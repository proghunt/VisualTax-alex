unit vtShared;
(* This unit contains all global variables, shared by all AppIds.

  Add as very last unit to the implementation uses lists, so that
  all possibly existing app-specific variables are redefined.
  Such relicts should be removed anyhow.

  Also add variables of bad type, which should not be used any more
  or which have been renamed and changed in type.
*)

interface

uses
  Windows, Messages, Graphics, ExtCtrls, Controls, Contnrs, Classes, StdCtrls,
  vtMulti, //type declarations
  Vcl.Dialogs, VirtualUI_Mediator, System.IOUtils, TlHelp32, VirtualUI_SDK, //20190205 Igor
 RxRichEd; //20160819 Igor (It must be the last)

type
  TOverRec = class //Record
  public
    RetNo: Word;
    FormNo: Word;
    FieldId: Word;
    Value: string;
    constructor Create(RNo, FNo, FId: integer);
    destructor Destroy; override;
  end;
  TOverList = class(TObjectList)
  protected
    function RemoveOverride(r: TOverRec): boolean;
  public
    destructor Destroy; override; //debug only
    procedure EnumRecs(AppId: TApp; Lst: TStrings);
    function OvrOn(RetNo, FormNo, FieldId: integer): TOverRec;
    function RetOn(RetNo: integer): boolean;
    function SetFieldOverride(RetNo, FormNo, FieldId: integer): TOverRec;
    function GetFieldOverride(Index: integer): TOverRec;
  end;
var
  OverList: TOverList;
  OverRec: TOverRec;
  //Procedure RenameUnitsInMultiApp;
function GetOvrValue(RetNo, FormNo, FieldId: integer): string;
procedure RemoveFieldOverride(RetNo, FormNo, FieldId: integer);
procedure RemoveFormOverrides(const RetNo, FNo: integer);
procedure RemoveReturnOverrides(RetNo: integer);
procedure SaveFieldOverride(RetNo, FormNo, FieldId: integer; Value: string);
function SetFieldOverride(RetNo, FormNo, FieldId: integer): TOverRec;
function OvrOn(RetNo, FormNo, FieldId: integer): boolean;
//Function  GetFormOvrSw(RetNo:integer;FormNo:Integer):boolean;

type
  TReviewRec = class // Record
  public
    RetNo: Word; {Integer;}
    FormNo: Word; {Integer;}
    FieldId: Word; {Integer;}
    ReviewSw: Boolean;
    Symbol: Word; {integer;}
    constructor Create(RNo, FNo, FId: integer);
  end;

  TReviewList = class(TObjectList)
  private
    function GetRec(index: integer): TReviewRec;
  public
    destructor Destroy; override; //debug only
    procedure EnumRecs(AppId: TApp; Lst: TStrings);
    property Items[index: integer]: TReviewRec read GetRec;
  end;
var
  ReviewList: TReviewList;
  ReviewRec: TReviewRec;
function FormHasReviewMarks(RetNo, FNo: Integer): Boolean;
procedure RemoveReviewMark(RetNo: Integer; FormNo: integer; FieldId: integer);
procedure RemoveRetReviewMarks(RetNo: Integer);
procedure SetReviewMark(RetNo: Integer; FormNo: integer; FieldId: integer);
function ReviewOn(RetNo, FormNo, FieldId: integer): boolean;

procedure SignOffAWarning(RetNo: Integer; r: TAuditRec = nil);

type
  TExtractedAutoRec = class
    StatementId, //      : String[12];
    ClassId, //          : String[4];
    Description: string; //[40];
    KmDrove: Integer;
    KmTotal: Integer;
    DateAcquired: string; //[10];
    Cost: Real;
    KmPercent: Real;
    StatementPercent: Real;
    ExpensesClaimed: Real;
    CCAForTheYear: Real;
    UccStart: Real;
    Additions: Real;
    AdditionsPersonal: Real;
    Proceeds: Real;
    ProceedsPersonal: Real;
    UccAfter: Real; //20190217CON
    Adjustments: Real;
    BaseAmount: Real;
    Rate: Real;
    CCAClaimed: Real;
    CCA: Real;
    UCCEnd: Real;
    TerminalLossAmount: Real;
    RecaptureAmount: Real;
    AutoCCAForStatement: Real;
    PartnerFlag: string; //[1]; //boolean? //20170619 Igor
    AiiPAdditions    : Real;  //?? Why these?    than is why they here
    AiiPProceeds     : Real;
    AiiPUccAdj       : Real;
    //new field //20230424
     Col1Val:String[4];
     Col2Val,Col3Val,col4Val,col5Val,col6Val,col7Val,col8Val,col9Val,col10Val,col11Val,col12Val,
     col13Val,col14Val,col15Val,col16Val,col17Val,col18Val,col19Val,col20Val,col21Val,col22Val:Real; //jz//20260404 - add col vars:Real;
     col21T776val,col22T776val,col23T776val,col24T776val:Real;
     T776ChartBc1val,T776ChartBc2val,T776ChartBc3val,T776ChartBc5val,T776ChartBc6val:string;
     T776ChartBc4val,T776ChartBc7val :Real;                                                   //jz//20260409//CCAv3 - added col vars for T776 chartb
  end;

  TExtractedAutoList = class(TObjectList)
  private
    function GetItems(index: integer): TExtractedAutoRec;
  public
    property Items[index: integer]: TExtractedAutoRec read GetItems; default;
  end;

type
  TExtractedCCARec = class
    StatementId, //      : String[12];
    ClassId, //          : String[4];
    Description, //      :String;  //[40];
    DateAcquired: string; //[10];
    PersonalPercent: Real;
    Cost: Real;
    StatementPercent: Real;
    CCAForTheYear: Real;
    UccStart: Real;
    Additions: Real;
    AdditionsPersonal: Real;
    Proceeds: Real;
    ProceedsPersonal: Real;
    Adjustments: Real;
    AdjUCC: Real;
    BaseAmount: Real;
    Rate: Real;
    CCAClaimed: Real;
    CCA: Real;
    UCCEnd: Real;
    RecordKeeping: string; //[1]; //20170619 Igor
    TermLossFlag: string; //[1];  //20170619 Igor
    TerminalLossAmount: Real;
    RecaptureAmount: Real;
    CCAForStatement: Real;
    //20190204 Igor >>>
    AiiPAdditions   : Real;
    AiiPProceeds    : Real;
    AiiPUccAdj      : Real;
    //con
   // AiiAdditions    : Real;
   // AiiProceeds     : Real;
   // AiiUccAdj       : Real;
    //20190204 Igor <<<
    //new field //20230424
     Col1Val:String[4];
     Col2Val, Col3Val, col4Val, col5Val, col6Val, col7Val, col8Val, col9Val, col10Val,col11Val, col12Val,
     col13Val,col14Val,col15Val,col16Val,col17Val,col18Val,col19Val,col20Val,col21Val,col22Val:Real; //jz//20260404 - add col vars:Real;

     col21T776val,col22T776val,col23T776val,col24T776val:Real;
     T776ChartBc1val,T776ChartBc2val,T776ChartBc3val,T776ChartBc5val,T776ChartBc6val:string;
     T776ChartBc4val,T776ChartBc7val :Real;                                                   //jz//20260409//CCAv3 - added col vars for T776 chartb
  end;
  TExtractedCCAList = class(TObjectList)
  private
    function GetItems(index: integer): TExtractedCCARec;
  public
    property Items[index: integer]: TExtractedCCARec read GetItems; default;
  end;

type
  TLabelSectList = class(TStringList)
  private
    MyApp: TApp;
    procedure ExtractSectionLabels(FName, OriginalInst: string; SomeList: TStringList);
  public
    constructor Create(App: TApp);
    procedure AddLabel(ALabel: TLabel; FName: string);
    procedure GetFormSections(FName: string; SomeList: TstringList);
  end;

  (* combine Template form names and copies: <form>=<copies>
  *)
type
  TTemplCopies = class(TStringList)
  private
    AppDir: string;
    //TemplList: TStringList;
    FList: TFList;
  public
    constructor Create(RetNo: integer; Dir, TemplName: string);
    //procedure AddCopies(FName, Copies: string);
    procedure FinishPrintList(FormsToPrint: TStrings);
    function IsExactlyInList(FName: string): integer;
  end;

type
  TApplicationState = (asNone, asLoadReturn, asOpenForm, asChangeZoom, asFamilyOpen, asDummyFormShow,
    asConvertFromLastYear, asSilentSave); //20170412 Igor //20170703 Igor
  TApplicationStateSet = Set of TApplicationState; //20160615
  //RetInMem covering all returns from all AppIds
function RetInMem: Integer; overload;
function DrawingRetInMem: Integer; //20161028 Igor
function RetInMem(AApp: TApp; AWithOutAppendix: Boolean = False): Integer; overload; //20170307 Igor

function GetFieldColorFromHint(AuditRec: TAuditRec): TColor;

function ReadComponentResFile(const DfmFileName: string; AForm: TComponent; AShowError: boolean = false): TComponent; //20220127 Igor

const //Init/Open/ReadReturn error codes for ShowOpenReturnFailure
  iorReported = 0; //message already shown
  iorFileName = -1; //invalid filename
  iorFileType = -2; //not a valid return file
  iorCountExceeded = -3; //some limit exceeded
  iorPassword = -4; //invalid password
  iorFileRead = -5; //error reading file
  //iorNone     = -88; //no errors, no RetNo
  iorUnknown = -99; //unknown reason (exception...)
  //value > 0 is valid RetNo

  //Function  GetFilePsw(Datadir:string;FlName:string; Elm: integer):String;
function GetFilePsw(Datadir, FlName: string; Elm: integer; var pwd: string; APwdArr: Variant): integer; //20160415 Igor
function CheckFilePsw(Datadir, FlName: string; Elm: integer; APwdArr: Variant): integer; //20160415 Igor
function CheckFileAndPsw(Datadir, FlName: string; Elm: integer; APwdArr: Variant): boolean; //20160415 Igor
procedure ShowOpenReturnFailure(var FailCode: integer; DataDir: string; FlName: string);

function GetOptionValue(FieldNm: string; TempList: TStringList): string;
procedure SaveOptionValue(FieldNm: string; Value: string; TempList: TStringList);

procedure Checkupdates(WindowHandle: HWND; AppTitle: string);
function GetUpdateFrequency: Integer;
//function TimeToCheckUpdates: Boolean; //20160717 Igor

//try resolve references to the current(?) form
{$IFDEF globalForm}
function FormName: string;
function FormNo: integer;
function NoFormInfo(ACtrl: TControl): boolean; //form info for control in a tax form
{$ELSE}
{$ENDIF}

//update RetNo, FormName, FormNo
procedure FormNameNo(RNo: integer; FName: string);
procedure GetFormNameNo(var RNo, FNo: integer; var FName: string);
function NoActiveForm: boolean; //get currently active ChildWin page

function FormHasInstanceIndicator(RetNo: integer; FName: string): Boolean;
function GetFNoOfFirstInstance(RetNo: integer; FName: string; FNo: Integer): Integer;
//Function GetFNoOfFirstInstance(RetNo: integer; FNo:Integer):Integer; <--- FName unused!
//Function GetPrintSequence(RetNo: integer; FName:string):String;
function IsDevelopmentMode: Boolean;

procedure InitFormData(RetNo, FNo: integer);
procedure ClearElms(RetNo, FNo, FromElm, ToElm: integer);
//Procedure ClearForm(RetNo:integer;FName:string);
function ClearForm(RetNo: integer; FName: string): boolean;
procedure CloneForm(FromRetNo: integer; FromFormName: string; ToRetNo: integer;
  ToFormName: string = ''; AAll: Boolean = False); //20160722 Igor
procedure CloneReturn(FromRetNo: integer; ToRetNo: integer);
procedure UpdateFormDataIndicator(RetNo: Integer; Frec: TFRec);
//Procedure UpdateFormDataIndicator(RetNo:Integer;FNo:Integer;S:String);
procedure UpdateChildWin(RetNo: integer);
procedure UpdateChildTaxPanelOnly(RetNo: integer);
//procedure UpdateChildTaxPanel(RetNo: integer);
procedure UpdateAllVisibleForms;

//Calcs, Diagnostics...
procedure LoadTV(RetNo: integer; FName: string; FNo: integer);
procedure SaveTV(RetNo: integer; FName: string; FNo: integer);
procedure ClearDiagnostics(RetNo: integer);
procedure SaveDiagnostic(RetNo: Integer; FrmNm: string; ElmNo: integer; ErrMsg: string); overload;
procedure SaveDiagnostic(RetNo: Integer; FrmNm: string; ElmNo: integer; Category: char; ErrMsg: string); overload;
//function UploadToDropBox(WindowHandle: HWND; ADir_ClientDocs: String = ''): Boolean;//20170811 Igor
function UrlVersionFile: String; //20161116 Igor

const
  //FieldsLimit = 999; //max. field no
  FieldsLimit = 1500; //T2! //20120919 //1000;//600; //430; //300; //20110128
  //UrlVersionFile = 'http://www.visualtax.com/downloads/vtUpdate/vt2015Versions.xml'; //20160425 Igor //20161116 Igor
//  URLVerionFile = 'http://localhost/vt2015Versions.xml'; //20160425 Igor

(* //20230815 Igor
var
  TV: array[0..FieldsLimit] of real; {temp variable for numeric form fields}
*)

var
  WindowLocks: integer;
  ApplicationState: TApplicationStateSet; //20160615 Igor

procedure LockWindowUpdate(hwnd: HWND);

function MyCopyFile(const SourceFile, DestinationFile: string): boolean;
function MyMoveFile(const SourceFile, DestinationFile: string): boolean;
function BackUpData(const ASrcDir, ADstDir: String; out AErr: String): Boolean; //20160502 Igor //20160615 Igor

function ClientsDBLite(const AAppName: String = '') :String; //20151018 Igor //20160314 Igor

function Reverse(S: String): String;
Function GetReturnAppAndYear(ADataDir,AFlName: string; out AApp: String;
  out AYear: integer; APwdArr: Variant):Boolean; //20160311 Igor //20160703 Igor
function RecentRFlName: string; //20170112 Igor
function RecentFlName: string;  //20170112 Igor
procedure ClearExplorerData; //20190222 Igor

const
  //fixed files

//  //T1SQLLitePassword = 'Ke1' + 'Key2'; // 20150903 - Encrypt
//  T1SQLLitePassword = '';               // 20150907 - not Encrypt
//
//  //T2SQLLitePassword = 'Ke1' + 'Key2'; // 20150924- Encrypt
//  T2SQLLitePassword = '';               // 20150924 - not Encrypt
//
//  //TFSQLLitePassword = 'Ke1' + 'Key2'; // 20150924 - Encrypt
//  TFSQLLitePassword = '';               // 20150924 - not Encrypt
//
//  //FPSQLLitePassword = 'Ke1' + 'Key2'; // 20150924 - Encrypt
//  FPSQLLitePassword = '';               // 20150924 - not Encrypt
  Contributor1='IGOR'; //20160226 Igor
  Contributor2='DODI'; //20160226 Igor
  Contributor3='Con';  //20160226 Igor
  Contributor3ver2 = 'CON'; //20160303 Igor

  //AssistDB      = 'FP_ASSIST.DBF'; //20150918 Igor
  AssistDBLite    = 'FP_ASSIST.DB';  //20150916 Igor
  AssistTableLite = 'FP_ASSIST';     //20150916 Igor

  ClientsTable_dbf   = 'CLIENTS.DBF'; //20150922 Igor
  lClientsDBLite     = 'CLIENTS';     //20151018 Igor
  //ClientsDBLite      = 'CLIENTS.DB';//move to CurrentApp.ClientsDBLite 20151018 Igor
  ClientsTableLite   = 'CLIENTS';     //20150820 Igor
  ClientsBkDBLite    = 'ClientBk.DB'; //20150916 Igor
  ClientsBkTableLite = 'ClientBk';    //20150916 Igor

  ClientPortfoliosDBLite    = 'ClientPortfolios.db'; //20150916 Igor: FP_2015
  ClientPortfoliosTableLite = 'ClientPortfolios';    //20150916 Igor: FP_2015
  AssetsDBLite              = 'Assets.db';           //20150923 Igor: FP_2015
  AssetsTableLite           = 'Assets';              //20150923 Igor: FP_2015
  LiabilitiesDBLite         = 'Liabilities.db';      //20150923 Igor: FP_2015
  LiabilitiesTableLite      = 'Liabilities';         //20150923 Igor: FP_2015

  GiFibsDBLite    = 'GiFibs.db'; //20150922 Igor: T2_2015
  GiFibsTableLite = 'GiFibs';    //20150922 Igor: T2_2015
  GiFiisDBLite    = 'GiFiis.db'; //20150922 Igor: T2_2015
  GiFiisTableLite = 'GiFiis';    //20150922 Igor: T2_2015


  //DictTable   = 'DATADICT.DBF'; //***20150918 Igor
  DictDBLite    = 'DATADICT.DB';  //20150915 Igor
  DictTableLite = 'DATADICT';     //20150915 Igor

  //UserDB      = 'USERS.DBF';   //***20150918 Igor
  UserDBLite    = 'USERS.DB';    //20150915 Igor
  UserTableLite = 'USERS';       //20150915 Igor

  EfErrorsDBLite    = 'EFERRORS.DB'; //20150916 Igor
  EfErrorsTableLite = 'EFERRORS';    //20150916 Igor
  SendErrDBLite     = 'SENDErr.DB';  //20150916 Igor
  SendErrTableLite  = 'SENDErr';     //20150916 Igor
  T1135ErrorsDBLite    = 'T1135Errors.DB'; //20150916 Igor
  T1135ErrorsTableLite = 'T1135Errors';    //20150916 Igor
  WSErrorsDBLite    = 'WebServiceErrors.DB'; //20150916 Igor
  WSErrorsTableLite = 'WebServiceErrors';    //20150916 Igor

  TipsDBLite        = 'Tips.DB';  //20150916 Igor
  TipsTableLite     = 'Tips';     //20150916 Igor


  OptionsFlName = 'Options.txt';
  //RecentRFlName = 'Recent.txt'; //20170112 Igor
  //RecentFlName = RecentRFlName; //20170112 Igor

const //misc
  //Delimiter: string[1] = Chr(127); {in file i/o between variables}
  Delimiter: char = chr(127); //20150702
  //--------------- colors -----------------
{$IFDEF old}
const
  //box background color
  DarkShade = $00B4B4B4; //rgb(180,180,180);
  brightGreen = $0097FF97; //rgb(151,255,151
  LightGreen = $00D2FFFF; //$00A7FCE2; //$00C0FEEF; //$00DFFFBF;
  PinkishColor = $00AEAEFF; //$008080FF; //255,174,174 //rgb(255,128,128)
  BluishColor = $00FADDA0; //rgb (160,221,250)
  FirstRetColor = $00FFFFC3; //Rgb(195,255,255)
  //----
  MyBlue = $00AC7400;
  MyBlueGrey = $00E3DCCC;
  MyLightBlue = $00FFFFCA; //T2:$00FFFFE1; //$00FFFF80; //$00FFFFE1;
  MyBeige = $00C8D0D8;
  MyBronze = $A6CAF0;
  MyYellow = $00C5EEFE;
  MyLightYellow = $00DBFFFF;
  NoteColor = $00E7CFCF; //light haki
  TapeColor = MyBronze; //$009098A8; //light brown
{$ELSE}
  //in vtCommon, allow to override
{$ENDIF}
var
  //PrintShade: TColor;  // = RGB(236,236,236);//RGB(230,230,230);  //20110119
  ReviewMarkColor: TColor = clRed; //RGB(255,0,128);

type {1=line,2=rectangle, etc}
  TDrawingTool = (dtLine, dtRectangle, dtEllipse, dtRoundRect);
var
  DrawingTool: TDrawingTool;

var //Fees
  FeesRec: PFeesList; //rarely used

  //switch forms
  PrevRetNo: Integer;
//  PrevFormName: string; //20170215 Igor
  //PrevFormNo   : Integer; //app specific! remove?

//User
//User : AUserProfile; - app specific!
  Licensee: string;
//20170112 Igor >>>
//  LoginName:String;   //20160216 Igor
//  UserName, LoginPwd: string; //set in fLogon
//  UserId: string; //???
  IsDeveloperLogin: boolean;
  IsAdminPasswordEntered: Boolean; //20170112 Igor

//For compatibility with VT-2015
  function UserName: string; deprecated 'Only for compatibility with VT-2015. Use User.UserName';
  function LoginName: string; deprecated 'Only for compatibility with VT-2015. Use User.UserName';
  function UserId: string; deprecated 'Only for compatibility with VT-2015. Use User.UserName';
//20170112 Igor <<<
//20170609 Igor >>>
Type
  TIntArr = TArray<Integer>;
  TIntArrOfIntArr = TArray<TIntArr>;
  procedure CheckTableFieldsNotNull(ARetNo: Integer; AFormName, ATableName: String;
    ATableNo: Integer; ANotNullFields: TIntArr);
  procedure CheckTableFieldsUnique(ARetNo: Integer;  AFormName, ATableName: String;
    ATableNo: Integer; AUniqueFields: TIntArrOfIntArr);
  procedure CheckFormTable(ARetNo: Integer;  AFormName, ATableName: String;
    ATableNo: Integer; ANotNullFields: TIntArr;
    AUniqueFields: TIntArrOfIntArr);
//20170609 Igor <<<


var //shared by all AppIds (check!)
  AbortSw: Boolean; {progress on printing etc}
  ShowFieldIdSw, //-> vtEditBox? also Memo!
  PauseSw: Boolean; {pause printing printing etc}
  //ToolBarSw: boolean; //per AppId?!
  CalcAlways: boolean = False; //omit excessive recalculations?
//20170927 Igor>>>
//  BorderShape: TShape;
//  ReviewShape: TShape;
//20170927 Igor<<<

  SomeLetterName: string;
  SomeList: TStringList; //TSingleStringList; //owned by vtMulti  //20151008
  SomeString, SomeCaption: string;
  SomeResult: Boolean;
  SomeFile: String; //20160907 Igor
  SomeLabel: String; //20160907 igor
  SomeFilter: String; //20160907 igor
  SomeFileMask: String; //20160907 igor
  SomeDir: String; //20160907 Igor
  SelectedString: String; //20160907 Igor

//  ScaleType: string;//20170927 Igor
  PdfPrint: Boolean;
  TrFolder: string; //see vtTaxResearch
  FastPrint: boolean;
  ServerMode: Boolean;
  ScrollSender : HWND; //20160312 Igor
{$IFDEF removed}
  //list some removed (no more used) identifiers
  ShowTreeView: Boolean;
{$ELSE}
{$ENDIF}

//20170703 Igor >>>
CONST
  UM_EXECUTEFORM = WM_USER + $0100;

  EF_OPTIONS = $0001; //TOptionsFrm
//20170703 Igor <<<

//20171221 Igor>>>
const
  c_FormInfoKind_Count = 'COUNT';
  c_FormInfoKind_Status = 'STATUS';
//20171221 Igor<<<
implementation

uses
  //for FormName...
  SysUtils, ShellApi, {ComCtrls,} Forms, vtDialogs,
  vtChild, vtForm, vtCommon, vtFileStorage,
  fCaseDo, //20190205 Igor
  vtTrimStr, Variants; //20160415 Igor

procedure ClearExplorerData; //20190222 Igor
const FileName = 'ClearInternetCookies.cmd';
var L: TStringList;
    cFile: string;
begin
  cFile := TPath.Combine(TPath.GetTempPath, 'ClearInternetCookies.cmd');
  if FileExists(cFile) then
    DeleteFile(cFile);

  L := TStringList.Create;
  try
    L.Add('RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 2'); // Cookies
    L.Add('RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 16'); // Form Data
    L.Add('RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 32'); // Passwords
    //L.Add('RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 255'); // All
    L.Add('');
    L.SaveToFile(cFile);
  finally
    L.Free;
  end;

  VirtualUI.AllowExecute(ExtractFileName(cFile));
  ShellExecute(0, 'runas', Pchar(cFile), nil, nil, SW_HIDE);
  Sleep(1000);
end;

//20151018 Igor
function ClientsDBLite(const AAppName: String = '') :String;
//20170722 Igor >>>
var
  I: Integer;
  App: TApp;
begin
  if AAppName = '' then
    Result:=CurrentApp.ClientsDBLite
  else
  Begin
    App := AppList.AppFromName(AAppName);
    if Assigned(App) then
      Result := App.ClientsDBLite
    else
      Result := lClientsDBLite+'_'+AAppName+'.DB';
  End;
//20170722 Igor<<<
end;

function RetInMem: Integer;
var
  i: integer;
begin
  (* count only assigned items
  *)
  Result := 0;
  for i := 1 to RetList.Count - 1 do //don't count dummy at index zero
    if assigned(RetList[i])
      and not RetList[i].Destroying then
      inc(Result);
end;

function DrawingRetInMem: Integer; //20161028 Igor
var
  i: integer;
begin
  (* count only assigned items
  *)
  Result := 0;
  for i := 1 to RetList.Count - 1 do //don't count dummy at index zero
    if assigned(RetList[i])
      and not RetList[i].Destroying
      and RetList[i].isCreateMDIChild then
      inc(Result);
end;

function RetInMem(AApp: TApp; AWithOutAppendix: Boolean = False): Integer; //20170307 Igor
var
  i: integer;
begin
  (* count only assigned items
  *)
  Result := 0;
  for i := 1 to RetList.Count - 1 do //don't count dummy at index zero
    if assigned(RetList[i])
       and not RetList[i].Destroying
       and (not AWithOutAppendix or Not RetList[i].isAppendix) //20170307 Igor
       and (RetList[i].MyApp = AApp) then
      inc(Result);
end;

{$IFDEF dynamic}

function FormName: string;
var
  MyChild: TMyChild;
  MyPage: Ttabsheet;
begin
  Result := ''; //or some error indicator?
  MyChild := GetActiveChild;
  if (MyChild = nil) then
    exit;
  MyPage := MyChild.Pages.ActivePage;
  if MyPage = nil then
    exit;
  Result := MyPage.Caption;
end;

function FormNo: integer;
var
  MyChild: TMyChild;
  MyPage: Ttabsheet;
begin
  Result := 0; //or some error indicator?
  MyChild := GetActiveChild;
  if (MyChild = nil) then
    exit;
  MyPage := MyChild.Pages.ActivePage;
  if MyPage = nil then
    exit;
  Result := MyPage.Tag;
end;
{$ELSE}
var //updated on write requests to the previously global variables
  FRetNo: integer;
  FFormName: string;
  FFormNo: integer;

function FormName: string;
begin
  Result := FFormName;
end;

function FormNo: integer;
begin
  Result := FFormNo;
end;

procedure FormNameNo(RNo: integer; FName: string);
begin
  FRetNo := RNo;
  GetCurrentRetNo := RNo;
  FFormName := FName;
  if RNo = 0 then
    FFormNo := 0
  else
    FFormNo := GetRetFormNo(RNo, FName);
end;

procedure GetFormNameNo(var RNo, FNo: integer; var FName: string);
begin
  RNo := FRetNo;
  FNo := FFormNo;
  FName := FFormName;
end;

{$ENDIF}

procedure UpdateChildWin(RetNo: integer);
var
  MyChild: TMyChild;
begin
  MyChild := RetList[RetNo].MyChild;
  if MyChild <> nil then
    MyChild.UpdateFrames;
end;

procedure UpdateChildTaxPanelOnly(RetNo: integer);
var
  MyChild: TMyChild;
begin
  (* Call when there is absolutely no need to update the header frame
  *)
  MyChild := RetList[RetNo].MyChild;
  if assigned(MyChild) then
    MyChild.UpdateChildTaxPanel;
end;

procedure UpdateAllVisibleForms;
var
  MyChild: TMyChild;
begin
  //If RetInMem >0 then MyChild.ShowFormData(MyChild,GetCurrentRetNo,FormName,FormNo);
  //GetActiveChild.PopulateActiveFormWithData; //(GetActiveForm);
  MyChild := GetActiveChild;
  if MyChild = nil then
    exit;
  MyChild.ActiveForm.PopulateFormWithData;
  FloatingForms.UpdateForms(MyChild.RetNo);
end;

function FormHasInstanceIndicator(RetNo: integer; FName: string): Boolean;
begin
  Result := RetList[RetNo].MyApp.FList.ByFormName(FName).FormInst <> '';
end;

function GetFNoOfFirstInstance(RetNo: integer; FName: string; FNo: Integer): Integer;
var
  FRec: TFRec;
begin
  Result := FNo;
  FRec := RetList[RetNo].MyApp.FList.ByFormNoNil(FNo);
  if FRec = nil then
    exit; //error!!!
  Result := FRec.FirstInstFNo;
end;

procedure LoadTV(RetNo: integer; FName: string; FNo: integer);
begin
  RetList[RetNo].LoadTV(RetNo, FName, FNo);
end;

procedure SaveTV(RetNo: integer; FName: string; FNo: integer);
begin
  RetList[RetNo].SaveTV(RetNo, FName, FNo);
end;

procedure ClearDiagnostics(RetNo: integer);
begin
  RetList[RetNo].ClearDiagnostics;
end;

procedure SaveDiagnostic(RetNo: Integer; FrmNm: string; ElmNo: integer; ErrMsg: string);
begin
  SaveDiagnostic(RetNo, FrmNm, ElmNo, ErrMsg[1], MidStr(ErrMsg, 3, Length(ErrMsg)));
end;

procedure SaveDiagnostic(RetNo: Integer; FrmNm: string; ElmNo: integer; Category: char; ErrMsg: string);
begin
  RetList[RetNo].AddAudit(Category, ErrMsg, FrmNm, ElmNo);
end;

procedure ClearElms(RetNo, FNo, FromElm, ToElm: integer);
var
  i, MaxElm: integer;
begin
  (* for use in Calc routines: clear range of edits (and corresponding TVs)
  *)
  with RetList[RetNo].Frm[FNo] do
  begin
    MaxElm := Count - 1;
    if FromElm > MaxElm then
      exit;
    if ToElm > MaxElm then
    begin
      //diagnose
      BugMsg(Format('Clear %s:%s Elm=%d..%d > %d',
        [RetList[RetNo].MyApp.AppId, GetRetFormName(RetNo, FNo), FromElm, ToElm, MaxElm]), elmFile);
      ToElm := MaxElm;
    end;
    for i := FromElm to ToElm do
    begin
      Elms[i] := '';
      TV[i] := 0;
    end;
  end;
end;

procedure InitFormData(RetNo, FNo: integer);
begin
  (* only assert form created
  *)
  if RetList[RetNo].Frm[FNo] = nil then
    RetList[RetNo].Frm[FNo] := TFormData.Create(RetNo, FNo);
end;

function ClearForm(RetNo: integer; FName: string): boolean;
var
  i, FNo: integer;
  //FList: TFList;
  FRec: TFRec;
  BaseName: string;
begin
  (* clear all data elements of the form.
    The ChildWin must be refreshed after recalculation
    !!!prevent bad FName and protect locked forms!!!
  *)
  Result := False;
  with RetList[RetNo] do
  begin
    //FList := {RetList[retNo].}MyApp.FList;
    FRec := FList.ByFormName(FName);
    FNo := FRec.FormNo;
    if FNo < 1 then
      exit; //bad call
    if Locked then
    begin
      BugMsg('Cannot clear locked form: ' + FName);
      exit;
    end;
    i := Pos('_', FName);
    if i > 0 then // IsFormMultiPage(FName) then
    begin
      BaseName := Copy(FName, 1, i);
      for i := 0 to FList.Count - 1 do
      begin
        FRec := FList.ByIndex(i);
        if Copy(FRec.FormName, 1, Length(BaseName)) = BaseName then
          Result := ClrForm(FRec.FormName);
      end;
    end
    else
      Result := ClrForm(FName);
    Calc(RetNo, FName); //depending on AppId?
    {Ret[RetNo].}Changed := True;
  end; //with
end;

procedure CloneForm(FromRetNo: integer; FromFormName: string; ToRetNo: integer;
  ToFormName: string = ''; AAll: Boolean = False); //20160722 igor
begin
  if ToFormName = '' then
    ToFormName := FromFormName;
  RetList[FromRetNo].CloneForm(FromFormName, ToRetNo, ToFormName, AAll); //20160722 igor
end;

procedure CloneReturn(FromRetNo: integer; ToRetNo: integer);
begin
  RetList[FromRetNo].CloneReturn(ToRetNo);
end;

procedure UpdateFormDataIndicator(RetNo: Integer; Frec: TFRec);
//Procedure UpdateFormDataIndicator(RetNo:Integer;FNo:Integer;S:String);
{S contains the key elements to decide if form has data, sep by commas}
var
  i, j, k, NumOfElms, FromElm, ToElm: Integer;
  CurrentRoutine: string;
  FName: string;
  OriginalForm: string absolute FName; //10 to 12  //20101116
  DataElm: array[1..20] of string;
  MaxElm: integer;
  FNo: Integer;
  S: string;
  //20260703 Alex >>>
  function IsRMoreThenOne(): Boolean;
  var
    z, lRCount: Integer;
  begin
    Result:= False;
    lRCount:= 0;
    for z:= 1 to High(DataElm) do
      if UpperCase(DataElm[z]).Equals('R') then inc(lRCount, 1);

    Result:= lRCount > 1;
  end;
  //20260703 Alex <<<
begin
  FNo := Frec.FormNo;
  if FNo < 1 then
    Exit; //20101219
  if RetList[RetNo].isAppendix then exit; // 20160305 Igor
  OriginalForm := GetRetFormName(RetNo, FNo);
  RetList[RetNo].FrmHasData[FNo] := False;

  with RetList[RetNo].Frm[FNo] do
  begin
    //check memos
    for i := 1 to FRec.MaxMemo do
    begin
      if Memos[i] <> '' then
      begin
        RetList[RetNo].FrmHasData[FNo] := True;
        exit;
      end;
    end;

    s := trim(FRec.DataIndic); //20170606 Igor
    if s = '' then
      exit; //20100613
    MaxElm := Count - 1;
    //20101219
    CurrentRoutine := 'Update Data Ind: RetNo ' + IntToStr(RetNo) + '  ' + 'Form ' + OriginalForm + '  ' + 'Indicators :' + S; //200101217
    s := S + ','; {add comma at the end}
    try
      {Parse/Find comma delimited elms/put into array}
      for k := 1 to High(DataElm) do
        DataElm[k] := '';
      k := 1; {Comma position index}
      for j := 1 to Length(s) do
      begin
        if midStr(s, j, 1) = ',' then
          inc(k)
        else
          DataElm[k] := DataElm[k] + midstr(s, j, 1);
      end;
      NumOfElms := k - 1;

      {update the FrmHasData switch}
      if UpperCase(DataElm[1]) = 'L' then {depends on Line}
      begin
        for k := 2 to NumOfElms do
          if DataElm[k] > '' then
          try
            if RetList[RetNo].Ln[StrToInt(DataElm[k])] <> 0 then
              RetList[RetNo].FrmHasData[FNo] := True;
          except
            BugMsg('FormName= ' + Fname + 'FormNo= ' + IntToStr(FNo) + ' Data Indicator error: ' + s);
          end;
      end

      else if UpperCase(DataElm[1]) = 'Y' then {always}
        RetList[RetNo].FrmHasData[FNo] := True

      else if UpperCase(DataElm[1]) = 'F' then {depends on other form}
      begin
        //FName := GetFormName(RetNo,FNo);

        for k := 2 to 2 do {NumOfElms do}
          if DataElm[K] > '' then
          try
            if RetList[RetNo].FormHasData[DataElm[k] + ExtractFormInst(FName)] then
              RetList[RetNo].FrmHasData[Fno] := True;
          except
            BugMsg('FormName in F= ' + Fname + 'FormNo= ' + IntToStr(FNo) + ' Data Indicator error: ' + s);
          end;
      end
      //20260703 Alex >>>
      else if UpperCase(DataElm[1]).Equals('R') and IsRMoreThenOne() then {Array of Ranges: check all elements}
      begin
        if (Count > 0) then
          for k:= 1 to High(DataElm) do
            if not RetList[RetNo].FrmHasData[Fno] and UpperCase(DataElm[k]).Equals('R') then
            begin
              FromElm:= MyStrToInt(DataElm[k + 1]);
              if (FromElm > MaxElm) then Exit;
              ToElm:= MyStrToInt(DataElm[k + 2]); // Pars(s,3,','));
              if (ToElm > MaxElm) then
              begin
                BugMsg(Format('DataIndicator %s:%s=%s > %d', [RetList[RetNo].MyApp.AppId, FName, s, MaxElm]));
                ToElm:= MaxElm;
              end;

              for i:= FromElm to ToElm do
              try
                if not FetchElmFNo(RetNo, FNo, i).IsEmpty() then
                begin
                  RetList[RetNo].FrmHasData[Fno]:= True;
                  Break;
                end;
              except
                BugMsg('FormName In F= ' + Fname + 'FormNo= ' + IntToStr(FNo) + ' Data Indicator error: ' + s);
              end;
            end;
      end
      //20260703 Alex <<<
      else if UpperCase(DataElm[1]) = 'R' then {Range: check all elements}
      begin
        if {Ret[RetNo].Frm[FNo].} Count > 0 then
        begin
          //FName := GetFormName(RetNo,FNo);
          //FromElm :=MyStrToInt(Pars(s,2,','));
          FromElm := MyStrToInt(DataElm[2]); // Pars(s,2,','));
          if FromElm > MaxElm then
            exit; //nothing stored
          //ToElm   :=MyStrToInt(Pars(s,3,','));
          ToElm := MyStrToInt(DataElm[3]); // Pars(s,3,','));
          if ToElm > MaxElm then
          begin
            BugMsg(Format('DataIndicator %s:%s=%s > %d',
              [RetList[RetNo].MyApp.AppId, FName, s, MaxElm]));
            ToElm := MaxElm;
          end;
          for i := FromElm to ToElm do
          try
            if FetchElmFNo(RetNo, FNo, i) > '' then
            begin
              RetList[RetNo].FrmHasData[Fno] := True;
              break;
            end;
          except
            BugMsg('FormName In F= ' + Fname + 'FormNo= ' + IntToStr(FNo) + ' Data Indicator error: ' + s);
          end;
        end;
      end

      else {depends on specific elm values}
      try
        if {Ret[RetNo].Frm[FNo].} Count > 0 then {initialized}
        begin
          for k := 1 to NumOfElms do
            if DataElm[k] > '' then
            begin
              FromElm := MyStrToint(DataElm[k]);
              if (FromElm > MaxElm) and (FromElm < arraymul) then
              begin
                BugMsg(Format('DataIndicator %s:%s=%s > %d',
                  [RetList[RetNo].MyApp.AppId, FName, s, MaxElm]));
              end
              else if FetchElmFNo(RetNo, FNo, FromElm) > '' then
              begin
                RetList[RetNo].FrmHasData[Fno] := True;
                break;
              end;
            end;
        end;
      except
        begin
          //If FNo>FormsLimit then  //20101223
          if FName = '' then //20101223
          begin
            // ShowMessage('OrigFormName= '+OriginalForm+ 'FormNo= '+IntToStr(FNo)+' Data Indicator error: '+s); //20101223
            Exit;
          end;
        end;
      end;
    except
      begin
        BugMsg('Maybe a problem in ' + CurrentRoutine); //20101219
        Exit;
      end;
    end;
  end; //with
end;

{$IFDEF new}

procedure UpdateFormDataIndicator(RetNo: integer; FRec: TFRec);
var
  i, j: integer;
  lst: TStringList;
begin
  RetList[RetNo].FormHasData[FRec.FormName] := False;
  with RetList[RetNo].Frm[FRec.FormNo] do
  begin
    for i := 1 to FRec.MaxMemo do
    begin
      if Memos[i] <> '' then
      begin
        RetList[RetNo].FormHasData[FRec.FormName] := True;
        exit;
      end;
    end;

    if FRec.DataIndic <> '' then
    begin
      lst := TStringList.Create;
      try
        lst.CommaText := FRec.DataIndic;
        case lst[0][1] of
          'R': ;
        else //case
          for i := 0 to lst.Count - 1 do
          begin
            //RetList[RetNo].FormHasData[FRec.FormName] := True;
          end;
        end; //case
      finally
        lst.Free;
      end;
    end;
  end;
end;
{$ENDIF}

function NoActiveForm: boolean; //for currently active ChildWin page
var
  MyChild: TMyChild;
begin
  (* used by GUI
  *)
    //Result := True; //if fails
  MyChild := GetActiveChild;
  Result := MyChild = nil;
  if Result then
    exit;
  Result := MyChild.ActiveForm = nil; //.NoActiveForm;
end;

function GetFieldColorFromHint(AuditRec: TAuditRec): TColor;
begin
  Result := clWhite; //no Hint
  if AuditRec = nil then
    exit;
  case AuditRec.Category of
    'M', 'E': Result := clYellow;
    'W': Result := LightGreen;
  end;
end;

{ TOverList }

destructor TOverList.Destroy;
begin
  inherited;
end;

procedure TOverList.EnumRecs(AppId: TApp; Lst: TStrings);
var
  i: integer;
  FName: string;
begin
  lst.Clear;
  for i := 0 to Count - 1 do
  begin
    TObject(OverRec) := Items[i];
    if RetList[OverRec.RetNo].MyApp = AppId then
      FName := GetRetFormName(OverRec.RetNo, OverRec.FormNo);
    lst.AddObject(FName, OverRec);
  end;
end;

function TOverList.GetFieldOverride(Index: integer): TOverRec;
begin
  TObject(Result) := Items[index];
end;

function TOverList.OvrOn(RetNo, FormNo, FieldId: integer): TOverRec;
var
  i: integer;
begin
  for i := 0 to (Count - 1) do
  begin
    TObject(Result) := Items[i];
    if (Result.RetNo = RetNo)
      and (Result.FormNo = FormNo)
      and (Result.FieldId = FieldId) then
      exit;
  end;
  //none found
  Result := nil;
end;

function TOverList.RemoveOverride(r: TOverRec): boolean;
var
  i: integer;
begin
  //remove AND destroy OverRec!
  i := IndexOf(r);
  Result := i >= 0;
  if Result then
    Delete(i);
end;

function TOverList.RetOn(RetNo: integer): boolean;
var
  i: integer;
  OverRec: TOverRec;
begin
  (* Any overrides for RetNo?
  *)
  Result := True;
  for i := 0 to (Count - 1) do
  begin
    TObject(OverRec) := Items[i];
    if (OverRec.RetNo = RetNo) then
      exit;
  end;
  Result := False; //none found
end;

function TOverList.SetFieldOverride(RetNo, FormNo,
  FieldId: integer): TOverRec;
begin
  Result := OvrOn(RetNo, FormNo, FieldId);
  if Result <> nil then
    exit;
  Result := TOverRec.Create(RetNo, FormNo, FieldId);
  Add(Result);
end;

function OvrOn(RetNo, FormNo, FieldId: integer): boolean;
begin
  Result := OverList.OvrOn(RetNo, FormNo, FieldId) <> nil;
end;

function GetFormOvrSw(RetNo: integer; FormNo: Integer): boolean;
var
  I: integer;
begin
  Result := True;
  for i := 0 to (OverList.Count - 1) do
  begin
    TObject(OverRec) := OverList.Items[i];
    if (OverRec.RetNo = RetNo) and
      (OverRec.FormNo = FormNo) then
      exit;
  end;
  //none
  Result := False;
end;

function SetFieldOverride(RetNo, FormNo, FieldId: integer): TOverRec;
var
  s: string;
begin
  Result := OverList.OvrOn(RetNo, FormNo, FieldId);
  if Result = nil then
  begin
    {add the override}
    s := FetchElm(RetNo, FormNo, FieldId); //calculated value
    Result := TOverRec.Create(RetNo, FormNo, FieldId);
    OverList.Add(result);
    Result.Value := s; //init to calculated value?
  end;
end;

procedure SaveFieldOverride(RetNo, FormNo, FieldId: integer; Value: string);
begin
  OverRec := OverList.SetFieldOverride(RetNo, FormNo, FieldId);
  OverRec.Value := Value; //bypass Put setter
end;

procedure RemoveFieldOverride(RetNo, FormNo, FieldId: integer);
begin
  OverRec := OverList.OvrOn(RetNo, FormNo, FieldId);
  if OverRec <> nil then
  begin
    OverList.Remove(OverRec); //remove AND destroy
    RetList[RetNo].CalcAll; //20140905
  end;
end;

procedure RemoveFormOverrides(const RetNo, FNo: integer);
var
  i, Cnt: integer;
begin
  (* part of ClearForm
  *)
  Cnt := OverList.Count;
  for i := Cnt - 1 downto 0 do
  begin
    TObject(OverRec) := OverList.Items[i];
    if (OverRec.RetNo = RetNo)
      and (OverRec.FormNo = FormNo) then
      OverList.Remove(OverRec);
  end;
  {
    if RetList[RetNo].Destroying then
      exit; //no further handling allowed
    if OverList.Count < Cnt then //something deleted?
      CalcAll(RetNo);
  }
end;

procedure RemoveReturnOverrides(RetNo: integer);
var
  i, Cnt, FNo: integer;
begin
  Cnt := OverList.Count;
  for i := Cnt - 1 downto 0 do
  begin
    TObject(OverRec) := OverList.Items[i];
    if OverRec.RetNo = RetNo then
    begin
      FNo := OverRec.FormNo;
      OverList.Remove(OverRec); //destroys the OverRec!
      if not RetList[RetNo].Destroying then
        CalcNo(RetNo, FNo); //only when NOT called during close return
      //CalcAll(RetNo);
    end;
  end;
  if RetList[RetNo].Destroying then
    exit; //no further handling allowed
  if OverList.Count < Cnt then //something deleted?
    CalcAll(RetNo);
end;

function GetOvrValue(RetNo, FormNo, FieldId: integer): string;
begin
  OverRec := OverList.OvrOn(RetNo, FormNo, FieldId);
  if OverRec = nil then
    Result := ''
  else
    Result := OverRec.Value;
end;

{ TOverRec }

constructor TOverRec.Create(RNo, FNo, FId: integer);
begin
  if FNo=0 then exit; //20221216

  RetNo := RNo;
  FormNo := FNo;
  FieldId := FId;
  //flag in data
  //20170609 Igor >>>
  if FId < RetList[RNo].Frm[FNo].Count then
    RetList[RNo].Frm[FNo].Objects[FId] := Self
  else //Dynamics data
    RetList[RNo].Frm[FNo].DynOverload.AddOrSetValue(FId, Self)
  //20170609 Igor <<<
end;

destructor TOverRec.Destroy;
begin
  (* Remove override mark from return (form data).
    Prevent illegal refs on close program or return!
    Overrides should be removed on return close!

    Also remove from OverList, preventing recursion!
    Problem: never destroy programmatically, is done by OverList owning objects!
  *)
  //flag in data
  if assigned(RetList)
    and assigned(RetList[RetNo])
    and not RetList[RetNo].Destroying then
  begin
    //20170609 igor >>>
    if FieldId < RetList[RetNo].Frm[FormNo].Count then
      RetList[RetNo].Frm[FormNo].Objects[FieldId] := nil
    else //Dynamics data
      if RetList[RetNo].Frm[FormNo].DynOverload.ContainsKey(FieldId) then
        RetList[RetNo].Frm[FormNo].DynOverload.Remove(FieldId);
    //20170609 igor <<<
    //restore calculated value in the edit field?
    //OverList.RemoveOverride(self); - owns objects!
  end;

  inherited;
end;

{ TReviewRec }

constructor TReviewRec.Create(RNo, FNo, FId: integer);
begin
  RetNo := RNo;
  FormNo := FNo;
  FieldId := FId;
  //drop?
  ReviewSw := True;
  Symbol := 1;
end;

{ TReviewList }

destructor TReviewList.Destroy;
begin
  inherited;
end;

procedure TReviewList.EnumRecs(AppId: TApp; Lst: TStrings);
var
  i: integer;
  FName: string;
begin
  lst.Clear;
  for i := 0 to Count - 1 do
  begin
    ReviewRec := ReviewList.GetRec(i);
    if RetList[ReviewRec.RetNo].MyApp = AppId then
      FName := getRetformname(ReviewRec.RetNo, ReviewRec.FormNo);
    lst.AddObject(FName, ReviewRec);
  end;
end;

function TReviewList.GetRec(index: integer): TReviewRec;
begin
  TObject(Result) := inherited Items[index];
end;

function ReviewOn(RetNo, FormNo, FieldId: integer): boolean;
var
  i: integer;
begin
  Result := True;
  for i := 0 to (ReviewList.Count - 1) do
  begin
    ReviewRec := ReviewList.Items[i];
    if (ReviewRec.RetNo = RetNo) and
      (ReviewRec.FormNo = FormNo) and
      (ReviewRec.FieldId = FieldId) then
      exit;
  end;
  //none
  Result := False;
end;

procedure SetReviewMark(RetNo: Integer; FormNo: integer; FieldId: integer);
var
  i: integer;
begin
  for i := 0 to (ReviewList.Count - 1) do
  begin
    ReviewRec := ReviewList.Items[i];
    if (ReviewRec.RetNo = RetNo) and
      (ReviewRec.FormNo = FormNo) and
      (ReviewRec.FieldId = FieldId) then
    begin ReviewRec.ReviewSw := True;
      exit;
    end;
  end;
  {add a new Review rec}
  ReviewRec := TReviewRec.Create(RetNo, FormNo, FieldId);
  ReviewList.Add(ReviewRec);
end;

procedure RemoveReviewMark(RetNo: Integer; FormNo: integer; FieldId: integer);
var
  i: integer;
begin
  for i := ReviewList.Count - 1 downto 0 do
  begin
    ReviewRec := ReviewList.Items[i];
    if (ReviewRec.RetNo = RetNo)
      and (ReviewRec.FormNo = FormNo)
      and (ReviewRec.FieldId = FieldId) then
      ReviewList.Delete(i); //.Remove(ReviewRec);
  end;
end;

procedure RemoveRetReviewMarks(RetNo: Integer);
var
  i: integer;
begin
  for i := ReviewList.Count - 1 downto 0 do
  begin
    ReviewRec := ReviewList.Items[i];
    if (ReviewRec.RetNo = RetNo) then
      ReviewList.Delete(i); //.Remove(ReviewRec);
  end;
end;

function FormHasReviewMarks(RetNo, FNo: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to (ReviewList.Count - 1) do
  begin
    ReviewRec := ReviewList.Items[i];
    if (ReviewRec.RetNo = RetNo) and (ReviewRec.FormNo = FNo) then
    begin
      Result := True;
      exit;
    end;
  end;
end;

procedure SignOffAWarning(RetNo: Integer; r: TAuditRec);
//procedure SignOffAWarning(RetNo:Integer;ErrMsg:String);
//Function SignOffAWarning(RetNo:Integer;ErrMsg:String):Boolean;
begin
  (* Sign off and refresh everything if successful.
    To be used by all user code.
    ErrMsg='' means by dialog.
  *)
    //if ErrMsg = '' then
  if r = nil then
  begin
    SignOffWarnings(RetNo);
    exit;
  end;
  with RetList[RetNo].AuditList do
  begin
    case r.Category of
      'O': exit; //already done
      'R': //Review mark - remove
        begin
          RemoveReviewMark(RetNo, RetList[RetNo].GetFormNo(r.form), r.Elm);
        end;
      'W':
        begin
          r.Category := 'O';
          //exit;
        end;
    else
      UserMsg('You can only sign off Warnings');
      Exit;
    end;
    Changed := True;
    EndUpdate;
  end;

  {
    MyChild.Invalidate; //refresh field properties
    MainForm.RefreshAuditPanel(RetNo);
    //Result := RetList[RetNo].DoSignOffAWarning(ErrMsg);
  }
end;

function GetOptionValue(FieldNm: string; TempList: TStringList): string;
var
  i: Integer;
begin
  (* shared options take precedence!
  *)
  Result := '';
  //20170127 Igor >>>
  if MainOptions.HaveOptions(FieldNm) then
  Begin
    Result := MainOptions.ReadOptions(FieldNm)
//    i := MainOptions.IndexOfName(FieldNm);
//    if i >= 0 then
//    begin
      //NotImp('GetOption: ' + FieldNm);
//      Result := MainOptions.Values[FieldNm]; //maybe outdated!?
//    end
  //20170127 Igor <<<
  End
  else
  begin
    i := IsInList(FieldNm, TempList);
    if i > -1 then
      result := MidStr(Templist[i], 21, 250); //jz//20250324 increase from 21 to 31 caused error , changed back
  end;
end;

procedure SaveOptionValue(FieldNm: string; Value: string; TempList: TStringList);
begin
  (* used in OptionsFrm, accept MainOptions changes?
    update GUI when MainOption changed?
  *)
  //if MainOptions.IndexOfName(FieldNm) >= 0 then //20170127 Igor
  if MainOptions.HaveOptions(FieldNm) then        //20170127 Igor
  begin
    //NotImp('SaveOption: ' + FieldNm);
    MainOptions.Values[FieldNm] := Value; //accept change - load how???
    MainOptions.SetOptions(FieldNm, Value); //20170127 Igor
    exit; //???
  end;
  TempList.Add(PaddR(FieldNm, 20) + Value); //jz//20250324 - increase paddr from 20 to 30, caused error , changed back
end;

function ReadComponentResFile(const DfmFileName: string; AForm: TComponent; AShowError: boolean = false): TComponent; //20220127 Igor
var oldVisible:Boolean;
begin
  //rem 20151030 Igor //20151013 Igor
  //if AForm is TWinControl then begin oldVisible:=TWinControl(AForm).Visible; TWinControl(AForm).Visible:=false; end;

  if AForm is TvtScrollBox then                       //20161130 Igor
    TvtScrollBox(AForm).BeforeReadComponentResFile;    //20161130 Igor

  try
    Result := Classes.ReadComponentResFile(DfmFileName, AForm);
  except
    on e: Exception do
    begin
      //20220127 Igor >>>
      if AShowError then
        UserMsg('Error occured while processing '+ DfmFileName + #13#10 + e.Message);
      //20220127 Igor <<<
{$IFDEF DEBUG}
      ExceptMsg(e);
{$ELSE}
      UserMsg('Form ' + DfmFileName + ' is damaged. Contact VisualTax');
{$ENDIF}
      Result := nil;
    end;
  end;
  if AForm is TvtScrollBox then                       //20160720 Igor
    TvtScrollBox(AForm).AfterReadComponentResFile;    //20160720 Igor

  //rem 20151030 Igor //20151013 Igor
  //if AForm is TWinControl then TWinControl(AForm).Visible:= oldVisible;
end;

(* should return ior errorcode?
*)

function CheckFilePsw(Datadir, FlName: string; Elm: integer; APwdArr: Variant): integer; //20160415 Igor
var
  pwd: string;
begin
  (* Return iorReported if okay.
  *)
  result := GetFilePsw(Datadir, FlName, elm, pwd, APwdArr); //20160415 Igor
  //fail: file does not exist
  if Result = iorFileName then
    exit; //no such file
  if (Result = iorReported) and (pwd = '') then
    exit; //file ok, no psw
  if YouKnowTheReturnPassword(pwd) then
    Result := iorReported;
  //ShowTimedMsg('Wrong password', 2000);
end;

function CheckFileAndPsw(Datadir, FlName: string; Elm: integer; APwdArr: Variant): boolean; //20160415 Igor
var
  ior: integer;
begin
  ior := CheckFilePsw(Datadir, FlName, Elm, APwdArr); //20160415 Igor
  Result := ior = iorReported;
  if not Result then
    showopenreturnfailure(ior, Datadir, FlName);
end;

function GetFilePsw(Datadir, FlName: string; Elm: integer; var pwd: string; APwdArr: Variant): integer; //20160415 Igor
// returns the unencrypted
var
  FullFlName: string; //TempList:TStringList;
  Val1, Val2, Val3, Val4, ElmStr: string;
  fs: TFileStorage;
  SQLite: TSQLiteStorage; //20160415 Igor
  S: String; //20161206 Igor
begin
  pwd := '';
  Result := iorReported;
  FullFlName := DataDir + '\' + FlName;
  //20170315 Igor >>>
  if not FileExists(FullFlName) then
  begin
    Result := iorFileName;
    exit;
  end;
  //20170315 Igor <<<
 //20160415 Igor>>>
  SQLite := TSQLiteStorage.Create(Datadir, FlName, fsRead, APwdArr);
  try
    if SQLite.LastError = '' then
    Begin
      //20161206 Igor >>>
      S := SQLite.ReadData('STATUS', 'D', Elm);
      if S <> '' then
      Begin
        pwd := DecryptPsw(S, 9999);
      //20161206 Igor
        Result := iorPassword;
      End;
      exit;
    End;
  finally
    SQLite.free;
  end;
 //20160415 Igor<<<
  (* Read the return file, get STATUS[Elm], decrypt
    Return iorFileName if file does not exist.
    Return iorPassword if password specified, else iorReported=0.
  *)
//20170315 Igor >>>
//  if not FileExists(FullFlName) then
//  begin
//    Result := iorFileName;
//    //UserMsg('Cannot locate the file '+FullFlName);
//    exit;
//  end;
//20170315 Igor <<<

  ElmStr := IntToStr(Elm);
  fs := TFileStorage.Create(Datadir, FlName, fsRead);
  if not fs.ReadLine(Val1, Val2, Val3, Val4) then //skip header
  begin
       fs.Free;//20151223 Igor
       exit;
  end;
  while fs.ReadLine(Val1, Val2, Val3, Val4) do
  begin
    if (Val1 = 'F') and (Val2 = 'STATUS') then
    begin
      while fs.ReadLine(Val1, Val2, Val3, Val4) do
      begin
        if (Val1 <> 'D') then
        begin
          fs.Free;
          exit;
        end;
        if (Val2 = ElmStr) then
        begin
          pwd := DecryptPsw(Val3, 9999);
          Result := iorPassword;
          fs.Free;
          exit;
        end;
      end;
    end;
  end;
  fs.Free;
end;

function IsDevelopmentMode: Boolean;
begin
  //unusable with multi-app
  Result := FileExists(ExeDir + '\' + 'Main.pas');
end;

procedure LockWindowUpdate(hwnd: HWND);
begin
  (* try: reset lock only in OnIdle
    Problem: forced updates seem to occur!
  *)
  if hwnd = 0 then
    exit; //ignore unlocks
  if WindowLocks = 0 then
  begin
    Windows.LockWindowUpdate(hwnd);
    Screen.Cursor := crHourGlass;
  end;
  inc(WindowLocks);
end;

procedure ShowOpenReturnFailure(var FailCode: integer; DataDir: string; FlName: string);
begin
  if FailCode > 0 then
    exit; //no error
  case FailCode of
    iorReported: ; //message already shown
    iorFileName: UserMsg('File ' + FlName + ' does not exist' +
        Chr(13) + 'in dir: ' + DataDir);
    iorFileType: UserMsg('File ' + FlName + ' is not a tax return');
    iorCountExceeded: UserMsg('Exceeds number of maximum returns in memory');
    iorPassword: UserMsg('Wrong password'); //show when checked!?
    iorFileRead: UserMsg('Reading of data may be incomplete ' + FlName);
  else
    UserMsg('Some error occured');
  end;
  FailCode := iorReported; //message shown, don't show again
end;

{ TExtractedAutoList }

function TExtractedAutoList.GetItems(index: integer): TExtractedAutoRec;
begin
  TObject(Result) := inherited Get(index);
end;


{ TExtractedCCAList }

function TExtractedCCAList.GetItems(index: integer): TExtractedCCARec;
begin
  TObject(Result) := inherited Get(index);
end;


// ------ dynamic data -------

{ TLabelSectList }

(* Keep column widths consistent!
*)

procedure TLabelSectList.AddLabel(ALabel: TLabel; FName: string);
begin
  Add(' ' + PaddR(ALabel.Caption, 80) + PaddR(FName, 10) + IntToStr(ALabel.Top));
end;

constructor TLabelSectList.Create(App: TApp);
begin
  inherited Create;
  MyApp := App;
end;

procedure TLabelSectList.ExtractSectionLabels(FName, OriginalInst: string; SomeList: TStringList);
var
  i, j: Integer;
  s: string;
begin
  for i := 0 to count - 1 do
  begin
    s := Strings[i];
    if AllTrim(LeftStr(S, 10)) = Fname then //got right rec
    begin
      if AllTrim(MidStr(s, 81, 15)) = '' then //it is a header rec
      begin
        SomeList.Add(S);
        for j := i + 1 to count - 1 do //get lbls related to fname
        begin
          s := Strings[j];
          if AllTrim(MidStr(S, 82, 10)) <> FName then
            Exit; //reached next form labels
          s := StringReplace(S, '#1', OriginalInst, [RfReplaceAll]);
          SomeList.Add(s);
        end; //j
      end; //header rec
    end; //found fname
  end; //i
end;

procedure TLabelSectList.GetFormSections(FName: string;
  SomeList: TstringList);
var //I,J:Integer;AForm:TForm;ALabel:TVtLabel;
  i, mxPg: Integer;
  OriginalInst, MatchingInst: string;
  FRootName, OriginalFName: string;
begin
  MatchingInst := '';
  OriginalFName := FName;
  OriginalInst := ExtractFormInst(OriginalFName);

  if OriginalInst = '' then
    MatchingInst := ''
  else if OriginalInst = '#1' then
    MatchingInst := OriginalInst
  else if OriginalInst > '#1' then //table only has inst #1 for matching purposes
  begin
    MatchingInst := '#1';
    FName := ExtractNonInstFormName(FName) + '#1';
  end;

  //LblSectList:=TStringList.Create;
  LoadFromFile(MyApp.AppDir + '\' + 'LblSect.d');

  if (IsFormMultipage(FName)) = false then //i.e Info, T4, etc
  begin
    ExtractSectionLabels(FName, OriginalInst, SomeList); //returns some list
    exit;
  end;

  // Multi page now
  FRootName := ExtractFormRootName(FName); //i.e Page
  MxPg := MyApp.FList.ByFormName(FName).FormMxPg; //GetFormMxPg(FName);
  for I := 1 to MxPg do
  begin
    FName := FRootName + '_' + IntToStr(i) + MatchingInst;
    ExtractSectionLabels(FName, OriginalInst, SomeList); //returns some list
  end;
end;

{ TTemplCopies }

constructor TTemplCopies.Create(RetNo: integer; Dir, TemplName: string);
var
  i: integer;
  s: string;

  procedure AddCopies(i: integer; FName, Copies: string);
  var
    FRec: TFRec;
  begin
    FRec := FList.ByFormName(FName);
    //AddObject(FName+'='+Copies, FRec);
    Strings[i] := FName + '=' + Copies;
    Objects[i] := FRec;
  end;

begin
  inherited Create;
  AppDir := Dir;
  {split: templist has nFFFFFF where n=copies and FFFF=form without instance
    replace by FFFF=n for Values[FFFF]
  }
  FList := RetList[RetNo].MyApp.FList;
  //TemplList := TStringList.Create;
  {TemplList.}LoadFromFile(Dir + '\' + TemplName);
  for i := 0 to {TemplList.} Count - 1 do
  begin
    s := Strings[i];
    AddCopies(i, MidStr(s, 2, 10), LeftStr(s, 1));
  end;
end;

procedure TTemplCopies.FinishPrintList(FormsToPrint: TStrings);
var
  i, ic: integer;
  FRec: TFRec;
  FName, Copies, seq: string;
  PrintSeq: TStringList;

  function GetPrintSequence(FName: string): string;
  var
    i: integer;
  begin
    if PrintSeq = nil then
      Result := FRec.PrnSeq
    else
    begin
      Result := '999';
      FName := UpperCase(ExtractNonInstFormName(FName));
      for i := 0 to (PrintSeq.Count - 1) do
      begin
        if UpperCase(AllTrim(LeftStr(PrintSeq[i], 15))) = FName then
        begin
          result := AddLeadingZeros(MidStr(PrintSeq[i], 16, 3), 3);
          exit;
        end;
      end;
    end;
    if Result = '' then
      Result := '999';
  end;

begin
  {match and attach number of copies}
  //special T1: use PrintSeq.txt for print sequence
  PrintSeq := nil;
  if FileExists(AppDir + '\' + 'PrintSeq.txt') then
  begin
    PrintSeq := TStringList.Create;
    PrintSeq.LoadFromFile(AppDir + '\' + 'PrintSeq.txt');
  end;

  //now format
  for i := 0 to FormsToPrint.Count - 1 do
  begin
    FName := FormsToPrint[i];
    Copies := Values[ExtractNonInstFormName(FName)]; //20160719 Igor
    ic := IndexOfName(ExtractNonInstFormName(FName));//20160327 Igor
    TObject(FRec) := Objects[ic];
    seq := GetPrintSequence(FName); // FRec.PrnSeq;
    FormsToPrint[i] := {sssnFFFFFFFFF}
    seq //  GetPrintSequence(RetNo, ExtractNonInstFormName(FormsToPrint[i]))
    + copies // GetCopiesToPrint(FormsToPrint[i],TemplForms,TemplCopies)
    + FName; // FormsToPrint[i];
    //ShowMessage(FormsToPrint[i]);
  end;
  if FormsToPrint is TStringList then
    TStringList(FormsToPrint).Sorted := True; {sort by sequence}
  PrintSeq.Free;
end;

function TTemplCopies.IsExactlyInList(FName: string): integer;
begin
  Result := IndexOfName(FName);
end;

function GetUpdateFrequency: Integer;
begin
  Result := MainOptions.UpdateFrequency;
end;

function GetLastUpdCheck: string;
begin
  Result := ReadPgmFileLine('LastUpdCheck.txt');
end;

//20170811 Igor>>>
(*
function UploadToDropBox(WindowHandle: HWND; ADir_ClientDocs: String = ''): Boolean; //20160614 Igor //20160803 Igor
var
  DropBox_ClientID, FilePath, Params, PgmPath: String;
  h: THandle;
begin
  //Get DropBoxClientID from options
  //20160729 Igor >>>
  DropBox_ClientID := 'clmqhseptut86vm';//CurrentApp.DropBox_ClientID;
//  if DropBox_ClientID = '' then
//  Begin
//    UserMsg('You should first enter the DropBox ClientID'
//            +Chr(13)+'See Configure | Security/Password | DropBox Client ID'); //20160728 Igor
//    exit;
//  End;
  //Get or Generate File vtMobile.sdb
  //20160729 Igor <<<
//20160728 Igor >>>

  params := '"' + IncludeTrailingPathDelimiter(CurrentApp.Dir_Cur) + '" '+
            '"' + CurrentApp.ClientsDBLite + '" '+
            '"' + ClientsTableLite + '" '+
            '"' + CurrentApp.SQLLitePassword.CurrentPassword + '" '+
            '"' + DropBox_ClientID + '" '+
            '"' + User.UserName + '" '+ //20160729 Igor //20170112 Igor
            '"' + CurrentApp.AppDir + '" ' + //20160803 Igor
            '"' + ADir_ClientDocs + '"';//20160803 Igor
  PgmPath := IncludeTrailingPathDelimiter(ExeDir) + 'vtFillDB.exe';

//  {$IFNDEF DEBUG}
//  if (FilePath = '') or not FileExists(FilePath) then
//  Begin
//    UserMsg('File for upload not generated.');
//    exit;
//  End;
//  {$ENDIF}
//  //Run uploader
//  params := '"' + DropBox_ClientID + '" "' + FilePath + '"';
//
//  PgmPath := '"' + ExeDir + '\vtUploadToDropBox.exe' + '"';
//20160728 Igor <<<

  h := ShellExecute(WindowHandle, 'open', Pchar('' + PgmPath), Pchar('' + params), nil, Sw_Show);
  Screen.Cursor := crDefault;

  if H <= 32 then
  begin
    UserMsg('The Upload program cannot run.'
      + Chr(13) + 'Error Code:  ' + IntToStr(H));
  end
end;
*)
procedure UpdateVirtualUI; //20190205 Igor
var cYear, cUpdateDir, cUpdateExe, cSetupCmd, cWaitCmd, cStr: string; //20190228 Igor
    nRes: Integer;

    procedure CreateSetupCmd;
    var FList: TStringList;
    begin
      if FileExists(cSetupCmd) then
        DeleteFile(cSetupCmd);
      FList := TStringList.Create;
      try
        FList.Add('net stop VirtualUISvc');
        FList.Add('taskkill /F /IM VT'+ cYear +'.exe');
        FList.Add(TPath.Combine(cUpdateDir, cUpdateExe) + ' /VERYSILENT');
        FList.Add('net start VirtualUISvc');
        FList.Add(' ');
        FList.SaveToFile(cSetupCmd);
      finally
        FList.Free;
      end;
    end;

    procedure CreateWaitCmd;
    var FList: TStringList;
    begin
      if FileExists(cWaitCmd) then
        DeleteFile(cWaitCmd);
      FList := TStringList.Create;
      try
        FList.Add('@ECHO OFF');
        FList.Add(':LOOP');
        FList.Add('tasklist | find /i "VT'+ cYear +'.exe" >nul 2>&1');
        FList.Add('IF ERRORLEVEL 1 (');
        FList.Add('  GOTO CONTINUE');
        FList.Add(') ELSE (');
        FList.Add('  ECHO VT'+ cYear +'.exe is still running');
        FList.Add('  Timeout /T 5 /Nobreak');
        FList.Add('  GOTO LOOP');
        FList.Add(')');

        FList.Add(':CONTINUE');
        FList.Add(cSetupCmd);
        FList.Add(' ');
        FList.SaveToFile(cWaitCmd);
      finally
        FList.Free;
      end;
    end;

    function RunningProcessesCount(AFileName: string): integer;
    var
      Snapshot: THandle;
      pe: TProcessEntry32;
    begin
      Result := 0;
      Snapshot := CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);
      try
        pe.dwSize := SizeOf(pe);
        if Process32First(Snapshot, pe) then
          while Process32Next(Snapshot, pe) do
            if SameText(ExtractFileName(pe.szExeFile), AFileName) then
              inc(Result);
      finally
        CloseHandle(Snapshot);
      end;
    end;

begin
  If UpperCase(InputBox('Password', #31'Enter Password', '')) <> 'IGOR' then Exit;
  cYear := CurrentApp.AppYear;
  //20190228 Igor >>>
  if SameText(CurrentApp.AppName, 'T2') or SameText(CurrentApp.AppName, 'FP') then
    cYear := IntToStr(StrToInt(cYear) - 1);
  //20190228 Igor <<<
  cUpdateDir := 'c:\VT-'+ cYear +'\UPDATE\';
  cUpdateExe := 'VT'+ cYear +'SetupFull.exe';
  cSetupCmd := TPath.Combine(cUpdateDir, 'setup.cmd');
  cWaitCmd := TPath.Combine(cUpdateDir, 'wait.cmd');
  ForceDirectories(cUpdateDir);
  if not UploadSetupExe('c:\VT-'+ cYear +'\UPDATE\', cUpdateExe) then Exit;
  CreateSetupCmd;
  CreateWaitCmd;
  VirtualUI.AllowExecute(ExtractFileName(cSetupCmd));
  VirtualUI.AllowExecute(ExtractFileName(cWaitCmd));
  if RunningProcessesCount('VT'+ cYear + '.exe') = 1 then
    ShellExecute(0, 'runas', Pchar(cSetupCmd), nil, nil, SW_HIDE)
  else
  begin
    nRes := CaseDo('There are running instances on server',
                   ['Close them and run update (data might not be saved)',
                    'Wait until all instances will be closed (you need to close your instance too)'], nil);
    case nRes of
      0 : ShellExecute(0, 'runas', Pchar(cSetupCmd), nil, nil, SW_HIDE);
      1 : ShellExecute(0, 'runas', Pchar(cWaitCmd), nil, nil, SW_HIDE);
    end;
  end;
end;

//20170811 Igor<<<
procedure Checkupdates(WindowHandle: HWND; AppTitle: string);
var
  h: THandle;
  spaceDelimiter, quotes, params, RegisteredApp: string;
  PgmPath: string;
  I: Integer;
begin
//20170927 Igor>>>
  if StartParams.isCloud then
  begin
    //20190205 Igor >>>
    //UserMsg(c_NotAvailable);
    UpdateVirtualUI;
    //20190205 Igor <<<
    Exit;
  end;
//20170927 Igor<<<

  Screen.Cursor := crHourGlass;
  //20160416 Igor >>>
  //20210118 Igor >>>
  if IsVtClient then
  begin
    RegisteredApp := ChangeFileExt(ExtractFileName(Application.ExeName),'') + '>>' +
        CurrentApp.vtClientUpdateDate + '>>' + AppRelease;
  end
  else
  begin
    RegisteredApp := ChangeFileExt(ExtractFileName(Application.ExeName),'') + '>>' +
        AppUpdateDate + '>>' + //20190917 Igor //20191007 Igor
        AppRelease;
    for I := 0 to AppList.Count - 1 do
    Begin
      if Assigned(AppList.GetApp(I)) AND AppList.GetApp(I).NeedUpdate then  //20160526 Igor
        RegisteredApp := RegisteredApp + '>>' +
          AppList.GetApp(I).AppTitle + '>>' +
          AppList.GetApp(I).AppUpdateDate + '>>' +
          AppList.GetApp(I).AppRelease;
      AppList.GetApp(I).NeedUpdate := true; //20160526 Igor
    End;
    RegisteredApp := RegisteredApp + '>>' + 'Utilities' + '>>' + GetUtilitiesDateUpdate + '>>' + AppRelease; //20190917 Igor
  end;
  //20210118 Igor <<<
  spaceDelimiter := ' ';
  quotes := '"';
  params := spaceDelimiter + quotes + RegisteredApp + quotes
    + spaceDelimiter + quotes + ExeDir + quotes
    + spaceDelimiter + quotes + UrlVersionFile + quotes //20160425 Igor
    + spaceDelimiter + quotes + Application.ExeName + quotes; //20160705 Igor
//    + spaceDelimiter + quotes + 'http://localhost/vt2015Versions.xml' + quotes;
  //20160416 Igor <<<

  //20130411 //add path when executing \vtchkupd.exe
  PgmPath := quotes + ExeDir + '\vtchkupd.exe' + quotes; //C:\Delphi\T1\vtchkupd.exe
  h := ShellExecute(WindowHandle, 'open', Pchar('' + PgmPath), Pchar('' + params), nil, Sw_Show);
  Screen.Cursor := crDefault;

  if H <= 32 then
  begin
    UserMsg('The Updater program cannot run.'
      + Chr(13) + 'Error Code:  ' + IntToStr(H));
    // +Chr(13)+'and unzipped into the program folder?');
  end
  else //now save the date
    WritePgmFileLine('LastUpdCheck.txt', FormatDateTime('yyyy-mm-dd', Date));
end;

//20160717 Igor
//function TimeToCheckUpdates: Boolean;
//var
//  LastUpdateDone: string;
//  DaysFreq: Integer;
//  D2, D1: string;
//begin
//  LastUpdateDone := GetLastUpdCheck;
//  if LastUpdateDone = '' then
//  begin Result := True;
//    Exit;
//  end;
//  //there is previous update
//  Result := False;
//  DaysFreq := GetUpdateFrequency;
//  if DaysFreq = 0 then
//  begin Result := False;
//    exit;
//  end;
//  D2 := FormatDateTime('yyyy/mm/dd', Date);
//  D1 := ReplaceChar(LastUpdateDone, '-', '/');
//  if DateDiffYMD(D1, D2) > DaysFreq then
//    result := True;
//end;

function MyCopyFile(const SourceFile, DestinationFile: string): boolean;
begin
  RESULT := Windows.CopyFile(pChar(SourceFile),
    pChar(DestinationFile),
    False); //alow override
end {CopyFile};

function MyMoveFile(const SourceFile, DestinationFile: string): boolean;
begin //it does not work!
  RESULT := Windows.MoveFile(pChar(SourceFile),
    pChar(DestinationFile));
  // True); //alow override
end;

(*
Procedure RenameUnitsInMultiApp;
Var Dir:String;
    //IncrBy:String;
    i:   integer;
    FileListBox1:TFileList;
    ListBox1:TListBox;

 begin
 EXIT;
  FileListbox1.Directory:='C:\delphi\vt-2015-fl\T2-2015\*.*';
  UnitPrefixTo:='T2_2015';
  dir := FileListbox1.Directory;

  if dir[Length(dir)] <> '\' then  dir := dir + '\';

  Listbox1.Clear;

 // if FileListbox1.SelCount > 0 then
     for i := 0 to FileListbox1.Items.Count - 1 do
       //if FileListbox1.Selected[f] then
       Listbox1.Items.Add(dir +  FileListbox1.Items[i]);

     ListBox1.refresh;
     For i:=0 to ListBox1.items.count-1 do
     begin
      //rename file
      OldFileNm:=ExtractFileName(ListBox1.Items[i]);
      NewFileNm:=UnitPrefixTo+MidStr(OldFileNm,8,15);
      RenameFile(ListBox1.Items[i],LeftStr(ListBox1.Items[i],Length(ListBox1.Items[i])-Length(OldFileNm))+NewFileNm);
     end;
 end;
 *)

function Reverse(S: String): String;
var I: Integer;
Begin
  Result := '';
  for I := length(S) downto 1 do
    Result := Result + S[I];
End;

Function GetReturnAppAndYear(ADataDir,AFlName: string; out AApp: String;
  out AYear: integer; APwdArr: Variant):Boolean; //20160311 Igor //20160703 Igor
var
  f : TFileStorage;
  Var1,Var2,Var3,Var4: String;
  SQLite: TSQLiteStorage; //20160415 Igor
Begin
  result := false;
  //20160703 Igor >>>
  SQLite := TSQLiteStorage.Create(ADatadir, AFlName, fsRead, APwdArr);
  try
    if SQLite.LastError = '' then
    Begin
      if not SQLite.ReadSettings('AppName', Var1) or
         not SQLite.ReadSettings('AppYear', Var2) then
        exit
      else
      begin
        if not tryStrToInt(Var2,AYear) then exit;
        result := True;
        AApp := Var1;
        exit; //20160713 Igor
      end;
    End;
  finally
    SQLite.free;
  end;
  //20160703 <<<
  f := TFileStorage.Create(ADataDir, AFlName, fsRead);
  try
    Try
      if not f.ReadLine(Var1,Var2,Var3,Var4) then exit;
      AApp := Var1;
      if not tryStrToInt(Var2,AYear) then exit;
      result := true;
    except ON E: Exception do
      BugMsg(E.Message);
    End;
  finally
    F.Free;
  end;
End;

function BackUpData(const ASrcDir, ADstDir: String; out AErr: String): Boolean; //20160502 Igor
Var
  i: Integer;
  TempList: TstringList;
begin
  Result := False;
  AErr := '';
  if not DirectoryExists(ASrcDir) then //20160615 Igor
  Begin
    AErr := 'Source directory "' + ASrcDir + '" does not exist';
    exit;
  End;

  If Not ForceDirectories(ADstDir) then
  begin
    AErr := 'Cannot create destination directory "' + ADstDir + '"'+ #13 + SysErrorMessage(GetLastError); //20160615 Igor
    exit;
  end;
  TempList:=TstringList.Create;
  Screen.Cursor:=crHourGlass;
  try
    GetFileList(IncludeTrailingPathDelimiter(ASrcDir), '*.*', TempList);
    For i := 0 to templist.count - 1 do
    begin
      try
        if FileExists(TempList[i]) AND not CopyFile(Templist[i], ChangeFilePath(TempList[i], IncludeTrailingPathDelimiter(ADstDir))) then
        Begin
          AErr :=  SysErrorMessage(GetLastError); //20160615 Igor
          exit;
        End;
      except ON E: Exception do //20160615 Igor
        begin
          AErr :=  E.Message;
          exit;
        end;
      end;
    end;
    Result := true;
  finally
    Screen.Cursor:=crDefault;
    TempList.Free;
  end;
End;

function UrlVersionFile: String; //20161116 Igor
Begin
  if SameText('VTDebugT2.exe', ExtractFileName(Application.ExeName)) then Exit; //20210510 Igor
  if SameText('vt2015.exe', ExtractFileName(Application.ExeName)) or
     SameText('vtDebug.exe', ExtractFileName(Application.ExeName)) then
    Result := 'http://www.visualtax.com/downloads/vtUpdate/vt2015Versions.xml'
  else
  if SameText('vt2016.exe', ExtractFileName(Application.ExeName)) or
     SameText('vtDebug2016.exe', ExtractFileName(Application.ExeName)) then
    Result := 'http://www.visualtax.com/downloads/vtUpdate/vt2016Versions.xml';
  //20170831  CON
  if SameText('vt2017.exe', ExtractFileName(Application.ExeName)) or
     SameText('vtDebug2017.exe', ExtractFileName(Application.ExeName)) then
    Result := 'http://www.visualtax.com/downloads/vtUpdate/vt2017Versions.xml';
  // 20180830 Igor >>>
  if SameText('vt2018.exe', ExtractFileName(Application.ExeName)) or
     SameText('vtDebug2018.exe', ExtractFileName(Application.ExeName)) then
    Result := 'http://www.visualtax.com/downloads/vtUpdate/vt2018Versions.xml';
  // 20180830 Igor <<<
  // 20190627 Igor >>>
  if SameText('vt2019.exe', ExtractFileName(Application.ExeName)) or
     SameText('vtDebug2019.exe', ExtractFileName(Application.ExeName)) then
    Result := 'http://www.visualtax.com/downloads/vtUpdate/vt2019Versions.xml';
  // 20190627 Igor <<<
  // 20200611 Igor >>>
  if SameText('vt2020.exe', ExtractFileName(Application.ExeName)) or
     SameText('vtDebug2020.exe', ExtractFileName(Application.ExeName)) or
     SameText('vtClient2020.exe', ExtractFileName(Application.ExeName)) then //20210118 Igor
    Result := 'http://www.visualtax.com/downloads/vtUpdate/vt2020Versions.xml';
  // 20200611 Igor <<<
  // 20210820 Igor >>>
  if SameText('vt2021.exe', ExtractFileName(Application.ExeName)) or
     SameText('vtDebug2021.exe', ExtractFileName(Application.ExeName)) or
     SameText('vtClient2021.exe', ExtractFileName(Application.ExeName)) then
    Result := 'http://www.visualtax.com/downloads/vtUpdate/vt2021Versions.xml';
  // 20210820 Igor <<<
  // 20220801 Igor >>>
  if SameText('VT2023.exe', ExtractFileName(Application.ExeName)) or
     SameText('VTDebug2023.exe', ExtractFileName(Application.ExeName)) or
     SameText('vtClient2023.exe', ExtractFileName(Application.ExeName)) then //20210118 Igor
    Result := 'http://www.visualtax.com/downloads/vtUpdate/VT2023Versions.xml';
  //20210210 Igor >>>
  //20240906 Igor >>>
  if SameText('VT2024.exe', ExtractFileName(Application.ExeName)) or
     SameText('VTDebug2024.exe', ExtractFileName(Application.ExeName)) or
     SameText('vtClient2024.exe', ExtractFileName(Application.ExeName)) then
    Result := 'http://www.visualtax.com/downloads/vtUpdate/VT2024Versions.xml';
  //20240906 Igor <<<
  //20250818 Igor >>>
  if SameText('VT2025.exe', ExtractFileName(Application.ExeName)) or
     SameText('VTDebug2025.exe', ExtractFileName(Application.ExeName)) or
     SameText('vtClient2025.exe', ExtractFileName(Application.ExeName)) then
    Result := 'http://www.visualtax.com/downloads/vtUpdate/VT2025Versions.xml';
  //20250818 Igor <<<
  //20260826 Alex >>>
  if SameText('VT2026.exe', ExtractFileName(Application.ExeName)) or
     SameText('VTDebug2026.exe', ExtractFileName(Application.ExeName)) or
     SameText('vtClient2026.exe', ExtractFileName(Application.ExeName)) then
    Result := 'http://www.visualtax.com/downloads/vtUpdate/VT2026Versions.xml';
  //20260826 Alex <<<
  Result := ReplaceStr(Result, 'vtUpdate/VT', 'vtUpdate/vt'); // fix letter case for website, it should be the same
  if Result.IsEmpty then
    ShowMessage('UrlVersion file is not defined');
  //20210210 Igor <<<
end;

function RecentRFlName: string; //20170112 Igor
begin
  if CurrentApp.LicenseLevel in anyMulti then
    Result := 'Recent - ' + User.UserName + '.txt'
  else
    Result := 'Recent.txt';
end;

function RecentFlName: string;  //20170112 Igor
begin
  Result := RecentRFlName;
end;

function UserName: string; //20170112 Igor
begin
  Result := User.UserName;
  //20190222 Igor >>>
  if SameText(Result, '') then
    Result := '-';
  //20190222 Igor <<<
end;

function LoginName: string; //20170112 Igor
begin
  Result := User.UserName;
end;

function UserId: string; //20170112 Igor
begin
  Result := User.UserName;
end;

//20170609 Igor >>>
procedure CheckTableFieldsNotNull(ARetNo: Integer; AFormName, ATableName: String;
  ATableNo: Integer; ANotNullFields: TIntArr);
var
  FormData: TFormData;
  LastDataCellID, CellID, ColumnID, RowID, AbsoluteElementID: Integer;
begin
  FormData := RetList[ARetNo].Form[AFormName];
  LastDataCellID := High(FormData.Dyn[ATableNo]) - FormData.FormDataRec.BoxesPerRow[ATableNo];
    {The last line is empty always.}
  for ColumnID := Low(ANotNullFields) to High(ANotNullFields) do
  begin
    CellID := ANotNullFields[ColumnID];
    RowID := 1;
    while CellID <= LastDataCellID do
    begin
      AbsoluteElementID := (ArrayMul * ATableNo) + CellID;
      if FormData.Elms[AbsoluteElementID].IsEmpty then
      begin
        SaveDiagnostic(ARetNo, AFormName, AbsoluteElementID,
         FORMAT('E-%s. Table "%s" must have a value in the cell [C:%d, R:%d]', //20170711 CON
          //FORMAT('E-%s. Table "%s" contains an empty value in the cell [C:%d, R:%d],'+' which is required to be filled.',
                [AFormName, ATableName, ANotNullFields[ColumnID], RowID]));
      end;
      CellID := CellID + FormData.FormDataRec.BoxesPerRow[ATableNo];
      Inc(RowID);
    end;
  end;
end;

procedure CheckTableFieldsUnique(ARetNo: Integer;  AFormName, ATableName: String;
  ATableNo: Integer; AUniqueFields: TIntArrOfIntArr);
var
  FormData: TFormData;
  IndexFields: TIntArr;
  RowCount, IndexID, LastDataCellID, ColumnID, RowID, RowID2, AbsoluteElementID: Integer;
  IndexData: TArray<String>;
  RowEqual: Boolean;
  DupRows, CheckedRows: TArray<Integer>;
  S, S2: String;
  function RowChecked(ARowID: Integer): Boolean;
  var
    X: Integer;
  begin
    for X := Low(CheckedRows) to High(CheckedRows) do
      if CheckedRows[X] = ARowID then
        Exit(True);
    Result := False;
  end;
begin
  FormData := RetList[ARetNo].Form[AFormName];
  LastDataCellID := High(FormData.Dyn[ATableNo]) - FormData.FormDataRec.BoxesPerRow[ATableNo];
    {The last line is empty always.}
  RowCount := LastDataCellID div FormData.FormDataRec.BoxesPerRow[ATableNo];
  for IndexID := Low(AUniqueFields) to High(AUniqueFields) do
  begin
    SetLength(CheckedRows, 0);
    IndexFields := AUniqueFields[IndexID];
    RowID := 1;
    while RowID < RowCount do
    begin
      if RowChecked(RowID) then
      begin
        inc(RowID);
        Continue;
      end;
      SetLength(DupRows, 0);
      SetLength(IndexData, length(IndexFields));
      for ColumnID := Low(IndexFields) to High(IndexFields) do
      begin
        AbsoluteElementID := (ArrayMul * ATableNo)
          + ((RowID - 1) * FormData.FormDataRec.BoxesPerRow[ATableNo])
          + IndexFields[ColumnID];
        IndexData[ColumnID] := FormData.Elms[AbsoluteElementID];
      end;
      RowID2 := RowID + 1;
      RowEqual := False;
      while RowID2 <= RowCount do
      begin
        RowEqual := True;
        for ColumnID := Low(IndexFields) to High(IndexFields) do
        begin
          AbsoluteElementID := (ArrayMul * ATableNo)
            + ((RowID2 - 1) * FormData.FormDataRec.BoxesPerRow[ATableNo])
            + IndexFields[ColumnID];
          RowEqual := IndexData[ColumnID].Equals(FormData.Elms[AbsoluteElementID]);
          if not RowEqual then
            Break;
        end;
        if RowEqual then
        begin
          if Length(DupRows) = 0 then
          begin
            SetLength(DupRows, 1);
            DupRows[0] := RowID;
          end;
          SetLength(DupRows, length(DupRows) + 1);
          DupRows[length(DupRows) - 1] := RowID2;
        end;
        inc(RowID2);
      end;
      if length(DupRows) > 0 then
      begin
        AbsoluteElementID := (ArrayMul * ATableNo)
          + ((RowID - 1) * FormData.FormDataRec.BoxesPerRow[ATableNo])
          + IndexFields[Low(IndexFields)];
        S := '';
        for ColumnID := Low(DupRows) to High(DupRows) do
        begin
          SetLength(CheckedRows, length(CheckedRows) + 1);
          CheckedRows[length(CheckedRows) - 1] := DupRows[ColumnID];
          S := S + DupRows[ColumnID].ToString + ', ';
        end;
        System.Delete(S, length(S) - 1, 2);
        S2 := '';
        for ColumnID := Low(IndexFields) to High(IndexFields) do
          S2 := S2 + IndexFields[ColumnID].ToString + ', ';
        System.Delete(S2, length(S2) - 1, 2);

        SaveDiagnostic(ARetNo, AFormName,
          AbsoluteElementID,
          FORMAT('E-%s. Table "%s" contains duplicate data in rows (%s) for column(s) <%s>.',
                [AFormName, ATableName, S, S2]));

      end;
      Inc(RowID);
    end;
  end;
end;

procedure CheckFormTable(ARetNo: Integer;  AFormName, ATableName: String;
  ATableNo: Integer; ANotNullFields: TIntArr;
  AUniqueFields: TIntArrOfIntArr);
begin
  CheckTableFieldsNotNull(ARetNo, AFormName, ATableName, ATableNo, ANotNullFields);
  CheckTableFieldsUnique(ARetNo, AFormName, ATableName, ATableNo, AUniqueFields);
end;
//20170609 Igor <<<

end.
