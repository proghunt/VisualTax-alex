unit vtMulti;

(* find declarations
{procedure|function}[ /t]+{id}
*)

{.$DEFINE FixForms}//use fixed size?

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, ComCtrls, ExtCtrls, Contnrs,
  Menus, DB, stdCtrls, //20160114 Igor
  System.StrUtils, //20171018 Igor
  vtForm, vtChild, vtFileStorage
, uADCompClient, VKDBFDataSet, // 20150916 Igor
  Generics.Collections, //20170112 Igor
  System.Rtti, System.TypInfo, //20170112 Igor
  vtLockManager, //20170307 Igor
  System.RegularExpressions,vtDBF_SQLite,//20170927 Igor
  vtKeyList, //20171017 Igor
  IniFiles, //20190917 Igor
  RxRichEd; //20160819 Igor (It must be the last)

const //update every year/release
  AppRelease = '2.0.0'; //20150607 //'1.14.2';
  AppUpdateDate = '2017/09/25'; //20170925
  cLicenseDenied = 'Your license does not allow you to work with this form.';//20171017 Igor

//20161212 Igor >>>
  //ExeYear = '2015-2016'; //20150607 EXEYear in VtMulti //'2012-13'; //should be what???
type
  TInternalExeYear = (iey2015, iey2016, iey2017, iey2018, iey2019, iey2020, iey2021);  //con 20211216
//20171031 Igor>>>
const
  TInternalExeYearName: array [TInternalExeYear] of PWideChar = ('TVisualTax2015', 'TVisualTax2016', 'TVisualTax2017', 'TVisualTax2018', 'TVisualTax2019', 'TVisualTax2020'); //20171031 Igor
//20171031 Igor<<<
var
  InternalExeYear: TInternalExeYear = iey2015;
  function ExeYear: String;
  function MainHelpFile: String; //20161220 Igor
  function MainHelpUpdFile: String; //20161220 Igor
  function ProjectYear: Integer; //20190306 Igor
//20161212 Igor <<<

  //20190917 Igor >>>
  function GetDateUpdateFromIni(AIniFile: string): string;
  //function GetFullDateUpdate: string; //20191007 Igor
  function GetUtilitiesDateUpdate: string;
  //20190917 Igor <<<

const
  MaxRecentReturns = 50;
  AppRecentFiles = True; //False: file in ExeDir, True in AppDir
  //app data files
    //ActivationFile = 'LVerf.EX_'; //20120128
  LicenseFile = 'LVerf.EX_'; //renamed for finding old references
  InstallFile = 'AppsIncluded.d';
  //form properties
  FieldsListD = 'FieldsList1.d'; //was: T1Prop.d ...
  LblSectD = 'LblSect.d'; //no more used
  SinLabelsD = 'SinLabels.Txt'; //not .d
  YesNoLabelsD = 'YesNoLabels.Txt';
  CheckCompD = 'CheckComp.txt';
  NoCompareD = 'NoCompare.d'; //20160320 Igor
  //ScanActivationFile='LverfSc.ex_';
  LoginNames = 'LoginNames';
  DeveloperPwd = 'DODI1'; // 'RONCON';
//20160114 Igor
  GC_MINSCALE: Integer = 50;
  GC_MAXSCALE: Integer = 200;
  GC_SQLLitePasswordVersion = Integer(4); //20160303 Igor //20161208 Igor //20161215 Igor
  heplPage = 'www.visualtax.com/updhlp/'; //20160801 Igor
//  MainHelpUpdFile = heplPage + 'vtupdhlp.htm'; //20160601 Igor //20160801 Igor //20161220 Igor
//  MainHelpFile = 'VtHelp.chm';  //20160601 Igor //20161220 Igor
  RedesignFile = 'www.visualtax.com/vtredesign/vtredesign.html'; //20160705 Igor //20160719 Igor
  vtAlerthtml = 'www.visualtax.com/vtAlert.html'; //20160819 Igor   //20190104
var
  ExeDir: string;
  //20190213 Igor >>>
  CloudDir: string; //20180503 Igor
  CloudDataDir: string;
  //20190213 Igor <<<

//20170927 Igor>>>
type
  TStartParams = class // 20180917 Igor
  private
    FisCloud: Boolean;
    FIsDemo: Boolean;
    FIsAdmin: Boolean; // 20190501 Igor
    FCloudKey: string; //20190523 Igor
  public
    StartKeys: TDictionary<String, String>; // 20180917 Igor
    constructor Create(AStartKey: String);
    destructor Destroy; // 20180917 Igor
    property isCloud: Boolean read FisCloud;
    property IsDemo: Boolean read FIsDemo;
    property IsAdmin: Boolean read FIsAdmin write FIsAdmin; //20190501 Igor
    property CloudKey: string read FCloudKey write FCloudKey; //20190523 Igor
  end;
var
  StartParams: TStartParams;
const
  c_NotAvailable = 'Not available in the browser version!';

//20170927 Igor<<<

type

  //should reside in vtMain, but circular unit references
  eGuiCommand = (
    gcHideFlash, //debug flash screen
    //for T2
    gcAuditOpenBtnClick, //(Sender: TObject);
    gcReduceTutorialHeight, //(Sender: TObject);
    //gcFileNewItemClick, //(Sender: TObject);
    gcFormPaint, //(Sender: TObject);
    gcRecalcBtnClick, //(Sender: TObject);
    //gcTileVertical1Click, //(Sender: TObject);
    //gcTileHorizontally1Click, //: TNotifyEvent; //(Sender: TObject);
    gcRefreshAuditPanel, //(RetNo:Integer);
    gcRefreshFormsPanel, //: TMainProcInt;  // (RetNo:Integer);
    gcSuperVerification, //calls back TApp.SuperVerification
    //splash screen - to be removed
      //gcShowMostRecentReturns,  //: ShowMostRecentReturns;
    //more abstract
    gcReturns, //RetList changed
    gcLicenseCheck, //apply license list
    gcShowLeftPanel, //LeftPanel.Visible := True
    gcHideLeftPanel, //LeftPanel.Visible := False //20160220 Igor
    gcToggleLeftPanel, //AuditOpenBtnClick (toggles!)
    gcExit, //: FileExit1Execute(nil);
    //gcCloseReturn,  //:  FileCloseItemClick(nil);
    //gcSaveAs, //:       FileSaveAsItemClick(nil);
    gcSaveAll, //:      SaveAllOpenedReturnsClick(nil);
    gcColorChanged, //update panels with tax color
    gcRetNoChanged, //show splash screen or update all panels
    gcAppIdChanged, //from splash screen
    gcChildClose, //ChildWin closed - immediate action required?
    gcMDIArrange, //:   MDIArrange;
    gcTutorials, //Tutorials1Click - fill tutorials listbox
    gcActiveFormChange, //20160305 Igor
    gcStartCloseReturn, //20160311 Igor
    gcDoneCloseReturn,   //20160311 Igor
    gcShowLastYear, //20160311 Igor
    gcHideLastYear,  //20160311 Igor
    gcUpdateLastYearIfOpenned, //20160615 Igor
    gcScroll, //20160312 Igor
    gcAvailableWidth, //20160406 Igor
    gcShowPriorYearList, //20160519 Igor
    gcSetReturnsHeaderPanelNormalState, //20160805 Igor
    gcShowAllControls, //20170518 Igor
    gcShowSideBySidePanel, //20170719 Igor
    gcChangeSkin,//20170824 Igor
    gcShowDiagnostics,//20171215 Igor
    gcNoScroll //20190115 Igor
    );


  //MDI arrange modes
  TArrangeMode = (//if not side-by-side
    amCascade,
    amTile, //default: tile vertically
    amTileHorz,
    amMaximize
    );

  eAppIdx = (aiNone, aiT1, aiT2, aiTF, aiFP, aiT4, aiSL, aiT4T5, aiT3); //20170731 Igor

  //error types for saving returns

  TOpenMode = (omHidden, // no form activate, no return in list on the left panel,
               omBackground, //no form activate, only return in list on the left panel
               omActivate, //Form activate and return in list on left the panel
               omOnRightPanel); //show form on right panel, no return in list on the left panel
  //20171228 Igor>>>
  TRightTabSheet = (rtsReview, rtsPrevYear, rtsClientDocument, rtsAutoFill);
  TRightTabSheets = Set of TRightTabSheet;
  //20171228 Igor<<<
{$IFDEF new}
  eWriteResult = (
    wrDone, //no errors
    //msg already shown
    wrSkipped, //user denied override
    wrCancel, //user stops saving
    //show message
    wrMsg, //show message
    wrMandatory //mandatory information missing or wrong
    );

  EWriteReturn = class(Exception)
  public
    code: eWriteResult;
    constructor Create(ACode: eWriteResult; const AMsg: string);
  end;
{$ELSE}
  eWriteResult = integer;
const
  wrDone = 0;
{$ENDIF}

type
  TMyStringList = class(TStringList)
  protected
    procedure SetCapacity(NewCapacity: Integer); override;
    procedure SetCount(const Value: integer);
  public
    property Capacity: integer read GetCapacity write SetCapacity;
    property Count: integer read GetCount write SetCount;
  end;

  TOwningStringList = class(TStringList)
  public
    destructor Destroy; override;
    procedure Delete(Index: Integer); override;
  end;

  TSingleStringList = class(TStringList)
  public
    procedure Clear; override;
    procedure Free; reintroduce; //deny destruction
  end;

  TSingleList = class(TList)
  public
    procedure Free; reintroduce; //deny destruction
  end;

  PObject = ^TObject;
//20170515 Igor >>>
//  TSingleStringLists = class(TList)
//  public
//    //destructor Destroy; override; - calls Clear
//    procedure AddSingle(AVar: PObject; AClass: TClass);
//    procedure Clear; override;
//  end;
//var //all global stringlists
//  StringLists: TSingleStringLists;
//20170515 Igor <<<
type
  eLicenseLevel = (
    llNone, //not licensed
    llDemo,
    llHome, //~NetFile
    llLimited,
    llLimEfile,
    llStd,
    llPower,
    llMulti,
    //T2 only
    llMultiPower,
    //FP only
    llAgStd, llAgPower, llDealer //llEnterprise?
    , llLimited1Returns, llLimited2Returns, llLimited3Returns, llLimited4Returns, llLimited5Returns, //20170502 Igor  //20170627
    llLimited6Returns, // 20180830 Igor
    llLimitedForms //20171012 Igor
    );
  sLicenseLevel = set of eLicenseLevel;
const
  llNetFile = llHome;
  anyLimited: sLicenseLevel = [llLimited, llLimEFile,
    llLimited1Returns, llLimited2Returns, llLimited3Returns, llLimited4Returns, llLimited5Returns, //20170802 Igor
    llLimited6Returns]; // 20180830 Igor
  anyMulti: sLicenseLevel = [llMulti, llMultiPower];
  //anyPower = [llPower, llAgPower]; //???
type
  eLicenseCapabilities = (
    //required by the IDE
    lcLimited, //limited version --> not lcMultiData, limited returns
    lcMultiData, //multiple Data directories
    lcMultiDrive, //more than ABCD: ?
    lcSuperAudit, //= lcSuperVerification?
    lcEFile, //EFile, applies not to Limited, but Limited EFile
    //others
    lcLetter //client letters (Demo, Power, Multi)
    );
  sLicenseCapabilities = set of eLicenseCapabilities;

  RPgmLicenseData = record
  //20170502 igor >>>
  private
    function GetLimitReturns: Integer;
  public
  //20170502 Igor <<<
    Name, Id: string;
    Factor: byte; //Factor2 provided by ???
    Level: eLicenseLevel;
    Caps: sLicenseCapabilities;
    Caption: string; //Caption defaults to Name if empty
    property LimitReturns: Integer read GetLimitReturns; //20170502 Igor
  end;
  PPgmLicenseData = ^RPgmLicenseData;

  TLicenseList = class(TStringList)
  private
    FChanged: Boolean;//20170927 igor
    FLicenseFile: string; //20180503 Igor
    procedure SetPassword(const Value: string);
    function GetPassword: string;
    function GetKeys(const AppId: string): string;
    procedure SetKeys(const AppId, Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromFile(const FileName: string); override;
    procedure SaveToFile(const FileName: string); override;
    //20180503 Igor >>>
    procedure Save;
    procedure Load;
    //20180503 Igor <<<
    property Password: string read GetPassword write SetPassword;
    property Keys[const AppId: string]: string read GetKeys write SetKeys;
    property Changed: Boolean read FChanged; //20190307 Igor
    //hide list details
  end;
var
  LicenseList: TLicenseList;

type //20110129 //fees for all forms
  //AFeesRec       = Record
  AFeesRec = class
  public
    FormNo: integer; // Word;
    FormName, //: string[12];
    FormAbrev, //: String[22];
    Fee, //: String[7];
    HowCharged, //: String[20];
    AddnlForm, //: String[7];
    Each_Item: string; // String[7];
  end;
  PFeesList = AFeesRec;

  TFeesList = class(TObjectList)
  private
    function GetFeesRec(index: integer): PFeesList;
  public
    property FeesRec[index: integer]: PFeesList read GetFeesRec; default;
  end;


//20170112 Igor >>>
(*
type
  //applies to T1 only???
  AUserProfile = object // Record   //keep track of user who runs the program
  private
    Name: string;
  public
    M_Office,
      Branch,
      Prep_Intls,
      Login_Id,
      Pswd,
      Auth_Level,
      Prep_Name,
      Tax_dir,
      DBFData_dir, //20160226 Igor
      EFile_dir,
      BR_dir,
      CODE: string;
    Inv_No: integer;
    CrProfile: Boolean;
    CrReturn: boolean;
    PrReturn: Boolean;
    PrReport: boolean;
    PrInvoice: Boolean;
    MkAppoint: boolean;
    CrRTU: boolean;
    EFile: boolean;
    MkPay: boolean;
    Upload: Boolean;
    function GetUserProfile(const UserName: string): boolean;
    function GetAdminPassword(const UserName: string): string;
    function GetNextInvoiceNo(const UserName: string): integer;
  end;
var
  User: AUserProfile; //used in fLogon!!!
*)
//20170112 Igor <<<
type
  TColorTable = array[0..11] of TColor;

//20170726 Igor>>>
type
  TVTElement = record
    FormName: String;
    BoxNo: String;//20170729 Igor
    ElementNo: Integer;
    RowStep: Integer;
    HardValue: String;
    constructor Create(const AFormName, ABoxNo: String; const AElementNo: Integer;
      const ARowStep: Integer = 1; const AHardValue: String = '');//20170729 Igor
    procedure GetRealTarget(const AInstanse, ARowNo: Integer;
      out AFormName: String; out AElementNo: Integer;
      var AValue: String);
  end;

  TVTMapElement = TArray<TVTElement>;
//20170726 Igor<<<

function NextAvailColor(const ColorTable: TColorTable): TColor;
function IsColorInUse(clr: Tcolor): boolean;
function ReColorReturn(RetNo: integer; clr: TColor): boolean;

(* Dynamic Data
Production version:
  FieldId = AA0000 + Row*MaxCol + Col, first Col of first Row = 1
  Data stored as packed array.
MultiApp version?
  FieldId = AARRCC
  Data stored as Array[MaxRow].StringList[MaxCol]
*)
const
  ArrayMul = 10000; //ElmNo = ArrayNo*ArrayMul+index
  ArrayBase = 1; //Dyn[ArrayBase] for 10001
  ElmBase = 1; //Dyn[ArrayBase,ElmBase] for 10001

type
  TFRec = class;
  TDynArray = array of string;
  TDynamicData = array of TDynArray;
  TDynamicDataOverload = TDictionary<Integer,TObject>; //20170609 Igor

  TApp = class;

  //audit modes, for AuditPanel
  eAuditMode = (
    amStd, //RefreshAuditPanel
    amSuperAudit, //SuperAuditBoxClick
    amSuperVericifcation); //SuperVerificationBtnClick - T1 only?

  TAuditRec = class
  public
    Category: char; //String[01];
    Description: string;
    Form: string;
    Elm: Integer;
    constructor Create(Cat: char; Descr, FName: string; ElmNo: integer);
    function Message: string;
  end;
  PAuditRec = TAuditRec;

  TAuditList = class(TObjectList)
  private
    function GetAuditRec(index: integer): TAuditRec;
  public
    Changed: boolean;
    RetNo: integer;
    constructor Create(RNo: integer);
    procedure BeginUpdate;
    procedure EndUpdate;
    function HasCategory(Category: char): boolean;
    function GetHint(FName: string; Fld: integer): TAuditRec;
    property AuditRec[index: integer]: TAuditRec read GetAuditRec; default;
  end;

  (* New FList model:
    TFRec contains all fields of all AppIds.
    Virtual LoadFromTable method only loads common values, must be overridden
      for values not present in specific AppIds.
    Clone method creates a copy for AddPageInstance.
    A FormInstName:string is added, holding the full FormName+FormInst. This
      results in less string copies at runtime.
    AffectedList could be added, used to calculate affected forms.

  DynData description???

    TFList is a sorted StringList, containing all instanced and non-instanced FormNames.
    On normal iteration all dummy entries (Form for Form#1) return a dummy form,
    so that all indices (0..Count-1) are valid.
    Possible speedup: override Find for string equality instead of AnsiStringCompare

    Searching for all instances of a form can start from the index of Form#1,
    and proceed until a different FormName is reached.

    An ByFNo array/list contains the form descriptors, directly indexed by FormNo.

    TFList contains the FormsLimit and FieldsLimit, for the list initialization
    and fixing of FormFields.
  *)
  TCalcRtn = procedure(RetNo: integer; FName: string; FNo: integer);

  TFRec = class
  protected //unused?
  public
    FormNo: integer;
    FormName, //     : string[20];
    FormInstName: string; //FormName+FormInst
    FormInst, //     : string[3];   {#nn}
    FormMxInst, //   : string[3];
    FormDescr, //    : string[65];
    FormAbrev, //    : String[45];
    FormRlNm, //     : String[9];
    FormType: string; //     : String[2];
    FormFields: Word; {integer;}
    FormHeight: Word;
    FormMxPg: Word; {integer;}
    CursorPos: Word;
    FormShow: Boolean;
    DelphiForm, //   : String[1];
    IsSlip: Boolean;
    Modal, //        : String[1];
    Preload: Boolean;
    WhiteBoxes: Boolean;
    AddBlankPg: boolean;
    ShowFlag: Boolean;
    ShowHdr: Boolean;
    PrnSeq: string; //really string
    DataIndic: string; //list of fieldNo
    //Fees are Real values
    Fee, //          : String[10];
    FeeAddItem: string; //   : String[10];
    HowCharged,
      AddnlForm, //real/string
    Each_Item: string;
    AddInT1C,
      Landscape: boolean; //    : String[1];
    //T2 added
    PdfFile,
      RSIName: string;
    MultiPage: boolean;

    //shortcut to first instance
    FirstInstFNo: integer;
    InstNo: integer;
    DollarFields: array of integer;
    DollarArray: array of boolean; //[FormNo]
    MaxMemo: integer;
    { TODO : add AffectedList? }
      //procedure LoadFromTable(Table1: TADTable); virtual; abstract;
    Calc: TCalcRtn; //speedup calculation of this form
    BoxesPerRow: array of integer; // byte; //[ArrNo]
    Allowed: boolean; //20171017 Igor
    constructor Create;//20171017 Igor

    function Clone: TFRec;
  end;
  TFRecClass = class of TFRec;

  TFRecArray = array of TFRec; //20170118 Igor

  TFList = class(TStringList)
  private
    ByFNo: array of TFRec;
    Destroying: boolean; //make Clear destroy the lists
    FisLastYearList: Boolean; //20160321 Igor
    FSortedList: TStringList; //20170324 Igor
    //20170927 igor>>>
    FAffectedForms: TDictionary<String, TArray<String>>;
    FAffectedFormsIsInit: Boolean;
    //20170927 igor<<<
    function GetApproachedLimit: Boolean;
    //20170927 igor>>>
    function GetAffectedForms(AFormName: String): TArray<string>;
    function InitAffectedForms: Boolean;
    //20170927 igor<<<
  protected
    function InitStorage: Boolean; virtual; abstract;//20170927 igor
    function LoadFromTable(Table1: TDataSet): TFRec; virtual; abstract;//20150918 Igor
    procedure Changed; override; //20170324 Igor
  public
    MyApp: TApp;
    FormsLimit: integer;
{$IFDEF fixForms}
    FFieldsLimit: integer;
    property FieldsLimit: integer read FFieldsLimit;
{$ELSE}
    FieldsLimit: integer;
{$ENDIF}
    //AffectedList: TStringList; //loaded from AppDir\Affected.d//20170927 igor
    //could add the lines to the TFRec's, too?
//DynData? descriptors in FRec?
    constructor Create(AApp: TApp; MaxForms, MaxFields: integer; AFormsDBLite, AFormsTableLite: String; AAppPath: String = '');//20150119 Igor //20160314 Igor
    destructor Destroy; override;
    procedure Clear; override;

    function InitFormsTable(Dir, lFileName, lTableName: string): boolean;//20150918 Igor

    function AddRec(r: TFRec): integer; //return FNo
    function AddPageInstance(RetNo: integer; NonInstFormName, FormInst: string): integer;
    //items
    function ByFormNoDummy(FNo: integer): TFRec;
    function ByFormNoNil(FNo: integer): TFRec;
    function ByFormName(FName: string): TFrec;
    function ByIndex(i: integer): TFRec;
    function FirstInstNo(NonInstFormName: string): integer;
    function LastInstNo(NonInstFormName: string): integer;
    function FirstInstRec(NonInstFormName: string): TFRec; overload;
    function FirstInstRec(FNo: integer): TFRec; overload;
    property Items[i: integer]: TFRec read ByIndex;
    //standard functions
    procedure CalcAffectedBy(RetNo: integer; FName: string);
    function GetFormName(FNo: integer): string;
    function GetFormNo(FName: string; Check: boolean = True): integer;
    function GetFormNumberFields(FNo: integer): integer;
    function IsDollarField(FNo, Elm: integer): boolean; overload;
    function IsDollarField(FName: string; Elm: integer): boolean; overload;
    function GetAllInstForms(ANotInstFormName: String; ARetNo: integer = 0): TFRecArray; //20170118 Igor //20180110 Igor
    property isLastYearList: Boolean read FisLastYearList write FisLastYearList; //20160321 Igor
    property ApproachedLimit: Boolean read GetApproachedLimit; //20160617 Igor
  end;

  (* All data related to a form.
    Added virtual methods for handling dynamic fields.
  *)
  TFormData = class(TStringList)
  private
    FFRec: TFRec; //fast lookup - add FormInstNo? //20160319 Igor
    FDisableSaveOverrideCount: Integer; //20170609 Igor
  protected
    //override methods to handle dynamic fields
    function Get(Index: Integer): string; override;
    procedure Put(Index: Integer; const S: string); override;
  public //become read-only properties?
    RetNo, FormNo: integer;

    //HasData,
    //FrmScaled: boolean;
    //Memos: TStringList; //[InstNo] of TObjectList[MemoNo] of TStringList[jj]
    Memos: array of string;
    //DynData: TDynamicData; //[ArrNo] of TObjectList[RowNo] of TStringList[ColNo]
    Dyn: TDynamicData; //[ArrNo] of TObjectList[RowNo] of TStringList[ColNo]
    DynOverload: TDynamicDataOverload; //20170609 Igor
    procedure DeleteRowData(id: integer);
    procedure AddRowData(id: integer);
    procedure SwapRow(const ATableID, ARow1, ARow2: Integer); //20170407 Igor
    procedure InsertBeforeRowData(const ATableID, ARow: Integer); //20170407 Igor
    procedure MoveRow(const ATableID, ARow1, ARow2: Integer); //20170411 Igor
    function MaxDynamicElm(FieldId: integer): integer;
    function MaxRow(ArrNo: integer): integer;
    function SplitId(ElmNo: integer; fExtend: boolean; ChangeSize: Boolean): boolean; //20160212 Igor
    procedure SetFRec(Value: TFRec); //20160319 Igor
    function GetFRec: TFRec; //20160319 Igor
    //20170609 igor >>>
    procedure SwapDynamicOverride(ATableID, ARow1, ARow2: Integer);
    procedure DeleteDynamicOverride(ATableID, ARow: Integer);
    procedure MoveDynamicOverride(ATableID, ARow1, ARow2: Integer);
    procedure ShiftUpDynamicOverride(ATableID, ARow: Integer);
    procedure ShiftDownDynamicOverride(ATableID, ARow: Integer);
    procedure TurnOffOnOverride(AElementOff, AElementOn: Integer);
    procedure ReassignFRec(Value: TFRec); //20180113 Igor
    //20170609 igor <<<
  public
    constructor Create(RNo, FNo: integer);
//{$IFDEF debug}//20170609 Igor
    destructor Destroy; override;
//{$ELSE} //20170609 Igor
//NOP, debug only
//{$ENDIF}//20170609 Igor
    procedure ClrForm; //virtual; //also clear memos...
{$IFDEF old}
    procedure PopulateWithData(ACtrl: TWinControl); //virtual; ?
{$ELSE}
{$ENDIF}
    property Elms[ElmNo: integer]: string read Get write Put; default;
    property FormDataRec: TFRec read GetFRec write SetFRec; //20160319 Igor
    //20170609 Igor >>>
    procedure DisableSaveOverride;
    procedure EnableSaveOverride;
    //20170609 Igor >>>
  end;

//20161229 Igor >>>
  TExportElement = record
    ElemNo: Integer;
    Description: String;
  end;

  TExportElements = array of TExportElement;

  TExportForm = Record
    FormName: String;
    ExportElements: TExportElements;
  End;

  TExportForms = Array of TExportForm;
//20161229 Igor <<<
  TRetData = class
  protected
{$IFDEF dumbIDE}
  private
{$ELSE}
{$ENDIF}
    FRetNo: integer;
    FMyApp: TApp;
    FMyChild: TMyChild;
    FIsLastYearReturn: boolean;
//20170512 Igor >>>
//    StringLists: TSingleStringLists;
//20170512 Igor <<<
    FDestroying: boolean;
    FRetColor: TColor;
    FIsTaxPlan: boolean;
    FLocked: boolean;
    FCalcStatus: boolean;
    FFList: TFList;
    FLastYearRetNo: Integer; //20160302 Igor
    FisAppendix: Boolean; //20160302 Igor
    FChanged: boolean;
    FLockManager: TLockManager; //20170307 Igor
    FSourceForRollOver: Boolean; //20170904 Igor
    FLn: TDictionary<integer, real>; //20190627 Igor
    procedure SetChanged(Value: boolean);
    procedure SetMyApp(const Value: TApp);
    function GetMyChild: TMyChild;
    procedure SetMyChild(const Value: TMyChild);
    procedure SetRetNo(const Value: integer);
    procedure SetRetColor(const Value: TColor); virtual;
    function GetAuditRec(index: integer): PAuditRec;
    procedure SetIsTaxPlan(const Value: boolean);
    procedure SetLocked(const Value: boolean); virtual;
    function GetLocked: boolean; virtual;
    procedure OVR(const MethName: string);
    function GetHasData(FName: string): boolean;
    procedure SetHasData(FName: string; const Value: boolean);
    function GetFormByName(FName: string): TFormData;
    //for use in constructor only!
      //procedure InitFormData(FNo: integer);
    function InitFormData(AFRec: TFRec): boolean; virtual;
    procedure SetFList(const Value: TFList);
    procedure SetLockManager(const Value: TLockManager); //20170307 Igor
    function GetReadOnly: Boolean; //20170307 Igor
    //20190627 Igor >>>
    function GetLn(AIndex: integer): real;
    procedure SetLn(AIndex: integer; const Value: real);
    //20190627 Igor <<<
  public
    property Changed: boolean read fChanged write SetChanged;
    property Locked: boolean read GetLocked write SetLocked;
    property ReadOnly: Boolean read GetReadOnly; //20170307 Igor
    property IsTaxPlan: boolean read FIsTaxPlan write SetIsTaxPlan;
    property FList: TFList read FFList write SetFList; //for T1 LastYear returns
  public
    Province: string;
    //Audit
    AuditList: TAuditList;
    ErrorCount,
      MandatoryErrorCount,
      SeriousErrorCount,
      EFileErrorCount,
      TapeErrorCount,
      NoteErrorCount: integer;

    Frm: array of TFormData; //[FormNo]
    Ln: array {[LnLowBound..LnHighBound]} of real; //20190627 Igor
    FrmHasData: array of boolean;
    Notes, //       : string;  //[80];
    PrpStatus, //   : string; //[2];
    SourceDataDir, // : String[80]; //string[70];  {dir it came from}  //20120201
    SourceFlName: string; // : string[12];  {file name it came from via readreturn}

    property Form[FName: string]: TFormData read GetFormByName;
    property FormHasData[FName: string]: boolean read GetHasData write SetHasData;
    property RetColor: TColor read FRetColor; // write SetRetColor;
    property Lnn[AIndex: integer]: real read GetLn write SetLn; //20190627 Igor
    procedure RestoreRetColor(clr: TColor); //from loaded return
    procedure ReadData(fs: TFileStorage; AFRec: TFRec);
    procedure WriteFData(AFRec: TFRec;
      ASQLite: TSQLiteStorage); //20160414 Igor
    procedure WriteLnEtc(LnLowBound, LnHighBound: integer;
      ASQLite: TSQLiteStorage = nil); //20160415 Igor
    procedure AssignLn(ASource: TDictionary<integer, real>); //20190627 Igor
  protected //confuses compiler when public
    function FetchElmFNo(FNo, ElmNo: integer): string; virtual;
    function GetLastYearRetNo: Integer;  //20160302 Igor
    procedure SetLastYearRetNo(Value: Integer);  //20160302 Igor
    function GetisCreateMDIChild: Boolean; virtual; //20161028 Igor
  public
    constructor Create(TheApp: TApp); virtual;
    destructor Destroy; override;
    //procedure ClrForm(FName: string); virtual;
    function ClrForm(FName: string): boolean; virtual;
    procedure CloneForm(FromFormName: string; ToRetNo: integer; ToFormName: string; fAll: boolean); virtual;
    procedure CloneReturn(ToRetNo: integer); virtual;
    procedure SaveElmFromFile(FNo, ElmNo: integer; value: string);
    procedure SaveMemoFromFile(FNo, ElmNo: integer; value: string);
    function Close(fRemove: boolean): boolean; virtual; abstract;
    procedure BeforeDestruction; override;
    property MyApp: TApp read FMyApp;
    property MyChild: TMyChild read GetMyChild write SetMyChild;
    property RetNo: integer read FRetNo; // write SetRetNo;
    property IsLastYearReturn: boolean read FIsLastYearReturn write FIsLastYearReturn;
    property LastYearRetNo: Integer Read GetLastYearRetNo Write SetLastYearRetNo; //20160302 Igor
    procedure Free; reintroduce; //prevent use of Free
    property Destroying: boolean read FDestroying;
    property isAppendix: Boolean Read FIsAppendix write FIsAppendix; //20160305 Igor
    property isCreateMDIChild: Boolean Read GetisCreateMDIChild; //20161028 Igor
    property LockManager: TLockManager read FLockManager write SetLockManager; //20170307 Igor
    property SourceForRollOver: Boolean read FSourceForRollOver write FSourceForRollOver;//20170904 Igor
  public //forms
    function AddPageInstance(NonInstFormName, FormInst: string): integer; virtual;
    function GetDfmFileName(const FormName: string): string; virtual; abstract;
    function GetFormNo(const FormName: string): Integer; virtual; //abstract;
    function GetFormName(FormNo: integer): string; virtual; //abstract;
    function GetFormNumberFields(FormNo: integer): integer; //virtual; abstract;
    function GetFormCursorPos(FrmNm: string): Integer;
    procedure GetFrmTree(TreeView: TTreeView; fUsedForms: boolean = False); virtual; abstract;
    function GetFrmTreeFNo(SourceNode: TTreeNode; fUsedForms: boolean): integer; virtual; abstract;
    function NewChild: TMyChild; virtual; abstract;
    function BeforeOpenForm(var FormName: string; var FormNo: integer): string; virtual; abstract;
    function SubstituteForm(AFormName: String): String; Virtual; //20161101 Igor
    function FormClass: TvtFormClass; virtual; abstract; //20161102 Igor
    function PrintTitle(AForm: TFrec): String; virtual; //20161102 Igor
    function IsLetterForm(AFormName: String): Boolean; virtual; abstract; //20161104 Igor
    //map FormName, return DfmFileName
{$IFDEF unused}
    procedure Print(FName: string; pgNo: integer = -1); //virtual;
{$ELSE}
{$ENDIF}
    //procedure PopulateWithData();
  public //utils
    function GetReturnCaption: string; virtual; abstract;
    function GetReturnName: string; virtual; abstract; //for printing
    function DoSave: boolean; virtual; abstract; //part of SaveAllReturns
    procedure DoSaveAs; virtual; abstract; //using SaveAs dialog
    function GetDefaultFileName: String; virtual; abstract; //20160305 Igor
    function GetCloudFileName: String; virtual; //20190312 Igor
    function GetLastYearFile: String; Virtual; abstract; //20160701 Igor
    procedure SetLastYearFile(const AValue: String); Virtual; abstract; //20160701 Igor
    procedure ExportToFile(const ExportForms: TExportForms;
      AFileName: String = ''); //20161229 Igor //20170112 Igor
    function GenerateDefaultFileNameForExport: String; virtual; abstract; //20170110 Igor
  public //calculations
    procedure Calc(Dummy: integer; const FName: string; FNo: integer = -1); virtual; abstract;
    procedure CalcAll; virtual; abstract;
    procedure CalcFullReturn; virtual;
    procedure ReCalcEveryThing; virtual;
    procedure SetCalcStatus(const Value: boolean); virtual;
    property CalcStatus: boolean read FCalcStatus write SetCalcStatus;
    procedure ClearDiagnostics;
    procedure CountDiagnostics; virtual; abstract;
    function IsSignedOff(ErrMsg: string): boolean;
    procedure LoadTV(RetNo: integer; FName: string; FNo: integer);
    procedure SaveTV(RetNo: integer; FName: string; FNo: integer);
    function InitDataDirectory: Boolean; virtual;
  public //special values
    function GetFirstName: string; virtual;
    function GetLastName: string; virtual;
    function GetSIN: string; virtual;//20170328 Igor
    function GetDCN: string; virtual; //20170328 Igor
    function GetInterpetedRichEdit(LetterName: string; ARichEdit: TRichEdit): boolean; virtual;
    function GetDirClientDocs: String; virtual;//20170714 Igor
    function GetTDDFileName: String; virtual; //20170720 Igor
  public //visual feedback
    procedure AddAudit(ACategory: char; AMsg, AForm: string; AField: integer);
    property AuditRec[index: integer]: PAuditRec read GetAuditRec;
    procedure AuditRecsToTreeView(TreeView: TTreeView; const Categories: string);
    function RefreshAuditPanel(ReturnsHeaderPanel: TPanel; ErrorView: TTreeView; AuditMode: eAuditMode): string; virtual; abstract;
    procedure OpenAuditOrigin({ErrorView: TTreeView;}SourceNode: TTreeNode); virtual;
    //see AuditListDblClick, ErrorViewClick
{$IFDEF old}
    function DoSignOffAWarning(msg: string): boolean; virtual;
{$ELSE}
{$ENDIF}
    procedure StartPrintForm(FormName: string; WhichPage: integer); virtual; abstract;
    function GetFrm(Index: Integer): TFormData;
  end;
  RetPtr = TRetData; //or app specific?
  TRetDataClass = class of TRetData; //allow for common cast

  TRetList = class(TObjectList)
  private
    function GetRet(RetNo: integer): TRetData;
  protected
    function AddRet(ARet: RetPtr): integer;
  public
    constructor Create;
    procedure Clear; override;

    procedure GetListOfLoadedReturns(SomeList: TStrings; AApp: TApp; AWithOutAppendix: Boolean = False); //20161216 Igor //20170307 Igor
    function MustSave: boolean;
    procedure RemoveReturn(RetNo: integer);
    //property Returns[RetNo: integer]: TRetData read GetRet; default;
    property Items[RetNo: integer]: TRetData read GetRet; default;
    function TypedReturn(RetNo: integer; AClass: TRetDataClass; fWarn: boolean = True): TRetData;
  end;

  eEmailResult = (
    erFail, //not sent
    erSucc, //was sent
    erOpenIt //open and EmailTheReturnClick
    );

  TOptRec = class(TPersistent) // add TPersistent 20151116 Igor
  private
    function GetFormZoom: integer;
    procedure SetFormZoom(const Value: integer); //ignore!
    function GetRightZoom: integer; //20160209 Igor
  public //all options used by MainForm and dialogs
    ActiveBoxColor: TColor;
    DataInBold,
      NoTypeAhead,
      DecimalAssume: Boolean;
    UseProperName: Boolean;
    Dir_Cur: string;
    Dir_Deflt: string; //20170310 Igor
    Dir_DbfData: String; //20160226 Igor
    Dir_AutoFill: String; //20160505 Igor
    Dir_PermanentDocs: String;  //20150217 //20160505 Igor
    Dir_ClientDocs: string; //20170308 Igor
    Prp_EMail,
      Prp_BusNo,
      Prp_ContactFN,
      Prp_ContactLN,
      Prp_ContactPos,
      Prp_RepId,
      Prp_Name,
      Prp_Street,
      Prp_City,
      Prp_Prov,
      Prp_Postal,
      Prp_Countr,
      Prp_Area,
      Prp_OrgType,
      Prp_Tel,
      Prp_FxArea,
      Prp_Fax,
      Prp_DiscNo,
      Prp_DiscNm,
      Prp_GSTNo: string;
    Prp_Bill: string; //[1];
    Prp_VSFee: Integer;
    Prp_SFee: Integer;
    Prp_AFee: Integer;
    Prp_CFee: Integer;
    Prp_VCFee: Integer;
    Prp_GSTRat: string;
    Prp_Hour: Real;
    Prp_Elect: Boolean;
    Prp_EfRepr: Boolean;
    Prp_Dates: Boolean;
//    DropBox_ClientID: String;//20160614 Igor //20161208 Igor
    //shared options - immediate effects must be handled explicitly (MainForm)
    property FormZoom: integer read GetFormZoom; // write SetFormZoom;
    property RightZoom: integer read GetRightZoom; //20160209 Igor
  end;

  TDataDict = class
  public
    Is_Amount, //  : String[1]; - char? boolean?
    KeyWord,
      FormName: string;
    Field_No: Word;
  end;

  { TODO : make DataDictList a TStringList, for quick search by name? }
    //TDataDictList = class(TObjectList)
  TDataDictList = class(TOwningStringList)
  private
    FDirLoaded: String; //20170410 Igor
    function GetRec(index: integer): TDataDict;
  public
    procedure Load(AppDir: string);
    function GetKeyWAttributes(KeyW: string; var FName: string; var Elm: Integer; var IsAmount: string): boolean;
    property Items[index: integer]: TDataDict read GetRec;
    function InDataDict(KeyW: string): Boolean;
    function ValidateLetter(ARichEdit: tRichEdit): string;
  end;

  TAppList = class;

  TSQLitePassword = class(TObject)
  private
    FApp: TApp;
    /// <summary>get password for SQLite DB</summary>
    /// <param name="Version">version password. Currentversion = GC_SQLitePassword</param>
    /// <returns>return current password for owner app</returns>
    function GetPassword(Version: Integer): String;
    function GetCurrentPassword: String;
    function RFGetPassword(Version: Integer): String; //20160415 Igor
    function RFGetCurrentPassword: String; //20160415 Igor
  public
    constructor create(Owner: TApp);
    function PassArray: Variant; //20160415 Igor
    function PassRFArray: Variant; //20160415 Igor
    property Password[Version: Integer]: String read GetPassword;
    property CurrentPassword: String read GetCurrentPassword;
    property RFPassword[Version: Integer]: String read RFGetPassword; //20160415 Igor
    property RFCurrentPassword: String read RFGetCurrentPassword; //20160415 Igor
  end;

  TApp = class(TOptRec)
  protected //all fields are accessible to derived classes
{$IFDEF dumbCompletion}
  private
{$ELSE}
{$ENDIF}
    FLastYearApp: boolean;
    FLicCaps: sLicenseCapabilities;
    FScanLicenseLevel: eLicenseLevel;
    FFirstForm: string;
    FReviewStaticForm: TStringList; //20160220 Igor
    FReviewDynamicForm: TStringList; //20160220 Igor
    FLastActiveReviewTab: Integer; //20160220 Igor
    FSQLitePassword: TSQLitePassword; //20160303 Igor
    FLastYearPgmFolderError: String; //20160516 Igor
    FDisabled: Boolean; //20160526 Igor
    FNeedUpdate: Boolean; //20160526 Igor
    FLimitReturns: Integer; //20170502 Igor
    //FColorTable: PColor;
    property IsDummyApp: boolean read FLastYearApp;
    //meaning: not fully implemented!
    function GetScanAuthorizationKey: string;
    procedure SetScanLicenseLevel(const Value: eLicenseLevel);
    function GetAuthorizationKey: string;
    function GetAppDir: string; virtual;
    function GetAppTitle: string; virtual;
    procedure OVR(const MethName: string);
    function GetCountReviewStaticForm: Integer;  //20160220 Igor
    function GetCountReviewDynamicForm: Integer;  //20160220 Igor
    function GetReviewStaticFormName(Index: Integer): string; //20160220 Igor
    function GetReviewDynamicFormName(Index: Integer): string; //20160220 Igor
  protected //Prepare distribution
    function GetDfmFileName(const FormName: string): string; overload; virtual; abstract;   //20160302 Igor
    function GetDfmFileNameLY(const FormName: string): string; virtual; abstract;   //20160321 Igor
    function GetHelpFile: String; Virtual; abstract;
    function GetHelpUpdFile: String; Virtual; abstract;
    procedure CreateDefaultDataDirectories; Virtual; abstract;//20170803 Igor
    function CheckDateExpiration(AKey: String; AMessage: Boolean = False): Boolean; Virtual; //20170803 Igor
    function GetDemoDateExpiration(AKey: String = ''): TDateTime;//20170803 Igor
    //20170927 igor>>>
    function GenerateOneDayDemoKey: String;
    function Factor2: Byte; virtual; abstract;
    //20170927 igor<<<
    function GetRightTabSheets: TRightTabSheets; virtual;//20171228 Igor
  private
    FLimitedFormList: string; //20171018 Igor
    procedure SetDisabled(const Value: Boolean);
  protected
    FLicLevel: eLicenseLevel;
    FProductName: string;
//20170515 Igor >>>
//    StringLists: TSingleStringLists;
//20170515 Igor <<<
    //must override
    function GetAppName: string; virtual; abstract;
    function GetAppRelease: string; virtual; abstract;
    function GetAppUpdateDate: string; virtual; abstract;
    function GetAppYear: string; virtual; abstract;
    function GetSQLLitePassword(const Version: Integer = GC_SQLLitePasswordVersion): String; virtual; abstract; //20160226 Igor //20160303 Igor
    function GetSQLLiteRFPassword(const Version: Integer = GC_SQLLitePasswordVersion): String; virtual; abstract;//20160415 Igor
    function GetValidLastYearPgmFolder: Boolean; virtual; abstract; //20160302 Igor
    function GetValidLastYearDataFolder: Boolean; virtual; abstract; //20160302 Igor
    function GetLastYearDataFolder: String; virtual; abstract; //20160302 Igor
    function GetInitLastYear: Boolean; Virtual; //20160320 Igor
    function GetLimitedVersionDir: String; Virtual; abstract; //20160718 Igor
    function GetPswElm: Integer; virtual; //20161028 Igor
    function GetLimitReturns: Integer; Virtual;//20170901 Igor
    // 20180712 Igor >>>
    function GetEfilerNumber: string; virtual;
    function GetTaxationYear: string; virtual;
    function GetAdditionalInfo: string; virtual;
    // 20180712 Igor <<<
  public //properties
    AppId: string; //pp-yyyy
    //SQLLitePassword: string; //20151017 Igor //20160226 Igor
    ClientsDBLite: string;   //20151017 Igor
    AppIdx: eAppIdx;
    // 20160114 Igor
    procedure SetZoomCaption(AZoom: Integer); virtual; abstract;
    procedure AddReviewStaticForm(AFormName: String);   //20160220 Igor
    procedure AddReviewDynamicForm(AFormName: String);  //20160220 Igor
    procedure DelReviewDynamicForm(AFormName: String);  //20160220 Igor
    function GetLastYearFormNo(AFormName: String): Integer; Virtual; abstract; //20160302 Igor
    function GetSubstituteLastYearForm(AFormName: String): String; Virtual; abstract; //20160302 Igor
    procedure FrmTreeCustomNodeClick(ANode: TTreeNode); Virtual; //20160323
    procedure ReloadMainMenu; virtual; //20180113 igor
    property CountReviewStaticForm: Integer read GetCountReviewStaticForm;  //20160220 Igor
    property CountReviewDynamicForm: Integer read GetCountReviewDynamicForm;  //20160220 Igor
    property ReviewStaticFormName[Index: Integer]: String read GetReviewStaticFormName; //20160220 Igor
    property ReviewDynamicFormName[Index: Integer]: String read GetReviewDynamicFormName; //20160220 Igor
    property LastActiveReviewTab: Integer read FLastActiveReviewTab write FLastActiveReviewTab; //20160220 Igor
    property AppDir: string read GetAppDir;
    property AppName: string read GetAppName; //short name
    property AppTitle: string read GetAppTitle;
    property AppRelease: string read GetAppRelease;
    property AppUpdateDate: string read GetAppUpdateDate;
    property AppYear: string read GetAppYear;
    //property ColorTable: PColor read FColorTable;
    property FirstForm: string read FFirstForm;
//    property SQLLitePassword: String read GetSQLLitePassword; //20160226 Igor //20160303 Igor
    property SQLLitePassword: TSQLitePassword read FSQLitePassword; //20160303 Igor
    property ValidLastYearPgmFolder: Boolean read GetValidLastYearPgmFolder; //20160302 Igor
    property LastYearPgmFolderError: String read FLastYearPgmFolderError; //20160516 Igor
    property ValidLastYearDataFolder: Boolean read GetValidLastYearDataFolder; //20160302 Igor
    property LastYearDataFolder: String read GetLastYearDataFolder; //20160302 Igor
    property InitLastYear: Boolean read GetInitLastYear; //20160320 Igor
    function ConvertToLastYearName(AFileName: String): String; virtual; //20160424 Igor
    // 20180712 Igor >>>
    property EfilerNumber: string read GetEfilerNumber;
    property TaxationYear: string read GetTaxationYear;
    property AdditionalInfo: string read GetAdditionalInfo;
    // 20180712 Igor <<<
  public
    //DBForms      : string; //20150920 Igor
    lFormsDBLite   : string; //20150915 Igor
    lFormsTableLite: string; //20150915 Igor
    FList: TFList;
    constructor Create(AAppList: TAppList); virtual; //add param 20151116 Igor
    destructor Destroy; override;
    procedure AfterConstruction; override;
{$IFDEF old}
    function CreateForm(ParentForm: TWinControl; RNo, FNo: integer): TvtScrollBox;
{$ELSE}
{$ENDIF}
    procedure Activate;
    function GetMenu: TMainMenu; virtual; abstract;
    property Menu: TMainMenu read GetMenu;
    function GetToolBar: TControl; virtual; abstract;//20170824 Igor
    function GetSplash: TCustomControl; virtual; abstract;
    procedure SelectFeatures; virtual; abstract;
    function PrepareDistribution(ADir: String = ''): boolean; //virtual; //canceld?
  public //licenses
    LicenseRec: PPgmLicenseData;
    ScanId: string;
    procedure DeveloperLicense; //no override required
    procedure GetLicenseLevel;
    procedure GetScanLicenseLevel; //into ScanLicense
    property LicenseCaps: sLicenseCapabilities read FLicCaps; // write SetLicensed;
    property LicenseLevel: eLicenseLevel read FLicLevel;
    //name string in ProductName
    function Licenses: PPgmLicenseData; virtual; abstract;
    property ProductName: string read FProductName; // write SetProductName;
    property ScanLicenseLevel: eLicenseLevel read FScanLicenseLevel write SetScanLicenseLevel;
    property LimitedFormList: string read FLimitedFormList; //20171018 Igor
    procedure SetLicense(const Key: string); virtual;
    procedure SetLimitedFormList(const Key: string); virtual; //20171017 Igor
    function GetLicenseKey: String; virtual; //20160602 Igor
    function AskChangeLicenseLevel: boolean;
    function ValidateKey(AKey: string): boolean; virtual;
    function ValidateScanKey(AKey: string): boolean; virtual;
    property LimitReturns: Integer read GetLimitReturns; //20170901 Igor
    function ExceedsMaxReturnsAllowed(ABeforeCreateNew: Boolean): Boolean; Virtual;//20170901 Igor
    function CountReturnsInDB: Integer;//20170901 Igor
    function ExistReturnInDB(const ADir, AReturnFileName: String): Boolean;//20170902 Igor
  public //client letters
    DataDict: TDataDictList;
    function LoadDataDict: TDataDictList; //virtual;
    procedure HelpOnClientLetter; virtual;
    procedure ConvertDataBase;//20150119 Igor
  public //cross-app
    function InitNewReturn(ForLoad: boolean = False): integer; virtual;
    function OpenReturn(DirName, FlName: string; fShow: boolean; AIsAppendix: Boolean = False): integer; virtual;//20160305 Igor
    function CheckLastYearPgmFolder(out AErrorMessage: String): Boolean; virtual; abstract; //20160516 Igor
    function CheckLastYearDataFolder(out AErrorMessage: String): Boolean; virtual; abstract; //20160516 Igor
    function GetOptionsCaption(AOptionName: String): String; virtual; abstract; //20160530 Igor
    function GetDefaultOptionsValue(AOptionName: String): String; virtual; abstract; //20160530 Igor
    function GetDefaultOptions: TStringList; virtual; abstract; //20160530 Igor
    function GetOptions: TStringList; virtual; //20160602 Igor
    function HaveOptions(AOptionsName: String): Boolean; Virtual; abstract; //20170112 Igor
    function ImportOneReturn(ADS: TDataSet; ASrcDir, ADstDir: String; var AErr: String;
      AOverride: Boolean): Boolean; virtual; abstract; //20160530 Igor //20160602 Igor //20160615 Igor
    function vtMobileFilePath: String; Virtual;  //20160614 Igor
    procedure LoadOptionsFileToMem; virtual; abstract; //20160530 Igor
    procedure InitFList; Virtual; abstract; //20160531 Igor
    procedure SaveSingleOptions(const AOptionName, AValue: String; AOptionsFileName: String = ''); virtual; abstract; //20160602 Igor //20160617 Igor
    procedure InitFormsTable; virtual; abstract; //20160616 Igor
    procedure AppOnIddle; virtual; //20161213 Igor
    property ModuleHelpFile: String read GetHelpFile; //20160526 Igor
    property ModuleHelpUpdFile: String read GetHelpUpdFile; //20160526 Igor
    property Disabled: Boolean read FDisabled write SetDisabled Default False; //20160526 Igor
    property NeedUpdate: Boolean read FNeedUpdate write FNeedUpdate Default True; //20160526 Igor
    function isMyReturn(const AAppName: String): Boolean; Virtual; //20160703 Igor
    property LimitedVersionDir: String read GetLimitedVersionDir; //20160718 Igor
    property PswElm: Integer read GetPswElm; //20161028 Igor
    function GetExportForms: TExportForms; virtual; //20161229 Igor
    procedure GetOverloadedProperty; virtual; //20170112 Igor
    function isValidDataDir(const ADir: String): Boolean; virtual; abstract;//20170504 Igor
    function FormsDBLite: String; virtual; //20170504 Igor
    function FormsTableLite: String; virtual; //20170504 Igor
    function MaskClientDataForBuildReport(const AFieldName, AValue: String): String; virtual; //20170505 Igor
    function AllowFormForBuildReport(const AFormName: String): Boolean; virtual; //20170505 Igor
    function MaskFormDataForBuildReport(const AFormName: String; AFieldNo: Integer;
      AFieldValue: String): String; virtual; //20170505 Igor
    //20170703 Igor >>>
    procedure CallExecuteForm(AFormID: Integer); virtual;
    //20170703 Igor <<<
    //20170717 Igor >>>
    function OpenForeignForm(const ADir, AFile, AForm: String; const AElement: Integer): TFormData; virtual;
    //20170717 Igor <<<
    //20170719 Igor >>>
    function GetForeignForm(const ADir, AFile, AForm: String;
      const AOpenMode: TOpenMode = TOpenMode.omHidden): TFormData; virtual;
    //20170719 Igor <<<
    //20170726 Igor>>>
    function AutoFillToVtAddr(const ASection, ASubSection: String;
      out AVTAddr: TVTMapElement): Boolean; Virtual;
    //20170726 Igor<<<
    function LicenseKeyPrefix: String; virtual;//20170731 Igor
    //20191015 Igor >>>
    function IsBNButtonVisible: boolean; virtual;
    function GetBNText: string; virtual;
    procedure SetBNText(const Value: string); virtual;
    property BNText: string read GetBNText write SetBNText;
    //20191015 Igor <<<
    //20200317 Igor >>>
    function CanRebuildCorruptedDatabase: boolean; virtual;
    procedure RebuildCorruptedDatabase; virtual;
    //20200317 Igor <<<
    property RightTabSheets: TRightTabSheets read GetRightTabSheets;//20171228 Igor
  end;

  TAppClass = class of TApp; // add 20151116 Igor

  TApp2016 = Class(TApp)
  protected//20170811 Igor
    FCoreVersion: String;
  public
    constructor Create(AAppList: TAppList); override;
    property CoreVersion: String read FCoreVersion;
  End;
//20170811 Igor>>>
  TApp2017 = Class(TApp2016)
  public
    constructor Create(AAppList: TAppList); override;
  End;
//20170811 Igor<<<
  //20180830 Igor >>>
  TApp2018 = Class(TApp2016)
  public
    Prp_NameAsTitle: Boolean; //20191202 Igor
  public
    constructor Create(AAppList: TAppList); override;
  End;
  //20180830 Igor <<<
  TFloatingForms = class(TList)
  public
    procedure RegisterForm(AForm: TvtScrollBox; RemoveIt: boolean);
    function GetForm(index: integer): TvtScrollBox;
    function FindForm(ARetNo, AFormNo: integer): TvtScrollBox; //20160314 Igor
    procedure RemoveReturn(RetNo: integer);
    procedure UpdateForms(RetNo: integer);

    procedure ColorChanged(RetNo: integer);
  end;

  TAppList = class(TOwningStringList)
  protected
    function RegisterApp(TheApp: TApp): integer; //return AppID?
  public
    constructor Create;
    destructor Destroy; override;
    procedure AssignTo(lst: TStrings); reintroduce;
    function AppFromID(const id: string): TApp;
    function AppFromName(const id: string): TApp; overload; //by short ID!
    function GetApp(index: integer): TApp; overload;
    //20170703 Igor >>>
    function GetApp(AAppIdx: eAppIdx): TApp; overload;
    //20170703 Igor <<<
    procedure GetLicenses;
    function LicensedApps: integer;
    procedure InitApps;
    procedure RetNoChanged; //notify all AppIds
  end;
var
  AppList: TAppList;
var
  FloatingForms: TFloatingForms;
  CurrentApp: TApp; //CurApp is private to MainForm
  RetList: TRetList;
  RetRec: TRetData;

procedure NothingToCalc(RetNo: integer; FName: string; FNo: integer);
procedure NoFormToCalc(RetNo: integer; FName: string; FNo: integer);

//function GetKeyWAttributes(KeyW: String;Var FName:String; Var Elm:Integer;Var IsAmount:String): boolean;
function CleanUpKeyW(KeyW: string): string;

type
  //TMainOptions = object
  TZoomForm = (zfAll,zfCenter,zfRight); //20160209 Igor
  TLockManagerLevel = (lmlDisableLock, lmlAllowMultiWrite, lmlDeniedMultiWrite); //20170315 Igor
  TSkin = (skClassic, skSmallToolBar, skLargeToolBar, skRibbon);//20170824 Igor
  TMainOptions = class(TSingleStringList)
  private
    //20160114 Igor
    FFormZoom: Integer;
    FRightZoom: Integer; //20160209 Igor
    FtbZoom: TTrackBar;
    FlblZoom: TLabel;
    FZoomForm: TZoomForm; //20160209 Igor
    FRightPanelActivePageIndex: Integer; //20160221 Igor
    FOptionsLoaded: Boolean; //20160225 Igor
    FReturnsPanelVisible: Boolean; //20160426 Igor
    FAuditPanelVisible: Boolean; //20160426 Igor
    FFormsPanelVisible: Boolean; //20160426 Igor
    FDisabledApp: TStringList;
    FLockManagerLevel: TLockManagerLevel; //20170315 Igor
    FSkin: TSkin;//20170824 Igor
    FActiveTabColor: TColor; //20180111 Igor
    procedure SetFormZoom(Value:Integer);
    function GetFormZoom: Integer;
    procedure SetRightZoom(Value:Integer); //20160209 Igor
    function GetRightZoom: Integer; //20160209 Igor
    procedure SettbZoomParams;
    procedure SettbZoom(Value: TTrackBar);
    procedure SetlblZoom(Value: TLabel);
    procedure SetZoomForm(Value: TZoomForm); //20160209 Igor
    procedure CallBackZoom; //20160209 Igor
    procedure SetRightPanelActivePageIndex(Value: Integer); //20160221 Igor
    function GetRightPanelActivePageIndex:Integer; //20160221 Igor
    procedure SetSkin(const Value: TSkin);//20170824 Igor
    procedure SetActiveTabColor(Value: TColor);//20180111 Igor
  public
    Valid: boolean; //file loaded?

    LeftPanelWidth, RightPanelWidth,
    FormPanelHeight, //20160225 Igor
      MainLeft,
      MainTop,
      MainWidth,
      MainHeight: integer; //string?
    MaximizeMainForm: Boolean;
    SkipLogin,
      HideMostRecent: boolean;
//    FormZoom,
      Prn_LMargin, Prn_RMargin: Real; //20160204 Igor
      Prn_FontIncr,
      UpdateFrequency: integer;
    EscOption: string;
    SingleLoginId,
      LastAppId,
      LastUpdateCheck: string;
    constructor Create; //override;
    destructor Destroy; override;
    procedure Load;
    procedure Save;
    procedure AddDisabledApp(const AppID: String); //20160526 Igor
    procedure DelDisabledApp(const AppID: String); //20160526 Igor
    function IsDisabledApp(const AppID: String): Boolean; //20160526 Igor
    procedure SaveSingle(const AName, AValue: String); //20160526 Igor
    //20160114 Igor
    property FormZoom: Integer read GetFormZoom write SetFormZoom;
    property RightZoom: Integer read GetRightZoom write SetRightZoom; //20160209 Igor
    property RightPanelActivePageIndex: Integer read GetRightPanelActivePageIndex write setRightPanelActivePageIndex; //20160221 Igor
    property tbZoom: TTrackBar read FtbZoom write SettbZoom;
    property lblZoom: TLabel read FlblZoom write SetlblZoom;
    property ZoomForm: TZoomForm read FZoomForm write SetZoomForm; //20160209 Igor
    property ReturnsPanelVisible: Boolean read FReturnsPanelVisible write FReturnsPanelVisible; //20160426 Igor
    property AuditPanelVisible: Boolean read FAuditPanelVisible write FAuditPanelVisible; //20160426 Igor
    property FormsPanelVisible: Boolean read FFormsPanelVisible write FFormsPanelVisible; //20160426 Igor
    property LockManagerLevel: TLockManagerLevel read FLockManagerLevel write FLockManagerLevel; //20170315 Igor
    property Skin: TSkin read FSkin Write SetSkin;//20170824 Igor
    property ActiveTabColor: TColor read FActiveTabColor write SetActiveTabColor; //20180111 Igor
    function HaveOptions(AOptionsName: String): Boolean; //20170112 Igor
    procedure SetOptions(AOptionsName, AOptionsValue: String);//20170127 Igor
    function ReadOptions(AOptionsName: String): string; //20170127 Igor
  end;
var
  MainOptions: TMainOptions;

type
  TErrorLogger = class(TStringList)
  private
    FLogName: string;
    procedure SetLogName(const Value: string);
    procedure SendReport;//20170927 igor
  public
    destructor Destroy; override;
    procedure Log(const Msg: string);
    property LogName: string read FLogName write SetLogName;
    procedure ApplicationException(Sender: TObject; E: Exception);//20170927 igor
  end;
var
  Errors: TErrorLogger;

//20170112 Igor >>>

type
  TAppProfile = class(TObject)
  private
    FLogin_ID: String;
    FApp: TApp;
    FConnection: TADConnection;
    function GetOverloadProperty(const APropertyName: String): String;
    procedure SetOverloadProperty(const APropertyName: String;
      const APropertyValue: String); overload;
  protected
  public
    constructor Create(AApp: TApp; AConnection: TADConnection);
    destructor Destroy; override;
    procedure DeleteOverloadProperty(const APropertyName: String);
    class procedure DeleteAllOverloadProperty(AConnection: TADConnection; const AUser, AApp: String); overload;
    class procedure DeleteAllOverloadProperty(AConnection: TADConnection; const AUser: String); overload;
    procedure DeleteAllOverloadProperty; overload;
    class procedure SetOverloadProperty(AConnection: TADConnection;
      const AUser, AApp, APropertyName, APropertyValue: String); overload;
    class procedure CloneSettings(AConnection: TADConnection;
      const AFromUser, AToUser: String);

    property App: TApp read FApp;
    property Login_ID: String read FLogin_ID write FLogin_ID;
    property OverloadProperty[const APropertyName: String]: String read GetOverloadProperty write SetOverloadProperty;
    function EqualOverloadProperty(const APropertyName,
      ACompareValue: String; ACaseInsensitive: Boolean = False): Boolean;
    function isOverload(const APropertyName: String): Boolean;
  end;

  TAppProfiles = class(TObjectList<TAppProfile>)
  private
    FLogin_ID: String;
    FConnection: TADConnection;

    procedure SetLogin_ID(const ALogin_ID: String);
  public
    constructor Create(ALogin_ID: String; AConnection: TADConnection);
    destructor Destroy; override;
    procedure Clear;
    class procedure AddApp(AConnection: TADConnection;
      const AUser, AApp: string); overload;
    function AddApp(AApp: TApp): TAppProfile; overload;
    class procedure DeleteApp(AConnection: TADConnection;
      const AUser, AApp: string); overload;
    class procedure DeleteAllApp(AConnection: TADConnection;
      const AUser: string);
    class procedure CloneSettings(AConnection: TADConnection;
      const AFromUser, AToUser: String);
    procedure DeleteApp(AApp: TApp); overload;
    function ProfileByApp(AApp: TApp): TAppProfile;
    property Login_ID: String read FLogin_ID write SetLogin_ID;
  end;

  TUserProfile = class(TObject)
  private
    FUserName: String;
    FCode: String;
    FPassword: String;
    FPrep_Name: String;

    FAppProfiles: TAppProfiles;
    FConnection: TADConnection;
    FPREP_INTLS: String;
    FM_OFFICE: String;
    FBRANCH: String;
    FINV_NO: Integer;
    FAUTH_LEVEL: String;

    procedure SetUserName(const Value: String);
    procedure SetCode(const Value: String);
    procedure SetPassword(const Value: String);
    procedure SetPrep_Name(const Value: String);

    function GetOverloadProperty(const AApp: TApp; const APropertyName: String): String;
    procedure SetOverloadProperty(const AApp: TApp; const APropertyName: String; const APropertyValue: String);
    procedure SetAUTH_LEVEL(const Value: String);
    procedure SetBRANCH(const Value: String);
    procedure SetINV_NO(const Value: Integer);
    procedure SetM_OFFICE(const Value: String);
    procedure SetPREP_INTLS(const Value: String);
  protected

  public
    constructor Create;
    destructor Destroy; override;
    procedure InitEmpty;
    function LoadUserProfile(const AUserName: string;
 AHaveMultiOffice: Boolean): boolean; //20170115 Igor
    procedure SaveUserProfile;
    property UserName: String read FUserName write SetUserName;
    property Code: String read FCode write SetCode;
    property Password: String read FPassword write SetPassword;
    property Prep_Name: String read FPrep_Name write SetPrep_Name;
    property PREP_INTLS: String read FPREP_INTLS write SetPREP_INTLS;
    property M_OFFICE: String read FM_OFFICE write SetM_OFFICE;
    property BRANCH: String read FBRANCH write SetBRANCH;
    property AUTH_LEVEL: String read FAUTH_LEVEL write SetAUTH_LEVEL;
    property INV_NO: Integer read FINV_NO write SetINV_NO;

    property AppProfiles: TAppProfiles read FAppProfiles;
    property OverloadProperty[const AApp: TApp; const APropertyName: String]: String read GetOverloadProperty write SetOverloadProperty;
    function EqualOverloadProperty(const AApp: TApp; const APropertyName,
      ACompareValue: String; ACaseInsensitive: Boolean = False): Boolean;
    procedure RealProperty(const AApp: TApp; const APropertyName: String; var APropertyValue: String); overload;
    procedure RealProperty(const AApp: TApp; const APropertyName: String; var APropertyValue: Integer); overload;
    procedure RealProperty(const AApp: TApp; const APropertyName: String; var APropertyValue: Currency); overload;
    procedure RealProperty(const AApp: TApp; const APropertyName: String; var APropertyValue: Boolean); overload;
    procedure RealProperty(const AApp: TApp; const APropertyName: String; var APropertyValue: TDateTime); overload;
    function OverloadedProperty(const AApp: TApp; const APropertyName: String; var APropertyValue: TValue): Boolean;

    function Tax_Dir: string; deprecated 'Only for compatibility with VT-2015. Use OverloadProperty[const AApp: TApp; const APropertyName: String]';
    function DBFData_Dir: string; deprecated 'Only for compatibility with VT-2015. Use OverloadProperty[const AApp: TApp; const APropertyName: String]';
    function EFile_Dir: string; deprecated 'Only for compatibility with VT-2015. Use OverloadProperty[const AApp: TApp; const APropertyName: String]';
    function Br_Dir: string; deprecated 'Only for compatibility with VT-2015. Use OverloadProperty[const AApp: TApp; const APropertyName: String]';

    class function InitStorage: Boolean;//20170927 igor
  end;

type TUnFreezeThread = class(TThread) //20200312 Igor
  private
    procedure ModalFormOnTop;
  protected
    procedure Execute; override;
  end;

var
  User: TUserProfile;
  CurrGlobalMessageId: integer; //20190504 Igor
  FUnFreezeThread: TUnFreezeThread; //20200312 Igor
//20170112 Igor <<<

//20170927 Igor>>>
Function InitMulti: Boolean;
function InitTaxModules: Boolean;
procedure InitCloudKeys; // 20180917 Igor
Procedure DoneMulti;
//20170927 Igor<<<
function App(RetNo: integer): TApp;

function GetChildWin(RetNo: integer): TMyChild;
function GetDfmFileName(RetNo: integer; const AName: string): string;
{$IFDEF LastYear}
function GetLastYearDfmFileName(RetNo: integer; const AName: string): string;
{$ELSE}
{$ENDIF}

function GetRetFormName(RetNo: integer; FormNo: integer): string;
function GetRetFormNo(RetNo: integer; FormName: string): Integer;
function GetNextReturn(RetNo: Integer; AWithOutAppendix: Boolean = False): Integer; //20170307 Igor
function GetRetColor(RetNo: integer): integer;
procedure SetRetColor(RetNo: integer; clr: TColor; AClrElm: Integer); //20170219 Igor

procedure PopulateFormWithData(AForm: TvtScrollBox);
function RemoveFormsExcept(ParentForm: TComponent; RetNo, FNo: integer): TvtForm;
// 20180712 Igor >>>
procedure AddLogAppMon;
procedure SendAndUpdateAppMon;
// 20180712 Igor <<<
procedure AddLogAppMonEfile; // 20180722 Igor
function GetExeDir: string; //20190513 Igor

implementation

uses
  Forms, {$WARN UNIT_PLATFORM OFF}FileCtrl{$WARN UNIT_PLATFORM ON}, Printers, Dialogs,//20170811 Igor
  vtShape, vtEditBox, vtLabel, vtMemoBox, //wwRichEd,
  vtCommon, vtDialogs, fDfmProgress, fCalcWatch, //vtScrollBox,
  vtMain, vtAuthorization, vtRichText,
  fAskForScanKey, fPopList, fProgres,
  //keep last
  vtDynData, vtTrimStr, vtShared, vtDataBase, vtDataModuleUnit,//20150119 Igor
  Variants,//20160415 Igor
  Math, //20170609 igor
  fCloudLogon, //20171026 Igor
  vtAppMon, // 20180712 Igor
  fCaseDo, //20200305 Igor
  vtCommonIntf, vtHelpermanager, //20181213 Igor
  IOUtils, DateUtils;//20170802 Igor //20180503 Igor

var
  DummyRec: TFRec;
//20170927 Igor>>>

function GetExeDir: string; //20190513 Igor
begin
  if CheckIsCloud(true) then
    Result := CloudDir
  else
    Result := ExeDir;
end;

procedure AddLogAppMon; // 20180712 Igor
begin
  try
    with TAppMon.Create do
    try
      InitAppMon(false);
      if AppMonType <> amtOnSave then Exit; // 20180722 Igor
      if not CheckIfNeedLog then Exit;
      SaveLog;
    finally
      Free;
    end;
  except
  end;
end;

procedure AddLogAppMonEfile; // 20180722 Igor
begin
  try
    with TAppMon.Create do
    try
      InitAppMon(false);
      if AppMonType <> amtOnEfile then Exit;
      if not CheckIfNeedLog then Exit;
      SaveLog;
    finally
      Free;
    end;
  except
  end;
end;

procedure SendAndUpdateAppMon; // 20180712 Igor
begin
  try
    with TAppMon.Create do
    try
      InitAppMon(true);
      SendLogs;
    finally
      Free;
    end;
  except
  end;
end;

function InitStorage: Boolean;
begin
  Result := ForceDirectories(ExeDir) and
    TUserProfile.InitStorage;
  if not TFile.Exists(TPath.Combine(ExeDir, InstallFile)) then
  begin
    with TStringList.Create do
      try
        if TFile.Exists(TPath.Combine(ExtractFilePath(Application.ExeName), InstallFile)) then
          LoadFromFile(TPath.Combine(ExtractFilePath(Application.ExeName), InstallFile))
        else
          Add('*');  
        SaveToFile(TPath.Combine(ExeDir, InstallFile));
      finally
        Free;
      end;
  end;
end;
//20171031 Igor>>>
function WindowProc(wnd: HWND; Msg: Integer; Wparam: Wparam; Lparam: Lparam):Lresult; stdcall;
Begin
  Result:=DefWindowProc(wnd,msg,wparam,lparam);
end;
//20171031 Igor<<<
Function InitMulti: Boolean;
var                    //20171027 Igor
  DemoPartDir: string; //20171027 Igor
  wc: TWndClassEx;     //20171031 Igor
  I: integer; //20190222 Igor
  Helper: string; //20190307 Igor
begin
  //20171031 Igor>>>
  //create hidden window for iis setup check
  try
    wc.cbSize := sizeof(wc);
    wc.lpfnWndProc := @WindowProc;
    wc.hInstance := HInstance;
    wc.lpszClassName := TInternalExeYearName[InternalExeYear];
    RegisterClassEx(wc);
    CreateWindowEx(0, wc.lpszClassName, '', ws_overlappedwindow, 0, 0, 0, 0, 0, 0, Hinstance, nil);
  except end;
  //20171031 Igor<<<
  if not ExeDir.IsEmpty then
    exit(True);
  StartParams := TStartParams.Create('');
  if StartParams.isCloud then
  begin
    DemoPartDir := TGUID.NEWGUID.ToString;
    //20171026 Igor>>>
    with TfrmCloudLogon.Create(Application) do
    //20180503 Igor >>>
    try
      //lbProgramId.Caption := ExeYear;
      if ShowModal <> mrOk then
      begin
        Result := false;
        Exit;
      end;
      //Result := ValidUser; //set where???
      StartParams.FIsDemo := True;
      DemoPartDir := UserDir;
      //20190213 Igor >>>
      if not SameText(UserDataDir, '') then
        CloudDataDir := TPath.Combine(TPath.Combine(TPath.Combine(TPath.GetDocumentsPath, ExeYear), 'DataDir'), UserDataDir);
      //20190213 Igor <<<
    finally
      Release;
    end;
    //20171026 Igor<<<
    //20190213 Igor >>>
    CloudDir := TPath.Combine(TPath.GetDocumentsPath, ExeYear); 
    if StartParams.IsDemo then
      CloudDir := TPath.Combine(CloudDir, DemoPartDir); //20171027 Igor
    ForceDirectories(CloudDir); //20180212 Igor
    //20190222 Igor >>>
    for I := 0 to HelperManager.HelperClassList.Count - 1 do
    begin
      HelperManager.ManagerConfig.ConfigFileName := TPath.Combine(CloudDir,'HelpersConfig.txt');
      HelperManager.ManagerConfig.Save;
    end;
    //20190222 Igor <<<
    //20190213 Igor <<<
    FUnFreezeThread.Resume; //20200312 Igor
  end;
  CaseDoStayOnTop := StartParams.isCloud; //20200305 Igor
  //20180503 Igor <<<
  ExeDir := ExtractFileDir(Application.ExeName);

  try
    FormatSettings.DecimalSeparator := '.';
    Errors := TErrorLogger.Create;
    Application.OnException := Errors.ApplicationException;
    Errors.LogName := TPath.Combine(ExeDir, 'vtErrors.txt');
    if not InitStorage then
      Exit(False);
    User := TUserProfile.Create;
    AppList := TAppList.Create;
    AppList.Sorted := False;
    SomeList := TSingleStringList.Create;
    MainOptions := TMainOptions.Create;
    FloatingForms := TFloatingForms.Create;
    LicenseList := TLicenseList.Create;
    RetList := TRetList.Create;
    ReviewList := TReviewList.Create;
    OverList := TOverList.Create;
    DummyRec := TFRec.Create;
    Progress := TProgress.Create(Application);
    Result := True;
  except ON E: Exception do
    begin
      if Assigned(Errors) then
        Errors.Log(E.Message);
      Result := False;
    end;
  end;
end;

function InitTaxModules: Boolean;
var
  AppStrList: TStringList;
  FileList: TDictionary<String, String>;
  AppName: String;
  WorkPath: string;
  PackageModule: HModule;
  AClass: TPersistentClass;
  bplName,bplClassName: String;
begin
  Result := False;
  AppStrList := TStringList.Create;
  FileList := TDictionary<String, String>.Create;
  try
    //Find file by mask
    WorkPath := ExtractFilePath(Application.ExeName);
    TDirectory.GetFiles(WorkPath, 'vt*.bpl', TSearchOption.soTopDirectoryOnly,
      function(const Path: string; const SearchRec: TSearchRec): Boolean
      begin
        Result := True;
        if TRegEx.IsMatch(SearchRec.Name, '^vt([\w\d]{2,2}|[\w\d]{4,4})_\d{4,4}.bpl$', [roIgnoreCase]) then
        begin
          AppName := ReplaceStr(Copy(ChangeFileExt(SearchRec.Name, ''), 3, MaxInt), '_', '-');
          FileList.AddOrSetValue(AppName, TPath.Combine(Path, SearchRec.Name));
        end;
      end);
    if FileExists(TPath.Combine(ExeDir, InstallFile)) then
      AppStrList.LoadFromFile(TPath.Combine(ExeDir, InstallFile));
    if (AppList.Count > 0) and (AppList[0] = '*') then
    begin
      AppList.Clear;
      for AppName in FileList.Keys.ToArray do
        AppList.Add(AppName);
    end;    
      
    for AppName in AppStrList do
    begin
      if not FileList.TryGetValue(AppName, bplName) or bplName.IsEmpty then
        Continue;
      bplClassName := 'TApp' + ReplaceStr(AppName, '-', '_');
      try
        PackageModule := SafeLoadLibrary(bplName, SEM_FAILCRITICALERRORS);
        if PackageModule <> 0 then
        begin
          try
            InitializePackage(PackageModule, nil);
          except ON E: Exception DO
            Begin
              FreeLibrary(PackageModule);
              continue;
            End;
          end;
          AClass := GetClass(bplClassName);
          if Assigned(AClass) then
          begin
            TAppClass(AClass).Create(AppList);
            Result := True;
          end;
        end
        else
          Errors.Log(SysErrorMessage(GetLastError));
      except ON E: Exception do
      end;
    end;
  finally
    AppStrList.Free;
    FileList.Free;
  end;
  // 20180917 Igor >>>
  if Not Result then
    MessageDlg('Please install also at least one of the specific tax modules!', mtError, [mbOk], 0)
  else
    InitCloudKeys;
  // 20180917 Igor <<<

  try
    AppName := TPath.Combine(WorkPath, 'vtchkupd.exe.bak');
    if FileExists(AppName) then
      if FileExists(TPath.Combine(WorkPath, 'vtchkupd.exe')) then
        TFile.Delete(AppName)
      else
        TFile.Move(AppName, TPath.Combine(WorkPath, 'vtchkupd.exe'));
  except ON E: Exception DO
  end;
  //20200319 Igor >>>
  try
    AppName := TPath.Combine(WorkPath, 'vtchkupd.exe.tmbak');
    if FileExists(AppName) then
      if FileExists(TPath.Combine(WorkPath, 'vtchkupd.exe')) then
        TFile.Delete(AppName)
      else
        TFile.Move(AppName, TPath.Combine(WorkPath, 'vtchkupd.exe'));
  except ON E: Exception DO
  end;
  try
    AppName := TPath.Combine(WorkPath, 'vtchkupd.exe.ubak');
    if FileExists(AppName) then
      if FileExists(TPath.Combine(WorkPath, 'vtchkupd.exe')) then
        TFile.Delete(AppName)
      else
        TFile.Move(AppName, TPath.Combine(WorkPath, 'vtchkupd.exe'));
  except ON E: Exception DO
  end;
  //20200319 Igor <<<
end;

procedure InitCloudKeys; // 20180917 Igor
var I: Integer;
    AppName, AppKey, BNLimited: string; //20191015 Igor
    SaveApp: TApp; //20190325 Igor
begin
  if not StartParams.isCloud then Exit;
  //20190307 Igor >>>
  for I := 0 to AppList.Count - 1 do
  begin
    AppName := Copy(TApp(AppList.Objects[I]).AppName, 1, 2);
    if StartParams.StartKeys.TryGetValue(AppName, AppKey) then
    begin
      if TApp(AppList.Objects[I]).ValidateKey(AppKey) then
      begin
        LicenseList.Keys[TApp(AppList.Objects[I]).AppName + '-' + TApp(AppList.Objects[I]).AppYear] := AppKey;
        TApp(AppList.Objects[I]).SetLicense(AppKey);
      end
    end
    else
      LicenseList.Keys[TApp(AppList.Objects[I]).AppName + '-' + TApp(AppList.Objects[I]).AppYear] := '';
    //20191015 Igor >>>
    if SameText(AppName, 'T2') then
    begin
      StartParams.StartKeys.TryGetValue('BNLIMITED', BNLimited);
      TApp(AppList.Objects[I]).SetBNText(BNLimited);
    end;
    //20191015 Igor <<<
  end;
  with HelperManager do
  begin
    for I := 0 to HelperClassList.Count - 1 do
    begin
      AppName := HelperClassList.Values.ToArray[I];
      if StartParams.StartKeys.TryGetValue(UpperCase(AppName), AppKey) then
      begin
        if HelperManager.ValidateKey(I, AppKey) then
          LicenseList.Keys[AppName] := AppKey;
      end
      else
        LicenseList.Keys[AppName] := '';
    end;
  end;
  //20190307 Igor <<<
  LicenseList.Save;
  //20190325 Igor >>>
  SaveApp := CurrentApp;
  try
    for AppName in AppList do
    begin
      CurrentApp := AppList.AppFromID(AppName);
      CurrentApp.ReloadMainMenu;
    end;
  finally
    CurrentApp := SaveApp;
  end;
  //20190325 Igor <<<
end;

procedure DoneMulti;
begin
  FreeAndNil(User);
  if Assigned(RetList) then
  begin
    RetList.Clear;
    FreeAndNil(RetList);
  end;
  FreeAndNil(AppList);
  FreeAndNil(Errors);
  FreeAndNil(LicenseList);
  FreeAndNil(FloatingForms);
  FreeAndNil(ReviewList);
  FreeAndNil(OverList);
  FreeAndNil(SomeList);
  FreeAndNil(MainOptions);
  FreeAndNil(DummyRec);
  if StartParams.IsDemo AND (not StartParams.isCloud) AND TDirectory.Exists(ExeDir) then //20171027 Igor
    try
      TDirectory.Delete(ExeDir, True);
    except
    end;
end;

//20170927 Igor<<<

function App(RetNo: integer): TApp;
begin
  if RetNo > 0 then
    Result := RetList[RetNo].MyApp
  else
    Result := CurrentApp;
end;

procedure NothingToCalc(RetNo: integer; FName: string; FNo: integer);
begin
end;

procedure NoFormToCalc(RetNo: integer; FName: string; FNo: integer);
begin
  ErrorMsg('Cannot calc undefined form ' + FName);
end;

function GetNextReturn(RetNo: Integer; AWithOutAppendix: Boolean = False): Integer; //20170307 Igor
var
  i: integer;
begin
  Result := RetNo;
  {get higher retno}
  for i := RetNo + 1 to (RetList.Count - 1) do
  begin
    RetRec := RetList[i];
    if (RetRec <> nil)
       and not RetRec.Destroying
       and (not AWithOutAppendix or not RetRec.isAppendix) //20170307 Igor
       AND (RetList[RetNo].MyApp = RetRec.MyApp) then   //20161216 Igor
    begin Result := i;
      exit;
    end;
  end;
  {Get lower RetNo}
  for i := 1 to (RetNo - 1) do
  begin
    RetRec := RetList[i];
    if (RetRec <> nil)
      and not RetRec.Destroying
      and (not AWithOutAppendix or not RetRec.isAppendix) //20170307 Igor
      AND (RetList[RetNo].MyApp = RetRec.MyApp) then   //20161216 Igor
    begin Result := i;
      exit;
    end;
  end;
end;

function GetChildWin(RetNo: integer): TMyChild;
begin
  Result := RetList[RetNo].MyChild;
end;

function GetRetFormNo(RetNo: integer; FormName: string): Integer;
//function  GetFormNo(RetNo: integer; FormName: String):Integer;
begin
  Result := RetList[RetNo].GetFormNo(FormName);
end;

function GetRetFormName(RetNo: integer; FormNo: integer): string;
//function  GetFormName(RetNo: integer; FormNo: integer):String;
begin
  Result := RetList[RetNo].GetFormName(FormNo);
end;

function GetDfmFileName(RetNo: integer; const AName: string): string;
begin
  //Result:=AppPath + 'U' + RemoveInst(AName)+'.DFM';
  Result := RetList[RetNo].GetDfmFileName(AName);
end;

{$IFDEF LastYear}

function GetLastYearDfmFileName(RetNo: integer; const AName: string): string;
begin
  Result := RetList[RetNo].MyApp.GetLastYearDFMFileName(AName);
end;
{$ELSE}
{$ENDIF}

function NextAvailColor(const ColorTable: TColorTable): TColor;
var
  i: Integer;
begin
  for i := 0 to high(ColorTable) do
  begin
    Result := ColorTable[i];
    if not IsColorInUse(Result) then
      exit;
  end;
  Result := RGB(255, 255, 255); {white if no more colors}
end;

function GetRetColor(RetNo: integer): integer;
begin
  (* Beware: this function can have 2 meanings:
    - init return color <--- must be explicitly in constructor
    - current return color
  *)
  Result := RetList[RetNo].RetColor;
end;

function ReColorReturn(RetNo: integer; clr: TColor): boolean;
begin
  (* Meaning of Result? - False when color in use?
    - color unchanged
    - color changed
    - color in use
    - invalid RetNo
  *)
  Result := RetList[RetNo].RetColor = Clr;
  if Result then
    exit;
  Result := not IsColorInUse(clr);
  if not Result then
    exit;
  RetList[RetNo].SetRetColor(Clr);
  RetList[RetNo].MyChild.Invalidate; //SetColor?
  MainForm.GuiCommand(gcColorChanged);
  { TODO : update all return windows, main form }
end;

(* The following assumes that return colors should be
  unique across ALL open returns.
*)

function IsColorInUse(clr: Tcolor): boolean;
var
  i: Integer;
begin
  (* Check *all* open returns for this color
  *)
  Result := True; //if found
  for i := 0 to (RetList.Count - 1) do
  begin
    if assigned(RetList[i]) and (RetList[i].RetColor = clr) then
      exit; //True
  end;
  Result := False;
end;

procedure SetRetColor(RetNo: integer; clr: TColor; AClrElm: Integer); //20170219 Igor
begin
  (* Problem: when to send notifications?
    Not on initial assignments to return!
    Only from color panel selection (vtMain)!
  *)
  if RetList[RetNo].RetColor = clr then
    exit; //unchanged

//20170219 Igor >>>. returns many, colors few
//  if IsColorInUse(Clr) then
//  begin
//    ShowTimedMsg('Color already in use', 1000);
//    exit;
//  end;
//20170219 Igor <<<s

  RetList[RetNo].SetRetColor(clr);
  StoreElm(RetNo,'STATUS', AClrElm, ColorToString(clr)); //20170219 Igor
{$IFDEF old}
  if clr <> 0 then
    AttributeChanged(RetList[RetNo]);
  //else initial assignment - no actions to take
{$ELSE}
  //if RetNo=CurrentReturn then notify?
{$ENDIF}
end;

procedure PopulateFormWithData(AForm: TvtScrollBox);
begin
  (* Delegate to ChildWin, even if AForm is not a child of it.
  *)
  { TODO : drop - use SB.PopulateFormWithData }
    //RetList[AForm.RetNo].MyChild.PopulateFormWithData(AForm);
  AForm.PopulateFormWithData;
end;

function RemoveFormsExcept(ParentForm: TComponent; RetNo, FNo: integer): TvtForm;
var
  i: integer;
  cmp: TComponent;
  sb: TvtScrollBox;
begin
  Result := nil;
  for i := ParentForm.ComponentCount - 1 downto 0 do
  begin
    cmp := ParentForm.Components[i];
    if cmp is TvtScrollBox then
    begin
      sb := TvtScrollBox(cmp);
      if (sb.FormNo = FNo) and (sb.RetNo = RetNo) then
        Result := sb
      else
      begin
        FloatingForms.RegisterForm(sb, True); //remove it
        sb.Free;
      end;
    end;
  end;
end;

{ TRetData }

constructor TRetData.Create(TheApp: TApp);
var
  i, n, l: integer;
  lclVarFRec: TFRec;
begin
  (* Init the return.
    Init arrays - must be dimensioned by derived constructor!
  *)
  FMyApp := TheApp;
  if not assigned(FList) then //20160704 Igor
    FList := TheApp.FList; //if not already assigned (T1 LastYear!)
  Screen.Cursor := crHourGlass;
//20170515 Igor >>>
//  StringLists := TSingleStringLists.Create;
//20170515 Igpor <<<
  FRetNo := RetList.AddRet(self);
  AuditList := TAuditList.Create(RetNo);
  FLastYearRetNo := 0;//20160302 Igor
  //init forms
  n := Length(FrmHasData);
  if n > 0 then
    FillChar(FrmHasData[0], n, 0)
  else
    OVR('Create: SetLength(FrmHasData)');
  //20190627 Igor >>>
  n := Length(Ln);
  if n > 0 then
    FillChar(Ln[0], n * sizeof(Ln[0]), 0)
  else
  begin
    //OVR('Create: SetLength(Ln)'); - TF has no Ln[]
  end;
  FLn := TDictionary<integer, real>.Create;
  //20190627 Igor <<<
  n := length(Frm);
  if n > 0 then
  begin
    FillChar(Frm[0], n * sizeof(Frm[0]), 0);
    for i := 0 to FList.Count - 1 do
    begin
      lclVarFRec := FList.ByIndex(i);
      InitFormData(lclVarFRec); //creates the form
    end;
  end //else intentional: don't auto-create forms?
  else
    OVR('Create: SetLength(Frm)');
end;

destructor TRetData.Destroy;
var
  i, RNo: integer;
  AChild: TMyChild;
begin
  AChild := FMyChild; //MyChild NIL when destroying!
  MyChild := nil; //break loop
  if (AChild <> nil)
    and not (csDestroying in AChild.ComponentState)
    and (AChild.RetNo = RetNo) then
    AChild.DetachReturn; //break loop AND close it

  //do whatever might require an still valid return (Ret[RetNo]...)
  assert(Destroying, 'invalid Destroy');
  RemoveReturnOverrides(RetNo); //don't Calc!
  RemoveRetReviewMarks(RetNo);
  FloatingForms.RemoveReturn(RetNo);

  //now delete our resources
    //PreSelForms.Free;
    //AuditList.Free;
  if Frm <> nil then
  begin
    for i := low(Frm) to high(Frm) do
      Frm[i].Free;
    Frm := nil; //prevent further access - fixed heap corruption
  end;

{$IFDEF OtherYear}
  (* used only here - remove OtherYearReturn?
    Meaning: coupled for scroll in sync.
    When uncoupled, unload last year return?
  *)
  if OtherYearReturn <> nil then
  begin
    //break link
    OtherYearReturn.OtherYearReturn := nil;
  end;
{$ELSE}
{$ENDIF}
  FreeAndNil(AuditList); //clear GUI list as well!
  //20170515 Igor >>>
  //StringLists.Free;
  //20170515 Igor <<<
  inherited;
  //20170619 Igor >>>
  if GetCurrentRetNo = RetNo then
  begin
    RNo := 0;
    for I := GetCurrentRetNo - 1 downto 1 do
    begin
      if Assigned(RetList[I]) AND
         not RetList[I].Destroying AND
         not RetList[I].isAppendix AND
         (RetList[I].MyApp = RetList[RetNo].MyApp) then
      begin
        RNo := I;
        Break;
      end;
    end;
    if RNo = 0 then
    begin
      for I := GetCurrentRetNo + 1 to RetList.Count - 1 do
      begin
        if Assigned(RetList[I]) AND
           not RetList[I].Destroying AND
           not RetList[I].isAppendix AND
           (RetList[I].MyApp = RetList[RetNo].MyApp) then
        begin
          RNo := I;
          Break;
        end;
      end;
    end;
    if RNo = 0 then
    begin
      for I := GetCurrentRetNo - 1 downto 0 do
      begin
        if Assigned(RetList[I]) AND
           not RetList[I].Destroying AND
           not RetList[I].isAppendix then
        begin
          RNo := I;
          Break;
        end;
      end;
    end;
    if RNo = 0 then
    begin
      for I := GetCurrentRetNo + 1 to RetList.Count - 1 do
      begin
        if Assigned(RetList[I]) AND
           not RetList[I].Destroying AND
           not RetList[I].isAppendix then
        begin
          RNo := I;
          Break;
        end;
      end;
    end;
  end
  else
    RNo := -1;
  RetList.RemoveReturn(RetNo); //no further references allowed (hope it will work!)
  if RNo >= 0 then
  begin
    GetCurrentRetNo := RNo;
    RetNoChanged(GetCurrentRetNo);
  end;
  //20170619 igor <<<
  FreeAndNil(FLockManager); //20170307 Igor
  //20190627 Igor >>>
  If Assigned(FLn) then
    FLn.Free;
  //20190627 Igor <<<
end;


procedure TRetData.ExportToFile(const ExportForms: TExportForms;
  AFileName: String = ''); //20161229 Igor //20170112 Igor

type
  TExportRow = Record
    FormName: String;
    ElementNo: Integer;
    ElementDescription: String;
    ElementValue: String;
  end;
  TExportData = array of TExportRow;
var
  F: Integer;
  EFrm: TExportForm;
  EElm: TExportElement;
  CurrFrmData: TFormData;
  CurrFRec: TFRec;

  ExportData: TExportData;
  ExportFile: TextFile;
  I: Integer;
  procedure FillArray(AInstFormName: String = ''); //20170219 Igor
  var
    E: Integer;
  begin
    for E := 0 to length(EFrm.ExportElements) - 1 do
    begin
      EElm := EFrm.ExportElements[E];
      if CurrFrmData.Elms[EElm.ElemNo] = '' then //20170104 Igor
        continue;                                //20170104 Igor
      SetLength(ExportData, length(ExportData) + 1);
      with ExportData[length(ExportData) - 1] do
      begin
        //20170219 Igor >>>
        if AInstFormName = '' then
          FormName := CurrFRec.FormInstName
        else
          FormName := AInstFormName;
        //20170219 Igor <<<
        ElementNo := EElm.ElemNo;
        ElementDescription := EElm.Description;
        ElementValue := CurrFrmData.Elms[EElm.ElemNo];
      end;
    end;
  end;

const
  dlm: String = '·';
  dlm2: String = '='; //20170104 Igor
  dlm3: String = '==';//20170104 Igor
  eol: String = '¤';

begin
//20170112 Igor >>>
  if AFileName = '' then
    AFileName := Self.GenerateDefaultFileNameForExport;
//20170112 Igor <<<
//prepare data
//20170112 Igor >>>
  if not SysUtils.ForceDirectories(ExtractFileDir(AFileName)) then
  begin
    MessageDlg('Unable to create directory "'+ExtractFileDir(AFileName)+'". '+
               'The file was not exported.', mtWarning, [mbOk], 0);
    Exit;
  end;
//20170112 Igor <<<

  for F := 0 to length(ExportForms) - 1 do
  begin
    EFrm := ExportForms[F];
    CurrFRec := Self.FList.ByFormName(EFrm.FormName);
    if IsFormMultiInst(EFrm.FormName) then
    begin
      for I := 0 to Self.FList.Count - 1 do
      if SameText(ExtractNonInstFormName(EFrm.FormName), Self.FList.Items[I].FormName) then //20170219 Igor
      begin
        CurrFrmData := Self.Frm[Self.FList.Items[I].FormNo];
        if not assigned(CurrFrmData) then
          Continue;
        FillArray(Self.FList.Items[I].FormInstName);//20170219 Igor
      end
    end
    else
    begin
      CurrFrmData := Self.Frm[CurrFRec.FormNo];
      if not assigned(CurrFrmData) then
        Continue;
      FillArray;
    end;
  end;
//Write data
  AssignFile(ExportFile, AFileName);
  Rewrite(ExportFile);
  try
    for I := 0 to length(ExportData) - 1 do
    begin
      writeln(ExportFile, ExportData[I].FormName + dlm +
                          IntToSTr(ExportData[I].ElementNo) + dlm2 + //20170104 Igor
                          ExportData[I].ElementDescription + dlm3 +  //20170104 Igor
                          ExportData[I].ElementValue + eol)
    end;
  finally
    CloseFile(ExportFile);
  end;
  //UserMsg('Export complete to file "'+AFileName+'"'); //20170113 Igor
end;


procedure TRetData.SetMyApp(const Value: TApp);
begin
  FMyApp := Value;
end;

procedure TRetData.SetMyChild(const Value: TMyChild);
begin
  (* catch:
  - replace registered child
  - register child while destroying
  *)
  if FMyChild = value then
    exit; //nop
  if assigned(Value)
    and (Destroying or assigned(FMyChild)) then
    ErrorMsg('bad recreate MyChild')
  else
    FMyChild := Value;
end;

procedure TRetData.SetRetNo(const Value: integer);
begin
  FRetNo := Value;
end;

function TRetData.SubstituteForm(AFormName: String): String;
begin
  Result := AFormName;
end;

procedure TRetData.CalcFullReturn;
begin
  CalcAll; //default
end;

procedure TRetData.ReCalcEveryThing;
begin
  CalcAll; //default;
end;

procedure TRetData.Free;
begin
  ErrorMsg('illegal use of TRetData.Free');
  //use RetList.RemoveReturn
  DebugBreak;
end;

procedure TRetData.BeforeDestruction;
begin
  FDestroying := True;
  inherited;
end;

procedure TRetData.SetRetColor(const Value: TColor);
begin
  FRetColor := Value;
end;

function TRetData.GetMyChild: TMyChild;
begin
  if Destroying then
    Result := nil
  else
    Result := FMyChild;
end;

function TRetData.GetReadOnly: Boolean; //20170307 Igor
begin
  Result := (MainOptions.LockManagerLevel = lmlDeniedMultiWrite) and
    (Assigned(FLockManager) and
    not(FLockManager.LockMode in [lmReadWrite, lmCreate]));
end;

function TRetData.GetSIN: string; //20170328 Igor
begin
  Result := '';
end;

function TRetData.GetTDDFileName: String;//20170720 Igor
begin
  Result := IncludeTrailingPathDelimiter(Self.MyApp.Dir_AutoFill) +
    Self.GetLastName + ' ' + LeftStr(Self.GetFirstName, 1) +
    '-AutoFillData-' + Self.GetSIN + '.txt';
end;

function TRetData.FetchElmFNo(FNo, ElmNo: integer): string;
begin
  (* Override for dynamic fields? Here or in TRetData?
  *)
  Result := Frm[FNo].Elms[ElmNo];
end;

procedure TRetData.SaveElmFromFile(FNo, ElmNo: integer; value: string);
begin
  (* allow to map dynamic data (extend arrays!)
  *)
  if ElmNo > ArrayMul then
    //always extend arrays?
    Frm[FNo].Elms[ElmNo] := value
  else
    Frm[FNo].Strings[ElmNo] := value; //quick save
end;

procedure TRetData.SaveMemoFromFile(FNo, ElmNo: integer; value: string);
begin
  if ElmNo >= Length(Frm[FNo].memos) then
  begin
    if value = '' then
      exit;
    //20160710 Igor
    if RetList[Self.RetNo].IsLastYearReturn or
       RetList[Self.RetNo].isAppendix then
    begin
      SetLength(Frm[FNo].memos, ElmNo + 1);
    end
    else
    begin
      ErrorMsg('Invalid memo# in return');
      ElmNo := 1; //assume?
    end;
  end;

  if Frm[FNo].Memos[ElmNo] <> '' then                      //20160818 Igor
    Frm[FNo].Memos[ElmNo] := Frm[FNo].Memos[ElmNo] + #$D#$A;  //20160818 Igor
  Frm[FNo].Memos[ElmNo] := Frm[FNo].Memos[ElmNo] + value; //append when reading text format

  if value <> '' then
    FrmHasData[FNo] := True;
end;

function TRetData.GetAuditRec(index: integer): PAuditRec;
begin
  TObject(Result) := AuditList[index];
end;

function TRetData.GetCloudFileName: String; //20190312 Igor
begin
  Result := GetDefaultFileName;
end;

function TRetData.GetDCN: string; //20170328 Igor
begin
  Result := '';
end;

function TRetData.GetDirClientDocs: String;//20170714 Igor
begin
  Result := '';
end;

procedure TRetData.AddAudit(ACategory: char; AMsg, AForm: string;
  AField: integer);
var
  i: integer;
begin
  //skip duplicate messages!
  for i := 0 to AuditList.Count - 1 do
  begin
    //20171212 Igor>>
    if (AuditList[i].Description = AMsg) and (AuditList[i].Form = AForm)
      and (AuditList[i].Elm = AField) then
    //20171212 Igor<<
      exit; //dupe!
  end;

  Inc(ErrorCount);
  case ACategory of
    'D': Inc(TapeErrorCount);
    'E': Inc(SeriousErrorCount);
    'F': Inc(EfileErrorCount);
    'G': ; //signature, was S
    'M': Inc(MandatoryErrorCount);
    'N': Inc(NoteErrorCount);
    'O', //signed off
    'R', //review mark
    'S', //super audit
    'T': ; //tip
    'W': //warning
      if IsSignedOff(AMsg) then
        ACategory := 'O'; //signed-off warning
  end; //case
  AuditList.Add(TAuditRec.Create(ACategory, AMsg, AForm, AField));
end;

procedure TRetData.AuditRecsToTreeView(TreeView: TTreeView; const Categories: string);
  //20171212 Igor>>
  function GetNodeByText(ATree : TTreeView; AValue:String;
   AVisible: Boolean): TTreeNode;
  var
    Node: TTreeNode;
  begin
    Result := nil;
    if ATree.Items.Count = 0 then Exit;
    Node := ATree.Items[0];
    while Node <> nil do
    begin
      if UpperCase(Node.Text) = UpperCase(AValue) then
      begin
        Result := Node;
        if AVisible then
          Result.MakeVisible;
        Break;
      end;
      Node := Node.GetNext;
    end;
  end;
  //20171212 Igor<<
var
  i, j, l: integer;
  hdr: string;
  //20171212 Igor>>
  root, parent: TTreeNode;
  r, rr: TAuditRec;
  Category: char;
  isFirst: boolean;
  //20171212 Igor<<
begin
  TreeView.Items.Clear;
  for i := 1 to Length(Categories) do
  begin
    Category := Categories[i];
    case Category of  //20160518 Igor>>>
      'D': hdr := 'ADDING TAPES';
      'E': hdr := 'ERRORS';
      'F': hdr := 'EFILE-CANNOT EFILE';
      'G': hdr := 'SIGNATURES';
      'M': hdr := 'MANDATORY';
      'N': hdr := 'NOTES';
      'O': hdr := 'SIGNED-OFF WARNINGS';
      'R': hdr := 'REVIEW MARKS';
      'S': hdr := 'SUPER AUDIT';
      'T': hdr := 'TIPS';
      'W': hdr := 'WARNINGS';
    else  //20160518 Igor <<<
      continue; //unknown category
    end;
    if AuditList.HasCategory(Category) then
    begin
      root := TreeView.Items.Add(nil, hdr);
      for j := 0 to AuditList.Count - 1 do
      begin
        r := AuditRec[j];
        //20171212 Igor>>
        if r.Category = Category then
        begin
          if not Assigned(GetNodeByText(TreeView, r.Description, False)) then
          begin
            parent := TreeView.Items.AddChildObject(root, r.Description, r);
            isFirst := True;
            for l := 0 to AuditList.Count - 1 do
            begin
              if l = j then
                continue;
              rr := AuditRec[l];
              if rr.Description = r.Description then
              begin
                if isFirst then
                begin
                  TreeView.Items.AddChildObject(parent, 'Form: ' + r.Form + '; Element: ' + IntToStr(r.Elm), r);
                  isFirst := False;
                end;
                TreeView.Items.AddChildObject(parent, 'Form: ' + rr.Form + '; Element: ' + IntToStr(rr.Elm), rr);
              end;
            end;
            parent.Collapse(True);
          end;
        end;
        //20171212 Igor<<
      end;
    end
    else
    begin
      if Category = 'F' then
        hdr := 'EFILE (NONE)'  //20160518 Igor
      else
        hdr := hdr + ' (NONE)';  //20160518 Igor
      TreeView.Items.Add(nil, hdr);
    end;
  end; //categories

  //overrides
  if OverList.RetOn(RetNo) then
  begin
    root := TreeView.Items.Add(nil, 'OVERRIDES');  //20160518 Igor
    for i := 0 to OverList.Count - 1 do
    begin
      OverRec := OverList.GetFieldOverride(i);
      if OverRec.RetNo = RetNo then
      begin
        //hdr := GetFormName(OverRec.FieldId)
        TreeView.Items.AddChildObject(root, Format('%s Field %d',
          [GetFormName(OverRec.FormNo), OverRec.FieldId]), OverRec);
      end;
    end;
  end
  else
    TreeView.Items.Add(nil, 'OVERRIDES (NONE)');  //20160518 Igor
end;

procedure TRetData.OpenAuditOrigin(SourceNode: TTreeNode);
var
  r: TAuditRec;
begin
  (* override ONLY if special handling is required
  *)
  if SourceNode.Data = nil then
    exit;
  pointer(r) := SourceNode.Data;
  if (r.Form <> '') then
    OpenForm(RetNo, GetFormNo(r.Form), r.Elm);
end;

{$IFDEF old}

function TRetData.DoSignOffAWarning(msg: string): boolean;
var
  i: integer;
  r: PAuditRec;
begin
  (* Sign off the warning with Message in SourceNode.
    Refresh the affected form - FrmHasData if contains overrides
    Override to refresh more, depending on Result
    Override to show dialog on msg=''
  *)
  Result := False;
  if msg = '' then
  begin
    //Result :=
    vtDialogs.SignOffWarnings(RetNo);
    exit;
  end;
  //msg := SourceNode.Text;
  r := nil;
  for i := 0 to AuditList.Count - 1 do
  begin
    r := AuditRec[i];
    if r.Description = msg then
    begin
      case r.Category of
        'O': exit; //already done
        'W':
          begin Result := True;
            break;
          end;
      else
        UserMsg('You can only sign off Warnings');
        Exit;
      end;
    end;
  end;
  if Result < 0 then
    exit; //no applicable message
  //sign it off
  r.Category := 'O';
  //FrmHasData[GetFormNo(r.Form)] := True; ???
  MyChild.Invalidate; //refresh field properties
  MainForm.RefreshAuditPanel(RetNo);
end;
{$ELSE}
{$ENDIF}

procedure TRetData.SetIsTaxPlan(const Value: boolean);
begin
  FIsTaxPlan := Value;
end;

function TRetData.IsSignedOff(ErrMsg: string): boolean;
var
  i, FNo, MsgLimit: integer;
  msg: string;
  r: TAuditRec;
begin
  (* form only exists in T1,T2, not TF
    Use AuditList!? - NO!
    Used to restore overrides during CountDiagnostics!
  *)
  Result := False;
  if ErrMsg = '' then
    exit;
  if ErrMsg[2] = '-' then
    ErrMsg := MidStr(ErrMsg, 3, length(ErrMsg));
{$IFNDEF single}
  Result := False;
  FNo := FList.GetFormNo('WARNOFF', False);
  if FNo < 1 then
    exit; //TF
  if Frm[FNo].Count = 0 then
    exit; //InitFormData(FNo);
  //Frm[FNo].ClrForm;
  MsgLimit := GetFormNumberFields(FNo);
  //bring msgs from form into templist
  for i := 1 to MsgLimit do
  begin
    msg := Frm[FNo][i];
    Result := (msg <> '') and (msg = ErrMsg);
    if Result then
      exit;
  end;
{$ELSE}
  for i := 0 to AuditList.Count - 1 do
  begin
    r := AuditList.AuditRec[i];
    Result := (r.Category = 'O')
      and (r.Description = ErrMsg);
    if Result then
      exit; //found
  end;
{$ENDIF}
end;

procedure TRetData.ClearDiagnostics;
begin
  (* overrides must call inherited!
  *)
  AuditList.Clear;
  ErrorCount := 0;
  MandatoryErrorCount := 0;
  SeriousErrorCount := 0;
  EFileErrorCount := 0;
  TapeErrorCount := 0;
  NoteErrorCount := 0;
end;

procedure TRetData.SetLastYearRetNo(Value: Integer);
begin
  FLastYearRetNo := Value;
end;

procedure TRetData.SetLn(AIndex: integer; const Value: real); //20190627 Igor
begin
  FLn.AddOrSetValue(AIndex, Value);
end;

procedure TRetData.SetLocked(const Value: boolean);
begin
  //20170307 Igor >>>
  if Not Value and FLocked then
  begin
    //20170315 Igor >>>
    if (MainOptions.LockManagerLevel = lmlDeniedMultiWrite) AND
       (Assigned(FLockManager) and
       not(FLockManager.LockMode in [lmReadWrite, lmCreate, lmDisableLock])) then
    //20170315 Igor <<<
    begin
      MessageDlg(FLockManager.LockMessage + #13 +
        'You can not unlock this Return.' + #13 +
        'Make sure that no one is working on the return and reopen it.',
        mtInformation, [mbOk], 0);
    end;
  end;
  //20170307 Igor <<<
  FLocked := Value;
end;

procedure TRetData.SetLockManager(const Value: TLockManager); //20170307 Igor
begin
  FLockManager := Value;
end;

function TRetData.GetLocked: boolean;
begin
  Result := FLocked or ReadOnly; //20170307 Igor
end;

function TRetData.AddPageInstance(NonInstFormName,
  FormInst: string): integer;
begin
  Result := 0;
  OVR('AddPageInstance');
end;

procedure TRetData.AssignLn(ASource: TDictionary<integer, real>); //20190627 Igor
var I: integer;
begin
  FLn.Clear;
  for I in ASource.Keys do
    FLn.AddOrSetValue(I, ASource.Items[I]);
end;

procedure TRetData.OVR(const MethName: string);
begin
  ErrorMsg('Override ' + ClassName + '.' + MethName);
end;

function TRetData.PrintTitle(AForm: TFrec): String;
begin
  Result := AForm.FormRlNm + ' ' + AForm.FormInst + ': '+ GetLastName+ ', ' + GetFirstName;
end;

procedure TRetData.RestoreRetColor(clr: TColor);
begin
  FRetColor := clr;
end;

function TRetData.GetFormCursorPos(FrmNm: string): Integer;
begin
  Result := FList.byformName(FrmNm).CursorPos;
end;

procedure TRetData.SetFList(const Value: TFList);
begin
  if FList = nil then
    FFList := Value; //only once!
end;

function TRetData.GetFormName(FormNo: integer): string;
begin
  Result := FList.ByFormNoDummy(FormNo).FormInstName;
end;

function TRetData.GetFormNumberFields(FormNo: integer): integer;
begin
  Result := FList.GetFormNumberFields(FormNo);
end;

function TRetData.GetFrm(Index: Integer): TFormData;
begin
  if (Index >= low(frm)) AND
     (Index <= High(Frm)) then
    Result := frm[Index]
  else
    Result := Nil;
end;

procedure TRetData.LoadTV(RetNo: integer; FName: string; FNo: integer);
var
  i, fld: integer;
  s: string;
  lclVarFRec: TFRec;
begin
  (* Assure that the form is valid.
  - check for related DFM file (should be done only once!)
    --> moved into determination of Calc routine
  - assert form was fully created, means:
    - Frm[] is not Nil
    - Frm[].Count is not zero
  *)
  if FNo < 1 then
    exit; //???

{$IFDEF old}
  //assume CalcAll lists all tax forms in use
  s := GetDfmFileName(FName);
  if not FileExists(s) then
    ErrorMsg('Missing DFM file: ' + s);
{$ELSE}
  //moved into Calc
{$ENDIF}

  //these should never happen
  if Frm[FNo] = nil then
    Frm[FNo] := TFormData.Create(RetNo, FNo)
  else if Frm[FNo].Count = 0 then
    InitFormData(FList.ByFormNoDummy(FNo));

  lclVarFRec := FList.FirstInstRec(FNo);
  with lclVarFRec do
  begin
    for i := 0 to high(DollarFields) do
    begin
      fld := DollarFields[i];
      TV[fld] := VL(Frm[fno].Elms[fld]);
    end;
  end;
  CalcWatch.ShowTV(RetNo, FName, TV, True); //before
end;

procedure TRetData.SaveTV(RetNo: integer; FName: string; FNo: integer);
var
  i, fld: integer;
  s: AnsiString; //20150701
  r: real;
  lclVarFRec: TFRec;
begin
  if FNo < 1 then
    exit; //???
  lclVarFRec := FList.FirstInstRec(FNo);
  with lclVarFRec do
  begin
    for i := 0 to high(DollarFields) do
    begin
      fld := DollarFields[i];
      r := TV[Fld];
      if r = 0 then
        s := ''
      else
        Str(r: 1: 2, s);
      Frm[FNo].Elms[Fld] := String(s); // AllTrim(s); //20150701
    end;
  end;

  if CalcWatch.ShowTV(RetNo, FName, TV, False) then //after
    CalcWatch.ShowModal;
end;

function TRetData.GetHasData(FName: string): boolean;
var
  FNo: integer;
begin
  FNo := GetFormNo(FName);
  Result := FrmHasData[FNo];
end;

procedure TRetData.SetHasData(FName: string; const Value: boolean);
var
  FNo: integer;
begin
  FNo := GetFormNo(FName);
  FrmHasData[FNo] := Value;
end;

procedure TRetData.SetCalcStatus(const Value: boolean);
begin
  FCalcStatus := Value;
end;

procedure TRetData.SetChanged(Value: boolean);
begin
  FChanged := Value
end;

procedure TRetData.ReadData(fs: TFileStorage; AFRec: TFRec);
var
  Var1, Var2, Var3, Var4: string;
  No: integer;
begin
  (* read D=Data,M=Memo,R=RTF data
  *)
  with Frm[AFRec.FormNo] do
  begin
    if not fs.ReadLine(Var1, var2, var3, var4) then
      exit; //eof
    No := StrToInt(var2);
    case var1[1] of
      'D': //D,elmNo,value,-
        SaveElmFromFile(AFRec.FormNo, No, var3);
      //'M':  //M,MemNo,Text,-
      //'R': ...
    else
      exit; //problem: data lost!
    end;
  end;
end;

procedure TRetData.WriteFData(AFRec: TFRec;
  ASQLite: TSQLiteStorage); //20160414 Igor
var
  i, ia: integer;
  lst: TStrings;
  s: string;
begin
  (* save D=Data,D=dyn data, 'M'=multi-line
  *)

  with Frm[AFRec.FormNo] do
  begin
    for i := 1 to Count - 1 do
    begin
      s := Strings[i];
      if (S <> '') then //20160415 Igor
        if not ASQLite.WriteData(AFRec.FormInstName, 'D', i, s) then
          raise Exception.Create(ASQLite.LastError);
    end;
    for i := 1 to AFRec.MaxMemo do
    begin
      s := Memos[i];
      if (S <> '') then //20160415 Igor
        if not ASQLite.WriteData(AFRec.FormInstName, 'M', i, s) then
          raise Exception.Create(ASQLite.LastError);
    end;
    if assigned(Dyn) then
    begin
      for ia := ArrayBase to high(Dyn) do
      begin
        for i := ElmBase to high(Dyn[ia]) do
        begin
          s := Dyn[ia, i];
          if not ASQLite.WriteData(AFRec.FormInstName, 'D', ia * ArrayMul + i, s) then
            raise Exception.Create(ASQLite.LastError);
        end;
      end;
    end;
  end;
end;

procedure TRetData.WriteLnEtc(LnLowBound, LnHighBound: integer;
  ASQLite: TSQLiteStorage = nil); //20160415 Igor
var
  i: integer;
  s: AnsiString; //20150701
begin
  (* Write R=ReviewMarks, L=Ln
  *)
  {Save overrides}
  for i := 0 to (OverList.Count - 1) do {O,Formname, Elm, value}
  begin
    TObject(OverRec) := OverList.Items[i];
    if (OverRec.RetNo = RetNo) then
    Begin
      if not ASQLite.WriteData(GetFormName(OverRec.FormNo), 'O', OverRec.FieldId, OverRec.Value) then
        raise Exception.Create(ASQLite.LastError);
    end;
  end;
  {Save review marks}
  for i := 0 to (ReviewList.Count - 1) do {R,Formname, Elm, Type}
  begin
    ReviewRec := ReviewList.Items[i];
    if (ReviewRec.RetNo = RetNo) then
    Begin
      if not ASQLite.WriteData(GetFormName(ReviewRec.FormNo), 'R', ReviewRec.FieldId, IntToStr(ReviewRec.Symbol)) then //20160617 Igor
        raise Exception.Create(ASQLite.LastError);
    end;
  end;
  {Save Line data}
  for i := 0 to Length(Ln) - 1 do //20190729 Igor
  begin
    if Ln[i] <> 0 then
    begin
      Str(Ln[i]: 13: 2, s);
      if not ASQLite.WriteData('Z_LINES', 'L', i, LTrim(RTrim(string(s)))) then
        raise Exception.Create(ASQLite.LastError);
    end;
  end;
  //20190729 Igor >>>
  {Save Lnn data}
  for I in FLn.Keys do
  begin
    if Lnn[i] <> 0 then
    begin
      Str(Lnn[i]: 13: 2, s);
      if not ASQLite.WriteData('Z_LINES', 'L', i, LTrim(RTrim(string(s)))) then
        raise Exception.Create(ASQLite.LastError);
    end;
  end;
  //20190729 Igor <<<
end;

function TRetData.GetFormByName(FName: string): TFormData;
var
  FNo: integer;
begin
  FNo := GetFormNo(FName);
  Result := Frm[FNo];
end;

procedure Isotropic(hDC: hdc; scale: integer);
//const Scale = 128; //64 --> 1/64"
begin
  SetMapMode(hDC, MM_ISOTROPIC);
  SetWindowExtEx(hDC, scale, scale, nil);
  SetViewportExtEx(hDC, GetDeviceCaps(hDC, LOGPIXELSX),
    GetDeviceCaps(hDC, LOGPIXELSY), nil);
end;

{$IFDEF unused}

procedure TRetData.Print(FName: string; pgNo: integer);
var
  AForm: TvtScrollBox; // TForm;
  FNo: integer;
  dfm: string;
begin
  (* print specified or all forms (-1) to the default printer
  *)
  //create and populate form
  dfm := GetDfmFileName(FName);
  if not FileExists(dfm) then
    exit; //msg: no DFM?
  FNo := GetFormNo(FName);
  //AForm := TForm.Create(Application);
//does this work?
  AForm := TvtScrollBox.Create(nil, RetNo, FNo);
  ReadComponentResFile(dfm, AForm);
  //Form[FName].PopulateWithData(AForm);
  AForm.PopulateFormWithData;
  AForm.Color := clWhite; //override RetColor
  AForm.Height := 1000;
  { TODO : separate pages }
  //print
    //AForm.Print; - ugly stretched bitmap
  with Printer do
  begin
    Title := FName; //default filename for PDF output
    BeginDoc;
    Isotropic(Handle, 120); //120 dpi?
    AForm.PaintTo(Handle, 10, 0);
    EndDoc;
  end;
end;
{$ELSE}
//test only
{$ENDIF}

function TRetData.ClrForm(FName: string): boolean;
//function TRetData.ClrForm(FRec: TFRec): boolean; //???
var
  FNo: integer;
  lclVarFRec: TFRec;
begin
  (* Override to clear/preset special forms
    Only clear single-page forms, multi-page becomes app-specific
  *)
  Result := False;
  if Locked then
  begin
    ErrorMsg('Cannot clear locked form: ' + FName);
    exit;
  end;
  lclVarFRec := FList.ByFormName(FName);
  FNo := lclVarFRec.FormNo;
  if FNo < 1 then
    exit; //bad call

  //valid form
  if Frm[FNo] = nil then
    Frm[FNo] := TFormData.Create(RetNo, FNo)
  else
    Frm[FNo].ClrForm;

  FrmHasData[FNo] := False;
  Result := True;
  //Calc(RetNo,FName,FNo); //depending on AppId?
end;

function TApp.ConvertToLastYearName(AFileName: String): String;
begin
  Result := AFileName;
end;

function TApp.CountReturnsInDB: Integer;//20170901 Igor
var
  C: TADConnection;
  Q: TADQuery;
begin
  if Not TFile.Exists(TPath.Combine(Self.Dir_Cur, Self.ClientsDBLite)) then
    exit(0);
  C := TADConnection.Create(Nil);
  try
    if Not SetConnection(C, TPath.Combine(Self.Dir_Cur, Self.ClientsDBLite), ClientsTableLite, False, False)  then
      exit(0);
    Q := TADQuery.Create(nil);
    try
      Q.Connection := C;
      Q.SQL.Text := 'SELECT COUNT(*) AS C from `'+ClientsTableLite+'`';
      Q.Open;
      Result := Q.FieldByName('C').AsInteger;
    finally
      Q.Free;
    end;
  finally
    C.Free;
  end;
end;

procedure TRetData.CloneForm(FromFormName: string; ToRetNo: integer;
  ToFormName: string; fAll: boolean);
var
  i: integer;
  lVarFRec, ToFRec: TFrec;
  FromFNo, ToFNo: integer;
  ToRet: TRetData;
begin
  (* Override for special actions after copying standard data
    Handle returns of different years.
  *)
  lVarFRec := FList.ByFormName(FromFormName);
  FromFNo := lVarFRec.FormNo;
  ToRet := RetList[ToRetNo];
  ToFRec := ToRet.FList.ByFormName(ToFormName);
  ToFNo := ToFRec.FormNo;
  if (FromFNo < 1) or (ToFNo < 1) then
    exit;
  if (RetNo = ToRetNo) and (FromFNo = ToFNo) then
    exit; //cannot clone form to itself
  if not ToRet.InitFormData(ToFRec) then
    exit; //form not created
  if not FrmHasData[FromFNo] then
    exit; //nothing more to do
  //copy non-array data
  if fAll then
    (* reading inexistent fields is harmless (empty strings),
      init fields as found in ToRet!
    *)
    for i := 1 to ToFRec.FormFields do
      ToRet.Frm[ToFNo].Elms[i] := Frm[FromFNo].Elms[i];
  //else special copy of selected fields (T1)
//copy array data
  ToRet.Frm[ToFNo].Dyn := Frm[FromFNo].Dyn;
  //copy multi-line (memo etc.) data?
  ToRet.Frm[ToFNo].Memos := Frm[FromFNo].Memos;
  //Ln data - must be recalculated!
end;

procedure TRetData.CloneReturn(ToRetNo: integer);
var
  i, j: integer;
  lVarFRec: TFRec;
  ToRet: TRetData;
begin
  for i := 1 to MyApp.FList.Count - 1 do
  begin
    lVarFRec := MyApp.FList.ByIndex(i);
    if lVarFRec.FormNo < 1 then
      continue;
    if FrmHasData[lVarFRec.FormNo] then
      CloneForm(lVarFRec.FormInstName, ToRetNo, lVarFRec.FormInstName, True);
  end;
  //from T2
    {copy other data}
  ToRet := RetList[ToRetNo];
  ToRet.Changed := True; // Changed;
  ToRet.SourceDataDir := SourceDataDir;
  ToRet.SourceFlName := SourceFlName;
  ToRet.PrpStatus := PrpStatus;
  ToRet.Province := Province;
  ToRet.Notes := Notes;
{$IFDEF old}
  for j := low(Ln) to high(Ln) do
    ToRet.Ln[j] := Ln[j];
{$ELSE}
  //20190627 Igor >>>
  //ToRet.Ln := Ln;
  ToRet.AssignLn(FLn);
  //20190627 Igor <<<
{$ENDIF}
end;

function TRetData.InitDataDirectory: Boolean;
begin
  Result := True;
end;

function TRetData.InitFormData(AFRec: TFRec): boolean;
var //i, NumFields: integer;
  FNo: integer;
begin
  (* Default procedure, allocates storage for the form.
    Does nothing when the form was already created.
    Override to init special fields with specific values.
  *)
{$IFDEF old}
  NumFields := GetFormNumberFields(FNo);
  if Frm[FNo].Count >= NumFields then
    exit; //ignore further calls
  Frm[FNo].ClrForm; //alloc
{$ELSE}
  //check valid FNo
  Result := False;
  if AFRec = nil then
    exit;
  FNo := AFRec.FormNo;
  if FNo < 1 then
    exit; //is dummy FRec?
  if FNo > high(Frm) then
  begin
    ErrorMsg('Exceeded Forms limit (FNo=' + IntToStr(FNo) + ')');
    exit;
  end;
  //okay
  if Frm[FNo] = nil then
    Frm[FNo] := TFormData.Create(RetNo, FNo);
  Result := True;
{$ENDIF}
end;

function TRetData.GetFormNo(const FormName: string): Integer;
begin
  Result := FList.ByFormName(FormName).FormNo;
end;

function TRetData.GetFirstName: string;
begin
  OVR('GetFirstName');
  Result := 'GetFirstName?';
end;

function TRetData.GetLastName: string;
begin
  OVR('GetLastName?');
  Result := '???';
end;

function TRetData.GetLastYearRetNo: Integer;
begin
  if assigned(Self) then //20160305 Igor
    Result := FLastYearRetNo
  else
    Result := 0;
end;

function TRetData.GetLn(AIndex: integer): real; //20190627 Igor
begin
  Result := 0.0;
  FLn.TryGetValue(AIndex, Result);
end;

function TRetData.GetInterpetedRichEdit(LetterName: string; ARichEdit: TRichEdit): boolean;
begin
  OVR('GetInterpetedRichEdit');
  Result := False;
end;

function TRetData.GetisCreateMDIChild: Boolean; //20161028 Igor
begin
  Result := (Self.MyChild <> nil) //201700704 Igor
end;

{ TRetList }

constructor TRetList.Create;
begin
  inherited Create(False); //don't own objects, allow for := nil!
  Add(nil); //dummy return
end;

procedure TRetList.GetListOfLoadedReturns(SomeList: TStrings; AApp: TApp; AWithOutAppendix: Boolean = False); //20161216 Igor //20170307 Igor
var
  i: integer;
begin
  SomeList.Clear;
  for i := 1 to (Count - 1) do
  begin
    RetRec := Items[i];
    //20161216 Igor >>>
    if (RetRec <> nil) and
       not RetRec.Destroying and
       (not AWithOutAppendix or not RetRec.isAppendix) and //20170307 Igor
       ((AApp = nil) or (RetRec.MyApp = AApp)) then
    //20161216 Igor <<<
      SomeList.AddObject(RetRec.GetReturnCaption, RetRec);
  end;
end;

function TRetList.GetRet(RetNo: integer): TRetData;
begin
  TObject(Result) := inherited Items[RetNo];
end;

procedure TRetList.RemoveReturn(RetNo: integer);
var
  r: RetPtr;
begin
  (* Close the return, and its ChildWin
    and floating forms. All this is done in return destructor!

    When return is NOT closing (RetNo>0) then close it and exit.
    Otherwise remove return.
  *)
  try
    if (RetNo <= 0) or (RetNo >= Count) then
      exit; //dummy call
    r := Items[RetNo];
    if r = nil then
      exit; //already removed
    if r.RetNo <> RetNo then
      exit; //bad call
    if not r.Destroying then //else already destroying
    begin
      r.Destroy; ////eventually activates an still existing return?
      exit; //calls back with RetNo=0
    end;

    begin
      inherited Items[RetNo] := nil; //flag removed - only after return really closed
      //RetNoChanged(0); //argument ignored
      if assigned(Application.MainForm) then
        MainForm.GuiCommand(gcReturns);
    end;
  except
    on e: exception do
      ErrorMsg('RemoveReturn: ' + e.Message);
  end;
end;

function TRetList.MustSave: boolean;
var
  RetNo: integer;
  lVarFRec: RetPtr;
begin
  //check for changed returns
  Result := True;
  for RetNo := Count - 1 downto 1 do
  begin
    lVarFRec := Items[RetNo];
    if assigned(lVarFRec) and lVarFRec.Changed then
      exit; //True - found changed return
  end;
  Result := False; //nothing changed
end;

function TRetList.AddRet(ARet: RetPtr): integer;
var
  i: integer;
begin
  (* always assign a new RetNo.
  Rationale: mainform gets confused by re-used RetNo
    (when a return is closed and another one is opened)
  *)
  Result := ARet.RetNo;
  if Result > 0 then
    exit; //already registered!
  if Count = 0 then
    Add(nil); //dummy item at RetNo=0
  Result := Add(ARet);
end;

procedure TRetList.Clear;
var
  i: integer;
  r: RetPtr;
begin
  (* Not all returns (OpenReturn) are closed properly!
    Must find out why not...
  *)
  for i := 1 to Count - 1 do
  begin
    r := Items[i];
    if r <> nil then
    begin
      r.Destroy; //recursion?
      inherited Items[i] := nil;
    end;
  end;
  inherited;
end;

function TRetList.TypedReturn(RetNo: integer;
  AClass: TRetDataClass; fWarn: boolean): TRetData;
begin
  (* returns the requested return only if it is of class AClass.
    Error message and Nil for other return type.
    Message can be suppressed with fWarn=False.
  *)
  Result := Items[RetNo];
  if Result is AClass then
    exit; //okay
  if fWarn then
    ErrorMsg('wrong return type');
  Result := nil;
end;

{ TFeesList }

function TFeesList.GetFeesRec(index: integer): PFeesList;
begin
  TObject(Result) := Items[index];
end;

{ TLicenseList }

constructor TLicenseList.Create;
begin
  inherited Create;
  //20180503 Igor >>>
  if StartParams.isCloud then
    FLicenseFile := TPath.Combine(CloudDir, LicenseFile) //20190213 Igor
  else
    FLicenseFile := TPath.Combine(ExeDir, LicenseFile);
  if FileExists(FLicenseFile) then
    LoadFromFile(FLicenseFile);
  //20180503 Igor <<<
end;

destructor TLicenseList.Destroy;
begin
//20170927 igor>>>
  if FChanged then
    SaveToFile(FLicenseFile); //20180503 Igor
//20170927 igor<<<
  inherited;
end;

function Crypt(const s: string): string;
var
  i: integer;
begin
  SetLength(Result, Length(s));
  for i := 1 to Length(s) do
    Result[i] := chr(ord(s[i]) xor $F); //no ctrl chars!
end;

procedure TLicenseList.Load; //20180503 Igor
begin
  LoadFromFile(FLicenseFile);
end;

procedure TLicenseList.LoadFromFile(const FileName: string);
var
  i: integer;
  s: string;
  lst: TStringList;
begin
  Clear; //20190307 Igor
  lst := TStringList.Create;
  ReadPgmFile(FileName, lst); //assume encrypted
  for i := 0 to lst.Count - 1 do
  begin
    s := lst.Strings[i];
    s := Crypt(s); // DecryptPsw(s, 9999);
    Add(s); //Strings[i] := s;
  end;
  lst.Free;
  FChanged := False;//20170927 igor
end;

procedure TLicenseList.Save; //20180503 Igor
begin
  SaveToFile(FLicenseFile);
end;

procedure TLicenseList.SaveToFile(const FileName: string);
//20181220
function IsValidKey(const aSLString: string = ''): Boolean; //20181210 Igor //20181213 Igor
  var
    MyApp: TApp;
    AppId: String;
    I: Integer;
  begin
    Result:= false;

    if Pos('=', aSLString) > 0 then
    begin
      AppId:= Copy(aSLString, 1, Pos('=', aSLString) - 1);
      MyApp:= AppList.AppFromID(AppId);
      if Assigned(MyApp) then
        Result:= MyApp.ValidateKey(Keys[AppId])
      else
      begin
        for I := 0 to HelperManager.HelperClassList.Keys.Count - 1 do
          if SameText(HelperManager.HelperClassList.Values.ToArray[I], AppId) then
          begin
            with HelperManager.HelperClassList.Keys.ToArray[I].Create do
            try
              Result := ValidateKey(Keys[AppId], ProjectYear); //20190307 Igor
            finally
              Free;
            end;
            break;
          end;
      end;
      //20181220 Igor >>>
      if not Result then
      begin
        if SameText(AppId, 'Password') then
        begin
          Result := True;
          Exit;
        end;
        for I := 0 to AppList.Count - 1 do
          if SameText(AppList.GetApp(I).ScanId, AppId) then
          begin
            Result := AppList.GetApp(I).ValidateScanKey(Keys[AppId]);
            break;
          end;
      end;
      //20181220 Igor <<<
    end;
  end;

(*
  function IsValidKey(const aSLString: string = ''): Boolean; //20181210 Igor //20181213 Igor
  var
    MyApp: TApp;
    AppId: String;
    I: Integer;
  begin
    Result:= false;

    if Pos('=', aSLString) > 0 then
    begin
      AppId:= Copy(aSLString, 1, Pos('=', aSLString) - 1);
      MyApp:= AppList.AppFromID(AppId);
      if Assigned(MyApp) then
        Result:= MyApp.ValidateKey(Keys[AppId])
      else
      begin
        for I := 0 to HelperManager.HelperClassList.Keys.Count - 1 do
          if SameText(HelperManager.HelperClassList.Values.ToArray[I], AppId) then
          begin
            with HelperManager.HelperClassList.Keys.ToArray[I].Create do
            try
              Result := ValidateKey(Keys[AppId]);
            finally
              Free;
            end;
            break;
          end;
      end;
    end;
  end;
*)
var
  lst: TStringList;
  s: string;
  i: integer;
begin
  (* save not-empty license list
  *)
  if Count = 0 then
    exit; //don't save empty list
  lst := TStringList.Create;
  for i := 0 to Count - 1 do
    if IsValidKey(Strings[i]) then //20181210 Igor
    begin
      s := Strings[i];
      s := Crypt(s); // EncryptPsw(s, 9999);
      lst.Add(s);
    end;
  //20181210 Igor >>>
  if lst.Count = 0 then
    exit; //don't save empty list
  //20181210 Igor <<<
  WritePgmFile(FileName, lst);
  lst.Free;
  FChanged := False;//20170927 igor
end;

function TLicenseList.GetPassword: string;
begin
  Result := Values['Password'];
end;

procedure TLicenseList.SetPassword(const Value: string);
begin
  Values['Password'] := Value;
end;

function TLicenseList.GetKeys(const AppId: string): string;
begin
  Result := Values[AppId];
end;

procedure TLicenseList.SetKeys(const AppId, Value: string);
begin
//20170927 igor>>>
  if Values[AppId] <> Value then
  begin
    Values[AppId] := Value;
    FChanged := True;
  end;
//20170927 igor<<<
end;

{ TMainOptions }

const
  LftPW = 'LeftPanelWidth';
  RgtPW = 'RightPanelWidth';
  FrmPH = 'FormPanelHeight'; //20160225 Igor
  RgtPAPI = 'RightPanelActivePageIndex'; //20160222 Igor
  MainL = 'MainLeft';
  MainT = 'MainTop';
  MainW = 'MainWidth';
  MainH = 'MainHeight';
  MainMx = 'MaximizeMainForm';
  NoLogin = 'SkipLogin';
  User_Id = 'SingleLoginId';
  FrmZoom = 'FormZoom';
  RghtZoom = 'RightZoom'; //20160209 Igor
  UpdFrq = 'UpdateFrequency';
  EscOpt = 'EscOption';
  LstUpd = 'LastUpdate';
  LstApp = 'LastAppId';
  HideRecent = 'HideMostRecent';
  PgmPwd = 'Pgmpwd';
  PrnLMargin = 'Prn_LMargin';
  PrnRMargin = 'Prn_RMargin';
  PrnFontIncr = 'Prn_FontIncr';
  DummyPassword = 'passworD';
  RetPanVis = 'ReturnsPanelVisible'; //20160426 Igor
  AudPanVis = 'AuditPanelVisible'; //20160426 Igor
  FormPanVis = 'FormsPanelVisible'; //20160426 Igor
  DisabledApps = 'DisabledApps'; //20160526 Igor
  LockManLvl = 'LockManagerLevel'; //20170315 Igor
  Skin_ID = 'Skin';//20170824 Igor
  ActiveTabColor_ID = 'ActiveTabColor'; //20180111 Igor

//20170315 Igor >>>
function IntToLockManagerLevel(AValue: Integer): TLockManagerLevel;
begin
  case AValue of
    1: Result := lmlAllowMultiWrite;
    2: Result := lmlDeniedMultiWrite;
  else Result := lmlDisableLock;
  end;
end;
//20170315 Igor <<<


constructor TMainOptions.Create;
begin
  inherited Create;
  FDisabledApp := TStringList.Create; //20160526 Igor
  load;
end;

procedure TMainOptions.DelDisabledApp(const AppID: String); //20160526 Igor
begin
  if FDisabledApp.IndexOf(AppID) <> -1 then
  begin
    FDisabledApp.Delete(FDisabledApp.IndexOf(AppID));
    SaveSingle(DisabledApps, FDisabledApp.CommaText);
  end;
end;

destructor TMainOptions.Destroy;
begin
  save;
  if assigned(FDisabledApp) then
    FDisabledApp.Free; //20160526 Igor
  inherited;
end;
//20160114 Igor
procedure TMainOptions.SetFormZoom(Value:Integer);
Begin
  if Value < GC_MINSCALE then
    Value := GC_MINSCALE;
  if Value > GC_MAXSCALE then
    Value := GC_MAXSCALE;
  if Value = FFormZoom then
    Exit;
  FFormZoom := Value;
  CallBackZoom; //20160209 Igor
end;

procedure TMainOptions.SetActiveTabColor(Value: TColor); //20180111 Igor
begin
  if Value <> FActiveTabColor then
    FActiveTabColor := Value;
end;

procedure TMainOptions.SetRightZoom(Value:Integer); //20160209 Igor
Begin
  if Value < GC_MINSCALE then
    Value := GC_MINSCALE;
  if Value > GC_MAXSCALE then
    Value := GC_MAXSCALE;
  if Value = FRightZoom then
    Exit;
  FRightZoom := Value;
  CallBackZoom;
end;

procedure TMainOptions.SetSkin(const Value: TSkin);
begin
  if Value <> FSkin then
  begin
    FSkin := Value;
    MainForm.GuiCommand(gcChangeSkin);
  end;
end;

procedure TMainOptions.SetlblZoom(Value: TLabel);
begin
  if Value = flblZoom then exit;
  flblZoom := Value;
  CallBackZoom; //20160209 Igor
end;

procedure TMainOptions.SetOptions(AOptionsName, AOptionsValue: String); //20170127 Igor
begin
  if SameText(AOptionsName, LftPW) then
    LeftPanelWidth := StrToIntDef(AOptionsValue, Screen.Monitors[0].Width div 4)
  else
  if SameText(AOptionsName, RgtPW) then
    RightPanelWidth := StrToIntDef(AOptionsValue, Screen.Monitors[0].Width div 4)
  else
  if SameText(AOptionsName, FrmPH) then
    FormPanelHeight := StrToIntDef(AOptionsValue, ROUND(Screen.Monitors[0].Height * 0.3))
  else
  if SameText(AOptionsName, RgtPAPI) then
    RightPanelActivePageIndex := StrToIntDef(AOptionsValue, 1)
  else
  if SameText(AOptionsName, MainL) then
    MainLeft := StrToIntDef(AOptionsValue, 0)
  else
  if SameText(AOptionsName, MainT) then
    MainTop := StrToIntDef(AOptionsValue, 0)
  else
  if SameText(AOptionsName, MainW) then
    MainWidth := StrToIntDef(AOptionsValue, Screen.Monitors[0].Width)
  else
  if SameText(AOptionsName, MainH) then
    MainHeight := StrToIntDef(AOptionsValue, Screen.Monitors[0].Height)
  else
  if SameText(AOptionsName, PrnLMargin) then
    Prn_LMargin := StrToFloatDef(AOptionsValue, 0.75)
  else
  if SameText(AOptionsName, PrnRMargin) then
    Prn_RMargin := StrToFloatDef(AOptionsValue, 0.5)
  else
  if SameText(AOptionsName, PrnFontIncr) then
    Prn_FontIncr := StrToIntDef(AOptionsValue, 1)
  else
  if SameText(AOptionsName, MainMx) then
    MaximizeMainForm := StringToBoolean(AOptionsValue)
  else
  if SameText(AOptionsName, NoLogin) then
    SkipLogin := StringToBoolean(AOptionsValue)
  else
  if SameText(AOptionsName, User_Id) then
    SingleLoginId := AOptionsValue
  else
  if SameText(AOptionsName, HideRecent) then
    HideMostRecent := StringToBoolean(AOptionsValue)
  else
  if SameText(AOptionsName, FrmZoom) then
    FormZoom := StrToIntDef(AOptionsValue, 100)
  else
  if SameText(AOptionsName, RghtZoom) then
    RightZoom := StrToIntDef(AOptionsValue, 100)
  else
  if SameText(AOptionsName, UpdFrq) then
    UpdateFrequency := StrToIntDef(AOptionsValue, 20)
  else
  if SameText(AOptionsName, EscOpt) then
    EscOption := AOptionsValue
  else
  if SameText(AOptionsName, LstUpd) then
    LastUpdateCheck := AOptionsValue
  else
  if SameText(AOptionsName, LstApp) then
    LastAppId := AOptionsValue
  else
  if SameText(AOptionsName, RetPanVis) then
    ReturnsPanelVisible := StringToBoolean(AOptionsValue)
  else
  if SameText(AOptionsName, AudPanVis) then
    AuditPanelVisible := StringToBoolean(AOptionsValue)
  else
  if SameText(AOptionsName, FormPanVis) then
    FormsPanelVisible := StringToBoolean(AOptionsValue)
  else
  if SameText(AOptionsName, DisabledApps) then
    FDisabledApp.CommaText := AOptionsValue
  //20170315 Igor >>>
  else
  if SameText(AOptionsName, LockManLvl) then
    LockManagerLevel := IntToLockManagerLevel(StrToIntDef(AOptionsValue,0))
  //20170315 Igor <<<
  //20170315 Igor >>>
  else
  if SameText(AOptionsName, Skin_ID) then
    Skin := TSkin(StrToIntDef(AOptionsValue,0));
  //20170315 Igor <<<
end;

procedure TMainOptions.SetZoomForm(Value: TZoomForm);
begin
  if Value = FZoomForm then exit;
  FZoomForm := Value;
  CallBackZoom; //20160209 Igor
end;

procedure TMainOptions.SetRightPanelActivePageIndex(Value: Integer); //20160221 Igor
Begin
  if Value = FRightPanelActivePageIndex then exit;
  FRightPanelActivePageIndex := Value;
end;

function TMainOptions.GetRightPanelActivePageIndex:Integer; //20160221 Igor
Begin
  Result := FRightPanelActivePageIndex;
end;

procedure TMainOptions.AddDisabledApp(const AppID: String); //20160526 Igor
begin
  if FDisabledApp.IndexOf(AppID) = -1 then
  begin
    FDisabledApp.Add(AppID);
    SaveSingle(DisabledApps, FDisabledApp.CommaText);
  end;
end;

procedure TMainOptions.CallBackZoom; //20160209 Igor
var
  tbonChange : TNotifyEvent;
  I: Integer;
begin
  case ZoomForm of
    zfAll,zfCenter:Begin
      if Assigned(flblZoom) then
        flblZoom.Caption := IntToStr(FFormZoom)+'%';
      if Assigned(FtbZoom) then
      Begin
        tbonChange := FtbZoom.OnChange;
        FtbZoom.OnChange := nil;
        FtbZoom.Position := FFormZoom div 5;
        FtbZoom.OnChange := tbonChange;
      end;
      for I := 0 to AppList.Count - 1 do
        TApp(AppList.Objects[I]).SetZoomCaption(MainOptions.FormZoom);
    end;
    zfRight: Begin
      if Assigned(flblZoom) then
        flblZoom.Caption := IntToStr(FRightZoom)+'%';
      if Assigned(FtbZoom) then
      Begin
        tbonChange := FtbZoom.OnChange;
        FtbZoom.OnChange := nil;
        FtbZoom.Position := FRightZoom div 5;
        FtbZoom.OnChange := tbonChange;
      end;
      for I := 0 to AppList.Count - 1 do
        TApp(AppList.Objects[I]).SetZoomCaption(MainOptions.RightZoom);
    end;
  end;
end;

procedure TMainOptions.SettbZoom(Value: TTrackBar);
begin
  if Value = ftbZoom then exit;
  ftbZoom := Value;
  if Assigned(ftbZoom) then
    SettbZoomParams;
end;

procedure TMainOptions.SettbZoomParams;
begin
  if not Assigned(tbZoom) then exit;
  tbZoom.Min := GC_MINSCALE div 5;
  tbZoom.Max := GC_MAXSCALE div 5;
end;

//20160114 Igor
function TMainOptions.GetFormZoom: Integer;
Begin
  Result := FFormZoom;
end;

function TMainOptions.GetRightZoom: Integer; //20160209 Igor
Begin
  Result := FRightZoom;
end;

function TMainOptions.HaveOptions(AOptionsName: String): Boolean; //20170112 Igor
begin
  Result := SameText(AOptionsName, LftPW) or
            SameText(AOptionsName, RgtPW) or
            SameText(AOptionsName, FrmPH) or
            SameText(AOptionsName, RgtPAPI) or
            SameText(AOptionsName, MainL) or
            SameText(AOptionsName, MainT) or
            SameText(AOptionsName, MainW) or
            SameText(AOptionsName, MainH) or
            SameText(AOptionsName, PrnLMargin) or
            SameText(AOptionsName, PrnRMargin) or
            SameText(AOptionsName, PrnFontIncr) or
            SameText(AOptionsName, MainMx) or
            SameText(AOptionsName, NoLogin) or
            SameText(AOptionsName, User_Id) or
            SameText(AOptionsName, HideRecent) or
            SameText(AOptionsName, FrmZoom) or
            SameText(AOptionsName, RghtZoom) or
            SameText(AOptionsName, UpdFrq) or
            SameText(AOptionsName, EscOpt) or
            SameText(AOptionsName, LstUpd) or
            SameText(AOptionsName, LstApp) or
            SameText(AOptionsName, RetPanVis) or
            SameText(AOptionsName, AudPanVis) or
            SameText(AOptionsName, FormPanVis) or
            SameText(AOptionsName, DisabledApps) or
            SameText(AOptionsName, LockManLvl) or //20170315 Igor
            SameText(AOptionsName, Skin_ID);//20170824 Igor
end;

function TMainOptions.IsDisabledApp(const AppID: String): Boolean; //20160526 Igor
begin
  Result := FDisabledApp.IndexOf(AppID) <> -1;
end;

procedure TMainOptions.Load;
var
  lst: tstringlist;
  function OptStr(const AName: string): string;
  begin
    Result := lst.Values[AName];
  end;

  function OptInt(const AName: string): integer;
  begin
    Result := StrToIntDef(OptStr(AName), 0);
  end;

  function OptBool(const AName: string): boolean;
  begin
    Result := StringToBoolean(OptStr(AName));
  end;

  function OptFloat(const AName: string): Real; //20160204 Igor
  var
    S: String;
  begin
    S := OptStr(AName);
    if S = '' then
      result := 0
    else
    Begin
      S := ReplaceStr(S,',',FormatSettings.DecimalSeparator);
      S := ReplaceStr(S,'.',FormatSettings.DecimalSeparator);
      Result := StrToFloatDef(S,0);
    end;
  end;
var
  FName: string;
begin
  FName := GetExeDir + '\' + OptionsFlName; //20190513 Igor
  //20160406 Igor >>>
  if not FileExists(FName) then
  Begin
    LeftPanelWidth := Screen.Monitors[0].Width div 4;
    RightPanelWidth := Screen.Monitors[0].Width div 4;
    FormPanelHeight := ROUND(Screen.Monitors[0].Height * 0.3);
    RightPanelActivePageIndex := 1;
    MainLeft := 0;
    MainTop := 0;
    MainWidth := Screen.Monitors[0].Width;
    MainHeight := Screen.Monitors[0].Width;
    MaximizeMainForm := true;
    SkipLogin := False;
    SingleLoginId := 'ADMIN';
    HideMostRecent := False;
    FormZoom := 100;
    RightZoom := 100;
    UpdateFrequency := 20;
    EscOption := 'CloseForm';
    LastUpdateCheck := '';
    LastAppId := '';
    Prn_LMargin := 0.75; //20160721 Igor
    Prn_RMargin := 0.5;  //20160721 Igor
    Prn_FontIncr := 0;
    FReturnsPanelVisible := true; //20160426 Igor
    FAuditPanelVisible := true; //20160426 Igor
    FFormsPanelVisible := true; //20160426 Igor
    FOptionsLoaded := true;
    FLockManagerLevel := lmlDisableLock; //20170315 Igor
    FActiveTabColor := Rgb(128, 180, 128); //20180111 Igor
    Save;
  end;
  //20160406 Igor <<<
  Valid := FileExists(FName);
  if not Valid then exit;
  


  //  lst := self; //mine 20150702
  lst:=TStringList.Create;  //mine 20150702
  try
    lst.LoadFromFile(FName);
    LeftPanelWidth := OptInt(LftPW);
    RightPanelWidth := OptInt(RgtPW);
    FormPanelHeight := OptInt(FrmPH); //20160225 Igor
    if OptStr(RgtPAPI) = '' then //20160221 Igor
      RightPanelActivePageIndex := 1
    else
      RightPanelActivePageIndex := OptInt(RgtPAPI);
    MainLeft := OptInt(MainL);
    MainTop := OptInt(MainT);
    MainWidth := OptInt(MainW);
    MainHeight := OptInt(MainH);
    // 20180619 Igor >>>
    if MainLeft + MainWidth > Screen.DesktopLeft + Screen.DesktopWidth then
      MainLeft := Screen.DesktopLeft + Screen.DesktopWidth - MainWidth;
    if MainTop + MainHeight > Screen.DesktopTop + Screen.DesktopHeight then
      MainTop := Screen.DesktopTop + Screen.DesktopHeight - MainHeight;
    if MainLeft < Screen.DesktopLeft then
      MainLeft := Screen.DesktopLeft;
    if MainTop < Screen.DesktopTop then
      MainTop := Screen.DesktopTop;
    // 20180619 Igor <<<
    MaximizeMainForm := OptBool(MainMx);
    SkipLogin := OptBool(NoLogin);
    SingleLoginId := OptStr(User_Id);
    HideMostRecent := OptBool(HideRecent);
    FormZoom := OptInt(FrmZoom);
    if FormZoom <= 0 then
      FormZoom := 100;
    RightZoom := OptInt(RghtZoom); //20160209 Igor
    if RightZoom <= 0 then //20160209 Igor
      RightZoom := FormZoom; //20160209 Igor
    UpdateFrequency := OptInt(UpdFrq);
    EscOption := OptStr(EscOpt);
    LastUpdateCheck := OptStr(LstUpd);
    LastAppId := OptStr(LstApp);
    Prn_LMargin := OptFloat(PrnLMargin); //20160204 Igor
    Prn_RMargin := OptFloat(PrnRMargin); //20160204 Igor
    Prn_FontIncr := OptInt(PrnFontIncr);
    //20160426 Igor >>>
    FReturnsPanelVisible := OptBool(RetPanVis);
    FAuditPanelVisible := OptBool(AudPanVis);
    FFormsPanelVisible := OptBool(FormPanVis);
    if not (FReturnsPanelVisible or FAuditPanelVisible or FFormsPanelVisible) then
    Begin
      FReturnsPanelVisible := true;
      FAuditPanelVisible := true;
      FFormsPanelVisible := true;
    end;
    //20160426 Igor<<<
    if not assigned(FDisabledApp) then
      FDisabledApp := TStringList.Create;
    FDisabledApp.CommaText := OptStr(DisabledApps);
    FLockManagerLevel := IntToLockManagerLevel(OptInt(LockManLvl)); //20170315 Igor
    FSkin := TSkin(OptInt(Skin_ID)); //20170315 Igor
    //20180111 Igor >>>
    if lst.Values[ActiveTabColor_ID] = '' then
      FActiveTabColor := Rgb(128, 180, 128)
    else
      FActiveTabColor := TColor(OptInt(ActiveTabColor_ID));
    //20180111 Igor <<<
    FOptionsLoaded := true;//20160225 Igor
  finally
    freeAndNil(lst); //20160720 Igor
  end;
end;

function TMainOptions.ReadOptions(AOptionsName: String): string; //20170127 Igor
begin
  if FileExists(GetExeDir + '\' + OptionsFlName) then //20190513 Igor
  begin
    with TStringList.Create do
      try
         LoadFromFile(GetExeDir + '\' + OptionsFlName); //20190513 Igor
         Result := Values[AOptionsName];
      finally
        free;
      end;
  end
  else
    Result := '';
end;

procedure TMainOptions.Save;
var
  lst: TStringList;
begin
  //convert our options
  if not FOptionsLoaded then exit; //20160225 Igor

  lst := TStringList.Create;
  lst.Values[LftPW] := IntToStr(LeftPanelWidth);
  lst.Values[RgtPW] := IntToStr(RightPanelWidth);
  lst.Values[FrmPH] := IntToStr(FormPanelHeight); //20160225 Igor
  lst.Values[RgtPAPI] := IntToStr(RightPanelActivePageIndex); //20160221 Igor
  lst.Values[MainL] := IntToStr(MainLeft);
  lst.Values[MainT] := IntToStr(MainTop);
  lst.Values[MainW] := IntToStr(MainWidth);
  lst.Values[MainH] := IntToStr(MainHeight);
  lst.Values[PrnLMargin] := FloatToStr(Prn_LMargin); //20160204 Igor
  lst.Values[PrnRMargin] := FloatToStr(Prn_RMargin); //20160204 Igor
  lst.Values[PrnFontIncr] := IntToStr(Prn_FontIncr);
  lst.Values[MainMx] := BooleanToString(MaximizeMainForm);
  lst.Values[NoLogin] := BooleanToString(SkipLogin);
  lst.Values[User_Id] := SingleLoginId;
  lst.Values[HideRecent] := BooleanToString(HideMostRecent);
  lst.Values[FrmZoom] := IntToStr(FormZoom);
  lst.Values[RghtZoom] := IntToStr(RightZoom); //20160209 Igor
  lst.Values[UpdFrq] := IntToStr(UpdateFrequency);
  lst.Values[EscOpt] := EscOption;
  lst.Values[LstUpd] := LastUpdateCheck;
  if CurrentApp <> nil then
    lst.Values[LstApp] := CurrentApp.AppId;
  lst.Values[RetPanVis] := BooleanToString(FReturnsPanelVisible); //20160426 Igor
  lst.Values[AudPanVis] := BooleanToString(FAuditPanelVisible); //20160426 Igor
  lst.Values[FormPanVis] := BooleanToString(FFormsPanelVisible); //20160426 Igor
  if assigned(FDisabledApp) then
    lst.Values[DisabledApps] := FDisabledApp.CommaText;
  lst.Values[LockManLvl] := IntToStr(Integer(FLockManagerLevel)); //20170315 Igor
  lst.Values[Skin_ID] := IntToStr(Integer(Skin));//20170824 Igor
  lst.Values[ActiveTabColor_ID] := IntToStr(ActiveTabColor);//20170824 Igor
  lst.SaveToFile(GetExeDir + '\' + OptionsFlName); //20190513 Igor
  lst.Free;
end;

procedure TMainOptions.SaveSingle(const AName, AValue: String);
var
  lst: TStringList;
begin
  lst := TStringList.Create;
  try
    //20190513 Igor >>>
    if FileExists(GetExeDir + '\' + OptionsFlName) then
      lst.LoadFromFile(GetExeDir + '\' + OptionsFlName);
    lst.Values[AName] := AValue;
    lst.SaveToFile(GetExeDir + '\' + OptionsFlName);
    //20190513 Igor <<<
  finally
    lst.Free;
  end;
end;

{ TErrorLogger }
//20170927 Igor>>>
procedure TErrorLogger.ApplicationException(Sender: TObject; E: Exception);
begin
  Log(E.Message);
  Application.ShowException(E);
end;

destructor TErrorLogger.Destroy;
begin
  EXIT;   //20180313 CON  NO need to show anything. If we need we can ask for a copy of the VtErrors.txt
  LogName := LogName; //flush
  if Count > 0 then
    {$IFDEF INTERNAL_SENDMAIL}
    if MessageDlg('Errors occured! Do you wont send report to vender?', mtWarning, [mbYes, mbNo], 0) = mrYes then
      SendReport;
    {$ELSE}
    //20180313 Igor >>>
    if False then
      MessageDlg('Errors occured!' + #13 +
                 'See "' + FLogName + '"', mtWarning, [mbOk], 0);
    //20180313 Igor <<<
    {$ENDIF}
  inherited;
end;

procedure TErrorLogger.Log(const Msg: string);
begin
  Add(FormatDateTime('YYYY.MM.DD hh:nn:ss', Now) + ': ' + Msg);
  try
    if not LogName.IsEmpty and ForceDirectories(ExtractFilePath(LogName)) then
      with TFile.AppendText(LogName) do
        try
          WriteLine(FormatDateTime('YYYY.MM.DD hh:nn:ss', Now) + ': ' + Msg);
        finally
          Free;
        end;
  except ON E: Exception do
    begin
    end;
  end;
end;

procedure TErrorLogger.SendReport;
begin
{TODO: }
end;
//20170927 igor<<<

procedure TErrorLogger.SetLogName(const Value: string);
begin
  FLogName := Value;
end;

type
  TMyCtrl = class(TControl)
  public
    property OnClick;
  end;

  { TApp }

procedure TApp.CallExecuteForm(AFormID: Integer); //20170703 Igor
begin
//
end;
function TApp.CanRebuildCorruptedDatabase: boolean; //20200317 Igor
begin
  Result := false;
end;

//20170927 igor>>>
procedure MyXOR(var S: String; const r1, r2, r3: Integer);
var
  X: Integer;
begin
  X := r1 * 1000 + r2 * 100 + r3 * 10 + r2 + r1 + ((r1 + r2 + r3) mod 5) * 10000;
  S := PaddZero(IntToStr(StrToInt(S) xor X), 5);
end;

function TApp.GetDemoDateExpiration(AKey: String = ''): TDateTime;
var
  LicenseRec: PPgmLicenseData;
  ll: eLicenseLevel;
  A: TArray<String>;
  r1, r2, r3, I: Integer;
  S: String;
  D: TDate;
begin
  if AKey = '' then
  begin
    AKey := Self.GetLicenseKey;
    ll := Self.LicenseLevel;
  end
  else
  begin
    LicenseRec := Licenses;
    while LicenseRec.Level <> llNone do
    begin
      if LeftStr(AKey, 4) = LicenseRec.Id then
        break; //found it
      inc(LicenseRec); //next record
    end;
    ll := LicenseRec.Level;
  end;
  if ll = llDemo then
  begin
    A := AKey.Split(['-']);
    S := A[1] + Copy(A[2], 1, 1);
    r1 := StrToInt(A[2][2]);
    r2 := StrToInt(A[2][3]);
    r3 := StrToInt(A[2][4]);
    MyXOR(S, r1, r2, r3);
    Result := StrToInt(S);
  end
  else
    Result := Date + 365; //always > date
end;

function TApp.GenerateOneDayDemoKey: String;
  procedure GenerateMid(ADate: TDateTime; out ARandom1, ARandom2: String);
  var
    S: String;
    r1, r2, r3: Integer;
  begin
    repeat
      S := IntToStr(Trunc(ADate));
      randomize;
      r1 := Random(9);
      r2 := Random(9);
      r3 := Random(9);
      MyXOR(S, r1, r2, r3);
    until Length(S) = 5;

    ARandom1 := copy(S, 1, 4);
    ARandom2 := copy(S, 5, 1) + IntToStr(r1) + IntToStr(r2) +IntToStr(r3);
  end;
var
  Random1, Random2: String;
  LicenseRec: PPgmLicenseData;
begin
  LicenseRec := Licenses;
  while LicenseRec.Level <> llNone do
  begin
    if LicenseRec.Level = llDemo then
    begin
      GenerateMid(Date, Random1, Random2);
      Result := LicenseRec.Id + '-' + Random1 + '-' + Random2;
      Result := Result + '-' + MakeHashString(Result, LicenseRec.Factor, Self.Factor2);
      break; //found it
    end;  
    inc(LicenseRec); //next record
  end;
end;
//20170927 igor<<<

Function TApp.CheckDateExpiration(AKey: String; AMessage: Boolean = False): Boolean;//20170803 Igor
var
  D: TDateTime;
begin
  D := GetDemoDateExpiration(AKey);
  Result := (Date <= D);
  if Date > D then
  begin
    if AMessage then
      MessageDlg(Format('The license for the demonstration version of the tax module "%s" has expired. '+
                        '"%s" module is disabled.', [Self.AppId, Self.AppId]), mtWarning, [mbOk], 0);
    SetDisabled(True);
  end
  else
  if AMessage AND ((Date + 7) >= D)  then
    MessageDlg(Format('The license period for the demo version of the tax module "%s" expires after %d day(s).',
                      [Self.AppId, ROUND(D - Date)]), mtWarning, [mbOk], 0);
end;

procedure TApp.ConvertDataBase;//20150119 Igor
begin
  vtDataModuleUnit.DataBaseCreate(self.SQLLitePassword,
    self.ClientsDBLite,
    IncludeTrailingPathDelimiter(self.Dir_Cur),
    IncludeTrailingPathDelimiter(AppDir));
  if not CheckTableStructure(Self) then  //20160226 Igor;
  Begin
    MessageDlg('The structure of the database is not updated. The program can not be started!',
               mtWarning,[mbOk],0);
    Halt;
    exit;
  end;
end;

constructor TApp.Create(AAppList: TAppList); // 20151116 Igor
begin
//20170927 igor>>>
  inherited Create;
  AAppList.RegisterApp(self);
  FDisabled := False;
  NeedUpdate := True;
  GetLicenseLevel;
//20170927 igor<<<
end;

procedure TApp.DelReviewDynamicForm(AFormName: String); //20160220 Igor
begin
  if not Assigned(FReviewDynamicForm) then exit;
  if FReviewDynamicForm.IndexOf(AFormName) >= 0 then
    FReviewDynamicForm.Delete(FReviewDynamicForm.IndexOf(AFormName));
end;

destructor TApp.Destroy;
begin
//20170515 Igor >>>
//  StringLists.Free;
//20170515 Igor <<<
  FList.Free;
  if assigned(FReviewStaticForm) then //20160220 Igor
    freeAndNil(FReviewStaticForm);
  if assigned(FReviewDynamicForm) then //20160220 Igor
    freeAndNil(FReviewDynamicForm);
  if assigned(FSQLitePassword) then //20160303 Igor
    freeAndNil(FSQLitePassword);
  inherited;
end;

function TApp.ValidateScanKey(AKey: string): boolean;
begin
  Result := False; //must override
end;

function TApp.vtMobileFilePath: String;
begin
  Result := '';
end;

function TApp.GetLicenseKey: String;
begin
  Result := LicenseList.Keys[Self.AppId];
end;

procedure TApp.GetLicenseLevel;
var
  s: string;
  OldKey: String; //20160721 Igor
begin
  (* Called when the LicenseList has changed.
    global part reads the installation file,
    AppId part compares with ActivationFile

    Override to also handle ScanLicense!
  *)
  s := LicenseList.Values[AppID];

  if ValidateKey(s) then
    SetLicense(s)
  else
  //20170927 igor>>>
  // 20180917 Igor >>>
  // switch off one day demo generation
  {if StartParams.isCloud and StartParams.IsDemo then
  begin
    S := GenerateOneDayDemoKey;
    LicenseList.Save; //20180503 Igor
    LicenseList.Keys[AppId] := S;
    SetLicense(S);
  end
  else}
  // 20180917 Igor <<<
  if ExistsPrevKey(AppId, OldKey) then
  begin
    if ValidateKey(OldKey) then
    Begin
      LicenseList.Keys[AppId] := OldKey;
      LicenseList.Save; //20180503 Igor
      SetLicense(OldKey);
    End;
  end;
  //20170927 igor<<<
end;

function TApp.GetLimitReturns: Integer;//20170901 Igor
begin
  Result := FLimitReturns;
end;

function TApp.GetOptions: TStringList; //20160602 Igor
var
  tmp: TStringList;
  I: Integer;
  Nm, Vl: String;
begin
  Result := TStringList.Create;
  if FileExists(IncludeTrailingPathDelimiter(AppDir)+OptionsFlName) then
  Begin
    tmp := TStringList.Create;
    try
      tmp.LoadFromFile(IncludeTrailingPathDelimiter(AppDir)+OptionsFlName);
      for I := 0 to tmp.Count - 1 do
      Begin
        nm := trim(LeftStr(tmp[I],20));
        vl := MidStr(tmp[I],21, 250);
        if vl <> '' then
          Result.Values[nm] := vl
        else
          Result.Add(nm+'=');
      End;
    finally
      tmp.free;
    end;

  End;

end;

procedure TApp.GetOverloadedProperty; //20170112 Igor
var
  ctx: TRttiContext;
  objType: TRttiType;
  Field: TRttiField;
  FieldName: String;
  FieldValue: TValue;

const
  SavedTypes: TTypeKinds = [tkInteger, tkChar, tkEnumeration, tkFloat, tkString, tkUString];
begin
  if User.UserName = '' then
    exit;
  //20170131 Igor >>>
  if not (Self.LicenseLevel in anyMulti) then
    exit;
  //20170131 Igor <<<

  ctx := TRttiContext.Create;
  objType := ctx.GetType(Self.ClassInfo);
  for Field in objType.GetFields do
  Begin
    if (Field.FieldType.TypeKind in SavedTypes) AND
       (Field.Visibility = mvPublic) then
    begin
      FieldName := Field.Name;
      FieldValue := Field.GetValue(Self);
      if User.OverloadedProperty(Self, FieldName, FieldValue) then
        Field.SetValue(Self, FieldValue);
    end;
  End;
end;

function TApp.GetPswElm: Integer; //20161028 Igor
begin
  Result := -1;
end;

function TApp.GetReviewDynamicFormName(Index: Integer): string; //20160220 Igor
begin
  if not assigned(FReviewDynamicForm) or (Index <0) or (Index > CountReviewDynamicForm) then
    Result := ''
  else
    Result := FReviewDynamicForm[Index];
end;

function TApp.GetReviewStaticFormName(Index: Integer): string; //20160220 Igor
begin
  if not assigned(FReviewStaticForm) or (Index <0) or (Index > CountReviewStaticForm) then
    Result := ''
  else
    Result := FReviewStaticForm[Index];
end;

procedure TApp.SetBNText(const Value: string); //20191015 Igor
begin
end;

procedure TApp.SetDisabled(const Value: Boolean);
begin
//20170803 Igor>>>
  FDisabled := Value;
  if FDisabled or (Date > GetDemoDateExpiration(Self.GetLicenseKey)) then
  begin
    FDisabled := True;
    MainOptions.AddDisabledApp(AppId)
  end
  else
    MainOptions.DelDisabledApp(AppId);
//20170803 Igor<<<
end;

procedure TApp.SetLicense(const Key: string);
begin
  (* The key has been validated before.
    Initialize all affected class members.
    Override to update the splash screen. - extra?
  *)
  LicenseRec := Licenses;
  while LicenseRec.Level <> llNone do
  begin
    if LeftStr(Key, 4) = LicenseRec.Id then
      break; //found it
    inc(LicenseRec); //next record
  end;
  //now LicenseRec is the selected or last (unlicensed) one
  FLicLevel := LicenseRec.Level;
  FLicCaps := LicenseRec.Caps;
  FProductName := GetProductName(LicenseRec);
  FLimitReturns := LicenseRec.LimitReturns; //20170502 igor
  FLimitedFormList := '';//20171018 Igor
  //20170802 Igor>>>
  if FLicLevel in anyLimited then
    CreateDefaultDataDirectories;
  if FLicLevel = llDemo then
    CheckDateExpiration(Key, not (StartParams.isCloud and StartParams.FIsDemo));//20170927 igor
  //20170802 Igor<<<
  //20171017 Igor>>>
  if FLicLevel = llLimitedForms then
    SetLimitedFormList(Key);
  //20171017 Igor<<<
end;
//20171017 Igor>>>
procedure TApp.SetLimitedFormList(const Key: string);
  procedure ExtractKeyItemFromInt(const aValue: integer; const aKeyItems: TList<integer>);
    function GetBit(Value: Word; Index: Byte): Boolean;
    begin
      Result := ((Value shr Index) and 1) = 1;
    end;
  var
    i: integer;
  begin
    for I := 0 to 15 do
    begin
      if GetBit(aValue, i) then
        aKeyItems.Add(i);
    end;
  end;
var
  A: TArray<String>;
  r1, r2, r3, I, l, n, m: Integer;
  S: String;
  AKeyItems: TList<integer>;
  lclVarFRec: TFRec;
begin
  A := Key.Split(['-']);
  S := A[1] + Copy(A[2], 1, 1);
  r1 := StrToInt(A[2][2]);
  r2 := StrToInt(A[2][3]);
  r3 := StrToInt(A[2][4]);
  MyXOR(S, r1, r2, r3);
  I := StrToInt(S);
  AKeyItems := TList<integer>.Create;
  try
    ExtractKeyItemFromInt(I, AKeyItems);
    for n := 0 to FList.Count - 1 do
    begin
      lclVarFRec := FList.ByIndex(n);
      for l := 0 to Length(KeyList) -1 do
        if (KeyList[l].AppID = AppId) then
        begin
          for m := 0 to Length(KeyList[l].FormList) - 1 do
          begin
            if lclVarFRec.FormType = KeyList[l].FormList[m] then   //20171025 Igor
              lclVarFRec.Allowed := False;
          end;
        end;
    end;
    for I := 0 to AKeyItems.Count - 1 do
      for l := 0 to Length(KeyList) -1 do
        if (KeyList[l].AppID = AppId) and (KeyList[l].ID = TSubKeyID(AKeyItems[i])) then
        begin
          FLimitedFormList := FLimitedFormList + IfThen(FLimitedFormList = '', '', '; ')
            + ArrToString(KeyList[l].FormList);
          for n := 0 to FList.Count - 1 do
          begin
            lclVarFRec := FList.ByIndex(n);
            for m := 0 to Length(KeyList[l].FormList) - 1 do
            begin
              if lclVarFRec.FormType = KeyList[l].FormList[m] then   //20171025 Igor
                lclVarFRec.Allowed := True;
            end;
          end;
        end;
  finally
    AKeyItems.Free;
  end;
end;

//20171017 Igor<<<
function TApp.GetAuthorizationKey: string;
begin
  (* for display purposes only (about box)
  *)
  Result := LicenseList.Values[AppId];
  if Result = '' then
    Result := 'N/A'; {default to no key}
end;

function TApp.GetBNText: string; //20191015 Igor
begin
  Result := '';
end;

function TApp.GetCountReviewDynamicForm: Integer; //20160220 Igor
begin
  if not assigned(FReviewDynamicForm) then
    Result := 0
  else
    Result := FReviewDynamicForm.Count;
end;

function TApp.GetCountReviewStaticForm: Integer; //20160220 Igor
begin
  if not assigned(FReviewStaticForm) then
    Result := 0
  else
    Result := FReviewStaticForm.Count;
end;

function TApp.GetEfilerNumber: string; // 20180712 Igor
begin
  Result := '';
end;

function TApp.GetExportForms: TExportForms;  //20161229 Igor
var
  DummyExportForms: TExportForms;
begin
  SetLength(DummyExportForms, 0);
  Result := DummyExportForms;
end;

function TApp.GetForeignForm(const ADir, AFile, AForm: String;
  const AOpenMode: TOpenMode): TFormData; //20170719 Igor
var
  R, I, WorkRetNo: Integer;
  F: TvtForm;
  SB: TvtScrollBox;
  OldAppState: TApplicationStateSet;
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

  OldAppState := ApplicationState;
  if R < 0 then
  begin
    WorkRetNo := GetCurrentRetNo;
    R := Self.OpenReturn(ADir, AFile, False, False);
    GetCurrentRetNo := WorkRetNo;
  end;
  if R <=0 then
    exit(nil);
  case AOpenMode of
    omHidden:
      begin
        Result := RetList[R].Form[AForm];
        ApplicationState := OldAppState;
      end;
    omBackground:
      begin
        if RetList[R].MyChild = nil then
          with RetList[R].NewChild do
          begin
            AddDeferredOpenForm(RetList[R].MyApp.FirstForm);
            Visible := False;
            WindowState := wsMaximized;
          end;
        RetList[R].MyChild.AddDeferredOpenForm(AForm);
        Result := RetList[R].Form[AForm];
        ApplicationState := OldAppState;
      end;
    omActivate:
      begin
        F := OpenForm(R, AForm, 0);
        if Assigned(F) then
          Result := RetList[R].Form[AForm]
        else
          Result := nil;
      end;
    omOnRightPanel:
      begin
        Result := RetList[R].Form[AForm];
        if Result.FormNo <> 0 then
        begin
          for I := FloatingForms.Count - 1 downto 0 do
          begin
            SB := FloatingForms.GetForm(I);
            if SB.Parent = MainForm.ViewSideBySidePanel then
              FloatingForms.RegisterForm(SB, True);
            FreeAndNil(SB);
          end;
          SB := RetList[R].FormClass.Create(MainForm.ViewSideBySidePanel, R, RetList[R].Form[AForm].FormNo);
          SB.isAppendix := True;
          SB.RetNo := R;
          SB.Activated(True, False);
          FloatingForms.RegisterForm(SB, False);
          MainForm.GuiCommand(gcShowSideBySidePanel);
        end;
        ApplicationState := OldAppState;
      end;
  end;
end;

function TApp.GetInitLastYear: Boolean;
begin
  Result := False;
end;

function TApp.GetScanAuthorizationKey: string;
begin
  (* for display purposes only (about box)
  *)
  Result := LicenseList.Values[ScanId];
  if Result = '' then
    Result := 'N/A'; {default to no key}
end;

procedure TApp.GetScanLicenseLevel;
var
  LicenseString: string;
begin
  (* only when needed!
  *)
  ScanLicenseLevel := llNone;
  if ScanId = '' then
    exit;
  LicenseString := LicenseList.Values[ScanId]; //['S1'];
  if (LicenseString = '')
    or not ValidateScanKey(LicenseString) then
    LicenseString := AskForScanKey(Self);
 //ScanLicenseLevel:= GetProductName(LeftStr(LicenseString,4));
  if LicenseString <> '' then
    ScanLicenseLevel := llStd;
end;

function TApp.GetTaxationYear: string; // 20180712 Igor
begin
  Result := '';
end;

procedure TApp.SetScanLicenseLevel(const Value: eLicenseLevel);
begin
  (* Can be dropped. App detects ScanLicenseLevel in SetLicenseLevel (override!)
  *)
  FScanLicenseLevel := Value;
end;

procedure TApp.Activate;
begin
  CurrentApp := Self;
end;

{$IFDEF old}

function TApp.CreateForm(ParentForm: TWinControl; RNo, FNo: integer): TvtScrollBox;
begin
  (* Create common scrollbox type
    If virtualization is ever desired, add a ChildClass property
    that can be ignored when not initialized.
  *)
  Result := TvtScrollBox.Create(ParentForm, RNo, FNo);
end;
{$ELSE}
{$ENDIF}

procedure TApp.DeveloperLicense;
var
  p: PPgmLicenseData;
  //PopList: TPopList;
  s: string;
begin
  (* Developer choice of LicenseLevels for a product
  *)
  s := '';
  p := Licenses;
  with TPopList.Create(Application) do
  begin
    Caption := 'Select an license level';
    repeat
      SomeList.Add(p.Id + ': ' + p.Name);
      inc(p);
    until p.Level = llNone;
    if ShowModal = mrOK then
      s := Selected; //else s stays empty
    Release;
  end;
  if s <> '' then
    SetLicense(s); //uses only ID part of the key/string
end;

function TApp.ExceedsMaxReturnsAllowed(ABeforeCreateNew: Boolean): Boolean;//20170901 Igor
var
  RNow, RMax: Integer;
  SL: TStringList;
  C: TADConnection;
  Q: TADQuery;
  I: Integer;
begin
  RMax := LimitReturns;
  if RMax <> MaxInt then
  begin
    SL := TStringList.Create;
    try
      SL.Sorted := True;
      SL.Duplicates := dupIgnore;
      if ABeforeCreateNew then
        SL.Add(TGuid.NewGuid.ToString);
      for I := 0 to RetList.Count - 1 do
      begin
        if Assigned(RetList[I]) and
           not RetList[I].Destroying and
           Self.Equals(RetList[I].MyApp) and
           not RetList[I].isAppendix and
           not RetList[I].IsLastYearReturn and
           not RetList[I].SourceForRollOver then {for T2 IsLastYearReturn do not actually}
        begin
          if RetList[I].SourceFlName <> '' then
            SL.Add(RetList[I].SourceFlName)
          else
            SL.Add(TGuid.NewGuid.ToString);
        end;
      end;
      if (SL.Count <= RMax) AND FileExists(TPath.Combine(Self.Dir_Cur, Self.ClientsDBLite)) then//20170912 Igor
      begin
        C := TADConnection.Create(Nil);
        try
          //20200317 Igor >>>
          if CurrentApp.CanRebuildCorruptedDatabase then
          begin
            if not SetConnection(C, TPath.Combine(Self.Dir_Cur, Self.ClientsDBLite), ClientsTableLite, False, False, True) then
            begin
              CurrentApp.RebuildCorruptedDatabase;
              if Not SetConnection(C, TPath.Combine(Self.Dir_Cur, Self.ClientsDBLite), ClientsTableLite, False, False)  then
                exit(False);
            end;
          end
          else
            if Not SetConnection(C, TPath.Combine(Self.Dir_Cur, Self.ClientsDBLite), ClientsTableLite, False, False)  then
              exit(False);
          //20200317 Igor <<<
          Q := TADQuery.Create(nil);
          try
            Q.Connection := C;
            Q.SQL.Text := 'SELECT `FILE_NAME` from `'+ClientsTableLite+'`';
            Q.Open;
            while Not Q.Eof do
            begin
              SL.Add(LowerCase(Q.FieldByName('FILE_NAME').AsString));
              Q.Next;
            end;
          finally
            Q.Free;
          end;
        finally
          C.Free;
        end;
      end;
      Result := SL.Count > RMax;
      if Result then
        MessageDlg(Format('Number of returns exceeds maximum allowed (%d) in the %s version!',
          [RMax, Self.ProductName]), mtError, [mbOk], 0);
    finally
      SL.Free;
    end;
  end
  else
    Result := False;
end;

function TApp.ExistReturnInDB(const ADir, AReturnFileName: String): Boolean;//20170902 Igor
var
  C: TADConnection;
  Q: TADQuery;
begin
  if Not TFile.Exists(TPath.Combine(ADir, Self.ClientsDBLite)) then
    exit(False);
  C := TADConnection.Create(Nil);
  try
    if Not SetConnection(C, TPath.Combine(ADir, Self.ClientsDBLite), ClientsTableLite, False, False)  then
      exit(False);
    Q := TADQuery.Create(nil);
    try
      Q.Connection := C;
      Q.SQL.Text := 'SELECT 1 from `'+ClientsTableLite+'` WHERE lower(`FILE_NAME`) = lower(' + QuotedStr(AReturnFileName) + ')';
      Q.Open;
      Result := not Q.IsEmpty;
    finally
      Q.Free;
    end;
  finally
    C.Free;
  end;
end;

function TApp.FormsDBLite: String;
begin
  Result := AppName + 'SCR.DB'; //20170731 Igor
end;

function TApp.FormsTableLite: String;
begin
  Result := AppName + 'SCR';//20170731 Igor
end;

function TApp.GetRightTabSheets: TRightTabSheets;
begin
  Result := [rtsReview, rtsPrevYear, rtsClientDocument, rtsAutoFill];
end;

procedure TApp.FrmTreeCustomNodeClick(ANode: TTreeNode); //20160323 Igor
begin
//
end;

function TApp.ValidateKey(AKey: string): boolean;
begin
  (* Checks key length and app name.
    Override to check hash and invalidated licenses
  *)
  Result := (Length(AKey) = 19)
    and (LeftStr(AKey, 2) = LicenseKeyPrefix);//20170731 Igor
end;

function TApp.OpenForeignForm(const ADir, AFile, AForm: String;
  const AElement: Integer): TFormData; //20170717 Igor
begin
  (* Create AND read return.
  *)
  OVR('OpenForeignForm');
  Result := nil; //must override
end;

function TApp.OpenReturn(DirName, FlName: string; fShow: boolean; AIsAppendix: Boolean = False): integer; //20160302 Igor
begin
  (* Create AND read return.
  *)
  OVR('OpenReturn');
  Result := 0; //must override
end;

function TApp.InitNewReturn(ForLoad: boolean): integer;
begin
  (* Create new return.
    If ForLoad=True don't register, this is done by OpenReturn.
  *)
  Ovr('InitNewReturn');
  Result := 0;
end;

function TApp.IsBNButtonVisible: boolean; //20191015 Igor
begin
  Result := false;
end;

function TApp.isMyReturn(const AAppName: String): Boolean;
begin
  Result := (AAppName = Self.AppName);
end;

procedure TApp.AddReviewDynamicForm(AFormName: String);  //20160220 Igor
begin
  if not Assigned(FReviewDynamicForm) then
    FReviewDynamicForm := TStringList.Create;
 FReviewDynamicForm.Add(AFormName);
end;

procedure TApp.AddReviewStaticForm(AFormName: String);  //20160220 Igor
begin
  if not Assigned(FReviewStaticForm) then
    FReviewStaticForm := TStringList.Create;
 FReviewStaticForm.Add(AFormName);
end;

procedure TApp.AfterConstruction;
begin
  (* check for missing overrides
  *)
  assert(AppId <> '');
  assert(AppIdx <> aiNone);
  assert(AppDir <> '');
  assert(AppName <> '');
  assert(AppTitle <> '');
  assert(AppRelease <> '');
  assert(AppUpdateDate <> '');
  assert(AppYear <> '');
  //assert(ColorTable<>nil);
  assert(FirstForm <> '');
  assert(Menu <> nil);
  assert(GetToolBar <> nil);
  assert(GetSplash <> nil);
  assert(Licenses <> nil);
  //ScanId: string;
end;

function TApp.AllowFormForBuildReport(const AFormName: String): Boolean; //20170505 igor
begin
  Result := False;
end;

procedure TApp.AppOnIddle; //20161213 Igor
begin
//
end;

function TApp.GetAppTitle: string;
begin
  Result := 'Visual Tax - ' + AppName;
end;

function TApp.GetAdditionalInfo: string; // 20180712 Igor
begin
  Result := '';
end;

function TApp.GetAppDir: string;
begin
  result := ExeDir + '\' + AppId;
end;

procedure TApp.OVR(const MethName: string);
begin
  ErrorMsg('Override ' + ClassName + '.' + MethName);
end;

function TApp.PrepareDistribution(ADir: String = ''): boolean;
var
  i, CompIndex, k, n, FNo, Elm, NumForms, NumEditBoxes: integer;
  s, WorkDirectory: string;
  //FormsDir,
  DfmFileName, FName: string;
  MaxFormNo: integer;
  FormHeight: Integer;
  FormFields: Integer;
  CursorPos: Integer;
  Pages: Integer;

  AForm: Tform;
  AControl: TControl;
  MyCtrl: TMyCtrl absolute AControl;
  aShape: TvtShape;
  AEditBox: TvtEdit;
  ALabel: TVtLabel;
  PrevCursorTop, PrevCursorLeft: Integer;
  lVarFRec: TFRec;
  //dyn data
  ia, ia0, ielm: integer;
  //used during PrepareDistribution
  ADConnection: TADConnection;
  Table1: TADTable;
  TempList, DollarFields: TStringList;
  CheckComp, //FieldsList,
  YesNoLabelsList,
    SinLabelsList: TStringList;
  LblSectList: TLabelSectList;

  procedure CheckUnlistedForms;
  var
    i, id, FormFields: integer;
    sr: TSearchRec;
    Dir, FName, DFMname: string;
    cmp: TComponent;
    Handlers: boolean;
  begin
    Dir := WorkDirectory;
    if FileExists(Dir+'\main.pas') then
      Dir := Dir + '\'+AppName+'Forms';
    if findfirst(Dir + '\*.dfm', faAnyFile, sr) <> 0 then
      exit;
    repeat
      FName := sr.Name;
      DFMname := Dir + '\' + sr.Name;
      FName := UpperCase(ChangeFileExt(FName, ''));
      if FName[1] = 'U' then
        FName := copy(FName, 2, 100);
      lVarFRec := FList.ByFormName(FName);
      if lVarFRec.FormNo = 0 then
      begin
        DfmProgress.lbFile.Caption := DFMname;
        //DfmIgnore := False; //expect user input
        DfmProgress.ShowMsg('Form not in DB');
        //ErrorMsg('unused form file '+DFMname+'?');
        if False then
        begin
          //add dummy descriptor?
          lVarFRec := TFRec.Create;
          lVarFRec.FormName := FName;
          //FRec.FormFields := FormFields;
          FList.AddRec(lVarFRec);
        end;
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;

var
  DataElm: TStringList;
  MemoList: TStringList; //easy tó clear

  procedure AdjustFields(fld, i: integer);
  begin
    DfmProgress.ShowMsg('DataIndic uses non-existing field ' + IntToStr(fld));
    FormFields := fld; //extend form?
    //DataElm.Delete(i); //drop fld?
  end;

  procedure CheckDataIndic;
  var
    i, Fld: integer;
  begin
    (* using FRec - adjust FormFields up?
    *)
    DataElm.CommaText := lVarFRec.DataIndic;
    if DataElm.Count = 0 then
      exit; //no indicators?
    if DataElm[0] = '' then
      exit; //missing check type???
    //strip empty fields
    for i := DataElm.Count - 1 downto 1 do
      if DataElm[i] = '' then
        DataElm.Delete(i);
    //check ElmNo's
    case DataElm[0][1] of
      'F': {depends on other form}
        if FList.GetFormNo(DataElm[1]) < 1 then //preserves FRec
        begin
          DfmProgress.ShowMsg('DataIndic refers to non-existing form ' + DataElm[1]);
          //fix?
            //DataElm.Clear;
        end;
      'L', //depends on Line
      { TODO : check L DataIndic }
      'Y': exit; //always
      'R': //Range: check all elements [1]..[2]
        begin
          fld := StrToInt(DataElm[1]); //lower bound
          //drop if too high?
          fld := StrToInt(DataElm[2]); //upper bound
          if fld > FormFields then
            AdjustFields(fld, 2);
        end;
      '0'..'9':
        for i := 0 to DataElm.Count - 1 do
        begin
          fld := StrToInt(DataElm[i]);
          if (fld > FormFields) and (fld < arrayMul) then
            AdjustFields(fld, i);
        end;
    else //case
      DfmProgress.ShowMsg('unhandled DataIndic: ' + DataElm[0]);
    end;
    //store fixed string
    lVarFRec.DataIndic := DataElm.CommaText;
  end;

  procedure InitList(AList: TStrings; ANum: integer = 0; ListId: string = '');
  var
    s: string;
  begin
    AList.Clear;
    s := '000' + IntToStr(FNo);
    s := RightStr(s, 3);
    AList.Add(s); //[0] = FormNo
    AList.Add(FName); //[1] = FormName
    if ANum = 0 then
      s := ''
    else
      s := IntToStr(ANum);
    AList.Add(s); //[2] any number
    AList.Add(ListId); //[3] version field
  end;

begin //PrepareDistribution
  (* check forms, create property files
  Org:
    TestAllForms
    CheckVtComponents

  T1: also init LastYearsFormsTable!
  *)
  Result := True; //assume everything is fine
  AControl := nil; //make compiler happy
  if ADir = '' then
    WorkDirectory := AppDir
  else
    WorkDirectory := ADir;
  TempList := TstringList.Create;
  TempList.Sorted := True;
  DollarFields := TStringList.Create;
  CheckComp := TStringList.Create;
  LblSectList := TLabelSectList.Create(Self);
  YesNoLabelsList := TStringList.Create;
  SinLabelsList := TStringList.Create;
  DataElm := TStringList.Create;
  MemoList := TStringList.Create;

  MaxFormNo := 0;

  Screen.Cursor := crHourGlass;

  DfmProgress := TDfmProgress.Create(Application);
  DfmProgress.lbAction.Caption := 'Build Properties File ' + AppId;
  DfmProgress.LogName := WorkDirectory + '\BuildProps.txt';
  DfmProgress.Show;

  DollarFields.SaveToFile(WorkDirectory + '\' + FieldsListD); //clear file, will be rebuilt
  //
  if not  FList.InitFormsTable(WorkDirectory, lFormsDBLite, lFormsTableLite) then //20150918 Igor
  Begin
    Result := False;
    Exit;
  End;

  CheckUnlistedForms; //to FList? analyzed subsequently

  //20150915 Igor
  ADConnection:= TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  if SetTableName(ADConnection, Table1, WorkDirectory + '\' + lFormsDBLite, lFormsTableLite, 'FormNo') then
  begin
  try
      for i := 0 to FList.count - 1 do
      begin
        lVarFRec := FList.Items[i];
        FNo := lVarFRec.FormNo;
        if FNo < 1 then
          continue;
        if FNo > MaxFormNo then
          MaxFormNo := FNo; //currently unused - store where?
        FName := lVarFRec.FormInstName;

        if AllTrim(lVarFRec.FormInst) < '#2' then
        begin
          DfmFileName := GetDfmFileName(FName);
          DfmProgress.lbFile.Caption := DfmFileName;
          Application.ProcessMessages;

          if not FileExists(DfmFileName) then
          begin //file does not exist
            if DfmProgress.ShowMsg('File not found') then
              break; //Cancel
            continue; //next form
          end
          else if lVarFRec.DelphiForm then
          begin
            DfmIgnore := False; //await OK
            DfmIgnore1 := False;
            if DfmProgress.ShowMsg('is Delphi form - kill?') then
              break; //cancel
            if not DfmIgnore1 then
              DeleteFile(DfmFileName);
            continue; //okay, DFM not allowed
          end;

          //init counters
          Pages := 0;
          FormFields := 0;
          MemoList.Clear;
          CursorPos := 0;
          PrevCursorTop := 10000;
          PrevCursorLeft := 1000;
          FormHeight := 0;

          AForm := Tform.Create(Application);
          try
            //If i>310 then ShowMessage(FName+' -  '+DfmFileName);
            if ReadComponentResFile(DfmFileName, AForm) = nil then
            begin //resource error
              Result := False;
              if DfmProgress.ShowMsg('DFM File problem') then
                break; //user cancel
              Continue; //next form
            end;

            //FieldsList: FNo,FName,FormFields,$,vtDollar1, ...
            if lVarFRec.DelphiForm then
              s := 'D' //DollarFields.Add('D') //version field - Delphi form
            else
              s := '$'; //DollarFields.Add('$'); //version field
            InitList(DollarFields, 0, s);

            if AForm.VertScrollBar.Position > 0 then
            begin
              if DfmProgress.ShowMsg('*** SET SCROLLBAR to TOP*** ' + FName) then
                break; //user cancel
            end;

            LblSectList.Add(FName); //header for each form
            //find cursor default
            for CompIndex := 0 to AForm.ComponentCount - 1 do
            begin
              // get the form height
              if AForm.Components[CompIndex] is TControl then
                AControl := AForm.Components[CompIndex] as TControl
              else
                continue; //ignore non-controls
              if AControl.Visible
                and ((AControl.Top + AControl.Height) > FormHeight) then
                FormHeight := AControl.Top + AControl.Height;
              //check for installed handlers
              if assigned(MyCtrl.OnClick) then
              begin //won't this cause an exception in ReadComponentResFile?
                lVarFRec.DelphiForm := True; //DFM alone is unusable!
                DollarFields[3] := 'D'; //mark as Delphi form
              end;

              //check for non-VT controls
              if (UpperCase(Copy(AControl.ClassName, 1, 3)) <> 'TVT') AND
                 (AControl.Parent <> nil) then //20161227 Igor (for TrxRichEdit)
                CheckComp.Add(FName + '.' + AControl.Name + ': ' + AControl.ClassName)

              else if AControl is TvtEdit then
              begin
                AEditBox := AControl as TvtEdit;
                Elm := AEditBox.FieldId;
                if Elm > ArrayMul then
                begin
                  //determine array characteristics
                  ia := Elm div ArrayMul;
                  ielm := Elm mod ArrayMul;
                  ia0 := length(lVarFRec.BoxesPerRow);
                  if ia >= ia0 then
                  begin
                    assert(ArrayBase = 1, 'Unhandled ArrayBase');
                    SetLength(lVarFRec.BoxesPerRow, ia + 1); //[0..ia]
                    //clear addeds
                    while ia0 <= ia do
                    begin
                      lVarFRec.BoxesPerRow[ia0] := 0;
                      inc(ia0);
                    end;
                  end;
                  if lVarFRec.BoxesPerRow[ia] < ielm then
                    lVarFRec.BoxesPerRow[ia] := ielm;
                  continue; //skip dynamic fields
                end;
                if Elm > FormFields then
                  FormFields := Elm; //20111231
                case AEditBox.vtInputType of
{$IFDEF old}
                  vtDollar:
                    TempList.add(PaddR(FName, 10) + PaddR(IntToStr(FNo), 4) + PaddR(IntToStr(Elm), 6) + 'vtDollar');
                  vtYesOrNo, vtCheckBox:
                    TempList.add(PaddR(FName, 10) + PaddR(IntToStr(FNo), 4) + PaddR(IntToStr(Elm), 6) + 'vtCheck');
{$ELSE}
                  vtDollar:
                    DollarFields.Add(IntToStr(Elm));
{$ENDIF}
                end;

                //find the most top, left unprotected field for cursor positioning
                if (AEditBox.Visible)
                  //and (AEditBox.vtDataSource in [vtUser,vtPopupList]) //???
                and not (AEditBox.vtDataSource in [vtCalc, vtAddingTape]) //???
                and (AEditBox.Top <= PrevCursorTop) then
                begin
                  if (AEditBox.Top < PrevCursorTop)
                    or (AEditBox.Left < PrevCursorLeft) then
                  begin
                    PrevCursorLeft := AEditBox.Left;
                    PrevCursorTop := AEditBox.Top;
                    CursorPos := Elm;
                  end;
                end;
              end //vtedit

              else if (AControl is TMemo) //includes TvtMemo
              or ((AControl is TRichEdit) AND (AControl.Parent <> nil)) {//includes TwwDbRichEdit} then //20161227 Igor
              begin
                //multi-line controls
                ielm := GetFieldId(AControl.Name);
                //expand list if required
                while ielm >= MemoList.Count do
                  MemoList.Add('');

                if MemoList[ielm] <> '' then
                begin
                  ErrorMsg(Format('Duplicate ID: %s and %s', [AControl.Name, MemoList[ielm]]));
                  CheckComp.Add(FName + '.' + AControl.Name + ': ' + AControl.ClassName)
                end
                else
                  MemoList[ielm] := AControl.Name;
              end

              else if AControl is TvtLabel then
              begin
                ALabel := AForm.Components[CompIndex] as TvtLabel;
                if ALabel.vtIsSelectionLabel then {section labels}
                  LblSectList.AddLabel(ALabel, FName); //(' '+PaddR(ALabel.Caption,80)+PaddR(FName,10)+IntToStr(ALabel.Top));

                if (Pos('Social Insurance Number', ALabel.Caption) > 0)
                  or (Pos('SIN', ALabel.Caption) > 0) then
                  SinLabelsList.Add('SIN Label' + FName + ' ' + IntToStr(ALabel.Top));

                if (Pos('Y/N', ALabel.Caption) > 0) then
                  YesNoLabelsList.Add('Y/N Label ' + FName + ' ' + IntToStr(ALabel.Top));
              end //end if TvtLabel

              else if AControl is TvtShape then
              begin
                AShape := AForm.Components[CompIndex] as TvtShape;
                if AShape.vtPageBreak then
                  inc(Pages, 1);
              end; //if is vtShape

            end; //CompINdex
          finally
            AForm.Free;
            DollarFields[2] := IntToStr(FormFields);
            TempList.Add(DollarFields.CommaText);
          end;
          //end  //file exists

         //check DataIndic - trunc or extend FormFields?
          CheckDataIndic; //adjust FormFields
          if lVarFRec.FormNo <> FNo then
          begin
            ErrorMsg('FRec changed during analysis');
            lVarFRec := FList.ByFormNoNil(FNo);
          end;

          //update forms table
          if Table1.FindKey([FNo]) then
          begin
            Table1.edit;
            Table1.FieldByName('FormFields').AsInteger := FormFields;
            Table1.FieldByName('CursorPos').AsInteger := CursorPos;
            Table1.FieldByName('FormHeight').AsInteger := FormHeight;
            //DelphiForms maybe missing from this table - flag in DollarFields
            {
             if (Table1.Fields.FindField('DelphiForm') <> nil)
             and (Table1.FieldByName('DelphiForm').As Boolean = False) then
              Table1.FieldByName('DelphiForm').As Boolean := FRec.DelphiForm;
            }
            if Pages = 0 then
            begin
              CheckComp.add('***    No Page Break    *** ' + FName);
              Pages := 1;
            end;
            Table1.FieldByName('FORMMXPG').AsInteger := Pages;

            Table1.Post;
          end
          else
            DfmProgress.ShowMsg('Form' //+FRec.FormInstName+' FNo='+IntToStr(FNo)
              + ' not in ' + lFormsDBLite + ' ' + lFormsTableLite); //20150915 Igor
        end;
        //save arrays
        ia0 := Length(lVarFRec.BoxesPerRow);
        if ia0 > 1 then
        begin //dynamic arrays
          InitList(DollarFields, ia0 - 1, 'A'); //has dynamic arrays
          for ia := 1 to ia0 - 1 do
            DollarFields.Add(IntToStr(lVarFRec.BoxesPerRow[ia]));
          TempList.Add(DollarFields.CommaText);
        end;
        if MemoList.Count > 0 then
        begin //multi-line controls
          MemoList.Delete(0); //dummy entry
          InitList(DollarFields, MemoList.Count, 'M');
          //debug only
          DollarFields.AddStrings(MemoList);
          TempList.Add(DollarFields.CommaText);
        end;
      end; //i, flist;
    except
      on E: Exception do
      begin
        Result := False;
        //MessageDlg(FName+ ' '+E.Message, mtError, [mbok], 0);
        DfmProgress.lbExcept.Caption := e.Message;
        //DfmProgress.ShowMsg(e.Message); //then Result := False;
      end;
    end;
  end;
  // finally
    //Table1.Close;
    Table1.Free;
    ADConnection.Free;

    DollarFields.Free;
    MemoList.Free;
    DataElm.Free;

    //log following messages without filename
    DfmProgress.lbFile.Caption := AppId;
    DfmIgnore := True; //don't wait

    //this is the only used data file, containing vtDollar fields etc.
    TempList.SaveToFile(WorkDirectory + '\' + FieldsListD);
    TempList.Free;

    //if LblSectList.Count > 0 then - always!
    LblSectList.SaveToFile(WorkDirectory + '\LblSect.d');
    LblSectList.Free;

    if SinLabelsList.Count > 0 then
      DfmProgress.ShowMsg('Check SinLabels.txt');
    SinLabelsList.SaveToFile(WorkDirectory + '\SinLabels.Txt');
    SinLabelsList.Free;

    //if YesNoLabelsList.Count > 0 then
    YesNoLabelsList.SaveToFile(WorkDirectory + '\YesNoLabels.Txt');
    YesNoLabelsList.Free;

    if CheckComp.Count > 0 then
    begin
      DfmProgress.ShowMsg('Non Vt components found. See CheckComp.Txt');
      CheckComp.Insert(0, 'Non Vt components found');
    end;
    CheckComp.SaveToFile(WorkDirectory + '\CheckComp.txt');
    CheckComp.Free;

    //???
    if Result then
    begin
      DfmProgress.Close; //stores in LogName and shows message
      Application.ProcessMessages; //20160220 Igor
      UserMsg('Done PrepareDistr');
    end
    else
    begin
      DfmProgress.ShowMsg('Please fix the listed errors and run PrepareDistr again');
    end;
    Screen.Cursor := crDefault;
  //end; //finally
end;

procedure TApp.RebuildCorruptedDatabase; //20200317 Igor
begin
end;

procedure TApp.ReloadMainMenu; //20180113 Igor
begin
  ;
end;

function TApp.LicenseKeyPrefix: String;//20170731 Igor
begin
  Result := AppName;
end;

function TApp.LoadDataDict: TDataDictList;
begin
  if DataDict = nil then
  begin
    { TODO : destroy }
    DataDict := TDataDictList.Create;
    //str
  end;
  DataDict.Load(AppDir);
  Result := DataDict;
end;

function TApp.MaskClientDataForBuildReport(const AFieldName, AValue: String): String;
begin
  if SameText(AFieldName, 'SIN') or
     SameText(AFieldName, 'FILE_NAME') or
     SameText(AFieldName, 'BIRTHDATE') then
    if AValue <> '' then
      Result := StringOfChar('*', length(AValue))
    else
      Result := ''
  else
    Result := AValue;
end;

function TApp.MaskFormDataForBuildReport(const AFormName: String;
  AFieldNo: Integer; AFieldValue: String): String; //20170505 Igor
begin
  Result := '';
end;

procedure TApp.HelpOnClientLetter;
begin
  OVR('HelpOnClientLetter')
end;

function TApp.AskChangeLicenseLevel: boolean;
var
  K, Psw: string;
begin
  (* interactive change, developers only
  *)
  Result := False;
  if not IsDeveloperLogin then
    exit;
  SetLicense(InputBox(AppId, 'License Key', ''));
  //If ValidateKey(s) then SetLicense(s);
  Result := LicenseLevel <> llNone;
  {
   Licensee:='Some Multi-user';
   SelectFeatures;
   MainForm.FormPaint(Application);
  }
end;

function TApp.AutoFillToVtAddr(const ASection, ASubSection: String;
  out AVTAddr: TVTMapElement): Boolean;//20170726 Igor
begin
  Result := False;
end;

{ TAppList }

function TAppList.AppFromID(const id: string): TApp;
var
  i: integer;
begin
  (* ID should be AppId
  *)
  i := self.IndexOf(id);
  if i < 0 then
    Result := nil
  else
    TObject(Result) := Objects[i];
end;

procedure TAppList.AssignTo;
var
  i: integer;
begin
  (* init lst with both Strings[] and Objects[]
    only fully implemented and licensed apps
  *)
  lst.Clear;
  for i := 0 to Count - 1 do
  begin
    if not GetApp(i).IsDummyApp
      //and (GetApp(i).ProductName <> '')
    and (GetApp(i).LicenseLevel > llNone) then
      lst.AddObject(Strings[i], Objects[i]);
  end;
end;

function TAppList.AppFromName(const id: string): TApp;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    Result := GetApp(i);
    if Result.AppName = id then
      exit; //app found
  end;
  //not found
  Result := nil;
end;

function TAppList.GetApp(index: integer): TApp;
begin
  TObject(Result) := Objects[index];
end;

function TAppList.RegisterApp(TheApp: TApp): integer;
begin
  Result := AddObject(TheApp.AppID, TheApp);
end;

function TAppList.LicensedApps: integer;
var
  i: integer;
  app: TApp;
begin
  Result := 0;
  for i := 0 to Count - 1 do
  begin
    app := GetApp(i);
    if assigned(app) and (app.LicenseLevel > llNone) then
      inc(Result);
  end;
end;

function TAppList.GetApp(AAppIdx: eAppIdx): TApp; //20170703 igor
var
  I: integer;
begin
  for I := 0 to Count - 1 do
    if GetApp(I).AppIdx = AAppIdx then
      exit(GetApp(I));
  Result := nil;
end;

procedure TAppList.GetLicenses;
var
  i: integer;
begin
  (* Refresh app licenses
  *)
  for i := 0 to Count - 1 do
    GetApp(i).GetLicenseLevel;
end;

procedure TAppList.InitApps;
var
  i: integer;
  CurApp: TApp;
begin
  (* Activate the first licensed app, or last active
  *)
  CurrentApp := nil; //ignore set in constructors
  if MainOptions.LastAppId <> '' then
  begin
    CurApp := AppList.AppFromID(MainOptions.LastAppId); //!!! AppName only!
    if Assigned(CurApp) then //20160302 Igor
    Begin
      if CurApp.LicenseLevel > llNone then
      begin
        CurrentApp := CurApp;
        exit;
      end;
    End;
  end;
  for i := 0 to Count - 1 do
  begin
    CurApp := GetApp(i);
    if CurApp.LicenseLevel > llNone then
    begin
      CurrentApp := CurApp; //first licensed app
      exit;
    end;
  end;
  //error: no licensed apps!?
end;

procedure TAppList.RetNoChanged;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    GetApp(i).SelectFeatures;
  end;
end;

destructor TAppList.Destroy;
begin
  AppList := nil; //become unavailable
  CurrentApp := nil; //will be destroyed now!
  inherited;
end;

constructor TAppList.Create;
begin
  inherited;
end;

{ TOwningStringList }

procedure TOwningStringList.Delete(Index: Integer);
begin
  (* Destroy the associated object
    never called?
  *)
  Objects[Index].Free;
  Objects[Index] := nil;
  inherited;
end;

destructor TOwningStringList.Destroy;
var
  i: integer;
begin
  //Clear; - doesn't help
  for i := Count - 1 downto 0 do
  begin
    Objects[i].Free;
    Objects[i] := nil;
  end;

  inherited Destroy;
end;

{$IFDEF new}

{ EWriteReturn }

constructor EWriteReturn.Create(ACode: eWriteResult; const AMsg: string);
begin
  code := ACode;
  inherited Create(AMsg);
end;
{$ELSE}
{$ENDIF}

{ TFloatingForms }

procedure TFloatingForms.ColorChanged(RetNo: integer);
var
  i: integer;
  frm: TvtForm;
begin
  (* assume the return color has changed
  *)
  for i := 0 to Count - 1 do
  begin
    frm := GetForm(i);
    if frm.RetNo = RetNo then
    begin
      frm.Color := RetList[RetNo].RetColor;
      //exit;
    end;
  end;
end;

function TFloatingForms.GetForm(index: integer): TvtScrollBox;
begin
  pointer(Result) := items[index];
end;

function TFloatingForms.FindForm(ARetNo, AFormNo: integer): TvtScrollBox;
var
  I: Integer;
  Frm: TvtScrollBox;
Begin
  Result := nil;
  for i := Count - 1 downto 0 do
  begin
    frm := GetForm(i);
    if (frm.RetNo = ARetNo) AND (frm.FormNo = AFormNo) then
    begin
      Result := frm;
      exit;
    end;
  end;
End;

procedure TFloatingForms.RegisterForm(AForm: TvtScrollBox; RemoveIt: boolean);
begin
  (* Floating form registration (tax forms outside MDI pages)
    Floating forms are read-only?
  *)
  Remove(AForm);
  if not RemoveIt then
  begin
    Add(AForm);
    //AForm.ReadOnly := True;
  end;
end;

procedure TFloatingForms.RemoveReturn(RetNo: integer);
var
  i: integer;
  frm: TvtForm;
begin
  for i := Count - 1 downto 0 do
  begin
    frm := GetForm(i);
    if frm.RetNo = RetNo then
    begin
      Delete(i);
      //how to detect possibly destroyed form?
        //if (Frm.Handle = 0) or IsWindow(frm.handle) then  --> creates Handle!!!
      if Frm.Owner <> nil then
        frm.Free;
    end;
  end;
end;

procedure TFloatingForms.UpdateForms(RetNo: integer);
var
  i: integer;
  f: TvtScrollBox;
begin
  if RetNo < 1 then
    exit;
  for i := 0 to Count - 1 do
  begin
    f := GetForm(i);
    //20160711 Igor
    if (f.RetNo < 0) or (f.RetNo >= RetList.Count) then
      continue;
    if (f.RetNo = RetNo) or (assigned(RetList[f.RetNo]) and RetList[f.RetNo].IsLastYearReturn) then //20160608 Igor
      //f.Activated(True);
      //RetList[RetNo].MyChild.PopulateFormWithData(f);
      f.PopulateFormWithData;
  end;
end;

//20170112 Igor >>>
(*
{ AUserProfile }

function AUserProfile.GetAdminPassword(const UserName: string): string;
begin
  Result := '';
  if Name <> UserName then
    if not GetUserProfile(UserName) then
      exit;
  Result := Pswd;
end;

function AUserProfile.GetNextInvoiceNo(const UserName: string): integer;
var
  ADConnection: TADConnection;
  Table1: TADTable;
begin
  Result := 0;

  //20150915 Igor
  ADConnection:= TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  SetTableName(ADConnection, Table1, ExeDir + '\' + UserDBLite, UserTableLite, 'Name');

  if Table1.FindKey([UserName]) = true then
  begin
    result := Table1.FieldByName('Inv_No').AsInteger + 1;
    Table1.edit;
    Table1.FieldByName('Inv_No').AsInteger := Result;
    Table1.Post;
    //update the cache
    if Name = UserName then
      Inv_No := Result;
  end;

  Table1.Free;
  ADConnection.Free;
end;

function AUserProfile.GetUserProfile(const UserName: string): boolean;
var
  ADConnection: TADConnection;
  Table1: TADTable;
begin
  Result := True;
  if UserName = Name then
    exit; //already loaded

  //20150915 Igor
  ADConnection:= TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  SetTableName(ADConnection, Table1, ExeDir + '\' + UserDBLite, UserTableLite, 'Name');

  if Table1.FindKey([UserName]) = false then
  begin Result := false;
    exit;
  end;
  with Table1 do
  begin
    M_Office := FieldByName('M_Office').AsString;
    Branch := FieldByName('Branch').AsString;
    Prep_Intls := FieldByName('Prep_Intls').AsString;
    Login_Id := FieldByName('Login_Id').AsString;
    Pswd := FieldByName('Pswd').AsString;
    Auth_Level := FieldByName('Auth_Level').AsString;
    Inv_No := FieldByName('Inv_No').AsInteger;
    Code := FieldByName('CODE').AsString;
    Prep_Name := FieldByName('Prep_Name').AsString;
    Tax_dir := FieldByName('Tax_dir').AsString;
    DBFData_dir := FieldByName('DBFData_dir').AsString; //20160226
    EFile_Dir := FieldByName('EFile_dir').AsString;
    Br_Dir := FieldByName('BR_dir').AsString;
    //20150916 - convert
    CrProfile := Boolean(FieldByName('Cr_Profile').AsInteger);
    CrReturn := Boolean(FieldByName('Cr_Return').AsInteger);
    PrReturn := Boolean(FieldByName('Pr_Return').AsInteger);
    PrInvoice := Boolean(FieldByName('Pr_Invoice').AsInteger);
    PrReport := Boolean(FieldByName('Pr_Report').AsInteger);
    MkAppoint := Boolean(FieldByName('Mk_Appoint').AsInteger);
    CrRtu := Boolean(FieldByName('Cr_Rtu').AsInteger);
    EFile := Boolean(FieldByName('Efile').AsInteger);
    Upload := Boolean(FieldByName('Upload').AsInteger);
    MkPay := Boolean(FieldByName('Mk_Pay').AsInteger);

    Table1.Free;
    ADConnection.Free;
  end;
  Name := UserName;
end;
*) //20170112 Igor


//20161229 Igor <<<
{ TSingleStringList }

procedure TSingleStringList.Clear;
begin
  (* reset for next use
  *)
  Sorted := False;
  inherited;
end;

procedure TSingleStringList.Free;
begin
  (* don't destroy
  *)
    //ErrorMsg('attempt to free a singleton');
  Clear; //for next use
end;

//20170515 Igor >>>

//{ TSingleStringLists }
//
//procedure TSingleStringLists.AddSingle(AVar: PObject; AClass: TClass);
//begin
//  (* remember the variable holding a singleton
//  *)
//  if IndexOf(AVar) >= 0 then
//    exit; //duplicate add!
//  Add(AVar);
//  AVar^ := AClass.Create;
//end;
//
//procedure TSingleStringLists.Clear;
//var
//  i: integer;
//  p: PObject;
//  o: TObject;
//begin
//  (* free and nil all objects
//  *)
//  for i := 0 to Count - 1 do
//  begin
//    p := Items[i];
//    if p = nil then
//      continue;
//    o := p^;
//    if o <> nil then
//    begin
//      o.Destroy; //bypass Free
//      p^ := nil;
//    end;
//  end;
//  inherited;
//end;

//20170515 Igor <<<

{ TSingleList }

procedure TSingleList.Free;
begin
  Clear;
end;

{ TOptRec }

function TOptRec.GetFormZoom: integer;
begin
  Result := MainOptions.FormZoom;
end;

function TOptRec.GetRightZoom: integer; //20160209 Igor
begin
  Result := MainOptions.RightZoom;
end;

procedure TOptRec.SetFormZoom(const Value: integer);
begin
  (* simply ignore assignments
  *)
  UserMsg('Use +/- buttons to change the zoom factor');
end;

{ TAuditRec }

constructor TAuditRec.Create(Cat: char; Descr, FName: string;
  ElmNo: integer);
begin
  Category := Cat;
  Description := Descr;
  Form := FName;
  Elm := ElmNo;
end;

function TAuditRec.Message: string;
begin
  Result := Category + '-' + Description;
end;

{ TAuditList }

constructor TAuditList.Create(RNo: integer);
begin
  inherited Create(True);
  RetNo := RNo;
end;

procedure TAuditList.BeginUpdate;
begin
  Changed := False; //checked in EndUpdate
end;

procedure TAuditList.EndUpdate;
var
  i, m, FNo: integer;
  r: TAuditRec;
  MsgLimit: Integer;
begin
  if not Changed then
    exit;
  //refresh storage
  FNo := RetList[RetNo].GetFormNo('WARNOFF');
  if FNo > 0 then
  begin
    ClearForm(RetNo, 'WARNOFF');
    MsgLimit := RetList[RetNo].GetFormNumberFields(FNo);
    m := 0;
    for i := 0 to Count - 1 do
    begin
      r := AuditRec[i];
      if r.Category = 'O' then
      begin
        //count sign-offs
        inc(m);
        if m > MsgLimit then
          break;
        StoreElmFNo(RetNo, FNo, m, r.Description);
      end;
    end;
    RetList[RetNo].FrmHasData[FNo] := m > 0; //when something was stored
  end;
  //update GUI
  RetList[RetNo].MyChild.Invalidate; //update field indicators
  MainForm.RefreshAuditPanel(RetNo);
  Changed := False;
end;

function TAuditList.GetAuditRec(index: integer): TAuditRec;
begin
  TObject(Result) := Items[index];
end;

function TAuditList.GetHint(FName: string; Fld: integer): TAuditRec;
var
  i: integer;
begin
  (* return error description AND category
  *)
  for i := 0 to Count - 1 do
  begin
    Result := GetAuditRec(i);
    if (Result.Form = FName) and (Result.Elm = Fld) then
      exit;
  end;
  //none found
  Result := nil;
end;

function TAuditList.HasCategory(Category: char): boolean;
var
  i: integer;
  r: TAuditRec;
begin
  Result := True; //assume found
  for i := 0 to Count - 1 do
  begin
    r := GetAuditRec(i);
    if r.Category = Category then
      exit; //found
  end;
  Result := False; //not found
end;

{ TFList }

constructor TFList.Create(AApp: TApp; MaxForms, MaxFields: integer;
  AFormsDBLite, AFormsTableLite: String; AAppPath: String = '');//20150119 Igor
begin
//20170927 Igor>>>
  inherited Create;
  FSortedList := TStringList.Create; //20170322 Igor
  MyApp := AApp;
  FormsLimit := MaxForms;
{$IFDEF fixForms}
  FFieldsLimit := MaxFields;
{$ELSE}
  FieldsLimit := MaxFields;
{$ENDIF}
  FAffectedForms := TDictionary<String, TArray<String>>.Create;
  FAffectedFormsIsInit := False;
  FisLastYearList := AAppPath <> '';
  DummyRec.Calc := NoFormToCalc;
  if not assigned(AApp.FList) then
  Begin
    AApp.FList := Self;
    AApp.lFormsDBLite := AFormsDBLite;
    AApp.lFormsTableLite := AFormsTableLite;
  End;
//20170927 Igor<<<
end;

//var
//  FRec: TFRec;

destructor TFList.Destroy;
begin
  if Destroying then
    DebugBreak;
  Destroying := True;
  Clear;
  FSortedList.Free; //20170324 Igor
  inherited; //doesn't call Clear!
  ByFNo := nil;
  FreeAndNil(FAffectedForms);//20170927 Igor
end;

procedure TFList.Clear;
var
  i: integer;
  lVarFRec: TFRec;
begin
  //destroy all objects
  try
    for i := 0 to Count - 1 do
    begin
      TObject(lVarFRec) := Objects[i];
      if Strings[i] = lVarFRec.FormInstName then
        lVarFRec.Free
      else
        Objects[i] := nil;
    end;
  except
    on e: exception do
      ExceptMsg(e);
  end;
  //destroy forms map
  ByFNo := nil;
  inherited;
  if Destroying then
    exit;
  //resize - assume FormsLimit is max valid FormNo
  Capacity := FormsLimit + 1;
  SetLength(byfno, FormsLimit + 1);
  FillChar(ByFNo[0], (FormsLimit + 1) * sizeof(pointer), 0);
end;

function TFList.ByFormName(FName: string): TFrec;
var
  i: integer;
begin
  (* Also return FormName without instance
  *)
  //20170324 Igor >>>
  I := FSortedList.IndexOf(FName);
  if i < 0 then
    Result := DummyRec
  else
    TObject(Result) := Objects[Integer(FSortedList.Objects[I])];
  //20170324 Igor <<<
end;

function TFList.ByFormNoNil(FNo: integer): TFRec;
begin
  Result := self.byfno[FNo];
end;

function TFList.ByFormNoDummy(FNo: integer): TFRec;
begin
  Result := byfno[FNo];
  if Result = nil then
    Result := DummyRec;
end;

function TFList.ByIndex(i: integer): TFRec;
begin
  (* Suppress multi-inst duplicates (without FormInst)
  *)
  if i < 0 then
  begin
    ErrorMsg('Form does not exist');
    Result := DummyRec;
  end;
  TObject(Result) := Objects[i];
  if Result.FormInstName <> Strings[i] then
    Result := DummyRec; //not a valid instanced FRec
end;

function TFList.FirstInstNo(NonInstFormName: string): integer;
var
  I: Integer; //20170324 Igor
begin
  (* return index of first instance, i.e. FName#1.
  Problem: loop over all instances should NOT start in FName,
    i.e. requires search for FName#1 (inc(Result)
  Problem: frequently called for non-inst forms!
  --> for use in loops only, expect non-inst FName
  --> to determine any instance, use IndexOf(any existing)

  Production, using only valid calls with non-inst name:
    Result := IndexOf(FName)+1;
  *)
  //20170324 Igor >>>
  I := FSortedList.IndexOf(NonInstFormName);
  //i := IndexOf(FName);
  if I < 0 then
    Result := 0
  else
    Result := Integer(FSortedList.Objects[I]) + 1;
//  Result := IndexOf(NonInstFormName) + 1;
  //20170324 Igor <<<
end;

function TFList.LastInstNo(NonInstFormName: string): integer;
begin
  (* return index of last instance
  *)
  //20170324 Igor >>>
  Result := FSortedList.IndexOf(NonInstFormName);
  if Result < 0 then
    Exit;
  while (Result < (FSortedList.Count - 1)) and
        (Items[Integer(FSortedList.Objects[Result + 1])].FormName = NonInstFormName)  do
    inc(Result);

//  Result := FirstInstNo(NonInstFormName);
//  if Result < 1 then
//    exit;
//  while Items[Result + 1].FormName = NonInstFormName do
//    inc(Result);
//20170324 Igor <<<
end;

//20170927 Igor>>>
//20180214 Igor >>>
function TFList.InitAffectedForms: Boolean;
var
  SL: TStringList;
  S, FormName, Item: string;
  A, CurrA : TArray<string>;

  function MergeTwoArray(A1, A2: TArray<string>): TArray<string>;
  var L: TStringList;
      I: integer;
  begin
    L := TStringList.Create;
    try
      L.Sorted := True;
      L.Duplicates := dupIgnore;
      for i := Low(A1) to High(A1) do
        L.Add(A1[i]);
      for i := Low(A2) to High(A2) do
        L.Add(A2[i]);
      for i := 0 to L.Count - 1 do
      begin
        SetLength(Result, Length(Result)+1);
        Result[High(Result)] := L.Strings[I];
      end;
    finally
      L.Free;
    end;
  end;

begin
  if FAffectedFormsIsInit then
    Exit(True);
  if TFile.Exists(TPath.Combine(MyApp.AppDir, 'affected.d')) then
  begin
    SL := TStringList.Create;
    //SL.LoadFromFile(TPath.Combine(MyApp.AppDir, 'affected.d')); //20180213 Igor
    try
      for S in SL do
      begin
        FormName := ExtractNonInstFormName(Copy(S, 1, 10).Trim).ToUpper;
        A := Copy(S, 11, maxInt).Split([' '], ExcludeEmpty);
        if FAffectedForms.TryGetValue(UpperCase(FormName), CurrA) then
          A := MergeTwoArray(A, CurrA);
        FAffectedForms.AddOrSetValue(FormName, A);
      end;
      Result := true; //20180213 Igor
    finally
      SL.Free;
    end;
  end;
  FAffectedFormsIsInit := True;
end;
//20180214 Igor <<<

function TFList.GetAffectedForms(AFormName: String): TArray<string>;
var
  Empty: TArray<String>;
begin
  if not InitAffectedForms or not FAffectedForms.TryGetValue(UpperCase(AFormName), Result) then
  begin
    SetLength(Empty, 0);
    Result := Empty;
  end;
end;
//20170927 Igor<<<

function TFList.GetAllInstForms(ANotInstFormName: String; ARetNo: integer = 0): TFRecArray; //20170118 Igor  //20180110 Igor
var
  Z: Integer;
  R: TFRec;
  procedure qSort(var A: TFRecArray; min, max: Integer);
  var
    i, j: Integer;
    Supp, tmp: TFRec;
  begin
    supp := A[max-((max-min) div 2)];
    i := min;
    j := max;
    while i < j do
    begin
      while ExtractFormInstNo(A[i].FormInst) < ExtractFormInstNo(supp.FormInst) do
        i := i + 1;
      while ExtractFormInstNo(A[j].FormInst) > ExtractFormInstNo(supp.FormInst) do
        j := j - 1;
      if i <= j then
      begin
        tmp := A[i];
        A[i] := A[j];
        A[j] := tmp;
        i := i + 1;
        j := j - 1;
      end;
    end;
    if min < j then
      qSort(A, min, j);
    if i < max then
      qSort(A, i, max);
  end;
begin
  Result := TFRecArray.Create(); //20180410 Igor
  //20180111 Igor >>>
  for Z := 0 to Self.Count - 1 do
  begin
    R := Self.Items[Z];
    //20180111 Igor>>>
    If SameText(R.FormName, ANotInstFormName) and
       ((ARetNo = 0)
        or
        ((R.FirstInstFNo = R.FormNo)
         or
         Assigned(RetList[ARetNo]) AND
         not RetList[ARetNo].Destroying and
         RetList[ARetNo].FrmHasData[R.FormNo])) then //20180110 Igor
    //20180111 Igor<<<
    begin
      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1] := R;
    end;
  end;
  //Reorder
  if Length(Result) > 0 then
    qSort(Result, 0, High(Result));
  //20180111 Igor <<<
end;

function TFList.GetApproachedLimit: Boolean; //20160617 Igor
var
  K, I: Integer;
begin
  K := 0;
  for I := low(ByFNo) to High(ByFNo) do
    if ByFNo[I] <> nil then
      Inc(K);
  Result := ((K + 150) >= FormsLimit);
end;

function TFList.GetFormName(FNo: integer): string;
var
  lVarFRec: TFRec;
begin
  lVarFRec := byfno[FNo];
  if lVarFRec = nil then
    Result := ''
  else
    //Result := FRec.FormName;
    Result := lVarFRec.FormInstName; //?
end;

function TFList.GetFormNo(FName: string; Check: boolean): integer;
var
  lVarFRec: TFRec;
begin
  lVarFRec := ByFormName(FName); //duplicates!
  Result := lVarFRec.FormNo;
(* rem all 20151215 Igor
{$IFDEF debug}
  if Check and (Result = 0) then
    ErrorMsg('Form ' + FName + ' not found');
{$ELSE}
{$ENDIF}
*)
end;

function TFList.InitFormsTable(Dir, lFileName, lTableName: string): boolean;
var
  i, ia, f, elm, ndf, FNo, FormFields, MaxArray: integer;
  FName, FieldsFileName: string;
  s, fms, fis: string;
  //Table1: TTable;
  ADConnection: TADConnection;
  ADTableLite1: TADTable;
  //20170927 Igor>>>
  //DBFTableList1: TVKSmartDBF;
  //TableLite1: TDataSet;
  //20170927 Igor<<<
  FmList, FiList: TStringList;
  DataElm: TStringList;
  lVarFRec: TFRec;
{$IFDEF debug}
const
  LogTo: ErrLogMode = elmFile;
{$ELSE}
const
  LogTo: ErrLogMode = elmBoth;
{$ENDIF}

  procedure AdjustFields(fld, i: integer);
  begin
    BugMsg(Format('%s DataIndic uses non-existing field %d',
      [FName, fld]), LogTo);
    //DataElm.Delete(i); //drop fld?
    lVarFRec.FormFields := fld; //extend form?
  end;

  procedure CheckDataIndic;
  var
    i, Fld: integer;
  begin
    (* using FRec - adjust FormFields up?
    *)
    if lVarFRec.DataIndic = '' then
      exit;
    DataElm.CommaText := lVarFRec.DataIndic;
    if DataElm.Count = 0 then
      exit; //no indicators?
    if DataElm[0] = '' then
      exit; //missing check type???
    //strip empty fields
    for i := DataElm.Count - 1 downto 1 do
      if DataElm[i] = '' then
        DataElm.Delete(i);
    //check ElmNo's
    case DataElm[0][1] of
      'F': {depends on other form}
        if ByFormName(DataElm[1]).FormNo < 1 then
        begin
          BugMsg(FName + ' DataIndic refers to non-existing form ' + DataElm[1], LogTo);
          //fix?
          DataElm.Clear; //clear DataIndic
        end;
      'L', //depends on Line
      { TODO : check L DataIndic }
      'Y': exit; //always
      'R': //Range: check all elements [1]..[2]
        begin
          fld := StrToInt(DataElm[1]); //lower bound
          //drop if too high?
          fld := StrToInt(DataElm[2]); //upper bound
          if fld > FormFields then
{$IFDEF debug}
            DataElm[2] := IntToStr(FormFields);
{$ELSE}
            AdjustFields(fld, 2);
{$ENDIF}
        end;
      '0'..'9':
        for i := DataElm.Count - 1 downto 0 do
        begin
          fld := StrToInt(DataElm[i]);
          if fld > FormFields then
{$IFDEF debug}
            DataElm.Delete(i); //remove field
{$ELSE}
            AdjustFields(fld, i);
{$ENDIF}
        end;
    else
      BugMsg(FName + ' unhandled DataIndic: ' + DataElm[0], LogTo);
    end;
    //store fixed string
    lVarFRec.DataIndic := DataElm.CommaText;
  end;

  function RecordDeleted(ADS: TDataSet): Boolean; //20160321 Igor
  Begin
    if ADS is TVKSmartDBF then
      Result := (ADS as TVKSmartDBF).Deleted
    else
      Result := false;
  End;

begin //InitFormsTable
  Result := True;
  //20170927 Igor >>>>
  if pos('\',lFileName)=0 then //only fileName
    lFileName := Dir + '\' + lFileName;
  if not FileExists(lFileName) then
  begin
    BugMsg('No forms DB in ' + ExtractFileDir(lFileName));
    Result := False;
    exit;
  end;
  ADConnection := TADConnection.Create(Application);
  ADTableLite1 := TADTable.Create(Application);
  try
    ADTableLite1.Connection := ADConnection;
    if SameText(ExtractFileExt(lFileName),'.db') then
      SetTableName(ADConnection, ADTableLite1, lFileName, lTableName, 'FormName')
    else
    if SameText(ExtractFileExt(lFileName),'.dbf') then
    Begin
      SetODBCConnect(ADConnection, ExtractFileDir(lFileName));
      ADTableLite1.TableName := ChangeFileExt(ExtractFIleName(lFileName), '');
      ADTableLite1.Active := True;
    End
    else
      exit;
    Clear;
    Sorted := False;
    ADTableLite1.First;
    while not ADTableLite1.EOF do
    begin
      lVarFRec := LoadFromTable(ADTableLite1);
      if isLastYearList then
        FName := MyApp.GetDfmFileNameLY(lVarFRec.FormName)
      else
        FName := MyApp.GetDfmFileName(lVarFRec.FormName);
      if not lVarFRec.DelphiForm and not FileExists(FName) then
      begin
        BugMsg(FName + ' not found', LogTo); //really drop???
        lVarFRec.DelphiForm := True; //prevent further DFM loads
      end;
      if lVarFRec.FormFields = 0 then
        lVarFRec.FormFields := FieldsLimit;
      if lVarFRec.FormAbrev = '' then
        lVarFRec.FormAbrev := lVarFRec.FormName;
      AddRec(lVarFRec);
      lVarFRec.FirstInstFNo := lVarFRec.FormNo;
      ADTableLite1.Next;
    end;
  finally
    freeAndNil(ADTableLite1);
    freeAndNil(ADConnection);
  end;
  Sort;
  //LoadEditBoxProperties
  FieldsFileName := TPath.Combine(Dir, FieldsListD);
//20170927 Igor<<<
  if FileExists(FieldsFileName) then
  begin
    DataElm := TStringList.Create;
    FmList := TStringList.Create;
    FiList := TStringList.Create;
    FmList.LoadFromFile(FieldsFileName);
    for i := 0 to FmList.Count - 1 do
    begin
      fms := FmList[i];
      FiList.CommaText := fms;
      //debug
      FNo := StrToInt(FiList[0]);
      FName := MyApp.AppId + ' ' + FiList[1]; //for messages

      s := FiList[3]; //expected format id: '$'/'D'/'A'/'M'
      if s = 'D' then
        continue //is Delphi form
      else if s = 'A' then
      begin
        //init dynamic arrays
        lVarFRec := byFNo[FNo]; // ByFormNoNil(FNo);
        assert(lVarFRec <> nil, 'No FRec for dynamic arrays');
        MaxArray := FiList.Count - 4; //4..
        SetLength(lVarFRec.BoxesPerRow, MaxArray + 1); //base 0 or 1???
        for ia := 1 to MaxArray do
          lVarFRec.BoxesPerRow[ia] := StrToInt(FiList[ia + 3]);
      end
      else if s = 'M' then
      begin //multi-line components
        lVarFRec := byFNo[FNo]; // ByFormNoNil(FNo);
        assert(lVarFRec <> nil, 'No FRec for dynamic arrays');
        lVarFRec.MaxMemo := StrToInt(FiList[2]);
      end
      else if s = '$' then
      begin
        //init vtDollar arrays, FormFields is max. index
        lVarFRec := byFNo[FNo]; // ByFormNoNil(FNo);
        FormFields := StrToInt(FiList[2]); //from DataIndic - valid!?

        if FormFields = 0 then
          continue; //try skip dummy entries

        //check fields
        if lVarFRec = nil then
        begin
          //add form from fieldslist
          lVarFRec := TFRec.Create;
          lVarFRec.FormNo := FNo;
          lVarFRec.FormName := FiList[1];
          //FRec.FormFields := FormFields;
          FNo := AddRec(lVarFRec);
          if FNo < 1 then //name already exists!?
            lVarFRec := ByFormName(FiList[1]);
          assert(lVarFRec <> nil, 'no such form: ' + FName);
        end;
{$IFDEF fixForms}
        //FormFields := FRec.FormFields;
        assert(self.FieldsLimit > 0, 'init FormFields');
{$ELSE}
        if lVarFRec.FormFields <> FormFields then
        begin
{$IFDEF fast}
{$ELSE}
          //accept (but fix) forms without vtEdits
          if FormFields > 0 then
            BugMsg(Format('%s has only %d fields', [FName, FormFields]), LogTo);
{$ENDIF}
          lVarFRec.FormFields := FormFields;
        end;
{$ENDIF}
        //also check DataIndic?
        CheckDataIndic; //may be wrong!
        //create the vtDollar arrays
        SetLength(lVarFRec.DollarArray, FormFields + 1);
        FillChar(lVarFRec.DollarArray[0], FormFields + 1, 0);
        ndf := FiList.Count - 4; //strip 4 heaader fields
        if ndf > 0 then
        begin
          SetLength(lVarFRec.DollarFields, ndf);
          for f := 4 to FiList.Count - 1 do
          begin
            s := FiList[f];
            elm := StrToInt(s);
            lVarFRec.DollarFields[f - 4] := elm;
            lVarFRec.DollarArray[elm] := True;
          end;
        end;
      end
      else //if s <> '$' then
      begin
        BugMsg('Unknown FieldsList format: ' + s);
        continue;
      end;
    end;
    DataElm.Free;
    FmList.Free;
    FiList.Free;
  end
  else
  begin
    ErrorMsg('Missing ' + FieldsFileName);
    result := False;
  end;
  //alert user
  if not Result then
    UserMsg('Found errors in forms, please run PrepareDistr');
end;

function TFList.AddRec(r: TFRec): integer;
var
  i: integer;
begin
  (* Add to both StringList and array.
    Determine new FormNo if zero
  *)
  //prevent duplicates
  r.FormInstName := r.FormName + r.FormInst; //create instanced name
  i := IndexOf(r.FormInstName);
  if i >= 0 then
  begin
    BugMsg('duplicate FormName: ' + r.FormInstName);
    r.Free;
    Result := 0;
    exit;
  end;
  //add full name
  AddObject(r.FormInstName, r); //with InstNo
  if r.FormInst <> '' then
  begin
    r.InstNo := StrToInt(Copy(r.FormInst, 2, 10));
    //add non-instanced?
    i := IndexOf(r.FormName); //find without InstNo
    if i < 0 then
      AddObject(r.FormName, r); //also add un-instanced
  end;
  //get/create FormNo
  Result := r.FormNo;
  if Result < 1 then
  begin
    for i := 1 to high(byFNo) do
      if ByFNo[i] = nil then
      begin
        Result := i;
        r.FormNo := i;
        break;
      end;
  end;
  if Result < 1 then
    ErrorMsg('FormsLimit exceeded')
  else
    ByFNo[Result] := r;
end;

function TFList.AddPageInstance(RetNo: integer; NonInstFormName,
  FormInst: string): integer;
var
  i: integer;
  App: TApp;
  lVarFRec: TFRec;
begin
  (* Return FormNo.
    Always create form if not yet created - all returns?
  *)
  //check existing instance
  lVarFRec := ByFormName(NonInstFormName + FormInst);
  Result := lVarFRec.FormNo;
  if Result < 1 then
  begin
    //get first instance
    i := IndexOf(NonInstFormName);
    if i < 0 then
    begin
      BugMsg('no such form: ' + NonInstFormName);
      exit; //no such form
    end;
    TObject(lVarFRec) := Objects[i]; // := ByFormName(NonInstFormName);
    lVarFRec := lVarFRec.Clone;
    lVarFRec.FormInst := FormInst;
    Result := AddRec(lVarFRec);
    //create form in all returns
    App := RetList[RetNo].MyApp;
    for i := 1 to RetList.Count - 1 do
    begin
      if RetList[i] = nil then
        continue; //closed return
      if (RetList[i].MyApp = App)
        and (RetList[i].Frm[Result] = nil)
        and ((RetList[i].IsLastYearReturn = RetList[RetNo].IsLastYearReturn)//20160608 Igor
             or
             (RetList[i].isAppendix = RetList[RetNo].isAppendix)) then
        RetList[i].Frm[Result] := TFormData.Create(i, Result);
    end;
  end;
end;

function TFList.GetFormNumberFields(FNo: integer): integer;
var
  lVarFRec: TFRec;
begin
  (* Only used in Load/SaveTV -> must be valid only for first instance of form.
  *)
  lVarFRec := ByFormNoNil(FNo);
  if lVarFRec = nil then
    Result := 0
  else
  begin
{$IFDEF fixForms}
{$ELSE}
    Result := lVarFRec.FormFields;
    if Result = 0 then
{$ENDIF}
      Result := self.FieldsLimit;
  end;
end;

function TFList.IsDollarField(FNo, Elm: integer): boolean;
var
  lVarFRec: TFRec;
begin
  lVarFRec := byFNo[FNo];
  if lVarFRec.FirstInstFNo <> FNo then
    lVarFRec := byFNo[lVarFRec.FirstInstFNo];
  Result := lVarFRec.DollarArray[Elm];
end;

function TFList.IsDollarField(FName: string; Elm: integer): boolean;
var
  lVarFRec: TFRec;
begin
  lVarFRec := ByFormName(FName);
  if lVarFRec.FirstInstFNo <> lVarFRec.FormNo then
    lVarFRec := byFNo[lVarFRec.FirstInstFNo];
  Result := lVarFRec.DollarArray[Elm];
end;

function TFList.FirstInstRec(NonInstFormName: string): TFRec;
begin
  Result := ByFormName(NonInstFormName);
  if Result.FirstInstFNo <> Result.FormNo then
    Result := byFNo[Result.FirstInstFNo];
end;

function TFList.FirstInstRec(FNo: integer): TFRec;
begin
  Result := byFNo[FNo];
  if Result.FirstInstFNo <> FNo then
    Result := byFNo[Result.FirstInstFNo];
end;

procedure TFList.CalcAffectedBy(RetNo: integer; FName: string);
//20170927 Igor>>>
var
  i, k, FNo: integer;
  FInst: string;
  AffectedFName: string; //[15];
begin
  Finst := ExtractFormInst(FName);
  for AffectedFName in GetAffectedForms(ExtractNonInstFormName(FName)) do
  begin
    FNo := GetFormNo(AffectedFName, False);
    if Fno > 0 then {effected is single}
      RetList[RetNo].Calc(RetNo, AffectedFName)
    else
    if GetFormNo(AffectedFName + FInst, False) <> 0 then
      RetList[RetNo].Calc(RetNo, AffectedFName + FInst);
  end;
//20170927 Igor<<<
end;

procedure TFList.Changed;
var
  I: Integer;
begin
  FSortedList.Clear;
  FSortedList.Sorted := False;
  FSortedList.Assign(Self);
  for I := 0 to FSortedList.Count - 1 do
    FSortedList.Objects[I] := TObject(I);
  FSortedList.Sorted := True;
  inherited;
end;

{ TFRec }

function TFRec.Clone: TFRec;
var
  lVarFRec: TFRec;
begin
  (* create an copy of all fields.
    New FormInst has to be inserted afterwards.
    New FormNo is assigned by AddRec.
  *)
  Result := TFRec.Create;
  lVarFRec := Result;
  lVarFRec.Calc := Calc;
  //FRec.FormNo     := Result; - assigned by AddRec
  lVarFRec.FirstInstFNo := FirstInstFNo; //same first instance
  lVarFRec.FormName := FormName;
  //FRec.FormInst   :=  FormInst; {from parameter};
  lVarFRec.FormMxInst := FormMxInst;
  lVarFRec.FormDescr := FormDescr;
  lVarFRec.FormMxPg := FormMxPg;
  lVarFRec.FormRlNm := FormRlNm;
  lVarFRec.FormAbrev := FormAbrev;
  lVarFRec.FormShow := FormShow;
  lVarFRec.FormType := FormType;
  lVarFRec.FormFields := FormFields;
  lVarFRec.ISslip := IsSlip;
  lVarFRec.DataIndic := DataIndic;
  lVarFRec.ShowFlag := ShowFlag;
  lVarFRec.ShowHdr := ShowHdr;
  lVarFRec.Fee := Fee;
  lVarFRec.HowCharged := HowCharged;
  lVarFRec.AddnlForm := AddnlForm;
  lVarFRec.Each_Item := Each_Item;
  lVarFRec.LandScape := LandScape;
  lVarFRec.AddInT1C := AddInT1C;
  //T2 added
  lVarFRec.PdfFile := PdfFile;
  lVarFRec.RSIName := RSIName;
  lVarFRec.MultiPage := MultiPage;
  lVarFRec.DelphiForm := DelphiForm;
  //questionable
  lVarFRec.AddBlankPg := AddBlankPg;
  lVarFRec.CursorPos := CursorPos;
  lVarFRec.FeeAddItem := FeeAddItem;
  lVarFRec.FormHeight := FormHeight;
  lVarFRec.Modal := Modal;
  lVarFRec.Preload := Preload;
  lVarFRec.PrnSeq := PrnSeq;
  lVarFRec.WhiteBoxes := WhiteBoxes;
  lVarFRec.BoxesPerRow := BoxesPerRow;
  lVarFRec.MaxMemo := MaxMemo;
end;
//20171017 Igor>>>
constructor TFRec.Create;
begin
  Allowed := True;
end;
//20171017 Igor<<<
{ TFormData }

constructor TFormData.Create(RNo, FNo: integer);
var
  ia, i: integer;
begin
  inherited Create;
  RetNo := RNo;
  FormNo := FNo;
  //20160710 Igor
  FormDataRec := RetList[RNo].FList.ByFormNoDummy(FNo); //20160327 Igor
  assert(FormDataRec.FormNo = FNo, 'bad FREC');
  //init fields?
  Capacity := FormDataRec.FormFields + 1;
  for i := 0 to FormDataRec.FormFields do
    add('');
  //init memos
  if FormDataRec.MaxMemo > 0 then
    SetLength(Memos, FormDataRec.MaxMemo + 1); //index 1..MaxMemo
  //init dynamic arrays
  if Length(FormDataRec.BoxesPerRow) > 0 then
  begin
    SetLength(Dyn, Length(FormDataRec.BoxesPerRow));
    for ia := 1 to high(Dyn) do
      SetLength(Dyn[ia], FormDataRec.BoxesPerRow[ia] + 1);
  end;
  //20170609 Igor >>>
  DynOverload := TDynamicDataOverload.Create;
  FDisableSaveOverrideCount := 0;
  //20170609 Igor <<<
end;

//{$IFDEF debug} //20170609 Igor

destructor TFormData.Destroy;
begin
  inherited;
  FreeAndNil(DynOverload); //20170609 Igor
end;
procedure TFormData.DisableSaveOverride;
begin
  Inc(FDisableSaveOverrideCount);
end;

procedure TFormData.EnableSaveOverride;
begin
  if FDisableSaveOverrideCount > 0 then
    Dec(FDisableSaveOverrideCount);
end;

//{$ELSE}{$ENDIF} //20170609 Igor

function TFormData.Get(Index: Integer): string;
var
  ovr: TOverRec;
{$IFDEF debug}
const
  LogTo = elmFile;
{$ELSE}
const
  LogTo = elmBoth;
{$ENDIF}
begin
  (* Handle dynamic arrays.
    Extend arrays (only?) while loading from file!?
    Handle overrides
  *)
  Result := '';
  if Count = 0 then
  begin
    ErrorMsg('form not initialized');
  end
  else if Index > ArrayMul then
  begin
    //dynamic data
    //20170609 igor >>>
    ovr := nil;
    if Self.DynOverload.TryGetValue(index, TObject(ovr)) and Assigned(ovr) then
      Result := ovr.Value
    else
    //20170609 igor <<<
    if SplitId(Index, True, False) then //20160212 Igor
      Result := Dyn[arrayNo, DynElmIdx];
  end
  else if Index >= Count then
  begin
    BugMsg(Format('GET form %s index %d >= Count %d', [FormDataRec.FormInstName, Index, Count]), LogTo);
  end
  else
  begin
    TObject(ovr) := Objects[index];
    if assigned(ovr) then
      Result := ovr.Value
    else
      Result := inherited Get(Index);
  end;
end;

procedure TFormData.Put(Index: Integer; const S: string);
var
  i: integer;
  ovr: TOverRec;
{$IFDEF debug}
const
  LogTo = elmFile;
{$ELSE}
const
  LogTo = elmBoth;
{$ENDIF}
begin
  if Count = 0 then
  begin
    ErrorMsg('form not initialized');
  end
  else if Index > ArrayMul then
  begin
    //dynamic data - extend only when loading from file!?
    //20170609 igor >>>
    ovr := nil;
    if (FDisableSaveOverrideCount = 0) AND Self.DynOverload.TryGetValue(index, TObject(ovr)) and Assigned(ovr) then
      ovr.Value := S
    else
    //20170609 igor <<<
    if SplitId(Index, True, true) then //20160212 Igor
      Dyn[ArrayNo, DynElmIdx] := s;
  end
  else if Index >= Count then
  begin
    //  BugMsg(Format('PUT form %s index %d >= Count %d, value %s',[FRec.FormInstName, Index, Count, S]), LogTo); //20150426
    if S = '' then
      exit; //ignore?
    for i := Count to Index do
      Add(''); //recursion?
    inherited;
  end
  else if (FDisableSaveOverrideCount > 0) or (Objects[Index] = nil) then //20170609 Igor
    inherited;
  //else keep override? must add PutOverride
end;

procedure TFormData.ReassignFRec(Value: TFRec);
begin
  FFRec := Value;
end;

function TFormData.SplitId(ElmNo: integer; fExtend: boolean; ChangeSize: Boolean): boolean; //20160212 Igor
begin
  (* Called for every dynamic ElmNo, from everywhere.
    Init global variables in vtDynData
  *)
  Result := ElmNo > ArrayMul;
  if not Result then
    exit; //not an array ID
  ArrayNo := ElmNo div ArrayMul; //-ArrayBase
  DynElmIdx := ElmNo - ArrayNo * ArrayMul; //-ElmBase
  //extend as required - move into ...?
  Result := ArrayNo <= high(Dyn);
  if not Result then
  begin
    BugMsg('No such array: ' + IntToStr(ElmNo));
    exit; //no such array
  end;
  BoxesPerRow := FormDataRec.BoxesPerRow[ArrayNo];
  RowNo := (DynElmIdx - ElmBase) div BoxesPerRow; //assume dummy at [0]?
  MaxElm := high(Dyn[arrayNo]); //=Count-1
  TopRow := (MaxElm - ElmBase) div BoxesPerRow;
  Result := DynElmIdx <= MaxElm;
  if not Result AND ChangeSize then //20160212 Igor
  begin
    if not fExtend then
    begin
      BugMsg('No such element: ' + IntToStr(ElmNo));
      exit; //index too high
    end;
    //ErrorMsg('Extend DynArray'); - not when loading from file
    while MaxElm < DynElmIdx do
      inc(MaxElm, BoxesPerRow); //add required number of rows
    SetLength(Dyn[ArrayNo], MaxElm + ElmBase); //round up to BoxesPerRow
    //added elements are initialized to ''
    Result := True; //missing fields allocated
  end;
end;

procedure TFormData.SetFRec(Value: TFRec); //20160319 Igor
Begin
  if FFRec = Value then exit;
  if FFRec <> nil then
    ErrorMsg('Reassignment FRec!')
  else
    FFRec := Value;
End;

function TFormData.GetFRec: TFRec; //20160319 Igor
Begin
  Result := FFRec;
End;

function TFormData.MaxDynamicElm(FieldId: integer): integer;
begin
  Result := high(Dyn[FieldId div ArrayMul]);
end;

function TFormData.MaxRow(ArrNo: integer): integer;
var
  I: Integer;
  HaveData: Boolean;
begin
  //20160719 Igor >>>
  // check last row/ if not is empty - add
  HaveData := False;
  for I := high(Dyn[ArrNo]) downto high(Dyn[ArrNo]) - FormDataRec.BoxesPerRow[ArrNo] + 1 do
  begin
    if Dyn[ArrNo][I] <> '' then
    begin
      HaveData := True;
      break;
    end;
  end;
  if HaveData then
  begin
    SetLength(Dyn[ArrNo], Length(Dyn[ArrNo]) + FormDataRec.BoxesPerRow[ArrNo]);
  end;
  //20160719 Igor <<<
  Result := (high(Dyn[ArrNo]) - ElmBase) div FormDataRec.BoxesPerRow[ArrNo];//20160203 Igor //20160212 Igor
end;

//20170609 Igor >>>
procedure TFormData.SwapDynamicOverride(ATableID, ARow1, ARow2: Integer);
var
  Buf: TDynamicDataOverload;
  FirstCell1, LastCell1, FirstCell2, LastCell2, I: Integer;
  P: TPair<Integer, TObject>;
begin
  Buf := TDynamicDataOverload.Create;
  try
    FirstCell1 := (ATableID * ArrayMul) + ((ARow1 - 1) * FormDataRec.BoxesPerRow[ATableID]) + 1;
    LastCell1 := (ATableID * ArrayMul) + ((ARow1 - 1) * FormDataRec.BoxesPerRow[ATableID]) + FormDataRec.BoxesPerRow[ATableID];
    FirstCell2 := (ATableID * ArrayMul) + ((ARow2 - 1) * FormDataRec.BoxesPerRow[ATableID]) + 1;
    LastCell2 := (ATableID * ArrayMul) + ((ARow2 - 1) * FormDataRec.BoxesPerRow[ATableID]) + FormDataRec.BoxesPerRow[ATableID];
    for I := FirstCell1 to LastCell1 do
    begin
      if DynOverload.ContainsKey(I) then
      begin
        Buf.Add(I, DynOverload.Items[I]);
        TurnOffOnOverride(I, -1);
        DynOverload.Remove(I);
      end;
    end;
    for I := FirstCell2 to LastCell2 do
    begin
      if DynOverload.ContainsKey(I) then
      begin
        P := DynOverload.ExtractPair(I);
        TurnOffOnOverride(P.Key, P.Key + (ARow1 - ARow2) * FormDataRec.BoxesPerRow[ATableID]);
        TOverRec(P.Value).FieldId := P.Key + (ARow1 - ARow2) * FormDataRec.BoxesPerRow[ATableID];
        DynOverload.Add(P.Key + (ARow1 - ARow2) * FormDataRec.BoxesPerRow[ATableID], P.Value);
        DynOverload.Remove(P.Key);
      end;
    end;
    for P in Buf do
    begin
      TurnOffOnOverride(-1, P.Key - (ARow1 - ARow2) * FormDataRec.BoxesPerRow[ATableID]);
      TOverRec(P.Value).FieldId := P.Key - (ARow1 - ARow2) * FormDataRec.BoxesPerRow[ATableID];
      DynOverload.Add(P.Key - (ARow1 - ARow2) * FormDataRec.BoxesPerRow[ATableID], P.Value);
    end;
  finally
    Buf.Free;
  end;
end;

procedure TFormData.DeleteDynamicOverride(ATableID, ARow: Integer);
var
  FirstCell, LastCell, I: Integer;
  P: TPair<Integer, TObject>;
begin
  FirstCell := (ATableID * ArrayMul) + ((ARow - 1) * FormDataRec.BoxesPerRow[ATableID]) + 1;
  LastCell := (ATableID * ArrayMul) + ((ARow - 1) * FormDataRec.BoxesPerRow[ATableID]) + FormDataRec.BoxesPerRow[ATableID];
  for I := FirstCell to LastCell do
    if DynOverload.ContainsKey(I) then
    begin
      P := DynOverload.ExtractPair(I);
      TurnOffOnOverride(P.Key, -1);
      OverList.Remove(P.Value);
      DynOverload.Remove(I);
    end;
  ShiftUpDynamicOverride(ArrayNo, RowNo + 1);
end;

procedure TFormData.MoveDynamicOverride(ATableID, ARow1, ARow2: Integer);
var
  Buf: TDynamicDataOverload;
  FirstCell1, LastCell1, FirstCell2, LastCell2, I, J: Integer;
  P: TPair<Integer, TObject>;
begin
  if ARow1 = ARow2 then
    exit;
  Buf := TDynamicDataOverload.Create;
  try
    FirstCell1 := (ATableID * ArrayMul) + ((ARow1 - 1) * FormDataRec.BoxesPerRow[ATableID]) + 1;
    LastCell1 := (ATableID * ArrayMul) + ((ARow1 - 1) * FormDataRec.BoxesPerRow[ATableID]) + FormDataRec.BoxesPerRow[ATableID];
    FirstCell2 := (ATableID * ArrayMul) + ((ARow2 - 1) * FormDataRec.BoxesPerRow[ATableID]) + 1;
    LastCell2 := (ATableID * ArrayMul) + ((ARow2 - 1) * FormDataRec.BoxesPerRow[ATableID]) + FormDataRec.BoxesPerRow[ATableID];
    I := Math.Min(FirstCell1, FirstCell2);
    J := Math.Max(LastCell1, LastCell2);
    while I <= J do
    Begin
      if DynOverload.ContainsKey(I) then
      begin
        Buf.Add(I, DynOverload.Items[I]);
        DynOverload.Remove(I);
      end;
      inc(I);
    end;
    for P in Buf do
    begin
      if (P.Key >= FirstCell1) AND (P.Key <= LastCell1) then
      Begin
        TurnOffOnOverride(P.Key, P.Key - (ARow1 - ARow2) * FormDataRec.BoxesPerRow[ATableID]);
        TOverRec(P.Value).FieldId := P.Key - (ARow1 - ARow2) * FormDataRec.BoxesPerRow[ATableID];
        DynOverload.Add(P.Key - (ARow1 - ARow2) * FormDataRec.BoxesPerRow[ATableID], P.Value)
      End
      else
      if ARow1 < ARow2 then
      Begin
        TurnOffOnOverride(P.Key, P.Key - FormDataRec.BoxesPerRow[ATableID]);
        TOverRec(P.Value).FieldId := P.Key - FormDataRec.BoxesPerRow[ATableID];
        DynOverload.Add(P.Key - FormDataRec.BoxesPerRow[ATableID], P.Value)
      End
      else
      begin
        TurnOffOnOverride(P.Key, P.Key + FormDataRec.BoxesPerRow[ATableID]);
        TOverRec(P.Value).FieldId := P.Key + FormDataRec.BoxesPerRow[ATableID];
        DynOverload.Add(P.Key + FormDataRec.BoxesPerRow[ATableID], P.Value);
      end;
    end;
  finally
    Buf.Free;
  end;
end;

procedure TFormData.ShiftUpDynamicOverride(ATableID, ARow: Integer);
var
  Buf: TDynamicDataOverload;
  FirstCell, LastCell, I, J: Integer;
  P: TPair<Integer, TObject>;
begin
  Buf := TDynamicDataOverload.Create;
  try
    FirstCell := (ATableID * ArrayMul) + ((ARow - 1) * FormDataRec.BoxesPerRow[ATableID]) + 1;
    LastCell := (ATableID * ArrayMul) + high(Dyn[ATableID]);
    I := FirstCell;
    J := LastCell;
    while I < J do
    Begin
      if DynOverload.ContainsKey(I) then
      begin
        Buf.Add(I, DynOverload.Items[I]);
        DynOverload.Remove(I);
      end;
      inc(I);
    end;
    for P in Buf do
    begin
      TurnOffOnOverride(P.Key, P.Key - FormDataRec.BoxesPerRow[ATableID]);
      TOverRec(P.Value).FieldId := P.Key - FormDataRec.BoxesPerRow[ATableID];
      DynOverload.Add(P.Key - FormDataRec.BoxesPerRow[ATableID], P.Value)
    end;
  finally
    Buf.Free;
  end;
end;

procedure TFormData.ShiftDownDynamicOverride(ATableID, ARow: Integer);
var
  Buf: TDynamicDataOverload;
  FirstCell, LastCell, I, J: Integer;
  P: TPair<Integer, TObject>;
begin
  Buf := TDynamicDataOverload.Create;
  try
    FirstCell := (ATableID * ArrayMul) + 1;
    LastCell := (ATableID * ArrayMul) + ((ARow - 1) * FormDataRec.BoxesPerRow[ATableID]) + FormDataRec.BoxesPerRow[ATableID];
    I := FirstCell;
    J := LastCell;
    while I < J do
    Begin
      if DynOverload.ContainsKey(I) then
      begin
        Buf.Add(I, DynOverload.Items[I]);
        DynOverload.Remove(I);
      end;
      inc(I);
    end;
    for P in Buf do
    begin
      TurnOffOnOverride(P.Key, P.Key + FormDataRec.BoxesPerRow[ATableID]);
      TOverRec(P.Value).FieldId := P.Key + FormDataRec.BoxesPerRow[ATableID];
      DynOverload.Add(P.Key + FormDataRec.BoxesPerRow[ATableID], P.Value);
    end;
  finally
    Buf.Free;
  end;
end;

procedure TFormData.TurnOffOnOverride(AElementOff, AElementOn: Integer);
var
  sb: TScrollBox;
  Ed: TComponent;
begin
  sb := RetList[Self.RetNo].MyChild.GetScrollbox(Self.FormNo);
  if Assigned(sb) then
  begin
    if AElementOff > 0 then
    begin
      Ed := sb.FindComponent('vtEdit' + AElementOff.ToString);
      if Assigned(Ed) AND (Ed is TvtEdit) then
      begin
        TvtEdit(Ed).vtDataSource := vtCalc;
        TvtEdit(Ed).vtPrefix := '';
      end;
    end;
    if AElementOn > 0 then
    begin
      Ed := sb.FindComponent('vtEdit' + AElementOn.ToString);
      if Assigned(Ed) AND (Ed is TvtEdit) then
      begin
        TvtEdit(Ed).vtDataSource := vtOverride;
        TvtEdit(Ed).vtPrefix := '* ';
      end
    end;
  end;
end;

//20170609 Igor <<<

procedure TFormData.DeleteRowData(id: integer);
var
  i, FromElm: integer;
  arr: TDynArray;
begin
  (* delete from Dyn[arr][from]<-[from+BoxesPerRow]
  *)
  arr := nil; //keep compiler happy
  if SplitId(id, False, False) and (TopRow > 0) then //don't delete first row //20160212 Igor
  begin
    arr := Dyn[ArrayNo];
    if RowNo < TopRow then
    begin //remove row in between
      FromElm := RowNo * BoxesPerRow + ElmBase;
      for i := FromElm to high(arr) - BoxesPerRow do
        arr[i] := arr[i + BoxesPerRow];
    end;
    //squeeze array
    SetLength(Dyn[arrayNo], Length(Dyn[arrayNo]) - BoxesPerRow);
    DeleteDynamicOverride(ArrayNo, RowNo); //20170609 Igor
  end
  else
    UserMsg('Cannot delete last row');
end;

procedure TFormData.AddRowData(id: integer);
begin
  (* Called when user adds a row
  *)
  SplitId(id, True, True); //20160212 Igor
  SetLength(Dyn[arrayNo], Length(Dyn[arrayNo]) + BoxesPerRow);
end;

procedure TFormData.SwapRow(const ATableID, ARow1, ARow2: Integer); //20170407 Igor
var
  I, B: Integer;
  Buf: String;
begin
  B := FormDataRec.BoxesPerRow[ATableID];
  for I := 1 to B do
  begin
    Buf := Dyn[ATableID][((ARow1 - 1) * B) + I];
    Dyn[ATableID][((ARow1 - 1) * B) + I] := Dyn[ATableID][((ARow2 - 1) * B) + I];
    Dyn[ATableID][((ARow2 - 1) * B) + I] := Buf;
  end;
  SwapDynamicOverride(ATableID, ARow1, ARow2); //20170609 Igor
end;

procedure TFormData.MoveRow(const ATableID, ARow1, ARow2: Integer); //20170411 Igor
var
  I, B, R, Step: Integer;
  Buf: Array of String;
Begin
  B := FormDataRec.BoxesPerRow[ATableID];
  SetLength(Buf, B);
  if ARow1 < ARow2 then
    Step := +1
  else
    Step := -1;

  for I := 1 to B do
    Buf[I - 1] := Dyn[ATableID][((ARow1 - 1) * B) + I];
  R := ARow1;
  while R <> ARow2 do
  Begin
    for I := 1 to B do
      Dyn[ATableID][((R - 1) * B) + I] := Dyn[ATableID][(((R - 1) + Step) * B) + I];
    R := R + Step;
  End;
  for I := 1 to B do
    Dyn[ATableID][((ARow2 - 1) * B) + I] := Buf[I - 1];

  MoveDynamicOverride(ATableID, ARow1, ARow2); //20170609 Igor
End;

procedure TFormData.InsertBeforeRowData(const ATableID, ARow: Integer); //20170407 Igor
var
  I, B, First, Last: Integer;
begin
  B := FormDataRec.BoxesPerRow[ATableID];
  SetLength(Dyn[ATableID], Length(Dyn[ATableID]) + B);
  First := ARow * B + 1;
  Last := High(Dyn[ATableID]);
  for I := Last downto First do
    Dyn[ATableID][I] := Dyn[ATableID][I - B];
  for I := First - 1 downto First - B do
    Dyn[ATableID][I] := '';
  ShiftDownDynamicOverride(ATableID, ARow); //20170609 Igor
end;

{$IFDEF old}

procedure TFormData.PopulateWithData(ACtrl: TWinControl);
var
  i, Fld: integer;
  s: string;
  cmp: TComponent;
  ctl: TControl;
  wctl: TWinControl absolute ctl;
  MyEditBox: TVtEdit;
  MyLabel: TvtLabel;
  MyMemoBox: TvtMemo;
  MyRichEdit: TRichEdit;
begin
  (* populate real form: all Components[]
    populate WinCtrl: all contained Controls[], nesting!
  *)
  if ACtrl is TvtScrollBox then
  begin
    TvtScrollBox(ACtrl).PopulateFormWithData;
  end;
  for i := 0 to ACtrl.ControlCount - 1 do
  begin
    ctl := ACtrl.Controls[i];
    if not (ctl is TWinControl) then
      continue;
    Fld := GetFieldId(ctl.Name);
    if ShowFieldIdSw then
      s := '[' + IntToStr(Fld) + ']';
    //case ctl.ClassType of - not applicable
    if ctl.ClassType = TvtEdit then
    begin
      MyEditBox := TvtEdit(ctl);
      MyEditBox.vtVertSeparator := False; //201209/01
      //If MyEditBox.vtDataSource=vtCalc then MyEditBox.TabStop:=False;
      if not ShowFieldIdSw then
        //ShowFieldData(MyEditBox,FNo);
        s := Elms[Fld]; //include dynamic data
      MyEditBox.Text := s
    end
    else if (ctl.ClassType = TvtMemo) then
    begin
      MyMemoBox := TvtMemo(ctl);
      if not ShowFieldIdSw then
        //ShowMemoData(MyMemoBox,RetNo,FNo);
        s := Memos[Fld];
      MyMemoBox.Text := s
    end
      //else if ctl.ClassType = TwwDbRichEdit then
    else if ctl.InheritsFrom(TRichEdit) then
    begin
      MyRichEdit := TRichEdit(ctl);
      if not ShowFieldIdSw then
        //ShowInterpretedRichData(MyRichEdit,MyScrollBox.FormName,FNo);
        s := Memos[Fld];
      MyRichEdit.Text := s
    end
    else
      PopulateWithData(wctl);
  end;
end;
{$ELSE}
{$ENDIF}

procedure TFormData.ClrForm;
var
  i, ia: integer;
begin
  (* Override to init forms with default values
  *)
  if Self = nil then
    exit; //bad call
  //clear simple elements
  RemoveFormOverrides(RetNo, FormNo);
  for i := 1 to Count - 1 do
    Strings[i] := '';
  //clear dynamic arrays - values only!
  for ia := 1 to high(Dyn) do
  begin
    for i := 0 to high(Dyn[ia]) do
      Dyn[ia, i] := '';
    SetLength(Dyn[ia], FormDataRec.BoxesPerRow[ia] + 1); //20160527 Igor
  end;
  //clear memos...
  for i := 1 to high(Memos) do
    Memos[i] := '';
end;

{ TMyStringList }

procedure TMyStringList.SetCapacity(NewCapacity: Integer);
begin
  if NewCapacity < Count then
    SetCount(NewCapacity);
  inherited SetCapacity(NewCapacity);
end;

procedure TMyStringList.SetCount(const Value: integer);
var
  i: integer;
begin
  for i := GetCount - 1 downto Value do
    Delete(i);
end;

{ TDataDictList }

function TDataDictList.GetRec(index: integer): TDataDict;
begin
  TObject(Result) := Objects[index]; // GetItem(index);
end;

procedure TDataDictList.Load(AppDir: string);
var
  DataDictRec: TDataDict;
  ADConnection: TADConnection;
  Table1: TADTable;
begin
  {Try}
  //20170410 Igor >>>
  if AppDir = FDirLoaded then
    exit;
  FDirLoaded := AppDir;
  OwnsObjects := True;
  //20170410 Igor <<<
  Clear; //DataDictList.Free;
  //DataDictList  := TList.Create;

  //20150915 Igor
  ADConnection:= TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  try//20170410 Igor
    SetTableName(ADConnection, Table1, AppDir + '\' + DictDBLite, DictTableLite, 'KeyWord');

    {load in memory into DataDictRec}
    Table1.First;
    while not Table1.EOF do
    begin
      DataDictRec := TDataDict.Create; //New(DataDictRec);
      DataDictRec.KeyWord := Table1.FieldByName('KeyWord').AsString;
      DataDictRec.FormName := UpperCase(Table1.FieldByName('FormName').AsString);
      DataDictRec.Field_No := Table1.FieldByName('Field_No').AsInteger;
      DataDictRec.Is_Amount := Table1.FieldByName('Is_Amount').AsString;
      {DataDictList.}AddObject(DataDictRec.KeyWord, DataDictRec);
      Table1.Next;
    end;
    Table1.Close;
  //20170410 Igor >>>
  finally
    Table1.Free;
    ADConnection.Free;
  end;
  //20170410 Igor <<<
end;

function TDataDictList.GetKeyWAttributes(KeyW: string; var FName: string; var Elm: Integer; var IsAmount: string): boolean;
//Procedure GetKeyWAttributes(KeyW: String;Var FName:String; Var Elm:Integer;Var IsAmount:String);
var
  I: integer;
  DataDictRec: TDataDict;
begin
  Result := True; //assume found
  for i := 0 to (Count - 1) do
  begin
    DataDictRec := Items[i];
    if KeyW = DataDictRec.KeyWord {//MidStr( ,1,255)???} then
    begin
      FName := DataDictRec.FormName;
      Elm := DataDictRec.Field_No;
      IsAmount := DataDictRec.Is_Amount;
      Exit;
    end;
  end;
  //not found
  Result := False;
  IsAmount := ''; //in case not found
end;

function CleanUpKeyW(KeyW: string): string;
//comes as If (keywxxx > 0)  etc > < || ! && etc
// also Need Ffix in front of dollar variables
var
  k: Integer;
begin
  Result := KeyW;

  KeyW := StringReplace(KeyW, 'IF (', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, 'IF(', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, 'ELSIF (', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, 'ELSIF(', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, 'ELSIF(', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, ')', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, '''', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, '"', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, '=', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, '>', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, '<', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, '||', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, '&&', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, '!', ' ', [rfReplaceAll, rfIgnoreCase]);

  Result := alltrim(KeyW);
end;

function TDataDictList.InDataDict(KeyW: string): Boolean;
//case insensitive comparison
var
  I: integer;
  DataDictRec: TDataDict;
begin
  KeyW := UpperCase(KeyW);
  //assumed present
  if (LeftStr(KeyW, 5) = 'LINE_')
    or (LeftStr(KeyW, 5) = 'FORM_')
    or (LeftStr(KeyW, 4) = 'FNUM')
    or (LeftStr(KeyW, 4) = 'FIMG') then
  begin Result := True;
    Exit;
  end;

  Result := False;
  for i := 0 to (Count - 1) do
  begin
    DataDictRec := Items[i];
    if KeyW = UpperCase(MidStr(DataDictRec.KeyWord, 1, 100)) then
    begin Result := True;
      Exit;
    end;
  end;
end;

function TDataDictList.ValidateLetter(ARichEdit: tRichEdit): string;
var
  KeyWList: TStringList;
  I: integer;
  {
   KeyW:string;
   Buffer:Pchar;
   WorkBuffer:Pchar;
   Size:Word;
   OrdKeyW:integer;
   LineNum:integer;
   J,L: integer;
   MaxLine:integer;
   s:string;
  }
begin
  ARichEdit.SelStart := 0;
  ARichEdit.SelLength := 0;

  result := '';
  KeyWList := TStringList.Create;
  if GetKeyWListFromRichEdit(Self, ARichEdit, KeyWList) = False then
  begin
    UserMsg('Keyword opening and closing brackets are not in pairs');
    Exit;
  end;
  //LoadDataDict;

  for i := 0 to KeyWList.Count - 1 do
  begin
    if InDataDict(KeyWList[i]) = False then
    begin
      Result := KeywList[i];
      KeyWList.Free;
      Exit;
    end;
  end;
  Result := '';
  KeyWList.Free;
  ARichEdit.SelStart := 0;
  ARichEdit.SelLength := 0;
end;

{ TSQLitePassword }

constructor TSQLitePassword.create(Owner: TApp);
begin
  inherited create;
  FApp := Owner;
end;

function TSQLitePassword.GetCurrentPassword: String;
begin
  Result := FApp.GetSQLLitePassword(GC_SQLLitePasswordVersion);
end;

function TSQLitePassword.GetPassword(Version: Integer): String;
begin
  if Version < 0 then
    Version := 0;
  if Version > GC_SQLLitePasswordVersion then
    Version := GC_SQLLitePasswordVersion;
  Result := FApp.GetSQLLitePassword(Version);
end;

function TSQLitePassword.PassArray: Variant; //20160415 Igor
var
  I: Integer;
begin
  Result := VarArrayCreate([0,GC_SQLLitePasswordVersion],varOleStr);
  for I :=  VarArrayLowBound(Result, 1) to VarArrayHighBound(Result, 1) do
    VarArrayPut(Result, FApp.GetSQLLitePassword(I), [I]);
end;

function TSQLitePassword.PassRFArray: Variant;
var
  I: Integer;
  Arr: Variant;
begin
  Arr := VarArrayCreate([0,GC_SQLLitePasswordVersion],varOleStr);
  for I :=  VarArrayLowBound(Arr, 1) to VarArrayHighBound(Arr, 1) do
    VarArrayPut(Arr, FApp.GetSQLLiteRFPassword(I), [I]);
  Result := Arr;
end;

function TSQLitePassword.RFGetCurrentPassword: String;
begin
  Result := FApp.GetSQLLiteRFPassword(GC_SQLLitePasswordVersion);
end;

function TSQLitePassword.RFGetPassword(Version: Integer): String;
begin
  if Version < 0 then
    Version := 0;
  if Version > GC_SQLLitePasswordVersion then
    Version := GC_SQLLitePasswordVersion;
  Result := FApp.GetSQLLiteRFPassword(Version);
end;

{ TApp2016 }

constructor TApp2016.Create(AAppList: TAppList);
begin
  inherited;
  FCoreVersion := '2016.01';
end;

function ExeYear: String; //20161212 Igor
begin
  case InternalExeYear of
    iey2015: result := 'VT-2015';
    iey2016: result := 'VT-2016';
    iey2017: result := 'VT-2017';
    iey2018: result := 'VT-2018';
    iey2019: result := 'VT-2019';
    iey2020: result := 'VT-2020';
    iey2020: result := 'VT-2021';
  end;
end;

function MainHelpFile: String; //20161220 Igor
begin
  case InternalExeYear of
    iey2015: result := 'http://www.visualtax.com/Vt2015HELP/vtBaseHelp/vt2015Help.html';
    iey2016: result := 'http://www.visualtax.com/Vt2016HELP/vtBaseHelp/vt2016Help.html';
    iey2017: result := 'http://www.visualtax.com/Vt2017HELP/vtBaseHelp/vt2017Help.html';
    iey2018: result := 'http://www.visualtax.com/Vt2018HELP/vtBaseHelp/vt2018Help.html';
    iey2019: result := 'http://www.visualtax.com/Vt2019HELP/vtBaseHelp/vt2019Help.html';
    iey2020: result := 'http://www.visualtax.com/Vt2020HELP/vtBaseHelp/vt2020Help.html';
    iey2021: result := 'http://www.visualtax.com/VT2023HELP/vtBaseHelp/VT2023Help.html';
  end;
end;

function MainHelpUpdFile: String; //20161220 Igor
begin
  case InternalExeYear of
    iey2015: result := 'http://www.visualtax.com/Vt2015HELP/vtBaseHelp/vtUpd/vtUpdHlp.html';
    iey2016: result := 'http://www.visualtax.com/Vt2016HELP/vtBaseHelp/vtUpd/vtUpdHlp.html';
    iey2017: result := 'http://www.visualtax.com/Vt2017HELP/vtBaseHelp/vtUpd/vtUpdHlp.html';
    iey2018: result := 'http://www.visualtax.com/Vt2018HELP/vtBaseHelp/vtUpd/vtUpdHlp.html';
    iey2019: result := 'http://www.visualtax.com/Vt2019HELP/vtBaseHelp/vtUpd/vtUpdHlp.html';
    iey2020: result := 'http://www.visualtax.com/Vt2020HELP/vtBaseHelp/vtUpd/vtUpdHlp.html';
    iey2021: result := 'http://www.visualtax.com/Vt-2021-WhatsNew.html';  //con 20211216
  end;
end;

function ProjectYear: Integer; //20190306 Igor
begin
  case InternalExeYear of
    iey2015: result := 2015;
    iey2016: result := 2016;
    iey2017: result := 2017;
    iey2018: result := 2018;
    iey2019: result := 2019;
    iey2020: result := 2020;
    iey2021: result := 2021;
  end;
end;

//20170112 Igor >>>

function GetDateUpdateFromIni(AIniFile: string): string; //20190917 Igor
var FIniFile: TIniFile;
begin
  Result := '';
  if not FileExists(AIniFile) then Exit;
  FIniFile := TIniFile.Create(AIniFile);
  try
    Result := FIniFile.ReadString('Main', 'DateUpdate', '');
  finally
    FIniFile.Free;
  end;
end;

//20191007 Igor >>>
//function GetFullDateUpdate: string; //20190917 Igor
//begin
//  Result := GetDateUpdateFromIni(TPath.Combine(ExtractFilePath(Application.ExeName), 'vtUpdateFull.ini'));
//end;
//20191007 Igor <<<

function GetUtilitiesDateUpdate: string; //20190917 Igor
begin
  Result := GetDateUpdateFromIni(TPath.Combine(ExtractFilePath(Application.ExeName), 'vtUpdateUtilities.ini'));
end;

{ TAppProfile }

class procedure TAppProfile.CloneSettings(AConnection: TADConnection;
  const AFromUser, AToUser: String);
begin
  TAppProfile.DeleteAllOverloadProperty(AConnection, AToUser);
  AConnection.ExecSQL('INSERT OR REPLACE INTO `Overload_Options`(`LOGIN_ID`, `TaxModule`, `OptionsName`, `OptionsValue`) ' +
    'Select '+QuotedStr(AToUser)+', T.`TaxModule`, T.`OptionsName`, T.`OptionsValue` ' +
    'From `Overload_Options` AS T '+
    'Where upper(T.`LOGIN_ID`) = upper(' + QuotedStr(AFromUser) + ')');
end;

constructor TAppProfile.Create(AApp: TApp; AConnection: TADConnection);
begin
  inherited Create;
  FApp := AApp;
  FConnection := AConnection;
end;

procedure TAppProfile.DeleteAllOverloadProperty;
begin
  TAppProfile.DeleteAllOverloadProperty(FConnection, FLogin_ID, FApp.AppID)
end;

class procedure TAppProfile.DeleteAllOverloadProperty(AConnection: TADConnection;
  const AUser, AApp: String);
begin
  AConnection.ExecSQL('DELETE from Overload_Options Where Upper(`Login_ID`) = upper('+QuotedStr(AUser)+ ')' +
              ' AND `TaxModule` = '+QuotedStr(AApp));
end;

class procedure TAppProfile.DeleteAllOverloadProperty(
  AConnection: TADConnection; const AUser: String);
begin
  AConnection.ExecSQL('DELETE from Overload_Options Where upper(`Login_ID`) = upper('+QuotedStr(AUser)+')');
end;

procedure TAppProfile.DeleteOverloadProperty(const APropertyName: String);
begin
  FConnection.ExecSQL('Delete from Overload_Options Where upper(`Login_ID`) = upper('+QuotedStr(FLogin_ID)+ ')' +
              ' AND `TaxModule` = '+QuotedStr(FApp.AppID)+
              ' AND lower(`OptionsName`) = lower('+quotedStr(APropertyName)+')');
end;

destructor TAppProfile.Destroy;
begin
  inherited;
end;

function TAppProfile.EqualOverloadProperty(const APropertyName, ACompareValue: String;
  ACaseInsensitive: Boolean): Boolean;
begin
  with TADQuery.Create(nil) do
  begin
    try
      Connection := FConnection;
      Open('Select OptionsValue from Overload_Options Where upper(`Login_ID`) = upper('+QuotedStr(FLogin_ID) + ')' +
           ' AND `TaxModule` = '+QuotedStr(FApp.AppID)+
           ' AND lower(`OptionsName`) = lower('+quotedStr(APropertyName)+')');
      if not isempty then
      begin
        if ACaseInsensitive then
          Result := SameText(ACompareValue, fieldByName('OptionsValue').asString)
        else
          Result := ACompareValue = fieldByName('OptionsValue').asString;
      end
      else
        Result := true;
    finally
      Close;
      free;
    end;
  end;

end;

function TAppProfile.GetOverloadProperty(const APropertyName: String): String;
begin
  with TADQuery.Create(nil) do
  begin
    try
      Connection := FConnection;
      Open('Select OptionsValue from Overload_Options Where upper(`Login_ID`) = upper('+QuotedStr(FLogin_ID) + ')' +
           ' AND `TaxModule` = '+QuotedStr(FApp.AppID)+
           ' AND lower(`OptionsName`) = lower('+quotedStr(APropertyName)+')');
      if not isempty then
        Result := fieldByName('OptionsValue').asString
      else
        Result := '';
    finally
      Close;
      free;
    end;
  end;
end;

function TAppProfile.isOverload(const APropertyName: String): Boolean;
begin
  //20170131 Igor >>>
  if not (Self.App.LicenseLevel in anyMulti) then
    Exit(False);
  //20170131 Igor <<<

  with TADQuery.Create(nil) do
  begin
    try
      Connection := FConnection;
      Open('Select 1 from Overload_Options Where upper(`Login_ID`) = upper('+QuotedStr(FLogin_ID) + ')' +
           ' AND `TaxModule` = '+QuotedStr(FApp.AppID)+
           ' AND lower(`OptionsName`) = lower('+quotedStr(APropertyName)+')');
      Result := not isempty;
    finally
      Close;
      free;
    end;
  end;
end;

class procedure TAppProfile.SetOverloadProperty(AConnection: TADConnection;
  const  AUser, AApp, APropertyName, APropertyValue: String);
begin
  AConnection.ExecSQL('INSERT OR REPLACE INTO Overload_Options(LOGIN_ID, TaxModule, OptionsName, OptionsValue) '+
                 'Values ('+QuotedStr(AUser)+','+QuotedStr(AApp)+','+quotedStr(APropertyName)+','+quotedStr(APropertyValue)+'); ');
end;

procedure TAppProfile.SetOverloadProperty(const APropertyName,
  APropertyValue: String);
begin
  TAppProfile.SetOverloadProperty(FConnection, FLogin_ID, FApp.AppID, APropertyName, APropertyValue);
end;

{ TAppProfiles }

function TAppProfiles.AddApp(AApp: TApp): TAppProfile;
begin
  if AApp = nil then Exit(nil); //20170123 Igor
  Result := TAppProfile.Create(AApp, FConnection);
  Result.Login_ID := FLogin_ID;
  Self.Add(Result);
  TAppProfiles.AddApp(FConnection, FLogin_ID, AApp.AppId);
end;

class procedure TAppProfiles.AddApp(AConnection: TADConnection; const AUser,
  AApp: string);
begin
  AConnection.ExecSQL('INSERT OR REPLACE INTO User_TaxModule(LOGIN_ID, TaxModule) '+
                      'Values ('+QuotedStr(AUser)+','+QuotedStr(AApp)+')');
end;

procedure TAppProfiles.Clear;
begin
  while self.Count > 0 do
  begin
    Self.Items[0].Free;
    Self.Delete(0);
  end;
end;

class procedure TAppProfiles.CloneSettings(AConnection: TADConnection;
  const AFromUser, AToUser: String);
begin
  TAppProfiles.DeleteAllApp(AConnection, AToUser);
  AConnection.ExecSQL('INSERT INTO `User_TaxModule`(`LOGIN_ID`, `TaxModule`) '+
    'Select ' + QuotedStr(AToUser) + ', T.`TaxModule` from `User_TaxModule` AS T '+
    'Where upper(T.`LOGIN_ID`) = upper(' + QuotedStr(AFromUser) + ')');
  TAppProfile.CloneSettings(AConnection, AFromUser, AToUser);
end;

constructor TAppProfiles.Create(ALogin_ID: String; AConnection: TADConnection);
begin
  inherited Create(False);
  FLogin_ID := ALogin_ID;
  FConnection := AConnection;
end;

class procedure TAppProfiles.DeleteAllApp(AConnection: TADConnection;
  const AUser: string);
begin
  TAppProfile.DeleteAllOverloadProperty(AConnection, AUser);
  AConnection.ExecSQL('Delete from User_TaxModule Where upper(`Login_ID`) = upper('+QuotedStr(AUser) + ')');

end;

procedure TAppProfiles.DeleteApp(AApp: TApp);
var
  p: TAppProfile;
  I: Integer;
begin
  for I := 0 to Self.Count - 1 do
  begin
    p := Self.Items[I];
    if p.App = AApp then
    begin
      TAppProfiles.DeleteApp(FConnection, FLogin_ID, AApp.AppID);
      p.Free;
      Self.Delete(I);
      exit;
    end;
  end;
end;

class procedure TAppProfiles.DeleteApp(AConnection: TADConnection;
  const AUser, AApp: string);
begin
  TAppProfile.DeleteAllOverloadProperty(AConnection, AUser, AApp);
  AConnection.ExecSQL('Delete from User_TaxModule Where upper(`Login_ID`) = upper('+QuotedStr(AUser) + ')' +
                      ' AND `TaxModule` = '+QuotedStr(AApp));
end;

destructor TAppProfiles.Destroy;
begin
  Clear;
  inherited;
end;

function TAppProfiles.ProfileByApp(AApp: TApp): TAppProfile;
var
  p: TAppProfile;
begin
  for p in Self do
    if p.App = AApp then
      exit(p);
  Result := AddApp(AApp);    
end;

procedure TAppProfiles.SetLogin_ID(const ALogin_ID: String);
var
  p: TAppProfile;
begin
  FLogin_ID := ALogin_ID;
  for p in Self do
    p.Login_ID := ALogin_ID;
end;

{ TUserProfile }

constructor TUserProfile.Create;
begin
  inherited Create;
  FConnection := TADConnection.Create(nil);
  //20170927 Igor>>>
  SetConnection(FConnection, TPath.Combine(ExeDir, UserDBLite), UserTableLite);
  //20170927 Igor<<<
  FAppProfiles := TAppProfiles.Create(UserName, FConnection);
  initEmpty;
end;

destructor TUserProfile.Destroy;
begin
  FAppProfiles.Free;
  FConnection.Free;
  inherited;
end;

function TUserProfile.EqualOverloadProperty(const AApp: TApp;
  const APropertyName, ACompareValue: String;
  ACaseInsensitive: Boolean): Boolean;
begin
  Result := FAppProfiles.ProfileByApp(AApp).EqualOverloadProperty(APropertyName,
    ACompareValue, ACaseInsensitive);
end;

function TUserProfile.GetOverloadProperty(const AApp: TApp;
  const APropertyName: String): String;
begin
  Result := FAppProfiles.ProfileByApp(AApp).OverloadProperty[APropertyName];
end;

procedure TUserProfile.InitEmpty;
begin
  FUserName := '-'; //20190222 Igor
  FCode := '';
  FPassword := '';
  FAppProfiles.Clear;
end;

class function TUserProfile.InitStorage: Boolean;//20170927 Igor
var
  Conn: TADConnection;
  DB: string;
begin
  DB := TPath.Combine(ExeDir, UserDBLite);
  if TFile.Exists(DB) then
    Exit(True);
  Conn := TADConnection.Create(Nil);
  try
    Conn.LoginPrompt := False;
    Conn.DriverName := 'SQLite';
    Conn.Params.Values['Database'] := DB;
    Conn.Params.Values['Password'] := '';
    try
      Conn.Connected := True;
      Conn.ExecSQL('CREATE TABLE DataBaseVersion (VersionNo INT NOT NULL PRIMARY KEY, RestructureDate DATETIME NOT NULL)');
      Conn.ExecSQL('INSERT INTO DataBaseVersion(VersionNo, RestructureDate) Values (1, CURRENT_TIMESTAMP)');
      Conn.ExecSQL('CREATE TABLE User_TaxModule ('+
                      'LOGIN_ID VARCHAR(10) NOT NULL, '+
                      'TaxModule VARCHAR(10) NOT NULL, '+
                      'CONSTRAINT `PK_User_TaxModule` PRIMARY KEY (LOGIN_ID, TaxModule))');
      Conn.ExecSQL('CREATE TABLE Overload_Options ('+
                      'LOGIN_ID VARCHAR(10) NOT NULL, '+
                      'TaxModule VARCHAR(10) NOT NULL, '+
                      'OptionsName VARCHAR(50) NOT NULL, '+
                      'OptionsValue TEXT NULL, '+
                      'CONSTRAINT `PK_Overload_Options` PRIMARY KEY (LOGIN_ID, TaxModule, OptionsName))');
      Conn.ExecSQL('CREATE TABLE Users (' +
                      'LOGIN_ID VARCHAR(10) NOT NULL, ' +
                      'CODE VARCHAR(4) NOT NULL, ' +
                      'PSWD VARCHAR(10) NOT NULL, ' +
                      'PREP_NAME VARCHAR (20) NULL, ' +
                      'PREP_INTLS VARCHAR (2) NULL, ' +
                      'M_OFFICE VARCHAR(4) NULL, ' +
                      'BRANCH VARCHAR(2) NULL, ' +
                      'AUTH_LEVEL VARCHAR(2) NULL,'+
                      'INV_NO REAL NULL,'+
                      'CONSTRAINT `PK_USERS` PRIMARY KEY (LOGIN_ID))');
      Conn.ExecSQL('INSERT INTO Users(LOGIN_ID,CODE,PSWD,PREP_NAME,PREP_INTLS,M_OFFICE,BRANCH,AUTH_LEVEL,INV_NO) '+
                   'VALUES (''ADMIN'', ''0001'', ''ADMIN'', ''DEMO Preparer'', NULL, NULL, NULL, NULL, 0)');
      Conn.ExecSQL('CREATE INDEX NAME ON Users (LOGIN_ID);');
      Result := True;
    except ON E: Exception DO
      begin
        Result := False;
        Errors.Log(E.Message);
      end;
    end;
  finally
    Conn.Free;
  end;
  if not Result AND FileExists(DB) then
    try
      TFile.Delete(DB);
    except
    end;
end;

function TUserProfile.LoadUserProfile(const AUserName: string;
 AHaveMultiOffice: Boolean): boolean; //20170115 Igor
var
  I: Integer;
begin
  //20170212 Igor >>>
  if AHaveMultiOffice then
  Begin
  with TADQuery.Create(nil) do
  begin
    try
      connection := FConnection;
      SQL.Text := 'SELECT * FROM `Users` Where upper(`LOGIN_ID`) = upper(' + QuotedStr(AUserName)+')';
      Open;
      //20170212 Igor>>>
      ////20170115 Igor >>>
      //if AHaveMultiOffice AND not isEmpty then //20170131 Igor
      //Begin
      //20170212 Igor <<<
        if isEmpty then
          Exit(false);
        UserName := FieldByName('LOGIN_ID').AsString;
        Code := FieldByName('CODE').AsString;
        Password := FieldByName('PSWD').AsString;
        Prep_Name := FieldByName('Prep_Name').AsString;
        PREP_INTLS := FieldByName('PREP_INTLS').AsString;
        M_OFFICE := FieldByName('M_OFFICE').AsString;
        BRANCH := FieldByName('BRANCH').AsString;
        AUTH_LEVEL := FieldByName('AUTH_LEVEL').AsString;
        INV_NO := FieldByName('INV_NO').AsInteger;

        Close;
        SQL.Text := 'SELECT * FROM `User_TaxModule` WHERE upper(`LOGIN_ID`) = upper(' + QuotedStr(UserName) + ')';
        Open;
        while Not eof do
        begin
          FAppProfiles.AddApp(AppList.AppFromID(FieldByName('TaxModule').AsString));
          next;
        end;
        for I := 0 to AppList.Count - 1 do
          AppList.GetApp(I).GetOverloadedProperty;
        Result := True;
   //20170212 Igor >>>     
      finally
        free;
      end;
    end;
    //20170212 Igor <<<
      End
      else
      begin
        UserName := AUserName;
        Code := '0001';
        Password := '';
        Prep_Name := '';
        PREP_INTLS := '';
        M_OFFICE := 'MAIN';
        BRANCH := '';
        AUTH_LEVEL := '';
        INV_NO := 0;
        Result := True;
      end;
      //20170115 Igor <<<
 //20170212 Igor >>>     
    //finally
    //  free;
    //end;
  //end;
  //20170212 Igor <<<
end;

function TUserProfile.OverloadedProperty(const AApp: TApp;
  const APropertyName: String; var APropertyValue: TValue): Boolean;
var
  tmp: String;
  I: Integer;
  I64: Int64;
  S:String;
  B: Boolean;
  C: Currency;
  Ch: Char;
begin
  if not FAppProfiles.ProfileByApp(AApp).isOverload(APropertyName) then
    exit(false);
  case APropertyValue.TypeInfo.Kind of
    tkInteger:
      begin
        Tmp := FAppProfiles.ProfileByApp(AApp).OverloadProperty[APropertyName];
        if not tryStrToInt(Tmp, I) then
          I := 0;
        APropertyValue := TValue.From(I);
      end;
    tkChar:
      begin
        Tmp := FAppProfiles.ProfileByApp(AApp).OverloadProperty[APropertyName];
        APropertyValue := TValue.From(Tmp);
      end;
    tkEnumeration:
      begin
        Tmp := FAppProfiles.ProfileByApp(AApp).OverloadProperty[APropertyName];
        if not TryStrToBool(Tmp, B) then
          B := False;
        APropertyValue := TValue.From(B);
      end;
    tkFloat:
      begin
        Tmp := FAppProfiles.ProfileByApp(AApp).OverloadProperty[APropertyName];
        if not TryStrToCurr(Tmp, C) then
          I := 0;
        APropertyValue := TValue.From(C);
      end;
    tkString, tkUString:
      begin
        Tmp := FAppProfiles.ProfileByApp(AApp).OverloadProperty[APropertyName];
        APropertyValue := TValue.From(Tmp);
      end;
  else
    exit(false);
  end;
  Result := True;
end;

procedure TUserProfile.RealProperty(const AApp: TApp;
  const APropertyName: String; var APropertyValue: Integer);
var
  S: String;
begin
  if not FAppProfiles.ProfileByApp(AApp).isOverload(APropertyName) then
    exit;
  S := FAppProfiles.ProfileByApp(AApp).OverloadProperty[APropertyName];
  if not tryStrToInt(S, APropertyValue) then
    APropertyValue := 0;
end;

procedure TUserProfile.RealProperty(const AApp: TApp;
  const APropertyName: String; var APropertyValue: String);
begin
  if not FAppProfiles.ProfileByApp(AApp).isOverload(APropertyName) then
    exit;
  APropertyValue := FAppProfiles.ProfileByApp(AApp).OverloadProperty[APropertyName];
end;

procedure TUserProfile.RealProperty(const AApp: TApp;
  const APropertyName: String; var APropertyValue: Currency);
var
  S: String;
begin
  if not FAppProfiles.ProfileByApp(AApp).isOverload(APropertyName) then
    exit;
  S := FAppProfiles.ProfileByApp(AApp).OverloadProperty[APropertyName];
  if not TryStrToCurr(S, APropertyValue) then
    APropertyValue := 0;
end;

procedure TUserProfile.RealProperty(const AApp: TApp;
  const APropertyName: String; var APropertyValue: TDateTime);
var
  S: String;
begin
  if not FAppProfiles.ProfileByApp(AApp).isOverload(APropertyName) then
    exit;
  S := FAppProfiles.ProfileByApp(AApp).OverloadProperty[APropertyName];
  if not TryStrToDateTime(S, APropertyValue) then
    APropertyValue := 0;
end;

procedure TUserProfile.RealProperty(const AApp: TApp;
  const APropertyName: String; var APropertyValue: Boolean);
var
  S: String;
begin
  if not FAppProfiles.ProfileByApp(AApp).isOverload(APropertyName) then
    exit;
  S := FAppProfiles.ProfileByApp(AApp).OverloadProperty[APropertyName];
  if not TryStrToBool(S, APropertyValue) then
    APropertyValue := false;
end;

procedure TUserProfile.SaveUserProfile;
begin
  with TADQuery.Create(nil) do
  begin
    try
      connection := FConnection;
      SQL.Text := 'INSERT OR REPLACE into `Users` (`LOGIN_ID`, `CODE`, `PSWD`, '+
                    '`PREP_NAME`, `PREP_INTLS`, `M_OFFICE`, `BRANCH`, `AUTH_LEVEL`, `INV_NO`) '+
                  ' Values('+QuotedStr(UserName)+', '+QuotedStr(Code) + ', ' + QuotedStr(Password) + ', '+
                             QuotedStr(PREP_NAME)+', '+QuotedStr(PREP_INTLS) + ', ' + QuotedStr(M_OFFICE) + ', '+
                             QuotedStr(BRANCH)+', '+QuotedStr(AUTH_LEVEL) + ', ' + IntToStr(INV_NO)+')';
      ExecSQL;
    finally
      free;
    end;
  end;
end;

procedure TUserProfile.SetAUTH_LEVEL(const Value: String);
begin
  FAUTH_LEVEL := Value;
end;

procedure TUserProfile.SetBRANCH(const Value: String);
begin
  FBRANCH := Value;
end;

procedure TUserProfile.SetINV_NO(const Value: Integer);
begin
  FINV_NO := Value;
end;

procedure TUserProfile.SetM_OFFICE(const Value: String);
begin
  FM_OFFICE := Value;
end;

procedure TUserProfile.SetOverloadProperty(const AApp: TApp;
  const APropertyName, APropertyValue: String);
begin
  FAppProfiles.ProfileByApp(AApp).OverloadProperty[APropertyName] := APropertyValue;
end;

procedure TUserProfile.SetPREP_INTLS(const Value: String);
begin
  FPREP_INTLS := Value;
end;

procedure TUserProfile.SetPrep_Name(const Value: String);
begin
  FPrep_Name := Value;
end;

procedure TUserProfile.SetCode(const Value: String);
begin
  FCode := Value;
end;

procedure TUserProfile.SetUserName(const Value: String);
begin
  FUserName := Value;
  FAppProfiles.Login_ID := FUserName;
end;

function TUserProfile.Tax_Dir: string;
begin
  Result := Self.OverloadProperty[CurrentApp, 'Dir_Cur'];
end;

function TUserProfile.DBFData_Dir: string;
begin
  Result := Self.OverloadProperty[CurrentApp, 'Dir_DBFData'];
end;

function TUserProfile.EFile_Dir: string;
begin
  Result := Self.OverloadProperty[CurrentApp, 'Ef_DataDir'];
end;

function TUserProfile.Br_Dir: string;
begin
  Result := Self.OverloadProperty[CurrentApp, 'BR_DIR'];
end;

procedure TUserProfile.SetPassword(const Value: String);
begin
  FPassword := Value;
end;

//20170112 Igor <<<

{ RPgmLicenseData }

function RPgmLicenseData.GetLimitReturns: Integer; //20170502 igor
begin
  case Level of
//20170901 Igor>>>
    llLimited1Returns: Result := 1;
    llLimited2Returns: Result := 2;
    llLimited3Returns: Result := 3;
    llLimited4Returns: Result := 4;
    llLimited5Returns: Result := 5;
    llLimited6Returns: Result := 6; // 20180830 Igor
//20170901 Igor<<<
  else
    Result := MaxInt;
  end;
end;


//20170726 Igor>>>
{ TVTMapElement }

constructor TVTElement.Create(const AFormName, ABoxNo: String;
  const AElementNo: Integer; const ARowStep: Integer = 1;
  const AHardValue: String = '');//20170729 Igor
begin
  FormName := AFormName;
  BoxNo := ABoxNo;//20170729 Igor
  ElementNo := AElementNo;
  RowStep := ARowStep;
  HardValue := AHardValue;
end;

procedure TVTElement.GetRealTarget(const AInstanse, ARowNo: Integer;
  out AFormName: String; out AElementNo: Integer; var AValue: String);//20170726 Igor
begin
  AFormName := Self.FormName;
  if AInstanse > 0 then
    AFormName := AFormName + '#' + AInstanse.ToString;
  AElementNo := Self.ElementNo + ARowNo * Self.RowStep;
  if HardValue <> '' then
    AValue := HardValue;
end;
//20170726 Igor<<<

//20170811 Igor>>>
{ TApp2017 }

constructor TApp2017.Create(AAppList: TAppList);
begin
  inherited;
  FCoreVersion := '2017.01';
end;
//20170811 Igor<<<

//20170927 Igor>>>
{ TStartParams }
constructor TStartParams.Create(AStartKey: String);
begin
  FisCloud := FindCmdLineSwitch('isCloud');
  FisDemo := FindCmdLineSwitch('isDemo');
  FIsAdmin := false; //20190501 Igor
  StartKeys := TDictionary<String, String>.Create; // 20180917 Igor
end;

destructor TStartParams.Destroy; // 20180917 Igor
begin
  StartKeys.Free;
end;

{ TApp2018 }

constructor TApp2018.Create(AAppList: TAppList); // 20180830 Igor
begin
  inherited;
  FCoreVersion := '2017.01';
end;

{ TUnFreezeThread }

procedure TUnFreezeThread.Execute; //20200312 Igor
var I: integer;
begin
  inherited;
  while not Terminated do
  begin
    Synchronize(ModalFormOnTop);
    Sleep(5000);
  end;
end;

procedure TUnFreezeThread.ModalFormOnTop; //20200312 Igor
var I: integer;
begin
  for I := Screen.FormCount - 1 downto 0 do
    if fsModal in Screen.Forms[I].FormState then
      SetWindowPos(Screen.Forms[I].Handle, HWND_TOPMOST,0,0,0,0, SWP_NOMOVE or SWP_NOSIZE);
end;

initialization
//  InitMulti;//20170916 Igor
  //CloudMessageId := RegisterWindowMessage(PChar('CloudMessage_'+ Application.ExeName));

  FUnFreezeThread := TUnFreezeThread.Create(true); //20200312 Igor

finalization
//  DoneMulti;
//20170927 Igor<<<
  //20200312 Igor  >>>
  FUnFreezeThread.Terminate;
  FUnFreezeThread.Free;
  //20200312 Igor  <<<

end.


