unit T2_2027TrimStr;
// rev. 2014-07-29
{$B-}
// IGOR

interface

uses
  SysUtils, FileCtrl, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls, Dialogs, DBctrls, ExtCtrls, Printers, DB, ShellApi, ComObj,
  IniFiles,
  IdHttp, // 20150624
  Registry, ClipBrd, ComCtrls, vtEditBox, vtLabel, vtShape, EkRtf,
  ekbasereport, ekfunc, Wininet, vtMulti,
  vtDynData, // 20150824
  T2_2027Declare, // 50160524 Igor
  System.IOUtils, // 20181002 Igor
  rxRichEd; // 20160819 Igor (Must be last)

// 20160512
// 20160402  New for handling dynamic form Efiling
// function MkDynamicRSIAmountRec(RetNo: Integer; Ln: string; FName: string; FNo: Integer; RsiElm:Integer): string;
// 20171202

Function ExemptClassesForFirstYearRule(aclass:String):Boolean;  //20260718CZ
Function S8NeedsConversion(RetNo:Integer):Boolean; //20260530
Function IsEnterpriseForm(Fname:string):Boolean; //20240707
Function IsABStep1(RetNo:Integer):Boolean; //20250621
Function IsABStep2(RetNo:Integer):Boolean; //20250621
Function IsABStep3(RetNo:Integer):Boolean; //20240620

Function IsSubstantiveCCPC(RetNo:Integer):Boolean;
Procedure SetAddOnStatus;  //20231031
Procedure FindDuplicates(flName: string);
Function DIEPClass(CCAClass: String): Boolean; // 20220611
function CalcCheckDigitForT7DROCR(ALine: string): string; // 20210614
Function IsMultJurisdiction(RetNo: integer): Boolean; // 202200611
Procedure GetListOfS60Projects(RetNo: integer; AList: TStrings);
Procedure OpenT1ClientBook; // 20200919
Function CreateT1return(Sin: String): integer; // 20200919
Function AddNextInstance(RetNo: integer; FormName: String): integer;
Procedure SortTaxForms(FormsToPrint, PrintSeqList, SortedList: TStringList);
// 20200506
Procedure SendEmail(RetNo: integer; SomeSubject, SomeRecipientEMail,
  SomeSenderEMail, SomeAttachment, SomeText: String);
Function GetSignatureFilePath(RetNo: integer): String; // 20200320
Function FixBusinessNumberMissingRC(BN: String): String; // 20190820
Function Leasehold(cls: String): Boolean; // 20190806
function GetReducedBusinessLimit(RetNo: integer): Real; // 20190626
function GetAiipHelp: Boolean; // 20190311

function RoundDown(R: Real): LongInt;
function RoundUp(R: Real): LongInt; // 20180531
Function ValidatePhone(Phone: String): Boolean; // 20180118
Function GetLn780(RetNo: integer): Real;
Function GetRefundableTaxCreditsAllProvinces(RetNo: integer): Real;

Function IsClass141Claimed(RetNo: integer): Boolean;
Procedure CreateGroupInfoLink(DataDir, flName, BusName: String); // 20170716
Procedure ShowGroupTemplate(TemplateName: String);
Procedure CopyGroupTemplate(FromRetNo: integer);
Procedure ApplyFromTheGroupTemplate(RetNo: integer); // into S9, S23, etc
Procedure ApplyGroupInfoToMember(RetNo: integer; TemplateReturnName: String);
// i.e. copy S9 etc from the original templte file
Function GetRetNoByFileName(flName: String): integer;

// 20170614
Function ValidForT106Efile(RetNo: integer; FNo: integer): Boolean;
// 20170627 CON
Function NotPaidFor2018(RetNo: integer): Boolean; // 20170614
Function ValidEMail(s: String): Boolean; // 20170626

// 20160618
Function FiscalTimeRequired(RetNo: integer): Boolean; // 20170528 //20221114
Function FormatFiscalStartTime(RetNo: integer; Tm: String): String;
Function FormatFiscalEndTime(RetNo: integer; Tm: String): String;
Procedure GetLastYearS125Data(OldFNo, RetNo: integer);
Procedure GetLastYearS100Data(OldFNo, RetNo: integer);

function MkRsiAmountRec(RetNo: integer; Ln: string; FName: string; FNo: integer;
  RsiElm: integer): string; // 20160512

Procedure ConvertOldGifiData(RetNo: integer);
Procedure ConvertOldGifiISData(RetNo: integer; OldFNo, NewFNo: integer);
Procedure ConvertOldGifiBSData(RetNo: integer; OldFNo, NewFNo: integer);
procedure ImportGIFI(ARetNo, AFormNo: integer; AFormName: String);
// 20160722 Igor
procedure ImportGIFI_IS(ARetNo, AFormNo: integer); // 20160722 Igor
procedure ImportGIFI_BS(ARetNo, AFormNo: integer); // 20160722 Igor
procedure ClearGIFI(ARetNo, AFormNo: integer); // 20190225 Igor
procedure PutFIGIISLine(const ALineNo, AVal: String;
  ATargetRetNo, ATargetFormNo: integer; TargetStringList: TStringList);
// 20160722 Igor
procedure PutFIGIBSLine(const ALineNo, AVal: String;
  ATargetRetNo, ATargetFormNo: integer; TargetStringList: TStringList);
// 20160722 Igor
Procedure StoreGifiValues(RetNo: integer; FNo: integer;
  GifiValues: TStringList);
Function GetIsArrayNoFromGifiLine(Ln: String): String;
Function GetBSArrayNoFromGifiLine(Ln: String): String;
Function GetGifiLineDesciption(Ln: String): String;

// function S100LineToElm(RetNo: Integer; FNo:Integer; Ln: string): Integer;  backout
// function CountS125IncStatements(RetNo: Integer): Integer;
Function S100LineShouldBeNegative(LineNo, ValStr: String): Boolean;
Procedure PopBSGifiLines(FromLine: String; ToLine: String); // 20150816
Procedure PopISGifiLines(FromLine: String; ToLine: String); // 20150720
// 20140704
function RemoveInvalidEFCharacters(s: string): string;
// 20150606
procedure FixMostRecent;
// 20141025
function IsNumberInSet(Numb, FromNumb, ToNumb, Incr: integer): Boolean;
function Class43HasDetail(RetNo: integer; RowNo: integer): Boolean;

function LicenseLevel: eLicenseLevel;
function LicenseName: string;
Function IsEnterpriseVersion: Boolean; //20231211 Igor

function RemoveSpecialCharacters(s: string): string;
function OldPrintSet(flName: string): Boolean;
function StillOldPrintSets: Boolean;
procedure RevisePrintSets;
procedure ReviseAPrintSet(flName: string);
function Daysafter2012(RetNo: integer): integer;
function ShouldFileS5(RetNo: integer): Boolean;
function IsAmendedReturn(RetNo: integer): Boolean;
procedure createPasFromTXT(flName: string);
procedure createDfmFromTxt(flName: string);

function ConvertFNameToCombined(FName: string): string;
function ConvertElmNoToCombined(OldFName: string; Elm: integer;
  IncrElmList: TStringList): integer;

function DateToDDMMYYYY(Dt: string): string;
function IsOpeningBalanceSheetDone(RetNo: integer): Boolean;
// function IsOntarioIncorporated(RetNo: Integer): Boolean;
function GetMaxCharactersToFitBox(CharacterWidth: integer;
  BoxWidth: integer): integer;
function IsInactive(RetNo: integer): Boolean;
function IsAmortizationLine(LineNo: string): Boolean;
function ValidProjectsInT661(RetNo: integer): Boolean;
procedure GetFormsToPrint(RetNo: integer; Template: string;
  var FormsToPrint: TStringList; Prov: string);
function GetFormAbbrevDescr(FName: string): string;
function IncludeS510InFiling(RetNo: integer): Boolean;
function GetOntBasicTaxRate(RetNo: integer): string;
function MkDirforClientDocs(RetNo: integer): string;
// procedure AdjustFinePrintRegistrySettings(PDFFullfileName: string; ShowDlgValue: Integer; PdfActionValue: Integer; CollectJobsValue: Integer); //20160905 Igor (move to vtTrimStr)
procedure OpenAnyFile(PgmPath, PgmFile: string);
function GetAnyNumDays(RetNo: integer; BegDate: string; EndDate: string;
  ADate: string; BfrAftr: string): integer;
function ShouldFileS510(RetNo: integer): Boolean;
function DateWithinDates(Dt, Dt1, Dt2: string): Boolean;
// function FileS546(RetNo: Integer): Boolean;
function GifiNotesEntered(RetNo: integer): Boolean;

function IncludesFeb29(RetNo: integer): Boolean;
procedure ClearTheClipBoard;
procedure PasteFromClipBoard(RetNo, FNo, Elm, MaxLines, MaxLineLength: integer);
// procedure ConvertS60(RetNo: Integer; FName: string; FNo: Integer; Fld: Integer; Valu: string);  //20150829
procedure ImportT661Descriptions(RetNo: integer; FNo: integer; LineNo: integer);
function GetNewFromDate(ThisYearEnd: string): string;
function IncDay(const AValue: TDateTime; const ANumberOfDays: integer)
  : TDateTime;
function IsAuthorizedPreparer: Boolean; // 20190226  //20190311 CON
function GetMaxSKItc(RetNo: integer): Real;
function IsMJWithOntario(RetNo: integer): Boolean;
function IncludeGifiSchedules(RetNo: integer; RsiForm: string): Boolean;
function IncDayMine(Dt: TDateTime; NumDays: integer): TDateTime;
function GetS568NumProjects(RetNo: integer): integer;
function InFormswithSpecialAddress(FName: string): Boolean;
function GetSpecialAddressValu(RetNo: integer; FName: string; ElmNo: integer;
  Valu: string): string;
function ReformatPostal(s: string): string;
function ReformatPostalForBarCode(s: string): string;
function RoundCorrect(R: Real): Int64; //LongInt; //202605018 Alex
function GetMultipleRSIcount(RetNo: integer; RsiForm: string): integer;
function AttachInstToFNameForRsi(FName: string; Inst: integer): string;
function GetT661NumProjects(RetNo: integer): integer;
function UseGifi(RetNo: integer): Boolean;
function GetTotBegBalS8(RetNo: integer): Real;
function IsAmalgamatedOntario(RetNo: integer): Boolean;
procedure CopyS511FromS23(RetNo: integer);
procedure CopyS513FromS9(RetNo: integer);
procedure CopyS516FromS23(RetNo: integer);
procedure CopyS517FromS23(RetNo: integer);
procedure CopyS566FromS23(RetNo: integer);
procedure CopyS568FromS23(RetNo: integer);
function GetOntDomesticFactor(RetNo: integer): string;
function GetPreparerInfo(RedirectToSite: string): string;
function DownLoadFromWeb(url, remoteFlName, localDir,
  localFlName: string): Boolean;
procedure OpenMsWord;
function FindPosOfLastSpace(s: string): integer;
procedure BreakGIFINotes78chars(var ImportList: TStringList);
function ValidT2Date(Dt: string): Boolean;
function GetBeforeAfterDays(RetNo: integer; ADate: string; BfrAftr: string;
  BegDate: string; EndDate: string): integer;
function GetTxblIncBfrLosses(RetNo: integer): Real;
function GetTxblIncBfrNetCapLosses(RetNo: integer): Real;
function CalcOntCapTaxRate(RetNo: integer; YearEnd: string): Real;
function RoundN(x: Extended; d: integer): Extended;
procedure CopyOT2013ToOITCPart1(RetNo: integer);
procedure CopyS23ToOITCBusLimit(RetNo: integer);
procedure CopyOT2013ToOITCBusLimit(RetNo: integer);
function IsAlpha(s: string): Boolean;
// procedure GetS53ADD06ValuesFromDisk(RetNo: Integer);   //20160523
function GetValueFromDisk(FullFlName: string; FName: string;
  Elm: integer): string;
function GetTheValue(TempList: TStringList; FName: string;
  Elm: integer): string;
function IsDic(RetNo: integer): Boolean;
function GetUserCaisCodeDescr(Code: string): string;
function PaddRZero(s: string; MaxLength: integer): string;
function FormatT1273Decimals(s: string): string;
procedure RemoveEmptyFGS(flName: string);
function IsOversizedForm(FName: string): Boolean;
procedure OpenUsedForms(RetNo: integer);
// Function SignOffAWarning(RetNo:Integer;ErrMsg:String):Boolean;
function RsiS13HasData(RetNo: integer): Boolean;
procedure CopyS23FromS9(RetNo: integer);
procedure CopyS49FromS23(RetNo: integer);
procedure InitPredictiveFiles;
function PrintLabels(DataDir, FileNm: string): Boolean;
procedure PrintALabel(LabelPosX, LabelPosY: integer;
  Line1, Line2, Line3, Line4, Line5: string);
procedure FixAProperty;
function IncrString(s: string; ByValue: integer): string;

procedure ModifyAllForms;
function ModifyFormOrText(FileToConvertFrom: string;
  ConversionType: string): Boolean;

function LandscapeFormsInFEDReturn(RetNo: integer): Boolean;
function LandscapeFormsInALBReturn(RetNo: integer): Boolean;

function IsT1273CashMethod(RetNo: integer; FInst: string): Boolean;
function CountT1273(RetNo: integer): integer;
function CountT1163(RetNo: integer): integer;
procedure ImportGifiNotes(RetNo: integer);
function GetFNoOfFirstInstance(FName: string; FNo: integer): integer;
function IsValidTrustNo(s: string): Boolean;
function GetTrTopicFromLineRef(FormName: string; FieldId: integer): string;

procedure InsertKeyWToDataDict(FormName: string; AnEditBox: TvtEdit);
function RemoveHyphens(s: string): string;
function GetFldMemFormNo(RetNo: integer;
  RefFormName, RefFieldId: string): integer;
procedure InitRichEditStorage(RetNo: integer);
procedure GetLoginNames(TempList: TStringList);
procedure UpdateLoginNames(Nm: string);
procedure ReplaceRtfText(ARichEdit: TRichEdit; InSearch, InReplace: string);
procedure ConvertOldLetter(ARichEdit: TRichEdit);
function CleanUpKeyW(KeyW: string): string;
function IsConditionalRtfStatement(KeyW: string): Boolean;
procedure GetDelimiterPositionsInRtf(ARichEdit: TRichEdit; SearchText: string;
  var DelimList: TStringList);
function FirstTimeClient(RetNo: integer): Boolean;
procedure ReadTheValue(TempList: TStringList; FrmNm: string;
  Elm1, Elm2: integer; var Val1: string; var Val2: string);
procedure AddDisplayFormatToRtf(ARichEdit: TRichEdit; KeyWList: TStringList);
procedure ReplaceRtfDelimiters(ARichEdit: TRichEdit;
  FromDelim, ToDelim: string);
procedure InsertBackFunction(ARichEdit: TRichEdit;
  InSearch, InSecondSearch, InReplace: string);
function ConvertToProper(s: string): string;
function GetKeyWListFromRichEdit(ARichEdit: TRichEdit;
  KeyWList: TStringList): Boolean;
function GetFormHeight(FName: string): integer;
function GetFormNumberFields(FNo: integer): integer;
function GetMaxFormNumber: integer;
function IncludeFormInPrint(RetNo: integer; FNm: string): Boolean;
function NotOldGifiForm(AFormName: String): Boolean; // 20160720 Igor
function CreateDefaultDataDirectories: Boolean; // 20170811 Igor

function GetInterpetedRichEdit(RetNo: integer; LetterName: string;
  ARichEdit: TRichEdit): Boolean; // 20160819 Igor
function GetLetterFileName(RetNo: integer; FName: string): string;
function LinkToSelf(InitialFormName: string; TargetFormName: string): Boolean;
procedure GetFrmDataListFromFullDataList(FrmNm: string; DataList: TStringList;
  FrmDataList: TStringList);
function FormatRSIDollarAmount(FrmNm: string; s: string; How: integer): string;
function IsFieldInElmsInError(s: string; AList: TStringList): integer;
function GetFormAbrevNameWithNoInst(FormNo: integer): string;
function FieldHasAddingTape(RetNo: integer; FName: string;
  Elm: integer): Boolean;
function IsInvoiceLocked(RetNo: integer): Boolean;
function GetDfmFormsDir: string;
function IsFormAClientLetter(FName: string): Boolean;
function GetAnyPathMoreThan8Chars(Dir: string): string;
function CopyMoveReturn(CopyOrMove: string; FromDir: string; ToDir: string;
  flName: string): Boolean;
function StripInstNo(FormName: string): string;
procedure ResortFormsToPrint(FormsToPrint: TStringList);
function GetPrintTemplate: string;
function AllowedToFullPrint(RetNo: integer): Boolean;
function CreateNewDataDir: string;
// Function AllowedToFormPrint(RetNo:Integer;FormName:String):Boolean;
function AllowedToFormPrint(RetNo: integer): Boolean;
function IsOkToOpenReturn(DataDir: string; flName: string): Boolean;

function GetReturnPsw(DataDir: string; flName: string): string;
function CheckReturnPsw(DataDir: string; flName: string): integer;
procedure RemoveReturnPsw(RetNo: integer);
procedure StoreReturnPsw(RetNo: integer; RetPsw: string);

function ValidShortProvince(s: string): Boolean;
function IsFormTheDefaultSearch: Boolean;
procedure ConvertCfgToOptionsFile(CfgTbl: TDataSet);
procedure InitOptions;
procedure SetDefaultOptions; // 20160523 Igor //20160617 Igor
Function GetDefaultOptionsValue(const AOptionsName: String): String;
// 20160617 Igor
function GetDefaultOptions: TStringList; // 20160617 Igor
function GetOptionsCaption(AOptionsName: String): String; // 20160617 Igor
function HaveOptions(AOptionsName: String): Boolean; // 20170112 Igor
procedure LoadOptionsFileToMem;
function GetOptionValue(FieldNm: string; TempList: TStringList): string;
procedure SaveSingleOption(FieldNm, Value: string;
  AOptionsFileName: String = ''); // 20160617 Igor
procedure SaveOptionValue(FieldNm: string; Value: string;
  TempList: TStringList);
function BooleanToString(ABoolean: Boolean): string;
function StringToBoolean(AString: string): Boolean;
function GetFileList(FDirectory, Filter: TFileName): TStringList;
// function IncrementlastBackUpDir(LastBackUp: string): string;  //20160602 Igor
function GetDefaultScaling: integer;
// ---------------------- above for DFM version ----

function FormatPhoneForRSI(s: string): string;
procedure UpdateMostRecentFiles(RetNo: integer; Dir, flName, Sin: string);
function IsInMostRecentReturns(flName: string;
  MostRecentList: TStringList): integer;
procedure InitMostRecentFiles(HowMany: integer);
procedure ConvertMostRecentFiles; // 20201015 Igor
procedure SaveScreenSettings(Sc: Real; ScChar: Real; ScChange: Real;
  LeftPanelWidth: LongInt);
procedure GetScreenSettings(var Sc: Real; var ScChar: Real; var ScChange: Real;
  var LeftPanelWidth: LongInt);
function ValidPhoneNo(s: string): Boolean;
function FillSignatureDates: Boolean;
procedure UpdatePrintDate(RetNo: integer; DataDir: string; flName: string);
function IsFirstPageOfForm(FormName: string): Boolean;
function PositionInList(AString: string; SomeList: TStringList): integer;
function GetShowOpenedFormsIndicator: Boolean;
procedure DataChangedRtn(RetNo: integer; FormName: string);
// 20170904 Igor>>>
// function IsTrLoaded: Boolean;
// function GetTrHandle: HWND;
// procedure LinkToTR(SearchItem: string);
// procedure LoadTr(TrFolder: string);
// 20170904 Igor<<<
procedure LinkToCICA(Ln: string);
// function GetTrFolder: string;//20170904 Igor
// function YYYYMMDDToWinFormat(Dt: string): string;//20170728 Igor
function DtDiff(D1: string; D2: string): integer;
function TimeToCheckUpdates: Boolean;
procedure Checkupdates(WindowHandle: Word; AppTitle: string);
procedure SetUpdateFrequency(Freq: integer);
function GetUpdateFrequency: integer;
function GetLastUpdCheck: string;
procedure ConnectToWeb(url: string);
procedure StoreClipboardValues(RetNo: integer; FNo: integer;
  WList: TStringList);
function GetNextInstanceFName(RetNo: integer; FName: string): string;
function GetPrevInstanceFName(RetNo: integer; FName: string): string;
// function KillTask(ExeFileName: string): integer;
procedure AcrobatMinimize;
function GetAcrobatFdfDir: string;
function AcrobatReaderLoaded: Boolean;
function KillApp(const sCapt: PChar): Boolean;
procedure StartAcrobatReader(WinTitle, PgmPath, PgmName: string);
procedure DoPdfFile(RetNo: integer; FName: string; PdfFile: string);
procedure DoClipBoardChanged(RetNo: integer);
function GetFormNameOfPdfFile(PdfFile: string): string;
function GetPdfFileOfFName(FName: string): string;
procedure ProcessPdfFile(RetNo: integer; FName: string; FNo: integer;
  NumFlds: integer; PdfFile: string);
procedure CreateAcrobatFdf(RetNo: integer; FName: string; NumFlds: integer;
  PdfFile: string);
procedure ShowPdf(PgmPath, PgmFile: string);

function ValidCertificate(RetNo, FNo, Elm: integer): Boolean;
function IsBankCorp(RetNo: integer): Boolean;
// function IsLoanCorp(RetNo: Integer): Boolean;
function IsTrustOrLoanCorp(RetNo: integer): Boolean;
function MkCorEFileName(RetNo: integer): string;
function MkWebEFileName(RetNo: integer): string; // 20170626
function MkWebEFileResponseName(RetNo: integer): string; // 20170626
function GetEfileUrl: string;
procedure GetEOLParms(var OnlineNo: string; var Password: string;
  var url: string; var NetFileDir: string);
function GetEOLAgentNo: string;
procedure SaveEOLParms(OnlineNo, Password, url, NetFileDir: string);
function GetDefaultNetFileDir: string;
function AlbDiffResourceData(RetNo: integer): Boolean;
function IsForeignAuthorizedBank(RetNo: integer): Boolean;
function IsS12Designation(RetNo: integer): Boolean;
function CountSpacesInString(s: string): integer;
function ClaimingSurtaxCredit(RetNo: integer): Boolean;
procedure BuildSuperEntries(FullFlName: string);
function NumInRange(Num: integer; FromNum, ToNum, ByNum: integer): Boolean;
function PredictiveForm(Frm: string): Boolean;
function GetPredictive(FrmNm: string; FldId: integer;
  OldString: string): string;
function PredictCharityList(RetNo: integer; FrmNm: string; FldId: integer;
  OldString: string): string;
// function GetOntApprovalCode(FName: string): string;   //20220903
function GetPrvAlloc(RetNo: integer; Prv: string): string;
function GetPrvAllocForFtc(RetNo: integer; Prv: string): string;
function GetMaxNonRefNBRdCredit(RetNo: integer): Real;
function GetMaxRefNBRdCredit(RetNo: integer): Real;
function GetMaxSkRdCredit(RetNo: integer): Real;
function GetMaxMBRdCredit(RetNo: integer): Real;
function GetTxblIncomeFromS5(RetNo: integer; Prv: string): Real;
function IsElectricalGenerator(RetNo: integer): Boolean;
function GetJurisdiction(RetNo: integer): string;
function GetNonTaxableGainsLosses(RetNo: integer): Real;
function ProfileJulianDays(DtIn: string): string;
function FetchElmForEFile(RetNo: integer; FName: string; Elm: integer): string;
function IsFieldABN(FrmNm: string; ElmNo: integer): Boolean;
function IsElmInRange(ElmNo, FromElm, ToElm, ByIncr: integer): Boolean;
function IsEFiled(RetNo: integer): Boolean;
function GetWACNumber(RetNo: integer): string;
function GetEFileConfirmationNo(RetNo: integer): string;
function GetSuperCorpName(ElmRec: string): string;
function IsStringInList(s: string; AList: TStringList): integer;
procedure PutValuesInElmList(FrmNm: string; DataList: TStringList;
  var ElmList: TStringList);
procedure BuildExperience(FrmNm: string; FromElm, ToElm, ByElm: integer;
  flName: string; var ElmList: TStringList; DataList: TStringList);
procedure GetTheHtmlDoc(url: string; CaptureFileName: string);
function GetValueFromHtm(url: string; Parameter: string): string;
function GetPositionOfSubstring(ss, s: string): integer;
procedure GetMostRecentFiles(SomeList: TStringList; HowMany: integer);
function IsFirstYearAfterAmalgamation(RetNo: integer): Boolean;
function IsFirstYearAfterWindUp(RetNo: integer): Boolean;
function IsWindUpOfSubsidiary(RetNo: integer): Boolean;
function IsNameChange(RetNo: integer): Boolean;
function CanItBeEfiled(RetNo: integer): Boolean;
procedure AutoFormatDate(var Value: string);
procedure AutoFormatYYYYMMDate(var Value: string);
procedure FindTextInForm(FormNm: string; KeyW: string;
  var TempList: TStringList);
function GetModuleName: string;
function GetFileExtension(flName: string): string;
function RemoveFileExtension(flName: string): string;
function CanTaxJulianDaysToYYYYMMDD(DtIn: string): string;
function GetIncomeForAlbSBD(RetNo: integer): Real;
function FetchElmFromDataList(DataList: TStringList; FName: string;
  Elm: integer): string;
function GetHlpTopicFromLineRef(FormName: string; FieldId: integer): string;
function GetEmptyInstance(RetNo: integer; FormName: string): integer;
function GetFldTapeFormNo(RetNo: integer;
  RefFormName, RefFieldId: string): integer;
function GetTxblIncome(RetNo: integer): Real;
function GetTxblIncomeInAllProv(RetNo: integer): Real; // exclude outside canada
function GetTxblIncomeInProv(RetNo: integer; Prv: string): Real;
function JulianDaysToYYYYMMDD(DtIn: string): string;
function ConvertGpDate(DtIn: string): string;
// 20170901 Igor>>>
// function CountDBRecords: Integer;
// function ExceedsMaxReturnsAllowed: Boolean;
// 20170901 Igor<<<
function OpentaxbyteDB(UserId: string): Boolean;
function GetDCNNo(RetNo: integer): string;
function GetAlbEffectiveRate(RetNo: integer): Real;
function GetInclRateForCarryBack(BackToDt: string): string;
function GetAlbAllocationFactor(RetNo: integer): string;
function GetAlbAllocationFactorForS1(RetNo: integer): string;
function CalcAlbFactor(A, B, C, d: Real): Real;
function IsAlbSpecialAlloc(RetNo: integer): Boolean;
function GetAlbACTADed(RetNo: integer): Real;
function SubjectToCMT(RetNo: integer): Boolean;
function GapsInTable(RetNo: integer; Frm: string;
  StartElm, EndElm, IncrElm: integer): Boolean;
// Function CountAlbErrors(AuditList:TAuditList):Integer;
function IsCanadianProvince(AddressPrv: string): Boolean;
function FetchAlbInclusionRateString(RetNo: integer): string;
function GetTaxationYearEnd(RetNo: integer): string;
function GetTaxationYearStart(RetNo: integer): string;
function GetTheTime(Dt: TDateTime): string;
function CountMultipleInstances(RetNo: integer; NonInstFormName: string)
  : integer; { No Instance }
function IsFirstYearFiling(RetNo: integer): Boolean;
function FetchOntInclusionRateString(RetNo: integer): string;
function IsInvestmentCorp(RetNo: integer): Boolean;
function IsMutualFundCorp(RetNo: integer): Boolean;
function MTrim(s: string): string;
function IsShortYear(RetNo: integer): Boolean;
function GetCapitalStock(RetNo: integer): Real;
function GetRetainedEarnings(RetNo: integer): Real;
function GetContributedSurplus(RetNo: integer): Real;
function GetOtherSurpluses(RetNo: integer): Real;
function IsTaxExempt(RetNo: integer): Boolean;
function IsLifeInsuranceCorp(RetNo: integer): Boolean;
function IsInsuranceCorp(RetNo: integer): Boolean;
function IsNonResidentCorp(RetNo: integer): Boolean;
function IsNonResidentInvestmentCorp(RetNo: integer): Boolean;
function IsCooperativeCorp(RetNo: integer): Boolean;
function GetNetIncBfrPatronage(RetNo: integer): Real;
function GetLifeInsTxblCapital(RetNo: integer): Real;
function GetFullMonth(mm: string): string;
function WhichPeriod(DispDate: string): integer;
function GetTxblIncomeForOntSurtax(RetNo: integer): Real;
function FetchInclusionRateString(RetNo: integer): string;
function GetFastPrintIndicator: Boolean;
function GetGifiValFromMem(RetNo: integer; FNo: integer; Ln: string): string;
function BeyondMaxYearEnd(RetNo: integer): Boolean;
function FindWord(ThisWord, Ln: string): integer;
// function MkRSIAmountRec(RetNo: Integer; Ln: string; FName: string; FNo: Integer): string;
function MkEFileAmountRec(RetNo: integer; Ln: string; FName: string;
  FNo: integer): string;
function MkEFileNotesRec(RetNo: integer; FName: string; FNo: integer;
  ElmStr: string): string;
procedure GetExplGifiList(GifiId: string; ParentLine: string;
  var ExplodedList: TStringList);
function FetchGifiElm(RetNo: integer; FName: string; Ln: string): string;
function FetchGifiElmFNo(RetNo: integer; FNo: integer; Ln: string): string;
procedure StoreGifiElm(RetNo: integer; FNo: integer; Ln: string; Valu: string);
function GifiLineToElm(RetNo: integer; FNo: integer; Ln: string): integer;
function TotGifiMultiple(RetNo: integer; NonInstFormName: string;
  GifiLine: string): Real; { No Instance }
function CurrentYearIsLeap(RetNo: integer): Boolean;
function CheckGainsBreak(RetNo: integer; FName: string;
  TotalElm, P1Elm, P2Elm: integer; P3Elm: integer): Boolean;
function GetBusLimitOfAssoc(RetNo: integer): Real;

function IsLeapYear(Yr: integer): Boolean;
function isLeapDayWithinReturnDateRange(RetNo: integer): Boolean;

function GetOntRate(RetNo: integer): Real;
procedure GifiISToTreeview;
procedure CopySalariesToOS5(RetNo: integer; OntFName: string);
procedure CopyRevenuesToOS5(RetNo: integer; OntFName: string);
function ConvertToPixelsX(x: Real; PixPerInX: integer): integer;
function ConvertToPixelsY(Y: Real; PixPerInY: integer): integer;
function DoubleSpaced(s: string): string;
function IsCreditUnion(RetNo: integer): Boolean;
function IsFedFnclInstitution(RetNo: integer): Boolean;
function IsOntFnclInstitution(RetNo: integer): Boolean;
procedure Filter2000Release1AndStore(RetNo: integer; FormNm: string;
  FNo: integer; Elm: integer; Valu: string);
function StraddleLowRate(RetNo: integer; Dt: string; Rate1, Rate2: Real): Real;
function StraddleHighRate(RetNo: integer; Dt: string; Rate1, Rate2: Real): Real;
function IsKeyWAnAmount(KeyW: string): Boolean;
function GetFileDate(TheFileName: string): string;
function GetPositionInList(s: string; AlistBox: TFileListBox): integer;
function GetClientLettersDir: string;
function MkClientLetterName(RetNo: integer): string;
function TimeToHHMMSS(Dt: TDateTime): string;
function GetCorpBusNo(RetNo: integer): string;
function ReformatBN(BN: string): string;

function GetAlbTxblIncome(RetNo: integer): Real;

function AlbAnyDiffSchedule(RetNo: integer): Boolean;
function AlbDiffInc(RetNo: integer): Boolean;
function AlbDiffS6(RetNo: integer): Boolean;
function AlbDiffCCA(RetNo: integer): Boolean;
function AlbDiffCEC(RetNo: integer): Boolean;
function AlbDiffResDed(RetNo: integer): Boolean;
function AlbDiffSRD(RetNo: integer): Boolean;
function AlbDiffReserves(RetNo: integer): Boolean;
function AlbDiffCapDisp(RetNo: integer): Boolean;
function AlbDiffDon(RetNo: integer): Boolean;
function AlbDiffLoss(RetNo: integer): Boolean;
function AlbDiffAdjubi(RetNo: integer): Boolean;

function RSIType(RetNo: integer; FName: string; FedOrProv: string): string;
function DoubleWordSeparators(s: string): string;
function RemoveNonNumericChars(s: string): string;
procedure ParseWords(s: string; Delim: string; var WList: TStringList);
procedure ParseAddress(s: string; Delim: string; var WList: TStringList);
function GetAlbAlloc(RetNo: integer): Real;
function GetOntAlloc(RetNo: integer): Real;
function GetMaxItcClaim(RetNo: integer; Avlbl: Real; PropType: string): Real;
function GetAlbAccNo(RetNo: integer): string;
function RoundToThousands(rn: Real): Real;
function GetGrossRevenue(RetNo: integer): Real;
function PrintAListing(FileNm, Hdr1, Hdr2, Hdr3: string): Boolean;
function GetFormNameFromRsi(RsiNm: string; FedOrProv: string): string;
function GetAlbertaFormNameFromRsi(RsiNm: string): string;
function CountIncStatements(RetNo: integer): integer;
function ValidBusNumber(RetNo: integer; BN: string): Boolean;
function ValidPartnershipNumber(RetNo: integer; BN: string): Boolean;
// 20210516
function RemoveChar(s: string; Ch: string): string;
function HowMuchPrvTax(Prv: string; TxblAmount: Real; SBd: Real): Real;
function GetPrvTaxBfrCredits(RetNo: integer; ProvJurisd: string;
  SomeProv: string): Real;
function GetTotNetPrvTaxes(RetNo: integer): Real;
function TotISNetInc(RetNo: integer): Real;
function TotAmortOfTangible(RetNo: integer): Real;
function TotAmortOfNatRes(RetNo: integer): Real;
function TotAmortOfInTangible(RetNo: integer): Real;
function TotLossInEquity(RetNo: integer): Real;
function TotGainLossOnDisposal(RetNo: integer): Real;

function IsCorpResident(RetNo: integer): Boolean;
function IsCorpRelated(RetNo: integer): Boolean;
function ReplaceChar(s, Ch1, Ch2: string): string;
function IsLandscape(FName: string): Boolean;
function GetBegYearEnd(RetNo: integer): string;
function GetTaxationYearEndYYYY(RetNo: integer): integer;
function GetTaxationYearStartYYYY(RetNo: integer): integer;
function GetNetInc(RetNo: integer): Real;
function YYYYMMDDToMMDDYYYY(Dt: string): string;
function MMDDYYYYToYYYYMMDD(Dt: string): string;
function GetFedTxblBfrLosses(RetNo, FNo: integer): Real;
procedure RecalcAllForms(RetNo: integer);
function GetFedCurrYrNonCapLoss(RetNo: integer): Real;
function GetFedCurrYrFarmLoss(RetNo: integer): Real;
function GetFedCurrYrRestrFarmLoss(RetNo: integer): Real;
function GetFedCurrYrLPPLoss(RetNo: integer): Real;

procedure CalcAllForms(RetNo: integer);
procedure OnestepCom;
procedure WriteFileForEFCom;
function GetAdminPswrd(UserName: string): string;
function DateWithinTaxYear(Dt: string; RetNo: integer): Boolean;
procedure InitPRVRates(RetNo: integer);
function DDMMYYYYToEFDate(RetNo: integer; Dt: string): string;
function YYYYMMDDToEFDate(RetNo: integer; Dt: string): string;
function YYMMDDToEFDate(RetNo: integer; Dt: string): string;
function DDMMYYToEFDate(RetNo: integer; Dt: string): string;
function GetLowIncome(RetNo: integer; PrvNdx: integer): Real;
function GetHighIncome(RetNo: integer; PrvNdx: integer): Real;
function GetLowRate(RetNo: integer; PrvNdx: integer): Real;
function GetHighRate(RetNo: integer; PrvNdx: integer): Real;
function DateToEfileDate(Dt: TDateTime): string;
function GetEfT2IncorpDate(RetNo: integer): string;
function GetEfT2AmalgDate(RetNo: integer): string;
function GetEfT2ControlDate(RetNo: integer): string;
function EFT2013Date(RetNo: integer; Dt: string): string;

function TimeToHHMM(Dt: TDateTime): string;
function GetEfT2FromDate(RetNo: integer): string;
function GetEfT2ToDate(RetNo: integer): string;
function GetEfT2CorpType(RetNo: integer): string;

// function MMDDYYYYToWinFormat(Dt: string): string;//20170728 Igor
function GetWinIniString(IniFileName: string; Sect: string;
  Ident: string): string;
procedure WriteWinIniString(IniFileName: string; Sect: string; Ident: string;
  Val: string);
function Pars(Msg: string; Elm: integer; Delimiter: string): string;
function GetHowToFormat(FrmName: string; Elm: integer): integer;
function GetOITC(RetNo: integer): Real;
function ABSIfNegative(x: Real): Real;
procedure GetCurYearLoss(RetNo: integer; Prov: string; var NonCapLoss: Real;
  var FarmLoss: Real; var RestrFarmLoss: Real);

function YrEndToYYYYMMDD(YrEnd: string): string;
function IsAssociated(RetNo: integer): Boolean;
function DDMMYYYYToYYYYMMDD(Dt: string): string;
function YYYYMMDDToDDMMYYYY(Dt: string): string;
function GetPrevYearEnd(ThisYearEnd: string; No: integer): string;
function AdvanceYearEnd(ThisYearEnd: string): string;
function GetLowTax(PrvNdx: integer; TxblIncome, PrvAlloc,
  SmBusLimit: Real): Real;
function GetLowBCTax(PrvNdx: integer;
  TxblIncome, PrvAlloc, SmBusLimit: Real): Real;
function GetHighTax(PrvNdx: integer; TxblIncome, PrvAlloc,
  SmBusLimit: Real): Real;
function GetHighBCTax(PrvNdx: integer;
  TxblIncome, PrvAlloc, SmBusLimit: Real): Real;
function GetPrvNdx(SPrv: string): integer;
function GetFedPolitCredit(RetNo: integer; PolContr: Real): Real;
function GetPolitCredit(Contr: Real): Real;
function GetNUPolitCredit(Contr: Real): Real;
function GetSKPolitCredit(RetNo: integer; PolContr: Real): Real;
function GetNWTPolitCredit(Contr: Real): Real;
function GetFormType(FName: string): string;
function GetOntAllocString(RetNo: integer): string;
function GetFormFee(FName: string; Qty: integer): Real;
function GetTotalFee(RetNo: integer): Real;
procedure GetListInvoiceForms(RetNo: integer; var Frms: TStringList;
  var HowMany: TStringList);
function CountPagesGenerated(RetNo: integer): integer;
procedure FillHeader(RetNo, FormNo, NameElm, AccountElm, YearEndElm: integer);
function MyStrToFloat(AString: string): Real;
procedure SetNumDays(RetNo: integer);
function GetMaxBizLimit(RetNo: integer; YrEnd: integer): Real;
function GetMBMaxBizLimit(RetNo: integer; YrEnd: integer): Real;
function GetNBMaxBizLimit(RetNo: integer; YrEnd: integer): Real;
function GetIncForSmBusDed(RetNo: integer): Real; { Min of 223, etc }
procedure SetCorpType(RetNo: integer);
function GetCorpName(RetNo: integer): string;
function GetAccountNumber(RetNo: integer): string;
function GetNineDigitAccountNumber(RetNo: integer): string;
function GetNumDays(RetNo: integer; ADate: string; BfrAftr: string): integer;
function GetNumDays2(RetNo: integer; BegDate: string; EndDate: string;
  ADate: string; BfrAftr: string): integer;

procedure AllowLinesForLogo(var LetterLines: TStringList);
procedure ExpandTabs(var AList: TStringList);
procedure ResolveConditions(var AList: TStringList);
function InvalidAmountInLetter(s: string): Boolean;
function IsFormMultiPage(FName: string): Boolean;
function MultiPage1(Frm: string; Inst: string; MxPg: integer): Boolean;
function MultiPage23(Frm: string; Inst: string; MxPg: integer): Boolean;
procedure CountMulties(RetNo: integer; var Frms: TStringList;
  var HowMany: TStringList);

function CountKeystrokePoints(RetNo: integer): integer;
function InitFormsTable: Boolean;
function ClcR(FieldId: integer; PgmValue: Real; FormOvrSw: Boolean;
  RetNo: integer; FormNo: integer): Real;

function EditDate(s: string; MnYear, MxYear: integer): Boolean;
function EditYYYYMMDate(s: string; MnYear, MxYear: integer): Boolean;

function CalcAge(BirthDate: string): integer;

(* 20190609
  procedure CalcCCA(Cls: string; OriginalCost:Real; UccStart: real;
  Additions: real; Adjustments: real; Proceeds: real;
  var UCC: real;
  var HalfRuleAmount: real;
  var UCCReduced: real;
  OverrideIndic: string; HalfYearIndic: string; TermLossIndic: string;
  Var Rate: string;   //var 20190607
  var Recapture: Real; var TerminalLoss: Real;
  var CCA: real; var UccEnd: real;
  DaysinTaxYear: integer;
  AssetInfo:String;
  EligibleForAiip:Boolean;
  AiipFactor:String;
  Var AdditionsAiip:Real;
  Var AssistanceReceived:Real;
  var RepaidAmount:Real;
  var ProceedsAiip:Real;
  var NetCapCostAdditionsAiip:Real;
  var UccAdjustmentAiip:Real;
  var UccAdjustmentNONAiip:Real);
*)

procedure CalcPreAiipCCA(cls: string; UccStart: Real; Additions: Real;
  Adjustments: Real; Proceeds: Real; var UCC: Real; var HalfRuleAmount: Real;
  var UCCReduced: Real; OverrideIndic: string; HalfYearIndic: string;
  TermLossIndic: string; Rate: string; var Recapture: Real;
  var TerminalLoss: Real; var CCA: Real; var UccEnd: Real;
  DaysinTaxYear: integer);

function GetCCARate(cls: string): string;
procedure InitCCARates;

function IsShowFlagIndicator(FName: string): Boolean;
function IsShowHdrIndicator(FName: string): Boolean;
procedure RemoveLastEmptyLines(var TempList: TStringList);
function ValidateTextLine(Txt: string; var Cursor_position: integer;
  var KeyWLength: integer): Boolean;
procedure RemoveEmptyLines(var TempList: TStringList);
procedure LoadLetter(var TempList: TStringList; LetterName: string);
procedure InterpretTextLine(RetNo: integer; var Txt: string);
procedure ReplaceKeyWord(var Txt: string; Cursor_position: integer;
  KeyWLength: integer; ReplaceString: string);
procedure ConditionEvaluator(CStr: string; var CCheck: Boolean;
  var error: Boolean);

procedure ReplaceText(LetterBody: TMemo; Cursor_position: integer;
  KeyWLength: Byte; ReplaceText: string);
function GetDataDictElmNo(KeyW: string): integer;
function GetDataDictFormName(KeyW: string): string;
function InDataDict(KeyW: string): Boolean;
function InsertPenniesDot(s: string): string;
function GetWhiteBoxesIndicator(FName: string): Boolean;
function TotMultiple(RetNo: integer; NonInstFormName: string;
  Elm: integer): Real;
function TotMultipleExludingDeletedSlips(RetNo: integer;
  NonInstFormName: string; Elm: integer; dElm: integer;
  deleteString: string): Real;

function SpouseDisabled(RetNo: integer): Boolean;
procedure UpdateAllDataIndicators(RetNo: integer);
procedure UpdateAllPagesDataIndicator(RetNo: integer; FName: string);
procedure InfoOn; { just repaint mdi status panel }
procedure InfoOff;
function GetNumbFields(FName: string): integer;
function WhichCreditForm(RetNo: integer; ShortPrv: string): string;
function ReformatSin(s: string): string;
function RemovePenniesDot(FormName, s: string): string;
function MakeEFFileName(LicenseLevel: string): string;

function EditLongPrv(Value: string): Boolean;
function FormatAmount(FrmNm: string; s: string; How: integer): string;
procedure SetDateFormat; { to DMY }
{ File i/o }
function FileNameValid(flName: string): Boolean;
// function GetUserProfile(UserName: string): boolean; //20170112 Igor (Move to TUserProfile)
function CreateDataDirectory(AppDir: string; DataDir: string): integer;
procedure UpdateDbStructure; // 20201015 Igor
function InitDataBase(AppDir: string; DataDir: string; out Err: String)
  : Boolean; // 20170811 Igor
// Procedure ShowOpenReturnFailure(FailCode: integer;DataDir: String; FlName: string);
procedure LoadDataDict;

procedure ShowHelp(HelpFile: string; Helptopic: string;
  AIsWeb: Boolean = False); // 20160801 Igor

procedure SwapStrings(S1: string; S2: string);
function ExtractDecimalPart(s: string): string;
function ExtractIntegerPart(s: string): string;
function PaddL(s: string; MaxLength: integer): string;
function InsertCommas(s: string): string;
function VL(s: string): Real;
function MyStrToInt(s: string): integer;
Function ValidNaics(Code: String): Boolean; // 20160220 Igor
Function IsSelfEmployed(RetNo: integer): Boolean; // 20160222 Igor
Function GetSpouseSIN(RetNo: integer): String; // 20160222 Igor
Function GetSinNo(RetNo: integer): String; // 20160222 Igor
Function GetBN(RetNo: integer): String; // 20171205 Igor
Function GetStreetAddress(RetNo: integer): String; // 20160222 Igor

Function IsValidLastYearPgmFolder(AShowMessage: Boolean;
  out AErrorMessage: String): Boolean; // 20160424 Igor //20160516 Igor
Function isValidLastYearDataFolder(AShowMessage: Boolean;
  out AErrorMessage: String): Boolean; // 20160424 Igor //20160516 Igor
procedure InitLastYearFormsTable; // 20160424 Igor
Function GetRenamedFName(FName: String): String; // 20160424 Igor
function GetLastYearFormNo(FormName: String): integer; // 20160424 Igor
function GetLastYearFormName(FormNo: integer): String; // 20160704 Igor
Function ValidForT1135Efile(RetNo: integer; FNo: integer): Boolean;
// 20160523 Igor
Function CreateEfileResponseHtm(RetNo: integer; AckRec: TAckRec;
  // 20160523 Igor
  HtmFile: String): String;
Function GetBirthDate(RetNo: integer): String; // 20160523 Igor
Function GetWebServiceErrorDescr(ErrorCode: String): AnsiString;
Function GetEfErrorDescr(ErrorCode: String): AnsiString;
function ImportOneReturn(ADS: TDataSet; ASrcDir, ADstDir: String;
  out AErr: String; AOverride: Boolean): Boolean; // 20160617 Igor

function GetLastYearFile(ARetNo: integer): String; // 20160701 Igor
procedure SetLastYearFile(const ARetNo: integer; AValue: String);
// 20160701 Igor

Function ShowUnconvertedLastYear(RNo: integer): Boolean; // 20160704 Igor
procedure QuickFormFind(RetNo: integer; ThisForm: String); // 20160711 Igor
function AutocompleteFormName(AFormName: String): String; // 20160711 Igor
Function MkTddFileName(RNo: integer): String; // 20171124 Igor
Function MkTddCorFileName(RNo: integer): String; // 20180518 Igor
Function MkTddFileNameAutofill(RNo: integer): String; // 20180530 Igor
Function GetRetNoFromBN(ABN: String): integer; // 20171205 Igor
Function IsDataGroupASlip(DataGroup: String): Boolean; // 20171124 Igor
function GetFormNo(FormName: String; RetNo: integer = 0): integer;
// 20171124 Igor
function GenerateReturnFileName(ARetNo: integer; AFileNameFormat: string)
  : string; // 20201013 Igor

//20230510 Igor >>>
type TGroupItemAccountType = (atIndividual, atCorporation, atTrust, atPartnership);
type T1134GroupItem = record
  AccountNumber: string;
  Name: string;
  AccountType: TGroupItemAccountType;
end;

procedure PopulateT1134ForeignAffiliates(ARetNo: Integer; AList: TStringList);
//20230619 CON from IGOR
function GetT1134ForeignAffiliatesIdentificationNumber(ARetNo: Integer; AName: string): string;
function GetT1134ForeignAffiliatesCountryCode(ARetNo: Integer; AName: string): string; //20230601 Igor
function GetT1134GroupList(ARetNo: Integer): TArray<T1134GroupItem>;


procedure PopulateT1134GroupList(ARetNo: Integer; AList: TStringList; AShowName: boolean = true); //20230619 Igor
procedure PopulateT1134SGroupList(ARetNo, AFormNo: Integer; AList: TStringList; AOnlyArrayNo: integer = 0);

{
function GetT1134ForeignAffiliatesIdentificationNumber(ARetNo: Integer; AName: string): string;
function GetT1134ForeignAffiliatesCountryCode(ARetNo: Integer; AName: string): string; //20230601 Igor
function GetT1134GroupList(ARetNo: Integer): TArray<T1134GroupItem>;
}


{
procedure PopulateT1134SGroupList(ARetNo, AFormNo: Integer; AList: TStringList; AOnlyArrayNo: integer = 0);
procedure PopulateT1134GroupList(ARetNo: Integer; AList: TStringList);
procedure PopulateT1134SGroupList(ARetNo, AFormNo: Integer; AList: TStringList; AOnlyArrayNo: integer = 0);
}

//20230510 Igor <<<


implementation

uses vtMain, vtDialogs, vtCommon, HtmlHelp,
  // T2_2020ReturnPassword,
  T2_2027, T2_2027Main, T2_2027Calc, T2_2027Common, T2_2027Common2,
  T2_2027Features,
  T2_2027ChildWinNew, vtTrimStr, vtShared, vtDataBase, uADCompClient,
  // 20150920 Igor
  fConvertToMultiApp, // 20160530 Igor
  vtFileStorage; // 20170502 igor

const // 20160617 Igor
  c_DefDataDir = '{DataDir}'; // 20171204 Igor
  // 20170112 Igor >>>
  OptionsArray: Array [0 .. 94, 0 .. 3] of string =
  // Options Name         Default Value                  Caption    Fill Default
    (('Dir_Cur', c_DefDataDir + '\Data', 'Current Directory', 'X'),
    // 0//20171204 Igor
    ('Dir_ClientDocs', c_DefDataDir + '\ClientDocs',
    'Client Documents Directory', 'X'), // 20171204 Igor
    ('BackUpFrequency', '5', 'Remind me to backup data every', 'X'),
    ('BackUpDir', c_DefDataDir + '\BackUp', 'Default Backup directory', 'X'),
    // 20171204 Igor
    ('LastBackUpDir', '', 'Most recent back up folder', ''),
    ('Dir_Deflt', c_DefDataDir + '\Data', 'Default Directory', 'X'),
    ('Dir_LastYr', '', 'Directory that contains last year''s tax return', 'X'),
    ('Dir_PgmLastYr', '', 'PROGRAM dir last year (optional)', 'X'),
    ('Dir_DBFData', '',
    'Data directory of your T2 returns (Prior to VT).  Typically enter  C:\T2-2017\data. To be used as the source to import data into the VT Multi-App version',
    'X'), ('Prp_Name', '', 'Preparer Identification: Company Name', ''),
    ('Prp_ContactFn', '', 'Preparer Identification: First Name', ''), // 10
    ('Prp_ContactLn', '', 'Preparer Identification: Last Name', ''),
    ('Prp_ContactPos', '', 'Preparer Identification: Contact: Position', ''),
    ('Prp_RepId', '', 'Preparer Identification: RepId (for RC59)', ''),
    ('Prp_EMail', '', 'Preparer Identification: Email Address', ''),
    ('Prp_OrgType', '', 'Preparer Identification: Organization', ''),
    ('Prp_BusNo', '', 'Preparer Identification: Business No', ''),
    ('Reviewer_Name', '', 'Reviewer Identification: Name', ''),
    ('Reviewer_EMail', '', 'Reviewer Identification: Email Address', ''),
    ('Reviewer_Area', '', 'Reviewer Identification: Tel. Area', ''),
    ('Reviewer_Tel', '', 'Reviewer Identification: Tel. Number', ''), // 20
    ('Prp_Street', '', 'Preparer Identification: Street', ''),
    ('Prp_City', '', 'Preparer Identification: City', ''),
    ('Prp_Prov', '', 'Preparer Identification: Province', ''),
    ('Prp_Postal', '', 'Preparer Identification: Postal', ''),
    ('Prp_Countr', '', 'Preparer Identification: Country', ''),
    ('Prp_Area', '', 'Preparer Identification: Tel. Area code', ''),
    ('Prp_Tel', '', 'Preparer Identification: Tel No.', ''),
    ('Prp_FxArea', '', 'Preparer Identification: Fax Area code', ''),
    ('Prp_Fax', '', 'Preparer Identification: Fax No.', ''),
    ('Prp_DiscNo', '', 'Prp_DiscNo', ''), { 30 } { TODO : check }
    ('Prp_DiscNm', '', 'Prp_DiscNm', ''), { TODO : check }
    ('Prp_GSTNo', '', 'GST No', ''), ('Prp_Bill', '2', 'Default Billing Option',
    'X'), ('Prp_VSFee', '200', 'Flat Fees ($): Very small', 'X'),
    ('Prp_SFee', '400', 'Flat Fees ($): Small', 'X'),
    ('Prp_AFee', '600', 'Flat Fees ($): Average', 'X'),
    ('Prp_CFee', '1000', 'Flat Fees ($): Complex', 'X'),
    ('Prp_VCFee', '2000', 'Flat Fees ($): Very Complex', ''),
    ('Prp_Hour', '60', 'Charge per hour ($)', 'X'),
    ('Prp_Elect', 'X', 'Prp_Elect', 'X'), { 40 } { TODO : check }
    ('Prp_EfRepr', 'X', 'Prp_EfRepr', 'X'), { TODO : check }
    ('Prp_Dates', '',
    'Signature date: If checked, the program will automatically fill Signature dates with today''s date',
    ''), ('Nfl_Prov', 'ON', 'Default values for tax returns: Default Province',
    'X'), ('Nfl_City', 'TORONTO',
    'Default values for tax returns: Default City', 'X'),
    ('Nfl_Disced', '1', 'Nfl_Disced', 'X'), { TODO : check }
    ('Capitalization', 'UpperCase', 'Name/address Capitalization: Convert to',
    'X'), ('Nfl_Efile', 'X', 'Check if most returns are EFiled', 'X'),
    ('Ef_ThirdParty', 'X', 'Efile as third party prepared/transmitter', 'X'),
    ('Ef_Method', 'EOL', 'Ef_Method', 'X'), { TODO : check }
    ('Prn_NameH', 'X', 'Print headers on tax forms: Client Name on Headings',
    'X'), // 50
    ('Prn_SinH', 'X', 'Print headers on tax forms: B/N on Headings', 'X'),
    ('Prn_DateH', 'X', 'Print headers on tax forms: Date on Headings', 'X'),
    ('Prn_Disclm', '',
    'Disclaimer above signature on Page 8 (Leave it blank, if not required)',
    ''), ('Opr_Close', 'X', 'Navigation and warnings Esc key', 'X'),
    ('Opr_GstHst', '', 'GST/HST rate', ''), ('ShowConsultantOnInv', '',
    'ShowConsultantOnInv', 'X'), { TODO : check }
    ('UseFastPrint', '', 'Use Fast Print method', 'X'),
    ('UseProperName', '',
    'Client Letters: Show proper format (Capitalize only first letter)  in Name and Address',
    'X'), ('ShowUsedForms', '',
    'Show forms used last time you saved the return', ''),
    ('OpenAtLastForm', '', 'If ticked, open at last form used', ''), // 60
    ('DecimalAssume', '',
    'Decimal Assume (if you enter 12345 it will register as 123.45) DO NOT TICK it unless USED TO IT',
    ''), ('UseFormSearch', 'X', 'UseFormSearch', 'X'), { TODO : check }
    ('NoTypeAhead', '',
    'DO NOT Use the Predictive Typing feature (Super Entry)', 'X'),
    ('ShowVisitedForms', '', 'ShowVisitedForms', ''), { TODO : check }
    ('ShowInvoiceWarning', 'X',
    'Invoice: Show warning  if invoice not prepared', 'X'),
    ('ActiveBoxColor', '8421631', 'Active Box Color', 'X'),
    ('FirstReturnColor', '16777155', 'FirstReturnColor', 'X'), { TODO : check }
    ('InvFoot1', '',
    'Invoice footer (Free format text to appear at bottom of Invoice) 1', ''),
    ('InvFoot2', '',
    'Invoice footer (Free format text to appear at bottom of Invoice) 2', ''),
    ('InvFoot3', '',
    'Invoice footer (Free format text to appear at bottom of Invoice) 3', ''),
    // 70
    ('InvFoot4', '',
    'Invoice footer (Free format text to appear at bottom of Invoice) 4', ''),
    ('InvFoot5', '',
    'Invoice footer (Free format text to appear at bottom of Invoice) 5', ''),
    ('DataInBold', '', 'Show data in Bold in all forms', 'X'),
    ('NoBarCode', '', 'DO NOT Print BarCode', ''),
    ('RolloverProgram', 'VisualTax',
    'Program that created last year''s return...', 'X'),
    ('EscOption', 'CloseForm', 'ESC key - When pressed on a form it will', 'X'),
    ('Opr-GstHst', '6', 'GST/HST rate', 'X'),
    { TODO -oUfomaster -cLookTolya : ÐŸÐ¾Ð²Ñ‚Ð¾Ñ€ }
    ('FormZoom', '100', 'Form Size (zoom) in effect', 'X'),
    ('OtherSlipsButtons', 'X', 'OtherSlipsButtons', 'X'), { TODO : check }
    ('Prn_LMargin', '0.75',
    'Client Letters Print Margins: Left margin in inches', 'X'),
    // 80 //20160721 Igor
    ('Prn_RMargin', '0.5',
    'Client Letters Print Margins: Right margin in inches', 'X'),
    // 20160721 Igor
    ('Prn_FontIncr', '1', 'Printing Font Size Increment: Increment by (0 or 1)',
    'X'), ('HideMostRecent', '', 'Hide most recent returns', 'X'),
    ('T1013AuthorLevel', '2', 'T1013AuthorLevel', 'X'), { TODO : check }
    ('CVSetting', '2', 'CVSetting', 'X'), { TODO : check }
    ('ShowFinWarning', '', 'ShowFinWarning', 'X'), { TODO : check }
    ('UseCondominiumLine', '', 'UseCondominiumLine', 'X'), { TODO : check }
    ('RolloverT4T5', 'X', 'RolloverT4T5', 'X'), { TODO : check }
    ('ShowInvoiceEfCharge', 'X', 'ShowInvoiceEfCharge', 'X'), { TODO : check }
    ('ShowSaluteWarning', 'X', 'ShowSaluteWarning', 'X'),
    { 90 } { TODO : check }
    ('UpdateFrequency', '7',
    'Internet Updates: Check automaticaly every X deys', 'X'),
    ('AutoSeniorDiscount', '', 'AutoSeniorDiscount', 'X'), { TODO : check }
    ('DiscountForSeniors', '0', 'DiscountForSeniors', 'X'),
    { 93 }  { TODO : check }
    ('FileNameFormat', '1', 'File Rename Format', 'X') { 94 } // 20201013 Igor

    );
  // 20170112 Igor <<<


procedure PopulateT1134ForeignAffiliates(ARetNo: Integer; AList: TStringList); //20230510 Igor //20230601 Igor //20230712 Igor
var FormNo, I: integer;
    TempList: TStringList;

    procedure AddToList(AValue: string); //20230619 Igor
    begin
      if not AValue.IsEmpty and (TempList.IndexOf(AValue) = -1) then
        TempList.Add(AValue);
    end;

    procedure PopulateForeignAffiliates(ArrayNo, ElmId: integer);
    var BoxesPerRow, ElmName, RowCount, i: integer;
    begin
      BoxesPerRow := RetList[ARetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
      ElmName := ArrayNo * 10000 + ElmId;
      RowCount := DynamicRowCount(ARetNo, FormNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        AddToList(FetchElmFNo(ARetNo, FormNo, ElmName));
        ElmName := ElmName + BoxesPerRow;
      end;
    end;
begin
  AList.Text := FetchElm(ARetNo, 'STATUS', T1134_FA_LIST);
  TempList := TStringList.Create;
  try
    For i:=1 to 10 do
    begin
     FormNo:=GetFormNo('T1134S#'+IntToStr(i));
     If FormNo>0 then
       AddToList(FetchElmFNo(ARetNo, FormNo, 35)); //20230619 Igor
    end;
    //20230619 Igor >>>
    FormNo := GetFormNo('T1134');
    PopulateForeignAffiliates(7, 4);
    //20230619 Igor <<<

    // remove non existing
    for I := AList.Count - 1 downto 0 do
      if TempList.IndexOf(AList.Strings[I]) = -1 then
        AList.Delete(I);

    // add new
    for I := 0 to TempList.Count - 1 do
      if AList.IndexOf(TempList.Strings[I]) = -1 then
        AList.Add(TempList.Strings[I]);
  finally
    TempList.Free;
  end;
  StoreElm(ARetNo, 'STATUS', T1134_FA_LIST, AList.Text);
end;


  (*
//20230619 CON from IGOr
procedure PopulateT1134ForeignAffiliates(ARetNo: Integer; AList: TStringList); //20230510 Igor //20230601 Igor
var FormNo, I: integer;

    procedure AddToList(AValue: string); //20230619 Igor
    begin
      if not AValue.IsEmpty and (AList.IndexOf(AValue) = -1) then
        AList.Add(AValue);
    end;

    procedure PopulateForeignAffiliates(ArrayNo, ElmId: integer);
    var BoxesPerRow, ElmName, RowCount, i: integer;
    begin
      BoxesPerRow := RetList[ARetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
      ElmName := ArrayNo * 10000 + ElmId;
      RowCount := DynamicRowCount(ARetNo, FormNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        AddToList(FetchElmFNo(ARetNo, FormNo, ElmName));
        ElmName := ElmName + BoxesPerRow;
      end;
    end;
begin
  For i:=1 to 10 do
  begin
   FormNo:=GetFormNo('T1134S#'+IntToStr(i));
   If FormNo>0 then
     AddToList(FetchElmFNo(ARetNo, FormNo, 35)); //20230619 Igor
  end;
  //20230619 Igor >>>
  FormNo := GetFormNo('T1134');
  PopulateForeignAffiliates(7, 4);
  //20230619 Igor <<<
end;
*)

function GetT1134ForeignAffiliatesIdentificationNumber(ARetNo: Integer; AName: string): string; //20230510 Igor //20230601 Igor
var FormNo, I: integer;
    function GetForeignAffiliatesNumber(ArrayNo, ElmNameId, ElmNumberId: integer): string; //20230619 Igor
    var BoxesPerRow, ElmName, ElmNumber, RowCount, i: integer;
    begin
      BoxesPerRow := RetList[ARetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
      ElmName := ArrayNo * 10000 + ElmNameId;
      ElmNumber := ArrayNo * 10000 + ElmNumberId;
      RowCount := DynamicRowCount(ARetNo, FormNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        if SameText(AName, FetchElmFNo(ARetNo, FormNo, ElmName)) then
        begin
          Result := FetchElmFNo(ARetNo, FormNo, ElmNumber);
          break;
        end;
        ElmName := ElmName + BoxesPerRow;
        ElmNumber := ElmNumber + BoxesPerRow;
      end;
    end;
begin
  For i:=1 to 10 do
  begin
   FormNo:=GetFormNo('T1134S#'+IntToStr(i));
   If FormNo>0 then
     if SameText(FetchElmFNo(ARetNo, FormNo, 35), AName) then
     begin
       Result := FetchElmFNo(ARetNo, FormNo, 4);
       break;
     end;
  end;
  //20230619 Igor >>>
  FormNo := GetFormNo('T1134');
  if Result.IsEmpty then
    Result := GetForeignAffiliatesNumber(7, 4, 5);
  //20230619 Igor <<<
end;


{
function GetT1134ForeignAffiliatesIdentificationNumber(ARetNo: Integer; AName: string): string; //20230510 Igor //20230601 Igor
var FormNo, I: integer;
begin
  For i:=1 to 10 do
  begin
   FormNo:=GetFormNo('T1134S#'+IntToStr(i));
   If FormNo>0 then
     if SameText(FetchElmFNo(ARetNo, FormNo, 35), AName) then
     begin
       Result := FetchElmFNo(ARetNo, FormNo, 4);
       break;
     end;
  end;
end;
}

function GetT1134ForeignAffiliatesCountryCode(ARetNo: Integer; AName: string): string; //20230601 Igor
var FormNo, I: integer;
    function GetForeignAffiliatesCountryCode(ArrayNo, ElmNameId, ElmNumberId: integer): string; //20230619 Igor
    var BoxesPerRow, ElmName, ElmNumber, RowCount, i: integer;
    begin
      BoxesPerRow := RetList[ARetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
      ElmName := ArrayNo * 10000 + ElmNameId;
      ElmNumber := ArrayNo * 10000 + ElmNumberId;
      RowCount := DynamicRowCount(ARetNo, FormNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        if SameText(AName, FetchElmFNo(ARetNo, FormNo, ElmName)) then
        begin
          Result := FetchElmFNo(ARetNo, FormNo, ElmNumber);
          break;
        end;
        ElmName := ElmName + BoxesPerRow;
        ElmNumber := ElmNumber + BoxesPerRow;
      end;
    end;
begin
  For i:=1 to 10 do
  begin
   FormNo:=GetFormNo('T1134S#'+IntToStr(i));
   If FormNo>0 then
     if SameText(FetchElmFNo(ARetNo, FormNo, 35), AName) then
     begin
       Result := FetchElmFNo(ARetNo, FormNo, 48);
       break;
     end;
  end;
  //20230619 Igor >>>
  FormNo := GetFormNo('T1134');
  if Result.IsEmpty then
    Result := GetForeignAffiliatesCountryCode(7, 4, 6);
  //20230619 Igor <<<
end;

{
function GetT1134ForeignAffiliatesCountryCode(ARetNo: Integer; AName: string): string; //20230601 Igor
var FormNo, I: integer;
begin
  For i:=1 to 10 do
  begin
   FormNo:=GetFormNo('T1134S#'+IntToStr(i));
   If FormNo>0 then
     if SameText(FetchElmFNo(ARetNo, FormNo, 35), AName) then
     begin
       Result := FetchElmFNo(ARetNo, FormNo, 48);
       break;
     end;
  end;
end;
}

function GetT1134GroupList(ARetNo: Integer): TArray<T1134GroupItem>; //20230510 Igor
var FormNo: integer;

    procedure AddItem(AName, ANumber: string; AType: TGroupItemAccountType);
    begin
      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1].Name := AName;
      Result[Length(Result) - 1].AccountNumber := ANumber;
      Result[Length(Result) - 1].AccountType := AType;
    end;

    procedure PopulateGroupList(ArrayNo: integer; AType: TGroupItemAccountType; ElmNumberId, ElmNameId: integer; ElmName2Id: integer = 0);
    var BoxesPerRow, ElmName, ElmName2, ElmNumber, RowCount, i: integer;
        ValueName, ValueName2, ValueNumber: string;
    begin
      BoxesPerRow := RetList[ARetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
      ElmNumber := ArrayNo * 10000 + ElmNumberId;
      ElmName := ArrayNo * 10000 + ElmNameId;
      ElmName2 := ArrayNo * 10000 + ElmName2Id;
      RowCount := DynamicRowCount(ARetNo, FormNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        ValueNumber := FetchElmFNo(ARetNo, FormNo, ElmNumber);
        ValueName := FetchElmFNo(ARetNo, FormNo, ElmName);
        if ElmName2Id <> 0 then
        begin
          ValueName2 := FetchElmFNo(ARetNo, FormNo, ElmName2);
          if not ValueName2.IsEmpty then
          begin
            if ValueName.IsEmpty then
              ValueName := ValueName2
            else
              ValueName := ValueName + ' ' + ValueName2;
          end;
        end;
        if not ValueName.IsEmpty and not ValueNumber.IsEmpty then
          AddItem(ValueName, ValueNumber, aType);
        ElmNumber := ElmNumber + BoxesPerRow;
        ElmName := ElmName + BoxesPerRow;
        if ElmNameId <> 0 then
          ElmName2 := ElmName2 + BoxesPerRow;
      end;
    end;
begin
  FormNo := GetFormNo('T1134');
  AddItem(FetchElmFNo(ARetNo, FormNo, 7), FetchElmFNo(ARetNo, FormNo, 8), atCorporation);
  PopulateGroupList(1, atIndividual, 10, 1, 3);
  PopulateGroupList(2, atCorporation, 8, 1);
  PopulateGroupList(3, atTrust, 8, 1);
  PopulateGroupList(4, atPartnership, 8, 1);
end;

procedure PopulateT1134GroupList(ARetNo: Integer; AList: TStringList; AShowName: boolean); //20230510 Igor //20230619 Igor
var Arr: TArray<T1134GroupItem>;
    I: integer;
begin
  Arr := GetT1134GroupList(ARetNo);
  for I := 0 to Length(Arr) - 1 do
    //20230619 Igor >>>
    if AShowName then
      AList.Add(Arr[I].AccountNumber + ' - ' + Arr[I].Name)
    else
      AList.Add(Arr[I].AccountNumber);
    //20230619 Igor <<<
end;

procedure PopulateT1134SGroupList(ARetNo, AFormNo: Integer; AList: TStringList; AOnlyArrayNo: integer = 0); //20230510 Igor

    procedure PopulateList(AArrayNo: integer);
    var BoxesPerRow, Elm, RowCount, i, j: integer;
        ValueName, ValueNumber: string;
    begin
      BoxesPerRow := RetList[ARetNo].Frm[AFormNo].FormDataRec.BoxesPerRow[AArrayNo];
      Elm := AArrayNo * 10000;
      RowCount := DynamicRowCount(ARetNo, AFormNo, AArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        for j in [2,3,4,5] do
        begin
          ValueNumber := FetchElmFNo(ARetNo, AFormNo, Elm + j);
          if not ValueNumber.IsEmpty then
            break;
        end;
        ValueName := FetchElmFNo(ARetNo, AFormNo, Elm + 1);
        if not ValueName.IsEmpty and not ValueNumber.IsEmpty then
          AList.Add(ValueNumber + ' - ' + ValueName);
        Elm := Elm + BoxesPerRow;
      end;
    end;
begin
  if AOnlyArrayNo > 0 then
    PopulateList(AOnlyArrayNo)
  else
  begin
    PopulateList(1);
    PopulateList(4);
  end;
end;


(*
function GetT1134GroupList(ARetNo: Integer): TArray<T1134GroupItem>; //20230510 Igor
var FormNo: integer;

    procedure AddItem(AName, ANumber: string; AType: TGroupItemAccountType);
    begin
      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1].Name := AName;
      Result[Length(Result) - 1].AccountNumber := ANumber;
      Result[Length(Result) - 1].AccountType := AType;
    end;

    procedure PopulateGroupList(ArrayNo: integer; AType: TGroupItemAccountType; ElmNumberId, ElmNameId: integer; ElmName2Id: integer = 0);
    var BoxesPerRow, ElmName, ElmName2, ElmNumber, RowCount, i: integer;
        ValueName, ValueName2, ValueNumber: string;
    begin
      BoxesPerRow := RetList[ARetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
      ElmNumber := ArrayNo * 10000 + ElmNumberId;
      ElmName := ArrayNo * 10000 + ElmNameId;
      ElmName2 := ArrayNo * 10000 + ElmName2Id;
      RowCount := DynamicRowCount(ARetNo, FormNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        ValueNumber := FetchElmFNo(ARetNo, FormNo, ElmNumber);
        ValueName := FetchElmFNo(ARetNo, FormNo, ElmName);
        if ElmName2Id <> 0 then
        begin
          ValueName2 := FetchElmFNo(ARetNo, FormNo, ElmName2);
          if not ValueName2.IsEmpty then
          begin
            if ValueName.IsEmpty then
              ValueName := ValueName2
            else
              ValueName := ValueName + ' ' + ValueName2;
          end;
        end;
        if not ValueName.IsEmpty and not ValueNumber.IsEmpty then
          AddItem(ValueName, ValueNumber, aType);
        ElmNumber := ElmNumber + BoxesPerRow;
        ElmName := ElmName + BoxesPerRow;
        if ElmNameId <> 0 then
          ElmName2 := ElmName2 + BoxesPerRow;
      end;
    end;
begin
  FormNo := GetFormNo('T1134');
  AddItem(FetchElmFNo(ARetNo, FormNo, 7), FetchElmFNo(ARetNo, FormNo, 8), atCorporation);
  PopulateGroupList(1, atIndividual, 10, 1, 3);
  PopulateGroupList(2, atCorporation, 8, 1);
  PopulateGroupList(3, atTrust, 8, 1);
  PopulateGroupList(4, atPartnership, 8, 1);
end;

procedure PopulateT1134GroupList(ARetNo: Integer; AList: TStringList); //20230510 Igor
var Arr: TArray<T1134GroupItem>;
    I: integer;
begin
  Arr := GetT1134GroupList(ARetNo);
  for I := 0 to Length(Arr) - 1 do
    AList.Add(Arr[I].AccountNumber + ' - ' + Arr[I].Name);
end;

procedure PopulateT1134SGroupList(ARetNo, AFormNo: Integer; AList: TStringList; AOnlyArrayNo: integer = 0); //20230510 Igor

    procedure PopulateList(AArrayNo: integer);
    var BoxesPerRow, Elm, RowCount, i, j: integer;
        ValueName, ValueNumber: string;
    begin
      BoxesPerRow := RetList[ARetNo].Frm[AFormNo].FormDataRec.BoxesPerRow[AArrayNo];
      Elm := AArrayNo * 10000;
      RowCount := DynamicRowCount(ARetNo, AFormNo, AArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        for j in [2,3,4,5] do
        begin
          ValueNumber := FetchElmFNo(ARetNo, AFormNo, Elm + j);
          if not ValueNumber.IsEmpty then
            break;
        end;
        ValueName := FetchElmFNo(ARetNo, AFormNo, Elm + 1);
        if not ValueName.IsEmpty and not ValueNumber.IsEmpty then
          AList.Add(ValueNumber + ' - ' + ValueName);
        Elm := Elm + BoxesPerRow;
      end;
    end;
begin
  if AOnlyArrayNo > 0 then
    PopulateList(AOnlyArrayNo)
  else
  begin
    PopulateList(1);
    PopulateList(4);
  end;
end;
*)



function GenerateReturnFileName(ARetNo: integer; AFileNameFormat: string)
  : string; // 20201013 Igor
var
  nCountForTrunc: integer;
  cCorpName, cAccountNumber, cExt: string;
begin
  cCorpName := GetCorpName(ARetNo);
  cAccountNumber := LeftStr(GetAccountNumber(ARetNo), 9);
  cExt := '.' + MidStr(FetchElm(ARetNo, 'T2', 11), 3, 2);
  // 20201212 CON (ran ito problems with thenew extension)
  // cExt := '.' + AppName + '-' + MidStr(FetchElm(ARetNo,'T2',11),3,2);
  if AFileNameFormat = '0' then
    Result := cAccountNumber + cExt
  else
  begin
    Result := NormalizeFileName(cCorpName + '-' + '{' + cAccountNumber +
      '}' + cExt);
    if Length(Result) > 50 then
    begin
      nCountForTrunc := Length(Result) - 50;
      if nCountForTrunc > 0 then
        cCorpName := Copy(cCorpName, 1, Length(cCorpName) - nCountForTrunc);
      Result := NormalizeFileName(cCorpName + '-' + '{' + cAccountNumber +
        '}' + cExt);
    end;
  end;
end;

function Pars(Msg: string; Elm: integer; Delimiter: string): string;
const
  QuoteChar = '"';
var
  i: integer;
  DelimiterPositions: TStringList;
  FirstQuoteSw: Boolean;
begin
  if RightStr(Msg, 1) <> Delimiter then
    Msg := Msg + Delimiter;
  if LeftStr(Msg, 1) <> Delimiter then
    Msg := Delimiter + Msg;
  if (Length(Msg) < 2) or (Elm < 1) or (Msg = '') then
  begin
    Result := '';
    exit;
  end;

  DelimiterPositions := TStringList.Create;
  FirstQuoteSw := False;
  i := 1;
  repeat
    if Msg[i] = QuoteChar then
      FirstQuoteSw := True; { quotations started }
    if (Msg[i] = Delimiter) and (FirstQuoteSw = False) then
      DelimiterPositions.Add(IntTostr(i));
    Inc(i);
  until i > Length(Msg);
  if Elm > DelimiterPositions.Count then
    Result := ''
  else
    Result := MidStr(Msg, StrToInt(DelimiterPositions[Elm - 1]) + 1,
      StrToInt(DelimiterPositions[Elm]) -
      StrToInt(DelimiterPositions[Elm - 1]) - 1);
  DelimiterPositions.Free;
end;

function GetOITC(RetNo: integer): Real;
begin
  Result := VL(FetchElm(RetNo, 'OITC_5', 43));
end;

function IsAssociated(RetNo: integer): Boolean;
begin
  if UpperCase(FetchElm(RetNo, 'S23', 127)) = 'Y' then
    Result := True
  else
    Result := False;
end;

function YrEndToYYYYMMDD(YrEnd: string): string;
begin
  Result := YrEnd;
end;

function DDMMYYYYToYYYYMMDD(Dt: string): string;
begin
  Result := RightStr(Dt, 4) + '/' + MidStr(Dt, 4, 2) + '/' + LeftStr(Dt, 2);
  if Result = '//' then
    Result := '';
end;

function MMDDYYYYToYYYYMMDD(Dt: string): string;
{ from mm/dd/yyyy }
begin
  Result := RightStr(Dt, 4) + '/' + LeftStr(Dt, 2) + '/' + MidStr(Dt, 4, 2);
  if Result = '//' then
    Result := '';
end;

function YYYYMMDDToDDMMYYYY(Dt: string): string;
begin
  Result := RightStr(Dt, 2) + '-' + MidStr(Dt, 6, 2) + '-' + LeftStr(Dt, 4);
  if Result = '--' then
    Result := '';
  {
    Result := RightStr(Dt,2)+'/'+MidStr(Dt,6,2)+'/'+LeftStr(Dt,4);
    If Result = '//' then result :='';
  }
end;

function YYYYMMDDToMMDDYYYY(Dt: string): string;
begin
  { ? }
  Result := MidStr(Dt, 6, 2) + '/' + RightStr(Dt, 2) + '/' + LeftStr(Dt, 4);
  if Result = '//' then
    Result := '';
end;

function GetFedPolitCredit(RetNo: integer; PolContr: Real): Real;
var
  X1, X2, X3: Real;
begin
  Result := 0;
  if GetTaxationYearEndYYYY(RetNo) >= 2004 then
  begin
    if (PolContr > 0) and (PolContr <= 400) then
    begin
      Result := PolContr * 0.75;
      exit;
    end
    else if (PolContr > 400) and (PolContr <= 750) then
    begin
      Result := 300 + (PolContr - 400) * 0.50;
      exit;
    end
    else if (PolContr > 750) and (PolContr <= 1275) then
    begin
      Result := 475 + (PolContr - 750) * (33.33 / 100);
      exit;
    end
    else if PolContr > 1275 then
      Result := 650;
  end
  else
  begin
    if (PolContr > 0) and (PolContr <= 200) then
    begin
      Result := PolContr * 0.75;
      exit;
    end
    else if (PolContr > 200) and (PolContr <= 550) then
    begin
      Result := 150 + (PolContr - 200) * 0.50;
      exit;
    end
    else if (PolContr > 550) and (PolContr <= 1075) then
    begin
      Result := 275 + (PolContr - 550) * (33.33 / 100);
      exit;
    end
    else if PolContr > 1075 then
      Result := 500;
  end;
end;

function GetSKPolitCredit(RetNo: integer; PolContr: Real): Real;
var
  X1, X2, X3: Real;
begin
  Result := 0;
  if GetTaxationYearEndYYYY(RetNo) >= 2004 then
  begin
    if (PolContr > 0) and (PolContr <= 400) then
    begin
      Result := PolContr * 0.75;
      exit;
    end
    else if (PolContr > 400) and (PolContr <= 750) then
    begin
      Result := 300 + (PolContr - 400) * 0.50;
      exit;
    end
    else if (PolContr > 750) and (PolContr <= 1275) then
    begin
      Result := 475 + (PolContr - 750) * (33.33 / 100);
      exit;
    end
    else if PolContr > 1275 then
      Result := 650;
  end
  else
  begin
    if (PolContr > 0) and (PolContr <= 200) then
    begin
      Result := PolContr * 0.75;
      exit;
    end
    else if (PolContr > 200) and (PolContr <= 550) then
    begin
      Result := 150 + (PolContr - 200) * 0.50;
      exit;
    end
    else if (PolContr > 550) and (PolContr <= 1075) then
    begin
      Result := 275 + (PolContr - 550) * (33.33 / 100);
      exit;
    end
    else if PolContr > 1075 then
      Result := 500;
  end;
end;

function GetPolitCredit(Contr: Real): Real;
var
  X1, X2, X3: Real;
begin
  Result := 0;
  X1 := MinR(100, Contr) * 0.75;
  X2 := (MinR(450, (Contr - 100))) * 0.50;
  if X2 < 0 then
    X2 := 0;
  X3 := MaxR(0, (Contr - 550) * (33.33 / 100));
  Result := MinR(500, (X1 + X2 + X3));
end;

function GetNUPolitCredit(Contr: Real): Real;
var
  X1, X2, X3: Real;
begin
  // 20100501
  Result := 0;
  X1 := MinR(100, Contr) * 1.00;
  X2 := MaxR(0, Contr - 100) * 0.50;
  if X2 < 0 then
    X2 := 0;
  Result := MinR(500, (X1 + X2));
end;

function GetNWTPolitCredit(Contr: Real): Real;
var
  X1, X2: Real;
begin
  X1 := MinR(100, Contr) * 100 / 100;
  X2 := (MinR(800, (Contr - 100))) * 0.50;
  if X2 < 0 then
    X2 := 0;
  Result := MinR(500, (X1 + X2));
end;

function MyStrToFloat(AString: string): Real;
begin
  AString := Ltrim(AString);
  if AString = '' then
    Result := 0
  else
    Result := StrToFloat(AString);
end;

procedure FillHeader(RetNo, FormNo, NameElm, AccountElm, YearEndElm: integer);
begin
  if FormNo = 0 then
    exit; // 20110417
  with Ret[RetNo].Frm[FormNo] do
  begin
    { screws up the bardode data
      If Length(GetCorpName(RetNo)) >80 then  //20111125
      Strings[NameElm] := LeftStr(GetCorpName(RetNo),80)+'...'
      else
    }
    Strings[NameElm] := GetCorpName(RetNo);
    Strings[AccountElm] := GetNineDigitAccountNumber(RetNo);  //20250116 CZ //GetAccountNumber(RetNo);//LeftStr(GetAccountNumber(RetNo), 9);  //20240726 Igor
    Strings[YearEndElm] := GetTaxationYearEnd(RetNo);
  end;
end;

function GetMaxBizLimit(RetNo: integer; YrEnd: integer): Real;
begin
  Result := 400000;
  if YrEnd = 2005 then
    Result := 300000;
  if YrEnd = 2006 then
    Result := 300000;
  if YrEnd = 2007 then
    Result := 400000;
  if YrEnd = 2008 then
    Result := 400000;
  if YrEnd > 2008 then
    Result := 500000;
end;

function GetMBMaxBizLimit(RetNo: integer; YrEnd: integer): Real;
begin
  Result := 400000;
  if YrEnd = 2005 then
    Result := 300000;
  if YrEnd = 2006 then
    Result := 300000;
  if YrEnd > 2006 then
    Result := 400000;
end;

function GetNBMaxBizLimit(RetNo: integer; YrEnd: integer): Real;
begin
  Result := 300000;
  if YrEnd >= 2005 then
    Result := 300000;
end;

function GetIncForSmBusDed(RetNo: integer): Real;
begin
  Result := MinR(MinR(Ret[RetNo].Ln[400], Ret[RetNo].Ln[405]),
    MinR(Ret[RetNo].Ln[410], GetReducedBusinessLimit(RetNo)));
  // 20190626  Ret[Retno].Ln[427])); //20170620

  { see above
    if GetBegYearEnd(RetNo) > '2018/12/31'  then
    Result := MinR(
    MinR(Ret[Retno].Ln[400],
    Ret[Retno].Ln[405]),
    MinR(Ret[Retno].Ln[410],
    Ret[Retno].Ln[428])); //20190418
  }
end;

//20250524
procedure SetCorpType(RetNo: integer);
Var FNo:Integer;
begin
  FNo:=GetFormNo('T2');
  Ret[RetNo].CorpType := CCPC;
  if FetchElmFNo(RetNo, FNo, 51) > '' then
    Ret[RetNo].CorpType := CCPC;
  if FetchElmFNo(RetNo, FNo, 52) > '' then
    Ret[RetNo].CorpType := ControlledbyPublic;
  if FetchElmFNo(RetNo, FNo, 56) > '' then
    Ret[RetNo].CorpType := OtherPrivate;
  if FetchElmFNo(RetNo, FNo, 57) > '' then
    Ret[RetNo].CorpType := Other;
  if FetchElmFNo(RetNo, FNo, 59) > '' then
    Ret[RetNo].CorpType := PublicCorp;
  {
    If FetchElm(RetNo,'T2',60) >'' then
    Ret[RetNo].CorpType := PublicCorp;
  }
end;

function GetCorpName(RetNo: integer): string;
{ Returns Corp Name from T2 }
begin
  Result := AllTrim(FetchElm(RetNo, 'T2', 3) + ' ' + FetchElm(RetNo, 'T2', 65));
end;

function GetAccountNumber(RetNo: integer): string;
begin
  Result := FetchElm(RetNo, 'T2', 1);
end;

function GetNineDigitAccountNumber(RetNo: integer): string;
begin
  Result := LeftStr(FetchElm(RetNo, 'T2', 1), 9);
end;

function GetTaxationYearEnd(RetNo: integer): string;
{ Returns Taxation Year as Input in T2 }
begin
  Result := FetchElm(RetNo, 'T2', 11);
end;

function GetTaxationYearStart(RetNo: integer): string;
{ Returns Taxation Year as Input in T2 }
begin
  Result := FetchElm(RetNo, 'T2', 10);
end;

function GetTaxationYearEndYYYY(RetNo: integer): integer;
{ Returns Taxation Year as Input in T2 }
begin
  Result := MyStrToInt(LeftStr(FetchElm(RetNo, 'T2', 11), 4));
end;

// 20210519
function GetTaxationYearStartYYYY(RetNo: integer): integer;
{ Returns Taxation Year as Input in T2 }
begin
  Result := MyStrToInt(LeftStr(FetchElm(RetNo, 'T2', 10), 4));
end;

procedure SetNumDays(RetNo: integer);
begin
  // 20120806
  if (Length(FetchElm(RetNo, 'T2', 10)) <> 10) or
    (Length(FetchElm(RetNo, 'T2', 10)) <> 10) then
  begin
    Ret[RetNo].DaysInYear := 365;
    exit;
  end;
  Ret[RetNo].DaysInYear := DateDiffYMD(FetchElm(RetNo, 'T2', 10),
    FetchElm(RetNo, 'T2', 11));
  if Ret[RetNo].DaysInYear <= 0 then
    Ret[RetNo].DaysInYear := 365;
  if Ret[RetNo].DaysInYear > 375 then
    Ret[RetNo].DaysInYear := 375;
end;

function GetNumDays(RetNo: integer; ADate: string; BfrAftr: string): integer;
var
  i: integer;
  BegDate, EndDate: string;
begin
  Result := 0;
  try
    ADate := DMYtoYMD(ADate); { convert to mm/dd/yyyy }
    BegDate := FetchElm(RetNo, 'T2', 10);
    EndDate := FetchElm(RetNo, 'T2', 11);
    if BfrAftr = 'B' then
      Result := DateDiffYMD(BegDate, ADate) - 1
    else
      Result := DateDiffYMD(ADate, EndDate) - 1;

    if Result < 0 then
      Result := 0;
    if Result > Ret[RetNo].DaysInYear then
      Result := Ret[RetNo].DaysInYear;
  except
    on E: Exception do
      MessageDlg('Num of days ' + E.Message, mtError, [mbok], 0);
  end;
end;

function GetNumDays2(RetNo: integer; BegDate: string; EndDate: string;
  ADate: string; BfrAftr: string): integer;
var
  i: integer;
begin
  Result := 0;
  try
    ADate := DMYtoYMD(ADate); { convert to mm/dd/yyyy }
    // BegDate := YYYYMMDDToMMDDYYYY(BegDate);
    // EndDate := YYYYMMDDToMMDDYYYY(EndDate);
    if BfrAftr = 'B' then
      Result := DateDiffYMD(BegDate, ADate) - 1
    else
      Result := DateDiffYMD(ADate, EndDate) - 1;

    if Result < 0 then
      Result := 0;
    if Result > Ret[RetNo].DaysInYear then
      Result := Ret[RetNo].DaysInYear;
  except
    on E: Exception do
      MessageDlg('Num of days ' + E.Message, mtError, [mbok], 0);
  end;
end;

function GetAnyNumDays(RetNo: integer; BegDate: string; EndDate: string;
  ADate: string; BfrAftr: string): integer;
var
  i: integer;
begin
  try
    ADate := DMYtoYMD(ADate);
    if BfrAftr = 'B' then
      Result := DateDiffYMD(BegDate, ADate) - 1
    else
      Result := DateDiffYMD(ADate, EndDate) - 1;

    if Result < 0 then
      Result := 0;
    if Result > Ret[RetNo].DaysInYear then
      Result := Ret[RetNo].DaysInYear;
  except
    on E: Exception do
    begin
      MessageDlg('Num of days ' + E.Message, mtError, [mbok], 0);
      UndefMsg('GetAnyNumDays');
      Result := 0; // ???
    end;
  end;
end;

function PositionInList(AString: string; SomeList: TStringList): integer;
var
  i, LengthOfKeyWord: integer;
begin
  Result := -1;
  AString := AllTrim(AString);
  LengthOfKeyWord := Length(AString);
  for i := 0 to SomeList.Count - 1 do
    if AString = LeftStr(AllTrim(SomeList[i]), LengthOfKeyWord) then
    begin
      Result := i;
      exit;
    end;
end;

function CountPagesGenerated(RetNo: integer): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if Ret[RetNo].FrmHasData[FRec.FormNo] then
      Inc(Result);
  end;
end;

function IsFormMultiPage(FName: string): Boolean;
var
  i: integer;
begin
  Result := False;
  i := Length(FName);
  while i > 0 do
  begin
    if FName[i] = '_' then
    begin
      Result := True;
      exit;
    end;
    Dec(i);
  end;
end;

procedure CountMulties(RetNo: integer; var Frms: TStringList;
  var HowMany: TStringList);
var
  i, j: integer;
begin
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if Ret[RetNo].FrmHasData[FRec.FormNo] then
    begin
      if IsFormMultiPage(FRec.FormName) then { Multipage }
      begin
        if (RightStr(FRec.FormName, 2) = '_1') and (FRec.FormInst = '#1') then
        begin
          Frms.Add(FRec.FormName);
          HowMany.Add('1');
        end
        else if (RightStr(FRec.FormName, 2) = '_1') and (FRec.FormInst > '#1')
        then
          for j := 0 to Frms.Count - 1 do
            if FRec.FormName = Frms[j] then
              HowMany[j] := IntTostr(StrToInt(HowMany[j]) + 1);
      end
      else { Single Page }
      begin
        if (FRec.FormInst = '#1') then
        begin
          Frms.Add(FRec.FormName);
          HowMany.Add('1');
        end
        else
          for j := 0 to Frms.Count - 1 do
            if FRec.FormName = Frms[j] then
              HowMany[j] := IntTostr(StrToInt(HowMany[j]) + 1);
      end;
    end;
  end;
end;

function MultiPage1(Frm: string; Inst: string; MxPg: integer): Boolean;
{ frm is noninstance }
begin
  Result := False;
  if (Inst = '#1') then
    if (RightStr(Frm, 2) = '-1') or (MxPg < 2) then
      Result := True;
end;

function MultiPage23(Frm: string; Inst: string; MxPg: integer): Boolean;
{ frm is noninstance }
begin
  Result := False;
  if (Inst > '#1') then
    if (RightStr(Frm, 2) = '-1') or (MxPg < 2) then
      Result := True;
end;

function CountKeystrokePoints(RetNo: integer): integer;
var
  i: integer;
  ADConnection: TADConnection;
  Table1: TADTable;
begin
  Result := 0;

  // 20150922 Igor
  ADConnection := TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  SetTableName(ADConnection, Table1, AppDir + '\' + FormsFeesDBLite,
    FormsFeesTableLite, 'FORMNAME');

  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if Ret[RetNo].FrmHasData[FRec.FormNo] then
    begin
      if Table1.FindKey([FRec.FormName]) then
      begin { Table1.FieldByName(Template).AsString; }
      end;
    end;
  end;
  Table1.Close;
  Table1.Free;
  ADConnection.Free;
end;

// 20220107 Igor
procedure InitCCARates;
var
  TempList: TStringList;
  i: integer;
begin
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir + '\' + 'CCARATES.D');
  // 20220107 Igor >>>
  SetLength(CCAClasses, TempList.Count + 1);
  SetLength(CCaRates, TempList.Count + 1);
  // 20220107 Igor <<<
  for i := 0 to TempList.Count - 1 do
  begin
    CCAClasses[i + 1] := RTrim(LeftStr(TempList[i], 4));
    CCaRates[i + 1] := MidStr(TempList[i], 6, 3);
  end;
  TempList.Free;
end;

(*
  procedure InitCCARates;
  var
  TempList: TstringList;
  I: integer;
  begin
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir + '\' + 'CCARATES.D');
  for i := 0 to TempList.Count - 1 do
  begin
  CCaClasses[i + 1] := RTrim(LeftStr(TempList[i], 4));
  CCaRates[i + 1] := MidStr(TempList[i], 6, 3);
  end;
  TempList.Free;
  end;
*)
procedure InitPRVRates(RetNo: integer);
var
  TempList: TStringList;
  i: integer;
  Dt: string;
  LowRate2, HighRate2: Real;
begin
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir + '\' + 'PRVRATES.D');
  for i := 0 to 14 do { TempList.Count-1 do }
  begin
    PrvLowRate[i + 1] := VL(AllTrim(MidStr(TempList[i], 5, 6)));
    PrvHighRate[i + 1] := VL(AllTrim(MidStr(TempList[i], 12, 6)));
    Dt := AllTrim(MidStr(TempList[i], 20, 10));
    if (Length(Dt) = 10) and (RetNo > 0) then
    begin
      LowRate2 := VL(AllTrim(MidStr(TempList[i], 31, 6)));
      HighRate2 := VL(AllTrim(MidStr(TempList[i], 39, 6)));
      if LowRate2 > 0 then
        PrvLowRate[i + 1] := StraddleLowRate(RetNo, Dt, PrvLowRate[i + 1],
          LowRate2);
      if HighRate2 > 0 then
        PrvHighRate[i + 1] := StraddleHighRate(RetNo, Dt, PrvHighRate[i + 1],
          HighRate2);
    end;
  end;
  TempList.Free;
end;

function StraddleLowRate(RetNo: integer; Dt: string; Rate1, Rate2: Real): Real;
var
  StraddleDate: string;
  DaysB, DaysA: integer;
begin
  StraddleDate := RightStr(Dt, 2) + '-' + MidStr(Dt, 6, 2) + '-' +
    LeftStr(Dt, 4);
  DaysB := GetNumDays(RetNo, StraddleDate, 'B');
  DaysA := GetNumDays(RetNo, StraddleDate, 'A') + 1;
  if DaysA + DaysB > 0 then
    Result := (Rate1 * DaysB + Rate2 * DaysA) / (DaysA + DaysB)
  else
    Result := Rate1;
end;

function StraddleHighRate(RetNo: integer; Dt: string; Rate1, Rate2: Real): Real;
var
  StraddleDate: string;
  DaysB, DaysA: integer;
begin
  StraddleDate := RightStr(Dt, 2) + '-' + MidStr(Dt, 6, 2) + '-' +
    LeftStr(Dt, 4);
  DaysB := GetNumDays(RetNo, StraddleDate, 'B');
  DaysA := GetNumDays(RetNo, StraddleDate, 'A') + 1;
  if DaysA + DaysB > 0 then
    Result := (Rate1 * DaysB + Rate2 * DaysA) / (DaysA + DaysB)
  else
    Result := Rate1;
end;

function GetCCARate(cls: string): string;
var
  i: integer;
begin
  Result := '';
  cls := RmvLeadingZeros(cls);
  for i := 1 to High(CCAClasses) do
    if AllTrim(cls) = AllTrim(CCAClasses[i]) then
    begin
      Result := AllTrim(CCaRates[i]);
      exit;
    end;
end;
(*
  //20190609
  procedure CalcCCA(Cls: string;OriginalCost:Real; UccStart: real;
  Additions: real; Adjustments: real; Proceeds: real;
  var UCC: real; var HalfRuleAmount: real; var UCCReduced: real;
  OverrideIndic: string; HalfYearIndic: string; TermLossIndic: string;
  Var Rate: string;  //20190607 made it var
  var Recapture: Real; var TerminalLoss: Real;
  var CCA: real; var UccEnd: real;
  DaysinTaxYear: integer;
  AssetInfo:String;
  EligibleForAiip:Boolean;
  AiipFactor:String;
  Var AdditionsAiip:Real;
  Var AssistanceReceived:Real;
  Var RepaidAmount:Real;
  var ProceedsAiip:Real;
  var NetCapCostAdditionsAiip:Real;
  var UccAdjustmentAiip:Real;
  var UccAdjustmentNONAiip:Real);

  Var LeaseStart,LeaseEnd: string; LeaseTerm:Real;s:String; k,K1:Integer;LeaseMaxCca:Real;

  begin
  Rate:=GetCCARate(Cls);  //string

  //get lease and orinal cost from decr box
  if Cls='13' then
  begin
  LeaseTerm:=5; //Default;
  //for class 13: 1234567890-1234567890
  s:=ReplaceChar(AssetInfo,',','');
  LeaseStart:=LeftStr(S,10);
  LeaseEnd:=MidStr(S,12,10);
  if (Length(LeaseStart)<>10) or (Length(LeaseEnd)<>10) then
  LeaseTerm :=0
  Else
  begin
  LeaseTerm := DateDiffYMD(LeaseStart,LeaseEnd) div 365;
  If (LeaseTerm>0) and (LeaseTerm<5) then LeaseTerm :=5;
  End;
  LeaseMaxCCA:=(OriginalCost/LeaseTerm)*50/100;
  Rate:=FormatFloat('####.##',100/LeaseTerm);      //20190601
  end;

  if Cls = '' then
  begin
  UCC := 0;
  HalfRuleAmount := 0;
  UccReduced := 0;
  Recapture := 0;
  TerminalLoss := 0;
  CCA := 0;
  UCCEnd := 0;
  end;
  if DaysInTaxYear > 365 then DaysInTaxYear := 365;
  Ucc := UccStart + Additions + Adjustments - AssistanceReceived + RepaidAmount - Proceeds; //20190606pm
  if cls='10.1' then Ucc:= UccStart + Additions + Adjustments - AssistanceReceived + RepaidAmount; //20190607 no proceeds

  if cls='13' then UCC:=UCC+OriginalCost;  //20190604

  if UpperCase(HalfYearIndic) = 'Y' then   ////20190605
  begin
  if UpperCase(OverrideIndic) <> 'Y' then  //20190605
  begin
  HalfRuleAmount := MaxR(0, 0.5 * (Additions-AssistanceReceived+RepaidAmount-Proceeds));
  HalfRuleAmount := RoundCorrect(HalfRuleAmount);
  end;
  end
  else
  HalfRuleAmount := 0;

  If EligibleForAiip then
  Begin
  HalfRuleAmount:=0;   //20190608
  UCCReduced:=UccStart +additions+Adjustments-Proceeds;
  ProceedsAiip:=MaxR(0,Proceeds+AssistanceReceived-Additions+AdditionsAiiP-RepaidAmount);
  NetCapCostAdditionsAiip:=MaxR(0,AdditionsAiip-ProceedsAiip);
  UccAdjustmentAiip:=NetCapCostAdditionsAiip*vl(AiipFactor);
  UccAdjustmentNONAiip:=MaxR(0,0.5 * (Additions-AdditionsAiip-AssistanceReceived+RepaidAmount-Proceeds));
  End
  Else
  Begin
  UCCReduced := UCC - HalfRuleAmount;
  ProceedsAiip:=0;
  NetCapCostAdditionsAiip:=0;
  UccAdjustmentAiip:=0;
  UccAdjustmentNONAiip:=0;
  end;
  end;
*)

function GetYTClassInclusionRate(cls: string): string;
var
  i: integer;
begin
  (*
    Result := '';
    Cls := RmvLeadingZeros(Cls);
    for i := 1 to 40 do
    CCaClasses
    if AllTrim(Cls) = AllTrim(CCAClasses[i]) then
    begin Result := AllTrim(CCARates[i]);
    exit;
    end;
  *)
end;

function GetFormNameFromRsi(RsiNm: string; FedOrProv: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    // 2008/09/15
    if UpperCase(FRec.RsiName) = AllTrim(UpperCase(RsiNm)) then
    begin
      Result := AllTrim(UpperCase(FRec.FormInstName));
      exit;
    end;
  end;
end;

function GetAlbertaFormNameFromRsi(RsiNm: string): string;
var
  i: integer;
begin
  Result := '';
  RsiNm := AllTrim(RsiNm);
  if RsiNm = 'Schedule 000' then
    Result := 'AT1';
  if RsiNm = 'Schedule 001' then
    Result := 'AS1';
  if RsiNm = 'Schedule 002' then
    Result := 'AS2';
  if RsiNm = 'Schedule 003' then
    Result := 'AS3'; // 20121004  /as3_1
  if RsiNm = 'Schedule 004' then
    Result := 'AS4';
  if RsiNm = 'Schedule 005' then
    Result := 'AS5';
  if RsiNm = 'Schedule OS5' then
    Result := 'AS5';
  if RsiNm = 'Schedule 006' then
    Result := 'AS6';
  if RsiNm = 'Schedule 007' then
    Result := 'AS7';
  if RsiNm = 'Schedule 008' then
    Result := 'AS8';
  //if RsiNm = 'Schedule 009' then Result := 'AS9';  //20231024
  if RsiNm = 'Schedule 010' then
    Result := 'AS10';
  if RsiNm = 'Schedule 011' then
    Result := 'AS11';
  if RsiNm = 'Schedule 012' then
    Result := 'AS12';

  if RsiNm = 'Schedule 013' then Result := 'AS13#1';
  //if RsiNm = 'Schedule 013' then Result := 'AS3'; // 20170624

  if RsiNm = 'Schedule 014' then
    Result := 'AS14';

  if RsiNm = 'Schedule 015' then
    Result := 'AS15';

  if RsiNm = 'Schedule 016' then
    Result := 'AS16';
  if RsiNm = 'Schedule 017' then
    Result := 'AS17';
  if RsiNm = 'Schedule 018' then
    Result := 'AS18';
  if RsiNm = 'Schedule 019' then
    Result := 'AS19'; // _1';  20121004
  if RsiNm = 'Schedule 020' then
    Result := 'AS20';
  if RsiNm = 'Schedule 021' then
    Result := 'AS21';
  if RsiNm = 'Schedule 022' then
    Result := 'AS22; // _1'; // 20121004

  // 20211207 jz -------------------
  if RsiNm = 'Schedule 029' then Result := 'AS29';  //20231024
  if RsiNm = 'Schedule 09L' then Result := 'AS9L';
  if RsiNm = 'Schedule 29L' then Result := 'AS29L';
  // 20211207 jz -------------------
end;

function RSIType(RetNo: integer; FName: string; FedOrProv: string): string;
begin
  Result := 'F';
  if (LeftStr(FName, 1) = 'A') and (FedOrProv = 'A') then
    Result := 'A'
  else
  begin
    if IsAmalgamatedOntario(RetNo) then
    begin
      Result := 'F';
      exit;
    end;
    if (LeftStr(FName, 1) = 'O') and (FedOrProv = 'O') then
      Result := 'O';
  end;
end;

function IsShowHdrIndicator(FName: string): Boolean;
begin
  Result := FList.ByFormName(FName).ShowHdr;
end;

function IsLandscape(FName: string): Boolean;
begin
  Result := FList.ByFormName(FName).Landscape;
end;

function IsShowFlagIndicator(FName: string): Boolean;
begin
  Result := FList.ByFormName(FName).ShowFlag;
end;

function GetWhiteBoxesIndicator(FName: string): Boolean;
begin
  Result := FList.ByFormName(FName).WhiteBoxes;
end;

// t20150823  New
function TotMultiple(RetNo: integer; NonInstFormName: string; Elm: integer)
  : Real; { No Instance }
var
  i, FNo: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = NonInstFormName then
    begin
      if Ret[RetNo].FrmHasData[FRec.FormNo] then
        Result := Result + VL(FetchElmFNo(RetNo, FRec.FormNo, Elm));
    end;
  end;
end;

// 20180719
function TotMultipleExludingDeletedSlips(RetNo: integer;
  NonInstFormName: string; Elm: integer; dElm: integer;
  deleteString: string): Real;
var
  i, FNo: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = NonInstFormName then
    begin
      if (Ret[RetNo].FrmHasData[FRec.FormNo]) and
        (FetchElmFNo(RetNo, FRec.FormNo, dElm) <> deleteString) then
        Result := Result + VL(FetchElmFNo(RetNo, FRec.FormNo, Elm));
    end;
  end;
end;

(* replaces as above 20150823
  function TotMultiple(RetNo: Integer; NonInstFormName: string; Elm: Integer): Real; {No Instance}
  var
  i, FNo: Integer;
  begin
  Result := 0;
  i := FList.FirstInstNo(NonInstFormName);
  if i < 1 then
  begin
  ErrorMsg('TotMultiple: form ' + NonInstFormName + ' does not exist');
  //ErrorMsg('FP: TotMultiple: form ' + NonInstFormName + ' does not exist');  //20150822  //why needed?
  exit;
  end;

  for i := i to (Flist.count - 1) do
  begin
  FRec := FList.Items[i];
  if FRec.FormName <> NonInstFormName then  break;
  begin
  if Ret[RetNo].FrmHasData[Frec.FormNo] then
  Result := Result + Vl(FetchElmFNo(RetNo, Frec.FormNo, Elm));
  end;
  end;
  end;
*)

// 20160503
function CountMultipleInstances(RetNo: integer; NonInstFormName: string)
  : integer; { No Instance }
var
  i, FNo: integer;
begin
  Result := 0;
  for i := 0 to FList.Count - 1 do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = NonInstFormName then
    Begin
      if Ret[RetNo].FrmHasData[FRec.FormNo] then
        Result := Result + 1;
      // if NonInstFormName='S125' then ShowMessage(NonInstFormName + 'Retno= '+IntToStr(RetNo)+' Inst '+IntToStr(Result)); //20160606
    End;
  end;

end;

(* //20160503
  function CountMultipleInstances(RetNo: Integer; NonInstFormName: string): Integer; {No Instance}
  var
  i, FNo: Integer;
  begin
  Result := 0;
  for i := FList.FirstInstNo(NonInstFormName) to FList.Count - 1 do
  begin
  FRec := FList.Items[i];
  if FRec.FormName <> NonInstFormName then
  break
  if Ret[RetNo].FrmHasData[FRec.FormNo] then
  Result := Result + 1;
  end;
  end;
*)

function IsOpeningBalanceSheetDone(RetNo: integer): Boolean;
begin
  Result := True;
  // 20150825
  if (VL(FetchElm(RetNo, 'S101', 89)) = 0) // assets
    and (VL(FetchElm(RetNo, 'S101', 8)) = 0) { //liabil } then
    Result := False;
  {
    if (Vl(FetchGifiElm(RetNo, 'GIFIBS#2', '2599')) = 0) //assets
    and (Vl(FetchGifiElm(RetNo, 'GIFIBS#2', '3499')) = 0) then //liabil
    result := False;
  }
end;

function CountIncStatements(RetNo: integer): integer; // 20160225 Igor
var
  i, j, FNo: integer;
  FName: String[12];
  FInst: String[3];
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    FName := FRec.FormName;
    FInst := AllTrim(FRec.FormInst); // alltrim 20111129
    FNo := FRec.FormNo;
    If (LeftStr(FName, 6) = 'GIFIIS') then
    begin
      If (VL(FetchGifiElm(RetNo, FName + FRec.FormInst, '9369')) <> 0) or
        (VL(FetchGifiElm(RetNo, FName + FRec.FormInst, '9899')) <> 0) or
        (VL(FetchGifiElm(RetNo, FName + FRec.FormInst, '8089')) <> 0) or
        (VL(FetchGifiElm(RetNo, FName + FRec.FormInst, '8090')) <> 0) or
        (VL(FetchGifiElm(RetNo, FName + FRec.FormInst, '8091')) <> 0) or
        (VL(FetchGifiElm(RetNo, FName + FRec.FormInst, '8092')) <> 0) or
        (VL(FetchGifiElm(RetNo, FName + FRec.FormInst, '8093')) <> 0) or
        (VL(FetchGifiElm(RetNo, FName + FRec.FormInst, '8094')) <> 0) or
        (VL(FetchGifiElm(RetNo, FName + FRec.FormInst, '8095')) <> 0) or
        (VL(FetchGifiElm(RetNo, FName + FRec.FormInst, '8100')) <> 0) or
        (VL(FetchGifiElm(RetNo, FName + FRec.FormInst, '8120')) <> 0) then
        Inc(Result);
    end;
  end;

end;

function FetchElmForEFile(RetNo: integer; FName: string; Elm: integer): string;
var
  FNo: integer;
begin
  FNo := GetFormNo(UpperCase(FName));
  if FNo = 0 then
    exit;
  if Ret[RetNo].Frm[FNo].Count = 0 then
    Result := ''
  else
    Result := Ret[RetNo].Frm[FNo].Strings[Elm];
  if IsFieldABN(FName, Elm) then
    Result := UpperCase(Result);
end;

function SpouseDisabled(RetNo: integer): Boolean;
begin
  Result := False;
  if Ret[RetNo].Frm[GetFormNo('S2')].Count > 0 then
    Result := VL(FetchElm(RetNo, 'S2', 45)) > 0;
end;

procedure UpdateAllDataIndicators(RetNo: integer);
var
  i, FNo: integer;
  FName, s, Msg: string;
begin
  try
    Msg := '';
    for i := 0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      FNo := FRec.FormNo;
      if FNo < 1 then
        continue; // skip undefined forms
      FName := FRec.FormInstName;
      UpdateFormDataIndicator(RetNo, FRec);

      if (Ret[RetNo].AlbAlloc = 0) and
        ((LeftStr(FName, 2) = 'AS') or (LeftStr(FName, 2) = 'AT')) then
        Ret[RetNo].FrmHasData[FNo] := False;
      if (Ret[RetNo].OntAlloc = 0) and (LeftStr(FName, 1) = 'O') then
        Ret[RetNo].FrmHasData[FNo] := False;
    end;
    // SPECIAL
    // 20120627  If UpperCase(FetchElm(RetNo,'S510',154))<>'Y' then Ret[RetNo].FrmHasData[GetFormNo('S511')]:=False; //20120530
    if (UpperCase(FetchElm(RetNo, 'S510', 154)) = 'Y') and (IsAssociated(RetNo))
    then
      Ret[RetNo].FrmHasData[GetFormNo('S511')] := True;

    if UpperCase(FetchElm(RetNo, 'S150', 679)) = 'Y'
    then
      Ret[RetNo].FrmHasData[GetFormNo('S150')] := True;

    if UpperCase(FetchElm(RetNo, 'S151', 414)) = 'Y'
    then
      Ret[RetNo].FrmHasData[GetFormNo('S151')] := True;


    // 20100531
    if ((Ret[RetNo].Province = 'AB') or (GetTxblIncomeInProv(RetNo, 'AB') > 0))
    then
    begin
      Ret[RetNo].FrmHasData[GetFormNo('AS12')] := True;
    end
    else
    begin
      Ret[RetNo].FrmHasData[GetFormNo('AS12')] := False;
    end;

    if GifiNotesEntered(RetNo) = True then // 20090610
      Ret[RetNo].FrmHasData[GetFormNo('FNOTE2')] := True
    else
      Ret[RetNo].FrmHasData[GetFormNo('FNOTE2')] := False;

    { {20180526
      if Vl(FetchElm(RetNo, 'S5', 935)) <> 0 then
      begin
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := True;
      end;
    }
    // 20250524
    if (VL(FetchElm(RetNo, 'S7', 6)) <> 0) or //txbl gains/losses
       (VL(FetchElm(RetNo, 'S7', 9)) <> 0) or
       (VL(FetchElm(RetNo, 'S7', 48)) <> 0) or
       (VL(FetchElm(RetNo, 'S7', 317)) <> 0) or
       (VL(FetchElm(RetNo, 'S7', 335)) <> 0) or
       (VL(FetchElm(RetNo, 'S7', 467)) <> 0) or
       //(VL(FetchElm(RetNo, 'S7', 162)) <> 0) or  do not inclu it //20250525
       (VL(FetchElm(RetNo, 'S7', 308)) > 0) or
       (VL(FetchElm(RetNo, 'S7', 262)) > 0) then
    begin
      Ret[RetNo].FrmHasData[GetFormNo('S7')] := True;
    end;

    FNo := GetFormNo('S20'); // ??? not needed??
    if UpperCase(FetchElmFNo(RetNo, FNo, 24)) = 'Y' then
    begin
      Ret[RetNo].FrmHasData[FNo] := True;
    end;

    // 20201206
    FNo := GetFormNo('ACONSENT'); // 20201206
    if FetchElmFNo(RetNo, FNo, 66) > '' then // new authorization
    begin
      If FetchElmFNo(RetNo, FNo, 64) = '' // thre is date submitted
      then
        Ret[RetNo].FrmHasData[FNo] := True;
    end;

    if UpperCase(FetchElm(RetNo, 'S27', 22)) = 'Y' then
    begin
      Ret[RetNo].FrmHasData[GetFormNo('S27')] := True;
    end
    else
    begin
      Ret[RetNo].FrmHasData[GetFormNo('S27')] := False;
    end;
    //20250924
    if  (VL(FetchElm(RetNo, 'S31', 250)) > 0) // pg3
    or (VL(FetchElm(RetNo, 'S31', 310)) > 0) // pg4
    or (VL(FetchElm(RetNo, 'S31', 531)) > 0) // pg6
    or (Ret[RetNo].FrmHasData[GetFormNo('S31')] = True)
    or (VL(FetchElm(RetNo, 'S31', 1017)) > 0)
    or (VL(FetchElm(RetNo, 'S31', 7)) > 0)
    or (VL(FetchElm(RetNo, 'S31', 1411)) > 0)
    then
    begin
      Ret[RetNo].FrmHasData[GetFormNo('S31')] := True;
    end;

    if (VL(FetchElm(RetNo, 'S33', 114)) > 10000000) or
      (Ret[RetNo].FrmHasData[GetFormNo('S515')] = True) or
      (UpperCase(FetchElm(RetNo, 'S33', 25)) = 'Y')
    // 20160516  //in update all data indic
    then
    begin
      Ret[RetNo].FrmHasData[GetFormNo('S33')] := True;
    end
    else
    begin
      Ret[RetNo].FrmHasData[GetFormNo('S33')] := False;
    end;

    if (VL(FetchElm(RetNo, 'S34', 108)) > 10000000) then
    begin
      Ret[RetNo].FrmHasData[GetFormNo('S34')] := True;
      Ret[RetNo].FrmHasData[GetFormNo('S34')] := True;
    end
    else
    begin
      Ret[RetNo].FrmHasData[GetFormNo('S34')] := False;
      Ret[RetNo].FrmHasData[GetFormNo('S34')] := False;
    end;

    if (VL(FetchElm(RetNo, 'S35', 229)) > 10000000) or
      (VL(FetchElm(RetNo, 'S35', 235)) > 10000000) or
      (VL(FetchElm(RetNo, 'S35', 221)) > 10000000) then
    begin
      Ret[RetNo].FrmHasData[GetFormNo('S35')] := True;
    end
    else
    begin
      Ret[RetNo].FrmHasData[GetFormNo('S35')] := False;
    end;

    // ???
    if Ret[RetNo].FrmHasData[GetFormNo('S38_2')] = True then // 20110514
    begin
      Ret[RetNo].FrmHasData[GetFormNo('S38_1')] := True;
      Ret[RetNo].FrmHasData[GetFormNo('S38_3')] := True;
      Ret[RetNo].FrmHasData[GetFormNo('S38_4')] := True;
      Ret[RetNo].FrmHasData[GetFormNo('S38_5')] := True;
    end;

    // 20161129
    if VL(FetchElm(RetNo, 'S53', 4)) <> VL(FetchElm(RetNo, 'S53', 27)) then
      Ret[RetNo].FrmHasData[GetFormNo('S53')] := True;

    if CountMultipleInstances(RetNo, 'S125') > 1 then
      Ret[RetNo].FrmHasData[GetFormNo('S140')] := True;

    // 20180526
    if ShouldFileS5(RetNo) then
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := True
    Else
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := False;

    if Ret[RetNo].Province = 'MJ' then
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := True; // 20180531

    (*
      //check if S5 applies
      if Ret[Retno].Province = 'MJ' then
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := True
      else
      begin
      if (Ret[Retno].Province = 'BC') then
      begin
      if ((Vl(FetchElm(RetNo, 'S5', 801)) <> Vl(FetchElm(RetNo, 'S5', 816)))
      or (Vl(FetchElm(RetNo, 'S5', 822)) > 0)) then
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := True
      else
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := False;
      end
      else if (Ret[Retno].Province = 'NL') then
      begin
      if Vl(FetchElm(RetNo, 'S5', 401)) <> Vl(FetchElm(RetNo, 'S5', 413)) then
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := True
      else
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := False;
      end
      else if (Ret[Retno].Province = 'PE') then
      begin
      if Vl(FetchElm(RetNo, 'S5', 414)) <> Vl(FetchElm(RetNo, 'S5', 422)) then
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := True
      else
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := False;
      end
      else if (Ret[Retno].Province = 'NS') then
      begin
      if Vl(FetchElm(RetNo, 'S5', 523)) <> Vl(FetchElm(RetNo, 'S5', 552)) then
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := True
      else
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := False;
      end
      else if (Ret[Retno].Province = 'NB') then
      begin
      if Vl(FetchElm(RetNo, 'S5', 516)) <> Vl(FetchElm(RetNo, 'S5', 511)) then
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := True
      else
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := False;
      end
      else if (Ret[Retno].Province = 'MB') then
      begin
      if Vl(FetchElm(RetNo, 'S5', 712)) <> Vl(FetchElm(RetNo, 'S5', 723)) then
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := True
      else
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := False;
      end
      else if (Ret[Retno].Province = 'SK') then
      begin
      if Vl(FetchElm(RetNo, 'S5', 724)) <> Vl(FetchElm(RetNo, 'S5', 732)) then
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := True
      else
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := False;
      end
      else if (Ret[Retno].Province = 'YT') then
      begin
      if Vl(FetchElm(RetNo, 'S5', 931)) <> Vl(FetchElm(RetNo, 'S5', 927)) then
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := True
      else
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := False;
      end
      else if (Ret[Retno].Province = 'NT') then
      begin
      if Vl(FetchElm(RetNo, 'S5', 928)) <> Vl(FetchElm(RetNo, 'S5', 934)) then
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := True
      else
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := False;
      end
      else if (Ret[Retno].Province = 'NU') then
      begin
      if Vl(FetchElm(RetNo, 'S5', 905)) <> Vl(FetchElm(RetNo, 'S5', 911)) then
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := True
      else
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := False;
      end
      else {//} if Vl(FetchElm(RetNo, 'S5', 935)) > 0 then
      begin
      Ret[RetNo].FrmHasData[GetFormNo('S5')] := True;
      end;

      if (Ret[RetNo].FrmHasData[GetFormNo('S5')] = True)
      or (vl(FetchElm(RetNo, 'S5', 618)) > 0) {//20120503} then //20090514
      begin

      Ret[RetNo].FrmHasData[GetFormNo('S5')] := True;
      end;
      end; //MJ
    *)
    // ontario
    if ShouldFileS510(RetNo) then
      Ret[RetNo].FrmHasData[GetFormNo('S510')] := True;

    // amalgamated ont
    FNo := GetFormNo('S524');
    Ret[RetNo].FrmHasData[FNo] := False;
    for i := 4 to 26 do
    begin
      if FetchElmFNo(RetNo, FNo, i) > '' then
      begin
        Ret[RetNo].FrmHasData[FNo] := True;
        Break;
      end;
    end;
    // --------------------  alberta  ---------------------
    if Ret[RetNo].Province = 'AB' then // no reason for s2 factor
    begin
      Ret[RetNo].FrmHasData[GetFormNo('AS2')] := False;
      Ret[RetNo].FrmHasData[GetFormNo('AS2')] := False;
    end;
    if AlbDiffResDed(RetNo) = False then
    begin
      Ret[RetNo].FrmHasData[GetFormNo('AS15')] := False;
    end;

  except
    on E: Exception do
      ExceptMsg(E); // MessageDlg(E.Message, mtError, [mbok], 0);
  end;
end;

procedure InfoOn;
begin

end;

procedure InfoOff;
begin

end;

function RetNoOfSpouse(RetNo: integer; SpouseSin1: string;
  SpouseSin2: string): integer;
var
  i, RNo: integer;
begin
  Result := 0;
  if SpouseSin1 + SpouseSin2 = '' then
    exit;
  for i := 1 to (RetList.Count - 1) do
  begin
    RetRec := RetList.Items[i];
    if RetRec = nil then
      continue;
    RNo := RetRec.RetNo;
    if (RetRec is TRetT2_2027) // 20190831
    // if (RetRec is TRetT2_2020)
      and (Ret[RNo].Frm[1].Strings[3] = SpouseSin2) and
      (Ret[RNo].Frm[1].Strings[4] = SpouseSin1) then
    begin
      Result := RNo;
      exit;
    end;
  end;
end;

function GetNumbFields(FName: string): integer;
begin
  Result := FList.ByFormName(FName).FormFields;
end;

function GetNetInc(RetNo: integer): Real;
begin
  Result := Round(VL(FetchElm(RetNo, 'T2', 214))); //20230810  add Round
end;

function WhichCreditForm(RetNo: integer; ShortPrv: string): string;
begin

  if ShortPrv = 'NL' then
    Result := 'NFTAX'
  else if ShortPrv = 'PE' then
    Result := 'PETAX'
  else if ShortPrv = 'NS' then
    Result := 'NSCR'
  else if ShortPrv = 'NB' then
    Result := 'NBTAX'
  else if ShortPrv = 'QC' then
    Result := ''
  else if ShortPrv = 'ON' then
    Result := 'ONCR_1'
  else if ShortPrv = 'MB' then
    Result := 'MANCR_1'
  else if ShortPrv = 'SK' then
    Result := 'SKTAX'
  else if ShortPrv = 'AB' then
    Result := 'ALTAX'
  else if ShortPrv = 'BC' then
    Result := 'BCCR'
  else if ShortPrv = 'NT' then
    Result := 'NWTAX'
  else if ShortPrv = 'YT' then
    Result := 'YKTAX'
  else if ShortPrv = 'OC' then
    Result := ''
end;

procedure ShowHelp(HelpFile: string; Helptopic: string;
  AIsWeb: Boolean = False); // 20160801 Igor
{ var
  RetCode: LongInt;
  iHelpID: LongInt; }
begin
  if not AIsWeb then // 20160801 Igor
    HelpFile := AppDir + '\' + HelpFile + '.CHM';
  vtDialogs.ShowHelp(HelpFile, Helptopic, AIsWeb); // 20160801 Igor
  // ShellExecute(0, 'open', PWideChar(HelpFile), nil, nil, SW_SHOW); //20160525 Igor //20160801 Igor

  {
    if HtmlHelpInstalled = True then
    begin
    if HelpTopic = 'HELP_CONTENTS' then
    RetCode := HH(0, PChar(HelpFile), HH_DISPLAY_TOPIC, 0)
    else
    RetCode := HH(0, PChar(HelpFile + '::/' + HelpTopic + '.html'), HH_DISPLAY_TOPIC, 0);
    end
    else
    begin
    ShowMessage('Please install at least v4.01 of Internet Explorer before ' +
    'displaying a CHM file');
    end;
  }
end;

function ReformatSin(s: string): string;
begin
  Result := LeftStr(s, 3) + '-' + MidStr(s, 4, 3) + '-' + RightStr(s, 3);
  if Result = '--' then
    Result := '';
end;

function DateToEfileDate(Dt: TDateTime): string;
var
  YYYY, mm, DD, Hour, Min, Sec, Msec: Word;
  SYY, SMM, SDD, SSec: string; // [2];
begin
  DecodeDate(Dt, YYYY, mm, DD);
  DecodeTime(Dt, Hour, Min, Sec, Msec);
  SYY := RightStr(AllTrim(IntTostr(YYYY)), 2);
  SMM := Ltrim(RTrim(IntTostr(mm)));
  SDD := Ltrim(RTrim(IntTostr(DD)));
  SSec := Ltrim(RTrim(IntTostr(Sec)));
  if Length(SMM) = 1 then
    SMM := '0' + SMM;
  if Length(SDD) = 1 then
    SDD := '0' + SDD;
  if Length(SSec) = 1 then
    SSec := '0' + SSec;
  Result := SYY + SMM + SDD;
end;

function MakeEFFileName(LicenseLevel: string): string;
var
  YYYY, mm, DD, Hour, Min, Sec, Msec: Word;
  SMM, SDD, SSec: string; // [2];
begin
  DecodeDate(Now, YYYY, mm, DD);
  DecodeTime(Now, Hour, Min, Sec, Msec);
  SMM := Ltrim(RTrim(IntTostr(mm)));
  SDD := Ltrim(RTrim(IntTostr(DD)));
  SSec := Ltrim(RTrim(IntTostr(Sec)));
  if Length(SMM) = 1 then
    SMM := '0' + SMM;
  if Length(SDD) = 1 then
    SDD := '0' + SDD;
  if Length(SSec) = 1 then
    SSec := '0' + SSec;
  if VL(LicenseLevel) = 3 then
    Result := User.M_Office + SDD + SSec
  else
    Result := SMM + SDD + SSec;
end;

function EditDate(s: string; MnYear, MxYear: integer): Boolean;
{ In form yyyy/mm/dd }
begin
  Result := EditDateYMD(s, MnYear, MxYear, '/');
end;

function EditYYYYMMDate(s: string; MnYear, MxYear: integer): Boolean;
{ In form yyyy/mm/dd }
begin
  Result := EditDateYMD(s, MnYear, MxYear, '/');
end;

function GetOntAllocFirstPart(RetNo: integer; s: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to Length(s) do
    if s[i] = ',' then
    begin
      if i > 1 then
      begin
        Result := LeftStr(s, i - 1);
      end;
    end;
end;

function GetOntAllocString(RetNo: integer): string;
var
  i: integer;
begin
  Result := FormatFloat('###.0000', Ret[RetNo].OntAlloc);
end;

function EditLongPrv(Value: string): Boolean;
var
  i: integer;
begin
  Result := False;
  for i := Low(PrvLong) to High(PrvLong) do
  begin
    if Value = PrvLong[i] then
    begin
      Result := True;
      exit;
    end;
  end;
end;

function GetPrvNdx(SPrv: string): integer;
var
  i: integer;
begin
  Result := 6; { Ontario }
  for i := 1 to High(PrvShort) do
  begin
    if UpperCase(SPrv) = PrvShort[i] then
    begin
      Result := i;
      exit;
    end;
  end;
end;

function GetNewFromDate(ThisYearEnd: string): string;
// 20170728 Igor>>>
// var
// k: integer;
// yyyy, mm, dd: string;
// ADate: TDateTime;
begin
  // ThisYearEnd := YYYYMMDDToWinFormat(ThisYearEnd);
  // ADate := StrToDate(ThisYearEnd);
  // ADate := IncDay(ADate, 1);
  // Result := FormatDateTime('yyyy/mm/dd', ADate);
  Result := FormatDateTime('yyyy/mm/dd', YYYYMMDDTodate(ThisYearEnd));
  // 20170728 Igor<<<
end;

function AdvanceYearEnd(ThisYearEnd: string): string;
var
  k: integer;
  YYYY, mm, DD: string;
begin
  k := MyStrToInt(LeftStr(ThisYearEnd, 4)) + 1;
  Result := IntTostr(k) + MidStr(ThisYearEnd, 5, 6);
  YYYY := LeftStr(Result, 4);
  mm := MidStr(Result, 6, 2);
  DD := RightStr(Result, 2);

  if (not IsLeapYear(MyStrToInt(YYYY))) and (mm = '02') and (DD = '29') then
    Result := LeftStr(Result, 4) + '/02/28';
end;

function GetPrevYearEnd(ThisYearEnd: string; No: integer): string;
{ in as YYYY/mm/dd ? }
var
  k: integer;
  YYYY: integer;
  mmdd: string; // [6];
begin
  YYYY := MyStrToInt(LeftStr(ThisYearEnd, 4));
  k := YYYY - No;
  mmdd := MidStr(ThisYearEnd, 5, 6);
  Result := IntTostr(k) + MidStr(ThisYearEnd, 5, 6);
  if (not IsLeapYear(k)) and (mmdd = '/02/29') then
    Result := IntTostr(k) + '/02/28';
end;

function HowMuchPrvTax(Prv: string; TxblAmount: Real; SBd: Real): Real;
var
  Ndx: integer;
begin
  Ndx := GetPrvNdx('Prv');
  Result := MinR(TxblAmount, SBd) * PrvLowRate[Ndx] / 100 +
    MaxR(0, TxblAmount - SBd) * PrvHighRate[Ndx] / 100;
end;

function GetLowTax(PrvNdx: integer; TxblIncome, PrvAlloc,
  SmBusLimit: Real): Real;
begin

  if PrvNdx = 10 then // BC
  begin
    Result := GetLowBCTax(PrvNdx, TxblIncome, PrvAlloc, SmBusLimit);
    exit;
  end;

  if TxblIncome > 0 then
    Result := MinR(PrvAlloc, SmBusLimit * PrvAlloc / TxblIncome) * PrvLowRate
      [PrvNdx] / 100
  else
    Result := 0;
end;

function GetLowBCTax(PrvNdx: integer;
  TxblIncome, PrvAlloc, SmBusLimit: Real): Real;
begin
  if TxblIncome > 0 then
    Result := MinR(PrvAlloc, SmBusLimit * PrvAlloc / TxblIncome) * PrvLowRate
      [PrvNdx] / 100
  else
    Result := 0;
end;

function GetHighTax(PrvNdx: integer; TxblIncome, PrvAlloc,
  SmBusLimit: Real): Real;
begin

  if PrvNdx = 10 then // BC
  begin
    Result := GetHighBCTax(PrvNdx, TxblIncome, PrvAlloc, SmBusLimit);
    exit;
  end;

  if TxblIncome > 0 then
    Result := MaxR(0, PrvAlloc - SmBusLimit * (PrvAlloc / TxblIncome)) *
      PrvHighRate[PrvNdx] / 100
  else
    Result := 0;
end;

function GetHighBCTax(PrvNdx: integer;
  TxblIncome, PrvAlloc, SmBusLimit: Real): Real;
begin
  if TxblIncome > 0 then
    Result := MaxR(0, PrvAlloc - SmBusLimit * (PrvAlloc / TxblIncome)) *
      PrvHighRate[PrvNdx] / 100
  else
    Result := 0;
end;

function GetLowRate(RetNo: integer; PrvNdx: integer): Real;
begin
  Result := PrvLowRate[PrvNdx];
  // 20110214
  if (PrvNdx = 1) // NL
    and (GetBegYearEnd(RetNo) >= '2010/04/01') then
    Result := 4;
end;

function GetHighRate(RetNo: integer; PrvNdx: integer): Real;
begin
  Result := PrvHighRate[PrvNdx];
end;

function GetLowIncome(RetNo: integer; PrvNdx: integer): Real;
var
  PrvAlloc, SmBusLimit, TxblIncome: Real;
  AllocNdx: integer;
begin
  SmBusLimit := GetIncForSmBusDed(RetNo);
  TxblIncome := GetTxblIncome(RetNo);
  AllocNdx := PrvNdx * 11 - 2; { to point to T2STC PrvAlloc element }
  PrvAlloc := VL(FetchElm(RetNo, 'S5', AllocNdx));
  if TxblIncome > 0 then
    Result := MinR(PrvAlloc, SmBusLimit * PrvAlloc / TxblIncome)
  else
    Result := 0;
end;

function GetHighIncome(RetNo: integer; PrvNdx: integer): Real;
var
  PrvAlloc, SmBusLimit, TxblIncome: Real;
  AllocNdx: integer;
begin
  SmBusLimit := GetIncForSmBusDed(RetNo);
  TxblIncome := GetTxblIncome(RetNo);
  AllocNdx := PrvNdx * 11 - 2; { to point to PrvAlloc element }
  PrvAlloc := VL(FetchElm(RetNo, 'S5', AllocNdx));
  if TxblIncome > 0 then
    Result := MaxR(0, PrvAlloc - SmBusLimit * (PrvAlloc / TxblIncome))
  else
    Result := 0;
end;

function PaddL(s: string; MaxLength: integer): string;
{ put leading blacks/right justify }
begin
  if Length(s) >= MaxLength then
  begin
    Result := s;
    exit;
  end
  else
    Result := Space(MaxLength - Length(s)) + s;
end;

function InsertCommas(s: string): string;
var
  SignPart: string; // [1];
begin
  s := Ltrim(s);
  if LeftStr(s, 1) = '-' then
  begin
    SignPart := '-';
    s := RightStr(s, Length(s) - 1);
  end
  else
    SignPart := '';

  Result := SignPart + s;
  case Length(s) of
    4:
      Result := SignPart + LeftStr(s, 1) + ',' + RightStr(s, 3);
    5:
      Result := SignPart + LeftStr(s, 2) + ',' + RightStr(s, 3);
    6:
      Result := SignPart + LeftStr(s, 3) + ',' + RightStr(s, 3);
    7:
      Result := SignPart + LeftStr(s, 1) + ',' + MidStr(s, 2, 3) + ',' +
        RightStr(s, 3);
    8:
      Result := SignPart + LeftStr(s, 2) + ',' + MidStr(s, 3, 3) + ',' +
        RightStr(s, 3);
    9:
      Result := SignPart + LeftStr(s, 3) + ',' + MidStr(s, 4, 3) + ',' +
        RightStr(s, 3);
    { 10: Result := Leftstr(s,3)+','+MidStr(S,3,3)+','+RightStr(S,3); }
  end;
end;

function ExtractIntegerPart(s: string): string;
var
  i: integer;
  IntegerPart, DecimalPart: string; // [20];
begin
  i := 1;
  while (i <= Length(s)) and not(s[i] = '.') do
    Inc(i);
  Result := LeftStr(s, i - 1); { copy(s[i],1,i-1); }
end;

function ExtractDecimalPart(s: string): string;
var
  i: integer;
begin
  i := Length(s);
  while (i > 0) and not(CharInSet(s[i], ['.'])) do
    Dec(i); // 20150702
  if (i > 0) and (s[i] = '.') then
    Result := Copy(s, i + 1, 255)
  else
    Result := '';
end;

function InsertPenniesDot(s: string): string;
begin
  s := Ltrim(RTrim(s));
  Result := s;
  if MidStr(s, Length(s) - 2, 1) = ' ' then
    Result := Concat(LeftStr(s, Length(s) - 3), '.', RightStr(s, 2));
end;

function RemovePenniesDot(FormName, s: string): string;
begin
  Result := s;
  if FormName = 'INVOICE' then
    exit;
  if MidStr(s, Length(s) - 2, 1) = '.' then
    Result := Concat(LeftStr(s, Length(s) - 3), ' ', RightStr(s, 2));
end;

function GetHowToFormat(FrmName: string; Elm: integer): integer;
begin
  Result := 0; { no decimals }
  if ((FrmName = 'AT1') and ((Elm = 42) or (Elm = 43))) then
    Result := 0;
  if FrmName = 'INVOICE' then
    Result := 2;
end;

// Function FormatAmount(s: string;VerticalSeparator:Boolean): string;

function FormatAmount(FrmNm: string; s: string; How: integer): string;
var
  x: Real; k:integer;
begin
  try
    s := Ltrim(s);
    x := VL(s);

    if FrmNm = 'INVOICE' then
    begin
      Result := FormatFloat('###,###,###.00', x);
      exit;
    end;

    if How = 2 then
    begin
      Result := FormatFloat('###,###,###', x) + '.00'
    end
    else
    begin
      x := Round(x);
      Result := FormatFloat('####,###,###', x);  //20230626 add digit in front
       k:=Pos('.00',result);
       if k>0 then
         result:=Leftstr(result,k);  //20230626
    end;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbok], 0);
  end;
end;

function FormatRSIDollarAmount(FrmNm: string; s: string; How: integer): string;
var
  x: Real; k:Integer;
begin
  try
    s := Ltrim(s);
    x := VL(s);

    if FrmNm = 'INVOICE' then
    begin
      Result := FormatFloat('###,###,###.00', x);
      exit;
    end;

    if How = 2 then
    begin
      x := VL(s);
      Result := FormatFloat('###,###,###', x) + '.00'
    end
    else
    begin
      x := Round(VL(s));
      Result := FormatFloat('####,###,###', x);  //20230626 add digit in front
      k:=Pos('.00',result);
       if k>0 then
         result:=Leftstr(result,k);  //20230626
    end;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbok], 0);
  end;

end;

procedure SwapStrings(S1: string; S2: string);
var
  s: string;
begin
  s := S1;
  S1 := S2;
  S2 := s;
end;

function VL(s: string): Real;
var
  Code: integer;
begin
  if s = '' then
  begin
    Result := 0;
    exit;
  end;
  s := StringReplace(s, ',', '', [rfReplaceAll, rfIgnoreCase]);
  Val(s, Result, Code);
end;

function MyStrToInt(s: string): integer;
begin
  Result := 0;
  try
    if Numeric(s) then
      Result := StrToInt(s)
  except
    ShowMessage(s);
  end;
end;

procedure SetDateFormat;
begin
  {
    DateOrder := doDMY;
    DateSeparator := '-';
    DateFullYear := True;
    DateLeadZero := True;
  }
end;

function FileNameValid(flName: string): Boolean;
var
  i: integer;
begin
  Result := True;
  if (Length(flName) > 50) or (Length(flName) = 0) // 20201015 Igor
    or (Length(ExtractFilePath(flName)) > 0) or
    (Length(ExtractFileExt(flName)) > 7) // 20201015 Igor
    or (LeftStr(flName, 1) = '.') then
    Result := False;
end;

// 20161230 Igor >>>(Move to TUserProfile)
// function GetUserProfile(UserName: string): boolean;
// var
// ADConnection: TADConnection;
// Table1: TADTable;
// (*
// Tm : TDBmemo; {temporary memo}
// Tf : TForm;  {temporary to be parent of Tm}
// *)
// begin
// Result := True;
//
// //20150920 Igor
// ADConnection:= TADConnection.Create(Application);
// Table1 := TADTable.Create(Application);
// SetTableName(ADConnection, Table1, AppDir + '\' + UserDBLite, UserTableLite, 'Name');
//
// if Table1.FindKey([UserName]) = false then
// begin Result := false;
// exit;
// end;
// with Table1 do
// begin
// User.M_Office := FieldByName('M_Office').AsString;
// User.Branch := FieldByName('Branch').AsString;
// User.Prep_Intls := FieldByName('Prep_Intls').AsString;
// User.Login_Id := FieldByName('Login_Id').AsString;
// User.Pswd := FieldByName('Pswd').AsString;
// User.Auth_Level := FieldByName('Auth_Level').AsString;
// User.Inv_No := FieldByName('Inv_No').AsInteger;
// User.Prep_Name := FieldByName('Prep_Name').AsString;
// User.Tax_dir := FieldByName('Tax_dir').AsString;
// User.EFile_Dir := FieldByName('EFile_dir').AsString;
// User.CrProfile := Boolean(FieldByName('Cr_Profile').AsInteger);
// User.CrReturn := Boolean(FieldByName('Cr_Return').AsInteger);
// User.PrReturn := Boolean(FieldByName('Pr_Return').AsInteger);
// User.PrInvoice := Boolean(FieldByName('Pr_Invoice').AsInteger);
// User.PrReport := Boolean(FieldByName('Pr_Report').AsInteger);
// User.MkAppoint := Boolean(FieldByName('Mk_Appoint').AsInteger);
// User.CrRtu := Boolean(FieldByName('Cr_Rtu').AsInteger);
// User.EFile := Boolean(FieldByName('Efile').AsInteger);
// User.Upload := Boolean(FieldByName('Upload').AsInteger);
// User.MkPay := Boolean(FieldByName('Mk_Pay').AsInteger);
// Table1.Free;
// ADConnection.Free;
// end;
// end;
// 20170112 Igor <<<

function CreateDataDirectory(AppDir: string; DataDir: string): integer;
{ return codes
  0 : OK
  -1 : Directory exists
  -2 : Already contains data base
  -3 : Dir cannot be created
  -4 : Cannot copy Data Bases
}
// 20170811 Igor>>>
var
  Err: String;
begin
  if FileExists(DataDir + '\' + ClientsDBLite) then // 20150922 Igor
    exit(-2);
  if SysUtils.DirectoryExists(DataDir) then
    exit(-1);

  { now create and copy data bases }
  if not SysUtils.ForceDirectories(DataDir) then
    exit(-3);

  if not InitDataBase(AppDir, DataDir, Err) then
    exit(-4);

  Result := 0;
  // 20170811 Igor<<<
end;

procedure CreateClientsTable(AConn: TADConnection); // 20201015 Igor
begin
  AConn.ExecSQL(' CREATE TABLE Clients ( ' + sLineBreak +
    '     CORP_NAME  VARCHAR (40), ' + sLineBreak +
    '     FILE_NAME  VARCHAR (50), ' + sLineBreak +
    '     CONTACT    VARCHAR (20), ' + sLineBreak +
    '     AREA       VARCHAR (3), ' + sLineBreak +
    '     PHONE      VARCHAR (7), ' + sLineBreak +
    '     FAX        VARCHAR (7), ' + sLineBreak +
    '     PRP_STATUS VARCHAR (2), ' + sLineBreak +
    '     CREATED_BY VARCHAR (10), ' + sLineBreak +
    '     CREATED_DT VARCHAR (10), ' + sLineBreak +
    '     CREATED_TM VARCHAR (10), ' + sLineBreak +
    '     UPDATED_BY VARCHAR (10), ' + sLineBreak +
    '     UPDATED_DT VARCHAR (10), ' + sLineBreak +
    '     UPDATED_TM VARCHAR (10), ' + sLineBreak +
    '     PRINTED_BY VARCHAR (10), ' + sLineBreak +
    '     PRINTED_DT VARCHAR (10), ' + sLineBreak +
    '     PRINTED_TM VARCHAR (10), ' + sLineBreak +
    '     ACCOUNT    VARCHAR (15), ' + sLineBreak +
    '     STREET     VARCHAR (30), ' + sLineBreak +
    '     CITY       VARCHAR (15), ' + sLineBreak +
    '     PROVINCE   VARCHAR (2), ' + sLineBreak +
    '     POSTAL     VARCHAR (6), ' + sLineBreak +
    '     COUNTRY    VARCHAR (10), ' + sLineBreak +
    '     COMPL_BY   VARCHAR (10), ' + sLineBreak +
    '     COMPL_DT   VARCHAR (10), ' + sLineBreak +
    '     COMPL_TM   VARCHAR (10), ' + sLineBreak +
    '     DUE_DT     VARCHAR (10), ' + sLineBreak +
    '     NOTES      VARCHAR (80), ' + sLineBreak + '     PAY_AMOUNT REAL, ' +
    sLineBreak + '     PAY_INVNO  VARCHAR (13), ' + sLineBreak +
    '     PAY_TYPE   VARCHAR (6), ' + sLineBreak + '     INV_AMOUNT REAL, ' +
    sLineBreak + '     PAY_DT     VARCHAR (10), ' + sLineBreak +
    '     YEAR_END   VARCHAR (10), ' + sLineBreak +
    '     DUE_DATE   VARCHAR (10), ' + sLineBreak +
    '     CORPTYPE   VARCHAR (1) ' + sLineBreak + ' ); ');
  AConn.ExecSQL('CREATE INDEX CORP_NAME ON Clients (CORP_NAME);');
  AConn.ExecSQL('CREATE INDEX DUE_DATE ON Clients (DUE_DATE);');
  AConn.ExecSQL('CREATE INDEX PRP_STATUS ON Clients (PRP_STATUS);');
  AConn.ExecSQL('CREATE UNIQUE INDEX FILE_NAME ON Clients (FILE_NAME);');
end;

procedure UpdateDbStructure; // 20201015 Igor
var
  Conn: TADConnection;
  Q: TADQuery;
begin
  if TFile.Exists(TPath.Combine(OptRec.Dir_Cur, AppT2.ClientsDBLite)) then
  begin
    Conn := TADConnection.Create(Nil);
    Q := TADQuery.Create(Nil);
    try
      Conn.LoginPrompt := False;
      Conn.DriverName := 'SQLite';
      Conn.Params.Values['Database'] := TPath.Combine(OptRec.Dir_Cur,
        AppT2.ClientsDBLite);
      Conn.Params.Values['Password'] := Pswd(GC_SQLLitePasswordVersion, False);
      try
        try
          Conn.Connected := True;
        except
          Conn.Params.Values['Password'] := '';
          Conn.Connected := True;
        end;
        Q.Connection := Conn;
        Q.SQL.Text := 'SELECT * FROM Clients WHERE 1 = 0';
        Q.Open;
        if Assigned(Q.FindField('FILE_NAME')) then
          if Q.FieldByName('FILE_NAME').DataSize < 50 then
          begin
            Conn.ExecSQL('ALTER TABLE Clients RENAME TO Clients_Bak');
            Conn.ExecSQL('DROP INDEX IF EXISTS CORP_NAME');
            Conn.ExecSQL('DROP INDEX IF EXISTS DUE_DATE');
            Conn.ExecSQL('DROP INDEX IF EXISTS PRP_STATUS');
            Conn.ExecSQL('DROP INDEX IF EXISTS FILE_NAME');
            CreateClientsTable(Conn);
            Conn.ExecSQL('INSERT INTO Clients SELECT * FROM Clients_Bak');
            Conn.ExecSQL('DROP TABLE Clients_Bak');
          end;
      except
        ON E: Exception DO
        begin
          Errors.Log(E.Message);
        end;
      end;
    finally
      Q.Free;
      Conn.Free;
    end;
  end;
end;

function InitDataBase(AppDir: string; DataDir: string; out Err: String)
  : Boolean; // 20201015 Igor
var
  Conn: TADConnection;
begin
  if not SysUtils.ForceDirectories(DataDir) then
  begin
    Err := Format('Could not create data directory "%s".' + #13 +
      'Eror message: %s', [DataDir, SysErrorMessage(GetLastError)]);

    exit(False);
  end;
  if not TFile.Exists(TPath.Combine(DataDir, AppT2.ClientsDBLite)) then
  begin
    Conn := TADConnection.Create(Nil);
    try
      Conn.LoginPrompt := False;
      Conn.DriverName := 'SQLite';
      Conn.Params.Values['Database'] :=
        TPath.Combine(DataDir, AppT2.ClientsDBLite);
      Conn.Params.Values['Password'] := Pswd(GC_SQLLitePasswordVersion, False);
      // 20200108 Igor             //AppT1_2026.SQLLitePassword.CurrentPassword;

      try
        Conn.Connected := True;
        CreateClientsTable(Conn); // 20200818 Igor
        Result := True;
      except
        ON E: Exception DO
        begin
          Result := False;
          Errors.Log(E.Message);
        end;
      end;
    finally
      Conn.Free;
    end;
    if not Result AND FileExists(TPath.Combine(DataDir, AppT2.ClientsDBLite))
    then
      try
        TFile.Delete(TPath.Combine(DataDir, AppT2.ClientsDBLite));
      except
      end;
  end
  else
    Result := True;
end;

procedure LoadDataDict;
begin
  if DataDictList = nil then
    DataDictList := TDataDictList.Create;
  DataDictList.Load(AppDir);
end;

function InDataDict(KeyW: string): Boolean;
var
  i: integer;
begin
  KeyW := UpperCase(KeyW);
  // assumed present
  if (LeftStr(KeyW, 5) = 'LINE_') or (LeftStr(KeyW, 5) = 'FORM_') or
    (LeftStr(KeyW, 4) = 'FNUM') or (LeftStr(KeyW, 4) = 'FIMG') then
  begin
    Result := True;
    exit;
  end;

  Result := False;
  for i := 0 to (DataDictList.Count - 1) do
  begin
    DataDictRec := DataDictList.Items[i];
    if KeyW = UpperCase(MidStr(DataDictRec.KeyWord, 1, 100)) then
    begin
      Result := True;
      exit;
    end;
  end;
end;

function GetDataDictFormName(KeyW: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to (DataDictList.Count - 1) do
  begin
    DataDictRec := DataDictList.Items[i];
    if KeyW = MidStr(DataDictRec.KeyWord, 1, 255) then
    begin
      Result := DataDictRec.FormName;
      exit;
    end;
  end;
end;

function GetDataDictElmNo(KeyW: string): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to (DataDictList.Count - 1) do
  begin
    DataDictRec := DataDictList.Items[i];
    if KeyW = MidStr(DataDictRec.KeyWord, 1, 255) then
    begin
      Result := DataDictRec.Field_No;
      exit;
    end;
  end;
end;

function CalcAge(BirthDate: string): integer;
{ birthdate in form dd-mm-yyyy }
begin
  if Length(BirthDate) = 0 then
  begin
    Result := 0;
    exit;
  end;
  Result := AppYearInt - StrToInt(RightStr(BirthDate, 4));
end;

function ClcR(FieldId: integer; PgmValue: Real; FormOvrSw: Boolean;
  RetNo: integer; FormNo: integer): Real;
var
  i: integer;
begin
  if FormOvrSw = False then
    Result := PgmValue
  else
    Result := VL(GetOvrValue(RetNo, FormNo, FieldId));
end;

function InitFormsTable: Boolean;
begin
  Result := FList.InitFormsTable(AppDir, FormsDBLite, FormsTableLite);
  // 20150920 Igor
  if Result then exit; // okay
  AppT2.PrepareDistribution;
  Result := FList.InitFormsTable(AppDir, FormsDBLite, FormsTableLite);
  // 20150920 Igor
  if Result then
    exit; // okay
  UserMsg('Please fix errors in T2 forms');
  Application.Terminate;

end;

procedure ExpandTabs(var AList: TStringList);
// var i,j:integer;TabChar,s:string;
begin
  exit; { ? }
  (*
    TabChar := chr(9);
    for i := 0 to Alist.Count-1 do
    begin
    s := AList[i];
    {Convert tabs to 6 spaces}
    while Pos(TabChar,s) > 0 do
    begin
    j:=Pos(TabChar,s);
    s[j] := ' ';
    s := LeftStr(s,j)+'     '+MidStr(s,j+6,255);
    end;
    end;
  *)
end;

function GetTotalFee(RetNo: integer): Real;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if Ret[RetNo].FrmHasData[FRec.FormNo] then
      if FRec.FormInst > '#1' then
        Result := Result + VL(FRec.FeeAddItem)
      else
        Result := Result + VL(FRec.Fee);
  end;
end;

procedure GetListInvoiceForms(RetNo: integer; var Frms: TStringList;
  var HowMany: TStringList);
var
  i, j: integer;
begin
  { Count non multi-instance forms }
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if (Ret[RetNo].FrmHasData[FRec.FormNo]) and (VL(FRec.Fee) > 0) and
      (FRec.FormInst = '') then
    begin
      Frms.Add(FRec.FormName);
      HowMany.Add('1');
    end;
  end; { Flist do }
  { Count multiple forms, add them to the lists }
  CountMulties(RetNo, Frms, HowMany);
end;

function GetFormFee(FName: string; Qty: integer): Real;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FName = FRec.FormName then
      Result := VL(FRec.Fee) + (Qty - 1) * VL(FRec.FeeAddItem);
  end;
end;

function ABSIfNegative(x: Real): Real;
begin
  if x < 0 then
    Result := ABS(x)
  else
    Result := 0;
end;

procedure GetCurYearLoss(RetNo: integer; Prov: string; var NonCapLoss: Real;
  var FarmLoss: Real; var RestrFarmLoss: Real);
begin
  NonCapLoss := 0;
  FarmLoss := 0;
  RestrFarmLoss := 0;
  if Prov = 'F' then
  begin
    NonCapLoss := ABSIfNegative(VL(FetchElm(RetNo, 'S4', 14))); { cap loss }
    FarmLoss := ABSIfNegative(VL(FetchElm(RetNo, 'S4', 13)));
    RestrFarmLoss := ABSIfNegative(VL(FetchElm(RetNo, 'S4', 206)));
  end
  else if Prov = 'A' then
  begin
    NonCapLoss := ABSIfNegative(VL(FetchElm(RetNo, 'AT2S1', 44))); { cap loss }
    FarmLoss := ABSIfNegative(VL(FetchElm(RetNo, 'AT2S1', 63)));
    RestrFarmLoss := ABSIfNegative(VL(FetchElm(RetNo, 'AT2S1', 64)));
  end;
end;

procedure AllowLinesForLogo(var LetterLines: TStringList);
var
  i: integer;
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  // If OptRec.Prn_Logo then For i :=1 to CfgRec.Prn_LogoLn do Templist.Add('');
  for i := 0 to LetterLines.Count - 1 do
    TempList.Add(LetterLines[i]);
  LetterLines.clear;
  LetterLines.Addstrings(TempList);
  TempList.Free;
end;

function InvalidAmountInLetter(s: string): Boolean;
begin
  Result := False;
  if ((s < '0') or (s > '9')) and (s <> '.') and (s <> ' ') and (s <> '-') and
    (s <> ',') and (s <> '(') and (s <> ')') and (s <> '$') then
    Result := True;
end;

procedure RemoveEmptyLines(var TempList: TStringList);
var
  i: integer;
begin
  i := 0;
  while i < TempList.Count do
  begin
    if Ltrim(RTrim(TempList[i])) = '' then
      TempList.Delete(i)
    else
      Inc(i);
  end;
end;

procedure RemoveLastEmptyLines(var TempList: TStringList);
var
  i: integer;
begin
  i := TempList.Count - 1; { start from bottom }
  while i > 0 do
  begin
    if Ltrim(RTrim(TempList[i])) > '' then
      exit
    else
    begin
      if Ltrim(RTrim(TempList[i])) = '' then
      begin
        TempList.Delete(i);
        Dec(i);
      end
      else
        Dec(i);
    end;
  end;
end;

procedure LoadLetter(var TempList: TStringList; LetterName: string);
var
  i: integer;
begin
  if FileExists(AppDir + '\' + LetterName) then
    TempList.LoadFromFile(AppDir + '\' + LetterName)
  else
    for i := 1 to LetterMxParagraphLines do
      TempList.Add('');
end;

function GetWinIniString(IniFileName: string; Sect: string;
  Ident: string): string;
var
  SomeIniFile: TIniFile;
begin
  SomeIniFile := TIniFile.Create(IniFileName);
  Result := SomeIniFile.ReadString(Sect, Ident, 'Not Found');
  SomeIniFile.Free;
end;

procedure WriteWinIniString(IniFileName: string; Sect: string; Ident: string;
  Val: string);
var
  SomeIniFile: TIniFile;
begin
  SomeIniFile := TIniFile.Create(IniFileName);
  SomeIniFile.WriteString(Sect, Ident, Val);
  SomeIniFile.Free;
end;

// 20070517

// 20170728 Igor>>>
// function MMDDYYYYToWinFormat(Dt: string): string;
// var
// WinDateFormat: string;
// Sep: string; //[1];
// WinBootDir: string;
// begin
// Result := Dt;
// WinDateFormat := UpperCase(FormatSettings.ShortDateFormat); //delphi variable //20150622
// Sep := FormatSettings.DateSeparator; //'/';    //20070517 //20150622
// if LeftStr(WinDateFormat, 1) = 'M' then {to MM/DD/YYYY}
// begin
// //Result := Dt;exit;
// Result := MidStr(Dt, 1, 2) + Sep + midStr(Dt, 4, 2) + Sep + RightStr(Dt, 4);
// end
// else if LeftStr(WinDateFormat, 1) = 'D' then {to DDMMYYYY}
// begin
// Result := MidStr(Dt, 4, 2) + Sep + LeftStr(Dt, 2) + Sep + RightStr(Dt, 4);
// end
// else if LeftStr(WinDateFormat, 1) = 'Y' then {to YYYYMMDD}
// begin
// Result := RightStr(Dt, 4) + Sep + LeftStr(Dt, 2) + Sep + MidStr(Dt, 4, 2);
// end;
// end;
// 20170728 Igor<<<

function TimeToHHMMSS(Dt: TDateTime): string;
var
  Year, Month, Day, Hour, Min, Sec, Msec: Word;
begin
  DecodeDate(Dt, Year, Month, Day);
  DecodeTime(Dt, Hour, Min, Sec, Msec);

  Result := PaddZero(AllTrim(IntTostr(Hour)), 2) +
    PaddZero(AllTrim(IntTostr(Min)), 2) + PaddZero(AllTrim(IntTostr(Sec)), 2);
end;

function TimeToHHMM(Dt: TDateTime): string;
var
  Year, Month, Day, Hour, Min, Sec, Msec: Word;
begin
  DecodeDate(Dt, Year, Month, Day);
  DecodeTime(Dt, Hour, Min, Sec, Msec);
  Result := PaddZero(IntTostr(Hour), 2) + PaddZero(IntTostr(Min), 2);
end;

function GetEfT2FromDate(RetNo: integer): string;
var
  s: string;
begin
  s := FetchElm(RetNo, 'T2', 10);
  Result := RightStr(s, 2) + MidStr(s, 4, 2) + LeftStr(s, 2);
end;

function GetEfT2ToDate(RetNo: integer): string;
var
  s: string;
begin
  s := FetchElm(RetNo, 'T2', 11);
  Result := RightStr(s, 2) + MidStr(s, 4, 2) + LeftStr(s, 2);
end;

function GetEfT2IncorpDate(RetNo: integer): string;
var
  s: string;
begin
  {
    s:= FetchElm(RetNo,'T2',60);
    Result := RightStr(s,2)+MidStr(S,4,2)+LeftStr(s,2);
  }
  Result := ''; { ? }
end;

function GetEfT2AmalgDate(RetNo: integer): string;
var
  s: string;
begin
  Result := ''; { ? }
  {
    s:= FetchElm(RetNo,'T2',63);
    Result := RightStr(s,2)+MidStr(S,4,2)+LeftStr(s,2);
  }
end;

function GetEfT2ControlDate(RetNo: integer): string;
var
  s: string;
begin
  Result := ''; { ? }
  {
    s:= FetchElm(RetNo,'T2',21);
    Result := RightStr(s,2)+MidStr(S,4,2)+LeftStr(s,2);
  }
end;

function GetEfT2CorpType(RetNo: integer): string;
var
  s: string;
begin
  Result := '1';
  if FetchElm(RetNo, 'T2', 51) > '' then
    Result := '1'
  else if FetchElm(RetNo, 'T2', 56) > '' then
    Result := '2'
  else if FetchElm(RetNo, 'T2', 59) > '' then
    Result := '3'
  else if FetchElm(RetNo, 'T2', 52) > '' then
    Result := '4'
  else if FetchElm(RetNo, 'T2', 57) > '' then
    Result := '5';
end;

function EFT2013Date(RetNo: integer; Dt: string): string;
{ used by EFile, date of signature }
begin
  Result := RightStr(Dt, 2) + MidStr(Dt, 4, 2) + LeftStr(Dt, 2);
end;

function DDMMYYYYToEFDate(RetNo: integer; Dt: string): string;
{ used by EFile }
begin
  Result := RightStr(Dt, 2) + MidStr(Dt, 4, 2) + LeftStr(Dt, 2);
end;

function YYYYMMDDToEFDate(RetNo: integer; Dt: string): string;
{ used by EFile for Ontario format }
begin
  Result := LeftStr(Dt, 2) + MidStr(Dt, 5, 2) + RightStr(Dt, 2);
end;

function YYMMDDToEFDate(RetNo: integer; Dt: string): string;
{ used by EFile for Ontario format }
begin
  Result := LeftStr(Dt, 2) + MidStr(Dt, 4, 2) + RightStr(Dt, 2);
end;

function DDMMYYToEFDate(RetNo: integer; Dt: string): string;
{ used by EFile for Ontario format }
begin
  Result := RightStr(Dt, 2) + MidStr(Dt, 4, 2) + LeftStr(Dt, 2);
end;

function DateWithinTaxYear(Dt: string; RetNo: integer): Boolean;
begin
  Result := False;
  if (Dt >= GetBegYearEnd(RetNo)) and (Dt <= GetTaxationYearEnd(RetNo)) then
    Result := True;
end;

function DateWithinDates(Dt, Dt1, Dt2: string): Boolean;
// yyyy/mm/dd
begin
  Result := False;
  if (Dt >= Dt1) and (Dt <= Dt2) then
    Result := True;
end;

procedure OnestepCom;
var
  h: THandle;
  ClickedOK: Boolean;
  EFMethod: string;
begin
  WriteFileForEFCom;
  // h := ShellExecute(MdiHandle, Nil, 'GPCOM.EXE', Nil,
  h := ShellExecute(MainForm.Handle, nil, 'GPCOM.EXE', nil,
    { h := ShellExecute(MainForm.Handle, Nil, 'EFCOM.EXE', Nil, }
    nil, SW_RESTORE);
  if h <= 32 then
  begin
    ShowMessage('Program cannot execute. Error Code = ' + IntTostr(h));
    SelectedString := PopSomeFile(AppDir + '\' + 'SHELLERR.D', 'Error codes');
  end;
end;

procedure WriteFileForEFCom;
var
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  TempList.Add(User.UserName); // 20170112 Igor
  TempList.Add(AppDir);
  TempList.Add(LicenseName);
  TempList.SaveToFile(AppDir + '\' + 'UserData.d');
  TempList.Free;
end;

function GetAdminPswrd(UserName: string): string;
var
  ADConnection: TADConnection;
  Table1: TADTable;
begin
  Result := '';

  // 20150920 Igor
  ADConnection := TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  SetTableName(ADConnection, Table1, AppDir + '\' + UserDBLite,
    UserTableLite, 'Name');

  if Table1.FindKey([UserName]) = True then
    Result := Table1.FieldByName('Pswd').AsString;
  Table1.Free;
  ADConnection.Free;
end;

procedure CalcAllForms(RetNo: integer);
var
  i: integer;
begin
  for i := FList.Count - 1 downto 1 do
  begin
    FRec := FList.Items[i];
    if (Ret[RetNo].FrmHasData[FRec.FormNo]) then
    begin
      // MainForm.TestBtn.caption:=Frec.FormInstName;
      Calc(RetNo, FRec.FormInstName { , FRec.FormNo } );
    end;
  end;
end;

function GetFedCurrYrNonCapLoss(RetNo: integer): Real;
var
  x: Real;
begin
  Result := 0;
  if VL(FetchElm(RetNo, 'S1', 68)) < 0 then
    Result := MaxR(0, ABS(VL(FetchElm(RetNo, 'S1', 68))) -
      ABS(VL(FetchElm(RetNo, 'S1', 71))) - -ABS(VL(FetchElm(RetNo, 'S1', 72))) -
      -ABS(VL(FetchElm(RetNo, 'S1', 73))));
end;

function GetFedCurrYrFarmLoss(RetNo: integer): Real;
var
  x: Real;
begin
  Result := ABS(VL(FetchElm(RetNo, 'S1', 71)));
end;

function GetFedCurrYrRestrFarmLoss(RetNo: integer): Real;
var
  x: Real;
begin
  Result := ABS(VL(FetchElm(RetNo, 'S1', 72)));
end;

function GetFedCurrYrLPPLoss(RetNo: integer): Real;
var
  x: Real;
begin
  Result := ABS(VL(FetchElm(RetNo, 'S6', 535)));
end;

procedure RecalcAllForms(RetNo: integer);
begin
  try
    Calc(RetNo, 'T2');
    CalcAllForms(RetNo);
    CalcFed(RetNo);
    CalcOnt(RetNo);
    CalcAlb(RetNo);
    UpdateAllDataIndicators(RetNo);
    Ret[RetNo].FedCalcStatus := True;
    Ret[RetNo].OntCalcStatus := True;
    Ret[RetNo].AlbCalcStatus := True;
    // MainForm.UpdateTaxPanel;
    Ret[RetNo].Changed := True;
  except
    ShowMessage('Recalculation Problem');
  end;
end;

function GetFedTxblBfrLosses(RetNo, FNo: integer): Real;
var
  i: integer;
  Ded: Real;
begin
  with Ret[RetNo].Frm[FNo] do
  begin
    Ded := 0;
    for i := 15 to 20 do
      Ded := Ded + Tv[i];
    Ded := Ded + Tv[56];
    Ded := Ded + VL(FetchElm(RetNo, 'T2', 226)) + VL(FetchElm(RetNo, 'T2', 228));
    Result := MaxR(0, GetNetInc(RetNo) - Ded);
  end;
end;

function GetBegYearEnd(RetNo: integer): string;
begin
  Result := FetchElm(RetNo, 'T2', 10);
end;

function GetTxblIncome(RetNo: integer): Real;
begin
  Result := Ret[RetNo].Ln[360]; // Vl(FetchElm(RetNo, 'T2', 234));  //20201016
end;

function GetTxblIncomeInAllProv(RetNo: integer): Real;
begin
  Result := GetTxblIncome(RetNo) - VL(FetchElm(RetNo, 'S5', 263)); // MINUS OUTSIDE cANADA
end;

function GetTxblIncomeInProv(RetNo: integer; Prv: string): Real;
begin
  Result := 0;
  if IsTaxExempt(RetNo) then
  begin
    Result := 0;
    exit;
  end; // 20110608
  if Prv = Ret[RetNo].Province then
  begin
    Result := Ret[RetNo].Ln[360]; // Vl(FetchElm(RetNo, 'T2', 234)); //20201016
    exit;
  end;

  if Ret[RetNo].Province = 'MJ' then
  begin
    Result := GetTxblIncomeFromS5(RetNo, Prv);
  end;
end;

function GetTxblIncomeFromS5(RetNo: integer; Prv: string): Real;
begin
  Result := 0;
  if Prv = 'NL' then
    Result := VL(FetchElm(RetNo, 'S5', 109))+VL(FetchElm(RetNo, 'S5', 252)); //20240706
  if Prv = 'PE' then
    Result := VL(FetchElm(RetNo, 'S5', 120));
  if Prv = 'NS' then
    Result := VL(FetchElm(RetNo, 'S5', 131))+VL(FetchElm(RetNo, 'S5', 241));
  if Prv = 'NB' then
    Result := VL(FetchElm(RetNo, 'S5', 142));
  if Prv = 'QC' then
    Result := VL(FetchElm(RetNo, 'S5', 153));
  if Prv = 'ON' then
    Result := VL(FetchElm(RetNo, 'S5', 164));
  if Prv = 'MB' then
    Result := VL(FetchElm(RetNo, 'S5', 175));
  if Prv = 'SK' then
    Result := VL(FetchElm(RetNo, 'S5', 186));
  if Prv = 'AB' then
    Result := VL(FetchElm(RetNo, 'S5', 197));
  if Prv = 'BC' then
    Result := VL(FetchElm(RetNo, 'S5', 208));
  if Prv = 'YT' then
    Result := VL(FetchElm(RetNo, 'S5', 219)); // 20110929
  if Prv = 'NT' then
    Result := VL(FetchElm(RetNo, 'S5', 230));
  if Prv = 'NU' then
    Result := VL(FetchElm(RetNo, 'S5', 281)); // 20130601
  if Prv = 'NO' then
    Result := VL(FetchElm(RetNo, 'S5', 241)); { ns offshore }
  if Prv = 'XO' then
    Result := VL(FetchElm(RetNo, 'S5', 252)); { Nf offsh }
  if Prv = 'OC' then
    Result := VL(FetchElm(RetNo, 'S5', 263));
end;

function GetAlbTxblIncome(RetNo: integer): Real;
begin
  Result := VL(FetchElm(RetNo, 'AT1', 107));
end;

function ReplaceChar(s, Ch1, Ch2: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to Length(s) do
    if s[i] <> Ch1 then
      Result := Result + s[i]
    else
      Result := Result + Ch2;
end;

function IsCorpResident(RetNo: integer): Boolean;
begin
  Result := False;
  if UpperCase(FetchElm(RetNo, 'T2', 48)) = 'X' then
    Result := True;
end;

function IsCorpRelated(RetNo: integer): Boolean;
var
  i: integer;
begin
  Result := False;
  (*
    i:=7;
    repeat
    If FetchElm(RetNo,'S9',i) = '4' then
    begin result := True; Break; end;
    Inc(i,9);
    until i>133;
  *)
end;

function TotAmortOfTangible(RetNo: integer): Real;
var
  i, FNo, Elm: integer;
begin
  // 20160715
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'S125' then // 20160511
    // if Frec.FormName = 'S125#1' then  //20150826
    // if Frec.FormName = 'GIFIIS' then
    begin
      FNo := FRec.FormNo;
      try
        Elm := GifiLineToElm(RetNo, FNo, '8459');
        If Elm > 0 then
          Result := Result + VL(FetchElmFNo(RetNo, FNo, Elm + 1)); // 20160715
        // result := result + Vl(FetchElmFNo(RetNo, FNo, Elm+1));  //20160508

        Elm := GifiLineToElm(RetNo, FNo, '8670');
        If Elm > 0 then
          Result := Result + VL(FetchElmFNo(RetNo, FNo, Elm + 1)); // 20160508

        Elm := GifiLineToElm(RetNo, FNo, '9791');
        If Elm > 0 then
          Result := Result + VL(FetchElmFNo(RetNo, FNo, Elm + 1)); // 20160508
      except
      end;
    end;
  end; { i loop }
end;

function TotAmortOfNatRes(RetNo: integer): Real;
var
  i, FNo, Elm: integer;
const
  FName = 'S125'; // GIFIIS';  //20150826
  // FName = 'GIFIIS';
begin
  Result := 0;
  for i := FList.FirstInstNo(FName) to FList.Count - 1 do
  begin
    FRec := FList.Items[i];
    if FRec.FormName <> FName then
      Break;
    FNo := FRec.FormNo;
    begin
      try
        Elm := GifiLineToElm(RetNo, FNo, '8650');
        If Elm > 0 then
          Result := Result + VL(FetchElmFNo(RetNo, FNo, Elm + 1));
        // 20160508 //20160715

        Elm := GifiLineToElm(RetNo, FNo, '8460');
        If Elm > 0 then
          Result := Result + VL(FetchElmFNo(RetNo, FNo, Elm + 1));
        // 20160508  //20160715
      except
      end;
    end;
  end; { i loop }
end;

function TotAmortOfInTangible(RetNo: integer): Real;
var
  i, FNo, Elm: integer;
const
  FName = 'S125';
  // FName = 'GIFIIS';
begin
  Result := 0;
  for i := FList.FirstInstNo(FName) to FList.Count - 1 do
  begin
    FRec := FList.Items[i];
    if FRec.FormName <> FName then
      Break;
    FNo := FRec.FormNo;
    try
      // 20160715
      Elm := GifiLineToElm(RetNo, FNo, '8570');
      If Elm > 0 then
        Result := Result + VL(FetchElmFNo(RetNo, FNo, Elm + 1)); // 20160508
      Elm := GifiLineToElm(RetNo, FNo, '9832'); // farm related
      If Elm > 0 then
        Result := Result + VL(FetchElmFNo(RetNo, FNo, Elm + 1)); // 20160508
      Elm := GifiLineToElm(RetNo, FNo, '9833'); // farm related
      If Elm > 0 then
        Result := Result + VL(FetchElmFNo(RetNo, FNo, Elm + 1)); // 20160508
    except
    end;
  end; { i loop }

end;

function TotLossInEquity(RetNo: integer): Real;
var
  i, FNo, Elm: integer;
const
  FName = 'S125'; // 'GIFIIS';  //20150826
begin
  Result := 0;
  for i := FList.FirstInstNo(FName) to FList.Count - 1 do
  begin
    FRec := FList.Items[i];
    if FRec.FormName <> FName then
      Break;
    FNo := FRec.FormNo;
    try
      Elm := GifiLineToElm(RetNo, FNo, '8232');
      If Elm > 0 then
        Result := Result + VL(FetchElmFNo(RetNo, FNo, Elm + 1));
      // 20160508  //20160715
    except
    end;
  end; { i loop }

end;

function TotGainLossOnDisposal(RetNo: integer): Real;
var
  i, FNo, Elm: integer;
const
  FName = 'S125'; // 'GIFIIS'; //20150826
begin
  Result := 0;
  for i := FList.FirstInstNo(FName) to FList.Count - 1 do
  begin
    FRec := FList.Items[i];
    if FRec.FormName <> FName then
      Break;
    FNo := FRec.FormNo;
    try
      // 20160715
      Elm := GifiLineToElm(RetNo, FNo, '8210');
      If Elm > 0 then
        Result := Result + VL(FetchElmFNo(RetNo, FNo, Elm + 1)); // 20160508

      Elm := GifiLineToElm(RetNo, FNo, '8211');
      If Elm > 0 then
        Result := Result + VL(FetchElmFNo(RetNo, FNo, Elm + 1)); // 20160508

      Elm := GifiLineToElm(RetNo, FNo, '8212');
      If Elm > 0 then
        Result := Result + VL(FetchElmFNo(RetNo, FNo, Elm + 1)); // 20160508

      Elm := GifiLineToElm(RetNo, FNo, '9609');
      If Elm > 0 then
        Result := Result + VL(FetchElmFNo(RetNo, FNo, Elm + 1)); // 20160508
    except
    end;
  end; { i loop }

end;

function TotISNetInc(RetNo: integer): Real;
var
  i, FNo: integer;
begin
  Result := 0;
  try
    Result := TotMultiple(RetNo, 'S125', 89) + TotMultiple(RetNo, 'S125', 35);
    // 20150826
    // Result := TotGifiMultiple(RetNo, 'GIFIIS', '9369') + TotGifiMultiple(RetNo, 'GIFIIS', '9899');
  except
  end;
end;

function GetTotNetPrvTaxes(RetNo: integer): Real;
begin
  Result := 0;
  Result := VL(FetchElm(RetNo, 'S5', 935));
end;

function GetPrvTaxBfrCredits(RetNo: integer; ProvJurisd: string;
  SomeProv: string): Real;
begin
  Result := 0;
  if IsTaxExempt(RetNo) then
    exit;
  if SomeProv = ProvJurisd then
  begin
    Result := GetLowTax(GetPrvNdx(SomeProv), GetTxblIncome(RetNo),
      GetTxblIncome(RetNo), GetIncForSmBusDed(RetNo)) +
      GetHighTax(GetPrvNdx(SomeProv), GetTxblIncome(RetNo),
      GetTxblIncome(RetNo), GetIncForSmBusDed(RetNo));
    if SomeProv = 'BC' then
      Result := VL(FetchElm(RetNo, 'S427', 25));
    if SomeProv = 'PE' then
      Result := VL(FetchElm(RetNo, 'S322', 34)); // 20150924
    If SomeProv = 'NL' then
      Result := VL(FetchElm(RetNo, 'S307', 21)); // 20141030
    If SomeProv = 'NU' then
      Result := VL(FetchElm(RetNo, 'S481', 18)); // 20201019
    exit;
  end;
  if ProvJurisd = 'MJ' then
  begin
    if SomeProv = 'NL' then
      Result := VL(FetchElm(RetNo, 'S5', 111)) + VL(FetchElm(RetNo, 'S5', 113))
    else if SomeProv = 'PE' then
      Result :=VL(FetchElm(RetNo, 'S322', 34))  // 2026725
       // VL(FetchElm(RetNo, 'S5', 122)) + VL(FetchElm(RetNo, 'S5', 124))
    else if SomeProv = 'NS' then
      Result := VL(FetchElm(RetNo, 'S5', 133)) + VL(FetchElm(RetNo, 'S5', 135))
    else if SomeProv = 'NB' then
      Result := VL(FetchElm(RetNo, 'S5', 144)) + VL(FetchElm(RetNo, 'S5', 146))
    else if SomeProv = 'MB' then
      Result := VL(FetchElm(RetNo, 'S5', 177)) + VL(FetchElm(RetNo, 'S5', 179))
    else if SomeProv = 'SK' then
      Result := VL(FetchElm(RetNo, 'S5', 188)) + VL(FetchElm(RetNo, 'S5', 190))
    else if SomeProv = 'BC' then
      Result := VL(FetchElm(RetNo, 'S5', 210)) + VL(FetchElm(RetNo, 'S5', 212))
        + VL(FetchElm(RetNo, 'S5', 214))
    else if SomeProv = 'YT' then
      Result := VL(FetchElm(RetNo, 'S5', 221)) + VL(FetchElm(RetNo, 'S5', 223))
    else if SomeProv = 'NT' then
      Result := VL(FetchElm(RetNo, 'S5', 232)) + VL(FetchElm(RetNo, 'S5', 234))
    else if SomeProv = 'NU' then
      Result := VL(FetchElm(RetNo, 'S5', 283)) + VL(FetchElm(RetNo, 'S5', 285));
  end;
end;

(*
  procedure ConvertS60(RetNo: Integer; FName: string; FNo: Integer; Fld: Integer; Valu: string);
  var
  I: Integer;
  begin
  if (Fld >= 4) and (Fld <= 33) then
  begin StoreElm(RetNo, FNo, Fld, Valu);
  Exit;
  end;
  if (Fld >= 34) and (Fld <= 39) then
  begin StoreElm(RetNo, FNo, Fld, Valu);
  Exit;
  end;
  if (Fld >= 64) and (Fld <= 103) then
  begin StoreElm(RetNo, FNo, Fld, Valu);
  Exit;
  end;
  if (Fld >= 40) and (Fld <= 45) then
  begin StoreElm(RetNo, FNo, Fld + 64, Valu);
  Exit;
  end;
  if (Fld >= 46) and (Fld <= 51) then
  begin StoreElm(RetNo, FNo, Fld + 85, Valu);
  Exit;
  end;
  if (Fld >= 52) and (Fld <= 57) then
  begin StoreElm(RetNo, FNo, Fld + 106, Valu);
  Exit;
  end;
  if (Fld >= 58) and (Fld <= 63) then
  begin StoreElm(RetNo, FNo, Fld + 127, Valu);
  Exit;
  end;
  end;
*)

procedure Filter2000Release1AndStore(RetNo: integer; FormNm: string;
  FNo: integer; Elm: integer; Valu: string);
var
  NewFNo, NewElm: integer;
begin
  if (LeftStr(FormNm, 3) <> 'OPG') then
  begin
    StoreElm(RetNo, FNo, Elm, Valu);
    exit;
  end;

  NewFNo := FNo;
  NewElm := Elm;

  if NewFNo > 0 then
    if Ret[RetNo].Frm[NewFNo].Count = 0 then
      InitFormData(RetNo, NewFNo);

  if (NewFNo > 0) and (NewElm > 0) then
    StoreElm(RetNo, NewFNo, NewElm, Valu); { once }
end;

function RemoveNonNumericChars(s: string): string;
var
  i: integer;
begin
  s := RemoveChar(s, '-');
  s := RemoveChar(s, '(');
  s := RemoveChar(s, ')');
  s := RemoveChar(s, ' ');
  Result := s;
end;

function RemoveChar(s: string; Ch: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to Length(s) do
    if s[i] <> Ch then
      Result := Result + s[i];
end;

function ValidBusNumber(RetNo: integer; BN: string): Boolean;
var
  i: integer;
begin
  Result := True;
  if LeftStr(BN, 1) = '0' then
  begin
    Result := False;
    exit;
  end;
  if (Length(BN) <> 15) then
  begin
    Result := False;
    exit;
  end;
  if (UpperCase(BN[10] + BN[11]) <> 'RC') and (UpperCase(BN[10] + BN[11]) <> 'RZ') and (UpperCase(BN[10] + BN[11]) <> 'RU') then // 20250625 Igor
  begin
    Result := False;
    exit;
  end;

  for i := 1 to 9 do
    if not Numeric(BN[i]) then
    begin
      Result := False;
      exit;
    end;

  for i := 12 to 15 do
    if not Numeric(BN[i]) then
    begin
      Result := False;
      exit;
    end;

  if ValidSin(LeftStr(BN, 9)) = False then
  begin
    Result := False;
    exit;
  end;
end;

function ValidPartnershipNumber(RetNo: integer; BN: string): Boolean;
var
  i: integer;
begin
  Result := True;
  if LeftStr(BN, 1) = '0' then
  begin
    Result := False;
    exit;
  end;
  if (Length(BN) <> 15) then
  begin
    Result := False;
    exit;
  end;
  if UpperCase(BN[10] + BN[11]) <> 'RZ' then
  begin
    Result := False;
    exit;
  end;

  for i := 1 to 9 do
    if not Numeric(BN[i]) then
    begin
      Result := False;
      exit;
    end;

  for i := 12 to 15 do
    if not Numeric(BN[i]) then
    begin
      Result := False;
      exit;
    end;

  if ValidSin(LeftStr(BN, 9)) = False then
  begin
    Result := False;
    exit;
  end;
end;

function PrintAListing(FileNm, Hdr1, Hdr2, Hdr3: string): Boolean;
var
  i, LineCnt, MxLinesPerPage, PageCnt: integer;
  PrnFile: TextFile;
  { TempList:TstringList; }
  XPos: LongInt;
  PageX, PageY: LongInt;
  ScMult: integer;
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
  XPos := 30;
  ScMult := 10;
  PageX := Printer.PageWidth;
  PageY := Printer.PageHeight;
  ScaleX := (PageX * ScMult) div 614; { to get the decimals }
  ScaleY := (PageY * ScMult) div 1000; { formheight }

  repeat
    if (FirstTimeSw) or (LineCnt > MxLinesPerPage) then
    begin { print headers }
      LineCnt := 1;
      Inc(PageCnt);
      if not FirstTimeSw then
        Printer.NewPage;

      Printer.Canvas.Font.Name := 'Arial';
      Printer.Canvas.Font.Size := 10;
      Printer.Canvas.Font.Style := [fsBold];
      Printer.Canvas.TextOut((XPos * ScaleX) div ScMult, (LineCnt * 15 * ScaleY)
        div ScMult, Hdr1 + ' Page: ' + IntTostr(PageCnt));

      Inc(LineCnt); { leave empty line }
      Printer.Canvas.Font.Name := 'Courier New';
      Printer.Canvas.Font.Size := 8;
      Printer.Canvas.Font.Style := [fsBold];
      Inc(LineCnt);
      Printer.Canvas.TextOut((XPos * ScaleX) div ScMult, (LineCnt * 15 * ScaleY)
        div ScMult, Hdr2);

      Inc(LineCnt);
      Printer.Canvas.TextOut((XPos * ScaleX) div ScMult, (LineCnt * 15 * ScaleY)
        div ScMult, Hdr3);
      Inc(LineCnt, 1);
    end; { headers }
    FirstTimeSw := False;
    Printer.Canvas.Font.Style := [];
    Readln(F1, s);
    Printer.Canvas.TextOut((XPos * ScaleX) div ScMult, (LineCnt * 15 * ScaleY)
      div ScMult, s);
    Inc(LineCnt);
  until Eof(F1);
  CloseFile(F1);
  Printer.EndDoc;
  Result := True;
end;

function GetGrossRevenue(RetNo: integer): Real;
begin
  Result := TotMultiple(RetNo, 'S125', 14) + TotMultiple(RetNo, 'S125', 29);
  // 20150826
  // Result := TotGifiMultiple(RetNo, 'GIFIIS', '8299') + TotGifiMultiple(RetNo, 'GIFIIS', '9659');
end;

function RoundToThousands(rn: Real): Real;
var
  x: Real;
begin
  x := Frac(rn / 1000);
  if x < 0.500 then
    Result := Trunc(rn / 1000) * 1000
  else
    Result := Trunc((rn + 1000) / 1000) * 1000
end;

function GetAlbAccNo(RetNo: integer): string;
begin
  Result := FetchElm(RetNo, 'AT1', 9);
end;

function GetMaxItcClaim(RetNo: integer; Avlbl: Real; PropType: string): Real;
var
  i, Pg7FNo: integer;
  OthCredits: Real;
begin
  Pg7FNo := GetFormNo('T2');
  OthCredits := 0;
  for i := 624 to 627 do
    OthCredits := OthCredits + Round(VL(FetchElmFNo(RetNo, Pg7FNo, i)));
  for i := 629 to 633 do // 20160609  //for i := 629 to 632 do
    OthCredits := OthCredits + Round(VL(FetchElmFNo(RetNo, Pg7FNo, i)));
  for i := 644 to 645 do
    OthCredits := OthCredits + Round(VL(FetchElmFNo(RetNo, Pg7FNo, i)));
  OthCredits := OthCredits + Round(VL(FetchElmFNo(RetNo, Pg7FNo, 635))) +
    Round(VL(FetchElmFNo(RetNo, Pg7FNo, 638)));

  if PropType = 'AP' then // apprecticeship
  begin
    Result := MinR(MaxR(0, Round(VL(FetchElmFNo(RetNo, Pg7FNo, 623))) -
      OthCredits), Round(Avlbl)); // bfr credits
    exit;
  end;

  if PropType = 'RD' then
  begin
    OthCredits := OthCredits + Round(VL(FetchElm(RetNo, 'S31', 251)));
    // from reg prop
    // 20100501
    OthCredits := OthCredits + Round(VL(FetchElm(RetNo, 'S31', 1465)));
    // from reg prop
    OthCredits := OthCredits + Round(VL(FetchElm(RetNo, 'S31', 1466)));
    // from reg prop
    OthCredits := OthCredits + Round(VL(FetchElm(RetNo, 'S31', 1416)));
    // from reg prop

  end;
  Result := MinR(MaxR(0, Round(VL(FetchElmFNo(RetNo, Pg7FNo, 623))) -
    OthCredits), Round(Avlbl)); // bfr credits
end;

function GetOntAlloc(RetNo: integer): Real;
// Var X1,X2,TotSal,TotRev:Real;
begin
  if Ret[RetNo].Province = 'ON' then
  begin
    Result := 100;
    Ret[RetNo].OntAlloc := Result;
    exit;
  end;
  Result := VL(FetchElm(RetNo, 'OS5', 28));
end;

function GetAlbAlloc(RetNo: integer): Real;
var
  X1, X2, TotSal, TotRev: Real;
begin
  if Ret[RetNo].Province = 'AB' then
  begin
    Result := 100;
    exit;
  end;
  TotSal := VL(FetchElm(RetNo, 'S5', 270));
  if TotSal > 0 then
    X1 := VL(FetchElm(RetNo, 'S5', 193)) / TotSal
  else
    X1 := 0;
  TotRev := VL(FetchElm(RetNo, 'S5', 272));
  if TotRev > 0 then
    X2 := VL(FetchElm(RetNo, 'S5', 195)) / TotRev
  else
    X2 := 0;
  if (TotSal = 0) or (TotRev = 0) then
    Result := 100 * (X1 + X2)
  else
    Result := 100 * (X1 + X2) / 2;
end;

function GetAlbAllocationFactor(RetNo: integer): string;
begin
  Result := FetchElm(RetNo, 'AS2', 9); { 402 general allocation }
  (*
    If (SalariesOutsideCanada=0)
    or (RevenueOutsideCanada=0) then
    OneOrHalf:=1
    else
    OneOrHalf:=0.50;
  *)
  { special categories }

  if FetchElm(RetNo, 'AS2', 25) > '' then { 409 }
    Result := FetchElm(RetNo, 'AS2', 14)

  else if FetchElm(RetNo, 'AS2', 26) > '' then { 408 }
    Result := FetchElm(RetNo, 'AS2', 19)

  else if FetchElm(RetNo, 'AS2', 27) > '' then { 411 }
    Result := FetchElm(RetNo, 'AS2', 24)

  else if FetchElm(RetNo, 'AS2', 134) > '' then { 403 }
    Result := FetchElm(RetNo, 'AS2', 104)
  else if FetchElm(RetNo, 'AS2', 137) > '' then { 404 }
    Result := FetchElm(RetNo, 'AS2', 109)
  else if FetchElm(RetNo, 'AS2', 138) > '' then { 405 }
    Result := FetchElm(RetNo, 'AS2', 112)
  else if FetchElm(RetNo, 'AS2', 139) > '' then { 407 }
    Result := FetchElm(RetNo, 'AS2', 117)
  else if FetchElm(RetNo, 'AS2', 140) > '' then { 406 }
    Result := FetchElm(RetNo, 'AS2', 122)
  else if FetchElm(RetNo, 'AS2', 141) > '' then { 410 }
    Result := FetchElm(RetNo, 'AS2', 131)
  else if FetchElm(RetNo, 'AS2', 142) > '' then { 412 }
    Result := FetchElm(RetNo, 'AS2', 135);
end;

function GetAlbAllocationFactorForS1(RetNo: integer): string;
var
  SalariesOutsideCanada, RevenueOutsideCanada: Real;
  OneOrHalf: Real;
begin
  Result := GetAlbAllocationFactor(RetNo);
  SalariesOutsideCanada := VL(FetchElm(RetNo, 'S5', 259));
  RevenueOutsideCanada := VL(FetchElm(RetNo, 'S5', 261));
  if (SalariesOutsideCanada = 0) and (RevenueOutsideCanada = 0) then
    exit;

  { from AS1 }
  { 402 general allocation }

  if FetchElm(RetNo, 'S5', 104) = '402' then
    Result := FormatFloat('##0.000000',
      (1 / 2) * CalcAlbFactor(VL(FetchElm(RetNo, 'AS2', 5)),
      VL(FetchElm(RetNo, 'AS2', 6)) - SalariesOutsideCanada,
      VL(FetchElm(RetNo, 'AS2', 7)), VL(FetchElm(RetNo, 'AS2', 8)) -
      RevenueOutsideCanada))

    { other special cases }
  else if FetchElm(RetNo, 'AS2', 25) > '' then { 409 }
    Result := FormatFloat('##0.000000',
      (1 / 2) * CalcAlbFactor(VL(FetchElm(RetNo, 'AS2', 10)),
      VL(FetchElm(RetNo, 'AS2', 11)) - SalariesOutsideCanada,
      VL(FetchElm(RetNo, 'AS2', 12)), VL(FetchElm(RetNo, 'AS2', 13))))

  else if FetchElm(RetNo, 'AS2', 26) > '' then { 408 }
    Result := FormatFloat('##0.000000',
      (1 / 2) * CalcAlbFactor(VL(FetchElm(RetNo, 'AS2', 15)),
      VL(FetchElm(RetNo, 'AS2', 16)) - SalariesOutsideCanada,
      VL(FetchElm(RetNo, 'AS2', 17)), VL(FetchElm(RetNo, 'AS2', 18))))

  else if FetchElm(RetNo, 'AS2', 27) > '' then { 411 }
    Result := FormatFloat('##0.000000',
      (1 / 2) * CalcAlbFactor(VL(FetchElm(RetNo, 'AS2', 20)),
      VL(FetchElm(RetNo, 'AS2', 21)) - SalariesOutsideCanada,
      VL(FetchElm(RetNo, 'AS2', 22)), VL(FetchElm(RetNo, 'AS2', 23))))

  else if FetchElm(RetNo, 'AS2', 134) > '' then { 403 }
    Result := FormatFloat('##0.000000',
      CalcAlbFactor(0, 0, VL(FetchElm(RetNo, 'AS2', 102)),
      VL(FetchElm(RetNo, 'AS2', 103))))

  else if FetchElm(RetNo, 'AS2', 137) > '' then { 404 }
    Result := FormatFloat('##0.000000',
      (1 / 3) * CalcAlbFactor(VL(FetchElm(RetNo, 'AS2', 105)),
      VL(FetchElm(RetNo, 'AS2', 106)) - SalariesOutsideCanada,
      2 * VL(FetchElm(RetNo, 'AS2', 107)), VL(FetchElm(RetNo, 'AS2', 108))))

  else if FetchElm(RetNo, 'AS2', 138) > '' then { 405 }
    Result := FormatFloat('##0.000000',
      CalcAlbFactor(0, 0, VL(FetchElm(RetNo, 'AS2', 110)),
      VL(FetchElm(RetNo, 'AS2', 111)) - RevenueOutsideCanada))
  else
    Result := GetAlbAllocationFactor(RetNo);

end;

procedure ParseWords(s: string; Delim: string; var WList: TStringList);
var
  i, FromI, ToI: integer;
  Wrd: string;
begin
  s := AllTrim(s);
  WList.clear;
  if s = '' then
    exit;
  i := 1;
  FromI := 1;
  ToI := Length(s);
  repeat
    if (i > ToI) or (s[i] = Delim) then
    begin
      Wrd := MidStr(s, FromI, i - FromI);
      WList.Add(Wrd);
      FromI := i + 1;
      Inc(i);
      if (FromI > ToI) or (i > ToI) then
        Break;
    end
    else
      Inc(i);
  until i > ToI + 1;
end;

procedure ParseAddress(s: string; Delim: string; var WList: TStringList);
var
  i, k, FromI, ToI: integer;
  Wrd: string;
  TempList: TStringList;
begin
  ParseWords(s, Delim, WList);
  if WList.Count < 6 then
  begin
    k := 6 - WList.Count;
    for i := 1 to k do
      WList.Add(' ');
  end;
  { may end up with 2 entries, but want 5: Str, Str,City,Prov,Country,Postal }
  { 0 str ,
    1 City,
    2 Prov,
    3 Postal is on the string, max 4 entries }

  TempList := TStringList.Create;
  for i := 1 to 6 do
    TempList.Add(' ');
  TempList[0] := WList[0]; { Str }
  TempList[1] := ' '; { Str }
  TempList[2] := WList[1]; { City }
  TempList[3] := WList[2]; { Prov }
  TempList[4] := ' '; { country }
  TempList[5] := WList[3]; { Postal }
  { back to wlist }
  for i := 0 to TempList.Count - 1 do
    WList[i] := TempList[i];
  TempList.Free;
end;

function DoubleWordSeparators(s: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to Length(s) do
  begin
    if s[i] <> ' ' then
      Result := Result + s[i]
    else
      Result := Result + s[i] + ' ';
  end;
end;

function DoubleSpaced(s: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to Length(s) do
    Result := Result + s[i] + ' ';

end;

function AlbDiffInc(RetNo: integer): Boolean;
begin
  Result := False;
  if UpperCase(FetchElm(RetNo, 'AS12', 45)) = 'Y' then
    Result := True;
end;

function AlbDiffCCA(RetNo: integer): Boolean;
begin
  Result := False;
  if UpperCase(FetchElm(RetNo, 'AS13#1', 3)) = 'Y' then
    Result := True;
end;

function AlbDiffCEC(RetNo: integer): Boolean;
begin
  Result := False;
  if UpperCase(FetchElm(RetNo, 'AS14', 21)) = 'Y' then
    Result := True;
end;

function AlbDiffResDed(RetNo: integer): Boolean;
begin
  Result := False;
  if UpperCase(FetchElm(RetNo, 'AS15', 3)) = 'Y' then
    Result := True;
end;

function AlbDiffSRD(RetNo: integer): Boolean;
begin
  Result := False;
  if UpperCase(FetchElm(RetNo, 'AS16', 14)) = 'Y' then
    Result := True;
end;

function AlbDiffReserves(RetNo: integer): Boolean;
begin
  Result := False;
  if UpperCase(FetchElm(RetNo, 'AS17', 34)) = 'Y' then
    Result := True;
end;

function AlbDiffCapDisp(RetNo: integer): Boolean;
begin
  Result := False;
  if UpperCase(FetchElm(RetNo, 'AS18', 3)) = 'Y' then
    Result := True;
end;

function AlbDiffResourceData(RetNo: integer): Boolean;
begin
  Result := False;
  if UpperCase(FetchElm(RetNo, 'AS51', 5)) = 'Y' then
    Result := True;
end;

function AlbDiffDon(RetNo: integer): Boolean;
begin
  Result := False;
  if UpperCase(FetchElm(RetNo, 'AS20', 22)) = 'Y' then
    Result := True;
end;

function AlbDiffLoss(RetNo: integer): Boolean;
begin
  Result := False;
  if UpperCase(FetchElm(RetNo, 'AS21', 28)) = 'Y' then
    Result := True;
end;

function AlbDiffAdjubi(RetNo: integer): Boolean;
begin
  Result := False;
  if UpperCase(FetchElm(RetNo, 'AS12', 125)) = 'X' then
    Result := True;
end;

function GetCorpBusNo(RetNo: integer): string;
begin
  Result := FetchElm(RetNo, 'T2', 1);
end;

function GetClientLettersDir: string;
var
  Dir: string;
begin
  Dir := OptRec.Dir_Cur + '\' + 'ClientLetters';
  if not SysUtils.DirectoryExists(Dir) then // 20150702
  begin
    if not CreateDir(Dir) then
      raise Exception.Create('Cannot create letters directory ' + Dir);
  end;
  Result := Dir;
end;

function MkClientLetterName(RetNo: integer): string;
begin
  Result := GetCorpName(RetNo) + '.' + 'RTF';
end;

function GetPositionInList(s: string; AlistBox: TFileListBox): integer;
{ return item index of a given string }
var
  i: integer;
begin
  Result := -1;
  for i := 0 to AlistBox.Items.Count - 1 do
    if s = AlistBox.Items[i] then
    begin
      Result := i;
      exit;
    end;
end;

procedure ResolveConditions(var AList: TStringList);
var
  i, Place: integer;
  errorC: Boolean;
  NetList: TStringList;
  KeyW: string;
  Size: Word;
  Buffer, WorkBuffer: PChar;
  CheckKey: Boolean;
  LineNum: LongInt;
  ConditionStr: string;
  CheckCondition: Boolean;
  exchange: string;
  j, k, L, M: integer;
  MaxLine: integer;
  f: TextFile;
  s: string;
begin
  { now Condition interpret }
  NetList := TStringList.Create;
  errorC := False;
  MaxLine := AList.Count;
  { Replace condition lines }
  i := 0;
  repeat
    Place := pos('#If#', AList[i]);
    if Place = 0 then { no If statement }
    begin
      NetList.Add(AList[i]);
      { Inc(i); }
    end
    else
    begin
      LineNum := i; { lineNum has the If statement }
      s := MidStr(AList[LineNum], Place, 255);
      ConditionEvaluator(s, CheckCondition, errorC);
      if errorC = True then
        exit;

      { If condition is true }
      if CheckCondition = True then
      begin
        j := 1; { j counts the lines after a true if }
        while (pos('#Else#', AList[LineNum + j]) = 0)
        { (MidStr(AList[LineNum+J],6,6)<>'#Else#') }
          and (pos('#Endif#', AList[LineNum + j]) = 0) and
          (LineNum + j < MaxLine) do
          j := j + 1;

        for k := 1 to j - 1 do
          NetList.Add(AList[LineNum + k]); { copy lines after If }

        if (pos('#Else#', AList[LineNum + j]) > 0)
        { MidStr(AList[LineNum+J],6,6)='#Else#' } then { after else }
        begin
          L := j + 1;
          while (pos('#Endif#', AList[LineNum + L]) = 0)
          { (MidStr(AList[LineNum+L],6,7)<>'#Endif#') }
            and (LineNum + L < MaxLine) do
            L := L + 1;
        end
        else
          L := j;
        i := i + L;
      end;

      if CheckCondition = False then
      begin
        j := 1; { j counts the lines after a false if }
        while (pos('#Else#', AList[LineNum + j]) = 0)
        { (MidStr(AList[LineNum+J],6,6)<>'#Else#') }
          and (pos('#Endif#', AList[LineNum + j]) = 0)
        { (MidStr(AList[LineNum+J],6,7)<>'#Endif#') }
          and (LineNum + j < MaxLine) do
          j := j + 1;

        if (pos('#Endif#', AList[LineNum + j]) > 0)
        { MidStr(AList[LineNum+J],6,7)='#Endif#' } then
          L := j
        else
        begin
          L := j + 1;
          while (pos('#Endif#', AList[LineNum + L]) = 0)
          { (MidStr(AList[LineNum+L],6,7)<>'#Endif#') }
            and (LineNum + L < MaxLine) do
            L := L + 1;
          for k := j + 1 to L - 1 do
            NetList.Add(AList[LineNum + k]);
        end;
        i := i + L;
      end;
    end;
    Inc(i); { ? }
  until i > MaxLine - 1;
  AList.clear;
  for i := 0 to NetList.Count - 1 do
    AList.Add(NetList[i]);
  NetList.Free;
end;

procedure InterpretTextLine(RetNo: integer; var Txt: string);
var
  i, Size: integer;
  KeyW: string;
  OrdKeyW: integer;
  j, L: integer;
  s: string;
  FrmNm: string;
  ElmNo: integer;
  ReplaceString: string;
  KeyWLength, Cursor_position, LineNumber: integer;
begin
  Txt := RTrim(Txt) + ' '; { one space to allow for logic }
  Size := Length(Txt) + 1;
  KeyW := '';
  i := 1;
  repeat
    if Txt[i] = KeyWDelimiter1 then
    begin
      Cursor_position := i;
      i := i + 1;
      while (Txt[i] <> KeyWDelimiter2) and (i < Size) do
      begin
        KeyW := KeyW + Txt[i];
        i := i + 1;
      end;

      if (InDataDict(KeyW)) and (KeyW <> 'If') and (KeyW <> 'Else') and
        (KeyW <> 'Endif') and (KeyW <> 'Date') and (KeyW <> 'This_TaxYear') and
        (KeyW <> 'Next_TaxYear') and (LeftStr(KeyW, 5) <> 'Line_') then
      begin
        FrmNm := GetDataDictFormName(KeyW);
        ElmNo := GetDataDictElmNo(KeyW);
        KeyWLength := Length(KeyW);
        if IsKeyWAnAmount(KeyW) then
        begin
          FormatSettings.DecimalSeparator := '.'; // 20150622
          ReplaceString :=
            AllTrim(FloatToStrF(VL(FetchElm(RetNo, FrmNm, ElmNo)),
            ffNumber, 15, 2));
          InsertPenniesDot(ReplaceString);
        end
        else
          ReplaceString := FetchElm(RetNo, FrmNm, ElmNo);
        ReplaceKeyWord(Txt, Cursor_position, KeyWLength, ReplaceString);
      end
      else if LeftStr(KeyW, 5) = 'Line_' then
      begin { Replace Line Number }
        KeyWLength := Length(KeyW);
        LineNumber := 0; // 20150702
        if KeyWLength = 8 then
          LineNumber := StrToInt(RightStr(KeyW, 3));

        if KeyWLength = 9 then
          LineNumber := StrToInt(RightStr(KeyW, 4));

        FormatSettings.DecimalSeparator := '.'; // 20150622
        ReplaceString := FloatToStrF(Ret[RetNo].Ln[LineNumber],
          ffNumber, 15, 2);
        InsertPenniesDot(ReplaceString);
        ReplaceKeyWord(Txt, Cursor_position, KeyWLength, ReplaceString);
      end
      else
      begin
        { Replace reserved keyword }
        KeyWLength := Length(KeyW);
        if KeyW = 'Date' then
          ReplaceString := DateToMonthDayYear(Date)
        else if KeyW = 'This_TaxYear' then
          ReplaceString := AppYear
        else if KeyW = 'Next_TaxYear' then
          ReplaceString := IntTostr(AppYearInt + 1)
        else
          ReplaceString := '#' + KeyW + '#';
        ReplaceKeyWord(Txt, Cursor_position, KeyWLength, ReplaceString);
      end;
      KeyW := '';
      i := Cursor_position + Length(ReplaceString);
      Size := Size - KeyWLength + Length(ReplaceString);
    end
    else { no keyword }
      if i > Size then
        exit;
    Inc(i); { ? }
  until i > Size;
end;

function ValidateTextLine(Txt: string; var Cursor_position: integer;
  var KeyWLength: integer): Boolean;
var
  i, Size: integer;
  KeyW: string;
  OrdKeyW: integer;
  j, L: integer;
  s: string;
begin
  Result := False;
  Txt := Ltrim(RTrim(Txt)) + ' '; { one space to allow for logic }
  Size := Length(Txt);

  KeyW := '';
  i := 1;
  repeat
    {
      for i := 1 to size do
      begin }
    if Txt[i] = KeyWDelimiter1 then
    begin
      Cursor_position := i;
      i := i + 1;
      while (Txt[i] <> KeyWDelimiter2) and (Txt[i] <> '.') and (i < Size) do
      begin
        KeyW := KeyW + Txt[i];
        i := i + 1;
      end;

      if (InDataDict(KeyW) = False) and (LeftStr(KeyW, 5) <> 'Line_') then
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
        if (StrToInt(s) < LnLowBound) or (StrToInt(s) > LnHighBound) then
        begin
          { Line number out of limit }
          { ShowMessage('Line Number Out Of Bound'); }
          KeyWLength := Length(KeyW);
          exit;
        end;
      end;
      KeyW := '';
    end;
    Inc(i);
  until i > Size;
  Result := True;
end;

procedure ReplaceKeyWord(var Txt: string; Cursor_position: integer;
  KeyWLength: integer; ReplaceString: string);
begin
  Txt := LeftStr(Txt, Cursor_position - 1) + ReplaceString +
    MidStr(Txt, Cursor_position + KeyWLength + 2, 255);
end;

procedure ConditionEvaluator(CStr: string; var CCheck: Boolean;
  var error: Boolean);
{ cstring comes as: #If#  -12000.00 > 0 then }
var
  n1, n2: Real;
  i, Count: integer;
  nstr, temp: string;
  great, less, eql: Boolean;
  t1, t2: Boolean;
  cand, cor: Boolean;
  j, N1StartsAt, N2StartsAt: integer;
begin
  { remove leading spaces before the amount }
  temp := AllTrim(MidStr(CStr, 5, 255));
  temp := AllTrim(temp);
  if (LeftStr(temp, 1) = '<') or (LeftStr(temp, 1) = '>') or
    (LeftStr(temp, 1) = '=') then { null value came }
    temp := '0 ' + temp;
  CStr := LeftStr(CStr, 4) + temp;

  error := False;
  i := 5;
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
  repeat
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
      i := Count + 1;
      Count := Length(CStr);
      if nstr = '' then
        n1 := 0
      else
        n1 := VL(nstr);
      { StrToFloat(nstr); } { Vl(FormatAmount(nstr)); } { no commas }
      nstr := '';
    end;
    Inc(Count);
  until Count > j;
  { end; }
  { get > < position }
  Count := i;
  repeat
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
      i := Count;
      Count := Length(CStr);
    end;
    Inc(Count);
  until Count > j;

  { get second amount }
  if CStr[i + 1] = ' ' then
    N2StartsAt := i + 2
  else
    N2StartsAt := i + 1;
  Count := N2StartsAt;
  repeat
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
      i := Count;
      Count := Length(CStr);
      n2 := VL(nstr);
      { StrToFloat(Ltrim(nstr)); } { Vl(FormatAmount(nStr)); {no commas }
      nstr := '';
    end;
    Inc(Count);
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

procedure ReplaceText(LetterBody: TMemo; Cursor_position: integer;
  KeyWLength: Byte; ReplaceText: string);
var
  i, j, k, PosReturn, SkipChars: integer;
begin
  with LetterBody do
  begin
    SelStart := Cursor_position - 1;
    SelLength := KeyWLength + 1;
    SelText := ReplaceText;
  end;
end;

function GetFileDate(TheFileName: string): string;
var
  FHandle: integer;
begin
  FHandle := FileOpen(TheFileName, 0);
  try
    Result := FormatDateTime('yyyy-mm-dd',
      FileDateToDateTime(FileGetDate(FHandle)));
    { Result := DateTimeToStr(FileDateToDateTime(FileGetDate(FHandle))); }
  finally
    FileClose(FHandle);
  end;
end;

function IsKeyWAnAmount(KeyW: string): Boolean;
begin
  Result := False;
  if (UpperCase(KeyW) = 'FEDERAL_OWING') or
    (UpperCase(KeyW) = 'FEDERAL_PAYABLE') or
    (UpperCase(KeyW) = 'FEDERAL_REFUND')

    or (UpperCase(KeyW) = 'ONTARIO_OWING') or
    (UpperCase(KeyW) = 'ONTARIO_PAYABLE') or
    (UpperCase(KeyW) = 'ONTARIO_REFUND')

    or (UpperCase(KeyW) = 'ALBERTA_OWING') or
    (UpperCase(KeyW) = 'ALBERTA_PAYABLE') or (UpperCase(KeyW) = 'ALBERTA_REFUND')
  then
    Result := True;
end;

function IsCreditUnion(RetNo: integer): Boolean;
begin
  Result := False;
  if FetchElm(RetNo, 'T2', 62) = 'Credit Union' then
    Result := True;
end;

function IsFedFnclInstitution(RetNo: integer): Boolean;
var
  s: string;
begin
  Result := False;
  s := FetchElm(RetNo, 'T2', 62);
  if (s = 'Financial Institution') or (s = 'Credit Union') or
    (s = 'Investment Corporation')
  { or (s = 'Non-resident Owned Investment Corp.') }
    or (s = 'Bank') or (s = 'Trust or Loan Corporation')
  { or (s = 'Co-operative Corporation') }
    or (s = 'Mutual Fund Corporation') or (s = 'Life Insurance Corporation') or
    (s = 'Insurance Corporation') then
    Result := True;
end;

function IsBankCorp(RetNo: integer): Boolean;
begin
  Result := False;
  if FetchElm(RetNo, 'T2', 62) = 'Bank' then
    Result := True;
end;

function IsTrustOrLoanCorp(RetNo: integer): Boolean;
begin
  Result := False;
  if FetchElm(RetNo, 'T2', 62) = 'Trust or Loan Corporation' then
    Result := True;
end;

function IsCooperativeCorp(RetNo: integer): Boolean;
begin
  Result := False;
  if FetchElm(RetNo, 'T2', 62) = 'Co-operative Corporation' then
    Result := True;
end;

function IsNonResidentInvestmentCorp(RetNo: integer): Boolean;
begin
  Result := False;
  if FetchElm(RetNo, 'T2', 62) = 'Non-resident Owned Investment Corp.' then
    Result := True;
end;

function IsInvestmentCorp(RetNo: integer): Boolean;
begin
  Result := False;
  if FetchElm(RetNo, 'T2', 62) = 'Investment Corporation' then
    Result := True;
end;

function IsMutualFundCorp(RetNo: integer): Boolean;
begin
  Result := False;
  if FetchElm(RetNo, 'T2', 62) = 'Mutual Fund Corporation' then
    Result := True;
end;

function IsInsuranceCorp(RetNo: integer): Boolean;
begin
  Result := False;
  if (FetchElm(RetNo, 'T2', 62) = 'Insurance Corporation') or
    (FetchElm(RetNo, 'T2', 62) = 'Life Insurance Corporation') then
    Result := True;
end;

function IsOntFnclInstitution(RetNo: integer): Boolean;
begin
  Result := False;
  if (FetchElm(RetNo, 'S524', 6) > '') or { Mortg invstm }
    (FetchElm(RetNo, 'S524', 7) > '') or { crdt Union }
    (FetchElm(RetNo, 'S524', 8) > '') or { bank mortg subsid }
    (FetchElm(RetNo, 'S524', 9) > '') or { banks }
    (FetchElm(RetNo, 'S524', 10) > '') or { loan and trust }
    (FetchElm(RetNo, 'S524', 17) > '') or { mutual fund }
    (FetchElm(RetNo, 'S524', 11) > '') { fncl inst by reg } then
    Result := True;
end;

function IsOntExemptFromCapitalTax(RetNo: integer): Boolean;
begin
  Result := False;
  if (FetchElm(RetNo, 'S524', 4) > '') // family farm
    or (FetchElm(RetNo, 'S524', 5) > '') { family fish }
    or (FetchElm(RetNo, 'S524', 7) > '') { credit union }
  // or (FetchElm(RetNo,'S524',?) >'') or {deposit insurance}
    or (IsTaxExempt(RetNo)) then
    Result := True;
end;

function ConvertToPixelsX(x: Real; PixPerInX: integer): integer;
begin
  Result := Trunc(x * PixPerInX);
end;

function ConvertToPixelsY(Y: Real; PixPerInY: integer): integer;
begin
  Result := Trunc(Y * PixPerInY);
end;

procedure CopySalariesToOS5(RetNo: integer; OntFName: string);
var
  FedFno, OntFNo: integer;
  x: Real;
begin
  FedFno := GetFormNo('S5');
  OntFNo := GetFormNo(UpperCase(OntFName));
  { Salaries }
  StoreElm(RetNo, OntFNo, 4, FetchElmFNo(RetNo, FedFno, 204)); { BC }
  StoreElm(RetNo, OntFNo, 9, FetchElmFNo(RetNo, FedFno, 193)); { ab }
  StoreElm(RetNo, OntFNo, 14, FetchElmFNo(RetNo, FedFno, 182)); { sk }
  StoreElm(RetNo, OntFNo, 19, FetchElmFNo(RetNo, FedFno, 171)); { mb }
  StoreElm(RetNo, OntFNo, 24, FetchElmFNo(RetNo, FedFno, 160)); { on }
  StoreElm(RetNo, OntFNo, 29, FetchElmFNo(RetNo, FedFno, 149)); { qc }
  StoreElm(RetNo, OntFNo, 34, FetchElmFNo(RetNo, FedFno, 138)); { nb }
  x := VL(FetchElmFNo(RetNo, FedFno, 27)) + VL(FetchElmFNo(RetNo, FedFno, 237));
  { ns/offs }
  StoreElm(RetNo, OntFNo, 39, FormatFloat('#########.##', x)); { ns }
  StoreElm(RetNo, OntFNo, 44, FetchElmFNo(RetNo, FedFno, 116)); { pe }
  x := VL(FetchElmFNo(RetNo, FedFno, 5)) + VL(FetchElmFNo(RetNo, FedFno, 248));
  // nf offsh
  StoreElm(RetNo, OntFNo, 49, FormatFloat('#########.##', x)); { nf }
  StoreElm(RetNo, OntFNo, 54, FetchElmFNo(RetNo, FedFno, 226)); { nw }
  StoreElm(RetNo, OntFNo, 59, FetchElmFNo(RetNo, FedFno, 215)); { yk }
  StoreElm(RetNo, OntFNo, 64, FetchElmFNo(RetNo, FedFno, 277)); { nu }
  StoreElm(RetNo, OntFNo, 69, FetchElmFNo(RetNo, FedFno, 259)); { outside }
end;

procedure CopyRevenuesToOS5(RetNo: integer; OntFName: string);
var
  FedFno, OntFNo: integer;
  x: Real;
begin
  FedFno := GetFormNo('S5');
  OntFNo := GetFormNo(UpperCase(OntFName));

  StoreElm(RetNo, OntFNo, 6, FetchElmFNo(RetNo, FedFno, 206)); { BC }
  StoreElm(RetNo, OntFNo, 11, FetchElmFNo(RetNo, FedFno, 195)); { ab }
  StoreElm(RetNo, OntFNo, 16, FetchElmFNo(RetNo, FedFno, 184)); { sk }
  StoreElm(RetNo, OntFNo, 21, FetchElmFNo(RetNo, FedFno, 173)); { mb }
  StoreElm(RetNo, OntFNo, 26, FetchElmFNo(RetNo, FedFno, 162)); { on }
  StoreElm(RetNo, OntFNo, 31, FetchElmFNo(RetNo, FedFno, 151)); { qc }
  StoreElm(RetNo, OntFNo, 36, FetchElmFNo(RetNo, FedFno, 140)); { nb }
  x := VL(FetchElmFNo(RetNo, FedFno, 29)) + VL(FetchElmFNo(RetNo, FedFno, 239));
  StoreElm(RetNo, OntFNo, 41, FormatFloat('#########.##', x));
  // FetchElmFNo(RetNo,FedFNo,29)); {ns}
  StoreElm(RetNo, OntFNo, 46, FetchElmFNo(RetNo, FedFno, 118)); { pe }
  x := VL(FetchElmFNo(RetNo, FedFno, 7)) +
    VL(FetchElmFNo(RetNo, FedFno, 250)); { nf }
  StoreElm(RetNo, OntFNo, 51, FormatFloat('#########.##', x));
  // FetchElmFNo(RetNo,FedFNo,7)); {nf}
  StoreElm(RetNo, OntFNo, 56, FetchElmFNo(RetNo, FedFno, 228)); { nw }
  StoreElm(RetNo, OntFNo, 61, FetchElmFNo(RetNo, FedFno, 217)); { yk }
  StoreElm(RetNo, OntFNo, 66, FetchElmFNo(RetNo, FedFno, 279)); { nu }
  StoreElm(RetNo, OntFNo, 71, FetchElmFNo(RetNo, FedFno, 261)); { outside }
end;

procedure GifiISToTreeview;
var
  i: integer;
  TempList: TStringList;
  ADConnection: TADConnection;
  Table1: TADTable;
begin
  TempList := TStringList.Create;

  // 20150922 Igor
  ADConnection := TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  SetTableName(ADConnection, Table1, AppDir + '\' + GiFiisDBLite,
    GiFiisTableLite, '');

  Table1.First;
  with Table1 do
  begin

    repeat
      if AllTrim(FieldByName('Parent').AsString) = '' then
        TempList.Add(FieldByName('LineNo').AsString + ' ' +
          FieldByName('Descr').AsString)
      else
      begin
        {
          IndexFieldNames := 'LINENO';
          if Table1.FindKey([Frec.FormName]) then
        }
        TempList.Add(' ' + FieldByName('LineNo').AsString + ' ' +
          FieldByName('Descr').AsString)
      end;
      Next;
    until Table1.Eof;
  end;
  TempList.SaveToFile(AppDir + '\' + 'GIFIIS.D');
  Table1.Close;
  Table1.Free;
  ADConnection.Free;
  TempList.Free;
end;

function GetOntRate(RetNo: integer): Real;
var
  D1, D2, D3: integer;
begin
  { Result := 15.5; }
  D1 := GetNumDays(RetNo, '02-05-2000', 'B');
  D2 := GetNumDays(RetNo, '01-05-2000', 'A') -
    GetNumDays(RetNo, '31-12-2000', 'A');
  D3 := GetNumDays(RetNo, '31-12-2000', 'A');
  Result := (D1 * 15.5 + D2 * 14.5 + D3 * 14) / Ret[RetNo].DaysInYear;
end;

function CheckGainsBreak(RetNo: integer; FName: string;
  TotalElm, P1Elm, P2Elm: integer; P3Elm: integer): Boolean;
begin
  Result := True;
  if VL(FetchElm(RetNo, FName, TotalElm)) <> VL(FetchElm(RetNo, FName, P1Elm)) +
    VL(FetchElm(RetNo, FName, P2Elm)) + VL(FetchElm(RetNo, FName, P3Elm)) then
    Result := False;
end;

function CurrentYearIsLeap(RetNo: integer): Boolean;
begin
  Result := False;
  if IsLeapYear(GetTaxationYearEndYYYY(RetNo)) then
    Result := True;
end;

function WhichPeriod(DispDate: string): integer;
begin
  if DispDate = '' then
  begin
    Result := 3;
    exit;
  end;
  Result := 3;
  if DispDate < '2000/02/28' then
    Result := 1;
  if (DispDate > '2000/02/27') and (DispDate < '2000/10/18') then
    Result := 2;
end;

function IsLeapYear(Yr: integer): Boolean;
begin
  { Result := False; }
  Result := (Yr mod 4) = 0;
  { if (Yr = 1988)
    or (Yr = 1992)
    or (Yr = 1996)
    or (Yr = 2000)
    or (Yr = 2004)
    or (Yr = 2008)
    or (Yr = 2012)
    or (Yr = 2016) then
    result := True; }
end;

function isLeapDayWithinReturnDateRange(RetNo: integer): Boolean;
var
  startYear, endYear : integer;
  startDate, endDate : integer;//: string;
  d: integer;
begin
  result := false;

  startYear := GetTaxationYearStartYYYY(RetNo);
  endYear   := GetTaxationYearEndYYYY(RetNo);

  if startYear = endYear then
  begin
    if IsLeapYear(endYear) then
      result := true;
  end
  else
  begin

    startDate := strtoint(StringReplace(GetTaxationYearStart(RetNo), '/', '',[rfReplaceAll]));
    endDate   := strtoint(StringReplace(GetTaxationYearEnd(RetNo)  , '/', '',[rfReplaceAll]));
    //startDate := GetTaxationYearStart(RetNo);
    //endDate   := GetTaxationYearEnd(RetNo);

    d := strtoint(inttostr(startYear) + '0229');
    if startDate < d then
    begin
      if IsLeapYear(endYear) then
        result := true;
    end;

    d := strtoint(inttostr(endYear) + '0229');
    if d < endDate then
    begin
      if IsLeapYear(endYear) then
        result := true;
    end;

  end;

//GetTaxationYearEnd(RetNo: integer): string;
//GetTaxationYearStart(RetNo: integer): string;
//GetTaxationYearEndYYYY(RetNo: integer): integer;
//GetTaxationYearStartYYYY(RetNo: integer): integer;

end;



function GetBusLimitOfAssoc(RetNo: integer): Real;
var
  i, FNo: integer;
begin
  Result := 0;
  FNo := GetFormNo('S23');
  i := 16;
  repeat
    Result := Result + VL(FetchElmFNo(RetNo, FNo, i));
    Inc(i, 6);
  until i > 124;
end;

function TotGifiMultiple(RetNo: integer; NonInstFormName: string;
  GifiLine: string): Real; { No Instance }
var
  i, FNo, Elm: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = NonInstFormName then
    begin
      FNo := FRec.FormNo;
      if Ret[RetNo].FrmHasData[FNo] then
      begin
        try
          Elm := GifiLineToElm(RetNo, FNo, GifiLine);
          if (Elm > 0) and (FNo > 0) then
            // Try
            Result := Result + VL(FetchElmFNo(RetNo, FNo, Elm + 1)); // 20160425
          // Result := Result + Vl(FetchElmFNo(RetNo, Fno, Elm));
          // except
          // end;
        except
        end;
      end; // has data
    end; // right form
  end; // i
end;

procedure GetExplGifiList(GifiId: string; ParentLine: string;
  var ExplodedList: TStringList);
var
  i, j: integer;
  s: string;
  GifiLines: TStringList;
  ADConnection: TADConnection;
  Table1: TADTable;
begin
  ExplodedList.clear;

  // 20150922 Igor
  ADConnection := TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);

  if GifiId = 'BS' then
    SetTableName(ADConnection, Table1, AppDir + '\' + GiFibsDBLite,
      GiFibsTableLite, '') // 20150922 Igor
  else if GifiId = 'IS' then
    SetTableName(ADConnection, Table1, AppDir + '\' + GiFiisDBLite,
      GiFiisTableLite, ''); // 20150922 Igor

  Table1.Open; { Table1.IndexName := 'FORMNAME'; }
  with Table1 do
  begin
    First;
    repeat
      if AllTrim(FieldByName('Parent').AsString) = AllTrim(ParentLine) then
        ExplodedList.Add(FieldByName('LineNo').AsString);
      Next;
    until Table1.Eof;
  end;
  Table1.Close;
  Table1.Free;
  ADConnection.Free;
end;

function MkRsiAmountRec(RetNo: integer; Ln: string; FName: string; FNo: integer;
  RsiElm: integer): string;
// var ElmStr: string; //insert into the spec
begin
  Result := Space(1) + PaddR(Ln, 12) + PaddR(FName, 8) +
    PaddR(AllTrim(IntTostr(RsiElm)), 41) + '$'; // 20160402
  {
    ElmStr := IntToStr(Elm);
    Result := Space(1) + PaddR(Ln, 12) + PaddR(FName, 8) +
    PaddR(ElmStr, 41) + '$';  //20160402
    // PaddR(ElmStr, 38) + '$     1-13';   //20160402
  }
end;

(*
  function MkRSIAmountRec(RetNo: Integer; Ln: string; FName: string; FNo: Integer): string;
  var
  ElmStr: string; //insert into the spec
  begin
  ElmStr := AllTrim(IntToStr(GifiLineToElm(RetNo, FNo, Ln)));
  Result := Space(1) + PaddR(Ln, 12) + PaddR(FName, 8) +
  PaddR(ElmStr, 41) + '$';  //20160402
  // PaddR(ElmStr, 38) + '$     1-13';   //20160402
  end;
*)
(*
  //20160402  New for handling dynamic form Efiling
  function MkDynamicRSIAmountRec(RetNo: Integer; Ln: string; FName: string; FNo: Integer; RsiElm:Integer): string;
  //var  ElmStr: string; //insert into the spec   //20160402
  begin
  //ElmStr := AllTrim(IntToStr(GifiLineToElm(RetNo, FNo, Ln)));
  Result := Space(1) + PaddR(Ln, 12) + PaddR(FName, 8) +
  PaddR(AllTrim(IntToStr(RsiElm)), 41) + '$';  //20160402
  // PaddR(ElmStr, 38) + '$     1-13';   //20160402
  end;
*)

function MkEFileNotesRec(RetNo: integer; FName: string; FNo: integer;
  ElmStr: string): string;
const
  Ln = '0001'; // ln='0000';
begin
  Result := Space(1) + PaddR(Ln, 12) + PaddR(FName, 8) + PaddR(ElmStr, 41) +
    'AN'; // 20160402
  // Result := Space(1) + PaddR(Ln, 12) + PaddR(FName, 8) + PaddR(ElmStr, 38) + 'AN'; //20090713
end;

// 20160402  It seems it is not used!  I should delete
function MkEFileAmountRec(RetNo: integer; Ln: string; FName: string;
  FNo: integer): string;
var
  ElmStr: string;
begin
  ElmStr := AllTrim(IntTostr(GifiLineToElm(RetNo, FNo, Ln)));
  Result := PaddR(Ln, 13) + PaddR(FName, 8) + PaddR(ElmStr, 41) + '$' +
    Space(10) + 'FD TIA    200' // 20160402
  // Result := PaddR(Ln, 13) + PaddR(FName, 8) + PaddR(ElmStr, 38) + '$' + Space(10) + 'FD TIA    200'
end;

function FindWord(ThisWord, Ln: string): integer;
var
  Place: integer;
begin
  Result := pos(UpperCase(ThisWord), UpperCase(Ln));
end;

function FetchGifiElm(RetNo: integer; FName: string; Ln: string): string;
var
  i, FNo, Elm: integer;
begin
  Result := '';
  FNo := GetFormNo(FName);
  try
    Elm := GifiLineToElm(RetNo, FNo, Ln);
    if Elm > 0 then
      Result := FetchElmFNo(RetNo, FNo, Elm + 1);
    // 20150825 the column after the elm
  except
  end;
end;

(*
  //20150824
  function S100LineToElm(RetNo: Integer; FNo:Integer; Ln: string): Integer;
  var  i: Integer;
  begin
  Result:=0;
  i:=10002;
  Repeat
  if FetchElmFNo(RetNo,FNo,i)=Ln  then
  begin
  result:=i;
  Exit;
  end;
  Inc(i,10000);  //array by array
  Until i>70002;

  {
  if SplitDynId(RetNo, FNo, elm) then
  begin
  with RetList[RetNo].Frm[FNo] do
  while i <= MaxElm+ArrayNo*10000 do
  begin
  //If S100LineShouldBeNegative(Strings[i-1],Strings[i]) then Strings[i]:='-'+Strings[i];
  //If S100LineShouldBeNegative(Strings[i-1],Strings[i+1]) then Strings[i+1]:='-'+Strings[i+1];
  inc(i, BoxesPerRow);
  end;
  end;
  }
  end;
*)

// 20150824
function GifiLineToElm(RetNo: integer; FNo: integer; Ln: string): integer;
// used only for pre-populated gifi statements (not empty ones)
// if finds the elm of an existing gifi line in the statement
var
  i, j, LnInt: integer;
  k: Boolean;
begin
  // this should work for both S100 and S125 for dynamic rows only
  // it is finding the Elm number of the rows in the second coluimn of S100, and S125
  // once the elm is found then the value of the current year column can be picked up by FetchElm(RetNo,Fname,Elm+1)

  Result := 0;
  // for fixed lines of dynamic forms: fetch them directly from the form as the elm is known
  if not Assigned(RetList[RetNo]) or not Assigned(RetList[RetNo].Frm[FNo]) then
    exit; // 20160710 Igor

  // for Dynamic array Lines of a form loop through all arrays as shown below

  with RetList[RetNo].Frm[FNo] do
  begin
    i := 10002; // starting elm of the 'Line' coumn
    if not SplitDynId(RetNo, FNo, i) then
      exit; // begin ShowMessage('Not a dynamic Elm in GIFILineToElm = '+IntToStr(i));Exit;end; //initial splitDynId
    Repeat
      if not SplitDynId(RetNo, FNo, i) then
        exit; // exit if not dynamic  //this routine establishes arrayNo, MaxElm, etc
      while DynElmIdx <= MaxElm do
      begin
        If Dyn[ArrayNo, DynElmIdx] = Ln then
        begin
          Result := ArrayNo * 10000 + DynElmIdx;
          exit;
        end;
        Inc(DynElmIdx, BoxesPerRow);
      end;
      Inc(i, 10000); // go to the next array
      if not SplitDynId(RetNo, FNo, i) then
        exit; // needed again otherwise it does not go to the next array
    Until i > MaxElm + ArrayNo * 10000 + 2;
  end; // RetList

  { OLD D5 GIFI
    Result := 0;
    if FNo = 0 then exit;
    if FNo > FormsLimit then  exit;
    i := 1;
    repeat
    if FetchElmFNo(RetNo, FNo, i) = Ln then
    begin
    result := i + 1;
    exit;
    end;
    Inc(i, 2);
    until i > Ret[RetNo].Frm[Fno].Count - 1;
  }
end;

function FetchGifiElmFNo(RetNo: integer; FNo: integer; Ln: string): string;
var
  i, Elm: integer;
begin
  Result := '';
  try
    Elm := GifiLineToElm(RetNo, FNo, Ln);
    if Elm > 0 then
      Result := FetchElmFNo(RetNo, FNo, Elm + 1);
    // value of of column  //20150825
  except
  end;
end;

procedure StoreGifiElm(RetNo: integer; FNo: integer; Ln: string; Valu: string);
var
  Elm: integer;
begin
  if FNo = 0 then
    exit;
  Elm := GifiLineToElm(RetNo, FNo, Ln);
  if Elm > Ret[RetNo].Frm[FNo].Count - 1 then
    exit
  else
    Ret[RetNo].Frm[FNo].Strings[Elm + 1] := AllTrim(Valu); // 20150825
end;

function ReformatBN(BN: string): string;
var
  s: string;
begin
  Result := BN;
  if Length(Result) <> 15 then
    exit;
  Result := UpperCase(LeftStr(BN, 5) + ' ' + MidStr(BN, 6, 4) + ' RC ' +
    RightStr(BN, 4));
end;

function BeyondMaxYearEnd(RetNo: integer): Boolean;
begin
  Result := False;
  if GetTaxationYearEnd(RetNo) > MaxEndPeriod then
  begin
    ShowMessage('This program version prints returns with Y/E up to ' +
      MaxEndPeriod);
    Result := True;
  end;
end;

function GetGifiValFromMem(RetNo: integer; FNo: integer; Ln: string): string;
var
  i: integer;
begin
  Result := '';
  i := 1;
  repeat
    if FetchElmFNo(RetNo, FNo, i) = Ln then
      try
        begin
          Result := FetchElmFNo(RetNo, FNo, i + 1);
          exit;
        end;
      except
      end;
    Inc(i, 2);
  until i > Ret[RetNo].Frm[FNo].Count - 1;
end;

function GetFastPrintIndicator: Boolean;
var
  TempList: TStringList;
  s: string;
begin
  Result := False;
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir + '\' + 'OthOpt.D');
  s := TempList[1];
  if UpperCase(s[30]) = 'Y' then
    Result := True;
  TempList.Free;
end;

function AlbDiffS6(RetNo: integer): Boolean;
begin
  Result := False;
  if UpperCase(FetchElm(RetNo, 'ACAPD', 254)) = 'Y' then
    Result := True;
end;

function FetchInclusionRateString(RetNo: integer): string;
begin
  Result := '0.50'; // FetchElm(RetNo,'S6_5',11);
end;

function FetchOntInclusionRateString(RetNo: integer): string;
begin
  Result := '50';
end;

function FetchAlbInclusionRateString(RetNo: integer): string;
begin
  Result := '0.50'; // FetchElm(RetNo,'ACAPD_5',11);
end;

function GetTxblIncomeForOntSurtax(RetNo: integer): Real;
begin
  Result := 200000 * (GetNumDays(RetNo, '01-01-2001', 'B') / Ret[RetNo]
    .DaysInYear) + 240000 * (GetNumDays(RetNo, '31-12-2000', 'A') /
    Ret[RetNo].DaysInYear);

end;

function GetFullMonth(mm: string): string;
begin
  Result := '?????';
  if mm = '01' then
    Result := 'January'
  else if mm = '02' then
    Result := 'February'
  else if mm = '03' then
    Result := 'March'
  else if mm = '04' then
    Result := 'April'
  else if mm = '05' then
    Result := 'May'
  else if mm = '06' then
    Result := 'June'
  else if mm = '07' then
    Result := 'July'
  else if mm = '08' then
    Result := 'August'
  else if mm = '09' then
    Result := 'September'
  else if mm = '10' then
    Result := 'October'
  else if mm = '11' then
    Result := 'November'
  else if mm = '12' then
    Result := 'December';
end;

function IsLifeInsuranceCorp(RetNo: integer): Boolean;
begin
  Result := False;
  if FetchElm(RetNo, 'T2', 62) = 'Life Insurance Corporation' then
    Result := True;
end;

function IsNonResidentCorp(RetNo: integer): Boolean;
begin
  Result := False;
  if FetchElm(RetNo, 'T2', 49) > '' then
    Result := True;
end;

function GetLifeInsTxblCapital(RetNo: integer): Real;
begin
  if IsNonResidentCorp(RetNo) then
    Result := VL(FetchElm(RetNo, 'S38', 304))
  else
    Result := VL(FetchElm(RetNo, 'S38', 130));
end;

function IsTaxExempt(RetNo: integer): Boolean;
begin
  Result := False;
  if (FetchElm(RetNo, 'T2', 53) > '') or (FetchElm(RetNo, 'T2', 54) > '')
  // or (FetchElm(RetNo, 'T2', 55) > '')  //20211018
    or (FetchElm(RetNo, 'T2', 58) > '') then
    Result := True;
end;

function GetNetIncBfrPatronage(RetNo: integer): Real;
var
  i, S1FNo: integer;
  x: Real;
begin
  S1FNo := GetFormNo('S1');
  { add deductions from sch 1 excluding patronage }
  x := 0;
  for i := 35 to 47 do
    x := x + VL(FetchElmFNo(RetNo, S1FNo, i));
  x := x + VL(FetchElmFNo(RetNo, S1FNo, 50)) +
    VL(FetchElmFNo(RetNo, S1FNo, 51));
  Result := VL(FetchElm(RetNo, 'S1', 4)) + VL(FetchElm(RetNo, 'S1', 34)) - x;
end;

function GetCapitalStock(RetNo: integer): Real;
begin
  // 20150825
  Result := VL(FetchElm(RetNo, 'S100', 29)) +
  // direct fetch of fixed element   common shares
    VL(FetchGifiElm(RetNo, 'S100', '3520'));
  // 20150824  dynamic row element       //preferred shared
  // result := Vl(FetchGifiElm(RetNo, 'GIFIBS#1', '3500'))+ Vl(FetchGifiElm(RetNo, 'GIFIBS#1', '3520'));
end;

function GetRetainedEarnings(RetNo: integer): Real;
begin
  Result := MaxR(0, VL(FetchElm(RetNo, 'S100', 54)));
  // MaxR(0, Vl(FetchGifiElm(RetNo, 'GIFIBS#1', '3849')));
end;

function GetContributedSurplus(RetNo: integer): Real;
begin
  Result := VL(FetchGifiElm(RetNo, 'S100', '3541'));
end;

function GetOtherSurpluses(RetNo: integer): Real;
begin
  Result := VL(FetchGifiElm(RetNo, 'S100', '3542')) +
    VL(FetchGifiElm(RetNo, 'S100', '3543')); // 20170527
  // Vl(FetchGifiElm(RetNo, 'S100', '3540'));
end;

function IsShortYear(RetNo: integer): Boolean;
begin
  Result := False;
  if Ret[RetNo].DaysInYear < 357 then
    Result := True;
end;

function MTrim(s: string): string;
var
  i, len: integer;
begin
  Result := '';
  len := Length(s);
  i := 1;
  while i <= len do
  begin
    if s[i] <> Space(1) then
      Result := Result + s[i];
    Inc(i);
  end;
end { MTrim };

function IsFirstYearFiling(RetNo: integer): Boolean;
begin
  Result := False;
  if (UpperCase(FetchElm(RetNo, 'T2', 28)) = 'X')
  { //or (UpperCase(FetchElm(RetNo,'T2',30)) = 'X') } then
    Result := True;
end;

function GetTheTime(Dt: TDateTime): string;
var
  SHours, SMinutes, SSeconds: string; // [2];
  Hour, Min, Sec, Msec: Word;
begin
  DecodeTime(Now, Hour, Min, Sec, Msec);
  SHours := IntTostr(Hour);
  SMinutes := IntTostr(Min);
  { sSeconds := IntToStr(Sec); }
  if Length(SHours) = 1 then
    SHours := '0' + SHours;
  if Length(SMinutes) = 1 then
    SMinutes := '0' + SMinutes;
  { If Length(SSeconds) =1 then SSeconds := '0'+SSeconds; }
  Result := SHours + SMinutes;
  { +SSeconds; }
end;

function IsCanadianProvince(AddressPrv: string): Boolean;
var
  i: integer;
begin
  Result := False;
  for i := Low(PrvCodes) to High(PrvCodes) do
  begin
    if AddressPrv = PrvCodes[i] then
    begin
      Result := True;
      exit;
    end;
  end;
end;

function GapsInTable(RetNo: integer; Frm: string;
  StartElm, EndElm, IncrElm: integer): Boolean;
var
  i: integer;
  FNo: integer;
begin
  Result := False;
  FNo := GetFormNo(Frm);
  i := StartElm;
  repeat
    if (FetchElmFNo(RetNo, FNo, i) > '') and
      (FetchElmFNo(RetNo, FNo, i + IncrElm) = '') and
      (FetchElmFNo(RetNo, FNo, i + 2 * IncrElm) > '') then
    begin
      Result := True;
      exit;
    end;
    Inc(i, IncrElm);
  until i > EndElm - 2 * IncrElm;
end;

function GetAlbACTADed(RetNo: integer): Real;
var
  i, j, FNoS21, FnoAS4: integer;
begin
  Result := 0;
  FnoAS4 := GetFormNo('AS4');
  FNoS21 := GetFormNo('S21');
  i := 46;
  j := 7;
  repeat
    if VL(FetchElmFNo(RetNo, FnoAS4, i)) > VL(FetchElmFNo(RetNo, FNoS21, j))
    then
      Result := Result + VL(FetchElmFNo(RetNo, FnoAS4, i))
    else
      Result := Result + VL(FetchElmFNo(RetNo, FNoS21, j));
    Inc(i, 1);
    Inc(j, 9);
  until i > 50;
end;

function IsAlbSpecialAlloc(RetNo: integer): Boolean;
var
  FNoAS2_1, FNoAS2_2: integer;
begin
  Result := False;
  FNoAS2_1 := GetFormNo('AS2');
  FNoAS2_2 := GetFormNo('AS2');
  if (FetchElmFNo(RetNo, FNoAS2_1, 25) > '') or
    (FetchElmFNo(RetNo, FNoAS2_1, 26) > '') or
    (FetchElmFNo(RetNo, FNoAS2_1, 27) > '')

    or (FetchElmFNo(RetNo, FNoAS2_2, 134) > '') or
    (FetchElmFNo(RetNo, FNoAS2_2, 137) > '') or
    (FetchElmFNo(RetNo, FNoAS2_2, 138) > '') or
    (FetchElmFNo(RetNo, FNoAS2_2, 139) > '') or
    (FetchElmFNo(RetNo, FNoAS2_2, 140) > '') or
    (FetchElmFNo(RetNo, FNoAS2_2, 141) > '') or
    (FetchElmFNo(RetNo, FNoAS2_2, 142) > '') then
    Result := True;
end;

function GetInclRateForCarryBack(BackToDt: string): string;
begin
  Result := '0.50';
  // FetchElm(RetNo,'ACAPD_5',11);
  {
    If BackToDt < '2000/02/28' then result := '0.75'
    else  If BackToDt < '2000/10/18' then result := '0.60'
    else  result := '0.50';
  }
end;

function AlbAnyDiffSchedule(RetNo: integer): Boolean;
begin
  Result := False;
  if AlbDiffS6(RetNo) or AlbDiffCCA(RetNo) or AlbDiffCEC(RetNo) or
    AlbDiffResDed(RetNo) or AlbDiffSRD(RetNo) or AlbDiffReserves(RetNo) or
    AlbDiffCapDisp(RetNo) or AlbDiffDon(RetNo) or AlbDiffLoss(RetNo) then
    Result := True;
end;

function CalcAlbFactor(A, B, C, d: Real): Real;
var
  TheResult, x, Y: Real; { A,B,C,D:Real; }
begin
  if (A = 0) or (B = 0) then
  begin
    if d > 0 then
      TheResult := C / d
    else
      TheResult := 0;
  end
  else
  begin
    if B > 0 then
      x := A / B
    else
      x := 0;
    if d > 0 then
      Y := C / d
    else
      Y := 0;
    TheResult := x + Y;
  end;
  Result := TheResult;
end;

function GetAlbEffectiveRate(RetNo: integer): Real;
// Var Days1,Days2:Integer;
begin
  Result := (GetNumDays(RetNo, '01-04-2001', 'B') * 15.5 +
    (GetNumDays(RetNo, '31-03-2001', 'A') - GetNumDays(RetNo, '31-03-2002', 'A')
    ) * 13.5 + (GetNumDays(RetNo, '31-03-2002', 'A') - GetNumDays(RetNo,
    '31-03-2003', 'A')) * 13.0 + (GetNumDays(RetNo, '31-03-2003', 'A') -
    GetNumDays(RetNo, '31-03-2004', 'A')) * 12.5 + GetNumDays(RetNo,
    '31-03-2004', 'A') * 11.5) / Ret[RetNo].DaysInYear;

  // Days1:=GetNumDays(RetNo,'01-04-2001','B');
  // Days2:=GetNumDays(RetNo,'31-03-2001','A');
  // Result:= Vl(FormatFloat('###.###',(15.5 *(Days1/Ret[RetNo].DaysInYear))+ 13.5 *(Days2/Ret[RetNo].DaysInYear)));
end;

function GetDCNNo(RetNo: integer): string;
begin
  Result := LeftStr(GetAccountNumber(RetNo), 9) + FormatDateTime('yyyymmdd',
    Now) + GetTheTime(Now) + '00000000';
end;

function OpentaxbyteDB(UserId: string): Boolean;
// var lPsw:String; //20160303 Igor
begin
  // Result := fGetSQLitePsw(lPsw); //20150925 igor //20160303 Igor

  // 20150923 Igor
  taxbyteDb := TADConnection.Create(Application);
  Result := SetConnection(taxbyteDb, TaxByteDBLite, TaxByteTableLite);
  // 20160303 Igor
  // taxbyteDb.Params.Values['DataBase'] := TaxByteDBLite;
  // taxbyteDb.Params.Values['Password'] := lPsw;
  // taxbyteDb.DriverName:='SQLite';
  // taxbyteDB.LoginPrompt := False;
  // taxbyteDb.Data+Base+Name := 'TaxByteT2';
  // taxbyteDb.AliasName := taxbyteDB.DataBaseName; {needed}
  // try
  // taxbyteDb.Open;
  // except
  // on E: Exception do
  // MessageDlg(E.Message, mtError, [mbok], 0);
  // end;
  // Result := taxbyteDb.Connected;

end;

// 20170901 Igor>>>
// function ExceedsMaxReturnsAllowed: Boolean;
// Var MaxReturnsAllowed: Integer;  //20170628 CON
// begin
// //20170628 CON  adding more licenses for 1 to 5
// // NOTE llLimited and llLimited2returns is the same
// // NOTE llLimEfile and llLimited4returns is the same
// Result := false;
// if LicenseLevel = llLimited then
// begin
// if CountDBRecords > LimitedVersionReturns then
// begin result := True;MaxReturnsAllowed:=LimitedVersionReturns;end;  //20170628 CON
// end
// else if LicenseLevel = llLimEfile then
// begin
// if CountDBRecords > LimitedWithEfileVersionReturns then
// begin result := True;MaxReturnsAllowed:=LimitedWithEfileVersionReturns;end;    //20170628 CON
// end
// //20170628 CON
// else if LicenseLevel = llLimited1Returns then  Begin Result :=True; MaxReturnsAllowed:=Limited1Returns;end
// else if LicenseLevel = llLimited2Returns then  Begin Result :=True; MaxReturnsAllowed:=Limited2Returns;end
// else if LicenseLevel = llLimited3Returns then  Begin Result :=True; MaxReturnsAllowed:=Limited3Returns;end
// else if LicenseLevel = llLimited4Returns then  Begin Result :=True; MaxReturnsAllowed:=Limited4Returns;end
// else if LicenseLevel = llLimited5Returns then  Begin Result :=True; MaxReturnsAllowed:=Limited5Returns;end;
// //show message if limit exceeded
// if Result then
// UserMsg('Number of returns exceeds maximum allowed '
// + '(' + IntToStr(MaxReturnsAllowed) + ')' +
// // + '(' + IntToStr(LimitedVersionReturns) + ')' +  //20170628 CON
// Chr(13) + ' in the T2 Limited version'
// + Chr(13) + 'Please delete returns from the ClientBook');
// end;
//
// function CountDBRecords: Integer;
// var ADConnection: TADConnection;
// Table1: TADTable;
// begin
// //20150922 Igor
// ADConnection:= TADConnection.Create(Application);
// Table1 := TADTable.Create(Application);
// SetTableName(ADConnection, Table1, OptRec.Dir_Cur + '\' + ClientsDBLite, ClientsTableLite, '');
//
// Table1.Open;
// Result := Table1.RecordCount;
// Table1.Close;
// Table1.Free;
// ADConnection.Free;
// end;
// 20170901 Igor<<<

function ProfileJulianDays(DtIn: string): string;
var
  i, d, M, Yr, temp: integer;
  x, Y: Real;
  sd, sm, syr: string;
  MonthDays: array [0 .. 11] of integer;
  NumDays: integer;
begin
  if DtIn = '' then
  begin
    Result := '';
    exit;
  end;
  if LeftStr(DtIn, 5) = '12:00' then
  begin
    Result := '';
    exit;
  end;
  try
    (*
      {check std format}
      If (MidStr(DtIn,2,1)='/')
      or (MidStr(DtIn,3,1)='/') then
      begin
      Result:=ConvertGPDate(DtIn);
      exit;
      end;
    *)
    for i := 1 to Length(DtIn) do
    begin
      if (DtIn[i] = '/') or (DtIn[i] = '-') then
      begin
        Result := ConvertGpDate(DtIn);
        exit;
      end;
    end;

    { if in Julian numeric forma }
    NumDays := MyStrToInt(DtIn);
    if NumDays = 0 then
    begin
      Result := '';
      exit;
    end;
    MonthDays[0] := 31;
    MonthDays[1] := 28;
    MonthDays[2] := 31;
    MonthDays[3] := 30;
    MonthDays[4] := 31;
    MonthDays[5] := 30;
    MonthDays[6] := 31;
    MonthDays[7] := 31;
    MonthDays[8] := 30;
    MonthDays[9] := 31;
    MonthDays[10] := 30;
    MonthDays[11] := 31;

    Yr := Trunc(NumDays / 365.25) + 1900;
    if IsLeapYear(Yr) then
      MonthDays[1] := 29;

    d := (NumDays * 100 mod 36525) div 100;

    M := 0;
    temp := d;
    while temp > 30 do
    begin
      temp := temp - MonthDays[M];
      M := M + 1;
    end;

    M := M + 1;
    if (M = 2) and (temp > MonthDays[1]) then
    begin
      M := M + 1;
      d := temp - MonthDays[1];
    end
    else
      d := temp;

    sd := AllTrim(IntTostr(d));
    if Length(sd) = 1 then
      sd := '0' + sd;

    sm := AllTrim(IntTostr(M));
    if Length(sm) = 1 then
      sm := '0' + sm;

    syr := AllTrim(IntTostr(Yr));
    Result := syr + '/' + sm + '/' + sd;
  except
    ShowMessage('error converting date');
  end;
end;

function JulianDaysToYYYYMMDD(DtIn: string): string;
var
  i, d, M, Yr, temp: integer;
  x, Y: Real;
  sd, sm, syr: string;
  MonthDays: array [0 .. 11] of integer;
  NumDays: integer;
begin
  if DtIn = '' then
  begin
    Result := '';
    exit;
  end;
  if LeftStr(DtIn, 5) = '12:00' then
  begin
    Result := '';
    exit;
  end;
  try
    { check std format }
    (*
      For i:=1 to Length(DtIn) do
      begin
      If DtIn[i]='/' then
      begin
      Result:=ConvertGPDate(DtIn);
      exit;
      end;
      end;
    *)
    { if in Julian numeric forma }
    NumDays := MyStrToInt(DtIn);
    if NumDays = 0 then
    begin
      Result := '';
      exit;
    end;
    MonthDays[0] := 31;
    MonthDays[1] := 28;
    MonthDays[2] := 31;
    MonthDays[3] := 30;
    MonthDays[4] := 31;
    MonthDays[5] := 30;
    MonthDays[6] := 31;
    MonthDays[7] := 31;
    MonthDays[8] := 30;
    MonthDays[9] := 31;
    MonthDays[10] := 30;
    MonthDays[11] := 31;

    Yr := Trunc(NumDays / 365.25) + 1900;
    if IsLeapYear(Yr) then
      MonthDays[1] := 29;

    d := (NumDays * 100 mod 36525) div 100;

    M := 0;
    temp := d;
    while temp > 30 do
    begin
      temp := temp - MonthDays[M];
      M := M + 1;
    end;

    M := M + 1;
    if (M = 2) and (temp > MonthDays[1]) then
    begin
      M := M + 1;
      d := temp - MonthDays[1];
    end
    else
      d := temp;

    sd := AllTrim(IntTostr(d));
    if Length(sd) = 1 then
      sd := '0' + sd;

    sm := AllTrim(IntTostr(M));
    if Length(sm) = 1 then
      sm := '0' + sm;

    syr := AllTrim(IntTostr(Yr));
    if sd = '00' then
    begin
      sm := '12';
      sd := '31';
    end;
    Result := syr + '/' + sm + '/' + sd;
  except
    ShowMessage('error converting date');
  end;
end;

function CanTaxJulianDaysToYYYYMMDD(DtIn: string): string;
var
  i, d, M, Yr, temp: integer;
  x, Y: Real;
  sd, sm, syr: string;
  MonthDays: array [0 .. 11] of integer;
  NumDays: integer;
  TDate1, TDate2: TDate; // date is number of days since delphi since 1899
  D1: string;
begin
  Result := '';
  try
    // 20170728 Igor>>>
    // D1 := MMDDYYYYToWinFormat('03/01/1800');
    // TDate1 := StrToDateTime(D1);
    TDate1 := EncodeDate(1800, 03, 01);
    // 20170728 Igor<<<
    TDate2 := StrToInt(DtIn) + TDate1 - 2;
    Result := FormatDateTime('yyyy-mm-dd', TDate2);
  except
    on E: Exception do
      ExceptMsg(E);
  end;
end;

function ConvertGpDate(DtIn: string): string;
{ DtIn m/d/yyyy }
var
  WList: TStringList;
  mm, DD, YYYY: string;
begin
  WList := TStringList.Create;
  ParseWords(DtIn, '/', WList);
  DD := WList[0];
  mm := WList[1];
  YYYY := WList[2];
  if Length(DD) = 1 then
    DD := '0' + DD;
  if Length(mm) = 1 then
    mm := '0' + mm;
  Result := YYYY + '/' + mm + '/' + DD;
  WList.Free;
end;

function GetFldTapeFormNo(RetNo: integer;
  RefFormName, RefFieldId: string): integer;
var
  i, FNo: integer;
  FrmNm: string; // [10];
begin
  Result := 0;
  for i := FList.FirstInstNo('FLDTAPE') to FList.Count - 1 do
  begin
    FRec := FList.Items[i];
    if FRec.FormName <> 'FLDTAPE' then
      Break;
    begin
      FNo := FRec.FormNo;
      if (FetchElmFNo(RetNo, FNo, 121) = RefFormName) and
        (FetchElmFNo(RetNo, FNo, 122) = RefFieldId) then
      begin
        Result := FNo;
        exit; // DoDi 2014-02-17
      end;
    end;
  end;
end;

Function GetEmptyInstance(RetNo: integer; FormName: String): integer;
// 20170118 Igor >>>
Var
  i: integer;
  InstForms: TFRecArray;
begin
  InstForms := FList.GetAllInstForms(FormName);
  for i := 0 to Length(InstForms) - 1 do
    If not Ret[RetNo].FormHasData[GetFormName(InstForms[i].FormNo, RetNo)] then
    // 20170130 Igor
      exit(ExtractFormInstNo(InstForms[i].FormInst));
  Result := ExtractFormInstNo(InstForms[Length(InstForms) - 1].FormInst) + 1;
  // 20170118 Igor >>>
end;

function GetHlpTopicFromLineRef(FormName: string; FieldId: integer): string;
var
  i: integer;
  LineRef: TStringList;
begin
  Result := '';

  exit;

  LineRef := TStringList.Create;
  LineRef.LoadFromFile(AppDir + '\' + 'LineRef.d');
  for i := 0 to LineRef.Count - 1 do
  begin
    if FormName = AllTrim(LeftStr(LineRef[i], 9)) then
    begin
      if FieldId = MyStrToInt(AllTrim(MidStr(LineRef[i], 10, 4))) then
      begin
        Result := AllTrim(MidStr(LineRef[i], 14, 50));
        Break;
      end;
    end; { same formname }
  end; { i loop }
  LineRef.Free;
end;

function FetchElmFromDataList(DataList: TStringList; FName: string;
  Elm: integer): string;
{ datalist is what is the stringlist of the saved file: i.e. F... D... etc }
var
  i, j: integer;
  Rec: string;
  WList: TStringList;
begin
  Result := '';
  try
    WList := TStringList.Create;
    for i := 0 to DataList.Count - 1 do
    begin
      Rec := DataList[i];
      ParseWords(Rec, Delimiter, WList);
      if (WList[0] = 'F') and (WList[1] = FName) then
      begin
        j := i + 1;
        repeat
          if j > DataList.Count - 1 then
            Break;
          Rec := DataList[j];
          ParseWords(Rec, Delimiter, WList);
          if (WList[0] = 'D') then
          begin
            if VL(WList[1]) = Elm then
            begin
              Result := WList[2];
              // WList.free;
              j := DataList.Count + 2;
              Break;
              // exit;
            end;
          end;
          Inc(j);
        until (j > DataList.Count - 1) or (LeftStr(Rec, 2) = 'F' + Delimiter);
        { end form data }
        Break;
      end; { within form nm }
    end; { i }
  except
  end;
  WList.Free;
end;

function GetIncomeForAlbSBD(RetNo: integer): Real;
var
  S1FNo: integer;
begin
  S1FNo := GetFormNo('AS1');
  Result := MinR(VL(FetchElmFNo(RetNo, S1FNo, 7)),
    MinR(VL(FetchElmFNo(RetNo, S1FNo, 10)), VL(FetchElmFNo(RetNo, S1FNo, 11))) *
    VL(FetchElmFNo(RetNo, S1FNo, 13)));
end;

function GetFileExtension(flName: string): string;
begin
  Result := ExtractFileExt(flName);
  Result := MidStr(Result, 2, 3);
end;

function RemoveFileExtension(flName: string): string;
var
  s: string;
begin
  s := ExtractFileExt(flName);
  Result := LeftStr(flName, Length(flName) - Length(s));
end;

function GetModuleName: string; // ??? not used
// Small utility function to get the module name of the DLL.
var
  ModName: array [0 .. MAX_PATH] of Char;
begin
  // SetString(Result, ModName, Windows.GetModuleFileName(HInstance, ModName, SizeOf(ModName)));

  Result := ExtractFileName(Result);
end;

procedure FindTextInForm(FormNm: string; KeyW: string;
  var TempList: TStringList);
var
  i, j, N: integer;
  AList: TStringList;
  Root, FName: string;
begin
end;

procedure AutoFormatDate(var Value: string);
begin
  if ((Length(Value) = 8) and Numeric(Value)) or (Length(Value) = 10) then
  begin
    Value := RemoveChar(Value, '-');
    Value := RemoveChar(Value, '/');
    Value := LeftStr(Value, 4) + '/' + MidStr(Value, 5, 2) + '/' +
      RightStr(Value, 2);
  end;
end;

procedure AutoFormatYYYYMMDate(var Value: string);
begin
  if ((Length(Value) = 6) and Numeric(Value)) or (Length(Value) = 7) then
  begin
    Value := RemoveChar(Value, '-');
    Value := RemoveChar(Value, '/');
    Value := LeftStr(Value, 4) + '/' + MidStr(Value, 5, 2);
  end;
end;

function CanItBeEfiled(RetNo: integer): Boolean;
begin
  Result := True;

  delay(1000);
  // showmessage(inttostr(GetTaxationYearEndYYYY(RetNo)));

  // If (IsNonResidentCorp(RetNo))  //2008/09/22
  if (IsNameChange(RetNo))
  { or (GetTaxationYearEndYYYY(RetNo) <2002) }
    or (Ret[RetNo].FrmHasData[GetFormNo('S35')]) { Insurance }
    or (Ret[RetNo].FrmHasData[GetFormNo('S40')]) { Insurance } // 20121209
  // 20100510
    or (IsInsuranceCorp(RetNo) = True) or (IsLifeInsuranceCorp(RetNo) = True)
  then
    Result := False;
end;

function IsNameChange(RetNo: integer): Boolean;
begin
  Result := False;
  // If UpperCase(FetchElm(RetNo,'T2',4)) = 'X' then result:=True;  //20130607
end;

function IsFirstYearAfterAmalgamation(RetNo: integer): Boolean;
begin
  Result := False;
  if UpperCase(FetchElm(RetNo, 'T2', 30)) = 'X' then
    Result := True;
end;

function IsFirstYearAfterWindUp(RetNo: integer): Boolean;
begin
  Result := False;
  if UpperCase(FetchElm(RetNo, 'T2', 36)) = 'X' then
    Result := True;
end;

function IsWindUpOfSubsidiary(RetNo: integer): Boolean;
begin
  Result := False;
  if UpperCase(FetchElm(RetNo, 'T2', 36)) = 'X' then
    Result := True;
end;

procedure GetMostRecentFiles(SomeList: TStringList; HowMany: integer);
var
  ADConnection: TADConnection;
  AQuery: TADQuery;
  s, WhereClause: string;
  i: integer;
begin
  // 20150923 Igor
  ADConnection := TADConnection.Create(Application);
  AQuery := TADQuery.Create(Application);
  SqlLoadDBFromFile(ADConnection, AQuery, OptRec.Dir_Cur + '\' +
    ClientsDBLite, '');
  try
    WhereClause := '';
    {
      WhereClause := ' where '
      +'('
      + 'Trim(Updated_Dt) > ' + '"' + OldestUpdDate + '"'
      +')';
    }
    { ------------ }
    with AQuery do
    begin
      SQL.Add('Select * from ' + ClientsTableLite); // 20150923 Igor
      // SQL.Add( WhereClause);
      SQL.Add(' ORDER BY Updated_Dt DESC');
      Prepare;
      Open;

      i := 1;
      First;
      repeat
        s := PaddR(AllTrim(AQuery.FieldByName('CORP_NAME').AsString), 30) + ' '
          + PaddR(AQuery.FieldByName('Updated_Dt').AsString, 10) + ' ' +
          PaddR(AQuery.FieldByName('Updated_tm').AsString, 10) + ' ' +
          PaddR(AQuery.FieldByName('File_Name').AsString, 15);
        SomeList.Add(s);
        if i > HowMany then
          Break;
        Next;
      until Eof;
      AQuery.Close;
      AQuery.Free;
      ADConnection.Free;
    end;
  except
    on E: Exception do
      ExceptMsg(E); // MessageDlg(E.Message, mtError, [mbok], 0);
  end; // except
end;

function GetValueFromHtm(url: string; Parameter: string): string;
var
  i, j, k, L: integer;
  h: THandle;
  flName: string;
  TempList: TStringList;
  TempString: array [0 .. 79] of Char;
begin
  Result := '';
  TempList := TStringList.Create;
  TempList.LoadFromFile(url);
  for i := 0 to TempList.Count - 1 do
  begin
    if GetPositionOfSubstring(Parameter, TempList[i]) > 0 then
    begin
      Result := TempList[i];
      exit;
    end; // found parameter string
  end; // i
  TempList.Free;
end;

(* KEEP
  Function GetValueFromInternet(Url:String;Parameter:String):String;
  Var i,j,k,l:Integer;h:THandle;FlName:String;TempList:Tstringlist;
  TempString : array[0..79] of char;
  NMHTTP1 : TNMHTTP;
  Memo1:TMemo;
  begin
  Result:='';
  NMHTTP1 := TNMHTTP.Create(Application);
  Memo1:=TMemo.Create(Application);
  NMHTTP1.Get(Url);
  Memo1.Text := NMHTTP1.Body;
  Memo1.lines.SaveToFile(AppDir+'Temp.htm');
  Memo1.Free;
  { If NMHTTP1.CookieIn <> '' then
  ShowMessage('Cookie:'+#13#10+NMHTTP1.CookieIn);}
  TempList:=TStringList.Create;
  TempList.LoadFromFile(AppDir+'Temp.htm');
  For i:=0 to TempList.Count-1 do
  begin
  If GetPositionOfSubstring(Parameter,TempList[i]) > 0  then
  begin
  {ShowMessage(TempList[i]);}
  for j:=i to i+3 do
  begin
  k:=GetPositionOfSubstring('$',TempList[j]);
  If k>0 then
  begin
  //ShowMessage(TempList[j]);
  Result:=MidStr(TempList[j],k+1,10);
  For l:=1 to 10 do
  begin
  If Result[l] = '<' then result := LeftStr(Result,l-1);
  end;
  NMHTTP1.Free;
  TempList.Free;
  exit;
  end; //found keyword
  end; // checked 3 lines for $
  end; //found parameter
  end; //i
  NMHTTP1.Free;
  TempList.Free;
  end;
*)

function GetPositionOfSubstring(ss, s: string): integer;
begin
  Result := pos(UpperCase(ss), UpperCase(s));
end;

procedure GetTheHtmlDoc(url: string; CaptureFileName: string); // 20150624
var
  i: integer;
  h: THandle;
  flName: string;
  TempString: array [0 .. 79] of Char;
  IdHTTP1: TIdHTTP;
  // Memo1: TMemo; //20150624
  aFS: TFileStream;

  PgmPathS, PgmS, PgmParmsS: string;
  PgmPathZ: array [0 .. 254] of Char;
  PgmParmsZ: array [0 .. 254] of Char;
  PgmZ: array [0 .. 254] of Char;
begin
  IdHTTP1 := nil;
  aFS := nil;
  try
    IdHTTP1 := TIdHTTP.Create(Application);
    // Memo1 := TMemo.Create(Application); //20150624
    aFS := TFileStream.Create(CaptureFileName, fmCreate or fmShareDenyWrite);
    IdHTTP1.Get(url, aFS);
    // Memo1.Text := NMHTTP1.Body; //20150624
    { If IdHTTP1.CookieManager.CookieCollection.Count <> 0 then //20150624 ?
      ShowMessage('Cookie:'+#13#10+NMHTTP1.CookieIn); }
    // Memo1.lines.SaveToFile(CaptureFileName); //20150624

    // StrPCopy(TempString, CaptureFileName);

    PgmPathS := AppDir;
    StrPCopy(PgmPathZ, PgmPathS);
    PgmS := CaptureFileName;
    StrPCopy(PgmZ, PgmS);
    PgmParmsS := '';
    StrPCopy(PgmParmsZ, PgmParmsS);
    h := ShellExecute(MainForm.Handle, nil, PgmZ, PgmParmsZ, PgmPathZ,
      SW_RESTORE);
    if h <= 32 then
      ShowMessage('Failed');
  finally
    aFS.Free;
    IdHTTP1.Free;
  end;
end;

//
// https://198.103.185.174/tg.t2if.tierp/index.jsp
// https://198.103.185.174/tg.t2if.tierp/T2ifTransferFileForm-e

procedure BuildExperience(FrmNm: string; FromElm, ToElm, ByElm: integer;
  flName: string; var ElmList: TStringList; DataList: TStringList);
// For a given form
// for a set of elms
// From values in datalist (image of tax return data file)
var
  i, j, BnElm: integer;
  s: string;
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  ElmList.clear;
  j := FromElm;
  repeat
    ElmList.Add(FillLeftZeros(AllTrim(IntTostr(j)), 3));
    Inc(j, ByElm);
  until j > ToElm;
  PutValuesInElmList(FrmNm, DataList, ElmList);

  (*
    If UpperCase(FlName)='CorpBn.txt' then
    begin  //add corp name after the BN i.e. nn   bn  CorpNm
    For i:=0 to ElmList.Count-1 do
    begin
    ElmList[i] := ElmList[i] +' '+GetSuperCorpName(ElmList[i]);
    end;
    end;
  *)
  if FileExists(AppDir + '\' + flName) then
    TempList.LoadFromFile(AppDir + '\' + flName);
  for j := 0 to ElmList.Count - 1 do
  begin
    s := MidStr(ElmList[j], 6, 255);
    if (s > '') and (IsStringInList(s, TempList) = -1) and (s <> '"') then
      TempList.Add(s);
  end;
  for i := 0 to TempList.Count - 1 do
    TempList[i] := UpperCase(TempList[i]);

  TempList.Sorted := True;
  TempList.SaveToFile(AppDir + '\' + flName);
  TempList.Free;
end;

procedure PutValuesInElmList(FrmNm: string; DataList: TStringList;
  var ElmList: TStringList);
// DataList is the tax return data
// Elm list has the Elm numbers for a given form
// Returns populated ElmList nnn  value
var
  i, j, k, ElmNo: integer;
  WList: TStringList;
  Rec: string;
begin
  if ElmList.Count < 1 then
    exit;
  try
    if LeftStr(DataList[0], 2) <> 'T2' then
      exit;

    WList := TStringList.Create;
    for i := 1 to DataList.Count - 1 do
    begin
      Rec := DataList[i];
      ParseWords(Rec, Delimiter, WList);
      if (WList[0] = 'F') and (WList[1] = FrmNm) then // found form record
      begin
        j := i + 1;
        repeat
          Rec := DataList[j];
          ParseWords(Rec, Delimiter, WList);
          if (WList[0] = 'D') then // wlist[2] has the actual data
          begin
            for k := 0 to ElmList.Count - 1 do
            begin
              ElmNo := MyStrToInt(MidStr(ElmList[k], 1, 3));
              if VL(WList[1]) = ElmNo then
                ElmList[k] := PaddR(ElmList[k], 4) + ' ' + WList[2];
            end;
          end; // end detail rec
          Inc(j);
        until (j > DataList.Count - 1) or (LeftStr(Rec, 2) = 'F' + Delimiter);
        { end form data }
      end; { within form nm }
    end; { i }
  except
  end;
  WList.Free;
end;

function IsStringInList(s: string; AList: TStringList): integer;
{ return item index of a given string }
var
  i: integer;
begin
  Result := -1;
  for i := 0 to AList.Count - 1 do
    if UpperCase(s) = UpperCase(AList[i]) then
    begin
      Result := i;
      exit;
    end;
end;

function GetSuperCorpName(ElmRec: string): string;
var
  FNo: integer;
begin
  Result := '';
end;

function GetWACNumber(RetNo: integer): string;
begin
  // result:=FetchElm(RetNo,'T183CP',20);
  Result := FetchElm(RetNo, 'T2', 75); // 20130527
end;

function IsEFiled(RetNo: integer): Boolean;
begin
  Result := False;
  if UpperCase(FetchElm(RetNo, 'T2', 76)) = 'Y' then
    Result := True; // 20130530
  // If FetchElm(RetNo,'T183CP',21) >'' then Result:=True;  //20130528
end;

function GetEFileConfirmationNo(RetNo: integer): string;
begin
  Result := FetchElm(RetNo, 'T183CP', 21);
end;

function IsElmInRange(ElmNo, FromElm, ToElm, ByIncr: integer): Boolean;
var
  i: integer;
begin
  Result := False;
  i := FromElm;
  repeat
    if i = ElmNo then
    begin
      Result := True;
      exit;
    end;
    Inc(i, ByIncr);
  until i > ToElm;
end;

function IsFieldABN(FrmNm: string; ElmNo: integer): Boolean;
begin
  Result := False;

  if (FrmNm = 'T2') then
  begin
    if IsElmInRange(ElmNo, 1, 1, 1) then
    begin
      Result := True;
      exit;
    end;
  end;

  if (FrmNm = 'S3') then
  begin
    if IsElmInRange(ElmNo, 6, 87, 9) then
    begin
      Result := True;
      exit;
    end;
  end;

  if (FrmNm = 'S3') then
  begin
    if IsElmInRange(ElmNo, 211, 247, 4) then
    begin
      Result := True;
      exit;
    end;
  end;

  if (FrmNm = 'S9') then
  begin
    if IsElmInRange(ElmNo, 6, 177, 9) then
    begin
      Result := True;
      exit;
    end;
  end;

  if (FrmNm = 'S23') then
  begin
    if IsElmInRange(ElmNo, 6, 120, 6) then
    begin
      Result := True;
      exit;
    end;
  end;

  if (FrmNm = 'S24') then
  begin
    if IsElmInRange(ElmNo, 23, 33, 2) then
    begin
      Result := True;
      exit;
    end;
    if IsElmInRange(ElmNo, 35, 63, 4) then
    begin
      Result := True;
      exit;
    end;
  end;

  if (FrmNm = 'S28') then
  begin
    if IsElmInRange(ElmNo, 50, 50, 1) then
    begin
      Result := True;
      exit;
    end;
  end;

  if (FrmNm = 'S28') then
  begin
    if IsElmInRange(ElmNo, 5, 47, 3) then
    begin
      Result := True;
      exit;
    end;
  end;

  if (FrmNm = 'S39') then
  begin
    if IsElmInRange(ElmNo, 5, 93, 4) then
    begin
      Result := True;
      exit;
    end;
  end;

  if (FrmNm = 'S40') then
  begin
    if IsElmInRange(ElmNo, 5, 93, 4) then
    begin
      Result := True;
      exit;
    end;
  end;

  if (FrmNm = 'S41') then
  begin
    if IsElmInRange(ElmNo, 6, 74, 4) then
    begin
      Result := True;
      exit;
    end;
  end;

  if (FrmNm = 'S44') then
  begin
    if IsElmInRange(ElmNo, 5, 74, 3) then
    begin
      Result := True;
      exit;
    end;
  end;

  if (FrmNm = 'S45') then
  begin
    if IsElmInRange(ElmNo, 4, 4, 1) then
    begin
      Result := True;
      exit;
    end;
  end;

  if (FrmNm = 'S45') then
  begin
    if IsElmInRange(ElmNo, 7, 7, 1) then
    begin
      Result := True;
      exit;
    end;
  end;

  if (FrmNm = 'S49') then
  begin
    if IsElmInRange(ElmNo, 6, 120, 6) then
    begin
      Result := True;
      exit;
    end;
  end;

  if (FrmNm = 'S50') then
  begin
    if IsElmInRange(ElmNo, 5, 125, 5) then
    begin
      Result := True;
      exit;
    end;
  end;
  { S501 deleted 20130831
    If (LeftStr(FrmNm,4)='S501') then
    begin
    If IsElmInRange(ElmNo,5,81,4) then Begin Result := True;exit;end;
    end;
  }

  if (LeftStr(FrmNm, 4) = 'S511') then
  begin
    if IsElmInRange(ElmNo, 5, 81, 4) then
    begin
      Result := True;
      exit;
    end;
  end;

  if (LeftStr(FrmNm, 4) = 'S512') then
  begin
    if IsElmInRange(ElmNo, 43, 43, 1) then
    begin
      Result := True;
      exit;
    end;
  end;

  if (LeftStr(FrmNm, 4) = 'S513') then
  begin
    if IsElmInRange(ElmNo, 5, 62, 3) then
    begin
      Result := True;
      exit;
    end;
  end;

  if (LeftStr(FrmNm, 4) = 'S516') then
  begin
    if IsElmInRange(ElmNo, 5, 119, 6) then
    begin
      Result := True;
      exit;
    end;
  end;

  if (LeftStr(FrmNm, 4) = 'S556') then
  begin
    if IsElmInRange(ElmNo, 42, 42, 1) then
    begin
      Result := True;
      exit;
    end;
  end;

  if (LeftStr(FrmNm, 4) = 'S566') then
  begin
    if IsElmInRange(ElmNo, 110, 167, 3) then
    begin
      Result := True;
      exit;
    end;
  end;

  if (LeftStr(FrmNm, 4) = 'S568') then
  begin
    if IsElmInRange(ElmNo, 16, 73, 3) then
    begin
      Result := True;
      exit;
    end;
  end;

end;

function GetNonTaxableGainsLosses(RetNo: integer): Real;
var
  x: Real;
begin
  Result := VL(FetchElm(RetNo, 'S6', 684)) *
    (1 - VL(FetchInclusionRateString(RetNo)));
end;

function GetJurisdiction(RetNo: integer): string;
begin
  Result := FetchElm(RetNo, 'T2', 710);
end;

function IsElectricalGenerator(RetNo: integer): Boolean;
begin
  Result := False;
  if UpperCase(FetchElm(RetNo, 'S27', 314)) = 'Y' then
    Result := True;
end;

function GetMaxMBRdCredit(RetNo: integer): Real;
var
  S5FNo: integer;
begin
  S5FNo := GetFormNo('S5'); // pg 6
  Result := MaxR(0, VL(FetchElmFNo(RetNo, S5FNo, 712)) -
    VL(FetchElmFNo(RetNo, S5FNo, 715)) - VL(FetchElmFNo(RetNo, S5FNo, 716)) -
    VL(FetchElmFNo(RetNo, S5FNo, 747)) - VL(FetchElmFNo(RetNo, S5FNo, 748)));
end;

function GetMaxSkRdCredit(RetNo: integer): Real;
var
  S5FNo: integer;
begin
  S5FNo := GetFormNo('S5'); // pg 6
  Result := MaxR(0, VL(FetchElmFNo(RetNo, S5FNo, 724)) -
    VL(FetchElmFNo(RetNo, S5FNo, 740)) - VL(FetchElmFNo(RetNo, S5FNo, 725)) -
    VL(FetchElmFNo(RetNo, S5FNo, 739))
    // -Vl(FetchElmFNo(RetNo,S5FNo,726))
    - VL(FetchElmFNo(RetNo, S5FNo, 727)) - VL(FetchElmFNo(RetNo, S5FNo, 728)));
end;

function GetMaxNonRefNBRdCredit(RetNo: integer): Real;
var
  S5FNo: integer;
begin
  S5FNo := GetFormNo('S5'); // pg4
  Result := MaxR(0, VL(FetchElmFNo(RetNo, S5FNo, 504)) -
    VL(FetchElmFNo(RetNo, S5FNo, 515)) - VL(FetchElmFNo(RetNo, S5FNo, 512)) -
    VL(FetchElmFNo(RetNo, S5FNo, 505)));
end;

function GetMaxRefNBRdCredit(RetNo: integer): Real;
var
  S5FNo: integer;
begin
  S5FNo := GetFormNo('S5'); // pg4
  Result := MaxR(0, VL(FetchElmFNo(RetNo, S5FNo, 508)) -
    VL(FetchElmFNo(RetNo, S5FNo, 509)));
end;

function IsFieldInElmsInError(s: string; AList: TStringList): integer;
{ return item index of a given string }
var
  i: integer;
begin
  Result := -1;
  s := AllTrim(UpperCase(s));
  for i := 0 to AList.Count - 1 do
  begin
    if s = AllTrim(UpperCase(LeftStr(AList[i], 3))) then
    begin
      Result := i;
      exit;
    end;
  end;
end;

function GetPrvAlloc(RetNo: integer; Prv: string): string;
const
  msk = '###.##';
var
  i: integer;
  PrvTxbl, TotTxbl: Real;
begin
  Result := '';
  if Prv = Ret[RetNo].Province then
  begin
    Result := '100';
    exit;
  end;

  // MJ
  TotTxbl := VL(FetchElm(RetNo, 'S5', 274));
  if TotTxbl > 0 then
  begin
    if Prv = 'NL' then
      PrvTxbl := VL(FetchElm(RetNo, 'S5', 109))
    else if Prv = 'PE' then
      PrvTxbl := VL(FetchElm(RetNo, 'S5', 120))
    else if Prv = 'NS' then
      PrvTxbl := VL(FetchElm(RetNo, 'S5', 131))
    else if Prv = 'NB' then
      PrvTxbl := VL(FetchElm(RetNo, 'S5', 142))
    else if Prv = 'MB' then
      PrvTxbl := VL(FetchElm(RetNo, 'S5', 175))
    else if Prv = 'SK' then
      PrvTxbl := VL(FetchElm(RetNo, 'S5', 186))
    else if Prv = 'AB' then
      PrvTxbl := VL(FetchElm(RetNo, 'S5', 199))
    else if Prv = 'BC' then
      PrvTxbl := VL(FetchElm(RetNo, 'S5', 208))
    else if Prv = 'YT' then
      PrvTxbl := VL(FetchElm(RetNo, 'S5', 219))
    else if Prv = 'NT' then
      PrvTxbl := VL(FetchElm(RetNo, 'S5', 30))
    else if Prv = 'NU' then
      PrvTxbl := VL(FetchElm(RetNo, 'S5', 281));

    Result := FormatFloat(msk, (PrvTxbl / TotTxbl) * 100);
  end;
end;

function GetPrvAllocForFtc(RetNo: integer; Prv: string): string;
const
  msk = '###.##';
var
  i: integer;
  PrvTxbl, TotTxbl: Real;
begin
  Result := '';
  if Prv = Ret[RetNo].Province then
  begin
    Result := '100';
    exit;
  end;

  // MJ
  TotTxbl := VL(FetchElm(RetNo, 'S5', 274)) - VL(FetchElm(RetNo, 'S5', 252))
  // NL offshore
    - VL(FetchElm(RetNo, 'S5', 241)) // NS offshore
    - VL(FetchElm(RetNo, 'S5', 263)); // less outside canada
  if TotTxbl > 0 then
  begin
    if Prv = 'NL' then
      PrvTxbl := VL(FetchElm(RetNo, 'S5', 109))
    else if Prv = 'PE' then
      PrvTxbl := VL(FetchElm(RetNo, 'S5', 120))
    else if Prv = 'NS' then
      PrvTxbl := VL(FetchElm(RetNo, 'S5', 131))
    else if Prv = 'NB' then
      PrvTxbl := VL(FetchElm(RetNo, 'S5', 142))
    else if Prv = 'MB' then
      PrvTxbl := VL(FetchElm(RetNo, 'S5', 175))
    else if Prv = 'SK' then
      PrvTxbl := VL(FetchElm(RetNo, 'S5', 186))
    else if Prv = 'AB' then
      PrvTxbl := VL(FetchElm(RetNo, 'S5', 199))
    else if Prv = 'BC' then
      PrvTxbl := VL(FetchElm(RetNo, 'S5', 208))
    else if Prv = 'YT' then
      PrvTxbl := VL(FetchElm(RetNo, 'S5', 219))
    else if Prv = 'NT' then
      PrvTxbl := VL(FetchElm(RetNo, 'S5', 230))
    else if Prv = 'NU' then
      PrvTxbl := VL(FetchElm(RetNo, 'S5', 281))
    else if Prv = 'ON' then
      PrvTxbl := VL(FetchElm(RetNo, 'S5', 164));
    Result := FormatFloat(msk, (PrvTxbl / TotTxbl) * 100);
  end;
end;

(* 20220901
  function GetOntApprovalCode(FName: string): string;
  begin
  if UpperCase(LeftStr(FName, 3)) = 'OPG' then
  result := 'VisualTax T2 - 2007 CT23 - Version 2007.3 - Approval Code '
  + OntDFileSoftCode {051F'}
  else
  result := 'VisualTax T2 - Version 2007.3';

  end;
*)

function PredictiveForm(Frm: string): Boolean;
var
  i: integer;
  TempList: TStringList;
begin
  Result := False;
  if LicenseLevel in [llLimited .. llStd] then
    exit;

  Frm := ExtractNonInstFormName(Frm);
  if (Frm = 'T2') or (Frm = 'S2') or (Frm = 'S3')
  // or (Frm = 'S3_2')
    or (Frm = 'S9') or (Frm = 'S14') or (Frm = 'S15') or (Frm = 'S22') or
    (Frm = 'S29') or (Frm = 'S23') or (Frm = 'S24') or (Frm = 'S25') or
    (Frm = 'S28') or (Frm = 'S29') or (Frm = 'S39') or (Frm = 'S40') or
    (Frm = 'S41') or (Frm = 'S44') or (Frm = 'S45') or (Frm = 'S49') or
    (Frm = 'S50') then
    Result := True;
end;

function GetPredictive(FrmNm: string; FldId: integer;
  OldString: string): string;
var
  i: integer;
  TempList: TStringList;
  FieldId: integer absolute FldId;
begin
  Result := '';
  FrmNm := ExtractNonInstFormName(FrmNm);
  // CorpNm
  if ((FrmNm = 'T2') and (FldId = 3)) or
    ((FrmNm = 'S3') and ((NumInRange(FieldId, 4, 85, 9)) or (NumInRange(FieldId,
    10, 46, 4))))
  // Or ((FrmNm = 'S3_2') and (NumInRange(FieldId,10,46,4)))
    or ((FrmNm = 'S9') and (NumInRange(FieldId, 4, 175, 9))) or
    ((FrmNm = 'S23') and (NumInRange(FieldId, 5, 119, 6))) or
    ((FrmNm = 'S24') and (NumInRange(FieldId, 22, 32, 2))) or
    ((FrmNm = 'S24') and (NumInRange(FieldId, 34, 62, 4))) or
    ((FrmNm = 'S25') and (NumInRange(FieldId, 4, 64, 3))) or
    ((FrmNm = 'S28') and (NumInRange(FieldId, 49, 49, 1))) or
    ((FrmNm = 'S28') and (NumInRange(FieldId, 4, 46, 3))) or
    ((FrmNm = 'S39') and (NumInRange(FieldId, 4, 92, 4))) or
    ((FrmNm = 'S40') and (NumInRange(FieldId, 4, 92, 4))) or
    ((FrmNm = 'S41') and (NumInRange(FieldId, 5, 73, 4))) or
    ((FrmNm = 'S44') and (NumInRange(FieldId, 4, 73, 3))) or
    ((FrmNm = 'S45') and (NumInRange(FieldId, 3, 3, 1))) or
    ((FrmNm = 'S45') and (NumInRange(FieldId, 6, 6, 1))) or
    ((FrmNm = 'S49') and (NumInRange(FieldId, 5, 119, 6))) or
    ((FrmNm = 'S50') and (NumInRange(FieldId, 4, 124, 5))) then
  begin
    TempList := TStringList.Create;
    TempList.LoadFromFile(AppDir + '\' + 'CorpNm.txt');
    for i := 0 to TempList.Count - 1 do
    begin
      if UpperCase(OldString) = UpperCase
        (LeftStr(TempList[i], Length(OldString))) then
      begin
        Result := TempList[i];
        TempList.Free;
        exit;
      end
      else
        Result := '';
    end;
    TempList.Free;
  end; // corpnm

  // CorpBn
  if ((FrmNm = 'T2') and (NumInRange(FieldId, 1, 1, 1))) or
    ((FrmNm = 'S3') and ((NumInRange(FieldId, 6, 87, 9)) or (NumInRange(FieldId,
    211, 247, 4))))
  // or ((FrmNm = 'S3_2') and (NumInRange(FieldId,11,47,4)))
    or ((FrmNm = 'S9') and (NumInRange(FieldId, 6, 132, 9))) or
    ((FrmNm = 'S23') and (NumInRange(FieldId, 6, 120, 6))) or
    ((FrmNm = 'S24') and (NumInRange(FieldId, 23, 33, 2))) or
    ((FrmNm = 'S24') and (NumInRange(FieldId, 35, 63, 4))) or
    ((FrmNm = 'S28') and (NumInRange(FieldId, 50, 50, 1))) or
    ((FrmNm = 'S28') and (NumInRange(FieldId, 5, 47, 3))) or
    ((FrmNm = 'S39') and (NumInRange(FieldId, 5, 93, 4))) or
    ((FrmNm = 'S40') and (NumInRange(FieldId, 5, 93, 4))) or
    ((FrmNm = 'S41') and (NumInRange(FieldId, 6, 74, 4))) or
    ((FrmNm = 'S44') and (NumInRange(FieldId, 5, 74, 3))) or
    ((FrmNm = 'S45') and (NumInRange(FieldId, 4, 4, 1))) or
    ((FrmNm = 'S45') and (NumInRange(FieldId, 7, 7, 1))) or
    ((FrmNm = 'S49') and (NumInRange(FieldId, 6, 120, 6))) or
    ((FrmNm = 'S50') and (NumInRange(FieldId, 5, 125, 5))) then
  begin
    TempList := TStringList.Create;
    TempList.LoadFromFile(AppDir + '\' + 'CorpBn.txt');
    for i := 0 to TempList.Count - 1 do
    begin
      if UpperCase(OldString) = UpperCase
        (LeftStr(TempList[i], Length(OldString))) then
      begin
        Result := TempList[i];
        TempList.Free;
        exit;
      end
      else
        Result := '';
    end;
    TempList.Free;
  end; // CorpBn

  // Cities
  if ((FrmNm = 'T2') and (NumInRange(FieldId, 16, 16, 1))) or
    ((FrmNm = 'T2') and (NumInRange(FieldId, 32, 32, 1))) or
    ((FrmNm = 'T2') and (NumInRange(FieldId, 44, 44, 1))) or
    ((FrmNm = 'S14') and (NumInRange(FieldId, 7, 115, 12))) or
    ((FrmNm = 'S15') and (NumInRange(FieldId, 9, 149, 10))) or
    ((FrmNm = 'S22') and (NumInRange(FieldId, 6, 55, 7))) or
    ((FrmNm = 'S29') and (NumInRange(FieldId, 6, 55, 8))) then
  begin
    TempList := TStringList.Create;
    TempList.LoadFromFile(AppDir + '\' + 'Cities.Txt');
    for i := 0 to TempList.Count - 1 do
    begin
      if UpperCase(OldString) = UpperCase
        (LeftStr(TempList[i], Length(OldString))) then
      begin
        Result := TempList[i];
        TempList.Free;
        exit;
      end
      else
        Result := '';
    end;
    TempList.Free;
  end; // T2 Page 1

  // Charity
  if ((FrmNm = 'S2') and (NumInRange(FieldId, 404, 470, 3))) or
    ((FrmNm = 'S2') and (NumInRange(FieldId, 474, 486, 3))) or
    ((FrmNm = 'S2') and (NumInRange(FieldId, 490, 502, 3))) or
    ((FrmNm = 'S2') and (NumInRange(FieldId, 506, 518, 3))) then
  begin
    TempList := TStringList.Create;
    TempList.LoadFromFile(AppDir + '\' + 'Charity.txt');
    for i := 0 to TempList.Count - 1 do
    begin
      if UpperCase(OldString) = UpperCase
        (LeftStr(TempList[i], Length(OldString))) then
      begin
        Result := TempList[i];
        TempList.Free;
        exit;
      end
      else
        Result := '';
    end;
    TempList.Free;
  end; // T2 Page 1
end;

function PredictCharityList(RetNo: integer; FrmNm: string; FldId: integer;
  OldString: string): string;
var
  i: integer;
  TempList: TStringList;
  FNo: integer;
begin
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir + '\' + 'Charity.txt');
  for i := 0 to TempList.Count - 1 do
  begin
    if UpperCase(OldString) = UpperCase(LeftStr(TempList[i], Length(OldString)))
    then
    begin
      Result := TempList[i];
      TempList.Free;
      exit;
    end
    else
      Result := '';
  end;
  TempList.Free;
end;

function NumInRange(Num: integer; FromNum, ToNum, ByNum: integer): Boolean;
var
  i: integer;
begin
  Result := False;
  i := FromNum;
  repeat
    if Num = i then
    begin
      Result := True;
      exit;
    end;
    Inc(i, ByNum);
  until i > ToNum;
end;

procedure BuildSuperEntries(FullFlName: string);
var
  i, j: integer;
  DataList, ElmList, TempList: TStringList;
  Dir, s: string;
begin
  // 20170502 Igor >>>
  If not FileExists(FullFlName) then
    exit;
  DataList := TStringList.Create;
  try
    if not TSQLiteStorage.LoadToStringList(FullFlName, DataList,
      AppT2.SQLLitePassword.PassRFArray) then
      if not TFileStorage.LoadToStringList(FullFlName, DataList) then
        exit;
    ElmList := TStringList.Create;
    TempList := TStringList.Create;
    try
      BuildExperience('S2', 404, 470, 3, 'Charity.txt', ElmList, DataList);
      BuildExperience('S2', 474, 486, 3, 'Charity.txt', ElmList, DataList);
      BuildExperience('S2', 490, 502, 3, 'Charity.txt', ElmList, DataList);
      BuildExperience('S2', 506, 518, 3, 'Charity.txt', ElmList, DataList);

      BuildExperience('T2', 16, 16, 1, 'Cities.txt', ElmList, DataList);
      BuildExperience('T2', 32, 32, 1, 'Cities.txt', ElmList, DataList);
      BuildExperience('T2', 44, 44, 1, 'Cities.txt', ElmList, DataList);

      BuildExperience('S14', 7, 115, 12, 'Cities.txt', ElmList, DataList);
      BuildExperience('S15', 9, 149, 10, 'Cities.txt', ElmList, DataList);
      BuildExperience('S22', 6, 55, 7, 'Cities.txt', ElmList, DataList);
      BuildExperience('S29', 6, 55, 8, 'Cities.txt', ElmList, DataList);
      BuildExperience('T2', 3, 3, 1, 'CorpNm.txt', ElmList, DataList);
      BuildExperience('S3', 4, 85, 9, 'CorpNm.txt', ElmList, DataList);
      BuildExperience('S3', 210, 246, 4, 'CorpNm.txt', ElmList, DataList);
      BuildExperience('S9', 4, 130, 9, 'CorpNm.txt', ElmList, DataList);
      BuildExperience('S23', 5, 119, 6, 'CorpNm.txt', ElmList, DataList);
      BuildExperience('S24', 22, 32, 2, 'CorpNm.txt', ElmList, DataList);
      BuildExperience('S24', 34, 62, 4, 'CorpNm.txt', ElmList, DataList);
      BuildExperience('S25', 4, 64, 3, 'CorpNm.txt', ElmList, DataList);
      BuildExperience('S28', 49, 49, 1, 'CorpNm.txt', ElmList, DataList);
      BuildExperience('S28', 4, 46, 3, 'CorpNm.txt', ElmList, DataList);
      BuildExperience('S39', 4, 92, 4, 'CorpNm.txt', ElmList, DataList);
      BuildExperience('S40', 4, 92, 4, 'CorpNm.txt', ElmList, DataList);
      BuildExperience('S41', 5, 73, 4, 'CorpNm.txt', ElmList, DataList);
      BuildExperience('S44', 4, 73, 3, 'CorpNm.txt', ElmList, DataList);
      BuildExperience('S45', 3, 3, 1, 'CorpNm.txt', ElmList, DataList);
      BuildExperience('S45', 6, 6, 1, 'CorpNm.txt', ElmList, DataList);
      BuildExperience('S49', 5, 119, 6, 'CorpNm.txt', ElmList, DataList);
      BuildExperience('S50', 4, 124, 5, 'CorpNm.txt', ElmList, DataList);

      BuildExperience('T2', 1, 1, 1, 'CorpBn.txt', ElmList, DataList);
      BuildExperience('S3', 6, 87, 9, 'CorpBn.txt', ElmList, DataList);
      BuildExperience('S3', 211, 247, 4, 'CorpBn.txt', ElmList, DataList);
      // pg2
      BuildExperience('S9', 6, 132, 9, 'CorpBn.txt', ElmList, DataList);
      BuildExperience('S23', 6, 120, 6, 'CorpBn.txt', ElmList, DataList);
      BuildExperience('S24', 23, 33, 2, 'CorpBn.txt', ElmList, DataList);
      BuildExperience('S24', 35, 63, 4, 'CorpBn.txt', ElmList, DataList);
      BuildExperience('S28', 50, 50, 1, 'CorpBn.txt', ElmList, DataList);
      BuildExperience('S28', 5, 47, 3, 'CorpBn.txt', ElmList, DataList);
      BuildExperience('S39', 5, 93, 4, 'CorpBn.txt', ElmList, DataList);
      BuildExperience('S40', 5, 93, 4, 'CorpBn.txt', ElmList, DataList);
      BuildExperience('S41', 6, 74, 4, 'CorpBn.txt', ElmList, DataList);
      BuildExperience('S44', 5, 74, 3, 'CorpBn.txt', ElmList, DataList);
      BuildExperience('S45', 4, 4, 1, 'CorpBn.txt', ElmList, DataList);
      BuildExperience('S45', 7, 7, 1, 'CorpBn.txt', ElmList, DataList);
      BuildExperience('S49', 6, 120, 6, 'CorpBn.txt', ElmList, DataList);
      BuildExperience('S50', 5, 125, 5, 'CorpBn.txt', ElmList, DataList);

    finally
      TempList.Free;
      ElmList.Free;
    end;
  finally
    DataList.clear;
    DataList.Free;
  end;
  // 20170502 Igor <<<
end;

function ClaimingSurtaxCredit(RetNo: integer): Boolean;
begin
  Result := False;
end;

function CountSpacesInString(s: string): integer;
var
  i: integer;
begin
  Result := 0;
  i := 0;
  repeat
    if s[i] = ' ' then
      Inc(Result, 1);
    Inc(i, 1)
  until i > Length(s);
end;

function IsS12Designation(RetNo: integer): Boolean;
begin
  Result := False;
  // if UpperCase(FetchElm(RetNo, 'S12', 215)) = 'Y' then result := True;   //20191116
end;

function IsForeignAuthorizedBank(RetNo: integer): Boolean;
begin
  Result := False;
  if (UpperCase(FetchElm(RetNo, 'S34', 4)) = 'Y') or
    (UpperCase(FetchElm(RetNo, 'S38', 21)) = 'Y') then
    Result := True;
end;

procedure GetEOLParms(var OnlineNo: string; var Password: string;
  var url: string; var NetFileDir: string);
var
  i: integer;
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  for i := 0 to 4 do
    TempList.Add('');
  if FileExists(AppDir + '\' + 'CIF.d') then
  begin
    TempList.LoadFromFile(AppDir + '\' + 'CIF.d');
    if TempList.Count < 4 then
    begin
      for i := TempList.Count to 3 do
        TempList.Add('');
    end;
    OnlineNo := UpperCase(TempList[0]);
    Password := TempList[1];
    url := TempList[2];
    NetFileDir := TempList[3];
  end
  else
  begin
    OnlineNo := '';
    Password := '';
    url := '';
    NetFileDir := '';
  end;
  TempList.Free;
end;

function GetEOLAgentNo: string;
var
  TempList: TStringList;
begin
  Result := '';
  TempList := TStringList.Create;
  if FileExists(AppDir + '\' + 'CIF.d') then
  begin
    TempList.LoadFromFile(AppDir + '\' + 'CIF.d');
    Result := TempList[0];
  end;
  TempList.Free;
end;

procedure SaveEOLParms(OnlineNo, Password, url, NetFileDir: string);
var
  i: integer;
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  TempList.Add(OnlineNo);
  TempList.Add(Password);
  TempList.Add(url);
  TempList.Add(NetFileDir);
  TempList.SaveToFile(AppDir + '\' + 'CIF.d');
  TempList.Free;
end;

function GetDefaultNetFileDir: string;
begin
  Result := '';
  try
    if not SysUtils.DirectoryExists(AppDir + '\' + 'EolFiles') then // 20150702
    begin
      CreateDir(AppDir + '\' + 'EFILE');
      Result := AppDir + '\' + 'EFILE';
    end
    else
      Result := AppDir + '\' + 'EFile';
  except
    ShowMessage('Unable to create Directory' + Chr(13) + AppDir + '\' +
      'EFile');
  end; { try }
end;

function GetEfileUrl: string;
var
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir + '\' + 'EfileUrl.d');
  Result := TempList[0];
  TempList.Free;
end;

function MkCorEFileName(RetNo: integer): string; // 20170627
var
  OnlineNo, Password, url, NetFileDir: string;
  s: string;
  Chr39, Chr44: string;
begin
  Chr39 := Chr(39);
  Chr44 := Chr(44);

  GetEOLParms(OnlineNo, Password, url, NetFileDir);
  s := RemoveChar(GetCorpName(RetNo), '.');
  s := ReplaceChar(s, Chr39, '');
  s := ReplaceChar(s, Chr44, '');
  s := ReplaceChar(s, '/', '');
  s := ReplaceChar(s, '"', '');
  s := ReplaceChar(s, ':', ''); // 20100628
  s := ReplaceChar(s, ';', '');
  s := ReplaceChar(s, '?', ''); // 20121207
  s := ReplaceChar(s, '!', '');
  s := LeftStr(s, 30); //20260526 //s := LeftStr(s, 30);
  Result := NetFileDir + '\' + s + '-' + GetNineDigitAccountNumber(RetNo) +
    '.COR'; // 20170626
  // NetFileDir + '\' + GetNineDigitAccountNumber(RetNo) + '-' + s + '.COR';
end;

function MkWebEFileName(RetNo: integer): string; // 20170626
var
  OnlineNo, Password, url, NetFileDir: string;
  s: string;
  Chr39, Chr44: string;
begin
  Chr39 := Chr(39);
  Chr44 := Chr(44);

  GetEOLParms(OnlineNo, Password, url, NetFileDir);
  s := RemoveChar(GetCorpName(RetNo), '.');
  s := ReplaceChar(s, Chr39, '');
  s := ReplaceChar(s, Chr44, '');
  s := ReplaceChar(s, '/', '');
  s := ReplaceChar(s, '"', '');
  s := ReplaceChar(s, ':', ''); // 20100628
  s := ReplaceChar(s, ';', '');
  s := ReplaceChar(s, '?', ''); // 20121207
  s := ReplaceChar(s, '!', '');
  s := LeftStr(s, 30);
  Result := NetFileDir + '\' + s + '-' + GetNineDigitAccountNumber(RetNo) +
    'Submitted' + '.TXT'; // 20170626
  // NetFileDir + '\' + GetNineDigitAccountNumber(RetNo) + '-' + s + '.COR';
end;

function MkWebEFileResponseName(RetNo: integer): string; // 20170626
var
  OnlineNo, Password, url, NetFileDir: string;
  s: string;
  Chr39, Chr44: string;
begin
  Chr39 := Chr(39);
  Chr44 := Chr(44);

  GetEOLParms(OnlineNo, Password, url, NetFileDir);
  s := RemoveChar(GetCorpName(RetNo), '.');
  s := ReplaceChar(s, Chr39, '');
  s := ReplaceChar(s, Chr44, '');
  s := ReplaceChar(s, '/', '');
  s := ReplaceChar(s, '"', '');
  s := ReplaceChar(s, ':', ''); // 20100628
  s := ReplaceChar(s, ';', '');
  s := ReplaceChar(s, '?', ''); // 20121207
  s := ReplaceChar(s, '!', '');
  s := LeftStr(s, 30);
  Result := NetFileDir + '\' + s + '-' + GetNineDigitAccountNumber(RetNo) +
    'Received' + '.XML'; // 20170626
  // NetFileDir + '\' + GetNineDigitAccountNumber(RetNo) + '-' + s + '.COR';
end;

function ValidCertificate(RetNo, FNo, Elm: integer): Boolean;
var
  s: string;
begin
  Result := True;
  if FetchElmFNo(RetNo, FNo, Elm) = '' then  exit;
  //20251014
  If Length(FetchElmFNo(RetNo, FNo, Elm)) > 9 then Result:=False;
  {
  s := '00' + LeftStr(FetchElmFNo(RetNo, FNo, Elm), 7);
  if (not ValidSin(s) 0r   //210251024
   (Length(FetchElmFNo(RetNo, FNo, Elm)) <> 9) then  //(prefix with 00 to be 9 chars
    Result := False;
  }
end;

procedure StartAcrobatReader(WinTitle, PgmPath, PgmName: string);
var
  h: THandle;
begin
  h := FindWindow(PChar('' + WinTitle), nil);
  // FindWindow(nil,pchar(''+WinTitle));
  if h = 0 then
  begin
    h := ShellExecute(Application.Handle, nil, PChar('' + PgmName), nil,
      PChar('' + PgmPath), SW_SHOWMINIMIZED);
    if h > 32 then
    begin
      // showMessage('Acrobat cannot be started. Check version and path');
      exit;
    end;
  end;
end;

procedure ShowPdf(PgmPath, PgmFile: string);
var
  h: THandle;
begin
  h := ShellExecute(Application.Handle, nil, PChar('' + PgmFile), PChar(''),
    PChar('' + PgmPath), SW_RESTORE);
  if h <= 32 then
    ShowMessage('File ' + PgmFile + ' not found ');
end;

procedure ProcessPdfFile(RetNo: integer; FName: string; FNo: integer;
  NumFlds: integer; PdfFile: string);
var
  i: integer;
begin
  if Ret[RetNo].Frm[FNo].Count = 0 then
    InitFormData(RetNo, FNo);
  if ShowFieldIdSw then
    for i := 1 to NumFlds do
      StoreElm(RetNo, FNo, i, IntTostr(i));
  Calc(RetNo, FName);
  CreateAcrobatFdf(RetNo, FName, NumFlds, PdfFile);
  ShowPdf(PdfFormsDir, ChangeFileExt(PdfFile, '.fdf'));
  IsPdfDocumentOpen := True;
end;

procedure CreateAcrobatFdf(RetNo: integer; FName: string; NumFlds: integer;
  PdfFile: string);
var
  i, FNo: integer;
  TempList: TStringList;
  s: string;
  FullFdfFile: string;
begin

  FullFdfFile := PdfFormsDir + '\' + ChangeFileExt(PdfFile, '.fdf');
  // If FileExists(FullFdfFile) then Sysutils.DeleteFile(FullFdfFile);
  FNo := GetFormNo(FName);
  if FNo = 0 then
  begin
    ShowMessage(FName + ' FormName not found');
    exit;
  end;
  TempList := TStringList.Create;
  TempList.Add('%FDF-1.2');
  TempList.Add('%âãÏÓ');
  s := '1 0 obj<</FDF<</F(' + PdfFile +
    ')/ID[<fc6aca2a2a6b934893b1d65418b79ffb><fc6aca2a2a6b934893b1d65418b79ffb>]/Fields[';
  TempList.Add(s);
  (*
    //WORKS: s:=s+'<</T(Name)/V('+'Costantinoooooss'+')>>'+'<</T(Surname)/V('+'zantiris'+')>>'+']>>>>';
    // TempList.Add(S);
  *)
  /// ??? if ShowFieldIdSw then DO NOT STORE values ???
  // populate the input field of the acro form
  TempList.Add('<</T(' + 'input' + ')/V(' + FName + '&' + 'PSW??' + '&' +
    'Approval code???' + '&' + '|' + '&' + '50' + '&' + '120' + '&' + '180' +
    '&' + 'Speed??' + ')>>');
  TempList.Add('<</T(' + 'DataSource' + ')/V(' + 'VT' + ')>>');

  for i := 1 to NumFlds do
  begin
    TempList.Add('<</T(' + IntTostr(i) + ')/V(' + FetchElmFNo(RetNo, FNo,
      i) + ')>>');
  end;
  // s:=']>>>>';
  TempList.Add(']>>>>');
  TempList.Add('endobj');
  TempList.Add('trailer');
  TempList.Add('<</Root 1 0 R>>');
  TempList.Add('%%EOF');
  TempList.SaveToFile(FullFdfFile);
  TempList.Free;
end;

function GetFormNameOfPdfFile(PdfFile: string): string;
var
  i: integer;
begin
  Result := '';
  PdfFile := UpperCase(PdfFile);
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if UpperCase(FRec.PdfFile) = PdfFile then
    begin
      Result := FRec.FormName;
      exit;
    end;
  end;
end;

function GetPdfFileOfFName(FName: string): string;
var
  i: integer;
  FInst: string; // [3];
begin
  Result := '';
  FName := UpperCase(FName);
  FInst := UpperCase(ExtractFormInst(FName));
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if (UpperCase(FRec.FormName) = ExtractNonInstFormName(FName)) and
      (UpperCase(FRec.FormInst) = FInst) then
    begin
      Result := FRec.PdfFile;
      exit;
    end;
  end;
end;

procedure StoreClipboardValues(RetNo: integer; FNo: integer;
  WList: TStringList);
var
  i: integer;
begin
  i := 5;
  while WList[i] <> 'TheEnd' do
  begin
    if i > WList.Count - 2 then
      Break;
    if Numeric(WList[i]) then
      StoreElm(RetNo, FNo, MyStrToInt(WList[i]), WList[i + 1]);
    Inc(i, 2);
  end;
end;

procedure DoClipBoardChanged(RetNo: integer);
var
  i, FNo: integer;
  AMemo: TMemo;
  ClipboardText: string; // 20150702
  WList: TStringList;
  TempList: TStringList;
  h: THandle;
  ActionVerb: string;
  ActionParm: string;
  CurrentPdfFile: string;
  NumFlds: integer;
  FldCountS: string;
  FName: string;
  PdfFile: string;
  FullFdfFile: string;
  ClipbdDelim: string;
begin
  if Clipboard.AsText = '' then
    exit;
  ClipbdDelim := '|';
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    ClipboardText := Clipboard.AsText;
    if LeftStr(ClipboardText, 16) = 'From ' + LeftStr(AppName, 2) + ' Acrobat' + ClipbdDelim
    then
    begin
      WList := TStringList.Create;
      ParseWords(ClipboardText + ClipbdDelim, ClipbdDelim, WList);
      FName := WList[1]; // CurrentPdfFile
      if FName = '' then
        exit;
      NumFlds := MyStrToInt(WList[2]);
      ActionVerb := WList[3];
      ActionParm := WList[4];

      if NumFlds <> GetNumbFields(FName) then
      begin
        Application.BringToFront;
        ShowMessage(FName + ' should have ' + IntTostr(NumFlds) +
          ' fields. Contact VisualTax');
        // Exit;
      end;

      if (ActionVerb = 'calc') then
      begin
        FName := WList[1]; // CurrentPdfFile
        FNo := GetFormNo(FName);
        StoreClipboardValues(RetNo, FNo, WList);
        WList.Free;
        Calc(RetNo, FName);
        PdfFile := GetPdfFileOfFName(FName);
        CreateAcrobatFdf(RetNo, FName, NumFlds, PdfFile);
        ShowPdf(PdfFormsDir, ChangeFileExt(PdfFile, '.fdf'));
        Clipboard.clear;
      end;

      if ActionVerb = 'fld' then
      begin
        FName := WList[1];
        FNo := GetFormNo(FName);
        // get the data
        StoreClipboardValues(RetNo, FNo, WList);
        WList.Free;
        Calc(RetNo, FName);
        if ActionParm = 'autoCalcOn' then
        begin
          PdfFile := GetPdfFileOfFName(FName);
          CreateAcrobatFdf(RetNo, FName, NumFlds, PdfFile);
          ShowPdf(PdfFormsDir, ChangeFileExt(PdfFile, '.fdf'));
          Clipboard.clear;
        end;
      end;

      if (ActionVerb = 'FormsList') then
      begin
        FName := WList[1]; // CurrentPdfFile
        FNo := GetFormNo(FName);
        // get the data
        StoreClipboardValues(RetNo, FNo, WList);
        WList.Free;
        Calc(RetNo, FName);
        Application.BringToFront;
        Clipboard.clear;
      end;

      if (ActionVerb = 'NextInst') then
      begin
        FName := WList[1]; // CurrentPdfFile
        FName := GetNextInstanceFName(RetNo, FName);
        FNo := GetFormNo(FName);
        NumFlds := GetNumbFields(FName);
        CreateAcrobatFdf(RetNo, FName, NumFlds, PdfFile);
        ShowPdf(PdfFormsDir, ChangeFileExt(PdfFile, '.fdf'));
        Clipboard.clear;
      end;

      if (ActionVerb = 'PrevInst') then
      begin
        FName := WList[1]; // CurrentPdfFile
        FName := GetPrevInstanceFName(RetNo, FName);
        FNo := GetFormNo(FName);
        NumFlds := GetNumbFields(FName);
        CreateAcrobatFdf(RetNo, FName, NumFlds, PdfFile);
        ShowPdf(PdfFormsDir, ChangeFileExt(PdfFile, '.fdf'));
        Clipboard.clear;
      end;

      if ActionVerb = 'open' then
      begin
        PdfFile := ActionParm;
        FName := GetFormNameOfPdfFile(PdfFile);
        FNo := GetFormNo(FName);
        NumFlds := GetNumbFields(FName);
        CreateAcrobatFdf(RetNo, FName, NumFlds, PdfFile);
        ShowPdf(PdfFormsDir, ChangeFileExt(PdfFile, '.fdf'));
        Clipboard.clear;
      end;

      if (ActionVerb = 'close') then
      begin
        Application.BringToFront;
        FName := WList[1]; // GetFormNameOfPdfFile(PdfFile);
        FNo := GetFormNo(FName);
        // get the data
        StoreClipboardValues(RetNo, FNo, WList);
        WList.Free;
        Calc(RetNo, FName);
        if FileExists(FullFdfFile) then
          SysUtils.DeleteFile(FullFdfFile);
        IsPdfDocumentOpen := False;
        // DeEnlistFormNo(RetNo,FormNo);
        // Ret[RetNo].Frm[FormNo].Free;
        Clipboard.clear;
      end;

      if (ActionVerb = 'print') then
      begin
        FName := WList[1]; // CurrentPdfFile
        FNo := GetFormNo(FName);
        // get the data
        StoreClipboardValues(RetNo, FNo, WList);
        WList.Free;
        Calc(RetNo, FName);
        Clipboard.clear;
      end;
    end // has legitimate text
    else;
  end; // has text
end;

procedure DoPdfFile(RetNo: integer; FName: string; PdfFile: string);
var
  FNo, NumFlds: integer;
begin
  FNo := GetFormNo(FName);
  NumFlds := GetNumbFields(FName);
  if FNo = 0 then
  begin
    ShowPdf(PdfFormsDir, PdfFile);
    exit;
  end;
  ProcessPdfFile(RetNo, FName, FNo, NumFlds, PdfFile);
end;

function KillApp(const sCapt: PChar): Boolean;
var
  AppHandle: THandle;
begin
  AppHandle := FindWindow(nil, sCapt);
  Result := PostMessage(AppHandle, WM_QUIT, 0, 0);
end;

function GetNextInstanceFName(RetNo: integer; FName: string): string;
var
  CInst: integer;
  NewFormName: string; // [10];
begin
  {
    If Ret[RetNo].FrmHasData[FormNo] = False then
    if MessageDlg('Current statement has not been used. Show next?',
    mtInformation, [mbYes, mbNo], 0) = mrNo then exit;
  }
  CInst := StrToInt(MidStr(ExtractFormInst(FName), 2, 2));
  NewFormName := ExtractNonInstFormName(FName) + '#' + IntTostr(CInst + 1);
  if GetFormNo(NewFormName) = 0 then { instance does not exist }
  begin
    if IsFormMultiPage(FName) then { do all pages }
    begin
      AddPageInstance(RetNo, ExtractFormRootName(FName) + '_1',
        '#' + IntTostr(CInst + 1));
      AddOtherPagesInstance(RetNo, ExtractFormRootName(FName) + '_1',
        '#' + IntTostr(CInst + 1));
    end
    else
      AddPageInstance(RetNo, ExtractNonInstFormName(FName),
        '#' + IntTostr(CInst + 1));
  end;
  Result := NewFormName;
end;

function GetPrevInstanceFName(RetNo: integer; FName: string): string;
var
  CInst: integer;
begin
  Result := FName;
  CInst := StrToInt(MidStr(ExtractFormInst(FName), 2, 2));
  if CInst > 1 then
  begin
    Dec(CInst);
    Result := ExtractNonInstFormName(FName) + '#' + IntTostr(CInst);
  end;
end;

procedure ConnectToWeb(url: string);
var
  h: THandle;
begin
  Screen.Cursor := crHourGlass;
  h := ShellExecute(MainForm.Handle, 'open', PChar('' + url), nil, nil,
    Sw_Show);
  if h <= 32 then
    ShowMessage('Connection failed');
  Screen.Cursor := crDefault;
end;

function GetAcrobatFdfDir: string;
var
  CurrentUserName: string;
begin
  CurrentUserName := '';
  GetWindowsUserName(CurrentUserName);
  Result := 'C:\Documents and Settings\' + CurrentUserName + '\My Documents\';
end;

procedure AcrobatMinimize;
var
  h: THandle;
begin
  h := FindWindow('Adobe Reader', nil);
  if h <> 0 then
    ShowWindow(h, SW_MINIMIZE);
end;

function AcrobatReaderLoaded: Boolean;
var
  h: THandle;
begin
  if FindWindow(nil, 'Adobe Reader') > 0 then
    Result := True
  else
    Result := False;
end;

procedure Checkupdates(WindowHandle: Word; AppTitle: string);
var
  h: THandle;
  TempList: TStringList; // AppTitle:String;
  spaceDelimiter, quotes, Params, PgmPath: string;
begin
  Screen.Cursor := crHourGlass;

  spaceDelimiter := ' ';
  quotes := '"';
  Params := spaceDelimiter + quotes + AppTitle + quotes
  // params := spaceDelimiter+quotes+Application.Title+quotes
    + spaceDelimiter + quotes + AppUpdateDate + quotes + spaceDelimiter + quotes
    + AppRelease + quotes + spaceDelimiter + quotes + 'c:\Downloads' + quotes +
    spaceDelimiter + quotes + AppDir + quotes + spaceDelimiter + quotes +
    'http://www.visualtax.com/downloads/vtUpdate/vtVersions.xml' + quotes;

  // 20130411 //add path when executing \vtchkupd.exe
  PgmPath := quotes + AppDir + '\vtchkupd.exe' + quotes;
  // C:\Delphi\T1\vtchkupd.exe
  h := ShellExecute(WindowHandle, 'open', PChar('' + PgmPath),
    PChar('' + Params), nil, Sw_Show);
  // h := ShellExecute(WindowHandle,'open','VTChkUpd.Exe',Pchar(' '+params),Nil,Sw_Show);

  if h <= 32 then
  begin
    ShowMessage('The Updater program cannot be found.' + Chr(13) +
      'Did you download the VTChkUpd.EXE program' + Chr(13) +
      'and unzipped into the program folder?');
    Screen.Cursor := crDefault;
    exit;
  end;
  // now save the date
  TempList := TStringList.Create;
  TempList.Add(FormatDateTime('yyyy-mm-dd', Date));
  TempList.SaveToFile(AppDir + '\' + 'LastUpdCheck.txt');
  TempList.Free;
  Screen.Cursor := crDefault;
end;

function GetLastUpdCheck: string;
var
  TempList: TStringList;
begin
  if not FileExists(AppDir + '\' + 'LastUpdCheck.txt') then
  begin
    Result := '';
    exit;
  end;
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir + '\' + 'LastUpdCheck.txt');
  Result := TempList[0];
  TempList.Free;
end;

function TimeToCheckUpdates: Boolean;
var
  i: integer;
  LastUpdateDone: string;
  mm: string;
  DaysFreq: integer;
  D2, D1: string;
begin
  LastUpdateDone := GetLastUpdCheck;
  if LastUpdateDone = '' then
  begin
    Result := True;
    exit;
  end;
  // there is previous update
  Result := False;
  DaysFreq := GetUpdateFrequency;
  if DaysFreq = 0 then
  begin
    Result := False;
    exit;
  end;
  D2 := FormatDateTime('yyyy/mm/dd', Date);
  D2 := ReplaceChar(D2, '-', '/'); // 20090517
  D1 := ReplaceChar(LastUpdateDone, '-', '/'); // =yyyy/mm/dd

  if DateDiffYMD(D1, D2) > DaysFreq then
    Result := True;

end;

function GetUpdateFrequency: integer;
var
  TempList: TStringList;
begin
  if FileExists(AppDir + '\' + 'UpdSch.txt') then
  begin // load schedule
    TempList := TStringList.Create;
    TempList.LoadFromFile(AppDir + '\' + 'UpdSch.txt');
    Result := MyStrToInt(AllTrim(TempList[0]));
  end
  else
    Result := 1;
end;

procedure SetUpdateFrequency(Freq: integer);
var
  TempList: TStringList;
begin
  if FileExists(AppDir + '\' + 'UpdSch.txt') then
    exit
  else
  begin // load schedule
    TempList := TStringList.Create;
    TempList.Add(IntTostr(Freq));
    TempList.SaveToFile(AppDir + '\' + 'UpdSch.txt');
    TempList.Free;
  end
end;

function DtDiff(D1: string; D2: string): integer;
{ D1,D2 in form YYYYMMDD }
var
  Date1, Date2: TDateTime;
begin
  // 20170728 Igor>>>
  if D1.IsEmpty or D2.IsEmpty then
    exit(0)
  else if not TryYYYYMMDDToDate(D1, Date1) or not TryYYYYMMDDToDate(D2, Date2)
  then
  begin
    MessageDlg('Invalid Date formats: ' + D1 + ' ' + D2, mtError, [mbok], 0);
    exit(365);
  end
  else
    Result := DateDiff(Date2, Date1);

  // if (D1 = '') or (d2 = '') then
  // begin result := 0;
  // exit;
  // end;
  // D1 := YYYYMMDDToWinFormat(D1);
  // D2 := YYYYMMDDToWinFormat(D2);
  // try
  // Date1 := StrToDateTime(D1);
  // Date2 := StrToDateTime(D2);
  // Result := StrToInt(FloatToStr(Date2 - Date1)) + 1;
  // except
  // on exception do
  // begin
  // ShowMessage('Invalid Date formats: ' + D1 + ' ' + D2);
  // result := 365;
  // end;
  // end;
  // 20170728 Igor<<<
end;

// 20170728 Igor>>>
// function YYYYMMDDToWinFormat(Dt: string): string;
/// /comes in as yyyy/mm/dd : to be concverted to say dd/mm/yyyy
// var
// WinDateFormat, Sep, WinBootDir: string;
// mm, dd, yyyy: string;
// begin
// Result := Dt;
// WinDateFormat := UpperCase(FormatSettings.ShortDateFormat); //delphi //20150622
// Sep := FormatSettings.DateSeparator; // '/'; //20150622
// mm := MidStr(Dt, 6, 2);
// dd := RightStr(Dt, 2);
// yyyy := LeftStr(Dt, 4);
//
// if UpperCase(LeftStr(WinDateFormat, 1)) = 'M' then {to MM/DD/YYYY}
// begin
// Result := mm + Sep + dd + Sep + yyyy
// end
// else if UpperCase(LeftStr(WinDateFormat, 1)) = 'D' then {to DD/MM/YYYY}
// begin
// Result := dd + Sep + mm + Sep + yyyy; //20090216
// end
// else if UpperCase(LeftStr(WinDateFormat, 1)) = 'Y' then {to YYYY/MM/DD}
// begin
// Result := yyyy + Sep + mm + Sep + dd; //20090216
// end;
// end;
// 20170728 Igor<<<

// 20170904 Igor>>>
// function GetTrFolder: string;
// var
// TempList: TStringList;
// begin
// result := '';
// TempList := TStringList.Create;
// if FileExists(AppDir + '\' + 'TrFolder.d') then
// begin
// TempList.LoadFromFile(AppDir + '\' + 'TrFolder.d');
// Result := TempList[0];
// TempList.Free;
// Exit;
// end;
// end;
//
// function IsTrLoaded: Boolean;
// begin
// if GetTrHandle <> 0 then
// result := True
// else
// result := False;
// end;
//
// function GetTrHandle: HWND;
// begin
// result := FindWindow(pChar('TTrEngine'), nil);
// end;
//
// procedure LinkToTR(SearchItem: string);
// var
// h: THandle;
// begin
// TrFolder := GetTrFolder;
// h := GetTrHandle;
// if h <> 0 then
// begin
// ShowWindow(h, SW_MAXIMIZE);
// Clipboard.AsText := 'From T2|Search|' + SearchItem;
// Application.Minimize;
// end
// else
// begin
// Application.Minimize;
// LoadTr(TrFolder);
// end
// end;
//
// procedure LoadTr(TrFolder: string);
// var
// h: THandle;
// begin
// //20160714
// h := ShellExecute(MainForm.Handle, nil,
// Pchar('' + TrFolder + '\TR2015.EXE'), nil, '', SW_RESTORE);
// //Delay(2000);
// if H <= 32 then
// ShowMessage('The TR-2015 was not installed in ' + TrFolder);
// end;
// 20170904 Igor<<<

procedure LinkToCICA(Ln: string);
var
  h: THandle;
  url: PChar;
begin
  url := PChar
    ('http://www.knotia.ca/Knowledge/LBL/Jump.cfm?kType=93&LBLGuideID=1&ChapterID=1&line='
    + Ln);
  Screen.Cursor := crHourGlass;
  h := ShellExecute(MainForm.Handle, 'open', url, nil, nil, Sw_Show);
  if h <= 32 then
    ShowMessage('Connection failed');
  Screen.Cursor := crDefault;
  // http://www.knotia.ca/Knowledge/LBL/Jump.cfm?kType=93&LBLGuideID=1&ChapterID=1&line=135
end;

procedure DataChangedRtn(RetNo: integer; FormName: string);
begin
  Ret[RetNo].Changed := True;
  // Ret[RetNo].Saved := False;
  { save instance data }
  Calc(RetNo, FormName);
  CalcAffectedBy(RetNo, FormName);
  if IsFormMultiPage(FormName) then
    CalcMultiPageForm(RetNo, FormName);
  if StatusBarSw = True then
    Recalc(RetNo, FormName)
  else
  begin
    Ret[RetNo].FedCalcStatus := False;
    Ret[RetNo].OntCalcStatus := False;
    Ret[RetNo].AlbCalcStatus := False;
  end;
end;

function GetShowOpenedFormsIndicator: Boolean;
var
  TempList: TStringList;
  s: string;
begin
  Result := False;
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir + '\' + 'OthOpt.D');
  s := TempList[2];
  if UpperCase(s[30]) = 'Y' then
    Result := True;
  TempList.Free;
end;

function IsFirstPageOfForm(FormName: string): Boolean;
var
  i: integer;
begin
  Result := False;
  i := Length(FormName);
  while i > 0 do
  begin
    if (FormName[i] = '_') and (AllTrim(MidStr(FormName, i + 1, 2)) = '1') then
    begin
      Result := True;
      exit;
    end;
    Dec(i);
  end;
end;

// 20160627  IGOR
procedure UpdatePrintDate(RetNo: integer; DataDir: string; flName: string);
var
  FNo: integer;
  // TempList: TStringList; //20170329 Igor
begin
  FNo := GetFormNo('STATUS');
  Ret[RetNo].Frm[FNo].Strings[8] := User.UserName; // 20170112 Igor
  Ret[RetNo].Frm[FNo].Strings[9] := FormatDateTime('yyyy/mm/dd', Date);
  { DateToStr(Date); }
  Ret[RetNo].Frm[FNo].Strings[10] := TimeToStr(Time);
  Ret[RetNo].Changed := True; // 20170329 Igor
  { //20160627 Igor
    if FileExists(DataDir + '\' + FlName) then
    begin
    TempList := TstringList.Create;
    Templist.LoadFromFile(DataDir + '\' + FlName);
    Templist.Add('F' + Delimiter + 'STATUS' + Delimiter + Delimiter);
    TempList.Add('D' + Delimiter + '8' + Delimiter + UserName + Delimiter);
    TempList.Add('D' + Delimiter + '9' + Delimiter + FormatDateTime('yyyy/mm/dd', Date) + Delimiter);
    TempList.Add('D' + Delimiter + '10' + Delimiter + TimeToStr(Time) + Delimiter);
    Templist.SaveToFile(DataDir + '\' + FlName);
    TempList.Free;
    end;
  }
end;
(*
  //20160625
  Procedure UpdatePrintDate(RetNo:Integer;DataDir:string;FlName:string);
  var FNo :integer; TempList :TStringList;
  ADConnection: TADConnection;
  Table1: TADTable;
  begin
  EXIT;  //20160626  IT Damages the return amd makes the return unreadable!..
  End;
*)
(*
  FNo := GetFormNo('STATUS');
  Ret[RetNo].Frm[Fno].Strings[4] := '03';
  Ret[RetNo].Frm[Fno].Strings[8] := UserName;
  Ret[RetNo].Frm[Fno].Strings[9] := FormatDateTime('yyyy-mm-dd',Date);
  Ret[RetNo].Frm[Fno].Strings[10] := TimeToStr(Time);
  {now update the data base with RTU dates}
  //20150922 Igor
  ADConnection:= TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  SetTableName(ADConnection, Table1, DataDir + '\' + ClientsDBLite, ClientsTableLite, 'File_Name');
  if Table1.FindKey([FlName]) then
  begin
  Table1.Edit;
  Table1.FieldByName('Prp_Status').AsString := FetchElm(RetNo,'STATUS',4);
  Table1.FieldByName('Printed_by').AsString := FetchElm(RetNo,'STATUS',8);
  Table1.FieldByName('Printed_dt').AsString := FetchElm(RetNo,'STATUS',9);
  Table1.FieldByName('Printed_tm').AsString := FetchElm(RetNo,'STATUS',10);
  Table1.Post;
  end;
  Table1.Free;
  end;
*)
(* //20160625
  procedure UpdatePrintDate(RetNo: Integer; DataDir: string; FlName: string);
  var
  FNo: integer;
  TempList: TStringList;
  begin
  FNo := GetFormNo('STATUS');
  Ret[RetNo].Frm[Fno].Strings[8] := UserName;
  Ret[RetNo].Frm[Fno].Strings[9] := FormatDateTime('yyyy/mm/dd', Date);
  {DateToStr(Date);}
  Ret[RetNo].Frm[Fno].Strings[10] := TimeToStr(Time);

  if FileExists(DataDir + '\' + FlName) then
  begin
  TempList := TstringList.Create;
  Templist.LoadFromFile(DataDir + '\' + FlName);
  Templist.Add('F' + Delimiter + 'STATUS' + Delimiter + Delimiter);
  TempList.Add('D' + Delimiter + '8' + Delimiter + UserName + Delimiter);
  TempList.Add('D' + Delimiter + '9' + Delimiter + FormatDateTime('yyyy/mm/dd', Date) + Delimiter);
  TempList.Add('D' + Delimiter + '10' + Delimiter + TimeToStr(Time) + Delimiter);
  Templist.SaveToFile(DataDir + '\' + FlName);
  TempList.Free;
  end;
  end;
*)

(*
  //20160627  IGOR
  procedure UpdatePrintDate(RetNo: Integer; DataDir: string; FlName: string);
  var
  FNo: integer;
  TempList: TStringList;
  begin
  FNo := GetFormNo('STATUS');
  Ret[RetNo].Frm[Fno].Strings[8] := User.UserName; //20170112 Igor
  Ret[RetNo].Frm[Fno].Strings[9] := FormatDateTime('yyyy/mm/dd', Date);
  {DateToStr(Date);}
  Ret[RetNo].Frm[Fno].Strings[10] := TimeToStr(Time);

  {//20160627 Igor
  if FileExists(DataDir + '\' + FlName) then
  begin
  TempList := TstringList.Create;
  Templist.LoadFromFile(DataDir + '\' + FlName);
  Templist.Add('F' + Delimiter + 'STATUS' + Delimiter + Delimiter);
  TempList.Add('D' + Delimiter + '8' + Delimiter + UserName + Delimiter);
  TempList.Add('D' + Delimiter + '9' + Delimiter + FormatDateTime('yyyy/mm/dd', Date) + Delimiter);
  TempList.Add('D' + Delimiter + '10' + Delimiter + TimeToStr(Time) + Delimiter);
  Templist.SaveToFile(DataDir + '\' + FlName);
  TempList.Free;
  end;
  }
  end;
  (*
  //20160625
  Procedure UpdatePrintDate(RetNo:Integer;DataDir:string;FlName:string);
  var FNo :integer; TempList :TStringList;
  ADConnection: TADConnection;
  Table1: TADTable;
  begin
  EXIT;  //20160626  IT Damages the return amd makes the return unreadable!..
  End;
*)
(*
  FNo := GetFormNo('STATUS');
  Ret[RetNo].Frm[Fno].Strings[4] := '03';
  Ret[RetNo].Frm[Fno].Strings[8] := UserName;
  Ret[RetNo].Frm[Fno].Strings[9] := FormatDateTime('yyyy-mm-dd',Date);
  Ret[RetNo].Frm[Fno].Strings[10] := TimeToStr(Time);
  {now update the data base with RTU dates}
  //20150922 Igor
  ADConnection:= TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  SetTableName(ADConnection, Table1, DataDir + '\' + ClientsDBLite, ClientsTableLite, 'File_Name');
  if Table1.FindKey([FlName]) then
  begin
  Table1.Edit;
  Table1.FieldByName('Prp_Status').AsString := FetchElm(RetNo,'STATUS',4);
  Table1.FieldByName('Printed_by').AsString := FetchElm(RetNo,'STATUS',8);
  Table1.FieldByName('Printed_dt').AsString := FetchElm(RetNo,'STATUS',9);
  Table1.FieldByName('Printed_tm').AsString := FetchElm(RetNo,'STATUS',10);
  Table1.Post;
  end;
  Table1.Free;
  end;
*)
(* //20160625
  procedure UpdatePrintDate(RetNo: Integer; DataDir: string; FlName: string);
  var
  FNo: integer;
  TempList: TStringList;
  begin
  FNo := GetFormNo('STATUS');
  Ret[RetNo].Frm[Fno].Strings[8] := UserName;
  Ret[RetNo].Frm[Fno].Strings[9] := FormatDateTime('yyyy/mm/dd', Date);
  {DateToStr(Date);}
  Ret[RetNo].Frm[Fno].Strings[10] := TimeToStr(Time);

  if FileExists(DataDir + '\' + FlName) then
  begin
  TempList := TstringList.Create;
  Templist.LoadFromFile(DataDir + '\' + FlName);
  Templist.Add('F' + Delimiter + 'STATUS' + Delimiter + Delimiter);
  TempList.Add('D' + Delimiter + '8' + Delimiter + UserName + Delimiter);
  TempList.Add('D' + Delimiter + '9' + Delimiter + FormatDateTime('yyyy/mm/dd', Date) + Delimiter);
  TempList.Add('D' + Delimiter + '10' + Delimiter + TimeToStr(Time) + Delimiter);
  Templist.SaveToFile(DataDir + '\' + FlName);
  TempList.Free;
  end;
  end;
*)

function FillSignatureDates;
var
  s: string;
  TempList: TStringList;
begin
  Result := OptRec.Prp_dates;
end;

function ValidPhoneNo(s: string): Boolean;
begin
  Result := False;
  if MidStr(s, 4, 1) = '-' then
    s := AllTrim(RemoveChar(s, '-'));
  if (Length(s) = 7) and (Numeric(s) = True) then
    Result := True;
end;

procedure UpdateAllPagesDataIndicator(RetNo: integer; FName: string);
// fname is in format aaaaaaa_n#nn
// If any page has data then all pages are set to True
var
  i, j, FNo, MxPg: integer;
  RootFName, FInst: string;
var
  FNoArray: array [1 .. 10] of integer;
  AnyPageHasData: Boolean;
begin
  exit; // 20140609
  {
    MxPg:=GetFormMxPg(FName);
    RootFName:=ExtractFormRootName(FName);
    FInst:=ExtractFormInst(FName);
    AnyPageHasData:=False;
    //get all FNO s
    For i:=Low(FNoArray) to High(FNoArray) do FNoArray[i]:=0;  //initialize
    For i:=1 to MxPg do
    FNoArray[i]:=GetFormNo(RootFName+'_'+AllTrim(IntToStr(i))+FInst);

    For i:=1 to MxPg do   //if any is true then this one also
    begin
    If Ret[RetNo].FrmHasData[FNoArray[i]] =True then
    begin  //make them all
    For j:=1 to MxPg do
    begin
    Ret[RetNo].FrmHasData[FNoArray[j]]:=True;
    end;
    end;
    end;
  }
end;

procedure SaveScreenSettings(Sc: Real; ScChar: Real; ScChange: Real;
  LeftPanelWidth: LongInt);
var
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  TempList.Add(FormatFloat('##.##', Sc));
  TempList.Add(FormatFloat('##.##', ScChar));
  TempList.Add(FormatFloat('##.##', ScChange));
  TempList.Add(IntTostr(LeftPanelWidth));
  TempList.SaveToFile(AppDir + '\' + 'ScrSize.d');
  TempList.Free;
end;

procedure GetScreenSettings(var Sc: Real; var ScChar: Real; var ScChange: Real;
  var LeftPanelWidth: LongInt);
var
  TempList: TStringList;
begin
  Sc := 1;
  ScChar := 1;
  ScChange := 0;
  LeftPanelWidth := Screen.Width div 7;
  TempList := TStringList.Create;
  if FileExists(AppDir + '\' + 'ScrSize.d') then
  begin
    TempList.LoadFromFile(AppDir + '\' + 'ScrSize.d');
    Sc := VL(TempList[0]);
    ScChar := VL(TempList[1]);
    ScChange := VL(TempList[2]);
    LeftPanelWidth := MyStrToInt(TempList[3]);
  end;
  TempList.Free;
end;

procedure InitMostRecentFiles(HowMany: integer);
// 20171201 Igor>>>
var
  i: integer;
  ADConnection: TADConnection;
  AQuery: TADQuery;
  s: string;
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  try
    ADConnection := TADConnection.Create(Application);
    AQuery := TADQuery.Create(Application);
    try
      SqlLoadDBFromFile(ADConnection, AQuery, OptRec.Dir_Cur + '\' +
        ClientsDBLite, '');
      if ADConnection.Connected then
      begin
        try
          with AQuery do
          begin
            SQL.Add('Select * from ' + ClientsTableLite);
            SQL.Add(' ORDER BY Updated_Dt DESC');
            Prepare;
            Open;
            First;
            while not Eof do
            begin
              // 20200817 Igor >>>
              s := AllTrim(AQuery.FieldByName('CORP_NAME').AsString) +
                RecentDelim + AQuery.FieldByName('Updated_Dt').AsString +
                RecentDelim + AQuery.FieldByName('Updated_tm').AsString +
                RecentDelim + AQuery.FieldByName('File_Name').AsString +
                RecentDelim;
              // 20200817 Igor ,,,
              TempList.Add(s);
              if TempList.Count > HowMany then
                Break;
              Next;
            end;
          end;
        except
          on E: Exception do
            MessageDlg(E.Message, mtError, [mbok], 0);
        end; // except
        for i := 0 to TempList.Count - 1 do
          TempList[i] := TempList[i] + ' ' + OptRec.Dir_Cur; // add the dir
      end
    finally
      AQuery.Close;
      AQuery.Free;
      ADConnection.Free;
    end;
    TempList.SaveToFile(AppDir + '\' + RecentFlName);
  finally
    TempList.Free;
  end;
  // 20171201 Igor<<<
end;

procedure ConvertMostRecentFiles; // 20201015 Igor
var
  L: TStringList;
  i: integer;
  cRow, cName, cDate, cTime, cFile, cDir: string;
  NeedSave: Boolean;
begin
  if not FileExists(AppDir + '\' + RecentRFlName) then
    exit;
  NeedSave := False;
  L := TStringList.Create;
  try
    L.LoadFromFile(AppDir + '\' + RecentRFlName);
    for i := 0 to L.Count - 1 do
    begin
      cRow := L.Strings[i];
      if cRow.IsEmpty then
        continue;
      if not((Copy(cRow, 31, 1) = ' ') and (Copy(cRow, 42, 1) = ' ') and
        (Copy(cRow, 53, 1) = ' ') and (Copy(cRow, 69, 1) = ' ') and
        (Copy(cRow, 32, 3) = '202')) then
        Break;
      cName := Copy(cRow, 1, 30);
      cDate := Copy(cRow, 32, 10);
      cTime := Copy(cRow, 43, 10);
      cFile := Copy(cRow, 54, 15);
      cDir := Copy(cRow, 70, Length(cRow));
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

procedure UpdateMostRecentFiles(RetNo: integer; Dir, flName, Sin: string);
var
  i, k, MaxReturns: integer;
  TempList1, TempList2: TStringList;
  s: string;
begin
  TempList1 := TStringList.Create;
  TempList2 := TStringList.Create;
  if FileExists(AppDir + '\' + RecentFlName) then
    TempList1.LoadFromFile(AppDir + '\' + RecentFlName);
  // 20201015 Igor >>>
  s := GetCorpName(RetNo) + RecentDelim + FormatDateTime('yyyy-mm-dd', Date) +
    RecentDelim + TimeToStr(Time) + RecentDelim + flName + RecentDelim + Dir;
  // 20201015 Igor <<<
  // First remove it if it exists
  k := IsInMostRecentReturns(flName, TempList1);
  if k > -1 then
    TempList1.Delete(k);
  // then add it as first
  TempList2.Add(s);
  // add the existing ones
  MaxReturns := TempList1.Count - 1;
  if MaxReturns > 30 then
    MaxReturns := 30;
  for i := 0 to MaxReturns do
    TempList2.Add(TempList1[i]);
  // save it
  TempList2.SaveToFile(AppDir + '\' + RecentFlName);
  TempList1.Free;
  TempList2.Free;

  MainFormT2.ShowMostRecentReturns;
end;

(*
  procedure InitMostRecentFiles(HowMany: Integer);
  var
  i: Integer;
  ADConnection: TADConnection;
  AQuery: TADQuery;
  s, WhereClause: string;
  TempList: TStringList;
  begin
  TempList := TStringList.Create;

  //20150923 Igor
  ADConnection:= TADConnection.Create(Application);
  AQuery := TADQuery.Create(Application);
  SqlLoadDBFromFile(ADConnection, AQuery, OptRec.Dir_Cur +'\'+ ClientsDBLite, '');

  try
  WhereClause := '';
  {------------}
  with AQuery do
  begin
  SQL.Add('Select * from '+ClientsTableLite); //20150923 Igor
  //SQL.Add( WhereClause);
  Sql.Add(' ORDER BY Updated_Dt DESC');
  Prepare;
  open;

  i := 1;
  First;
  repeat
  s := PaddR(AllTrim(Aquery.FieldByName('CORP_NAME').AsString), 30) + ' '
  + PaddR(Aquery.FieldByName('Updated_Dt').AsString, 10) + ' '
  + PAddR(Aquery.FieldByName('Updated_tm').AsString, 10) + ' '
  + PaddR(Aquery.FieldByName('File_Name').AsString, 15);
  TempList.Add(s);
  if TempList.Count > HowMany then
  break;
  Next;
  until Eof;
  AQuery.Close;
  AQuery.Free;
  ADConnection.Free;
  end;
  except
  on E: Exception do
  MessageDlg(E.Message, mtError, [mbok], 0);
  end; //except
  for i := 0 to TempList.Count - 1 do
  TempList[i] := TempList[i] + ' ' + OptRec.Dir_Cur; //add the dir
  TempList.SaveToFile(AppDir + '\' + RecentFlName);
  TempList.Free;
  end;

  procedure UpdateMostRecentFiles(RetNo: Integer; Dir, FlName, Sin: string);
  var
  i, k, MaxReturns: Integer;
  TempList1, TempList2: TStringList;
  s: string;
  begin
  TempList1 := TStringList.Create;
  TempList2 := TStringList.Create;
  if FileExists(AppDir + '\' + RecentFlName) then
  TempList1.LoadFromFile(AppDir + '\' + RecentFlName);
  s := PaddR(GetCorpName(RetNo), 30) + ' '
  + PaddR(FormatDateTime('yyyy-mm-dd', Date), 10) + ' '
  + PAddR(TimeToStr(Time), 10) + ' '
  + PaddR(FlName, 15) + ' '
  + Dir;
  //First remove it if it exists
  k := IsInMostRecentReturns(FlName, TempList1);
  if K > -1 then
  TempList1.Delete(k);
  //then add it as first
  TempList2.Add(S);
  //add the existing ones
  MaxReturns := TempList1.Count - 1;
  if MaxReturns > 30 then
  MaxReturns := 30;
  for i := 0 to MaxReturns do
  TempList2.Add(TempList1[i]);
  //save it
  TempList2.SaveToFile(AppDir + '\' + RecentFlName);
  TempList1.Free;
  TempList2.Free;

  MainFormT2.ShowMostRecentReturns;
  end;
*)
function IsInMostRecentReturns(flName: string;
  MostRecentList: TStringList): integer;
var
  i, LengthOfKeyWord: integer;
  A: TArray<string>; // 20201015 Igor
begin
  Result := -1;
  if MostRecentList.Count = 0 then
    exit;
  flName := AllTrim(flName);
  // 20201015 Igor >>>
  For i := 0 to MostRecentList.Count - 1 do
  begin
    A := MostRecentList[i].Split([RecentDelim]);
    if Length(A) >= 4 then
      if SameText(flName, A[3]) then
      begin
        Result := i;
        exit;
      end;
  end;
  // 20201015 Igor <<<
end;

function FormatPhoneForRSI(s: string): string;
begin
  Result := ReplaceChar(s, ' ', '');
  Result := ReplaceChar(Result, '-', '');
  Result := LeftStr(Result, 3) + ' ' + MidStr(Result, 4, 6);
  Result := AllTrim(Result);
end;

function GetDefaultScaling: integer;
const
  OriginalWidth = 800; { I designed my form in 800x600 mode. }
  OriginalHeight = 600;
begin
  Result := OptRec.FormZoom;
  if (Result = 0) or (Result < 50) or (Result > 200) then
  begin
    if (Screen.Width <= 800) then
    begin
      Result := 100;
      exit;
    end;
    Result := Round(((Screen.Width) / OriginalWidth) * 100);
  end;
end;

// 20160602 Igor
// function IncrementlastBackUpDir(LastBackUp: string): string;
// var
// k: Integer;
// OldNo, NewNo: string;
// begin
// OldNo := RightStr(Lastbackup, 2);
// if NumbersOnly(OldNo) then
// begin
// NewNo := PaddZero(IntToStr(MyStrToInt(OldNo) + 1), 2);
// Result := LeftStr(LastBackUp, Length(LastBackUp) - 2) + NewNo;
// end
// else
// result := ExtractFileDir(LastBackUp) + '\' + 'Backup01';
// end;

{
  function IncrementlastBackUpDir(LastBackUp: string): string;
  var
  k: Integer;
  OldNo, NewNo: string;
  begin
  OldNo := RightStr(Lastbackup, 2);
  if NumbersOnly(OldNo) then
  begin
  NewNo := PaddZero(IntToStr(MyStrToInt(OldNo) + 1), 2);
  Result := LeftStr(LastBackUp, Length(LastBackUp) - 2) + NewNo;
  end
  else
  result := ExtractFileDir(LastBackUp) + '\' + 'Backup01';
  end;
}
function GetFileList(FDirectory, Filter: TFileName): TStringList;
var
  ARec: TSearchRec;
  Res: integer;
begin
  if FDirectory[Length(FDirectory)] <> '\' then
    FDirectory := FDirectory + '\';
  Result := TStringList.Create;
  try
    Res := FindFirst(FDirectory + Filter, faAnyFile, ARec);
    while Res = 0 do
    begin
      if FileExists(FDirectory + ARec.Name) then
        Result.Add(FDirectory + ARec.Name);

      Res := FindNext(ARec);
    end;
    SysUtils.FindClose(ARec);
  except
    Result.Free;
  end;
end;

procedure SaveSingleOption(FieldNm, Value: string;
  AOptionsFileName: String = ''); // 20160617 Igor >>>
var
  i: integer;
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  if AOptionsFileName = '' then
    AOptionsFileName := AppDir + '\' + OptionsFlName;
  // create txt if does not exist
  if not FileExists(AOptionsFileName) then
    TempList.SaveToFile(AOptionsFileName);

  TempList.LoadFromFile(AOptionsFileName);
  i := IsInList(FieldNm, TempList);
  if i > -1 then
    TempList[i] := LeftStr(TempList[i], 20) + Value
  else
    TempList.Add(PaddR(UpperCase(FieldNm), 20) + Value);
  TempList.SaveToFile(AOptionsFileName);
  // 20160617 Igor <<<<
  TempList.Free;
end;

procedure SaveOptionValue(FieldNm: string; Value: string;
  TempList: TStringList);
begin
  TempList.Add(PaddR(FieldNm, 20) + Value);
end;

function BooleanToString(ABoolean: Boolean): string;
begin
  if ABoolean = True then
    Result := 'X'
  else
    Result := '';
end;

function FromYesToX(YesNo: string): string;
begin
  if UpperCase(YesNo) = 'Y' then
    Result := 'X'
  else
    Result := '';
end;

function StringToBoolean(AString: string): Boolean;
begin
  if UpperCase(AString) = 'X' then
    Result := True
  else
    Result := False;
end;

procedure LoadOptionsFileToMem;
var
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir + '\' + OptionsFlName);
  with OptRec do
  begin
    // Read Values
    // EscOption:=GetOptionValue('EscOption',TempList);
    Dir_Cur := GetOptionValue('Dir_Cur', TempList);
    Dir_ClientDocs := GetOptionValue('Dir_ClientDocs', TempList);
    BackUpFrequency := GetOptionValue('BackUpFrequency', TempList);
    BackUpDir := GetOptionValue('BackUpDir', TempList);
    LastBackUpDir := GetOptionValue('LastBackUpDir', TempList);
    Dir_Deflt := GetOptionValue('Dir_Deflt', TempList);
    Dir_LastYr := GetOptionValue('Dir_LastYr', TempList);
    Dir_PgmLastYr := GetOptionValue('Dir_PgmLastYr', TempList);
    Dir_DBFData := GetOptionValue('Dir_DBFData', TempList); // 20160226 Igor
    { 20160523
      Dir2006 := GetOptionValue('Dir2006', TempList);
      Dir2005 := GetOptionValue('Dir2005', TempList);
      Dir2004 := GetOptionValue('Dir2004', TempList);
      Dir2003 := GetOptionValue('Dir2003', TempList);
      Dir2002 := GetOptionValue('Dir2002', TempList);
      Dir2001 := GetOptionValue('Dir2001', TempList);
    }

    Prp_Name := GetOptionValue('Prp_Name', TempList);
    Prp_ContactFn := GetOptionValue('Prp_ContactFn', TempList);
    Prp_ContactLn := GetOptionValue('Prp_ContactLn', TempList);
    Prp_ContactPos := GetOptionValue('Prp_ContactPos', TempList);
    Prp_RepId := GetOptionValue('Prp_RepId', TempList);

    Prp_EMail := GetOptionValue('Prp_EMail', TempList);
    Prp_OrgType := GetOptionValue('Prp_OrgType', TempList);
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
    Prp_Hour := VL(GetOptionValue('Prp_Hour', TempList));

    Prp_Elect := StringToBoolean(GetOptionValue('Prp_Elect', TempList));
    Prp_EfRepr := StringToBoolean(GetOptionValue('Prp_EfRepr', TempList));
    Prp_dates := StringToBoolean(GetOptionValue('Prp_Dates', TempList));
    Nfl_Prov := GetOptionValue('Nfl_Prov', TempList);
    Nfl_City := GetOptionValue('Nfl_City', TempList);

    Nfl_Disced := GetOptionValue('Nfl_Disced', TempList);
    Capitalization := GetOptionValue('Capitalization', TempList);
    Nfl_Efile := StringToBoolean(GetOptionValue('Nfl_Efile', TempList));
    Ef_ThirdParty := StringToBoolean(GetOptionValue('Ef_ThirdParty', TempList));

    Ef_method := GetOptionValue('Ef_Method', TempList);
    Prn_NameH := StringToBoolean(GetOptionValue('Prn_NameH', TempList));
    Prn_SinH := StringToBoolean(GetOptionValue('Prn_SinH', TempList));
    Prn_DateH := StringToBoolean(GetOptionValue('Prn_DateH', TempList));
    Prn_Disclm := GetOptionValue('Prn_Disclm', TempList);
    Opr_Close := StringToBoolean(GetOptionValue('Opr_Close', TempList));
    Opr_GstHst := VL(GetOptionValue('Opr_GstHst', TempList));

    // other optios
    ShowConsultantOnInv := StringToBoolean(GetOptionValue('ShowConsultantOnInv',
      TempList));
    UseFastPrint := StringToBoolean(GetOptionValue('UseFastPrint', TempList));
    UseProperName := StringToBoolean(GetOptionValue('UseProperName', TempList));
    ShowUsedForms := StringToBoolean(GetOptionValue('ShowUsedForms', TempList));
    OpenAtLastForm := StringToBoolean(GetOptionValue('OpenAtLastForm',
      TempList));
    DecimalAssume := StringToBoolean(GetOptionValue('DecimalAssume', TempList));

    UseFormSearch := StringToBoolean(GetOptionValue('UseFormSearch', TempList));
    NoTypeAhead := StringToBoolean(GetOptionValue('NoTypeAhead', TempList));

    ShowVisitedForms := StringToBoolean(GetOptionValue('ShowVisitedForms',
      TempList));
    ShowInvoiceWarning := StringToBoolean(GetOptionValue('ShowInvoiceWarning',
      TempList));

    Try
      ActiveBoxColor := StrToInt(GetOptionValue('ActiveBoxColor', TempList));
    Except
    End;

    // FirstReturnColor:=GetOptionValue('FirstReturnColor',TempList);
    // update frequency
    // invoice footter
    InvFoot1 := GetOptionValue('InvFoot1', TempList);
    InvFoot2 := GetOptionValue('InvFoot2', TempList);
    InvFoot3 := GetOptionValue('InvFoot3', TempList);
    InvFoot4 := GetOptionValue('InvFoot4', TempList);
    InvFoot5 := GetOptionValue('InvFoot5', TempList);

    DataInBold := StringToBoolean(GetOptionValue('DataInBold', TempList));
    NoBarCode := StringToBoolean(GetOptionValue('NoBarCode', TempList));
    RolloverProgram := GetOptionValue('RolloverProgram', TempList);
    { MainOptions
      HideMostRecent:=StringToBoolean(GetOptionValue('HideMostRecent',TempList));
      Prn_LMargin:=GetOptionValue('Prn_LMargin',TempList);
      Prn_RMargin:=GetOptionValue('Prn_RMargin',TempList);
      Prn_FontIncr:=GetOptionValue('Prn_FontIncr',TempList);
      UpdateFrequency:=GetOptionValue('UpdateFrequency',TempList);
    }
    FileNameFormat := GetOptionValue('FileNameFormat', TempList);
    // 20201013 Igor
    GetOverloadedProperty; // 20170112 Igor
  end;
  TempList.Free;
end;

function GetOptionValue(FieldNm: string; TempList: TStringList): string;
var
  i: integer;
begin
  Result := '';
  if MainOptions.HaveOptions(FieldNm) then
  Begin
    Result := MainOptions.ReadOptions(FieldNm)
  End
  else
  begin
    i := IsInList(FieldNm, TempList);
    if i > -1 then
      Result := MidStr(TempList[i], 21, 250);
  end;
end;

function GetOptionInt(FieldNm: string; TempList: TStringList): integer;
begin
  Result := StrToInt(GetOptionValue(FieldNm, TempList));
end;

procedure InitOptions; // 20160617 Igor >>>
// var
// PrevOptionsPath: String;
// sl: TStringList;
begin
  // 20190213 Igor >>>
  // if CheckIsCloud(true) then //20201013 Igor
  // if not SameText(CloudDataDir, '') then //20190306 Igor
  SetDefaultOptions;
  // 20190213 Igor <<<

  If Not FileExists(AppDir + '\' + OptionsFlName) then
  begin // if first run - try convert from old program
    if not ConvertToMultiApp(AppT2) then
    begin // if no old program or user cancel - load default param values
      SetDefaultOptions;
      LoadOptionsFileToMem; // from txt to optrec
    end
  end
  else // 20160601 Igor
    LoadOptionsFileToMem; // from txt to optrec
  // if not FileExists(AppDir + '\' + OptionsFlName) then
  // begin
  // //20160523 Igor >>>
  // if ExistsPrevOption(AppT2.AppId, PrevOptionsPath) and
  // (MessageDlg('Locate the file settings of the previous version of the program' + #13 +
  // '[' + PrevOptionsPath + '].' + #13 +
  // 'Apply it?', mtConfirmation, [mbYes,mbNo],0) = mrYes) then
  // begin
  // sl := TStringList.Create;
  // try
  // try
  // sl.loadFromFile(PrevOptionsPath);
  // SetDefaultOptions(sl);
  // except
  // SetDefaultOptions;
  // end;
  // finally
  // sl.free;
  // end;
  // end
  // else
  // //20160523 Igor <<<
  // SetDefaultOptions;
  // end;
  // LoadOptionsFileToMem; //from txt to optrec
end; // 20160617 Igor <<<

function BuildValue(ASource: String): String; // 20160617 Igor
Begin
  // 20171204 Igor>>>
  if pos(c_DefDataDir, ASource) > 0 then
    Result := StringReplace(ASource, c_DefDataDir, DefaultDataDir(AppT2),
      [rfReplaceAll, rfIgnoreCase])
    // 20171204 Igor<<<
  else
    Result := ASource;
  Result := Result;
End;

Function GetDefaultOptionsValue(const AOptionsName: String): String;
// 20160617 Igor
var
  i: integer;
Begin
  for i := Low(OptionsArray) to High(OptionsArray) do
    if SameText(OptionsArray[i, 0], AOptionsName) then
    Begin
      Result := BuildValue(OptionsArray[i, 1]);
      exit;
    End;
  Result := '';
End;

function GetDefaultOptions: TStringList; // 20160617 Igor
var
  i: integer;
  N, V: String;
Begin
  Result := TStringList.Create;
  for i := Low(OptionsArray) to High(OptionsArray) do
    if SameText(OptionsArray[i, 3], 'X') then
    begin
      N := OptionsArray[i, 0];
      V := BuildValue(OptionsArray[i, 1]);
      if V <> '' then
        Result.Values[N] := V
      else
        Result.Add(N + '=');
    end;
End;

function GetOptionsCaption(AOptionsName: String): String; // 20160617 Igor
var
  i: integer;
Begin
  for i := Low(OptionsArray) to High(OptionsArray) do
    if SameText(OptionsArray[i, 0], AOptionsName) then
    Begin
      Result := OptionsArray[i, 2];
      if Result = '' then
        Result := AOptionsName;
      exit;
    End;
  Result := AOptionsName;
End;

function HaveOptions(AOptionsName: String): Boolean; // 20170112 Igor
var
  i: integer;
Begin
  for i := Low(OptionsArray) to High(OptionsArray) do
    if SameText(OptionsArray[i, 0], AOptionsName) then
      exit(True);
  Result := False;
end;

procedure SetDefaultOptions; // 20160523 Igor //20160617 Igor
var
  i: integer;
  CurrOptions: TStringList; // 20201116 Igor

  procedure lSaveSingleOption(AOptionsName: String); // 20201116 Igor
  var
    Value: string;
  Begin
    Value := GetOptionValue(AOptionsName, CurrOptions);
    if Value.IsEmpty then
      Value := GetDefaultOptionsValue(AOptionsName);
    SaveSingleOption(AOptionsName, Value);
  End;

Begin
  // 20160602 igor
  // 20201116 Igor >>>
  CurrOptions := TStringList.Create;
  try
    if FileExists(AppDir + '\' + OptionsFlName) then
      CurrOptions.LoadFromFile(AppDir + '\' + OptionsFlName);

    CreateDefaultDataDirectories; // It saves the new dir to Options file
    for i := Low(OptionsArray) to High(OptionsArray) do
      if OptionsArray[i, 3] = 'X' then
        lSaveSingleOption(OptionsArray[i, 0]);

  finally
    CurrOptions.Free;
  end;
  // 20201116 Igor <<<

  // if assigned(APrevOptions) and
  // (IsInList('Dir_Cur', APrevOptions, I)) then
  // SaveSingleOption('Dir_DBFData',MidStr(APrevOptions[I], 21, 250));
  // lSaveSingleOption('EscOption', 'CloseForm');
  // lSaveSingleOption('Opr-GstHst', '6');
  // lSaveSingleOption('Prp_Bill', '2');
  // lSaveSingleOption('Prp_VSFee', '200');
  // lSaveSingleOption('Prp_SFee', '400');
  // lSaveSingleOption('Prp_AFee', '600');
  // lSaveSingleOption('Prp_CFee', '1000');
  // lSaveSingleOption('Prp_VCFee', '2000');
  // lSaveSingleOption('Prp_Hour', '60');
  // //display
  // lSaveSingleOption('FormZoom', IntToStr(GetDefaultScaling));
  // lSaveSingleOption('ActiveBoxColor', IntToStr(Rgb(255, 128, 128)));
  // lSaveSingleOption('FirstReturnColor', IntToStr(RGB(195, 255, 255)));
  // lSaveSingleOption('UseFormSearch', 'X');
  // lSaveSingleOption('OtherSlipsButtons', 'X');
  // lSaveSingleOption('OtherSlipsButtons', 'X');
  // lSaveSingleOption('Opr_Close', 'X');
  // lSaveSingleOption('Prn_NameH', 'X');
  // lSaveSingleOption('Prn_SinH', 'X');
  // lSaveSingleOption('Prn_DateH', 'X');
  // lSaveSingleOption('Prn_LMargin', '1.0');
  // lSaveSingleOption('Prn_RMargin', '0.75');
  // lSaveSingleOption('Prn_FontIncr', '1');
  //
  // lSaveSingleOption('DataInBold', '');
  // lSaveSingleOption('HideMostRecent', '');
  //
  // lSaveSingleOption('T1013AuthorLevel', '2');
  // lSaveSingleOption('CVSetting', '2');
  // lSaveSingleOption('ShowFinWarning', '');
  // lSaveSingleOption('ShowConsultantOnInv', '');
  // lSaveSingleOption('UseFastPrint', '');
  // lSaveSingleOption('UseProperName', 'X');
  //
  // lSaveSingleOption('UseCondominiumLine', 'X');
  // lSaveSingleOption('NoTypeAhead', '');
  // lSaveSingleOption('RolloverT4T5', 'X');
  // lSaveSingleOption('ShowInvoiceWarning', 'X');
  // lSaveSingleOption('ShowInvoiceEfCharge', 'X');
  // lSaveSingleOption('ShowSaluteWarning', 'X');
  //
  // lSaveSingleOption('UpdateFrequency', '7');
  // lSaveSingleOption('Nfl_Efile', 'X');
  // lSaveSingleOption('Ef_ThirdParty', 'X');
  // lSaveSingleOption('Nfl_Prov', 'ON');
  // lSaveSingleOption('Nfl_City', 'TORONTO');
  // lSaveSingleOption('Ef_Method', 'EOL');
  //
  // lSaveSingleOption('Prp_Elect', 'X');
  // lSaveSingleOption('Prp_EfRepr', 'X');
  // lSaveSingleOption('Nfl_Disced', '1');
  // lSaveSingleOption('Capitalization', 'UpperCase');
  //
  // lSaveSingleOption('AutoSeniorDiscount', '');
  // lSaveSingleOption('DiscountForSeniors', '0');
  // lSaveSingleOption('RolloverProgram', 'VisualTax');
  //
  // if assigned(APrevOptions) then
  // CompareOptions(APrevOptions, AppDir+'\'+OptionsFlName);

end;

(*
  procedure SetDefaultOptions; //20160523 Igor //20160617 Igor
  var
  I: integer;
  procedure lSaveSingleOption(AOptionsName: String);
  Begin
  SaveSingleOption(AOptionsName,GetDefaultOptionsValue(AOptionsName));
  End;
  begin
  CreateDefaultDataDirectories; //It saves the new dir to Options file

  for I := Low(OptionsArray) to High(OptionsArray) do
  if OptionsArray[I,3] = 'X' then
  lSaveSingleOption(OptionsArray[I,0]);

  //  if assigned(APrevOptions) and
  //    (IsInList('Dir_Cur', APrevOptions, I)) then
  //    SaveSingleOption('Dir_DBFData',MidStr(APrevOptions[I], 21, 250));
  //  lSaveSingleOption('EscOption', 'CloseForm');
  //  lSaveSingleOption('Opr-GstHst', '6');
  //  lSaveSingleOption('Prp_Bill', '2');
  //  lSaveSingleOption('Prp_VSFee', '200');
  //  lSaveSingleOption('Prp_SFee', '400');
  //  lSaveSingleOption('Prp_AFee', '600');
  //  lSaveSingleOption('Prp_CFee', '1000');
  //  lSaveSingleOption('Prp_VCFee', '2000');
  //  lSaveSingleOption('Prp_Hour', '60');
  //  //display
  //  lSaveSingleOption('FormZoom', IntToStr(GetDefaultScaling));
  //  lSaveSingleOption('ActiveBoxColor', IntToStr(Rgb(255, 128, 128)));
  //  lSaveSingleOption('FirstReturnColor', IntToStr(RGB(195, 255, 255)));
  //  lSaveSingleOption('UseFormSearch', 'X');
  //  lSaveSingleOption('OtherSlipsButtons', 'X');
  //  lSaveSingleOption('OtherSlipsButtons', 'X');
  //  lSaveSingleOption('Opr_Close', 'X');
  //  lSaveSingleOption('Prn_NameH', 'X');
  //  lSaveSingleOption('Prn_SinH', 'X');
  //  lSaveSingleOption('Prn_DateH', 'X');
  //  lSaveSingleOption('Prn_LMargin', '1.0');
  //  lSaveSingleOption('Prn_RMargin', '0.75');
  //  lSaveSingleOption('Prn_FontIncr', '1');
  //
  //  lSaveSingleOption('DataInBold', '');
  //  lSaveSingleOption('HideMostRecent', '');
  //
  //  lSaveSingleOption('T1013AuthorLevel', '2');
  //  lSaveSingleOption('CVSetting', '2');
  //  lSaveSingleOption('ShowFinWarning', '');
  //  lSaveSingleOption('ShowConsultantOnInv', '');
  //  lSaveSingleOption('UseFastPrint', '');
  //  lSaveSingleOption('UseProperName', 'X');
  //
  //  lSaveSingleOption('UseCondominiumLine', 'X');
  //  lSaveSingleOption('NoTypeAhead', '');
  //  lSaveSingleOption('RolloverT4T5', 'X');
  //  lSaveSingleOption('ShowInvoiceWarning', 'X');
  //  lSaveSingleOption('ShowInvoiceEfCharge', 'X');
  //  lSaveSingleOption('ShowSaluteWarning', 'X');
  //
  //  lSaveSingleOption('UpdateFrequency', '7');
  //  lSaveSingleOption('Nfl_Efile', 'X');
  //  lSaveSingleOption('Ef_ThirdParty', 'X');
  //  lSaveSingleOption('Nfl_Prov', 'ON');
  //  lSaveSingleOption('Nfl_City', 'TORONTO');
  //  lSaveSingleOption('Ef_Method', 'EOL');
  //
  //  lSaveSingleOption('Prp_Elect', 'X');
  //  lSaveSingleOption('Prp_EfRepr', 'X');
  //  lSaveSingleOption('Nfl_Disced', '1');
  //  lSaveSingleOption('Capitalization', 'UpperCase');
  //
  //  lSaveSingleOption('AutoSeniorDiscount', '');
  //  lSaveSingleOption('DiscountForSeniors', '0');
  //  lSaveSingleOption('RolloverProgram', 'VisualTax');
  //
  //  if assigned(APrevOptions) then
  //   CompareOptions(APrevOptions, AppDir+'\'+OptionsFlName);

  end;
*)
procedure ConvertCfgToOptionsFile(CfgTbl: TDataSet);
var
  TempList, TempList1: TStringList;
begin
  with CfgTbl do
  begin
    FormatSettings.DecimalSeparator := '.'; // 20150622
    TempList := TStringList.Create;
    SaveOptionValue('Dir_Cur', FieldByName('Dir_Cur').AsString, TempList);
    SaveOptionValue('Dir_Deflt', FieldByName('Dir_Deflt').AsString, TempList);
    SaveOptionValue('Dir_LastYr', FieldByName('Dir_LastYr').AsString, TempList);
    SaveOptionValue('Dir_PgmLastYr', FieldByName('Dir_PgmLastYr').AsString,
      TempList);
    SaveOptionValue('Dir_ClientDocs', FieldByName('Dir_ClientDocs').AsString,
      TempList);
    SaveOptionValue('Dir_PrvLYr', FieldByName('Dir_PrvLYr').AsString, TempList);
    SaveOptionValue('Dir_DBFData', FieldByName('Dir_DBFData').AsString,
      TempList); // 20160226 Igor
    SaveOptionValue('Dir_Train', FieldByName('Dir_Train').AsString, TempList);
    SaveOptionValue('Dir_Sample', FieldByName('Dir_Sample').AsString, TempList);

    SaveOptionValue('Prp_Name', FieldByName('Prp_Name').AsString, TempList);
    SaveOptionValue('Prp_ContactFn', FieldByName('Prp_ContactFn').AsString,
      TempList);
    SaveOptionValue('Prp_ContactLn', FieldByName('Prp_ContactLn').AsString,
      TempList);
    SaveOptionValue('Prp_ContactPos', FieldByName('Prp_ContactPos').AsString,
      TempList);
    SaveOptionValue('Prp_RepId', FieldByName('Prp_RepId').AsString, TempList);

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
    SaveOptionValue('Prp_VSFee', IntTostr(FieldByName('Prp_VSFee').AsInteger),
      TempList);
    SaveOptionValue('Prp_SFee', IntTostr(FieldByName('Prp_SFee').AsInteger),
      TempList);
    SaveOptionValue('Prp_AFee', IntTostr(FieldByName('Prp_AFee').AsInteger),
      TempList);
    SaveOptionValue('Prp_CFee', IntTostr(FieldByName('Prp_CFee').AsInteger),
      TempList);
    SaveOptionValue('Prp_VCFee', IntTostr(FieldByName('Prp_VCFee').AsInteger),
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
    SaveOptionValue('Nfl_Disced', FieldByName('Nfl_Disced').AsString, TempList);
    SaveOptionValue('Nfl_Efile',
      BooleanToString(Boolean(FieldByName('Nfl_EFile').AsInteger)), TempList);
    SaveOptionValue('Ef_ThirdParty',
      BooleanToString(Boolean(FieldByName('Ef_ThirdParty').AsInteger)),
      TempList);

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
    SaveOptionValue('Opr_FPres', IntTostr(FieldByName('Opr_FPres').AsInteger),
      TempList);
    SaveOptionValue('Opr_GSTHst', FormatFloat('######.##',
      FieldByName('Opr_GSTHst').AsFloat), TempList);

    // other options
    TempList1 := TStringList.Create;
    if FileExists(AppDir + 'OthOpt.d') then
    begin
      TempList1.LoadFromFile(AppDir + 'OthOpt.d');
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
    if FileExists(AppDir + '\' + 'UpdSch.Txt') then
    begin
      TempList1.LoadFromFile(AppDir + '\' + 'UpdSch.Txt');
      SaveOptionValue('UpdateFrequency', TempList1[0], TempList);
    end;

    // Ef_method
    TempList1.clear;
    if FileExists(AppDir + '\' + 'EfMethod.d') then
    begin
      TempList1.LoadFromFile(AppDir + '\' + 'EfMethod.d');
      SaveOptionValue('Ef_Method', TempList1[0], TempList);
    end;

    // Inv Footer
    TempList1.clear;
    if FileExists(AppDir + '\' + 'InvFoot.d') then
    begin
      TempList1.LoadFromFile(AppDir + '\' + 'InvFoot.d');
      SaveOptionValue('InvFoot1', TempList1[0], TempList);
      SaveOptionValue('InvFoot2', TempList1[1], TempList);
      SaveOptionValue('InvFoot3', TempList1[2], TempList);
      SaveOptionValue('InvFoot4', TempList1[3], TempList);
      SaveOptionValue('InvFoot5', TempList1[4], TempList);
    end;
  end; // with
  TempList.SaveToFile(AppDir + '\' + OptionsFlName);
  TempList.Free;
  TempList1.Free;
end;

function IsFormTheDefaultSearch: Boolean;
var
  TempList: TStringList;
  s: string;
begin
  Result := OptRec.UseFormSearch;
end;

function ValidShortProvince(s: string): Boolean;
var
  i: integer;
begin
  Result := False;
  for i := Low(PrvShort) to High(PrvShort) do
    if s = PrvShort[i] then
    begin
      Result := True;
      exit;
    end
end;

function IsOkToOpenReturn(DataDir: string; flName: string): Boolean;
// Function IsOkToOpenReturn(DataDir:String;FlName:String;Sin:String):Boolean;
var
  s: string;
begin
  Result := False;
  if flName = '' then
    exit;
  if not FileExists(DataDir + '\' + ClientsDBLite) then // 20150922 Igor
  begin
    ShowMessage('Data directory has not been defined' + Chr(13) +
      'Use Configure | Data Directories');
    exit;
  end;

  if IsDataDirectoryGood(DataDir) = False then
    exit;

  // 20170901 Igor>>>
  if AppT2.ExceedsMaxReturnsAllowed(False) then
  begin
    // ShowMessage('Number of returns exceeds maximum allowed '
    // + '(' + IntToStr(LimitedVersionReturns) + ')' +
    // Chr(13) + ' in the T2 Limited version'
    // + Chr(13) + 'Please delete some returns');
    exit;
  end;
  // 20170901 Igor<<<

  Result := True;
end;

function AllowedToFormPrint(RetNo: integer): Boolean;
begin
  Result := True;
  if (LicenseLevel in anyMulti) and (Ret[RetNo].Changed) then
  begin
    ShowMessage('Please save return first or enter the ADMIN password');
    if YouknowTheAdminPassword then
    begin
      Result := True;
      exit;
    end;
    Result := False;
  end;
end;

function CreateNewDataDir: string;
var
  DataDir: string; // [60];
  ThisResult: integer;
  ClickedOK: Boolean;
begin
  if LicenseLevel = llLimited then
    DataDir := LimitedVersionDir
  else
    DataDir := AppDir + '\Data';
  DataDir := InputBox('Create Data Directory', 'Enter Full path', DataDir);
  ThisResult := CreateDataDirectory(AppDir, DataDir);
  case ThisResult of
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
  if ThisResult = 0 then
    Result := DataDir
  else
    Result := '';
end;

function AllowedToFullPrint(RetNo: integer): Boolean;
begin
  Result := True;
  if LicenseLevel in anyMulti then
  begin
    if (Ret[RetNo].Changed) then
    begin
      ShowMessage('Please save return first or enter the ADMIN password');
      if YouknowTheAdminPassword then
      begin
        Result := True;
        exit;
      end;
      Result := False;
    end;
  end;
end;

function GetPrintTemplate: string;
begin
  { select print set }
  Result := '';
  SomeList.clear; // := TStringList.Create;
  SomeList.Add('CRA');
  SomeList.Add('Client');
  SomeList.Add('Preparer');
  SomeList.Add('C+P (Client and Preparer)');
  SomeList.Add('All three (CRA, Client and Preparer)');
  SomeList.Add('Other 1');
  SomeList.Add('Other 2');
  SomeList.Add('Other 3');
  SelectedString := PopSomeList(SomeList, 'Select Print Template');
  // SomeList.Free; //20160704 Igor
  if SelectedString = 'CRA' then
    Result := 'CRASET.D'
  else if SelectedString = 'Client' then
    Result := 'CLINTSET.D'
  else if SelectedString = 'Preparer' then
    Result := 'PREPSET.D'
  else if SelectedString = 'Other 1' then
    Result := 'OTH1SET.D'
  else if SelectedString = 'Other 2' then
    Result := 'OTH2SET.D'
  else if SelectedString = 'Other 3' then
    Result := 'OTH3SET.D'
  else if LeftStr(SelectedString, 3) = 'C+P' then
    Result := 'C+P'
  else if LeftStr(SelectedString, 3) = 'All' then
    Result := 'ALL';
end;

procedure ResortFormsToPrint(FormsToPrint: TStringList);
// comes as sssnFFFFFFFFF  i.e. 1011T2124-1#1
// take the -1#1 and put it under the sss then resort
var
  i, k1, k2: integer;
  TempList: TStringList;
  Rec: string;
  SeqNo: integer;
  SeqNoString: string;
begin
  SeqNo := 0; // new seq
  TempList := TStringList.Create;

  FormsToPrint.Sorted := False;
  for i := 0 to FormsToPrint.Count - 1 do
  begin
    Rec := FormsToPrint[i];
    k1 := pos('_', Rec);
    k2 := pos('#', Rec);
    if (k1 > 0) and (k2 > 0) then
    begin
      TempList.Add(LeftStr(Rec, 4) + PaddR(AllTrim(MidStr(Rec, k2, 3)), 3) +
        PaddR(AllTrim(MidStr(Rec, k1, 3)), 3) + MidStr(Rec, 5, 10));
    end
    else
    begin
      TempList.Add(LeftStr(Rec, 4) + Space(6) + MidStr(Rec, 5, 10));
    end;
  end;

  TempList.Sorted := True;

  FormsToPrint.clear;
  for i := 0 to TempList.Count - 1 do
  begin
    Rec := TempList[i];
    FormsToPrint.Add(LeftStr(Rec, 4) + MidStr(Rec, 11, 20));
  end;
  TempList.Free;
end;

function StripInstNo(FormName: string): string;
var { T4#1  yields T4 }
  i: integer;
begin
  i := 1;
  while (i <= Length(FormName)) and not(FormName[i] = '#') do
    Inc(i);
  Result := Copy(FormName, 1, i - 1);
end;

function CopyMoveReturn(CopyOrMove: string; FromDir: string; ToDir: string;
  flName: string): Boolean;
// 20170811 Igor>>>
var
  Err: string;
  RetNo: integer;
begin
  Result := False;
  if not SysUtils.DirectoryExists(ToDir) then // 20150702
  begin
    if not SysUtils.ForceDirectories(ToDir) then // 20150702
      exit;
  end;
  if not CopyFile(FromDir + '\' + flName, ToDir + '\' + flName) then
    exit;
  // init db if not thre
  if not FileExists(ToDir + '\' + ClientsDBLite) then // 20150922 Igor
  begin
    if not InitDataBase(AppDir, ToDir, Err) then
    begin
      ShowMessage(Err);
      exit;
    end;
  end;
  // read file
  RetNo := ReadReturn(ToDir, flName, False, False); // 'N','N'); //unchecked?
  if RetNo > 0 then
  begin
    try
      UpdateClientsTable(RetNo, ToDir, flName);
      UpdateMostRecentFiles(RetNo, ToDir, flName, GetAccountNumber(RetNo));
      // If RetNo >0 then
    finally
      RemoveReturnFromMemory(RetNo);
    end;
    if CopyOrMove = 'M' then
      DeleteReturn(FromDir, flName);
    Result := True;
  end;
  // 20170811 Igor<<<
end;

function ValidEMail(s: string): Boolean;
begin
  Result := True;
  if s = '' then
    exit;
  if (pos('@', s) <= 0) or (pos('.', s) <= 0) then
    Result := False;
end;

function GetAnyPathMoreThan8Chars(Dir: string): string;
var
  i: integer;
  WList: TStringList;
  { returns dir part that is more than 8 chars, else nil }
begin
  Result := '';
  WList := TStringList.Create;
  ParseWords(Dir, '\', WList);
  for i := 0 to WList.Count - 1 do
  begin
    if Length(WList[i]) > 8 then
    begin
      Result := WList[i];
      WList.Free;
      exit;
    end;
  end;
  WList.Free;
end;

function IsFormAClientLetter(FName: string): Boolean;
begin
  Result := False;
  if (FName = 'CLETTER') or (FName = 'PIPEDA') or (FName = 'ENGAGE') or
    (FName = 'CUSTINV') or (FName = 'ALETTER') { //for miscellaneous letters }
  then
    Result := True;
end;

function GetDfmFormsDir: string;
begin
  if IsDevelopmentMode then
    Result := AppDir + '\' + 'T2Forms'
  else
    Result := AppDir;
end;

function IsInvoiceLocked(RetNo: integer): Boolean;
begin
  Result := False;
  // ????
  if UpperCase(FetchElm(RetNo, 'INVOICE', 285)) = 'Y' then
    Result := True;
end;

function FieldHasAddingTape(RetNo: integer; FName: string;
  Elm: integer): Boolean;
var
  i: integer;
begin
  Result := False;
  exit;
end;

function GetFormAbrevNameWithNoInst(FormNo: integer): string;
var
  i: integer;
begin

  Result := FList.ByFormNoDummy(FormNo).FormAbrev;

end;

procedure GetFrmDataListFromFullDataList(FrmNm: string; DataList: TStringList;
  FrmDataList: TStringList);
// data list is image of disk file
var
  i, j, ElmNo: integer;
  WList: TStringList;
  Rec: string;
begin
  // ????
  try
    j := 0;
    FrmDataList.clear;
    if LeftStr(DataList[0], 2) <> 'T2' then
      exit;
    WList := TStringList.Create;
    for i := 1 to DataList.Count - 1 do
    begin
      Rec := DataList[i];
      ParseWords(Rec + Delimiter, Delimiter, WList);
      if (WList[0] = 'F') and (WList[1] = FrmNm) then // found frm record
      begin
        // j:=i+1;
        for j := i + 1 to DataList.Count - 1 do
        begin
          Rec := DataList[j];
          ParseWords(Rec + Delimiter, Delimiter, WList);
          if LeftStr(Rec, 2) = 'F' + Delimiter then
            exit;
          if (WList[0] = 'D') then
            FrmDataList.Add(Rec);
        end;
      end; // frm found
    end; // i
  except
    ShowMessage(Rec);
  end; // try
end;

function LinkToSelf(InitialFormName: string; TargetFormName: string): Boolean;
begin
  Result := False;
  if ExtractFormRootName(InitialFormName) = ExtractFormRootName(TargetFormName)
  then
    Result := True;
end;

function GetLetterFileName(RetNo: integer; FName: string): string;
begin
  if FName = 'CLETTER' then
  begin
    Result := GetClientLettersDir + '\' + MkClientLetterName(RetNo);
    if FileExists(Result) then
      exit; // special letter
    if IsEFiled(RetNo) then
      Result := AppDir + '\' + 'EfiledLetter.RTF'
    else
      Result := AppDir + '\' + 'PaperFiledLetter.RTF';
  end;
  if FName = 'PIPEDA' then
    Result := AppDir + '\' + 'PIPEDALetter.RTF';
  if FName = 'ENGAGE' then
    Result := AppDir + '\' + 'EngagementLetter.RTF';
  if FName = 'CUSTINV' then
    Result := AppDir + '\' + 'CustInvLetter.RTF';
  if FName = 'ALETTER' then
    Result := AppDir + '\' + SomeLetterName; // global variable
end;

function GetInterpetedRichEdit(RetNo: integer; LetterName: string;
  ARichEdit: TRichEdit): Boolean; // 20160819 Igor
var
  i, j: integer;
  errorC: Boolean;
  Txt: string;
  Memo1: TMemo;
  KeyWList: TStringList;
  TempFileName: string;
  EkRtf1: TEkRtf;
  AStream: TMemoryStream;
  KeyW: string;
  FName, FName1: string;
  Elm: integer;
  IsAmount: string;
  LineNumber: integer;
  Args: TEkUdfArgs;
  ArgCount: integer;
  aResult: TEkReportVariable; // TObject;
begin
  Result := False; // 20160819 igor
  if not FileExists(LetterName) then
  begin
    ShowMessage('Template ' + LetterName + ' was not found');
    exit;
  end;
  ARichEdit.ReadOnly := False;

  ARichEdit.Visible := False;
  ARichEdit.Lines.LoadFromFile(LetterName);
  KeyWList := TStringList.Create;
  LoadDataDict;
  GetKeyWListFromRichEdit(ARichEdit, KeyWList);

  KeyWList.SaveToFile(AppDir + '\' + 'Temp1.txt');
  with MainFormT2.EkRtf1 do
  begin
    ClearVars;
    for i := 0 to KeyWList.Count - 1 do
    begin
      KeyW := KeyWList[i];
      DataDictList.GetKeyWAttributes(KeyW, FName, Elm, IsAmount);
      // 20121211
      if FName = 'PAGE_1' then
        FName := 'T2';
      if (FName = 'PAGE_8') and (Elm = 43) then
      begin
        FName := 'T2';
        Elm := 743;
      end;
      if (FName = 'PAGE_8') and (Elm = 42) then
      begin
        FName := 'T2';
        Elm := 742;
      end;
      FormatSettings.DecimalSeparator := '.'; // 20150622
      if UpperCase(LeftStr(IsAmount, 1)) = 'Y' then
        CreateVar(KeyW, Round(VL(FetchElm(RetNo, FName, Elm))))

      else if KeyW = 'Date' then
        CreateVar(KeyW, DateToMonthDayYear(Date))

      else if LeftStr(KeyW, 5) = 'Line_' then
      begin
        IsAmount := 'Y';
        LineNumber := 0; // 20150702
        if Length(KeyW) = 8 then
          LineNumber := StrToInt(RightStr(KeyW, 3));
        if Length(KeyW) = 9 then
          LineNumber := StrToInt(RightStr(KeyW, 4));
        CreateVar(KeyW, Ret[RetNo].Ln[LineNumber]);
      end

      else if KeyW = 'This_TaxYear' then
        CreateVar(KeyW, AppYear)
      else if KeyW = 'Next_TaxYear' then
        CreateVar(KeyW, IntTostr(AppYearInt + 1))

      else if LeftStr(KeyW, 5) = 'Form_' then
      begin
        IsAmount := '';
        FName1 := UpperCase(AllTrim(MidStr(KeyW, 6, 10)));
        if FormHasInstanceIndicator(RetNo, FName1) then
          FName1 := FName1 + '#1';
        if GetFormNo(FName1) > 0 then
        begin
          if Ret[RetNo].FrmHasData[GetFormNo(FName1)] then
            CreateVar(KeyW, 'Y') // Form =Yes meaning has data
          else
            CreateVar(KeyW, 'N');
        end;
      end // form_
      else
      begin
        if ((KeyW = 'Client_CorporateName') or (KeyW = 'Client_Address1') or
          (KeyW = 'Client_Address2') or (KeyW = 'Client_City') or
          (KeyW = 'Client_Contact')) then
        begin
          if OptRec.UseProperName then
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
    KeyWList.Free;

    ARichEdit.Lines.SaveToFile(AppDir + '\' + 'TempRtf.rtf'); // 20160819 Igor
    InFile := AppDir + '\' + 'TempRtf.rtf'; // LetterName; //20160819Igor
    AStream := TMemoryStream.Create;
    try
      ExecuteStream([], AStream);
      ARichEdit.Lines.LoadFromStream(AStream);
      Result := True; // 20160819 Igor
    except
      Result := False; // 20160819 Igor
    end;
    AStream.Free;
  end; // with
end;

// 20170811 Igor >>>
Function CreateDefaultDataDirectories: Boolean;
var
  Err: String;
  ClientDocDir: string; // 20181002 Igor
begin
  (* if not CheckIsCloud(true) and (LicenseLevel in anyLimited) then //20170902 Igor //20180503 Igor
    begin
    if not SysUtils.DirectoryExists(LimitedVersionDir) then //20150702
    if not SysUtils.ForceDirectories(LimitedVersionDir) then
    begin
    ShowMessage('Data directory ' + LimitedVersionDir + ' cannot be created');
    exit(False);
    end;
    if not SysUtils.FileExists(IncludeTrailingPathDelimiter(LimitedVersionDir) + AppT2.ClientsDBLite) then //20150702
    if not InitDataBase(AppDir, LimitedVersionDir, Err) then
    begin
    ShowMessage(Err);
    exit(False);
    end
    else
    ShowMessage('A Data Directory has been created: ' + LimitedVersionDir);
    SaveSingleOption('Dir_Cur', LimitedVersionDir);
    SaveSingleOption('Dir_Deflt', LimitedVersionDir);
    // 20181002 Igor >>>
    ClientDocDir := TPath.Combine(LimitedVersionDir, 'Client Documents');
    SaveSingleOption('Dir_ClientDocs', ClientDocDir);
    if not SysUtils.DirectoryExists(ClientDocDir) then
    SysUtils.ForceDirectories(ClientDocDir);
    // 20181002 Igor <<<
    Result := True;
    end
    else *) // not limited version
  begin
    // 20171201 Igor>>>
    if not SysUtils.ForceDirectories(DefaultDataDir(AppT2) + '\Data') then
    begin
      ShowMessage('Data directory ' + DefaultDataDir(AppT2) + '\Data' +
        ' cannot be created');
      exit(False);
    end;
    if not SysUtils.FileExists(IncludeTrailingPathDelimiter(AppDir) +
      AppT2.ClientsDBLite) then // 20150702
      if not InitDataBase(AppDir, DefaultDataDir(AppT2) + '\Data', Err) then
      begin
        ShowMessage(Err);
        exit(False);
      end
      else if not CheckIsCloud(True) then // 20180503 Igor
        ShowMessage('A default Data Directory has been created: ' +
          DefaultDataDir(AppT2) + '\Data' + Chr(13) +
          'You can change it via Configure | General options');
    SaveSingleOption('Dir_Cur', DefaultDataDir(AppT2) + '\Data');
    SaveSingleOption('Dir_Deflt', DefaultDataDir(AppT2) + '\Data');
    SaveSingleOption('Dir_ClientDocs', DefaultDataDir(AppT2) +
      '\Client Documents');

    if not SysUtils.DirectoryExists(DefaultDataDir(AppT2) + '\Client Documents')
    then // 20150702
      SysUtils.ForceDirectories(DefaultDataDir(AppT2) + '\Client Documents');
    // 20150702
    // 20171201 Igor<<<
    Result := True;
  end;
  // 20170811 Igor <<<
end;


// 20160721 Igor Move to T2_2020Declare
// const
// PswElm = 25; //STATUS ElmNo
// c_LastYearElm = 32;
// c_OldGifiDataConvertedElm = 33; //20160721 Igor

(*
  //20170811 Igor >>>
  Function CreateDefaultDataDirectories: Boolean;
  var
  Err: String;
  begin
  if LicenseLevel in anyLimited then//20170902 Igor
  begin
  if not SysUtils.DirectoryExists(LimitedVersionDir) then //20150702
  if not SysUtils.ForceDirectories(LimitedVersionDir) then
  begin
  ShowMessage('Data directory ' + LimitedVersionDir + ' cannot be created');
  exit(False);
  end;
  if not SysUtils.FileExists(IncludeTrailingPathDelimiter(LimitedVersionDir) + AppT2.ClientsDBLite) then //20150702
  if not InitDataBase(AppDir, LimitedVersionDir, Err) then
  begin
  ShowMessage(Err);
  exit(False);
  end
  else
  ShowMessage('A Data Directory has been created: ' + LimitedVersionDir);
  SaveSingleOption('Dir_Cur', LimitedVersionDir);
  SaveSingleOption('Dir_Deflt', LimitedVersionDir);
  Result := True;
  end
  else //not limited version
  begin
  if not SysUtils.ForceDirectories(AppDir + '\Data') then
  begin
  ShowMessage('Data directory ' + AppDir + '\Data' + ' cannot be created');
  exit(False);
  end;
  if not SysUtils.FileExists(IncludeTrailingPathDelimiter(AppDir) + AppT2.ClientsDBLite) then //20150702
  if not InitDataBase(AppDir, AppDir + '\Data', Err) then
  begin
  ShowMessage(Err);
  exit(False);
  end
  else
  ShowMessage('A default Data Directory has been created: ' + AppDir + '\Data'
  + Chr(13) +
  'You can change it via Configure | General options');
  SaveSingleOption('Dir_Cur', AppDir + '\Data');
  SaveSingleOption('Dir_Deflt', AppDir + '\Data');
  SaveSingleOption('Dir_ClientDocs', AppDir + '\Client Documents');

  if not SysUtils.DirectoryExists(AppDir + '\Client Documents') then //20150702
  SysUtils.ForceDirectories(AppDir + '\Client Documents'); //20150702
  Result := True;
  end;
  //20170811 Igor <<<
  end;


  //20160721 Igor Move to T2_2020Declare
  //const
  //  PswElm = 25; //STATUS ElmNo
  //  c_LastYearElm = 32;
  //  c_OldGifiDataConvertedElm = 33; //20160721 Igor

*)
function GetReturnPsw(DataDir: string; flName: string): string;
begin
  GetFilePsw(DataDir, flName, PswElm, Result,
    AppT2.SQLLitePassword.PassRFArray); // 20160415 Igor
end;

function CheckReturnPsw(DataDir: string; flName: string): integer;
begin
  Result := CheckFilePsw(DataDir, flName, PswElm,
    AppT2.SQLLitePassword.PassRFArray); // 20160415 Igor
end;

function CheckReturnAndPsw(DataDir, flName: string): Boolean;
begin
  Result := CheckFileAndPsw(DataDir, flName, PswElm,
    AppT2.SQLLitePassword.PassRFArray); // 20160415 Igor
end;

procedure StoreReturnPsw(RetNo: integer; RetPsw: string);
begin
  StoreElm(RetNo, 'STATUS', PswElm, EncryptPsw(RetPsw, 9999));
end;

procedure RemoveReturnPsw(RetNo: integer);
begin
  StoreElm(RetNo, 'STATUS', PswElm, '');
end;

function IncludeFormInPrint(RetNo: integer; FNm: string): Boolean;
// Var RetNo:Integer;
begin
  Result := True;

  // 20180526
  if FNm = 'S8ALL' then
  begin
    if FetchElm(RetNo, FNm, 402) = '' then // no 43 rec
    begin
      Result := False;
      exit;
    end;
  end;

  if FNm = 'S23' then
  begin
    if VL(FetchElm(RetNo, FNm, 9)) = 100 then
    begin
      Result := False;
      exit;
    end;
  end;

  if Result then
    Result := NotOldGifiForm(FNm); // 20160720 Igor
end;

function NotOldGifiForm(AFormName: String): Boolean; // 20160720 Igor
begin
  AFormName := ExtractNonInstFormName(AFormName);
  Result := not(SameText(AFormName, 'GIFIBS') or SameText(AFormName, 'GIFIIS'));
end;

function GetMaxFormNumber: integer;
var
  i: integer;
  mFormNum: integer;
begin
  Result := FormsLimit;
  exit; // we use 600

  mFormNum := 0;
  for i := (FList.Count - 1) downto 0 do
  begin
    FRec := FList.Items[i];
    if (FRec.FormNo > mFormNum) then
    begin
      mFormNum := FRec.FormNo
    end;
  end;
  Result := mFormNum;
end;

function GetFormHeight(FName: string): integer;
var
  i: integer;
begin
  Result := 1050;
  FName := ExtractNonInstFormName(FName);
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = FName then
    begin
      if FRec.FormHeight < 700 then
        Result := 700
      else
        Result := FRec.FormHeight;
      exit;
    end;
  end;
end;

function GetFormNumberFields(FNo: integer): integer;
begin
  Result := FList.GetFormNumberFields(FNo);
end;

function GetKeyWListFromRichEdit(ARichEdit: TRichEdit;
  KeyWList: TStringList): Boolean;
var
  i: integer;
  Delim1List, Delim2List: TStringList;
  KeyW, tempKeyWFull: string;
  StartPos: integer;
begin
  Result := True;
  Delim1List := TStringList.Create;
  Delim2List := TStringList.Create;
  GetDelimiterPositionsInRtf(ARichEdit, '[', Delim1List);
  GetDelimiterPositionsInRtf(ARichEdit, ']', Delim2List);

  if Delim1List.Count <> Delim2List.Count then
  begin
    Delim1List.Free;
    Delim2List.Free;
    Result := False;
    exit;
  end;

  for i := 0 to Delim1List.Count - 1 do
  begin
    with ARichEdit do
    begin
      SelStart := MyStrToInt(Delim1List[i]) + 1;
      SelLength := MyStrToInt(Delim2List[i]) - MyStrToInt(Delim1List[i]) - 1;
      KeyW := SelText;
      KeyW := CleanUpKeyW(KeyW);

      tempKeyWFull := KeyW;
      while (tempKeyWFull > '') do
      begin
        StartPos := pos(' ', tempKeyWFull);
        if StartPos > 0 then
        begin
          KeyW := AllTrim(LeftStr(tempKeyWFull, StartPos));
          tempKeyWFull :=
            AllTrim(RightStr(tempKeyWFull, Length(tempKeyWFull) - StartPos));
        end
        else
        begin
          KeyW := tempKeyWFull;
          tempKeyWFull := '';
        end;
        if (IsInList(KeyW, KeyWList) = -1) and (InDataDict(KeyW)) then
        begin
          if KeyW > '' then
            KeyWList.Add(KeyW);
        end;
      end;

    end;
  end;
  with ARichEdit do
  begin
    SelStart := Perform(EM_LINEINDEX, 0, 0);
    SelLength := 0;
  end;
  Delim1List.Free;
  Delim2List.Free;
end;

function CleanUpKeyW(KeyW: string): string;
// comes as If (keywxxx > 0)  etc > < || ! && etc
// also Need Ffix in front of dollar variables
var
  k: integer;
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

  Result := AllTrim(KeyW);
end;

function ConvertToProper(s: string): string;
var
  i, iLen, iIndex: integer;
  WList: TStringList;
  SBuffer: string;
begin

  Result := '';
  iLen := Length(s);
  if iLen = 0 then
    exit;
  s := UpperCase(MidStr(s, 1, 1)) + Lowercase(MidStr(s, 2, iLen));

  WList := TStringList.Create;
  ParseWords(s, ' ', WList);
  for i := 0 to WList.Count - 1 do
  begin
    SBuffer := WList[i];
    SBuffer := UpperCase(MidStr(SBuffer, 1, 1)) +
      Lowercase(MidStr(SBuffer, 2, Length(SBuffer)));
    WList[i] := SBuffer;
    // o'connor
    if MidStr(SBuffer, 2, 1) = Chr(39) then
      WList[i] := LeftStr(SBuffer, 2) + UpperCase(MidStr(SBuffer, 3, 1)) +
        MidStr(SBuffer, 4, 100)
      // RR
    else if UpperCase(LeftStr(SBuffer, 2)) = 'RR' then
      WList[i] := UpperCase(LeftStr(SBuffer, 2)) + MidStr(SBuffer, 3, 100)
    else if Length(SBuffer) = 2 then
    begin
      if (UpperCase(LeftStr(SBuffer, 2)) = 'NE') or
        (UpperCase(LeftStr(SBuffer, 2)) = 'SE') or
        (UpperCase(LeftStr(SBuffer, 2)) = 'NW') or
        (UpperCase(LeftStr(SBuffer, 2)) = 'SW') then
        WList[i] := UpperCase(LeftStr(SBuffer, 2) + MidStr(SBuffer, 3, 100))
    end;
  end;

  Result := '';
  for i := 0 to WList.Count - 1 do
    Result := Result + WList[i] + ' ';
  Result := AllTrim(Result);
  WList.Free;
end;

procedure InsertBackFunction(ARichEdit: TRichEdit;
  InSearch, InSecondSearch, InReplace: string);
var
  x, Y, ToEnd: integer;
begin
  with ARichEdit do
  begin
    Visible := False;
    x := 0;
    ToEnd := Length(ARichEdit.Text);
    x := FindText(InSearch, x, ToEnd, []);
    while x <> -1 do
    begin
      Y := x;
      Y := FindText(InSecondSearch, Y, ToEnd, []);
      SelStart := Y;
      SelLength := Length(InSecondSearch);
      SelText := InReplace;
      x := FindText(InSearch, Y + Length(InReplace), ToEnd, []);
    end;
    Visible := True;
  end; // with
end;

procedure ReplaceRtfDelimiters(ARichEdit: TRichEdit;
  FromDelim, ToDelim: string);
begin
  ARichEdit.SelStart := 0;
  ARichEdit.SelectAll;
  ARichEdit.Paragraph.Alignment := paLeftJustify; // 20160819 Igor
  ReplaceRtfText(ARichEdit, FromDelim, ToDelim);
end;

procedure AddDisplayFormatToRtf(ARichEdit: TRichEdit; KeyWList: TStringList);
// i.e. [Taxable_amount] s/b FNum(Taxable_amount)
begin
  //
end;

procedure ReadTheValue(TempList: TStringList; FrmNm: string;
  Elm1, Elm2: integer; var Val1: string; var Val2: string);
{ templist is the tax return data }
var
  i, j: integer;
  WList: TStringList;
  Rec: string;
begin
  Val1 := '';
  Val2 := '';
  WList := TStringList.Create;
  for i := 1 to TempList.Count - 2 do // -2 otherwise it abends
  begin
    Rec := TempList[i];
    ParseWords(Rec, Delimiter, WList);
    if (WList[0] = 'F') and (WList[1] = FrmNm) then
    begin
      j := i + 1;
      repeat
        Rec := TempList[j];
        ParseWords(Rec, Delimiter, WList);
        if (WList[0] = 'D') then
        begin
          if VL(WList[1]) = Elm1 then
            Val1 := WList[2];
          if VL(WList[1]) = Elm2 then
            Val2 := WList[2];
        end;
        Inc(j);
      until (j > TempList.Count - 2) or (LeftStr(Rec, 2) = 'F' + Delimiter);
      { end form data }
    end; { within form nm }
  end; { i }
  WList.Free;
end;

function FirstTimeClient(RetNo: integer): Boolean;
begin
  // ????
  Result := False;
  if UpperCase(FetchElm(RetNo, 'INFO', 88)) = 'X' then
    Result := True;
end;

procedure GetDelimiterPositionsInRtf(ARichEdit: TRichEdit; SearchText: string;
  var DelimList: TStringList);
var
  k, StartPos, FoundAt, Endpos: integer;
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
      if k <> -1 then
        DelimList.Add(IntTostr(k));
      k := FindText(SearchText, k + Length(SearchText), Endpos, []);
    end;
  end; // with
  // ARichEdit.SelStart := 0;
  with ARichEdit do
  begin
    // SetFocus;
    SelStart := Perform(EM_LINEINDEX, 0, 0);
    SelLength := 0;
  end;

  // ARichEdit.HideScrollbars:=False;
end;

function IsConditionalRtfStatement(KeyW: string): Boolean;
// for letters
begin
  Result := False;
  if (UpperCase(LeftStr(KeyW, 4)) = 'IF (') or
    (UpperCase(LeftStr(KeyW, 3)) = 'IF(') or
    (UpperCase(LeftStr(KeyW, 7)) = 'ELSIF (') or
    (UpperCase(LeftStr(KeyW, 6)) = 'ELSIF(') then
    Result := True;
end;

procedure ConvertOldLetter(ARichEdit: TRichEdit);
var
  s: AnsiString;
begin
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
end;

procedure ReplaceRtfText(ARichEdit: TRichEdit; InSearch, InReplace: string);
var
  x, ToEnd: integer;
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

procedure GetLoginNames(TempList: TStringList);
begin
  if FileExists(AppDir + '\' + 'LoginNames') then
    TempList.LoadFromFile(AppDir + '\' + 'LoginNames');
end;

procedure UpdateLoginNames(Nm: string);
var
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  Nm := UpperCase(Nm);
  if FileExists(AppDir + '\' + 'LoginNames') then
    TempList.LoadFromFile(AppDir + '\' + 'LoginNames');
  if IsInList(Nm, TempList) < 0 then
    TempList.Add(Nm);
  TempList.SaveToFile(AppDir + '\' + 'LoginNames');
  TempList.Free;
end;

procedure InitRichEditStorage(RetNo: integer);
// strings will hold ponters to richdit fields
begin
end;

// ---------------------------New Functions Added---------------------------------------------

function RemoveHyphens(s: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to Length(s) do
    if s[i] <> '-' then
      Result := Result + s[i];
end;

procedure InsertKeyWToDataDict(FormName: string; AnEditBox: TvtEdit);
var
  KeyW: string;
  s: string;
  ADConnection: TADConnection;
  Table1: TADTable;
begin
  // 20150920 Igor
  ADConnection := TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  SetTableName(ADConnection, Table1, AppDir + '\' + DictDBLite, DictTableLite,
    'KeyWord');

  KeyW := ExtractNonInstFormName(FormName) + '_' +
    IntTostr(GetFieldId(AnEditBox.Name));
  if Table1.FindKey([KeyW]) = False then
  begin
    Table1.Insert;
    Table1.FieldByName('FormName').AsString := ExtractNonInstFormName(FormName);
    Table1.FieldByName('Field_No').AsInteger := GetFieldId(AnEditBox.Name);
    Table1.FieldByName('Descr').AsString := FormName + ' cell number' +
      IntTostr(GetFieldId(AnEditBox.Name));
    if AnEditBox.vtInputType = vtDollar then
      Table1.FieldByName('Is_Amount').AsString := 'Y'
    else
      Table1.FieldByName('Is_Amount').AsString := '';
  end;
  s := InputBox('Input Box', 'Enter a keyWord name for this data field', '');
  if s = '' then
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
  Table1.Free;
  ADConnection.Free;

  ShowMessage('The keyWord was added with name: ' + s + Chr(13) + ' ' +
    'You can further refine/delete keywords by clicking on Configure | Data Dictionary');
end;

function GetFldMemFormNo(RetNo: integer;
  RefFormName, RefFieldId: string): integer;
var
  i, FNo: integer;
  FrmNm: string; // [10];
const
  FName = 'FLDMEM';
begin
  Result := 0;
  for i := FList.FirstInstNo(FName) to FList.Count - 1 do
  begin
    FRec := FList.Items[i];
    if FRec.FormName <> FName then
      Break;
    begin
      FNo := FRec.FormNo;
      if (FetchElmFNo(RetNo, FNo, 17) = RefFormName) and
        (FetchElmFNo(RetNo, FNo, 18) = RefFieldId) then
      begin
        Result := FNo;
        exit;
      end;
    end;
  end;
end;

function GetTrTopicFromLineRef(FormName: string; FieldId: integer): string;
var
  i: integer;
  LineRef: TStringList;
begin
  Result := '';
  LineRef := TStringList.Create;
  LineRef.LoadFromFile(AppDir + '\' + 'Effields.d');
  for i := 0 to LineRef.Count - 1 do
  begin
    if FormName = AllTrim(MidStr(LineRef[i], 81, 9)) then
    begin
      if FieldId = MyStrToInt(AllTrim(MidStr(LineRef[i], 91, 3))) then
      begin
        Result := ReplaceChar(AllTrim(LeftStr(LineRef[i], 4)), '*', '');
        Break;
      end;
    end; { same formname }
  end; { i loop }
  LineRef.Free;
end;

function IsValidTrustNo(s: string): Boolean;
// T12345678
begin
  Result := True;
  if s = '' then
    exit;
  if UpperCase(LeftStr(s, 1)) <> 'T' then
  begin
    Result := False;
    exit;
  end;
  if Length(s) <> 9 then
  begin
    Result := False;
    exit;
  end;
  if not Numeric(MidStr(s, 2, 8)) then
  begin
    Result := False;
    exit;
  end;
end;

function GetFNoOfFirstInstance(FName: string; FNo: integer): integer;
begin
  Result := FNo;
  if IsFormMultiInst(FName) then
    Result := GetFormNo(ExtractNonInstFormName(FName) + '#1');
end;

procedure ImportT661Descriptions(RetNo: integer; FNo: integer; LineNo: integer);
var
  i, k, Mx: integer;
  ImportList: TStringList;
  flName: string;
begin
  if CheckIsCloud then
    exit; // 20180503 Igor
  with MainFormT2 do
  begin
    OpenDialog.Filter := 'Descriptions in TXT files(*.TXT)|*.TXT';
    if OpenDialog.Execute then
    begin
      flName := OpenDialog.FileName;
    end;
  end;
  if flName = '' then
    exit;

  // TempList:=TStringList.create;
  ImportList := TStringList.Create;
  try
    ImportList.LoadFromFile(flName);
  except
    ShowMessage('Import failed');
    exit;
  end;
  BreakGIFINotes78chars(ImportList);
  i := 0;
  k := LineNo;
  Mx := ImportList.Count - 1;
  if Mx > LineNo + 27 then
    Mx := LineNo + 27;

  repeat
    StoreElm(RetNo, FNo, k, LeftStr(ImportList[i], 78));
    Inc(i, 1);
    Inc(k, 1);
  until i > Mx;

  OpenForm(RetNo, FNo, LineNo);
  ImportList.Free;
  // TempList.free;
end;

procedure ImportGifiNotes(RetNo: integer);
var
  i, FNo: integer;
  ImportList, TempList: TStringList;
  flName: string;
begin
  if CheckIsCloud then
    exit; // 20180503 Igor
  if MessageDlg('This will replace ALL existing data on this form. Proceed??',
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;

  with MainFormT2 do
  begin
    OpenDialog.Filter := 'Notes in TXT files(*.TXT)|*.TXT';
    if OpenDialog.Execute then
    begin
      flName := OpenDialog.FileName;
    end;
  end;
  if flName = '' then
    exit;

  TempList := TStringList.Create;
  ImportList := TStringList.Create;
  try
    ImportList.LoadFromFile(flName);
  except
    ShowMessage('Import failed');
  end;
  // BreakGIFINotes78chars(ImportList);
  // For i:=0 to TempList.count-1 do ImportList.Add(TempList[i]);
  FNo := GetFormNo('FNOTE2'); // 20121002
  for i := 0 to ImportList.Count - 1 do
  begin
    if i > 500 then
      Break;
    StoreElm(RetNo, FNo, i + 10, LeftStr(ImportList[i], 78));
  end;
  OpenForm(RetNo, FNo, 0);
  ImportList.Free;
  TempList.Free;
end;

function CountT1163(RetNo: integer): integer;
var
  i, FNo: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'T1163' then
    begin
      FNo := FRec.FormNo;
      if Ret[RetNo].FrmHasData[FNo] then
        Inc(Result);
    end;
  end;
end;

function CountT1273(RetNo: integer): integer;
var
  i, FNo: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'T1273' then
    begin
      FNo := FRec.FormNo;
      if Ret[RetNo].FrmHasData[FNo] then
        Inc(Result);
    end;
  end;
end;

function IsT1273CashMethod(RetNo: integer; FInst: string): Boolean;
begin
  if FetchElm(RetNo, 'T1273' + FInst, 12) = '102' then
    Result := True
  else
    Result := False;
end;

function LandscapeFormsInFEDReturn(RetNo: integer): Boolean;
begin
  Result := False;
  if (Ret[RetNo].FrmHasData[GetFormNo('S8#1')]) or
    (Ret[RetNo].FrmHasData[GetFormNo('S9')]) or
    (Ret[RetNo].FrmHasData[GetFormNo('S8FREE#1')]) or
    (Ret[RetNo].FrmHasData[GetFormNo('S35_6')]) // ???
    or (Ret[RetNo].FrmHasData[GetFormNo('S38_5')]) // ???
    or (Ret[RetNo].FrmHasData[GetFormNo('T1273')]) then
    Result := True;
end;

function LandscapeFormsInALBReturn(RetNo: integer): Boolean;
begin
  Result := False;
  if (Ret[RetNo].FrmHasData[GetFormNo('AS10')]) or
    (Ret[RetNo].FrmHasData[GetFormNo('AS13')]) then
    Result := True;
end;

function ModifyFormOrText(FileToConvertFrom: string;
  ConversionType: string): Boolean;
var
  InputStream, OutputStream: TFileStream;
  FileToConvertTo: string;
begin
  Result := True;

  FileToConvertFrom := FileToConvertFrom; // ExtractFileName(FileToConvertFrom);

  FileToConvertTo := FileToConvertFrom;

  { change file extensions as appropriate }
  if ConversionType = 'FORM' then
  begin
    FileToConvertFrom := ChangeFileExt(FileToConvertFrom, '.TXT');
    FileToConvertTo := ChangeFileExt(FileToConvertFrom, '.DFM');
  end
  else if ConversionType = 'TEXT' then
  begin
    FileToConvertFrom := ChangeFileExt(FileToConvertFrom, '.DFM');
    FileToConvertTo := ChangeFileExt(FileToConvertFrom, '.TXT');
  end;

  if not FileExists(FileToConvertFrom) then
  begin
    ShowMessage('File ' + FileToConvertFrom + ' does not exist');
    Result := False;
    exit;
  end;

  InputStream := nil; // 20150702
  OutputStream := nil; // 20150702
  try
    try
      // Create a file stream for the specified file
      InputStream := TFileStream.Create(FileToConvertFrom, fmOpenRead);
      OutputStream := TFileStream.Create(FileToConvertTo, fmCreate);

      // perform the selected conversion

      if ConversionType = 'FORM' then
      begin
        ObjectTextToResource(InputStream, OutputStream);
      end
      else if ConversionType = 'TEXT' then
      begin
        ObjectResourceToText(InputStream, OutputStream);
      end;
    except
      on EStreamError do
      begin
        Result := False;
        ShowMessage('Form Failed: ' + FileToConvertFrom);
      end;
    end;
  finally
    InputStream.Free;
    OutputStream.Free;
  end;
end;

procedure ModifyAllForms;
// Var  Type TDFMorTXT = (ConvertToForm, ConvertToText);
var
  i, j: integer;
  TempList: TStringList;
  FName, DfmFileName: string;
begin
  Screen.Cursor := crHourGlass;
  TempList := TStringList.Create;
  try
    for i := 0 to FList.Count - 1 do
    begin
      FRec := FList.Items[i];
      FName := FRec.FormInstName;
      if FName = '' then
        continue;
      // MainForm.BitBtn1.Caption:=FName;
      DfmFileName := GetDfmFileName(FName);
      if FileExists(DfmFileName) then
      begin
        // convertDfmtoTxt(ToDir,FlName);
        ModifyFormOrText(DfmFileName, 'TEXT');
        TempList.LoadFromFile(ChangeFileExt(DfmFileName, '.txt'));
        for j := 0 to TempList.Count - 1 do
        begin
          if pos('vtVertSeparator', TempList[j]) > 0 then
          begin
            TempList[j] := '';
          end;
        end;
        TempList.SaveToFile((ChangeFileExt(DfmFileName, '.txt')));
        ModifyFormOrText(ChangeFileExt(DfmFileName, '.txt'), 'FORM');
      end;
    end;
  except
    ;
  end;
  Screen.Cursor := crDefault;
  TempList.Free;
  ShowMessage('Done');
end;

procedure FixAProperty;
var
  i, j: integer;
  TempList, vtCalcList: TStringList;
  StartPos: integer;
  FName, DfmFileName: string;
  vtCalcElmName: string;
begin
  // FIX vtCalc for all forms based on a list with Fname and Elm
  Screen.Cursor := crHourGlass;
  vtCalcList := TStringList.Create;
  TempList := TStringList.Create;
  vtCalcList.LoadFromFile(AppDir + '\vtCalcLinkList.txt');
  try
    for i := 0 to vtCalcList.Count - 1 do
    begin
      FName := AllTrim(LeftStr(vtCalcList[i], 10));
      DfmFileName := GetDfmFileName(FName);
      if FileExists(DfmFileName) then
      begin
        // convertDfmtoTxt(ToDir,FlName);
        // MainForm.bitbtn1.Caption := FName;
        ModifyFormOrText(DfmFileName, 'TEXT');
        TempList.LoadFromFile(ChangeFileExt(DfmFileName, '.txt'));

        vtCalcElmName := AllTrim(MidStr(vtCalcList[i], 10, 20));
        StartPos := TempList.indexof('  object ' + vtCalcElmName + ': TvtEdit');
        if StartPos > -1 then
        begin
          for j := StartPos to StartPos + 40 do // TempList.count - 1 do
          begin
            if pos('vtDataSource', TempList[j]) > 0 then
            begin
              if pos(UpperCase('end'), UpperCase(TempList[j])) > 0 then
              begin
                vtCalcList[i] := PaddR(vtCalcList[i], 40) +
                  'Failed..............';
                Break;
              end;
              TempList[j] := '    vtDataSource = vtLinked';
              vtCalcList[i] := PaddR(vtCalcList[i], 40) + 'Changed!??';
              Break;
            end;
          end;
        end
        else
        begin
          vtCalcList[i] := PaddR(vtCalcList[i], 40) + 'Failed..............';
        end;
        TempList.SaveToFile((ChangeFileExt(DfmFileName, '.txt')));
        vtCalcList.SaveToFile(AppDir + '\vtCalcList.txt');
        // convertTxttoDfm(ToDir,FlName);
        ModifyFormOrText(ChangeFileExt(DfmFileName, '.txt'), 'FORM');
      end;
    end;
  except
    ;
  end;
  vtCalcList.Free;
  TempList.Free;
  Screen.Cursor := crDefault;
  ShowMessage('Done');
  exit;
end;

function PrintLabels(DataDir, FileNm: string): Boolean;
var
  Tbl: TADTable;
  ADConnection: TADConnection;
  i, RecNo, LineCnt, MxLinesPerPage, PageCnt: integer;
  PrnFile: TextFile;
  XPos: LongInt;
  YPos: LongInt;
  InpFile: TextFile;
  InpKey: string;
  PixPerInX, PixPerInY: integer;
  LabelPosX, LabelPosY: integer;
  TopMargin, LeftMargin, LabelHeight, LabelWidth, VertIncr,
    HorizLabelGap: integer;
  Line1, Line2, Line3, Line4, Line5: string;
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

  { open the input file of keys }
  AssignFile(InpFile, FileNm);
  Reset(InpFile);
  { start printer }
  Printer.BeginDoc;
  { Get data from data base }
  // 20150922 Igor
  ADConnection := TADConnection.Create(Application);
  Tbl := TADTable.Create(Application);
  SetTableName(ADConnection, Tbl, DataDir + '\' + ClientsDBLite,
    ClientsTableLite, 'FILE_NAME');

  if Tbl.Active then
    Tbl.Close;
  Tbl.Open;

  RecNo := 0;
  while not Eof(InpFile) do
  begin
    Readln(InpFile, InpKey);
    // 20170223 Igor >>>
    if Tbl.FindKey([InpKey]) then
      if Tbl.Locate('FILE_NAME', InpKey, [loCaseInsensitive]) then
      // 20170223 Igor <<<

      begin
        Inc(RecNo);
        if RecNo > 30 then
        begin
          RecNo := 1;
          Printer.NewPage;
        end;
        Line1 := Tbl.FieldByName('Corp_Name').AsString;
        Line2 := Tbl.FieldByName('STREET').AsString;
        Line3 := Tbl.FieldByName('CITY').AsString;
        Line4 := Tbl.FieldByName('PROVINCE').AsString + ', ' +
          Tbl.FieldByName('POSTAL').AsString;

        if RecNo < 11 then { left label }
        begin
          LabelPosX := LeftMargin;
          LabelPosY := TopMargin + (RecNo - 1) * LabelHeight;
        end;
        if (RecNo > 10) and (RecNo < 21) then { Midle label }
        begin
          LabelPosX := LeftMargin + LabelWidth + HorizLabelGap;
          LabelPosY := TopMargin + (RecNo - 11) * LabelHeight;
        end;
        if (RecNo > 20) and (RecNo < 31) then { right label }
        begin
          LabelPosX := LeftMargin + 2 * LabelWidth + 3 * HorizLabelGap;
          LabelPosY := TopMargin + (RecNo - 21) * LabelHeight;
        end;
        PrintALabel(LabelPosX, LabelPosY, Line1, Line2, Line3, Line4, Line5);
      end;
  end; { end while }

  CloseFile(InpFile);
  Tbl.Free;
  ADConnection.Free;
  Printer.EndDoc;
  Result := True;
end;

procedure PrintALabel(LabelPosX, LabelPosY: integer;
  Line1, Line2, Line3, Line4, Line5: string);
{ pos in pixels }
var
  XPos, YPos, VertIncr, PixPerInX, PixPerInY: integer;
begin
  Printer.Canvas.Font.Name := 'Arial';
  PixPerInX := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
  PixPerInY := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
  Printer.Canvas.Font.Size := 8;
  XPos := LabelPosX + 2;
  YPos := LabelPosY + 2;
  VertIncr := Trunc(PixPerInY * (1 / 6));
  Printer.Canvas.Font.Style := [fsBold];
  Printer.Canvas.TextOut(XPos, YPos, Line1);
  Printer.Canvas.Font.Style := [];
  Printer.Canvas.TextOut(XPos, YPos + 1 * VertIncr, Line2);
  Printer.Canvas.TextOut(XPos, YPos + 2 * VertIncr, Line3);
  Printer.Canvas.TextOut(XPos, YPos + 3 * VertIncr, Line4);
  Printer.Canvas.TextOut(XPos, YPos + 4 * VertIncr, Line5);
end;

procedure InitPredictiveFiles;
var
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  TempList.Add(' ');
  if FileExists(AppDir + '\' + 'CorpBn.txt') = False then
    TempList.SaveToFile(AppDir + '\' + 'CorpBn.txt');

  if FileExists(AppDir + '\' + 'CorpNm.txt') = False then
    TempList.SaveToFile(AppDir + '\' + 'CorpNm.txt');

  if FileExists(AppDir + '\' + 'Cities.txt') = False then
    TempList.SaveToFile(AppDir + '\' + 'Cities.txt');

  if FileExists(AppDir + '\' + 'Charity.txt') = False then
    TempList.SaveToFile(AppDir + '\' + 'Charity.txt');
  TempList.Free;
end;

procedure CopyS23FromS9(RetNo: integer);
var
  i, j, S9FNo, S23FNo: integer;
begin
  S9FNo := GetFormNo('S9');
  S23FNo := GetFormNo('S23');
  for i := 5 to 126 do
    StoreElm(RetNo, S23FNo, i, '');
  // 20170726
  StoreElm(RetNo, S23FNo, 5, GetCorpName(RetNo));
  StoreElm(RetNo, S23FNo, 6, GetCorpBusNo(RetNo));
  i := 11; // ndx to s23
  j := 4; // ndx to s9
  repeat
    StoreElm(RetNo, S23FNo, i, FetchElmFNo(RetNo, S9FNo, j));
    StoreElm(RetNo, S23FNo, i + 1, FetchElmFNo(RetNo, S9FNo, j + 2));
    Inc(i, 6);
    Inc(j, 9);
  until j > 175; // 166;  //20170726
end;

(*
  procedure CopyS23FromS9(RetNo: Integer);
  var
  i, j, S9FNo, S23FNo: Integer;
  begin
  S9FNo := GetFormNo('S9');
  S23FNo := GetFormNo('S23');
  for i := 5 to 126 do
  StoreElm(RetNo, S23FNo, i, '');
  i := 11; //ndx to s23
  j := 4; //ndx to s9
  repeat
  StoreElm(RetNo, S23FNo, i, FetchElmFNo(RetNo, S9FNo, j));
  StoreElm(RetNo, S23FNo, i + 1, FetchElmFNo(RetNo, S9FNo, j + 2));
  Inc(i, 6);
  Inc(j, 9);
  until j > 166;
  end;
*)

procedure CopyS49FromS23(RetNo: integer);
var
  i, j, S23FNo, S49FNo: integer;
begin
  S23FNo := GetFormNo('S23');
  S49FNo := GetFormNo('S49');
  for i := 5 to 127 do
    StoreElm(RetNo, S49FNo, i, '');
  StoreElm(RetNo, S49FNo, 129, '');
  i := 5; // ndx to s49
  repeat
    StoreElm(RetNo, S49FNo, i, FetchElmFNo(RetNo, S23FNo, i));
    StoreElm(RetNo, S49FNo, i + 1, FetchElmFNo(RetNo, S23FNo, i + 1));
    StoreElm(RetNo, S49FNo, i + 2, FetchElmFNo(RetNo, S23FNo, i + 2));
    // StoreElm(RetNo,S49FNo,i+3,FetchElmFNo(RetNo,S23FNo,i+3)); //20100628
    Inc(i, 6);
  until i > 119;
  StoreElm(RetNo, S49FNo, 8, FetchElm(RetNo, 'T2', 342)); // 20100628
end;

function RsiS13HasData(RetNo: integer): Boolean;
var
  S13FNo: integer;
begin
  S13FNo := GetFormNo('S13');
  Result := False;
  if (VL(FetchElmFNo(RetNo, S13FNo, 28)) <> 0) or
    (VL(FetchElmFNo(RetNo, S13FNo, 29)) <> 0) or
    (VL(FetchElmFNo(RetNo, S13FNo, 30)) <> 0) or
    (VL(FetchElmFNo(RetNo, S13FNo, 52)) <> 0) or
    (VL(FetchElmFNo(RetNo, S13FNo, 53)) <> 0) or
    (VL(FetchElmFNo(RetNo, S13FNo, 54)) <> 0) then
    Result := True;
end;

procedure OpenUsedForms(RetNo: integer);
var
  i, UsedFNo, FNo: integer;
  FName: string;
begin
  if OptRec.ShowUsedForms = False then
    exit;
  UsedFNo := GetFormNo('USEDFRM');
  LockWindowUpdate(MainForm.Handle);
  for i := 1 to 15 do
  begin
    FName := AllTrim(FetchElmFNo(RetNo, UsedFNo, i));
    if FName > '' then
    begin
      FNo := GetFormNo(FName);
      if FNo > 0 then
        OpenForm(RetNo, FNo, 0);
    end;
  end; // 20150811

  if OptRec.OpenAtLastForm then
  begin
    FName := AllTrim(FetchElmFNo(RetNo, UsedFNo, 31));
    FNo := GetFormNo(FName);
    if FNo > 0 then
      OpenForm(RetNo, FNo, 0);
  end
  else
  begin
    FName := 'T2';
    FNo := GetFormNo(FName);
    if FNo > 0 then
      OpenForm(RetNo, FNo, 0);
  end;
  LockWindowUpdate(0);
end;

function IsOversizedForm(FName: string): Boolean;
var
  i: integer;
begin
  FRec := FList.ByFormName(FName); // any instance
  Result := FRec.MultiPage;
end;

procedure RemoveEmptyFGS(flName: string);
begin
  // from Efile COR file
end;

function FormatT1273Decimals(s: string): string;
var
  S1, S2: string;
begin
  Result := s;
  S1 := ExtractIntegerPart(s);
  S2 := ExtractDecimalPart(s);
  Result := S1 + '.' + PaddRZero(S2, 3);
  Result := RmvLeadingZeros(Result);
  if Result = '.000' then
    Result := '0.000';
end;

function PaddRZero(s: string; MaxLength: integer): string;
{ Fill to the end with zeros }
begin
  s := Ltrim(RTrim(s));
  Result := LeftStr(s, MaxLength) + FilledStr(PaddCount(s, MaxLength), '0');
end;

function GetUserCaisCodeDescr(Code: string): string;
var
  InputString: string;
begin
  InputString := InputBox('Input Box', 'Enter description for code ' +
    Code, '');
  Result := InputString;
end;

function IsDic(RetNo: integer): Boolean;
// direct deposit corp
begin
  if (UpperCase(FetchElm(RetNo, 'S53', 87)) = 'Y') then
    Result := True
  else
    Result := False;
end;

function GetValueFromDisk(FullFlName: string; FName: string;
  Elm: integer): string;
var
  TempList: TStringList;
begin
  Result := '';
  if not FileExists(FullFlName) then
  begin
    ShowMessage('Cannot locate ' + Chr(39) + 's file or directory');
    exit;
  end;
  TempList := TStringList.Create;
  TempList.LoadFromFile(FullFlName);
  Result := GetTheValue(TempList, FName, Elm);
  TempList.Free;
end;

function GetTheValue(TempList: TStringList; FName: string;
  Elm: integer): string;
{ templist is the tax return data }
var
  i, j: integer;
  WList: TStringList;
  Rec: string;
begin
  Result := '';
  WList := TStringList.Create;
  for i := 1 to TempList.Count - 2 do // -2 otherwise it abends
  begin
    Rec := TempList[i];
    ParseWords(Rec, Delimiter, WList);
    if (WList[0] = 'F') and (WList[1] = FName) then
    begin
      j := i + 1;
      repeat
        Rec := TempList[j];
        ParseWords(Rec, Delimiter, WList);
        if (WList[0] = 'D') then
        begin
          if VL(WList[1]) = Elm then
          begin
            Result := WList[2];
            WList.Free;
            exit;
          end;
        end;
        Inc(j);
      until (j > TempList.Count - 2) or (LeftStr(Rec, 2) = 'F' + Delimiter);
      { end form data }
    end; { within form nm }
  end; { i }
  WList.Free;
end;

function IsAlpha(s: string): Boolean;
var
  i: integer;
begin
  Result := True;
  for i := 1 to Length(s) do
  begin
    if (CharInSet(s[i], ['a' .. 'z', 'A' .. 'Z', '_', ' '])) or (s[i] = Chr(39))
    // apostrophe //20100407
      or (s[i] = Chr(233)) // é
      or (s[i] = Chr(232)) { //è } then
      // ok
    else
    begin
      Result := False;
      exit;
    end;
  end;
  // If Numeric(S) then result=False else result:=True;
end;

procedure CopyS23ToOITCBusLimit(RetNo: integer);
var
  i, j, S23FNo, OITCFNo: integer;
  s: string;
begin
  S23FNo := GetFormNo('S23');
  OITCFNo := GetFormNo('OITC_4');
  for i := 4 to 23 do
    StoreElm(RetNo, OITCFNo, i, '');
  // StoreElm(RetNo,S49FNo,129,'');
  i := 4; // ndx to OITCFNo
  j := 5; // index to S23
  repeat
    StoreElm(RetNo, OITCFNo, i, FetchElmFNo(RetNo, S23FNo, j)); // nm
    StoreElm(RetNo, OITCFNo, i + 1, FetchElmFNo(RetNo, S23FNo, j + 1)); // bn
    s := FetchElmFNo(RetNo, S23FNo, j + 3);
    StoreElm(RetNo, OITCFNo, i + 2, FetchElmFNo(RetNo, S23FNo, j + 3)); // b lim
    StoreElm(RetNo, OITCFNo, i + 3, FetchElmFNo(RetNo, S23FNo, j + 4)); // %
    Inc(i, 5);
    Inc(j, 6);
  until i > 19;
end;

procedure CopyOT2013ToOITCBusLimit(RetNo: integer);
var
  i, j, OT2013FNo, OITCFNo: integer;
begin
  OT2013FNo := GetFormNo('OT2013');
  OITCFNo := GetFormNo('OITC_4');
  i := 64; // ndx to OITCFNo
  j := 3; // index to OT2013
  repeat
    StoreElm(RetNo, OITCFNo, i, FetchElmFNo(RetNo, OT2013FNo, j)); // nm
    Inc(i, 1);
    Inc(j, 7);
  until i > 67;
end;

procedure CopyOT2013ToOITCPart1(RetNo: integer);
var
  i, j, OT2013FNo, OITCFNo: integer;
begin
  OT2013FNo := GetFormNo('OT2013');
  OITCFNo := GetFormNo('OITC_1');
  i := 18; // ndx to OITCFNo
  j := 8; // index to OT2013
  repeat
    StoreElm(RetNo, OITCFNo, i, FetchElmFNo(RetNo, OT2013FNo, j)); // nm
    StoreElm(RetNo, OITCFNo, i + 1, FetchElmFNo(RetNo, OT2013FNo, j + 1));
    // Account
    // StoreElm(RetNo,OITCFNo,i+2,FetchElmFNo(RetNo,OT2013FNo,j+2)); //y/e
    Inc(i, 4);
    Inc(j, 7);
  until i > 26;
end;

// 20180531
function RoundUp(R: Real): LongInt;
begin
  Result := Trunc(R); // extract the integer part
  if Frac(R) >= 0.5 then // if fractional part >= 0.5 then...
    Result := Result + 1; // ...add 1
end;

// 20180531
function RoundDown(R: Real): LongInt;
begin
  Result := Trunc(R); // extract the integer part
  // if Frac(R) >= 0.5 then // if fractional part >= 0.5 then...
  // Result := Result + 1; // ...add 1
end;

function RoundCorrect(R: Real): Int64; //LongInt; //202605018 Alex
begin
  Result := Trunc(R); // extract the integer part
  if Frac(R) >= 0.5 then // if fractional part >= 0.5 then...
    Result := Result + 1; // ...add 1
end;

function RoundN(x: Extended; d: integer): Extended;
// RoundN(123.456, 0) = 123.00
// RoundN(123.456, 2) = 123.46
// RoundN(123456, -3) = 123000
const
  t: array [0 .. 12] of int64 = (1, 10, 100, 1000, 10000, 100000, 1000000,
    10000000, 100000000, 1000000000, 10000000000, 100000000000, 1000000000000);
begin
  if ABS(d) > 12 then
    raise ERangeError.Create('RoundN: Value must be in -12..12');
  if d = 0 then
    Result := Int(x) + Int(Frac(x) * 2)
  else if d > 0 then
  begin
    x := x * t[d];
    Result := (Int(x) + Int(Frac(x) * 2)) / t[d];
  end
  else
  begin // d < 0
    x := x / t[-d];
    Result := (Int(x) + Int(Frac(x) * 2)) * t[-d];
  end;
end;

function CalcOntCapTaxRate(RetNo: integer; YearEnd: string): Real;
var
  DaysInYear: integer;
begin
  DaysInYear := Ret[RetNo].DaysInYear; // 365;
  Result := RoundN(0.3 * VL(IntTostr(GetNumDays(RetNo, '01-01-2007', 'B'))) /
    DaysInYear + 0.285 * VL(IntTostr(GetNumDays(RetNo, '31-12-2006',
    'A') - GetNumDays(RetNo, '31-12-2008', 'A'))) / DaysInYear, 4);
end;

function GetTxblIncBfrLosses(RetNo: integer): Real;
begin
  with Ret[RetNo] do
    Result := MaxR(0, Ln[300] - Ln[311] - Ln[313] - Ln[314] - Ln[315] - Ln[320]
      - Ln[325] - Ln[340] - Ln[345] - Ln[350]); // - Ln[312]   //20161113

end;

function GetTxblIncBfrNetCapLosses(RetNo: integer): Real;
// to determine line 332
begin
  with Ret[RetNo] do
    Result := MaxR(0, Ln[300] - Ln[311] - Ln[313] - Ln[314] - Ln[315] - Ln[320]
      - Ln[325] - Ln[331] - Ln[333] - Ln[334] - Ln[335] - Ln[340] - Ln[350]);
  // -Ln[332]  //- Ln[312] 20161113

end;

function GetBeforeAfterDays(RetNo: integer; ADate: string; BfrAftr: string;
  BegDate: string; EndDate: string): integer;
// all date come as yyyy/mm/dd
var
  i: integer;
  DaysInYear: integer;
begin
  Result := 0;
  try
    // ADate:=YYYYMMDDToMMDDYYYY(ADate); {convert to mm/dd/yyyy}
    // BegDate := YYYYMMDDToMMDDYYYY(BegDate);
    // EndDate := YYYYMMDDToMMDDYYYY(EndDate);
    DaysInYear := DateDiffYMD(BegDate, EndDate);
    if Ret[RetNo].DaysInYear <= 0 then
      DaysInYear := 365;
    if Ret[RetNo].DaysInYear > 375 then
      DaysInYear := 375;

    if BfrAftr = 'B' then
      Result := DateDiffYMD(BegDate, ADate) - 1
    else
      Result := DateDiffYMD(ADate, EndDate) - 1;

    if Result < 0 then
      Result := 0;
    if Result > Ret[RetNo].DaysInYear then
      Result := Ret[RetNo].DaysInYear;
  except
    on E: Exception do
      MessageDlg('Num of days ' + E.Message, mtError, [mbok], 0);
  end;
end;

function ValidT2Date(Dt: string): Boolean;
begin
  Result := True;
  if (Length(Dt) <> 10) or (MidStr(Dt, 5, 1) <> '/') or (MidStr(Dt, 8, 1) <> '/')
  then
    Result := False;
  {
    or (Length(Value)=10)
    then
    begin
    Value:=RemoveChar(Value,'-');
    Value:=RemoveChar(Value,'/');
    Value:=LeftStr(value,4)+'/'+MidStr(value,5,2)+'/'+RightStr(value,2);
  }
end;

procedure BreakGIFINotes78chars(var ImportList: TStringList);
var
  i: integer;
  s: string;
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  i := 0;
  repeat
    TempList.Add(WrapText(ImportList[i], 78));
    Inc(i);
  until i > ImportList.Count - 1;
  ImportList.clear;
  for i := 0 to TempList.Count - 1 do
    ImportList.Add(TempList[i]);
  TempList.Free;
end;

function FindPosOfLastSpace(s: string): integer;
var
  i: integer;
begin
  i := Length(s);
  Result := i;
  repeat
    if s[i] = '' then
    begin
      Result := i;
      exit;
    end;
    Dec(i, 1);
  until i < 1;
end;

procedure OpenMsWord;
var
  wrdApp, wrdDoc: Variant;
  StrToAdd: string;
  wrdSelection: Variant;
begin
  // Create an instance of Word and make it visible
  wrdApp := CreateOleObject('Word.Application');
  wrdApp.Visible := True;
  // Create a new document
  wrdDoc := wrdApp.Documents.Add();
  wrdDoc.Select;
  wrdSelection := wrdApp.Selection;
  wrdSelection.TypeText(' ');
end;

function IsAuthorizedPreparer: Boolean;
// 20190226 //20190311 Igor //removed OnlineNo //20190311 //20220512 Igor
var
  i: integer;
  url, localDir, remoteFlName, localFlName, ExpKeysFlName, LicenseKey, TempStr,
    s: string;
  TempList: TStringList;
  EfilerNo: String; // 20190311 CON
  PreparerStreet: string; // 20190417
begin
  Result := True; // 20220530
  // 20220410
  // Result:=True;
  // Exit;
  // ==========================

  // Result := True;
  // EXIT;         //20220505 Does not work without Internet
  // Result := True;  //20220527

  if not IsInternetConnectionActive then
    exit;
  Screen.Cursor := crHourGlass;
  try
    url := 'https://www.visualtax.com/downloads/'; // 20220411 Igor
    localDir := AppDir + '\'; // where the dowloaded files are saved
    remoteFlName := 'ExpKeysT2.txt';
    ExpKeysFlName := 'ExpKeysT2.txt'; // expired tr keys

    { SomeString := TstringList.Create;
      if FileExists(AppDir + '\' + 'LVerf.EX_') then
      SomeString.LoadFromFile(AppDir + '\' + 'LVerf.EX_')
      else
      Exit;     //ALWAYS EXITS as there is no lverf in the T2 dir (only in C:\vt-20xx)    //20190226 }

    try
      TempList := TStringList.Create;
      try
        if DownLoadFromWeb(url, remoteFlName, localDir, ExpKeysFlName) then
        begin
          LicenseKey := AppT2.GetLicenseKey;
          if FileExists(AppDir + '\' + ExpKeysFlName) then
          begin
            TempList.LoadFromFile(AppDir + '\' + ExpKeysFlName);

            If TempList.Count > 0 then // 20190401
            Begin
              if LeftStr(UpperCase(TempList[0]), 7) = 'MON-OFF' then
              Begin
                Result := True;
                exit;
              end; // no monitoring meaning everybody is authorized otherwise continue MON-ON
            End;

            for i := 0 to TempList.Count - 1 do
            begin
              TempStr := AllTrim(TempList[i]);
              if SameText(LicenseKey, Copy(TempStr, 1, 19)) or
                SameText(OptRec.Prp_Name, AllTrim(TempList[i])) // 20190311 con
              // or (UpperCase(LeftStr(TempStr, 5))=UpperCase(OnlineNo)) //201190226 //
              then
              begin
                ShowMessage
                  ('VT Program Authorization Failure. Contact VisualTax by Email only');
                // 20180824 CON instaed of Authorization failure //20181119
                Result := False;
                Break;
              end;

              GetEOLParms(EfilerNo, s, s, s);
              If EfilerNo > '' then
              begin
                If UpperCase(EfilerNo) = UpperCase(LeftStr(TempStr, 5)) then
                begin
                  ShowMessage
                    ('VT Program Authorization Failure. Contact VisualTax by Email only');
                  // 20180824 CON instead of Authorization Failure  //20181119
                  Result := False;
                  Break;
                end;
              end;
              // Check preparer Street  //20190417
              PreparerStreet :=
                UpperCase(AllTrim(LeftStr(OptRec.Prp_Street, 25)));
              If PreparerStreet > '' then
              begin
                If PreparerStreet = UpperCase(AllTrim(LeftStr(TempList[i], 25)))
                then
                begin
                  ShowMessage
                    ('VT Program Authorization Failure. Contact VisualTax by Email only');
                  Result := False;
                  Break;
                end;
              end;
            end;
          end;
        end;
      finally
        if FileExists(AppDir + '\' + ExpKeysFlName) then
          DeleteFile(PChar(AppDir + '\' + ExpKeysFlName));
        TempList.Free;
      end;
    except // do not show errors
    end
  finally
    Screen.Cursor := crDefault;
  end;
end;

(*
  function IsAuthorizedPreparer: Boolean;  //20190226 //20190311 Igor //removed OnlineNo //20190311
  var
  i: integer;
  url, LocalDir, RemoteFlName, LocalFlName, ExpKeysFlName,LicenseKey,TempStr,s: string;
  tempList: TStringList;
  EfilerNo:String;  //20190311 CON
  PreparerStreet:string; //20190417
  begin
  //20220410
  //Result:=True;
  //Exit;
  //==========================

  Result := True;
  EXIT;         //20220505 Does not work without Internet

  url := 'https://www.visualtax.com/downloads/';  //20220411 Igor
  LocalDir := appdir + '\'; //where the dowloaded files are saved
  RemoteFlName  := 'ExpKeysT2.txt';
  ExpKeysFlName := 'ExpKeysT2.txt'; //expired tr keys

  {SomeString := TstringList.Create;
  if FileExists(AppDir + '\' + 'LVerf.EX_') then
  SomeString.LoadFromFile(AppDir + '\' + 'LVerf.EX_')
  else
  Exit;     //ALWAYS EXITS as there is no lverf in the T2 dir (only in C:\vt-20xx)    //20190226}

  TempList := TStringList.Create;
  try
  if DownLoadFromWeb(url, remoteFlName, localDir, ExpKeysFlName) then
  begin
  LicenseKey := AppT2.GetLicenseKey;
  if FileExists(AppDir + '\' + ExpKeysFlName) then
  begin
  TempList.LoadFromFile(AppDir + '\' + ExpKeysFlName);

  If TempList.count>0 then //20190401
  Begin
  if LeftStr(Uppercase(TempList[0]),7)='MON-OFF' then
  Begin Result:=True;exit;end;   //no monitoring meaning everybody is authorized otherwise continue MON-ON
  End;

  for i := 0 to TempList.count - 1 do
  begin
  TempStr := AllTrim(TempList[i]);
  if SameText(LicenseKey, Copy(TempStr, 1, 19))
  or SameText(OptRec.Prp_Name, AllTrim(TempList[i])) //20190311 con
  // or (UpperCase(LeftStr(TempStr, 5))=UpperCase(OnlineNo)) //201190226 //
  then
  begin
  ShowMessage('VT Program Authorization Failure. Contact VisualTax by Email only');   //20180824 CON instaed of Authorization failure //20181119
  Result := False;
  break;
  end;

  GetEOLParms(EfilerNo,s,s,s);
  If EfilerNo >'' then
  begin
  If UpperCase(EfilerNo)=UpperCase(LeftStr(TempStr,5)) then
  begin
  ShowMessage('VT Program Authorization Failure. Contact VisualTax by Email only'); //20180824 CON instead of Authorization Failure  //20181119
  Result:=False;
  Break;
  end;
  end;
  //Check preparer Street  //20190417
  PreparerStreet:=UpperCase(AllTrim(LeftStr(OptRec.Prp_Street,25)));
  If PreparerStreet > '' then
  begin
  If PreparerStreet=UpperCase(AllTrim(LeftStr(TempList[i],25))) then
  begin
  ShowMessage
  ('VT Program Authorization Failure. Contact VisualTax by Email only');
  result := false;
  Break;
  end;
  end;
  end;
  end;
  end;
  finally
  if FileExists(AppDir + '\' + ExpKeysFlName) then
  DeleteFile(Pchar(AppDir + '\' + ExpKeysFlName));
  TempList.Free;
  end;
  end;
*)
Function DownLoadFromWeb(url, remoteFlName, localDir, localFlName: string)
// 20220411 Igor
  : Boolean; // 20190311 Igor
var
  fileUrl, FileName: string;
begin
  Result := True;
  fileUrl := url + remoteFlName;
  FileName := localDir + localFlName;
  if not(SameText(Copy(fileUrl, 1, 7), 'http://') or
    SameText(Copy(fileUrl, 1, 8), 'https://')) then
    fileUrl := 'https://' + fileUrl;
  GetFileWithNoCache(fileUrl, FileName);
end;

(* //20220411 Igor
  function DownLoadFromWeb(url, remoteFlName, localDir, localFlName: string): boolean; //20190311 Igor
  const
  BufferSize = 1024;
  var
  hSession, hURL: HInternet;
  Buffer: array[1..BufferSize] of Byte;
  BufferLen: DWORD;
  f: file;
  sAppName: string;
  fileURL, FileName: string;
  begin
  fileURL := url + remoteFlName;

  if Pos('?', fileUrl) = 0 then
  fileUrl := fileUrl + '?readtime='+FormatDateTime('yyyymmddhhnnss',now); // avoid cached file
  if not (SameText(Copy(fileUrl, 1, 7), 'http://') or SameText(Copy(fileUrl, 1, 8), 'https://')) then
  fileUrl := 'http://'+ fileUrl; // avoid error with h_url

  FileName := localDir + localFlName;
  Result := False;
  sAppName := ExtractFileName(Application.ExeName);

  hSession := InternetOpen(PChar('' + sAppName), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  If hSession=Nil then exit; //does not work
  try
  result := false;
  hURL := InternetOpenURL(hSession, PChar('' + fileURL), nil, 0, 0, 0);
  If hUrl=Nil then exit;  //does not work //20190311 Igor
  try
  AssignFile(f, FileName);
  Rewrite(f, 1);
  repeat
  InternetReadFile(hURL, @Buffer, SizeOf(Buffer), BufferLen);
  Screen.Cursor := crHourGlass;
  BlockWrite(f, Buffer, BufferLen);
  //ProgressBar1.Position:=ProgressBar1.Position+1000;
  until BufferLen = 0;
  CloseFile(f);
  Result := True;
  finally
  InternetCloseHandle(hURL)
  end
  finally
  InternetCloseHandle(hSession)
  end;
  Screen.Cursor := crDefault;
  end;
*)

(*
  function DownLoadFromWeb(url, remoteFlName, localDir, localFlName: string): boolean; //20190311 Igor
  const
  BufferSize = 1024;
  var
  hSession, hURL: HInternet;
  Buffer: array[1..BufferSize] of Byte;
  BufferLen: DWORD;
  f: file;
  sAppName: string;
  fileURL, FileName: string;
  begin
  fileURL := url + remoteFlName;

  if Pos('?', fileUrl) = 0 then
  fileUrl := fileUrl + '?readtime='+FormatDateTime('yyyymmddhhnnss',now); // avoid cached file
  if not (SameText(Copy(fileUrl, 1, 7), 'http://') or SameText(Copy(fileUrl, 1, 8), 'https://')) then
  fileUrl := 'http://'+ fileUrl; // avoid error with h_url

  FileName := localDir + localFlName;
  Result := False;
  sAppName := ExtractFileName(Application.ExeName);

  hSession := InternetOpen(PChar('' + sAppName), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  If hSession=Nil then exit; //does not work
  try
  result := false;
  hURL := InternetOpenURL(hSession, PChar('' + fileURL), nil, 0, 0, 0);
  If hUrl=Nil then exit;  //does not work //20190311 Igor
  try
  AssignFile(f, FileName);
  Rewrite(f, 1);
  repeat
  InternetReadFile(hURL, @Buffer, SizeOf(Buffer), BufferLen);
  Screen.Cursor := crHourGlass;
  BlockWrite(f, Buffer, BufferLen);
  //ProgressBar1.Position:=ProgressBar1.Position+1000;
  until BufferLen = 0;
  CloseFile(f);
  Result := True;
  finally
  InternetCloseHandle(hURL)
  end
  finally
  InternetCloseHandle(hSession)
  end;
  Screen.Cursor := crDefault;
  end;
*)
function GetPreparerInfo(RedirectToSite: string): string;
var
  PrepInfo: string;
  EfileNo: string;
begin
  EfileNo := GetEOLAgentNo;
  // If EfileNo='' then GetEolPAgentNo;
  PrepInfo := '?RedirectURL=' + RedirectToSite; // 'www.visualtax.com';
  PrepInfo := PrepInfo + '&pLic=' + AllTrim(LeftStr(GetAuthorizationKey, 20));
  PrepInfo := PrepInfo + '&pName=' + OptRec.Prp_Name;
  PrepInfo := PrepInfo + '&pStreet=' + RemoveChar(OptRec.Prp_Street, '#');
  PrepInfo := PrepInfo + '&pCity=' + OptRec.Prp_City;
  PrepInfo := PrepInfo + '&pProv=' + OptRec.Prp_Prov;
  PrepInfo := PrepInfo + '&pPostal=' + OptRec.Prp_Postal;
  PrepInfo := PrepInfo + '&pArea=' + OptRec.Prp_Area;
  PrepInfo := PrepInfo + '&pPhone=' + OptRec.Prp_Tel;
  PrepInfo := PrepInfo + '&pEfileNo=' + EfileNo;
  Result := PrepInfo;

  // ShellExecute(MainForm.Handle,'open',Pchar('' + 'http://www.visualtax.com/emailer/collectEfileData.asp' + sendInfoString), Nil,Nil, SW_RESTORE);
end;

function GetOntDomesticFactor(RetNo: integer): string;
begin
  if Ret[RetNo].Province = 'ON' then
  begin
    Result := '1.00000';
    exit;
  end;
  if GetTxblIncomeInAllProv(RetNo) > 0 then
  // GetTxblIncome(RetNo)>0 then  //20090621
    Result := FormatFloat('##0.00000',
      RoundN(GetTxblIncomeInProv(RetNo, 'ON') / GetTxblIncomeInAllProv
      (RetNo), 4))
    // Result := FormatFloat('##0.00000',RoundN(GetTxblIncomeInProv(RetNo,'ON')/GetTxblIncome(RetNo),4))
  else
    Result := '';
end;

(*
  Procedure CopyS501FromS23(RetNo:Integer);
  Var i,j,S23FNo,S501FNo:Integer;
  begin
  S23FNo:=GetFormNo('S23');
  S501FNo:=GetFormNo('S501');
  //  For i:=4 to 84 do StoreElm(RetNo,S501FNo,i,'');
  i:=4; //ndx to s501
  j:=11;  //ndx to s23 second line
  Repeat
  StoreElm(RetNo,S501FNo,i,FetchElmFNo(RetNo,S23FNo,j));
  StoreElm(RetNo,S501FNo,i+1,FetchElmFNo(RetNo,S23FNo,j+1));
  Inc(i,4);
  Inc(j,6);
  until j>119;
  end;
*)

procedure CopyS566FromS23(RetNo: integer);
var
  i, j, S23FNo, S566FNo: integer;
begin
  S23FNo := GetFormNo('S23');
  S566FNo := GetFormNo('S566');
  // For i:=15 to 74 do StoreElm(RetNo,S568FNo,i,'');
  i := 48; // ndx to s552
  j := 5; // ndx to s23
  repeat
    StoreElm(RetNo, S566FNo, i, FetchElmFNo(RetNo, S23FNo, j));
    StoreElm(RetNo, S566FNo, i + 1, FetchElmFNo(RetNo, S23FNo, j + 1));
    Inc(i, 3);
    Inc(j, 6);
  until j > 105;
end;

procedure CopyS568FromS23(RetNo: integer);
var
  i, j, S23FNo, S568FNo: integer;
begin
  S23FNo := GetFormNo('S23');
  S568FNo := GetFormNo('S568');
  for i := 15 to 74 do
    StoreElm(RetNo, S568FNo, i, '');
  i := 15; // ndx to s568
  j := 5; // ndx to s23
  repeat
    StoreElm(RetNo, S568FNo, i, FetchElmFNo(RetNo, S23FNo, j));
    StoreElm(RetNo, S568FNo, i + 1, FetchElmFNo(RetNo, S23FNo, j + 1));
    Inc(i, 3);
    Inc(j, 6);
  until j > 119;
end;

procedure CopyS511FromS23(RetNo: integer);
var
  i, j, S23FNo, S511FNo: integer;
begin
  S23FNo := GetFormNo('S23');
  S511FNo := GetFormNo('S511');
  for i := 4 to 84 do
    StoreElm(RetNo, S511FNo, i, '');
  i := 4; // ndx to s511
  j := 11; // ndx to s23 second line
  repeat
    StoreElm(RetNo, S511FNo, i, FetchElmFNo(RetNo, S23FNo, j));
    StoreElm(RetNo, S511FNo, i + 1, FetchElmFNo(RetNo, S23FNo, j + 1));
    Inc(i, 4);
    Inc(j, 6);
  until j > 119;
end;

procedure CopyS513FromS9(RetNo: integer);
var
  i, j, S9FNo, S513FNo: integer;
begin
  S9FNo := GetFormNo('S9');
  S513FNo := GetFormNo('S513');
  for i := 4 to 63 do
    StoreElm(RetNo, S513FNo, i, '');
  StoreElm(RetNo, S513FNo, 4, GetCorpName(RetNo));
  StoreElm(RetNo, S513FNo, 5, GetCorpBusNo(RetNo));

  i := 7; // ndx to s513
  j := 4; // 5;  //ndx to S9 //ndx to s23
  repeat
    StoreElm(RetNo, S513FNo, i, FetchElmFNo(RetNo, S9FNo, j));
    StoreElm(RetNo, S513FNo, i + 1, FetchElmFNo(RetNo, S9FNo, j + 1));
    Inc(i, 3);
    Inc(j, 9); // 20110514    Inc(j,6);
  until j > 175; // 119;
end;

procedure CopyS516FromS23(RetNo: integer);
var
  i, j, S23FNo, S516FNo: integer;
begin
  S23FNo := GetFormNo('S23');
  S516FNo := GetFormNo('S516');
  // For i:=4 to 125 do StoreElm(RetNo,S516FNo,i,'');
  i := 4; // ndx to s516
  j := 5; // ndx to s23
  repeat
    StoreElm(RetNo, S516FNo, i, FetchElmFNo(RetNo, S23FNo, j));
    StoreElm(RetNo, S516FNo, i + 1, FetchElmFNo(RetNo, S23FNo, j + 1));
    Inc(i, 6);
    Inc(j, 6);
  until j > 119;
end;

procedure CopyS517FromS23(RetNo: integer);
var
  i, j, S23FNo, S517FNo: integer;
begin
  S23FNo := GetFormNo('S23');
  S517FNo := GetFormNo('S517');
  for i := 4 to 103 do
    StoreElm(RetNo, S517FNo, i, '');
  i := 4; // ndx to s517
  j := 5; // ndx to s23
  repeat
    StoreElm(RetNo, S517FNo, i, FetchElmFNo(RetNo, S23FNo, j));
    Inc(i, 5);
    Inc(j, 6);
  until j > 119;
end;

function IsAmalgamatedOntario(RetNo: integer): Boolean;
begin
  Result := False;
  if (Ret[RetNo].Province = 'ON') or
    ((Ret[RetNo].Province = 'MJ') and (GetTxblIncomeFromS5(RetNo, 'ON') > 0))
  // 20100531
    or (IsMJWithOntario(RetNo) = True) { //20100830 } then
    Result := True;
end;

function GetTotBegBalS8(RetNo: integer): Real;
var
  i, j: integer;
  Tot: Real;
begin
  Tot := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'S8' then
    begin
      if Ret[RetNo].FrmHasData[FRec.FormNo] then
      begin
        j := 7;
        repeat
          Tot := Tot + VL(FetchElmFNo(RetNo, FRec.FormNo, j));
          Inc(j, 16);
        until j > 199;
        Tot := Tot + VL(FetchElmFNo(RetNo, FRec.FormNo, 215)); // leasehold
      end;
    end; // s8
  end; // i
  Result := Tot;
end;

function UseGifi(RetNo: integer): Boolean;
begin
  Result := True;
  if UpperCase(FetchElm(RetNo, 'T2', 71)) = 'N' then
    Result := False;
end;

function GetT661NumProjects(RetNo: integer): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'S60' then
    begin
      if Ret[RetNo].FrmHasData[FRec.FormNo] then
        Result := Result + 1
    end;
  end;
end;

function GetS568NumProjects(RetNo: integer): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'S569' then
    begin
      if Ret[RetNo].FrmHasData[FRec.FormNo] then
        Result := Result + 1
    end;
  end;
end;

function AttachInstToFNameForRsi(FName: string; Inst: integer): string;
begin
  Result := FName;

  if LeftStr(FName, 3) = 'S60' then
  begin
    Result := FName + '#' + AllTrim(IntTostr(Inst));
    exit;
  end;
  if FName = 'S48' then
  begin
    Result := FName + '#' + AllTrim(IntTostr(Inst));
    exit;
  end;

  if LeftStr(FName, 6) = 'T661SB' then
  begin
    Result := FName + '#' + AllTrim(IntTostr(Inst));
    exit;
  end;
  if LeftStr(FName, 5) = 'T1131' then
  begin
    Result := FName + '#' + AllTrim(IntTostr(Inst));
    exit;
  end;

  if LeftStr(FName, 4) = 'S422' then
  begin
    Result := FName + '#' + AllTrim(IntTostr(Inst));
    exit;
  end;
  if LeftStr(FName, 4) = 'S428' then
  begin
    Result := FName + '#' + AllTrim(IntTostr(Inst));
    exit;
  end;
  { //20170525
    if LeftStr(FName, 5) = 'S490' then
    begin Result := FName + '#' + AllTrim(IntToStr(Inst));
    Exit;
    end;
  }
  if LeftStr(FName, 4) = 'S423' then
  begin
    Result := FName + '#' + AllTrim(IntTostr(Inst));
    exit;
  end;
  if LeftStr(FName, 4) = 'S384' then
  begin
    Result := FName + '#' + AllTrim(IntTostr(Inst));
    exit;
  end;
  if LeftStr(FName, 4) = 'S388' then
  begin
    Result := FName + '#' + AllTrim(IntTostr(Inst));
    exit;
  end;

  (*
    if LeftStr(FName, 4) = 'S547' then
    begin
    Result := FName + '#' + AllTrim(IntToStr(Inst));
    Exit;
    end;
  *)

  if LeftStr(FName, 4) = 'S550' then
  begin
    Result := FName + '#' + AllTrim(IntTostr(Inst));
    exit;
  end;
  if LeftStr(FName, 4) = 'S552' then
  begin
    Result := FName + '#' + AllTrim(IntTostr(Inst));
    exit;
  end;
  if LeftStr(FName, 4) = 'S554' then
  begin
    Result := FName + '#' + AllTrim(IntTostr(Inst));
    exit;
  end;
  if LeftStr(FName, 4) = 'S556' then
  begin
    Result := FName + '#' + AllTrim(IntTostr(Inst));
    exit;
  end;
  if LeftStr(FName, 4) = 'S558' then
  begin
    Result := FName + '#' + AllTrim(IntTostr(Inst));
    exit;
  end;
  if LeftStr(FName, 4) = 'S560' then
  begin
    Result := FName + '#' + AllTrim(IntTostr(Inst));
    exit;
  end;
  if LeftStr(FName, 4) = 'S562' then
  begin
    Result := FName + '#' + AllTrim(IntTostr(Inst));
    exit;
  end;
  if LeftStr(FName, 4) = 'S564' then
  begin
    Result := FName + '#' + AllTrim(IntTostr(Inst));
    exit;
  end;
  if LeftStr(FName, 4) = 'S569' then
  begin
    Result := FName + '#' + AllTrim(IntTostr(Inst));
    exit;
  end;

  if FName = 'S30' then
  begin
    Result := FName + '#' + AllTrim(IntTostr(Inst));
    exit;
  end;

  {
    //relocated from before  S423   //20170601
    if ((LeftStr(FName, 3) = 'S30')      //anything starting with S30
    and (Fname <> 'S301')
    and (Fname <> 'S302')
    and (Fname <> 'S304')
    and (Fname <> 'S309')   //20160426
    and (Fname <> 'S305')   //20170601
    and (LeftStr(Fname, 5) <> 'S303_')) then
    begin Result := FName + '#' + AllTrim(IntToStr(Inst));
    ;
    Exit;
    end;
  }
end;

function GetMultipleRSIcount(RetNo: integer; RsiForm: string): integer;
begin
  Result := 1;

  if UpperCase(RsiForm) = 'SCHEDULE 125' then
    Result := CountMultipleInstances(RetNo, 'S125'); // 20160503

  if UpperCase(RsiForm) = 'SCHEDULE 047' then
    Result := CountMultipleInstances(RetNo, 'T1131');
  if UpperCase(RsiForm) = 'SCHEDULE 030' then
    Result := CountMultipleInstances(RetNo, 'S30');
  if UpperCase(RsiForm) = 'SCHEDULE 060' then
    Result := CountMultipleInstances(RetNo, 'S60');
  if UpperCase(RsiForm) = 'SCHEDULE 048' then
    Result := CountMultipleInstances(RetNo, 'S48');
  if UpperCase(RsiForm) = 'SCHEDULE 384' then
    Result := CountMultipleInstances(RetNo, 'S384');
  if UpperCase(RsiForm) = 'SCHEDULE 388' then
    Result := CountMultipleInstances(RetNo, 'S388');
  // 20170601
  if UpperCase(RsiForm) = 'SCHEDULE 422' then
    Result := CountMultipleInstances(RetNo, 'S422');
  if UpperCase(RsiForm) = 'SCHEDULE 423' then
    Result := CountMultipleInstances(RetNo, 'S423');

  // if UpperCase(RsiForm) = 'SCHEDULE 547' then Result := CountMultipleInstances(RetNo, 'S547');

  if UpperCase(RsiForm) = 'SCHEDULE 550' then
    Result := CountMultipleInstances(RetNo, 'S550');
  if UpperCase(RsiForm) = 'SCHEDULE 552' then
    Result := CountMultipleInstances(RetNo, 'S552');
  if UpperCase(RsiForm) = 'SCHEDULE 554' then
    Result := CountMultipleInstances(RetNo, 'S554');
  if UpperCase(RsiForm) = 'SCHEDULE 556' then
    Result := CountMultipleInstances(RetNo, 'S556');
  if UpperCase(RsiForm) = 'SCHEDULE 558' then
    Result := CountMultipleInstances(RetNo, 'S558');
  if UpperCase(RsiForm) = 'SCHEDULE 560' then
    Result := CountMultipleInstances(RetNo, 'S560');
  if UpperCase(RsiForm) = 'SCHEDULE 562' then
    Result := CountMultipleInstances(RetNo, 'S562');
  if UpperCase(RsiForm) = 'SCHEDULE 564' then
    Result := CountMultipleInstances(RetNo, 'S564');
  if UpperCase(RsiForm) = 'SCHEDULE 569' then
    Result := CountMultipleInstances(RetNo, 'S569');
end;

function ReformatPostal(s: string): string;
begin
  Result := ReplaceChar(s, ' ', '');
  Result := LeftStr(Result, 3) + ' ' + MidStr(Result, 4, 5);
end;

function ReformatPostalForBarCode(s: string): string;
begin
  Result := ReplaceChar(s, ' ', '');
  Result := LeftStr(Result, 3) + MidStr(Result, 4, 5);
end;

function InFormswithSpecialAddress(FName: string): Boolean;
begin
  Result := False;
  if ExtractNonInstFormName(FName) = 'S6RE' then
  begin
    Result := True;
    exit;
  end;
  if ExtractNonInstFormName(FName) = 'S14' then
  begin
    Result := True;
    exit;
  end;
  if ExtractNonInstFormName(FName) = 'S15' then
  begin
    Result := True;
    exit;
  end;
  if ExtractNonInstFormName(FName) = 'S22' then
  begin
    Result := True;
    exit;
  end;
  if ExtractNonInstFormName(FName) = 'S29' then
  begin
    Result := True;
    exit;
  end;
  if ExtractNonInstFormName(FName) = 'S30' then
  begin
    Result := True;
    exit;
  end;
  if ExtractNonInstFormName(FName) = 'S566' then
  begin
    Result := True;
    exit;
  end;
end;

function GetSpecialAddressValu(RetNo: integer; FName: string; ElmNo: integer;
  Valu: string): string;
var
  k: integer;
begin
  Result := Valu;

  if ExtractNonInstFormName(FName) = 'S6RE' then
  begin
    case ElmNo of
      1, 12, 23, 34, 45, 56, 67, 78, 89, 100, 111, 122, 133, 144, 155, 166, 177,
        188, 199, 210, 221, 232, 243, 254, 265, 276, 287, 298:
        begin
          Result := PaddR(Valu, 30); // initial address
          Result := Result + PaddR(Space(30), 30) // second address
            + PaddR(FetchElm(RetNo, FName, ElmNo + 1), 30) // City
            + PaddR(FetchElm(RetNo, FName, ElmNo + 2), 2) // Province
            + PaddR(FetchElm(RetNo, FName, ElmNo + 3), 2)
          // Country    //20130919 //instead of 4
            + ReformatPostalForBarCode(PaddR(FetchElm(RetNo, FName, ElmNo + 4),
            10)); // Postal

          Result := PaddR(Result, 104);
          if Result = Space(104) then
            Result := ''; // 20090513
          exit;
        end;
    end; // case
  end;

  if ExtractNonInstFormName(FName) = 'S14' then
  begin
    k := 5;
    repeat
      if ElmNo = k then
      begin
        Result := PaddR(Valu, 30); // initial address
        Result := Result + PaddR(FetchElm(RetNo, FName, k + 1), 30)
        // second adr
          + PaddR(FetchElm(RetNo, FName, k + 2), 30) // City
          + PaddR(FetchElm(RetNo, FName, k + 3), 2) // Province
          + PaddR(FetchElm(RetNo, FName, k + 4), 2) // Country
          + ReformatPostalForBarCode(PaddR(FetchElm(RetNo, FName, k + 5), 10));
        // Postal

        Result := PaddR(Result, 104);
        if Result = Space(104) then
          Result := ''; // 20090513
        exit;
      end;
      Inc(k, 12);
    until k > 113;
  end; // form

  if ExtractNonInstFormName(FName) = 'S15' then
  begin
    k := 8;
    repeat
      if ElmNo = k then
      begin
        Result := PaddR(Valu, 30); // initial address
        Result := Result + PaddR(Space(30), 30) // second address
          + PaddR(FetchElm(RetNo, FName, k + 1), 30) // City
          + PaddR(FetchElm(RetNo, FName, k + 2), 2) // Province
          + PaddR(FetchElm(RetNo, FName, k + 3), 2) // Country
          + ReformatPostalForBarCode(PaddR(FetchElm(RetNo, FName, k + 4), 10));
        // Postal

        Result := PaddR(Result, 104);
        if Result = Space(104) then
          Result := ''; // 20090513
        exit;
      end;
      Inc(k, 10);
    until k > 148; // 20140608
  end; // form

  if ExtractNonInstFormName(FName) = 'S22' then
  begin
    k := 5;
    repeat
      if ElmNo = k then
      begin
        Result := PaddR(Valu, 30); // initial address
        Result := Result + PaddR(Space(30), 30) // second address
          + PaddR(FetchElm(RetNo, FName, k + 1), 30) // City
          + PaddR(FetchElm(RetNo, FName, k + 2), 2) // Province
          + PaddR(FetchElm(RetNo, FName, k + 3), 2) // Country
          + ReformatPostalForBarCode(PaddR(FetchElm(RetNo, FName, k + 4), 10));
        // Postal

        Result := PaddR(Result, 104);
        if Result = Space(104) then
          Result := ''; // 20090513
        exit;
      end;
      Inc(k, 7);
    until k > 54;
  end; // form

  if ExtractNonInstFormName(FName) = 'S29' then
  begin
    k := 5;
    repeat
      if ElmNo = k then
      begin
        Result := PaddR(Valu, 30); // initial address
        Result := Result + PaddR(FetchElm(RetNo, FName, k + 80), 30) // addr2
          + PaddR(FetchElm(RetNo, FName, k + 1), 30) // City
          + PaddR(FetchElm(RetNo, FName, k + 2), 2) // Province
          + PaddR(FetchElm(RetNo, FName, k + 3), 2) // Country
          + ReformatPostalForBarCode(PaddR(FetchElm(RetNo, FName, k + 4), 10));
        // Postal

        Result := PaddR(Result, 104);
        if Result = Space(104) then
          Result := ''; // 20090513
        exit;
      end;
      Inc(k, 8);
    until k > 77;
  end; // form

  if ExtractNonInstFormName(FName) = 'S30' then
  begin
    if ElmNo = 2 then
    begin
      Result := PaddR(Valu, 30); // initial address
      Result := Result + PaddR(FetchElm(RetNo, FName, 32), 30) // second address
        + PaddR(FetchElm(RetNo, FName, 33), 30) // City
        + PaddR(FetchElm(RetNo, FName, 34), 2) // Province
        + PaddR(FetchElm(RetNo, FName, 18), 2) // Country
        + ReformatPostalForBarCode(PaddR(FetchElm(RetNo, FName, 35), 10));
      // Postal

      Result := PaddR(Result, 104);
      if Result = Space(104) then
        Result := ''; // 20090513
      exit;
    end;
  end; // form

  if ExtractNonInstFormName(FName) = 'S566' then
  begin
    case ElmNo of
      181, 187, 193, 199, 205, 211, 217, 223, 229, 235:
        begin
          Result := PaddR(Valu, 30); // initial address
          Result := Result + PaddR(Space(30), 30) // second address
            + PaddR(FetchElm(RetNo, FName, ElmNo + 1), 30) // City
            + PaddR(FetchElm(RetNo, FName, ElmNo + 2), 2) // Province
            + PaddR(FetchElm(RetNo, FName, ElmNo + 3), 2) // Country
            + ReformatPostalForBarCode
            (ReformatPostal(PaddR(FetchElm(RetNo, FName, ElmNo + 4), 10)));
          // Postal

          Result := PaddR(Result, 104);
          if Result = Space(104) then
            Result := ''; // 20090513
          exit;
        end;
    end; // case
  end;

end;

function IncDayMine(Dt: TDateTime; NumDays: integer): TDateTime;
var
  Year, Month, Day: integer;
begin
  Result := Dt + NumDays;
end;

function IncludeGifiSchedules(RetNo: integer; RsiForm: string): Boolean;
begin
  Result := True;
  if (RsiForm = 'Schedule 100') or (RsiForm = 'Schedule 101') or
    (RsiForm = 'Schedule 125') or (RsiForm = 'Schedule 140') or
    (RsiForm = 'Schedule 141') then
  begin
    if UseGifi(RetNo) = False then
      Result := False;
  end;
end;

function IsMJWithOntario(RetNo: integer): Boolean;
var
  S5FNo: integer;
begin
  S5FNo := GetFormNo('S5');
  Result := False;
  if Ret[RetNo].Province = 'MJ' then
  begin
    if VL(FetchElmFNo(RetNo, S5FNo, 164)) > 0 then
      Result := True;
    if VL(FetchElmFNo(RetNo, S5FNo, 160)) > 0 then
      Result := True;
    if VL(FetchElmFNo(RetNo, S5FNo, 162)) > 0 then
      Result := True;
  end;
end;

function GetMaxSKItc(RetNo: integer): Real;
var
  i, S5FNo: integer;
begin
  S5FNo := GetFormNo('S5'); // pg6
  Result := MaxR(0, VL(FetchElmFNo(RetNo, S5FNo, 724)) -
    VL(FetchElmFNo(RetNo, S5FNo, 740)) - VL(FetchElmFNo(RetNo, S5FNo, 725)) -
    VL(FetchElmFNo(RetNo, S5FNo, 739)) - VL(FetchElmFNo(RetNo, S5FNo, 738)) -
    VL(FetchElmFNo(RetNo, S5FNo, 728)));
end;

function IncDay(const AValue: TDateTime; const ANumberOfDays: integer)
  : TDateTime;
begin
  Result := AValue + 1;
end;

procedure PasteFromClipBoard(RetNo, FNo, Elm, MaxLines, MaxLineLength: integer);
var
  i, j, NextPos, k, Mx: integer;
  flName: string;
  AMemo: TMemo;
  TempList: TStringList;
  ALength: integer;
  s: string; // 20150702
  h: THandle;
begin
  if CheckIsCloud then
    exit; // 20180503 Igor
  if MessageDlg('This will replace ALL existing data on this form. Proceed??',
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;

  with MainFormT2 do
  begin
    OpenDialog.Filter := 'TXT files(*.TXT)|*.TXT';
    // OpenDialog.Filter:='All files (*.*)|*.*';

    if OpenDialog.Execute then
    begin
      flName := OpenDialog.FileName;
    end;
  end;
  if flName = '' then
    exit;

  ShowMessage
    ('Once the file is shown, highlight text and Press Ctrl C or click Edit -> Copy');

  h := ShellExecute(MainForm.Handle, 'open', PChar('' + flName), nil,
    nil, Sw_Show);
  if h <= 32 then
  begin
    ShowMessage('Open failed');
    exit;
  end;

  ShowMessage('Press any key once you highlighted and copied text');
  AMemo := TMemo.Create(Application);
  AMemo.Parent := MainFormT2;
  AMemo.Visible := False;
  AMemo.PasteFromClipBoard;

  TempList := TStringList.Create;
  ALength := Length(AMemo.Text);
  NextPos := 1;
  repeat
    s := MidStr(AMemo.Text, NextPos, MaxLineLength);
    for j := 1 to Length(s) do
    begin
      if ((s = #10) or (s = #13) or (s = #10#13)) then
        s := Space(78) // does not work
      else if s[j] <= #32 then
        s[j] := #32 // get rid of control characters
      else if s[j] > #126 then
        s[j] := #32; // get rid of control characters
    end;
    TempList.Add(s);
    Inc(NextPos, MaxLineLength);
  until (NextPos > ALength) or (TempList.Count > MaxLines);

  i := 0;
  // Elm:=LineNo;
  Mx := TempList.Count - 1;
  if Mx > Elm + MaxLines then
    Mx := Elm + MaxLines - 1;
  repeat
    StoreElm(RetNo, FNo, Elm, LeftStr(TempList[i], MaxLineLength));
    Inc(i, 1);
    Inc(Elm, 1);
  until i > Mx;
  Ret[RetNo].FrmHasData[FNo] := True;
  OpenForm(RetNo, FNo, Elm - 1);
  AMemo.Free;
end;

function IncludesFeb29(RetNo: integer): Boolean;
begin
  Result := False;
  if (RightStr(GetTaxationYearEnd(RetNo), 5) > '0228') and
    (IsLeapYear(MyStrToInt(LeftStr(GetTaxationYearEnd(RetNo), 4)))) then
    Result := True;
end;

procedure ClearTheClipBoard;
begin
  Clipboard.clear;
end;

function GifiNotesEntered(RetNo: integer): Boolean;
var
  i: integer;
begin
  Result := False; // EXIT;   //20151004 //20160405 Igor
  for i := 0 to Length(RetList[RetNo].Form[GifiFormName].Memos) - 1 do
  Begin
    Result := RetList[RetNo].Form[GifiFormName].Memos[i] <> '';
    if Result then
      exit;
  End;
end;

(*
  function FileS546(RetNo: Integer): Boolean;
  var
  i: Integer;
  begin
  Result := False;
  if UpperCase(FetchElm(RetNo, 'S546', 68)) > '' then
  Result := True;
  end;
*)

function ShouldFileS510(RetNo: integer): Boolean;
var
  i: integer;
  FNo: integer;
begin
  Result := False;
  FNo := GetFormNo('S100'); // 20150826
  // 20100405
  if (IsAmalgamatedOntario(RetNo)) then
  begin
    if GetTaxationYearEnd(RetNo) < '2010/06/01' then
    begin
      // assets
      if VL(FetchElm(RetNo, 'S510', 8)) > 5000000 then
        Result := True;
      // revenue
      if VL(FetchElm(RetNo, 'S125#1', 14)) > 10000000 then
        // if Vl(FetchGifiElmFNo(RetNo, FNo, '8299')) > 10000000 then
        Result := True;
    end
    else
    begin
      // assets
      if VL(FetchElm(RetNo, 'S510', 8)) > 50000000 then
        Result := True;
      // revenue
      if VL(FetchElm(RetNo, 'S510', 13)) > 50000000 then
        Result := True; // 20131016
    end;
  end; // amalgamated
  // 20100907
  if (VL(FetchElm(RetNo, 'S510', 68)) > 0) // cmt payable
  // cmt credit
    or (VL(FetchElm(RetNo, 'S510', 73)) > 0) or
    (VL(FetchElm(RetNo, 'S510', 79)) > 0) or
    (VL(FetchElm(RetNo, 'S510', 85)) > 0) or
    (VL(FetchElm(RetNo, 'S510', 97)) > 0)
  // cmt loss
    or (VL(FetchElm(RetNo, 'S510', 111)) > 0) or
    (VL(FetchElm(RetNo, 'S510', 117)) > 0) or
    (VL(FetchElm(RetNo, 'S510', 120)) > 0) then
    Result := True;
end;

procedure OpenAnyFile(PgmPath, PgmFile: string);
var
  h: THandle;
  PgmPathS, PgmS, PgmParmsS: string;
  PgmPathZ: array [0 .. 254] of Char;
  PgmParmsZ: array [0 .. 254] of Char;
  PgmZ: array [0 .. 254] of Char;
begin
  StrPCopy(PgmPathZ, PgmPath);
  PgmS := PgmFile;
  StrPCopy(PgmZ, PgmS);
  PgmParmsS := '';
  StrPCopy(PgmParmsZ, PgmParmsS);
  h := ShellExecute(MainForm.Handle, nil, PgmZ, PgmParmsZ, PgmPathZ,
    SW_RESTORE);
  if h = 31 then
    ShowMessage
      ('There is no file association, or file extension is not visible (Explorer Option)')
  else if h < 31 then
    ShowMessage('File not found ');
end;
// 20160905 Igor Move to vtTrimStr
// procedure AdjustFinePrintRegistrySettings(PDFFullfileName: string; ShowDlgValue: Integer; PdfActionValue: Integer; CollectJobsValue: Integer);
// var
// i, j: Integer;
// Reg: TRegistry;
// PDFfilePath, PDFfileName: string;
// keyName, keyName2, keyNameTemp, PDFFactoryVersion, PDFFactoryVersion2: string;
// Val, Val2: TStringList;
//
// procedure AdjustForPDFstd(PDFFullfileName: string; ShowDlgValue: Integer; PdfActionValue: Integer; CollectJobsValue: Integer);
// begin
// keyNameTemp := keyName + '\' + PDFFactoryVersion;
// if Reg.OpenKey(keyNameTemp, False) = True then //False because we do not want to create it if it doesn’t exist
// begin
// if PDFFullfileName = '' then
// begin
// reg.DeleteKey('OutputFilePerm');
// reg.DeleteKey('OutputFile');
// reg.WriteString('CurDir', PDFfilePath);
// reg.WriteString('AutoSaveDir', PDFfilePath);
// end
// else
// begin
// reg.WriteString('OutputFilePerm', PDFFullfileName);
// reg.WriteString('OutputFile', PDFFullfileName);
// reg.WriteString('CurDir', PDFfilePath);
// reg.WriteString('AutoSaveDir', PDFfilePath);
// end;
// end
// else
// ShowMessage('Cannot find ' + keyNameTemp);
//
// keyNameTemp := keyName + '\' + PDFFactoryVersion + '\FinePrinters\' + PDFFactoryVersion2;
// if Reg.OpenKey(keyNameTemp, False) = True then //False because we do not want to create it if it doesn’t exist
// begin
// reg.WriteInteger('ShowDlg', ShowDlgValue);
// reg.WriteInteger('PdfAction', PdfActionValue);
// reg.WriteInteger('CollectJobs', CollectJobsValue);
// end
// else
// ShowMessage('Cannot find ' + keyNameTemp);
// end;
//
// procedure AdjustForPDfpro(PDFFullfileName: string; ShowDlgValue, PdfActionValue, CollectJobsValue: Integer);
// begin
// keyNameTemp := keyName + '\' + PDFFactoryVersion + '\FinePrinters\' + PDFFactoryVersion2 + '\PrinterDriverData';
// if Reg.OpenKey(keyNameTemp, False) = True then //False because we do not want to create it if it doesn’t exist
// begin
// reg.WriteInteger('ShowDlg', ShowDlgValue);
// reg.WriteInteger('PdfAction', PdfActionValue);
// reg.WriteString('CurDir', PDFfilePath);
// end
// else
// begin
// ShowMessage('Cannot find ' + keyNameTemp);
// end;
//
// keyNameTemp := keyName + '\' + PDFFactoryVersion;
// if Reg.OpenKey(keyNameTemp, False) = True then //False because we do not want to create it if it doesn’t exist
// begin
// reg.WriteString('OutputFilePerm', PDFFullfileName);
// reg.WriteString('OutputFile', PDFFullfileName);
// reg.WriteString('CurDir', PDFfilePath);
// reg.WriteString('AutoSaveDir', PDFfilePath);
// end
// else
// begin
// ShowMessage('Cannot find ' + keyNameTemp);
// end;
//
// keyNameTemp := keyName + '\' + PDFFactoryVersion + '\FinePrinters\' + PDFFactoryVersion2;
// if Reg.OpenKey(keyNameTemp, False) = True then //False because we do not want to create it if it doesn’t exist
// begin
// reg.WriteInteger('ShowDlg', ShowDlgValue);
// reg.WriteInteger('PdfAction', PdfActionValue);
// reg.WriteInteger('CollectJobs', CollectJobsValue);
// end
// else
// begin
// ShowMessage('Cannot find ' + keyNameTemp);
// end;
// end;
//
// begin
// PDFfilePath := ExtractFilePath(PDFFullfileName);
// PDFfileName := ExtractFileName(PDFFullfileName);
//
// Reg := TRegistry.Create;
//
// try
// Val := TStringList.Create;
// Val2 := TStringList.Create;
// try
// Reg.RootKey := HKEY_CURRENT_USER; // Section to look for within the registry
// keyName := '\Software\FinePrint Software';
// if not Reg.OpenKey(keyName, False) then
// ShowMessage('Error opening key')
// else
// begin
// Reg.GetKeyNames(Val);
// for i := 0 to Val.Count - 1 do
// begin
// PDFFactoryVersion := Val.Strings[i];
// keyName2 := keyName + '\' + PDFFactoryVersion + '\FinePrinters';
// if not Reg.OpenKey(keyName2, False) then
// ShowMessage('Error opening key')
// else
// begin
// Reg.GetKeyNames(Val2);
// for j := 0 to Val2.Count - 1 do
// begin
// if Pos('PDFFACTORY', uppercase(Val2.Strings[j])) > 0 then
// begin
// PDFFactoryVersion2 := Val2.Strings[j];
// end;
// end;
// end;
//
// //showmessage(PDFFactoryVersion+' '+PDFFactoryVersion2);
//
// // if pos('Pro',PDFFactoryVersion2) > 0 then
// //   AdjustForPDfpro(PDFFullfileName,ShowDlgValue,PdfActionValue,CollectJobsValue)
// // else
// AdjustForPDFstd(PDFFullfileName, ShowDlgValue, PdfActionValue, CollectJobsValue);
//
// end;
// end;
// finally
// Val.Free;
// end;
// finally
// Reg.Free;
// end;
//
// end;

function MkDirforClientDocs(RetNo: integer): string;
Var
  CorpNm: String;
begin
  CorpNm := GetCorpName(RetNo);
  CorpNm := ReplaceChar(CorpNm, '"', '');
  CorpNm := ReplaceChar(CorpNm, '.', '');
  Result := GetCorpName(RetNo) + '-YE-' + LeftStr(GetTaxationYearEnd(RetNo), 4);
end;

function GetOntBasicTaxRate(RetNo: integer): string;
begin
  Result := FetchElm(RetNo, 'S500', 95);
end;

function IncludeS510InFiling(RetNo: integer): Boolean;
var
  FNo: integer;
begin
  Result := False;
  FNo := GetFormNo('S510');
  // 20130602
  if (SubjectToCMT(RetNo)) // Assets>=50,000,000 and rev>=100,000,000
    or (VL(FetchElmFNo(RetNo, FNo, 79)) > 0) // cmt credit
    or (VL(FetchElmFNo(RetNo, FNo, 85)) > 0) // cmt credit c/f
    or (VL(FetchElmFNo(RetNo, FNo, 116)) > 0) // cmt loss
    or (VL(FetchElmFNo(RetNo, FNo, 82)) > 0) // SAT payable
    or (VL(FetchElmFNo(RetNo, FNo, 120)) > 0) { //loss c/f } then
    Result := True;
end;

function SubjectToCMT(RetNo: integer): Boolean;
var
  FNo: integer;
begin
  Result := False;
  FNo := GetFormNo('S510');
  // 20130602
  if ((VL(FetchElmFNo(RetNo, FNo, 8)) >= 50000000) // assets
    and (VL(FetchElmFNo(RetNo, FNo, 13)) >= 100000000))
  { //revenue  //and 20130602 } then
    Result := True;
end;

function GetFormAbbrevDescr(FName: string): string;
var
  i: integer;
begin
  Result := '';
  FName := RTrim(FName);
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FName = FRec.FormName then
    begin
      Result := FRec.FormAbrev;
      exit;
    end;
  end;

end;

procedure GetFormsToPrint(RetNo: integer; Template: string;
  var FormsToPrint: TStringList; Prov: string);
var
  i, j, FNo: integer;
  Copies: string; // [1];
  TemplCopies: TTemplCopies;
begin
  if not FileExists(AppDir + '\' + Template) then
  begin
    ShowMessage('Print Template: ' + AppDir + '\' + Template + Chr(13) +
      'does not exist');
    exit;
  end;
  TemplCopies := TTemplCopies.Create(RetNo, AppDir, Template);

  for i := 0 to FList.Count - 1 do { run thru all forms available }
  begin
    FRec := FList.Items[i];
    FNo := FRec.FormNo;
    if FNo = 0 then
      continue; // dummy entry

    // if TemplCopies.IndexOfName(FRec.FormName) >= 0 then   //equivalent
    if TemplCopies.IsExactlyInList(FRec.FormName) >= 0 then
    begin
      if (Ret[RetNo].FrmHasData[FNo]) { has data and it is in template }
        and (IncludeFormInPrint(RetNo, FRec.FormInstName) = True) and
        (FRec.FormName <> 'ALETTER') then
      begin
        { check for province }
        if ((Prov = 'FED') and (FRec.FormType <> 'OO') and
          (FRec.FormType <> 'AL')) or ((Prov = 'ONT') and (FRec.FormType = 'OO')
          ) or ((Prov = 'ALB') and (FRec.FormType = 'AL')) or
          ((Prov = 'FEDONT') and (FRec.FormType <> 'AL')) then
          FormsToPrint.Add(FRec.FormInstName);

        if Prov = 'ALL' then
        begin
          if (FRec.FormType <> 'OO') and (FRec.FormType <> 'AL') then
            FormsToPrint.Add(FRec.FormInstName);
          if (Ret[RetNo].OntAlloc > 0) and (FRec.FormType = 'OO') then
            FormsToPrint.Add(FRec.FormInstName);
          if (Ret[RetNo].AlbAlloc > 0) and (FRec.FormType = 'AL') then
            FormsToPrint.Add(FRec.FormInstName);
        end;
      end; // in template
    end;
  end; // i

  TemplCopies.FinishPrintList(FormsToPrint);
  TemplCopies.Free;
end;

function ValidProjectsInT661(RetNo: integer): Boolean;
var
  i, FNo: integer;
  x, Y, z: Real;
begin
  Result := True;
  FNo := GetFormNo('T661');
  i := 402;
  x := 0;
  Y := 0;
  z := 0;
  repeat
    x := x + VL(FetchElmFNo(RetNo, FNo, i));
    Y := Y + VL(FetchElmFNo(RetNo, FNo, i + 1));
    z := z + VL(FetchElmFNo(RetNo, FNo, i + 2));
    Inc(i, 4);
  until i > 590; // 454; //20181119

  // 20181119  totals at the end
  if (x <> VL(FetchElmFNo(RetNo, FNo, 595))) or
    (Y <> VL(FetchElmFNo(RetNo, FNo, 596))) or
    (z <> VL(FetchElmFNo(RetNo, FNo, 597))) then
    Result := False;

  { //20181119
    {
    //20161115  totals at the end
    if (x <> Vl(FetchElmFNo(RetNo, FNo, 485)))
    or (Y <> Vl(FetchElmFNo(RetNo, FNo, 486)))
    or (z <> Vl(FetchElmFno(RetNo, FNo, 487))) then
    result := False;
  }
end;

function IsAmortizationLine(LineNo: string): Boolean;
var
  i: integer;
  TempList: TStringList;
  S1: string;
begin
  Result := False;
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir + '\Amortization.d');
  for i := 0 to TempList.Count - 1 do
  begin
    S1 := MidStr(TempList[i], 6, 4);
    if LineNo = S1 then
    begin
      Result := True;
      TempList.Free;
      exit;
    end;
  end;
  TempList.Free;
end;

function IsInactive(RetNo: integer): Boolean;
begin
  Result := False;
  if FetchElm(RetNo, 'T2', 201) > '' then
  begin
    Result := True;
    exit;
  end;
end;

function GetMaxCharactersToFitBox(CharacterWidth: integer;
  BoxWidth: integer): integer;
begin
  Result := Trunc(BoxWidth / CharacterWidth);
end;

(*
  function IsOntarioIncorporated(RetNo: Integer): Boolean;
  begin
  if UpperCase(FetchElm(RetNo, 'S546', 100)) = 'X' then
  result := True
  else
  result := False;
  end;
*)
function DateToDDMMYYYY(Dt: string): string;
begin
  Result := RightStr(Dt, 2) + '-' + MidStr(Dt, 6, 2) + '-' + LeftStr(Dt, 4);
end;

function ConvertFNameToCombined(FName: string): string;
var
  FInst: string;
begin
  Result := FName;
  if IsFormMultiPage(FName) = False then
    exit; // only if multipage
  FInst := ExtractFormInst(FName);
  Result := ExtractFormRootName(FName) + FInst;
end;

function ConvertElmNoToCombined(OldFName: string; Elm: integer;
  IncrElmList: TStringList): integer;
var
  FInst: string;
  OldNonInstFName, NewNonInstFName, RootFormName: string;
var
  i: integer;
begin
  Result := Elm;
  if IsFormMultiPage(OldFName) = False then
    exit; // only if multipage
  OldFName := UpperCase(OldFName);
  FInst := ExtractFormInst(OldFName);
  OldNonInstFName := ExtractNonInstFormName(OldFName);
  NewNonInstFName := ExtractNonInstFormName
    (ConvertFNameToCombined(OldNonInstFName));
  for i := 0 to IncrElmList.Count - 1 do
  begin
    if OldNonInstFName = UpperCase
      (AllTrim(LeftStr(MidStr(IncrElmList[i], 2, 9), 9))) then
    begin
      if (OldFName = 'PAGE_1') and (Elm = 10) then
        ShowMessage('got it');
      Result := Elm + MyStrToInt(AllTrim(MidStr(IncrElmList[i], 11, 4)));
      exit;
    end;
  end;
end;

procedure createPasFromTXT(flName: string);
var
  i, StartPos: integer;
  PasList: TStringList;
  TempString: string;
  FileDir: string;
  PasUnit: string;
  s: string;
  FormNm: string;
  LabelsList: TStringList;
begin
  FileDir := ExtractFileDir(flName);
  FormNm := ChangeFileExt(ExtractFileName(flName), '');
  PasUnit := 'U' + FormNm;
  PasList := TStringList.Create;
  PasList.Add('unit ' + PasUnit + ';');
  PasList.Add('interface');
  PasList.Add('uses');
  PasList.Add
    ('  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,');
  PasList.Add
    ('  StdCtrls, ExtCtrls, GTSize32, DisplayChange, jpeg, ComCtrls, vtLabel;');
  PasList.Add(' Type');
  PasList.Add('  T' + FormNm + '= class(TForm)');

  LabelsList := TStringList.Create;
  LabelsList.LoadFromFile(flName);

  for i := 0 to 50 do // LabelsList.Count-1 do
  begin
    if Length(LabelsList[i]) > 250 then
      ShowMessage(LabelsList[i]);
    PasList.Add('  vtLabel' + IntTostr(i + 1) + ': TvtLabel;');
  end;

  PasList.Add('  private');
  PasList.Add('    { Private declarations }');
  PasList.Add('  public');
  PasList.Add('    { Public declarations }');
  PasList.Add('  end;');
  PasList.Add('var');
  PasList.Add(' ' + FormNm + ': T' + FormNm + ';');
  PasList.Add('implementation');
  PasList.Add('{$R *.DFM}');
  PasList.Add('end.');

  s := ExtractFileName(flName);
  s := ChangeFileExt(s, '.Pas');
  PasList.SaveToFile(FileDir + '\U' + s);
  PasList.Free;
  createDfmFromTxt(flName);
end; { Procedure }

procedure createDfmFromTxt(flName: string);
var
  i, StartPos, fontType, tempint: integer;
  DFMList: TStringList;
  quote1, temp, fontHeight, fontSize, fontStyle, TempString: string;
  LabelTop: integer;
  LabelsList: TStringList;
  FileDir, FormNm, DfmUnit: string;
begin
  FileDir := ExtractFileDir(flName);
  FormNm := ChangeFileExt(ExtractFileName(flName), '');
  DfmUnit := 'U' + FormNm;

  LabelsList := TStringList.Create;
  LabelsList.LoadFromFile(flName);

  quote1 := '''';
  DFMList := TStringList.Create;

  DFMList.Add('object ' + FormNm + ': T' + FormNm);
  DFMList.Add('  Left = 247');
  DFMList.Add('  Top = 247');
  DFMList.Add('  Width = 696');
  DFMList.Add('  Height = 3000');
  DFMList.Add('  Caption = ' + quote1 + FormNm + quote1);
  DFMList.Add('  Color = clBtnFace');
  DFMList.Add('  Font.Charset = DEFAULT_CHARSET');
  DFMList.Add('  Font.Color = clWindowText');
  DFMList.Add('  Font.Height = -11');
  DFMList.Add('  Font.Name = ' + quote1 + 'Arial' + quote1);
  DFMList.Add('  Font.Style = []');
  DFMList.Add('  OldCreateOrder = False');
  DFMList.Add('  PixelsPerInch = 96');
  DFMList.Add('  TextHeight = 13');

  LabelTop := 30;
  for i := 0 to 50 do // LabelsList.Count-1 do
  begin
    DFMList.Add('  object vtLabel' + IntTostr(i + 1) + ': TvtLabel');
    DFMList.Add('    Left = ' + '10');
    LabelTop := LabelTop + 16; // incr label top property
    DFMList.Add('    Top =  ' + IntTostr(LabelTop));
    DFMList.Add('    Width = 99');
    DFMList.Add('    Height = 14');
    DFMList.Add('    Transparent = True');
    DFMList.Add('    vtBorderType = vtlblNoBorder');
    ReplaceChar(DFMList[i], quote1, ' ');
    // replace any embedded quotation with space
    ReplaceChar(DFMList[i], '"', ' ');
    // replace any embedded quotation with space
    if Length(DFMList[i]) > 250 then
      ShowMessage(DFMList[i]);
    DFMList.Add('    Caption = ' + quote1 + LabelsList[i] + quote1);
    DFMList.Add('    Font.Charset = DEFAULT_CHARSET');
    DFMList.Add('    Font.Color = clWindowText');

    DFMList.Add('    Font.Size  = ' + '7');
    DFMList.Add('    Font.Name = ' + quote1 + 'Arial' + quote1);
    // fontArray[fontType,3]

    DFMList.Add('    Font.Style = [' + fontStyle + ']');
    DFMList.Add('    ParentFont = False');
    DFMList.Add('  end');
  end; // for

  DFMList.Add('end');

  DFMList.SaveToFile(FileDir + '\' + DfmUnit + '.DFM');
  DFMList.Free;
  LabelsList.Free;
end;

function IsAmendedReturn(RetNo: integer): Boolean;
begin
  Result := False;
  if UpperCase(FetchElm(RetNo, 'T2', 66)) = 'Y' then
    Result := True;
end;

function ShouldFileS5(RetNo: integer): Boolean;
var
  S5FNo: integer;
Begin
  If GetCorpBusNo(RetNo) = '984305995RC0001' then
  begin
    Result := True;
    exit;
  End; // 20180528
  if FetchElm(RetNo, 'T2', 2) = 'MULTIPLE' then
  begin
    Result := True;
    exit;
  end; // 20181104

  Ret[RetNo].FrmHasData[GetFormNo('S5')] := False; // 20180526
  // check if S5 applies
  if Ret[RetNo].Province = 'MJ' then
    Ret[RetNo].FrmHasData[GetFormNo('S5')] := True
  else
  begin
    // 20180526
    if (Ret[RetNo].Province = 'ON') then
    begin
      if (VL(FetchElm(RetNo, 'S5', 618)) <> 0) or
         (VL(FetchElm(RetNo, 'S5', 642)) <> 0) or

         (VL(FetchElm(RetNo, 'S5', 611)) <> 0) or     //20260806 - was missing amounts, not begin shown as used
         (VL(FetchElm(RetNo, 'S5', 643)) <> 0) then
                                                      Ret[RetNo].FrmHasData[GetFormNo('S5')] := True
    end
    // ---------------
    Else if (Ret[RetNo].Province = 'BC') then
    begin
      if ((VL(FetchElm(RetNo, 'S5', 801)) <> VL(FetchElm(RetNo, 'S5', 816))) or
         (VL(FetchElm(RetNo, 'S5', 822)) > 0)) then
                                                      Ret[RetNo].FrmHasData[GetFormNo('S5')] := True;
    end

    else if (Ret[RetNo].Province = 'NL') then
    begin
      if VL(FetchElm(RetNo, 'S5', 401)) <> VL(FetchElm(RetNo, 'S5', 413)) then
                                                      Ret[RetNo].FrmHasData[GetFormNo('S5')] := True;
    end
    else if (Ret[RetNo].Province = 'PE') then
    begin
      if VL(FetchElm(RetNo, 'S5', 414)) <> VL(FetchElm(RetNo, 'S5', 422)) then
        Ret[RetNo].FrmHasData[GetFormNo('S5')] := True;
    end
    else if (Ret[RetNo].Province = 'NS') then
    begin
      if VL(FetchElm(RetNo, 'S5', 523)) <> VL(FetchElm(RetNo, 'S5', 552)) then
        Ret[RetNo].FrmHasData[GetFormNo('S5')] := True;
    end
    else if (Ret[RetNo].Province = 'NB') then
    begin
      if VL(FetchElm(RetNo, 'S5', 516)) <> VL(FetchElm(RetNo, 'S5', 511)) then
        Ret[RetNo].FrmHasData[GetFormNo('S5')] := True;
    end
    else if (Ret[RetNo].Province = 'MB') then
    begin
      if VL(FetchElm(RetNo, 'S5', 712)) <> VL(FetchElm(RetNo, 'S5', 723)) then
        Ret[RetNo].FrmHasData[GetFormNo('S5')] := True;
    end
    else if (Ret[RetNo].Province = 'SK') then
    begin
      if VL(FetchElm(RetNo, 'S5', 724)) <> VL(FetchElm(RetNo, 'S5', 732)) then
        Ret[RetNo].FrmHasData[GetFormNo('S5')] := True;
    end
    else if (Ret[RetNo].Province = 'YT') then
    begin
      if VL(FetchElm(RetNo, 'S5', 831)) <> VL(FetchElm(RetNo, 'S5', 827)) then
      // 20180526
        // if Vl(FetchElm(RetNo, 'S5', 931)) <> Vl(FetchElm(RetNo, 'S5', 927)) then
        Ret[RetNo].FrmHasData[GetFormNo('S5')] := True;
    end
    else if (Ret[RetNo].Province = 'NT') then
    begin
      if VL(FetchElm(RetNo, 'S5', 928)) <> VL(FetchElm(RetNo, 'S5', 934)) then
        Ret[RetNo].FrmHasData[GetFormNo('S5')] := True;
    end
    else if (Ret[RetNo].Province = 'NU') then
    begin
      if VL(FetchElm(RetNo, 'S5', 905)) <> VL(FetchElm(RetNo, 'S5', 911)) then
        Ret[RetNo].FrmHasData[GetFormNo('S5')] := True;
    end;
  End; //

  if Ret[RetNo].FrmHasData[GetFormNo('S5')] = True then
    Result := True;

  {
    else if Vl(FetchElm(RetNo, 'S5', 935)) > 0 then
    begin
    Ret[RetNo].FrmHasData[GetFormNo('S5')] := True;
    end;
  }
end;

(*
  function ShouldFileS5(RetNo: Integer): Boolean;
  var
  s5FNo: Integer;
  begin
  result := False;
  if Ret[Retno].Province = 'MJ' then
  begin
  result := True;
  Exit;
  end;
  S5FNo := GetFormNo('S5');
  if Vl(FetchElmFNo(RetNo, S5FNo, 935)) <> 0 then Result := True; //20180510

  if Vl(FetchElmFNo(RetNo, S5FNo, 404)) <> Vl(FetchElmFNo(RetNo, S5FNo, 413)) then
  Result := True; //nl
  if Vl(FetchElmFNo(RetNo, S5FNo, 414)) <> Vl(FetchElmFNo(RetNo, S5FNo, 422)) then
  Result := True; //pe
  if Vl(FetchElmFNo(RetNo, S5FNo, 526)) <> Vl(FetchElmFNo(RetNo, S5FNo, 552)) then
  Result := True; //ns
  if Vl(FetchElmFNo(RetNo, S5FNo, 504)) <> Vl(FetchElmFNo(RetNo, S5FNo, 511)) then
  Result := True; //nb
  if Vl(FetchElmFNo(RetNo, S5FNo, 604)) <> Vl(FetchElmFNo(RetNo, S5FNo, 643)) then
  Result := True; //on
  if Vl(FetchElmFNo(RetNo, S5FNo, 712)) <> Vl(FetchElmFNo(RetNo, S5FNo, 723)) then
  Result := True; //mb
  if Vl(FetchElmFNo(RetNo, S5FNo, 724)) <> Vl(FetchElmFNo(RetNo, S5FNo, 732)) then
  Result := True; //sk
  if Vl(FetchElmFNo(RetNo, S5FNo, 801)) <> Vl(FetchElmFNo(RetNo, S5FNo, 818)) then
  Result := True; //bc
  if Vl(FetchElmFNo(RetNo, S5FNo, 831)) <> Vl(FetchElmFNo(RetNo, S5FNo, 827)) then
  Result := True; //yt
  if Vl(FetchElmFNo(RetNo, S5FNo, 928)) <> Vl(FetchElmFNo(RetNo, S5FNo, 934)) then
  Result := True; //nt
  if Vl(FetchElmFNo(RetNo, S5FNo, 905)) <> Vl(FetchElmFNo(RetNo, S5FNo, 911)) then
  Result := True; //nu
  end;
*)

function Daysafter2012(RetNo: integer): integer;
begin
  Result := GetNumDays(RetNo, DateToDDMMYYYY('2012/12/31'), 'A');
end;

function StillOldPrintSets: Boolean;
var
  flName: string;
begin
  Result := False;
  flName := AppDir + '\' + 'RvCanSet.d';
  if OldPrintSet(flName) then
  begin
    Result := True;
    exit;
  end;
  flName := AppDir + '\' + 'ClintSet.d';
  if OldPrintSet(flName) then
  begin
    Result := True;
    exit;
  end;
  flName := AppDir + '\' + 'PrepSet.d';
  if OldPrintSet(flName) then
  begin
    Result := True;
    exit;
  end;
end;

procedure RevisePrintSets;
var
  flName: string;
begin
  flName := AppDir + '\' + 'RvCanSet.d';
  ReviseAPrintSet(flName);
  flName := AppDir + '\' + 'ClintSet.d';
  ReviseAPrintSet(flName);
  flName := AppDir + '\' + 'PrepSet.d';
  ReviseAPrintSet(flName);
  flName := AppDir + '\' + 'Oth1Set.d';
  ReviseAPrintSet(flName);
  flName := AppDir + '\' + 'Oth2Set.d';
  ReviseAPrintSet(flName);
  flName := AppDir + '\' + 'Oth3Set.d';
  ReviseAPrintSet(flName);
end;

//20250524
Procedure FindDuplicates(flName: string);
var
  i: integer;
  TempList: TStringList;
  Str1, PrevStr: string;
  TempList2: TStringList;
begin
  TempList := TStringList.Create;
  TempList.LoadFromFile(flName);
  TempList.Sorted := True;
  // TempList2 := TStringList.Create;
  PrevStr := '';
  for i := 0 to TempList.Count - 1 do
  begin
    Str1 := LeftStr(TempList[i], 7);
    if Str1 = PrevStr then
      ShowMessage('Duplicate ' + TempList[i]);
    PrevStr:=Str1;
  end;
  // TempList2.SaveToFile(flName);
  TempList.Free;
  TempList2.Free;
end;

procedure ReviseAPrintSet(flName: string);
var
  i: integer;
  TempList: TStringList;
  FrmName, PrevFrm: string;
  TempList2: TStringList;
begin
  TempList := TStringList.Create;
  TempList.LoadFromFile(flName);
  // TempList.Sorted:=True;
  for i := 0 to TempList.Count - 1 do
  begin
    FrmName := MidStr(TempList[i], 2, 12);
    if LeftStr(UpperCase(FrmName), 5) = 'PAGE_' then
      FrmName := 'T2';
    if UpperCase(FrmName) = 'INV_1' then
      FrmName := 'INVOICE';
    if UpperCase(FrmName) = 'INV_2' then
      FrmName := 'INVFORMS';
    if UpperCase(FrmName) = 'FNOTE1' then
      FrmName := 'S141'; // 20150829
    if UpperCase(FrmName) = 'FNOTE_1' then
      FrmName := 'S141';
    if UpperCase(FrmName) = 'FNOTE_2' then
      FrmName := 'FNOTE2';

    FrmName := ExtractFormRootName(FrmName);
    TempList[i] := LeftStr(TempList[i], 1) + FrmName;
  end;
  // remove duplicates
  TempList.Sorted := True;
  TempList2 := TStringList.Create;
  PrevFrm := '';
  for i := 0 to TempList.Count - 1 do
  begin
    FrmName := MidStr(TempList[i], 2, 12);
    if FrmName = PrevFrm then
      // ignore it
    else
    begin
      TempList2.Add(TempList[i]);
      PrevFrm := FrmName;
    end;
  end;
  TempList2.SaveToFile(flName);

  TempList.Free;
  TempList2.Free;
end;

function OldPrintSet(flName: string): Boolean;
var
  i, j: integer;
  TempList: TStringList;
  FrmName: string;
  // check if user still has the old forms with Undescore (single pages)
begin
  Result := False;
  TempList := TStringList.Create;
  TempList.LoadFromFile(flName);
  for i := 0 to TempList.Count - 1 do
  begin
    FrmName := MidStr(TempList[i], 2, 12);
    for j := 1 to Length(FrmName) do
    begin
      if MidStr(FrmName, j, 1) = '_' then
      begin
        Result := True;
        TempList.Free;
        exit;
      end;
    end;
  end;
  TempList.Free;
end;

function RemoveSpecialCharacters(s: string): string; // 20121209
begin
  Result := s;
  exit; // causes problems
end;

function LicenseLevel: eLicenseLevel;
begin
  Result := AppT2.LicenseLevel;
end;

function LicenseName: string;
begin
  Result := AppT2.ProductName;
end;

Function IsEnterpriseVersion: Boolean; //20231211 Igor
begin
  Result := LicenseLevel = llEnterprise;
end;


function IsNumberInSet(Numb, FromNumb, ToNumb, Incr: integer): Boolean;
// find if a number is within a set defined by increment within a range
var
  x: Real;
begin
  Result := False;
  if (Numb > ToNumb) or (Numb < FromNumb) or (FromNumb > ToNumb) or (Incr = 0)
  then
    exit;
  x := (Numb - FromNumb) mod Incr;
  if x = 0 then
    Result := True;
end;

function Class43HasDetail(RetNo: integer; RowNo: integer): Boolean;
var
  i, FNo: integer;
begin
  Result := False;
  FNo := GetFormNo('S8All');
  i := 402;
  repeat
    if FetchElmFNo(RetNo, FNo, i) = IntTostr(RowNo) then
    begin
      Result := True;
      exit;
    end;
    Inc(i, 4);
  until i > 630;
end;

// 20150214

procedure FixMostRecent;
var
  TempList: TStringList;
begin
  // 20150218  John
  // If FileExists(AppDir+'\'+RecentFlName) = False then
  // begin
  // neither of these work, files do not seem to be created in time
  // TempList.add('') //InitMostRecentFiles(30) //put them in RecentFlName
  // end;
  // else
  // TempList.LoadFromFile(AppDir+'\'+'Recent.txt');

  // 20150218
  if FileExists(AppDir + '\' + RecentFlName) then
  begin
    TempList := TStringList.Create;
    TempList.LoadFromFile(AppDir + '\' + RecentFlName);
    // fails if Recent.txt does not exist, Recent.txt and other files not created at first logon
    if TempList.Count = 1 then
    begin
      if UpperCase(LeftStr(TempList[0], 21)) = 'CANADIAN CORPORATIONS' then
      begin
        TempList.clear;
        TempList.SaveToFile(AppDir + '\' + 'Recent.txt');
      end;
    end;
    TempList.Free;
  end;
end;

function IncrString(s: string; ByValue: integer): string;
begin
  Result := '';
  if s > '' then
    Result := IntTostr(MyStrToInt(s) + ByValue);
end;

// 20140704

function RemoveInvalidEFCharacters(s: string): string;
var
  i, j: integer;
  isValid: Boolean;
  // acceptedSet : set of char;
begin
  for i := 1 to Length(s) do
  begin
    if not(CharInSet(s[i], acceptedEFSet)) then
    begin
      s[i] := ' '; // 20140703
      // showmessage('new string: ' + s);
    end;
  end;
  Result := s;
end;

Procedure PopISGifiLines(FromLine: String; ToLine: String); // 20150720
Var
  i: integer;
  TempList: TStringList;
begin
  SomeList.clear; // :=TStringList.Create;
  TempList := TStringList.Create;

  TempList.LoadFromFile(AppDir + '\' + 'GIFIIS.d');

  // need to exclude some lines such as total 8089

  For i := 0 to TempList.Count - 1 do
  begin
    If (LeftStr(AllTrim(TempList[i]), 4) >= FromLine) and
      (LeftStr(AllTrim(TempList[i]), 4) <= ToLine) then
      SomeList.Add(AllTrim(TempList[i]));
  end;
  If FromLine = '3460' then
    SomeList.Add('3470 Amounts held in trust');
  TempList.Free;
end;

Procedure PopBSGifiLines(FromLine: String; ToLine: String); // 20150816
Var
  i: integer;
  TempList: TStringList;
begin
  SomeList.clear; // :=TStringList.Create;
  TempList := TStringList.Create;
  TempList.Sorted := True; // 20150817
  TempList.LoadFromFile(AppDir + '\' + 'GIFIBS.d');

  // need to exclude some lines such as total 8089

  For i := 0 to TempList.Count - 1 do
  begin
    If (LeftStr(AllTrim(TempList[i]), 4) >= FromLine) and
      (LeftStr(AllTrim(TempList[i]), 4) <= ToLine) then
      SomeList.Add(AllTrim(TempList[i]));
  end;
  // If FromLine='3460' then SomeList.add('3470 Amounts held in trust');
  TempList.Free;
end;

// 20150818
Function S100LineShouldBeNegative(LineNo, ValStr: String): Boolean;
Var
  i: integer;
  TempList: TStringList;
  x: Real;
begin
  Result := False;
  if ((LineNo >= '1600') and (LineNo <= '1922')) // it is an tangible assets
    or ((LineNo >= '2010') and (LineNo <= '2077')) or
    ((LineNo >= '3700') and (LineNo <= '3741')) // 20160514
    or (LineNo = '1063') // 20160514
  then // it is an intangible assets
    // continue to see if it is supposed to be negative
  Else
    exit;

  x := VL(ValStr);
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir + '\' + 'NegBs.d');
  For i := 0 to TempList.Count - 1 do
  begin
    If (LineNo = LeftStr(TempList[i], 4)) and (x > 0) then
    begin
      Result := True;
      Break;
    end;
  end;
  TempList.Free;
end;

(* 20150506
  //20150822
  function CountS125IncStatements(RetNo: Integer): Integer;
  var
  i, j, FNo: Integer;
  FName: string;
  FInst: string;
  begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
  FRec := FList.Items[i];
  FName := Frec.FormName;
  if FName='S125' then
  Begin
  FInst := AllTrim(Frec.FormInst); //alltrim 20111129
  FNo := Frec.FormNo;
  If Ret[RetNo].FrmHasData[Fno] then Inc(result);
  End;
  end;
  end;
*)

// 20150827
Function GetIsArrayNoFromGifiLine(Ln: String): String;
Var
  ArrayNo: String;
Begin
  ArrayNo := '00';
  If ((Ln >= '8000') and (Ln <= '8088')) then
    ArrayNo := '01'
  Else if ((Ln >= '8090') and (Ln <= '8250')) then
    ArrayNo := '02'
  Else if ((Ln >= '8300') and (Ln <= '8503')) then
    ArrayNo := '03'
  Else if ((Ln >= '8520') and (Ln <= '9286')) then
    ArrayNo := '04'
  Else if ((Ln >= '9370') and (Ln <= '9650')) then
    ArrayNo := '05'
  Else if ((Ln >= '9660') and (Ln <= '9870')) then
    ArrayNo := '06';

  Result := ArrayNo;

End;

// 20150827
Function GetBSArrayNoFromGifiLine(Ln: String): String;
Var
  ArrayNo: String;
Begin
  // 20160430
  ArrayNo := '00';
  If ((Ln >= '1000') and (Ln <= '1486')) then
    ArrayNo := '01'
  Else if ((Ln >= '1600') and (Ln <= '2007')) then
    ArrayNo := '02' // 20160430
    // Else if ((Ln>='1600') and (Ln<='1922')) then ArrayNo:='02'
  Else if ((Ln >= '2010') and (Ln <= '2177')) then
    ArrayNo := '03'
    // 20160430 //Else if ((Ln>='2010') and (Ln<='2077')) then ArrayNo:='03'
  Else if ((Ln >= '2180') and (Ln <= '2588')) then
    ArrayNo := '04' // 20160430
    // Else if ((Ln>='2180') and (Ln<='2590')) then ArrayNo:='04'
  Else if ((Ln >= '2600') and (Ln <= '3138')) then
    ArrayNo := '05'
    // Else if ((Ln>='2600') and (Ln<='3139')) then ArrayNo:='05'  //20160430
  Else if (((Ln >= '3140') and (Ln <= '3449')) Or (Ln >= '3451') and
    (Ln <= '3470')) then
    ArrayNo := '06'
    // Else if ((Ln>='3140') and (Ln<='3470')) then ArrayNo:='06'
  Else if ((Ln >= '3520') and (Ln <= '3599')) then
    ArrayNo := '07'
    // Else if ((Ln>='3520') and (Ln<='3580')) then ArrayNo:='07'
  Else if (((Ln >= '3661') and (Ln <= '3679')) or (Ln > '3681') and
    (Ln <= '3848')) then
    ArrayNo := '08';
  // Else if ((Ln>='3700') and (Ln<='3475')) then ArrayNo:='08';
  Result := ArrayNo;
End;

Procedure ConvertOldGifiData(RetNo: integer);
Var
  i, OldFNo, NewFNo: integer;
begin
  // test only if Ret[RetNo].FrmHasData[GetFormNo('GIFIIS#1')]=False then Exit; //20160519 already converted to new GIFI in Multi version

  for i := 1 to 10 do // 20 do    //20160506
  Begin
    OldFNo := GetFormNo('GIFIIS#' + AllTrim(IntTostr(i)));
    NewFNo := GetFormNo('S125#' + AllTrim(IntTostr(i)));

    if OldFNo > 0 then
    Begin
      If (NewFNo = 0) then
      begin
        NewFNo := AddPageInstance(RetNo, 'S125',
          ExtractFormInst('S125' + AllTrim(IntTostr(i))));
        AddOtherPagesInstance(RetNo, 'S125',
          ExtractFormInst('S125' + AllTrim(IntTostr(i))));
        NewFNo := GetFormNo('S125' + AllTrim(IntTostr(i))); { get it again }
      end;
      If NewFNo > 0 then
        ConvertOldGifiISData(RetNo, OldFNo, NewFNo);
    end;
  end; // i

  OldFNo := GetFormNo('GIFIBS#1');
  NewFNo := GetFormNo('S100');
  ConvertOldGifiBSData(RetNo, OldFNo, NewFNo);

  {
    //do the gifi summary fields 9975 etc, used to be in GIFIBS#1 . Now it goes to S125#1 or S140
    OldFNo:=GetFormNo('GIFIBS#1');
    OldFNo:=GetFormNo('S125#1'); //normal, but it could also be S140 to be checked in the routine below
    ConvertOldGifiSUmmaryData(RetNo,OldFNo,NewFNo);
    if GetFormNo(GIFIIS#2)>0  then  //there are multiple statements
    Begin
    NewFNo:=GetFormNo('S140');
    End
    Else
    Begin
    NewFNo:=GetFormNo('S125#1');
    End;
  }

  OldFNo := GetFormNo('GIFIBS#2');
  NewFNo := GetFormNo('S101');
  if OldFNo > 0 then
    ConvertOldGifiBSData(RetNo, OldFNo, NewFNo);
End;

// 20150827
Procedure ConvertOldGifiISData(RetNo: integer; OldFNo, NewFNo: integer);
// Gifi inc statement conversion
Var
  i: integer;
  Ln, Val: String;
  // ArrayNo:Integer; //20160722 Igor
  GifiValues: TStringList;
begin
  // store fixed elm data
  StoreElmFNo(RetNo, NewFNo, 6, FetchElmFNo(RetNo, OldFNo, 1)); // SeqNoBox.Text
  StoreElmFNo(RetNo, NewFNo, 4, FetchElmFNo(RetNo, OldFNo, 2)); // opernm
  StoreElmFNo(RetNo, NewFNo, 5, FetchElmFNo(RetNo, OldFNo, 3)); // opernm
  // GIFI summary convesion

  // create a file with arrayNo Ln and Val for dynamic data
  If Ret[RetNo].Frm[OldFNo].Count > 4 then
  Begin
    GifiValues := TStringList.Create;
    i := 5;
    Repeat
      Ln := FetchElmFNo(RetNo, OldFNo, i);
      Val := FetchElmFNo(RetNo, OldFNo, i + 1);
      // 20160722 Igor >>>
      PutFIGIISLine(Ln, Val, RetNo, NewFNo, GifiValues);
      // //20160518
      // If      Ln='7000' then StoreElmFNo(RetNo,NewFNo,41,Val)
      // Else if Ln='7002' then StoreElmFNo(RetNo,NewFNo,44,Val)
      // Else if Ln='7004' then StoreElmFNo(RetNo,NewFNo,47,Val)
      // Else if Ln='7006' then StoreElmFNo(RetNo,NewFNo,50,Val)
      // Else if Ln='7008' then StoreElmFNo(RetNo,NewFNo,53,Val)
      // Else if Ln='7010' then StoreElmFNo(RetNo,NewFNo,56,Val)
      // Else if Ln='7020' then StoreElmFNo(RetNo,NewFNo,59,Val)
      //
      // Else if Ln='9975' then StoreElmFNo(RetNo,NewFNo,65,Val)
      // Else if Ln='9976' then StoreElmFNo(RetNo,NewFNo,68,Val)
      // Else if Ln='9980' then StoreElmFNo(RetNo,NewFNo,71,Val)
      // Else if Ln='9985' then StoreElmFNo(RetNo,NewFNo,74,Val)
      // Else if Ln='9990' then StoreElmFNo(RetNo,NewFNo,77,Val)
      // Else if Ln='9995' then StoreElmFNo(RetNo,NewFNo,80,Val)
      // Else
      // Begin
      // ArrayNo:=MyStrToInt(GetISArrayNoFromGifiLine(Ln));
      // if ArrayNo>0 then
      // Begin
      // GifiValues.Sorted:=True;
      // GifiValues.add(PaddZero(IntToStr(ArrayNo),2)+' '+Ln+' '+AllTrim(Val));
      // End;
      // End;
      // 20160722 Igor <<<
      Inc(i, 2);
    until i > Ret[RetNo].Frm[OldFNo].Count - 1;
    // end;  //20150905  //moved below by dodi
    // now store ln and val
    // now store ln and val - only when created //20150904   //by DODI but no change in logic?
    StoreGifiValues(RetNo, NewFNo, GifiValues);
    GifiValues.Free;
  End;
  // Do the remaing income statemets
  // ???
end;

Procedure ConvertOldGifiBSData(RetNo: integer; OldFNo, NewFNo: integer);
// balance shhet converion
Var
  i: integer;
  Ln, Val: String;
  // ArrayNo:Integer; //20160722 igor
  GifiValues: TStringList;
begin
  // Do the fixed data i.e.
  // do the Balance sheets
  // create a file with arrayNo Ln and Val  for dynamic data
  GifiValues := TStringList.Create;
  i := 1;
  Repeat
    Ln := FetchElmFNo(RetNo, OldFNo, i);
    Val := FetchElmFNo(RetNo, OldFNo, i + 1);

    // 20160722 Igor >>>
    PutFIGIBSLine(Ln, Val, RetNo, NewFNo, GifiValues); // 20160722 Igor
    // 20160618
    // if Ln='3500' then StoreElmFNo(RetNo,NewFNo,29,Val)
    // Else if Ln='3660' then StoreElmFNo(RetNo,NewFNo,44,Val)
    // Else
    // Begin
    // ArrayNo:=MyStrToInt(GetBSArrayNoFromGifiLine(Ln));
    // if ArrayNo>0 then
    // Begin
    // GifiValues.Sorted:=True;
    // GifiValues.add(PaddZero(IntToStr(ArrayNo),2)+' '+Ln+' '+LTrim(Val));
    // End;
    // End;
    // 20160722 Igor <<<
    Inc(i, 2);
  until i > Ret[RetNo].Frm[OldFNo].Count - 1;
  // now store ln and val
  StoreGifiValues(RetNo, NewFNo, GifiValues);
  GifiValues.Free;
end;

// 20150827
Procedure StoreGifiValues(RetNo: integer; FNo: integer;
  GifiValues: TStringList);
Var
  i, ArrayNo, Elm: integer;
  Ln, Val: String;
  // TempString:TstringList; //20160720 Igor
  CurrentArrayElm: array [1 .. 10] of integer;
  S140FNo, S125FNo: integer;

  function LocateAndGetElm(ALn: string): integer; // 20190225 Igor
  var
    ElmId, i: integer;
    V: string;
  begin
    Result := -1;
    ElmId := ArrayNo * 10000 + 1;
    if RetList[RetNo].Frm[FNo].SplitId(ElmId, False, False) then
      while True do
      begin
        i := ElmId - ArrayNo * 10000;
        if i >= MaxElm then
          Break;
        V := RetList[RetNo].Frm[FNo].Dyn[ArrayNo, i + 1];
        if V.IsEmpty then
          Break;
        if SameText(V, ALn) then
        begin
          Result := ElmId;
          Break;
        end;
        ElmId := ElmId + 4;
      end;
    if Result = -1 then
    begin
      Result := CurrentArrayElm[ArrayNo];
      CurrentArrayElm[ArrayNo] := CurrentArrayElm[ArrayNo] + 4;
    end;
  end;

begin
  // populate the FNo array by array.
  // initial current elm i.e. first column (Description) would be 100001 for array 1, then 200001, etc
  // 20190225 Igor >>>
  for ArrayNo := 1 to 10 do
  begin
    CurrentArrayElm[ArrayNo] := ArrayNo * 10000 + 1;
    if RetList[RetNo].Frm[FNo].SplitId(CurrentArrayElm[ArrayNo], False, False)
    then
      while True do
      begin
        i := CurrentArrayElm[ArrayNo] - ArrayNo * 10000;
        if i >= MaxElm then
          Break;
        Val := RetList[RetNo].Frm[FNo].Dyn[ArrayNo, i];
        if Val.IsEmpty then
          Break;
        CurrentArrayElm[ArrayNo] := CurrentArrayElm[ArrayNo] + 4;
      end;
  end;
  // 20190225 Igor <<<

  for i := 0 to GifiValues.Count - 1 do
  Begin
    ArrayNo := MyStrToInt(LeftStr(GifiValues[i], 2));
    Ln := MidStr(GifiValues[i], 4, 4);
    Val := MidStr(GifiValues[i], 9, 100);
    Elm := LocateAndGetElm(Ln); // 20190225 Igor
    StoreElm(RetNo, FNo, Elm, GetGifiLineDesciption(Ln));
    StoreElm(RetNo, FNo, Elm + 1, Ln);
    StoreElm(RetNo, FNo, Elm + 2, Val);
    // CurrentArrayElm[ArrayNo]:=CurrentArrayElm[ArrayNo]+4;  //ready for the next row //20190225 Igor
  End;

  // Now Store the GIFISUMMMARY fields from GIFIBS to S125#1 or S140
  S125FNo := GetFormNo('S125#1');
  S140FNo := GetFormNo('S140');
  for i := 0 to GifiValues.Count - 1 do
  Begin
    // ArrayNo:=MyStrToInt(LeftStr(GifiValues[i],2));
    Ln := MidStr(GifiValues[i], 4, 4);
    Val := MidStr(GifiValues[i], 9, 100);
    if (Ln >= '9975') and (Ln <= '9995') then
    begin
      if GetFormNo('GIFIIS#2') > 0 then // multiple statements
      begin
        If Ln = '9975' then
          StoreElm(RetNo, S140FNo, 6, Val);
        If Ln = '9976' then
          StoreElm(RetNo, S140FNo, 8, Val);
        If Ln = '9980' then
          StoreElm(RetNo, S140FNo, 10, Val);
        If Ln = '9985' then
          StoreElm(RetNo, S140FNo, 12, Val);
        If Ln = '9990' then
          StoreElm(RetNo, S140FNo, 14, Val);
        If Ln = '9995' then
          StoreElm(RetNo, S140FNo, 16, Val);
      end
      Else
      begin
        If Ln = '9975' then
          StoreElm(RetNo, S125FNo, 65, Val);
        If Ln = '9976' then
          StoreElm(RetNo, S125FNo, 68, Val);
        If Ln = '9980' then
          StoreElm(RetNo, S125FNo, 71, Val);
        If Ln = '9985' then
          StoreElm(RetNo, S125FNo, 74, Val);
        If Ln = '9990' then
          StoreElm(RetNo, S125FNo, 77, Val);
        If Ln = '9995' then
          StoreElm(RetNo, S125FNo, 80, Val);
      end;
    end;
  End; // i

end;

Function GetGifiLineDesciption(Ln: String): String;
Var
  i: integer;
  Dfile: String;
  TempList: TStringList;
Begin
  Result := '';
  if Ln >= '8000' then
    Dfile := 'GIFIIS.d'
  Else
    Dfile := 'GIFIBS.d';
  TempList := TStringList.Create;
  try
    TempList.LoadFromFile(AppDir + '\' + Dfile);
    for i := 0 to TempList.Count - 1 do
    Begin
      TempList[i] := Ltrim(TempList[i]);
      if LeftStr(Ltrim(TempList[i]), 4) = Ln then
      begin
        Result := MidStr(TempList[i], 6, 100);
        exit;
      end;
    End;
  finally
    freeAndNil(TempList);
  end;

end;

// 20151025
Function ValidNaics(Code: String): Boolean; // 20160220 Igor
Var
  i: integer;
  TempList: TStringList;
begin
  Result := True;
  TempList := TStringList.Create;
  try
    TempList.LoadFromFile(AppDir + '\' + 'NAICS.d');
    For i := 0 to TempList.Count - 1 do
    Begin
      If Code = Ltrim(LeftStr(TempList[i], 7)) then
        exit;
    end;
    Result := False;
  finally
    freeAndNil(TempList); // 20160720 Igor
  end;
end;

Function GetSpouseSIN(RetNo: integer): String; // 20160222 Igor
begin
  Result := FetchElm(RetNo, 'INFO', 4);
end;

Function IsSelfEmployed(RetNo: integer): Boolean; // 20160222 Igor
begin
  Result := False;
  With Ret[RetNo] do
  begin
    If Ln[162] + Ln[164] + Ln[166] + Ln[168] + Ln[170] <> 0 then
      Result := True; // gross
  end;
end;

Function GetSinNo(RetNo: integer): String; // 20160222 Igor
begin
  Result := FetchElm(RetNo, 'INFO', 1); //20240724 Igor
end;

Function GetBN(RetNo: integer): String; // 20171205 Igor
begin
  Result := FetchElm(RetNo, 'T2', 1);
end;

Function GetStreetAddress(RetNo: integer): String; // 20160222 Igor
Var
  s: String;
  InfoFNo: integer;
begin
  InfoFNo := GetFormNo('INFO');
  Result := '';
  If FetchElmFNo(RetNo, InfoFNo, 22) > '' then
    Result := FetchElmFNo(RetNo, InfoFNo, 22) + '-'; // apt
  Result := Result + FetchElmFNo(RetNo, InfoFNo, 6) // str
    + ' ' + FetchElmFNo(RetNo, InfoFNo, 68) // po box
    + ' ' + FetchElmFNo(RetNo, InfoFNo, 163); // RR
end;

Function IsValidLastYearPgmFolder(AShowMessage: Boolean;
  out AErrorMessage: String): Boolean; // 20160424 Igor //20160516 Igor
Var
  LastYearPgm, LastYearBpl: String;
begin
  Result := False;
  AErrorMessage := '';
  // 20160608 Igor
  if OptRec.Dir_PgmLastYr = '' then
  // if not set Dir_PgmLastYr then search returns in Cur_Dir
  begin
    Result := True;
    exit;
  end;
  (*
    If OptRec.Dir_PgmLastYr = '' then
    begin
    AErrorMessage := 'You should first enter the program directory you used last year'
    +Chr(13)+'See Configure | General Options | Data Directories.'+#13+
    '(Need restart program after configure last year directory)';
    if AShowMessage then //20160516 Igor
    ShowMessage(AErrorMessage);
    Exit;
    end;
  *)
  If (DirectoryExists(OptRec.Dir_PgmLastYr) = False) then
  Begin
    AErrorMessage := 'Last year program’s directory "' + OptRec.Dir_PgmLastYr +
      '" does not exist.' // 20160710 Igor
      + Chr(13) + 'See Configure | General Options | Data Directories' + #13 +
      'You need to Exit and restart the program after changing last year’s data directory';
    if AShowMessage then // 20160516 Igor
      ShowMessage(AErrorMessage);
    exit;
  End;

  If FileExists(OptRec.Dir_PgmLastYr + '\' + FormsDBLite) = False then
  Begin
    if FileExists(OptRec.Dir_PgmLastYr + '\' + ChangeFileExt(FormsDBLite,
      '.DBF')) = False then
    Begin
      AErrorMessage := 'Last Year' + Chr(39) + 's directory "' +
        OptRec.Dir_PgmLastYr + '" does not have a VisualTax form data base'
      // 20160710 Igor
        + Chr(13) + 'See Configure | General Options | Data Directories';
      if AShowMessage then // 20160516 Igor
        ShowMessage(AErrorMessage);
      exit;
    End;
  End;
  // 20160627 Igor
  // LastYearPgm := AppName+IntToStr(StrToInt(AppYear)-1)+'.EXE';
  // LastYearBpl := 'vt'+AppName+'_'+IntToStr(StrToInt(AppYear)-1)+'.bpl';
  // If not FileExists(OptRec.Dir_PgmLastYr+'\'+LastYearPgm) AND
  // not FileExists(OptRec.Dir_PgmLastYr+'\'+LastYearBpl) then
  // Begin
  // AErrorMessage := 'Last Year'+Chr(39)+'s directory does not have a VisualTax system files'
  // +Chr(13)+'See Configure | General Options | Data Directories';
  // if AShowMessage then //20160516 Igor
  // ShowMessage(AErrorMessage);
  // exit;
  // End;

  Result := True;
End;

(* 20160627
  Function IsValidLastYearPgmFolder(AShowMessage: Boolean; out AErrorMessage: String): boolean; //20160424 Igor //20160516 Igor
  Var
  LastYearPgm,
  LastYearBpl: String;
  begin
  Result:=False;
  AErrorMessage := '';
  //20160608 Igor
  if OptRec.Dir_PgmLastYr = '' then  // if not set Dir_PgmLastYr then search returns in Cur_Dir
  begin
  result := true;
  exit;
  end;
  {
  If OptRec.Dir_PgmLastYr = '' then
  begin
  AErrorMessage := 'You should first enter the program directory you used last year'
  +Chr(13)+'See Configure | General Options | Data Directories.'+#13+
  '(Need restart program after configure last year directory)';
  if AShowMessage then //20160516 Igor
  ShowMessage(AErrorMessage);
  Exit;
  end;
  }
  If (DirectoryExists(OptRec.Dir_PgmLastYr) = false) then
  Begin
  AErrorMessage := 'Last year program’s directory does not exist.'
  +Chr(13)+'See Configure | General Options | Data Directories'+#13+
  'You need to Exit and restart the program after changing last year’s data directory';
  if AShowMessage then //20160516 Igor
  ShowMessage(AErrorMessage);
  exit;
  End;

  If FileExists(OptRec.Dir_PgmLastYr+'\'+FormsDBLite) = false then
  Begin
  if FileExists(OptRec.Dir_PgmLastYr+'\'+ChangeFileExt(FormsDBLite,'.DBF')) = False then
  Begin
  AErrorMessage := 'Last Year'+Chr(39)+'s directory does not have a VisualTax form data base'
  +Chr(13)+'See Configure | General Options | Data Directories';
  if AShowMessage then //20160516 Igor
  ShowMessage(AErrorMessage);
  Exit;
  End;
  End;
  LastYearPgm := AppName+IntToStr(StrToInt(AppYear)-1)+'.EXE';
  LastYearBpl := 'vt'+AppName+'_'+IntToStr(StrToInt(AppYear)-1)+'.bpl';
  If not FileExists(OptRec.Dir_PgmLastYr+'\'+LastYearPgm) AND
  not FileExists(OptRec.Dir_PgmLastYr+'\'+LastYearBpl) then
  Begin
  AErrorMessage := 'Last Year'+Chr(39)+'s directory does not have a VisualTax system files'
  +Chr(13)+'See Configure | General Options | Data Directories';
  if AShowMessage then //20160516 Igor
  ShowMessage(AErrorMessage);
  exit;
  End;

  result:=True;
  End;
*)

{
  Function IsValidLastYearPgmFolder(AShowMessage: Boolean; out AErrorMessage: String): boolean; //20160424 Igor //20160516 Igor
  Var
  LastYearPgm,
  LastYearBpl: String;
  begin
  Result:=False;
  AErrorMessage := '';
  If OptRec.Dir_PgmLastYr = '' then
  begin
  AErrorMessage := 'You should first enter the programm directory you used last year'
  +Chr(13)+'See Configure | General Options | Data Directories.'+#13+
  '(Need restart programm after configure last year directory)';
  if AShowMessage then //20160516 Igor
  ShowMessage(AErrorMessage);
  Exit;
  end;
  If (DirectoryExists(OptRec.Dir_PgmLastYr) = false) then
  Begin
  AErrorMessage := 'Last year programm''s directory not exists.'
  +Chr(13)+'See Configure | General Options | Data Directories'+#13+
  '(Need restart programm after configure last year directory)';
  if AShowMessage then //20160516 Igor
  ShowMessage(AErrorMessage);
  exit;
  End;

  If FileExists(OptRec.Dir_PgmLastYr+'\'+FormsDBLite) = false then
  Begin
  if FileExists(OptRec.Dir_PgmLastYr+'\'+ChangeFileExt(FormsDBLite,'.DBF')) = False then
  Begin
  AErrorMessage := 'Last Year'+Chr(39)+'s directory does not have a VisualTax form data base'
  +Chr(13)+'See Configure | General Options | Data Directories';
  if AShowMessage then //20160516 Igor
  ShowMessage(AErrorMessage);
  Exit;
  End;
  End;
  LastYearPgm := AppName+IntToStr(StrToInt(AppYear)-1)+'.EXE';
  LastYearBpl := 'vt'+AppName+'_'+IntToStr(StrToInt(AppYear)-1)+'.bpl';
  If not FileExists(OptRec.Dir_PgmLastYr+'\'+LastYearPgm) AND
  not FileExists(OptRec.Dir_PgmLastYr+'\'+LastYearBpl) then
  Begin
  AErrorMessage := 'Last Year'+Chr(39)+'s directory does not have a VisualTax system files'
  +Chr(13)+'See Configure | General Options | Data Directories';
  if AShowMessage then //20160516 Igor
  ShowMessage(AErrorMessage);
  exit;
  End;
  result:=True;
  End;
}

Function isValidLastYearDataFolder(AShowMessage: Boolean;
  out AErrorMessage: String): Boolean; // 20160424 Igor //20160516 Igor
Begin
  AErrorMessage := '';
  Result := False;
  // 20160608 Igor
  If OptRec.Dir_LastYr = '' then
  // if not set Dir_LastYr then search returns in Cur_Dir
  Begin
    Result := True;
    exit;
  End;
  (*
    If OptRec.Dir_LastYr='' then
    begin
    AErrorMessage := 'You should first enter the data directory you used last year'
    +Chr(13)+'See Configure | General Options | Data Directories';
    if AShowMessage then
    ShowMessage(AErrorMessage);
    Exit;
    end;
  *)
  // 20160711 Igor
  If (DirectoryExists(OptRec.Dir_LastYr) = False) then
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
  Result := True;
End;

{
  Function isValidLastYearDataFolder(AShowMessage: Boolean; out AErrorMessage: String): Boolean; //20160424 Igor //20160516 Igor
  Begin
  AErrorMessage := '';
  Result := False;
  If OptRec.Dir_LastYr='' then
  begin
  AErrorMessage := 'You should first enter the data directory you used last year'
  +Chr(13)+'See Configure | General Options | Data Directories';
  if AShowMessage then
  ShowMessage(AErrorMessage);
  Exit;
  end;
  If not FileExists(OptRec.Dir_LastYr+'\' + OptRec.ClientsDBLite) then
  begin
  if not FileExists(OptRec.Dir_LastYr+'\' + ClientsTable_dbf) then
  Begin
  AErrorMessage := 'Last Year'+Chr(39)+'s directory does not have a VisualTax Client data base'
  +Chr(13)+'See Configure | General Options | Data Directories';
  if AShowMessage then
  ShowMessage(AErrorMessage);
  Exit;
  End;
  end;
  result := True;
  End;
}
procedure InitLastYearFormsTable; // 20160424 Igor
var
  LastYearDir: string;
  f: TextFile;
begin
  LastYearDir := OptRec.Dir_PgmLastYr;
  if LastYearDir = '' then
    LastYearDir := OptRec.AppDir;

  // 20160710 Igor
  // for T2 all returns use setting T2_2020
  FullPathT2Scr_LastYear := OptRec.AppDir + '\' + FormsDBLite;
  // If not DirectoryExists(LastYearDir) then Exit;
  // If FileExists(LastYearDir+'\'+FormsDBLite) then
  // Begin
  // FullPathT2Scr_LastYear := LastYearDir+'\'+FormsDBLite; //use original db file    //20160425
  // End
  // else
  // if Fileexists(LastYearDir+'\'+ChangeFileExt(FormsDBLite,'.DBF')) then
  // begin
  // FullPathT2Scr_LastYear := LastYearDir+'\'+ChangeFileExt(FormsDBLite,'.DBF'); //use converted db     //20160425 Con
  // end
  // else
  // exit; //bad directory
  // If not FileExists(LastYearDir+'\'+FieldsListD) then
  // begin //create empty file
  // assign(F,LastYearDir+'\'+FieldsListD);
  // rewrite(F);
  // CloseFile(F);
  // end;

  FLastYearList := TFListT2.Create(AppT2, FormsLimit, FieldsLimit,
    FullPathT2Scr_LastYear, FormsTableLite, LastYearDir); // 20160425 Con
  // 20160710 Igor
  if not FLastYearList.InitFormsTable(LastYearDir, FullPathT2Scr_LastYear,
    FormsTableLite) then // 20160425 Con
  Begin
    freeAndNil(FLastYearList);
    exit;
  End;
end;

Function GetRenamedFName(FName: String): String; // 20160424 Igor
Var
  TempList: TStringList;
  FInst: String;
  i: integer;
begin
  Result := FName;
  if FileExists(AppDir + '\Substit.d') then
  begin
    TempList := TStringList.Create;
    try
      TempList.LoadFromFile(AppDir + '\Substit.d');
      FInst := ExtractFormInst(FName);
      FName := ExtractFormRootName(FName);
      For i := 0 to TempList.Count - 1 do
        If UpperCase(FName) = RTrim(UpperCase(LeftStr(TempList[i], 10))) then
        begin
          Result := UpperCase(AllTrim(MidStr(TempList[i], 14, 10)));
          Result := Result + FInst;
          Break;
        end;
    finally
      TempList.Free;
    end;
  end;
end;

function GetLastYearFormNo(FormName: String): integer; // 20160424 Igor
begin
  Result := FLastYearList.ByFormName(UpperCase(FormName)).FormNo;
end;

function GetLastYearFormName(FormNo: integer): String; // 20160704 Igor
begin
  Result := FLastYearList.GetFormName(FormNo);
end;

Procedure GetLastYearS125Data(OldFNo, RetNo: integer); // 20160518
Begin
  //

End;

Procedure GetLastYearS100Data(OldFNo, RetNo: integer); // 20160518
Begin
  //

End;

Function ValidForT106Efile(RetNo: integer; FNo: integer): Boolean;
// 20170627 CON
var
  i: integer;
begin
  Result := True;
end;

Function ValidForT1135Efile(RetNo: integer; FNo: integer): Boolean;
// 20160523 Igor
var
  i: integer;
begin
  Result := True;
  // If FetchElmFNo(RetNo,FNo,39)>'' then //alredy efiled
  // result:=False;
end;

Function CreateEfileResponseHtm(RetNo: integer; AckRec: TAckRec;
  // 20160523 Igor
  HtmFile: String): String;
var
  htmlSource: TStringList;
  source, flName: string;
  OnlineNo, Password, url, NetFileDir: String;
  i, j, k, s, StartPos, itemNumTemp: integer;
begin
  Result := '';
  GetEOLParms(OnlineNo, Password, url, NetFileDir);
  htmlSource := TStringList.Create;
  htmlSource.LoadFromFile(HtmFile);
  For i := 0 to htmlSource.Count - 1 do
  begin
    StartPos := pos('!Client!', htmlSource[i]);
    if StartPos > 0 then
      htmlSource[i] := AckRec.GivenName + ' ' + AckRec.FamilyName;
    {
      startPos := pos('!FamilyName!', htmlSource[i]);
      if  startPos > 0 then htmlSource[i] := AckRec.FamilyName;

      startPos := pos('!GivenName!', htmlSource[i]);
      if  startPos > 0 then htmlSource[i] := AckRec.GivenName;
    }

    StartPos := pos('!Received!', htmlSource[i]);
    if StartPos > 0 then
      htmlSource[i] := 'Acknowledgement received: ' + AckRec.DateReceived + ' '
        + AckRec.TimeReceived;

    StartPos := pos('!DocumentNo!', htmlSource[i]);
    if StartPos > 0 then
      htmlSource[i] := AckRec.DocumentNo;

    StartPos := pos('!TransmissionNo!', htmlSource[i]);
    if StartPos > 0 then
      htmlSource[i] := AckRec.TransmissionNo;

    If (AckRec.Accepted = False) and (AckRec.ResultCode <> '184') then
    Begin
      // failures other than 184 code (i.e, connection problems, and not tax return errors
      StartPos := pos('!ResultCode!', htmlSource[i]);
      if (StartPos > 0) and (AckRec.ResultCode <> '184') then
        htmlSource[i] := AckRec.ResultCode;

      StartPos := pos('!Description!', htmlSource[i]);
      if (StartPos > 0) and (AckRec.ResultCode <> '184') then
        htmlSource[i] := GetWebServiceErrorDescr(AckRec.ResultCode);
    end;
    // ----------------------------------------------------------------

    // tax return error codes
    StartPos := pos('!ErrorCode[1]!', htmlSource[i]);
    if StartPos > 0 then
      htmlSource[i] := AckRec.ErrorCode[1];

    StartPos := pos('!ErrorCode[2]!', htmlSource[i]);
    if StartPos > 0 then
      htmlSource[i] := AckRec.ErrorCode[2];

    StartPos := pos('!ErrorCode[3]!', htmlSource[i]);
    if StartPos > 0 then
      htmlSource[i] := AckRec.ErrorCode[3];

    StartPos := pos('!ErrorCode[4]!', htmlSource[i]);
    if StartPos > 0 then
      htmlSource[i] := AckRec.ErrorCode[4];

    StartPos := pos('!ErrorCode[5]!', htmlSource[i]);
    if StartPos > 0 then
      htmlSource[i] := AckRec.ErrorCode[5];

    StartPos := pos('!ErrorCode[6]!', htmlSource[i]);
    if StartPos > 0 then
      htmlSource[i] := AckRec.ErrorCode[6];

    // Error descriptions code coming from the EfErrors.db
    StartPos := pos('!Description[1]!', htmlSource[i]);
    if StartPos > 0 then
      htmlSource[i] := GetEfErrorDescr(AckRec.ErrorCode[1]);

    StartPos := pos('!Description[2]!', htmlSource[i]);
    if StartPos > 0 then
      htmlSource[i] := GetEfErrorDescr(AckRec.ErrorCode[2]);

    StartPos := pos('!Description[3]!', htmlSource[i]);
    if StartPos > 0 then
      htmlSource[i] := GetEfErrorDescr(AckRec.ErrorCode[3]);

    StartPos := pos('!Description[4]!', htmlSource[i]);
    if StartPos > 0 then
      htmlSource[i] := GetEfErrorDescr(AckRec.ErrorCode[4]);

    StartPos := pos('!Description[5]!', htmlSource[i]);
    if StartPos > 0 then
      htmlSource[i] := GetEfErrorDescr(AckRec.ErrorCode[5]);
  end;

  flName := NetFileDir + '\' + GetLastName(RetNo) + ' ' + GetFirstName(RetNo) +
    '-EFileAck.htm';
  htmlSource.SaveToFile(flName);
  htmlSource.Free;
end;

Function GetBirthDate(RetNo: integer): String; // 20160523 Igor
begin
  // result := FetchElm(RetNo, 'INFO', 9);
  Result := '';
end;

Function GetWebServiceErrorDescr(ErrorCode: String): AnsiString; // 20160523
Var
  ADConnection: TADConnection;
  Tbl: TADTable;
begin
  Result := '';

  ADConnection := TADConnection.Create(Application);
  Tbl := TADTable.Create(Application);
  // 201600226 Igor >>>>>
  if not SetTableName(ADConnection, Tbl, AppDir + '\' + WSErrorsDBLite,
    WSErrorsTableLite, 'Code') then
  Begin
    if Assigned(ADConnection) then
      freeAndNil(ADConnection);
    if Assigned(Tbl) then
      freeAndNil(Tbl);
    exit;
  End;
  // 20160226 Igor <<<<
  if Tbl.FindKey([ErrorCode]) = True then
  begin
    Result := Tbl.FieldByName('Descr').AsString;
  end
  Else; // ShowMessage('See the Web Services Error Messages document Under EfileOnline');
  Tbl.Free;
  ADConnection.Free;
end;

Function GetEfErrorDescr(ErrorCode: String): AnsiString; // 20160523 Igor
Var
  ADConnection: TADConnection;
  Tbl: TADTable;
begin
  If Length(ErrorCode) = 6 then
    ErrorCode := 'Y' + MidStr(ErrorCode, 2, 5); // 20140119

  ADConnection := TADConnection.Create(Application);
  Tbl := TADTable.Create(Application);
  if not SetTableName(ADConnection, Tbl, AppDir + '\' + EfErrorsDBLite,
    EfErrorsTableLite, 'Code') then
  Begin
    if Assigned(ADConnection) then
      freeAndNil(ADConnection);
    if Assigned(Tbl) then
      freeAndNil(Tbl);
    exit;
  End;
  if Tbl.FindKey([ErrorCode]) = True then
  begin
    Result := Tbl.FieldByName('Descr').AsString;
  end
  Else; // ShowMessage('See the Error Messages document Under EfileOnline');
  Tbl.Free;
  ADConnection.Free;
end;

function ImportOneReturn(ADS: TDataSet; ASrcDir, ADstDir: String;
  out AErr: String; AOverride: Boolean): Boolean; // 20160617 Igor
var
  flName: String;
  RApp: String;
  RYear, WorkRetNo, FNo, j: integer;
  PrPStatus, EfStatus: String[2];
  Notes: String[80];
  DbfDataDir: String[60];
Begin
  Result := False;
  flName := Trim(ADS.FieldByName('File_Name').AsString);

  If flName = '' then
  Begin
    AErr := 'Skip record. FileName is empty';
    exit;
  End;
  If Not FileExists(IncludeTrailingBackslash(ASrcDir) + flName) then
  Begin
    AErr := 'Skip record. File "' + IncludeTrailingBackslash(ASrcDir) + flName +
      '" is missing';
    exit;
  End;
  { 20160703 CON  It was not in Igors notes
    if not GetReturnAppAndYear(ASrcDir, FlName, RApp, RYear) then
    Begin
    AErr := 'Skip record. File "'+IncludeTrailingBackslash(ASrcDir)+FlName+'" have bad format';
    exit;
    End;
  }
  if not GetReturnAppAndYear(ASrcDir, flName, RApp, RYear,
    AppT2.SQLLitePassword.PassArray) then // 20160703 Igor
  Begin
    AErr := 'Skip record. File "' + IncludeTrailingBackslash(ASrcDir) + flName +
      '" have bad format';
    exit;
  End;

  if (RApp <> AppName) { or (RYear <> AppYearInt) } then // 20160623 Igor
  Begin
    AErr := 'Skip record. File "' + IncludeTrailingBackslash(ASrcDir) + flName +
      '" does not belong to the current program';
    exit;
  End;

  try // 20160311 Igor
    WorkRetNo := ReadReturn(ASrcDir, flName, True, False); // 20160627 Igor
  except
    ON E: Exception DO
    Begin
      AErr := 'Return "' + flName + '" not read:' + #13 + E.Message;
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
    PrPStatus := FetchElm(WorkRetNo, 'STATUS', 4);
    If Not Numeric(PrPStatus) then
      PrPStatus := '00';
    EfStatus := FetchElm(WorkRetNo, 'STATUS', 15);
    If Not Numeric(EfStatus) then
      EfStatus := '00';
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
      StoreElm(WorkRetNo, FNo, j, User.UserName); // 20170112 Igor
    For j := 12 to 12 do
      StoreElm(WorkRetNo, FNo, j, FormatDateTime('yyyy-mm-dd', Date));
    { DateToStr(Date)); }
    For j := 13 to 13 do
      StoreElm(WorkRetNo, FNo, j, TimeToStr(Time));
    if Ret[WorkRetNo].Locked then
      Ret[WorkRetNo].Locked := False;
    If not FileExists(IncludeTrailingBackslash(ADstDir) + flName) or AOverride
    then
      If SaveReturn(WorkRetNo, ADstDir, flName, True, False) = 0 then
        Result := True
      else
        AErr := 'An error occurred while saving the file to disk'
    else
      AErr := 'Record skipped. File "' + flName +
        '" exists in destination folder.';
  end
  else
    AErr := 'Record skipped. Return not loaded';

  If WorkRetNo > 0 then
    RemoveReturnFromMemory(WorkRetNo);
End;

function GetLastYearFile(ARetNo: integer): String; // 20160701 Igor
Begin
  Result := FetchElm(ARetNo, 'STATUS', c_LastYearElm);
End;

procedure SetLastYearFile(const ARetNo: integer; AValue: String);
// 20160701 Igor
begin
  StoreElm(ARetNo, 'STATUS', c_LastYearElm, AValue);
end;

(* 20160627
  function ImportOneReturn(ADS: TDataSet; ASrcDir, ADstDir: String; out AErr: String;
  AOverride: Boolean): Boolean; //20160617 Igor
  var
  FlName: String;
  RApp: String;
  RYear, WorkRetNo, FNo, j: Integer;
  PrPStatus, EfStatus: String[2];
  Notes: String[80];
  DbfDataDir: String[60];
  Begin
  result := False;
  FlName := Trim(ADS.FieldByName('File_Name').AsString);

  If FlName = '' then
  Begin
  AErr := 'Skip record. FileName is empty';
  Exit;
  End;
  If Not fileExists(IncludeTrailingBackslash(ASrcDir)+FlName) then
  Begin
  AErr := 'Skip record. File "'+IncludeTrailingBackslash(ASrcDir)+FlName+'" is missing';
  Exit;
  End;
  if not GetReturnAppAndYear(ASrcDir, FlName, RApp, RYear) then
  Begin
  AErr := 'Skip record. File "'+IncludeTrailingBackslash(ASrcDir)+FlName+'" have bad format';
  exit;
  End;
  if (RApp <> AppName) {or (RYear <> AppYearInt)} then //20160623 Igor
  Begin
  AErr := 'Skip record. File "'+IncludeTrailingBackslash(ASrcDir)+FlName+'" does not belong to the current program';
  exit;
  End;


  try //20160311 Igor
  WorkRetNo:=ReadReturn(ASrcDir, FlName, true, true);
  except ON E: Exception DO
  Begin
  AErr := 'Return "'+FlName+'" not read:'+#13+E.Message;
  if WorkRetNo > 0 then
  Begin
  RemoveReturnFromMemory(WorkRetNo);
  WorkRetNo := 0;
  End;
  End;
  end;
  if WorkRetNo > 0 then
  begin
  StoreElm(WorkRetNo,GetFormNo('STATUS'),4,'01'); //not started
  Ret[WorkRetNo].SourceDataDir := OptRec.Dir_Cur; {fooli t}
  PrpStatus := FetchElm(WorkRetNo,'STATUS',4);
  If Not Numeric(PrpStatus) then PrpStatus :='00';
  EFStatus  := FetchElm(WorkRetNo,'STATUS',15);
  If Not Numeric(EFStatus) then EFStatus :='00';
  Notes     := FetchElm(WorkRetNo,'STATUS',14);
  CalcAll(WorkRetNo);
  FNo :=GetFormNo('STATUS');
  For j:=8 to 10 do StoreElm(WorkRetNo,FNo,j,'');
  For j:=18 to 30 do StoreElm(WorkRetNo,FNo,j,'');
  For j:=16 to 16 do StoreElm(WorkRetNo,FNo,j,'');
  For j:=14 to 14 do StoreElm(WorkRetNo,FNo,j,'');
  For j:=31 to 31 do StoreElm(WorkRetNo,FNo,j,'');

  For j:=11 to 11 do StoreElm(WorkRetNo,FNo,j,UserName);
  For j:=12 to 12 do StoreElm(WorkRetNo,FNo,j,FormatDateTime('yyyy-mm-dd',Date));
  {DateToStr(Date));}
  For j:=13 to 13 do StoreElm(WorkRetNo,FNo,j,TimeToStr(Time));
  if Ret[WorkRetNo].Locked then
  Ret[WorkRetNo].Locked := False;
  If not FileExists(IncludeTrailingBackslash(ADstDir) + FlName) or AOverride then
  If SaveReturn(WorkRetNo, ADstDir, FlName, True, False) = 0 then
  Result := True
  else
  AErr := 'An error occurred while saving the file to disk'
  else
  AErr := 'Record skipped. File "' + FlName + '" exists in destination folder.';
  end
  else
  AErr := 'Record skipped. Return not loaded';

  If WorkRetNo > 0 then
  RemoveReturnFromMemory(WorkRetNo);
  End;
*)

Function ShowUnconvertedLastYear(RNo: integer): Boolean; // 20160704 Igor
begin
  Result := False;
  If RNo = 0 then
    exit;
  Result := Ret[RNo].IsLastYearReturn;
end;

procedure QuickFormFind(RetNo: integer; ThisForm: String); // 20160711 Igor
Var
  i, Elm, FNo, TheLength: integer;
  FName: String;
  List1: TStringList;
begin
  ThisForm := UpperCase(ThisForm);
  ThisForm := AutocompleteFormName(ThisForm);
  TheLength := Length(ThisForm);

  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If ThisForm = AllTrim(ExtractFormRootName(FRec.FormName)) then
    begin
      FNo := FRec.FormNo;
      If FNo > 0 then
      begin
        OpenFormNo(RetNo, FNo, 0);
        exit;
      end;
    end;
  end;

  // load the firms
  List1 := TStringList.Create;
  List1.Sorted := True;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormShow then
      List1.AddObject(PaddR(FRec.FormRlNm, 10) + PaddR(FRec.FormDescr, 70) +
        FRec.FormName + FRec.FormInst, FRec);
  end; // i

  // not found as formname
  SomeCaption := 'Form or KeyWord found in following';
  SelectedString := PopMatchingList(ThisForm, List1, SomeCaption, True);
  List1.Free;
  If SelectedString > '' then
  begin
    TObject(FRec) := PopListObject; // ResultsList.Objects[PopListIdx];
    FNo := FRec.FormNo;
    OpenForm(RetNo, FNo, 0);
  end;
end;

function AutocompleteFormName(AFormName: String): String; // 20160711 Igor
begin
  If AFormName = 'S1' then
    Result := 'S01'
  else If AFormName = 'S2' then
    Result := 'S02'
  else If AFormName = 'S3' then
    Result := 'S03'
  else If AFormName = 'S4' then
    Result := 'S04'
  else If AFormName = 'S5' then
    Result := 'S05'
  else If AFormName = 'S6' then
    Result := 'S06'
  else If AFormName = 'S7' then
    Result := 'S07'
  else If AFormName = 'S8' then
    Result := 'S08'
  else If AFormName = 'S9' then
    Result := 'S09'
  else
    Result := AFormName;
end;

// 20171124 Igor>>
Function MkTddFileName(RNo: integer): String; // 20171123 Igor
Begin
  Result := IncludeTrailingPathDelimiter(AppT2.AppDir) + 'AFR\' + 'AFR-' +
    GetCorpName(RNo) + '-' + GetCorpBusNo(RNo) + '.txt';
end;

Function MkTddCorFileName(RNo: integer): String; // 20180518 Igor
Begin
  Result := IncludeTrailingPathDelimiter(AppT2.AppDir) + 'AFR\' + 'AFR-' +
    GetCorpName(RNo) + '-' + GetCorpBusNo(RNo) + '-COR.txt';
end;

Function MkTddFileNameAutofill(RNo: integer): String; // 20180530 Igor
begin
  Result := IncludeTrailingPathDelimiter(AppT2.AppDir) + 'AFR\' + 'AFR-' +
    GetCorpName(RNo) + '-' + GetCorpBusNo(RNo) + '-AutoFillData-.txt';
end;

Function GetRetNoFromBN(ABN: String): integer; // 20171205 Igor
Var
  i: integer;
begin
  Result := 0;
  If ABN = '' then
    exit;
  for i := 1 to (RetList.Count - 1) do
  begin
    RetRec := RetList[i];
    if (RetRec = nil) or RetRec.Destroying or (RetRec.MyApp <> AppT2) then
      continue;
    If GetBN(RetRec.RetNo) = ABN then
    begin
      Result := RetRec.RetNo;
      exit;
    end;
  end;
end;

Function IsDataGroupASlip(DataGroup: String): Boolean;
Begin
  Result := False;
  DataGroup := UpperCase(DataGroup);

  if (DataGroup = '??SLIP') then
    Result := True;
end;

function GetFormNo(FormName: String; RetNo: integer): integer;
var
  FRec: TFRec;
begin
  if (RetNo > 0) and Ret[RetNo].IsLastYearReturn then
    Result := FLastYearList.ByFormName(FormName).FormNo
  else
  begin
    FRec := FList.ByFormName(FormName);
    Result := FRec.FormNo;
  end;
end;

// 20171124 Igor<<
procedure ImportGIFI(ARetNo, AFormNo: integer; AFormName: String);
// 20160722 Igor
begin
  if SameText(AFormName, 'S100') then
    ImportGIFI_BS(ARetNo, AFormNo)
  else if SameText(Copy(AFormName, 1, 5), 'S125#') then
    ImportGIFI_IS(ARetNo, AFormNo)
  else
    MessageDlg('Unsupported targer form "' + AFormName + '"', mtWarning,
      [mbok], 0);
end;

procedure PutFIGIISLine(const ALineNo, AVal: String;
  ATargetRetNo, ATargetFormNo: integer; TargetStringList: TStringList);
var
  ArrayNo: integer;
Begin
  If ALineNo = '7000' then
    StoreElmFNo(ATargetRetNo, ATargetFormNo, 41, AVal)
  Else if ALineNo = '7002' then
    StoreElmFNo(ATargetRetNo, ATargetFormNo, 44, AVal)
  Else if ALineNo = '7004' then
    StoreElmFNo(ATargetRetNo, ATargetFormNo, 47, AVal)
  Else if ALineNo = '7006' then
    StoreElmFNo(ATargetRetNo, ATargetFormNo, 50, AVal)
  Else if ALineNo = '7008' then
    StoreElmFNo(ATargetRetNo, ATargetFormNo, 53, AVal)
  Else if ALineNo = '7010' then
    StoreElmFNo(ATargetRetNo, ATargetFormNo, 56, AVal)
  Else if ALineNo = '7020' then
    StoreElmFNo(ATargetRetNo, ATargetFormNo, 59, AVal)
  Else if ALineNo = '9975' then
    StoreElmFNo(ATargetRetNo, ATargetFormNo, 65, AVal)
  Else if ALineNo = '9976' then
    StoreElmFNo(ATargetRetNo, ATargetFormNo, 68, AVal)
  Else if ALineNo = '9980' then
    StoreElmFNo(ATargetRetNo, ATargetFormNo, 71, AVal)
  Else if ALineNo = '9985' then
    StoreElmFNo(ATargetRetNo, ATargetFormNo, 74, AVal)
  Else if ALineNo = '9990' then
    StoreElmFNo(ATargetRetNo, ATargetFormNo, 77, AVal)
  Else if ALineNo = '9995' then
    StoreElmFNo(ATargetRetNo, ATargetFormNo, 80, AVal)
  Else
  Begin
    ArrayNo := MyStrToInt(GetIsArrayNoFromGifiLine(ALineNo));
    if ArrayNo > 0 then
    Begin
      TargetStringList.Sorted := True;
      TargetStringList.Add(PaddZero(IntTostr(ArrayNo), 2) + ' ' + ALineNo + ' '
        + AllTrim(AVal));
    End;
  End;
End;

procedure PutFIGIBSLine(const ALineNo, AVal: String;
  ATargetRetNo, ATargetFormNo: integer; TargetStringList: TStringList);
// 20160722 Igor
var
  ArrayNo: integer;
Begin
  if ALineNo = '3500' then
    StoreElmFNo(ATargetRetNo, ATargetFormNo, 29, AVal)
  Else if ALineNo = '3660' then
    StoreElmFNo(ATargetRetNo, ATargetFormNo, 44, AVal)
  Else
  Begin
    ArrayNo := MyStrToInt(GetBSArrayNoFromGifiLine(ALineNo));
    if ArrayNo > 0 then
    Begin
      TargetStringList.Sorted := True;
      TargetStringList.Add(PaddZero(IntTostr(ArrayNo), 2) + ' ' + ALineNo + ' '
        + Ltrim(AVal));
    End;
  End;
End;

procedure ImportGIFI_IS(ARetNo, AFormNo: integer); // 20160722 Igor
var
  dlgOpen: TOpenDialog;
  ImportList, WList, GifiValues: TStringList;
  i, xInt: integer;
  LineNo, ValStr: String;
begin
  if CheckIsCloud then
    exit; // 20180503 Igor
  if MessageDlg('This will replace ALL amounts in the GIFI-IS. Proceed?',
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;
  dlgOpen := TOpenDialog.Create(nil);
  try
    dlgOpen.Filter := 'GIFI files(*.GFI)|*.GFI';
    dlgOpen.DefaultExt := 'GFI';
    dlgOpen.Options := dlgOpen.Options + [ofFileMustExist];
    if not dlgOpen.Execute then
      exit;
    ImportList := TStringList.Create;
    WList := TStringList.Create;
    GifiValues := TStringList.Create;
    Screen.Cursor := crHourGlass;
    try
      ImportList.LoadFromFile(dlgOpen.FileName);
      ClearGIFI(ARetNo, AFormNo); // 20190225 Igor
      { ignore first and last record }
      For i := 1 to ImportList.Count - 2 do
      begin
        ParseWords(ImportList[i], ',', WList);
        LineNo := AllTrim(RemoveChar(WList[0], '"'));
        { With enter value like batch entry }
        xInt := Round(VL(AllTrim(RemoveChar(WList[1], '"'))));
        ValStr := IntTostr(xInt);
        PutFIGIISLine(LineNo, ValStr, ARetNo, AFormNo, GifiValues);
      end;
      StoreGifiValues(ARetNo, AFormNo, GifiValues);
      MainFormT2.RecalcBtnClick(Application);
      Ret[ARetNo].MyChild.ActiveForm.RebuildDynamicRows;
      ShowFormData(ARetNo, '', AFormNo);
      MainForm.RefreshAuditPanel(ARetNo);
      If MainForm.FormsPanel.Visible then
        MainForm.RefreshFormsPanel(ARetNo);
    finally
      freeAndNil(ImportList);
      freeAndNil(WList);
      freeAndNil(GifiValues);
      Screen.Cursor := crDefault;
    end;
  finally
    freeAndNil(dlgOpen);
  end;
end;

procedure ImportGIFI_BS(ARetNo, AFormNo: integer); // 20160722 Igor
var
  dlgOpen: TOpenDialog;
  ImportList, WList, GifiValues: TStringList;
  i, xInt: integer;
  LineNo, ValStr: String;
begin
  if CheckIsCloud then
    exit; // 20180503 Igor
  if MessageDlg('This will replace ALL amounts in the GIFI-IS. Proceed?',
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;
  dlgOpen := TOpenDialog.Create(nil);
  try
    dlgOpen.Filter := 'GIFI files(*.GFI)|*.GFI';
    dlgOpen.DefaultExt := 'GFI';
    dlgOpen.Options := dlgOpen.Options + [ofFileMustExist];
    if not dlgOpen.Execute then
      exit;
    ImportList := TStringList.Create;
    WList := TStringList.Create;
    GifiValues := TStringList.Create;
    Screen.Cursor := crHourGlass;
    try
      ImportList.LoadFromFile(dlgOpen.FileName);
      ClearGIFI(ARetNo, AFormNo); // 20190225 Igor
      { ignore first and last record }
      For i := 1 to ImportList.Count - 2 do
      begin
        ParseWords(ImportList[i], ',', WList);
        LineNo := AllTrim(RemoveChar(WList[0], '"'));
        { With enter value like batch entry }
        xInt := Round(VL(AllTrim(RemoveChar(WList[1], '"'))));
        ValStr := IntTostr(xInt);
        PutFIGIBSLine(LineNo, ValStr, ARetNo, AFormNo, GifiValues);
      end;
      StoreGifiValues(ARetNo, AFormNo, GifiValues);
      MainFormT2.RecalcBtnClick(Application);
      Ret[ARetNo].MyChild.ActiveForm.RebuildDynamicRows;
      ShowFormData(ARetNo, '', AFormNo);
      MainForm.RefreshAuditPanel(ARetNo);
      If MainForm.FormsPanel.Visible then
        MainForm.RefreshFormsPanel(ARetNo);
    finally
      freeAndNil(ImportList);
      freeAndNil(WList);
      freeAndNil(GifiValues);
      Screen.Cursor := crDefault;
    end;
  finally
    freeAndNil(dlgOpen);
  end;
end;

procedure ClearGIFI(ARetNo, AFormNo: integer); // 20190225 Igor
var
  FormName: string;
  ArrayNo, Elm: integer;
begin
  FormName := ExtractNonInstFormName(GetFormName(AFormNo, ARetNo));
  if SameText(FormName, 'S125') then
  begin
    ArrayNo := 1;
    Elm := ArrayNo * 10000 + 3;
    ClearDynColumn(ARetNo, AFormNo, Elm);

    ArrayNo := 2;
    Elm := ArrayNo * 10000 + 3;
    ClearDynColumn(ARetNo, AFormNo, Elm);

    ArrayNo := 3;
    Elm := ArrayNo * 10000 + 3;
    ClearDynColumn(ARetNo, AFormNo, Elm);

    ArrayNo := 4;
    Elm := ArrayNo * 10000 + 3;
    ClearDynColumn(ARetNo, AFormNo, Elm);

    ArrayNo := 5;
    Elm := ArrayNo * 10000 + 3;
    ClearDynColumn(ARetNo, AFormNo, Elm);

    ArrayNo := 6;
    Elm := ArrayNo * 10000 + 3;
    ClearDynColumn(ARetNo, AFormNo, Elm);

    StoreElm(ARetNo, AFormNo, 41, '');
    StoreElm(ARetNo, AFormNo, 44, '');
    StoreElm(ARetNo, AFormNo, 47, '');
    StoreElm(ARetNo, AFormNo, 50, '');
    StoreElm(ARetNo, AFormNo, 53, '');
    StoreElm(ARetNo, AFormNo, 56, '');
    StoreElm(ARetNo, AFormNo, 59, '');

    StoreElm(ARetNo, AFormNo, 65, '');
    StoreElm(ARetNo, AFormNo, 68, '');
    StoreElm(ARetNo, AFormNo, 71, '');
    StoreElm(ARetNo, AFormNo, 74, '');
    StoreElm(ARetNo, AFormNo, 77, '');
    StoreElm(ARetNo, AFormNo, 80, '');

    Calc(ARetNo, FormName, AFormNo);
  end
  else if SameText(FormName, 'S100') then
  begin
    ArrayNo := 1;
    Elm := ArrayNo * 10000 + 3;
    ClearDynColumn(ARetNo, AFormNo, Elm);

    ArrayNo := 2;
    Elm := ArrayNo * 10000 + 3;
    ClearDynColumn(ARetNo, AFormNo, Elm);

    ArrayNo := 3;
    Elm := ArrayNo * 10000 + 3;
    ClearDynColumn(ARetNo, AFormNo, Elm);

    ArrayNo := 4;
    Elm := ArrayNo * 10000 + 3;
    ClearDynColumn(ARetNo, AFormNo, Elm);

    ArrayNo := 5;
    Elm := ArrayNo * 10000 + 3;
    ClearDynColumn(ARetNo, AFormNo, Elm);

    ArrayNo := 6;
    Elm := ArrayNo * 10000 + 3;
    ClearDynColumn(ARetNo, AFormNo, Elm);

    ArrayNo := 7;
    Elm := ArrayNo * 10000 + 3;
    ClearDynColumn(ARetNo, AFormNo, Elm);

    ArrayNo := 8;
    Elm := ArrayNo * 10000 + 3;
    ClearDynColumn(ARetNo, AFormNo, Elm);

    StoreElm(ARetNo, AFormNo, 47, '');
    StoreElm(ARetNo, AFormNo, 57, '');
    StoreElm(ARetNo, AFormNo, 29, '');
    StoreElm(ARetNo, AFormNo, 44, '');

    Calc(ARetNo, FormName, AFormNo);
  end
  else
    MainFormT2.ClearCurrentPageClick(nil);
end;

// 20221115 put back
// 20170528
Function FiscalTimeRequired(RetNo: integer): Boolean;
Begin
  Result := False;
  If UpperCase(FetchElm(RetNo, 'T2', 216)) = 'Y' then
    Result := True;
End;

// 20170525
Function FormatFiscalStartTime(RetNo: integer; Tm: String): String;
// tm in hh:mm
Begin
  // If FiscalTimeRequired(RetNo)=False then Exit;
  Result := Tm;
  if (Length(Tm) <> 5) or (MidStr(Tm, 3, 1) <> ':') Or
    (Not Numeric(LeftStr(Tm, 2))) Or (Not Numeric(RightStr(Tm, 2))) Or
    (VL(LeftStr(Tm, 2)) > 23) Or (VL(RightStr(Tm, 2)) > 59) then
  Begin
    Result := '00:00';
    exit;
  End;
End;

// 20170525
Function FormatFiscalEndTime(RetNo: integer; Tm: String): String;
// tm in hh:mm
Begin
  // If FiscalTimeRequired(RetNo)=False then Exit;
  Result := Tm;
  if (Length(Tm) <> 5) or (MidStr(Tm, 3, 1) <> ':') Or
    (Not Numeric(LeftStr(Tm, 2))) Or (Not Numeric(RightStr(Tm, 2))) Or
    (VL(LeftStr(Tm, 2)) > 23) Or (VL(RightStr(Tm, 2)) > 59) then
  Begin
    Result := '00:59';
    exit;
  End; // 20221115 put back
End;

// 20170614
Function NotPaidFor2018(RetNo: integer): Boolean; // 20170614
Var
  YrEnd: String; // Gave then T2-2017 for last two months of 2016
Begin
  Result := False;
  YrEnd := FetchElm(RetNo, 'T2', 11);
  // 20180204
  if YrEnd > '2017/12/31)' then
  Begin
    if LicenseList.Keys[AppT2.AppId] = 'T208-4467-3970-1872' then
    begin
      Result := True;
      exit;
    end; // ANZALI CONSULTING LTD/KENNETH OSKOUIAN
    if LicenseList.Keys[AppT2.AppId] = 'T204-8285-7364-1462' then
    begin
      Result := True;
      exit;
    end; // ALTAAJ ENTERPRISES LTD C/O OMAR ABDULLE
    if LicenseList.Keys[AppT2.AppId] = 'T206-4454-3959-1708' then
    begin
      Result := True;
      exit;
    end; // RNK PROFESSIONAL C/O RAVI KHANNA
    if LicenseList.Keys[AppT2.AppId] = 'T208-8368-7438-2082' then
    begin
      Result := True;
      exit;
    end; // JOHN HEPBURN
  end;

  if YrEnd > '2016/12/31)' then
  Begin
    if LicenseList.Keys[AppT2.AppId] = 'T201-8753-7780-1152' then
    begin
      Result := True;
      exit;
    end; // 1055165 ONTARIO CORP
    if LicenseList.Keys[AppT2.AppId] = 'T206-3679-3270-1490' then
    begin
      Result := True;
      exit;
    end; // Versico Financial
    if LicenseList.Keys[AppT2.AppId] = 'T201-1751-1557-0853' then
    begin
      Result := True;
      exit;
    end; // Bill Hummel
    if LicenseList.Keys[AppT2.AppId] = 'T206-8831-7850-1571' then
    begin
      Result := True;
      exit;
    end; // Marilyn Smith
    if LicenseList.Keys[AppT2.AppId] = 'T203-8803-7825-1244' then
    begin
      Result := True;
      exit;
    end; // NDC Accounting
    if LicenseList.Keys[AppT2.AppId] = 'T201-3251-2889-0991' then
    begin
      Result := True;
      exit;
    end; // OSVALDO IDAROLA
    If LicenseList.Keys[AppT2.AppId] = 'T206-6726-5979-1868' then
    begin
      Result := True;
      exit;
    end; // The Counting Department
    If LicenseList.Keys[AppT2.AppId] = 'T201-5257-4673-1014' then
    begin
      Result := True;
      exit;
    end; // WATKIN
    if LicenseList.Keys[AppT2.AppId] = 'T201-5161-4587-0968' then
    begin
      Result := True;
      exit;
    end; // 2264648 ONTARIO INC  Nan Li
    if LicenseList.Keys[AppT2.AppId] = 'T201-1261-1121-0462' then
    begin
      Result := True;
      exit;
    end; // 7178735 CANADA INC
    if LicenseList.Keys[AppT2.AppId] = 'T206-3383-3007-1220' then
    begin
      Result := True;
      exit;
    end; // ACCUTYPE BUSINESS SOLUTIONS
    if LicenseList.Keys[AppT2.AppId] = 'T201-2819-2506-0876' then
    begin
      Result := True;
      exit;
    end; // AMA MANAGEMENT LTD Barry Sharp
    if LicenseList.Keys[AppT2.AppId] = 'T204-4992-4437-1385' then
    begin
      Result := True;
      exit;
    end; // AR RASHAAD CENTRE INC
    if LicenseList.Keys[AppT2.AppId] = 'T201-5766-5125-0968' then
    begin
      Result := True;
      exit;
    end; // Anna Yang
    if LicenseList.Keys[AppT2.AppId] = 'T201-0788-0700-0807' then
    begin
      Result := True;
      exit;
    end; // BECKY CHAN CPA CGA
    if LicenseList.Keys[AppT2.AppId] = 'T206-5035-4476-1409' then
    begin
      Result := True;
      exit;
    end; // C UN & J XU PROFESSIONAL CORP
    if LicenseList.Keys[AppT2.AppId] = 'T201-8250-7333-0830' then
    begin
      Result := True;
      exit;
    end; // COMSTAR MOBILITY INC
    if LicenseList.Keys[AppT2.AppId] = 'T206-0942-0837-1382' then
    begin
      Result := True;
      exit;
    end; // JOHN E HOLT CGA
    if LicenseList.Keys[AppT2.AppId] = 'T201-4612-4100-0531' then
    begin
      Result := True;
      exit;
    end; // LARRY WALKER
    if LicenseList.Keys[AppT2.AppId] = 'T206-7867-6993-1976' then
    begin
      Result := True;
      exit;
    end; // MACKEY ACCOUNTING SERVICES LTD
    if LicenseList.Keys[AppT2.AppId] = 'T201-4531-4028-0738' then
    begin
      Result := True;
      exit;
    end; // MARILYN K ABBEY
    if LicenseList.Keys[AppT2.AppId] = 'T204-7985-7097-1635' then
    begin
      Result := True;
      exit;
    end; // METROPRO BOOKKEEPING AND TAX dasardin
    if LicenseList.Keys[AppT2.AppId] = 'T206-3448-3065-1382' then
    begin
      Result := True;
      exit;
    end; // Mobile Accounting  joe
    if LicenseList.Keys[AppT2.AppId] = 'T206-9214-8190-1409' then
    begin
      Result := True;
      exit;
    end; // ROSE SERVICES INC
    if LicenseList.Keys[AppT2.AppId] = 'T203-0459-0408-0980' then
    begin
      Result := True;
      exit;
    end; // SOUTHVIEW AUTO SPA June Burns
    if LicenseList.Keys[AppT2.AppId] = 'T206-0466-0414-1166' then
    begin
      Result := True;
      exit;
    end; // TEMPLES ACCOUNTING
    if LicenseList.Keys[AppT2.AppId] = 'T201-6880-6116-0945' then
    begin
      Result := True;
      exit;
    end; // The MatchGirl Knitting Shop, Ltd.

    if LicenseList.Keys[AppT2.AppId] = 'T201-3677-3268-1083' then
    begin
      Result := True;
      exit;
    end; // mike nicholson
    if LicenseList.Keys[AppT2.AppId] = 'T201-7702-6846-1037' then
    begin
      Result := True;
      exit;
    end; // mary leung
    if LicenseList.Keys[AppT2.AppId] = 'T206-4625-4111-1102' then
    begin
      Result := True;
      exit;
    end; // LIDIA BERESTECKI Accutype
    if LicenseList.Keys[AppT2.AppId] = 'T206-1513-1345-1112' then
    begin
      Result := True;
      exit;
    end; // leinster acct
    if LicenseList.Keys[AppT2.AppId] = 'T201-2288-2033-0761' then
    begin
      Result := True;
      exit;
    end; // joanne harte
    if LicenseList.Keys[AppT2.AppId] = 'T201-0464-0413-0623' then
    begin
      Result := True;
      exit;
    end; // olean andru
    // 20170909 Igor>>>
    if LicenseList.Keys[AppT2.AppId] = 'T201-8638-7678-1336' then
    begin
      Result := True;
      exit;
    end; // rdfosty  //20170825
    // 20170909 Igor<<<
  end;
End;

// 20170716
Procedure CreateGroupInfoLink(DataDir, flName, BusName: String);
Var
  GroupInfoDir, GroupInfoTxtFile, GroupLink: String;
  TempList: TStringList;
Begin
  TempList := TStringList.Create;
  GroupInfoDir := DataDir + '\' + 'GroupInfo';
  GroupInfoTxtFile := 'GroupInfo.txt'; // contains all available groups
  if SysUtils.DirectoryExists(GroupInfoDir) = False then
  Begin
    If SysUtils.ForceDirectories(GroupInfoDir) = False then
    Begin
      ShowMessage('GroupInfo sub folder ' + GroupInfoDir +
        ' cannot be created');
      exit;
    end;

    if FileExists(GroupInfoTxtFile) = False then
    Begin
      TempList.Add(''); // empty file
      TempList.SaveToFile(GroupInfoDir + '\' + GroupInfoTxtFile);
    End;
  End;

  TempList.clear;
  TempList.LoadFromFile(GroupInfoDir + '\' + GroupInfoTxtFile);
  GroupLink := flName + '-' + LeftStr(BusName, 40); // 20170725
  If IsStringInList(GroupLink, TempList) < 0 then
  Begin
    TempList.Add(GroupLink);
    TempList.SaveToFile(GroupInfoDir + '\' + GroupInfoTxtFile);
  End;
  TempList.Free;
End;

(*
  //20170716
  Procedure CreateGroupInfoLink(DataDir,FlName,BusName:String);
  Var GroupInfoDir,GroupInfoTxtFile,GroupLink:String; TempList:TStringList;
  Begin
  TempList := TStringList.Create;
  GroupInfoDir:=DataDir+'\'+'GroupInfo';
  GroupInfoTxtFile:='GroupInfo.txt';  //contains all available groups
  if SysUtils.DirectoryExists(GroupInfoDir) = false then
  Begin
  If SysUtils.ForceDirectories(GroupInfoDir) = false then
  Begin
  ShowMessage('GroupInfo sub folder '+ GroupInfoDir + ' cannot be created');
  Exit;
  end;

  if FileExists(GroupInfoTxtFile)=False then
  Begin
  Templist.Add('');
  TempList.SaveToFile(GroupInfoDir+'\'+GroupInfoTxtFile);
  End;
  End;

  TempList.clear;
  TempList.LoadFromFile(GroupInfoDir+'\'+GroupInfoTxtFile);
  GroupLink:=FlName+'-GRP-'+LeftStr(BusName,40);
  If IsStringInList(GroupLink,TempList)<0 then
  Begin
  Templist.Add(GroupLink);
  TempList.SaveToFile(GroupInfoDir+'\'+GroupInfoTxtFile);
  End;
  TempList.Free;
  End;
*)

// 20170725
Procedure ApplyGroupInfoToMember(RetNo: integer; TemplateReturnName: String);
// i.e. copy S9 etc from the original templte file
Var
  FromFlName: String;
  i, j, jj, k, FromRetNo, FNo, FromFNo, CurrentBnNdx, CurrentCapDedNdx: integer;
  CurrentBn: String;

Begin
  // Get the From RetNo of the GroupInfo template
  k := pos('-', TemplateReturnName);
  if k > 0 then
    FromFlName := LeftStr(TemplateReturnName, k - 1)
  else
    exit;

  FromRetNo := GetRetNoByFileName(FromFlName);
  FromFNo := GetFormNo('GROUPINFO');

  If FromRetNo = 0 then
  begin
    FromRetNo := OpenReturn(OptRec.Dir_Cur, FromFlName, True);
    if FromRetNo = 0 then
    Begin
      ShowMessage('The template return ' + FromFlName +
        ' cannot be found/opened');
      exit;
    End;
    // ShowMessage('You must first open the template return '+FromFlName);
    // Exit;
  end;

  // Find the row that has the CurrentBN in GroupInfo of the Base return
  CurrentBn := GetCorpBusNo(RetNo); // 20170726
  CurrentBnNdx := 0;
  With Ret[FromRetNo].Frm[FromFNo] do
  Begin
    j := 4; // GroupInfo pointer in FromRetNo
    Repeat
      If FetchElmFNo(FromRetNo, FromFNo, j + 2) = CurrentBn then
      // the current BN
      begin
        CurrentBnNdx := j;
        Break;
        exit;
      end;
      Inc(j, 9);
    until j > 175;
  end;
  if CurrentBnNdx = 0 then
    ShowMessage
      ('The Current Business Number was not found in the Group Template');

  // --------------------------------------------
  FNo := GetFormNo('S9');
  // copy into S9 all except the current BN
  With Ret[RetNo].Frm[FNo] do
  Begin
    i := 4; // pointer to s9
    j := 4; // Pointer to GroupInfo form
    Repeat
      if j <> CurrentBnNdx then // alray put on the first row
      Begin
        for k := 0 to 8 do
          StoreElm(RetNo, FNo, i + k, FetchElmFNo(FromRetNo, FromFNo, j + k));
        Inc(i, 9);
      End;
      Inc(j, 9);
    until j > 175;
  end;
  // -----------------------------------------------
  FNo := GetFormNo('S23');
  // Find the row that has the CurrentBN in GroupInfo of the Base return
  With Ret[FromRetNo].Frm[FromFNo] do
  Begin
    j := 189; // GroupInfo pointer in FromRetNo
    Repeat
      If FetchElmFNo(FromRetNo, FromFNo, j + 1) = CurrentBn then
      // the current BN
      begin
        CurrentBnNdx := j;
        Break;
        exit;
      end;
      Inc(j, 6);
    until j > 297;
  end;
  // copy the CurrentBn data to the first row
  i := 5;
  for k := 0 to 5 do
    StoreElm(RetNo, FNo, i + k, FetchElmFNo(FromRetNo, FromFNo,
      CurrentBnNdx + k));
  // copy the rest
  With Ret[RetNo].Frm[FNo] do
  Begin
    i := 11; // current retno
    j := 189; // groupinfo from from retno
    Repeat
      if j <> CurrentBnNdx then // alray put on the first row
      Begin
        for k := 0 to 5 do
        Begin
          StoreElm(RetNo, FNo, i + k, FetchElmFNo(FromRetNo, FromFNo, j + k));
        End;
        Inc(i, 6);
      End;
      Inc(j, 6);
    until j > 297;
  end;

  // populate 49
  FNo := GetFormNo('S49');
  // Find the row that has the CurrentBN in GroupInfo of the Base return
  With Ret[FromRetNo].Frm[FromFNo] do
  Begin
    j := 372; // GroupInfo pointer in FromRetNo
    Repeat
      If FetchElmFNo(FromRetNo, FromFNo, j + 1) = CurrentBn then
      // the current BN
      begin
        CurrentBnNdx := j;
        Break;
        exit;
      end;
      Inc(j, 5);
    until j > 467;
  end;
  // copy current to top
  // copy the CurrentBn data to the first row
  i := 5;
  for k := 0 to 5 do
    StoreElm(RetNo, FNo, i + k, FetchElmFNo(FromRetNo, FromFNo,
      CurrentBnNdx + k));
  // Copy the rest starting from second row
  With Ret[RetNo].Frm[FNo] do
  Begin
    i := 11; // current retno
    j := 372; // groupinfo from from retno
    Repeat
      if j <> CurrentBnNdx then // alray put on the first row
      Begin
        for k := 0 to 4 do
          StoreElm(RetNo, FNo, i + k, FetchElmFNo(FromRetNo, FromFNo, j + k));
        Inc(i, 6);
      End;
      Inc(j, 5);
    until i > 119;
  end;

  // populate 39
  FNo := GetFormNo('S39');
  // Find the row that has the CurrentBN in GroupInfo of the Base return
  With Ret[FromRetNo].Frm[FromFNo] do
  Begin
    j := 372; // GroupInfo pointer in FromRetNo
    jj := 311;
    Repeat
      If FetchElmFNo(FromRetNo, FromFNo, j + 1) = CurrentBn then
      // the current BN
      begin
        CurrentBnNdx := j;
        CurrentCapDedNdx := jj;
        Break;
        exit;
      end;
      Inc(j, 5);
      Inc(jj, 1);
    until j > 467;
  end;
  // copy the CurrentBn data to the first row
  StoreElm(RetNo, FNo, 4, FetchElmFNo(FromRetNo, FromFNo, CurrentBnNdx));
  StoreElm(RetNo, FNo, 5, FetchElmFNo(FromRetNo, FromFNo, CurrentBnNdx + 1));
  StoreElm(RetNo, FNo, 7, FetchElmFNo(FromRetNo, FromFNo, CurrentCapDedNdx));

  // copy the rest
  With Ret[RetNo].Frm[FNo] do
  Begin
    i := 8; // current retno
    j := 372; // groupinfo from from retno
    jj := 311;
    Repeat
      if j <> CurrentBnNdx then // alray put on the first row
      Begin
        StoreElm(RetNo, FNo, i, FetchElmFNo(FromRetNo, FromFNo, j));
        StoreElm(RetNo, FNo, i + 1, FetchElmFNo(FromRetNo, FromFNo, j + 1));
        StoreElm(RetNo, FNo, i + 3, FetchElmFNo(FromRetNo, FromFNo, jj));
        // cap deduction
        Inc(i, 4);
      End;
      Inc(j, 5);
      Inc(jj, 1);
    until i > 92;
  end;

  OpenForm(RetNo, GetFormNo('S23'), 0);
  OpenForm(RetNo, GetFormNo('S39'), 0);
  OpenForm(RetNo, GetFormNo('S49'), 0);

End;

// 20170716
Procedure ShowGroupTemplate(TemplateName: String);
var
  i: integer;
  flName: String;
  RetRec: RetPtr;
  RNo: integer;
begin
  flName := LeftStr(TemplateName, 12); // get file name from template name
  OpenForeignForm(OptRec.Dir_Cur, flName, 'GROUPINFO');
End;

// 20170716
Procedure CopyGroupTemplate(FromRetNo: integer);
Var
  i, j, k, Numb, GroupInfoFNo: integer;
  flName, YrEnd: String;
  FrmData: TFormData;
  RetNo: integer;
Begin
  // It needs to be done fron the original return that contains the template
  RetNo := 0;
  Numb := MyStrToInt(InputBox('Input the number shown on the list',
    '1 to 20', ''));
  if (Numb > 20) or (Numb < 1) then
    exit;
  YrEnd := MidStr(GetTaxationYearEnd(FromRetNo), 3, 2);
  GroupInfoFNo := GetFormNo('GROUPINFO');
  // j:=1;
  k := 1; // first corporation listed
  i := 4;
  Repeat
    if k = Numb then
    Begin
      flName := LeftStr(FetchElm(FromRetNo, 'GROUPINFO', i + 2), 9) +
        '.' + YrEnd;
      FrmData := OpenForeignForm(OptRec.Dir_Cur, flName, 'GROUPINFO');
      if FrmData <> Nil then
      Begin
        RetNo := FrmData.RetNo;
        for j := 4 to 474 do
          StoreElm(RetNo, GroupInfoFNo, j, FetchElmFNo(FromRetNo,
            GroupInfoFNo, j));
      End;
    end;
    Inc(i, 9);
    Inc(k, 1);
  Until i > 175;
  if RetNo > 0 then
    OpenForm(RetNo, GroupInfoFNo, 0);
  ApplyFromTheGroupTemplate(RetNo);
End;

// 20170716
Procedure ApplyFromTheGroupTemplate(RetNo: integer);
Var
  i, j, k, FNo, GroupInfoFNo: integer;
  // This routines takes data from the GROUPINFO and Copies it into S9, S23, S39 and S49
Begin
  GroupInfoFNo := GetFormNo('GROUPINFO');
  if FetchElmFNo(RetNo, GroupInfoFNo, 4) = '' then
  Begin
    ShowMessage('There are no group data to apply to S9, etc)');
    exit;
  End;

  // populate S9
  FNo := GetFormNo('S9');
  With Ret[RetNo].Frm[FNo] do
  Begin
    i := 4;
    j := 4; // destination such as s9
    Repeat
      for k := 0 to 8 do
        StoreElm(RetNo, FNo, j + k, FetchElmFNo(RetNo, GroupInfoFNo, i + k));
      Inc(i, 9);
      Inc(j, 9);
    until i > 175;
  end;

  (* FromFNo:=GetFormNo('S23');
    i:=189;  //current form
    j:=5;  //FromFNo
    Repeat
    for k:=0 to 5 do
    Begin
    Strings[i+k]:=FetchElmFNo(RetNo,FromFNo,j+k);
    Tv[i+k]:=Vl(FetchElmFNo(RetNo,FromFNo,j+k));
    end;

    Inc(i,6);
    Inc(j,6);
    until i>303;

    FromFNo:=GetFormNo('S49');
    i:=372;  //current form
    j:=5;  //FromFNo
    Repeat
    for k:=0 to 5 do
    Begin
    Strings[i+k]:=FetchElmFNo(RetNo,FromFNo,j+k);
    Tv[i+k]:=Vl(FetchElmFNo(RetNo,FromFNo,j+k));
    end;
    Inc(i,5);
    Inc(j,6);  //it looks 5 but it is 6
    until i>467;

    FromFNo:=GetFormNo('S39');
    i:=311;  //current form
    j:=7;  //FromFNo
    Repeat
    Tv[i]:=Vl(FetchElmFNo(RetNo,FromFNo,j));
    Inc(i,1);
    Inc(j,4);
    until i>330;

    //now copy the s9 to the top listing
    Strings[481]:=GetCorpName(RetNo);
    Strings[482]:=GetCorpBusNo(RetNo);
    Strings[483]:=GetTaxationYearStart(RetNo);
    Strings[484]:=GetTaxationYearEnd(RetNo);
    // Strings[485]:=Ret[RetNo].CorpType;
    //from same page S9 section
    i:=486;
    j:=4;
    Repeat
    for k:=0 to 4 do
    Begin
    Strings[i+k]:=FetchElmFNo(RetNo,FromFNo,j+k);
    //Tv[i+k]:=Vl(FetchElmFNo(RetNo,FromFNo,j+k));
    end;
    Inc(i,5);
    Inc(j,9);
    Until i>576;
  *)
End;

Function GetRetNoByFileName(flName: String): integer;
Var
  i, RNo: integer;
begin
  Result := 0;
  for i := 1 to (RetList.Count - 1) do
  begin
    RetRec := RetList.Items[i];
    if RetRec = nil then
      continue;
    RNo := RetRec.RetNo;
    If UpperCase(flName) = UpperCase(Ret[RNo].SourceFlName) then
    begin
      Result := RNo;
      exit;
    End;
  end;
end;

// 20170730
Function IsClass141Claimed(RetNo: integer): Boolean;
Var
  i: integer;
begin
  Result := False;
  i := 6;
  Repeat
    if FetchElm(RetNo, 'S8#1', i) = '14.1' then
    begin
      Result := True;
      exit;
    End;
    Inc(i, 16);
  Until i > 198;
end;

// 20171201
Function GetRefundableTaxCreditsAllProvinces(RetNo: integer): Real;
Var
  S5FNo: integer;
Begin
  S5FNo := GetFormNo('S5');
  Result := 0;
  Result := Result + VL(FetchElm(RetNo, S5FNo, 456)); // NL
  // result := Result + Vl(FetchElm(RetNo,S5FNo,421));  //PE
  Result := Result + VL(FetchElm(RetNo, S5FNo, 551)); // ns
  Result := Result + VL(FetchElm(RetNo, S5FNo, 501)); // nb
  Result := Result + VL(FetchElm(RetNo, S5FNo, 642)); // on
  Result := Result + VL(FetchElm(RetNo, S5FNo, 751)); // mb
  Result := Result + VL(FetchElm(RetNo, S5FNo, 736)); // sk
  Result := Result + VL(FetchElm(RetNo, S5FNo, 839)); // bc
  // result := Result + Vl(FetchElm(RetNo,S5FNo,819));  //yt non ref
  // result := Result + Vl(FetchElm(RetNo,S5FNo,933));  //nt non ref
  Result := Result + VL(FetchElm(RetNo, S5FNo, 910)); // nu
End;

Function GetLn780(RetNo: integer): Real; // 20231016
Var S31FNo:Integer;
Begin
   S31Fno:=GetFormNo('S31');
   Result := VL(FetchElmFNo(RetNo, S31FNo, 271))  //part 7
            +VL(FetchElmFNo(RetNo, S31FNo, 615)) //20231016  //part 14
            +VL(FetchElmFNo(RetNo, S31FNo, 624)); //20231016 //part 15

   //20250610
   Result:=Result+VL(FetchElmFNo(RetNo, S31FNo, 7));
                 //+VL(FetchElmFNo(RetNo, S31FNo, 257));
   End;

// 20180118
Function ValidatePhone(Phone: String): Boolean;
// expected (999)999-9999  or (999)999-9999x9999
var
  i, j: integer;
  s: String;
Begin
  Result := True;
  if Phone = '' then
    exit;
  If (Length(Phone) < 10) or (Length(Phone) > 20) then
  begin
    Result := False;
    exit;
  End;
  if pos(Phone, ' ') > 0 then
  begin
    Result := False;
    exit;
  End; // no space
End;

function GetAiipHelp: Boolean; // 20190311
var
  h: THandle;
  url: String;
begin
  url := 'https://www.canada.ca/en/revenue-agency/services/tax/businesses/topics/sole-proprietorships-partnerships/'
    + 'report-business-income-expenses/claiming-capital-cost-allowance/accelerated-investment-incentive.html?utm_campaign=not-applicable&utm_medium=vanity-url&utm_source=canada-ca_taxes-accelerated-investment-income';
  Result := True;
  Screen.Cursor := crHourGlass;
  h := ShellExecute(Application.MainForm.Handle, 'open', PChar('' + url), nil,
    nil, Sw_Show);
  Screen.Cursor := crDefault;
  if h <= 32 then
  begin
    ShowMessage('Connection failed');
    Result := False;
  end;
end;

(*
  Function ValidatePhone(Phone:String):Boolean;
  //expected (999)999-9999  or (999)999-9999x9999
  const AList: array of string=('0','1','2','3','4','5','6','7','8', '9', 'x', 'X', '(', ')');
  var i,j:Integer;s:String;
  Begin
  Result:=True;
  if Phone='' then exit;
  If (Length(Phone)<10) or (Length(Phone)>20) then begin Result:=False;Exit; End;
  if Pos(Phone,' ')>0 then begin Result:=False;Exit; End; //no space
  for i:=1 to Length(Phone) Do
  Begin
  s:=MidStr(Phone,i,1);
  for j:= low(AList) to high(AList) do
  begin
  If SameText(S,Alist[j]) then //case insensitive test
  //ok
  Else
  begin Result:=False;Exit; End;
  end;
  End;
*)
// Original prior to AIIP
procedure CalcPreAiipCCA(cls: string; UccStart: Real; Additions: Real;
  Adjustments: Real; Proceeds: Real; var UCC: Real; var HalfRuleAmount: Real;
  var UCCReduced: Real; OverrideIndic: string; HalfYearIndic: string;
  TermLossIndic: string; Rate: string; var Recapture: Real;
  var TerminalLoss: Real; var CCA: Real; var UccEnd: Real;
  DaysinTaxYear: integer);

begin
  if cls = '' then
  begin
    UCC := 0;
    HalfRuleAmount := 0;
    UCCReduced := 0;
    Recapture := 0;
    TerminalLoss := 0;
    CCA := 0;
    UccEnd := 0;
    exit;
  end;
  if DaysinTaxYear > 365 then
    DaysinTaxYear := 365;
  UCC := UccStart + Additions + Adjustments - Proceeds;
  if UpperCase(HalfYearIndic) = 'Y' then
  /// /20190605
  begin
    if UpperCase(OverrideIndic) <> 'Y' then // 20190605
    begin
      HalfRuleAmount := MaxR(0, 0.5 * (Additions - Proceeds));
      HalfRuleAmount := RoundCorrect(HalfRuleAmount);
    end;
  end
  else
    HalfRuleAmount := 0;

  UCCReduced := UCC - HalfRuleAmount;

  if UpperCase(OverrideIndic) = 'Y' then // 20190605
    exit;

  if UpperCase(TermLossIndic) = 'Y' then // 20190605
  begin
    CCA := 0;
    Recapture := 0;
    TerminalLoss := MaxR(0, UCCReduced);
    UccEnd := 0;
  end
  else
  begin
    CCA := RoundCorrect(((UCCReduced * VL(Rate)) / 100) * (DaysinTaxYear / 365)
      ); // 20190607

    if (Leasehold(cls)) and (OverrideIndic <> 'Y') and (CCA = 0) then
    // 20190605 //20190806
      // if (Cls = '13') and (OverrideIndic <> 'Y') and (CCA = 0) then   //20190605
      CCA := Round(UCCReduced * 0.20 * DaysinTaxYear / 365);
    TerminalLoss := 0;
    Recapture := 0;
    UccEnd := MaxR(0, UCC - CCA);
  end;

  if UCCReduced < 0 then
  begin
    CCA := 0;
    TerminalLoss := 0;
    Recapture := ABS(UCCReduced);
    UccEnd := 0;
    if cls = '10.1' then
    begin
      CCA := ABS(UCCReduced);
      Recapture := 0;
    end;
  end;

  if (cls = '10.1') and (Proceeds > 0) then
  begin
    CCA := Round((UccStart + Adjustments) / 2 * VL(Rate) / 100);
    UCC := 0;
    UCCReduced := 0;
    TerminalLoss := 0;
    Recapture := 0;
    UccEnd := 0;
  end;
end;

function GetFormType(FName: string): string;
begin
  Result := FList.ByFormName(FName).FormType;
end;

// 20190626
function GetReducedBusinessLimit(RetNo: integer): Real;
begin
  if GetBegYearEnd(RetNo) > '2018/12/31' then
    Result := Ret[RetNo].Ln[428]
  Else
    Result := Ret[RetNo].Ln[427];

end;

// 20190806
Function Leasehold(cls: String): Boolean;
Begin
  Result := False;
  if (cls = '13') or (cls = '14') then
    Result := True;
End;

Function FixBusinessNumberMissingRC(BN: String): String; // 20190820
Var
  i: integer;
Begin
  Result := BN;
  if (BN = '') then
    exit;
  if (Length(BN) = 13) and (RightStr(BN, 4) = '0001') then
  // s/b 15 threfore assume it is missing RC
  Begin
    Result := LeftStr(BN, 9) + 'RC' + RightStr(BN, 4)
  End;
End;

Function GetSignatureFilePath(RetNo: integer): String; // 20200320
Var
  Folder, FullName: String;
Begin
  Result := '';
  Folder := OptRec.Dir_ClientDocs + '\' + MkDirforClientDocs(RetNo);
  // MkDirforClientDocs(RetNo)+'\'+GetCorpName(retNo); //OptRec.Dir_ClientDocs+'\'+GetCorpName(retNo); //20200325
  // check both jpg and png
  FullName := Folder + '\' + 'Signature.jpg';
  if FileExists(FullName) then
  begin
    Result := FullName;
    exit;
  end
  else
  Begin
    FullName := Folder + '\' + 'Signature.bmp';
    if FileExists(FullName) then
    begin
      Result := FullName;
      exit;
    end
    else
    begin
      FullName := Folder + '\' + 'Signature.png';
      if FileExists(FullName) then
      begin
        Result := FullName;
        exit;
      end
      else
      begin
        FullName := Folder + '\' + 'Signature.GIF';
        if FileExists(FullName) then
        begin
          Result := FullName;
          exit;
        end;
      end;
    end;
  end;
End;

// 20200502
Procedure SendEmail(RetNo: integer; SomeSubject, SomeRecipientEMail,
  SomeSenderEMail, SomeAttachment, SomeText: String);
// SomeSubject, SomeRecipientEMail, SomeSenderEMail, SomeAttachment: String;
// SomeText: String;
begin
  ShellExecute(Application.MainForm.Handle, nil,
    PChar('' + 'mailto:' + SomeRecipientEMail + '?Subject=' + SomeSubject +
    '&Body=' + SomeText), nil, nil, SW_NORMAL);
  // MainForm.SendMapiMail(SomeSubject,SomeText,SomeAttachment,'','','',SomeRecipientEMail);
end;

Procedure SortTaxForms(FormsToPrint, PrintSeqList, SortedList: TStringList);
// 20200506
// Sequence list has all forms in proper sequence
// ListforSorting is a list of some forms to be sorted
Var
  i, k: integer;
  FrmName, seq: String;
  TempSortList: TStringList;
Begin
  TempSortList := TStringList.Create;
  TempSortList.Sorted := True;

  for i := 0 to FormsToPrint.Count - 1 do
  Begin
    FrmName := FormsToPrint[i];
    k := IsInList(ExtractNonInstFormName(FrmName), PrintSeqList);
    If k >= 0 then
    Begin
      seq := MidStr(PrintSeqList[k], 16, 3);
      TempSortList.Add(seq + FrmName)
    End;
  end;
  for i := 0 to TempSortList.Count - 1 do
  Begin
    SortedList.Add(MidStr(TempSortList[i], 4, 15));
  end;
  TempSortList.Free;
End;

Function AddNextInstance(RetNo: integer; FormName: String): integer;
Var
  NewFNo: integer;
  CInst: integer;
  NewFormName: String;
Begin
  NewFNo := RetList[RetNo].GetFormNo(FormName); // //GetFormNo(RetNo,FormName);
  CInst := ExtractFormInstNo(FormName);
  NewFormName := ExtractNonInstFormName(FormName) + '#' + IntTostr(CInst + 1);
  NewFNo := RetList[RetNo].GetFormNo(NewFormName);
  // GetFormNo(RetNo, NewFormName);
  if NewFNo > 0 then // exists
    // do nothing
  Else
    NewFNo := RetList[RetNo].AddPageInstance(ExtractNonInstFormName(FormName),
      '#' + IntTostr(CInst + 1));

  Result := NewFNo;
End;

Procedure OpenT1ClientBook; // 20200919
Var
  T1App: TApp;
Begin
  T1App := AppList.AppFromName('T1');
  if not Assigned(T1App) then
  begin
    ShowMessage('T1 App was not found');
    exit;
  end
  Else
    AppList.T1App.OpenClientBook;
End;

Function CreateT1return(Sin: String): integer; // 20200919
var
  T1RetNo: integer;
  FApp: TApp;
begin
  Result := 0;
  FApp := AppList.T1App;
  if not Assigned(FApp) then
  begin
    ShowMessage('T1 App was not found');
    exit;
  end;

  T1RetNo := FApp.InitNewReturn;
  // StoreElm(T1RetNo, 'INFO', 2, 'Unknown First');
  // StoreElm(T1RetNo, 'INFO', 5, 'Unknown Last Name');
  StoreElm(T1RetNo, 'INFO', 3, Sin);
  StoreElm(T1RetNo, 'INFO', 9, '1980-01-01');
  RetList[T1RetNo].RecalcEverything;
  // RetList[NewRetNo].CountDiagnostics;
  FApp.SaveReturn(T1RetNo, FApp.Dir_Cur, '-{' + LeftStr(Sin, 8) + '.' +
    RightStr(Sin, 1) + '}', True, True); // 20200919
  // FApp.SaveReturn(T1RetNo, FApp.Dir_Cur, RetList[T1RetNo].GetDefaultFileName, true, true);
  Result := T1RetNo;
end;

// 20210722
Procedure GetListOfS60Projects(RetNo: integer; AList: TStrings);
Var
  i: integer;
  SlipId: String;
Begin
  AList.clear;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If Ret[RetNo].FrmHasData[FRec.FormNo] then
    begin
      if FRec.FormName = 'S60' then
      begin
        If Ret[RetNo].FrmHasData[FRec.FormNo] then
          AList.Add(PaddR(LeftStr(FetchElmFNo(RetNo, FRec.FormNo, 4), 40), 40) +
            '_' + FetchElmFNo(RetNo, FRec.FormNo, 7)); // name and code
      end
    end;
  end;
end;

Function IsMultJurisdiction(RetNo: integer): Boolean; // 20220611
Begin
  Result := False;
  if UpperCase(FetchElmFNo(RetNo, T2FNo, 2)) = 'MULTIPLE' then
    Result := True;
End;

function CalcCheckDigitForT7DROCR(ALine: string): string; // 20210614
var
  cLine1, cLine2, cLine3, cLine4: string;
  nTotalSum: integer;

  function SumLine(ASumLine: string; AStartWeight: integer): integer;
  var
    i, nSum, weight: integer;
  begin
    Result := 0;
    weight := AStartWeight;
    for i := Low(ASumLine) to High(ASumLine) do
    begin
      nSum := StrToInt(ASumLine[i]) * weight;
      if nSum >= 10 then
        nSum := nSum div 10 + nSum mod 10;
      Result := Result + nSum;
      if weight = 2 then
        weight := 1
      else
        weight := 2;
    end;
  end;

begin
  Result := '';
  cLine1 := Copy(ALine, 1, 16);
  cLine2 := Copy(ALine, 17, 15);
  cLine3 := Copy(ALine, 32, 18);
  cLine4 := Copy(ALine, 50, 6);
  nTotalSum := SumLine(cLine1, 2) + SumLine(cLine2, 2) + SumLine(cLine3, 1) +
    SumLine(cLine4, 1);
  Result := IntTostr(10 - nTotalSum mod 10);
end;

Function DIEPClass(CCAClass: String): Boolean; // 20221015
var
  cls: Real;
Begin
  cls := VL(CCAClass);
  Result := True;

  if (cls >= 1) and (cls <= 6) or (cls = 14.1) or (cls = 17) or (cls = 47) or
    (cls = 49) or (cls = 51) then
    Result := False;
end;

Procedure SetAddOnStatus;  //20231031
Begin
If FileExists(Appdir+'\'+t2enterpriseflname) then
 AddOnEnabled:=True
else
 AddOnEnabled:=False;
end;

Function IsSubstantiveCCPC(RetNo:Integer):Boolean; //20240707
Begin
 Result:=False;
 if FetchElmFNo(RetNo,T2FNo,265)>'' then  Result:=True;
End;

(*
//20250611
Function IsEnterPriseForm(Fname:String):Boolean; //20240707
Begin
 Result:=False;
 If (Uppercase(Fname)='S76')
 or (Uppercase(LeftStr(Fname,4))='S78#')
 or (Uppercase(Fname)='S150')
 or (Uppercase(Fname)='S151')
 or (Uppercase(Fname)='T2184')
 or (Uppercase(Fname)='S130')
 Or (UpperCase(LeftStr(Fname,6))='SALDIV')
 Or (UpperCase(LeftStr(Fname,6))='SBDALLOC')
 then result:=True;
End;
*)

Function IsABStep1(RetNo:Integer):Boolean; //20240707
Begin
 Result:=False;
 If FetchElm(RetNo,'AS29', 146)>''
 then result:=True;
End;

Function IsABStep2(RetNo:Integer):Boolean; //20240707
Begin
 Result:=False;
 If FetcheLM(RetNo,'AS29', 147)>''
 then result:=True;
End;

//20260620
Function IsABStep3(RetNo:Integer):Boolean; //20240620
Begin
 Result:=False;
 If FetcheLM(RetNo,'AS29', 248)>''
 then result:=True;
End;


Function IsEnterpriseForm(Fname:string):Boolean; //20251114
Begin
 //20260819CZ
 if IsEnterpriseVersion then
 begin
  Result:=True;
  Exit;
 end;

 Result:=False;
 If (GetFormType(FName)='EL')  // special Election form
 Or (upperCase(Fname)='S150')
 or (upperCase(Fname)='S151')
 or (Uppercase(Fname)='S76')
 or (Uppercase(LeftStr(Fname,4))='S78#')
 or (Uppercase(Fname)='T2184')
 or (Uppercase(Fname)='S130')
 or (upperCase(Fname)='SALDIV')
 or (upperCase(Fname)='SBDALLOC')
 or (upperCase(Fname)='T1134')
 or (upperCase(Fname)='T106')

 then result:=True;
End;

//20260630

Function S8NeedsConversion(RetNo:Integer):Boolean; //20260530
Begin
 Result:=false;
 if FetchElm(RetNo,'S8',227)='S8RevisionDate' then result:=True;
end;

//20260718
Function ExemptClassesForFirstYearRule(aclass:String):Boolean;
Begin
 Result:=False;
 If (aclass='13')
 Or (aclass='14')
 Or (aclass='23')
 Or (aclass='24')
 Or (aclass='27')
 Or (aclass='29')
 Or (aclass='34')
 Or (aclass='52')
 Or (aclass='12')
 then result:=True;
End;

end.
