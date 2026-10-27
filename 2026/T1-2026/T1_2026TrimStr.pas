unit T1_2026TrimStr;
// updated 07-23

{$B-}

interface

uses
  SysUtils, {FileCtrl,} WinTypes, Messages, Classes, Graphics, // 20171031 igor
  // windows,WinProcs,
  Controls, Forms, StdCtrls, Dialogs, DBctrls, ExtCtrls, Printers, DB,
  ShellApi, MAPI, ComCtrls, ComObj, WinSpool, // 20150727 NMHttp,
  vtEditBox, vtLabel, vtShape, EkRtf,
  ekbasereport, ekfunc, RichEdit, Wininet, Activex, ShlObj, vtMulti,
  T1_2026Declare,
  uADCompClient, // 20150916 Igor
  vtFileStorage, // 20160820 Igor

  System.Generics.Collections, // 20190709 Igor
  IOUtils, // 20170331
  vtPDFPrinter,
  vtDynData, // 20230801
  RxRichEd, // 20160819 Igor (It must be the last)
  Math; // 20210119

type
  TwwDbRichEdit = TRichEdit; // else update many units containing TwwDbRichEdit

  // 20220510 Igor <<<
  // copied from T2-2024 //20230801 Con
type
  TGroupItemAccountType = (atIndividual, atCorporation, atTrust, atPartnership);

type
  T1134GroupItem = record
    AccountNumber: string;
    Name: string;
    AccountType: TGroupItemAccountType;
  end;


//jz//20260406//CCAv2

Function IsEnterpriseForm(Fname:string):Boolean; //20251114
Function IsSection2161(RetNo: integer): Boolean; //20260506
Function GetTotalT776IncomeBeforeCCA(RetNo:Integer):Real;  //20260419
Function GetTotalT776CCAClaimed(RetNo:Integer):Real;
procedure autosAssetsCCA(RetNo,FNo:integer;var CCAformData: TFormData);
function GetAiipFactor(cls:string):string;
function GetRiipFactor(cls:string):string;
Function IsDeemed183(RetNo:Integer):boolean; //20260313
Function IsDeemedOther(RetNo:Integer):boolean; //20260313

Function ifAmendedPopulateInitialRevNum(RetNo:integer;amendedIndicatorVal,revisionIndicatorVal:string):string;
procedure setTestingElementsVisibility(testPanal:TPanel); //jz//20260402

Function HaveEligibleDependant(RetNo: integer):Boolean;
Function GetEligibleDependantNetIncome(RetNo: integer): Real;
Function ValidForT106Efile(RetNo: integer; FNo: integer): Boolean;
function TotMultipleExludingDeletedSlips(RetNo: integer;
  NonInstFormName: string; Elm: integer; dElm: integer;
  deleteString: string): Real;

function calcLNN10100(RetNo: integer): Real; //jz//20260202
function GetLine51200FromRc269(RetNo: integer): Real; // 20250306
function GetLine51201FromRc269(RetNo: integer): Real; // 20260203

function selectNetIncomeAmount(RetNo: integer): Real; // 20250221
function selectTaxableIncomeAmount(RetNo: integer): Real; // 20250223
Function PlacementOfficeSlip(RetNo: integer): Boolean; // 20250220
Function GetEfileDname(RetNo: integer): String; // 20250130
Function GetCppScheduleName(RetNo: integer): String; // 20250130
function GetFormType(FName: string): string; // 20260109
Function GetBox16AFromT4Slips(RetNo: integer): Real; // 20241121
Function GetBox17AFromT4Slips(RetNo: integer): Real; // 20250225 cz
Function GetBox17FromT4Slips(RetNo: integer): Real; // 20241121
Procedure GetMaxCPPAdditionalAmounts(RetNo: integer; Months: integer;
  MaxAdditionalCPPPensionableEarnings: Real;
  MaxAdditionalCPPContributions: Real);
// Function GetCaregiverMj(RetNo:Integer; Prv:String):Real; //20240602
// Function IsResType7(RetNo:Integer); //20240515
Function ShouldZeroOutNonRefLines(RetNo: integer): Boolean; // 20240424
Procedure ZeroOutNonRefLines(RetNo: integer); // 20240424
Function GetTotalTerminalLoss(RetNo: integer; StmtId: String; StatementInst: String): Real;
Function GetTotalRecaptureAmt(RetNo: integer; StmtId: String; StatementInst: String): Real;

Function IsCanadianResident(RetNo: integer): Boolean; // 20240423
Function IsDeemedNonRes(RetNo: integer): Boolean; // 20240423
Function IsDeemedResident(RetNo: integer): Boolean; // 20240325
Function IsDeemedRes183(RetNo: integer): Boolean; // 20240423
Function IsDeemedResOther(RetNo: integer): Boolean; // 20240423
Function IsDeemedResQuebec(RetNo: integer): Boolean;  //jz//NonResCERT-R1//202404
Function IsFactualResident(RetNo: integer): Boolean; // 20240423

Function GetResidencySection(RetNo: integer): String; // 20240213
Function IsFirstTimeFiler(RetNo: integer): Boolean; // 20240209
Function GetResidencyType(RetNo: integer): String; // 20240126
Function GetResidencyStatus(RetNo: integer): String; // 20240213

function CountMultipleInstances(RetNo: integer; NonInstFormName: string)
  : integer; { No Instance } // copied from T2-2024 //20230801
// t1134 related  --------------------------
function GetT1134ForeignAffiliatesIdentificationNumber(ARetNo: integer;
  AName: string): string; // 20230510 Igor //20230601 Igor
// 20230510 Igor >>>  //copied from T202023 Con
procedure PopulateT1134ForeignAffiliates(ARetNo: integer; AList: TStringList);
// 20230619 CON from IGOR
function GetT1134ForeignAffiliatesCountryCode(ARetNo: integer; AName: string)
  : string; // 20230601 Igor

function GetT1134GroupList(ARetNo: integer): TArray<T1134GroupItem>;
procedure PopulateT1134GroupList(ARetNo: integer; AList: TStringList;
  AShowName: Boolean = true); // 20230619 Igor
procedure PopulateT1134SGroupList(ARetNo, AFormNo: integer; AList: TStringList;
  AOnlyArrayNo: integer = 0);
// t1134 related  --------------------------

// Function GetExchRate(Country:String):String;  //20230405
Function IsDiepEligible(Cls: String; PurchaseDate: String): Boolean;
Function MaxStLoan(RetNo: integer): Real;
Function GetSpouseAgeDeductionForMJ(SpRetNo: integer; RetNo, FNo: integer;
  PRV: String): Real; // 20220516
// 20220424
Procedure GetT2030ACharts(RetNo: integer; FarmFname: String; FarmFNo: integer;
  Var Totexp: Real; Var TotMInv: Real; Var TotOInv: Real; Var TotGInc: Real;
  Var TotSal: Real);

// 20220423  //20220424
Procedure GetT2030AFarmExpensesByFarm(RetNo, FormNo: integer; FarmFname: string;
  FarmFNo: integer; Var ONexp: Real; Var MBexp: Real; Var SKexp: Real;
  Var ABexp: Real; Var ONMInv: Real; Var MBMInv: Real; Var SKMInv: Real;
  Var ABMInv: Real; Var ONOInv: Real; Var MBOInv: Real; Var SKOInv: Real;
  Var ABOInv: Real; Var ONGInc: Real; Var MBGINC: Real; Var SKGInc: Real;
  Var ABGInc: Real; Var ONSal: Real; Var MBSal: Real; Var SKSal: Real;
  Var ABSal: Real);

// Function GetSpouseNetIncome(RetNo: integer): Real;      //jz//20250224 consolidate with selectSpouseNetIncomeAmount //20230418
function selectSpouseNetIncomeAmount(RetNo: integer): Real; // jz//20250224

// 20210408
Function GetNonResPercent(RetNo: integer): Real;
Function NonResWithEmpl(RetNo: integer): Boolean; // 20220407
Function ValidateUSAZipCode(S: String): Boolean; // 20220209
Function ValidateT1135Phone(S: String): Boolean; // 20220209
Procedure GetListOfT4SlipsForT777(RetNo: integer; AList: TStrings); // 20210404
Function GetEligGstRebateFromT777(RetNo: integer): Real;
// Procedure GetGst370WorkSpaceFromT777(RetNo:Integer;  //20210402
// 20210325
// Function GetT777SElectricityForGst370(RetNo: Integer): Real;
// Function GetT777SMaintenanceForGst370(RetNo: Integer): Real;

Function GetOprimumDonationClaim(RetNo: integer): Real;
Function RoundtoOneDecimal(R: Real): Real;
Function TimeToHHMMDD(DateTime: TDateTime): String;
Function GetPreparerSignatureFilePath: String; // 20200618
Function GetT5008CurrencyRate(Currency: String;
  Var ForeignCurrencyList: TStringList): Real;
Procedure GetAutofillData(RetNo: integer; AutofillGroup: String); // 20200526
Function GetT777ExpenseLine(RetNo: integer; T777FName: String; T777FNo: integer;
  Auto777Elm: integer): Real;
Function GetT777TotCCA(RetNo: integer; T777FName: String; T777FNo: integer;
  Auto777Elm: integer): Real;
Function GetT777NumOfCars(RetNo: integer; T777FName: String;
  T777FNo: integer): integer;
Function GetT777BusKm(RetNo: integer; T777FName: String;
  T777FNo: integer): integer;
Function GetT777TotKm(RetNo: integer; T777FName: String;
  T777FNo: integer): integer;
Function GetT777KmPercent(RetNo: integer; T777FName: String;
  T777FNo: integer): Real;

Procedure ExtractAuto777CCA(RetNo: integer; StmtId: String;
  StatementInst: String; Var TermLossAmount: Real; Var RecaptAmount: Real;
  Var CCAForStmt: Real; ClassOption: string);

Function IsSignatureForm(FName: String): Boolean;
// 202200511
Procedure PostAuto777CCA(RetNo: integer; FName: String; Stmt: String;
  FInst: String; FNo: integer; ClassOption: String);
{
  Procedure PostAuto777CCA(RetNo: Integer; FName: String; Stmt: String;
  FInst: String; FNo: Integer; StartNdx, EndNdx, IncrBy, EndSectionNdx,
  RemainingNdx, TotalNdx: Integer;ClassOption:String);
}
Procedure Auto777ToAuto777Multiple(RetNo: integer);
Procedure GetListOfStatementsForAuto777(RetNo: integer; AList: TStrings;
  CurrentT777: String); // 20200513

Procedure SortTaxForms(FormsToPrint, PrintSeqList, SortedList: TStringList);
function HideSin(RetNo: integer): Boolean; // 20200430
function GetHiddenSin(Sin: String): String; // 20200430
function GetHiddenRepId(RepId: String): String; // 20230216
function CopyDir(const fromDir, toDir: string): Boolean; // 20200426
// Procedure SaveFormsToPdf(RetNo:Integer;FrmList:TStringList;Dir:String;FlName:String);
Function GetT1032TransferringSin(RetNo: integer): String;
Function GetT1032ReceivingSin(RetNo: integer): String;
// reverse to pick up spouse
Function GetMaxDisabForS2MJ(SpRetNo: integer; PRV: String): Real;
Function GetSignatureFilePath(LastName: String; FirstName: String): String;
// 20200320
// Function GetSignatureFilePath(RetNo:Integer):String;//20200318
function GetSignatureFolderPath(LastName: String; FirstName: String): String;
// 20210331 Igor
Function CalcPartYear(RetNo: integer): Real;
Function EligibleForChildCareRelief(RetNo: integer): Boolean; // 20200207
Function ReadyForT1135Efile(RetNo: integer): Boolean;
Function GetPrvNonRefUpToDisability(RetNo, PrvTaxFNo: integer): Real;
Function GetSelfEmplLosses(RetNo: integer): Real; // 20191127
Function GetOn479ARate(FamIncome: Real): Real;
Function AddNextInstance(RetNo: integer; FormName: String): integer;
Procedure InitTransfForm(RetNo: integer); // 20190405
Procedure InitS14Form(RetNo: integer); // 20190405
Function GetBCSpouseCareGiver(RetNo: integer; PRV: String): Real; // 20190403
Procedure UpdateAllIndicatorsForMJ(RetNo: integer); // 20190328
Function GetSpouseAge(RetNo: integer): integer; // 20190317
Function EligibleForWIBPerCRA(RetNo: integer): Boolean; // 2019022
function EligibleSpouseForS14(RetNo: integer): Boolean;
// climate credit //20190217
function EligibleForS14(RetNo: integer): Boolean; // climate credit //20190217
function GetAiipHelp: Boolean;
Function GetT1204IncomeForT2125(RetNo: integer; T1204FInst: String): Real;
Function InitialWITBEligibility(RetNo: integer): Boolean;
Function IsForEfile(RetNo: integer): Boolean; // 20190124
Procedure GetKidsUnder6ForNs6372(RetNo: integer);
Function GetBCTaxIncrease(RetNo: integer): Real; // 20180607 txbl over 108460
Procedure CreateNaicsFile; // 20180417
Function L300ToL314(RetNo: integer): Real; // 20180319
Procedure CAREPRV(RetNo: integer; FName: string; FNo: integer); // 20180318

Function ReformatSinWithSpaceInBetween(S: string): String;
// 20180310 CON 9:54PM
function CalcCheckDigitForT7DROCR(ALine: string): string; // 20180307 Igor

Function IsEfAccepted(RetNo: integer): Boolean; // 20160120
Function IsReturnAmended(RetNo: integer): Boolean; // 20160120

Function CalcPrvCareGvrClaim(RetNo: integer; Ni: Real; PercentClaim: Real)
  : Real; // 20180120
Function GetTestCaseId(RetNo: integer; Sin: String): String; // 20171214
function AllowImportExport: Boolean; // 20171130
Function L300ToL318(RetNo: integer): Real; // 20171113
Procedure SetRefileVersion(RetNo: integer);
Function GetRefileVersion(RetNo: integer): String;
// Function GetRefileSuffix(FlName:String):String;

Function MkRefiledDir(DataDir: String): String; // 20240607
// Function MkRefiledDir:String;  //20240607
// Function MkBeforeRefileFileName(RetNo:Integer):String;
Function InitializeRefileReturn(RetNo: integer): string;
// ;RefileFolder:String): String; // 20240606
Function ValidateRefileReturn(RetNo: integer; DCN: String): String; // 20170329

Procedure GetREFILEVNetList(BeforeList, AfterList: TStringList;
  Var NetList: TStringList);
Function IsForRefile(RetNo: integer): Boolean; // 20170320
Procedure NetListToREFILEV(RetNo: integer; FNo: integer; NetList: TStringList;
  FromNetListNdx: integer);

// 20170316
Function ValidatePadPaymentDate(SignDate, PayDay: String): integer;
Function IsHoliday(Dt: String): Boolean;

Function ValidateDcn(RetNo: integer): Boolean; // 20170218
Procedure FixT929(RetNo: integer); // 20170212
Function IncludeRc381InT1cPrintedForms(RetNo: integer): Boolean; // 20170204
Function GetS9DonHigh(RetNo: integer): Real; // 20161126
Function GetS9DonLow(RetNo: integer): Real; // 20161126

Function ValidForT1135Efile(RetNo: integer; FNo: integer): Boolean; // 20150709

Function QualifiedForFamilyTaxCut(RetNo: integer): Boolean; // 20150708
Function AnyDependantUnder18(RetNo: integer): Boolean; // 20150708
Function GetPrvNonRefundableBasedOnRuleOf90(RetNo: integer;NormalPrvNonRefAmount:real): Real; // 20150412
// 20150412
Function AllowSaSB(RetNo: integer): Boolean;
function LicenseLevel: eLicenseLevel;
function LicenseName: string;
Function IsEnterpriseVersion: Boolean; // 20231211 Igor
Function IsBCJ: Boolean;
Function IsTaxTown: Boolean;
Procedure CopyMoveDateAndAddr(RetNo: integer; FrmNm: String); // 20140224

Function CreateEfileResponseHtm(RetNo: integer; AckRec: TAckRec;
  HtmFile: String): String; // 20140119  //20150716
// procedure CreateEfileResponseHtm(RetNo:Integer;AckRec:TAckRec;HtmFile:String); //20140119
Function MakeEolPFileName(LicenseLevel: eLicenseLevel): string;
Function GetEfErrorDescr(ErrorCode: String): AnsiString;
Function GetWebServiceErrorDescr(ErrorCode: String): AnsiString;
// Function GetTimeToMilliSec(Dt:tDateTime):String; //20160523 Igor Move to vtTrimStr
// Function AckReceivedTime(Dt:tDateTime):String;
Function GetPlacementOfficeIncome(RetNo: integer): Real;
Function HasBusiness(RetNo: integer): Boolean;
procedure QuickFormFind(RetNo: integer; ThisForm: String);
Function GetUniqueMinutesSeconds: String;
procedure CreateEfileXmlOnlyFile;
Function MkXmlFileName(RetNo: integer; NetFileDir: String): String;

Function Rc381InEffect(RetNo: integer): Boolean;
Function GetCPPMonthsForRC381(RetNo: integer): integer;
Function GetQPPMonthsForRC381(RetNo: integer): integer;

Function GetCPPMonths(RetNo: integer): integer;
Function GetCPPMonthsForS8(RetNo: integer): integer;
function getCPPRetirementMonths(RetNo: integer; CppMonths: integer): integer; //jz//2026 - change name, use in other places other than s8 //function getCPPRetirementMonthsForS8(RetNo: integer; CppMonths: integer): integer;

Function GetCPPQPPMonthsForRC269(RetNo: integer): integer; //jz//20260204

Function GetActualCPPPremiums(RetNo: integer): Real;
Function GetActualQPPPremiums(RetNo: integer): Real;

Function Rule90(RetNo: integer): Real; // 20240426 //boolean; // 201311201
Function Immigrant(RetNo: integer): Boolean; // 201311201
Function Emigrant(RetNo: integer): Boolean; // 201311201

// Function ImmigrantEmigrant(RetNo:Integer):Boolean; //20120711
// Function ImmigrantEmigrant(RetNo:Integer):Boolean; //20120711
Function GetEligDepBirthdate(RetNo: integer): String;
Function GetDeceasedMonth(RetNo: integer): String; // 20130220
Function GetCpt30months(RetNo: integer; Cpt30Date: String): integer; // 20130203

Function GetBirthMonth(RetNo: integer): String; // 20130220
Function GetBirthDay(RetNo: integer): String; // 20140105

Function GetLine489EfileNo(RetNo: integer): String; // 20121226

Function GetTotalTaxDeducted(RetNo: integer): Real;

Function Calc5031(RetNo: integer): Real;
procedure GetFilenames(Path: string; Dest: TStringList);
Procedure MergeWordFilesIntoPdf;

Function CalcLn439(RetNo: integer): Real; // 20121225
Function CalcLn434(RetNo: integer): Real; // 20121225
Function CalcLn5280(RetNo: integer): Real;
Function CalcLn5281(RetNo: integer): Real;
Function CalcLn5282(RetNo: integer): Real;
Function CalcLn5276(RetNo: integer): Real; // foreign bus tax #1
Function CalcLn5283(RetNo: integer): Real; // foreign bus tax #2
Function CalcLn5284(RetNo: integer): Real; // foreign bus tax #3

Function GetDateOfBirth(RetNo: integer): String;

Function OntarioInvoluntarySeparation(RetNo: integer): Boolean;

Function CalcLn433(RetNo: integer): Real;
Function CalcLn431(RetNo: integer): Real;
Function CalcLn5273(RetNo: integer): Real;
Function CalcLn5274(RetNo: integer): Real;
Function CalcLn5275(RetNo: integer): Real;
Function CalcLn5277(RetNo: integer): Real; // foreign tax
Function CalcLn5278(RetNo: integer): Real; // foreign tax
Function CalcLn5279(RetNo: integer): Real; // foreign tax

Function ValidPhone(S: String): Boolean;
Function isCanadianProvince(PRV: String): Boolean;
Procedure RotateImage(SrcFile: string; CCW: integer);

// Function ReplaceReservedXMLCharacters(S:String):String; //20160523 Igor Move to vtTrimStr
Function GetPhotoIdFlName(RetNo: integer): String; // 20120131

Function GetMonthsForPensionSplit(RetNo1, RetNo2: integer): integer; // 20120129
Function GetMonthsMarried(RetNo1, RetNo2: integer): integer; // 20120129

Function HasVtScanLicense: Boolean;
Procedure ShowClientPhotoId(FlName: String);
Function isT1273NoDecimalSection(FName: String; elm: integer): Boolean;
Function FormatNoDecimals(S: String; How: integer): string; // 20120123
// Function NoDecimal(x:Real):String;
// Function NoDecimalFormatAmount(s: string): string;

Function GetValueFromDataFile(FileName: String; FName: String;
  elm: integer): String;
Function GetRetFileNameViaDCNNO(DcnNo: String): String;
Function ChangeAckToXmlExtension(FlName: String): String; // 20120117
Function GetLine351ForEfile(RetNo: integer): Real;
Function GetLine5532ForEfile(RetNo: integer): Real; // wib income

// ----
Procedure CheckBeforeEfile(RetNo: integer);
Function ValidTaxShelterNo(Taxshelter: String): Boolean;
Function ValidPartnershipNo(S: String): Boolean;
Procedure StoreBeforeAfterOptimize(RetNo: integer);
// Email related
Procedure SendEmail(RetNo: integer; SomeSubject, SomeRecipientEMail,
  SomeSenderEMail, SomeAttachment, SomeText: String);
Procedure EMailToClient(RetNo: integer);
Function GetClientEMail(ClientFileName: String): String;
Procedure CreateEmailList(DataDir: String; ClientFiles: TStringList);
Procedure EMailAFormToClient(RetNo: integer; FormName: String);
Function ValidEMail(S: String): Boolean;
// --------------------------
Function HasDeceasedSpouse(RetNo: integer): Boolean;
// Procedure SplitGst370(RetNo:Integer); //between the 2 rates  //20111110
function GetNodeByText(ATree: TTreeView; AValue: String; AVisible: Boolean)
  : TTreeNode;
Function GetFNameFromLastYearFName(LastYrFName: String): String;
Function GetLastYearFNameFromCurrentFName(FName: String): String;
Function GetLastYearFormMxPg(FormName: string): integer;
Procedure GetFormDataFromDisk(FlName: String; FrmNm: String;
  Var FrmDataList: TStringList);
Function IsValidLastYearPgmFolder(AShowMessage: Boolean;
  out AErrorMessage: String): Boolean; // 20160516 Igor
function isValidLastYearDataFolder(AShowMessage: Boolean;
  out AErrorMessage: String): Boolean;
// 20160302 Igor //20160311 Igor //20160516 Igor
Function GetT4AIncomeForT2125(RetNo: integer; T2125FInst: String): Real;
function InitFeesTable: Boolean;
Function IsFormCharged(FName: String): Boolean;
Function OpenReturnAndCheckT1013(DataDir: String; FlName: String): Boolean;
Function GetFormAbbrevDescr(FName: String): String;
Function GetT1013ConfirmationNumber(ResponseXmlFile: String): String;
Function ValidForT1013Efile(RetNo: integer; FNo: integer): Boolean;
Function ShouldHighlight(RetNo: integer; FName: String; FNo: integer): Boolean;
// 20110109
Procedure CallT1WebService;
Procedure CallTrisWebService;
Function ExtractLinkedFormAndSlashField(FInst: String; LinkedToString: String;
  Var TargetLinkedField: integer): String; // 20101223
Function YYYYMMDDToMMDDYYYY(Dt: String): string;
Procedure ShowHTTPStatus(State: integer);
Procedure CheckAllForms;
Procedure OpenCloseForms(Ndx1, Ndx2: integer);
Procedure RenumberT1Scr;
Function GetFncValue(RetNo: integer): String;
// Procedure CopyCATCFromFitness(RetNo:Integer);  //20171119
Function IsSpouseNonResident(RetNo: integer): Boolean;
// Function GetRc310Income(RetNo:Integer):Real;  //20170126
procedure ShowTheFList;
Function GetNetIncomeForDependantId(RetNo: integer; Id: String): Real;
Procedure SetDependantIncomeForUCCB(RetNo: integer; Id: String; Amount: Real);
Function GetEligibleDependantNameFromId(RetNo: integer; Id: String): String;
Function GetEligibleDependantId(RetNo: integer): String;
Procedure GetKidsUnder6ForUCCB(RetNo: integer);
Function GetPRPStatusDescr(PRPStatusCode: String): String;
Function GetEfStatusDescr(EFStatusCode: String): String;
procedure RegisterFileType(cMyExt, cMyFileType, cMyDescription, ExeName: string;
  IcoIndex: integer; DoUpdate: Boolean = false);
// Function ReturnPswHasEof(S:String):Boolean;
Function GetClientNameFromDB(FlName: String): String;

Function ConvertFNameToCombined(FName: String): String;
Function ConvertElmNoToCombined(OldFName: String; elm: integer;
  IncrElmList: TStringList): integer;
function ConvertFormToText(SourceFileName: string): Boolean;
function ConvertTextToForm(SourceFileName: string): Boolean;

function DfmFile2Stream(const Src: string; Dest: TStream): Boolean;
function IsDFMBinary(FileName: string): Boolean;
function Dfm2Txt(Src, Dest: string): Boolean;
function Txt2DFM(Src, Dest: string): Boolean;

function ReplaceStr(OriginalString, SubStr, NewStr: string): string;
Function GetFirstInstanceWithData(RetNo: integer; FName: String): String;
Function CountMultiPageStatements(RetNo: integer; FrmNm: String): integer;
Function CountSinglePageStatements(RetNo: integer; FrmNm: String): integer;
Function CheckAssets(RetNo: integer): String;
Procedure GetPOBoxAndRRFromDisk(RetNo: integer; Var Val1: String;
  Var Val2: String; FullFlName: String);
Function GetAddBlankPg(FName: string): Boolean;
// Function GetAddBlankPg(FName:string):String;
Function IsDitto(S: String): Boolean;
Function GetQPPPensionableEarnings(RetNo: integer; MxQpp: Real): Real;
// 20140113
Function GetCPPPensionableEarnings(RetNo: integer; MxCpp: Real): Real;
// 20140113
// Function IsInTapesList(RetNo: Integer; Fname: String; elm: Integer): Boolean; //20220121 Igor
// procedure AdjustFinePrintRegistrySettings(PDFFullfileName: String; //20160905 Igor (Move to vtTrimStr)
// ShowDlgValue: Integer; PdfActionValue: Integer; CollectJobsValue: Integer);
Procedure RenumberMultiples(RetNo: integer; FrmNm: String);
function ColumnSortDescending(List: TStringList;
  Index1, Index2: integer): integer;
function ColumnSortAscending(List: TStringList;
  Index1, Index2: integer): integer;
Function FieldHasNote(RetNo: integer; FName: String; elm: integer): String;
Function FieldHasTape(RetNo: integer; FName: String; elm: integer): String;
Function GetRestrictedFarmLoss(RetNo: integer; Stmt: String): Real;
Function CountScholarships(RetNo: integer): integer;
Procedure GetKidsForFitness(RetNo: integer);
Procedure GetKidsForArts(RetNo: integer);
Procedure GetMBKidsForFitness(RetNo: integer);
Procedure GetKidsUnder6(RetNo: integer);
Function GetTaxOnBase(Bracket, PrevBracket, PrevPercent,
  PrevBaseTax: Real): Real;
Function GetInfirmEligDependantsOver18(RetNo: integer): integer;
Function CountDispositionEntriesForInvoice(RetNo: integer): integer;
Function CountDependantEntriesForInvoice(RetNo: integer): integer;
Function CountTuitionEntriesForInvoice(RetNo: integer): integer;
// Function CountAssetEntriesForInvoice(RetNo:Integer):Integer;
// Function CountAutosEntriesForInvoice(RetNo:Integer):Integer;
Function CountDonationEntriesForInvoice(RetNo: integer): integer;
Function CountRRSPEntriesForInvoice(RetNo: integer): integer;
Function CountMedicalEntriesForInvoice(RetNo: integer): integer;
Function GetRevisedAssetbLink(OldStmt: String; ConvList: TStringList): String;
Function GetTxblForPrvS11(RetNo: integer; PRV: String; LowBracket: Real;
  LowRate: Real): Real;
// Procedure ConsolidateIntoT2125(RetNo:Integer;ReverseCCA:Boolean);
function CreateShortcut(SourceFileName: string;
  // the file the shortcut points to
  Location: ShortcutType; // shortcut location
  SubFolder, // subfolder of location
  WorkingDir, // working directory property of the shortcut
  Parameters, Description: string): // description property of the shortcut
  string;
function CreateShortCutDialog(Directory: string): Boolean;
procedure OpenMsWord;
Procedure PopulateAssets(RetNo: integer);
Procedure CaptureLastYearCCA(RetNo: integer);
Function HasEligibleDependant(RetNo: integer): Boolean;
Function HasEligibleDependantForWIB(RetNo: integer): Boolean;
Function HasEligibleSpouseForWIB(RetNo: integer): Boolean;
Function GetAutoCCAClaimed(RetNo: integer; Stmt: String; FInst: String): Real;
Function IsAuthorizedPreparer: Boolean;
Function DownLoadFromWeb(url, remoteFlName, localDir,
  localFlName: string): Boolean;
Function GetLine371ForEfile(RetNo: integer): Real;
Function GetPensionerSinNo(RetNo: integer): String;
Function GetTotT4ARCA(RetNo: integer): Real;
Function GetPensionerRetNo(RetNo: integer): integer;
Function GetTransfereeRetNo(RetNo: integer): integer;
Function GetSelfEmplForWib(RetNo: integer): Real;
Function EligibleForWIB(RetNo: integer): Boolean;
Function GetWorkingIncomeForWib(RetNo: integer): Real;
Function GetLn314(RetNo: integer): Real;
Function GetPrvPnsDed(RetNo: integer): Real;
Function TaxDeductedForEligiblePension(RetNo: integer; Var FromT4a: Real;
  Var FromT4Rif: Real; Var FromT4RSP: Real; Var FromT4ARCA: Real): Real;
// 20150313
// Function TaxDeductedForEligiblePension(RetNo:Integer;Var FromT4a:Real;Var FromT4Rif:Real;Var FromT4RSP:Real):Real;
Function MarStatusChanged(RetNo: integer): Boolean;
Function AnySplittableCredits(RetNo, OptimizeFNo: integer): Boolean;
Function CalcBusDays(RetNo: integer; Stmt: String): integer;

Procedure PostNonVehicleCCA(RetNo: integer; FName: String; Stmt: String;
  FInst: String; FNo: integer; StartNdx, EndNdx, IncrBy, EndSectionNdx,
  RemainingNdx, TotalNdx: integer);

Procedure PostNonBuildingAdditions(RetNo: integer; FName: String; Stmt: String;
  FInst: String; FNo: integer; StartNdx, EndNdx, IncrBy, EndSectionNdx,
  RemainingNdx, TotalNdx: integer);

Procedure PostBuildingAdditions(RetNo: integer; FName: String; Stmt: String;
  FInst: String; FNo: integer; StartNdx, EndNdx, IncrBy, EndSectionNdx,
  RemainingNdx, TotalNdx: integer);

Procedure PostNonBuildingDispositions(RetNo: integer; FName: String;
  Stmt: String; FInst: String; FNo: integer;
  StartNdx, EndNdx, IncrBy, EndSectionNdx, RemainingNdx, TotalNdx: integer);
Procedure PostBuildingDispositions(RetNo: integer; FName: String; Stmt: String;
  FInst: String; FNo: integer; StartNdx, EndNdx, IncrBy, EndSectionNdx,
  RemainingNdx, TotalNdx: integer);
Procedure PostAutoCCA(RetNo: integer; FName: String; Stmt: String;
                      FInst: String; FNo: integer; RemainingNdx, TotalNdx: integer);   // 20230428 Igor


Procedure PostAutosAdditions(RetNo: integer; FName: String; Stmt: String;
  FInst: String; FNo: integer; StartNdx, EndNdx, IncrBy, EndSectionNdx,
  RemainingNdx, TotalNdx: integer);

Procedure PostAutosDispositions(RetNo: integer; FName: String; Stmt: String;
  FInst: String; FNo: integer; StartNdx, EndNdx, IncrBy, EndSectionNdx,
  RemainingNdx, TotalNdx: integer);

Function PostCCAFromAssetsB(RetNo: integer): Boolean;
Procedure PostNonCompliantShortTermRentalsCCA(RetNo: integer; FName: String; Stmt: String;
                                              FInst: String; FNo: integer; StartNdx, EndNdx, IncrBy, EndSectionNdx,
                                              RemainingNdx, TotalNdx: integer);
function IsVista: Boolean;
Procedure ShowChmHelp(HelpFile: String; Helptopic: string);
Procedure FillAuto777ExpRec(RetNo: integer; Stmt: String);
Procedure FillSelfAutoExpRec(RetNo: integer; Stmt: String);
Function IsSharedStatement(RetNo: integer; Stmt: String): Boolean;
Procedure RecalcBusStatements(RetNo: integer); // StmList:TStringList);
Procedure CopyOptimumSplitsToOptimize(RNo: integer);
Procedure CopyOptimumSplitsToSchedules(RNo: integer);
Procedure SaveDebugInfo(RetNo: integer; SpRetNo: integer; FlName: String);
Procedure GetListOfStatementsForAutos(RetNo: integer; AList: TStrings);
Procedure InitExtractedAutolist(RetNo: integer = 0);
Procedure InitExtractedCCAlist(RetNo: integer = 0);

Procedure ExtractAutos(RetNo: integer; StmtId: String; StatementInst: String;
  Var TermLossAmount: Real; Var RecaptAmount: Real; Var AutoCCAForStmt: Real);

Procedure ExtractCCA(RetNo: integer; StmtId: String; StatementInst: String;
  Var TermLossAmount: Real; Var RecaptAmount: Real; Var CCAForStmt: Real);

// 20200511
Procedure ExtractAuto777(RetNo: integer; StmtId: String; StatementInst: String;
  Var TermLossAmount: Real; Var RecaptAmount: Real; Var AutoCCAForStmt: Real);

procedure saveXMLWithNoCRAPasswordID(savelocation: string; AList: TStringList;
  SaveTheXML: Boolean);

Function FedTaxBfrDividendTaxCredit(RetNo: integer): Real;
Procedure GetParentsInfo(RetNo: integer);
Function GetRetToOptimize(RetNo, SpRetNo: integer): integer;
Function GetLn115FromSlips(RetNo: integer): Real;
Function CalcInfirmClaim(RetNo: integer; Ni: Real; PercentClaim: Real): Real;
Function CalcCareGvrClaim(RetNo: integer; Ni: Real; PercentClaim: Real): Real;
Function CalcPrvInfirmClaim(RetNo: integer; Ni: Real; PercentClaim: Real): Real;
Function GetTot306(RetNo: integer): Real;
Function GetTot315(RetNo: integer): Real;
Procedure InitOtherSplits(RNo: integer; CurRetNo: integer);
Function GetFedPolCredit(RetNo: integer; PolContr: Real): Real;
Function CalcPolitContrFromCredit(TotPolit: Real; PolitCredit: Real): Real;
Function GetBftBeforePolit(RNo: integer): Real;
Function GetHigherTxblSpouseRetNo(RetNo, SpRetNo: integer): integer;
Procedure OptimizeNonRefundableSplits(RetToOptimize: integer;
  Var LowestTotal: Real; CurRetNo: integer);
Function ExtractFamilyTotal(RetNo, SpRetNo: integer): Real;
Function GetMaxClaimableMedical(RetNo: integer; TotMedicalExpenses: Real): Real;
Procedure SplitMedical(RetNo, SpRetNo: integer; Var LowestTotal: Real;
  TotMedical: Real; Var OptimumMedicalPercent: Real);
Function EligibleForPSplit(RNo: integer): Boolean;
Function IsResident(RetNo: integer): Boolean; // 20240424
Function IsNonResident(RetNo: integer): Boolean;
Function GetOptimumRRSPClaim(RetNo: integer; MaxAvailable: Real): Real;
Function GetOptimumPensionSplit(RetNo: integer;
  Var PercentElm: integer): integer;
Procedure CloneMedical(FromRetNo, ToRetNo: integer);
Procedure CloneDonations(FromRetNo, ToRetNo: integer);
Function AnyNonSlipDonations(RetNo: integer): Boolean;
Function TransferMedical(FromRetNo, ToRetNo: integer): Boolean;
Function TransferDonations(FromRetNo, ToRetNo: integer): Boolean;
Procedure CopyACBSalesToS3ACB(RetNo: integer);
// Function IsSignedOff(RetNo:Integer;ErrMsg:String):Boolean; //may 15 2008
// Function IsSignedOff(ErrMsg:String):Boolean;
Function GetFieldErrorMsg(RetNo: integer; FName: String; elm: integer): String;
// Function SignOffAWarning(RetNo:Integer;ErrorRec:TAuditRec):Boolean;
Function IsFormInDataList(RetNo: integer; FName: String;
  TempList: TStringList): Boolean;
Function GetValueFromDisk(RetNo: integer; FName: String; elm: integer;
  TempList: TStringList): String;
Procedure OpenUsedForms(RetNo: integer);
Function CountKidsUnder6(RetNo: integer): integer;
Function CountKidsUnder18(RetNo: integer): integer; // for S1 ln 388
Function FormatT1273Decimals(S: String): String;
Function GetNonQCEIPremiums(RetNo: integer): Real;
Function GetFisherUIEarnings(RetNo: integer): Real;
Function GetUserCaisCodeDescr(Code,CodeOrDescr: String): String;
Function AnyQCT4Slip(RetNo: integer): Boolean;
Function GetNonQCT4Box14(RetNo: integer): Real;
Function GetQCT4Box14(RetNo: integer): Real;
Function GetPPIPInsurable(RetNo: integer): Real;
Function GetRenamedFName(FName: String): String;
Function YYYYMMDDToDDMMYYYY(InputDate: String): string;
Function IsLowerIncomeSpouse(RetNo: integer): Boolean;
Function GetTxblIncBeforeLine253(RetNo: integer): Real;
Function GetTxblIncBeforeLine254(RetNo: integer): Real;
Procedure GetListOfBusiness(RetNo: integer; AList: TStringList);
Function GetFormHeight(FName: string): integer;
Function MaxString(S1, S2: String): String;
Function MinString(S1, S2: String): String;
Function GetTotalUCCB(RetNo: integer): Real;
Function GetTotalRDSP(RetNo: integer): Real;
Function IsIncomeLowerForUCCB(RetNo: integer): Boolean;
Function GetSpouseUCCB(RetNo: integer): Real;
Function GetSpouseRDSP(RetNo: integer): Real;
Procedure GetDependantsForTransit(RetNo: integer);
Function GetPreparerInfo(RedirectToSite: String): String;
Function LinkToSelf(InitialFormName: String; TargetFormName: String): Boolean;
Function DoubleDoubleSpaced(S: String): String;
Function DoubleSpaced(S: String): String;
Function ConvertToPixelsX(x: Real; PixPerInX: integer): integer;
Function ConvertToPixelsY(Y: Real; PixPerInY: integer): integer;
Procedure GetDependantsSINS(RetNo: integer);
Function GetBirthDate(RetNo: integer): String;
Function EmptyElms(RetNo, FNo, Elm1, Elm2: integer): Boolean;
Procedure FindEmptyInvoiceLine(RetNo: integer; FNo: integer;
  Var EmptyDescrElm: integer; Var EmptyAmountElm: integer);
Procedure AddSpouseCharges(RetNo: integer);
Function IsJointInvoice(RetNo: integer): Boolean;
Function IsJointInvoiceForThisReturn(RetNo: integer): Boolean;
function ConvertToProper(S: string): string;
Procedure LoadT1013Template(RetNo: integer; FName: String);
Procedure SaveT1013Template(RetNo: integer; FName: String);
Function TimeForBackUp: Boolean;

Function GetSinNoFromAck(DCN: String): String;
Function GetDcnSeqNoEOL(RetNo: integer; OnLineNo: String): String;
Function CountT1163(RetNo: integer): integer;
Function CountT1273(RetNo: integer): integer;
Function HarmonizedProvince(PRV: String): Boolean; // for rollover
Function HarmonizedFarmStead(PRV: String): Boolean;
Function CountCropEntries(RetNo: integer; FInst: String): integer;
Function CountLiveStockEntries(RetNo: integer; FInst: String): integer;
Function IsT1273CashMethod(RetNo: integer; FInst: String): Boolean;
function IsLandscape(FName: String): Boolean;
Function IsEfOverride(RetNo: integer; Lline: integer): Boolean;
Function GetEfOverride(RetNo: integer; Lline: integer): Real;
Function UpdateDcnNo(SinNo: String; DcnNo: String): Boolean;
Function IsValidCCA(Cls: String): Boolean;
Procedure GetLoginNames(Var TempList: TStringList);
Procedure UpdateLoginNames(Nm: String);
Procedure RemoveLinkToLastYearRetNo(LastYrRNo: integer);
// procedure InsertBackFunction(ARichEdit:TRichEdit;InSearch, InSecondSearch, InReplace: string); //20160819 Igor
Function GetLastYearTaxYear: String;
Function DeleteReturn(Dir, FlName: String; ATable: TADTable = nil): Boolean;
// 20170210 Igor
// Function DeleteReturn(Dir,FlName:String):Boolean;
Function CopyMoveReturn(const CopyOrMove, fromDir, toDir, FlName: String)
  : Boolean; // 20170811 Igor
// Function IncrementlastBackUpDir(LastBackUp:String):String;
Procedure ExtractFromHelpCnt(CntRec: String; Var Descr: String;
  Var KeyW: String);
Procedure LoadHelpCntInTreeView(HelpCntFile: String; ATreeView: TTreeView;
  Var HelpKeyW: TStringList);
Function GetPlannerDir: String;
procedure GetFileList(FDirectory, Filter: TFileName; SomeList: TStringList);
// function GetFileList(FDirectory, Filter: TFileName): TStringList;

function GetDefaultPrinterName: string;
Function IsPrinterInstalled(PrinterName: String): Boolean;
procedure SetDefaultPrinter(PrinterName: String);
Procedure GetPrinterDriversNames(Var AList: TStringList);
procedure PrintAtAngle(AText: String; ACanvas: TCanvas; Xpos: integer;
  YPos: integer; FontSize: integer; AtAngle: integer);
Procedure PrintWithMsWord(RetNo: integer; FileName: String;
  InterpretKeyWords: Boolean);
Function IsInvoiceLocked(RetNo: integer): Boolean;
Function GetClosestEditBoxOFINFO(LblCaption: String): integer;
Function IsKeyWAnAmount(KeyW: String): Boolean;
Function IsConditionalRtfStatement(KeyW: String): Boolean;
Procedure InsertKeyWToDataDict(FormName: String; AnEditBox: TvtEdit);
// Procedure AddDisplayFormatToRtf(ARichEdit:TRichEdit;KeyWList:TStringList); //20160819 Igor
Function CleanUpKeyW(KeyW: String): String;
// Procedure GetDelimiterPositionsInRtf(ARichEdit: TRichEdit; SearchText: string;DelimList:TStringList); //20160819 Igor
// Function GetKeyWListFromRichEdit(ARichEdit:TRichEdit;KeyWList:TStringList):Boolean; //20160819 Igor
// Procedure ReplaceRtfDelimiters(ARichEdit:TRichEdit;FromDelim,ToDelim:String); //20160819 Igor
Procedure GetKeyWAttributes(KeyW: String; Var FName: String; Var elm: integer;
  Var IsAmount: String);
// Function IsKeyWInRtf(ARichEdit:TRichEdit;InSearch:string):Boolean;
// Function RTFToPlainText(ARichEdit:TRichEdit):AnsiString;
// Procedure ConvertOldLetter(ARichEdit:TRichEdit);
// procedure ReplaceRtfText(ARichEdit:TRichEdit;InSearch, InReplace: string) ; //20160819 Igor
Function IsFormAClientLetter(FName: String): Boolean;
Function IsAcceptableGraphicsFile(FlName: String): Boolean;
Function GetLetterFileName(RetNo: integer; FName: String): String;
Function GetRichElms(FrmNm: String): String;
Function CreateNewDataDir: String;
Function GetSigningDate(RetNo: integer): String;
// Procedure LoadCPLList(RetNo:Integer;Var CplList:TList);
// Function FieldHasAddingTape(RetNo:Integer;FName:String;Elm:Integer):Boolean;
Procedure GetCouplingSins(RetNo: integer; Var CouplingSins: TStringList);
Procedure SetDefaultOptions; // 20160523 Igor //20160602 Igor
Function GetDefaultOptionsValue(const AOptionsName: String): String;
// 20160530 Igor
function GetDefaultOptions: TStringList; // 20160530 Igor
function GetOptionsCaption(AOptionsName: String): String; // 20160530 Igor
function HaveOptions(AOptionsName: String): Boolean; // 20170112 Igor
function CreateDefaultDataDirectories: Boolean; // 20170811 Igor
Function IsDevelopmentMode: Boolean;
Procedure GetS3ACBAmounts(RetNo: integer; PropertyType: String;
  Var AcbProceeds: Real; Var AcbGain: Real);

Procedure SaveSingleOption(FieldNm: String; Value: String;
  AOptionsFileName: String = ''); // 20160617 Igor
Procedure InitOptions;
Function GetDfmFormsDir: String;
Function FromYesToX(YesNo: String): String;
Function StringToBoolean(AString: String): Boolean;
Procedure ConvertCfgToOptionsFile(CfgTbl: TADTable); // 20150915 Igor //one time
Procedure LoadOptionsFileToMem;

Function BooleanToString(ABoolean: Boolean): String;

Procedure StorePage1ToInfo(RetNo: integer; FormNm: String; FNo: integer;
  elm: integer; Valu: String);
Procedure CopyPortfolioToACBForm(RetNo: integer);
Procedure CopyPortflDetails(RetNo, PortflFNo, AcbFormFNo, FromPortfolElm,
  ToPortflElm, FromAcbElm: integer);
Function IsInMostRecentReturns(FlName: String;
  MostRecentList: TStringList): integer;
Procedure FixCheckBoxes(RNo: integer);
Function YesNoToX(S: String): String;
Procedure PopulatePage1FromInfo(RNo: integer);
Procedure LockReturn(RNo: integer);
Procedure UnlockReturn(RNo: integer);
Function ShowUnconvertedLastYear(RNo: integer): Boolean;
Function IsOkToOpenReturn(DataDir: String; FlName: String; Sin: String)
  : Boolean;
Function GetEfileStatus(DataDir, FlName: String): String;
Function GetLongestLengthItem(SomeList: TStringList): integer;
Function GetDefaultScaling: integer;
Procedure LoadEditBoxProperties;

Function GetRetNoFromSin(Sin: String): integer;
Function GetAdditionalHighlights(RetNo: integer; FName: String;
  FNo: integer): Boolean;
Procedure GetMIAAmount(RetNo: integer; FarmFname: String; Var MIA: Real;
  Var OIA: Real);
Procedure GetListOfFarmingStatements(RetNo: integer; AList: TStringList);
Function GetTL2ForGst370(RetNo: integer): Real;
Function GetT1013Level: String;
Function ShowSalutationWarning: Boolean;
Function ShowInvoiceWarning: Boolean;
Function ShowEfileCharges: Boolean;
Function IsFieldASin(FName: String; Fld: integer): Boolean;
Function SelfEmployedInQc(RetNo: integer): Boolean;
Function GetTrTopicFromLineRef(FormName: String; FieldId: integer): String;
Function TotT4RIFBox20(RetNo: integer; NonInstFormName: String;
  elm: integer): Real;
// 20170904 Igor>>>
// Function GetTrFolder:String;
// Function IsTrLoaded:Boolean;
// Procedure LoadTr(TrFolder:String);
// Function GetTrHandle:HWND;
// Procedure LinkToTR(SearchItem:String);
// 20170904 Igor<<<
Function CalcMortgageForeclosure(L127, ForeClosureQfp, ForeClosureOth
  : Real): Real;
Procedure CopyT5SlipsToT5Mult(RetNo: integer);
Function SlipsInAT5Mult(RetNo: integer; FName: String): integer;
Function SlipsInAT3Mult(RetNo: integer; FName: String): integer;
Function IsFormASlip(FrmNm: String): Boolean;
Procedure UpdateThisFormDataIndicator(RetNo: integer; FName: String);
Function IncrDay(Dt: String): String;
Function GetRealFormName(FrmNm: String): String;
Function GetShowOpenedFormsIndicator: Boolean;
Function IsFirstPageOfForm(FormName: String): Boolean;
Function CalcFedMedicalLimitForDependant(RetNo: integer;
  MedicalPaid, Ni: Real): Real;
Function CalcPrvMedicalLimitForDependant(RetNo: integer;
  MedicalPaid, Ni: Real): Real;
Procedure AccumMedical(RetNo: integer);
Procedure GetDependantRec(RetNo: integer; DependId: String; Var DepRec: TDepRec;
  DependFNo: integer);
Function GetEmptyIndexIn331(RetNo, MedicalFno: integer): integer;
Procedure GetAllLinesWithAString(S: String; AList: TStringList;
  Var ResultsList: TStringList);
Function GetPatientIndexIn331(RetNo: integer; DependId: String;
  MedicalFno: integer): integer;
Function IsPatientFor330(RetNo: integer; DependId: String;
  DependFNo: integer): Boolean;
Procedure AddPatientFor331(RetNo: integer; DependId: String;
  MedicalFno, DependFNo: integer; AmountPaid, AmountClaim: Real);
Procedure GetPatientsInfo(RetNo: integer);
Procedure GetT12002CNIL(RetNo: integer; Var Val1: String; Var Val2: String;
  FullFlName: String);
Function SeparatedThisYear(RetNo: integer): Boolean;
Function FirstTimeClient(RetNo: integer): Boolean;
Function GetL122LossForMinTax(RetNo: integer): Real;
Function GetTaxShelterLossT776T2042(RetNo: integer): Real;
procedure BuildSuperEntries(FullFlName: String);
// procedure ShowPdf(PgmPath,PgmFile:String);//20171031 igor
// procedure OpenAnyFile(PgmPath,PgmFile:String);//20171031 igor
Procedure LinkToCICA(Ln: String);
Function IsPredictiveRRSPField(FieldId: integer): Boolean;
Function Fetch2001ValueFromDisk(RetNo: integer; FName: String; elm: integer;
  TempList: TStringList): String;
Function ShowCondominiumIndicator: Boolean;
Function GetCVIndicator: String;
Function GetCVPostIndicator: String;
Function GetT4T5RolloverIndicator: Boolean;
Function CountOtherInAssets(RetNo: integer; StatementFNo: integer): integer;
Function CountCarsInAssets(RetNo: integer; StatementFNo: integer): integer;
Function AnyDisabledDependant(RetNo: integer): Boolean;
Function GetPreAdjValue(RetNo: integer; LnNo: String;
  BeforeList: TStringList): Real;
Function GetSnapShotFileName(RetNo: integer): String;
Function GetLineDescription(Ln: integer; LineList: TStringList): String;
Procedure NetListToT1Adj(RetNo: integer; FNo: integer; NetList: TStringList;
  FromNetListNdx: integer);
Procedure GetT1AdjNetList(BeforeList, AfterList: TStringList;
  Var NetList: TStringList);
Procedure CreateSnapshot(RetNo: integer; BeforeOrAfter: String);
Function IsBuildingClass(CcaClass: String): Boolean;
Function IsAutosClass(CcaClass: String): Boolean; // 20230519
Procedure LoadDirList(DirList: TStringList);
Procedure GetElmsInError(RetNo: integer; FName: String);
Function IsFieldInElmsInError(S: String; AList: TStringList): integer;
Function GetCampLimit(KidAge: integer; Weeks: integer; Infirm: String): Real;
Function GetCarePrvHeader(RetNo: integer): String;
Function AmountForPrvMinTax(RetNo: integer): Real;
Function CalcCpp(TotalEarnings: Real): Real;
Function CalcEI(TotalEarnings: Real): Real;
Function SlipsAvailable(RetNo: integer): Boolean;
Function SetReplaceStringToZero(RetNo: integer;
  ReplaceString, KeyW, FrmNm: String; ElmNo: integer): String;
// Function MaxStLoan(RetNo: Integer): Real;
Function NIBfrAprTool(RetNo, FNo: integer; AprToolDed: Real): Real;
Function ValidFirstLastName(S: String): Boolean;
Function GetEolPNetFileDir: String;
Function GetEOLAgentNo: String;
Function GetEOLPAgentNo: String;
Function FetchEfMethod(RetNo: integer): String;
Function GetEfMethod: String;

// Function GetFilePsw(Datadir: string; FlName: string):String;
Procedure StoreReturnPsw(RetNo: integer; RetPsw: String);
Procedure RemoveReturnPsw(RetNo: integer);
Function GetReturnPsw(DataDir, FlName: string; APwdArr: Variant): String;
// 20160415 Igor
function CheckReturnPsw(DataDir, FlName: string; APwdArr: Variant): integer;
// 20160415 Igor
function CheckReturnAndPsw(DataDir, FlName: string; APwdArr: Variant): Boolean;
// 20160415 Igor

Function GetDefaultNetFileDir: String;
Function GetDefaultEolPNetFileDir: String;

Procedure GetEOLPParms(Var OnLineNo: String; Var TransmitterNo: String;
  Var Password: String; Var url: String; Var NetFileDir: String);

Procedure GetEOLParms(Var OnLineNo: String; Var Password: String;
  Var url: String; Var NetFileDir: String);

Procedure SaveEOLPParms(OnLineNo, TransmitterNo, Password, url,
  NetFileDir: String);
Procedure SaveEOLParms(OnLineNo, Password, url, NetFileDir: String);

function MouseHasWheel: Boolean;
Procedure GetDependantsList(RetNo: integer);
Procedure GetDependantsNamesAndSINS(RetNo: integer);
Function IsFormTheDefaultSearch: Boolean;
Function MBSchoolCredit(RetNo: integer; FamilyIncome: Real): Real;
Function GetLastYearValue(ElmNo: integer; FrmDataList: TStringList): String;
Procedure GetFrmDataListFromFullDataList(FrmNm: String; DataList: TStringList;
  Var FrmDataList: TStringList);
Procedure GetElmListFromCompFrmRec(Rec: String; Var ElmList: TStringList);
Function GetLastYearValueFromYRSum(LnNo: integer): String;
Function GetProfileFldName(S: String; ClientOrSpouse: String): String;
Function GetPositionOfSubstring(ss, S: String): integer;
Function GetValueFromInternet(url: String; Parameter: String): String;
Function IsProfileReturn(RetNo: integer): Boolean;
Function IsCanTaxReturn(RetNo: integer): Boolean;
Function GetLastYrLineNoValueFromDisk(LnNo: integer; FlName: String): String;
Function MkFlNameFromSin(RetNo: integer): String;
Function LineIsInCompList(LineNo: String; Comp2YrList: TStringList): integer;
Function PredictiveForm(Frm: String): Boolean;
Function PredictMedPatientName(RetNo: integer; FrmNm: String; FldId: integer;
  OldString: String): String;
Function PredictMedDoctorName(RetNo: integer; FrmNm: String; FldId: integer;
  OldString: String): String;
Function PredictMedExpenseName(RetNo: integer; FrmNm: String; FldId: integer;
  OldString: String): String;
Function PredictMedDates(RetNo: integer; FrmNm: String; FldId: integer;
  OldString: String): String;
Function PredictCharityList(RetNo: integer; FrmNm: String; FldId: integer;
  OldString: String): String;

Procedure BuildExperience(FrmNm: String; FromElm, ToElm, ByElm: integer;
  FlName: String; Var ElmList: TStringList; DataList: TStringList);

Procedure PutValuesInElmList(FrmNm: String; DataList: TStringList;
  Var ElmList: TStringList);

Procedure PutValuesInFrmDict(FrmNm: String; DataList: TStringList;
  Var Frmdict: TStringList);
Procedure GetFormAndElmViaFrmDict(Frmdict: TStringList; FldName: String;
  Var FrmNm: String; Var ElmNo: integer);
Procedure GetUsedFormsFromDisk(FullFlName: String);
Procedure GetFrmDict(FormNm: String; Frmdict: TStringList);
// ;WhichYear:String);
Function GetLastYearValueOfAForm(ElmNo: integer;
  FileValuesList: TStringList): String;
procedure GetDataFromDiskViaFrmDict(FullFlName: String; FrmNm: String;
  Var FileValuesList: TStringList);
Function CanTaxJulianDaysToYYYYMMDD(DtIn: String): String;
Function JulianDaysToBirthDate(DtIn: String): String;
Function GetFileExtension(FlName: String): String;
Function AdvanceYearEnd(ThisYearEnd: String): String;
Function FillLeftZeros(S: String; MaxLength: integer): string;
procedure ConvertMostRecentFiles; // 20200914 Igor
Procedure InitMostRecentFiles(HowMany: integer);
Procedure UpdateMostRecentFiles(RetNo: integer; Dir, FlName, Sin: String);
Function GetMotorPercent(RetNo: integer; FNo: integer): Real;
Procedure ConvertOldAutoExpDates(RetNo, FNo: integer);
Function ThereIsNetCapLossThisYear(RetNo: integer): Boolean;
Function NetCapLossCarryBackClaimed(RetNo: integer): Boolean;
Function IsEFiledReturn(RetNo: integer): Boolean;
Procedure AutoFormatDate(Var Value: String);
Function FetchLastYearValueFromDisk(RetNo: integer; FName: String;
  elm: integer): String;
Function IsNonResWithCanEmpl(RetNo: integer): Boolean;
Function EmplIncInProv(RetNo: integer; PRV: String): Real;
// Procedure FixCNIL(RetNo:Integer;Var Val1:String;Var Val2:String);
Procedure ReadTheValue(TempList: TStringList; FrmNm: String;
  Elm1, Elm2: integer; Var Val1: String; Var Val2: String);
Procedure ClearAnyForm(RetNo: integer; Frm: String);
Procedure RefreshDependAddresses(RetNo: integer);
Procedure RefreshSpouseAddresses(RetNo: integer);
Procedure ClearAllMJS2S11(RetNo: integer);
Function GetMjAlloc(RetNo: integer; PRV: String): String;
Function GetEmptyInstance(RetNo: integer; FormName: String): integer;
Function GetFldTapeFormNo(RetNo: integer;
  RefFormName, RefFieldId: String): integer;
Function GetFldMemFormNo(RetNo: integer;
  RefFormName, RefFieldId: String): integer;
Function NetIncBfrChCare(RNo: integer): Real;
Procedure SortMedical(RetNo: integer; FName: String);
Procedure SortACBFRM(RetNo: integer; FName: String);
Function IncrYear(Dt: String): String;
Function IsBankruptcyReturn(RetNo: integer): Boolean;
Function IsPreBankruptcyReturn(RetNo: integer): Boolean;
Function IsPostBankruptcyReturn(RetNo: integer): Boolean;
Function IsSection216(RetNo: integer): Boolean;
Function IsSection115(RetNo: integer): Boolean; // NR with empl
Function IsSection116(RetNo: integer): Boolean;
Function IsSection217(RetNo: integer): Boolean;
// 20170901 Igor>>>
// Function ExceedsMaxReturnsAllowed:Boolean;
// Function CountDBRecords:Integer;
// 20170901 Igor<<<
Function PowerFeatureOnly(LicenseLevel: String): Boolean;
Function MaxTransfersFromKids(RetNo: integer): Real;
Function GetLongPrv(SPrv: string): String;
Function ConvertGpDate(DtIn: String): String;
Function IsCPPExempt(RetNo: integer): Boolean;
Function GetTax1FormName(RetNo: integer): String;
Function GetAnyPathMoreThan8Chars(Dir: String): String;
Procedure ParseWords(S: String; Delim: String; Var WList: TStringList);

Function GetS2PrvHeader(RetNo: integer): String;
Function GetS11PrvHeader(RetNo: integer): String;
Function FullTONIProvince(RetNo: integer): Boolean;
Function GetPrvDisabXfer(RetNo: integer): Real;
Function GetPrvEducXfer(RetNo: integer): Real;
Function CalcPRVL300To314(RNo: integer; WhichTransfer: String): Real;
Function GetShortPrv(LPrv: string): String;
Function FindWord(ThisWord, Ln: String): integer;
Function CalcPrvMedicalLimit(RetNo: integer): Real;
Function OpentaxbyteDB(UserId: string): Boolean;
Function FetchADate: String;
Procedure AuditRecsToTreeView(RetNo: integer; TempList: TStrings;
  AuditMode: eAuditMode);
Function CountErrorType(RetNo: integer; Category: String): integer;
Function ZeroIfPositive(x: Real): Real;
Function IsDeceased(RetNo: integer): Boolean;
Function IsDeceasedNextYear(RetNo: integer): Boolean; // 20140219
Function IsSpouseDeceased(RetNo: integer): Boolean;
Function GetPrvForTaxCredit(RetNo: integer; ThisPrv: String): Real;
Function IsHomeUse: Boolean;
Function GetFastPrintIndicator: Boolean;
Function GetTheTime(Dt: TDateTime): String;
Function GetProrationIndicator(RetNo: integer): integer;
// Function GetDeferredDispBenefit(RetNo: integer): Real;
Function SumT3MultBox(RetNo: integer; elm: integer): Real;
Function GetInclusionRate(RetNo: integer): Real;
Function SplitIncome(RetNo: integer): Boolean;
Function CalcFedDisabilityXfer(RetNo: integer; Under18: String;
  ChCare, AttendantCare, TxblInc, L300To314: Real): Real;
Function CalcPrvDisabilityXfer(RetNo: integer; Under18: String;
  ChCare, AttendantCare, TxblInc, L300To314: Real): Real;
Function CalcFedEducClaim(UnusedCF, TotalThisYear, TxblInc,
  L300To318: Real): Real;
Function CalcPrvEducClaim(RetNo: integer; UnusedCF, TotalThisYear, TxblInc,
  L300To318: Real): Real;
Function NIBfrAttendantCare(RetNo: integer): Real;
function GetFormNumberFields(FNo: integer): integer;
function GetMaxFormNumber: integer;
Function ReplaceChar(S, FromChar, ToChar: String): String;
Function FormatAccNonAccRecordCnt(S: String): String;
Function GetSpouseBirthDate(RetNo: integer): String;
Procedure GetChartColors(Var ChartColor: Array of TColor);
Function IsStringInList(S: String; AList: TStringList): integer;
function GetFormAbrevName(FormNo: integer): String;
function GetLastYearFormAbrevName(FormNo: integer): String;
function GetFormAbrevNameWithNoInst(FormNo: integer): String;
Function GetClientLettersDir: String;
Function MkClientLetterName(RetNo: integer): String;
// procedure ExecuteForm(AFormClass: TFormClass); //20160612 Igor (Duplicate vtCommon)
Function GetHlpTopicFromLineRef(FormName: String; FieldId: integer): String;
Function CalcMaxDonations(RetNo: integer): Real;
Function RemoveChar(S: string; Ch: String): string;
Function IsSelfEmployed(RetNo: integer): Boolean;
Function GetSelfEmplIncome(RetNo: integer): Real;
Function GetOriginalTransmUser(FlName, FileType: string): String;
Procedure LoadPrvRates;
Function CalcMedicalLimit(RetNo: integer): Real;
Function GetPrvIndex(SPrv: string): integer;
Function XferToQuebec(RetNo: integer): Real;
Function CalcAgeTo(BirthDate: string; ToDate: string): integer;
Function RemoveHyphens(S: string): string;
Function GetParentRetNo(Sin: String): integer;
Function NoDecimal(S: string): String;
Function GetMotorCCAForGST370(RetNo: integer): Real;
Function GetGST370EXP(RetNo: integer): Real;
Function ForPensDed(RetNo: integer): Real;
Procedure SumSlips(RetNo: integer; FName: string);
Function IsFormMultiInst(Frm: String): Boolean;
Function GetFormFee(RetNo: integer; FName: String; Qty: integer): Real;
Function IsReturnPaid(RetNo: integer): Boolean;

Function GetAreaCode(RetNo: integer): String;
Function GetPhoneNo(RetNo: integer): String;
Function GetFaxNo(RetNo: integer): String;
Function GetLastName(RetNo: integer): String;
Function GetSpouseSIN(RetNo: integer): String;
Function GetSpouseLastName(RetNo: integer): String;
Function GetSpouseFirstName(RetNo: integer): String;
Function GetSpouseAddress(RetNo: integer): String;
Function GetFirstName(RetNo: integer): String;
Function GetSinNo(RetNo: integer): String;
Function GetSpouseSinNo(RetNo: integer): String;
Function GetFullAddress(RetNo: integer): String;
Function GetPrvYear(ThisYear: String; No: integer): String;
Function Pars(Msg: string; elm: integer; Delimiter: string): string;
Procedure TotT2125(RetNo: integer);
Procedure ExpandTabs(Var AList: TStringList);
Function InvalidAmountInLetter(S: string): Boolean;
Function IsFormMultiPage(FormName: String): Boolean;
Function MultiPage1(Frm: string; Inst: string; MxPg: integer): Boolean;
Function MultiPage23(Frm: string; Inst: string; MxPg: integer): Boolean;

Procedure GetListInvoiceForms(RetNo: integer; Var Frms: TStringList;
  Var HowMany: TStringList);
Procedure CountMultiesForInvoice(RetNo: integer; Var Frms: TStringList;
  Var HowMany: TStringList);

Function CountPagesGenerated(RetNo: integer): integer;

procedure SaveFormsTableToFile;
procedure InitFormsTable;
procedure InitLastYearFormsTable;

Function ClcR(FieldId: integer; PgmValue: Real; FormOvrSw: Boolean;
  RetNo: integer; FormNo: integer): Real;
// keep app-specific delegates
Function EditDate(S: String; MxYear: integer): Boolean;
Function EditDateYYYYMMDD(S: String; MxYear: integer): Boolean;

Function CalcAge(BirthDate: string): integer;

Procedure T4RSPProcess(RetNo: integer; Var T4RspIncome: Real;
  Var T4RspOthDed: Real; Var T4RspTax: Real; Var T4RspSpBox20: Real;
  Var T4RspSpBox22: Real; Var T4RspSpBox26: Real);

Procedure T3MultProcess(RetNo: integer; Var T3OthInc: Real; Var T3Pens: Real;
  Var T3itc: Real; Var T3xii: Real; Var T3ElgblQSB1: Real;
  Var T3ElgblQFP1: Real; Var T3ElgblOTH1: Real; Var T3ElgblOTH2: Real;
  Var T3ElgblOTH3: Real; Var T3NonElgblGains1: Real; Var T3Dividends: Real;
  Var T3DividendsEligible: Real; Var T3FNonBusInc1: Real;
  Var T3FNonBusInc2: Real; Var T3FNonBusInc3: Real; Var T3FNonBusTax1: Real;
  Var T3FNonBusTax2: Real; Var T3FNonBusTax3: Real; Var T3FBusInc1: Real;
  Var T3FBusInc2: Real; Var T3FBusInc3: Real; Var T3FBusTax1: Real;
  Var T3FBusTax2: Real; Var T3FBusTax3: Real; Var T3FarmElgbl: Real;
  Var T3OthElgbl: Real; Var T3QFPElgbl: Real; Var T3ElgblQSB2: Real;
  Var T3ElgblQFP2: Real; Var T3ElgblQSB3: Real; Var T3ElgblQFP3: Real;
  Var T3NonElgblGains2: Real; Var T3NonElgblGains3: Real;
  //Var T3Box52: Real;
  //Var T3Box53: Real;
  //Var T3Box54: Real;
  Var T3Box55: Real;
  //Var T3Box56: Real;
  Var T3Box57: Real);
  //Var T3Box58: Real;
  //Var T3Box59: Real); // 20250112

Procedure T5MULTProcess(RetNo: integer; Var T5Interest: Real; Var T5Pens: Real;
  Var T5NonElgblGains: Real; Var T5Dividends: Real;
  Var T5DividendsEligible: Real; Var T5FNonBusInc1: Real;
  Var T5FNonBusInc2: Real; Var T5FNonBusInc3: Real; Var T5FNonBusTax1: Real;
  Var T5FNonBusTax2: Real; Var T5FNonBusTax3: Real; Var T5OthEmpl: Real);

Procedure T101Process(RetNo: integer; Var T101CEE: Real; Var T101AllowCEE: Real;
  Var T101CDE: Real; Var T101AllowCDE: Real; Var T101COGPE: Real;
  Var T101AllowCOGPE: Real);

Procedure T102Process(RetNo: integer; Var T102CEE: Real; Var T102AllowCEE: Real;
  Var T102CDE: Real; Var T102AllowCDE: Real; Var T102COGPE: Real;
  Var T102AllowCOGPE: Real; Var T102PShipInc: Real);

// 20121116
Procedure T4APProcess(RetNo: integer; Var T4APOAS: Real; Var T4APCppBnf: Real;
  Var T4APDisabBnf: Real; Var T4APTax: Real; Var T4APCppMonths: integer;
  Var T4APDisabMonths: integer);
(*
  Procedure T4APProcess(RetNo:integer;
  Var T4APOAS:real;Var T4APCppBnf:real;Var T4APDisabBnf:real;
  Var T4APTax:real;Var T4APCppMonths:integer;T4APDisabMonths:Integer);
*)
Procedure T4Process(RetNo: integer; var T4Gross: Real; var T4Don: Real;
  var T4Union: Real; var T4Commissions: Real; var T4PAdj: Real; var T4Rpp: Real;
  var T4FreeLoan: Real; var T4StockOptions: Real; var T4Tax: Real;
  var T4UIEarnings: Real; var T4CppEarnings: Real; var T4UIPremium: Real;
  var T4CPPPremium: Real; var T4QppPremium: Real; var T4UiWeeks: integer;
  Var T4NorthA: Real; Var T4NorthB: Real; Var T4PastRPPW: Real;
  Var T4PastRPPWNot: Real; Var T4Indian: Real);

Procedure T4AProcess(RetNo: integer; Var T4AOthInc: Real; Var T4APens: Real;
  Var T4ARPP: Real; Var T4APAdj: Real; Var T4AOthEmpl: Real; Var T4ADon: Real;
  Var T4ATax: Real; Var T4ANorthA: Real; Var T4ANorthB: Real;
  Var T4APastRppW: Real; Var T4APastRppWNot: Real; Var T4ARESP: Real;
  Var T4ARespEduc: Real; Var T4AResp22: Real;
  Var T4AAnnuity, T4ARDSP, T4ACovidIncome: Real); // 20210315

Procedure T4RIFProcess(RetNo: integer; Var T4RIFOthInc: Real;
  Var T4RIFPens: Real; Var T4RIFTax: Real; Var T4RIFAnnuity: Real;
  Var T4RIFSpBox16: Real; Var T4RIFSpBox20: Real; Var T4RIFSpBox24: Real);

function IsShowFlagIndicator(FName: String): Boolean;
function IsShowHdrIndicator(FName: String): Boolean;
Procedure RemoveLastEmptyLines(Var TempList: TStringList);
// Function ValidateTextLine(Txt:String; Var Cursor_position:integer; Var KeyWLength:Integer):boolean;
Procedure RemoveEmptyLines(Var TempList: TStringList);
{ Procedure SelectLetterName(LetterReturnType:String;ParagraphName:String); }
Procedure LoadLetter(Var TempList: TStringList; LetterName: String);
// procedure InterpretTextLine(RetNo:Integer;Var Txt:String);
// procedure InterpretTextLine(Var  Txt:String);
Procedure ReplaceKeyWord(Var Txt: String; Cursor_Position: integer;
  KeyWLength: integer; ReplaceString: String);
// procedure ConditionEvaluator(CStr:string;var CCheck:boolean; var error:boolean);
// procedure StringConditionEvaluator(CStr:string;var CCheck:boolean; var error:boolean);
Procedure ReplaceText(LetterBody: TMemo; Cursor_Position: integer;
  KeyWLength: Byte; ReplaceText: string);
function GetDataDictElmNo(KeyW: String): integer;
function GetDataDictFormName(KeyW: String): String;
function InDataDict(KeyW: String): Boolean;
Function InsertPenniesDot(S: string): String;
function GetWhiteBoxesIndicator(FName: String): Boolean;
Function ExtractNonInstFormName(FormName: string): string;

Function TotMultiple(RetNo: integer; NonInstFormName: String;
  elm: integer): Real;
// Function GetNSHospRate(SomeInc:Real;MarSt:integer):Real;

Function IsDisabled(RetNo: integer): Boolean;
Function SpouseDisabled(RetNo: integer): Boolean;
Function ExtractFormInst(FormName: String): string;
// function GetFormName(FormNo: integer):String;
function GetFormName(const RetNo: integer; FormNo: integer): String;
function GetFName(AbrevName: String): String;
function GetLastYearFName(AbrevName: String): String;
// function GetFormNo(FormName: String):Integer;
// function GetFormNo(const RetNo: integer; FormName: String):Integer;
function GetFormNo(FormName: String; RetNo: integer = 0): integer;
function GetLastYearFormNo(FormName: String): integer;
function GetLastYearFormName(FormNo: integer): String;
function GetFormDescr(RlName: String): String;
Procedure UpdateAllDataIndicators(RetNo: integer);
Function GetSpRetNo(RetNo: integer): integer;
Function GetFPENSByCountry(RetNo: integer; Country: String;
  AmtType: String): Real;
Function GetForeignFromSlip(RetNo: integer; FormName: string; Row: integer;
  ExchRow: integer; ShareRow: integer; CountryCode: integer;
  CountryRow: integer): Real;
Function T4AEligible(RetNo: integer; FormName: string): Real;
Function T4ANonEligible(RetNo: integer; FormName: string; Row: integer): Real;
Function GetRowFromSlip(RetNo: integer; FormName: string; Row: integer;
  ExchRow: integer; ShareRow: integer): Real;
Function CalcDaysInCan(RetNo: integer): integer;
Function WhichCreditForm(RetNo: integer; ShortPrv: string): String;
Function WhichTaxForm(RetNo: integer; ShortPrv: string): String;
Function ReformatSin(S: string): String;
Function RemovePenniesDot(S: string): String;
Function MakeEFFileName(LicenseLevel: string): string;

Function EditLongPrv(Value: string): Boolean;
// Procedure GetCalendar;
Function FormatAmount(S: string; VerticalSeparator: Boolean): string;
Function FormatPrintAmountForT1273(S: string; VerticalSeparator: Boolean;
  FName: String; elm: integer): string;
{ File i/o }
Function FileNameValid(FlName: string): Boolean;
Function CopyReturn(DataDir: String; FileName: String;
  DestinationDir: string): Boolean;
// Function GetUserProfile(UserName:string): boolean; //20170112 Igor (move to TUserProfile)
Function CreateDataDirectory(AppDir: string; DataDir: string): integer;
Function InitDataBase(const DataDir: string; Out Msg: String): Boolean;
procedure UpdateDbStructure; // 20200914 Igor
// 20171031 Igor
Procedure ShowOpenReturnFailure(FailCode: integer; DataDir: String;
  FlName: string);

procedure LoadDataDict;

Procedure ShowHelp(HelpFile: String; Helptopic: string;
  AisWeb: Boolean = false); // 20160801 Igor

Procedure SwapStrings(S1: string; S2: string);
Function ExtractDecimalPart(S: string): string;
Function ExtractIntegerPart(S: string): string;
Function InsertCommas(S: string): String;
Function VL(S: string): Real;
Function MyStrToInt(S: string): integer;

Function InvalidNAICS(NaicsCode: String): Boolean; // 20160118 Igor
Function SeparatedForLessThan90Days(RetNo: integer): Boolean;
// 20151220 //20160119 Igor
Procedure CreateFileWithEFValues(XmlFlName, OutputFlName: String);
// 20160125 Igor
Function isAutofilled(RNo: integer): Boolean; // 20160126 Igor
Function IsAuthRepDoneForTdd(RNo: integer): Boolean; // 20160126 Igor
Function MkTddFileName(RNo: integer; Sin: String): String; // 20160126 Igor
Procedure UpdateNetCapitalLossesFromTdd(RNo: integer); // 20160126 Igor
Procedure UpdateCapitalGainsFromTdd(RNo: integer); // 20160126 Igor
Function IsAbilNdx(i: integer): Boolean; // 20160126 Igor
Procedure UpdateNonCapitalLossesFromTdd(RNo: integer); // 20160126 Igor
Function GetStreetAddress(RetNo: integer): String; // 20160126 //20160202 Igor
Function ValidPin(S: String): Boolean;
Function PaddL(S: string; MaxLength: integer): string;
// 20160127 //padd to the left with spaces
Function GetEfilerNo: String;
Function HasNonQCT4Income(RetNo: integer): Boolean; // 20160216 Igor
Function IsCraOpenForEfile: Boolean; // 20160216 Igor
Function IsTDDOpenForUse: Boolean; // 20160216 Igor
Procedure ShowCraIsClosed; // 20160216 Igor
Procedure ShowTDDNotAvailableForUse; // 20160216 Igor
// 20160205
Function GetDateTimeHoursMinutesSeconds(Dt: TDateTime): String;
// 20160213 //20160216 Igor
Function AddDateTimeSuffixToFileName(FileNm: String): String;
// 20160213 //20160216 Igor
Function CfrAFillHasData(RetNo: integer; FNo: integer): Boolean;
// 20160216 Igor
Function CountT5008DtlSlips(RetNo: integer): integer; // 20160120

Procedure GetDepentantsList(RetNo: integer; FName: string; FNo: integer);
procedure OpenTheTddElmsTable; // 20160327
Function IsDataGroupASlip(DataGroup: String): Boolean; // 20160327
// Function TAutoFillFrm.IsDataGroupASlip(DataGroup:String):Boolean;  //20160327
procedure HorScrollBarInListBox(ListBox: TListBox; MaxWidth: integer);
function ImportOneReturn(ADS: TDataSet; ASrcDir, ADstDir: String;
  out AErr: String; AOverride: Boolean): Boolean;
function GetLastYearFile(ARetNo: integer): String; // 20160701 Igor
procedure SetLastYearFile(const ARetNo: integer; AValue: String);
// 20160701 Igor

function AllowExportToFile(ARetNo: integer): Boolean; // 20170112 Igor

// 20190709 Igor >>>
procedure InitOldToNewLnDict;
function ConvertOldToNewLn(AOld: integer): integer;
// 20190709 Igor <<<

// 20200914 Igor >>>
function GenerateCloudFileName(ASIN, ALastName, AFirstName, AFileNameFormat
  : string): string; // 20200921 Igor
function GetRealReturnFileName(ADataDir, AFileName, ASIN, ALastName,
  AFirstName: string): string;
// 20200914 Igor <<<
function GenerateReturnFileName(ARetNo: integer; AFileNameFormat: string)
  : string; // 20200921 Igor
function GetDefaultFileExt: string; // 20201013 Igor
// 20220510 Igor >>>
function GenerateT5008ExcelFile(ARetNo: integer): string;
procedure CreateT5008Excel(ReceivedFile: String; ExcelFileName: String);
procedure OpenT5008Excel(ARetNo: integer);

  function GetDcnSeqNoFor(RetNo: Integer; OnLineNo: string): string; //20251229 Igor
  function PCPM(aVal, aPercent: Currency): Currency; //Perform the Correct Percentage Multiplication //20260311 Igor

implementation

uses
  HtmlHelp, IniFiles, Registry, ClipBrd,
  vtCommon, vtDialogs, vtMain, vtRichText,
  T1_2026, T1_2026T1Rtns,
  T1_2026T1Rtns2, T1_2026Pdf417, T1_2026MSSOAPLib30_TLB,
  T1_2026MsXml2_TLB, T1_2026Common2, T1_2026ChildWinNew, T1_2026Common,
  T1_2026Main,
  T1_2026CalcBus, T1_2026Calc, T1_2026Calc3, T1_2026Calc4, T1_2026Features,
  T1_2026Calc2, // 20220220
  T1_2026BarDataGen, T1_2026Print,
  vtPrints, vtTrimStr, vtShared, variants,
  vtDataBase, vtDataModuleUnit, // 20150825 igor;
  fConvertToMultiApp, System.StrUtils; // 20160530 Igor //20220511 Igor
// fConvertToMultiApp; // 20160530 Igor
// vtFileStorage; //20160819 Igor //20160820 Igor

const
  c_DefDataDir = '{DataDir}'; // 20171204 Igor
  // c_RefileDir = '{RefileDir}'; //220240606
  // 20170112 Igor >>>
  // OptionsArray: Array [0 .. 113, 0 .. 3] of string =  if we have dir_refile
  OptionsArray: Array [0 .. 112, 0 .. 3] of string =
  // 20170130 Igor  //20200529 from 110 after adding PRN_hideSin //20200925 Igor
  // Options Name        Default Value                 Caption    Fill Default
    (('Opr_GstHst', '7', 'GST/HST rate', 'X'), { 0 }
    ('Prp_Bill', '2', 'Default Billing Option', 'X'),
    ('Prp_VSFee', '30', 'Flat Fees ($): Very small', 'X'),
    ('Prp_SFee', '50', 'Flat Fees ($): Small', 'X'),
    ('Prp_AFee', '70', 'Flat Fees ($): Average', 'X'),
    ('Prp_CFee', '100', 'Flat Fees ($): Complex', 'X'),
    ('Prp_VCFee', '150', 'Flat Fees ($): Very Complex', 'X'),
    ('Prp_Hour', '60', 'Charge per hour ($)', 'X'),
    ('FormZoom', '100', 'Form Size (zoom) in effect', 'X'),
    ('ActiveBoxColor', '8421631', 'Active box color', 'X'),
    ('FirstReturnColor', '16777155', 'First return color', 'X'), { 10 }
    ('UseFormSearch', 'X', 'Use FORM vs Line as default search', 'X'),
    ('RetainRetColor', 'X', 'Retain return Color upon saving it', 'X'),
    ('Use2YearSummary', 'X', 'Use 2-year summary as default', 'X'),
    ('OpenCouple', 'X', 'Open couple without warning', 'X'),
    ('PstOnInvoice', '', 'Use PST on Invoice', 'X'), ('OtherSlipsButtons', 'X',
    'Show Other Slips buttons', 'X'), ('ShowUsedForms', '',
    'Show forms used last time you saved ', 'X'),
    ('OpenAtLastForm', '', 'If ticked, open at last form used', 'X'),
    ('Opr_Close', 'X', 'Opr_Close', 'X'), { TODO : check }
    ('Prn_NameH', 'X', 'In tax forms, print: Client Name on Headings',
    'X'), { 20 }
    ('Prn_PIPEDAAll', '',
    'Print the Privacy Letter (PIPEDA) not only in New but also in Old returns',
    'X'), ('Prn_SinH', 'X', 'In tax forms, print: SIN on Headings', 'X'),
    ('Prn_HideSin', 'X', 'In tax forms, print: Hide Sin partally', 'X'),
    // 20200529
    ('Prn_DateH', 'X', 'In tax forms, print: Date on Headings', 'X'),
    ('Prn_LMargin', '0.75', 'Client Letters Printing: Left margin in inches',
    'X'), // 20160721 Igor
    ('Prn_RMargin', '0.5', 'Client Letters Printing: Right margin in inches',
    'X'), // 20160721 Igor
    ('Prn_FontIncr', '1', 'Printing Font Size Increment: Increment by (0 or 1)',
    'X'), ('DataInBold', '', 'Show data in Bold in all forms', 'X'),
    ('MaximizeMainForm', 'X', 'Maximize main form at startup', 'X'),
    ('HideMostRecent', '', 'Hide most recent returns', 'X'),
    ('BarCode', 'X', 'BarCode', 'X'), { 30 } { TODO : check }
    ('T1013AuthorLevel', '2',
    'T1013-DEFAULT AUTHORIZATION: 1=Disclose    2=Disclose/Request Changes',
    'X'), ('CVSetting', '',
    'PRE-ASSESSMENT CONTACT (CV)  (2=By Mail  3=Client)', 'X'),
    ('CVPostSetting', '', 'POST-ASSESSMENT CONTACT (CV)  (2=By Mail  3=Client)',
    'X'), ('ShowFinWarning', '', 'Show Financial Warning', 'X'),
    ('ShowConsultantOnInv', '',
    'INVOICE: Multi-office version only: Show Consultant name on invoice', 'X'),
    ('UseFastPrint', '', 'Use Fast Print method', 'X'),
    ('UseProperName', 'X',
    'CLIENT LETTERS: Show proper format (Capitalize only first letter)  in Name and Address',
    'X'), ('UseCondominiumLine', 'X',
    'BUSINESS USE OF HOME: Show Condominium/Telephone expense lines', 'X'),
    ('NoTypeAhead', '', 'DO NOT USE PREDICTIVE TYPING (Super Entry)', 'X'),
    ('RolloverT4T5', 'X',
    'Rollover names of T4/T5  (Option in Roll-over from last year)',
    'X'), { 40 }
    ('DecimalAssume', '',
    'CANADIAN CITIZEN: If Checked, the Canadian Citizen question on Page 1, defaults to Yes',
    'X'), ('ShowInvoiceWarning', 'X',
    'INVOICE: Show warning  if invoice not prepared', 'X'),
    ('ShowInvoiceEfCharge', 'X', 'INVOICE: Show Efile charge as separate item',
    'X'), ('ShowSaluteWarning', 'X',
    'SALUTATION: Show Warning if client Title (Mr, Mrs..) not entered', 'X'),
    ('UpdateFrequency', '7',
    'Internet Updates: Check automatically every X deys', 'X'),
    ('Nfl_Efile', 'X', 'Check if most returns are EFiled', 'X'),
    ('Nfl_Prov', 'ON', 'Default values for tax returns: DEFAULT PROVINCE', 'X'),
    ('Nfl_City', 'TORONTO', 'Default values for tax returns: DEFAULT CITY',
    'X'), ('Ef_Method', 'EOL', 'Default Efile method', 'X'),
    ('Prp_Elect', 'X',
    'ELECTIONS CANADA: If checked, the Elections Canada question on Page 1, defaults to Yes for new returns',
    'X'), { 50 }
    ('Prp_Citizen', '',
    'CANADIAN CITIZEN: If Checked, the Canadian Citizen question on Page 1, defaults to Yes',
    'X'), ('Prp_EfRepr', '',
    'T183 REPRESENTATION: If checked, the Representation question in T183, defaults to Yes for new returns',
    'X'), ('Nfl_Disced', '1', 'COMPENSATION FOR RETURN PREPARATION', 'X'),
    ('Capitalization', 'UpperCase', 'NAME/ADDRESS CAPITALIZATION: Convert to',
    'X'), ('T1013Warn', 'IfNotLastYear', 'T1013 WARNING IF FORM NOT COMPLETED',
    'X'), ('EscOption', 'CloseForm', 'ESC key - When pressed on a form it will',
    'X'), ('AutoSeniorDiscount', '',
    'Discount for seniors: Apply automatically', 'X'),
    ('DiscountForSeniors', '0', 'Discount for seniors: Discount', 'X'),
    ('RolloverProgram', 'VisualTax', 'PROGRAM name used last year', 'X'),
    ('DecimalAssume', '',
    'DECIMAL ASSUME (if you enter 12345 it will register as 123.45) DO NOT TICK it unless you are used to it',
    'X'), { 60 }
    ('Dir_Cur', c_DefDataDir + '\Data', 'Current Directory', 'X'),
    // ('Dir_Refile', c_RefileDir + '\EfiledReturns', 'Refile Directory', 'X'),  //20340606
    // 20171204 Igor
    ('Dir_ClientDocs', c_DefDataDir + '\ClientDocs',
    'Client Documents Directory', 'X'), // 20171204 Igor
    ('Dir_PermanentDocs', 'C:\T1-Permanent-Client Documents',
    'Client Permanent Docs Directory', 'X'), // 20170130 Igor
    ('BackUpFrequency', '7', 'Remind me to backup data every X deys', 'X'),
    ('BackUpDir', c_DefDataDir + '\BackUp', 'Default Backup directory', 'X'),
    // 20171204 Igor
    ('LastBackUpDir', '', 'Most recent back up folder', 'X'),
    ('Dir_Deflt', c_DefDataDir + '\Data', 'Default Directory', 'X'),
    // 20171204 Igor
    ('Dir_Planner', c_DefDataDir + '\Planner', 'Tax Planner Dir.', 'X'),
    // 20171204 Igor
    ('Dir_LastYr', '', 'DATA DIRECTORY used last year', 'X'),
    ('Dir_AutoFill', c_DefDataDir + '\Autofill', 'Auto-fill data directory',
    'X'), // 20171204 Igor        {70}
    ('Dir_PgmLastYr', '', 'PROGRAM dir last year (optional)', 'X'),
    ('Dir_DBFData', '',
    'Data directory of the T1-2017 production data prior to Multi-App. Typically enter  C:\T1-2017\data. To be used as the source to import data into the Multi-App version',
    'X'), ('Prp_Name', '', 'Preparer Identification: Company Name', ''),
    ('Prp_FirstName', '', 'Preparer Identification: First name', ''),
    ('Prp_LastName', '', 'Preparer Identification: Last Name', ''),
    ('Prp_RepId', '', 'T1013 RepId', ''),
    ('Prp_EMail', '', 'Preparer Identification: Email Address', ''),
    ('Prp_BusNo', '', 'T1013 Business No', ''),
    ('Reviewer_Name', '', 'Reviewer Identification: Name', ''),
    ('Reviewer_EMail', '', 'Reviewer Identification: EMail', ''), { 80 }
    ('Reviewer_Area', '', 'Reviewer Identification: Tel. Area', ''),
    ('Reviewer_Tel', '', 'Reviewer Identification: Tel. Number', ''),
    ('Prp_Street', '', 'Preparer Identification: Street', ''),
    ('Prp_City', '', 'Preparer Identification: City', ''),
    ('Prp_Prov', '', 'Preparer Identification: Province', ''),
    ('Prp_Postal', '', 'Preparer Identification: Postal', ''),
    ('Prp_Countr', '', 'Preparer Identification: Country', ''),
    ('Prp_Area', '', 'Preparer Identification: Tel. Area', ''),
    ('Prp_Tel', '', 'Preparer Identification: Tel. Number', ''),
    ('Prp_FxArea', '', 'Preparer Identification: Fax Area', ''), { 90 }
    ('Prp_Fax', '', 'Preparer Identification: Fax Number', ''),
    ('Prp_DiscNo', '', 'Discounter data: Registration Number', ''),
    ('Prp_DiscNm', '', 'Discounter data: Proprietor Name', ''),
    ('Prp_GSTNo', '', 'GST No', ''), ('SerializeInvoice', '',
    'Serialize Invoice No', ''), ('Prp_Dates', '',
    'SIGNATURE DATE: If checked, the program will automatically fill Signature dates with today''s date',
    ''), ('Prn_Disclm', '',
    'DISCLAIMERS  (Leave it blank, if not required): On T1 Page 4', ''),
    ('Bus_Disclm', '',
    'DISCLAIMERS  (Leave it blank, if not required): On S/E Statements', ''),
    ('Opr_PST', '', 'PST Rate', ''), ('ShowVisitedForms', '',
    'ShowVisitedForms', ''), { TODO : Check }             { 100 }
    ('InvPrefix', '', 'Enter at least the Starting Seq. No.: Prefix', ''),
    ('InvStartNo', '', 'Enter at least the Starting Seq. No.: Starting Seq No',
    ''), ('InvSuffix', '', 'Enter at least the Starting Seq. No.: Suffix', ''),
    ('InvFoot1', '',
    'Invoice footer (Free format text to appear at bottom of Invoice) 1', ''),
    ('InvFoot2', '',
    'Invoice footer (Free format text to appear at bottom of Invoice) 2', ''),
    ('InvFoot3', '',
    'Invoice footer (Free format text to appear at bottom of Invoice) 3', ''),
    ('InvFoot4', '',
    'Invoice footer (Free format text to appear at bottom of Invoice) 4', ''),
    ('InvFoot5', '',
    'Invoice footer (Free format text to appear at bottom of Invoice) 5', ''),
    ('NoBarCode', '',
    'DO NOT Print BarCode in Client Copy (The CRA Filing Copy will always print the BarCode)',
    ''), ('RetainDefaultPrinter', '',
    'Retain default printer between successive print requests', ''), { 110 }
    ('FileNameFormat', '1', 'File Rename Format', 'X') // 20200925 Igor
    // 20161210 Igor
    (* ,
      ('DropBox_ClientID',    '',                         'Client ID from DropBox', ''),{110}
      ('DefaultSaveToCloud',  '',                         'Default save returns to cloud','') //20161208 Igor
    *)
    );
  // 20170112 Igor <<<

function GenerateT5008ExcelFile(ARetNo: integer): string; // 20220510 Igor
begin
  if ARetNo = 0 then
    raise Exception.Create('Please, open return first');
  Result := OptRec.Dir_ClientDocs + '\' + RetList[ARetNo].GetLastName + ',' +
    RetList[ARetNo].GetFirstName + '\' + AppYear + '-' + 'T5008Excel.xlsx';
end;

procedure CreateT5008Excel(ReceivedFile: String; ExcelFileName: String);
// 20220510 Igor
var
  i, j, k: integer;
  S, Section, SubSection, DataElmName, Instance, Value, BoxNo: String;
  // 20220511 Igor
  A: TArray<string>;
  FList: TStringList;
  FCaptions: TList<string>;
  FCurrSlipNo: integer;
  arrSlips: array of TDictionary<integer, string>;
  arrData: Variant;

  // 20220511 Igor >>>
  TddElmsConnection: TADConnection;
  TddElmsTable: TADTable;
  // 20220511 Igor <<<

  FSaveSheetsCount: integer;
  FSaveFormat: integer;
  xlApp, xlBook, xlSheet, xlRange: OLEVariant;

  function TranslateDataElmName(ADataElmName: string): string; // 20220511 Igor
  begin
    if SameText(ADataElmName, 'CurrencyTypeCode') then
      Result := 'Currency'
    else if SameText(ADataElmName, 'SecuritySettlementAmount') then
      Result := 'Settlement'
    else if SameText(ADataElmName, 'SecurityFaceValueAmount') then
      Result := 'Face Value'
    else if SameText(ADataElmName, 'SecurityBookValueAmount') then
      Result := 'Cost Book Value'
    else if SameText(ADataElmName, 'DisposedSecurityTypeCode') then
      Result := 'Security Type'
    else if SameText(ADataElmName, 'ReportedSlipRecipientTypeCode') then
      Result := 'Recipient Type'
    else
      Result := ADataElmName;
  end;

  procedure SetBorders(ARange: OLEVariant; AWeight, ALineStyle: integer);
  const
    xlEdgeLeft = 7;
    xlEdgeTop = 8;
    xlEdgeBottom = 9;
    xlEdgeRight = 10;
    xlInsideVertical = 11;
    xlInsideHorizontal = 12;
    xlAbove = 0;
    xlBelow = 1;
    xlLeft = -4131;
    xlRight = -4152;
  begin
    ARange.Borders.Item[xlEdgeLeft].Weight := AWeight;
    ARange.Borders.Item[xlEdgeLeft].LineStyle := ALineStyle;
    ARange.Borders.Item[xlEdgeTop].Weight := AWeight;
    ARange.Borders.Item[xlEdgeTop].LineStyle := ALineStyle;
    ARange.Borders.Item[xlEdgeRight].Weight := AWeight;
    ARange.Borders.Item[xlEdgeRight].LineStyle := ALineStyle;
    ARange.Borders.Item[xlEdgeBottom].Weight := AWeight;
    ARange.Borders.Item[xlEdgeBottom].LineStyle := ALineStyle;
    ARange.Borders.Item[xlInsideVertical].Weight := AWeight;
    ARange.Borders.Item[xlInsideVertical].LineStyle := ALineStyle;
    ARange.Borders.Item[xlInsideHorizontal].Weight := AWeight;
    ARange.Borders.Item[xlInsideHorizontal].LineStyle := ALineStyle;
  end;

begin
  // 20220511 Igor >>>
  TddElmsConnection := TADConnection.Create(nil);
  TddElmsTable := TADTable.Create(nil);
  if not SetTableName(TddElmsConnection, TddElmsTable,
    IncludeTrailingPathDelimiter(AppDir) + TddElmsDBLite, TddElmsTableLite,
    'FIELDKEY') then
  begin
    FreeAndNil(TddElmsConnection);
    FreeAndNil(TddElmsTable);
    MessageDlg(TddElmsDBLite + ' is missing', mtError, [mbOk], 0);
    Exit;
  end;
  // 20220511 Igor <<<

  FList := TStringList.Create;
  FCaptions := TList<string>.Create;
  try
    FList.LoadFromFile(ReceivedFile);
    FCurrSlipNo := -1;
    // reading data from received file
    for i := 0 to FList.Count - 1 do
    begin
      A := FList.Strings[i].Split([AFRStringDelimiter]);
      if Length(A) < 5 then
        continue;
      SubSection := AllTrim(A[1]);
      if not SameText(SubSection, 'T5008Slip') then
        continue;
      DataElmName := AllTrim(A[2]);
      if SameText(DataElmName, 'TaxYear') then
      begin
        inc(FCurrSlipNo);
        SetLength(arrSlips, FCurrSlipNo + 1);
        arrSlips[FCurrSlipNo] := TDictionary<integer, string>.Create;
      end;
      if FCurrSlipNo = -1 then
        raise Exception.Create
          ('ReceivedFile contains incorrect data elms. First DataElm for T5008Slip is '
          + DataElmName + ', but it should be TaxYear');
      Value := AllTrim(A[4]);
      // 20220511 Igor >>>
      if TddElmsTable.FindKey([SubSection + '-' + DataElmName]) and
        not TddElmsTable.FieldByName('BoxNo').AsString.IsEmpty
      // skip elements with empty BoxNo
      then
      begin
        DataElmName := TddElmsTable.FieldByName('BoxNo').AsString + '#' +
          AnsiReplaceStr(TranslateDataElmName(DataElmName), ' ', '_');
        if not FCaptions.Contains(DataElmName) then
          FCaptions.Add(DataElmName);
        if Assigned(arrSlips[FCurrSlipNo]) then
          arrSlips[FCurrSlipNo].AddOrSetValue
            (FCaptions.IndexOf(DataElmName), Value);
      end;
      // 20220511 Igor <<<
    end;

    // 20220511 Igor >>>
    // no T5008 slips
    if FCaptions.Count = 0 then
      Exit;

    // building matrix for excel spreadsheet
    arrData := VarArrayCreate([1, Length(arrSlips) + 1, 1, FCaptions.Count + 1],
      varVariant);
    arrData[1, 1] := 'Slip No';
    for j := 0 to Length(arrSlips) - 1 do
      arrData[j + 2, 1] := 'T5008DTL#' + IntToStr(j + 1);
    for i := 0 to FCaptions.Count - 1 do
    begin
      DataElmName := FCaptions.Items[i];
      arrData[1, i + 2] := DataElmName;
      for j := 0 to Length(arrSlips) - 1 do
      begin
        if arrSlips[j].TryGetValue(i, Value) then
          arrData[j + 2, i + 2] := Value
        else
          arrData[j + 2, i + 2] := '';
      end;
    end;
    // 20220511 Igor <<<

    if FileExists(ExcelFileName) then
      if not DeleteFile(PChar(ExcelFileName)) then
      begin
        ShowMessage('File ' + QuotedStr(ExcelFileName) +
          ' already exists and cannot be removed. ' +
          'T5008 slips will not be saved to Excel file');
        Exit;
      end;

    // connecting to excel and saving data matrix to spreadsheet
    xlApp := CreateOLEObject('Excel.Application');
    try
      FSaveSheetsCount := xlApp.SheetsInNewWorkbook;
      FSaveFormat := xlApp.DefaultSaveFormat;
      try
        xlApp.SheetsInNewWorkbook := 1;
        xlApp.DefaultSaveFormat := 51; // xlsx save format
        xlBook := xlApp.WorkBooks.Add;
        xlSheet := xlBook.ActiveSheet;
      finally
        xlApp.SheetsInNewWorkbook := FSaveSheetsCount;
        xlApp.DefaultSaveFormat := FSaveFormat;
      end;

      // 20220511 Igor >>>
      xlRange := xlSheet.Range[xlSheet.Cells[1, 1],
        xlSheet.Cells[Length(arrSlips) + 1, FCaptions.Count + 1]];
      xlRange.Value := arrData;

      SetBorders(xlRange, 2, 1); // thin borders

      xlRange := xlSheet.Range[xlSheet.Cells[1, 1],
        xlSheet.Cells[1, FCaptions.Count + 1]];
      SetBorders(xlRange, -4138, 1); // thick borders
      // xlRange.Font.Bold := true;

      xlRange := xlSheet.Range[xlSheet.Cells[1, 1],
        xlSheet.Cells[Length(arrSlips) + 1, FCaptions.Count + 1]];
      xlSheet.Columns[1].EntireColumn.AutoFit;

      for i := 0 to FCaptions.Count - 1 do
      begin
        DataElmName := AnsiReplaceStr(xlSheet.Cells[1, i + 2].FormulaR1C1,
          '_', ' ');
        xlSheet.Cells[1, i + 2].FormulaR1C1 :=
          Copy(DataElmName, Pos('#', DataElmName) + 1, Length(DataElmName));
        xlSheet.Columns[i + 2].EntireColumn.AutoFit;
        xlSheet.Cells[1, i + 2].FormulaR1C1 := AnsiReplaceStr(DataElmName,
          '#', #13#10);
        BoxNo := Copy(DataElmName, 1, Pos('#', DataElmName) - 1);
        if SameText(BoxNo, '20') or SameText(BoxNo, '21') then
        begin
          xlSheet.Cells[Length(arrSlips) + 2, i + 2].FormulaR1C1 := '=SUM(R[-' +
            IntToStr(Length(arrSlips)) + ']C:R[-1]C)';
          SetBorders(xlSheet.Cells[Length(arrSlips) + 2, i + 2], 2, 1);
        end;
      end;
      xlRange.EntireRow.AutoFit;
      // 20220511 Igor <<<

      ForceDirectories(ExtractFilePath(ExcelFileName));
      xlApp.ActiveWorkbook.SaveAs(ExcelFileName, 51);
      xlApp.ActiveWindow.Close;
    finally
      if not VarIsEmpty(xlApp) then
      begin
        xlApp.Quit;
        xlApp := Unassigned;
        xlSheet := Unassigned;
      end;
    end;
  finally
    FList.Free;
    FCaptions.Free;
    // 20220511 Igor >>>
    FreeAndNil(TddElmsConnection);
    FreeAndNil(TddElmsTable);
    // 20220511 Igor <<<
  end;
end;

procedure OpenT5008Excel(ARetNo: integer); // 20220510 Igor
var
  ExcelFileName, ReceivedFile: string;
begin
  ExcelFileName := GenerateT5008ExcelFile(ARetNo);
  if not FileExists(ExcelFileName) then
  begin
    ReceivedFile := MkTddFileName(ARetNo, RetList[ARetNo].GetSIN);
    if FileExists(ReceivedFile) then
    // 20220511 Igor >>>
    begin
      CreateT5008Excel(ReceivedFile, ExcelFileName);
      Sleep(1000); // wait to close excel instance
    end;
    // 20220511 Igor <<<
  end;
  if FileExists(ExcelFileName) then
    ShellExecute(Application.MainForm.Handle, 'open', PChar(ExcelFileName), nil,
      nil, SW_SHOW)
  else
    ShowMessage('There is no T5008 Excel file for this return');
end;

function GetDefaultFileExt: string; // 20201013 Igor
begin
  Result := '.' + AppName + '-' + Copy(AppYear, 3, 2);
end;

function GenerateReturnFileName(ARetNo: integer; AFileNameFormat: string)
  : string; // 20200921 Igor
begin
  Result := GenerateCloudFileName(RetList[ARetNo].GetSIN,
    RetList[ARetNo].GetLastName, RetList[ARetNo].GetFirstName, AFileNameFormat);
end;

// //20201124 Igor <<<
function GenerateCloudFileName(ASIN, ALastName, AFirstName, AFileNameFormat
  : string): string; // 20200914 Igor //20200921 Igor //20201013 Igor
var
  nCountForTrunc: integer;
begin
  if AFileNameFormat = '0' then
    // 20201124 Igor >>>
    // Result := ASIN + GetDefaultFileExt
    Result := LeftStr(ASIN, 8) + '.' + RightStr(ASIN, 1)
    // 20201124 Igor <<<
  else
  begin
    if SameText(AFileNameFormat, 'old_cloud_format') then
      Result := NormalizeFileName(AllTrim(ALastName + ' ' + AFirstName) + '-' +
        '{' + LeftStr(ASIN, 8) + '.' + RightStr(ASIN, 1) + '}')
    else
      Result := NormalizeFileName(AllTrim(ALastName + ' ' + AFirstName) + '-' +
        '{' + ASIN + '}' + GetDefaultFileExt);
    if Length(Result) > 60 then
    begin
      nCountForTrunc := Length(Result) - 60;
      if Length(AFirstName) < nCountForTrunc then
      begin
        nCountForTrunc := nCountForTrunc - Length(AFirstName) + 1;
        AFirstName := Copy(AFirstName, 1, 1);
      end
      else
      begin
        AFirstName := Copy(AFirstName, 1, Length(AFirstName) - nCountForTrunc);
        nCountForTrunc := 0;
      end;
      if nCountForTrunc > 0 then
        ALastName := Copy(ALastName, 1, Length(ALastName) - nCountForTrunc);
      Result := NormalizeFileName(ALastName + ' ' + AFirstName + '-' + '{' +
        ASIN + '}.' + RightStr(AppYear, 2) + '');
    end;
  end;
end;

(*
  function GenerateCloudFileName(ASIN, ALastName, AFirstName, AFileNameFormat: string): string; //20200914 Igor //20200921 Igor //20201013 Igor
  var nCountForTrunc: integer;
  begin
  if AFileNameFormat = '0' then
  Result := ASIN + GetDefaultFileExt
  else
  begin
  if SameText(AFileNameFormat, 'old_cloud_format') then
  Result := NormalizeFileName(AllTrim(ALastName + ' ' + AFirstName)+'-'+'{'+ LeftStr(ASIN,8) + '.' + RightStr(ASIN,1) + '}')
  else
  Result := NormalizeFileName(AllTrim(ALastName + ' ' + AFirstName)+'-'+'{'+ ASIN + '}' + GetDefaultFileExt);
  if Length(Result) > 60 then
  begin
  nCountForTrunc := Length(Result) - 60;
  if Length(AFirstName) < nCountForTrunc then
  begin
  nCountForTrunc := nCountForTrunc - Length(AFirstName) + 1;
  AFirstName := Copy(AFirstName, 1, 1);
  end
  else
  begin
  AFirstName := Copy(AFirstName, 1, Length(AFirstName) - nCountForTrunc);
  nCountForTrunc := 0;
  end;
  if nCountForTrunc > 0 then
  ALastName := Copy(ALastName, 1, Length(ALastName) - nCountForTrunc);
  Result := NormalizeFileName(ALastName + ' ' + AFirstName+'-'+'{'+ ASIN + '}.' + RightStr(AppYear,2) + '');
  end;
  end;
  end;
*)
function GetRealReturnFileName(ADataDir, AFileName, ASIN, ALastName,
  AFirstName: string): string; // 20200914 Igor //20200921 Igor
var
  cCloudFile: string;
begin
  Result := AFileName;
  if not FileExists(TPath.Combine(ADataDir, AFileName)) then
  begin
    cCloudFile := GenerateCloudFileName(ASIN, ALastName, AFirstName,
      OptRec.FileNameFormat);
    if not FileExists(TPath.Combine(ADataDir, cCloudFile)) then
      cCloudFile := GenerateCloudFileName(ASIN, ALastName, AFirstName,
        'old_cloud_format');
    if FileExists(TPath.Combine(ADataDir, cCloudFile)) then
      Result := cCloudFile;
  end;
end;

procedure InitOldToNewLnDict; // 20190709 Igor
var
  L: TStringList;
  A: TArray<String>;
  i, nOld, nNew: integer;
begin
  OldToNewLnDict := TDictionary<integer, integer>.Create;
  L := TStringList.Create;
  try
    L.LoadFromFile(AppDir + '\' + 'OldToNewLN.d');
    for i := 0 to L.Count - 1 do
    begin
      A := L.Strings[i].Split([' '], ExcludeEmpty);
      if Length(A) < 2 then
        continue;
      nOld := StrToIntDef(A[0], 0);
      nNew := StrToIntDef(A[1], 0);
      if (nOld <> 0) and (nNew <> 0) then
        OldToNewLnDict.AddOrSetValue(nOld, nNew);
    end;
  finally
    L.Free;
  end;
end;

function ConvertOldToNewLn(AOld: integer): integer; // 20190709 Igor
begin
  if not Assigned(OldToNewLnDict) then
    InitOldToNewLnDict;
  if not OldToNewLnDict.TryGetValue(AOld, Result) then
    Result := AOld;
end;

Procedure GetParentsInfo(RetNo: integer);
// into somelist
Var
  i, RNo: integer;
begin
  SomeList.Clear;
  for i := 1 to (RetList.Count - 1) do
  begin
    RetRec := RetList.Items[i];
    if RetRec = nil then
      continue;
    RNo := RetRec.RetNo;
    If RNo <> RetNo then
      SomeList.Add(GetSinNo(RNo) + '  ' + GetFirstName(RNo) + ' ' +
        GetLastName(RNo));
  end;
end;

// 20210301
Function CalcMaxDonations(RetNo: integer): Real;
Var
  BFedTaxBfrDon: Real;
begin
  BFedTaxBfrDon := MaxR(0, VL(FetchElm(RetNo, 'T1', 132)) // 20220412
    // BFedTaxBfrDon := MaxR(0, VL(FetchElm(RetNo, 'T1', 130)) // line 39 of s1
    - Ret[RetNo].Lnn[33800] // 15% of NON ref
    - Ret[RetNo].Lnn[40425] // Fed div tx cr
    - Ret[RetNo].Lnn[40427]); // min tax carryover
  If BFedTaxBfrDon > 200 * (VL(Constant[RY].Rate1) / 100) then
    Result := 200 + (BFedTaxBfrDon - (200 * VL(Constant[RY].Rate1) / 100)) /
      (VL(Constant[RY].Rate4) / 100) // 0.29
  else
    Result := BFedTaxBfrDon / (VL(Constant[RY].Rate1) / 100); // 0.15
end;

(*
  //20210221
  //20191220
  Function CalcMaxDonations(RetNo: Integer): Real;
  Var  BFedTaxBfrDon,x,y: Real;
  B130,B142,B146: real;
  begin
  //this is the BFTax before donations
  Result:=
  VL(FetchElm(RetNo, 'T1', 130))
  -VL(FetchElm(RetNo, 'T1', 139))
  -VL(FetchElm(RetNo, 'T1', 143))
  -VL(FetchElm(RetNo, 'T1', 144));
  {
  //tv's alray defined
  //start from elm=130
  B130:=VL(FetchElm(RetNo, 'T1', 150));  //tax table in step
  B142:=VL(FetchElm(RetNo, 'T1', 139));
  //does not incl donations -VL(FetchElm(RetNo, 'T1', 140)); //*VL(Constant[RY].Rate1); //bfr Donations line
  B146:=B142+VL(FetchElm(RetNo, 'T1',143))+VL(FetchElm(RetNo, 'T1', 144));
  BFedTaxBfrDon:=MaxR(0,B130-B146);
  Result:=BFedTaxBfrDon;
  }
  end;
*)
(*
  //20210221
  BFedTaxBfrDon :=MaxR(0, VL(FetchElm(RetNo, 'T1', 150)) // line 39 of s1
  - Ret[RetNo].Lnn[35000]
  - Ret[RetNo].LNN[34900]*VL(Constant[RY].Rate1)
  - Ret[RetNo].LNN[40425]
  - Ret[RetNo].LNN[40427]);
  Result:=BFedTaxBfrDon;
  }

  {
  If BFedTaxBfrDon > 200 * (VL(Constant[RY].Rate1) / 100) then
  result := 200 + (BFedTaxBfrDon - (200 * VL(Constant[RY].Rate1) / 100)) /
  (VL(Constant[RY].Rate4) / 100) // 0.29
  else
  result := BFedTaxBfrDon / (VL(Constant[RY].Rate1) / 100); // 0.15
  }
  end;


  (* //20210221
  //20191220
  Function CalcMaxDonations(RetNo: Integer): Real;
  Var
  BFedTaxBfrDon: Real;
  begin
  BFedTaxBfrDon := MaxR(0, VL(FetchElm(RetNo, 'T1', 130)) // line 39 of s1
  - Ret[RetNo].Lnn[33800] // 15% of NON ref
  - Ret[RetNo].LNN[40425] //VL(FetchElm(RetNo, 'S1', 105)) // Fed div tx cr
  // - VL(FetchElm(RetNo, 'S1', 130)) // overseas  //20191220 discontinued
  - Ret[RetNo].LNN[40427]); // VL(FetchElm(RetNo, 'S1', 106))); // min tax carryover
  If BFedTaxBfrDon > 200 * (VL(Constant[RY].Rate1) / 100) then
  result := 200 + (BFedTaxBfrDon - (200 * VL(Constant[RY].Rate1) / 100)) /
  (VL(Constant[RY].Rate4) / 100) // 0.29
  else
  result := BFedTaxBfrDon / (VL(Constant[RY].Rate1) / 100); // 0.15
  end;
*)
(*
  Function CalcMaxDonations(RetNo: Integer): Real;
  Var
  BFedTaxBfrDon: Real;
  begin
  BFedTaxBfrDon := MaxR(0, VL(FetchElm(RetNo, 'S1', 103)) // line 39 of s1
  - Ret[RetNo].Lnn[33800] // 15% of NON ref
  - VL(FetchElm(RetNo, 'S1', 105)) // Fed div tx cr
  - VL(FetchElm(RetNo, 'S1', 130)) // overseas
  - VL(FetchElm(RetNo, 'S1', 106))); // min tax carryover
  If BFedTaxBfrDon > 200 * (VL(Constant[RY].Rate1) / 100) then
  result := 200 + (BFedTaxBfrDon - (200 * VL(Constant[RY].Rate1) / 100)) /
  (VL(Constant[RY].Rate4) / 100) // 0.29
  else
  result := BFedTaxBfrDon / (VL(Constant[RY].Rate1) / 100); // 0.15
  end;
*)

Function GetMaxClaimableMedical(RetNo: integer; TotMedicalExpenses: Real): Real;
Var
  BFedTaxBfrMed, OptimumMedExp: Real;
  NonRefBfrMedical: Real;
  FNo: integer;
begin
  // take enough to reduce fed tax to 0
  // Subtotal 70 is non-refundable before Med and Don
  Result := 0;
  If TotMedicalExpenses = 0 then
    Exit;
  NonRefBfrMedical := (VL(FetchElm(RetNo, 'T1', 97)) + Ret[RetNo].Lnn[33199]) *
  // 20191220 NonRefBfrMedical := (VL(FetchElm(RetNo, 'S1', 70)) + Ret[RetNo].Lnn[33199]) *
    VL(Constant[RY].Rate1) / 100 + Ret[RetNo].Lnn[34900]; // don

  // FNo := GetFormNo('S1');   //20191220
  BFedTaxBfrMed := MaxR(0, VL(FetchElm(RetNo, 'T1', 130)) - NonRefBfrMedical -
    Ret[RetNo].Lnn[40425] // VL(FetchElmFNo(RetNo, FNo, 5)) // Fed div tx cr
    // - VL(FetchElmFNo(RetNo, FNo, 30)) // overseas  obsoletet
    - Ret[RetNo].Lnn[40427]);
  // VL(FetchElmFNo(RetNo, FNo, 6))); // min tax carryover

  { //20191220
    FNo := GetFormNo('S1');
    BFedTaxBfrMed := MaxR(0, VL(FetchElmFNo(RetNo, FNo, 3)) - NonRefBfrMedical -
    VL(FetchElmFNo(RetNo, FNo, 5)) // Fed div tx cr
    - VL(FetchElmFNo(RetNo, FNo, 30)) // overseas
    - VL(FetchElmFNo(RetNo, FNo, 6))); // min tax carryover
  }
  If BFedTaxBfrMed <= 0 then
  begin
    Result := 0;
    Exit;
  end; // do not waste medical, tax is aleady 0
  // calc how much to take
  OptimumMedExp := MinR(TotMedicalExpenses,
    BFedTaxBfrMed / (VL(Constant[RY].Rate1) / 100) +
    (MinR(Constant[RY].MedicalLimit, Ret[RetNo].Lnn[23600] * (3 / 100))));
  If OptimumMedExp > TotMedicalExpenses then
    OptimumMedExp := TotMedicalExpenses;
  Result := OptimumMedExp;
end;

Function GetOptimumRRSPClaim(RetNo: integer; MaxAvailable: Real): Real;
Var
  NiBfrRRSP: Real;
  SpRetNo: integer;
begin
  With Ret[RetNo] do
  begin
    NiBfrRRSP :=
      MaxR(0, MaxR(0, Lnn[15000] - (Lnn[20700] + Lnn[21200] + Lnn[21400] +
      Lnn[21500] + Lnn[21700] + Lnn[21900] + Lnn[22000] + Lnn[22100] +
      Lnn[22200] + Lnn[22300] + Lnn[22400] + Lnn[22900] + Lnn[23100] +
      Lnn[23200]) - VL(FetchElm(RetNo, 'S7', 7)) // RRSP xfers
      - Lnn[23500]));
    Result := MaxR(0, MinR(NiBfrRRSP, MaxAvailable));
  end;
end;

Function GetPrvYear(ThisYear: String; No: integer): String;
Var
  k: integer;
begin
  k := MyStrToInt(ThisYear) - No;
  Result := IntToStr(k);
end;

Function GetLastName(RetNo: integer): String;
begin
  Result := RTrim(FetchElm(RetNo, 'INFO', 5));
end;

Function GetSpouseLastName(RetNo: integer): String;
Var
  RNo: integer;
begin
  If RetNo = 0 then
    Exit;
  RNo := GetSpRetNo(RetNo);
  If RNo > 0 then
    Result := GetLastName(RNo)
  else
  begin
    If FetchElm(RetNo, 'INFO', 45) > '' then
      Result := FetchElm(RetNo, 'INFO', 45)
    else
      Result := GetLastName(RetNo);
  end;
end;

Function GetSpouseFirstName(RetNo: integer): String;
Var
  RNo: integer;
begin
  Result := FetchElm(RetNo, 'INFO', 20);
end;

Function GetSpouseAddress(RetNo: integer): String;
Var
  RNo: integer;
begin
  RNo := GetSpRetNo(RetNo);
  If RNo = 0 then
    RNo := RetNo;
  Result := FetchElm(RNo, 'INFO', 6) + ', ' + FetchElm(RNo, 'INFO', 10) + ', ' +
    FetchElm(RNo, 'INFO', 14) + ', ' + FetchElm(RNo, 'INFO', 15);
end;

Function IsReturnPaid(RetNo: integer): Boolean;
begin
  Result := false;
  If FetchElm(RetNo, 'INVOICE', 223) + FetchElm(RetNo, 'INVOICE', 224) +
    FetchElm(RetNo, 'INVOICE', 225) + FetchElm(RetNo, 'INVOICE', 282)
  // 20140205
    + FetchElm(RetNo, 'INVOICE', 271) + FetchElm(RetNo, 'INVOICE', 286) > ''
  then
    Result := true;
end;

Function GetAreaCode(RetNo: integer): String;
begin
  Result := FetchElm(RetNo, 'T1', 441);
end;

Function GetPhoneNo(RetNo: integer): String;
begin
  Result := FetchElm(RetNo, 'T1', 442);
end;

Function GetFaxNo(RetNo: integer): String;
begin
  Result := FetchElm(RetNo, 'INFO', 63);
end;

Function GetFirstName(RetNo: integer): String;
begin
  Result := RTrim(FetchElm(RetNo, 'INFO', 2));
end;

Function GetSinNo(RetNo: integer): String;
begin
  Result := FetchElm(RetNo, 'INFO', 3);
end;

Function GetSpouseSinNo(RetNo: integer): String;
begin
  Result := FetchElm(RetNo, 'INFO', 4);
end;

Function GetFullAddress(RetNo: integer): String;
begin
  Result := FetchElm(RetNo, 'INFO', 6) + ', ' + FetchElm(RetNo, 'INFO', 10) +
    ', ' + FetchElm(RetNo, 'INFO', 14) + ', ' + FetchElm(RetNo, 'INFO', 15);
end;

Function Pars(Msg: string; elm: integer; Delimiter: string): string;
Var
  i: integer;
  DelimiterPositions: TStringList;
begin
  If RightStr(Msg, 1) <> Delimiter then
    Msg := Msg + Delimiter;
  If LeftStr(Msg, 1) <> Delimiter then
    Msg := Delimiter + Msg;
  if (Length(Msg) < 2) or (elm < 1) or (Msg = '') then
  begin
    Result := '';
    Exit;
  end;

  DelimiterPositions := TStringList.Create;
  For i := 1 to Length(Msg) do
    If Msg[i] = Delimiter then
      DelimiterPositions.Add(IntToStr(i));
  If elm > DelimiterPositions.Count then
    Result := ''
  else
    Result := MidStr(Msg, StrToInt(DelimiterPositions[elm - 1]) + 1,
      StrToInt(DelimiterPositions[elm]) -
      StrToInt(DelimiterPositions[elm - 1]) - 1);
  DelimiterPositions.Free;
end;

Function IsFormASlip(FrmNm: String): Boolean;
begin
  Result := FList.ByFormName(FrmNm).IsSlip;
end;

Function GetRealFormName(FrmNm: String): String;
begin
  Result := FList.ByFormName(FrmNm).FormRlNm;
end;

function GetFormNumberFields(FNo: integer): integer;
begin
  Result := FList.GetFormNumberFields(FNo);
end;

function GetMaxFormNumber: integer;
var
  i: integer;
  mFormNum: integer;
begin
  Result := FormsLimit;
  Exit; // we use 600

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

Function GetHigherTxblSpouseRetNo(RetNo, SpRetNo: integer): integer;
Var
  x1, X2: Real;
  OptimizeFNo: integer;
begin
  OptimizeFNo := GetFormNo('OPTIMIZE');
  Result := RetNo;
  x1 := Ret[RetNo].Lnn[26000] + VL(FetchElmFNo(RetNo, OptimizeFNo, 28)) -
    VL(FetchElmFNo(RetNo, OptimizeFNo, 38));
  X2 := Ret[SpRetNo].Lnn[26000] - VL(FetchElmFNo(SpRetNo, OptimizeFNo, 29)) +
    VL(FetchElmFNo(SpRetNo, OptimizeFNo, 39));
  If X2 >= x1 then
    Result := SpRetNo;
end;

Procedure ClearAnyForm(RetNo: integer; Frm: String);
Var
  i, j: integer;
begin
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If (FRec.FormName = Frm) then
    begin
      For j := 1 to FRec.FormFields do
        StoreElm(RetNo, FRec.FormNo, j, '');
      Exit;
    end;
  end;
end;

Procedure ClearAllMJS2S11(RetNo: integer);
Var
  i, j: integer;
begin
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If (FRec.FormName = 'S2MJ') or (FRec.FormName = 'S11MJ') then
      // For j :=1 to Frec.FormFields+20 do StoreElm(Retno,FRec.FormNo,j,'');
      For j := 1 to FRec.FormFields do
        StoreElm(RetNo, FRec.FormNo, j, ''); // 20120309
  end;
end;

Function GetFldMemFormNo(RetNo: integer;
  RefFormName, RefFieldId: String): integer;
Var
  i, FNo: integer;
  FrmNm: string; // [10];
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'FLDMEM' then
    begin
      FNo := FRec.FormNo;
      If (FetchElmFNo(RetNo, FNo, 17) = RefFormName) and
        (FetchElmFNo(RetNo, FNo, 18) = RefFieldId) then
        Result := FNo;
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
    If not Ret[RetNo].FormHasData[GetFormName(RetNo, InstForms[i].FormNo)] then
      Exit(ExtractFormInstNo(InstForms[i].FormInst));
  Result := ExtractFormInstNo(InstForms[Length(InstForms) - 1].FormInst) + 1;
  // 20170118 Igor >>>
end;

Function GetFldTapeFormNo(RetNo: integer;
  RefFormName, RefFieldId: String): integer;
Var
  i, FNo: integer;
  FrmNm: String;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'FLDTAPE' then
    begin
      FNo := FRec.FormNo;
      If (FetchElmFNo(RetNo, FNo, 121) = RefFormName) and
        (FetchElmFNo(RetNo, FNo, 122) = RefFieldId) then
        Result := FNo;
    end;
  end;
end;

Function GetFormFee(RetNo: integer; FName: String; Qty: integer): Real;
Var
  i: integer;
  Fee, EachItem, AddnlForm: Real;
begin
  Result := 0;
  for i := 0 to (FeesList.Count - 1) do
  begin
    FeesRec := FeesList[i];
    If FName = FeesRec.FormName then
    begin
      Fee := VL(FeesRec.Fee);
      AddnlForm := VL(FeesRec.AddnlForm);
      Result := Fee + (Qty - 1) * AddnlForm;
      EachItem := VL(FeesRec.Each_Item);

      If FName = 'MEDICAL' then
        Result := Result + CountMedicalEntriesForInvoice(RetNo) * EachItem;
      If FName = 'DON' then
        Result := Result + CountDonationEntriesForInvoice(RetNo) * EachItem;
      If FName = 'RRSP' then
        Result := Result + CountRRSPEntriesForInvoice(RetNo) * EachItem;
      If FName = 'DEPEND' then
        Result := Result + CountDependantEntriesForInvoice(RetNo) * EachItem;
      If FName = 'T2202' then
        Result := Result + CountTuitionEntriesForInvoice(RetNo) * EachItem;
      If FName = 'S3' then
        Result := Result + CountDispositionEntriesForInvoice(RetNo) * EachItem;
      // 20100311
      If FName = 'T5MULT' then
        Result := Result + SlipsInAT5Mult(RetNo, FName) * EachItem;
      If FName = 'T3MULT' then
        Result := Result + SlipsInAT3Mult(RetNo, FName) * EachItem;
    end;
  end;
end;

// 20110129
Function IsFormCharged(FName: String): Boolean;
Var
  i: integer;
  Fee, EachItem, AddnlForm: Real;
begin
  Result := false;
  for i := 0 to (FeesList.Count - 1) do
  begin
    FeesRec := FeesList[i];
    If FName = FeesRec.FormName then
    begin
      If VL(FeesRec.Fee) + VL(FeesRec.AddnlForm) + VL(FeesRec.Each_Item) <> 0
      then // 20120205
      // If Vl(FeesRec.Fee)+Vl(FeesRec.AddnlForm)+Vl(Feesrec.Each_Item)>0 then
      Begin
        Result := true;
        Exit;
      end;
    end;
  end;
end;

Function CountPagesGenerated(RetNo: integer): integer;
Var
  i: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If Ret[RetNo].FrmHasData[FRec.FormNo] then
      inc(Result); // 20160813
  end;
end;

Function IsFormMultiPage(FormName: String): Boolean;
Var
  i: integer;
begin
  Result := false;
  i := Length(FormName);
  While i > 0 do
  begin
    If FormName[i] = '_' then
    begin
      Result := true;
      Exit;
    end;
    Dec(i);
  end;
end;

Function IsFirstPageOfForm(FormName: String): Boolean;
Var
  i: integer;
begin
  Result := false;
  i := Length(FormName);
  While i > 0 do
  begin
    If (FormName[i] = '_') and (MidStr(FormName, i + 1, 1) = '1') then
    begin
      Result := true;
      Exit;
    end;
    Dec(i);
  end;
end;

Function IsFormMultiInst(Frm: String): Boolean;
Var
  i: integer;
begin // 20101220  formname to Frm
  Result := false;
  i := Length(Frm);
  While i > 0 do
  begin
    If Frm[i] = '#' then
    begin
      Result := true;
      Exit;
    end;
    Dec(i);
  end;
end;

Procedure GetListInvoiceForms(RetNo: integer; Var Frms: TStringList;
  Var HowMany: TStringList);
Var
  i, j: integer;
begin
  { Count non multi-instance forms }
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If (Ret[RetNo].FrmHasData[FRec.FormNo]) // 20160813 //20170324 Igor
      and (IsFormCharged(FRec.FormName) // 20110129
      and (AllTrim(FRec.FormInst) = '')) // 20110315   //only non inst
    // and (Vl(Frec.Fee)+ Vl(Frec.Each_item)>0) and (Frec.FormInst = '')
    then
    begin
      // 20090214
      If ((FRec.FormName = 'S2') and (VL(FetchElmFNo(RetNo, FRec.FormNo, 19))
        = 0)) then
      begin
        // no charge
      end
      Else If ((FRec.FormName = 'S7') and (Ret[RetNo].Lnn[20800] = 0)) then
      begin
        // no charge
      end

      Else If ((FRec.FormName = 'DON') and (Ret[RetNo].Lnn[34900] = 0)) then
      begin
        // no charge
      end
      Else If ((FRec.FormName = 'MEDICAL') and (Ret[RetNo].Lnn[33200] = 0)) then
      begin
        // no charge
      end
      else
      begin
        Frms.Add(FRec.FormName);
        HowMany.Add('1');
      end;
    end;
  end; { Flist do }
  CountMultiesForInvoice(RetNo, Frms, HowMany);
end;

// 20100421
Procedure CountMultiesForInvoice(RetNo: integer; Var Frms: TStringList;
  Var HowMany: TStringList);
Var
  i, j, k: integer;
  FrmNm, Inst: String;
begin
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if (Ret[RetNo].FrmHasData[FRec.FormNo]) // 20160813 //20170324 Igor
      and (IsFormCharged(FRec.FormName))
    // (Vl(Frec.Fee)+Vl(Frec.Each_Item) >0)  //20110129
      and (FRec.FormInst > '') then // 20090104
    begin
      If IsFormMultiPage(FRec.FormName) then { Multipage }
      Begin
        FrmNm := FRec.FormName;
        k := CountMultiPageStatements(RetNo, FrmNm);
        If (k > 0) and (IsStringInList(FrmNm, Frms) < 0) then
        begin
          Frms.Add(FrmNm);
          HowMany.Add(IntToStr(k));
        end;
      end
      else
      Begin // no multiipage such as T4 slips ot T5MULT
        FrmNm := FRec.FormName;
        k := CountSinglePageStatements(RetNo, FrmNm);
        If (k > 0) and (IsStringInList(FrmNm, Frms) < 0) then
        begin
          Frms.Add(FrmNm);
          HowMany.Add(IntToStr(k));
        end;
      end;
    end; { frm has data }
  end; { i Flist do }
end;

Function SlipsInAT5Mult(RetNo: integer; FName: String): integer;
Var
  i: integer;
  FNo: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If (FName = FRec.FormName) then
    begin
      FNo := FRec.FormNo;
      If (FetchElmFNo(RetNo, FNo, 131) = 'Y') and
        (VL(FetchElmFNo(RetNo, FNo, 2)) > 0) then
        inc(Result);
      If (FetchElmFNo(RetNo, FNo, 132) = 'Y') and
        (VL(FetchElmFNo(RetNo, FNo, 24)) > 0) then
        inc(Result);
      If (FetchElmFNo(RetNo, FNo, 133) = 'Y') and
        (VL(FetchElmFNo(RetNo, FNo, 46)) > 0) then
        inc(Result);
      If (FetchElmFNo(RetNo, FNo, 134) = 'Y') and
        (VL(FetchElmFNo(RetNo, FNo, 68)) > 0) then
        inc(Result);
      If (FetchElmFNo(RetNo, FNo, 135) = 'Y') and
        (VL(FetchElmFNo(RetNo, FNo, 90)) > 0) then
        inc(Result);
    end;
  end;
end;

Function SlipsInAT3Mult(RetNo: integer; FName: String): integer;
Var
  i, FNo: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If (FName = FRec.FormName) then
    begin
      FNo := FRec.FormNo;
      If (FetchElmFNo(RetNo, FNo, 233) > '') and
        (VL(FetchElmFNo(RetNo, FNo, 35)) > 0) then
        inc(Result);
      If (FetchElmFNo(RetNo, FNo, 234) > '') and
        (VL(FetchElmFNo(RetNo, FNo, 36)) > 0) then
        inc(Result);
      If (FetchElmFNo(RetNo, FNo, 235) > '') and
        (VL(FetchElmFNo(RetNo, FNo, 37)) > 0) then
        inc(Result);
      If (FetchElmFNo(RetNo, FNo, 236) > '') and
        (VL(FetchElmFNo(RetNo, FNo, 38)) > 0) then
        inc(Result);
      If (FetchElmFNo(RetNo, FNo, 237) > '') and
        (VL(FetchElmFNo(RetNo, FNo, 39)) > 0) then
        inc(Result);
    end;
  end;
end;

Function MultiPage1(Frm: string; Inst: string; MxPg: integer): Boolean;
{ frm is noninstance }
begin
  Result := false;
  If (Inst = '#1') then
    if (RightStr(Frm, 2) = '-1') or (MxPg < 2) then
      Result := true;
end;

Function MultiPage23(Frm: string; Inst: string; MxPg: integer): Boolean;
{ frm is noninstance }
begin
  Result := false;
  If (Inst > '#1') then
    if (RightStr(Frm, 2) = '-1') or (MxPg < 2) then
      Result := true;
end;

function IsShowHdrIndicator(FName: String): Boolean;
begin
  Result := FList.ByFormName(FName).ShowHdr;
End;

function IsShowFlagIndicator(FName: String): Boolean;
begin
  Result := FList.ByFormName(FName).ShowFlag;
End;

function GetWhiteBoxesIndicator(FName: String): Boolean;
begin
  Result := FList.ByFormName(FName).WhiteBoxes;
End;

Function GetFormAbbrevDescr(FName: String): String;
Var
  i: integer;
begin
  Result := '';
  FName := RTrim(FName);
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FName = FRec.FormName then
    begin
      Result := FRec.FormAbrev;
      Exit;
    end;
  end;

End;

function GetFormDescr(RlName: String): String;
Var
  i: integer;
begin
  Result := '';
  RlName := RTrim(RlName);
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If RlName = FRec.FormRlNm then
    begin
      Result := FRec.FormDescr;
      Exit;
    end;
  end;

End;

function GetFName(AbrevName: String): String;
var
  i: integer;
begin
  Result := '';
  AbrevName := RTrim(AbrevName);
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if LeftStr(FRec.FormAbrev, Length(AbrevName)) = AbrevName then
    begin
      Result := FRec.FormInstName;
      Exit;
    end;
  end;
end;

function GetLastYearFName(AbrevName: String): String;
var
  i: integer;
begin
  Result := '';
  AbrevName := RTrim(AbrevName);
  for i := 0 to (FLastYearList.Count - 1) do
  begin
    FLastYearRec := FLastYearList.Items[i];
    if UpperCase(LeftStr(FLastYearRec.FormAbrev, Length(AbrevName)))
      = UpperCase(AbrevName) then // 20120209
    begin
      Result := UpperCase(FLastYearRec.FormInstName);
      Exit;
    end; // 20120209
  end;
end;

function GetFormName(const RetNo: integer; FormNo: integer): String;
var
  i: integer;
begin
  If (RetNo > 0) and Ret[RetNo].IsLastYearReturn then // 20160314 Igor
    Result := FLastYearList.GetFormName(FormNo)
  else
    Result := FList.GetFormName(FormNo);
end;

function GetLastYearFormName(FormNo: integer): String;
begin
  Result := FLastYearList.GetFormName(FormNo);
end;

// 20160812  CON
Function TotMultiple(RetNo: integer; NonInstFormName: String; elm: integer)
  : Real; { No Instance }
var
  i, FNo: integer;
  FName: String; // 20160723
  FInst: String; // 20160812
begin
  // 20160723
  Result := 0;
  If RetNo < 1 then
    Exit;
  i := FList.FirstInstNo(NonInstFormName);
  if i > 0 then
  Begin
    for i := i to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      FInst := FRec.FormInst; // 20160812
      if FInst > '' then // 20160812
      Begin
        FNo := FRec.FormNo;
        if FNo > 0 Then
        Begin
          FName := FRec.FormName;
          If FName = NonInstFormName then
          Begin
            If Ret[RetNo].FrmHasData[FNo] then
              // 20160730  //20160812 //20170324 Igor
              Result := Result + VL(FetchElmFNo(RetNo, FNo, elm));
          end;
        end; // fno
      end; // inst
    end; // i loop
  end; // i>0
end;

(* 20160723
  Result := 0;
  If RetNo<1 then exit;   //20101220
  i := FList.FirstInstNo(NonInstFormName);
  if i < 1 then
  begin
  if (NonInstFormName = 'T5') //-->T5MULT?
  or (NonInstFormName = 'S12SUP')
  then
  exit; //known bugs
  ErrorMsg('T1: TotMultiple: form '+NonInstFormName+' does not exist');
  i := FList.FirstInstNo(NonInstFormName); //debug
  exit;
  end;

  for i :=i to (Flist.Count-1) do
  begin
  FRec := FList.Items[i];
  if Frec.FormName <> NonInstFormName then break;
  begin
  FNo :=Frec.FormNo;
  If FNo>0 then
  Begin
  If Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)] then
  begin
  If NonInstFormName <> 'T4AOAS' then
  Result := Result + Vl(FetchElmFNo(RetNo,FNo,Elm))
  else //t4aoas slip
  begin
  If (Elm<>4) then Result := Result + Vl(FetchElmFNo(RetNo,FNo,Elm))
  else
  If {(Elm=4) and} (Vl(FetchElmFNo(RetNo,FNo,Elm))>0) then
  Result := Result + Vl(FetchElmFNo(RetNo,FNo,Elm));
  end;
  end;
  end;
  end;
  end;
  end;
*)

(*
  //20160723 BY IGOR VERSION
  Function TotMultiple(RetNo:Integer;NonInstFormName:String;Elm:Integer):Real; {No Instance}
  var
  i, FNo: Integer;
  begin
  Result := 0;
  If RetNo<1 then exit;   //20101220
  i := FList.FirstInstNo(NonInstFormName);
  if i < 1 then
  begin
  if (NonInstFormName = 'T5') //-->T5MULT?
  or (NonInstFormName = 'S12SUP')
  then
  exit; //known bugs
  ErrorMsg('T1: TotMultiple: form '+NonInstFormName+' does not exist');
  i := FList.FirstInstNo(NonInstFormName); //debug
  exit;
  end;

  for i := 0{i} to (Flist.Count-1) do //20160723 Igor
  begin
  FRec := FList.Items[i];
  if Frec.FormName <> NonInstFormName then Continue; //break; //20160723 Igor
  begin
  FNo :=Frec.FormNo;
  If FNo>0 then
  Begin
  If Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)] then
  begin
  If NonInstFormName <> 'T4AOAS' then
  Result := Result + Vl(FetchElmFNo(RetNo,FNo,Elm))
  else //t4aoas slip
  begin
  If (Elm<>4) then Result := Result + Vl(FetchElmFNo(RetNo,FNo,Elm))
  else
  If {(Elm=4) and} (Vl(FetchElmFNo(RetNo,FNo,Elm))>0) then
  Result := Result + Vl(FetchElmFNo(RetNo,FNo,Elm));
  end;
  end;
  end;
  end;
  end;
  end;
*)

Function TotT4RIFBox20(RetNo: integer; NonInstFormName: String; elm: integer)
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
      FNo := FRec.FormNo;
      If (Ret[RetNo].FrmHasData[FNo]) // 20170324 Igor
        and (UpperCase(FetchElmFNo(RetNo, FNo, 15)) <> 'Y') // spousal
      then
        Result := Result + VL(FetchElmFNo(RetNo, FNo, elm));
    end;
  end;
end;

Function IsCPPExempt(RetNo: integer): Boolean;
var
  i, FNo: integer;
begin
  Result := false;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'T4' then
    begin
      FNo := FRec.FormNo;
      If UpperCase(FetchElmFNo(RetNo, FNo, 7)) = 'X' then
      begin
        Result := true;
        Exit;
      end;
    end;
  end;
end;

Function GetTotT4ARCA(RetNo: integer): Real;
var
  i, FNo: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'T4ARCA' then
    begin
      FNo := FRec.FormNo;
      Result := Result + VL(FetchElmFNo(RetNo, FNo, 3)) +
        VL(FetchElmFNo(RetNo, FNo, 4)) + VL(FetchElmFNo(RetNo, FNo, 5)) +
        VL(FetchElmFNo(RetNo, FNo, 6));
    end;
  end;
end;

Function ForPensDed(RetNo: integer): Real;
var { 65 or due to death of spouse }
  i, FNo: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'T4RSP' then
    begin
      FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] then // 20170324 Igor
      begin
        If (Ret[RetNo].Age >= 65) or (FetchElmFNo(RetNo, FNo, 3) > '')
        then { due to death }
          Result := Result + VL(FetchElmFNo(RetNo, FNo, 2));
      end;
    end;
  end;
end;

Procedure TotT2125(RetNo: integer);
var
  i, FNo: integer;
  T2125Page1: string; // [10];
begin
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'T2125' then
    begin
      FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] then // 20170324 Igor
      begin
        If FetchElmFNo(RetNo, FNo, 74) > '' then // commission
        begin
          Ret[RetNo].Lnn[13899] := Ret[RetNo].Lnn[13899] +
            VL(FetchElmFNo(RetNo, FNo, 32));
          Ret[RetNo].Lnn[13900] := Ret[RetNo].Lnn[13900] +
            VL(FetchElmFNo(RetNo, FNo, 106));
        end
        else
        begin // bus or prof
          If FetchElmFNo(RetNo, FNo, 82) > '' then // bus
          begin
            Ret[RetNo].Lnn[13499] := Ret[RetNo].Lnn[13499] +
              VL(FetchElmFNo(RetNo, FNo, 32));
            Ret[RetNo].Lnn[13500] := Ret[RetNo].Lnn[13500] +
              VL(FetchElmFNo(RetNo, FNo, 106));
          end
          Else
          begin
            If FetchElmFNo(RetNo, FNo, 90) > '' then // prof
              Ret[RetNo].Lnn[13699] := Ret[RetNo].Lnn[13699] +
                VL(FetchElmFNo(RetNo, FNo, 32));
            Ret[RetNo].Lnn[13700] := Ret[RetNo].Lnn[13700] +
              VL(FetchElmFNo(RetNo, FNo, 106));
          end;
        end;
      end; // has data
    end
  end; // end i

end;

Function GetMotorCCAForGST370(RetNo: integer): Real;
Var
  FNo: integer;
begin
  FNo := GetFormNo('T777');
  Result := VL(FetchElmFNo(RetNo, FNo, 31));
  If VL(FetchElmFNo(RetNo, FNo, 7)) > 0 then
    Result := Result * VL(FetchElmFNo(RetNo, FNo, 6)) /
      VL(FetchElmFNo(RetNo, FNo, 7))
end;

Function GetGST370EXP(RetNo: integer): Real;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if (FRec.FormName = 'T777') and
      (UpperCase(FetchElmFNo(RetNo, FRec.FormNo, 1)) = 'Y') then
      Result := Result + VL(FetchElmFNo(RetNo, FRec.FormNo, 24)) -
        VL(FetchElmFNo(RetNo, FRec.FormNo, 20)) { cca }
        - GetMotorCCAForGST370(RetNo)
    else if FRec.FormName = 'T2125' then
      Result := Result + VL(FetchElmFNo(RetNo, FRec.FormNo, 215))
    else if FRec.FormName = 'T2121' then
      Result := Result + VL(FetchElmFNo(RetNo, FRec.FormNo, 109))
    else if FRec.FormName = 'T2042' then
      Result := Result + VL(FetchElmFNo(RetNo, FRec.FormNo, 613));
  end;
end;

Function ExtractNonInstFormName(FormName: string): string;
var
  i: integer;
begin
  i := 1;
  while (i <= Length(FormName)) and not(FormName[i] = '#') do
    inc(i);
  Result := Copy(FormName, 1, i - 1);
end;

function GetFormNo(FormName: String; RetNo: integer): integer;
var
  FRec: TFRec;
begin
  // FormName := UpperCase(FormName); - not case sensitive
  if (RetNo > 0) and Ret[RetNo].IsLastYearReturn then // 20160314 Igor
    Result := FLastYearList.ByFormName(FormName).FormNo
  else
  begin
    FRec := FList.ByFormName(FormName);
    Result := FRec.FormNo;
  end;
end;

function GetLastYearFormNo(FormName: String): integer;
begin
  Result := FLastYearList.ByFormName(UpperCase(FormName)).FormNo;
end;

Function ExtractFormInst(FormName: String): string;
var
  i: integer;
begin
  i := 1;
  while (i <= Length(FormName)) and not(FormName[i] = '#') do
    inc(i);
  Result := Copy(FormName, i, 255);
end;


Function GetCPPMonths(RetNo: integer): integer;
Var
  i, FNo, StopMonth: integer;
begin
  FNo := GetFormNo('INFO');
  With Ret[RetNo] do
  begin
    Result := 12;
    If (Age < 18) or (Age > 70) then
      Result := 0
    Else If Age = 18 then
      Result := 12 - MyStrToInt(MidStr(Frm[FNo].Strings[9], 6, 2))
    Else If Age = 70 then
      Result := MyStrToInt(MidStr(Frm[FNo].Strings[9], 6, 2)) // 20121212
      // 20130510
    Else If Age < 100 then
    begin
      Result := 12 - T4APDisabMonths; // 20131215
    end;
    (* 20131215
      //20130510
      Else If Age<100 then
      begin
      result:=12-T4APDisabMonths;   //20130404  //20130510
      If (T4APCppMonths>0) and (T4APCppMonths<12) then result:=12-T4APCppMonths;
      end;  //20130510
    *)
    { Else } If Frm[FNo].Strings[24] > '' then // dateof death  //20130510
    begin
      If LeftStr(Frm[FNo].Strings[24], 4) = AppYear then // 20100501
        Result := MyStrToInt(MidStr(Frm[FNo].Strings[24], 6, 2)); { Deceased }
    end;

    { TODO 1 -oCON : StopMonth <> Result!? }
    StopMonth := MyStrToInt(FetchElm(RetNo, 'S8', 20));

    If Result < 0 then
      Result := 0;
  end; { end with  Ret[RetNo] }
end;

Function GetCPPMonthsForRC381(RetNo: integer): integer;
Var
  i, FNo, StopMonth: integer;
begin
  FNo := GetFormNo('INFO');
  With Ret[RetNo] do
  begin
    Result := 12;
    If (Age < 18) or (Age > 70) then
      Result := 0
    Else If Age = 18 then
      Result := 12 - MyStrToInt(MidStr(Frm[FNo].Strings[9], 6, 2))
    Else If Age = 70 then
      Result := MyStrToInt(MidStr(Frm[FNo].Strings[9], 6, 2)) // 20121212
    Else If Age < 100 then // 20140112
    begin
      Result := 12 - T4APDisabMonths;
    end;

    If Frm[FNo].Strings[24] > '' then // dateof death  //20130510
    begin
      If LeftStr(Frm[FNo].Strings[24], 4) = AppYear then // 20100501
        Result := MyStrToInt(MidStr(Frm[FNo].Strings[24], 6, 2)); { Deceased }
    end;

    // See RC381 for stop month
    If FetchElm(RetNo, 'RC381', 43) > '' then
      Result := 12 - MyStrToInt(FetchElm(RetNo, 'RC381', 43));
    // 20140112  //cancel revoke

    If Result < 0 then
      Result := 0;
  end; { end with  Ret[RetNo] }
end;

Function GetQPPMonthsForRC381(RetNo: integer): integer; // 20140113
Var
  i, FNo, StopMonth: integer;
begin
  FNo := GetFormNo('INFO');
  With Ret[RetNo] do
  begin
    Result := 12;
    If (Age < 18) then
      Result := 0
    Else If Age = 18 then
      Result := 12 - MyStrToInt(MidStr(Frm[FNo].Strings[9], 6, 2))
    Else If Age < 100 then // 20140216
      Result := 12 - T4APDisabMonths;

    If Frm[FNo].Strings[24] > '' then // dateof death  //20130510
    begin
      If LeftStr(Frm[FNo].Strings[24], 4) = AppYear then // 20100501
        Result := MyStrToInt(MidStr(Frm[FNo].Strings[24], 6, 2)); { Deceased }
    end;

    // See RC381 for stop month
    If FetchElm(RetNo, 'RC381', 43) > '' then
      Result := 12 - MyStrToInt(FetchElm(RetNo, 'RC381', 43));
    // 20140112  //cancel revoke

    If Result < 0 then
      Result := 0;
  end; { end with  Ret[RetNo] }
end;

Function GetCPPQPPMonthsForRC269(RetNo: integer): integer; // 20140113
Var
  i, FNo, StopMonth: integer;
begin
  FNo := GetFormNo('INFO');
  With Ret[RetNo] do
  begin
    Result := 12;
    If (Age < 18) then
      Result := 0
    Else If Age = 18 then
      Result := 12 - MyStrToInt(MidStr(Frm[FNo].Strings[9], 6, 2))
    Else If Age < 100 then // 20140216
      Result := 12 - T4APDisabMonths;

    If Frm[FNo].Strings[24] > '' then // dateof death  //20130510
    begin
      If LeftStr(Frm[FNo].Strings[24], 4) = AppYear then // 20100501
        Result := MyStrToInt(MidStr(Frm[FNo].Strings[24], 6, 2)); { Deceased }
    end;

    { do not think this applies to RC269
    // See RC381 for stop month
    If FetchElm(RetNo, 'RC381', 43) > '' then
      Result := 12 - MyStrToInt(FetchElm(RetNo, 'RC381', 43));
    // 20140112  //cancel revoke
    }

    If Result < 0 then
      Result := 0;
  end; { end with  Ret[RetNo] }
end;

//function getCPPRetirementMonthsForS8(RetNo: integer; CppMonths: integer): integer;
//jz//20260204 - change name, nothing here specific to s8 and use in other places also (RC269)
//jz//20260204 - update routine as per test case and profile output -- still not sure is totally right
function getCPPRetirementMonths(RetNo: integer; CppMonths: integer): integer;
begin

  Result := CppMonths;
  if ((IsSelfEmployed(RetNo)) or (Ret[RetNo].Lnn[12200] > 0) ) then  //only do if self empl
  begin
    Result:= round(TotMultiple(RetNo, 'T4AP', 8));

    if (CppMonths <> 12) and (CppMonths <> Result) then
      Result:= Result + (12 - CppMonths);
    Result:= 12 - Result;

    if Result > 12 then
      Result:= 12
    else
      if Result < 0 then
        Result:= 0;
  end;

{ //jz//20260204 - this was not working well
  Result:= round(TotMultiple(RetNo, 'T4AP', 8));
  Result:= ABS(CppMonths - 12) + Result;  // get original months so can add
  Result:= 12 - Result;                   // get the added differnce

  if Result > 12 then
    Result:= 12
  else
  if Result < 0 then
    Result:= 0;
}

end;

Function GetCPPMonthsForS8(RetNo: integer): integer; // 20130212
Var
  i, FNo, StopMonth: integer;
begin
  FNo := GetFormNo('INFO');
  With Ret[RetNo] do
  begin
    Result := 12;
    If (Age < 18) or (Age > 70) then
      Result := 0
    Else If Age = 18 then
      Result := 12 - MyStrToInt(MidStr(Frm[FNo].Strings[9], 6, 2))
    Else If Age = 70 then
      Result := MyStrToInt(MidStr(Frm[FNo].Strings[9], 6, 2)) // 20121212
    Else If Age < 100 then // 20131215
    begin
      If Age < 100 then
        Result := 12 - T4APDisabMonths; // 20130510
    end;

    (* 20131215
      //20130510
      Else If Age<100 then
      begin
      If Age<100 then result:=12-T4APDisabMonths;  //20130510
      If (T4APCppMonths>0) and (T4APCppMonths<12) then result:=12-T4APCppMonths;
      end;   //20130510
    *)

    { Else }  // 20130510
    If Frm[FNo].Strings[24] > '' then // dateof death
    begin
      If LeftStr(Frm[FNo].Strings[24], 4) = AppYear then // 20100501
        Result := MyStrToInt(MidStr(Frm[FNo].Strings[24], 6, 2)); { Deceased }
    end;

    { TODO 1 -oCON : StopMonth <> Result!? }
    // 20130304
    StopMonth := MyStrToInt(FetchElm(RetNo, 'S8', 20)); // -1;   //20130304
    If StopMonth < 0 then
      StopMonth := 0;
    If Result < 0 then
      Result := 0;
  end; { end with  Ret[RetNo] }
end;

Function IsDisabled(RetNo: integer): Boolean;
begin
  Result := false;
  If FetchElm(RetNo, 'INFO', 87) > '' then
    Result := true;
end;

Function SpouseDisabled(RetNo: integer): Boolean;
begin
  Result := false;
  If Ret[RetNo].Frm[GetFormNo('S2')].Count > 0 then
    Result := VL(FetchElm(RetNo, 'S2', 5)) > 0;
end;

Function SlipsAvailable(RetNo: integer): Boolean;
Var
  T4Cnt, T5Cnt, T3Cnt, T4ACnt, T4RSPCnt, T4RIFCnt: integer;
  T4AOASCnt, T4APCnt, T4ECnt, T4PSCnt, T5007Cnt: integer;
begin
  Result := false;
  CountSlips(RetNo, T4Cnt, T4ACnt, T5Cnt, T3Cnt, T4RIFCnt, T4RSPCnt, T4AOASCnt,
    T4APCnt, T4ECnt, T4PSCnt, T5007Cnt);
  // CountSlips(RetNo,T4Cnt,T4ACnt,T5Cnt,T3Cnt,T4RifCnt,T4RspCnt);
  If T4Cnt + T4ACnt + T5Cnt + T3Cnt + T4RIFCnt + T4RSPCnt + T4AOASCnt + T4APCnt
    + T4ECnt + T4PSCnt + T5007Cnt > 0 then
    Result := true;
end;

Procedure UpdateThisFormDataIndicator(RetNo: integer; FName: String);
var
  i, j, FNo: integer;
  S: string; // [60];
  FRec: TFRec;
begin
  FRec := FList.ByFormName(FName);
  UpdateFormDataIndicator(RetNo, FRec);
end;

Procedure UpdateAllDataIndicators(RetNo: integer);
var
  i, j, k, FNo: integer;
  FName: string[13];
  S: string;

begin
  // ShowMessage('Entering Update All Data Indicators');
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    FNo := FRec.FormNo;
    FName := FRec.FormName + FRec.FormInst; // 20160216 Igor
    S := FRec.DataIndic; // 20160216 Igor
    If FNo > 0 then
      UpdateFormDataIndicator(RetNo, FRec);
  end;

  { Special cases }

  if FName = 'T657' then // 20200321   //not working
  Begin
    FNo := GetFormNo(FName);
    if UpperCase(FetchElm(RetNo, FNo, 18)) = 'Y' then
      Ret[RetNo].FrmHasData[FNo] := true;
  end;

  // 20240210 Con
  if FName = 'T2043' then
  Begin
    FNo := GetFormNo(FName);
    if Ret[RetNo].FrmHasData[FNo] = true then
    // if main T2043 then first supplement s/b true
    Begin
      FNo := GetFormNo('T2043A#1');
      Ret[RetNo].FrmHasData[FNo] := true;
    end;
  end;

  { //20200227  not needed
    if Fname='ON428A' then //20200227
    Begin
    Fno:=GetFormNo(FName);
    if UpperCase(FetchElm(RetNo,FNo,48))='Y' then Ret[RetNo].FrmHasData[FNo] := True;
    end;
  }
  if FName = 'S2' then // 20191215
  Begin
    FNo := GetFormNo(FName);
    if UpperCase(FetchElm(RetNo, FNo, 10)) = 'Y' then
      Ret[RetNo].FrmHasData[FNo] := true;
  end;

  if FName = 'S9' then // 20210311
  Begin
    FNo := GetFormNo(FName);
    if UpperCase(FetchElm(RetNo, FNo, 37)) = 'Y' then
      Ret[RetNo].FrmHasData[FNo] := true;
  end;

  if FName = 'S2PRV' then // 20191215
  Begin
    FNo := GetFormNo(FName);
    if UpperCase(FetchElm(RetNo, FNo, 10)) = 'Y' then
      Ret[RetNo].FrmHasData[FNo] := true;
  end;

  if (FName = 'S6') or (FName = 'S6QC') then // 20191215
  Begin
    FNo := GetFormNo(FName);
    if UpperCase(FetchElm(RetNo, FNo, 83)) > '' then
      Ret[RetNo].FrmHasData[FNo] := true;
  end;

  (* Experiment does not work
    if Fname='S6' then //20191215
    Begin
    Fno:=GetFormNo(FName);
    if FetchElm(RetNo,FNo,30)>'' then Ret[RetNo].FrmHasData[FNo] := True; //No to Basic WITB //20200415
    if FetchElm(RetNo,FNo,67)>'' then Ret[RetNo].FrmHasData[FNo] := True; //No to  WITB //20200415
    end;
  *)

  if FName = 'ON479A' then // 20191121
  Begin
    FNo := GetFormNo(FName);
    if UpperCase(FetchElm(RetNo, FNo, 13)) = 'Y' then
      Ret[RetNo].FrmHasData[FNo] := true;
  end;

  if FName = 'NT479' then // 20200329
  Begin
    FNo := GetFormNo(FName);
    if UpperCase(FetchElm(RetNo, FNo, 26)) = 'N' then
      Ret[RetNo].FrmHasData[FNo] := true;
  end;

  // 20160213 //20160216 Igor
  FNo := GetFormNo('CDE');
  For i := 1 to 12 do
  Begin
    If (UpperCase(FetchElmFNo(RetNo, FNo, i)) = 'TRUE') Or
      (VL(FetchElmFNo(RetNo, FNo, i)) <> 0) then
      Ret[RetNo].FrmHasData[FNo] := true;
  end;
  for i := 13 to 22 do
  begin
    If FetchElmFNo(RetNo, FNo, i) > '' then
      Ret[RetNo].FrmHasData[FNo] := true;
    Break;
  end;
  for i := 23 to 32 do
  begin
    If FetchElmFNo(RetNo, FNo, i) > '' then
      Ret[RetNo].FrmHasData[FNo] := true;
    Break;
  end;
  for i := 53 to 62 do
  begin
    If FetchElmFNo(RetNo, FNo, i) > '' then
      Ret[RetNo].FrmHasData[FNo] := true;
    Break;
  end;
  // ----------------------------

  // 20180228
  if FetchElm(RetNo, 'S3', 139) + FetchElm(RetNo, 'S3', 140) +
    FetchElm(RetNo, 'S3', 148) > '' then
    Ret[RetNo].FrmHasData[GetFormNo('S3')] := true;

  If (UpperCase(FetchElm(RetNo, 'S1A', 133)) = 'Y')
  // Or ((UpperCase(FetchElm(RetNo,'S1A',133))= 'Y') and (UpperCase(FetchElm(RetNo,'S1A',134))='N'))
  then
    Ret[RetNo].FrmHasData[GetFormNo('S1A')] := true
  Else
    Ret[RetNo].FrmHasData[GetFormNo('S1A')] := false;

  // 20160116
  FNo := GetFormNo('CFRAFILL');
  If CfrAFillHasData(RetNo, FNo) then
    Ret[RetNo].FrmHasData[GetFormNo('CFRAFILL')] := true;

  // 20140130
  If UpperCase(FetchElm(RetNo, 'RC381', 44)) = 'Y' then
    Ret[RetNo].FrmHasData[GetFormNo('RC381')] := true;

  // 20130927
  If UpperCase(FetchElm(RetNo, 'S8', 21)) = 'Y' then
    Ret[RetNo].FrmHasData[GetFormNo('S8')] := true;

  // s5   //20130213
  If UpperCase(FetchElm(RetNo, 'S5', 52)) = 'Y' then
    Ret[RetNo].FrmHasData[GetFormNo('S5')] := true;
  If UpperCase(FetchElm(RetNo, 'S5', 55)) = 'Y' then
    Ret[RetNo].FrmHasData[GetFormNo('S5')] := true;

  // 20160116 //20160216 Igor
  FNo := GetFormNo('RRSP');
  For i := 103 to 182 do
  Begin
    If FetchElmFNo(RetNo, FNo, i) > '' then
    begin
      Ret[RetNo].FrmHasData[FNo] := true;
      Break;
    end; // 20180411 break instead of exit
  end;

  // MCREDIT
  FNo := GetFormNo('MCREDIT');
  Ret[RetNo].FrmHasData[FNo] := false;
  If (Ret[RetNo].Province = 'ON') and
    (VL(FetchElmFNo(RetNo, FNo, 12)) + VL(FetchElmFNo(RetNo, FNo, 67)) > 0) then
    Ret[RetNo].FrmHasData[FNo] := true; // 20120228
  If (Ret[RetNo].Province = 'BC') and
    (VL(FetchElmFNo(RetNo, FNo, 25)) + VL(FetchElmFNo(RetNo, FNo, 37)) > 0) then
    Ret[RetNo].FrmHasData[FNo] := true;

  If (Ret[RetNo].Province = 'SK') and (VL(FetchElmFNo(RetNo, FNo, 49)) > 0) then
    Ret[RetNo].FrmHasData[FNo] := true;

  If UpperCase(FetchElm(RetNo, 'INVOICE', 285)) = 'Y' then
    Ret[RetNo].FrmHasData[GetFormNo('INVOICE')] := true;

  If UpperCase(FetchElm(RetNo, 'MB428A', 1)) = 'Y' then
    Ret[RetNo].FrmHasData[GetFormNo('MB428A')] := true;

  Ret[RetNo].FrmHasData[GetFormNo('YRSUM')] := true;

  If Ret[RetNo].MarStatus > 2 then
    Ret[RetNo].FrmHasData[GetFormNo('FAMSUM')] := false;

  If Ret[RetNo].FrmHasData[GetFormNo('PTRANSF')] then
    Ret[RetNo].FrmHasData[GetFormNo('TRANSF')] := true;

  If IsEFiledReturn(RetNo) then
  begin
    Ret[RetNo].FrmHasData[GetFormNo('T183')] := true;
    Ret[RetNo].FrmHasData[GetFormNo('T183I')] := true;
    // March 17 2008  //20140208
  end
  else
  begin
    Ret[RetNo].FrmHasData[GetFormNo('T183')] := false;
    Ret[RetNo].FrmHasData[GetFormNo('T183I')] := false;
    // March 17 2008   //20140208
  end;

  Ret[RetNo].FrmHasData[GetFormNo('DEPEND')] := false;
  i := 5;
  Repeat
    If FetchElm(RetNo, 'DEPEND', i) > '' then
      Ret[RetNo].FrmHasData[GetFormNo('DEPEND')] := true;
    inc(i, 15);
  until i > 125;
  If UpperCase(FetchElm(RetNo, 'S8', 17)) = 'Y' then
    Ret[RetNo].FrmHasData[GetFormNo('S8')] := true;

  If (VL(FetchElm(RetNo, 'S3', 105)) <> 0) Or
    (VL(FetchElm(RetNo, 'S3', 113)) <> 0) Or
    (VL(FetchElm(RetNo, 'S3', 121)) <> 0) Or
    (VL(FetchElm(RetNo, 'S3', 18)) <> 0) Or (VL(FetchElm(RetNo, 'S3', 35)) <> 0)
    Or (VL(FetchElm(RetNo, 'S3', 60)) <> 0) Or
    (VL(FetchElm(RetNo, 'S3', 71)) <> 0) then
    Ret[RetNo].FrmHasData[GetFormNo('S3')] := true;

  If (SubjectToMinTax(RetNo)) or (VL(FetchElm(RetNo, 'T691', 317)) > 0) or
    (VL(FetchElm(RetNo, 'T691', 324)) > 0) then
  begin
    Ret[RetNo].FrmHasData[GetFormNo('T691')] := true;
  end;

  For k := 1 to 5 do
  Begin
    FNo := GetFormNo('T4A#' + IntToStr(k));

    If VL(FetchElmFNo(RetNo, FNo, 44)) > 0 then
      Ret[RetNo].FrmHasData[FNo] := true;
    If VL(FetchElmFNo(RetNo, FNo, 87)) > 0 then
      Ret[RetNo].FrmHasData[FNo] := true; // 20160129
    If VL(FetchElmFNo(RetNo, FNo, 45)) > 0 then
      Ret[RetNo].FrmHasData[FNo] := true; // 20160129
    // COVID-19

    If VL(FetchElmFNo(RetNo, FNo, 93)) > 0 then
      Ret[RetNo].FrmHasData[FNo] := true; // 20160129
    If VL(FetchElmFNo(RetNo, FNo, 94)) > 0 then
      Ret[RetNo].FrmHasData[FNo] := true; // 20160129
    If VL(FetchElmFNo(RetNo, FNo, 95)) > 0 then
      Ret[RetNo].FrmHasData[FNo] := true; // 20160129
    If VL(FetchElmFNo(RetNo, FNo, 89)) > 0 then
      Ret[RetNo].FrmHasData[FNo] := true; // 20160129

    If VL(FetchElmFNo(RetNo, FNo, 98)) > 0 then
      Ret[RetNo].FrmHasData[FNo] := true; // 20160129
    If VL(FetchElmFNo(RetNo, FNo, 90)) > 0 then
      Ret[RetNo].FrmHasData[FNo] := true; // 20160129
    If VL(FetchElmFNo(RetNo, FNo, 91)) > 0 then
      Ret[RetNo].FrmHasData[FNo] := true; // 20160129
    If VL(FetchElmFNo(RetNo, FNo, 92)) > 0 then
      Ret[RetNo].FrmHasData[FNo] := true; // 20160129
    If (VL(FetchElmFNo(RetNo, FNo, 99)) > 0) or
      (VL(FetchElmFNo(RetNo, FNo, 100)) > 0) then
      Ret[RetNo].FrmHasData[FNo] := true; // 20211120

  End;

  If VL(FetchElm(RetNo, 'T4#1', 11)) > 0 then
    Ret[RetNo].FrmHasData[GetFormNo('T4#1')] := true;
  If VL(FetchElm(RetNo, 'T4#1', 47)) > 0 then
    Ret[RetNo].FrmHasData[GetFormNo('T4#1')] := true;

  If GetFormNo('T4#2') > 0 then
  begin
    If VL(FetchElm(RetNo, 'T4#2', 47)) > 0 then
      Ret[RetNo].FrmHasData[GetFormNo('T4#2')] := true;
  end;

  // CFR      //20180411
  FNo := GetFormNo('CFR');
  Ret[RetNo].FrmHasData[FNo] := false;
  For i := 1 to 57 do
  begin
    If FetchElmFNo(RetNo, FNo, i) > '' then
      Ret[RetNo].FrmHasData[FNo] := true;
  end; // first page
  For i := 59 to 77 do
  begin
    If FetchElmFNo(RetNo, FNo, i) > '' then
      Ret[RetNo].FrmHasData[FNo] := true;
  end; // first page
  // 20180411
  For i := 72 to 97 do
  begin
    If FetchElmFNo(RetNo, FNo, i) > '' then
      Ret[RetNo].FrmHasData[FNo] := true;
  end;
  For i := 263 to 292 do
  begin
    If FetchElmFNo(RetNo, FNo, i) > '' then
      Ret[RetNo].FrmHasData[FNo] := true;
  end;

  for i := 141 to 575 do // 20180811
  Begin
    Case i of
      141, 144, 100, 203, 293, 297, 259, 262, 283, 284, 287, 407, 408, 402, 406,
        432: // net cap losses
        If FetchElmFNo(RetNo, FNo, i) > '' then
          Ret[RetNo].FrmHasData[FNo] := true;
    end; // case
  end; // cfr

  // T1175   //20110320
  FNo := GetFormNo('T1175#1');
  Ret[RetNo].FrmHasData[FNo] := false;
  If (FetchElmFNo(RetNo, FNo, 1) > '') or (FetchElmFNo(RetNo, FNo, 82) > '') or
    (FetchElmFNo(RetNo, FNo, 124) > '') or (FetchElmFNo(RetNo, FNo, 148) > '')
    or (FetchElmFNo(RetNo, FNo, 159) > '') or (FetchElmFNo(RetNo, FNo, 172) > '')
  then
    Ret[RetNo].FrmHasData[FNo] := true;
  {
    Case i of
    1,82,124,148,159,172:
    If FetchElmFNo(RetNo,FNo,i)>'' then Ret[RetNo]^.FrmHasData[FNo]:= True;
    end; //case
  }
  For i := 201 to 335 do
  begin
    If FetchElmFNo(RetNo, FNo, i) > '' then
      Ret[RetNo].FrmHasData[FNo] := true;
  end;

  // T1175H  //20110320
  FNo := GetFormNo('T1175H#1');
  Ret[RetNo].FrmHasData[FNo] := false;
  If (FetchElmFNo(RetNo, FNo, 1) > '') or (FetchElmFNo(RetNo, FNo, 82) > '') or
    (FetchElmFNo(RetNo, FNo, 124) > '') or (FetchElmFNo(RetNo, FNo, 148) > '')
    or (FetchElmFNo(RetNo, FNo, 159) > '') or (FetchElmFNo(RetNo, FNo, 172) > '')
  then
    Ret[RetNo].FrmHasData[FNo] := true;
  For i := 201 to 335 do
  begin
    If FetchElmFNo(RetNo, FNo, i) > '' then
      Ret[RetNo].FrmHasData[FNo] := true;
  end;
  (*
    Case i of
    1,82,124,148,159,215,216: If FetchElmFNo(RetNo,FNo,i)>'' then Ret[RetNo]^.FrmHasData[FNo]:= True;
    end; //case
  *)

  If SplitIncome(RetNo) then // 20181215
    Ret[RetNo].FrmHasData[GetFormNo('T1206')] := true
  else
    Ret[RetNo].FrmHasData[GetFormNo('T1206')] := false;

  If UpperCase(FetchElm(RetNo, 'T2201', 127)) = 'Y' then
  Begin
    Ret[RetNo].FrmHasData[GetFormNo('T2201')] := true;
  end;

  If IsSelfEmployed(RetNo) then
    Ret[RetNo].FrmHasData[GetFormNo('BUSSUM')] := true
  else
    Ret[RetNo].FrmHasData[GetFormNo('BUSSUM')] := false;

  If Ret[RetNo].FrmHasData[GetFormNo('ACBFRM#1')] = true
  // or (Ret[RetNo].FrmHasData[GetFormNo('ACBFRM#2')] = True)) //see below /t20101020
  then
    Ret[RetNo].FrmHasData[GetFormNo('ACBSUM#1')] := true
  else
    Ret[RetNo].FrmHasData[GetFormNo('ACBSUM#1')] := false;

  FNo := GetFormNo('ACBFRM#2');
  If FNo > 0 then
  Begin
    If Ret[RetNo].FrmHasData[FNo] = true then
      Ret[RetNo].FrmHasData[GetFormNo('ACBSUM#1')] := true;
  end;

  If IsMultJurisdiction(RetNo) then
  begin
    Ret[RetNo].FrmHasData[GetFormNo('S2PRV')] := false;
    if VL(FetchElm(RetNo, 'S2PRV', 6)) > 0 then
      Ret[RetNo].FrmHasData[GetFormNo('S2PRV')] := true;
    // otherwise does not work

    Ret[RetNo].FrmHasData[GetFormNo('ON428')] := false;
    Ret[RetNo].FrmHasData[GetFormNo('AB428')] := false;
    Ret[RetNo].FrmHasData[GetFormNo('NL428')] := false;
    Ret[RetNo].FrmHasData[GetFormNo('PE428')] := false;
    Ret[RetNo].FrmHasData[GetFormNo('NS428')] := false;
    Ret[RetNo].FrmHasData[GetFormNo('NB428')] := false;
    Ret[RetNo].FrmHasData[GetFormNo('MB428')] := false;
    Ret[RetNo].FrmHasData[GetFormNo('SK428')] := false;
    Ret[RetNo].FrmHasData[GetFormNo('BC428')] := false;
    Ret[RetNo].FrmHasData[GetFormNo('YT428')] := false;
    Ret[RetNo].FrmHasData[GetFormNo('NT428')] := false;
    Ret[RetNo].FrmHasData[GetFormNo('NU428')] := false;

    Ret[RetNo].FrmHasData[GetFormNo('T2203')] := true;

    If VL(GetMjAlloc(RetNo, 'ON')) > 0 then
    begin
      Ret[RetNo].FrmHasData[GetFormNo('ONMJ')] := true;
    end
    else
    begin
      Ret[RetNo].FrmHasData[GetFormNo('ONMJ')] := false;
    end;

    If VL(GetMjAlloc(RetNo, 'AB')) > 0 then
    begin
      Ret[RetNo].FrmHasData[GetFormNo('ABMJ')] := true;
    end
    else
    begin
      Ret[RetNo].FrmHasData[GetFormNo('ABMJ')] := false;
    end;

    If VL(GetMjAlloc(RetNo, 'NL')) > 0 then
    begin
      Ret[RetNo].FrmHasData[GetFormNo('NLMJ')] := true;
    end
    else
    begin
      Ret[RetNo].FrmHasData[GetFormNo('NLMJ')] := false;
    end;

    If VL(GetMjAlloc(RetNo, 'PE')) > 0 then
    begin
      Ret[RetNo].FrmHasData[GetFormNo('PEMJ')] := true;
    end
    else
    begin
      Ret[RetNo].FrmHasData[GetFormNo('PEMJ')] := false;
    end;

    If VL(GetMjAlloc(RetNo, 'NS')) > 0 then
    begin
      Ret[RetNo].FrmHasData[GetFormNo('NSMJ')] := true;
    end
    else
    begin
      Ret[RetNo].FrmHasData[GetFormNo('NSMJ')] := false;
    end;

    If VL(GetMjAlloc(RetNo, 'NB')) > 0 then
    begin
      Ret[RetNo].FrmHasData[GetFormNo('NBMJ')] := true;
    end
    else
    begin
      Ret[RetNo].FrmHasData[GetFormNo('NBMJ')] := false;
    end;

    If VL(GetMjAlloc(RetNo, 'MB')) > 0 then
    begin
      Ret[RetNo].FrmHasData[GetFormNo('MBMJ')] := true;
    end
    else
    begin
      Ret[RetNo].FrmHasData[GetFormNo('MBMJ')] := false;
    end;

    If VL(GetMjAlloc(RetNo, 'SK')) > 0 then
    begin
      Ret[RetNo].FrmHasData[GetFormNo('SKMJ')] := true;
    end
    else
    begin
      Ret[RetNo].FrmHasData[GetFormNo('SKMJ')] := false;
    end;

    If VL(GetMjAlloc(RetNo, 'BC')) > 0 then
    begin
      Ret[RetNo].FrmHasData[GetFormNo('BCMJ')] := true;
    end
    else
    begin
      Ret[RetNo].FrmHasData[GetFormNo('BCMJ')] := false;
    end;

    If VL(GetMjAlloc(RetNo, 'YT')) > 0 then
      Ret[RetNo].FrmHasData[GetFormNo('YTMJ')] := true
    else
      Ret[RetNo].FrmHasData[GetFormNo('YTMJ')] := false;

    If VL(GetMjAlloc(RetNo, 'NT')) > 0 then
      Ret[RetNo].FrmHasData[GetFormNo('NTMJ')] := true
    else
      Ret[RetNo].FrmHasData[GetFormNo('NTMJ')] := false;

    If VL(GetMjAlloc(RetNo, 'NU')) > 0 then
    begin
      Ret[RetNo].FrmHasData[GetFormNo('NUMJ')] := true;
    end
    else
    begin
      Ret[RetNo].FrmHasData[GetFormNo('NUMJ')] := false;
    end;

  end { mult jurisd }
  else
  begin { clear indicators }
    for i := 0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      If (FRec.FormName = 'S2MJ') or (FRec.FormName = 'S11MJ') then
      begin
        Ret[RetNo].FrmHasData[FRec.FormNo] := false;
      end;
    end;

  end;
  // ShowMessage('Update All Data Indicators finished');
end;

Procedure InfoOn;
begin
  MdiPaint(GetCurrentRetNo); // SendMessage(MDIHandle,WM_PAINT,0,0);
end;

Function GetSpRetNo(RetNo: integer): integer;
Var
  i, RNo: integer;
  SpouseSin1, SpouseSin2: string; // [11];
  // InfoFNo:Integer;
begin
  Result := 0;
  If RetNo = 0 then
    Exit;
  // InfoFNo:=GetFormNo('INFO');
  SpouseSin1 := FetchElmFNo(RetNo, InfoFNo, 3);
  SpouseSin2 := FetchElmFNo(RetNo, InfoFNo, 4);
  If SpouseSin1 + SpouseSin2 = '' then
    Exit;
  for i := 1 to (RetList.Count - 1) do
  begin
    RetRec := Ret[i];
    if RetRec = nil then
      continue;
    RNo := RetRec.RetNo;
    If (FetchElmFNo(RNo, InfoFNo, 3) = SpouseSin2) and
      (FetchElmFNo(RNo, InfoFNo, 4) = SpouseSin1) then
    begin
      Result := RNo;
      Exit;
    end;
  end;
end;

Function GetParentRetNo(Sin: String): integer;
Var
  i, j, RNo: integer;
begin
  Result := 0;
  If Sin = '' then
    Exit;
  // DependFNo := GetFormNo('DEPEND');
  for i := 1 to (RetList.Count - 1) do
  begin
    RetRec := Ret[i];
    if RetRec = nil then
      continue;
    RNo := RetRec.RetNo;
    j := 7; { search dependendts screen }
    Repeat
      If FetchElm(RNo, 'DEPEND', j) = Sin then
      begin
        Result := RNo;
        Exit;
      end;
      inc(j, 15);
    until j > 127;
  end;
end;

Function GetRetNoFromSin(Sin: String): integer;
Var
  i: integer;
begin
  Result := 0;
  If Sin = '' then
    Exit;
  for i := 1 to (RetList.Count - 1) do
  begin
    RetRec := Ret[i];
    if RetRec = nil then
      continue;
    If GetSinNo(RetRec.RetNo) = Sin then
    begin
      Result := RetRec.RetNo;
      Exit;
    end;
  end;
end;

Function ShowUnconvertedLastYear(RNo: integer): Boolean;
Var
  i: integer;
begin
  Result := false;
  If RNo = 0 then
    Exit;
  Result := Ret[RNo].IsLastYearReturn; // 20160314 Igor
end;

Function CalcDaysInCan(RetNo: integer): integer;
Var
  D1, D2: string; // [20];
  // InfoFNo:Integer;
begin
  // InfoFNo:=GetFormNo('INFO');
  With Ret[RetNo] do
  begin
    If ((Frm[InfoFNo].Strings[25] > '') and (Frm[InfoFNo].Strings[26] > '')) or
      ((Frm[InfoFNo].Strings[27] > '') and (Frm[InfoFNo].Strings[28] > '')) then
    begin
      If Length(Frm[InfoFNo].Strings[25] + Frm[InfoFNo].Strings[26]) < 4 then
        D1 := '01/01/' + AppYear
      else
        D1 := Frm[InfoFNo].Strings[26] + '/' + Frm[InfoFNo].Strings[25] + '/'
          + AppYear;
      If Length(Frm[InfoFNo].Strings[27] + Frm[InfoFNo].Strings[28]) < 4 then
        D2 := '12/31/' + AppYear
      else
        D2 := Frm[InfoFNo].Strings[28] + '/' + Frm[InfoFNo].Strings[27] + '/'
          + AppYear;
      Result := DateDiffMDY(D1, D2) + 1; // 20090113
    end
    else
      Result := Constant[RY].FullYear;
  end;
  If Result < 0 then
    Result := 0;
end;

Function CalcBusDays(RetNo: integer; Stmt: String): integer;
Var
  D1, D2: string; // [20];
  FInst: String;
begin
  Result := 365;
  If IsLeapYear(StrToInt(AppYear)) then
    Result := 366;
  FInst := ExtractFormInst(Stmt);
  Stmt := LeftStr(Stmt, 5);
  With Ret[RetNo] do
  begin
    If Stmt = 'T2125' then
    begin
      D1 := FetchElm(RetNo, Stmt + FInst, 4);
      D2 := FetchElm(RetNo, Stmt + FInst, 5);
    end
    Else If Stmt = 'T2121' then
    begin
      D1 := FetchElm(RetNo, Stmt + FInst, 4);
      D2 := FetchElm(RetNo, Stmt + FInst, 5);
    end
    Else If Stmt = 'T2042' then
    begin
      D1 := FetchElm(RetNo, Stmt + FInst, 4);
      D2 := FetchElm(RetNo, Stmt + FInst, 5);
    end
    Else If Stmt = 'T1163' then
    begin
      // 20210405
      D1 := FetchElm(RetNo, Stmt + FInst, 213);
      D2 := FetchElm(RetNo, Stmt + FInst, 214);
      {
        D1 := FetchElm(RetNo, Stmt + FInst, 113);
        D2 := FetchElm(RetNo, Stmt + FInst, 114);
      }
    end
    Else If Stmt = 'T1273' then
    begin
      D1 := FetchElm(RetNo, Stmt + FInst, 213);
      D2 := FetchElm(RetNo, Stmt + FInst, 214);
    end;

    If Length(D1) <> 10 then
      D1 := AppYear + '-01-01';
    If Length(D2) <> 10 then
      D2 := AppYear + '-12-31';
    Result := DateDiff(YMDtoDate(D1), YMDtoDate(D2)) + 1;
    If Result < 0 then
      Result := 0;
  end;
end;

Function WhichCreditForm(RetNo: integer; ShortPrv: string): String;
begin

  if ShortPrv = 'NL' then
    Result := 'NL479' // not 428  //202230207
  else if ShortPrv = 'PE' then
    Result := 'PE428'
  else if ShortPrv = 'NS' then
    Result := 'NS479'
  else if ShortPrv = 'NB' then
    Result := 'NB428'
  else if ShortPrv = 'QC' then
    Result := ''
  else if ShortPrv = 'ON' then
    Result := 'ON479'
  else if ShortPrv = 'MB' then
    Result := 'MB479'
  else if ShortPrv = 'SK' then
    Result := 'SK479' // 'SK428'   //20240210
  else if ShortPrv = 'AB' then
    Result := 'AB428'
  else if ShortPrv = 'BC' then
    Result := 'BC479'
  else if ShortPrv = 'NT' then
    Result := 'NT479'
  else if ShortPrv = 'YT' then
    Result := 'YT479'
  else if ShortPrv = 'NU' then
    Result := 'NU479'
  else if ShortPrv = 'ZZ' then
    Result := ''
end;

Function WhichTaxForm(RetNo: integer; ShortPrv: string): String;
begin
  If ShortPrv = 'NL' then
    Result := 'NL428'
  else if ShortPrv = 'PE' then
    Result := 'PE428'
  else if ShortPrv = 'NS' then
    Result := 'NS428'
  else if ShortPrv = 'NB' then
    Result := 'NB428'
  else if ShortPrv = 'QC' then
    Result := ''
  else if ShortPrv = 'ON' then
    Result := 'ON428'
  else if ShortPrv = 'MB' then
    Result := 'MB428'
  else if ShortPrv = 'SK' then
    Result := 'SK428'
  else if ShortPrv = 'AB' then
    Result := 'AB428'
  else if ShortPrv = 'BC' then
    Result := 'BC428'
  else if ShortPrv = 'NT' then
    Result := 'NT428'
  else if ShortPrv = 'YT' then
    Result := 'YT428'
  else if ShortPrv = 'NU' then
    Result := 'NU428'
  else if ShortPrv = 'ZZ' then
    Result := ''
end;

Procedure ShowChmHelp(HelpFile: String; Helptopic: string);
Var
  h: THandle;
  RetCode: LongInt;
begin
  // open the help file
  // h:=HtmlHelp(0,Pchar(HelpFile),HH_DISPLAY_TOPIC,0);
  // h:=HH(0,Pchar(HelpFile),HH_DISPLAY_TOPIC,0);
  // Application.HelpFile := AppDir+'\'+HelpFile;
  // Application.HelpJump(HelpTopic);
  // RetCode:=HH(Handle, MYHELP_FILE, HH_HELP_CONTEXT, iHelpID)
  // RetCode:=HH(Handle, HelpFile+Chr(0), HelpTopic+Chr(0), 0);
end;

Procedure ShowHelp(HelpFile: String; Helptopic: string;
  AisWeb: Boolean = false); // 20160801 Igor
// Var RetCode: LongInt;  iHelpID: LongInt;
begin
  if not AisWeb then // 20160801 Igor
    HelpFile := AppDir + '\' + HelpFile + '.PHP'; // 20181221 It does not work
  // HelpFile:=AppDir+'\'+HelpFile+'.CHM';
  vtDialogs.ShowHelp(HelpFile, Helptopic, AisWeb); // 20160801 Igor
  // ShellExecute(0, 'open', PWideChar(HelpFile), nil, nil, SW_SHOW); //20160525 Igor //20160801 Igor
  // // iHelpId:=0;
  // if HtmlHelpInstalled = True then
  // begin
  // if HelpTopic='HELP_CONTENTS' then
  // RetCode := HH(0, PChar(HelpFile), HH_DISPLAY_TOPIC,0)
  // else
  // RetCode := HH(0, PChar(HelpFile+'::/'+HelpTopic+'.html'), HH_DISPLAY_TOPIC,0);
  // end
  // else
  // begin
  // ShowMessage('Please install at least v4.01 of Internet Explorer before '+
  // 'displaying a CHM file');
  // end;
  // (*
  // Application.HelpFile := AppDir+'\'+HelpFile+'.HLP';
  // If HelpTopic='HELP_CONTENTS' then
  // Application.HelpCommand(HELP_CONTENTS, 0)
  // else
  // Application.HelpJump(HelpTopic);
  // *)
end;

Function ReformatSin(S: string): String;
begin
  If Length(S) < 9 then
  begin
    Result := S;
    Exit;
  end;
  Result := LeftStr(S, 3) + '-' + MidStr(S, 4, 3) + '-' + RightStr(S, 3);
  If Result = '--' then
    Result := '';
end;

Function ReformatSinWithSpaceInBetween(S: string): String;
// 20180310 CON 9:54PM
begin
  If Length(S) < 9 then
  begin
    Result := S;
    Exit;
  end;
  Result := LeftStr(S, 3) + ' ' + MidStr(S, 4, 3) + ' ' + RightStr(S, 3);
  If Result = '  ' then
    Result := '';
end;

Function GetTheTime(Dt: TDateTime): String;
Var
  SHours, SMinutes, SSeconds: string; // [2];
  Hour, Min, Sec, Msec: word;
begin
  DecodeTime(Now, Hour, Min, Sec, Msec);
  SHours := IntToStr(Hour);
  SMinutes := IntToStr(Min);
  { sSeconds := IntToStr(Sec); }
  If Length(SHours) = 1 then
    SHours := '0' + SHours;
  If Length(SMinutes) = 1 then
    SMinutes := '0' + SMinutes;
  { If Length(SSeconds) =1 then SSeconds := '0'+SSeconds; }
  Result := SHours + SMinutes;
  { +SSeconds; }
end;

// 20160523 Igor Move to vtTrimStr
// Function GetTimeToMilliSec(Dt:tDateTime):String;
// Var SHours, SMinutes,SSeconds : string[2];
// Hour,Min,Sec,Msec :word;
// begin
// DecodeTime(Now,Hour,Min,Sec,Msec);
// sHours := IntToStr(Hour);
// sMinutes := IntToStr(Min);
// sSeconds := IntToStr(Sec);
// If Length(SHours)   =1 then SHours   := '0'+SHours;
// If Length(sMinutes) =1 then SMinutes := '0'+SMinutes;
// If Length(SSeconds) =1 then SSeconds := '0'+SSeconds;
// Result := sHours+':'+SMinutes+':'+SSeconds;
// end;

Function MakeEFFileName(LicenseLevel: string): string;
Var
  YYYY, MM, DD, Hour, Min, Sec, Msec: word;
  SMM, SDD, SMin, SSec: string; // [2];
begin
  DecodeDate(Now, YYYY, MM, DD);
  DecodeTime(Now, Hour, Min, Sec, Msec);
  SMM := LTrim(RTrim(IntToStr(MM)));
  SDD := LTrim(RTrim(IntToStr(DD)));
  SMin := LTrim(RTrim(IntToStr(Min)));
  SSec := LTrim(RTrim(IntToStr(Sec)));
  If Length(SMM) = 1 then
    SMM := '0' + SMM;
  If Length(SDD) = 1 then
    SDD := '0' + SDD;
  If Length(SMin) = 1 then
    SMin := '0' + SMin;
  If Length(SSec) = 1 then
    SSec := '0' + SSec;
  If LeftStr(LicenseLevel, 8) = 'T1 Multi' then
    Result := LeftStr(User.UserName, 4) + SDD + SSec { User.M_Office+SDD+SSec }
    // 20170112 Igor
  Else
    Result := SMM + SDD + SMin + SSec;
end;

Function NoDecimal(S: string): String;
Var
  x: Real;
Begin
  x := VL(S);
  x := x * 100 + 50;
  x := x / 100;
  x := INT(x);
  Result := FloatToSTR(x);
End;

Function EditDate(S: String; MxYear: integer): Boolean;
{ In form dd-mm-yyyy }
begin
  Result := EditDateDMY(S, 1880, MxYear, '-');
end;

Function EditDateYYYYMMDD(S: String; MxYear: integer): Boolean;
{ In form yyyy-mm-dd }
begin
  Result := EditDateYMD(S, 1990, MxYear, '-');
end;

Function EditLongPrv(Value: string): Boolean;
Var
  i: integer;
begin
  Result := false;
  For i := Low(PrvLong) to High(PrvLong) do
  begin
    If Value = PrvLong[i] then
    begin
      Result := true;
      Exit;
    end;
  end;
end;

Function GetShortPrv(LPrv: string): String;
Var
  i: integer;
Begin
  Result := PrvShort[1];
  For i := 1 to High(PrvLong) do
  begin
    If LPrv = PrvLong[i] then
    begin
      Result := PrvShort[i];
      Exit;
    end;
  end;
End;

Function GetLongPrv(SPrv: string): String;
Var
  i: integer;
Begin
  Result := PrvLong[1];
  For i := 1 to High(PrvShort) do
  begin
    If SPrv = PrvShort[i] then
    begin
      Result := PrvLong[i];
      Exit;
    end;
  end;
End;

Function GetRowFromSlip(RetNo: integer; FormName: string; Row: integer;
  ExchRow: integer; ShareRow: integer): Real;
Var
  i, FNo: integer;
  ExchRate, SharePercent: Real;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = FormName then
    begin
      FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] then // 20170324 Igor
      begin
        ExchRate := 1;
        If ExchRow > 0 then
        begin
          If VL(Ret[RetNo].Frm[FNo].Strings[ExchRow]) > 0 then
            ExchRate := VL(Ret[RetNo].Frm[FNo].Strings[ExchRow])
        end
        else
          ExchRate := 1;
        SharePercent := 100;
        If (ShareRow > 0) and
          (LTrim(RTrim(Ret[RetNo].Frm[FNo].Strings[ShareRow])) > '') then
          SharePercent := VL(Ret[RetNo].Frm[FNo].Strings[ShareRow]);
        Result := Result + (VL(Ret[RetNo].Frm[FNo].Strings[Row])) * ExchRate *
          SharePercent / 100;
      end; { has data }
    end; { it is right slip }
  end; { i loop }
end;

Function SumT3MultBox(RetNo: integer; elm: integer): Real;
Var
  i, FNo: integer;
  PercentShare, ExchRate: Real;
begin
  Result := TotMultiple(RetNo, 'T3MULT', elm);
end;

Function GetFPENSByCountry(RetNo: integer; Country: String;
  AmtType: String): Real;
Var
  i, FNo, Row, CountryRow, ExchRow: integer;
  ExchRate, SharePercent: Real;
  FName: string; // [10];
begin
  Row := 0; // init
  If AmtType = 'I' then
    Row := 4 { Income }
  else if AmtType = 'T' then
    Row := 5 { Tax }
  else if AmtType = 'E' then
    Row := 6; { Exempt }
  ExchRow := 3;
  CountryRow := 2;
  Result := 0;
  FName := 'FPENS';
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = FName then
    begin
      FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] then // 20170324 Igor
      begin
        If ExchRow > 0 then
          ExchRate := VL(Ret[RetNo].Frm[FNo].Strings[ExchRow])
        else
          ExchRate := 1;
        If LeftStr(Ret[RetNo].Frm[FNo].Strings[CountryRow], 1) = Country then
        begin
          If (UpperCase(FetchElmFNo(RetNo, FNo, 7)) = 'Y') // us soc sec
            and ((AmtType = 'I') or (AmtType = 'E')) // income or exempt
            and (VL(FetchElmFNo(RetNo, FNo, 5)) = 0) // tax =0
          then // us soc sec
            // do nothing
          else
          begin
            if ExchRate > 0 then { exch rate }
              Result := Result + (VL(Ret[RetNo].Frm[FNo].Strings[Row]))
                * ExchRate
            else
              Result := Result + VL(Ret[RetNo].Frm[FNo].Strings[Row]);
          end;
        end;
      end;
    end;
  end;
end;

Function GetForeignFromSlip(RetNo: integer; FormName: string; Row: integer;
  ExchRow: integer; ShareRow: integer; CountryCode: integer;
  CountryRow: integer): Real;
Var
  i, FNo, SlipCountry: integer;
  ExchRate, SharePercent: Real;
begin
  Result := 0;
  SharePercent := 0; // Con???
  ExchRate := 0; // Con???
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = FormName then
    begin
      FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] then // 20170324 Igor
      begin
        If ExchRow > 0 then
          ExchRate := VL(Ret[RetNo].Frm[FNo].Strings[ExchRow]);
        If ExchRate = 0 then
          ExchRate := 1;
        If CountryCode = 0 then
          CountryCode := 1;
        If ShareRow > 0 then
          SharePercent := VL(Ret[RetNo].Frm[FNo].Strings[ShareRow]);
        If SharePercent = 0 then
          SharePercent := 100.0;
        If FormName = 'T4PS' then
          Result := Result + VL(Ret[RetNo].Frm[FNo].Strings[Row])
        else { other slips }
        begin
          If LTrim(RTrim(Ret[RetNo].Frm[FNo].Strings[CountryRow])) = '' then
            SlipCountry := 1
          else
            SlipCountry :=
              StrToInt(LTrim(RTrim(Ret[RetNo].Frm[FNo].Strings[CountryRow])));
          If SlipCountry = CountryCode then
            Result := Result + (VL(Ret[RetNo].Frm[FNo].Strings[Row])) * ExchRate
              * SharePercent / 100;
        end;
      end;
    end;
  end;
end;

Procedure T4AProcess(RetNo: integer; Var T4AOthInc: Real; Var T4APens: Real;
  Var T4ARPP: Real; Var T4APAdj: Real; Var T4AOthEmpl: Real; Var T4ADon: Real;
  Var T4ATax: Real; Var T4ANorthA: Real; Var T4ANorthB: Real;
  Var T4APastRppW: Real; Var T4APastRppWNot: Real; Var T4ARESP: Real;
  Var T4ARespEduc: Real; Var T4AResp22: Real;
  Var T4AAnnuity, T4ARDSP, T4ACovidIncome: Real);

Var
  i, FNo: integer;
begin
  T4AOthInc := 0;
  T4APens := 0;
  T4ARPP := 0;
  T4APAdj := 0;
  T4AOthEmpl := 0;
  T4ADon := 0;
  T4ATax := 0;
  T4ANorthA := 0;
  T4ANorthB := 0;
  T4APastRppW := 0;
  T4APastRppWNot := 0;
  T4ARESP := 0;
  T4ARespEduc := 0;
  T4AResp22 := 0;
  T4AAnnuity := 0;
  T4ARDSP := 0;
  T4ACovidIncome := 0; // 20210315

  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'T4A' then
    begin
      FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] then // 20170324 Igor
      begin
        // 20210315
        T4ACovidIncome := T4ACovidIncome + VL(Ret[RetNo].Frm[FNo].Strings[93]) +
          VL(Ret[RetNo].Frm[FNo].Strings[94]) +
          VL(Ret[RetNo].Frm[FNo].Strings[95]) +
          VL(Ret[RetNo].Frm[FNo].Strings[89]) +
          VL(Ret[RetNo].Frm[FNo].Strings[90]) +
          VL(Ret[RetNo].Frm[FNo].Strings[91]) +
          VL(Ret[RetNo].Frm[FNo].Strings[92]) +
          VL(Ret[RetNo].Frm[FNo].Strings[100]) // 20230416
          ;
        T4AOthEmpl := T4AOthEmpl +
        // Vl(Ret[RetNo].Frm[FNo].Strings[19])  {rpp non elig}  //20110118
          +VL(Ret[RetNo].Frm[FNo].Strings[48]) { research grants code 104 }
          + VL(Ret[RetNo].Frm[FNo].Strings[35]) { wage loss code 107 }
        // 20110118
          + VL(Ret[RetNo].Frm[FNo].Strings[49]) { Medical benefits code 118 }
          + VL(Ret[RetNo].Frm[FNo].Strings[30])
        { premiums paid to group life ins plan code 119 }
          + VL(Ret[RetNo].Frm[FNo].Strings[57]) { veteran benefits code 127 }
        // 20110118
          + VL(Ret[RetNo].Frm[FNo].Strings[59]) { wage protection code 132 }
          + VL(Ret[RetNo].Frm[FNo].Strings[53]) { SUBP code 152 } // 20110118
          + VL(Ret[RetNo].Frm[FNo].Strings[63]); { Bunkcruptcy 156 }
        // 20110118

        T4APens := T4APens + VL(Ret[RetNo].Frm[FNo].Strings[1]) +
          VL(Ret[RetNo].Frm[FNo].Strings[15]); // 20131012
        T4ARDSP := T4ARDSP + VL(Ret[RetNo].Frm[FNo].Strings[55]);
        // 20110118
        T4AOthInc := T4AOthInc + VL(Ret[RetNo].Frm[FNo].Strings[7])
        // 028  oth income
          + VL(Ret[RetNo].Frm[FNo].Strings[2]) // 018 lumpsum
          + VL(Ret[RetNo].Frm[FNo].Strings[6]) // 026
          + VL(Ret[RetNo].Frm[FNo].Strings[42]) // 027
          + VL(Ret[RetNo].Frm[FNo].Strings[45]) // 030
          + VL(Ret[RetNo].Frm[FNo].Strings[43]) // 040

        // + VL(Ret[RetNo].Frm[FNo].Strings[47]) // 105  //20191124
          + VL(Ret[RetNo].Frm[FNo].Strings[34])
        // 106  20110305 //+Vl(Ret[RetNo].Frm[FNo].Strings[52]) //106
          + VL(Ret[RetNo].Frm[FNo].Strings[66]) // 109
          + VL(Ret[RetNo].Frm[FNo].Strings[39]) // 117
          + VL(Ret[RetNo].Frm[FNo].Strings[28]) // 123
          + VL(Ret[RetNo].Frm[FNo].Strings[50]) // 125
          + VL(Ret[RetNo].Frm[FNo].Strings[58]) // 129
          + VL(Ret[RetNo].Frm[FNo].Strings[55]) // 130
          + VL(Ret[RetNo].Frm[FNo].Strings[61]) // 134
          + VL(Ret[RetNo].Frm[FNo].Strings[64]) // 150
          + VL(Ret[RetNo].Frm[FNo].Strings[65]) // 154
          ;
        (*
          T4AOthInc := T4AOthInc
          +Vl(Ret[RetNo].Frm[FNo].Strings[2])
          +Vl(Ret[RetNo].Frm[FNo].Strings[6])
          +Vl(Ret[RetNo].Frm[FNo].Strings[42])
          +Vl(Ret[RetNo].Frm[FNo].Strings[7])
          +Vl(Ret[RetNo].Frm[FNo].Strings[45])

          +Vl(Ret[RetNo].Frm[FNo].Strings[43])
          {+Vl(Ret[RetNo].Frm[FNo].Strings[50]) already in strings[7]}
          {less amounts that do not go to other income box 28 elm 7}
          -Vl(Ret[RetNo].Frm[FNo].Strings[56])  {RDSP}
          -Vl(Ret[RetNo].Frm[FNo].Strings[19])  {grants}
          -Vl(Ret[RetNo].Frm[FNo].Strings[30])  {group life insurance}
          -Vl(Ret[RetNo].Frm[FNo].Strings[48])  {research grants}
          -Vl(Ret[RetNo].Frm[FNo].Strings[49])  {medical benefits}
          -Vl(Ret[RetNo].Frm[FNo].Strings[46]) {scholarsh ded}
          -Vl(Ret[RetNo].Frm[FNo].Strings[32]) {wage loss}
          // -Vl(Ret[RetNo].Frm[FNo].Strings[27]) {DPSP annuity instalments why?} //2008-02
          -Vl(Ret[RetNo].Frm[FNo].Strings[59])  {wage protection} //20100307
          -Vl(Ret[RetNo].Frm[FNo].Strings[33]); {Status indian}
        *)
        If ((Ret[RetNo].Age >= 65) or (UpperCase(Ret[RetNo].Frm[FNo].Strings[41]
          ) = 'Y') { box 24/annuities }
          or (VL(Ret[RetNo].Frm[FNo].Strings[27]) > 0)) then
        begin
          T4APens := T4APens + VL(Ret[RetNo].Frm[FNo].Strings[5]);
          T4AAnnuity := T4AAnnuity + VL(Ret[RetNo].Frm[FNo].Strings[5]);
        end
        else
          T4AOthInc := T4AOthInc + VL(Ret[RetNo].Frm[FNo].Strings[5]);
        // 20100307
        If ((Ret[RetNo].Age >= 65) or (UpperCase(Ret[RetNo].Frm[FNo].Strings[41]
          ) = 'Y')) { box 24/annuities }
        then
        begin
          T4APens := T4APens + VL(Ret[RetNo].Frm[FNo].Strings[60]);
          // T4AOthInc := T4AOthInc-Vl(Ret[RetNo].Frm[FNo].Strings[60]);  //20110118
        end
        ELSE
          T4AOthInc := T4AOthInc + VL(Ret[RetNo].Frm[FNo].Strings[60]);
        // 20110118

        T4ARPP := T4ARPP + VL(Ret[RetNo].Frm[FNo].Strings[8]); { box32 }
        T4APastRppW := T4APastRppW + VL(Ret[RetNo].Frm[FNo].Strings[26]);
        T4APastRppWNot := T4APastRppWNot + VL(Ret[RetNo].Frm[FNo].Strings[37]);
        T4APAdj := T4APAdj + VL(Ret[RetNo].Frm[FNo].Strings[9]); { box34 }

        T4ADon := T4ADon + VL(Ret[RetNo].Frm[FNo].Strings[10]); { box 46 }
        T4ATax := T4ATax + VL(Ret[RetNo].Frm[FNo].Strings[4]); { box 22 }
        T4ANorthA := T4ANorthA + VL(Ret[RetNo].Frm[FNo].Strings[40]);
        T4ANorthB := T4ANorthB + VL(Ret[RetNo].Frm[FNo].Strings[38]);
        T4ARESP := T4ARESP + VL(Ret[RetNo].Frm[FNo].Strings[43]);
        T4ARespEduc := T4ARespEduc + VL(Ret[RetNo].Frm[FNo].Strings[44]);
        If Ret[RetNo].Frm[FNo].Strings[12] = '22' then
          T4AResp22 := T4AResp22 + VL(Ret[RetNo].Frm[FNo].Strings[43]);
      end;
    end;
  end;
end;

Procedure T4RSPProcess(RetNo: integer; Var T4RspIncome: Real;
  Var T4RspOthDed: Real; Var T4RspTax: Real; Var T4RspSpBox20: Real;
  Var T4RspSpBox22: Real; Var T4RspSpBox26: Real);
Var
  i, FNo: integer;
begin
  T4RspIncome := 0;
  T4RspOthDed := 0;
  T4RspTax := 0;
  T4RspSpBox20 := 0;
  T4RspSpBox22 := 0;
  T4RspSpBox26 := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'T4RSP' then
    begin
      FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] then // 2070322 Igor
      begin
        T4RspIncome := T4RspIncome + VL(Ret[RetNo].Frm[FNo].Strings[2]) +
          VL(Ret[RetNo].Frm[FNo].Strings[3]) + VL(Ret[RetNo].Frm[FNo].Strings[4]
          ) + VL(Ret[RetNo].Frm[FNo].Strings[12]);
        If UpperCase(Ret[RetNo].Frm[FNo].Strings[20]) <> 'Y' then
        begin
          T4RspIncome := T4RspIncome + VL(Ret[RetNo].Frm[FNo].Strings[5]) +
            VL(Ret[RetNo].Frm[FNo].Strings[6]) +
            VL(Ret[RetNo].Frm[FNo].Strings[8]);
        end
        else
        begin
          T4RspSpBox20 := T4RspSpBox20 + VL(Ret[RetNo].Frm[FNo].Strings[5]);
          T4RspSpBox22 := T4RspSpBox22 + VL(Ret[RetNo].Frm[FNo].Strings[6]);
          T4RspSpBox26 := T4RspSpBox26 + VL(Ret[RetNo].Frm[FNo].Strings[8]);
        end;

        T4RspTax := T4RspTax + VL(Ret[RetNo].Frm[FNo].Strings[11]);
        if VL(Ret[RetNo].Frm[FNo].Strings[9]) < 0 then
          T4RspOthDed := T4RspOthDed + ABS(VL(Ret[RetNo].Frm[FNo].Strings[9]))
        else
          T4RspIncome := T4RspIncome + VL(Ret[RetNo].Frm[FNo].Strings[9]);
      end;
    end;
  end;
end;

Procedure T4RIFProcess(RetNo: integer; Var T4RIFOthInc: Real;
  Var T4RIFPens: Real; Var T4RIFTax: Real; Var T4RIFAnnuity: Real;
  Var T4RIFSpBox16: Real; Var T4RIFSpBox20: Real; Var T4RIFSpBox24: Real);
Var
  i, FNo: integer;
begin
  T4RIFOthInc := 0;
  T4RIFPens := 0;
  T4RIFTax := 0;
  T4RIFAnnuity := 0;
  T4RIFSpBox16 := 0;
  T4RIFSpBox20 := 0;
  T4RIFSpBox24 := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'T4RIF' then
    begin
      FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] then // 20170324 Igor
      begin
        If (UpperCase(Ret[RetNo].Frm[FNo].Strings[16]) = 'Y')
        { death of spouse }
          or (Ret[RetNo].Age >= 65) then
        begin
          If UpperCase(Ret[RetNo].Frm[FNo].Strings[15]) <> 'Y' then
          // non spousal
          begin
            T4RIFPens := T4RIFPens + VL(Ret[RetNo].Frm[FNo].Strings[2])
            // feb 2008
              + VL(Ret[RetNo].Frm[FNo].Strings[4]) +
              VL(Ret[RetNo].Frm[FNo].Strings[5]);
            // +Vl(Ret[RetNo].Frm[FNo].Strings[6]);  //20090326
            T4RIFAnnuity := T4RIFAnnuity + VL(Ret[RetNo].Frm[FNo].Strings[2]);
          end;
        end // due to death of spouse
        else // not due to death of spouse
        begin
          If UpperCase(Ret[RetNo].Frm[FNo].Strings[15]) <> 'Y' then
          // non spousal
          begin
            T4RIFOthInc := T4RIFOthInc + VL(Ret[RetNo].Frm[FNo].Strings[2])
            // Feb 2008
              + VL(Ret[RetNo].Frm[FNo].Strings[4]) +
              VL(Ret[RetNo].Frm[FNo].Strings[5]);
            // +Vl(Ret[RetNo].Frm[FNo].Strings[6]);  20090326
          end;
        end;
        T4RIFTax := T4RIFTax + VL(Ret[RetNo].Frm[FNo].Strings[7]);
        If UpperCase(Ret[RetNo].Frm[FNo].Strings[15]) = 'Y' then
        begin
          T4RIFSpBox16 := T4RIFSpBox16 + VL(FetchElmFNo(RetNo, FNo, 2));
          T4RIFSpBox20 := T4RIFSpBox20 + VL(FetchElmFNo(RetNo, FNo, 4));
          T4RIFSpBox24 := T4RIFSpBox24 + VL(FetchElmFNo(RetNo, FNo, 8));
        end;
      end; // has data
    end; // T4Rif
  end; // i
end;

Procedure T101Process(RetNo: integer; Var T101CEE: Real; Var T101AllowCEE: Real;
  Var T101CDE: Real; Var T101AllowCDE: Real; Var T101COGPE: Real;
  Var T101AllowCOGPE: Real);
Var
  i, FNo: integer;
begin
  T101CEE := 0;
  T101AllowCEE := 0;
  T101CDE := 0;
  T101AllowCDE := 0;
  T101COGPE := 0;
  T101AllowCOGPE := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'T101' then
    begin
      FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] then // 20170324 Igor
      begin
        T101CEE := T101CEE + VL(Ret[RetNo].Frm[FNo].Strings[2]);
        // +Vl(Ret[RetNo].Frm[FNo].Strings[9]);
        T101AllowCEE := T101AllowCEE + VL(Ret[RetNo].Frm[FNo].Strings[5]);
        T101CDE := T101CDE + VL(Ret[RetNo].Frm[FNo].Strings[3]);
        // +Vl(Ret[RetNo].Frm[FNo].Strings[11]);
        T101AllowCDE := T101AllowCDE + VL(Ret[RetNo].Frm[FNo].Strings[12]);
        // T101COGPE := T101COGPE+Vl(Ret[RetNo].Frm[FNo].Strings[4])+Vl(Ret[RetNo].Frm[FNo].Strings[13]);
        // T101AllowCOGPE := T101AllowCOGPE+Vl(Ret[RetNo].Frm[FNo].Strings[10]);
      end;
    end;
  end;
end;

Procedure T102Process(RetNo: integer; Var T102CEE: Real; Var T102AllowCEE: Real;
  Var T102CDE: Real; Var T102AllowCDE: Real; Var T102COGPE: Real;
  Var T102AllowCOGPE: Real; Var T102PShipInc: Real);
Var
  i, FNo: integer;
begin
  T102CEE := 0;
  T102AllowCEE := 0;
  T102CDE := 0;
  T102AllowCDE := 0;
  T102COGPE := 0;
  T102AllowCOGPE := 0;
  T102PShipInc := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'T102' then
    begin
      FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] then // 20170324 Igor
      begin
        T102CEE := T102CEE + VL(Ret[RetNo].Frm[FNo].Strings[2]);
        T102AllowCEE := T102AllowCEE + VL(Ret[RetNo].Frm[FNo].Strings[6]);
        T102CDE := T102CDE + VL(Ret[RetNo].Frm[FNo].Strings[3]);
        T102AllowCDE := T102AllowCDE + VL(Ret[RetNo].Frm[FNo].Strings[11]);
        T102COGPE := T102COGPE + VL(Ret[RetNo].Frm[FNo].Strings[4]);
        T102AllowCOGPE := T102AllowCOGPE + VL(Ret[RetNo].Frm[FNo].Strings[12]);
        T102PShipInc := T102PShipInc + VL(Ret[RetNo].Frm[FNo].Strings[1]);
      end;
    end;
  end;
end;

Procedure T4APProcess(RetNo: integer; Var T4APOAS: Real; Var T4APCppBnf: Real;
  Var T4APDisabBnf: Real; Var T4APTax: Real; Var T4APCppMonths: integer;
  Var T4APDisabMonths: integer);
Var
  i, FNo: integer;
begin
  T4APOAS := 0;
  T4APCppBnf := 0;
  T4APDisabBnf := 0;
  T4APTax := 0;
  T4APCppMonths := 0;
  T4APDisabMonths := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'T4AP' then
    begin
      FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] then // 20170324 Igor
      begin
        T4APCppBnf := T4APCppBnf + VL(Ret[RetNo].Frm[FNo].Strings[4]);
        T4APDisabBnf := T4APDisabBnf + VL(Ret[RetNo].Frm[FNo].Strings[13]);
        T4APTax := T4APTax + VL(Ret[RetNo].Frm[FNo].Strings[7]);

        // 20121115
        If Numeric(Ret[RetNo].Frm[FNo].Strings[8]) then
        begin
          If VL(Ret[RetNo].Frm[FNo].Strings[11]) +
            VL(Ret[RetNo].Frm[FNo].Strings[13]) > 0 // 20121116
          then
            Ret[RetNo].T4APCppMonths :=
              MyStrToInt(Ret[RetNo].Frm[FNo].Strings[8])
          else
            Ret[RetNo].T4APCppMonths := 0;
        end;
        If Numeric(Ret[RetNo].Frm[FNo].Strings[3]) then
        begin
          If VL(Ret[RetNo].Frm[FNo].Strings[13]) > 0 then
            Ret[RetNo].T4APDisabMonths :=
              MyStrToInt(Ret[RetNo].Frm[FNo].Strings[3])
          else
            Ret[RetNo].T4APDisabMonths := 0;
        end;
      end;
    end;
  end;
end;

Procedure T4Process(RetNo: integer; var T4Gross: Real; var T4Don: Real;
  var T4Union: Real; var T4Commissions: Real; var T4PAdj: Real; var T4Rpp: Real;
  var T4FreeLoan: Real; var T4StockOptions: Real; var T4Tax: Real;
  var T4UIEarnings: Real; var T4CppEarnings: Real; var T4UIPremium: Real;
  var T4CPPPremium: Real; var T4QppPremium: Real; var T4UiWeeks: integer;
  Var T4NorthA: Real; Var T4NorthB: Real; Var T4PastRPPW: Real;
  Var T4PastRPPWNot: Real; Var T4Indian: Real);
Var
  i, FNo: integer;

begin
  T4Gross := 0;
  T4Don := 0;
  T4Union := 0;
  T4Commissions := 0;
  T4PAdj := 0;
  T4Rpp := 0;
  T4FreeLoan := 0;
  T4StockOptions := 0;
  T4Tax := 0;
  T4UIEarnings := 0;
  T4CppEarnings := 0;
  T4UIPremium := 0;
  T4CPPPremium := 0;
  T4QppPremium := 0;
  T4NorthA := 0;
  T4NorthB := 0;
  T4UiWeeks := 52; { change only if > 52 }
  T4PastRPPW := 0;
  T4PastRPPWNot := 0;
  T4Indian := 0;

  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'T4' then
    begin
      FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] Or (VL(FetchElmFNo(RetNo, FNo, 2)) > 0)
      // 20200817 to accommodate the SalDiv
      then // 20170324 Igor
      begin
        T4Gross := T4Gross + VL(Ret[RetNo].Frm[FNo].Strings[2]);
        T4Don := T4Don + VL(Ret[RetNo].Frm[FNo].Strings[15]);
        T4Union := T4Union + VL(Ret[RetNo].Frm[FNo].Strings[14]);
        T4Commissions := T4Commissions + VL(Ret[RetNo].Frm[FNo].Strings[13]);
        T4PAdj := T4PAdj + VL(Ret[RetNo].Frm[FNo].Strings[16]);
        T4Rpp := T4Rpp + VL(Ret[RetNo].Frm[FNo].Strings[6]);
        T4PastRPPW := T4PastRPPW + VL(Ret[RetNo].Frm[FNo].Strings[29]);
        T4PastRPPWNot := T4PastRPPWNot + VL(Ret[RetNo].Frm[FNo].Strings[30]);
        T4FreeLoan := T4FreeLoan + VL(Ret[RetNo].Frm[FNo].Strings[27]);
        T4StockOptions := T4StockOptions + VL(Ret[RetNo].Frm[FNo].Strings[28]) +
          VL(Ret[RetNo].Frm[FNo].Strings[12]);
        T4Tax := T4Tax + VL(Ret[RetNo].Frm[FNo].Strings[8]);
        T4NorthA := T4NorthA + VL(Ret[RetNo].Frm[FNo].Strings[25]);
        T4NorthB := T4NorthB + VL(Ret[RetNo].Frm[FNo].Strings[26]);

        If UpperCase(Ret[RetNo].Frm[FNo].Strings[18]) <> 'X' then
        begin
          if Ret[RetNo].Frm[FNo].Strings[9] > '' then
            T4UIEarnings := T4UIEarnings + VL(Ret[RetNo].Frm[FNo].Strings[9])
            { Pnsnbl earnings }
          else
            T4UIEarnings := T4UIEarnings + VL(Ret[RetNo].Frm[FNo].Strings[2]);
          { earnings }
        end;

        If UpperCase(Ret[RetNo].Frm[FNo].Strings[7]) <> 'X' then
        begin
          if Ret[RetNo].Frm[FNo].Strings[10] > '' then
            T4CppEarnings := T4CppEarnings + VL(Ret[RetNo].Frm[FNo].Strings[10])
            { Pnsnbl earnings }
          else
            T4CppEarnings := T4CppEarnings + VL(Ret[RetNo].Frm[FNo].Strings[2]);
          { earnings }
        end;

        // 20121128
        // T4UIPremium:=T4UIPremium+Vl(Ret[RetNo].Frm[FNo].Strings[5])
        xxString := Ret[RetNo].Province;

        If (Ret[RetNo].Province = 'QC') or (IsDeemedResQuebec(RetNo)) then   //jz//NonResCERT-R1//202404 - allow ZZ and if deemed qc resident
          T4UIPremium := T4UIPremium + VL(Ret[RetNo].Frm[FNo].Strings[5])
        else
          T4UIPremium := T4UIPremium + VL(Ret[RetNo].Frm[FNo].Strings[5]) +
            +VL(Ret[RetNo].Frm[FNo].Strings[44]);

        T4CPPPremium := T4CPPPremium + VL(Ret[RetNo].Frm[FNo].Strings[3]);
        T4QppPremium := T4QppPremium + VL(Ret[RetNo].Frm[FNo].Strings[4]);
        T4Indian := T4Indian + VL(Ret[RetNo].Frm[FNo].Strings[11]);
      end;
    end;
  end;
end;

Procedure T5MULTProcess(RetNo: integer; Var T5Interest: Real; Var T5Pens: Real;
  Var T5NonElgblGains: Real; Var T5Dividends: Real;
  Var T5DividendsEligible: Real; Var T5FNonBusInc1: Real;
  Var T5FNonBusInc2: Real; Var T5FNonBusInc3: Real; Var T5FNonBusTax1: Real;
  Var T5FNonBusTax2: Real; Var T5FNonBusTax3: Real; Var T5OthEmpl: Real);
Var
  i, k, FNo, ForeignCountry: integer;
  ExchRate, PercentShare: Real;
begin

  T5Interest := 0;
  T5Pens := 0;
  T5NonElgblGains := 0;
  T5Dividends := 0;
  T5DividendsEligible := 0;
  T5FNonBusInc1 := 0;
  T5FNonBusInc2 := 0;
  T5FNonBusInc3 := 0;
  T5FNonBusTax1 := 0;
  T5FNonBusTax2 := 0;
  T5FNonBusTax3 := 0;
  T5OthEmpl := 0;

  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'T5MULT' then
    begin
      FNo := FRec.FormNo;
      If ((Ret[RetNo].FrmHasData[FNo]) and (Ret[RetNo].Frm[FNo].Count > 0))
      // 20170324 Igor
        or (VL(FetchElmFNo(RetNo, FNo, 39)) > 0)
      // 20200817 to accomodate salDiv  SIN //20200821
        or (VL(FetchElmFNo(RetNo, FNo, 141)) > 0)
      // 20200817  to accomodate salDiv Elig div
        or (VL(FetchElmFNo(RetNo, FNo, 6)) > 0)
      // 20200817  to accomodate salDiv non Elig div
      then
      begin
        For k := 0 to 4 do
        begin
          ExchRate := 1;
          If VL(Ret[RetNo].Frm[FNo].Strings[4 + k * 22]) > 0 then
            ExchRate := VL(Ret[RetNo].Frm[FNo].Strings[4 + k * 22]);
          PercentShare := 0;
          If VL(Ret[RetNo].Frm[FNo].Strings[2 + k * 22]) > 0 then
            PercentShare := VL(Ret[RetNo].Frm[FNo].Strings[2 + k * 22]);

          T5Interest := T5Interest +
            (VL(Ret[RetNo].Frm[FNo].Strings[7 + k * 22]) +
            VL(Ret[RetNo].Frm[FNo].Strings[8 + k * 22]) +
            VL(Ret[RetNo].Frm[FNo].Strings[11 + k * 22]) +
            VL(Ret[RetNo].Frm[FNo].Strings[181 + k * 22])) * PercentShare *
            ExchRate / 100;
          // 20220223
          if Ret[RetNo].Age > 65 then
            T5Pens := T5Pens + VL(Ret[RetNo].Frm[FNo].Strings[13 + k * 22]) *
              PercentShare * ExchRate / 100
          Else
            T5Interest := T5Interest +
              VL(Ret[RetNo].Frm[FNo].Strings[13 + k * 22]) * PercentShare *
              ExchRate / 100;

          T5OthEmpl := T5OthEmpl + VL(Ret[RetNo].Frm[FNo].Strings[180 + k * 22])
            * PercentShare * ExchRate / 100; // 20110607
          T5NonElgblGains := T5NonElgblGains +
            (VL(Ret[RetNo].Frm[FNo].Strings[12 + k * 22])) * PercentShare *
            ExchRate / 100;
          T5Dividends := Ret[RetNo].T5Dividends +
            VL(Ret[RetNo].Frm[FNo].Strings[6 + k * 22]) * PercentShare *
            ExchRate / 100;
          T5DividendsEligible := Ret[RetNo].T5DividendsEligible +
            VL(Ret[RetNo].Frm[FNo].Strings[141 + k]) * PercentShare *
            ExchRate / 100;

          ForeignCountry := 1;
          If (Ret[RetNo].Frm[FNo].Strings[5 + k * 22] > '') and
            (Numeric(Ret[RetNo].Frm[FNo].Strings[5 + k * 22])) then
            ForeignCountry := StrToInt(Ret[RetNo].Frm[FNo].Strings[5 + k * 22]);
          Case ForeignCountry of
            1:
              begin
                T5FNonBusInc1 := T5FNonBusInc1 +
                  VL(Ret[RetNo].Frm[FNo].Strings[9 + k * 22]) * PercentShare *
                  ExchRate / 100;
                T5FNonBusTax1 := T5FNonBusTax1 +
                  VL(Ret[RetNo].Frm[FNo].Strings[10 + k * 22]) * PercentShare *
                  ExchRate / 100;
              end;
            2:
              begin
                T5FNonBusInc2 := T5FNonBusInc2 +
                  VL(Ret[RetNo].Frm[FNo].Strings[9 + k * 22]) * PercentShare *
                  ExchRate / 100;
                T5FNonBusTax2 := T5FNonBusTax2 +
                  VL(Ret[RetNo].Frm[FNo].Strings[10 + k * 22]) * PercentShare *
                  ExchRate / 100;
              end;
            3:
              begin
                T5FNonBusInc3 := T5FNonBusInc3 +
                  VL(Ret[RetNo].Frm[FNo].Strings[9 + k * 22]) * PercentShare *
                  ExchRate / 100;
                T5FNonBusTax3 := T5FNonBusTax3 +
                  VL(Ret[RetNo].Frm[FNo].Strings[10 + k * 22]) * PercentShare *
                  ExchRate / 100;
              end;
          end; { case }
        end; // k
      end; // has data
    end;
  end;

end;

// //20250112
Procedure T3MultProcess(RetNo: integer; Var T3OthInc: Real; Var T3Pens: Real;
  // called procedure
  Var T3itc: Real; Var T3xii: Real; Var T3ElgblQSB1: Real;
  Var T3ElgblQFP1: Real; Var T3ElgblOTH1: Real; Var T3ElgblOTH2: Real;
  Var T3ElgblOTH3: Real; Var T3NonElgblGains1: Real; Var T3Dividends: Real;
  Var T3DividendsEligible: Real; Var T3FNonBusInc1: Real;
  Var T3FNonBusInc2: Real; Var T3FNonBusInc3: Real; Var T3FNonBusTax1: Real;
  Var T3FNonBusTax2: Real; Var T3FNonBusTax3: Real; Var T3FBusInc1: Real;
  Var T3FBusInc2: Real; Var T3FBusInc3: Real; Var T3FBusTax1: Real;
  Var T3FBusTax2: Real; Var T3FBusTax3: Real; Var T3FarmElgbl: Real;
  Var T3OthElgbl: Real; Var T3QFPElgbl: Real; Var T3ElgblQSB2: Real;
  Var T3ElgblQFP2: Real; Var T3ElgblQSB3: Real; Var T3ElgblQFP3: Real;
  Var T3NonElgblGains2: Real; Var T3NonElgblGains3: Real;
  // Var T3Box52: Real;
  //Var T3Box53: Real; Var T3Box54: Real;
  Var T3Box55: Real;
  //Var T3Box56: Real;
  Var T3Box57: Real);
  //Var T3Box58: Real; Var T3Box59: Real); // 20250112

Var
  i, k, FNo, T3Period, ForeignCountry: integer;
  ExchRate, PercentShare: Real;
begin
  T3OthInc := 0;
  T3Pens := 0;
  T3itc := 0;
  T3xii := 0;
  T3ElgblQSB1 := 0;
  T3ElgblQSB2 := 0;
  T3ElgblQSB3 := 0;
  T3ElgblQFP1 := 0;
  T3ElgblQFP2 := 0;
  T3ElgblQFP3 := 0;
  T3NonElgblGains1 := 0;
  T3NonElgblGains2 := 0;
  T3NonElgblGains3 := 0;
  T3ElgblOTH1 := 0;
  T3ElgblOTH2 := 0;
  T3ElgblOTH3 := 0;
  T3Dividends := 0;
  T3DividendsEligible := 0;
  T3FNonBusInc1 := 0;
  T3FNonBusInc2 := 0;
  T3FNonBusInc3 := 0;
  T3FNonBusTax1 := 0;
  T3FNonBusTax2 := 0;
  T3FNonBusTax3 := 0;
  T3FBusInc1 := 0;
  T3FBusInc2 := 0;
  T3FBusInc3 := 0;
  T3FBusTax1 := 0;
  T3FBusTax2 := 0;
  T3FBusTax3 := 0;
  T3FarmElgbl := 0;
  T3OthElgbl := 0;
  T3QFPElgbl := 0;
  //2025-106
  //T3Box52 := 0;
 // T3Box53 := 0;
  //T3Box54 := 0;
  T3Box55 := 0;
  //T3Box56 := 0;
  T3Box57 := 0;
  //T3Box58 := 0;
  //T3Box59 := 0;

  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'T3MULT' then
    begin
      For k := 0 to 4 do
      begin
        FNo := FRec.FormNo;
        If (Ret[RetNo].FrmHasData[FNo]) and // 20170324 Igor
          (Ret[RetNo].Frm[FNo].Count > 0) then
        begin
          ExchRate := 1;
          T3Period := 3;
          If VL(Ret[RetNo].Frm[FNo].Strings[65 + k]) > 0 then
            ExchRate := VL(Ret[RetNo].Frm[FNo].Strings[65 + k]);
          PercentShare := VL(Ret[RetNo].Frm[FNo].Strings[35 + k]);

          T3Pens := T3Pens + VL(Ret[RetNo].Frm[FNo].Strings[119 + k]) *
            PercentShare * ExchRate / 100;
          T3itc := T3itc + VL(Ret[RetNo].Frm[FNo].Strings[173 + k]) *
            PercentShare * ExchRate / 100;;
          T3xii := T3xii + VL(Ret[RetNo].Frm[FNo].Strings[161 + k]) *
            PercentShare * ExchRate / 100;

          T3ElgblQSB3 := T3ElgblQSB3 + VL(Ret[RetNo].Frm[FNo].Strings[203 + k])
            * PercentShare * ExchRate / 100;
          T3ElgblQFP3 := T3ElgblQFP3 + VL(Ret[RetNo].Frm[FNo].Strings[197 + k])
            * PercentShare * ExchRate / 100;
          T3ElgblOTH3 := T3ElgblOTH3 + VL(Ret[RetNo].Frm[FNo].Strings[83 + k]) *
            PercentShare * ExchRate / 100 - T3ElgblQSB3 - T3ElgblQFP3;

          // box 21 minus box 30 - box 37
          T3NonElgblGains3 := T3NonElgblGains3 +
            (VL(Ret[RetNo].Frm[FNo].Strings[77 + k]) -
            VL(Ret[RetNo].Frm[FNo].Strings[203 + k])
            // Vl(Ret[RetNo].Frm[FNo].Strings[83+k])
            - VL(Ret[RetNo].Frm[FNo].Strings[197 + k]) -
            VL(Ret[RetNo].Frm[FNo].Strings[155 + k])) * PercentShare *
            ExchRate / 100;
          T3Dividends := T3Dividends + VL(Ret[RetNo].Frm[FNo].Strings[89 + k]) *
            PercentShare * ExchRate / 100;
          T3DividendsEligible := T3DividendsEligible +
            VL(Ret[RetNo].Frm[FNo].Strings[71 + k]) * PercentShare *
            ExchRate / 100;
          T3FarmElgbl := T3FarmElgbl + VL(Ret[RetNo].Frm[FNo].Strings[209 + k])
            * PercentShare * ExchRate / 100;

          T3QFPElgbl := T3QFPElgbl + VL(Ret[RetNo].Frm[FNo].Strings[215 + k]) *
            PercentShare * ExchRate / 100;
          T3OthElgbl := T3OthElgbl + VL(Ret[RetNo].Frm[FNo].Strings[221 + k]) *
            PercentShare * ExchRate / 100;

          // 20190301
          T3OthInc := T3OthInc +
            MaxR(0, (VL(Ret[RetNo].Frm[FNo].Strings[95 + k]) +
            VL(Ret[RetNo].Frm[FNo].Strings[101 + k]) -
            VL(Ret[RetNo].Frm[FNo].Strings[119 + k])) // 20190301 //box 31
            // -Vl(Ret[RetNo].Frm[FNo].Strings[215+k])  //20190301
            // -Vl(Ret[RetNo].Frm[FNo].Strings[221+k])  //20190301
            * PercentShare * ExchRate / 100);
          (*
            //20190301
            T3OthInc := T3OthInc+
            MaxR(0,(Vl(Ret[RetNo].Frm[FNo].Strings[95+k])
            +Vl(Ret[RetNo].Frm[FNo].Strings[101+k])
            -Vl(Ret[RetNo].Frm[FNo].Strings[119+k]))  //20190301 //box 31
            // -Vl(Ret[RetNo].Frm[FNo].Strings[215+k])  //20190301
            // -Vl(Ret[RetNo].Frm[FNo].Strings[221+k])  //20190301
            * PercentShare *ExchRate/100);
          *)
          ForeignCountry := 1;
          If (Ret[RetNo].Frm[FNo].Strings[53 + k] > '') and
            (Numeric(Ret[RetNo].Frm[FNo].Strings[53 + k])) then
            ForeignCountry := StrToInt(Ret[RetNo].Frm[FNo].Strings[53 + k]);
          Case ForeignCountry of
            1:
              begin
                T3FNonBusInc1 := T3FNonBusInc1 +
                  VL(Ret[RetNo].Frm[FNo].Strings[113 + k]) * PercentShare *
                  ExchRate / 100;
                T3FNonBusTax1 := T3FNonBusTax1 +
                  VL(Ret[RetNo].Frm[FNo].Strings[131 + k]) * PercentShare *
                  ExchRate / 100;
                T3FBusInc1 := T3FBusInc1 +
                  VL(Ret[RetNo].Frm[FNo].Strings[107 + k]) * PercentShare *
                  ExchRate / 100;
                T3FBusTax1 := T3FBusTax1 +
                  VL(Ret[RetNo].Frm[FNo].Strings[125 + k]) * PercentShare *
                  ExchRate / 100;
              end;
            2:
              begin
                T3FNonBusInc2 := T3FNonBusInc2 +
                  VL(Ret[RetNo].Frm[FNo].Strings[113 + k]) * PercentShare *
                  ExchRate / 100;
                T3FNonBusTax2 := T3FNonBusTax2 +
                  VL(Ret[RetNo].Frm[FNo].Strings[131 + k]) * PercentShare *
                  ExchRate / 100;
                T3FBusInc2 := T3FBusInc2 +
                  VL(Ret[RetNo].Frm[FNo].Strings[107 + k]) * PercentShare *
                  ExchRate / 100;
                T3FBusTax2 := T3FBusTax2 +
                  VL(Ret[RetNo].Frm[FNo].Strings[125 + k]) * PercentShare *
                  ExchRate / 100;
              end;
            3:
              begin
                T3FNonBusInc3 := T3FNonBusInc3 +
                  VL(Ret[RetNo].Frm[FNo].Strings[113 + k]) * PercentShare *
                  ExchRate / 100;
                T3FNonBusTax3 := T3FNonBusTax3 +
                  VL(Ret[RetNo].Frm[FNo].Strings[131 + k]) * PercentShare *
                  ExchRate / 100;
                T3FBusInc3 := T3FBusInc3 +
                  VL(Ret[RetNo].Frm[FNo].Strings[107 + k]) * PercentShare *
                  ExchRate / 100;
                T3FBusTax3 := T3FBusTax3 +
                  VL(Ret[RetNo].Frm[FNo].Strings[125 + k]) * PercentShare *
                  ExchRate / 100;
              end;
          end; { case }
        end; // 53+k
      end; // k
      (* 20120330
        If TotMultiple(RetNo,'T3MULT',82)>0 then  //20120229 //cap gains
        begin
        If (Ret[RetNo].T3NonElgblGains3 =0)
        //and (TotMultiple(RetNo,'T3MULT',35)>0)   //20120229
        then Ret[RetNo].T3NonElgblGains3:=1;        //  Ret[RetNo]. //20120330
        end;
      *)
    end;
  end; // i
end;

Function T4AEligible(RetNo: integer; FormName: string): Real;
{ boxes 24,28 for line 115 }
Var
  i, FNo: integer;
  DeathIndicator: Boolean;
  Footnote: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = FormName then
    begin
      FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] then // 20170324 Igor
      begin
        Footnote := StrToInt(Ret[RetNo].Frm[FNo].Strings[12]);
        { DeathIndicator := (Vl(Ret[RetNo].Frm[FNo].Strings[34]) > 0); }
        Result := Result + VL(Ret[RetNo].Frm[FNo].Strings[5]); { box 24 }
        If (Footnote = 06) or (Footnote = 15) Or (Ret[RetNo].Age >= 65) then
          Result := Result + VL(Ret[RetNo].Frm[FNo].Strings[7]); { box 28 }
      end;
    end;
  end;
end;

Function T4ANonEligible(RetNo: integer; FormName: string; Row: integer): Real;
{ Row to be summarized: i.e.  24,28 }
Var
  i, FNo: integer;
  DeathIndicator: string; // [1];
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = FormName then
    begin
      FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] then // 20170324 Igor
      begin
        DeathIndicator := UpperCase(Ret[RetNo].Frm[FNo].Strings[10]);
        If (DeathIndicator <> 'Y') and (Ret[RetNo].Age < 65) then
          Result := Result + VL(Ret[RetNo].Frm[FNo].Strings[Row]);
      end;
    end;
  end;
end;

Function InsertCommas(S: string): String;
Var
  SignPart: string; // [1];
begin
  S := LTrim(S);
  If LeftStr(S, 1) = '-' then
  begin
    SignPart := '-';
    S := RightStr(S, Length(S) - 1);
  end
  else
    SignPart := '';

  Result := SignPart + S;
  Case Length(S) of
    4:
      Result := SignPart + LeftStr(S, 1) + ',' + RightStr(S, 3);
    5:
      Result := SignPart + LeftStr(S, 2) + ',' + RightStr(S, 3);
    6:
      Result := SignPart + LeftStr(S, 3) + ',' + RightStr(S, 3);
    7:
      Result := SignPart + LeftStr(S, 1) + ',' + MidStr(S, 2, 3) + ',' +
        RightStr(S, 3);
    8:
      Result := SignPart + LeftStr(S, 2) + ',' + MidStr(S, 3, 3) + ',' +
        RightStr(S, 3);
    // 9 : Result := SignPart+Leftstr(s,3)+','+MidStr(S,4,3)+','+RightStr(S,3);
    { 10: Result := Leftstr(s,3)+','+MidStr(S,3,3)+','+RightStr(S,3); }
  end;
end;

Function ExtractIntegerPart(S: string): string;
var
  i: integer;
  IntegerPart, DecimalPart: string; // [20];
Begin
  i := 1;
  while (i <= Length(S)) and not(S[i] = '.') do
    inc(i);
  Result := LTrim(LeftStr(S, i - 1)); { copy(s[i],1,i-1); }
end;

Function ExtractDecimalPart(S: string): string;
var
  i: integer;
Begin
  i := Length(S);
  while (i > 0) and not CharInSet(S[i], ['.']) do
    Dec(i);
  If (i > 0) and (S[i] = '.') then
    Result := Copy(S, i + 1, 255)
  else
    Result := '';
end;

Function InsertPenniesDot(S: string): String;
begin
  S := LTrim(RTrim(S));
  Result := S;
  If MidStr(S, Length(S) - 2, 1) = ' ' then
    Result := Concat(LeftStr(S, Length(S) - 3), '.', RightStr(S, 2));
end;

Function RemovePenniesDot(S: string): String;
begin
  Result := S;
  If MidStr(S, Length(S) - 2, 1) = '.' then
    Result := Concat(LeftStr(S, Length(S) - 3), ' ', RightStr(S, 2));
end;

Function FormatAmount(S: string; VerticalSeparator: Boolean): string;
var
  SignPart: string; // [1];
  IntegerPart: string; // [15];
  DecimalPart: string; // [2];
  { SignPart, IntegerPart, DecimalPart : string; //[20]; }
begin
  S := LTrim(S);
  IntegerPart := ExtractIntegerPart(S);
  DecimalPart := ExtractDecimalPart(S);
  If Length(DecimalPart) = 0 then
    DecimalPart := '00'
  else if Length(DecimalPart) = 1 then
    DecimalPart := DecimalPart + '0'
  else
    DecimalPart := Copy(DecimalPart, 1, 2);
  If VerticalSeparator = true then
    Result := InsertCommas(IntegerPart) + '  ' + DecimalPart
  else
    Result := InsertCommas(IntegerPart) + '.' + DecimalPart;
end;

Function FormatPrintAmountForT1273(S: string; VerticalSeparator: Boolean;
  FName: String; elm: integer): string;
var
  i: integer;
  SignPart: string; // [1];
  IntegerPart: string; // [15];
  DecimalPart: string; // [2];
begin
  S := LTrim(S);
  IntegerPart := ExtractIntegerPart(S);
  DecimalPart := ExtractDecimalPart(S);
  If Length(DecimalPart) = 0 then
    DecimalPart := '00'
  else if Length(DecimalPart) = 1 then
    DecimalPart := DecimalPart + '0'
  else
    DecimalPart := Copy(DecimalPart, 1, 2);
  If VerticalSeparator = true then
    Result := InsertCommas(IntegerPart) + '  ' + DecimalPart
  else
    Result := InsertCommas(IntegerPart) + '.' + DecimalPart;

  // result:=FormatAmount(s,VerticalSeparator); //standard formatting
  If ((LeftStr(FName, 5) = 'T1273') or (LeftStr(FName, 7) = 'T1273A1')) then
  begin
    // section 7 end of year
    i := 810;
    Repeat
      If elm = i then
        Result := IntegerPart + '.' + DecimalPart;
      inc(i, 4);
    until i > 858;
    // section 8 end of year;
    i := 865;
    Repeat
      If elm = i then
        Result := IntegerPart + '.' + DecimalPart;
      inc(i, 7);
    until i > 949;
  end;

  If ((LeftStr(FName, 7) = 'T1273') or (LeftStr(FName, 7) = 'T1273A2')) then
  begin
    // section 10
    i := 1007;
    Repeat
      If elm = i then
        Result := IntegerPart;
      inc(i, 3);
    until i > 1028;

    // section 11
    i := 1031;
    Repeat
      If elm = i then
        Result := IntegerPart;
      inc(i, 3);
    until i > 1052;
    // section 12
    i := 1055;
    Repeat
      If elm = i then
        Result := IntegerPart;
      inc(i, 3);
    until i > 1076;
  end;
end;

Procedure SwapStrings(S1: string; S2: string);
var
  S: string;
begin
  S := S1;
  S1 := S2;
  S2 := S;
end;

Function VL(S: string): Real;
Var
  Code: integer;
begin
  // DecimalSeparator:='.';
  If S = '' then
  begin
    Result := 0;
    Exit;
  end;
  S := StringReplace(S, ',', '', [rfReplaceAll, rfIgnoreCase]);
  Val(S, Result, Code);
end;

Function MyStrToInt(S: string): integer;
begin
  Result := Trunc(VL(S));
end;

// 20160118
Function InvalidNAICS(NaicsCode: String): Boolean; // 20160119 Igor
begin
  Result := false;
  If (Length(NaicsCode) <> 6) and (Not Numeric(NaicsCode)) then
    Result := true;
end;

Function FileNameValid(FlName: string): Boolean;
Var
  i: integer;
begin
  Result := true;
  If (Length(FlName) > 60) or (Length(FlName) = 0) or // 20200914 Igor
    (Length(ExtractFilePath(FlName)) > 0) or
    (Length(ExtractFileExt(FlName)) > 6) { includes . }  // 20201015 Igor
  then
    Result := false;
end;

Function CopyReturn(DataDir: String; FileName: String;
  DestinationDir: string): Boolean;
begin
  UndefMsg('CopyReturn');
  Result := false;
  ShowMessage('Copying: ' + FileName);
end;

// 20170112 Igor >>> (move to TUserProfile)
(*
  Function GetUserProfile(UserName:string): boolean;
  var
  ADConnection: TADConnection;
  Table1: TADTable;
  begin
  Result := True;

  //20150915 Igor
  ADConnection:= TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  //20160226 Igor >>>>
  if not SetTableName(ADConnection, Table1, AppDir + '\' + UserDBLite, UserTableLite, 'Name') then
  Begin
  if assigned(ADConnection) then
  freeAndNil(ADConnection);
  if assigned(Table1) then
  freeAndNil(Table1);
  result := False;
  exit;
  end;
  //20160226 Igor <<<<<
  if Table1.FindKey([UserName]) = false then
  begin Result := false; exit; end;
  With Table1 do
  begin
  User.M_Office  := FieldByName('M_Office').AsString;
  User.Branch    := FieldByName('Branch').AsString;
  User.Prep_Intls:= FieldByName('Prep_Intls').AsString;
  User.Login_Id  := FieldByName('Login_Id').AsString;
  User.Pswd      := FieldByName('Pswd').AsString;
  User.Auth_Level:= FieldByName('Auth_Level').AsString;
  User.Inv_No    := FieldByName('Inv_No').AsInteger;
  User.Code      := FieldByName('CODE').AsString;
  User.Prep_Name := FieldByName('Prep_Name').AsString;
  User.Tax_dir   := FieldByName('Tax_dir').AsString;
  User.EFile_Dir := FieldByName('EFile_dir').AsString;
  User.Br_Dir    := FieldByName('BR_dir').AsString;
  User.CrProfile := Boolean(FieldByName('Cr_Profile').AsInteger);
  User.CrReturn  := Boolean(FieldByName('Cr_Return').AsInteger);
  User.PrReturn  := Boolean(FieldByName('Pr_Return').AsInteger);
  User.PrInvoice := Boolean(FieldByName('Pr_Invoice').AsInteger);
  User.PrReport  := Boolean(FieldByName('Pr_Report').AsInteger);
  User.MkAppoint := Boolean(FieldByName('Mk_Appoint').AsInteger);
  User.CrRtu     := Boolean(FieldByName('Cr_Rtu').AsInteger);
  User.EFile     := Boolean(FieldByName('Efile').AsInteger);
  User.Upload    := Boolean(FieldByName('Upload').AsInteger);
  User.MkPay     := Boolean(FieldByName('Mk_Pay').AsInteger);

  Table1.Free;
  ADConnection.Free;
  end;
  end;
*)
// 20170112 Igor <<<

procedure CreateClientsTable(AConn: TADConnection); // 20200914 Igor
begin
  AConn.ExecSQL('CREATE TABLE Clients (' + #13#10 + 'LAST_NAME  VARCHAR (30),' +
    #13#10 + 'FIRST_NAME VARCHAR (20),' + #13#10 + 'FILE_NAME  VARCHAR (60),' +
    #13#10 + 'AREA       VARCHAR (3),' + #13#10 + 'PHONE      VARCHAR (8),' +
    #13#10 + 'FAX        VARCHAR (8),' + #13#10 + 'MARSTATUS  INTEGER,' + #13#10
    + 'EF_STATUS  VARCHAR (2),' + #13#10 + 'PRP_STATUS VARCHAR (2),' + #13#10 +
    'CREATED_BY VARCHAR (10),' + #13#10 + 'CREATED_DT VARCHAR (10),' + #13#10 +
    'CREATED_TM VARCHAR (10),' + #13#10 + 'UPDATED_BY VARCHAR (10),' + #13#10 +
    'UPDATED_DT VARCHAR (10),' + #13#10 + 'UPDATED_TM VARCHAR (10),' + #13#10 +
    'RTUSENT_BY VARCHAR (10),' + #13#10 + 'RTUSENT_DT VARCHAR (10),' + #13#10 +
    'RTUSENT_TM VARCHAR (10),' + #13#10 + 'ACKRCVD_BY VARCHAR (10),' + #13#10 +
    'ACKRCVD_DT VARCHAR (10),' + #13#10 + 'ACKRCVD_TM VARCHAR (10),' + #13#10 +
    'PRINTED_BY VARCHAR (10),' + #13#10 + 'PRINTED_DT VARCHAR (10),' + #13#10 +
    'PRINTED_TM VARCHAR (10),' + #13#10 + 'DCN_NO     VARCHAR (8),' + #13#10 +
    'AUTOFILLED VARCHAR (1),' + #13#10 + 'T1013OL    VARCHAR (1),' + #13#10 +
    'SIN        VARCHAR (9),' + #13#10 + 'BIRTHDATE  VARCHAR (10),' + #13#10 +
    'STREET     VARCHAR (30),' + #13#10 + 'APARTMENT  VARCHAR (8),' + #13#10 +
    'CITY       VARCHAR (15),' + #13#10 + 'PROVINCE   VARCHAR (2),' + #13#10 +
    'POSTAL     VARCHAR (7),' + #13#10 + 'COUNTRY    VARCHAR (10),' + #13#10 +
    'EF_ELGBL   VARCHAR (1),' + #13#10 + 'RTUFILE    VARCHAR (12),' + #13#10 +
    'ACKFILE    VARCHAR (12),' + #13#10 + 'COMPL_BY   VARCHAR (10),' + #13#10 +
    'COMPL_DT   VARCHAR (10),' + #13#10 + 'COMPL_TM   VARCHAR (10),' + #13#10 +
    'DISCOUNTED VARCHAR (1),' + #13#10 + 'DUE_DT     VARCHAR (10),' + #13#10 +
    'NOTES      VARCHAR (80),' + #13#10 + 'PAY_AMOUNT REAL,' + #13#10 +
    'PAY_INVNO  VARCHAR (18),' + #13#10 + 'PAY_TYPE   VARCHAR (6),' + #13#10 +
    'INV_AMOUNT REAL,' + #13#10 + 'PAY_DT     VARCHAR (10),' + #13#10 +
    'FAXAREA    VARCHAR (3),' + #13#10 + 'FAMILYHEAD VARCHAR (1),' + #13#10 +
    'CLIENT_ID  VARCHAR (15),' + #13#10 + 'TITLE      VARCHAR (6),' + #13#10 +
    'EMAIL      VARCHAR (75),' + #13#10 + 'EMAIL2     VARCHAR (75),' + #13#10 +
    'TAXPROV    VARCHAR (2),' + #13#10 + 'GENDER     VARCHAR (1),' + #13#10 +
    'CRABAL     REAL,' + #13#10 + //20251219 Igor
    'CATEGORY   VARCHAR (10)' + #13#10 + ');');
  AConn.ExecSQL('CREATE INDEX CATEGORY ON Clients (CATEGORY);');
  AConn.ExecSQL('CREATE INDEX DCN_NO ON Clients (DCN_NO);');
  AConn.ExecSQL('CREATE INDEX DUE_DT ON Clients (DUE_DT);');
  AConn.ExecSQL('CREATE INDEX EF_STATUS ON Clients (EF_STATUS);');
  AConn.ExecSQL('CREATE INDEX FAMILYHEAD ON Clients (FAMILYHEAD);');
  AConn.ExecSQL('CREATE INDEX LAST_NAME ON Clients (LAST_NAME);');
  AConn.ExecSQL('CREATE INDEX PRP_STATUS ON Clients (PRP_STATUS);');
  AConn.ExecSQL('CREATE INDEX UPDATED_BY ON Clients (UPDATED_BY);');
  AConn.ExecSQL('CREATE INDEX UPDATED_DT ON Clients (UPDATED_DT);');
  AConn.ExecSQL('CREATE UNIQUE INDEX FILE_NAME ON Clients (FILE_NAME);');
end;

Function InitDataBase(Const DataDir: string; Out Msg: String): Boolean;
// 20171031 Igor
var
  Conn: TADConnection;
begin
  if not SysUtils.ForceDirectories(DataDir) then
  begin
    Msg := Format('Could not create data directory "%s".' + #13 +
      'Eror message: %s', [DataDir, SysErrorMessage(GetLastError)]);

    Exit(false);
  end;
  if not TFile.Exists(TPath.Combine(DataDir, AppT1_2026.ClientsDBLite)) then
  begin
    Conn := TADConnection.Create(Nil);
    try
      Conn.LoginPrompt := false;
      Conn.DriverName := 'SQLite';
      Conn.Params.Values['Database'] :=
        TPath.Combine(DataDir, AppT1_2026.ClientsDBLite);
      Conn.Params.Values['Password'] := Pswd(GC_SQLLitePasswordVersion, false);
      // 20200108 Igor             //AppT1_2026.SQLLitePassword.CurrentPassword;

      try
        Conn.Connected := true;
        CreateClientsTable(Conn); // 20200818 Igor
        Result := true;
      except
        ON E: Exception DO
        begin
          Result := false;
          Errors.Log(E.Message);
        end;
      end;
    finally
      Conn.Free;
    end;
    if not Result AND FileExists(TPath.Combine(DataDir,
      AppT1_2026.ClientsDBLite)) then
      try
        TFile.Delete(TPath.Combine(DataDir, AppT1_2026.ClientsDBLite));
      except
      end;
  end
  else
    Result := true;
end;

procedure UpdateDbStructure; // 20200914 Igor
var
  Conn: TADConnection;
  Q: TADQuery;
begin
  if TFile.Exists(TPath.Combine(OptRec.Dir_Cur, AppT1_2026.ClientsDBLite)) then
  begin
    Conn := TADConnection.Create(Nil);
    Q := TADQuery.Create(Nil);
    try
      Conn.LoginPrompt := false;
      Conn.DriverName := 'SQLite';
      Conn.Params.Values['Database'] := TPath.Combine(OptRec.Dir_Cur,
        AppT1_2026.ClientsDBLite);
      Conn.Params.Values['Password'] := Pswd(GC_SQLLitePasswordVersion, false);
      try
        try
          Conn.Connected := true;
        except
          Conn.Params.Values['Password'] := '';
          Conn.Connected := true;
        end;
        Q.Connection := Conn;
        Q.SQL.Text := 'SELECT * FROM Clients WHERE 1 = 0';
        Q.Open;
        if Assigned(Q.FindField('FILE_NAME')) then
          if Q.FieldByName('FILE_NAME').DataSize < 60 then
          begin
            Conn.ExecSQL('ALTER TABLE Clients RENAME TO Clients_Bak');
            Conn.ExecSQL('DROP INDEX IF EXISTS CATEGORY');
            Conn.ExecSQL('DROP INDEX IF EXISTS DCN_NO');
            Conn.ExecSQL('DROP INDEX IF EXISTS DUE_DT');
            Conn.ExecSQL('DROP INDEX IF EXISTS EF_STATUS');
            Conn.ExecSQL('DROP INDEX IF EXISTS FAMILYHEAD');
            Conn.ExecSQL('DROP INDEX IF EXISTS LAST_NAME');
            Conn.ExecSQL('DROP INDEX IF EXISTS PRP_STATUS');
            Conn.ExecSQL('DROP INDEX IF EXISTS UPDATED_BY');
            Conn.ExecSQL('DROP INDEX IF EXISTS UPDATED_DT');
            Conn.ExecSQL('DROP INDEX IF EXISTS FILE_NAME');
            CreateClientsTable(Conn);
            Conn.ExecSQL('INSERT INTO Clients SELECT * FROM Clients_Bak');
            Conn.ExecSQL('DROP TABLE Clients_Bak');
          end;
        if not Assigned(Q.FindField('CRABAL')) then //20251219 Igor
          Conn.ExecSQL('ALTER TABLE Clients ADD CRABAL REAL'); //20251219 Igor
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

Procedure ShowOpenReturnFailure(FailCode: integer; DataDir: String;
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
  // 20170410 Igor >>>
  AppT1_2026.LoadDataDict;
  // if DataDictList = nil then
  // DataDictList := TDataDictList.Create;
  // DataDictList.Load(AppDir);
  // 20170410 Igor <<<
end;

function InDataDict(KeyW: String): Boolean; // 20170410 Igor
Var
  i: integer;
begin
  KeyW := UpperCase(KeyW);
  // assumed present
  If (LeftStr(KeyW, 5) = 'LINE_') Or (LeftStr(KeyW, 5) = 'FORM_') Or
    (LeftStr(KeyW, 4) = 'FNUM') Or (LeftStr(KeyW, 4) = 'FIMG') then
    Exit(true);

  with AppT1_2026.LoadDataDict do
    for i := 0 to (Count - 1) do
      If KeyW = UpperCase(MidStr(Items[i].KeyWord, 1, 100)) then
        Exit(true);
  Result := false;
end;

function GetDataDictFormName(KeyW: String): String; // 20170410 Igor
Var
  i: integer;
begin
  with AppT1_2026.LoadDataDict do
    for i := 0 to (Count - 1) do
      If KeyW = MidStr(Items[i].KeyWord, 1, 255) then
        Exit(Items[i].FormName);
  Result := '';
End;

function GetDataDictElmNo(KeyW: String): integer; // 20170410 Igor
Var
  i: integer;
begin
  with AppT1_2026.LoadDataDict do
    for i := 0 to (Count - 1) do
      If KeyW = MidStr(Items[i].KeyWord, 1, 255) then
        Exit(Items[i].Field_No);
  Result := 0;
End;

Function CalcAgeTo(BirthDate: string; ToDate: string): integer;
// birthdate in form YYYY-MM-DD
Var
  k: integer;
Begin
  Result := 0;
  If Length(BirthDate) = 0 then
  begin
    Result := 0;
    Exit;
  end;
  k := StrToInt(LeftStr(ToDate, 4)) - StrToInt(LeftStr(BirthDate, 4));
  Result := k;
end;

Function CalcAge(BirthDate: string): integer;
{ birthdate in form yyyy-mm-dd }
Begin
  If Length(BirthDate) = 0 then
  begin
    Result := 0;
    Exit;
  end;
  Result := MyStrToInt(AppYear) - MyStrToInt(LeftStr(BirthDate, 4));
end;

Function CalcOnAgeEx(Age: integer; Ni: Real): Real;
var
  x, Y, z: Real;
  RetNo: integer;
begin
  { exclude mortg foreclosures }
  RetNo := GetCurrentRetNo;
  x := VL(FetchElm(RetNo, 'S3', 122)) * 50 / 100;

  If x > 0 then
    Ni := MaxR(0, Ni - x);

  If (Age < 65) or (Ni > Constant[RY].AgeNIThreshhold) then
  begin
    Result := 0;
    Exit;
  end;
  x := MaxR(0, Ni - Constant[RY].AgeBaseAmount);
  Y := x * 0.15;
  Result := MaxR(0, Constant[RY].MaxAgeAmount - Y);
end;

Function InvalidAmountInLetter(S: string): Boolean;
begin
  Result := false;
  if ((S < '0') or (S > '9')) and (S <> '.') and (S <> ' ') and (S <> '-') and
    (S <> ',') and (S <> '(') and (S <> ')') and (S <> '$') then
    Result := true;
end;

Function SetReplaceStringToZero(RetNo: integer;
  ReplaceString, KeyW, FrmNm: String; ElmNo: integer): String;
Var
  FirstInstFNo: integer;
begin
  Result := ReplaceString;
  If (LeftStr(KeyW, 5) = 'Line_') then
  begin
    If VL(ReplaceString) = 0 then
      Result := '0';
    Exit;
  end;
  if FList.IsDollarField(FrmNm, ElmNo) then
  begin
    If VL(ReplaceString) = 0 then
      Result := '0';
  end;
end;

Procedure ReplaceText(LetterBody: TMemo; Cursor_Position: integer;
  KeyWLength: Byte; ReplaceText: string);
var
  i, j, k, PosReturn, SkipChars: integer;
begin
  With LetterBody do
  begin
    SelStart := Cursor_Position - 1;
    SelLength := KeyWLength + 1;
    SelText := ReplaceText;
  end;
end;

Procedure RemoveEmptyLines(Var TempList: TStringList);
Var
  i: integer;
begin
  i := 0;
  While i < TempList.Count do
  begin
    If LTrim(RTrim(TempList[i])) = '' then
      TempList.Delete(i)
    else
      inc(i);
  end;
end;

Procedure RemoveLastEmptyLines(Var TempList: TStringList);
Var
  i: integer;
begin
  i := TempList.Count - 1; { start from bottom }
  While i > 0 do
  begin
    If LTrim(RTrim(TempList[i])) > '' then
      Exit
    else
    begin
      If LTrim(RTrim(TempList[i])) = '' then
      begin
        TempList.Delete(i);
        Dec(i);
      end
      else
        Dec(i);
    end;
  end;
end;

Procedure LoadLetter(Var TempList: TStringList; LetterName: String);
Var
  i: integer;
begin
  If FileExists(AppDir + '\' + LetterName) then
    TempList.LoadFromFile(AppDir + '\' + LetterName)
  else
    For i := 1 to LetterMxParagraphLines do
      TempList.Add('');
end;

Procedure ReplaceKeyWord(Var Txt: String; Cursor_Position: integer;
  KeyWLength: integer; ReplaceString: String);
begin
  Txt := LeftStr(Txt, Cursor_Position - 1) + ReplaceString +
    MidStr(Txt, Cursor_Position + KeyWLength + 2, 255);
end;

Function ClcR(FieldId: integer; PgmValue: Real; FormOvrSw: Boolean;
  RetNo: integer; FormNo: integer): Real;
Var
  i: integer;
begin
  If FormOvrSw = false then
    Result := PgmValue
  else
    Result := VL(GetOvrValue(RetNo, FormNo, FieldId));
end;

(* AFRec is the file type of Scr.d, read in InitFormsTable.
  Since InitFormsTable copies the records, a different declaration
  can be used in memory (TFList).
*)
Type { all forms offerd in the Tax program }
  // PFList      = ^AFRec;
  AFRec = Record
    FormNo: word;
    FormName: string[12];
    FormInst: string[3]; { #nn }
    FormMxInst: string[3];
    FormDescr: string[65]; { 65 }
    FormMxPg: word;
    FormAbrev: string[22];
    FormRlNm: string[10];
    FormShow: Boolean;
    FormType: string[2];
    FormFields: word;
    IsSlip: Boolean;
    Preload: Boolean;
    DataIndic: string[60];
    WhiteBoxes: Boolean;
    ShowFlag: Boolean;
    ShowHdr: Boolean;
    PrnSeq: string[5];
    // 20110229   STILL NEEDED but WHY???
    Fee: string[7];
    HowCharged: string[20];
    AddnlForm: string[7];
    Each_Item: string[7];

    CursorPos: word;
    LandScape: Boolean;
    FormHeight: word;
    AddBlankPg: string[1];
    AddInT1C: string[1];
  end;

Type { all forms offerd in the Tax program }
  // PFLastYearList      = ^AFLastYearRec;
  AFLastYearRec = Record
    FormNo: word;
    FormName: string[12];
    FormInst: string[3]; { #nn }
    FormMxInst: string[3];
    FormDescr: string[65]; { 65 }
    FormMxPg: word;
    FormAbrev: string[22];
    FormRlNm: string[10];
    FormShow: Boolean;
    FormType: string[2];
    FormFields: word;
    IsSlip: Boolean;
    Preload: Boolean;
    DataIndic: string[60];
    WhiteBoxes: Boolean;
    ShowFlag: Boolean;
    ShowHdr: Boolean;
    PrnSeq: string[5];
    // 20110229   STILL NEEDED but WHY???
    Fee: string[7];
    HowCharged: string[20];
    AddnlForm: string[7];
    Each_Item: string[7];

    CursorPos: word;
    LandScape: Boolean;
    FormHeight: word;
    AddBlankPg: string[1];
  end;

  // 20101230
procedure SaveFormsTableToFile();
var
  i: integer;
  FormRecord: AFRec;
  fRecFile: File of AFRec;
  ADConnection: TADConnection;
  Table1: TADTable;
begin
  AssignFile(fRecFile, AppDir + '\' + 'Scr.D');
  ReWrite(fRecFile);

  // fillchar(FormRecord,sizeof(FormRecord),0);

  // 20150915 Igor
  ADConnection := TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  // 20160226 Igor >>>>
  if not SetTableName(ADConnection, Table1, AppDir + '\' + FormsDBLite,
    FormsTableLite, 'FormNo') then
  Begin
    if Assigned(ADConnection) then
      FreeAndNil(ADConnection);
    if Assigned(Table1) then
      FreeAndNil(Table1);
    Exit;
  End;
  // 20160226 Igor <<<<<
  { load in memory }
  // Table1.Edit;
  // Table1.Post;
  Table1.First;
  while not Table1.EOF do
  begin
    FormRecord.FormNo := Table1.FieldByName('FormNo').AsInteger;
    FormRecord.FormName :=
      UpperCase(LTrim(RTrim(UpperCase(Table1.FieldByName('FormName')
      .AsString))));
    FormRecord.FormInst :=
      LTrim(RTrim(Table1.FieldByName('FormInst').AsString));
    FormRecord.FormMxInst := Table1.FieldByName('FormMxInst').AsString;
    FormRecord.FormDescr := Table1.FieldByName('FormDescr').AsString;
    FormRecord.FormMxPg := Table1.FieldByName('FormMxPg').AsInteger;
    FormRecord.FormRlNm := Table1.FieldByName('FormRlNm').AsString;
    FormRecord.FormAbrev := Table1.FieldByName('FormAbrev').AsString;
    FormRecord.FormType := Table1.FieldByName('FormType').AsString;
    FormRecord.FormShow := Boolean(Table1.FieldByName('FormShow').AsInteger);

    FormRecord.FormFields := Table1.FieldByName('FormFields').AsInteger;
    If FormRecord.FormFields = 0 then
      FormRecord.FormFields := FieldsLimit;

    FormRecord.IsSlip := Boolean(Table1.FieldByName('IsSlip').AsInteger);
    FormRecord.Preload := Boolean(Table1.FieldByName('Preload').AsInteger);
    FormRecord.DataIndic := Table1.FieldByName('DataIndic').AsString;
    FormRecord.WhiteBoxes := Boolean(Table1.FieldByName('WhiteBoxes')
      .AsInteger);
    FormRecord.ShowFlag := Boolean(Table1.FieldByName('ShowFlag').AsInteger);
    FormRecord.ShowHdr := Boolean(Table1.FieldByName('ShowHdr').AsInteger);
    FormRecord.PrnSeq := Table1.FieldByName('PrnSeq').AsString;
    { 20110129
      FormRecord.Fee         := Table1.FieldByName('Fee').AsString;
      FormRecord.HowCharged  := Table1.FieldByName('HowCharged').AsString;
      FormRecord.AddnlForm   := Table1.FieldByName('AddnlForm').AsString;
      FormRecord.Each_Item   := Table1.FieldByName('Each_Item').AsString;
    }
    FormRecord.CursorPos := Table1.FieldByName('CursorPos').AsInteger;
    FormRecord.LandScape := Boolean(Table1.FieldByName('LandScape').AsInteger);
    FormRecord.FormHeight := Table1.FieldByName('FormHeight').AsInteger;
    FormRecord.AddBlankPg := Table1.FieldByName('AddBlankPg').AsString;
    FormRecord.AddInT1C := Table1.FieldByName('AddInT1C').AsString;
    Write(fRecFile, FormRecord); // Write the data to file

    Table1.Next;
  end;
  Table1.Close;
  CloseFile(fRecFile);
  // 20150915 Igor
  Table1.Free;
  ADConnection.Free;
end;

procedure InitFormsTable;
begin
  if FList.InitFormsTable(AppDir, FormsDBLite, FormsTableLite) then
    // 20150918 Igor
    Exit; // okay

  AppT1_2026.PrepareDistribution;

  if FList.InitFormsTable(AppDir, FormsDBLite, FormsTableLite) then
    // 20150918 Igor
    Exit; // okay

  UserMsg('Please fix errors in T1 forms');
  Application.Terminate;
end;

// rem 20150915 Igor
// const
// DBFormsLast = T1Scr.db f;

procedure InitLastYearFormsTable;
var
  LastYearDir: string;
  F: TextFile;
begin
  LastYearDir := OptRec.Dir_PgmLastYr;
  If not SysUtils.DirectoryExists(LastYearDir) then
    Exit;
  // If not FileExists(LastYearDir+'\'+FormsScrDBLite) then Exit;  //20110228
  // 20160314 Igor >>>>>
  If FileExists(LastYearDir + '\' + FormsScrDBLite) then
  Begin
    FullPathT1Scr_LastYear := LastYearDir + '\' + FormsScrDBLite;
    // use original db file
  End
  else
    // 20160321 Igor
    if FileExists(LastYearDir + '\' + ChangeFileExt(FormsScrDBLite, '.DBF'))
    then
    begin
      FullPathT1Scr_LastYear := LastYearDir + '\' +
        ChangeFileExt(FormsScrDBLite, '.DBF'); // use converted db
    end
    else
      Exit; // bad directory
  // 20160314 Igor <<<<<
  If not FileExists(LastYearDir + '\' + FieldsListD) then
  begin // create empty file
    assign(F, LastYearDir + '\' + FieldsListD);
    ReWrite(F);
    CloseFile(F);
    // SomeList.Clear;
    // SomeList.SaveToFile(LastYearDir+'\'+FieldsListD);
  end;

  FLastYearList := TFListT1.Create(AppT1_2026, FormsLimit, FieldsLimit,
    FullPathT1Scr_LastYear, FormsScrTableLite, LastYearDir); // 20160314 Igor
  // 20160710 Igor
  if not FLastYearList.InitFormsTable(LastYearDir, FullPathT1Scr_LastYear,
    FormsScrTableLite) then // 20150918 Igor //20160314 Igor
  begin
    FreeAndNil(FLastYearList);
    Exit;
  end;
end;

// 20110129
function InitFeesTable: Boolean;
var
  i: integer;
  F1: TextFile;
  // ScrRec : string;   //20110129
  ADConnection: TADConnection;
  Table1: TADTable;
begin
  { Try }
  if FeesList = nil then
    FeesList := TFeesList.Create(true)
  else
    FeesList.Clear;

  // 20150915 Igor
  ADConnection := TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  // 20160226 Igor >>>>
  if not SetTableName(ADConnection, Table1, AppDir + '\' + FormsFeesDBLite,
    FormsFeesTableLite, 'FormNo') then
  Begin
    if Assigned(ADConnection) then
      FreeAndNil(ADConnection);
    if Assigned(Table1) then
      FreeAndNil(Table1);
    Result := false;
    Exit;
  End;
  // 20160226 Igor <<<<<<
  { load in memory }
  Table1.First;
  while not Table1.EOF do
  begin
    // New(FeesRec);
    FeesRec := AFeesRec.Create;
    FeesRec.FormNo := Table1.FieldByName('FormNo').AsInteger;
    FeesRec.FormName :=
      UpperCase(LTrim(RTrim(UpperCase(Table1.FieldByName('FormName')
      .AsString))));
    FeesRec.FormAbrev := Table1.FieldByName('FormAbrev').AsString;
    FeesRec.Fee := Table1.FieldByName('Fee').AsString;
    FeesRec.HowCharged := Table1.FieldByName('HowCharged').AsString;
    FeesRec.AddnlForm := Table1.FieldByName('AddnlForm').AsString;
    FeesRec.Each_Item := Table1.FieldByName('Each_Item').AsString;
    FeesList.Add(FeesRec);
    Table1.Next;
  end;
  Table1.Close;
  Table1.Free; // 20150915 Igor
  ADConnection.Free; // 20150915 Igor
  Result := true;
end;

Procedure ExpandTabs(Var AList: TStringList);
var
  i, j: integer;
  TabChar, S: string;
begin
  Exit; { ? }

  TabChar := Chr(9);
  for i := 0 to AList.Count - 1 do
  begin
    S := AList[i];
    { Convert tabs to 6 spaces }
    while Pos(TabChar, S) > 0 do
    begin
      j := Pos(TabChar, S);
      S[j] := ' ';
      S := LeftStr(S, j) + '     ' + MidStr(S, j + 6, 255);
    end;
  end;
end;

Procedure SumSlips(RetNo: integer; FName: string);
begin
  with Ret[RetNo] do
  begin
    If (FName = 'ALL') or (LeftStr(FName, 2) = 'T4') then
      T4Process(RetNo, T4Gross, T4Don, T4Union, T4Commissions, T4PAdj, T4Rpp,
        T4FreeLoan, T4StockOptions, T4Tax, T4UIEarnings, T4CppEarnings,
        T4UIPremium, T4CPPPremium, T4QppPremium, T4UiWeeks, T4NorthA, T4NorthB,
        T4PastRPPW, T4PastRPPWNot, T4Indian);

    If (FName = 'ALL') or (LeftStr(FName, 4) = 'T4AP') then
      T4APProcess(RetNo, T4APOAS, T4APCppBnf, T4APDisabBnf, T4APTax,
        T4APCppMonths, T4APDisabMonths);

    If (FName = 'ALL') or (LeftStr(FName, 3) = 'T4A') then
      T4AProcess(RetNo, T4AOthInc, T4APens, T4ARPP, T4APAdj, T4AOthEmpl, T4ADon,
        T4ATax, T4ANorthA, T4ANorthB, T4APastRppW, T4APastRppWNot, T4ARESP,
        T4ARespEduc, T4AResp22, T4AAnnuity, T4ARDSP, T4ACovidIncome);

    // calling routine
    If (FName = 'ALL') or (LeftStr(FName, 6) = 'T3MULT') then
      T3MultProcess(RetNo, T3OthInc, T3Pens, T3itc, T3xii, T3ElgblQSB1,
        T3ElgblQFP1, T3ElgblOTH1, T3ElgblOTH2, T3ElgblOTH3, T3NonElgblGains1,
        T3Dividends, T3DividendsEligible, T3FNonBusInc1, T3FNonBusInc2,
        T3FNonBusInc3, T3FNonBusTax1, T3FNonBusTax2, T3FNonBusTax3, T3FBusInc1,
        T3FBusInc2, T3FBusInc3, T3FBusTax1, T3FBusTax2, T3FBusTax3, T3FarmElgbl,
        T3OthElgbl, T3QFPElgbl, T3ElgblQSB2, T3ElgblQFP2, T3ElgblQSB3,
        T3ElgblQFP3, T3NonElgblGains2, T3NonElgblGains3,
        //T3Box52, T3Box53,
        //T3Box54,
        T3Box55,
        //T3Box56,
        T3Box57);
        //T3Box58, T3Box59);
    // 20250112  //calling routine

    If (FName = 'ALL') or (LeftStr(FName, 2) = 'T5') then
    begin
      T5MULTProcess(RetNo, T5Interest, T5Pens, T5NonElgblGains, T5Dividends,
        T5DividendsEligible, T5FNonBusInc1, T5FNonBusInc2, T5FNonBusInc3,
        T5FNonBusTax1, T5FNonBusTax2, T5FNonBusTax3, T5OthEmpl);
    end;

    If (FName = 'ALL') or (LeftStr(FName, 5) = 'T4RSP') then
      T4RSPProcess(RetNo, T4RspIncome, T4RspOthDed, T4RspTax, T4RspSpBox20,
        T4RspSpBox22, T4RspSpBox26);

    If (FName = 'ALL') or (LeftStr(FName, 5) = 'T4RIF') then
      // T4RIFProcess(RetNo,T4RIFOthInc,T4RIFPens,T4RIFTax,T4RifAnnuity);
      T4RIFProcess(RetNo, T4RIFOthInc, T4RIFPens, T4RIFTax, T4RIFAnnuity,
        T4RIFSpBox16, T4RIFSpBox20, T4RIFSpBox24);

    If (FName = 'ALL') or (LeftStr(FName, 5) = 'T5013') then
      T5013Process(RetNo, T5013LimitedInc, T5013OthInc, T5013ITC,
        T5013ElgblQSB1, T5013ElgblQFP1, T5013ElgblOTH1, T5013NonElgblGains1,
        T5013ActDiv, T5013ActDivEligible, T5013CarrCharg, T5013CDE, T5013CEE,
        T5013COGPE, T5013FDE, T5013RecapDepl, T5013FedPol, T5013ProvPol,
        T5013Don, T5013Gifts, T5013Abil, T5013FNonBusInc1, T5013FNonBusInc2,
        T5013FNonBusInc3, T5013FNonBusTax1, T5013FNonBusTax2, T5013FNonBusTax3,
        T5013FBusInc1, T5013FBusInc2, T5013FBusInc3, T5013FBusTax1,
        T5013FBusTax2, T5013FBusTax3, T5013Interest, T5013Tax, T5013ResAllow,
        T5013FInterest, T5013ElgblQSB2, T5013ElgblQFP2, T5013ElgblOTH2,
        T5013NonElgblGains2, T5013ElgblQSB3, T5013ElgblQFP3, T5013ElgblOTH3,
        T5013NonElgblGains3);

    If (FName = 'ALL') or (LeftStr(FName, 4) = 'T101') then
      T101Process(RetNo, T101CEE, T101AllowCEE, T101CDE, T101AllowCDE,
        T101COGPE, T101AllowCOGPE);

    If (FName = 'ALL') or (LeftStr(FName, 4) = 'T102') then
      T102Process(RetNo, T102CEE, T102AllowCEE, T102CDE, T102AllowCDE,
        T102COGPE, T102AllowCOGPE, T102PShipInc);
  end;
end;

Function RemoveChar(S: string; Ch: String): string;
Var
  i: integer;
begin
  Result := '';
  For i := 1 to Length(S) do
    If S[i] <> Ch then
      Result := Result + S[i];
end;

Function RemoveHyphens(S: string): string;
Var
  i: integer;
begin
  Result := '';
  For i := 1 to Length(S) do
    If S[i] <> '-' then
      Result := Result + S[i];
end;

Function XferToQuebec(RetNo: integer): Real;
var
  i, FNo: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'T4' then
    begin
      FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] then // 20170324 Igor
      begin
        If (Ret[RetNo].Province = 'QC') and (FetchElmFNo(RetNo, FNo, 20) <> 'QC')
        then
          Result := Result + VL(Ret[RetNo].Frm[FNo].Strings[8]);
      end;
    end;
  end;
end;

Function GetPrvIndex(SPrv: string): integer;
Var
  i: integer;
Begin
  Result := 6; { Ontario }
  For i := 1 to High(PrvShort) do
  begin
    If UpperCase(SPrv) = PrvShort[i] then
    begin
      Result := i;
      Exit;
    end;
  end;
  If UpperCase(SPrv) = 'NU' then
    Result := 14;
End;

Function CalcMedicalLimit(RetNo: integer): Real;
begin
  Result := MaxR(0, MinR(Ret[RetNo].Lnn[23600] * 0.03,
    Constant[RY].MedicalLimit));
end;

Function CalcFedMedicalLimitForDependant(RetNo: integer;
  MedicalPaid, Ni: Real): Real;
begin
  // 20100408
  If UpperCase(FetchElm(RetNo, 'MEDICAL', 135)) <> 'Y' then
    Result := MinR(Constant[RY].MaxMedicalExpense,
      MaxR(0, MedicalPaid - MinR(Ni * 0.03, Constant[RY].MedicalLimit)))
  Else
    Result := MaxR(0, MedicalPaid - MinR(Ni * 0.03, Constant[RY].MedicalLimit));
  If Result < 0 then
    Result := 0;
end;

Function CalcPrvMedicalLimit(RetNo: integer): Real;
begin
  Result := MaxR(0, MinR(Ret[RetNo].Lnn[23600] * 0.03,
    PrvConstant[RY].PrvMedicalLimit));
end;

Function CalcPrvMedicalLimitForDependant(RetNo: integer;
  MedicalPaid, Ni: Real): Real;
Var
  IgnoreMax: Boolean;
begin

  // 20120326

  // If ((Ret[RetNo].Province = 'BC')  //20121216
  If (Ret[RetNo].Province = 'ON') Or (Ret[RetNo].Province = 'NT') then
    IgnoreMax := false
  else
  begin
    PrvConstant[RY].PrvMaxMedicalExpense := 100000;
    IgnoreMax := true;
  end;

  // 20100408
  // If UpperCase(FetchElm(RetNo,'MEDPRV',135)) <> 'Y' then
  If IgnoreMax = false then
    Result := MinR(PrvConstant[RY].PrvMaxMedicalExpense,
      MaxR(0, MedicalPaid - MinR(Ni * 0.03, PrvConstant[RY].PrvMedicalLimit)))
  else
    Result := MaxR(0, MedicalPaid - MinR(Ni * 0.03,
      PrvConstant[RY].PrvMedicalLimit));
  If Result < 0 then
    Result := 0;
end;

Procedure LoadPrvRates;
Var
  i: integer;
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir + '\' + 'PrvRates.d');
  For i := 0 to TempList.Count - 2 do
  begin
    PrvRate[i + 1, 0] := VL(AllTrim(MidStr(TempList[i], 5, 7))) / 100;
    { current yr }
    PrvRate[i + 1, 1] := VL(AllTrim(MidStr(TempList[i], 12, 7))) / 100;
    { next yr }
  end;
  TempList.Free;
end;

Function GetOriginalTransmUser(FlName, FileType: string): String;
Var
  TempList: TStringList;
  S: string;
begin
  TempList := TStringList.Create;
  TempList.LoadFromFile(FlName);
  S := TempList[0];
  If FileType = 'ACK' then
    Result := MidStr(S, 29, 10)
  else
    Result := MidStr(S, 23, 10);
  TempList.Free;
end;

Function GetSpouseSIN(RetNo: integer): String;
begin
  Result := FetchElm(RetNo, 'INFO', 4);
end;

Function IsSelfEmployed(RetNo: integer): Boolean;
begin
  Result := false;
  With Ret[RetNo] do
  begin
    If Lnn[13499] + Lnn[13699] + Lnn[13899] + Lnn[14099] + Lnn[14299] <> 0 then
      Result := true; // gross
  end;
end;

Function GetSelfEmplIncome(RetNo: integer): Real;
begin
  Result := 0;
  With Ret[RetNo] do
  begin
    Result := Lnn[13500] + Lnn[13700] + Lnn[13900] + Lnn[14100] + Lnn[14300];
    // net
  end;
end;

Function GetHlpTopicFromLineRef(FormName: String; FieldId: integer): String;
Var
  i: integer;
  LineRef: TStringList;
begin
  Result := '';
  LineRef := TStringList.Create;
  LineRef.LoadFromFile(AppDir + '\' + 'LineRef.d');
  For i := 0 to LineRef.Count - 1 do
  begin
    If FormName = AllTrim(LeftStr(LineRef[i], 9)) then
    begin
      If FieldId = MyStrToInt(AllTrim(MidStr(LineRef[i], 10, 4))) then
      begin
        Result := AllTrim(MidStr(LineRef[i], 14, 50));
        Break;
      end;
    end; { same formname }
  end; { i loop }
  LineRef.Free;
end;

Function GetTrTopicFromLineRef(FormName: String; FieldId: integer): String;
Var
  i: integer;
  LineRef: TStringList;
begin
  Result := '';
  LineRef := TStringList.Create;
  LineRef.LoadFromFile(AppDir + '\' + 'Effields.d');
  For i := 0 to LineRef.Count - 1 do
  begin
    If FormName = AllTrim(MidStr(LineRef[i], 81, 9)) then
    begin
      If FieldId = MyStrToInt(AllTrim(MidStr(LineRef[i], 91, 3))) then
      begin
        Result := ReplaceChar(AllTrim(LeftStr(LineRef[i], 4)), '*', '');
        Break;
      end;
    end; { same formname }
  end; { i loop }
  LineRef.Free;
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

Function GetClientLettersDir: String;
Var
  Dir: String;
begin
  Dir := OptRec.Dir_Cur + '\' + 'ClientLetters';
  If Not SysUtils.DirectoryExists(Dir) then
    if not SysUtils.DirectoryExists(Dir) then
    begin
      if not CreateDir(Dir) then
        raise Exception.Create('Cannot create letters directory ' + Dir);
    end;
  Result := Dir;
end;

Function MkClientLetterName(RetNo: integer): String;
begin
  Result := GetLastName(RetNo) + '-' + LeftStr(GetFirstName(RetNo), 1) +
    '.' + 'RTF';
end;

function GetLastYearFormAbrevName(FormNo: integer): String;
var
  i: integer;
begin
  Result := '';
  for i := 0 to (FLastYearList.Count - 1) do
  begin
    FLastYearRec := FLastYearList.Items[i];
    if (FLastYearRec.FormNo = FormNo) then
      Result := FLastYearRec.FormAbrev + ' ' + FLastYearRec.FormInst;
  end;
end;

function GetFormAbrevName(FormNo: integer): String;
var
  i: integer;
begin
  Result := '';
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if (FRec.FormNo = FormNo) then
      Result := FRec.FormAbrev + ' ' + FRec.FormInst;
  end;
end;

function GetFormAbrevNameWithNoInst(FormNo: integer): String;
var
  i: integer;
begin
  Result := '';
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if (FRec.FormNo = FormNo) then
      Result := FRec.FormAbrev;
  end;
end;

(*
  The following example shows how to complete partial strings typed into a combo box. The code represents the OnKeyPress event handler of the combo box, which performs most of the default keystroke handling before finding a matching list item and updating the text.

  Note:	This OnKeyPress event handler does not deal with the case when the user types the Delete key. That case must be caught in the OnKeyDown event handler instead.

  procedure TForm1.ComboBox1KeyPress(Sender: TObject; var Key: Char);

  var
  Found: boolean;
  i,SelSt: Integer;
  TmpStr: string;
  begin
  { first, process the keystroke to obtain the current string }
  { This code requires all items in list to be uppercase}
  if Key in ['a'..'z'] then Dec(Key,32); {Force Uppercase only!}
  with (Sender as TComboBox) do
  begin
  SelSt := SelStart;
  if (Key = Chr(vk_Back)) and (SelLength <> 0) then
  TmpStr := Copy(Text,1,SelStart)+Copy(Text,SelLength+SelStart+1,255)

  else if Key = Chr(vk_Back) then {SelLength = 0}
  TmpStr := Copy(Text,1,SelStart-1)+Copy(Text,SelStart+1,255)
  else {Key in ['A'..'Z', etc]}
  TmpStr := Copy(Text,1,SelStart)+Key+Copy(Text,SelLength+SelStart+1,255);
  if TmpStr = '' then Exit;
  { update SelSt to the current insertion point }

  if (Key = Chr(vk_Back)) and (SelSt > 0) then Dec(SelSt)

  else if Key <> Chr(vk_Back) then Inc(SelSt);
  Key := #0; { indicate that key was handled }
  if SelSt = 0 then
  begin
  Text:= '';
  Exit;
  end;

  {Now that TmpStr is the currently typed string, see if we can locate a match }

  Found := False;
  for i := 1 to Items.Count do
  if Copy(Items[i-1],1,Length(TmpStr)) = TmpStr then
  begin
  Text := Items[i-1]; { update to the match that was found }
  ItemIndex := i-1;
  Found := True;
  Break;
  end;
  if Found then { select the untyped end of the string }
  begin
  SelStart := SelSt;
  SelLength := Length(Text)-SelSt;

  end
  else Beep;
  end;
  end;

*)

Function IsStringInList(S: String; AList: TStringList): integer;
{ return item index of a given string }
Var
  i: integer;
begin
  Result := -1;
  For i := 0 to AList.Count - 1 do
    If UpperCase(S) = UpperCase(AList[i]) then
    begin
      Result := i;
      Exit;
    end;
end;

Procedure GetChartColors(Var ChartColor: Array of TColor);
Var
  i: integer;
begin
  For i := Low(ChartColor) to High(ChartColor) do
    ChartColor[i] := clSilver;
  ChartColor[0] := clGreen;
  ChartColor[1] := $00C5EEFE; { haki }
  ChartColor[2] := clAqua;
  ChartColor[3] := clBlue;
  ChartColor[4] := clRed;
  ChartColor[5] := clOlive;
  ChartColor[6] := clNavy;
  ChartColor[7] := clPurple;
  ChartColor[8] := clBlack;
  ChartColor[9] := clWhite;
  ChartColor[10] := clMaroon;
  ChartColor[11] := clTeal;
  ChartColor[12] := clLime;
  ChartColor[13] := clFuchsia;
  ChartColor[14] := clAqua;
  ChartColor[15] := clYellow;
  ChartColor[16] := $00F7FFFF; { Light haki }
  ChartColor[17] := $00FFFFE1; { Light blue }
  ChartColor[18] := $00DFFFFF; { Light yellow }
  ChartColor[19] := $00E6E6E6; { Light grey }
  ChartColor[20] := $000080FF; { Orange }
end;

Function GetSpouseBirthDate(RetNo: integer): String;
begin
  Result := FetchElm(RetNo, 'INFO', 59);
end;

Function FormatAccNonAccRecordCnt(S: String): String;
begin
  Result := RmvLeadingZeros(S);
  If Result = '' then
    Result := '0';
end;

Function ReplaceChar(S, FromChar, ToChar: String): String;
Var
  i: integer;
begin
  Result := '';
  For i := 1 to Length(S) do
    If S[i] = FromChar then
      Result := Result + ToChar
    else
      Result := Result + S[i];
end;

Function NIBfrAttendantCare(RetNo: integer): Real;
Var
  x: Real;
begin
  With Ret[RetNo] do
  begin
    x := Lnn[20700] + Lnn[20800] + Lnn[21200] + Lnn[21400] + { Lnn[21500] + }
      Lnn[21700] + Lnn[21900] + Lnn[22000] + Lnn[22100] + Lnn[22400] +
      Lnn[22900] + Lnn[23100] + Lnn[23200];
    Result := MaxR(0, Lnn[15000] - x);
    Result := MaxR(0, Result - Lnn[23500]);
  end;
end;

Function NIBfrAprTool(RetNo, FNo: integer; AprToolDed: Real): Real;
Var
  x: Real;
begin
  With Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    x := Lnn[20700] + Lnn[20800] + Lnn[21200] + Lnn[21400] + Lnn[21500] +
      Lnn[21700] + Lnn[21900] + Lnn[22000] + Lnn[22100] + Lnn[22200] +
      Lnn[22400] + MaxR(0, Lnn[22900] - AprToolDed) + Lnn[23100] + Lnn[23200]
      + Tv[235];
    Result := MaxR(0, Lnn[15000] - x);
    // Result := MaxR(0,Result + AprToolDed);  //add again
  end;
end;

// 20190411
// no calc change
Function CalcFedEducClaim(UnusedCF, TotalThisYear, TxblInc,
  L300To318: Real): Real;
Var
  TotalEduc, RemTxbl, UnusedClaim, MoreClaim, TotalClaim: Real;
begin
  RemTxbl := MaxR(0, TxblInc - L300To318); // ln 6
  UnusedClaim := MinR(RemTxbl, UnusedCF); // ln7
  RemTxbl := MaxR(0, RemTxbl - UnusedClaim); // ln 8
  MoreClaim := MinR(TotalThisYear, RemTxbl); // ln9=minR(Ln2,Ln8)
  Result := UnusedClaim + MoreClaim; // ln10=ln7+Ln9
end;

{ //20190411
  Function CalcFedEducClaim(UnusedCF, TotalThisYear, TxblInc,
  L300To318: Real): Real;
  Var
  TotalEduc, RemTxbl, UnusedClaim, MoreClaim, TotalClaim: Real;
  begin
  RemTxbl := MaxR(0, TxblInc - L300To318);
  UnusedClaim := MinR(RemTxbl, UnusedCF);
  RemTxbl := MaxR(0, RemTxbl - UnusedClaim);
  MoreClaim := MinR(TotalThisYear, RemTxbl);
  result := UnusedClaim + MoreClaim;
  end;
}
// 20181223 rename L300To315 to L300To314
Function CalcFedDisabilityXfer(RetNo: integer; Under18: String;
  ChCare, AttendantCare, TxblInc, L300To314: Real): Real;
Var
  DisabSupl, x, Y: Real;
begin
  If Under18 = '' then // 18 or over
    DisabSupl := 0
  else
  Begin // 20200324
    DisabSupl := Constant[RY].MaxDisabSupl18 * Ret[RetNo].PartYear;
    Y := (MaxR(0, ChCare + AttendantCare - Constant[RY].DisabSuplBase));
    DisabSupl := MaxR(0, DisabSupl - Y);
  end;
  x := Constant[RY].MaxDisability * Ret[RetNo].PartYear + DisabSupl;
  // ws 31800 line 8
  Result := MinR(x, MaxR(0, x + L300To314 - TxblInc));
end;

// 20200401
Function CalcPrvDisabilityXfer(RetNo: integer; Under18: String;
  ChCare, AttendantCare, TxblInc, L300To314: Real): Real;
Var
  DisabSupl, Ln1, Ln2, Ln5, Ln6, Ln7, Ln8, Ln9, LN10, LN11, LN12: Real;
begin
  // 20200403
  if IsMultJurisdiction(RetNo) = false then
    InitPrvConstants(Ret[RetNo].Province) // 20110310
  Else
    InitPrvConstants(T2203Prov); // 20110310

  Ln1 := PrvConstant[RY].PrvMaxDisability * Ret[RetNo].PartYear;
  Ln2 := PrvConstant[RY].PrvMaxDisabSupl18 * Ret[RetNo].PartYear;
  Ln5 := MaxR(0, ChCare + AttendantCare - PrvConstant[RY].PrvDisabSuplBase);
  Ln6 := MaxR(0, Ln2 - Ln5);
  If UpperCase(Under18) = '' then
    Ln6 := 0;
  Ln7 := Ln1 + Ln6;
  if Ln7 > PrvConstant[RY].PrvMaxDisability + PrvConstant[RY].PrvMaxDisabSupl18
  then
    Ln7 := PrvConstant[RY].PrvMaxDisability + PrvConstant[RY].PrvMaxDisabSupl18;

  Ln8 := L300To314;
  Ln9 := Ln7 + Ln8;
  LN10 := TxblInc;
  LN11 := MaxR(0, Ln9 - LN10);
  LN12 := MinR(Ln7, LN11);
  Result := LN12;
end;

(*
  //20190410
  Function CalcPrvDisabilityXfer(RetNo: Integer; Under18: String;
  ChCare, AttendantCare, TxblInc, L300To314: Real): Real;
  Var
  DisabSupl, Ln3, Ln5, Ln6,Ln7: Real;
  begin
  if IsMultJurisdiction(RetNo) then
  InitPrvConstants(T2203Prov); // 20170508

  If Under18 = '' then
  DisabSupl := 0
  else
  // DisabSupl:= MaxR(0,PrvConstant[RY].PrvMaxDisabSupl18
  DisabSupl := MaxR(0, PrvConstant[RY].PrvMaxDisabSupl18 * Ret[RetNo].PartYear
  - (MaxR(0, ChCare + AttendantCare - PrvConstant[RY].PrvDisabSuplBase)));
  Ln3 := PrvConstant[RY].PrvMaxDisability * Ret[RetNo].PartYear + DisabSupl;
  { chart ln 3 }
  Ln5 := Ln3 + L300To314;
  Ln6:=TxblInc;
  Ln7:=MaxR(0,Ln5-Ln6);
  result := MinR(Ln3, Ln7);
  //result := MinR(Ln3, MaxR(0, Ln5 - TxblInc));
  end;
*)
(*
  Function CalcPrvDisabilityXfer(RetNo: Integer; Under18: String;
  ChCare, AttendantCare, TxblInc, L300To314: Real): Real;
  Var
  DisabSupl, Ln3, Ln5: Real;
  begin
  if IsMultJurisdiction(RetNo) then
  InitPrvConstants(T2203Prov); // 20170508

  If Under18 = '' then
  DisabSupl := 0
  else
  // DisabSupl:= MaxR(0,PrvConstant[RY].PrvMaxDisabSupl18
  DisabSupl := MaxR(0, PrvConstant[RY].PrvMaxDisabSupl18 * Ret[RetNo].PartYear
  - (MaxR(0, ChCare + AttendantCare - PrvConstant[RY].PrvDisabSuplBase)));
  Ln3 := PrvConstant[RY].PrvMaxDisability * Ret[RetNo].PartYear + DisabSupl;
  { chart ln 3 }
  Ln5 := Ln3 + L300To314;
  result := MinR(Ln3, MaxR(0, Ln5 - TxblInc));
  end;
*)
(*
  Function CalcFedDisabilityXfer(RetNo:Integer;Under18:String;ChCare,AttendantCare,TxblInc,L300To315:real):Real;
  Var DisabSupl,x:Real;
  begin
  If Under18 = '' then
  DisabSupl:= 0
  else
  DisabSupl:= MaxR(0,Constant[RY].MaxDisabSupl18 * Ret[RetNo].PartYear
  -(MaxR(0,Chcare+AttendantCare-Constant[RY].DisabSuplBase)));
  X:=Constant[RY].MaxDisability * Ret[RetNo].PartYear + DisabSupl;

  Result:=MinR(x,MaxR(0,x+L300To315-TxblInc));
  end;

  Function CalcPrvDisabilityXfer(RetNo:Integer;Under18:String;ChCare,AttendantCare,TxblInc,L300To315:real):Real;
  Var DisabSupl,Ln3,Ln5:Real;
  begin
  if IsMultJurisdiction(RetNo) then InitPrvConstants(T2203Prov); //20170508

  If Under18 = '' then
  DisabSupl:= 0
  else
  //DisabSupl:= MaxR(0,PrvConstant[RY].PrvMaxDisabSupl18
  DisabSupl:= MaxR(0,PrvConstant[RY].PrvMaxDisabSupl18 * Ret[RetNo].PartYear
  -(MaxR(0,Chcare+AttendantCare-PrvConstant[RY].PrvDisabSuplBase)));
  Ln3:=PrvConstant[RY].PrvMaxDisability * Ret[RetNo].PartYear + DisabSupl;   {chart ln 3}
  Ln5:= Ln3 +L300To315;
  Result := MinR(Ln3,MaxR(0,Ln5-TxblInc));
  //T2203Prov:='';  //20180323
  end;
*)

(* 20170508
  //20170426
  Function T2203CalcPrvDisabilityXfer(RetNo:Integer;Under18:String;ChCare,AttendantCare,TxblInc,L5804To5840:real;Prv:String):Real; //20170426
  Var DisabSupl,Ln3,Ln5:Real;
  begin
  InitPrvConstants(PRV);   //to pick up the right variables for the province
  If Under18 = '' then
  DisabSupl:= 0
  else
  //DisabSupl:= MaxR(0,PrvConstant[RY].PrvMaxDisabSupl18
  DisabSupl:= MaxR(0,PrvConstant[RY].PrvMaxDisabSupl18 * Ret[RetNo].PartYear
  -(MaxR(0,Chcare+AttendantCare-PrvConstant[RY].PrvDisabSuplBase)));
  Ln3:=PrvConstant[RY].PrvMaxDisability * Ret[RetNo].PartYear + DisabSupl;   {chart ln 3}
  Ln5:= Ln3 +L5804To5840;
  Result := MinR(Ln3,MaxR(0,Ln5-TxblInc));
  end;
*)

Function CalcPrvEducClaim(RetNo: integer; UnusedCF, TotalThisYear, TxblInc,
  L300To318: Real): Real;
Var
  TotalEduc, RemTxbl, UnusedClaim, MoreClaim, TotalClaim: Real;
begin
  RemTxbl := MaxR(0, TxblInc - L300To318);
  UnusedClaim := MinR(RemTxbl, UnusedCF);
  RemTxbl := MaxR(0, RemTxbl - UnusedClaim);
  MoreClaim := MinR(TotalThisYear, RemTxbl);
  Result := UnusedClaim + MoreClaim;
end;

Function SplitIncome(RetNo: integer): Boolean;
begin
  If (VL(FetchElm(RetNo, 'T1206', 3)) > 0) then
    Result := true
  else
    Result := false;
end;

Function GetInclusionRate(RetNo: integer): Real;
begin
  Result := 50;
end;

{ //for othded 24900 but not used
  Function GetDeferredDispBenefit(RetNo: integer): Real;
  begin
  Result := VL(FetchElm(RetNo, 'T1212', 5)) * 50 / 100;
  Result:=Result+VL(FetchElm(RetNo, 'T1212', 3)) * 33.3333 / 100; //20241214

  end;
}

Function GetProrationIndicator(RetNo: integer): integer;
begin
  Result := 0;
  If ((Ret[RetNo].Age >= 70) or (TotMultiple(RetNo, 'T4AP', 11) > 0)) then
  begin
    If (Ret[RetNo].Province = 'QC') then
    begin
      If (TotMultiple(RetNo, 'T4', 4) > 0) { qpp hence employed in QC }
        or ((TotMultiple(RetNo, 'T4', 4) > 0) and
        (TotMultiple(RetNo, 'T4', 3) > 0)) then
        Result := 2 // means no proration of cpp
      else if TotMultiple(RetNo, 'T4', 3) > 0 then
        Result := 1;
    end
    else { non qc resident }
    begin
      If (TotMultiple(RetNo, 'T4', 4) > 0) and (TotMultiple(RetNo, 'T4', 3) > 0)
      then
        Result := 1
      else If (TotMultiple(RetNo, 'T4', 4) > 0) then
        Result := 2;
    end;
  end;
  // If GetSinNo(RetNo)='870000676' then result:=1;  //????  20121211
end;

Function GetFastPrintIndicator: Boolean;
Var
  TempList: TStringList;
  S: String;
begin
  Result := OptRec.UseFastPrint;
end;

Function ShowSalutationWarning: Boolean;
Var
  TempList: TStringList;
  S: String;
begin
  Result := OptRec.ShowSaluteWarning;
end;

Function ShowInvoiceWarning: Boolean;
Var
  TempList: TStringList;
  S: String;
begin
  Result := OptRec.ShowInvoiceWarning;
end;

Function ShowEfileCharges: Boolean;
Var
  TempList: TStringList;
  S: String;
begin
  Result := OptRec.ShowInvoiceEfCharge;

end;

Function GetT1013Level: String;
Var
  TempList: TStringList;
  S: String;
begin
  Result := OptRec.T1013AuthorLevel;
end;

Function GetShowOpenedFormsIndicator: Boolean;
begin
  Result := OptRec.ShowVisitedForms;
end;

Function GetCVIndicator: String;
Var
  TempList: TStringList;
  S: String;
begin
  Result := OptRec.CVSetting;
  // If result='' then result:='1';
end;

Function GetCVPostIndicator: String;
Var
  TempList: TStringList;
  S: String;
begin
  Result := OptRec.CVPostSetting;
  // If result='' then result:='1';
end;

Function GetT4T5RolloverIndicator: Boolean;
Var
  TempList: TStringList;
  S: String;
begin
  Result := OptRec.RolloverT4T5;
end;

Function ShowCondominiumIndicator: Boolean;
Var
  TempList: TStringList;
  S: String;
begin
  Result := OptRec.UseCondominiumLine;
end;

Function IsFormTheDefaultSearch: Boolean;
Var
  TempList: TStringList;
  S: String;
begin
  Result := OptRec.UseFormSearch;
end;

Function IsHomeUse: Boolean;
// const ActivationFile = 'LVerf.EX_';  //20120128
Var
  SomeString: TStringList;
  ThisKey: String;
begin
  Result := false;
  If LicenseLevel = llNetFile then
    Result := true;
end;

Function GetPrvForTaxCredit(RetNo: integer; ThisPrv: String): Real;
begin
  Result := 0;
  If ThisPrv = Ret[RetNo].Province then
    Result := VL(FetchElm(RetNo, 'T2036', 34));
end;

Function IsDeceased(RetNo: integer): Boolean;
begin
  Result := false;
  If (FetchElm(RetNo, 'INFO', 24) > '') and
    (LeftStr(FetchElm(RetNo, 'INFO', 24), 4) = AppYear) then
    Result := true;
end;

Function IsDeceasedNextYear(RetNo: integer): Boolean; // 20140219
begin
  Result := false;
  If (FetchElm(RetNo, 'INFO', 24) > '') then
  Begin
    If LeftStr(FetchElm(RetNo, 'INFO', 24), 4)
      = IntToStr(MyStrToInt(AppYear) + 1) then
      Result := true;
  end;
end;

Function IsSpouseDeceased(RetNo: integer): Boolean;
begin
  Result := false;
  If LeftStr(FetchElm(RetNo, 'INFO', 65), 4) = AppYear then
    Result := true;
end;

Function ZeroIfPositive(x: Real): Real;
begin
  Result := x;
  If x > 0 then
    Result := 0;
end;

// Procedure AuditRecsToTreeView(RetNo:Integer;TempList:TStrings);
Procedure AuditRecsToTreeView(RetNo: integer; TempList: TStrings;
  AuditMode: eAuditMode);
Var
  i: integer;
begin
  TempList.Clear;
  // If MainForm.SuperAuditBox.Checked then
  if AuditMode = amSuperAudit then
  begin
    If CountErrorType(RetNo, 'S') = 0 then
      TempList.Add('SUPER AUDIT (NONE)') // 20160518 Igor
    else
    begin
      TempList.Add('SUPER AUDIT'); // 20160518 Igor
      // for i:=Low(Ret[RetNo].AuditRec) to High(Ret[RetNo].AuditRec) do
      For i := 0 to Ret[RetNo].AuditList.Count - 1 do
        If LeftStr(Ret[RetNo].AuditRec[i].Category, 1) = 'S' then
          TempList.Add(' ' + Ret[RetNo].AuditRec[i].Description);
    end;
  end;

  If CountErrorType(RetNo, 'M') = 0 then
    TempList.Add('MANDATORY (NONE)') // 20160518 Igor
  else
  begin
    TempList.Add('MANDATORY'); // 20160518 Igor
    // for i:=Low(Ret[RetNo].AuditRec) to High(Ret[RetNo].AuditRec) do
    For i := 0 to Ret[RetNo].AuditList.Count - 1 do
      If LeftStr(Ret[RetNo].AuditRec[i].Category, 1) = 'M' then
        TempList.Add(' ' + Ret[RetNo].AuditRec[i].Description);
  end;

  If CountErrorType(RetNo, 'E') = 0 then
    TempList.Add('ERRORS (NONE)') // 20160518 Igor
  else
  begin
    TempList.Add('ERRORS'); // 20160518 Igor
    // for i:=Low(Ret[RetNo].AuditRec) to High(Ret[RetNo].AuditRec) do
    For i := 0 to Ret[RetNo].AuditList.Count - 1 do
      If LeftStr(Ret[RetNo].AuditRec[i].Category, 1) = 'E' then
        TempList.Add(' ' + Ret[RetNo].AuditRec[i].Description);
  end;

  If CountErrorType(RetNo, 'W') = 0 then
    TempList.Add('WARNINGS (NONE)') // 20160518 Igor
  else
  begin
    TempList.Add('WARNINGS'); // 20160518 Igor
    // for i:=Low(Ret[RetNo].AuditRec) to High(Ret[RetNo].AuditRec) do
    For i := 0 to Ret[RetNo].AuditList.Count - 1 do
      If LeftStr(Ret[RetNo].AuditRec[i].Category, 1) = 'W' then
        TempList.Add(' ' + Ret[RetNo].AuditRec[i].Description);
  end;

  If CountErrorType(RetNo, 'F') = 0 then
    TempList.Add('EFILE (NONE)') // 20160518 Igor
  else
  begin
    TempList.Add('EFILE-CANNOT EFILE'); // 20160518 Igor
    // for i:=Low(Ret[RetNo].AuditRec) to High(Ret[RetNo].AuditRec) do
    For i := 0 to Ret[RetNo].AuditList.Count - 1 do
      If LeftStr(Ret[RetNo].AuditRec[i].Category, 1) = 'F' then
        TempList.Add(' ' + Ret[RetNo].AuditRec[i].Description);
  end;

  If CountErrorType(RetNo, 'T') = 0 then
    TempList.Add('TIPS (NONE)') // 20160518 Igor
  else
  begin
    TempList.Add('TIPS'); // 20160518 Igor
    // for i:=Low(Ret[RetNo].AuditRec) to High(Ret[RetNo].AuditRec) do
    For i := 0 to Ret[RetNo].AuditList.Count - 1 do
      If LeftStr(Ret[RetNo].AuditRec[i].Category, 1) = 'T' then
        TempList.Add(' ' + Ret[RetNo].AuditRec[i].Description);
  end;

  If CountErrorType(RetNo, 'R') = 0 then
    TempList.Add('REVIEW MARKS (NONE)') // 20160518 Igor
  else
  begin
    TempList.Add('REVIEW MARKS'); // 20160518 Igor
    // for i:=Low(Ret[RetNo].AuditRec) to High(Ret[RetNo].AuditRec) do
    For i := 0 to Ret[RetNo].AuditList.Count - 1 do
      If LeftStr(Ret[RetNo].AuditRec[i].Category, 1) = 'R' then
        TempList.Add(' ' + Ret[RetNo].AuditRec[i].Description);
  end;

  If CountErrorType(RetNo, 'D') = 0 then
    TempList.Add('ADDING TAPES (NONE)') // 20160518 Igor
  else
  begin
    TempList.Add('ADDING TAPES'); // 20160518 Igor
    // for i:=Low(Ret[RetNo].AuditRec) to High(Ret[RetNo].AuditRec) do
    For i := 0 to Ret[RetNo].AuditList.Count - 1 do
      If LeftStr(Ret[RetNo].AuditRec[i].Category, 1) = 'D' then
        TempList.Add(' ' + Ret[RetNo].AuditRec[i].Description);
  end;

  If CountErrorType(RetNo, 'N') = 0 then
    TempList.Add('NOTES (NONE)') // 20160518 Igor
  else
  begin
    TempList.Add('NOTES'); // 20160518 Igor
    // for i:=Low(Ret[RetNo].AuditRec) to High(Ret[RetNo].AuditRec) do
    For i := 0 to Ret[RetNo].AuditList.Count - 1 do
      If LeftStr(Ret[RetNo].AuditRec[i].Category, 1) = 'N' then
        TempList.Add(' ' + Ret[RetNo].AuditRec[i].Description);
  end;

  If CountErrorType(RetNo, '0') = 0 then
    TempList.Add('SIGNED-OFF WARNINGS(NONE)') // 20160518 Igor
  else
  begin
    TempList.Add('SIGNED-OFF WARNINGS'); // 20160518 Igor
    // for i:=Low(Ret[RetNo].AuditRec) to High(Ret[RetNo].AuditRec) do
    For i := 0 to Ret[RetNo].AuditList.Count - 1 do
      If LeftStr(Ret[RetNo].AuditRec[i].Category, 1) = 'O' then
        TempList.Add(' ' + Ret[RetNo].AuditRec[i].Description);
  end;

end;

Function CountErrorType(RetNo: integer; Category: String): integer;
Var
  i: integer;
begin
  Result := 0;
  // For i:=Low(Ret[Retno].AuditRec) to High(Ret[Retno].AuditRec) do
  For i := 0 to Ret[RetNo].AuditList.Count - 1 do
  begin
    If UpperCase(LeftStr(Ret[RetNo].AuditRec[i].Category, 1)) = Category then
      inc(Result);
  end;
end;

Function FetchADate: String;
begin
  Result := GetCalendar;
end;

Function OpentaxbyteDB(UserId: string): Boolean;
// var lPsw:String;//20160303 Igor
begin
  Result := SetConnection(taxbyteDb, TaxByteDBLite, TaxByteTableLite);
  // 20160303 Igor

  // Result := fGetSQLitePsw(lPsw); //20150925 Igor
  // //20150924 Igor
  // taxbyteDb := TADConnection.Create(Application);
  // taxbyteDb.Params.Values['DataBase'] := TaxByteDBLite;
  // taxbyteDb.Params.Values['Password'] := lPsw;
  // taxbyteDb.DriverName:='SQLite';
  // taxbyteDB.LoginPrompt := False;
  // //taxbyteDb.Data+Base+Name := 'TaxByteT1';
  // //taxbyteDb.AliasName := taxbyteDB.DataBaseName; {needed}
  // Try
  // taxbyteDb.Open;
  // except on e: Exception do ExceptMsg(e);
  // //on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
  // end;
  // Result := taxbyteDb.Connected;

end;

Function FindWord(ThisWord, Ln: String): integer;
Var
  Place: integer;
begin
  Result := Pos(UpperCase(ThisWord), UpperCase(Ln));
end;

Function CalcPRVL300To314(RNo: integer; WhichTransfer: String): Real;
// 20181223
{ 5804 to 5840 }
Var
  FNo: integer;
  FName: String;
begin
  Result := 0;
  If Ret[RNo].Province = 'ON' then
    FName := 'ON428'
  else If Ret[RNo].Province = 'AB' then
    FName := 'AB428'
  else If Ret[RNo].Province = 'BC' then
    FName := 'BC428'
  else If Ret[RNo].Province = 'MB' then
    FName := 'MB428'
  else If Ret[RNo].Province = 'NB' then
    FName := 'NB428'
  else If Ret[RNo].Province = 'NL' then
    FName := 'NL428'
  else If Ret[RNo].Province = 'PE' then
    FName := 'PE428'
  else If Ret[RNo].Province = 'NS' then
    FName := 'NS428'
  else If Ret[RNo].Province = 'SK' then
    FName := 'SK428'
  else If Ret[RNo].Province = 'NT' then
    FName := 'NT428'
  else If Ret[RNo].Province = 'NU' then
    FName := 'NU428'
  else If Ret[RNo].Province = 'YT' then
    FName := 'YT428'
  else
    Exit;

  FNo := GetFormNo(FName);
  Result := VL(FetchElmFNo(RNo, FNo, 23)) + VL(FetchElmFNo(RNo, FNo, 24)) +
    VL(FetchElmFNo(RNo, FNo, 28)) + VL(FetchElmFNo(RNo, FNo, 29)) +
    VL(FetchElmFNo(RNo, FNo, 30)) + VL(FetchElmFNo(RNo, FNo, 31)) +
    VL(FetchElmFNo(RNo, FNo, 32)) + VL(FetchElmFNo(RNo, FNo, 33)) +
    VL(FetchElmFNo(RNo, FNo, 34)) +
  // + VL(FetchElmFNo(RNo, FNo, 35)) + //20200320  uknown
    Ret[RNo].Lnn[31217];
  // Ret[RNo].Ln[317] // same all provinces  //20200214 self -empl

  If WhichTransfer = 'EDUC' then
  begin
    Result := Result + VL(FetchElmFNo(RNo, FNo, 36)) +
      VL(FetchElmFNo(RNo, FNo, 37));
    If (Ret[RNo].Province = 'MB') or (Ret[RNo].Province = 'ON') or
      (Ret[RNo].Province = 'AB') or (Ret[RNo].Province = 'NL') or
      (Ret[RNo].Province = 'YT') then
      Result := Result + VL(FetchElmFNo(RNo, FNo, 51));
    If Ret[RNo].Province = 'NS' then
      Result := Result + VL(FetchElmFNo(RNo, FNo, 74)) +
        VL(FetchElmFNo(RNo, FNo, 75));
    If Ret[RNo].Province = 'NU' then
      Result := Result + VL(FetchElmFNo(RNo, FNo, 73));
    If Ret[RNo].Province = 'PE' then
      Result := Result + VL(FetchElmFNo(RNo, FNo, 68)) +
        VL(FetchElmFNo(RNo, FNo, 75));
    If Ret[RNo].Province = 'SK' then
      Result := Result + VL(FetchElmFNo(RNo, FNo, 66)) +
        VL(FetchElmFNo(RNo, FNo, 67));
    If Ret[RNo].Province = 'YT' then
      Result := Result + VL(FetchElmFNo(RNo, FNo, 73)) +
        VL(FetchElmFNo(RNo, FNo, 74));
  end;
end;

Function GetPrvDisabXfer(RetNo: integer): Real;
begin
  Result := VL(FetchElm(RetNo, 'PTRANSF', 71));
  // 20240520 FO OT prparea % again * VL(FetchElm(RetNo, 'PTRANSF', 69)) / 100;
end;

Function GetPrvEducXfer(RetNo: integer): Real;
var
  Amt, x: Real; // 20131215
begin
  // 20240303
  Amt := VL(FetchElm(RetNo, 'PTRANSF', 3));
  If Amt = 0 then
    Amt := VL(FetchElm(RetNo, 'PTRANSF', 72));
  // x := VL(FetchElm(RetNo, 'PTRANSF', 72)) *
  x := Amt * VL(FetchElm(RetNo, 'PTRANSF', 70)) / 100;
  Result := x;
  If IsPreBankruptcyReturn(RetNo) then
  begin
    Result := x * VL(FetchElm(RetNo, 'BANKRPT', 2)) / 365;
    Exit;
  End; // 20101202
end;

Function FullTONIProvince(RetNo: integer): Boolean;
begin
  Result := false;
  If (Ret[RetNo].Province = 'ON') or (Ret[RetNo].Province = 'AB') or
    (Ret[RetNo].Province = 'BC') or (Ret[RetNo].Province = 'MB') or
    (Ret[RetNo].Province = 'NL') or (Ret[RetNo].Province = 'NB') or
    (Ret[RetNo].Province = 'PE') or (Ret[RetNo].Province = 'NS') or
    (Ret[RetNo].Province = 'SK') or (Ret[RetNo].Province = 'NT') or
    (Ret[RetNo].Province = 'NU') or (Ret[RetNo].Province = 'YT') then
    Result := true;
end;

Function GetS2PrvHeader(RetNo: integer): String;
begin
  Result := Ret[RetNo].Province + '(S2)';
  {
    If Ret[RetNo].Province = 'NT' then result:= 'NT(S2)';
    If Ret[RetNo].Province = 'YT' then result:= 'YT(S2)';
  }
end;

Function GetCarePrvHeader(RetNo: integer): String;
begin
  Result := Ret[RetNo].Province;
end;

Function GetS11PrvHeader(RetNo: integer): String;
begin
  Result := Ret[RetNo].Province + '(S11)';
end;

Function GetAnyPathMoreThan8Chars(Dir: String): String;
Var
  i: integer;
  WList: TStringList;
  { returns dir part that is more than 8 chars, else nil }
begin
  Result := '';
  WList := TStringList.Create;
  ParseWords(Dir, '\', WList);
  For i := 0 to WList.Count - 1 do
  begin
    If Length(WList[i]) > 8 then
    begin
      Result := WList[i];
      WList.Free;
      Exit;
    end;
  end;
  WList.Free;
end;

Procedure ParseWords(S: String; Delim: String; Var WList: TStringList);
Var
  i, FromI, ToI: integer;
  Wrd: String;
  { when calling s:=s+delimiter may need a delimiter at the end in case tere is no last value }
begin
  Try
    S := AllTrim(S);
    WList.Clear;
    If S = '' then
      Exit;
    // s:=s+Delim;
    i := 1;
    FromI := 1;
    ToI := Length(S);
    Repeat
      If (i > ToI) or (S[i] = Delim) then
      begin
        Wrd := MidStr(S, FromI, i - FromI);
        WList.Add(Wrd);
        FromI := i + 1;
        inc(i);
        If (FromI > ToI) or (i > ToI) then
          Break;
      end
      else
        inc(i);
    until i > ToI + 1;
  Except
    ShowMessage('Parsing failed');
    // on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
  end; // try
end;

Function GetTax1FormName(RetNo: integer): String;
begin
  Result := Ret[RetNo].Province + '428';
  If Ret[RetNo].Province = 'AB' then
    Result := 'AB428';
  If Ret[RetNo].Province = 'MB' then
    Result := 'MB428';
  If Ret[RetNo].Province = 'ON' then
    Result := 'ON428';
  If Ret[RetNo].Province = 'BC' then
    Result := 'BC428';
  If Ret[RetNo].Province = 'NB' then
    Result := 'NB428';
  If Ret[RetNo].Province = 'NS' then
    Result := 'NS428';
  If Ret[RetNo].Province = 'NU' then
    Result := 'NU428';
  If Ret[RetNo].Province = 'NT' then
    Result := 'NT428';
  If Ret[RetNo].Province = 'NL' then
    Result := 'NL428';
  If Ret[RetNo].Province = 'YT' then
    Result := 'YT428';
  If Ret[RetNo].Province = 'SK' then
    Result := 'SK428';
  If Ret[RetNo].Province = 'PE' then
    Result := 'PE428';
  If Ret[RetNo].Province = 'QC' then
    Result := '';
end;

Function JulianDaysToBirthDate(DtIn: String): String;
// 20170731 Igor>>>
Var
  i, d, m, yr, temp: integer;
  x, Y: Real;
  sd, sm, syr: string;
  MonthDays: Array [0 .. 11] of integer;
  NumDays: integer;
begin
  If DtIn.IsEmpty or DtIn.StartsWith('12:00') then
    Exit('');
  Try
    if Length(DtIn.Split(['/', '-', '.'])) = 3 then
      Exit(ConvertGpDate(DtIn));
    { if in Julian numeric forma }
    NumDays := MyStrToInt(DtIn);
    If NumDays = 0 then
      Exit('');

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
    yr := Trunc(NumDays / 365.25) + 1900;
    If IsLeapYear(yr) then
      MonthDays[1] := 29;
    d := (NumDays * 100 mod 36525) div 100;
    m := 0;
    temp := d;
    While temp > MonthDays[m] do
    begin
      temp := temp - MonthDays[m];
      m := m + 1;
    end;
    m := m + 1;

    sd := AllTrim(IntToStr(d));
    If Length(sd) = 1 then
      sd := '0' + sd;

    sm := AllTrim(IntToStr(m));
    If Length(sm) = 1 then
      sm := '0' + sm;

    syr := AllTrim(IntToStr(yr));
    Result := syr + '-' + sm + '-' + sd;
  except
    ShowMessage('error converting Dates (birthdate, etc)');
  end;
  // 20170731 Igor<<<
end;

Function CanTaxJulianDaysToYYYYMMDD(DtIn: String): String;
// shows days since March 1, 1800?
Var
  TDate1, TDate2: TDate; // date is number of days since delphi since 1899
begin
  Result := '';
  Try
    TDate1 := MDYtoDate('03/01/1800');
    TDate2 := StrToInt(DtIn) + TDate1 - 2;
    Result := FormatDateTime('yyyy-mm-dd', TDate2);
    If LeftStr(Result, 4) = '1800' then
      Result := '';
  Except
    on E: Exception do
      ExceptMsg(E);
  end;
end;

Function MaxTransfersFromKids(RetNo: integer): Real;
Var
  L350, L335, CurrentXfer: Real;
begin
  With Ret[RetNo] do
  begin
    { calc line 350 so basic fed tax ln 429 becomes zero }
    L350 := VL(FetchElm(RetNo, 'T1', 130)) // VL(FetchElm(RetNo, 'S1', 103))
      - Lnn[40425] - Lnn[42600] - Lnn[40427] + Lnn[41450];
    { calc line gross L335 so ln 420 based on the above }
    L335 := MaxR(0, L350 - Lnn[34900]) / (16 / 100);
    Result := MaxR(0, L335 - Lnn[30300] - Lnn[30400] - Lnn[30600] - Lnn[30800] -
      Lnn[31000] - Lnn[31200] - Lnn[31400] - Lnn[31500] - Lnn[31600] -
      Lnn[31900] - Lnn[32300] - Lnn[32600]);
  end;
end;

Function PowerFeatureOnly(LicenseLevel: String): Boolean;
begin
  If (LicenseLevel = 'T1 Power') or (LicenseLevel = 'T1 PaperFile') or
    (LeftStr(LicenseLevel, 8) = 'T1 Multi') then
    Result := true
  else
    Result := false;
end;

// 20170901 Igor>>>
// Function CountDBRecords: Integer;
// var
// //20150824 igor
// FDConnection: TADConnection;
/// /  lPsw:String; //20160226 Igor
// begin
// Result := -1; //20160226 Igor
/// /  fGetSQLitePsw(lPsw); //20150925 igor //20160226 Igor
// //20160226 Igor >>>>>
// if not SetConnection(FDConnection, OptRec.Dir_Cur + '\' + ClientsDBLite, ClientsTableLite) then
// Begin
// if assigned(FDConnection) then
// freeAndNil(FDConnection);
// exit;
// End;
/// /  FDConnection := TADConnection.Create(nil);
/// /  FDConnection.DriverName := 'SQLite';
// try
/// /    //20150904 igor
/// /    FDConnection.Params.Values['Password'] := lPsw;
/// /    FDConnection.Params.Values['DataBase'] := OptRec.Dir_Cur + '\' + ClientsDBLite;
// //20160226 Igor <<<<<<
// result := FDConnection.ExecSQLScalar('SELECT count(*) FROM ' + ClientsTableLite);
// finally
// FDConnection.Free;
// end;
// end;
// 20170901 Igor<<<

Function UpdateDcnNo(SinNo: String; DcnNo: String): Boolean;
// match on file name and store the DcnNo (8 chars) starting at pos 6 of t183 dcn (after the Efiler No)
var
  // 20150824 igor
  FDConnection: TADConnection;
  FlName: String;
  // lPsw:String; //20160226 Igor
begin
  // Result := fGetSQLitePsw(lPsw); //20150925 igor //20160226 Igor

  FlName := LeftStr(SinNo, 8) + '.' + RightStr(SinNo, 1);
  // DcnNo:=DcnNo; //MidStr(DcnNo,6,8);  //20120122
  // 20160226 Igor >>>>>
  if not SetConnection(FDConnection, OptRec.Dir_Cur + '\' + ClientsDBLite,
    ClientsTableLite) then
  Begin
    if Assigned(FDConnection) then
      FreeAndNil(FDConnection);
    Exit(false);
  End;
  // FDConnection := TADConnection.Create(nil);
  // FDConnection.DriverName := 'SQLite';
  try
    // FDConnection.Params.Values['DataBase'] := OptRec.Dir_Cur + '\' + ClientsDBLite;
    // //20150904 igor
    // FDConnection.Params.Values['Password'] := lPsw;
    // 20160226 Igor <<<<<
    Result := FDConnection.ExecSQL('UPDATE ' + ClientsTableLite +
      ' SET Dcn_No = ''' + DcnNo + ''' WHERE lower(File_Name) = lower(''' +
      FlName + ''')') <> 0; // 20170223 Igor
    if not Result then
      ShowTimedMsg('Return ' + FlName +
        ' not found while updating the DCN number', 1300);
  finally
    FDConnection.Free;
  end;
end;

// 20170901 Igor>>>
// Function ExceedsMaxReturnsAllowed:Boolean;
// begin
// Result:=false;
//
// If LicenseLevel in anyLimited then  //20090301
// begin
// If CountDBRecords > LimitedVersionReturns then
// begin
// result:=True;
// Exit;
// end;
// end;
//
// If IsHomeUse then
// begin
// If CountDBRecords > NetfileVersionReturns then
// begin
// result:=True;
// Exit;
// end;
// end;
// end;
// 20170901 Igor<<<

Function IsSection115(RetNo: integer): Boolean; // 20240413  NR with Empl
begin
  Result := false;
  If FetchElm(RetNo, 'INFO', 237) > '' then
    Result := true
  else
    Result := false;
end;

Function IsSection116(RetNo: integer): Boolean; // 20240413
begin
  Result := false;
  If FetchElm(RetNo, 'INFO', 238) > '' then
    Result := true
  else
    Result := false;
end;

Function IsSection216(RetNo: integer): Boolean;
begin
  Result := false;
  If FetchElm(RetNo, 'INFO', 239) > '' then  //20250423  cz
  //If FetchElm(RetNo, 'INFO', 238) > '' then   //jz//NonResCERT-R2 20250415 //If FetchElm(RetNo, 'INFO', 93) > '' then
    Result := true;

  If Ret[RetNo].Province <> 'ZZ' then
    Result := false;
end;


Function IsSection2161(RetNo: integer): Boolean;  //20260506
begin
  Result := false;
  If FetchElm(RetNo, 'INFO', 240) > '' then  //20250423  cz
    Result := true;

  If Ret[RetNo].Province <> 'ZZ' then
    Result := false;
end;



Function IsSection217(RetNo: integer): Boolean;
begin
  Result := false;
  If FetchElm(RetNo, 'INFO', 94) > '' then
    Result := true;
  If Ret[RetNo].Province <> 'ZZ' then
    Result := false;
end;

Function IsBankruptcyReturn(RetNo: integer): Boolean;
begin
  Result := false;
  If FetchElm(RetNo, 'INFO', 92) > '' then
    Result := true;
end;

Function IsPreBankruptcyReturn(RetNo: integer): Boolean;
begin
  Result := false;
  If FetchElm(RetNo, 'BANKRPT', 4) > '' then
    Result := true;
end;

Function IsPostBankruptcyReturn(RetNo: integer): Boolean;
begin
  Result := false;
  If FetchElm(RetNo, 'BANKRPT', 5) > '' then
    Result := true;
end;

Function IncrYear(Dt: String): String;
{ in:yyyy-mm-dd : gives yyy+1-mm-dd }
Var
  yr: integer;
begin
  Result := IntToStr(MyStrToInt(LeftStr(Dt, 4)) + 1) + MidStr(Dt, 5, 6);
end;

Function ConvertGpDate(DtIn: String): String;
// DtIn mm/dd/yyyy or yyy-mm-dd Could be any valid win date
// 20170731 Igor >>>
begin
  Result := FormatDateTime('yyyy-mm-dd',
    StrToDate(DtIn, TFormatSettings.Create));
  // 20170731 Igor<<<
end;

Procedure SortMedical(RetNo: integer; FName: String);
Var
  i, j, k, kk, FNo: integer;
  Records: TStringList;
  FormName: string absolute FName; // ???
begin
  Records := TStringList.Create;
  FNo := GetFormNo(FName);
  i := 5;
  If FormName = 'MEDICAL' then
  begin
    k := 137;
    kk := 113;
  end
  else
  begin
    k := 110;
    kk := 133;
  end;
  Repeat
    If AllTrim(FetchElmFNo(RetNo, FNo, i)) > '' then
    begin
      Records.Add(PaddR(FetchElmFNo(RetNo, FNo, i), 10) +
        PaddR(FetchElmFNo(RetNo, FNo, kk), 3) + PaddR(FetchElmFNo(RetNo, FNo,
        i + 1), 20) + PaddR(FetchElmFNo(RetNo, FNo, i + 2), 30) +
        PaddR(FetchElmFNo(RetNo, FNo, i + 3), 30) + PaddR(FetchElmFNo(RetNo,
        FNo, i + 4), 10) + PaddR(FetchElmFNo(RetNo, FNo, k), 10));
    end;
    i := i + 5;
    k := k + 1;
    kk := kk + 1;
  until i > 105;

  Records.Sorted := true;

  { Clear form }
  i := 5;
  If FormName = 'MEDICAL' then
  begin
    k := 137;
    kk := 113;
  end
  else
  begin
    k := 110;
    kk := 133;
  end;
  Repeat
    StoreElm(RetNo, FNo, i, '');
    StoreElm(RetNo, FNo, kk, '');
    StoreElm(RetNo, FNo, i + 1, '');
    StoreElm(RetNo, FNo, i + 2, '');
    StoreElm(RetNo, FNo, i + 3, '');
    StoreElm(RetNo, FNo, i + 4, '');
    StoreElm(RetNo, FNo, k, '');
    i := i + 5;
    k := k + 1;
    kk := kk + 1;
  until i > 105;
  { copy to medical sorted records }
  j := 5;
  If FormName = 'MEDICAL' then
  begin
    k := 137;
    kk := 113;
  end
  else
  begin
    k := 110;
    kk := 133;
  end;
  For i := 0 to Records.Count - 1 do
  begin
    StoreElm(RetNo, FNo, j, AllTrim(LeftStr(Records[i], 10)));
    StoreElm(RetNo, FNo, kk, AllTrim(MidStr(Records[i], 11, 3)));
    StoreElm(RetNo, FNo, j + 1, AllTrim(MidStr(Records[i], 14, 20)));
    StoreElm(RetNo, FNo, j + 2, AllTrim(MidStr(Records[i], 34, 30)));
    StoreElm(RetNo, FNo, j + 3, AllTrim(MidStr(Records[i], 64, 30)));
    StoreElm(RetNo, FNo, j + 4, AllTrim(MidStr(Records[i], 94, 10)));
    StoreElm(RetNo, FNo, k, AllTrim(MidStr(Records[i], 104, 10)));
    j := j + 5;
    k := k + 1;
    kk := kk + 1;
  end;
  Records.Free;
end;

Function NetIncBfrChCare(RNo: integer): Real;
begin
  With Ret[RNo] do
  begin
    Result := MaxR(0, Lnn[15000] - Lnn[20700] - Lnn[20800] - Lnn[21000] -
      Lnn[21200] - Lnn[21300] - Lnn[21500] - Lnn[21700] - Lnn[21900] -
      Lnn[22000] - Lnn[22100] - Lnn[22200] - Lnn[22400] - Lnn[22900] -
      Lnn[23100] - Lnn[23200]);
    Result := MaxR(0, Result - Lnn[23500]);
  end;
end;

Function GetMjAlloc(RetNo: integer; PRV: String): String;
begin
  Result := '';
  If PRV = 'NL' then
    Result := FetchElm(RetNo, 'T2203', 8)
  else If PRV = 'PE' then
    Result := FetchElm(RetNo, 'T2203', 15)
  else If PRV = 'NS' then
    Result := FetchElm(RetNo, 'T2203', 22)
  else If PRV = 'NB' then
    Result := FetchElm(RetNo, 'T2203', 29)
  else If PRV = 'QC' then
    Result := FetchElm(RetNo, 'T2203', 36)
  else If PRV = 'ON' then
    Result := FetchElm(RetNo, 'T2203', 43)
  else If PRV = 'MB' then
    Result := FetchElm(RetNo, 'T2203', 50)
  else If PRV = 'SK' then
    Result := FetchElm(RetNo, 'T2203', 57)
  else If PRV = 'AB' then
    Result := FetchElm(RetNo, 'T2203', 64)
  else If PRV = 'BC' then
    Result := FetchElm(RetNo, 'T2203', 71)
  else If PRV = 'YT' then
    Result := FetchElm(RetNo, 'T2203', 78)
  else If PRV = 'NT' then
    Result := FetchElm(RetNo, 'T2203', 85)
  else If PRV = 'NU' then
    Result := FetchElm(RetNo, 'T2203', 106)
  else If PRV = 'ZZ' then
    Result := FetchElm(RetNo, 'T2203', 92);
end;

Procedure RefreshDependAddresses(RetNo: integer);
Var
  i, DependFNo: integer;
begin
  DependFNo := GetFormNo('DEPEND');
  i := 14;
  Repeat
    // 20170224 Igor >>>
    If (FetchElmFNo(RetNo, DependFNo, i) > '') or
      (FetchElmFNo(RetNo, DependFNo, i + 1) > '') or
      (FetchElmFNo(RetNo, DependFNo, i + 3) > '') or
      (FetchElmFNo(RetNo, DependFNo, i + 4) > '') then
    // 20170224 Igor <<<
    begin
      StoreElm(RetNo, DependFNo, i, FetchElm(RetNo, 'INFO', 6));
      StoreElm(RetNo, DependFNo, i + 1, FetchElm(RetNo, 'INFO', 10));
      StoreElm(RetNo, DependFNo, i + 3, FetchElm(RetNo, 'INFO', 14));
      StoreElm(RetNo, DependFNo, i + 4, FetchElm(RetNo, 'INFO', 15));
    end;
    inc(i, 15);
  until i > 134;
end;

Procedure RefreshSpouseAddresses(RetNo: integer);
Var
  i, FNo, SpRetNo: integer;
begin
  SpRetNo := GetSpRetNo(RetNo);
  FNo := GetFormNo('INFO');
  If (Ret[RetNo].CouplingSw) and (SpRetNo > 0) then
  begin
    StoreElm(RetNo, FNo, 6, FetchElmFNo(SpRetNo, FNo, 6));
    StoreElm(RetNo, FNo, 22, FetchElmFNo(SpRetNo, FNo, 22));
    StoreElm(RetNo, FNo, 68, FetchElmFNo(SpRetNo, FNo, 68));
    StoreElm(RetNo, FNo, 10, FetchElmFNo(SpRetNo, FNo, 10));
    StoreElm(RetNo, FNo, 14, FetchElmFNo(SpRetNo, FNo, 14));
    StoreElm(RetNo, FNo, 15, FetchElmFNo(SpRetNo, FNo, 15));
    StoreElm(RetNo, FNo, 163, FetchElmFNo(SpRetNo, FNo, 163));
  end;

end;

Procedure GetPOBoxAndRRFromDisk(RetNo: integer; Var Val1: String;
  Var Val2: String; FullFlName: String);
Var
  TempList: TStringList;
  Val3, Val4: String;
begin
  Val1 := '';
  Val2 := '';
  Val3 := '';
  Val4 := '';
  If not FileExists(FullFlName) then
  begin
    // ShowMessage('Cannot locate last year'+Chr(39)+'s file or directory');
    Exit;
  end;
  TempList := TStringList.Create;
  TempList.LoadFromFile(FullFlName);
  ReadTheValue(TempList, 'INFO', 68, 163, Val1, Val2);

  TempList.Free;
end;

Procedure GetT12002CNIL(RetNo: integer; Var Val1: String; Var Val2: String;
  FullFlName: String);
Var
  TempList: TStringList;
  Val3, Val4: String;
begin
  Val1 := '';
  Val2 := '';
  Val3 := '';
  Val4 := '';
  If not FileExists(FullFlName) then
  begin
    // ShowMessage('Cannot locate last year'+Chr(39)+'s file or directory');
    Exit;
  end;
  TempList := TStringList.Create;
  TempList.LoadFromFile(FullFlName);
  // from 2001
  ReadTheValue(TempList, 'CFR', 29, 30, Val1, Val2);
  // incurred in 2002
  // TempList.Clear;  TempList.LoadFromFile(FullFlName);
  ReadTheValue(TempList, 'T936', 9, 17, Val3, Val4);
  // full c/f
  FormatSettings.DecimalSeparator := '.'; // 20150727
  Val1 := FormatFloat('#######.##', VL(Val1) + VL(Val3));
  Val2 := FormatFloat('#######.##', VL(Val2) + VL(Val4));
  // ShowMessage(FullflName+ ' '+Val1+' '+Val2);
  TempList.Free;
end;

Function Fetch2001ValueFromDisk(RetNo: integer; FName: String; elm: integer;
  TempList: TStringList): String;
Var
  i, j: integer;
  Rec: String;
  WList: TStringList; // templist has disk data
begin
  Result := '';
  WList := TStringList.Create;
  j := 0;
  For i := 1 to TempList.Count - 1 do
  begin
    Rec := TempList[i];
    ParseWords(Rec, Delimiter, WList);
    If (WList[0] = 'F') and (WList[1] = FName) then
    begin
      j := i + 1;
      Repeat
        Rec := TempList[j];
        ParseWords(Rec, Delimiter, WList);
        If (WList[0] = 'D') then
        begin
          If VL(WList[1]) = elm then
          begin
            Result := WList[2];
            // Templist.Free;
            WList.Free;
            Exit;
          end;
        end;
        inc(j);
      until (j > TempList.Count - 1) or (LeftStr(Rec, 2) = 'F' + Delimiter);
      { end form data }
    end; { within form nm }
  end; { i }
  WList.Free;
end;

Function FetchLastYearValueFromDisk(RetNo: integer; FName: String;
  elm: integer): String;
Var
  i, j: integer;
  Rec: String;
  FullFlName: String;
  TempList, WList: TStringList;
begin
  Result := '';
  FullFlName := OptRec.Dir_LastYr + '\' + LeftStr(GetSinNo(RetNo), 8) + '.' +
    RightStr(GetSinNo(RetNo), 1);

  If not FileExists(FullFlName) then
  begin
    ShowMessage('Cannot locate last year' + Chr(39) + 's file or directory');
    Exit;
  end;
  TempList := TStringList.Create;
  WList := TStringList.Create;
  TempList.LoadFromFile(FullFlName);
  For i := 1 to TempList.Count - 1 do
  begin
    Rec := TempList[i];
    ParseWords(Rec, Delimiter, WList);
    If (WList[0] = 'F') and (WList[1] = FName) then
    begin
      j := i + 1;
      Repeat
        Rec := TempList[j];
        ParseWords(Rec, Delimiter, WList);
        If (WList[0] = 'D') then
        begin
          If VL(WList[1]) = elm then
          begin
            Result := WList[2];
            TempList.Free;
            WList.Free;
            Exit;
          end;
        end;
        inc(j);
      until (j > TempList.Count - 1) or (LeftStr(Rec, 2) = 'F' + Delimiter);
      { end form data }
    end; { within form nm }
  end; { i }
  TempList.Free;
  WList.Free;
end;

Procedure ReadTheValue(TempList: TStringList; FrmNm: String;
  Elm1, Elm2: integer; Var Val1: String; Var Val2: String);
{ templist is the tax return data }
Var
  i, j: integer;
  WList: TStringList;
  Rec: String;
begin
  Val1 := '';
  Val2 := '';
  WList := TStringList.Create;
  For i := 1 to TempList.Count - 2 do // -2 otherwise it abends
  begin
    Rec := TempList[i];
    ParseWords(Rec, Delimiter, WList);
    If (WList[0] = 'F') and (WList[1] = FrmNm) then
    begin
      j := i + 1;
      Repeat
        Rec := TempList[j];
        ParseWords(Rec, Delimiter, WList);
        If (WList[0] = 'D') then
        begin
          If VL(WList[1]) = Elm1 then
            Val1 := WList[2];
          If VL(WList[1]) = Elm2 then
            Val2 := WList[2];
        end;
        inc(j);
      until (j > TempList.Count - 2) or (LeftStr(Rec, 2) = 'F' + Delimiter);
      { end form data }
    end; { within form nm }
  end; { i }
  WList.Free;
end;

Function IsNonResWithCanEmpl(RetNo: integer): Boolean; // NOT used? ???
begin
  Result := false;
  If (Ret[RetNo].Province = 'ZZ') and
    (UpperCase(LeftStr(FetchElm(RetNo, 'INFO', 70), 7)) = 'NR-EMPL') then
    Result := true;
end;

Function EmplIncInProv(RetNo: integer; PRV: String): Real; // NOT used? ???
Var
  i, FNo: integer;
  FrmNm: string; // [10];
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T4' then
    begin
      FNo := GetFormNo(FRec.FormName + FRec.FormInst);
      If FetchElmFNo(RetNo, FNo, 20) = PRV then
        Result := Result + VL(FetchElmFNo(RetNo, FNo, 2));
    end;
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

Function IsEFiledReturn(RetNo: integer): Boolean;
begin
  Result := false;
  If UpperCase(FetchElm(RetNo, 'INFO', 46)) = 'X' then
    Result := true;
end;

Function ThereIsNetCapLossThisYear(RetNo: integer): Boolean;
begin
  Result := false;
  If VL(FetchElm(RetNo, 'S3', 339)) < 0 then  Result := true; //20250411
  //If VL(FetchElm(RetNo, 'S3', 97)) < 0 then  Result := true;
end;

Function NetCapLossCarryBackClaimed(RetNo: integer): Boolean;
begin
  Result := false;
  If VL(FetchElm(RetNo, 'T1A', 121)) + VL(FetchElm(RetNo, 'T1A', 123)) +
    VL(FetchElm(RetNo, 'T1A', 125)) > 0 then
    Result := true;
end;

Procedure ConvertOldAutoExpDates(RetNo, FNo: integer);
Var
  Dt: String;
begin
  // for existing data with dates entered as dd-mm-yyyy
  Dt := FetchElmFNo(RetNo, FNo, 57);
  If (Length(Dt) = 10) and (MidStr(Dt, 3, 1) = '-') and (MidStr(Dt, 6, 1) = '-')
  then
  begin
    Dt := DMYtoYMD(Dt); // Dt:=DateFromDDMMYYYtoYYYYMMDD(Dt);
    StoreElm(RetNo, FNo, 57, Dt);
  end;

  Dt := FetchElmFNo(RetNo, FNo, 60);
  If (Length(Dt) = 10) and (MidStr(Dt, 3, 1) = '-') and (MidStr(Dt, 6, 1) = '-')
  then
  begin
    Dt := DMYtoYMD(Dt); // DateFromDDMMYYYtoYYYYMMDD(Dt);
    StoreElm(RetNo, FNo, 60, Dt);
  end;
end;

Function GetMotorPercent(RetNo: integer; FNo: integer): Real;
// FNo came from T777
Var
  x, Y: Real;
begin
  x := VL(FetchElmFNo(RetNo, FNo, 25));
  Y := VL(FetchElmFNo(RetNo, FNo, 26));
  If Y = 0 then
    Result := 0
  else
    Result := x / Y;
end;

Procedure InitMostRecentFiles(HowMany: integer);
// 20171201 Igor>>>
var
  i: integer;
  S: string;
  TempList: TStringList;
  ADConnection: TADConnection;
  AQuery: TADQuery;
begin
  TempList := TStringList.Create;
  try
    try
      ADConnection := TADConnection.Create(Application);
      AQuery := TADQuery.Create(Application);
      try
        SqlLoadDBFromFile(ADConnection, AQuery, OptRec.Dir_Cur + '\' +
          ClientsDBLite, '');
        if ADConnection.Connected then
        begin
          with AQuery do
          begin
            SQL.Add('Select * from ' + ClientsTableLite);
            SQL.Add(' ORDER BY Updated_Dt DESC');
            Prepare;
            Open;
            First;
            while not EOF do
            begin
              // 20200914 Igor >>>
              S := AllTrim(AQuery.FieldByName('First_Name').AsString) + ' ' +
                AllTrim(AQuery.FieldByName('Last_Name').AsString) + RecentDelim
                + AQuery.FieldByName('Updated_Dt').AsString + RecentDelim +
                AQuery.FieldByName('Updated_tm').AsString + RecentDelim +
                AQuery.FieldByName('File_Name').AsString + RecentDelim;
              // 20200914 Igor ,,,
              TempList.Add(S);
              if TempList.Count > HowMany then
                Break;
              Next;
            end
          end;
        end;
      finally
        AQuery.Close;
        AQuery.Free;
        ADConnection.Free;
      end;
    except
      on E: Exception do
        ExceptMsg(E);
    end; // except
    for i := 0 to TempList.Count - 1 do
      TempList[i] := TempList[i] + ' ' + OptRec.Dir_Cur; // add the dir
    TempList.SaveToFile(AppDir + '\' + RecentRFlName);
  finally
    TempList.Free;
  end;
  // 20171201 Igor<<<
end;

(*
  Procedure InitMostRecentFiles(HowMany:Integer);
  Var i:Integer;
  s,WhereClause:String;
  TempList:TStringList;
  ADConnection: TADConnection;
  AQuery:TADQuery;
  begin
  TempList:=TStringList.Create;
  Try

  //20150916 Igor
  ADConnection:= TADConnection.Create(Application);
  AQuery:= TADQuery.Create(Application);
  SqlLoadDBFromFile(ADConnection, AQuery, OptRec.Dir_Cur + '\' + ClientsDBLite, '');

  WhereClause := '';
  {------------}
  With  AQuery do
  begin
  ADConnection.Connected := True;//20160119 Igor
  SQL.Add('Select * from '+ClientsTableLite); //20150923 Igor
  //SQL.Add( WhereClause);
  Sql.Add(' ORDER BY Updated_Dt DESC');
  Prepare;
  open;

  i:=1;
  First;
  Repeat
  s:=PaddR(AllTrim(Aquery.FieldByName('First_Name').AsString)+' '
  +AllTrim(AQuery.FieldByName('Last_Name').AsString),30)+' '
  +PaddR(Aquery.FieldByName('Updated_Dt').AsString,10)+' '
  +PAddR(Aquery.FieldByName('Updated_tm').AsString,10)+' '
  +PAddR(Aquery.FieldByName('File_Name').AsString,15);

  TempList.Add(s);
  If TempList.Count>HowMany then break;
  Next;
  until Eof;
  AQuery.Close;
  AQuery.Free;
  ADConnection.Free;
  end;
  except on e: Exception do ExceptMsg(e);
  //on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
  end; //except
  For i:=0 to TempList.Count-1 do
  TempList[i]:=TempList[i]+' '+OptRec.Dir_Cur;  //add the dir
  TempList.SaveToFile(AppDir+'\'+RecentRFlName);
  TempList.Free;
  end;
*)

procedure ConvertMostRecentFiles; // 20200914 Igor
var
  L: TStringList;
  i: integer;
  cRow, cName, cDate, cTime, cFile, cDir: string;
  NeedSave: Boolean;
begin
  if not FileExists(AppDir + '\' + RecentRFlName) then
    Exit;
  NeedSave := false;
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
      NeedSave := true;
    end;
    if NeedSave then
      L.SaveToFile(AppDir + '\' + RecentRFlName);
  finally
    L.Free;
  end;
end;

Procedure UpdateMostRecentFiles(RetNo: integer; Dir, FlName, Sin: String);
Var
  i, k, MaxReturns: integer;
  TempList1, TempList2: TStringList;
  S: String;
Begin
  // 20190507 Igor >>>
  if CheckIsCloud(true) and IsCloudStorageEnabled then
  begin
    if not Assigned(MainFormT1) then
      Exit;
    MainFormT1.UpdateMostRecentFilesCloud(RetNo, FlName);
    MainFormT1.ShowMostRecentReturns;
    Exit;
  end;
  // 20190507 Igor <<<
  TempList1 := TStringList.Create;
  TempList2 := TStringList.Create;
  If FileExists(AppDir + '\' + RecentRFlName) then
    TempList1.LoadFromFile(AppDir + '\' + RecentRFlName);
  // 20200914 Igor >>>
  S := AllTrim(GetFirstName(RetNo)) + ' ' + AllTrim(GetLastName(RetNo)) +
    RecentDelim + FormatDateTime('yyyy-mm-dd', Date) + RecentDelim +
    TimeToStr(Time) + RecentDelim + FlName + RecentDelim + Dir;
  // 20200914 Igor <<<
  // First remove it if it exists
  k := IsInMostRecentReturns(FlName, TempList1);
  If k > -1 then
    TempList1.Delete(k);
  // then add it as first
  TempList2.Add(S);
  // add the existing ones
  MaxReturns := TempList1.Count - 1;
  If MaxReturns > 30 then
    MaxReturns := 30;
  For i := 0 to MaxReturns do
    TempList2.Add(TempList1[i]);
  // save it
  TempList2.SaveToFile(AppDir + '\' + RecentRFlName);
  TempList1.Free;
  TempList2.Free;
  if Assigned(MainFormT1) then // 20160531 Igor
    MainFormT1.ShowMostRecentReturns; // updates the main menu
end;

Function IsInMostRecentReturns(FlName: String;
  MostRecentList: TStringList): integer;
var
  i, LengthOfKeyWord: integer;
  A: TArray<string>; // 20200914 Igor
begin
  Result := -1;
  If MostRecentList.Count = 0 then
    Exit;
  FlName := AllTrim(FlName);
  // 20200914 Igor >>>
  For i := 0 to MostRecentList.Count - 1 do
  begin
    A := MostRecentList[i].Split([RecentDelim]);
    if Length(A) >= 4 then
      if SameText(FlName, A[3]) then
      begin
        Result := i;
        Exit;
      end;
  end;
  // 20200914 Igor <<<
end;

Function FillLeftZeros(S: String; MaxLength: integer): string;
begin
  S := LTrim(RTrim(S));
  Result := FilledStr(PaddCount(S, MaxLength), '0') + S;
end;

Function AdvanceYearEnd(ThisYearEnd: String): String;
Var
  k: integer;
  YYYY, MM, DD: String;
begin
  k := MyStrToInt(LeftStr(ThisYearEnd, 4)) + 1;
  Result := IntToStr(k) + MidStr(ThisYearEnd, 5, 6);
  YYYY := LeftStr(Result, 4);
  MM := MidStr(Result, 6, 2);
  DD := RightStr(Result, 2);

  If (not IsLeapYear(MyStrToInt(YYYY))) and (MM = '02') and (DD = '29') then
    Result := LeftStr(Result, 4) + '-02-28';
end;

Function GetFileExtension(FlName: String): String;
begin
  Result := ExtractFileExt(FlName);
  Result := MidStr(Result, 2, 3);
end;

procedure GetDataFromDiskViaFrmDict(FullFlName: String; FrmNm: String;
  Var FileValuesList: TStringList);
// all file data put on fileValues list as nnn xxxxxx (elm and data)
var
  i: integer;
  DataList: TStringList;
begin
  DataList := TStringList.Create;
  DataList.LoadFromFile(FullFlName); // the data of a tax file: F,ggg,fff etc
  GetFrmDict(ExtractNonInstFormName(FrmNm), Frmdict);
  // returns FRmDict ,extracts this frm portion: Frmnm Elm Descr
  PutValuesInFrmDict(FrmNm, DataList, Frmdict);
  // returns the populated frmDict
end;

Procedure PutValuesInElmList(FrmNm: String; DataList: TStringList;
  Var ElmList: TStringList);
// DataList is the tax return data, Returns populated ElmList nnn  value
Var
  i, j, k, ElmNo: integer;
  WList: TStringList;
  Rec: String;
begin
  If ElmList.Count < 1 then
    Exit;
  Try
    If LeftStr(DataList[0], 2) <> 'T1' then
      Exit;

    WList := TStringList.Create;
    try
      For i := 1 to DataList.Count - 1 do
      begin
        Rec := DataList[i];
        ParseWords(Rec, Delimiter, WList);
        If (WList[0] = 'F') and (WList[1] = FrmNm) then // found form record
        begin
          j := i + 1;
          Repeat
            Rec := DataList[j];
            ParseWords(Rec, Delimiter, WList);
            If (WList[0] = 'D') then // wlist[2] has the actual data
            begin
              For k := 0 to ElmList.Count - 1 do
              begin
                ElmNo := MyStrToInt(MidStr(ElmList[k], 1, 3));
                If VL(WList[1]) = ElmNo then
                  ElmList[k] := PaddR(ElmList[k], 4) + ' ' + WList[2];
              end;
            end; // end detail rec
            inc(j);
          until (j > DataList.Count - 1) or (LeftStr(Rec, 2) = 'F' + Delimiter);
          { end form data }
        end; { within form nm }
      end; { i }
    finally
      WList.Free;
    end;
  Except
    on E: Exception do
      ExceptMsg(E);
  end;
end;

Function GetLastYearValue(ElmNo: integer; FrmDataList: TStringList): String;
Var
  i: integer;
  Rec: string;
  WList: TStringList;
begin
  Result := '';
  WList := TStringList.Create;
  For i := 0 to FrmDataList.Count - 1 do
  begin
    Rec := FrmDataList[i];
    ParseWords(Rec + Delimiter, Delimiter, WList);
    If ElmNo = VL(WList[1]) then
    begin
      Result := AllTrim(WList[2]);
      WList.Free;
      Exit;
    end; // found
  end; // i list of data
  WList.Free;
end;

Procedure GetFrmDataListFromFullDataList(FrmNm: String; DataList: TStringList;
  Var FrmDataList: TStringList);
// data list is image of disk file
Var
  i, j, ElmNo: integer;
  WList: TStringList;
  Rec: String;
begin
  Try
    j := 0;
    FrmDataList.Clear;
    If LeftStr(DataList[0], 2) <> 'T1' then
      Exit;
    WList := TStringList.Create;
    For i := 1 to DataList.Count - 1 do
    begin
      Rec := DataList[i];
      ParseWords(Rec + Delimiter, Delimiter, WList);
      If (WList[0] = 'F') and (WList[1] = FrmNm) then // found frm record
      begin
        // j:=i+1;
        For j := i + 1 to DataList.Count - 1 do
        begin
          Rec := DataList[j];
          ParseWords(Rec + Delimiter, Delimiter, WList);
          If LeftStr(Rec, 2) = 'F' + Delimiter then
            Exit;
          If (WList[0] = 'D') then
            FrmDataList.Add(Rec);
        end;

      end; // frm found
    end; // i
  except
    on E: Exception do
    begin
      ExceptMsg(E);
      ShowMessage(Rec);
    end;
  end; // try
end;

Procedure PutValuesInFrmDict(FrmNm: String; DataList: TStringList;
  Var Frmdict: TStringList);
// DataList is the tax return data, Returns populated frmDict
Var
  i, j, k, ElmNo: integer;
  WList: TStringList;
  Rec: String;
begin
  If Frmdict.Count < 1 then
    Exit;
  WList := TStringList.Create;
  For i := 1 to DataList.Count - 1 do
  begin
    Rec := DataList[i];
    ParseWords(Rec, Delimiter, WList);
    If (WList[0] = 'F') and (WList[1] = FrmNm) then // found form record
    begin
      j := i + 1;
      Repeat
        Rec := DataList[j];
        ParseWords(Rec, Delimiter, WList);
        If (WList[0] = 'D') then // wlist[2] has the actual data
        begin
          For k := 0 to Frmdict.Count - 1 do
          begin
            ElmNo := MyStrToInt(MidStr(Frmdict[k], 12, 3));
            If VL(WList[1]) = ElmNo then
              Frmdict[k] := PaddR(Frmdict[k], 65) + ' ' + WList[2];
          end;
        end; // end detail rec
        inc(j);
      until (j > DataList.Count - 1) or (LeftStr(Rec, 2) = 'F' + Delimiter);
      { end form data }
    end; { within form nm }
  end; { i }
  WList.Free;
end;

Function GetLastYearValueOfAForm(ElmNo: integer;
  FileValuesList: TStringList): String;
Var
  i: integer;
  ElmStr: String;
begin
  Result := '';
  ElmStr := PaddR(AllTrim(IntToStr(ElmNo)), 3);
  For i := 0 to FileValuesList.Count - 1 do
  begin
    If ElmStr = LeftStr(FileValuesList[i], 3) then
    begin
      Result := MidStr(FileValuesList[i], 5, 255);
      Exit;
    end;
  end;
end;

Procedure GetFrmDict(FormNm: String; Frmdict: TStringList);
// extract frpm frmDict the portion that belongs to FrmNm
// FrmDict receives FrmNm elm and description
Var
  i: integer;
  TempList: TStringList;
  S: String;
begin
  Frmdict.Clear;
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir + '\' + 'FrmDict.d');
  i := 0;
  Repeat
    S := AllTrim(UpperCase(LeftStr(TempList[i], 10)));
    If S = FormNm then
      Frmdict.Add(TempList[i]);
    inc(i);
  until i > TempList.Count - 1;
  TempList.Free;
end;

Procedure GetUsedFormsFromDisk(FullFlName: String);
Var
  i: integer;
  Rec: String;
  RetNo: integer;
  SQLite: TSQLiteStorage;
  F: TFileStorage;
  Var1, Var2, Var3, Var4: String;
begin
  RetNo := GetCurrentRetNo;
  Ret[RetNo].PreSelForms.Clear;

  if CheckReturnPsw(ExtractFileDir(FullFlName), ExtractFileName(FullFlName),
    AppT1_2026.SQLLitePassword.PassRFArray) <> iorReported then
    Exit;
  SQLite := TSQLiteStorage.Create(ExtractFileDir(FullFlName),
    ExtractFileName(FullFlName), fsRead,
    AppT1_2026.SQLLitePassword.PassRFArray);
  if SQLite.LastError <> '' then
  Begin
    FreeAndNil(SQLite);
    F := TFileStorage.Create(ExtractFileDir(FullFlName),
      ExtractFileName(FullFlName), fsRead);
  End
  else
    F := nil;
  While ReadNextLine(SQLite, Var1, Var2, Var3, Var4, F) do
  begin
    If (Var1 = 'F') then
    begin
      If (Var2 = 'T1') or (LeftStr(Var2, 5) = 'ON479_')
      // or (LeftStr(Var2, 3) = 'S1')  //20191220
      then
        { ignore }
      else
      begin
        Ret[RetNo].PreSelForms.Add(Var2);
        Ret[RetNo].PreSelSW := true;
      end;
    end;
  end; { i }
  if Assigned(F) then
    F.Free;
  if Assigned(SQLite) then
    FreeAndNil(SQLite);
  // DataList.Free;
  // WList.Free;

  // 20160819 Igor <<<
end;

Function PredictiveForm(Frm: String): Boolean;
Var
  i: integer;
  TempList: TStringList;
begin
  Result := false;
  if LicenseLevel in [llHome .. llStd] then
  Begin
    Frm := ExtractNonInstFormName(Frm);
    If (Frm = 'T5') or (Frm = 'T5MULT') or (Frm = 'S4') or (Frm = 'T3MULT') then
      Result := true;
    Exit;
  end;

  Frm := ExtractNonInstFormName(Frm);
  If (Frm = 'T3MULT') or (Frm = 'T4') or (Frm = 'T4A') or (Frm = 'T5') or
    (Frm = 'T5MULT') or (Frm = 'T4RSP') or (Frm = 'T4RIF') or (Frm = 'UNIOND')
    or (Frm = 'S4') or (Frm = 'INFO') or (Frm = 'DEPEND') or (Frm = 'DON') or
    (Frm = 'MEDICAL') or (Frm = 'RRSP') then
    Result := true;
end;

Function IsPredictiveRRSPField(FieldId: integer): Boolean;
begin
  Result := false;
  Case FieldId of
    9, 20, 24, 28, 32, 36:
      Result := true;
    43, 47, 51, 55, 59, 63:
      Result := true;
    79:
      Result := true;
  end;
end;

Function PredictMedPatientName(RetNo: integer; FrmNm: String; FldId: integer;
  OldString: String): String;
Var
  i: integer;
  TempList: TStringList;
  FNo: integer;
begin
  TempList := TStringList.Create;
  // self and spouse
  FNo := GetFormNo('INFO');
  If FetchElmFNo(RetNo, FNo, 2) > '' then
    TempList.Add(FetchElmFNo(RetNo, FNo, 2));
  If FetchElmFNo(RetNo, FNo, 20) > '' then
    TempList.Add(FetchElmFNo(RetNo, FNo, 20));

  // dependants
  FNo := GetFormNo('DEPEND');
  i := 5;
  Repeat
    If FetchElmFNo(RetNo, FNo, i) > '' then
      TempList.Add(FetchElmFNo(RetNo, FNo, i));
    inc(i, 15);
  until i > 125;

  // other names in medical
  FNo := GetFormNo('MEDICAL');
  i := 6;
  Repeat
    If FetchElmFNo(RetNo, FNo, i) > '' then
      TempList.Add(FetchElmFNo(RetNo, FNo, i));
    inc(i, 5);
  until i > 106;

  For i := 0 to TempList.Count - 1 do
  begin
    If UpperCase(OldString) = UpperCase(LeftStr(TempList[i], Length(OldString)))
    then
    Begin
      Result := TempList[i];
      TempList.Free;
      Exit;
    end
    else
      Result := '';
  end;
  TempList.Free;
end;

Function PredictMedDoctorName(RetNo: integer; FrmNm: String; FldId: integer;
  OldString: String): String;
Var
  i: integer;
  TempList, TList2: TStringList;
  FNo: integer;
begin
  TempList := TStringList.Create;
  TList2 := TStringList.Create;
  FNo := GetFormNo('MEDICAL');
  i := 7;
  Repeat
    If FetchElmFNo(RetNo, FNo, i) > '' then
      TempList.Add(FetchElmFNo(RetNo, FNo, i));
    inc(i, 5);
  until i > 107;
  TList2.LoadFromFile(AppDir + '\' + 'doctors.txt');
  For i := 0 to TList2.Count - 1 do
    TempList.Add(TList2[i]);

  For i := 0 to TempList.Count - 1 do
  begin
    If UpperCase(OldString) = UpperCase(LeftStr(TempList[i], Length(OldString)))
    then
    Begin
      Result := TempList[i];
      TempList.Free;
      Exit;
    end
    else
      Result := '';
  end;
  TempList.Free;
  TList2.Free;
end;

Function PredictMedExpenseName(RetNo: integer; FrmNm: String; FldId: integer;
  OldString: String): String;
Var
  i: integer;
  TempList, TList2: TStringList;
  FNo: integer;
begin
  TempList := TStringList.Create;
  TList2 := TStringList.Create;
  FNo := GetFormNo('MEDICAL');
  i := 8;
  Repeat
    If FetchElmFNo(RetNo, FNo, i) > '' then
      TempList.Add(FetchElmFNo(RetNo, FNo, i));
    inc(i, 5);
  until i > 108;

  TList2.LoadFromFile(AppDir + '\' + 'MedExp.txt');
  For i := 0 to TList2.Count - 1 do
    TempList.Add(TList2[i]);

  For i := 0 to TempList.Count - 1 do
  begin
    If UpperCase(OldString) = UpperCase(LeftStr(TempList[i], Length(OldString)))
    then
    Begin
      Result := TempList[i];
      TempList.Free;
      Exit;
    end
    else
      Result := '';
  end;
  TempList.Free;
  TList2.Free;
end;

Function PredictMedDates(RetNo: integer; FrmNm: String; FldId: integer;
  OldString: String): String;
Var
  i: integer;
  TempList: TStringList;
  FNo: integer;
begin
  TempList := TStringList.Create;
  FNo := GetFormNo('MEDICAL');
  i := 5;
  Repeat
    If FetchElmFNo(RetNo, FNo, i) > '' then
      TempList.Add(FetchElmFNo(RetNo, FNo, i));
    inc(i, 5);
  until i > 105;

  For i := 0 to TempList.Count - 1 do
  begin
    If UpperCase(OldString) = UpperCase(LeftStr(TempList[i], Length(OldString)))
    then
    Begin
      Result := TempList[i];
      TempList.Free;
      Exit;
    end
    else
      Result := '';
  end;
  TempList.Free;
end;

Function PredictCharityList(RetNo: integer; FrmNm: String; FldId: integer;
  OldString: String): String;
Var
  i: integer;
  TempList: TStringList;
  FNo: integer;
begin
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir + '\' + 'Charity.txt');
  For i := 0 to TempList.Count - 1 do
  begin
    If UpperCase(OldString) = UpperCase(LeftStr(TempList[i], Length(OldString)))
    then
    Begin
      Result := TempList[i];
      TempList.Free;
      Exit;
    end
    else
      Result := '';
  end;
  TempList.Free;
end;

Procedure BuildExperience(FrmNm: String; FromElm, ToElm, ByElm: integer;
  FlName: String; Var ElmList: TStringList; DataList: TStringList);
Var
  i, j: integer;
  S: String;
  TempList: TStringList;
begin
  Try
    TempList := TStringList.Create;
    try // 20170502 Igor
      ElmList.Clear;
      j := FromElm;
      Repeat
        ElmList.Add(FillLeftZeros(AllTrim(IntToStr(j)), 3));
        inc(j, ByElm);
      until j > ToElm;
      PutValuesInElmList(FrmNm, DataList, ElmList);
      TempList.LoadFromFile(AppDir + '\' + FlName);
      For j := 0 to ElmList.Count - 1 do
      begin
        S := MidStr(ElmList[j], 6, 255);
        If (S > '') and (IsStringInList(S, TempList) = -1) and (S <> '"') then
          TempList.Add(S);
      end;
      For i := 0 to TempList.Count - 1 do
      begin
        If UpperCase(FlName) = 'FIRSTNM.txt' then
          TempList[i] := UpperCase(TempList[i]);
      end;
      TempList.Sorted := true;
      TempList.SaveToFile(AppDir + '\' + FlName);
    finally // 20170502 Igor
      TempList.Free;
    end;
  Except
    on E: Exception do
      ExceptMsg(E);
  end;
end;

Procedure GetFormAndElmViaFrmDict(Frmdict: TStringList; FldName: String;
  Var FrmNm: String; Var ElmNo: integer);
Var
  i: integer;
  L: integer;
begin
  FrmNm := '';
  ElmNo := 0;
  For i := 0 to Frmdict.Count - 1 do
  begin
    L := Length(FldName);
    If FldName = MidStr(Frmdict[i], 16, L) then
    begin
      FrmNm := AllTrim(LeftStr(Frmdict[i], 11));
      ElmNo := MyStrToInt(MidStr(Frmdict[i], 12, 3));
      Exit;
    end; // found
  end; // i
end;

Function LineIsInCompList(LineNo: String; Comp2YrList: TStringList): integer;
// what lines to check in 2yr uconterr for super edit
Var
  i: integer;
begin
  Result := -1;
  For i := 0 to Comp2YrList.Count - 1 do
  begin
    If LineNo = MidStr(Comp2YrList[i], 45, 5) then // 20190709 Igor
    begin
      Result := i;
      Exit;
    end;
  end;
end;

Function MkFlNameFromSin(RetNo: integer): String;
begin
  Result := LeftStr(GetSinNo(RetNo), 8) + '.' + RightStr(GetSinNo(RetNo), 1);
end;

Function GetLastYearValueFromYRSum(LnNo: integer): String;
var
  i, RetNo, j, FNo, Lno: integer;
  TempList: TStringList;
begin
  Result := '';
  RetNo := GetCurrentRetNo;
  FNo := GetFormNo('YRSUM');
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir + '\' + 'YRSUM.D');
  i := 8;
  repeat
    j := IsInList(AddLeadingZeros(IntToStr(i), 3), TempList);
    // pos of elm in list
    Lno := MyStrToInt(MidStr(TempList[j], 5, 3));
    if Lno = LnNo then
    begin
      Result := FetchElmFNo(RetNo, FNo, i + 1); // prv yr value
      TempList.Free;
      Exit;
    end;
    inc(i, 5);
  until i > 208;

  i := 308;
  repeat
    j := IsInList(AddLeadingZeros(IntToStr(i), 3), TempList);
    // pos of elm in list
    Lno := MyStrToInt(MidStr(TempList[j], 5, 3));
    if Lno = LnNo then
    begin
      Result := FetchElmFNo(RetNo, FNo, i + 1); // prv yr value
      TempList.Free;
      Exit;
    end;
    inc(i, 5);
  until i > 483;

  i := 608;
  repeat
    j := IsInList(AddLeadingZeros(IntToStr(i), 3), TempList);
    // pos of elm in list
    Lno := MyStrToInt(MidStr(TempList[j], 5, 3));
    if Lno = LnNo then
    begin
      Result := FetchElmFNo(RetNo, FNo, i + 1); // prv yr value
      TempList.Free;
      Exit;
    end;
    inc(i, 5);
  until i > 768; // i>743;   //20110322
  TempList.Free;
end;

Function GetLastYrLineNoValueFromDisk(LnNo: integer; FlName: String): String;
Var
  i, j: integer;
  k, FNo, SNo, BxNo: integer;
  F1: TextFile;
  Comma: string; // [1];
  Ndx: Array [1 .. 3] of word;
  S: string; // [16];
  InputLin, Var1, Var2, Var3, Var4: String;
begin
  Result := '';
  If FileExists(FlName) = false then
    Exit;

  AssignFile(F1, FlName);
  ReSet(F1);
  Readln(F1, InputLin);
  { Break up into variables }
  j := 0;
  for i := 1 to Length(InputLin) do
  begin
    if InputLin[i] = Delimiter then
    begin
      inc(j);
      Ndx[j] := i;
    end;
  end;
  Var1 := Copy(InputLin, 1, Ndx[1] - 1);
  Var2 := Copy(InputLin, Ndx[1] + 1, Ndx[2] - Ndx[1] - 1);
  Var3 := Copy(InputLin, Ndx[2] + 1, Ndx[3] - Ndx[2] - 1);
  Var4 := Copy(InputLin, Ndx[3] + 1, 255);
  If Var1 <> AppName then
  begin
    CloseFile(F1);
    Exit;
  end;

  While not EOF(F1) do
  begin
    Readln(F1, InputLin);
    { break it }
    j := 0;
    for i := 1 to Length(InputLin) do
    begin
      if InputLin[i] = Delimiter then
      begin
        inc(j);
        Ndx[j] := i;
      end;
    end;
    Var1 := Copy(InputLin, 1, Ndx[1] - 1);
    Var2 := Copy(InputLin, Ndx[1] + 1, Ndx[2] - Ndx[1] - 1);
    Var3 := Copy(InputLin, Ndx[2] + 1, Ndx[3] - Ndx[2] - 1);
    Var4 := Copy(InputLin, Ndx[3] + 1, 255);
    if Var1 = 'L' then
    begin
      If VL(Var2) = LnNo then
      begin
        Result := Var3;
        Exit;
      end;
    end;
  end;
  CloseFile(F1);
end;

Function IsProfileReturn(RetNo: integer): Boolean;
Begin
  Result := false;
  If FetchElm(RetNo, 'STATUS', 5) = 'CONV-PROF' then
    Result := true;
end;

Function IsCanTaxReturn(RetNo: integer): Boolean;
Begin
  Result := false;
  If FetchElm(RetNo, 'STATUS', 5) = 'CONV-CTAX' then
    Result := true;
end;

Function GetValueFromInternet(url: String; Parameter: String): String;
Var
  i, j, k, L: integer;
  h: THandle;
  FlName: String;
  TempList: TStringList;
  TempString: array [0 .. 79] of char;
  // 20150727 NMHTTP1 : TNMHTTP;
  Memo1: TMemo;
begin
  Result := '';
  // 20150727 NMHTTP1 := TNMHTTP.Create(Application);
  Memo1 := TMemo.Create(Application);
  // 20150727 NMHTTP1.Get(Url);
  // 20150727 Memo1.Text := NMHTTP1.Body;
  Memo1.lines.SaveToFile(AppDir + 'Temp.htm');
  Memo1.Free;
  { If NMHTTP1.CookieIn <> '' then
    ShowMessage('Cookie:'+#13#10+NMHTTP1.CookieIn); }
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir + 'Temp.htm');
  For i := 0 to TempList.Count - 1 do
  begin
    If GetPositionOfSubstring(Parameter, TempList[i]) > 0 then
    begin
      { ShowMessage(TempList[i]); }
      for j := i to i + 3 do
      begin
        k := GetPositionOfSubstring('$', TempList[j]);
        If k > 0 then
        begin
          // ShowMessage(TempList[j]);
          Result := MidStr(TempList[j], k + 1, 10);
          For L := 1 to 10 do
          begin
            If Result[L] = '<' then
              Result := LeftStr(Result, L - 1);
          end;
          // 20150727 NMHTTP1.Free;
          TempList.Free;
          Exit;
        end; // found keyword
      end; // checked 3 lines for $
    end; // found parameter
  end; // i
  // 20150727 NMHTTP1.Free;
  TempList.Free;
end;

Function GetPositionOfSubstring(ss, S: String): integer;
begin
  Result := Pos(UpperCase(ss), UpperCase(S));
end;

Function GetProfileFldName(S: String; ClientOrSpouse: String): String;
Var
  WList: TStringList;
begin
  If (AllTrim(S) = '') or (LeftStr(AllTrim(S), 2) = '//') then
  begin
    Result := '';
    Exit;
  end;
  WList := TStringList.Create;
  ParseWords(S, '=', WList);
  Result := WList[0];
  // If ClientOrSpouse='S' then Result:='Spouse.'+Result;
  WList.Free;
end;

Procedure GetElmListFromCompFrmRec(Rec: String; Var ElmList: TStringList);
Var
  i, j: integer;
  WList: TStringList;
  PosOfDash: integer;
  FromElm, ToElm: integer;
begin
  ElmList.Clear;
  WList := TStringList.Create;
  ParseWords(Rec, ',', WList);
  For i := 0 to WList.Count - 1 do
  begin
    PosOfDash := Pos('-', WList[i]);
    If PosOfDash > 0 then
    begin
      FromElm := MyStrToInt(LeftStr(WList[i], PosOfDash - 1));
      ToElm := MyStrToInt(MidStr(WList[i], PosOfDash + 1, 3));
      For j := FromElm To ToElm do
        ElmList.Add(PaddR(AllTrim(IntToStr(j)), 3));
    end
    Else
    begin
      If WList[i] > '' then
        ElmList.Add(PaddR(WList[i], 3));
    end;
  end;
  WList.Free;
end;

Function MBSchoolCredit(RetNo: integer; FamilyIncome: Real): Real;
Var
  LowestFamilyIncome, HighestFamilyIncome, Range1, Range2: Real;
  NumIncrements: Real;
begin
  LowestFamilyIncome := 15100;
  HighestFamilyIncome := 23800;
  If FamilyIncome < LowestFamilyIncome then
  begin
    Result := 175;
    Exit;
  end;

  If FamilyIncome >= HighestFamilyIncome then
  begin
    Result := 0;
    Exit;
  end;
  Range1 := Trunc((FamilyIncome / 100)) * 100;
  Range2 := Range1 + 100;
  NumIncrements := MaxR(0, (Range2 - LowestFamilyIncome) / 100);
  Result := 175 - 2 * NumIncrements;
end;

Procedure GetDepentantsList(RetNo: integer; FName: string; FNo: integer);
Var
  i, j: integer;
  DepRec: TDepRec;
  DependId: String[3];
Begin
  // SomeList:=TStringList.Create; //20170512 Igor
  For i := 0 to 10 do
  Begin

  end;
  // GetDependantRec(RetNo:Integer;DependId:String;Var DepRec:TDepRec;DependFNo:Integer);
end;

Procedure GetDependantsList(RetNo: integer);
// into somelist
Var
  i, FNo: integer;
begin
  SomeList.Clear;
  FNo := GetFormNo('DEPEND');
  i := 5;
  repeat
    If FetchElmFNo(RetNo, FNo, i) > '' then
      SomeList.Add(PaddR(FetchElmFNo(RetNo, FNo, i), 15) // first nm
        + ' ' + PaddR(FetchElmFNo(RetNo, FNo, i + 1), 30) // last
        + ' ' + PaddR(FetchElmFNo(RetNo, FNo, i + 5), 10) // birthdate
        + ' ' + PaddR(FetchElmFNo(RetNo, FNo, i + 6), 15)); // Relationship
    i := i + 15;
  until i > 125;
end;

Procedure GetDependantsSINS(RetNo: integer);
// into somelist
Var
  i, FNo: integer;
begin
  SomeList.Clear;
  FNo := GetFormNo('DEPEND');
  i := 5;
  repeat
    If FetchElmFNo(RetNo, FNo, i) > '' then
      SomeList.Add(FetchElmFNo(RetNo, FNo, i + 2)); // SIN
    i := i + 15;
  until i > 125;
end;

Procedure GetDependantsNamesAndSINS(RetNo: integer);
// into somelist
Var
  i, FNo: integer;
begin
  SomeList.Clear;
  FNo := GetFormNo('DEPEND');
  i := 5;
  repeat
    If FetchElmFNo(RetNo, FNo, i) > '' then
      SomeList.Add(PaddR(FetchElmFNo(RetNo, FNo, i + 2), 10) // SIN
        + ' ' + PaddR(FetchElmFNo(RetNo, FNo, i), 15) // first nm
        + ' ' + PaddR(FetchElmFNo(RetNo, FNo, i + 1), 30) // last
        );
    i := i + 15;
  until i > 125;
end;

Function IsPatientFor330(RetNo: integer; DependId: String;
  DependFNo: integer): Boolean;
Var
  i: integer;
  IncomingDependNo, DepNo: integer;
begin
  Result := false;
  DependId := AllTrim(DependId);
  If (DependId = 'TP') or (DependId = 'SP1') or (DependId = 'SP2') then
  begin
    Result := true;
    Exit;
  end;
  // check dependants
  IncomingDependNo := MyStrToInt(RightStr(DependId, 1));
  i := 5;
  Repeat
    DepNo := Trunc(1 + i / 15);
    If DepNo = IncomingDependNo then
    begin
      // if relationship
      If ((FetchElmFNo(RetNo, DependFNo, i + 6) = 'Child') or
        (FetchElmFNo(RetNo, DependFNo, i + 6) = 'Son') or
        (FetchElmFNo(RetNo, DependFNo, i + 6) = 'Daughter') or
        (FetchElmFNo(RetNo, DependFNo, i + 6) = 'GrandChild')) and { birthdate }
        (CalcAge(FetchElmFNo(RetNo, DependFNo, i + 5)) < 18) // birthdate
      then
      begin
        Result := true;
        Exit;
      end;
    end;
    inc(i, 15);
  until i > 125;
end;

Procedure AccumMedical(RetNo: integer);
Var
  i, j, Ndx, MedicalFno, MedSuplFNo, DependFNo: integer;
  DependId: string; // [3];
begin
  MedicalFno := GetFormNo('MEDICAL');
  DependFNo := GetFormNo('DEPEND');
  // initialize accumulators
  MedSum330.PeriodPaid := 0;
  For i := 1 to 9 do
  begin
    MedSum331[i].DependId := '';
    MedSum331[i].PeriodPaid := 0;
  end;

  // Main medical
  i := 113;
  Repeat
    DependId := FetchElmFNo(RetNo, MedicalFno, i);
    If DependId > '' then
    begin
      If IsPatientFor330(RetNo, DependId, DependFNo) then
      begin
        MedSum330.PeriodPaid := MedSum330.PeriodPaid +
          VL(FetchElmFNo(RetNo, MedicalFno, 9 + (i - 113) * 5));
      end
      else
      begin
        Ndx := MyStrToInt(RightStr(DependId, 1));
        MedSum331[Ndx].DependId := DependId;
        MedSum331[Ndx].PeriodPaid := MedSum331[Ndx].PeriodPaid +
          VL(FetchElmFNo(RetNo, MedicalFno, 9 + (i - 113) * 5));
      end;
    end; // dependId>''
    inc(i);
  until i > 133;

  // medical supl
  for j := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[j];
    If (FRec.FormName = 'MEDSUPL') and (Ret[RetNo].FrmHasData[FRec.FormNo]) then
    // 20160813//20170324 Igor
    begin
      MedSuplFNo := FRec.FormNo;
      i := 133;
      Repeat
        DependId := FetchElmFNo(RetNo, MedSuplFNo, i);
        If DependId > '' then
        begin
          If IsPatientFor330(RetNo, DependId, DependFNo) then
          begin
            MedSum330.PeriodPaid := MedSum330.PeriodPaid +
              VL(FetchElmFNo(RetNo, MedSuplFNo, 9 + (i - 133) * 5));
          end
          else
          begin
            Ndx := MyStrToInt(RightStr(DependId, 1));
            MedSum331[Ndx].DependId := DependId;
            MedSum331[Ndx].PeriodPaid := MedSum331[Ndx].PeriodPaid +
              VL(FetchElmFNo(RetNo, MedSuplFNo, 9 + (i - 133) * 5));
          end;
        end; // pependId>''
        inc(i);
      until i > 153;
    end; // has data
  end; // j  flist
end;

Procedure AddPatientFor331(RetNo: integer; DependId: String;
  MedicalFno, DependFNo: integer; AmountPaid, AmountClaim: Real);
Var
  i, j, k: integer;
  IncomingDependNo, DepNo: integer;
  x: Real;
  DepRec: TDepRec;
begin
  FormatSettings.DecimalSeparator := '.'; // 20150727
  DependId := AllTrim(DependId); // i. DP2
  // check dependants
  IncomingDependNo := MyStrToInt(RightStr(DependId, 1)); // becomes 2
  i := 5;
  Repeat
    DepNo := Trunc(1 + i / 15);
    // convert i to number in dependants list i.e. 1 or 2 etc
    If DepNo = IncomingDependNo then
    begin
      k := GetPatientIndexIn331(RetNo, DependId, MedicalFno);
      If k > 0 then
      begin
        x := VL(FetchElmFNo(RetNo, MedicalFno, k + 6));
        x := x + AmountPaid;
        StoreElm(RetNo, MedicalFno, k + 6, FormatFloat('########.##', x));

        x := VL(FetchElmFNo(RetNo, MedicalFno, k + 7));
        x := x + AmountClaim;
        StoreElm(RetNo, MedicalFno, k + 7, FormatFloat('########.##', x));
      end
      else
      // add a new patient in section 331, new line
      begin
        k := GetEmptyIndexIn331(RetNo, MedicalFno);
        If k > 0 then
        begin
          GetDependantRec(RetNo, DependId, DepRec, DependFNo);
          StoreElm(RetNo, MedicalFno, k, DependId);
          StoreElm(RetNo, MedicalFno, k + 1, DepRec.FirstNm + ' ' +
            DepRec.LastNm);
          StoreElm(RetNo, MedicalFno, k + 2, DepRec.BirthDate);
          StoreElm(RetNo, MedicalFno, k + 3, DepRec.Relationship);
          StoreElm(RetNo, MedicalFno, k + 4, FormatFloat('########.##',
            DepRec.NetInc));
          StoreElm(RetNo, MedicalFno, k + 5, DepRec.Infirmity);
          StoreElm(RetNo, MedicalFno, k + 6, FormatFloat('########.##',
            AmountPaid));
          StoreElm(RetNo, MedicalFno, k + 7, FormatFloat('########.##',
            AmountClaim));
        end;
      end;
    end;
    inc(i, 15);
  until i > 125;
end;

{ procedure OneStepCom; }

Procedure GetDependantRec(RetNo: integer; DependId: String; Var DepRec: TDepRec;
  DependFNo: integer);
Var
  i, j, DepNo, IncomingDependNo: integer;
begin
  IncomingDependNo := MyStrToInt(RightStr(DependId, 1)); // DP2 to 2
  DepRec.Id := ''; // initialize, in case not found
  i := 5;
  j := 191; // caregiver claimed
  Repeat
    DepNo := Trunc(1 + i / 15);
    If DepNo = IncomingDependNo then
    begin
      DepRec.Id := DependId;
      DepRec.FirstNm := FetchElmFNo(RetNo, DependFNo, i);
      DepRec.LastNm := FetchElmFNo(RetNo, DependFNo, i + 1);
      DepRec.BirthDate := FetchElmFNo(RetNo, DependFNo, i + 5);
      DepRec.Sin := FetchElmFNo(RetNo, DependFNo, i + 2);
      DepRec.Relationship := FetchElmFNo(RetNo, DependFNo, i + 6);
      DepRec.Infirmity := FetchElmFNo(RetNo, DependFNo, i + 7);
      DepRec.CareGiver := FetchElmFNo(RetNo, DependFNo, j); // 20171209
      DepRec.NetInc := VL(FetchElmFNo(RetNo, DependFNo, i + 8));
      DepRec.Street := FetchElmFNo(RetNo, DependFNo, i + 9);
      DepRec.City := FetchElmFNo(RetNo, DependFNo, i + 10);
      DepRec.Prov := FetchElmFNo(RetNo, DependFNo, i + 12);
      DepRec.Postal := FetchElmFNo(RetNo, DependFNo, i + 13);
    end;
    inc(i, 15);
    inc(j, 1);
  until i > 125;
end;

Function GetPatientIndexIn331(RetNo: integer; DependId: String;
  MedicalFno: integer): integer;
Var
  i: integer;
begin
  Result := 0;
  i := 161;
  Repeat
    If FetchElmFNo(RetNo, MedicalFno, i) = DependId then
    begin
      Result := i;
      Exit;
    end;
    inc(i, 8);
  until i > 225;
end;

Function GetEmptyIndexIn331(RetNo, MedicalFno: integer): integer;
Var
  i: integer;
begin
  Result := 0;
  i := 161;
  Repeat
    If FetchElmFNo(RetNo, MedicalFno, i) = '' then
    begin
      Result := i;
      Exit;
    end;
    inc(i, 8);
  until i > 225;
end;

Procedure GetPatientsInfo(RetNo: integer);
// into somelist
Var
  i, k, FNo: integer;
begin
  FormatSettings.DecimalSeparator := '.'; // 20150727
  SomeList.Clear;
  FNo := GetFormNo('DEPEND');
  If Ret[RetNo].MarStatus < 3 then
  begin
    SomeList.Add('SP1 ' + GetFirstName(RetNo));
    SomeList.Add('SP2 ' + GetSpouseFirstName(RetNo));
  end
  else
    SomeList.Add('TP  ' + GetFirstName(RetNo));

  i := 5;
  k := 1;
  repeat
    If FetchElmFNo(RetNo, FNo, i) > '' then
      SomeList.Add('DP' + AllTrim(IntToStr(k)) // id
        + ' ' + PaddR(FetchElmFNo(RetNo, FNo, i), 15) // first nm
        + ' ' + PaddR(FetchElmFNo(RetNo, FNo, i + 1), 30) // last
        + ' ' + PaddR(FetchElmFNo(RetNo, FNo, i + 5), 10) // birthdate
        + ' ' + PaddR(FetchElmFNo(RetNo, FNo, i + 6), 15) // Relationship
        + ' ' + PaddR(FetchElmFNo(RetNo, FNo, i + 7), 15) // infirmity
        + ' ' + FormatFloat('#######.##', VL(FetchElmFNo(RetNo, FNo, i + 8))));
    // Net income
    i := i + 15;
    inc(k);
  until i > 125;
end;

Function GetEligibleDependantId(RetNo: integer): String;
// into somelist
Var
  i, k, FNo: integer;
begin
  Result := '';
  FormatSettings.DecimalSeparator := '.'; // 20150727
  FNo := GetFormNo('DEPEND');
  i := 5;
  k := 1;
  repeat
    If (FetchElmFNo(RetNo, FNo, i) > '') and
      (UpperCase(FetchElmFNo(RetNo, FNo, i + 14)) = 'Y') then
    Begin
      Result := 'DP' + AllTrim(IntToStr(k)); // id
      Exit;
    end;
    i := i + 15;
    inc(k);
  until i > 125;
end;

Procedure SetDependantIncomeForUCCB(RetNo: integer; Id: String; Amount: Real);
Var
  i, k, FNo: integer;
begin
  FormatSettings.DecimalSeparator := '.'; // 20150727
  FNo := GetFormNo('DEPEND');
  i := 5;
  k := 1;
  repeat
    If 'DP' + AllTrim(IntToStr(k)) = Id then
    Begin
      StoreElm(RetNo, FNo, i + 8, FormatFloat('#######.##', Amount));
      Exit;
    end;
    i := i + 15;
    inc(k);
  until i > 125;
end;

Function GetNetIncomeForDependantId(RetNo: integer; Id: String): Real;
// into somelist
Var
  i, k, FNo: integer;
begin
  Result := 0;
  FormatSettings.DecimalSeparator := '.'; // 20150727
  FNo := GetFormNo('DEPEND');
  i := 5;
  k := 1;
  repeat
    If 'DP' + AllTrim(IntToStr(k)) = Id then
    Begin
      Result := VL(FetchElmFNo(RetNo, FNo, i + 8));
      Exit;
    end;
    i := i + 15;
    inc(k);
  until i > 125;
end;

Function GetEligibleDependantNameFromId(RetNo: integer; Id: String): String;
// into somelist
Var
  i, k, FNo: integer;
begin
  Result := '';
  FormatSettings.DecimalSeparator := '.'; // 20150727
  FNo := GetFormNo('DEPEND');
  i := 5;
  k := 1;
  repeat
    If 'DP' + AllTrim(IntToStr(k)) = Id then
    Begin
      Result := FetchElmFNo(RetNo, FNo, i);
      Exit;
    end;
    i := i + 15;
    inc(k);
  until i > 125;
end;

Procedure GetKidsUnder6ForUCCB(RetNo: integer);
// into somelist
Var
  i, k, FNo: integer;
begin
  FormatSettings.DecimalSeparator := '.'; // 20150727
  SomeList.Clear;
  FNo := GetFormNo('DEPEND');
  i := 5;
  k := 1;
  repeat
    If FetchElmFNo(RetNo, FNo, i) > '' then
      SomeList.Add('DP' + AllTrim(IntToStr(k)) // id
        + ' ' + PaddR(FetchElmFNo(RetNo, FNo, i), 15) // first nm
        + ' ' + PaddR(FetchElmFNo(RetNo, FNo, i + 1), 30) // last
        + ' ' + PaddR(FetchElmFNo(RetNo, FNo, i + 5), 10) // birthdate
        + ' ' + PaddR(FetchElmFNo(RetNo, FNo, i + 6), 15) // Relationship
        + ' ' + PaddR(FetchElmFNo(RetNo, FNo, i + 7), 15) // infirmity
        + ' ' + FormatFloat('#######.##', VL(FetchElmFNo(RetNo, FNo, i + 8))));
    // Net income
    i := i + 15;
    inc(k);
  until i > 125;
end;

function MouseHasWheel: Boolean;
begin
  Result := Mouse.WheelPresent;
  { (GetSystemMetrics(SM_MOUSEWHEELPRESENT)<>0); }
end;

Procedure GetEOLParms(Var OnLineNo: String; Var Password: String;
  Var url: String; Var NetFileDir: String);
Var
  i: integer;
  TempList: TStringList;
  S: String;
begin
  TempList := TStringList.Create;
  For i := 0 to 4 do
    TempList.Add('');
  If FileExists(AppDir + '\' + 'EOL.TXT') then // 20160620 Igor
  begin
    TempList.LoadFromFile(AppDir + '\' + 'EOL.TXT'); // 20160620 Igor
    If TempList.Count < 4 then
    begin
      For i := TempList.Count to 3 do
        TempList.Add('');
    end;
    OnLineNo := UpperCase(TempList[0]);
    Password := TempList[1];
    url := TempList[2];
    NetFileDir := TempList[3];
  end
  else
  begin
    OnLineNo := '';
    Password := '';
    url := '';
    NetFileDir := '';
  end;
  TempList.Free;
end;

Function GetEOLAgentNo: String;
Var
  TempList: TStringList;
begin
  Result := '';
  TempList := TStringList.Create;
  If FileExists(AppDir + '\' + 'EOL.TXT') then // 20160620 Igor
  begin
    TempList.LoadFromFile(AppDir + '\' + 'EOL.TXT'); // 20160620 Igor
    Result := TempList[0];
  end;
  TempList.Free;
end;

Function GetEOLPAgentNo: String;
Var
  TempList: TStringList;
begin
  Result := '';
  TempList := TStringList.Create;
  If FileExists(AppDir + '\' + 'EOLP.TXT') then // 20160620 Igor
  begin
    TempList.LoadFromFile(AppDir + '\' + 'EOLP.TXT'); // 20160620 Igor
    Result := TempList[0];
  end;
  TempList.Free;
end;

Procedure GetEOLPParms(Var OnLineNo: String; Var TransmitterNo: String;
  Var Password: String; Var url: String; Var NetFileDir: String);
Var
  i: integer;
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  For i := 0 to 4 do
    TempList.Add('');
  If FileExists(AppDir + '\' + 'EOLP.TXT') then // 20160620 Igor
  begin
    TempList.LoadFromFile(AppDir + '\' + 'EOLP.TXT'); // 20160620 Igor
    If TempList.Count < 5 then
    begin
      For i := TempList.Count to 5 do
        TempList.Add('');
    end;
    OnLineNo := TempList[0];
    TransmitterNo := TempList[1];
    Password := TempList[2];
    url := TempList[3];
    NetFileDir := TempList[4];
  end
  else
  begin
    OnLineNo := '';
    TransmitterNo := '';
    Password := '';
    url := '';
    NetFileDir := '';
  end;
  TempList.Free;
end;

Function GetEolPNetFileDir: String;
Var
  i: integer;
  TempList: TStringList;
begin
  Result := '';
  TempList := TStringList.Create;
  If FileExists(AppDir + '\' + 'EOLP.TXT') then // 20160620 Igor
  begin
    TempList.LoadFromFile(AppDir + '\' + 'EOLP.TXT'); // 20160620 Igor
    If TempList.Count >= 4 then
      Result := TempList[4];
  end;
  TempList.Free;
end;

Procedure SaveEOLPParms(OnLineNo, TransmitterNo, Password, url,
  NetFileDir: String);
Var
  i: integer;
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  TempList.Add(OnLineNo);
  TempList.Add(TransmitterNo);
  TempList.Add(Password);
  TempList.Add(url);
  TempList.Add(NetFileDir);
  TempList.SaveToFile(AppDir + '\' + 'EOLP.TXT'); // 20160620 Igor
  TempList.Free;
end;

Procedure SaveEOLParms(OnLineNo, Password, url, NetFileDir: String);
Var
  i: integer;
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  TempList.Add(OnLineNo);
  TempList.Add(Password);
  TempList.Add(url);
  TempList.Add(NetFileDir);
  TempList.SaveToFile(AppDir + '\' + 'EOL.TXT'); // 20160620 Igor
  TempList.Free;
end;

Function GetDefaultNetFileDir: String;
begin
  Result := '';
  Try
    If Not SysUtils.DirectoryExists(AppDir + '\' + 'EolFiles') then
    begin
      CreateDir(AppDir + '\' + 'EolFiles');
      Result := AppDir + '\' + 'EolFiles';
    end
    else
      Result := AppDir + '\' + 'EolFiles';
  except
    ShowMessage('Unable to create Directory' + Chr(13) + AppDir + '\' +
      'EolFiles');
  end; { try }
end;

Function GetDefaultEolPNetFileDir: String;
begin
  Result := '';
  Try
    If Not SysUtils.DirectoryExists(AppDir + '\' + 'EolPFiles') then
    begin
      CreateDir(AppDir + '\' + 'EolPFiles');
      Result := AppDir + '\' + 'EolPFiles';
    end
    else
      Result := AppDir + '\' + 'EolPFiles';
  except
    ShowMessage('Unable to create Directory' + Chr(13) + AppDir + '\' +
      'EolPFiles');
  end; { try }
end;

// 20170223 Igor
// const Move to T1_2026_Declare
// PswElm = 17;
// c_LastYearElm = 32;

Procedure StoreReturnPsw(RetNo: integer; RetPsw: String);
begin
  StoreElm(RetNo, 'STATUS', PswElm, EncryptPsw(RetPsw, 9999));
end;

Procedure RemoveReturnPsw(RetNo: integer);
begin
  StoreElm(RetNo, 'STATUS', PswElm, '');
end;

Function FetchReturnPsw(RetNo: integer): String;
begin
  Result := DecryptPsw(FetchElm(RetNo, 'STATUS', PswElm), 9999);
end;

Function GetReturnPsw(DataDir, FlName: string; APwdArr: Variant): String;
// 20160415 Igor
begin
  GetFilePsw(DataDir, FlName, PswElm, Result, APwdArr); // 20160415 Igor
end;

function CheckReturnPsw(DataDir, FlName: string; APwdArr: Variant): integer;
// 20160415 Igor
begin
  Result := CheckFilePsw(DataDir, FlName, PswElm, APwdArr);
  // = iorReported; //20160415 Igor
end;

function CheckReturnAndPsw(DataDir, FlName: string; APwdArr: Variant): Boolean;
// 20160415 Igor
begin
  Result := CheckFileAndPsw(DataDir, FlName, PswElm, APwdArr); // 20160415 Igor
end;

Function GetEfMethod: String;
Var
  TempList: TStringList;
Begin
  Result := OptRec.Ef_Method;
end;

Function FetchEfMethod(RetNo: integer): String;
Begin
  Result := 'EOL';
  If FetchElm(RetNo, 'INFO', 77) > '' then
    Result := 'EOL'
  else If FetchElm(RetNo, 'INFO', 78) > '' then
    Result := 'EOLP';
  // else If FetchElm(RetNo,'INFO',79) >'' then Result:='PROP';
end;

Function ValidFirstLastName(S: String): Boolean;
Var
  i: integer;
begin
  Result := true;
  For i := 1 to Length(S) do
  begin
    If ((S[i] >= 'A') and (S[i] <= 'Z')) Or ((S[i] >= 'a') and (S[i] <= 'z')) or
      (S[i] = ' ') // space
      or (S[i] = '-') Or (S[i] = Chr(39)) // 20110814 //apostrophe
    then
      // ok
    Else
    begin
      Result := false;
      Exit;
    end;
  end;
end;

Function CalcCpp(TotalEarnings: Real): Real;
// cppprorate=1
Var
  x, Y, z: Real;
begin
  x := MinR(Constant[RY].MaxCppPensionableEarnings, TotalEarnings); // 20241121
  Y := Constant[RY].BasicCppExemption * 1; // CPPProrate;
  Result := MinR(Constant[RY].MaxCppEarnings * 1, MaxR(0, x - Y)) *
    Constant[RY].CPPRate;
end;

Function CalcEI(TotalEarnings: Real): Real;
Var
  x, Y, z: Real;
begin
  x := MinR(Constant[RY].MaxUIEarn52, TotalEarnings);
  If x < 2000 then
  begin
    Result := 0;
    Exit;
  end;
  Y := x * Constant[RY].UIRate;
  Result := MinR(Constant[RY].MaxUI52, Y);
end;

Function AmountForPrvMinTax(RetNo: integer): Real;
// Line 117 of T691 OR Line 108 minus line 111 of T691
begin
  { //remove it
    Result:=0;  //20250219   <<<===============================
    EXIT;
  }
  // ------------------------------
  If IsDeceased(RetNo) then
  Begin
    Result := 0;
  end;
  if SubjectToMinTax(RetNo) = false then
  begin
    Result := 0;
    Exit;
  end; // 20190217
  // ------------------------------

  // 20161217
  Result := VL(FetchElm(RetNo, 'T691', 314)); // line 117 of T691;

  if (Ret[RetNo].Province = 'MB') then // 20221224
    Result := MaxR(0, VL(FetchElm(RetNo, 'T691', 307)) -
      VL(FetchElm(RetNo, 'T691', 308))); // line 111 minus line 112+
  // Result := MaxR(0, VL(FetchElm(RetNo, 'T691', 307)) - VL(FetchElm(RetNo, 'T691', 304))); // line 111 minus line 112

  if (Ret[RetNo].Province = 'NB') then
    Result := MaxR(0, VL(FetchElm(RetNo, 'T691', 307)) -
      VL(FetchElm(RetNo, 'T691', 304))); // line 108 minus line 111

  if (Ret[RetNo].Province = 'AB') then
    Result := VL(FetchElm(RetNo, 'T691', 307)) - VL(FetchElm(RetNo, 'T691', 308)
      ); // 202200410 line 111 minus line 1125
  if (Ret[RetNo].Province = 'NS') then
    Result := VL(FetchElm(RetNo, 'T691', 316)); // 20190217
  if (Ret[RetNo].Province = 'PE') then
    Result := VL(FetchElm(RetNo, 'T691', 316)); // 20190217
  if (Ret[RetNo].Province = 'YT') then
    Result := VL(FetchElm(RetNo, 'T691', 316)); // 20190217
  if (Ret[RetNo].Province = 'NU') then
    Result := VL(FetchElm(RetNo, 'T691', 316)); // 20190217
  if (Ret[RetNo].Province = 'NT') then
    Result := VL(FetchElm(RetNo, 'T691', 316));
  if (Ret[RetNo].Province = 'SK') then
    Result := MaxR(0, VL(FetchElm(RetNo, 'T691', 307)) -
      VL(FetchElm(RetNo, 'T691', 308)));
end;

// 20170324
Function GetCampLimit(KidAge: integer; Weeks: integer; Infirm: String): Real;
begin
  Result := 0;
  If Weeks = 0 then
    Exit;
  // 20170323
  Infirm := UpperCase(Infirm);
  If (KidAge < 7) and (Infirm <> 'Y') then
  begin
    Result := 200 * Weeks; // result:=175 * Weeks;
    Exit;
  End;

  If ((KidAge > 6) and (KidAge < 17)) or (KidAge > 16) and (Infirm <> 'Y') then
  begin
    Result := 125 * Weeks; // result:=100 * Weeks;
    Exit;
  End;
  // all other ages
  If Infirm = 'Y' then
    Result := 275 * Weeks; // If Infirm='Y' then Result:=250*weeks;

end;

(*
  Function GetCampLimit(KidAge:Integer;Weeks:Integer;Infirm:String):Real;
  begin
  result:=0;
  If weeks=0 then exit;

  Infirm:=UpperCase(Infirm);
  If (KidAge <7) and (Infirm <> 'Y') then
  begin
  result:=175 * Weeks;
  Exit;
  End;

  If ((KidAge>6) and (KidAge <17))
  or (KidAge>16) and (Infirm<>'Y') then
  begin
  result:=100 * Weeks;
  Exit;
  End;
  //all other ages
  If Infirm='Y' then Result:=250*weeks;

  end;
*)

Procedure GetElmsInError(RetNo: integer; FName: String);
Var
  i: integer;
  AuditFName: String;
begin
  ElmsInError.Clear;
  FName := AllTrim(UpperCase(FName));
  // For i:=Low(Ret[RetNo].AuditRec) to High(Ret[RetNo].AuditRec) do
  For i := 0 to Ret[RetNo].AuditList.Count - 1 do
  begin
    AuditFName := AllTrim(UpperCase(Ret[RetNo].AuditRec[i].Form));
    If FName = AuditFName then
    begin
      ElmsInError.Add(IntToStr(Ret[RetNo].AuditRec[i].elm) + ' ' + Ret[RetNo]
        .AuditRec[i].Description);
    end;
  end;
end;

Function GetFieldErrorMsg(RetNo: integer; FName: String; elm: integer): String;
Var
  i: integer;
  AuditFName: String;
  AuditElm: integer;
begin
  Result := '';
  FName := AllTrim(UpperCase(FName));
  // For i:=Low(Ret[RetNo].AuditRec) to High(Ret[RetNo].AuditRec) do
  For i := 0 to Ret[RetNo].AuditList.Count - 1 do
  begin
    AuditFName := AllTrim(UpperCase(Ret[RetNo].AuditRec[i].Form));
    AuditElm := Ret[RetNo].AuditRec[i].elm;
    If (FName = AuditFName) and (elm = AuditElm) then
    begin
      Result := Ret[RetNo].AuditRec[i].Description;
      Exit;
    end;
  end;
end;

Function IsFieldInElmsInError(S: String; AList: TStringList): integer;
{ return item index of a given string }
Var
  i: integer;
begin
  Result := -1;
  S := PaddR(AllTrim(S), 3);
  For i := 0 to AList.Count - 1 do
    If S = PaddR(LeftStr(AList[i], 3), 3) then
    begin
      Result := i;
      Exit;
    end;
end;

Procedure LoadDirList(DirList: TStringList);
begin
  DirList.Clear;
  If FileExists(AppDir + '/' + 'Dirs.d') then
    DirList.LoadFromFile(AppDir + '/' + 'Dirs.d')
  else
  begin
    DirList.Add(' ');
    DirList.Add(' ');
    DirList.Add(' ');
    DirList.Add(' ');
    DirList.Add(' ');
  end;
end;

Function IsBuildingClass(CcaClass: String): Boolean;
begin
  Result := false;
  If (CcaClass = '1') or (CcaClass = '3') or (CcaClass = '6') then
    Result := true;
end;

Function IsAutosClass(CcaClass: String): Boolean;
begin
  Result := false;
  If (CcaClass = '10') or (CcaClass = '10.1') or (CcaClass = '54') or
    (CcaClass = '55') then
    Result := true;
end;

Procedure CreateSnapshot(RetNo: integer; BeforeOrAfter: String);
Var
  i, j, LnIdx: integer; // 20190709 Igor
  Ln, Amt, TempList, AdjLines: TStringList;
  S, SnapshotDir: String;
begin
  FormatSettings.DecimalSeparator := '.'; // 20150727
  SnapshotDir := AppDir + '\' + 'AdjSnapshots';
  Ln := TStringList.Create;
  Amt := TStringList.Create;
  TempList := TStringList.Create;

  AdjLines := TStringList.Create;
  AdjLines.LoadFromFile(AppDir + '\' + 'T1Adj.d');

  // 20190709 Igor >>>
  For i := 101 to 486 do
  begin
    LnIdx := ConvertOldToNewLn(i);
    If Ret[RetNo].Lnn[LnIdx] <> 0 then
    begin
      If (LnIdx <> 16700) and (LnIdx <> 16900) and (LnIdx <> 429) then // ???
      begin
        Ln.Add(IntToStr(LnIdx));
        Amt.Add(FormatFloat('########.##', Ret[RetNo].Lnn[LnIdx]));
      end;
    end;
  end;
  // 20190709 Igor <<<

  for i := 0 to Ln.Count - 1 do
  begin
    S := PaddR(Ln[i], 6) + ' ' + PaddR(Amt[i], 13);
    TempList.Add(S);
  end;

  If Not SysUtils.DirectoryExists(SnapshotDir) then
    SysUtils.ForceDirectories(SnapshotDir);
  If BeforeOrAfter = 'B' then
    TempList.SaveToFile(GetSnapShotFileName(RetNo))
    { SnapShotDir+'\'+GetSinNo(RetNo)+'-'
      +GetLastName(RetNo)+'-'+GetFirstName(RetNo)
      +'.'+'Bfr') }
  else
    TempList.SaveToFile(GetSnapShotFileName(RetNo));
  { SnapShotDir+'\'+GetSinNo(RetNo)+'-'
    +GetLastName(RetNo)+'-'+GetFirstName(RetNo)
    +'.'+'Aft'); }
  TempList.Free;
  Ln.Free;
  Amt.Free;
end;

Function GetSnapShotFileName(RetNo: integer): String;
Var
  SnapshotDir: String;
Begin
  SnapshotDir := AppDir + '\' + 'AdjSnapshots';
  Result := SnapshotDir + '\' + GetSinNo(RetNo) + '-' + GetLastName(RetNo) + '-'
    + GetFirstName(RetNo) + '.' + 'Bfr';
end;

Function GetPreAdjValue(RetNo: integer; LnNo: String;
  BeforeList: TStringList): Real;
Var
  k: integer;
begin
  Result := 0;
  If (AllTrim(LnNo) = '') or (BeforeList.Count = 0) then
    Exit;
  If not FileExists(GetSnapShotFileName(RetNo)) then
    Exit;
  k := IsInList(LnNo, BeforeList);
  If k >= 0 then
    Result := VL(AllTrim(MidStr(BeforeList[k], 8, 13)));
end;

Procedure GetT1AdjNetList(BeforeList, AfterList: TStringList;
  Var NetList: TStringList);
Var
  i, j: integer;
  Ln1, Ln2: integer;
  TempList: TStringList;
  PrevAmount, RevisedAmount: Real;
begin
  NetList.Clear;
  i := 0;
  j := 0;
  Repeat
    If i > BeforeList.Count - 1 then
      i := 9999;
    If j > AfterList.Count - 1 then
      j := 9999;
    If (i >= 9999) or (j >= 9999) then
      Break;
    Ln1 := MyStrToInt(AllTrim(LeftStr(BeforeList[i], 6)));
    Ln2 := MyStrToInt(AllTrim(LeftStr(AfterList[j], 6)));
    If Ln1 > Ln2 then // only in afterlist
    begin
      NetList.Add(Space(20) + AfterList[j]);
      inc(j);
    end
    else If Ln1 < Ln2 then // only in beforelist
    begin
      NetList.Add(BeforeList[i]);
      inc(i);
    end
    else If Ln1 = Ln2 then // in both
    begin
      NetList.Add(BeforeList[i] + ' ' + AfterList[j]);
      inc(i);
      inc(j);
    end;
  until (i >= 9999) or (j >= 9999);
  // process unfinished list
  If i >= 9999 then // only afterlist
  begin
    If j < 9999 then
    begin
      repeat
        NetList.Add(Space(20) + AfterList[j]);
        inc(j);
      until j > AfterList.Count - 1;
      j := 9999;
    end;
  end;
  If j >= 9999 then // only beforelist
  begin
    If i < 9999 then
    begin
      repeat
        NetList.Add(BeforeList[i]);
        inc(i);
      until i > BeforeList.Count - 1;
      i := 9999;
    end;
  end;

  // remove the equal
  TempList := TStringList.Create;
  i := 0;
  Repeat
    PrevAmount := VL(AllTrim(MidStr(NetList[i], 7, 13)));
    RevisedAmount := VL(AllTrim(MidStr(NetList[i], 27, 13)));
    If PrevAmount <> RevisedAmount then
      TempList.Add(NetList[i]);
    inc(i);
  until i > NetList.Count - 1;

  NetList.Clear;
  For i := 0 to TempList.Count - 1 do
    NetList.Add(TempList[i]);
  TempList.Free;
end;

Procedure NetListToT1Adj(RetNo: integer; FNo: integer; NetList: TStringList;
  FromNetListNdx: integer);
Var
  i, k, j: integer;
  Ln: String;
  PrevAmount, RevisedAmount: Real;
begin
  FormatSettings.DecimalSeparator := '.'; // 20150727
  i := 23; // ln ndx in form
  j := FromNetListNdx; // where to start on netlist
  Repeat
    Ln := AllTrim(LeftStr(NetList[j], 6));
    If Ln = '' then
      Ln := AllTrim(MidStr(NetList[j], 21, 6));
    PrevAmount := VL(AllTrim(MidStr(NetList[j], 7, 13)));
    RevisedAmount := VL(AllTrim(MidStr(NetList[j], 27, 13)));
    If PrevAmount <> RevisedAmount then
    begin
      StoreElm(RetNo, FNo, i, Ln);
      StoreElm(RetNo, FNo, i + 2, FormatFloat('########.##', PrevAmount));
      StoreElm(RetNo, FNo, i + 4, FormatFloat('########.##', RevisedAmount));
      StoreElm(RetNo, FNo, i + 3, FormatFloat('########.##',
        RevisedAmount - PrevAmount));
      inc(i, 5);
    end;
    inc(j, 1);
  until (i > 108) or (j > NetList.Count - 1);
end;

Function GetLineDescription(Ln: integer; LineList: TStringList): String;
Var
  i: integer;
begin
  Result := '';
  For i := 0 to LineList.Count - 1 do
  begin
   If MyStrToInt(AllTrim(MidStr(LineList[i], 45, 5))) = Ln then   //20250516
   // If MyStrToInt(AllTrim(MidStr(LineList[i], 45, 4))) = Ln then
      Result := AllTrim(LeftStr(LineList[i], 44));
  end;
end;

Function AnyDisabledDependant(RetNo: integer): Boolean;
Var
  i: integer;
begin
  Result := false;
  If Ret[RetNo].FormHasData['DEPEND'] = false then
    Exit;
  i := 5;
  Repeat
    If FetchElm(RetNo, 'DEPEND', i + 7) = 'Y' then // 20130223
    begin
      Result := true;
      Exit;
    end;
    inc(i, 15);
  until i > 125;
end;

Function IsKeyWAnAmount(KeyW: String): Boolean; // 202170410 Igor
Var
  i: integer;
begin
  With AppT1_2026.LoadDataDict do
    for i := 0 to (Count - 1) do
      If (KeyW = MidStr(Items[i].KeyWord, 1, 255)) AND
        (UpperCase(Items[i].Is_Amount) = 'Y') then
        Exit(true);
  Result := false; // in case not found
End;

Procedure GetKeyWAttributes(KeyW: String; Var FName: String; Var elm: integer;
  Var IsAmount: String); // 20170410 Igor
Var
  i: integer;
begin
  With AppT1_2026.LoadDataDict do
    for i := 0 to (Count - 1) do
      If KeyW = MidStr(Items[i].KeyWord, 1, 255) then
      begin
        FName := Items[i].FormName;
        elm := Items[i].Field_No;
        IsAmount := Items[i].Is_Amount;
        Exit;
      End;
  IsAmount := '';
End;

Function CountCarsInAssets(RetNo: integer; StatementFNo: integer): integer;
Var
  i: integer;
  k: integer;
begin
  i := 161;
  k := 0;
  Repeat
    If UpperCase(FetchElmFNo(RetNo, StatementFNo, i)) = 'Y' then
      inc(k);
    inc(i, 1);
  until i > 172;
  Result := k;
end;

Function CountOtherInAssets(RetNo: integer; StatementFNo: integer): integer;
Var
  i, ii: integer;
  k: integer;
begin
  i := 16;
  ii := 161;
  k := 0;
  Repeat
    If (FetchElmFNo(RetNo, StatementFNo, i) > '') and
      (FetchElmFNo(RetNo, StatementFNo, ii) <> 'Y') then
      inc(k);
    inc(i, 13);
    inc(ii, 1);
  until i > 159;
  Result := k;
end;
// 20170904 Igor>>>
// Function GetTrFolder:String;
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

// Function IsTrLoaded:Boolean;
// begin
// If GetTrHandle <>0 then
// result:=True
// Else
// result:=False;
// end;


// Function GetTrHandle:HWND;
// begin
// result:=FindWindow(pChar('TTrEngine'), Nil);
// end;

// Procedure LinkToTR(SearchItem:String);
// Var h:THandle;
// begin
// TrFolder:=GetTrFolder;
// h:=GetTrHandle;
// If h<>0 then
// begin
// ShowWindow(h, SW_MAXIMIZE);
// Clipboard.AsText:='From T1|Search|'+SearchItem;
// Application.Minimize;
// end
// else
// begin
// Application.Minimize;
// LoadTr(TrFolder);
// end
// end;


// Procedure LoadTr(TrFolder:String);
// Var h:THandle;
// begin
// h := ShellExecute(Application.MainForm.Handle, Nil,
// Pchar(''+TrFolder+'\TR2017.EXE'), Nil,'', SW_RESTORE);
// //Delay(2000);
// If H<=32 then ShowMessage('The TR-2017 was not installed in '+TrFolder + ' see Configure');
// end;
// 20170904 Igor<<<

Procedure LinkToCICA(Ln: String);
Var
  h: THandle;
  url: PChar;
begin
  url := PChar
    ('http://www.knotia.ca/Knowledge/LBL/Jump.cfm?kType=93&LBLGuideID=1&ChapterID=1&line='
    + Ln);
  Screen.Cursor := crHourGlass;
  h := ShellExecute(Application.MainForm.Handle, 'open', url, Nil, Nil,
    SW_SHOW);
  If h <= 32 then
    ShowMessage('Connection failed');
  Screen.Cursor := crDefault;
end;

// 20171031 igor>>>
(*
  procedure ShowPdf(PgmPath,PgmFile:String);
  Var h : Thandle;
  PgmPathS,PgmS,PgmParmsS:String;
  PgmPathZ : Array[0..254] of Char;
  PgmParmsZ : Array[0..254] of Char;
  PgmZ: Array[0..254] of Char;
  begin
  StrPCopy(PgmPathZ,PgmPath);
  PgmS:=PgmFile; StrPCopy(PgmZ,PgmS);
  PgmParmsS:=''; StrPCopy(PgmParmsZ,PgmParmsS);
  h := ShellExecute(Application.MainForm.Handle, Nil, PgmZ, PgmParmsZ,PgmPathz, SW_RESTORE);
  If H=31 then
  ShowMessage('There is no file association, or file extension is not visible (Explorer Option)')
  else if H<31 then ShowMessage('File not found ');
  end;

  procedure OpenAnyFile(PgmPath,PgmFile:String);
  Var h : Thandle;
  PgmPathS,PgmS,PgmParmsS:String;
  PgmPathZ : Array[0..254] of Char;
  PgmParmsZ : Array[0..254] of Char;
  PgmZ: Array[0..254] of Char;
  begin
  StrPCopy(PgmPathZ,PgmPath);
  PgmS:=PgmFile; StrPCopy(PgmZ,PgmS);
  PgmParmsS:=''; StrPCopy(PgmParmsZ,PgmParmsS);
  h := ShellExecute(Application.MainForm.Handle, Nil, PgmZ, PgmParmsZ,PgmPathz, SW_RESTORE);
  If H=31 then
  ShowMessage('There is no file association, or file extension is not visible (Explorer Option)')
  else if H<31 then ShowMessage('File not found ');
  end;
*)
// 20171031 igor<<<

Function GetL122LossForMinTax(RetNo: integer): Real;
Var
  FNo: integer;
begin
  Result := 0;
  FNo := GetFormNo('OTHINC'); // 20131219
  If VL(FetchElmFNo(RetNo, FNo, 26)) < 0 then
    Result := Result + ABS(VL(FetchElmFNo(RetNo, FNo, 26)));
  If VL(FetchElmFNo(RetNo, FNo, 27)) < 0 then
    Result := Result + ABS(VL(FetchElmFNo(RetNo, FNo, 27)));
  // do not include not a partrership //If Vl(FetchElmFNo(RetNo,FNo,76))<0 then result:=Result+Abs(Vl(FetchElmFNo(RetNo,FNo,76)));
  If VL(FetchElmFNo(RetNo, FNo, 29)) < 0 then
    Result := Result + ABS(VL(FetchElmFNo(RetNo, FNo, 29)));
end;

Function GetTaxShelterLossT776T2042(RetNo: integer): Real;
var
  i: integer;
  x: Real;
  FNo: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if (FRec.FormName = 'T776') and (FetchElmFNo(RetNo, FRec.FormNo, 13) > '')
    then // tax shelter
    begin
      If VL(FetchElmFNo(RetNo, FRec.FormNo, 106)) < 0 then
        Result := Result + ABS(VL(FetchElmFNo(RetNo, FRec.FormNo, 106)));
    end;
    if (FRec.FormName = 'T2042') and (FetchElmFNo(RetNo, FRec.FormNo, 20) > '')
    then // tax shelter no exists
    begin
      FNo := GetFormNo('T2042' + FRec.FormInst);
      If VL(FetchElmFNo(RetNo, FNo, 148)) < 0 then
        Result := Result + ABS(VL(FetchElmFNo(RetNo, FNo, 148)));
    end;
  end;
end;

Function FirstTimeClient(RetNo: integer): Boolean;
begin
  Result := false;
  If UpperCase(FetchElm(RetNo, 'INFO', 88)) = 'X' then
    Result := true;
end;

Function SeparatedThisYear(RetNo: integer): Boolean;
begin
  Result := false;
  If (Ret[RetNo].MarStatus = 5) and (FetchElm(RetNo, 'INFO', 39) > '') then
    Result := true;
end;

Function MarStatusChanged(RetNo: integer): Boolean;
begin
  Result := false;
  If FetchElm(RetNo, 'INFO', 39) > '' then
    Result := true;
end;

Procedure GetAllLinesWithAString(S: String; AList: TStringList;
  Var ResultsList: TStringList);
{ return list with given string }
Var
  i: integer;
  j: integer;
begin
  S := UpperCase(S);
  For i := 0 to AList.Count - 1 do
  Begin
    j := Pos(S, UpperCase(AList[i]));
    If j > 0 then
      ResultsList.Add(AList[i]);
  end;
end;

Function IncrDay(Dt: String): String;
Var
  AYear, AMonth, ADay: integer;
begin
  AYear := MyStrToInt(LeftStr(Dt, 4));
  ADay := MyStrToInt(RightStr(Dt, 2));
  AMonth := MyStrToInt(MidStr(Dt, 6, 2));
  Case AMonth of
    2, 4, 6, 9, 11:
      If ADay < 30 then
        inc(ADay)
      else
      begin
        ADay := 1;
        inc(AMonth);
      end;
    1, 3, 5, 7, 8, 10, 12:
      If ADay < 31 then
        inc(ADay)
      else
      begin
        ADay := 1;
        inc(AMonth);
      end;
  end;
  If AMonth > 12 then
  begin
    inc(AYear);
    AMonth := 1;
  end;
  Result := PaddZero(AllTrim(IntToStr(AYear)), 4) + '-' +
    PaddZero(AllTrim(IntToStr(AMonth)), 2) + '-' +
    PaddZero(AllTrim(IntToStr(ADay)), 2);
end;

Procedure CopyT5SlipsToT5Mult(RetNo: integer);
// only 5 slips
Var
  i, j, k, T5MFNo: integer;
begin
  T5MFNo := GetFormNo('T5MULT#1');
  k := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If (FRec.FormName = 'T5') and (Ret[RetNo].FrmHasData[FRec.FormNo]) then
    // 20160813//20170324 Igor
    begin
      For j := 1 to 14 do
        StoreElm(RetNo, T5MFNo, j + k * 22, FetchElmFNo(RetNo, FRec.FormNo, j));
      For j := 16 to 16 do
        StoreElm(RetNo, T5MFNo, j, FetchElmFNo(RetNo, FRec.FormNo, j));
      inc(k, 1);
      If k > 4 then
        Break;
    end;
  end;
end;

Function CalcMortgageForeclosure(L127, ForeClosureQfp, ForeClosureOth
  : Real): Real;
Var
  S3FNo: integer;
begin
  Result := 0;

  If L127 <= 0 then
  begin
    Result := 0;
    Exit;
  end;
  // there is L127
  If (ForeClosureQfp <= 0) and (ForeClosureOth <= 0) then
  begin
    Result := 0;
    Exit;
  end;
  If (ForeClosureQfp <= 0) and (ForeClosureOth <= 0) then
  begin
    Result := 0;
    Exit;
  end;

  If (ForeClosureQfp <= 0) and (ForeClosureOth > 0) then
  begin
    If ForeClosureOth / 2 < L127 then
    begin
      Result := ForeClosureOth / 2;
      Exit;
    end
    else
    begin
      Result := L127;
      Exit;
    end;
  end;

  If (ForeClosureQfp > 0) and (ForeClosureOth <= 0) then
  begin
    If ForeClosureQfp / 2 < L127 then
    begin
      Result := ForeClosureQfp / 2;
      Exit;
    end
    else
    begin
      Result := L127;
      Exit;
    end;
  end;

  If (ForeClosureQfp > 0) and (ForeClosureOth > 0) then
  begin
    If (ForeClosureQfp + ForeClosureOth) / 2 < L127 then
    begin
      Result := (ForeClosureQfp + ForeClosureOth) / 2;
      Exit;
    end
    else
    begin
      Result := L127;
      Exit;
    end;
  end;

end;

Function SelfEmployedInQc(RetNo: integer): Boolean;
begin
  Result := false;
  If FetchElm(RetNo, 'INFO', 21) = 'QUEBEC' then
    Result := true;
end;

Function IsFieldASin(FName: String; Fld: integer): Boolean;
begin
  Result := false;
  If ((FName = 'INFO') and (Fld = 3)) or ((FName = 'INFO') and (Fld = 4)) or
    ((FName = 'TAXSUM') and (Fld = 11)) or
    ((LeftStr(FName, 3) = 'T4#') and (Fld = 21))
  // or ((LeftStr(FName,3) = 'T3#') and (Fld = 30)) //what is it?
    or ((LeftStr(FName, 4) = 'T4A#') and (Fld = 84)) // 20110119
    or ((LeftStr(FName, 4) = 'T4AP') and (Fld = 10)) or
    ((LeftStr(FName, 3) = 'T4E') and (Fld = 5)) or
    ((LeftStr(FName, 4) = 'T4PS') and (Fld = 12)) or
    ((LeftStr(FName, 6) = 'T4RSP#') and (Fld = 15)) or
    ((LeftStr(FName, 6) = 'T4AOAS') and (Fld = 6)) or
    ((LeftStr(FName, 5) = 'T5007') and (Fld = 6))
  // or ((LeftStr(FName,4) = 'T4F#') and (Fld = 8))
    or ((LeftStr(FName, 5) = 'T4RIF') and (Fld = 14)) then
    Result := true;
  If ((LeftStr(FName, 6) = 'T2125#') and (Fld = 3)) // 20101214
    or ((LeftStr(FName, 6) = 'T2042#') and (Fld = 3)) or
    ((LeftStr(FName, 6) = 'T2121#') and (Fld = 3)) or
    ((LeftStr(FName, 5) = 'T776#') and (Fld = 2)) then
    Result := true;
end;

Function GetT777SElectricityForGst370(RetNo: integer): Real;
Var
  i: integer;
begin
  Result := 0; // no GSTrebate for T777S
  (*
    for i := 0 to (FList.Count - 1) do
    begin
    FRec := FList.Items[i];
    (*
    If FRec.FormName = 'T777S' then
    Begin
    Result := Result +VL(FetchElmFNo(RetNo, FRec.FormNo, 48))
    //+VL(FetchElmFNo(RetNo, FRec.FormNo, 50)) //done separately
    +VL(FetchElmFNo(RetNo, FRec.FormNo, 46))
    +VL(FetchElmFNo(RetNo, FRec.FormNo, 47))
    +VL(FetchElmFNo(RetNo, FRec.FormNo, 49));
    End;
    end;
  *)
end;

(*
  Function GetT777SMaintenanceForGst370(RetNo: Integer): Real;
  Var
  i: Integer;
  begin
  Result := 0;
  end;
*)

Function GetTL2ForGst370(RetNo: integer): Real;
Var
  i: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'TL2' then
      Result := Result + VL(FetchElmFNo(RetNo, FRec.FormNo, 131));
  end;
end;

Procedure GetListOfFarmingStatements(RetNo: integer; AList: TStringList);
Var
  i, FNo: integer;
  FName: string; // [12];//EndDate:string; //[10];BusInc:Real;
begin
  AList.Clear;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    FNo := FRec.FormNo;
    FName := FRec.FormInstName;
    If Ret[RetNo].FrmHasData[FNo] then // 20170324 Igor
    begin
      if (LeftStr(FName, 5) = 'T2042') then
      begin
        AList.Add(PaddR('T2042' + ' ' + FRec.FormInst, 10) + FetchElm(RetNo,
          'T2042' + FRec.FormInst, 8)); // farm name
      end

      else if (LeftStr(FName, 5) = 'T1163') then
      begin
        AList.Add(PaddR('T1163' + ' ' + FRec.FormInst, 10) + FetchElm(RetNo,
          'T1163' + FRec.FormInst, 201)); // farm name //20110216
      end

      else if (LeftStr(FName, 5) = 'T1273') then
      begin
        AList.Add(PaddR('T1273' + ' ' + FRec.FormInst, 10) + FetchElm(RetNo,
          'T1273' + FRec.FormInst, 201)); // farm name  //20110216
      end

    end; // hasdata
  end; // i
end;

Procedure GetMIAAmount(RetNo: integer; FarmFname: String; Var MIA: Real;
  Var OIA: Real);
Var
  i, FNo: integer;
  Inst, FName, S1, S2: string; // [12];
begin
  MIA := 0;
  OIA := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    FNo := FRec.FormNo;
    if (LeftStr(FRec.FormName, 3) = 'MIA') then
    begin
      S1 := LeftStr(FetchElmFNo(RetNo, FNo, 1), 5);
      // If S1='T1163' then S1:='NISAA';
      S2 := LeftStr(ExtractFormRootName(FarmFname), 5);
      Inst := AllTrim(ExtractFormInst(FarmFname));
      If (S1 = S2) and (Inst = AllTrim(MidStr(FetchElmFNo(RetNo, FNo, 1), 6, 3)))
      then
      begin
        MIA := VL(FetchElmFNo(RetNo, FNo, 95));
        OIA := VL(FetchElmFNo(RetNo, FNo, 99));
        Exit;
      end;
    end;
  end; // i
end;

Function GetAdditionalHighlights(RetNo: integer; FName: String;
  FNo: integer): Boolean;
Var
  i: integer;
begin
  UndefMsg('GetAdditionalHighlights');
  Result := false; // ???
  If LeftStr(FName, 6) = 'T5MULT' then
  begin
    Case i of
      1, 23, 45, 67, 89:
        If FetchElmFNo(RetNo, FNo, i) > '' then
        begin
          Result := true;
          Exit;
        End;
    end; // case
  end;

end;

Procedure LoadEditBoxProperties;
begin
  // assert(T1PropDynList=nil,'dupe call of LoadEditBoxProperties');
  // T1PropDynList:=TStringList.Create;
  T1PropDynList.Clear; // :=TStringList.Create;
  T1PropDynList.LoadFromFile(AppDir + '\' + 'T1PropDyn.d');
end;

Function GetDefaultScaling: integer;
Const
  OriginalWidth = 800; { I designed my form in 800x600 mode. }
  OriginalHeight = 600;
begin
  Result := OptRec.FormZoom;
  If (Result = 0) or (Result < 50) or (Result > 200) then
  Begin
    If (Screen.width <= 800) then
    begin
      Result := 100;
      Exit;
    end;
    Result := Round(((Screen.width) / OriginalWidth) * 100);
  end;
end;

Function GetLongestLengthItem(SomeList: TStringList): integer;
var
  i: integer;
begin
  Result := 10;
  For i := 0 to SomeList.Count - 1 do
    If Length(SomeList[i]) > Result then
      Result := Length(SomeList[i]);
end;

Function IsOkToOpenReturn(DataDir: String; FlName: String; Sin: String)
  : Boolean;
Var
  S: String;
Begin
  Result := false;
  If FlName = '' then
    Exit;
  If IsDataDirectoryGood(DataDir) = false then
    Exit;

  // 20170901 Igor>>>
  If AppT1_2026.ExceedsMaxReturnsAllowed(false) then
  begin
    // ShowMessage('Number of returns exceeds maximum allowed '
    // +'('+IntToStr(LimitedVersionReturns)+')'+
    // Chr(13)+' in the T1 Limited version');
    // +Chr(13)+'Please delete some returns');
    Exit;
  end;
  // 20170901 Igor<<<

  If (Sin <> '') and (IsRetInMemory(Sin) > 0) then
  begin
    if MessageDlg('Return for the same SIN is already in memory.' + Chr(13) +
      'Create duplicate copy?', mtInformation, [mbYes, mbNo], 0) = mrNo then
      Exit;
  end;
  Result := true;
end;

Function GetEfileStatus(DataDir, FlName: String): String;
var
  // 20150824 igor
  FDConnection: TADConnection;
  // lPsw:String; //20160226 Igor
begin
  // fGetSQLitePsw(lPsw); //20150925 igor //20160226 Igor

  Result := '';
  if not SetConnection(FDConnection, DataDir + '\' + ClientsDBLite,
    ClientsTableLite) then
  Begin
    if Assigned(FDConnection) then
      FreeAndNil(FDConnection);
    Exit;
  End;
  // 20160226 Igor >>>>>
  if not SetConnection(FDConnection, OptRec.Dir_Cur + '\' + ClientsDBLite,
    ClientsTableLite) then
  Begin
    if Assigned(FDConnection) then
      FreeAndNil(FDConnection);
    Exit;
  End;

  // FDConnection := TADConnection.Create(nil);
  // FDConnection.DriverName := 'SQLite';
  try
    // FDConnection.Params.Values['DataBase'] := DataDir + '\' + ClientsDBLite;
    // //20150904 igor
    // FDConnection.Params.Values['Password'] := lPsw;
    // 20160226 Igor <<<<<
    Result := FDConnection.ExecSQLScalar('SELECT EF_Status FROM ' +
      ClientsTableLite + ' WHERE lower(File_Name) = lower(''' + FlName + ''')')
  finally
    FDConnection.Free;
  end;
end;

Procedure LockReturn(RNo: integer);
Begin
  Ret[RNo].Locked := true;
End;

Procedure UnlockReturn(RNo: integer);
Begin
  If ShowUnconvertedLastYear(RNo) then
    Ret[RNo].Locked := true // do mot allow it
  else
    Ret[RNo].Locked := false;
End;

Procedure PopulatePage1FromInfo(RNo: integer);
Var
  i, Page1FNo: integer;
begin
  Page1FNo := GetFormNo('T1');
  If Ret[RNo].Frm[Page1FNo].Count = 0 then
    InitFormData(RNo, Page1FNo);
  // InfoFNo:=GetFormNo('INFO');
  For i := 1 to 90 do
    StoreElm(RNo, Page1FNo, i, FetchElmFNo(RNo, InfoFNo, i));
end;

Procedure StorePage1ToInfo(RetNo: integer; FormNm: String; FNo: integer;
  elm: integer; Valu: String);
// Var InfoFNo:Integer;
Begin
  If FormNm = 'T1' then
  begin
    // InfoFNo:=GetFormNo('INFO');
    If Ret[RetNo].Frm[InfoFNo].Count = 0 then
      InitFormData(RetNo, InfoFNo);
    Case elm of
      70: // special types of return
        begin
          If LeftStr(Valu, 2) = 'BK' then
            StoreElm(RetNo, InfoFNo, 92, 'X');
          If Valu = 'NR-Section 216 election' then
            StoreElm(RetNo, InfoFNo, 93, 'X');
          If Valu = 'NR-Section 217 election' then
            StoreElm(RetNo, InfoFNo, 94, 'X');
        end;
      49: // Alternate type of address
        begin
          If LeftStr(Valu, 2) = '00' then
            StoreElm(RetNo, InfoFNo, 95, 'X');
          If LeftStr(Valu, 2) = '01' then
            StoreElm(RetNo, InfoFNo, 96, 'X');
          If LeftStr(Valu, 2) = '02' then
            StoreElm(RetNo, InfoFNo, 97, 'X');
          If LeftStr(Valu, 2) = '03' then
            StoreElm(RetNo, InfoFNo, 98, 'X');
          If LeftStr(Valu, 2) = '04' then
            StoreElm(RetNo, InfoFNo, 99, 'X');
        end;

      47: // compensation
        begin
          If LeftStr(Valu, 1) = '1' then
            StoreElm(RetNo, InfoFNo, 100, 'X');
          If LeftStr(Valu, 1) = '2' then
            StoreElm(RetNo, InfoFNo, 101, 'X');
          If LeftStr(Valu, 1) = '3' then
            StoreElm(RetNo, InfoFNo, 102, 'X');
        end;

      52: // transfer refund
        If Valu = '1' then
          StoreElm(RetNo, InfoFNo, 107, 'X');
      23: // gender
        begin
          If Valu = 'M' then
            StoreElm(RetNo, InfoFNo, 108, 'X');
          If Valu = 'F' then
            StoreElm(RetNo, InfoFNo, 109, 'X');
        end;
      53: // Pre-assess review cv
        begin
          If LeftStr(Valu, 1) = '1' then
            StoreElm(RetNo, InfoFNo, 104, 'X');
          If LeftStr(Valu, 1) = '2' then
            StoreElm(RetNo, InfoFNo, 105, 'X');
          If LeftStr(Valu, 1) = '3' then
            StoreElm(RetNo, InfoFNo, 106, 'X');
        end;

      76: // Current yr separation
        If Valu = '1' then
          StoreElm(RetNo, InfoFNo, 118, 'X');
    Else // all other cases
      StoreElm(RetNo, InfoFNo, elm, Valu);
    end;
  end; // page 1

End;

Procedure FixCheckBoxes(RNo: integer);
Var
  FNo: integer;
begin
  FNo := GetFormNo('INFO');
  StoreElm(RNo, FNo, 88, YesNoToX(FetchElmFNo(RNo, FNo, 88)));
  StoreElm(RNo, FNo, 87, YesNoToX(FetchElmFNo(RNo, FNo, 87)));
  StoreElm(RNo, FNo, 85, YesNoToX(FetchElmFNo(RNo, FNo, 85)));
  StoreElm(RNo, FNo, 86, YesNoToX(FetchElmFNo(RNo, FNo, 86)));
  StoreElm(RNo, FNo, 37, YesNoToX(FetchElmFNo(RNo, FNo, 37)));
  StoreElm(RNo, FNo, 46, YesNoToX(FetchElmFNo(RNo, FNo, 46)));
  StoreElm(RNo, FNo, 58, YesNoToX(FetchElmFNo(RNo, FNo, 58)));
  StoreElm(RNo, FNo, 48, YesNoToX(FetchElmFNo(RNo, FNo, 48)));
  StoreElm(RNo, FNo, 51, YesNoToX(FetchElmFNo(RNo, FNo, 51)));
  StoreElm(RNo, FNo, 38, YesNoToX(FetchElmFNo(RNo, FNo, 38)));
  StoreElm(RNo, FNo, 90, YesNoToX(FetchElmFNo(RNo, FNo, 90)));
  StoreElm(RNo, FNo, 56, YesNoToX(FetchElmFNo(RNo, FNo, 56)));
  StoreElm(RNo, FNo, 73, YesNoToX(FetchElmFNo(RNo, FNo, 73)));
end;

Function YesNoToX(S: String): String;
Begin
  Result := '';
  If UpperCase(S) = 'Y' then
    Result := 'X';
end;

Procedure CopyPortfolioToACBForm(RetNo: integer);
Var
  i, j, jj, k: integer;
  Inst: integer;
  FInst: String;
  PortflFNo, AcbFormFNo: integer;
  x: Real;
Begin
  Inst := 0; // of acbform
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If (FRec.FormName = 'PORTFL') and (Ret[RetNo].FrmHasData[FRec.FormNo]) then
    // 20160813//20170324 Igor
    Begin
      PortflFNo := FRec.FormNo;
      If FetchElmFNo(RetNo, PortflFNo, 1) > '' then // if there is descr
      begin
        Inst := Inst + 1;
        FInst := '#' + IntToStr(Inst);
        AcbFormFNo := AddPageInstance(RetNo, 'ACBFRM', FInst);
        InitFormData(RetNo, AcbFormFNo);
        // If Ret[RetNo].Frm[AcbFormFno].Count =0 then InitFormData(RetNo,ACBFormFNo);
        CopyPortflDetails(RetNo, PortflFNo, AcbFormFNo, 8, 50, 15);
        Calc(RetNo, 'ACBFRM' + FInst);
      end;
      If FetchElmFNo(RetNo, PortflFNo, 56) > '' then // if there is descr
      begin
        Inst := Inst + 1;
        FInst := '#' + IntToStr(Inst);
        AcbFormFNo := AddPageInstance(RetNo, 'ACBFRM', FInst);
        InitFormData(RetNo, AcbFormFNo);
        CopyPortflDetails(RetNo, PortflFNo, AcbFormFNo, 63, 105, 15);
        Calc(RetNo, 'ACBFRM' + FInst);
      end;
      If FetchElmFNo(RetNo, PortflFNo, 111) > '' then // if there is descr
      begin
        Inst := Inst + 1;
        FInst := '#' + IntToStr(Inst);
        AcbFormFNo := AddPageInstance(RetNo, 'ACBFRM', FInst);
        InitFormData(RetNo, AcbFormFNo);
        CopyPortflDetails(RetNo, PortflFNo, AcbFormFNo, 118, 160, 15);
        Calc(RetNo, 'ACBFRM' + FInst);
      end;
    end; // found portfl
  end; // i
end;

Procedure CopyPortflDetails(RetNo, PortflFNo, AcbFormFNo, FromPortfolElm,
  ToPortflElm, FromAcbElm: integer);
Var
  j, jj: integer;
  x: Real;
begin
  FormatSettings.DecimalSeparator := '.'; // 20150727
  // copy identification part
  StoreElm(RetNo, AcbFormFNo, 4, 'Mutual Funds');
  StoreElm(RetNo, AcbFormFNo, 3, FetchElmFNo(RetNo, PortflFNo,
    FromPortfolElm - 7)); // descr
  StoreElm(RetNo, AcbFormFNo, 5, '100'); // percent
  StoreElm(RetNo, AcbFormFNo, 8, FetchElmFNo(RetNo, PortflFNo,
    FromPortfolElm - 6)); // beg units
  StoreElm(RetNo, AcbFormFNo, 9, FetchElmFNo(RetNo, PortflFNo,
    FromPortfolElm - 5)); // beg Avg cost

  j := FromAcbElm; // date in new
  jj := FromPortfolElm; // date on old
  Repeat
    StoreElm(RetNo, AcbFormFNo, j, FetchElmFNo(RetNo, PortflFNo, jj)); // Date
    StoreElm(RetNo, AcbFormFNo, j + 2, FetchElmFNo(RetNo, PortflFNo, jj + 1));
    // Units
    If VL(FetchElmFNo(RetNo, PortflFNo, jj + 1)) > 0 then
      StoreElm(RetNo, AcbFormFNo, j + 1, 'Buy')
    else If VL(FetchElmFNo(RetNo, PortflFNo, jj + 1)) < 0 then
      StoreElm(RetNo, AcbFormFNo, j + 1, 'Sell');
    If VL(FetchElmFNo(RetNo, PortflFNo, jj + 1)) > 0 then // units>0
    Begin
      x := VL(FetchElmFNo(RetNo, PortflFNo, jj + 2)) /
        VL(FetchElmFNo(RetNo, PortflFNo, jj + 1)); // unit cost
      StoreElm(RetNo, AcbFormFNo, j + 3, FormatFloat('########.####', x));
      // unit cost
    end
    Else If VL(FetchElmFNo(RetNo, PortflFNo, jj + 1)) < 0 then // units<0
    begin
      x := ABS(VL(FetchElmFNo(RetNo, PortflFNo, jj + 3)) /
        VL(FetchElmFNo(RetNo, PortflFNo, jj + 1))); // unit cost
      StoreElm(RetNo, AcbFormFNo, j + 3, FormatFloat('########.####', x));
      // unit cost
    end;
    inc(j, 9);
    inc(jj, 6);
  until jj > ToPortflElm;
end; // there are units

Procedure ConvertCfgToOptionsFile(CfgTbl: TADTable);
Var
  TempList, TempList1: TStringList;
begin
  With CfgTbl do
  Begin
    FormatSettings.DecimalSeparator := '.'; // 20150727
    TempList := TStringList.Create;
    SaveOptionValue('Dir_Cur', FieldByName('Dir_Cur').AsString, TempList);
    SaveOptionValue('Dir_ClientDocs', FieldByName('Dir_ClientDocs').AsString,
      TempList);
    SaveOptionValue('Dir_PermanentDocs', FieldByName('Dir_PermanentDocs')
      .AsString, TempList); // 20170130 Igor
    SaveOptionValue('Dir_Deflt', FieldByName('Dir_Deflt').AsString, TempList);
    // SaveOptionValue('Dir_Refile', FieldByName('Dir_Refile').AsString, TempList); //20240606
    SaveOptionValue('Dir_LastYr', FieldByName('Dir_LastYr').AsString, TempList);
    SaveOptionValue('Dir_AutoFill', FieldByName('Dir_AutoFill').AsString,
      TempList); // 20160307 //20160505 Igor
    SaveOptionValue('Dir_PgmLastYr', FieldByName('Dir_PgmLastYr').AsString,
      TempList);
    SaveOptionValue('Dir_DBFData', FieldByName('Dir_DBFData').AsString,
      TempList); // 20160226 Igor
    SaveOptionValue('Dir_PrvLYr', FieldByName('Dir_PrvLYr').AsString, TempList);
    SaveOptionValue('Dir_Train', FieldByName('Dir_Train').AsString, TempList);
    SaveOptionValue('Dir_Sample', FieldByName('Dir_Sample').AsString, TempList);

    SaveOptionValue('Prp_Name', FieldByName('Prp_Name').AsString, TempList);

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
    SaveOptionValue('Prp_VSFee', FormatFloat('######.##',
      FieldByName('Prp_VSFee').AsFloat), TempList); // 20100624
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

    SaveOptionValue('SerializeInvoice',
      BooleanToString(Boolean(FieldByName('SerializeInvoice').AsInteger)),
      TempList);

    SaveOptionValue('Prp_Elect',
      BooleanToString(Boolean(FieldByName('Prp_Elect').AsInteger)), TempList);
    SaveOptionValue('Prp_Citizen',
      BooleanToString(Boolean(FieldByName('Prp_Citizen').AsInteger)), TempList);
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

    SaveOptionValue('Prn_Shade',
      BooleanToString(Boolean(FieldByName('Prn_Shade').AsInteger)), TempList);
    SaveOptionValue('Prn_Head',
      BooleanToString(Boolean(FieldByName('Prn_Head').AsInteger)), TempList);
    SaveOptionValue('Prn_NameH',
      BooleanToString(Boolean(FieldByName('Prn_NameH').AsInteger)), TempList);
    SaveOptionValue('Prn_PIPEDAAll',
      BooleanToString(Boolean(FieldByName('Prn_PIPEDAAll').AsInteger)),
      TempList);
    SaveOptionValue('Prn_SinH',
      BooleanToString(Boolean(FieldByName('Prn_SinH').AsInteger)), TempList);
    SaveOptionValue('Prn_HideSin',
      BooleanToString(Boolean(FieldByName('Prn_HideSin').AsInteger)), TempList);
    SaveOptionValue('Prn_DateH',
      BooleanToString(Boolean(FieldByName('Prn_DateH').AsInteger)), TempList);
    SaveOptionValue('Prn_Disclm', FieldByName('Prn_Disclm').AsString, TempList);
    SaveOptionValue('Bus_Disclm', FieldByName('Bus_Disclm').AsString, TempList);
    SaveOptionValue('Prn_Logo',
      BooleanToString(Boolean(FieldByName('Prn_Logo').AsInteger)), TempList);
    // SaveOptionValue('Prn_LogoLn',IntToStr(FieldByName('Prn_LogoLn').AsInteger),TempList);
    // ??  If OptRec.Prn_LogoLn >15 then OptRec.Prn_LogoLn :=15;
    // ??  If OptRec.Prn_LogoLn <0 then OptTec.Prn_LogoLn:=0;
    SaveOptionValue('Opr_Recalc',
      BooleanToString(Boolean(FieldByName('Opr_Recalc').AsInteger)), TempList);
    SaveOptionValue('Opr_Close',
      BooleanToString(Boolean(FieldByName('Opr_Close').AsInteger)), TempList);
    SaveOptionValue('Opr_FPres', IntToStr(FieldByName('Opr_FPres').AsInteger),
      TempList);
    SaveOptionValue('Opr_GSTHst', FormatFloat('######.##',
      FieldByName('Opr_GSTHst').AsFloat), TempList);
    SaveOptionValue('Opr_PST', FormatFloat('######.##',
      FieldByName('Opr_PST').AsFloat), TempList);

    // other options
    TempList1 := TStringList.Create;
    // update frequency
    TempList1.Clear;

    If FileExists(AppDir + '\' + 'UpdSch.Txt') then
    begin
      TempList1.LoadFromFile(AppDir + '\' + 'UpdSch.Txt');
      SaveOptionValue('UpdateFrequency', TempList1[0], TempList);
    end;

    // Ef_method
    TempList1.Clear;
    If FileExists(AppDir + '\' + 'EfMethod.d') then
    begin
      TempList1.LoadFromFile(AppDir + '\' + 'EfMethod.d');
      SaveOptionValue('Ef_Method', TempList1[0], TempList);
    end;

    // Inv Footer
    TempList1.Clear;
    If FileExists(AppDir + '\' + 'InvFoot.d') then
    begin
      TempList1.LoadFromFile(AppDir + '\' + 'InvFoot.d');
      SaveOptionValue('InvFoot1', TempList1[0], TempList);
      SaveOptionValue('InvFoot2', TempList1[1], TempList);
      SaveOptionValue('InvFoot3', TempList1[2], TempList);
      SaveOptionValue('InvFoot4', TempList1[3], TempList);
      SaveOptionValue('InvFoot5', TempList1[4], TempList);
    end;
  End; // with
  TempList.SaveToFile(AppDir + '\' + OptionsFlName);
  TempList.Free;
  TempList1.Free;
end;

Procedure LoadOptionsFileToMem;
Var
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir + '\' + OptionsFlName);
  With OptRec do
  begin
    // Read Values
    Dir_Cur := GetOptionValue('Dir_Cur', TempList);
    // Dir_Refile := GetOptionValue('Dir_Refile', TempList);
    Dir_ClientDocs := GetOptionValue('Dir_ClientDocs', TempList);
    Dir_PermanentDocs := GetOptionValue('Dir_PermanentDocs', TempList);
    // 20170130 Igor
    BackUpFrequency := GetOptionValue('BackUpFrequency', TempList);
    BackUpDir := GetOptionValue('BackUpDir', TempList);
    LastBackUpDir := GetOptionValue('LastBackUpDir', TempList);
    Dir_Deflt := GetOptionValue('Dir_Deflt', TempList);
    // Dir_Refile := GetOptionValue('Dir_Refile', TempList); //20240606
    Dir_Planner := GetOptionValue('Dir_Planner', TempList);
    Dir_LastYr := GetOptionValue('Dir_LastYr', TempList);
    Dir_AutoFill := GetOptionValue('Dir_AutoFill', TempList); // 20160307
    Dir_PgmLastYr := GetOptionValue('Dir_PgmLastYr', TempList);
    Dir_DBFData := GetOptionValue('Dir_DBFData', TempList); // 20160226 Igor

    Prp_Name := GetOptionValue('Prp_Name', TempList);
    Prp_FirstName := GetOptionValue('Prp_FirstName', TempList);
    Prp_LastName := GetOptionValue('Prp_LastName', TempList);
    Prp_RepId := GetOptionValue('Prp_RepId', TempList);

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
    Prp_VSFee := VL(GetOptionValue('Prp_VSFee', TempList)); // 20100624
    Prp_SFee := VL(GetOptionValue('Prp_SFee', TempList));
    Prp_AFee := VL(GetOptionValue('Prp_AFee', TempList));
    Prp_CFee := VL(GetOptionValue('Prp_CFee', TempList));
    // MyStrToInt(GetOptionValue('Prp_CFee',TempList));
    Prp_VCFee := VL(GetOptionValue('Prp_VCFee', TempList));

    Prp_Hour := VL(GetOptionValue('Prp_Hour', TempList));

    SerializeInvoice := StringToBoolean(GetOptionValue('SerializeInvoice',
      TempList));

    Prp_Elect := StringToBoolean(GetOptionValue('Prp_Elect', TempList));
    Prp_Citizen := StringToBoolean(GetOptionValue('Prp_Citizen', TempList));
    Prp_EfRepr := StringToBoolean(GetOptionValue('Prp_EfRepr', TempList));
    Prp_Dates := StringToBoolean(GetOptionValue('Prp_Dates', TempList));
    Nfl_Prov := GetOptionValue('Nfl_Prov', TempList);
    Nfl_City := GetOptionValue('Nfl_City', TempList);

    Nfl_Disced := GetOptionValue('Nfl_Disced', TempList);
    Capitalization := GetOptionValue('Capitalization', TempList);
    T1013Warn := GetOptionValue('T1013Warn', TempList);
    Nfl_Efile := StringToBoolean(GetOptionValue('Nfl_Efile', TempList));

    Ef_Method := GetOptionValue('Ef_Method', TempList);

    Prn_PIPEDAALL := StringToBoolean(GetOptionValue('Prn_PIPEDAAll', TempList));
    // 20180301
    Prn_NameH := StringToBoolean(GetOptionValue('Prn_NameH', TempList));
    Prn_SinH := StringToBoolean(GetOptionValue('Prn_SinH', TempList));
    Prn_HideSin := StringToBoolean(GetOptionValue('Prn_HideSin', TempList));
    Prn_DateH := StringToBoolean(GetOptionValue('Prn_DateH', TempList));
    Prn_Disclm := GetOptionValue('Prn_Disclm', TempList);
    Bus_Disclm := GetOptionValue('Bus_Disclm', TempList);
    // Prn_Logo:=StringToBoolean(GetOptionValue('Prn_Logo',TempList));
    // Prn_logoln:=MyStrToInt(GetOptionValue('Prn_logoln',TempList));
    // LogoFile:=GetOptionValue('LogoFile',TempList);
    // Opr_Close:=StringToBoolean(GetOptionValue('Opr_Close',TempList));  //20090816
    Opr_GstHst := VL(GetOptionValue('Opr_GstHst', TempList));
    Opr_PST := VL(GetOptionValue('Opr_PST', TempList));

    // other optios
    ShowFinWarning := StringToBoolean(GetOptionValue('ShowFinWarning',
      TempList));
    ShowConsultantOnInv := StringToBoolean(GetOptionValue('ShowConsultantOnInv',
      TempList));
    UseFastPrint := StringToBoolean(GetOptionValue('UseFastPrint', TempList));
    UseProperName := StringToBoolean(GetOptionValue('UseProperName', TempList));

    UseFormSearch := StringToBoolean(GetOptionValue('UseFormSearch', TempList));
    RetainRetColor := StringToBoolean(GetOptionValue('RetainRetColor',
      TempList));
    Use2YearSummary := StringToBoolean(GetOptionValue('Use2YearSummary',
      TempList));
    OpenCouple := StringToBoolean(GetOptionValue('OpenCouple', TempList));
    PstOnInvoice := StringToBoolean(GetOptionValue('PstOnInvoice', TempList));
    OtherSlipsButtons := StringToBoolean(GetOptionValue('OtherSlipsButtons',
      TempList));
    ShowUsedForms := StringToBoolean(GetOptionValue('ShowUsedForms', TempList));
    OpenAtLastForm := StringToBoolean(GetOptionValue('OpenAtLastForm',
      TempList));

    UseCondominiumLine := StringToBoolean(GetOptionValue('UseCondominiumLine',
      TempList));
    NoTypeAhead := StringToBoolean(GetOptionValue('NoTypeAhead', TempList));

    RolloverT4T5 := StringToBoolean(GetOptionValue('RolloverT4T5', TempList));
    DecimalAssume := StringToBoolean(GetOptionValue('DecimalAssume', TempList));
    ShowVisitedForms := StringToBoolean(GetOptionValue('ShowVisitedForms',
      TempList));
    ShowInvoiceWarning := StringToBoolean(GetOptionValue('ShowInvoiceWarning',
      TempList));
    ShowInvoiceEfCharge := StringToBoolean(GetOptionValue('ShowInvoiceEfCharge',
      TempList));
    ShowSaluteWarning := StringToBoolean(GetOptionValue('ShowSaluteWarning',
      TempList));
    T1013AuthorLevel := GetOptionValue('T1013AuthorLevel', TempList);
    CVSetting := GetOptionValue('CVSetting', TempList);
    CVPostSetting := GetOptionValue('CVPostSetting', TempList);
    ActiveBoxColor := StrToInt(GetOptionValue('ActiveBoxColor', TempList));
    FirstReturnColor := GetOptionValue('FirstReturnColor', TempList);

    // invoice numbering
    InvPrefix := GetOptionValue('InvPrefix', TempList);
    InvStartNo := GetOptionValue('InvStartNo', TempList);
    InvSuffix := GetOptionValue('InvSuffix', TempList);
    // invoice footter
    InvFoot1 := GetOptionValue('InvFoot1', TempList);
    InvFoot2 := GetOptionValue('InvFoot2', TempList);
    InvFoot3 := GetOptionValue('InvFoot3', TempList);
    InvFoot4 := GetOptionValue('InvFoot4', TempList);
    InvFoot5 := GetOptionValue('InvFoot5', TempList);

    DataInBold := StringToBoolean(GetOptionValue('DataInBold', TempList));

    NoBarCode := StringToBoolean(GetOptionValue('NoBarCode', TempList));
    RetainDefaultPrinter :=
      StringToBoolean(GetOptionValue('RetainDefaultPrinter', TempList));
    RolloverProgram := GetOptionValue('RolloverProgram', TempList);

    AutoSeniorDiscount := StringToBoolean(GetOptionValue('AutoSeniorDiscount',
      TempList));
    DiscountForSeniors := GetOptionValue('DiscountForSeniors', TempList);
    FileNameFormat := GetOptionValue('FileNameFormat', TempList);
    // 20200921 Igor

    // DropBox_ClientID := GetOptionValue('DropBox_ClientID',TempList); //20160614 Igor //20161208 Igor
    { ignored shared options
      EscOption:=GetOptionValue('EscOption',TempList);
      FormZoom:=MyStrToInt(GetOptionValue('FormZoom',TempList));
      HideMostRecent:=StringToBoolean(GetOptionValue('HideMostRecent',TempList));

      Prn_LMargin:=GetOptionValue('Prn_LMargin',TempList);
      Prn_RMargin:=GetOptionValue('Prn_RMargin',TempList);
      Prn_FontIncr:=GetOptionValue('Prn_FontIncr',TempList);
      UpdateFrequency:=GetOptionValue('UpdateFrequency',TempList);
    }
    // DefaultSaveToCloud := StringToBoolean(GetOptionValue('DefaultSaveToCloud', TempList)); //20161208 Igor//20161210 Igor
    GetOverloadedProperty; // 20170112 Igor
  end;
  TempList.Free;
end;

Procedure SaveSingleOption(FieldNm: String; Value: String;
  AOptionsFileName: String = ''); // 20160617 Igor
Var
  i: integer;
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  if AOptionsFileName = '' then
    AOptionsFileName := AppDir + '\' + OptionsFlName; // 20160617 Igor
  // create txt if does not exist
  If FileExists(AOptionsFileName) then
    TempList.LoadFromFile(AOptionsFileName);
  i := IsInList(FieldNm, TempList);
  If i > -1 then
    TempList[i] := LeftStr(TempList[i], 20) + Value
  else
    TempList.Add(PaddR(UpperCase(FieldNm), 20) + Value);
  TempList.SaveToFile(AOptionsFileName);
  TempList.Free;
end;

Function BooleanToString(ABoolean: Boolean): String;
Begin
  If ABoolean = true then
    Result := 'X'
  else
    Result := '';
end;

Function FromYesToX(YesNo: String): String;
Begin
  If UpperCase(YesNo) = 'Y' then
    Result := 'X'
  else
    Result := '';
end;

Function StringToBoolean(AString: String): Boolean;
Begin
  If UpperCase(AString) = 'X' then
    Result := true
  else
    Result := false;
end;

Function GetDfmFormsDir: String;
begin
  If IsDevelopmentMode then
    Result := AppDir + '\' + 'T1Forms'
  else
    Result := AppDir;
end;

Procedure GetS3ACBAmounts(RetNo: integer; PropertyType: String;
  Var AcbProceeds: Real; Var AcbGain: Real);
Var
  i, j: integer;
  FNo: integer;
  Percent: Real;
Begin
  AcbProceeds := 0;
  AcbGain := 0;
  for j := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[j];
    If FRec.FormName = 'S3ACB' then
    begin
      FNo := FRec.FormNo;
      i := 2;
      Repeat
        If FetchElmFNo(RetNo, FNo, i) = PropertyType then
        begin
          Percent := VL(FetchElmFNo(RetNo, FNo, i + 2)) / 100;
          AcbProceeds := AcbProceeds + VL(FetchElmFNo(RetNo, FNo, i + 4))
            * Percent;
          AcbGain := AcbGain + VL(FetchElmFNo(RetNo, FNo, i + 7)) * Percent;
        end;
        inc(i, 9);
      until i > 272;
    end; // s3acb
  end; // j
end;

Function IsDevelopmentMode: Boolean;
begin
  If FileExists(AppDir + '\' + 'Main.pas') then
    Result := true
  else
    Result := false;
end;

Procedure InitOptions;
// var
// PrevOptionsPath: String;
// sl: TStringList;
begin

  // 20190222 Igor >>>
  // if CheckIsCloud(True) then  //20200925 Igor
  // if not SameText(CloudDataDir, '') then  //20190306 Igor
  SetDefaultOptions;
  // 20190222 Igor <<<

  If Not FileExists(AppDir + '\' + OptionsFlName) then
  begin // if first run - try convert from old program
    if not ConvertToMultiApp(AppT1_2026) then
    begin // if no old program or user cancel - load default param values
      SetDefaultOptions;
      LoadOptionsFileToMem; // from txt to optrec
    end
  end
  else // 20160601 Igor
    LoadOptionsFileToMem; // from txt to optrec

  // 20160523 Igor >>>
  // if ExistsPrevOption(AppT1_2026.AppId, PrevOptionsPath) and
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
end;

function BuildValue(ASource: String): String; // 20160530 Igor
Begin
  // 20171204 Igor>>>
  if Pos(c_DefDataDir, ASource) > 0 then
    Result := StringReplace(ASource, c_DefDataDir, DefaultDataDir(AppT1_2026),
      [rfReplaceAll, rfIgnoreCase])
    // 20171204 Igor<<<
  else
    Result := ASource;
  Result := Result;
End;

Function GetDefaultOptionsValue(const AOptionsName: String): String;
// 20160530 Igor
var
  i: integer;
Begin
  for i := Low(OptionsArray) to High(OptionsArray) do
    if SameText(OptionsArray[i, 0], AOptionsName) then
    Begin
      Result := BuildValue(OptionsArray[i, 1]);
      Exit;
    End;
  Result := '';
End;

function GetDefaultOptions: TStringList; // 20160530 Igor
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

function GetOptionsCaption(AOptionsName: String): String; // 20160530 Igor
var
  i: integer;
Begin
  for i := Low(OptionsArray) to High(OptionsArray) do
    if SameText(OptionsArray[i, 0], AOptionsName) then
    Begin
      Result := OptionsArray[i, 2];
      if Result = '' then
        Result := AOptionsName;
      Exit;
    End;
  Result := AOptionsName;
End;

function HaveOptions(AOptionsName: String): Boolean; // 20170112 Igor
var
  i: integer;
Begin
  for i := Low(OptionsArray) to High(OptionsArray) do
    if SameText(OptionsArray[i, 0], AOptionsName) then
      Exit(true);
  Result := false;
end;

Procedure SetDefaultOptions; // 20160523 Igor //20160602 Igor
var
  i: integer;
  CurrOptions: TStringList; // 20201116 Igor

  procedure lSaveSingleOption(AOptionsName: String); // 20201116 Igor
  var
    Value: string;
  Begin
    if OptionsArray[i, 1] = 'X' then
      Exit;
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
  //
  //
  // lSaveSingleOption('Opr-GstHst');
  // lSaveSingleOption('Prp_Bill');
  // lSaveSingleOption('Prp_VSFee');
  // lSaveSingleOption('Prp_SFee');
  // lSaveSingleOption('Prp_AFee');
  // lSaveSingleOption('Prp_CFee');
  // lSaveSingleOption('Prp_VCFee');
  // lSaveSingleOption('Prp_Hour');
  // lSaveSingleOption('FormZoom');
  // lSaveSingleOption('ActiveBoxColor');
  // lSaveSingleOption('FirstReturnColor');
  // lSaveSingleOption('UseFormSearch');
  // lSaveSingleOption('RetainRetColor');
  // lSaveSingleOption('Use2YearSummary');
  // lSaveSingleOption('OpenCouple');
  // lSaveSingleOption('PstOnInvoice');
  // lSaveSingleOption('OtherSlipsButtons');
  // lSaveSingleOption('ShowUsedForms');
  // lSaveSingleOption('OpenAtLastForm');
  // lSaveSingleOption('Opr_Close');
  // lSaveSingleOption('Prn_NameH');
  // lSaveSingleOption('Prn_PIPEDAAll');
  // lSaveSingleOption('Prn_SinH');
  // lSaveSingleOption('Prn_DateH');
  // lSaveSingleOption('Prn_LMargin');
  // lSaveSingleOption('Prn_RMargin');
  // lSaveSingleOption('Prn_FontIncr');
  //
  // lSaveSingleOption('DataInBold');
  // lSaveSingleOption('MaximizeMainForm');
  // lSaveSingleOption('HideMostRecent');
  // lSaveSingleOption('BarCode');
  //
  // lSaveSingleOption('T1013AuthorLevel');
  // lSaveSingleOption('CVSetting');
  // lSaveSingleOption('CVPostSetting');
  // lSaveSingleOption('ShowFinWarning');
  // lSaveSingleOption('ShowConsultantOnInv');
  // lSaveSingleOption('UseFastPrint');
  // lSaveSingleOption('UseProperName');
  //
  // lSaveSingleOption('UseCondominiumLine');
  // lSaveSingleOption('NoTypeAhead');
  // lSaveSingleOption('RolloverT4T5');
  // lSaveSingleOption('DecimalAssume');
  // lSaveSingleOption('ShowInvoiceWarning');
  // lSaveSingleOption('ShowInvoiceEfCharge');
  // lSaveSingleOption('ShowSaluteWarning');
  //
  // lSaveSingleOption('UpdateFrequency');
  // lSaveSingleOption('Nfl_Efile');
  // lSaveSingleOption('Nfl_Prov');
  // lSaveSingleOption('Nfl_City');
  // lSaveSingleOption('Ef_Method');
  //
  // lSaveSingleOption('Prp_Elect');
  // lSaveSingleOption('Prp_Citizen');
  // lSaveSingleOption('Prp_EfRepr');
  // lSaveSingleOption('Nfl_Disced');
  // lSaveSingleOption('Capitalization');
  // lSaveSingleOption('T1013Warn');
  // lSaveSingleOption('EscOption');
  //
  // lSaveSingleOption('AutoSeniorDiscount');
  // lSaveSingleOption('DiscountForSeniors');
  // lSaveSingleOption('RolloverProgram');
  // lSaveSingleOption('DecimalAssume');

  // 20160602 Igor
  // if assigned(APrevOptions) then
  // CompareOptions(APrevOptions, AppDir+'\'+OptionsFlName);
  // AutoSeniorDiscount.Checked:=StringToBoolean(GetOptionValue('AutoSeniorDiscount',TempList));
  // DiscountForSeniors.Text:=GetOptionValue('DiscountForSeniors',TempList);

end;

// 20171031 Igor>>>
function CreateDefaultDataDirectories: Boolean;
var
  Err: String;
  DataDir, PlannerDir, ClientDocDir, LYDir: string;
Begin
  If not CheckIsCloud(true) and (LicenseLevel in anyLimited) then
  // 20180503 Igor
  begin
    DataDir := LimitedVersionDir; // 20180109 Igor
    PlannerDir := TPath.Combine(LimitedVersionDir, 'Planner');
    ClientDocDir := TPath.Combine(LimitedVersionDir, 'Client Documents');
    LYDir := TPath.Combine(LimitedVersionDir, 'LastYear');
  end
  else
  begin
    // 20171201 Igor>>>
    DataDir := TPath.Combine(DefaultDataDir(AppT1_2026), 'Data');
    PlannerDir := TPath.Combine(DefaultDataDir(AppT1_2026), 'Planner');
    ClientDocDir := TPath.Combine(DefaultDataDir(AppT1_2026),
      'Client Documents');
    LYDir := TPath.Combine(DefaultDataDir(AppT1_2026), 'LastYear');
    // 20171201 Igor<<<
  end;
  If not TDirectory.Exists(DataDir) or
    not TFile.Exists(TPath.Combine(DataDir, ClientsDBLite)) then
  begin
    If not InitDataBase(DataDir, Err) then
    begin
      Errors.Log(Err);
      MessageDlg(Err, mtError, [mbOk], 0);
      Exit(false);
    end;
  end;
  If not TDirectory.Exists(PlannerDir) or
    Not TFile.Exists(TPath.Combine(PlannerDir, ClientsDBLite)) then
  begin
    If not InitDataBase(IncludeTrailingPathDelimiter(AppDir) + 'Planner', Err)
    then
    begin
      Errors.Log(Err);
      MessageDlg(Err, mtError, [mbOk], 0);
      Exit(false);
    end;
  end;
  If not TDirectory.Exists(ClientDocDir) then
    ForceDirectories(ClientDocDir);

  SaveSingleOption('Dir_Cur', DataDir);
  SaveSingleOption('Dir_Deflt', DataDir);
  // SaveSingleOption('Dir_Refile', DataDir);   //20240606
  SaveSingleOption('Dir_Planner', PlannerDir);
  SaveSingleOption('Dir_ClientDocs', ClientDocDir);
  if CheckIsCloud(true) then // 20180503 Igor
  begin
    if OptRec.RolloverProgram <> '' then
      SaveSingleOption('Dir_LastYr', LYDir + TPath.DirectorySeparatorChar +
        OptRec.RolloverProgram)
    else
    begin
      SaveSingleOption('RolloverProgram', 'VisualTax');
      SaveSingleOption('Dir_LastYr', LYDir + TPath.DirectorySeparatorChar +
        'VisualTax')
    end;
  end;

  If not OptRec.Dir_PermanentDocs.IsEmpty AND
    not TDirectory.Exists(OptRec.Dir_PermanentDocs) then
    ForceDirectories(OptRec.Dir_PermanentDocs);
  If not OptRec.Dir_AutoFill.IsEmpty and
    not TDirectory.Exists(OptRec.Dir_AutoFill) then
    ForceDirectories(OptRec.Dir_AutoFill);
  Result := true;
  // 20171031 Igor<<<
end;

Procedure SortACBFRM(RetNo: integer; FName: String);
Var
  i, j, ii, iii, iiii, k, kk, FNo: integer;
  Records: TStringList;
begin
  Records := TStringList.Create;
  Records.Sorted := true;
  FNo := GetFormNo(FName);
  i := 15;
  ii := 429;
  iii := 475;
  iiii := 521;
  Repeat
    If AllTrim(FetchElmFNo(RetNo, FNo, i + 1)) > '' then
    begin
      Records.Add(PaddR(FetchElmFNo(RetNo, FNo, i), 20) +
        PaddR(FetchElmFNo(RetNo, FNo, i + 1), 20) + PaddR(FetchElmFNo(RetNo,
        FNo, i + 2), 20) + PaddR(FetchElmFNo(RetNo, FNo, i + 3), 20) +
        PaddR(FetchElmFNo(RetNo, FNo, i + 4), 20) + PaddR(FetchElmFNo(RetNo,
        FNo, i + 5), 20) + PaddR(FetchElmFNo(RetNo, FNo, i + 6), 20) +
        PaddR(FetchElmFNo(RetNo, FNo, i + 7), 20) + PaddR(FetchElmFNo(RetNo,
        FNo, i + 8), 20) + PaddR(FetchElmFNo(RetNo, FNo, ii), 20) // exch rate
        + PaddR(FetchElmFNo(RetNo, FNo, iii), 20) // country
        + PaddR(FetchElmFNo(RetNo, FNo, iiii), 20)); // orig amount
    end;
    i := i + 9;
    ii := ii + 1;
    iii := iii + 1;
    iiii := iiii + 1
  until i > 420;

  { Clear form detail transactions }
  i := 15;
  ii := 429;
  iii := 475;
  iiii := 521;
  Repeat
    StoreElm(RetNo, FNo, i, '');
    StoreElm(RetNo, FNo, i + 1, '');
    StoreElm(RetNo, FNo, i + 2, '');
    StoreElm(RetNo, FNo, i + 3, '');
    StoreElm(RetNo, FNo, i + 4, '');
    StoreElm(RetNo, FNo, i + 5, '');
    StoreElm(RetNo, FNo, i + 6, '');
    StoreElm(RetNo, FNo, i + 7, '');
    StoreElm(RetNo, FNo, i + 8, '');
    StoreElm(RetNo, FNo, ii, '');
    StoreElm(RetNo, FNo, iii, '');
    StoreElm(RetNo, FNo, iiii, '');
    i := i + 9;
    ii := ii + 1;
    iii := iii + 1;
    iiii := iiii + 1;
  until i > 420;
  { copy sorted records to form }
  j := 15;
  ii := 429;
  iii := 475;
  iiii := 521;
  For i := 0 to Records.Count - 1 do
  begin
    StoreElm(RetNo, FNo, j, AllTrim(LeftStr(Records[i], 20)));
    StoreElm(RetNo, FNo, j + 1, AllTrim(MidStr(Records[i], 21, 20)));
    StoreElm(RetNo, FNo, j + 2, AllTrim(MidStr(Records[i], 41, 20)));
    StoreElm(RetNo, FNo, j + 3, AllTrim(MidStr(Records[i], 61, 20)));
    StoreElm(RetNo, FNo, j + 4, AllTrim(MidStr(Records[i], 81, 20)));
    StoreElm(RetNo, FNo, j + 5, AllTrim(MidStr(Records[i], 101, 20)));
    StoreElm(RetNo, FNo, j + 6, AllTrim(MidStr(Records[i], 121, 20)));
    StoreElm(RetNo, FNo, j + 7, AllTrim(MidStr(Records[i], 141, 20)));
    StoreElm(RetNo, FNo, j + 8, AllTrim(MidStr(Records[i], 161, 20)));
    StoreElm(RetNo, FNo, ii, AllTrim(MidStr(Records[i], 181, 20)));
    StoreElm(RetNo, FNo, iii, AllTrim(MidStr(Records[i], 201, 20)));
    StoreElm(RetNo, FNo, iiii, AllTrim(MidStr(Records[i], 221, 20)));
    j := j + 9;
    ii := ii + 1;
    iii := iii + 1;
    iiii := iiii + 1;
  end;
  Records.Free;
end;

Procedure GetCouplingSins(RetNo: integer; Var CouplingSins: TStringList);
Var
  i, FNo: integer;
begin
  CouplingSins.Clear;
  FNo := GetFormNo('FAMSET');
  i := 3;
  Repeat
    If (FetchElmFNo(RetNo, FNo, i) > '') and
      (UpperCase(FetchElmFNo(RetNo, FNo, i + 1)) = 'X') then
      CouplingSins.Add(RemoveChar(FetchElmFNo(RetNo, FNo, i), '-'));
    inc(i, 4);
  until i > 43;
end;

procedure BuildSuperEntries(FullFlName: String);
Var
  i, j: integer;
  DataList, ElmList, TempList: TStringList;
  Dir, S: String;
begin
  // 20170502 Igor >>>
  If not FileExists(FullFlName) then
    Exit;
  DataList := TStringList.Create;
  try
    if not TSQLiteStorage.LoadToStringList(FullFlName, DataList,
      AppT1_2026.SQLLitePassword.PassRFArray) then
      if not TFileStorage.LoadToStringList(FullFlName, DataList) then
        Exit;

    ElmList := TStringList.Create;
    TempList := TStringList.Create;
    try
      BuildExperience('MEDICAL', 8, 108, 5, 'MedExp.txt', ElmList, DataList);
      BuildExperience('MEDICAL', 7, 107, 5, 'Doctors.txt', ElmList, DataList);

      BuildExperience('DON', 16, 82, 6, 'Charity.txt', ElmList, DataList);
      BuildExperience('DON', 3, 13, 5, 'Charity.txt', ElmList, DataList);
      BuildExperience('DON', 19, 85, 6, 'Charity.txt', ElmList, DataList);

      For i := 1 to 15 do
        BuildExperience('T3MULT#' + AllTrim(IntToStr(i)), 17, 21, 1,
          'Banks.txt', ElmList, DataList);
      // For i:=1 to 15 do BuildExperience('T3#'+AllTrim(IntToStr(i)),1,1,1,'Banks.txt',ElmList,DataList);
      For i := 1 to 15 do
        BuildExperience('T5#' + AllTrim(IntToStr(i)), 1, 1, 1, 'Banks.txt',
          ElmList, DataList);
      For i := 1 to 10 do
        BuildExperience('T5MULT#' + AllTrim(IntToStr(i)), 1, 89, 22,
          'Banks.txt', ElmList, DataList);
      For i := 1 to 3 do
        BuildExperience('T4RIF#' + AllTrim(IntToStr(i)), 1, 1, 1, 'Banks.txt',
          ElmList, DataList);
      For i := 1 to 3 do
        BuildExperience('T4RSP#' + AllTrim(IntToStr(i)), 1, 1, 1, 'Banks.txt',
          ElmList, DataList);
      For i := 1 to 3 do
        BuildExperience('T4#' + AllTrim(IntToStr(i)), 1, 1, 1, 'Employers.txt',
          ElmList, DataList);
      For i := 1 to 3 do
        BuildExperience('T4A#' + AllTrim(IntToStr(i)), 81, 81, 1,
          'Employers.txt', ElmList, DataList);

      BuildExperience('UNIOND', 2, 12, 2, 'Banks.txt', ElmList, DataList);
      BuildExperience('RRSP', 9, 9, 1, 'Banks.txt', ElmList, DataList);
      BuildExperience('RRSP', 20, 36, 4, 'Banks.txt', ElmList, DataList);
      BuildExperience('RRSP', 43, 63, 4, 'Banks.txt', ElmList, DataList);
      BuildExperience('RRSP', 79, 79, 1, 'Banks.txt', ElmList, DataList);
      BuildExperience('INFO', 2, 2, 2, 'FirstNm.txt', ElmList, DataList);
      BuildExperience('DEPEND', 5, 20, 125, 'FirstNm.txt', ElmList, DataList);
      BuildExperience('INFO', 10, 10, 1, 'Cities.txt', ElmList, DataList);
    finally
      TempList.Free;
      ElmList.Free;
    end;
  finally
    DataList.Clear;
    DataList.Free;
  end;
  // 20170502 Igor <<<
end;

Function GetSigningDate(RetNo: integer): String;
begin
  Result := FetchElm(RetNo, 'INFO', 112);
end;

Function CreateNewDataDir: String;
var
  DataDir: string; // [60];
  ThisResult: integer;
  ClickedOK: Boolean;
begin
  If LicenseLevel in anyLimited then
    DataDir := LimitedVersionDir
  else
    DataDir := AppDir + '\Data';
  DataDir := InputBox('Create Data Directory', 'Enter Full path', DataDir);
  ThisResult := CreateDataDirectory(AppDir, DataDir);
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
    Result := DataDir
  else
    Result := '';
end;

Function CreateDataDirectory(AppDir: string; DataDir: string): integer;
{ return codes
  0 : OK
  -1 : Directory exists
  -2 : Already contains data base
  -3 : Dir cannot be created
  -4 : Cannot copy Data Bases
  -5 : must have a slash with subdirectory
}
// 20170811 Igor >>>
var
  Err: String;
begin
  If (Length(DataDir) < 3) or (Pos('\', DataDir) = 0) then
    Exit(-5);
  If SysUtils.DirectoryExists(DataDir) then
    Exit(-1);
  If SysUtils.FileExists(IncludeTrailingPathDelimiter(DataDir) + ClientsDBLite)
  then
    Exit(-2);
  try
    if not SysUtils.ForceDirectories(DataDir) then
      Exit(-3);
  except
    Exit(-3);
  end;
  If not InitDataBase(DataDir, Err) then // 20171031 igor
    Exit(-4);

  Result := 0;
  // 20170811 Igor<<<
end;

Function GetRichElms(FrmNm: String): String;
Var
  i: integer;
  TempList: TStringList;
begin
  Result := '';
  FrmNm := UpperCase(ExtractNonInstFormName(FrmNm));
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir + '\' + 'Rich.d');
  For i := 0 to TempList.Count - 1 do
  begin
    If FrmNm = UpperCase(RTrim(LeftStr(TempList[i], 10))) then
    begin
      Result := AllTrim(MidStr(TempList[i], 11, 15));
      Exit;
    end; // found form
  end; // i
end;

(* //20170409 Igor
  procedure InsertBackFunction(ARichEdit:TRichEdit;InSearch, InSecondSearch, InReplace: string); //20160819 Igor
  var X,Y,ToEnd : integer;
  begin
  with ARichEdit do
  begin
  Visible:=False;
  X := 0;
  ToEnd := length(ARichEdit.Text) ;
  X := FindText(inSearch, X, ToEnd, []) ;
  while X <> -1 do
  begin
  Y := X;
  Y := FindText(inSecondSearch, Y, ToEnd, []) ;
  SelStart := Y;
  SelLength := length(inSecondSearch);
  SelText := InReplace;
  X := FindText(inSearch,Y + length(InReplace),ToEnd, []);
  end;
  Visible:=True;
  end;//with
  end;
*)

Function GetLetterFileName(RetNo: integer; FName: String): String;
Begin
  If FName = 'CLETTER' then
  begin
    Result := GetClientLettersDir + '\' + MkClientLetterName(RetNo);
    If FileExists(Result) then
      Exit; // special letter
    If UpperCase(FetchElm(RetNo, 'INFO', 46)) = 'X' then { Efiled }
      Result := AppDir + '\' + 'EfiledLetter.RTF'
    else
      Result := AppDir + '\' + 'PaperFiledLetter.RTF';
  end;
  If FName = 'PIPEDA' then
    Result := AppDir + '\' + 'PIPEDALetter.RTF';
  If FName = 'ENGAGE' then
    Result := AppDir + '\' + 'EngagementLetter.RTF';
  // If FName = 'CUSTINV' then result := AppDir + '\' + 'CustInvLetter.RTF';  //20200428
  If FName = 'ALETTER' then
    Result := AppDir + '\' + SomeLetterName; // global variable
End;

Function IsAcceptableGraphicsFile(FlName: String): Boolean;
Var
  Ext: String;
begin
  Result := false;
  Ext := UpperCase(ExtractFileExt(FlName));
  If (Ext = '.BMP') or (Ext = '.WMF') or (Ext = '.JPG') or (Ext = '.ICO') then
    Result := true;
end;

Function IsFormAClientLetter(FName: String): Boolean;
begin
  Result := false;
  If (FName = 'CLETTER') or (FName = 'PIPEDA') or (FName = 'ENGAGE') or
    (FName = 'CUSTINV') or (FName = 'ALETTER') // for miscellaneous letters
  then
    Result := true;
end;


// 20170409 Iogr >>>
// Function RTFToPlainText(ARichEdit:TRichEdit):AnsiString;
// var strStream: TStringStream;
// begin
// (* BEWARE: this will permanently change the ARichEdit.PlainText property!
// Try accessing Text directly (doesn't contain attributes}!?
// *)
// strStream := TStringStream.Create('') ;
// try
// ARichEdit.PlainText := True;
// ARichEdit.Lines.SaveToStream(strStream) ;
// Result := strStream.DataString;
// finally
// strStream.Free;
// end;
// end;
// 20170409 Iogr <<<

(* //20170409 Igor
  procedure ReplaceRtfText(ARichEdit:TRichEdit;InSearch, InReplace: string) ; //20160819 Igor
  var X, ToEnd : integer;
  begin

  with ARichEdit do
  begin
  Visible:=False;
  X := 0;
  ToEnd := length(ARichEdit.Text) ;
  X := FindText(inSearch, X, ToEnd, []) ;
  while X <> -1 do
  begin
  SelStart := X;
  SelLength := length(inSearch) ;
  SelText := InReplace;
  X := FindText(inSearch,X + length(InReplace),ToEnd, []);
  end;
  Visible:=True;
  end;//with
  end;
*)

(* //20170409 Igor
  Function GetKeyWListFromRichEdit(ARichEdit:TRichEdit;KeyWList:TStringList):Boolean; //20160819 Igor
  Var
  Delim1List,Delim2List:TStringList;
  KeyW,tempKeyWFull:String;
  StartPos:Integer;
  var
  i: integer;
  begin
  Result:=True;
  Delim1List:=TStringList.Create;
  Delim2List:=TStringList.Create;
  GetDelimiterPositionsInRTf(ARichEdit,'[',Delim1List);
  GetDelimiterPositionsInRTf(ARichEdit,']',Delim2List);

  If Delim1List.Count <> Delim2List.Count then
  Begin
  Delim1List.Free;
  Delim2List.Free;
  Result:=False;
  Exit;
  end;

  For i:=0 to Delim1List.count-1 do
  begin
  With ARichEdit do
  Begin
  SelStart:=MyStrToInt(Delim1List[i])+1;
  SelLength:=MyStrToInt(Delim2List[i])-MyStrToInt(Delim1List[i])-1;
  KeyW:=SelText;
  KeyW:=CleanUpKeyW(KeyW);

  tempKeyWFull := KeyW;
  while(tempKeyWFull > '') do
  begin
  StartPos := Pos(' ', tempKeyWFull);
  if StartPos > 0 then
  begin
  KeyW := alltrim(LeftStr(tempKeyWFull,StartPos));
  tempKeyWFull := alltrim(RightStr(tempKeyWFull,Length(tempKeyWFull)-StartPos ));
  end
  else
  begin
  KeyW := tempKeyWFull;
  tempKeyWFull := '';
  end;
  If (IsInList(KeyW,KeyWList) = -1) and (InDataDict(KeyW)) then
  begin
  If KeyW>'' then KeyWList.Add(KeyW);
  end;
  end;

  end;
  end;
  With ARichEdit do
  begin
  SelStart := Perform(EM_LINEINDEX, 0, 0) ;
  SelLength:=0;
  end;
  Delim1List.Free;
  Delim2List.Free;
  end;
*)

Function CleanUpKeyW(KeyW: String): String;
// comes as If (keywxxx > 0)  etc > < || ! && etc
// also Need Ffix in front of dollar variables
Var
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

(* //20170409 Iogr
  Procedure GetDelimiterPositionsInRtf(ARichEdit: TRichEdit; SearchText: string;DelimList:TStringList); //20160819 igor
  var k,StartPos, FoundAt, Endpos: Integer;
  begin
  //ARichEdit.HideScrollbars:=True;
  ARichEdit.SelStart := 0;
  ARichEdit.SelLength := 0;
  with ARichEdit do
  begin
  k := 0;
  EndPos := length(ARichEdit.Text) ;
  k := FindText(SearchText, k, EndPos, []) ;
  while k <> -1 do
  begin
  If k<> -1 then DelimList.Add(IntToStr(k));
  k := FindText(SearchText,k + length(SearchText),EndPos, []);
  end;
  end;//with
  //ARichEdit.SelStart := 0;
  With ARichEdit do
  begin
  //SetFocus;
  SelStart := Perform(EM_LINEINDEX, 0, 0) ;
  SelLength:=0;
  end;

  // ARichEdit.HideScrollbars:=False;
  end;
*)
(*
  Function IsKeyWInRtf(ARichEdit:TRichEdit;InSearch:string):Boolean;
  var X, ToEnd : integer;
  begin
  Result:=False;
  with ARichEdit do
  begin
  X := 0;
  ToEnd := length(ARichEdit.Text) ;
  X := FindText(inSearch, X, ToEnd, []) ;
  If X<> -1 then begin Result:=True;exit;end;
  end;//with

  end;
*)
(* //20170409 Iogr
  Procedure ConvertOldLetter(ARichEdit:TRichEdit);
  Var s:AnsiString;
  Begin
  ARichEdit.SelStart:=0;
  ARichEdit.SelectAll;
  //ARichEdit.Paragraph.Alignment := taLeftJustify;
  ReplaceRtfText(ARichEdit,'[If]', '[If (');
  ReplaceRtfText(ARichEdit,'[If ([', '[If (');
  ReplaceRtfText(ARichEdit,'[If ( [', '[If (');
  ReplaceRtfText(ARichEdit,'[Nested_If]', '[If (');
  ReplaceRtfText(ARichEdit,'[Nested_If ([', '[If (');
  ReplaceRtfText(ARichEdit,'[Nested_If ( [', '[If (');
  ReplaceRtfText(ARichEdit,'[Nested_Endif]', '[Endif');

  ReplaceRtfText(ARichEdit,']>', ')>])');
  ReplaceRtfText(ARichEdit,'] >', ')>])');
  ReplaceRtfText(ARichEdit,']<', ')<])');
  ReplaceRtfText(ARichEdit,'] <', ')<])');

  //ReplaceRtfText(ARichEdit,#$D, '');  //never ending loop
  //ReplaceRtfText(ARichEdit,'tab', ''); //nothing
  //remove tabs
  //CellText := StringReplace(CellText,#$D, '', [rfReplaceAll]);
  // Remove linebreaks
  //CellText := StringReplace(CellText, #$7, '', [rfReplaceAll]);
  End;
*)
(* //20170409 igor
  Procedure ReplaceRtfDelimiters(ARichEdit:TRichEdit;FromDelim,ToDelim:String); //20160819 igor
  begin
  ARichEdit.SelStart:=0;
  ARichEdit.SelectAll;
  ARichEdit.Paragraph.Alignment := paLeftJustify; //20160819 Igor
  ReplaceRtfText(ARichEdit,FromDelim, ToDelim);
  end;
*)

Function IsConditionalRtfStatement(KeyW: String): Boolean;
// for letters
begin
  Result := false;
  If (UpperCase(LeftStr(KeyW, 4)) = 'IF (') Or
    (UpperCase(LeftStr(KeyW, 3)) = 'IF(') Or
    (UpperCase(LeftStr(KeyW, 7)) = 'ELSIF (') Or
    (UpperCase(LeftStr(KeyW, 6)) = 'ELSIF(') then
    Result := true;
end;

(* //20170409 Iogr
  Procedure AddDisplayFormatToRtf(ARichEdit:TRichEdit;KeyWList:TStringList); //20160819 igor
  // i.e. [Taxable_amount] s/b FNum(Taxable_amount)
  begin
  //
  end;
*)

Procedure InsertKeyWToDataDict(FormName: String; AnEditBox: TvtEdit);
var
  KeyW, S: String;
  // 20150824 igor
  FDConnection: TADConnection;
  Table1: TADTable;
begin
  FDConnection := TADConnection.Create(nil);
  Table1 := TADTable.Create(nil);

  // 20150918 Igor
  // 20160226 Igor >>>>
  if not SetTableName(FDConnection, Table1, AppDir + '\' + 'DATADICT.DB',
    'DATADICT', 'KeyWord') then // 20170223 Igor
  Begin
    if Assigned(FDConnection) then
      FreeAndNil(FDConnection);
    if Assigned(Table1) then
      FreeAndNil(Table1);
    Exit;
  End;
  // 20160226 Igor
  try
    KeyW := ExtractNonInstFormName(FormName) + '_' +
      IntToStr(GetFieldId(AnEditBox.Name));
    if Table1.FindKey([KeyW]) = false then
    Begin
      Table1.Insert;
      Table1.FieldByName('FormName').AsString :=
        ExtractNonInstFormName(FormName);
      Table1.FieldByName('Field_No').AsInteger := GetFieldId(AnEditBox.Name);
      Table1.FieldByName('Descr').AsString := FormName + ' cell number' +
        IntToStr(GetFieldId(AnEditBox.Name));
      If AnEditBox.vtInputType = vtDollar then
        Table1.FieldByName('Is_Amount').AsString := 'Y'
      else
        Table1.FieldByName('Is_Amount').AsString := '';
    end;
    S := InputBox('Input Box', 'Enter a keyWord name for this data field', '');
    If S = '' then
    begin
      ShowMessage('Cancelled');
      Table1.Close;
      Exit;
    end;
    S := ReplaceChar(S, ' ', '_');
    S := RemoveChar(S, '#');
    Table1.FieldByName('KeyWord').AsString := S;
    Table1.Post;
    ShowMessage('The keyWord was added with name: ' + S + Chr(13) + ' ' +
      'You can further refine/delete keywords by clicking on Configure | Data Dictionary');
  finally
    Table1.Free;
    FDConnection.Free;
  end;
end;

Function GetClosestEditBoxOFINFO(LblCaption: String): integer;
begin
  Result := 0;
  LblCaption := UpperCase(AllTrim(LblCaption));
  If LblCaption = 'IDENTIFICATION' then
    Result := 2;
  If LblCaption = 'INFORMATION ABOUT YOU' then
    Result := 3;
  If LblCaption = 'RESIDENCE INFORMATION' then
    Result := 1;
  If LblCaption = 'SPOUSE OR COMMON-LAW INFORMATION' then
    Result := 4;
  If LblCaption = 'NON-RESIDENT INFO' then
    Result := 81;
  If LblCaption = 'CONTACT INFORMATION' then
    Result := 54;
  If LblCaption = 'ELECTIONS CANADA' then
    Result := 43;
  If LeftStr(LblCaption, 7) = 'GST/HST' then
    Result := 29;
  If LblCaption = 'PREPARER OFFICE USE' then
    Result := 124;
  If LblCaption = 'FILING INFORMATION' then
    Result := 46;
end;

Function IsInvoiceLocked(RetNo: integer): Boolean;
begin
  Result := false;
  If UpperCase(FetchElm(RetNo, 'INVOICE', 285)) = 'Y' then
    Result := true;
end;

Procedure PrintWithMsWord(RetNo: integer; FileName: String;
  InterpretKeyWords: Boolean);
Var
  h: THandle;
  V: Variant;
  ARichEdit: TwwDbRichEdit;
begin

  try
    V := CreateOLEObject('Word.Application');
    V.Visible := false; // true;  // Word window visible with true
    // 20150727  MainFormT1.EkRTF1.InFile:=FileName;
    // 20150727  MainFormT1.EkRTF1.OutFile:=AppDir+'\'+'Temp.rtf';
    // MainForm.EKRTF1.ExecuteOpen([],SW_HIDE);
    If InterpretKeyWords then
    begin
      ARichEdit := TwwDbRichEdit.Create(Application);
      ARichEdit.Parent := MainFormT1;
      ARichEdit.Visible := false;
      // 20150727    ARichEdit.Lines.LoadFromFile(MainFormT1.EkRTF1.OutFile);
      GetInterpetedRichEdit(RetNo, FileName, ARichEdit);
      // 20150727    ARichEdit.Lines.SaveToFile(MainFormT1.EkRTF1.OutFile);
      ARichEdit.Free;
    end;
    // 20150727  V.Documents.Open(MainFormT1.EkRTF1.outfile);
    V.ActiveDocument.PrintOut(false);
    V.Quit(0); // Quit, do not save changes;
    V := Unassigned;
  except
    ShowMessage('Could not print document using MS Word');
  end;

end;

procedure PrintAtAngle(AText: String; ACanvas: TCanvas; Xpos: integer;
  YPos: integer; FontSize: integer; AtAngle: integer);
var
  lf: TLogfont;
begin
  ACanvas.font.Name := 'Times New Roman'; // 'Arial';
  ACanvas.font.Size := FontSize;
  ACanvas.font.Color := RGB(220, 220, 220);
  // clSilver; //RGB(230,230,230); //clSilver; //20121216
  ACanvas.font.Style := [fsBold];
  GetObject(ACanvas.font.Handle, Sizeof(lf), @lf);
  lf.lfescapement := AtAngle; // 450;
  lf.lforientation := AtAngle; // 450;
  ACanvas.font.Handle := CreateFontIndirect(lf);
  ACanvas.TextOut(Xpos, YPos, AText);
  ACanvas.font.Handle := 0;
end;

(*
  // tip by Peter Below.
  // Drawing a selection rectangle on the form:

  {
  A good way to draw a rectangle that needs to be erased again is the Windows
  API function DrawFocusRect, by the way. It draws using an XOR pen,
  if you call it twice with the same rectangle it is erased on screen.
  Using two private fields on your form declaration:
  }
  private
  { Private declarations }
  fDragging: Boolean;
  fRect: TRect;

  it is fairly easy to implement a selection rectangle the user can
  drag on the form, using handlers for the forms OnMouse... events:

  procedure TForm2.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  begin
  If mbLeft = Button Then Begin
  fDragging := True;
  SetRect( fRect, X, Y, X, Y );
  Canvas.DrawFocusrect( fRect );
  end;
  end;

  procedure TForm2.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
  begin
  If fDragging Then Begin
  Canvas.DrawFocusrect( fRect );
  fRect.Right := X;
  fRect.Bottom := Y;
  Canvas.DrawFocusrect( fRect );
  End;
  end;

  procedure TForm2.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  begin
  If fDragging Then Begin
  Canvas.DrawFocusrect( fRect );
  fDragging := False;
  ... here would go the code to mark all the controls in fRect as
  selected.
  End;
  end;
*)

Procedure GetPrinterDriversNames(Var AList: TStringList);
Var
  i: integer;
begin
  For i := Printer.Printers.Count - 1 downto 0 do
    AList.Add(Printer.Printers[i]);
end;

procedure SetDefaultPrinter(PrinterName: String);
var
  j: integer;
  Device: PChar;
  Driver: PChar;
  Port: PChar;
  HdeviceMode: THandle;
  aPrinter: TPrinter;

  arrWindows: array [0 .. 64] of char;
  AList: TStringList;
  Ndx: integer;
begin
  AList := TStringList.Create;
  PrinterName := UpperCase(PrinterName);
  GetPrinterDriversNames(AList);
  Ndx := IsInList(PrinterName, AList);
  If Ndx < 0 then
  begin
    ShowMessage('Printer driver ' + PrinterName + ' is not installed');
    AList.Free;
    Exit;
  end;
  PrinterName := AList[Ndx]; // exact name

  Printer.PrinterIndex := -1;
  getmem(Device, 255);
  getmem(Driver, 255);
  getmem(Port, 255);
  aPrinter := TPrinter.Create;
  for j := 0 to Printer.Printers.Count - 1 do
  begin
    if Printer.Printers[j] = PrinterName then
    begin
      aPrinter.PrinterIndex := j;
      aPrinter.getprinter(Device, Driver, Port, HdeviceMode);
      StrCat(Device, ',');
      StrCat(Device, Driver);
      StrCat(Device, Port);
      WriteProfileString('windows', 'device', Device);
      StrCopy(Device, 'windows');
      StrCopy(arrWindows, 'windows');
      SendMessage(HWND_BROADCAST, WM_WININICHANGE, 0, LongInt(@arrWindows));
    end;
  end;
  Freemem(Device, 255);
  Freemem(Driver, 255);
  Freemem(Port, 255);
  aPrinter.Free;
end;

Function IsPrinterInstalled(PrinterName: String): Boolean;
// 20170811 Igor >>>
Var
  AList: TStringList;
begin
  AList := TStringList.Create;
  try
    PrinterName := UpperCase(PrinterName);
    GetPrinterDriversNames(AList);
    Result := IsInList(PrinterName, AList) > -1;
  finally
    AList.Free;
  end;
  // 20170811 Igor >>>
end;

function GetDefaultPrinterName: string;
begin
  if (Printer.PrinterIndex > 0) then
  begin
    Result := Printer.Printers[Printer.PrinterIndex];
  end
  else
    Result := '';
end;

procedure GetFileList(FDirectory, Filter: TFileName; SomeList: TStringList);
var
  ARec: TSearchRec;
  Res: integer;
begin
  if FDirectory[Length(FDirectory)] <> '\' then
    FDirectory := FDirectory + '\';
  try
    Res := FindFirst(FDirectory + Filter, faAnyFile, ARec);
    while Res = 0 do
    begin
      if FileExists(FDirectory + ARec.Name) then
        SomeList.Add(FDirectory + ARec.Name);

      Res := FindNext(ARec);
    end;
    SysUtils.FindClose(ARec);
  except
    on E: Exception do
    begin
      ExceptMsg(E);
      // Result.Free;
      // Result := nil; //!!!
    end;
  end;
end;

Function GetPlannerDir: String;
begin
  Result := OptRec.Dir_Planner;
end;

Function ValidEMail(S: String): Boolean;
Begin
  Result := true;
  If S = '' then
    Exit;
  if (Pos('@', S) <= 0) or (Pos('.', S) <= 0) Then
    Result := false;
end;

Procedure ExtractFromHelpCnt(CntRec: String; Var Descr: String;
  Var KeyW: String);
// comes as 2 Preparer Configuration=Preparer_Configuration
Var
  k: integer;
Begin
  k := Pos('=', CntRec);
  If k > 0 then
  begin
    Descr := LeftStr(CntRec, k - 1);
    KeyW := MidStr(CntRec, k + 1, 100);
    // indent descriptions for treeview
  end;
end;

Procedure LoadHelpCntInTreeView(HelpCntFile: String; ATreeView: TTreeView;
  Var HelpKeyW: TStringList);
Var
  TempList: TStringList;
  Descr, KeyW: String;
var
  i: integer;
begin
  ATreeView.Items.Clear;
  HelpKeyW.Clear;
  TempList := TStringList.Create;
  If Not FileExists(HelpCntFile) then
  begin
    ShowMessage('Help file ' + HelpCntFile + ' was not found');
    Exit;
  end;
  TempList.LoadFromFile(HelpCntFile);
  For i := 1 to TempList.Count - 1 do
  begin
    ExtractFromHelpCnt(TempList[i], Descr, KeyW);
    HelpKeyW.Add(KeyW);
    // indents for tree view
    If LeftStr(Descr, 1) = '1' then
      Descr := MidStr(Descr, 3, 100)
    else If LeftStr(Descr, 1) = '2' then
      Descr := Space(1) + MidStr(Descr, 3, 100)
    Else if LeftStr(Descr, 1) = '3' then
      Descr := Space(2) + MidStr(Descr, 3, 100)
    Else if LeftStr(Descr, 1) = '4' then
      Descr := Space(3) + MidStr(Descr, 3, 100)
    Else if LeftStr(Descr, 1) = '5' then
      Descr := Space(4) + MidStr(Descr, 3, 100)
    Else if LeftStr(Descr, 1) = '6' then
      Descr := Space(5) + MidStr(Descr, 3, 100);
    TempList.Add(Descr);
  end;
  TempList.SaveToFile(AppDir + '\' + 'Temp');
  ATreeView.LoadFromFile(AppDir + '\' + 'Temp');
  TempList.Free;
end;

// 20160602 Igor Move to vtTrimStr
// Function IncrementlastBackUpDir(LastBackUp:String):String;
// Var k:Integer;OldNo,NewNo:String;
// begin
// OldNo:=RightStr(Lastbackup,2);
// If NumbersOnly(OldNo) then
// begin
// NewNo:=PaddZero(IntToStr(MyStrToInt(OldNo)+1),2);
// Result:=LeftStr(LastBackUp,Length(LastBackUp)-2)+NewNo;
// end
// else
// result:=ExtractFileDir(LastBackUp)+'\'+'Backup01';
// end;
// 20170811 Igor>>>
Function CopyMoveReturn(const CopyOrMove, fromDir, toDir,
  FlName: String): Boolean;
Var
  RetNo: integer;
  Err: String;
begin
  If SysUtils.FileExists(IncludeTrailingPathDelimiter(toDir) + ClientsTable_dbf)
  then
  begin
    ShowMessage(toDir + Chr(13) +
      'The data directory is NOT compatible with the Multi-App version.' + #13 +
      'Please use another data directory, such as ' + OptRec.Dir_Cur +
      ' in the Copy/Move window');
    Exit(false);
  end;
  If Not SysUtils.DirectoryExists(toDir) then
  begin
    if not SysUtils.ForceDirectories(toDir) Then
      Exit(false);
  end;
  if not CopyFile(IncludeTrailingPathDelimiter(fromDir) + FlName,
    IncludeTrailingPathDelimiter(toDir) + FlName) then
    Exit(false);
  If Not SysUtils.FileExists(IncludeTrailingPathDelimiter(toDir) +
    ClientsDBLite) and not InitDataBase(toDir, Err) then // 20171031 igor
  begin
    MessageDlg(Err, mtError, [mbOk], 0);
    Exit(false);
  end;
  // read file
  RetNo := ReadReturn(toDir, FlName);
  If RetNo < 1 then
    Exit(false);
  try
    UpdateClientsTable(RetNo, toDir, FlName);
    UpdateMostRecentFiles(RetNo, toDir, FlName, GetSinNo(RetNo));
  finally
    RemoveReturnFromMemory(RetNo);
  end;
  If CopyOrMove = 'M' then
    DeleteReturn(fromDir, FlName);
  Result := true;
  // 20170811 Igor<<<
end;

Function DeleteReturn(Dir, FlName: String; ATable: TADTable = nil): Boolean;
// 20170210 Igor
// 20160226 Igor >>>>
var
  ADConnection: TADConnection;
  Table1: TADTable;
  // 20170210 Igor >>>
  DelFromDB, DelFromHDD: Boolean;
  B: TBookmark;
  CountRecord: integer;
  RecordList: String;
begin
  Result := false;
  DelFromDB := false;
  DelFromHDD := false;
  if ATable <> nil then
    Table1 := ATable
  else
  begin
    // 20150922 Igor
    ADConnection := TADConnection.Create(Application);
    Table1 := TADTable.Create(Application);
    if not SetTableName(ADConnection, Table1, Dir + '\' + ClientsDBLite,
      ClientsTableLite, 'File_Name') then
    Begin
      FreeAndNil(ADConnection);
      FreeAndNil(Table1);
      DelFromDB := true;
    End;
  End;

  if not DelFromDB then
    try
      if not Table1.Active then
        Table1.Open;
      if not SameText(Table1.FieldByName('FILE_NAME').AsString, FlName) then
        if not Table1.Locate('FILE_NAME', FlName, [loCaseInsensitive]) then
          DelFromDB := true;

      if not DelFromDB then
      begin
        B := Table1.GetBookmark;
        Table1.DisableControls;
        try
          Table1.First;
          CountRecord := 0;
          while not Table1.EOF do
          begin
            if SameText(Table1.FieldByName('FILE_NAME').AsString, FlName) then
            begin
              inc(CountRecord);
              RecordList := RecordList + '    ' +
                Table1.FieldByName('LAST_NAME').AsString + ' ' +
                Table1.FieldByName('FIRST_NAME').AsString + #13;
            end;
            Table1.Next;
          end;
        finally
          Table1.GotoBookmark(B);
          Table1.EnableControls;
          Table1.FreeBookmark(B);
        end;
        if CountRecord = 1 then
        begin
          if MessageDlg('Delete file "' + FlName + '" and record in database?',
            mtConfirmation, [mbYes, mbCancel], 0) = mrYes then
          begin
            Table1.Delete;
            DelFromDB := true;
          end
          else
            Exit;
        end
        else
        begin
          case MessageDlg('Attention!' + #13 + 'File "' + FlName +
            '" is specified as the data source for ' + IntToStr(CountRecord) +
            ' entries:' + #13 + RecordList + #13 +
            'Press [Yes] - for remove only current record in the database and leave the file to other records. '
            + #13 + 'Press [All] - for delete all records that are linked to this file and delete the file.',
            mtWarning, [mbYes, mbAll, mbCancel], 0) of
            mrYes:
              begin
                Table1.Delete;
                DelFromDB := true;
                DelFromHDD := true;
              end;
            mrAll:
              begin
                while Table1.Locate('FILE_NAME', FlName, [loCaseInsensitive]) do
                  Table1.Delete;
                DelFromDB := true;
              end;
            mrCancel:
              Exit;
          end;
        end;
      end;
    finally
      if ATable = nil then
      Begin
        Table1.Free;
        ADConnection.Free;
      End;
    end;
  if DelFromDB and not DelFromHDD then
  begin
    if FileExists(IncludeTrailingPathDelimiter(Dir) + FlName) then
      DelFromHDD := SysUtils.DeleteFile(IncludeTrailingPathDelimiter(Dir) +
        '\' + FlName)
    else
      DelFromHDD := true;
  end;
  Result := DelFromDB and DelFromHDD;
  // 20170210 Igor <<<
end;

(* 20170210
  Function DeleteReturn(Dir, FlName:String):Boolean;
  //20160226 Igor >>>>
  var ADConnection: TADConnection;
  Table1: TADTable;
  begin
  Result := False;
  if FileExists(Dir + '\' + FlName) then
  SysUtils.DeleteFile(Dir + '\' + FlName);

  //20150922 Igor
  ADConnection:= TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  if not SetTableName(ADConnection, Table1, OptRec.Dir_Cur + '\' + ClientsDBLite, ClientsTableLite, 'File_Name') then
  Begin
  if assigned(ADConnection) then
  freeAndNil(ADConnection);
  if assigned(Table1) then
  freeAndNil(Table1);
  Result := True;
  exit;
  End;
  try
  if Table1.FindKey([FlName]) = True then
  begin
  Table1.Edit;
  Table1.Delete;
  Result := True;
  end;
  Table1.Close;
  finally
  Table1.Free;
  ADConnection.Free;
  end;
  end;
*)
Function GetLastYearTaxYear: String;
begin
  Result := IntToStr(StrToInt(AppYear) - 1);
end;

Procedure RemoveLinkToLastYearRetNo(LastYrRNo: integer);
Var
  i, RNo: integer;
Begin
  for i := 1 to (RetList.Count - 1) do
  begin
    RetRec := RetList.Items[i];
    if RetRec = nil then
      continue;
    RNo := RetRec.RetNo;
    If Assigned(Ret[RNo]) AND (Ret[RNo].LastYearRetNo = LastYrRNo) then
      Ret[RNo].LastYearRetNo := 0; // 20160305 Igor
  end;
end;

Procedure GetLoginNames(Var TempList: TStringList);
begin
  If FileExists(AppDir + '\' + 'LoginNames') then
    TempList.LoadFromFile(AppDir + '\' + 'LoginNames');
end;

Procedure UpdateLoginNames(Nm: String);
Var
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  Nm := UpperCase(Nm);
  If FileExists(AppDir + '\' + 'LoginNames') then
    TempList.LoadFromFile(AppDir + '\' + 'LoginNames');
  If IsInList(Nm, TempList) < 0 then
    TempList.Add(Nm);
  TempList.SaveToFile(AppDir + '\' + 'LoginNames');
  TempList.Free;
end;

Function IsValidCCA(Cls: String): Boolean;
begin
  Result := true;
  If Cls = '' then
    Exit;
  If (VL(Cls) < 1) { or (Vl(Cls)>50) } then
    Result := false;
end;

Function IsEfOverride(RetNo: integer; Lline: integer): Boolean;
Var
  i: integer;
begin
  Result := false;
  If Lline < 1 then
    Exit;
  i := 23;
  repeat
    If Lline = VL(FetchElm(RetNo, 'EFMEMO', i)) then
    begin
      Result := true;
      Exit;
    end;
    inc(i, 2);
  until i > 33;
end;

Function GetEfOverride(RetNo: integer; Lline: integer): Real;
Var
  i: integer;
begin
  Result := 0;
  i := 23;
  repeat
    If Lline = VL(FetchElm(RetNo, 'EFMEMO', i)) then
    begin
      Result := VL(FetchElm(RetNo, 'EFMEMO', i + 1));
      Exit;
    end;
    inc(i, 2);
  until i > 33;
end;

function IsLandscape(FName: String): Boolean;
begin
  Result := FList.ByFormName(FName).LandScape;
End;

Function IsT1273CashMethod(RetNo: integer; FInst: String): Boolean;
begin
  If FetchElm(RetNo, 'T1273' + FInst, 212) = '2' then
    Result := true
  else
    Result := false;
end;

Function CountCropEntries(RetNo: integer; FInst: String): integer;
Var
  i, k: integer;
  FName: String;
  FNo, Cnt1, Cnt2: integer;
begin
  Result := 0;
  Cnt1 := 0;
  Cnt2 := 0;
  FName := 'T1273' + FInst;
  FNo := GetFormNo(FName);
  If FNo = 0 then
    Exit;
  i := 859;
  Repeat
    If FetchElmFNo(RetNo, FNo, i) > '' then
      inc(Cnt1, 1);
    inc(i, 7);
  until i > 943;

  Result := Cnt1 + Cnt2;

end;

Function CountLiveStockEntries(RetNo: integer; FInst: String): integer;
Var
  i, k, FNo: integer;
  FName: String;
  Cnt1, Cnt2: integer;
begin
  Result := 0;
  Cnt1 := 0;
  Cnt2 := 0;
  FName := 'T1273' + FInst;
  FNo := GetFormNo(FName);
  If FNo = 0 then
    Exit;
  i := 807;
  Repeat
    If FetchElmFNo(RetNo, FNo, i) > '' then
      inc(Cnt1, 1);
    inc(i, 4);
  until i > 855;
  Result := Cnt1 + Cnt2;
end;

Function HarmonizedProvince(PRV: String): Boolean;
begin
  If (PRV = 'ON') or (PRV = 'AB') or (PRV = 'PE') then
    Result := false
  else
    Result := true;
end;

Function HarmonizedFarmStead(PRV: String): Boolean;
begin
  If (PRV = 'ON') or (PRV = 'AB') or (PRV = 'PE') then
    Result := false
  else
    Result := true;
end;

// 20180210
Function CountT1163(RetNo: integer): integer;
Var
  i, FNo: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T1163' then
    begin
      FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] then // 20170324 Igor
        inc(Result);
    end;
  end;
end;

Function CountT1273(RetNo: integer): integer;
Var
  i, FNo: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T1273' then
    begin
      FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] then // 20170324 Igor
        inc(Result);
    end;
  end;
end;

// 20170217
Function GetDcnSeqNoEOL(RetNo: integer; OnLineNo: String): String;
Var
  YYYY, MM, DD, Hour, Min, Sec, Msec: word;
  SMM, SDD, SMin, SSec, SMSec: string; // [2];
  Syyyy: string; // [4];
  sBirthday: string; // [2];
  AppYr: String; // 20170217
begin
  Delay(1); // to inceasethe second
  DecodeDate(Now, YYYY, MM, DD);
  DecodeTime(Now, Hour, Min, Sec, Msec);
  Syyyy := AllTrim(IntToStr(YYYY));
  SMM := LTrim(RTrim(IntToStr(MM)));
  SDD := LTrim(RTrim(IntToStr(DD)));
  SMin := LTrim(RTrim(IntToStr(Min)));
  SSec := AllTrim(IntToStr(Sec));
  SMSec := LTrim(RTrim(IntToStr(Msec)));
  If Length(SMM) = 1 then
    SMM := '0' + SMM;
  If Length(SDD) = 1 then
    SDD := '0' + SDD;
  If Length(SMin) = 1 then
    SMin := '0' + SMin;
  If Length(SSec) = 1 then
    SSec := '0' + SSec;
  If Length(SMSec) = 1 then
    SMSec := '0' + SMSec;

  AppYr := RightStr(AppYear, 2);
  // 20170217
  Result := OnLineNo + AppYr + SDD + SSec + SMSec; // 2005
  Result := OnLineNo + AppYr + SDD + SSec + RightStr(GetBirthDate(RetNo), 1) +
    RightStr(SMSec, 1); // 2005
  { 20170217
    Result:=OnlineNo+smm+Sdd+SSec+SMSec;    //2005
    Result:=OnlineNo+smm+Sdd+SSec+RightStr(GetBirthdate(RetNo),1)+RightStr(SMSec,1);    //2005
  }
  If Length(Result) <> 13 then
    Result := '';
end;

(*
  Function GetDcnSeqNoEOL(RetNo:Integer;OnLineNo:String):String;
  Var YYYY,MM,DD,Hour,Min,Sec,Msec :word;
  SMM, SDD, SMin,SSec,SMSec : string; //[2];
  Syyyy:string; //[4];
  sBirthday:string; //[2];
  begin
  Delay(1);  //to inceasethe second
  DecodeDate(Now,YYYY,MM,DD);
  DecodeTime(Now,Hour,Min,Sec,Msec);
  Syyyy:=AllTrim(IntToStr(YYYY));
  SMM   := LTrim(RTrim(IntToStr(MM)));
  SDD   := Ltrim(Rtrim(IntToStr(dd)));
  SMIN  := Ltrim(Rtrim(IntToStr(Min)));
  SSec   := AllTrim(IntToStr(Sec));
  SMSec:=LTrim(RTrim(IntToStr(MSec)));
  If Length(SMM)   =1 then SMM   := '0'+SMM;
  If Length(SDD)   =1 then SDD   := '0'+Sdd;
  If Length(SMIN)  =1 then SMin  := '0'+SMin;
  If Length(SSec)  =1 then SSec  := '0'+SSec;
  If Length(SMSec) =1 then SMSec:= '0'+SMSec;
  Result:=OnlineNo+smm+Sdd+SSec+SMSec;    //2005
  Result:=OnlineNo+smm+Sdd+SSec+RightStr(GetBirthdate(RetNo),1)+RightStr(SMSec,1);    //2005
  If length(result)<> 13 then result:='';
  end;
*)
Function GetSinNoFromAck(DCN: String): String;
// incoming is B0864yymmddss
Var
  MatchDcn: String;
  // lPsw:String; //20160303 Igor
  // 20150825 igor
  FDConnection: TADConnection;
begin
  // fGetSQLitePsw(lPsw); //20150925 igor //20160303 Igor

  IF DCN = '' then
    Exit;
  Result := '';
  MatchDcn := MidStr(DCN, 6, 8);
  // 20160303 Igor >>>
  FDConnection := TADConnection.Create(nil);
  try
    if SetConnection(FDConnection, OptRec.Dir_Cur + '\' + ClientsDBLite,
      ClientsTableLite) then
    Begin
      // with TADConnection.Create(nil) do
      // try
      // DriverName := 'SQLite';
      // Params.Values['DataBase'] := OptRec.Dir_Cur + '\' + ClientsDBLite;
      // //20150904 igor
      // FDConnection.Params.Values['Password'] := lPsw;
      Result := FDConnection.ExecSQLScalar('SELECT SIN FROM ' + ClientsTableLite
        + ' WHERE DCN_NO = ''' + MatchDcn + '');
    End;
  finally
    FDConnection.Free;
  end;
  // 20160303 Igor <<<<
  { Table1 := TADTable.Create(Application);
    Table1.DataBaseName := OptRec.Dir_Cur;
    Table1.TableName := ClientsTable;
    Table1.IndexName := 'DCN_NO';
    Table1.Open;

    if Table1.FindKey([MatchDcn]) then
    Result:=Table1.FieldByName('SIN').AsString;
    Table1.Close;
    Table1.Free; }
end;

Function GetRetFileNameViaDCNNO(DcnNo: String): String;
var
  // 20150825 igor
  FDConnection: TADConnection;
  // lPsw:String; //20160303 Igor
begin
  // fGetSQLitePsw(lPsw); //20150925 igor //20160303 Igor

  IF DcnNo = '' then
    Exit;
  Result := '';
  FDConnection := TADConnection.Create(nil);
  try
    if SetConnection(FDConnection, OptRec.Dir_Cur + '\' + ClientsDBLite,
      ClientsTableLite) then
    Begin
      // with TADConnection.Create(nil) do
      // try
      // DriverName := 'SQLite';
      // Params.Values['DataBase'] := OptRec.Dir_Cur + '\' + ClientsDBLite;
      // //20150904 igor
      // FDConnection.Params.Values['Password'] := lPsw;
      Result := FDConnection.ExecSQLScalar('SELECT SIN FROM ' + ClientsTableLite
        + ' WHERE DCN_NO = ''' + DcnNo + '');
    End;
  finally
    FDConnection.Free;
  end;
  { Result:='';
    // MatchDcn:=MidStr(Dcn,6,8);
    Table1 := TADTable.Create(Application);
    Table1.DataBaseName := OptRec.Dir_Cur;
    Table1.TableName := ClientsTable;
    Table1.IndexName := 'DCN_NO';
    Table1.Open;

    if Table1.FindKey([DcnNo]) then
    Result:=Table1.FieldByName('File_Name').AsString;
    Table1.Close;
    Table1.Free; }
end;

// uncommented 20130513

Function TimeForBackUp: Boolean;
Var
  Dt: TDateTime;
  DateInteger: integer;
begin
  Result := false;
  // does not work with folders!!!
  DateInteger := FileAge(OptRec.LastBackUpDir);
  // DateInteger:=FileAge('C:\Delphi\t1\t12005.exe');
  Dt := FileDateToDateTime(DateInteger);
  FormatDateTime('yyyy-mm-dd', Dt);

  If OptRec.LastBackUpDir = '' then
  begin
    Result := true;
    Exit;
  end;
end;

// 20200313
Procedure SaveT1013Template(RetNo: integer; FName: String);
Var
  TempList: TStringList;
  Valu: String;
  FInst: String;
var
  i: integer;
begin
  FInst := ExtractFormInst(FName);
  TempList := TStringList.Create;
  for i := 1 to 133 do // 131   //20130205
  begin
    Valu := FetchElm(RetNo, 'AUTHREP' + FInst, i);
    If Valu > '' then
      TempList.Add(PaddR(IntToStr(i), 4) + FetchElm(RetNo,
        'AUTHREP' + FInst, i));
  end;
  TempList.SaveToFile(AppDir + '\' + 'AUTHREP.txt');
  TempList.Free;
end;

// 20200313
Procedure LoadT1013Template(RetNo: integer; FName: String);
Var
  TempList: TStringList;
  FNo: integer;
  elm: integer;
  Valu: String;
  FInst: String;
var
  i: integer;
begin
  FInst := ExtractFormInst(FName);
  TempList := TStringList.Create;
  If FileExists(AppDir + '\' + 'AUTHREP.txt') then
  begin
    TempList.LoadFromFile(AppDir + '\' + 'AUTHREP.txt');
    If TempList.Count = 0 then
    begin
      TempList.Free;
      Exit;
    End;
    FNo := GetFormNo('AUTHREP' + FInst);
    // clear it   //20130205
    For i := 1 to 10 do
      StoreElm(RetNo, FNo, i, '');
    For i := 12 to 133 do
      StoreElm(RetNo, FNo, i, '');
    // 20130205
    For i := 0 to TempList.Count - 1 do
    begin
      elm := MyStrToInt(AllTrim(LeftStr(TempList[i], 4)));
      Valu := AllTrim(MidStr(TempList[i], 5, 100));
      If elm <> 11 then // prepared last year
      begin
        If Valu > '' then
          StoreElm(RetNo, FNo, elm, Valu);
      end;
    end;
  end;
  (* 20200313
    // taxpayer info  //20130205
    StoreElm(RetNo, FNo, 3, '');
    StoreElm(RetNo, FNo, 4, '');
    StoreElm(RetNo, FNo, 30, '');
    // StoreElm(RetNo,FNo,29,''); //20160223 Igor
    StoreElm(RetNo, FNo, 20, '');
    StoreElm(RetNo, FNo, 9, '');
    StoreElm(RetNo, FNo, 12, '');
    StoreElm(RetNo, FNo, 13, '');
    StoreElm(RetNo, FNo, 133, ''); // Name at the end //20130228

    StoreElm(RetNo, FNo, 26, 'X'); // prepare it
  *)

  StoreElm(RetNo, FNo, 131, FormatDateTime('yyyy-mm-dd', Date)); // 20110309
  TempList.Free;
  // Calc(RetNo, 'AUTHREP#1'); // 20120301
  OpenForm(RetNo, 'AUTHREP#1', 0);
end;

function ConvertToProper(S: string): string;
var
  iLen, iIndex: integer;
  WList: TStringList;
  SBuffer: String;
var
  i: integer;
begin

  Result := '';
  iLen := Length(S);
  If iLen = 0 then
    Exit;
  S := UpperCase(MidStr(S, 1, 1)) + Lowercase(MidStr(S, 2, iLen));

  WList := TStringList.Create;
  ParseWords(S, ' ', WList);
  For i := 0 to WList.Count - 1 do
  begin
    SBuffer := WList[i];
    SBuffer := UpperCase(MidStr(SBuffer, 1, 1)) +
      Lowercase(MidStr(SBuffer, 2, Length(SBuffer)));
    WList[i] := SBuffer;
    // o'connor
    If MidStr(SBuffer, 2, 1) = Chr(39) then
      WList[i] := LeftStr(SBuffer, 2) + UpperCase(MidStr(SBuffer, 3, 1)) +
        MidStr(SBuffer, 4, 100)
      // RR
    else If UpperCase(LeftStr(SBuffer, 2)) = 'RR' then
      WList[i] := UpperCase(LeftStr(SBuffer, 2)) + MidStr(SBuffer, 3, 100)
    else If Length(SBuffer) = 2 then
    begin
      If (UpperCase(LeftStr(SBuffer, 2)) = 'NE') or
        (UpperCase(LeftStr(SBuffer, 2)) = 'SE') or
        (UpperCase(LeftStr(SBuffer, 2)) = 'NW') or
        (UpperCase(LeftStr(SBuffer, 2)) = 'SW') then
        WList[i] := UpperCase(LeftStr(SBuffer, 2) + MidStr(SBuffer, 3, 100))
    end;
  end;

  Result := '';
  For i := 0 to WList.Count - 1 do
    Result := Result + WList[i] + ' ';
  Result := AllTrim(Result);

  WList.Free;

end;

Function IsJointInvoice(RetNo: integer): Boolean;
begin
  Result := false;
  If FetchElm(RetNo, 'INFO', 121) > '' then
    Result := true;
end;

Function IsJointInvoiceForThisReturn(RetNo: integer): Boolean;
begin
  Result := false;
  If FetchElm(RetNo, 'INFO', 129) > '' then
    Result := true;
end;

Procedure AddSpouseCharges(RetNo: integer);
Var
  i: integer;
  FNo, SpRetNo: integer;
  x: Real;
  EmptyDescrElm, EmptyAmountElm: integer;
begin
  FormatSettings.DecimalSeparator := '.'; // 20150727
  FNo := GetFormNo('INVOICE');
  SpRetNo := GetSpRetNo(RetNo);

  If SpRetNo = 0 then
  begin
    ShowMessage('You must be in coupling mode to add the charges');
    Exit;
  end;

  If SpRetNo > 0 then
  begin
    FindEmptyInvoiceLine(RetNo, FNo, EmptyDescrElm, EmptyAmountElm);
    If (EmptyDescrElm > 0) and (EmptyAmountElm > 0) then
    begin
      StoreElm(RetNo, FNo, EmptyDescrElm, 'Spouse' + Chr(39) + 's ' + AppYear +
        ' Personal Tax Preparation');
      StoreElm(RetNo, FNo, EmptyAmountElm, FormatFloat('######.##',
        VL(FetchElmFNo(SpRetNo, FNo, 219)))); // 20110226
      // Vl(FetchElmFNo(SpRetNo,FNo,19))));
    end;
    // blank out spouses invoice
    For i := 200 to 282 do
      StoreElm(SpRetNo, FNo, i, '');
    StoreElm(SpRetNo, FNo, 286, 'X'); // mark paid
  end;
end;

Procedure FindEmptyInvoiceLine(RetNo: integer; FNo: integer;
  Var EmptyDescrElm: integer; Var EmptyAmountElm: integer);
Var
  k1, k2: integer;
begin
  EmptyDescrElm := 0;
  EmptyAmountElm := 0;
  // 20110226
  k1 := 227;
  k2 := 218;
  If EmptyElms(RetNo, FNo, k1, k2) then
  begin
    EmptyDescrElm := k1;
    EmptyAmountElm := k2;
    Exit;
  end;
  k1 := 228;
  k2 := 234;
  If EmptyElms(RetNo, FNo, k1, k2) then
  begin
    EmptyDescrElm := k1;
    EmptyAmountElm := k2;
    Exit;
  end;
  k1 := 229;
  k2 := 235;
  If EmptyElms(RetNo, FNo, k1, k2) then
  begin
    EmptyDescrElm := k1;
    EmptyAmountElm := k2;
    Exit;
  end;
  k1 := 230;
  k2 := 236;
  If EmptyElms(RetNo, FNo, k1, k2) then
  begin
    EmptyDescrElm := k1;
    EmptyAmountElm := k2;
    Exit;
  end;
  k1 := 231;
  k2 := 237;
  If EmptyElms(RetNo, FNo, k1, k2) then
  begin
    EmptyDescrElm := k1;
    EmptyAmountElm := k2;
    Exit;
  end;
  k1 := 232;
  k2 := 238;
  If EmptyElms(RetNo, FNo, k1, k2) then
  begin
    EmptyDescrElm := k1;
    EmptyAmountElm := k2;
    Exit;
  end;
  k1 := 233;
  k2 := 239;
  If EmptyElms(RetNo, FNo, k1, k2) then
  begin
    EmptyDescrElm := k1;
    EmptyAmountElm := k2;
    Exit;
  end;
  k1 := 240;
  k2 := 242;
  If EmptyElms(RetNo, FNo, k1, k2) then
  begin
    EmptyDescrElm := k1;
    EmptyAmountElm := k2;
    Exit;
  end;
  k1 := 241;
  k2 := 243;
  If EmptyElms(RetNo, FNo, k1, k2) then
  begin
    EmptyDescrElm := k1;
    EmptyAmountElm := k2;
    Exit;
  end;
  k1 := 253;
  k2 := 256;
  If EmptyElms(RetNo, FNo, k1, k2) then
  begin
    EmptyDescrElm := k1;
    EmptyAmountElm := k2;
    Exit;
  end;
  k1 := 254;
  k2 := 257;
  If EmptyElms(RetNo, FNo, k1, k2) then
  begin
    EmptyDescrElm := k1;
    EmptyAmountElm := k2;
    Exit;
  end;
  k1 := 255;
  k2 := 258;
  If EmptyElms(RetNo, FNo, k1, k2) then
  begin
    EmptyDescrElm := k1;
    EmptyAmountElm := k2;
    Exit;
  end;
  k1 := 259;
  k2 := 261;
  If EmptyElms(RetNo, FNo, k1, k2) then
  begin
    EmptyDescrElm := k1;
    EmptyAmountElm := k2;
    Exit;
  end;
  k1 := 260;
  k2 := 262;
  If EmptyElms(RetNo, FNo, k1, k2) then
  begin
    EmptyDescrElm := k1;
    EmptyAmountElm := k2;
    Exit;
  end;
  k1 := 263;
  k2 := 265;
  If EmptyElms(RetNo, FNo, k1, k2) then
  begin
    EmptyDescrElm := k1;
    EmptyAmountElm := k2;
    Exit;
  end;
  k1 := 264;
  k2 := 266;
  If EmptyElms(RetNo, FNo, k1, k2) then
  begin
    EmptyDescrElm := k1;
    EmptyAmountElm := k2;
    Exit;
  end;
  k1 := 267;
  k2 := 269;
  If EmptyElms(RetNo, FNo, k1, k2) then
  begin
    EmptyDescrElm := k1;
    EmptyAmountElm := k2;
    Exit;
  end;
  k1 := 268;
  k2 := 270;
  If EmptyElms(RetNo, FNo, k1, k2) then
  begin
    EmptyDescrElm := k1;
    EmptyAmountElm := k2;
    Exit;
  end;
end;

Function GetBirthDate(RetNo: integer): String;
begin
  Result := FetchElm(RetNo, 'INFO', 9); // 20140129
  // result:=RightStr(FetchElm(RetNo,'INFO',9),1);
end;

Function GetDateOfBirth(RetNo: integer): String;
begin
  Result := FetchElm(RetNo, 'INFO', 9);
end;

Function EmptyElms(RetNo, FNo, Elm1, Elm2: integer): Boolean;
begin
  Result := false;
  If (FetchElmFNo(RetNo, FNo, Elm1) = '') and
    (FetchElmFNo(RetNo, FNo, Elm2) = '') then
    Result := true;
end;

Function ConvertToPixelsX(x: Real; PixPerInX: integer): integer;
begin
  Result := Trunc(x * PixPerInX);
end;

Function ConvertToPixelsY(Y: Real; PixPerInY: integer): integer;
begin
  Result := Trunc(Y * PixPerInY);
end;

Function DoubleSpaced(S: String): String;
Var
  i: integer;
begin
  Result := '';
  For i := 1 to Length(S) do
    Result := Result + S[i] + ' ';
end;

Function DoubleDoubleSpaced(S: String): String;
Var
  i: integer;
begin
  Result := '';
  For i := 1 to Length(S) do
    Result := Result + S[i] + ' ' + ' ';
end;

Function LinkToSelf(InitialFormName: String; TargetFormName: String): Boolean;
begin
  Result := false;
  If ExtractFormRootName(InitialFormName) = ExtractFormRootName(TargetFormName)
  then
    Result := true;
end;

Function GetPreparerInfo(RedirectToSite: String): String;
Var
  PrepInfo: String;
  EfileNo: String;
begin
  EfileNo := GetEOLAgentNo;
  If EfileNo = '' then
    GetEOLPAgentNo;
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
end;

Procedure GetDependantsForTransit(RetNo: integer);
// into somelist
Var
  i, FNo: integer;
begin
  SomeList.Clear;
  SomeList.Add(GetFirstName(RetNo) + ' ' + GetLastName(RetNo));
  If Ret[RetNo].MarStatus < 3 then
    SomeList.Add(GetSpouseFirstName(RetNo) + ' ' + GetSpouseLastName(RetNo));
  FNo := GetFormNo('DEPEND');
  i := 5;
  repeat
    If FetchElmFNo(RetNo, FNo, i) > '' then
      If CalcAge(FetchElmFNo(RetNo, FNo, i + 5)) < 19 then
      Begin
        SomeList.Add(FetchElmFNo(RetNo, FNo, i) // first nm
          + ' ' + FetchElmFNo(RetNo, FNo, i + 1)); // last
      end;
    i := i + 15;
  until i > 125;
end;

Procedure GetKidsUnder6ForNs6372(RetNo: integer);
// into somelist
Var
  i, FNo: integer;
begin
  SomeList.Clear;
  FNo := GetFormNo('DEPEND');
  i := 5;
  repeat
    If (FetchElmFNo(RetNo, FNo, i) > '') and
      (UpperCase(FetchElmFNo(RetNo, FNo, i + 14)) <> 'Y')
    // not eligible dependant //20181128
    then
      SomeList.Add(PaddR(FetchElmFNo(RetNo, FNo, i) + ' ' + FetchElmFNo(RetNo,
        FNo, i + 1), 40) + PaddR(FetchElmFNo(RetNo, FNo, i + 6), 10) +
        PaddR(FetchElmFNo(RetNo, FNo, i + 5), 10)); // f-last-rel-birth
    i := i + 15;
  until i > 125;
end;

Procedure GetKidsUnder6(RetNo: integer);
// into somelist
Var
  i, FNo: integer;
begin
  SomeList.Clear;
  FNo := GetFormNo('DEPEND');
  i := 5;
  repeat
    If FetchElmFNo(RetNo, FNo, i) > '' then
      If CalcAge(FetchElmFNo(RetNo, FNo, i + 5)) < 6 then
      Begin
        SomeList.Add(PaddR(FetchElmFNo(RetNo, FNo, i) + ' ' + FetchElmFNo(RetNo,
          FNo, i + 1), 40) + PaddR(FetchElmFNo(RetNo, FNo, i + 6), 10) +
          PaddR(FetchElmFNo(RetNo, FNo, i + 5), 10)); // f-last-rel-birth
      end;
    i := i + 15;
  until i > 125;
end;

(* duplicate
  //20170310
  Function CountKidsUnder6(RetNo:Integer):Integer;
  Var i,FNo:Integer;
  begin
  Result:=0;
  Fno := GetFormNo('DEPEND');
  i := 5;
  repeat
  If FetchElmFNo(RetNo,FNo,i)>''  then
  If CalcAge(FetchElmFNo(RetNo,FNo,i+5))<6 then Result:=Result+1;
  i := i+15;
  until i>125;
  end;
*)

Function IsIncomeLowerForUCCB(RetNo: integer): Boolean;
begin
  If Ret[RetNo].Lnn[23600] - Ret[RetNo].Lnn[11700] - Ret[RetNo].Lnn[23500] <=
  // -Ret[RetNo].Lnn[21400]<=
    VL(FetchElm(RetNo, 'INFO', 19)) - VL(FetchElm(RetNo, 'INFO', 131)) then
    // spouses
    Result := true
  else
    Result := false;
end;

Function GetSpouseUCCB(RetNo: integer): Real;
Var
  SpRetNo: integer;
begin
  Result := VL(FetchElm(RetNo, 'INFO', 131));
end;

Function GetTotalUCCB(RetNo: integer): Real;
Var
  SpRetNo: integer;
begin
  If Ret[RetNo].Lnn[11700] > 0 then
    Result := Ret[RetNo].Lnn[11700]
  else
    Result := GetSpouseUCCB(RetNo);
end;

Function GetTotalRDSP(RetNo: integer): Real;
Var
  SpRetNo: integer;
begin
  Result := Ret[RetNo].Lnn[12500] + GetSpouseRDSP(RetNo);
end;

Function GetSpouseRDSP(RetNo: integer): Real;
Var
  SpRetNo: integer;
begin
  Result := VL(FetchElm(RetNo, 'S2', 33));
end;

Function MinString(S1, S2: String): String;
begin
  Result := S1;
  If RTrim(S2) < RTrim(S1) then
    Result := S2;
end;

Function MaxString(S1, S2: String): String;
begin
  Result := S1;
  If RTrim(S2) > RTrim(S1) then
    Result := S2;
end;

Function GetFormHeight(FName: string): integer;
Var
  i: integer;
begin
  Result := 1050;
  FName := ExtractNonInstFormName(FName);
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = FName then
    begin
      if FRec.FormHeight < 700 then
        Result := 700
      else if FRec.FormHeight > 1050 then
        Result := 1050
      else
        Result := FRec.FormHeight;
      Exit;
    end;
  end;
end;

Function GetAddBlankPg(FName: string): Boolean;
begin
  Result := FList.ByFormName(FName).AddBlankPg;
end;

Procedure GetListOfBusiness(RetNo: integer; AList: TStringList);
Var
  i: integer;
Begin
  AList.Clear;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If Ret[RetNo].FrmHasData[FRec.FormNo] then // 20160813  //20170324 Igor
    begin
      if FRec.FormName = 'T2125' then // 20101218
        AList.Add(PaddR(FRec.FormInstName, 13) + FetchElmFNo(RetNo,
          FRec.FormNo, 8))
      Else if FRec.FormName = 'T2121' then
        AList.Add(PaddR(FRec.FormInstName, 13) + FetchElmFNo(RetNo,
          FRec.FormNo, 61))
      Else if FRec.FormName = 'T2042' then
        AList.Add(PaddR(FRec.FormInstName, 13) + FetchElmFNo(RetNo,
          FRec.FormNo, 8))
      Else if FRec.FormName = 'T1163' then
        AList.Add(PaddR(FRec.FormInstName, 13))
      Else if FRec.FormName = 'T1273' then
        AList.Add(PaddR(FRec.FormInstName, 13))
      Else if FRec.FormName = 'T776' then // 20101218
        AList.Add(PaddR(FRec.FormInstName, 13) + FetchElmFNo(RetNo,
          FRec.FormNo, 45));
    end;
  end;
end;

Procedure GetListOfStatementsForAutos(RetNo: integer; AList: TStrings);
Var
  i: integer;
Begin
  AList.Clear;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If Ret[RetNo].FrmHasData[FRec.FormNo] then // 20160813   //20170324 Igor
    begin
      if FRec.FormName = 'T2125' then // 20101218
      begin
        If FRec.FormInst = '#1' then
          AList.Add(PaddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst,
            13) + FetchElmFNo(RetNo, FRec.FormNo, 8))
        Else If Ret[RetNo].FrmHasData[FRec.FormNo] then // 20170324 Igor
          AList.Add(PaddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst,
            13) + FetchElmFNo(RetNo, FRec.FormNo, 8)) // 20160813
      end

      Else if FRec.FormName = 'T2121' then
      begin
        If FRec.FormInst = '#1' then
          AList.Add(PaddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst,
            13) + FetchElmFNo(RetNo, FRec.FormNo, 61))
        Else If Ret[RetNo].FrmHasData[FRec.FormNo] then // 20170324 Igor
          AList.Add(PaddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst,
            13) + FetchElmFNo(RetNo, FRec.FormNo, 8)) // 20160813
      end

      Else if FRec.FormName = 'T2042' then
      begin
        If FRec.FormInst = '#1' then
          AList.Add(PaddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst,
            13) + FetchElmFNo(RetNo, FRec.FormNo, 8))
        Else If Ret[RetNo].FrmHasData[FRec.FormNo] then // 20170324 Igor
          AList.Add(PaddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst,
            13) + FetchElmFNo(RetNo, FRec.FormNo, 8)) // 20160813
      end

      Else if FRec.FormName = 'T1163' then
      begin
        If FRec.FormInst = '#1' then
          AList.Add(PaddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst,
            13) + FetchElmFNo(RetNo, FRec.FormNo, 8))
        Else If Ret[RetNo].FrmHasData[FRec.FormNo] then // 20170324 Igor
          AList.Add(PaddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst,
            13) + FetchElmFNo(RetNo, FRec.FormNo, 8)) // 20160813
      end

      Else if FRec.FormName = 'T1273' then
      begin
        If FRec.FormInst = '#1' then
          AList.Add(PaddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst,
            13) + FetchElmFNo(RetNo, FRec.FormNo, 65))
        Else If Ret[RetNo].FrmHasData[FRec.FormNo] then // 20170324 Igor
          AList.Add(PaddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst,
            13) + FetchElmFNo(RetNo, FRec.FormNo, 65)) // 20160813
      end

      Else if FRec.FormName = 'T776' then // 20101218
      begin
        If FRec.FormInst = '#1' then
          AList.Add(PaddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst,
            13) + FetchElmFNo(RetNo, FRec.FormNo, 45))
        Else If Ret[RetNo].FrmHasData[FRec.FormNo] then
          // 20160813  //20170324 Igor
          AList.Add(PaddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst,
            13) + FetchElmFNo(RetNo, FRec.FormNo, 45))
      end

      { experimental
        Else if FRec.FormName = 'T777' then // 20200509
        begin
        AList.Add(PaddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst,13));
        // + FetchElmFNo(RetNo, FRec.FormNo, 45))
        end;
      }
    end;
  end;

end;

Function GetTxblIncBeforeLine253(RetNo: integer): Real;
begin
  With Ret[RetNo] do
  begin
    Result := MaxR(0, Lnn[23600] - Lnn[24400] - Lnn[24900]
      // -Lnn[248] //20181109
      - Lnn[25000] - Lnn[25100] - Lnn[25200] - Lnn[25400] - Lnn[25500] -
      Lnn[25600]);
    // 254 is zero by design
  end;
end;

Function GetTxblIncBeforeLine254(RetNo: integer): Real;
begin
  With Ret[RetNo] do
  begin
    Result := MaxR(0, Lnn[23600] - Lnn[24400] - Lnn[24900]
      // -Lnn[248] //20181109
      - Lnn[25000] - Lnn[25100] - Lnn[25200] - Lnn[25300] - Lnn[25500] -
      Lnn[25600]);
  end;
end;

Function CountKidsUnder6(RetNo: integer): integer;
Var
  i, FNo: integer;
begin
  Result := 0;
  FNo := GetFormNo('DEPEND');
  i := 5;
  repeat
    If ((FetchElmFNo(RetNo, FNo, i) > '') and
      (CalcAge(FetchElmFNo(RetNo, FNo, i + 5)) < 6)) then
      Result := Result + 1;
    i := i + 15;
  until i > 125;
end;

Function CountKidsUnder18(RetNo: integer): integer;
Var
  i, FNo: integer;
begin
  Result := 0;
  FNo := GetFormNo('DEPEND');
  i := 5;
  repeat
    If ((FetchElmFNo(RetNo, FNo, i) > '') and
      (CalcAge(FetchElmFNo(RetNo, FNo, i + 5)) < 18)) then
      Result := Result + 1;
    i := i + 15;
  until i > 125;
  If MyStrToInt(FetchElmFNo(RetNo, FNo, 1)) > 9 then
    Result := MyStrToInt(FetchElmFNo(RetNo, FNo, 1));
end;

Function IsLowerIncomeSpouse(RetNo: integer): Boolean;
begin
  If Ret[RetNo].MarStatus > 2 then
  begin
    Result := true;
    Exit;
  end; // not married
  If Ret[RetNo].Lnn[23600] <= VL(FetchElm(RetNo, 'INFO', 19)) then
    Result := true
  else
    Result := false;
end;

Function YYYYMMDDToDDMMYYYY(InputDate: String): string;
{ input date in form yyyy-mm-dd, output as mm/dd/yyyy for datediff }
begin
  Result := '';
  If InputDate = '' then
    Exit;
  Result := MidStr(InputDate, 6, 2) + '/' + RightStr(InputDate, 2) + '/' +
    LeftStr(InputDate, 4);
end;

Function GetRenamedFName(FName: String): String;
Var
  TempList: TStringList;
  FInst: String;
var
  i: integer;
begin
  Result := FName; // '';   //20110220
  If FName = 'PAGE_2' then
    FName := 'PAGE_1';
  If FName = 'PAGE_3' then
    FName := 'PAGE_1';
  If FName = 'PAGE_4' then
    FName := 'PAGE_1';
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir + '\' + 'Substit.d');
  FInst := ExtractFormInst(FName);
  FName := ExtractFormRootName(FName);
  For i := 0 to TempList.Count - 1 do
    If UpperCase(FName) = RTrim(UpperCase(LeftStr(TempList[i], 10))) then
    begin
      Result := UpperCase(AllTrim(MidStr(TempList[i], 14, 10)));
      Result := Result + FInst;
      TempList.Free;
      Exit;
    end;
  TempList.Free;
end;

Function GetPPIPInsurable(RetNo: integer): Real;
Var
  i: integer;
  FNo: integer;
Begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T4' then
    begin
      FNo := FRec.FormNo;
      If FetchElmFNo(RetNo, FNo, 20) = 'QC' then
      begin
        if FetchElmFNo(RetNo, FNo, 43) > '' then
          Result := Result + VL(FetchElmFNo(RetNo, FNo, 43)) { Pnsnbl earnings }
        else
        begin
          Result := Result + VL(FetchElmFNo(RetNo, FNo, 2)); { earnings }
        end;
      end;
    End;
  end; // i

end;

Function GetNonQCT4Box14(RetNo: integer): Real;
Var
  i: integer;
  FNo: integer;
Begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T4' then
    begin
      FNo := FRec.FormNo;
      If FetchElmFNo(RetNo, FNo, 20) <> 'QC' then
      begin
        Result := Result + VL(FetchElmFNo(RetNo, FNo, 2)); // empl income
      end;
    End;
  end; // i
  Result := MinR(Result, Constant[RY].MaxCppPensionableEarnings);
end;

Function GetActualCPPPremiums(RetNo: integer): Real;
Var
  i: integer;
  FNo: integer;
Begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T4' then
    begin
      FNo := FRec.FormNo;
      If FetchElmFNo(RetNo, FNo, 20) <> 'QC' then
      begin
        Result := Result + VL(FetchElmFNo(RetNo, FNo, 3)); // CPP box
      end;
    End;
  end; // i
end;

Function GetActualQPPPremiums(RetNo: integer): Real;
Var
  i: integer;
  FNo: integer;
Begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T4' then
    begin
      FNo := FRec.FormNo;
      If FetchElmFNo(RetNo, FNo, 20) = 'QC' then
      begin
        Result := Result + VL(FetchElmFNo(RetNo, FNo, 4)) // QPP box
      end;
    End;
  end; // i
end;

(*
  //20181204CPP Temp
  Function GetCPPPensionableEarnings(RetNo:Integer;MxCpp:Real):Real;
  Var i:Integer; FNo:Integer;
  Begin

  Result:=0;
  for i :=0 to (FList.Count - 1) do
  begin
  FRec := FList.Items[i];
  //[3]:= CPP premium on t4 slip [4]:=Qpp prem   [10]= Cpp Pensionable earnings
  If Frec.FormName = 'T4'  then
  begin
  FNo:=Frec.FormNo;
  //20181204
  If UpperCase(FetchElmFNo(RetNo,FNo,20)) <> 'QC' then
  begin
  if Vl(FetchElmFNo(RetNo,FNo,10))>0 then
  result:=Result+MinR(Constant[RY].MaxCppPensionable,Vl(FetchElmFNo(RetNo,FNo,10)))   //20140227 //Box 26   //20131203
  Else
  result:=Result+MinR(Constant[RY].MaxCppPensionable,Vl(FetchElmFNo(RetNo,FNo,2)));   //20140227 //Box 26   //20131203
  end;
  End;
  end; //i
  Result:=MinR(Result,MxCpp); //20180101
  end;
*)

Function GetCPPPensionableEarnings(RetNo: integer; MxCpp: Real): Real;
Var
  i: integer;
  FNo: integer;
Begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T4' then
    begin
      FNo := FRec.FormNo;
      If (VL(FetchElmFNo(RetNo, FNo, 3)) > 0) // cpp
        Or ((VL(FetchElmFNo(RetNo, FNo, 3)) = 0) and
        (UpperCase(FetchElmFNo(RetNo, FNo, 20)) <> 'QC')) // 20140219
        or (VL(FetchElmFNo(RetNo, FNo, 3)) = 0) and
        (FetchElmFNo(RetNo, FNo, 46) = '11') // placement office  //20140215
        Or ((VL(FetchElmFNo(RetNo, FNo, 3)) = 0) and
        (FetchElm(RetNo, 'RC381', 43) > '') and
        (UpperCase(FetchElmFNo(RetNo, FNo, 20)) <> 'QC')) // 20140113
      then // cpp premium  //20131206
      begin
        If (VL(FetchElmFNo(RetNo, FNo, 10)) > 0) then // box 26
          Result := Result + MinR(MxCpp, VL(FetchElmFNo(RetNo, FNo, 10)))
          // 20140227 //Box 26   //20131203
        Else
        begin
          If (VL(FetchElmFNo(RetNo, FNo, 3)) = 0) then
          // 20140326  no cpp premium
          // do nothing  //20140612
          Begin // 20140612
            If (UpperCase(FetchElmFNo(RetNo, FNo, 20)) <> 'QC') then
              If FetchElmFNo(RetNo, FNo, 7) = '' then
                // 20180110 if not cpp exempt
                Result := Result + MinR(MxCpp, VL(FetchElmFNo(RetNo, FNo, 2)));
          end
          Else
            Result := Result + MinR(MxCpp, VL(FetchElmFNo(RetNo, FNo, 2)));
          // 20131203  //20140113  uses mxcpp
        end;
      end;
    End;
  end; // i
  // Result := MinR(Result, MxCpp); // 20180101 //jz//20250321 max is per slip not over all, as per form
end;

// jz//20250213 replaced with CZ version
Function GetQPPPensionableEarnings(RetNo: integer; MxQpp: Real): Real;
Var
  i: integer;
  T4FNo: integer;
Begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T4' then
    begin
      T4FNo := FRec.FormNo;
      //jz//20260203 - added if not cpp/qpp exempt, rearranged to make more readable
      If (  (UpperCase(FetchElmFNo(RetNo, T4FNo, 20)) = 'QC') or      // 20250212  if QC slip
            (VL(FetchElmFNo(RetNo, T4FNo, 4)) > 0)                    // empl qpp contr has amount
            or
            (
              (UpperCase(FetchElmFNo(RetNo, T4FNo, 20)) = 'QC')  and
              (VL(FetchElmFNo(RetNo, T4FNo, 4)) = 0)             and
              (FetchElm(RetNo, 'RC381', 43) > '')                     // revoke previous election to stop contr
            )
         )
         and
         (FetchElmFNo(RetNo, T4FNo, 7) = '')                          //jz//20260203 if is not exempt
      then // Qpp premium     //20131206
      begin
        If VL(FetchElmFNo(RetNo, T4FNo, 10)) > 0 then
          Result := Result + MinR(MxQpp, VL(FetchElmFNo(RetNo, T4FNo, 10)))
          // 20140227  //Box 26  //20140113
          // result:=Result+Vl(FetchElmFNo(RetNo,FNo,10))   //Box 26  //20140113
        else
          Result := Result + MinR(MxQpp, VL(FetchElmFNo(RetNo, T4FNo, 2)));
        // empl income  //20140113 uses mxQpp
      end;
    End;
  end; // i
end;

Function GetBox16AFromT4Slips(RetNo: integer): Real; // 20241121
Var
  i: integer;
  FNo: integer;
Begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T4' then
    begin
      FNo := FRec.FormNo;
      Result := Result + VL(FetchElmFNo(RetNo, FNo, 68));
    End;
  end; // i
end;

Function GetBox17FromT4Slips(RetNo: integer): Real; // 20241121
Var
  i: integer;
  FNo: integer;
Begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T4' then
    begin
      FNo := FRec.FormNo;
      Result := Result + VL(FetchElmFNo(RetNo, FNo, 4));
      // 20250131 //Result + VL(FetchElmFNo(RetNo, FNo, 69));
      (*
        If (VL(FetchElmFNo(RetNo, FNo, 3)) > 0) // cpp
        Or ((VL(FetchElmFNo(RetNo, FNo, 3)) = 0) and
        (UpperCase(FetchElmFNo(RetNo, FNo, 20)) <> 'QC')) // 20140219

        or (VL(FetchElmFNo(RetNo, FNo, 3)) = 0) and
        (FetchElmFNo(RetNo, FNo, 46) = '11') // placement office  //20140215

        Or ((VL(FetchElmFNo(RetNo, FNo, 3)) = 0) and
        (FetchElm(RetNo, 'RC381', 43) > '') and
        (UpperCase(FetchElmFNo(RetNo, FNo, 20)) <> 'QC')) // 20140113
        then // cpp premium  //20131206
        begin
        If (VL(FetchElmFNo(RetNo, FNo, 10)) > 0) then // box 26
        Result := Result + MinR(MxCpp, VL(FetchElmFNo(RetNo, FNo, 10)))
        // 20140227 //Box 26   //20131203
        Else
        begin
        If (VL(FetchElmFNo(RetNo, FNo, 3)) = 0) then
        // 20140326  no cpp premium
        // do nothing  //20140612
        Begin // 20140612
        If (UpperCase(FetchElmFNo(RetNo, FNo, 20)) <> 'QC') then
        If FetchElmFNo(RetNo, FNo, 7) = '' then
        // 20180110 if not cpp exempt
        Result := Result + MinR(MxCpp, VL(FetchElmFNo(RetNo, FNo, 2)));
        end
        Else
        Result := Result + MinR(MxCpp, VL(FetchElmFNo(RetNo, FNo, 2)));
        // 20131203  //20140113  uses mxcpp
        end;
        end;
      *)
    End;
  end; // i
  // Result := MinR(Result, MxCpp); // 20180101
end;

Function GetBox17AFromT4Slips(RetNo: integer): Real; // 20250225  CZ
Var
  i: integer;
  FNo: integer;
Begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T4' then
    begin
      FNo := FRec.FormNo;
      Result := Result + VL(FetchElmFNo(RetNo, FNo, 69));
    End;
  end; // i
end;


Function GetQCT4Box14(RetNo: integer): Real;
Var
  i: integer;
  FNo: integer;
Begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T4' then
    begin
      FNo := FRec.FormNo;
      If FetchElmFNo(RetNo, FNo, 20) = 'QC' then
      begin
        If VL(FetchElmFNo(RetNo, FNo, 10)) > 0 then
          Result := Result + VL(FetchElmFNo(RetNo, FNo, 10)) // Box 26
        else
          Result := Result + MinR(Constant[RY].MaxCppPensionableEarnings,
            // 20241121
            VL(FetchElmFNo(RetNo, FNo, 2))); // empl income
      end;
    End;
  end; // i
end;

Function GetNonQCEIPremiums(RetNo: integer): Real;
Var
  i: integer;
  FNo: integer;
Begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T4' then
    begin
      FNo := FRec.FormNo;
      If FetchElmFNo(RetNo, FNo, 20) <> 'QC' then
      begin
        Result := Result + VL(FetchElmFNo(RetNo, FNo, 5)) +
          VL(FetchElmFNo(RetNo, FNo, 44)); // ei and PPIP prem
      end;
    End;
  end; // i
end;

Function AnyQCT4Slip(RetNo: integer): Boolean;
Var
  i: integer;
  FNo: integer;
Begin
  Result := false;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T4' then
    begin
      FNo := FRec.FormNo;
      If FetchElmFNo(RetNo, FNo, 20) = 'QC' then
      begin
        Result := true;
        Exit;
      end;
    End;
  end; // i
end;

Function GetUserCaisCodeDescr(Code,CodeOrDescr: String): String;
Var
  InputString: String;
begin
  if CodeOrDescr = 'D' then InputString := InputBox('Input Box', 'Enter code ', '') //jz//20260225 - get code, change wording
  else                      InputString := InputBox('Input Box', 'Enter description for code ' + Code, '');

  Result := InputString;
end;

Function GetFisherUIEarnings(RetNo: integer): Real;
Var
  i: integer;
  FNo: integer;
Begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T4' then
    begin
      FNo := FRec.FormNo;
      If VL(FetchElmFNo(RetNo, FNo, 35)) > 0 then // fisher income
      begin
        Result := Result + VL(FetchElmFNo(RetNo, FNo, 9));
      end;
    End;
  end; // i
end;

Function FormatT1273Decimals(S: String): String;
Var
  S1, S2: String;
begin
  Result := S;
  S1 := ExtractIntegerPart(S);
  S2 := ExtractDecimalPart(S);
  Result := S1 + '.' + PaddRZero(S2, 3);

  // if S1='1058222' then Result := S1; //special for #15 870000205

  // if length(RemoveKeadingZeros(S1))>=7 then Result:= Result := S1; //20240204

  Result := RmvLeadingZeros(Result);
  If Result = '.000' then
    Result := '0.000';
  if Result = '0' then
    Result := '0.000'; // 20210106

end;

Procedure OpenUsedForms(RetNo: integer);
Var
  i, UsedFNo, FNo: integer;
  FName: String;
Begin
  If OptRec.ShowUsedForms = false then
    Exit;
  UsedFNo := GetFormNo('USEDFRM');
  LockWindowUpdate(Application.MainForm.Handle); // works in T2
  // LockWindowUpdate(RetList[RetNo].MyChild.Handle);
  // RetList[RetNo].MyChild.Hide; - cannot hide MDI child!
  For i := 1 to 15 do
  begin
    FName := AllTrim(FetchElmFNo(RetNo, UsedFNo, i));
    If FName > '' then
    begin
      FNo := GetFormNo(FName);
      If FNo > 0 then
      Begin
        If FName <> 'T1' then
          OpenForm(RetNo, FNo, 0); // 20220220
      End;
    end;
  end;

  // 20150811  Open last used form?
  If OptRec.OpenAtLastForm then
    FName := AllTrim(FetchElmFNo(RetNo, UsedFNo, 31))
  else
    FName := 'INFO';
  FNo := GetFormNo(FName);
  If FNo > 0 then
    OpenForm(RetNo, FNo, 0);

  LockWindowUpdate(0);
end;

Procedure GetAssetsFromDisk(RetNo: integer);
Var
  i, elm, FNo, Inst: integer;
  TempList: TStringList;
  FName, Valu: String;
begin
  FlName := OptRec.Dir_LastYr + '\' + LeftStr(GetSinNo(RetNo), 8) + '.' +
    RightStr(GetSinNo(RetNo), 1);

  If not FileExists(FlName) then
  begin
    ShowMessage('Cannot locate ' + FlName);
    Exit;
  end;
  TempList := TStringList.Create;
  TempList.LoadFromFile(FlName);
  For Inst := 1 to 1 do
  begin
    FName := 'T2124A' + '#' + AllTrim(IntToStr(Inst));
    FNo := GetFormNo(FName);
    If (FNo > 0) and (IsFormInDataList(RetNo, FName, TempList)) then
    begin
      For elm := 1 to 218 do
      begin
        Valu := GetValueFromDisk(RetNo, FName, elm, TempList);
        If Valu > '' then
        begin
          Ret[RetNo].FrmHasData[FNo] := true; // 20170324 Igor
          StoreElm(RetNo, FNo, elm, Valu);
        end;
      end;
    end;
  end;

  TempList.Free;
end;

Function GetValueFromDisk(RetNo: integer; FName: String; elm: integer;
  TempList: TStringList): String;
Var
  i, j: integer;
  Rec: String;
  WList: TStringList; // templist has disk data
begin
  Result := '';
  WList := TStringList.Create;
  j := 0;
  For i := 1 to TempList.Count - 1 do
  begin
    Rec := TempList[i];
    ParseWords(Rec, Delimiter, WList);
    If (WList[0] = 'F') and (WList[1] = FName) then
    begin
      j := i + 1;
      Repeat
        Rec := TempList[j];
        ParseWords(Rec, Delimiter, WList);
        If (WList[0] = 'D') then
        begin
          If VL(WList[1]) = elm then
          begin
            Result := WList[2];
            WList.Free;
            Exit;
          end;
        end;
        inc(j);
      until (j > TempList.Count - 1) or (LeftStr(Rec, 2) = 'F' + Delimiter);
      { end form data }
    end; { within form nm }
  end; { i }
  WList.Free;
end;

Function GetValueFromDataFile(FileName: String; FName: String;
  elm: integer): String;
Var
  i, j: integer;
  Rec: String;
  TempList, WList: TStringList; // templist has disk data
begin
  Result := '';
  TempList := TStringList.Create;
  TempList.LoadFromFile(FileName);
  WList := TStringList.Create;
  j := 0;
  For i := 1 to TempList.Count - 1 do
  begin
    Rec := TempList[i];
    ParseWords(Rec, Delimiter, WList);
    If (WList[0] = 'F') and (WList[1] = FName) then
    begin
      j := i + 1;
      Repeat
        Rec := TempList[j];
        ParseWords(Rec, Delimiter, WList);
        If (WList[0] = 'D') then
        begin
          If VL(WList[1]) = elm then
          begin
            Result := WList[2];
            WList.Free;
            Exit;
          end;
        end;
        inc(j);
      until (j > TempList.Count - 1) or (LeftStr(Rec, 2) = 'F' + Delimiter);
      { end form data }
    end; { within form nm }
  end; { i }
  WList.Free;
  TempList.Free;
end;

Function IsFormInDataList(RetNo: integer; FName: String;
  TempList: TStringList): Boolean;
Var
  i, j: integer;
  Rec: String;
  WList: TStringList; // templist has disk data
begin
  Result := false;
  WList := TStringList.Create;
  j := 0;
  For i := 1 to TempList.Count - 1 do
  begin
    Rec := TempList[i];
    ParseWords(Rec, Delimiter, WList);
    If (WList[0] = 'F') and (WList[1] = FName) then
    begin
      Result := true;
      WList.Free;
      Exit;
    end; { within form nm }
  end; { i }
  WList.Free;
end;

Procedure CopyACBSalesToS3ACB(RetNo: integer);
Var
  i, ii, j, jj, FNo, ACBFNo, Inst: integer;
  Percent: Real;
  FInst: String;
begin
  Inst := 1;
  FInst := '#' + IntToStr(Inst);
  FNo := GetFormNo('S3ACB' + FInst);
  j := 300;
  For i := 1 to j do
  begin
    StoreElm(RetNo, FNo, i, '');
  End;
  // ---
  jj := 2; // S3ACB
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'ACBFRM' then
    begin
      ACBFNo := FRec.FormNo;
      If UpperCase(FetchElmFNo(RetNo, ACBFNo, 1)) = 'Y' then
      begin
        // If Frec.FormInst='#16' then ShowMessage('#16');
        j := 15; // ACBFRM
        Repeat
          If jj > 272 then // need next instance
          begin
            inc(Inst, 1);
            FInst := '#' + IntToStr(Inst);
            begin
              FNo := AddPageInstance(RetNo, 'S3ACB', FInst);
              // clear if already existed?
              For ii := 1 to 300 do
              begin
                StoreElm(RetNo, FNo, ii, '');
              End;
              // FNo:=GetFormNo('S3ACB'+FInst);
              jj := 2; // begining of S3ACB
              Ret[RetNo].FrmHasData[FNo] := true; // 20170324 Igor
            end;
          end;

          Percent := VL(FetchElmFNo(RetNo, ACBFNo, 5)) / 100;
          If (VL(FetchElmFNo(RetNo, ACBFNo, j + 8)) <> 0) and (Percent > 0) and
            (LeftStr(FetchElmFNo(RetNo, ACBFNo, j), 4) = AppYear) then
          begin
            // StoreElm(Retno,FNo,1,'ACBFRM');
            StoreElm(RetNo, FNo, jj, FetchElmFNo(RetNo, ACBFNo, 4));
            // prop type
            StoreElm(RetNo, FNo, jj + 1,
              RemoveChar(FetchElmFNo(RetNo, ACBFNo, j + 2), '-'));
            // positive units
            StoreElm(RetNo, FNo, jj + 2, FetchElmFNo(RetNo, ACBFNo, 5));
            // Percent
            StoreElm(RetNo, FNo, jj + 3, 'Various'); // year aqui
            StoreElm(RetNo, FNo, jj + 4, FetchElmFNo(RetNo, ACBFNo, j + 5));
            // * Percent; //proceeds
            StoreElm(RetNo, FNo, jj + 5,
              RemoveChar(FetchElmFNo(RetNo, ACBFNo, j + 6), '-'));
            StoreElm(RetNo, FNo, jj + 6, FetchElmFNo(RetNo, ACBFNo, j + 7));
            // * Percent; //expenses
            StoreElm(RetNo, FNo, jj + 7, FetchElmFNo(RetNo, ACBFNo, j + 8));
            // * Percent; //Gains/loss
            StoreElm(RetNo, FNo, jj + 8, FetchElmFNo(RetNo, ACBFNo, 3));
            // Descr
            Ret[RetNo].FrmHasData[FNo] := true; // 20170324 Igor
            inc(jj, 9);
          end;
          inc(j, 9);
        until (j > 420); // (jj>272) or (j>420);

      end; // Y for posting
    end; // acbfrm
  end; // i
end;

Function TransferMedical(FromRetNo, ToRetNo: integer): Boolean;
Var
  i, FNo: integer;
  FInst: String;
begin
  Result := false;
  If (VL(FetchElm(FromRetNo, 'MEDICAL', 134)) > 0) then
  begin
    If UpperCase(FetchElm(FromRetNo, 'DEPEND', 140)) = 'Y' then
    begin
      ShowMessage
        ('Transfer not done. Expenses include other dependants claimed by this spouse on line 331');
      Exit;
    end;
  end;

  If (Ret[FromRetNo].CouplingSw) and (ToRetNo > 0) And
    (Ret[ToRetNo].FormHasData['MEDICAL'] = false) then
  begin
    if Ret[FromRetNo].FormHasData['MEDICAL'] then
    begin
      Screen.Cursor := crHourGlass;
      MoveForm(FromRetNo, 'MEDICAL', ToRetNo, 'MEDICAL');
      For i := 1 to 10 do
      begin
        FInst := '#' + AllTrim(IntToStr(i));
        FNo := GetFormNo('MEDSUPL' + FInst);
        if Ret[FromRetNo].FrmHasData[FNo] then // 20170324 Igor
        begin
          If Ret[FromRetNo].Frm[FNo].Count = 0 then
            InitFormData(FromRetNo, FNo);
          MoveForm(FromRetNo, 'MEDSUPL' + FInst, ToRetNo, 'MEDSUPL' + FInst);
        end;
      end;
      Screen.Cursor := crDefault;
      ShowTimedMsg('Done', 1200);
      Result := true;
    end;
  end
  Else
    ShowMessage('Transfer not done.' + Chr(13) + 'You are not in coupling mode'
      + Chr(13) + 'Or Spouse has already medical expenses' + Chr(13) +
      'Or there are no expenses to transfer');
End;

Function TransferDonations(FromRetNo, ToRetNo: integer): Boolean;
Var
  i, FNo, SpFNo, SpRetNo: integer;
  FInst: String;
begin
  Result := false;

  FNo := GetFormNo('DON');
  If VL(FetchElmFNo(FromRetNo, FNo, 88)) <= 0 then
  begin
    ShowMessage('No donations recorded. No transfer done');
    Exit;
  end;
  If FetchElmFNo(FromRetNo, FNo, 6) <> 'Y' then
  begin
    ShowMessage('Include spouse' + Chr(39) +
      ' slips should be set to Yes first. No transfer done');
    Exit;
  end;

  If (AnyNonSlipDonations(FromRetNo) = true) and
    (AnyNonSlipDonations(ToRetNo) = true) then
  begin
    ShowMessage
      ('All non-slip donations should be in one spouse. No transfer done');
    Exit;
  end;

  If (Ret[FromRetNo].CouplingSw) and (ToRetNo > 0) and
    (VL(FetchElmFNo(ToRetNo, FNo, 78)) = 0) then
  begin // move only current year donations
    Screen.Cursor := crHourGlass;
    if Ret[FromRetNo].FrmHasData[FNo] then // 20170324 Igor
    begin
      For i := 1 to 2 do
      begin
        StoreElm(ToRetNo, FNo, i, FetchElmFNo(FromRetNo, FNo, i));
        StoreElm(ToRetNo, FNo, i, '');
        StoreElm(ToRetNo, FNo, 6, 'Y');
        StoreElm(FromRetNo, FNo, 6, 'N');
      end;
      If AnyNonSlipDonations(FromRetNo) = true then
      begin
        For i := 8 to 87 do
        begin
          StoreElm(ToRetNo, FNo, i, FetchElmFNo(FromRetNo, FNo, i));
          StoreElm(FromRetNo, FNo, i, '');
        end;
      end;
      For i := 1 to 10 do
      begin
        FInst := '#' + AllTrim(IntToStr(i));
        FNo := GetFormNo('DONSUPL' + FInst);
        if Ret[FromRetNo].FrmHasData[FNo] then // 20170324 Igor
        begin
          If Ret[ToRetNo].Frm[FNo].Count = 0 then
            InitFormData(ToRetNo, FNo);
          MoveForm(FromRetNo, 'DONSUPL' + FInst, ToRetNo, 'DONSUPL' + FInst);
        end;
      end;
      Calc(FromRetNo, 'DON');
      Calc(ToRetNo  , 'DON');
    end;
    Screen.Cursor := crDefault;
    ShowTimedMsg('Transfer done.', 1200);
    Result := true;
  end
  Else
    ShowMessage('Transfer not done.' + Chr(13) + 'You are not in coupling mode'
      + Chr(13) + 'Or Spouse has already donations claimed' + Chr(13) +
      'Or there are no expenses to transfer');

End;

Function AnyNonSlipDonations(RetNo: integer): Boolean;
Var
  i, FNo: integer;
  x: Real;
begin
  FNo := GetFormNo('DON');
  i := 17;
  x := 0;
  Repeat
    x := x + VL(FetchElmFNo(RetNo, FNo, i));
    inc(i, 5);
  until i > 86;
  If x > 0 then
    Result := true
  else
    Result := false;
end;

Procedure CloneMedical(FromRetNo, ToRetNo: integer);
Var
  i, FNo: integer;
  FInst: String;
begin
  FNo := GetFormNo('MEDICAL');
  If (Ret[FromRetNo].CouplingSw) and (ToRetNo > 0) And
    (Ret[FromRetNo].FrmHasData[FNo] = true) then
  // from has medical//20170324 Igor
  begin
    CloneForm(FromRetNo, 'MEDICAL', ToRetNo, 'MEDICAL', true); // 20170223 Igor
    For i := 1 to 10 do
    begin
      FInst := '#' + AllTrim(IntToStr(i));
      FNo := GetFormNo('MEDSUPL' + FInst);
      If FNo > 0 then // 20101220
      begin
        UpdateThisFormDataIndicator(FromRetNo, GetFormName(FromRetNo, FNo));
        // 20170223 Igor
        if Ret[FromRetNo].FrmHasData[FNo] then // 20170324 Igor
        begin
          If Ret[ToRetNo].Frm[FNo].Count = 0 then
            InitFormData(ToRetNo, FNo); // 20101220
          // If Ret[FromRetNo].Frm[Fno].Count =0 then InitFormData(FromRetNo,FNo);
          CloneForm(FromRetNo, 'MEDSUPL' + FInst, ToRetNo, 'MEDSUPL' + FInst,
            true); // 20170223 Igor
        end;
      end; // Fno>0
    end; // i
  end;
End;

Procedure CloneDonations(FromRetNo, ToRetNo: integer);
Var
  i, FNo, SpFNo, SpRetNo: integer;
  FInst: String;
  MaxElm: integer;
begin
  FNo := GetFormNo('DON');
  If (Ret[FromRetNo].CouplingSw) and (ToRetNo > 0) and
    (VL(FetchElmFNo(FromRetNo, FNo, 180)) + VL(FetchElmFNo(FromRetNo, FNo, 181))
    > 0) // March 5 2008
  then
  begin // move only current year donations
    StoreElm(ToRetNo, FNo, 6, 'Y');
    StoreElm(FromRetNo, FNo, 6, 'N');
    For i := 1 to 5 do
      StoreElm(ToRetNo, FNo, i, FetchElmFNo(FromRetNo, FNo, i));
    For i := 8 to 87 do
      StoreElm(ToRetNo, FNo, i, FetchElmFNo(FromRetNo, FNo, i));
    MaxElm := Ret[FromRetNo].Frm[FNo].Count - 1; // 185!
    For i := 169 to 172 do
      StoreElm(ToRetNo, FNo, i, FetchElmFNo(FromRetNo, FNo, i));
    For i := 186 to 186 do
      StoreElm(ToRetNo, FNo, i, FetchElmFNo(FromRetNo, FNo, i));
    // first time //20170102
    For i := 1 to 10 do
    begin
      FInst := '#' + AllTrim(IntToStr(i));
      FNo := GetFormNo('DONSUPL' + FInst);
      If FNo > 0 then // 20110209
      Begin
        if Ret[FromRetNo].FrmHasData[FNo] then // 20170324 Igor
        begin
          If Ret[ToRetNo].Frm[FNo].Count = 0 then
            InitFormData(ToRetNo, FNo);
          CloneForm(FromRetNo, 'DONSUPL' + FInst, ToRetNo, 'DONSUPL' + FInst);
        end;
      end;
    end;
  end;
End;

Function IsResident(RetNo: integer): Boolean; // 20240424
begin
  Result := false;
  if FetchElm(RetNo, InfoFNo, 226) > '' then
    Result := true;
end;

Function IsNonResident(RetNo: integer): Boolean;
begin
  Result := false;
  If Ret[RetNo].Province = 'ZZ' then
    Result := true;
end;

Function CalcCareGvrClaim(RetNo: integer; Ni: Real; PercentClaim: Real): Real;
Var
  x: Real;
begin
  x := MaxR(0, Constant[RY].CareGvrBase - Ni);
  Result := MinR(x, Constant[RY].MaxCaregvr * Ret[RetNo].PartYear);

  Result := (Result * PercentClaim) / 100;
end;

Function GetRetToOptimize(RetNo, SpRetNo: integer): integer;
begin
  If Ret[RetNo].Lnn[26000] >= Ret[SpRetNo].Lnn[26000] then
    Result := RetNo
  Else
    Result := SpRetNo;
end;

Function CalcInfirmClaim(RetNo: integer; Ni: Real; PercentClaim: Real): Real;
Var
  x: Real;
begin
  x := MaxR(0, Constant[RY].InfirmDependBase - Ni);
  Result := MinR(x, Constant[RY].MaxDependAmount * Ret[RetNo].PartYear);
  Result := (Result * PercentClaim) / 100;
end;

Function CalcPrvInfirmClaim(RetNo: integer; Ni: Real; PercentClaim: Real): Real;
Var
  x: Real;
begin
  Result := 0; // 20170416
  If FullTONIProvince(RetNo) then
  begin
    x := MaxR(0, PrvConstant[RY].PrvInfirmDependBase - Ni);
    Result := MinR(x, PrvConstant[RY].PrvMaxInfirmDependAmount * Ret[RetNo]
      .PartYear);
    Result := (Result * PercentClaim) / 100;
  end;
  UndefMsg('CalcPrvInfirmClaim');
  // Result := 0; //???
end;

Function EligibleForPSplit(RNo: integer): Boolean;
begin
  Result := false;
  If Ret[RNo].CouplingSw = false then
    Exit;
  If IsNonResident(RNo) = true then
    Exit;
  If Ret[RNo].MarStatus < 3 then
  begin
    Result := true;
    Exit;
  End; // married
  If Ret[RNo].MarStatus = 3 then // widow
  begin
    If FetchElm(RNo, 'INFO', 39) > '' then
    begin
      Result := true;
      Exit;
    End; // widow ith mar st changed
  end;
  If IsDeceased(RNo) = true then
  begin
    Result := true;
    Exit;
  End;
end;

Function GetTot306(RetNo: integer): Real; // 20130301
Begin
  Result := VL(FetchElm(RetNo, 'S5', 29)) + VL(FetchElm(RetNo, 'S5', 30));
end;

// 20130301
Function GetTot315(RetNo: integer): Real;
begin
  Result := VL(FetchElm(RetNo, 'S5', 45)) + VL(FetchElm(RetNo, 'S5', 46));
end;

Function GetLn115FromSlips(RetNo: integer): Real;
begin
  Result := MaxR(0, Ret[RetNo].T4APens + Ret[RetNo].T3Pens + Ret[RetNo].T5Pens +
    Ret[RetNo].T4RIFPens + GetRowFromSlip(RetNo, 'FPENS', 4, 3, 0) +
    VL(FetchElm(RetNo, 'PNSDED', 2)) - VL(FetchElm(RetNo, 'PNSDED', 6)));
end;

Procedure SplitMedical(RetNo, SpRetNo: integer; Var LowestTotal: Real;
  TotMedical: Real; Var OptimumMedicalPercent: Real);
Var
  i, MedFNo, OptimizeFNo: integer;
  FamilyTotal: Real;
begin
  MedFNo := GetFormNo('MEDICAL');
  OptimizeFNo := GetFormNo('OPTIMIZE');

  If TotMedical = 0 then
    Exit;
  OptimumMedicalPercent := 0;
  StoreElm(RetNo, MedFNo, 233, '');
  StoreElm(SpRetNo, MedFNo, 233, '');
  i := 0;
  Repeat
    StoreElm(RetNo, OptimizeFNo, 1, '');
    StoreElm(SpRetNo, OptimizeFNo, 6, '');
    StoreElm(RetNo, MedFNo, 233, FormatFloat('###.##', i));
    StoreElm(SpRetNo, MedFNo, 233, FormatFloat('###.##', 100 - i));
    CalcAllForOptimizeAfterTxbl(RetNo);
    FamilyTotal := ExtractFamilyTotal(RetNo, SpRetNo);
    If FamilyTotal <= LowestTotal then
    begin
      OptimumMedicalPercent := i;
      LowestTotal := FamilyTotal;
    end;
    inc(i, 50);
  Until i > 100;

  if VL(FetchElmFNo(RetNo, MedFNo, 160)) = 0 then
    OptimumMedicalPercent := 0; // ! no claim no %
  StoreElm(RetNo, OptimizeFNo, 1, FormatFloat('###.##', OptimumMedicalPercent));
  StoreElm(RetNo, OptimizeFNo, 6, FormatFloat('###.##',
    100 - OptimumMedicalPercent));
end;

Function ExtractFamilyTotal(RetNo, SpRetNo: integer): Real;
begin
  If SpRetNo = 0 then
  begin
    UndefMsg('ExtractFamilyTotal');
    Result := 0; // ???
    Exit;
  end;
  Result := Ret[RetNo].Lnn[43500] - Ret[RetNo].Lnn[48200] + Ret[SpRetNo].Lnn
    [43500] - Ret[SpRetNo].Lnn[48200];
end;

Function GetFedPolCredit(RetNo: integer; PolContr: Real): Real;
Var
  x, Y, z: Real;
  BftBeforePolit, MaxPolitCredit: Real;
begin
  Result := 0;
  If (PolContr > 0) and (PolContr <= 400) then
  begin
    Result := PolContr * 0.75;
    Exit;
  end
  else If (PolContr > 400) and (PolContr <= 750) then
  begin
    Result := 300 + (PolContr - 400) * 0.50;
    Exit;
  end
  else If (PolContr > 750) and (PolContr <= 1275) then
  begin
    Result := 475 + (PolContr - 750) * (33.33 / 100);
    Exit;
  end
  else If PolContr > 1275 then
    Result := 650;

  BftBeforePolit := GetBftBeforePolit(RetNo);
  Result := MinR(Result, BftBeforePolit);

end;

Function CalcPolitContrFromCredit(TotPolit, PolitCredit: Real): Real;
begin
  If PolitCredit >= 650 then
    Result := 1275 // TotPolit //1275
  else If PolitCredit <= 300 then
    Result := MaxR(TotPolit, MinR(400, PolitCredit / 0.75))
  else
    Result := MaxR(TotPolit, MinR(750, (PolitCredit - 300) / 0.50 + 300));
end;

Function GetBftBeforePolit(RNo: integer): Real;
// get Lnn[420] before polit
begin
  With Ret[RNo] do
  begin
    Result := MinR(Lnn[40600], MaxR(0, Lnn[40600] - Lnn[41200] - Lnn[41400]) +
      Lnn[41700] + VL(FetchElm(RNo, 'T1', 129)) // VL(FetchElm(RNo, 'S1', 129))
      + Lnn[41800]);
  end;
end;

Function GetBFTBeforeSplits(RetNo: integer): Real;
Var
  x: Real;
begin
  // exclude S5 (306/315/331), medical, donations, PTransit, Adoption, Home renov, Home buyers
  With Ret[RetNo] do
  begin
    x := Lnn[30000] + Lnn[30100] + Lnn[30300] + Lnn[30400] + Lnn[30800] +
      Lnn[31000] + Lnn[31200] + Lnn[31260] + Lnn[36800] + Lnn[31270] +
      Lnn[31400] + Lnn[31600] + Lnn[31800] + Lnn[31900] + Lnn[32300] +
      Lnn[32400] + Lnn[32600];
    Result := (MaxR(0, VL(FetchElm(RetNo, 'T1', 130)) - x *
      VL(Constant[RY].Rate1) / 100 // nonref claimed already
      - Ret[RetNo].Lnn[40425] // VL(FetchElm(RetNo, 'S1', 105))
      // - VL(FetchElm(RetNo, 'S1', 130))  overseas obsolete
      - Ret[RetNo].Lnn[40427]));
    // min tax carry over //VL(FetchElm(RetNo, 'S1', 106))));

    {
      result := (MaxR(0, VL(FetchElm(RetNo, 'S1', 103)) - x * VL(Constant[RY].Rate1) / 100 // nonref claimed already
      - VL(FetchElm(RetNo, 'S1', 105))
      - VL(FetchElm(RetNo, 'S1', 130))
      - VL(FetchElm(RetNo, 'S1', 106))));
    }
  end;
end;

Procedure InitOtherSplits(RNo: integer; CurRetNo: integer);
var
  OptimizeFNo, DependFNo, DisabFNo, MedFNo, DonFNo, TransitFNo, AdoptFNo,
    PolitFNo, HomeBuyFNo: integer;
  SpRNo: integer;
begin
  OptimizeFNo := GetFormNo('OPTIMIZE');
  DependFNo := GetFormNo('DEPEND');
  DisabFNo := GetFormNo('TRANSF');
  MedFNo := GetFormNo('MEDICAL');
  DonFNo := GetFormNo('DON');
  TransitFNo := GetFormNo('PTRANSIT');
  HomeBuyFNo := GetFormNo('HOMEBUY');
  AdoptFNo := GetFormNo('ADOPT#1');
  PolitFNo := GetFormNo('POLIT');

  // 100% to RNo being optimized
  StoreElm(RNo, DependFNo, 160, '100');
  StoreElm(RNo, DisabFNo, 69, '100');
  StoreElm(RNo, DisabFNo, 70, '100');
  StoreElm(RNo, MedFNo, 233, '100');
  StoreElm(RNo, MedFNo, 236, '100');
  StoreElm(RNo, DonFNo, 179, '100');
  StoreElm(RNo, AdoptFNo, 5, '100');
  StoreElm(RNo, TransitFNo, 79, '100');
  StoreElm(RNo, HomeBuyFNo, 1, '100');
  StoreElm(RNo, PolitFNo, 19, '100');

  SpRNo := GetSpRetNo(CurRetNo);
  StoreElm(SpRNo, DependFNo, 160, '');
  StoreElm(SpRNo, MedFNo, 233, '');
  StoreElm(SpRNo, DisabFNo, 69, '');
  StoreElm(SpRNo, DisabFNo, 70, '');
  StoreElm(SpRNo, MedFNo, 236, '');
  StoreElm(SpRNo, DonFNo, 179, '');
  StoreElm(SpRNo, AdoptFNo, 5, '');
  StoreElm(SpRNo, TransitFNo, 79, '');
  StoreElm(SpRNo, HomeBuyFNo, 1, '');
  StoreElm(SpRNo, PolitFNo, 19, '');
end;

Procedure OptimizeNonRefundableSplits(RetToOptimize: integer;
  Var LowestTotal: Real; CurRetNo: integer);
// applies credits as long as thei BFT basic federal tax
// finds max that can be taken for each credit and then the % by dividing by total available
// Copies percents to respective crdit forms so
// when then the return is calculated it uses the % on the credit forms
Var
  i, RNo, SpRNo, OptimizeFNo, DependFNo, DisabFNo, MedFNo, DonFNo, TransitFNo,
    HomeBuyFNo, AdoptFNo, PolitFNo: integer;
  FamilyTotal: Real;
  BftBeforeSplits, RemainingBft: Real;
  TotMedical330, TotMedical331, TotDonations, DonationsLn349, TotAdoption,
    TotTransit, TotHomeBuy: Real; // 20101212 removed homerenovation
  TotPolit, MaxPolitCredit, OptimumPolit, OptimumPolitPercent,
    BftBeforePolit: Real;
  OptimumMedical330, OptimumMedical331, OptimumDonations, OptimumAdoption,
    OptimumTransit, OptimumHomeBuy: Real;
  OptimumMedical330Percent, OptimumMedical331Percent, OptimumDonationsPercent,
    OptimumAdoptionPercent, OptimumTransitPercent, OptimumHomeBuyPercent: Real;
  Optimum306And315, Optimum306And315Percent, Tot306And315: Real;
  TotDisabXfer, MaxDisabXfer, OptimumDisabXfer, OptimumDisabXferPercent: Real;
  TotEducXfer, MaxEducXfer, OptimumEducXfer, OptimumEducXferPercent: Real;
begin
  OptimizeFNo := GetFormNo('OPTIMIZE');

  If UpperCase(FetchElmFNo(RetToOptimize, OptimizeFNo, 17)) <> 'Y' then
    Exit;
  DependFNo := GetFormNo('DEPEND');
  MedFNo := GetFormNo('MEDICAL');
  DonFNo := GetFormNo('DON');
  TransitFNo := GetFormNo('PTRANSIT');
  HomeBuyFNo := GetFormNo('HOMEBUY');
  AdoptFNo := GetFormNo('ADOPT#1');
  PolitFNo := GetFormNo('POLIT');
  DisabFNo := GetFormNo('TRANSF');

  Tot306And315 := VL(FetchElmFNo(RetToOptimize, OptimizeFNo, 37));
  TotDisabXfer := VL(FetchElmFNo(RetToOptimize, OptimizeFNo, 45));
  TotEducXfer := VL(FetchElmFNo(RetToOptimize, OptimizeFNo, 61));
  TotMedical330 := VL(FetchElmFNo(RetToOptimize, OptimizeFNo, 2));
  TotMedical331 := VL(FetchElmFNo(RetToOptimize, OptimizeFNo, 58));
  TotDonations := VL(FetchElmFNo(RetToOptimize, OptimizeFNo, 10));
  TotAdoption := VL(FetchElmFNo(RetToOptimize, OptimizeFNo, 48));
  TotTransit := VL(FetchElmFNo(RetToOptimize, OptimizeFNo, 7));
  TotHomeBuy := VL(FetchElmFNo(RetToOptimize, OptimizeFNo, 66));
  TotPolit := VL(FetchElmFNo(RetToOptimize, OptimizeFNo, 16));

  InitOtherSplits(RetToOptimize, CurRetNo);
  // put 100% to credit schedules of rettooptimize
  CalcForOptimizeUpToTxbl(RetToOptimize);
  CalcForOptimizeAfterTxbl(RetToOptimize);

  // zero them out
  OptimumMedical330Percent := 0;
  OptimumMedical331Percent := 0;
  OptimumAdoptionPercent := 0;
  OptimumTransitPercent := 0;
  OptimumHomeBuyPercent := 0;
  Optimum306And315Percent := 0;
  OptimumDisabXferPercent := 0;
  OptimumEducXferPercent := 0;
  OptimumDonationsPercent := 0;
  OptimumPolitPercent := 0;

  BftBeforeSplits := GetBFTBeforeSplits(RetToOptimize);
  RemainingBft := MaxR(0, BftBeforeSplits);

  If CurRetNo = RetToOptimize then
    RNo := CurRetNo
  else
    RNo := GetSpRetNo(CurRetNo);


  // watch sequence - the ones than can be c/f to next year are last

  If TotMedical330 > 0 then
  begin
    If (RemainingBft = 0) or (TotMedical330 <= MinR(Constant[RY].MedicalLimit,
      Ret[RetToOptimize].Lnn[23600] * (3 / 100))) then
      OptimumMedical330 := 0
    else
    begin
      OptimumMedical330 := MinR(TotMedical330,
        RemainingBft / (VL(Constant[RY].Rate1) / 100) +
        (MinR(Constant[RY].MedicalLimit, Ret[RetToOptimize].Lnn[23600] *
        (3 / 100))));

      RemainingBft :=
        MaxR(0, RemainingBft -
        (MaxR(0, TotMedical330 - (MinR(Constant[RY].MedicalLimit,
        Ret[RetToOptimize].Lnn[23600] * (3 / 100)))) *
        (VL(Constant[RY].Rate1) / 100)));
      OptimumMedical330Percent := (OptimumMedical330 / TotMedical330) * 100;
      StoreElm(RNo, MedFNo, 233, FormatFloat('###.##',
        OptimumMedical330Percent));
      SpRNo := GetSpRetNo(RNo);
      StoreElm(SpRNo, MedFNo, 233, FormatFloat('###.##',
        100 - OptimumMedical330Percent));
    end;
  end;

  If TotMedical331 > 0 then
  begin
    If RemainingBft = 0 then
      OptimumMedical331 := 0
    else
    begin
      OptimumMedical331 := MinR(TotMedical331,
        RemainingBft / (VL(Constant[RY].Rate1) / 100));
      RemainingBft :=
        MaxR(0, RemainingBft - (OptimumMedical331 *
        (VL(Constant[RY].Rate1) / 100)));
      OptimumMedical331Percent := (OptimumMedical331 / TotMedical331) * 100;
      StoreElm(RNo, MedFNo, 236, FormatFloat('###.##',
        OptimumMedical331Percent));
      SpRNo := GetSpRetNo(RNo);
      StoreElm(SpRNo, MedFNo, 236, FormatFloat('###.##',
        100 - OptimumMedical331Percent));
    end;
  end;

  // calc tot Disab 318 claimable

  If TotDisabXfer > 0 then
  begin
    OptimumDisabXfer := MinR(TotDisabXfer,
      RemainingBft / (VL(Constant[RY].Rate1) / 100));
    RemainingBft := MaxR(0, RemainingBft - OptimumDisabXfer *
      VL(Constant[RY].Rate1) / 100);
    OptimumDisabXferPercent := (OptimumDisabXfer / TotDisabXfer) * 100;
    StoreElm(RNo, DisabFNo, 69, FormatFloat('###.##', OptimumDisabXferPercent));
    // for 318
    SpRNo := GetSpRetNo(RNo);
    StoreElm(SpRNo, DisabFNo, 69, FormatFloat('###.##',
      100 - OptimumDisabXferPercent)); // for 318 ??
  end;

  // calc tot S5 claimable
  If Tot306And315 > 0 then
  begin
    Optimum306And315 := MinR(Tot306And315,
      RemainingBft / (VL(Constant[RY].Rate1) / 100));
    RemainingBft := MaxR(0, RemainingBft - Optimum306And315 *
      VL(Constant[RY].Rate1) / 100);
    Optimum306And315Percent := (Optimum306And315 / Tot306And315) * 100;
    StoreElm(RNo, DependFNo, 160, FormatFloat('###.##',
      Optimum306And315Percent));
    SpRNo := GetSpRetNo(RNo);
    StoreElm(SpRNo, DependFNo, 160, FormatFloat('###.##',
      100 - Optimum306And315Percent));
  end;

  // calc tot Educ 324 claimable
  If TotEducXfer > 0 then
  begin
    OptimumEducXfer := MinR(TotEducXfer,
      RemainingBft / (VL(Constant[RY].Rate1) / 100));
    RemainingBft := MaxR(0, RemainingBft - OptimumEducXfer *
      VL(Constant[RY].Rate1) / 100);
    OptimumEducXferPercent := (OptimumEducXfer / TotEducXfer) * 100;
    StoreElm(RNo, DisabFNo, 70, FormatFloat('###.##', OptimumEducXferPercent));
    // for 324
    SpRNo := GetSpRetNo(RNo);
    StoreElm(SpRNo, DisabFNo, 70, FormatFloat('###.##',
      100 - OptimumEducXferPercent)); // for 324 ??
  end;

  If TotAdoption > 0 then
  begin
    OptimumAdoption := MinR(TotAdoption,
      RemainingBft / (VL(Constant[RY].Rate1) / 100));
    OptimumAdoption := MinR(Constant[RY].MaxAdoption, OptimumAdoption);
    RemainingBft := MaxR(0, RemainingBft - OptimumAdoption *
      VL(Constant[RY].Rate1) / 100);
    OptimumAdoptionPercent := (OptimumAdoption / TotAdoption) * 100;
    StoreElm(RNo, AdoptFNo, 5, FormatFloat('###.##', OptimumAdoptionPercent));
    SpRNo := GetSpRetNo(RNo);
    StoreElm(SpRNo, AdoptFNo, 5, FormatFloat('###.##',
      100 - OptimumAdoptionPercent));
  end;

  If TotDonations > 0 then
  begin
    TotDonations := MinR(TotDonations, Ret[RetToOptimize].Lnn[23600] *
      75 / 100);
    DonationsLn349 := MinR(TotDonations, RemainingBft);
    If DonationsLn349 > 200 * VL(Constant[RY].Rate1) / 100 then
      OptimumDonations := 200 + (DonationsLn349 - 200 * VL(Constant[RY].Rate1) /
        100) / (VL(Constant[RY].Rate4) / 100)
    else
      OptimumDonations := DonationsLn349 / VL(Constant[RY].Rate1) / 100;
    OptimumDonations := MinR(OptimumDonations, TotDonations);
    RemainingBft := MaxR(0, RemainingBft - OptimumDonations);
    OptimumDonationsPercent := (OptimumDonations / TotDonations) * 100;
    StoreElm(RNo, DonFNo, 179, FormatFloat('###.##', OptimumDonationsPercent));
    SpRNo := GetSpRetNo(RNo);
    StoreElm(SpRNo, DonFNo, 179, FormatFloat('###.##',
      100 - OptimumDonationsPercent));
  end;

  If TotTransit > 0 then
  begin
    OptimumTransit := MinR(TotTransit,
      RemainingBft / (VL(Constant[RY].Rate1) / 100));
    RemainingBft := MaxR(0, RemainingBft - OptimumTransit *
      VL(Constant[RY].Rate1) / 100);
    OptimumTransitPercent := (OptimumTransit / TotTransit) * 100;
    StoreElm(RNo, TransitFNo, 79, FormatFloat('###.##', OptimumTransitPercent));
    SpRNo := GetSpRetNo(RNo);
    StoreElm(SpRNo, TransitFNo, 79, FormatFloat('###.##',
      100 - OptimumTransitPercent));
  end;

  If TotHomeBuy > 0 then
  begin
    OptimumHomeBuy := MinR(TotHomeBuy,
      RemainingBft / (VL(Constant[RY].Rate1) / 100));
    RemainingBft := MaxR(0, RemainingBft - OptimumHomeBuy *
      VL(Constant[RY].Rate1) / 100);
    OptimumHomeBuyPercent := (OptimumHomeBuy / TotHomeBuy) * 100;
    StoreElm(RNo, HomeBuyFNo, 1, FormatFloat('###.##', OptimumHomeBuyPercent));
    SpRNo := GetSpRetNo(RNo);
    StoreElm(SpRNo, HomeBuyFNo, 1, FormatFloat('###.##',
      100 - OptimumHomeBuyPercent));
  end;

  If TotPolit > 0 then
  begin
    With Ret[RetToOptimize] do
    begin
      BftBeforePolit := MinR(RemainingBft,
        MaxR(0, RemainingBft - Lnn[41200] - Lnn[41400]) + Lnn[41700] +
        VL(FetchElm(RetToOptimize, 'T1', 129)) + Lnn[41800]); // 20191220
    end;
    MaxPolitCredit := MinR(GetFedPolCredit(RetToOptimize, TotPolit),
      BftBeforePolit);
    OptimumPolit := CalcPolitContrFromCredit(TotPolit, MaxPolitCredit);
    OptimumPolitPercent := (OptimumPolit / TotPolit) * 100;
    SpRNo := GetSpRetNo(RNo);
    If TotPolit > 0 then
      StoreElm(SpRNo, PolitFNo, 19, FormatFloat('###.##',
        100 - OptimumPolitPercent));
  end;
end;

Procedure CopyOptimumSplitsToOptimize(RNo: integer);
Var
  OptimizeFNo, DependFNo, MedFNo, DonFNo, TransitFNo, HomeBuyFNo, AdoptFNo,
    PolitFNo, DisabFNo: integer;
begin
  OptimizeFNo := GetFormNo('OPTIMIZE');
  DependFNo := GetFormNo('DEPEND');
  MedFNo := GetFormNo('MEDICAL');
  DonFNo := GetFormNo('DON');
  TransitFNo := GetFormNo('PTRANSIT');
  HomeBuyFNo := GetFormNo('HOMEBUY');
  AdoptFNo := GetFormNo('ADOPT#1');
  PolitFNo := GetFormNo('POLIT');
  DisabFNo := GetFormNo('TRANSF');

  StoreElm(RNo, OptimizeFNo, 1, FetchElmFNo(RNo, MedFNo, 233));
  StoreElm(RNo, OptimizeFNo, 59, FetchElmFNo(RNo, MedFNo, 236));
  StoreElm(RNo, OptimizeFNo, 34, FetchElmFNo(RNo, DependFNo, 160));
  StoreElm(RNo, OptimizeFNo, 46, FetchElmFNo(RNo, DisabFNo, 69));
  StoreElm(RNo, OptimizeFNo, 62, FetchElmFNo(RNo, DisabFNo, 70));
  StoreElm(RNo, OptimizeFNo, 49, FetchElmFNo(RNo, AdoptFNo, 5));
  StoreElm(RNo, OptimizeFNo, 8, FetchElmFNo(RNo, TransitFNo, 79));
  StoreElm(RNo, OptimizeFNo, 67, FetchElmFNo(RNo, HomeBuyFNo, 1));
  StoreElm(RNo, OptimizeFNo, 9, FetchElmFNo(RNo, DonFNo, 179));
  StoreElm(RNo, OptimizeFNo, 15, FetchElmFNo(RNo, PolitFNo, 19));

end;

Procedure CopyOptimumSplitsToSchedules(RNo: integer);
Var
  OptimizeFNo, DependFNo, MedFNo, DonFNo, TransitFNo, HomeBuyFNo, AdoptFNo,
    PolitFNo, DisabFNo: integer;
begin
  OptimizeFNo := GetFormNo('OPTIMIZE');
  DependFNo := GetFormNo('DEPEND');
  MedFNo := GetFormNo('MEDICAL');
  DonFNo := GetFormNo('DON');
  TransitFNo := GetFormNo('PTRANSIT');
  HomeBuyFNo := GetFormNo('HOMEBUY');
  AdoptFNo := GetFormNo('ADOPT#1');
  PolitFNo := GetFormNo('POLIT');
  DisabFNo := GetFormNo('TRANSF');

  StoreElm(RNo, MedFNo, 233, FetchElmFNo(RNo, OptimizeFNo, 1));
  StoreElm(RNo, MedFNo, 236, FetchElmFNo(RNo, OptimizeFNo, 59));
  StoreElm(RNo, DependFNo, 160, FetchElmFNo(RNo, OptimizeFNo, 34));
  StoreElm(RNo, DisabFNo, 69, FetchElmFNo(RNo, OptimizeFNo, 46));
  StoreElm(RNo, DisabFNo, 70, FetchElmFNo(RNo, OptimizeFNo, 62));
  StoreElm(RNo, AdoptFNo, 5, FetchElmFNo(RNo, OptimizeFNo, 49));
  StoreElm(RNo, TransitFNo, 79, FetchElmFNo(RNo, OptimizeFNo, 8));
  StoreElm(RNo, HomeBuyFNo, 1, FetchElmFNo(RNo, OptimizeFNo, 67));
  StoreElm(RNo, DonFNo, 179, FetchElmFNo(RNo, OptimizeFNo, 9));
  StoreElm(RNo, PolitFNo, 19, FetchElmFNo(RNo, OptimizeFNo, 15));

end;

Procedure SaveDebugInfo(RetNo: integer; SpRetNo: integer; FlName: String);
Var
  i, FNo, OptimizeFNo, LnIdx: integer; // 20190709 Igor
  S: String;
  TempList: TStringList;
begin
  OptimizeFNo := GetFormNo('OPTIMIZE');
  TempList := TStringList.Create;
  TempList.Add('Family Total %=' + FormatFloat('###,###.##',
    ExtractFamilyTotal(RetNo, SpRetNo)));
  TempList.Add('Optimum pension %=' + FetchElmFNo(RetNo, OptimizeFNo, 24));
  TempList.Add('Optimum medical %=' + FetchElmFNo(RetNo, OptimizeFNo, 1));
  TempList.Add('Optimum 306/315 %=' + FetchElmFNo(RetNo, OptimizeFNo, 34));
  TempList.Add('disab xfer %=' + FetchElmFNo(RetNo, OptimizeFNo, 46));
  TempList.Add('tuition xfer%=' + FetchElmFNo(RetNo, OptimizeFNo, 62));
  TempList.Add('donations %=' + FetchElmFNo(RetNo, OptimizeFNo, 9));

  // 20190709 Igor >>>
  for i := 101 to 485 do
  begin
    S := '';
    LnIdx := ConvertOldToNewLn(i);
    If (Ret[RetNo].Lnn[LnIdx] <> 0) or (Ret[SpRetNo].Lnn[LnIdx] <> 0) then
    begin
      S := IntToStr(LnIdx) + ' ' + FormatFloat('########.00',
        Ret[RetNo].Lnn[LnIdx]) + '           ' + FormatFloat('########.00',
        Ret[SpRetNo].Lnn[LnIdx]);
    end;
    If S <> '' then
      TempList.Add(S);
  end;
  // 20190709 Igor <<<

  TempList.SaveToFile(AppDir + '\' + FlName);
  TempList.Free;
end;

Function FedTaxBfrDividendTaxCredit(RetNo: integer): Real;
begin
  Result := MaxR(0, VL(FetchElm(RetNo, 'T1', 130)) - Ret[RetNo].Lnn[35000] -
    Ret[RetNo].Lnn[40427]);
end;

Procedure InitExtractedAutolist;
Begin
  if ExtractedAutoList = nil then
    ExtractedAutoList := TExtractedAutoList.Create
  else
    ExtractedAutoList.Clear;
end;

Procedure InitExtractedCCAlist;
Begin
  if ExtractedCCAlist = nil then
    ExtractedCCAlist := TExtractedCCAList.Create
  else
    ExtractedCCAlist.Clear;
end;

Procedure RecalcBusStatements(RetNo: integer); // StmList:TStringList);
// due to autos
// 20170731 Igor >>>
Var
  i, FNo: integer;
  FInst: String;
  lFrec: TFRec;
begin

  If Ret[RetNo].IsLastYearReturn then
    Exit; // 20160314 Igor
  // 20220416
  // 20220220
  for i := 0 to (FList.Count - 1) do
  begin
    lFrec := FList.Items[i];
    FNo := lFrec.FormNo;
    If Ret[RetNo].FrmHasData[FNo] then
    begin
      If (lFrec.FormName = 'T2042') or (lFrec.FormName = 'T1163') or
        (lFrec.FormName = 'T1273') then
      Begin
        // ShowMessage('Bfr T2043A#1  '+FetchElm(RetNo,'T2043A#1',7));  //20210220
        if (Ret[RetNo].Province = 'ON') or (Ret[RetNo].Province = 'MB') or
          (Ret[RetNo].Province = 'SK') or (Ret[RetNo].Province = 'AB') then
        Begin
          T2043A(RetNo, 'T2043A#1', GetFormNo('T2043A#1')); // 20220201
          // T2043A(RetNo, 'T2043A#2', GetFormNo('T2043A#2'));  //20220201
        End;
        T2043(RetNo, 'T2043', GetFormNo('T2043')); // 20220201
      end; // isfarming
    end; // has data
  end; // i

  for i := 0 to (FList.Count - 1) do
  begin
    lFrec := FList.Items[i];
    FNo := lFrec.FormNo;
    If Ret[RetNo].FrmHasData[FNo] then
    begin
      If (lFrec.FormName = 'T2125') or (lFrec.FormName = 'T776') or
        (lFrec.FormName = 'T2121') or (lFrec.FormName = 'T2042') or
        (lFrec.FormName = 'T1163') or (lFrec.FormName = 'T1273') or
        (lFrec.FormName = 'T777') // 20200514
      then
      begin
        FInst := lFrec.FormInst;
        If lFrec.FormName = 'T2125' then
          T2125(RetNo, 'T2125' + FInst, GetFormNo('T2125' + FInst))
        else If lFrec.FormName = 'T776' then
          T776(RetNo, 'T776' + FInst, GetFormNo('T776' + FInst))
        else If lFrec.FormName = 'T777' then
          T777(RetNo, 'T777' + FInst, GetFormNo('T777' + FInst))
        else If lFrec.FormName = 'T1163' then
        begin
          T1175(RetNo, 'T1175' + FInst, GetFormNo('T1175' + FInst));
          T1163(RetNo, 'T1163' + FInst, GetFormNo('T1163' + FInst));
        end
        else If lFrec.FormName = 'T1273' then
        begin
          T1175H(RetNo, 'T1175H' + FInst, GetFormNo('T1175H' + FInst));
          T1273(RetNo, 'T1273' + FInst, GetFormNo('T1273' + FInst));
        end
        else If lFrec.FormName = 'T2121' then
          T2121(RetNo, 'T2121' + FInst, GetFormNo('T2121' + FInst))
        else If lFrec.FormName = 'T2042' then
          T2042(RetNo, 'T2042' + FInst, GetFormNo('T2042' + FInst));
      end; // any specific stmt
    end; // has data
  end; // i
  // 20170731 Igor <<<
end;

Function IsSharedStatement(RetNo: integer; Stmt: String): Boolean;
// comes as T2125#1
Var
  FInst: String;
begin
  Result := false;
  FInst := ExtractFormInst(Stmt);
  If LeftStr(Stmt, 5) = 'T2125' then
  begin
    If GetFormNo('T2125' + FInst) > 0 then // 20101223
    begin
      If VL(FetchElm(RetNo, 'T2125' + FInst, 238)) > 0 then
      begin
        Result := true;
        Exit;
      End
    end;
  end
  else If LeftStr(Stmt, 5) = 'T2121' then
  begin
    If VL(FetchElm(RetNo, 'T2121' + FInst, 505)) > 0 then
    begin
      Result := true;
      Exit;
    end
  end

  else If LeftStr(Stmt, 5) = 'T2042' then
  begin
    If VL(FetchElm(RetNo, 'T2042' + FInst, 642)) > 0 then
    begin
      Result := true;
      Exit;
    end
  end

  else If LeftStr(Stmt, 5) = 'T1163' then
  begin
    If VL(FetchElm(RetNo, 'T1163' + FInst, 627)) > 0 then
    begin
      Result := true;
      Exit;
    end
  end

  else If LeftStr(Stmt, 5) = 'T1273' then
  begin
    If VL(FetchElm(RetNo, 'T1273' + FInst, 627)) > 0 then
    begin
      Result := true;
      Exit;
    end
  end

  else If LeftStr(Stmt, 4) = 'T776' then
  begin
    If VL(FetchElm(RetNo, 'T776' + FInst, 24)) > 0 then
    begin
      Result := true;
      Exit;
    end
  end

  {
    //20170131 temp
    else If LeftStr(Stmt,7)='ASSETSB'  then
    begin  Result:=True;exit;end

    else If LeftStr(Stmt,5)='AUTOS'  then
    begin Result:=True;exit;end
  }
end;

Procedure FillAuto777ExpRec(RetNo: integer; Stmt: String);
Var
  i, j, FNo: integer;
  NumCarsUsed: integer;
  UsagePercent: Real;
begin
  With AutoExpRec do
  begin
    NumOfCars := 0;
    KMDrove := 0;
    KmTotal := 0;
    KmPercent := 0;
    StatementPercent := 0;
    Cost := 0;
    TotalCCAClaimed := 0;
    CCAClaimed := 0; // 20200511
    Fuel := 0;
    Maintenance := 0;
    Insurance := 0;
    License := 0;
    Interest := 0;
    Leasing := 0;
    Other := 0;
    Rebates := 0;
  end;

  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'AUTO777' then
    begin
      FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] then // 20170324 Igor
      begin
        j := 215;
        Repeat
          If (FetchElmFNo(RetNo, FNo, j) = Stmt) and
            (VL(FetchElmFNo(RetNo, FNo, j + 1)) > 0) then
          begin
            With AutoExpRec do
            begin
              NumOfCars := NumOfCars + 1;
              StatementPercent := VL(FetchElmFNo(RetNo, FNo, j + 1));
              KMDrove := Round(VL(FetchElmFNo(RetNo, FNo, 4)));
              KmTotal := Round(VL(FetchElmFNo(RetNo, FNo, 7)));
              If KmTotal > 0 then
                KmPercent := (KMDrove / KmTotal) * 100
              else
                KmPercent := 0;

              UsagePercent := StatementPercent * KmPercent / 100;
              If KmPercent > 0 then
                Cost := Cost + VL(FetchElmFNo(RetNo, FNo, 191)) /
                  (KmPercent / 100)
              else
                Cost := 0;
              If VL(FetchElmFNo(RetNo, FNo, 6)) > 0 then
                Cost := VL(FetchElmFNo(RetNo, FNo, 6));

              CCAClaimed := VL(FetchElmFNo(RetNo, FNo, 173));; // 20200511

              {
                TotalCCAClaimed := TotalCCAClaimed
                +VL(FetchElmFNo(RetNo, FNo, 210)) * UsagePercent / 100;  //class 8
                //+VL(FetchElmFNo(RetNo, FNo, 173)) * UsagePercent / 100; prior to multi auto777
              }
              // (KmPercent/100);
              Fuel := Fuel + VL(FetchElmFNo(RetNo, FNo, 10)) *
                UsagePercent / 100;
              Maintenance := Maintenance + VL(FetchElmFNo(RetNo, FNo, 13)) *
                UsagePercent / 100;
              Insurance := Insurance + VL(FetchElmFNo(RetNo, FNo, 22)) *
                UsagePercent / 100;
              License := License + VL(FetchElmFNo(RetNo, FNo, 25)) *
                UsagePercent / 100;
              Interest := Interest + VL(FetchElmFNo(RetNo, FNo, 19)) *
                UsagePercent / 100;
              Leasing := Leasing + VL(FetchElmFNo(RetNo, FNo, 16)) *
                UsagePercent / 100;
              Other := Other + (VL(FetchElmFNo(RetNo, FNo, 32)) +
                VL(FetchElmFNo(RetNo, FNo, 36))) * UsagePercent / 100;
              Rebates := Rebates + VL(FetchElmFNo(RetNo, FNo, 219));
            end;
          end;
          inc(j, 6); // dummy
        until j > 215; // 227;
      end;
    end;
  end;
end;

Procedure FillSelfAutoExpRec(RetNo: integer; Stmt: String);
Var
  i, j, FNo: integer;
  NumCarsUsed: integer;
  UsagePercent: Real;
  StmtPg1: String;
begin
  StmtPg1 := ExtractNonInstFormName(Stmt) + ExtractFormInst(Stmt);
  With SelfAutoExpRec do
  begin
    NumOfCars := 0;
    For i := 1 to 6 do
    begin
      Descr[i] := '';
      KMDrove[i] := 0;
      KmTotal[i] := 0;
      Stmt[i] := '';
      StmtPercent[i] := 0;
      PartnerFlag[i] := '';
      ExpensesClaim[i] := 0;
      CCAClaim[i] := 0;
    end;
  end;

  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'AUTOS' then
    begin
      FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] then // 20170324 Igor
      begin
        j := 215;
        Repeat
          If (FetchElmFNo(RetNo, FNo, j) = Stmt) and
            (VL(FetchElmFNo(RetNo, FNo, j + 1)) > 0) then
          begin
            With SelfAutoExpRec do
            begin
              NumOfCars := NumOfCars + 1;
              If NumOfCars > 6 then
                Exit;
              Descr[NumOfCars] := FetchElmFNo(RetNo, FNo, 1);
              StmtPercent[NumOfCars] := VL(FetchElmFNo(RetNo, FNo, j + 1));
              KMDrove[NumOfCars] := Round(VL(FetchElmFNo(RetNo, FNo, 4)));
              KmTotal[NumOfCars] := Round(VL(FetchElmFNo(RetNo, FNo, 7)));
              Stmt[NumOfCars] := FetchElmFNo(RetNo, FNo, j);
              PartnerFlag[NumOfCars] := FetchElmFNo(RetNo, FNo, j + 5);
              ExpensesClaim[NumOfCars] := VL(FetchElmFNo(RetNo, FNo, j + 2));
              CCAClaim[NumOfCars] := VL(FetchElmFNo(RetNo, FNo, j + 3));
            end;
          end;
          inc(j, 6); // dummy
        until j > 227; // 227;
      end;
    end;
  end;
end;

function IsVista: Boolean;
var
  OSVinfo: TOSVERSIONINFO;
begin
  ZeroMemory(@OSVinfo, Sizeof(OSVinfo));
  OSVinfo.dwOSVersionInfoSize := Sizeof(TOSVERSIONINFO);
  GetVersionEx(OSVinfo);
  if (OSVinfo.dwMajorVersion = 6) then
    IsVista := true
  else
    IsVista := false;
end;

Procedure ExtractAuto777(RetNo: integer; StmtId: String; StatementInst: String;
  Var TermLossAmount: Real; Var RecaptAmount: Real; Var AutoCCAForStmt: Real);
Var
  i, j, k, FNo: integer;
  MilesPercent, StPercent: Real;
  ShortYearPercent: Real;
  ExtractedAutoRec: TExtractedAutoRec;
begin
  InitExtractedAutolist(RetNo);
  StPercent := 0;
  TermLossAmount := 0;
  RecaptAmount := 0;
  AutoCCAForStmt := 0;
  MilesPercent := 0;

  // 20100501
  If Ret[RetNo].FormHasData[StmtId + StatementInst] = false then
    Exit;

  // fill it up
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'AUTO777' then
    begin
      FNo := FRec.FormNo;
      If ((FetchElmFNo(RetNo, FNo, 215) = StmtId + StatementInst) and
        (VL(FetchElmFNo(RetNo, FNo, 216)) > 0)) or
        ((FetchElmFNo(RetNo, FNo, 221) = StmtId + StatementInst) and
        (VL(FetchElmFNo(RetNo, FNo, 222)) > 0)) or
        ((FetchElmFNo(RetNo, FNo, 227) = StmtId + StatementInst) and
        (VL(FetchElmFNo(RetNo, FNo, 228)) > 0)) then
      begin
        ExtractedAutoRec := TExtractedAutoRec.Create;
        With ExtractedAutoRec do
        begin
          StatementId := StmtId;
          Description := FetchElmFNo(RetNo, FNo, 1);
          KMDrove := MyStrToInt(FetchElmFNo(RetNo, FNo, 4));
          KmTotal := MyStrToInt(FetchElmFNo(RetNo, FNo, 7));
          // 20090120
          If KmTotal > 0 then
            KmPercent := (KMDrove / KmTotal) * 100
          else
            KmPercent := 0;
          j := 215;
          Repeat
            If FetchElmFNo(RetNo, FNo, j) = StmtId + StatementInst then
            begin
              StatementPercent := VL(FetchElmFNo(RetNo, FNo, j + 1));
              StPercent := StatementPercent;
              MilesPercent := KmPercent;
              ShortYearPercent := (CalcBusDays(RetNo, FetchElmFNo(RetNo, FNo, j)
                ) / Constant[RY].FullYear) * 100;
              PartnerFlag := FetchElmFNo(RetNo, FNo, j + 5);
              ExpensesClaimed := VL(FetchElmFNo(RetNo, FNo, j + 2));
              CCAClaimed := VL(FetchElmFNo(RetNo, FNo, j + 3));
              AutoCCAForStatement := VL(FetchElmFNo(RetNo, FNo, j + 3));
              // may 26 2008
            end;
            inc(j, 6);
          until j > 227;

          ClassId := FetchElmFNo(RetNo, FNo, 134);
          DateAcquired := FetchElmFNo(RetNo, FNo, 137);
          Cost := VL(FetchElmFNo(RetNo, FNo, 20));
          If VL(FetchElmFNo(RetNo, FNo, 149)) > 0 then
            Cost := VL(FetchElmFNo(RetNo, FNo, 158));
          UccStart := VL(FetchElmFNo(RetNo, FNo, 191));
          Additions := VL(FetchElmFNo(RetNo, FNo, 158));
          AdditionsPersonal := VL(FetchElmFNo(RetNo, FNo, 8));
          Proceeds := VL(FetchElmFNo(RetNo, FNo, 18));
          // 20190217 //Vl(FetchElmFNo(RetNo,FNo,15));
          UccAfter := VL(FetchElmFNo(RetNo, FNo, 24)); // 20190217
          ProceedsPersonal := VL(FetchElmFNo(RetNo, FNo, 14));
          Adjustments := VL(FetchElmFNo(RetNo, FNo, 164));
          BaseAmount := VL(FetchElmFNo(RetNo, FNo, 167));
          Rate := VL(FetchElmFNo(RetNo, FNo, 170));
          CCAForTheYear := VL(FetchElmFNo(RetNo, FNo, 173));
          // * (ShortYearPercent/100);
          UCCEnd := VL(FetchElmFNo(RetNo, FNo, 176));
          // May 15 2008
          TerminalLossAmount := VL(FetchElmFNo(RetNo, FNo, 21)) *
            (StPercent / 100) * (MilesPercent / 100);
          RecaptureAmount := VL(FetchElmFNo(RetNo, FNo, 12)) * (StPercent / 100)
            * (MilesPercent / 100);

          AiiPAdditions := VL(FetchElmFNo(RetNo, FNo, 26));
          // see declare unit and vtShared
          AiiPProceeds := VL(FetchElmFNo(RetNo, FNo, 27));
          AiiPUccAdj := VL(FetchElmFNo(RetNo, FNo, 30));

          ExtractedAutoList.Add(ExtractedAutoRec);
        end;
      end;
    end;
  end;
  // get recapt and termloss
  For i := 0 to ExtractedAutoList.Count - 1 do
  begin
    ExtractedAutoRec := ExtractedAutoList.Items[i];
    TermLossAmount := TermLossAmount + ExtractedAutoRec.TerminalLossAmount;
    RecaptAmount := RecaptAmount + ExtractedAutoRec.RecaptureAmount;
    AutoCCAForStmt := AutoCCAForStmt + ExtractedAutoRec.AutoCCAForStatement;
  end;
end;

//jz//20260413//CCAv6 -updated
Procedure ExtractCCA(RetNo: integer; StmtId: String; StatementInst: String;
  Var TermLossAmount: Real; Var RecaptAmount: Real; Var CCAForStmt: Real);
Var
  i, j, k, FNo: integer;
  StPercent: Real;
  ShortYearPercent: Real;
  ExtractedCCARec: TExtractedCCARec;
  StatementFNo: integer;
  // 20230424
  Col1,  Col2,  Col3,  col4,  col5,  col6,  col7,  col8,  col9,  col10, col11,
  col12, col13, col14, col15, col16, col17, col18, col19, col20, col21, col22: integer;

  //jz//20260409//CCAv3
  col22T776,col23T776,col24T776,
  T776ChartBc1,T776ChartBc2,T776ChartBc3,T776ChartBc4,T776ChartBc5,T776ChartBc6,T776ChartBc7:integer;
begin

  StatementFNo := GetFormNo(StmtId + StatementInst); // 20230424

  InitExtractedCCAlist(RetNo);
  TermLossAmount := 0;
  RecaptAmount := 0;
  CCAForStmt := 0;
  StPercent := 0;

  // 20100501
  If Ret[RetNo].FormHasData[StmtId + StatementInst] = false then
    Exit;

  // fill it up
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If ( (FRec.FormName = 'ASSETSB') and PostCCAFromAssetsB(RetNo) ) then //      (UpperCase(FetchElmFNo(RetNo, FRec.FormNo, 10)) = 'Y')) // 20081231 //20200520
    begin
      FNo := FRec.FormNo;
      If ((FetchElmFNo(RetNo, FNo, 215) = StmtId + StatementInst) and
        (VL(FetchElmFNo(RetNo, FNo, 216)) > 0)) or
        ((FetchElmFNo(RetNo, FNo, 221) = StmtId + StatementInst) and
        (VL(FetchElmFNo(RetNo, FNo, 222)) > 0)) or
        ((FetchElmFNo(RetNo, FNo, 227) = StmtId + StatementInst) and
        (VL(FetchElmFNo(RetNo, FNo, 228)) > 0)) then
      begin

        ExtractedCCARec := TExtractedCCARec.Create;
        With ExtractedCCARec do
        begin
          StatementId := StmtId;
          Description := FetchElmFNo(RetNo, FNo, 1);
          RecordKeeping := FetchElmFNo(RetNo, FNo, 36); // 20110109
          PersonalPercent := VL(FetchElmFNo(RetNo, FNo, 4));

          j := 215;
          Repeat
            If FetchElmFNo(RetNo, FNo, j) = StmtId + StatementInst then
            begin
              StatementPercent := VL(FetchElmFNo(RetNo, FNo, j + 1));
              StPercent := StatementPercent;
              ShortYearPercent := (CalcBusDays(RetNo, FetchElmFNo(RetNo, FNo, j))
                                  / Constant[RY].FullYear) * 100;
              CCAClaimed := VL(FetchElmFNo(RetNo, FNo, j + 3));
              CCAForStatement := VL(FetchElmFNo(RetNo, FNo, j + 3));
              // may 26 2008
            end;
            inc(j, 6);
          until j > 227;

          /// /20230427 populate the auto  columns into the record
          Col1 :=134;Col2 :=191;Col3 :=158;col4 := 44;col5 := 18;col6 := 24;col7 := 46;col8 := 47;col9 := 26;col10:= 49;col11:=  50;
          col12:= 12;col13:= 27;col14:= 52;col15:= 53;col16:= 15;col17:= 14;col18:= 30;col19:=167;col20:=170;col21:=173;col22:= 176;//jz//20260406 - add cols elms

          Col22T776:=59;Col23T776:=61;col24T776:=62;
          T776ChartBc1:=588;T776ChartBc2:=489;T776ChartBc3:=490;
          T776ChartBc4:=491;T776ChartBc5:=492;T776ChartBc6:=493;T776ChartBc7:=494;
          Col1Val := FetchElmFNo(RetNo, FNo, Col1);
          // 20230525 Igor >>>
          Col2Val  := VL(FetchElmFNo(RetNo, FNo, Col2))  * (StPercent / 100);
          Col3Val  := VL(FetchElmFNo(RetNo, FNo, Col3))  * (StPercent / 100);
          Col4Val  := VL(FetchElmFNo(RetNo, FNo, col4))  * (StPercent / 100);
          Col5Val  := VL(FetchElmFNo(RetNo, FNo, col5))  * (StPercent / 100);
          Col6Val  := VL(FetchElmFNo(RetNo, FNo, col6))  * (StPercent / 100);
          Col7Val  := VL(FetchElmFNo(RetNo, FNo, col7))  * (StPercent / 100);
          Col8Val  := VL(FetchElmFNo(RetNo, FNo, col8))  * (StPercent / 100);
          Col9Val  := VL(FetchElmFNo(RetNo, FNo, col9))  * (StPercent / 100);
          Col10Val := VL(FetchElmFNo(RetNo, FNo, col10)) * (StPercent / 100);
          Col11Val := VL(FetchElmFNo(RetNo, FNo, col11)) * (StPercent / 100);
          Col12Val := VL(FetchElmFNo(RetNo, FNo, col12)) * (StPercent / 100);
          Col13Val := VL(FetchElmFNo(RetNo, FNo, col13)) * (StPercent / 100);
          Col14Val := VL(FetchElmFNo(RetNo, FNo, col14)) * (StPercent / 100);
          Col15Val := VL(FetchElmFNo(RetNo, FNo, col15)) * (StPercent / 100);
          Col16Val := VL(FetchElmFNo(RetNo, FNo, col16)) * (StPercent / 100);
          Col17Val := VL(FetchElmFNo(RetNo, FNo, col17)) * (StPercent / 100);
          Col18Val := VL(FetchElmFNo(RetNo, FNo, col18)) * (StPercent / 100);
          Col19Val := VL(FetchElmFNo(RetNo, FNo, col19)) * (StPercent / 100);

          Col20Val := VL(FetchElmFNo(RetNo, FNo, col20));   //CCA rate, not value to prorate // * (StPercent / 100);

          Col21Val := CCAClaimed; //jz//20260406 - what is all this, just take final value directly //VL(FetchElmFNo(RetNo, FNo, col21)) * (StPercent / 100);
          Col22Val := VL(FetchElmFNo(RetNo, FNo, col22)) * (StPercent / 100);
          // 20230525 Igor <<<

          col21T776val    := VL(FetchElmFNo(RetNo, FNo, col21))         * (StPercent / 100);
          col22T776val    := VL(FetchElmFNo(RetNo, FNo, col22T776))     * (StPercent / 100);
          col23T776val    := CCAClaimed; //VL(FetchElmFNo(RetNo, FNo, col23T776))     * (StPercent / 100);
          col24T776val    := VL(FetchElmFNo(RetNo, FNo, col24T776))     * (StPercent / 100);
          T776ChartBc1val := FetchElmFNo(RetNo, FNo, T776ChartBc1);
          T776ChartBc2val := FetchElmFNo(RetNo, FNo, T776ChartBc2);
          T776ChartBc3val := FetchElmFNo(RetNo, FNo, T776ChartBc3);
          T776ChartBc4val := VL(FetchElmFNo(RetNo, FNo, T776ChartBc4))  * (StPercent / 100);
          T776ChartBc5val := FetchElmFNo(RetNo, FNo, T776ChartBc5);
          T776ChartBc6val := FetchElmFNo(RetNo, FNo, T776ChartBc6);
          T776ChartBc7val := VL(FetchElmFNo(RetNo, FNo, T776ChartBc7))  * (StPercent / 100);

          ClassId := Trim(FetchElmFNo(RetNo, FNo, 134)); // 20230501 Igor
          DateAcquired := FetchElmFNo(RetNo, FNo, 137);
          if VL(FetchElmFNo(RetNo, FNo, 56)) > 0 then // 20230521 CON
            Cost := VL(FetchElmFNo(RetNo, FNo, 56))
          Else
            Cost := VL(FetchElmFNo(RetNo, FNo, 33));

          AdditionsPersonal := VL(FetchElmFNo(RetNo, FNo, 39));

          // 20230501 Igor >>>
          UccStart          := VL(FetchElmFNo(RetNo, FNo, 191));
          Additions         := VL(FetchElmFNo(RetNo, FNo, 158));
          Proceeds          := VL(FetchElmFNo(RetNo, FNo, 18));
          ProceedsPersonal  := VL(FetchElmFNo(RetNo, FNo, 14)); //jz//CCAv6 - NOT SURE ABOUT THIS
          Adjustments       := VL(FetchElmFNo(RetNo, FNo, 164));
          //AdjUCC            := VL(FetchElmFNo(RetNo, FNo, 29)); //jz//CCAv6 - no ELM 29 exists??
          BaseAmount        := VL(FetchElmFNo(RetNo, FNo, 167));
          Rate              := VL(FetchElmFNo(RetNo, FNo, 170));
          CCAForTheYear     := VL(FetchElmFNo(RetNo, FNo, 173));
          UCCEnd            := VL(FetchElmFNo(RetNo, FNo, 176));

          // 20230501 Igor <<<
          TermLossAmount := VL(FetchElmFNo(RetNo, FNo, 20)) * (StPercent / 100);
          // termlossamount //20230502
          RecaptureAmount := VL(FetchElmFNo(RetNo, FNo, 21)) *(StPercent / 100);
          // not acepted here
          // 20190216CON
          // see declare unit and vtShared
          AiiPAdditions := VL(FetchElmFNo(RetNo, FNo, 37));
          AiiPProceeds := VL(FetchElmFNo(RetNo, FNo, 38));
          AiiPUccAdj := VL(FetchElmFNo(RetNo, FNo, 39));

          ExtractedCCAlist.Add(ExtractedCCARec);
          TermLossFlag := FetchElmFNo(RetNo, FNo, 6); //jz/CCAv6 - class empty indicator, why called TermLossFlag?
        end;
      end;
    end;
  end;
  // get recapt and termloss
  For i := 0 to ExtractedCCAlist.Count - 1 do
  begin
    ExtractedCCARec := ExtractedCCAlist.Items[i];
    TermLossAmount := TermLossAmount + ExtractedCCARec.TerminalLossAmount;
    RecaptAmount := RecaptAmount + ExtractedCCARec.RecaptureAmount;
    CCAForStmt := CCAForStmt + ExtractedCCARec.CCAForStatement;
  end;
end;



//jz//20260413//CCAv6 - replaced with updated one
(*
Procedure ExtractCCA(RetNo: integer; StmtId: String; StatementInst: String;
  Var TermLossAmount: Real; Var RecaptAmount: Real; Var CCAForStmt: Real);
Var
  i, j, k, FNo: integer;
  StPercent: Real;
  ShortYearPercent: Real;
  ExtractedCCARec: TExtractedCCARec;
  StatementFNo: integer;
  // 20230424
  Col1, Col2, Col3, col4, col5, col6, col7, col8, col9, col10, col11, col12,
    col13, col14, col15, col16, col17, col18, col19: integer;
begin
  StatementFNo := GetFormNo(StmtId + StatementInst); // 20230424
  TermLossAmount := 0;
  RecaptAmount := 0;
  CCAForStmt := 0;
  StPercent := 0;

  InitExtractedCCAlist(RetNo);
  // 20100501
  If Ret[RetNo].FormHasData[StmtId + StatementInst] = false then
    Exit;

  // fill it up
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If ((FRec.FormName = 'ASSETSB') and
      (UpperCase(FetchElmFNo(RetNo, FRec.FormNo, 10)) = 'Y'))
    // 20081231 //20200520
    then
    begin
      FNo := FRec.FormNo;
      If ((FetchElmFNo(RetNo, FNo, 215) = StmtId + StatementInst) and
        (VL(FetchElmFNo(RetNo, FNo, 216)) > 0)) or
        ((FetchElmFNo(RetNo, FNo, 221) = StmtId + StatementInst) and
        (VL(FetchElmFNo(RetNo, FNo, 222)) > 0)) or
        ((FetchElmFNo(RetNo, FNo, 227) = StmtId + StatementInst) and
        (VL(FetchElmFNo(RetNo, FNo, 228)) > 0)) then
      begin
        /// OR TAssetsBRec    but you wrote     TExtractedCCARec and this fields has to be here as i undertand
        ExtractedCCARec := TExtractedCCARec.Create;
        With ExtractedCCARec do
        begin
          StatementId := StmtId;
          Description := FetchElmFNo(RetNo, FNo, 1);
          RecordKeeping := FetchElmFNo(RetNo, FNo, 36); // 20110109
          PersonalPercent := VL(FetchElmFNo(RetNo, FNo, 4));

          j := 215;
          Repeat
            If FetchElmFNo(RetNo, FNo, j) = StmtId + StatementInst then
            begin
              StatementPercent := VL(FetchElmFNo(RetNo, FNo, j + 1));
              StPercent := StatementPercent;
              ShortYearPercent := (CalcBusDays(RetNo, FetchElmFNo(RetNo, FNo, j))
                                  / Constant[RY].FullYear) * 100;
              CCAClaimed := VL(FetchElmFNo(RetNo, FNo, j + 3));
              CCAForStatement := VL(FetchElmFNo(RetNo, FNo, j + 3));
              // may 26 2008
            end;
            inc(j, 6);
          until j > 227;

          // populate the columns into the reord//20230424

          Col1Val := FetchElmFNo(RetNo, FNo, 134);
          // 20230525 Igor >>>
          Col2Val  := VL(FetchElmFNo(RetNo, FNo, 191)) * (StPercent / 100);
          Col3Val  := VL(FetchElmFNo(RetNo, FNo, 158)) * (StPercent / 100);
          Col4Val  := VL(FetchElmFNo(RetNo, FNo, 44))  * (StPercent / 100);
          Col5Val  := VL(FetchElmFNo(RetNo, FNo, 18))  * (StPercent / 100);
          Col6Val  := VL(FetchElmFNo(RetNo, FNo, 45))  * (StPercent / 100);
          Col7Val  := VL(FetchElmFNo(RetNo, FNo, 46))  * (StPercent / 100);
          Col8Val  := VL(FetchElmFNo(RetNo, FNo, 47))  * (StPercent / 100);
          Col9Val  := VL(FetchElmFNo(RetNo, FNo, 48))  * (StPercent / 100);
          Col10Val := VL(FetchElmFNo(RetNo, FNo, 49))  * (StPercent / 100);
          Col11Val := VL(FetchElmFNo(RetNo, FNo, 50))  * (StPercent / 100);
          Col12Val := VL(FetchElmFNo(RetNo, FNo, 22))  * (StPercent / 100);  // 51 old //20260402
          Col13Val := VL(FetchElmFNo(RetNo, FNo, 51))  * (StPercent / 100);  //52
          Col14Val := VL(FetchElmFNo(RetNo, FNo, 52))  * (StPercent / 100);  //53
          Col15Val := VL(FetchElmFNo(RetNo, FNo, 53))  * (StPercent / 100);  //53
          Col16Val := VL(FetchElmFNo(RetNo, FNo, 55))  * (StPercent / 100); //167 //jz//20260403 - updated elm
          Col17Val := VL(FetchElmFNo(RetNo, FNo,  5))  * (StPercent / 100); //170 //jz//20260403 - not rate any more, add Statement Percent adjustment
          Col18Val := VL(FetchElmFNo(RetNo, FNo, 54))  * (StPercent / 100); //173
          Col19Val := VL(FetchElmFNo(RetNo, FNo, 167)) * (StPercent / 100); //176

          Col20Val := VL(FetchElmFNo(RetNo, FNo, 170));                     //jz//20260403 - CCA rate, Statement Percent adjustment not applicable

          Col21Val := VL(FetchElmFNo(RetNo, FNo, 173)) * (StPercent / 100); //jz//20260403
          Col22Val := VL(FetchElmFNo(RetNo, FNo, 176)) * (StPercent / 100); //jz//20260403
          // 20230525 Igor <<<

          ClassId := Trim(FetchElmFNo(RetNo, FNo, 134)); // 20230501 Igor
          DateAcquired := FetchElmFNo(RetNo, FNo, 137);
          Cost := VL(FetchElmFNo(RetNo, FNo, 20));
          If VL(FetchElmFNo(RetNo, FNo, 12)) > 0 then
            Cost := VL(FetchElmFNo(RetNo, FNo, 12));

          AdditionsPersonal := VL(FetchElmFNo(RetNo, FNo, 8));

          // 20230501 Igor >>>
          UccStart          := VL(FetchElmFNo(RetNo, FNo, 191));
          Additions         := VL(FetchElmFNo(RetNo, FNo, 158));
          Proceeds          := VL(FetchElmFNo(RetNo, FNo, 15));
          ProceedsPersonal  := VL(FetchElmFNo(RetNo, FNo, 14));
          Adjustments       := VL(FetchElmFNo(RetNo, FNo, 164));
          AdjUCC            := VL(FetchElmFNo(RetNo, FNo, 29));
          BaseAmount        := VL(FetchElmFNo(RetNo, FNo, 167));
          Rate              := VL(FetchElmFNo(RetNo, FNo, 170));
          CCAForTheYear     := VL(FetchElmFNo(RetNo, FNo, 173));
          UCCEnd            := VL(FetchElmFNo(RetNo, FNo, 176));

          // 20230501 Igor <<<
          TermLossAmount := VL(FetchElmFNo(RetNo, FNo, 16)) * (StPercent / 100);
          // termlossamount //20230502
          RecaptureAmount := VL(FetchElmFNo(RetNo, FNo, 19)) *(StPercent / 100);
          // not acepted here
          // 20190216CON
          AiiPAdditions := VL(FetchElmFNo(RetNo, FNo, 37)); // see declare unit
          AiiPProceeds := VL(FetchElmFNo(RetNo, FNo, 38));
          AiiPUccAdj := VL(FetchElmFNo(RetNo, FNo, 39));

          // ---------------
          ExtractedCCAlist.Add(ExtractedCCARec);
          TermLossFlag := FetchElmFNo(RetNo, FNo, 6);
        end;
      end;
    end;
  end;
  // get recapt and termloss
  For i := 0 to ExtractedCCAlist.Count - 1 do
  begin
    ExtractedCCARec := ExtractedCCAlist.Items[i];
    TermLossAmount := TermLossAmount + ExtractedCCARec.TerminalLossAmount;
    RecaptAmount := RecaptAmount + ExtractedCCARec.RecaptureAmount;
    CCAForStmt := CCAForStmt + ExtractedCCARec.CCAForStatement;
  end;
end;
*)

Procedure ExtractAutos(RetNo: integer; StmtId: String; StatementInst: String;
  Var TermLossAmount: Real; Var RecaptAmount: Real; Var AutoCCAForStmt: Real);

Var
  i, j, k, FNo: integer;
  MilesPercent, StPercent: Real;
  ShortYearPercent: Real;
  ExtractedAutoRec: TExtractedAutoRec;
  Col1,  Col2,  Col3,  col4,  col5,  col6,  col7,  col8,  col9,  col10, col11,
  col12, col13, col14, col15, col16, col17, col18, col19, col20, col21, col22: integer;

  //jz//20260409//CCAv3
  col22T776,col23T776,col24T776,
  T776ChartBc1,T776ChartBc2,T776ChartBc3,T776ChartBc4,T776ChartBc5,T776ChartBc6,T776ChartBc7:integer;
begin
  InitExtractedAutolist(RetNo);
  StPercent := 0;
  TermLossAmount := 0;
  RecaptAmount := 0;
  AutoCCAForStmt := 0;
  MilesPercent := 0;

  // 20100501
  If Ret[RetNo].FormHasData[StmtId + StatementInst] = false then
    Exit;

  // fill it up
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'AUTOS' then
    begin
      FNo := FRec.FormNo;
      If ((FetchElmFNo(RetNo, FNo, 215) = StmtId + StatementInst) and
        (VL(FetchElmFNo(RetNo, FNo, 216)) > 0)) or
        ((FetchElmFNo(RetNo, FNo, 221) = StmtId + StatementInst) and
        (VL(FetchElmFNo(RetNo, FNo, 222)) > 0)) or
        ((FetchElmFNo(RetNo, FNo, 227) = StmtId + StatementInst) and
        (VL(FetchElmFNo(RetNo, FNo, 228)) > 0))
      then
      begin
        ExtractedAutoRec := TExtractedAutoRec.Create;
        With ExtractedAutoRec do
        begin
          StatementId := StmtId;
          Description := FetchElmFNo(RetNo, FNo, 1);
          KMDrove := MyStrToInt(FetchElmFNo(RetNo, FNo, 4));
          KmTotal := MyStrToInt(FetchElmFNo(RetNo, FNo, 7));
          // 20090120
          If KmTotal > 0 then
            KmPercent := (KMDrove / KmTotal) * 100
          else
            KmPercent := 0;
          j := 215; // index to allocation section
          Repeat
            If FetchElmFNo(RetNo, FNo, j) = StmtId + StatementInst then
            begin
              StatementPercent := VL(FetchElmFNo(RetNo, FNo, j + 1));
              StPercent := 100;
              // StatementPercent; OTHREWISE it does it twice  //20230717
              MilesPercent := KmPercent;
              ShortYearPercent := (CalcBusDays(RetNo, FetchElmFNo(RetNo, FNo, j))
                                   / Constant[RY].FullYear) * 100;
              PartnerFlag := FetchElmFNo(RetNo, FNo, j + 5);
              ExpensesClaimed := VL(FetchElmFNo(RetNo, FNo, j + 2));
              CCAClaimed := VL(FetchElmFNo(RetNo, FNo, j + 3));
              AutoCCAForStatement := VL(FetchElmFNo(RetNo, FNo, j + 3));
              // may 26 2008
            end;
            inc(j, 6);
          until j > 227;

          /// /20230427 populate the auto  columns into the record
          Col1 :=134;Col2 :=191;Col3 :=158;col4 := 44;col5 := 18;col6 := 24;col7 := 46;col8 := 47;col9 := 26;col10:= 49;col11:=  50;
          col12:= 12;col13:= 27;col14:= 52;col15:= 53;col16:= 15;col17:= 14;col18:= 30;col19:=167;col20:=170;col21:=173;col22:= 176;//jz//20260406 - add cols elms

          Col22T776:=59;Col23T776:=61;col24T776:=62;
          T776ChartBc1:=588;T776ChartBc2:=489;T776ChartBc3:=490;
          T776ChartBc4:=491;T776ChartBc5:=492;T776ChartBc6:=493;T776ChartBc7:=494;

          Col1Val := FetchElmFNo(RetNo, FNo, Col1);
          // 20230525 Igor >>>
          Col2Val  := VL(FetchElmFNo(RetNo, FNo, Col2))  * (StPercent / 100);
          Col3Val  := VL(FetchElmFNo(RetNo, FNo, Col3))  * (StPercent / 100);
          Col4Val  := VL(FetchElmFNo(RetNo, FNo, col4))  * (StPercent / 100);
          Col5Val  := VL(FetchElmFNo(RetNo, FNo, col5))  * (StPercent / 100);
          Col6Val  := VL(FetchElmFNo(RetNo, FNo, col6))  * (StPercent / 100);
          Col7Val  := VL(FetchElmFNo(RetNo, FNo, col7))  * (StPercent / 100);
          Col8Val  := VL(FetchElmFNo(RetNo, FNo, col8))  * (StPercent / 100);
          Col9Val  := VL(FetchElmFNo(RetNo, FNo, col9))  * (StPercent / 100);
          Col10Val := VL(FetchElmFNo(RetNo, FNo, col10)) * (StPercent / 100);
          Col11Val := VL(FetchElmFNo(RetNo, FNo, col11)) * (StPercent / 100);
          Col12Val := VL(FetchElmFNo(RetNo, FNo, col12)) * (StPercent / 100);
          Col13Val := VL(FetchElmFNo(RetNo, FNo, col13)) * (StPercent / 100);
          Col14Val := VL(FetchElmFNo(RetNo, FNo, col14)) * (StPercent / 100);
          Col15Val := VL(FetchElmFNo(RetNo, FNo, col15)) * (StPercent / 100);
          Col16Val := VL(FetchElmFNo(RetNo, FNo, col16)) * (StPercent / 100);
          Col17Val := VL(FetchElmFNo(RetNo, FNo, col17)) * (StPercent / 100);
          Col18Val := VL(FetchElmFNo(RetNo, FNo, col18)) * (StPercent / 100);
          Col19Val := VL(FetchElmFNo(RetNo, FNo, col19)) * (StPercent / 100);

          Col20Val := VL(FetchElmFNo(RetNo, FNo, col20));   //CCA rate, not value to prorate // * (StPercent / 100);

          Col21Val := CCAClaimed; //jz//20260406 - what is all this, just take final value directly //VL(FetchElmFNo(RetNo, FNo, col21)) * (StPercent / 100);
          Col22Val := VL(FetchElmFNo(RetNo, FNo, col22)) * (StPercent / 100);
          // 20230525 Igor <<<

          col21T776val    := VL(FetchElmFNo(RetNo, FNo, col21))         * (StPercent / 100);
          col22T776val    := VL(FetchElmFNo(RetNo, FNo, col22T776))     * (StPercent / 100);
          col23T776val    := CCAClaimed; //VL(FetchElmFNo(RetNo, FNo, col23T776))     * (StPercent / 100);
          col24T776val    := VL(FetchElmFNo(RetNo, FNo, col24T776))     * (StPercent / 100);
          T776ChartBc1val := FetchElmFNo(RetNo, FNo, T776ChartBc1);
          T776ChartBc2val := FetchElmFNo(RetNo, FNo, T776ChartBc2);
          T776ChartBc3val := FetchElmFNo(RetNo, FNo, T776ChartBc3);
          T776ChartBc4val := VL(FetchElmFNo(RetNo, FNo, T776ChartBc4))  * (StPercent / 100);
          T776ChartBc5val := FetchElmFNo(RetNo, FNo, T776ChartBc5);
          T776ChartBc6val := FetchElmFNo(RetNo, FNo, T776ChartBc6);
          T776ChartBc7val := VL(FetchElmFNo(RetNo, FNo, T776ChartBc7))  * (StPercent / 100);
          ClassId := Trim(FetchElmFNo(RetNo, FNo, 134)); // 20230501 Igor
          DateAcquired := FetchElmFNo(RetNo, FNo, 137);
          if VL(FetchElmFNo(RetNo, FNo, 56)) > 0 then // 20230521 CON
            Cost := VL(FetchElmFNo(RetNo, FNo, 56))
          Else
            Cost := VL(FetchElmFNo(RetNo, FNo, 33));
          // If VL(FetchElmFNo(RetNo, FNo, 12)) > 0 then Cost := VL(FetchElmFNo(RetNo, FNo, 12));
          AdditionsPersonal := VL(FetchElmFNo(RetNo, FNo, 39));
          ProceedsPersonal := VL(FetchElmFNo(RetNo, FNo, 14)); // 20230522 Igor
          Rate := VL(FetchElmFNo(RetNo, FNo, 170));

          // 20230501 Igor >>>
          // 20230427
          // 20230426CON
          // 20230522 Igor >>>
          UccStart := VL(FetchElmFNo(RetNo, FNo, 191)); // Tv[Col2];
          Additions := VL(FetchElmFNo(RetNo, FNo, 158)); // Tv[Col3];
          Proceeds := VL(FetchElmFNo(RetNo, FNo, 18)); // Tv[Col5];
          // 20230522 Igor <<<
          // 20190217 //Vl(FetchElmFNo(RetNo,FNo,15));
          UccAfter := VL(FetchElmFNo(RetNo, FNo, 24)); // 20190217
          Adjustments := VL(FetchElmFNo(RetNo, FNo, 164));
          BaseAmount := VL(FetchElmFNo(RetNo, FNo, 167));
          CCAForTheYear := VL(FetchElmFNo(RetNo, FNo, 173));
          UCCEnd := VL(FetchElmFNo(RetNo, FNo, 176));
          // 20230501 Igor <<<

          // May 15 2008
          // 20230522 Igor >>>
          TerminalLossAmount := VL(FetchElmFNo(RetNo, FNo, 20));
          // Tv[20]; //VL(FetchElmFNo(RetNo, FNo, 20)) * (StPercent / 100) * (MilesPercent / 100); //20230502 21->20
          RecaptureAmount := VL(FetchElmFNo(RetNo, FNo, 21));
          // Tv[21]; //VL(FetchElmFNo(RetNo, FNo, 21)) * (StPercent / 100) * (MilesPercent / 100); //20230502 12->21
          // 20230522 Igor <<<

          AiiPAdditions := VL(FetchElmFNo(RetNo, FNo, 26));
          // see declare unit and vtShared
          AiiPProceeds := VL(FetchElmFNo(RetNo, FNo, 27));
          AiiPUccAdj := VL(FetchElmFNo(RetNo, FNo, 30));

          ExtractedAutoList.Add(ExtractedAutoRec);
        end;
      end;
    end;
    // SaveTv(RetNo,FRec.FormName,FNo); //???? //20230519
  end;

  // get recapt and termloss
  For i := 0 to ExtractedAutoList.Count - 1 do
  begin
    ExtractedAutoRec := ExtractedAutoList.Items[i];
    TermLossAmount := TermLossAmount + ExtractedAutoRec.TerminalLossAmount;
    RecaptAmount := RecaptAmount + ExtractedAutoRec.RecaptureAmount;
    AutoCCAForStmt := AutoCCAForStmt + ExtractedAutoRec.AutoCCAForStatement;
  end;
end;


Procedure PostNonVehicleCCA(RetNo: integer; FName: String; Stmt: String;
  FInst: String; FNo: integer; StartNdx, EndNdx, IncrBy, EndSectionNdx,
  RemainingNdx, TotalNdx: integer);
Var
  i, j, RowCount: integer; // 20230428 Igor   //jz//20260418//CCAv9 - replace with TermLossCol  kRent, KT2125, KT2121, KT1163
  RemainingAmount: Real;
  TermLossAmount, RecaptAmount: Real;
  KTermLoss, KRecapture: integer;
  CCAForStmt: Real;
  Aii: integer; // Index for AiiP
  T1175FNo, T1175FInst: integer;
  // 20230424
  Col1,  Col2,  Col3,  col4,  col5,  col6,  col7,  col8,  col9,  col10, col11,
  col12, col13, col14, col15, col16, col17, col18, col19, col20, col21, col22, col23 : integer; //jz//20260405 - add col new vars
  //jz//20260409//CCAv3 - //jz//20260405 - add chartb col elm vars
  col21T776,col22T776,col23T776,col24T776,
  TermLossCol, //jz//20260418//CCAv9
  T776ChartBc1,T776ChartBc2,T776ChartBc3,T776ChartBc4,T776ChartBc5,T776ChartBc6,T776ChartBc7: integer;

            procedure IncCols; // 20230428 Igor
            begin
              If (LeftStr(Stmt, 4) = 'T776') then // 20230425 Igor
              begin
                inc(Col1 ,9);inc(Col2 ,9);inc(Col3 ,9);inc(col4 ,1);inc(col5 ,9);inc(col6 ,1);inc(col7 ,1);inc(col8 ,1);inc(col9,1);inc(col10,1);inc(col11,1);
                inc(col12,1);inc(col13,1);inc(col14,1);inc(col15,1);inc(col16,1);inc(col17,1);inc(col18,9);inc(col19,9);
                inc(col20,9);
                inc(col21,9);inc(col22,1);inc(col23,1); //not needed for T776, but inc anyway
                inc(col21T776,9);inc(col22T776,1);inc(col23T776,1);inc(col24T776,9);
                inc(TermLossCol,1); //jz//CCAv9
              end
              Else if LeftStr(FName, 5) = 'T1175'
              // t1175h# and t1175# are the same structure
              then
              Begin
                inc(Col1, 10);inc(Col2, 10);inc(Col3, 10);inc(col4, 1);inc(col5, 10);inc(col6,  1);inc(col7, 10);inc(col8,  1);inc(col9, 1);inc(col10,1);inc(col11,1);
                inc(col12, 1);inc(col13, 1);inc(col14, 1);inc(col15,1);inc(col16,10);inc(col17,10);inc(col18,10);inc(col19,10);inc(col20,10);inc(col21,10);inc(col22,10);
                inc(TermLossCol,10); //jz//CCAv9
              end
              else              //T2125 PostNonVehicleCCA
              Begin
                //jz//20260404 - add and adjust inc amounts
                inc(Col1, 10);inc(Col2, 10);inc(Col3, 10);inc(col4, 1);inc(col5, 10);inc(col6, 1);inc(col7,  1);inc(col8,  1);inc(col9,  1);inc(col10, 1);inc(col11,1);
                inc(col12, 1);inc(col13, 1);inc(col14, 1);inc(col15,1);inc(col16, 1);inc(col17,1);inc(col18,10);inc(col19,10);inc(col20,10);inc(col21,10);inc(col22,10);
                inc(TermLossCol,10); //jz//CCAv9
              End;
            end;

            procedure InitCols; // 20230428 Igor
            begin
              // 20230226
              If LeftStr(FName, 6) = 'T2125#' then //PostNonVehicleCCA
              begin
                //jz//20260404 - update and add column elms
                Col1 :=301;Col2 :=302;Col3 :=303;col4 :=285;col5 :=304;col6 :=293;col7 :=551;col8 :=515;col9 :=523;col10:=575;col11:= 189;
                col12:=874;col13:=583;col14:=112;col15:=120;col16:=276;col17:=882;col18:=305;col19:=306;col20:=307;col21:=308;col22:= 309;
                TermLossCol := 310; //jz//CCAv9 - KT2125 := 300; // so 2125 starts from 310
              end
              Else if LeftStr(FName, 6) = 'T2042#' then
              Begin
                //jz//20260414 - update and add column elms
                Col1 :=401;Col2 :=402;Col3 :=403;col4 :=337;col5 :=404;col6 :=345;col7 :=158;col8 :=353;col9 :=361;col10:=369;col11:=93;
                col12:=699;col13:=378;col14:=166;col15:=174;col16:=591;col17:=683;col18:=405;col19:=406;col20:=407;col21:=408;col22:=409;
                TermLossCol := 410//jz//CCAv9
              end
              Else if LeftStr(FName, 6) = 'T2121#' then
              begin
                //jz//20260414 - update and add column elms
                Col1 :=137;Col2 :=138;Col3 :=139;col4 :=460;col5 :=140;col6 :=468;col7 := 90;col8 :=476;col9 :=484;col10:=492;col11:=285;
                col12:=598;col13:=523;col14:=293;col15:=435;col16:=685;col17:=716;col18:=142;col19:=141;col20:=143;col21:=144;col22:=145;
                TermLossCol := 146; //jz//CCAv9 KT2121 := 136; // so 2121 starts from 146
              end
              Else if LeftStr(FName, 5) = 'T776#' then
              Begin
                //jz//20260414 - update and add column elms
                Col1 :=201;Col2 :=202;Col3 :=203;col4 :=176;col5 :=204;col6 :=181;col7 :=146;col8 :=186;col9 :=191;col10:=196;col11:=153;col12:=602;
                col13:=383;col14:=158;col15:=163;col16:=612;col17:=607;col18:=205;col19:=206;col20:=207;
                col21T776:=208;col22T776:=576;col23T776:=581;col24T776:=209;
                TermLossCol := 360;  //jz//CCAv9 kRent := 359;
                //jz//CCAv9
                T776ChartBc1:=588;T776ChartBc2:=489;T776ChartBc3:=490;T776ChartBc4:=491;T776ChartBc5:=492;T776ChartBc6:=493;T776ChartBc7:=494;
              end
              Else if (LeftStr(FName, 7) = 'T1175H#') or (LeftStr(FName, 6) = 'T1175#')
              then
              Begin
                Col1 :=  1;Col2 :=  2;Col3 :=  3;col4 :=363;col5 :=  4;col6 :=372;col7 :=  5;col8 :=380;col9 :=388;col10:=396;col11:=173;
                col12:=474;col13:=404;col14:=181;col15:=189;col16:=482;col17:=490;col18:=338;col19:=  6;col20:=  7;col21:=  8;col22:=  9;
                TermLossCol := 10; //jz//CCAv9
              end;
            end;


            //jz//20260417//CCAv9
            procedure clearAllCols;
              const b=''; z=0;
              var i:integer;
            begin

              if LeftStr(FName, 5) = 'T776#' then RowCount := 5                        //jz//20260417//CCAv9 - T776 has more than 2 rows
                                             else RowCount := 8;                       //jz//20260417//CCAv9 - the rest have 8 rows

              with Ret[RetNo].Frm[FNo] do
              begin
                For i := 0 to RowCount - 1 do
                begin
                  strings[Col1] := b;  //jz//20260411//CCAv4 - clear
                  Tv[Col2] :=z;Tv[Col3] :=z;Tv[col4] :=z;Tv[col5] :=z;Tv[col6] :=z;Tv[col7] :=z;Tv[col8] :=z;Tv[col9] :=z;Tv[col10] :=z;Tv[col11] :=z;
                  Tv[col12]:=z;Tv[col13]:=z;Tv[col14]:=z;Tv[col15]:=z;Tv[col16]:=z;Tv[col17]:=z;Tv[col18]:=z;Tv[col19]:=z;

                  strings[col20] := b; //jz//20260405 - change to strings
                  if LeftStr(FName, 5) = 'T776#' then
                  begin
                    Tv[col21T776]:=z;Tv[col22T776]:=z;Tv[col23T776]:=z;Tv[col24T776]:=z;
                    strings[T776ChartBc1]:=b;strings[T776ChartBc2]:=b;strings[T776ChartBc3]:=b;Tv[T776ChartBc4]:=0;strings[T776ChartBc5]:=b;strings[T776ChartBc6]:=b;Tv[T776ChartBc7]:=z; //jz//20260409//CCAv3 - //jz//20260405 - init chartb col val
                  end
                  else
                  begin
                    Tv[col21] := z;
                    Tv[col22] := z;
                  end;

                  EndNdx := Col1; // 20230523 Igor //jz//20260411//CCAv4 - necessary as is used below for RemainingAmount, seems to work?
                                                                 //        probably should be remnamed
                  IncCols;
                end;
              end;
              InitCols;
            end;

begin
  TermLossAmount := 0;
  RecaptAmount := 0;
  CCAForStmt := 0;
  with Ret[RetNo].Frm[FNo] do
  begin

    //jz//20260417//CCAv9 - init and clear first
    initCols;       //get column elm numbers
    clearAllCols;   //clear all cols, must be in this order

    if not PostCCaFromAssetsB(RetNo) then exit;
    ExtractCCA(RetNo, Stmt, FInst, TermLossAmount, RecaptAmount, CCAForStmt);


    Tv[RemainingNdx] := 0; // suppl clear
    Tv[TotalNdx] := 0;
    RemainingAmount := 0;
    j := StartNdx;
//kRent := 359;KT2125 := 300; // so 2125 starts from 310 KT2121 := 136; // so 2121 starts from 146 KT1163 := -9; // 20190215

    // 20230428 Igor <<<

    For i := 0 to ExtractedCCAlist.Count - 1 do
    begin
      //kRent  := kRent  + 1;KT2125 := KT2125 + 10;KT2121 := KT2121 + 10;KT1163 := KT1163 + 10;
      ExtractedCCARec := ExtractedCCAlist.Items[i];

      TermLossAmount := TermLossAmount + ExtractedCCARec.TerminalLossAmount;
      RecaptAmount := RecaptAmount + ExtractedCCARec.RecaptureAmount;
      If j > EndNdx then //NOTE: EndNdx is set in clearAllCols
        RemainingAmount := RemainingAmount + ExtractedCCARec.CCAClaimed
      else
      begin
        StoreElm(RetNo, FNo, j, ExtractedCCARec.ClassId);
        // 20230424
        Tv[Col2] := ExtractedCCARec.Col2Val;
        Tv[Col3] := ExtractedCCARec.Col3Val;
        Tv[col4] := ExtractedCCARec.Col4Val;
        Tv[col5] := ExtractedCCARec.Col5Val;
        Tv[col6] := ExtractedCCARec.Col6Val;
        Tv[col7] := ExtractedCCARec.Col7Val;
        Tv[col8] := ExtractedCCARec.Col8Val;
        Tv[col9] := ExtractedCCARec.Col9Val;
        Tv[col10] := ExtractedCCARec.Col10Val;
        Tv[col11] := ExtractedCCARec.Col11Val;
        Tv[col12] := ExtractedCCARec.Col12Val;
        Tv[col13] := ExtractedCCARec.Col13Val;
        Tv[col14] := ExtractedCCARec.Col14Val;
        Tv[col15] := ExtractedCCARec.Col15Val;
        Tv[col16] := ExtractedCCARec.Col16Val;
        Tv[col17] := ExtractedCCARec.Col17Val;
        Tv[col18] := ExtractedCCARec.Col18Val;
        Tv[col19] := ExtractedCCARec.Col19Val;

        strings[col20] := floattostr(ExtractedCCARec.Col20Val); //jz//20260404 - add col

          If LeftStr(Stmt, 4) = 'T776' then //jz//20260409//CCAv3 - account for T776 extra cols and chartb
          begin
            //Tv[col22] := 0;                                 //jz - not valid for T776
            Tv[col21T776]         := ExtractedCCARec.col21T776Val;
            Tv[col22T776]         := ExtractedCCARec.col22T776Val;
            Tv[col23T776]         := ExtractedCCARec.CCAClaimed;    //CCA //jz//20260417//CCAv9 - take final value directly //col23T776Val;
            Tv[col24T776]         := ExtractedCCARec.col24T776Val;
            If ExtractedCCARec.T776ChartBc6Val > '0' then  //jz - only populate if possible to have value
            begin
              strings[T776ChartBc1] := ExtractedCCARec.T776ChartBc1Val;
              strings[T776ChartBc2] := ExtractedCCARec.T776ChartBc2Val;
              strings[T776ChartBc3] := ExtractedCCARec.T776ChartBc3Val;
              Tv[T776ChartBc4]      := ExtractedCCARec.T776ChartBc4Val;
              strings[T776ChartBc5] := ExtractedCCARec.T776ChartBc5Val;
              strings[T776ChartBc6] := ExtractedCCARec.T776ChartBc6Val;
              Tv[T776ChartBc7]      := ExtractedCCARec.T776ChartBc7Val;
            end;
          end
          else
          begin
            Tv[col21] := ExtractedCCARec.CCAClaimed;  //jz//20260406 - what is all this BS, take final value directly //ExtractedAutoRec.Col21Val;   * ExtractedAutoRec.StatementPercent   //jz//20260405 - add
            Tv[col22] := ExtractedCCARec.Col22Val;   //jz//20260405 - add
          end;

          strings[TermLossCol] := ExtractedCCARec.TermLossFlag;          //StoreElm(RetNo, FNo, KT2125, ExtractedCCARec.TermLossFlag);

        { //20230424
          If LeftStr(Stmt, 5) = 'T1163' then // 20190215
          Begin
          Tv[i + 173] := ExtractedCCARec.AiiPAdditions; // jives the proper J
          Tv[i + 181] := MaxR(0, ExtractedCCARec.AiiPProceeds);
          Tv[i + 189] := MaxR(0, ExtractedCCARec.AiiPUccAdj);
          end;

          If LeftStr(Stmt, 5) = 'T2125' then
          Begin
          Tv[i + 189] := ExtractedCCARec.AiiPAdditions; // jives the proper J
          Tv[i + 112] := MaxR(0, ExtractedCCARec.AiiPProceeds);
          Tv[i + 120] := MaxR(0, ExtractedCCARec.AiiPUccAdj);
          end;
          If LeftStr(Stmt, 5) = 'T2042' then
          Begin
          Tv[i + 93] := ExtractedCCARec.AiiPAdditions; // jives the proper J
          Tv[i + 166] := MaxR(0, ExtractedCCARec.AiiPProceeds);
          Tv[i + 174] := MaxR(0, ExtractedCCARec.AiiPUccAdj);
          end;
          If LeftStr(Stmt, 5) = 'T2121' then
          Begin
          Tv[i + 285] := ExtractedCCARec.AiiPAdditions; // jives the proper J
          Tv[i + 293] := MaxR(0, ExtractedCCARec.AiiPProceeds);
          Tv[i + 435] := MaxR(0, ExtractedCCARec.AiiPUccAdj);
          end;

          If LeftStr(Stmt, 4) = 'T776' then
          Begin
          Tv[i + 153] := ExtractedCCARec.AiiPAdditions; // jives the proper J
          Tv[i + 158] := MaxR(0, ExtractedCCARec.AiiPProceeds);
          Tv[i + 163] := MaxR(0, ExtractedCCARec.AiiPUccAdj);
          end;
        }

        // -------------
        //jz//CCAv9 - replace with TermLossCol
        {
        If LeftStr(Stmt, 4) = 'T776' then
        begin
          StoreElm(RetNo, FNo, kRent, ExtractedCCARec.TermLossFlag);
        end;

        If (LeftStr(Stmt, 5) = 'T2125') or (LeftStr(Stmt, 5) = 'T2042') or
          (LeftStr(Stmt, 5) = 'T1163') or (LeftStr(Stmt, 5) = 'T1273') then
        begin
          StoreElm(RetNo, FNo, KT2125, ExtractedCCARec.TermLossFlag);
        end;

        If (LeftStr(Stmt, 5) = 'T2121') then
        begin
          StoreElm(RetNo, FNo, KT2121, ExtractedCCARec.TermLossFlag);
        end;
}
        Tv[TotalNdx] := Tv[TotalNdx] + ExtractedCCARec.CCAClaimed;  //jz//CCA9 - + Tv[j + 7];
        inc(j, IncrBy);
        // 20230424
        // 20230226
        // Inc(col1,10);      //igor //20230425
        // Inc(col3,10);      //igor //20230425
        IncCols; // 20230428 Igor
      end;
    end;
    //jz//CCAv9 - theses are going to the wrong elms, populating term loss and recapture amounts must happen elsewhere??
    {
    // store term loss and recapture amounts
    If LeftStr(Stmt, 4) = 'T776' then
    begin
      StoreElm(RetNo, FNo, 159, FormatFloat('########.##', TermLossAmount));
      StoreElm(RetNo, FNo, 183, FormatFloat('########.##', RecaptAmount));
    end;
    If (LeftStr(Stmt, 5) = 'T2125') then
    begin
      StoreElm(RetNo, FNo, 215, FormatFloat('########.##', TermLossAmount));
      StoreElm(RetNo, FNo, 216, FormatFloat('########.##', RecaptAmount));
    end;

    If (LeftStr(Stmt, 5) = 'T2121') then
    begin
      StoreElm(RetNo, FNo, 215, FormatFloat('########.##', TermLossAmount));
      StoreElm(RetNo, FNo, 216, FormatFloat('########.##', RecaptAmount));
    end;

    If (LeftStr(Stmt, 5) = 'T2042') then
    begin
      StoreElm(RetNo, FNo, 215, FormatFloat('########.##', TermLossAmount));
      StoreElm(RetNo, FNo, 216, FormatFloat('########.##', RecaptAmount));
    end;

    If (LeftStr(Stmt, 5) = 'T1163') or (LeftStr(Stmt, 5) = 'T1273') then
    begin
      StoreElm(RetNo, FNo, 215, FormatFloat('########.##', TermLossAmount));
      StoreElm(RetNo, FNo, 216, FormatFloat('########.##', RecaptAmount));
    end;
    }

    Tv[RemainingNdx] := RemainingAmount;
    Tv[TotalNdx] := Tv[TotalNdx] + Tv[RemainingNdx];
  end;
end;



//jz//20260413//CCAv6 - replaced
(*
// 2021 routine that works
Procedure PostNonVehicleCCA(RetNo: integer; FName: String; Stmt: String;
  FInst: String; FNo: integer; StartNdx, EndNdx, IncrBy, EndSectionNdx,
  RemainingNdx, TotalNdx: integer);
Var
  i, j, kRent, KT2125, KT2121, KT1163, RowCount: integer; // 20230428 Igor
  RemainingAmount: Real;
  TermLossAmount, RecaptAmount: Real;
  KTermLoss, KRecapture: integer;
  CCAForStmt: Real;
  Aii: integer; // Index for AiiP
  T1175FNo, T1175FInst: integer;
  // 20230424
  Col1,  Col2,  Col3,  col4,  col5,  col6,  col7,  col8,  col9,  col10, col11,
  col12, col13, col14, col15, col16, col17, col18, col19, col20, col21, col22, col23 : integer; //jz//20260405 - add col new vars
  //jz//20260409//CCAv3 - //jz//20260405 - add chartb col elm vars
  col21T776,col22T776,col23T776,col24T776,
  T776ChartBc1,T776ChartBc2,T776ChartBc3,T776ChartBc4,T776ChartBc5,T776ChartBc6,T776ChartBc7: integer;


      procedure InitCols;
      begin
        If LeftStr(FName, 6) = 'T2125#' then
        begin
          Col1 :=383;Col2 :=384;Col3 :=385;col4 :=591;col5 :=386;col6 :=595;col7 :=561;col8 :=642;col9 :=646;col10:= 571;col11:= 197;
          col12:=890;col13:=650;col14:=182;col15:= 96;col16:=657;col17:=944;col18:=387;col19:=388;col20:=389;col21:=390;col22:= 391;   //jz//20260405 - add col elms
        end
        Else if LeftStr(FName, 6) = 'T2042#' then
        Begin
          Col1 :=483;Col2 :=484;Col3 :=485;col4 :=386;col5 :=486;col6 :=390;col7 :=487;col8 :=394;col9 :=549;col10:=553;col11:=182;
          col12:=691;col13:=557;col14:=186;col15:=190;col16:=695;col17:=738;col18:=194;col19:=488;col20:=489;col21:=490;col22:=491;   //jz//20260405//CCAv2 - add col elm, udpate elms
        end
        Else if LeftStr(FName, 6) = 'T2121#' then
        begin
          Col1 :=219;Col2 :=220;Col3 :=221;col4 :=531;col5 :=222;col6 :=548;col7 :=261;col8 :=552;col9 :=556;col10:=560;col11 :=443;
          col12:=694;col13:=564;col14:=447;col15:=451;col16:=620;col17:=637;col18:=223;col19:=224;col20:=225;col21:=226;col22:=227;   //jz//20260405CCAv2 - add col elm, udpate elms
        end
        Else if LeftStr(FName, 5) = 'T776#' then
        Begin
          Col1 :=246;Col2 :=247;Col3 :=248;col4 :=389;col5 :=249;col6 :=151;col7 :=392;col8 :=394;col9 :=396;col10:=398;col11:=168;
          col12:=598;col13:=400;col14:=170;col15:=172;col16:=618;col17:=600;col18:=250;col19:=251;col20:=252;col21:=253;              //jz//20260405 - add col elm, udpate elms
          col22:=254; //***NOTE col22 coresponds to col24

         col21T776:=253;col22T776:=428;col23T776:=586;col24T776:=254;
         T776ChartBc1:=588;T776ChartBc2:=489;T776ChartBc3:=490;T776ChartBc4:=491;T776ChartBc5:=492;T776ChartBc6:=493;T776ChartBc7:=494; //jz//20260409//CCAv3 - //jz//20260405 - add chartb col elm, udpate elms
        end
        Else if (LeftStr(FName, 7) = 'T1175H#') or (LeftStr(FName, 6) = 'T1175#')
        then
        Begin
          Col1 := 83;Col2 := 84;Col3 := 85;col4 :=412;col5 := 86;col6 :=416;col7 := 87;col8 :=420;col9 :=424;col10:=428;col11:=197;
          col12:=498;col13:=432;col14:=346;col15:=353;col16:=502;col17:=506;col18:=357;col19:= 88;col20:= 89;col21:= 90;col22:= 91;   //jz//20260405CCAv2 - add col elm, udpate elms
        end;
      end;

      procedure IncCols;
      begin
        If (LeftStr(Stmt, 4) = 'T776') then
        begin
          inc(Col1, 9);inc(Col2 ,9);inc(Col3, 9);inc(col4, 2);inc(col5, 9);inc(col6, 1);inc(col7, 1);inc(col8, 1);inc(col9, 1);inc(col10,1);inc(col11,1);              //**missing a column??
          inc(col12,1);inc(col13,1);inc(col14,1);inc(col15,1);inc(col16,1);inc(col17,9);inc(col18,9);inc(col19,9);inc(col20,9);inc(col21,9);inc(col22,1);inc(col23,9); //jz//20260405CCAv2 - add col elm, udpate increment

          inc(col21T776,9);inc(col22T776,-6);inc(col23T776,1);inc(col24T776,9);
          inc(T776ChartBc1,1);inc(T776ChartBc2,6);inc(T776ChartBc3,6);inc(T776ChartBc4,6);inc(T776ChartBc5,6);inc(T776ChartBc6,6);inc(T776ChartBc7,6);   //jz//20260409//CCAv3 - //jz//20260405 - add chartb col inc
        end
        Else if LeftStr(FName, 5) = 'T1175' then
        Begin
          inc(Col1 ,10);inc(Col2, 10);inc(Col3, 10);inc(col4,  1);inc(col5, 10);inc(col6, 1);inc(col7, 10);inc(col8,  1);inc(col9,  1);inc(col10, 1);inc(col11, 1);
          inc(col12, 1);inc(col13, 1);inc(col14, 1);inc(col15,-1);inc(col16, 1);inc(col17,1);inc(col18,-1);inc(col19,10);inc(col20,10);inc(col21,10);inc(col22,10); //jz//20260405CCAv2 - add col elm, udpate increment
        end
        Else if LeftStr(FName, 5) = 'T2042' then
        Begin
          inc(Col1 ,10);inc(Col2 ,10);inc(Col3 ,10);inc(col4 , 1);inc(col5 ,10);inc(col6 , 1);inc(col7 ,10);inc(col8 , 1);inc(col9 , 1);inc(col10, 1);inc(col11, 1);
          inc(col12, 1);inc(col13, 1);inc(col14, 1);inc(col15, 1);inc(col16, 1);inc(col17, 1);inc(col18, 1);inc(col19,10);inc(col20,10);inc(col21,10);inc(col22,10);  //jz//20260405 - add col elm, udpate increment
        end
        else             //T2125
        Begin
          inc(Col1 ,10);inc(Col2 ,10);inc(Col3 ,10);inc(col4 , 1);inc(col5 ,10);inc(col6 , 1);inc(col7 , 1);inc(col8 , 1);inc(col9 , 1);inc(col10, 1);inc(col11, 1);
          inc(col12, 1);inc(col13, 1);inc(col14, 1);inc(col15, 1);inc(col16, 1);inc(col17, 1);inc(col18,10);inc(col19,10);inc(col20,10);inc(col21,10);inc(col22,10);  //jz//20260405 - add col elm, udpate increment
        End;
      end;
begin
  TermLossAmount := 0;
  RecaptAmount := 0;
  CCAForStmt := 0;
  with Ret[RetNo].Frm[FNo] do
  begin
    ExtractCCA(RetNo, Stmt, FInst, TermLossAmount, RecaptAmount, CCAForStmt);
    For i := StartNdx to EndSectionNdx do
    begin
      Tv[i] := 0;
      StoreElm(RetNo, FNo, i, '');
    end; // clear section

    If LeftStr(Stmt, 5) = 'T1163' then
    // 20190215  delete the clear the T1175 enties
    Begin
      T1175FNo := GetFormNo('T1175' + FInst);
      if T1175FNo > 0 then
      Begin
        For i := StartNdx to EndSectionNdx do
        begin
          StoreElm(RetNo, T1175FNo, i, '');
        end; // clear section
      end;
    End;

    If LeftStr(Stmt, 5) = 'T1273' then
    // 20190215  delete the clear the T1175 enties
    Begin
      T1175FNo := GetFormNo('T1175H' + FInst);
      if T1175FNo > 0 then
      Begin
        For i := StartNdx to EndSectionNdx do
        begin
          StoreElm(RetNo, T1175FNo, i, '');
        end; // clear section
      end;
    End;

    Tv[RemainingNdx] := 0; // suppl clear
    Tv[TotalNdx] := 0;
    RemainingAmount := 0;
    j := StartNdx;
    kRent := 359;
    // for t776 so it starts from 360  ?????? NOT SURE WHY THIS IS DONE THIS WAY?
    KT2125 := 300; // so 2125 starts from 310
    KT2121 := 136; // so 2121 starts from 146
    KT1163 := -9; // 20190215

    // 20230428 Igor >>>
    // clear old values
    InitCols;
    if LeftStr(FName, 5) = 'T776#' then
      RowCount := 5
    else
      RowCount := 8;
    For i := 0 to RowCount - 1 do
    begin
      Tv[Col2] := 0;
      Tv[Col3] := 0;
      Tv[col4] := 0;
      Tv[col5] := 0;
      Tv[col6] := 0;
      Tv[col7] := 0;
      Tv[col8] := 0;
      Tv[col9] := 0;
      Tv[col10] := 0;
      Tv[col11] := 0;
      Tv[col12] := 0;
      Tv[col13] := 0;
      Tv[col14] := 0;
      Tv[col15] := 0;
      Tv[col16] := 0;
      Tv[col17] := 0;
      Tv[col18] := 0;
      Tv[col19] := 0;
      IncCols;
    end;
    InitCols;
    // 20230428 Igor <<<

    For i := 0 to ExtractedCCAlist.Count - 1 do
    begin
      kRent := kRent + 1;
      KT2125 := KT2125 + 10;
      KT2121 := KT2121 + 10;
      KT1163 := KT1163 + 10;
      ExtractedCCARec := ExtractedCCAlist.Items[i];

      TermLossAmount := TermLossAmount + ExtractedCCARec.TerminalLossAmount;
      RecaptAmount := RecaptAmount + ExtractedCCARec.RecaptureAmount;
      If j > EndNdx then
        RemainingAmount := RemainingAmount + ExtractedCCARec.CCAClaimed
      else
      begin
        StoreElm(RetNo, FNo, j, ExtractedCCARec.ClassId);
        // 20230424
        Tv[Col2] := ExtractedCCARec.Col2Val;
        Tv[Col3] := ExtractedCCARec.Col3Val;
        Tv[col4] := ExtractedCCARec.Col4Val;
        Tv[col5] := ExtractedCCARec.Col5Val;
        Tv[col6] := ExtractedCCARec.Col6Val;
        Tv[col7] := ExtractedCCARec.Col7Val;
        Tv[col8] := ExtractedCCARec.Col8Val;
        Tv[col9] := ExtractedCCARec.Col9Val;
        Tv[col10] := ExtractedCCARec.Col10Val;
        Tv[col11] := ExtractedCCARec.Col11Val;
        Tv[col12] := ExtractedCCARec.Col12Val;
        Tv[col13] := ExtractedCCARec.Col13Val;
        Tv[col14] := ExtractedCCARec.Col14Val;
        Tv[col15] := ExtractedCCARec.Col15Val;
        Tv[col16] := ExtractedCCARec.Col16Val;
        Tv[col17] := ExtractedCCARec.Col17Val;
        Tv[col18] := ExtractedCCARec.Col18Val;
        Tv[col19] := ExtractedCCARec.Col19Val;

        strings[col20] := floattostr(ExtractedCCARec.Col20Val); //jz//20260404 - add col

        Tv[col21] := ExtractedCCARec.Col21Val; //jz//20260404 - add col
        Tv[col22] := ExtractedCCARec.Col22Val; //jz//20260404 - add col
        { //20230424
          If LeftStr(Stmt, 5) = 'T1163' then // 20190215
          Begin
          Tv[i + 173] := ExtractedCCARec.AiiPAdditions; // jives the proper J
          Tv[i + 181] := MaxR(0, ExtractedCCARec.AiiPProceeds);
          Tv[i + 189] := MaxR(0, ExtractedCCARec.AiiPUccAdj);
          end;

          If LeftStr(Stmt, 5) = 'T2125' then
          Begin
          Tv[i + 189] := ExtractedCCARec.AiiPAdditions; // jives the proper J
          Tv[i + 112] := MaxR(0, ExtractedCCARec.AiiPProceeds);
          Tv[i + 120] := MaxR(0, ExtractedCCARec.AiiPUccAdj);
          end;
          If LeftStr(Stmt, 5) = 'T2042' then
          Begin
          Tv[i + 93] := ExtractedCCARec.AiiPAdditions; // jives the proper J
          Tv[i + 166] := MaxR(0, ExtractedCCARec.AiiPProceeds);
          Tv[i + 174] := MaxR(0, ExtractedCCARec.AiiPUccAdj);
          end;
          If LeftStr(Stmt, 5) = 'T2121' then
          Begin
          Tv[i + 285] := ExtractedCCARec.AiiPAdditions; // jives the proper J
          Tv[i + 293] := MaxR(0, ExtractedCCARec.AiiPProceeds);
          Tv[i + 435] := MaxR(0, ExtractedCCARec.AiiPUccAdj);
          end;

          If LeftStr(Stmt, 4) = 'T776' then
          Begin
          Tv[i + 153] := ExtractedCCARec.AiiPAdditions; // jives the proper J
          Tv[i + 158] := MaxR(0, ExtractedCCARec.AiiPProceeds);
          Tv[i + 163] := MaxR(0, ExtractedCCARec.AiiPUccAdj);
          end;
        }

        // -------------
        If LeftStr(Stmt, 4) = 'T776' then
        begin
          StoreElm(RetNo, FNo, kRent, ExtractedCCARec.TermLossFlag);
        end;

        If (LeftStr(Stmt, 5) = 'T2125') or (LeftStr(Stmt, 5) = 'T2042') or
          (LeftStr(Stmt, 5) = 'T1163') or (LeftStr(Stmt, 5) = 'T1273') then
        begin
          StoreElm(RetNo, FNo, KT2125, ExtractedCCARec.TermLossFlag);
        end;

        If (LeftStr(Stmt, 5) = 'T2121') then
        begin
          StoreElm(RetNo, FNo, KT2121, ExtractedCCARec.TermLossFlag);
        end;

        Tv[TotalNdx] := Tv[TotalNdx] + Tv[j + 7];
        inc(j, IncrBy);
        // 20230424
        // 20230226
        // Inc(col1,10);      //igor //20230425
        // Inc(col3,10);      //igor //20230425
        IncCols; // 20230428 Igor
      end;
    end;
    // store term loss and recapture amounts
    If LeftStr(Stmt, 4) = 'T776' then
    begin
      StoreElm(RetNo, FNo, 159, FormatFloat('########.##', TermLossAmount));
      StoreElm(RetNo, FNo, 183, FormatFloat('########.##', RecaptAmount));
    end;
    If (LeftStr(Stmt, 5) = 'T2125') then
    begin
      StoreElm(RetNo, FNo, 215, FormatFloat('########.##', TermLossAmount));
      StoreElm(RetNo, FNo, 216, FormatFloat('########.##', RecaptAmount));
    end;

    If (LeftStr(Stmt, 5) = 'T2121') then
    begin
      StoreElm(RetNo, FNo, 215, FormatFloat('########.##', TermLossAmount));
      StoreElm(RetNo, FNo, 216, FormatFloat('########.##', RecaptAmount));
    end;

    If (LeftStr(Stmt, 5) = 'T2042') then
    begin
      StoreElm(RetNo, FNo, 215, FormatFloat('########.##', TermLossAmount));
      StoreElm(RetNo, FNo, 216, FormatFloat('########.##', RecaptAmount));
    end;

    If (LeftStr(Stmt, 5) = 'T1163') or (LeftStr(Stmt, 5) = 'T1273') then
    begin
      StoreElm(RetNo, FNo, 215, FormatFloat('########.##', TermLossAmount));
      StoreElm(RetNo, FNo, 216, FormatFloat('########.##', RecaptAmount));
    end;

    Tv[RemainingNdx] := RemainingAmount;
    Tv[TotalNdx] := Tv[TotalNdx] + Tv[RemainingNdx];
  end;
end;
*)

Procedure PostAutoCCA(RetNo: integer; FName: String; Stmt: String; FInst: String; FNo: integer;
                      RemainingNdx, TotalNdx: integer);
Var
  i, RowCount , EndNdx: integer; //StartNdx//jz//20260411//CCAv4 - not used
  //j: integer;                             //jz//20260411//CCAv4 - not used
  TermLossAmount, RecaptAmount, RemainingAmount: Real;
  AutoCCAForStmt: Real;
  CCAForStmt: Real;
  Col1,  Col2,  Col3,  col4,  col5,  col6,  col7,  col8,  col9,  col10, col11,
  col12, col13, col14, col15, col16, col17, col18, col19, col20, col21, col22, col23 : integer; //jz//20260405 - add col new vars

  //jz//20260409//CCAv3 - //jz//20260405 - add chartb col elm vars
  col21T776,col22T776,col23T776,col24T776,
  T776ChartBc1,T776ChartBc2,T776ChartBc3,T776ChartBc4,T776ChartBc5,T776ChartBc6,T776ChartBc7: integer;
  procedure InitCols;
  begin
    If LeftStr(FName, 6) = 'T2125#' then
    begin
      Col1 :=383;Col2 :=384;Col3 :=385;col4 :=591;col5 :=386;col6 :=595;col7 :=561;col8 :=642;col9 :=646;col10:= 571;col11:= 197;
      col12:=890;col13:=650;col14:=182;col15:= 96;col16:=657;col17:=944;col18:=387;col19:=388;col20:=389;col21:=390;col22:= 391;   //jz//20260405 - add col elms
    end
    Else if LeftStr(FName, 6) = 'T2042#' then
    Begin
      Col1 :=483;Col2 :=484;Col3 :=485;col4 :=386;col5 :=486;col6 :=390;col7 :=487;col8 :=394;col9 :=549;col10:=553;col11:=182;
      col12:=691;col13:=557;col14:=186;col15:=190;col16:=695;col17:=738;col18:=194;col19:=488;col20:=489;col21:=490;col22:=491;   //jz//20260405//CCAv2 - add col elm, udpate elms
    end
    Else if LeftStr(FName, 6) = 'T2121#' then
    begin
      Col1 :=219;Col2 :=220;Col3 :=221;col4 :=531;col5 :=222;col6 :=548;col7 :=261;col8 :=552;col9 :=556;col10:=560;col11 :=443;
      col12:=694;col13:=564;col14:=447;col15:=451;col16:=620;col17:=637;col18:=223;col19:=224;col20:=225;col21:=226;col22:=227;   //jz//20260405CCAv2 - add col elm, udpate elms
    end
    Else if LeftStr(FName, 5) = 'T776#' then
    Begin
      Col1 :=246;Col2 :=247;Col3 :=248;col4 :=389;col5 :=249;col6 :=151;col7 :=392;col8 :=394;col9 :=396;col10:=398;col11:=168;
      col12:=598;col13:=400;col14:=170;col15:=172;col16:=618;col17:=600;col18:=250;col19:=251;col20:=252;col21:=253;              //jz//20260405 - add col elm, udpate elms
      col22:=254; //***NOTE col22 coresponds to col24

     col21T776:=253;col22T776:=428;col23T776:=586;col24T776:=254;
     T776ChartBc1:=588;T776ChartBc2:=489;T776ChartBc3:=490;T776ChartBc4:=491;T776ChartBc5:=492;T776ChartBc6:=493;T776ChartBc7:=494; //jz//20260409//CCAv3 - //jz//20260405 - add chartb col elm, udpate elms
    end
    Else if (LeftStr(FName, 7) = 'T1175H#') or (LeftStr(FName, 6) = 'T1175#')
    then
    Begin
      Col1 := 83;Col2 := 84;Col3 := 85;col4 :=412;col5 := 86;col6 :=416;col7 := 87;col8 :=420;col9 :=424;col10:=428;col11:=197;
      col12:=498;col13:=432;col14:=346;col15:=353;col16:=502;col17:=506;col18:=357;col19:= 88;col20:= 89;col21:= 90;col22:= 91;   //jz//20260405CCAv2 - add col elm, udpate elms
    end;
  end;

  procedure IncCols;
  begin
    If (LeftStr(Stmt, 4) = 'T776') then
    begin
      inc(Col1, 9);inc(Col2 ,9);inc(Col3, 9);inc(col4, 2);inc(col5, 9);inc(col6, 1);inc(col7, 1);inc(col8, 1);inc(col9, 1);inc(col10,1);inc(col11,1);              //**missing a column??
      inc(col12,1);inc(col13,1);inc(col14,1);inc(col15,1);inc(col16,1);inc(col17,9);inc(col18,9);inc(col19,9);inc(col20,9);inc(col21,9);inc(col22,1);inc(col23,9); //jz//20260405CCAv2 - add col elm, udpate increment

      inc(col21T776,9);inc(col22T776,-6);inc(col23T776,1);inc(col24T776,9);
      inc(T776ChartBc1,1);inc(T776ChartBc2,6);inc(T776ChartBc3,6);inc(T776ChartBc4,6);inc(T776ChartBc5,6);inc(T776ChartBc6,6);inc(T776ChartBc7,6);   //jz//20260409//CCAv3 - //jz//20260405 - add chartb col inc
    end
    Else if LeftStr(FName, 5) = 'T1175' then
    Begin
      inc(Col1 ,10);inc(Col2, 10);inc(Col3, 10);inc(col4,  1);inc(col5, 10);inc(col6, 1);inc(col7, 10);inc(col8,  1);inc(col9,  1);inc(col10, 1);inc(col11, 1);
      inc(col12, 1);inc(col13, 1);inc(col14, 1);inc(col15,-1);inc(col16, 1);inc(col17,1);inc(col18,-1);inc(col19,10);inc(col20,10);inc(col21,10);inc(col22,10); //jz//20260405CCAv2 - add col elm, udpate increment
    end
    Else if LeftStr(FName, 5) = 'T2042' then
    Begin
      inc(Col1 ,10);inc(Col2 ,10);inc(Col3 ,10);inc(col4 , 1);inc(col5 ,10);inc(col6 , 1);inc(col7 ,10);inc(col8 , 1);inc(col9 , 1);inc(col10, 1);inc(col11, 1);
      inc(col12, 1);inc(col13, 1);inc(col14, 1);inc(col15, 1);inc(col16, 1);inc(col17, 1);inc(col18, 1);inc(col19,10);inc(col20,10);inc(col21,10);inc(col22,10);  //jz//20260405 - add col elm, udpate increment
    end
    else             //T2125
    Begin
      inc(Col1 ,10);inc(Col2 ,10);inc(Col3 ,10);inc(col4 , 1);inc(col5 ,10);inc(col6 , 1);inc(col7 , 1);inc(col8 , 1);inc(col9 , 1);inc(col10, 1);inc(col11, 1);
      inc(col12, 1);inc(col13, 1);inc(col14, 1);inc(col15, 1);inc(col16, 1);inc(col17, 1);inc(col18,10);inc(col19,10);inc(col20,10);inc(col21,10);inc(col22,10);  //jz//20260405 - add col elm, udpate increment
    End;
  end;

begin
  TermLossAmount := 0;
  RecaptAmount := 0;
  CCAForStmt := 0;

  with Ret[RetNo].Frm[FNo] do
  begin
    ExtractAutos(RetNo, Stmt, FInst, TermLossAmount, RecaptAmount,AutoCCAForStmt);

    //jz//20260414//CCAv7 - done on the forms now with GetTotalTerminalLoss and GetTotalRecaptureAmount
    {
    If LeftStr(FName, 6) = 'T2125#' then
    begin
      Tv[515] := Tv[515] + TermLossAmount;
      Tv[516] := Tv[516] + RecaptAmount;
    end
    else if LeftStr(FName, 6) = 'T2042#' then
      Tv[134] := Tv[134] + TermLossAmount;
}

    Tv[RemainingNdx] := 0; // suppl clear
    Tv[TotalNdx] := 0;
    RemainingAmount := 0;
    //j := StartNdx;      //jz//20260411//CCAv4 - not used
    //StartNdx := Col1;   //jz//20260411//CCAv4 - not used

    InitCols;     // clear old values
    if LeftStr(FName, 5) = 'T776#' then
      RowCount := 2
    else
      RowCount := 4;
    For i := 0 to RowCount - 1 do
    begin
      strings[Col1] := '';  //jz//20260411//CCAv4 - clear
      Tv[Col2] := 0;Tv[Col3] := 0;Tv[col4] := 0;Tv[col5] := 0;Tv[col6] := 0;Tv[col7] := 0;Tv[col8] := 0;Tv[col9] := 0;Tv[col10] := 0;Tv[col11] := 0;
      Tv[col12]:= 0;Tv[col13]:= 0;Tv[col14]:= 0;Tv[col15]:= 0;Tv[col16]:= 0;Tv[col17]:= 0;Tv[col18]:= 0;Tv[col19]:= 0;

      strings[col20] := ''; //jz//20260405 - change to strings
      Tv[col21] := 0;
      if LeftStr(FName, 5) = 'T776#' then
      begin
        Tv[col21T776]:=0;Tv[col22T776]:=0;Tv[col23T776]:=0;Tv[col24T776]:=0;
        strings[T776ChartBc1]:='';strings[T776ChartBc2]:='';strings[T776ChartBc3]:='';Tv[T776ChartBc4]:=0;strings[T776ChartBc5]:='';strings[T776ChartBc6]:='';Tv[T776ChartBc7]:=0; //jz//20260409//CCAv3 - //jz//20260405 - init chartb col val
      end
      else
      	Tv[col22] := 0;

      EndNdx := Col1; // 20230523 Igor //jz//20260411//CCAv4 - necessary as is used below for RemainingAmount, seems to work?
                                                     //        probably should be renamed
      IncCols;
    end;
    InitCols;

    For i := 0 to ExtractedAutoList.Count - 1 do
    begin
      ExtractedAutoRec := ExtractedAutoList.Items[i];

      If ExtractedAutoRec.PartnerFlag = '' then
      begin
        If Col1 > EndNdx then
          RemainingAmount := RemainingAmount + ExtractedAutoRec.CCAClaimed
        else
        begin
          StoreElm(RetNo, FNo, Col1, ExtractedAutoRec.Col1Val);
          Tv[Col2]  := ExtractedAutoRec.Col2Val;
          Tv[Col3]  := ExtractedAutoRec.Col3Val;
          Tv[col4]  := ExtractedAutoRec.Col4Val;
          Tv[col5]  := ExtractedAutoRec.Col5Val;
          Tv[col6]  := ExtractedAutoRec.Col6Val;
          Tv[col7]  := ExtractedAutoRec.Col7Val;
          Tv[col8]  := ExtractedAutoRec.Col8Val;
          Tv[col9]  := ExtractedAutoRec.Col9Val;
          Tv[col10] := ExtractedAutoRec.Col10Val;
          Tv[col11] := ExtractedAutoRec.Col11Val;
          Tv[col12] := ExtractedAutoRec.Col12Val;
          Tv[col13] := ExtractedAutoRec.Col13Val;
          Tv[col14] := ExtractedAutoRec.Col14Val;
          Tv[col15] := ExtractedAutoRec.Col15Val;
          Tv[col16] := ExtractedAutoRec.Col16Val;
          Tv[col17] := ExtractedAutoRec.Col17Val; //jz//20260405  //StoreElm(RetNo, FNo, col17, FormatFloat('###.##',ExtractedAutoRec.Col17Val));
          Tv[col18] := ExtractedAutoRec.Col18Val; //jz//20260406-  no longer the CCA, do not adjust * ExtractedAutoRec.StatementPercent / 100; // 20230717           // TV[Col18]:=ExtractedAutoRec.Col18Val;
          Tv[col19] := ExtractedAutoRec.Col19Val; //Tv[col7] - Tv[col18];

          strings[col20] := floattostr(ExtractedAutoRec.Col20Val); //jz//20260405 - add

          If LeftStr(Stmt, 4) = 'T776' then //jz//20260409//CCAv3 - account for T776 extra cols and chartb
          begin
            Tv[col22] := 0;                                 //jz - not valid for T776
            Tv[col21T776]         := ExtractedAutoRec.col21T776Val;
            Tv[col22T776]         := ExtractedAutoRec.col22T776Val;
            Tv[col23T776]         := ExtractedAutoRec.col23T776Val;
            Tv[col24T776]         := ExtractedAutoRec.col24T776Val;
            If ExtractedAutoRec.T776ChartBc6Val > '0' then  //jz - only populate if possible to have value
            begin
              strings[T776ChartBc1] := ExtractedAutoRec.T776ChartBc1Val;
              strings[T776ChartBc2] := ExtractedAutoRec.T776ChartBc2Val;
              strings[T776ChartBc3] := ExtractedAutoRec.T776ChartBc3Val;
              Tv[T776ChartBc4]      := ExtractedAutoRec.T776ChartBc4Val;
              strings[T776ChartBc5] := ExtractedAutoRec.T776ChartBc5Val;
              strings[T776ChartBc6] := ExtractedAutoRec.T776ChartBc6Val;
              Tv[T776ChartBc7]      := ExtractedAutoRec.T776ChartBc7Val;
            end;
          end
          else
          begin
            Tv[col21] := ExtractedAutoRec.CCAClaimed;  //jz//20260406 - what is all this BS, take final value directly //ExtractedAutoRec.Col21Val;   * ExtractedAutoRec.StatementPercent   //jz//20260405 - add
            Tv[col22] := ExtractedAutoRec.Col22Val;   //jz//20260405 - add
          end;
        end;
        Tv[TotalNdx] := Tv[TotalNdx] + ExtractedAutoRec.CCAClaimed; //jz//20260406 - what is all this BS, take final value directly //ExtractedAutoRec.Col21Val * ExtractedAutoRec.StatementPercent / 100; //jz//20260405 - Col21Val from Col18Val // 20230717
                                                   //               BUT this should really be done on form for override purposes
        // Tv[TotalNdx] := Tv[TotalNdx] + ExtractedAutoRec.Col18Val;
        IncCols;
      end;
    end;
    Tv[RemainingNdx] := RemainingAmount;
    // Tv[TotalNdx] := Tv[TotalNdx] + Tv[RemainingNdx]; //20230523 Igor probably should be removed
  end;
end;

Function PostCCAFromAssetsB(RetNo: integer): Boolean;
begin
  Result := false;
  If (UpperCase(FetchElm(RetNo, 'ASSETSB#1', 10)) = 'Y') then
    Result := true;
end;

Procedure PostNonBuildingAdditions(RetNo: integer; FName: String; Stmt: String;
  FInst: String; FNo: integer; StartNdx, EndNdx, IncrBy, EndSectionNdx,
  RemainingNdx, TotalNdx: integer);
Var
  i, j: integer;
  RemainingAmount: Real;
  TermLossAmount, RecaptAmount: Real;
  CCAForStatement: Real;
begin
  with Ret[RetNo].Frm[FNo] do
  begin
    ExtractCCA(RetNo, Stmt, FInst, TermLossAmount, RecaptAmount,CCAForStatement);
    For i := StartNdx to EndSectionNdx do
    begin
      Tv[i] := 0;
      StoreElm(RetNo, FNo, i, '');
    end; // clear section
    RemainingAmount := 0;
    Tv[RemainingNdx] := 0;
    j := StartNdx;
    For i := 0 to ExtractedCCAlist.Count - 1 do
    begin
      ExtractedCCARec := ExtractedCCAlist.Items[i];
      If ExtractedCCARec.RecordKeeping <> 'X' then
      Begin
        If IsBuildingClass(ExtractedCCARec.ClassId) = false then
        Begin
          If ExtractedCCARec.Additions > 0 then
          begin
            If j > EndNdx then
              RemainingAmount := MaxR(0, RemainingAmount + ExtractedCCARec.Cost
                - ExtractedCCARec.AdditionsPersonal)
            else
            begin
              StoreElm(RetNo, FNo, j, ExtractedCCARec.ClassId);
              StoreElm(RetNo, FNo, j + 1, ExtractedCCARec.Description);
              Tv[j + 2] := ExtractedCCARec.Cost;
              Tv[j + 3] := ExtractedCCARec.AdditionsPersonal;
              Tv[446] := Tv[446] + Tv[j + 3];
              // 20110204    //Tv[146]:=Tv[146]+Tv[j+3];
              inc(j, IncrBy);
            end;
          end;
        end;
      end; // no record keeping
    end; // i
    Tv[RemainingNdx] := RemainingAmount;
  end;
end;

procedure PostNonCompliantShortTermRentalsCCA(RetNo: integer; FName: String; Stmt: String;
                                              FInst: String; FNo: integer; StartNdx, EndNdx, IncrBy, EndSectionNdx,
                                              RemainingNdx, TotalNdx: integer);
var
  i, j: integer;
  ExtractedListCount: integer;

  rowsFilled, rowsInChart: integer;

  T776ChartBc1,T776ChartBc2,T776ChartBc3,T776ChartBc4,T776ChartBc5,T776ChartBc6,T776ChartBc7:integer;
  TermLossAmount, RecaptAmount, CCAForStatement, RemainingAmount:real;

  ss:string;


      procedure initChartBColElms();
      begin
        T776ChartBc1:=588;T776ChartBc2:=489;T776ChartBc3:=490;T776ChartBc4:=491;T776ChartBc5:=492;T776ChartBc6:=493;T776ChartBc7:=494;
      end;
      procedure incChartBColElms();
      begin
        inc(T776ChartBc1,1);inc(T776ChartBc2,6);inc(T776ChartBc3,6);inc(T776ChartBc4,6);inc(T776ChartBc5,6);inc(T776ChartBc6,6);inc(T776ChartBc7,6);
      end;
      procedure clearT776ChartBVal();
      var i:integer;
      begin
        for i:= 0 to 6 do
        begin
          with Ret[RetNo].Frm[Fno] do
          begin
            strings[T776ChartBc1] := '';strings[T776ChartBc2] := '';strings[T776ChartBc3] := '';Tv[T776ChartBc4]:= 0;
            strings[T776ChartBc5] := '';strings[T776ChartBc6] := '';Tv[T776ChartBc7]:= 0;
          end;
          incChartBColElms;
        end;
        initChartBColElms //important to init so ready to be used again in next loop
      end;


begin
  with Ret[RetNo].Frm[Fno] do
  begin

    ExtractCCA  (RetNo, 'T776', FInst, TermLossAmount, RecaptAmount,CCAForStatement);
    ExtractAutos(RetNo, 'T776', FInst, TermLossAmount, RecaptAmount,CCAForStatement);

    initChartBColElms;
    clearT776ChartBVal;

    rowsFilled        := 0;
    rowsInChart       := 7 - 1;
    RemainingNdx      := 359;
    Tv[RemainingNdx]  := 0;
    RemainingAmount   := 0;

    For i := 0 to ExtractedCCAlist.Count - 1 do
    begin
      ExtractedCCAREC := ExtractedCCAlist.Items[i];
      If ExtractedCCAREC.RecordKeeping <> 'X' then
      Begin
        If rowsFilled > rowsInChart then RemainingAmount := RemainingAmount + ExtractedCCAREC.T776ChartBc7Val
        else
        begin
          strings[T776ChartBc1] := ExtractedCCAREC.T776ChartBc1Val;
          strings[T776ChartBc2] := ExtractedCCAREC.T776ChartBc2Val;
          strings[T776ChartBc3] := ExtractedCCAREC.T776ChartBc3Val;
          Tv[T776ChartBc4]      := ExtractedCCAREC.T776ChartBc4Val;
          strings[T776ChartBc5] := ExtractedCCAREC.T776ChartBc5Val;
          strings[T776ChartBc6] := ExtractedCCAREC.T776ChartBc6Val;
          Tv[T776ChartBc7]      := ExtractedCCAREC.T776ChartBc7Val;

          incChartBColElms;
          inc(rowsFilled,1);
        end;
      end; // no record keeping
    end; // i

    For i := 0 to ExtractedAutoList.Count - 1 do
    begin
      ExtractedAutoREC := ExtractedAutoList.Items[i];
      //If ExtractedAutoREC.RecordKeeping <> 'X' then //jz - no RecordKeeping option in autos
      Begin
        If rowsFilled > rowsInChart then RemainingAmount := RemainingAmount + ExtractedAutoREC.T776ChartBc7Val
        else
        begin
          strings[T776ChartBc1] := ExtractedAutoREC.T776ChartBc1Val;
          strings[T776ChartBc2] := ExtractedAutoREC.T776ChartBc2Val;
          strings[T776ChartBc3] := ExtractedAutoREC.T776ChartBc3Val;
          Tv[T776ChartBc4]      := ExtractedAutoREC.T776ChartBc4Val;
          strings[T776ChartBc5] := ExtractedAutoREC.T776ChartBc5Val;
          strings[T776ChartBc6] := ExtractedAutoREC.T776ChartBc6Val;
          Tv[T776ChartBc7]      := ExtractedAutoREC.T776ChartBc7Val;

          incChartBColElms;
          inc(rowsFilled,1);
        end;
      end; // no record keeping
    end; // i

    Tv[RemainingNdx] := RemainingAmount;

  end; //with
end;
Procedure PostBuildingAdditions(RetNo: integer; FName: String; Stmt: String;
  FInst: String; FNo: integer; StartNdx, EndNdx, IncrBy, EndSectionNdx,
  RemainingNdx, TotalNdx: integer);
Var
  i, j: integer;
  RemainingAmount: Real;
  TermLossAmount, RecaptAmount: Real;
  CCAForStatement: Real;
begin
  with Ret[RetNo].Frm[FNo] do
  begin
    ExtractCCA(RetNo, Stmt, FInst, TermLossAmount, RecaptAmount, CCAForStatement);
    For i := StartNdx to EndSectionNdx do
    begin
      Tv[i] := 0;
      StoreElm(RetNo, FNo, i, '');
    end; // clear section
    RemainingAmount := 0;
    Tv[RemainingNdx] := 0;
    j := StartNdx;
    For i := 0 to ExtractedCCAlist.Count - 1 do
    begin
      ExtractedCCARec := ExtractedCCAlist.Items[i];
      If ExtractedCCARec.RecordKeeping <> 'X' then
      Begin
        If IsBuildingClass(ExtractedCCARec.ClassId) = true then
        Begin
          If ExtractedCCARec.Additions > 0 then
          begin
            If j > EndNdx then
              RemainingAmount := MaxR(0, RemainingAmount + ExtractedCCARec.Cost
                - ExtractedCCARec.AdditionsPersonal)
            else
            begin
              StoreElm(RetNo, FNo, j, ExtractedCCARec.ClassId);
              StoreElm(RetNo, FNo, j + 1, ExtractedCCARec.Description);
              Tv[j + 2] := ExtractedCCARec.Cost;
              Tv[j + 3] := ExtractedCCARec.AdditionsPersonal;
              Tv[j + 4] := MaxR(0, Tv[j + 2] - Tv[j + 3]);
              inc(j, IncrBy);
            end;
          end;
        end;
      end;
    end; // i
    Tv[RemainingNdx] := RemainingAmount;
  end;
end;

Procedure PostNonBuildingDispositions(RetNo: integer; FName: String;
  Stmt: String; FInst: String; FNo: integer;
  StartNdx, EndNdx, IncrBy, EndSectionNdx, RemainingNdx, TotalNdx: integer);
Var
  i, j: integer;
  RemainingAmount: Real;
  TermLossAmount, RecaptAmount: Real;
  CCAForStatement: Real;
Begin
  with Ret[RetNo].Frm[FNo] do
  begin
    ExtractCCA(RetNo, Stmt, FInst, TermLossAmount, RecaptAmount,
      CCAForStatement);
    For i := StartNdx to EndSectionNdx do
    begin
      Tv[i] := 0;
      StoreElm(RetNo, FNo, i, '');
    end; // clear section
    RemainingAmount := 0;
    Tv[RemainingNdx] := 0;
    j := StartNdx;
    For i := 0 to ExtractedCCAlist.Count - 1 do
    begin
      ExtractedCCARec := ExtractedCCAlist.Items[i];
      If ExtractedCCARec.RecordKeeping <> 'X' then
      Begin
        If IsBuildingClass(ExtractedCCARec.ClassId) = false then
        begin
          If ExtractedCCARec.Proceeds > 0 then
          begin
            If j > EndNdx then
              RemainingAmount :=
                MaxR(0, RemainingAmount + ExtractedCCARec.Proceeds -
                ExtractedCCARec.ProceedsPersonal)
            else
            begin
              StoreElm(RetNo, FNo, j, ExtractedCCARec.ClassId);
              StoreElm(RetNo, FNo, j + 1, ExtractedCCARec.Description);
              Tv[j + 2] := ExtractedCCARec.Proceeds;
              Tv[j + 3] := ExtractedCCARec.ProceedsPersonal;
              Tv[j + 4] := MaxR(0, Tv[j + 2] - Tv[j + 3]);
              inc(j, IncrBy);
            end;
          end;
        end;
      end;
    end;
    Tv[RemainingNdx] := RemainingAmount;
  end;
end;

Procedure PostBuildingDispositions(RetNo: integer; FName: String; Stmt: String;
  FInst: String; FNo: integer; StartNdx, EndNdx, IncrBy, EndSectionNdx,
  RemainingNdx, TotalNdx: integer);
Var
  i, j: integer;
  RemainingAmount: Real;
  TermLossAmount, RecaptAmount: Real;
  CCAForStatement: Real;
begin
  with Ret[RetNo].Frm[FNo] do
  begin
    ExtractCCA(RetNo, Stmt, FInst, TermLossAmount, RecaptAmount,
      CCAForStatement);
    For i := StartNdx to EndSectionNdx do
    begin
      Tv[i] := 0;
      StoreElm(RetNo, FNo, i, '');
    end; // clear section
    RemainingAmount := 0;
    Tv[RemainingNdx] := 0;
    j := StartNdx;
    For i := 0 to ExtractedCCAlist.Count - 1 do
    begin
      ExtractedCCARec := ExtractedCCAlist.Items[i];
      If IsBuildingClass(ExtractedCCARec.ClassId) = true then
      begin
        If ExtractedCCARec.Proceeds > 0 then
        begin
          If j > EndNdx then
            RemainingAmount :=
              MaxR(0, RemainingAmount + ExtractedCCARec.Proceeds -
              ExtractedCCARec.ProceedsPersonal)
          else
          begin
            StoreElm(RetNo, FNo, j, ExtractedCCARec.ClassId);
            If ExtractedCCARec.RecordKeeping <> 'X' then
            Begin
              StoreElm(RetNo, FNo, j + 1, ExtractedCCARec.Description);
              Tv[j + 2] := ExtractedCCARec.Proceeds;
              Tv[j + 3] := ExtractedCCARec.ProceedsPersonal;
              inc(j, IncrBy);
            end;
          end;
        end;
      end;
    end; // i
    Tv[RemainingNdx] := RemainingAmount;
  end;
end;

Function AnySplittableCredits(RetNo, OptimizeFNo: integer): Boolean;
begin
  Result := false;
  If (VL(FetchElmFNo(RetNo, OptimizeFNo, 2)) > 0) or
    (VL(FetchElmFNo(RetNo, OptimizeFNo, 58)) > 0) or
    (VL(FetchElmFNo(RetNo, OptimizeFNo, 45)) > 0) or
    (VL(FetchElmFNo(RetNo, OptimizeFNo, 37)) > 0) or
    (VL(FetchElmFNo(RetNo, OptimizeFNo, 61)) > 0) or
    (VL(FetchElmFNo(RetNo, OptimizeFNo, 48)) > 0) or
    (VL(FetchElmFNo(RetNo, OptimizeFNo, 7)) > 0) or
    (VL(FetchElmFNo(RetNo, OptimizeFNo, 10)) > 0) then
    Result := true;
end;

// 20200426
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

Procedure EMailToClient(RetNo: integer);
Var
  SomeSubject, SomeRecipientEMail, SomeSenderEMail, SomeAttachment: String;
  SomeText: String;
begin
  SomeSubject := 'Your tax return';
  SomeRecipientEMail := FetchElm(RetNo, 'INFO', 140); // 64); //20170512
  SomeSenderEMail := '';
  SomeAttachment := '';
  SomeText := Chr(13) + Chr(13) + 'Thank you ' + Chr(13) + ' ' + Chr(13) +
    OptRec.Prp_Name + Chr(13) + ' (' + OptRec.Prp_Area + ') ' + OptRec.Prp_Tel;

  SomeText := SomeText + '%0D%0A';
  // %0D%0A is hex for 10 (linefeed) and 13 (carriage return) //Chr(10)+Chr(13);
  // 20111108 //john
  ShellExecute(Application.MainForm.Handle, nil,
    PChar('' + 'mailto:' + SomeRecipientEMail + '?Subject=' + SomeSubject +
    '&Body=' + SomeText), nil, nil, SW_NORMAL);
  // MainForm.SendMapiMail(SomeSubject,SomeText,SomeAttachment,'','','',SomeRecipientEMail);
end;

Procedure EMailAFormToClient(RetNo: integer; FormName: String);
Var
  SomeSubject, SomeRecipientEMail, SomeSenderEMail, SomeAttachment: String;
  SomeText: String;
begin
  SomeSubject := 'Form ' + FormName + ' attached';
  SomeRecipientEMail := FetchElm(RetNo, 'INFO', 64);
  SomeSenderEMail := '';
  SomeAttachment := '';
  SomeText := Chr(13) + Chr(13) + 'Thank you ' + Chr(13) + ' ' + Chr(13) +
    OptRec.Prp_Name + Chr(13) + ' (' + OptRec.Prp_Area + ') ' + OptRec.Prp_Tel;
  MainFormT1.SendMapiMail(SomeSubject, SomeText, SomeAttachment, '', '', '',
    SomeRecipientEMail);
end;

// 20150707
Function TaxDeductedForEligiblePension(RetNo: integer; Var FromT4a: Real;
  Var FromT4Rif: Real; Var FromT4RSP: Real; Var FromT4ARCA: Real): Real;
Var
  i, k, FNo: integer;
  ExchRate, PercentShare: Real;
begin
  Result := 0; // 20150708  Init  It is using variables, no result
  FromT4a := 0;
  FromT4Rif := 0;
  FromT4RSP := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    FNo := FRec.FormNo;

    if FRec.FormName = 'T4A' then
    begin
      If Ret[RetNo].FrmHasData[FNo] then
      begin
        If VL(FetchElmFNo(RetNo, FNo, 1)) > 0 then
          FromT4a := FromT4a + VL(Ret[RetNo].Frm[FNo].Strings[4])
        else
        begin
          If VL(FetchElmFNo(RetNo, FNo, 2)) = 0 then // Lump sum box 18
          begin
            If ((Ret[RetNo].Age >= 65) or (UpperCase(FetchElmFNo(RetNo, FNo, 41)
              ) = 'Y')) then { box 24/annuities }
              FromT4a := FromT4a + VL(FetchElmFNo(RetNo, FNo, 4));
          end;
        End;
      end; // has data
    end // t4a

    Else if FRec.FormName = 'T4RIF' then
    begin
      If Ret[RetNo].FrmHasData[FNo] then // 20170324 Igor
      begin
        If (UpperCase(FetchElmFNo(RetNo, FNo, 16)) = 'Y') { death of spose }
          or (Ret[RetNo].Age >= 65) then
        begin
          If UpperCase(FetchElmFNo(RetNo, FNo, 15)) <> 'Y' then // spousal
          begin
            If VL(FetchElmFNo(RetNo, FNo, 2)) > 0 then
              FromT4Rif := FromT4Rif + VL(FetchElmFNo(RetNo, FNo, 7));
          end;
        end;
      end;
    end

    Else if FRec.FormName = 'T4RSP' then
    begin
      If Ret[RetNo].FrmHasData[FNo] then // 20170324 Igor
      begin
        If (Ret[RetNo].Age >= 65) or (FetchElmFNo(RetNo, FNo, 3) > '')
        then { due to death }
        begin
          If VL(FetchElmFNo(RetNo, FNo, 2)) > 0 then
            FromT4RSP := FromT4RSP + VL(FetchElmFNo(RetNo, FNo, 11));
        end;
      end;
    end
    // 20150313
    Else if FRec.FormName = 'T4ARCA' then
    begin
      If Ret[RetNo].FrmHasData[FNo] then // 20170324 Igor
      begin
        If (Ret[RetNo].Age >= 65) then
        begin
          If VL(FetchElmFNo(RetNo, FRec.FormNo, 2)) > 0 then
            FromT4ARCA := FromT4ARCA + VL(FetchElmFNo(RetNo, FNo, 7));
        end;
      end;
    end;
  end; // i

end;

(*
  //20230111
  Function GetLn314(RetNo: Integer): Real;
  Var
  FNo: Integer;
  SpRetNo:Integer;
  begin
  Result := VL(FetchElm(RetNo, 'PNSDED', 8));
  FNo := GetFormNo('T1032');
  // if splitting pension
  If (UpperCase(FetchElmFNo(RetNo, FNo, 34)) = 'Y') and    //eligible
  (VL(FetchElmFNo(RetNo, FNo, 32)) > 0) then    //% >0
  begin
  // pensioner
  If GetSinNo(RetNo) = FetchElmFNo(RetNo, FNo, 4) then
  Result := MinR(2000, VL(FetchElmFNo(RetNo, FNo, 71))) //20220111  Result := MinR(2000, VL(FetchElmFNo(RetNo, FNo, 20)))
  else If GetSinNo(RetNo) = FetchElmFNo(RetNo, FNo, 9) then
  Result := MinR(2000, VL(FetchElmFNo(RetNo, FNo, 23)));//MinR(2000, VL(FetchElmFNo(RetNo, FNo, 23)));
  end;
  Result := MaxR(0, Result);
  end;
*)


// It works ok for pensioner as of 20230111

// 20230111  //put back on J23
Function GetLn314(RetNo: integer): Real;
Var
  FNo: integer;
begin
  Result := VL(FetchElm(RetNo, 'PNSDED', 8));
  FNo := GetFormNo('T1032');
  // if splitting pension
  If (UpperCase(FetchElmFNo(RetNo, FNo, 34)) = 'Y') and // eligible
    (VL(FetchElmFNo(RetNo, FNo, 17)) > 0) then // elected transfer //20230315
  begin
    // 20230123
    // pensioner
    If GetSinNo(RetNo) = FetchElmFNo(RetNo, FNo, 4) then   //transferring spouse
      Result := MinR(2000, VL(FetchElmFNo(RetNo, FNo, 20)))
    else If GetSinNo(RetNo) = FetchElmFNo(RetNo, FNo, 9) then
      Result := MinR(2000, VL(FetchElmFNo(RetNo, FNo, 23)));
  end;
  Result := MaxR(0, Result);
end;

Function GetPrvPnsDed(RetNo: integer): Real;
Var
  FNo: integer;
  MaxPrvDed: Real;
begin
  Result := MinR(Ret[RetNo].Lnn[31400], PrvConstant[RY].PrvMaxPensionAmount);
  (*
    Result:=Vl(FetchElm(RetNo,'PNSDED',18));  //ws
    //splitting
    If (Result=0) and (Ret[RetNo].Lnn[31400]>0) then
    begin
    Result:=MinR(Ret[RetNo].Lnn[31400],PrvConstant[RY].PrvMaxPensionAmount);
    end;
  *)
end;

Function GetOptimumPensionSplit(RetNo: integer;
  Var PercentElm: integer): integer;
// it puts the before split in elm 22 of optimize form, after split total in elm 25 and savings into elm 26
Var
  i1, i2, spouseIndex, OptimizeFNo, SpRetNo, RNo, IncrBy: integer;
  FamilyTotal, LowestTotal, LastFamilyTotal, BeforeSplitFamilyTotal,
    BeforeSplitFedTax: Real;
  PensionPercent, OptimumPensionPercent: integer;
  RetToOptimize: integer;
  T1032FNo, MPercent: integer;
  OptimizeCreditsSw: Boolean;
  PensionerRetNo, TransfereeRetNo: integer;
var
  i: integer;
begin

  Screen.Cursor := crHourGlass;
  OptimizeBtnClicked := true;
  OptimizeFNo := GetFormNo('OPTIMIZE');
  T1032FNo := GetFormNo('T1032');
  PensionerRetNo := GetPensionerRetNo(RetNo);
  TransfereeRetNo := GetTransfereeRetNo(RetNo);

  (* CON //20160810
    //20160810 Igor >>>
    if (PensionerRetNo = 0) or (TransfereeRetNo = 0) then
    Begin
    ShowMessage('Insufficient input data for optimization. Please fill data in the form T1032');
    Result := 0;
    //  exit;
    End;
    //20160810 Igor <<<
  *)
  { see above
    Screen.Cursor:=crHourGlass;
    OptimizeBtnClicked:=True;
    OptimizeFNo:=GetFormNo('OPTIMIZE');
    T1032FNo:=GetFormNo('T1032');
    PensionerRetNo:=GetPensionerRetNo(RetNo);
    TransfereeRetNo:=GetTransfereeRetNo(RetNo);
  }
  If FetchElmFNo(RetNo, OptimizeFNo, 17) = 'Y' then
    OptimizeCreditsSw := true
  else
    OptimizeCreditsSw := false;

  SpRetNo := GetSpRetNo(RetNo);
  If FetchElmFNo(RetNo, OptimizeFNo, 13) > '' then
  begin
    StoreElm(PensionerRetNo, T1032FNo, 32, FetchElmFNo(RetNo, OptimizeFNo, 24));
    StoreElm(TransfereeRetNo, T1032FNo, 32,
      FetchElmFNo(RetNo, OptimizeFNo, 24));
  end
  else
  begin
    StoreElm(PensionerRetNo, T1032FNo, 32, FetchElmFNo(RetNo, OptimizeFNo, 35));
    StoreElm(TransfereeRetNo, T1032FNo, 32,
      FetchElmFNo(RetNo, OptimizeFNo, 35));
  end;

  Calc(RetNo, 'T1032');
  Calc(SpRetNo, 'T1032');
  CalcAll(RetNo); // to start off without split
  // Calc(RetNo,'OPTIMIZE');

  BeforeSplitFamilyTotal := ExtractFamilyTotal(RetNo, SpRetNo);
  StoreElm(RetNo, OptimizeFNo, 22, FormatFloat('#########.##',
    BeforeSplitFamilyTotal));
  LowestTotal := BeforeSplitFamilyTotal;

  // remove pension split percentages
  StoreElm(RetNo, OptimizeFNo, 24, '');
  StoreElm(RetNo, OptimizeFNo, 25, '');
  StoreElm(RetNo, OptimizeFNo, 28, '');
  StoreElm(RetNo, OptimizeFNo, 29, '');
  StoreElm(RetNo, OptimizeFNo, 38, '');
  StoreElm(RetNo, OptimizeFNo, 39, '');
  PercentElm := 24; // default
  LowestTotal := 10000000; // high enough to start with as rtn looks for lower

  // increment percent split from current spouse and capture the lowast fam payable
  // PensionPercent =0 not used, as it is with no splitting

  IncrBy := 1; // 3;  //1% skipped second spouse
  // FIRST SPOUSE
  If (Ret[RetNo].CouplingSw = true) and
    (VL(FetchElmFNo(RetNo, OptimizeFNo, 19)) > 0) and
    (VL(FetchElmFNo(RetNo, OptimizeFNo, 20)) > VL(FetchElmFNo(RetNo,
    OptimizeFNo, 21))) // higher txbl
  then
  Begin
    PensionPercent := 1; // 1;
    Repeat
      StoreElm(RetNo, OptimizeFNo, 24, '');
      StoreElm(RetNo, OptimizeFNo, 35, '');
      StoreElm(RetNo, OptimizeFNo, 24, FormatFloat('###.##', PensionPercent));
      StoreElm(PensionerRetNo, T1032FNo, 32,
        FetchElmFNo(RetNo, OptimizeFNo, 24));
      StoreElm(TransfereeRetNo, T1032FNo, 32,
        FetchElmFNo(RetNo, OptimizeFNo, 24));

      CalcAllForOptimizeUpToTxbl(RetNo);

      RetToOptimize := RetNo;
      If OptimizeCreditsSw = true then
      begin
        InitOtherSplits(RetToOptimize, RetNo); // put 100 to rettooptimize
        OptimizeNonRefundableSplits(RetToOptimize, LowestTotal, RetNo);
        // puts optimum % on credits and OPTIMIZE form
      end;
      CalcAllForOptimizeAfterTxbl(RetNo);
      FamilyTotal := ExtractFamilyTotal(RetNo, SpRetNo);
      // SaveDebugInfo(RetNo,SpRetNo,'Test'+IntToStr(PensionPercent)+'.txt');
      If FamilyTotal <= LowestTotal then
      begin
        OptimumPensionPercent := PensionPercent;
        CopyOptimumSplitsToOptimize(RetNo);
        LowestTotal := FamilyTotal;
        PercentElm := 24;
      end;
      inc(PensionPercent, IncrBy);
    Until PensionPercent > 50; // 50;
  end;

  // OTHER SPOUSE
  If (Ret[RetNo].CouplingSw = true) and
    (VL(FetchElmFNo(RetNo, OptimizeFNo, 23)) > 0) // elig pension
    and (VL(FetchElmFNo(RetNo, OptimizeFNo, 21)) > VL(FetchElmFNo(RetNo,
    OptimizeFNo, 20))) // higher txbl
  then // PensionToSplit
  begin
    // increment percent split from other spouse and continue checking for lower fam payable
    PensionPercent := 1;
    Repeat
      StoreElm(RetNo, OptimizeFNo, 24, '');
      StoreElm(RetNo, OptimizeFNo, 35, '');
      StoreElm(RetNo, OptimizeFNo, 35, FormatFloat('###.##', PensionPercent));
      StoreElm(PensionerRetNo, T1032FNo, 32,
        FetchElmFNo(RetNo, OptimizeFNo, 35));

      CalcAllForOptimizeUpToTxbl(RetNo);

      RetToOptimize := RetNo;
      // Old: GetRetToOptimize(RetNo,SpRetNo);  //RetToOptimize:=GetHigherTxblSpouseRetNo(RetNo,SpRetNo);
      If OptimizeCreditsSw = true then
      begin
        InitOtherSplits(RetToOptimize, RetNo);
        OptimizeNonRefundableSplits(RetToOptimize, LowestTotal, RetNo);
      end;
      CalcAllForOptimizeAfterTxbl(RetNo);
      FamilyTotal := ExtractFamilyTotal(RetNo, SpRetNo);
      // SaveDebugInfo(RetNo,SpRetNo,'TestOther'+IntToStr(PensionPercent)+'.txt');
      If FamilyTotal <= LowestTotal then
      begin
        OptimumPensionPercent := PensionPercent;
        CopyOptimumSplitsToOptimize(RetNo);
        LowestTotal := FamilyTotal;
        PercentElm := 35;
      end;
      inc(PensionPercent, IncrBy);
    Until PensionPercent > 50;
  end;

  // NO PENSION SPLIT (only Other Splits) (if no pension, otherwize it has been done above
  If VL(FetchElmFNo(RetNo, OptimizeFNo, 24)) +
    VL(FetchElmFNo(RetNo, OptimizeFNo, 35)) = 0 then
  begin
    LowestTotal := 10000000;
    OptimumPensionPercent := 0;
    RetToOptimize := RetNo;
    If OptimizeCreditsSw = true then
    begin
      // elm 17 has the include and 22 has the bfr optimization
      For i := 1 to 16 do
      begin
        StoreElm(RetToOptimize, OptimizeFNo, i, '');
      end;
      For i := 23 to 63 do
      begin
        StoreElm(RetToOptimize, OptimizeFNo, i, '');
      end;
      Calc(RetToOptimize, 'OPTIMIZE');
      CopyOptimumSplitsToSchedules(RetToOptimize);
      If OptimizeCreditsSw = true then
      begin
        OptimizeNonRefundableSplits(RetToOptimize, LowestTotal, RetNo);
        // copies % to credit forms
        CopyOptimumSplitsToOptimize(RetNo); // from credit forms
      end;
    end;
    CalcAll(RetToOptimize);
    FamilyTotal := ExtractFamilyTotal(RetNo, SpRetNo);
    LowestTotal := FamilyTotal;
  end;

  // AFTER ALL DONE
  If PercentElm = 24 then
  begin
    StoreElm(RetNo, OptimizeFNo, 24, FormatFloat('###.##',
      OptimumPensionPercent));
    StoreElm(PensionerRetNo, T1032FNo, 32, FormatFloat('###.00',
      OptimumPensionPercent));
    StoreElm(TransfereeRetNo, T1032FNo, 32,
      FormatFloat('###.00', OptimumPensionPercent));
    StoreElm(RetNo, OptimizeFNo, 35, '');
    StoreElm(SpRetNo, OptimizeFNo, 35, FormatFloat('###.##',
      OptimumPensionPercent));
    StoreElm(SpRetNo, OptimizeFNo, 24, '');
  end
  Else
  begin
    StoreElm(RetNo, OptimizeFNo, 35, FormatFloat('###.##',
      OptimumPensionPercent));
    StoreElm(RetNo, OptimizeFNo, 24, FormatFloat('###.##',
      100 - OptimumPensionPercent));
    StoreElm(PensionerRetNo, T1032FNo, 32, FormatFloat('###.00',
      100 - OptimumPensionPercent));
    StoreElm(TransfereeRetNo, T1032FNo, 32,
      FormatFloat('###.00', 100 - OptimumPensionPercent));
    StoreElm(SpRetNo, OptimizeFNo, 24, FormatFloat('###.##',
      OptimumPensionPercent));
    StoreElm(SpRetNo, OptimizeFNo, 35, FormatFloat('###.##',
      100 - OptimumPensionPercent));
  end;

  // SaveDebugInfo(RetNo,SpRetNo,'Test1.txt');

  // SaveDebugInfo(RetNo,SpRetNo,'Test2.txt');
  CalcAll(RetNo); // changes the familytotal?
  FamilyTotal := ExtractFamilyTotal(RetNo, SpRetNo);
  // If FamilyTotal<=LowestTotal then LowestTotal:=FamilyTotal; //wrong
  LowestTotal := FamilyTotal; // OK?

  If LowestTotal = 10000000 then
    LowestTotal := BeforeSplitFamilyTotal;

  StoreElm(RetNo, OptimizeFNo, 25, FormatFloat('#########.##', LowestTotal));
  StoreElm(RetNo, OptimizeFNo, 26, FormatFloat('#########.##',
    BeforeSplitFamilyTotal - LowestTotal));
  Screen.Cursor := crDefault;

  Result := OptimumPensionPercent;
  OptimizeBtnClicked := false;

  If Ret[RetNo].Province = 'ON' then
  begin
    If (VL(FetchElm(RetNo, 'ON428', 112)) > VL(FetchElm(RetNo, 'ON428', 152)))
      and (AnySplittableCredits(RetNo, OptimizeFNo) = true) then
      ShowMessage
        ('Due to Ont tax reduction (ON428), there may still be room for furher optimization'
        + Chr(13) +
        'If you have any non-refundable credits try reducing the splits and look at Family Refund or Owing at bottom line');
  end;

  If Ret[RetNo].Province = 'MB' then
  begin
    If (Ret[RetNo].Lnn[46000] <= 0) and
      (AnySplittableCredits(RetNo, OptimizeFNo) = true) then
      ShowMessage('There may still be room for adjustments' + Chr(13) +
        'If you have any non-refundable credits try changing them and look at Family Refund or Owing at bottom line');
  end;
end;

Function GetPensionerSinNo(RetNo: integer): String;
begin
  Result := '';
  If FetchElm(RetNo, 'T1032', 42) > '' then
    Result := FetchElm(RetNo, 'T1032', 44)
  else If FetchElm(RetNo, 'T1032', 45) > '' then
    Result := FetchElm(RetNo, 'T1032', 47);
end;

Function GetPensionerRetNo(RetNo: integer): integer;
begin
  Result := 0;
  If FetchElm(RetNo, 'T1032', 42) > '' then
    Result := GetRetNoFromSin(FetchElm(RetNo, 'T1032', 44))
  else If FetchElm(RetNo, 'T1032', 45) > '' then
    Result := GetRetNoFromSin(FetchElm(RetNo, 'T1032', 47));
end;

Function GetTransfereeRetNo(RetNo: integer): integer;
begin
  Result := 0;
  If FetchElm(RetNo, 'T1032', 42) = '' then
    Result := GetRetNoFromSin(FetchElm(RetNo, 'T1032', 44))
  else If FetchElm(RetNo, 'T1032', 45) = '' then
    Result := GetRetNoFromSin(FetchElm(RetNo, 'T1032', 47));
end;

Function GetLine371ForEfile(RetNo: integer): Real;
Var
  CppProrate: Real;
  CppMonths: integer;
begin
  Result := 0;

  If Rc381InEffect(RetNo) then
    Result := VL(FetchElm(RetNo, 'RC381', 77)) // 20131217
  Else
    Result := VL(FetchElm(RetNo, 'S8Q', 1));

  // 20140109
  If (HasBusiness(RetNo)) and (GetPlacementOfficeIncome(RetNo) > 0) then
  Begin
    If (VL(FetchElm(RetNo, 'RC381', 46)) = 0) and
      (VL(FetchElm(RetNo, 'RC381', 77)) = 0) then
      Result := 1;
  end;
end;

Function GetSelfEmplForWib(RetNo: integer): Real;
Var
  i: integer;
  x: Real;
begin
  Result := 0;

  If Ret[RetNo].FormHasData['T1139#1'] then
  begin
    x := MaxR(0, Ret[RetNo].Lnn[13500]) + MaxR(0, Ret[RetNo].Lnn[13700]) +
      MaxR(0, Ret[RetNo].Lnn[13900]) + MaxR(0, Ret[RetNo].Lnn[14100]) +
      MaxR(0, Ret[RetNo].Lnn[14300]);
    Result := x;
    Exit;
  end;

  x := 0;
  for i := 0 to (FList.Count - 1) do // only positive income
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'T2125' then // 20101220
      x := x + MaxR(0, VL(FetchElmFNo(RetNo, FRec.FormNo, 106)))
    Else if FRec.FormName = 'T2121' then
      x := x + MaxR(0, VL(FetchElmFNo(RetNo, FRec.FormNo, 74)))
    Else if FRec.FormName = 'T2042' then
      x := x + MaxR(0, VL(FetchElmFNo(RetNo, FRec.FormNo, 148)))
    Else if FRec.FormName = 'T1163' then
      x := x + MaxR(0, VL(FetchElmFNo(RetNo, FRec.FormNo, 616)))
    Else if FRec.FormName = 'T1273' then
      x := x + MaxR(0, VL(FetchElmFNo(RetNo, FRec.FormNo, 616)));
    Result := x;
  end; { loop thru forms }
end;

Function GetSelfEmplLosses(RetNo: integer): Real;
Var
  i: integer;
  x: Real;
begin
  Result := 0;

  If Ret[RetNo].FormHasData['T1139#1'] then
  begin
    x := MinR(0, Ret[RetNo].Lnn[13500]) + MinR(0, Ret[RetNo].Lnn[13700]) +
      MinR(0, Ret[RetNo].Lnn[13900]) + MinR(0, Ret[RetNo].Lnn[14100]) +
      MinR(0, Ret[RetNo].Lnn[14300]);
    Result := x;
    Exit;
  end;

  x := 0;
  for i := 0 to (FList.Count - 1) do // only positive income
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'T2125' then // 20101220
      x := x + MinR(0, VL(FetchElmFNo(RetNo, FRec.FormNo, 106)))
    Else if FRec.FormName = 'T2121' then
      x := x + MinR(0, VL(FetchElmFNo(RetNo, FRec.FormNo, 74)))
    Else if FRec.FormName = 'T2042' then
      x := x + MinR(0, VL(FetchElmFNo(RetNo, FRec.FormNo, 148)))
    Else if FRec.FormName = 'T1163' then
      x := x + MinR(0, VL(FetchElmFNo(RetNo, FRec.FormNo, 616)))
    Else if FRec.FormName = 'T1273' then
      x := x + MinR(0, VL(FetchElmFNo(RetNo, FRec.FormNo, 616)));
    Result := x;
  end; { loop thru forms }
end;

Function InitialWITBEligibility(RetNo: integer): Boolean; // 20190127
begin
  Result := true;

  if FetchElmFNo(RetNo, InfoFNo, 26) + FetchElmFNo(RetNo, InfoFNo, 28) > '' then
  begin
    Result := false;
    Exit;
  end; // entry / departure
  If (IsDeceased(RetNo)) and (FetchElmFNo(RetNo, InfoFNo, 24) < AppYear +
    '-06-01') then
  begin
    Result := false;
    Exit;
  end;
  If Ret[RetNo].Province = 'ZZ' then
  begin
    Result := false;
    Exit;
  end;
  If Ret[RetNo].Lnn[10100] + Ret[RetNo].Lnn[10400] + GetSelfEmplForWib(RetNo) +
    TotMultiple(RetNo, 'T4', 11) = 0 then
  begin
    Result := false;
    Exit;
  end;
  If FetchElmFNo(RetNo, InfoFNo, 26) + FetchElmFNo(RetNo, InfoFNo, 28) > '' then
  begin
    Result := false;
    Exit;
  end; // immigrant-emigrant
  If IsPreBankruptcyReturn(RetNo) then
  begin
    Result := false;
    Exit;
  End;
  // If FetchElmFNo(RetNo,InfoFNo,166)>'' then begin result:=False;Exit;end;exit; // 90 or more days in prison

  (*
    if Ret[RetNo].Province<>'QC' then
    Begin
    If Ret[RetNo].Age <19 then
    begin
    If (HasEligibleDependantForWIB(RetNo))=False   //no elig elig dep
    and (FetchElm(RetNo,'S6',83)='')  //no elig elig dep claimed via S6
    and (Ret[RetNo].MarStatus>2)          //not married
    then exit;
    end;
    //student with no eligible dependant
    If (HasEligibleDependantForWIB(RetNo)=False) //no elig dependant
    and (FetchElm(RetNo,'S6',83)='')  //no elig elig dep claimed via S6
    and (Vl(FetchElm(RetNo,'T2202',67))>3) then exit;  //more than 3 months //20180302
    //and (Vl(FetchElm(RetNo,'S11',12))>3) then exit;  //more than 3 months //20180302
    end
    Else
    Begin //QC
    If Ret[RetNo].Age <19 then
    begin
    If (HasEligibleDependantForWIB(RetNo))=False   //no elig elig dep
    and (FetchElm(RetNo,'S6QC',83)='')  //no elig elig dep claimed via S6
    and (Ret[RetNo].MarStatus>2)          //not married
    then exit;
    end;
    //student with no eligible dependant
    If (HasEligibleDependantForWIB(RetNo)=False) //no elig dependant
    and (FetchElm(RetNo,'S6QC',83)='')  //no elig elig dep claimed via S6
    and (Vl(FetchElm(RetNo,'T2202',67))>3) then exit;  //more than 3 months  //20180302
    // and (Vl(FetchElm(RetNo,'S11',12))>3) then exit;  //more than 3 months  //20180302
    End;

    If GetWorkingIncomeForWib(RetNo)<910 then exit; //lowest in ab
    {If IsDeceased(RetNo) then begin end;}

    Result:=True;
  *)
end;

Function EligibleForWIBPerCRA(RetNo: integer): Boolean; // 2019022
Var
  Fnm: String;
begin
  Result := true;
  // 20190128
  if (FetchElmFNo(RetNo, InfoFNo, 145) > '') Or
    (FetchElmFNo(RetNo, InfoFNo, 147) > '') Or
    (FetchElmFNo(RetNo, InfoFNo, 149) > '') or
    (FetchElmFNo(RetNo, InfoFNo, 151) > '') then // 20200420 by spouse
    Result := false;
end;

Function EligibleForWIB(RetNo: integer): Boolean;
Var
  Fnm: String;
begin
  Result := true; // false;   //20190407
  Fnm := 'S6';
  if (IsDeemedResident(RetNo))  or    //jz//NonResCERT-R3//20240416 - add deemed as eligible
  (IsDeemedRes183(RetNo))       or
  (IsDeemedResOther(RetNo))
  then
    //is ok
  else if (Ret[RetNo].Province = 'QC') or (isDeemedResQuebec(RetNo)) then //jz//NonResCERT-R3//20240416 - add isDeemedResQuebec, make seperate ifs --> if else with prov = ZZ
    Fnm := 'S6QC'
  else if Ret[RetNo].Province = 'ZZ' then
  begin
    Result := false;
    Exit;
  end;

  if IsPreBankruptcyReturn(RetNo) then
  begin
    Result := false;
    Exit;
  end;

  //jz//20260202 -  order of openning form calc in such a way that doesn't populate 10100 causeing save errors
  //             -  may be an issue also with 10400 and ohters, need to rework form calc order in major way / more precise / blocks that make sense
  Ret[RetNo].Lnn[10100] := calcLnn10100(RetNo);

  xx := Ret[RetNo].Lnn[10100];
  xx := Ret[RetNo].Lnn[10400];
  xx := GetSelfEmplForWib(RetNo);
  xx := TotMultiple(RetNo, 'T4', 11);

  If Ret[RetNo].Lnn[10100] + Ret[RetNo].Lnn[10400] + GetSelfEmplForWib(RetNo) +
    TotMultiple(RetNo, 'T4', 11) = 0 then
  begin
    Result := false;
    Exit;
  End; // + st ind non txbl
  If FetchElmFNo(RetNo, InfoFNo, 25) + FetchElmFNo(RetNo, InfoFNo, 26) +
    FetchElmFNo(RetNo, InfoFNo, 27) + FetchElmFNo(RetNo, InfoFNo, 28) > '' then
  begin
    Result := false;
    Exit;
  End; // immigrant-emigrant

  If FetchElmFNo(RetNo, InfoFNo, 166) > '' then
  begin
    Result := false;
    Exit;
  End; // 90 or more days in prison

  If (IsDeceased(RetNo)) and (FetchElm(RetNo, 'INFO', 24) <= AppYear + '-06-01')
  then
  begin
    Result := false;
    Exit;
  End; // 20190128

  If Ret[RetNo].Age < 19 then
  begin
    If (HasEligibleDependantForWIB(RetNo)) = false // no elig elig dep
      and (FetchElm(RetNo, Fnm, 83) = '') // no elig elig dep claimed via S6
      and (Ret[RetNo].MarStatus > 2) // not married
    then
    begin
      Result := false;
      Exit;
    End;
  end;

  (* 20190503
    // student with no eligible dependant
    If (HasEligibleDependantForWIB(RetNo) = false) // no elig dependant
    and (FetchElm(RetNo, Fnm, 83) = '') // no elig elig dep claimed via S6
    and (VL(FetchElm(RetNo, 'T2202', 67)) > 3) then
    exit; // more than 3 months //20180302
  *)
  // 20190503
  If (VL(FetchElm(RetNo, 'T2202', 67)) > 3) then // full time 13 week
  Begin
    If (HasEligibleDependantForWIB(RetNo) = true) // elig dependant
      Or (FetchElm(RetNo, Fnm, 83) > '') // elig dep claimed via S6
    // Or (FetchElm(RetNo, Fnm, 83) = '') // elig dep claimed via S6
    then
      // ok  result:=True
    Else
    Begin
      Result := false;
      Exit;
    End;
  end; // 20190503

  Result := true;
end;

Function GetWorkingIncomeForWib(RetNo: integer): Real;
begin
  Result := Ret[RetNo].Lnn[10100] + Ret[RetNo].Lnn[10400] +
    TotMultiple(RetNo, 'T4A', 47) // scholarsip
    + GetSelfEmplForWib(RetNo) + TotMultiple(RetNo, 'T4', 11) +
    TotMultiple(RetNo, 'T4', 47); // st indian/volunteer
end;

Function IsAuthorizedPreparer: Boolean; // 20190311 Igor //20220512 Igor
var
  i: integer;
  S: String;
  url, localDir, remoteFlName, localFlName, ExpKeysFlName, LicenseKey,
    TempStr: String;
  TempList: TStringList;
  EfilerNo: String;
  PreparerStreet: String;
begin
  // Result:=True; // 20190314
  // Exit;  //20220505
  // -----------------------------------------
  Result := true;
  if not IsInternetConnectionActive then
    Exit;
  Screen.Cursor := crHourGlass;
  try
    url := 'www.visualtax.com/downloads/';
    localDir := AppDir + '\'; // where the dowloaded files are saved
    remoteFlName := 'ExpKeysT1.txt';
    ExpKeysFlName := 'ExpKeysT1.txt'; // expired tr keys

    try
      TempList := TStringList.Create;
      try
        if DownLoadFromWeb(url, remoteFlName, localDir, ExpKeysFlName) then
        begin
          LicenseKey := AppT1_2026.GetLicenseKey;
          If FileExists(AppDir + '\' + ExpKeysFlName) then
          begin
            TempList.LoadFromFile(AppDir + '\' + ExpKeysFlName);
            // for i:=0 to TempList.Count-1 do ShowMessage(Templist[i]);  //20190406
            If TempList.Count > 0 then // 20190401
            Begin
              if LeftStr(UpperCase(TempList[0]), 7) = 'MON-OFF' then
              Begin
                Result := true;
                Exit;
              end; // no monitoring meaning everybody is authorized otherwise continue
            End;

            For i := 0 to TempList.Count - 1 do
            begin
              TempStr := AllTrim(TempList[i]); // 20190311
              If SameText(LicenseKey, Copy(TempStr, 1, 19)) or
                SameText(OptRec.Prp_Name, AllTrim(TempList[i])) then // 20190311
              begin
                ShowMessage
                  ('VT Program Authorization Failure. Contact VisualTax by Email only');
                Result := false;
                Break;
              end;
              // check Efiler no
              GetEOLParms(EfilerNo, S, S, S);
              If EfilerNo > '' then
              begin
                If UpperCase(EfilerNo) = UpperCase(LeftStr(TempStr, 5)) then
                begin
                  ShowMessage
                    ('VT Program Authorization Failure. Contact VisualTax by Email only');
                  // 20180824 CON instead of Authorization Failure  //20181119
                  Result := false;
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
                  Result := false;
                  Break;
                end;
              end;

            end;
          end;
        end;
      finally
        If FileExists(AppDir + '\' + ExpKeysFlName) then
          DeleteFile(PChar(AppDir + '\' + ExpKeysFlName));
        TempList.Free;
      end
    except // do not show errors
    end
  finally
    Screen.Cursor := crDefault;
  end;
end;

Function DownLoadFromWeb(url, remoteFlName, localDir, localFlName: string)
// 20220411 Igor
  : Boolean; // 20190311 Igor
var
  fileUrl, FileName: string;
begin
  Result := true;
  fileUrl := url + remoteFlName;
  FileName := localDir + localFlName;
  if not(SameText(Copy(fileUrl, 1, 7), 'http://') or
    SameText(Copy(fileUrl, 1, 8), 'https://')) then
    fileUrl := 'https://' + fileUrl;
  GetFileWithNoCache(fileUrl, FileName);
end;

(*
  Function DownLoadFromWeb(url, remoteFlName, localDir, localFlName: string)
  : Boolean; // 20190311 Igor
  const
  BufferSize = 1024;
  var
  hSession, hURL: HInternet;
  Buffer: array [1 .. BufferSize] of Byte;
  BufferLen: DWORD;
  F: File;
  sAppName: string;
  fileURL, FileName: String;
  begin
  try
  fileURL := url + remoteFlName;

  if Pos('?', fileURL) = 0 then
  fileURL := fileURL + '?readtime=' + FormatDateTime('yyyymmddhhnnss', Now);
  // avoid cached file
  if not(SameText(Copy(fileURL, 1, 7), 'http://') or
  SameText(Copy(fileURL, 1, 8), 'https://')) then
  fileURL := 'http://' + fileURL; // avoid error with h_url

  FileName := localDir + localFlName;
  Result := false;
  sAppName := ExtractFileName(Application.ExeName);

  hSession := InternetOpen(Pchar('' + sAppName), INTERNET_OPEN_TYPE_PRECONFIG,
  nil, nil, 0);
  If hSession = Nil then
  exit; // does not work
  try
  Result := false;
  hURL := InternetOpenURL(hSession, Pchar(fileURL), nil, 0, 0, 0);
  If hURL = Nil then
  begin
  ShowMessage('hUrl may have failed. Ignore');
  exit;
  End; // does not work
  try
  AssignFile(F, FileName);
  ReWrite(F, 1);
  repeat
  InternetReadFile(hURL, @Buffer, Sizeof(Buffer), BufferLen);
  Screen.Cursor := crHourGlass;
  BlockWrite(F, Buffer, BufferLen);
  // ProgressBar1.Position:=ProgressBar1.Position+1000;
  until BufferLen = 0;
  CloseFile(F);
  Result := True;
  finally
  InternetCloseHandle(hURL)
  end
  finally
  InternetCloseHandle(hSession)
  end;
  finally
  Screen.Cursor := crDefault;
  end;
  end;
*)

(*
  Function DownLoadFromWeb(url,remoteFlName,localDir,localFlName:string): boolean; //20190311 Igor
  const BufferSize = 1024;
  var
  hSession, hURL: HInternet;
  Buffer: array[1..BufferSize] of Byte;
  BufferLen: DWORD;
  f: File;
  sAppName: string;
  fileURL, FileName: String;
  begin
  try
  fileURL := url + remoteFlName;

  if Pos('?', fileUrl) = 0 then
  fileUrl := fileUrl + '?readtime='+FormatDateTime('yyyymmddhhnnss',now); // avoid cached file
  if not (SameText(Copy(fileUrl, 1, 7), 'http://') or SameText(Copy(fileUrl, 1, 8), 'https://')) then
  fileUrl := 'http://'+ fileUrl; // avoid error with h_url

  FileName := localDir + localFlName;
  Result:=False;
  sAppName := ExtractFileName(Application.ExeName);

  hSession := InternetOpen(PChar(''+sAppName),INTERNET_OPEN_TYPE_PRECONFIG,nil, nil, 0);
  If hSession=Nil then exit; //does not work
  try
  result:=false;
  hURL := InternetOpenURL(hSession,PChar(fileURL),nil,0,0,0);
  If hUrl=Nil then begin ShowMessage('hUrl may have failed. Ignore'); exit; End; //does not work
  try
  AssignFile(f, FileName);
  Rewrite(f,1);
  repeat
  InternetReadFile(hURL, @Buffer,SizeOf(Buffer), BufferLen);
  Screen.Cursor:=crHourGlass;
  BlockWrite(f, Buffer, BufferLen);
  //ProgressBar1.Position:=ProgressBar1.Position+1000;
  until BufferLen = 0;
  CloseFile(f);
  Result:=True;
  finally
  InternetCloseHandle(hURL)
  end
  finally
  InternetCloseHandle(hSession)
  end;
  finally
  Screen.Cursor:=crDefault;
  end;
  end;
*)
Function GetAutoCCAClaimed(RetNo: integer; Stmt: String; FInst: String): Real;
Var
  i: integer;
  TermLossAmount, RecaptAmount: Real;
  AutoCCAForStmt: Real;
Begin
  ExtractAutos(RetNo, Stmt, FInst, TermLossAmount, RecaptAmount,
    AutoCCAForStmt);
  Result := 0;
  For i := 0 to ExtractedAutoList.Count - 1 do
  begin
    ExtractedAutoRec := ExtractedAutoList.Items[i];
    If ExtractedAutoRec.PartnerFlag = '' then
      Result := Result + ExtractedAutoRec.CCAClaimed;
  end;
end;

//jz//20260202
Function HasEligibleSpouseForWIB(RetNo: integer): Boolean;
begin
    result:=false;
    //married or commonlaw
    If      ret[RetNo].MarStatus < 3 then
    begin
      result:=true;
    end
    //widowed but in the year after June 30 (also you not cohabitating with someone else as of year end Dec 31.. how to check that??)
    else if (ret[RetNo].MarStatus = 3) and (FetchElmFNo(RetNo,InfoFNo,65)>=appyear+'-06-30') then
    begin
      result:=true;
    end;
end;


Function HasEligibleDependantForWIB(RetNo: integer): Boolean;
Var
  i: integer;
  DepFNo: integer;
begin
  DepFNo := GetFormNo('DEPEND');
  Result := false;
  i := 5;
  Repeat
   If ((UpperCase(FetchElmFNo(RetNo, DepFNo, i + 6)) = 'CHILD') or
        (UpperCase(FetchElmFNo(RetNo, DepFNo, i + 6)) = 'SON') or
        (UpperCase(FetchElmFNo(RetNo, DepFNo, i + 6)) = 'DAUGHTER')) and
        (CalcAge(FetchElmFNo(RetNo, DepFNo, i + 5)) < 19) then
   begin
        Result := true;
        Exit;
   end;
   inc(i, 15);
  until i > 125;
end;
  

  //20260412
  {
  if Ret[RetNo].Province <> 'QC' then
  Begin
    If (VL(FetchElmFNo(RetNo, DepFNo, 3)) = 0) // no elig elig dep
      and (FetchElm(RetNo, 'S6', 83) = '') then
      Exit;
  End
  Else // qc
  Begin
    If (VL(FetchElmFNo(RetNo, DepFNo, 3)) = 0) // no elig elig dep
      and (FetchElm(RetNo, 'S6QC', 83) = '') then
      Exit;
  End;

  i := 5;
  Repeat
    If UpperCase(FetchElmFNo(RetNo, DepFNo, i + 14)) = 'Y' then // elig claimed
    begin
      If ((UpperCase(FetchElmFNo(RetNo, DepFNo, i + 6)) = 'CHILD') or
        (UpperCase(FetchElmFNo(RetNo, DepFNo, i + 6)) = 'SON') or
        (UpperCase(FetchElmFNo(RetNo, DepFNo, i + 6)) = 'DAUGHTER')) and
        (CalcAge(FetchElmFNo(RetNo, DepFNo, i + 5)) < 19) then
      begin
        Result := true;
        Exit;
      end;
    end;
    inc(i, 15);
  until i > 125;
end;
}

Function HasEligibleDependant(RetNo: integer): Boolean;
Var
  i: integer;
  DepFNo: integer;
begin
  Result := false;
  DepFNo := GetFormNo('DEPEND');
  If (VL(FetchElmFNo(RetNo, DepFNo, 3)) > 0) // no elig elig dep
  then
    Result := true;
end;

Procedure CaptureLastYearCCA(RetNo: integer);
Var
  i, FNo, RowNdx: integer;
Begin
  // prepare CCA screen from statements
  FNo := GetFormNo('CCALIST');
  For i := 1 to 171 do
  begin
    StoreElm(RetNo, FNo, i, '');
  end; // init
  RowNdx := 1;
  // Other
  ExtractCCAList(RetNo, RowNdx, 'T776', 201, 237, 9);
  ExtractCCAList(RetNo, RowNdx, 'T2125', 301, 371, 10); // 20110313
  // ExtractCCAList(RetNo,RowNdx,'T2125',501,571,10);
  ExtractCCAList(RetNo, RowNdx, 'T2121', 137, 207, 10);
  ExtractCCAList(RetNo, RowNdx, 'T2042', 401, 471, 10);
  ExtractCCAList(RetNo, RowNdx, 'T1175', 1, 71, 10);
  ExtractCCAList(RetNo, RowNdx, 'T1175H', 1, 71, 10);
End;

Procedure PopulateAssets(RetNo: integer); // from ccalist
Var
  i, j, k, CCAListFNo, AssetFNo: integer;
  Cls: String;
  UCC: Real;
  AssetFName, Stmt: String;
begin
  // 20090128
  For i := 1 to 15 do
  begin
    AssetFNo := GetFormNo('ASSETSB#' + AllTrim(IntToStr(i)));
    If AssetFNo > 0 then
      InitFormData(RetNo, AssetFNo);
  end;

  Calc(RetNo, 'CCALIST');
  CCAListFNo := GetFormNo('CCALIST');
  j := 1; // index to assetFNo instance
  i := 1; // index to elm of CCAlist
  Repeat
    Cls := FetchElmFNo(RetNo, CCAListFNo, i);
    UCC := VL(FetchElmFNo(RetNo, CCAListFNo, i + 1));
    Stmt := FetchElmFNo(RetNo, CCAListFNo, i + 2);
    If (Cls > '') and (Cls <> '0') then
    begin
      AssetFName := 'ASSETSB' + '#' + IntToStr(j);
      begin
        AssetFNo := AddPageInstance(RetNo, 'ASSETSB', '#' + IntToStr(j));
        // AssetFName:='ASSETSB#'+IntTostr(j);
        // AssetFNo := GetFormNo(AssetFName); {get it again}
        InitFormData(RetNo, AssetFNo);
      end;
      For k := 1 to 230 do
        StoreElm(RetNo, AssetFNo, k, '');
      StoreElm(RetNo, AssetFNo, 10, 'Y');
      StoreElm(RetNo, AssetFNo, 1, 'Asset #' + IntToStr(j)); // descr

      If LeftStr(Stmt, 6) = 'T1175#' then // 20110109  6 instead of 5
        StoreElm(RetNo, AssetFNo, 215, 'T1163' + ExtractFormInst(Stmt))
      else If LeftStr(Stmt, 7) = 'T1175H#' then
        StoreElm(RetNo, AssetFNo, 215, 'T1273' + ExtractFormInst(Stmt))
      else
        StoreElm(RetNo, AssetFNo, 215, ExtractFormRootName(Stmt) +
          ExtractFormInst(Stmt));

      StoreElm(RetNo, AssetFNo, 216, '100');
      StoreElm(RetNo, AssetFNo, 134, Cls);
      StoreElm(RetNo, AssetFNo, 137, '2006-01-01'); // purch dt
      StoreElm(RetNo, AssetFNo, 191, FormatFloat('########.##', UCC));
      Calc(RetNo, AssetFName);
      Ret[RetNo].FrmHasData[AssetFNo] := true; // 20170324 Igor
      j := j + 1;
    end;
    i := i + 3;
  until i > 169;
end;

procedure OpenMsWord;
var
  wrdApp, wrdDoc: Variant;
  StrToAdd: String;
  wrdSelection: Variant;
begin
  // Create an instance of Word and make it visible
  wrdApp := CreateOLEObject('Word.Application');
  wrdApp.Visible := true;
  // Create a new document
  wrdDoc := wrdApp.Documents.Add();
  wrdDoc.Select;
  wrdSelection := wrdApp.Selection;
  wrdSelection.TypeText(' ');
end;

function CreateShortCutDialog(Directory: string): Boolean;
var
  reg: TRegistry;
  cmd: string;
begin
  Result := false;
  reg := TRegistry.Create;
  try
    reg.Rootkey := HKEY_CLASSES_ROOT;
    if reg.OpenKeyReadOnly('.LNK\ShellNew') then
    begin
      cmd := reg.ReadString('Command');
      cmd := StringReplace(cmd, '%1', Directory, []);
      Result := true;
      WinExec(PAnsiChar(cmd + ''), SW_SHOWNORMAL);
      // typecast error unless adding cmd+''
    end
  finally
    reg.Free;
  end;
end;

function CreateShortcut(SourceFileName: string;
  // the file the shortcut points to
  Location: ShortcutType; // shortcut location
  SubFolder, // subfolder of location
  WorkingDir, // working directory property of the shortcut
  Parameters, Description: string): // description property of the shortcut
  string;

const
  SHELL_FOLDERS_ROOT = 'Software\MicroSoft\Windows\CurrentVersion\Explorer';
  QUICK_LAUNCH_ROOT = 'Software\MicroSoft\Windows\CurrentVersion\GrpConv';
var
  MyObject: IUnknown;
  MySLink: IShellLink;
  MyPFile: IPersistFile;
  Directory, LinkName: string;
  WFileName: WideString;
  reg: TRegIniFile;
begin
  MyObject := CreateComObject(CLSID_ShellLink);
  MySLink := MyObject as IShellLink;
  MyPFile := MyObject as IPersistFile;

  MySLink.SetPath(PChar(SourceFileName + ''));
  MySLink.SetArguments(PChar(Parameters + ''));
  MySLink.SetDescription(PChar(Description + ''));

  LinkName := ChangeFileExt(SourceFileName, '.lnk');
  LinkName := ExtractFileName(LinkName);

  // Quicklauch
  if Location = _QUICKLAUNCH then
  begin
    reg := TRegIniFile.Create(QUICK_LAUNCH_ROOT);
    try
      Directory := reg.ReadString('MapGroups', 'Quick Launch', '');
    finally
      reg.Free;
    end;
  end
  else
  // Other locations
  begin
    reg := TRegIniFile.Create(SHELL_FOLDERS_ROOT);
    try
      case Location of
        _OTHERFOLDER:
          Directory := SubFolder;
        _DESKTOP:
          Directory := reg.ReadString('Shell Folders', 'Desktop', '');
        _STARTMENU:
          Directory := reg.ReadString('Shell Folders', 'Start Menu', '');
        _SENDTO:
          Directory := reg.ReadString('Shell Folders', 'SendTo', '');
      end;
    finally
      reg.Free;
    end;
  end;

  if Directory <> '' then
  begin
    if (SubFolder <> '') and (Location <> _OTHERFOLDER) then
      WFileName := Directory + '\' + SubFolder + '\' + LinkName
    else
      WFileName := Directory + '\' + LinkName;

    if WorkingDir = '' then
      MySLink.SetWorkingDirectory(PChar(ExtractFilePath(SourceFileName + '')))
    else
      MySLink.SetWorkingDirectory(PChar(WorkingDir + ''));

    MyPFile.Save(PWChar(WFileName), false);
    Result := WFileName;
  end;
end;

Function GetTxblForPrvS11(RetNo: integer; PRV: String; LowBracket: Real;
  LowRate: Real): Real;
Var
  TaxOnIncome: Real;
begin
  Result := Ret[RetNo].Lnn[26000];
  TaxOnIncome := Ret[RetNo].Lnn[26000];
  If TaxOnIncome > PrvConstant[RY].PrvBracket1 then
  begin
    If PRV = 'AB' then
      TaxOnIncome := VL(FetchElm(RetNo, 'AB428', 13))
    else If PRV = 'BC' then
      TaxOnIncome := VL(FetchElm(RetNo, 'BC428', 132))
    else If PRV = 'MB' then
      TaxOnIncome := VL(FetchElm(RetNo, 'MB428', 101))
    else If PRV = 'NB' then
      TaxOnIncome := VL(FetchElm(RetNo, 'NB428', 101))
    else If PRV = 'NL' then
      TaxOnIncome := VL(FetchElm(RetNo, 'NL428', 101))
    else If PRV = 'NS' then
      TaxOnIncome := VL(FetchElm(RetNo, 'NS428', 130))
    else If PRV = 'NT' then
      TaxOnIncome := VL(FetchElm(RetNo, 'NT428', 101))
    else If PRV = 'NU' then
      TaxOnIncome := VL(FetchElm(RetNo, 'NU428', 101))
    else If PRV = 'ON' then
      TaxOnIncome := VL(FetchElm(RetNo, 'ON428', 101))
    else If PRV = 'PE' then
      TaxOnIncome := VL(FetchElm(RetNo, 'PE428', 101))
    else If PRV = 'SK' then
      TaxOnIncome := VL(FetchElm(RetNo, 'SK428', 101))
    else If PRV = 'YT' then
      TaxOnIncome := VL(FetchElm(RetNo, 'YT428', 134));
    If LowRate > 0 then
      Result := TaxOnIncome / (LowRate / 100);
  end;
  if TosiInEffect(RetNo) then
    Result := Result + GetTosiPrvTaxableIncome(RetNo); // 20181221

end;

Function GetRevisedAssetbLink(OldStmt: String; ConvList: TStringList): String;
Var
  i: integer;
begin
  For i := 0 to ConvList.Count - 1 do
  begin
    If OldStmt = AllTrim(LeftStr(ConvList[i], 10)) then
    begin
      Result := AllTrim(MidStr(ConvList[i], 11, 10));
      Exit;
    end;
  end;
  Result := OldStmt; // 20090224  //if not on the list
end;

Function CountMedicalEntriesForInvoice(RetNo: integer): integer;
Var
  i, j, k, FNo: integer;
  FName: String;
begin
  k := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    FName := FRec.FormName;
    FNo := FRec.FormNo;
    If (UpperCase(FName) = 'MEDICAL') and
      (Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)]) then
    begin
      j := 137;
      Repeat
        If VL(FetchElmFNo(RetNo, FNo, j)) > 0 then
          k := k + 1;
        inc(j, 1);
      until j > 157;
    end;

    If (UpperCase(FName) = 'MEDSUPL') and
      (Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)]) then
    begin
      j := 110;
      Repeat
        If VL(FetchElmFNo(RetNo, FNo, j)) > 0 then
          k := k + 1;
        inc(j, 1);
      until j > 130;
    end;
  end;
  Result := k;
end;

Function CountRRSPEntriesForInvoice(RetNo: integer): integer;
Var
  i, j, k, FNo: integer;
  FName: String;
begin
  k := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    FNo := FRec.FormNo;
    FName := FRec.FormName;
    If (UpperCase(FName) = 'RRSP') and
      (Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)]) then
    begin
      // left list
      If FetchElmFNo(RetNo, FNo, 9) > '' then
        k := k + 1;
      j := 20;
      Repeat
        If FetchElmFNo(RetNo, FNo, j) > '' then
          k := k + 1;
        inc(j, 4);
      until j > 36;

      j := 43;
      Repeat
        If FetchElmFNo(RetNo, FNo, j) > '' then
          k := k + 1;
        inc(j, 4);
      until j > 63;
    end;
  end;
  Result := k;
end;

Function CountDonationEntriesForInvoice(RetNo: integer): integer;
Var
  i, j, k, FNo: integer;
  FName: String;
begin
  k := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    FNo := FRec.FormNo;
    FName := FRec.FormName;
    If (UpperCase(FName) = 'DON') and
      (Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)]) then
    begin
      // left list
      If VL(FetchElmFNo(RetNo, FNo, 1)) > 0 then
        k := k + 1;
      If VL(FetchElmFNo(RetNo, FNo, 11)) > 0 then
        k := k + 1;
      j := 17;
      Repeat
        If VL(FetchElmFNo(RetNo, FNo, j)) > 0 then
          k := k + 1;
        inc(j, 6);
      until j > 83;
      // right hand list
      If VL(FetchElmFNo(RetNo, FNo, 4)) > 0 then
        k := k + 1;
      If VL(FetchElmFNo(RetNo, FNo, 9)) > 0 then
        k := k + 1;
      j := 14;
      Repeat
        If VL(FetchElmFNo(RetNo, FNo, j)) > 0 then
          k := k + 1;
        inc(j, 6);
      until j > 86;
    end;

    If (UpperCase(FName) = 'DONSUPL') and
      (Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)]) then
    begin
      j := 2;
      Repeat
        If VL(FetchElmFNo(RetNo, FNo, j)) > 0 then
          k := k + 1;
        inc(j, 3);
      until j > 173;
    end;
  end;
  Result := k;
end;

Function CountTuitionEntriesForInvoice(RetNo: integer): integer;
Var
  i, j, k, FNo: integer;
  FName: String;
begin
  k := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    FNo := FRec.FormNo;
    FName := FRec.FormName;
    If (UpperCase(FName) = 'T2202') and
      (Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)]) then
    begin
      j := 1;
      Repeat
        If FetchElmFNo(RetNo, FNo, j) > '' then
          k := k + 1;
        inc(j, 4);
      until j > 61;
    end;
  end;
  Result := k;
end;

Function CountDependantEntriesForInvoice(RetNo: integer): integer;
Var
  i, j, k, FNo: integer;
  FName: String;
begin
  k := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    FNo := FRec.FormNo;
    FName := FRec.FormName;
    If (UpperCase(FName) = 'DEPEND') and
      (Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)]) then
    begin
      j := 5;
      Repeat
        If FetchElmFNo(RetNo, FNo, j) > '' then
          k := k + 1;
        inc(j, 15);
      until j > 125;
    end;
  end;
  Result := k;
end;

Function CountDispositionEntriesForInvoice(RetNo: integer): integer;
Var
  i, j, k, FNo: integer;
  FName: String;
begin
  k := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    FNo := FRec.FormNo;
    FName := FRec.FormName;

    If (UpperCase(FName) = 'S3') and
      (Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)]) then
    begin
      // S3
      If VL(FetchElmFNo(RetNo, FNo, 101)) > 0 then
        k := k + 1;
      If VL(FetchElmFNo(RetNo, FNo, 144)) > 0 then
        k := k + 1;
      If VL(FetchElmFNo(RetNo, FNo, 117)) > 0 then
        k := k + 1;
      If VL(FetchElmFNo(RetNo, FNo, 4)) > 0 then
        k := k + 1;
      If VL(FetchElmFNo(RetNo, FNo, 11)) > 0 then
        k := k + 1;
      If VL(FetchElmFNo(RetNo, FNo, 22)) > 0 then
        k := k + 1;
      If VL(FetchElmFNo(RetNo, FNo, 28)) > 0 then
        k := k + 1;
      If VL(FetchElmFNo(RetNo, FNo, 43)) > 0 then
        k := k + 1;
      If VL(FetchElmFNo(RetNo, FNo, 53)) > 0 then
        k := k + 1;
      If VL(FetchElmFNo(RetNo, FNo, 64)) > 0 then
        k := k + 1;
      If VL(FetchElmFNo(RetNo, FNo, 75)) > 0 then
        k := k + 1;
      If VL(FetchElmFNo(RetNo, FNo, 84)) > 0 then
        k := k + 1;
    end;
    // s3qsupl
    If (UpperCase(LeftStr(FName, 7)) = 'S3QSUPL') and
      (Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)]) then
    begin
      j := 4;
      Repeat
        If VL(FetchElmFNo(RetNo, FNo, j)) > 0 then
          k := k + 1;
        inc(j, 7);
      until j > 137;

      j := 145;
      Repeat
        If VL(FetchElmFNo(RetNo, FNo, j)) > 0 then
          k := k + 1;
        inc(j, 6);
      until j > 175;
    end;

    // s3supl
    If (UpperCase(LeftStr(FName, 6)) = 'S3SUPL') and
      (Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)]) then
    begin
      j := 4;
      Repeat
        If VL(FetchElmFNo(RetNo, FNo, j)) > 0 then
          k := k + 1;
        inc(j, 7);
      until j > 67;

      j := 75;
      Repeat
        If VL(FetchElmFNo(RetNo, FNo, j)) > 0 then
          k := k + 1;
        inc(j, 6);
      until j > 87;

      j := 97;
      Repeat
        If VL(FetchElmFNo(RetNo, FNo, j)) > 0 then
          k := k + 1;
        inc(j, 8);
      until j > 121;

      j := 129;
      Repeat
        If VL(FetchElmFNo(RetNo, FNo, j)) > 0 then
          k := k + 1;
        inc(j, 6);
      until j > 135;

    end; // s3Supl
  end;
  Result := k;
end;

Function GetInfirmEligDependantsOver18(RetNo: integer): integer;
Var
  i, FNo: integer;
begin
  Result := 0;
  FNo := GetFormNo('DEPEND');
  i := 5;
  repeat
    If FetchElmFNo(RetNo, FNo, i) > '' then
    begin
      If (CalcAge(FetchElmFNo(RetNo, FNo, i + 5)) > 17) and
        (FetchElmFNo(RetNo, FNo, i + 7) = 'Y') then // infirm     //20130223
      begin
        If FetchElmFNo(RetNo, FNo, i + 14) = 'Y' then
          Result := Result + 1; // elig
      end;
    end;
    inc(i, 15);
  until i > 125;
end;

Function GetTaxOnBase(Bracket, PrevBracket, PrevPercent,
  PrevBaseTax: Real): Real;
begin
  Result := Round((Bracket - PrevBracket) * PrevPercent / 100) + PrevBaseTax;
end;

Procedure GetKidsForFitness(RetNo: integer);
// into somelist
Var
  i, FNo: integer;
begin
  SomeList.Clear;
  FNo := GetFormNo('DEPEND');
  i := 5;
  repeat
    If FetchElmFNo(RetNo, FNo, i) > '' then
    begin
      If (CalcAge(FetchElmFNo(RetNo, FNo, i + 5)) < 17) // was 16 20100301
      // 20101206
        or ((CalcAge(FetchElmFNo(RetNo, FNo, i + 5)) < 19) // was 18 20100301
        and (UpperCase(FetchElmFNo(RetNo, FNo, i + 7)) = 'Y') // 20121115
        ) then
      Begin
        SomeList.Add(PaddR(FetchElmFNo(RetNo, FNo, i) + ' ' + FetchElmFNo(RetNo,
          FNo, i + 1), 40) + PaddR(FetchElmFNo(RetNo, FNo, i + 6), 10) +
          PaddR('Age: ' + IntToStr(CalcAge(FetchElmFNo(RetNo, FNo, i + 5))), 10)
          + ' ' + PaddR(FetchElmFNo(RetNo, FNo, i + 7), 1));
        // disability  //20121115
        // f-last-rel-birth-disability
      end;
    end;
    i := i + 15;
  until i > 125;
end;

Procedure GetKidsForArts(RetNo: integer);
// into somelist
Var
  i, FNo: integer;
begin
  SomeList.Clear;
  FNo := GetFormNo('DEPEND');
  i := 5;
  repeat
    If FetchElmFNo(RetNo, FNo, i) > '' then
    begin
      If (CalcAge(FetchElmFNo(RetNo, FNo, i + 5)) < 17) // was 16 20100301
      // 20101206
        or ((CalcAge(FetchElmFNo(RetNo, FNo, i + 5)) < 19) // was 18 20100301
        and (FetchElmFNo(RetNo, FNo, i + 7) = 'Y') // 20130223
        ) then
      Begin
        SomeList.Add(PaddR(FetchElmFNo(RetNo, FNo, i) + ' ' + FetchElmFNo(RetNo,
          FNo, i + 1), 40) + PaddR(FetchElmFNo(RetNo, FNo, i + 6), 10) +
          PaddR('Age: ' + IntToStr(CalcAge(FetchElmFNo(RetNo, FNo, i + 5))), 10)
          + ' ' + PaddR(FetchElmFNo(RetNo, FNo, i + 7), 10)); // disability
        // f-last-rel-birth-disability
      end;
    end;
    i := i + 15;
  until i > 125;
end;

Procedure GetMBKidsForFitness(RetNo: integer);
// into somelist
Var
  i, FNo: integer;
begin
  SomeList.Clear;
  FNo := GetFormNo('DEPEND');
  i := 5;
  repeat
    If FetchElmFNo(RetNo, FNo, i) > '' then
    begin
      If ((CalcAge(FetchElmFNo(RetNo, FNo, i + 5)) < 19) // was 18 20110301
        ) then
      Begin
        SomeList.Add(PaddR(FetchElmFNo(RetNo, FNo, i) + ' ' + FetchElmFNo(RetNo,
          FNo, i + 1), 40) + PaddR(FetchElmFNo(RetNo, FNo, i + 6), 10) +
          PaddR('Age: ' + IntToStr(CalcAge(FetchElmFNo(RetNo, FNo, i + 5))), 10)
          + ' ' + PaddR(FetchElmFNo(RetNo, FNo, i + 7), 10)); // disability
        // f-last-rel-birth-disability
      end;
    end;
    i := i + 15;
  until i > 125;
end;

Function CountScholarships(RetNo: integer): integer;
var
  i, FNo: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'T4A' then
    begin
      FNo := FRec.FormNo;
      If FNo > 0 then // 20101020
      begin
        If VL(FetchElmFNo(RetNo, FNo, 31)) > 0 then
          Result := Result + 1;
      end;
    end;
  end;
end;

Function GetRestrictedFarmLoss(RetNo: integer; Stmt: String): Real;
Var
  i: integer;
  TotRestrictedLoss: Real;
  x: Real; // for t2042
begin
  Result := 0;
  TotRestrictedLoss := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if LeftStr(FRec.FormName, 5) = Stmt then
    begin
      If UpperCase(FetchElmFNo(RetNo, FRec.FormNo, 67)) = 'Y' then // restricted
      begin
        x := VL(FetchElm(RetNo, Stmt + FRec.FormInst, 149));
        If x < 0 then
          TotRestrictedLoss := TotRestrictedLoss + x;
      end;
    end;
  end;
  Result := TotRestrictedLoss;
end;

Function FieldHasNote(RetNo: integer; FName: String; elm: integer): String;
Var
  i: integer;
Begin
  If RetNo = 0 then
    Exit;
  Result := '';
  // For i:=Low(Ret[RetNo].AuditRec) to High(Ret[RetNo].AuditRec) do
  For i := 0 to Ret[RetNo].AuditList.Count - 1 do
  begin
    If Ret[RetNo].AuditRec[i].Category = 'N-' then
    begin
      If (UpperCase(AllTrim(Ret[RetNo].AuditRec[i].Form)) = FName) and
        (Ret[RetNo].AuditRec[i].elm = elm) then
      Begin
        Result := AllTrim(Ret[RetNo].AuditRec[i].Form);
        Exit;
      end;
    end;
  end;
end;

Function FieldHasTape(RetNo: integer; FName: String; elm: integer): String;
Var
  i: integer;
Begin
  If RetNo = 0 then
    Exit;
  Result := '';
  // For i:=Low(Ret[RetNo].AuditRec) to High(Ret[RetNo].AuditRec) do
  For i := 0 to Ret[RetNo].AuditList.Count - 1 do
  begin
    If Ret[RetNo].AuditRec[i].Category = 'D-' then
    begin
      If (AllTrim(Ret[RetNo].AuditRec[i].Form) = FName) and
        (Ret[RetNo].AuditRec[i].elm = elm) then
      Begin
        Result := AllTrim(Ret[RetNo].AuditRec[i].Form);
        Exit;
      end;
    end;
  end;
end;

function ColumnSortAscending(List: TStringList;
  Index1, Index2: integer): integer;
var
  lsStr1, lsStr2: string;
begin
  // get the strings to compare
  lsStr1 := Copy(List[Index1], 32, 5);
  lsStr2 := Copy(List[Index2], 32, 5);
  Result := AnsiCompareText(lsStr1, lsStr2); // AnsiCompareText(Str1, Str2);
end;

function ColumnSortDescending(List: TStringList;
  Index1, Index2: integer): integer;
var
  lsStr1, lsStr2: string;
begin
  // get the strings to compare
  lsStr1 := Copy(List[Index1], 32, 5);
  lsStr2 := Copy(List[Index2], 32, 5);
  Result := -AnsiCompareText(lsStr1, lsStr2); // - AnsiCompareText(Str1, Str2);
end;

// MyStringList.CustomSort(ColumnSortDescending);
// or
// MyStringList.CustomSort(ColumnSortAscending

Procedure RenumberMultiples(RetNo: integer; FrmNm: String);
Var
  i, j: integer;
begin
  j := 1;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If ((FrmNm = FRec.FormName) and
      (Ret[RetNo].FormHasData[FRec.FormName + FRec.FormInst])) then // 20160813
    begin

    End;
  end;
end;

// 20160905 Igor (Move to vtTrimStr)
// procedure AdjustFinePrintRegistrySettings(PDFFullfileName: String;
// ShowDlgValue: Integer; PdfActionValue: Integer; CollectJobsValue: Integer);
// var
// i,j : Integer;
// Reg: TRegistry;
// PDFfilePath, PDFfileName: String;
// keyName, keyName2, keyNameTemp, PDFFactoryVersion, PDFFactoryVersion2: String;
// Val, Val2: TStringList;
//
// procedure AdjustForPDFstd(PDFFullfileName: String; ShowDlgValue: Integer;
// PdfActionValue: Integer; CollectJobsValue: Integer);
// begin
// keyNameTemp := keyName + '\' + PDFFactoryVersion;
// If Reg.OpenKey(keyNameTemp, False) = True then //False because we do not want to create it if it doesn’t exist
// Begin
// if PDFFullfileName = '' then
// begin
// reg.DeleteValue('OutputFilePerm'); //20160905 Igor
// reg.DeleteValue('OutputFile');     //20160905 Igor
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
// End
// else
// ShowMessage('Cannot find '+keyNameTemp);
//
// keyNameTemp := keyName + '\' + PDFFactoryVersion + '\FinePrinters\' + PDFFactoryVersion2;
// If Reg.OpenKey(keyNameTemp,False) = True then //False because we do not want to create it if it doesn’t exist
// Begin
// reg.WriteInteger('ShowDlg', ShowDlgValue);
// reg.WriteInteger('PdfAction', PdfActionValue);
// reg.WriteInteger('CollectJobs', CollectJobsValue);
// end
// else
// ShowMessage('Cannot find '+keyNameTemp);
// end;
//
// procedure AdjustForPDfpro(PDFFullfileName: String; ShowDlgValue,
// PdfActionValue, CollectJobsValue: Integer);
// begin
// keyNameTemp := keyName + '\' + PDFFactoryVersion + '\FinePrinters\' +
// PDFFactoryVersion2 + '\PrinterDriverData';
// If Reg.OpenKey(keyNameTemp,False) = True then //False because we do not want to create it if it doesn’t exist
// Begin
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
// If Reg.OpenKey(keyNameTemp,False) = True then //False because we do not want to create it if it doesn’t exist
// Begin
// reg.WriteString('OutputFilePerm', PDFFullfileName);
// reg.WriteString('OutputFile', PDFFullfileName);
// reg.WriteString('CurDir', PDFfilePath);
// reg.WriteString('AutoSaveDir', PDFfilePath);
// end
// else
// begin
// ShowMessage('Cannot find '+keyNameTemp);
// end;
//
// keyNameTemp := keyName + '\' + PDFFactoryVersion + '\FinePrinters\' + PDFFactoryVersion2;
// If Reg.OpenKey(keyNameTemp,False) = True then //False because we do not want to create it if it doesn’t exist
// Begin
// reg.WriteInteger('ShowDlg', ShowDlgValue);
// reg.WriteInteger('PdfAction', PdfActionValue);
// reg.WriteInteger('CollectJobs', CollectJobsValue);
// end
// else
// begin
// ShowMessage('Cannot find '+keyNameTemp);
// end;
// end;
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
// if not Reg.OpenKey(keyName,False) then
// ShowMessage('Error opening key')
// else
// begin
// Reg.GetKeyNames(Val);
// for i := 0 to Val.Count-1 do
// begin
// PDFFactoryVersion := Val.Strings[i];
// keyName2 := keyName + '\' + PDFFactoryVersion + '\FinePrinters';
// if not Reg.OpenKey(keyName2, False) then
// ShowMessage('Error opening key')
// else
// begin
// Reg.GetKeyNames(Val2);
// for j := 0 to Val2.Count-1 do
// begin
// if Pos('PDFFACTORY',uppercase(Val2.Strings[j])) > 0 then
// begin
// PDFFactoryVersion2 := Val2.Strings[j];
// end;
// end;
// end;
//
// AdjustForPDFstd(PDFFullfileName, ShowDlgValue, PdfActionValue, CollectJobsValue);
// end;
// end;
// finally
// Val.Free;
// end;
// finally
// Reg.Free;
// end;
// end;

(* //20220121 Igor   moved to vtTrimStr
  Function IsInTapesList(RetNo: Integer; Fname: String; elm: Integer): Boolean;
  var
  i: Integer;
  A: TArray<string>;
  TapeFName: String;
  TapeElm: Integer;
  begin
  Result := false;
  TapeElm := Ret[RetNo].;
  For i := 0 to Ret[RetNo].TapesList.Count - 1 do
  begin
  A := Ret[RetNo].TapesList[i].Split(['|'], ExcludeEmpty);
  if Length(A) < 2 then continue;
  TapeFName := AllTrim(A[0]);
  TapeElm := MyStrToInt(AllTrim(A[1]));
  If (Fname = TapeFName) and (elm = TapeElm) then
  begin
  Result := True;
  exit;
  end;
  end;
  end;
*)

Function IsDitto(S: String): Boolean;
// char 34 is the apotrophe with " (shift)
// char 39 is two simple apostrophes without pressing the shift key
begin
  If (S = char(34)) or (S = char(39) + char(39)) then
    Result := true
  Else
    Result := false;
end;

Function CheckAssets(RetNo: integer): String;
Var
  i, SpRetNo: integer;
  AssetBInstances, AutosInstances: String;
begin
  Result := '';
  SpRetNo := GetSpRetNo(RetNo);
  If SpRetNo < 1 then
    Exit;

  AssetBInstances := '';
  AutosInstances := '';

  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If (FRec.FormName = 'ASSETSB') then
    begin
      If (VL(FetchElmFNo(RetNo, FRec.FormNo, 176)) <> VL(FetchElmFNo(SpRetNo,
        FRec.FormNo, 176))) then
        AssetBInstances := AssetBInstances + AllTrim(FRec.FormInst) + ' ';
    end
    Else If (FRec.FormName = 'AUTOS') then
    begin
      If (VL(FetchElmFNo(RetNo, FRec.FormNo, 176)) <> VL(FetchElmFNo(SpRetNo,
        FRec.FormNo, 176))) then
        AutosInstances := AutosInstances + AllTrim(FRec.FormInst) + ' ';
    end
  end;
  If AssetBInstances > '' then
    Result := 'Assetsb' + ' ' + AssetBInstances;
  If AutosInstances > '' then
    Result := Result + ' ' + 'Autos' + ' ' + AutosInstances;
end;

Function CountMultiPageStatements(RetNo: integer; FrmNm: String): integer;
Var
  i, k: integer; // comes in as t2125
begin
  k := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If Ret[RetNo].FrmHasData[FRec.FormNo] then // 20160813 //20170324 Igor
    begin
      If (FrmNm = FRec.FormName) and (IsFormMultiPage(FrmNm)) then
        inc(k);
    end;
  end; // i
  Result := k;
end;

Function CountSinglePageStatements(RetNo: integer; FrmNm: String): integer;
Var
  i, k: integer;
begin
  k := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If Ret[RetNo].FrmHasData[FRec.FormNo] then // 20160813 //20170324 Igor
    begin
      If (IsFormMultiPage(FrmNm) = false) and (FRec.FormInst > '') and
        (FrmNm = FRec.FormName) then
        inc(k);
    end;
  end;
  Result := k;
end;

Function GetFirstInstanceWithData(RetNo: integer; FName: String): String;
Var
  i, j, FNo: integer;
  FInst: String;
begin
  Result := ''; // 20110224   :='';
  If IsFormMultiInst(FName) then
    Result := '#1';

  For j := 1 to 10 do
  Begin
    // 20101219
    FNo := GetFormNo(ExtractNonInstFormName(FName) + '#' +
      AllTrim(IntToStr(j)));
    If FNo > 0 then
    begin
      If Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)] then
        Result := '#' + AllTrim(IntToStr(j));
    end;
  end;
end;

function ReplaceStr(OriginalString, SubStr, NewStr: string): string;
var
  Position: integer;
begin
  Position := Pos(SubStr, OriginalString);
  Delete(OriginalString, Position, Length(SubStr));
  Insert(NewStr, OriginalString, Position);
  Result := OriginalString;
end;

// returns true if dfm file is in a binary format
function IsDFMBinary(FileName: string): Boolean;
var
  F: TFileStream;
  B: Byte;
begin
  B := 0;
  F := TFileStream.Create(FileName, fmOpenRead);
  try
    F.Read(B, 1);
    Result := B = $FF;
  finally
    F.Free;
  end;
end;

// convert a binary dfm file to a text dfm file
function Dfm2Txt(Src, Dest: string): Boolean;
var
  SrcS, DestS: TFileStream;
begin
  if Src = Dest then
  begin
    MessageDlg('Error converting dfm file to binary!. ' +
      'The source file and destination file names are the same.', mtError,
      [mbOk], 0);
    Result := false;
    Exit;
  end;
  SrcS := TFileStream.Create(Src, fmOpenRead);
  DestS := TFileStream.Create(Dest, fmCreate);
  try
    ObjectResourceToText(SrcS, DestS);
    if FileExists(Src) and FileExists(Dest) then
      Result := true
    else
      Result := false;
  finally
    SrcS.Free;
    DestS.Free;
  end;
end;

// convert a text DFM file to a binary DFM file
function Txt2DFM(Src, Dest: string): Boolean;
var
  SrcS, DestS: TFileStream;
begin
  if Src = Dest then
  begin
    MessageDlg('Error converting dfm file to binary!. ' +
      'The source file and destination file names are the same.', mtError,
      [mbOk], 0);
    Result := false;
    Exit;
  end;
  SrcS := TFileStream.Create(Src, fmOpenRead);
  DestS := TFileStream.Create(Dest, fmCreate);
  try
    ObjectTextToResource(SrcS, DestS);
    if FileExists(Src) and FileExists(Dest) then
      Result := true
    else
      Result := false;
  finally
    SrcS.Free;
    DestS.Free;
  end;
end;

/// open a binary DFM file as a text stream
function DfmFile2Stream(const Src: string; Dest: TStream): Boolean;
var
  SrcS: TFileStream;
begin
  SrcS := TFileStream.Create(Src, fmOpenRead or fmShareDenyWrite);
  try
    ObjectResourceToText(SrcS, Dest);
    Result := true;
  finally
    SrcS.Free;
  end;
end;

function ConvertFormToText(SourceFileName: string): Boolean;
var
  InputStream, OutputStream: TFileStream;
  DestFileName: string;
begin
  Result := true;
  { change the file extension to .txt }
  DestFileName := ChangeFileExt(SourceFileName, '.txt');
  { Create a file stream for the specified file }
  InputStream := TFileStream.Create(SourceFileName, fmOpenRead);
  OutputStream := TFileStream.Create(DestFileName, fmCreate);
  { convert }
  try
    try
      ObjectResourceToText(InputStream, OutputStream);
    except
      On EStreamError do
        Result := false;
    end
  finally
    { free memory }
    InputStream.Free;
    OutputStream.Free;
  end;
end;

function ConvertTextToForm(SourceFileName: string): Boolean;
var
  InputStream, OutputStream: TFileStream;
  DestFileName: string;
begin
  Result := true;

  DestFileName := ChangeFileExt(SourceFileName, '.dfm');

  InputStream := TFileStream.Create(SourceFileName, fmOpenRead);
  OutputStream := TFileStream.Create(DestFileName, fmCreate);
  try
    try
      ObjectTextToResource(InputStream, OutputStream);
    except
      on EStreamError do
        Result := false;
    end
  finally
    InputStream.Free;
    OutputStream.Free;
  end;
end;

Function ConvertFNameToCombined(FName: String): String;
Var
  FInst: String;
begin
  Result := FName;
  If IsFormMultiPage(FName) = false then
    Exit; // only if multipage
  FInst := ExtractFormInst(FName);
  Result := ExtractFormRootName(FName) + FInst;
end;

Function ConvertElmNoToCombined(OldFName: String; elm: integer;
  IncrElmList: TStringList): integer;
Var
  FInst: String;
  OldNonInstFName, NewNonInstFName, RootFormName: String;
Var
  i: integer;
begin
  Result := elm;
  If IsFormMultiPage(OldFName) = false then
    Exit; // only if multipage
  OldFName := UpperCase(OldFName);
  FInst := ExtractFormInst(OldFName);
  OldNonInstFName := ExtractNonInstFormName(OldFName);
  NewNonInstFName := ExtractNonInstFormName
    (ConvertFNameToCombined(OldNonInstFName));
  For i := 0 to IncrElmList.Count - 1 do
  begin
    If OldNonInstFName = UpperCase
      (AllTrim(LeftStr(MidStr(IncrElmList[i], 2, 9), 9))) then
    begin
      Result := elm + MyStrToInt(AllTrim(MidStr(IncrElmList[i], 11, 4)));
      Exit;
    end;
  end;
end;

Function GetClientNameFromDB(FlName: String): String;
var
  // lPsw:String; //20160303 Igor
  // 20150825 igor
  FDConnection: TADConnection;
begin
  // fGetSQLitePsw(lPsw); //20150925 igor //20160303 Igor

  Result := '';
  FDConnection := TADConnection.Create(nil);
  // with TADConnection.Create(nil) do
  try
    if SetConnection(FDConnection, OptRec.Dir_Cur + '\' + ClientsDBLite,
      ClientsTableLite) then
    Begin
      // DriverName := 'SQLite';
      // Params.Values['DataBase'] := OptRec.Dir_Cur + '\' + ClientsDBLite;
      // //20150904 igor
      // Params.Values['Password'] := lPsw;
      Result := FDConnection.ExecSQLScalar('SELECT LAST_Name||''' + ' ' +
        '''||FIRST_NAME FROM ' + ClientsTableLite +
        ' WHERE lower(File_Name) = lower(''' + FlName + ''')'); // 20170223 Igor
    End;
    if Result = '' then
      Result := '** File not in the Client Book **';
  finally
    FDConnection.Free;
  end;

  { Table1 := TADTable.Create(Application);
    Table1.DataBaseName := OptRec.Dir_Cur;
    Table1.TableName := ClientsTable;
    Table1.IndexName := 'File_Name';
    Table1.Open;
    if Table1.FindKey([FlName]) then
    begin
    Result:=Table1.FieldByName('LAST_Name').AsString + ' '+Table1.FieldByName('FIRST_NAME').AsString;
    Exit;
    end
    Else
    begin
    Result:='** File not in the Client Book **';
    end;
    Table1.Close;
    Table1.Free; }
end;

procedure RegisterFileType(cMyExt, cMyFileType, cMyDescription, ExeName: string;
  IcoIndex: integer; DoUpdate: Boolean = false);
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.Rootkey := HKEY_CLASSES_ROOT;
    reg.OpenKey(cMyExt, true);
    // Write my file type to it.
    // This adds HKEY_CLASSES_ROOT\.abc\(Default) = 'Project1.FileType'
    reg.WriteString('', cMyFileType);
    reg.CloseKey;
    // Now create an association for that file type
    reg.OpenKey(cMyFileType, true);
    // This adds HKEY_CLASSES_ROOT\Project1.FileType\(Default)
    // = 'Project1 File'
    // This is what you see in the file type description for
    // the a file's properties.
    reg.WriteString('', cMyDescription);
    reg.CloseKey; // Now write the default icon for my file type
    // This adds HKEY_CLASSES_ROOT\Project1.FileType\DefaultIcon
    // \(Default) = 'Application Dir\Project1.exe,0'
    reg.OpenKey(cMyFileType + '\DefaultIcon', true);
    reg.WriteString('', ExeName + ',' + IntToStr(IcoIndex));
    reg.CloseKey;
    // Now write the open action in explorer
    reg.OpenKey(cMyFileType + '\Shell\Open', true);
    reg.WriteString('', '&Open');
    reg.CloseKey;
    // Write what application to open it with
    // This adds HKEY_CLASSES_ROOT\Project1.FileType\Shell\Open\Command
    // (Default) = '"Application Dir\Project1.exe" "%1"'
    // Your application must scan the command line parameters
    // to see what file was passed to it.
    reg.OpenKey(cMyFileType + '\Shell\Open\Command', true);
    reg.WriteString('', '"' + ExeName + '" "%1"');
    reg.CloseKey;
    // Finally, we want the Windows Explorer to realize we added
    // our file type by using the SHChangeNotify API.
    if DoUpdate then
      SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);
  finally
    reg.Free;
  end;
end;

Function GetPRPStatusDescr(PRPStatusCode: String): String;
var
  i: integer;
begin
  Result := '';
  For i := Low(PRPStatusCodes) to High(PRPStatusCodes) do
    If PRPStatusCodes[i] = PRPStatusCode then
    begin
      Result := PRPStatusDescr[i];
      Exit;
    end;
end;

Function GetEfStatusDescr(EFStatusCode: String): String;
var
  i: integer;
begin
  Result := '';
  For i := Low(EFStatusCodes) to High(EFStatusCodes) do
    If EFStatusCodes[i] = EFStatusCode then
    begin
      Result := EFStatusDescr[i];
      Exit;
    end;
end;

procedure ShowTheFList;
Var
  i: integer;
  RetNo: integer;
begin
  SomeList.Clear; // := TStringList.Create;
  SomeList.Sorted := true;
  SomeCaption := 'Forms in FList';
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if (FRec.FormNo > 0) and (FRec.FormType <> 'MI') then
      SomeList.Add('                ' + PaddR(FRec.FormName, 12) +
        PaddR(FRec.FormInst, 4) + PaddR(IntToStr(FRec.FormNo), 5) +
        PaddR(FRec.FormAbrev, 24) + PaddR(IntToStr(FRec.FormFields), 5) +
        PaddR(FRec.FormType, 3));
  end;
  PopSomeList(SomeList, SomeCaption);
  if PopResult = mrAll then
  begin
    // only if printing is required
    SomeList.SaveToFile(AppDir + '\' + 'Temp.txt');
    PrintSomeFile(AppDir + '\' + 'Temp.txt');
  end;
  // SomeList.Free;  //20160301 Igor
end;

{
  //20170126
  Function GetRc310Income(RetNo:Integer):Real;
  Begin
  Result:=Vl(FetchElm(RetNo,'RC310',15)); //+Vl(FetchElm(RetNo,'INFO',168));  //spouses 5229
  end;
}

Function IsSpouseNonResident(RetNo: integer): Boolean;
Begin
  Result := false;
  If FetchElm(RetNo, 'INFO', 167) > '' then
    Result := true;
end;

{
  //20171119
  Procedure CopyCATCFromFitness(RetNo:Integer);
  Var i,FitnessFNo,CATCFNo:Integer;
  Begin
  FitnessFNo:=GetFormNo('FITNESS');
  CATCFNo:=GetFormNo('CATC');
  For i:=1 to 73 do
  begin
  StoreElm(RetNo,CATCFNo,i,FetchElmFNo(RetNo,FitnessFNo,i));
  end;
  end;
}

Function GetFncValue(RetNo: integer): String; // living in aboriginal land
Begin
  Result := ''; // 201206
  // Result:='2';  //means no
  IF (Ret[RetNo].Province = 'NL') then
  begin
    If FetchElm(RetNo, 'INFO', 127) > '' then
      Result := '1'; // else Result:='0';
    // If FetchElm(RetNo,'INFO',136) >'' then Result:='2';
  end;

  If Ret[RetNo].Province = 'NT' then
  begin
    If FetchElm(RetNo, 'INFO', 90) > '' then
      Result := '1'; // else Result:='0';
    // If FetchElm(RetNo,'INFO',137) >'' then Result:='2';
  end;
  If Ret[RetNo].Province = 'YT' then
  begin
    If FetchElm(RetNo, 'INFO', 132) > '' then
      Result := '1'; // else Result:='0';
    // If FetchElm(RetNo,'INFO',138) >'' then Result:='2';
  end;
end;

Procedure RenumberT1Scr;
Var
  i: integer;
  ADConnection: TADConnection;
  Table1: TADTable;
begin
  // 20150915 Igor
  ADConnection := TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  // 20160226 Igor >>>>
  if not SetTableName(ADConnection, Table1, AppDir + '\' + FormsDBLite,
    FormsTableLite, 'FormNo') then
  Begin
    if Assigned(ADConnection) then
      FreeAndNil(ADConnection);
    if Assigned(Table1) then
      FreeAndNil(Table1);
    Exit;
  End;

  i := 0;
  Table1.First;
  Repeat
    i := i + 1;
    Table1.Edit;
    Table1.FieldByName('FormNo').AsInteger := i;
    Table1.Next;
  until Table1.EOF;

  Table1.Free;
  ADConnection.Free;
end;

Procedure CheckAllForms;
Var
  i: integer;
  DfmFileName: String;
  RetNo: integer;
begin
  RetNo := GetCurrentRetNo;
  If RetNo = 0 then
  Begin
    ShowMessage('First open a return');
    Exit;
  End;
  OpenCloseForms(0, 50);
  OpenCloseForms(51, 100);
  OpenCloseForms(101, 150);
  OpenCloseForms(151, 200);
  OpenCloseForms(201, 250);
  OpenCloseForms(251, 300);
  OpenCloseForms(301, FList.Count - 1);
end;

Procedure OpenCloseForms(Ndx1, Ndx2: integer);
Var
  i: integer;
  DfmFileName: String;
  RetNo: integer;
begin
  RetNo := CreateNewReturn;
  if RetNo < 1 then
  begin
    ShowOpenReturnFailure(RetNo, '', '');
    Exit;
  end;
  for i := Ndx1 to Ndx2 do
  begin
    FRec := FList.Items[i];
    OpenForm(RetNo, FRec.FormInstName, 0);
  end;
  // if MessageDlg('Close them now?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  // begin
  CloseReturn(RetNo, true);
end;

Procedure ShowHTTPStatus(State: integer);
Var
  Status: String;
Begin
  Status := 'Uknown';
  Case State of
    0:
      Status := 'Unsent';
    1:
      Status := 'Opened';
    2:
      Status := 'Headers received';
    3:
      Status := 'Loading';
    4:
      Status := 'Done';
  end;
  ShowTimedMsg(Status, 2000);
end;

Function YYYYMMDDToMMDDYYYY(Dt: String): string;
// yyyy-mm-dd to mm/dd/yyyy
begin
  Result := MidStr(Dt, 6, 2) + '/' + RightStr(Dt, 2) + '/' + LeftStr(Dt, 4);
  If Result = '//' then
    Result := '';
end;

Function ExtractLinkedFormAndSlashField(FInst: String; LinkedToString: String;
  Var TargetLinkedField: integer): String; // 20101223
// comes as ffffff#n/5
Var
  SlashPos: integer;
  LinkedToForm: String;
begin
  LinkedToString := AllTrim(LinkedToString);
  SlashPos := Pos('/', LinkedToString);
  If SlashPos = 0 then
  begin
    Result := AllTrim(LinkedToString);
    TargetLinkedField := 0;
  end
  else
  begin
    LinkedToForm := AllTrim(LeftStr(LinkedToString, SlashPos - 1));
    If ExtractFormInst(LinkedToForm) = '#' then
      Result := ExtractNonInstFormName(LinkedToForm) + FInst
    else
      Result := AllTrim(LeftStr(LinkedToString, SlashPos - 1));
    TargetLinkedField :=
      MyStrToInt(AllTrim(MidStr(LinkedToString, SlashPos + 1, 3)));
  end;
end;

// Not called from any place  //20200408
Procedure CallT1WebService;
// http://linkzero.co.uk/soap.html
Var
  WString: AnsiString; // wide string
  objHttp: ixmlHttpRequest;
  SoapMsg: AnsiString;
  Status: String;
  sUrl: String;
  TempList: TStringList;
  T1WebServiceFile: String;
  xmlDoc: Variant;
var
  i: integer;
Begin
  T1WebServiceFile := AppDir + '\' + 'T1WebService2.xml';
  TempList := TStringList.Create;
  TempList.LoadFromFile(T1WebServiceFile);

  SoapMsg := '';
  For i := 0 to TempList.Count - 1 do
    SoapMsg := SoapMsg + TempList[i] + Chr(13);
  ShowMessage(SoapMsg);

  // define
  objHttp := CreateOLEObject('MSXML2.XMLHTTP.3.0') as ixmlHttpRequest;
  // ShowHTTPStatus(ObjHTTP.ReadyState);
  sUrl := 'https://apps-ct.cra-arc.gc.ca/ebci/pfeo/ws/services/EolService';
  // open it
  objHttp.Open('POST', sUrl, false, 'B0865', '948789Q');
  // what is this? 20200119
  // objHttp.open('POST', sUrl, false, 'B0864', '948789Q');  //what is this? 20200119

  // 'GET' says perhaps thre will be a form...
  objHttp.setRequestHeader('SOAPAction', 'NA'); // set action?

  // transmit it now
  Screen.Cursor := crHourGlass;
  objHttp.send(SoapMsg);
  Delay(600);
  Screen.Cursor := crDefault;
  ShowHTTPStatus(objHttp.ReadyState);
  ShowTimedMsg('Getting response', 600);

  WString := objHttp.ResponseText;
  ShowMessage(objHttp.ResponseText);

  ShowMessage(WString);
  // ObjHTTP.Free;     //FREE not accepted by compiler
end;

Function ShouldHighlight(RetNo: integer; FName: String; FNo: integer): Boolean;
// 20110109
Var
  i: integer;
begin
  Result := false;
  If (LeftStr(FName, 7) <> 'T776SUM') and (LeftStr(FName, 8) <> 'T2125SUM') and
    (LeftStr(FName, 8) <> 'T2121SUM') and (LeftStr(FName, 8) <> 'T2042SUM') and
    (LeftStr(FName, 8) <> 'T1163SUM') and (LeftStr(FName, 8) <> 'T1273SUM') then
    Result := true;
end;

// Not called from any place //20200408
Procedure CallTrisWebService;
// http://linkzero.co.uk/soap.html
Var
  WString: AnsiString; // wide string
  objHttp: ixmlHttpRequest;
  SoapMsg: AnsiString;
  Status: String;
  sUrl: String;
  T1013Msg: AnsiString;
  TempList: TStringList;
  T1013File: String;
  h: THandle;

  DOMDocument: IXMLDOMDocument;
  TrackNodes: IXMLDOMNodeList;
  ResponseXmlFile: String;
var
  i: integer;

Begin
  T1013File := AppDir + '\' + 'T1013.xml';
  ResponseXmlFile := AppDir + '\' + 'TrisRersponse.xml';
  TempList := TStringList.Create;
  TempList.LoadFromFile(T1013File);

  SoapMsg := '';
  For i := 0 to TempList.Count - 1 do
    SoapMsg := SoapMsg + TempList[i] + Chr(13);
  // define
  objHttp := CreateOLEObject('MSXML2.XMLHTTP.3.0') as ixmlHttpRequest;
  sUrl := 'https://apps-ct.cra-arc.gc.ca/ebci/tdws/esub/services/TRISWebService';
  // open it
  objHttp.Open('POST', sUrl, false, 'B0864', '948789Q');
  objHttp.setRequestHeader('SOAPAction', 'NA'); // set action?
  objHttp.setRequestHeader('Content-Type', 'text/xml');
  // ShowHTTPStatus(ObjHTTP.ReadyState);
  // transmit it now
  Screen.Cursor := crHourGlass;
  objHttp.send(SoapMsg);
  Delay(1000);
  Screen.Cursor := crDefault;
  WString := objHttp.ResponseText;
  // ShowMessage(WString);
  DOMDocument := coDOMDocument.Create;
  DOMDocument.async := false;
  DOMDocument.loadXML(WString);
  DOMDocument.Save(ResponseXmlFile);
  h := ShellExecute(Application.MainForm.Handle, 'open',
    PChar('' + ResponseXmlFile), Nil, Nil, SW_SHOW);
  If h <= 32 then
    ShowMessage(ResponseXmlFile + 'not found');
  // objHttp.Free;    It is not accepted
end;

Function ValidForT1013Efile(RetNo: integer; FNo: integer): Boolean;
var
  i: integer;
begin
  Result := true;

  If FetchElmFNo(RetNo, FNo, 39) > '' then // alredy efiled
    Result := false;

  If (FetchElmFNo(RetNo, FNo, 26) = '') then
  Begin
    Result := false;
    Exit;
  end; // not set for filing

  If (FetchElmFNo(RetNo, FNo, 26) > '') then // but no other info
  begin
    If (FetchElmFNo(RetNo, FNo, 27) = '') and
      (Length(FetchElmFNo(RetNo, FNo, 8)) = 1) // 20180201
      and (FetchElmFNo(RetNo, FNo, 28) = '') and
      (FetchElmFNo(RetNo, FNo, 14) = '') and (FetchElmFNo(RetNo, FNo, 16) = '')
      and (FetchElmFNo(RetNo, FNo, 15) = '') and
      (FetchElmFNo(RetNo, FNo, 17) = '') then
      Result := false;

    // prt A
    If (FetchElmFNo(RetNo, FNo, 27) = '') and (FetchElmFNo(RetNo, FNo, 8) = '')
      and (FetchElmFNo(RetNo, FNo, 28) = '')

    // part B
      and (FetchElmFNo(RetNo, FNo, 15) = '') and
      (FetchElmFNo(RetNo, FNo, 17) = '')
    // part 4 cancel
      and (FetchElmFNo(RetNo, FNo, 14) = '') and
      (FetchElmFNo(RetNo, FNo, 16) = '') then
      Result := false;
  end;

  If (FetchElmFNo(RetNo, FNo, 14) > '') // radio buttons
    and (FetchElmFNo(RetNo, FNo, 16) > '') then
    Result := false;

  If (FetchElmFNo(RetNo, FNo, 16) > '') then // B cancellation
  begin
    If (FetchElmFNo(RetNo, FNo, 6) = '') and (FetchElmFNo(RetNo, FNo, 10) = '')
      and (FetchElmFNo(RetNo, FNo, 7) = '') and
      (FetchElmFNo(RetNo, FNo, 1) = '') and (FetchElmFNo(RetNo, FNo, 31) = '')
      and (FetchElmFNo(RetNo, FNo, 2) = '') then
      Result := false;
  end;
end;

Function GetT1013ConfirmationNumber(ResponseXmlFile: String): String;
Const
  LookingForString = 'ConfirmationNumber>';
Var
  TempList: TStringList;
  k: integer;
var
  i: integer;
Begin
  If FileExists(ResponseXmlFile) = false Then
  begin
    ShowMessage('CRA response file cannot be found');
    Exit;
  end;
  // Get the Confirmation number and store it in Elm=39 of T1013
  Result := '';

  TempList := TStringList.Create;
  TempList.LoadFromFile(ResponseXmlFile);
  For i := 0 to TempList.Count - 1 do
  begin
    k := Pos(LookingForString, TempList[i]);
    If k > 0 then
    begin
      Result := MidStr(TempList[i], k + Length(LookingForString), 10);
      TempList.Free;
      Exit;
    end;
  end;
  TempList.Free;
end;

Function OpenReturnAndCheckT1013(DataDir: String; FlName: String): Boolean;
// 20220113 Igor
Var
  RetNo: integer;
Begin
  Result := true;
  try
    RetNo := ReadReturn(DataDir, FlName);
    if RetNo > 0 then
    begin
      If ValidForT1013Efile(RetNo, GetFormNo('AUTHREP#1')) = true then
      // If ValidForT1013Efile(RetNo, GetFormNo('T1013#1')) = True then
      begin
        Result := true;
        // If RetNo >0 then
        RemoveReturnFromMemory(RetNo);
        RetNo := 0; // RetINmem :=0;
        Exit;
      end
      Else
        Result := false; // no valid T1013
    end
    Else
      Result := false;

    If RetNo > 0 then
      RemoveReturnFromMemory(RetNo); // RetNo :=0; //RetINmem :=0;
  finally
    Screen.Cursor := crDefault;
  end;
end;

(*
  Function OpenReturnAndCheckT1013(DataDir: String; FlName: String): Boolean;
  Var
  RetNo: Integer;
  Begin
  Result := True;
  RetNo := ReadReturn(DataDir, FlName);
  if RetNo > 0 then
  begin
  If ValidForT1013Efile(RetNo, GetFormNo('AUTHREP#1')) = True then
  // If ValidForT1013Efile(RetNo, GetFormNo('T1013#1')) = True then
  begin
  Result := True;
  // If RetNo >0 then
  RemoveReturnFromMemory(RetNo);
  RetNo := 0; // RetINmem :=0;
  exit;
  end
  Else
  Result := false; // no valid T1013
  end
  Else
  Result := false;

  If RetNo > 0 then
  RemoveReturnFromMemory(RetNo); // RetNo :=0; //RetINmem :=0;
  end;
*)
Function GetT4AIncomeForT2125(RetNo: integer; T2125FInst: String): Real;
Var
  i: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T4A' then
    begin
      If Ret[RetNo].FormHasData[FRec.FormName + FRec.FormInst] then // 20160813
      Begin
        If '#' + FetchElmFNo(RetNo, FRec.FormNo, 12) = T2125FInst then
          Result := Result + VL(FetchElmFNo(RetNo, FRec.FormNo, 3));

        If '#' + FetchElmFNo(RetNo, FRec.FormNo, 11) = T2125FInst then
          Result := Result + VL(FetchElmFNo(RetNo, FRec.FormNo, 62));
      end;
    end;
  end;
end;

Function GetT1204IncomeForT2125(RetNo: integer; T1204FInst: String): Real;
Var
  i: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T1204' then
    begin
      If Ret[RetNo].FormHasData[FRec.FormName + FRec.FormInst] then // 20160813
      Begin
        If '#' + FetchElmFNo(RetNo, FRec.FormNo, 17) = T1204FInst then
          Result := Result + VL(FetchElmFNo(RetNo, FRec.FormNo, 3)) +
            VL(FetchElmFNo(RetNo, FRec.FormNo, 4)); // 20190209
      end;
    end;
  end;
end;

Function IsValidLastYearPgmFolder(AShowMessage: Boolean;
  out AErrorMessage: String): Boolean; // 20160516 Igor
Var
  LastYearPgm, LastYearBpl: String; // 20160302 Igor
begin
  AErrorMessage := '';
  Result := false; // 20110228
  If OptRec.Dir_PgmLastYr = '' then
  begin
    AErrorMessage :=
      'You should first enter the program directory you used last year' +
      Chr(13) + 'See Configure | General Options | Data Directories.' + #13 +
      'You need to Exit and restart the program after changing last year’s data directory';
    // 20160706 Igor
    if AShowMessage then // 20160516 Igor
      ShowMessage(AErrorMessage);
    Exit;
  end;
  If (DirectoryExists(OptRec.Dir_PgmLastYr) = false) then
  Begin
    AErrorMessage := 'Last year program’s directory "' + OptRec.Dir_PgmLastYr +
      '" does not exist.' // 20160710 Igor
      + Chr(13) + 'See Configure | General Options | Data Directories' + #13 +
      'You need to Exit and restart the program after changing last year’s data directory';
    if AShowMessage then // 20160516 Igor
      ShowMessage(AErrorMessage);
    Exit;
  End;

  // if not FileExists(OptRec.Dir_PgmLastYr+'\'+FieldsListD) then
  // Begin
  // ShowMessage('Last Year'+Chr(39)+'s directory does not have a VisualTax system files'
  // +Chr(13)+'See Configure | General Options | Data Directories');
  // exit;
  // End;

  If FileExists(OptRec.Dir_PgmLastYr + '\' + FormsScrDBLite) = false then
  // exit; //20150915 Igor
  Begin
    if FileExists(OptRec.Dir_PgmLastYr + '\' + ChangeFileExt(FormsScrDBLite,
      '.DBF')) = false then
    Begin
      AErrorMessage := 'Last Year' + Chr(39) + 's directory "' +
        OptRec.Dir_PgmLastYr + '" does not have a VisualTax form data base'
      // 20160710 Igor
        + Chr(13) + 'See Configure | General Options | Data Directories';
      if AShowMessage then // 20160516 Igor
        ShowMessage(AErrorMessage);
      Exit;
    End
    else
    Begin
      // if MessageDlg('Last year form''s database have old format.'+#13#10+
      // 'Create a copy of the database in the new format?',
      // mtConfirmation,[mbYes,mbNo],0) <> mrYes then exit;
      //
      // if not ConvertOneTable(OptRec.Dir_PgmLastYr+'\'+ChangeFileExt(FormsScrDBLite,'.DBF'),
      // OptRec.Dir_PgmLastYr+'\'+FormsScrDBLite,'') then
      // Begin
      // ShowMessage('Can''t convert forms database.');
      // exit;
      // End;
    End;
  End;
  // 20110303
  LastYearPgm := AppName + IntToStr(StrToInt(AppYear) - 1) + '.EXE';
  LastYearBpl := 'vt' + AppName + '_' + IntToStr(StrToInt(AppYear) - 1)
    + '.bpl';
  If not FileExists(OptRec.Dir_PgmLastYr + '\' + LastYearPgm) AND
    not FileExists(OptRec.Dir_PgmLastYr + '\..\' + LastYearBpl) then
  // 20161110 Igor
  Begin
    AErrorMessage := 'Last Year' + Chr(39) + 's directory "' +
      OptRec.Dir_PgmLastYr + '" does not have a VisualTax system files'
    // 20160710 Igor
      + Chr(13) + 'See Configure | General Options | Data Directories';
    if AShowMessage then // 20160516 Igor
      ShowMessage(AErrorMessage);
    Exit;
  End;
  // all tests passed
  Result := true;
end;

function isValidLastYearDataFolder(AShowMessage: Boolean;
  out AErrorMessage: String): Boolean; // 20160311 Igor //20160516 Igor
Begin
  AErrorMessage := '';
  Result := false;
  If OptRec.Dir_LastYr = '' then
  begin
    AErrorMessage :=
      'You should first enter the data directory you used last year' + Chr(13) +
      'See Configure | General Options | Data Directories';
    if AShowMessage then
      ShowMessage(AErrorMessage);
    Exit;
  end;

  // 20160711 Igor
  If (DirectoryExists(OptRec.Dir_LastYr) = false) then
  Begin
    AErrorMessage := 'Last year data directory "' + OptRec.Dir_LastYr +
      '" does not exist.' // 20160710 Igor
      + Chr(13) + 'See Configure | General Options | Data Directories';
    if AShowMessage then // 20160516 Igor
      ShowMessage(AErrorMessage);
    Exit;
  End;

  // if ButtonInactive then exit;
  If not FileExists(OptRec.Dir_LastYr + '\' + OptRec.ClientsDBLite) then
  // 20150909 Igor
  begin
    // 20160226 Igor >>>>>>
    if not FileExists(OptRec.Dir_LastYr + '\' + ClientsTable_dbf) then
    // 20160311 Igor
    Begin
      AErrorMessage := 'Last Year' + Chr(39) + 's directory "' +
        OptRec.Dir_LastYr + '" does not have a VisualTax Client data base'
      // 20160710 Igor
        + Chr(13) + 'See Configure | General Options | Data Directories';
      if AShowMessage then
        ShowMessage(AErrorMessage);
      Exit;
    End;
    // 20160226 Igor <<<<<<<
  end;
  Result := true;
End;

Procedure GetFormDataFromDisk(FlName: String; FrmNm: String;
  Var FrmDataList: TStringList);
// data list is image of disk file
Var
  i, j: integer;
  elm: String;
  WList: TStringList;
  Rec, Valu: String;
  FullDataList: TStringList;
begin
  If FileExists(FlName) = false then
  begin
    ShowMessage(FlName + 'not found');
    Exit;
  End;
  FullDataList := TStringList.Create;
  FullDataList.LoadFromFile(FlName);
  Try
    j := 0;
    FrmDataList.Clear;
    If LeftStr(FullDataList[0], 2) <> 'T1' then
      Exit;
    WList := TStringList.Create;
    For i := 1 to FullDataList.Count - 1 do
    begin
      Rec := FullDataList[i];
      ParseWords(Rec + Delimiter, Delimiter, WList);
      If (WList[0] = 'F') and (WList[1] = FrmNm) then // found frm record
      begin
        For j := i + 1 to FullDataList.Count - 1 do
        begin
          Rec := FullDataList[j];
          ParseWords(Rec + Delimiter, Delimiter, WList);
          If (LeftStr(Rec, 2) = 'F' + Delimiter) or (j > FullDataList.Count - 1)
          then
            Exit; // 20110221
          If (WList[0] = 'D') then
          begin
            elm := WList[1];
            Valu := WList[2];
            FrmDataList.Add(PaddR(elm, 3) + Valu);
          end;
        end;
      end; // frm found
    end; // i
  except
    ShowMessage(Rec);
  end; // try
  FullDataList.Free;
end;

Function GetFNameFromLastYearFName(LastYrFName: String): String;
Var
  TempList: TStringList;
  i: integer;
  FInst: String;
begin
  Result := LastYrFName;
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir + '\' + 'Substit.d');
  FInst := ExtractFormInst(LastYrFName);
  LastYrFName := ExtractNonInstFormName(LastYrFName);
  For i := 0 to TempList.Count - 1 do
    If UpperCase(LastYrFName) = AllTrim(UpperCase(MidStr(TempList[i], 14, 12)))
    then
    begin
      Result := UpperCase(AllTrim(LeftStr(TempList[i], 12)));
      Result := Result + FInst;
      TempList.Free;
      Exit;
    end;
  TempList.Free;
end;

Function GetLastYearFNameFromCurrentFName(FName: String): String;
Var
  TempList: TStringList;
  i: integer;
  FInst: String;
begin
  Result := FName;
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir + '\' + 'Substit.d');
  FInst := ExtractFormInst(FName);
  FName := ExtractNonInstFormName(FName);
  For i := 0 to TempList.Count - 1 do
    If UpperCase(FName) = AllTrim(UpperCase(LeftStr(TempList[i], 12))) then
    begin
      Result := UpperCase(AllTrim(MidStr(TempList[i], 14, 12)));
      Result := Result + FInst;
      TempList.Free;
      Exit;
    end;
  TempList.Free;
end;

function GetNodeByText(ATree: TTreeView; AValue: String; AVisible: Boolean)
  : TTreeNode;
var
  Node: TTreeNode;
begin
  Result := nil;
  if ATree.Items.Count = 0 then
    Exit;
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

Function GetLastYearFormMxPg(FormName: string): integer; // 20111125
begin
  Result := FLastYearList.ByFormName(FormName).FormMxPg;
end;

Function HasDeceasedSpouse(RetNo: integer): Boolean;
begin
  Result := false;
  If LeftStr(FetchElm(RetNo, 'INFO', 65), 4) = AppYear then
    Result := true; // 20120423

end;

Procedure StoreBeforeAfterOptimize(RetNo: integer);
Var
  FNo, SpRetNo: integer;
  Bfr, After, Saving: Real;
begin
  FNo := GetFormNo('OPTIMIZE'); // 20110420
  StoreElm(RetNo, FNo, 76, ''); // falily total
  StoreElm(RetNo, FNo, 77, ''); // savings
  SpRetNo := GetSpRetNo(RetNo);
  If SpRetNo = 0 then
    Exit;
  FNo := GetFormNo('OPTIMIZE');
  If FNo > 0 then
  Begin
    Bfr := VL(FetchElmFNo(RetNo, FNo, 75));
    If Bfr = 0 then
      Exit;
    After := ExtractFamilyTotal(RetNo, SpRetNo);
    StoreElm(RetNo, FNo, 76, FormatFloat('#######.##', After));
    Saving := Bfr - After;
    StoreElm(RetNo, FNo, 77, FormatFloat('#######.##', Saving));
  end;
end;

Function ValidTaxShelterNo(Taxshelter: String): Boolean;
Var
  i: integer;
begin
  Result := true;
  If Taxshelter = '' then
    Exit;
  If Length(Taxshelter) <> 8 then
  begin
    Result := false;
    Exit;
  end;
  If Numeric(LeftStr(Taxshelter, 1)) then
  begin
    Result := false;
    Exit;
  end; // alpha
  If Numeric(MidStr(Taxshelter, 2, 1)) then
  begin
    Result := false;
    Exit;
  end; // alpha

  For i := 3 to 8 do
  begin
    If Numeric(MidStr(Taxshelter, i, 1)) = false then
    begin
      Result := false;
      Exit;
    end;
  end;
end;

Function ValidPartnershipNo(S: String): Boolean;
Var
  i: integer;
begin
  Result := true;
  If S = '' then
    Exit;
  If Length(S) <> 9 then
  begin
    Result := false;
    Exit;
  end;
  For i := 1 to 9 do
  begin
    If Numeric(MidStr(S, i, 1)) = false then
    begin
      Result := false;
      Exit;
    end;
  end;
end;

Procedure CheckBeforeEfile(RetNo: integer);
Var
  OnLineNo, Password, url, NetFileDir: String;
Begin

  (*
    ShowMessage('CRA will open up Efile On-line (EOL) on Feb 15, 2010'+
    Chr(13)+'DO NOT transmit until then');
  *)
  If (OptRec.Prp_Name = '') or (OptRec.Prp_Street = '') then
  begin
    ShowMessage
      ('Please Enter Preparer Name/Address in Configure -> General Options -> Preparer');
    Exit;
  end;

  If LicenseLevel = llLimited then // 20090125
  begin
    ShowMessage('Efile not available in the Limited version');
    Exit;
  end;

  RetNo := GetCurrentRetNo;

  If RetNo = 0 then
    Exit; // 20101218

  If RY = 1 then
  begin
    ShowMessage('You are in tax planner mode. You cannot Efile it');
    Exit;
  end;

  GetEOLParms(OnLineNo, Password, url, NetFileDir);
  If Length(OnLineNo) <> 5 then
  begin
    ShowMessage
      ('Efiler number not entered correctly. Please complete the Efile Online Setup');
    MainFormT1.SetupEOL1Click(Application); // 20111208 instead of sender
    Exit;
  end;

  {
    //20170527
    If IsCanadianProvince(FetchElm(RetNo,'INFO',14))=False then
    Begin
    ShowMessage('Taxpaper Address Postal Code is outside Canada'+
    Chr(13)+'It cannot be efiled');
    Exit;
    end;
  }
  If UpperCase(OnLineNo) <> UpperCase(LeftStr(FetchElm(RetNo, 'T183', 21), 5))
  then
  begin
    // 20210305
    ShowMessage('There may be errors that need to be fixed (Audit Wizard)' +
      Chr(13) + 'OR' +
      ' the T183 has different Efiler no on Box D than your EflieOnLine-> SetUp EOL'
      + Chr(13) + 'OR' + Chr(13) + 'Press the Make New DCN button' + Chr(13) +
      'OR' + Chr(13) + 'the return has been already submitted and accepted');
    OpenForm(RetNo, 'T183', 21);
    Exit;
  end;

  RecalcEverything(RetNo);
  Calc(RetNo, 'T183');

  If IsEFiledReturn(RetNo) = false then
  begin
    ShowTimedMsg('Return NOT set for Efiling', 1700);
    OpenForm(RetNo, 'INFO', 46);
    Exit;
  end;

  If Ret[RetNo].EfStatus = '02' then
  begin
    ShowTimedMsg('Return has been already accepted by EFile', 1700);
    Exit;
  end;

  If Ret[RetNo].EfStatus = '04' then
  begin
    ShowTimedMsg('Return submitted already and waiting Acknowledgement', 1500);
    Exit;
  end;

  // StartEOL;
  // If ButtonInactive then exit;
  If MainFormT1.EditBeforeSave(RetNo) = false then
    Exit;
  If Ret[RetNo].SeriousErrorCount > 0 then
  begin
    ShowMessage('Return has important ommissions. Fix before Efiling');
    // exit;
  end;

  If Not IsReadyForEfile(RetNo) then
  begin
    ShowMessage
      ('Not ready for Efiling. See error(s) on the Audit -> Efile-cannot Efile section');
    // 2024030
    Exit;
  end;

  If (CountCropEntries(RetNo, '#1') > 10) then
  begin
    ShowMessage
      ('T1273 Crop Inventory entries exceed 10. You must use Efile on-line Plus');
    Exit;
  end;

  If (CountLiveStockEntries(RetNo, '#1') > 10) then
  begin
    ShowMessage
      ('T1273 LiveStock Inventory entries exceed 10. You must use Efile on-line Plus');
    Exit;
  end;

End;

Function GetLine351ForEfile(RetNo: integer): Real; // adjusted sp income  35100?
Begin
  // 20121227
  Result := VL(FetchElm(RetNo, 'S2', 17)); // spouse adj inc

  If (VL(FetchElm(RetNo, 'S2', 19)) > 0) // xfer
    and (VL(FetchElm(RetNo, 'S2', 17)) = 0) // adjusted
  then
    Result := 1;

  // 20120309
  If VL(FetchElm(RetNo, 'S2PRV', 19)) > 0 then
  begin
    Result := VL(FetchElm(RetNo, 'S2', 17)); // spouse adj inc
    If Result = 0 then
      Result := 1;
  end;
  If (VL(FetchElm(RetNo, 'S2', 19)) = 0) and
    (VL(FetchElm(RetNo, 'S2PRV', 19)) = 0) then
    Result := 0; // 20130104
end;

Function GetLine5532ForEfile(RetNo: integer): Real; // wib income
Var
  i, FNo: integer;
  Adj, TotalNet, S6Income: Real;
  k: integer;
Begin
  // 20130109
  Result := 0;
  If Ret[RetNo].Lnn[45300] = 0 then
  begin
    Result := 0;
    Exit;
  End;
  /// check for neg income adjustment
  // EXIT;     //20130109  //20140520

  FNo := GetFormNo('BUSSUM');

  k := 0;
  Adj := 0;
  TotalNet := Ret[RetNo].Lnn[13500] + Ret[RetNo].Lnn[13700] + Ret[RetNo].Lnn
    [13900] + Ret[RetNo].Lnn[14100] + Ret[RetNo].Lnn[14300];
  S6Income := VL(FetchElm(RetNo, 'S6', 9));
  if Ret[RetNo].Province = 'QC' then
    S6Income := VL(FetchElm(RetNo, 'S6QC', 9)); // 20171205

  If TotalNet < 0 then
    TotalNet := 0; // 20140520
  Adj := ABS(S6Income - TotalNet);
  Result := Adj;
end;

Function ChangeAckToXmlExtension(FlName: String): String; // 20120117
Begin
  Result := ChangeFileExt(FlName, '.XML');
end;

Function FormatNoDecimals(S: String; How: integer): string; // 20120123
Var
  x: Real;
Begin
  Try
    S := LTrim(S);
    x := Round(VL(S));
    Result := FormatFloat('###,###,###', x);
  except
    on E: Exception do
      ExceptMsg(E); // MessageDlg(E.Message, mtError, [mbok], 0);
  end;
end;

Function isT1273NoDecimalSection(FName: String; elm: integer): Boolean;
// 20120123
Var
  i: integer;
begin
  Result := false;
  If LeftStr(FName, 6) <> 'T1273#' then
    Exit;
  Result := false;
  i := 1007;
  Repeat
    If i = elm then
    begin
      Result := true;
      Exit;
    end;
    inc(i, 3);
  until i > 1028;

  i := 1031;
  Repeat
    If i = elm then
    begin
      Result := true;
      Exit;
    end;
    inc(i, 3);
  until i > 1052;

  i := 1055;
  Repeat
    If i = elm then
    begin
      Result := true;
      Exit;
    end;
    inc(i, 3);
  until i > 1076;
end;

Procedure ShowClientPhotoId(FlName: String);
Var
  S: String;
  h: THandle;
Begin
  {
    If FileExists(FlName) = false then
    begin
    ShowMessage('No documents found');
    Exit;
    End;
  }
  h := ShellExecute(Application.MainForm.Handle, Nil, PChar('' + FlName), Nil,
    '', SW_RESTORE);
  If h <= 32 then
    ShowMessage('The client Photo Id was not found');
end;

Function HasVtScanLicense: Boolean;
begin
 Result := AppT1_2026.ScanLicenseLevel > llNone;
end;

Function GetMonthsForPensionSplit(RetNo1, RetNo2: integer): integer;
Var
  Dt1, dt2: String; // death date for each  RetNo2 is the transferee
begin
  Result := 12;
  Dt1 := FetchElm(RetNo1, 'INFO', 24);
  dt2 := FetchElm(RetNo2, 'INFO', 24);
  If dt2 > '' then
  begin
    Result := MyStrToInt(MidStr(dt2, 6, 2));
    Exit;
  End;
  // If (Dt1>'') and (Dt1>Dt2) then begin Result:=MyStrToInt(MidStr(Dt1,6,1));Exit;End; //pensiner died before spouse
end;

Function GetMonthsMarried(RetNo1, RetNo2: integer): integer;
Var
  Dt1, dt2: String;
  Month1, Month2: integer; // death date for each
begin
  Result := 12;
  Dt1 := FetchElm(RetNo1, 'INFO', 24);
  dt2 := FetchElm(RetNo2, 'INFO', 24);
  If (Dt1 = '') and (dt2 = '') then
    Exit;

  Month1 := MyStrToInt(MidStr(Dt1, 6, 2));
  Month2 := MyStrToInt(MidStr(dt2, 6, 2));
  If (Month1 > 0) and (Month2 > 0) then // both died
  begin
    Result := Month1;
    // If Month1<Month2 then Begin result:=Month1;Exit;End;
    // If Month1>Month2 then Begin result:=Month1;Exit;End;
  end;
  If (Month1 > 0) and (Month1 > Month2) then
    Result := Month1;
end;

Function GetPhotoIdFlName(RetNo: integer): String;
var
  S: String;
begin
  // s:=OptRec.Dir_PermanentDocs + '\' + GetLastName(RetNo) + ',' + GetFirstName(RetNo) + '\Photo Id.bmp';
  // 20250527 Igor >>>
  Result:= OptRec.Dir_PermanentDocs + '\' + GetLastName(RetNo) + ',' + GetFirstName(RetNo) + '\Photo Id.bmp'; // 20250203

  if not FileExists(Result) then
    Result:= OptRec.Dir_ClientDocs + '\' + GetLastName(RetNo) + ',' + GetFirstName(RetNo) + '\Photo Id.bmp';
  // 20250527 Igor <<<
end;

Procedure RotateImage(SrcFile: string; CCW: integer);
var
  x, Y: integer;
  Src, Dst: TImage;
  BitM: TBitmap;
begin
  If FileExists(SrcFile) then
  begin
    Src := TImage.Create(nil);
    Src.Picture.LoadFromFile(SrcFile);
    Src.AutoSize := true;
  end
  else
  begin
    Exit;
  end;

  Dst := TImage.Create(nil);
  Dst.width := Src.Height;
  Dst.Height := Src.width;

  if Src.Picture.Bitmap = nil then
  begin
    BitM := TBitmap.Create;
    BitM.assign(TBitmap(Src.Picture.Graphic));
    Src.Picture.Bitmap.assign(BitM);
  end;

  if CCW = 0 then // clockwise rotate
    for x := 0 to Src.Height do
      for Y := 0 to Src.width do
        Dst.Canvas.Pixels[x, Y] := Src.Canvas.Pixels[Y, Src.Height - x - 1];
  if CCW = 1 then // counter-clockwise rotate
    for x := 0 to Src.Height do
      for Y := 0 to Src.width do
        Dst.Canvas.Pixels[x, Y] := Src.Canvas.Pixels[Src.width - Y - 1, x];
  Src.Picture.Bitmap := Dst.Picture.Bitmap;
  // Src.Picture.savetofile(appdir + '\testPicture.bmp');
  Src.Picture.SaveToFile(SrcFile);
  Dst.Free;
  Src.Free;
end;

// 20160523 Igor Move to vtTrimStr
// Function ReplaceReservedXMLCharacters(s:String):String;    //20120209
// Const k=60;
// begin
// s:=LeftStr(AllTrim(s),40);   //20121217
// //s:=LeftStr(AllTrim(s),30);
// If Length(s) <k then s :=StringReplace(s,'&','&amp;', [rfReplaceAll]);  //MUST BE FIRST
// If Length(s) <k then s :=StringReplace(s,'"','&quot;', [rfReplaceAll]);
// If Length(s) <k then s :=StringReplace(s,'''','&apos;', [rfReplaceAll]);
// If Length(s) <k then s :=StringReplace(s,'<','&lt;', [rfReplaceAll]);
// If Length(s) <k then s :=StringReplace(s,'>','&gt;', [rfReplaceAll]);
// result := AllTrim(s); //LeftStr(AllTrim(s),30);  //20120213
// end;
//
Function isCanadianProvince(PRV: String): Boolean;
Var
  i: integer;
Begin
  Result := true;
  If UpperCase(PRV) = 'ZZ' then
  begin
    Result := false;
    Exit;
  end; // 20120315
  PRV := UpperCase(AllTrim(PRV));
  For i := Low(PrvShort) to High(PrvShort) do
  begin
    If PRV = PrvShort[i] then
    begin
      Result := true;
      Exit;
    end;
  end;
  Result := false;
end;

Function ValidPhone(S: String): Boolean;
begin
  Result := true;
  If Length(S) > 8 then
  begin
    Result := false;
    Exit;
  End;
  S := ReplaceChar(S, '-', '');
  S := ReplaceChar(S, ' ', '');
  If Length(S) <> 7 then
    Result := false;
  If Numeric(S) = false then
    Result := false;
end;

Function ValidateT1135Phone(S: String): Boolean; // 20220209
var
  i, j, k: integer;
begin
  Result := false;
  k := Length(S);
  if Not Numeric(MidStr(S, 1, 1)) then
    Exit;
  if MidStr(S, 2, 1) <> '(' then
    Exit;
  if MidStr(S, 6, 1) <> ')' then
    Exit;
  if MidStr(S, 10, 1) <> '-' then
    Exit;
  if k < 14 then
    Exit;

  for i := 0 to k do
  Begin
    if (MidStr(S, i, 1) = '0') or (MidStr(S, i, 1) = '1') or
      (MidStr(S, i, 1) = '2') or (MidStr(S, i, 1) = '3') or
      (MidStr(S, i, 1) = '4') or (MidStr(S, i, 1) = '5') or
      (MidStr(S, i, 1) = '6') or (MidStr(S, i, 1) = '7') or
      (MidStr(S, i, 1) = '8') or (MidStr(S, i, 1) = '9') or
      (MidStr(S, i, 1) = '(') or (MidStr(S, i, 1) = ')') or
      (MidStr(S, i, 1) = 'x') or (MidStr(S, i, 1) = 'X') or
      (MidStr(S, i, 1) = '-') or (MidStr(S, i, 1) = '.') then
      Result := true;
  End;
  {
    Result := True;
    If Length(S) > 8 then
    begin
    Result := false;
    exit;
    End;
    S := ReplaceChar(S, '-', '');
    S := ReplaceChar(S, ' ', '');
    If Length(S) <> 7 then
    Result := false;
    If Numeric(S) = false then
    Result := false;
  }
end;

Function CalcLn433(RetNo: integer): Real;
Var
  ForIncFNo: integer;
begin
  Result := 0;
  ForIncFNo := GetFormNo('FORINC');
  // 20130315
  Result := VL(FetchElmFNo(RetNo, ForIncFNo, 157)) +
    VL(FetchElmFNo(RetNo, ForIncFNo, 159)) +
    VL(FetchElmFNo(RetNo, ForIncFNo, 161)); // 20120402 //20120314
  // 20130301
  If VL(FetchElmFNo(RetNo, ForIncFNo, 158)) +
    VL(FetchElmFNo(RetNo, ForIncFNo, 160)) +
    VL(FetchElmFNo(RetNo, ForIncFNo, 162)) = 0 then
    Result := 0;
  {
    result:=Round(Vl(FetchElmFNo(RetNo,FORINCFNo,157)))+Round(Vl(FetchElmFNo(RetNo,FORINCFNo,159)))+Round(Vl(FetchElmFNo(RetNo,FORINCFNo,161))); //20120402 //20120314
    //20130301
    If Round(Vl(FetchElmFNo(RetNo,FORINCFNo,158)))+Round(Vl(FetchElmFNo(RetNo,FORINCFNo,160)))+Round(Vl(FetchElmFNo(RetNo,FORINCFNo,162)))=0 then
    result:=0;
  }
end;

Function CalcLn431(RetNo: integer): Real;
Var
  ForIncFNo: integer;
begin
  Result := 0;
  ForIncFNo := GetFormNo('FORINC');

  If (VL(FetchElmFNo(RetNo, ForIncFNo, 157)) > 0) and
    (VL(FetchElmFNo(RetNo, ForIncFNo, 158)) > 0) then
    Result := Result + VL(FetchElmFNo(RetNo, ForIncFNo, 158));
  If (VL(FetchElmFNo(RetNo, ForIncFNo, 159)) > 0) and
    (VL(FetchElmFNo(RetNo, ForIncFNo, 160)) > 0) then
    Result := Result + VL(FetchElmFNo(RetNo, ForIncFNo, 160));
  If (VL(FetchElmFNo(RetNo, ForIncFNo, 161)) > 0) and
    (VL(FetchElmFNo(RetNo, ForIncFNo, 162)) > 0) then
    Result := Result + VL(FetchElmFNo(RetNo, ForIncFNo, 162));
end;

Function CalcLn434(RetNo: integer): Real; // 20121225
Var
  ForIncFNo: integer;
begin
  Result := 0;
  ForIncFNo := GetFormNo('FORINC');
  If (VL(FetchElmFNo(RetNo, ForIncFNo, 207)) > 0) and
    (VL(FetchElmFNo(RetNo, ForIncFNo, 208)) > 0) then
    Result := Result + VL(FetchElmFNo(RetNo, ForIncFNo, 208));
  If (VL(FetchElmFNo(RetNo, ForIncFNo, 209)) > 0) and
    (VL(FetchElmFNo(RetNo, ForIncFNo, 210)) > 0) then
    Result := Result + VL(FetchElmFNo(RetNo, ForIncFNo, 210));
  If (VL(FetchElmFNo(RetNo, ForIncFNo, 211)) > 0) and
    (VL(FetchElmFNo(RetNo, ForIncFNo, 212)) > 0) then
    Result := Result + VL(FetchElmFNo(RetNo, ForIncFNo, 212));
end;

Function CalcLn439(RetNo: integer): Real; // 20121225
Var
  ForIncFNo: integer;
begin
  Result := 0;
  ForIncFNo := GetFormNo('FORINC'); // for bus inc
  // 20130315
  Result := VL(FetchElmFNo(RetNo, ForIncFNo, 207)) +
    VL(FetchElmFNo(RetNo, ForIncFNo, 209)) +
    VL(FetchElmFNo(RetNo, ForIncFNo, 211));
  // result:=Round(Vl(FetchElmFNo(RetNo,FORINCFNo,207)))+Round(Vl(FetchElmFNo(RetNo,FORINCFNo,209)))+Round(Vl(FetchElmFNo(RetNo,FORINCFNo,211)));
  // 20120315
  If VL(FetchElmFNo(RetNo, ForIncFNo, 208)) +
    VL(FetchElmFNo(RetNo, ForIncFNo, 210)) +
    VL(FetchElmFNo(RetNo, ForIncFNo, 212)) = 0 then
    Result := 0;

end;

Function CalcLn5273(RetNo: integer): Real;
Var
  ForIncFNo: integer;
begin
  Result := 0;
  ForIncFNo := GetFormNo('FORINC');
  If (VL(FetchElmFNo(RetNo, ForIncFNo, 157)) > 0) and
    (VL(FetchElmFNo(RetNo, ForIncFNo, 158)) > 0) then
    Result := Result + VL(FetchElmFNo(RetNo, ForIncFNo, 157));
end;

Function CalcLn5274(RetNo: integer): Real;
Var
  ForIncFNo: integer;
begin
  Result := 0;
  ForIncFNo := GetFormNo('FORINC');
  If (VL(FetchElmFNo(RetNo, ForIncFNo, 159)) > 0) and
    (VL(FetchElmFNo(RetNo, ForIncFNo, 160)) > 0) then
    Result := Result + VL(FetchElmFNo(RetNo, ForIncFNo, 159));
end;

Function CalcLn5275(RetNo: integer): Real;
Var
  ForIncFNo: integer;
begin
  Result := 0;
  ForIncFNo := GetFormNo('FORINC');
  If (VL(FetchElmFNo(RetNo, ForIncFNo, 161)) > 0) and
    (VL(FetchElmFNo(RetNo, ForIncFNo, 162)) > 0) then
    Result := Result + VL(FetchElmFNo(RetNo, ForIncFNo, 161));
end;

Function CalcLn5277(RetNo: integer): Real; // foreign tax
Var
  ForIncFNo: integer;
begin
  Result := 0;
  ForIncFNo := GetFormNo('FORINC');
  If (VL(FetchElmFNo(RetNo, ForIncFNo, 157)) > 0) and
    (VL(FetchElmFNo(RetNo, ForIncFNo, 158)) > 0) then
    Result := Result + VL(FetchElmFNo(RetNo, ForIncFNo, 158));
end;

Function CalcLn5278(RetNo: integer): Real; // foreign tax
Var
  ForIncFNo: integer;
begin
  Result := 0;
  ForIncFNo := GetFormNo('FORINC');
  If (VL(FetchElmFNo(RetNo, ForIncFNo, 159)) > 0) and
    (VL(FetchElmFNo(RetNo, ForIncFNo, 160)) > 0) then
    Result := Result + VL(FetchElmFNo(RetNo, ForIncFNo, 160));
end;

Function CalcLn5279(RetNo: integer): Real; // foreign tax
Var
  ForIncFNo: integer;
begin
  Result := 0;
  ForIncFNo := GetFormNo('FORINC');
  If (VL(FetchElmFNo(RetNo, ForIncFNo, 161)) > 0) and
    (VL(FetchElmFNo(RetNo, ForIncFNo, 162)) > 0) then
    Result := Result + VL(FetchElmFNo(RetNo, ForIncFNo, 162));
end;

Function CalcLn5280(RetNo: integer): Real;
Var
  ForIncFNo: integer;
begin
  Result := 0;
  ForIncFNo := GetFormNo('FORINC');
  If (VL(FetchElmFNo(RetNo, ForIncFNo, 207)) > 0) and
    (VL(FetchElmFNo(RetNo, ForIncFNo, 208)) > 0) then
    Result := Result + VL(FetchElmFNo(RetNo, ForIncFNo, 207));
end;

Function CalcLn5281(RetNo: integer): Real;
Var
  ForIncFNo: integer;
begin
  Result := 0;
  ForIncFNo := GetFormNo('FORINC');
  If (VL(FetchElmFNo(RetNo, ForIncFNo, 209)) > 0) and
    (VL(FetchElmFNo(RetNo, ForIncFNo, 210)) > 0) then
    Result := Result + VL(FetchElmFNo(RetNo, ForIncFNo, 209));
end;

Function CalcLn5282(RetNo: integer): Real;
Var
  ForIncFNo: integer;
begin
  Result := 0;
  ForIncFNo := GetFormNo('FORINC');
  If (VL(FetchElmFNo(RetNo, ForIncFNo, 211)) > 0) and
    (VL(FetchElmFNo(RetNo, ForIncFNo, 212)) > 0) then
    Result := Result + VL(FetchElmFNo(RetNo, ForIncFNo, 211));
end;

Function CalcLn5276(RetNo: integer): Real; // foreign bus tax #1
Var
  ForIncFNo: integer;
begin
  Result := 0;
  ForIncFNo := GetFormNo('FORINC');
  If (VL(FetchElmFNo(RetNo, ForIncFNo, 207)) > 0) and
    (VL(FetchElmFNo(RetNo, ForIncFNo, 208)) > 0) then
    Result := Result + VL(FetchElmFNo(RetNo, ForIncFNo, 208));
end;

Function CalcLn5283(RetNo: integer): Real; // foreign bus tax #2
Var
  ForIncFNo: integer;
begin
  Result := 0;
  ForIncFNo := GetFormNo('FORINC');
  If (VL(FetchElmFNo(RetNo, ForIncFNo, 209)) > 0) and
    (VL(FetchElmFNo(RetNo, ForIncFNo, 210)) > 0) then
    Result := Result + VL(FetchElmFNo(RetNo, ForIncFNo, 210));
end;

Function CalcLn5284(RetNo: integer): Real; // foreign bus tax #1
Var
  ForIncFNo: integer;
begin
  Result := 0;
  ForIncFNo := GetFormNo('FORINC');
  If (VL(FetchElmFNo(RetNo, ForIncFNo, 211)) > 0) and
    (VL(FetchElmFNo(RetNo, ForIncFNo, 212)) > 0) then
    Result := Result + VL(FetchElmFNo(RetNo, ForIncFNo, 212));
end;

Function OntarioInvoluntarySeparation(RetNo: integer): Boolean;
Begin
  Result := false;
  // 20120324
  If FetchElm(RetNo, 'ONBEN', 31) > '' then
    Result := true;
end;

(*
  procedure ExecMethod(OnObject: TObject; MethodName: string) ;
  var
  Routine: TMethod;
  Exec: TExec;
  begin
  Routine.Data := Pointer(OnObject) ;
  Routine.Code := OnObject.MethodAddress(MethodName) ;
  if NOT Assigned(Routine.Code) then Exit;
  Exec := TExec(Routine) ;
  Exec;
  end;

*)

(*

  Execute a Delphi Method (Procedure/Function) by Name

  When you need to convert an integer to a string, you would use the IntToStr Delphi function. When you need to display a form modally you would use the ShowModal method of a form object.
  In short, functions, procedures and methods are called by their name. Ok, I know you knew that.
  What if you need to call a function by its name as a string variable value? What if you need to use a code like:

  ExecMethod(Form1, 'ShowModal');

  type
  TForm1 = class(TForm)
  Button1: TButton;
  procedure Button1Click(Sender: TObject) ;
  procedure CallMeByName(Sender: TObject) ;
  private
  procedure ExecMethod(OnObject: TObject; MethodName: string) ;
  end;

  var
  Form1: TForm1;

  type
  TExec = procedure of object;

  procedure TForm1.ExecMethod(OnObject: TObject; MethodName: string) ;
  var
  Routine: TMethod;
  Exec: TExec;
  begin
  Routine.Data := Pointer(OnObject) ;
  Routine.Code := OnObject.MethodAddress(MethodName) ;
  if NOT Assigned(Routine.Code) then Exit;
  Exec := TExec(Routine) ;
  Exec;
  end;

  procedure TForm1.CallMeByName(Sender: TObject) ;
  begin
  ShowMessage('Hello Delphi!') ;
  end;

  procedure TForm1.Button1Click(Sender: TObject) ;
  begin
  ExecMethod(Form1, 'CallMeByName') ;
  end;
  ---------------------------------------------
*)

(*
  Delphi methods by name
  by Jan Verhoeven, 15 November 2002


  In Delphi you can call published methods by name.

  function TPascalServerF.ExecProc(MyProcStr : String):boolean;
  Var
  MyProc : procedure of object;
  Begin
  TMethod(myProc).data:=self;
  TMethod(MyProc).code :=MethodAddress(MyProcStr);
  result:=true;
  if not Assigned(MyProc) Then
  result:=false
  else
  MyProc;
  end;

  The example code above is from my PascalServer program where I use a Pascal Script Interpreter that generates an event each time an unknown identifier is encountered, allowing you to respond with you own code.
  Because I wanted to avoid a lengthy sequence of if.. else statements, I needed a way to call a method from the identifier name. The function listed above does exactly that.

  Published methods
  The method presented only works with published procedures and functions.

  Access Errors
  Originally I did not use a procedure of object but just procedure and did not bother about allocating the implicit self. This seemed to work, untill I started calling other methods from within the published method. Delphi was expecting a self pointer which was not there and generated an access error.
  -------------------------------

  See also:
  http://objectmix.com/delphi/402039-how-call-instance-method-name-runtime.html

*)

(* http://www.swissdelphicenter.ch/en/showcode.php?id=2201
  Procedure FtPDownload;
  {
  The following function shows how to connect to a ftp server
  and download a file.
  It uses the functions from wininet.dll.

  You need a ProgressBar to show the progress and a Label to show progress informations.
  }

  uses WinInet,ComCtrls;

  function FtpDownloadFile(strHost, strUser, strPwd: string;
  Port: Integer; ftpDir, ftpFile, TargetFile: string; ProgressBar: TProgressBar): Boolean;

  function FmtFileSize(Size: Integer): string;
  begin
  if Size >= $F4240 then
  Result := Format('%.2f', [Size / $F4240]) + ' Mb'
  else
  if Size < 1000 then
  Result := IntToStr(Size) + ' bytes'
  else
  Result := Format('%.2f', [Size / 1000]) + ' Kb';
  end;

  const
  READ_BUFFERSIZE = 4096;  // or 256, 512, ...
  var
  hNet, hFTP, hFile: HINTERNET;
  buffer: array[0..READ_BUFFERSIZE - 1] of Char;
  bufsize, dwBytesRead, fileSize: DWORD;
  sRec: TWin32FindData;
  strStatus: string;
  LocalFile: file;
  bSuccess: Boolean;
  begin
  Result := False;

  { Open an internet session }
  hNet := InternetOpen('Program_Name', // Agent
  INTERNET_OPEN_TYPE_PRECONFIG, // AccessType
  nil,  // ProxyName
  nil, // ProxyBypass
  0); // or INTERNET_FLAG_ASYNC / INTERNET_FLAG_OFFLINE

  {
  Agent contains the name of the application or
  entity calling the Internet functions
  }


  { See if connection handle is valid }
  if hNet = nil then
  begin
  ShowMessage('Unable to get access to WinInet.Dll');
  Exit;
  end;

  { Connect to the FTP Server }
  hFTP := InternetConnect(hNet, // Handle from InternetOpen
  PChar(strHost), // FTP server
  port, // (INTERNET_DEFAULT_FTP_PORT),
  PChar(StrUser), // username
  PChar(strPwd),  // password
  INTERNET_SERVICE_FTP, // FTP, HTTP, or Gopher?
  0, // flag: 0 or INTERNET_FLAG_PASSIVE
  0);// User defined number for callback

  if hFTP = nil then
  begin
  InternetCloseHandle(hNet);
  ShowMessage(Format('Host "%s" is not available',[strHost]));
  Exit;
  end;

  { Change directory }
  bSuccess := FtpSetCurrentDirectory(hFTP, PChar(ftpDir));

  if not bSuccess then
  begin
  InternetCloseHandle(hFTP);
  InternetCloseHandle(hNet);
  ShowMessage(Format('Cannot set directory to %s.',[ftpDir]));
  Exit;
  end;

  { Read size of file }
  if FtpFindFirstFile(hFTP, PChar(ftpFile), sRec, 0, 0) <> nil then
  begin
  fileSize := sRec.nFileSizeLow;
  // fileLastWritetime := sRec.lastWriteTime
  end else
  begin
  InternetCloseHandle(hFTP);
  InternetCloseHandle(hNet);
  ShowMessage(Format('Cannot find file ',[ftpFile]));
  Exit;
  end;

  { Open the file }
  hFile := FtpOpenFile(hFTP, // Handle to the ftp session
  PChar(ftpFile), // filename
  GENERIC_READ, // dwAccess
  FTP_TRANSFER_TYPE_BINARY, // dwFlags
  0); // This is the context used for callbacks.

  if hFile = nil then
  begin
  InternetCloseHandle(hFTP);
  InternetCloseHandle(hNet);
  Exit;
  end;

  { Create a new local file }
  AssignFile(LocalFile, TargetFile);
  {$i-}
  Rewrite(LocalFile, 1);
  {$i+}

  if IOResult <> 0 then
  begin
  InternetCloseHandle(hFile);
  InternetCloseHandle(hFTP);
  InternetCloseHandle(hNet);
  Exit;
  end;

  dwBytesRead := 0;
  bufsize := READ_BUFFERSIZE;

  while (bufsize > 0) do
  begin
  Application.ProcessMessages;

  if not InternetReadFile(hFile,
  @buffer, // address of a buffer that receives the data
  READ_BUFFERSIZE, // number of bytes to read from the file
  bufsize) then Break; // receives the actual number of bytes read

  if (bufsize > 0) and (bufsize <= READ_BUFFERSIZE) then
  BlockWrite(LocalFile, buffer, bufsize);
  dwBytesRead := dwBytesRead + bufsize;

  { Show Progress }
  ProgressBar.Position := Round(dwBytesRead * 100 / fileSize);
  Form1.Label1.Caption := Format('%s of %s / %d %%',[FmtFileSize(dwBytesRead),FmtFileSize(fileSize) ,ProgressBar.Position]);
  end;

  CloseFile(LocalFile);

  InternetCloseHandle(hFile);
  InternetCloseHandle(hFTP);
  InternetCloseHandle(hNet);
  Result := True;
  end;
*)

(*
  Procedure FtpUpload;
  procedure UploadPerFTP;
  procedure GetDir(dir: string);
  var
  SearchRec: TSearchRec;
  details, nodetails: TStringList;
  k: Integer;
  begin
  //iterate through directory given
  //schleife über alle dateien im ordner
  if FindFirst(dir + '*.*', faAnyFile, SearchRec) = 0 then
  begin
  repeat

  //get rid of the both "dummy-directories" '.' and '..'
  //die ordner '.' und '..' brauchen man nicht
  if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
  begin
  //if we found a folder
  //falls wir einen ordner haben
  if (SearchRec.Attr and faDirectory) = faDirectory then
  begin
  //get folder contents from ftp. one with details, one without
  //holen wir uns den ordnerinhalt mit details und einmal ohne vom server
  details   := TStringList.Create;
  nodetails := TStringList.Create;
  FTPClient.List(details, '', True);
  FTPClient.List(nodetails, '', False);

  //we only want to have directories in the list (without '.' and '..')
  //nun filtern wir das nach den ordnern (ohne '.' und '..')
  for k := details.Count - 1 downto 0 do
  begin
  if details.Strings[k] <> '' then
  begin
  if (details.Strings[k][1] <> 'd') or
  (nodetails.Strings[k] = '.') or
  (nodetails.Strings[k] = '..') then
  begin
  details.Delete(k);
  nodetails.Delete(k);
  end;
  end;
  end;

  //if our directory does not exist on the server, create it
  //falls unser ordner auf dem server noch nicht existiert, legen wir ihn an
  if nodetails.IndexOf(SearchRec.Name) = -1 then
  begin
  FTPClient.MakeDir(SearchRec.Name);
  end;

  //change into next directory on server
  //nun wechseln wir in den nächsten ordner
  FTPClient.ChangeDir(SearchRec.Name);
  details.Free;
  nodetails.Free;

  //and also locally go into the next subfolder
  //und suchen lokal im nächsten unterordner weiter
  GetDir(dir + SearchRec.Name + '\');

  //we have to go one directory up after leaving the recursion
  //wenn die rekursion zurück ist, müssen wir wieder eine ordnerstufe hochgehen
  FTPClient.ChangeDirUp;
  end
  else
  begin
  //if it's only a file, upload it to the current directory
  //falls wir eine datei angetroffen haben, können wir diese uploaden
  FTPClient.Put(dir + SearchRec.Name, SearchRec.Name);
  end;
  end;
  until FindNext(SearchRec) <> 0;
  FindClose(SearchRec);
  end;
  end;
  var
  dir: string;
  details, nodetails: TStringList;
  k: Integer;
  begin
  //set some basic settings on your ftp client (TIdFTPClient)
  //hier kommen die grundangaben für unseren ftp client hin (TIdFTPClient)
  with FTPClient do
  begin
  Host     := 'your_server.com';            // Adjust your data here / Hier gwünschte Daten eintragen
  Username := 'your_username';
  // Adjust your data here / Hier gwünschte Daten eintragen
  Password := 'your_password';
  // Adjust your data here / Hier gwünschte Daten eintragen
  Passive := True;                      // Adjust your data here / Hier gwünschte Daten eintragen
  end;
  FTPClient.Connect;

  //if you want to upload you data to an remote-directory, enter it below (does not matter if 'dir\dir' or 'dir/dir')
  //falls die daten in ein remote-directory heraufgeladen werden sollen, kann es hier angegeben werden (egal ob 'dir\dir' oder 'dir/dir')
  dir := StringReplace('your/remote_directory', '\', '/', [rfReplaceAll]);
  // Adjust your data here / Hier gwünschte Daten eintragen

  //remove first '/' if there's one
  //wir löschen das erste '/', falls eines existiert
  if dir <> '' then
  begin
  if dir[1] = '/' then Delete(dir, 1, 1);

  //but add a '/' at the end
  //aber am ende fügen wir ein '/' hinzu
  if dir[Length(dir)] <> '/' then dir := dir + '/';

  //loop through our remote-directories
  //schleife über alle remote-directories
  while Pos('/', dir) > 0 do
  begin
  //get folder contents from ftp. one with details, one without
  //runterladen der aktuellen ordnerinhalte vom server (mit und ohne details)
  details   := TStringList.Create;
  nodetails := TStringList.Create;
  FTPClient.List(details, '', True);
  FTPClient.List(nodetails, '', False);

  //we only want to have directories in the list (without '.' and '..')
  //wir wollen wieder nur ordner ohne '.' und '..'
  for k := details.Count - 1 downto 0 do
  begin
  if details.Strings[k] <> '' then
  begin
  if (details.Strings[k][1] <> 'd') or
  (nodetails.Strings[k] = '.') or
  (nodetails.Strings[k] = '..') then
  begin
  details.Delete(k);
  nodetails.Delete(k);
  end;
  end;
  end;

  //if our directory does not exist on the server, create it
  //falls der ordner nicht existiert, legen wir ihn an
  if nodetails.IndexOf(Copy(dir, 1, Pos('/', dir) - 1)) = -1 then
  begin
  FTPClient.MakeDir(Copy(dir, 1, Pos('/', dir) - 1));
  end;

  //change to our directory on server
  //nun wechseln wir in den nächsten ordner auf dem server
  FTPClient.ChangeDir(Copy(dir, 1, Pos('/', dir) - 1));

  //remove first directory from path ('your/directory/subdir/' --> 'directory/subdir/')
  //wir schneiden den ersten ordner vom pfad ab ('dein/ordner/unterordner/' --> 'ordner/unterordner/')
  Delete(dir, 1, Pos('/', dir));
  details.Free;
  nodetails.Free;
  end;
  end;

  //ftp client is ready in your remote-directory
  //begin to upload our local directory
  //der ftp client ist nun im remote-directory bereit
  //wür können anfangen unseren lokalen ordner raufzuladen
  dir := 'C:\your\local\directory\';
  // Adjust your data here / Hier gwünschte Daten eintragen
  if dir[Length(dir)] <> '\' then dir := dir + '\';
  GetDir(dir);
  FTPClient.Disconnect;
  end;
*)

(*
  function CombineFiles(FileName, CombinedFileName : TFileName) : Boolean;
  var
  i: integer;
  fs, sStream: TFileStream;
  filenameOrg: String;
  begin
  i := 1;
  fs := TFileStream.Create(CombinedFileName, fmCreate or fmShareExclusive);
  try
  while FileExists(FileName) do
  begin
  sStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
  fs.CopyFrom(sStream, 0);
  finally
  sStream.Free;
  end;
  Inc(i);
  FileName := ChangeFileExt(FileName, '.'+ FormatFloat('000', i));
  end;

  finally
  fs.Free;
  end;
  end;
*)
(*
  function CombineFiles(FileName, CombinedFileName : TFileName) : Boolean;
  var i: integer;
  fs, sStream: TFileStream;
  filenameOrg: String;
  begin
  i := 1;
  fs := TFileStream.Create(CombinedFileName, fmCreate or fmShareExclusive);
  try while FileExists(FileName) do
  begin
  sStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
  fs.CopyFrom(sStream, 0);
  finally
  sStream.Free;
  DeleteFile(FileName);
  end;
  Inc(i);
  FileName := ChangeFileExt(FileName, '.'+ FormatFloat('000', i));
  end;
  finally
  fs.Free;
  end;
  end;
*)

(*
  function CombineFiles(FileName, CombinedFileName : TFileName;cbdel:tcheckbox) : Boolean;
  var
  i: integer;
  fs, sStream: TFileStream;
  filenameOrg: String;
  begin
  i := 1;
  fs := TFileStream.Create(CombinedFileName, fmCreate or fmShareExclusive);
  try
  while FileExists(FileName) do
  begin
  sStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
  fs.CopyFrom(sStream, 0);
  finally
  sStream.Free;
  if cbdel.Checked then
  DeleteFile(FileName);
  end;
  Inc(i);
  FileName := ChangeFileExt(FileName, '.'+ FormatFloat('000', i));
  end;

  finally
  fs.Free;
  end;
  end;
*)

procedure GetFilenames(Path: string; Dest: TStringList);
// DOES NOT WORK
var
  Rec: TSearchRec;
  nFileCount: integer;
  foo: string;
begin
  nFileCount := 0;

  if FindFirst('c:\Government Specs\2012-T1\Test Returns' + '*.*', faAnyFile,
    Rec) = 0 then
  begin
    repeat
      if ((Rec.Attr and faDirectory) <> faDirectory) then
      Begin
        inc(nFileCount);
        Dest.Add(Rec.Name);
        // SysUtils.FindClose(Rec);  mine
      end;
    until nFileCount = 100; // mine //SysUtils.FindNext(Rec) <> 0;
    SysUtils.FindClose(Rec);
  end;
  (*
    if FindFirst(Path+'*.*', faAnyFile, Rec) = 0 then
    begin
    repeat
    // Exclude directories from the list of files.
    if ((Rec.Attr and faDirectory) <> faDirectory) then
    Begin
    Inc(nFileCount);
    Dest.Add(Rec.Name);
    end;
    If SysUtils.FindNext(Rec)=0 then SysUtils.FindClose(Rec);
    until SysUtils.FindNext(Rec) <> 0;
    // SysUtils.FindClose(Rec);
    end;
  *)
end;

Procedure MergeWordFilesIntoPdf;
// Open each file and Print in PDF Factory
Var
  Path: String;
  Dest: TStringList;
var
  i: integer;
begin
  Path := 'c:\Government Specs\2012-T1\Test Returns';
  Dest := TStringList.Create;
  GetFilenames(Path, Dest);
  For i := 0 to Dest.Count - 1 do
    ShowMessage(Dest[i]);

  Dest.Free;
end;

Function Calc5031(RetNo: integer): Real;   //CPP AND QPP contrributions
Var
  i: integer;
  CppContr, QppContr: Real;
Begin
  CppContr := 0;
  QppContr := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T4' then
    Begin
      CppContr := CppContr + VL(FetchElmFNo(RetNo, FRec.FormNo, 3));
      QppContr := QppContr + VL(FetchElmFNo(RetNo, FRec.FormNo, 4));
    end;
  end;
  If (Ret[RetNo].Province = 'QC') Or ((CppContr > 0) and (QppContr > 0)) or
    ((Ret[RetNo].Province <> 'QC') and (CppContr = 0) and (QppContr > 0)) then
  begin
    Result := VL(FetchElm(RetNo, 'T2204', 25)); // part b   //???
    If Result = 0 then Result := VL(FetchElm(RetNo, 'T2204', 5)); // part A   ???
    If IsSelfEmployed(RetNo) then
      Result := CppContr + QppContr; // see zofia return
  end
  Else
    Result := 0;

end;

Function GetTotalTaxDeducted(RetNo: integer): Real;
begin
  With Ret[RetNo] do
  Begin
    Result := T4Tax + T4ATax + T4RspTax + T4RIFTax +
      TotMultiple(RetNo, 'T4AOAS', 3) { t4Aoas/22 }
      + T4APTax + TotMultiple(RetNo, 'T4E', 3) + TotMultiple(RetNo, 'T4E', 12) +
      T5013Tax + TotMultiple(RetNo, 'T4ARCA', 7) + TotMultiple(RetNo, 'T4FHSA',
      8); // 2023209
  end;
end;

Function GetLine489EfileNo(RetNo: integer): String;
// 20130220 add RetNo as param //20121226
Var
  OnLineNo, Password, url, NetFileDir: String;
begin
  Result := '';
  If (FetchElm(RetNo, 'INFO', 100) > '') // compensation
  // or (FetchElm(RetNo,'INFO',100)>'')  //discounter 20130220  out duplicate
  then
  Begin
    GetEOLParms(OnLineNo, Password, url, NetFileDir);
    Result := OnLineNo;
  end;
end;

Function GetBirthMonth(RetNo: integer): String; // 20130220
begin
  If Length(FetchElm(RetNo, 'INFO', 9)) >= 8 then
    Result := MidStr(FetchElm(RetNo, 'INFO', 9), 6, 2);
end;

Function GetBirthDay(RetNo: integer): String; // 20130220
begin
  If Length(FetchElm(RetNo, 'INFO', 9)) >= 8 then
    Result := RightStr(FetchElm(RetNo, 'INFO', 9), 2);
end;

Function GetDeceasedMonth(RetNo: integer): String; // 20130220
begin
  Result := '';
  If Length(FetchElm(RetNo, 'INFO', 12)) >= 8 then
    Result := MidStr(FetchElm(RetNo, 'INFO', 12), 6, 2);
end;

Function GetCpt30months(RetNo: integer; Cpt30Date: String): integer;
Begin
  Result := 0;
  If Cpt30Date = '' then
    Exit;
  If LeftStr(Cpt30Date, 4) = AppYear then
    Result := MyStrToInt(MidStr(Cpt30Date, 6, 2)) + 1; // 20130303
end;

Function GetEligDepBirthdate(RetNo: integer): String; // 20130312
Var
  i, DependFNo: integer;
Begin
  Result := '';
  DependFNo := GetFormNo('DEPEND');
  i := 5; { index to first dep in  Depend }
  Repeat
    if UpperCase(FetchElmFNo(RetNo, DependFNo, i + 14)) = 'Y'
    then { Equv spouse field }
    begin
      Result := FetchElmFNo(RetNo, DependFNo, i + 5);
      Exit;
    End;
    inc(i, 15);
  until i > 125;
end;

{$IFDEF v2012}

Function ImmigrantEmigrant(RetNo: integer): Boolean; // 20120711
begin
  Result := false;
  If FetchElm(RetNo, 'INFO', 25) + FetchElm(RetNo, 'INFO', 26) > '' then
    Result := true;
  If FetchElm(RetNo, 'INFO', 27) + FetchElm(RetNo, 'INFO', 28) > '' then
    Result := true;
end;
{$ELSE}
{$ENDIF}

function LicenseLevel: eLicenseLevel;
begin
  Result := AppT1_2026.LicenseLevel;
end;

function LicenseName: string;
begin
  Result := AppT1_2026.ProductName;
end;

Function IsEnterpriseVersion: Boolean; // 20231211 Igor
begin
  Result := LicenseLevel = llEnterprise;
end;

procedure QuickFormFind(RetNo: integer; ThisForm: String);
Var
  i, elm, FNo, TheLength: integer;
  FName: String;
  // FormRecs,ResultsList:TStringList;
  List1: TStringList;
begin
  ThisForm := UpperCase(ThisForm);
  // If ThisForm='T1' then ThisForm:='T1';
  If ThisForm = 'T3' then
    ThisForm := 'T3MULT';
  If ThisForm = 'T5' then
    ThisForm := 'T5MULT';
  TheLength := Length(ThisForm);

  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If ThisForm = AllTrim(ExtractFormRootName(FRec.FormName)) then
    begin
      FNo := FRec.FormNo; // GetFormNo(Frec.FormName+Frec.FormInst);
      If FNo > 0 then
      begin
        OpenFormNo(RetNo, FNo, 0);
        // Close;
        Exit;
      end;
    end;
  end;

  // load the firms
  List1 := TStringList.Create;
  List1.Sorted := true;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormShow then
      List1.AddObject(PaddR(FRec.FormRlNm, 10) + PaddR(FRec.FormDescr, 70) +
        FRec.FormName + FRec.FormInst, FRec);
  end; // i

  // not found as formname
  SomeCaption := 'Form or KeyWord found in following';
  SelectedString := PopMatchingList(ThisForm, List1, SomeCaption, true);
  List1.Free;
  If SelectedString > '' then
  begin
    TObject(FRec) := PopListObject; // ResultsList.Objects[PopListIdx];
    FNo := FRec.FormNo;
    OpenForm(RetNo, FNo, 0);
  end;
end;

(*
  Function ImmigrantEmigrant(RetNo:Integer):Boolean; //20120711
  begin
  Result:=False;
  If FetchElm(RetNo,'INFO',25)+FetchElm(RetNo,'INFO',26)>'' then result:=True;
  If FetchElm(RetNo,'INFO',27)+FetchElm(RetNo,'INFO',28)>'' then result:=True;
  end;
*)

Function Immigrant(RetNo: integer): Boolean; // 201311201
begin
  Result := false;
  If FetchElm(RetNo, 'INFO', 25) + FetchElm(RetNo, 'INFO', 26) > '' then
    Result := true;
end;

Function Emigrant(RetNo: integer): Boolean; // 201311201
begin
  Result := false;
  If FetchElm(RetNo, 'INFO', 27) + FetchElm(RetNo, 'INFO', 28) > '' then
    Result := true;
end;

{
  Function Rule90(RetNo: integer): Real; // 201311201
  // *** used ONLY for Immigrants / Emmigrants  ********
  var
  x: Real;
  CanInc, NonCanInc: Real;
  begin
  Result := 0;
  CanInc := VL(FetchElmFNo(RetNo, InfoFNo, 211));    //52920
  NonCanInc := VL(FetchElmFNo(RetNo, InfoFNo, 212)); //52930

  If CanInc + NonCanInc > 0 then
  begin
  Result := 100 * (CanInc / (CanInc + NonCanInc)); // //20240423
  // If x >= 90 then Result := true;
  end;
  end;
}

// 20240425
Function Rule90(RetNo: integer): Real; // 20140426c
// *** used ONLY for Immigrants / Emmigrants  ********
var
  x: Real;
  DaysInCan: integer;
  CanInc, NonCanInc: Real;
begin
  x := 100;
  CanInc := VL(FetchElmFNo(RetNo, InfoFNo, 211)); // 52920
  NonCanInc := VL(FetchElmFNo(RetNo, InfoFNo, 212)); // 52930

  If CanInc + NonCanInc > 0 then
  begin
    x := 100 * (CanInc / (CanInc + NonCanInc)); // //20240423
  end
  Else
    x := 0;
  if x >= 90 then
  Begin
    Result := MinR(100, x);
    Exit;
  End
  Else
  Begin
    // 20240426c
    DaysInCan := CalcDaysInCan(RetNo);
    If UpperCase(FetchElmFNo(RetNo, InfoFNo, 73)) > ''
    // zeroout the Non RefF credits
    then
      DaysInCan := 0;
    x := 100 * DaysInCan / Constant[RY].FullYear; // 20200307
    Result := x; // 20200307
    if (CanInc = 1) and (NonCanInc = 1) then
      Result := x; // ??100; //20250405
    // if (CanInc=1) and (NonCanInc=1) then result:=100; //20250405 //20240604
    Exit;
  End;

end;

{
  //20240425
  Function Rule90(RetNo: integer): Real; // 201311201
  // *** used ONLY for Immigrants / Emmigrants  ********
  var
  x: Real;
  CanInc, NonCanInc: Real;
  begin
  Result := 1; //false;
  CanInc := VL(FetchElmFNo(RetNo, InfoFNo, 211));    //52920
  NonCanInc := VL(FetchElmFNo(RetNo, InfoFNo, 212)); //52930

  If CanInc + NonCanInc > 0 then
  begin
  result:= 100 * (CanInc / (CanInc + NonCanInc)); // //20240423
  // x := 100 * (CanInc / (CanInc + NonCanInc)); // //20240423
  // If x >= 90 then Result := true;
  end;
  Else
  Result:=0;
  end;
}

// jz//20250213 replaced with CZ version
Function Rc381InEffect(RetNo: integer): Boolean;
begin
  // 20250208
  Result := false;
  // EXIT;
  // 20250212
  If (Ret[RetNo].Province = 'QC') Or (GetActualQPPPremiums(RetNo) > 0)
  // T4 with Province='QP' on elm 20) //jz//20250227 reinstate for testing #16
  then
    Result := true
  Else
    Result := false;
end;

procedure CreateEfileXmlOnlyFile;
var
  FileNm, FlName, FirstLast: String;
  RetNo: integer;
  h: THandle;
  OnLineNo, Password, url, NetFileDir: String;
begin
  (*
    GetEOLParms(OnlineNo,Password,Url,NetFileDir);
    RetNo:=GetCurrentRetNo;
    If RetNo>0 then
    begin
    FirstLast:='';
    FileNm :=MkXmlFileName(RetNo,NetFileDir);
    ProdOrTest:='T'; //GetProductionOrTest;
    CreateXmlDataFile(RetNo,FileNm,'',ProdOrTest,'P',FirstLast,OnLineMethod,DcnSeqNo);

    //remove CDATA from first line
    XmlList[0] := midstr(XmlList[0],16,length(XmlList[0]));

    FlName:=NetFileDir+'\'+'T1Efile-XMLONLY-'+RemoveChar(GetLastName(RetNo)+' '+GetFirstName(RetNo),'.')+'.xml';
    XmlList.SaveToFile(FlName);

    XmlList.Clear;
    //ShowMessage('Done');
    h := ShellExecute(Self.Handle,'open',Pchar(''+FileName),Nil,Nil,Sw_Show);
    If H<=32 then ShowMessage('File not found');
    end
    else
    Begin
    ShowMessage('The tax return must be opened first');
    Close;
    Exit;
    end;
  *)
end;

Function MkXmlFileName(RetNo: integer; NetFileDir: String): String;
Var
  S: String;
begin
  // 20140126
  Result := NetFileDir + '\' + RemoveChar(GetLastName(RetNo) + ' ' +
    GetFirstName(RetNo) + '-' + GetSinNo(RetNo) + '-' + Ret[RetNo].Province +
    '-FullXml', '.') + '.xml'; // 20140126
end;

(*
  //20170401
  Function MkBeforeRefileFileName(RetNo:Integer):String;
  Var Dt:String;
  begin
  Dt:=FormatDateTime('yyy-mm-dd',Date);
  Result:=GetLastName(RetNo)+' '+GetFirstName(RetNo)+'-'+GetSinNo(RetNo);
  Result:=RemoveChar(Result,Chr(39));  //apostrophe
  Result:=Result+'-Before Refile-'+Dt;
  End;
*)
Function GetUniqueMinutesSeconds: String;
Var
  SHours, SMinutes, SSeconds: string[2];
  Hour, Min, Sec, Msec: word;
begin
  DecodeTime(Now, Hour, Min, Sec, Msec);
  SMinutes := AllTrim(IntToStr(Min));
  SSeconds := AllTrim(IntToStr(Sec));
  If Length(SMinutes) = 1 then
    SMinutes := '0' + SMinutes;
  If Length(SSeconds) = 1 then
    SSeconds := '0' + SSeconds;
  Result := SMinutes + SSeconds;
end; // end of embedded function

Function HasBusiness(RetNo: integer): Boolean;
Begin
  Result := false;
  With Ret[RetNo] do
  Begin
    If Lnn[12200] + Lnn[13500] + Lnn[13700] + Lnn[13900] + Lnn[14100] +
      Lnn[14300] > 0 then
      Result := true;
  end;

end;

Function GetPlacementOfficeIncome(RetNo: integer): Real; // 20140109
Begin
  Result := TotMultiple(RetNo, 'T4', 48);
end;

Function GetEfErrorDescr(ErrorCode: String): AnsiString;
Var
  ADConnection: TADConnection;
  Tbl: TADTable;
begin
  If Length(ErrorCode) = 6 then
    ErrorCode := 'Y' + MidStr(ErrorCode, 2, 5); // 20140119

  // 20150916 Igor
  ADConnection := TADConnection.Create(Application);
  Tbl := TADTable.Create(Application);
  // 20160226 Igor >>>
  if not SetTableName(ADConnection, Tbl, AppDir + '\' + EfErrorsDBLite,
    EfErrorsTableLite, 'Code') then
  Begin
    if Assigned(ADConnection) then
      FreeAndNil(ADConnection);
    if Assigned(Tbl) then
      FreeAndNil(Tbl);
    Exit;
  End;
  // 20160226 Igor <<<<
  if Tbl.FindKey([ErrorCode]) = true then
  begin
    Result := Tbl.FieldByName('Descr').AsString;
  end
  Else; // ShowMessage('See the Error Messages document Under EfileOnline');

  Tbl.Free;
  ADConnection.Free;
end;

Function GetWebServiceErrorDescr(ErrorCode: String): AnsiString; // 20140119
Var
  ADConnection: TADConnection;
  Tbl: TADTable;
begin
  Result := '';

  // 20150916 Igor
  ADConnection := TADConnection.Create(Application);
  Tbl := TADTable.Create(Application);
  // 201600226 Igor >>>>>
  if not SetTableName(ADConnection, Tbl, AppDir + '\' + WSErrorsDBLite,
    WSErrorsTableLite, 'Code') then
  Begin
    if Assigned(ADConnection) then
      FreeAndNil(ADConnection);
    if Assigned(Tbl) then
      FreeAndNil(Tbl);
    Exit;
  End;
  // 20160226 Igor <<<<
  if Tbl.FindKey([ErrorCode]) = true then
  begin
    Result := Tbl.FieldByName('Descr').AsString;
  end
  Else; // ShowMessage('See the Web Services Error Messages document Under EfileOnline');
  Tbl.Free;
  ADConnection.Free;
end;

Function MakeEolPFileName(LicenseLevel: eLicenseLevel): string;
Var
  YYYY, MM, DD, Hour, Min, Sec, Msec: word;
  SMM, SDD, SMin, SSec: string[2];
begin
  DecodeDate(Now, YYYY, MM, DD);
  DecodeTime(Now, Hour, Min, Sec, Msec);
  SMM := LTrim(RTrim(IntToStr(MM)));
  SDD := LTrim(RTrim(IntToStr(DD)));
  SMin := LTrim(RTrim(IntToStr(Min)));
  SSec := LTrim(RTrim(IntToStr(Sec)));
  If Length(SMM) = 1 then
    SMM := '0' + SMM;
  If Length(SDD) = 1 then
    SDD := '0' + SDD;
  If Length(SMin) = 1 then
    SMin := '0' + SMin;
  If Length(SSec) = 1 then
    SSec := '0' + SSec;
  // If LeftStr(LicenseLevel,8) = 'T1 Multi' then
  If LicenseLevel in anyMulti then
    Result := LeftStr(User.UserName, 4) + SDD + SSec { User.M_Office+SDD+SSec }
    // 20170112 Igor
  Else
    Result := 'Batch' + SMM + SDD + SMin + SSec;
end;

// 20150716
Function CreateEfileResponseHtm(RetNo: integer; AckRec: TAckRec;
  HtmFile: String): String;
var
  htmlSource: TStringList;
  source, FlName: string;
  KeyWord, S: string;
  OnLineNo, Password, url, NetFileDir: String;
  i, j, k, StartPos, itemNumTemp: integer;
begin
  Result := ''; // 20150716   //?????
  GetEOLParms(OnLineNo, Password, url, NetFileDir);
  htmlSource := TStringList.Create;
  htmlSource.LoadFromFile(HtmFile);

  For i := 0 to htmlSource.Count - 1 do
  begin

    {
      startPos := pos('!FamilyName!', htmlSource[i]);
      if  startPos > 0 then htmlSource[i] := AckRec.FamilyName;

      startPos := pos('!GivenName!', htmlSource[i]);
      if  startPos > 0 then htmlSource[i] := AckRec.GivenName;
    }

    // not handled, why are they there?----------------------------------------------
    KeyWord := '!CVIndicator!';
    S := '';
    StartPos := Pos(KeyWord, htmlSource[i]);
    if StartPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], KeyWord, S,
        [rfReplaceAll, rfIgnoreCase]);
    KeyWord := '!Type!';
    S := AckRec.returnTypeName;
    StartPos := Pos(KeyWord, htmlSource[i]);
    if StartPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], KeyWord, S,
        [rfReplaceAll, rfIgnoreCase]);
    // not handled, why are they there?----------------------------------------------

    KeyWord := '!Client!';
    S := AckRec.GivenName + ' ' + AckRec.FamilyName;
    StartPos := Pos(KeyWord, htmlSource[i]);
    if StartPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], KeyWord, S,
        [rfReplaceAll, rfIgnoreCase]);

    KeyWord := '!Received!';
    S := 'Acknowledgement received: ' + AckRec.DateReceived + ' ' +
      AckRec.TimeReceived;
    StartPos := Pos(KeyWord, htmlSource[i]);
    if StartPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], KeyWord, S,
        [rfReplaceAll, rfIgnoreCase]);

    KeyWord := '!DocumentNo!';
    S := AckRec.DocumentNo;
    StartPos := Pos(KeyWord, htmlSource[i]);
    if StartPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], KeyWord, S,
        [rfReplaceAll, rfIgnoreCase]);

    KeyWord := '!TransmissionNo!';
    S := AckRec.TransmissionNo;
    StartPos := Pos(KeyWord, htmlSource[i]);
    if StartPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], KeyWord, S,
        [rfReplaceAll, rfIgnoreCase]);

    // If (AckRec.Accepted= false) and (AckRec.ResultCode <> '184') then
    // Begin
    // failures other than 184 code (i.e, connection problems, and not tax return errors
    KeyWord := '!ResultCode!';
    S := AckRec.ResultCode;
    StartPos := Pos(KeyWord, htmlSource[i]);
    if (StartPos > 0) then // and (AckRec.ResultCode <> '184') then
      htmlSource[i] := StringReplace(htmlSource[i], KeyWord, S,
        [rfReplaceAll, rfIgnoreCase]);

    KeyWord := '!Description!';
    S := tempAckRecDescription; // AckRec.Description; // 20170130
    // keyWord:= '!Description!'; s := GetWebServiceErrorDescr(AckRec.ResultCode); //AckRec.Description;
    StartPos := Pos(KeyWord, htmlSource[i]);
    if (StartPos > 0) then // and (AckRec.ResultCode <> '184') then
      htmlSource[i] := StringReplace(htmlSource[i], KeyWord, S,
        [rfReplaceAll, rfIgnoreCase]);


    // end;
    // ----------------------------------------------------------------

    // jz 20230217
    for k := 1 to 5 do
    begin
      KeyWord := '!HyperLinkText[' + IntToStr(k) + ']!';
      S := AckRec.HyperLinkText[k];
      StartPos := Pos(KeyWord, htmlSource[i]);
      if StartPos > 0 then
        htmlSource[i] := StringReplace(htmlSource[i], KeyWord, S,
          [rfReplaceAll, rfIgnoreCase]);

      KeyWord := '!HyperLinkLink[' + IntToStr(k) + ']!';
      S := AckRec.HyperLinkLink[k];
      StartPos := Pos(KeyWord, htmlSource[i]);
      if StartPos > 0 then
        htmlSource[i] := StringReplace(htmlSource[i], KeyWord, S,
          [rfReplaceAll, rfIgnoreCase]);
    end;

    // 20180118 //20181802 ??  wrong
    for k := 1 to 6 do
    begin
      // tax return error codes
      KeyWord := '!ErrorCode[' + IntToStr(k) + ']!';
      S := AckRec.ErrorCode[k];
      StartPos := Pos(KeyWord, htmlSource[i]);
      if StartPos > 0 then
        htmlSource[i] := StringReplace(htmlSource[i], KeyWord, S,
          [rfReplaceAll, rfIgnoreCase]);

      // tax return descriptions
      for j := 1 to 12 do
      begin
        KeyWord := '!Description[' + IntToStr(k) + '][' + IntToStr(j) + ']!';
        S := tempAckRecErrorCodeMsg[k][j]; // AckRec.ErrorCodeMsg[1];
        StartPos := Pos(KeyWord, htmlSource[i]);
        if StartPos > 0 then
          htmlSource[i] := StringReplace(htmlSource[i], KeyWord, S,
            [rfReplaceAll, rfIgnoreCase]);
      end;
    end;
  end;

  // 20160722  CON  Name was not the same with the one expected by T1Efile
  FlName := NetFileDir + '\' + RemoveChar(GetLastName(RetNo) + ' ' +
    GetFirstName(RetNo) + '-' + GetSinNo(RetNo) + '-EfileAck', '.') + '.htm';
  // 20140126

  htmlSource.SaveToFile(FlName);
  htmlSource.Free;

  Result := FlName; // 20170123 //return the created file location
end;

(*
  // 20150716
  Function CreateEfileResponseHtm(RetNo:Integer;AckRec:TAckRec;HtmFile:String):String;
  var
  htmlSource:TStringList;
  source,flName:string;
  keyWord,s:string;
  OnLineNo,PassWord,Url,NetFileDir:String;
  i,j,k,startPos,itemNumTemp:integer;
  begin
  Result:='';  //20150716   //?????
  GetEOLParms(OnlineNo,Password,Url,NetFileDir);
  htmlSource:=TStringList.Create;
  htmlSource.LoadFromFile(HtmFile);

  For i := 0 to htmlSource.Count-1 do
  begin

  {
  startPos := pos('!FamilyName!', htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := AckRec.FamilyName;

  startPos := pos('!GivenName!', htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := AckRec.GivenName;
  }


  //not handled, why are they there?----------------------------------------------
  keyWord:= '!CVIndicator!'; s := '';
  startPos := pos(keyWord, htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := StringReplace(htmlSource[i],keyWord,s,[rfReplaceAll, rfIgnoreCase]);
  keyWord:= '!Type!'; s := AckRec.returnTypeName;
  startPos := pos(keyWord, htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := StringReplace(htmlSource[i],keyWord,s,[rfReplaceAll, rfIgnoreCase]);
  //not handled, why are they there?----------------------------------------------



  keyWord:= '!Client!'; s := AckRec.GivenName+' '+AckRec.FamilyName;
  startPos := pos(keyWord, htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := StringReplace(htmlSource[i],keyWord,s,[rfReplaceAll, rfIgnoreCase]);

  keyWord:= '!Received!'; s := 'Acknowledgement received: '+AckRec.DateReceived+' '+AckRec.TimeReceived;
  startPos := pos(keyWord, htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := StringReplace(htmlSource[i],keyWord,s,[rfReplaceAll, rfIgnoreCase]);

  keyWord:= '!DocumentNo!'; s := AckRec.DocumentNo;
  startPos := pos(keyWord, htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := StringReplace(htmlSource[i],keyWord,s,[rfReplaceAll, rfIgnoreCase]);

  keyWord:= '!TransmissionNo!'; s := AckRec.TransmissionNo;
  startPos := pos(keyWord, htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := StringReplace(htmlSource[i],keyWord,s,[rfReplaceAll, rfIgnoreCase]);

  If (AckRec.Accepted= false) and (AckRec.ResultCode <> '184') then
  Begin
  //failures other than 184 code (i.e, connection problems, and not tax return errors
  keyWord:= '!ResultCode!'; s := AckRec.ResultCode;
  startPos := pos(keyWord, htmlSource[i]);
  if  (startPos > 0) and (AckRec.ResultCode <> '184') then htmlSource[i] := StringReplace(htmlSource[i],keyWord,s,[rfReplaceAll, rfIgnoreCase]);

  KeyWord := '!Description!'; s := tempAckRecDescription; //AckRec.Description; // 20170130
  // keyWord:= '!Description!'; s := GetWebServiceErrorDescr(AckRec.ResultCode);
  startPos := pos(keyWord, htmlSource[i]);
  if  (startPos > 0) and (AckRec.ResultCode <> '184') then htmlSource[i] := StringReplace(htmlSource[i],keyWord,s,[rfReplaceAll, rfIgnoreCase]);
  end;
  //----------------------------------------------------------------

  //tax return error codes
  keyWord:= '!ErrorCode[1]!'; s := AckRec.ErrorCode[1];
  startPos := pos(keyWord, htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := StringReplace(htmlSource[i],keyWord,s,[rfReplaceAll, rfIgnoreCase]);

  keyWord:= '!ErrorCode[2]!'; s := AckRec.ErrorCode[2];
  startPos := pos(keyWord, htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := StringReplace(htmlSource[i],keyWord,s,[rfReplaceAll, rfIgnoreCase]);

  keyWord:= '!ErrorCode[3]!'; s := AckRec.ErrorCode[3];
  startPos := pos(keyWord, htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := StringReplace(htmlSource[i],keyWord,s,[rfReplaceAll, rfIgnoreCase]);

  keyWord:= '!ErrorCode[4]!'; s := AckRec.ErrorCode[4];
  startPos := pos(keyWord, htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := StringReplace(htmlSource[i],keyWord,s,[rfReplaceAll, rfIgnoreCase]);

  keyWord:= '!ErrorCode[5]!'; s := AckRec.ErrorCode[5];
  startPos := pos(keyWord, htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := StringReplace(htmlSource[i],keyWord,s,[rfReplaceAll, rfIgnoreCase]);

  keyWord:= '!ErrorCode[6]!'; s := AckRec.ErrorCode[6];
  startPos := pos(keyWord, htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := StringReplace(htmlSource[i],keyWord,s,[rfReplaceAll, rfIgnoreCase]);



  //Error descriptions code coming from the EfErrors.db
  keyWord:= '!Description[1]!'; s := GetEfErrorDescr(AckRec.ErrorCode[1]);
  startPos := pos(keyWord, htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := StringReplace(htmlSource[i],keyWord,s,[rfReplaceAll, rfIgnoreCase]);

  keyWord:= '!Description[2]!'; s := GetEfErrorDescr(AckRec.ErrorCode[2]);
  startPos := pos(keyWord, htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := StringReplace(htmlSource[i],keyWord,s,[rfReplaceAll, rfIgnoreCase]);

  keyWord:= '!Description[3]!'; s := GetEfErrorDescr(AckRec.ErrorCode[3]);
  startPos := pos(keyWord, htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := StringReplace(htmlSource[i],keyWord,s,[rfReplaceAll, rfIgnoreCase]);

  keyWord:= '!Description[4]!'; s := GetEfErrorDescr(AckRec.ErrorCode[4]);
  startPos := pos(keyWord, htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := StringReplace(htmlSource[i],keyWord,s,[rfReplaceAll, rfIgnoreCase]);

  keyWord:= '!Description[5]!'; s := GetEfErrorDescr(AckRec.ErrorCode[5]);
  startPos := pos(keyWord, htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := StringReplace(htmlSource[i],keyWord,s,[rfReplaceAll, rfIgnoreCase]);

  end;

  //20160722  CON  Name was not the same with the one expected by T1Efile
  flName  := NetFileDir+'\'+RemoveChar(GetLastName(RetNo)+' '+GetFirstName(RetNo)+'-'+GetSinNo(RetNo)+'-EfileAck','.')+'.htm'; //20140126

  htmlSource.SaveToFile(flName);
  htmlSource.Free;

  result  := flName; //20170123 //return the created file location
  end;
*)
(* 20150716
  //20140119
  procedure CreateEfileResponseHtm(RetNo:Integer;AckRec:TAckRec;HtmFile:String);
  var
  htmlSource:TStringList;
  source,flName:string;
  OnLineNo,PassWord,Url,NetFileDir:String;
  i,j,k,s,startPos,itemNumTemp:integer;
  begin
  GetEOLParms(OnlineNo,Password,Url,NetFileDir);
  htmlSource:=TStringList.Create;
  htmlSource.LoadFromFile(HtmFile);

  For i := 0 to htmlSource.Count-1 do
  begin
  startPos := pos('!Client!', htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := AckRec.GivenName+' '+AckRec.FamilyName;
  {
  startPos := pos('!FamilyName!', htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := AckRec.FamilyName;

  startPos := pos('!GivenName!', htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := AckRec.GivenName;
  }

  startPos := pos('!Received!', htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := 'Acknowledgement received: '+AckRec.DateReceived+' '+AckRec.TimeReceived;

  startPos := pos('!DocumentNo!', htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := AckRec.DocumentNo;

  startPos := pos('!TransmissionNo!', htmlSource[i]);
  if  startPos > 0 then
  htmlSource[i] := AckRec.TransmissionNo;

  If (AckRec.Accepted= false) and (AckRec.ResultCode <> '184') then
  Begin
  //failures other than 184 code (i.e, connection problems, and not tax return errors
  startPos := pos('!ResultCode!', htmlSource[i]);
  if  (startPos > 0) and (AckRec.ResultCode <> '184')
  then htmlSource[i] := AckRec.ResultCode;

  startPos := pos('!Description!', htmlSource[i]);
  if  (startPos > 0) and (AckRec.ResultCode <> '184')
  then htmlSource[i] := GetWebServiceErrorDescr(AckRec.ResultCode);
  end;
  //----------------------------------------------------------------

  //tax return error codes
  startPos := pos('!ErrorCode[1]!', htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := AckRec.ErrorCode[1];

  startPos := pos('!ErrorCode[2]!', htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := AckRec.ErrorCode[2];

  startPos := pos('!ErrorCode[3]!', htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := AckRec.ErrorCode[3];

  startPos := pos('!ErrorCode[4]!', htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := AckRec.ErrorCode[4];

  startPos := pos('!ErrorCode[5]!', htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := AckRec.ErrorCode[5];

  startPos := pos('!ErrorCode[6]!', htmlSource[i]);
  if  startPos > 0 then htmlSource[i] := AckRec.ErrorCode[6];


  //Error descriptions code coming from the EfErrors.db
  startPos := pos('!Description[1]!', htmlSource[i]);
  if  startPos > 0 then
  htmlSource[i] := GetEfErrorDescr(AckRec.ErrorCode[1]);

  startPos := pos('!Description[2]!', htmlSource[i]);
  if  startPos > 0 then  htmlSource[i] := GetEfErrorDescr(AckRec.ErrorCode[2]);

  startPos := pos('!Description[3]!', htmlSource[i]);
  if  startPos > 0 then  htmlSource[i] := GetEfErrorDescr(AckRec.ErrorCode[3]);

  startPos := pos('!Description[4]!', htmlSource[i]);
  if  startPos > 0 then  htmlSource[i] := GetEfErrorDescr(AckRec.ErrorCode[4]);

  startPos := pos('!Description[5]!', htmlSource[i]);
  if  startPos > 0 then  htmlSource[i] := GetEfErrorDescr(AckRec.ErrorCode[5]);

  end;

  flName := NetFileDir+'\'+ GetLastName(RetNo)+' '+GetFirstName(RetNo) + '-EFileAck.htm';
  htmlSource.SaveToFile(flName);

  htmlSource.Free;
  end;
*)

(*
  //20140121 John
  procedure CreateEfileResponseHtm(RetNo:Integer;AckRec:TAckRec;HtmFile:String);
  var
  htmlSource:TStringList;
  sString,source,flName:string;
  OnLineNo,PassWord,Url,NetFileDir:String;
  i,j,k,s,startPos,itemNumTemp:integer;
  begin
  GetEOLParms(OnlineNo,Password,Url,NetFileDir);
  htmlSource:=TStringList.Create;
  htmlSource.LoadFromFile(HtmFile);

  For i := 0 to htmlSource.Count-1 do
  begin
  sString := '!Client!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
  htmlSource[i] := StringReplace(htmlSource[i], sString, AckRec.GivenName+' '+AckRec.FamilyName,[rfReplaceAll, rfIgnoreCase]);

  sString := '!Received!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
  htmlSource[i] := StringReplace(htmlSource[i], sString, 'Received: ' + AckRec.DateReceived+' '+AckRec.TimeReceived,[rfReplaceAll, rfIgnoreCase]);

  sString := '!DocumentNo!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
  begin
  htmlSource[i] := StringReplace(htmlSource[i], sString, AckRec.DocumentNo,[rfReplaceAll, rfIgnoreCase]);
  if AckRec.DocumentNo = '' then StringReplace(htmlSource[i], sString, AckRec.DocumentNo,[rfReplaceAll, rfIgnoreCase]);
  end;
  sString := '!TransmissionNo!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
  begin
  htmlSource[i] := StringReplace(htmlSource[i], sString, AckRec.TransmissionNo,[rfReplaceAll, rfIgnoreCase]);
  end;

  If (AckRec.EFresultType<>EFaccepted) then //this if probably not needed //20140124
  Begin
  //failures other than 184 code (i.e, connection problems, and not tax return errors

  sString := '!ResultCode!';          //20140219
  startPos := pos(sString, htmlSource[i]);
  if (startPos > 0) then
  htmlSource[i] := StringReplace(htmlSource[i], sString, AckRec.ResultCode,[rfReplaceAll, rfIgnoreCase]);

  sString := '!Description!'; //'!Description!';    //20140219
  startPos := pos(sString, htmlSource[i]);
  if (startPos > 0) then
  htmlSource[i] := StringReplace(htmlSource[i], sString, GetWebServiceErrorDescr(AckRec.ResultCode),[rfReplaceAll, rfIgnoreCase]);
  end;

  //----------------------------------------------------------------

  //tax return error codes
  sString := '!ErrorCode[1]!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
  htmlSource[i] := StringReplace(htmlSource[i], sString, AckRec.ErrorCode[1],[rfReplaceAll, rfIgnoreCase]);

  sString := '!ErrorCode[2]!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
  htmlSource[i] := StringReplace(htmlSource[i], sString, AckRec.ErrorCode[2],[rfReplaceAll, rfIgnoreCase]);

  sString := '!ErrorCode[3]!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0
  then htmlSource[i] := StringReplace(htmlSource[i], sString, AckRec.ErrorCode[3],[rfReplaceAll, rfIgnoreCase]);

  sString := '!ErrorCode[4]!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0
  then htmlSource[i] := StringReplace(htmlSource[i], sString, AckRec.ErrorCode[4],[rfReplaceAll, rfIgnoreCase]);

  sString := '!ErrorCode[5]!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
  htmlSource[i] := StringReplace(htmlSource[i], sString, AckRec.ErrorCode[5],[rfReplaceAll, rfIgnoreCase]);


  //Error descriptions code coming from the EfErrors.db
  sString := '!Description[1]!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
  htmlSource[i] := StringReplace(htmlSource[i], sString, GetEfErrorDescr(AckRec.ErrorCode[1]),[rfReplaceAll, rfIgnoreCase]);

  sString := '!Description[2]!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
  htmlSource[i] := StringReplace(htmlSource[i], sString, GetEfErrorDescr(AckRec.ErrorCode[2]),[rfReplaceAll, rfIgnoreCase]);

  sString := '!Description[3]!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
  htmlSource[i] := StringReplace(htmlSource[i], sString, GetEfErrorDescr(AckRec.ErrorCode[3]),[rfReplaceAll, rfIgnoreCase]);

  sString := '!Description[4]!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
  htmlSource[i] := StringReplace(htmlSource[i], sString, GetEfErrorDescr(AckRec.ErrorCode[4]),[rfReplaceAll, rfIgnoreCase]);

  sString := '!Description[5]!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
  htmlSource[i] := StringReplace(htmlSource[i], sString, GetEfErrorDescr(AckRec.ErrorCode[5]),[rfReplaceAll, rfIgnoreCase]);

  end;

  flName := NetFileDir+'\'+RemoveChar(GetLastName(RetNo)+' '+GetFirstName(RetNo)+'-'+GetSinNo(RetNo)+'-EFileAck','.')+'.htm'; //20140126
  htmlSource.SaveToFile(flName);

  htmlSource.Free;
  end;
*)

Procedure CreateEmailList(DataDir: String; ClientFiles: TStringList);
Var
  i: integer;
  TempList: TStringList;
  h: THandle;
  FlName: String;
  PflName: PChar;
  FDConnection: TADConnection;
  Table1: TADTable;
  // lPsw:String; //20160226 Igor
Begin
  // fGetSQLitePsw(lPsw); //20150925 igor //20160226 Igor
  // 220160226 Igor >>>>
  if not SetTableName(FDConnection, Table1, DataDir + '\' + ClientsDBLite,
    ClientsTableLite, UpperCase('File_Name')) then
  Begin
    if Assigned(FDConnection) then
      FreeAndNil(FDConnection);
    if Assigned(Table1) then
      FreeAndNil(Table1);
    Exit;
  End;

  TempList := TStringList.Create;
  // 20150902 igor
  // FDConnection := TADConnection.Create(nil);
  // FDConnection.DriverName := 'SQLite';
  // Table1 := TADTable.Create(nil);
  // Table1.Connection := FDConnection;
  try
    // FDConnection.Params.Values['DataBase'] := DataDir + '\' + ClientsDBLite;
    // //20150904 igor
    // FDConnection.Params.Values['Password'] := lPsw;
    // Table1.TableName := ClientsTableLite;
    // Table1.IndexName := 'File_Name';
    // Table1.Open;
    Table1.First;

    For i := 0 to ClientFiles.Count - 1 do
    Begin
      // 20170223 Igor >>>
      // if Table1.FindKey([ClientFiles[i]]) = True then
      if Table1.Locate('FILE_NAME', ClientFiles[i], [loCaseInsensitive]) then
      // 20170223 Igor <<<
      begin
        If AllTrim(Table1.FieldByName('Email').AsString) > '' then
          TempList.Add(AllTrim(Table1.FieldByName('Email').AsString) + ';');
      end;
    end;
    FlName := 'EmailAddresses.txt';
    TempList.SaveToFile(AppDir + '\' + FlName);
    TempList.Free;
  finally
    Table1.Free;
    FDConnection.Free;
  end;

  ShowMessage('A file by the name ' + FlName + ' has been built in ' + AppDir +
    ' folder.' + Chr(13) +
    'with all selected clients who have an EMail address and the specified birthdate.'
    + Chr(13) + ' ' + Chr(13) +
    'You can copy its contents to the Recipients Box of your Email program' +
    Chr(13) + 'and use the same text message or the same attachment for all');

  PflName := PChar(AppDir + '\' + FlName);
  h := ShellExecute(Application.Handle, 'open', 'c:\windows\notepad.exe',
    PflName, nil, SW_SHOWNORMAL);
  If h <= 32 then
    ShowMessage('File not found');
end;

Function GetClientEMail(ClientFileName: String): String;
Var
  i: integer;
  TempList: TStringList;
  h: THandle;
  FDConnection: TADConnection; // 20150909
  Table1: TADTable; // 20150909
Begin
  Result := '';

  // 20150909 Igor
  // Create Connection DB
  FDConnection := TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  // 20160226 Igor >>>>
  if not SetTableName(FDConnection, Table1, OptRec.Dir_Cur + '\' +
    ClientsDBLite, ClientsTableLite, 'File_Name') then
  Begin
    if Assigned(FDConnection) then
      FreeAndNil(FDConnection);
    if Assigned(Table1) then
      FreeAndNil(Table1);
    Exit;
  End;
  // 20160226 Igor >>>>
  Table1.First;
  // 20170223 Igor >>>
  // if Table1.FindKey([ClientFileName]) = True then
  if Table1.Locate('FILE_NAME', ClientFileName, [loCaseInsensitive]) then
  // 20170223 Igor <<<
  begin
    Result := AllTrim(Table1.FieldByName('Email').AsString);
    Exit;
  end;
  Table1.Close;
  Table1.Free;
  FDConnection.Free;
end;

Procedure CopyMoveDateAndAddr(RetNo: integer; FrmNm: String);
// frmnm is T1C_ON etc
Var
  FNo: integer;
Begin
  FNo := GetFormNo(FrmNm);
  If FNo > 0 then
  begin
    StoreElm(RetNo, FNo, 171, FetchElm(RetNo, 'INFO', 171)); // date of move
    StoreElm(RetNo, FNo, 169, FetchElm(RetNo, 'INFO', 170));
    // reverse the indicators
    StoreElm(RetNo, FNo, 170, FetchElm(RetNo, 'INFO', 169));
    // reverse the indicators
  end;
end;

Function IsTaxTown: Boolean;
// alows SIN and Birthdates in ExtractData export to excel
begin
  Result := false;
  // NOT USED If UpperCase(LeftStr(OptRec.Prp_Name, 3)) = 'TAX TOWN' then result := True;  //20200121
  If (LicenseList.Keys[AppT1_2026.AppId] = 'T105-1894-1683-1245') Or
    (LicenseList.Keys[AppT1_2026.AppId] = 'T105-9643-8572-1329') then
    Result := true; // TaxTown 2020 //20200121  He has 2 licenses
end;

Function IsBCJ: Boolean;
begin
  Result := false;
  If UpperCase(LeftStr(OptRec.Prp_Name, 3)) = 'BCJ' then
    Result := true;
end;

// 20150412
Function AllowSaSB(RetNo: integer): Boolean; // nr categotis
Begin
  If (Ret[RetNo].Province = 'ZZ') // 20200307
  or (UpperCase(FetchElm(RetNo, 'INFO', 276)) = 'X')  // info residense info  nr eith rmpl
  or (IsSection115(RetNo)) // 20240425B nr with employment
  or (IsSection216(RetNo)) // 20240425B //nr with rental only //20240430
  then
    Result := true
  Else
    Result := false;
end;

Function QualifiedForFamilyTaxCut(RetNo: integer): Boolean;
begin
  Result := false;
  If Ret[RetNo].MarStatus > 3 then
    Exit; // only married and common law . How about others?
  If AnyDependantUnder18(RetNo) = false then
    Exit; // no dependant < 18
  If (Ret[RetNo].Lnn[11600] > 0) or (Ret[RetNo].Lnn[21000] > 0) then
    Exit; // pension split
  If FetchElm(RetNo, 'INFO', 166) > '' then
    Exit; // taxpayer prison
  If FetchElm(RetNo, 'INFO', 167) > '' then
    Exit; // spouse non res or prison
  If Ret[RetNo].Lnn[26000] < VL(FetchElm(RetNo, 'S2', 24)) then
    Exit; // lower taxable income
  If IsNonResident(RetNo) then
    Exit; // taxpayer not resident
  If IsSpouseNonResident(RetNo) then
    Exit; // Spose not resident
  If IsBankruptcyReturn(RetNo) then
    Exit; // taxpayer bankrupt

  Result := true;
end;

Function AnyDependantUnder18(RetNo: integer): Boolean;
Var
  i: integer;
begin
  Result := false;
  If Ret[RetNo].FormHasData['DEPEND'] = false then
    Exit;
  i := 5;
  Repeat
    If (CalcAge(FetchElm(RetNo, 'DEPEND', i + 5)) < 18) and
      (CalcAge(FetchElm(RetNo, 'DEPEND', i + 5)) >= 0)
    // 20150218  //also 0  //20150225
      and (FetchElm(RetNo, 'DEPEND', i) > '') // 20150225
    then
    begin
      Result := true;
      Exit;
    end;
    inc(i, 15);
  until i > 125;
end;

//20260503
Function GetPrvNonRefundableBasedOnRuleOf90(RetNo: integer;NormalPrvNonRefAmount:real): Real; // 20150412
Var
  FNo: integer;
  FName: String;
Begin
  FName := WhichTaxForm(RetNo, Ret[RetNo].Province);
  FNo := GetFormNo(FName);
  If (VL(FetchElm(RetNo, 'SNRESB', 2)) < 90)
  and (VL(FetchElm(RetNo, 'SNRESB', 6))>0) //has world Income
  then result:=0  // EXIT;  //already has the value
  Else
   Result:=NormalPrvNonRefAmount;
  //result:=0; //20260503
 //If VL(FetchElm(RetNo, 'SNRESB', 3)) < 90 then result:=0; //20260503
end;


(* //20260503 keep this old one just in case
// 20150412
Function GetPrvNonRefundableBasedOnRuleOf90(RetNo: integer): Real; // 20150412
Var
  x, Val5896: Real;
  FNo: integer;
  FName: String;
Begin
  FName := WhichTaxForm(RetNo, Ret[RetNo].Province);
  FNo := GetFormNo(FName);
  If VL(FetchElm(RetNo, 'SNRESB', 3)) < 90 then // 20150413
  // If VL(FetchElm(RetNo, 'SNRESB', 2)) < 90 then // 20150413
  Begin
    x := MaxR(0, Ret[RetNo].Lnn[30800] // l(FetchElmFNo(RetNo,FNo,31))  //5824
      + Ret[RetNo].Lnn[31217] // Vl(FetchElmFNo(RetNo,FNo,82))  //5829
      + Ret[RetNo].Lnn[31200] // Vl(FetchElmFNo(RetNo,FNo,33))  //5832
      + VL(FetchElmFNo(RetNo, FNo, 36)) // 5844  //disb
      + Ret[RetNo].Lnn[31900] // Vl(FetchElmFNo(RetNo,FNo,38))  //5852
      + VL(FetchElmFNo(RetNo, FNo, 39)) // 5856  tuition
      - VL(FetchElm(RetNo, 'S11PRV', 14)) // textbook
      - VL(FetchElm(RetNo, 'S11PRV', 2))); // textbook

    If Ret[RetNo].Province = 'AB' then
      Val5896 := VL(FetchElmFNo(RetNo, FNo, 69)) // 5896
    Else
      Val5896 := VL(FetchElmFNo(RetNo, FNo, 60)); // 5896
    Result := x * PrvConstant[RY].PrvNonRefundRate / 100 + Val5896;
  end
  Else
    Result := VL(FetchElmFNo(RetNo, FNo, 61)); // full not ref credits
end;
*)

Function ValidForT1135Efile(RetNo: integer; FNo: integer): Boolean;
var
  i: integer;
begin
  Result := true;

  // If FetchElmFNo(RetNo,FNo,39)>'' then //alredy efiled
  // result:=False;

end;

Function SeparatedForLessThan90Days(RetNo: integer): Boolean;
// 20151222 //20160119 Igor
Begin
  Result := false;
  If (FetchElm(RetNo, 'INFO', 188) > '') and
    ((Ret[RetNo].MarStatus = 3) Or (Ret[RetNo].MarStatus = 5)) then
    Result := true;
  // widow or separated

end;

Procedure CreateFileWithEFValues(XmlFlName, OutputFlName: String); // 20141126
Var
  i, j, Location: integer;
  TempList, TempList2: TStringList;
  S, Ln, Val: String;
begin
  Exit; // 20170110

  // FlName:='C:\t1-2014\EolFiles\Three Paul C-870000031-Submitted.xml';
  TempList := TStringList.Create;
  TempList2 := TStringList.Create;
  TempList.LoadFromFile(XmlFlName);
  For i := 0 to TempList.Count - 1 do
  begin
    S := AllTrim(TempList[i]);
    Location := Pos('FieldCode>', S);
    If Location > 0 then
    Begin
      Ln := MidStr(S, Location + 10, 4);
      Ln := ReplaceChar(Ln, '<', ' ');
      Location := Pos('FieldValue>', S);
      Val := ''; // MidStr(s,Loc+11,15);
      For j := Location to Location + 18 do
      Begin
        If Numeric(S[j]) then
          Val := Val + S[j];
      end;
      TempList2.Add(Ln + ' ' + Val);
    end;
  end;
  TempList2.SaveToFile(OutputFlName);
  // TempList2.SaveToFile('C:\t1-2014\eolfiles\Three Paul C-870000031-MB-Eflines.txt');
  TempList.Free;
  TempList2.Free;
  // ShowMessage('Done-See Eflines.txt file in folder EolFiles');
END;

Function isAutofilled(RNo: integer): Boolean; // 20160126 Igor
begin
  Result := false;  //allow it any way;   //20260302
  //20260302
  //If FetchElm(RNo, 'INFO', 224) > '' then Result := true;
end;

Function IsAuthRepDoneForTdd(RNo: integer): Boolean; // 20160126 Igor
begin
  //20260302
  Result:=True;
  Exit;
  {
  Result := false;
  // 20200302
  If (FetchElm(RNo, 'AUTHREP#1', 39) > '') // confirmation number
    Or (FetchElm(RNo, 'AUTHREP#1', 11) > '') // prepared prev year
  then
    Result := true;
 }
end;

Function MkTddFileName(RNo: integer; Sin: String): String; // 20160126 Igor
Begin
  Result := OptRec.Dir_AutoFill + '\' + GetLastName(RNo) // 20170222 Igor
    + ' ' + LeftStr(GetFirstName(RNo), 1) + '-' + 'AutoFillData' + '-' +
    Sin + '.txt';
end;

Procedure UpdateNetCapitalLossesFromTdd(RNo: integer); // 20160126 Igor
// update the net capital losses - pg 3 of cfr     from CFrAfill 'Net Capital Gain and Loss - unapplied loss
Var
  i, j, k, CfrFNo, CfrAFillFNo: integer;
  SYear: String; // this is the ear of origin
  iYear, IAppYear: integer;
  x: Real;
  Value: String;
Begin
  CfrFNo := GetFormNo('CFR');
  CfrAFillFNo := GetFormNo('CFRAFILL');
  IAppYear := StrToInt(AppYear);
  // Non-capital loss
  For i := 465 to 559 do
  begin
    StoreElm(RNo, CfrFNo, i, '');
  end; // clear it
  i := 153; // incoming cfrAfill form with TDD data
  Repeat
    SYear := FetchElmFNo(RNo, CfrAFillFNo, i);
    Value := FetchElmFNo(RNo, CfrAFillFNo, i + 3); // unapplied net loss
    If SYear > '' then
    Begin
      iYear := StrToInt(SYear);
      Case iYear of
        1980 .. 1984:
          Begin
            j := 465;
            x := VL(FetchElmFNo(RNo, CfrFNo, j)) + VL(Value);
            StoreElm(RNo, CfrFNo, j, FormatFloat('########.##', x));
            // add it tp first row
          end;

        1985 .. 1987:
          Begin
            j := 470;
            x := VL(FetchElmFNo(RNo, CfrFNo, j)) + VL(Value);
            StoreElm(RNo, CfrFNo, j, FormatFloat('########.##', x));
            // add it tp first row
          end;

        1988 .. 1989:
          Begin
            j := 475;
            x := VL(FetchElmFNo(RNo, CfrFNo, j)) + VL(Value);
            StoreElm(RNo, CfrFNo, j, FormatFloat('########.##', x));
            // add it tp first row
          end;

        1990 .. 1999:
          Begin
            j := 480;
            x := VL(FetchElmFNo(RNo, CfrFNo, j)) + VL(Value);
            StoreElm(RNo, CfrFNo, j, FormatFloat('########.##', x));
            // add it tp first row
          end;

        2000:
          begin
            j := 485;
            StoreElm(RNo, CfrFNo, j, Value);
            StoreElm(RNo, CfrFNo, 410, FetchElmFNo(RNo, CfrAFillFNo, i + 1));
            // incl in 2000
          end;
      else
        Begin
          // remaining years
          j := 490; // bfr 2001
          For k := 1 to 14 do
          begin
            If iYear = k + 2000 then
            Begin
              j := j + (k - 1) * 5;
              StoreElm(RNo, CfrFNo, j, Value);
            end;
          end;
        end;
      end; // case
    end; // syear
    inc(i, 6);
  until i > 273;
end;

Procedure UpdateCapitalGainsFromTdd(RNo: integer); // 20160126 Igor
Var
  i, j, k, CfrFNo, CfrAFillFNo: integer;
  SYear: String; // this is the ear of origin
  iYear, IAppYear: integer;
  x: Real;
  Value: String;
Begin
  CfrFNo := GetFormNo('CFR');
  CfrAFillFNo := GetFormNo('CFRAFILL');
  IAppYear := StrToInt(AppYear);
  // capital loss
  For i := 1 to 282 do
  begin
    If IsAbilNdx(i) = false then
      StoreElm(RNo, CfrFNo, i, ''); // clear all except ABIL
  end;

  // TAXABLE CAPITAL GAINS
  i := 153; // incoming cfrAfill form with TDD data
  Repeat
    SYear := FetchElmFNo(RNo, CfrAFillFNo, i);
    Value := FetchElmFNo(RNo, CfrAFillFNo, i + 2); // cap txbl gain
    If SYear > '' then
    Begin
      iYear := StrToInt(SYear);
      Case iYear of
        1986 .. 1987:
          Begin
            j := 1;
            // Value:=FetchElmFNo(RNo,CfrAFillFNo,i);  //c/ column from cap loss
            x := VL(FetchElmFNo(RNo, CfrFNo, j)) + VL(Value);
            StoreElm(RNo, CfrFNo, j, FormatFloat('########.##', x));
            // add it tp first row
          end;

        1988 .. 1989:
          Begin
            j := 2;
            x := VL(FetchElmFNo(RNo, CfrFNo, j)) + VL(Value);
            StoreElm(RNo, CfrFNo, j, FormatFloat('########.##', x));
            // add it tp first row
          end;

        1990 .. 1991:
          Begin
            j := 3;
            x := VL(FetchElmFNo(RNo, CfrFNo, j)) + VL(Value);
            StoreElm(RNo, CfrFNo, j, FormatFloat('########.##', x));
            // add it tp first row
          end;

        1992 .. 1993:
          Begin
            j := 4;
            x := VL(FetchElmFNo(RNo, CfrFNo, j)) + VL(Value);
            StoreElm(RNo, CfrFNo, j, FormatFloat('########.##', x));
            // add it tp first row
          end;

        1994 - 1999:
          begin
            j := 5;
            x := VL(FetchElmFNo(RNo, CfrFNo, j)) + VL(Value);
            StoreElm(RNo, CfrFNo, j, Value);
          end;

        2000:
          begin
            j := 33;
            StoreElm(RNo, CfrFNo, j, Value);
          end;
        2001:
          begin
            j := 41;
            StoreElm(RNo, CfrFNo, j, Value);
          end;
        2002:
          begin
            j := 46;
            StoreElm(RNo, CfrFNo, j, Value);
          end;
        2003:
          begin
            j := 53;
            StoreElm(RNo, CfrFNo, j, Value);
          end;
        2004:
          begin
            j := 65;
            StoreElm(RNo, CfrFNo, j, Value);
          end;
        2005:
          begin
            j := 66;
            StoreElm(RNo, CfrFNo, j, Value);
          end;
        2006:
          begin
            j := 28;
            StoreElm(RNo, CfrFNo, j, Value);
          end;
        2007:
          begin
            j := 72;
            StoreElm(RNo, CfrFNo, j, Value);
          end;
        2008:
          begin
            j := 83;
            StoreElm(RNo, CfrFNo, j, Value);
          end;
        2009:
          begin
            j := 88;
            StoreElm(RNo, CfrFNo, j, Value);
          end;
        2010:
          begin
            j := 93;
            StoreElm(RNo, CfrFNo, j, Value);
          end;
        2011:
          begin
            j := 263;
            StoreElm(RNo, CfrFNo, j, Value);
          end;
        2012:
          begin
            j := 268;
            StoreElm(RNo, CfrFNo, j, Value);
          end;
        2013:
          begin
            j := 273;
            StoreElm(RNo, CfrFNo, j, Value);
          end;
        2014:
          begin
            j := 278;
            StoreElm(RNo, CfrFNo, j, Value);
          end;
      end; // case
    end; // syear
    inc(i, 6);
  until i > 273;

  // CAPITAL GAINS DEDUCTION
  i := 285; // incoming cfrAfill form with TDD data
  Repeat
    SYear := FetchElmFNo(RNo, CfrAFillFNo, i);
    Value := FetchElmFNo(RNo, CfrAFillFNo, i + 1); // cap gains deduction
    If SYear > '' then
    Begin
      iYear := StrToInt(SYear);
      Case iYear of
        1986 .. 1987:
          Begin
            j := 1;
            x := VL(FetchElmFNo(RNo, CfrFNo, 6)) + VL(Value);
            StoreElm(RNo, CfrFNo, 6, FormatFloat('########.##', x));
            // add it tp first row
          end;

        1988 .. 1989:
          Begin
            j := 2;
            x := VL(FetchElmFNo(RNo, CfrFNo, 7)) + VL(Value);
            StoreElm(RNo, CfrFNo, 7, FormatFloat('########.##', x));
            // add it tp first row
          end;

        1990 .. 1991:
          Begin
            j := 3;
            x := VL(FetchElmFNo(RNo, CfrFNo, 8)) + VL(Value);
            StoreElm(RNo, CfrFNo, 8, FormatFloat('########.##', x));
            // add it tp first row
          end;

        1992 .. 1993:
          Begin
            j := 4;
            x := VL(FetchElmFNo(RNo, CfrFNo, 9)) + VL(Value);
            StoreElm(RNo, CfrFNo, 9, FormatFloat('########.##', x));
            // add it tp first row
          end;

        1994 - 1999:
          begin
            j := 5;
            x := VL(FetchElmFNo(RNo, CfrFNo, 10)) + VL(Value);
            StoreElm(RNo, CfrFNo, 10, FormatFloat('########.##', x));
            // add it tp first row
          end;

        2000:
          begin
            j := 33;
            StoreElm(RNo, CfrFNo, 34, Value);
          end;
        2001:
          begin
            j := 41;
            StoreElm(RNo, CfrFNo, 42, Value);
          end;
        2002:
          begin
            j := 46;
            StoreElm(RNo, CfrFNo, 47, Value);
          end;
        2003:
          begin
            j := 53;
            StoreElm(RNo, CfrFNo, 54, Value);
          end;
        2004:
          begin
            j := 65;
            StoreElm(RNo, CfrFNo, 64, Value);
          end;
        2005:
          begin
            j := 66;
            StoreElm(RNo, CfrFNo, 67, Value);
          end;
        2006:
          begin
            j := 28;
            StoreElm(RNo, CfrFNo, 32, Value);
          end;
        2007:
          begin
            j := 72;
            StoreElm(RNo, CfrFNo, 78, Value);
          end;
        2008:
          begin
            j := 83;
            StoreElm(RNo, CfrFNo, 84, Value);
          end;
        2009:
          begin
            j := 88;
            StoreElm(RNo, CfrFNo, 89, Value);
          end;
        2010:
          begin
            j := 93;
            StoreElm(RNo, CfrFNo, 94, Value);
          end;
        2011:
          begin
            j := 263;
            StoreElm(RNo, CfrFNo, 264, Value);
          end;
        2012:
          begin
            j := 268;
            StoreElm(RNo, CfrFNo, 269, Value);
          end;
        2013:
          begin
            j := 273;
            StoreElm(RNo, CfrFNo, 274, Value);
          end;
        2014:
          begin
            j := 278;
            StoreElm(RNo, CfrFNo, 279, Value);
          end;
      end; // case
    end; // syear
    inc(i, 5);
  until i > 380;
end;

Function IsAbilNdx(i: integer): Boolean; // 20160126 Igor
begin
  Result := false;
  Case i of
    21 .. 25:
      Result := true;
    37, 45, 50, 57, 61, 70, 71, 81, 87, 92, 97, 267, 272, 277, 282:
      Result := true;
  End;
end;

Procedure UpdateNonCapitalLossesFromTdd(RNo: integer); // 20160126 Igor
Var
  i, j, k, CfrFNo, CfrAFillFNo: integer;
  Value: String;
  SYear: String; // this is the ear of origin
  iYear, IAppYear: integer; // Value:String;
  x: Real;
Begin
  CfrFNo := GetFormNo('CFR');
  CfrAFillFNo := GetFormNo('CFRAFILL');
  IAppYear := StrToInt(AppYear);
  // Non-capital loss
  For i := 101 to 144 do
  begin
    StoreElm(RNo, CfrFNo, i, '');
  end; // clear it
  Calc(RNo, 'CFR'); // to put back the years
  i := 65; // incoming TDD form    //k=where to store it
  Repeat
    SYear := FetchElmFNo(RNo, CfrAFillFNo, i);
    If SYear > '' then
    Begin
      iYear := StrToInt(SYear);
      Value := FetchElmFNo(RNo, CfrAFillFNo, i + 1); // c/ column from cap loss
      If iYear <= IAppYear - 7 then // add it t first row
      Begin
        k := 101; // where to store it
        x := VL(FetchElmFNo(RNo, CfrFNo, k + 1)) + VL(Value);
        StoreElm(RNo, CfrFNo, k + 1, FormatFloat('########.##', x));
        // add it tp first row
      end
      Else // other years
      Begin // specific single year
        // find the matching year
        k := 106; // where to store it index to year of cfr non cap losses
        Repeat
          // ShowMessage('Elm in CFR ='+IntToStr(k)+' '+'Year='+FetchElmFNo(RNo,CfrFNo,k));
          If AllTrim(SYear) = FetchElmFNo(RNo, CfrFNo, k) then
          begin
            StoreElm(RNo, CfrFNo, k + 1, Value); // cf amount
            // ??? prior year amount where?
          end;
          inc(k, 5);
        until k > 131;
      end; // syear
    end; // syear
    inc(i, 4);
  until i > 141;
end;

// 20171220
Function GetStreetAddress(RetNo: integer): String; // 20160126 //20160202 Igor
Var
  S: String;
begin
  // InfoFNo:=GetFormNo('INFO');
  Result := '';
  If FetchElmFNo(RetNo, InfoFNo, 163) > '' then
    Result := FetchElmFNo(RetNo, InfoFNo, 163) + ' '; // rr
  If FetchElmFNo(RetNo, InfoFNo, 68) > '' then
    Result := Result + FetchElmFNo(RetNo, InfoFNo, 68) + ' '; // po box
  If FetchElmFNo(RetNo, InfoFNo, 22) > '' then
    Result := Result + FetchElmFNo(RetNo, InfoFNo, 22) + ' ';
  // +'-'; //apt  //20180109
  Result := Result + FetchElmFNo(RetNo, InfoFNo, 6); // str
  {
    Result:=Result
    +FetchElmFNo(RetNo,InfoFNo,6) //str
    +' '+FetchElmFNo(RetNo,InfoFNo,68)  //po box
    +' '+FetchElmFNo(RetNo,InfoFNo,163);  //RR
  }
end;

{ //20171220
  Function GetStreetAddress(RetNo:Integer):String; //20160126 //20160202 Igor
  Var s:String;
  begin
  InfoFNo:=GetFormNo('INFO');
  Result:='';
  If FetchElmFNo(RetNo,InfoFNo,22)>'' then Result:=FetchElmFNo(RetNo,InfoFNo,22)+'-'; //apt
  Result:=Result
  +FetchElmFNo(RetNo,InfoFNo,6) //str
  +' '+FetchElmFNo(RetNo,InfoFNo,68)  //po box
  +' '+FetchElmFNo(RetNo,InfoFNo,163);  //RR
  end;
}
Function ValidPin(S: String): Boolean; // 20160128
Begin
  Result := true;
  If S = '' then
    Exit;
  If Not Numeric(S) then
  begin
    Result := false;
    Exit;
  End;
  If Length(S) <> 8 then
  begin
    Result := false;
    Exit;
  End;
end;

Function PaddL(S: string; MaxLength: integer): string;
// add spaces in the beginning
Begin
  Result := FilledStr(PaddCount(S, MaxLength), ' ') + S;
End;

Function GetEfilerNo: String;
Var
  EfilerNo, S: String;
begin
  GetEOLParms(EfilerNo, S, S, S);
  Result := EfilerNo;
end;

Function HasNonQCT4Income(RetNo: integer): Boolean; // 20160216 Igor
Var
  i: integer;
  FNo: integer;
Begin
  Result := true;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T4' then
    begin
      FNo := FRec.FormNo;
      If FetchElmFNo(RetNo, FNo, 20) <> 'QC' then
      begin
        If VL(FetchElmFNo(RetNo, FNo, 2)) > 0 then
          Result := false; // empl income
      end;
    End;
  end; // i
end;

Function IsCraOpenForEfile: Boolean; // 20160216 Igor
begin
  Result := true;
  { 20160211
    If (Uppercase(LoginName)='FREDW') or (Uppercase(LoginName)='ATD') then exit;
    If FormatDateTime('yyyy-mm-dd',Date) < CraOpensForEfileDate then result:=false;
  }
end;

Function IsTDDOpenForUse: Boolean; // 20160216 Igor
begin
  Result := true;
  {
    result:=False;
    If (Uppercase(LoginName)='FREDW') or (Uppercase(LoginName)='ATD') then Begin Result:=True;exit;End; //allow only Fred and CRA
  }
end;

Procedure ShowCraIsClosed; // 20160216 Igor
begin
  If IsCraOpenForEfile = false then
    ShowMessage('CRA is currently NOT open for Efile' + Chr(13) + Chr(13) +
      'Expected to open on ' + CraOpensForEfileDate);
end;

Procedure ShowTDDNotAvailableForUse; // 20160216 Igor
begin
  ShowMessage('CRA is currently NOT open for Auto-Fill' + Chr(13) + Chr(13) +
    'Expected to open on ' + CraOpensForEfileDate);
end;

Function CfrAFillHasData(RetNo: integer; FNo: integer): Boolean;
// 20160216 Igor
Var
  i: integer;
Begin
  Result := false;
  For i := 1 to 7 do
  begin
    If FetchElmFNo(RetNo, FNo, i) > '' then
    begin
      Result := true;
      Exit;
    End;
  end;

  For i := 65 to 384 do
  begin
    If FetchElmFNo(RetNo, FNo, i) > '' then
    begin
      Result := true;
      Exit;
    End;
  end;
end;

Function GetDateTimeHoursMinutesSeconds(Dt: TDateTime): String;
// 20160213 //20160216 Igor
Var
  SHours, SMinutes, SSeconds: string[2];
  Hour, Min, Sec, Msec: word;
begin
  DecodeTime(Now, Hour, Min, Sec, Msec);
  SHours := IntToStr(Hour);
  SMinutes := IntToStr(Min);
  SSeconds := IntToStr(Sec);
  If Length(SHours) = 1 then
    SHours := '0' + SHours;
  If Length(SMinutes) = 1 then
    SMinutes := '0' + SMinutes;
  If Length(SSeconds) = 1 then
    SSeconds := '0' + SSeconds;
  Result := SHours + '-' + SMinutes + '-' + SSeconds;
end;

Function AddDateTimeSuffixToFileName(FileNm: String): String;
// 20160213 //20160216 Igor
Var
  OldFileNameOnly, Timesuffix, Ext: String;
  DotPos: integer;
  // yyyy,mm,dd:String;
Begin
  Result := FileNm;
  DotPos := Pos('.', FileNm);
  If DotPos = 0 then
    OldFileNameOnly := FileNm
  Else
    OldFileNameOnly := LeftStr(FileNm, DotPos - 1);
  Ext := ExtractFileExt(FileNm);

  Result := OldFileNameOnly + '-' + FormatDateTime('yyyy-mm-dd', Now) + '-' +
    GetDateTimeHoursMinutesSeconds(Now) + Ext;
end;

Function CountT5008DtlSlips(RetNo: integer): integer; // 20160120
Var
  i, SlipFNo: integer;
Begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T5008DTL' then
    Begin
      SlipFNo := FRec.FormNo;
      if Ret[RetNo].FrmHasData[SlipFNo] then
        Result := Result + 1;
    end;
  end;
end;

procedure HorScrollBarInListBox(ListBox: TListBox; MaxWidth: integer);
var
  i, w: integer;
begin
  if MaxWidth = 0 then
    SendMessage(ListBox.Handle, LB_SETHORIZONTALEXTENT, MaxWidth, 0)
  else
  begin
    { get largest item }
    for i := 0 to ListBox.Items.Count - 1 do
      with ListBox do
      begin
        w := Canvas.TextWidth(Items[i]);
        if w > MaxWidth then
          MaxWidth := w;
      end;
    SendMessage(ListBox.Handle, LB_SETHORIZONTALEXTENT,
      MaxWidth + GetSystemMetrics(SM_CXFRAME), 0);
  end;
end;

// 20160327
Function IsDataGroupASlip(DataGroup: String): Boolean;
Begin
  Result := false;
  DataGroup := UpperCase(DataGroup);

  If (DataGroup = 'T3SLIP') or (DataGroup = 'T4SLIP') Or (DataGroup = 'T4ASLIP')
    Or (DataGroup = 'T4APSLIP') Or (DataGroup = 'T4RSPSLIP') Or
    (DataGroup = 'T4RIFSLIP') Or (DataGroup = 'T4AOASSLIP') Or
    (DataGroup = 'T4ESLIP') Or (DataGroup = 'T5SLIP') Or
    (DataGroup = 'T5007SLIP') Or (DataGroup = 'T5008SLIP') Or
    (DataGroup = 'RC210SLIP') Or (DataGroup = 'RC62SLIP') Or
    (DataGroup = 'RRSPCONTRIBUTIONRECEIPTSLIP') // 20160117
    Or (DataGroup = 'PRPPSLIP') // 20170302
    Or (DataGroup = 'T1204SLIP') // 20170302
  Then
    Result := true;
end;

procedure OpenTheTddElmsTable; // 20160327
begin
  if not Assigned(TddElmsConnection) then
    TddElmsConnection := TADConnection.Create(nil);
  if not Assigned(TddElmsTable) then
    TddElmsTable := TADTable.Create(Application);
  TddElmsTable.Connection := TddElmsConnection;
  SetTableName(TddElmsConnection, TddElmsTable, AppDir + '\' + TddElmsDBLite,
    TddElmsTableLite, 'FieldKey');
  If TddElmsTable.Active then
    TddElmsTable.Close;
  If not TddElmsTable.Active then
    TddElmsTable.Open;
end;

function ImportOneReturn(ADS: TDataSet; ASrcDir, ADstDir: String;
  out AErr: String; AOverride: Boolean): Boolean;
var
  FlName: String;
  RApp: String;
  RYear, WorkRetNo, FNo, j: integer;
  PrPStatus, EfStatus: String[2];
  Notes: String[80];
  DbfDataDir: String[60];
Begin
  Result := false;
  FlName := Trim(ADS.FieldByName('File_Name').AsString);
  If FlName = '' then
  Begin
    AErr := 'Skip record. FileName is empty';
    Exit;
  End;
  If Not FileExists(IncludeTrailingBackslash(ASrcDir) + FlName) then
  Begin
    AErr := 'Skip record. File "' + IncludeTrailingBackslash(ASrcDir) + FlName +
      '" is missing';
    Exit;
  End;
  if not GetReturnAppAndYear(ASrcDir, FlName, RApp, RYear,
    AppT1_2026.SQLLitePassword.PassArray) then // 20160703 Igor
  Begin
    AErr := 'Skip record. File "' + IncludeTrailingBackslash(ASrcDir) + FlName +
      '" have bad format';
    Exit;
  End;
  if (RApp <> AppName) or (RYear <> AppYearInt) then
  Begin
    AErr := 'Skip record. File "' + IncludeTrailingBackslash(ASrcDir) + FlName +
      '" does not belong to the current program';
    Exit;
  End;
  If FileExists(IncludeTrailingBackslash(ADstDir) + FlName) AND not AOverride
  then // 20160615 Igor
  begin
    AErr := 'Record skipped. File "' + FlName +
      '" exists in destination folder.';
    Exit;
  end;
  try // 20160311 Igor
    WorkRetNo := ReadReturn(ASrcDir, FlName, false, false);
    // 20160615 Igor //20160621 Igor
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
      Ret[WorkRetNo].Locked := false;
    If not FileExists(IncludeTrailingBackslash(ADstDir) + FlName) or AOverride
    then // 20160615 Igor //20160617 Igor
      If SaveReturn(WorkRetNo, ADstDir, FlName, true, true) = 0 then
        Result := true
      else
        AErr := 'An error occurred while saving the file to disk'
    else
      AErr := 'Record skipped. File "' + FlName +
        '" exists in destination folder.';
  end
  else
    AErr := 'Record skipped. Return not loaded (' + IntToStr(WorkRetNo) + ')';

  If WorkRetNo > 0 then
    RemoveReturnFromMemory(WorkRetNo);
End;

function GetLastYearFile(ARetNo: integer): String; // 20160701 Igor
Begin
  Result := FetchElm(ARetNo, 'STATUS', c_LastYearElm);
End;

procedure SetLastYearFile(const ARetNo: integer; AValue: String);
begin
  StoreElm(ARetNo, 'STATUS', c_LastYearElm, AValue);
end;

Function GetS9DonHigh(RetNo: integer): Real; // 20161126
Begin
  Result := VL(FetchElm(RetNo, 'S9', 15)); // line 17 of s9
end;

Function GetS9DonLow(RetNo: integer): Real; // 20161126
Begin
  Result := VL(FetchElm(RetNo, 'S9', 34)); // line 30 of of S9
end;

function AllowImportExport: Boolean; // 20171130 CON
Begin
  Result := false;
  If (LicenseList.Keys[AppT1_2026.AppId] = 'T105-2383-2118-0876') // taxtyme
    or (LicenseList.Keys[AppT1_2026.AppId] = 'T105-4244-3773-0984')
  // taxtyme  //20180225
  // Or (IsDeveloperLogin)
  then
    Result := true;
End;

function AllowExportToFile(ARetNo: integer): Boolean; // 20170112 Igor
Begin
  Result := IsBCJ = true;
  // 20191229 //((IsBCJ = True) AND (LicenseList.Keys[AppT1_2026.AppId]  = 'T106-2248-1998-1316')); // 2018 only    //20190108
  if Result AND (ARetNo <> 0) AND Assigned(RetList[ARetNo]) then
  Begin
    Result := not RetList[ARetNo].Changed;
    if Not Result then
      UserMsg('Export Data works only after SAVE RETURN and SIN is known');
  End;
End;

Function IncludeRc381InT1cPrintedForms(RetNo: integer): Boolean; // 20170204
Var
  Rc381FNo: integer;
Begin
  Result := false;
  Rc381FNo := GetFormNo('RC381');
  if (VL(FetchElm(RetNo, Rc381FNo, 4)) > 0) or
    (VL(FetchElm(RetNo, Rc381FNo, 30)) > 0) or
    (VL(FetchElm(RetNo, Rc381FNo, 77)) > 0) or
    (VL(FetchElm(RetNo, Rc381FNo, 78)) > 0) or
    (VL(FetchElm(RetNo, Rc381FNo, 107)) > 0) then
    Result := true;
End;

// 20170212 fix T929 from datavers 0.0 of T12016
Procedure FixT929(RetNo: integer);
Var
  i, j: integer;
  T929FNo: integer;
Begin
  T929FNo := GetFormNo('T929');
  if T929FNo < 1 then
    Exit;
  {
    StoreElm(RetNo,T929FNo,61,'');
    StoreElm(RetNo,T929FNo,63,'');
  }
  i := 24;
  j := 3;
  Repeat
    StoreElm(RetNo, T929FNo, i, '');
    StoreElm(RetNo, T929FNo, j, '');
    inc(i, 4);
    inc(j, 4);
  Until i > 76;

  StoreElm(RetNo, T929FNo, 2, '');
  StoreElm(RetNo, T929FNo, 9, '');
  StoreElm(RetNo, T929FNo, 10, '');
  StoreElm(RetNo, T929FNo, 13, '');
  StoreElm(RetNo, T929FNo, 14, '');
  StoreElm(RetNo, T929FNo, 17, '');
  StoreElm(RetNo, T929FNo, 18, '');
  StoreElm(RetNo, T929FNo, 46, '');
  StoreElm(RetNo, T929FNo, 49, '');
  StoreElm(RetNo, T929FNo, 50, '');
  StoreElm(RetNo, T929FNo, 53, '');
  StoreElm(RetNo, T929FNo, 78, '');
  StoreElm(RetNo, T929FNo, 57, '');
  StoreElm(RetNo, T929FNo, 54, '');
End;

// 20170218
Function ValidateDcn(RetNo: integer): Boolean;
Var
  S: String;
Begin
  Result := false;
  S := MidStr(FetchElm(RetNo, 'T183', 21), 6, 2);
  if S = '' then
  begin
    Result := true;
    Exit;
  End;
  If Ret[RetNo].EfStatus = '02' then
  begin
    Result := true;
    Exit;
  End;
  If S = RightStr(AppYear, 2) then
    Result := true;
End;

// 20170316
Function ValidatePadPaymentDate(SignDate, PayDay: String): integer;
Var
  D1, D2: String;
  DD, MM, YYYY: String;
  NumHolidays: integer;
  MinBusDays: integer;
Begin
  MinBusDays := 5;
  Result := 0;

  DD := RightStr(PayDay, 2);
  MM := MidStr(PayDay, 6, 2);

  if IsHoliday(PayDay) then
  begin
    Result := 1;
    Exit;
  end; // 1=holiday

  YYYY := LeftStr(PayDay, 4);
  D2 := MM + '/' + DD + '/' + YYYY;

  if SignDate = '' then
    SignDate := '2015-01-01';

  DD := RightStr(SignDate, 2);
  MM := MidStr(SignDate, 6, 2);
  YYYY := LeftStr(SignDate, 4);
  D1 := MM + '/' + DD + '/' + YYYY;
  Result := DateDiffMDY(D1, D2); // +1;

  if IsHoliday(PayDay) then
    MinBusDays := MinBusDays + 1;
  if Result < MinBusDays then
  begin
    Result := 2;
    Exit;
  end; // days < 5   //2 = must be 5 days in future

End;

Function IsHoliday(Dt: String): Boolean;
var
  DD, MM, YYYY, mmdd: String;
Begin
  if Length(Dt) <> 10 then
  begin
    Result := false;
    Exit;
  end;
  DD := RightStr(Dt, 2);
  MM := MidStr(Dt, 6, 2);
  YYYY := LeftStr(Dt, 4);

  mmdd := MM + '-' + DD;
  if mmdd = '01-01' then
  begin
    Result := true;
    Exit;
  end; // Jan 1 new year
  if mmdd = '04-14' then
  begin
    Result := true;
    Exit;
  end; // good friday
  if mmdd = '04-17' then
  begin
    Result := true;
    Exit;
  end; // eastern monay
  if mmdd = '05-22' then
  begin
    Result := true;
    Exit;
  end; // victoria day
  if mmdd = '06-01' then
  begin
    Result := true;
    Exit;
  end; // canada day
  if mmdd = '09-04' then
  begin
    Result := true;
    Exit;
  end; // labour day
  if mmdd = '10-09' then
  begin
    Result := true;
    Exit;
  end; // thanks giving day
  if mmdd = '11-11' then
  begin
    Result := true;
    Exit;
  end; // rememberance day
  if mmdd = '12-25' then
  begin
    Result := true;
    Exit;
  end; // christmas day
  if mmdd = '12-26' then
  begin
    Result := true;
    Exit;
  end; // Boxing day
End;

// 20170320
Function IsForRefile(RetNo: integer): Boolean;
var
  S: String;
Begin
  Result := false;
  // R1 to R9)
  S := FetchElm(RetNo, 'INFO', 223);
  if (UpperCase(LeftStr(S, 1)) = 'R') and Numeric(MidStr(S, 2, 1)) then
    Result := true;
  // if FetchElm(RetNo,'INFO', 79)>'' then Result:=True;
End;

// 20170322
Procedure NetListToREFILEV(RetNo: integer; FNo: integer; NetList: TStringList;
  FromNetListNdx: integer);
Var
  i, k, j: integer;
  Ln: String;
  PrevAmount, RevisedAmount: Real;
begin
  FormatSettings.DecimalSeparator := '.'; // 20150727
  i := 23; // ln ndx in form
  j := FromNetListNdx; // where to start on netlist
  Repeat
    Ln := AllTrim(LeftStr(NetList[j], 6));
    If Ln = '' then
      Ln := AllTrim(MidStr(NetList[j], 21, 6));
    PrevAmount := VL(AllTrim(MidStr(NetList[j], 7, 13)));
    RevisedAmount := VL(AllTrim(MidStr(NetList[j], 27, 13)));
    If PrevAmount <> RevisedAmount then
    begin
      StoreElm(RetNo, FNo, i, Ln);
      StoreElm(RetNo, FNo, i + 2, FormatFloat('########.##', PrevAmount));
      StoreElm(RetNo, FNo, i + 4, FormatFloat('########.##', RevisedAmount));
      StoreElm(RetNo, FNo, i + 3, FormatFloat('########.##',
        RevisedAmount - PrevAmount));
      inc(i, 5);
    end;
    inc(j, 1);
  until (i > 108) or (j > NetList.Count - 1);
end;

Procedure GetREFILEVNetList(BeforeList, AfterList: TStringList;
  Var NetList: TStringList);
Var
  i, j: integer;
  Ln1, Ln2: integer;
  TempList: TStringList;
  PrevAmount, RevisedAmount: Real;
begin
  NetList.Clear;
  i := 0;
  j := 0;
  Repeat
    If i > BeforeList.Count - 1 then
      i := 9999;
    If j > AfterList.Count - 1 then
      j := 9999;
    If (i >= 9999) or (j >= 9999) then
      Break;
    Ln1 := MyStrToInt(AllTrim(LeftStr(BeforeList[i], 6)));
    Ln2 := MyStrToInt(AllTrim(LeftStr(AfterList[j], 6)));
    If Ln1 > Ln2 then // only in afterlist
    begin
      NetList.Add(Space(20) + AfterList[j]);
      inc(j);
    end
    else If Ln1 < Ln2 then // only in beforelist
    begin
      NetList.Add(BeforeList[i]);
      inc(i);
    end
    else If Ln1 = Ln2 then // in both
    begin
      NetList.Add(BeforeList[i] + ' ' + AfterList[j]);
      inc(i);
      inc(j);
    end;
  until (i >= 9999) or (j >= 9999);
  // process unfinished list
  If i >= 9999 then // only afterlist
  begin
    If j < 9999 then
    begin
      repeat
        NetList.Add(Space(20) + AfterList[j]);
        inc(j);
      until j > AfterList.Count - 1;
      j := 9999;
    end;
  end;
  If j >= 9999 then // only beforelist
  begin
    If i < 9999 then
    begin
      repeat
        NetList.Add(BeforeList[i]);
        inc(i);
      until i > BeforeList.Count - 1;
      i := 9999;
    end;
  end;

  // remove the equal
  TempList := TStringList.Create;
  i := 0;
  Repeat
    PrevAmount := VL(AllTrim(MidStr(NetList[i], 7, 13)));
    RevisedAmount := VL(AllTrim(MidStr(NetList[i], 27, 13)));
    If PrevAmount <> RevisedAmount then
      TempList.Add(NetList[i]);
    inc(i);
  until i > NetList.Count - 1;

  NetList.Clear;
  For i := 0 to TempList.Count - 1 do
    NetList.Add(TempList[i]);
  TempList.Free;
end;

// ------------------------------------
Function InitializeRefileReturn(RetNo: integer): string;
// ;RefileFolder:String): String; //20240606
// 20170811 Igor >>>
Var
  FNo, LineNo: integer;
  Err, RefiledDir, S, DCN, Vers, InitialFileName, InitialDataDir: String;
Begin
  Result := '';
  FNo := GetFormNo('REFILEQ');
  // create the refileBackUp

  // RefiledDir := MkRefiledDir;  //20240607
  RefiledDir := MkRefiledDir(FetchElm(RetNo, 'REFILEQ', 102)); // 20240607

  If not SysUtils.FileExists(IncludeTrailingPathDelimiter(RefiledDir) +
    ClientsDBLite) then
  begin
    If not SysUtils.DirectoryExists(RefiledDir) then
      If not InitDataBase(RefiledDir, Err) then // 20170927 igor
      begin
        MessageDlg(Err, mtError, [mbOk], 0);
        Exit;
      end;
  end;
  // ----- DCN  issues
  DCN := UpperCase(FetchElm(RetNo, FNo, 101));
  if DCN.Trim.IsEmpty then
    DCN := FetchElm(RetNo, 'T183', 36);
  // If it was preserved when return was initially Efiled - Started March 20, 2017

  if Length(DCN) <> 13 then
  begin
    ShowMessage('Please provide the 13 character DCN of the initial return');
    Exit;
  End; // dcn problem

  if MidStr(DCN, 6, 2) <> RightStr(AppYear, 2) then
  Begin
    ShowMessage('The DCN is incorrect');
    Exit;
  End;

  If UpperCase(LeftStr(DCN, 5)) <> UpperCase(GetEfilerNo) then
  Begin
    ShowMessage('The DCN number does not seem correct and Refile will fail.' +
      Chr(13) + 'It does not have your Efiler Number in the first 5 characters');
    Exit;
  End;

  if IsForRefile(RetNo) then
    if MessageDlg
      ('This appears to be an already Refiled return or in the process of being ReFiled'
      + Chr(13) +
      'If already Refiled, do you want to ReFile it again with new amendments?',
      mtInformation, [mbYes, mbNo], 0) <> mrYes then
      Exit;

  // ------------------

  if IsBankruptcyReturn(RetNo) Or IsPreBankruptcyReturn(RetNo) Or
    IsPostBankruptcyReturn(RetNo) then
    Exit('Not allowed to ReFILE a Bankruptcy return');
  // dcn probem,

  If Immigrant(RetNo) Or Emigrant(RetNo) Then
    Exit('Not allowed to ReFILE:' + Chr(13) + ' ' + Chr(13) +
      'A newcomer to Canada' + Chr(13) + 'Or' + Chr(13) +
      'an individual who left Canada during the year');

  if IsNonResident(RetNo) then
    Exit('Not allowed to ReFILE a non-resident or deemed resident');

  If IsMultJurisdiction(RetNo) then
    Exit('Not allowed to ReFILE:' + Chr(13) +
      'a Multiple Jurisdictions return (T2203)');

  if GetRefileVersion(RetNo) > 'R9' then
  Begin
    ShowMessage
      ('The return exceeded 9 revisions. You cannot ReFILE, submit paper return');
    Exit;
  End;

  CreateSnapshot(RetNo, 'B'); // 20170404

  // ONCE DCN is corect COPY the initial return to Refiled folder
  // InitialFileName:=Ret[RetNo].SourceDataDir+'\'+Ret[RetNo].SourceFlName;
  if MessageDlg
    ('This initial return will be backed-up in the RefiledReturns folder' +
    Chr(13) + RefiledDir + Chr(13) +
    'where the before ReFile returns are kept and the new return will be created'
    + Chr(13) + 'Proceed now?', mtInformation, [mbYes, mbNo], 0) = mrYes then
  Begin
    Begin
      InitialFileName := Ret[RetNo].SourceFlName;
      InitialDataDir := Ret[RetNo].SourceDataDir;
      Vers := AllTrim(GetRefileVersion(RetNo));
      If SaveReturn(RetNo, RefiledDir, InitialFileName + Vers, true, false) = 0
      then // save with proper version override
      begin
        If FileExists(InitialFileName) Then
          SysUtils.DeleteFile(IncludeTrailingPathDelimiter(InitialDataDir) +
            InitialFileName);
        ShowMessage('Initial tax return has been moved to ' + RefiledDir);
      end
      Else
      Begin
        ShowMessage('Initial tax return can not be saved/backed-up to ' +
          RefiledDir);
      End;
    end;
    {
      // TFile.Copy(Ret[RetNo].SourceDataDir+'\'+Ret[RetNo].SourceFlName,
      RefiledDir+'\'+Ret[RetNo].SourceFlName,True); //for override
      //If FileExists(InitialFileName) Then SysUtils.DeleteFile(InitialFileName);
      ShowMessage('Initial tax return has been moved to '+RefiledDir);
      End;
      Except
      ShowMessage('Initial file could not be Copied to the ReFiledReturns folder');
      Exit;
      End;
    }
  End;

  // ---------------------- after validations/eligibility
  // Now Prepare and save the new return and capture some values
  UnlockReturn(RetNo);
  If Length(DCN) = 13 then
    StoreElm(RetNo, GetFormNo('T183'), 21, DCN); // retain the DCN
  StoreElm(RetNo, GetFormNo('T183'), 9, AppYear + 'R');
  SetRefileVersion(RetNo); // into fiels 223 of INFO R1, R2 etc.
  Ret[RetNo].PrPStatus := '00';
  Ret[RetNo].EfStatus := '00';

  // prepare the diffrences
  // 245, 208, 129, 316 and 318, 330 and 331
  StoreElm(RetNo, FNo, 91, FormatFloat('#########.##', Ret[RetNo].Lnn[24500]));
  StoreElm(RetNo, FNo, 92, FormatFloat('#########.##', Ret[RetNo].Lnn[20800]));
  StoreElm(RetNo, FNo, 93, FormatFloat('#########.##', Ret[RetNo].Lnn[12900]));
  StoreElm(RetNo, FNo, 94, FormatFloat('#########.##', Ret[RetNo].Lnn[31600] +
    Ret[RetNo].Lnn[31800]));
  StoreElm(RetNo, FNo, 95, FormatFloat('#########.##', Ret[RetNo].Lnn[33099] +
    Ret[RetNo].Lnn[33199]));

  // split pension //116, 210
  StoreElm(RetNo, FNo, 105, FormatFloat('#########.##', Ret[RetNo].Lnn[11600]));
  StoreElm(RetNo, FNo, 106, FormatFloat('#########.##', Ret[RetNo].Lnn[21000]));
  // force it into the T1032
  // NON cap and net cap losses
  StoreElm(RetNo, FNo, 107, FormatFloat('#########.##',
    VL(FetchElm(RetNo, 'T1A', 44))));
  StoreElm(RetNo, FNo, 108, FormatFloat('#########.##',
    VL(FetchElm(RetNo, 'T1A', 45))));
  StoreElm(RetNo, FNo, 109, FormatFloat('#########.##',
    VL(FetchElm(RetNo, 'T1A', 46))));

  StoreElm(RetNo, FNo, 110, FormatFloat('#########.##',
    VL(FetchElm(RetNo, 'T1A', 121))));
  StoreElm(RetNo, FNo, 111, FormatFloat('#########.##',
    VL(FetchElm(RetNo, 'T1A', 123))));
  StoreElm(RetNo, FNo, 112, FormatFloat('#########.##',
    VL(FetchElm(RetNo, 'T1A', 125))));

  // diab credit

  CalcFullReturn(RetNo);
  Ret[RetNo].Changed := true; // 20170404

  if SaveReturn(RetNo, InitialDataDir, InitialFileName, true, false) <> 0 then
    Exit('The return for ReFILE cannot be saved')
  else
    ShowMessage
      ('The return for ReFILE is now ready for revisions and then ReFILE');
  // ShowMessage('The return for ReFILE has been saved as '+Ret[RetNo].SourceFlName+Chr(13)+'waiting for revisions and ReFILE');
  OpenForm(RetNo, 'REFILEQ', 0);
  // 20170811 Igor<<<
End;

Function ValidateRefileReturn(RetNo: integer; DCN: String): String;
Var
  LineNo: integer;
  RefileFNo: integer;
  ReplySurvey: Boolean;
Begin
  Result := '';
  RefileFNo := GetFormNo('REFILEQ');

  REFILEQ(RetNo, 'REFILEQ', RefileFNo); // 20170329  //recalc

  if FetchElm(RetNo, RefileFNo, 9) > '' then
    ReplySurvey := true
  else
    ReplySurvey := false;

  if Length(DCN) <> 13 then
  begin
    Result := 'Please provide the 13 character DCN of the initial return';
    // ShowMessage(result);
    Exit;
  End; // dcn probem,

  // 20170402
  if FetchElm(RetNo, 'T183', 21) <> FetchElm(RetNo, 'REFILEQ', 101) then
  begin
    Result := 'Please initialize the return first';
    Exit;
  end;

  if (IsBankruptcyReturn(RetNo)) Or (IsPreBankruptcyReturn(RetNo)) Or
    (IsPostBankruptcyReturn(RetNo)) then
  begin
    Result := 'Not allowed to ReFILE a Bankruptcy return';
    Exit;
  End; // dcn probem,

  If (Immigrant(RetNo)) Or (Emigrant(RetNo)) Then
  Begin
    Result := 'Not allowed to ReFILE:' + Chr(13) + ' ' + Chr(13) +
      'A newcomer to Canada' + Chr(13) + 'Or' + Chr(13) +
      'an individual who left Canada during the year';
    Exit;
  End;

  if IsNonResident(RetNo) then
  Begin
    Result := 'Not allowed to ReFILE a non-resident or deemed resident';
    Exit;
  End;

  If IsMultJurisdiction(RetNo) then
  Begin
    Result := 'Not allowed to ReFILE:' + Chr(13) +
      'a Multiple Jurisdictions return (T2203)';
    Exit;
  End;


  // Now Prepare and save the new return and capture some values
  // 245, 208, 129, 316 and 318, 330 and 331
  // survey

  Result := '';
  if ReplySurvey = true then
  Begin
    If VL(FetchElmFNo(RetNo, RefileFNo, 91)) <> Ret[RetNo].Lnn[24500] then
    Begin
      If FetchElmFNo(RetNo, RefileFNo, 1) = '' then
        Result := 'Please complete Survey question 1';
    end;

    If VL(FetchElmFNo(RetNo, RefileFNo, 92)) <> Ret[RetNo].Lnn[20800] then
    begin
      If FetchElmFNo(RetNo, RefileFNo, 2) = '' then
        Result := Result + Chr(13) + 'Please complete Survey question 2';
    End;

    If VL(FetchElmFNo(RetNo, RefileFNo, 93)) <> Ret[RetNo].Lnn[12900] then
    Begin
      If FetchElmFNo(RetNo, RefileFNo, 3) = '' then
        Result := Result + Chr(13) + 'Please complete Survey question 3';
    end;

    If VL(FetchElmFNo(RetNo, RefileFNo, 94)) <> Ret[RetNo].Lnn[31600] +
      Ret[RetNo].Lnn[31800] then
    Begin
      If FetchElmFNo(RetNo, RefileFNo, 4) = '' then
        Result := Result + Chr(13) + 'Please complete Survey question 4';
    End;

    If VL(FetchElmFNo(RetNo, RefileFNo, 95)) <> Ret[RetNo].Lnn[33099] +
      Ret[RetNo].Lnn[33199] then
    Begin
      If FetchElmFNo(RetNo, RefileFNo, 5) = '' then
        Result := Result + Chr(13) + 'Please complete Survey question 5';
    End;

  end;
  OpenForm(RetNo, 'REFILEQ', 0); // 20170329
End;

Function MkRefiledDir(DataDir: String): String; // 20240607
Var
  Err: String;
Begin
  // 20170811 Igor>>>
  // TPath.Combine(DefaultDataDir(AppT1_2026), 'RefiledReturns');  //20240607
  // 20210322
  // result := IncludeTrailingPathDelimiter(AppDir) + 'RefiledReturns';
  If not SysUtils.DirectoryExists(DataDir) then
    SysUtils.ForceDirectories(DataDir);

  // 20210322 //If not SysUtils.DirectoryExists(Result) then SysUtils.ForceDirectories(Result);
  Result := DataDir;
  // 20210322
  If not TDirectory.Exists(DataDir) or
    not TFile.Exists(TPath.Combine(DataDir, ClientsDBLite)) then
  begin
    If not InitDataBase(DataDir, Err) then
    begin
      Errors.Log(Err);
      MessageDlg(Err, mtError, [mbOk], 0);
    end;
  end;
End;

(*
  Function MkRefiledDir); //(RefileFolder:String):String; //20240607
  Var Err, DataDir: String;
  Begin
  // 20170811 Igor>>>
  //DataDir:=OptRec.Dir_Cur+'\RefiledReturns'; //20240607
  TPath.Combine(DefaultDataDir(AppT1_2026), 'RefiledReturns');  //20240607
  // 20210322
  result := IncludeTrailingPathDelimiter(AppDir) + 'RefiledReturns';
  If not SysUtils.DirectoryExists(Result) then
  SysUtils.ForceDirectories(DataDir);

  // 20210322 //If not SysUtils.DirectoryExists(Result) then SysUtils.ForceDirectories(Result);
  Result := DataDir;
  // 20210322
  If not TDirectory.Exists(DataDir) or
  not TFile.Exists(TPath.Combine(DataDir, ClientsDBLite)) then
  begin
  If not InitDataBase(DataDir, Err) then
  begin
  Errors.Log(Err);
  MessageDlg(Err, mtError, [mbOk], 0);
  end;
  end;
  End;
*)
// 20170403
Procedure SetRefileVersion(RetNo: integer);
Var
  S: String;
  NewVers: String;
  // InfoFNo:Integer;
Begin
  // InfoFNo:=GetFormNo('INFO');
  S := FetchElmFNo(RetNo, InfoFNo, 223);
  if S = '' then
    NewVers := 'R1'
  Else if S = 'R1' then
    NewVers := 'R2'
  Else if S = 'R2' then
    NewVers := 'R3'
  Else if S = 'R3' then
    NewVers := 'R4'
  Else if S = 'R4' then
    NewVers := 'R5'
  Else if S = 'R5' then
    NewVers := 'R6'
  Else if S = 'R6' then
    NewVers := 'R7'
  Else if S = 'R7' then
    NewVers := 'R8'
  Else if S = 'R8' then
    NewVers := 'R9';
  StoreElm(RetNo, InfoFNo, 223, NewVers);
  // only 9 allowed  Logic must not save it or proceed - See Save in Initialize Refile
End;

Function GetRefileVersion(RetNo: integer): String;
Begin
  Result := FetchElm(RetNo, 'INFO', 223);
End;

Function L300ToL318(RetNo: integer): Real; // 20171113
// 20191120
Begin
  With Ret[RetNo] do
  Begin
    Result := Lnn[30000] + Lnn[30100] + Lnn[30300] + Lnn[30400] + Lnn[30425] +
      Lnn[30450] + Lnn[30500] + Lnn[30800] + Lnn[31000] + Lnn[31200] +
      Lnn[31217] + Lnn[31220] + Lnn[31240] + Lnn[31205] + Lnn[31210] +
      Lnn[31215] // 20180319  QC?
      + Lnn[31260] + Lnn[31270] + Lnn[31285] // +Lnn[364] //20181109
      + Lnn[31300] + Lnn[31400] + Lnn[31600] + Lnn[31800] +
      VL(FetchElm(RetNo, 'RC269', 10));
  End;
End;

Function L300ToL314(RetNo: integer): Real; // 20180319
Begin
  With Ret[RetNo] do
  Begin
    Result := Lnn[30000] + Lnn[30100] + Lnn[30300] + Lnn[30425] + Lnn[30400] +
      Lnn[30450] + Lnn[30400] + Lnn[30800] + Lnn[31000] + Lnn[31200] +
      Lnn[31217] + Lnn[31220] + Lnn[31240] + Lnn[31205] + Lnn[31210] +
      Lnn[31215] // qC?
      + Lnn[31260] + Lnn[31285] // +Lnn[364] //20181109
      + Lnn[31270] + Lnn[31300] + Lnn[31400] + VL(FetchElm(RetNo, 'RC269', 10));
  End;
End;

// 20171214
Function GetTestCaseId(RetNo: integer; Sin: String): String;
Var
  i: integer;
  TempList: TStringList;
  IdFlName, ReturnFlName: String;
Begin
  IdFlName := AppDir + '\' + 'TestCaseId.d';
  ReturnFlName := LeftStr(Sin, 8) + '.' + RightStr(Sin, 1);
  TempList := TStringList.Create;
  If FileExists(IdFlName) then
    TempList.LoadFromFile(IdFlName)
  else
  Begin
    ShowMessage(FlName + ' was not found');
    Exit;
  End;
  for i := 0 to TempList.Count - 1 do
  Begin
    if MidStr(TempList[i], 17, 10) = ReturnFlName then
    Begin
      Result := AllTrim(MidStr(TempList[i], 37, 5));
      TempList.Free;
      Exit;
    End;
  End;
  ShowMessage(FlName + ' was not found');
  TempList.Free;
End;

// 20180120
Function CalcPrvCareGvrClaim(RetNo: integer; Ni: Real;
  PercentClaim: Real): Real;
Var
  x: Real;
begin
  // ShowMessage('S5prv Ret[RetNo].Province= '+ret[RetNo].Province);
  // ShowMessage('Care givr base= '+FormatFloat('#########.##',PrvConstant[RY].PrvCareGvrBase));
  Result := 0; // 20170416
  If FullTONIProvince(RetNo) then
  begin
    x := MaxR(0, PrvConstant[RY].PrvCareGvrBase - Ni);
    Result := MinR(x, PrvConstant[RY].PrvMaxCareGvr * Ret[RetNo].PartYear);
    Result := (Result * PercentClaim) / 100;
  end;
  UndefMsg('CalcPrvCareGvrClaim');
end;

Function IsEfAccepted(RetNo: integer): Boolean; // 20160120
Begin
  Result := false;
  If FetchElm(RetNo, 'STATUS', 15) = '02' then
    Result := true;
end;

Function IsReturnAmended(RetNo: integer): Boolean; // 20160120
Begin
  Result := false;
  If FetchElm(RetNo, 'INFO', 223) > '' then
    Result := true;
End;

function CalcCheckDigitForT7DROCR(ALine: string): string; // 20180307 Igor
var
  cLine1, cLine2, cLine3, cLine4: string;
  nTotalSum: integer;

  function SumLine(ASumLine: string; AStartWeight: integer): integer;
  var
    i, nSum, Weight: integer;
  begin
    Result := 0;
    Weight := AStartWeight;
    for i := Low(ASumLine) to High(ASumLine) do
    begin
      nSum := StrToInt(ASumLine[i]) * Weight;
      if nSum >= 10 then
        nSum := nSum div 10 + nSum mod 10;
      Result := Result + nSum;
      if Weight = 2 then
        Weight := 1
      else
        Weight := 2;
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
  Result := IntToStr(10 - nTotalSum mod 10);
end;

Procedure CAREPRV(RetNo: integer; FName: string; FNo: integer);
var
  i, j, k, L, m, DFNo, FedCareFno: integer;
  Sw305: Boolean;
Begin
  Sw305 := false;
  // 20170509
  if IsMultJurisdiction(RetNo) = false then
    InitPrvConstants(Ret[RetNo].Province) // 20110310
  Else
    InitPrvConstants(T2203Prov); // 20110310
  // InitPrvConstants(ret[RetNo].Province);

  LoadTv(RetNo, FName, FNo);
  FedCareFno := GetFormNo('CAREGVR');
  { Copy from federal }
  For i := 1 to 61 do
    StoreElm(RetNo, FNo, i, FetchElmFNo(RetNo, FedCareFno, i));
  { Calculate }
  With Ret[RetNo].Frm[FNo] do
  begin
    Strings[70] := 'CAREGVR';
    Strings[67] := GetCarePrvHeader(RetNo);
    Tv[68] := PrvConstant[RY].PrvCareGvrBase;
    Tv[69] := PrvConstant[RY].PrvCareGvrBase;
    For i := 1 to 61 do
    begin
      Strings[i] := '';
      Tv[i] := 0;
    end;
    { bring from DEPEND }
    i := 5; { index to depend elm }
    j := 1; { index to CAREGVR elm }
    k := 191; // 20180113 //141; {index to depend caregiver elm}
    L := 62;
    m := 263; // indx to Elig dep
    DFNo := GetFormNo('DEPEND');
    Repeat
      // 20171128
      If (UpperCase(FetchElmFNo(RetNo, DFNo, k)) = 'Y') // caregivr claim
      // and (FetchElmFNo(RetNo,DFNo,i+14)<>'Y')  //NOT elig depenant (other than ONT
        and (VL(FetchElmFNo(RetNo, DFNo, m)) >= 18) // age >=18
      then
      begin
        if (Ret[RetNo].Province <> 'ON') // 20180113
        {
          if (Ret[RetNo].Province='ON')  //elig or not elig
          Or ((Ret[RetNo].Province<>'ON') and (FetchElmFNo(RetNo,DFNo,i+14)<>'Y')) //not elig dependant
        }
        then
        Begin
          Strings[j] := FetchElmFNo(RetNo, DFNo, i + 1); { Last nm }
          Strings[j + 1] := FetchElmFNo(RetNo, DFNo, i); { First nm }
          Strings[j + 2] := FetchElmFNo(RetNo, DFNo, i + 5); { birthdate }
          Strings[j + 3] := FetchElmFNo(RetNo, DFNo, i + 6); { relationship }
          Tv[j + 4] := VL(FetchElmFNo(RetNo, DFNo, i + 8)); { ni }
          Strings[j + 5] := FetchElmFNo(RetNo, DFNo, i + 7); { infirmity }
          Strings[j + 6] := FetchElmFNo(RetNo, DFNo, i + 9) { str }
            + ',' + FetchElmFNo(RetNo, DFNo, i + 10) { city }
            + ' ' + FetchElmFNo(RetNo, DFNo, i + 12) { prov }
            + ' ' + FetchElmFNo(RetNo, DFNo, i + 13); { postal }
          { copy % claim }
          Strings[L] := FetchElmFNo(RetNo, DFNo, i + 11);
        end;

        inc(j, 12);
        inc(L, 1);
        inc(m, 1);
      end;
      inc(i, 15);
      inc(k, 1);
    until (j > 49) or (i > 125);

    i := 0;
    Tv[61] := 0;
    k := 62;
    repeat
      If Strings[1 + i] > '' then
      begin
        Tv[8 + i] := PrvConstant[RY].PrvCareGvrBase;
        Tv[9 + i] := Tv[5 + i];
        Tv[10 + i] := MaxR(0, Tv[8 + i] - Tv[9 + i]);

        If Tv[10 + i] > PrvConstant[RY].PrvMaxCareGvr then
          Tv[10 + i] := PrvConstant[RY].PrvMaxCareGvr;

        If (Sw305 = false) and (Strings[i + 3] = FetchElm(RetNo, 'S5PRV', 6))
        { birthdate }
          and (UpperCase(Strings[i + 4]) = UpperCase(FetchElm(RetNo, 'S5PRV', 7)
          )) { relationship }
        then
        begin
          If FullTONIProvince(RetNo) then
            Tv[11 + i] := VL(FetchElm(RetNo, GetTax1FormName(RetNo), 29));
          Sw305 := true;
        end;
        Tv[12 + i] := MaxR(0, Tv[10 + i] - Tv[11 + i]);
        If (VL(Strings[k]) > 0) and (VL(Strings[k]) < 100) then
          Tv[12 + i] := Tv[12 + i] * VL(Strings[k]) / 100;

        Tv[61] := Tv[61] + Tv[12 + i];
      end
      else
        Tv[12 + i] := 0;
      inc(i, 12);
      inc(k, 1);
    until i > 48; { i starts with 0 }
  end;
  SaveTv(RetNo, FName, FNo);
  // T2203Prov:='';  //20180323
end;

(*
  //20180408
  function RunAsAdmin(hWnd: HWND; filename: string; Parameters: string): Boolean;
  //Source: * http://edn.embarcadero.com/article/33942
  {
  See Step 3: Redesign for UAC Compatibility (UAC)
  http://msdn.microsoft.com/en-us/library/bb756922.aspx
  }
  var
  sei: TShellExecuteInfo;
  begin
  ZeroMemory(@sei, SizeOf(sei));
  sei.cbSize := SizeOf(TShellExecuteInfo);
  sei.Wnd := hwnd;
  sei.fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI;
  sei.lpVerb := PChar('runas');
  sei.lpFile := PChar(Filename); // PAnsiChar;
  if parameters  '' then
  sei.lpParameters := PChar(parameters); // PAnsiChar;
  sei.nShow := SW_SHOWNORMAL; //Integer;

  Result := ShellExecuteEx(@sei);
  end;
*)

Procedure CreateNaicsFile; // 20180417
Var
  List1, List2: TStringList;
  i: integer;
  Dir, S, S1, S2: String;
Begin
  Dir := 'C:\Government Specs\2017-T1\Specifications';
  List1 := TStringList.Create;
  List2 := TStringList.Create;
  List1.LoadFromFile(Dir + '\Naics.txt');
  for i := 0 to List1.Count - 1 do
  Begin
    S1 := List1[i];
    S1 := ReplaceChar(S1, '"', '');
    if (Length(AllTrim(LeftStr(S1, 6))) < 4) Or
      (Length(AllTrim(LeftStr(S1, 6))) = 6) then
    Begin
      If Length(AllTrim(LeftStr(S1, 6))) = 2 then
        S2 := LeftStr(S1, 2) + ' ' + AllTrim(MidStr(S1, 8, 80));
      If Length(AllTrim(LeftStr(S1, 6))) = 3 then
        S2 := Space(1) + LeftStr(S1, 6) + Space(2) + AllTrim(MidStr(S1, 8, 80));
      If Length(AllTrim(LeftStr(S1, 6))) = 6 then
        S2 := Space(2) + LeftStr(S1, 6) + Space(2) + AllTrim(MidStr(S1, 8, 80));
      List2.Add(S2);
    End;
  End;
  List2.SaveToFile(Dir + '\Naics.txt2');
  ShowMessage('Done');
End;

Function GetBCTaxIncrease(RetNo: integer): Real; // 20180607 txbl over 108460
var
  x: Real;
  RateIncrease: Real;
Begin
  Result := 0; // 20200905
  RateIncrease := 20.5 - 16.8;
  x := Ret[RetNo].Lnn[26000] - 220000;
  if x > 0 then
    Result := x * RateIncrease / 100;
End;

Function IsForEfile(RetNo: integer): Boolean; // 20190124
Begin
  Result := true;
  if FetchElmFNo(RetNo, InfoFNo, 46) = '' then
    Result := false;
End;

function GetAiipHelp: Boolean; // 20190216
var
  h: THandle;
  url: String;
begin
  url := 'https://www.canada.ca/en/revenue-agency/services/tax/businesses/topics/sole-proprietorships-partnerships/'
    + 'report-business-income-expenses/claiming-capital-cost-allowance/accelerated-investment-incentive.html?utm_campaign=not-applicable&utm_medium=vanity-url&utm_source=canada-ca_taxes-accelerated-investment-income';
  Result := true;
  Screen.Cursor := crHourGlass;
  h := ShellExecute(Application.MainForm.Handle, 'open', PChar('' + url), nil,
    nil, SW_SHOW);
  Screen.Cursor := crDefault;
  if h <= 32 then
  begin
    ShowMessage('Connection failed');
    Result := false;
  end;
end;

Function GetSpouseAge(RetNo: integer): integer; // 20190317
Begin
  Result := CalcAge(FetchElm(RetNo, 'INFO', 59));
End;

Procedure UpdateAllIndicatorsForMJ(RetNo: integer); // 20190328
Begin
  if IsMultJurisdiction(RetNo) = false then
    Exit;

  Ret[RetNo].FrmHasData[GetFormNo('ON428')] := true;
  Ret[RetNo].FrmHasData[GetFormNo('AB428')] := true;
  Ret[RetNo].FrmHasData[GetFormNo('NL428')] := true;
  Ret[RetNo].FrmHasData[GetFormNo('PE428')] := true;
  Ret[RetNo].FrmHasData[GetFormNo('NS428')] := true;
  Ret[RetNo].FrmHasData[GetFormNo('NB428')] := true;
  Ret[RetNo].FrmHasData[GetFormNo('MB428')] := true;
  Ret[RetNo].FrmHasData[GetFormNo('SK428')] := true;
  Ret[RetNo].FrmHasData[GetFormNo('BC428')] := true;
  Ret[RetNo].FrmHasData[GetFormNo('YT428')] := true;
  Ret[RetNo].FrmHasData[GetFormNo('NT428')] := true;
  Ret[RetNo].FrmHasData[GetFormNo('NU428')] := true;
End;

Function GetBCSpouseCareGiver(RetNo: integer; PRV: String): Real; // 20190403
Var
  x: Real;
Begin
  Result := 0;
  x := 0; // 20190411
  if (FetchElmFNo(RetNo, InfoFNo, 32) > '') // spouse elg for caregiver then
    and (PRV = 'BC') And (Ret[RetNo].MarStatus < 3) then
    x := CalcPrvCareGvrClaim(RetNo, VL(FetchElmFNo(RetNo, InfoFNo, 19)), 100);
  // net inc and %)
  Result := MaxR(0, x - VL(FetchElm(RetNo, 'BC428', 28)));
  // deduct spousal at 5812
End;

Procedure InitTransfForm(RetNo: integer); // 20190405
Var
  TransfFNo: integer;
Begin
  TransfFNo := GetFormNo('TRANSF');
  if ((FetchElmFNo(RetNo, TransfFNo, 158) = '') or
    (FetchElmFNo(RetNo, TransfFNo, 158) = 'N')) // direct
    and ((FetchElmFNo(RetNo, TransfFNo, 1) = '') or
    (FetchElmFNo(RetNo, TransfFNo, 1) = 'N')) // fill names
    and ((FetchElmFNo(RetNo, TransfFNo, 79) = '') or
    (FetchElmFNo(RetNo, TransfFNo, 79) = 'N')) // tax amounts
  then
  begin
    StoreElm(RetNo, TransfFNo, 1, 'Y');
    StoreElm(RetNo, TransfFNo, 79, 'Y');
  end;
End;

function EligibleSpouseForS14(RetNo: integer): Boolean;
// climate credit //20190217
Begin
  Result := true;
  if (Ret[RetNo].MarStatus > 2) or (FetchElmFNo(RetNo, InfoFNo, 215) > '')
  // entry to canada   /20190218
    or (FetchElmFNo(RetNo, InfoFNo, 167) > '') // prison or non resident
    Or ((FetchElmFNo(RetNo, InfoFNo, 65) > '') and
    (FetchElmFNo(RetNo, InfoFNo, 65) < '2019-04-01')) // 20190405
  then
  begin
    Result := false;
    Exit;
  End;
End;

function EligibleForS14(RetNo: integer): Boolean; // climate credit //20190217
Begin
  if ((Ret[RetNo].Province = 'ON') or (Ret[RetNo].Province = 'AB') // 20191110
    or (Ret[RetNo].Province = 'MB') or (Ret[RetNo].Province = 'NB') or
    (Ret[RetNo].Province = 'SK')) then
    Result := true;

  // exceptions
  // 20190405
  If IsNonResident(RetNo) then
  Begin
    Result := false;
    Exit;
  end; // No elig dep  Exit; //20190407
  if (Ret[RetNo].Age < 18) then
  Begin
    If (Ret[RetNo].MarStatus > 2) and (VL(FetchElm(RetNo, 'DEPEND', 3)) = 0)
    then
    Begin
      Result := false;
      Exit;
    end; // No elig dep  Exit;
  End;
  // 20190406
  if (FetchElmFNo(RetNo, InfoFNo, 24) > '') and
    (FetchElmFNo(RetNo, InfoFNo, 24) < '2019-04-01') then
  Begin
    Result := false;
    Exit;
  end; // death before Apr 1 2019

  if (FetchElmFNo(RetNo, InfoFNo, 166) > '') // in prison
    or (FetchElmFNo(RetNo, InfoFNo, 26) > '') // entry to can
    or (FetchElmFNo(RetNo, InfoFNo, 28) > '') // exit from can
  then
  Begin
    Result := false;
    Exit;
  end;

End;

Procedure InitS14Form(RetNo: integer); // 20190405
Var
  FNo: integer;
Begin
  Exit; // 20190405

  FNo := GetFormNo('S14' + Ret[RetNo].Province);
  if FNo = 0 then
    Exit;

  if EligibleForS14(RetNo) = false then
  begin
    StoreElm(RetNo, FNo, 20, 'N');
    Exit;
  End
  Else
  begin
    StoreElm(RetNo, FNo, 20, 'Y');
    Exit;
  End;
  // eligible
  if FetchElmFNo(RetNo, FNo, 20) = '' then
    StoreElm(RetNo, FNo, 20, 'Y');
End;

(*
  //20190421
  Function AddNextInstance(RetNo:Integer;FormName:String):Integer;
  Var NewFNo:Integer;CInst:Integer;NewFormName:String;
  Begin
  NewFNo := RetList[RetNo].GetFormNo(FormName); //  //GetFormNo(RetNo,FormName);
  CInst := ExtractFormInstNo(FormName);
  NewFormName := ExtractNonInstFormName(FormName) + '#' + IntToStr(CInst + 1);
  NewFNo := RetList[RetNo].GetFormNo(NewFormName); //GetFormNo(RetNo, NewFormName);
  if NewFNo = 0 then {instance does not exist}
  begin
  if IsFormMultipage(FormName) then {do all pages}
  begin
  {
  AddPageInstance(ExtractFormRootName(FormName) + '_1','#' + IntToStr(CInst + 1));
  AddOtherPagesInstance(ExtractFormRootName(FormName) + '_1','#' + IntToStr(CInst + 1));
  NewFNo := GetFormNo(RetNo,ExtractFormRootName(FormName) + '_1' +'#' + IntToStr(CInst + 1));
  }
  end
  else
  NewFNo := RetList[RetNo].AddPageInstance(ExtractNonInstFormName(FormName),'#' + IntToStr(CInst + 1));
  end;
  Result:=NewFNo;
  End;
*)

// 20190421
Function AddNextInstance(RetNo: integer; FormName: String): integer;
Var
  NewFNo: integer;
  CInst: integer;
  NewFormName: String;
Begin
  NewFNo := RetList[RetNo].GetFormNo(FormName); // //GetFormNo(RetNo,FormName);
  CInst := ExtractFormInstNo(FormName);
  NewFormName := ExtractNonInstFormName(FormName) + '#' + IntToStr(CInst + 1);
  NewFNo := RetList[RetNo].GetFormNo(NewFormName);
  // GetFormNo(RetNo, NewFormName);
  if NewFNo > 0 then // exists
    // do nothing
  Else
    NewFNo := RetList[RetNo].AddPageInstance(ExtractNonInstFormName(FormName),
      '#' + IntToStr(CInst + 1));

  Result := NewFNo;
End;

Function GetOn479ARate(FamIncome: Real): Real;
Var
  i: integer;
  S: String;
  RatesList: TStringList;
  FromAmount, toAmount, Rate: Real;
  Found: Boolean;
Begin
  if FamIncome <= 20000 then
  begin
    Result := 75;
    Exit;
  end; // 20200225
  if FamIncome > 150000 then
  begin
    Result := 0;
    Exit;
  end;

  RatesList := TStringList.Create;
  RatesList.LoadFromFile(AppDir + '\' + 'On479ARates.d');
  Found := false;
  for i := 1 to RatesList.Count - 2 do
  // ignore first and bottom lines, handlled above
  Begin
    S := RatesList[i];
    FromAmount := VL(AllTrim(LeftStr(S, 7)));
    toAmount := VL(AllTrim(MidStr(S, 8, 7)));
    Rate := VL(AllTrim(MidStr(S, 15, 2)));
    if (FamIncome > FromAmount) and (FamIncome <= toAmount) then
    begin
      Result := Rate;
      Found := true;
      Exit;
    end;
  End;
  if Found = false then
  Begin
    ShowMessage('CARE Rate not found');
  End;

End;

Function GetPrvNonRefUpToDisability(RetNo, PrvTaxFNo: integer): Real;
Var
  x: Real;
Begin
  x := 0;
  x := x + VL(FetchElmFNo(RetNo, PrvTaxFNo, 23)) +
    VL(FetchElmFNo(RetNo, PrvTaxFNo, 24)) + VL(FetchElmFNo(RetNo, PrvTaxFNo, 28)
    ) + VL(FetchElmFNo(RetNo, PrvTaxFNo, 29)) +
    VL(FetchElmFNo(RetNo, PrvTaxFNo, 30)) + VL(FetchElmFNo(RetNo, PrvTaxFNo, 31)
    ) + VL(FetchElmFNo(RetNo, PrvTaxFNo, 32)) +
    VL(FetchElmFNo(RetNo, PrvTaxFNo, 33));

  If Ret[RetNo].Province = 'AB' then
  Begin
    x := x + VL(FetchElmFNo(RetNo, PrvTaxFNo, 4)) +
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 51));
  End;

  If Ret[RetNo].Province = 'BC' then
  Begin
    x := x + VL(FetchElmFNo(RetNo, PrvTaxFNo, 82)) + // BC
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 86)) + // BC
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 87)) + // BC
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 51)); // BC
  End;

  If Ret[RetNo].Province = 'NL' then
  Begin
    x := x + VL(FetchElmFNo(RetNo, PrvTaxFNo, 89)) +
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 90)) +
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 48)) +
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 91)) +
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 51));
  End;

  If Ret[RetNo].Province = 'NB' then
  Begin
    x := x + VL(FetchElmFNo(RetNo, PrvTaxFNo, 86));
  End;

  If Ret[RetNo].Province = 'NS' then
  Begin
    x := x + VL(FetchElmFNo(RetNo, PrvTaxFNo, 74)) +
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 161));
  End;

  If Ret[RetNo].Province = 'NT' then
  Begin
    x := x + VL(FetchElmFNo(RetNo, PrvTaxFNo, 51));
  End;

  If Ret[RetNo].Province = 'NU' then
  Begin
    x := x + VL(FetchElmFNo(RetNo, PrvTaxFNo, 73)) +
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 79));
  End;

  If Ret[RetNo].Province = 'MB' then
  Begin
    x := x + VL(FetchElmFNo(RetNo, PrvTaxFNo, 68)) +
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 77)) +
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 78)) +
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 67)) +
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 74)) +
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 51));
  End;

  If Ret[RetNo].Province = 'ON' then
  Begin
    x := x + VL(FetchElmFNo(RetNo, PrvTaxFNo, 116)) + // ON
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 51)); // ON
  End;

  If Ret[RetNo].Province = 'PE' then
  Begin
    x := x + VL(FetchElmFNo(RetNo, PrvTaxFNo, 68)) +
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 80));
  End;

  If Ret[RetNo].Province = 'SK' then
  Begin
    x := x + VL(FetchElmFNo(RetNo, PrvTaxFNo, 66)) +
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 67)) +
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 83)) +
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 84));
  End;

  If Ret[RetNo].Province = 'YT' then
  Begin
    x := x + VL(FetchElmFNo(RetNo, PrvTaxFNo, 35)) +
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 25)) +
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 64)) +
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 73)) +
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 65)) +
      VL(FetchElmFNo(RetNo, PrvTaxFNo, 51));
  End;

  // common
  x := x + VL(FetchElmFNo(RetNo, PrvTaxFNo, 34)) +
    VL(FetchElmFNo(RetNo, PrvTaxFNo, 36)) + VL(FetchElmFNo(RetNo, PrvTaxFNo, 37)
    ) + VL(FetchElm(RetNo, 'RC269', 10)) + Ret[RetNo].Lnn[31217];
  // this is field 64?

  Result := x;
End;

Function ReadyForT1135Efile(RetNo: integer): Boolean; // 20200207
Var
  FNo: integer;
Begin
  Result := false;
  FNo := GetFormNo('T1135');
  if FetchElmFNo(RetNo, FNo, 36) + FetchElmFNo(RetNo, FNo, 42) +
    FetchElmFNo(RetNo, FNo, 34) + FetchElmFNo(RetNo, FNo, 86) > '' then
    Result := true;
End;

Function EligibleForChildCareRelief(RetNo: integer): Boolean; // 20200225
Var
  FNo, SpRetNo: integer;
  AdjFamIncome: Real;
Begin
  Result := true;
  if Ret[RetNo].Province <> 'ON' then
  begin
    Result := false;
    Exit;
  end; // no child care claimed
  if Ret[RetNo].Lnn[21400] <= 0 then
  begin
    Result := false;
    Exit;
  end; // no child care claimed

  FNo := GetFormNo('ON479A');
  AdjFamIncome := 0;

  AdjFamIncome := AdjFamIncome + Ret[RetNo].Lnn[23600];
  AdjFamIncome := AdjFamIncome + Ret[RetNo].Lnn[21400];
  AdjFamIncome := AdjFamIncome + Ret[RetNo].Lnn[23500];
  If Ret[RetNo].CouplingSw then
  begin
    SpRetNo := GetSpRetNo(RetNo);
    if SpRetNo > 0 then
    Begin
      AdjFamIncome := AdjFamIncome + Ret[SpRetNo].Lnn[23600];
      AdjFamIncome := AdjFamIncome + Ret[SpRetNo].Lnn[21400];
      AdjFamIncome := AdjFamIncome + Ret[SpRetNo].Lnn[23500];
    End;
  end
  Else // no coupling
  Begin
    AdjFamIncome := AdjFamIncome + VL(FetchElmFNo(RetNo, FNo, 4));
    AdjFamIncome := AdjFamIncome + VL(FetchElmFNo(RetNo, FNo, 5));
    AdjFamIncome := AdjFamIncome + VL(FetchElmFNo(RetNo, FNo, 6));
  end;
  if AdjFamIncome > 150000 then
    Result := false
  else
    Result := true;
End;

// 20200307
Function CalcPartYear(RetNo: integer): Real;
Var
  DaysInCan: integer;
  x: Real;
Begin
  DaysInCan := CalcDaysInCan(RetNo);
  If UpperCase(FetchElmFNo(RetNo, InfoFNo, 73)) = 'X' then
    DaysInCan := 0;
  x := DaysInCan / Constant[RY].FullYear; // 20200307
  Result := x;
end;

function GetSignatureFolderPath(LastName: String; FirstName: String): String;
// 20210331 Igor
begin
  if LastName.IsEmpty and FirstName.IsEmpty then
    Result := OptRec.Dir_ClientDocs
  else
    Result := OptRec.Dir_ClientDocs + '\' + LastName + ',' + FirstName;
end;

Function GetSignatureFilePath(LastName: String; FirstName: String): String;
// 20200320
Var
  Folder, FullName: String;
Begin
  Result := '';
  // 20210126 Igor >>>
  Folder := GetSignatureFolderPath(LastName, FirstName);
  // 20200419 //20210331 Igor

  // 20210126 Igor <<<
  // 202210226
  FullName := Folder + '\' + 'Signature.bmp';
  if FileExists(FullName) then
  begin
    Result := FullName;
    Exit;
  end;
  FullName := Folder + '\' + 'Signature.jpg';
  if FileExists(FullName) then
  begin
    Result := FullName;
    Exit;
  end;
  FullName := Folder + '\' + 'Signature.jpeg';
  if FileExists(FullName) then
  begin
    Result := FullName;
    Exit;
  end;
  FullName := Folder + '\' + 'Signature.gif';
  if FileExists(FullName) then
  begin
    Result := FullName;
    Exit;
  end;
  FullName := Folder + '\' + 'Signature.png';
  if FileExists(FullName) then
  begin
    Result := FullName;
    Exit;
  end; // 20210302
  (*
    if FileExists(FullName) then begin Result:=FullName; exit;end
    else
    Begin
    FullName:=Folder+'\'+'Signature.jpg';
    if FileExists(FullName) then begin Result:=FullName; exit;end
    else
    begin
    FullName:=Folder+'\'+'Signature.png';
    if FileExists(FullName) then begin Result:=FullName; exit;end
    else
    begin
    FullName:=Folder+'\'+'Signature.GIF';
    if FileExists(FullName) then begin Result:=FullName; exit;end;
    end;
    end;
    end;
  *)
End;

(*
  Function GetSignatureFilePath(LastName: String; FirstName: String): String;// 20200320
  Var
  Folder, FullName: String;
  Begin
  Result := '';
  // 20210126 Igor >>>
  if LastName.IsEmpty and FirstName.IsEmpty then
  Folder := OptRec.Dir_ClientDocs
  else
  Folder := OptRec.Dir_ClientDocs + '\' + LastName + ',' + FirstName;
  // 20200419

  // 20210126 Igor <<<
  // 202210226
  FullName := Folder + '\' + 'Signature.bmp';
  if FileExists(FullName) then
  begin
  Result := FullName;
  exit;
  end;
  FullName := Folder + '\' + 'Signature.jpg';
  if FileExists(FullName) then
  begin
  Result := FullName;
  exit;
  end;
  FullName := Folder + '\' + 'Signature.jpeg';
  if FileExists(FullName) then
  begin
  Result := FullName;
  exit;
  end;
  FullName := Folder + '\' + 'Signature.gif';
  if FileExists(FullName) then
  begin
  Result := FullName;
  exit;
  end;
  FullName := Folder + '\' + 'Signature.png';
  if FileExists(FullName) then
  begin
  Result := FullName;
  exit;
  end; // 20210302
  {
  if FileExists(FullName) then begin Result:=FullName; exit;end
  else
  Begin
  FullName:=Folder+'\'+'Signature.jpg';
  if FileExists(FullName) then begin Result:=FullName; exit;end
  else
  begin
  FullName:=Folder+'\'+'Signature.png';
  if FileExists(FullName) then begin Result:=FullName; exit;end
  else
  begin
  FullName:=Folder+'\'+'Signature.GIF';
  if FileExists(FullName) then begin Result:=FullName; exit;end;
  end;
  end;
  end;
  }
  End;
*)

(* 20210126

  Function GetSignatureFilePath(LastName:String;FirstName:String):String;//20200320
  Var Folder,FullName:String;
  Begin
  Result:='';
  Folder:=OptRec.Dir_ClientDocs+'\'+LastName + ','+ FirstName;   //20200419
  //Folder:=OptRec.Dir_ClientDocs+'\'+GetLastName(retNo) + ','+ GetFirstName(retNo);
  // Folder:='C:\test';  ///remove
  //check both jpg and png
  FullName:=Folder+'\'+'Signature.bmp';
  if FileExists(FullName) then begin Result:=FullName; exit;end
  else
  Begin
  FullName:=Folder+'\'+'Signature.jpg';
  if FileExists(FullName) then begin Result:=FullName; exit;end
  else
  begin
  FullName:=Folder+'\'+'Signature.png';
  if FileExists(FullName) then begin Result:=FullName; exit;end
  else
  begin
  FullName:=Folder+'\'+'Signature.GIF';
  if FileExists(FullName) then begin Result:=FullName; exit;end;
  end;
  end;
  end;
  End;
*)
Function GetPreparerSignatureFilePath: String; // 20200320
Var
  Folder, FullName: String;
Begin
  Result := '';
  Folder := EXEDir;
  // check both jpg and png
  FullName := Folder + '\' + 'T1PreparerSignature.bmp';
  if FileExists(FullName) then
  begin
    Result := FullName;
    Exit;
  end
  else
  Begin
    FullName := Folder + '\' + 'T1PreparerSignature.jpg';
    if FileExists(FullName) then
    begin
      Result := FullName;
      Exit;
    end
    else
    begin
      FullName := Folder + '\' + 'T1PreparerSignature.png';
      if FileExists(FullName) then
      begin
        Result := FullName;
        Exit;
      end
      else
      begin
        FullName := Folder + '\' + 'T1PreparerSignature.GIF';
        if FileExists(FullName) then
        begin
          Result := FullName;
          Exit;
        end;
      end;
    end;
  end;
End;

Function GetMaxDisabForS2MJ(SpRetNo: integer; PRV: String): Real; // 20200410
Begin
  Result := 0;
  if SpRetNo > 0 then
  Begin
    InitPrvConstants(PRV);

    if FetchElm(SpRetNo, InfoFNo, 87) + FetchElm(SpRetNo, InfoFNo, 85) > '' then
    // current or permanent disabilty of spouse
    Begin
      If CalcAge(FetchElm(SpRetNo, InfoFNo, 9)) < 18 then
        Result := PrvConstant[RY].PrvMaxDisability + PrvConstant[RY]
          .PrvMaxDisabSupl18
      else
        Result := PrvConstant[RY].PrvMaxDisability;
    End;
  End;
end;

// 20200419
Function GetT1032TransferringSin(RetNo: integer): String;
Var
  T1032FNo: integer;
Begin
  Result := '';
  // T1032FNo:=GetFormNO('T1032');
  Result := FetchElm(RetNo, 'T1032', 4);
  // if FetchElmFNo(RetNo,T1032FNo,42)>'' then begin Result:=FetchElmFNo(RetNo,T1032FNo,4);Exit;End;
  // if FetchElmFNo(RetNo,T1032FNo,45)>'' then begin Result:=FetchElmFNo(RetNo,T1032FNo,9);Exit;End;
end;

// 20200419
Function GetT1032ReceivingSin(RetNo: integer): String;
// reverse to pick up spouse
Var
  T1032FNo: integer;
Begin
  Result := '';
  // T1032FNo:=GetFormNO('T1032');
  Result := FetchElm(RetNo, 'T1032', 9);
  // if FetchElmFNo(RetNo,T1032FNo,42)>'' then begin Result:=FetchElmFNo(RetNo,T1032FNo,47);Exit;End;
  // if FetchElmFNo(RetNo,T1032FNo,45)>'' then begin Result:=FetchElmFNo(RetNo,T1032FNo,44);Exit;End;
end;

(*
  Procedure SaveFormsToPdf(RetNo:Integer;FrmList:TStringList;Dir:String;FlName:String);
  Var i:Integer; PDF:TvtPDFPrinter;
  Begin
  PDF := TvtPDFPrinter.Create(AppT1_2026);
  for i:=0 to FrmList.Count-1 do
  Begin
  PDF.PrintForm(RetNo, FName, 99, T1_2026Print.AfterReadComponentForPrint,
  T1_2026Print.PrintEditBox, T1_2026Print.PrepareRichEdit,
  T1_2026Print.PrintImageT1, T1_2026Print.PrintHeader);
  PDF.SaveToFile(Dir+'/'+FlName,false);
  End;
  End;
*)

// 20200426
function CopyDir(const fromDir, toDir: string): Boolean;
var
  fos: TSHFileOpStruct;
begin
  ZeroMemory(@fos, Sizeof(fos));
  with fos do
  begin
    wFunc := FO_COPY;
    fFlags := FOF_FILESONLY;
    pFrom := PChar(fromDir + #0);
    pTo := PChar(toDir)
  end;
  Result := (0 = ShFileOperation(fos));
end;

function HideSin(RetNo: integer): Boolean; // 20200430
begin
  Result := false;
  if OptRec.Prn_HideSin then
    Result := true; // 20200601

  {
    If (UpperCase(FetchElmFno(RetNo,InfoFNo,144))='Y') //use  e-signature
    and (UpperCase(FetchElmFno(RetNo,InfoFNo,154))='Y') //hide
    then Result :=True;
  }
end;

function GetHiddenSin(Sin: String): String; // 20200430
begin
  if Sin = '' then
  begin
    Result := '';
    Exit;
  end;
  Result := 'XXX XX' + MidStr(Sin, 6, 1) + ' ' + RightStr(Sin, 3); // 20200529
end;

function GetHiddenRepId(RepId: String): String; // 20230216
begin
  if RepId = '' then
  begin
    Result := '';
    Exit;
  end;
  Result := 'XXXX' + MidStr(RepId, 5, 3);
end;

(*
  Procedure SortTaxForms(FormsToPrint,PrintSeqList,SortedList:TStringList);
  //Sequence list has all forms in proper sequence
  // ListforSorting is a list of some forms to be sorted
  Var i,k:Integer;FrmName,seq:String;TempSortList:TStringList;
  Begin
  TempSortList:=TstringList.Create;
  TempSortList.Sorted:=True;

  for i:=0 to PrintSeqList.count-1 do
  Begin
  FrmName:=AllTrim(LeftStr(PrintSeqList[i],15));
  Seq:=MidStr(PrintSeqList[i],16,3);
  k:=IsInList(FrmName,FormsToPrint);
  If K>=0 then TempSortList.Add(Seq+FormsToPrint[k]);
  end;
  for i:=0 to TempSortList.count-1 do
  Begin
  SortedList.Add(MidStr(TempSortList[i],4,15));
  end;
  TempSortList.Free;
  End;
*)
Procedure SortTaxForms(FormsToPrint, PrintSeqList, SortedList: TStringList);
// Sequence list has all forms in proper sequence
// ListforSorting is a list of some forms to be sorted
Var
  i, k: integer;
  FrmName, seq: String;
  TempSortList: TStringList;
Begin
  TempSortList := TStringList.Create;
  TempSortList.Sorted := true;

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

Procedure GetListOfStatementsForAuto777(RetNo: integer; AList: TStrings;
  CurrentT777: String); // 20200513
Var
  i: integer;
Begin
  // T777Inst:=ExtractFormInst(CurrentT777);
  AList.Clear;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If Ret[RetNo].FrmHasData[FRec.FormNo] then // 20160813   //20170324 Igor
    begin
      if (FRec.FormName = 'T777')
      // ???And (FetchElm(RetNo,'AUTO777'
      then // 20101218
      begin
        If FRec.FormInst = '#1' then
          AList.Add(PaddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst,
            13)) // + FetchElmFNo(RetNo, FRec.FormNo, 8))
        Else If Ret[RetNo].FrmHasData[FRec.FormNo] then // 20170324 Igor
          AList.Add(PaddR(ExtractFormRootName(FRec.FormName) +
            FRec.FormInst, 13));
      end; // t777
    end;
  end; // i
end;

Procedure Auto777ToAuto777Multiple(RetNo: integer);
// needed to go from t777 to T777# multiple first time
Var
  i, FNo: integer;
Begin
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'AUTO777' then
    begin
      FNo := FRec.FormNo;
      // 20200511 gonin to multiple
      If FetchElmFNo(RetNo, FNo, 215) = 'T777' then
        StoreElm(RetNo, FNo, 215, 'T777#1');
      If FetchElmFNo(RetNo, FNo, 221) = 'T777' then
        StoreElm(RetNo, FNo, 221, 'T777#1');
      If FetchElmFNo(RetNo, FNo, 227) = 'T777' then
        StoreElm(RetNo, FNo, 215, 'T777#1');
    end;
  end;
end;

Procedure ExtractAuto777CCA(RetNo: integer; StmtId: String;
  StatementInst: String; Var TermLossAmount: Real; Var RecaptAmount: Real;
  Var CCAForStmt: Real; ClassOption: String);
Var
  i, j, k, FNo: integer;
  StPercent: Real;
  ShortYearPercent: Real;
  ExtractedCCARec: TExtractedCCARec;
  // ClassOption:String;
begin

  TermLossAmount := 0;
  RecaptAmount := 0;
  CCAForStmt := 0;
  StPercent := 0;

  InitExtractedCCAlist(RetNo);  //create or clear ExtractedCCAlist
  // 20100501
  If Ret[RetNo].FormHasData[StmtId + StatementInst] = false then
    Exit;

  // fill it up
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If (FRec.FormName = 'AUTO777') then
    begin
      FNo := FRec.FormNo;
      If ((FetchElmFNo(RetNo, FNo, 215) = StmtId + StatementInst) and
        (VL(FetchElmFNo(RetNo, FNo, 216)) > 0))                   then
      begin
        /// OR TAssetsBRec    but you wrote     TExtractedCCARec and this fields has to be here as i undertand
        ExtractedCCARec := TExtractedCCARec.Create;
        With ExtractedCCARec do
        begin
          StatementId := StmtId;
          Description := FetchElmFNo(RetNo, FNo, 1);
          RecordKeeping := FetchElmFNo(RetNo, FNo, 36); // 20110109
          PersonalPercent := VL(FetchElmFNo(RetNo, FNo, 4));
          j := 215;
          Repeat
            If FetchElmFNo(RetNo, FNo, j) = StmtId + StatementInst then
            begin
              StatementPercent := VL(FetchElmFNo(RetNo, FNo, j + 1));
              StPercent := StatementPercent;
              ShortYearPercent := (CalcBusDays(RetNo, FetchElmFNo(RetNo, FNo, j)) 
                                  / Constant[RY].FullYear) * 100;
              CCAClaimed := VL(FetchElmFNo(RetNo, FNo, j + 3));
              CCAForStatement := VL(FetchElmFNo(RetNo, FNo, j + 3));
              // may 26 2008
            end;
            inc(j, 6);
          until j > 227;

          ClassId := FetchElmFNo(RetNo, FNo, 134);
          DateAcquired := FetchElmFNo(RetNo, FNo, 137);

          Cost := VL(FetchElmFNo(RetNo, FNo, 20)); // 20200512 in app year

          UccStart := VL(FetchElmFNo(RetNo, FNo, 191));
          Additions := VL(FetchElmFNo(RetNo, FNo, 6)); // 158)); //20200512
          AiiPAdditions := VL(FetchElmFNo(RetNo, FNo, 26)); // see declare unit
          Proceeds := VL(FetchElmFNo(RetNo, FNo, 15));
          AiiPProceeds := VL(FetchElmFNo(RetNo, FNo, 27));
          AiiPUccAdj := VL(FetchElmFNo(RetNo, FNo, 30));

          Adjustments := VL(FetchElmFNo(RetNo, FNo, 164));
          AdjUCC := VL(FetchElmFNo(RetNo, FNo, 29));
          BaseAmount := VL(FetchElmFNo(RetNo, FNo, 167));
          Rate := VL(FetchElmFNo(RetNo, FNo, 170));
          CCAForTheYear := VL(FetchElmFNo(RetNo, FNo, 173));
          UCCEnd := VL(FetchElmFNo(RetNo, FNo, 176));
          TerminalLossAmount := VL(FetchElmFNo(RetNo, FNo, 2)); // 20200512
          RecaptureAmount := VL(FetchElmFNo(RetNo, FNo, 2)); // 20200512

          {
            // not acepted here
            // 20190216CON
            AiiPAdditions := VL(FetchElmFNo(RetNo, FNo, 37)); // see declare unit
            AiiPProceeds := VL(FetchElmFNo(RetNo, FNo, 38));
            AiiPUccAdj := VL(FetchElmFNo(RetNo, FNo, 39));
          }
          // ---------------
          if ClassOption = 'PARTA' then
          Begin
            if (ClassId = '8') or (ClassId = '10') or (ClassId = '54') or
              (ClassId = '55') then
            Begin
              ExtractedCCAlist.Add(ExtractedCCARec);
              TermLossFlag := FetchElmFNo(RetNo, FNo, 6);
            End
          End
          Else if ClassOption = 'PARTB' then
          begin
            if (ClassId = '10.1') then
            Begin
              ExtractedCCAlist.Add(ExtractedCCARec);
              TermLossFlag := FetchElmFNo(RetNo, FNo, 6);
            End
          end;
        end;
      end;

    end;        //end If 'AUTO777'
  end;          //end FOR FList.Count
  // get recapt and termloss
  For i := 0 to ExtractedCCAlist.Count - 1 do
  begin
    ExtractedCCARec := ExtractedCCAlist.Items[i];
    TermLossAmount := TermLossAmount + ExtractedCCARec.TerminalLossAmount;
    RecaptAmount := RecaptAmount + ExtractedCCARec.RecaptureAmount;
    CCAForStmt := CCAForStmt + ExtractedCCARec.CCAForStatement;
  end;
end;

// 20200511
Procedure PostAuto777CCA(RetNo: integer; FName: String; Stmt: String;
  FInst: String; FNo: integer; ClassOption: String);
Var
  i, j: integer;
  StartNdx, EndNdx, IncrBy, RemainingNdx, EndSectionNdx: integer;
  RemainingAmount: Real;
  TermLossAmount, RecaptAmount: Real;
  KTermLoss, KRecapture: integer;
  CCAForStmt: Real;
  kAii: integer; // Index for AiiP

begin
  if ClassOption = 'PARTA' then
  Begin
    StartNdx := 225;
    EndNdx := 264;//316;             //20260327
    IncrBy := 13;
    RemainingNdx := 185;        //capture tot for any additional missing lines
    EndSectionNdx := 328;
  end; // as per t777 tables //20200512
  if ClassOption = 'PARTB' then
  Begin
    StartNdx := 175;
    EndNdx := 199;
    IncrBy := 12;
    RemainingNdx := 222;
    EndSectionNdx := 208;
  end; // as per t777 tables

  TermLossAmount := 0;
  RecaptAmount := 0;
  CCAForStmt := 0;
  ExtractAuto777CCA(RetNo, Stmt, FInst, TermLossAmount, RecaptAmount, CCAForStmt, ClassOption);
  with Ret[RetNo].Frm[FNo] do
  begin
    // clear section PARTA
    if ClassOption = 'PARTA' then
    Begin
      For i := StartNdx to EndSectionNdx do
      begin
        Tv[i] := 0;
        StoreElm(RetNo, FNo, i, '');
      end; // clear section A
    end;
    // clear section PARTB
    if ClassOption = 'PARTB' then
    Begin
      For i := StartNdx to EndSectionNdx do
      begin
        Tv[i] := 0;
        StoreElm(RetNo, FNo, i, '');
      end; // clear section B
    end;

    Tv[RemainingNdx] := 0; // suppl clear
    RemainingAmount := 0;
    j := StartNdx;

    For i := 0 to ExtractedCCAlist.Count - 1 do
    begin
      ExtractedCCARec := ExtractedCCAlist.Items[i];
      TermLossAmount := TermLossAmount + ExtractedCCARec.TerminalLossAmount;
      RecaptAmount := RecaptAmount + ExtractedCCARec.RecaptureAmount;

      {20260327CZ
      //20260311 Igor >>>
      if ClassOption = 'PARTA' then
        case StrToIntDef(ExtractedCCARec.ClassId, 0) of
          8: j:= 225;
          10: j:= 238;
          54: j:= 251;
          55: j:= 264;
        end;
      }
      //20260311 Igor <<<
      If j > EndNdx then
        RemainingAmount := RemainingAmount + ExtractedCCARec.CCAClaimed
      else
      begin
        if ClassOption = 'PARTA' then
        Begin
          StoreElm(RetNo, FNo, j, ExtractedCCARec.ClassId); //was dummied out by alex //20260311 Igor
          //jz//20260321 - add Tv[j + x] + so it adds all the instances in each column
          Tv[j + 1] := Tv[j + 1] + ExtractedCCARec.UccStart;
          Tv[j + 2] := Tv[j + 2] + ExtractedCCARec.Additions;
          Tv[j + 3] := Tv[j + 3] + ExtractedCCARec.AiiPAdditions;
          Tv[j + 4] := Tv[j + 4] + ExtractedCCARec.Proceeds;
          //20260311 Igor >>>  Following was dummied oit by Alex i
          Tv[j + 5] := MaxR(0, Tv[j + 1] + Tv[j + 2] - Tv[j + 4]);
          Tv[j + 6] := MaxR(0, ExtractedCCARec.AiiPProceeds);
          Tv[j + 7] := MaxR(0, ExtractedCCARec.AiiPUccAdj);
          Tv[j + 8] := ExtractedCCARec.Adjustments;
          Tv[j + 9] := ExtractedCCARec.BaseAmount;
          Tv[j + 10] := ExtractedCCARec.Rate;
          Tv[j + 11] := ExtractedCCARec.CCAForTheYear;
          Tv[j + 12] := ExtractedCCARec.UCCEnd;
          inc(j, IncrBy);
          //20260311 Igor <<<
        end
        Else
        Begin // PartB
          StoreElm(RetNo, FNo, j, ExtractedCCARec.DateAcquired);
          Tv[j + 1] := ExtractedCCARec.Cost;
          StoreElm(RetNo, FNo, j + 2, ExtractedCCARec.ClassId);
          Tv[j + 3] := ExtractedCCARec.UccStart;
          Tv[j + 4] := ExtractedCCARec.Additions;
          // Tv[KAiipAdd+1]:=
          Tv[j + 5] := ExtractedCCARec.Proceeds;
          Tv[j + 6] := ExtractedCCARec.BaseAmount;
          StoreElm(RetNo, FNo, j + 7, FormatFloat('###.##',
            ExtractedCCARec.Rate));
          Tv[j + 8] := ExtractedCCARec.CCAForTheYear;
          Tv[j + 9] := ExtractedCCARec.UCCEnd;
          // 20190202 Post Aii
          // Tv[TotalNdx] := Tv[TotalNdx] + Tv[j + 7];
          inc(j, IncrBy);
        End;
      end;
    end;
    // ??
    // store term loss and recapture amounts
    If (LeftStr(Stmt, 5) = 'T777#') then
    begin
      // StoreElm(RetNo, FNo, 215, FormatFloat('########.##', TermLossAmount));
      // StoreElm(RetNo, FNo, 216, FormatFloat('########.##', RecaptAmount));
    end;
  end;
end;

Function IsSignatureForm(FName: String): Boolean; // 20200517
Var
  i: integer;
Begin
  Result := false;
  FName := UpperCase(ExtractNonInstFormName(FName));
  for i := 1 to 7 do
  Begin
    if FName = AutoSignedForms[i] then
    begin
      Result := true;
      Exit;
    end;
  End;
End;

Function GetT777BusKm(RetNo: integer; T777FName: String;
  T777FNo: integer): integer;
// FNo is of T777#1 etc
Var
  i: integer;
  Auto777FNo: integer;
  S: String;
Begin
  Result := 1;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    Auto777FNo := FRec.FormNo;
    if (FetchElmFNo(RetNo, Auto777FNo, 215) = T777FName) and
      (VL(FetchElmFNo(RetNo, Auto777FNo, 216)) > 0) and
      (FetchElmFNo(RetNo, Auto777FNo, 134) <> '8') then
    Begin
      Result := StrToInt(FetchElmFNo(RetNo, Auto777FNo, 4));
    End;
  end;
End;

Function GetT777TotKm(RetNo: integer; T777FName: String;
  T777FNo: integer): integer;
// FNo is of T777#1 etc
Var
  i: integer;
  Auto777FNo: integer;
  S: String;
Begin
  Result := 1;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    Auto777FNo := FRec.FormNo;
    if (FetchElmFNo(RetNo, Auto777FNo, 215) = T777FName) and
      (VL(FetchElmFNo(RetNo, Auto777FNo, 216)) > 0) and
      (FetchElmFNo(RetNo, Auto777FNo, 134) <> '8') then
    Begin
      Result := StrToInt(FetchElmFNo(RetNo, Auto777FNo, 7));
    End;
  end;
End;

Function GetT777NumOfCars(RetNo: integer; T777FName: String;
  T777FNo: integer): integer;
// FNo is of T777#1 etc
Var
  i: integer;
  Auto777FNo: integer;
Begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    Auto777FNo := FRec.FormNo;
    if (FetchElmFNo(RetNo, Auto777FNo, 215) = T777FName) and
      (VL(FetchElmFNo(RetNo, Auto777FNo, 216)) > 0) and
      (FetchElmFNo(RetNo, Auto777FNo, 134) <> '8') then // %
    Begin
      Result := Result + 1;
    End;
  end;
End;

Function GetT777KmPercent(RetNo: integer; T777FName: String;
  T777FNo: integer): Real;
Var
  BusKm, TotKm: integer;
begin
  BusKm := GetT777BusKm(RetNo, T777FName, T777FNo);
  TotKm := GetT777TotKm(RetNo, T777FName, T777FNo);
  Result := BusKm / TotKm;
end;

// 20200519
Function GetT777ExpenseLine(RetNo: integer; T777FName: String; T777FNo: integer;
  Auto777Elm: integer): Real;
// FNo is of T777#1 etc
Var
  i: integer;
  Auto777FNo: integer;
  Cars: integer;
  KmPercent, AllocPercent: Real;
Begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    Auto777FNo := FRec.FormNo;
    if (FetchElmFNo(RetNo, Auto777FNo, 215) = T777FName) and
      (VL(FetchElmFNo(RetNo, Auto777FNo, 216)) > 0) then // %
    Begin
      KmPercent := VL(FetchElmFNo(RetNo, Auto777FNo, 4)) /
        VL(FetchElmFNo(RetNo, Auto777FNo, 7));
      AllocPercent := VL(FetchElmFNo(RetNo, Auto777FNo, 216)) / 100;
      // 20200521
      if UpperCase(FetchElmFNo(RetNo, T777FNo, 67)) <> 'Y' then
        // NO multiple cars
        Result := Result + VL(FetchElmFNo(RetNo, Auto777FNo, Auto777Elm)) *
          AllocPercent
      Else // multiple cars
        Result := Result + VL(FetchElmFNo(RetNo, Auto777FNo, Auto777Elm)) *
          AllocPercent * KmPercent; // multiple cars
    end;
  end;
End;

// 20200519
Function GetT777TotCCA(RetNo: integer; T777FName: String; T777FNo: integer;
  Auto777Elm: integer): Real;
// FNo is of T777#1 etc
Var
  i: integer;
  Auto777FNo: integer;
  Cars: integer;
  KmPercent, AllocPercent: Real;
Begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    Auto777FNo := FRec.FormNo;
    if (FetchElmFNo(RetNo, Auto777FNo, 215) = T777FName) and
      (VL(FetchElmFNo(RetNo, Auto777FNo, 216)) > 0) then // %
    Begin
      KmPercent := VL(FetchElmFNo(RetNo, Auto777FNo, 4)) /
        VL(FetchElmFNo(RetNo, Auto777FNo, 7));
      AllocPercent := VL(FetchElmFNo(RetNo, Auto777FNo, 216)) / 100;
      // 20200521
      if FetchElmFNo(RetNo, Auto777FNo, 134) <> '8' then
      // do not include 8 this is only for cars
      Begin
        if UpperCase(FetchElmFNo(RetNo, T777FNo, 67)) <> 'Y' then
          // NO multiple cars
          Result := Result + VL(FetchElmFNo(RetNo, Auto777FNo, Auto777Elm)) *
            AllocPercent
        Else // multiple cars
          Result := Result + VL(FetchElmFNo(RetNo, Auto777FNo, Auto777Elm)) *
            AllocPercent * KmPercent; // multiple cars
      end;
    end;
  end;
End;

Function GetT5008CurrencyRate(Currency: String;
  Var ForeignCurrencyList: TStringList): Real;
Var
  i: integer;
  CurrencyFound: Boolean;
Begin
  CurrencyFound := false;
  Result := 0;
  Currency := AllTrim(UpperCase(Currency));
  For i := 0 to ForeignCurrencyList.Count - 1 do
  Begin
    if Currency = AllTrim(UpperCase(LeftStr(ForeignCurrencyList[i],
      Length(Currency)))) then
    Begin
      CurrencyFound := true;
      Result := VL(AllTrim(MidStr(ForeignCurrencyList[i], 30, 9)));
    End;
  End;
  if CurrencyFound = false then
  Begin
    ForeignCurrencyList.Add(PaddR(Currency, 3) + Space(27) + '??.??????');
    ForeignCurrencyList.SaveToFile(AppDir + '\' + 'FCurrencies.txt');
  End;
end;

// 20210311
Procedure GetAutofillData(RetNo: integer; AutofillGroup: String); // 20200526
// Show the slip details or Summarize certain boxes of various slips captured by Autofil
Type
  TT5008Rec = Record
    SlipInstance: String[5]; // [10];
    Box21Amount: Real;
    Box20Amount: Real;
    CurrencyType: String[3];
    ForeignExchRate: Real;
    RecipientType: String[1];
  end;

Var
  i, j: integer;
  FlName1, FlName2, S: String;
  TempList1, TempList2, ForeignCurrencyList, RecList: TStringList;
  h: THandle;
  PrevItem: String;
  BoxPosition, BoxAmountPosition: integer;
  Box1Amount, Box2Amount, Box3Amount, Box4Amount: Real;
  Section, SubSection, DataElmName, Instance, Value, FieldKey, BoxNo: String;
  PrevInstance: String;
  JointInstance: String;
  Currency: String;
  MissingCurrencies: String;
  ForeignCurrencyRate: Real; // i.e USA, CAD etc

  T5008Rec: TT5008Rec;
  TotBox21Amount, TotBox20Amount: Real;
  TotJointBox21Amount, TotJointBox20Amount: Real;
  A: TArray<string>; // 20210309 Igor
  CurrInstance: integer; // 20210311 Igor
Begin
  AutofillGroup := UpperCase(AutofillGroup);
  // FileNm:= (GetLastName(RetNo)+' '+GetFirstName(RetNo))+'.Txt';
  FlName1 := MkTddFileName(RetNo, GetSinNo(RetNo));

  if Not FileExists(FlName1) then
  Begin
    ShowMessage(FlName + ' Does not exist');
    Exit;
  end;

  // summarize now
  TempList1 := TStringList.Create; // big list of data
  TempList2 := TStringList.Create;
  // Fltetred list only for the datagroup we need
  // TempList1.Sorted:=True; //20210311 Igor
  TempList1.LoadFromFile(FlName1);

  OpenTheTddElmsTable;

  PrevItem := '';
  PrevInstance := '';
  MissingCurrencies := '';
  ForeignCurrencyList := TStringList.Create;
  RecList := TStringList.Create;
  ForeignCurrencyList.LoadFromFile(AppDir + '\' + 'FCurrencies.txt');
  CurrInstance := 0; // 20210311 Igor
  For i := 0 To TempList1.Count - 1 do
  begin
    S := TempList1[i];
    // 20210309 Igor >>>
    A := S.Split([AFRStringDelimiter]);
    if Length(A) >= 5 then
    begin
      Section := AllTrim(A[0]);
      SubSection := AllTrim(A[1]);
      DataElmName := AllTrim(A[2]);
      Instance := AllTrim(A[3]);
      Value := AllTrim(A[4]);
    end
    else
    begin
      Section := AllTrim(LeftStr(S, 45));
      SubSection := AllTrim(MidStr(S, 46, 35));
      DataElmName := AllTrim(MidStr(S, 81, 60));
      Instance := AllTrim(MidStr(S, 141, 2));

      // BoxPosition:=

      Value := AllTrim(MidStr(S, 144, 100)); // ??? not needed
    end;
    // if LeftStr(subsection,5)='T5008' then ShowMessage('T5008'); //20230409

    // 20210311 Igor >>>
    If IsDataGroupASlip(SubSection) then
    begin
      if SameText(DataElmName, 'TaxYear') then
        inc(CurrInstance);
      Instance := PaddR(IntToStr(CurrInstance), 2);
      Instance := '#' + RmvLeadingZeros(Instance)
    end
    Else
      Instance := '';
    // 20210309 Igor
    // get the rest from the tddElms data base i.e boxno
    BoxNo := '';
    // 20210311 Igor <<<
    FieldKey := SubSection + '-' + DataElmName;
    If FieldKey <> '-' then
    Begin
      If TddElmsTable.FindKey([FieldKey]) = true then
        BoxNo := TddElmsTable.FieldByName('BoxNo').AsString;
    end;

    TempList2.Sorted := true; // sorting on instance
    // Filter the records and create a new shorter record layout
    If UpperCase(LeftStr(SubSection, Length(AutofillGroup))) = AutofillGroup
    then // If LeftStr(S,5)='Slips' then
    Begin
      S := PaddR(Instance, 4) + PaddR(AllTrim(SubSection), 35) +
        PaddR(AllTrim(DataElmName), 50) + PaddR(BoxNo, 3) + Space(1) +
        ' ' + Value;
      // 20200527
      If (Instance > PrevInstance) then
      begin
        TempList2.Add('');
        PrevInstance := Instance;
      end;
      TempList2.Add(S);
    end;
  end; // i

  if TempList2.Count = 0 then // 20200601
  Begin
    ShowMessage('There are no data found');
    TempList2.Free;
    Exit;
  End;

  // Initialize boxes in slips
  TotBox21Amount := 0;
  TotBox20Amount := 0;

  Box1Amount := 0;
  Box2Amount := 0;
  Box3Amount := 0;
  Box4Amount := 0;
  Value := '';
  BoxNo := '';
  DataElmName := '';
  PrevInstance := '';
  ForeignCurrencyRate := 1;

  With T5008Rec do
  Begin
    SlipInstance := '';
    Box21Amount := 0;
    Box20Amount := 0;
    CurrencyType := '';
    RecipientType := '';
  end;

  for i := 0 to TempList2.Count - 1 do
  Begin
    S := TempList2[i];
    Instance := AllTrim(MidStr(S, 1, 4));
    // initialize or summarize between instances
    if Instance > PrevInstance then // initialize the rec
    Begin
      With T5008Rec do
      Begin
        SlipInstance := '';
        Box21Amount := 0;
        Box20Amount := 0;
        CurrencyType := '';
        RecipientType := '';
        PrevInstance := Instance;
      end;
    End;

    Value := AllTrim(MidStr(S, 94, 30));
    BoxNo := AllTrim(MidStr(S, 90, 3));
    DataElmName := AllTrim(MidStr(S, 40, 50));

    With T5008Rec do
    Begin
      SlipInstance := Instance;
      If BoxNo = '11' then
        RecipientType := Value;

      If BoxNo = '13' then // currency
      begin
        CurrencyType := AllTrim(Value);
        If (CurrencyType = 'CAD') or (CurrencyType = '') then
          ForeignExchRate := 1
        Else
          ForeignExchRate := GetT5008CurrencyRate(CurrencyType,
            ForeignCurrencyList);
        if ForeignExchRate = 0 then
        Begin
          MissingCurrencies := MissingCurrencies + CurrencyType + ',';
        end;
      end;

      If BoxNo = '21' then
      Begin
        Box21Amount := VL(Value) * ForeignExchRate;
        if RecipientType = '1' then
          TotBox21Amount := TotBox21Amount + Box21Amount
        Else if RecipientType = '2' then
          TotBox21Amount := TotBox21Amount + Box21Amount / 2;
        // TotJointBox21Amount:=TotJointBox21Amount+Box21Amount/2;

      End;

      If BoxNo = '20' then
      Begin
        Box20Amount := VL(Value) * ForeignExchRate;
        if RecipientType = '1' then
          TotBox20Amount := TotBox20Amount + Box20Amount
        Else if RecipientType = '2' then
          TotBox20Amount := TotBox20Amount + Box20Amount / 2;
        // TotJointBox20Amount:=TotJointBox20Amount+Box20Amount/2;

      End;
    end;
  End; // i
  StoreElm(RetNo, GetFormNo('T5008#1'), 193, FormatFloat('########.##',
    TotBox21Amount));
  StoreElm(RetNo, GetFormNo('T5008#1'), 194, FormatFloat('########.##',
    TotBox20Amount));
  StoreElm(RetNo, GetFormNo('T5008#1'), 198, FormatFloat('########.##',
    TotJointBox21Amount));
  StoreElm(RetNo, GetFormNo('T5008#1'), 199, FormatFloat('########.##',
    TotJointBox20Amount)); // box20
  StoreElm(RetNo, GetFormNo('T5008#1'), 214, MissingCurrencies);

  Calc(RetNo, 'T5008#1');
  CalcFullReturn(RetNo);
  CountDiagnostics(RetNo);
  OpenForm(RetNo, 'T5008#1', 0);

  TempList1.Free;
  ForeignCurrencyList.Free;
  RecList.Free;
  TempList2.Free;

End;

(*
  //20210309
  Procedure GetAutofillData(RetNo:Integer;AutofillGroup:String); //20200526
  // Show the slip details or Summarize certain boxes of various slips captured by Autofil
  Type
  TT5008Rec = Record
  SlipInstance   :String[5]; //[10];
  Box21Amount    :Real;
  Box20Amount    :Real;
  CurrencyType   :String[3];
  ForeignExchRate:Real;
  RecipientType  :String[1];
  end;


  Var i,j:Integer;FlName1,FlName2,s:String;TempList1,TempList2,ForeignCurrencyList,RecList:TStringList;
  h:Thandle;PrevItem:String;
  BoxPosition,BoxAmountPosition:Integer;
  Box1Amount,Box2Amount,Box3Amount,Box4Amount:Real;
  Section,Subsection,DataElmName,Instance,value,FieldKey,BoxNo:String;
  PrevInstance:String;
  JointInstance:String;
  Currency:String; MissingCurrencies:String;
  ForeignCurrencyRate:Real; //i.e USA, CAD etc

  T5008Rec:TT5008Rec;
  TotBox21Amount,TotBox20Amount:Real;
  TotJointBox21Amount,TotJointBox20Amount:Real;
  A: TArray<string>; //20210309 Igor
  Begin
  AutofillGroup:=UpperCase(AutofillGroup);
  //FileNm:= (GetLastName(RetNo)+' '+GetFirstName(RetNo))+'.Txt';
  FlName1:=MkTddFileName(RetNo,GetSinNo(RetNo));

  if Not FileExists(FlName1) then
  Begin
  ShowMessage(FlName + ' Does not exist');
  Exit;
  end;

  //summarize now
  TempList1:=TStringList.create;  //big list of data
  TempList2:=TStringList.create;  //Fltetred list only for the datagroup we need
  TempList1.Sorted:=True;
  TempList1.LoadFromFile(FlName1);

  OpenTheTddElmsTable;

  PrevItem:='';
  PrevInstance:='';
  MissingCurrencies:='';
  ForeignCurrencyList:=TStringList.Create;
  RecList:=TstringList.Create;
  ForeignCurrencyList.LoadFromFile(AppDir+'\'+'FCurrencies.txt');

  For i:=0 To TempList1.Count-1 do
  begin
  s:=TempList1[i];
  //20210309 Igor >>>
  A := s.Split([AFRStringDelimiter]);
  if Length(A) >= 5 then
  begin
  Section:=AllTrim(A[0]);
  SubSection:=AllTrim(A[1]);
  DataElmName:=AllTrim(A[2]);
  Instance:=AllTrim(A[3]);
  Value:=AllTrim(A[4]);
  end
  else
  begin
  Section:=AllTrim(LeftStr(s,45));
  SubSection:=AllTrim(MidStr(S,46,35));
  DataElmName:=AllTrim(MidStr(S,81,60));
  Instance:=AllTrim(MidStr(S,141,2));

  //  BoxPosition:=

  Value:=AllTrim(MidStr(S,144,100));   //??? not needed
  end;
  If IsDataGroupASlip(SubSection) then
  Instance:='#'+RmvLeadingZeros(Instance)
  Else
  Instance:='';
  //20210309 Igor
  //get the rest from the tddElms data base i.e boxno
  FieldKey:=SubSection+'-'+DataElmName;
  If FieldKey<>'-' then
  Begin
  If TddElmsTable.FindKey([FieldKey]) = True then
  BoxNo:=TddElmsTable.FieldByName('BoxNo').AsString;
  end;

  TempList2.Sorted:=True;  //sorting on instance
  //Filter the records and create a new shorter record layout
  If UpperCase(LeftStr(Subsection,Length(Autofillgroup)))=Autofillgroup then//If LeftStr(S,5)='Slips' then
  Begin
  s:=PaddR(Instance,4)+PaddR(AllTrim(SubSection),35)+PaddR(AllTrim(DataElmName),50)+PaddR(BoxNo,3)+Space(1)+' '+Value;
  //20200527
  If (Instance>PrevInstance) then
  begin
  TempList2.Add('');
  PrevInstance:=Instance;
  end;
  TempList2.Add(s);
  end;
  end; //i

  if Templist2.count=0 then  //20200601
  Begin
  ShowMessage('There are no data found');
  Templist2.Free;
  Exit;
  End;

  //Initialize boxes in slips
  TotBox21Amount:=0;
  TotBox20Amount:=0;

  Box1Amount:=0;Box2Amount:=0;  Box3Amount:=0;  Box4Amount:=0;
  Value:='';
  BoxNo:='';
  DataElmName:='';
  PrevInstance:='';
  ForeignCurrencyRate:=1;

  With T5008Rec do
  Begin
  SlipInstance   :='';
  Box21Amount    :=0;
  Box20Amount    :=0;
  CurrencyType   :='';
  RecipientType  :='';
  end;

  for i:=0 to TempList2.count-1 do
  Begin
  s:=TempList2[i];
  Instance:=AllTrim(MidStr(s,1,4));
  //initialize or summarize between instances
  if Instance>PrevInstance then //initialize the rec
  Begin
  With T5008Rec do
  Begin
  SlipInstance   :='';
  Box21Amount    :=0;
  Box20Amount    :=0;
  CurrencyType   :='';
  RecipientType  :='';
  PrevInstance:=Instance;
  end;
  End;

  Value:=AllTrim(MidStr(s,94,30));
  BoxNo:=AllTrim(MidStr(s,90,3));
  DataElmName:=AllTrim(MidStr(s,40,50));

  With T5008Rec do
  Begin
  SlipInstance   :=Instance;
  If BoxNo='11' then RecipientType:=Value;

  If BoxNo='13' then //currency
  begin
  CurrencyType:=AllTrim(Value);
  If (CurrencyType='CAD') or (CurrencyType='') then
  ForeignExchRate:=1
  Else
  ForeignExchRate:=GetT5008CurrencyRate(CurrencyType,ForeignCurrencyList);
  if ForeignExchRate=0 then
  Begin
  MissingCurrencies:=MissingCurrencies+CurrencyType+',';
  end;
  end;

  If BoxNo='21' then
  Begin
  Box21Amount:=vl(Value) * ForeignExchRate;
  if RecipientType='1' then
  TotBox21Amount:=TotBox21Amount+Box21Amount
  Else if RecipientType='2' then
  TotBox21Amount:=TotBox21Amount+Box21Amount/2;
  // TotJointBox21Amount:=TotJointBox21Amount+Box21Amount/2;

  End;

  If BoxNo='20' then
  Begin
  Box20Amount:=Vl(Value) * ForeignExchRate;
  if RecipientType='1' then
  TotBox20Amount:=TotBox20Amount+Box20Amount
  Else if RecipientType='2' then
  TotBox20Amount:=TotBox20Amount+Box20Amount/2;
  //TotJointBox20Amount:=TotJointBox20Amount+Box20Amount/2;

  End;
  end;
  End; //i
  StoreElm(RetNo,GetFormNo('T5008#1'),193,FormatFloat('########.##',TotBox21Amount));
  StoreElm(RetNo,GetFormNo('T5008#1'),194,FormatFloat('########.##',TotBox20Amount));
  StoreElm(RetNo,GetFormNo('T5008#1'),198,FormatFloat('########.##',TotJointBox21Amount));
  StoreElm(RetNo,GetFormNo('T5008#1'),199,FormatFloat('########.##',TotJointBox20Amount)); //box20
  StoreElm(RetNo,GetFormNo('T5008#1'),214,MissingCurrencies);

  Calc(RetNo,'T5008#1');
  CalcFullReturn(RetNo);
  CountDiagnostics(RetNo);
  OpenForm(RetNo,'T5008#1',0);

  TempList1.free;
  ForeignCurrencyList.Free;
  RecList.Free;
  TempList2.Free;

  //Calc(RetNo,'T5008#1');
  //OpenForm(RetNo,'T5008#1',0);

  (*
  FlName2:=AppDir+'\'+'TempFile.txt';
  AssignFile(F1,FlName2);
  Rewrite(F1);
  {
  WriteLn(F1,' ');
  WriteLn(F1,'    ************  Widen the screen to see cleaner horizontal lines ***********');
  WriteLn(F1,' ');
  }
  For i:=0 To TempList2.Count-1 do WriteLn(F1,TempList2[i]);
  CloseFile(F1);
  TempList1.free;
  ForeignCurrencyList.Free;
  RecList.Free;
  TempList2.Free;
  h := ShellExecute(mainform.Handle,'open',Pchar(''+FlName2),Nil,Nil,Sw_Show);
  If H<=32 then
  Begin
  ShowMessage('File '+FlName2+' not found');
  Exit;
  End;
*)

// End;

(*
  Procedure GetAutofillData(RetNo:Integer;AutofillGroup:String); //20200526
  // Show the slip details or Summarize certain boxes of various slips captured by Autofil
  Type
  TT5008Rec = Record
  SlipInstance   :String[5]; //[10];
  Box21Amount    :Real;
  Box20Amount    :Real;
  CurrencyType   :String[3];
  ForeignExchRate:Real;
  RecipientType  :String[1];
  end;


  Var i,j:Integer;FlName1,FlName2,s:String;TempList1,TempList2,ForeignCurrencyList,RecList:TStringList;
  h:Thandle;PrevItem:String;
  BoxPosition,BoxAmountPosition:Integer;
  Box1Amount,Box2Amount,Box3Amount,Box4Amount:Real;
  Section,Subsection,DataElmName,Instance,value,FieldKey,BoxNo:String;
  PrevInstance:String;
  JointInstance:String;
  Currency:String; MissingCurrencies:String;
  ForeignCurrencyRate:Real; //i.e USA, CAD etc

  T5008Rec:TT5008Rec;
  TotBox21Amount,TotBox20Amount:Real;
  TotJointBox21Amount,TotJointBox20Amount:Real;

  Begin
  AutofillGroup:=UpperCase(AutofillGroup);
  //FileNm:= (GetLastName(RetNo)+' '+GetFirstName(RetNo))+'.Txt';
  FlName1:=MkTddFileName(RetNo,GetSinNo(RetNo));

  if Not FileExists(FlName1) then
  Begin
  ShowMessage(FlName + ' Does not exist');
  Exit;
  end;

  //summarize now
  TempList1:=TStringList.create;  //big list of data
  TempList2:=TStringList.create;  //Fltetred list only for the datagroup we need
  TempList1.Sorted:=True;
  TempList1.LoadFromFile(FlName1);

  OpenTheTddElmsTable;

  PrevItem:='';
  PrevInstance:='';
  MissingCurrencies:='';
  ForeignCurrencyList:=TStringList.Create;
  RecList:=TstringList.Create;
  ForeignCurrencyList.LoadFromFile(AppDir+'\'+'FCurrencies.txt');

  For i:=0 To TempList1.Count-1 do
  begin
  s:=TempList1[i];
  Section:=AllTrim(LeftStr(s,45));
  SubSection:=AllTrim(MidStr(S,46,35));
  DataElmName:=AllTrim(MidStr(S,81,60));
  Instance:=AllTrim(MidStr(S,141,2));

  //  BoxPosition:=
  If IsDataGroupASlip(SubSection) then
  Instance:='#'+RmvLeadingZeros(Instance)
  Else
  Instance:='';
  Value:=AllTrim(MidStr(S,144,100));   //??? not needed

  //get the rest from the tddElms data base i.e boxno
  FieldKey:=SubSection+'-'+DataElmName;
  If FieldKey<>'-' then
  Begin
  If TddElmsTable.FindKey([FieldKey]) = True then
  BoxNo:=TddElmsTable.FieldByName('BoxNo').AsString;
  end;

  TempList2.Sorted:=True;  //sorting on instance
  //Filter the records and create a new shorter record layout
  If UpperCase(LeftStr(Subsection,Length(Autofillgroup)))=Autofillgroup then//If LeftStr(S,5)='Slips' then
  Begin
  s:=PaddR(Instance,4)+PaddR(AllTrim(SubSection),35)+PaddR(AllTrim(DataElmName),50)+PaddR(BoxNo,3)+Space(1)+' '+Value;
  //20200527
  If (Instance>PrevInstance) then
  begin
  TempList2.Add('');
  PrevInstance:=Instance;
  end;
  TempList2.Add(s);
  end;
  end; //i

  if Templist2.count=0 then  //20200601
  Begin
  ShowMessage('There are no data found');
  Templist2.Free;
  Exit;
  End;

  //Initialize boxes in slips
  TotBox21Amount:=0;
  TotBox20Amount:=0;

  Box1Amount:=0;Box2Amount:=0;  Box3Amount:=0;  Box4Amount:=0;
  Value:='';
  BoxNo:='';
  DataElmName:='';
  PrevInstance:='';
  ForeignCurrencyRate:=1;

  With T5008Rec do
  Begin
  SlipInstance   :='';
  Box21Amount    :=0;
  Box20Amount    :=0;
  CurrencyType   :='';
  RecipientType  :='';
  end;

  for i:=0 to TempList2.count-1 do
  Begin
  s:=TempList2[i];
  Instance:=AllTrim(MidStr(s,1,4));
  //initialize or summarize between instances
  if Instance>PrevInstance then //initialize the rec
  Begin
  With T5008Rec do
  Begin
  SlipInstance   :='';
  Box21Amount    :=0;
  Box20Amount    :=0;
  CurrencyType   :='';
  RecipientType  :='';
  PrevInstance:=Instance;
  end;
  End;

  Value:=AllTrim(MidStr(s,94,30));
  BoxNo:=AllTrim(MidStr(s,90,3));
  DataElmName:=AllTrim(MidStr(s,40,50));

  With T5008Rec do
  Begin
  SlipInstance   :=Instance;
  If BoxNo='11' then RecipientType:=Value;

  If BoxNo='13' then //currency
  begin
  CurrencyType:=AllTrim(Value);
  If (CurrencyType='CAD') or (CurrencyType='') then
  ForeignExchRate:=1
  Else
  ForeignExchRate:=GetT5008CurrencyRate(CurrencyType,ForeignCurrencyList);
  if ForeignExchRate=0 then
  Begin
  MissingCurrencies:=MissingCurrencies+CurrencyType+',';
  end;
  end;

  If BoxNo='21' then
  Begin
  Box21Amount:=vl(Value) * ForeignExchRate;
  if RecipientType='1' then
  TotBox21Amount:=TotBox21Amount+Box21Amount
  Else if RecipientType='2' then
  TotBox21Amount:=TotBox21Amount+Box21Amount/2;
  // TotJointBox21Amount:=TotJointBox21Amount+Box21Amount/2;

  End;

  If BoxNo='20' then
  Begin
  Box20Amount:=Vl(Value) * ForeignExchRate;
  if RecipientType='1' then
  TotBox20Amount:=TotBox20Amount+Box20Amount
  Else if RecipientType='2' then
  TotBox20Amount:=TotBox20Amount+Box20Amount/2;
  //TotJointBox20Amount:=TotJointBox20Amount+Box20Amount/2;

  End;
  end;
  End; //i
  StoreElm(RetNo,GetFormNo('T5008#1'),193,FormatFloat('########.##',TotBox21Amount));
  StoreElm(RetNo,GetFormNo('T5008#1'),194,FormatFloat('########.##',TotBox20Amount));
  StoreElm(RetNo,GetFormNo('T5008#1'),198,FormatFloat('########.##',TotJointBox21Amount));
  StoreElm(RetNo,GetFormNo('T5008#1'),199,FormatFloat('########.##',TotJointBox20Amount)); //box20
  StoreElm(RetNo,GetFormNo('T5008#1'),214,MissingCurrencies);

  Calc(RetNo,'T5008#1');
  CalcFullReturn(RetNo);
  CountDiagnostics(RetNo);
  OpenForm(RetNo,'T5008#1',0);

  TempList1.free;
  ForeignCurrencyList.Free;
  RecList.Free;
  TempList2.Free;

  //Calc(RetNo,'T5008#1');
  //OpenForm(RetNo,'T5008#1',0);

  (*
  FlName2:=AppDir+'\'+'TempFile.txt';
  AssignFile(F1,FlName2);
  Rewrite(F1);
  {
  WriteLn(F1,' ');
  WriteLn(F1,'    ************  Widen the screen to see cleaner horizontal lines ***********');
  WriteLn(F1,' ');
  }
  For i:=0 To TempList2.Count-1 do WriteLn(F1,TempList2[i]);
  CloseFile(F1);
  TempList1.free;
  ForeignCurrencyList.Free;
  RecList.Free;
  TempList2.Free;
  h := ShellExecute(mainform.Handle,'open',Pchar(''+FlName2),Nil,Nil,Sw_Show);
  If H<=32 then
  Begin
  ShowMessage('File '+FlName2+' not found');
  Exit;
  End;
*)
// End;

Function TimeToHHMMDD(DateTime: TDateTime): String;
Var
  S: String;
Begin
  S := FormatDateTime('tt', DateTime); // 20201227
  S := ReplaceStr(S, 'AM', '');
  S := ReplaceStr(S, 'PM', '');
  if MidStr(S, 2, 1) = ':' then
    S := '0' + MidStr(S, 1, 8);
  Result := S;
end;

Function RoundtoOneDecimal(R: Real): Real;
Begin

  Result := RoundTo(R, -1); // k = 1.23
  (*
    Result := Trunc(R); // extract the integer part
    if Frac(R) >= 0.5 then // if fractional part >= 0.5 then...
    Result := Result + 0.5;
  *)
End;

// 20210314
Function GetOprimumDonationClaim(RetNo: integer): Real;
// Function GetOprimumDonationClaim(RetNo:Integer; FromClaim,ToClaim:Real;MaxScenarios:Integer):Real;
// it find the optimum donation claim amount and enter it on S9

Var
  i, j: integer;
  FromClaim, ToClaim: Real;
  MaxScenarios: integer;

  TaxPayable: Array of Real;
  ClaimAmount: Array of Real;
  OptimumTaxPayable: Real;
  OptimumClaimAmount: Real;
  S9FNo: integer;
  IncrAmount: Real;
  x: Real;
  LeastTaxPayable: Real;
Begin
  MaxScenarios := 10;
  S9FNo := GetFormNo('S9');
  FromClaim := 0;
  ToClaim := MinR(VL(FetchElmFNo(RetNo, S9FNo, 40)),
    VL(FetchElmFNo(RetNo, S9FNo, 8)));

  SetLength(ClaimAmount, MaxScenarios);
  SetLength(TaxPayable, MaxScenarios);

  IncrAmount := (ToClaim - FromClaim) / MaxScenarios;
  OptimumClaimAmount := 0;
  ClaimAmount[0] := 0;
  For j := low(ClaimAmount) to High(ClaimAmount) do
  Begin
    StoreElm(RetNo, S9FNo, 137, 'Y');
    StoreElm(RetNo, S9FNo, 138, FormatFloat('#########.##', ClaimAmount[j]));
    // S9(RetNo,'S9',S9FNo);
    CalcFullReturn(RetNo);

    TaxPayable[j] := Ret[RetNo].Lnn[43500];
    OptimumTaxPayable := TaxPayable[j];
    ClaimAmount[j] := OptimumClaimAmount + IncrAmount;
    OptimumClaimAmount := ClaimAmount[j];
  end;

  // Find the least
  OptimumTaxPayable := 1000000000; // TaxPayable[low(ClaimAmount)];
  For j := low(ClaimAmount) to High(ClaimAmount) do
  Begin
    if TaxPayable[j] < OptimumTaxPayable then
    begin
      OptimumTaxPayable := TaxPayable[j];
      OptimumClaimAmount := ClaimAmount[j];
      Result := ClaimAmount[j];
    end;
  End;
  ShowMessage('The optimum claim is ' + FormatFloat('#########.##', Result));
End;

// 20210402
Function GetEligGstRebateFromT777(RetNo: integer): Real;
Var
  i, FNo: integer;
begin
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T777' then
    begin
      FNo := FRec.FormNo;
      Result := VL(FetchElmFNo(RetNo, FNo, 88)) +
        VL(FetchElmFNo(RetNo, FNo, 101));
    end;
  end;
end;

Procedure GetListOfT4SlipsForT777(RetNo: integer; AList: TStrings);
Var
  i: integer;
  SlipId: String;
Begin
  AList.Clear;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If Ret[RetNo].FrmHasData[FRec.FormNo] then // 20160813   //20170324 Igor
    begin
      if FRec.FormName = 'T4' then // 20101218
      begin
        If Ret[RetNo].FrmHasData[FRec.FormNo] then // 20170324 Igor
          AList.Add(PaddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst, 7)
            // + FetchElm(RetNo,LeftStr(FRec.FormName+FRec.FormInst,5)+' '
            + LeftStr(FetchElmFNo(RetNo, FRec.FormNo, 1), 15));
      end
    end;
  end;
end;

// 20220216
Function ValidateUSAZipCode(S: String): Boolean;
Var
  i, FNo: integer;
begin
  Result := true;
  if S > '' then
  Begin
    for i := 1 to Length(S) do
    begin
      If Not Numeric(MidStr(S, i, 1)) then
      begin
        Result := false;
        Exit;
      end;
    end;
  End;
end;

Function NonResWithEmpl(RetNo: integer): Boolean; // 20220407
Begin
  Result := false;
  //if IsNonResident(RetNo) and (not(IsDeemedResident(RetNo))) then //jz//NonResCERT//202404 - needs testing to see if works
  if IsNonResident(RetNo) then // 20240425
  begin
    if FetchElmFNo(RetNo, InfoFNo, 276) > '' then
      Result := true;
  end;
End;

// 20210408
Function GetNonResPercent(RetNo: integer): Real;
Begin
  if Ret[RetNo].Province = 'ZZ' then // 20240422
  begin
    Result := VL(FetchElm(RetNo, 'SNRESB', 2)); // gives frm o to 1oo;
  end;
End;

// 20210416
Procedure GetT2030AFarmExpenses(RetNo, FormNo: integer; Var ONexp: Real;
  Var MBexp: Real; Var SKexp: Real; Var ABexp: Real; Var ONMInv: Real;
  Var MBMInv: Real; Var SKMInv: Real; Var ABMInv: Real; Var ONOInv: Real;
  Var MBOInv: Real; Var SKOInv: Real; Var ABOInv: Real; Var ONGInc: Real;
  Var MBGINC: Real; Var SKGInc: Real; Var ABGInc: Real; Var ONSal: Real;
  Var MBSal: Real; Var SKSal: Real; Var ABSal: Real);
// get farm exp, Mandatory and Optional inventory adjustments and gross income
Var
  i, j, FNo: integer;
  FInst: String;
  lFrec: TFRec;
  PRV: String;
begin
  with Ret[RetNo].Frm[FormNo] do
  begin
    ONexp := 0;
    MBexp := 0;
    SKexp := 0;
    ABexp := 0;
    ONMInv := 0;
    MBMInv := 0;
    SKMInv := 0;
    ABMInv := 0;
    ONOInv := 0;
    MBOInv := 0;
    SKOInv := 0;
    ABOInv := 0;
    ONGInc := 0;
    MBGINC := 0;
    SKGInc := 0;
    ABGInc := 0;
    ONSal := 0;
    MBSal := 0;
    SKSal := 0;
    ABSal := 0;

    for i := 51 to 53 do
      Tv[i] := 0;
    for i := 55 to 56 do
      Tv[i] := 0;
    for i := 61 to 63 do
      Tv[i] := 0;
    for i := 65 to 66 do
      Tv[i] := 0;
    for i := 71 to 73 do
      Tv[i] := 0;
    for i := 75 to 76 do
      Tv[i] := 0;
    for i := 81 to 83 do
      Tv[i] := 0;
    for i := 85 to 86 do
      Tv[i] := 0;

    If Ret[RetNo].IsLastYearReturn then
      Exit; // 20160314 Igor
    for i := 0 to (FList.Count - 1) do
    begin
      lFrec := FList.Items[i];
      FNo := lFrec.FormNo;
      // 20220417
      If Ret[RetNo].FrmHasData[FNo] then
      begin
        If (lFrec.FormName = 'T2042') then
        Begin
          PRV := FetchElmFNo(RetNo, FNo, 71);
          if PRV = 'ON' then
          Begin
            ONexp := VL(FetchElmFNo(RetNo, FNo, 138));
            ONMInv := VL(FetchElmFNo(RetNo, FNo, 128));
            ONOInv := VL(FetchElmFNo(RetNo, FNo, 127));
            ONGInc := VL(FetchElmFNo(RetNo, FNo, 66));
            ONSal := VL(FetchElmFNo(RetNo, FNo, 115)); // 20220419

            Tv[51] := Tv[51] + ONexp;
            Tv[52] := Tv[52] + ONMInv;
            Tv[53] := Tv[53] + ONOInv;
            For j := 52 to 54 do
              Tv[55] := Tv[55] + Tv[j];
            Tv[56] := MaxR(0, Tv[51] - Tv[55]);
          End
          Else if PRV = 'MB' then
          Begin
            MBexp := VL(FetchElmFNo(RetNo, FNo, 138));
            MBMInv := VL(FetchElmFNo(RetNo, FNo, 128));
            MBOInv := VL(FetchElmFNo(RetNo, FNo, 127));
            MBGINC := VL(FetchElmFNo(RetNo, FNo, 66));
            MBSal := VL(FetchElmFNo(RetNo, FNo, 115));
            Tv[61] := Tv[61] + MBexp;
            Tv[62] := Tv[62] + MBMInv;
            Tv[63] := Tv[63] + MBOInv;
            For j := 62 to 64 do
              Tv[65] := Tv[65] + Tv[j];
            Tv[66] := MaxR(0, Tv[61] - Tv[65]);
          End
          Else if PRV = 'SK' then
          Begin
            SKexp := VL(FetchElmFNo(RetNo, FNo, 138));
            SKMInv := VL(FetchElmFNo(RetNo, FNo, 128));
            SKOInv := VL(FetchElmFNo(RetNo, FNo, 127));
            SKGInc := VL(FetchElmFNo(RetNo, FNo, 66));
            SKSal := VL(FetchElmFNo(RetNo, FNo, 115));
            Tv[71] := Tv[61] + SKexp;
            Tv[72] := Tv[62] + SKMInv;
            Tv[73] := Tv[63] + SKOInv;
            For j := 72 to 74 do
              Tv[75] := Tv[75] + Tv[j];
            Tv[76] := MaxR(0, Tv[71] - Tv[75]);
          End
          Else if PRV = 'AB' then
          Begin
            ABexp := VL(FetchElmFNo(RetNo, FNo, 138));
            ABMInv := VL(FetchElmFNo(RetNo, FNo, 128));
            ABOInv := VL(FetchElmFNo(RetNo, FNo, 127));
            ABGInc := VL(FetchElmFNo(RetNo, FNo, 66));
            ABSal := VL(FetchElmFNo(RetNo, FNo, 115));
            Tv[81] := Tv[81] + SKexp;
            Tv[82] := Tv[82] + SKMInv;
            Tv[83] := Tv[83] + SKOInv;
            For j := 82 to 84 do
              Tv[85] := Tv[85] + Tv[j];
            Tv[86] := MaxR(0, Tv[81] - Tv[85]);
          End
        end
        Else If (lFrec.FormName = 'T1163') Or (lFrec.FormName = 'T2273') then
        Begin
          PRV := FetchElmFNo(RetNo, FNo, 14);
          if PRV = 'ON' then
          Begin
            ONexp := VL(FetchElmFNo(RetNo, FNo, 602));
            ONMInv := VL(FetchElmFNo(RetNo, FNo, 538));
            ONOInv := VL(FetchElmFNo(RetNo, FNo, 539));
            ONGInc := VL(FetchElmFNo(RetNo, FNo, 526));
            ONSal := VL(FetchElmFNo(RetNo, FNo, 526));
            Tv[51] := Tv[51] + ONexp;
            Tv[52] := Tv[52] + ONMInv;
            Tv[53] := Tv[53] + ONOInv;
            For j := 52 to 54 do
              Tv[55] := Tv[55] + Tv[j];
            Tv[56] := MaxR(0, Tv[51] - Tv[55]);
          End;
        end
        {
          Else If (lFrec.FormName = 'T1273') then
          Begin
          Prv:=FetchElmFNo(RetNo,Fno,14);
          if Prv='ON' then
          Begin
          OnExp:=Vl(FetchElmFNo(RetNo,Fno,602));
          OnMInv:=Vl(FetchElmFNo(RetNo,Fno,538));
          OnOInv:=Vl(FetchElmFNo(RetNo,Fno,539));
          OnGInc:=Vl(FetchElmFNo(RetNo,Fno,526));
          OnSal:=Vl(FetchElmFNo(RetNo,Fno,526));
          Tv[61]:=Tv[61]+MbExp;
          Tv[62]:=Tv[62]+MbMInv;
          Tv[63]:=Tv[63]+MbOInv;
          For j:=61 to 65 do Tv[65]:=Tv[61]+Tv[j];
          Tv[66]:=MaxR(0,Tv[61]-Tv[65]);
          End;
          end;
        }
      end; // has data
    end; // i
  end;
end;

(*
  //put back 20220424
  Procedure GetT2030AFarmExpensesByRetNo(RetNo: Integer;
  Var ONexp:Real;Var MBexp:Real;Var SKexp:Real;Var ABexp:Real;
  Var ONMInv:Real;Var MBMInv:Real;Var SKMInv:Real;Var ABMInv:Real;
  Var ONOInv:Real;Var MBOInv:Real;Var SKOInv:Real;Var ABOInv:Real;
  Var ONGInc:Real;Var MBGINC:Real;Var SKGInc:Real;Var ABGInc:Real;
  Var ONSal:Real;Var MBSal:Real;Var SKSal:Real;Var ABSal:Real);
  //get farm exp, Mandatory and Optional inventory adjustments and gross income
  Var
  i, FNo: Integer;
  FInst: String;
  lFrec: TFRec;
  Prv:String;
  begin
  OnExp:=0;MbExp:=0;SkExp:=0;AbExp:=0;
  ONMInv:=0;MBMInv:=0;SKMInv:=0;ABMInv:=0;
  ONOInv:=0;MBOInv:=0;SKOInv:=0;ABOInv:=0;
  ONGInc:=0;MBGInc:=0;SKGInc:=0;ABGInc:=0;
  ONSal:=0;MBSal:=0;SKSal:=0;ABSal:=0;

  If Ret[RetNo].IsLastYearReturn then exit; // 20160314 Igor
  for i:= 0 to (FList.Count - 1) do
  begin
  lFrec := FList.Items[i];
  FNo := lFrec.FormNo;



  If Ret[RetNo].FrmHasData[FNo] then
  begin
  If (lFrec.FormName = 'T2042') then
  Begin
  Prv:=FetchElmFNo(RetNo,Fno,71);
  if Prv='ON' then
  Begin
  OnExp:=Onexp+Vl(FetchElmFNo(RetNo,Fno,138));
  OnMInv:=OnMInv+Vl(FetchElmFNo(RetNo,Fno,128));
  OnOInv:=OnOInv+Vl(FetchElmFNo(RetNo,Fno,127));
  OnGInc:=OnGInc+Vl(FetchElmFNo(RetNo,Fno,66));
  OnSal:=OnSal+Vl(FetchElmFNo(RetNo,Fno,115));
  End
  Else if Prv='MB' then
  Begin
  MBExp:=MBExp+Vl(FetchElmFNo(RetNo,Fno,138));
  MBMInv:=MBMInv+Vl(FetchElmFNo(RetNo,Fno,128));
  MBOInv:=MBOInv+Vl(FetchElmFNo(RetNo,Fno,127));
  MbGInc:=MBGInc+Vl(FetchElmFNo(RetNo,Fno,66));
  MbSal:=MBSal+Vl(FetchElmFNo(RetNo,Fno,115));
  End
  Else if Prv='SK' then
  Begin
  SKExp:=SKExp+Vl(FetchElmFNo(RetNo,Fno,138));
  SKMInv:=SKMInv+Vl(FetchElmFNo(RetNo,Fno,128));
  SKOInv:=SKOINV+Vl(FetchElmFNo(RetNo,Fno,127));
  SKGInc:=SKGInc+Vl(FetchElmFNo(RetNo,Fno,66));
  SKSal:=SKSal+Vl(FetchElmFNo(RetNo,Fno,115));
  End
  Else if Prv='AB' then
  Begin
  ABExp:=ABExp+Vl(FetchElmFNo(RetNo,Fno,138));
  ABMInv:=ABMInv+Vl(FetchElmFNo(RetNo,Fno,128));
  ABOInv:=ABOInv+Vl(FetchElmFNo(RetNo,Fno,127));
  ABGInc:=ABGInc+Vl(FetchElmFNo(RetNo,Fno,66));
  ABSal:=ABSal+Vl(FetchElmFNo(RetNo,Fno,115));
  End
  end
  Else If (lFrec.FormName = 'T1163') then
  Begin
  Prv:=FetchElmFNo(RetNo,Fno,14);
  if Prv='ON' then
  Begin
  OnExp:=Vl(FetchElmFNo(RetNo,Fno,602));
  OnMInv:=Vl(FetchElmFNo(RetNo,Fno,538));
  OnOInv:=Vl(FetchElmFNo(RetNo,Fno,539));
  OnGInc:=Vl(FetchElmFNo(RetNo,Fno,526));
  OnSal:=Vl(FetchElmFNo(RetNo,Fno,526));
  End;
  end

  Else If (lFrec.FormName = 'T1273') then
  Begin
  Prv:=FetchElmFNo(RetNo,Fno,14);
  if Prv='ON' then
  Begin
  OnExp:=Vl(FetchElmFNo(RetNo,Fno,602));
  OnMInv:=Vl(FetchElmFNo(RetNo,Fno,538));
  OnOInv:=Vl(FetchElmFNo(RetNo,Fno,539));
  OnGInc:=Vl(FetchElmFNo(RetNo,Fno,526));
  OnSal:=Vl(FetchElmFNo(RetNo,Fno,526));
  End;
  end;
  end;  //has data
  end; //i
  end;
*)



// 20220424

// 20210416
Procedure GetT2030AFarmExpensesByFarm(RetNo, FormNo: integer; FarmFname: string;
  FarmFNo: integer; Var ONexp: Real; Var MBexp: Real; Var SKexp: Real;
  Var ABexp: Real; Var ONMInv: Real; Var MBMInv: Real; Var SKMInv: Real;
  Var ABMInv: Real; Var ONOInv: Real; Var MBOInv: Real; Var SKOInv: Real;
  Var ABOInv: Real; Var ONGInc: Real; Var MBGINC: Real; Var SKGInc: Real;
  Var ABGInc: Real; Var ONSal: Real; Var MBSal: Real; Var SKSal: Real;
  Var ABSal: Real);
// get farm exp, Mandatory and Optional inventory adjustments and gross income
Var
  i, j, FNo: integer;
  FInst: String;
  lFrec: TFRec;
  PRV: String;
begin
  with Ret[RetNo].Frm[FormNo] do
  begin
    ONexp := 0;
    MBexp := 0;
    SKexp := 0;
    ABexp := 0;
    ONMInv := 0;
    MBMInv := 0;
    SKMInv := 0;
    ABMInv := 0;
    ONOInv := 0;
    MBOInv := 0;
    SKOInv := 0;
    ABOInv := 0;
    ONGInc := 0;
    MBGINC := 0;
    SKGInc := 0;
    ABGInc := 0;
    ONSal := 0;
    MBSal := 0;
    SKSal := 0;
    ABSal := 0;

    { section non needed //20220423
      for i:=51 to 53 do Tv[i]:=0;
      for i:=55 to 56 do Tv[i]:=0;
      for i:=61 to 63 do Tv[i]:=0;
      for i:=65 to 66 do Tv[i]:=0;
      for i:=71 to 73 do Tv[i]:=0;
      for i:=75 to 76 do Tv[i]:=0;
      for i:=81 to 83 do Tv[i]:=0;
      for i:=85 to 86 do Tv[i]:=0;
    }

    If Ret[RetNo].IsLastYearReturn then
      Exit; // 20160314 Igor

    // for i:= 0 to (FList.Count - 1) do
    // begin
    // lFrec := FList.Items[i];
    // FNo := FarmFNo; //lFrec.FormNo;
    // FormName:=GetFormName(FormFNo);
    // 20220417
    FNo := FarmFNo; // lFrec.FormNo;
    If Ret[RetNo].FrmHasData[FNo] then
    begin
      if LeftStr(FarmFname, 5) = 'T2042' then
      Begin
        PRV := FetchElmFNo(RetNo, FNo, 71);
        if PRV = 'ON' then
        Begin
          ONexp := VL(FetchElmFNo(RetNo, FNo, 138));
          ONMInv := VL(FetchElmFNo(RetNo, FNo, 128));
          ONOInv := VL(FetchElmFNo(RetNo, FNo, 127));
          ONGInc := VL(FetchElmFNo(RetNo, FNo, 66));
          ONSal := VL(FetchElmFNo(RetNo, FNo, 115)); // 20220419

          Tv[51] := Tv[51] + ONexp;
          Tv[52] := Tv[52] + ONMInv;
          Tv[53] := Tv[53] + ONOInv;
          For j := 52 to 54 do
            Tv[55] := Tv[55] + Tv[j];
          Tv[56] := MaxR(0, Tv[51] - Tv[55]);
        End
        Else if PRV = 'MB' then
        Begin
          MBexp := VL(FetchElmFNo(RetNo, FNo, 138));
          MBMInv := VL(FetchElmFNo(RetNo, FNo, 128));
          MBOInv := VL(FetchElmFNo(RetNo, FNo, 127));
          MBGINC := VL(FetchElmFNo(RetNo, FNo, 66));
          MBSal := VL(FetchElmFNo(RetNo, FNo, 115));
          Tv[61] := Tv[61] + MBexp;
          Tv[62] := Tv[62] + MBMInv;
          Tv[63] := Tv[63] + MBOInv;
          For j := 62 to 64 do
            Tv[65] := Tv[65] + Tv[j];
          Tv[66] := MaxR(0, Tv[61] - Tv[65]);
        End
        Else if PRV = 'SK' then
        Begin
          SKexp := VL(FetchElmFNo(RetNo, FNo, 138));
          SKMInv := VL(FetchElmFNo(RetNo, FNo, 128));
          SKOInv := VL(FetchElmFNo(RetNo, FNo, 127));
          SKGInc := VL(FetchElmFNo(RetNo, FNo, 66));
          SKSal := VL(FetchElmFNo(RetNo, FNo, 115));
          Tv[71] := Tv[61] + SKexp;
          Tv[72] := Tv[62] + SKMInv;
          Tv[73] := Tv[63] + SKOInv;
          For j := 72 to 74 do
            Tv[75] := Tv[75] + Tv[j];
          Tv[76] := MaxR(0, Tv[71] - Tv[75]);
        End
        Else if PRV = 'AB' then
        Begin
          ABexp := VL(FetchElmFNo(RetNo, FNo, 138));
          ABMInv := VL(FetchElmFNo(RetNo, FNo, 128));
          ABOInv := VL(FetchElmFNo(RetNo, FNo, 127));
          ABGInc := VL(FetchElmFNo(RetNo, FNo, 66));
          ABSal := VL(FetchElmFNo(RetNo, FNo, 115));
          Tv[81] := Tv[81] + SKexp;
          Tv[82] := Tv[82] + SKMInv;
          Tv[83] := Tv[83] + SKOInv;
          For j := 82 to 84 do
            Tv[85] := Tv[85] + Tv[j];
          Tv[86] := MaxR(0, Tv[81] - Tv[85]);
        End
      end
      Else If (lFrec.FormName = 'T1163') Or (lFrec.FormName = 'T2273') then
      Begin
        PRV := FetchElmFNo(RetNo, FNo, 14);
        if PRV = 'ON' then
        Begin
          ONexp := VL(FetchElmFNo(RetNo, FNo, 602));
          ONMInv := VL(FetchElmFNo(RetNo, FNo, 538));
          ONOInv := VL(FetchElmFNo(RetNo, FNo, 539));
          ONGInc := VL(FetchElmFNo(RetNo, FNo, 526));
          ONSal := VL(FetchElmFNo(RetNo, FNo, 526));
          Tv[51] := Tv[51] + ONexp;
          Tv[52] := Tv[52] + ONMInv;
          Tv[53] := Tv[53] + ONOInv;
          For j := 52 to 54 do
            Tv[55] := Tv[55] + Tv[j];
          Tv[56] := MaxR(0, Tv[51] - Tv[55]);
        End;
      end;
    end; // has data
    // end; //i
  end;
end;

Procedure GetT2030ACharts(RetNo: integer; FarmFname: String; FarmFNo: integer;
  Var Totexp: Real; Var TotMInv: Real; Var TotOInv: Real; Var TotGInc: Real;
  Var TotSal: Real);
// get farm exp, Mandatory and Optional inventory adjustments and gross income
Var
  i, FNo: integer;
  FInst: String;
  lFrec: TFRec;
  PRV: String;
begin
  // FNo:=FarmFNo;
  Totexp := 0;
  TotMInv := 0;
  TotOInv := 0;
  TotGInc := 0;
  TotSal := 0;

  If Ret[RetNo].IsLastYearReturn then
    Exit; // 20160314 Igor
  for i := 0 to (FList.Count - 1) do
  begin
    lFrec := FList.Items[i];
    FNo := lFrec.FormNo;
    If Ret[RetNo].FrmHasData[FNo] and (FNo = FarmFNo) then
    begin
      If (lFrec.FormName = 'T2042') then
      Begin
        Totexp := Totexp + VL(FetchElmFNo(RetNo, FNo, 138));
        TotMInv := TotMInv + VL(FetchElmFNo(RetNo, FNo, 128));
        TotOInv := TotOInv + VL(FetchElmFNo(RetNo, FNo, 127));
        TotGInc := TotGInc + VL(FetchElmFNo(RetNo, FNo, 66)) -
          VL(FetchElm(RetNo, FNo, 137)); // fuel charge
        // If FNo=FarmFNo then
        TotSal := TotSal + VL(FetchElmFNo(RetNo, FNo, 115)); // 20220424
      end
      Else If (lFrec.FormName = 'T1163') Or (lFrec.FormName = 'T1273') then
      Begin
        Totexp := Totexp + VL(FetchElmFNo(RetNo, FNo, 602));
        TotMInv := TotMInv + VL(FetchElmFNo(RetNo, FNo, 538));
        TotOInv := TotOInv + VL(FetchElmFNo(RetNo, FNo, 539));
        TotGInc := TotGInc + VL(FetchElmFNo(RetNo, FNo, 526)) -
          VL(FetchElm(RetNo, FNo, 137));
        // If FNo=FarmFNo then
        TotSal := TotSal + VL(FetchElmFNo(RetNo, FNo, 526));
      End;
    end; // has data
  end; // i
end;

Function GetSpouseAgeDeductionForMJ(SpRetNo: integer; RetNo, FNo: integer;
  PRV: String): Real; // 20220516
// PRV Contains the Mult Jurisdiction Province / gloal variable
// this is a replica of form field in AGEDED, to be used as a function.
// form incorrectly contains the Provincial part also
// FNo is irrelevant
Var
  i: integer;
  FedNi, Ni, PrvNi, x: Real;
  AgeDedFname: String; // 20240521
  AgeDedFNo: integer;
Begin
  If GetSpouseAge(RetNo) < 65 then
  begin
    Result := 0;
    Exit;
  end; // 20240529
  if IsMultJurisdiction(RetNo) = false then
  begin
    Result := 0;
    Exit;
  end; // main return
  Result := VL(FetchElm(RetNo, PRV + 'MJWS', 13));
End;

{
  if IsMultJurisdiction(RetNO) =false then begin Result:=0;Exit;end; //main return
  AgeDedFname:='AGEDED';
  AgeDedFNo:=GetFormNo(AgeDedFname);
  //StoreElm(SpRetNo,AgeDedFname,9,T2203Prov);  //done in ageded form
  //no need to save it . The calc in will pick it up
  LoadTv(SpRetNo, AgeDedFname, AgeDedFNo);
  Calc(SpRetNo,AgeDedFName); //reload  and calc
  if T2203Prov='NS' then
  Result:=Vl(FetchElmFNo(SpRetNo,AgeDedFNo,31))
  Else
  Result:=Vl(FetchElmFNo(SpRetNo,AgeDedFNo,17));
  //SaveTv(SpRetNo,AgeDedFname,AgeDedFNo);
  end;
}

(* pld GetspouseAgeDeductionfor MJ
  //====================================
  Result:=Vl(FetchElm(SpRetNo,'AGEDED',8));
  Exit;

  //============= //20240520=======================================
  Result := 0;
  with Ret[RetNo].Frm[FNo] do
  begin
  Tv[31] := 0; // used by NS only
  PRV := T2203Prov; // 20180326
  InitPrvConstants(PRV); // 20110310

  if IsMultJurisdiction(spretno) = false then
  Begin
  Prv := ret[spretno].Province; // 20180326
  InitPrvConstants(ret[spretno].Province); // 20110310
  end
  Else
  Begin
  Prv := T2203Prov; // 20180326
  InitPrvConstants(T2203Prov); // 20110310
  end;

  // 20090330
  // LoadTv(spretno, FName, FNo);
  With Ret[SpRetNo] do
  begin
  If IsPreBankruptcyReturn(SpRetNo) then
  Tv[1] := Constant[RY].MaxAgeAmount
  else
  Tv[1] := Constant[RY].MaxAgeAmount * PartYear;

  x := CalcMortgageForeclosure(Ret[SpRetNo].Lnn[12700],
  VL(FetchElmFNo(SpRetNo, GetFormNo('S3'), 122)),
  VL(FetchElmFNo(SpRetNo, GetFormNo('S3'), 72)));
  If x < 0 then
  x := 0;

  FedNi := MaxR(0, Lnn[23600] - x);
  if FetchElmFNo(SpRetNo, InfoFNo, 94) > '' then
  FedNi := MaxR(0, VL(FetchElm(SpRetNo, 'T1', 88)) - x); // 20220317

  If IsPreBankruptcyReturn(SpRetNo) then
  FedNi := MaxR(0, Lnn[23600] + VL(FetchElm(SpRetNo, 'BANKRPT', 13)) - x);

  // 20181221
  if (PRV = 'NS') then // 20191207
  PrvNi := FedNi // before TOSI
  Else
  Begin
  if TosiInEffect(SpRetNo) then
  FedNi := GetTosiNetIncome(SpRetNo);
  PrvNi := FedNi; // fter TOSI
  end;

  If (Age < 65) then
  begin
  For i := 1 to 31 do // 20211121  For i := 1 to 17 do
  begin
  // Frm[FNo].Strings[i] := '';
  Tv[i] := 0;
  end;
  Exit;
  end;

  Tv[2] := FedNi;
  If IsPreBankruptcyReturn(SpRetNo) then
  Tv[3] := Constant[RY].AgeBaseAmount
  else
  Tv[3] := Constant[RY].AgeBaseAmount * Ret[SpRetNo].PartYear;

  Tv[4] := MaxR(0, Tv[2] - Tv[3]);
  Tv[5] := 15;
  Tv[6] := Tv[4] * Tv[5] / 100;
  Tv[7] := Tv[6];
  Tv[8] := MaxR(0, Tv[1] - Tv[7]);

  If (Age < 65) or (FedNi >= Constant[RY].AgeNIThreshhold) then
  Tv[8] := 0;

  If IsPreBankruptcyReturn(SpRetNo) then
  Tv[8] := Tv[8] * PartYear;
  // If UpperCase(Frm[FNo].Strings[19]) = 'Y' then Tv[8] := Tv[18]; // 20100413
  { Provincial };
  { copy to prv }
  For i := 1 to 8 do
  Tv[i + 9] := Tv[i];

  // Strings[9] := '';
  // If FullToniProvince(spretno) then
  // begin
  // Frm[FNo].Strings[9] := Prv; // ret[spretno].Province;   //20180406
  If IsPreBankruptcyReturn(SpRetNo) then
  Tv[10] := PrvConstant[RY].PrvMaxAgeAmount
  else
  Begin
  Tv[10] := PrvConstant[RY].PrvMaxAgeAmount * Ret[SpRetNo].PartYear;
  End;

  Tv[11] := PrvNi;
  If (Ret[SpRetNo].Province = 'NL') then
  Tv[11] := Tv[2];
  // 20211229 //as in Federal NI ret[spretno].Lnn[23600]; // 20190203
  If IsPreBankruptcyReturn(SpRetNo) then // 20181201
  Tv[12] := PrvConstant[RY].PrvAgeBaseAmount
  else
  Begin
  Tv[12] := PrvConstant[RY].PrvAgeBaseAmount * Ret[SpRetNo].PartYear;
  End;
  Tv[13] := MaxR(0, Tv[11] - Tv[12]);
  Tv[15] := Tv[13] * Tv[14] / 100;
  Tv[16] := Tv[15];
  Tv[17] := MaxR(0, Tv[10] - Tv[16]);
  If (Age < 65) or (PrvNi >= PrvConstant[RY].PrvAgeNIThreshhold) then
  Tv[17] := 0;
  If IsPreBankruptcyReturn(SpRetNo) then
  Begin
  if Ret[SpRetNo].Province <> 'NS' then // 20181201  //20181204
  Tv[17] := Tv[17] * PartYear;
  End;
  // If UpperCase(Frm[FNo].Strings[21]) = 'Y' then Tv[17] := Tv[20]; // 20100413
  // NS //2018311128
  if PRV = 'NS' then
  // if ret[spretno].Province = 'NS' then
  Begin
  Tv[22] := 1465;
  Tv[23] := Ret[SpRetNo].Lnn[26000];
  If IsPreBankruptcyReturn(SpRetNo) then
  Tv[23] := Tv[23] + VL(FetchElm(SpRetNo, 'BANKRPT', 13));

  Tv[24] := 25000;
  Tv[25] := MaxR(0, Tv[23] - Tv[24]);
  Tv[26] := 2.93;
  Tv[27] := Tv[25] * Tv[26] / 100;
  Tv[28] := Tv[27];
  Tv[29] := MaxR(0, Tv[22] - Tv[28]);
  Tv[30] := Tv[29];
  // 20181204
  Tv[31] := (Tv[17] + Tv[30]) * PartYear; // 20181201
  Tv[31] := MinR(5606, Tv[31]);
  End
  Else
  begin
  for i := 22 to 31 do
  Tv[i] := 0;
  end;
  // end;
  Result := Tv[17];
  if Tv[31] > 0 then
  Result := Tv[31];
  // if ret[spretno].Province = 'NS' then Result:=Tv[31];  //does not work
  end;
  // SaveTv(spretno, FName, FNo);
  end;
  end;
*)

// 20220520
Function MaxStLoan(RetNo: integer): Real;
Var
  x, Y, L350, L335, L338: Real;
begin
  With Ret[RetNo] do
  begin
    L335 := Lnn[30000] + Lnn[30100] + Lnn[30300] + Lnn[30400] + Lnn[306] +
      Lnn[30800] + Lnn[31000] + Lnn[31200] + Lnn[31400] + Lnn[31500] +
      Lnn[31600] { +Lnn[31900] stloan excluded }
      + Lnn[32300] + Lnn[32400] + Lnn[32600] + Lnn[33200];

    L338 := L335 * (15 / 100); // not 16   //20220518
    L350 := L338 + Lnn[34900];

    // calc deductions based on the new L350
    x := L350 + Lnn[40425] + Lnn[42600] + Lnn[40427]; // 20191110 ???
    // +Lnn[41450];
    Y := VL(FetchElm(RetNo, 'T1', 132)); // 20220518
    Result := MaxR(0, Y - x) * 100 / 15; // 15 not 16
    If Result < 0.05 then
      Result := 0;
  end;
end;


(*
  //?? NOT USED  CANNOT DO IT: our file shilud have the codes used by Autofill
  //FCurrency.d needs to have all currencies from Autofill
  Function GetExchRate(Country:String):String;
  Var i:Integer;Alist:=Tstringlist(Create);
  Begin
  Result:='';
  Alist.LoadFromFile(AppDir+'\'+'Fcurrency.d');
  for i:=0 to AlistClint-1 do
  begin
  if Alist[i];=Country then begin result:=AllTrim(MidStr(Alist,5,7));end;
  end;
  end;
*)

// 20230502
Function IsDiepEligible(Cls: String; PurchaseDate: String): Boolean;
Begin
  Result := true;
  if ((Cls > '0') and (Cls < '7')) Or (Cls = '14.1') Or (Cls = '17') Or
    (Cls = '47') Or (Cls = '49') Or (Cls = '51') Or
    (PurchaseDate < '2022-01-01') // 20230515
    Or (PurchaseDate > '2024-12-31') // 20230515
  then
    Result := false;
End;

// 20230519  Con
Procedure PostAutosAdditions(RetNo: integer; FName: String; Stmt: String;
  FInst: String; FNo: integer; StartNdx, EndNdx, IncrBy, EndSectionNdx,
  RemainingNdx, TotalNdx: integer);
Var
  i, j: integer;
  RemainingAmount: Real;
  TermLossAmount, RecaptAmount: Real;
  CCAForStatement: Real;
begin
  ExtractAutos(RetNo, Stmt, FInst, TermLossAmount, RecaptAmount,CCAForStatement);
  // ShowMessage('ExtractedCCAlist='+IntToStr(ExtractedCCAlist.Count)); //20230519
  {
    For i := StartNdx to EndSectionNdx do
    begin
    Tv[i] := 0;
    StoreElm(RetNo, FNo, i, '');
    end; // clear section
  }
  with Ret[RetNo].Frm[FNo] do
  begin
    RemainingAmount := 0;
    Tv[RemainingNdx] := 0;
    j := StartNdx;
    For i := 0 to ExtractedAutoList.Count - 1 do
    begin
      ExtractedAutoRec := ExtractedAutoList.Items[i];
      If IsAutosClass(ExtractedAutoRec.ClassId) = true then
      Begin
        If ExtractedAutoRec.Additions > 0 then // 20220522 CON
        begin
          If j > EndNdx then
            RemainingAmount := MaxR(0, RemainingAmount + ExtractedAutoRec.Cost -
              ExtractedAutoRec.ProceedsPersonal)
            else
            begin
              StoreElm(RetNo, FNo, j, ExtractedAutoRec.ClassId);
              StoreElm(RetNo, FNo, j + 1, ExtractedAutoRec.Description);
              Tv[j + 2] := ExtractedAutoRec.Cost;
              Tv[j + 3] := ExtractedAutoRec.AdditionsPersonal;
              Tv[j + 4] := MaxR(0, Tv[j + 2] - Tv[j + 3]);
              inc(j, IncrBy);
            end; //j > EndNdx
        end; //ExtractedAutoRec.Additions  //jz//CCAv8 - was in wrong place causing issues
      end; // autoclass
    end; // i
    Tv[RemainingNdx] := RemainingAmount;
  end;
end;

// 20230519
Procedure PostAutosDispositions(RetNo: integer; FName: String; Stmt: String;
  FInst: String; FNo: integer; StartNdx, EndNdx, IncrBy, EndSectionNdx,
  RemainingNdx, TotalNdx: integer);
Var
  i, j: integer;
  RemainingAmount: Real;
  TermLossAmount, RecaptAmount: Real;
  CCAForStatement: Real;
begin
  ExtractAutos(RetNo, Stmt, FInst, TermLossAmount, RecaptAmount,
    CCAForStatement);
  {
    For i := StartNdx to EndSectionNdx do
    begin
    Tv[i] := 0;
    StoreElm(RetNo, FNo, i, '');
    end; // clear section
  }
  with Ret[RetNo].Frm[FNo] do
  begin
    RemainingAmount := 0;
    Tv[RemainingNdx] := 0;
    j := StartNdx;
    For i := 0 to ExtractedAutoList.Count - 1 do
    begin
      ExtractedAutoRec := ExtractedAutoList.Items[i];
      If IsAutosClass(ExtractedAutoRec.ClassId) = true then
      begin
        If ExtractedAutoRec.Proceeds > 0 then
        begin
          If j > EndNdx then
            RemainingAmount :=
              MaxR(0, RemainingAmount + ExtractedAutoRec.Proceeds -
              ExtractedAutoRec.ProceedsPersonal)
          else
          begin
            StoreElm(RetNo, FNo, j, ExtractedAutoRec.ClassId);
            StoreElm(RetNo, FNo, j + 1, ExtractedAutoRec.Description);
            Tv[j + 2] := ExtractedAutoRec.Proceeds;
            Tv[j + 3] := ExtractedAutoRec.ProceedsPersonal;
            inc(j, IncrBy);
          end;
        end;
      end;
    end; // i
    Tv[RemainingNdx] := RemainingAmount;
  end;
end;

// 20160503  //20230801 Copied from T2-2024 Con
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

function GetT1134ForeignAffiliatesIdentificationNumber(ARetNo: integer;
  AName: string): string; // 20230510 Igor //20230601 Igor
var
  FormNo, i: integer;
  function GetForeignAffiliatesNumber(ArrayNo, ElmNameId, ElmNumberId: integer)
    : string; // 20230619 Igor
  var
    BoxesPerRow, ElmName, ElmNumber, RowCount, i: integer;
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
        Break;
      end;
      ElmName := ElmName + BoxesPerRow;
      ElmNumber := ElmNumber + BoxesPerRow;
    end;
  end;

begin
  For i := 1 to 10 do
  begin
    FormNo := GetFormNo('T1134S#' + IntToStr(i));
    If FormNo > 0 then
      if SameText(FetchElmFNo(ARetNo, FormNo, 35), AName) then
      begin
        Result := FetchElmFNo(ARetNo, FormNo, 4);
        Break;
      end;
  end;
  // 20230619 Igor >>>
  FormNo := GetFormNo('T1134');
  if Result.IsEmpty then
    Result := GetForeignAffiliatesNumber(7, 4, 5);
  // 20230619 Igor <<<
end;

procedure PopulateT1134ForeignAffiliates(ARetNo: integer; AList: TStringList);
// 20230510 Igor //20230601 Igor //20230712 Igor
var
  FormNo, i: integer;
  TempList: TStringList;
  //SortList: TStringList;//20260213 Igor

  procedure AddToList(AValue: string); // 20230619 Igor
  begin
    if not AValue.IsEmpty and (TempList.IndexOf(AValue) = -1) then
      TempList.Add(AValue);
  end;

  procedure PopulateForeignAffiliates(ArrayNo, ElmId: integer);
  var
    BoxesPerRow, ElmName, RowCount, i: integer;
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
  //20260213 Igor >>>
  {SortList:= TStringList.Create;
  try
    for i:= 0 to pred(AList.Count) do
      if Pos('other', LowerCase(AList.Strings[i])) = 0 then
        SortList.Add(AList.Strings[i]);

    for i:= 0 to pred(AList.Count) do
      if Pos('other', LowerCase(AList.Strings[i])) > 0 then
        SortList.Add(AList.Strings[i]);

//    for i:= 3 to 3 do
//      if Pos('other', LowerCase(AList.Strings[i])) = 0 then
//        SortList.Add(AList.Strings[i]);

    AList.Text:= SortList.Text;
  finally
    SortList.Free;
  end;   }
  //20260213 Igor <<<
  TempList := TStringList.Create;
  try
    For i := 1 to 10 do
    begin
      FormNo := GetFormNo('T1134S#' + IntToStr(i));
      If FormNo > 0 then
        AddToList(FetchElmFNo(ARetNo, FormNo, 35)); // 20230619 Igor
    end;
    // 20230619 Igor >>>
    FormNo := GetFormNo('T1134');
    PopulateForeignAffiliates(7, 4);
    // 20230619 Igor <<<

    // remove non existing
    for i := AList.Count - 1 downto 0 do
      if TempList.IndexOf(AList.Strings[i]) = -1 then
        AList.Delete(i);

    // add new
    for i := 0 to TempList.Count - 1 do
      if AList.IndexOf(TempList.Strings[i]) = -1 then
        AList.Add(TempList.Strings[i]);
  finally
    TempList.Free;
  end;
  StoreElm(ARetNo, 'STATUS', T1134_FA_LIST, AList.Text);
end;

(*
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
*)
function GetT1134ForeignAffiliatesCountryCode(ARetNo: integer; AName: string)
  : string; // 20230601 Igor
var
  FormNo, i: integer;
  function GetForeignAffiliatesCountryCode(ArrayNo, ElmNameId,
    ElmNumberId: integer): string; // 20230619 Igor
  var
    BoxesPerRow, ElmName, ElmNumber, RowCount, i: integer;
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
        Break;
      end;
      ElmName := ElmName + BoxesPerRow;
      ElmNumber := ElmNumber + BoxesPerRow;
    end;
  end;

begin
  For i := 1 to 10 do
  begin
    FormNo := GetFormNo('T1134S#' + IntToStr(i));
    If FormNo > 0 then
      if SameText(FetchElmFNo(ARetNo, FormNo, 35), AName) then
      begin
        Result := FetchElmFNo(ARetNo, FormNo, 48);
        Break;
      end;
  end;
  // 20230619 Igor >>>
  FormNo := GetFormNo('T1134');
  if Result.IsEmpty then
    Result := GetForeignAffiliatesCountryCode(7, 4, 6);
  // 20230619 Igor <<<
end;

function GetT1134GroupList(ARetNo: integer): TArray<T1134GroupItem>;
// 20230510 Igor
var
  FormNo: integer;

  procedure AddItem(AName, ANumber: string; AType: TGroupItemAccountType);
  begin
    SetLength(Result, Length(Result) + 1);
    Result[Length(Result) - 1].Name := AName;
    Result[Length(Result) - 1].AccountNumber := ANumber;
    Result[Length(Result) - 1].AccountType := AType;
  end;

  procedure PopulateGroupList(ArrayNo: integer; AType: TGroupItemAccountType;
    ElmNumberId, ElmNameId: integer; ElmName2Id: integer = 0);
  var
    BoxesPerRow, ElmName, ElmName2, ElmNumber, RowCount, i: integer;
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
        AddItem(ValueName, ValueNumber, AType);
      ElmNumber := ElmNumber + BoxesPerRow;
      ElmName := ElmName + BoxesPerRow;
      if ElmNameId <> 0 then
        ElmName2 := ElmName2 + BoxesPerRow;
    end;
  end;

begin
  FormNo := GetFormNo('T1134');
  AddItem(FetchElmFNo(ARetNo, FormNo, 2) + ' ' + FetchElmFNo(ARetNo, FormNo, 3),
    FetchElmFNo(ARetNo, FormNo, 5), atIndividual); // 20230811 Igor
  PopulateGroupList(1, atIndividual, 10, 1, 3);
  PopulateGroupList(2, atCorporation, 8, 1);
  PopulateGroupList(3, atTrust, 8, 1);
  PopulateGroupList(4, atPartnership, 8, 1);
end;

procedure PopulateT1134GroupList(ARetNo: integer; AList: TStringList;
  AShowName: Boolean); // 20230510 Igor //20230619 Igor
var
  Arr: TArray<T1134GroupItem>;
  i: integer;
begin
  Arr := GetT1134GroupList(ARetNo);
  for i := 0 to Length(Arr) - 1 do
    // 20230619 Igor >>>
    if AShowName then
      AList.Add(Arr[i].AccountNumber + ' - ' + Arr[i].Name)
    else
      AList.Add(Arr[i].AccountNumber);
  // 20230619 Igor <<<
end;

procedure PopulateT1134SGroupList(ARetNo, AFormNo: integer; AList: TStringList;
  AOnlyArrayNo: integer = 0); // 20230510 Igor

  procedure PopulateList(AArrayNo: integer);
  var
    BoxesPerRow, elm, RowCount, i, j: integer;
    ValueName, ValueNumber: string;
  begin
    BoxesPerRow := RetList[ARetNo].Frm[AFormNo].FormDataRec.BoxesPerRow
      [AArrayNo];
    elm := AArrayNo * 10000;
    RowCount := DynamicRowCount(ARetNo, AFormNo, AArrayNo);
    For i := 0 to RowCount - 1 do
    begin
      for j in [2, 3, 4, 5] do
      begin
        ValueNumber := FetchElmFNo(ARetNo, AFormNo, elm + j);
        if not ValueNumber.IsEmpty then
          Break;
      end;
      ValueName := FetchElmFNo(ARetNo, AFormNo, elm + 1);
      if not ValueName.IsEmpty and not ValueNumber.IsEmpty then
        AList.Add(ValueNumber + ' - ' + ValueName);
      elm := elm + BoxesPerRow;
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

Function GetResidencyType(RetNo: integer): String; // 20240126
Begin
  Result := '1';
  if FetchElmFNo(RetNo, InfoFNo, 227) > '' then
    Result := '2'
  Else if FetchElmFNo(RetNo, InfoFNo, 228) > '' then
    Result := '3'
  Else if FetchElmFNo(RetNo, InfoFNo, 229) > '' then
    Result := '4'
  Else if FetchElmFNo(RetNo, InfoFNo, 230) > '' then
    Result := '5'
  Else if FetchElmFNo(RetNo, InfoFNo, 231) > '' then
    Result := '6'
  Else if FetchElmFNo(RetNo, InfoFNo, 232) > '' then
    Result := '7';
End;

Function GetResidencyStatus(RetNo: integer): String; // 20240213
Var
  T1248FNo: integer;
Begin
  T1248FNo := GetFormNo('T1248');
  Result := '';
  if FetchElmFNo(RetNo, T1248FNo, 1) > '' then
    Result := 'a non-resident of Canada'
  Else If FetchElmFNo(RetNo, T1248FNo, 2) > '' then
    Result := 'a deemed non-resident of Canada'
  Else If FetchElmFNo(RetNo, T1248FNo, 3) > '' then
    Result := 'a factual resident of Canada';
End;

Function IsFirstTimeFiler(RetNo: integer): Boolean; // 20240209
Begin
  Result := false;
  if FetchElmFNo(RetNo, InfoFNo, 139) > '' then
    Result := true;
end;

Function GetResidencySection(RetNo: integer): String; // 20240213
Begin
  Result := '';
  if FetchElmFNo(RetNo, InfoFNo, 237) > '' then
    Result := '115'
  Else if FetchElmFNo(RetNo, InfoFNo, 238) > '' then
    Result := '116'
  Else if FetchElmFNo(RetNo, InfoFNo, 239) > '' then
    Result := '216'
  Else if FetchElmFNo(RetNo, InfoFNo, 240) > '' then
    Result := '216.1'
  Else if FetchElmFNo(RetNo, InfoFNo, 241) > '' then
    Result := '217'
End;

(* not used
  Function Ln17906Completed(RetNo:Integer):Boolean; //in S3  //20240217
  Var S3FNo:Integer;
  Begin
  S3FNo:=GetFormNo('S3');
  if (FetchElmFNo(RetNo,S3FNo,107)>'' then begin Result:-True;Exit;end;
  Or (FetchElmFNo(RetNo,S3FNo,108)>'' then begin Result:-True;Exit;end;
  Or (FetchElmFNo(RetNo,S3FNo,150)>'' then begin Result:-True;Exit;end;
  Or (FetchElmFNo(RetNo,S3FNo,151)>'' then begin Result:-True;Exit;end;
  Or (FetchElmFNo(RetNo,S3FNo,111)>'' then begin Result:-True;Exit;end;
  Or (FetchElmFNo(RetNo,S3FNo,112)>'' then begin Result:-True;Exit;end;
  Or (FetchElmFNo(RetNo,S3FNo,112)>'' then begin Result:-True;Exit;end;
  then begin Result:-True;Exit;end;
  End;
*)

Function IsDeemedNonRes(RetNo: integer): Boolean; // 20240209
Begin
  Result := false;
  if (FetchElmFNo(RetNo, InfoFNo, 252) > '') then
    Result := true;
end;

Function IsCanadianResident(RetNo: integer): Boolean; // 20240428B
Begin
  Result := false;
  if (FetchElmFNo(RetNo, InfoFNo, 226) > '') then
    Result := true;
end;

Function IsFactualResident(RetNo: integer): Boolean; // 20240424C
Begin
  Result := false;
  if (FetchElmFNo(RetNo, InfoFNo, 227) > '') then
    Result := true;
end;

Function IsDeemedResident(RetNo: integer): Boolean; // 20240209
Begin
  Result := false;
  if (FetchElmFNo(RetNo, InfoFNo, 253) > '') or
     (FetchElmFNo(RetNo, InfoFNo, 254) > '')      //jz//NonResCERT//202404
  then
    Result := true;
end;

Function IsDeemedRes183(RetNo: integer): Boolean; // 20240209
Begin
  Result := false;
  if (FetchElmFNo(RetNo, InfoFNo, 253) > '') then
    Result := true;
end;

Function IsDeemedResOther(RetNo: integer): Boolean; // 20240209
Begin
  Result := false;
  if (FetchElmFNo(RetNo, InfoFNo, 254) > '') then
    Result := true;
end;

Function IsDeemedResQuebec(RetNo: integer): Boolean;  //jz//NonResCERT-R1//202404
Begin
  Result := false;
  if (FetchElmFNo(RetNo, InfoFNo, 204) > '') then
    Result := true;
end;

// 20249414  Check autos form
Function GetTotalTerminalLoss(RetNo: integer; StmtId: String;StatementInst: String): Real; // i.e for T2125
// from both autos and assetsb
Var
  i, FNo: integer;
  TermLossElm: integer;

Begin
  Result := 0;

  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If (FRec.FormName = 'AUTOS') Or (FRec.FormName = 'ASSETSB') then
    begin
      FNo := FRec.FormNo;
      If  ((FetchElmFNo(RetNo, FNo, 215) = StmtId + StatementInst) and (VL(FetchElmFNo(RetNo, FNo, 216)) > 0)) or
          ((FetchElmFNo(RetNo, FNo, 221) = StmtId + StatementInst) and (VL(FetchElmFNo(RetNo, FNo, 222)) > 0)) or
          ((FetchElmFNo(RetNo, FNo, 227) = StmtId + StatementInst) and (VL(FetchElmFNo(RetNo, FNo, 228)) > 0))
      then
      Begin
        If      FRec.FormName = 'AUTOS'   then TermLossElm := 20
        else If FRec.FormName = 'ASSETSB' then TermLossElm := 20;   //jz//20260414??CCAv7 - ASSETSB TermLossElm is same as AUTOS now //16;

        if VL(FetchElmFNo(RetNo, FNo, TermLossElm)) > 0 then
          Result := Result + VL(FetchElmFNo(RetNo, FNo, TermLossElm)); // term loss
      End;
    end;
  End; // i
end;


//jz//20260414??CCAv7 - add this function for consistancy with terminal loss
Function GetTotalRecaptureAmt(RetNo: integer; StmtId: String;StatementInst: String): Real; // i.e for T2125
Var
  i, FNo, RecapAmtElm : integer;
Begin
  Result := 0;

  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If (FRec.FormName = 'AUTOS') Or (FRec.FormName = 'ASSETSB') then // from both autos and assetsb
    begin
      FNo := FRec.FormNo;
      If  ((FetchElmFNo(RetNo, FNo, 215) = StmtId + StatementInst) and (VL(FetchElmFNo(RetNo, FNo, 216)) > 0)) or
          ((FetchElmFNo(RetNo, FNo, 221) = StmtId + StatementInst) and (VL(FetchElmFNo(RetNo, FNo, 222)) > 0)) or
          ((FetchElmFNo(RetNo, FNo, 227) = StmtId + StatementInst) and (VL(FetchElmFNo(RetNo, FNo, 228)) > 0))
      then
      Begin
        If      FRec.FormName = 'AUTOS'   then RecapAmtElm := 21
        else If FRec.FormName = 'ASSETSB' then RecapAmtElm := 21;

        if VL(FetchElmFNo(RetNo, FNo, RecapAmtElm)) > 0 then
          Result := Result + VL(FetchElmFNo(RetNo, FNo, RecapAmtElm)); // recapture amt
      End;
    end;
  End; // i
end;
Function ShouldZeroOutNonRefLines(RetNo: integer): Boolean; // 20240424
begin
  If (IsSection116(RetNo)) then begin result:=True;Exit;end; //20260506 // //taxbl cap gains
  If (IsSection216(RetNo)) then begin result:=True;Exit;end; //20260506   //T1159/rental
  If (IsSection2161(RetNo)) then begin result:=True;Exit;end; //20260506 actor's election
  Result := false;
  if Immigrant(RetNo) then  Exit;
  If Emigrant(RetNo) then   Exit;
  if IsResident(RetNo) Then  Exit; // 20240424
  if IsSection217(RetNo) then  Exit;
  If IsSection115(RetNo) then  Exit; // 20240424b

  If IsDeemedResident(RetNo) then
  begin
    Result := false;
    If ((FetchElm(RetNo, 'T1248', 1) > '') or (FetchElm(RetNo, 'T1248', 2) > ''))
    then // ..17700 =2  or 1
    begin
      Result := true;
      Exit;
    end;
  End; // 20240516 //????

  If IsDeemedRes183(RetNo) then
  begin
    Result := false;
    Exit;
  End; // ???
  If IsDeemedResOther(RetNo) then
  begin
    Result := false;
    Exit;
  End; // ??? other types of deemed?  //20240516
  // If IsDeemedNonRes(RetNo)then Exit;  //20240515
  If IsFactualResident(RetNo) then
  begin
    Result := false;
    Exit;
  End; // 202404C
  if GetResidencyType(RetNo) = '6' then
  begin
    Result := false;
    Exit;
  End; // 20240515
  // --------------------------------------

  if (IsNonResident(RetNo)) = true and (FetchElm(RetNo, 'SNRESB', 4) = 'Y')
  // SB allowed but not section 217
    And (VL(FetchElm(RetNo, 'SNRESB', 2)) < 90) // %
  then
  Begin
    Result := true;
    Exit;
  end; //

  // 20240513
  if (IsNonResident(RetNo)) = true And (VL(FetchElm(RetNo, 'SNRESB', 2)) < 90)
  // %
    and (FetchElm(RetNo, 'T1248', 2) > '') // 17700 =2  //deemed not resident
  then
  Begin
    Result := true;
    Exit;
  End;
end;

Procedure ZeroOutNonRefLines(RetNo: integer); // 20240424
var
  i: integer;
  NonRefLines: TStringList;
  Lin: integer;
  Ln31600, Ln31900, ln32300, ln34900: Real; // Only nonref that can be claimed
  T1FNo: integer;
begin
  If ShouldZeroOutNonRefLines(RetNo) = false then
    Exit;
  T1FNo := GetFormNo('T1');
  NonRefLines := TStringList.Create;
  NonRefLines.LoadFromFile(AppDir + '\' + 'NonRefLines.D');

  With Ret[RetNo] do
  Begin
    Ln31600 := VL(FetchElmFNo(RetNo, T1FNo, 91));
    // Lnn[31600];  //disability //20240425
    Ln31900 := Lnn[31900];
    ln32300 := Lnn[32300];
    ln34900 := Lnn[34900];

    for i := 98 to 113 do
    begin
      StoreElm(RetNo, T1FNo, i, '');
    end; // 20240425  //retain 114 = //Ln31600 disability
    for i := 115 to 118 do
    begin
      StoreElm(RetNo, T1FNo, i, '');
    end; // 20240425
    for i := 157 to 157 do
    begin
      StoreElm(RetNo, T1FNo, i, '');
    end; // dig news
    for i := 92 to 92 do
    begin
      StoreElm(RetNo, T1FNo, i, '');
    end; // leave [91] disability  in  //20240424
    for i := 96 to 96 do
    begin
      StoreElm(RetNo, T1FNo, i, '');
    end; // spouse xfer
    // -----------------------------
    for i := 0 to NonRefLines.Count - 1 do
    Begin
      Lin := MyStrToInt(LeftStr(NonRefLines[i], 5));
      If Lin > 0 then
        Lnn[Lin] := 0;
      xx := Ret[RetNo].Lnn[Lin];
    End;
    // for some reason it not zeroed out
    Lnn[31260] := 0;
    StoreElm(RetNo, T1FNo, 114, '');

    // special cases for Section116
    Lnn[31600] := Ln31600;
    Lnn[31900] := Ln31900;
    Lnn[32300] := ln32300;
    Lnn[34900] := ln34900; // 20240424b
    //

    Lnn[35000] := (Ln31600 + Ln31900 + ln32300 + ln34900) * 15 / 100;

    { //20240501 no diffrence
      if (isNonResident(RetNo)) and (FetchElm(RetNo,'SNRESB',4)='Y')
      //and (getNonResPercent(RetNo)<90)  //20240501 ??
      THEN //20240430
      Lnn[35000]:=vl(fetchElm(RetNo,'T1',71));
    }
    // also overpayments
    Lnn[44800] := 0;
    StoreElm(RetNo, T1FNo, 419, '');

    Lnn[45000] := 0;
    StoreElm(RetNo, T1FNo, 420, '');

  End;
  NonRefLines.Free;
end;

// 20241120
Procedure GetMaxCPPAdditionalAmounts(RetNo: integer; Months: integer;
  MaxAdditionalCPPPensionableEarnings: Real;
  MaxAdditionalCPPContributions: Real);
begin
  if Months = 12 then
  begin
    Constant[0].MaxAdditionalCPPPensionableEarnings := 0;
    Constant[0].MaxAdditionalCPPContributions := 0;

    Constant[0].MaxAdditionalCPPPensionableEarnings := 73200;
    Constant[0].MaxAdditionalCPPContributions := 4700;
  end
  Else
    ShowMessage
      ('CPP months less than 12. Please complete the CPP boxes on page 4 of form RC381');
end;

// 20241120
Procedure GetMaxQPPAdditionalAmounts(RetNo: integer; Months: integer;
  MaxAdditionalPensionableEarnings: Real; MaxAdditionalContributions: Real);
begin
  if Months = 0 then
  begin
    Constant[0].MaxAdditionalQPPPensionableEarnings := 0;
    Constant[0].MaxAdditionalQPPContributions := 0;
  end;

  if Months = 12 then
  begin
    Constant[0].MaxAdditionalQPPPensionableEarnings := 73200;
    Constant[0].MaxAdditionalQPPContributions := 4700;
  end
  Else
    ShowMessage
      ('QPP months less than 12. Please complete the QPP boxes on page 4 of form RC381');
end;

function GetFormType(FName: string): string;
begin
  Result := FList.ByFormName(FName).FormType;
end;

// jz//20250213 replaced with CZ version
// 20250212
Function GetEfileDname(RetNo: integer): String;
// it contains all lines for Efile submission
Begin
  Result := 'EFLINE.D';
  if Rc381InEffect(RetNo) then
    Result := 'EFLINE-QC.D';
end;

// jz//20250213 replaced with CZ version
// 20250130
Function GetCppScheduleName(RetNo: integer): String;
// it contains all lines for Efile submission
Begin
  Result := 'S8';
  If Rc381InEffect(RetNo) then
    Result := 'RC381';
end;

// 20250220
Function PlacementOfficeSlip(RetNo: integer): Boolean;
Var
  i, FNo: integer;
begin
  Result := false;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T4' then
    begin
      FNo := FRec.FormNo;
      If FetchElmFNo(RetNo, FNo, 46) = '11' then
      begin
        Result := true;
        Exit;
      end;
    end;
  end;
end;

// 20250221
function selectNetIncomeAmount(RetNo: integer): Real;
begin
  if is23600Negative then
    Result := Lnn23600NegativeAmount
  else
    Result := Ret[RetNo].Lnn[23600];
end;

function selectTaxableIncomeAmount(RetNo: integer): Real;
begin
  if is26000Negative then
    Result := Lnn26000NegativeAmount
  else
    Result := Ret[RetNo].Lnn[26000];
end;

function selectSpouseNetIncomeAmount(RetNo: integer): Real;
var
  SpNetIncTemp: string;
begin
  Result := VL(FetchElm(RetNo, InfoFNo, 19));

  if TosiInEffect(RetNo) then // should test if married or common law also ??
  begin

    SpNetIncTemp := FetchElm(RetNo, InfoFNo, 29);
    if SpNetIncTemp > '' then
      Result := VL(SpNetIncTemp);

    SpNetIncTemp := FetchElm(RetNo, InfoFNo, 30);
    if SpNetIncTemp > '' then
      Result := VL(SpNetIncTemp);

    // SpNetIncTemp := FetchElm(RetNo, InfoFNo, 47);
    // if SpNetIncTemp > '' then result := VL(SpNetIncTemp);

    // use these functions??
    // ??Function GetSpouseSplitIncome(RetNo, InfoFormNo: integer): Real;
    // ??Function GetSpouseTosiNetIncome(RetNo, InfoFormNo: integer): Real;

  end;

end;

function calcLNN10100(RetNo: integer): Real; //jz//20260202
begin
    result := ret[RetNo].T4Gross + vl(FetchElm(RetNo, 'T1212', 3)) //jz//20251217 - T1212 form updated, change from elm tv[4] to tv[3]
      -TotMultiple(RetNo, 'T4', 19) - vl(FetchElm(RetNo, 'OTHINC', 33)) +
      vl(FetchElm(RetNo, 'T1SALDIV', 4)); // 20200829
end;


function GetLine51201FromRc269(RetNo: integer): Real; // 20260203
begin
  Result := VL(FetchElm(RetNo, 'RC269', 54));
end;


function GetLine51200FromRc269(RetNo: integer): Real; // 20250306
begin
  Result := VL(FetchElm(RetNo, 'RC269', 51));
end;

{
  //jz//20250224 consolidate with selectSpouseNetIncomeAmount //20230418
  Function GetSpouseNetIncome(RetNo: integer): Real; // 20230418
  Begin
  Result := VL(FetchElm(RetNo, InfoFNo, 19));
  End;
}

// remove the password from the text file and save
procedure saveXMLWithNoCRAPasswordID(savelocation: string; AList: TStringList;
  SaveTheXML: Boolean);
var
  i: integer;
  atempList: TStringList;
begin
  if SaveTheXML then
  begin
    // if (askForPassword) then
    // if (GetDeveloperPwd) then

    begin
      atempList := TStringList.Create;
      For i := 0 to AList.Count - 1 do
      begin
        atempList.Add(AList[i]);
        // do not have to remove as is password protected just for us
        if Pos('<ef:PasswordID>', atempList[i]) > 0 then
          atempList[i] := '<ef:PasswordID>*redacted*</ef:PasswordID>';
      end;
      atempList.SaveToFile(savelocation);
      atempList.Free

    end;
  end;
end;

(*
Procedure GetT3NonEligCapitalGains(RetNo:Integer);
Begin
   for i := 0 to (FList.Count - 1) do
   begin
     FRec := FList.Items[i];
     if FRec.FormName = 'T3MULT' then
     begin
       SFNo := FRec.FormNo;
       TotT3DispP1:=TotT3DispP1+Vl(FetchElmFno(RetNo,SFno,82));
       TotT3CapGP1:=TotT3CapGP1 +Vl(FetchElmFNo(RetNo,SFNo,298))-Vl(FetchElmFNo(RetNo,SFNo,334));
       TotT3CapGP2:=TotT3CapGP2+Vl(FetchElmFNo(RetNo,SFNo,304))-Vl(FetchElmFNo(RetNo,SFNo,340));
    end
end;
*)

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

Function ValidForT106Efile(RetNo: integer; FNo: integer): Boolean;
// 20170627 CON
var
  i: integer;
begin
  Result := True;
end;

//20251229 Igor >>>
function GetDcnSeqNoFor(RetNo: Integer; OnLineNo: string): string;
var
  YYYY, MM, DD, Hour, Min, Sec, Msec: Word;
  SMM, SDD, SMin, SSec, SMSec: string[2];
  Syyyy: string[4];
  sBirthday: string[2];
  SAppYear: string[2];
begin
   Delay(1); //To inceasethe second
   DecodeDate(Now, YYYY, MM, DD);
   DecodeTime(Now, Hour, Min, Sec, Msec);
   Syyyy:= AllTrim(IntToStr(YYYY));
   SMM:= LTrim(RTrim(IntToStr(MM)));
   sAppYear:= RightStr(AppYear, 2); //20150128
   SDD:= Ltrim(Rtrim(IntToStr(dd)));
   SMIN:= Ltrim(Rtrim(IntToStr(Min)));
   SSec:= AllTrim(IntToStr(Sec));
   SMSec:= LTrim(RTrim(IntToStr(MSec)));

   if (Length(SMM) = 1) then SMM:= '0' + SMM;
   if (Length(SDD) = 1) then SDD:= '0' + Sdd;
   if (Length(SMIN) = 1) then SMin:= '0' + SMin;
   if (Length(SSec) = 1) then SSec:= '0' + SSec;
   if (Length(SMSec) = 1) then SMSec:= '0' + SMSec;

   Result:= sAppYear + Sdd + SSec + RightStr(GetBirthdate(RetNo), 1) + RightStr(SMSec, 1);//2005
   //If length(result)<> 13 then result:='';
end;
//20251229 Igor <<<

Function GetEligibleDependantNetIncome(RetNo: integer): Real;
// into somelist
Var
  i, k, FNo: integer;
begin
  Result := 0;
  FormatSettings.DecimalSeparator := '.'; // 20150727
  FNo := GetFormNo('DEPEND');
  i := 5;
  k := 19;   //elig Y/N
  repeat
    If UpperCase(FetchElmFNo(RetNo, FNo, k))='Y' then
    Begin
      Result := vl(FetchElmFNo(RetNo, FNo, i+8));  //net income
      Exit;
    end;
    i := i + 15;
    k := k+15;  //20260307
    //inc(k);
  until i > 125;
end;

Function HaveEligibleDependant(RetNo: integer):Boolean;
// into somelist
Var
  i, k, FNo: integer;
begin
  Result := False;
  //FormatSettings.DecimalSeparator := '.'; // 20150727
  FNo := GetFormNo('DEPEND');
  i := 5;
  k := 19;   //elig Y/N
  repeat
    If UpperCase(FetchElmFNo(RetNo, FNo, k))='Y' then
    Begin
      Result := True;
      Exit;
    end;
    i := i + 15;
    k := k+15;  //20260307
  until i > 125;
end;
//20260311 Igor >>>
function PCPM(aVal, aPercent: Currency): Currency; //Perform the Correct Percentage Multiplication
var
  lReal: Currency;
begin
  Result:= RoundTo(aVal, -2);
  Result:= RoundTo(Result * aPercent, -2);
end;
//20260311 Igor <<<

Function IsDeemed183(RetNo:Integer):boolean; //20260313
Begin
 Result:=False;
 if FetchElm(RetNo,InfoFNo,253)>'' then result:=True;
End;

Function IsDeemedOther(RetNo:Integer):boolean; //20260313
Begin
 Result:=False;
 if FetchElm(RetNo,InfoFNo,254)>'' then result:=True;
End;

//jz//20260325 - adjusted for T1, taken from T3
Function ifAmendedPopulateInitialRevNum(RetNo:integer;amendedIndicatorVal,revisionIndicatorVal:string):string;
//var
  //spElms:TSpecialEfileStatusElms;
  //confirmationNum, amendedIndicatorVal, revisionIndicatorVal:string;
begin
  //spElms := getSpecialEfileStatusElms(RetNo,fName);
  //amendedIndicatorVal  := FetchElm(RetNo,FName,spElms.spAmendedIndicatorElm);
  //revisionIndicatorVal := FetchElm(RetNo,FName,spElms.spRevisionIndicatorElm);

  result := revisionIndicatorVal;

  if       amendedIndicatorVal = ''   then
    result := ''      //jz//20260315 - if not amended cannot have revision number
  else if (amendedIndicatorVal  > '') and
          (revisionIndicatorVal = '') then
    result := 'R1';   //do use R1 here for T1 //jz//20260315 - otherwise put initial value R0.. note: R1 maybe makes more sense but dont want to change what i've already done now
end;

//jz//20260402
procedure setTestingElementsVisibility(testPanal:TPanel);
begin
  if inJZtestmode or forCRATestMode then //or (GetEfilerNo='B0865')
  begin
    testPanal            .visible := true;
    //ProductionOrTestGroup.visible := true;
    //URLForWebServices    .visible := true;
    //btnShowXML           .visible := true;
  end
  else
    testPanal            .visible := false;

end;


//jz//20260406//CCAv2
procedure autosAssetsCCA(RetNo,FNo:integer;var CCAformData: TFormData);
const
  //jz//20260405 - add col vars
  Col1 =134;Col2 =191;Col3 =158;Col4 =44;Col5 =18;Col6 =24;Col7 =46;Col8 = 47;Col9 = 26;Col10= 49;Col11= 50;
  Col12= 12;Col13= 27;Col14= 52;Col15=53;Col16=15;Col17=14;Col18=30;Col19=167;Col20=170;Col21=173;Col22=176;
var
  Cls : string;
  AiipEligible,DiepEligible:boolean;
begin

  with CCAformData do
  begin
   //20230521
   //20230502
   Cls:=Ret[RetNo].Frm[FNo].Strings[134];  //class

   if Ret[RetNo].Frm[FNo].Strings[137]>'2018/11/20' then
   Begin
    Ret[RetNo].Frm[FNo].Strings[55]:='X';  //aiip
    AiipEligible:=True;
   End
   Else
   Begin
    Ret[RetNo].Frm[FNo].Strings[55]:='';
    AiipEligible:=False;
   End;

   //20230516
   If (Ret[RetNo].Frm[FNo].Strings[6]='') or (UpperCase(Ret[RetNo].Frm[FNo].Strings[6])='X')
   then
   //ok
   Else
    Ret[RetNo].Frm[FNo].Strings[6]:='';
   //if Ret[RetNo].Frm[FNo].strings[55]>'' then Ret[RetNo].Frm[FNo].Strings[34]:='X'; //if aiip then halh year blank/exempt
   if Ret[RetNo].Frm[FNo].Strings[41]>'' then DiepEligible:=True else DiepEligible:=False; //20230515

  //AUTOS CCA New format with 22  //21 columns now
   // If IsDiepEligible(Cls,Ret[RetNo].Frm[FNo].Strings[137])=false then begin DiepEligible:=False;Ret[RetNo].Frm[FNo].Strings[41]:='';end; //20230515

    if cls='12' then
    begin
      Ret[RetNo].Frm[FNo].Strings[55] := '';  //no Aiip  //?? 20230404
    end; // 20200703

    Strings[38]:=GetAiipFactor(Cls); //jz//20260406//CCAv2
    Strings[58]:=GetRiipFactor(Cls); //jz//20260406//CCAv2

    //20230515
    if Tv[33]=Tv[40] then Tv[33]:=0; //if cost = AiiFactor then zero it out (error in restructioring with new format of CCA
    //20230429
    Tv[152]:=Tv[143] * Tv[197]/100;
    Tv[155]:=Tv[143] * Tv[200]/100;
    Tv[56]:=MaxR(0,Tv[143]+Tv[152]+Tv[155]-Tv[39]); //jz//20260406//CCAv2

    Tv[col3]:=Tv[56];  //jz//20260406//CCAv2 158  //20230519

    //COLUMNS
    if diepEligible=true then //Ret[RetNo].Frm[FNo].Strings[43]>'' then //diep eligible //20230423
    begin
     if Tv[Col4]=0 then begin Tv[col4]:=Tv[Col3];Tv[44]:=Tv[Col4];end;
     if Tv[Col4]>Tv[col3] then begin Tv[Col4]:=Tv[Col3];Tv[44]:=Tv[Col3];End;
    end
    Else
     Tv[Col4]:=0;

    If Tv[Col5]=0 then Tv[Col6]:=0;  //User if no diep then no dispos of diep //20230516
    Tv[col7]:=Tv[col2]+Tv[Col3]-Tv[col5];
    Tv[col8]:=MaxR(0,Tv[col4]-Tv[col6]);
    If DiepEligible=false then Tv[col9]:=0; //useer?/ immediate expensing
    if Tv[Col9]>1500000 then Tv[col9]:=1500000;
    Tv[col10]:=Tv[col3]-Tv[col9]; //MaxR(0,Tv[col3]-Tv[col4]+Tv[col8]-Tv[col9]);
    Tv[col11]:=Tv[50]; //user
    Tv[col12]:=Tv[12];  //manual MaxR(0,Tv[col7]-Tv[col9]);
    Tv[col13]:=MaxR(0,Tv[col7]-Tv[col9]) ; //-Tv[col10]+Tv[col11]);   //??? //MaxR(0,Tv[col5]-Tv[col6]-Tv[col10]+Tv[col11]);   //???
    Tv[Col14]:=MaxR(0,Tv[col5]-TV[Col10]+Tv[Col11]+Tv[Col12]); //*AiipFactor); //MaxR(0,(Tv[col11]-Tv[col13])*AiipFactor);
    Tv[Col15]:=MaxR(0,(Tv[col11]-Tv[col14]))*Vl(Strings[38]); //factor)   //-Tv[col11]-Tv[col5])*(1/2)) //20230411
    Tv[Col16]:=MaxR(0,Tv[col12]-Tv[col14]); //Factor 2??
    Tv[Col17]:=MaxR(0,Tv[col12]-Tv[col16])* Vl(strings[58]); //jz//20260405 - form wrong, fix col16 not col14
    if Strings[34]='' then //not exempt half-year rule
     Tv[Col18]:=(Tv[Col10]-Tv[col11]-Tv[col12]-Tv[Col5])* (1/2);
    Tv[Col19]:=Tv[Col13]+Tv[col15]+Tv[Col17]-Tv[col18];     //jz//20260405 - form wrong, fix - +Tv[Col16]-Tv[col17];
    Strings[col20]:=GetCCARate(Cls); //20260405
    Tv[col21] := (tv[col19] * (vl(strings[col20])/100)) + tv[col9];   //jz//20260406//CCAv2 - no more override, strait to col21 instead of 177 first  //jz//20260405 - as per changed form
    Tv[col22]:= Tv[COL7]-TV[col21]; //jz//20260405 - change as per form //Tv[Col19]-TV[177];

  end;
end;


//jz//20260406//CCAv2
function GetAiipFactor(cls:string):string;
var AiipFactor:real;
begin
    // Aiipfactor //jz//20260406
    if      (cls = '43.1') or
            (cls = '54')   or
            (cls = '56')   then Aiipfactor := 1.5

    else if  cls = '55'    then Aiipfactor := 7/8

    else if (cls = '43.2') or
            (cls = '53')   then Aiipfactor := 1/2
    //does this need extra coding  /date checks? //proposed changes, for properties included in Class 44, 46, or 50
                                                 //acquired after April 15, 2024, and that became available for use in 2025
    else if cls = '44'     then Aiipfactor := 3     //

    else if cls = '46'     then Aiipfactor := 1/3

    else if cls = '50'     then Aiipfactor := 9/11

    else                           Aiipfactor := 0;

    result := floattostr(AiipFactor);

end;

//jz//20260406//CCAv2
function GetRiipFactor(cls:string):string;
var RiipFactor:real;
begin
    // Riipfactor //jz//20260406
    //Under proposed changes, for ZEVs acquired after 2024 and RIIPs that became available for use in 2025
    if       cls = '44'       then Riipfactor := 3

    else if (cls = '43.1') or
            (cls = '46')   or
            (cls = '54')   or
            (cls = '56')   then Riipfactor := 2 + (1/3)

    else if  cls = '55'    then Riipfactor := 1.5

    else if  cls = '53'    then Riipfactor := 1

    else if  cls = '50'    then Riipfactor := 9/11

    else if (cls = '12')   or
            (cls = '13')   or
            (cls = '14')   or
            (cls = '15')   or
            (cls = '59')   then Riipfactor := 0

    Else                        Riipfactor := 0.5;

    result := floattostr(RiipFactor); //jz//20260406//CCAv2
end;

Function GetTotalT776IncomeBeforeCCA(RetNo:Integer):Real;
Var  i, FNo: integer; FName:String;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if Frec.FormName = 'T776' then
    begin
      FNo := FRec.FormNo;
      Result:=Result+Vl(FetchElmFNo(RetNo, FNo, 100));
    end;
  end;
end;

//20260421
Function GetTotalT776CCAClaimed(RetNo:Integer):Real;
Var  i, FNo: integer; FName:String;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if Frec.FormName = 'ASSETSB' then
    begin
      FNo := FRec.FormNo;
      if Uppercase(LeftStr(FetchElmFNo(RetNo, FNo, 215),4))='T776' then
       Result:=Result+Vl(FetchElmFNo(RetNo, FNo, 218));
      if Uppercase(LeftStr(FetchElmFNo(RetNo, FNo, 221),4))='T776' then
       Result:=Result+Vl(FetchElmFNo(RetNo, FNo, 224));
      if Uppercase(LeftStr(FetchElmFNo(RetNo, FNo, 227),4))='T776' then
       Result:=Result+Vl(FetchElmFNo(RetNo, FNo, 230));
    end;

    if Frec.FormName = 'AUTOS' then
    begin
      FNo := FRec.FormNo;
      if Uppercase(LeftStr(FetchElmFNo(RetNo, FNo, 215),4))='T776' then
       Result:=Result+Vl(FetchElmFNo(RetNo, FNo, 218));
      if Uppercase(LeftStr(FetchElmFNo(RetNo, FNo, 221),4))='T776' then
       Result:=Result+Vl(FetchElmFNo(RetNo, FNo, 224));
      if Uppercase(LeftStr(FetchElmFNo(RetNo, FNo, 227),4))='T776' then
       Result:=Result+Vl(FetchElmFNo(RetNo, FNo, 230));
    end;
  end;

end;

//20260816
Function IsEnterpriseForm(Fname:string):Boolean; //20251114
Begin
 Result:=False;
 If (GetFormType(FName)='EL')  // special Election form
 or (IsEnterpriseVersion=True)  ///20260819 cz
 or (upperCase(Fname)='T1134')
 or (upperCase(Fname)='T106')
 or (upperCase(LeftStr(Fname,6))='T1134S')
 or (upperCase(LeftStr(Fname,5))='T106S')
 Or (upperCase(Fname)='S150')
 or (upperCase(Fname)='S151')
 or (Uppercase(Fname)='S76')
 or (Uppercase(LeftStr(Fname,4))='S78#')
 or (Uppercase(Fname)='T2184')
 or (Uppercase(Fname)='S130')
 or (upperCase(Fname)='SALDIV')
 or (upperCase(Fname)='SBDALLOC')

 then result:=True;
End;


end.
