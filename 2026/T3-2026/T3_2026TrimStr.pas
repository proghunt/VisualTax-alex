unit T3_2026TrimStr;
// updated to 2014-07-28
{$B-}

interface

uses SysUtils, FileCtrl, WinTypes, WinProcs, Messages, Classes, Graphics,
  Controls, System.Math, //20260309 Igor
  ShellAPi, Forms, StdCtrls, Dialogs, DBctrls, ExtCtrls, Printers, DB,
  T3_2026Declare, IniFiles, ClipBrd, Registry, ComCtrls, vtEditBox, vtLabel,
  vtShape,
  EkRtf, ekbasereport, ekfunc, vtMulti,
  uADCompClient, // 20150919 Igor
  System.IOUtils, //20220324 Igor
  rxRichEd; // 20160819 Igor (Must be last)

{ Const }
{ Space = #$20; }
//20260115 Igor >>>
type
  TGroupItemAccountType = (atIndividual, atCorporation, atTrust, atPartnership);
  T1134GroupItem = record
    AccountNumber: string;
    Name: string;
    AccountType: TGroupItemAccountType;
  end;
//20260115 Igor >>>

Function IsEnterpriseForm(Fname:string):Boolean; //20260816CZ

Function GetShortYearfactor(RetNo:Integer):real;  //20260321
Function IsDisabilityTrust(RetNo:Integer):boolean; //20250329

Procedure DeleteLastS15(RetNo:Integer); //20240319
Function CountS15(RetNo:Integer):Integer; //20240319
Function GetLastS15FNo(RetNo:Integer):Integer;  //20240319

Function specialReturnEfileStatus(RetNo:integer;fName:string):TspecialReturnEfileStatus;  //jz 20240405 add specialreturns efile button
Function getSpecialEfileStatusElms(RetNo:integer;fName:string):TSpecialEfileStatusElms;   //jz 20240406 add specialreturns r1

Function ifAmendedPopulateInitialRevNum(RetNo:integer;fName:string):string;

function GetTrustNumber(RetNo:Integer; ReturnType:string; IsProd:boolean): String;

Function isCanadianProvince(PRV: String): boolean;
function ValidBusNumberFull(RetNo: integer; BN: string): Boolean; //20240310
Function SiftTrust(RetNo:Integer):Boolean;
Function CalcThisProvince(RetNo:Integer;Prv:String): Boolean;
Function CalcThisMJProvince(RetNo:Integer;Prv:String): Boolean;
Function GetEfilerNo: String; //20231223

Function GetMjAllocBusinessIncomeProv(RetNo: Integer): String;

//20230312
Function IsMultiJurisdiction(RetNo:Integer): Boolean; //20231202
function MkDirforClientDocs(RetNo: Integer): string;
Function GetSignatureFilePath(RetNo:Integer):String;//20200320

Function GetAiipFActor(Cls:String):Real;  //20230226
Function MaskTheAccount(RetNo:Integer): Boolean; //20230209;
Function GetMaskedAccount(RetNo:Integer): String; //20230209;
Function GetMaskedRepId(RetNo:Integer): String;   //20230209;
Function GetMaskedString(RetNo,numToMask:integer;fullString:string): String; //20260312

Procedure GetT2030ACharts(RetNo: Integer;FarmFname:String;FarmFNo:Integer;
  Var Totexp:Real; Var TotMInv:Real;Var TotOInv:Real;Var TotGInc:Real;
  Var TotSal:Real);

Function ReformatSinWithSpaceInBetween(S: string): String;
function CalcCheckDigitForT3AOOCR(ALine: string): string; //20240329
//function CalcCheckDigitForT7DROCR(ALine: string): string; // 20180307 Igor
Function ReadyForT1135Efile(RetNo: Integer): Boolean; // 20220116
Function GetTestCaseId(RetNo: Integer;CaseID:string): Integer; //20211220 Igor

Function CreateEfileResponseHtm(RetNo: Integer; AckRec: TAckRec;  //20211201 Igor
  HtmFile: String): String;

//20211223 Igor >>>
Function IsEfOverride(RetNo: Integer; Lline: Integer): Boolean;
Function GetEfOverride(RetNo: Integer; Lline: Integer): String;
//20211223 Igor <<<

function ValidatePreparerInfo:boolean;  //for efile   //20180317
Function T3EfileEligible(RetNo:Integer):Boolean;

Procedure T5013IncProcess(RetNo: Integer; Var T5013LimitedInc: Real;
  Var T5013OthInc: Real; Var T5013ITC: Real; Var T5013ActDiv: Real;
  Var T5013ActDivEligible: Real; Var T5013CarrCharg: Real; Var T5013CDE: Real;
  Var T5013CEE: Real; Var T5013COGPE: Real; Var T5013FDE: Real;
  Var T5013RecapDepl: Real; Var T5013FedPol: Real; Var T5013ProvPol: Real;
  Var T5013Don: Real; Var T5013Gifts: Real; Var T5013Abil: Real;
  Var T5013FNonBusInc1: Real; Var T5013FNonBusInc2: Real;
  Var T5013FNonBusInc3: Real; Var T5013FNonBusTax1: Real;
  Var T5013FNonBusTax2: Real; Var T5013FNonBusTax3: Real;
  Var T5013FBusInc1: Real; Var T5013FBusInc2: Real; Var T5013FBusInc3: Real;
  Var T5013FBusTax1: Real; Var T5013FBusTax2: Real; Var T5013FBusTax3: Real;
  Var T5013Interest: Real; Var T5013Tax: Real; Var T5013ResAllow: Real;
  Var T5013FInterest: Real; Var T5013GrossIncome: Real;
  Var T5013BusIncome: Real; Var T5013FarmIncome: Real;
  Var T5013FishIncome: Real; Var T5013RentIncome: Real);

procedure ClearElmValues(ARetNo, AFormNo: integer;ElmList:TStringList);

Function CountNR4Slips(RetNo: Integer): Integer; //20170610
//20170122
Function IsQRE(RetNo: Integer): Boolean;
Function IsQDT(RetNo: Integer): Boolean;

Function GetStartTrustYear(RetNo: Integer): String; // 20160808
function LicenseLevel: eLicenseLevel;
function LicenseName: string;
Function IsEnterpriseVersion: Boolean; //20231211 Igor

Function OtherThanQREAndQdt(RetNo: Integer): Boolean; //20170113

Function FormatT3Account(RetNo: Integer; Acc: String): String;
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
Procedure GetListOfStatementsForAutos(RetNo: Integer; AList: TStrings);
Procedure ExtractCCA(RetNo: Integer; StmtId: String; StatementInst: String;
  Var TermLossAmount: Real; Var RecaptAmount: Real; Var CCAForStmt: Real);
Function PostCCAFromAssetsB(RetNo: Integer): Boolean;
Procedure PostNonVehicleCCA(RetNo: Integer; FName: String; Stmt: String;
  FInst: String; FNo: Integer; StartNdx, EndNdx, IncrBY, EndSectionNdx,
  RemainingNdx, TotalNdx: Integer);
Procedure PostNonBuildingAdditions(RetNo: Integer; FName: String; Stmt: String;
  FInst: String; FNo: Integer; StartNdx, EndNdx, IncrBY, EndSectionNdx,
  RemainingNdx, TotalNdx: Integer);
Procedure PostNonBuildingDispositions(RetNo: Integer; FName: String;
  Stmt: String; FInst: String; FNo: Integer;
  StartNdx, EndNdx, IncrBY, EndSectionNdx, RemainingNdx, TotalNdx: Integer);
Procedure PostBuildingDispositions(RetNo: Integer; FName: String; Stmt: String;
  FInst: String; FNo: Integer; StartNdx, EndNdx, IncrBY, EndSectionNdx,
  RemainingNdx, TotalNdx: Integer);
Procedure InitExtractedAutolist(RetNo: Integer);
Procedure InitExtractedCCAlist(RetNo: Integer);
Procedure RecalcBusStatements(RetNo: Integer); // StmList:TStringList);
Function CalcBusDays(RetNo: Integer; Stmt: String): Integer;
Function IsBuildingClass(CcaClass: String): Boolean;
Function YYYY_MM_DDToMMDDYYYY(InputDate: String): string;
// Function YYYY_mm_ddToMMDDYYYY(InputDate:String):string;
Procedure ExtractAutos(RetNo: Integer; StmtId: String; StatementInst: String;
  Var TermLossAmount: Real; Var RecaptAmount: Real; Var AutoCCAForStmt: Real);
Procedure PostBuildingAdditions(RetNo: Integer; FName: String; Stmt: String;
  FInst: String; FNo: Integer; StartNdx, EndNdx, IncrBY, EndSectionNdx,
  RemainingNdx, TotalNdx: Integer);
Procedure FillSelfAutoExpRec(RetNo: Integer; Stmt: String);
Procedure UpdateThisFormDataIndicator(RetNo: Integer; FName: String);
Function IsSharedStatement(RetNo: Integer; Stmt: String): Boolean;

Procedure SumSlips(RetNo: Integer; FName: string);
Procedure T3IncomeProcess(RetNo: Integer; Var T3OthInc: Real; Var T3Pens: Real;
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
  Var T3FCapGains: Real);

Procedure T5IncomeProcess(RetNo: Integer; Var T5Interest: Real;
  Var T5FInterest: Real; Var T5Pens: Real; Var T5Royalty: Real;
  Var T5NonElgblGains: Real; Var T5Dividends: Real;
  Var T5DividendsEligible: Real; Var T5FNonBusInc1: Real;
  Var T5FNonBusInc2: Real; Var T5FNonBusInc3: Real; Var T5FNonBusTax1: Real;
  Var T5FNonBusTax2: Real; Var T5FNonBusTax3: Real);

Procedure T4APIncomeProcess(RetNo: Integer; Var T4APOthInc: Real;Var T4APIncTax: Real);

Function GetTaxOnBase(Bracket, PrevBracket, PrevPercent,
  PrevBaseTax: Real): Real;
Function AdvanceYearEnd(ThisYearEnd: String): String;
Function GetFedTaxBfrITC(RetNo: Integer): Real;
Procedure CopyT5015ToS50(RetNo: Integer);
Function ValidBusNumber(RetNo: Integer; Bn: String): Boolean;
Function MiddleR(x, y, z: Real): Real;
Function GetTrustTxblBfrLosses(RetNo: Integer): Real;
Function CountT106Slips(RetNo: Integer): Integer;
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
{$IFDEF single}
Function EditDate(s: String; MnYear: String; MxYear: string): Boolean;
Function EditT3Date(s: String; MxYear: string): Boolean;
{$ELSE}
Function EditDate(s: String; MnYear, MxYear: Integer): Boolean;
Function EditT3Date(s: String; MxYear: Integer): Boolean;
{$ENDIF}
Function GetFldTapeFormNo(RetNo: Integer;
  RefFormName, RefFieldId: String): Integer;
Function GetEmptyInstance(RetNo: Integer; FormName: String): Integer;
Function ReformatSin(s: string): String;
Function IsTrLoaded: Boolean;
Function InitDataBase(Appdir: string; DataDir: string): Boolean;
procedure UpdateDbStructure(ADir: string = ''); // 20220324 Igor //20220325 Igor
// Function ExceedsMaxReturnsAllowed:Boolean; -> uFeatures
Procedure LinkToTR(SearchItem: String);
Procedure LoadTr(TrFolder: String);
Function GetTrHandle: HWND;
Function GetTrFolder: String;
Function GetAdminPswrd(UserName: string): String;

Procedure InitMostRecentFiles(HowMany: Integer);
Procedure UpdateMostRecentFiles(RetNo: Integer; Dir, FlName, Sin: String);
Function FindWord(ThisWord, Ln: String): Integer;
Procedure InitPredictiveFiles;
Function PrintLabels(DataDir, FileNm: String): Boolean;
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

Function IsT1273CashMethod(RetNo: Integer; FInst: String): Boolean;
Function CountT1273(RetNo: Integer): Integer;
procedure ImportGifiNotes(RetNo: Integer);
Function GetFNoOfFirstInstance(FName: String; FNo: Integer): Integer;
Function IsValidTrustNo(s: String): Boolean;
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
{$IFDEF single}
function FormHasInstanceIndicator(FName: String): Boolean;
Procedure GetKeyWAttributes(KeyW: String; Var FName: String; Var Elm: Integer;
  Var IsAmount: String);
Function IsDevelopmentMode: Boolean;
Function DeleteReturn(Dir, FlName: String): Boolean;
Procedure GetPrinterDriversNames(AList: TStrings);
Procedure RemovePGMPsw;
{$ELSE}
{$ENDIF}
Function GetKeyWListFromRichEdit(ARichEdit: TRichEdit;
  KeyWList: TStrings): Boolean;
Function GetFormHeight(FName: string): Integer;
function GetFormNumberFields(FNo: Integer): Integer;
function GetMaxFormNumber: Integer;
Function GetCopiesToPrint(FName: string; TemplForms: TStringList;
  TemplCopies: TStringList): String;
// Function GetPrintSequence(FName:string):String;
Function IncludeFormInPrint(RetNo: Integer; FNm: String): Boolean;

{$IFDEF single}
// Function GetAdminPassword(UserName: string):String;
Function YouKnowTheReturnPassword(UnencryptedPsw: String): Boolean;
Function GetFilePsw(DataDir: string; FlName: string): String;
{$ELSE}
Function GetReturnPsw(DataDir, FlName: string): String;
function CheckReturnPsw(DataDir, FlName: string): Integer;
function CheckReturnAndPsw(DataDir, FlName: string): Boolean;
{$ENDIF}
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
Function IsGrandFatheredTrust(RetNo: Integer): Boolean;
Function AllocatedTaxableGains(RetNo: Integer): Real;
Function AllocatedNonResTaxableGains(RetNo: Integer): Real;
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
Function PrintVerticalSeparator(FName: String; Elm: Integer): Boolean;
Function GetFastPrintIndicator: Boolean;
Function GetEmptyT3BoxNo(RetNo, FNo: integer; FromElm, ToElm, ByElm: Integer): Integer;
Function PrvTaxBfrT3PFT(RetNo: Integer): Real;
Function IsT3Form(RetNo: Integer; Frm: String): Boolean;
Function GetCapGainsConversionRate(RetNo: Integer; InclusionRate: Real): String;
Function UseIntervivosRate(RetNo: Integer): Boolean;
Procedure ClearFields(RetNo, FNo, Ndx1, Ndx2: Integer);
Function AllowPrinting(RetNo: Integer): Boolean;
Function GetTotalFootValue(RetNo: Integer; Txt: String; SlipType: String): Real;
Function GetT3SlipType(RetNo, FNo: Integer): String;
Function CountAllT3Slips(RetNo: Integer): Integer;
Function CountT2202Slips(RetNo: Integer): Integer;
Function CountResidentSlips(RetNo: Integer): Integer;
Function CountPreferredBeneficiaries(RetNo: Integer): Integer;
Function CountNonResidentBeneficiaries(RetNo: Integer): Integer;
Function GetTotalPreferredAllocation(RetNo: Integer): Real;
Function FetchADate: String;
Function GetPositionInList(s: String; AlistBox: TFileListBox): Integer;
Function MkClientLetterName(RetNo: Integer): String;
Function GetT3StartYear(RetNo: Integer): String;
Function GetT3EndYear(RetNo: Integer): String;
Function GetT3TrustName(RetNo: Integer): String;
Function GetFootValue(RetNo, FNo: Integer; Txt: String): Real;
Function FetchInclusionRate(RetNo: Integer): Real;
Function IsInterVivos(RetNo: Integer): Boolean;
Function IsTestamentary(RetNo: Integer): Boolean;
Function GetTrustNetIncome(RetNo: Integer): Real;
Function GetTrustTxbl(RetNo: Integer): Real;
Function GetClientLettersDir: String;
Function ShadePenniesOnly(FName: String; ElmNo: Integer): Boolean;
Function PenniesShouldBeShaded(FName: String; Elm: Integer): Boolean;
Function ShouldBeShaded(FName: String; Elm: Integer): Boolean;
Function SubstituteForm(RetNo: Integer; FrmNm: String): String;
Procedure CopySubstitute(RetNo: Integer; FromFrm, ToFrm: String);
function GetFormAbrevName(FormNo: Integer): String;
// procedure ExecuteForm(AFormClass: TFormClass); //20160612 Igor (duplicate vtCommon)
{ Function ValidateKey(ThisKey:String):Boolean; }
Function GetPrevYearEnd(ThisYearEnd: String; No: Integer): String;
Function GetHowToFormat(FrmName: String; Elm: Integer): Integer;
// Function GetHowToFormat(FName:String;Elm:Integer):Integer;
// Function FormatAmount(s: string;How:Integer): string;
Function FormatAmount(FrmNm: String; s: string; How: Integer): string;
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
Function IsT3Return(RetNo: Integer): Boolean;

//Procedure CopySlipToDestForm(RetNo: Integer; FromForm: string; DestFNo: Integer; //20170610
Procedure CopyT3SlipToDestForm(RetNo: Integer; FromForm: string; DestFNo: Integer;
  TopOrBottom: Integer; DestFormName: String);
Procedure CopyNR4SlipToDestForm(RetNo: Integer; FromForm: string;
  DestFNo: Integer; TopOrBottom: Integer; DestFormName: String);
Function RemoveCommas(s: string): String;
Function ValidAccount(Account: string): Boolean;
Function GetTrustYear(RetNo: Integer): String;
Function GetPrvYear(ThisYear: String; No: Integer): String;
Procedure SumT3Boxes(RetNo: Integer);
Function ReformatAccount(s: string; PrefixLtr: string): String;
Function GetPrvForTaxCredit(RetNo: Integer): Real;
Function GetBasicFedTax(RetNo: Integer): Real;
Function SubjectToMinTax(RetNo: Integer): Boolean;
Function GetTotProvTax(RetNo: Integer): Real;

Function CalcFedPolitCredit(TotalContrib: Real): Real;
Function CalcPolitCredit(Province: String; TotalContrib: Real): Real;
Function GetFormFee(FormName: String; Qty: Integer): Real;
Function GetTotalFee(RetNo: Integer): Real;
Procedure GetListInvoiceForms(RetNo: Integer; Frms, HowMany: TStrings);
Function CountPagesGenerated(RetNo: Integer): Integer;
// Function DDMMYYYYToMMDDYYYY(DDMMYYYY:String):string;
Procedure FillHeader(RetNo, FormNo, NameElm, AccountElm, YearEndElm: Integer);
Procedure FillPHeader(RetNo, FormNo, NameElm, AccountElm, YearEndElm: Integer);
// partnership
Function MyStrToFloat(Astring: String): Real;
Function CorpIsMutualFund(RetNo: Integer): Boolean;
Procedure SetNumDays(RetNo: Integer);
Function GetSmlBizDeduction(RetNo: Integer): Real;
Function GetBizLimit(RetNo: Integer): Real;
Procedure SetTrustType(RetNo: Integer);
Function GetRetName(RetNo: Integer): String;
Function GetT3AccountNumber(RetNo: Integer): String;
Function GetAccountNumber(RetNo: Integer): String;
Function GetYearEnd(RetNo: Integer): String;
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

Function ClcR(FieldId: Integer; PgmValue: Real; FormOvrSw: Boolean;
  RetNo: Integer; FormNo: Integer): Real;
// Function EditDate(S:String;MxYear:string):Boolean;
// Function CalcAge(BirthDate: string): Integer;
Function CalcAgeTo(BirthDate: string; ToDate: string): Integer;

Procedure CalcCCA(Cls: string; UccStart: Real; Additions: Real; Proceeds: Real;
  Var Adjustments: Real; Var BaseForCCA: Real; Rate: string; Var CCA: Real;
  Var UccEnd: Real; OvrCCA: string; OvrUCC: string; ClaimIt: Boolean);
Function GetCCARate(Cls: string): String;
Procedure InitCCARates;

function IsShowFlagIndicator(FName: String; DorP: String): Boolean;
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
 //20230324 Igor >>>
function GetFormName(FormNo: Integer): String; overload;
function GetFormName(ARetNo: Integer; FormNo: Integer): String; overload;
 //20230324 Igor <<<
function GetFName(AbrevName: String): String;
function GetFormNo(const FormName: String; Check: Boolean = True;
  ARetNo: Integer = 0): Integer; // 20160704 Igor
Procedure UpdateAllDataIndicators(RetNo: Integer);
Procedure InfoOn; { just repaint mdi status panel }
Procedure InfoOff;
Function GetRowFromSlip(RetNo: Integer; FormName: string; Row: Integer;
  ExchRow: Integer; ShareRow: Integer): Real;
Function CalcDaysInCan(RetNo: Integer): Integer;
Function GetNumbFields(FName: string): Integer;
Function RemovePenniesDot(s: string): String;
Function MakeEFFileName(LicenseLevel: string): string;

Function EditLongPrv(Value: string): Boolean;
{ File i/o }
Function FileNameValid(FlName: string): Boolean;
Function CopyReturn(DataDir: String; FileName: String;
  DestinationDir: string): Boolean;
//Function GetUserProfile(UserName: string): Boolean; //20170112 Igor (Move to TUserProfile)
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

function QuickFormFind(RetNo: integer; AFormName: String): Boolean; //20170418 Igor

//20210906 Igor >>>
Function GetEfStatusDescr(EFStatusCode: String): String;
Procedure GetEOLParms(Var OnLineNo: String; Var Password: String; Var url: String; Var NetFileDir: String);
Procedure SaveEOLParms(OnLineNo, Password, url, NetFileDir: String);
Function GetDefaultNetFileDir: String;
Function MkJsonFileName(RetNo: Integer; NetFileDir: String): String;
//20210906 Igor <<<

(* //20240118 Igor delete this
Function MkT3MJsonFileName(RetNo: Integer; NetFileDir: String): String;
Function MkT3RCAJsonFileName(RetNo: Integer; NetFileDir: String): String; //20231201 Igor
Function MkT3ATHJsonFileName(RetNo: Integer; NetFileDir: String): String; //20231211 Igor
*)

Function GetEOLAgentNo: String; //20220117 Igor
//20220120 Igor >>>
Function GetDcnSeqNoEOL(RetNo: Integer; OnLineNo: String): String;
Function IsReadyForEfile(RetNo:Integer):Boolean;
Function ValidateDcn(RetNo: Integer): Boolean;
//20220120 Igor <<<
//20220512 Igor >>>
function DownLoadFromWeb(url, remoteFlName, localDir, localFlName: string): boolean;
function IsAuthorizedPreparer: Boolean;
//20220512 Igor <<<

  //20260115 Igor >>>
  function GetT1134ForeignAffiliatesIdentificationNumber(ARetNo: Integer; AName: string): string;
  procedure PopulateT1134ForeignAffiliates(ARetNo: Integer; AList: TStringList);
  function GetT1134GroupList(ARetNo: integer): TArray<T1134GroupItem>;
  procedure PopulateT1134GroupList(ARetNo: integer; AList: TStringList; AShowName: Boolean = true);
  procedure PopulateT1134SGroupList(ARetNo, AFormNo: integer; AList: TStringList; AOnlyArrayNo: integer = 0);
  //20260115 Igor <<<
  function PCPM(aVal, aPercent: Currency): Currency; //Perform the Correct Percentage Multiplication //20260309 Igor
  procedure saveXMLWithNoCRAPasswordID(savelocation: string; AList: TStringList; SaveTheXML: Boolean);
  //20260817 Alex >>>
  function GetDcnSeqNoFor(RetNo: Integer; OnLineNo: string): string;
  function GetWACNumber(RetNo: integer): string;
  function ValidForT106Efile(RetNo: Integer; FNo: Integer): Boolean;
  function TotMultipleExludingDeletedSlips(RetNo: integer; NonInstFormName: string; Elm: integer; dElm: integer; deleteString: string): Real;
  //20260817 Alex <<<

implementation

uses
  HtmlHelp,
  vtCommon, vtDialogs, vtDynData,
  T3_2026,
  // T3_2026PopList,
  T3_2026Calc,
  T3_2026Common, T3_2026Common2, T3_2026Main, T3_2026ChildWinNew,
  T3_2026ReturnPassword, T3_2026CalcBus,
  vtTrimStr, vtShared, vtDataBase, // 20150919 Igor
  fConvertToMultiApp; // 20160623

const
  c_DefDataDir = '{DataDir}'; //20171204 Igor
  //20170112 Igor >>>
  OptionsArray: Array [0 .. 87, 0 .. 3] of string =  //20161107 Igor  //20230101
  // Options Name        Default Value                 Caption    Fill Default
    (('Dir_Cur', c_DefDataDir + '\Data', 'Current Directory', 'X'), { 0 }//20171204 Igor
    ('BackUpFrequency', '7', 'Remind me to backup data every X deys', 'X'),
    ('BackupDir', c_DefDataDir + '\BackUp', 'Default Backup directory', 'X'),//20171204 Igor
    ('LastBackupDir', '', 'Most recent back up folder', 'X'),
    ('Dir_Deflt', c_DefDataDir + '\Data', 'Default Directory', 'X'),//20171204 Igor
    ('Dir_LastYr', '', 'DATA DIRECTORY used last year', 'X'),
    ('Dir_PgmLastYr', '', 'Program DIRECTORY last year', 'X'),
    ('Dir_DBFData', '', 'Data directory of the T3-2017 production data prior to Multi-App. Typically enter  C:\T3-2017\data. To be used as the source to import data into the Multi-App version', 'X'),
    ('Prp_Name', '', 'Preparer Identification: Company Name', ''),
    ('Prp_ContactName', '', 'Preparer Identification: Contact Name', ''),
    ('Prp_TransmitterNo', '', 'Preparer Identification: Transmitter Number', ''), { 10 }
    ('Prp_TransmitterAccountRepId', '', 'Preparer Identification: Transmitter Account Rep ID', ''),
    //('Prp_TransmitterType', '', 'Preparer Identification: Transmitter type', ''), //jz//20240324
    ('Prn_LMargin', '0.75', 'Client Letters Printing: Left margin in inches', 'X'), // 20160721 Igor
    ('Prn_RMargin', '0.5', 'Client Letters Printing: Right margin in inches', 'X'), // 20160721 Igor
    ('Prn_FontIncr', '1', 'Printing Font Size Increment: Increment by (0 or 1)', 'X'),
    ('Prp_EMail', '', 'Preparer Identification: Email Address', ''),
    ('Prp_BusNo', '', 'Preparer Identification: Business No', ''),
    ('Prp_RepresentativeId', '', 'Preparer Identification: Representative Id', ''), //20230101
    ('Reviewer_EMail', '', 'Reviewer Identification: EMail', ''),
    ('Reviewer_Name', '', 'Reviewer Identification: Name', ''),
    ('Reviewer_Area', '', 'Reviewer Identification: Tel. Area', ''),
    ('Reviewer_Tel', '', 'Reviewer Identification: Tel. Number', ''), { 20 }
    ('Prp_Street', '', 'Preparer Identification: Street', ''),
    ('Prp_City', '', 'Preparer Identification: City', ''),
    ('Prp_Prov', '', 'Preparer Identification: Province', ''),
    ('Prp_Postal', '', 'Preparer Identification: Postal', ''),
    ('Prp_Countr', '', 'Preparer Identification: Country', ''),
    ('Prp_Area', '', 'Preparer Identification: Tel. Area', ''),
    ('Prp_Tel', '', 'Preparer Identification: Tel. Number', ''),
    ('Prp_FxArea', '', 'Preparer Identification: Fax Area', ''),
    ('Prp_Fax', '', 'Preparer Identification: Fax Number', ''),
    ('Prp_GSTNo', '', 'GST No', ''), { 30 }
    ('Prp_Bill', '2', 'Default Billing Option', 'X'),
    ('Prp_VSFee', '30', 'Flat Fees ($): Very small', 'X'),
    ('Prp_SFee', '50', 'Flat Fees ($): Small', 'X'),
    ('Prp_AFee', '70', 'Flat Fees ($): Average', 'X'),
    ('Prp_CFee', '100', 'Flat Fees ($): Complex', 'X'),
    ('Prp_VCFee', '150', 'Flat Fees ($): Very Complex', 'X'),
    ('Prp_Hour', '60', 'Charge per hour ($)', 'X'),
    ('Prp_Dates', '', 'Signature date: If checked, the program will automatically fill Signature dates with today''s date', ''),
    ('Nfl_Prov', 'ON', 'Default values for tax returns: DEFAULT PROVINCE', 'X'),
    ('Nfl_City', 'TORONTO', 'Default values for tax returns: DEFAULT CITY', 'X'), { 40 }
    ('Capitalization', 'UpperCase', 'NAME/ADDRESS CAPITALIZATION: Convert to', 'X'),
    ('Prn_NameH', 'X', 'Print headers on tax forms: Client Name on Headings', 'X'),
    ('Prn_SinH', 'X', 'Print headers on tax forms: B/N on Headings', 'X'),
    ('Prn_DateH', 'X', 'Print headers on tax forms: Date on Headings', 'X'),
    ('Prn_Disclm', '', 'Disclaimer above signature on Page 4 (Leave it blank, if not required)', ''),
    ('Opr_Close', 'X', 'Navigation and warnings Esc key', 'X'),
    ('Opr_GstHst', '', 'GST/HST rate', ''),
    ('UseFastPrint', '', 'Use Fast Print method', 'X'),
    ('UseProperName', 'X', 'Client Letters: Show proper format (Capitalize only first letter)  in Name and Address', 'X'),
    ('NoTypeAhead', '', 'DO NOT Use the Predictive Typing feature (Super Entry)', 'X'), { 50 }
    ('ShowInvoiceWarning', 'X', 'Invoice: Show warning  if invoice not prepared', 'X'),
    ('UpdateFrequency', '7', 'Internet Updates: Check automatically every X deys', 'X'),
    ('InvFoot1', '', 'Invoice footer (Free format text to appear at bottom of Invoice) 1', ''),
    ('InvFoot2', '', 'Invoice footer (Free format text to appear at bottom of Invoice) 2', ''),
    ('InvFoot3', '', 'Invoice footer (Free format text to appear at bottom of Invoice) 3', ''),
    ('InvFoot4', '', 'Invoice footer (Free format text to appear at bottom of Invoice) 4', ''),
    ('InvFoot5', '', 'Invoice footer (Free format text to appear at bottom of Invoice) 5', ''),
    ('ActiveBoxColor', '8421631', 'Active box color', 'X'),
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
    ('FirstReturnColor', '16777155', 'FirstReturnColor', 'X'), { TODO : check }
    ('UseFormSearch', 'X', 'UseFormSearch', 'X'), { 70 } { TODO : check }
    ('OtherSlipsButtons', 'X', 'OtherSlipsButtons', 'X'),  { TODO : check }
    ('T1013AuthorLevel', '2', 'T1013AuthorLevel', 'X'), { TODO : check }
    ('CVSetting', '2', 'CVSetting', 'X'), { TODO : check }
    ('ShowFinWarning', '', 'ShowFinWarning', 'X'), { TODO : check }
    ('ShowConsultantOnInv', '', 'ShowConsultantOnInv', 'X'), { TODO : check }
    ('UseCondominiumLine', 'X', 'UseCondominiumLine', 'X'),  { TODO : check }
    ('RolloverT4T5', 'X', 'RolloverT4T5', 'X'),  { TODO : check }
    ('ShowInvoiceEfCharge', 'X', 'ShowInvoiceEfCharge', 'X'), { TODO : check }
    ('ShowSaluteWarning', 'X', 'ShowSaluteWarning', 'X'), { TODO : check }
    ('Nfl_Efile', 'X', 'Nfl_Efile', 'X'), { 80 }   { TODO : check }
    ('Ef_Method', 'EOL', 'Ef_Method', 'X'),    { TODO : check }
    ('Prp_Elect', 'X', 'Prp_Elect', 'X'), { TODO : check }
    ('Prp_EfRepr', 'X', 'Prp_EfRepr', 'X'), { TODO : check }
    ('Nfl_Disced', '1', 'Nfl_Disced', 'X'), { TODO : check }
    ('AutoSeniorDiscount', '', 'AutoSeniorDiscount', 'X'), { TODO : check }
    ('DiscountForSeniors', '0', 'DiscountForSeniors', 'X') { 86 } { TODO : check }

    );

Function DownLoadFromWeb(url, remoteFlName, localDir, localFlName: string) //20220512 Igor
  : Boolean;
var fileUrl, FileName: string;
begin
  Result := true;
  fileURL := url + remoteFlName;
  FileName := localDir + localFlName;
  if not(SameText(Copy(fileURL, 1, 7), 'http://') or
      SameText(Copy(fileURL, 1, 8), 'https://')) then
      fileURL := 'https://' + fileURL;
  GetFileWithNoCache(fileUrl, FileName);
end;

function IsAuthorizedPreparer: Boolean;  //20220512 Igor
var
  i: integer;
  url, LocalDir, RemoteFlName, LocalFlName, ExpKeysFlName,LicenseKey,TempStr,s: string;
  tempList: TStringList;
  EfilerNo:String;  //20190311 CON
  PreparerStreet:string; //20190417
begin
  Result := True;
  if not IsInternetConnectionActive then Exit;
  Screen.Cursor := crHourGlass;
  try
    url := 'https://www.visualtax.com/downloads/';  //20220411 Igor
    LocalDir := appdir + '\'; //where the dowloaded files are saved
    RemoteFlName  := 'ExpKeysT3.txt';
    ExpKeysFlName := 'ExpKeysT3.txt'; //expired tr keys
    try
      TempList := TStringList.Create;
      try
        if DownLoadFromWeb(url, remoteFlName, localDir, ExpKeysFlName) then
        begin
          LicenseKey := AppT3_2026.GetLicenseKey;
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
    except // do not show errors
    end
  finally
    Screen.Cursor := crDefault;
  end;
end;

Function IsEfOverride(RetNo: Integer; Lline: Integer): Boolean; //20211223 Igor
Var
  i: Integer;
begin
  Result := false;
  If Lline < 1 then
    exit;
  i := 23;
  repeat
    If Lline = VL(FetchElm(RetNo, 'EFMEMO', i)) then
    begin
      Result := True;
      exit;
    end;
    inc(i, 2);
  until i > 33;
end;

Function GetEfOverride(RetNo: Integer; Lline: Integer): String; //20211223 Igor
Var
  i: Integer;
begin
  Result := '';
  i := 23;
  repeat
    If Lline = VL(FetchElm(RetNo, 'EFMEMO', i)) then
    begin
      Result := FetchElm(RetNo, 'EFMEMO', i + 1);
      exit;
    end;
    inc(i, 2);
  until i > 33;
end;


Function CreateEfileResponseHtm(RetNo: Integer; AckRec: TAckRec;  //20211201 Igor
  HtmFile: String): String;
var
  htmlSource: TStringList;
  source, FlName: string;
  KeyWord, S: string;
  OnLineNo, Password, url, NetFileDir: String;
  i, j, k, StartPos, itemNumTemp: Integer;
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


    KeyWord := '!TaxYear!';
    S := AppYear;
    StartPos := Pos(KeyWord, htmlSource[i]);
    if StartPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], KeyWord, S,
        [rfReplaceAll, rfIgnoreCase]);


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

    KeyWord := '!HyperLinkText!';
    S := AckRec.HyperLinkText;
    StartPos := Pos(KeyWord, htmlSource[i]);
    if StartPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], KeyWord, S,
        [rfReplaceAll, rfIgnoreCase]);

    KeyWord := '!HyperLinkLink!';
    S := AckRec.HyperLinkLink;
    StartPos := Pos(KeyWord, htmlSource[i]);
    if StartPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], KeyWord, S,
        [rfReplaceAll, rfIgnoreCase]);

    // 20180118 //20181802 ??  wrong
    for k := 1 to 6 do
    begin
      // tax return error codes
      KeyWord := '!ErrorCode[' + IntTostr(k) + ']!';
      S := AckRec.ErrorCode[k];
      StartPos := Pos(KeyWord, htmlSource[i]);
      if StartPos > 0 then
        htmlSource[i] := StringReplace(htmlSource[i], KeyWord, S,
          [rfReplaceAll, rfIgnoreCase]);

      // tax return descriptions
      for j := 1 to 12 do
      begin
        KeyWord := '!Description[' + IntTostr(k) + '][' + IntTostr(j) + ']!';
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
    GetFirstName(RetNo) + '-EfileAck', '.') + AckRec.TransmissionName + '.htm'; //20240129 Igor
  // 20140126

  htmlSource.SaveToFile(FlName);
  htmlSource.Free;

  Result := FlName; // 20170123 //return the created file location
end;

//20170112 Igor <<<
Function MyStrToFloat(Astring: String): Real;
begin
  If Astring = '' then
    result := 0
  else
    result := StrToFloat(Astring);
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
  end;
end;

//MJjz2024
Function GetTotProvTax(RetNo: Integer): Real;
  type
    TprovElmRec = record
      prov, pFname  : string;
      pElm          : integer;
      pMJFname      : string;
      pMJElm        : integer;
    end;
  const
    //20250325 T3pe fixed to 44
    pArray: array[0..12] of TprovElmRec =
      (
        (prov:'ON'; pFname: 'T3ON'; pElm: 56; pMJFname: 'T3MJON'; pMJElm: 56),
        (prov:'AB'; pFname: 'T3AB'; pElm: 56; pMJFname: 'T3MJAB'; pMJElm: 56),
        (prov:'BC'; pFname: 'T3BC'; pElm: 64; pMJFname: 'T3MJBC'; pMJElm: 64),
        (prov:'MB'; pFname: 'T3MB'; pElm: 53; pMJFname: 'T3MJMB'; pMJElm: 53),
        (prov:'NB'; pFname: 'T3NB'; pElm: 46; pMJFname: 'T3MJNB'; pMJElm: 46),
        (prov:'NS'; pFname: 'T3NS'; pElm: 49; pMJFname: 'T3MJNS'; pMJElm: 49),
        (prov:'NL'; pFname: 'T3NL'; pElm: 56; pMJFname: 'T3MJNL'; pMJElm: 56),
        (prov:'NT'; pFname: 'T3NT'; pElm: 46; pMJFname: 'T3MJNT'; pMJElm: 46),
        (prov:'NU'; pFname: 'T3NU'; pElm: 46; pMJFname: 'T3MJNU'; pMJElm: 46),
        (prov:'PE'; pFname: 'T3PE'; pElm: 44; pMJFname: 'T3MJPE'; pMJElm: 44),
        (prov:'SK'; pFname: 'T3SK'; pElm: 56; pMJFname: 'T3MJSK'; pMJElm: 56),
        (prov:'YT'; pFname: 'T3YT'; pElm: 46; pMJFname: 'T3MJYT'; pMJElm: 46),
        (prov:'QC'; pFname: '';     pElm: 00; pMJFname: '';       pMJElm: 00)  //jz 20240308
      );

      Var
        i:integer;
begin
  result := 0;
  //20260118
  for i := 0 to high(pArray) do
  begin
        if IsMultiJurisdiction(RetNo) then
            result := Vl(FetchElm(RetNo, 'T3MJ', 117)) //result := Vl(FetchElm(RetNo, pArray[i].pMJFname, pArray[i].pMJElm))
          else
          Begin
            If HomeProv = pArray[i].prov then
            result := Vl(FetchElm(RetNo, pArray[i].pFname, pArray[i].pElm))
          End;
        {//2026018
        If Ret[RetNo].Province = pArray[i].prov then
        begin
          if IsMultiJurisdiction(RetNo) then
            result := Vl(FetchElm(RetNo, 'T3MJ', 117)) //result := Vl(FetchElm(RetNo, pArray[i].pMJFname, pArray[i].pMJElm))
          else
            result := Vl(FetchElm(RetNo, pArray[i].pFname, pArray[i].pElm))
        end;
        }
  end;
  {
  //20260118
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
  }
end;


Function SubjectToMinTax(RetNo: Integer): Boolean;
begin
  result := False;
  If Vl(FetchElm(RetNo, 'S12', 124)) > 0 then result := True;
  If (Ret[RetNo].TrustType = ivMutualFund) then
    result := False;
 // If CertificationMode then result := True;   //20250324

end;

Function GetBasicFedTax(RetNo: Integer): Real;
begin
  result := Vl(FetchElm(RetNo, 'S11', 30));
  If SubjectToMinTax(RetNo) then
    result := Vl(FetchElm(RetNo, 'S12', 227));
end;

Function CorpIsMutualFund(RetNo: Integer): Boolean;
begin
  result := False;
end;


Procedure SetNumDays(RetNo: Integer);
var
  n: Integer;
begin
  n := DateDiff(DMYtoDate(FetchElm(RetNo, 'T3', 8)),
    DMYtoDate(FetchElm(RetNo, 'T3', 11)));
  if n <= 0 then
    n := 365
  else if n > 365 then
    n := 365; // better than above?
  Ret[RetNo].DaysInYear := n;
end;

Function GetSmlBizDeduction(RetNo: Integer): Real;
begin
  { ? }
  result := 0;
end;

Function GetBizLimit(RetNo: Integer): Real;
begin
  { ? }
  result := 0;
end;

Procedure SetTrustType(RetNo: Integer);
Var
  TC: Integer;
begin
  // 20160205
  TC := MyStrToInt(FetchElm(RetNo, 'T3', 81)); // trustcode
  If TC = 1 then
    Ret[RetNo].TrustType := TestamSpousal
 Else If ((TC = 900) or (TC = 901) or (TC = 903) or (TC = 904))
  // 20160807  Code to be changed
  then
    Ret[RetNo].TrustType := TestamOther
  Else If TC = 11 then
    Ret[RetNo].TrustType := IvSpousal
  Else If TC = 12 then
    Ret[RetNo].TrustType := IvUnit
  Else If TC = 13 then
    Ret[RetNo].TrustType := ivMutualFund
  Else If TC = 14 Then
    Ret[RetNo].TrustType := IvCommunal
  Else If TC = 15 then
    Ret[RetNo].TrustType := IvEBP
  Else If TC = 161 then
    Ret[RetNo].TrustType := IvInsSegrReg
  Else If TC = 22 then
    Ret[RetNo].TrustType := IvJointPartner
  Else If TC = 23 then
    Ret[RetNo].TrustType := IvAlterEgo
  Else If TC = 163 then
    Ret[RetNo].TrustType := IvInsSegrNonReg
  Else If (TC = 180) or (TC = 181) then
    Ret[RetNo].TrustType := IvNonProfit
  Else If TC = 19 then
    Ret[RetNo].TrustType := IvEmplTrust
  Else If TC = 21 then
    Ret[RetNo].TrustType := IvPersTrust
  Else
    Ret[RetNo].TrustType := IvOther

    (* //20160205
      If FetchElm(RetNo,'T3',23) >'' then
      Ret[RetNo].TrustType := TestamSpousal;
      If FetchElm(RetNo,'T3',24) >'' then
      Ret[RetNo].TrustType := TestamOther;
      If FetchElm(RetNo,'T3',31) >'' then
      Ret[RetNo].TrustType := IvSpousal;
      If FetchElm(RetNo,'T3',33) >'' then
      Ret[RetNo].TrustType := IvUnit;
      If FetchElm(RetNo,'T3',36) >'' then
      Ret[RetNo].TrustType := IvMutualFund;
      If FetchElm(RetNo,'T3',39) >'' then
      Ret[RetNo].TrustType := IvCommunal;
      If FetchElm(RetNo,'T3',42) >'' then
      Ret[RetNo].TrustType := IvEBP;
      If FetchElm(RetNo,'T3',46) >'' then
      Ret[RetNo].TrustType := IvInsSegrReg;
      If FetchElm(RetNo,'T3',53) >'' then
      Ret[RetNo].TrustType := IvJointPartner;
      If FetchElm(RetNo,'T3',55) >'' then
      Ret[RetNo].TrustType := IvAlterEgo;

      If FetchElm(RetNo,'T3',50) >'' then
      Ret[RetNo].TrustType := IvInsSegrNonReg;
      If FetchElm(RetNo,'T3',32) >'' then
      Ret[RetNo].TrustType := IvNonProfit;

      If FetchElm(RetNo,'T3',37) >'' then
      Ret[RetNo].TrustType := IvEmplTrust;
      If FetchElm(RetNo,'T3',60) >'' then
      Ret[RetNo].TrustType := IvPersTrust;
      If FetchElm(RetNo,'T3',38) >'' then
      Ret[RetNo].TrustType := IvOther;
    *)
end;

Function IsGrandFatheredTrust(RetNo: Integer): Boolean;
begin
  // 20160307
  result := False;
  If UpperCase(FetchElm(RetNo, 'T3', 84)) > '' then
    result := True;
  // If FetchElm(RetNo,'T3',51) >= '1971-06-18' then result:=True;

  (*
    Result:=False; If FetchElm(RetNo,'T3',51)='' then exit;  //20160307
    If FetchElm(RetNo,'T3',51) < '1971-06-18' then
    result:=True
    else
    result:=False;
  *)
end;

Function GetRetName(RetNo: Integer): String;
Var
  s: string;
Begin
  result := '(Un-named)';
  s := FetchElm(RetNo, 'T3', 1);
  If s > '' then
  begin
    result := Rtrim(s);
    exit;
  end;


  s := FetchElm(RetNo, 'T1044', 5);
  If s > '' then
  begin
    result := Rtrim(s);
    exit;
  end;

  s := FetchElm(RetNo, 'T3RG_1', 1);
  If s > '' then
  begin
    result := Rtrim(s);
    exit;
  end;

  s := FetchElm(RetNo, 'T3P_1', 1);
  If s > '' then
  begin
    result := Rtrim(s);
    exit;
  end;

  s := FetchElm(RetNo, 'T3RI_1', 1);
  If s > '' then
  begin
    result := Rtrim(s);
    exit;
  end;

end;

Function GetT3AccountNumber(RetNo: Integer): String;
begin
  result := '';
  result := FetchElm(RetNo, 'T3', 2);
end;

Function GetAccountNumber(RetNo: Integer): String;
Var
  s: string;
begin
  result := '';
  s := FetchElm(RetNo, 'T3', 2);
  If s > '' then
  begin
    result := Rtrim(s);
    exit;
  end;


  s := FetchElm(RetNo, 'T3P_1', 2);
  If s > '' then
  begin
    result := Rtrim(s);
    exit;
  end;

  s := FetchElm(RetNo, 'T3RI_1', 2);
  If s > '' then
  begin
    result := Rtrim(s);
    exit;
  end;
end;

Function GetYearEnd(RetNo: Integer): String;
Var
  s: string;
  { Returns Taxation Year as Input in PAGE }
Begin
  result := '';
  s := FetchElm(RetNo, 'T3', 17);
  If s > '' then
  begin
    result := Rtrim(s);
    exit;
  end;


  s := FetchElm(RetNo, 'T1044', 2);
  If s > '' then
  begin
    result := Rtrim(s);
    exit;
  end;

  s := FetchElm(RetNo, 'T3RG_1', 6);
  If s > '' then
  begin
    result := Rtrim(s);
    exit;
  end;

  s := FetchElm(RetNo, 'T3P_1', 12);
  If s > '' then
  begin
    result := Rtrim(s);
    exit;
  end;

  s := FetchElm(RetNo, 'T3RI_1', 12);
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

Procedure InitCCARates;
Var
  TempList: TStringList;
  I: Integer;
begin
  TempList := TStringList.create;
  TempList.LoadFromFile(Appdir + '\' + 'CCARATES.D');
  For I := 0 to TempList.Count - 1 do
  begin
    CCaClasses[I + 1] := Rtrim(LeftStr(TempList[I], 4));
    CCaRates[I + 1] := MidStr(TempList[I], 6, 3);
  end;
  TempList.free;
end;

Function GetCCARate(Cls: string): String;
Var
  I: Integer;
begin
  result := '';
  For I := 1 to High(CCaClasses) do
    If Rtrim(Cls) = Ltrim(Rtrim(CCaClasses[I])) then
    begin
      result := Ltrim(Rtrim(CCaRates[I]));
      exit;
    end;
end;

Procedure CalcCCA(Cls: string; UccStart: Real; Additions: Real; Proceeds: Real;
  Var Adjustments: Real; Var BaseForCCA: Real; Rate: string; Var CCA: Real;
  Var UccEnd: Real; OvrCCA: string; OvrUCC: string; ClaimIt: Boolean);

Var
  AdjUcc: Real;
  OvrRate: Boolean;
begin

  AdjUcc := UccStart + Additions - Proceeds;
  Adjustments := MaxR(0, 0.5 * (Additions - Proceeds));
  BaseForCCA := AdjUcc - Adjustments;

  If AllTrim(Rate) <> GetCCARate(Cls) then
  begin
    If BaseForCCA < 0 then
      CCA := BaseForCCA
    else
      CCA := (BaseForCCA * Vl(Rate)) / 100;
  end
  else
  begin
    If UpperCase(OvrCCA) <> 'X' then
    begin
      If BaseForCCA < 0 then
        CCA := BaseForCCA
      else
        CCA := (BaseForCCA * Vl(Rate)) / 100;
    end;
  end;

  If UpperCase(Cls) = '10A' then
    CCA := BaseForCCA * (30 / 100) + Additions * (85 / 100);
  If UpperCase(Cls) = '12A' then
    CCA := BaseForCCA * (100 / 100) + Additions * (50 / 100);

  If ClaimIt = False then
    CCA := 0;

  If OvrUCC <> 'OVRUCC' then
    UccEnd := MaxR(0, AdjUcc - CCA);

  If UpperCase(OvrUCC) = 'X' then { terminal loss }
  begin
    If UccEnd > 0 then
    begin
      CCA := BaseForCCA;
      UccEnd := 0;
    end;
  end;
end;

function IsShowHdrIndicator(FName: String): Boolean;
begin
  result := FList.ByFormName(FName).ShowHdr;
End;

function IsShowFlagIndicator(FName: String; DorP: String): Boolean;
begin
  result := FList.ByFormName(FName).ShowFlag;
  If DorP = 'P' then // print
  begin
    If FName = 'T3AB' then
      result := True
    else If FName = 'T3BC' then
      result := True
    else If FName = 'T3MB' then
      result := True
    else If FName = 'T3NB' then
      result := True
    else If FName = 'T3NL' then
      result := True
    else If FName = 'T3NS' then
      result := True
    else If FName = 'T3NU' then
      result := True
    else If FName = 'T3NT' then
      result := True
    else If FName = 'T3ON' then
      result := True
    else If FName = 'T3PE' then
      result := True
    else If FName = 'T3SK' then
      result := True
    else If FName = 'T3YT' then
      result := True
  end;
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

function GetFormName(ARetNo: Integer; FormNo: Integer): String; //20230324 Igor
begin
  // 20160704 Igor >>>
  // Result := FList.GetFormName(FormNo);
  if (ARetNo > 0) and Ret[ARetNo].IsLastYearReturn then // 20160704 Igor
    result := FLastYearList.GetFormName(FormNo)
  else
    result := FList.GetFormName(FormNo);
  // 20160704 Igor <<<

end;

function GetFormName(FormNo: Integer): String; //20230324 Igor
begin
  Result := FList.GetFormName(FormNo);
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


//20170301
Function TotMultiple(RetNo: Integer; NonInstFormName: String; Elm: Integer)
  : Real; { No Instance }
var
  I, FNo: Integer;
begin
  result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    if UpperCase(FRec.FormName) = UpperCase(NonInstFormName) then
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
{$IFDEF single}
    FName := FRec.FormInstName;
   // if Fname='T3MJ' then showMessage('T3MJ');  //20231202

    s := FRec.DataIndic;
    UpdateFormDataIndicator(RetNo, FNo, s);
    { If Ret[RetNo].FrmHasdata[FNo] then Msg :=Msg+FName+Chr(13); }
{$ELSE}
    if FNo > 0 then
      UpdateFormDataIndicator(RetNo, FRec);
{$ENDIF}
  end;
  If CertificationMode then exit; // 20130203

  If FetchElm(RetNo, 'T3MJ', 110) > '' then //20231202
    Ret[RetNo].FrmHasData[GetFormNo('T3MJ')] := True
  Else
    Ret[RetNo].FrmHasData[GetFormNo('T3MJ')] := False;

  If Vl(FetchElm(RetNo, 'T3SUM', 15)) > 0 then
    Ret[RetNo].FrmHasData[GetFormNo('T3SUM')] := True
  Else
    Ret[RetNo].FrmHasData[GetFormNo('T3SUM')] := False;

  If CertificationMode then
    Ret[RetNo].FrmHasData[GetFormNo('S12')] := True;

  If SubjectToMinTax(RetNo) then
  begin
    Ret[RetNo].FrmHasData[GetFormNo('S12')] := True;
  end
  else
  begin
    Ret[RetNo].FrmHasData[GetFormNo('S12')] := True; //20240309 jz true seems wrong but test cases dont match json when is false
  end;

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

Function CalcDaysInCan(RetNo: Integer): Integer;
Var
  D1, D2: string;
begin
  With Ret[RetNo] do
  begin
    If (Frm[1].Strings[26] > '') and (Frm[1].Strings[27] > '') and
      (Frm[1].Strings[28] > '') and (Frm[1].Strings[29] > '') then
    begin
      D1 := Frm[1].Strings[26] + '/' + Frm[1].Strings[25] + '/' + Appyear;
      D2 := Frm[1].Strings[28] + '/' + Frm[1].Strings[27] + '/' + Appyear;
      result := DateDiffMDY(D1, D2);
    end
    else
      result := Constant[RY].FullYear;
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
  If LeftStr(LicenseLevel, 8) = 'T3 Multi' then
    result := User.M_Office + SDD + SSec
  Else
    result := SMM + SDD + SSec;
end;

{$IFDEF single}

Function EditDate(s: String; MnYear: String; MxYear: string): Boolean;
{ In form yyyy/mm/dd }
Var
  DD, MM: string; // [2];
begin
  result := True;
  If s = '' then
    exit;
  DD := RightStr(s, 2);
  MM := MidStr(s, 6, 2);
  If (s[5] <> '/') or (s[8] <> '/') or (not InNumRange(DD, '01', '31')) or
    (not InNumRange(MM, '01', '12')) or
    (not InNumRange(LeftStr(s, 4), MnYear, MxYear)) or
    (Vl(LeftStr(s, 4)) > Vl(MxYear)) then
    result := False;

  If (Vl(MM) = 2) and (Vl(DD) > 28) then
    result := False;
  If (Vl(LeftStr(s, 4)) = 1996) and (Vl(MM) = 2) and (Vl(DD) = 29) then
    result := True;
  If (Vl(LeftStr(s, 4)) = 2000) and (Vl(MM) = 2) and (Vl(DD) = 29) then
    result := True;
  If (Vl(LeftStr(s, 4)) = 2004) and (Vl(MM) = 2) and (Vl(DD) = 29) then
    result := True;
  If (Vl(LeftStr(s, 4)) = 2008) and (Vl(MM) = 2) and (Vl(DD) = 29) then
    result := True;
  If ((Vl(MM) = 4) or (Vl(MM) = 6) or (Vl(MM) = 9) or (Vl(MM) = 11)) and
    (Vl(DD) > 30) then
    result := False;
end;

Function EditT3Date(s: String; MxYear: string): Boolean;
{ In form yyyy-mm-dd }
Var
  DD, MM: string; // [2];
begin
  result := True;
  If s = '' then
    exit;
  If (s[5] <> '-') or (s[8] <> '-') or
    (not InNumRange(RightStr(s, 2), '01', '31')) or
    (not InNumRange(MidStr(s, 6, 2), '01', '12')) or
    (not InNumRange(LeftStr(s, 4), '1900', MxYear)) or
    (Vl(RightStr(s, 4)) > Vl(MxYear)) then
    result := False;
end;
{$ELSE}

Function EditDate(s: String; MnYear, MxYear: Integer): Boolean;
{ In form yyyy/mm/dd }
begin
  result := EditDateYMD(s, MnYear, MxYear, '/');
end;

Function EditT3Date(s: String; MxYear: Integer): Boolean;
begin
  result := EditDateYMD(s, 1900, MxYear, '-');
end;
{$ENDIF}

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
begin
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

//20170112 Igor >>> (Move To TUserProfile)
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
*) //20170112 Igor <<<

Function MakeDataDirectory(DataDir: string): Integer;
{ return codes
  0 : OK
  -1 : Directory exists
  -3 : cannot be created
}
begin
  result := 0;
  If ForceDirectories(DataDir) <> True then
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
  { copy the Clients d bf }
  Result := FileExists(IncludeTrailingPathDelimiter(DataDir) + ClientsDBLite);
  if not Result then
    result := CopyDB(ClientsDBLite, Appdir, DataDir, Err);
  if Not Result then
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

  AppT3_2026.PrepareDistribution;

  if FList.InitFormsTable(Appdir, FormsDBLite, FormsTableLite) then
  // 20150918 Igor
    exit; // okay

  UserMsg('Please fix errors in TF forms');
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
  If (Province = 'BC') OR (Province = 'PE') {OR (Province = 'YT') OR}  //20180218
    or (Province = 'NU')
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
      751 .. 2325: // 20181106 Igor
        result := 475 + ((TotalContrib - 750) * 0.3333);
    else
      result := 1000; //650;  //20181207
    end;
  end;

  if Province = 'YT' then  //20180218
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

Function GetPrvForTaxCredit(RetNo: Integer): Real;
begin
  result := Vl(FetchElm(RetNo, 'T3PFT', 34));
end;

Procedure SumT3Boxes(RetNo: Integer);
Var
  I, j, FNo: Integer;
  Tp: string; // [1]; //type of slip
  T3Box30, T3Box30Res, T3Box30Pref, T3Box30NonRes: Real;

  T3Box: Array [21 .. 51] of Real; { usee temporarily then moved }
  T3Foot: Array [1 .. 8] of Real;
begin
  // initialize boxes
  Ret[RetNo].T3Box30 := 0;
  Ret[RetNo].T3Box30Res := 0;
  Ret[RetNo].T3Box30Pref := 0;
  Ret[RetNo].T3Box30NonRes := 0;

  For I := 21 to 51 do
  begin
    T3Box[I] := 0;
    Ret[RetNo].T3BoxRes[I] := 0;
    Ret[RetNo].T3BoxPref[I] := 0;
    Ret[RetNo].T3BoxNonRes[I] := 0;
  end;
  For I := 1 to 8 do
  begin
    T3Foot[I] := 0;
    Ret[RetNo].T3FootRes[I] := 0;
    Ret[RetNo].T3FootNonRes[I] := 0;
    Ret[RetNo].T3FootPref[I] := 0;
  end;

  { run thtu all slips }
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = 'T3SUPL' then
    begin
      FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] then
      begin { single slip }
        T3Box[49] := Vl(FetchElmFNo(RetNo, FNo, 56));
        T3Box[50] := Vl(FetchElmFNo(RetNo, FNo, 55));
        T3Box[51] := Vl(FetchElmFNo(RetNo, FNo, 54));

        T3Box[21] := Vl(FetchElmFNo(RetNo, FNo, 5));
        T3Box[22] := Vl(FetchElmFNo(RetNo, FNo, 6));
        T3Box[23] := Vl(FetchElmFNo(RetNo, FNo, 7));
        T3Box[24] := Vl(FetchElmFNo(RetNo, FNo, 8));
        T3Box[25] := Vl(FetchElmFNo(RetNo, FNo, 9));
        T3Box[26] := Vl(FetchElmFNo(RetNo, FNo, 10));
        T3Box[29] := Vl(FetchElmFNo(RetNo, FNo, 58));
        T3Box30 := Vl(FetchElmFNo(RetNo, FNo, 59));
        T3Box[30] := Vl(FetchElmFNo(RetNo, FNo, 12));
        T3Box[31] := Vl(FetchElmFNo(RetNo, FNo, 13));
        T3Box[32] := Vl(FetchElmFNo(RetNo, FNo, 14));
        T3Box[33] := Vl(FetchElmFNo(RetNo, FNo, 15));
        T3Box[34] := Vl(FetchElmFNo(RetNo, FNo, 16));
        T3Box[35] := Vl(FetchElmFNo(RetNo, FNo, 17));
        // T3Box[36] := Vl(FetchElmFNo(RetNo,FNo,18));
        T3Box[37] := Vl(FetchElmFNo(RetNo, FNo, 19));
        T3Box[38] := Vl(FetchElmFNo(RetNo, FNo, 20));
        T3Box[39] := Vl(FetchElmFNo(RetNo, FNo, 21));
        T3Box[40] := Vl(FetchElmFNo(RetNo, FNo, 22));
        T3Box[41] := Vl(FetchElmFNo(RetNo, FNo, 23));
        T3Box[42] := Vl(FetchElmFNo(RetNo, FNo, 49));
        T3Box[45] := Vl(FetchElmFNo(RetNo, FNo, 18));
        T3Box[46] := Vl(FetchElmFNo(RetNo, FNo, 51));
        T3Box[47] := Vl(FetchElmFNo(RetNo, FNo, 52));
        T3Box[48] := Vl(FetchElmFNo(RetNo, FNo, 53));
        { foot notes }

        T3Foot[1] := GetFootValue(RetNo, FNo, 'Box 21-Inc ');
        T3Foot[2] := GetFootValue(RetNo, FNo, 'Box 26-ECP-');
        T3Foot[3] := GetFootValue(RetNo, FNo, 'Box 26-Self');
        T3Foot[4] := GetFootValue(RetNo, FNo, 'Box 30-QFP-');
        T3Foot[5] := GetFootValue(RetNo, FNo, 'Box 30-QSB-');

        T3Foot[6] := GetFootValue(RetNo, FNo, 'Box 21-P1  ');
        T3Foot[7] := GetFootValue(RetNo, FNo, 'Box 21-P2  ');
        T3Foot[8] := GetFootValue(RetNo, FNo, 'Box 21-P3  ');


        //SET type of slip (TP)
        if (UpperCase(FetchElmFNo(RetNo, FNo, 41)) = 'Y') And (UpperCase(FetchElmFNo(RetNo, FNo, 42)) <> 'Y') then
          Tp := 'R'; //resident
        if (UpperCase(FetchElmFNo(RetNo, FNo, 41)) = 'N') then
          Tp := 'N'; //non resident
        if (UpperCase(FetchElmFNo(RetNo, FNo, 42)) = 'Y') then
          Tp := 'P'; //preferred


        If Tp = 'R' then
        begin
          Ret[RetNo].T3Box30Res := Ret[RetNo].T3Box30Res + T3Box30;

          for j := 21 to 51 do
            Ret[RetNo].T3BoxRes[j] := Ret[RetNo].T3BoxRes[j] + T3Box[j];
          For j := 1 to 8 do
            Ret[RetNo].T3FootRes[j] := Ret[RetNo].T3FootRes[j] + T3Foot[j];

        end;

        If Tp = 'P' then
        begin
          Ret[RetNo].T3Box30Pref := Ret[RetNo].T3Box30Pref + T3Box30;

          for j := 21 to 51 do
            Ret[RetNo].T3BoxPref[j] := Ret[RetNo].T3BoxPref[j] + T3Box[j];
          For j := 1 to 8 do
            Ret[RetNo].T3FootPref[j] := Ret[RetNo].T3FootPref[j] + T3Foot[j];
        end;

        If Tp = 'N' then
        begin
          Ret[RetNo].T3Box30NonRes := Ret[RetNo].T3Box30NonRes + T3Box30;

          For j := 21 to 51 do
            Ret[RetNo].T3BoxNonRes[j] := Ret[RetNo].T3BoxNonRes[j] + T3Box[j];
          For j := 1 to 8 do
            Ret[RetNo].T3FootNonRes[j] := Ret[RetNo].T3FootNonRes[j] +
              T3Foot[j];
        end;

        For j := 21 to 51 do
          T3Box[j] := 0;
        For j := 1 to 8 do
          T3Foot[j] := 0;
      end;
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

Function GetEmptyT3BoxNo(RetNo, FNo: integer; FromElm, ToElm, ByElm: Integer): Integer;
Var
  I: Integer;
begin
  result := 0;
  I := FromElm;
  Repeat

    //20170321
   // showmessage(inttostr(I) + '      ' + floattostr(Tv[I]));

    If Ret[RetNo].Frm[FNo].Tv[I] = 0 then
    begin
      result := I;
      exit;
    end;
    inc(I, ByElm);
  until I > ToElm;
end;

//Procedure CopySlipToDestForm(RetNo: Integer; FromForm: string; DestFNo: Integer;
Procedure CopyT3SlipToDestForm(RetNo: Integer; FromForm: string; DestFNo: Integer;
  TopOrBottom: Integer; DestFormName: String);
Var
  I, j, k, Ndx, NumSlips: Integer;
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

    { TEST ONLY  //20250323
    //COPY OTHE AMOUNTS to Destination
    Strings[23]:=AllTrim(FetchElm(RetNo, FromForm, 76));
    Tv[24]:=Tv[75];

    Strings[25]:=AllTrim(FetchElm(RetNo, FromForm, 74));
    Tv[26]:=Tv[73];
    }


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

    //COPY new fields on T3Supl to destination:



  end; { end with ret }

end; { procedure }

Procedure CopyNR4SlipToDestForm(RetNo: Integer; FromForm: string;
  DestFNo: Integer; TopOrBottom: Integer; DestFormName: String);
//20170628 Igor >>>
Var
  I, k, Ndx: Integer;
begin
  If TopOrBottom = 1 then
    Ndx := 0
  else
  if TopOrBottom = 2 then
    Ndx := 40; // fields in second slip
  with Ret[RetNo].Frm[DestFNo] do
    For k := 1 to 36 do
      Strings[k + ndx] := FetchElm(RetNo, FromForm, k);
//20170628 Igor <<<
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
 // Cf_TrustType := ''; // 20160207 //20200328
  Cf_Itc := 0;
  CF_NonCapLossPrior:=0;  //20170326
  // 20130329
  Cf_CNILInc := 0;
  Cf_CNILExp := 0;
  (*
    CF_PensAdj   :=0;
    CF_GSTRebate :=0;
  *)
end;

Procedure CFFilterLastYrAndStore(RetNo: Integer; FormNm: String; FNo: Integer;
  Elm: Integer; Valu: String);
Var
  I: Integer;
  OldFNo, NewFNo: Integer;
Begin
  // ShowMessage(FormNM);
  // 20130329
  if GetFormType(FormNm) = 'T3' then
  Begin
    {//20200328
    // cf the trust type  //20160207
    If (Elm = 23) and (Valu > '') then  Cf_TrustType := '001';
    If (Elm = 73) and (Valu > '') then  Cf_TrustType := Valu;
    If (Elm = 31) and (Valu > '') then  Cf_TrustType := '011';
    }
    If (FormNm = 'T2038') and (Elm = 146) then Cf_Itc := Vl(Valu);
    If (FormNm = 'S4') and (Elm = 16) then Cf_CNILExp := Vl(Valu);
    If (FormNm = 'S4') and (Elm = 121) then Cf_CNILInc := Vl(Valu);
    Ret[RetNo].FrmHasData[FNo]:=True;
   end;

   If (FormNm = 'T3LOSS') and (Elm = 5) then  CF_NonCapLossPrior := Vl(Valu); //20170326
    // ----
   If (LeftStr(FormNm, 5) = 'PAGE_') or (LeftStr(FormNm, 8) = 'T5INCOME') or
      (LeftStr(FormNm, 8) = 'T3INCOME') or (LeftStr(FormNm, 8) = 'T5013INC') or
      (FormNm = 'S1') or (FormNm = 'S1A') or (LeftStr(FormNm, 6) = 'S1SUPQ') or
      (LeftStr(FormNm, 7) = 'S1SUPPL') or (FormNm = 'S1AS2') or (FormNm = 'S2')
      or (FormNm = 'S3') or (FormNm = 'S5') or (FormNm = 'S6') or
      (FormNm = 'S7') or (FormNm = 'S8') or (FormNm = 'ABIL') or
      (LeftStr(FormNm, 5) = 'T1236') // 20131231
      or (LeftStr(FormNm, 6) = 'INVSTM') or (FormNm = 'POLIT') or
      (FormNm = 'T3DON') or (FormNm = 'PRVCR') or (FormNm = 'T3OTHDED') or
      (FormNm = 'T3ADJ') or (FormNm = 'T2038') or (FormNm = 'T1135') or
      (FormNm = 'T3SUM') or (FormNm = 'T3SUM2') or
      (LeftStr(FormNm, 7) = 'FINVSTM') or (LeftStr(FormNm, 6) = 'INVSTM') or
      (FormNm = 'S9') // 20120217
      or (FormNm = 'S10')
      or (FormNm = 'S11') or (FormNm = 'S11A') or (FormNm = 'S12') or
      (FormNm = 'S13') or (FormNm = 'T3SUM') or (FormNm = 'PENSINC')
      or (FormNm = 'T183TRUST')  //20240402
      or (FormNm = 'T2043')      //20240402
      or (FormNm = 'EFMEMO')     //20240402
      or (LeftStr(FormNm, 7) = 'PRBNFR#')

      then
      Begin
       Ret[RetNo].FrmHasData[FNo]:=False;
       exit;
      End
      Else
     //20200328
      StoreElm(RetNo, FNo, Elm, Valu);

  end;

Procedure CFReformatLastYearData(RetNo: Integer);
Var
  I, j, FNo: Integer;
  x, y: Real;
  Inst, s: String;
  Cnt, OldFNo: Integer;
begin
  If RetNo = 0 then exit;
  UnlockReturn(RetNo);   //20220119
  FNo := GetFormNo('T3');
  //20220119 remove the other deductions section
  For i:=160 to 161 do begin StoreElm(RetNo, FNo, i, '');end;
  For i:=117 to 118 do begin StoreElm(RetNo, FNo, i, '');end;
  For i:=119 to 120 do begin StoreElm(RetNo, FNo, i, '');end;
  For i:=121 to 122 do begin StoreElm(RetNo, FNo, i, '');end;

  //deductions from total income
  For i:=233 to 242 do begin StoreElm(RetNo, FNo, i, '');end;
  StoreElm(RetNo, FNo, 316, ''); //20230108 tot tax deducted
   //-----------

  If FetchElmFNo(RetNo, FNo, 14) > '' then
    StoreElm(RetNo, FNo, 14, IncrementYear(FetchElmFNo(RetNo, FNo, 14)));
  If FetchElmFNo(RetNo, FNo, 17) > '' then
    StoreElm(RetNo, FNo, 17, IncrementYear(FetchElmFNo(RetNo, FNo, 17)));
  If FetchElmFNo(RetNo, FNo, 28) > '' then
    StoreElm(RetNo, FNo, 28, IncrementYear(FetchElmFNo(RetNo, FNo, 28)));

  Calc(RetNo, 'T3');

  FNo := GetFormNo('STATUS');  //20220119
  StoreElm(RetNo, FNo, 4, '00');
  For i:=8 to 13 do begin StoreElm(RetNo, FNo, i, '');end;  //dates of preparation
  //----------------------------------
 //beneficaries   //20200328
  for I := 0 to (FList.Count - 1) do
  begin
   FRec := FList.Items[I];
   FNo:=Frec.FormNo;
   if Frec.FormName='T3SUPL' then
   Begin
     for j:=1 to 66 do
     begin
      case j of 46,64,26,27,28,29,65,66,63,41,42,43,3544,60,61,62:
       //do nothing
      Else
       StoreElm(RetNo,FNo,j,'');
      end;
     end;
   End;
  end;

  { Private }
  FNo := GetFormNo('PRIVAT#1');
  If Ret[RetNo].Frm[FNo].Count = 0 then
    InitFormData(RetNo, FNo);
  Calc(RetNo, 'PRIVAT#1');


  FNo := GetFormNo('T2038');
  If Ret[RetNo].Frm[FNo].Count = 0 then
    InitFormData(RetNo, FNo);
  StoreElm(RetNo, FNo, 137, FormatFloat('#######.##', Cf_Itc));
  Calc(RetNo, 'T2038');

  // 20130329
  FNo := GetFormNo('S4');
  If Ret[RetNo].Frm[FNo].Count = 0 then
    InitFormData(RetNo, FNo);
  For I := 1 to 122 do
    StoreElm(RetNo, FNo, I, '');
  StoreElm(RetNo, FNo, 14, FormatFloat('#######.##', Cf_CNILExp));
  StoreElm(RetNo, FNo, 119, FormatFloat('#######.##', Cf_CNILInc));
  Calc(RetNo, 'S4');

  { others }
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    FNo := FRec.FormNo;
    If Ret[RetNo].FrmHasData[FNo] then
    begin

      // assets b
      if FRec.FormName = 'ASSETSB' then
      begin
        Ret[RetNo].Frm[FNo].Strings[191] := Ret[RetNo].Frm[FNo].Strings[176];
        ClearFields(RetNo, FNo, 30, 34); // additions
        ClearFields(RetNo, FNo, 12, 12);
        ClearFields(RetNo, FNo, 8, 8);
        ClearFields(RetNo, FNo, 158, 158);
        ClearFields(RetNo, FNo, 6, 6); // clas empty
        ClearFields(RetNo, FNo, 13, 13); // override
        ClearFields(RetNo, FNo, 206, 206);
        ClearFields(RetNo, FNo, 28, 28);
      end;
      // Autos
      if FRec.FormName = 'AUTOS' then
      begin
        Ret[RetNo].Frm[FNo].Strings[140] := Ret[RetNo].Frm[FNo].Strings[176];
        Ret[RetNo].Frm[FNo].Strings[4] := '1'; // km
        Ret[RetNo].Frm[FNo].Strings[7] := '1';
        ClearFields(RetNo, FNo, 37, 41); // additions
        ClearFields(RetNo, FNo, 143, 143);
        ClearFields(RetNo, FNo, 146, 146);
        ClearFields(RetNo, FNo, 197, 200);
        ClearFields(RetNo, FNo, 188, 188);
        ClearFields(RetNo, FNo, 182, 182); // class empty
        ClearFields(RetNo, FNo, 206, 206);
        ClearFields(RetNo, FNo, 178, 178);
        // expenses
        ClearFields(RetNo, FNo, 10, 10);
        ClearFields(RetNo, FNo, 28, 28);
        ClearFields(RetNo, FNo, 19, 19);
        ClearFields(RetNo, FNo, 22, 22);
        ClearFields(RetNo, FNo, 25, 25);
        ClearFields(RetNo, FNo, 13, 13);
        ClearFields(RetNo, FNo, 29, 29);
        ClearFields(RetNo, FNo, 16, 16);
        ClearFields(RetNo, FNo, 32, 32);
        ClearFields(RetNo, FNo, 36, 36);
        ClearFields(RetNo, FNo, 48, 48);
        ClearFields(RetNo, FNo, 51, 51);
        // rent
        ClearFields(RetNo, FNo, 103, 103);
        ClearFields(RetNo, FNo, 109, 109);
        ClearFields(RetNo, FNo, 106, 106);
        ClearFields(RetNo, FNo, 57, 57);
        ClearFields(RetNo, FNo, 60, 60);
        ClearFields(RetNo, FNo, 63, 63);
        ClearFields(RetNo, FNo, 126, 126);
        // leasing
        ClearFields(RetNo, FNo, 66, 66);
        ClearFields(RetNo, FNo, 69, 69);
        ClearFields(RetNo, FNo, 72, 72);
        ClearFields(RetNo, FNo, 75, 75);
      end;

      { rental }
      if FRec.FormName = 'T776' then
      begin
        Ret[RetNo].Frm[FNo].Strings[3] := '';
        Ret[RetNo].Frm[FNo].Strings[6] := '';
        ClearFields(RetNo, FNo, 47, 47);
        ClearFields(RetNo, FNo, 50, 50);
        ClearFields(RetNo, FNo, 53, 53);
        j := 57; // exp and personal, leave % in
        Repeat
          ClearFields(RetNo, FNo, j, j);
          ClearFields(RetNo, FNo, j + 2, j + 2);
          inc(j, 3);
        until j > 90;
        ClearFields(RetNo, FNo, 53, 56);
        ClearFields(RetNo, FNo, 94, 108);
        ClearFields(RetNo, FNo, 7, 8);
        ClearFields(RetNo, FNo, 20, 21);
        ClearFields(RetNo, FNo, 130, 133);
        ClearFields(RetNo, FNo, 93, 93);
        If FetchElmFNo(RetNo, FNo, 9) > '' then
          ClearFields(RetNo, FNo, 1, 135); // last yr
        // Calc(RetNo,Frec.FormInstName);

        ClearFields(RetNo, FNo, 267, 358);
        j := 202;
        Repeat
          Ret[RetNo].Frm[FNo].Strings[j] := FetchElmFNo(RetNo, FNo, j + 7);
          ClearFields(RetNo, FNo, j + 1, j + 6);
          inc(j, 9);
        until j > 256;
        ClearFields(RetNo, FNo, 264, 264);
        Calc(RetNo, FRec.FormInstName, FRec.FormNo);
      end;

      // T3Loss
      if FRec.FormName = 'T3LOSS' then
      Begin
        FNo := GetFormNo('T3LOSS');
        If Ret[RetNo].Frm[FNo].Count = 0 then
          InitFormData(RetNo, FNo);
        { non cap losses }
        j := 2;
        Repeat
          StoreElm(RetNo, FNo, j, FetchElmFNo(RetNo, FNo, j + 3));
          ClearFields(RetNo, FNo, j + 1, j + 2);
          inc(j, 5);
        until j > 37;

          { push it up }
        j := 2;
        Repeat
          StoreElm(RetNo, FNo, j, FetchElmFNo(RetNo, FNo, j + 5));
          inc(j, 5);
        until j > 37;
        ClearFields(RetNo, FNo, 37, 37);
        //prior years
        s:=FormatFloat('#######.##',CF_NonCapLossPrior + Vl(FetchElmFNo(RetNo, FNo, 2)));
        StoreElm(RetNo, FNo, 2, s);

        { Farm losses }
        j := 46;
        Repeat
          StoreElm(RetNo, FNo, j, FetchElmFNo(RetNo, FNo, j + 3));
          ClearFields(RetNo, FNo, j + 1, j + 2);
          inc(j, 5);
        until j > 96;
        { push it up }
        j := 46;
        Repeat
          StoreElm(RetNo, FNo, j, FetchElmFNo(RetNo, FNo, j + 5));
          inc(j, 5);
        until j > 96;
        ClearFields(RetNo, FNo, 96, 96);
        { Restr losses }
        j := 105;
        Repeat
          StoreElm(RetNo, FNo, j, FetchElmFNo(RetNo, FNo, j + 3));
          ClearFields(RetNo, FNo, j + 1, j + 2);
          inc(j, 5);
        until j > 155;
        { push it up }
        j := 105;
        Repeat
          StoreElm(RetNo, FNo, j, FetchElmFNo(RetNo, FNo, j + 5));
          inc(j, 5);
        until j > 155;
        ClearFields(RetNo, FNo, 155, 155);

        // net cap loss
        //StoreElm(RetNo, FNo, 355, FetchElmFNo(RetNo, FNo, 206)); // 20160207 ??? //20180330
        // StoreElm(RetNo,FNo,350,FetchElmFNo(RetNo,FNo,206)); //20141231
        // StoreElm(RetNo,FNo,345,FetchElmFNo(RetNo,FNo,206)); //20131227 //20090125   //20120218
        StoreElm(RetNo, FNo, 201, ''); // automatic
        j := 265;
        Repeat
          StoreElm(RetNo, FNo, j, FetchElmFNo(RetNo, FNo, j + 4));
          inc(j, 5);
        until j >380; //365; //20220215 //20180330  355;
        Calc(RetNo, FRec.FormName); // 20130218
      end; // t3loss

      { bus }
      if FRec.FormName = 'T2125' then // 'T2125_1' then  //20131231
      begin
        Ret[RetNo].Frm[FNo].Strings[4] :=
          IncrementYear(FetchElmFNo(RetNo, FNo, 4));
        Ret[RetNo].Frm[FNo].Strings[5] :=
          IncrementYear(FetchElmFNo(RetNo, FNo, 5));
        // gst bus no
        // Strings[21]
        ClearFields(RetNo, FNo, 23, 27);
        ClearFields(RetNo, FNo, 29, 29);
        ClearFields(RetNo, FNo, 30, 30);
        ClearFields(RetNo, FNo, 75, 76);
        ClearFields(RetNo, FNo, 83, 83);
        ClearFields(RetNo, FNo, 87, 89); // prof income
        ClearFields(RetNo, FNo, 84, 84);
        ClearFields(RetNo, FNo, 92, 92);

        ClearFields(RetNo, FNo, 101, 172);
        Ret[RetNo].Frm[FNo].Strings[234] := FetchElmFNo(RetNo, FNo, 231);
        // home c/f
        ClearFields(RetNo, FNo, 201, 233);
        ClearFields(RetNo, FNo, 201, 235);
        ClearFields(RetNo, FNo, 251, 253);

        ClearFields(RetNo, FNo, 1, 513);

        ClearFields(RetNo, FNo, 1, 641);
        s := FetchElmFNo(RetNo, FNo, 650); { cec }
        ClearFields(RetNo, FNo, 642, 655);
        Ret[RetNo].Frm[FNo].Strings[642] := s;

        ClearFields(RetNo, FNo, 1, 873);
      end; // t2125

      { Fish }
      if FRec.FormName = 'T2121' then
      begin
        Ret[RetNo].Frm[FNo].Strings[4] :=
          IncrementYear(FetchElmFNo(RetNo, FNo, 4));
        Ret[RetNo].Frm[FNo].Strings[5] :=
          IncrementYear(FetchElmFNo(RetNo, FNo, 5));
        ClearFields(RetNo, FNo, 20, 74);
        ClearFields(RetNo, FNo, 75, 78);
        ClearFields(RetNo, FNo, 61, 61);
        If FetchElmFNo(RetNo, FNo, 6) > '' then
          ClearFields(RetNo, FNo, 1, 17); // last year
      end;
      if FRec.FormName = 'T2121' then
      begin
        s := FetchElmFNo(RetNo, FNo, 131); { bus us cf }
        ClearFields(RetNo, FNo, 1, 135);
        ClearFields(RetNo, FNo, 136, 136);
        Ret[RetNo].Frm[FNo].Strings[128] := s;
        j := 138;
        Repeat
          Ret[RetNo].Frm[FNo].Strings[j] := FetchElmFNo(RetNo, FNo, j + 7);
          ClearFields(RetNo, FNo, j + 1, j + 6);
          ClearFields(RetNo, FNo, j + 8, j + 8);
          inc(j, 10);
        until j > 208;
        j := 220;
        Repeat
          Ret[RetNo].Frm[FNo].Strings[j] := FetchElmFNo(RetNo, FNo, j + 7);
          ClearFields(RetNo, FNo, j + 1, j + 6);
          ClearFields(RetNo, FNo, j + 8, j + 8);
          inc(j, 10);
        until j > 250;
      end;

      if FRec.FormName = 'T2121' then
        ClearFields(RetNo, FNo, 1, 434);
      if FRec.FormName = 'T2121' then
      begin
        ClearFields(RetNo, FNo, 1, 2);
        s := FetchElmFNo(RetNo, FNo, 531); { cec }
        ClearFields(RetNo, FNo, 523, 536);
        Ret[RetNo].Frm[FNo].Strings[523] := s;
      end;
      if FRec.FormName = 'T2121' then { lease }
      begin
        ClearFields(RetNo, FNo, 604, 656);
        ClearFields(RetNo, FNo, 718, 725);
        ClearFields(RetNo, FNo, 666, 717);
      end;

      { farm }
      if FRec.FormName = 'T2042' then
      begin
        Ret[RetNo].Frm[FNo].Strings[4] :=
          IncrementYear(FetchElmFNo(RetNo, FNo, 4));
        Ret[RetNo].Frm[FNo].Strings[5] :=
          IncrementYear(FetchElmFNo(RetNo, FNo, 5));
        ClearFields(RetNo, FNo, 26, 67);
      end;
      if FRec.FormName = 'T2042' then
        ClearFields(RetNo, FNo, 1, 148);
      if FRec.FormName = 'T2042' then
        ClearFields(RetNo, FNo, 1, 334);
      if FRec.FormName = 'T2042' then { cca,Cec }
      begin
        s := FetchElmFNo(RetNo, FNo, 557);
        ClearFields(RetNo, FNo, 525, 562);
        ClearFields(RetNo, FNo, 451, 453);
        Ret[RetNo].Frm[FNo].Strings[549] := s;
        ClearFields(RetNo, FNo, 563, 563);

        j := 402;
        Repeat
          Ret[RetNo].Frm[FNo].Strings[j] := FetchElmFNo(RetNo, FNo, j + 7);
          ClearFields(RetNo, FNo, j + 1, j + 6);
          ClearFields(RetNo, FNo, j + 8, j + 8);
          inc(j, 10);
        until j > 472;
        j := 484;
        Repeat
          Ret[RetNo].Frm[FNo].Strings[j] := FetchElmFNo(RetNo, FNo, j + 7);
          ClearFields(RetNo, FNo, j + 1, j + 6);
          ClearFields(RetNo, FNo, j + 8, j + 8);
          inc(j, 10);
        until j > 514;
      end;

      if FRec.FormName = 'T2042' then
      begin
        s := FetchElmFNo(RetNo, FNo, 635); { bus use }
        ClearFields(RetNo, FNo, 1, 639);
        Ret[RetNo].Frm[FNo].Strings[632] := s;
      end;

      if FRec.FormName = 'T2042' then
      begin
        ClearFields(RetNo, FNo, 4, 756);
        ClearFields(RetNo, FNo, 118, 825);
        ClearFields(RetNo, FNo, 66, 817);
      end;
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

Function FormatAmount(FrmNm: String; s: string; How: Integer): string;
Var
  x: Real;
begin
  Try
    s := Ltrim(s);
    x := Vl(s);
    result := FormatFloat('###,###,###.00', x);
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbok], 0);
  end;
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


Function GetPrevYearEnd(ThisYearEnd: String; No: Integer): String;
{ in as YYYY-mm-dd }
Var
  k: Integer;
begin
  k := MyStrToInt(LeftStr(ThisYearEnd, 4)) - No;
  result := IntToStr(k) + MidStr(ThisYearEnd, 5, 6)
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

Function GetTrustNetIncome(RetNo: Integer): Real;
begin
  result := Vl(FetchElm(RetNo, 'T3', 256));
end;

Function IsInterVivos(RetNo: Integer): Boolean;
begin
  result := True;
  If IsTestamentary(RetNo) then
    result := False;
end;

Function IsTestamentary(RetNo: Integer): Boolean;
begin
  result := False;
  // 20160130
  If (FetchElm(RetNo, 'T3', 81) = '001')
    or (FetchElm(RetNo, 'T3', 81) = '900')
    or (FetchElm(RetNo, 'T3', 81) = '901')
    //20220118 Igor >>>
    or (FetchElm(RetNo, 'T3', 81) = '903')
    or (FetchElm(RetNo, 'T3', 81) = '904')
    or (FetchElm(RetNo, 'T3', 81) = '905')
    //20220118 Igor <<<
    or (FetchElm(RetNo, 'T3', 43) > '')     //20180107 903
    or (FetchElm(RetNo, 'T3', 45) > '')     //20180108 904
    //or (FetchElm(RetNo, 'T3', 81) = '903')
  then
    result := True;
  {
    If (Ret[RetNo]^.TrustType =  TestamSpousal)
    or
    (Ret[RetNo]^.TrustType =  TestamOther)
    then result := True;
  }
end;

Function FetchInclusionRate(RetNo: Integer): Real;
begin
  result := 0.50;
 // If Vl(FetchElm(RetNo, 'S12', 301)) > 0 then result := Vl(FetchElm(RetNo, 'S12', 301)); //20220322
end;

Function GetT3TrustName(RetNo: Integer): String;
begin
  result := FetchElm(RetNo, 'T3', 1);
end;

Function GetT3StartYear(RetNo: Integer): String;
begin
  result := FetchElm(RetNo, 'T3', 14);
end;

Function GetT3EndYear(RetNo: Integer): String;
begin
  result := FetchElm(RetNo, 'T3', 17);
end;

Function GetClientLettersDir: String;
Var
  Dir: String;
begin
  Dir := OptRec.Dir_Cur + '\' + 'ClientLetters';
  If Not DirectoryExists(Dir) then
    if not DirectoryExists(Dir) then
    begin
      if not CreateDir(Dir) then
        raise Exception.create('Cannot create letters directory ' + Dir);
    end;
  result := Dir;
end;

Function MkClientLetterName(RetNo: Integer): String;
begin
  result := GetT3TrustName(RetNo);
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
(*
Function CountT3Slips(RetNo: Integer): Integer;
Var
  I, FNo: Integer;
begin
  result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = 'T3SUPPL' then
    begin
      FNo := FRec.FormNo;
      If (Ret[RetNo].FrmHasData[FNo]) and (FetchElmFNo(RetNo, FNo, 1) > '') then
        inc(result);
    end;
  end;
end;
*)
Function CountNR4Slips(RetNo: Integer): Integer;
Var
  I, FNo: Integer;
begin
  result := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = 'NR4DET' then
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
        result := result                //20230320
          + Vl(FetchElmFNo(RetNo, FNo, 56)) //div elgble
          + Vl(FetchElmFNo(RetNo, FNo, 5)) //Cap gains
          + Vl(FetchElmFNo(RetNo, FNo, 7)) //Div non elig
          + Vl(FetchElmFNo(RetNo, FNo, 10)); // Oth Inc
        (*
        result := result + Vl(FetchElmFNo(RetNo, FNo, 5)) //box 21
          + Vl(FetchElmFNo(RetNo, FNo, 6)) { 22 }
          + Vl(FetchElmFNo(RetNo, FNo, 7)) { 23 }
          + Vl(FetchElmFNo(RetNo, FNo, 8)) { 24 }
          + Vl(FetchElmFNo(RetNo, FNo, 9)) { 25 }
          + Vl(FetchElmFNo(RetNo, FNo, 10)); { 26 }
        *)
    end;
  end;
end;

Function GetTotalFootValue(RetNo: Integer; Txt: String; SlipType: String): Real;
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
        (GetT3SlipType(RetNo, FNo) = SlipType) then
        result := result + GetFootValue(RetNo, FNo, Txt);
    end;
  end;
end;

Function GetT3SlipType(RetNo, FNo: Integer): String;
begin
  If (UpperCase(FetchElmFNo(RetNo, FNo, 41)) = 'Y') and
    (UpperCase(FetchElmFNo(RetNo, FNo, 42)) <> 'Y') then
  begin
    result := 'R';
    exit;
  end;

  If FetchElmFNo(RetNo, FNo, 41) = 'N' then
  begin
    result := 'N';
    exit;
  end;

  If UpperCase(FetchElmFNo(RetNo, FNo, 42)) = 'Y' then
  begin
    result := 'P';
    exit;
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



Procedure ClearFields(RetNo, FNo, Ndx1, Ndx2: Integer);
Var
  I: Integer;
begin
  For I := Ndx1 to Ndx2 do
    StoreElm(RetNo, FNo, I, '');
end;

Function UseIntervivosRate(RetNo: Integer): Boolean;
begin
  result := False;
  If (UpperCase(FetchElm(RetNo, 'S11', 66)) = 'Y') then
  begin
    result := True;
    exit;
  end; // 20160207
  // If (UpperCase(FetchElm(RetNo,'S11',66)) = 'N') then  Exit;  //grndfathered? //20150211 //20160305 Igor
  If (IsInterVivos(RetNo)) Or (Ret[RetNo].TrustType = ivMutualFund) then
    result := True;
  // 20160608
  If (GetStartTrustYear(RetNo) > '2015') // 20160808
    and (FetchElm(RetNo, 'T3', 81) <> '903') and
    (FetchElm(RetNo, 'T3', 81) <> '904') then
    result := True; // 904 to be changed later see CRA??
end;

Function GetCapGainsConversionRate(RetNo: Integer; InclusionRate: Real): String;
Var
  InclRate: Real;
begin
  { Result :='0.50'; }
  {
    Result:=FormatFloat('#0.0000',3/5);
    If Ret[RetNo].FrmHasdata[GetFormNo('S12_4')] = false then exit;
  }
  If InclusionRate > 0 then
    result := FormatFloat('#0.0000', MaxR(0, (4 / 5) - InclusionRate) /
      InclusionRate);
end;

Function PrvTaxBfrT3PFT(RetNo: Integer): Real;
Var
  x: Real;
begin
  result := 0;
  If Ret[RetNo].Province = 'ON' then
  begin
    result := MaxR(0, Vl(FetchElm(RetNo, 'T3ON', 50)) - MaxR(0,
      312 - Vl(FetchElm(RetNo, 'T3ON', 50))));
  end;

  If Ret[RetNo].Province = 'AB' then
    result := Vl(FetchElm(RetNo, 'T3AB', 41)); { ? }

  If Ret[RetNo].Province = 'BC' then
  begin
    result := MaxR(0, Vl(FetchElm(RetNo, 'T3BC', 53)) +
      Vl(FetchElm(RetNo, 'T3BC', 56)) - Vl(FetchElm(RetNo, 'T3BC', 58)) -
      Vl(FetchElm(RetNo, 'T3BC', 59)) - Vl(FetchElm(RetNo, 'T3BC', 61)));
  end;

  If Ret[RetNo].Province = 'MB' then
    result := Vl(FetchElm(RetNo, 'T3MB', 47));
  If Ret[RetNo].Province = 'NB' then
    result := Vl(FetchElm(RetNo, 'T3NB', 41)); { ok }
  If Ret[RetNo].Province = 'NL' then
    result := Vl(FetchElm(RetNo, 'T3NL', 44)); { ok }
  If Ret[RetNo].Province = 'NS' then
  begin
    result := Vl(FetchElm(RetNo, 'T3NS', 44));
  end;
  If Ret[RetNo].Province = 'NT' then
    result := Vl(FetchElm(RetNo, 'T3NT', 41));

  If Ret[RetNo].Province = 'NU' then
    result := MaxR(0, Vl(FetchElm(RetNo, 'T3NU', 41)));

  If Ret[RetNo].Province = 'PE' then
    result := Vl(FetchElm(RetNo, 'T3PE', 42));

  If Ret[RetNo].Province = 'SK' then
  begin
    result := Vl(FetchElm(RetNo, 'T3SK', 41));
  end;
  If Ret[RetNo].Province = 'YT' then
    result := Vl(FetchElm(RetNo, 'T3YT', 66));
end;


Function GetFastPrintIndicator: Boolean; // 20160901 Igor
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

Procedure Delay(ms: LongInt);
Var
  TheTime: LongInt;
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
  Screen.Cursor := crHourGlass;
  h := ShellExecute(Application.MainForm.Handle, 'open', Pchar('' + Url), Nil,
    Nil, Sw_Show);
  If h <= 32 then
  begin
    ShowMessage('Connection failed');
    result := False;
  end;
  Screen.Cursor := crDefault;
end;

Procedure BuildUpdateXmlForWeb(UpdFileName: String);
// the file creared describes the latest version of the update
// and it needs to be uploaded to the web together with the update
Const
  XmLFileName = 'T3Update.xml';
Var
  TempList: TStringList;
begin
  UpdFileName := '????T3Upd17??????';
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

  With MainFormT3 do
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

Function PrintLabels(DataDir, FileNm: String): Boolean;
var
  ADConnection: TADConnection;
  Tbl: TADTable;
  I, RecNo, LineCnt, MxLinesPerPage, PageCnt: Integer;
  PrnFile: TextFile;
  Xpos: LongInt;
  YPos: LongInt;
  InpFile: TextFile;
  InpKey: String;
  PixPerInX, PixPerInY: Integer;
  LabelPosX, LabelPosY: Integer;
  TopMargin, LeftMargin, LabelHeight, LabelWidth, VertIncr,
    HorizLabelGap: Integer;
  Line1, Line2, Line3, Line4, Line5: String;
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
  // 20150923 Igor
  ADConnection := TADConnection.create(Application);
  Tbl := TADTable.create(Application);
  SetTableName(ADConnection, Tbl, DataDir + '\' + ClientsDBLite,
    ClientsTableLite, 'FILE_NAME');

  RecNo := 0;
  while not Eof(InpFile) do
  begin
    ReadLn(InpFile, InpKey);
    if Tbl.FindKey([InpKey]) then
    begin
      inc(RecNo);
      If RecNo > 30 then
      begin
        RecNo := 1;
        Printer.NewPage;
      end;
      Line1 := Tbl.FieldByName('Corp_Name').AsString;
      Line2 := Tbl.FieldByName('STREET').AsString;
      Line3 := Tbl.FieldByName('CITY').AsString;
      Line4 := Tbl.FieldByName('PROVINCE').AsString + ', ' +
        Tbl.FieldByName('POSTAL').AsString;

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
  end; { end while }

  CloseFile(InpFile);
  Tbl.free;
  ADConnection.free;
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
            SQL.Add('Select * from ' + ClientsTableLite); // 20150923 Igor
            // SQL.Add( WhereClause);
            SQL.Add(' ORDER BY Updated_Dt DESC');
            Prepare;
            open;

            First;
            while not EOF do
            begin
              s := paddR(AllTrim(AQuery.FieldByName('CORP_NAME').AsString), 30) + paddR(AQuery.FieldByName('Updated_Dt').AsString, 11) + paddR(AQuery.FieldByName('Updated_tm').AsString, 12) + paddR(AQuery.FieldByName('File_Name').AsString, 12);
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
  s := LeftStr(paddR(cName, 30), 30) + //20180314 Igor
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

  MainFormT3.ShowMostRecentReturns;
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

  MainFormT3.ShowMostRecentReturns;
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
  h := ShellExecute(MainFormT3.Handle, Nil,
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
  result := CopyDB(AppT3_2026.ClientsDBLite, Appdir, DataDir, Err);
  if not Result then
    MessageDlg(Err, mtError, [mbOk], 0);
//20170803 Igor<<<
end;


procedure UpdateDbStructure(ADir: string = ''); // 20220324 Igor //20220325 Igor
var
  Conn: TADConnection;
  Q: TADQuery;
begin
  //20220325 Igor >>>
  if ADir.IsEmpty then
    ADir := OptRec.Dir_Cur;
  //20220325 Igor <<<
  //20230103 Igor >>>
  if not TFile.Exists(TPath.Combine(ADir, AppT3_2026.ClientsDBLite)) then
    InitDataBase(Appdir, ADir);
  //20230103 Igor <<<
  if TFile.Exists(TPath.Combine(ADir, AppT3_2026.ClientsDBLite)) then //20220325 Igor
  begin
    Conn := TADConnection.Create(Nil);
    Q := TADQuery.Create(Nil);
    try
      Conn.LoginPrompt := false;
      Conn.DriverName := 'SQLite';
      Conn.Params.Values['Database'] := TPath.Combine(ADir, AppT3_2026.ClientsDBLite); //20220325 Igor
      Conn.Params.Values['Password'] := Pswd(GC_SQLLitePasswordVersion, false);
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
        if not Assigned(Q.FindField('EF_STATUS')) then
          Conn.ExecSQL('ALTER TABLE Clients ADD EF_STATUS VARCHAR(2)');
        //20220324 Igor >>>
        if not Assigned(Q.FindField('RTUSENT_BY')) then
          Conn.ExecSQL('ALTER TABLE Clients ADD RTUSENT_BY VARCHAR(10)');
        if not Assigned(Q.FindField('RTUSENT_DT')) then
          Conn.ExecSQL('ALTER TABLE Clients ADD RTUSENT_DT VARCHAR(10)');
        if not Assigned(Q.FindField('RTUSENT_TM')) then
          Conn.ExecSQL('ALTER TABLE Clients ADD RTUSENT_TM VARCHAR(10)');
        if not Assigned(Q.FindField('ACKRCVD_BY')) then
          Conn.ExecSQL('ALTER TABLE Clients ADD ACKRCVD_BY VARCHAR(10)');
        if not Assigned(Q.FindField('ACKRCVD_DT')) then
          Conn.ExecSQL('ALTER TABLE Clients ADD ACKRCVD_DT VARCHAR(10)');
        if not Assigned(Q.FindField('ACKRCVD_TM')) then
          Conn.ExecSQL('ALTER TABLE Clients ADD ACKRCVD_TM VARCHAR(10)');
        //20220324 Igor <<<

        //if not Assigned(Q.FindField('CRABAL')) then //20260109 Igor
          //Conn.ExecSQL('ALTER TABLE Clients ADD CRABAL REAL'); //20260109 Igor

        //20230101 CO
        if not Assigned(Q.FindField('BAL_DUE')) then
           Conn.ExecSQL('ALTER TABLE Clients ADD BAL_DUE VARCHAR(10)');

        if not Assigned(Q.FindField('FILE_NAME')) then
           Conn.ExecSQL('ALTER TABLE Clients ADD FILE_NAME VARCHAR(20)');

        //20240129 Igor >>>
        Conn.ExecSQL(
          ' CREATE TABLE IF NOT EXISTS BenoTable ( '+ #13#10 +
          '   Id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE NOT NULL, '+ #13#10 +
          '   TrustAccountNumber VARCHAR(20) NOT NULL, '+ #13#10 +
          '   TrustName VARCHAR(255), '+ #13#10 +
          '   EntityAction CHAR(1), '+ #13#10 +
          '   EntityType CHAR(1), '+ #13#10 +
          '   EntityClassification CHAR(1), '+ #13#10 +
          '   NotNaturalPersonEntityName VARCHAR(200), '+ #13#10 +
          '   NaturalPersonGivenName VARCHAR(50), '+ #13#10 +
          '   NaturalPersonFamilyName VARCHAR(50), '+ #13#10 +
          '   NaturalPersonBirthDate VARCHAR(10), '+ #13#10 +
          '   TaxIdentificationNumberType VARCHAR(50), '+ #13#10 +
          '   TaxIdentificationNumber VARCHAR(50), '+ #13#10 +
          '   AddressLineOne VARCHAR(90), '+ #13#10 +
          '   City VARCHAR(100), '+ #13#10 +
          '   ProvinceTerritoryState VARHAR(100), '+ #13#10 +
          '   GlobalPostalZipCode VARCHAR(12), '+ #13#10 +
          '   Country VARCHAR(100), '+ #13#10 +
          '   OtherCountryOfResidence VARCHAR(100), '+ #13#10 +
          '   EntityAssociationEndAction BOOLEAN '+ #13#10 +
          ' ) ');

        Conn.ExecSQL(
          ' CREATE INDEX IF NOT EXISTS idx_BenoTable ON BenoTable (TrustAccountNumber);');
        //20240129 Igor <<<
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

(*
procedure UpdateDbStructure; // 20220324 Igor
var
  Conn: TADConnection;
  Q: TADQuery;
begin
  if TFile.Exists(TPath.Combine(OptRec.Dir_Cur, AppT3_2026.ClientsDBLite)) then
  begin
    Conn := TADConnection.Create(Nil);
    Q := TADQuery.Create(Nil);
    try
      Conn.LoginPrompt := false;
      Conn.DriverName := 'SQLite';
      Conn.Params.Values['Database'] := TPath.Combine(OptRec.Dir_Cur,
        AppT3_2026.ClientsDBLite);
      Conn.Params.Values['Password'] := Pswd(GC_SQLLitePasswordVersion, false);
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
        if not Assigned(Q.FindField('EF_STATUS')) then
          Conn.ExecSQL('ALTER TABLE Clients ADD EF_STATUS VARCHAR(2)');
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
*)
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
begin
  result := -1;
  If MostRecentList.Count = 0 then
    exit;
  FlName := AllTrim(FlName);
  For I := 0 to MostRecentList.Count - 1 do
    if AllTrim(LeftStr(FlName, 20)) = AllTrim(MidStr(MostRecentList[I], 54, 20))
    then // 20140715
    // if LeftStr(FlName,20) = AllTrim(MidStr(MostRecentList[i],54,20)) then    //20130413
    // if FlName = AllTrim(MidStr(MostRecentList[i],54,12)) then
    begin
      result := I;
      exit;
    end;
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

{$IFDEF single}

function FormHasInstanceIndicator(FName: String): Boolean;
Var
  I: Integer;
begin
  result := False;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If (FName = FRec.FormName) then
    begin
      If LeftStr(FRec.FormInst, 1) = '#' then
      begin
        result := True;
        exit;
      end;
    end;
  end;
End;

Procedure GetKeyWAttributes(KeyW: String; Var FName: String; Var Elm: Integer;
  Var IsAmount: String);
Var
  I: Integer;
begin
  IsAmount := ''; // in case not found
  for I := 0 to (DataDictList.Count - 1) do
  begin
    DataDictRec := DataDictList.Items[I];
    If KeyW = MidStr(DataDictRec.KeyWord, 1, 255) then
    begin
      FName := DataDictRec.FormName;
      Elm := DataDictRec.Field_No;
      IsAmount := DataDictRec.Is_Amount;
      exit;
    End;
  end;
End;
{$ELSE}
{$ENDIF}

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

{$IFDEF single}

Function YouKnowTheReturnPassword(UnencryptedPsw: String): Boolean;
Var
  InputString: string; // [20];
begin
  result := False;
  Application.CreateForm(TReturnPasswordT3_2026, ReturnPassword);
  ReturnPassword.ShowModal;
  InputString := LeftStr(ReturnPassword.Edit1.Text, Length(UnencryptedPsw));
  If UpperCase(InputString) = UpperCase(UnencryptedPsw) then
    result := True;
  ReturnPassword.free;
end;

Function GetFilePsw(DataDir: string; FlName: string): String;
// returns the unencrypted
// Var FullFlName:String;TempList:TStringList;Val1,Val2:String;
begin
  // ????
  Val1 := '';
  Val2 := '';
  FullFlName := DataDir + '\' + FlName;

  If not FileExists(FullFlName) then
  begin
    ShowMessage('Cannot locate the file');
    exit;
  end;
  { TODO 1 : this won't work with binary files! }
  TempList := TStringList.create;
  TempList.LoadFromFile(FullFlName);
  ReadTheValue(TempList, 'STATUS', 25, 25, Val1, Val2);
  result := DecryptPsw(Val1, 9999);
  TempList.free;
end;
{$ELSE}
{$ENDIF}

//20170219 Igor Move to T3_2026Declare
//const
//  PswElm = 25;
//  c_LastYearElm = 32;

Function GetReturnPsw(DataDir, FlName: string): String;
begin
  GetFilePsw(DataDir, FlName, PswElm, result,
    AppT3_2026.SQLLitePassword.PassRFArray); // 20160415 Igor
end;

function CheckReturnPsw(DataDir, FlName: string): Integer;
begin
  result := CheckFilePsw(DataDir, FlName, PswElm,
    AppT3_2026.SQLLitePassword.PassRFArray); // = iorReported; //20160415 Igor
end;

function CheckReturnAndPsw(DataDir, FlName: string): Boolean;
begin
  result := CheckFileAndPsw(DataDir, FlName, PswElm,
    AppT3_2026.SQLLitePassword.PassRFArray); // 20160415 Igor
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
Begin
  if not CheckIsCloud(true) and (LicenseLevel in AnyLimited) then //20180503 Igor
  begin
    if not SysUtils.DirectoryExists(LimitedVersionDir) then //20150702
      if not SysUtils.ForceDirectories(LimitedVersionDir) then
      begin
        ShowMessage('Data directory ' + LimitedVersionDir + ' cannot be created');
        exit;
      end;
    if not SysUtils.FileExists(IncludeTrailingPathDelimiter(LimitedVersionDir) + AppT3_2026.ClientsDBLite) then //20150702
      if not InitDataBase(AppDir, LimitedVersionDir) then
        exit
      else
        ShowMessage('A Data Directory has been created: ' + LimitedVersionDir);
    SaveSingleOption('Dir_Cur', LimitedVersionDir);
    SaveSingleOption('Dir_Deflt', LimitedVersionDir);
  end
  else //not limited version
  begin
  //20171201 Igor>>>
    If (DirectoryExists(DefaultDataDir(AppT3_2026) + '\Data') = False) or
      (Not FileExists(DefaultDataDir(AppT3_2026) + '\Data' + '\' + ClientsDBLite)) then
    begin
      if not SysUtils.ForceDirectories(DefaultDataDir(AppT3_2026) + '\Data') then
        ShowMessage('Data directory ' + DefaultDataDir(AppT3_2026) + '\Data' + ' cannot be created');
      If InitDataBase(Appdir, DefaultDataDir(AppT3_2026) + '\Data') then
        if not CheckIsCloud(true) then //20180503 Igor
        ShowMessage('A default Data Directory has been created: ' + DefaultDataDir(AppT3_2026) +
          '\Data' + Chr(13) +
          'You can change it via Configure | General options');
    end;
    SaveSingleOption('Dir_Cur', DefaultDataDir(AppT3_2026) + '\Data');
    SaveSingleOption('Dir_Deflt', DefaultDataDir(AppT3_2026) + '\Data');

    SaveSingleOption('Dir_ClientDocs', DefaultDataDir(AppT3_2026) + '\Client Documents');
    if not SysUtils.DirectoryExists(DefaultDataDir(AppT3_2026) + '\Client Documents') then //20150702
      SysUtils.ForceDirectories(DefaultDataDir(AppT3_2026) + '\Client Documents'); //20150702

  end;
  //20171201 Igor<<<
end;



(*
Procedure CreateDefaultDataDirectories;
//20170803 Igor>>>
Begin
  If (DirectoryExists(Appdir + '\Data') = False) or
    (Not FileExists(Appdir + '\Data' + '\' + ClientsDBLite)) then
  // 20150923 Igor
  begin
    if not SysUtils.ForceDirectories(Appdir + '\Data') then
      ShowMessage('Data directory ' + Appdir + '\Data' + ' cannot be created');
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
  With MainFormT3.EkRtf1 do
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
    If LeftStr(DataList[0], 2) <> 'TF' then
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
    result := Appdir + '\' + 'T3Forms'  //20220119 // result := Appdir + '\' + 'TFForms'
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
  If s = '' then
  begin
    result := False;
    exit;
  end;
  For I := 1 to Length(s) do
    If s[I] in ['.', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'] then
      result := True
    else
    begin
      result := False;
      exit;
    end;
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
  If Not DirectoryExists(ToDir) then
  begin
    ForceResult := ForceDirectories(ToDir);
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
// as in TF-2011 before combined forms //20130112
var
  I, CompIndex, k, n, FNo, Elm, NumForms, NumEditBoxes: Integer;
  FormsDir, DfmFileName, FName: string;
  Test1: Tform;
  TempList: TStringList;
  s: String;
begin
  T3PropDynList.free; // if already exists
  T3PropDynList := TStringList.create;
  T3PropDynList.LoadFromFile(Appdir + '\' + 'T3PropDyn.d');
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

  isCraFilingCopy := false;

  If SelectedString = 'CRA' then
  begin
    // ShowMessage('CRA T3 er filing not released yet'); //20230301
    // Exit;
    isCraFilingCopy := true; //jz // 20230217 //keep track for water mark
    result := 'RVCANSET.D';
  end
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
  If DirectoryExists(DataDir) then
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
{$IFDEF single}
  s := GetFilePsw(DataDir, FlName);
  If s > '' then
    If YouKnowTheReturnPassword(s) = False then
    begin
      ShowTimedMsg('Invalid password', 1200);
      exit;
    end;
{$ELSE}
  // in Open/ReadReturn
{$ENDIF}
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
    if not ConvertToMultiApp(AppT3_2026) then
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
    result := StringReplace(ASource, c_DefDataDir, DefaultDataDir(AppT3_2026),
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

Procedure LoadOptionsFileToMem;  //it saves to optrec
Var
  TempList: TStringList;
begin
  TempList := TStringList.create;
  TempList.LoadFromFile(Appdir + '\' + OptionsFlName);
  With OptRec do
  begin
    // Read Values
    Dir_Cur := GetOptionValue('Dir_Cur', TempList);
    Dir_ClientDocs:=GetOptionValue('Dir_ClientDocs', TempList);  //20230312
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
    //Prp_TransmitterType := GetOptionValue('Prp_TransmitterType', TempList); //20250324 - fiels removed

    Prp_EMail := GetOptionValue('Prp_EMail', TempList);
    Prp_BusNo := GetOptionValue('Prp_BusNo', TempList);
    Prp_RepresentativeId := GetOptionValue('Prp_RepresentativeId', TempList); //20230101

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
  Xpos := 30;
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


Function MiddleR(x, y, z: Real): Real;
begin

  (*
    Result:=MinR(x,MinR(y,z));
    If x>Result then Result:=x;
    If y>Result then Result:=y;
    If z>Result then Result:=z;
  *)
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

  If ValidSin(LeftStr(Bn, 9)) = False then  //20170623
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

{$IFDEF single}
        FNo := GetFormNo('PS50' + ToInst);
        If FNo = 0 then
{$ELSE}
{$ENDIF}
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

Procedure T3IncomeProcess(RetNo: Integer; Var T3OthInc: Real; Var T3Pens: Real;
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
  Var T3FCapGains: Real);

Var
  I, FNo, T3Period, ForeignCountry: Integer;
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
  T3FCapGains := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    if FRec.FormName = 'T3INCOME' then
    begin
      FNo := FRec.FormNo;
      If (Ret[RetNo].FrmHasData[FNo]) and (Ret[RetNo].Frm[FNo].Count > 0) then
      begin
        ExchRate := 1;
        T3Period := 3;
        If Vl(Ret[RetNo].Frm[FNo].Strings[4]) > 0 then
          ExchRate := Vl(Ret[RetNo].Frm[FNo].Strings[4]);
        // PercentShare := 100;
        // If Vl(Ret[RetNo].Frm[FNo].Strings[2])>0 then
        PercentShare := 100; // Vl(Ret[RetNo].Frm[FNo].Strings[2]);

        T3Pens := T3Pens + Vl(Ret[RetNo].Frm[FNo].Strings[7]) * PercentShare *
          ExchRate / 100;
        T3itc := T3itc + Vl(Ret[RetNo].Frm[FNo].Strings[20]) * PercentShare *
          ExchRate / 100;;
        T3xii := T3xii + Vl(Ret[RetNo].Frm[FNo].Strings[19]) * PercentShare *
          ExchRate / 100;

        T3ElgblQSB3 := T3ElgblQSB3 + Vl(Ret[RetNo].Frm[FNo].Strings[25]) *
          PercentShare * ExchRate / 100;
        T3ElgblQFP3 := T3ElgblQFP3 + Vl(Ret[RetNo].Frm[FNo].Strings[24]) *
          PercentShare * ExchRate / 100;
        T3ElgblOTH3 := T3ElgblOTH3 + Vl(Ret[RetNo].Frm[FNo].Strings[11]) *
          PercentShare * ExchRate / 100 - T3ElgblQSB3 - T3ElgblQFP3;

        T3FCapGains := T3FCapGains + Vl(Ret[RetNo].Frm[FNo].Strings[22]) *
          PercentShare * ExchRate / 100;

        // box 21 minus box 30 - box 37
        T3NonElgblGains3 := T3NonElgblGains3 +
          (Vl(Ret[RetNo].Frm[FNo].Strings[6]) -
          Vl(Ret[RetNo].Frm[FNo].Strings[11]) -
          Vl(Ret[RetNo].Frm[FNo].Strings[16])) * PercentShare * ExchRate / 100;
        T3Dividends := T3Dividends + Vl(Ret[RetNo].Frm[FNo].Strings[13]) *
          PercentShare * ExchRate / 100;
        T3DividendsEligible := T3DividendsEligible +
          Vl(Ret[RetNo].Frm[FNo].Strings[26]) * PercentShare * ExchRate / 100;
        T3FarmElgbl := T3FarmElgbl + Vl(Ret[RetNo].Frm[FNo].Strings[23]) *
          PercentShare * ExchRate / 100;
        T3QFPElgbl := T3QFPElgbl + Vl(Ret[RetNo].Frm[FNo].Strings[27]) *
          PercentShare * ExchRate / 100;
        T3OthElgbl := T3OthElgbl + Vl(Ret[RetNo].Frm[FNo].Strings[28]) *
          PercentShare * ExchRate / 100;
        T3OthInc := T3OthInc + (Vl(Ret[RetNo].Frm[FNo].Strings[10]) -
          Vl(Ret[RetNo].Frm[FNo].Strings[27]) -
          Vl(Ret[RetNo].Frm[FNo].Strings[28])) * PercentShare * ExchRate / 100;
        ForeignCountry := 1;
        If (Ret[RetNo].Frm[FNo].Strings[5] > '') and
          (Numeric(Ret[RetNo].Frm[FNo].Strings[5])) then
          ForeignCountry := StrToInt(Ret[RetNo].Frm[FNo].Strings[5]);
        Case ForeignCountry of
          1:
            begin
              T3FNonBusInc1 := T3FNonBusInc1 + Vl(Ret[RetNo].Frm[FNo].Strings[9]
                ) * PercentShare * ExchRate / 100;
              T3FNonBusTax1 := T3FNonBusTax1 +
                Vl(Ret[RetNo].Frm[FNo].Strings[15]) * PercentShare *
                ExchRate / 100;
              T3FBusInc1 := T3FBusInc1 + Vl(Ret[RetNo].Frm[FNo].Strings[8]) *
                PercentShare * ExchRate / 100;
              T3FBusTax1 := T3FBusTax1 + Vl(Ret[RetNo].Frm[FNo].Strings[14]) *
                PercentShare * ExchRate / 100;
            end;
          2:
            begin
              T3FNonBusInc2 := T3FNonBusInc2 + Vl(Ret[RetNo].Frm[FNo].Strings[9]
                ) * PercentShare * ExchRate / 100;
              T3FNonBusTax2 := T3FNonBusTax2 +
                Vl(Ret[RetNo].Frm[FNo].Strings[15]) * PercentShare *
                ExchRate / 100;
              T3FBusInc2 := T3FBusInc2 + Vl(Ret[RetNo].Frm[FNo].Strings[8]) *
                PercentShare * ExchRate / 100;
              T3FBusTax2 := T3FBusTax2 + Vl(Ret[RetNo].Frm[FNo].Strings[14]) *
                PercentShare * ExchRate / 100;
            end;
          3:
            begin
              T3FNonBusInc3 := T3FNonBusInc3 + Vl(Ret[RetNo].Frm[FNo].Strings[9]
                ) * PercentShare * ExchRate / 100;
              T3FNonBusTax3 := T3FNonBusTax3 +
                Vl(Ret[RetNo].Frm[FNo].Strings[15]) * PercentShare *
                ExchRate / 100;
              T3FBusInc3 := T3FBusInc3 + Vl(Ret[RetNo].Frm[FNo].Strings[8]) *
                PercentShare * ExchRate / 100;
              T3FBusTax3 := T3FBusTax3 + Vl(Ret[RetNo].Frm[FNo].Strings[14]) *
                PercentShare * ExchRate / 100;
            end;
        end; { case }
      end;
    end;
  end;
end;

//20211210
Procedure T4APIncomeProcess(RetNo: Integer; Var T4APOthInc: Real;Var T4APIncTax: Real);
Var i,FNo:integer;
Begin
 T4ApOthInc:=0;
 T4ApIncTax:=0;
 for I := 0 to (FList.Count - 1) do
 begin
    FRec := FList.Items[I];
    if FRec.FormName = 'T4AP' then
    begin
      FNo := FRec.FormNo;
      If (Ret[RetNo].FrmHasData[FNo]) and (Ret[RetNo].Frm[FNo].Count > 0) then
      begin
       T4ApOthInc:=T4APOthInc+Vl(FetchElm(RetNo,FNo,4));
       T4ApIncTax:=T4APIncTax+Vl(FetchElm(RetNo,FNo,7));
      end;
    end;
 end;
end;

Procedure T5IncomeProcess(RetNo: Integer; Var T5Interest: Real;
  Var T5FInterest: Real; Var T5Pens: Real; Var T5Royalty: Real;
  Var T5NonElgblGains: Real; Var T5Dividends: Real;
  Var T5DividendsEligible: Real; Var T5FNonBusInc1: Real;
  Var T5FNonBusInc2: Real; Var T5FNonBusInc3: Real; Var T5FNonBusTax1: Real;
  Var T5FNonBusTax2: Real; Var T5FNonBusTax3: Real);
Var
  I, k, FNo, ForeignCountry: Integer;
  ExchRate, PercentShare: Real;
begin

  T5Interest := 0;
  T5FInterest := 0;
  T5Pens := 0;
  T5Royalty := 0;
  T5NonElgblGains := 0;
  T5Dividends := 0;
  T5DividendsEligible := 0;
  T5FNonBusInc1 := 0;
  T5FNonBusInc2 := 0;
  T5FNonBusInc3 := 0;
  T5FNonBusTax1 := 0;
  T5FNonBusTax2 := 0;
  T5FNonBusTax3 := 0;

  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    if FRec.FormName = 'T5INCOME' then
    begin
      FNo := FRec.FormNo;
      If (Ret[RetNo].FrmHasData[FNo]) and (Ret[RetNo].Frm[FNo].Count > 0) then
      begin
        For k := 0 to 4 do
        begin
          ExchRate := 1;
          If Vl(Ret[RetNo].Frm[FNo].Strings[4 + k * 22]) > 0 then
            ExchRate := Vl(Ret[RetNo].Frm[FNo].Strings[4 + k * 22]);
          PercentShare := 100; // 0;
          // If Vl(Ret[RetNo].Frm[FNo].Strings[2+k*22])>0 then PercentShare := Vl(Ret[RetNo].Frm[FNo].Strings[2+k*22]);
          T5Interest := T5Interest +
            (Vl(Ret[RetNo].Frm[FNo].Strings[7 + k * 22]) +
            Vl(Ret[RetNo].Frm[FNo].Strings[8 + k * 22]) +
            Vl(Ret[RetNo].Frm[FNo].Strings[13 + k * 22])) * PercentShare *
            ExchRate / 100;
          // If Ret[RetNo].Frm[FNo].Strings[5+k*22]>'' then  //NO foreign indicator
          T5FInterest := T5FInterest +
            (Vl(Ret[RetNo].Frm[FNo].Strings[9 + k * 22])) * PercentShare *
            ExchRate / 100;

          T5Pens := T5Pens + Vl(Ret[RetNo].Frm[FNo].Strings[13 + k * 22]) *
            PercentShare * ExchRate / 100;
          T5Royalty := T5Royalty + Vl(Ret[RetNo].Frm[FNo].Strings[11 + k * 22])
            * PercentShare * ExchRate / 100;
          T5NonElgblGains := T5NonElgblGains +
            (Vl(Ret[RetNo].Frm[FNo].Strings[12 + k * 22])) * PercentShare *
            ExchRate / 100;
          T5Dividends := Ret[RetNo].T5Dividends +
            Vl(Ret[RetNo].Frm[FNo].Strings[6 + k * 22]) * PercentShare *
            ExchRate / 100;
          T5DividendsEligible := Ret[RetNo].T5DividendsEligible +
            Vl(Ret[RetNo].Frm[FNo].Strings[141 + k]) * PercentShare *
            ExchRate / 100;

          ForeignCountry := 1;
          If (Ret[RetNo].Frm[FNo].Strings[5 + k * 22] > '') and
            (Numeric(Ret[RetNo].Frm[FNo].Strings[5 + k * 22])) then
            ForeignCountry := StrToInt(Ret[RetNo].Frm[FNo].Strings[5 + k * 22]);
          Case ForeignCountry of
            1:
              begin
                T5FNonBusInc1 := T5FNonBusInc1 +
                  Vl(Ret[RetNo].Frm[FNo].Strings[9 + k * 22]) * PercentShare *
                  ExchRate / 100;
                T5FNonBusTax1 := T5FNonBusTax1 +
                  Vl(Ret[RetNo].Frm[FNo].Strings[10 + k * 22]) * PercentShare *
                  ExchRate / 100;
              end;
            2:
              begin
                T5FNonBusInc2 := T5FNonBusInc2 +
                  Vl(Ret[RetNo].Frm[FNo].Strings[9 + k * 22]) * PercentShare *
                  ExchRate / 100;
                T5FNonBusTax2 := T5FNonBusTax2 +
                  Vl(Ret[RetNo].Frm[FNo].Strings[10 + k * 22]) * PercentShare *
                  ExchRate / 100;
              end;
            3:
              begin
                T5FNonBusInc3 := T5FNonBusInc3 +
                  Vl(Ret[RetNo].Frm[FNo].Strings[9 + k * 22]) * PercentShare *
                  ExchRate / 100;
                T5FNonBusTax3 := T5FNonBusTax3 +
                  Vl(Ret[RetNo].Frm[FNo].Strings[10 + k * 22]) * PercentShare *
                  ExchRate / 100;
              end;
          end; { case }
        end; // k
      end; // has data
    end;
  end;

end;


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

    If (FName = 'ALL') or (LeftStr(FName, 4) = 'T4AP') then
    begin
      T4ApIncomeProcess(RetNo, T4APOthInc,T4APIncTax);
    end;

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

Procedure GetListOfStatementsForAutos(RetNo: Integer; AList: TStrings);
Var
  I: Integer;
Begin
  AList.clear;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If Ret[RetNo].FrmHasData[FRec.FormNo] then
    begin
      if (LeftStr(FRec.FormName, 5) = 'T2125') then
      begin
        If FRec.FormInst = '#1' then
          AList.Add(paddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst,
            13) + FetchElmFNo(RetNo, FRec.FormNo, 8))
        Else If Ret[RetNo].FrmHasData[FRec.FormNo] then
          AList.Add(paddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst,
            13) + FetchElmFNo(RetNo, FRec.FormNo, 8))
      end

      Else if (LeftStr(FRec.FormName, 7) = 'T2121') then
      begin
        If FRec.FormInst = '#1' then
          AList.Add(paddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst,
            13) + FetchElmFNo(RetNo, FRec.FormNo, 61))
        Else If Ret[RetNo].FrmHasData[FRec.FormNo] then
          AList.Add(paddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst,
            13) + FetchElmFNo(RetNo, FRec.FormNo, 8))
      end

      Else if (LeftStr(FRec.FormName, 5) = 'T2042') then
      begin
        If FRec.FormInst = '#1' then
          AList.Add(paddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst,
            13) + FetchElmFNo(RetNo, FRec.FormNo, 8))
        Else If Ret[RetNo].FrmHasData[FRec.FormNo] then
          AList.Add(paddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst,
            13) + FetchElmFNo(RetNo, FRec.FormNo, 8))
      end

      Else if (LeftStr(FRec.FormName, 7) = 'T1163_1') then
      begin
        If FRec.FormInst = '#1' then
          AList.Add(paddR(ExtractFormRootName(FRec.FormName) +
            FRec.FormInst, 13))
        Else If Ret[RetNo].FrmHasData[FRec.FormNo] then
          AList.Add(paddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst,
            13) + FetchElmFNo(RetNo, FRec.FormNo, 8))
      end

      Else if (LeftStr(FRec.FormName, 7) = 'T1273_1') then
      begin
        If FRec.FormInst = '#1' then
          AList.Add(paddR(ExtractFormRootName(FRec.FormName) +
            FRec.FormInst, 13))
        Else If Ret[RetNo].FrmHasData[FRec.FormNo] then
          AList.Add(paddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst,
            13) + FetchElmFNo(RetNo, FRec.FormNo, 8))
      end

      Else if (LeftStr(FRec.FormName, 6) = 'T776') then
      begin
        If FRec.FormInst = '#1' then
          AList.Add(paddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst,
            13) + FetchElmFNo(RetNo, FRec.FormNo, 45))
        Else If Ret[RetNo].FrmHasData[FRec.FormNo] then
          AList.Add(paddR(ExtractFormRootName(FRec.FormName) + FRec.FormInst,
            13) + FetchElmFNo(RetNo, FRec.FormNo, 45))
      end;
    end;
  end;
end;

Procedure ExtractCCA(RetNo: Integer; StmtId: String; StatementInst: String;
  Var TermLossAmount: Real; Var RecaptAmount: Real; Var CCAForStmt: Real);
Var
  I, j, k, FNo: Integer;
  StPercent: Real;
  ShortYearPercent: Real;
begin
  TermLossAmount := 0;
  RecaptAmount := 0;
  CCAForStmt := 0;
  StPercent := 0;
  InitExtractedCCAlist(RetNo);

  // 20100320
  StmtId := AllTrim(StmtId);
  StatementInst := AllTrim(StatementInst);
  // fill it up
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If ((FRec.FormName = 'ASSETSB') and
      (UpperCase(FetchElmFNo(RetNo, FRec.FormNo, 10)) = 'Y')) //iN asstsb prompt to post it //2028
    then
    begin
      FNo := FRec.FormNo;
      If ((AllTrim(FetchElmFNo(RetNo, FNo, 215)) = StmtId + StatementInst) and
        (Vl(FetchElmFNo(RetNo, FNo, 216)) > 0)) or
        ((AllTrim(FetchElmFNo(RetNo, FNo, 221)) = StmtId + StatementInst) and
        (Vl(FetchElmFNo(RetNo, FNo, 222)) > 0)) or
        ((AllTrim(FetchElmFNo(RetNo, FNo, 227)) = StmtId + StatementInst) and
        (Vl(FetchElmFNo(RetNo, FNo, 228)) > 0)) then
      begin
        ExtractedCCARec := TExtractedCCARec.create;
        With ExtractedCCARec do
        begin
          StatementId := StmtId;
          Description := FetchElmFNo(RetNo, FNo, 1);
          PersonalPercent := Vl(FetchElmFNo(RetNo, FNo, 4));
          j := 215;
          Repeat
            If AllTrim(FetchElmFNo(RetNo, FNo, j)) = StmtId + StatementInst then
            begin
              StatementPercent := Vl(FetchElmFNo(RetNo, FNo, j + 1));
              StPercent := StatementPercent;
              ShortYearPercent := (CalcBusDays(RetNo, FetchElmFNo(RetNo, FNo, j))
                / Constant[RY].FullYear) * 100;
              CCAClaimed := Vl(FetchElmFNo(RetNo, FNo, j + 3));
              CCAForStatement := Vl(FetchElmFNo(RetNo, FNo, j + 3));
              // may 26 2008
            end;
            inc(j, 6);
          until j > 227;

          ClassId := AllTrim(FetchElmFNo(RetNo, FNo, 134)); // 2010213 AllTrim
          DateAcquired := FetchElmFNo(RetNo, FNo, 137);
          Cost := Vl(FetchElmFNo(RetNo, FNo, 20));
          If Vl(FetchElmFNo(RetNo, FNo, 12)) > 0 then
            Cost := Vl(FetchElmFNo(RetNo, FNo, 12));
          UccStart := Vl(FetchElmFNo(RetNo, FNo, 191));
          Additions := Vl(FetchElmFNo(RetNo, FNo, 158));
          AdditionsPersonal := Vl(FetchElmFNo(RetNo, FNo, 8));
          //NOT here it is part of the extractNonvehile CCA and vtShared?
          //20191225 add AIIP
          AiiPAdditions:=Vl(FetchElmFNo(RetNo, FNo, 37));
          AiipProceeds:=Vl(FetchElmFNo(RetNo, FNo, 38));
          AiiPUccAdj:=Vl(FetchElmFNo(RetNo, FNo, 39));

          Proceeds := Vl(FetchElmFNo(RetNo, FNo, 15));
          ProceedsPersonal := Vl(FetchElmFNo(RetNo, FNo, 14));
          Adjustments := Vl(FetchElmFNo(RetNo, FNo, 164));
          AdjUcc := Vl(FetchElmFNo(RetNo, FNo, 29));
          BaseAmount := Vl(FetchElmFNo(RetNo, FNo, 167));
          Rate := Vl(FetchElmFNo(RetNo, FNo, 170));
          CCAForTheYear := Vl(FetchElmFNo(RetNo, FNo, 173))
            *(StPercent / 100);   //20180309
            // *(ShortYearPercent/100);
          UccEnd := Vl(FetchElmFNo(RetNo, FNo, 176));
          TerminalLossAmount := Vl(FetchElmFNo(RetNo, FNo, 16)) *
            (StPercent / 100);
          RecaptureAmount := Vl(FetchElmFNo(RetNo, FNo, 19)) *
            (StPercent / 100);
          ExtractedCCAList.Add(ExtractedCCARec);
          TermLossFlag := FetchElmFNo(RetNo, FNo, 6);
        end;
      end;
    end;
  end;
  // get recapt and termloss
  For I := 0 to ExtractedCCAList.Count - 1 do
  begin
    ExtractedCCARec := ExtractedCCAList.Items[I];
    TermLossAmount := TermLossAmount + ExtractedCCARec.TerminalLossAmount;
    RecaptAmount := RecaptAmount + ExtractedCCARec.RecaptureAmount;
    CCAForStmt := CCAForStmt + ExtractedCCARec.CCAForStatement;
  end;
end;

Function PostCCAFromAssetsB(RetNo: Integer): Boolean;
begin
  result := False;
  If (UpperCase(FetchElm(RetNo, 'ASSETSB#1', 10)) = 'Y')  //firstr instance only
  then
    result := True;
end;
//20191225
Procedure PostNonVehicleCCA(RetNo: Integer; FName: String; Stmt: String;
  FInst: String; FNo: Integer; StartNdx, EndNdx, IncrBy, EndSectionNdx,
  RemainingNdx, TotalNdx: Integer);
Var
  i, j, kRent, KT2125, KT2121, KT1163: Integer;
  RemainingAmount: Real;
  TermLossAmount, RecaptAmount: Real;
  KTermLoss, KRecapture: Integer;
  CCAForStmt: Real;
  Aii: Integer; // Index for AiiP
  T1175FNo, T1175FInst: Integer;
  Col1, Col3, Col5,Col7, col9, col10, Col11,col12,col13, col14:Integer;
  AiipFactor:real;
begin
  with Ret[RetNo].Frm[FNo] do
  begin
    TermLossAmount := 0;
    RecaptAmount := 0;
    CCAForStmt := 0;

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

    //20230226
    If LeftStr(Fname,6)='T2125#' then
    begin
     Col1:=301;
     Col3:=303;
     Col5:=304;
     Col7:=551;
     Col9:=523;
     Col10:=575;
     Col11:=189;
     Col12:=583;
     Col13:=112;
     Col14:=120;
    end
    Else if LeftStr(Fname,6)='T2042#' then
    Begin
     Col1:=401;
     Col3:=403;
     Col5:=404;
     Col7:=158;
     Col9:=361;
     Col10:=369;
     Col11:=93;
     Col12:=378;
     Col13:=166;
     Col14:=174;
    end
    Else if LeftStr(Fname,6)='T2121#' then
    begin
     Col1:=137;
     Col3:=139;
     Col5:=140;
     Col7:=90;
     Col9:=484;
     Col10:=492;
     Col11:=285;
     Col12:=523;
     Col13:=293;
     Col14:=435;
    end

    Else if LeftStr(Fname,5)='T776#' then
    Begin
     Col1:=201;
     Col3:=203;
     Col5:=204;
     Col7:=146;
     Col9:=191;
     Col10:=196;
     Col11:=153;
     Col12:=383;
     Col13:=158;
     Col14:=163;
    end;


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
        // 20130408 ????????? 381
      else
      begin
        StoreElm(RetNo, FNo, j, ExtractedCCARec.ClassId);
        Tv[j + 1] := ExtractedCCARec.UccStart;
        Tv[j + 2] := ExtractedCCARec.Additions;
        Tv[j + 3] := MaxR(0, ExtractedCCARec.Proceeds -
          ExtractedCCARec.ProceedsPersonal);
        Tv[j + 4] := ExtractedCCARec.Adjustments;
        Tv[j + 5] := ExtractedCCARec.BaseAmount;
        StoreElm(RetNo, FNo, j + 6, FormatFloat('###.##', ExtractedCCARec.Rate));
        Tv[j + 7] := ExtractedCCARec.CCAForTheYear;
        // ExtractedCCARec.CCAClaimed;  //Feb 29 2008
        Tv[j + 8] := ExtractedCCARec.UCCEnd;
        // 20190202 Post Aii

        //20230226
        Tv[Col10]:=MaxR(0,Tv[Col3]-Tv[Col9]);
        //Tv[col11]:=MaxR(0,
        Tv[Col12]:=MaxR(0,Tv[Col7]-Tv[Col9]);
        Tv[Col13]:=MaxR(0,Tv[Col5]-Tv[Col10]+Tv[11]);
        AiipFactor:=GetAiipFactor(ExtractedCCARec.ClassId);
        Tv[Col14]:=MaxR(0,(Tv[Col11]-Tv[Col14])* AiipFactor);


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

          //20230226
        Inc(col1,10);
        Inc(col3,10);
        If (LeftStr(Stmt, 5) = 'T776#') then
        begin
         Inc(col1,9);
         Inc(col3,9);
        end;

        Inc(col7,1);
        Inc(col9,1);
        Inc(col10,1);
        Inc(col11,1);
        Inc(col12,1);
        Inc(col13,1);
        Inc(col14,1);
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

(* //20191225
Procedure PostNonVehicleCCA(RetNo: Integer; FName: String; Stmt: String;
  FInst: String; FNo: Integer; StartNdx, EndNdx, IncrBY, EndSectionNdx,
  RemainingNdx, TotalNdx: Integer);
Var
  I, j, kRent, KT2125, KT2121: Integer;
  RemainingAmount: Real;
  TermLossAmount, RecaptAmount: Real;
  KTermLoss, KRecapture: Integer;
  CCAForStmt: Real;
begin
  TermLossAmount := 0;
  RecaptAmount := 0;
  CCAForStmt := 0;

  ExtractCCA(RetNo, Stmt, FInst, TermLossAmount, RecaptAmount, CCAForStmt);
  For I := StartNdx to EndSectionNdx do
  begin
    Tv[I] := 0;
    StoreElm(RetNo, FNo, I, '');
  end; // clear section
  Tv[RemainingNdx] := 0; // suppl clear
  Tv[TotalNdx] := 0;
  RemainingAmount := 0;
  j := StartNdx;
  kRent := 159; // for t776  so it starts from 160
  KT2125 := 0; // 10-10
  KT2121 := 36;
  For I := 0 to ExtractedCCAList.Count - 1 do
  begin
    kRent := kRent + 1;
    KT2125 := KT2125 + 10;
    KT2121 := KT2121 + 10;
    ExtractedCCARec := ExtractedCCAList.Items[I];
    TermLossAmount := TermLossAmount + ExtractedCCARec.TerminalLossAmount;
    RecaptAmount := RecaptAmount + ExtractedCCARec.RecaptureAmount;
    If j > EndNdx then
      RemainingAmount := RemainingAmount + ExtractedCCARec.CCAClaimed
    else
    begin
      StoreElm(RetNo, FNo, j, ExtractedCCARec.ClassId);
      Tv[j + 1] := ExtractedCCARec.UccStart;
      Tv[j + 2] := ExtractedCCARec.Additions;
      Tv[j + 3] := MaxR(0, ExtractedCCARec.Proceeds -
        ExtractedCCARec.ProceedsPersonal);
      Tv[j + 4] := ExtractedCCARec.Adjustments;
      Tv[j + 5] := ExtractedCCARec.BaseAmount;
      StoreElm(RetNo, FNo, j + 6, FormatFloat('###.##', ExtractedCCARec.Rate));
      Tv[j + 7] := ExtractedCCARec.CCAForTheYear;
      // ExtractedCCARec.CCAClaimed;  //Feb 29 2008
      Tv[j + 8] := ExtractedCCARec.UccEnd;
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
      inc(j, IncrBY);
    end;
  end;
  // store term loss and recapture amounts
  If LeftStr(Stmt, 4) = 'T776' then
  begin
    StoreElm(RetNo, FNo, 159, FormatFloat('########.##', TermLossAmount));
    StoreElm(RetNo, FNo, 183, FormatFloat('########.##', RecaptAmount));
  end;
  If (LeftStr(Stmt, 5) = 'T2125')
  // or (LeftStr(Stmt,5)='T2032')
  then
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
*)

Procedure PostNonBuildingAdditions(RetNo: Integer; FName: String; Stmt: String;
  FInst: String; FNo: Integer; StartNdx, EndNdx, IncrBY, EndSectionNdx,
  RemainingNdx, TotalNdx: Integer);
Var
  I, j: Integer;
  RemainingAmount: Real;
  TermLossAmount, RecaptAmount: Real;
  CCAForStatement: Real;
begin
  with Ret[RetNo].Frm[FNo] do
  begin
    ExtractCCA(RetNo, Stmt, FInst, TermLossAmount, RecaptAmount, CCAForStatement);
    For I := StartNdx to EndSectionNdx do
    begin
      Tv[I] := 0;
      StoreElm(RetNo, FNo, I, '');
    end; // clear section
    RemainingAmount := 0;
    Tv[RemainingNdx] := 0;
    j := StartNdx;
    For I := 0 to ExtractedCCAList.Count - 1 do
    begin
      ExtractedCCARec := ExtractedCCAList.Items[I];
      If IsBuildingClass(ExtractedCCARec.ClassId) = False then
      Begin
        If ExtractedCCARec.Additions > 0 then
        begin
          If j > EndNdx then
            RemainingAmount := MaxR(0, RemainingAmount + ExtractedCCARec.Cost -
              ExtractedCCARec.AdditionsPersonal)
          else
          begin
            StoreElm(RetNo, FNo, j, ExtractedCCARec.ClassId);
            StoreElm(RetNo, FNo, j + 1, ExtractedCCARec.Description);
            Tv[j + 2] := ExtractedCCARec.Cost;
            Tv[j + 3] := ExtractedCCARec.AdditionsPersonal;
            Tv[146] := Tv[146] + Tv[j + 3];
            inc(j, IncrBY);
          end;
        end;
      end;
    end;
    Tv[RemainingNdx] := RemainingAmount;
  end;
end;

Procedure PostBuildingAdditions(RetNo: Integer; FName: String; Stmt: String;
  FInst: String; FNo: Integer; StartNdx, EndNdx, IncrBY, EndSectionNdx,
  RemainingNdx, TotalNdx: Integer);
Var
  I, j: Integer;
  RemainingAmount: Real;
  TermLossAmount, RecaptAmount: Real;
  CCAForStatement: Real;
begin
  with Ret[RetNo].Frm[FNo] do
  begin
    ExtractCCA(RetNo, Stmt, FInst, TermLossAmount, RecaptAmount, CCAForStatement);
    For I := StartNdx to EndSectionNdx do
    begin
      Tv[I] := 0;
      StoreElm(RetNo, FNo, I, '');
    end; // clear section
    RemainingAmount := 0;
    Tv[RemainingNdx] := 0;
    j := StartNdx;
    For I := 0 to ExtractedCCAList.Count - 1 do
    begin
      ExtractedCCARec := ExtractedCCAList.Items[I];
      If IsBuildingClass(ExtractedCCARec.ClassId) = True then
      Begin
        If ExtractedCCARec.Additions > 0 then
        begin
          If j > EndNdx then
            RemainingAmount := MaxR(0, RemainingAmount + ExtractedCCARec.Cost -
              ExtractedCCARec.AdditionsPersonal)
          else
          begin
            StoreElm(RetNo, FNo, j, ExtractedCCARec.ClassId);
            StoreElm(RetNo, FNo, j + 1, ExtractedCCARec.Description);
            Tv[j + 2] := ExtractedCCARec.Cost;
            Tv[j + 3] := ExtractedCCARec.AdditionsPersonal;
            Tv[j + 4] := MaxR(0, Tv[j + 2] - Tv[j + 3]);
            inc(j, IncrBY);
          end;
        end;
      end;
    end;
    Tv[RemainingNdx] := RemainingAmount;
  end;
end;

Procedure PostNonBuildingDispositions(RetNo: Integer; FName: String;
  Stmt: String; FInst: String; FNo: Integer;
  StartNdx, EndNdx, IncrBY, EndSectionNdx, RemainingNdx, TotalNdx: Integer);
Var
  I, j: Integer;
  RemainingAmount: Real;
  TermLossAmount, RecaptAmount: Real;
  CCAForStatement: Real;
Begin
  with Ret[RetNo].Frm[FNo] do
  begin
    ExtractCCA(RetNo, Stmt, FInst, TermLossAmount, RecaptAmount, CCAForStatement);
    For I := StartNdx to EndSectionNdx do
    begin
      Tv[I] := 0;
      StoreElm(RetNo, FNo, I, '');
    end; // clear section
    RemainingAmount := 0;
    Tv[RemainingNdx] := 0;
    j := StartNdx;
    For I := 0 to ExtractedCCAList.Count - 1 do
    begin
      ExtractedCCARec := ExtractedCCAList.Items[I];
      If IsBuildingClass(ExtractedCCARec.ClassId) = False then
      begin
        If ExtractedCCARec.Proceeds > 0 then
        begin
          If j > EndNdx then
            RemainingAmount := MaxR(0, RemainingAmount + ExtractedCCARec.Proceeds
              - ExtractedCCARec.ProceedsPersonal)
          else
          begin
            StoreElm(RetNo, FNo, j, ExtractedCCARec.ClassId);
            StoreElm(RetNo, FNo, j + 1, ExtractedCCARec.Description);
            Tv[j + 2] := ExtractedCCARec.Proceeds;
            Tv[j + 3] := ExtractedCCARec.ProceedsPersonal;
            Tv[j + 4] := MaxR(0, Tv[j + 2] - Tv[j + 3]);
            inc(j, IncrBY);
          end;
        end;
      end;
    end;
    Tv[RemainingNdx] := RemainingAmount;
  end;
end;

Procedure PostBuildingDispositions(RetNo: Integer; FName: String; Stmt: String;
  FInst: String; FNo: Integer; StartNdx, EndNdx, IncrBY, EndSectionNdx,
  RemainingNdx, TotalNdx: Integer);
Var
  I, j: Integer;
  RemainingAmount: Real;
  TermLossAmount, RecaptAmount: Real;
  CCAForStatement: Real;
begin
  with Ret[RetNo].Frm[FNo] do
  begin
    ExtractCCA(RetNo, Stmt, FInst, TermLossAmount, RecaptAmount, CCAForStatement);
    For I := StartNdx to EndSectionNdx do
    begin
      Tv[I] := 0;
      StoreElm(RetNo, FNo, I, '');
    end; // clear section
    RemainingAmount := 0;
    Tv[RemainingNdx] := 0;
    j := StartNdx;
    For I := 0 to ExtractedCCAList.Count - 1 do
    begin
      ExtractedCCARec := ExtractedCCAList.Items[I];
      If IsBuildingClass(ExtractedCCARec.ClassId) = True then
      begin
        If ExtractedCCARec.Proceeds > 0 then
        begin
          If j > EndNdx then
            RemainingAmount := MaxR(0, RemainingAmount + ExtractedCCARec.Proceeds
              - ExtractedCCARec.ProceedsPersonal)
          else
          begin
            StoreElm(RetNo, FNo, j, ExtractedCCARec.ClassId);
            StoreElm(RetNo, FNo, j + 1, ExtractedCCARec.Description);
            Tv[j + 2] := ExtractedCCARec.Proceeds;
            Tv[j + 3] := ExtractedCCARec.ProceedsPersonal;
            inc(j, IncrBY);
          end;
        end;
      end;
    end; // i
    Tv[RemainingNdx] := RemainingAmount;
  end;
end;

Procedure InitExtractedAutolist(RetNo: Integer);
Begin
  ExtractedAutoList.free; // Clear;
  ExtractedAutoList := TExtractedAutoList.create;
end;

Procedure InitExtractedCCAlist(RetNo: Integer);
Begin
  ExtractedCCAList.free; // Clear;
  ExtractedCCAList := TExtractedCCAList.create;
end;

Procedure RecalcBusStatements(RetNo: Integer); // StmList:TStringList);   //j???
// due to autos
Var
  I, FNo: Integer;
  FInst: String;
begin
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    FNo := FRec.FormNo;
    If Ret[RetNo].FrmHasData[FNo] then
    begin
      If (FRec.FormName = 'T2125') or (FRec.FormName = 'T776') or
        (FRec.FormName = 'T2121') or (FRec.FormName = 'T2042') then
      begin
        FInst := FRec.FormInst;

        If FRec.FormName = 'T2125' then // j???
        begin
          T2125(RetNo, 'T2125' + FInst, GetFormNo('T2125' + FInst));
        end;
        If FRec.FormName = 'T776' then
        begin
          T776(RetNo, 'T776' + FInst, GetFormNo('T776' + FInst));
        end;

        //20180319
        If FRec.FormName = 'T2121' then // j???
        begin
         T2121(RetNo, Frec.FormName + FInst, GetFormNo(Frec.FormName + FInst));
        end;

        If FRec.FormName = 'T2042' then // j???
        begin
         T2042(RetNo, Frec.FormName + FInst, GetFormNo(Frec.FormName + FInst));
        end;
      end; // any specific stmt
    end; // has data
  end; // i
end;

Function CalcBusDays(RetNo: Integer; Stmt: String): Integer;
Var
  D1, D2, FInst: String;
begin
  //20180309
  result := 365;
  If IsLeapYear(AppYearInt) then result := 366;
  FInst := ExtractFormInst(Stmt);
  Stmt := LeftStr(Stmt, 5);
  With Ret[RetNo] do
  begin
    If Stmt = 'T2125' then
    begin
     D1 := FetchElm(RetNo, ExtractNonInstFormName(Stmt)+ FInst, 4);
     D2 := FetchElm(RetNo, ExtractNonInstFormName(Stmt)+ FInst, 5);
     //D1 := FetchElm(RetNo, Stmt + '_1' + FInst, 4);
     //D2 := FetchElm(RetNo, Stmt + '_1' + FInst, 5);
    end
    Else If Stmt = 'T2121' then
    begin
      D1 := FetchElm(RetNo, ExtractNonInstFormName(Stmt)+ FInst, 4);
      D2 := FetchElm(RetNo, ExtractNonInstFormName(Stmt)+ FInst, 5);
    end
    Else If Stmt = 'T2042' then
    begin
     D1 := FetchElm(RetNo, ExtractNonInstFormName(Stmt)+ FInst, 4);
     D2 := FetchElm(RetNo, ExtractNonInstFormName(Stmt)+ FInst, 5);
    end
    Else If Stmt = 'T1163' then
    begin
      D1 := FetchElm(RetNo, ExtractNonInstFormName(Stmt)+ FInst, 13);
      D2 := FetchElm(RetNo, ExtractNonInstFormName(Stmt)+ FInst, 14);
    end
    Else If Stmt = 'T1273' then
    begin
      D1 := FetchElm(RetNo, ExtractNonInstFormName(Stmt)+ FInst, 13);
      D2 := FetchElm(RetNo, ExtractNonInstFormName(Stmt)+ FInst, 14);
    end
    Else If LeftStr(Stmt, 4) = 'T776' then // 20110409
    begin
      //20180309
      D1 := FetchElm(RetNo, ExtractNonInstFormName(Stmt)+ FInst, 3);
      D2 := FetchElm(RetNo, ExtractNonInstFormName(Stmt)+ FInst, 6);
    end;

    If Length(D1) <> 10 then
      D1 := Appyear + '-01-01';
    If Length(D2) <> 10 then
      D2 := Appyear + '-12-31';
    result := DateDiffYMD(D1, D2); // + 1; //20180309
    If result < 0 then result := 0;
   //20180309
    If result > 365 then
    Begin
      result := 365;  //20180308
      If IsLeapYear(AppYearInt) then result := 366;
    end;
  end;
end;

Function IsBuildingClass(CcaClass: String): Boolean;
begin
  result := False;
  If (CcaClass = '1') or (CcaClass = '3') or (CcaClass = '6') then
    result := True;
end;

Function YYYY_MM_DDToMMDDYYYY(InputDate: String): string;
{ input date in form yyyy-mm-dd, output as mm/dd/yyyy }
begin
  result := '';
  If InputDate = '' then
    exit;
  result := MidStr(InputDate, 6, 2) + '/' + RightStr(InputDate, 2) + '/' +
    LeftStr(InputDate, 4);
end;

Procedure ExtractAutos(RetNo: Integer; StmtId: String; StatementInst: String;
  Var TermLossAmount: Real; Var RecaptAmount: Real; Var AutoCCAForStmt: Real);
Var
  I, j, k, FNo: Integer;
  MilesPercent, StPercent: Real;
  ShortYearPercent: Real;
begin
  InitExtractedAutolist(RetNo);
  StPercent := 0;
  TermLossAmount := 0;
  RecaptAmount := 0;
  AutoCCAForStmt := 0;
  MilesPercent := 0;

  // fill it up
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = 'AUTOS' then
    begin
      FNo := FRec.FormNo;
      If ((FetchElmFNo(RetNo, FNo, 215) = StmtId + StatementInst) and
        (Vl(FetchElmFNo(RetNo, FNo, 216)) > 0)) or
        ((FetchElmFNo(RetNo, FNo, 221) = StmtId + StatementInst) and
        (Vl(FetchElmFNo(RetNo, FNo, 222)) > 0)) or
        ((FetchElmFNo(RetNo, FNo, 227) = StmtId + StatementInst) and
        (Vl(FetchElmFNo(RetNo, FNo, 228)) > 0)) then
      begin
        ExtractedAutoRec := TExtractedAutoRec.create;
        With ExtractedAutoRec do
        begin
          StatementId := StmtId;
          Description := FetchElmFNo(RetNo, FNo, 1);
          KmDrove := MyStrToInt(FetchElmFNo(RetNo, FNo, 4));
          KmTotal := MyStrToInt(FetchElmFNo(RetNo, FNo, 7));
          // 20090120
          If KmTotal > 0 then
            KmPercent := (KmDrove / KmTotal) * 100
          else
            KmPercent := 0;
          j := 215;
          Repeat
            If FetchElmFNo(RetNo, FNo, j) = StmtId + StatementInst then
            begin
              StatementPercent := Vl(FetchElmFNo(RetNo, FNo, j + 1));
              StPercent := StatementPercent;
              MilesPercent := KmPercent;
              ShortYearPercent := (CalcBusDays(RetNo, FetchElmFNo(RetNo, FNo, j)
                ) / Constant[RY].FullYear) * 100;
              PartnerFlag := FetchElmFNo(RetNo, FNo, j + 5);
              ExpensesClaimed := Vl(FetchElmFNo(RetNo, FNo, j + 2));
              CCAClaimed := Vl(FetchElmFNo(RetNo, FNo, j + 3));
              AutoCCAForStatement := Vl(FetchElmFNo(RetNo, FNo, j + 3));
              // may 26 2008
            end;
            inc(j, 6);
          until j > 227;

          ClassId := FetchElmFNo(RetNo, FNo, 134);
          DateAcquired := FetchElmFNo(RetNo, FNo, 137);
          Cost := Vl(FetchElmFNo(RetNo, FNo, 20));
          If Vl(FetchElmFNo(RetNo, FNo, 149)) > 0 then
            Cost := Vl(FetchElmFNo(RetNo, FNo, 158));
          // Cost:=Vl(FetchElmFNo(RetNo,FNo,149));
          UccStart := Vl(FetchElmFNo(RetNo, FNo, 191));
          Additions := Vl(FetchElmFNo(RetNo, FNo, 158));

          //20191225 add AIIP
          AiiPAdditions:=Vl(FetchElmFNo(RetNo, FNo, 26));
          AiipProceeds:=Vl(FetchElmFNo(RetNo, FNo, 27));
          AiiPUccAdj:=Vl(FetchElmFNo(RetNo, FNo, 30));

          AdditionsPersonal := Vl(FetchElmFNo(RetNo, FNo, 8));
          Proceeds := Vl(FetchElmFNo(RetNo, FNo, 15));
          ProceedsPersonal := Vl(FetchElmFNo(RetNo, FNo, 14));
          Adjustments := Vl(FetchElmFNo(RetNo, FNo, 164));
          BaseAmount := Vl(FetchElmFNo(RetNo, FNo, 167));
          Rate := Vl(FetchElmFNo(RetNo, FNo, 170));
          CCAForTheYear := Vl(FetchElmFNo(RetNo, FNo, 173));
          // * (ShortYearPercent/100);
          UccEnd := Vl(FetchElmFNo(RetNo, FNo, 176));

          // AutoCCAForStatement :=Vl(FetchElmFNo(RetNo,FNo,173)) * (StPercent/100) * (MilesPercent/100); May 26 2008
          // * (ShortYearPercent/100);  May 15 2008
          // May 15 2008
          TerminalLossAmount := Vl(FetchElmFNo(RetNo, FNo, 21)) *
            (StPercent / 100) * (MilesPercent / 100);
          RecaptureAmount := Vl(FetchElmFNo(RetNo, FNo, 12)) * (StPercent / 100)
            * (MilesPercent / 100);
          // TerminalLossAmount:=Vl(FetchElmFNo(RetNo,FNo,21))* (StPercent/100);
          // RecaptureAmount:=Vl(FetchElmFNo(RetNo,FNo,12)) * (StPercent/100);
          ExtractedAutoList.Add(ExtractedAutoRec);
        end;
      end;
    end;
  end;
  // get recapt and termloss
  For I := 0 to ExtractedAutoList.Count - 1 do
  begin
    ExtractedAutoRec := ExtractedAutoList.Items[I];
    TermLossAmount := TermLossAmount + ExtractedAutoRec.TerminalLossAmount;
    RecaptAmount := RecaptAmount + ExtractedAutoRec.RecaptureAmount;
    AutoCCAForStmt := AutoCCAForStmt + ExtractedAutoRec.AutoCCAForStatement;
  end;
end;

Procedure FillSelfAutoExpRec(RetNo: Integer; Stmt: String);
Var
  I, j, FNo: Integer;
  NumCarsUsed: Integer;
  UsagePercent: Real;
  StmtPg1: String;
begin
  StmtPg1 := ExtractNonInstFormName(Stmt) + '_1' + ExtractFormInst(Stmt);
  With SelfAutoExpRec do
  begin
    NumOfCars := 0;
    For I := 1 to 6 do
    begin
      Descr[I] := '';
      KmDrove[I] := 0;
      KmTotal[I] := 0;
      Stmt[I] := '';
      StmtPercent[I] := 0;
      PartnerFlag[I] := '';
      ExpensesClaim[I] := 0;
      CCAClaim[I] := 0;
    end;
  end;

  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    If FRec.FormName = 'AUTOS' then
    begin
      FNo := FRec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] then
      begin
        j := 215;
        Repeat
          If (FetchElmFNo(RetNo, FNo, j) = Stmt) and
            (Vl(FetchElmFNo(RetNo, FNo, j + 1)) > 0) then
          begin
            With SelfAutoExpRec do
            begin
              NumOfCars := NumOfCars + 1;
              If NumOfCars > 6 then
                exit;
              Descr[NumOfCars] := FetchElmFNo(RetNo, FNo, 1);
              StmtPercent[NumOfCars] := Vl(FetchElmFNo(RetNo, FNo, j + 1));
              KmDrove[NumOfCars] := Round(Vl(FetchElmFNo(RetNo, FNo, 4)));
              KmTotal[NumOfCars] := Round(Vl(FetchElmFNo(RetNo, FNo, 7)));
              Stmt[NumOfCars] := FetchElmFNo(RetNo, FNo, j);
              PartnerFlag[NumOfCars] := FetchElmFNo(RetNo, FNo, j + 5);
              ExpensesClaim[NumOfCars] := Vl(FetchElmFNo(RetNo, FNo, j + 2));
              CCAClaim[NumOfCars] := Vl(FetchElmFNo(RetNo, FNo, j + 3));
            end;
          end;
          inc(j, 6); // dummy
        until j > 227; // 227;
      end;
    end;
  end;
end;

Procedure UpdateThisFormDataIndicator(RetNo: Integer; FName: String);
var
  I, FNo: Integer;
  s: string;
begin
  begin
    FRec := FList.ByFormName(FName);
    FNo := FRec.FormNo;
{$IFDEF single}
    If FName = FRec.FormInstName then
    begin
      s := FRec.DataIndic;
      If FNo > 0 then
        UpdateFormDataIndicator(RetNo, FNo, s);
    end;
{$ELSE}
    If FNo > 0 then
      UpdateFormDataIndicator(RetNo, FRec);
{$ENDIF}
  end;


  //20240527
  if FName='S15#1' then //both boxes No)
  begin
   if  (FetchElm(RetNo,GetFormNo('S15#1'),2)>'')
   and (FetchElm(RetNo,GetFormNo('S15#1'),4)>'')
    Then Ret[RetNo].FrmHasdata[GetFormNo('S15#1')]:=True;
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


Function NewDBStructure: Boolean;
begin
  //
end;

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
{$IFDEF single}
        FNo := GetFormNo(FName + '#' + IntToStr(Cnt));
        If FNo = 0 then
{$ELSE}
{$ENDIF}
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
    exit; // 20101220
  ToFNo := GetFormNo(ToFormName);
  FromFNo := GetFormNo(FromFormName); // 20110125
  If ToFNo = 0 then
  begin
    CInst := ExtractFormInstNo(ToFormName);
{$IFDEF single}
    If GetFormNo(ToFormName) = 0 then { instance does not exist }
    begin
      AddPageInstance(ExtractNonInstFormName(ToFormName),
        '#' + IntToStr(CInst));
    end;
    ToFNo := GetFormNo(ToFormName);
{$ELSE}
    ToFNo := AddPageInstance(ToRetNo, ExtractNonInstFormName(ToFormName),
      '#' + IntToStr(CInst));
{$ENDIF}
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


Function FormatT3Account(RetNo: Integer; Acc: String): String;
Begin
  result := Acc;
  If Length(Acc) = 8 then
    result := LeftStr(Acc, 2) + '-' + MidStr(Acc, 3, 4) + '-' +
      RightStr(Acc, 2);
end;

function LicenseLevel: eLicenseLevel;
begin
  result := AppT3_2026.LicenseLevel;
end;

function LicenseName: string;
begin
  result := AppT3_2026.ProductName;
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
  PrpStatus, EFstatus: String[2];
  Notes: String[80];
  DbfDataDir: String[60];
Begin
  result := False;
  FlName := Trim(ADS.FieldByName('File_Name').AsString);
  If FlName = '' then
  Begin
    AErr := 'Skip record. FileName is empty';
    exit;
  End;
  If Not FileExists(IncludeTrailingBackslash(ASrcDir) + FlName) then
  Begin
    AErr := 'Skip record. File "' + IncludeTrailingBackslash(ASrcDir) + FlName +
      '" is missing';
    exit;
  End;
  if not GetReturnAppAndYear(ASrcDir, FlName, RApp, RYear,
    AppT3_2026.SQLLitePassword.PassArray) then // 20160703 Igor
  Begin
    AErr := 'Skip record. File "' + IncludeTrailingBackslash(ASrcDir) + FlName +
      '" have bad format';
    exit;
  End;
  if (RApp <> 'TAXFORMS' { AppName } ) { or (RYear <> AppYearInt) } then
  Begin
    AErr := 'Skip record. File "' + IncludeTrailingBackslash(ASrcDir) + FlName +
      '" does not belong to the current program';
    exit;
  End;

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
    If not FileExists(IncludeTrailingBackslash(ADstDir) + FlName) or AOverride
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
  If (DirectoryExists(OptRec.Dir_PgmLastYr) = False) then
  Begin
    AErrorMessage := 'Last year program’s directory "' + OptRec.Dir_PgmLastYr +
      '" does not exist.' // 20160710 Igor
      + Chr(13) + 'See Configure | General Options | Data Directories' + #13 +
      'You need to Exit and restart the program after changing last year’s data directory';
    if AShowMessage then
      ShowMessage(AErrorMessage);
    exit;
  End;

//20180207 Igor >>>
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

  //20180207 Igor <<<
  If not FileExists(OptRec.Dir_PgmLastYr + '\' + LastYearPgm) AND
    not FileExists(OptRec.Dir_PgmLastYr + '\' + LastYearBpl) AND
    not FileExists(OptRec.Dir_PgmLastYr + '\..\' + LastYearBpl) then //20180207 Igor
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
(*
  //20180207 Igor >>>
  If AppYear = '2017' then
  begin
    If FileExists(OptRec.Dir_PgmLastYr + '\' + 'TFSCR.db') = False then
    Begin
      if FileExists(OptRec.Dir_PgmLastYr + '\' + ChangeFileext('TFSCR.db',
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
    LastYearPgm := 'TF' + IntToStr(StrToInt(Appyear) - 1) + '.EXE';
    LastYearBpl := 'vt' + 'TF' + '_' + IntToStr(StrToInt(Appyear) - 1)
      + '.bpl';
  end
  else
  begin
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
  end;
  //20180207 Igor <<<
  If not FileExists(OptRec.Dir_PgmLastYr + '\' + LastYearPgm) AND
    not FileExists(OptRec.Dir_PgmLastYr + '\' + LastYearBpl) AND
    not FileExists(OptRec.Dir_PgmLastYr + '\..\' + LastYearBpl) then //20180207 Igor
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
*)

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
  If (DirectoryExists(OptRec.Dir_LastYr) = False) then
  Begin
    AErrorMessage := 'Last year data directory "' + OptRec.Dir_LastYr +
      '" does not exist.' // 20160710 Igor
      + Chr(13) + 'See Configure | General Options | Data Directories';
    if AShowMessage then // 20160516 Igor
      ShowMessage(AErrorMessage);
    exit;
  End;

  //20180207 Igor >>>
  If AppYear = '2017' then
  begin
    If not FileExists(OptRec.Dir_LastYr + '\' + 'CLIENTS_TF.db') then
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
  end
  else
  begin
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
  end;
  //20180207 Igor <<<
  result := True;
End;

procedure InitLastYearFormsTable; // 20160629 Igor
var
  LastYearDir: string;
  f: TextFile;
begin
  LastYearDir := OptRec.Dir_PgmLastYr;
  If not DirectoryExists(LastYearDir) then
    exit;
  //20180207 Igor >>>
  IF AppYear = '2017' then
  begin
    If FileExists(LastYearDir + '\' + 'TFSCR.db') then
    Begin
      FullPathT3Scr_LastYear := LastYearDir + '\' + 'TFSCR.db';
      // use original db file
    End
    else if FileExists(LastYearDir + '\' + ChangeFileext('TFSCR.db', '.DBF'))
    then
    begin
      FullPathT3Scr_LastYear := LastYearDir + '\' + ChangeFileext('TFSCR.db',
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

    FLastYearList := TFListT3.create(AppT3_2026, FormsLimit, FieldsLimit,
      FullPathT3Scr_LastYear, 'TFSCR', LastYearDir);
    // 20160710 Igor
    if not FLastYearList.InitFormsTable(LastYearDir, FullPathT3Scr_LastYear,
      'TFSCR') then
    begin
      freeAndNil(FLastYearList);
      exit;
    end;
  end
  else
  begin
    If FileExists(LastYearDir + '\' + FormsDBLite) then
    Begin
      FullPathT3Scr_LastYear := LastYearDir + '\' + FormsDBLite;
      // use original db file
    End
    else if FileExists(LastYearDir + '\' + ChangeFileext(FormsDBLite, '.DBF'))
    then
    begin
      FullPathT3Scr_LastYear := LastYearDir + '\' + ChangeFileext(FormsDBLite,
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

    FLastYearList := TFListT3.create(AppT3_2026, FormsLimit, FieldsLimit,
      FullPathT3Scr_LastYear, FormsTableLite, LastYearDir);
    // 20160710 Igor
    if not FLastYearList.InitFormsTable(LastYearDir, FullPathT3Scr_LastYear,
      FormsTableLite) then
    begin
      freeAndNil(FLastYearList);
      exit;
    end;
  end;
  //20180207 Igor <<<
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

//20170113
Function OtherThanQREAndQdt(RetNo: Integer): Boolean;
begin
  //20180107
  result := False;
  if (FetchElm(RetNo,'T3',43)='')
  and (FetchElm(RetNo,'T3',45)='')
  then result := True;

  {
  If  (FetchElm(RetNo, 'T3', 81) <> '903')
  and (FetchElm(RetNo, 'T3', 81) <> '904') then
    result := True;
  }
end;

//20170122
Function IsQRE(RetNo: Integer): Boolean;
begin
//20180107
  result := False;
  if FetchElm(RetNo,'T3',43)>'' then Result:=True;
 // If  (FetchElm(RetNo, 'T3', 81)= '903') then result := True;
end;

//20170325
Function IsQDT(RetNo: Integer): Boolean;
begin
//20180107
  result := False;
  if FetchElm(RetNo,'T3',45)>'' then Result:=True;
//  If  (FetchElm(RetNo, 'T3', 81)= '904') then result := True;
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
      //20220305 //con
      If ResultsList.count>0 then
        SelectedString := PopSomeList(ResultsList, SomeCaption)
      Else
        Begin ShowMessage('Form not found');Exit;end;

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

Procedure T5013IncProcess(RetNo: Integer; Var T5013LimitedInc: Real;
  Var T5013OthInc: Real; Var T5013ITC: Real; Var T5013ActDiv: Real;
  Var T5013ActDivEligible: Real; Var T5013CarrCharg: Real; Var T5013CDE: Real;
  Var T5013CEE: Real; Var T5013COGPE: Real; Var T5013FDE: Real;
  Var T5013RecapDepl: Real; Var T5013FedPol: Real; Var T5013ProvPol: Real;
  Var T5013Don: Real; Var T5013Gifts: Real; Var T5013Abil: Real;
  Var T5013FNonBusInc1: Real; Var T5013FNonBusInc2: Real;
  Var T5013FNonBusInc3: Real; Var T5013FNonBusTax1: Real;
  Var T5013FNonBusTax2: Real; Var T5013FNonBusTax3: Real;
  Var T5013FBusInc1: Real; Var T5013FBusInc2: Real; Var T5013FBusInc3: Real;
  Var T5013FBusTax1: Real; Var T5013FBusTax2: Real; Var T5013FBusTax3: Real;
  Var T5013Interest: Real; Var T5013Tax: Real; Var T5013ResAllow: Real;
  Var T5013FInterest: Real; Var T5013GrossIncome: Real;
  Var T5013BusIncome: Real; Var T5013FarmIncome: Real;
  Var T5013FishIncome: Real; Var T5013RentIncome: Real);

Var
  I, FNo, T5013Period: Integer;
begin
  T5013LimitedInc := 0;
  T5013OthInc := 0;
  T5013ITC := 0;
  T5013ActDiv := 0;
  T5013ActDivEligible := 0;
  T5013CarrCharg := 0;
  T5013CDE := 0;
  T5013CEE := 0;
  T5013COGPE := 0;
  T5013FDE := 0;
  T5013RecapDepl := 0;
  T5013FedPol := 0;
  T5013ProvPol := 0;
  T5013Don := 0;
  T5013Gifts := 0;
  T5013Abil := 0;
  T5013FNonBusInc1 := 0;
  T5013FNonBusInc2 := 0;
  T5013FNonBusInc3 := 0;
  T5013FNonBusTax1 := 0;
  T5013FNonBusTax2 := 0;
  T5013FNonBusTax3 := 0;
  T5013FBusInc1 := 0;
  T5013FBusInc2 := 0;
  T5013FBusInc3 := 0;
  T5013FBusTax1 := 0;
  T5013FBusTax2 := 0;
  T5013FBusTax3 := 0;
  T5013Interest := 0;
  T5013FInterest := 0;
  T5013Tax := 0;
  T5013ResAllow := 0;

  T5013GrossIncome := 0;
  T5013BusIncome := 0;
  T5013FarmIncome := 0;
  T5013FishIncome := 0;
  T5013RentIncome := 0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    if FRec.FormName = 'T5013INC' then
    begin
      FNo := FRec.FormNo;
      T5013Period := 3;
      { MyStrToInt(FetchElmFNo(RetNo,FNo,22)); }
      If Ret[RetNo].FrmHasData[FNo] then
      begin
        T5013ITC := T5013ITC + Vl(Ret[RetNo].Frm[FNo].Strings[26]);
        T5013ActDiv := T5013ActDiv + Vl(Ret[RetNo].Frm[FNo].Strings[5]);
        T5013ActDivEligible := T5013ActDivEligible +
          Vl(Ret[RetNo].Frm[FNo].Strings[61]);
        T5013CarrCharg := T5013CarrCharg + Vl(Ret[RetNo].Frm[FNo].Strings[19]);
        T5013CDE := T5013CDE + Vl(Ret[RetNo].Frm[FNo].Strings[28]);
        T5013CEE := T5013CEE + Vl(Ret[RetNo].Frm[FNo].Strings[27]);
        T5013COGPE := T5013COGPE + Vl(Ret[RetNo].Frm[FNo].Strings[29]);
        T5013FDE := T5013FDE + Vl(Ret[RetNo].Frm[FNo].Strings[30]);
        T5013RecapDepl := T5013RecapDepl + Vl(Ret[RetNo].Frm[FNo].Strings[31]);
        T5013FedPol := T5013FedPol + Vl(Ret[RetNo].Frm[FNo].Strings[24]);
        T5013ProvPol := T5013ProvPol + Vl(Ret[RetNo].Frm[FNo].Strings[25]);
        T5013Don := T5013Don + Vl(Ret[RetNo].Frm[FNo].Strings[33]);
        T5013Gifts := T5013Gifts + Vl(Ret[RetNo].Frm[FNo].Strings[34]);
        T5013Abil := T5013Abil + Vl(Ret[RetNo].Frm[FNo].Strings[8]);
        T5013ResAllow := T5013ResAllow + Vl(Ret[RetNo].Frm[FNo].Strings[32]);
        T5013RecapDepl := T5013RecapDepl + Vl(Ret[RetNo].Frm[FNo].Strings[31]);

        // foreign bus income
        If Ret[RetNo].Frm[FNo].Strings[1] = '1' then
        begin
          T5013FBusInc1 := T5013FBusInc1 + Vl(Ret[RetNo].Frm[FNo].Strings[6]);
          T5013FBusTax1 := T5013FBusTax1 + Vl(Ret[RetNo].Frm[FNo].Strings[67]);
        end
        else If Ret[RetNo].Frm[FNo].Strings[1] = '2' then
        begin
          T5013FBusInc2 := T5013FBusInc2 + Vl(Ret[RetNo].Frm[FNo].Strings[6]);
          T5013FBusTax2 := T5013FBusTax2 + Vl(Ret[RetNo].Frm[FNo].Strings[67]);
        end
        else If Ret[RetNo].Frm[FNo].Strings[1] = '3' then
        begin
          T5013FBusInc3 := T5013FBusInc3 + Vl(Ret[RetNo].Frm[FNo].Strings[6]);
          T5013FBusTax3 := T5013FBusTax3 + Vl(Ret[RetNo].Frm[FNo].Strings[67]);
        end;

        T5013FNonBusInc1 := T5013FNonBusInc1 +
          Vl(Ret[RetNo].Frm[FNo].Strings[10]);
        T5013FNonBusTax1 := T5013FNonBusTax1 +
          Vl(Ret[RetNo].Frm[FNo].Strings[23]);

        T5013Interest := T5013Interest + Vl(Ret[RetNo].Frm[FNo].Strings[7]) +
          Vl(Ret[RetNo].Frm[FNo].Strings[65]);
        T5013FInterest := T5013FInterest + Vl(Ret[RetNo].Frm[FNo].Strings[10]);
        T5013Tax := T5013Tax + Vl(Ret[RetNo].Frm[FNo].Strings[17]);
        T5013LimitedInc := T5013LimitedInc + Vl(Ret[RetNo].Frm[FNo].Strings[2]);
        Ret[RetNo].T5013OthInc := T5013OthInc +
          Vl(Ret[RetNo].Frm[FNo].Strings[63]) +
          Vl(Ret[RetNo].Frm[FNo].Strings[15]);;

        T5013GrossIncome := T5013GrossIncome +
          Vl(Ret[RetNo].Frm[FNo].Strings[18]);
        T5013BusIncome := T5013BusIncome + Vl(Ret[RetNo].Frm[FNo].Strings[9]) +
          Vl(Ret[RetNo].Frm[FNo].Strings[2]);
        T5013FarmIncome := T5013FarmIncome + Vl(Ret[RetNo].Frm[FNo].Strings[22])
          + Vl(Ret[RetNo].Frm[FNo].Strings[45]) +
          Vl(Ret[RetNo].Frm[FNo].Strings[46]);
        T5013FishIncome := T5013FishIncome + Vl(Ret[RetNo].Frm[FNo].Strings[26])
          + Vl(Ret[RetNo].Frm[FNo].Strings[47]);
        T5013RentIncome := T5013RentIncome + Vl(Ret[RetNo].Frm[FNo].Strings[3])
          + Vl(Ret[RetNo].Frm[FNo].Strings[49]);
      end;
    end;
  end;
end;



procedure ClearElmValues(ARetNo, AFormNo: integer;ElmList:TStringList);
var  I,Elm: Integer;
begin
  for i:=0 to Elmlist.count-1 do
  Begin
   Elm:=MyStrToInt(Elmlist[i]);
   if Elm>0 then StoreElm(ARetNo,aFormNo,Elm,'');
  End;
end;

//20180315
Function T3EfileEligible(RetNo:Integer):Boolean;
Begin
 Result:=True;
 //20180319
 if (FetchElm(RetNo,'T3',2)='') then Result:=False;  //Account no account No
 If (Vl(FetchElm(RetNo,'T3',272))>0) then Result:=False; //taxable  //20180319
 If (Vl(FetchElm(RetNo,'T3',314))>0) then Result:=False; //taxes payable
 If (Vl(FetchElm(RetNo,'T3',324))>0) then Result:=False; //ref credits
 If (LeftStr(FetchElm(RetNo,'T3',17),4)<'2017') then Result:=False; //year end
 If (Vl(FetchElm(RetNo,'T3',81))=28) then Result:=False; //SIFT type trust 28
 If (Ret[Retno].FrmHasData[GetFormNo('T1055')]=True) then Result:=False;
 If (Vl(FetchElm(RetNo,'T3',255))>0) then Result:=False; //gross up grossup 49
 If (Vl(FetchElm(RetNo,'S9',34))>0) then Result:=False; //Line 930 of S9  //20190401
 If (Vl(FetchElm(RetNo,'S1',93))>0) then Result:=False; //1170 reserves
 //If (Ret[Retno].FrmHasData[GetFormNo('S11A')]=True) then Result:=False;

 If (Vl(FetchElm(RetNo,'S12',143))>0) and (SubjectToMinTax(RetNo)) //MIN tax
 then Begin Result:=False;Exit;end;

End;

function ValidatePreparerInfo:boolean;  //for efile
begin
 result:= true;
 If OptRec.Prp_Name = '' then
 begin
  ShowMessage('Complete Company Name information'+Chr(13)+Chr(13)+'(See Configure -> General Options -> Preparer)');
  result:= false;
 end
 else If OptRec.Prp_ContactName = '' then
 begin
  ShowMessage('Complete Contact Name information'+Chr(13)+Chr(13)+'(See Configure -> General Options -> Preparer)');
  result:= false;
 end

 Else if Length(OptRec.Prp_Tel) <>8 then  //20110524
 begin
   ShowMessage('see Configure->Preparer->Telephone must be entered in format 999-9999');
   Result:=False;
 end

 Else If AllTrim(OptRec.Prp_Fax) >'' then
 begin
   If Length(OptRec.Prp_Fax) <>8 then
   Begin
    ShowMessage('see Configure->Preparer->Fax must be entered in format 999-9999');
    Result:=False;
   end;
 end

 else If (length(OptRec.Prp_Area) <> 3) or (OptRec.Prp_Tel = '') then
 begin
  ShowMessage('Complete Area Code and Phone Number information'+Chr(13)+Chr(13)+'(See Configure -> General Options -> Preparer)');
  result:= false;
 end

 else If OptRec.Prp_City = '' then
 begin
  ShowMessage('Complete City information'+Chr(13)+Chr(13)+'(See Configure -> General Options -> Preparer)');
  result:= false;
 end

 else If OptRec.Prp_Postal = '' then
 begin
  ShowMessage('Complete Postal Code information'+Chr(13)+Chr(13)+'(See Configure -> General Options -> Preparer)');
  result:= false;
 end
 else If length(OptRec.Prp_Countr) <> 3 then
 begin
  ShowMessage('Country Code must be 3 characters in accordance to ISO 3166-3'+Chr(13)+Chr(13)+'(See Configure -> General Options -> Preparer)');
  result:= false;
 end
 else If (Length(OptRec.Prp_TransmitterNo) <> 9) and (Length(OptRec.Prp_TransmitterNo) <> 15) then //jz//20250323 Length(OptRec.Prp_TransmitterNo) <> 6 then
 begin
  ShowMessage('Transmitter number must be 9 or 15 characters'+
  Chr(13)+
  Chr(13)+'(See Configure -> General Options -> Preparer)');
  result:= false;
 end;
end;



Function GetEfStatusDescr(EFStatusCode: String): String; //20210906 Igor
var
  i: Integer;
begin
  Result := '';
  For i := Low(EFStatusCodes) to High(EFStatusCodes) do
    If EFStatusCodes[i] = EFStatusCode then
    begin
      Result := EFStatusDescr[i];
      exit;
    end;
end;

Procedure GetEOLParms(Var OnLineNo: String; Var Password: String; //20210906 Igor
  Var url: String; Var NetFileDir: String);
Var
  i: Integer;
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

Procedure SaveEOLParms(OnLineNo, Password, url, NetFileDir: String); //20210906 Igor
Var
  i: Integer;
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  TempList.Add(OnLineNo);
  TempList.Add(Password);
  TempList.Add(url);
  TempList.Add(NetFileDir);
  TempList.SaveToFile(AppDir + '\' + 'EOL.TXT');
  TempList.Free;
end;

Function MkJsonFileName(RetNo: Integer; NetFileDir: String): String;
Var
  S: String;
begin
  // 20140126
  Result := NetFileDir + '\' + RemoveChar(GetLastName(RetNo) + ' ' +
    GetFirstName(RetNo) + '-' + {GetSinNo(RetNo) + '-' +} Ret[RetNo].Province +
    '-FullJson', '.') + '.json';
end;

(* //20240118 Igor delete this
Function MkT3MJsonFileName(RetNo: Integer; NetFileDir: String): String; //20211123 Igor
Var
  S: String;
begin
  // 20140126
  Result := NetFileDir + '\T3M-' + RemoveChar(GetLastName(RetNo) + ' ' +
    GetFirstName(RetNo) + '-' + {GetSinNo(RetNo) + '-' +} Ret[RetNo].Province +
    '-FullJson', '.') + '.json';
end;

Function MkT3RCAJsonFileName(RetNo: Integer; NetFileDir: String): String; //20231201 Igor
Var
  S: String;
begin
  Result := NetFileDir + '\T3RCA-' + RemoveChar(GetLastName(RetNo) + ' ' +
    GetFirstName(RetNo) + '-' + {GetSinNo(RetNo) + '-' +} Ret[RetNo].Province +
    '-FullJson', '.') + '.json';
end;

Function MkT3ATHJsonFileName(RetNo: Integer; NetFileDir: String): String; //20231211 Igor
Var
  S: String;
begin
  Result := NetFileDir + '\T3ATH-' + RemoveChar(GetLastName(RetNo) + ' ' +
    GetFirstName(RetNo) + '-' + {GetSinNo(RetNo) + '-' +} Ret[RetNo].Province +
    '-FullJson', '.') + '.json';
end;
*)


Function GetDefaultNetFileDir: String; //20210906 Igor
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

Function GetTestCaseId(RetNo: Integer; CaseID:string): Integer; //20211215 //20211220 Igor
Var
  i: Integer;
  TempList: TStringList;
  IdFlName, FlName,s: String;
Begin
  Result := 0;
  s:= InputBox('', 'Enter testcaseId', CaseID);
  if s>'' then result:=MyStrToInt(s);
  EXIT;
End;

Function ReadyForT1135Efile(RetNo: Integer): Boolean; // 20220116
Var
  FNo: Integer;
Begin
  Result := false;
  FNo := GetFormNo('T1135');
  if FetchElmFNo(RetNo, FNo, 36) + FetchElmFNo(RetNo, FNo, 42) +
    FetchElmFNo(RetNo, FNo, 34) + FetchElmFNo(RetNo, FNo, 86) > '' then
    Result := True;
End;

Function GetEOLAgentNo: String; //20220117 Igor
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

Function GetDcnSeqNoEOL(RetNo: Integer; OnLineNo: String): String; //20220120 Igor
Var
  YYYY, MM, DD, Hour, Min, Sec, Msec: word;
  SMM, SDD, SMin, SSec, SMSec: string; // [2];
  Syyyy: string; // [4];
  sBirthday: string; // [2];
  AppYr: String; // 20170217
  i:Integer;
begin
  //Delay(1); //For i:=1 to 1 Do begin Delay; end;//Delay(1); // to incease thesecond //20230207
  DecodeDate(Now, YYYY, MM, DD);
  DecodeTime(Now, Hour, Min, Sec, Msec);
  Syyyy := AllTrim(IntTostr(YYYY));
  SMM := LTrim(RTrim(IntTostr(MM)));
  SDD := LTrim(RTrim(IntTostr(DD)));
  SMin := LTrim(RTrim(IntTostr(Min)));
  SSec := AllTrim(IntTostr(Sec));
  SMSec := LTrim(RTrim(IntTostr(Msec)));
  If Length(SMM) = 1 then
    SMM := '0' + SMM;
  If Length(SDD) = 1 then
    SDD := '0' + SDD;
  If Length(SMin) = 1 then
    SMin := '0' + SMin;
  If Length(SSec) = 1 then
    SSec := '0' + SSec;
  Smsec:=AllTrim(LeftStr(Smsec,2)); //20220503
  If Length(SMSec) = 1 then
    SMSec := '0' + SMSec;
  AppYr := RightStr(AppYear, 2);
  Result := OnLineNo + AppYr + SDD + SSec + SMSec;
  If Length(Result) <> 13 then
    Result := '';
end;

Function IsReadyForEfile(RetNo:Integer):Boolean; //20220120 Igor
begin
  Result := True;
  If RetNo=0 then exit;
  CountDiagnostics(RetNo);
  If (Ret[RetNo].EFileErrorCount > 0) then result :=False;
end;

Function ValidateDcn(RetNo: Integer): Boolean; //20220120 Igor
Var
  S: String;
Begin
  Result := false;
  S := MidStr(FetchElm(RetNo, 'T183TRUST', 21), 6, 2);
  if S = '' then
  begin
    Result := True;
    exit;
  End;
  If Ret[RetNo].EfStatus = '02' then
  begin
    Result := True;
    exit;
  End;
  If S = RightStr(AppYear, 2) then
    Result := True;
End;

function CalcCheckDigitForT3AOOCR(ALine: string): string; // 20240329
//function CalcCheckDigitForT7DROCR(ALine: string): string; // 20180307 Igor
var
  cLine1, cLine2, cLine3, cLine4: string;
  nTotalSum: Integer;

  function SumLine(ASumLine: string; AStartWeight: Integer): Integer;
  var
    i, nSum, weight: Integer;
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

Function ReformatSinWithSpaceInBetween(S: string): String;
// 20180310 CON 9:54PM
begin
  If Length(S) < 9 then
  begin
    Result := S;
    exit;
  end;
  Result := LeftStr(S, 3) + ' ' + MidStr(S, 4, 3) + ' ' + RightStr(S, 3);
  If Result = '  ' then
    Result := '';
end;

//20230106
Procedure GetT2030ACharts(RetNo: Integer;FarmFname:String;FarmFNo:Integer;
  Var Totexp:Real; Var TotMInv:Real;Var TotOInv:Real;Var TotGInc:Real;
  Var TotSal:Real);
  //get farm exp, Mandatory and Optional inventory adjustments and gross income
Var
  i, FNo: Integer;
  FInst: String;
  lFrec: TFRec;
  Prv:String;
begin
   //FNo:=FarmFNo;
   TotExp:=0;
   TotMInv:=0;
   TotOInv:=0;
   TotGInc:=0;
   TotSal:=0;

  If Ret[RetNo].IsLastYearReturn then exit; // 20160314 Igor
  for i:= 0 to (FList.Count - 1) do
  begin
    lFrec := FList.Items[i];
    FNo := lFrec.FormNo;
    If Ret[RetNo].FrmHasData[FNo] and (FNo=FarmFNo) then
    begin
      If (lFrec.FormName = 'T2042') then
      Begin
        TotExp:=TotExp+Vl(FetchElmFNo(RetNo,Fno,138));
        TotMInv:=TotMInv+Vl(FetchElmFNo(RetNo,Fno,128));
        TotOInv:=TotOInv+Vl(FetchElmFNo(RetNo,Fno,127));
        TotGInc:=TotGInc+Vl(FetchElmFNo(RetNo,Fno,66))-vl(FetchElm(RetNo,FNo,137)); //fuel charge
        //If FNo=FarmFNo then
        TotSal:=TotSal+Vl(FetchElmFNo(RetNo,Fno,115));  //20220424
      end
      Else
      If (lFrec.FormName = 'T1163')
      Or (lFrec.FormName = 'T1273') then
      Begin
        TotExp:=TotExp+Vl(FetchElmFNo(RetNo,Fno,602));
        TotMInv:=TotMInv+Vl(FetchElmFNo(RetNo,Fno,538));
        TotOInv:=TotOInv+Vl(FetchElmFNo(RetNo,Fno,539));
        TotGInc:=TotGInc+Vl(FetchElmFNo(RetNo,Fno,526))-vl(FetchElm(RetNo,FNo,137));
        //If FNo=FarmFNo then
        TotSal:=TotSal+Vl(FetchElmFNo(RetNo,Fno,526));
      End;
    end;  //has data
  end; //i
end;

Function MaskTheAccount(RetNo:Integer): Boolean; //20230209;
begin
 Result:=false;
 if FetchElm(RetNo,'EFMEMO',57)>'' then result:=true;
end;



//jz//20260312 - no time to implement but could use this more generic routine instead of having seperate GetMaskedAccount and GetMaskedRepId
Function GetMaskedString(RetNo,numToMask:integer;fullString:string): String;
var
  i:integer;
begin
 Result:=fullString;
 if MasktheAccount(RetNo)=True then
 Begin
    for i := 1 to length(fullString) do
    begin
      fullString[i] := '#';
      if i = numToMask then break;
    end;
    Result:=fullString;
 End;
end;

Function GetMaskedAccount(RetNo:Integer): String; //20230209;
Var FullAccount:String; i:integer;
begin
 FullAccount:=FetchElm(RetNo,'T3',2); //8 digits
 Result:=FullAccount; //202300311
 if MasktheAccount(RetNo)=True then
 Begin
  //if Length(FullAccount)=8 then //jz//20260312 - why have this check? just mask it.
  //  result:='#####'+RightStr(FullAccount,4);
    //jz//20260312 - mask the fist 4 char
    for i := 1 to length(FullAccount) do
    begin
      FullAccount[i] := '#';
      if i = 4 then break;
    end;
    Result:=FullAccount;
 End;
end;

Function GetMaskedRepId(RetNo:Integer): String; //20230209;
Var FullAccount:String; i: Integer;
begin
 FullAccount:=FetchElm(RetNo,'T183TRUST',35); //8 digits
 Result:=FullAccount; //jz//20260312
 if MasktheAccount(RetNo)=True then
 Begin
      //if Length(FullAccount)=8 then //jz//20260312 - repId is less than 8 but why have this check at all? just mask it.
        //result:='#####'+RightStr(FullAccount,4);
    //jz//20260312 - mask the fist 4 char
    for i := 1 to length(FullAccount) do
    begin
      FullAccount[i] := '#';
      if i = 4 then break;
    end;
    Result:=FullAccount;
 End;
end;

Function GetAiipFActor(Cls:String):Real;  //20230226
Begin
 if cls = '43.1' then result := 2.33333
 Else if cls = '43.2' then result := 1
 Else if cls = '53' then  result:= 1
 Else result:=0.5;
 if (cls = '12') or (cls = '14') or (cls = '15') then result := 0; // 20200703
end;

function MkDirforClientDocs(RetNo: Integer): string;
Var CorpNm:String;
begin
  CorpNm:=GetT3TrustName(RetNo);
  CorpNm:=ReplaceChar(CorpNm,'"','');
  CorpNm:=ReplaceChar(CorpNm,'.','');
  Result := GetT3TrustName(RetNo) + '-YE-' + LeftStr(GetYearEnd(RetNo), 4);
end;

Function GetSignatureFilePath(RetNo:Integer):String;//20200320
Var Folder,FullName:String;
Begin
 Result:='';
 Folder:=optRec.Dir_ClientDocs+'\'+MkDirforClientDocs(RetNo);
  //MkDirforClientDocs(RetNo)+'\'+GetCorpName(retNo);
  //OptRec.Dir_ClientDocs+'\'+GetCorpName(retNo); //20200325
 //check both jpg and png
 FullName:=Folder+'\'+'Signature.jpg';
 if FileExists(FullName) then begin Result:=FullName; exit;end
 else
 Begin
   FullName:=Folder+'\'+'Signature.bmp';
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

Function IsMultiJurisdiction(RetNo:Integer): Boolean; //20231202
Begin
  Result := false;
  If FetchElm(RetNo,'T3MJ',110) > '' then result := true;
End;


//jz 20240326
function GetTrustNumber(RetNo:Integer; ReturnType:string; IsProd:boolean): String;
//function GetTrustNumber(ARetNo: integer; AFormName: string; AElmNo: integer; ProdOrTest:String): String;
var accountNm:string;
begin
  //regular T3 Ret
  accountNm := FetchElm(RetNo, 'T3', 2);

  if      ReturnType = 'T3M'    then accountNm := FetchElm(RetNo, ReturnType, 58)
  else if ReturnType = 'T3RCA'  then accountNm := FetchElm(RetNo, ReturnType,  2)
  else if ReturnType = 'T3ATH'  then accountNm := FetchElm(RetNo, ReturnType,  7)
  else if ReturnType = 'T3D'    then accountNm := FetchElm(RetNo, ReturnType,  6)
  else if ReturnType = 'T3P'    then accountNm := FetchElm(RetNo, ReturnType,  7)
  else if ReturnType = 'T3PRP'  then accountNm := FetchElm(RetNo, ReturnType,  8)
  else if ReturnType = 'T3GR'   then accountNm := FetchElm(RetNo, ReturnType, 12)
  else if ReturnType = 'T3RI'   then accountNm := FetchElm(RetNo, ReturnType,  6)
  else if ReturnType = 'T3S'    then accountNm := FetchElm(RetNo, ReturnType,  7)
  else if ReturnType = 'T1061'  then accountNm := FetchElm(RetNo, ReturnType,  6);

  if IsProd then
    Result := 'T' + accountNm
  else  //is test
    Result := 'A' + accountNm;
end;



Function GetEfilerNo: String; //20231223
Var
  EfilerNo, S: String;
begin
  GetEOLParms(EfilerNo, S, S, S);
  Result := EfilerNo;
end;

//mjjz2024
Function GetMjAlloc(RetNo: Integer; Prv: String): String;
Var T3MJFNo:Integer;
begin

   Result := '';
   T3MJFNo:=GetFormNo('T3MJ');  //20230508 relocated from above
   If IsMultiJurisdiction(RetNo) then     //check income allocated
   begin
    if      (Prv='NL') then Result := (FetchElmFNo(RetNo,T3MJFNo,   7))
    else if (Prv='PE') then Result := (FetchElmFNo(RetNo,T3MJFNo,  14))
    else if (Prv='NS') then Result := (FetchElmFNo(RetNo,T3MJFNo,  21))
    else if (Prv='NB') then Result := (FetchElmFNo(RetNo,T3MJFNo,  28))
    else if (Prv='QC') then Result := (FetchElmFNo(RetNo,T3MJFNo,  35))
    else if (Prv='ON') then Result := (FetchElmFNo(RetNo,T3MJFNo,  42))
    else if (Prv='MB') then Result := (FetchElmFNo(RetNo,T3MJFNo,  49))
    else if (Prv='SK') then Result := (FetchElmFNo(RetNo,T3MJFNo,  56))
    else if (Prv='AB') then Result := (FetchElmFNo(RetNo,T3MJFNo,  63))
    else if (Prv='BC') then Result := (FetchElmFNo(RetNo,T3MJFNo,  70))
    else if (Prv='YT') then Result := (FetchElmFNo(RetNo,T3MJFNo,  77))
    else if (Prv='NT') then Result := (FetchElmFNo(RetNo,T3MJFNo,  84))
    else if (Prv='NU') then Result := (FetchElmFNo(RetNo,T3MJFNo, 105))
    else if (Prv='ZZ') then Result := (FetchElmFNo(RetNo,T3MJFNo,  91));
 end;

end;


//mjjz2024
Function CalcThisMJProvince(RetNo:Integer;Prv:String): Boolean;
Var spRetNo:Integer;i:integer; T3MJFNo:Integer;
begin
  result :=false;
  If (IsMultiJurisdiction(RetNo)) and (GetMjAlloc(RetNo, Prv)>'') then
    result :=True;
end;


//mjjz2024
Function CalcThisProvince(RetNo:Integer;Prv:String): Boolean;
Var spRetNo:Integer;i:integer; T3MJFNo:Integer;
begin
  //jz//20260102
  result :=false;
  If (UpperCase(Prv) = HomeProv) and (not IsMultiJurisdiction(RetNo)) then Result:=True;

  //jz//20260102 - why put it in 2 places? also Prv = Ret[RetNo].Province) doens't seem to work
  {
  result :=false;
  If UpperCase(Prv) = HomeProv then Result:=True;
    //If Ret[RetNo].Province then result :=True;   //20260118cz
  If (not IsMultiJurisdiction(RetNo)) and (Prv = Ret[RetNo].Province) then result :=True; //20260118cz

  }


   //jz??
   {
   //if Certificationmode=true then exit; //jz?? true or false?


   //20220408
   if (Ret[RetNo].Province='ZZ')
   or (FetchElmFNo(RetNo,InfoFNo,189)>'')  //zero out prov tax //20220413
   then   //zeroout prvtax
   Begin
    Result:=False;
    Ret[RetNo].Lnn[47900]:=0;
    StoreElm(RetNo,GetFormNo('T1'),427,'');
    Exit;
   end; //20220407
   }
   {
   Result := False;

   If (not IsMultJurisdiction(RetNo)) and (Prv = Ret[RetNo].Province) then
       begin result :=True; exit; end;

   T3MJFNo:=GetFormNo('T3MJ');  //20230508 relocated from above
   If IsMultJurisdiction(RetNo) then     //check income allocated
   begin
    if (Prv='NL') and (Vl(FetchElmFNo(RetNo,T3MJFNo,7))>0) then
     begin Result:=True;Exit; end;
    if (Prv='PE') and (Vl(FetchElmFNo(RetNo,T3MJFNo,14))>0) then
     begin Result:=True;Exit;end;
    if (Prv='NS') and (Vl(FetchElmFNo(RetNo,T3MJFNo,21))>0) then
     begin Result:=True;Exit;end;
    if (Prv='NB') and (Vl(FetchElmFNo(RetNo,T3MJFNo,28))>0) then
     begin Result:=True;Exit;end;
    if (Prv='QC') and (Vl(FetchElmFNo(RetNo,T3MJFNo,35))>0) then
     begin Result:=True;Exit;end;
    if (Prv='ON') and (Vl(FetchElmFNo(RetNo,T3MJFNo,42))>0) then
     begin Result:=True;Exit;end;
    if (Prv='MB') and (Vl(FetchElmFNo(RetNo,T3MJFNo,49))>0) then
     begin Result:=True;Exit;end;
    if (Prv='SK') and (Vl(FetchElmFNo(RetNo,T3MJFNo,56))>0) then
     begin Result:=True;Exit;end;
    if (Prv='AB') and (Vl(FetchElmFNo(RetNo,T3MJFNo,63))>0) then
     begin Result:=True;Exit;end;
    if (Prv='BC') and (Vl(FetchElmFNo(RetNo,T3MJFNo,70))>0) then
     begin Result:=True;Exit;end;
    if (Prv='YT') and (Vl(FetchElmFNo(RetNo,T3MJFNo,77))>0) then
     begin Result:=True;Exit;end;
    if (Prv='NT') and (Vl(FetchElmFNo(RetNo,T3MJFNo,84))>0) then
      begin Result:=True;Exit;end;
    if (Prv='NU') and (Vl(FetchElmFNo(RetNo,T3MJFNo,105))>0) then
     begin Result:=True;Exit;end;
    if (Prv='ZZ') and (Vl(FetchElmFNo(RetNo,T3MJFNo,91))>0) then
     begin Result:=True;Exit;end;
 end;

 //jz??
 {NR with empl income in the province}
 {f (IsNonResWithCanEmpl(RetNo))
 and (EmplIncInProv(RetNo,Prv)>0)
  then result:=True;
 }
end;




//mjjz2024
Function GetMjAllocBusinessIncomeProv(RetNo: Integer): String;
Var i,provWithAllocatedIncomeCount,T3MJFNo:Integer;
begin
  result := '';
  T3MJFNo:=GetFormNo('T3MJ');  //20230508 relocated from above

  provWithAllocatedIncomeCount := 0;
  if FetchElmFNo(RetNo,T3MJFNo,   5) > '' then begin result := 'NL'; inc(provWithAllocatedIncomeCount); end;
  if FetchElmFNo(RetNo,T3MJFNo,  12) > '' then begin result := 'PE'; inc(provWithAllocatedIncomeCount); end;
  if FetchElmFNo(RetNo,T3MJFNo,  19) > '' then begin result := 'NS'; inc(provWithAllocatedIncomeCount); end;
  if FetchElmFNo(RetNo,T3MJFNo,  26) > '' then begin result := 'NB'; inc(provWithAllocatedIncomeCount); end;
  if FetchElmFNo(RetNo,T3MJFNo,  33) > '' then begin result := 'QC'; inc(provWithAllocatedIncomeCount); end;
  if FetchElmFNo(RetNo,T3MJFNo,  40) > '' then begin result := 'ON'; inc(provWithAllocatedIncomeCount); end;
  if FetchElmFNo(RetNo,T3MJFNo,  47) > '' then begin result := 'MB'; inc(provWithAllocatedIncomeCount); end;
  if FetchElmFNo(RetNo,T3MJFNo,  54) > '' then begin result := 'SK'; inc(provWithAllocatedIncomeCount); end;
  if FetchElmFNo(RetNo,T3MJFNo,  61) > '' then begin result := 'AB'; inc(provWithAllocatedIncomeCount); end;
  if FetchElmFNo(RetNo,T3MJFNo,  68) > '' then begin result := 'BC'; inc(provWithAllocatedIncomeCount); end;
  if FetchElmFNo(RetNo,T3MJFNo,  75) > '' then begin result := 'YT'; inc(provWithAllocatedIncomeCount); end;
  if FetchElmFNo(RetNo,T3MJFNo,  82) > '' then begin result := 'NT'; inc(provWithAllocatedIncomeCount); end;
  if FetchElmFNo(RetNo,T3MJFNo, 103) > '' then begin result := 'NU'; inc(provWithAllocatedIncomeCount); end;
  if FetchElmFNo(RetNo,T3MJFNo,  89) > '' then begin result := 'EX'; inc(provWithAllocatedIncomeCount); end;  //is this what 'EX' means???

  if provWithAllocatedIncomeCount > 1 then result := 'MJ';

end;



Function SiftTrust(RetNo:Integer):Boolean;
begin
 Result:=False;
 if FetchElm(RetNo,'T3',81)='338' then result:=True;

end;

function ValidBusNumberFull(RetNo: integer; BN: string): Boolean;
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
  if (UpperCase(BN[10] + BN[11]) = 'RC')
  Or (UpperCase(BN[10] + BN[11]) = 'RR')   //20250729
  then
  //ok
  Else
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

Function isCanadianProvince(PRV: String): boolean;
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

Function CountS15(RetNo:Integer):Integer;  //20240319
Var i:Integer;
Begin
 for I := 0 to (FList.Count - 1) do
 begin
  FRec := FList.Items[I];
  If FRec.FormName='S15' then
  Begin
   If Ret[RetNo].FrmHasData[FRec.FormNo] then inc(result);
  End;
 end;
 ShowMessage('S15 count = '+IntToStr(result));
end;

Procedure DeleteLastS15(RetNo:Integer); //20240319
Var i, k:Integer;FNo:Integer;Faname:String;
Begin
 FNo:=GetLastS15FNo(RetNo);
 if FNo>1 then
 begin
   if FetchElmFNo(RetNo,FNo,5)+FetchElmFNo(RetNo,FNo,6)='' then
    Begin
      For i:=1 to 17 do StoreElm(RetNo,FNo,i,'');
    End;
 End;
End;


Function GetLastS15FNo(RetNo:Integer):Integer;  //20240319
Var i:Integer;
Begin
 for I := 0 to (FList.Count - 1) do
 begin
  FRec := FList.Items[I];
  If FRec.FormName='S15' then
  Begin
   If Ret[RetNo].FrmHasData[FRec.FormNo] then Result:=FRec.FormNo;
  End;
 end;
end;


//jz 20240406 add specialreturns r1
Function getSpecialEfileStatusElms(RetNo:integer;fName:string):TSpecialEfileStatusElms;
var
  spElms:TSpecialEfileStatusElms;
begin

  //jz//20260318 - T3 and T1135 are handled separately, should they be? comment out for now
  //if      fName='T3'    then begin spElms.spAmendedIndicatorElm :=  ; spElms.spRevisionIndicatorElm :=  ; spElms.spConfirmationNumElm :=  ; end
  //if      fName='T1135' then begin spElms.spAmendedIndicatorElm :=  22; spElms.spRevisionIndicatorElm :=  65; spElms.spConfirmationNumElm :=  39; end


       if fName='T3M'   then begin spElms.spAmendedIndicatorElm :=  20; spElms.spRevisionIndicatorElm :=  69; spElms.spConfirmationNumElm :=  68; end
  else if fName='T3RCA' then begin spElms.spAmendedIndicatorElm := 230; spElms.spRevisionIndicatorElm := 231; spElms.spConfirmationNumElm := 232; end
  else if fName='T3ATH' then begin spElms.spAmendedIndicatorElm :=  56; spElms.spRevisionIndicatorElm :=  68; spElms.spConfirmationNumElm :=  69; end
  else if fName='T3D'   then begin spElms.spAmendedIndicatorElm :=   1; spElms.spRevisionIndicatorElm := 340; spElms.spConfirmationNumElm := 341; end
  else if fName='T3P'   then begin spElms.spAmendedIndicatorElm :=   1; spElms.spRevisionIndicatorElm :=  79; spElms.spConfirmationNumElm :=  80; end
  else if fName='T3PRP' then begin spElms.spAmendedIndicatorElm :=   1; spElms.spRevisionIndicatorElm :=  53; spElms.spConfirmationNumElm :=  79; end
  else if fName='T3GR'  then begin spElms.spAmendedIndicatorElm :=   1; spElms.spRevisionIndicatorElm :=  10; spElms.spConfirmationNumElm :=  71; end
  else if fName='T3RI'  then begin spElms.spAmendedIndicatorElm :=   1; spElms.spRevisionIndicatorElm := 244; spElms.spConfirmationNumElm := 245; end
  else if fName='T3S'   then begin spElms.spAmendedIndicatorElm :=  56; spElms.spRevisionIndicatorElm :=  52; spElms.spConfirmationNumElm :=  53; end
  else if fName='T1061' then begin spElms.spAmendedIndicatorElm :=  42; spElms.spRevisionIndicatorElm :=  43; spElms.spConfirmationNumElm :=  44; end
  else                       begin spElms.spAmendedIndicatorElm :=  00; spElms.spRevisionIndicatorElm :=  00; spElms.spConfirmationNumElm :=  00; end;

  result := spElms;
end;


Function ifAmendedPopulateInitialRevNum(RetNo:integer;fName:string):string;
var
  spElms:TSpecialEfileStatusElms;
  confirmationNum, amendedIndicatorVal, revisionIndicatorVal:string;
begin
  spElms := getSpecialEfileStatusElms(RetNo,fName);
  amendedIndicatorVal  := FetchElm(RetNo,FName,spElms.spAmendedIndicatorElm);
  revisionIndicatorVal := FetchElm(RetNo,FName,spElms.spRevisionIndicatorElm);

  result := revisionIndicatorVal;

  if       amendedIndicatorVal = ''   then
    result := ''      //jz//20260315 - if not amended cannot have revision number
  else if (amendedIndicatorVal  > '') and
          (revisionIndicatorVal = '') then
    result := 'R0';   //jz//20260315 - otherwise put initial value R0.. note: R1 maybe makes more sense but dont want to change what i've already done now
end;

//jz 20240405 add specialreturns efile button
Function specialReturnEfileStatus(RetNo:integer;fName:string):TspecialReturnEfileStatus;
var
  spElms:TSpecialEfileStatusElms;
  confirmationNum, amendedIndicator, revisionIndicator:string;
begin

  spElms := getSpecialEfileStatusElms(RetNo,fName); //jz 20240406 add specialreturns r1

  amendedIndicator  := FetchElm(RetNo,FName,spElms.spAmendedIndicatorElm);
  revisionIndicator := FetchElm(RetNo,FName,spElms.spRevisionIndicatorElm);
  confirmationNum   := FetchElm(RetNo,FName,spElms.spConfirmationNumElm);

  result := spNotEfiled;

  if confirmationNum > '' then //has a confirmation num and no amended indicator
  begin
    result := spOriginalEfiled;

    if amendedIndicator = 'X' then
    begin
      result := spOriginalEfileAmended;                                       //original after amend
      //if      revisionIndicator = 'R1' then result := spOriginalEfileAmended  //original after amend //jz//20260318
      if revisionIndicator >= 'R1' then result := spAmendedEfileRetransmitted; //retransmission
    end;
  end;

end;


Function IsDisabilityTrust(RetNo:Integer):boolean;
begin
 Result:=False;
 if FetchElm(RetNo,'T3',45)>'' then result:=true;
end;


//20260115 Igor >>>
function GetT1134ForeignAffiliatesIdentificationNumber(ARetNo: Integer; AName: string): string;
var
  FormNo, i: integer;

  function GetForeignAffiliatesNumber(ArrayNo, ElmNameId, ElmNumberId: integer): string;
  var
    BoxesPerRow, ElmName, ElmNumber, RowCount, i: integer;
  begin
    BoxesPerRow:= RetList[ARetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
    ElmName:= ArrayNo * 10000 + ElmNameId;
    ElmNumber:= ArrayNo * 10000 + ElmNumberId;
    RowCount:= DynamicRowCount(ARetNo, FormNo, ArrayNo);

    for i:= 0 to RowCount - 1 do
    begin
      if SameText(AName, FetchElmFNo(ARetNo, FormNo, ElmName)) then
      begin
        Result:= FetchElmFNo(ARetNo, FormNo, ElmNumber);
        Break;
      end;

      ElmName:= ElmName + BoxesPerRow;
      ElmNumber:= ElmNumber + BoxesPerRow;
    end;
  end;

begin
  for i:= 1 to 10 do
  begin
    FormNo:= GetFormNo('T1134S#' + IntToStr(i));

    if FormNo > 0 then
      if SameText(FetchElmFNo(ARetNo, FormNo, 35), AName) then
      begin
        Result:= FetchElmFNo(ARetNo, FormNo, 4);
        Break;
      end;
  end;

  FormNo:= GetFormNo('T1134');
  if Result.IsEmpty then Result:= GetForeignAffiliatesNumber(7, 4, 5);
end;

procedure PopulateT1134ForeignAffiliates(ARetNo: Integer; AList: TStringList);
var
  FormNo, i: Integer;
  TempList: TStringList;

  procedure AddToList(AValue: string);
  begin
    if not AValue.IsEmpty and (TempList.IndexOf(AValue) = -1) then
      TempList.Add(AValue);
  end;

  procedure PopulateForeignAffiliates(ArrayNo, ElmId: integer);
  var
    BoxesPerRow, ElmName, RowCount, i: integer;
  begin
    BoxesPerRow:= RetList[ARetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
    ElmName:= ArrayNo * 10000 + ElmId;
    RowCount:= DynamicRowCount(ARetNo, FormNo, ArrayNo);

    for i:= 0 to pred(RowCount) do
    begin
      AddToList(FetchElmFNo(ARetNo, FormNo, ElmName));
      ElmName:= ElmName + BoxesPerRow;
    end;
  end;

begin
  AList.Text:= FetchElm(ARetNo, 'STATUS', T1134_FA_LIST);
  TempList:= TStringList.Create;
  try
    for i:= 1 to 10 do
    begin
      FormNo:= GetFormNo('T1134S#' + IntToStr(i));

      if (FormNo > 0) then AddToList(FetchElmFNo(ARetNo, FormNo, 35));
    end;

    FormNo:= GetFormNo('T1134');
    PopulateForeignAffiliates(7, 4);

    // remove non existing
    for i:= pred(AList.Count) downto 0 do
      if (TempList.IndexOf(AList.Strings[i]) = -1) then AList.Delete(i);

    // add new
    for i:= 0 to pred(TempList.Count) do
      if (AList.IndexOf(TempList.Strings[i]) = -1) then AList.Add(TempList.Strings[i]);
  finally
    TempList.Free;
  end;
  StoreElm(ARetNo, 'STATUS', T1134_FA_LIST, AList.Text);
end;

function GetT1134GroupList(ARetNo: integer): TArray<T1134GroupItem>;
var
  FormNo: Integer;

  procedure AddItem(AName, ANumber: string; AType: TGroupItemAccountType);
  begin
    SetLength(Result, succ(Length(Result)));
    Result[Length(Result) - 1].Name:= AName;
    Result[Length(Result) - 1].AccountNumber:= ANumber;
    Result[Length(Result) - 1].AccountType:= AType;
  end;

  procedure PopulateGroupList(ArrayNo: integer; AType: TGroupItemAccountType; ElmNumberId, ElmNameId: integer; ElmName2Id: integer = 0);
  var
    BoxesPerRow, ElmName, ElmName2, ElmNumber, RowCount, i: integer;
    ValueName, ValueName2, ValueNumber: string;
  begin
    BoxesPerRow:= RetList[ARetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
    ElmNumber:= ArrayNo * 10000 + ElmNumberId;
    ElmName:= ArrayNo * 10000 + ElmNameId;
    ElmName2:= ArrayNo * 10000 + ElmName2Id;
    RowCount:= DynamicRowCount(ARetNo, FormNo, ArrayNo);

    for i:= 0 to pred(RowCount) do
    begin
      ValueNumber:= FetchElmFNo(ARetNo, FormNo, ElmNumber);
      ValueName:= FetchElmFNo(ARetNo, FormNo, ElmName);

      if (ElmName2Id <> 0) then
      begin
        ValueName2:= FetchElmFNo(ARetNo, FormNo, ElmName2);

        if not ValueName2.IsEmpty then
          if ValueName.IsEmpty then ValueName:= ValueName2 else ValueName:= ValueName + ' ' + ValueName2;
      end;
      if not ValueName.IsEmpty and not ValueNumber.IsEmpty then AddItem(ValueName, ValueNumber, AType);

      ElmNumber:= ElmNumber + BoxesPerRow;
      ElmName:= ElmName + BoxesPerRow;

      if (ElmNameId <> 0) then ElmName2:= ElmName2 + BoxesPerRow;
    end;
  end;

begin
  FormNo:= GetFormNo('T1134');
  //AddItem(FetchElmFNo(ARetNo, FormNo, 2) + ' ' + FetchElmFNo(ARetNo, FormNo, 3), FetchElmFNo(ARetNo, FormNo, 5), atIndividual); //20260817 Alex
  AddItem(FetchElmFNo(ARetNo, FormNo, 10), FetchElmFNo(ARetNo, FormNo, 11), atTrust); //20260817 Alex
  PopulateGroupList(1, atIndividual, 10, 1, 3);
  PopulateGroupList(2, atCorporation, 8, 1);
  PopulateGroupList(3, atTrust, 8, 1);
  PopulateGroupList(4, atPartnership, 8, 1);
end;

procedure PopulateT1134GroupList(ARetNo: Integer; AList: TStringList; AShowName: Boolean);
var
  Arr: TArray<T1134GroupItem>;
  i: integer;
begin
  Arr:= GetT1134GroupList(ARetNo);

  for i:= 0 to pred(Length(Arr)) do
    if AShowName then AList.Add(Arr[i].AccountNumber + ' - ' + Arr[i].Name) else AList.Add(Arr[i].AccountNumber);
end;


procedure PopulateT1134SGroupList(ARetNo, AFormNo: integer; AList: TStringList; AOnlyArrayNo: integer = 0);

  procedure PopulateList(AArrayNo: integer);
  var
    BoxesPerRow, elm, RowCount, i, j: integer;
    ValueName, ValueNumber: string;
  begin
    BoxesPerRow:= RetList[ARetNo].Frm[AFormNo].FormDataRec.BoxesPerRow[AArrayNo];
    elm:= AArrayNo * 10000;
    RowCount:= DynamicRowCount(ARetNo, AFormNo, AArrayNo);

    for i:= 0 to pred(RowCount) do
    begin
      for j in [2, 3, 4, 5] do
      begin
        ValueNumber:= FetchElmFNo(ARetNo, AFormNo, elm + j);
        if not ValueNumber.IsEmpty then Break;
      end;

      ValueName:= FetchElmFNo(ARetNo, AFormNo, elm + 1);

      if not ValueName.IsEmpty and not ValueNumber.IsEmpty then AList.Add(ValueNumber + ' - ' + ValueName);
      elm:= elm + BoxesPerRow;
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
//20260115 Igor <<<

//20260309 Igor >>>
function PCPM(aVal, aPercent: Currency): Currency; //Perform the Correct Percentage Multiplication
var
  lReal: Currency;
begin
  Result:= RoundTo(aVal, -2);
  Result:= RoundTo(Result * aPercent, -2);
end;
//20260309 Igor <<<

//jz//20260311 - taken from t1
procedure saveXMLWithNoCRAPasswordID(savelocation: string; AList: TStringList; SaveTheXML: Boolean);
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
        if      Pos('<ef:PasswordID>', atempList[i]) > 0 then atempList[i] := '<ef:PasswordID>*redacted*</ef:PasswordID>'
        else if Pos('"passwordId"'   , atempList[i]) > 0 then atempList[i] := '      "passwordId":"*redacted*",';
      end;
      atempList.SaveToFile(savelocation);
      atempList.Free

    end;
  end;
end;

//20260321
Function GetShortYearfactor(RetNo:Integer):real;
begin
 result:=1;
end;

//20260816
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
 //20260825cz
 {
 or (upperCase(Fname)='T1134')
 or (upperCase(Fname)='T106')
 or (upperCase(LeftStr(Fname,6))='T1134S')
 or (upperCase(LeftStr(Fname,5))='T106S')
 }
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

//20260817 Alex >>>
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

   Result:= sAppYear + Sdd + SSec + '1'{RightStr(GetBirthdate(RetNo), 1)} + RightStr(SMSec, 1);//2005
   //If length(result)<> 13 then result:='';
end;

function GetWACNumber(RetNo: integer): string;
begin
  Result:= '';//FetchElm(RetNo, 'T2', 75);
end;

function ValidForT106Efile(RetNo: Integer; FNo: Integer): Boolean;
begin
  Result:= True;
end;

function TotMultipleExludingDeletedSlips(RetNo: integer; NonInstFormName: string; Elm: integer; dElm: integer; deleteString: string): Real;
var
  i, FNo: integer;
begin
  Result:= 0;
  for i:= 0 to pred(FList.Count) do
  begin
    FRec:= FList.Items[i];

    if (FRec.FormName = NonInstFormName) and (Ret[RetNo].FrmHasData[FRec.FormNo]) and (FetchElmFNo(RetNo, FRec.FormNo, dElm) <> deleteString) then
      Result:= Result + VL(FetchElmFNo(RetNo, FRec.FormNo, Elm));
  end;
end;
//20260817 Alex <<<

end.
