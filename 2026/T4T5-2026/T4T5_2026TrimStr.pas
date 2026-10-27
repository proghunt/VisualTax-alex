unit T4T5_2026TrimStr;
// updated to 2014-07-28
{$B-}

interface

uses SysUtils, FileCtrl, WinTypes, WinProcs, Messages, Classes, Graphics,
  Controls,
  ShellAPi, Forms, StdCtrls, Dialogs, DBctrls, ExtCtrls, Printers, DB,
  T4T5_2026Declare, IniFiles, ClipBrd, Registry, ComCtrls, vtEditBox, vtLabel,
  vtShape,
  EkRtf, ekbasereport, ekfunc, vtMulti,
  uADCompClient, // 20150919 Igor

  rxRichEd; // 20160819 Igor (Must be last)

{ Const }
{ Space = #$20; }


Function CalcCpp2(EmplIncome:Real):Real; //20250122
Function IsReadyForEfile(RetNo:Integer;SlipType:String):Boolean; //20180106
Function IsAlreadyEfiled(RetNo:Integer;SlipType:String):Boolean;
Function TotBox(RetNo: Integer; BoxId: String): Real;
Function IsFormMultiInst(Frm: String): Boolean;  //20171230
//Function FindDuplicateSinFNo(RetNo:Integer;SlipName:String;Sin:String):Integer; //20171228
Function CountSlips(RetNo: Integer;SlipName:String): Integer; //20171210
Function RoundToTwo(x:Real):Real;  //20170910

Procedure RecalcAllSlips(RetNo:Integer;SlipName:String);

//20170902
Function ValidPostal(Country:String;PostCode:String):Boolean;
Function ValidateBusNo(S:string):Boolean;
Function ValidateT5Filer(S:string):Boolean;

Function GetYearEnd(RetNo:Integer):String;  //20170721
function LicenseLevel: eLicenseLevel;
function LicenseName: string;
Function IsEnterpriseVersion: Boolean; //20231211 Igor

Procedure RelocateCharityForms(RetNo: Integer);
Function CopyAForm(FromRetNo: Integer; FromFormName: string; ToRetNo: Integer;
  ToFormName: string): Integer;
Function ConvertFNameToCombined(FName: String): String;
Function ConvertElmNoToCombined(OldFName: String; Elm: Integer;
  IncrElmList: TStringList): Integer;

Function GetHighestT3SuplInstance(RetNo: Integer): Integer;
Function AnyCorpsInT3Slips(RetNo: Integer): Boolean;
Procedure RemoveEmptyInstances(RetNo: Integer; FName: String; Elms: Integer);
function ColumnSortAscending(List: TStringList; Index1, Index2: Integer)
  : Integer; // 20120310

{$IFDEF OLDdynamic}
// dynamic array routines
Function DynamicRowHasData(RetNo: Integer; FName: String; ArrayNo: Integer;
  RowNo: Integer; BoxesPerRow: Integer): Boolean;
Function IsElmDynamic(FieldId: Integer): Boolean;
Function FetchElmDynamic(RNo: Integer; FName: string; Elm: Integer): string;
Function FetchElmFNoDynamic(RNo: Integer; FNo: Integer; Elm: Integer): string;
// 20101217  //bring the value
Procedure StoreElmDynamic(RNo: Integer; FNo: Integer; Elm: Integer;
  Valu: String); // store the value in dynamic array
Function GetNumberOfDynamicRows(RetNo: Integer; FName: String;
  FirstFieldId: Integer; BoxesPerRow: Integer): Integer;
// how many rows completed
Function IsFormHavingDynamicData(RetNo: Integer; FNo: Integer): Boolean;
// deternine if form has dynamic table arrays
Procedure StoreElm(RNo: Integer; FNo: Integer; Elm: Integer; Valu: String);
Function NewDBStructure: Boolean;
{$ELSE}
Function DynamicRowHasData(RetNo: Integer; FName: String; ElmNo: Integer)
  : Boolean; overload;
{$ENDIF}
Function GetDynamicRowFromFieldId(FieldId: Integer; BoxesPerRow: Integer)
  : Integer; // 20120108

// autos and AssetsB related
Function ValidPhoneNo(s: String): Boolean;
Function AdvanceYear(ThisYear: String): String;
Procedure OpenUsedForms(RetNo: Integer);
//Procedure PopulateT5018G(RetNo: Integer);
Function YYYY_MM_DDToMMDDYYYY(InputDate: String): string;
// Function YYYY_mm_ddToMMDDYYYY(InputDate:String):string;
Procedure UpdateThisFormDataIndicator(RetNo: Integer; FName: String);
Function IsSharedStatement(RetNo: Integer; Stmt: String): Boolean;


Function AdvanceYearEnd(ThisYearEnd: String): String;
Function ValidBusNumber(RetNo: Integer; Bn: String): Boolean;
//Function MiddleR(x, y, z: Real): Real; //20170621 Igor
Function PrintAListing(FileNm, Hdr1, Hdr2, Hdr3: String): Boolean;
Function WhichTaxForm(RetNo: Integer; ShortPrv: string): String;
Function GetLongestLengthItem(SomeList: TStringList): Integer;
function IsLandscape(FName: String): Boolean;
function GetFileList(FDirectory, Filter: TFileName): TStringList;
Procedure ConvertCfgToOptionsFile(CfgTbl: TDataSet);
Function IsExactlyInList(Astring: String; SomeList: TStringList): Integer;
Procedure IsAnyWhereInList(Astring: String; AList, ResultsList: TStrings);
Function IsOkToOpenReturn(DataDir: String; FlName: String; Sin: String)
  : Boolean;
Function CreateDataDirectory(Appdir: string; DataDir: string): Integer;
// Function IsEFiled(RetNo:Integer):Boolean;
Function CountDBRecords: Integer;
Function CountErrorType(AuditList: TStringList; Category: String): Integer;
Function IsInMostRecentReturns(FlName: String;
  MostRecentList: TStringList): Integer;
Function EditDate(s: String; MnYear, MxYear: Integer): Boolean;
Function EditT3Date(s: String; MxYear: Integer): Boolean;
Function GetFldTapeFormNo(RetNo: Integer;
  RefFormName, RefFieldId: String): Integer;
Function GetEmptyInstance(RetNo: Integer; FormName: String): Integer;
Function ReformatSin(s: string): String;
Function IsTrLoaded: Boolean;
Function InitDataBase(Appdir: string; DataDir: string): Boolean;
// Function ExceedsMaxReturnsAllowed:Boolean; -> uFeatures
Procedure LinkToTR(SearchItem: String);
Procedure LoadTr(TrFolder: String);
Function GetTrHandle: HWND;
Function GetTrFolder: String;
Function GetAdminPswrd(UserName: string): String;
procedure ConvertMostRecentFiles; // 20230116 Igor
Procedure InitMostRecentFiles(HowMany: Integer);
Procedure UpdateMostRecentFiles(RetNo: Integer; Dir, FlName, Sin: String);
Function FindWord(ThisWord, Ln: String): Integer;
Procedure InitPredictiveFiles;
Function PrintLabels(const ARetNo: Integer; ATbl: string): Boolean; //20171226 igor
Procedure PrintALabel(LabelPosX, LabelPosY: Integer;
  Line1, Line2, Line3, Line4, Line5: String);
Procedure FixAProperty;
Function GetFormRlNm(FName: String): String;
// Procedure BuildHistoryData(RetNo:Integer;FullFlName:String;K:Integer);
Function IncrString(s: String; ByValue: Integer): String;

procedure ModifyAllForms;
function ModifyFormOrText(FileToConvertFrom: string;
  ConversionType: String): Boolean;

Function LandscapeFormsInFEDReturn(RetNo: Integer): Boolean;
Function LandscapeFormsInONTReturn(RetNo: Integer): Boolean;
Function LandscapeFormsInALBReturn(RetNo: Integer): Boolean;

Function GetFNoOfFirstInstance(FName: String; FNo: Integer): Integer;
Function GetTrTopicFromLineRef(FormName: String; FieldId: Integer): String;
procedure PrintAtAngle(AText: String; ACanvas: TCanvas; Xpos: Integer;
  YPos: Integer; FontSize: Integer; AtAngle: Integer);
Procedure InsertKeyWToDataDict(FormName: String; AnEditBox: TvtEdit);
Function GetFldMemFormNo(RetNo: Integer;
  RefFormName, RefFieldId: String): Integer;
Procedure GetLoginNames(TempList: TStrings);
Procedure UpdateLoginNames(Nm: String);
procedure ReplaceRtfText(ARichEdit: TRichEdit; InSearch, InReplace: string);
Procedure ConvertOldLetter(ARichEdit: TRichEdit);
Function CleanUpKeyW(KeyW: String): String;
Function IsConditionalRtfStatement(KeyW: String): Boolean;
Procedure GetDelimiterPositionsInRtf(ARichEdit: TRichEdit; SearchText: string;
  DelimList: TStrings);
Function GetPrintSequence(FName: string): String;
Function FirstTimeClient(RetNo: Integer): Boolean;
Procedure ReadTheValue(TempList: TStringList; FrmNm: String;
  Elm1, Elm2: Integer; Var Val1: String; Var Val2: String);
Procedure AddDisplayFormatToRtf(ARichEdit: TRichEdit; KeyWList: TStringList);
Procedure ReplaceRtfDelimiters(ARichEdit: TRichEdit;
  FromDelim, ToDelim: String);
procedure InsertBackFunction(ARichEdit: TRichEdit;
  InSearch, InSecondSearch, InReplace: string);
function ConvertToProper(sBuffer: string): string;
Function GetKeyWListFromRichEdit(ARichEdit: TRichEdit;
  KeyWList: TStrings): Boolean;
Function GetFormHeight(FName: string): Integer;
function GetFormNumberFields(FNo: Integer): Integer;
function GetMaxFormNumber: Integer;
Function GetCopiesToPrint(FName: string; TemplForms: TStringList;
  TemplCopies: TStringList): String;
// Function GetPrintSequence(FName:string):String;
Function IncludeFormInPrint(RetNo: Integer; FNm: String): Boolean;

Function GetReturnPsw(DataDir, FlName: string): String;
function CheckReturnPsw(DataDir, FlName: string): Integer;
function CheckReturnAndPsw(DataDir, FlName: string): Boolean;
Procedure CreateDefaultDataDirectories;
Procedure ExtractSectionLabels(FName: String; LblSectList: TStringList;
  SomeList: TStrings);
function GetInterpetedRichEdit(RetNo: Integer; LetterName: String;
  ARichEdit: TRichEdit): Boolean; // 20160819 Igor
Function GetLetterFileName(RetNo: Integer; FName: String): String;
Function LinkToSelf(InitialFormName: String; TargetFormName: String): Boolean;
Procedure GetFrmDataListFromFullDataList(FrmNm: String; DataList: TStringList;
  FrmDataList: TStrings);
// Function FormatRSIDollarAmount(FrmNm:String;s: string;How:Integer): string;
Procedure GetElmsInError(RetNo: Integer; FName: String);
Function IsFieldInElmsInError(s: String; AList: TStringList): Integer;
function GetFormAbrevNameWithNoInst(FormNo: Integer): String;
Function FieldHasAddingTape(RetNo: Integer; FName: String;
  Elm: Integer): Boolean;
// Procedure  BuildSuperEntry(Value:String;FlName:String);
// Function IsInvoiceLocked(RetNo:Integer):Boolean;
Function GetDfmFormsDir: String;
Function IsFormAClientLetter(FName: String): Boolean;
Function GetAnyPathMoreThan8Chars(Dir: String): String;
Function ValidEMail(s: String): Boolean;
Function RealNumeric(s: string): Boolean;
Function CopyMoveReturn(CopyOrMove: String; FromDir: String; ToDir: String;
  FlName: String): Boolean;
Procedure LoadEditBoxProperties;
Procedure RemoveReturnPsw(RetNo: Integer);
Function StripInstNo(FormName: String): string;
// Procedure GetFormsToPrint(RetNo:integer;Template:string;var FormsToPrint:TstringList);
Procedure ResortFormsToPrint(FormsToPrint: TStringList);
Function GetPrintTemplate: string;
Function AllowedToFullPrint(RetNo: Integer): Boolean;
Function CreateNewDataDir: String;
// Function YouKnowTheAdminPassword:Boolean;
Function AllowedToFormPrint(RetNo: Integer; FormName: String): Boolean;
// Function IsOkToOpenReturn(DataDir:String;FlName:String;Sin:String):Boolean;
// function GetWinHandleOfRetNo(RetNo:Integer):HWND;
Procedure StoreReturnPsw(RetNo: Integer; RetPsw: String);
// Procedure IsAnyWhereInList(Astring:String; AList: TstringList; Var ResultsList:TstringList);
// Function IsExactlyInList(Astring:String; SomeList: TstringList):Integer;
// Function ValidShortProvince(s:string):Boolean;
// Function IsFormTheDefaultSearch:Boolean;
// Procedure ConvertCfgToOptionsFile(CfgTbl:TTable);
Procedure InitOptions;
Procedure SetDefaultOptions; // 20160523 Igor //20160623 Igor
Function GetDefaultOptionsValue(const AOptionsName: String): String;
// 20160627 Igor
function GetDefaultOptions: TStringList; // 20160627 Igor
function GetOptionsCaption(AOptionsName: String): String; // 20160627 Igor
function HaveOptions(AOptionsName: String): Boolean; //20170112 Igor
Procedure LoadOptionsFileToMem;
Function GetOptionValue(FieldNm: String; TempList: TStringList): String;
Procedure SaveSingleOption(FieldNm, Value: string;
  AOptionsFileName: String = ''); // 20160627 Igor
Procedure SaveOptionValue(FieldNm: String; Value: String;
  TempList: TStringList);
// Function BooleanToString(ABoolean:Boolean):String;
// Function StringToBoolean(AString:String):Boolean;
// function GetFileList(FDirectory, Filter: TFileName): TStringList;
Function IncrementlastBackUpDir(LastBackUp: String): String;
Function GetPGMPsw: String;
Procedure SavePGMPsw(PGMPsw: String);
Function GetDefaultScaling: Integer;
// ---------------------------------------------------------------------

//20170721
Function MkClientLetterName(RetNo:Integer):String;
Function CountMultipleInstances(RetNo: Integer; NonInstFormName: String)
  : Integer; { No Instance }
Function ConnectToWeb(Url: String): Boolean;
Procedure BuildUpdateXmlForWeb(UpdFileName: String);
Procedure SetUpdateFrequency(Freq: Integer);
Function GetUpdateFrequency: Integer;
Function TimeToCheckUpdates: Boolean;
Function GetLastUpdCheck: String;
procedure Checkupdates(WindowHandle: Word; AppTitle: String);

Function GetShowOpenedFormsIndicator: Boolean;
Function IsFirstPageOfForm(FormName: String): Boolean;
Procedure ParseWords(s: String; Delim: String; WList: TStrings);
procedure ShowPdf(PgmPath, PgmFile: String);
Function ValidCharBn(s: String): Boolean;
Procedure AutoFormatDate(Var Value: String);
//Procedure AutoFormatT5013Date(Var Value: String);
Function PrintVerticalSeparator(FName: String; Elm: Integer): Boolean;
Function GetEmptyT3BoxNo(RetNo, FNo: Integer; FromElm, ToElm, ByElm: Integer): Integer;
Procedure ClearFields(RetNo, FNo, Ndx1, Ndx2: Integer);
Function AllowPrinting(RetNo: Integer): Boolean;
Function CountResidentSlips(RetNo: Integer): Integer;
Function CountPreferredBeneficiaries(RetNo: Integer): Integer;
Function CountNonResidentBeneficiaries(RetNo: Integer): Integer;
Function GetTotalPreferredAllocation(RetNo: Integer): Real;
Function FetchADate: String;
Function GetPositionInList(s: String; AlistBox: TFileListBox): Integer;
Function GetFootValue(RetNo, FNo: Integer; Txt: String): Real;
Function GetClientLettersDir: String;
Function ShadePenniesOnly(FName: String; ElmNo: Integer): Boolean;
Function PenniesShouldBeShaded(FName: String; Elm: Integer): Boolean;
Function ShouldBeShaded(FName: String; Elm: Integer): Boolean;
Function SubstituteForm(RetNo: Integer; FrmNm: String): String;
Procedure CopySubstitute(RetNo: Integer; FromFrm, ToFrm: String);
Function CountT5018Slips(RetNo: Integer): Integer;
function GetFormAbrevName(FormNo: Integer): String;
// procedure ExecuteForm(AFormClass: TFormClass); //20160612 Igor (duplicate vtCommon)
{ Function ValidateKey(ThisKey:String):Boolean; }
Function GetCharityYE(RetNo: Integer): String;
Function GetPrevYearEnd(ThisYearEnd: String; No: Integer): String;
Function IsCharityForm(FrmName: String): Boolean;
Function GetCharityBN(RetNo: Integer): String;
Function GetHowToFormat(FrmName: String; Elm: Integer): Integer;
// Function GetHowToFormat(FName:String;Elm:Integer):Integer;
// Function FormatAmount(s: string;How:Integer): string;
Function FormatAmount(s: string; VerticalSeparator: Boolean): string; overload; //20170123 Igor
Function FormatAmount(FormName, s: string; VerticalSeparator: Integer): string; overload; //20170123 Igor

// Function FormatAmount(s: string;VerticalSeparator:Boolean): string;
Function FormatTwoDecimals(FormName, s: string): string;
Function IncrementYear(YYYYMMDD: String): String;
Procedure CFZeroAmounts;
Procedure CFReformatLastYearData(RetNo: Integer);
Procedure CFFilterLastYrAndStore(RetNo: Integer; FormNm: String; FNo: Integer;
  Elm: Integer; Valu: String);
// procedure OnestepCom;
// Procedure WriteFileForEFCom;
{ Procedure GetLicenseLevel; }
Function MakeDataDirectory(DataDir: string): Integer;
Function CopyBlankDBFS(Appdir: string; DataDir: string): Boolean;
Function InQuotes(s: String): String;

Function GetWinIniString(IniFileName: String; Sect: String;
  Ident: String): String;
Function GetFormType(FormName: string): String;
Function RemoveSpaces(s: string): string;

Procedure CopySlipToDestForm(RetNo: Integer; FromForm: string; DestFNo: Integer;
  TopOrBottom: Integer; DestFormName: String);
Procedure CopyNR4SlipToDestForm(RetNo: Integer; FromForm: string;
  DestFNo: Integer; TopOrBottom: Integer; DestFormName: String);
Function RemoveCommas(s: string): String;
Function ValidAccount(Account: string): Boolean;
Function GetTrustYear(RetNo: Integer): String;
Function GetPrvYear(ThisYear: String; No: Integer): String;
Function ReformatAccount(s: string; PrefixLtr: string): String;
Function GetFormFee(FormName: String; Qty: Integer): Real;
Function GetTotalFee(RetNo: Integer): Real;
Procedure GetListInvoiceForms(RetNo: Integer; Frms, HowMany: TStrings);
Function CountPagesGenerated(RetNo: Integer): Integer;
// Function DDMMYYYYToMMDDYYYY(DDMMYYYY:String):string;
Procedure FillHeader(RetNo, FormNo, NameElm, AccountElm, YearEndElm: Integer);
Procedure FillPHeader(RetNo, FormNo, NameElm, AccountElm, YearEndElm: Integer);
// partnership
Function MyStrToFloat(Astring: String): Real;
Function GetRetName(RetNo: Integer): String;
Function GetAccountNumber(RetNo: Integer): String;
Function GetNumDays(RetNo: Integer; ADate: String; BfrAftr: string): Integer;
// Function GetNumDays (ADate:String;BfrAftr:string):Integer;

Procedure AllowLinesForLogo(LetterLines: TStrings);
Procedure ExpandTabs(AList: TStrings);
Procedure ResolveConditions(AList: TStrings);
Function InvalidAmountInLetter(s: string): Boolean;
Function IsFormMultiPage(FormName: String): Boolean;
Function MultiPage1(Frm: string; Inst: string; MxPg: Integer): Boolean;
Function MultiPage23(Frm: string; Inst: string; MxPg: Integer): Boolean;
Procedure CountMulties(RetNo: Integer; Frms, HowMany: TStrings);

Function CountKeystrokePoints(RetNo: Integer): Integer;
procedure InitFormsTable;
Procedure InitConstants;

Function ClcR(FieldId: Integer; PgmValue: Real; FormOvrSw: Boolean;
  RetNo: Integer; FormNo: Integer): Real;
// Function EditDate(S:String;MxYear:string):Boolean;
// Function CalcAge(BirthDate: string): Integer;
Function CalcAgeTo(BirthDate: string; ToDate: string): Integer;
//function IsShowFlagIndicator(FName: String; DorP: String): Boolean;
function IsShowHdrIndicator(FName: String): Boolean;
Procedure RemoveLastEmptyLines(TempList: TStrings);
Function ValidateTextLine(Txt: String; Var Cursor_position: Integer;
  Var KeyWLength: Integer): Boolean;
Procedure RemoveEmptyLines(TempList: TStringList);
Procedure LoadLetter(TempList: TStringList; LetterName: String);
procedure InterpretTextLine(Var Txt: String);
Procedure ReplaceKeyWord(Var Txt: String; Cursor_position: Integer;
  KeyWLength: Integer; ReplaceString: String);
procedure ConditionEvaluator(CStr: string; var CCheck: Boolean;
  var error: Boolean);

Procedure ReplaceText(LetterBody: TMemo; Cursor_position: Integer;
  KeyWLength: Byte; ReplaceText: string);
function GetDataDictElmNo(KeyW: String): Integer;
function GetDataDictFormName(KeyW: String): String;
function InDataDict(KeyW: String): Boolean;
Function InsertPenniesDot(s: string): String;
function GetWhiteBoxesIndicator(FName: String): Boolean;
Function TotMultiple(RetNo: Integer; NonInstFormName: String;
  Elm: Integer): Real;
function GetFormName(FormNo: Integer; ARetNo: Integer = 0): String;
function GetFName(AbrevName: String): String;
function GetFormNo(const FormName: String; Check: Boolean = True;
  ARetNo: Integer = 0): Integer; // 20160704 Igor
Procedure UpdateAllDataIndicators(RetNo: Integer);
Procedure InfoOn; { just repaint mdi status panel }
Procedure InfoOff;
Function GetRowFromSlip(RetNo: Integer; FormName: string; Row: Integer;
  ExchRow: Integer; ShareRow: Integer): Real;
Function GetNumbFields(FName: string): Integer;
Function RemovePenniesDot(s: string): String;
Function MakeEFFileName(LicenseLevel: string): string;

Function EditLongPrv(Value: string): Boolean;
{ File i/o }
Function FileNameValid(FlName: string): Boolean;
Function CopyReturn(DataDir: String; FileName: String;
  DestinationDir: string): Boolean;
//Function GetUserProfile(UserName: string): Boolean; //20170112 Igor (Move to TUserConfig)
Procedure ShowOpenReturnFailure(FailCode: Integer; DataDir: String;
  FlName: string);

procedure LoadDataDict;

Procedure ShowHelp(HelpFile: String; Helptopic: string;
  AIsWeb: Boolean = False); // 20160801 Igor

Procedure SwapStrings(S1: string; S2: string);
Function ExtractDecimalPart(s: string): string;
Function ExtractIntegerPart(s: string): string;
Function InsertCommas(s: string): String;

Function GetTrustTypeDescription(TrustType: String): String; // 20160207
Function GetStreetAddress(RetNo: Integer): String; // 20160222 Igor
function ImportOneReturn(ADS: TDataSet; ASrcDir, ADstDir: String;
  out AErr: String; AOverride: Boolean): Boolean; // 20160617 Igor

Function IsValidLastYearPgmFolder(AShowMessage: Boolean;
  out AErrorMessage: String): Boolean; // 20160629 Igor
function isValidLastYearDataFolder(AShowMessage: Boolean;
  out AErrorMessage: String): Boolean; // 20160629 Igor
procedure InitLastYearFormsTable; // 20160629 Igor
Function GetRenamedFName(FName: String): String; // 20160629 Igor
function GetLastYearFormNo(FormName: String): Integer;
function GetLastYearFormName(FormNo: Integer): String;
Function ShowUnconvertedLastYear(RNo: Integer): Boolean; // 20160629 Igor
function GetLastYearFile(ARetNo: Integer): String; // 20160701 Igor
procedure SetLastYearFile(const ARetNo: Integer; AValue: String);
// 20160701 Igor

procedure ClearDigitT4(ARetNo, AFormNo: integer); //20170123 Igor
procedure ClearDigitT4A(ARetNo, AFormNo: integer); //20170123 Igor
procedure ClearDigitT5(ARetNo, AFormNo: integer); //20170123 Igor

Function ValidateFootNote(Cd: String; Amt: Real): Boolean;//20170216 Igor
function ValidateSlips(ARetNo: Integer; ASlipName: String): String;//20170216 Igor
function ValidateAllT4Slips(ARetNo: Integer): String; //20170216 Igor
function ValidateAllT4ASlips(ARetNo: Integer): String; //20170216 Igor
function ValidateAllT5Slips(ARetNo: Integer): String; //20170216 Igor
function IsPhoneFormat(AValue: String): Boolean; //20170216 Igor
Function FixPostal(s: String): String; //20170216 Igor
Function GetEmailAddr: String; //20170216 Igor
Procedure SummarizeT4Slips(ARetNo: Integer; Var T4Sum: TT4Sum); //20170216 Igor
Procedure SummarizeT4ASlips(ARetNo: Integer; Var T4ASum: TT4ASum); //20170217 Igor
Procedure GetFootCodeTotal(ARetNo: Integer; ARec: TFRec; ACd: String; Var TotBox: Real); //20170217 Igor
Procedure GetTotBox101(ARetNo: Integer; ARec: TFRec; Var TotOther: Real); //20170217 Igor

Procedure SummarizeT5Slips(ARetNo: Integer; Var T5Sum: TT5Sum); //20170217 Igor
function QuickFormFind(RetNo: integer; AFormName: String): Boolean; //20170418 Igor

implementation

uses
  HtmlHelp,
  vtCommon, vtDialogs, vtDynData,
  T4T5_2026,
  // T4T5_2026PopList,
  T4T5_2026Calc,
  T4T5_2026Common, T4T5_2026Common2, T4T5_2026Main, T4T5_2026ChildWinNew,
  T4T5_2026ReturnPassword,// T4T5_2026CalcBus,
  vtTrimStr, vtShared, vtDataBase, // 20150919 Igor
  fConvertToMultiApp, // 20160623
  RegularExpressions; //20170216 Igor

const

  c_DefDataDir = '{DataDir}';//20171204 Igor
  //20170112 Igor >>>
  //20250116 Added RepId
   OptionsArray: Array [0 .. 87, 0 .. 3] of string =
  //OptionsArray: Array [0 .. 86, 0 .. 3] of string =  //20161107 Igor
  // Options Name        Default Value                 Caption    Fill Default
    (('Dir_Cur', c_DefDataDir + '\Data', 'Current Directory', 'X'), { 0 }//20171204 Igor
    ('BackUpFrequency', '7', 'Remind me to backup data every X deys', 'X'),
    ('BackupDir', c_DefDataDir + '\BackUp', 'Default Backup directory', 'X'),//20171204 Igor
    ('LastBackupDir', '', 'Most recent back up folder', 'X'),
    ('Dir_Deflt', c_DefDataDir + '\Data', 'Default Directory', 'X'),//20171204 Igor
    ('Dir_LastYr', '', 'Last year''s data (For ROLL-OVER purposes) * Data located in this directory:', 'X'),
    ('Dir_PgmLastYr', '', 'PROGRAM dir last year', 'X'),
    ('Dir_DBFData', '', 'Data directory of the T4T5-2017 production data prior to Multi-App. Typically enter  C:\T4T5-2017\data. To be used as the source to import data into the Multi-App version', 'X'),
    ('Prp_Name', '', 'Preparer Identification: Company Name', ''),
    ('Prp_ContactName', '', 'Preparer Identification: Contact Name', ''),
    ('Prp_TransmitterNo', '', 'Transmitter Number', ''), { 10 }
    ('Prp_TransmitterType', '', 'Transmitter type', ''),
    ('Prn_LMargin', '0.75', 'Client Letters Print Margins: Left margin in inches', 'X'), // 20160721 Igor
    ('Prn_RMargin', '0.5', 'Client Letters Print Margins: Right margin in inches', 'X'), // 20160721 Igor
    ('Prn_FontIncr', '1', 'Printing Font Size Increment: Increment by (0 or 1)', 'X'),
    ('Prp_EMail', '', 'Preparer Identification: Email Address', ''),
    ('Prp_BusNo', '', 'Preparer Identification: Business No', ''),
    ('Prp_RepId', '', 'PRP_RepId', ''),   //20250116
    ('Reviewer_EMail', '', 'Reviewer Identification (i.e. Supervisor or other Tax Advisor): Email Address', ''),
    ('Reviewer_Name', '', 'Reviewer Identification (i.e. Supervisor or other Tax Advisor): Name', ''),
    ('Reviewer_Area', '', 'Reviewer Identification (i.e. Supervisor or other Tax Advisor): Tel. Area', ''),
    ('Reviewer_Tel', '', 'Reviewer Identification (i.e. Supervisor or other Tax Advisor): Tel. Number', ''), { 20 }
    ('Prp_Street', '', 'Preparer Identification: Street', ''),
    ('Prp_City', '', 'Preparer Identification: City', ''),
    ('Prp_Prov', '', 'Preparer Identification: Province', ''),
    ('Prp_Postal', '', 'Preparer Identification: Postal', ''),
    ('Prp_Countr', '', 'Preparer Identification: Country', ''),
    ('Prp_Area', '', 'Preparer Identification: Tel. Area', ''),
    ('Prp_Tel', '', 'Preparer Identification: Tel. Number', ''),
    ('Prp_FxArea', '', 'Preparer Identification: Fax. Area', ''),
    ('Prp_Fax', '', 'Preparer Identification: Fax. Number', ''),
    ('Prp_GSTNo', '', 'GST No', ''), { 30 }
    ('Prp_Bill', '2', 'Default Billing Option', 'X'),
    ('Prp_VSFee', '30', 'Flat Fees ($): Very small', 'X'),
    ('Prp_SFee', '50', 'Flat Fees ($): Small', 'X'),
    ('Prp_AFee', '70', 'Flat Fees ($): Average', 'X'),
    ('Prp_CFee', '100', 'Flat Fees ($): Complex', 'X'),
    ('Prp_VCFee', '150', 'Flat Fees ($): Very Complex', 'X'),
    ('Prp_Hour', '60', 'Charge per hour ($)', 'X'),
    ('Prp_Dates', '', 'Signature date: If checked, the program will automatically fill Signature dates with today''s date', ''),
    ('Nfl_Prov', 'ON', 'Default values for tax returns: Default Province', 'X'),
    ('Nfl_City', 'TORONTO', 'Default values for tax returns: Default City', 'X'), { 40 }
    ('Capitalization', 'UpperCase', 'Name/address: Convert to', 'X'),
    ('Prn_NameH', 'X', 'Print headers on tax forms: Client Name on Headings', 'X'),
    ('Prn_SinH', 'X', 'Print headers on tax forms: B/N on Headings', 'X'),
    ('Prn_DateH', 'X', 'Print headers on tax forms: Date on Headings', 'X'),
    ('Prn_Disclm', '', 'Disclaimer above signature on Page 4 (Leave it blank, if not required)', ''),
    ('Opr_Close', 'X', 'Navigation and warnings Esc key', 'X'),
    ('Opr_GstHst', '', 'GST/HST rate', ''),
    ('UseFastPrint', '', 'Full return printing: Use Fast Print method', 'X'),
    ('UseProperName', 'X', 'Client Letters: Show proper format (Capitalize only first letter)  in Name and Address', 'X'),
    ('NoTypeAhead', '', 'DO NOT Use the Predictive Typing feature (Super Entry)', 'X'), { 50 }
    ('ShowInvoiceWarning', 'X', 'Invoice: Show warning  if invoice not prepared', 'X'),
    ('UpdateFrequency', '7', ' Internet Updates: Check automaticaly every X deys', 'X'),
    ('InvFoot1', '', 'Invoice footer (Free format text to appear at bottom of Invoice) 1', ''),
    ('InvFoot2', '', 'Invoice footer (Free format text to appear at bottom of Invoice) 2', ''),
    ('InvFoot3', '', 'Invoice footer (Free format text to appear at bottom of Invoice) 3', ''),
    ('InvFoot4', '', 'Invoice footer (Free format text to appear at bottom of Invoice) 4', ''),
    ('InvFoot5', '', 'Invoice footer (Free format text to appear at bottom of Invoice) 5', ''),
    ('ActiveBoxColor', '8421631', 'ActiveBoxColor', 'X'),
    ('DataInBold', '', 'Show data in Bold in all forms', 'X'),
    ('HideMostRecent', '', 'Hide most recent returns', 'X'), { 60 }
    ('ShowUsedForms', 'X', 'Show forms used last time you saved', 'X'),
    ('OpenAtLastForm', 'X', 'If ticked, open at last form used', 'X'),
    ('NoBarCode', '', 'DO NOT Print BarCode', ''),
    ('SingleLoginId', '', 'Log in Name', ''),
    ('RolloverProgram', 'VisualTax', 'Program name used last year...', 'X'),
    ('SkipLogin', '', 'Skip the Login window', ''),
    ('FormZoom', '100', 'Form Size (zoom) in effect', 'X'),
    ('Opr-GstHst', '5', 'GST/HST rate', 'X'),
    ('FirstReturnColor', '16777155', 'First Return Color', 'X'),  { TODO : check }
    ('UseFormSearch', 'X', 'Use Form Search', 'X'), { 70 } { TODO : check }
    ('OtherSlipsButtons', 'X', 'Other Slips Buttons', 'X'), { TODO : check }
    ('T1013AuthorLevel', '2', 'T1013AuthorLevel', 'X'), { TODO : check }
    ('CVSetting', '2', 'CVSetting', 'X'), { TODO : check }
    ('ShowFinWarning', '', 'Show Fin Warning', 'X'), { TODO : check }
    ('ShowConsultantOnInv', '', 'Show Consultant On Inv', 'X'), { TODO : check }
    ('UseCondominiumLine', 'X', 'Use Condominium Line', 'X'), { TODO : check }
    ('RolloverT4T5', 'X', 'RolloverT4T5', 'X'), { TODO : check }
    ('ShowInvoiceEfCharge', 'X', 'Show Invoice Ef Charge', 'X'), { TODO : check }
    ('ShowSaluteWarning', 'X', 'ShowSaluteWarning', 'X'), { TODO : check }
    ('Nfl_Efile', 'X', 'Nfl_Efile', 'X'), { 80 } { TODO : check }
    ('Ef_Method', 'EOL', 'Ef_Method', 'X'), { TODO : check }
    ('Prp_Elect', 'X', 'Prp_Elect', 'X'), { TODO : check }
    ('Prp_EfRepr', 'X', 'Prp_EfRepr', 'X'), { TODO : check }
    ('Nfl_Disced', '1', 'Nfl_Disced', 'X'), { TODO : check }
    ('AutoSeniorDiscount', '', 'Auto Senior Discount', 'X'), { TODO : check }
    ('DiscountForSeniors', '0', 'Discount For Seniors', 'X') { 86 } { TODO : check }

    );


Function GetYearEnd(RetNo:Integer):String;  //20170721
Begin
 Result:='unKnown YearEnd';
End;
//20170112 Igor <<<
Function MyStrToFloat(Astring: String): Real;
begin
  If Astring = '' then
    result := 0
  else
    result := StrToFloat(Astring);
end;


Function MkClientLetterName(RetNo:Integer):String;
Begin
  Result:='?Unknown';
end;


Procedure FillHeader(RetNo, FormNo, NameElm, AccountElm, YearEndElm: Integer);
Begin
  With Ret[RetNo].Frm[FormNo] do
  begin
    Strings[NameElm] := GetRetName(RetNo);
    Strings[AccountElm] := GetAccountNumber(RetNo);
    Strings[YearEndElm] := GetYearEnd(RetNo);
  end;
end;

Procedure FillPHeader(RetNo, FormNo, NameElm, AccountElm, YearEndElm: Integer);
Begin
  If CertificationMode = True then
    exit;
  With Ret[RetNo].Frm[FormNo] do
  begin
    Strings[NameElm] := FetchElm(RetNo, 'T5013FIN', 7);
    Strings[AccountElm] := FetchElm(RetNo, 'T5013FIN', 1);
    Strings[YearEndElm] := FetchElm(RetNo, 'T5013FIN', 39);
  end;
end;

Function GetTotProvTax(RetNo: Integer): Real;
begin
  result := 0;
  If Ret[RetNo].Province = 'ON' then
    result := Vl(FetchElm(RetNo, 'T3ON', 56))
  Else If Ret[RetNo].Province = 'AB' then
    result := Vl(FetchElm(RetNo, 'T3AB', 56))
  Else If Ret[RetNo].Province = 'BC' then
    result := Vl(FetchElm(RetNo, 'T3BC', 64))
  Else If Ret[RetNo].Province = 'MB' then
    result := Vl(FetchElm(RetNo, 'T3MB', 53))
  Else If Ret[RetNo].Province = 'NB' then
    result := Vl(FetchElm(RetNo, 'T3NB', 46))
  Else If Ret[RetNo].Province = 'NS' then
    result := Vl(FetchElm(RetNo, 'T3NS', 49))
  Else If Ret[RetNo].Province = 'NL' then
    result := Vl(FetchElm(RetNo, 'T3NL', 56))
  Else If Ret[RetNo].Province = 'NT' then
    result := Vl(FetchElm(RetNo, 'T3NT', 46))
  Else If Ret[RetNo].Province = 'NU' then
    result := Vl(FetchElm(RetNo, 'T3NU', 46))
  Else If Ret[RetNo].Province = 'PE' then
    result := Vl(FetchElm(RetNo, 'T3PE', 56))
  Else If Ret[RetNo].Province = 'SK' then
    result := Vl(FetchElm(RetNo, 'T3SK', 56))
  Else If Ret[RetNo].Province = 'YT' then
    result := Vl(FetchElm(RetNo, 'T3YT', 46));
end;


Function GetRetName(RetNo: Integer): String; //20161227 Igor
Var
  s: string;
Begin
  result := '(Un-named)';
  s := FetchElm(RetNo, 'EMPL', 1);
  If s > '' then
  begin
    result := Rtrim(s);
    exit;
  end;
end;


Function GetAccountNumber(RetNo: Integer): String;  //20161227 Igor
Var
  s: string;
begin
  result := '';
  s := FetchElm(RetNo, 'EMPL', 19);
  If s > '' then
  begin
    result := Rtrim(s);
    exit;
  end;
end;


Function GetNumDays(RetNo: Integer; ADate: String; BfrAftr: string): Integer;
Var
  I: Integer;
  BegDate, EndDate: string;
Begin
  result := 0;
  Try
    ADate := DMYtoYMD(ADate); { convert to mm/dd/yyyy }
    BegDate := FetchElm(RetNo, 'T3', 10);
    EndDate := FetchElm(RetNo, 'T3', 11);
    If BfrAftr = 'B' then
      result := DateDiffYMD(BegDate, ADate) - 1
    else
      result := DateDiffYMD(ADate, EndDate) - 1;

    If result < 0 then
      result := 0;
    If result > Ret[RetNo].DaysInYear then
      result := Ret[RetNo].DaysInYear;
  except
    on E: Exception do
      MessageDlg('Num of days ' + E.Message, mtError, [mbok], 0);
  end;
End;

Procedure AllowLinesForLogo(LetterLines: TStrings);
Var
  I: Integer;
  TempList: TStringList;
begin
  TempList := TStringList.create;
  // If OptRec.Prn_Logo then For i :=1 to OptRec.Prn_LogoLn do Templist.Add(' ');
  For I := 0 to LetterLines.Count - 1 do
    TempList.Add(LetterLines[I]);
  LetterLines.clear;
  LetterLines.Addstrings(TempList);
  TempList.free;
end;

Function CountPagesGenerated(RetNo: Integer): Integer;
Var
  I: Integer;
begin
  result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If Ret[RetNo].FrmHasData[FRec.FormNo] then
      inc(result);
  end;
end;

//20171210
Function CountSlips(RetNo: Integer;SlipName:String): Integer;
//20171215 Igor>>>
Var
  I, Elm: Integer;
  A: TArray<String>;
  S: string;
begin
  result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = SlipName then
    begin
      A := FRec.DataIndic.Split([',']);
      for S in A do
        if SameText(S, 'Y') and
           Ret[RetNo].FrmHasData[FRec.FormNo] then
        begin
          Inc(result);
          break;
        end
        else
        if TryStrToInt(S, Elm) then
          If FetchElm(RetNo, FRec.FormNo, Elm) <> '' then
          begin
            inc(result);
            Break;
          end;
    end;
  end;
//20171215 Igor<<<
end;

Function CountT5018Slips(RetNo: Integer): Integer;
Var
  I: Integer;
begin
  result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = 'T5018L' then
    begin
      If Vl(FetchElm(RetNo, FRec.FormNo, 2)) > 0 then
        inc(result);
    end;
  end;
end;

Function IsFormMultiPage(FormName: String): Boolean;
Var
  I: Integer;
begin
  result := False;
  I := Length(FormName);
  While I > 0 do
  begin
    If FormName[I] = '_' then
    begin
      result := True;
      exit;
    end;
    Dec(I);
  end;
end;

Procedure GetListInvoiceForms(RetNo: Integer; Frms, HowMany: TStrings);
Var
  I, j: Integer;
begin
  { Count non multi-instance forms }
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If (Ret[RetNo].FrmHasData[FRec.FormNo]) and (Vl(FRec.Fee) > 0) and
      (FRec.FormInst = '') then
    begin
      Frms.Add(FRec.FormName);
      HowMany.Add('1');
    end;
  end; { Flist do }
  { Count multiple forms, add them to the lists }
  CountMulties(RetNo, Frms, HowMany);
end;

Procedure CountMulties(RetNo: Integer; Frms, HowMany: TStrings);
Var
  I, j: Integer;
begin
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If (Ret[RetNo].FrmHasData[FRec.FormNo]) and (Vl(FRec.Fee) > 0) and
      (FRec.FormInst > '') then
    begin
      If IsFormMultiPage(FRec.FormName) then { Multipage }
      begin
        If (RightStr(FRec.FormName, 2) = '_1') and (FRec.FormInst = '#1') then
        begin
          Frms.Add(FRec.FormName);
          HowMany.Add('1');
        end
        else If (RightStr(FRec.FormName, 2) = '_1') and (FRec.FormInst > '#1')
        then
          for j := 0 to Frms.Count - 1 do
            If FRec.FormName = Frms[j] then
              HowMany[j] := IntToStr(StrToInt(HowMany[j]) + 1);
      end
      else { Single Page }
      begin
        If (FRec.FormInst = '#1') then
        begin
          Frms.Add(FRec.FormName);
          HowMany.Add('1');
        end
        else
          for j := 0 to Frms.Count - 1 do
            If FRec.FormName = Frms[j] then
            begin
              HowMany[j] := IntToStr(StrToInt(HowMany[j]) + 1);
            end;
      end; { end single page }
    end; { frm has data }
  end; { Flist do }
end;

Function MultiPage1(Frm: string; Inst: string; MxPg: Integer): Boolean;
{ frm is noninstance }
begin
  result := False;
  If (Inst = '#1') then
    if (RightStr(Frm, 2) = '-1') or (MxPg < 2) then
      result := True;
end;

Function MultiPage23(Frm: string; Inst: string; MxPg: Integer): Boolean;
{ frm is noninstance }
begin
  result := False;
  If (Inst > '#1') then
    if (RightStr(Frm, 2) = '-1') or (MxPg < 2) then
      result := True;
end;

Function CountKeystrokePoints(RetNo: Integer): Integer;
Var
  I: Integer;
  ADConnection: TADConnection;
  Table1: TADTable;
begin
  result := 0;
  // 20150923 Igor
  ADConnection := TADConnection.create(Application);
  Table1 := TADTable.create(Application);
  SetTableName(ADConnection, Table1, Appdir + '\' + FormsFeesDBLite,
    FormsFeesTableLite, 'FORMNAME');

  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If Ret[RetNo].FrmHasData[FRec.FormNo] then
    begin
      if Table1.FindKey([FRec.FormName]) then
      begin { Table1.FieldByName(Template).AsString; } end;
    end;
  end;
  Table1.Close;
  Table1.free;
  ADConnection.free;
end;


function IsShowHdrIndicator(FName: String): Boolean;
begin
  result := FList.ByFormName(FName).ShowHdr;
End;


function GetWhiteBoxesIndicator(FName: String): Boolean;
begin
  result := FList.ByFormName(FName).WhiteBoxes;
End;

function GetFName(AbrevName: String): String;
var
  I: Integer;
begin
  result := '';
  AbrevName := Rtrim(AbrevName);
  for I := 0 to (FList.Count - 1) do // 20150815 igor
  begin
    FRec := FList.Items[I];
    if FRec = nil then
      continue;
    if LeftStr(FRec.FormAbrev, Length(AbrevName)) = AbrevName then
    begin
      result := FRec.FormInstName;
      exit;
    end;
  end;
end;

function GetFormName(FormNo: Integer; ARetNo: Integer = 0): String;
begin
  // 20160704 Igor >>>
  // Result := FList.GetFormName(FormNo);
  if (ARetNo > 0) and Ret[ARetNo].IsLastYearReturn then // 20160704 Igor
    result := FLastYearList.GetFormName(FormNo)
  else
    result := FList.GetFormName(FormNo);
  // 20160704 Igor <<<

end;

function GetFormNo(const FormName: String; Check: Boolean = True;
  ARetNo: Integer = 0): Integer; // 20160704 Igor
begin
  // 20160704 Igor >>>
  // Result := FList.GetFormNo(FormName, Check);
  if (ARetNo > 0) and Ret[ARetNo].IsLastYearReturn then // 20160704 Igor
    result := FLastYearList.GetFormNo(FormName, Check)
  else
    result := FList.GetFormNo(FormName, Check);
  // 20160704 Igor <<<
end;

Function TotMultiple(RetNo: Integer; NonInstFormName: String; Elm: Integer): Real; { No Instance }
//20171210 CON
var
  I, FNo: Integer;
begin
  result := 0;
 {
  I := FList.FirstInstNo(NonInstFormName);
  if I < 1 then
  begin
    ErrorMsg('T4T5: TotMultiple: form ' + NonInstFormName + ' does not exist');
    exit;
  end;
}
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    //if FRec.FormName <> NonInstFormName then break;
    if FRec.FormName = NonInstFormName then
    Begin
     FNo := FRec.FormNo;
     result := result + Vl(FetchElmFNo(RetNo, FNo, Elm));
    End;
  end;
end;

Procedure UpdateAllDataIndicators(RetNo: Integer);
var
  I, FNo: Integer;
  FName, s: String;
  Msg: String;
begin
  Msg := '';
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    FNo := FRec.FormNo;
    if FNo > 0 then
      UpdateFormDataIndicator(RetNo, FRec);
  end;
  If CertificationMode then
    exit; // 20130203
end;

Procedure InfoOn;
begin

end;

Procedure InfoOff;
begin

end;

Function RetNoOfSpouse(RetNo: Integer; SpouseSin1: String;
  SpouseSin2: string): Integer;
Var
  I, RNo: Integer;
begin
  result := 0;
  If SpouseSin1 + SpouseSin2 = '' then
    exit;
  for I := 0 to (RetList.Count - 1) do
  begin
    RetRec := RetList.Items[I];
    RNo := RetRec.RetNo;
    If (Ret[RNo].Frm[1].Strings[3] = SpouseSin2) and
      (Ret[RNo].Frm[1].Strings[4] = SpouseSin1) then
    begin
      result := RNo;
      exit;
    end;
  end;
end;


Function GetNumbFields(FName: string): Integer;
Var
  I: Integer;
begin
  // really zero for FRec with FormFields=0 ???
  // result := 0;
  result := FList.ByFormName(FName).FormFields;
end;

// 20160810
Procedure ShowHelp(HelpFile: String; Helptopic: string;
  AIsWeb: Boolean = False); // 20160801 Igor
// Var RetCode: LongInt;  iHelpID: LongInt;
begin
  if not AIsWeb then // 20160801 Igor //20160810 Igor
    HelpFile := Appdir + '\' + HelpFile + '.CHM';
  vtDialogs.ShowHelp(HelpFile, Helptopic, AIsWeb); // 20160801 Igor
  // ShellExecute(0, 'open', PWideChar(HelpFile), nil, nil, SW_SHOW); //20160525 Igor //20160801 Igor
  // // iHelpId:=0;
  // if HtmlHelpInstalled = True then
  // begin
  // if HelpTopic='HELP_CONTENTS' then
  // RetCode := HH(0, PChar(HelpFile+Chr(0)), HH_DISPLAY_TOPIC,0)
  // else
  // RetCode := HH(0, PChar(HelpFile+'::/'+HelpTopic+'.html'+Chr(0)), HH_DISPLAY_TOPIC,0);
  // end
  // else
  // begin
  // ShowMessage('Please install at least v4.01 of Internet Explorer before '+
  // 'displaying a CHM file');
  // end;
end;

(*
  Procedure ShowHelp(HelpFile:String;Helptopic: string; AIsWeb: Boolean = False); //20160801 Igor
  //Var RetCode: LongInt;  iHelpID: LongInt;
  begin
  if AIsWeb then //20160801 Igor
  HelpFile:=AppDir+'\'+HelpFile+'.CHM';
  vtDialogs.ShowHelp(HelpFile, HelpTopic, AIsWeb); //20160801 Igor
  //  ShellExecute(0, 'open', PWideChar(HelpFile), nil, nil, SW_SHOW); //20160525 Igor //20160801 Igor
  // // iHelpId:=0;
  // if HtmlHelpInstalled = True then
  // begin
  //   if HelpTopic='HELP_CONTENTS' then
  //     RetCode := HH(0, PChar(HelpFile+Chr(0)), HH_DISPLAY_TOPIC,0)
  //   else
  //     RetCode := HH(0, PChar(HelpFile+'::/'+HelpTopic+'.html'+Chr(0)), HH_DISPLAY_TOPIC,0);
  // end
  // else
  // begin
  //      ShowMessage('Please install at least v4.01 of Internet Explorer before '+
  //      'displaying a CHM file');
  // end;
  end;
*)

Function MakeEFFileName(LicenseLevel: string): string;
Var
  YYYY, MM, DD, Hour, Min, Sec, Msec: Word;
  SMM, SDD, SSec: string; // [2];
begin
  DecodeDate(Now, YYYY, MM, DD);
  DecodeTime(Now, Hour, Min, Sec, Msec);
  SMM := Ltrim(Rtrim(IntToStr(MM)));
  SDD := Ltrim(Rtrim(IntToStr(DD)));
  SSec := Ltrim(Rtrim(IntToStr(Sec)));
  If Length(SMM) = 1 then
    SMM := '0' + SMM;
  If Length(SDD) = 1 then
    SDD := '0' + SDD;
  If Length(SSec) = 1 then
    SSec := '0' + SSec;
  If LeftStr(LicenseLevel, 8) = 'T4T5 Multi' then
    result := User.M_Office + SDD + SSec
  Else
    result := SMM + SDD + SSec;
end;

Function EditDate(s: String; MnYear, MxYear: Integer): Boolean;
{ In form yyyy/mm/dd }
begin
  result := EditDateYMD(s, MnYear, MxYear, '/');
end;

Function EditT3Date(s: String; MxYear: Integer): Boolean;
begin
  result := EditDateYMD(s, 1900, MxYear, '-');
end;

Function EditLongPrv(Value: string): Boolean;
Var
  I: Integer;
begin
  result := False;
  For I := Low(PrvLong) to High(PrvLong) do
  begin
    If Value = PrvLong[I] then
    begin
      result := True;
      exit;
    end;
  end;
end;

Function GetRowFromSlip(RetNo: Integer; FormName: string; Row: Integer;
  ExchRow: Integer; ShareRow: Integer): Real;
Var
  I, FNo: Integer;
  ExchRate, SharePercent: Real;
begin
  result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    if FRec.FormName = FormName then
    begin
      FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] then
      begin
        If ExchRow > 0 then
          ExchRate := Vl(Ret[RetNo].Frm[FNo].Strings[ExchRow])
        else
          ExchRate := 1;
        if ExchRate > 0 then { exch rate }
          result := result + (Vl(Ret[RetNo].Frm[FNo].Strings[Row])) * ExchRate
        else
          result := result + Vl(Ret[RetNo].Frm[FNo].Strings[Row]);
        If (ShareRow > 0) and
          (Ltrim(Rtrim(Ret[RetNo].Frm[FNo].Strings[ShareRow])) > '') then
        begin
          SharePercent := Vl(Ret[RetNo].Frm[FNo].Strings[ShareRow]);
          result := result * SharePercent / 100;
        end;
      end;
    end;
  end;
end;

Function RemoveCommas(s: string): String;
Var
  I: Integer;
begin
  For I := 1 to Length(s) do
  begin
    If s[I] = ',' then
      s[I] := ' ';
  end;
  result := s;
end;

Function InsertCommas(s: string): String;
Var
  SignPart: string; // [1];
  I: Integer; //20170123 Igor
begin
  //20170123 Igor >>>
  // Clear old commas
  for I := length(S) downto 1 do
    if not CharInSet(s[I], ['0','1','2','3','4','5','6','7','8','9','-']) then
      Delete(S, I, 1);
  //20170123 Igor >>>
  s := Ltrim(s);
  If LeftStr(s, 1) = '-' then
  begin
    SignPart := '-';
    s := RightStr(s, Length(s) - 1);
  end
  else
    SignPart := '';

  result := SignPart + s;
  Case Length(s) of
    4:
      result := SignPart + LeftStr(s, 1) + ',' + RightStr(s, 3);
    5:
      result := SignPart + LeftStr(s, 2) + ',' + RightStr(s, 3);
    6:
      result := SignPart + LeftStr(s, 3) + ',' + RightStr(s, 3);
    7:
      result := SignPart + LeftStr(s, 1) + ',' + MidStr(s, 2, 3) + ',' +
        RightStr(s, 3);
    8:
      result := SignPart + LeftStr(s, 2) + ',' + MidStr(s, 3, 3) + ',' +
        RightStr(s, 3);
    9:
      result := SignPart + LeftStr(s, 3) + ',' + MidStr(s, 4, 3) + ',' +
        RightStr(s, 3);
    { 10: Result := Leftstr(s,3)+','+MidStr(S,3,3)+','+RightStr(S,3); }
  end;
end;

Function ExtractIntegerPart(s: string): string;
var
  I: Integer;
  IntegerPart, DecimalPart: string; // [20];
Begin
  I := 1;
  while (I <= Length(s)) and not(s[I] = '.') do
    inc(I);
  result := LeftStr(s, I - 1); { copy(s[i],1,i-1); }
end;

Function ExtractDecimalPart(s: string): string;
var
  I: Integer;
Begin
  I := Length(s);
  while (I > 0) and not(s[I] in ['.']) do
    Dec(I);
  If (I > 0) and (s[I] = '.') then
    result := Copy(s, I + 1, 255)
  else
    result := '';
end;

Function InsertPenniesDot(s: string): String;
begin
  s := Ltrim(Rtrim(s));
  result := s;
  If MidStr(s, Length(s) - 2, 1) = ' ' then
    result := Concat(LeftStr(s, Length(s) - 3), '.', RightStr(s, 2));
end;

Function RemovePenniesDot(s: string): String;
begin
  result := s;
  If MidStr(s, Length(s) - 2, 1) = '.' then
    result := Concat(LeftStr(s, Length(s) - 3), ' ', RightStr(s, 2));
end;

Procedure SwapStrings(S1: string; S2: string);
var
  s: string;
begin
  s := S1;
  S1 := S2;
  S2 := s;
end;

Function FileNameValid(FlName: string): Boolean;
Var
  I: Integer;
begin
  result := True;
  If (Length(FlName) > 12) or (Length(FlName) = 0) or
    (Length(ExtractFilePath(FlName)) > 0) or
    (Length(ExtractFileExt(FlName)) > 4) { includes . }
  then
    result := False;
end;

Function CopyReturn(DataDir: String; FileName: String;
  DestinationDir: string): Boolean;
begin
  ShowMessage('Copying: ' + FileName);
end;

//20170112 Igor (Move to TUserConfig)
(*
Function GetUserProfile(UserName: string): Boolean;
Var
  ADConnection: TADConnection;
  Table1: TADTable;
begin
  result := True;

  // 20150919 Igor
  ADConnection := TADConnection.create(Application);
  Table1 := TADTable.create(Application);
  SetTableName(ADConnection, Table1, Appdir + '\' + UserDBLite,
    UserTableLite, 'Name');

  if Table1.FindKey([UserName]) = False then
  begin
    result := False;
    exit;
  end;
  With Table1 do
  begin
    User.M_Office := FieldByName('M_Office').AsString;
    User.Branch := FieldByName('Branch').AsString;
    User.Prep_Intls := FieldByName('Prep_Intls').AsString;
    User.Login_Id := FieldByName('Login_Id').AsString;
    User.Pswd := FieldByName('Pswd').AsString;
    User.Auth_Level := FieldByName('Auth_Level').AsString;
    User.Inv_No := FieldByName('Inv_No').AsInteger;
    User.Prep_Name := FieldByName('Prep_Name').AsString;
    User.Tax_dir := FieldByName('Tax_dir').AsString;
    // User.EFile_Dir := FieldByName('EFile_dir').AsString;
    User.CrProfile := Boolean(FieldByName('Cr_Profile').AsInteger);
    User.CrReturn := Boolean(FieldByName('Cr_Return').AsInteger);
    User.PrReturn := Boolean(FieldByName('Pr_Return').AsInteger);
    User.PrInvoice := Boolean(FieldByName('Pr_Invoice').AsInteger);
    User.PrReport := Boolean(FieldByName('Pr_Report').AsInteger);
    User.MkAppoint := Boolean(FieldByName('Mk_Appoint').AsInteger);
    // User.CrRtu     := FieldByName('Cr_Rtu').As Boolean;
    // User.EFile     := FieldByName('Efile').As Boolean;
    User.Upload := Boolean(FieldByName('Upload').AsInteger);
    User.MkPay := Boolean(FieldByName('Mk_Pay').AsInteger);

    Table1.free;
    ADConnection.free;
  end;
end;
*) //20170112 Igor

Function MakeDataDirectory(DataDir: string): Integer;
{ return codes
  0 : OK
  -1 : Directory exists
  -3 : cannot be created
}
begin
  result := 0;
  If SysUtils.ForceDirectories(DataDir) <> True then//20170803 Igor
    result := -3;
  (*
    If DirectoryExists(DataDir) then begin result := -1; exit; end;
    {now create the dir}
    {$I-}   {so that the ioresult can be effective}
    MkDir(DataDir);
    if IOResult <> 0 then
    begin result := -3; exit; end;
  *)
end;

Function CopyBlankDBFS(Appdir: string; DataDir: string): Boolean;
//20170803 Igor>>>
var
  Err: String;
begin
  result := True;
  { copy the Clients d bf }
  If not FileExists(DataDir + '\' + ClientsDBLite) then
    result := CopyDB(ClientsDBLite, Appdir, DataDir, Err);
  if not Result then
    MessageDlg(Err, mtError, [mbOk], 0);
 //20170803 Igor<<<
end;

Procedure ShowOpenReturnFailure(FailCode: Integer; DataDir: String;
  FlName: string);
begin
  Case FailCode of
    - 1:
      ShowMessage('File ' + FlName + ' does not exist' + Chr(13) + 'in dir: '
        + DataDir);
    -2:
      ShowMessage('File ' + FlName + ' is not a tax return');
    -3:
      ShowMessage('Exceeds number of maximum returns in memory');
  else
    ShowMessage('Some error occured');
  end;
end;

procedure LoadDataDict;
begin
  if DataDictList = nil then
    DataDictList := TDataDictList.create;
  DataDictList.Load(Appdir);
end;

function InDataDict(KeyW: String): Boolean;
Var
  I: Integer;
begin
  KeyW := UpperCase(KeyW);
  // assumed present
  If (LeftStr(KeyW, 5) = 'LINE_') Or (LeftStr(KeyW, 5) = 'FORM_') Or
    (LeftStr(KeyW, 4) = 'FNUM') Or (LeftStr(KeyW, 4) = 'FIMG') then
  begin
    result := True;
    exit;
  End;

  result := False;
  for I := 0 to (DataDictList.Count - 1) do
  begin
    DataDictRec := DataDictList.Items[I];
    If KeyW = UpperCase(MidStr(DataDictRec.KeyWord, 1, 100)) then
    begin
      result := True;
      exit;
    End;
  end;
End;

function GetDataDictFormName(KeyW: String): String;
Var
  I: Integer;
begin
  result := '';
  for I := 0 to (DataDictList.Count - 1) do
  begin
    DataDictRec := DataDictList.Items[I];
    If KeyW = MidStr(DataDictRec.KeyWord, 1, 255) then
    begin
      result := DataDictRec.FormName;
      exit;
    End;
  end;
End;

function GetDataDictElmNo(KeyW: String): Integer;
Var
  I: Integer;
begin
  result := 0;
  for I := 0 to (DataDictList.Count - 1) do
  begin
    DataDictRec := DataDictList.Items[I];
    If KeyW = MidStr(DataDictRec.KeyWord, 1, 255) then
    begin
      result := DataDictRec.Field_No;
      exit;
    End;
  end;
End;

Function CalcAgeTo(BirthDate: string; ToDate: string): Integer;
// birthdate in form YYYY-MM-DD
Var
  k: Integer;
Begin
  result := 0;
  If Length(BirthDate) = 0 then
  begin
    result := 0;
    exit;
  end;
  k := StrToInt(LeftStr(ToDate, 4)) - StrToInt(LeftStr(BirthDate, 4));
  result := k;
end;

Function ValidAccount(Account: string): Boolean;
begin
  result := True;
  If Length(Account) <> 8 then
  begin
    result := False;
    exit;
  end;
  {
    If ChkDigit(LeftStr(SiNum,8)) <> StrToInt(RightStr(SiNum,1))
    then Result := false; }
end;

Function InvalidAmountInLetter(s: string): Boolean;
begin
  result := False;
  if ((s < '0') or (s > '9')) and (s <> '.') and (s <> ' ') and (s <> '-') and
    (s <> ',') and (s <> '(') and (s <> ')') and (s <> '$') then
    result := True;
end;

Function ClcR(FieldId: Integer; PgmValue: Real; FormOvrSw: Boolean;
  RetNo: Integer; FormNo: Integer): Real;
Var
  I: Integer;
begin
  If FormOvrSw = False then
    result := PgmValue
  else
    result := Vl(GetOvrValue(RetNo, FormNo, FieldId));
end;

procedure InitFormsTable;
begin
  if FList.InitFormsTable(Appdir, FormsDBLite, FormsTableLite) then
  // 20150918 Igor
    exit; // okay

  AppT4T5_2026.PrepareDistribution;

  if FList.InitFormsTable(Appdir, FormsDBLite, FormsTableLite) then
  // 20150918 Igor
    exit; // okay

  UserMsg('Please fix errors in T4T5 forms');
  Application.Terminate;
end;

Procedure ExpandTabs(AList: TStrings);
var
  I, j: Integer;
  TabChar, s: string;
begin
  exit; { ? }

  TabChar := Chr(9);
  for I := 0 to AList.Count - 1 do
  begin
    s := AList[I];
    { Convert tabs to 6 spaces }
    while Pos(TabChar, s) > 0 do
    begin
      j := Pos(TabChar, s);
      s[j] := ' ';
      s := LeftStr(s, j) + '     ' + MidStr(s, j + 6, 255);
    end;
  end;
end;

Function GetTotalFee(RetNo: Integer): Real;
Var
  I: Integer;
begin
  result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If Ret[RetNo].FrmHasData[FRec.FormNo] then
      If FRec.FormInst > '#1' then
        result := result + Vl(FRec.FeeAddItem)
      else
        result := result + Vl(FRec.Fee);
  end;
end;

Function GetFormFee(FormName: String; Qty: Integer): Real;
Var
  I: Integer;
begin
  result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FormName = FRec.FormName then
    begin
      result := Vl(FRec.Fee) + (Qty - 1) * Vl(FRec.FeeAddItem);
      break;
    end;
    (*
      If Frec.FormInst >'#1' then
      Result := Qty * FRec.FeeAddItem
      else
      Result := Qty * FRec.Fee;
    *)
  end;
end;

Function CalcFedPolitCredit(TotalContrib: Real): Real;
Var
  Temp: LongInt;
begin
  result := 0.0;
  Temp := Round(TotalContrib);
  case Temp Of
    0 .. 200:
      result := TotalContrib * 0.75;
    201 .. 550:
      result := (200.00 * 0.75) + ((TotalContrib - 200.00) * 0.50);
  else
    result := MinR(500.00, ((200.0 * 0.75) + ((550 - 200.00) * 0.50) +
      ((TotalContrib - 550.00) * 0.333)));
  end;
end;

Function CalcPolitCredit(Province: String; TotalContrib: Real): Real;
Var
  Temp: LongInt;
begin
  result := 0.0;
  Temp := Round(TotalContrib);
  If (Province = 'BC') OR (Province = 'PE') OR (Province = 'YT') OR
    (Province = 'NU')
  { Fed political contrib is calculated as if it were MN. If you change MN calculations revise S11 line 1119 }
  then
  begin
    case Temp Of
      0 .. 100:
        result := TotalContrib * 0.75;
      101 .. 550:
        result := 75 + ((TotalContrib - 100.00) * 0.50);
      551 .. 1150:
        result := 300 + ((TotalContrib - 550) * 0.3333);
    else
      result := 500;
    end;
  end;

  if Province = 'NS' then
  begin
    result := MinR(750, TotalContrib * 0.75);
  end;

  if Province = 'MB' then
  begin
    case Temp Of
      0 .. 400:
        result := TotalContrib * 0.75;
      401 .. 750:
        result := 300 + ((TotalContrib - 400) * 0.50);
      751 .. 1275:
        result := 475 + ((TotalContrib - 750) * 0.3333);
    else
      result := 650;
    end;
  end;

  if Province = 'AB' then
  begin
    case Temp Of
      0 .. 200:
        result := TotalContrib * 0.75;
      201 .. 1100:
        result := (200.0 * 0.75) + ((TotalContrib - 200) * 0.50);
      1101 .. 2300:
        result := MinR(1000, 600 + ((TotalContrib - 1100) * 0.3333));
    else
      result := 1000;
    end;
  end;
  if Province = 'NT' then
  begin
    case Temp Of
      0 .. 100:
        result := TotalContrib * 1.00;
    else
      result := MinR(500.00,
        ((100.0 * 1.00) + ((TotalContrib - 100.00) * 0.50)));
    end;
  end;

  if Province = 'SK' then
  begin
    case Temp Of
      0 .. 400:
        result := TotalContrib * 0.75;
      401 .. 750:
        result := 300 + (TotalContrib - 400.00) * 0.50;
      751 .. 1275:
        result := 475 + (TotalContrib - 750.00) * 0.3333;
    else
      result := 650;
    end;
  end;

end;


Function GetFootValue(RetNo, FNo: Integer; Txt: String): Real;
Var
  SubS: String;
begin
  result := 0;
  If LeftStr(FetchElmFNo(RetNo, FNo, 30), Length(Txt)) = Txt then
    result := result + Vl(FetchElmFNo(RetNo, FNo, 31));
  If LeftStr(FetchElmFNo(RetNo, FNo, 32), Length(Txt)) = Txt then
    result := result + Vl(FetchElmFNo(RetNo, FNo, 33));
  If LeftStr(FetchElmFNo(RetNo, FNo, 34), Length(Txt)) = Txt then
    result := result + Vl(FetchElmFNo(RetNo, FNo, 35));
  If LeftStr(FetchElmFNo(RetNo, FNo, 36), Length(Txt)) = Txt then
    result := result + Vl(FetchElmFNo(RetNo, FNo, 37));
  If LeftStr(FetchElmFNo(RetNo, FNo, 47), Length(Txt)) = Txt then
    result := result + Vl(FetchElmFNo(RetNo, FNo, 48));
end;

Function ReformatAccount(s: string; PrefixLtr: string): String;
begin
  If Length(s) < 8 then
  begin
    result := s;
    exit;
  end;
  result := PrefixLtr + LeftStr(s, 2) + '-' + MidStr(s, 3, 4) + '-' +
    RightStr(s, 2);
  If result = '--' then
    result := '';
end;

Function GetPrvYear(ThisYear: String; No: Integer): String;
Var
  k: Integer;
begin
  k := MyStrToInt(ThisYear) - No;
  result := IntToStr(k);
end;

Function GetTrustYear(RetNo: Integer): String;
Var
  s: string; // [12];
begin
  s := GetYearEnd(RetNo);
  If Vl(LeftStr(s, 4)) = 0 then
    result := Appyear
  else
    result := LeftStr(s, 4);
end;

// 20160808
Function GetStartTrustYear(RetNo: Integer): String;
Var
  s: string; // [12];
begin
  s := FetchElm(RetNo, 'T3', 14);
  result := LeftStr(s, 4);
end;

Function GetEmptyT3BoxNo(RetNo, FNo: Integer; FromElm, ToElm, ByElm: Integer): Integer;
Var
  I: Integer;
begin
  result := 0;
  I := FromElm;
  Repeat
    If Ret[RetNo].Frm[FNo].Tv[I] = 0 then
    begin
      result := I;
      exit;
    end;
    inc(I, ByElm);
  until I > ToElm;
end;

Procedure CopySlipToDestForm(RetNo: Integer; FromForm: string; DestFNo: Integer;
  TopOrBottom: Integer; DestFormName: String);
Var
  I, j, k, Ndx: Integer;
  PercentAlloc: Real;
  s, BoxId: String; // Tp:string; //[1];
begin
  If TopOrBottom = 1 then
    Ndx := 0;
  If TopOrBottom = 2 then
    Ndx := 50;
  If TopOrBottom = 3 then
    Ndx := 100;
  with Ret[RetNo].Frm[DestFNo] do
  begin
    Strings[1 + Ndx] := Appyear; // FetchElm(RetNo,FromForm,39);  //Appyear;  ?
    Strings[2 + Ndx] := FetchElm(RetNo, FromForm, 7); // box 23
    Strings[3 + Ndx] := FetchElm(RetNo, FromForm, 14); // 32
    Strings[4 + Ndx] := FetchElm(RetNo, FromForm, 21); // 39
    Strings[5 + Ndx] := FetchElm(RetNo, FromForm, 5); // 21
    Strings[6 + Ndx] := FetchElm(RetNo, FromForm, 12); // 30
    Strings[7 + Ndx] := FetchElm(RetNo, FromForm, 10); // 26

    Strings[8 + Ndx] := FetchElm(RetNo, FromForm, 39); // yr

    Strings[9 + Ndx] := FetchElm(RetNo, FromForm, 40); // month
    Strings[10 + Ndx] := FetchElm(RetNo, FromForm, 1); // 12
    Strings[11 + Ndx] := 'T' + FetchElm(RetNo, FromForm, 2); // 14 account
    Strings[12 + Ndx] := FetchElm(RetNo, FromForm, 3); // 16
    Strings[13 + Ndx] := FetchElm(RetNo, FromForm, 4); // 18

    Strings[43 + Ndx] := FetchElm(RetNo, FromForm, 56); // box 49
    Strings[44 + Ndx] := FetchElm(RetNo, FromForm, 55); // box 50
    Strings[45 + Ndx] := FetchElm(RetNo, FromForm, 54); // box 51

    // check the from form for other amount. If there is empty box
    // in dest form then put the box and the amount
    BoxId := '22';
    s := AllTrim(FetchElm(RetNo, FromForm, 6));
    k := GetEmptyT3BoxNo(RetNo, DestFNo, 23 + Ndx, 33 + Ndx, 2);
    If (s <> '') and (k > 0) then
    begin
      Strings[k] := BoxId;
      Tv[k] := Vl(BoxId);
      Strings[k + 1] := s;
    end;
    // If (s <>'') and (K>0) then begin Strings[k+ndx]:=BoxId;Tv[k+ndx]:=Vl(BoxId);Strings[k+1+ndx]:=s;end;

    BoxId := '24';
    s := AllTrim(FetchElm(RetNo, FromForm, 8));
    k := GetEmptyT3BoxNo(RetNo, DestFNo, 23 + Ndx, 33 + Ndx, 2);
    If (s <> '') and (k > 0) then
    begin
      Strings[k] := BoxId;
      Tv[k] := Vl(BoxId);
      Strings[k + 1] := s;
    end;

    BoxId := '25';
    s := AllTrim(FetchElm(RetNo, FromForm, 9));
    k := GetEmptyT3BoxNo(RetNo, DestFNo, 23 + Ndx, 33 + Ndx, 2);
    If (s <> '') and (k > 0) then
    begin
      Strings[k] := BoxId;
      Tv[k] := Vl(BoxId);
      Strings[k + 1] := s;
    end;

    BoxId := '31';
    s := AllTrim(FetchElm(RetNo, FromForm, 13));
    k := GetEmptyT3BoxNo(RetNo, DestFNo, 23 + Ndx, 33 + Ndx, 2);
    If (s <> '') and (k > 0) then
    begin
      Strings[k] := BoxId;
      Tv[k] := Vl(BoxId);
      Strings[k + 1] := s;
    end;

    BoxId := '33';
    s := AllTrim(FetchElm(RetNo, FromForm, 15));
    k := GetEmptyT3BoxNo(RetNo, DestFNo, 23 + Ndx, 33 + Ndx, 2);
    If (s <> '') and (k > 0) then
    begin
      Strings[k] := BoxId;
      Tv[k] := Vl(BoxId);
      Strings[k + 1] := s;
    end;

    BoxId := '34';
    s := AllTrim(FetchElm(RetNo, FromForm, 16));
    k := GetEmptyT3BoxNo(RetNo, DestFNo, 23 + Ndx, 33 + Ndx, 2);
    If (s <> '') and (k > 0) then
    begin
      Strings[k] := BoxId;
      Tv[k] := Vl(BoxId);
      Strings[k + 1] := s;
    end;

    BoxId := '35';
    s := AllTrim(FetchElm(RetNo, FromForm, 17));
    k := GetEmptyT3BoxNo(RetNo, DestFNo, 23 + Ndx, 33 + Ndx, 2);
    If (s <> '') and (k > 0) then
    begin
      Strings[k] := BoxId;
      Tv[k] := Vl(BoxId);
      Strings[k + 1] := s;
    end;

    BoxId := '37';
    s := AllTrim(FetchElm(RetNo, FromForm, 19));
    k := GetEmptyT3BoxNo(RetNo, DestFNo, 23 + Ndx, 33 + Ndx, 2);
    If (s <> '') and (k > 0) then
    begin
      Strings[k] := BoxId;
      Tv[k] := Vl(BoxId);
      Strings[k + 1] := s;
    end;

    BoxId := '38';
    s := AllTrim(FetchElm(RetNo, FromForm, 20));
    k := GetEmptyT3BoxNo(RetNo, DestFNo, 23 + Ndx, 33 + Ndx, 2);
    If (s <> '') and (k > 0) then
    begin
      Strings[k] := BoxId;
      Tv[k] := Vl(BoxId);
      Strings[k + 1] := s;
    end;

    BoxId := '40';
    s := AllTrim(FetchElm(RetNo, FromForm, 22));
    k := GetEmptyT3BoxNo(RetNo, DestFNo, 23 + Ndx, 33 + Ndx, 2);
    If (s <> '') and (k > 0) then
    begin
      Strings[k] := BoxId;
      Tv[k] := Vl(BoxId);
      Strings[k + 1] := s;
    end;

    BoxId := '41';
    s := AllTrim(FetchElm(RetNo, FromForm, 23));
    k := GetEmptyT3BoxNo(RetNo, DestFNo, 23 + Ndx, 33 + Ndx, 2);
    If (s <> '') and (k > 0) then
    begin
      Strings[k] := BoxId;
      Tv[k] := Vl(BoxId);
      Strings[k + 1] := s;
    end;

    BoxId := '42';
    s := AllTrim(FetchElm(RetNo, FromForm, 49));
    k := GetEmptyT3BoxNo(RetNo, DestFNo, 23 + Ndx, 33 + Ndx, 2);
    If (s <> '') and (k > 0) then
    begin
      Strings[k] := BoxId;
      Tv[k] := Vl(BoxId);
      Strings[k + 1] := s;
    end;

    BoxId := '45';
    s := AllTrim(FetchElm(RetNo, FromForm, 18));
    k := GetEmptyT3BoxNo(RetNo, DestFNo, 23 + Ndx, 33 + Ndx, 2);
    If (s <> '') and (k > 0) then
    begin
      Strings[k] := BoxId;
      Tv[k] := Vl(BoxId);
      Strings[k + 1] := s;
    end;

    BoxId := '46';
    s := AllTrim(FetchElm(RetNo, FromForm, 51));
    k := GetEmptyT3BoxNo(RetNo, DestFNo, 23 + Ndx, 33 + Ndx, 2);
    If (s <> '') and (k > 0) then
    begin
      Strings[k] := BoxId;
      Tv[k] := Vl(BoxId);
      Strings[k + 1] := s;
    end;

    BoxId := '47';
    s := AllTrim(FetchElm(RetNo, FromForm, 52));
    k := GetEmptyT3BoxNo(RetNo, DestFNo, 23 + Ndx, 33 + Ndx, 2);
    If (s <> '') and (k > 0) then
    begin
      Strings[k] := BoxId;
      Tv[k] := Vl(BoxId);
      Strings[k + 1] := s;
    end;

    BoxId := '48';
    s := AllTrim(FetchElm(RetNo, FromForm, 53));
    k := GetEmptyT3BoxNo(RetNo, DestFNo, 23 + Ndx, 33 + Ndx, 2);
    If (s <> '') and (k > 0) then
    begin
      Strings[k] := BoxId;
      Tv[k] := Vl(BoxId);
      Strings[k + 1] := s;
    end;

    // copy footnotes
    I := 35; // t3sl
    j := 30; // t3supl
    Repeat
      Strings[I + Ndx] := FetchElm(RetNo, FromForm, j);
      Strings[I + 1 + Ndx] := AllTrim(FetchElm(RetNo, FromForm, j + 1));
      inc(I, 1);
      inc(j, 1);
    until I > 41;
    // copy recipient name/address    //20110521
    Strings[14 + Ndx] := FetchElm(RetNo, FromForm, 26) + ' ' +
      FetchElm(RetNo, FromForm, 64); // name
    Strings[15 + Ndx] := FetchElm(RetNo, FromForm, 27); // street
    Strings[16 + Ndx] := FetchElm(RetNo, FromForm, 28) + ' ' +
      FetchElm(RetNo, FromForm, 29); // city, prov
    Strings[17 + Ndx] := FetchElm(RetNo, FromForm, 65) + ' ' +
      FetchElm(RetNo, FromForm, 66); // prov and postal
    // copy trust name/address
    Strings[19 + Ndx] := FetchElm(RetNo, FromForm, 38);

    Strings[20 + Ndx] := FetchElm(RetNo, 'T3', 4);
    Strings[21 + Ndx] := FetchElm(RetNo, 'T3', 7);
    Strings[22 + Ndx] := FetchElm(RetNo, 'T3', 8);
  end; { end with ret }

end; { procedure }

Procedure CopyNR4SlipToDestForm(RetNo: Integer; FromForm: string;
  DestFNo: Integer; TopOrBottom: Integer; DestFormName: String);
Var
  I, j, k, Ndx: Integer;
  PercentAlloc: Real;
  s, BoxId: String; // Tp:string; //[1];
begin
  If TopOrBottom = 1 then
    Ndx := 0;
  If TopOrBottom = 2 then
    Ndx := 40; // fields in first slip
  // If TopOrbottom=3 then ndx:=80;
  with Ret[RetNo].Frm[DestFNo] do
  begin
    For k := 1 to 36 do
    begin
      StoreElm(RetNo, DestFNo, k + Ndx, FetchElm(RetNo, FromForm, k));
      // Strings[k+ndx] := FetchElm(RetNo,FromForm,k);
      Tv[k + Ndx] := Vl(Strings[k + Ndx]);
    end;
  end; { end with ret }
end; { procedure }

Procedure ResolveConditions(AList: TStrings);
var
  I, Place: Integer;
  errorC: Boolean;
  NetList: TStringList;
  KeyW: string;
  Size: Word;
  Buffer, WorkBuffer: Pchar;
  CheckKey: Boolean;
  LineNum: LongInt;
  ConditionStr: string;
  CheckCondition: Boolean;
  exchange: string;
  j, k, L, M: Integer;
  MaxLine: Integer;
  f: TextFile;
  s: String;
begin
  { now Condition interpret }
  NetList := TStringList.create;
  errorC := False;
  MaxLine := AList.Count;
  { Replace condition lines }
  I := 0;
  Repeat
    Place := Pos('#If#', AList[I]);
    If Place = 0 then { no If statement }
    begin
      NetList.Add(AList[I]);
      { Inc(i); }
    end
    else
    begin
      LineNum := I; { lineNum has the If statement }
      s := MidStr(AList[LineNum], Place, 255);
      ConditionEvaluator(s, CheckCondition, errorC);
      if errorC = True then
        exit;

      { If condition is true }
      if CheckCondition = True then
      begin
        j := 1; { j counts the lines after a true if }
        while (Pos('#Else#', AList[LineNum + j]) = 0)
        { (MidStr(AList[LineNum+J],6,6)<>'#Else#') }
          and (Pos('#Endif#', AList[LineNum + j]) = 0) and
          (LineNum + j < MaxLine) do
          j := j + 1;

        for k := 1 to j - 1 do
          NetList.Add(AList[LineNum + k]); { copy lines after ^If }

        if (Pos('#Else#', AList[LineNum + j]) > 0)
        { MidStr(AList[LineNum+J],6,6)='#Else#' } then { after else }
        begin
          L := j + 1;
          while (Pos('#Endif#', AList[LineNum + L]) = 0)
          { (MidStr(AList[LineNum+L],6,7)<>'#Endif#') }
            and (LineNum + L < MaxLine) do
            L := L + 1;
        end
        else
          L := j;
        I := I + L;
      end;

      if CheckCondition = False then
      begin
        j := 1; { j counts the lines after a false if }
        while (Pos('#Else#', AList[LineNum + j]) = 0)
        { (MidStr(AList[LineNum+J],6,6)<>'#Else#') }
          and (Pos('#Endif#', AList[LineNum + j]) = 0)
        { (MidStr(AList[LineNum+J],6,7)<>'#Endif#') }
          and (LineNum + j < MaxLine) do
          j := j + 1;

        if (Pos('#Endif#', AList[LineNum + j]) > 0)
        { MidStr(AList[LineNum+J],6,7)='#Endif#' } then
          L := j
        else
        begin
          L := j + 1;
          while (Pos('#Endif#', AList[LineNum + L]) = 0)
          { (MidStr(AList[LineNum+L],6,7)<>'#Endif#') }
            and (LineNum + L < MaxLine) do
            L := L + 1;
          for k := j + 1 to L - 1 do
            NetList.Add(AList[LineNum + k]);
        end;
        I := I + L;
      end;
    end;
    inc(I); { ? }
  until I > MaxLine - 1;
  AList.clear;
  For I := 0 to NetList.Count - 1 do
    AList.Add(NetList[I]);
  NetList.free;
end;

procedure InterpretTextLine(Var Txt: String);
Var
  I, Size: Integer;
  RetNo: Integer;
  KeyW: string;
  OrdKeyW: Integer;
  j, L: Integer;
  s: string;
  FrmNm: String;
  ElmNo: Integer;
  ReplaceString: string;
  KeyWLength, Cursor_position, LineNumber: Integer;
begin
  Txt := Rtrim(Txt) + ' '; { one space to allow for logic }
  Size := Length(Txt) + 1;
  KeyW := '';
  I := 1;
  Repeat
    if Txt[I] = KeyWDelimiter1 then
    begin
      Cursor_position := I;
      I := I + 1;
      while (Txt[I] <> KeyWDelimiter2) and (I < Size) do
      begin
        KeyW := KeyW + Txt[I];
        I := I + 1;
      end;

      If (InDataDict(KeyW)) and (KeyW <> 'If') and (KeyW <> 'Else') and
        (KeyW <> 'Endif') and (KeyW <> 'Date') and (KeyW <> 'This_TaxYear') and
        (KeyW <> 'Next_TaxYear') and (LeftStr(KeyW, 5) <> 'Line_') then
      begin
        FrmNm := GetDataDictFormName(KeyW);
        ElmNo := GetDataDictElmNo(KeyW);
        KeyWLength := Length(KeyW);
        ReplaceString := FetchElm(RetNo, FrmNm, ElmNo);
        ReplaceKeyWord(Txt, Cursor_position, KeyWLength, ReplaceString);
      end
      else if LeftStr(KeyW, 5) = 'Line_' then
      begin { Replace Line Number }
        KeyWLength := Length(KeyW);
        if KeyWLength = 8 then
          LineNumber := StrToInt(RightStr(KeyW, 3));
        if KeyWLength = 9 then
          LineNumber := StrToInt(RightStr(KeyW, 4));
        FormatSettings.DecimalSeparator := '.'; // 20150805 Igor
        ReplaceString :=
        { FloatToStrF(Ret[retNo].Ln[LineNumber],ffNumber,15,2); }
          InsertPenniesDot(ReplaceString);
        ReplaceKeyWord(Txt, Cursor_position, KeyWLength, ReplaceString);
      end
      else
      begin
        { Replace reserved keyword }
        KeyWLength := Length(KeyW);
        If KeyW = 'Date' then
          ReplaceString := DateToMonthDayYear(Date)
        else If KeyW = 'This_TaxYear' then
          ReplaceString := Appyear
        else If KeyW = 'Next_TaxYear' then
          ReplaceString := IntToStr(AppYearInt + 1)
        else
          ReplaceString := '#' + KeyW + '#';
        ReplaceKeyWord(Txt, Cursor_position, KeyWLength, ReplaceString);
      end;
      KeyW := '';
      I := Cursor_position + Length(ReplaceString);
      Size := Size - KeyWLength + Length(ReplaceString);
    end
    else { no keyword }
      If I > Size then
        exit;
    inc(I); { ? }
  until I > Size;
end;

procedure ConditionEvaluator(CStr: string; var CCheck: Boolean;
  var error: Boolean);
{ cstring comes as: #If#  -12000.00 > 0 then }
var
  n1, n2: Real;
  I, Count: Integer;
  nstr, Temp: string;
  great, less, eql: Boolean;
  t1, t2: Boolean;
  cand, cor: Boolean;
  j, N1StartsAt, N2StartsAt: Integer;
begin
  { remove leading spaces before the amount }
  Temp := AllTrim(MidStr(CStr, 5, 255));
  Temp := AllTrim(Temp); { i.e. 1215.00 <0 }
  If (LeftStr(Temp, 1) = '<') or (LeftStr(Temp, 1) = '>') or
    (LeftStr(Temp, 1) = '=') then { null value came }
    Temp := '0 ' + Temp;
  CStr := LeftStr(CStr, 4) + Temp;

  error := False;
  I := 5;
  great := False;
  less := False;
  eql := False;
  nstr := ''; { the string of each number }
  cand := False;
  cor := False;
  j := Length(CStr);
  N1StartsAt := 5;
  { get first number }

  Count := N1StartsAt;
  Repeat
    (*
      for count:=N1StartsAt to J do {get first number}
      begin
    *)

    { Number invalid check }
    if InvalidAmountInLetter(CStr[Count]) then
    begin
      ShowMessage('Invalid Number');
      error := True;
      exit;
    end;

    { take number out of the string }
    if ((CStr[Count] >= '0') and (CStr <= '9')) or (CStr[Count] = '.') or
      (CStr[Count] = '-') then
      nstr := nstr + CStr[Count];
    if CStr[Count] = ' ' then
    begin
      I := Count + 1;
      Count := Length(CStr);
      If nstr = '' then
        n1 := 0
      else
        n1 := Vl(nstr);
      { StrToFloat(nstr); } { Vl(FormatAmount(nstr)); } { no commas }
      nstr := '';
    end;
    inc(Count);
  until Count > j;
  { end; }
  { get > < position }
  Count := I;
  Repeat
    { for count:=i to J do }
    if (CStr[Count] = '>') or (CStr[Count] = '<') or (CStr[Count] = '=') or
      (CStr[Count] = '-') then
    begin
      if CStr[Count] = '>' then
        great := True
      else if CStr[Count] = '<' then
        less := True
      else if CStr[Count] = '=' then
        eql := True;
      I := Count;
      Count := Length(CStr);
    end;
    inc(Count);
  until Count > j;

  { get second amount }
  If CStr[I + 1] = ' ' then
    N2StartsAt := I + 2
  else
    N2StartsAt := I + 1;
  Count := N2StartsAt;
  Repeat
    { for count:=N2StartsAt to J do
      begin }
    if InvalidAmountInLetter(CStr[Count]) then
    begin
      ShowMessage('Invalid Number');
      error := True;
      exit;
    end;
    if ((CStr[Count] >= '0') and (CStr[Count] <= '9')) or (CStr[Count] = '.')
    then
      nstr := nstr + CStr[Count];
    if (CStr[Count] = ' ') or (CStr[Count] = ')') then
    begin
      I := Count;
      Count := Length(CStr);
      n2 := Vl(nstr);
      { StrToFloat(Ltrim(nstr)); } { Vl(FormatAmount(nStr)); {no commas }
      nstr := '';
    end;
    inc(Count);
  until Count > j;
  { end; }
  { Compare the extracted numbers }
  if (great = True) and (n1 > n2) then
    t1 := True;
  if (great = True) and (n1 <= n2) then
    t1 := False;
  if (less = True) and (n1 < n2) then
    t1 := True;
  if (less = True) and (n1 >= n2) then
    t1 := False;

  if (eql = True) and (n1 = n2) then
    t1 := True;
  if (eql = True) and (n1 <> n2) then
    t1 := False;

  CCheck := t1; { CCheck is true if t1 condition is true }
end;

Procedure ReplaceText(LetterBody: TMemo; Cursor_position: Integer;
  KeyWLength: Byte; ReplaceText: string);
var
  I, j, k, PosReturn, SkipChars: Integer;
begin
  With LetterBody do
  begin
    SelStart := Cursor_position - 1;
    SelLength := KeyWLength + 1;
    SelText := ReplaceText;
  end;
end;

Function ValidateTextLine(Txt: String; Var Cursor_position: Integer;
  Var KeyWLength: Integer): Boolean;
Var
  I, Size: Integer;
  KeyW: string;
  OrdKeyW: Integer;
  j, L: Integer;
  s: string;
begin
  result := False;
  Txt := Ltrim(Rtrim(Txt)) + ' '; { one space to allow for logic }
  Size := Length(Txt);

  KeyW := '';
  I := 1;
  Repeat
    {
      for i := 1 to size do
      begin }
    if Txt[I] = KeyWDelimiter1 then
    begin
      Cursor_position := I;
      I := I + 1;
      while (Txt[I] <> KeyWDelimiter2) and (Txt[I] <> '.') and (I < Size) do
      begin
        KeyW := KeyW + Txt[I];
        I := I + 1;
      end;

      If (InDataDict(KeyW) = False) and (LeftStr(KeyW, 5) <> 'Line_') then
      begin
        KeyWLength := Length(KeyW);
        exit;
      end
      else if LeftStr(KeyW, 5) = 'Line_' then { Check Line Number }
      begin
        KeyWLength := Length(KeyW);
        if (KeyWLength < 7) or (KeyWLength > 9) then
        begin
          KeyWLength := Length(KeyW);
          exit;
        end;
        if KeyWLength = 8 then
          s := RightStr(KeyW, 3);
        if KeyWLength = 9 then
          s := RightStr(KeyW, 4);
        for j := 1 to Length(s) do
          if (s[j] < '0') or (s[j] > '9') then
          begin
            KeyWLength := Length(KeyW);
            exit;
          end;
        {
          if (StrToInt(s)<LnLowBound) or (StrToInt(s)>LnHighBound) then
          begin
          KeyWlength:=Length(KeyW);
          exit;
          end;
        }
      end;
      KeyW := '';
    end;
    inc(I);
  Until I > Size;
  result := True;
end;

Procedure RemoveEmptyLines(TempList: TStringList);
Var
  I: Integer;
begin
  I := 0;
  While I < TempList.Count do
  begin
    If Ltrim(Rtrim(TempList[I])) = '' then
      TempList.Delete(I)
    else
      inc(I);
  end;
end;

Procedure RemoveLastEmptyLines(TempList: TStrings);
Var
  I: Integer;
begin
  I := TempList.Count - 1; { start from bottom }
  While I > 0 do
  begin
    If Ltrim(Rtrim(TempList[I])) > '' then
      exit
    else
    begin
      If Ltrim(Rtrim(TempList[I])) = '' then
      begin
        TempList.Delete(I);
        Dec(I);
      end
      else
        Dec(I);
    end;
  end;
end;

Procedure LoadLetter(TempList: TStringList; LetterName: String);
Var
  I: Integer;
begin
  If FileExists(Appdir + '\' + LetterName) then
    TempList.LoadFromFile(Appdir + '\' + LetterName)
  else
    For I := 1 to LetterMxParagraphLines do
      TempList.Add('');
end;

Procedure ReplaceKeyWord(Var Txt: String; Cursor_position: Integer;
  KeyWLength: Integer; ReplaceString: String);
begin
  Txt := LeftStr(Txt, Cursor_position - 1) + ReplaceString +
    MidStr(Txt, Cursor_position + KeyWLength + 2, 255);
end;

Function RemoveSpaces(s: string): string;
Var
  I: Integer;
begin
  result := '';
  For I := 1 to Length(s) do
    If s[I] <> ' ' then
      result := result + s[I];
end;

Function IsT3Form(RetNo: Integer; Frm: String): Boolean;
Var
  I: Integer;
begin
  result := False;
  If RetNo < 1 then
    exit;
  If (GetFormType(Frm) = 'T3') or (GetFormType(Frm) = 'TP') or
    (GetFormType(Frm) = 'TA') then
    result := True;
end;

Function IsT3Return(RetNo: Integer): Boolean;
Var
  I: Integer;
begin
  result := False;
  If RetNo < 1 then
    exit;
  If (FetchElm(RetNo, 'T3', 1) > '') or (FetchElm(RetNo, 'T3', 2) > '') then
    result := True;
  // If Ret[RetNo].FrmHasData[GetFormNo('PAGE')] then Result := 'T3';
  If CertificationMode then
    result := True;
end;

Function GetFormType(FormName: string): String;
Var
  I: Integer;
begin
  result := '';
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = ExtractNonInstFormName(FormName) then
    begin
      result := FRec.FormType;
      exit;
    end;
  end;
end;

Function GetWinIniString(IniFileName: String; Sect: String;
  Ident: String): String;
var
  SomeIniFile: TIniFile;
begin
  SomeIniFile := TIniFile.create(IniFileName);
  result := SomeIniFile.ReadString(Sect, Ident, 'Not Found');
  SomeIniFile.free;
end;

Function InQuotes(s: String): String;
{ enclose a string in quotes mailnly for SQL statements }
begin
  result := Chr(39) + s + Chr(39);
end;

Procedure CFZeroAmounts;
begin
end;

Procedure CFFilterLastYrAndStore(RetNo: Integer; FormNm: String; FNo: Integer;
  Elm: Integer; Valu: String);
Var
  I: Integer;
  OldFNo, NewFNo: Integer;
Begin
 if FormNm='EMPL' then
 Begin
  //20181228
  //remittances
  StoreElm(RetNo, FNo, 23, '');
  StoreElm(RetNo, FNo, 25, '');
  StoreElm(RetNo, FNo, 33, '');
  //status
  StoreElm(RetNo, FNo, 17, 'WIP (Work in Progress)');
  StoreElm(RetNo, FNo, 39, 'WIP (Work in Progress)');
  StoreElm(RetNo, FNo, 40, 'WIP (Work in Progress)');
  //div declared
  StoreElm(RetNo, FNo, 37, '');
  StoreElm(RetNo, FNo, 38, '');
 End;


  if GetFormType(FormNm) = 'PA' then
  begin // get certain forms only
    If (LeftStr(FormNm, 8) = 'T5013FIN') or (LeftStr(FormNm, 4) = 'PS8#') or
      (LeftStr(FormNm, 5) = 'PS10#') or ((LeftStr(FormNm, 5) = 'PS50#'))
    // 20130217
    then
    begin
      StoreElm(RetNo, FNo, Elm, Valu);
      exit;
    end
  end
  Else
  begin
    If (GetFormType(FormNm) <> 'PA') then
      StoreElm(RetNo, FNo, Elm, Valu);
  end;

end;

Procedure CFReformatLastYearData(RetNo: Integer);
Var
  I, j, FNo: Integer;
  x, y: Real;
  Inst, s: String;
  Cnt, OldFNo: Integer;
begin
  If RetNo = 0 then
    exit;

  { Private }
  FNo := GetFormNo('PRIVAT');
  If Ret[RetNo].Frm[FNo].Count = 0 then
    InitFormData(RetNo, FNo);
  Calc(RetNo, 'PRIVAT');   //20181217

  { others }
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    FNo := FRec.FormNo;
    If Ret[RetNo].FrmHasData[FNo] then
    begin

    end; { frm has data }
  end; { i }
end;

Function IncrementYear(YYYYMMDD: String): String;
Var
  s: string; // [4];
begin
  s := LeftStr(YYYYMMDD, 4);
  result := IntToStr(MyStrToInt(s) + 1) + MidStr(YYYYMMDD, 5, 6);
end;

Function FormatAmount(FormName, s: string; VerticalSeparator: Integer): string; //20170123 Igor
begin
  Result := FormatAmount(s, VerticalSeparator <> 0);
end;

Function FormatAmount(s: string; VerticalSeparator: Boolean): string; //20170123 Igor
var
//20170621 Igor >>>
  SignPart: String; //[1];
  IntegerPart : String; //[15];
  DecimalPart : String; //[2];
//20170621 Igor <<<
begin
  s := LTrim(s);
  IntegerPart := ExtractIntegerPart(s);
  DecimalPart := ExtractDecimalPart(s);
  If length(DecimalPart) = 0 then
    DecimalPart := '00'
  else
  if length(DecimalPart) = 1 then
    DecimalPart := DecimalPart + '0'
  else
    DecimalPart := Copy(DecimalPart, 1, 2);
  If VerticalSeparator = True then
    Result := InsertCommas(IntegerPart) + '  ' + DecimalPart
  else
    Result := InsertCommas(IntegerPart) + '.' + DecimalPart;
end;

Function FormatTwoDecimals(FormName, s: string): string;
var
  SignPart: string; // [1];
  IntegerPart: String;
  DecimalPart: String;
  { SignPart, IntegerPart, DecimalPart : string; //[20]; }
begin
  s := Ltrim(s);
  IntegerPart := ExtractIntegerPart(s);
  DecimalPart := ExtractDecimalPart(s);
  If Length(DecimalPart) = 0 then
    DecimalPart := '00'
  else if Length(DecimalPart) = 1 then
    DecimalPart := DecimalPart + '0'
  else
    DecimalPart := Copy(DecimalPart, 1, 2);
  If (FormName = 'T1OVP_3') or // j???
    (FormName = 'T1OVP_4') then
    result := IntegerPart
  else
    result := InsertCommas(IntegerPart) + '.' + DecimalPart;
end;

Function IsCharityForm(FrmName: String): Boolean;
begin
  result := False;
  If (FrmName = 'T3010') or (LeftStr(FrmName, 6) = 'T1235#') or
    (LeftStr(FrmName, 6) = 'T1236#') then
    result := True;
end;

Function GetCharityBN(RetNo: Integer): String;
begin
  result := FetchElm(RetNo, 'T3010', 2);
end;

Function GetPrevYearEnd(ThisYearEnd: String; No: Integer): String;
{ in as YYYY-mm-dd }
Var
  k: Integer;
begin
  k := MyStrToInt(LeftStr(ThisYearEnd, 4)) - No;
  result := IntToStr(k) + MidStr(ThisYearEnd, 5, 6)
end;

Function GetCharityYE(RetNo: Integer): String;
begin
  result := FetchElm(RetNo, 'T3010', 1);
end;

// procedure ExecuteForm(AFormClass: TFormClass);
// begin
// with AFormClass.create(Application) do
// begin
// Screen.cursor:= crDefault;
// ShowModal;
// Free;
// end;
// end;

function GetFormAbrevName(FormNo: Integer): String;
var
  I: Integer;
begin
  result := '';
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    if (FRec.FormNo = FormNo) then
      result := FRec.FormAbrev + ' ' + FRec.FormInst;
  end;
end;

Function SubstituteForm(RetNo: Integer; FrmNm: String): String;
{ Var i,NumbFlds,FNo : integer; }
{ during printing }
begin
  result := FrmNm;

  If LeftStr(FrmNm, 6) = 'T5015#' then
  begin
    CopySubstitute(RetNo, FrmNm, 'T5015P');
    result := 'T5015P';
    exit;
  end;
end;

Procedure CopySubstitute(RetNo: Integer; FromFrm, ToFrm: String);
Var
  I, FNo, NumbFlds: Integer;
begin
  FNo := GetFormNo(ToFrm);
  If Ret[RetNo].Frm[FNo].Count = 0 then
    InitFormData(RetNo, FNo);
  { copy data }
  NumbFlds := GetNumbFields(ToFrm);
  If ToFrm = 'T5015P' then
    NumbFlds := 185;
  For I := 1 to NumbFlds do
    Ret[RetNo].Frm[FNo].Strings[I] := FetchElm(RetNo, FromFrm, I);
end;

Function ShouldBeShaded(FName: String; Elm: Integer): Boolean;
begin
  result := False;
end;

Function ShadePenniesOnly(FName: String; ElmNo: Integer): Boolean;
begin
  result := False;

  //20180103
  If (UpperCase(LeftStr(FName, 5)) = 'T4_1') then
  begin
    Case ElmNo of
      18,20,22,23,25,26,27,28,46: result := True;
    end;
  end;

  //20180103
  If (UpperCase(LeftStr(FName, 5)) = 'T4A_1') then
  begin
    Case ElmNo of
      14,15,16,18,19,29,31,33,35,37,39,41,43: result := True;
    end;
  end;

(*
  If (UpperCase(LeftStr(FName, 5)) = 'T3SL1') or
    (UpperCase(LeftStr(FName, 5)) = 'T3SL4') or
    (UpperCase(LeftStr(FName, 6)) = 'T3SL23') then
  begin
    Case ElmNo of
      2 .. 7:
        result := True;
      24, 26, 28:
        result := True;
      30, 32, 34:
        result := True;
      52 .. 57:
        result := True;
      74, 76, 78:
        result := True;
      80, 82, 84:
        result := True;
    end;
  end;
*)
end;

Function PenniesShouldBeShaded(FName: String; Elm: Integer): Boolean;
begin
  result := False;
end;

Function GetOntTONI(Txbl: Real): Real;
begin
  If Txbl <= 30004 then
  begin
    result := Txbl * 6.37 / 100;
    exit;
  end
  else if Txbl <= 60009 then
  begin
    result := (30004 * 6.37 / 100) + (Txbl - 30004) * 9.62 / 100;
    exit;
  end
  else
  begin
    result := (30004 * 6.37 / 100) + 30004 * 9.62 / 100 + (Txbl - 60009) *
      11.16 / 100;
  end;
end;

Function GetBCTONI(Txbl: Real): Real;
begin
  If Txbl <= 30004 then
  begin
    result := Txbl * 8.4 / 100;
    exit;
  end
  else if Txbl <= 60009 then
  begin
    result := (30004 * 8.4 / 100) + (Txbl - 30004) * 12.4 / 100;
    exit;
  end
  else
  begin
    result := (30004 * 8.4 / 100) + 30004 * 12.4 / 100 + (Txbl - 60009) *
      14.4 / 100;
  end;
end;

Function GetMBTONI(Txbl: Real): Real;
begin
  If Txbl <= 30004 then
  begin
    result := Txbl * 8 / 100;
    exit;
  end
  else if Txbl <= 60009 then
  begin
    result := (30004 * 8 / 100) + (Txbl - 30004) * 12.22 / 100;
    exit;
  end
  else
  begin
    result := (30004 * 8 / 100) + 30004 * 12.22 / 100 + (Txbl - 60009) *
      13.63 / 100;
  end;
end;

Function GetTrustTxbl(RetNo: Integer): Real;
begin
  result := Vl(FetchElm(RetNo, 'T3', 272));
end;

Function GetTrustTxblBfrLosses(RetNo: Integer): Real;
begin
  result := MaxR(0, Vl(FetchElm(RetNo, 'T3', 256)) - Vl(FetchElm(RetNo, 'T3',
    265)) - Vl(FetchElm(RetNo, 'T3', 266)));
end;


Function GetClientLettersDir: String;
Var
  Dir: String;
begin
  Dir := OptRec.Dir_Cur + '\' + 'ClientLetters';
  If Not SysUtils.DirectoryExists(Dir) then //20170621 Igor
    if not SysUtils.DirectoryExists(Dir) then //20170621 Igor
    begin
      if not CreateDir(Dir) then
        raise Exception.create('Cannot create letters directory ' + Dir);
    end;
  result := Dir;
end;

Function GetPositionInList(s: String; AlistBox: TFileListBox): Integer;
{ return item index of a given string }
Var
  I: Integer;
begin
  result := -1;
  For I := 0 to AlistBox.Items.Count - 1 do
    If s = AlistBox.Items[I] then
    begin
      result := I;
      exit;
    end;
end;

Function FetchADate: String;
begin
  result := GetCalendar;
end;

Function CountAllT3Slips(RetNo: Integer): Integer;
Var
  I, FNo: Integer;
begin
  result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = 'T3SUPL' then
    begin
      FNo := FRec.FormNo;
      If (Ret[RetNo].FrmHasData[FNo]) and (FetchElmFNo(RetNo, FNo, 1) > '') then
        inc(result);
    end;
  end;
end;

Function CountT2202Slips(RetNo: Integer): Integer;
Var
  I, FNo: Integer;
begin
  result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = 'T2202WS' then
    begin
      FNo := FRec.FormNo;
      If (Ret[RetNo].FrmHasData[FNo]) and (FetchElmFNo(RetNo, FNo, 1) > '') then
        inc(result);
    end;
  end;
end;

Function CountResidentSlips(RetNo: Integer): Integer;
Var
  I, FNo: Integer;
begin
  result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = 'T3SUPL' then
    begin
      FNo := FRec.FormNo;
      If (Ret[RetNo].FrmHasData[FNo]) and (FetchElmFNo(RetNo, FNo, 1) > '') and
        (UpperCase(FetchElmFNo(RetNo, FNo, 41)) = 'Y') then
        inc(result);
    end;
  end;
end;

Function CountPreferredBeneficiaries(RetNo: Integer): Integer;
Var
  I, FNo: Integer;
begin
  result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = 'T3SUPL' then
    begin
      FNo := FRec.FormNo;
      If (Ret[RetNo].FrmHasData[FNo]) and (FetchElmFNo(RetNo, FNo, 1) > '') and
        (UpperCase(FetchElmFNo(RetNo, FNo, 42)) = 'Y') then
        inc(result);
    end;
  end;
end;

Function CountNonResidentBeneficiaries(RetNo: Integer): Integer;
Var
  I, FNo: Integer;
begin
  result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = 'T3SUPL' then
    begin
      FNo := FRec.FormNo;
      If (Ret[RetNo].FrmHasData[FNo]) and (FetchElmFNo(RetNo, FNo, 1) > '') and
        (UpperCase(FetchElmFNo(RetNo, FNo, 41)) = 'N') then
        inc(result);
    end;
  end;
end;

Function GetTotalPreferredAllocation(RetNo: Integer): Real;
Var
  I, FNo: Integer;
begin
  result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = 'T3SUPL' then
    begin
      FNo := FRec.FormNo;
      If (Ret[RetNo].FrmHasData[FNo]) and (FetchElmFNo(RetNo, FNo, 1) > '') and
        (UpperCase(FetchElmFNo(RetNo, FNo, 42)) = 'Y') then
        result := result + Vl(FetchElmFNo(RetNo, FNo, 5)) { box 21 }
          + Vl(FetchElmFNo(RetNo, FNo, 6)) { 22 }
          + Vl(FetchElmFNo(RetNo, FNo, 7)) { 23 }
          + Vl(FetchElmFNo(RetNo, FNo, 8)) { 24 }
          + Vl(FetchElmFNo(RetNo, FNo, 9)) { 25 }
          + Vl(FetchElmFNo(RetNo, FNo, 10)); { 26 }
    end;
  end;
end;


Function AllowPrinting(RetNo: Integer): Boolean;
begin
  result := True;
  If LicenseLevel = llDemo then
  begin
    ShowMessage('Demo program does not allow printing');
    result := False;
    exit;
  end;
end;

Procedure InitConstants; // federal  //20120606
Var
  Cpi: Real;
begin
end;


//20160902
Procedure InitPrvConstants(Prv: String);
Var
  Cpi: Real;
begin

end;



Procedure ClearFields(RetNo, FNo, Ndx1, Ndx2: Integer);
Var
  I: Integer;
begin
  For I := Ndx1 to Ndx2 do
    StoreElm(RetNo, FNo, I, '');
end;


(*
// Var TempList:TStringList;s:String;
begin
  result := OptRec.UseFastPrint;
  // Result := false;
  // TempList := TstringList.Create;
  // TempList.LoadFromFile(AppDir+'\'+'OthOpt.D');
  // s:=TempList[1];
  // If UpperCase(s[30]) = 'Y' then result := True;
  // Templist.Free;
end;
*)
Function PrintVerticalSeparator(FName: String; Elm: Integer): Boolean;
begin
  result := True;
  // if percentages do not print vert separator
  If FName = 'S11' then
  Begin
    Case Elm of
      11, 12, 13, 59, 54, 55, 63, 76, 32, 36, 39, 44, 47:
        result := False;
    end; // case
  end;

  If FName = 'S12' then
  Begin
    Case Elm of
      502, 505, 508, 513, 517, 520, 524, 530, 535, 541, 544, 547:
        result := False;
    end; // case
  end;

  If FName = 'T3AB' then
  Begin
    Case Elm of
      58, 59, 60, 61:
        result := False;
    end; // case
  end;

  If FName = 'T3BC' then
  Begin
    Case Elm of
      11, 12, 13, 69, 76, 32, 36, 39, 44, 47:
        result := False;
    end; // case
  end;

  If FName = 'T3MB' then
  Begin
    Case Elm of
      11, 12, 13, 54, 55, 56, 57, 58, 59:
        result := False;
    end; // case
  end;

  If FName = 'T3NB' then
  Begin
    Case Elm of
      11, 12, 13, 59, 50, 51, 52, 53, 54:
        result := False;
    end; // case
  end;

  If FName = 'T3NS' then
  Begin
    Case Elm of
      11, 12, 13, 50, 51, 52, 53, 54:
        result := False;
    end; // case
  end;

  If FName = 't3NL' then
  Begin
    Case Elm of
      11, 12, 13, 57, 58, 59, 60, 61:
        result := False;
    end; // case
  end;

  If FName = 'T3NU' then
  Begin
    Case Elm of
      11, 12, 13, 59, 63, 64, 65, 66, 67:
        result := False;
    end; // case
  end;

  If FName = 'T3NT' then
  Begin
    Case Elm of
      11, 12, 13, 59, 63, 62, 65, 66, 67:
        result := False;
    end; // case
  end;

  If FName = 'T3ON' then
  Begin
    Case Elm of
      11, 12, 13, 57, 58, 59, 60, 62, 63:
        result := False;
    end; // case
  end;

  If FName = 'T3PE' then
  Begin
    Case Elm of
      11, 12, 13, 57, 58, 59, 60, 61:
        result := False;
    end; // case
  end;

  If FName = 'T3SK' then
  Begin
    Case Elm of
      11, 12, 13, 57, 58, 59, 60, 61:
        result := False;
    end; // case
  end;

  If FName = 'T3YT' then
  Begin
    Case Elm of
      11, 12, 13, 59, 44, 53, 62, 63, 67:
        result := False;
    end; // case
  end;
end;

Procedure AutoFormatDate(Var Value: String);
begin
  If ((Length(Value) = 8) and Numeric(Value)) or (Length(Value) = 10) then
  begin
    Value := RemoveChar(Value, '-');
    Value := RemoveChar(Value, '/');
    Value := LeftStr(Value, 4) + '-' + MidStr(Value, 5, 2) + '-' +
      RightStr(Value, 2);
  end;
end;

(*
Procedure AutoFormatT5013Date(Var Value: String);
begin
  If ((Length(Value) = 8) and Numeric(Value)) or (Length(Value) = 10) then
  begin
    Value := RemoveChar(Value, '-');
    Value := RemoveChar(Value, '/');
    Value := LeftStr(Value, 4) + '/' + MidStr(Value, 5, 2) + '/' +
      RightStr(Value, 2);
  end;
end;
*)
Function ValidCharBn(s: String): Boolean;
begin
  result := True;
  If (Not Numeric(LeftStr(s, 9))) or (Not Numeric(RightStr(s, 4))) or
    (UpperCase(MidStr(s, 10, 2)) <> 'RR') or (Length(s) <> 15) then
    result := False;
end;

procedure ShowPdf(PgmPath, PgmFile: String);
Var
  h: Thandle;
  PgmPathS, PgmS, PgmParmsS: String;
  PgmPathZ: Array [0 .. 254] of Char;
  PgmParmsZ: Array [0 .. 254] of Char;
  PgmZ: Array [0 .. 254] of Char;
begin
  StrPCopy(PgmPathZ, PgmPath);
  PgmS := PgmFile;
  StrPCopy(PgmZ, PgmS);
  PgmParmsS := '';
  StrPCopy(PgmParmsZ, PgmParmsS);
  h := ShellExecute(Application.Handle, Nil, PgmZ, PgmParmsZ, PgmPathZ,
    SW_RESTORE);
  If h <= 32 then
    ShowMessage('File ' + PgmFile + ' not found ');

end;

Procedure ParseWords(s: String; Delim: String; WList: TStrings);
Var
  I, FromI, ToI: Integer;
  Wrd: String;
  { when calling s:=s+delimiter may need a delimiter at the end in case tere is no last value }
begin
  Try
    s := AllTrim(s);
    WList.clear;
    If s = '' then
      exit;
    // s:=s+Delim;
    I := 1;
    FromI := 1;
    ToI := Length(s);
    Repeat
      If (I > ToI) or (s[I] = Delim) then
      begin
        Wrd := MidStr(s, FromI, I - FromI);
        WList.Add(Wrd);
        FromI := I + 1;
        inc(I);
        If (FromI > ToI) or (I > ToI) then
          break;
      end
      else
        inc(I);
    until I > ToI + 1;
  Except
    ShowMessage('Parsing failed');
    // on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
  end; // try
end;

Procedure Delay(ms: Cardinal); //20170621 Igor
Var
  TheTime: Cardinal; //20170621 Igor
begin
  TheTime := GetTickCount + ms;
  While GetTickCount < TheTime do
    Application.ProcessMessages;
end;

Function IsFirstPageOfForm(FormName: String): Boolean;
Var
  I: Integer;
begin
  result := False;
  I := Length(FormName);
  While I > 0 do
  begin
    If (FormName[I] = '_') and (MidStr(FormName, I + 1, 1) = '1') then
    begin
      result := True;
      exit;
    end;
    Dec(I);
  end;
end;

Function GetShowOpenedFormsIndicator: Boolean;
Var
  TempList: TStringList;
  s: String;
begin
  result := False;
  TempList := TStringList.create;
  TempList.LoadFromFile(Appdir + '\' + 'OthOpt.D');
  s := TempList[2];
  If UpperCase(s[30]) = 'Y' then
    result := True;
  TempList.free;
end;

Function ConnectToWeb(Url: String): Boolean;
Var
  h: Thandle;
begin
//20170621 igor >>>
  Screen.Cursor := crHourGlass;
  try
    h := ShellExecute(Application.MainForm.Handle, 'open', Pchar('' + Url), Nil,
      Nil, Sw_Show);
    If h <= 32 then
    begin
      ShowMessage('Connection failed');
      result := False;
    end
    else
      Result := True;
  finally
    Screen.Cursor := crDefault;
  end;
//20170621 igor <<<
end;

Procedure BuildUpdateXmlForWeb(UpdFileName: String);
// the file creared describes the latest version of the update
// and it needs to be uploaded to the web together with the update
Const
  XmLFileName = 'T4T5Update.xml';
Var
  TempList: TStringList;
begin
  UpdFileName := '????T4T5Upd06??????';
  TempList := TStringList.create;
  TempList.Add('<?xml version="1.0" encoding="iso-8859-1"?>');
  TempList.Add('<visualtaxupdate>');
  TempList.Add('<Product>' + AppName + '</Product>');
  TempList.Add('<updateDate>' + AppUpdateDate + '</updateDate>');
  TempList.Add('<version>' + AppRelease + '</version>');
  TempList.Add('<fileName>' + UpdFileName + '</fileName>');
  TempList.Add('<fileDownloadLocation>http://www.visualtax.com/downloads/' +
    '</fileDownloadLocation>');
  TempList.Add('<onlineXmlFileLocation>http://www.visualtax.com/update/' +
    XmLFileName + '</onlineXmlFileLocation>');
  TempList.Add
    ('<descriptionUrl>http://www.visualtax.com/download.htm</descriptionUrl>');
  TempList.Add('<description>For more information click here...</description>');
  TempList.Add('</visualtaxupdate>');
end;

Function GetLastUpdCheck: String;
Var
  TempList: TStringList;
begin
  If not FileExists(Appdir + '\' + 'LastUpdCheck.txt') then
  begin
    result := '';
    exit;
  end;
  TempList := TStringList.create;
  TempList.LoadFromFile(Appdir + '\' + 'LastUpdCheck.txt');
  result := TempList[0];
  TempList.free;
end;

procedure Checkupdates(WindowHandle: Word; AppTitle: String);
Var
  h: Thandle;
  TempList: TStringList; // AppTitle:String;
  spaceDelimiter, quotes, params, PgmPath: string;
begin
  Screen.Cursor := crHourGlass;

  spaceDelimiter := ' ';
  quotes := '"';
  params := spaceDelimiter + quotes + AppTitle + quotes
  // params := spaceDelimiter+quotes+Application.Title+quotes
    + spaceDelimiter + quotes + AppUpdateDate + quotes + spaceDelimiter + quotes
    + AppRelease + quotes + spaceDelimiter + quotes + 'c:\Downloads' + quotes +
    spaceDelimiter + quotes + Appdir + quotes + spaceDelimiter + quotes +
    'http://www.visualtax.com/downloads/vtUpdate/vtVersions.xml' + quotes;

  // Clipboard.asText := params;

  // 20130411 //add path when executing \vtchkupd.exe
  PgmPath := quotes + Appdir + '\vtchkupd.exe' + quotes;
  // C:\Delphi\T1\vtchkupd.exe
  h := ShellExecute(WindowHandle, 'open', Pchar('' + PgmPath),
    Pchar('' + params), Nil, Sw_Show);
  // h := ShellExecute(WindowHandle,'open','VTChkUpd.Exe',Pchar(' '+params),Nil,Sw_Show);

  If h <= 32 then
  begin
    ShowMessage('The Updater program cannot be found.' + Chr(13) +
      'Did you download the VTChkUpd.EXE program' + Chr(13) +
      'and unzipped into the program folder?');
    Screen.Cursor := crDefault;
    exit;
  end;
  // now save the date
  TempList := TStringList.create;
  TempList.Add(FormatDateTime('yyyy-mm-dd', Date));
  TempList.SaveToFile(Appdir + '\' + 'LastUpdCheck.txt');
  TempList.free;
  Screen.Cursor := crDefault;
end;

Function TimeToCheckUpdates: Boolean;
Var
  I: Integer;
  LastUpdateDone: String;
  MM: String;
  DaysFreq: Integer;
  D2, D1: string;
Begin
  LastUpdateDone := GetLastUpdCheck;
  If LastUpdateDone = '' then
  begin
    result := True;
    exit;
  end;
  // there is previous update
  result := False;
  DaysFreq := GetUpdateFrequency;
  If DaysFreq = 0 then
  begin
    result := False;
    exit;
  end;
  D2 := FormatDateTime('yyyy/mm/dd', Date);
  D1 := ReplaceChar(LastUpdateDone, '-', '/'); // =yyyy/mm/dd
  If DateDiffYMD(D1, D2) > DaysFreq then
    result := True;
end;

Function GetUpdateFrequency: Integer;
Var
  TempList: TStringList;
begin
  If FileExists(Appdir + '\' + 'UpdSch.txt') then
  begin // load schedule
    TempList := TStringList.create;
    TempList.LoadFromFile(Appdir + '\' + 'UpdSch.txt');
    result := MyStrToInt(AllTrim(TempList[0]));
  end
  else
    result := 1;
end;

Procedure SetUpdateFrequency(Freq: Integer);
Var
  TempList: TStringList;
begin
  If FileExists(Appdir + '\' + 'UpdSch.txt') then
    exit
  else
  begin // load schedule
    TempList := TStringList.create;
    TempList.Add(IntToStr(Freq));
    TempList.SaveToFile(Appdir + '\' + 'UpdSch.txt');
    TempList.free;
  end
end;

Function CountMultipleInstances(RetNo: Integer; NonInstFormName: String)
  : Integer; { No Instance }
var
  I, FNo: Integer;
begin
  result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    if FRec.FormName = NonInstFormName then
    begin
      If Ret[RetNo].FrmHasData[FRec.FormNo] then
        result := result + 1;
    end;
  end;
end;

Function AllocatedNonResTaxableGains(RetNo: Integer): Real;
Var
  I, FNo: Integer;
begin
  result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = 'T3SUPL' then
    begin
      FNo := FRec.FormNo;
      If (Ret[RetNo].FrmHasData[FNo]) and
        (UpperCase(FetchElmFNo(RetNo, FNo, 41)) = 'N') // non res
      then
        result := result + Vl(FetchElmFNo(RetNo, FNo, 5));
    end;
  end;
  result := result / 2; // taxable
end;

Function AllocatedTaxableGains(RetNo: Integer): Real;
Var
  I, FNo: Integer;
begin
  result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = 'T3SUPL' then
    begin
      FNo := FRec.FormNo;
      If (Ret[RetNo].FrmHasData[FNo]) then
        result := result + Vl(FetchElmFNo(RetNo, FNo, 5));
    end;
  end;
  result := result / 2; // taxable
end;

procedure PrintAtAngle(AText: String; ACanvas: TCanvas; Xpos: Integer;
  YPos: Integer; FontSize: Integer; AtAngle: Integer);
var
  lf: TLogfont;
begin
  // begindoc;
  ACanvas.font.Name := 'Times New Roman'; // 'Arial';
  ACanvas.font.Size := FontSize;
  ACanvas.font.Color := RGB(230, 230, 230); // clSilver;
  ACanvas.font.Style := [fsBold];
  GetObject(ACanvas.font.Handle, Sizeof(lf), @lf);
  lf.lfescapement := AtAngle; // 450;
  lf.lforientation := AtAngle; // 450;
  ACanvas.font.Handle := CreateFontIndirect(lf);
  ACanvas.TextOut(Xpos, YPos, AText);
  ACanvas.font.Handle := 0;
  // EndDoc;
end;

Procedure InsertKeyWToDataDict(FormName: String; AnEditBox: TvtEdit);
Var
  KeyW: String;
  s: String;
  // 20150919 igor
  FDConnection: TADConnection;
  Table1: TADTable;
begin
  // 20150919 Igor
  FDConnection := TADConnection.create(nil);
  Table1 := TADTable.create(nil);
  SetTableName(FDConnection, Table1, Appdir + '\' + DictDBLite, DictTableLite,
    'KeyWord');

  KeyW := ExtractNonInstFormName(FormName) + '_' +
    IntToStr(GetFieldId(AnEditBox.Name));
  if Table1.FindKey([KeyW]) = False then
  Begin
    Table1.Insert;
    Table1.FieldByName('FormName').AsString := ExtractNonInstFormName(FormName);
    Table1.FieldByName('Field_No').AsInteger := GetFieldId(AnEditBox.Name);
    Table1.FieldByName('Descr').AsString := FormName + ' cell number' +
      IntToStr(GetFieldId(AnEditBox.Name));
    If AnEditBox.vtInputType = vtDollar then
      Table1.FieldByName('Is_Amount').AsString := 'Y'
    else
      Table1.FieldByName('Is_Amount').AsString := '';
  end;
  s := InputBox('Input Box', 'Enter a keyWord name for this data field', '');
  If s = '' then
  begin
    ShowMessage('Cancelled');
    Table1.Close;
    exit;
  end;
  s := ReplaceChar(s, ' ', '_');
  s := RemoveChar(s, '#');
  Table1.FieldByName('KeyWord').AsString := s;
  Table1.Post;
  Table1.Close;
  ShowMessage('The keyWord was added with name: ' + s + Chr(13) + ' ' +
    'You can further refine/delete keywords by clicking on Configure | Data Dictionary');
end;

Function GetFldMemFormNo(RetNo: Integer;
  RefFormName, RefFieldId: String): Integer;
Var
  I, FNo: Integer;
  FrmNm: string; // [10];
begin
  result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    if FRec.FormName = 'FLDMEM' then
    begin
      FNo := FRec.FormNo;
      If (FetchElmFNo(RetNo, FNo, 17) = RefFormName) and
        (FetchElmFNo(RetNo, FNo, 18) = RefFieldId) then
        result := FNo;
    end;
  end;
end;

Function GetTrTopicFromLineRef(FormName: String; FieldId: Integer): String;
Var
  I: Integer;
  LineRef: TStringList;
begin
  result := '';
  LineRef := TStringList.create;
  LineRef.LoadFromFile(Appdir + '\' + 'Effields.d');
  For I := 0 to LineRef.Count - 1 do
  begin
    If FormName = AllTrim(MidStr(LineRef[I], 81, 9)) then
    begin
      If FieldId = MyStrToInt(AllTrim(MidStr(LineRef[I], 91, 3))) then
      begin
        result := ReplaceStr(AllTrim(LeftStr(LineRef[I], 4)), '*', '');
        break;
      end;
    end; { same formname }
  end; { i loop }
  LineRef.free;
end;

Function IsValidTrustNo(s: String): Boolean;
// T12345678
begin
  result := True;
  If s = '' then
    exit;
  If UpperCase(LeftStr(s, 1)) <> 'T' then
  begin
    result := False;
    exit;
  end;
  If Length(s) <> 9 then
  begin
    result := False;
    exit;
  end;
  If Not Numeric(MidStr(s, 2, 8)) then
  begin
    result := False;
    exit;
  end;
end;

Function GetFNoOfFirstInstance(FName: String; FNo: Integer): Integer;
begin
  result := FNo;
  If IsFormMultiInst(FName) then
    result := GetFormNo(ExtractNonInstFormName(FName) + '#1');
end;

procedure ImportGifiNotes(RetNo: Integer);
Var
  I, FNo: Integer;
  ImportList: TStringList;
  FlName: String;
begin
  if CheckIsCloud then Exit; //20180503 Igor
  if MessageDlg('This will replace ALL existing data on this form. Proceed??',
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;

  With MainFormT4T5 do
  begin
    OpenDialog.Filter := 'Notes in TXT files(*.TXT)|*.TXT';
    If OpenDialog.Execute then
    begin
      FlName := OpenDialog.FileName;
    end;
  end;
  If FlName = '' then
    exit;

  ImportList := TStringList.create;
  Try
    ImportList.LoadFromFile(FlName);
  except
    ShowMessage('Import failed');
  end;
  FNo := GetFormNo('FNOTE_2');
  For I := 0 to ImportList.Count - 1 do
  begin
    If I > 54 then
      break;
    StoreElm(RetNo, FNo, I + 4, LeftStr(ImportList[I], 78));
  end;
  OpenForm(RetNo, FNo, 0);
  ImportList.free;
end;

Function CountT106Slips(RetNo: Integer): Integer;
Var
  I, FNo: Integer;
begin
  result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = 'T106SL' then
    begin
      FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] then
        inc(result);
    end;
  end;
end;

Function CountT1273(RetNo: Integer): Integer;
Var
  I, FNo: Integer;
begin
  result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = 'T1273_1' then
    begin
      FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] then
        inc(result);
    end;
  end;
end;

Function IsT1273CashMethod(RetNo: Integer; FInst: String): Boolean;
begin
  If FetchElm(RetNo, 'T1273_2' + FInst, 12) = '2' then
    result := True
  else
    result := False;
end;

Function LandscapeFormsInFEDReturn(RetNo: Integer): Boolean;
begin
  result := False;
  If (Ret[RetNo].FrmHasData[GetFormNo('S8#1')]) or
    (Ret[RetNo].FrmHasData[GetFormNo('S9')]) or
    (Ret[RetNo].FrmHasData[GetFormNo('S8FREE#1')]) or
    (Ret[RetNo].FrmHasData[GetFormNo('S35_6')]) or
    (Ret[RetNo].FrmHasData[GetFormNo('S38_6')]) or
    (Ret[RetNo].FrmHasData[GetFormNo('T1273_1')]) then
    result := True;
end;

Function LandscapeFormsInONTReturn(RetNo: Integer): Boolean;
begin
  result := False;
  If (Ret[RetNo].FrmHasData[GetFormNo('OS8#1')]) or
    (Ret[RetNo].FrmHasData[GetFormNo('OPRMTAX')]) then
    result := True;
end;

Function LandscapeFormsInALBReturn(RetNo: Integer): Boolean;
begin
  result := False;
  If (Ret[RetNo].FrmHasData[GetFormNo('AS10')]) or
    (Ret[RetNo].FrmHasData[GetFormNo('AS13')]) then
    result := True;
end;

function ModifyFormOrText(FileToConvertFrom: string;
  ConversionType: String): Boolean;
var
  InputStream, OutputStream: TFileStream;
  FileToConvertTo: string;
begin
  result := True;

  FileToConvertFrom := FileToConvertFrom; // ExtractFileName(FileToConvertFrom);

  FileToConvertTo := FileToConvertFrom;

  { change file extensions as appropriate }
  If ConversionType = 'FORM' then
  begin
    FileToConvertFrom := ChangeFileext(FileToConvertFrom, '.TXT');
    FileToConvertTo := ChangeFileext(FileToConvertFrom, '.DFM');
  end
  Else If ConversionType = 'TEXT' then
  begin
    FileToConvertFrom := ChangeFileext(FileToConvertFrom, '.DFM');
    FileToConvertTo := ChangeFileext(FileToConvertFrom, '.TXT');
  end;
  {
    case ConversionType of
    ConvertToForm:
    begin
    FileToConvertFrom := ChangeFileext(FileToConvertFrom, '.TXT');
    FileToConvertTo := ChangeFileext(FileToConvertFrom, '.DFM');
    end;
    ConvertToText:
    begin
    FileToConvertFrom := ChangeFileExt(FileToConvertFrom, '.DFM');
    FileToConvertTo := ChangeFileExt(FileToConvertFrom, '.TXT');
    end;
    end;
  }
  if not FileExists(FileToConvertFrom) then
  begin
    ShowMessage('File ' + FileToConvertFrom + ' does not exist');
    result := False;
    exit;
  end;
  try
    try
      // Create a file stream for the specified file
      InputStream := TFileStream.create(FileToConvertFrom, fmOpenRead);
      OutputStream := TFileStream.create(FileToConvertTo, fmCreate);

      // perform the selected conversion

      If ConversionType = 'FORM' then
      begin
        ObjectTextToResource(InputStream, OutputStream);
      end
      Else If ConversionType = 'TEXT' then
      begin
        ObjectResourceToText(InputStream, OutputStream);
      end;
      {
        case ConversionType of
        ConvertToForm :
        begin
        ObjectTextToResource(InputStream, OutputStream);
        end;
        ConvertToText :
        begin
        ObjectResourceToText(InputStream, OutputStream);
        end;
        end;
      }
    except
      On EStreamError do
      begin
        result := False;
        ShowMessage('Form Failed: ' + FileToConvertFrom);
      end;
    end;
  finally
    InputStream.free;
    OutputStream.free;
  end;
end;

procedure ModifyAllForms;
// Var  Type TDFMorTXT = (ConvertToForm, ConvertToText);
Var
  I, j: Integer;
  TempList: TStringList;
  FName, DfmFileName: String;
Begin
  Screen.Cursor := crHourGlass;
  TempList := TStringList.create;
  Try
    for I := 0 to FList.Count - 1 do
    begin
      FRec := FList.Items[I];
      FName := FRec.FormInstName;
      DfmFileName := GetDfmFileName(FName);
      If FileExists(DfmFileName) then
      Begin
        // convertDfmtoTxt(ToDir,FlName);
        ModifyFormOrText(DfmFileName, 'TEXT');
        TempList.LoadFromFile(ChangeFileext(DfmFileName, '.txt'));
        for j := 0 to TempList.Count - 1 do
        begin
          if Pos('vtVertSeparator', TempList[j]) > 0 then
          begin
            TempList[j] := '';
          end;
        end;
        TempList.SaveToFile((ChangeFileext(DfmFileName, '.txt')));
        ModifyFormOrText(ChangeFileext(DfmFileName, '.txt'), 'FORM');
      end;
    end;
  Except
    ;
  end;
  Screen.Cursor := crDefault;
  TempList.free;
  ShowMessage('Done');
end;

Function IncrString(s: String; ByValue: Integer): String;
begin
  result := '';
  If s > '' then
    result := IntToStr(MyStrToInt(s) + ByValue);
end;

Procedure FixAProperty;
Var
  I, j: Integer;
  TempList, vtCalcList: TStringList;
  StartPos: Integer;
  FName, DfmFileName: String;
  vtCalcElmName: String;
Begin
  // FIX vtCalc for all forms based on a list with Fname and Elm
  Screen.Cursor := crHourGlass;
  vtCalcList := TStringList.create;
  TempList := TStringList.create;
  vtCalcList.LoadFromFile(Appdir + '\vtCalcLinkList.txt');
  Try
    for I := 0 to vtCalcList.Count - 1 do
    begin
      FName := AllTrim(LeftStr(vtCalcList[I], 10));
      DfmFileName := GetDfmFileName(FName);
      If FileExists(DfmFileName) then
      Begin
        // convertDfmtoTxt(ToDir,FlName);
        ModifyFormOrText(DfmFileName, 'TEXT');
        TempList.LoadFromFile(ChangeFileext(DfmFileName, '.txt'));

        vtCalcElmName := AllTrim(MidStr(vtCalcList[I], 10, 20));
        StartPos := TempList.indexof('  object ' + vtCalcElmName + ': TvtEdit');
        if StartPos > -1 then
        begin
          for j := StartPos to StartPos + 40 do // TempList.count - 1 do
          begin
            if Pos('vtDataSource', TempList[j]) > 0 then
            begin
              if Pos(UpperCase('end'), UpperCase(TempList[j])) > 0 then
              begin
                vtCalcList[I] := paddR(vtCalcList[I], 40) +
                  'Failed..............';
                break;
              end;
              TempList[j] := '    vtDataSource = vtLinked';
              vtCalcList[I] := paddR(vtCalcList[I], 40) + 'Changed!??';
              break;
            end;
          end;
        end
        else
        begin
          vtCalcList[I] := paddR(vtCalcList[I], 40) + 'Failed..............';
        end;
        TempList.SaveToFile((ChangeFileext(DfmFileName, '.txt')));
        vtCalcList.SaveToFile(Appdir + '\vtCalcList.txt');
        // convertTxttoDfm(ToDir,FlName);
        ModifyFormOrText(ChangeFileext(DfmFileName, '.txt'), 'FORM');
      end;
    end;
  Except
    ;
  end;
  vtCalcList.free;
  TempList.free;
  Screen.Cursor := crDefault;
  ShowMessage('Done');
  exit;
end;

Function PrintLabels(const ARetNo: Integer; ATbl: string): Boolean; //20171226 igor
var
  I, RecNo, LineCnt, MxLinesPerPage, PageCnt: Integer;
  Xpos: LongInt;
  YPos: LongInt;
  PixPerInX, PixPerInY: Integer;
  LabelPosX, LabelPosY: Integer;
  TopMargin, LeftMargin, LabelHeight, LabelWidth, VertIncr,
    HorizLabelGap: Integer;
  Line1, Line2, Line3, Line4, Line5: String;
  F: TFRecArray;
  R: TFRec;

  procedure qSort(var A: TFRecArray; min, max, AFieldIndex: Integer);
  var
    i, j: Integer;
    Supp, tmp: TFRec;
  begin
    supp := A[max-((max-min) div 2)];
    i := min;
    j := max;
    while i < j do
    begin
      while FetchElmFNo(ARetNo, A[i].FormNo, AFieldIndex) < FetchElmFNo(ARetNo, supp.FormNo, AFieldIndex) do
        i := i + 1;
      while FetchElmFNo(ARetNo, A[j].FormNo, AFieldIndex) > FetchElmFNo(ARetNo, supp.FormNo, AFieldIndex) do
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
      qSort(A, min, j, AFieldIndex);
    if i < max then
      qSort(A, i, max, AFieldIndex);
  end;

begin
  { Set up label parameters }

  PixPerInX := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
  PixPerInY := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
  TopMargin := Trunc(0.5 * PixPerInY);
  LeftMargin := Trunc(1 / 8 * PixPerInY);
  LabelHeight := Trunc(1 * PixPerInY); { 1 inch }
  LabelWidth := Trunc(2.5 * PixPerInX); { 2.5 inches }
  VertIncr := Trunc(PixPerInY * (1 / 6)); { 6 lines per inch }
  HorizLabelGap := Trunc(1 / 8 * PixPerInX);

  {start printer}
  Printer.BeginDoc;

  F := Ret[ARetNo].FList.GetAllInstForms(ATbl);
  if UpperCase(ATbl) = 'T4' then
    qSort(F, 0, High(F), T4_LASTNAME)
  else if UpperCase(ATbl) = 'T4A' then
    qSort(F, 0, High(F), T4A_LASTNAME)
  else if UpperCase(ATbl) = 'T5' then
    qSort(F, 0, High(F), T5_LASTNAME_FIRSTNAME)
  else
  begin
    Printer.EndDoc;
    Exit;
  end;

  RecNo := 0;
  for R in F do
  begin
    if not RetList[ARetNo].FrmHasData[R.FormNo] then
      Continue;
    inc(RecNo);
    If RecNo > 30 then
    begin
      RecNo := 1;
      Printer.NewPage;
    end;
    if UpperCase(ATbl) = 'T4' then
    begin
      Line1 := AllTrim(FetchElmFNo(ARetNo, R.FormNo, T4_LASTNAME)){Tbl.FieldByName('LASTNAME').AsString} +
               ', ' +
               AllTrim(FetchElmFNo(ARetNo, R.FormNo, T4_FIRSTNAME)){Tbl.FieldByName('FIRSTNAME').AsString};
      Line2 := AllTrim(FetchElmFNo(ARetNo, R.FormNo, T4_STREET)){Tbl.FieldByName('STREET').AsString};
      Line3 := AllTrim(FetchElmFNo(ARetNo, R.FormNo, T4_CITY)){Tbl.FieldByName('CITY').AsString};
      Line4 := AllTrim(FetchElmFNo(ARetNo, R.FormNo, T4_PROV_POSTAL)){Tbl.FieldByName('PROV').AsString
             +',    '+Tbl.FieldByName('POSTAL').AsString};
    end
    else if UpperCase(ATbl) = 'T4A' then
    begin
      Line1 := AllTrim(FetchElmFNo(ARetNo, R.FormNo, T4A_LASTNAME)){Tbl.FieldByName('LASTNAME').AsString} +
               ', ' +
               AllTrim(FetchElmFNo(ARetNo, R.FormNo, T4A_FIRSTNAME)){Tbl.FieldByName('FIRSTNAME').AsString};
      Line2 := AllTrim(FetchElmFNo(ARetNo, R.FormNo, T4A_STREET)){Tbl.FieldByName('STREET').AsString};
      Line3 := AllTrim(FetchElmFNo(ARetNo, R.FormNo, T4A_CITY)){Tbl.FieldByName('CITY').AsString};
      Line4 := AllTrim(FetchElmFNo(ARetNo, R.FormNo, T4A_PROV)){Tbl.FieldByName('PROV').AsString} +
               ',    '+
               AllTrim(FetchElmFNo(ARetNo, R.FormNo, T4A_POSTAL)){Tbl.FieldByName('POSTAL').AsString};
    end
    else if UpperCase(ATbl) = 'T5' then
    begin
      Line1 := AllTrim(FetchElmFNo(ARetNo, R.FormNo, T5_LASTNAME_FIRSTNAME)){Tbl.FieldByName('LASTNAME').AsString +
               ', ' + Tbl.FieldByName('FIRSTNAME').AsString};
      Line2 := AllTrim(FetchElmFNo(ARetNo, R.FormNo, T5_STREET)){Tbl.FieldByName('STREET').AsString};
      Line3 := AllTrim(FetchElmFNo(ARetNo, R.FormNo, T5_CITY)){Tbl.FieldByName('CITY').AsString};
      Line4 := AllTrim(FetchElmFNo(ARetNo, R.FormNo, T5_PROV_POSTAL)){Tbl.FieldByName('PROV').AsString +
               ',    '+Tbl.FieldByName('POSTAL').AsString};
    end;

    If RecNo < 11 then { left label }
    begin
      LabelPosX := LeftMargin;
      LabelPosY := TopMargin + (RecNo - 1) * LabelHeight;
    end;
    If (RecNo > 10) and (RecNo < 21) then { Midle label }
    begin
      LabelPosX := LeftMargin + LabelWidth + HorizLabelGap;
      LabelPosY := TopMargin + (RecNo - 11) * LabelHeight;
    end;
    If (RecNo > 20) and (RecNo < 31) then { right label }
    begin
      LabelPosX := LeftMargin + 2 * LabelWidth + 3 * HorizLabelGap;
      LabelPosY := TopMargin + (RecNo - 21) * LabelHeight;
    end;
    PrintALabel(LabelPosX, LabelPosY, Line1, Line2, Line3, Line4, Line5);
  end;
  Printer.EndDoc;
  result := True;
end;

Procedure PrintALabel(LabelPosX, LabelPosY: Integer;
  Line1, Line2, Line3, Line4, Line5: String);
{ pos in pixels }
Var
  Xpos, YPos, VertIncr, PixPerInX, PixPerInY: Integer;
begin
  Printer.Canvas.font.Name := 'Arial';
  PixPerInX := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
  PixPerInY := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
  Printer.Canvas.font.Size := 8;
  Xpos := LabelPosX + 2;
  YPos := LabelPosY + 2;
  VertIncr := Trunc(PixPerInY * (1 / 6));
  Printer.Canvas.font.Style := [fsBold];
  Printer.Canvas.TextOut(Xpos, YPos, Line1);
  Printer.Canvas.font.Style := [];
  Printer.Canvas.TextOut(Xpos, YPos + 1 * VertIncr, Line2);
  Printer.Canvas.TextOut(Xpos, YPos + 2 * VertIncr, Line3);
  Printer.Canvas.TextOut(Xpos, YPos + 3 * VertIncr, Line4);
  Printer.Canvas.TextOut(Xpos, YPos + 4 * VertIncr, Line5);
end;

Procedure InitPredictiveFiles;
Var
  TempList: TStringList;
begin
  exit;
  TempList := TStringList.create;
  TempList.Add(' ');
  If FileExists(Appdir + '\' + 'CorpBn.txt') = False then
    TempList.SaveToFile(Appdir + '\' + 'CorpBn.txt');

  If FileExists(Appdir + '\' + 'CorpNm.txt') = False then
    TempList.SaveToFile(Appdir + '\' + 'CorpNm.txt');

  If FileExists(Appdir + '\' + 'Cities.txt') = False then
    TempList.SaveToFile(Appdir + '\' + 'Cities.txt');

  If FileExists(Appdir + '\' + 'Charity.txt') = False then
    TempList.SaveToFile(Appdir + '\' + 'Charity.txt');
end;

Function FindWord(ThisWord, Ln: String): Integer;
Var
  Place: Integer;
begin
  result := Pos(UpperCase(ThisWord), UpperCase(Ln));
end;

procedure ConvertMostRecentFiles; // 20230116 Igor
var
  L: TStringList;
  i: Integer;
  cRow, cName, cDate, cTime, cFile, cDir: string;
  NeedSave: Boolean;
begin
  if not FileExists(AppDir + '\' + RecentRFlName) then
    exit;
  NeedSave := false;
  L := TStringList.Create;
  try
    L.LoadFromFile(AppDir + '\' + RecentRFlName);
    for i := 0 to L.Count - 1 do
    begin
      cRow := L.Strings[i];
      if cRow.IsEmpty then
        continue;
      if Pos(RecentDelim, cRow) > 0 then
        Break;
      cName := Trim(Copy(cRow, 1, 30));
      cDate := Trim(Copy(cRow, 31, 10));
      cTime := Trim(Copy(cRow, 42, 11));
      cFile := Trim(Copy(cRow, 54, 15));
      cDir := Trim(Copy(cRow, 104, Length(cRow)));
      cRow := cName + RecentDelim + cDate + RecentDelim + cTime + RecentDelim +
        cFile + RecentDelim + cDir;
      L.Strings[i] := cRow;
      NeedSave := True;
    end;
    if NeedSave then
      L.SaveToFile(AppDir + '\' + RecentRFlName);
  finally
    L.Free;
  end;
end;

Procedure InitMostRecentFiles(HowMany: Integer);
//20171201 Igor>>>
var
  I: Integer;
  s: string;
  TempList: TStringList;
  ADConnection: TADConnection;
  AQuery: TADQuery;
begin
  TempList := TStringList.create;
  try
    try
      ADConnection := TADConnection.create(Application);
      AQuery := TADQuery.create(Application);
      try
        SqlLoadDBFromFile(ADConnection, AQuery, OptRec.Dir_Cur + '\' + ClientsDBLite, '');
        if ADConnection.Connected then
        begin
          with AQuery do
          begin
            SQL.Add('Select * from ' + ClientsTableLite);
            SQL.Add(' ORDER BY Updated_Dt DESC');
            Prepare;
            open;
            First;
            while not EOF do
            begin
              //20230117 Igor >>>
              //20230116 Igor >>>
              s := AllTrim(AQuery.FieldByName('CORP_NAME').AsString) + RecentDelim +
                AQuery.FieldByName('Updated_Dt').AsString + RecentDelim +
                AQuery.FieldByName('Updated_tm').AsString + RecentDelim +
                AQuery.FieldByName('File_Name').AsString + RecentDelim +
                OptRec.Dir_Cur;
              //20230116 Igor <<<
              //20230117 Igor <<<
              TempList.Add(s);
              if TempList.Count > HowMany then
                break;
              Next;
            end;
          end;
        end;
      finally
        AQuery.Close;
        AQuery.free;
        ADConnection.free;
      end;
    except
      on E: Exception do
        MessageDlg(E.Message, mtError, [mbok], 0);
    end; // except
    //20230117 Igor >>>
    (*
    for I := 0 to TempList.Count - 1 do
      TempList[I] := TempList[I] + ' ' + OptRec.Dir_Cur; // add the dir
    *)
    //20230117 Igor <<<
    TempList.SaveToFile(Appdir + '\' + RecentRFlName);
  finally
    TempList.free;
  end;
//20171201 Igor<<<
end;

(*
Procedure InitMostRecentFiles(HowMany: Integer);
//20171201 Igor>>>
var
  I: Integer;
  s: string;
  TempList: TStringList;
  ADConnection: TADConnection;
  AQuery: TADQuery;
begin
  TempList := TStringList.create;
  try
    try
      ADConnection := TADConnection.create(Application);
      AQuery := TADQuery.create(Application);
      try
        SqlLoadDBFromFile(ADConnection, AQuery, OptRec.Dir_Cur + '\' + ClientsDBLite, '');
        if ADConnection.Connected then
        begin
          with AQuery do
          begin
            SQL.Add('Select * from ' + ClientsTableLite);
            SQL.Add(' ORDER BY Updated_Dt DESC');
            Prepare;
            open;
            First;
            while not EOF do
            begin
              s := paddR(AllTrim(AQuery.FieldByName('CORP_NAME').AsString), 30) +
                paddR(AQuery.FieldByName('Updated_Dt').AsString, 11) +
                paddR(AQuery.FieldByName('Updated_tm').AsString, 12) +
                paddR(AQuery.FieldByName('File_Name').AsString, 12);
              TempList.Add(s);
              if TempList.Count > HowMany then
                break;
              Next;
            end;
          end;
        end;
      finally
        AQuery.Close;
        AQuery.free;
        ADConnection.free;
      end;
    except
      on E: Exception do
        MessageDlg(E.Message, mtError, [mbok], 0);
    end; // except
    for I := 0 to TempList.Count - 1 do
      TempList[I] := TempList[I] + ' ' + OptRec.Dir_Cur; // add the dir
    TempList.SaveToFile(Appdir + '\' + RecentRFlName);
  finally
    TempList.free;
  end;
//20171201 Igor<<<
end;
*)
Procedure UpdateMostRecentFiles(RetNo: Integer; Dir, FlName, Sin: String);
Var
  I, k, MaxReturns: Integer;
  TempList1, TempList2: TStringList;
  s, cName: String; //20180314 Igor
Begin
  //20180314 Igor >>>
  cName := FetchElm(RetNo, GetFormNo('STATUS'), c_FileDescription);
  if cName = '' then
    cName := GetRetName(RetNo);
  //20180314 Igor <<<
  TempList1 := TStringList.create;
  TempList2 := TStringList.create;
  If FileExists(Appdir + '\' + RecentRFlName) then
    TempList1.LoadFromFile(Appdir + '\' + RecentRFlName);
  //20230116 Igor >>>
  s := cName + RecentDelim +
       FormatDateTime('yyyy-mm-dd', Date) + RecentDelim +
       TimeToStr(Time) + RecentDelim +
       FlName + RecentDelim +
       Dir;
  //20230116 Igor <<<
  // First remove it if it exists
  k := IsInMostRecentReturns(FlName, TempList1);
  If k > -1 then
    TempList1.Delete(k);
  // then add it as first
  TempList2.Add(s);
  // add the existing ones
  MaxReturns := TempList1.Count - 1;
  If MaxReturns > 30 then
    MaxReturns := 30;
  For I := 0 to MaxReturns do
    TempList2.Add(TempList1[I]);
  // save it
  TempList2.SaveToFile(Appdir + '\' + RecentRFlName);
  TempList1.free;
  TempList2.free;

  MainFormT4T5.ShowMostRecentReturns;
end;


(*
Procedure UpdateMostRecentFiles(RetNo: Integer; Dir, FlName, Sin: String);
Var
  I, k, MaxReturns: Integer;
  TempList1, TempList2: TStringList;
  s: String;
Begin
  TempList1 := TStringList.create;
  TempList2 := TStringList.create;
  If FileExists(Appdir + '\' + RecentRFlName) then
    TempList1.LoadFromFile(Appdir + '\' + RecentRFlName);
  s := LeftStr(paddR(GetRetName(RetNo), 30), 30) +
    paddR(FormatDateTime('yyyy-mm-dd', Date), 11) + paddR(TimeToStr(Time), 12) +
    paddR(FlName, 50) // PaddR(FlName,12)    //20100216
    + Dir;
  // First remove it if it exists
  k := IsInMostRecentReturns(FlName, TempList1);
  If k > -1 then
    TempList1.Delete(k);
  // then add it as first
  TempList2.Add(s);
  // add the existing ones
  MaxReturns := TempList1.Count - 1;
  If MaxReturns > 30 then
    MaxReturns := 30;
  For I := 0 to MaxReturns do
    TempList2.Add(TempList1[I]);
  // save it
  TempList2.SaveToFile(Appdir + '\' + RecentRFlName);
  TempList1.free;
  TempList2.free;

  MainFormT4T5.ShowMostRecentReturns;
end;
*)
Function GetAdminPswrd(UserName: string): String;
Var
  ADConnection: TADConnection;
  Table1: TADTable;
begin
  result := '';

  // 20150919 Igor
  ADConnection := TADConnection.create(Application);
  Table1 := TADTable.create(Application);
  SetTableName(ADConnection, Table1, Appdir + '\' + UserDBLite,
    UserTableLite, 'Name');

  if Table1.FindKey([UserName]) = True then
    result := Table1.FieldByName('Pswd').AsString;

  Table1.free;
  ADConnection.free;
end;

Function GetTrFolder: String;
Var
  TempList: TStringList;
begin
  result := '';
  TempList := TStringList.create;
  If FileExists(Appdir + '\' + 'TrFolder.d') then
  begin
    TempList.LoadFromFile(Appdir + '\' + 'TrFolder.d');
    result := TempList[0];
    TempList.free;
    exit;
  end;
end;

Function IsTrLoaded: Boolean;
begin
  If GetTrHandle <> 0 then
    result := True
  Else
    result := False;
end;

Function GetTrHandle: HWND;
begin
  result := FindWindow(Pchar('TTrEngine'), Nil);
end;

Procedure LinkToTR(SearchItem: String);
Var
  h: Thandle;
begin
  TrFolder := GetTrFolder;
  h := GetTrHandle;
  If h <> 0 then
  begin
    ShowWindow(h, SW_MAXIMIZE);
    Clipboard.AsText := 'From T2|Search|' + SearchItem;
    Application.Minimize;
  end
  else
  begin
    Application.Minimize;
    LoadTr(TrFolder);
  end
end;

Procedure LoadTr(TrFolder: String);
Var
  h: Thandle;
begin
  // the t22005 uses Tr2004.exe !
  h := ShellExecute(MainFormT4T5.Handle, Nil,
    Pchar('' + TrFolder + '\TR2005.EXE'), Nil, '', SW_RESTORE);
  // Pchar(''+TrFolder+'\TR'+IntToStr(AppYearInt-1)+'.EXE'), Nil,'', SW_RESTORE);

  // Delay(2000);
  If h <= 32 then
    ShowMessage('TR was not installed in ' + TrFolder);
end;

Function InitDataBase(Appdir: string; DataDir: string): Boolean;
//20170803 Igor>>>
var
  Err: String;
begin
  result := CopyDB(AppT4T5_2026.ClientsDBLite, Appdir, DataDir, Err);
  if not Result then
    MessageDlg(Err, mtError, [mbOk], 0);
//20170803 Igor<<<
end;

Function GetHowToFormat(FrmName: String; Elm: Integer): Integer;
begin
  result := 0; { no decimals }
  If ((FrmName = 'AT1_1') and ((Elm = 42) or (Elm = 43))) then
    result := 0;
  If LeftStr(FrmName, 3) = 'INVOICE' then
    result := 2;
  // 20160215 //20160305 Igor
  If (FrmName = 'T3NL') and ((Elm = 74) Or (Elm = 94)) then
    result := 0;
end;

Function ReformatSin(s: string): String;
begin
  result := LeftStr(s, 3) + '-' + MidStr(s, 4, 3) + '-' + RightStr(s, 3);
  If result = '--' then
    result := '';
end;

Function GetEmptyInstance(RetNo: Integer; FormName: String): Integer;
//20170118 Igor >>>
Var
  I: integer;
  InstForms: TFRecArray;
begin
  InstForms := FList.GetAllInstForms(FormName);
  for i := 0 to length(InstForms) - 1 do
    If not Ret[RetNo].FormHasData[GetFormName(InstForms[i].FormNo, RetNo)] then //20170130 Igor
      Exit(ExtractFormInstNo(InstForms[i].FormInst));
  Result := ExtractFormInstNo(InstForms[length(InstForms) - 1].FormInst) + 1;
//20170118 Igor >>>
end;

Function GetFldTapeFormNo(RetNo: Integer;
  RefFormName, RefFieldId: String): Integer;
Var
  I, FNo: Integer;
  FrmNm: string; // [10];
begin
  result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    if FRec.FormName = 'FLDTAPE' then
    begin
      FNo := FRec.FormNo;
      If (FetchElmFNo(RetNo, FNo, 121) = RefFormName) and
        (FetchElmFNo(RetNo, FNo, 122) = RefFieldId) then
        result := FNo;
    end;
  end;
end;

Function IsInMostRecentReturns(FlName: String;
  MostRecentList: TStringList): Integer;
var
  I, LengthOfKeyWord: Integer;
  A: TArray<string>; //20230116 Igor
begin
  result := -1;
  If MostRecentList.Count = 0 then
    exit;
  FlName := AllTrim(FlName);
  //20230116 Igor >>>
  For i := 0 to MostRecentList.Count - 1 do
  begin
    A := MostRecentList[i].Split([RecentDelim]);
    if Length(A) >= 4 then
      if SameText(FlName, A[3]) then
      begin
        Result := i;
        exit;
      end;
  end;
  //20230116 Igor <<<
end;

Function CountErrorType(AuditList: TStringList; Category: String): Integer;
Var
  I: Integer;
begin
  result := 0;
  For I := 0 to AuditList.Count - 1 do
  begin
    If UpperCase(LeftStr(AuditList[I], 1)) = Category then
      inc(result);
  end;
end;

Function CountDBRecords: Integer;
var
  ADConnection: TADConnection;
  Table1: TADTable;
begin
  // 20150923 Igor
  ADConnection := TADConnection.create(Application);
  Table1 := TADTable.create(Application);
  SetTableName(ADConnection, Table1, OptRec.Dir_Cur + '\' + ClientsDBLite,
    ClientsTableLite, '');

  result := Table1.RecordCount;
  Table1.Close;
  Table1.free;
  ADConnection.free;
end;

Function GetFormRlNm(FName: String): String;
Var
  I: Integer;
begin
  result := '';
  result := Rtrim(FName);
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FName = FRec.FormName then
      result := FRec.FormRlNm;
  end;
End;

Procedure GetLoginNames(TempList: TStrings);
begin
  If FileExists(Appdir + '\' + 'LoginNames') then
    TempList.LoadFromFile(Appdir + '\' + 'LoginNames');
end;

Procedure UpdateLoginNames(Nm: String);
Var
  TempList: TStringList;
begin
  TempList := TStringList.create;
  Nm := UpperCase(Nm);
  If FileExists(Appdir + '\' + 'LoginNames') then
    TempList.LoadFromFile(Appdir + '\' + 'LoginNames');
  If IsInList(Nm, TempList) < 0 then
    TempList.Add(Nm);
  TempList.SaveToFile(Appdir + '\' + 'LoginNames');
  TempList.free;
end;

procedure ReplaceRtfText(ARichEdit: TRichEdit; InSearch, InReplace: string);
var
  x, ToEnd: Integer; // TempRichEdit:TRichEdit;
begin

  with ARichEdit do
  begin
    Visible := False;
    x := 0;
    ToEnd := Length(ARichEdit.Text);
    x := FindText(InSearch, x, ToEnd, []);
    while x <> -1 do
    begin
      SelStart := x;
      SelLength := Length(InSearch);
      SelText := InReplace;
      x := FindText(InSearch, x + Length(InReplace), ToEnd, []);
    end;
    Visible := True;
  end; // with
end;

Procedure ConvertOldLetter(ARichEdit: TRichEdit);
Var
  s: AnsiString;
Begin
  ARichEdit.SelStart := 0;
  ARichEdit.SelectAll;
  // ARichEdit.Paragraph.Alignment := taLeftJustify;
  ReplaceRtfText(ARichEdit, '[If]', '[If (');
  ReplaceRtfText(ARichEdit, '[If ([', '[If (');
  ReplaceRtfText(ARichEdit, '[If ( [', '[If (');
  ReplaceRtfText(ARichEdit, '[Nested_If]', '[If (');
  ReplaceRtfText(ARichEdit, '[Nested_If ([', '[If (');
  ReplaceRtfText(ARichEdit, '[Nested_If ( [', '[If (');
  ReplaceRtfText(ARichEdit, '[Nested_Endif]', '[Endif');

  ReplaceRtfText(ARichEdit, ']>', ')>])');
  ReplaceRtfText(ARichEdit, '] >', ')>])');
  ReplaceRtfText(ARichEdit, ']<', ')<])');
  ReplaceRtfText(ARichEdit, '] <', ')<])');
End;

Function CleanUpKeyW(KeyW: String): String;
// comes as If (keywxxx > 0)  etc > < || ! && etc
// also Need Ffix in front of dollar variables
Var
  k: Integer;
  LKeyW: Integer;
begin
  result := KeyW;
  LKeyW := Length(KeyW);
  If UpperCase(LeftStr(KeyW, 4)) = 'IF (' then
    KeyW := MidStr(KeyW, 5, LKeyW);
  If UpperCase(LeftStr(KeyW, 3)) = 'IF(' then
    KeyW := MidStr(KeyW, 4, LKeyW);
  If UpperCase(LeftStr(KeyW, 7)) = 'ELSIF (' then
    KeyW := MidStr(KeyW, 8, LKeyW);
  If UpperCase(LeftStr(KeyW, 6)) = 'ELSIF(' then
    KeyW := MidStr(KeyW, 7, LKeyW);
  k := Pos('=', KeyW);
  If k > 0 then
    KeyW := AllTrim(LeftStr(KeyW, k - 1));
  k := Pos('>', KeyW);
  If k > 0 then
    KeyW := AllTrim(LeftStr(KeyW, k - 1));
  k := Pos('<', KeyW);
  If k > 0 then
    KeyW := AllTrim(LeftStr(KeyW, k - 1));
  k := Pos('||', KeyW);
  If k > 0 then
    KeyW := AllTrim(LeftStr(KeyW, k - 2));
  k := Pos('&&', KeyW);
  If k > 0 then
    KeyW := AllTrim(LeftStr(KeyW, k - 2));
  k := Pos('!', KeyW);
  If k > 0 then
    KeyW := AllTrim(LeftStr(KeyW, k - 1));
  result := KeyW;
end;

Function IsConditionalRtfStatement(KeyW: String): Boolean;
// for letters
begin
  result := False;
  If (UpperCase(LeftStr(KeyW, 4)) = 'IF (') Or
    (UpperCase(LeftStr(KeyW, 3)) = 'IF(') Or
    (UpperCase(LeftStr(KeyW, 7)) = 'ELSIF (') Or
    (UpperCase(LeftStr(KeyW, 6)) = 'ELSIF(') then
    result := True;
end;

Procedure GetDelimiterPositionsInRtf(ARichEdit: TRichEdit; SearchText: string;
  DelimList: TStrings);
var
  k, StartPos, FoundAt, Endpos: Integer;
begin
  // ARichEdit.HideScrollbars:=True;
  ARichEdit.SelStart := 0;
  ARichEdit.SelLength := 0;
  with ARichEdit do
  begin
    k := 0;
    Endpos := Length(ARichEdit.Text);
    k := FindText(SearchText, k, Endpos, []);
    while k <> -1 do
    begin
      If k <> -1 then
        DelimList.Add(IntToStr(k));
      k := FindText(SearchText, k + Length(SearchText), Endpos, []);
    end;
  end; // with
  // ARichEdit.SelStart := 0;
  With ARichEdit do
  begin
    // SetFocus;
    SelStart := Perform(EM_LINEINDEX, 0, 0);
    SelLength := 0;
  end;

  // ARichEdit.HideScrollbars:=False;
end;

Function GetPrintSequence(FName: string): String;
begin
  result := FList.ByFormName(FName).PrnSeq;
  if result = '' then
    result := '999';
end;

Function FirstTimeClient(RetNo: Integer): Boolean;
begin
  // ????
  result := False;
  // If UpperCase(FetchElm(RetNo,'INFO',88))='X' then result:=True;
end;

Procedure ReadTheValue(TempList: TStringList; FrmNm: String;
  Elm1, Elm2: Integer; Var Val1: String; Var Val2: String);
{ templist is the tax return data }
Var
  I, j: Integer;
  WList: TStringList;
  Rec: String;
begin
  Val1 := '';
  Val2 := '';
  WList := TStringList.create;
  For I := 1 to TempList.Count - 2 do // -2 otherwise it abends
  begin
    Rec := TempList[I];
    ParseWords(Rec, Delimiter, WList);
    If (WList[0] = 'F') and (WList[1] = FrmNm) then
    begin
      j := I + 1;
      Repeat
        Rec := TempList[j];
        ParseWords(Rec, Delimiter, WList);
        If (WList[0] = 'D') then
        begin
          If Vl(WList[1]) = Elm1 then
            Val1 := WList[2];
          If Vl(WList[1]) = Elm2 then
            Val2 := WList[2];
        end;
        inc(j);
      until (j > TempList.Count - 2) or (LeftStr(Rec, 2) = 'F' + Delimiter);
      { end form data }
    end; { within form nm }
  end; { i }
  WList.free;
end;

Procedure ReplaceRtfDelimiters(ARichEdit: TRichEdit;
  FromDelim, ToDelim: String);
begin
  ARichEdit.SelStart := 0;
  ARichEdit.SelectAll;
  ARichEdit.Paragraph.Alignment := paLeftJustify; // 20160819 Igor
  ReplaceRtfText(ARichEdit, FromDelim, ToDelim);
end;

procedure InsertBackFunction(ARichEdit: TRichEdit;
  InSearch, InSecondSearch, InReplace: string);
var
  x, y, ToEnd: Integer;
begin
  with ARichEdit do
  begin
    Visible := False;
    x := 0;
    ToEnd := Length(ARichEdit.Text);
    x := FindText(InSearch, x, ToEnd, []);
    while x <> -1 do
    begin
      y := x;
      y := FindText(InSecondSearch, y, ToEnd, []);
      SelStart := y;
      SelLength := Length(InSecondSearch);
      SelText := InReplace;
      x := FindText(InSearch, y + Length(InReplace), ToEnd, []);
    end;
    Visible := True;
  end; // with
end;

function ConvertToProper(sBuffer: string): string;
var
  iLen, iIndex: Integer;
begin
  iLen := Length(sBuffer);
  sBuffer := UpperCase(MidStr(sBuffer, 1, 1)) +
    Lowercase(MidStr(sBuffer, 2, iLen));

  for iIndex := 0 to iLen do
  begin
    if MidStr(sBuffer, iIndex, 1) = ' ' then
      sBuffer := MidStr(sBuffer, 0, iIndex) +
        UpperCase(MidStr(sBuffer, iIndex + 1, 1)) +
        Lowercase(MidStr(sBuffer, iIndex + 2, iLen));
  end;
  result := sBuffer;
end;


Function GetKeyWListFromRichEdit(ARichEdit: TRichEdit;
  KeyWList: TStrings): Boolean;
Var
  I: Integer;
  Delim1List, Delim2List: TStringList;
  KeyW: String;
begin
  result := True;
  Delim1List := TStringList.create;
  Delim2List := TStringList.create;
  GetDelimiterPositionsInRtf(ARichEdit, '[', Delim1List);
  GetDelimiterPositionsInRtf(ARichEdit, ']', Delim2List);

  If Delim1List.Count <> Delim2List.Count then
  Begin
    Delim1List.free;
    Delim2List.free;
    result := False;
    exit;
  end;

  For I := 0 to Delim1List.Count - 1 do
  begin
    With ARichEdit do
    Begin
      SelStart := MyStrToInt(Delim1List[I]) + 1;
      SelLength := MyStrToInt(Delim2List[I]) - MyStrToInt(Delim1List[I]) - 1;
      KeyW := SelText;
      KeyW := CleanUpKeyW(KeyW);
      If IsInList(KeyW, KeyWList) = -1 then
      begin
        If KeyW > '' then
          KeyWList.Add(KeyW);
      end;
    end;
  end;
  // ARichEdit.SelStart := 0;
  With ARichEdit do
  begin
    // SetFocus;
    SelStart := Perform(EM_LINEINDEX, 0, 0);
    SelLength := 0;
  end;
  Delim1List.free;
  Delim2List.free;
end;

Function IsDevelopmentMode: Boolean;
begin
  If FileExists(Appdir + '\' + 'Main.pas') then
    result := True
  else
    result := False;
end;

Function DeleteReturn(Dir, FlName: String): Boolean;
Var
  ADConnection: TADConnection;
  Table1: TADTable;
begin
  result := False;
  If FileExists(Dir + '\' + FlName) then
    SysUtils.DeleteFile(Dir + '\' + FlName);
  // 20150923 Igor
  ADConnection := TADConnection.create(Application);
  Table1 := TADTable.create(Application);
  SetTableName(ADConnection, Table1, Dir + '\' + ClientsDBLite,
    ClientsTableLite, 'FILE_NAME');

  if Table1.FindKey([FlName]) = True then
  begin
    Table1.Edit;
    Table1.Delete;
    result := True;
  end;
  Table1.Close;
  Table1.free;
  ADConnection.free;
end;

Function GetFormHeight(FName: string): Integer;
Var
  I: Integer;
begin
  result := 1050;
  FName := ExtractNonInstFormName(FName);
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = FName then
    begin
      if FRec.FormHeight < 700 then
        result := 700
      else
        result := FRec.FormHeight;
      exit;
    end;
  end;
end;

function GetFormNumberFields(FNo: Integer): Integer;
begin
  result := FList.GetFormNumberFields(FNo);
end;

function GetMaxFormNumber: Integer;
var
  I: Integer;
  mFormNum: Integer;
begin
  result := FormsLimit;
  exit; // we use 600

  mFormNum := 0;
  for I := (FList.Count - 1) downto 0 do
  begin
    FRec := FList.Items[I];
    if (FRec.FormNo > mFormNum) then
    begin
      mFormNum := FRec.FormNo
    end;
  end;
  result := mFormNum;
end;

Procedure GetPrinterDriversNames(AList: TStrings);
Var
  I: Integer;
begin
  For I := Printer.Printers.Count - 1 downto 0 do
    AList.Add(Printer.Printers[I]);
end;

Procedure RemovePGMPsw;
Const
  ActivationFile = 'LVerf.EX_';
Var
  TempList: TStringList;
begin
  TempList := TStringList.create;
  If FileExists(Appdir + '\' + ActivationFile) then
    TempList.LoadFromFile(Appdir + '\' + ActivationFile);
  If TempList.Count < 3 then
  begin
    TempList.free;
    exit;
  end;
  TempList[2] := '';
  TempList.SaveToFile(Appdir + '\' + ActivationFile);
  TempList.free;
end;

Function GetPGMPsw: String;
// returns the unencrypted
Const
  ActivationFile = 'LVerf.EX_';
Var
  TempList: TStringList;
begin
  result := '';
  TempList := TStringList.create;
  If FileExists(Appdir + '\' + ActivationFile) then
  begin
    TempList.LoadFromFile(Appdir + '\' + ActivationFile);
    If TempList.Count = 3 then
      result := DecryptPsw(TempList[2], 9999);
  end;
  TempList.free;
end;

Function IncrementlastBackUpDir(LastBackUp: String): String;
Var
  k: Integer;
  OldNo, NewNo: String;
begin
  OldNo := RightStr(LastBackUp, 2);
  If NumbersOnly(OldNo) then
  begin
    NewNo := PaddZero(IntToStr(MyStrToInt(OldNo) + 1), 2);
    result := LeftStr(LastBackUp, Length(LastBackUp) - 2) + NewNo;
  end
  else
    result := ExtractFileDir(LastBackUp) + '\' + 'Backup01';
end;

Function GetCopiesToPrint(FName: string; TemplForms: TStringList;
  TemplCopies: TStringList): String;
Var
  j: Integer;
begin
  result := '0';
  For j := 0 to TemplForms.Count - 1 do
    If ExtractNonInstFormName(FName) = TemplForms[j] then
    begin
      result := TemplCopies[j];
      exit;
    end;
end;

Function IncludeFormInPrint(RetNo: Integer; FNm: String): Boolean;
// Var RetNo:Integer;
begin
  result := True;
end;


//20170219 Igor >>> Moveto T4T5_2026Declare
//const
//  PswElm = 25;
//  c_LastYearElm = 32;
//20170219 Igor <<<

Function GetReturnPsw(DataDir, FlName: string): String;
begin
  GetFilePsw(DataDir, FlName, PswElm, result,
    AppT4T5_2026.SQLLitePassword.PassRFArray); // 20160415 Igor
end;

function CheckReturnPsw(DataDir, FlName: string): Integer;
begin
  result := CheckFilePsw(DataDir, FlName, PswElm,
    AppT4T5_2026.SQLLitePassword.PassRFArray); // = iorReported; //20160415 Igor
end;

function CheckReturnAndPsw(DataDir, FlName: string): Boolean;
begin
  result := CheckFileAndPsw(DataDir, FlName, PswElm,
    AppT4T5_2026.SQLLitePassword.PassRFArray); // 20160415 Igor
end;

Procedure StoreReturnPsw(RetNo: Integer; RetPsw: String);
begin
  StoreElm(RetNo, GetFormNo('STATUS'), PswElm, EncryptPsw(RetPsw, 9999));
end;

Procedure RemoveReturnPsw(RetNo: Integer);
begin
  StoreElm(RetNo, GetFormNo('STATUS'), PswElm, '');
end;

Procedure CreateDefaultDataDirectories;
Var LastYearApp:String;
Begin
  //20170902 Igor >>>
  if not CheckIsCloud(true) and (LicenseLevel in AnyLimited) then //20180503 Igor
  begin
    if not SysUtils.DirectoryExists(LimitedVersionDir) then //20150702
      if not SysUtils.ForceDirectories(LimitedVersionDir) then
      begin
        ShowMessage('Data directory ' + LimitedVersionDir + ' cannot be created');
      end;
    if not SysUtils.FileExists(IncludeTrailingPathDelimiter(LimitedVersionDir) + AppT4T5_2026.ClientsDBLite) then //20150702
      if not InitDataBase(AppDir, LimitedVersionDir) then
        exit
      else
        ShowMessage('A Data Directory has been created: ' + LimitedVersionDir);
    SaveSingleOption('Dir_Cur', LimitedVersionDir);
    SaveSingleOption('Dir_Deflt', LimitedVersionDir);
  end
  else //not limited version
  begin
    If (SysUtils.DirectoryExists(DefaultDataDir(AppT4T5_2026) + '\Data') = False) or //20170621 Igor
      (Not FileExists(DefaultDataDir(AppT4T5_2026) + '\Data' + '\' + ClientsDBLite)) then
    // 20150923 Igor
    begin
      if not SysUtils.ForceDirectories(DefaultDataDir(AppT4T5_2026) + '\Data') then //20170621 Igor
      begin
        ShowMessage('Data directory ' + DefaultDataDir(AppT4T5_2026) + '\Data' + ' cannot be created');
        exit;
      end;
      If InitDataBase(Appdir, DefaultDataDir(AppT4T5_2026) + '\Data') then
        if not CheckIsCloud(true) then //20180503 Igor
        ShowMessage('A default Data Directory has been created: ' + DefaultDataDir(AppT4T5_2026) +
          '\Data' + Chr(13) +
          'You can change it via Configure | General options');
    end;
    SaveSingleOption('Dir_Cur', DefaultDataDir(AppT4T5_2026) + '\Data');
    SaveSingleOption('Dir_Deflt', DefaultDataDir(AppT4T5_2026) + '\Data');
    //20181217 CON
    if OptRec.Dir_PgmLastYr='' then
    Begin
     LastYearApp:='C:\VT-'+IntToStr(StrToInt(AppYear)-1)+'\T4T5-'+IntToStr(StrToInt(AppYear)-1);     //i.e C:\vt-2017\T4T5-2017
     SaveSingleOption('Dir_PgmLastYr', 'C:\'+LastYearApp+'\T4T5-'+LastYearApp);   //201812
    end;
  end;
  //20170902 Igor <<<
end;

(*
Procedure CreateDefaultDataDirectories;
Begin
  If (SysUtils.DirectoryExists(Appdir + '\Data') = False) or //20170621 Igor
    (Not FileExists(Appdir + '\Data' + '\' + ClientsDBLite)) then
  // 20150923 Igor
  begin
    if not SysUtils.ForceDirectories(Appdir + '\Data') then //20170621 Igor
    begin
      ShowMessage('Data directory ' + Appdir + '\Data' + ' cannot be created');
      exit;
    end;
    If InitDataBase(Appdir, Appdir + '\Data') then
      ShowMessage('A default Data Directory has been created: ' + Appdir +
        '\Data' + Chr(13) +
        'You can change it via Configure | General options');
  end;
  SaveSingleOption('Dir_Cur', Appdir + '\Data');
  SaveSingleOption('Dir_Deflt', Appdir + '\Data');

end;
*)

Procedure ExtractSectionLabels(FName: String; LblSectList: TStringList;
  SomeList: TStrings);
Var
  I, j: Integer;
  s: String;
begin
  For I := 0 to LblSectList.Count - 1 do
  begin
    s := LblSectList[I];
    If AllTrim(LeftStr(s, 10)) = FName then // got right rec
    begin
      If AllTrim(MidStr(s, 81, 15)) = '' then // it is a header rec
      begin
        SomeList.Add(s);
        For j := I + 1 to LblSectList.Count - 1 do // get lbls related to fname
        begin
          s := LblSectList[j];
          If AllTrim(MidStr(s, 82, 10)) = FName then
            SomeList.Add(s)
          else
            exit; // begin  LblSectList.Free; Exit; end;
        end; // j
      end; // header rec
    end; // found fname
  end; // i
end;

function GetInterpetedRichEdit(RetNo: Integer; LetterName: String;
  ARichEdit: TRichEdit): Boolean; // 20160819 Igor
Var
  I, j: Integer;
  errorC: Boolean;
  Txt: string;
  Memo1: TMemo;
  KeyWList: TStringList;
  TempFileName: String;
  EkRtf1: TEkRtf;
  AStream: TMemoryStream;
  KeyW: String;
  FName, FName1: String;
  Elm: Integer;
  IsAmount: String;
  LineNumber: Integer;
  Args: TEkUdfArgs;
  ArgCount: Integer;
  aResult: TEkReportVariable; // TObject;
Begin
  result := False; // 20160819 igor
  if Not FileExists(LetterName) then
  begin
    ShowMessage('Template ' + LetterName + ' was not found');
    exit;
  end;
  ARichEdit.ReadOnly := False;

  ARichEdit.Visible := False;
  ARichEdit.Lines.LoadFromFile(LetterName);
  KeyWList := TStringList.create;
  LoadDataDict;
  GetKeyWListFromRichEdit(ARichEdit, KeyWList);

  KeyWList.SaveToFile(Appdir + '\' + 'Temp1.txt');
  With MainFormT4T5.EkRtf1 do
  begin
    ClearVars;
    For I := 0 to KeyWList.Count - 1 do
    begin
      KeyW := KeyWList[I];
      DataDictList.GetKeyWAttributes(KeyW, FName, Elm, IsAmount);
      FormatSettings.DecimalSeparator := '.'; // 20150805 Igor
      If UpperCase(LeftStr(IsAmount, 1)) = 'Y' then
        CreateVar(KeyW, Vl(FetchElm(RetNo, FName, Elm)))

      else If KeyW = 'Date' then
        CreateVar(KeyW, DateToMonthDayYear(Date))
      else If KeyW = 'This_TaxYear' then
        CreateVar(KeyW, Appyear)
      else If KeyW = 'Next_TaxYear' then
        CreateVar(KeyW, IntToStr(AppYearInt + 1))

      else If LeftStr(KeyW, 5) = 'Form_' then
      begin
        IsAmount := '';
        FName1 := UpperCase(AllTrim(MidStr(KeyW, 6, 10)));
        If FormHasInstanceIndicator(RetNo, FName1) then
          FName1 := FName1 + '#1';
        If GetFormNo(FName1) > 0 then
        begin
          If Ret[RetNo].FrmHasData[GetFormNo(FName1)] then
            CreateVar(KeyW, 'Y') // Form =Yes meaning has data
          else
            CreateVar(KeyW, 'N');
        end;
      end // form_
      Else
      begin
        If ((KeyW = 'Client_CorporateName') or (KeyW = 'Client_Address1') or
          (KeyW = 'Client_Address2') or (KeyW = 'Client_City') or
          (KeyW = 'Client_Contact')) then
        begin
          If OptRec.UseProperName then
            CreateVar(KeyW, ConvertToProper(FetchElm(RetNo, FName, Elm)))
          else
            CreateVar(KeyW, FetchElm(RetNo, FName, Elm));
        end
        else
          CreateVar(KeyW, FetchElm(RetNo, FName, Elm));
      end;
    end;

    // NOW REPLACE $+brackets with slashes and currency function for EKRTF formating
    InsertBackFunction(ARichEdit, '$[', ']', ', 2)]');
    InsertBackFunction(ARichEdit, '$ [', ']', ', 2)]');

    ReplaceRtfDelimiters(ARichEdit, '$[', '[fcur(');
    ReplaceRtfDelimiters(ARichEdit, '$ [', '[fcur(');

    // NOW REPLACE brackets with slashes for EKRTF
    // and Put the display FIXR for formatting before streaming it
    ReplaceRtfDelimiters(ARichEdit, '[', KeyWDelimiter1);
    ReplaceRtfDelimiters(ARichEdit, ']', KeyWDelimiter2);
    AddDisplayFormatToRtf(ARichEdit, KeyWList);

    ARichEdit.Visible := True;
    KeyWList.free;

    ARichEdit.Lines.SaveToFile(Appdir + '\' + 'TempRtf.rtf'); // 20160819 igor
    InFile := Appdir + '\' + 'TempRtf.rtf'; // LetterName; //20160819 Igor
    AStream := TMemoryStream.create;
    Try
      ExecuteStream([], AStream);
      ARichEdit.Lines.LoadFromStream(AStream);
      result := True; // 20160819 igor
    Except
      result := False; // 20160819 Igor
    end;
    AStream.free;
  end; // with
end;

Procedure AddDisplayFormatToRtf(ARichEdit: TRichEdit; KeyWList: TStringList);
// i.e. [Taxable_amount] s/b FNum(Taxable_amount)
begin
  //
end;

Function GetLetterFileName(RetNo: Integer; FName: String): String;
Begin
  If FName = 'CLETTER' then
  begin
    result := GetClientLettersDir + '\' + MkClientLetterName(RetNo);
    If FileExists(result) then
      exit; // special letter
    result := Appdir + '\' + 'PaperFiledLetter.RTF';
    (*
      If IsEfiled(RetNo) then
      Result := AppDir+'\'+'EfiledLetter.RTF'
      else
      Result := AppDir+'\'+'PaperFiledLetter.RTF';
    *)
  end;
  If FName = 'PIPEDA' then
    result := Appdir + '\' + 'PIPEDALetter.RTF';
  If FName = 'ENGAGE' then
    result := Appdir + '\' + 'EngagementLetter.RTF';
  If FName = 'CUSTINV' then
    result := Appdir + '\' + 'CustInvLetter.RTF';
  If FName = 'ALETTER' then
    result := Appdir + '\' + SomeLetterName; // global variable
End;

Function LinkToSelf(InitialFormName: String; TargetFormName: String): Boolean;
begin
  result := False;
  If ExtractFormRootName(InitialFormName) = ExtractFormRootName(TargetFormName)
  then
    result := True;
end;

Procedure GetFrmDataListFromFullDataList(FrmNm: String; DataList: TStringList;
  FrmDataList: TStrings);
// data list is image of disk file
Var
  I, j, ElmNo: Integer;
  WList: TStringList;
  Rec: String;
begin
  // ????
  Try
    j := 0;
    FrmDataList.clear;
    If LeftStr(DataList[0], 4) <> 'T4T5' then
      exit;
    WList := TStringList.create;
    For I := 1 to DataList.Count - 1 do
    begin
      Rec := DataList[I];
      ParseWords(Rec + Delimiter, Delimiter, WList);
      If (WList[0] = 'F') and (WList[1] = FrmNm) then // found frm record
      begin
        // j:=i+1;
        For j := I + 1 to DataList.Count - 1 do
        begin
          Rec := DataList[j];
          ParseWords(Rec + Delimiter, Delimiter, WList);
          If LeftStr(Rec, 2) = 'F' + Delimiter then
            exit;
          If (WList[0] = 'D') then
            FrmDataList.Add(Rec);
        end;
      end; // frm found
    end; // i
  except
    ShowMessage(Rec);
  end; // try
end;

Procedure GetElmsInError(RetNo: Integer; FName: String);
Var
  I: Integer;
  AuditFName: String;
  Rec: TAuditRec;
begin
  ElmsInError.clear;
  FName := AllTrim(UpperCase(FName));
  For I := 0 to Ret[RetNo].AuditList.Count - 1 do
  begin
    Rec := Ret[RetNo].AuditRec[I];
    if Rec.Form = FName then
      ElmsInError.AddObject(Rec.Description, Rec);
  end;
end;

Function IsFieldInElmsInError(s: String; AList: TStringList): Integer;
{ return item index of a given string }
Var
  I: Integer;
begin
  result := -1;
  s := AllTrim(UpperCase(s));
  For I := 0 to AList.Count - 1 do
  begin
    If s = AllTrim(UpperCase(LeftStr(AList[I], 3))) then
    begin
      result := I;
      exit;
    end;
  end;
end;

function GetFormAbrevNameWithNoInst(FormNo: Integer): String;
var
  I: Integer;
begin
  result := '';
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    if (FRec.FormNo = FormNo) then
      result := FRec.FormAbrev;
  end;
end;

Function FieldHasAddingTape(RetNo: Integer; FName: String;
  Elm: Integer): Boolean;
var
  I: Integer;
Begin
  result := False;
end;

Function GetDfmFormsDir: String;
begin
  If IsDevelopmentMode then
    result := Appdir + '\' + 'TFForms'
  else
    result := Appdir;
end;

Function IsFormAClientLetter(FName: String): Boolean;
begin
  result := False;
  If (FName = 'CLETTER') or (FName = 'PIPEDA') or (FName = 'ENGAGE') or
    (FName = 'CUSTINV') or (FName = 'ALETTER') // for miscellaneous letters
  then
    result := True;
end;

Function GetAnyPathMoreThan8Chars(Dir: String): String;
Var
  I: Integer;
  WList: TStringList;
  { returns dir part that is more than 8 chars, else nil }
begin
  result := '';
  WList := TStringList.create;
  ParseWords(Dir, '\', WList);
  For I := 0 to WList.Count - 1 do
  begin
    If Length(WList[I]) > 8 then
    begin
      result := WList[I];
      WList.free;
      exit;
    end;
  end;
  WList.free;
end;

Function ValidEMail(s: String): Boolean;
Begin
  result := True;
  If s = '' then
    exit;
  if (Pos('@', s) <= 0) or (Pos('.', s) <= 0) Then
    result := False;
end;

Function RealNumeric(s: string): Boolean;
Var
  I: Integer;
begin
//20170621 Igor >>>
  If s.IsEmpty then
    Exit(False);
  For I := 1 to Length(s) do
    If not CharInSet(s[I], ['.', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) then
      exit(False);
  Result := True;
//20170621 Igor <<<
end;

Function CopyMoveReturn(CopyOrMove: String; FromDir: String; ToDir: String;
  FlName: String): Boolean;
Var
  ForceResult, CopyResult, InitDbResult: Boolean;
  ReadResult: Integer;
  PrpStatus, EFstatus, Notes: String;
  RetNo: Integer;
begin
  result := False;
  CopyResult := False;
  InitDbResult := False;
  // 20160327 Igor >>>
  If FileExists(ToDir + '\' + ClientsTable_dbf) then // 20160227 Igor
  begin
    ShowMessage(ToDir + Chr(13) +
      'The data directory is NOT compatible with the Multi-App version.' + #13 +
      'Please use another data directory, such as ' + OptRec.Dir_Cur +
      ' in the Copy/Move window');
    exit;
  end;
  // 20160327 Igor <<<
  If Not SysUtils.DirectoryExists(ToDir) then //20170621 Igor
  begin
    ForceResult := SysUtils.ForceDirectories(ToDir); //20170621 Igor
    If ForceResult = False then
      exit;
  end;
  CopyResult := CopyFile(FromDir + '\' + FlName, ToDir + '\' + FlName);
  If CopyResult = False then
    exit;
  // init db if not thre
  If Not FileExists(ToDir + '\' + ClientsDBLite) then // 20150923 Igor
  begin
    InitDbResult := InitDataBase(Appdir, ToDir);
    if InitDbResult = False then
      exit;
  end;
  // read file
  RetNo := ReadReturn(ToDir, FlName, False);
  If RetNo < 1 then
    exit;
  // ????
  PrpStatus := FetchElm(RetNo, 'STATUS', 4);
  If Not Numeric(PrpStatus) then
    PrpStatus := '00';
  EFstatus := FetchElm(RetNo, 'STATUS', 15);
  If Not Numeric(EFstatus) then
    EFstatus := '00';
  Notes := FetchElm(RetNo, 'STATUS', 14);
  UpdateClientsTable(RetNo, ToDir, FlName);
  UpdateMostRecentFiles(RetNo, ToDir, FlName, GetAccountNumber(RetNo));
  If RetNo > 0 then
    RemoveReturnFromMemory(RetNo);
  If CopyOrMove = 'M' then
    DeleteReturn(FromDir, FlName);
  result := True;
end;

Procedure LoadEditBoxProperties;
// as in T4T5-2011 before combined forms //20130112
var
  I, CompIndex, k, n, FNo, Elm, NumForms, NumEditBoxes: Integer;
  FormsDir, DfmFileName, FName: string;
  Test1: Tform;
  TempList: TStringList;
  s: String;
begin
  TfPropDynList.free; // if already exists
  TfPropDynList := TStringList.create;
  TfPropDynList.LoadFromFile(Appdir + '\' + 'T4T5PropDyn.d');
end;

Function StripInstNo(FormName: String): string;
var { T4#1  yields T4 }
  I: Integer;
begin
  I := 1;
  while (I <= Length(FormName)) and not(FormName[I] = '#') do
    inc(I);
  result := Copy(FormName, 1, I - 1);
end;

Procedure ResortFormsToPrint(FormsToPrint: TStringList);
// comes as sssnFFFFFFFFF  i.e. 1011T2125-1#1
// take the -1#1 and put it under the sss then resort
var
  I, k1, k2: Integer;
  TempList: TStringList;
  Rec: String;
  SeqNo: Integer;
  SeqNoString: String;
begin
  SeqNo := 0; // new seq
  TempList := TStringList.create;

  FormsToPrint.Sorted := False;
  For I := 0 to FormsToPrint.Count - 1 do
  begin
    Rec := FormsToPrint[I];
    k1 := Pos('_', Rec);
    k2 := Pos('#', Rec);
    If (k1 > 0) and (k2 > 0) then
    begin
      TempList.Add(LeftStr(Rec, 4) + paddR(AllTrim(MidStr(Rec, k2, 3)), 3) +
        paddR(AllTrim(MidStr(Rec, k1, 3)), 3) + MidStr(Rec, 5, 10));
    end
    else
    begin
      TempList.Add(LeftStr(Rec, 4) + Space(6) + MidStr(Rec, 5, 10));
    end;
  end;

  TempList.Sorted := True;

  FormsToPrint.clear;
  For I := 0 to TempList.Count - 1 do
  begin
    Rec := TempList[I];
    FormsToPrint.Add(LeftStr(Rec, 4) + MidStr(Rec, 11, 20));
  end;
  TempList.free;
end;

Function GetPrintTemplate: string;
begin
  { select print set }
  result := '';
  SomeList.clear; // := TStringList.Create;
  SomeCaption := 'Select Print Template';
  SomeList.Add('CRA');
  SomeList.Add('Client');
  SomeList.Add('Preparer');
  SomeList.Add('Other 1');
  SomeList.Add('Other 2');
  SomeList.Add('Other 3');
  SelectedString := PopSomeList(SomeList, SomeCaption);
  If SelectedString = 'CRA' then
    result := 'RVCANSET.D'
  else if SelectedString = 'Client' then
    result := 'CLINTSET.D'
  else if SelectedString = 'Preparer' then
    result := 'PREPSET.D'
  else if SelectedString = 'Other 1' then
    result := 'OTH1SET.D'
  else if SelectedString = 'Other 2' then
    result := 'OTH2SET.D'
  else if SelectedString = 'Other 3' then
    result := 'OTH3SET.D';
end;

Function AllowedToFormPrint(RetNo: Integer; FormName: String): Boolean;
begin
  result := True;

end;

Function AllowedToFullPrint(RetNo: Integer): Boolean;
begin
  result := True;

end;

Function CreateNewDataDir: String;
var
  DataDir: string; // [60];
  ThisResult: Integer;
  ClickedOK: Boolean;
begin
  DataDir := Appdir + '\Data';
  DataDir := InputBox('Create Data Directory', 'Enter Full path', DataDir);
  ThisResult := CreateDataDirectory(Appdir, DataDir);
  Case ThisResult of
    0:
      ShowMessage('Directory successfully created');
    -1:
      ShowMessage('Directory already exists!');
    -2:
      ShowMessage('Directory already contains a client data base');
    -3:
      ShowMessage('Directory cannot be created');
    -4:
      ShowMessage('Cannot initialize the Data Base');
    -5:
      ShowMessage('You must use a sub-directory i.e. D:\xxx');
  end;
  If ThisResult = 0 then
    result := DataDir
  else
    result := '';
end;

Function CreateDataDirectory(Appdir: string; DataDir: string): Integer;
{ return codes
  0 : OK
  -1 : Directory exists
  -2 : Already contains data base
  -3 : Dir cannot be created
  -4 : Cannot copy Data Bases
}
begin
  result := 0;
  If SysUtils.DirectoryExists(DataDir) then //20170621 igor
  begin
    result := -1;
    exit;
  end;
  If FileExists(DataDir + '\' + ClientsDBLite) then // 20150923 Igor
  begin
    result := -2;
    exit;
  end;

  { now create and copy data bases }
{$I-}   { so that the ioresult can be effective }
  MkDir(DataDir);
  if IOResult <> 0 then
  begin
    result := -3;
    exit;
  end;

  If InitDataBase(Appdir, DataDir) = False then
  begin
    result := -4;
    exit;
  end;

end;

Function IsOkToOpenReturn(DataDir: String; FlName: String; Sin: String)
  : Boolean;
Var
  s: String;
Begin
  result := False;
  If FlName = '' then
    exit;
  If Not FileExists(DataDir + '\' + ClientsDBLite) then // 20150923 Igor
  begin
    ShowMessage('Data directory has not been defined' + Chr(13) +
      'Use Configure | Data Directories');
    exit;
  end;

  result := True;
end;

Procedure IsAnyWhereInList(Astring: String; AList, ResultsList: TStrings);
var
  I, j, LengthOfKeyWord: Integer;
  s: String;
begin
  j := 0;
  Astring := UpperCase(AllTrim(Astring));
  LengthOfKeyWord := Length(Astring);
  For I := 0 to AList.Count - 1 do
  begin
    j := Pos(Astring, UpperCase(AList[I]));
    If j > 0 then
    begin
      s := paddR(AllTrim(IntToStr(I)), 4);
      ResultsList.Add(s + AList[I]);
    end;
  end;
end;

Function IsExactlyInList(Astring: String; SomeList: TStringList): Integer;
var
  I: Integer;
begin
  result := -1;
  For I := 0 to SomeList.Count - 1 do
    if AllTrim(Astring) = AllTrim(SomeList[I]) then
    begin
      result := I;
      exit;
    end;
end;

Function ValidShortProvince(s: string): Boolean;
Var
  I: Integer;
begin
  result := False;
  For I := Low(PrvShort) to High(PrvShort) do
    If s = PrvShort[I] then
    begin
      result := True;
      exit;
    end
end;

Function IsFormTheDefaultSearch: Boolean;
Var
  TempList: TStringList;
  s: String;
begin
  result := OptRec.UseFormSearch;
end;

Procedure ConvertCfgToOptionsFile(CfgTbl: TDataSet);
Var
  TempList, TempList1: TStringList;
begin
  With CfgTbl do
  Begin
    FormatSettings.DecimalSeparator := '.'; // 20150805 Igor
    TempList := TStringList.create;
    SaveOptionValue('Dir_Cur', FieldByName('Dir_Cur').AsString, TempList);
    SaveOptionValue('Dir_Deflt', FieldByName('Dir_Deflt').AsString, TempList);
    SaveOptionValue('Dir_LastYr', FieldByName('Dir_LastYr').AsString, TempList);
    SaveOptionValue('Dir_PrvLYr', FieldByName('Dir_PrvLYr').AsString, TempList);
    SaveOptionValue('Dir_DBFData', FieldByName('Dir_DBFData').AsString,
      TempList);
    SaveOptionValue('Dir_Train', FieldByName('Dir_Train').AsString, TempList);
    SaveOptionValue('Dir_Sample', FieldByName('Dir_Sample').AsString, TempList);

    SaveOptionValue('Prp_Name', FieldByName('Prp_Name').AsString, TempList);
    // SaveOptionValue('Prp_TransmitterNo',FieldByName('Prp_Name').AsString,TempList);

    SaveOptionValue('Prp_Street', FieldByName('Prp_Street').AsString, TempList);
    SaveOptionValue('Prp_City', FieldByName('Prp_City').AsString, TempList);
    SaveOptionValue('Prp_Prov', FieldByName('Prp_Prov').AsString, TempList);
    SaveOptionValue('Prp_Postal', FieldByName('Prp_Postal').AsString, TempList);
    SaveOptionValue('Prp_Countr', FieldByName('Prp_Countr').AsString, TempList);
    SaveOptionValue('Prp_Area', FieldByName('Prp_Area').AsString, TempList);
    SaveOptionValue('Prp_Tel', FieldByName('Prp_Tel').AsString, TempList);
    SaveOptionValue('Prp_FxArea', FieldByName('Prp_FxArea').AsString, TempList);
    SaveOptionValue('Prp_Fax', FieldByName('Prp_Fax').AsString, TempList);
    SaveOptionValue('Prp_DiscNo', FieldByName('Prp_DiscNo').AsString, TempList);
    SaveOptionValue('Prp_DiscNm', FieldByName('Prp_DiscNm').AsString, TempList);
    SaveOptionValue('Prp_GSTNo', FieldByName('Prp_GstNo').AsString, TempList);
    SaveOptionValue('Prp_VSFee', IntToStr(FieldByName('Prp_VSFee').AsInteger),
      TempList);
    SaveOptionValue('Prp_SFee', IntToStr(FieldByName('Prp_SFee').AsInteger),
      TempList);
    SaveOptionValue('Prp_AFee', IntToStr(FieldByName('Prp_AFee').AsInteger),
      TempList);
    SaveOptionValue('Prp_CFee', IntToStr(FieldByName('Prp_CFee').AsInteger),
      TempList);
    SaveOptionValue('Prp_VCFee', IntToStr(FieldByName('Prp_VCFee').AsInteger),
      TempList);
    SaveOptionValue('Prp_Kstrk', FormatFloat('######.##',
      FieldByName('Prp_Kstrk').AsFloat), TempList);
    SaveOptionValue('Prp_Hour', FormatFloat('######.##', FieldByName('Prp_Hour')
      .AsFloat), TempList);
    SaveOptionValue('Prp_Bill', FieldByName('Prp_Bill').AsString, TempList);

    SaveOptionValue('Prp_Elect',
      BooleanToString(Boolean(FieldByName('Prp_Elect').AsInteger)), TempList);
    SaveOptionValue('Prp_EfRepr',
      BooleanToString(Boolean(FieldByName('Prp_EfRepr').AsInteger)), TempList);
    SaveOptionValue('Prp_Dates',
      BooleanToString(Boolean(FieldByName('Prp_Dates').AsInteger)), TempList);

    SaveOptionValue('Nfl_Prov', FieldByName('Nfl_Prov').AsString, TempList);
    { New File defqaults }
    SaveOptionValue('Nfl_City', FieldByName('Nfl_City').AsString, TempList);
    // SaveOptionValue('Nfl_Disced',FieldByName('Nfl_Disced').AsString,TempList);
    // SaveOptionValue('Nfl_Efile',BooleanToString(FieldByName('Nfl_EFile').As Boolean),TempList);

    SaveOptionValue('Prn_Shade',
      BooleanToString(Boolean(FieldByName('Prn_Shade').AsInteger)), TempList);
    SaveOptionValue('Prn_Head',
      BooleanToString(Boolean(FieldByName('Prn_Head').AsInteger)), TempList);
    SaveOptionValue('Prn_NameH',
      BooleanToString(Boolean(FieldByName('Prn_NameH').AsInteger)), TempList);
    SaveOptionValue('Prn_SinH',
      BooleanToString(Boolean(FieldByName('Prn_SinH').AsInteger)), TempList);
    SaveOptionValue('Prn_DateH',
      BooleanToString(Boolean(FieldByName('Prn_DateH').AsInteger)), TempList);
    SaveOptionValue('Prn_Disclm', FieldByName('Prn_Disclm').AsString, TempList);
    SaveOptionValue('Prn_Logo',
      BooleanToString(Boolean(FieldByName('Prn_Logo').AsInteger)), TempList);
    SaveOptionValue('Opr_Recalc',
      BooleanToString(Boolean(FieldByName('Opr_Recalc').AsInteger)), TempList);
    SaveOptionValue('Opr_Close',
      BooleanToString(Boolean(FieldByName('Opr_Close').AsInteger)), TempList);
    SaveOptionValue('Opr_FPres', IntToStr(FieldByName('Opr_FPres').AsInteger),
      TempList);
    SaveOptionValue('Opr_GSTHst', FormatFloat('######.##',
      FieldByName('Opr_GSTHst').AsFloat), TempList);

    // other options
    TempList1 := TStringList.create;
    If FileExists(Appdir + 'OthOpt.d') then
    Begin
      TempList1.LoadFromFile(Appdir + 'OthOpt.d');
      SaveOptionValue('ShowFinWarning', FromYesToX(TempList1[1]), TempList);
      SaveOptionValue('ShowConsultantOnInv', FromYesToX(TempList1[2]),
        TempList);
      SaveOptionValue('UseFastPrint', FromYesToX(TempList1[3]), TempList);
      SaveOptionValue('UseProperName', FromYesToX(TempList1[3]), TempList);
      SaveOptionValue('UseFormSearch', FromYesToX(TempList1[4]), TempList);
      SaveOptionValue('OtherSlipsButtons', FromYesToX(TempList1[4]), TempList);
      SaveOptionValue('UseBusUseOfHome', FromYesToX(TempList1[5]), TempList);
      SaveOptionValue('RolloverT4T5', FromYesToX(TempList1[6]), TempList);
      SaveOptionValue('ShowVisitedForms', FromYesToX(TempList1[7]), TempList);
      SaveOptionValue('ShowInvoiceWarning', FromYesToX(TempList1[8]), TempList);
      SaveOptionValue('ShowInvoiceEfCharge', FromYesToX(TempList1[9]),
        TempList);
      SaveOptionValue('ShowSaluteWarning', FromYesToX(TempList1[10]), TempList);
      SaveOptionValue('CVSetting', TempList1[11], TempList);
      SaveOptionValue('T1013AuthorLevel', TempList1[12], TempList);
    end;
    // update frequency
    TempList1.clear;
    If FileExists(Appdir + '\' + 'UpdSch.Txt') then
    begin
      TempList1.LoadFromFile(Appdir + '\' + 'UpdSch.Txt');
      SaveOptionValue('UpdateFrequency', TempList1[0], TempList);
    end;

    // Ef_method
    TempList1.clear;
    If FileExists(Appdir + '\' + 'EfMethod.d') then
    begin
      TempList1.LoadFromFile(Appdir + '\' + 'EfMethod.d');
      SaveOptionValue('Ef_Method', TempList1[0], TempList);
    end;

    // Inv Footer
    TempList1.clear;
    If FileExists(Appdir + '\' + 'InvFoot.d') then
    begin
      TempList1.LoadFromFile(Appdir + '\' + 'InvFoot.d');
      SaveOptionValue('InvFoot1', TempList1[0], TempList);
      SaveOptionValue('InvFoot2', TempList1[1], TempList);
      SaveOptionValue('InvFoot3', TempList1[2], TempList);
      SaveOptionValue('InvFoot4', TempList1[3], TempList);
      SaveOptionValue('InvFoot5', TempList1[4], TempList);
    end;
  End; // with
  TempList.SaveToFile(Appdir + '\' + OptionsFlName);
  TempList.free;
  TempList1.free;
end;

function GetFileList(FDirectory, Filter: TFileName): TStringList;
var
  ARec: TSearchRec;
  Res: Integer;
begin
  if FDirectory[Length(FDirectory)] <> '\' then
    FDirectory := FDirectory + '\';
  result := TStringList.create;
  try
    Res := FindFirst(FDirectory + Filter, faAnyFile, ARec);
    while Res = 0 do
    begin
      if FileExists(FDirectory + ARec.Name) then
        result.Add(FDirectory + ARec.Name);

      Res := FindNext(ARec);
    end;
    SysUtils.FindClose(ARec);
  except
    result.free;
  end;
end;

Procedure InitOptions; // 20160623 Igor
begin
  //20190213 Igor >>>
  if CheckIsCloud(true) then
    //if not SameText(CloudDataDir, '') then //20190306 Igor
      SetDefaultOptions;
  //20190213 Igor <<<

  If Not FileExists(Appdir + '\' + OptionsFlName) then
  begin // if first run - try convert from old program
    if not ConvertToMultiApp(AppT4T5_2026) then
    begin // if no old program or user cancel - load default param values
      SetDefaultOptions;
      LoadOptionsFileToMem; // from txt to optrec
    end
  end
  else
    LoadOptionsFileToMem; // from txt to optrec
end;

function BuildValue(ASource: String): String; // 20160530 Igor
Begin
//20171204 Igor>>>
  if Pos(c_DefDataDir, ASource) > 0 then
    result := StringReplace(ASource, c_DefDataDir, DefaultDataDir(AppT4T5_2026),
//20171204 Igor<<<
      [rfReplaceAll, rfIgnoreCase])
  else
    result := ASource;
  result := result;
End;

Function GetDefaultOptionsValue(const AOptionsName: String): String;
// 20160627 Igor
var
  I: Integer;
Begin
  for I := Low(OptionsArray) to High(OptionsArray) do
    if SameText(OptionsArray[I, 0], AOptionsName) then
    Begin
      result := BuildValue(OptionsArray[I, 1]);
      exit;
    End;
  result := '';
End;

function GetDefaultOptions: TStringList; // 20160627 Igor
var
  I: Integer;
  n, V: String;
Begin
  result := TStringList.create;
  for I := Low(OptionsArray) to High(OptionsArray) do
    if SameText(OptionsArray[I, 3], 'X') then
    begin
      n := OptionsArray[I, 0];
      V := BuildValue(OptionsArray[I, 1]);
      if V <> '' then
        result.Values[n] := V
      else
        result.Add(n + '=');
    end;
End;

function GetOptionsCaption(AOptionsName: String): String; // 20160627 Igor
var
  I: Integer;
Begin
  for I := Low(OptionsArray) to High(OptionsArray) do
    if SameText(OptionsArray[I, 0], AOptionsName) then
    Begin
      result := OptionsArray[I, 2];
      if result = '' then
        result := AOptionsName;
      exit;
    End;
  result := AOptionsName;
End;

function HaveOptions(AOptionsName: String): Boolean; //20170112 Igor
var
  I: Integer;
Begin
  for I := Low(OptionsArray) to High(OptionsArray) do
    if SameText(OptionsArray[I,0],AOptionsName) then
      Exit(True);
  Result := False;
end;

Procedure SetDefaultOptions; // 20160523 Igor //20160623 Igor
var
  i: Integer;
  CurrOptions: TstringList; //20201116 Igor

  procedure lSaveSingleOption(AOptionsName: String); //20201116 Igor
  var Value: string;
  Begin
    Value := GetOptionValue(AOptionsName, CurrOptions);
    if Value.IsEmpty then
      Value := GetDefaultOptionsValue(AOptionsName);
    SaveSingleOption(AOptionsName,Value);
  End;

Begin
  // 20160602 igor
  //20201116 Igor >>>
  CurrOptions := TStringList.Create;
  try
    if FileExists(AppDir + '\' + OptionsFlName) then
      CurrOptions.LoadFromFile(AppDir + '\' + OptionsFlName);

    CreateDefaultDataDirectories; // It saves the new dir to Options file
    for I := Low(OptionsArray) to High(OptionsArray) do
     if OptionsArray[I,3] = 'X' then
       lSaveSingleOption(OptionsArray[I,0]);

  finally
    CurrOptions.Free;
  end;
  //20201116 Igor <<<

  // lSaveSingleOption('Opr-GstHst','5');
  // lSaveSingleOption('Prp_Bill','2');
  // lSaveSingleOption('Prp_VSFee','30');
  // lSaveSingleOption('Prp_SFee','50');
  // lSaveSingleOption('Prp_AFee','70');
  // lSaveSingleOption('Prp_CFee','100');
  // lSaveSingleOption('Prp_VCFee','150');
  // lSaveSingleOption('Prp_Hour','60');
  /// /display
  // lSaveSingleOption('FormZoom',IntToStr(GetDefaultScaling));
  // lSaveSingleOption('ActiveBoxColor',IntToStr(Rgb(255,128,128)));
  // lSaveSingleOption('FirstReturnColor',IntToStr(RGB(195,255,255)));
  // lSaveSingleOption('UseFormSearch','X');
  // lSaveSingleOption('OtherSlipsButtons','X');
  // lSaveSingleOption('OtherSlipsButtons','X');
  // lSaveSingleOption('Opr_Close','X');
  // lSaveSingleOption('Prn_NameH','X');
  // lSaveSingleOption('Prn_SinH','X');
  // lSaveSingleOption('Prn_DateH','X');
  // lSaveSingleOption('Prn_LMargin','1.0');
  // lSaveSingleOption('Prn_RMargin','0.75');
  // lSaveSingleOption('Prn_FontIncr','1');
  //
  // lSaveSingleOption('DataInBold','');
  // lSaveSingleOption('HideMostRecent','');
  // lSaveSingleOption('ShowUsedForms','X');
  // lSaveSingleOption('OpenAtLastForm','X');
  //
  // lSaveSingleOption('T1013AuthorLevel','2');
  // lSaveSingleOption('CVSetting','2');
  // lSaveSingleOption('ShowFinWarning','');
  // lSaveSingleOption('ShowConsultantOnInv','');
  // lSaveSingleOption('UseFastPrint','');
  // lSaveSingleOption('UseProperName','X');
  //
  // lSaveSingleOption('UseCondominiumLine','X');
  // lSaveSingleOption('NoTypeAhead','');
  // lSaveSingleOption('RolloverT4T5','X');
  // lSaveSingleOption('ShowInvoiceWarning','X');
  // lSaveSingleOption('ShowInvoiceEfCharge','X');
  // lSaveSingleOption('ShowSaluteWarning','X');
  //
  // lSaveSingleOption('UpdateFrequency','7');
  /// / SaveSingleOption('Nfl_Efile','X');
  // lSaveSingleOption('Nfl_Prov','ON');
  // lSaveSingleOption('Nfl_City','TORONTO');
  /// / SaveSingleOption('Ef_Method','EOL');
  //
  // lSaveSingleOption('Prp_Elect','X');
  // lSaveSingleOption('Prp_EfRepr','X');
  // lSaveSingleOption('Nfl_Disced','1');
  // lSaveSingleOption('Capitalization','UpperCase');
  //
  // lSaveSingleOption('AutoSeniorDiscount','');
  // lSaveSingleOption('DiscountForSeniors','0');
  // lSaveSingleOption('RolloverProgram','VisualTax');
  //
  // if assigned(APrevOptions) then
  // CompareOptions(APrevOptions, AppDir+'\'+OptionsFlName);

end;

Procedure LoadOptionsFileToMem;
Var
  TempList: TStringList;
begin
  TempList := TStringList.create;
  TempList.LoadFromFile(Appdir + '\' + OptionsFlName);
  With OptRec do
  begin
    // Read Values
    Dir_Cur := GetOptionValue('Dir_Cur', TempList);
    BackUpFrequency := GetOptionValue('BackUpFrequency', TempList);
    BackUpDir := GetOptionValue('BackUpDir', TempList);
    LastBackUpDir := GetOptionValue('LastBackUpDir', TempList);
    Dir_Deflt := GetOptionValue('Dir_Deflt', TempList);
    // Dir_Planner:=GetOptionValue('Dir_Planner',TempList);
    Dir_LastYr := GetOptionValue('Dir_LastYr', TempList);
    Dir_PgmLastYr := GetOptionValue('Dir_PgmLastYr', TempList); // 20160629 Igor
    Dir_DBFData := GetOptionValue('Dir_DBFData', TempList); // 20160226 Igor

    Prp_Name := GetOptionValue('Prp_Name', TempList);
    Prp_ContactName := GetOptionValue('Prp_ContactName', TempList);

    Prp_TransmitterNo := GetOptionValue('Prp_TransmitterNo', TempList);
    Prp_TransmitterType := GetOptionValue('Prp_TransmitterType', TempList);

    Prp_RepId := GetOptionValue('Prp_RepId', TempList); //jz 20250117


    Prp_EMail := GetOptionValue('Prp_EMail', TempList);
    Prp_BusNo := GetOptionValue('Prp_BusNo', TempList);

    Reviewer_Name := GetOptionValue('Reviewer_Name', TempList);
    Reviewer_EMail := GetOptionValue('Reviewer_EMail', TempList);
    Reviewer_Area := GetOptionValue('Reviewer_Area', TempList);
    Reviewer_Tel := GetOptionValue('Reviewer_Tel', TempList);

    Prp_Street := GetOptionValue('Prp_Street', TempList);
    Prp_City := GetOptionValue('Prp_City', TempList);
    Prp_Prov := GetOptionValue('Prp_Prov', TempList);
    Prp_Postal := GetOptionValue('Prp_Postal', TempList);
    Prp_Countr := GetOptionValue('Prp_Countr', TempList);
    Prp_Area := GetOptionValue('Prp_Area', TempList);
    Prp_Tel := GetOptionValue('Prp_Tel', TempList);
    Prp_FxArea := GetOptionValue('Prp_FxArea', TempList);
    Prp_Fax := GetOptionValue('Prp_Fax', TempList);
    Prp_DiscNo := GetOptionValue('Prp_DiscNo', TempList);
    Prp_DiscNm := GetOptionValue('Prp_DiscNm', TempList);
    Prp_GSTNo := GetOptionValue('Prp_GSTNo', TempList);
    Prp_Bill := GetOptionValue('Prp_Bill', TempList);
    Prp_VSFee := MyStrToInt(GetOptionValue('Prp_VSFee', TempList));
    Prp_SFee := MyStrToInt(GetOptionValue('Prp_SFee', TempList));
    Prp_AFee := MyStrToInt(GetOptionValue('Prp_AFee', TempList));
    Prp_CFee := MyStrToInt(GetOptionValue('Prp_CFee', TempList));
    Prp_VCFee := MyStrToInt(GetOptionValue('Prp_VCFee', TempList));
    Prp_Hour := Vl(GetOptionValue('Prp_Hour', TempList));

    Prp_Elect := StringToBoolean(GetOptionValue('Prp_Elect', TempList));
    Prp_EfRepr := StringToBoolean(GetOptionValue('Prp_EfRepr', TempList));
    Prp_Dates := StringToBoolean(GetOptionValue('Prp_Dates', TempList));
    Nfl_Prov := GetOptionValue('Nfl_Prov', TempList);
    Nfl_City := GetOptionValue('Nfl_City', TempList);

    Nfl_Disced := GetOptionValue('Nfl_Disced', TempList);
    Capitalization := GetOptionValue('Capitalization', TempList);
    // Nfl_Efile:=StringToBoolean(GetOptionValue('Nfl_Efile',TempList));
    // Ef_method:=GetOptionValue('Ef_Method',TempList);
    Prn_NameH := StringToBoolean(GetOptionValue('Prn_NameH', TempList));
    Prn_SinH := StringToBoolean(GetOptionValue('Prn_SinH', TempList));
    Prn_DateH := StringToBoolean(GetOptionValue('Prn_DateH', TempList));
    Prn_Disclm := GetOptionValue('Prn_Disclm', TempList);
    // Prn_Logo:=StringToBoolean(GetOptionValue('Prn_Logo',TempList));
    // Prn_logoln:=MyStrToInt(GetOptionValue('Prn_logoln',TempList));
    // LogoFile:=GetOptionValue('LogoFile',TempList);
    Opr_Close := StringToBoolean(GetOptionValue('Opr_Close', TempList));
    Opr_GstHst := Vl(GetOptionValue('Opr_GstHst', TempList));

    // other optios
    // ShowFinWarning:=StringToBoolean(GetOptionValue('ShowFinWarning',TempList));
    ShowConsultantOnInv := StringToBoolean(GetOptionValue('ShowConsultantOnInv',
      TempList));
    UseFastPrint := StringToBoolean(GetOptionValue('UseFastPrint', TempList));
    UseProperName := StringToBoolean(GetOptionValue('UseProperName', TempList));

    UseFormSearch := StringToBoolean(GetOptionValue('UseFormSearch', TempList));
    // OtherSlipsButtons:=StringToBoolean(GetOptionValue('OtherSlipsButtons',TempList));
    // UseCondominiumLine:=StringToBoolean(GetOptionValue('UseCondominiumLine',TempList));
    NoTypeAhead := StringToBoolean(GetOptionValue('NoTypeAhead', TempList));

    // RolloverT4T5:=StringToBoolean(GetOptionValue('RolloverT4T5',TempList));
    ShowVisitedForms := StringToBoolean(GetOptionValue('ShowVisitedForms',
      TempList));
    ShowInvoiceWarning := StringToBoolean(GetOptionValue('ShowInvoiceWarning',
      TempList));
    // ShowInvoiceEfCharge:=StringToBoolean(GetOptionValue('ShowInvoiceEfCharge',TempList));
    // ShowSaluteWarning:=StringToBoolean(GetOptionValue('ShowSaluteWarning',TempList));
    // T1013AuthorLevel:=GetOptionValue('T1013AuthorLevel',TempList);
    // CVSetting:=GetOptionValue('CVSetting',TempList);
    ActiveBoxColor := StrToInt(GetOptionValue('ActiveBoxColor', TempList));
    FirstReturnColor := GetOptionValue('FirstReturnColor', TempList);
    // update frequency
    // invoice footter
    InvFoot1 := GetOptionValue('InvFoot1', TempList);
    InvFoot2 := GetOptionValue('InvFoot2', TempList);
    InvFoot3 := GetOptionValue('InvFoot3', TempList);
    InvFoot4 := GetOptionValue('InvFoot4', TempList);
    InvFoot5 := GetOptionValue('InvFoot5', TempList);

    DataInBold := StringToBoolean(GetOptionValue('DataInBold', TempList));
    ShowUsedForms := StringToBoolean(GetOptionValue('ShowUsedForms', TempList));
    OpenAtLastForm := StringToBoolean(GetOptionValue('OpenAtLastForm',
      TempList));
    NoBarCode := StringToBoolean(GetOptionValue('NoBarCode', TempList));
    RolloverProgram := GetOptionValue('RolloverProgram', TempList);

    // AutoSeniorDiscount:=StringToBoolean(GetOptionValue('AutoSeniorDiscount',TempList));
    // DiscountForSeniors:=GetOptionValue('DiscountForSeniors',TempList);
    { ignored shared options
      FormZoom:=MyStrToInt(GetOptionValue('FormZoom',TempList));
      HideMostRecent:=StringToBoolean(GetOptionValue('HideMostRecent',TempList));
      Prn_LMargin:=GetOptionValue('Prn_LMargin',TempList);
      Prn_RMargin:=GetOptionValue('Prn_RMargin',TempList);
      Prn_FontIncr:=GetOptionValue('Prn_FontIncr',TempList);
      UpdateFrequency:=GetOptionValue('UpdateFrequency',TempList);
    }
    GetOverloadedProperty; //20170112 Igor
  end;
  TempList.free;
end;

Function GetOptionValue(FieldNm: String; TempList: TStringList): String;
Var
  I: Integer;
begin
  result := '';
  I := IsInList(FieldNm, TempList);
  If I > -1 then
    result := MidStr(TempList[I], 21, 250);
end;

Procedure SaveSingleOption(FieldNm, Value: string;
  AOptionsFileName: String = ''); // 20160627 Igor
Var
  I: Integer;
  TempList: TStringList;
begin
  TempList := TStringList.create;
  if AOptionsFileName = '' then
    AOptionsFileName := Appdir + '\' + OptionsFlName;
  // create txt if does not exist
  If Not FileExists(AOptionsFileName) then
    TempList.SaveToFile(AOptionsFileName);

  TempList.LoadFromFile(AOptionsFileName);
  I := IsInList(FieldNm, TempList);
  If I > -1 then
    TempList[I] := LeftStr(TempList[I], 20) + Value
  else
    TempList.Add(paddR(UpperCase(FieldNm), 20) + Value);
  TempList.SaveToFile(AOptionsFileName);
  TempList.free;
end;

Procedure SaveOptionValue(FieldNm: String; Value: String;
  TempList: TStringList);
begin
  TempList.Add(paddR(FieldNm, 20) + Value);
end;

Procedure SavePGMPsw(PGMPsw: String);
// save encrypted
Const
  ActivationFile = 'LVerf.EX_';
Var
  TempList: TStringList;
begin
  TempList := TStringList.create;
  If FileExists(Appdir + '\' + ActivationFile) then
    TempList.LoadFromFile(Appdir + '\' + ActivationFile);

  Case TempList.Count of
    0:
      begin
        TempList.free;
        ShowMessage('N/A');
        exit;
      end;
    1:
      begin
        TempList.Add(' ');
        TempList.Add(EncryptPsw(PGMPsw, 9999));
      end;
    2:
      TempList.Add(EncryptPsw(PGMPsw, 9999));
    3:
      TempList[2] := EncryptPsw(PGMPsw, 9999);
  end; // end case

  TempList.SaveToFile(Appdir + '\' + ActivationFile);
  TempList.free;
end;

Function GetLongestLengthItem(SomeList: TStringList): Integer;
var
  I: Integer;
begin
  result := 10;
  For I := 0 to SomeList.Count - 1 do
    If Length(SomeList[I]) > result then
      result := Length(SomeList[I]);
end;

Function GetDefaultScaling: Integer;
Const
  OriginalWidth = 800; { I designed my form in 800x600 mode. }
  OriginalHeight = 600;
begin
  result := OptRec.FormZoom;
  If (result = 0) or (result < 50) or (result > 200) then
  Begin
    If (Screen.width <= 800) then
    begin
      result := 100;
      exit;
    end;
    result := Round(((Screen.width) / OriginalWidth) * 100);
  end;
end;

function IsLandscape(FName: String): Boolean;
// Var I :integer;
begin
  result := FList.ByFormName(FName).Landscape;
End;

Function WhichTaxForm(RetNo: Integer; ShortPrv: string): String;
begin
  If ShortPrv = 'NL' then
    result := 'T3NL'
  else if ShortPrv = 'PE' then
    result := 'T3PE'
  else if ShortPrv = 'NS' then
    result := 'T3NS'
  else if ShortPrv = 'NB' then
    result := 'T3NB'
  else if ShortPrv = 'QC' then
    result := ''
  else if ShortPrv = 'ON' then
    result := 'T3ON'
  else if ShortPrv = 'MB' then
    result := 'T3MB'
  else if ShortPrv = 'SK' then
    result := 'T3SK'
  else if ShortPrv = 'AB' then
    result := 'T3AB'
  else if ShortPrv = 'BC' then
    result := 'T3BC'
  else if ShortPrv = 'NT' then
    result := 'T3NT'
  else if ShortPrv = 'YT' then
    result := 'T3YT'
  else if ShortPrv = 'NU' then
    result := 'T3NU'
  else if ShortPrv = 'ZZ' then
    result := ''
end;

Function PrintAListing(FileNm, Hdr1, Hdr2, Hdr3: String): Boolean;
var
  I, LineCnt, MxLinesPerPage, PageCnt: Integer;
  PrnFile: TextFile;
  { TempList:TstringList; }
  Xpos: LongInt;
  PageX, PageY: LongInt;
  ScMult: Integer;
  s: string;
  F1: TextFile;
  ScaleX, ScaleY: Word;
  FirstTimeSw: Boolean;
begin
  AssignFile(F1, FileNm);
  Reset(F1);

  FirstTimeSw := True;
  LineCnt := 0;
  PageCnt := 0;
  MxLinesPerPage := 60;
  { now print }
  Printer.BeginDoc;
  Xpos := 25;
  ScMult := 10;
  PageX := Printer.PageWidth;
  PageY := Printer.PageHeight;
  ScaleX := (PageX * ScMult) div 614; { to get the decimals }
  ScaleY := (PageY * ScMult) div 1000; { formheight }

  Repeat
    If (FirstTimeSw) or (LineCnt > MxLinesPerPage) then
    begin { print headers }
      LineCnt := 1;
      inc(PageCnt);
      If not FirstTimeSw then
        Printer.NewPage;

      Printer.Canvas.font.Name := 'Arial';
      Printer.Canvas.font.Size := 10;
      Printer.Canvas.font.Style := [fsBold];
      Printer.Canvas.font.Color := clBlack;
      Printer.Canvas.TextOut((Xpos * ScaleX) div ScMult, (LineCnt * 15 * ScaleY)
        div ScMult, Hdr1 + ' Page: ' + IntToStr(PageCnt));

      inc(LineCnt); { leave empty line }
      Printer.Canvas.font.Name := 'Courier New';
      Printer.Canvas.font.Size := 8;
      Printer.Canvas.font.Style := [fsBold];
      { Printer.Canvas.Font.Style := []; }
      Printer.Canvas.font.Color := clBlack;
      inc(LineCnt);
      Printer.Canvas.TextOut((Xpos * ScaleX) div ScMult, (LineCnt * 15 * ScaleY)
        div ScMult, Hdr2);

      inc(LineCnt);
      Printer.Canvas.TextOut((Xpos * ScaleX) div ScMult, (LineCnt * 15 * ScaleY)
        div ScMult, Hdr3);
      inc(LineCnt, 1);
    end; { headers }
    FirstTimeSw := False;
    Printer.Canvas.font.Style := [];
    ReadLn(F1, s);
    Printer.Canvas.font.Style := [fsBold];
    Printer.Canvas.font.Color := clBlack;
    Printer.Canvas.TextOut((Xpos * ScaleX) div ScMult, (LineCnt * 15 * ScaleY)
      div ScMult, s);
    inc(LineCnt);
  until Eof(F1);
  CloseFile(F1);
  Printer.EndDoc;
  result := True;
end;

Function GetCharityType(RetNo: Integer): String;
begin

  result := 'CHARITY';
  // 20110213
  (*
    If GetCharityYe(RetNo) <'2010-03-04' then
    begin
    If FetchElm(RetNo,'T1259',94)>'' then result:='PUBLICF'; //pablic
    If FetchElm(RetNo,'T1259',95)>'' then result:='PRIVATEF'; //pablic
    end
    Else
    begin
  *)

  If FetchElm(RetNo, 'T1259B', 94) > '' then
    result := 'PUBLICF'; // pablic
  If FetchElm(RetNo, 'T1259B', 95) > '' then
    result := 'PRIVATEF'; // pablic
  // end;
end;

//20170621 Igor >>>
//Function MiddleR(x, y, z: Real): Real;
//begin
//  (*
//    Result:=MinR(x,MinR(y,z));
//    If x>Result then Result:=x;
//    If y>Result then Result:=y;
//    If z>Result then Result:=z;
//  *)
//end;
//20170621 Igor <<<

Function IsT5013Return(RetNo: Integer): Boolean;
begin
  If Ret[RetNo].FrmHasData[GetFormNo('T5013FIN')] then
    result := True
  else
    result := False;
end;

Function ValidBusNumber(RetNo: Integer; Bn: String): Boolean;
Var
  I: Integer;
begin
  result := True;
  If Bn = '' then
    exit;
  If (Length(Bn) <> 15) then
  begin
    result := False;
    exit;
  end;
  If UpperCase(Bn[10]) <> 'R' then
  begin
    result := False;
    exit;
  end;
  If Numeric(Bn[11]) = True then
  begin
    result := False;
    exit;
  end;

  For I := 1 to 9 do
    If Not Numeric(Bn[I]) then
    begin
      result := False;
      exit;
    end;

  For I := 12 to 15 do
    If Not Numeric(Bn[I]) then
    begin
      result := False;
      exit;
    end;

  If ValidSin(LeftStr(Bn, 9)) = False then
  begin
    result := False;
    exit;
  end;
end;

Procedure CopyT5015ToS50(RetNo: Integer);
Var
  I, ii, j, k, FNo, T5015FNo: Integer;
  ToInst: String;
  TotUnits: String;
begin
  UpdateAllDataIndicators(RetNo);
  TotUnits := FormatFloat('######.####', TotMultiple(RetNo, 'T5015', 165));

  for ii := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[ii];
    If FRec.FormName = 'T5015' then
    begin
      T5015FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[T5015FNo] then
      begin
        ToInst := FRec.FormInst;

        begin
          FNo := AddPageInstance(RetNo, 'PS50', ToInst);
          // Fno := GetFormNo('PS50'+ToInst); {get it again}
          // InitFormData(RetNo,FNo);
        end;
        InitFormData(RetNo, FNo);
        // now copy
        j := 4; // PS50
        I := 4; // old T5015
        k := 175; // oth adj
        Repeat
          StoreElm(RetNo, FNo, 363, TotUnits); // nm

          StoreElm(RetNo, FNo, j, FetchElmFNo(RetNo, T5015FNo, I)); // nm
          StoreElm(RetNo, FNo, j + 1, FetchElmFNo(RetNo, T5015FNo, I + 1));
          // id
          StoreElm(RetNo, FNo, j + 6, FetchElmFNo(RetNo, T5015FNo, I + 2));
          // beg
          StoreElm(RetNo, FNo, j + 7, FetchElmFNo(RetNo, T5015FNo, I + 3));
          // contrib
          StoreElm(RetNo, FNo, j + 9, FetchElmFNo(RetNo, T5015FNo, I + 4));
          // alloc
          StoreElm(RetNo, FNo, j + 10, FetchElmFNo(RetNo, T5015FNo, I + 5));
          // drawings
          StoreElm(RetNo, FNo, j + 11, FetchElmFNo(RetNo, T5015FNo, I + 6));
          // end year
          StoreElm(RetNo, FNo, j + 3, FetchElmFNo(RetNo, T5015FNo, I + 7));
          // recip
          StoreElm(RetNo, FNo, j + 2, FetchElmFNo(RetNo, T5015FNo, I + 8));
          // memb
          StoreElm(RetNo, FNo, j + 5, FetchElmFNo(RetNo, T5015FNo, I + 9));
          // share
          StoreElm(RetNo, FNo, j + 4, FetchElmFNo(RetNo, T5015FNo, I + 10));
          // units

          StoreElm(RetNo, FNo, j + 12, FetchElmFNo(RetNo, T5015FNo, I + 11));
          // str
          StoreElm(RetNo, FNo, j + 13, FetchElmFNo(RetNo, T5015FNo, I + 12));
          // city
          StoreElm(RetNo, FNo, j + 14, FetchElmFNo(RetNo, T5015FNo, I + 13));
          // prov
          StoreElm(RetNo, FNo, j + 15, FetchElmFNo(RetNo, T5015FNo, I + 14));
          // postal
          StoreElm(RetNo, FNo, j + 16, FetchElmFNo(RetNo, T5015FNo, I + 15));
          // country
          StoreElm(RetNo, FNo, j + 8, FetchElmFNo(RetNo, T5015FNo, k));
          // country
          inc(I, 16);
          inc(j, 17);
          inc(k, 1);
        until I > 148;
        Ret[RetNo].FrmHasData[FNo] := True;
      end; // has data
    end; // form=T5015
  end; // ii
end;

Function GetFedTaxBfrITC(RetNo: Integer): Real;
Var
  FNo: Integer;
begin
  FNo := GetFormNo('S11');
  result := MaxR(0, Vl(FetchElmFNo(RetNo, FNo, 104)) - Vl(FetchElmFNo(RetNo,
    FNo, 105)) - Vl(FetchElmFNo(RetNo, FNo, 107)) - Vl(FetchElmFNo(RetNo, FNo,
    109)) - Vl(FetchElmFNo(RetNo, FNo, 116)) - Vl(FetchElmFNo(RetNo,
    FNo, 117)));
end;

Function AdvanceYearEnd(ThisYearEnd: String): String;
Var
  k: Integer;
  YYYY, MM, DD: String;
begin
  k := MyStrToInt(LeftStr(ThisYearEnd, 4)) + 1;
  result := IntToStr(k) + MidStr(ThisYearEnd, 5, 6);
  YYYY := LeftStr(result, 4);
  MM := MidStr(result, 6, 2);
  DD := RightStr(result, 2);

  If (not IsLeapYear(MyStrToInt(YYYY))) and (MM = '02') and (DD = '29') then
    result := LeftStr(result, 4) + '-02-28';
end;

Function AdvanceYear(ThisYear: String): String;
Var
  k: Integer;
  YYYY, MM, DD: String;
begin
  If ThisYear = '' then
    exit;
  result := IntToStr(MyStrToInt(ThisYear) + 1);
end;

Function GetTaxOnBase(Bracket, PrevBracket, PrevPercent,
  PrevBaseTax: Real): Real;
begin
  result := Round((Bracket - PrevBracket) * PrevPercent / 100) + PrevBaseTax;
end;


(* 20170721
Procedure SumSlips(RetNo: Integer; FName: string);
begin
  with Ret[RetNo] do
  begin
    If (FName = 'ALL') or (LeftStr(FName, 8) = 'T3INCOME') then
      T3IncomeProcess(RetNo, T3OthInc, T3Pens, T3itc, T3xii, T3ElgblQSB1,
        T3ElgblQFP1, T3ElgblOTH1, T3ElgblOTH2, T3ElgblOTH3, T3NonElgblGains1,
        T3Dividends, T3DividendsEligible, T3FNonBusInc1, T3FNonBusInc2,
        T3FNonBusInc3, T3FNonBusTax1, T3FNonBusTax2, T3FNonBusTax3, T3FBusInc1,
        T3FBusInc2, T3FBusInc3, T3FBusTax1, T3FBusTax2, T3FBusTax3, T3FarmElgbl,
        T3OthElgbl, T3QFPElgbl, T3ElgblQSB2, T3ElgblQFP2, T3ElgblQSB3,
        T3ElgblQFP3, T3NonElgblGains2, T3NonElgblGains3, T3FCapGains);

    If (FName = 'ALL') or (LeftStr(FName, 8) = 'T5INCOME') then
    begin
      T5IncomeProcess(RetNo, T5Interest, T5FInterest, T5Pens, T5Royalty,
        T5NonElgblGains, T5Dividends, T5DividendsEligible, T5FNonBusInc1,
        T5FNonBusInc2, T5FNonBusInc3, T5FNonBusTax1, T5FNonBusTax2,
        T5FNonBusTax3);
    end;

    If (FName = 'ALL') or (LeftStr(FName, 8) = 'T5013INC') then
      T5013IncProcess(RetNo, T5013LimitedInc, T5013OthInc, T5013ITC,
        T5013ActDiv, T5013ActDivEligible, T5013CarrCharg, T5013CDE, T5013CEE,
        T5013COGPE, T5013FDE, T5013RecapDepl, T5013FedPol, T5013ProvPol,
        T5013Don, T5013Gifts, T5013Abil, T5013FNonBusInc1, T5013FNonBusInc2,
        T5013FNonBusInc3, T5013FNonBusTax1, T5013FNonBusTax2, T5013FNonBusTax3,
        T5013FBusInc1, T5013FBusInc2, T5013FBusInc3, T5013FBusTax1,
        T5013FBusTax2, T5013FBusTax3, T5013Interest, T5013Tax, T5013ResAllow,
        T5013FInterest, T5013GrossIncome, T5013BusIncome, T5013FarmIncome,
        T5013FishIncome, T5013RentIncome);

  end;
end;
*)




Function YYYY_MM_DDToMMDDYYYY(InputDate: String): string;
{ input date in form yyyy-mm-dd, output as mm/dd/yyyy }
begin
  result := '';
  If InputDate = '' then
    exit;
  result := MidStr(InputDate, 6, 2) + '/' + RightStr(InputDate, 2) + '/' +
    LeftStr(InputDate, 4);
end;



Procedure UpdateThisFormDataIndicator(RetNo: Integer; FName: String);
var
  I, FNo: Integer;
  s: string;
begin
  // for i :=0 to (FList.Count - 1) do
  begin
    FRec := FList.ByFormName(FName);
    FNo := FRec.FormNo;
    If FNo > 0 then
      UpdateFormDataIndicator(RetNo, FRec);
  end;
end;

Function IsSharedStatement(RetNo: Integer; Stmt: String): Boolean;
// comes as T2125#1
Var
  FInst: String;
begin
  result := False;
  FInst := ExtractFormInst(Stmt);
  If LeftStr(Stmt, 5) = 'T2125' then
  begin
    If Vl(FetchElm(RetNo, 'T2125' + FInst, 238)) > 0 then
    begin
      result := True;
      exit;
    End
  end

  else If LeftStr(Stmt, 5) = 'T2121' then
  begin
    If Vl(FetchElm(RetNo, 'T2121' + FInst, 505)) > 0 then
    begin
      result := True;
      exit;
    end
  end

  else If LeftStr(Stmt, 5) = 'T2042' then
  begin
    If Vl(FetchElm(RetNo, 'T2042' + FInst, 642)) > 0 then
    begin
      result := True;
      exit;
    end
  end

  else If LeftStr(Stmt, 4) = 'T776' then
  begin
    If Vl(FetchElm(RetNo, 'T776' + FInst, 24)) > 0 then
    begin
      result := True;
      exit;
    end
  end;
end;

(*
// 2009 version
Procedure PopulateT5018G(RetNo: Integer);
Var
  I, j, FNoSlip, FNoGov, Incr: Integer;
  FName: String;
  FGovInst: Integer;
  NextSlipId: Integer;
  SlipsDone: Integer; // by 3
  PayerAccount: String;
begin
  Incr := 30;
  PayerAccount := FetchElm(RetNo, 'T5018S', 2);
  // delete any T5018G forms previuosly populated
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = 'T5018G' then
      InitFormData(RetNo, FRec.FormNo);
  end;

  FGovInst := 1;
  FNoGov := GetFormNo('T5018G' + '#' + IntToStr(FGovInst));
  NextSlipId := 1;
  InitFormData(RetNo, FNoGov);
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = 'T5018L' then
    begin
      FName := FRec.FormName;
      FNoSlip := FRec.FormNo; // recipient slip
      If Ret[RetNo].FrmHasData[FNoSlip] then
      begin
        // get slip available
        NextSlipId := 1;
        If Vl(FetchElmFNo(RetNo, FNoGov, 2)) > 0 then
          NextSlipId := 2; // next avlbl
        If Vl(FetchElmFNo(RetNo, FNoGov, 2 + Incr)) > 0 then
          NextSlipId := 3;
        If NextSlipId = 1 then
        begin
          For j := 1 to 16 do
            StoreElm(RetNo, FNoGov, j, FetchElmFNo(RetNo, FNoSlip, j));
          StoreElm(RetNo, FNoGov, 17, PayerAccount);
          // put the account no in CRA's copy
          Ret[RetNo].FrmHasData[FNoGov] := True;
        end;
        If NextSlipId = 2 then
        begin
          For j := 1 to 16 do
            StoreElm(RetNo, FNoGov, j + Incr, FetchElmFNo(RetNo, FNoSlip, j));
          StoreElm(RetNo, FNoGov, 17 + Incr, PayerAccount);
          // put the account no in CRA's copy
          Ret[RetNo].FrmHasData[FNoGov] := True;
        end;
        If NextSlipId = 3 then
        begin
          For j := 1 to 16 do
            StoreElm(RetNo, FNoGov, j + 2 * Incr,
              FetchElmFNo(RetNo, FNoSlip, j));
          StoreElm(RetNo, FNoGov, 17 + 2 * Incr, PayerAccount);
          // put the account no in CRA's copy
          Ret[RetNo].FrmHasData[FNoGov] := True;
          // now prepare a new FGov page
          FGovInst := FGovInst + 1;
          begin
            FNoGov := AddPageInstance(RetNo, 'T5018G',
              '#' + IntToStr(FGovInst));
            // FnoGov := GetFormNo('T5018G'+'#'+IntToStr(FGovInst)); {get it again}
            InitFormData(RetNo, FNoGov);
            NextSlipId := 1;
          end;
        end;
      end; // has data
    end; // is 5018L
  end; // i
end;
*)

//20170621 igor >>>
//Function NewDBStructure: Boolean;
//begin
//  //
//end;
//20170621 igor <<<

Procedure OpenUsedForms(RetNo: Integer);
Var
  I, UsedFNo, FNo: Integer;
  FName: String;
Begin
  If OptRec.ShowUsedForms = False then
    exit;
  UsedFNo := GetFormNo('USEDFRM');
  LockWindowUpdate(Application.MainForm.Handle);
  For I := 1 to 15 do
  begin
    FName := AllTrim(FetchElmFNo(RetNo, UsedFNo, I));
    If FName > '' then
    begin
      FNo := GetFormNo(FName);

      If FNo > 0 then
        OpenForm(RetNo, FNo, 0);
    end;
  end; // rest outside loop!?

  If OptRec.OpenAtLastForm then
  begin
    FName := AllTrim(FetchElmFNo(RetNo, UsedFNo, 31));
    FNo := GetFormNo(FName, False);
    If FNo > 0 then
      OpenForm(RetNo, FNo, 0);
  end
  else
  begin
    FName := 'T3';
    FNo := GetFormNo(FName);
    If FNo > 0 then
      OpenForm(RetNo, FNo, 0);
  end;
  LockWindowUpdate(0);
end;

Function ValidPhoneNo(s: String): Boolean;
begin
  result := False;
  If MidStr(s, 4, 1) = '-' then
    s := AllTrim(RemoveChar(s, '-'));
  If (Length(s) = 7) and (Numeric(s) = True) then
    result := True;
end;

Function DynamicRowHasData(RetNo: Integer; FName: String;
  ElmNo: Integer): Boolean;
begin
  result := DynamicFieldRowHasData(RetNo, FList.ByFormName(FName), ElmNo);
end;

Function GetDynamicRowFromFieldId(FieldId: Integer;
  BoxesPerRow: Integer): Integer;
Var
  Elm: Integer;
  sFieldId: String;
Begin
  sFieldId := IntToStr(FieldId);
  Elm := StrToInt(RightStr(sFieldId, 4));
  // If Elm=1 then begin Result:=1;Exit;End;
  If Elm <= BoxesPerRow then
  begin
    result := 1;
    exit;
  end;
  result := Elm Div BoxesPerRow; // +1;  //20120108
end;

Function CountT5013Partners(RetNo: Integer): Integer;
var
  I: Integer;
begin
  result := 0;
  If CertificationMode = True then
  begin
    result := 5;
    exit;
  End;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = 'PS50' then
    begin
      If Ret[RetNo].FrmHasData[FRec.FormNo] then
        inc(result);
    end;
  end;
end;

Function CountT5013PartnersWithDisposition(RetNo: Integer): Integer;
var
  I: Integer;
begin
  result := 0;
  If CertificationMode = True then
  begin
    result := 2;
    exit;
  End;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = 'PS50' then
    begin
      If Ret[RetNo].FrmHasData[FRec.FormNo] then
      Begin
        If FetchElmFNo(RetNo, FRec.FormNo, 12) > '' then
          inc(result); // 20140318
      end;
    end;
  end;
end;

Function CountT5013PartnersNominees(RetNo: Integer): Integer;
var
  I: Integer;
begin
  result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = 'PS50' then
    begin
      If Ret[RetNo].FrmHasData[FRec.FormNo] then
      Begin
        If FetchElmFNo(RetNo, FRec.FormNo, 15) = '4' then
          inc(result);
      end;
    end;
  end;
end;

Function GetT5013AllPartnersNetIncomeShare(RetNo: Integer): Real;
var
  I: Integer;
begin
  result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = 'PS50' then
    begin
      If Ret[RetNo].FrmHasData[FRec.FormNo] then
      Begin
        result := result + Vl(FetchElmFNo(RetNo, FRec.FormNo, 17));
      end;
    end;
  end;
end;

function ColumnSortAscending(List: TStringList;
  Index1, Index2: Integer): Integer;
var
  lsStr1, lsStr2: string;
begin
  // get the strings to compare
  lsStr1 := Copy(List[Index1], 32, 5);
  lsStr2 := Copy(List[Index2], 32, 5);
  result := AnsiCompareText(lsStr1, lsStr2); // AnsiCompareText(Str1, Str2);
end;

Procedure RemoveEmptyInstances(RetNo: Integer; FName: String; Elms: Integer);
Var
  I, j, FNo, SourceFNo, Cnt: Integer;
  WhichInst: Integer;
Begin
  // Just copy them to #1, #2 etc as long as they have data
  Cnt := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If UpperCase(FRec.FormName) = UpperCase(FName) then
    Begin
      SourceFNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[SourceFNo] then
      begin
        inc(Cnt);
        FNo := AddPageInstance(RetNo, FName, '#' + IntToStr(Cnt));
        If FNo <> SourceFNo then
        Begin
          For j := 1 to Elms do
          begin
            StoreElm(RetNo, FNo, j, FetchElmFNo(RetNo, SourceFNo, j));
            // copy first
            Ret[RetNo].FrmHasData[FNo] := True;
            StoreElm(RetNo, SourceFNo, j, ''); // clear the source
            Ret[RetNo].FrmHasData[FRec.FormNo] := False;
          end;
        end;
        UpdateAllDataIndicators(RetNo);
      end;
    end; // fname found
  end; // i
end;

Function AnyCorpsInT3Slips(RetNo: Integer): Boolean;
Var
  I: Integer;
begin
  result := False;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If (FRec.FormName = 'T3SUPL') and (FetchElmFNo(RetNo, FRec.FormNo, 4) = '3')
    then
    begin
      result := True;
      exit;
    End;
  end;
end;

// 20120411
Function GetHighestT3SuplInstance(RetNo: Integer): Integer;
Var
  I, Inst, tempInst: Integer; // Inst:String;
begin
  Inst := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If (FRec.FormName = 'T3SUPL') then
    begin
      tempInst := MyStrToInt(AllTrim(MidStr(FRec.FormInst, 2, 5)));
      If tempInst > Inst then
        Inst := tempInst;
    end;
  end;
  result := Inst;
end;

Function ConvertElmNoToCombined(OldFName: String; Elm: Integer;
  IncrElmList: TStringList): Integer;
Var
  FInst: String;
  OldNonInstFName, NewNonInstFName, RootFormName: String;
Var
  I: Integer;
begin
  result := Elm;
  OldFName := UpperCase(OldFName);
  FInst := ExtractFormInst(OldFName);
  OldNonInstFName := ExtractNonInstFormName(OldFName);
  NewNonInstFName := ExtractNonInstFormName
    (ConvertFNameToCombined(OldNonInstFName));
  For I := 0 to IncrElmList.Count - 1 do
  begin
    If OldNonInstFName = UpperCase
      (AllTrim(LeftStr(MidStr(IncrElmList[I], 2, 9), 9))) then
    begin
      result := Elm + MyStrToInt(AllTrim(MidStr(IncrElmList[I], 11, 4)));
      exit;
    end;
  end;
end;

Function ConvertFNameToCombined(FName: String): String;
Var
  FInst: String;
begin
  result := FName;
  If IsFormMultiPage(FName) = False then
    exit; // only if multipage
  FInst := ExtractFormInst(FName);
  result := ExtractFormRootName(FName) + FInst;
end;

Function CopyAForm(FromRetNo: Integer; FromFormName: string; ToRetNo: Integer;
  ToFormName: string): Integer;
Var
  I, j, FromFNo, ToFNo: Integer;
  CInst: Integer;
begin
  If FromRetNo = 0 then
    exit(0); // 20170621 igor
  ToFNo := GetFormNo(ToFormName);
  FromFNo := GetFormNo(FromFormName); // 20110125
  If ToFNo = 0 then
  begin
    CInst := ExtractFormInstNo(ToFormName);
    ToFNo := AddPageInstance(ToRetNo, ExtractNonInstFormName(ToFormName),
      '#' + IntToStr(CInst));
  end;
  InitFormData(ToRetNo, ToFNo);

  If (ToRetNo > 0) and (ToFNo > 0) and (FromRetNo > 0) and (FromFNo > 0) then
  // 20101220
  begin
    for I := 0 to FList.Count - 1 do
    begin
      FRec := FList.Items[I];
      If (FRec.FormInstName = FromFormName) and
        (Ret[FromRetNo].FrmHasData[FRec.FormNo]) // 20101220
      then
      begin
        For j := 0 to FieldsLimit do
        // Frec.FormFields do  //20130216 //5 Apr 19
        begin
          Ret[ToRetNo].Frm[ToFNo].Strings[j] :=
            FetchElm(FromRetNo, FromFormName, j);
        end;
        Calc(ToRetNo, ToFormName);
        Ret[ToRetNo].FrmHasData[ToFNo] := True;
        result := ToFNo;
        exit;
      end;
    end;
  end;
end;

Procedure RelocateCharityForms(RetNo: Integer);
Var
  I: Integer;
  NewFNo, OldFNo: Integer;
begin
  (*
    for i :=0 to (FList.Count - 1) do
    begin
    FRec := FList.Items[i];
    If (Frec.FormName='T3010') and Ret[RetNo].FrmHasData[GetFormNo('T3010')]  //20130221
    then CopyAForm(RetNo,Frec.FormInstName,RetNo,'T3010B'+Frec.FormInst);
    If (Frec.FormName='T1235') then CopyAForm(RetNo,Frec.FormInstName,RetNo,'T1235B'+Frec.FormInst);
    If (Frec.FormName='T1236') then CopyAForm(RetNo,Frec.FormInstName,RetNo,'T1236B'+Frec.FormInst);
    end;
  *)
end;

Function FormatT3Account(RetNo: Integer; Acc: String): String;
Begin
  result := Acc;
  If Length(Acc) = 8 then
    result := LeftStr(Acc, 2) + '-' + MidStr(Acc, 3, 4) + '-' +
      RightStr(Acc, 2);
end;

function LicenseLevel: eLicenseLevel;
begin
  result := AppT4T5_2026.LicenseLevel;
end;

function LicenseName: string;
begin
  result := AppT4T5_2026.ProductName;
end;

Function IsEnterpriseVersion: Boolean; //20231211 Igor
begin
  Result := LicenseLevel = llEnterprise;
end;


// 20160207
Function GetTrustTypeDescription(TrustType: String): String;
Var
  k: Integer;
  TempList: TStringList;
Begin
  result := 'Un-specified';
  If TrustType = '' then
    exit;

  TempList := TStringList.create;
  TempList.LoadFromFile(Appdir + '\' + 'TrustType.d');
  k := IsInList(TrustType, TempList);
  If k > -1 then
  Begin
    result := MidStr(TempList[k], 5, 100);
    TempList.free;
    exit;
  end
  Else
    TempList.free;
end;

Function GetStreetAddress(RetNo: Integer): String; // 20160222 Igor
Var
  s: String;
  InfoFNo: Integer;
begin
  InfoFNo := GetFormNo('INFO');
  result := '';
  If FetchElmFNo(RetNo, InfoFNo, 22) > '' then
    result := FetchElmFNo(RetNo, InfoFNo, 22) + '-'; // apt
  result := result + FetchElmFNo(RetNo, InfoFNo, 6) // str
    + ' ' + FetchElmFNo(RetNo, InfoFNo, 68) // po box
    + ' ' + FetchElmFNo(RetNo, InfoFNo, 163); // RR
end;

function ImportOneReturn(ADS: TDataSet; ASrcDir, ADstDir: String;
  out AErr: String; AOverride: Boolean): Boolean; // 20160617 Igor
var
  FlName: String;
  RApp: String;
  RYear, WorkRetNo, FNo, j: Integer;
  PrpStatus, EFstatus: String; //[2]; //20170612 Igor
  Notes: String; //[80]; //20170621 Igor
  //DbfDataDir: String[60]; //20170621 Igor
Begin
  result := False;
  FlName := Trim(ADS.FieldByName('File_Name').AsString);
  If FlName = '' then
  Begin
    AErr := 'Skip record. FileName is empty';
    exit;
  End;
  If Not FileExists(IncludeTrailingPathDelimiter(ASrcDir) + FlName) then  //20170621 Igor
  Begin
    AErr := 'Skip record. File "' + IncludeTrailingPathDelimiter(ASrcDir) + FlName + //20170621 Igor
      '" is missing';
    exit;
  End;
  if not GetReturnAppAndYear(ASrcDir, FlName, RApp, RYear,
    AppT4T5_2026.SQLLitePassword.PassArray) then // 20160703 Igor
  Begin
    AErr := 'Skip record. File "' + IncludeTrailingPathDelimiter(ASrcDir) + FlName + //20170621 Igor
      '" have bad format';
    exit;
  End;
  if (RApp <> 'TAXFORMS' { AppName } ) { or (RYear <> AppYearInt) } then
  Begin
    AErr := 'Skip record. File "' + IncludeTrailingPathDelimiter(ASrcDir) + FlName + //20170621 Igor
      '" does not belong to the current program';
    exit;
  End;
  WorkRetNo := 0; //20170621 Igor
  try // 20160311 Igor
    WorkRetNo := ReadReturn(ASrcDir, FlName, True);
  except
    ON E: Exception DO
    Begin
      AErr := 'Return "' + FlName + '" not read:' + #13 + E.Message;
      if WorkRetNo > 0 then
      Begin
        RemoveReturnFromMemory(WorkRetNo);
        WorkRetNo := 0;
      End;
    End;
  end;
  if WorkRetNo > 0 then
  begin
    StoreElm(WorkRetNo, GetFormNo('STATUS'), 4, '01'); // not started
    Ret[WorkRetNo].SourceDataDir := OptRec.Dir_Cur; { fooli t }
    PrpStatus := FetchElm(WorkRetNo, 'STATUS', 4);
    If Not Numeric(PrpStatus) then
      PrpStatus := '00';
    EFstatus := FetchElm(WorkRetNo, 'STATUS', 15);
    If Not Numeric(EFstatus) then
      EFstatus := '00';
    Notes := FetchElm(WorkRetNo, 'STATUS', 14);
    CalcAll(WorkRetNo);
    FNo := GetFormNo('STATUS');
    For j := 8 to 10 do
      StoreElm(WorkRetNo, FNo, j, '');
    For j := 18 to 30 do
      StoreElm(WorkRetNo, FNo, j, '');
    For j := 16 to 16 do
      StoreElm(WorkRetNo, FNo, j, '');
    For j := 14 to 14 do
      StoreElm(WorkRetNo, FNo, j, '');
    For j := 31 to 31 do
      StoreElm(WorkRetNo, FNo, j, '');

    For j := 11 to 11 do
      StoreElm(WorkRetNo, FNo, j, User.UserName); //20170112 Igor
    For j := 12 to 12 do
      StoreElm(WorkRetNo, FNo, j, FormatDateTime('yyyy-mm-dd', Date));
    { DateToStr(Date)); }
    For j := 13 to 13 do
      StoreElm(WorkRetNo, FNo, j, TimeToStr(Time));
    if Ret[WorkRetNo].Locked then
    Begin
      Ret[WorkRetNo].Locked := False;
    End;
    If not FileExists(IncludeTrailingPathDelimiter(ADstDir) + FlName) or AOverride //20170612 Igor
    then
      If SaveReturn(WorkRetNo, ADstDir, FlName, True, False) = 0 then
        result := True
      else
        AErr := 'An error occurred while saving the file to disk'
    else
      AErr := 'Record skipped. File "' + FlName +
        '" exists in destination folder.';
  end
  else
    AErr := 'Record skipped. Return not loaded';

  If WorkRetNo > 0 then
    RemoveReturnFromMemory(WorkRetNo);
End;

Function IsValidLastYearPgmFolder(AShowMessage: Boolean;
  out AErrorMessage: String): Boolean; // 20160629 Igor
Var
  LastYearPgm, LastYearBpl: String;
begin
  AErrorMessage := '';
  result := False;
  If OptRec.Dir_PgmLastYr = '' then
  begin
    AErrorMessage :=
      'You should first enter the program directory you used last year' +
      Chr(13) + 'See Configure | General Options | Data Directories.' + #13 +
      'You need to Exit and restart the program after changing last year’s data directory';
    // 20160706 Igor
    if AShowMessage then
      ShowMessage(AErrorMessage);
    exit;
  end;
  If (SysUtils.DirectoryExists(OptRec.Dir_PgmLastYr) = False) then //20170612 Igor
  Begin
    AErrorMessage := 'Last year program’s directory "' + OptRec.Dir_PgmLastYr +
      '" does not exist.' // 20160710 Igor
      + Chr(13) + 'See Configure | General Options | Data Directories' + #13 +
      'You need to Exit and restart the program after changing last year’s data directory';
    if AShowMessage then
      ShowMessage(AErrorMessage);
    exit;
  End;
  If FileExists(OptRec.Dir_PgmLastYr + '\' + FormsDBLite) = False then
  Begin
    if FileExists(OptRec.Dir_PgmLastYr + '\' + ChangeFileext(FormsDBLite,
      '.DBF')) = False then
    Begin
      AErrorMessage := 'Last Year' + Chr(39) + 's directory "' +
        OptRec.Dir_PgmLastYr + '" does not have a VisualTax form data base'
      // 20160710 Igor
        + Chr(13) + 'See Configure | General Options | Data Directories';
      if AShowMessage then
        ShowMessage(AErrorMessage);
      exit;
    End;
  End;
  LastYearPgm := AppName + IntToStr(StrToInt(Appyear) - 1) + '.EXE';
  LastYearBpl := 'vt' + AppName + '_' + IntToStr(StrToInt(Appyear) - 1)
    + '.bpl';
  If not FileExists(OptRec.Dir_PgmLastYr + '\' + LastYearPgm) AND
    not FileExists(OptRec.Dir_PgmLastYr + '\' + LastYearBpl) then
  Begin
    AErrorMessage := 'Last Year' + Chr(39) + 's directory "' +
      OptRec.Dir_PgmLastYr + '" does not have a VisualTax system files'
    // 20160710 Igor
      + Chr(13) + 'See Configure | General Options | Data Directories';
    if AShowMessage then
      ShowMessage(AErrorMessage);
    exit;
  End;
  // all tests passed
  result := True;
end;

function isValidLastYearDataFolder(AShowMessage: Boolean;
  out AErrorMessage: String): Boolean; // 20160629 Igor
Begin
  AErrorMessage := '';
  result := False;
  If OptRec.Dir_LastYr = '' then
  begin
    AErrorMessage :=
      'You should first enter the data directory you used last year' + Chr(13) +
      'See Configure | General Options | Data Directories';
    if AShowMessage then
      ShowMessage(AErrorMessage);
    exit;
  end;

  // 20160711 Igor
  If (SysUtils.DirectoryExists(OptRec.Dir_LastYr) = False) then //20170612 Igor
  Begin
    AErrorMessage := 'Last year data directory "' + OptRec.Dir_LastYr +
      '" does not exist.' // 20160710 Igor
      + Chr(13) + 'See Configure | General Options | Data Directories';
    if AShowMessage then // 20160516 Igor
      ShowMessage(AErrorMessage);
    exit;
  End;

  If not FileExists(OptRec.Dir_LastYr + '\' + OptRec.ClientsDBLite) then
  begin
    if not FileExists(OptRec.Dir_LastYr + '\' + ClientsTable_dbf) then
    Begin
      AErrorMessage := 'Last Year' + Chr(39) + 's directory "' +
        OptRec.Dir_LastYr + '" does not have a VisualTax Client data base'
      // 20160710 Igor
        + Chr(13) + 'See Configure | General Options | Data Directories';
      if AShowMessage then
        ShowMessage(AErrorMessage);
      exit;
    End;
  end;
  result := True;
End;

procedure InitLastYearFormsTable; // 20160629 Igor
var
  LastYearDir: string;
  f: TextFile;
begin
  LastYearDir := OptRec.Dir_PgmLastYr;
  If not SysUtils.DirectoryExists(LastYearDir) then //2070612 Igor
    exit;
  If FileExists(LastYearDir + '\' + FormsDBLite) then
  Begin
    FullPathT4T5Scr_LastYear := LastYearDir + '\' + FormsDBLite;
    // use original db file
  End
  else if FileExists(LastYearDir + '\' + ChangeFileext(FormsDBLite, '.DBF'))
  then
  begin
    FullPathT4T5Scr_LastYear := LastYearDir + '\' + ChangeFileext(FormsDBLite,
      '.DBF'); // use converted db
  end
  else
    exit; // bad directory
  If not FileExists(LastYearDir + '\' + FieldsListD) then
  begin // create empty file
    assign(f, LastYearDir + '\' + FieldsListD);
    rewrite(f);
    CloseFile(f);
  end;

  FLastYearList := TFListT4T5.create(AppT4T5_2026, FormsLimit, FieldsLimit,
    FullPathT4T5Scr_LastYear, FormsTableLite, LastYearDir);
  // 20160710 Igor
  if not FLastYearList.InitFormsTable(LastYearDir, FullPathT4T5Scr_LastYear,
    FormsTableLite) then
  begin
    freeAndNil(FLastYearList);
    exit;
  end;
end;

Function GetRenamedFName(FName: String): String; // 20160629 Igor
Var
  TempList: TStringList;
  FInst: String;
  I: Integer;
begin
  result := FName;
  if FileExists(Appdir + '\' + 'Substit.d') then
  begin
    TempList := TStringList.create;
    TempList.LoadFromFile(Appdir + '\' + 'Substit.d');
    FInst := ExtractFormInst(FName);
    FName := ExtractFormRootName(FName);
    For I := 0 to TempList.Count - 1 do
      If UpperCase(FName) = Rtrim(UpperCase(LeftStr(TempList[I], 10))) then
      begin
        result := UpperCase(AllTrim(MidStr(TempList[I], 14, 10)));
        result := result + FInst;
        TempList.free;
        exit;
      end;
    TempList.free;
  end;
end;

function GetLastYearFormNo(FormName: String): Integer;
begin
  result := FLastYearList.ByFormName(UpperCase(FormName)).FormNo;
end;

function GetLastYearFormName(FormNo: Integer): String;
begin
  result := FLastYearList.GetFormName(FormNo);
end;

Function ShowUnconvertedLastYear(RNo: Integer): Boolean; // 20160629 Igor
begin
  result := False;
  If RNo = 0 then
    exit;
  result := Ret[RNo].IsLastYearReturn;
end;

function GetLastYearFile(ARetNo: Integer): String; // 20160701 Igor
Begin
  result := FetchElm(ARetNo, 'STATUS', c_LastYearElm);
End;

procedure SetLastYearFile(const ARetNo: Integer; AValue: String);
// 20160701 Igor
begin
  StoreElm(ARetNo, 'STATUS', c_LastYearElm, AValue);
end;

procedure ClearDigitT4(ARetNo, AFormNo: integer); //20170123 Igor
var
  I: Integer;
const
  DigitElm: array [0..28] of Integer = (30,31,32,33,34,35,36,37,38,39,40,41,18,
    19,20,21,22,24,25,26,8,9,44,27,28,29,23,45,46);
begin
  for I := Low(DigitElm) to High(DigitElm) do
    Ret[ARetNo].Frm[AFormNo].Elms[DigitElm[I]] := '';
end;

procedure ClearDigitT4A(ARetNo, AFormNo: integer); //20170123 Igor
var
  I: Integer;
const
  DigitElm: array [0..29] of Integer = (14,15,18,17,19,16,20,21,22,23,24,25,26,
    27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43);
begin
  for I := Low(DigitElm) to High(DigitElm) do
    Ret[ARetNo].Frm[AFormNo].Elms[DigitElm[I]] := '';
end;

procedure ClearDigitT5(ARetNo, AFormNo: integer); //20170123 Igor
var
  I: Integer;
const
  DigitElm: array [0..10] of Integer = (2,3,4,5,6,7,8,9,14,16,18);
begin
  for I := Low(DigitElm) to High(DigitElm) do
    Ret[ARetNo].Frm[AFormNo].Elms[DigitElm[I]] := '';
end;

Function ValidateFootNote(Cd: String; Amt: Real): Boolean;
begin
  Result := (((Amt = 0) and (Cd = '')) or ((Amt <> 0) and (Cd > '')));
end;

function ValidateSlips(ARetNo: Integer; ASlipName: String): String;//20170216 Igor
Begin
  if SameText(ASlipName, 'T4') then
    Result := ValidateAllT4Slips(ARetNo)
  else
  if SameText(ASlipName, 'T4A') then
    Result := ValidateAllT4ASlips(ARetNo)
  else
  if SameText(ASlipName, 'T5') then
    Result := ValidateAllT5Slips(ARetNo)
  else
    raise Exception.Create('Unknown slip "' + ASlipName + '"');

End;

function ValidateAllT4Slips(ARetNo: Integer): String; //20170216 Igor
var
  FRecArray: TFRecArray;
  I: Integer;
begin
  Result:='';
  FRecArray := FList.GetAllInstForms('T4');
  If length(FRecArray) = 0 then
  begin
    ShowMessage('Cannot find T4 slips');
    exit;
  end;
  for I := Low(FRecArray) to High(FRecArray) do
  begin
    If (MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4_Box14)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4_Box20)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4_Box52)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4_Box55)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4_Box56)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4_Box24)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4_Box16)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4_Box18)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4_Box22)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4_Amount1)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4_Amount2)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4_Amount3)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4_Amount4)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4_Amount5)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4_Amount6))) = 0 then
    begin
      if Result <> '' then
        Result := Result + ', ';
      result := Result + FetchElm(ARetNo, FRecArray[I].FormInstName, T4_LASTNAME) + ' ' +
                         FetchElm(ARetNo, FRecArray[I].FormInstName, T4_FIRSTNAME);
    end;
  end;
End;

function ValidateAllT4ASlips(ARetNo: Integer): String; //20170216 Igor
var
  FRecArray: TFRecArray;
  I: Integer;
  procedure AddFullName(AIndex: Integer);
  begin
    if Result <> '' then
      Result := Result + ', ';
    result := FetchElm(ARetNo, FRecArray[AIndex].FormInstName, T4A_LASTNAME) + ' ' +
              FetchElm(ARetNo, FRecArray[AIndex].FormInstName, T4A_FIRSTNAME);
  end;
  function CheckFooter(AIndex, ACDBox, AAmtBox: Integer): Boolean;
  var
    Cd: String;
    Amt: Currency;
  Begin
    Cd := AllTrim(FetchElm(ARetNo, FRecArray[AIndex].FormInstName, ACDBox));
    Amt := MyStrToFloat(FetchElm(ARetNo, FRecArray[AIndex].FormInstName, AAmtBox));
    If not ValidateFootNote(Cd, Amt) then
      AddFullName(AIndex);
    Result := True; //20170621 Igor
  End;
begin
  Result:='';
  FRecArray := FList.GetAllInstForms('T4A');
  If length(FRecArray) = 0 then
  begin
    ShowMessage('Cannot find T4A slips');
    exit;
  end;
  for I := Low(FRecArray) to High(FRecArray) do
  begin
    If (MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4A_Box16)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4A_Box18)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4A_Box20)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4A_Box22)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4A_Box24)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4A_Box48)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4A_FT_AMT1)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4A_FT_AMT2)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4A_FT_AMT3)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4A_FT_AMT4)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4A_FT_AMT5)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4A_FT_AMT6)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4A_FT_AMT7)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4A_FT_AMT8)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4A_FT_AMT9)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4A_FT_AMT10)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4A_FT_AMT11)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T4A_FT_AMT12))) = 0 then
      AddFullName(I);
    if CheckFooter(I, T4A_FT_CD1, T4A_FT_AMT1) then
    if CheckFooter(I, T4A_FT_CD2, T4A_FT_AMT2) then
    if CheckFooter(I, T4A_FT_CD3, T4A_FT_AMT3) then
    if CheckFooter(I, T4A_FT_CD4, T4A_FT_AMT4) then
    if CheckFooter(I, T4A_FT_CD5, T4A_FT_AMT5) then
    if CheckFooter(I, T4A_FT_CD6, T4A_FT_AMT6) then
    if CheckFooter(I, T4A_FT_CD7, T4A_FT_AMT7) then
    if CheckFooter(I, T4A_FT_CD8, T4A_FT_AMT8) then
    if CheckFooter(I, T4A_FT_CD9, T4A_FT_AMT9) then
    if CheckFooter(I, T4A_FT_CD10, T4A_FT_AMT10) then
    if CheckFooter(I, T4A_FT_CD11, T4A_FT_AMT11) then
      CheckFooter(I, T4A_FT_CD12, T4A_FT_AMT12);
  end;
End;

function ValidateAllT5Slips(ARetNo: Integer): String; //20170216 Igor
var
  FRecArray: TFRecArray;
  I: Integer;
begin
  Result:='';
  FRecArray := FList.GetAllInstForms('T5');
  If length(FRecArray) = 0 then
  begin
    ShowMessage('Cannot find T5 slips');
    exit;
  end;
  for I := Low(FRecArray) to High(FRecArray) do
  begin
    If (MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T5_Box10)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T5_Box11)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T5_Box12)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T5_Box13)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T5_Box24)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T5_Box25)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T5_Box26)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T5_Box14)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T5_Box15)) +
       {TODO : Check Box16}
       {MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T5_Box16)) +}
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T5_Box17)) +
       MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T5_Box18)) {+}
       {TODO : Check Box19}
       {MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T5_Box19)) +}
       {TODO : Check Box20}
       {MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T5_Box20)) +}
       {TODO : Check Box40}
       {MyStrToFloat(FetchElm(ARetNo, FRecArray[I].FormInstName, T5_Box40))}) = 0 then
    begin
      if Result <> '' then
        Result := Result + ', ';
      result := Result + FetchElm(ARetNo, FRecArray[I].FormInstName, T5_LASTNAME_FIRSTNAME);
    end;
  end;
End;

function IsPhoneFormat(AValue: String): Boolean; //20170216 Igor
Begin
  Result := TRegEx.isMatch(AValue, '^[\d]{3,3}-[\d]{4,4}$');
End;

Function FixPostal(s: String): String; //20170216 Igor
{remove space or dash}
begin
  Result := RemoveChar(RemoveChar(s, ' '),'-');
end;

Function GetEmailAddr: String; //20170216 Igor
Var 
  tempList: TstringList;
  EmailAddrFile: String;
begin
  EmailAddrFile := IncludeTrailingPathDelimiter(AppDir)+'EmailAddr.d';
  Result:='';
  If FileExists(EmailAddrFile) then
  begin
    TempList := TStringList.Create;
    try
      TempList.LoadFromFile(EmailAddrFile);
      If Templist.Count > 0 then 
        result := TempList[0];
    finally
      TempList.Free;
    end;
  end;
end;

Procedure SummarizeT4Slips(ARetNo: Integer; Var T4Sum: TT4Sum); //20170216 Igor
var
  InstForms: TFRecArray;
  I: Integer;
begin
  {initialize global variables}
  InstForms := FList.GetAllInstForms('T4');
  with T4Sum do
  begin
    TotBox14 := 0;
    TotBox20 := 0;
    TotBox52 := 0;
    TotBox55 := 0;
    TotBox56 := 0;
    TotBox24 := 0;
    TotBox16 := 0;
    TotBox16e := 0;  //29250124
    TotBox18 := 0;
    TotBox22 := 0;
    TotBox83 := 0;
    TotCPPAdj := 0;
    TotEIAdj := 0;
    TotTotAdj := 0;
    EmployerCPP := 0;
    EmployerEI := 0;
    SubTot := 0;
    Diff := 0;
    OverPay := 0;
    Balance := 0;
    NewHires := 0;
    T4Remit := 0;
    EncloseT4 := 0;
  end;

  with T4Sum do
  begin
    NumSlips := FetchElm(ARetNo,'T4SUM',7); //jz 20190502
    for I := Low(InstForms) to High(InstForms) do
    begin
      TotBox14 := TotBox14 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T4_Box14));
      TotBox20 := TotBox20 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T4_Box20));
      TotBox52 := TotBox52 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T4_Box52));
      TotBox55 := TotBox55 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T4_Box55));
      TotBox56 := TotBox56 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T4_Box56));
      TotBox24 := TotBox24 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T4_Box24));
      TotBox16 := TotBox16 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T4_Box16));
      TotBox16e := TotBox16e + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T4_Box16e));//20250124
      TotBox18 := TotBox18 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T4_Box18));
      TotBox22 := TotBox22 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T4_Box22));
      {TODO : Check T4_ADJCPP, T4_ADJUI, T4_ADJTax}
      {TotCPPAdj := TotCPPAdj + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T4_ADJCPP));
      TotEIAdj := TotEIAdj + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T4_ADJUI));
      TotTotAdj := TotTotAdj + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T4_ADJTax));}
    end;
  end;
  T4Sum.EmployerCPP := T4Sum.TotBox16;
  T4Sum.EmployerCPPe := T4Sum.TotBox16e;   //20250124
{calc balance}
  with T4Sum do
  begin
    {TODO : Check EMPL_EncloseT4}
    {EncloseT4 := MyStrToFloat(FetchElm(ARetNo, 'EMPL', EMPL_EncloseT4));}
    EmployerEI := TotBox18 * 1.64;  //1.40; //20251207  //20180222
   // EmployerEI := TotBox18 * MyStrToFloat(FetchElm(ARetNo, 'EMPL', EMPL_UIRate)); //20180222
    TotDed := TotBox16 + EmployerCPP + TotBox18 + EmployerEI + TotBox22;
    T4Remit := MyStrToFloat(FetchElm(ARetNo, 'EMPL', EMPL_RemitT4));
    SubTot := TotDed - T4Remit;
    NewHires := 0;
    Diff := SubTot - NewHires;
    if Diff < 0 then
    begin
      OverPay := ABS(Diff);
      Balance := 0;
    end
    else
    begin
      OverPay := 0;
      Balance := Diff;
    end;
  end;
end;

Procedure SummarizeT4ASlips(ARetNo: Integer; Var T4ASum: TT4ASum); //20170217 Igor
var
  InstForms: TFRecArray;
  I: Integer;
begin
 {initialize global variables}
  InstForms := FList.GetAllInstForms('T4A');
  with T4ASum do
  begin
    TotBox16 := 0;
    TotBox18 := 0;
    TotBox20 := 0;
    TotBox22 := 0;
    TotBox24 := 0;
    TotBox28 := 0;
    TotBox26 := 0;
    TotBox27 := 0;
    TotBox30 := 0;
    TotBox32 := 0;
    TotBox34 := 0;
    TotBox40 := 0;
    TotBox42 := 0;
    TotBox48 := 0;
    TotBox101 := 0;
    Diff := 0;
    OverPay := 0;
    Balance := 0;
    T4ARemit := 0;
    T4AEnclosed := 0;
  end;

  with T4ASum do
  begin
    NumSlips := alltrim(FetchElm(ARetNo,'T4ASUM',7)); //jz 20190502
    for I := Low(InstForms) to High(InstForms) do
    begin
      //from main t4a slips
      TotBox16 := TotBox16 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T4A_Box16));
      TotBox18 := TotBox18 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T4A_Box18));
      TotBox20 := TotBox20 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T4A_Box20));
      TotBox22 := TotBox22 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T4A_Box22));
      TotBox24 := TotBox24 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T4A_Box24));
      TotBox48 := TotBox48 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T4A_Box48));

      //from other info
      GetFootCodeTotal(ARetNo, InstForms[I], '028', TotBox28);
      GetFootCodeTotal(ARetNo, InstForms[I], '030', TotBox30);
      GetFootCodeTotal(ARetNo, InstForms[I], '032', TotBox32);
      GetFootCodeTotal(ARetNo, InstForms[I], '034', TotBox34);
      GetFootCodeTotal(ARetNo, InstForms[I], '040', TotBox40);
      GetFootCodeTotal(ARetNo, InstForms[I], '042', TotBox42);

      // calc the total 101
      GetFootCodeTotal(ARetNo, InstForms[I], '026', TotBox26);
      GetFootCodeTotal(ARetNo, InstForms[I], '027', TotBox27);
      GetFootCodeTotal(ARetNo, InstForms[I], '046', TotBox46);
      GetTotBox101(ARetNo, InstForms[I], TotBox101);  //anything above code 101
    end;
    TotBox101 := TotBox101 + TotBox26 + TotBox27 + TotBox46; //add box 26, 27 and 46 to code 101
  end;
{calc balance}
  with T4ASum do
  begin
    TotDed := TotBox22;
    T4ARemit := myStrToFloat(FetchElm(ARetNo, 'EMPL', EMPL_RemitT4A));
    {TODO : check EMPL_EncloseT4A}
    {T4AEnclosed := myStrToFloat(FetchElm(ARetNo, 'EMPL', EMPL_EncloseT4A));}
    Diff := TotDed - T4ARemit;
    if Diff < 0 then
    begin
      OverPay := ABS(Diff);
      Balance := 0;
    end
    else
    begin
      OverPay := 0;
      Balance := Diff;
    end;
  end;
end;

Procedure GetFootCodeTotal(ARetNo: Integer; ARec: TFRec; ACd: String; Var TotBox: Real);//20170217 Igor
begin
  if FetchElm(ARetNo, ARec.FormNo, T4A_FT_CD1) = ACD then
    TotBox := TotBox + MyStrToFloat(FetchElm(ARetNo, ARec.FormNo, T4A_FT_Amt1));
  if FetchElm(ARetNo, ARec.FormNo, T4A_FT_CD2) = ACD then
    TotBox := TotBox + MyStrToFloat(FetchElm(ARetNo, ARec.FormNo, T4A_FT_Amt2));
  if FetchElm(ARetNo, ARec.FormNo, T4A_FT_CD3) = ACD then
    TotBox := TotBox + MyStrToFloat(FetchElm(ARetNo, ARec.FormNo, T4A_FT_Amt3));
  if FetchElm(ARetNo, ARec.FormNo, T4A_FT_CD4) = ACD then
    TotBox := TotBox + MyStrToFloat(FetchElm(ARetNo, ARec.FormNo, T4A_FT_Amt4));
  if FetchElm(ARetNo, ARec.FormNo, T4A_FT_CD5) = ACD then
    TotBox := TotBox + MyStrToFloat(FetchElm(ARetNo, ARec.FormNo, T4A_FT_Amt5));
  if FetchElm(ARetNo, ARec.FormNo, T4A_FT_CD6) = ACD then
    TotBox := TotBox + MyStrToFloat(FetchElm(ARetNo, ARec.FormNo, T4A_FT_Amt6));
  if FetchElm(ARetNo, ARec.FormNo, T4A_FT_CD7) = ACD then
    TotBox := TotBox + MyStrToFloat(FetchElm(ARetNo, ARec.FormNo, T4A_FT_Amt7));
  if FetchElm(ARetNo, ARec.FormNo, T4A_FT_CD8) = ACD then
    TotBox := TotBox + MyStrToFloat(FetchElm(ARetNo, ARec.FormNo, T4A_FT_Amt8));
  if FetchElm(ARetNo, ARec.FormNo, T4A_FT_CD9) = ACD then
    TotBox := TotBox + MyStrToFloat(FetchElm(ARetNo, ARec.FormNo, T4A_FT_Amt9));
  if FetchElm(ARetNo, ARec.FormNo, T4A_FT_CD10) = ACD then
    TotBox := TotBox + MyStrToFloat(FetchElm(ARetNo, ARec.FormNo, T4A_FT_Amt10));
  if FetchElm(ARetNo, ARec.FormNo, T4A_FT_CD11) = ACD then
    TotBox := TotBox + MyStrToFloat(FetchElm(ARetNo, ARec.FormNo, T4A_FT_Amt11));
  if FetchElm(ARetNo, ARec.FormNo, T4A_FT_CD12) = ACD then
    TotBox := TotBox + MyStrToFloat(FetchElm(ARetNo, ARec.FormNo, T4A_FT_Amt12));
end;

Procedure GetTotBox101(ARetNo: Integer; ARec: TFRec; Var TotOther: Real); //20170217 Igor
begin
  if FetchElm(ARetNo, ARec.FormNo, T4A_FT_CD1) > '101' then
    TotOther := TotOther + MyStrToFloat(FetchElm(ARetNo, ARec.FormNo, T4A_FT_Amt1));
  if FetchElm(ARetNo, ARec.FormNo, T4A_FT_CD2) > '101' then
    TotOther := TotOther + MyStrToFloat(FetchElm(ARetNo, ARec.FormNo, T4A_FT_Amt2));
  if FetchElm(ARetNo, ARec.FormNo, T4A_FT_CD3) > '101' then
    TotOther := TotOther + MyStrToFloat(FetchElm(ARetNo, ARec.FormNo, T4A_FT_Amt3));
  if FetchElm(ARetNo, ARec.FormNo, T4A_FT_CD4) > '101' then
    TotOther := TotOther + MyStrToFloat(FetchElm(ARetNo, ARec.FormNo, T4A_FT_Amt4));
  if FetchElm(ARetNo, ARec.FormNo, T4A_FT_CD5) > '101' then
    TotOther := TotOther + MyStrToFloat(FetchElm(ARetNo, ARec.FormNo, T4A_FT_Amt5));
  if FetchElm(ARetNo, ARec.FormNo, T4A_FT_CD6) > '101' then
    TotOther := TotOther + MyStrToFloat(FetchElm(ARetNo, ARec.FormNo, T4A_FT_Amt6));
  if FetchElm(ARetNo, ARec.FormNo, T4A_FT_CD7) > '101' then
    TotOther := TotOther + MyStrToFloat(FetchElm(ARetNo, ARec.FormNo, T4A_FT_Amt7));
  if FetchElm(ARetNo, ARec.FormNo, T4A_FT_CD8) > '101' then
    TotOther := TotOther + MyStrToFloat(FetchElm(ARetNo, ARec.FormNo, T4A_FT_Amt8));
  if FetchElm(ARetNo, ARec.FormNo, T4A_FT_CD9) > '101' then
    TotOther := TotOther + MyStrToFloat(FetchElm(ARetNo, ARec.FormNo, T4A_FT_Amt9));
  if FetchElm(ARetNo, ARec.FormNo, T4A_FT_CD10) > '101' then
    TotOther := TotOther + MyStrToFloat(FetchElm(ARetNo, ARec.FormNo, T4A_FT_Amt10));
  if FetchElm(ARetNo, ARec.FormNo, T4A_FT_CD11) > '101' then
    TotOther := TotOther + MyStrToFloat(FetchElm(ARetNo, ARec.FormNo, T4A_FT_Amt11));
  if FetchElm(ARetNo, ARec.FormNo, T4A_FT_CD12) > '101' then
    TotOther := TotOther + MyStrToFloat(FetchElm(ARetNo, ARec.FormNo, T4A_FT_Amt12));
end;

Procedure SummarizeT5Slips(ARetNo: Integer; Var T5Sum: TT5Sum); //20170217 Igor
var
  InstForms: TFRecArray;
  I: Integer;
begin
  InstForms := FList.GetAllInstForms('T5');
  {initialize global variables}
  with T5Sum do
  begin
    TotBox10 := 0;
    TotBox11 := 0;
    TotBox12 := 0;
    TotBox13 := 0;
    TotBox14 := 0;
    TotBox15 := 0;
    TotBox16 := 0;
    TotBox17 := 0;
    TotBox18 := 0;
    TotBox19 := 0;
    TotBox24 := 0;
    TotBox25 := 0;
    TotBox26 := 0;
  end;

  with T5Sum do
  begin
    T4T5_2026calc.T5SUM(ARetNo,'T5SUM', 8);  //20240222 CZ
    NumSlips := alltrim(FetchElm(ARetNo,'T5SUM',38)); //jz 20190502
    for I := Low(InstForms) to High(InstForms) do
    begin
      TotBox10 := TotBox10 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T5_Box10));
      TotBox11 := TotBox11 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T5_Box11));
      TotBox12 := TotBox12 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T5_Box12));
      TotBox13 := TotBox13 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T5_Box13));
      TotBox14 := TotBox14 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T5_Box14));
      TotBox15 := TotBox15 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T5_Box15));
      {TODO : check T5_Box16}
      {TotBox16 := TotBox16 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T5_Box16));}
      TotBox17 := TotBox17 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T5_Box17));
      TotBox18 := TotBox18 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T5_Box18));
      {TODO : check T5_Box16}
      {TotBox19 := TotBox19 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T5_Box19));}
      TotBox24 := TotBox24 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T5_Box24));
      TotBox25 := TotBox25 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T5_Box25));
      TotBox26 := TotBox26 + MyStrToFloat(FetchElm(ARetNo, InstForms[I].FormNo, T5_Box26));
    end;
  end;
end;

function QuickFormFind(RetNo: integer; AFormName: String): Boolean; //20170418 Igor
Var
  i, Elm, FNo: Integer;
  FName: String;
  ResultsList: TStringList;
  List1: TStringList;
begin
  Result := False;
  AFormName := UpperCase(AFormName);
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If AFormName = AllTrim(ExtractFormRootName(Frec.FormName)) then
    begin
      FNo := GetFormNo(Frec.FormInstName);
      If FNo > 0 then
      begin
        OpenForm(RetNo, FNo, 0);
        exit(True);
      end;
    end;
  end;
  List1 := TStringList.Create;
  try
    List1.Sorted := True;
    for i := 0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      If Frec.FormShow then
        List1.Add(PaddR(Frec.FormAbrev, 80) + Frec.FormInstName);
    end;
    ResultsList := TStringList.Create;
    try
      IsAnyWhereInList(AFormName, List1, ResultsList);
      If ResultsList.Count = 0 then
      begin
        ShowTimedMsg('Not found!', 1300);
        Exit;
      end;
      SomeCaption := 'Form or KeyWord found in following';
      SelectedString := PopSomeList(ResultsList, SomeCaption);
      If SelectedString > '' then
      begin
        FName:=UpperCase(AllTrim(MidStr(SelectedString, 85, 10)));
        FNo := GetFormNo(FName);
        If FNo > 0 then
        begin
          OpenForm(RetNo, FNo, 0);
          exit(True);
        end;
      end;
    finally
      ResultsList.Free;
    end;
  finally
    List1.Free;
  end;
end;




//20170902
Function ValidSin(SiNum: string):boolean;
begin
Result := True;
{EXIT;}
If Length(SiNum) = 0 then exit;
If Length(SiNum) <> 9 then begin Result := false;exit;end;
If ChkDigit(LeftStr(SiNum,8)) <> StrToInt(RightStr(SiNum,1))
   then Result := false;
end;

//20170902
Function ChkDigit(SiNum8: string):Integer;
{Returns the check digit}
Var Dig1,Dig2,Dig3,Dig4,Dig5,Dig6,Dig7,Dig8,Dig9 : string[1];
Dg0,Dg1,Dg2,Dg3,Dg4,Dg5 : string[1];
UnitNum : string[4];
i, UnitNumb,x,y,z,w,CheckDg, NextNum : integer;
Tot : string[10];
begin
     {Result := -1;}   {False}
     If Length(SiNum8) <> 8 then exit;
     For i := 1 to 8 do
     begin
      If (MidStr(SiNum8,i,1) <'0') or
         (MidStr(SiNum8,i,1) > '9')
        then exit;
     end;

     DIG1 := LEFTStr(SINUM8, 1);
     DIG2 := MIDStr(SINUM8, 2, 1);
     DIG3 := MIDStr(SINUM8, 3, 1);
     DIG4 := MIDStr(SINUM8, 4, 1);
     DIG5 := MIDStr(SINUM8, 5, 1);
     DIG6 := MIDStr(SINUM8, 6, 1);
     DIG7 := MIDStr(SINUM8, 7, 1);
     DIG8 := MIDStr(SINUM8, 8, 1);
    { DIG9 := MIDStr(SINUM, 9, 1);}
     UNITNUM := DIG2 + DIG4 + DIG6 + DIG8;
     UNITNUMB := StrToInt(UNITNUM);
     UNITNUMB := UNITNUMB * 2;
     TOT := IntToStr(UNITNUMB);
     {dg0 and dg5 are dummies for sign and provision for larger length}
     DG0 := LEFTStr(TOT, 1);
     DG1 := MIDStr(TOT, 2, 1);
     DG2 := MIDStr(TOT, 3, 1);
     DG3 := MIDStr(TOT, 4, 1);
     DG4 := MIDStr(TOT, 5, 1);
     DG5 := MIDStr(TOT, 6, 1);
     If Dg0 = '' then Dg0 := '0';
     If Dg1 = '' then Dg1 := '0';
     If Dg2 = '' then Dg2 := '0';
     If Dg3 = '' then Dg3 := '0';
     If Dg4 = '' then Dg4 := '0';
     If Dg5 = '' then Dg5 := '0';
     X := StrToInt(DG0) + StrToInt(DG1) + StrToInt(DG2) +
         StrToInt(DG3) + StrToInt(DG4) + StrToInt(DG5);

     Y := StrToInt(DIG1) + StrToInt(DIG3) + StrToInt(DIG5) + StrToInt(DIG7);
     Z := X + Y;
     {REM PRINT X,Y,Z}
     W := Z div 10;
     NEXTNUM := (W * 10);
     IF NEXTNUM < Z THEN NEXTNUM := NEXTNUM + 10;
     Result := NEXTNUM - Z;
     {CHECKDG := NEXTNUM - Z;}
     {IF CHECKDG = StrToInt(DIG9) THEN Result := True;}
end;

//20170902
Function ValidPostal(Country:String;PostCode:String):Boolean; //20130221 //or PROVINCE
Var PostalCode:String[10];
begin
 Result := true;
 If PostCode='' then begin Result:=False;Exit; end;
 If UpperCase(Country)='ZZZ' then Exit;
 If UpperCase(Country)='USA' then Exit; //20140115
 If (UpperCase(Country)='CAN') or (UpperCase(Country)='CA') then // or  (UpperCase(Country)<>'ZZZ') then //20140115
 Begin //validate it
   PostalCode := RemoveChar(UpperCase(MTrim(PostCode)),' ');  //20171223
   If (Numeric(PostalCode[1])) or
    (Numeric(PostalCode[3])) or
    (Numeric(PostalCode[5])) or
    (not Numeric(PostalCode[2])) or
    (not Numeric(PostalCode[4])) or
    (not Numeric(PostalCode[6]))
  then result := false;
 end
end;

//20170902
Function ValidateBusNo(S:string):Boolean;
begin
 result := true;
 If Length(s) <> 15 then begin result :=False;exit;end;
 If ValidSin(LeftStr(s,9))= false then begin result :=False;exit;end;
 If Numeric(MidStr(s,10,1)) then begin result :=False;exit;end;
 If Numeric(MidStr(s,11,1)) then begin result :=False;exit;end;
end;

//20170902
Function ValidateT5Filer(S:string):Boolean;
begin
 result := true;
 If Length(s) =0 then exit;
 {
 If Length(s) <> 15 then begin result :=False;exit;end;
 If ValidSin(LeftStr(s,9))= false then begin result :=False;exit;end;
 If Numeric(MidStr(s,10,1)) then begin result :=False;exit;end;
 If Numeric(MidStr(s,11,1)) then begin result :=False;exit;end;
 //If Numeric(MidStr(s,1,1)) then begin result :=False;exit;end;
 //If Numeric(MidStr(s,1,1)) then begin result :=False;exit;end;
 }
end;

//20170906
Procedure RecalcAllSlips(RetNo:Integer;SlipName:String);
Var i,FNo:Integer;
Begin

  for i :=0 to (FList.count-1) do
  begin
    FRec := FList.Items[i];
    if Frec.FormName = SlipName then
    begin
       FNo :=Frec.FormNo;
        //20170910
       if SlipName='T4'  then T4(RetNo,SlipName,FNo);
       if SlipName='T4A' then T4A(RetNo,SlipName,FNo);
       if SlipName='T5'  then T5(RetNo,SlipName,FNo);
    end;
  end;
  CountDiagnostics(RetNo);    //20180223
End;

Function RoundToTwo(x:Real):Real;
Begin
 Result:=round(x*100)/100;
End;


(* Needs a better way.  It will not work or too heavy if hundred of slps

//may be make a stringlist of all SINS, sorted and find duplicates
Function FindDuplicateSinFNo(RetNo:Integer;SlipName:String;Sin:String):Integer; //20171228
//returns the FNo of the slip that is duplicate
Var i:Integer;FNo,Sin,SinElmNo:Integer;
Begin
 result:=0;

 SlipName:=UpperCase(SlipName);
 if   SlipName='T4'     then SinElm:=7
 Else if SlipName='T4A' then SinElm:=4
 Else if SlipName='T5'  then SinElm:=11
 Else Exit;

 for I := 0 to (FList.Count - 1) do
 begin
    FRec := FList.Items[I];
    FNo:=Frec.FormNo;
    if UpperCase(Frec.FormName)=SlipName then
    Begin
      if FetchElmFNo(RetNo,FNo,SinElmNo)=Sin then
      Begin Result:=FNo;Exit;end;
    End;
 end;
end;
*)

//20171230
Function IsFormMultiInst(Frm: String): Boolean;
Var
I : integer;
begin           //20101220  formname to Frm
 Result := False;
 i := Length(Frm);
 While i >0 do
  begin
   If Frm[i] = '#' then begin Result := True; exit; end;
   Dec(i);
  end;
end;

Function TotBox(RetNo: Integer; BoxId: String): Real;
var
  I, FNo: Integer;
begin
  result := 0;

  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    if FRec.FormName = 'T5' then
    Begin
     FNo := FRec.FormNo;
     if FetchElm(RetNo,Fno,13)=BoxId then Result:=Result+Vl(FetchElm(RetNo,FNo,14));
     if FetchElm(RetNo,Fno,15)=BoxId then Result:=Result+Vl(FetchElm(RetNo,FNo,16));
     if FetchElm(RetNo,Fno,17)=BoxId then Result:=Result+Vl(FetchElm(RetNo,FNo,18));
    End;
  end;
end;


//20180106
Function IsReadyForEfile(RetNo:Integer;SlipType:String):Boolean;
Begin
 Result:=False;
 if (SlipType='T4') and (UpperCase(FetchElm(RetNo,'EMPL',17))='READY FOR EFILE')  then
   begin Result:=True;Exit;End;

 if (SlipType='T4A') and (UpperCase(FetchElm(RetNo,'EMPL',39))='READY FOR EFILE')  then
   begin Result:=True;Exit;End;

 if (SlipType='T5') and (UpperCase(FetchElm(RetNo,'EMPL',40))='READY FOR EFILE')  then
   begin Result:=True;Exit;End;
End;

Function IsAlreadyEfiled(RetNo:Integer;SlipType:String):Boolean;
Begin
 Result:=False;
 if (SlipType='T4') and (UpperCase(FetchElm(RetNo,'EMPL',17))='EFILED')  then
   begin Result:=True;Exit;End;

 if (SlipType='T4A') and (UpperCase(FetchElm(RetNo,'EMPL',39))='EFILED')  then
   begin Result:=True;Exit;End;

 if (SlipType='T5') and (UpperCase(FetchElm(RetNo,'EMPL',40))='EFILED')  then
   begin Result:=True;Exit;End;
End;


Function CalcCpp2(EmplIncome:Real):Real;
Begin
  Result:=0;
  If (EmplIncome>MaxCPPEarnings) then //and (Tv[18]<CPP2MaxCppEarnings) then //20241221
  begin
    Result:=MinR(396,(EmplIncome-MaxCPPEarnings)*4/100); //20260111
    //Result:=MinR(188,(EmplIncome-MaxCPPEarnings)*4/100); //20241220
  end;
end;

end.
