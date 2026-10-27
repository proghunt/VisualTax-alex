unit FP_2027TrimStr;

{$B-}
(*
  Simple interest : F:=P(1+ni)
  Compound interest: FV=PV(1+i) raised to n
  PV = FV/(1+i) raised to n
  Annuity: FV = A * ((1+i) raised to n)-1) /i
  PV =A* (1-(1+i) raised to -n)/i
*)

interface

uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,StdCtrls,Dialogs,DBctrls,ExtCtrls,Printers,DB,ShellApi,
  RichEdit,Math,DbiProcs,DbiErrs,DbiTypes,FP_2027Declare,IniFiles,
  VclTee.TeEngine, VclTee.Series, VclTee.TeeProcs, VclTee.Chart, {Psock, NMHttp,} //20150818 igor

  Registry,ComCtrls,vtEditBox,vtLabel,
  vtShape, ekfunc, EkRtf, ekbasereport, vtMulti,

  rxRichEd; //20160819 Igor (Must be last)

Procedure SaveT1LineDataInTXSUM(RetNo:Integer;Whom:Integer);
Function GetTaxOnBase(Bracket,PrevBracket,PrevPercent,PrevBaseTax:Real):Real;
Function GetIndexedAmount(StartBal:Real;IndexBy:Real;Years:Integer):Real;
Function FormAllowed(Fname:String):Boolean;
Function IsPowerVersion:Boolean;
Function GetPrintTemplate:string;
Function PopulateAssetsDbf(RetNo:Integer):Integer;
Procedure LoadTreeView(FlName:String;SectionId:Integer);
Procedure InitIncProjectionFromCashFlow(RetNo:Integer);
Function MkFileName(RetNo:Integer):String;
Function GetPlanDate(RetNo:Integer):String;
Procedure BuildBusinessProjection(RetNo:Integer);
Procedure BuildBusinessEvents(RetNo:Integer);
procedure ChartBusiness(RetNo:Integer;TempCanvas:TBitMap;R:TRect;YearOrAge:Boolean;ProjectionList:TList);
Function GetMinBusiness(RetNo:Integer;BusinessProjectionList:TList):Real;
Function GetMaxBusiness(RetNo:Integer;BusinessProjectionList:TList):Real;

Procedure SummarizeAssets (RetNo:Integer);
Procedure InitTaxRec;
procedure ChartCashFl(RetNo:Integer;TempCanvas:TBitMap;R:TRect;YearOrAge:Boolean;ProjectionList:TList);
Function GetMinCashFlBalance(RetNo:Integer;CashFlProjectionList:TList):Real;
Function GetMaxCashFlBalance(RetNo:Integer;CashFlProjectionList:TList):Real;

Function GetMinIncome(RetNo:Integer;CashFlProjectionList:TList):Real;
Function GetMaxIncome(RetNo:Integer;CashFlProjectionList:TList):Real;

procedure ChartNetWorth(RetNo:Integer;TempCanvas:TBitMap;R:TRect;YearOrAge:Boolean;NetWorthProjectionList:TList);
Function GetMinNetWorthBalance(RetNo:Integer;NetWorthProjectionList:TList):Real;
Function GetMaxNetWorthBalance(RetNo:Integer;NetWorthProjectionList:TList):Real;
Function GetMinLiabilityBalance(RetNo:Integer;LiabilitiesProjectionList:TList):Real;
Function GetMaxLiabilityBalance(RetNo:Integer;LiabilitiesProjectionList:TList):Real;
procedure ChartLiabilities(RetNo:Integer;TempCanvas:TBitMap;R:TRect;YearOrAge:Boolean;ProjectionList:TList);
Function GetRetNoFromSin(Sin:String):Integer;
Procedure InitModelPortfolioFile;
function OpenModelPortfolioFile(ShowSw:Boolean): integer;
//Procedure OpenModelPortfolioFile(RetNo:Integer;ShowSw:Boolean);
Procedure SaveModelPortfolio(RetNo:Integer);
//Procedure ImportModelPortfolio(FromRetNo,ToRetNo:Integer;ToFInst:String);
Procedure ImportModelPortfolio(ToRetNo:Integer;FormName:String);
Procedure SummarizeLifeIns(RetNo:Integer);
Function GetFormType(FName:String):String;
function IsLandscape(FName: String):Boolean;
procedure ChartIncome(RetNo:Integer;TempCanvas:TBitMap;R:TRect;YearOrAge:Boolean;ProjectionList:TList);

Function IsStringInList(s:String;Alist:TStringList):Integer;
Procedure PutValuesInElmList(FrmNm:String;DataList:TStringList;ElmList:TStringList);
Function CreateDataDirectory(Appdir: string; DataDir:string): integer;
Function IsInMostRecentReturns(FlName: String; MostRecentList: TstringList): Integer;
Function GetRetName(RetNo:integer): string;
procedure BuildSuperEntries(FullFlName:String);
//keep app-specific delegate
Function EditDate(S:String;MnYear,MxYear:integer):Boolean;
Function GetFldTapeFormNo(RetNo:Integer;RefFormName,RefFieldId:String):Integer;
Function GetEmptyInstance(RetNo:Integer;FormName:String):Integer;
Function GetHowToFormat(FrmName:String;Elm:Integer):Integer;
function GetFormAbrevName(FormNo: integer):String;
Procedure AutoFormatDate(Var Value:String);
Function InitDataBase(AppDir: string; DataDir: string): boolean;
Procedure BuildExperience(FrmNm:String;FromElm,ToElm,ByElm:Integer;FlName:String;ElmList:TStringList;DataList:TStringList);
Function GetFastPrintIndicator:Boolean;
procedure ShowPdf(PgmPath,PgmFile:String);
procedure ConnectToWeb(Url:String);

Procedure InitMostRecentFiles(HowMany:Integer);
Procedure UpdateMostRecentFiles(RetNo:Integer;Dir,FlName,Sin:String);
Function FindWord(ThisWord,Ln:String):Integer;
Procedure InitPredictiveFiles;
Function PrintLabels(DataDir,FileNm:String):boolean;
Procedure PrintALabel(LabelPosX,LabelPosY:integer;Line1,Line2,Line3,Line4,Line5:String);
Procedure FixAProperty;
Function GetFormRlNm(FName: String):String;
//Procedure BuildHistoryData(RetNo:Integer;FullFlName:String;K:Integer);
Function IncrString(s:String;ByValue:Integer):String;

procedure ModifyAllForms;
function ModifyFormOrText(FileToConvertFrom:string;ConversionType:String):Boolean;

Function LandscapeFormsInFEDReturn(RetNo:Integer):Boolean;
Function LandscapeFormsInONTReturn(RetNo:Integer):Boolean;
Function LandscapeFormsInALBReturn(RetNo:Integer):Boolean;

Function GetFNoOfFirstInstance(FName:String;FNo:Integer):Integer;
Function IsValidTrustNo(S:String):Boolean;
Function GetTrTopicFromLineRef(FormName:String;FieldId:Integer):String;
procedure PrintAtAngle(AText:String;ACanvas:TCanvas;Xpos:Integer;YPos:Integer;FontSize:Integer;AtAngle:Integer);
Procedure InsertKeyWToDataDict(FormName:String;AnEditBox:TvtEdit);
Function RemoveHyphens(S:string):string;
Function GetFldMemFormNo(RetNo:Integer;RefFormName,RefFieldId:String):Integer;
Procedure InitRichEditStorage(RetNo:Integer);
Procedure GetLoginNames(TempList:TStringList);
Procedure UpdateLoginNames(Nm:String);
procedure ReplaceRtfText(ARichEdit:TRichEdit;InSearch, InReplace: string) ;
Procedure ConvertOldLetter(ARichEdit:TRichEdit);
Function IsConditionalRtfStatement(KeyW:String):Boolean;
Procedure GetDelimiterPositionsInRtf(ARichEdit: TRichEdit; SearchText: string;DelimList:TStrings);
Function FirstTimeClient(RetNo:Integer):Boolean;
Procedure ReadTheValue(TempList:TstringList;FrmNm:String;Elm1,Elm2:Integer;Var Val1,Val2:String);
Procedure AddDisplayFormatToRtf(ARichEdit:TRichEdit;KeyWList:TStringList);
Procedure ReplaceRtfDelimiters(ARichEdit:TRichEdit;FromDelim,ToDelim:String);
procedure InsertBackFunction(ARichEdit:TRichEdit;InSearch, InSecondSearch, InReplace: string);
function ConvertToProper(s: string):string;
Function GetKeyWListFromRichEdit(ARichEdit:TRichEdit;KeyWList:TStrings):Boolean;
Function GetFormHeight(FName:string):Integer;
function GetFormNumberFields(FNo: integer):integer;
function GetMaxFormNumber:integer;

Function IsOkToOpenReturn(DataDir:String;FlName:String;Sin:String):Boolean;
function  CheckReturnPsw(Datadir:string;FlName:string):integer;
Procedure RemoveReturnPsw(RetNo:Integer);
Procedure StoreReturnPsw(RetNo:Integer;RetPsw:String);

function  LicenseLevel: eLicenseLevel;
function  LicenseName: string;
Function IsEnterpriseVersion: Boolean; //20231211 Igor
Procedure CreateDefaultDataDirectories;
Procedure ExtractSectionLabels(FName:String;LblSectList,SomeList:TStrings);
function GetInterpretedRichEdit(RetNo:Integer;LetterName:String;ARichEdit:TRichEdit): Boolean; //20160819 igor
Function GetLetterFileName(RetNo:Integer;FName:String):String;
Function LinkToSelf(InitialFormName:String;TargetFormName:String):Boolean;
Procedure GetFrmDataListFromFullDataList(FrmNm:String;DataList,FrmDataList:TStringList);
Procedure GetElmsInError(RetNo:Integer;FName:String);
Function IsFieldInElmsInError(s:String;Alist:TStringList):Integer;
function GetFormAbrevNameWithNoInst(FormNo: integer):String;
Function FieldHasAddingTape(RetNo:Integer;FName:String;Elm:Integer):Boolean;
Function IsInvoiceLocked(RetNo:Integer):Boolean;
Function GetDfmFormsDir:String;
Function IsFormAClientLetter(FName:String):Boolean;
function isCollectionForm(const AFormName: String): Boolean;//20170409 Igor
Function GetAnyPathMoreThan8Chars(Dir:String):String;
Function ValidEMail(s:String):Boolean;
Function RealNumeric(S:string):Boolean;
Function CopyMoveReturn(CopyOrMove:String;FromDir:String;ToDir:String;FlName:String):Boolean;

Function StripInstNo(FormName: String): string;
Procedure ResortFormsToPrint(FormsToPrint:TStringList);
Function AllowedToFullPrint(RetNo:Integer):Boolean;
Function CreateNewDataDir:String;
Function AllowedToFormPrint(RetNo:Integer):Boolean;
Procedure IsAnyWhereInList(Astring:String; AList: TstringList; ResultsList:Tstrings);
Function IsExactlyInList(Astring:String; SomeList: TstringList):Integer;
Function ValidShortProvince(s:string):Boolean;
Function IsFormTheDefaultSearch:Boolean;
Procedure ConvertCfgToOptionsFile(CfgTbl:TDataSet);
Procedure InitOptions;
Procedure SetDefaultOptions; //20160523 Igor //20160627 Igor
Function GetDefaultOptionsValue(const AOptionsName: String): String; //20160627 Igor
function GetDefaultOptions: TStringList; //20160627 Igor
function GetOptionsCaption(AOptionsName: String): String; //20160627 Igor
function HaveOptions(AOptionsName: String): Boolean; //20170112 Igor
Procedure LoadOptionsFileToMem;
Procedure SaveSingleOption(FieldNm, Value: string; AOptionsFileName: String = ''); //20160627 Igor

Function StringToBoolean(AString:String):Boolean;
function GetFileList(FDirectory, Filter: TFileName): TStringList;
Function IncrementlastBackUpDir(LastBackUp:String):String;
Function GetDefaultScaling:Integer;
// ************ above for dfm

Function GetDefaultDataBaseDir:String;
//Function StripInstNo(FormName: String): string;
//20170901 Igor>>>
//Function ExceedsMaxReturnsAllowed:Boolean;
//Function CountDBRecords:Integer;
//20170901 Igor<<<
Function CalcEstimatedTax(TotIncome:Real;Dividends:Real):Real;
Function GetDedLimit(EarnedInc,PriorYrPA,PriorYrUnusedRoom:Real;Year:Integer):Real;
Function GetDollarLimit(Year:Integer):Real;
procedure GetPaymentsTable(Principal:Real;Interest:Real;Years:Integer;
  PeriodNoList,InterestPaidList, PrincipalPaidList,BalanceRemainingList:TStrings);

Function IsT1Installed:Boolean;
Function GetMarStatus(RetNo:Integer):Integer;
function IsDelphiForm(FormNo: Integer):boolean;
Function GetMonthyMortgage(Principal:Real;Interest:Real;Years:Integer;Compounding:Integer):Real;
procedure GetMortgageTable(Principal:Real;Interest:Real;Years:Integer;
  PeriodNoList,InterestPaidList,PrincipalPaidList,BalanceRemainingList:TStrings);


Procedure BuildInvDetailProjection(RetNo:Integer);
Procedure BuildInvProjection(RetNo:Integer);
procedure ChartFixedAssets(RetNo:Integer;TempCanvas:TBitMap;R:TRect;YearOrAge:Boolean;ProjectionList:TList);
Function GetMinFixedAssetsBalance(RetNo:Integer;FixedAssetsProjectionList:TList):Real;
Function GetMaxFixedAssetsBalance(RetNo:Integer;FixedAssetsProjectionList:TList):Real;
Procedure BuildFixedAssetsProjection(RetNo:Integer);
Procedure BuildFixedAssetsEvents(RetNo:Integer);


Procedure  PutFixedAssetsStartBalanceInProjection(RetNo:Integer;AsOfYear:String;
       Autos,Homes,VacationPr,IncomeProp,OtherFixed,
       AutosOrigCost,HomesOrigCost,VacationPrOrigCost,IncomePropOrigCost,OtherFixedOrigCost:Real);

Procedure  PutBusinessStartBalanceInProjection(RetNo:Integer;AsOfYear:String;
       BusIncorp,BusNonIncorp,Other,
       BusIncorpOrigCost,BusNonIncorpOrigCost,OtherOrigCost:Real);

Procedure BuildLiabilitiesProjection(RetNo:Integer);
Procedure BuildNetWorthProjection(RetNo:Integer);
Procedure BuildAssetsProjection(RetNo:Integer);
Procedure BuildCashFlowProjection(RetNo:Integer);
Procedure BuildRRSPProjection(RetNo:Integer);
Procedure BuildRIFStream(RetNo:Integer;OpeningBalance:Real;YearRifStarted:Integer;Rules:String;Rate:Real);
Procedure BuildAllRIFs(RetNo:Integer);
Procedure BuildLiabilityEvents(RetNo:Integer);
Procedure PutLiabilityEventInProjection(RetNo:Integer;FromYear:String;ToYear:String;
  MortgageAmount,AutosAmount,OtherAmount,MonthlyMortgage,MonthlyAuto,MonthlyOther:Real);

Function GetTotalEndBalanceByYear(RetNo:Integer;Year:String):Real;
Procedure GetEduYearsList(RetNo:Integer;EduYearsList:TStrings);
Function GetT1Year:String;
Function GetT1ProgramCommand:String;
Procedure PutEventInBalanceList(RetNo:Integer;Description:String;
   FromYear:String;ToYear:String;EventType:String;YearlyAmount:Real;
   NonShPercent,SemShPercent,SheltPercent,OtherPercent :Real);
procedure StartT1;
procedure StopT1;
Function GetTuitionCost(Prv:String):Real;
Function GetTuitionEscal(Prv:String):String;
Function CountEducationKids(RetNo:Integer):Integer;
Function GetEduIndexForAKid(RetNo:Integer;WhichNo:Integer):Integer;
Procedure ReadUdlInfo(UdlFileName:String;Var ProviderName:String;Var DataSourceName:String);
Procedure SaveUdlInfo(UdlFile:String;Provider:String;DataSource:String);
Procedure ParseUdlInfo(UdlFileName:String;Var ProviderName:String;Var DataSourceName:String);
Function GetCurYear:String;
Function IsAgentDemo:Boolean;
Function GetAssumedIntDivCapG(RetNo: integer; AssetCls:String):String;
Function GetIntDivCapGpercent(AssetCls:String):String;
Function GetHistoricalRateOfReturn(AssetCls:String):String;
Function GetAssumedHistRateOfReturn(RetNo: integer; AssetCls:String):String;
Function IsRocheSystem:Boolean;
Function GetNonShRate(RetNo:Integer):Real;
Function GetSheltRate(RetNo:Integer):Real;
Function GetSemiShRate(RetNo:Integer):Real;
Function GetOtherRate(RetNo:Integer):Real;
Function StrToTwoDecimals(S:String):String;

Function AnnuityPv(A:Real;Interest:real;n:integer):Real;
Function AnnuityWithDrawal(TotalAmount:Real;Interest:real;n:integer):Real;
Function AnnuityPerPeriod(Amount:Real;Interest:real;n:integer):Real;
Function AnnuityFVOfDollar(Interest:real;n:integer):Real;
Function AnnuityFV(Amount:Real;Interest:real;n:integer):Real;
Procedure GenChartBMP(ChartHeader:String;TempCanvas:TBitMap;R:TRect;HorizontalList:TStringList;VerticalList:TStringList);
Function GetMinValInList(AList:TStringList):Real;
Function GetMaxValInList(AList:TStrings):Real;
Procedure GetIncomeStream(StartBal:Real;IndexBy:Real;Years:Integer;StreamList:TStrings);
Function ConvertToIFICFundType(OldType:String):String;
Function GetPresentationDate(RetNo:Integer):String;
Procedure FindKeywordPosition(Var Txt:AnsiString;Var keyW:String;Var KeyWPosition:Integer;Delim1,Delim2:String);
Function GetValueFromInternet(Url:String;Parameter:String):String;
procedure AnalyseAFundFromYahoo(PageId,FundId,Exchange:String);
procedure GetTheHtmlDoc(Url:String;CaptureFileName:String);
Procedure ShowFundDataOnWeb(PageId,FundId,Exchange,timeperiod:String);
Procedure ReplaceAString( Var Txt:String;Cursor_Position:Integer;
 KeyWLength:integer;ReplaceString:String);
Function GetPositionOfSubstring(ss,s:String):Integer;
Function GetYahooUrl(PageId,FundId,Exchange,timeperiod:String):String;
Function DateWithSlashes(Dt:String):String;
Function GetRetirementTaxRate(RetNo:Integer):Real;
Function GetFileExtension(FlName:String):String;
Function GetLongFilename( shortname: String ):String;
function GetShortName(sLongName : string ):string;
function GetLongName(sShortName : string ):string;
Function ReplaceChar(S,Ch1,Ch2:String):string;
Function ClientExists(FileNm:string): Boolean;
Function GetClientLastFirstName(FileNm:string): String;
Function GetTitleDescr(TitleCode:String):String;
Function CalcProbate(Estate:Real;Prv:String):Real;
Function CopyToOutBox(FileName,NewFileName,FromDir,ToDir:string):Integer;
Function FetchADate:String;
Function GetRandomNo(ThisRange:Integer):Integer;
Function RetirementCostOfLivingDone(RetNo:Integer):Boolean;
Function CurrentCostOfLivingDone(RetNo:Integer):Boolean;
Function NoClient(RetNo: integer):Boolean;
Function GetFundAndRateType(FundCode,Gn:String):String;
Function CalcDealerCommission(Gross:Real;GN:String;FeRate,DSCRate:Real):Real;
Function CalcAgentCommission(DealerCommission:Real;AgentRate:Real):Real;
Function CalcCoAgentCommission(AgCommission:Real;CoAgentRate:Real):Real;
procedure UnzipAFile(FrmHandle:THandle;FlName:String);
Function GetMarStatusDescription(Marst:Integer):String;
Function GetBranchFilesOutDir(Branch:string): String;
Function ConvertDateToMDD(Dt:TDateTime):String;
Function BackUpFpClients:Boolean;
Function ConvertFSMonthCode(MonthCode:String):String;
Function GetTransactionDescription(TypeSubType:String):String;
Function GetTransactionSign(GivenSign,TypeSubType:String):String;
Procedure ConnectToFundServ(FrmHandle:THandle);
Function ConvertAccountTypeCodeToDescr(AccountType:String):String;
Function ConvertAccountTypeDescrToCode(AccountTypeDescr:String):String;
function BigMidStr(Const Str: AnsiString;StartPos: Word; Size: Word): String;
Function FormatFsDate(Dt:String):String;
Function GetBranchOfAgent(Agent:string): String;
Function GetPricesAsOfDate:String;
Function ValidDateYYYYMMDD(S:String;MxYear:integer):Boolean;

Function IsDemoVersion:Boolean;
Function IsLimitedVersion:Boolean;
Function IsStandardVersion:Boolean;
Function IsAgentVersion:Boolean;
Function IsDealerVersion:Boolean;

procedure PrintAChart(Chart1:TChart;Heading1:String);
Function DebtPayment(Princ,Int,Term:Double):Double;
Function CheckDir(DirName:String):Boolean;
Function HOSetUpOk:Boolean;
Function EmptyATable(Table1:TDataSet):Boolean;
Function GetClientLettersDir:String;
Function MkClientLetterName(RetNo:Integer):String;
Function GetPositionInList(s:String;AlistBox:TFileListBox):Integer;
Procedure SavingsCalc(OpeningBalance,Amount,Interest,TaxRate,Inflation:Real;Years:Integer;
    Var PeriodInterestArray:Array of Real;Var PeriodBalanceArray:Array of Real;InvestTime:String);

procedure PopulateTransactionStatusCombo(ACombo:TDBComboBox);
Function OpenFundsDb(UserId:string): boolean;
Function OpenClientsDb(UserId:string): boolean;
Function GetCheck1(Pgm:String;VersionNum:Integer):String;
Function GetCheck2(Pgm:String;VersionNum:Integer):String;
Procedure SummarizeProposedAssets(FileNm:String);
Procedure GetChartColors(Var ChartColor:Array of TColor);
Procedure SummarizeLiabilities(RetNo:Integer);
Function MakeTransactionId(Branch,AgentCode:String;TransactionNo:Integer):String;
Function GetLastTransactionNo(AgentCode:string):Integer;
Function SaveLastTransactionNo(AgentCode:String;TransactionNo:Integer):Boolean;

Function MakeTempAccount(FundCo:String):String;

Procedure ParseWords(S:AnsiString;Delim:String;WList:Tstrings);
procedure PopulateAccountTypesCombo(ACombo:TDBComboBox);
Function GetClientHeader(RetNo:Integer):string;
//procedure ExecuteForm(AFormClass: TFormClass); //20160612 Igor (Duplicate vtCommon)
Function CountDetailRecs(RetNo:Integer;FNo:Integer):Integer;
Function GetBeneficiaryRelation(RetNo:Integer;FNo:Integer):String;
Function GetTitleCode(RetNo:Integer;FNo:Integer):String;
Function GetSpousalFlag(RetNo:Integer;FNo:Integer):String;
Function GetJointType(RetNo:Integer;FNo:Integer):String;
Function GetRecipientCode(RetNo:Integer;FNo:Integer):String;
Function GetLanguageCode(RetNo:Integer):String;
Function GetTheTime(Dt: TDateTime):String; {in HHMSS}
function EncryptIt(const S: String; Key: Word): String;
//var  I: byte; ???
function DecryptIt(const S: String; Key: Word): String;
Procedure ShowDemoMsg;
procedure ShowBDEError(AExc: EDataBaseError);
Function PrvLongToShort(PrvNm:String):String;
procedure ChartPortfolioMix(MixArray:Array of Real;ProposedOrCurrent:string;TempCanvas:TBitMap;R:TRect);
Function ClientFileName(RetNo:Integer):string;
Function GetPortFlLabel(ndx:integer):string;
Function ClientForCaption(RetNo:integer):string;
Function AnnualizeReturn(OpeningBalance,FutValue:Real;Years:Integer):Real;
Function ExtractNonExtensionFileName(FlName:String):string;
Function ClientAgeToYear(RetNo,SomeAge:Integer):Integer;
Function SomeAgeToYear(SomeAge:Integer;CurrentAge:Integer):Integer;
Function GetPlanStartAge(RetNo:Integer):Integer;
Function GetSpousePlanStartAge(RetNo:Integer):Integer;
Function GetNewRIFRate(Age:Integer):Real;
Function GetOldRIFRate(Age:Integer):Real;

Function GetMinGenEndBalance(RetNo:Integer;GenBalanceList:TList):Real;
Function GetMaxGenEndBalance(RetNo:Integer;GenBalanceList:TList):Real;
Function GetMinFVEndBalance(RetNo:Integer;GenBalanceList:TList):Real;
Function GetMaxFVEndBalance(RetNo:Integer;GenBalanceList:TList):Real;
Procedure FetchLifeEventsStreams(RetNo:Integer);
Function CalcEndBal(BegBalance,IntRate,RegContr,LumpSumContr,RegWithDr,LumpSumWithDr:Real):Real;
Procedure XferToCash(RetNo:Integer;BalanceRec:TBalanceRec);

Function GetRetirementAfterTaxIncome(RetNo:Integer):Real;
Function GetDesiredRetirementIncome(RetNo:integer):Real;

Procedure GetMinMaxEndBalance(RetNo:Integer;ThisStream:String;Var MinBal,MaxBal:real);
Function YearsOfPayout(RetNo:Integer):Integer;
Function GetEndBalanceByAge(RetNo:Integer;Age:Integer;ThisStream:String):Real;
Function GetIncShortFall(RetNo:Integer):Real;
Function XToY(x,y:Double): Double;
Function DeriveNonShPercent(RetNo:Integer;SheltPercent,SemShPercent,OtherPercent:Real):Real;
Function GetMaxSheltPercent(RetNo:Integer;RRSPRoom,DispIncome:Real):real;

Function GetMaxSheltRefundPercent(RetNo:Integer;RRSPRoom,DispIncome,TaxRefund,Preallocated:Real):real;
Function DeriveNonShRefundPercent(RetNo:Integer;
   SheltRefundPercent,SemShRefundPercent,OtherRefundPercent:Real):Real;

Function RemoveCommas(s: string):String;
Function GetInitialNonSh(RetNo:Integer):Real;
Function GetInitialShelt(RetNo:Integer):Real;
Function GetInitialSemSh(RetNo:Integer):Real;
Function GetInitialOther(RetNo:Integer):Real;
procedure ChartInvestmentsMix(RetNo:Integer;TempCanvas:TBitMap;R:TRect;
 Titl:string;NonSh,Shelt,SemSh,Other:Real);
procedure ChartShortFall(RetNo:Integer;DesiredIncome:Real;AvailableIncome:Real;TempCanvas:TBitMap;R:TRect);
procedure CalcFutValData(RetNo:Integer;Years:Integer;Interest,OpeningBalance:Real;GenBalanceList:TGenBalanceList);
procedure ChartFutVal(RetNo:Integer;TempCanvas:TBitMap;R:TRect);
procedure ChartPresVal(RetNo:Integer;ThisStream:String;TempCanvas:TBitMap;R:TRect);
Function AfterTaxReturn(BeforeTaxReturn:Real;MarginalRate:Real):Real;
Function GetAccumChartTitle(ThisStream,Interest:String):String;
Procedure ChangeRect(R:TRect;Var R1:TRect);
procedure ChartStream(RetNo:Integer;ThisStream:String;TempCanvas:TBitMap;R:TRect;YearOrAge:Boolean);
procedure ChartTotBalance(RetNo:Integer;TempCanvas:TBitMap;R:TRect;YearOrAge:Boolean);
Procedure ChartRIF(RetNo:integer;TempCanvas:TBitMap;R:TRect;YearOrAge:Boolean);
Procedure GetEventList(RetNo:Integer;Yr:Integer;EventList:TStrings);
procedure DrawFormList(RetNo: integer; Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);

Function GetStreamId(ThisStream:String):Integer;
Function GetStreamName(StreamId:Integer):String;
Function GetEventAmount(RetNo:Integer;ThisStream:String;TotalAmount:Real;NonShPercent,
         SemShPercent,SheltPercent,OtherPercent:Real):Real;


Function GetMaxAccumPageNo(RetNo:Integer):Integer;
procedure GetRetirementParms(RetNo:Integer);
Function GetActualBalance(RetNo:Integer):Real;
Function GetStartInvestmYear(RetNo:Integer):Integer;
Function GetMaxEndBalance(RetNo:Integer;ThisStream:String;BalanceList:TList):Real;
Function GetMinEndBalance(RetNo:Integer;ThisStream:String;BalanceList:TList):Real;
Function GetMaxTotBalanceEndBalance(RetNo:Integer;TotBalanceList:TList):Real;
Function GetMinTotBalanceEndBalance(RetNo:Integer;TotBalanceList:TList):Real;
Procedure ProcessShortFallEvent(RetNo:Integer;ThisStream:String;AcccumList,IrregWithDrList:Tlist);
Function GetYearOfZeroBalance(RetNo:Integer;ThisStream:String;BalanceList:Tlist):Integer;
Function GetEventStream(RetNo:Integer;NS,SS,SH,OT:String):String;
Function GetPlanningPeriods(RetNo:Integer):Integer;
Function YearInEventRange(Yr, FromYr,ToYr:String):Boolean;
Function CalcAge(BirthDate: string): Integer;
Function CalcAgeTo(BirthDate: string;ToDate:string): Integer;
function ExecuteFile(const FileName, Params, DefaultDir: string;
  ShowCmd: Integer): THandle;

Procedure GetFormsToPrint(RetNo:integer;Template:string;FormsToPrint:Tstrings);
//Procedure GetFormsToPrint(RetNo:integer;Template:string;var FormsToPrint:TstringList);

Function GetMFundsMasterData(FundCode:string; Var MFundsMastRec:TMFundsMastRec):Boolean;
Procedure FillMFundsMastRec(Tbl:TDataSet; Var MFundsMastRec:TMFundsMastRec);
Procedure ApplyClientRange(ThisTable:TDataSet;FileNm:String); // 20150920 Igor
Function GetFirstName(RetNo:integer):String;
Function GetLastName(RetNo:integer):String;
procedure OnestepCom;
Procedure WriteFileForEFCom;
Function PrintAListing(FileNm,Hdr1,Hdr2,Hdr3: String):boolean;
Function YYYYMMDDToDDMMYYYY(YYYYMMDD:String):string;
Function GetPrvIndex(SPrv: string): Integer;
Function GetPrvLongIndex(LPrv: string): Integer;
Function InputDateDMYToYMD(Dt:String):string;
Function CalcMarginalRate(Income:Real):Real;
Function GetMarginalRate(RetNo:Integer):Real;
Function SpouseMarginalRate(RetNo: integer):Real;
Function ClientMarginalRate(RetNo: integer):Real;
Function BeforeToAfterTaxRate(AfterTax:Real;BeforeTax:Real):Real;

Function GetRRSPLimit(RetNo:Integer):Real;
Function GetMargRate(RetNo:Integer):Real;
Function GetShFallDiscount(RetNo:Integer):Real;
Function ConvertToAfterTax(BeforeTax:Real;BToAFactor:Real):Real;
Function ConvertToBeforeTax(AfterTax:Real;BToAFactor:Real):Real;
Function GetPlanYear(RetNo:Integer):String;
Function MyPresentValue(FutureAmount:Real; Years:Integer; Interest:Real):Real;
Function FutureValue(OpeningBalance:Real; Interest:Real;Years:Integer):Real;
Function CapitalToGenIncome(AnnualIncome:Real; Years:Integer; Interest:Real):Real;
Function ClientYearOfUltimateAge(RetNo:Integer): String;
Function SpouseYearOfUltimateAge(RetNo:Integer): String;
Function ClientYearOfRetirement(RetNo:Integer): String;
Function SpouseYearOfRetirement(RetNo:Integer): String;
Function  CountKids(RetNo:Integer):Integer;
Function ClientBirthDate(RetNo:Integer):String;
Function SpouseBirthDate(RetNo:Integer):String;
Function ClientAge(RetNo:Integer): Integer;
Function SpouseAge(RetNo:Integer): Integer;
Function ClientUltimateAge(RetNo:Integer): Integer;
Function SpouseUltimateAge(RetNo:Integer): Integer;
Function ClientAgeAtRetirement(RetNo:Integer): Integer;
Function SpouseAgeAtRetirement(RetNo:Integer): Integer;
Function ClientYearsToRetirement(RetNo:Integer): Integer;
Function SpouseYearsToRetirement(RetNo:Integer): Integer;
Function ClientRetirementYears(RetNo:Integer): Integer;
Function SpouseRetirementYears(RetNo:Integer): Integer;

Function ClientYearsToUltimateAge(RetNo:Integer): Integer;
Function SpouseYearsToUltimateAge(RetNo:Integer): Integer;

Procedure LoadMarginalRates;
Function CalcAfterToBeforeFactor(Income:Real):Real;

Function GetAreaCode(RetNo:integer):String;
Function GetPhoneNo(RetNo:integer):String;
Function GetFaxNo(RetNo:integer):String;
Function GetOfficeNo(RetNo:integer):String;
Function GetEmailNo(RetNo:integer):String;
Function IsReturnPaid(RetNo:integer):Boolean;
Function ClientLastName(RetNo:integer):String;
Function ClientFirstName(RetNo:integer):String;
Function SpouseLastName(RetNo:integer):String;
Function SpouseFirstName(RetNo:integer):String;
Function InputDateToMMDDYYYY(InputDate:String):string;
Function GetSinNo(RetNo:integer):String;
Function GetSpouseSinNo(RetNo:integer):String;
Function GetFormFee(FormName:String;Qty:integer):Real;
Function GetTotalFee(RetNo:Integer):Real;
Procedure GetListInvoiceForms(RetNo:Integer;Frms,HowMany:Tstrings);
//Procedure GetListInvoiceForms(RetNo:Integer;Var Frms:TStringList;Var HowMany:TstringList);
Function CountPagesGenerated(RetNo:Integer):Integer;
Function DDMMYYYYToMMDDYYYY(DDMMYYYY:String):string;
Procedure FillHeader(RetNo,FormNo,DateElm,NameElm:Integer);
Function MyStrToFloat(AString:String):Real;

Procedure AllowLinesForLogo(LetterLines:Tstrings);
//Procedure AllowLinesForLogo(Var LetterLines:TstringList);
Procedure ExpandTabs(AList:Tstrings);
Procedure ResolveConditions(AList:Tstrings);
Function InvalidAmountInLetter(s:string):boolean;
Function IsFormMultiPage(FormName: String): Boolean;
Function MultiPage1(Frm:string;Inst:string;MxPg:Integer):Boolean;
Function MultiPage23(Frm:string;Inst:string;MxPg:Integer):Boolean;
Procedure CountMulties(RetNo:Integer;Frms,HowMany:Tstrings);

Function CountKeystrokePoints(RetNo:Integer):Integer;
function InitFormsTable: boolean;

Function ClcR(FieldId:integer;
              PgmValue:real;
              FormOvrSw:boolean;
              RetNo:integer;
              FormNo:integer):Real;
function IsShowFlagIndicator(FName: String):Boolean;
function IsShowHdrIndicator(FName: String):Boolean;
Procedure RemoveLastEmptyLines(TempList:Tstrings);
Procedure RemoveEmptyLines(TempList:Tstrings);
procedure InterpretTextLine(Var Txt:AnsiString);
Procedure ReplaceKeyWord(Var Txt:AnsiString;Cursor_Position:Integer;
     KeyWLength:integer;ReplaceString:String);
procedure ConditionEvaluator(ConditionLine:string;var CCheck:boolean; var error:boolean);
Procedure ReplaceText(LetterBody:TMemo;Cursor_Position:Integer;KeyWLength : Byte; ReplaceText: string);
function GetDataDictElmNo(KeyW: String):Integer;
function GetDataDictFormName(KeyW: String):String;
function InDataDict(KeyW: String):Boolean;
Function InsertPenniesDot(S: string):String;
function GetWhiteBoxesIndicator(FName: String):Boolean;
Function TotMultiple(RetNo:Integer;NonInstFormName:String;Elm:Integer):real;

Function SpouseDisabled(RetNo:integer):Boolean;
function GetFormName(FormNo: integer; ARetNo: Integer = 0):String;
function GetFName(AbrevName: String):String;
function GetFormNo(FormName: String; ARetNo: Integer = 0):Integer;
function GetFormDescr(RlName: String):String;
Procedure UpdateAllDataIndicators(RetNo:Integer);
Procedure InfoOn;  {just repaint mdi status panel}
Procedure InfoOff;

Function GetNumbFields(FName: string):integer;
Function WhichTaxForm(RetNo: integer;ShortPrv:string):String;
Function WhichCreditForm(RetNo: integer;ShortPrv:string):String;
Function RemovePenniesDot(S: string):String;
Function MakeEFFileName(LicenseLevel:string):string;

Function EditLongPrv(Value: string):Boolean;
Function FormatAmount(s: string;How:Integer): string;
{File i/o}
Function FileNameValid(FlName: string): boolean;
{$IFDEF unused}
Function CopyReturn(DataDir:String;FileName:String;DestinationDir:string):boolean;
{$ELSE}
{$ENDIF}
//Function GetUserProfile(UserId:string): boolean; //20170112 Igor (Move to TUserProfile)
Procedure ShowOpenReturnFailure(FailCode: integer;DataDir: String; FlName: string);

procedure LoadDataDict;

Procedure ShowHelp(HelpFile:String;Helptopic: string; AIsWeb: Boolean = False); //20160801 Igor

  Procedure SwapStrings(S1: string; S2: string);
  Function ExtractDecimalPart(S: string): string;
  Function ExtractIntegerPart(S: string): string;

  Function InsertCommas(s: string):String;
function ImportOneReturn(ADS: TDataSet; ASrcDir, ADstDir: String; out AErr: String;
    AOverride: Boolean): Boolean; //20160617 Igor
function GetLastYearFile(ARetNo: Integer): String; //20160701 Igor
procedure SetLastYearFile(const ARetNo: Integer; AValue: String); //20160701 Igor

Function IsValidLastYearPgmFolder(AShowMessage: Boolean;
  out AErrorMessage: String): Boolean; //20160704 Igor
function isValidLastYearDataFolder(AShowMessage: Boolean;
  out AErrorMessage: String): Boolean; //20160704 Igor
procedure InitLastYearFormsTable; //20160704 Igor
Function GetRenamedFName(FName: String): String; //20160704 Igor
function GetLastYearFormNo(FormName: String):Integer; //20160704 Igor
function GetLastYearFormName(FormNo: integer):String; //20160704 Igor
Function ShowUnconvertedLastYear(RNo:Integer): Boolean; //20160704 Igor
function QuickFormFind(RetNo: integer; AFormName: String): Boolean; //20170418 Igor

implementation

uses vtCommon,vtDialogs,HtmlHelp,{fReturnPassword,}FP_2027,FP_2027Main,
     FP_2027PopList,FP_2027Calc,FP_2027Features,FP_2027ChildWinNew,FP_2027Common,
     FP_2027common2,FP_2027CalcTax,vtTrimStr,vtShared
   , vtDataBase, uADCompClient, // 20150920 Igor
     fConvertToMultiApp; //20160627 Igor

const  //20160627 Igor
  c_DefDataDir = '{DataDir}';
  //20170112 Igor >>>
  OptionsArray: Array[0..64, 0..3] of string =
// Options Name        Default Value                 Caption    Fill Default
  (
  ('Dir_Cur',            c_DefDataDir+'\Data' ,           'Current FP Directory', 'X'), {0}//20171204 Igor
  ('BackUpFrequency',    '7' ,                        'Remind me to backup data every X deys', 'X'),
  ('BackupDir',          c_DefDataDir + '\BackUp' ,   'Default Backup Directory', 'X'),//20171204 Igor
  ('LastBackupDir',      '' ,                         'Most recent back up Directory', 'X'),
  ('Dir_Deflt',          c_DefDataDir+'\Data' ,           'Default FP Directory', 'X'),//20171204 Igor
  ('T1DataDir',          '' ,                         'T1 Tax returns Directory', 'X'),
  ('Dir_LastYr',         '' ,                         'Last year''s FP data directory (For ROLL-OVER purposes) *', 'X'),
  ('Dir_PgmLastYr',      '' ,                         'PROGRAM dir last year', 'X'), //20160704 Igor
  ('Dir_DBFData',        '' ,                         'Data directory of the FP-2018 production data prior to Multi-App. Typically enter  C:\FP-2018\data. To be used as the source to import data into the Multi-App version', 'X'),
  ('Prp_Name',           '' ,                         'Company Name', ''),
  ('Prn_LMargin',        '0.75' ,                     'Client Letters Print Margins: Left margin in inches', 'X'),{10} //20160721 Igor
  ('Prn_RMargin',        '0.5' ,                      'Client Letters Print Margins: Right margin in inches', 'X'),     //20160721 Igor
  ('Prn_FontIncr',       '1' ,                        'Printing Font Size Increment: Increment by (0 or 1)', 'X'),
  ('Prp_EMail',          '' ,                         'Email Address', ''),
  ('Prp_BusNo',          '' ,                         'Business No', ''),
  ('Reviewer_EMail',     '' ,                         'Reviewer Identification: Email Address', ''),
  ('Reviewer_Name',      '' ,                         'Reviewer Identification: Name', ''),
  ('Reviewer_Area',      '' ,                         'Reviewer Identification: Area', ''),
  ('Reviewer_Tel',       '' ,                         'Reviewer Identification: Number', ''),
  ('Prp_Street',         '' ,                         'Preparer Identification: Street', ''),
  ('Prp_City',           '' ,                         'Preparer Identification: City', ''),{20}
  ('Prp_Prov',           '' ,                         'Preparer Identification: Province', ''),
  ('Prp_Postal',         '' ,                         'Preparer Identification: Postal', ''),
  ('Prp_Countr',         '' ,                         'Preparer Identification: Country:', ''),
  ('Prp_Area',           '' ,                         'Preparer Identification: Tel. Area', ''),
  ('Prp_Tel',            '' ,                         'Preparer Identification: Tel. Number', ''),
  ('Prp_FxArea',         '' ,                         'Preparer Identification: Fax. Area', ''),
  ('Prp_Fax',            '' ,                         'Preparer Identification: Fax. Number', ''),
  ('Prp_GSTNo',          '' ,                         'GST No', ''),
  ('Prp_Bill',           '2' ,                        'Default Billing Option', 'X'),
  ('Prp_VSFee',          '100' ,                      'Flat Fees ($): Very small', 'X'),{30}
  ('Prp_SFee',           '150' ,                      'Flat Fees ($): Small', 'X'),
  ('Prp_AFee',           '200' ,                      'Flat Fees ($): Average', 'X'),
  ('Prp_CFee',           '300' ,                      'Flat Fees ($): Complex', 'X'),
  ('Prp_VCFee',          '400' ,                      'Flat Fees ($): Very Complex', 'X'),
  ('Prp_Hour',           '60' ,                       'Charge per hour ($)', 'X'),
  ('Prp_Dates',          '' ,                         'Signature date: If checked, the program will automatically fill Signature dates with today''s date', ''),
  ('Nfl_Prov',           'ON' ,                       'Default Province', 'X'),
  ('Nfl_City',           'TORONTO' ,                  'Default City', 'X'),
  ('Capitalization',     'UpperCase' ,                'Client Name/address: Convert to', 'X'),
  ('Prn_NameH',          'X' ,                        'Client Name on Headings', 'X'),{40}
  ('Prn_SinH',           'X' ,                        'SIN on Headings', 'X'),
  ('Prn_DateH',          'X' ,                        'Date on Headings', 'X'),
  ('Opr_GstHst',         '6' ,                        'GST/HST rate', 'X'),
  ('UseFastPrint',       '' ,                         'Use Fast Print method', 'X'),
  ('UseProperName',      'X' ,                        'Client Letters: Show proper format (Capitalize only first letter)  in Name and Address', 'X'),
  ('NoTypeAhead',        '' ,                         'DO NOT Use the Predictive Typing feature (Super Entry)', 'X'),
  ('ShowInvoiceWarning', 'X' ,                        'Invoice: Show warning  if invoice not prepared', 'X'),
  ('InvFoot1',           '' ,                         'Invoice footer (Free format text to appear at bottom of Invoice) 1', ''),
  ('InvFoot2',           '' ,                         'Invoice footer (Free format text to appear at bottom of Invoice) 2', ''),
  ('InvFoot3',           '' ,                         'Invoice footer (Free format text to appear at bottom of Invoice) 3', ''), {50}
  ('InvFoot4',           '' ,                         'Invoice footer (Free format text to appear at bottom of Invoice) 4', ''),
  ('InvFoot5',           '' ,                         'Invoice footer (Free format text to appear at bottom of Invoice) 5', ''),
  ('ActiveBoxColor',     '8421631' ,                  'ActiveBoxColor', 'X'),
  ('DataInBold',         '' ,                         'Show data in Bold in all forms', 'X'),
  ('HideMostRecent',     '' ,                         'Hide most recent returns', 'X'),
  ('FormZoom',           '100' ,                      'Form Size (zoom) in effect', 'X'),
  ('FirstReturnColor',   '16777155' ,                 'FirstReturnColor', 'X'),
  ('Opr_Close',          'X' ,                        'Opr_Close', 'X'),     { TODO : check }
  ('ShowFinWarning',     '' ,                         'Show fin. warning', 'X'),     { TODO : check }
  ('ShowConsultantOnInv','' ,                         'ShowConsultantOnInv', 'X'),{60} { TODO : check }
  ('ShowSaluteWarning',  'X' ,                        'ShowSaluteWarning', 'X'),     { TODO : check }
  ('UpdateFrequency',    '7' ,                        'Check automaticaly every X deys', 'X'),
  ('Nfl_Efile',          'X' ,                        'Nfl_Efile', 'X'),     { TODO : check }
  ('RolloverProgram',    'VisualTax' ,                'Rollover program', 'X') {64} { TODO : check }
  );
//20170112 Igor <<<
Procedure ShowDemoMsg;
begin
  ShowMessage('This function is not available in the Demo version');
end;

Procedure LoadMarginalRates;
Var I:integer;TempList:TstringList;
begin
 TempList := TstringList.Create;
 TempList.LoadFromFile(Appdir+'\'+'MargRate.d');
 MarginalFrom.free;
 MarginalTo.free;
 MarginalRate.free;
 MarginalFrom:=Tstringlist.Create;
 MarginalTo:=Tstringlist.Create;
 MarginalRate:=Tstringlist.Create;
 For i :=0 to TempList.Count -1 do
 begin
  MarginalFrom.Add(AllTrim(LeftStr(Templist[i],7)));
  MarginalTo.Add(AllTrim(MidStr(Templist[i],10,9)));
  MarginalRate.Add(AllTrim(MidStr(Templist[i],20,5)));
 end;
 TempList.Free;
end;


Function MyStrToFloat(AString:String):Real;
begin
 If AString='' then result :=0 else result := StrToFloat(AString);
end;

Function GetFullAddress(RetNo:Integer):String;
begin
 Result := FetchElm(RetNo,'PROFILE',6)+
                    ', '+FetchElm(RetNo,'PROFILE',10)+
                    ', '+FetchElm(RetNo,'PROFILE',14)+
                    ', '+FetchElm(RetNo,'PROFILE',15);
end;

Procedure FillHeader(RetNo,FormNo,DateElm,NameElm:Integer);
Begin
  With Ret[RetNo].Frm[FormNo] do
  begin
   Strings[DateElm] := GetPresentationDate(RetNo);
   //20090605
   Strings[NameElm] := FetchElm(RetNo,'PROFILE',131);
   If Strings[NameElm]='' then
     Strings[NameElm]:=ClientFirstName(RetNo)+' '+ClientLastName(RetNo);
  end;
end;

Procedure AllowLinesForLogo(LetterLines:Tstrings);
Var i:Integer; TempList:tstringlist;
begin
  //NOP?
end;

Function CountPagesGenerated(RetNo:Integer):Integer;
Var I:integer;
begin
 Result:=0;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If Ret[RetNo].FrmHasData[Frec.FormNo] then inc(Result);
 end;
end;

Function IsFormMultiPage(FormName: String): Boolean;
Var
I : integer;
begin
 Result := False;
 i := Length(FormName);
 While i >0 do
  begin
   If FormName[i] = '_' then begin Result := True; exit; end;
   Dec(i);
  end;
end;

Procedure CountMulties(RetNo:Integer;Frms,HowMany:Tstrings);
Var i,j:integer;
begin
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If Ret[RetNo].FrmHasData[Frec.FormNo] then
   begin
     If IsFormMultiPage(Frec.FormName) then  {Multipage}
     begin
      If (RightStr(Frec.FormName,2) = '_1') and (Frec.FormInst = '#1') then
       begin Frms.Add(Frec.FormName); HowMany.Add('1'); end
       else
       If (RightStr(Frec.FormName,2) = '_1') and (Frec.FormInst > '#1') then
        for j :=0 to Frms.Count-1 do
        If Frec.FormName = Frms[j] then
         HowMany[j] := IntToStr(StrToInt(HowMany[j]) +1);
     end
     else {Single Page}
     begin
      If (Frec.FormInst = '#1') then
         begin Frms.Add(Frec.FormName); HowMany.Add('1'); end
      else
        for j :=0 to Frms.Count-1 do
         If Frec.FormName = Frms[j] then
          HowMany[j] := IntToStr(StrToInt(HowMany[j]) +1);
     end;
   end;
 end;
end;

Function MultiPage1(Frm:string;Inst:string;MxPg:Integer):Boolean;
{frm is noninstance}
begin
 result := false;
 If (Inst = '#1') then
  if (RightStr(Frm,2) = '-1')
       or (MxPg <2) then
  result :=true;
end;

Function MultiPage23(Frm:string;Inst:string;MxPg:Integer):Boolean;
{frm is noninstance}
begin
 result := false;
 If (Inst > '#1') then
  if (RightStr(Frm,2) = '-1') or (MxPg <2) then
  result :=true;
end;


Function CountKeystrokePoints(RetNo:Integer):Integer;
Var I:integer;
    ADConnection: TADConnection;
    Table1: TADTable;
begin
 Result:=0;

 //20150923 Igor
 ADConnection:= TADConnection.Create(Application);
 Table1 := TADTable.Create(Application);
 SetTableName(ADConnection, Table1, FormsFeesDBLite, FormsFeesTableLite, 'FORMNAME');

 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If Ret[RetNo].FrmHasData[Frec.FormNo] then
   begin
    //if Table1.FindKey([Frec.FormName]) then
    if Table1.Locate('formname',Frec.FormName,[]) then
    begin {Table1.FieldByName(Template).AsString;} end;
   end;
 end;
 Table1.Close;
 Table1.Free;
 ADConnection.Free;
end;

function IsShowHdrIndicator(FName: String):Boolean;
begin
  Result := FList.ByFormName(FName).ShowHdr;
End;

function IsShowFlagIndicator(FName: String):Boolean;
begin
  Result := FList.ByFormName(FName).ShowFlag;
End;


function GetWhiteBoxesIndicator(FName: String):Boolean;
begin
  Result := FList.ByFormName(FName).WhiteBoxes;
End;

function GetFormDescr(RlName: String):String;
Var I :integer;
begin
Result :='';
RlName :=RTrim(RlName);
for i :=0 to (FList.Count - 1) do
  begin
     FRec := FList.Items[i];
     If RlName = FRec.FormRlNm
      then Result := FRec.FormDescr;
   end;
End;

function GetFName(AbrevName: String):String;
var
 i: Integer;
begin
 Result := '';
 AbrevName := RTrim(AbrevName);
  for i :=0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      if LeftStr(FRec.FormAbrev,Length(AbrevName)) = AbrevName then
        begin Result := FRec.FormInstName;exit;end;
    end;
 end;

function GetFormName(FormNo: integer; ARetNo: Integer = 0):String;
begin
  //20160704 Igor >>>
//  Result := FList.GetFormName(FormNo);
  if (ARetNo > 0) and Ret[ARetNo].IsLastYearReturn then //20160704 Igor
    Result := FLastYearList.GetFormName(FormNo)
  else
    Result := FList.GetFormName(FormNo);
  //20160704 Igor <<<
end;


Function TotMultiple(RetNo: Integer; NonInstFormName: String; Elm: Integer): Real; {No Instance}
var
  i, FNo: Integer;
begin
//20170409 Igor >>>
  Result := 0;
  If RetNo < 1 then exit;
  i := FList.FirstInstNo(NonInstFormName);
  if i > 0 then
  Begin
    for i := i to (Flist.Count - 1) do
    begin
      FRec := FList.Items[i];
      if FRec.FormInst > '' then
      Begin
        FNo := Frec.FormNo;
        if FNo > 0 Then
        Begin
          If Frec.FormName = NonInstFormName then
          Begin
            If Ret[RetNo].FrmHasData[FNo] then
              Result := Result + Vl(FetchElmFNo(RetNo,FNo,Elm));
          end;
        end;
      end;
    end;
  end;

//  Result := 0;
//  (* rem all 20151215 Igor
//  i := FList.FirstInstNo(NonInstFormName);
//  if i < 1 then
//  begin
//  {$IFDEF debug}
//  {$ELSE}
//    ErrorMsg('FP: TotMultiple: form '+NonInstFormName+' does not exist');
//  {$ENDIF}
//    exit;
//  end;
//  *)
//
//  for i := 0 to FList.Count-1 do //20160314 Igor
//  begin
//    FRec := FList.ByIndex(i);
//    if FRec.FormName <> NonInstFormName then break;
//    begin
//       FNo := FRec.FormNo;
//       If Ret[RetNo].FrmHasData[FNo] then
//           Result := Result + Vl(FetchElmFNo(RetNo,FNo,elm));
//               //Vl(Ret[RetNo].Frm[Fno].Strings[Elm]);
//    end;
//  end;
//20170409 Igor <<<
end;


function GetFormNo(FormName: String; ARetNo: Integer = 0):Integer;
begin
  //20160704 Igor >>>
//  Result := FList.GetFormNo(FormName);
  if (ARetNo > 0) and Ret[ARetNo].IsLastYearReturn then //20160704 Igor
    Result := FLastYearList.GetFormNo(FormName)
  else
    Result := FList.GetFormNo(FormName);
  //20160704 Igor <<<
end;

function IsDelphiForm(FormNo: Integer):boolean;
begin
  Result := FList.ByFormNoDummy(FormNo).DelphiForm;
end;

Function SpouseDisabled(RetNo:Integer):Boolean;
begin
 Result :=False;
 If Ret[RetNo].Frm[GetFormNo('S2')].Count >0
  then Result := vl(FetchElm(RetNo,'S2',45)) > 0;
end;


Procedure UpdateAllDataIndicators(RetNo:Integer);
var
 i,FNo: Integer;
 s:string;
 FName: string;
begin
    for i :=0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      FNo := Frec.FormNo;
      UpdateFormDataIndicator(RetNo,FRec);
      {If Ret[RetNo].FrmHasdata[FNo] then Msg :=Msg+FName+Chr(13);}
    end;
 // special cases
 If Vl(FetchElm(RetNo,'NETWORTH',52))>0 then
   Ret[RetNo].FrmHasData[GetFormNo('ASSETSUM')]:=True
 Else
   Ret[RetNo].FrmHasData[GetFormNo('ASSETSUM')]:=False;

 If Vl(FetchElm(RetNo,'NETWORTH',72))>0 then
   Ret[RetNo].FrmHasData[GetFormNo('LIABSUM')]:=True
 Else
   Ret[RetNo].FrmHasData[GetFormNo('LIABSUM')]:=False;

end;

Function Pars(Msg:string;elm:integer;Delimiter:string):string;
Var i:integer;DelimiterPositions :TstringList;
begin
 If RightStr(Msg,1) <> Delimiter then Msg:=Msg+Delimiter;
 If LeftStr(Msg,1) <> Delimiter then Msg:=Delimiter+Msg;
 if (Length(Msg) < 2) or (Elm <1) or (Msg ='') then
     begin result :='';exit;end;

 DelimiterPositions := TStringList.Create;
 For i:=1 to Length(Msg) do
  If Msg[i] = Delimiter then DelimiterPositions.Add(IntTostr(i));
 If Elm > DelimiterPositions.Count then Result :=''
 else Result := MidStr(Msg,StrToInt(DelimiterPositions[elm-1])+1,
             StrToInt(DelimiterPositions[elm]) - StrToInt(DelimiterPositions[elm-1])-1);
 DelimiterPositions.Free;
end;


Procedure InfoOn;
begin

end;

Procedure InfoOff;
begin

end;

Function RetNoOfSpouse(
  RetNo:integer;SpouseSin1:String;SpouseSin2:string):Integer;
Var I,RNo:integer;
begin
 Result := 0;
 If SpouseSin1+SpouseSin2 ='' then exit;
 for i :=0 to (RetList.Count - 1) do
 begin
   RetRec := RetList.Items[i];
   Rno := RetRec.RetNo;
   If (Ret[RNo].Frm[1].Strings[3] = SpouseSin2) and
      (Ret[RNo].Frm[1].Strings[4] = SpouseSin1)
    then begin Result := RNo;exit;end;
 end;
end;

Function GetNumbFields(FName: string):integer;
begin
  result := FList.ByFormName(FName).FormFields;
end;


Function WhichCreditForm(RetNo: integer;ShortPrv:string):String;
begin
 if      ShortPrv = 'NL' then result := 'NFTAX_1'
 else if ShortPrv = 'PE' then result := 'PETAX_1'
 else if ShortPrv = 'NS' then result := 'NSCR'
 else if ShortPrv = 'NB' then result := 'NBTAX_1'
 else if ShortPrv = 'QC' then result := ''
 else if ShortPrv = 'ON' then result := 'ONCR_1'
 else if ShortPrv = 'MB' then result := 'MANCR_1'
 else if ShortPrv = 'SK' then result := 'SKTAX_1'
 else if ShortPrv = 'AB' then result := 'ALTAX_1'
 else if ShortPrv = 'BC' then result := 'BCCR'
 else if ShortPrv = 'NT' then result := 'NWCR_1'
 else if ShortPrv = 'YT' then result := 'YKCR'
 else if ShortPrv = 'NU' then result := 'NUCR'
 else if ShortPrv = 'ZZ' then result := ''
end;

Function WhichTaxForm(RetNo: integer;ShortPrv:string):String;
begin
 If      ShortPrv = 'NL' then result := 'NFTAX_1'
 else if ShortPrv = 'PE' then result := 'PETAX_1'
 else if ShortPrv = 'NS' then result := 'NSTAX_1'
 else if ShortPrv = 'NB' then result := 'NBTAX_1'
 else if ShortPrv = 'QC' then result := ''
 else if ShortPrv = 'ON' then result := 'ONTAX_1'
 else if ShortPrv = 'MB' then result := 'MANTX_1'
 else if ShortPrv = 'SK' then result := 'SKTAX_1'
 else if ShortPrv = 'AB' then result := 'ALTAX_1'
 else if ShortPrv = 'BC' then result := 'BCTAX_1'
 else if ShortPrv = 'NT' then result := 'NWTAX_1'
 else if ShortPrv = 'YT' then result := 'YKTAX_1'
 else if ShortPrv = 'NU' then result := 'NUTAX_1'
 else if ShortPrv = 'ZZ' then result := ''
end;

Procedure ShowHelp(HelpFile:String;Helptopic: string; AIsWeb: Boolean = False); //20160801 Igor
//Var RetCode: LongInt;  iHelpID: LongInt;
begin
  if not AIsWeb then //20160801 Igor //20160810 Igor
    HelpFile:=AppDir+'\'+HelpFile+'.CHM';
  vtDialogs.ShowHelp(HelpFile, HelpTopic, AIsWeb); //20160801 Igor
//  ShellExecute(0, 'open', PWideChar(HelpFile), nil, nil, SW_SHOW); //20160525 Igor //20160801 Igor
// // iHelpId:=0;
// if HtmlHelpInstalled = True then
// begin
//   if HelpTopic='HELP_CONTENTS' then
//     RetCode := HH(0, PChar(HelpFile+Chr(0)), HH_DISPLAY_TOPIC,0)
//   else
//   begin
//     RetCode := HH(0, PChar(HelpFile+'::/'+HelpTopic+'.html'+Chr(0)), HH_DISPLAY_TOPIC,0);
//     //?? does nor workIf RetCode<>0 then ShowTimedMsg('Help was not found for HelpTopic',1200);
//   end;
// end
// else
// begin
//      ShowMessage('Please install at least v4.01 of Internet Explorer before '+
//      'displaying a CHM file');
// end;
end;

Function DDMMYYYYToMMDDYYYY(DDMMYYYY:String):string;
{input date in form dd-mm-yyyy, output as mm/dd/yyyy}
begin
 result :='';
 If DDMMYYYY ='' then exit;
 Result := MidStr(DDMMYYYY,4,2)+'/'+LeftStr(DDMMYYYY,2)+
           '/'+MidStr(DDMMYYYY,7,4);
end;

Function YYYYMMDDToDDMMYYYY(YYYYMMDD:String):string;
begin
 result :='';
 If YYYYMMDD ='' then exit;
 Result := RightStr(YYYYMMDD,2)+'-'
   +MidStr(YYYYMMDD,6,2)+'-'
   +LeftStr(YYYYMMDD,4);
end;



Function GetTheTime(Dt: TDateTime):String; {in HHMMSS}
Var
  //YYYY,MM,DD,
  Hour,Min,Sec,Msec :word;
begin
 Try
  //DecodeDate(Dt,YYYY,MM,DD);
  DecodeTime(Dt,Hour,Min,Sec,Msec);
  result := PaddZero(IntToStr(Hour),2)+
            PaddZero(IntToStr(Min),2)+
            PaddZero(IntToStr(Sec),2);
 except
  Result := '000000';
 end;
end;

Function MakeEFFileName(LicenseLevel:string):string;
Var YYYY,MM,DD,Hour,Min,Sec,Msec :word;
 SMM, SDD, SSec : string; //[2];
begin
  DecodeDate(Now,YYYY,MM,DD);
  DecodeTime(Now,Hour,Min,Sec,Msec);
  SMM   := LTrim(RTrim(IntToStr(MM)));
  SDD   := Ltrim(Rtrim(IntToStr(dd)));
  SSec := LTrim(RTrim(IntToStr(sec)));
  If Length(SMM)   =1 then SMM   := '0'+SMM;
  If Length(SDD)   =1 then SDD   := '0'+Sdd;
  If Length(SSec)  =1 then SSec  := '0'+SSec;
  If Vl(LicenseLevel) = 3 then
   Result := User.Branch+SDD+SSec   {M_Office} //20170112 Igor
  Else
   Result := SMM + SDD+ SSec;
end;

 Function EditLongPrv(Value: string):Boolean;
 Var i: integer;
 begin
   Result := False;
   For i := Low(PrvLong) to High(PrvLong) do
    begin
     If Value = PrvLong[i] then
       begin Result:= True;exit;end;
    end;
 end;


  function BigMidStr(Const Str: AnsiString;StartPos: Word; Size: Word): String;
  Var Len:Integer;
  begin
    Result := Copy(Str,StartPos,Size);
  end;

  Function BigSpace(Count: Word):AnsiString;
   {returns a string with Count spaces}
    var
     i:integer; S: AnsiString;
    begin
     s:='';
     For i:=1 to count do s:=s+' ';
     Result := S;
  end;


Function PaddZeroAtEnd(S:Ansistring;MaxLength:Integer):Ansistring;
Begin
  Result := s+FilledStr(PaddCount(S,MaxLength), '0');
End;

Function RemoveCommas(s: string):String; {remove 3 commas}
Var i,k:Integer;
begin
  k:=Pos(',',s);
  If k<> 0 then delete(s,k,1) else begin result:=s;exit;end;

  k:=Pos(',',s);
  If k<> 0 then delete(s,k,1) else begin result:=s;exit;end;;

  k:=Pos(',',s);
  If k<> 0 then delete(s,k,1) else begin result:=s;exit;end;;
end;

Function InsertCommas(s: string):String;
Var SignPart: string; //[1];
begin
 S := LTrim(s);
 If LeftStr(S,1) = '-' then
  begin SignPart := '-'; s := RightStr(s,Length(s)-1);end
 else
  SignPart :='';

 Result := SignPart+s;
 Case Length(s) of
  4 : Result := SignPart+LeftStr(S,1)+','+RightStr(S,3);
  5 : Result := SignPart+LeftStr(S,2)+','+RightStr(S,3);
  6 : Result := SignPart+LeftStr(S,3)+','+RightStr(S,3);
  7 : Result := SignPart+Leftstr(s,1)+','+MidStr(S,2,3)+','+RightStr(S,3);
  8 : Result := SignPart+Leftstr(s,2)+','+MidStr(S,3,3)+','+RightStr(S,3);
  9 : Result := SignPart+Leftstr(s,3)+','+MidStr(S,4,3)+','+RightStr(S,3);
 { 10: Result := Leftstr(s,3)+','+MidStr(S,3,3)+','+RightStr(S,3);}
 end;
end;


Function ExtractIntegerPart(S: string): string;
var
i :integer;
IntegerPart, DecimalPart : string; //[20];
Begin
 I :=1;
 while (i <= Length(s)) and not (S[i] ='.') do inc(i);
 Result := LeftStr(s,i-1); {copy(s[i],1,i-1);}
end;

Function ExtractDecimalPart(S: string): string;
var
i :integer;
Begin
 i := Length(S);
 while (i>0) and not (s[i] in ['.']) do dec(i);
 If (i>0) and (s[i] = '.') then
   result := Copy(s,i+1,255)
 else
   result := '';
end;

Function InsertPenniesDot(S: string):String;
begin
 S :=Ltrim(RTrim(s));
 Result := s;
 If MidStr(s,Length(s)-2,1) = ' ' then
  Result := Concat(LeftStr(s,Length(s)-3), '.', RightStr(s,2));
end;

Function RemovePenniesDot(S: string):String;
begin
 Result := s;
 If MidStr(s,Length(s)-2,1) = '.' then
  Result := Concat(LeftStr(s,Length(s)-3), ' ', RightStr(s,2));
end;


Function FormatAmount(s: string;How:Integer): string;
Var x:Real;
Begin
 FormatSettings.DecimalSeparator:='.';    //20150819  Igor
Try
 s := LTrim(s);
 x := Vl(S);
 //result:=FormatFloat('###,###,###',x);
 //result:=FormatFloat('###,###,###.00',x);

 If How=0 then
 begin
  x := Round(Vl(S));
  result := FormatFloat('###,###,###',x);
 end
 else
 begin
  If How=1 then result := FormatFloat('###,###,###.#',x)
  else If How=2 then result := FormatFloat('###,###,###.##',x)
  else If How=3 then result := FormatFloat('###,###,###.###',x)
  else If How=4 then result := FormatFloat('###,###,###.####',x)
 end;
except
  on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
end;
end;

Procedure SwapStrings(S1: string; S2: string);
var s: string;
begin
 s := S1; S1 := S2; S2 := s;
end;


Function FileNameValid(FlName: string): boolean;
Var i : Integer;
begin
 Result := True;
{
 for i :=1 to Length(FlName) do
  if FlName[i] in [' ','\',':','-'] then
   begin Result := false; exit; end;
 }
 If (Length(FlName) >12)  or (Length(FlName) = 0)
  or (Length(ExtractFilePath(FlName)) > 0)
  or (Length(ExtractFileExt(FlName)) > 4) {includes .}
  then
   result := false;
end;

{$IFDEF unused}
Function CopyReturn(DataDir:String;FileName:String;DestinationDir:string):boolean;
begin
  ShowMessage('Copying: '+FileName);
end;
{$ELSE}
{$ENDIF}

//20170112 Igor (Move to TUserProfile)
(*
Function GetUserProfile(UserId:string): boolean;
Var
  ADConnection: TADConnection;
  Table1: TADTable;
begin
  Result := True;

  //20150919 Igor
  ADConnection:= TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  SetTableName(ADConnection, Table1, AppDir + '\' + AgentsDBLite, AgentsTableLite, 'UserId');

  // Table1.ConnectionString:=FpClientsConnectionString;
  Table1.First;
  Repeat
    If UpperCase(UserId) = UpperCase(Table1.FieldByName('UserId').AsString) then
    begin
       With Table1 do
       begin
       FpUser.Branch    := FieldByName('Branch').AsString;
       FpUser.UserId  := FieldByName('UserId').AsString;
       FpUser.AgentCode := FieldByName('AgentCode').AsString;
       FpUser.BranchPassword      := FieldByName('BranchPassword').AsString;
       FpUser.LastName := FieldByName('LastName').AsString;
       FpUser.FirstName := FieldByName('FirstName').AsString;
       FpUser.IsAdmin := FieldByName('IsAdmin').AsString;
       FpUser.TaxFilesDir   := FieldByName('TaxFilesDir').AsString;
       FpUser.DefaultProvince   := FieldByName('DefaultProvince').AsString;
       FpUser.DefaultCity   := FieldByName('DefaultCity').AsString;
       Table1.Close;
       Table1.Free;
       Exit;
       end;
    end;
    Table1.Next;
  until Table1.Eof;
  Result := False;

  Table1.Close;
  Table1.Free;
  ADConnection.Free;
end;
*) //20170112 Igor

Function GetBranchOfAgent(Agent:string): String;
Var
    ADConnection: TADConnection;
    Table1: TADTable;
begin
  Agent := AllTrim(Agent);
  Result := '';

  //Table1.DataBaseName := ClientsDb;
  //Table1.ConnectionString:=FpClientsConnectionString;

  //20150922 Igor
  ADConnection:= TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  SetTableName(ADConnection, Table1, '', AgentsTableLite, '');

  Table1.First;
  Repeat
    If UpperCase(Table1.FieldByName('AgentCode').AsString) =UpperCase(Agent) then
    begin
     Result   := AllTrim(Table1.FieldByName('Branch').AsString);
     Table1.Close;
     Table1.Free;
     Exit;
    end;
    Table1.Next;
  until Table1.Eof;
  Table1.Close;
  Table1.Free;
  ADConnection.Free;
end;


Function GetBranchFilesOutDir(Branch:string): String;
Var
    ADConnection: TADConnection;
    Table1: TADTable;
begin
  Result := '';

  //Table1.DataBaseName := ClientsDb;
  //Table1.ConnectionString:=FpClientsConnectionString;

  //20150922 Igor
  ADConnection:= TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  SetTableName(ADConnection, Table1, '', 'BranchOffices', 'Branch');

  Table1.First;
  If Table1.Locate(Table1['branch'],Branch,[loCaseInsensitive]) then
   result := AllTrim(Table1['FilesOutDir'])
  else
   result := '???????';
  Table1.Close;
  Table1.Free;
  ADConnection.Free;
end;

Function ClientExists(FileNm:string): Boolean;
Var
    ADConnection: TADConnection;
    Table1: TADTable;
begin
  Result := False;

  //Table1.DataBaseName := ClientsDb;
  //Table1.ConnectionString:=FpClientsConnectionString;

  //20150922 Igor
  ADConnection:= TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  SetTableName(ADConnection, Table1, '', cfgClientsDbLite_noUse, 'File_Name');

  Table1.First;
  If Table1.Locate('File_Name',FileNm,[]) then
   result := True
  else
   result := False;
  Table1.Close;
  Table1.Free;
  ADConnection.Free;
end;

Function GetClientLastFirstName(FileNm:string): String;
Var
    ADConnection: TADConnection;
    Table1: TADTable;
begin
  Result := '';

  //Table1.DataBaseName := ClientsDb;
  //Table1.ConnectionString:=FpClientsConnectionString;

  //20150922 Igor
  ADConnection:= TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  SetTableName(ADConnection, Table1, '', cfgClientsDbLite_noUse, 'File_Name');

  Table1.First;
  If Table1.Locate('File_Name',FileNm,[]) then
   result := AllTrim(Table1.FieldByName('LastName').AsString)+ ' '+
     AllTrim(Table1.FieldByName('FirstName').AsString)
  else
   result := '';
  Table1.Close;
  Table1.Free;
  ADConnection.Free;
end;


Function OpenClientsDb(UserId:string): boolean;
Var
    DB: TADConnection; //20150922 Igor
begin
  Result := false;
  Db := TADConnection.Create(Application);
  //Db.DataBaseName := ClientsDb;
  //Db.AliasName :=Db.DataBaseName; {needed}
  DB.LoginPrompt := False;
  Try
   Db.Open;
  except
   on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
  end;
  Result := Db.Connected;
end;

Function OpenFundsDb(UserId:string): boolean;
Var
    FundDataDb: TADConnection; //20150922 Igor
begin
   //If LicenseLevel < '2' then exit;
   If LicenseLevel < llStd then exit;
   Result:=false;
   FundDataDb := TADConnection.Create(Application);
   //FundDataDb.DataBaseName := FundsDb;
   //FundDataDb.AliasName :=FundDataDb.DataBaseName; {needed}
   FundDataDb.LoginPrompt := False;

   Try
     FundDataDb.Open;
   except
     on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
     {
     ShowMessage('The FundData Data Base cannot be opened'+
     Chr(13)+'Ensure that it is configured properly');
     }
   end;
   {ShowMessage('Southam Funds Data Base Opened successfully');}
   Result:=FundDataDb.Connected;
end;

Procedure ShowOpenReturnFailure(FailCode: integer;DataDir: String; FlName: string);
begin
  Case FailCode of
  -1 :  ShowMessage('File '+ FlName +' does not exist'+
           Chr(13)+'in dir: '+ DataDir);
  -2 :  ShowMessage('File '+FlName +' is not a FP file');
  -3 :  ShowMessage('Exceeds number of maximum files in memory');
  else ShowMessage('Some error occured');
  end;
end;

procedure LoadDataDict;
begin
  if DataDictList = nil then
    DataDictList := TDataDictList.Create;
  DataDictList.Load(AppDir);
end;

function InDataDict(KeyW: String):Boolean;
Var I :integer;
begin
 KeyW:=UpperCase(KeyW);
 //assumed present
 If (LeftStr(KeyW,5)='LINE_')
 Or (LeftStr(KeyW,5)='FORM_')
 Or (LeftStr(KeyW,4)='FNUM')
 Or (LeftStr(KeyW,4)='FIMG')
 then
 begin Result:=True; Exit; End;

 Result :=False;
 for i :=0 to (DataDictList.Count - 1) do
 begin
     DataDictRec := DataDictList.Items[i];
     If KeyW = UpperCase(MidStr(DataDictRec.KeyWord,1,100))
      then begin Result := True;Exit;End;
 end;
End;

function GetDataDictFormName(KeyW: String):String;
Var I :integer;
begin
Result :='';
for i :=0 to (DataDictList.Count - 1) do
  begin
     DataDictRec := DataDictList.Items[i];
     If KeyW = MidStr(DataDictRec.KeyWord,1,255)
      then begin Result := DataDictRec.FormName;Exit;End;
   end;
End;

function GetDataDictElmNo(KeyW: String):Integer;
Var I :integer;
begin
Result :=0;
for i :=0 to (DataDictList.Count - 1) do
  begin
     DataDictRec := DataDictList.Items[i];
     If KeyW = MidStr(DataDictRec.KeyWord,1,255)
      then begin Result := DataDictRec.Field_No;Exit;End;
   end;
End;

Function ClientBirthDate(RetNo:Integer):String;
begin
 Result := FetchElm(RetNo,'PROFILE',27);
end;

Function SpouseBirthDate(RetNo:Integer):String;
begin
 Result := FetchElm(RetNo,'PROFILE',29);
end;

Function ClientAge(RetNo:Integer): Integer;
{birthdate in form yyyy-mm-dd}
Var BirthDate:String;
Begin
 Result :=0;
 If RetNo=0 then exit;
 BirthDate := ClientBirthDate(RetNo);
 If Length(BirthDate) =0 then begin Result :=0;exit;end;
 Result := MyStrToInt(GetCurYear) - MyStrToInt(LeftStr(BirthDate,4));
 //Result := MyStrToInt(AppYear) - MyStrToInt(LeftStr(BirthDate,4));
 If result >120 then result :=0;
end;

Function CalcAge(BirthDate: string): Integer;
{birthdate in form yyyy-mm-dd}
Begin
 If Length(BirthDate) =0 then begin Result :=0;exit;end;
 Result :=Trunc(Vl(LeftStr(FormatDateTime('yyyy-mm-dd',Now),4)) - Vl(LeftStr(BirthDate,4)));
 // appyear
end;

Function ClientYearOfRetirement(RetNo:Integer): String;
Begin
 Result :='';
 If RetNo=0 then exit;
 Result := IntToStr(StrToInt(GetCurYear)+ClientYearsToRetirement(RetNo)-1);
end;

Function SpouseYearOfRetirement(RetNo:Integer): String;
Begin
 Result :='';
 If RetNo=0 then exit;
 Result := IntToStr(StrToInt(GetCurYear)+SpouseYearsToRetirement(RetNo)-1);
end;


Function ClientYearOfUltimateAge(RetNo:Integer): String;
Begin
 Result :='';
 If RetNo=0 then exit;
 Result := IntToStr(StrToInt(GetCurYear)+ClientYearsToUltimateAge(RetNo));
end;

Function SpouseYearOfUltimateAge(RetNo:Integer): String;
Begin
 Result :='';
 If RetNo=0 then exit;
 Result := IntToStr(StrToInt(GetCurYear)+SpouseYearsToUltimateAge(RetNo));
end;


Function SpouseAge(RetNo:Integer): Integer;
{birthdate in yyyy-mm-dd}
Var BirthDate:String;
Begin
 Result :=0;
 If RetNo=0 then exit;
 BirthDate := SpouseBirthDate(RetNo);
 If Length(BirthDate) =0 then begin Result :=0;exit;end;
 Result := StrToInt(GetCurYear) - StrToInt(LeftStr(BirthDate,4));
end;

Function ClientUltimateAge(RetNo:Integer): Integer;
Begin
 Result:=MyStrToInt(FetchElm(RetNo,'GOALS',6));
end;

Function SpouseUltimateAge(RetNo:Integer): Integer;
{birthdate in form dd-mm-yyyy}
Begin
 Result:=MyStrToInt(FetchElm(RetNo,'GOALS',12));
end;


Function ClientAgeAtRetirement(RetNo:Integer): Integer;
{birthdate in form dd-mm-yyyy}
Begin
 result:=MyStrToInt(FetchElm(RetNo,'GOALS',4));
end;

Function SpouseAgeAtRetirement(RetNo:Integer): Integer;
{birthdate in form dd-mm-yyyy}
Begin
 result:=MyStrToInt(FetchElm(RetNo,'GOALS',10));
end;

Function ClientYearsToRetirement(RetNo:Integer): Integer;
{birthdate in form dd-mm-yyyy}
Begin
 result := ClientAgeAtRetirement(RetNo)- ClientAge(RetNo)+1;
 If result<0 then result :=0;
end;


Function SpouseYearsToRetirement(RetNo:Integer): Integer;
{birthdate in form dd-mm-yyyy}
Begin
 result := SpouseAgeAtRetirement(RetNo)- SpouseAge(RetNo)+1;
 If result<0 then result :=0;
end;

Function ClientRetirementYears(RetNo:Integer): Integer;
Begin
 result := ClientUltimateAge(RetNo)-ClientAgeAtRetirement(RetNo)-1;
 If result <0 then result :=0;
end;

Function SpouseRetirementYears(RetNo:Integer): Integer;
Begin
 result := SpouseUltimateAge(RetNo)-SpouseAgeAtRetirement(RetNo)-1;
 If result <0 then result :=0;
end;


Function ClientYearsToUltimateAge(RetNo:Integer): Integer;
Begin
 result := ClientUltimateAge(RetNo)-ClientAge(RetNo);
 If result <0 then result :=0;
end;

Function SpouseYearsToUltimateAge(RetNo:Integer): Integer;
Begin
 result := SpouseUltimateAge(RetNo)-SpouseAge(RetNo);
 If result <0 then result :=0;
end;


Function ValidSin(SiNum: string):boolean;
begin
Result := True;
If Length(SiNum) <> 9 then begin Result := false;exit;end;
If ChkDigit(LeftStr(SiNum,8)) <> StrToInt(RightStr(SiNum,1))
   then Result := false;
end;

Function InvalidAmountInLetter(s:string):boolean;
begin
Result :=false;
if ((s<'0') or (s>'9')) and
         (s<>'.') and (s<>' ')and (s<>'-') and
         (s<>',') and
         (s<>'(') and (s<>')') and (s<>'$')
         then
         result := true;
end;

procedure InterpretTextLine(Var Txt:AnsiString);
begin
EXIT;
end;


procedure ConditionEvaluator(ConditionLine:string;var CCheck:boolean; var error:boolean);
{ConditionLine comes as: #If#  -12000.00 > 0 then}
var Val1,Val2:real;
    i,count:integer;
    ValStr,temp:string;
    great,less,eql:boolean;
    t1,t2:boolean;
    cand,cor:boolean;
    J,N1StartsAt,N2StartsAt:integer;
begin
  {remove leading spaces before the amount}
  Temp := AllTrim(MidStr(ConditionLine,5,255));
  Temp := AllTrim(Temp);
  If (LeftStr(Temp,1) ='<') or (LeftStr(Temp,1) ='>')
     or (LeftStr(Temp,1) ='=') then {null value came}
     Temp := '0 '+Temp;
  ConditionLine := LeftStr(ConditionLine,4)+Temp;

  error:=False;
  i:=5;
  great:=false;
  less:=false;
  eql := false;
  ValStr:='';  {the string of each number}
  cand:=false;
  cor:=false;
  J:=Length(ConditionLine);
  N1StartsAt :=5;
  {get first number}

  count := N1StartsAt;
  Repeat
      {Number invalid check}
      if InvalidAmountInLetter(ConditionLine[count]) then
        begin ShowMessage('Invalid Number'); error:=True;exit; end;

      {take number out of the string}
      if ((ConditionLine[count]>='0') and (ConditionLine<='9')) or (ConditionLine[count]='.')
       or (ConditionLine[count]='-')
       then
         ValStr:=ValStr+ConditionLine[count];
      if ConditionLine[count]=' ' then
         begin
         i:=count+1;
         count:=Length(ConditionLine);
         If ValStr ='' then
           Val1:=0
         else
           Val1:=Vl(ValStr); {no commas}
         ValStr:='';
         end;
     Inc(Count);
   until Count > j;

  {get > < position}
  Count :=i;
  Repeat
      if (ConditionLine[count]='>') or (ConditionLine[count]='<') or (ConditionLine[count]='=')
         or (ConditionLine[count]='-') then
         begin
         if      ConditionLine[count]='>' then great:=True
         else if ConditionLine[count]='<' then less:=true
         else if ConditionLine[count]='=' then eql:=true;
         i:=count;
         count:=Length(ConditionLine);
         end;
    Inc(Count);
   until count >J;

  {get second amount}
  If ConditionLine[i+1] =' ' then N2StartsAt:=i+2 else N2StartsAt:=i+1;
  Count:= N2StartsAt;
  Repeat
      If ConditionLine[count]= '\' then break; //rtf: \par
      if InvalidAmountInLetter(ConditionLine[count]) then
          begin ShowMessage('Invalid Number');error:=True; exit; end;
      if ((ConditionLine[count]>='0') and (ConditionLine[count]<='9')) or (ConditionLine[count]='.') then
          ValStr:=ValStr+ConditionLine[count];
      if (ConditionLine[count]=' ') or (ConditionLine[count]=')') then
         begin
         i:=count;
         count:=Length(ConditionLine);
         Val2:=Vl(ValStr); {StrToFloat(Ltrim(nstr));} {Vl(FormatAmount(nStr)); {no commas}
         ValStr:='';
         end;
    Inc(Count);
  until Count >j;
  {Compare the extracted numbers}
  if (great=true) and (Val1>Val2) then t1:=true;
  if (great=true) and (Val1<=Val2) then t1:=False;

  if (less=true) and (Val1<Val2) then t1:=true;
  if (less=true) and (Val1>=Val2) then t1:=false;

  if (eql=true) and (Val1=Val2) then t1:=true;
  if (eql=true) and (Val1<>Val2) then t1:=False;

   CCheck := t1;  {CCheck is true if t1 condition is true}
end;

Procedure ReplaceText(LetterBody:TMemo;
          Cursor_Position:Integer;
          KeyWLength : Byte;
          ReplaceText: string);
var
i,j,k,PosReturn, SkipChars: Integer;
begin
  With LetterBody do
  begin
   SelStart:=cursor_position-1;
   SelLength:=KeyWLength+1;
   SelText:=ReplaceText;
  end;
end;

Procedure ResolveConditions(AList:Tstrings);
var i,Place: Integer;
    errorC:Boolean;
    NetList :TstringList;
    KeyW : string;
    Size:word;
    Buffer, WorkBuffer:Pchar;
    CheckKey:Boolean;
    LineNum:LongInt;
    ConditionStr:string;
    CheckCondition:boolean;
    exchange:string;
    J,K,L,M:integer;
    MaxLine:integer;
    f:TextFile;
    s:AnsiString;
begin
 {now Condition interpret}
  NetList := TstringList.Create;
  errorC:=False;
  MaxLine := AList.Count;
  {Replace condition lines}
  i:=0;
  Repeat
    Place :=pos('#If#',AList[i]);
    If Place =0 then  {no If statement}
    begin
      NetList.Add(Alist[i]);
    end
    else
    begin
       LineNum:=I;  {lineNum has the If statement}
       s:=MidStr(Alist[LineNum],Place,255);
       ConditionEvaluator(S,checkCondition,errorC);
       if errorC=True then exit;

       {If condition is true}
       if checkCondition=True then
       begin
           J:=1; {j counts the lines after a true if}
           while (Pos('#Else#',AList[LineNum+J])=0)
                 and (Pos('#Endif#',AList[LineNum+J])=0) and
                 (LineNum+J<MaxLine) do
                 J:=J+1;

           for K:=1 to J-1 do
                NetList.Add(AList[LineNum+K]); {copy lines after ^If}

           if (Pos('#Else#',AList[LineNum+J])>0) then
              begin
              L:=J+1;
              while (Pos('#Endif#',AList[LineNum+L])=0)
               and
                (LineNum+L<MaxLine) do
                 L:=L+1;
              end
           else
              L:=J;
           I:=I+L;
       end;

       if checkCondition=False then
       begin
           J:=1; {j counts the lines after a false if}
           while (Pos('#Else#',AList[LineNum+J])=0)
            and (Pos('#Endif#',AList[LineNum+J])=0)
            and (LineNum+J<MaxLine) do
                 J:=J+1;

           if (Pos('#Endif#',AList[LineNum+J])>0) then
              L:=J
           else
              begin
              L:=J+1;
              while (Pos('#Endif#',AList[LineNum+L])=0)
               and
                (LineNum+L<MaxLine) do
                 L:=L+1;
              for K:=J+1 to L-1 do
                  NetList.Add(AList[LineNum+K]);
              end;
           I:=I+L;
       end;
    end;
    Inc(i); {?}
   until i > MaxLine-1;
   AList.Clear;
   For i:=0 to NetList.count -1 do AList.Add(NetList[i]);
   NetList.Free;
end;


Procedure RemoveEmptyLines(TempList:Tstrings);
Var i:integer;
begin
  I:=0;
  While i < TempList.Count do
   begin
    If LTrim(Rtrim(Templist[i])) = '' then
     Templist.Delete(i)
    else
     Inc(i);
   end;
end;

Procedure RemoveLastEmptyLines(TempList:Tstrings);
Var i:integer;
begin
  I:=TempList.Count-1;  {start from bottom}
  While i >0 do
  begin
    If LTrim(Rtrim(Templist[i])) > '' then
     exit
    else
    begin
      If LTrim(Rtrim(Templist[i])) = '' then
       begin Templist.Delete(i);Dec(i);end
      else Dec(i);
    end;
  end;
end;

Procedure ReplaceKeyWord( Var Txt:AnsiString;Cursor_Position:Integer;
 KeyWLength:integer;ReplaceString:String);
begin
 Txt := LeftStr(Txt,Cursor_position-1)
        +ReplaceString
        +MidStr(Txt,Cursor_position+KeyWLength+2,255);
end;

Procedure ReplaceAString( Var Txt:String;Cursor_Position:Integer;
 KeyWLength:integer;ReplaceString:String);
begin
 Txt := LeftStr(Txt,Cursor_position-1)
        +ReplaceString
        +MidStr(Txt,Cursor_position+KeyWLength,255);
end;

Function ClcR(FieldId:integer;PgmValue:real;FormOvrSw:boolean;
              RetNo:integer;FormNo:integer):Real;
Var I:integer;
begin
 If FormOvrSw = False then
   Result := PgmValue
 else
   Result := Vl(GetOvrValue(RetNo,FormNo,FieldId));
end;

function InitFormsTable: boolean;
begin
  Result := FList.InitFormsTable(AppDir, FormsDBLite, FormsTableLite);//20150918 Igor

  if Result then
    exit; //okay
  AppFP.PrepareDistribution;

  Result := FList.InitFormsTable(AppDir, FormsDBLite, FormsTableLite);//20150918 Igor

  if Result then
    exit; //okay
  UserMsg('Please fix errors in FP forms');
  Application.Terminate;
end;

Procedure ExpandTabs(AList:Tstrings);
var i,j:integer;TabChar,s:string;
begin
 exit;  {?}

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
end;

Function GetTotalFee(RetNo:Integer):Real;
Var I:integer;
begin
 Result:=0;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If Ret[RetNo].FrmHasData[Frec.FormNo] then
    If Frec.FormInst >'#1' then
     Result := Result+ Vl(FRec.FeeAddItem)
    else
     Result := Result+ Vl(FRec.Fee);
 end;
end;

Procedure GetListInvoiceForms(RetNo:Integer;Frms,HowMany:Tstrings);
Var i,j:integer;
begin
 {Count non multi-instance forms}
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If (Ret[RetNo].FrmHasData[Frec.FormNo]) and
     (Vl(Frec.Fee) >0) and (Frec.FormInst = '') then
     begin
      Frms.Add(Frec.FormName);
      HowMany.Add('1');
     end;
 end;   {Flist do}
 {Count multiple forms, add them to the lists}
 CountMulties(RetNo,Frms,HowMany);
end;

Function GetFormFee(FormName:String;Qty:integer):Real;
Var I:integer;
begin
 Result:=0;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If FormName = Frec.FormName then
    Result := Vl(FRec.Fee) + (Qty-1)* Vl(FRec.FeeAddItem);
 end;
end;

Function GetAreaCode(RetNo:integer):String;
begin
 result := FetchElm(RetNo,'PROFILE',15);
end;

Function GetPhoneNo(RetNo:integer):String;
begin
 result := FetchElm(RetNo,'PROFILE',15)+' '+FetchElm(RetNo,'PROFILE',16);
end;

Function GetFaxNo(RetNo:integer):String;
begin
 result := FetchElm(RetNo,'PROFILE',87)+' '+FetchElm(RetNo,'PROFILE',88);
end;

Function GetOfficeNo(RetNo:integer):String;
begin
 result := FetchElm(RetNo,'PROFILE',90)+' '+FetchElm(RetNo,'PROFILE',91);
end;

Function GetEmailNo(RetNo:integer):String;
begin
 result := FetchElm(RetNo,'PROFILE',89);
end;


Function ClientFirstName(RetNo:integer):String;
begin
 Result :='';
 If retNo<1 then exit;
 result := FetchElm(RetNo,'PROFILE',1);
end;

Function SpouseFirstName(RetNo:integer):String;
begin
 result := FetchElm(RetNo,'PROFILE',17);
end;


Function GetSinNo(RetNo:integer):String;
begin
 result := FetchElm(RetNo,'PROFILE',3);
end;

Function GetSpouseSinNo(RetNo:integer):String;
begin
 result := FetchElm(RetNo,'PROFILE',4);
end;


Function InputDateToMMDDYYYY(InputDate:String):string;
{input date in form dd-mm-yyyy, output as mm/dd/yyyy}
begin
 result :='';
 If InputDate ='' then exit;
 Result := MidStr(InputDate,4,2)+'/'+LeftStr(InputDate,2)+
           '/'+MidStr(InputDate,7,4);
end;

Function ClientLastName(RetNo:integer):String;
begin
  result :='( No Client )';
 If RetNo=0 then exit;
 result := AllTrim(FetchElm(RetNo,'PROFILE',2));
end;

Function SpouseLastName(RetNo:integer):String;
begin
 result := FetchElm(RetNo,'PROFILE',82);
end;


Function IsReturnPaid(RetNo:integer):Boolean;
begin
 Result := False;
 If FetchElm(RetNo,'INV_2',23)+ FetchElm(RetNo,'INV_2',24)+
    FetchElm(RetNo,'INV_2',25) > ''
   then Result :=True;

end;

Function  CountKids(RetNo:Integer):Integer;
Var i:integer;
begin
result:=0;
i:=43;
Repeat
 If FetchElm(RetNo,'PROFILE',i) >'' then Inc(Result);
 Inc(i,4);
until i>75;
end;

Function MyPresentValue(FutureAmount:Real; Years:Integer; Interest:Real):Real;
Var i:integer; x, Denominator:real;
begin
 Interest := Interest/100;
 result := FutureAmount / XtoY(1+Interest,Years);
end;

Function FutureValue(OpeningBalance:Real; Interest:Real;Years:Integer):Real;
//single amount
Var i:integer; RunningBalance:real;
begin
 Interest := Interest/100;
 result := OpeningBalance * XtoY(1+Interest,Years);
end;

Function CapitalToGenIncome(AnnualIncome:Real; Years:Integer; Interest:Real):Real;
Var i:integer; FutureAmount:real;
begin
 If Interest =0 then begin result :=0 ; exit;end;
 Result := AnnualIncome * (100/Interest);
end;

Function GetPlanYear(RetNo:Integer):String;
begin
  Result := FetchElm(RetNo,'PROFILE',80);
end;

Function CalcAfterToBeforeFactor(Income:Real):Real;
Var i:Integer;
begin
 result :=0;
 For i:=0 to MarginalFrom.count -1 do
 begin
  If (Income <= vl(MarginalTo[i])) then
   begin result := Vl(MarginalRate[i]); exit; end;
 end;
end;

Function ClientMarginalRate(RetNo: integer):Real;
begin
  Result := CalcMarginalRate(Vl(FetchElm(RetNo,'CASHFLOW',62))); //net income
end;

Function SpouseMarginalRate(RetNo: integer):Real;
begin
  Result := CalcMarginalRate(Vl(FetchElm(RetNo,'CASHFLOW',63)));
end;

Function ConvertToAfterTax(BeforeTax:Real;BToAFactor:Real):Real;
begin
  result := BeforeTax;
  If BToAFactor >0 then
   Result := BeforeTax / BToAFactor;
end;

Function ConvertToBeforeTax(AfterTax:Real;BToAFactor:Real):Real;
begin
  Result :=AfterTax;
  If BToAFactor >0 then
     Result := AfterTax * BToAFactor;
end;

Function GetRRSPLimit(RetNo:Integer):Real;
begin
  result := Vl(FetchElm(RetNo,'RETPLAN',40));
end;

Function GetShFallDiscount(RetNo:Integer):Real;
begin
  result := Vl(FetchElm(RetNo,'RETPLAN',53));
end;

Function GetMargRate(RetNo:Integer):Real;
begin
  result := Vl(FetchElm(RetNo,'RETPLAN',29));
end;


Function BeforeToAfterTaxRate(AfterTax:Real;BeforeTax:Real):Real;
Begin
 If BeforeTax >0 then
   result := AfterTax/BeforeTax
 else
   result :=1;
end;

Function CalcMarginalRate(Income:real):Real;  //net income
begin
 If Income < 29590 then begin result :=27;exit;end;
 If Income > 59180 then begin result :=50;exit;end;
 result := 42;
end;

Function GetMarginalRate(RetNo:Integer):Real;
begin
 Result := Vl(FetchElm(RetNo,'RETPLAN',29));
end;


Function InputDateDMYToYMD(Dt:String):string;
begin
 result := RightStr(Dt,4)+'-'+MidStr(Dt,3,2)+'-'+LeftStr(Dt,2);
end;

Function GetPrvIndex(SPrv: string): Integer;
Var i : integer;
Begin
  Result := 6;  {Ontario}
  For i := 1 to High(PrvShort) do
   begin
    If UpperCase(SPrv) = UpperCase(PrvShort[i]) then
    begin Result := i;exit;end;
   end;
End;

Function GetPrvLongIndex(LPrv: string): Integer;
Var i : integer;
Begin
  Result := 6;  {Ontario}
  For i := 1 to High(PrvLong) do
   begin
    If UpperCase(LPrv) = UpperCase(PrvLong[i]) then
    begin Result := i;exit;end;
   end;
End;


Function PrintAListing(FileNm,Hdr1,Hdr2,Hdr3: String):boolean;
var
  i,LineCnt,MxLinesPerPage,PageCnt:integer;PrnFile: TextFile;
  {TempList:TstringList;}
  XPos :LongInt;PageX, PageY : LongInt;
  ScMult : Integer; s:string;
  F1 :TextFile;
  ScaleX, ScaleY : Word;
  FirstTimeSw:boolean;
begin
  AssignFile(F1, FileNm);
  Reset(F1);

  FirstTimeSw := true;
  LineCnt:=0;PageCnt :=0;MxLinesPerPage :=60;
  {now print}
  Printer.BeginDoc;
  XPos := 70;
  ScMult :=10;
  PageX:= Printer.PageWidth;
  PageY :=Printer.PageHeight;
  ScaleX := (PageX * ScMult) div 614; {to get the decimals}
  ScaleY := (PageY * ScMult) div 1000; {formheight}

  Repeat
   If (FirstTimeSw) or (LineCnt >MxLinesPerPage) then
   begin  {print headers}
     LineCnt:=1;
     Inc(PageCnt);
     If not FirstTimeSw then Printer.NewPage;

     Printer.Canvas.Font.Name := 'Arial';
     Printer.Canvas.Font.Size := 10;
     Printer.Canvas.Font.Style := [fsBold];
     Printer.Canvas.TextOut(
       (XPos * ScaleX) div ScMult,(LineCnt*15 * ScaleY) div ScMult,
        Hdr1+' Page: '+IntToStr(PageCnt));

     Inc(LineCnt); {leave empty line}
     Printer.Canvas.Font.Name := 'Courier New';
     Printer.Canvas.Font.Size := 8;
     Printer.Canvas.Font.Style := [];
     Inc(LineCnt);
     Printer.Canvas.TextOut(
        (XPos * ScaleX) div ScMult,(LineCnt*15 * ScaleY) div ScMult,Hdr2);

     Inc(LineCnt);
     Printer.Canvas.TextOut(
        (XPos * ScaleX) div ScMult,(LineCnt*15 * ScaleY) div ScMult,Hdr3);
     Inc(LineCnt,1);
   end; {headers}
   FirstTimeSw := False;
   Printer.Canvas.Font.Style := [];
   Readln(F1,s);
   Printer.Canvas.TextOut(
    (XPos * ScaleX) div ScMult,(LineCnt*15 * ScaleY) div ScMult,
          s);
   Inc(LineCnt);
  until Eof(F1);
  CloseFile(F1);
  Printer.EndDoc;
  Result := True;
end;

procedure OnestepCom;
Var h : THandle; ClickedOK : Boolean;EFMethod:string;
  ZString : Array[0..80] of Char;  PointerToDir : Pchar;
begin
  WriteFileForEfCom;
  PointerToDir := StrPCopy(ZString,AppDir);
  h := ShellExecute(Application.MainForm.Handle, Nil, 'GPCOM.EXE', Nil,PointerToDir, SW_RESTORE);
  {h := ShellExecute(MdiHandle, Nil, 'FPCOM.EXE', Nil,PointerToDir, SW_RESTORE);}
  If H<=32 then
  Begin
   ShowMessage('Program cannot execute. Error Code = '+IntToStr(h));
   SomeCaption := 'Error codes';
   PopSomeFile(AppDir+'\'+'SHELLERR.D',SomeCaption);
  end;
end;


Procedure WriteFileForEFCom;
Var TempList:TStringList;
begin
  TempList :=TstringList.Create;
  Templist.Add(User.UserName); //20170112 Igor
  Templist.Add(AppDir);
  Templist.Add(LicenseName);
  TempList.SaveToFile(AppDir+'\'+'UserData.d');
  TempList.Free;
end;

Function GetFirstName(RetNo:integer):String;
begin
 result := FetchElm(RetNo,'PROFILE',1);
end;

Function GetLastName(RetNo:integer):String;
begin
 result := FetchElm(RetNo,'PROFILE',2);
end;

Procedure ApplyClientRange(ThisTable:TDataSet; FileNm:String);
Begin
 ShowMessage ('Apply range fails');
 With ThisTable do
 begin
   Filter := 'ThisTable.FieldByName(QuotedStr(FileNm).AsString ='
   + QuotedStr(FileNm) +'='+QuotedStr(FileNm);
 end;
end;

Function GetMFundsMasterData(FundCode:string; Var MFundsMastRec:TMFundsMastRec):Boolean;
var ADConnection: TADConnection;
    Tbl: TADTable; // Tbl:T Table; //TAdoTable;
Begin
  Result := false;
  FundCode:=UpperCase(FundCode);

  //Tbl.DataBaseName := ClientsDb;
  //Tbl.ConnectionString:=FundBaseConnectionString;

  //20150922 Igor
  ADConnection:= TADConnection.Create(Application);
  Tbl := TADTable.Create(Application);
  SetTableName(ADConnection, Tbl, '', MutualFundsTableLite, 'FUNDCODE');

  if Tbl.FindKey([FundCode]) then  { If Tbl.Locate('FundId',FundId,[]}
  begin
    Result := true;
    FillMFundsMastRec(Tbl,MFundsMastRec);
  end;
  Tbl.Close;
  Tbl.Free;
  ADConnection.Free;
end;

Procedure FillMFundsMastRec(Tbl:TDataSet; Var MFundsMastRec:TMFundsMastRec);
begin
 With Tbl do
 begin
  with MFundsMastRec do
   begin
    FundCode:= FieldByName('FundCode').AsString;
    FundName  := FieldByName('FundName').AsString;
    UnitPrice := FieldByName('UnitPrice').AsFloat;
    Date      := FieldByName('PriceDate').AsString;
   end;
  end;
end;

Procedure GetFormsToPrint(RetNo:integer;Template:string;FormsToPrint:Tstrings);
var i,j,FNo:integer;Copies,n,sss,Fname :String;
  TemplCopies: TTemplCopies;
begin
 If not FileExists(AppDir+'\'+Template) then
  begin
   ShowMessage('Print Template: '+AppDir+'\'+Template+
             chr(13)+'does not exist');
   exit;
  end;
  TemplCopies := TTemplCopies.Create(RetNo, AppDir, Template);

  For i:=0 to FList.Count-1 do {run thru all forms available}
  begin
   FRec := FList.Items[i];
   FNo :=Frec.FormNo;
   If (FNo > 0)
   and Ret[RetNo].FrmHasData[FNo] //then {has data and it is in template}
   // and IsInList(Frec.FormName,TemplForms)>-1 then
   and (TemplCopies.IsExactlyInList(FRec.FormName)>=0) then
    begin
      //If Frec.FormName>'' then        //20110228
        FormsToPrint.Add(Frec.FormInstName);
    end;
  end;
  {match and attach number of copies}
  TemplCopies.FinishPrintList(FormsToPrint);
  TemplCopies.Free;
end;

function ExecuteFile(const FileName, Params, DefaultDir: string;
  ShowCmd: Integer): THandle;
var
  zFileName, zParams, zDir: array[0..79] of Char;
begin
  Result := ShellExecute(Application.MainForm.Handle, nil,
    StrPCopy(zFileName, FileName), StrPCopy(zParams, Params),
    StrPCopy(zDir, DefaultDir), ShowCmd);
end;


{Accum procedures}

Procedure BuildInvDetailProjection(RetNo:Integer);
type
    PEvent  = ^AEventRec;  {list of pointers to records}
    AEventRec = record
     Description  : string; //[25];
     Year         :Integer;
     EventType    :string; //[1];
     Amount      : Real;
    end;
Var i,StartAge:Integer;InvestedAmount:real;RunningBalance:Array[1..5] of Real;
    StreamId:Integer;
    RifWithdrRate:Real;
    InterestRate:Real;
    FNo:Integer;
    //for event processing
    EventsList  : TList;
    EventRec    : PEvent;
    FromYear,ToYear:string; //[4];
    EventDescr:String;
    EventType:string; //[1];
    YearlyAmount:Real;
    NonShPercent,SemShPercent,SheltPercent,OtherPercent:Real;
    CurrentShortFall:Real;
begin
  GetRetirementParms(RetNo);
  {initialize}
  //BalanceList.Clear;
  //BalanceList.Capacity:=RetirementParms.NumbPeriods+2;
  StartAge := GetPlanStartAge(RetNo);
  For StreamId:=1 to 4 do RunningBalance[StreamId]:=0;
  For i:=0 to RetirementParms.NumbPeriods do
  begin
   //New(BalanceRec);
   BalanceRec :=TBalanceRec(BalanceList.Items[i]);
   BalanceRec.PeriodNo      := i;
   BalanceRec.Year          := (RetirementParms.StartYear)+i;
   BalanceRec.Age[0]           := StartAge+i;

   For StreamId :=1 to 4 do
   begin
    BalanceRec.BegBalance[StreamId]    := 0;
    BalanceRec.RegContr[StreamId]      := 0;
    BalanceRec.RegWithDr[StreamId]     := 0;
    BalanceRec.LumpSumContr[StreamId]  := 0;
    BalanceRec.LumpSumWithDr[StreamId] := 0;
    BalanceRec.EndBalance[StreamId]    := 0;
    BalanceRec.EndActual[StreamId]     := 0;
    BalanceRec.Notes[StreamId]  := '';
   end;
 //  BalanceList.Add(BalanceRec);
  end;

  {initialize with lumpsum from life events}

  //BuildEducation stream
  If UpperCase(FetchElm(RetNo,'EDUPLN#1',16))='Y' then
  begin
   for i :=0 to (FList.Count - 1) do
   begin
    FRec := FList.Items[i];
    If Frec.FormName = 'EDUPLN' then
    begin
     If Ret[RetNo].FrmHasData[Frec.FormNo] then
     begin
       FNo:=Frec.FormNo;
       FromYear:=FetchElmFNo(RetNo,FNo,18);
       ToYear  :=IntToStr(MyStrToInt(FetchElmFNo(RetNo,FNo,6))
                 +MyStrToInt(FetchElmFNo(RetNo,FNo,7))-1);
       EventDescr:='Educ-'+LeftStr(FetchElmFNo(RetNo,FNo,3),1);
       EventType:='W';
       YearlyAmount:=Vl(FetchElmFNo(RetNo,FNo,20));
       NonShPercent:=100;
       SemShPercent:=0;SheltPercent:=0;OtherPercent:=0;
       PutEventInBalanceList(RetNo,EventDescr,FromYear,ToYear,EventType,YearlyAmount,
       NonShPercent,SemShPercent,SheltPercent,OtherPercent);
     end; //EDUPLN has data
    end; //edupln found
   end;  //i
  end  //educ
  else
  begin
   for i :=0 to (FList.Count - 1) do
   begin
    FRec := FList.Items[i];
    If Frec.FormName = 'EDUPLN' then
    begin
       FNo:=Frec.FormNo;
       FromYear:=FetchElmFNo(RetNo,FNo,18);
       ToYear  :=IntToStr(MyStrToInt(FetchElmFNo(RetNo,FNo,6))
                 +MyStrToInt(FetchElmFNo(RetNo,FNo,7))-1);
       EventDescr:='Educ-'+LeftStr(FetchElmFNo(RetNo,FNo,3),1);
       EventType:='W';
       YearlyAmount:=Vl(FetchElmFNo(RetNo,FNo,20));
       NonShPercent:=100;
       SemShPercent:=0;SheltPercent:=0;OtherPercent:=0;
       PutEventInBalanceList(RetNo,'',FromYear,ToYear,'',0,0,0,0,0);
    end; //edupln found
   end;  //i


  end;
  FetchLifeEventsStreams(RetNo);

  {Calc balances}
Try
  For i:=0 to RetirementParms.NumbPeriods do
  begin
    BalanceRec := TBalanceRec(BalanceList.Items[i]);
    For StreamId:=1 to 4 do
    begin
      If i=0 then
       BalanceRec.BegBalance[StreamId]    := RetirementParms.OpeningBalance[StreamId]
      else
       BalanceRec.BegBalance[StreamId]    := RunningBalance[StreamId];

      {add regular contr from Disposable income and tax refund}
      If BalanceRec.Age[0] <= ClientAgeAtRetirement(RetNo) then
      begin
       InvProjectionRec:=InvProjectionList[i];
       CashFlowProjectionRec:=CashFlowProjectionList[i];
       Case StreamId of
        1: BalanceRec.RegContr[StreamId]:=BalanceRec.RegContr[StreamId]
           +InvProjectionRec.NonSh;
        2: BalanceRec.RegContr[StreamId]:=BalanceRec.RegContr[StreamId]
           +InvProjectionRec.Shelt[0]+InvProjectionRec.Shelt[1];
        3: BalanceRec.RegContr[StreamId]:=BalanceRec.RegContr[StreamId]
           +InvProjectionRec.SemiSh;
       end;  //case
      end;  //age related
      If RetirementParms.RegContr[StreamId] >0 then
        BalanceRec.Notes[StreamId]  := BalanceRec.Notes[StreamId]+',Investment';

      {apply shortfall to non sheltered prior to retirement - NEW}
      If (StreamId =1) then
      begin
       If CashFlowProjectionRec.DispInc<0 then
         CurrentShortFall:=ABS(CashFlowProjectionRec.DispInc)
       else
         CurrentShortFall:=0;
       If (BalanceRec.Age[0] < ClientAgeAtRetirement(RetNo))
       and (CurrentShortFall>0) then
       begin
         BalanceRec.RegWithDr[1] := BalanceRec.RegWithDr[1]+CurrentShortFall;
         BalanceRec.Notes[1]  := BalanceRec.Notes[1]+',ShortFall';
        end;
      end; //streamid 1

      {apply shortfall to non sheltered at retirement}
      If (StreamId =1) then
      begin
       If (BalanceRec.Age[0] >= ClientAgeAtRetirement(RetNo))
       and (RetirementParms.IncShortFall>0) then
       begin
         BalanceRec.RegWithDr[1] := BalanceRec.RegWithDr[1]+RetirementParms.IncShortFall;
         BalanceRec.Notes[1]  := BalanceRec.Notes[1]+',ShortFall';
        end;
      end; //streamid 1

      {add Regular Withdraw for RIF}
      If (StreamId =2)       //rrsp
      and (BalanceRec.Age[0] >vl(FetchElm(RetNo,'ASSUME',20)))  //start rif age
      and (BalanceRec.BegBalance[2] >= 0)
      and (UpperCase(FetchElm(RetNo,'ASSUME',19)) = 'Y')   //convert to RRIF
      then    {shelt}
      begin
        RifWithDrRate := GetNewRifRate(BalanceRec.Age[0]);
        BalanceRec.RegWithDr[2] :=BalanceRec.BegBalance[2] * RIFWithdrRate/100;
        If BalanceRec.RegWithDr[2]>0 then
        begin
         BalanceRec.Notes[2]  := BalanceRec.Notes[2]+',RRIF';
         {Add to non-sh}
         BalanceRec.LumpSumContr[1] :=BalanceRec.LumpSumContr[1]
          +(BalanceRec.RegWithDr[2]) *(100-GetMarginalRate(RetNo)) /100;
         BalanceRec.Notes[1]  := BalanceRec.Notes[1]+',RRIF';
        end;
      end;  //stream id 2

      InvestedAmount:=BalanceRec.BegBalance[StreamId];
      If BalanceRec.Age[0] <= ClientAgeAtRetirement(RetNo) then
       InterestRate:=Vl(RetirementParms.IntRate[StreamId])
      else
       InterestRate := Vl(FetchElm(RetNo,'RETPLAN',59));
      With BalanceRec do
       BalanceRec.EndBalance[StreamId] :=
       CalcEndBal(BegBalance[StreamId],InterestRate,RegContr[StreamId],
       LumpSumContr[StreamId],RegWithDr[StreamId],LumpSumWithDr[StreamId]);
    end;{streamId}

     {transfer to cash if negative}
     If BalanceRec.EndBalance[1] < 0  then XferToCash(RetNo,BalanceRec);
     {recalc end balance}
     For StreamId :=1 to 4 do
     begin
      InvestedAmount:=BalanceRec.BegBalance[StreamId];
      If BalanceRec.Age[0] <= ClientAgeAtRetirement(RetNo) then
       InterestRate:=Vl(RetirementParms.IntRate[StreamId])
      else
       InterestRate := Vl(FetchElm(RetNo,'RETPLAN',59));
      With BalanceRec do
       BalanceRec.EndBalance[StreamId] :=
       CalcEndBal(BegBalance[StreamId],InterestRate,RegContr[StreamId],
       LumpSumContr[StreamId],RegWithDr[StreamId],LumpSumWithDr[StreamId]);

      RunningBalance[StreamId] := BalanceRec.EndBalance[StreamId];
      BalanceRec.EndActual[StreamId]    := GetActualBalance(RetNo);

      If LeftStr(BalanceRec.Notes[StreamId],1) <> ',' then
        BalanceRec.Notes[StreamId] := ''
      else
       BalanceRec.Notes[StreamId] := MidStr(BalanceRec.Notes[StreamId],2,30);
     end;
  end;{i}


  For StreamId:=1 to 4 do RunningBalance[StreamId]:=0;
  For i:= 0 to RetirementParms.NumbPeriods do //BalanceList.Count-1 do
  begin
   For streamId :=1 to 4 do
     begin
      BalanceRec := TBalanceRec(BalanceList.Items[i]);
      If i=0 then
       BalanceRec.BegBalance[StreamId]    := RetirementParms.OpeningBalance[StreamId]
      else
       BalanceRec.BegBalance[StreamId]    := RunningBalance[StreamId];
      InvestedAmount:=BalanceRec.BegBalance[StreamId];
      If BalanceRec.Age[0] <= ClientAgeAtRetirement(RetNo) then
       InterestRate:=Vl(RetirementParms.IntRate[StreamId])
      else
       InterestRate := Vl(FetchElm(RetNo,'RETPLAN',59));
      With BalanceRec do
       BalanceRec.EndBalance[StreamId] :=
       CalcEndBal(BegBalance[StreamId],InterestRate,RegContr[StreamId],
       LumpSumContr[StreamId],RegWithDr[StreamId],LumpSumWithDr[StreamId]);

      RunningBalance[StreamId] := BalanceRec.EndBalance[StreamId];
     end;  //streamId
  end;  //i
 Except
  //ShowMessage('Calc error - Investment Detail');
 end;
end; {procedure}

Procedure BuildLiabilitiesProjection(RetNo:Integer);
Var i,StartAge:Integer;InvestedAmount:real;
    RunningBalance:Array[1..5] of Real;
    InterestRate:Real;
    FNo:Integer;
begin
  GetRetirementParms(RetNo);
  {initialize}
  //LiabilitiesProjectionList.Clear;
  //LiabilitiesProjectionList.Capacity:=RetirementParms.NumbPeriods+2;
  StartAge := GetPlanStartAge(RetNo);
  //For StreamId:=1 to 4 do RunningBalance[StreamId]:=0;
  For i:=0 to RetirementParms.NumbPeriods do
  begin
   //New(LiabilitiesProjectionRec);
   LiabilitiesProjectionRec :=LiabilitiesProjectionList.Items[i];
   LiabilitiesProjectionRec.PeriodNo      := i;
   LiabilitiesProjectionRec.Year          := (RetirementParms.StartYear)+i;
   LiabilitiesProjectionRec.Age           := StartAge+i;
   LiabilitiesProjectionRec.Mortgages     := 0;
   LiabilitiesProjectionRec.Automobiles   := 0;
   LiabilitiesProjectionRec.Other         := 0;
   LiabilitiesProjectionRec.TotLiability     := 0;

   LiabilitiesProjectionRec.MonthlyMortgage  := 0;
   LiabilitiesProjectionRec.MonthlyAuto      := 0;
   LiabilitiesProjectionRec.MonthlyOther     := 0;
//   LiabilitiesProjectionList.Add(LiabilitiesProjectionRec);
  end;

  BuildLiabilityEvents(RetNo);  //calcs mortg , auto loans and other by year

  For i:=0 to LiabilitiesProjectionList.Count-1 do
  begin
   LiabilitiesProjectionRec := LiabilitiesProjectionList[i];
   LiabilitiesProjectionRec.TotLiability:=
         LiabilitiesProjectionRec.Mortgages
        +LiabilitiesProjectionRec.Automobiles
        +LiabilitiesProjectionRec.Other;
  end;
end; {procedure}

Procedure XferToCash(RetNo:Integer;BalanceRec:TBalanceRec);
Var  EndBal:real;
     MaxWithDr:Real;
     Remaining:Real;
     PlainRemaining:Real;
     XferAmount,TotXfered:real;
     SheltStreamId,NonShStreamId,SemShStreamId:Integer;
begin
 XferAmount:=0;
 TotXfered :=0;
 MaxWithDr:=0;
 Remaining :=0;
 NonShStreamId := GetStreamId('PNONSH');
 SheltStreamId := GetStreamId('PSHELT');
 SemShStreamId := GetStreamId('PSEMSH');

 EndBal:= BalanceRec.EndBalance[NonShStreamId];
 If EndBal < RetirementParms.MinNonShBal then
   begin
     XferAmount := MaxR(0,RetirementParms.MinNonShBal - EndBal);
     Remaining := XferAmount;
     {try Semsh , withdraw from semi sh}
     MaxWithDr := MinR(Remaining,MaxR(0,BalanceRec.EndBalance[SemShStreamId]));
     BalanceRec.RegWithDr[SemShStreamId]:= BalanceRec.RegWithDr[SemShStreamId]+MaxWithDr;
     If MaxWithDr >0 then BalanceRec.Notes[SemShStreamId] :=
        BalanceRec.Notes[SemShStreamId]+',LivingExp';
     Remaining := MaxR(0,Remaining-MaxWithDr);
     TotXfered := TotXfered+MaxWithDr;
     {try sheltered ,withdraw from shelt}
     PlainRemaining:=Remaining; {before grossed -up}
     Remaining := Remaining * (1+ClientMarginalRate(RetNo)/100); {grossed up due to taxes}
     MaxWithDr := MinR(Remaining,MaxR(0,BalanceRec.EndBalance[SheltStreamId]));
     BalanceRec.RegWithDr[SheltStreamId]:= BalanceRec.RegWithDr[SheltStreamId]+MaxWithDr;
     If MaxWithDr >0 then BalanceRec.Notes[SheltStreamId] :=
        BalanceRec.Notes[SheltStreamId]+',TaxedLivingExp';
     Remaining := MaxR(0,Remaining-MaxWithDr);
     TotXfered := TotXfered+MinR(PlainRemaining,MaxR(0,BalanceRec.EndBalance[SheltStreamId]));
      {TotXfered+MaxWithDr;}
     {put contr to nonsh}
     BalanceRec.RegContr[1]:= BalanceRec.RegContr[1]+TotXfered; {contribute to NonSh}
     If TotXfered >0 then BalanceRec.Notes[1]  := BalanceRec.Notes[1]+',LivingExp';
   end;
end;


Function CalcEndBal(BegBalance,IntRate,RegContr,LumpSumContr,RegWithDr,LumpSumWithDr:Real):Real;
//contr and withdrawals assumed at end of year
begin
   Result:=   BegBalance+RegContr+LumpSumContr
              +BegBalance*IntRate/100
              -RegWithDr-LumpSumWithDr;
end;


Procedure BuildRIFStream(RetNo:Integer;OpeningBalance:Real;YearRifStarted:Integer;Rules:String;Rate:Real);
 Var i,PlanStartAge:Integer;InterestAmount,RunningBalance,RIFRate:Real;Sep:String;
begin
  RunningBalance :=0;
  GenBalanceList.Clear;
  PlanStartAge := GetPlanStartAge(RetNo);
  For i:=1 to GetPlanningPeriods(RetNo) do
  begin
   GenBalanceRec := TGenBalanceRec.Create;
   GenBalanceRec.PeriodNo      := i;
   GenBalanceRec.Year          := (RetirementParms.StartYear)+i;
   GenBalanceRec.Age           := PlanStartAge+i;
   GenBalanceRec.Notes         := '';
   GenBalanceRec.BegBalance    :=0;
   GenBalanceRec.RegContr      := 0;
   GenBalanceRec.RegWithDr     :=0;
   GenBalanceRec.LumpSumContr  := 0;
   GenBalanceRec.LumpSumWithDr := 0;
   GenBalanceRec.EndBalance := 0;

   {calc only after maturity date}
   If GenBalanceRec.Year = YearRifStarted then
      GenBalanceRec.BegBalance    := OpeningBalance
    else
      GenBalanceRec.BegBalance    := RunningBalance;

    If GenBalanceRec.Year >= YearRifStarted then
    begin
     If Rules = 'O' then
      RifRate := GetOldRifRate(GenBalanceRec.Age)
     else
      RifRate := GetNewRifRate(GenBalanceRec.Age);

     If GenBalanceRec.BegBalance>0 then
     begin
      InterestAmount := GenBalanceRec.BegBalance*(Rate)/100;
      GenBalanceRec.RegWithDr :=(GenBalanceRec.BegBalance+InterestAmount)*RIFRate/100;
     end
     else
     begin
      InterestAmount := 0;
      GenBalanceRec.RegWithDr :=0;
     end;

     GenBalanceRec.EndBalance :=
               GenBalanceRec.BegBalance
               +GenBalanceRec.RegContr
               +GenBalanceRec.LumpSumContr
               +InterestAmount
               -GenBalanceRec.RegWithDr
               -GenBalanceRec.LumpSumWithDr;
     RunningBalance := GenBalanceRec.EndBalance;
     GenBalanceRec.EndActual    := 0;
   end; {after yr started}
   GenBalanceList.Add(GenBalanceRec);
  end;

end;


Procedure BuildAllRIFs(RetNo:Integer);
 Var i,j,FNo,FrmElm,PlanStartAge,YearRIFStarted:Integer;
    TotYield,InterestAmount,OpeningBalance,RunningBalance,Rate:Real;Sep:string; //[1];

begin
 RunningBalance :=0;
 AllRifList.Clear;
 PlanStartAge := GetPlanStartAge(RetNo);
 For i:=0 to RetirementParms.NumbPeriods do
  begin
   AllRifRec := TAllRifRec.Create;
   With AllRifRec do
   begin
    PeriodNo      := i;
    Year          := (RetirementParms.StartYear)+i;
    Age           := PlanStartAge+i;
    Notes         := '';
    BegBalance    := 0;
    RegContr      := 0;
    LumpSumContr  := 0;
    LumpSumWithDr := 0;
    RegWithDr     := 0;
    EndBalance    := 0;
    EndActual    := 0;
   end;
   AllRIFList.Add(AllRifRec);
  end; {i}

  OpeningBalance :=100000;
  TotYield:=0;
  Rate:=0;
  (*  Need to be replaced
  FNo := GetFormNo('ASS_3');
  OpeningBalance :=  Vl(FetchElmFNo(RetNo,FNo,103));  {current val of all RRSP}
  TotYield := Vl(FetchElmFNo(RetNo,FNo,104)); {projected annual uield}
  If OpeningBalance >0 then Rate := (TotYield/OpeningBalance)*100 else Rate := 0;
  *)
  YearRIfStarted := ClientAgeToYear(RetNo,69); {start RIF at 69}
  BuildRIFStream(RetNo,OpeningBalance,YearRifStarted,'N',Rate);
  j:=0;
  For i:=0 to AllRifList.Count-1 do
   begin
    AllRifRec := AllRifList.items[i];
    GenBalanceRec := GenBalanceList.items[j];
    If AllRifRec.Age = GenBalanceRec.Age then
    begin
      AllRifRec.BegBalance := AllRifRec.BegBalance+GenBalanceRec.BegBalance;
      AllRifRec.RegContr      := AllRifRec.RegContr+GenBalanceRec.RegContr;
      AllRifRec.LumpSumContr  := AllRifRec.LumpSumContr+GenBalanceRec.LumpSumContr;
      AllRifRec.LumpSumWithDr := AllRifRec.LumpSumWithDr+GenBalanceRec.LumpSumWithDr;
      AllRifRec.RegWithDr     := AllRifRec.RegWithDr+GenBalanceRec.RegWithDr;
      AllRifRec.EndBalance    := AllRifRec.EndBalance+GenBalanceRec.EndBalance;
      Inc(j);
    end; {matching age}
   end; {i}

end;

Procedure PutEventInBalanceList(RetNo:Integer;Description:String;
   FromYear:String;ToYear:String;EventType:String;YearlyAmount:Real;
   NonShPercent,SemShPercent,SheltPercent,OtherPercent :Real);
//for fixed amount contributions or withdrwals
Var I,j,FNo:integer; {Sep :string; //[1];}
 TotalAmount,NonShAmount,SheltAmount,SemShAmount,OtherAmount:Real;
 Notes,NonShNotes,SheltNotes,SemShNotes,OtherNotes:string; //[20];
Begin
 For i:=0 to RetirementParms.NumbPeriods do //BalanceList.Count-1 do
 begin
  BalanceRec := TBalanceRec(BalanceList[i]);
  {Check against events}
  If YearInEventRange(IntToStr(BalanceRec.Year),FromYear,ToYear) then
  begin
        TotalAmount  := YearlyAmount;
        NonShAmount :=TotalAmount * NonShPercent /100;
        SheltAmount :=TotalAmount * SheltPercent /100;
        SemShAmount :=TotalAmount * SemShPercent /100;
        OtherAmount :=TotalAmount * OtherPercent /100;
        Notes := ','+Description;
        If NonShAmount <> 0 then NonShNotes := Notes else NonShNotes :='';
        If SheltAmount <> 0 then SheltNotes := Notes else SheltNotes :='';;
        If SemShAmount <> 0 then SemShNotes := Notes else SemShNotes :='';;
        If OtherAmount <> 0 then OtherNotes := Notes else OtherNotes :='';;

        {Lumpsum Contributions}
        If EventType = 'C' then
        begin
         StreamId:=GetStreamId('PNONSH');
         BalanceRec.LumpSumContr[StreamId] := BalanceRec.LumpSumContr[StreamId]+NonShAmount;
         If Notes>'' then
            BalanceRec.Notes[StreamId] := BalanceRec.Notes[StreamId]+NonShNotes;

         StreamId:=GetStreamId('PSHELT');
         BalanceRec.LumpSumContr[StreamId] := BalanceRec.LumpSumContr[StreamId]+SheltAmount;
         If Notes>'' then
            BalanceRec.Notes[StreamId] := BalanceRec.Notes[StreamId]+SheltNotes;

         StreamId:=GetStreamId('PSEMSH');
         BalanceRec.LumpSumContr[StreamId] := BalanceRec.LumpSumContr[StreamId]+SemShAmount;
         BalanceRec.Notes[StreamId] := BalanceRec.Notes[StreamId]+SemShNotes;

         {
         StreamId:=GetStreamId('POTHER');
         BalanceRec.LumpSumContr[StreamId] := BalanceRec.LumpSumContr[StreamId]+OtherAmount;
         BalanceRec.Notes[StreamId] := BalanceRec.Notes[StreamId]+OtherNotes;
         }
        end; {Contr}

        {Lumpsum Withdrawals}
        If EventType = 'W' then
        begin
         StreamId:=GetStreamId('PNONSH');
         BalanceRec.LumpSumWithDr[StreamId] := BalanceRec.LumpSumWithDr[StreamId]+NonShAmount;
         BalanceRec.Notes[StreamId] := BalanceRec.Notes[StreamId]+NonShNotes;

         StreamId:=GetStreamId('PSHELT');
         BalanceRec.LumpSumWithDr[StreamId] := BalanceRec.LumpSumWithDr[StreamId]+SheltAmount;
         BalanceRec.Notes[StreamId] := BalanceRec.Notes[StreamId]+SheltNotes;

         StreamId:=GetStreamId('PSEMSH');
         BalanceRec.LumpSumWithDr[StreamId] := BalanceRec.LumpSumWithDr[StreamId]+SemShAmount;
         BalanceRec.Notes[StreamId] := BalanceRec.Notes[StreamId]+SemShNotes;

         {
         StreamId:=GetStreamId('POTHER');
         BalanceRec.LumpSumWithDr[StreamId] := BalanceRec.LumpSumWithDr[StreamId]+OtherAmount;
         BalanceRec.Notes[StreamId] := BalanceRec.Notes[StreamId]+OtherNotes;
         }
        end; {withdr}
   end; //in year range
 end; //i
end;


Procedure FetchLifeEventsStreams(RetNo:Integer);
Var I,j,FNo:integer; {Sep :string; //[1];}
 NonShPercent,SheltPercent,SemShPercent,OtherPercent,
 TotalAmount,NonShAmount,SheltAmount,SemShAmount,OtherAmount:Real;
 Notes,NonShNotes,SheltNotes,SemShNotes,OtherNotes:string; //[20];
Begin
 FNo := GetFormNo('LIFEEVENTS');
 If Ret[RetNo].Frm[FNo].Count =0 then exit;
 For i:=0 to RetirementParms.NumbPeriods do //BalanceList.Count-1 do
 begin
 BalanceRec := TBalanceRec(BalanceList[i]);
  {Check against events}
  j := 4;
  Repeat
   If YearInEventRange(IntToStr(BalanceRec.Year),FetchElmFNo(RetNo,FNo,j),
     FetchElmFNo(RetNo,FNo,j+1)) then
    begin
        TotalAmount :=Vl(FetchElmFNo(RetNo,FNo,j+3));
        NonShPercent := Vl(FetchElmFNo(RetNo,FNo,j+4));
        SemShPercent := Vl(FetchElmFNo(RetNo,FNo,j+5));
        SheltPercent := Vl(FetchElmFNo(RetNo,FNo,j+6));
        OtherPercent := Vl(FetchElmFNo(RetNo,FNo,j+7));
        NonShAmount :=TotalAmount * NonShPercent /100;
        SheltAmount :=TotalAmount * SheltPercent /100;
        SemShAmount :=TotalAmount * SemShPercent /100;
        OtherAmount :=TotalAmount * OtherPercent /100;
        Notes := ','+FetchElmFNo(RetNo,FNo,j-1);
        If NonShAmount <> 0 then NonShNotes := Notes else NonShNotes :='';
        If SheltAmount <> 0 then SheltNotes := Notes else SheltNotes :='';;
        If SemShAmount <> 0 then SemShNotes := Notes else SemShNotes :='';;
        If OtherAmount <> 0 then OtherNotes := Notes else OtherNotes :='';;

        {Lumpsum Contributions}
        If UpperCase(FetchElmFNo(RetNo,FNo,j+2)) = 'C' then
        begin
         StreamId:=GetStreamId('PNONSH');
         BalanceRec.LumpSumContr[StreamId] := BalanceRec.LumpSumContr[StreamId]+NonShAmount;
         If Notes>'' then
            BalanceRec.Notes[StreamId] := BalanceRec.Notes[StreamId]+NonShNotes;

         StreamId:=GetStreamId('PSHELT');
         BalanceRec.LumpSumContr[StreamId] := BalanceRec.LumpSumContr[StreamId]+SheltAmount;
         If Notes>'' then
            BalanceRec.Notes[StreamId] := BalanceRec.Notes[StreamId]+SheltNotes;

         StreamId:=GetStreamId('PSEMSH');
         BalanceRec.LumpSumContr[StreamId] := BalanceRec.LumpSumContr[StreamId]+SemShAmount;
         BalanceRec.Notes[StreamId] := BalanceRec.Notes[StreamId]+SemShNotes;

         {
         StreamId:=GetStreamId('POTHER');
         BalanceRec.LumpSumContr[StreamId] := BalanceRec.LumpSumContr[StreamId]+OtherAmount;
         BalanceRec.Notes[StreamId] := BalanceRec.Notes[StreamId]+OtherNotes;
         }
        end; {Contr}

        {Lumpsum Withdrawals}
        If UpperCase(FetchElmFNo(RetNo,FNo,j+2)) = 'W' then
        begin
         StreamId:=GetStreamId('PNONSH');
         BalanceRec.LumpSumWithDr[StreamId] := BalanceRec.LumpSumWithDr[StreamId]+NonShAmount;
         BalanceRec.Notes[StreamId] := BalanceRec.Notes[StreamId]+NonShNotes;

         StreamId:=GetStreamId('PSHELT');
         BalanceRec.LumpSumWithDr[StreamId] := BalanceRec.LumpSumWithDr[StreamId]+SheltAmount;
         BalanceRec.Notes[StreamId] := BalanceRec.Notes[StreamId]+SheltNotes;

         StreamId:=GetStreamId('PSEMSH');
         BalanceRec.LumpSumWithDr[StreamId] := BalanceRec.LumpSumWithDr[StreamId]+SemShAmount;
         BalanceRec.Notes[StreamId] := BalanceRec.Notes[StreamId]+SemShNotes;

         {
         StreamId:=GetStreamId('POTHER');
         BalanceRec.LumpSumWithDr[StreamId] := BalanceRec.LumpSumWithDr[StreamId]+OtherAmount;
         BalanceRec.Notes[StreamId] := BalanceRec.Notes[StreamId]+OtherNotes;
         }
        end; {withdr}
   end;
   Inc(j,9);
  until j>157;
 end; {i}
end;



Function GetEventStream(RetNo:Integer;NS,SS,SH,OT:String):String;
{nonSh, Shelt,SemSh,Other}
begin
 result :='';
 If Vl(NS) > 0 then begin Result := 'PNONSH';exit;end;
 If Vl(SH) > 0 then begin Result := 'PSHELT';exit;end;
 If Vl(SS) > 0 then begin Result := 'PSEMSH';exit;end;
// If Vl(OT) > 0 then begin Result := 'POTHER';exit;end;
end;

Function YearInEventRange(Yr, FromYr,ToYr:String):Boolean;
begin
 If (Yr >= FromYr) and (Yr <= ToYr)
 then result := true
 else
 result :=false;
end;


Function CalcAgeTo(BirthDate: string;ToDate:string): Integer;
//incoming dd-mm-yyyy
Begin
 BirthDate:=AllTrim(BirthDate);
 ToDate:=AllTrim(ToDate);
 If (Length(BirthDate) <> 10) or (Length(ToDate) <> 10)
  then begin Result :=0;exit;end;
 Result := MyStrToInt(RightStr(ToDate,4)) - StrToInt(RightStr(BirthDate,4));
end;


Function GetPlanningPeriods(RetNo:Integer):Integer;
begin
 result := ClientUltimateAge(RetNo) - ClientAge(RetNo)+1;

 If (Ret[RetNo].MarStatus<3)
 and (SpouseUltimateAge(RetNo) - SpouseAge(RetNo)+1>result)
 then result:=SpouseUltimateAge(RetNo) - SpouseAge(RetNo)+1;

 If result<0 then result :=0;
end;

Function YearsOfPayout(RetNo:Integer):Integer;
Var FNo:Integer;
begin
 result := ClientRetirementYears(RetNo);
 If Vl(SpouseYearOfUltimateAge(RetNo)) > Vl(ClientYearOfUltimateAge(RetNo)) then
  result := SpouseRetirementYears(RetNo);
 If result<0 then result :=0;
end;


Procedure ProcessShortFallEvent(RetNo:Integer;ThisStream:String;AcccumList,IrregWithDrList:Tlist);
Var I,j,k:integer;
begin
 {
 i:=GetYearOfZeroBalance(RetNo,'PNONSH',BalanceList);
 j:=GetYearOfZeroBalance(RetNo,'PSEMSH',BalanceList);
 k:=GetYearOfZeroBalance(RetNo,'PSHELT',BalanceList);
 }
end;

Function GetYearOfZeroBalance(RetNo:Integer;ThisStream:String;BalanceList:Tlist):Integer;
begin
{ }
end;

Function GetMaxEndBalance(RetNo:Integer;ThisStream:String;BalanceList:TList):Real;
Var i:Integer;
begin
 result :=0;
 StreamId:=GetStreamId(ThisStream);
 For i:=0 to RetirementParms.NumbPeriods do //BalanceList.Count-1 do
 begin
  BalanceRec := BalanceList.Items[i];
  If BalanceRec.EndBalance[StreamId] > result then
     result :=BalanceRec.EndBalance[StreamId];
 end;
end;

Procedure GetMinMaxEndBalance(RetNo:Integer;ThisStream:String;Var MinBal:real;Var MaxBal:real);
Var i:Integer;
begin
 MinBal :=0;MaxBal:=0;
 StreamId:=GetStreamId(ThisStream);
 For i:=0 to RetirementParms.NumbPeriods do //BalanceList.Count-1 do
 begin
  BalanceRec := TBalanceRec(BalanceList.Items[i]);
  If BalanceRec.EndBalance[StreamId] < MinBal then
     MinBal :=BalanceRec.EndBalance[StreamId];
  If BalanceRec.EndBalance[StreamId] > MaxBal then
     MaxBal :=BalanceRec.EndBalance[StreamId];
 end;
end;

Function GetMinEndBalance(RetNo:Integer;ThisStream:String;BalanceList:TList):Real;
Var i:Integer;
begin
 result :=0;
 StreamId:=GetStreamId(ThisStream);
 For i:=0 to RetirementParms.NumbPeriods do //BalanceList.Count-1 do
 begin
  BalanceRec := BalanceList.Items[i];
  If BalanceRec.EndBalance[StreamId] < result then
     result :=BalanceRec.EndBalance[StreamId];
 end;
end;

Function GetMinGenEndBalance(RetNo:Integer;GenBalanceList:TList):Real;
Var i:Integer;
begin
 result :=0;
 For i:=0 to RetirementParms.NumbPeriods do //GenBalanceList.Count-1 do
 begin
  GenBalanceRec := GenBalanceList.Items[i];
  If GenBalanceRec.EndBalance < result then
     result :=GenBalanceRec.EndBalance;
 end;
end;

Function GetMaxGenEndBalance(RetNo:Integer;GenBalanceList:TList):Real;
Var i:Integer;
begin
 result :=0;
 For i:=0 to RetirementParms.NumbPeriods do //GenBalanceList.Count-1 do
 begin
  GenBalanceRec := GenBalanceList.Items[i];
  If GenBalanceRec.EndBalance > result then
     result :=GenBalanceRec.EndBalance;
 end;
end;

Function GetMinIncome(RetNo:Integer;CashFlProjectionList:TList):Real;
Var i:Integer;
begin
 result :=0;
 For i:=0 to RetirementParms.NumbPeriods do //CashFlProjectionList.Count-1 do
 begin
  CashFlowProjectionRec := CashFlowProjectionList.Items[i];
  If CashFlowProjectionRec.TotIncome[0]+CashFlowProjectionRec.TotIncome[1] < result then
     result :=CashFlowProjectionRec.TotIncome[0]+CashFlowProjectionRec.TotIncome[1];
 end;
end;

Function GetMaxIncome(RetNo:Integer;CashFlProjectionList:TList):Real;
Var i:Integer;
begin
 result :=0;
 For i:=0 to RetirementParms.NumbPeriods do //CashFlProjectionList.Count-1 do
 begin
  CashFlowProjectionRec := CashFlowProjectionList.Items[i];
  If CashFlowProjectionRec.TotIncome[0]+CashFlowProjectionRec.TotIncome[1] > result then
    result:=CashFlowProjectionRec.TotIncome[0]+CashFlowProjectionRec.TotIncome[1];
 end;
end;


Function GetMinLiabilityBalance(RetNo:Integer;LiabilitiesProjectionList:TList):Real;
Var i:Integer;
begin
 result :=0;
 For i:=0 to RetirementParms.NumbPeriods do //LiabilitiesProjectionList.Count-1 do
 begin
  LiabilitiesProjectionRec := LiabilitiesProjectionList.Items[i];
  If LiabilitiesProjectionRec.TotLiability < result then
     result :=LiabilitiesProjectionRec.TotLiability;
 end;
end;

Function GetMaxLiabilityBalance(RetNo:Integer;LiabilitiesProjectionList:TList):Real;
Var i:Integer;
begin
 result :=0;
 For i:=0 to RetirementParms.NumbPeriods do //LiabilitiesProjectionList.Count-1 do
 begin
  LiabilitiesProjectionRec := LiabilitiesProjectionList.Items[i];
  If LiabilitiesProjectionRec.TotLiability > result then
     result :=LiabilitiesProjectionRec.TotLiability;
 end;
end;


Function GetMinNetWorthBalance(RetNo:Integer;NetWorthProjectionList:TList):Real;
Var i:Integer;
begin
 result :=0;
 For i:=0 to RetirementParms.NumbPeriods do //NetWorthProjectionList.Count-1 do
 begin
  NetWorthProjectionRec := NetWorthProjectionList.Items[i];
  If NetWorthProjectionRec.NetWorth < result then
     result :=NetWorthProjectionRec.NetWorth;
 end;
end;

Function GetMaxNetWorthBalance(RetNo:Integer;NetWorthProjectionList:TList):Real;
Var i:Integer;
begin
 result :=0;
 For i:=0 to RetirementParms.NumbPeriods do //NetWorthProjectionList.Count-1 do
 begin
  NetWorthProjectionRec := NetWorthProjectionList.Items[i];
  If NetWorthProjectionRec.NetWorth > result then
     result :=NetWorthProjectionRec.NetWorth;
 end;
end;

Function GetMinCashFlBalance(RetNo:Integer;CashFlProjectionList:TList):Real;
Var i:Integer;
begin
 result :=0;
 For i:=0 to RetirementParms.NumbPeriods do //CashFlProjectionList.Count-1 do
 begin
  CashFlowProjectionRec := CashFlowProjectionList.Items[i];
  If CashFlowProjectionRec.DispInc < result then
     result :=CashFlowProjectionRec.DispInc;
 end;
end;

Function GetMaxCashFlBalance(RetNo:Integer;CashFlProjectionList:TList):Real;
Var i:Integer;
begin
 result :=0;
 For i:=0 to RetirementParms.NumbPeriods do //CashFlProjectionList.Count-1 do
 begin
  CashFlowProjectionRec := CashFlowProjectionList.Items[i];
  If CashFlowProjectionRec.DispInc > result then
     result :=CashFlowProjectionRec.DispInc;
 end;
end;


Function GetMaxTotBalanceEndBalance(RetNo:Integer;TotBalanceList:TList):Real;
Var i:Integer;
begin
 result :=0;
 For i:=0 to RetirementParms.NumbPeriods do
 //For i:=0 to TotBalanceList.Count-1 do
 begin
  TotInvestmProjectionRec := TotInvestmProjectionList.Items[i];
  If TotInvestmProjectionRec.TotEndBalance > result then
    result :=TotInvestmProjectionRec.TotEndBalance;
 end;
end;


Function GetMinFVEndBalance(RetNo:Integer;GenBalanceList:TList):Real;
Var i:Integer;
begin
 result :=0;
 For i:=0 to RetirementParms.NumbPeriods do //GenBalanceList.Count-1 do
 begin
  FutValRec := GenBalanceList.Items[i];
  If FutValRec.EndBalance < result then
     result :=FutValRec.EndBalance;
 end;
end;

Function GetMaxFvEndBalance(RetNo:Integer;GenBalanceList:TList):Real;
Var i:Integer;
begin
 result :=0;
 For i:=0 to RetirementParms.NumbPeriods do //GenBalanceList.Count-1 do
 begin
  FutValRec := GenBalanceList.Items[i];
  If FutValRec.EndBalance > result then
     result :=FutValRec.EndBalance;
 end;
end;

Function GetMinTotBalanceEndBalance(RetNo:Integer;TotBalanceList:TList):Real;
Var i:Integer;
begin
 result :=0;
// For i:=0 to TotBalanceList.Count-1 do
 For i:=0 to RetirementParms.NumbPeriods do
 begin
  TotInvestmProjectionRec := TotInvestmProjectionList.Items[i];
  If TotInvestmProjectionRec.TotEndBalance < result then result :=TotInvestmProjectionRec.TotEndBalance;
 end;
end;

Function GetStartInvestmYear(RetNo:Integer):Integer;
begin
 result := StrToInt(GetCurYear);
end;


procedure GetRetirementParms(RetNo:Integer);
Var StreamId:Integer; FNo:Integer;
begin
  FNo := GetFormNo('RETPLAN');
  RetirementParms.NumbPeriods := GetPlanningPeriods(RetNo);
  RetirementParms.StartYear   := GetStartInvestmYear(RetNo);
  RetirementParms.IncShortFall:= GetIncShortFall(RetNo); {Vl(FetchElmFNo(RetNo,FNo,52));}
  RetirementParms.MinNonShBal :=0; {2000?}
  StreamId:=GetStreamId('PSHELT');
  RetirementParms.OpeningBalance[StreamId] := Vl(FetchElmFNo(RetNo,FNo,15));
  RetirementParms.IntRate[StreamId]        := AllTrim(FetchElmFNo(RetNo,FNo,46));
  If Vl(RetirementParms.IntRate[StreamId]) =0 then
     RetirementParms.IntRate[StreamId] :=
      FetchElm(RetNo,'ASSUME',16); //DefaultSheltInterest;

   RetirementParms.RegContr[StreamId]       := Vl(FetchElmFNo(RetNo,FNo,41));
   RetirementParms.RegWithDr[StreamId]      := Vl(FetchElmFNo(RetNo,FNo,69));   //20121020 ??? What is this??
   RetirementParms.ContrBegOrEnd[StreamId]  :='E';
   RetirementParms.WithDrBegOrEnd[StreamId] :='E';

   StreamId:=GetStreamId('PNONSH');
   RetirementParms.OpeningBalance[StreamId] := Vl(FetchElmFNo(RetNo,FNo,14));
   RetirementParms.IntRate[StreamId]        := AllTrim(FetchElmFNo(RetNo,FNo,55)); {bfr tax}
   If Vl(RetirementParms.IntRate[StreamId]) =0 then
     RetirementParms.IntRate[StreamId] :=
       FetchElm(RetNo,'ASSUME',15); //DefaultNonShInterest;
   RetirementParms.RegContr[StreamId]       := Vl(FetchElmFNo(RetNo,FNo,3));
   RetirementParms.RegWithDr[StreamId]      := Vl(FetchElmFNo(RetNo,FNo,68));  //20121020 ??? What is this??
   RetirementParms.ContrBegOrEnd[StreamId]  :='E';
   RetirementParms.WithDrBegOrEnd[StreamId] :='E';


   StreamId:=GetStreamId('PSEMSH');
   RetirementParms.OpeningBalance[StreamId] := Vl(FetchElmFNo(RetNo,FNo,17));
   RetirementParms.IntRate[StreamId]        := AllTrim(FetchElmFNo(RetNo,FNo,57));
   If Vl(RetirementParms.IntRate[StreamId]) =0 then
     RetirementParms.IntRate[StreamId] :=
       FetchElm(RetNo,'ASSUME',17); //DefaultSemShInterest;
   RetirementParms.RegContr[StreamId]       := Vl(FetchElmFNo(RetNo,FNo,43));
   RetirementParms.RegWithDr[StreamId]      := Vl(FetchElmFNo(RetNo,FNo,70)); //20121020 ??? What is this??
   RetirementParms.ContrBegOrEnd[StreamId]  :='E';
   RetirementParms.WithDrBegOrEnd[StreamId]:='E';

   {
   StreamId:=GetStreamId('POTHER');
   RetirementParms.OpeningBalance[StreamId] := Vl(FetchElmFNo(RetNo,FNo,16));
   RetirementParms.IntRate[StreamId]        := AllTrim(FetchElmFNo(RetNo,FNo,58));
   If Vl(RetirementParms.IntRate[StreamId]) =0 then
     RetirementParms.IntRate[StreamId] :=
       FetchElm(RetNo,'ASSUME',18); //DefaultOtherInterest;
   RetirementParms.RegContr[StreamId]       := Vl(FetchElmFNo(RetNo,FNo,42));
   RetirementParms.RegWithDr[StreamId]      := Vl(FetchElmFNo(RetNo,FNo,71));
   RetirementParms.ContrBegOrEnd[StreamId]  :='E';
   RetirementParms.WithDrBegOrEnd[StreamId]:='E';
   }
 end;


Function GetActualBalance(RetNo:Integer):Real;
begin
 Result := 0;
end;

Function GetMaxAccumPageNo(RetNo:Integer):Integer;
begin
 result := Trunc(GetPlanningPeriods(RetNo)/25)+1;
end;

Function GetEventAmount(RetNo:Integer;ThisStream:String;TotalAmount:Real;NonShPercent,
         SemShPercent,SheltPercent,OtherPercent:Real):Real;
begin
 result :=0;
 If ThisStream = 'PNONSH' then begin result := TotalAmount * NonShPercent /100;exit;end;
 If ThisStream = 'PSEMSH' then begin result := TotalAmount * SemShPercent /100;exit;end;
 If ThisStream = 'PSHELT' then begin result := TotalAmount * SheltPercent /100;exit;end;
// If ThisStream = 'POTHER' then begin result := TotalAmount * OtherPercent /100;exit;end;
end;


Function GetStreamId(ThisStream:String):Integer;
begin
 result :=0;
 If ThisStream = 'PNONSH' then begin result :=1;exit;end;
 If ThisStream = 'PSHELT' then begin result :=2;exit;end;
 If ThisStream = 'PSEMSH' then begin result :=3;exit;end;
 If ThisStream = 'POTHER' then begin result :=4;exit;end; //20090524
end;

Function GetStreamName(StreamId:Integer):String;
begin
 result :='';
 If StreamId=1 then result := 'Non-Sheltered'
 else If StreamId=2 then result :='Sheltered'
 else If StreamId=3 then result :='Semi-sheltered'
 else If StreamId=4 then result := 'Other';
end;

procedure DrawFormList(RetNo: integer; Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
	{Bitmap: TBitmap;}      { temporary variable for the item’s bitmap }
	Offset: Integer;      { text offset width }
        ShowStr : string; //[60];
        FName :String;FNo:Integer;
begin
(* For ownerdraw listbox
*)
    with (Control as TListBox).Canvas do  { draw on control canvas, not on the form }
    begin
        FillRect(Rect);       { clear the rectangle }
	Offset := 2;          { provide default offset }
	{Bitmap := TBitmap((Control as TListBox).Items.Objects[Index]);}  { get the bitmap}

        (*
        if Bitmap <> nil then
	begin
		BrushCopy(Bounds(Rect.Left + 2, Rect.Top, Bitmap.Width, Bitmap.Height),
			Bitmap, Bounds(0, 0, Bitmap.Width, Bitmap.Height), clRed);  {render bitmap}
		Offset := Bitmap.width + 6;    { add four pixels between bitmap and text}
	end;
        *)
        FName := FrmTreeForms[Index];
        FNo := GetFormNo(FName);

         {treat headers}
        If LeftStr((Control as TListBox).Items[Index],1) = '$' then
        begin
         ShowStr := MidStr((Control as TListBox).Items[Index],2,60);
         Font.color := clBlack; //clRed;
         Brush.Color := (Control as TListBox).Color; {clRed;}
         Font.Size :=10;
         Font.Style := [fsBold];
        end
        else
        begin
        ShowStr :=LeftStr((Control as TListBox).Items[Index],60);
        If (RetNo>0) and (FNo>0) then
         begin
            If Ret[RetNo].FrmHasData[FNo] then
            begin
            ShowStr :=LeftStr((Control as TListBox).Items[Index],60);
            Font.color := clBlue;
            end;
         end
        else
          begin
            //ShowStr :=LeftStr((Control as TListBox).Items[Index],60);  //??
            Font.color := clBlack;
          end;
        Font.Size :=10;
        Font.Style := []; {[fsBold];}
        Brush.Color := (Control as TListBox).Color;
        end;

        TextOut(Rect.Left + Offset, Rect.Top, ShowStr);
        {TextOut(Rect.Left + Offset, Rect.Top, (Control as TListBox).Items[Index])}
   End;

end;

Procedure GetEventList(RetNo:Integer;Yr:Integer;EventList:TStrings);
Var j,FNo:Integer;
begin
  FNo := GetFormNo('PEVENTS');
  j :=4;
  Repeat
   If YearInEventRange(IntToStr(Yr),FetchElmFNo(RetNo,FNo,j),
        FetchElmFNo(RetNo,FNo,j+1)) then
    EventList.Add(FetchElmFNo(RetNo,FNo,j-1));
   Inc(j,11);
  until j>213;
end;

procedure ChartStream(RetNo:Integer;ThisStream:String;TempCanvas:TBitMap;R:TRect;YearOrAge:Boolean);
Var
  Tot: Real;
  Chart1: TChart;
  R1: TRect;
  I: Integer;
  ThisSeries: TBarSeries;
  MinBal, MaxBal: Real;
  F: TForm; //20160411 Igor
begin
  { Get data }
  StreamId := GetStreamId(ThisStream);
  { create chart }
    //20160411 Igor >>>
  F := TForm.Create(nil);
  F.Visible := False;
  Chart1 := TChart.Create(F);
  Chart1.Parent := F;
  //20160411 Igor <<<
  With Chart1 do
  begin
    Title.Font.color := clBlack;
    Title.Font.Size := 8;
    Title.Font.Style := [fsBold];
    Title.Text.clear;
    Title.Text.Add(GetAccumChartTitle(ThisStream,
      RetirementParms.IntRate[StreamId]));

    GetMinMaxEndBalance(RetNo, ThisStream, MinBal, MaxBal);
    LeftAxis.Automatic := False;
    LeftAxis.Minimum := GetMinEndBalance(RetNo, ThisStream, BalanceList);
    LeftAxis.Minimum := { 1.10 * } LeftAxis.Minimum;
    LeftAxis.Maximum := GetMaxEndBalance(RetNo, ThisStream, BalanceList);
    LeftAxis.Maximum := { 1.10 * } LeftAxis.Maximum;
    Legend.Visible := False;
    AxisVisible := True;

    Gradient.Visible := True;
    Gradient.StartColor := clWhite;
    Gradient.EndColor := Rgb(128, 255, 255);;
    // GetRetColor(RetNo); //Rgb(128,255,255); //clAqua;
  end;
  { add series }
  ThisSeries := TBarSeries.Create(Chart1);
  TeeEraseBack := False;
  Chart1.Addseries(ThisSeries);
  With ThisSeries do
  Begin
    Marks.Visible := False; { no yellow boxes on top of Bar }
    BarStyle := bsRectGradient; { Rectangle; }
    BarBrush.color := clRed;
  end;

  With ThisSeries do
  Begin
    clear;
    { apply data }
    If BalanceList.Count < 1 then
      exit;
    I := 0;
    Repeat
      BalanceRec := TBalanceRec(BalanceList.Items[I]);
      If YearOrAge = True then
        Add(Round(BalanceRec.EndBalance[StreamId]), IntToStr(BalanceRec.Year),
          clTeeColor)
      else
        Add(Round(BalanceRec.EndBalance[StreamId]), IntToStr(BalanceRec.Age[0]),
          clTeeColor);
      inc(I, 1); { every  1,2 or 3years }
    until I > RetirementParms.NumbPeriods; // i>BalanceList.Count-1;
  end;

  Chart1.Draw(TempCanvas.Canvas, R);

  // via BMP file {Option}
  // Chart1.Parent:=MainForm;
  // Chart1.SaveToBitMapFile(AppDir+'\'+'TempBmp.bmp');

  ThisSeries.free;
  Chart1.free;
  F.free; //20160411 Igor
end;


procedure ChartTotBalance(RetNo: Integer; TempCanvas: TBitMap; R: TRect;
  YearOrAge: Boolean);
Var
  Tot: Real;
  Chart1: TChart;
  R1: TRect;
  I: Integer;
  PTotBalSeries, PSheltSeries, PNonShSeries, PSemShSeries: TBarSeries;
  { TFastLineSeries; } { TBarSeries; }
  ThisStream: string; // [10];
  t1, t2, t: LongInt;
  F: TForm;
begin
  BuildAssetsProjection(RetNo);
  If TotInvestmProjectionList.Count < 1 then
  begin { TotBalanceList.Free; }
    exit;
  end;

  { create chart }
  //20160411 Igor >>>
  F := TForm.Create(nil);
  F.Visible := False;
  Chart1 := TChart.Create(F);
  Chart1.Parent := F;
  //20160411 Igor <<<
  With Chart1 do
  begin
    Title.Font.color := clBlack;
    Title.Font.Size := 12;
    Title.Font.Style := [fsBold];
    Title.Text.clear;
    Title.Text.Add('All Investments');

    LeftAxis.Automatic := False;
    LeftAxis.Minimum := GetMinTotBalanceEndBalance(RetNo,
      TotInvestmProjectionList);
    LeftAxis.Minimum := 1.10 * LeftAxis.Minimum;
    LeftAxis.Maximum := GetMaxTotBalanceEndBalance(RetNo,
      TotInvestmProjectionList);
    LeftAxis.Maximum := 1.10 * LeftAxis.Maximum;
    Legend.Visible := False;
    AxisVisible := True;
    Gradient.Visible := True;
    Gradient.StartColor := clWhite;
    Gradient.EndColor := Rgb(128, 255, 255);;
    // GetRetColor(RetNo); //Rgb(128,255,255); //clAqua;
    {
      Gradient.StartColor := $008080FF;
      Gradient.EndColor := clAqua;
    }
  end;

  TeeEraseBack := False;
  PTotBalSeries := TBarSeries.Create(Chart1);
  PTotBalSeries.ParentChart := Chart1;
  With PTotBalSeries do
  Begin
    Marks.Visible := False; { no yellow boxes on top of Bar }
    BarStyle := bsRectGradient; { Rectangle; }
    BarBrush.color := clRed;
  end;
  With PTotBalSeries do
  Begin
    Marks.Visible := False; { no yellow boxes on top of Bar }
    clear;
    I := 0;
    Repeat
      TotInvestmProjectionRec := TotInvestmProjectionList.Items[I];
      If YearOrAge = True then
        Add(Round(TotInvestmProjectionRec.TotEndBalance),
          IntToStr(TotInvestmProjectionRec.Year), clTeeColor)
      else
        Add(Round(TotInvestmProjectionRec.TotEndBalance),
          IntToStr(TotInvestmProjectionRec.Age), clTeeColor);
      inc(I, 1); { every  1,2 or 3years }
    until I > RetirementParms.NumbPeriods; // TotInvestmProjectionList.Count-1;
  end;
  Chart1.Draw(TempCanvas.Canvas, R);
  PTotBalSeries.free;
  Chart1.free;
  F.Free; //20160411 Igor
end;

procedure ChartLiabilities(RetNo: Integer; TempCanvas: TBitMap; R: TRect;
  YearOrAge: Boolean; ProjectionList: TList);
Var
  Tot: Real;
  Chart1: TChart;
  R1: TRect;
  I: Integer;
  Series1: TBarSeries; { TFastLineSeries; } { TBarSeries; }
  t1, t2, t: LongInt;
  F: TForm; //20160411 Igor
begin
  If ProjectionList.Count < 1 then
  begin
    exit;
  end;
  { create chart }
  //20160411 Igor >>>
  F := TForm.Create(nil);
  F.Visible := False;
  Chart1 := TChart.Create(F);
  Chart1.Parent := F;
  //20160411 Igor <<<
  With Chart1 do
  begin
    Title.Font.color := clBlack;
    Title.Font.Size := 12;
    Title.Font.Style := [fsBold];
    Title.Text.clear;
    Title.Text.Add('Liabilities');

    LeftAxis.Automatic := False;
    LeftAxis.Minimum := GetMinLiabilityBalance(RetNo, ProjectionList);
    LeftAxis.Minimum := 1.10 * LeftAxis.Minimum;
    LeftAxis.Maximum := GetMaxLiabilityBalance(RetNo, ProjectionList);
    LeftAxis.Maximum := 1.10 * LeftAxis.Maximum;
    Legend.Visible := False;
    AxisVisible := True;
    Gradient.Visible := True;
    Gradient.StartColor := clWhite;
    Gradient.EndColor := Rgb(128, 255, 255);;
    // GetRetColor(RetNo); //Rgb(128,255,255); //clAqua;
  end;

  TeeEraseBack := False;
  Series1 := TBarSeries.Create(Chart1);
  Series1.ParentChart := Chart1;
  With Series1 do
  Begin
    Marks.Visible := False; { no yellow boxes on top of Bar }
    BarStyle := bsRectGradient; { Rectangle; }
    BarBrush.color := clRed;
  end;
  With Series1 do
  Begin
    Marks.Visible := False; { no yellow boxes on top of Bar }
    clear;
    I := 0;
    Repeat
      LiabilitiesProjectionRec := ProjectionList.Items[I];
      If YearOrAge = True then
        Add(Round(LiabilitiesProjectionRec.TotLiability),
          IntToStr(LiabilitiesProjectionRec.Year), clTeeColor)
      else
        Add(Round(LiabilitiesProjectionRec.TotLiability),
          IntToStr(LiabilitiesProjectionRec.Age), clTeeColor);
      inc(I, 1); { every  1,2 or 3years }
    until I > RetirementParms.NumbPeriods; // ProjectionList.Count-1;
  end;
  Chart1.Draw(TempCanvas.Canvas, R);
  Series1.free;
  Chart1.free;
  F.Free;
end;


Function GetMinBusiness(RetNo:Integer;BusinessProjectionList:TList):Real;
Var i:Integer;
begin
 result :=0;
 For i:=0 to RetirementParms.NumbPeriods  do//BusinessProjectionList.Count-1 do
 begin
  BusinesssProjectionRec := BusinessProjectionList.Items[i];
  If BusinesssProjectionRec.Total < result then
     result :=BusinesssProjectionRec.Total;
 end;
end;

Function GetMaxBusiness(RetNo:Integer;BusinessProjectionList:TList):Real;
Var i:Integer;
begin
 result :=0;
 For i:=0 to RetirementParms.NumbPeriods do //BusinessProjectionList.Count-1 do
 begin
  BusinesssProjectionRec := BusinessProjectionList.Items[i];
  If BusinesssProjectionRec.Total > result then
     result :=BusinesssProjectionRec.Total;
 end;
end;


Function GetMinFixedAssetsBalance(RetNo:Integer;FixedAssetsProjectionList:TList):Real;
Var i:Integer;
begin
 result :=0;
 For i:=0 to RetirementParms.NumbPeriods do //FixedAssetsProjectionList.Count-1 do
 begin
  FixedAssetsProjectionRec := FixedAssetsProjectionList.Items[i];
  If FixedAssetsProjectionRec.Total < result then
     result :=FixedAssetsProjectionRec.Total;
 end;
end;

Function GetMaxFixedAssetsBalance(RetNo:Integer;FixedAssetsProjectionList:TList):Real;
Var i:Integer;
begin
 result :=0;
 For i:=0 to RetirementParms.NumbPeriods do //FixedAssetsProjectionList.Count-1 do
 begin
  FixedAssetsProjectionRec := FixedAssetsProjectionList.Items[i];
  If FixedAssetsProjectionRec.Total > result then
     result :=FixedAssetsProjectionRec.Total;
 end;
end;

procedure ChartFixedAssets(RetNo:Integer;TempCanvas:TBitMap;R:TRect;YearOrAge:Boolean;ProjectionList:TList);
Var
  Tot:Real;
  Chart1 : TChart;
  R1:TRect;
  i:Integer;
  Series1 :TBarSeries;{TFastLineSeries;} {TBarSeries;}
  t1,t2,t:Longint;
  F: TForm; //20160411 Igor
begin
  If ProjectionList.Count <1 then begin exit;end;
  {create chart}
  //20160411 Igor >>>
  F := TForm.Create(nil);
  F.Visible := False;
  Chart1 := TChart.Create(F);
  Chart1.Parent := F;
  //20160411 Igor <<<
  With Chart1 do
  begin
    Title.Font.Color := clBlack;
    Title.Font.Size := 12;
    Title.Font.Style := [fsBold];
    Title.Text.Clear;
    Title.Text.Add('Fixed and Other Assets');

    LeftAxis.Automatic := False;
    LeftAxis.Minimum := GetMinFixedAssetsBalance(RetNo,ProjectionList);
    LeftAxis.Minimum := 1.10 * LeftAxis.Minimum;
    LeftAxis.Maximum := GetMaxFixedAssetsBalance(RetNo,ProjectionList);
    LeftAxis.Maximum := 1.10 * LeftAxis.Maximum;
    Legend.Visible := False;
    AxisVisible := True;
    Gradient.Visible :=True;
    Gradient.StartColor := clWhite;
    Gradient.EndColor := Rgb(128,255,255);; //GetRetColor(RetNo); //Rgb(128,255,255); //clAqua;
  end;

  TeeEraseBack:=False;
  Series1 := TBarSeries.Create(Chart1);
  Series1.ParentChart := Chart1;
  With Series1 do
  Begin
    Marks.Visible := False; {no yellow boxes on top of Bar}
    BarStyle := bsRectGradient; {Rectangle;}
    BarBrush.Color := clRed;
  end;
  With Series1 do
  Begin
    Marks.Visible := False; {no yellow boxes on top of Bar}
    Clear;
    i:=0; //i:=0;
    Repeat
      FixedAssetsProjectionRec := FixedAssetsProjectionList.Items[i];
      If YearOrAge = True then
        Add(Round(FixedAssetsProjectionRec.Total),IntToStr(FixedAssetsProjectionRec.Year),clTeeColor)
      else
        Add(Round(FixedAssetsProjectionRec.Total),IntToStr(FixedAssetsProjectionRec.Age),clTeeColor);
      Inc(i,1); {every  1,2 or 3years}
    until i>RetirementParms.NumbPeriods; //ProjectionList.Count-1;
  end;
  Chart1.Draw(TempCanvas.Canvas,R);

  Series1.Free;
  Chart1.Free;
  F.Free;//20160411 Igor
end;


procedure ChartBusiness(RetNo:Integer;TempCanvas:TBitMap;R:TRect;YearOrAge:Boolean;ProjectionList:TList);
Var
  Tot: Real;
  Chart1: TChart;
  R1: TRect;
  i: Integer;
  Series1: TBarSeries;{TFastLineSeries;} {TBarSeries;}
  t1, t2, t: Longint;
  F: TForm; //20160411 Igor
begin
  If ProjectionList.Count <1 then begin exit;end;
  {create chart}
  //20160411 Igor >>>
  F := TForm.Create(nil);
  F.Visible := False;
  Chart1 := TChart.Create(F);
  Chart1.Parent := F;
  //20160411 Igor <<<
  With Chart1 do
  begin
    Title.Font.Color := clBlack;
    Title.Font.Size := 12;
    Title.Font.Style := [fsBold];
    Title.Text.Clear;
    Title.Text.Add('Business Interests');

    LeftAxis.Automatic := False;
    LeftAxis.Minimum := GetMinBusiness(RetNo,ProjectionList);
    LeftAxis.Minimum := 1.10 * LeftAxis.Minimum;
    LeftAxis.Maximum := GetMaxBusiness(RetNo,ProjectionList);
    LeftAxis.Maximum := 1.10 * LeftAxis.Maximum;
    Legend.Visible := False;
    AxisVisible := True;
    Gradient.Visible :=True;
    Gradient.StartColor := clWhite;
    Gradient.EndColor := Rgb(128,255,255);; //GetRetColor(RetNo); //Rgb(128,255,255); //clAqua;
  end;

  TeeEraseBack:=False;
  Series1 := TBarSeries.Create(Chart1);
  Series1.ParentChart := Chart1;
  With Series1 do
  Begin
    Marks.Visible := False; {no yellow boxes on top of Bar}
    BarStyle := bsRectGradient; {Rectangle;}
    BarBrush.Color := clRed;
  end;
  With Series1 do
  Begin
    Marks.Visible := False; {no yellow boxes on top of Bar}
    Clear;
    i:=0;
    Repeat
      BusinesssProjectionRec := TBusinessProjectionRec(BusinessProjectionList.Items[i]);
      If YearOrAge = True then
        Add(Round(BusinesssProjectionRec.Total),IntToStr(BusinesssProjectionRec.Year),clTeeColor)
      else
        Add(Round(BusinesssProjectionRec.Total),IntToStr(BusinesssProjectionRec.Age),clTeeColor);
      Inc(i,1); {every  1,2 or 3years}
    until i>RetirementParms.NumbPeriods; //ProjectionList.Count-1;
  end;
  Chart1.Draw(TempCanvas.Canvas,R);
  Series1.Free;
  Chart1.Free;
  F.Free; //20160411 Igor
end;



procedure ChartNetWorth(RetNo:Integer;TempCanvas:TBitMap;R:TRect;YearOrAge:Boolean;NetWorthProjectionList:TList);
Var
  Tot: Real;
  Chart1: TChart;
  R1: TRect;
  i: Integer;
  Series1: TBarSeries;{TFastLineSeries;} {TBarSeries;}
  t1, t2, t: Longint;
  F: TForm; //20160411 Igor
begin
  If NetWorthProjectionList.Count <1 then begin exit;end;
  {create chart}
  //20160411 Igor >>>
  F := TForm.Create(nil);
  F.Visible := False;
  Chart1 := TChart.Create(F);
  Chart1.Parent := F;
  //20160411 Igor <<<
  With Chart1 do
  begin
    Title.Font.Color := clBlack;
    Title.Font.Size := 12;
    Title.Font.Style := [fsBold];
    Title.Text.Clear;
    Title.Text.Add('Net Worth');

    LeftAxis.Automatic := False;
    LeftAxis.Minimum := GetMinNetWorthBalance(RetNo,NetWorthProjectionList);
    LeftAxis.Minimum := 1.10 * LeftAxis.Minimum;
    LeftAxis.Maximum := GetMaxNetWorthBalance(RetNo,NetWorthProjectionList);
    LeftAxis.Maximum := 1.10 * LeftAxis.Maximum;
    Legend.Visible := False;
    AxisVisible := True;
    Gradient.Visible :=True;
    Gradient.StartColor := clWhite;
    Gradient.EndColor := Rgb(128,255,255);; //GetRetColor(RetNo); //Rgb(128,255,255); //clAqua;
  end;

  TeeEraseBack:=False;
  Series1 := TBarSeries.Create(Chart1);
  Series1.ParentChart := Chart1;
  With Series1 do
  Begin
    Marks.Visible := False; {no yellow boxes on top of Bar}
    BarStyle := bsRectGradient; {Rectangle;}
    BarBrush.Color := clRed;
  end;
  With Series1 do
  Begin
    Marks.Visible := False; {no yellow boxes on top of Bar}
    Clear;
    i:=0;
    Repeat
      NetWorthProjectionRec := NetWorthProjectionList.Items[i];
      If YearOrAge = True then
        Add(Round(NetWorthProjectionRec.NetWorth),IntToStr(NetWorthProjectionRec.Year),clTeeColor)
      else
       Add(Round(NetWorthProjectionRec.NetWorth),IntToStr(NetWorthProjectionRec.Age),clTeeColor);
      Inc(i,1); {every  1,2 or 3years}
    until i>RetirementParms.NumbPeriods; //ProjectionList.Count-1;
  end;
  Chart1.Draw(TempCanvas.Canvas,R);
  Series1.Free;
  Chart1.Free;
  F.Free; //20160411 Igor
end;

procedure ChartCashFl(RetNo:Integer;TempCanvas:TBitMap;R:TRect;YearOrAge:Boolean;ProjectionList:TList);
Var
  Tot: Real;
  Chart1: TChart;
  R1: TRect;
  i:Integer;
  Series1: TBarSeries;{TFastLineSeries;} {TBarSeries;}
  t1, t2, t: Longint;
  F: TForm; //20160411 Igor
begin
  If ProjectionList.Count <1 then begin exit;end;
  {create chart}
  //20160411 Igor >>>
  F := TForm.Create(nil);
  F.Visible := False;
  Chart1 := TChart.Create(F);
  Chart1.Parent := F;
  //20160411 Igor <<<
  With Chart1 do
  begin
    Title.Font.color := clBlack;
    Title.Font.Size := 12;
    Title.Font.Style := [fsBold];
    Title.Text.clear;
    Title.Text.Add('Cash Flow - Disposable Income');

    LeftAxis.Automatic := False;
    LeftAxis.Minimum := GetMinCashFlBalance(RetNo, ProjectionList);
    LeftAxis.Minimum := 1.10 * LeftAxis.Minimum;
    LeftAxis.Maximum := GetMaxCashFlBalance(RetNo, ProjectionList);
    LeftAxis.Maximum := 1.10 * LeftAxis.Maximum;
    Legend.Visible := False;
    AxisVisible := True;
    Gradient.Visible := True;
    Gradient.StartColor := clWhite;
    Gradient.EndColor := Rgb(128, 255, 255);;
    // GetRetColor(RetNo); //Rgb(128,255,255); //clAqua;
  end;

  TeeEraseBack := False;
  Series1 := TBarSeries.Create(Chart1);
  Series1.ParentChart := Chart1;
  With Series1 do
  Begin
    Marks.Visible := False; { no yellow boxes on top of Bar }
    BarStyle := bsRectGradient; { Rectangle; }
    BarBrush.color := clRed;
  end;
  With Series1 do
  Begin
    Marks.Visible := False; { no yellow boxes on top of Bar }
    clear;
    I := 0;
    Repeat
      CashFlowProjectionRec := ProjectionList.Items[I];
      If YearOrAge = True then
        Add(Round(CashFlowProjectionRec.DispInc),
          IntToStr(CashFlowProjectionRec.Year), clTeeColor)
      else
        Add(Round(CashFlowProjectionRec.DispInc),
          IntToStr(CashFlowProjectionRec.Age), clTeeColor);
      inc(I, 1); { every  1,2 or 3years }
    until I > RetirementParms.NumbPeriods; // ProjectionList.Count-1;
  end;
  Chart1.Draw(TempCanvas.Canvas, R);
  Series1.free;
  Chart1.free;
  F.Free;
end;


procedure ChartIncome(RetNo: Integer; TempCanvas: TBitMap; R: TRect;
  YearOrAge: Boolean; ProjectionList: TList);
Var
  Tot: Real;
  Chart1: TChart;
  R1: TRect;
  I: Integer;
  Series1: TBarSeries; { TFastLineSeries; } { TBarSeries; }
  t1, t2, t: LongInt;
  F: TForm; //20160411 Igor
begin
  If ProjectionList.Count < 1 then
  begin
    exit;
  end;
  { create chart }
  //20160411 Igor >>>
  F := TForm.Create(nil);
  F.Visible := False;
  Chart1 := TChart.Create(F);
  Chart1.Parent := F;
  //20160411 Igor <<<
  With Chart1 do
  begin
    Title.Font.color := clBlack;
    Title.Font.Size := 12;
    Title.Font.Style := [fsBold];
    Title.Text.clear;
    Title.Text.Add('Income projection');

    LeftAxis.Automatic := False;
    LeftAxis.Minimum := GetMinIncome(RetNo, ProjectionList);
    LeftAxis.Minimum := 1.10 * LeftAxis.Minimum;
    LeftAxis.Maximum := GetMaxIncome(RetNo, ProjectionList);
    LeftAxis.Maximum := 1.10 * LeftAxis.Maximum;
    Legend.Visible := False;
    AxisVisible := True;
    Gradient.Visible := True;
    Gradient.StartColor := clWhite;
    Gradient.EndColor := Rgb(128, 255, 255);;
    // GetRetColor(RetNo); //Rgb(128,255,255); //clAqua;
  end;

  TeeEraseBack := False;
  Series1 := TBarSeries.Create(Chart1);
  Series1.ParentChart := Chart1;
  With Series1 do
  Begin
    Marks.Visible := False; { no yellow boxes on top of Bar }
    BarStyle := bsRectGradient; { Rectangle; }
    BarBrush.color := clRed;
  end;
  With Series1 do
  Begin
    Marks.Visible := False; { no yellow boxes on top of Bar }
    clear;
    I := 0;
    Repeat
      CashFlowProjectionRec := ProjectionList.Items[I];
      If YearOrAge = True then
        Add(Round(CashFlowProjectionRec.TotIncome[0] +
          CashFlowProjectionRec.TotIncome[1]),
          IntToStr(CashFlowProjectionRec.Year), clTeeColor)
      else
        Add(Round(CashFlowProjectionRec.TotIncome[0] +
          CashFlowProjectionRec.TotIncome[1]),
          IntToStr(CashFlowProjectionRec.Age), clTeeColor);
      inc(I, 1); { every  1,2 or 3years }
    until I > RetirementParms.NumbPeriods; // ProjectionList.Count-1;
  end;
  Chart1.Draw(TempCanvas.Canvas, R);
  Series1.free;
  Chart1.free;
  F.Free; //20160411 Igor
end;



Procedure ChartRIF(RetNo: Integer; TempCanvas: TBitMap; R: TRect;
  YearOrAge: Boolean);
Var
  Tot: Real;
  Chart1: TChart;
  R1: TRect;
  I: Integer;
  ThisSeries: TBarSeries;
  F: TForm; //20160411 Igor
begin

  //20160411 Igor >>>
  F := TForm.Create(nil);
  F.Visible := False;
  Chart1 := TChart.Create(F);
  Chart1.Parent := F;
  //20160411 Igor <<<
  With Chart1 do
  begin
    Title.Font.color := clBlack;
    Title.Font.Size := 12;
    Title.Font.Style := [fsBold];
    Title.Text.clear;
    Title.Text.Add('RRIF');

    LeftAxis.Automatic := False;
    LeftAxis.Minimum := GetMinGenEndBalance(RetNo, GenBalanceList);
    LeftAxis.Minimum := 1.10 * LeftAxis.Minimum;
    LeftAxis.Maximum := GetMaxGenEndBalance(RetNo, GenBalanceList);
    LeftAxis.Maximum := 1.10 * LeftAxis.Maximum;
    Legend.Visible := False;
    AxisVisible := True;
    Gradient.Visible := True;
    Gradient.StartColor := $008080FF; { pinkish }
    Gradient.EndColor := clAqua;
  end;
  { add series }
  ThisSeries := TBarSeries.Create(Chart1);
  TeeEraseBack := False;
  Chart1.Addseries(ThisSeries);
  With ThisSeries do
  Begin
    Marks.Visible := False; { no yellow boxes on top of Bar }
    BarStyle := bsRectGradient; { Rectangle; }
    BarBrush.color := clRed;
  end;

  With ThisSeries do
  Begin
    clear;
    { apply data }
    If GenBalanceList.Count < 1 then
      exit;
    I := 0;
    Repeat
      GenBalanceRec := GenBalanceList.Items[I];
      If YearOrAge = True then
        Add(Round(GenBalanceRec.EndBalance), IntToStr(GenBalanceRec.Year),
          clTeeColor)
      else
        Add(Round(GenBalanceRec.EndBalance), IntToStr(GenBalanceRec.Age),
          clTeeColor);
      inc(I, 1); { every  1,2 or 3years }
    until I > GenBalanceList.Count - 1;
  end;
  {
    ChangeRect(R,R1);
    Chart1.Draw(TempCanvas.Canvas,R1);
  }
  Chart1.Draw(TempCanvas.Canvas, R);
  Chart1.free;
  F.Free;
end;



procedure CalcFutValData(RetNo:Integer;Years:Integer;Interest,OpeningBalance:Real;GenBalanceList:TGenBalanceList);
Var i:Integer;InvestedAmount,RunningBalance:Real;
begin
  For i := 1 to Years do
  begin
   FutValRec := TGenBalanceRec.Create;
   FutValRec.PeriodNo      := i;
   If i=1 then
      FutValRec.BegBalance    := OpeningBalance
   else
      FutValRec.BegBalance    := RunningBalance;

  InvestedAmount := FutValRec.BegBalance;
  FutValRec.EndBalance :=FutureValue(InvestedAmount,Interest,1);

  RunningBalance := FutValRec.EndBalance;
  GenBalanceList.Add(FutValRec);
 end;

end;


procedure CalcPresValData(RetNo:Integer;Years:Integer;Interest,OpeningBalance:Real;Var BalanceList:TList);
Const StreamId =5;
Var i:Integer;InvestedAmount,RunningBalance:Real;
begin
end;



procedure ChartFutVal(RetNo: Integer; TempCanvas: TBitMap; R: TRect);
Var
  Tot: Real;
  Chart1: TChart;
  R1: TRect;
  I, FNo: Integer;
  ThisSeries: TBarSeries;
  Years: Integer;
  Interest, OpeningBalance: Real;
  F: TForm; //20160411 Igor
begin

  { Get data }
  GenBalanceList.free;
  GenBalanceList := TGenBalanceList.Create;
  FNo := GetFormNo('FUTVAL');
  OpeningBalance := Vl(FetchElmFNo(RetNo, FNo, 1));
  Years := MyStrToInt(FetchElmFNo(RetNo, FNo, 2));
  Interest := Vl(FetchElmFNo(RetNo, FNo, 3));
  CalcFutValData(RetNo, Years, Interest, OpeningBalance, GenBalanceList);

  { create chart }
  //20160411 Igor >>>
  F := TForm.Create(nil);
  F.Visible := False;
  Chart1 := TChart.Create(F);
  Chart1.Parent := F;
  //20160411 Igor <<<
  With Chart1 do
  begin
    Title.Font.color := clBlack;
    Title.Font.Size := 12;
    Title.Font.Style := [fsBold];
    Title.Text.clear;
    Title.Text.Add('Future Value at ' + FormatFloat('###.00', Interest) + '%');

    LeftAxis.Automatic := False;

    LeftAxis.Minimum := GetMinFVEndBalance(RetNo, GenBalanceList);
    LeftAxis.Maximum := GetMaxFVEndBalance(RetNo, GenBalanceList);
    Legend.Visible := False;
    AxisVisible := True;
    Gradient.Visible := True;
    Gradient.StartColor := $008080FF; { pinkish }
    Gradient.EndColor := clAqua;
  end;
  { add series }
  ThisSeries := TBarSeries.Create(Chart1);
  TeeEraseBack := False;
  Chart1.Addseries(ThisSeries);
  With ThisSeries do
  Begin
    Marks.Visible := False; { no yellow boxes on top of Bar }
    BarStyle := bsRectGradient; { Rectangle; }
    BarBrush.color := clRed;
  end;

  With ThisSeries do
  Begin
    clear;
    { apply data }
    If GenBalanceList.Count < 1 then
      exit;
    I := 0;
    Repeat
      FutValRec := GenBalanceList.Items[I];
      Add(Round(FutValRec.EndBalance), IntToStr(FutValRec.PeriodNo),
        clTeeColor);
      inc(I, 1); { every  1,2 or 3years }
    until I > GenBalanceList.Count - 1;
  end;
  {
    ChangeRect(R,R1);
    Chart1.Draw(TempCanvas.Canvas,R1); }
  Chart1.Draw(TempCanvas.Canvas, R);
  Chart1.free;
  F.Free;
  FreeAndNil(GenBalanceList);
end;


procedure ChartPresVal(RetNo:Integer;ThisStream:String;TempCanvas:TBitMap;R:TRect);
Var Tot:Real; Chart1 : TChart; R1:TRect;
 i,FNo:Integer;ThisSeries :TBarSeries;
 Years:Integer;Interest,OpeningBalance:Real;
begin
end;




Procedure ChangeRect(R:TRect;Var R1:TRect); {bug in tchart}
begin

  R1.Left :=R.Top;
  R1.Top  :=R.Left;
  R1.Bottom :=R1.Top+(R.Bottom-R.Top);
  R1.Right :=R1.Left+(R.Right-R.Left);
end;

Function GetAccumChartTitle(ThisStream,Interest:String):String;
begin
  result :='';
  If interest='' then interest := '0.0';
  If ThisStream      = 'PSHELT' then result :='Sheltered Investments at '+AllTrim(Interest)+' %'
  else If ThisStream = 'PNONSH' then result :='Non Sheltered Investments at '+AllTrim(Interest)+' % after tax'
  else If ThisStream = 'PSEMSH' then result :='Semi-Sheltered Investments at '+AllTrim(Interest)+' % after tax'
//  else If ThisStream = 'POTHER' then result :='Other investments at '+AllTrim(Interest)+' % after tax';
end;

Procedure BuildAssetsProjection(RetNo:Integer);
Var i:Integer; StreamId: Integer;
begin
  GetRetirementParms(RetNo);
  //TotInvestmProjectionList.Clear;
  //TotInvestmProjectionList.Capacity:=RetirementParms.NumbPeriods+2;
  {now add up balances}
   //For i:=1 to RetirementParms.NumbPeriods do
   For i:=0 to RetirementParms.NumbPeriods do
   //For i:=0 to BalanceList.Count-1 do  {work from the balance list}
   begin
      BalanceRec := TBalanceRec(BalanceList.Items[i]);
      //New(TotInvestmProjectionRec);
      TotInvestmProjectionRec :=TotInvestmProjectionList.Items[i];
      TotInvestmProjectionRec.PeriodNo := BalanceRec.PeriodNo;
      TotInvestmProjectionRec.Age := BalanceRec.Age[0];
      TotInvestmProjectionRec.Year:= BalanceRec.Year;
      TotInvestmProjectionRec.TotBegBalance :=0;
      TotInvestmProjectionRec.TotEndBalance:=0;
      For StreamId:=1 to 4 do
       begin
       TotInvestmProjectionRec.BegBalance[StreamId] := 0;
       TotInvestmProjectionRec.EndBalance[StreamId] := 0;
       end;

      For StreamId:=1 to 4 do
       begin
       TotInvestmProjectionRec.BegBalance[StreamId] := BalanceRec.BegBalance[StreamId];
       TotInvestmProjectionRec.EndBalance[StreamId] := BalanceRec.EndBalance[StreamId];
       end;
      For StreamId:=1 to 4 do
       begin
       TotInvestmProjectionRec.TotBegBalance  :=  TotInvestmProjectionRec.TotBegBalance+BalanceRec.BegBalance[StreamId];
       TotInvestmProjectionRec.TotEndBalance  :=TotInvestmProjectionRec.TotEndBalance +BalanceRec.EndBalance[Streamid];
       end;
     // TotInvestmProjectionList.Add(TotInvestmProjectionRec);
   end; {i}
end;

Procedure BuildNetWorthProjection(RetNo:Integer);
Var i:Integer; StreamId: Integer;
begin
  // BuildBusinessProjection(RetNo);
   GetRetirementParms(RetNo);
   For i:=0 to RetirementParms.NumbPeriods do
   begin
      TotInvestmProjectionRec := TotInvestmProjectionList.Items[i];  //???
      InvProjectionRec := InvProjectionList.Items[i];  //???
      BalanceRec := BalanceList.Items[i];  //March 3
      FixedAssetsProjectionRec := FixedAssetsProjectionList.Items[i];
      BusinesssProjectionRec   := BusinessProjectionList.Items[i];
      LiabilitiesProjectionRec := LiabilitiesProjectionList.Items[i];
      //New(NetWorthProjectionRec);
      NetWorthProjectionRec := NetWorthProjectionList.items[i];
      NetWorthProjectionRec.PeriodNo := BalanceRec.PeriodNo; //InvProjectionRec.PeriodNo;//TotInvestmProjectionRec.PeriodNo;
      //NetWorthProjectionRec.Age := InvProjectionRec.Age; //TotInvestmProjectionRec.Age;
      NetWorthProjectionRec.Year:= BalanceRec.Year; //InvProjectionRec.Year; //TotInvestmProjectionRec.Year;
      NetWorthProjectionRec.Age:= FixedAssetsProjectionRec.Age;
      NetWorthProjectionRec.TotAssets :=
            BalanceRec.EndBalance[1]
            +BalanceRec.EndBalance[2]
            +BalanceRec.EndBalance[3]
            //BalanceRec.EndBalance[1]
             {
             BalanceRec.NonSh //InvProjectionRec.NonSh
             +BalanceRec.Shelt[0]+BalaneRec.Shelt[1] //InvProjectionRec.Shelt[0]+InvProjectionRec.Shelt[1]
             +BalanceRec.NonSh //InvProjectionRec.NonSh
             }
             +FixedAssetsProjectionRec.Total
             +BusinesssProjectionRec.Total;
        //TotInvestmProjectionRec.TotEndBalance+FixedAssetsProjectionRec.Total;
      NetWorthProjectionRec.TotLiabilities:=LiabilitiesProjectionRec.TotLiability;
      NetWorthProjectionRec.NetWorth:=NetWorthProjectionRec.TotAssets-NetWorthProjectionRec.TotLiabilities;
    //  NetWorthProjectionList.Add(NetWorthProjectionRec);
   end; {i}
end;

Procedure BuildCashFlowProjection(RetNo:Integer);
Var i,j,J1,J2,k,StartAge,SpouseStartAge:Integer;INCPROJECTIONFNo:Integer;
    Amount,IndexBy:Real;FromAge,ToAge:Integer;

begin
  GetRetirementParms(RetNo);
  {initialize}
  //CashFlowProjectionList.Clear;
  //CashFlowProjectionList.Capacity:=RetirementParms.NumbPeriods+2;

  INCPROJECTIONFNo:=GetFormNo('INCPROJECTION');
  StartAge := GetPlanStartAge(RetNo);
  SpouseStartAge:= GetSpousePlanStartAge(RetNo);
  //initialize
  For i:=0 to RetirementParms.NumbPeriods do
  begin
   //New(CashFlowProjectionRec);
   CashFlowProjectionRec :=CashFlowProjectionList.Items[i];
   CashFlowProjectionRec.PeriodNo      := i;
   CashFlowProjectionRec.Year          := (RetirementParms.StartYear)+i;
   CashFlowProjectionRec.Age           := StartAge+i;
   For k:=0 to 1 do
   begin
     CashFlowProjectionRec.Empl[k]          := 0;
     CashFlowProjectionRec.InvInterest[k]   := 0;
     CashFlowProjectionRec.InvActualDivElig[k] := 0;
     CashFlowProjectionRec.InvActualDivNonElig[k] := 0;
     CashFlowProjectionRec.InvOther[k]      := 0;
     CashFlowProjectionRec.BusAndOther[k]   := 0;
     CashFlowProjectionRec.PensCpp[k]       := 0;
     CashFlowProjectionRec.PensOAS[k]       := 0;
     CashFlowProjectionRec.PensOther[k]     := 0;
     CashFlowProjectionRec.OthInc[k]        := 0;
     CashFlowProjectionRec.TotIncome[k]     := 0;
     CashFlowProjectionRec.NonTaxableIncome[k] := 0;
     CashFlowProjectionRec.EstTax[k]     := 0;
     //If ManualTax<> 'Y' then CashFlProjectionRec.EstTax[k] := 0;
   end;
   CashFlowProjectionRec.Cola               := 0;
   CashFlowProjectionRec.LTermDebt          := 0;
   CashFlowProjectionRec.DispInc            := 0;
  // CashFlowProjectionList.Add(CashFlowProjectionRec);
  end; //i loop

  //CLIENT
  i:=9;
  Repeat
   Amount:=Vl(FetchElmFNo(RetNo,INCPROJECTIONFNo,i));
   FromAge:=MyStrToInt(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+1));
   ToAge:=MyStrToInt(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+2));
   //Percent:=Vl(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+3))/100;
   If Amount <> 0 then
   begin
    //find proper subscript in cash fl projection list i.e. goes from 0 to 31
    // age goes from 61 to 95
    If FromAge<StartAge then FromAge:=StartAge;
    J1:=FromAge-StartAge;
    If ToAge<StartAge
    then
     J2:=0
    else
     J2:=ToAge-StartAge;
    If J2>RetirementParms.NumbPeriods then
      J2:=RetirementParms.NumbPeriods;

    For j:=J1 to j2 do
    begin
     //empl
     Case i of
     9,17,25,33:  //empl
       begin
         CashFlowProjectionRec := CashFlowProjectionList.Items[j];
         CashFlowProjectionRec.Empl[0]:=CashFlowProjectionRec.Empl[0]
          +GetIndexedAmount(Amount,Vl(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+3)),j+1-FromAge+StartAge);
          //+Amount+Amount * (j-J1)* Percent;
       end;
     end;

     Case i of
      41:
      begin
       CashFlowProjectionRec := CashFlowProjectionList.Items[j];
       CashFlowProjectionRec.PensCpp[0]:=CashFlowProjectionRec.PensCpp[0]
        +GetIndexedAmount(Amount,Vl(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+3)),j+1-FromAge+StartAge);
       //+Amount+Amount * Percent;
      end;
     end;

     Case i of
      49:
      begin
       CashFlowProjectionRec := CashFlowProjectionList.Items[j];
       CashFlowProjectionRec.PensOAS[0]:=CashFlowProjectionRec.PensOAS[0]
        +GetIndexedAmount(Amount,Vl(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+3)),j+1-FromAge+StartAge);
       //+Amount+Amount * Percent;
      end;
     end;

     Case i of
      57,65,73:
      begin
       CashFlowProjectionRec := CashFlowProjectionList.Items[j];
       CashFlowProjectionRec.PensOther[0]:=CashFlowProjectionRec.PensOther[0]
        +GetIndexedAmount(Amount,Vl(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+3)),j+1-FromAge+StartAge);
       //+Amount+Amount * Percent;
      end;
     end;

     Case i of
      105,113:
      begin
       CashFlowProjectionRec := CashFlowProjectionList.Items[j];
       CashFlowProjectionRec.BusAndOther[0]:=CashFlowProjectionRec.BusAndOther[0]
        +GetIndexedAmount(Amount,Vl(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+3)),j+1-FromAge+StartAge);
      end;
     end;

     Case i of
      81:
      begin
       CashFlowProjectionRec := CashFlowProjectionList.Items[j];
       CashFlowProjectionRec.InvInterest[0]:=CashFlowProjectionRec.InvInterest[0]
        +GetIndexedAmount(Amount,Vl(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+3)),j+1-FromAge+StartAge);
      end;
     end;

     Case i of
      89, 121:
      begin
       CashFlowProjectionRec := CashFlowProjectionList.Items[j];
       CashFlowProjectionRec.InvActualDivNonElig[0]:=CashFlowProjectionRec.InvActualDivNonElig[0]
         +GetIndexedAmount(Amount,Vl(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+3)),j+1-FromAge+StartAge);
      end;
     end;

     Case i of
      241:
      begin
       CashFlowProjectionRec := CashFlowProjectionList.Items[j];
       CashFlowProjectionRec.InvActualDivElig[0]:=CashFlowProjectionRec.InvActualDivElig[0]
         +GetIndexedAmount(Amount,Vl(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+3)),j+1-FromAge+StartAge);
        //+Amount+Amount * Percent;
      end;
     end;

     Case i of
      129,137,145,153,161,169,177,185,193,201,209,217:
      begin
       CashFlowProjectionRec := CashFlowProjectionList.Items[j];
       CashFlowProjectionRec.OthInc[0]:=CashFlowProjectionRec.OthInc[0]
        +GetIndexedAmount(Amount,Vl(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+3)),j+1-FromAge+StartAge);
       If (i=153) or (i=161) or (i=169) then CashFlowProjectionRec.NonTaxableIncome[0]:=
            CashFlowProjectionRec.NonTaxableIncome[0]
            +GetIndexedAmount(Amount,Vl(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+3)),j+1-FromAge+StartAge);
      end;
     end;
    end;  //j loop
   end; //amount
   Inc(i,8);
  until i>241; //217;


  //SPOUSE
  If Ret[RetNo].MarStatus <3 then
  begin
   i:=13;
   Repeat
    Amount:=Vl(FetchElmFNo(RetNo,INCPROJECTIONFNo,i));
    FromAge:=MyStrToInt(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+1));
    ToAge:=MyStrToInt(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+2));
    If Amount<>0 then
    begin
     //find proper subscript in cash fl projection list
     If FromAge<SpouseStartAge then FromAge:=SpouseStartAge;
     J1:=FromAge-SpouseStartAge;
     If ToAge<SpouseStartAge then Begin ToAge:=SpouseStartAge;Amount:=0;end;
     J2:=ToAge-SpouseStartAge;
     For j:=J1 to j2 do
     begin
      //empl
       Case i of
      13,21,29,37:
        begin
          CashFlowProjectionRec := CashFlowProjectionList.Items[j];
          CashFlowProjectionRec.Empl[1]:=CashFlowProjectionRec.Empl[1]
            +GetIndexedAmount(Amount,Vl(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+3)),j+1-FromAge+StartAge);
         end;
      end;

      Case i of
       45:
       begin
        CashFlowProjectionRec := CashFlowProjectionList.Items[j];
        CashFlowProjectionRec.PensCpp[1]:=CashFlowProjectionRec.PensCpp[1]
          +GetIndexedAmount(Amount,Vl(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+3)),j+1-FromAge+StartAge);
       end;
      end;

      Case i of
       53:
       begin
        CashFlowProjectionRec := CashFlowProjectionList.Items[j];
        CashFlowProjectionRec.PensOAS[1]:=CashFlowProjectionRec.PensOAS[1]
          +GetIndexedAmount(Amount,Vl(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+3)),j+1-FromAge+StartAge);
       end;
      end;

      Case i of
       61,69,77:
       begin
        CashFlowProjectionRec := CashFlowProjectionList.Items[j];
        CashFlowProjectionRec.PensOther[1]:=CashFlowProjectionRec.PensOther[1]
          +GetIndexedAmount(Amount,Vl(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+3)),j+1-FromAge+StartAge);
       end;
      end;

      Case i of
       109,117: //,85,93,101:
       begin
        CashFlowProjectionRec := CashFlowProjectionList.Items[j];
        CashFlowProjectionRec.BusAndOther[1]:=CashFlowProjectionRec.BusAndOther[1]
          +GetIndexedAmount(Amount,Vl(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+3)),j+1-FromAge+StartAge);
       end;
      end;

      Case i of
       85:
       begin
        CashFlowProjectionRec := CashFlowProjectionList.Items[j];
        CashFlowProjectionRec.InvInterest[1]:=CashFlowProjectionRec.InvInterest[1]
          +GetIndexedAmount(Amount,Vl(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+3)),j+1-FromAge+StartAge);
       end;
      end;

      Case i of
       93, 125:
       begin
        CashFlowProjectionRec := CashFlowProjectionList.Items[j];
        CashFlowProjectionRec.InvActualDivNonElig[1]:=CashFlowProjectionRec.InvActualDivNonElig[1]
          +GetIndexedAmount(Amount,Vl(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+3)),j+1-FromAge+StartAge);
       end;
      end;

      Case i of
       245:
       begin
         CashFlowProjectionRec := CashFlowProjectionList.Items[j];
         CashFlowProjectionRec.InvActualDivElig[1]:=CashFlowProjectionRec.InvActualDivElig[1]
          +GetIndexedAmount(Amount,Vl(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+3)),j+1-FromAge+StartAge);
       end;
      end;

      Case i of
       133,141,149,157,165,173,181,189,197,205,213,221:
       begin
        CashFlowProjectionRec := CashFlowProjectionList.Items[j];
        CashFlowProjectionRec.OthInc[1]:=CashFlowProjectionRec.OthInc[1]
          +GetIndexedAmount(Amount,Vl(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+3)),j+1-FromAge+StartAge);
        If (i=157) or (i=165) or (i=173) then CashFlowProjectionRec.NonTaxableIncome[1]:=
            CashFlowProjectionRec.NonTaxableIncome[1]
            +GetIndexedAmount(Amount,Vl(FetchElmFNo(RetNo,INCPROJECTIONFNo,i+3)),j+1-FromAge+StartAge);
       end;
      end;
     end;  //j loop
    end; //amount
    Inc(i,8);
    until i>245; //221;
  end; //spouse

  If UpperCase(FetchElm(RetNo,'ASSUME',74))='Y' then
    IndexBy:=Vl(FetchElm(RetNo,'ASSUME',3))
  else
    IndexBy:=0;
  For i:=0 to RetirementParms.NumbPeriods do //CashFlowProjectionList.Count-1 do
  begin
   CashFlowProjectionRec      := CashFlowProjectionList[i];
   LiabilitiesProjectionRec := LiabilitiesProjectionList[i];
   CashFlowProjectionRec.LTermDebt:=
    (LiabilitiesProjectionRec.MonthlyMortgage
     +LiabilitiesProjectionRec.MonthlyAuto
     +LiabilitiesProjectionRec.MonthlyOther) * 12;

   If CashFlowProjectionRec.Age < ClientAgeAtRetirement(RetNo) then
    CashFlowProjectionRec.Cola:=
      GetIndexedAmount(Vl(FetchElm(RetNo,'LIVINGEXP_2',120)),IndexBy,i+1)
   else
    CashFlowProjectionRec.Cola:=
       GetIndexedAmount(Vl(FetchElm(RetNo,'LIVINGEXP_2',122)),IndexBy,
         i+1-ClientAgeAtRetirement(RetNo)+StartAge);

   For k:=0 to 1 do
   begin
      CashFlowProjectionRec.TotIncome[k]:=
      CashFlowProjectionRec.Empl[k]+
      CashFlowProjectionRec.InvInterest[k]+
      CashFlowProjectionRec.InvActualDivNonElig[k]+
      CashFlowProjectionRec.InvActualDivElig[k]+
      CashFlowProjectionRec.InvOther[k]+
      CashFlowProjectionRec.BusAndOther[k]+
      CashFlowProjectionRec.PensCpp[k]+
      CashFlowProjectionRec.PensOAS[k]+
      CashFlowProjectionRec.PensOther[k]+
      CashFlowProjectionRec.OthInc[k];
      InitTaxRec;
      With TaxRec do
      begin
       If k=0 then
         Age:=CalcAge(FetchElm(RetNo,'PROFILE',27))
       else
         Age:=CalcAge(FetchElm(RetNo,'PROFILE',29));
       MaritalStatus:=GetMarStatus(RetNo);
       Province:=UpperCase(FetchElm(RetNo,'PROFILE',99));
       ActualDividendsNonElig:=CashFlowProjectionRec.InvActualDivNonElig[k];
       ActualDividendsElig:=CashFlowProjectionRec.InvActualDivElig[k];
       TaxableIncome:= CashFlowProjectionRec.TotIncome[k]
                      +CashFlowProjectionRec.InvActualDivNonElig[k] * 25/100
                      +CashFlowProjectionRec.InvActualDivElig[k] * 45/100
                      -CashFlowProjectionRec.NonTaxableIncome[k];
       CashFlowProjectionRec.EstTax[k]:=CalcTaxForCashFlow(RetNo);  //not for spouse
      end; //taxrec
    end; //k
   CashFlowProjectionRec.DispInc:=
    CashFlowProjectionRec.TotIncome[0]+CashFlowProjectionRec.TotIncome[1]
    -CashFlowProjectionRec.Cola
    -CashFlowProjectionRec.LTermDebt
    -CashFlowProjectionRec.EstTax[0]-CashFlowProjectionRec.EstTax[1];
  end; //i
end;

Procedure BuildRRSPProjection(RetNo:Integer);
Var i,j,J1,J2,k,StartAge,StartSpouseAge,InvOption,DispIncFNo:Integer;
    SheltPercent,NonShPercent,SemiShPercent,OtherPercent:Real;
    FixedRRSp:Real;MaxRRSPFlag:Boolean;
    DispIncome:Real;
    DedLimit:Array[0..1] of real;
    PrevDedLimit,PrevRRSPContr:Real;

begin
  GetRetirementParms(RetNo);
  {initialize}
  //RRSPProjectionList.Clear;
  //RRSPProjectionList.Capacity:=RetirementParms.NumbPeriods+2;
  StartAge := GetPlanStartAge(RetNo);
  StartSpouseAge := SpouseAge(RetNo);
  //initialize
  For i:=0 to RetirementParms.NumbPeriods do
  begin
   //New(RRSPProjectionRec);
   RRSPProjectionRec :=RRSPProjectionList.Items[i];
   RRSPProjectionRec.PeriodNo      := i;
   RRSPProjectionRec.Year          := (RetirementParms.StartYear)+i;
   RRSPProjectionRec.DollarLimit   := 0;
   For k:=0 to 1 do
   begin
    RRSPProjectionRec.Age[k]           :=  StartAge+i;
    RRSPProjectionRec.PriorYrEarned[k] := 0;
    RRSPProjectionRec.PriorYrPA[k]     := 0;
    RRSPProjectionRec.PriorYrUnusedRoom[k]:= 0;
    RRSPProjectionRec.DedLimit[k]      := 0;
    RRSPProjectionRec.RRSPContr[k]     :=0;
   end;
   //RRSPProjectionList.Add(RRSPProjectionRec);
  end; //i loop

  DispIncFNo:=GetFormNo('INVESTSTRATEGY');
  If FetchElmFNo(RetNo,DispIncFNo,43) >'' then  //Invest  % of Disp income
  begin
   InvOption:=1;
   SheltPercent:=Vl(FetchElmFNo(RetNo,DispIncFNo,29))/100;
  end
  Else  //invest after rrsp taken
  begin
   InvOption:=2;
   FixedRRSP:=Vl(FetchElmFNo(RetNo,DispIncFNo,11));
   If FetchElmFNo(RetNo,DispIncFNo,10)>'' then MaxRRSPFlag:=True else MaxRRSPFlag:=False;
  end;

 // For i:=0 to RRSPProjectionList.Count-1 do
  For i:=0 to RetirementParms.NumbPeriods do
  begin
   RRSPProjectionRec      := RRSPProjectionList[i];
   If i=0 then   //first record
   begin
     RRSPProjectionRec.PriorYrEarned[0]:=Vl(FetchElm(RetNo,'INVESTSTRATEGY',6));
     RRSPProjectionRec.PriorYrPA[0]:=Vl(FetchElm(RetNo,'INVESTSTRATEGY',40));
     RRSPProjectionRec.PriorYrUnusedRoom[0]:= Vl(FetchElmFNo(RetNo,DispIncFNo,4));
     RRSPProjectionRec.DedLimit[0]:=Vl(FetchElmFNo(RetNo,DispIncFNo,14));

     If Ret[RetNo].MarStatus <3 then
     begin
      RRSPProjectionRec.PriorYrEarned[1]:=Vl(FetchElm(RetNo,'INVESTSTRATEGY',7));
      RRSPProjectionRec.PriorYrPA[1]:=Vl(FetchElm(RetNo,'INVESTSTRATEGY',41));
      RRSPProjectionRec.PriorYrUnusedRoom[1]:= Vl(FetchElmFNo(RetNo,DispIncFNo,5));
      RRSPProjectionRec.DedLimit[1]:=Vl(FetchElmFNo(RetNo,DispIncFNo,15));  //spouse
     end;
   end
   else //i>0
   begin
     CashFlowProjectionRec   := CashFlowProjectionList[i-1]; //previoys yr
     RRSPProjectionRec.PriorYrEarned[0]:=
                   CashFlowProjectionRec.Empl[0]
                  +CashFlowProjectionRec.BusAndOther[0]
                  +CashFlowProjectionRec.OthInc[0];
     If Ret[RetNo].MarStatus <3 then
      RRSPProjectionRec.PriorYrEarned[1]:=
                   CashFlowProjectionRec.Empl[1]
                  +CashFlowProjectionRec.BusAndOther[1]
                  +CashFlowProjectionRec.OthInc[1];
     //back to normal
     CashFlowProjectionRec   := CashFlowProjectionList[i];
     RRSPProjectionRec.DedLimit[0]:=
                  GetDedLimit(RRSPProjectionRec.PriorYrEarned[0],
                   RRSPProjectionRec.PriorYrPA[0],
                   RRSPProjectionRec.PriorYrUnusedRoom[0],
                   RRSPProjectionRec.Year);
     If Ret[RetNo].MarStatus <3 then
      RRSPProjectionRec.DedLimit[1]:=
                  GetDedLimit(RRSPProjectionRec.PriorYrEarned[1],
                   RRSPProjectionRec.PriorYrPA[1],
                   RRSPProjectionRec.PriorYrUnusedRoom[1],
                   RRSPProjectionRec.Year);
     //client unused room
     RRSPProjectionRec :=RRSPProjectionList[i-1]; //previoys RRSP yr
     PrevDedLimit:=RRSPProjectionRec.DedLimit[0];
     PrevRRSPContr:=RRSPProjectionRec.RRSPContr[0];
     RRSPProjectionRec :=RRSPProjectionList[i]; //back to current record
     RRSPProjectionRec.PriorYrUnusedRoom[0]:=MaxR(0,PrevDedLimit-PrevRRSPContr);
     //spouse
    If Ret[RetNo].MarStatus <3 then
     begin
      RRSPProjectionRec :=RRSPProjectionList[i-1]; //previoys RRSP yr
      PrevDedLimit:=RRSPProjectionRec.DedLimit[1];
      PrevRRSPContr:=RRSPProjectionRec.RRSPContr[1];
      RRSPProjectionRec :=RRSPProjectionList[i]; //back to current record
      RRSPProjectionRec.PriorYrUnusedRoom[1]:=MaxR(0,PrevDedLimit-PrevRRSPContr);
     end;
    end;  //i>0
    RRSPProjectionRec :=RRSPProjectionList[i];
    RRSPProjectionRec.DollarLimit:=GetDollarLimit(RRSPProjectionRec.Year);
    CashFlowProjectionRec :=CashFlowProjectionList[i];
    DispIncome:=CashFlowProjectionRec.DispInc;
    //calc rrsp contr
    If InvOption=1 then
    begin
      RRSPProjectionRec.RRSPContr[0] :=
        MaxR(0,MinR(DispIncome * SheltPercent,RRSPProjectionRec.DedLimit[0]));

      RRSPProjectionRec.RRSPContr[1] :=
        MaxR(0,MinR((DispIncome-RRSPProjectionRec.RRSPContr[0]) * SheltPercent,
           RRSPProjectionRec.DedLimit[1]));
    end
    Else   //option 2: fixed or max
    begin
     If MaxRrspFlag=True then
     begin
        RRSPProjectionRec.RRSPContr[0] :=
        MaxR(0,MinR(RRSPProjectionRec.DedLimit[0],DispIncome));
       If Ret[RetNo].MarStatus <3 then
        RRSPProjectionRec.RRSPContr[1] :=
         MaxR(0,MinR(RRSPProjectionRec.DedLimit[1],
          DispIncome-RRSPProjectionRec.RRSPContr[0]));
     end
     else  //fixed contribution
     begin
       RRSPProjectionRec.RRSPContr[0] :=
        MaxR(0,
         MinR(FixedRRsp,MinR(RRSPProjectionRec.DedLimit[0],DispIncome)));
       If Ret[RetNo].MarStatus <3 then
         RRSPProjectionRec.RRSPContr[1] :=
         MaxR(0,
         MinR(FixedRRsp,MinR(RRSPProjectionRec.DedLimit[0],
           DispIncome-RRSPProjectionRec.RRSPContr[0])));
     end;
    end;

    If i=0 then
    begin
     RRSPProjectionRec.RRSPContr[0] :=Vl(FetchElm(RetNo,'INVESTSTRATEGY',50));
     If Ret[RetNo].MarStatus <3 then
       RRSPProjectionRec.RRSPContr[1] :=Vl(FetchElm(RetNo,'INVESTSTRATEGY',51));
    end;

    If RRSPProjectionRec.Age[0]>69 then
    begin
     RRSPProjectionRec.PriorYrEarned[0] := 0;
     RRSPProjectionRec.PriorYrPA[0]     := 0;
     RRSPProjectionRec.PriorYrUnusedRoom[0]:= 0;
     RRSPProjectionRec.DedLimit[0]      := 0;
     RRSPProjectionRec.RRSPContr[0] :=0;
    end;
    If RRSPProjectionRec.Age[1]>69 then
    begin
     RRSPProjectionRec.RRSPContr[1] :=0;
     RRSPProjectionRec.PriorYrEarned[1] := 0;
     RRSPProjectionRec.PriorYrPA[1]     := 0;
     RRSPProjectionRec.PriorYrUnusedRoom[1]:= 0;
     RRSPProjectionRec.DedLimit[1]      := 0;
     RRSPProjectionRec.RRSPContr[1] :=0;
    end;
  end;
end;

Procedure BuildInvProjection(RetNo:Integer);
Var i,j,J1,J2,k,StartAge,StartSpouseAge,InvOption,DispIncFNo:Integer;
    SheltPercent,NonShPercent,SemiShPercent,OtherPercent,X:Real;
    FixedRRSp:Real;MaxRRSPFlag:Boolean;
    DedLimit:Array[0..1] of real;
begin
  GetRetirementParms(RetNo);
  {initialize}
  //InvProjectionList.Clear;
  //InvProjectionList.Capacity:=RetirementParms.NumbPeriods+2;
  StartAge := GetPlanStartAge(RetNo);
  StartSpouseAge := SpouseAge(RetNo);
  //initialize
  For i:=0 to RetirementParms.NumbPeriods do
  begin
   //New(InvProjectionRec);
   InvProjectionRec :=InvProjectionList.Items[i];
   InvProjectionRec.PeriodNo      := i;
   InvProjectionRec.Year          := (RetirementParms.StartYear)+i;
   InvProjectionRec.Age[0]      :=  StartAge+i;
   If Ret[Retno].MarStatus<3 then
     InvProjectionRec.Age[1]      :=  StartSpouseAge+i
   Else
     InvProjectionRec.Age[1]      :=  0;
   InvProjectionRec.Shelt[0]    := 0;
   InvProjectionRec.Shelt[1]    := 0;
   InvProjectionRec.SemiSh        := 0;
   InvProjectionRec.NonSh         := 0;
   InvProjectionRec.Other         := 0;
  // InvProjectionList.Add(InvProjectionRec);
  end; //i loop

  DispIncFNo:=GetFormNo('INVESTSTRATEGY');
  If FetchElmFNo(RetNo,DispIncFNo,43) >'' then  //Invest  % of Disp income
  begin
   InvOption:=1;
   SheltPercent:=Vl(FetchElmFNo(RetNo,DispIncFNo,29))/100;
   NonShPercent:=Vl(FetchElmFNo(RetNo,DispIncFNo,30))/100;
   SemiShPercent:=Vl(FetchElmFNo(RetNo,DispIncFNo,31))/100;
   OtherPercent:=Vl(FetchElmFNo(RetNo,DispIncFNo,32))/100;
  end
  Else  //invest after rrsp taken
  begin
   InvOption:=2;
   FixedRRSP:=Vl(FetchElmFNo(RetNo,DispIncFNo,11));
   If FetchElmFNo(RetNo,DispIncFNo,10)>'' then MaxRRSPFlag:=True else MaxRRSPFlag:=False;
   //SheltPercent:=Vl(FetchElmFNo(RetNo,DispIncFNo,29))/100;
   NonShPercent:=Vl(FetchElmFNo(RetNo,DispIncFNo,12))/100;
   SemiShPercent:=Vl(FetchElmFNo(RetNo,DispIncFNo,13))/100;
   OtherPercent:=Vl(FetchElmFNo(RetNo,DispIncFNo,28))/100;
  end;

  For i:=0 to RetirementParms.NumbPeriods do //InvProjectionList.Count-1 do
  begin
   InvProjectionRec         := InvProjectionList[i];
   CashFlowProjectionRec    := CashFlowProjectionList[i];
{ TODO 1 -oCon : what's this? }
   //RRSPProjectionRec        := PCashFlowProjectionList(CashFlowProjectionList[i]);
   RRSPProjectionRec        := RRSPProjectionList[i];

   InvProjectionRec.DispInc :=CashFlowProjectionRec.DispInc;
   CashFlowProjectionRec    := CashFlowProjectionList[i];  //again
   RRSPProjectionRec        := RRSPProjectionList[i];  //again
   //calc rrsp contr
   InvProjectionRec.Shelt[0] :=RRSPProjectionRec.RRSPContr[0];
   InvProjectionRec.Shelt[1] :=RRSPProjectionRec.RRSPContr[1];
   InvProjectionRec.NonSh  :=
    (CashFlowProjectionRec.DispInc
     -InvProjectionRec.Shelt[0]
     -InvProjectionRec.Shelt[1]) * NonShPercent;
   InvProjectionRec.SemiSh :=CashFlowProjectionRec.DispInc * SemiShPercent;
   InvProjectionRec.Other  := CashFlowProjectionRec.DispInc* OtherPercent;
   x:=CashFlowProjectionRec.DispInc
     -(InvProjectionRec.Shelt[0]
       +InvProjectionRec.Shelt[1]
       +InvProjectionRec.NonSh
       +InvProjectionRec.SemiSh
       +InvProjectionRec.Other);
   InvProjectionRec.NonSh:=InvProjectionRec.NonSh+X;
   If InvProjectionRec.NonSh<0 then InvProjectionRec.NonSh:=0;
   If InvProjectionRec.SemiSh<0 then InvProjectionRec.SemiSh:=0;
   If InvProjectionRec.Other<0 then InvProjectionRec.Other:=0;
  end;

end;


Function AfterTaxReturn(BeforeTaxReturn:Real;MarginalRate:Real):Real;
begin
  result := BeforeTaxReturn * (100-MarginalRate)/100;
end;

procedure ChartShortFall(RetNo: Integer; DesiredIncome: Real;
  AvailableIncome: Real; TempCanvas: TBitMap; R: TRect);
Var
  Tot: Real;
  Chart1: TChart;
  R1: TRect;
  I, FNo: Integer;
  ThisSeries: TBarSeries;
  ShortFall: Real;
  F: TForm; //20160411 Igor
begin
  { Get data }
  ShortFall := AvailableIncome - DesiredIncome;
  { create chart }
  //20160411 Igor >>>
  F := TForm.Create(nil);
  F.Visible := False;
  Chart1 := TChart.Create(F);
  Chart1.Parent := F;
  //20160411 Igor <<<
  With Chart1 do
  begin
    Title.Font.color := clBlack;
    Title.Font.Size := 10;
    Title.Font.Style := [fsBold];
    Title.Text.clear;
    Title.Text.Add('Income Surplus/ShortFall at retirement');

    LeftAxis.Automatic := False;

    LeftAxis.Maximum := MaxR(MaxR(DesiredIncome, AvailableIncome),
      ABS(ShortFall));
    LeftAxis.Minimum := MinR(MinR(DesiredIncome, AvailableIncome), 0);
    Legend.Visible := False;
    AxisVisible := True;
    Gradient.Visible := True;
    Gradient.StartColor := $008080FF; { pinkish }
    Gradient.EndColor := clAqua;
  end;
  { add series }
  ThisSeries := TBarSeries.Create(Chart1);
  TeeEraseBack := False;
  Chart1.Addseries(ThisSeries);
  With ThisSeries do
  Begin
    Marks.Visible := False; { no yellow boxes on top of Bar }
    BarStyle := bsRectGradient; { Rectangle; }
    BarBrush.color := clRed;
  end;

  With ThisSeries do
  Begin
    clear;
    { apply data }

    Add(Round(AvailableIncome), 'Expected income', clBlue);
    Add(Round(DesiredIncome), 'Cost of living', clBlue);
    If ShortFall < 0 then
      Add(Round(ABS(ShortFall)), 'Shortfall', clRed)
    else
      Add(Round(ABS(ShortFall)), 'Surplus', clBlue);
  end;
  Chart1.Draw(TempCanvas.Canvas, R);
  Chart1.Parent := MainFormFP;
  Chart1.SaveToBitMapFile(Appdir + '\' + 'tempbmp.bmp');
  // control has no parent, abends
  ThisSeries.free;
  Chart1.free;
  F.Free; //20160411 Igor
end;


procedure ChartInvestmentsMix(RetNo: Integer; TempCanvas: TBitMap; R: TRect;
  Titl: string; NonSh, Shelt, SemSh, Other: Real);
Var
  Tot: Real;
  Chart1: TChart;
  R1: TRect;
  I, FNo: Integer;
  ThisSeries: TPieSeries;
  F: TForm; //20160411 Igor
begin
  { Get data }

  { create chart }
  //20160411 Igor >>>
  F := TForm.Create(nil);
  F.Visible := False;
  Chart1 := TChart.Create(F);
  Chart1.Parent := F;
  //20160411 Igor <<<
  With Chart1 do
  begin
    Title.Font.color := clBlack;
    Title.Font.Size := 10;
    Title.Font.Style := [fsBold];
    Title.Text.clear;
    Title.Text.Add(Titl);

    LeftAxis.Automatic := False;

    Legend.Visible := False;
    AxisVisible := True;
    Gradient.Visible := True;
    Gradient.StartColor := $008080FF; { pinkish }
    Gradient.EndColor := clAqua;
  end;
  { add series }
  ThisSeries := TPieSeries.Create(Chart1);
  TeeEraseBack := False;
  Chart1.Addseries(ThisSeries);
  With ThisSeries do
  Begin
    Marks.Visible := True; { no yellow boxes on top of Bar }
    Marks.Style := smsLabelPercent;
  end;

  With ThisSeries do
  Begin
    clear;
    { apply data }
    Add(Round(NonSh), 'Non-Sheltered', clBlue);
    Add(Round(Shelt), 'Sheltered', clRed);
    Add(Round(SemSh), 'Semi-Sheltered', clYellow);
    Add(Round(Other), 'Other', clGreen);
  end;
  {
    ChangeRect(R,R1);
    Chart1.Draw(TempCanvas.Canvas,R1); }
  Chart1.Draw(TempCanvas.Canvas, R);
  ThisSeries.free;
  Chart1.free;
  F.Free; //20160411 Igor
end;



Function GetInitialNonSh(RetNo:Integer):Real;
begin
 result :=  Vl(FetchElm(RetNo,'NETWORTH',41))+Vl(FetchElm(RetNo,'NETWORTH',42));
end;

Function GetInitialShelt(RetNo:Integer):Real;
begin
 result:= Vl(FetchElm(RetNo,'NETWORTH',43));
end;

Function GetInitialSemSh(RetNo:Integer):Real;
begin
  result := Vl(FetchElm(RetNo,'NETWORTH',44));
end;

Function GetInitialOther(RetNo:Integer):Real;
begin
  result:= Vl(FetchElm(RetNo,'NETWORTH',91)); //business etc//Vl(FetchElm(RetNo,'NETWORTH',49));
end;

Function GetMaxSheltPercent(RetNo:Integer;RRSPRoom,DispIncome:Real):real;
Var x:real;
begin
 If DispIncome <=0 then begin result:=0;exit;end;
 x:= MinR(RRSPRoom,DispIncome);
 result := (x/DispIncome)*100;
end;

Function DeriveNonShPercent(RetNo:Integer;SheltPercent,SemShPercent,OtherPercent:Real):Real;
begin
  Result := 100 - SheltPercent-SemShPercent-OtherPercent;
end;

Function GetMaxSheltRefundPercent(RetNo:Integer;RRSPRoom,DispIncome,TaxRefund,Preallocated:Real):real;
Var x:real;
begin
 If TaxRefund <=0 then begin result:=0;exit;end;
 x:= MaxR(0,RRSPRoom-Preallocated);
 x:= MinR(x,TaxRefund);
{ x:= MinR(TaxRefund,GetMaxSheltPercent(RetNo,RRSPRoom,DispIncome)-PreAllocated);}
 result := (x/TaxRefund)*100;
end;


Function DeriveNonShRefundPercent(RetNo:Integer;
   SheltRefundPercent,SemShRefundPercent,OtherRefundPercent:Real):Real;
begin
  Result := 100 - SheltRefundPercent-SemShRefundPercent-OtherRefundPercent;
end;

Function AnnuityPv(A:Real;Interest:real;n:integer):Real;
//a=amount to be invested at end of first period
// PV =A* (1-(1/(1+i) raised to n)/i
//a:=Annuity amount, i:Interest, n=period
//it gives the PV at period n
begin
  If interest=0 then begin result:=A *n;exit;end;
  interest:=interest/100;

  result := A * (1-1/(XtoY(1+interest,n)))/interest;     //works
  //Result:=A * AnnuityFactor(Interest,n);
end;

Function AnnuityFV(Amount:Real;Interest:real;n:integer):Real;
begin
  If interest=0 then begin result:=Amount *n;exit;end;
  interest:=interest/100;
  result :=Amount * ((XtoY(1+interest,n)-1)/interest);
end;

Function AnnuityWithDrawal(TotalAmount:Real;Interest:real;n:integer):Real;
//Total amount is what is available at beginning (it is the pv)
Var AnnuityFactor:double;
begin
  If interest=0 then
   begin
    If n>0 then result:=TotalAmount/n else result:=0;
    exit;
   end;  //??
  AnnuityFactor := AnnuityPv(1,Interest,n);  //for $1 before interest is divided!
  interest:=interest/100;
  // use PV = PeriodAmount * Annuity factor
   If AnnuityFactor>0 then
    Result:= TotalAmount/AnnuityFactor
  else
    result:=0;
end;

Function AnnuityPerPeriod(Amount:Real;Interest:real;n:integer):Real;
begin
  If n=0 then begin result:=0;exit;end;
  If interest=0 then
   begin
    If n>0 then  result:=Amount/n else result :=0;
    exit;
  end;
  interest:=interest/100;
  Result:= Amount/((XtoY(1+interest,n)-1)/interest);
end;

Function AnnuityFVOfDollar(Interest:real;n:integer):Real;
//  AnnuityFV = ((1+interest) raised to years)-1) /i
begin
  //result := XtoY(1+interest,n);
  If interest=0 then begin result:=0;exit;end;
  interest:=interest/100;
  result := (XtoY(1+interest,n)-1)/interest;
end;


Function XToY(x,y:Double): Double;
begin
 Result := System.Exp(y * Ln(x));
end;

Function GetIncShortFall(RetNo:Integer):Real;
begin
 If Vl(FetchElm(RetNo,'ANNINC',14)) <0 then
       result := ABS(Vl(FetchElm(RetNo,'ANNINC',14)))
    else
       result :=0;
end;


Function GetEndBalanceByAge(RetNo:Integer;Age:Integer;ThisStream:String):Real;
{good routine but not used}
Var i:Integer;StreamId:Integer;
begin
 StreamId := GetStreamId(ThisStream);
 result :=0;
 For i:=0 to RetirementParms.NumbPeriods do //BalanceList.Count-1 do
 begin
  BalanceRec := TBalanceRec(BalanceList.Items[i]);
  If BalanceRec.Age[0] = Age then
  begin result := BalanceRec.EndBalance[StreamId]; break;Exit;end;
 end;
end;

Function GetTotalEndBalanceByYear(RetNo:Integer;Year:String):Real;
{good routine but not used}
Var i,IYear:Integer;
begin
 result :=0;
 IYear:=MyStrToInt(Year);
 For i:=0 to RetirementParms.NumbPeriods do //TotInvestmProjectionList.Count-1 do
 begin
  TotInvestmProjectionRec := TotInvestmProjectionList.Items[i];
  If TotInvestmProjectionRec.Year = iYear then
  begin result := TotInvestmProjectionRec.TotEndBalance; break;Exit;end;
 end;
end;

Function GetRetirementAfterTaxIncome(RetNo:integer):Real;
begin
  Result := Vl(FetchElm(RetNo,'ANNINC',108)) *
    BeforeToAfterTaxRate(Vl(FetchElm(RetNo,'ANNINC',5)),
                         Vl(FetchElm(RetNo,'ANNINC',118)));
end;

Function GetDesiredRetirementIncome(RetNo:integer):Real;
begin
 Result := Vl(FetchElm(RetNo,'LIVINGEXP_2',122));
end;

Function GetNewRifRate(Age:Integer):Real;
begin
 If (Age >93) then begin result := 20;exit;end;
 If (Age <71)  then begin result := (1/(90-Age))*100;exit;end;

 Case age of
 // 69: result := 4.76;
 // 70: result := 5.00;
  71: result := 7.38;
  72: result := 7.48;
  73: result := 7.59;
  74: result := 7.71;
  75: result := 7.85;
  76: result := 7.99;
  77: result := 8.15;
  78: result := 8.33;
  79: result := 8.53;

  80: result := 8.75;
  81: result := 8.99;
  82: result := 9.27;
  83: result := 9.58;
  84: result := 9.93;
  85: result := 10.33;
  86: result := 10.79;
  87: result := 11.33;
  88: result := 11.96;
  89: result := 12.71;
  90: result := 13.62;
  91: result := 14.73;
  92: result := 16.12;
  93: result := 17.92;
 end;
end;

Function GetOldRifRate(Age:Integer):Real;
begin
 If (Age >93) then begin result := 20;exit;end;
 If (Age <71)  then begin result := (1/(90-Age)) * 100;exit;end;
  //up to 77 use the old rules, then switching to new rates
 Case age of
  //69: result := 4.76;
  //70: result := 5.00;
  71: result := 5.26;
  72: result := 5.56;
  73: result := 5.88;
  74: result := 6.25;
  75: result := 6.67;
  76: result := 7.14;
  77: result := 7.69;
  78: result := 8.33;

  79: result := 8.53;
  80: result := 8.75;
  81: result := 8.99;
  82: result := 9.27;
  83: result := 9.58;
  84: result := 9.93;
  85: result := 10.33;
  86: result := 10.79;
  87: result := 11.33;
  88: result := 11.96;
  89: result := 12.71;

  90: result := 13.62;
  91: result := 14.73;
  92: result := 16.12;
  93: result := 17.92;
 end;
end;

Function GetPlanStartAge(RetNo:Integer):Integer;
Begin
Result := CalcAgeTo(YYYYMMDDToDDMMYYYY(ClientBirthDate(RetNo)),'31-12-'+IntToStr(RetirementParms.StartYear));
end;

Function GetSpousePlanStartAge(RetNo:Integer):Integer;
Begin
 If Ret[RetNo].MarStatus >2 then
  result:=GetPlanStartAge(RetNo)
 else
  Result := CalcAgeTo(YYYYMMDDToDDMMYYYY(SpouseBirthDate(RetNo)),'31-12-'+IntToStr(RetirementParms.StartYear));
end;


Function ClientAgeToYear(RetNo,SomeAge:Integer):Integer;
Var CurrentAge:Integer;
begin
 CurrentAge := ClientAge(RetNo);
 If SomeAge<CurrentAge then SomeAge:=CurrentAge;
 Result := StrToInt(GetCurYear)+SomeAge-CurrentAge;
end;

Function SomeAgeToYear(SomeAge:Integer;CurrentAge:Integer):Integer;
begin
 //If SomeAge<CurrentAge then SomeAge:=CurrentAge;
 Result :=StrToInt(GetCurYear)+SomeAge-CurrentAge;
end;


Function ExtractNonExtensionFileName(FlName:String):string;
Var i:Integer;
begin
 i := 1;
 while (i <= Length(FlName)) and not (FlName[i] ='.') do inc(i);
 Result := copy(FlName,1,i-1);
end;


Function AnnualizeReturn(OpeningBalance,FutValue:Real;Years:Integer):Real;
{Get annual Interest}
begin
 result :=0;
 { XtoY(1+Interest,Years):=FutValue/OpeningBalance;}
end;

Function ClientForCaption(RetNo:integer):string;
begin
 result := ' - '+ GetFirstName(RetNo)+' '+GetLastName(RetNo);
end;

Function GetPortFlLabel(ndx:integer):string;
begin
 If ndx =0 then
   result := 'Semi-sheltered'
 else
   result := 'Sheltered';
end;

Function ClientFileName(RetNo:Integer):string;
begin
result := LeftStr(GetSinNo(RetNo),8)+'.'+RightStr(GetSinNo(RetNo),1);
end;


procedure ChartPortfolioMix(MixArray:Array of Real;ProposedOrCurrent:string;TempCanvas:TBitMap;R:TRect);
Var Tot:Real; Chart1 : TChart; R1:TRect;
 i:Integer;ThisSeries :TPieSeries;
{ MinBal,MaxBal:Real;}
 begin
end;


Function PrvLongToShort(PrvNm:String):String;
Var i:Integer;
begin
 result :='';
 For i:=1 to 13 do
 begin
   If UpperCase(PrvNm) = UpperCase(PrvLong[i]) then begin result := UpperCase(PrvShort[i]);exit;end;
 end;
end;

procedure ShowBDEError(AExc: EDataBaseError);
  var
    i: Integer;
    Memo1 :TMemo;
  begin
    Memo1:=TMemo.Create(application);
    Memo1.Lines.Clear;
    Memo1.Lines.Add('Errors: ' + AExc.Message);

    (*20150923 Igor
    Memo1.Lines.Add('Number of errors: ' + IntToStr(AExc.ErrorCount));
    Memo1.Lines.Add('');
    {Iterate through the Errors records}
    for i := 0 to AExc.ErrorCount - 1 do begin
      Memo1.Lines.Add('Message: ' + AExc.Errors[i].Message);
      Memo1.Lines.Add('   Category: ' +
        IntToStr(AExc.Errors[i].Category));
      Memo1.Lines.Add('   Error Code: ' +
        IntToStr(AExc.Errors[i].ErrorCode));
      Memo1.Lines.Add('   SubCode: ' +
        IntToStr(AExc.Errors[i].SubCode));
      Memo1.Lines.Add('   Native Error: ' +
        IntToStr(AExc.Errors[i].NativeError));
      Memo1.Lines.Add('');
    end;
    *)
    for i := 0 to Memo1.Lines.Count - 1 do
      ShowMessage(Memo1.Lines[i]);
    Memo1.free;
  end;

function EncryptIt(const S: String; Key: Word): String;
var  I: byte;
begin
  Result := S; exit;
end;

function DecryptIt(const S: String; Key: Word): String;
const  C1 = 52845;  C2 = 22719;
var  I: byte;
begin
  Result := S; exit;
end;

Function GetLanguageCode(RetNo:Integer):String;
begin
 {If FetchElm(RetNo,'PROFILE',15)}
 Result := 'E';
end;

Function GetRecipientCode(RetNo:Integer;FNo:Integer):String;
begin
 If FetchElmFNo(RetNo,FNo,6) >'' then
   Result := '1' {individual}
 else If FetchElmFNo(RetNo,FNo,7) >'' then
   Result := '2' {Joint}
end;

Function GetJointType(RetNo:Integer;FNo:Integer):String;
begin
 If FetchElmFNo(RetNo,FNo,39) >'' then
   Result := 'J'
 else If FetchElmFNo(RetNo,FNo,40) >'' then
   Result := 'T' {Tenant in common}
end;

Function GetSpousalFlag(RetNo:Integer;FNo:Integer):String;
begin
 If FetchElmFNo(RetNo,FNo,10) >'' then
   Result := '1'
 else result := '';
end;

Function GetTitleCode(RetNo:Integer;FNo:Integer):String;
Var s:string; //[10];
begin
 s:=UpperCase(FetchElmFNo(RetNo,FNo,17));
 If s = 'MR' then result := '1'
 else if s = 'MRS' then result := '2'
 else if s = 'MISS' then result :='3'
 else if s = 'MS' then result :='4'
 else if s = 'DR' then result :='5'
 else if s = 'PROF' then result :='6';
 {
 7	Concatenate First & Last Name fields
 #
 }
end;

Function GetTitleDescr(TitleCode:String):String;
Var s:string; //[10];
begin
 Result :='';
 If      TitleCode = '1' then result := 'Mr'
 else If TitleCode = '2' then result := 'Mrs'
 else If TitleCode = '3' then result := 'Miss'
 else If TitleCode = '4' then result := 'Ms'
 else If TitleCode = '5' then result := 'Dr'
 else If TitleCode = '6' then result := 'Prof';
end;


Function GetBeneficiaryRelation(RetNo:Integer;FNo:Integer):String;
begin
 If FetchElmFNo(RetNo,FNo,26) >'' then result := '01'
 else result := '99';  {need more?}
end;

Function CountDetailRecs(RetNo:Integer;FNo:Integer):Integer;
begin
 result := 1; {?}
end;

//procedure ExecuteForm(AFormClass: TFormClass);
//begin
//   with AFormClass.create(Application) do
//   begin
//      Screen.cursor:= crDefault;
//      ShowModal;
//      Free;
//      {if modeless
//      Screen.cursor:= crDefault;
//      Show;
//      }
//   end;
//end;

Function GetClientHeader(RetNo:Integer):String;
begin
result :=AllTrim(GetLastName(RetNo))+','+
    AllTrim(GetFirstName(RetNo))+' ('+GetSinno(RetNo)+')';
    //+' - '+ Ret[RetNo].FileNm;
end;

procedure PopulateAccountTypesCombo(ACombo:TDBComboBox);
Var i:Integer;
begin
 For i := Low(AccountTypes) to High(AccountTypes) do
  ACombo.items.Add(AccountTypes[i]);
end;

procedure PopulateTransactionStatusCombo(ACombo:TDBComboBox);
Var i:Integer;
begin
 For i := Low(TransactionStatus) to High(TransactionStatus) do
  ACombo.items.Add(TransactionStatus[i]);
end;




Procedure ParseWords(S:AnsiString;Delim:String;WList:Tstrings);
Var i,FromI,ToI:Integer;Wrd:String;
begin
 s:=AllTrim(S);
 Wlist.Clear;
 If s ='' then exit;
 i:=1;
 FromI:=1;
 ToI:=Length(s);
 Repeat
    If (i>ToI) or (S[i] = Delim) then
    begin
       Wrd := MidStr(S,FromI,i-FromI);
       WList.Add(Wrd);
       FromI:=i+1;
       Inc(i);
       If (FromI>ToI) or (i>ToI) then break;
    end
    else
     Inc(i);
 until i>ToI+1;
end;


Function MakeTempAccount(FundCo:String):String;
begin
 result := 'NEW'+'-'+'xxxx';
end;


Function GetLastTransactionNo(AgentCode:String):Integer;
//Var Table1 : TAdoTable;
begin
end;

Function SaveLastTransactionNo(AgentCode:String;TransactionNo:Integer):Boolean;
//Var Table1 : TAdoTable;
begin
end;

Function MakeTransactionId(Branch,AgentCode:String;TransactionNo:Integer):String;
begin
 Result:= Branch+'-'+AgentCode+'-'+IntToStr(TransactionNo);
end;

Procedure SummarizeAssets (RetNo:Integer);
Var i,j:Integer;ClPercent,SpPercent:Real;
{Summarize current value and annualyield by AssetType and Portfolio type}
begin
  AssetSumList.Clear;  {initialize counters by Asset}
  With AssetsSumRec do
  begin
   //client
   CashTotalValueCl:=TotMultiple(RetNo,'CASH',271);
   NonShTotalValueCl:=
      TotMultiple(RetNo,'GIC',451)
     +TotMultiple(RetNo,'BONDS',451)
     +TotMultiple(RetNo,'CSB',451)
     +TotMultiple(RetNo,'LOANS',307)
     +TotMultiple(RetNo,'TERMDEP',421)
     +TotMultiple(RetNo,'MUTFUNDS',511)
     +TotMultiple(RetNo,'STOCKS',511)
     +TotMultiple(RetNo,'DEFPLANS',511);
   SheltTotalValueCl:=
      TotMultiple(RetNo,'GIC',454)
     +TotMultiple(RetNo,'BONDS',454)
     +TotMultiple(RetNo,'CSB',454)
     +TotMultiple(RetNo,'LOANS',316)
     +TotMultiple(RetNo,'TERMDEP',424)
     +TotMultiple(RetNo,'MUTFUNDS',512)
     +TotMultiple(RetNo,'STOCKS',512)
     +TotMultiple(RetNo,'DEFPLANS',512);
   SemShTotalValueCl:=
      TotMultiple(RetNo,'MUTFUNDS',513)
     +TotMultiple(RetNo,'STOCKS',513)
     +TotMultiple(RetNo,'DEFPLANS',513);

   HomesTotalValueCl:=TotMultiple(RetNo,'REALEST',235);
   VacPropTotalValueCl:=TotMultiple(RetNo,'REALEST',238);
   InvestPropTotalValueCl:=TotMultiple(RetNo,'REALEST',241);
   OthFixedTotalValueCl:=TotMultiple(RetNo,'OTHFIXED',271);
   AutosTotalValueCl:=TotMultiple(RetNo,'AUTOS',217);
   BusinessNonIncTotalValueCl:=TotMultiple(RetNo,'BUSINESS',208);
   BusinessIncTotalValueCl:=TotMultiple(RetNo,'BUSINESS',217);
   OthAssetsTotalValueCl:=TotMultiple(RetNo,'OTHASSETS',271);
   //spouse
   CashTotalValueSp:=TotMultiple(RetNo,'CASH',274);
   NonShTotalValueSP:=
      TotMultiple(RetNo,'GIC',460)
     +TotMultiple(RetNo,'BONDS',460)
     +TotMultiple(RetNo,'CSB',460)
     +TotMultiple(RetNo,'LOANS',310)
     +TotMultiple(RetNo,'TERMDEP',430)
     +TotMultiple(RetNo,'MUTFUNDS',526)
     +TotMultiple(RetNo,'STOCKS',526)
     +TotMultiple(RetNo,'DEFPLANS',526);
   SheltTotalValueSP:=
      TotMultiple(RetNo,'GIC',463)
     +TotMultiple(RetNo,'BONDS',463)
     +TotMultiple(RetNo,'CSB',463)
     +TotMultiple(RetNo,'LOANS',313)
     +TotMultiple(RetNo,'TERMDEP',433)
     +TotMultiple(RetNo,'MUTFUNDS',527)
     +TotMultiple(RetNo,'STOCKS',527)
     +TotMultiple(RetNo,'DEFPLANS',527);
   SemShTotalValueSP:=
      TotMultiple(RetNo,'MUTFUNDS',528)
     +TotMultiple(RetNo,'STOCKS',528)
     +TotMultiple(RetNo,'DEFPLANS',528);

   HomesTotalValueSP:=TotMultiple(RetNo,'REALEST',247);
   VacPropTotalValueSP:=TotMultiple(RetNo,'REALEST',250);
   InvestPropTotalValueSP:=TotMultiple(RetNo,'REALEST',253);
   OthFixedTotalValueSP:=TotMultiple(RetNo,'OTHFIXED',274);
   AutosTotalValueSP:=TotMultiple(RetNo,'AUTOS',218);
   BusinessNonIncTotalValueSP:=TotMultiple(RetNo,'BUSINESS',211);
   BusinessIncTotalValueSP:=TotMultiple(RetNo,'BUSINESS',220);
   OthAssetsTotalValueSP:=TotMultiple(RetNo,'OTHASSETS',274);

  end;

  AssetSumRec := TAssetSumRec.Create;
  //AssetSumRec.AssetType := AllTrim(Tbl.FieldByName('AssetType').AsString);
  AssetSumRec.TotalValue := 0;
  AssetSumRec.TotalYield   := 0;
  AssetSumRec.YieldPercent := 0;
  AssetSumList.Add(AssetSumRec);

  //GetLifeInsuranceData(FileNm);
  Calc(RetNo,'NETWORTH');
end;

Procedure SummarizeLiabilities (RetNo:Integer);
Var i,j:Integer;ClPercent,SpPercent:Real;
begin
 With LiabilitySumRec do
 begin
  BankAdvancesCl:=TotMultiple(RetNo,'BANKADV',161);
  BankAdvancesSP:=TotMultiple(RetNo,'BANKADV',164);

  AccountsPayableCl:=TotMultiple(RetNo,'CREDITCARDS',225)
                   + TotMultiple(RetNo,'UNPAIDBILLS',211)
                   + TotMultiple(RetNo,'TAXPAYABLE',181);
  AccountsPayableSp:=TotMultiple(RetNo,'CREDITCARDS',227)
                   + TotMultiple(RetNo,'UNPAIDBILLS',212)
                   + TotMultiple(RetNo,'TAXPAYABLE',183);

  HomeMortgageCL:=TotMultiple(RetNo,'MORTGAGES',265);
  HomeMortgageSp:=TotMultiple(RetNo,'MORTGAGES',273);

  VacPropMortgageCL:=TotMultiple(RetNo,'MORTGAGES',266);
  VacPropMortgageSP:=TotMultiple(RetNo,'MORTGAGES',274);
  InvestPropMortgageCL:=TotMultiple(RetNo,'MORTGAGES',267);
  InvestPropMortgageSP:=TotMultiple(RetNo,'MORTGAGES',275);

  OtherLtlCL:=TotMultiple(RetNo,'CARLOANS',361)+ TotMultiple(RetNo,'OTHERLTL',331);
  OtherLtlSP:=TotMultiple(RetNo,'CARLOANS',363)+ TotMultiple(RetNo,'OTHERLTL',332);

  LongTermMonthlyCl:=TotMultiple(RetNo,'MORTGAGES',272)
                   +TotMultiple(RetNo,'CARLOANS',362)
                   +TotMultiple(RetNo,'OTHERLTL',333);
  LongTermMonthlySP:=TotMultiple(RetNo,'MORTGAGES',280)
                   +TotMultiple(RetNo,'CARLOANS',364)
                   +TotMultiple(RetNo,'OTHERLTL',334);
 end;
end;

Procedure SummarizeLifeIns(RetNo:Integer);
Var i,j:Integer;ClPercent,SpPercent:Real;
begin
  With LifeInsuranceRec do
  begin
   CashSurrenderValue:=TotMultiple(RetNo,'LIFEINS',172);
   AnnualPremium:=TotMultiple(RetNo,'LIFEINS',173);
   SelfCoverage:=TotMultiple(RetNo,'LIFEINS',174);
   SpouseCoverage:=TotMultiple(RetNo,'LIFEINS',175);
  end;
  //GetLifeInsuranceData(FileNm);
  Calc(RetNo,'NETWORTH');
end;

Procedure GetChartColors(Var ChartColor:Array of TColor);
Var i:Integer;
begin
For i:= Low(ChartColor) to High(ChartColor) do ChartColor[i] := clSilver;
 ChartColor[0]:= clGreen;
 ChartColor[1]:= $00C5EEFE;  {haki}
 ChartColor[2]:= clAqua;
 ChartColor[3]:= clBlue;
 ChartColor[4]:= clRed;
 ChartColor[5]:= clOlive;
 ChartColor[6]:= clNavy;
 ChartColor[7]:= clPurple;
 ChartColor[8]:= clBlack;
 ChartColor[9]:= clWhite;
 ChartColor[10]:= clMaroon;
 ChartColor[11]:= clTeal;
 ChartColor[12]:= clLime;
 ChartColor[13]:= clFuchsia;
 ChartColor[14]:= clAqua;
 ChartColor[15]:= clYellow;
 ChartColor[16]:= $00F7FFFF; {Light haki}
 ChartColor[17]:= $00FFFFE1;  {Light blue}
 ChartColor[18]:= $00DFFFFF;  {Light yellow}
 ChartColor[19]:= $00E6E6E6; {Light grey}
 ChartColor[20]:= $000080FF;  {Orange}
end;


Procedure SummarizeProposedAssets(FileNm:String);
Var i,j:Integer;WhereClause:String;
begin
(*
*)
end;

Function GetCheck1(Pgm:String;VersionNum:Integer):String;
begin
 result :='0';
 If Pgm = 'FP' then result:=IntToStr(VersionNum*2+1);
end;

Function GetCheck2(Pgm:String;VersionNum:Integer):String;
begin
 Result :='0';
 If Pgm = 'FP' then result:= IntToStr(VersionNum+4);
end;

Procedure SavingsCalc(OpeningBalance,Amount,Interest,TaxRate,Inflation:Real;Years:Integer;
    Var PeriodInterestArray:Array of Real;Var PeriodBalanceArray:Array of Real;InvestTime:String);
Var i:Integer;EffectiveInterest:Real;
{RunningBalance,PeriodInterest,PeriodBalance:Real;}
begin
 {dynamic arrays are zero based}
 EffectiveInterest := Interest * (1-TaxRate);
 For i:=0 to Years-1 do
 begin
  PeriodInterestArray[i] :=0;
  PeriodBalanceArray[i] :=0;
 end;
 {init first period}
 If InvestTime='B' then
  PeriodInterestArray[0] :=(OpeningBalance+Amount)*EffectiveInterest
 else If InvestTime='M' then
  PeriodInterestArray[0] :=(OpeningBalance+Amount/2)*EffectiveInterest
 else If InvestTime='E' then
  PeriodInterestArray[0] :=(OpeningBalance)*EffectiveInterest;
 PeriodBalanceArray[0] :=OpeningBalance+Amount+PeriodInterestArray[0];

 For i:=1 to years-1 do
 begin
  If InvestTime='B' then
   PeriodInterestArray[i] := (PeriodBalanceArray[i-1]+Amount) * EffectiveInterest
  else If InvestTime='M' then
   PeriodInterestArray[i] := (PeriodBalanceArray[i-1]+Amount/2) * EffectiveInterest
  else If InvestTime='E' then
   PeriodInterestArray[i] := (PeriodBalanceArray[i-1]) * EffectiveInterest;

  PeriodBalanceArray[i] :=  PeriodBalanceArray[i-1]
                            +Amount
                            +PeriodInterestArray[i];
 end;

end;

Function GetClientLettersDir:String;
Var Dir:String;
begin
  Dir := AppDir+'\'+'ClientLetters';
  If Not DirectoryExists(Dir) then
   if not DirectoryExists(Dir) then
   begin
    if not CreateDir(Dir) then
      raise Exception.Create('Cannot create letters directory '+Dir);
   end;
  Result := Dir;
end;

Function MkClientLetterName(RetNo:Integer):String;
begin
 Result :=GetLastName(RetNo)+'-'+LeftStr(GetFirstName(RetNo),1)+'.'+'RTF';
end;


Function GetPositionInList(s:String;AlistBox:TFileListBox):Integer;
{return item index of a given string}
Var i:Integer;
begin
 result :=-1;
 For i:=0 to AlistBox.Items.count-1 do
 If s = AlistBox.Items[i] then
 begin
   result := i;
   exit;
 end;
end;

Function EmptyATable(Table1:TDataSet):Boolean;
begin
 with Table1 do
 begin
  try
   Close;
   //Exclusive := True;
   Open;
   //EmptyTable;
   Close;
   //Exclusive := False;
   Open;
   Result := True;
  except
   Close;
   Open;
   Result := False;
   Exit;
  end;
 end;
end;

Function HOSetUpOk:Boolean;
begin
 Result := True;
 If (Length(AllTrim(HoRec.DealerCode)) <4)
  or (Length(AllTrim(HoRec.FsInDir))<3)
  or (Length(AllTrim(HoRec.FsInArchive))<3)
  or (Length(AllTrim(HoRec.FsOutDir))<3)
  or (Length(AllTrim(HoRec.FsOutArchive))<3) then
  result := False;
end;

Function CheckDir(DirName:String):Boolean;
begin
 if DirectoryExists(DirName) then begin result:=True;exit;end;
  {Does Not exist}
   if MessageDlg('Directory: '+ DirName +
     ' does not exist. Create?',
      mtInformation, [mbYes, mbNo], 0) = mrYes then
    begin {replied mrYes to create}
        {$I-}   {so that the ioresult can be effective}
        MkDir(DirName);
        if IOResult = 0 then
           begin
            MessageDlg('Directory: '+ DirName + ' created', mtInformation, [mbOk], 0);
            result := True;
            exit;
           end
        else
           begin
             MessageDlg('Directory: '+ DirName +
              chr(13)+' cannot be created', mtInformation, [mbOk], 0);
             Result := False;
             exit;
           end;
    end
    else  {replied mrNo}
       begin result := False; exit; end;
end;

Function DebtPayment(Princ,Int,Term:Double):Double;
Var Temp:Double;
begin
 int:=Int/100;
 Temp:=exp(ln(int+1) * term);
 result := princ * ((int * temp)/(temp-1));
end;


procedure PrintAChart(Chart1:TChart;Heading1:String);
var h,w,x,y:longint;
begin
  Screen.Cursor := crHourGlass; { <-- nice detail }
  try
    Printer.BeginDoc;       { <-- start printer job }
    h:=Printer.PageHeight; { <-- get page height }
    w:=Printer.PageWidth;  { <-- get page width }
    try
      { now print some text on printer.canvas }
      With Printer.Canvas do
      begin
        Font.Name:='Arial';
        Font.Size:=9;             { <-- set the font size }
        Font.Style:=[fsBold];
        TextOut(w div 3,h div 6,Heading1);   { <-- print some text }
        {TextOut(w div 3,40,'Heading2');}   { <-- print some text }
      end;


      { And now print the chart component... }
      Chart1.PrintPartial(Rect(w div 18,          { <-- left margin }
                               h div 4 ,          { <-- top margin }
                               w - (w div 18),    { <-- right margin }
                               h - (h div 3) )); { <-- bottom margin }

     (*
      { print more text.... }
      With Printer.Canvas do
      begin
        Font.Name:='Arial';
        Font.Size:=12;             { <-- set the font size }
        Font.Style:=[fsItalic];
        TextOut(0,60,'XXXXXXX');   { <-- print some text }
      end;
     *)
      Printer.EndDoc; { <-- end job and print !! }
    except
      on Exception do  { just in case an error happens... }
      Begin
        Printer.Abort;
        //Printer.EndDoc; //20160910 igor
        Raise;       { <-- raise up the exception !!! }
      end;
    end;
  finally
    Screen.Cursor:=crDefault; { <-- restore cursor }
  end;
end;

Function IsAgentVersion:Boolean;
begin
  Result := licenseLevel in [llAgStd,llAgPower];
end;

Function IsDealerVersion:Boolean;
begin
  Result := LicenseLevel = llDealer;
end;

Function IsPowerVersion:Boolean;
begin
  Result := LicenseLevel = llPower;
end;

Function IsStandardVersion:Boolean;
begin
  Result := LicenseLevel = llStd;
end;

Function IsDemoVersion:Boolean;
begin
 result:= LicenseLevel = llDemo;
end;

Function IsLimitedVersion:Boolean;
begin
 result:=LicenseLevel = llLimited;
end;

Function ValidDateYYYYMMDD(S:String;MxYear:integer):Boolean;
begin
  Result := EditDateYMD(s,1880,MxYear,'-');
end;

Function GetPricesAsOfDate:String;
Var aList:TStringList;
begin
 AList := TstringList.Create;
 AList.LoadFromFile(Appdir+'\'+'AsOfDate.d');
 if AList.Count = 0 then PricesAsOfDate:='0'  else PricesAsOfDate := AList[0]; //20150918 Igor
 Result :=PricesAsOfDate;
 AList.Free;
end;

Function FormatFsDate(Dt:String):String;
{in as YYYYMMDD out as YYYY-MM-dd}
begin
 Result := LeftStr(Dt,4)+'-'+MidStr(Dt,5,2)+'-'+RightStr(dt,2);
end;

Function DateWithSlashes(Dt:String):String;
{in as YYYYMMDD out as YYYY/MM/dd}
begin
 Result := LeftStr(Dt,4)+'/'+MidStr(Dt,5,2)+'/'+RightStr(dt,2);
end;

Function GetTransactionDescription(TypeSubType:String):String;
begin
 Result := '??????';
 If AllTrim(TypeSubType) = '1'  then result := 'Reinvested distribution/Interest'
 else If TypeSubType = '12' then result := 'Reinvested distribution Adjustment'
 else if AllTrim(TypeSubType) = '2'  then Result := 'Cash distribution/Interest'
 else if TypeSubType = '22' then Result := 'Cash distribution/Interest Adjustment'
 else if TypeSubType = '23' then Result :=  'Cash distribution/Redirection'
 else if AllTrim(TypeSubType) = '3'  then Result :=  'Cash dividend/Interest (bulk Cheque)'
 else if TypeSubType = '32' then Result :=  'Cash dividend/Interest Adjustment'
 else if AllTrim(TypeSubType) = '4'  then Result :=  'Fee'
 else if TypeSubType = '42' then Result :=  'Fee Adjustment'
 else if AllTrim(TypeSubType) = '5'  then Result :=  'Purchase'
 else if TypeSubType = '51' then Result :=  'Switch-in'
 else if TypeSubType = '52' then Result :=  'Purchase Adjustment'
 else if TypeSubType = '53' then Result :=  'Purchase from distribution redirection'
 else if TypeSubType = '54' then Result :=  'External Nominee Transfer-In'
 else if TypeSubType = '55' then Result :=  'Commission Rebate Purchase'
 else if TypeSubType = '56' then Result :=  'Purchase PAC'
 else if TypeSubType = '58' then Result :=  'Internal Nominee Transfer-In'
 else if AllTrim(TypeSubType) = '6'  then Result :=  'Redemption'
 else if TypeSubType = '61' then Result :=  'Switch-Out'
 else if TypeSubType = '62' then Result :=  'Redemption Adjustment'
 else if TypeSubType = '64' then Result :=  'External Nominee Transfer-Out'
 else if TypeSubType = '67' then Result :=  'AWD/SWD withdrawal plan'
 else if TypeSubType = '68' then Result :=  'Internal Nominee Transfer-Out'
 else if AllTrim(TypeSubType) = '7'  then Result :=  'Split/Consolidation'
 else if TypeSubType = '72' then Result :=  'Split Adjustment'
 else if TypeSubType = '81' then Result :=  'Switch'
 else if TypeSubType = '84' then Result :=  'External Nominee Transfer'
 else if TypeSubType = '88' then Result :=  'Internal Nominee Transfer'
 else if AllTrim(TypeSubType) = '9'  then Result :=  'Issue Certificate'
 else if AllTrim(TypeSubType) = '0'  then Result :=  'Certificate File'
 else if AllTrim(TypeSubType) = 'A'  then Result :=  'Average Cost-Fund Company'
end;


Function GetTransactionSign(GivenSign,TypeSubType:String):String;
begin
 Result := GivenSign;
 If AllTrim(TypeSubType) = '1'  then result := '+' {'Reinvested distribution/Interest'}
 else If TypeSubType = '12' then result := '+' {Reinvested distribution Adjustment'}
 else if AllTrim(TypeSubType) = '2'  then Result := '-' {'Cash distribution/Interest'}
 else if TypeSubType = '22' then Result := '-' {'Cash distribution/Interest Adjustment'}
 else if TypeSubType = '23' then Result :=  '-' {'Cash distribution/Redirection'}
 else if AllTrim(TypeSubType) = '3'  then Result := '-' { 'Cash dividend/Interest (bulk Cheque)'}
 else if TypeSubType = '32' then Result :=  '-' {'Cash dividend/Interest Adjustment'}
 else if AllTrim(TypeSubType) = '4'  then Result :=  '-' {'Fee'}
 else if TypeSubType = '42' then Result :=  GivenSign {fee Adjustment'}
 else if AllTrim(TypeSubType) = '5'  then Result := '+' { 'Purchase'}
 else if TypeSubType = '51' then Result :=  '+' {'Switch-in'}
 else if TypeSubType = '52' then Result :=  GivenSign {'Purchase Adjustment'}
 else if TypeSubType = '53' then Result :=  '+' {'Purchase from distribution redirection'}
 else if TypeSubType = '54' then Result :=  '+' {'External Nominee Transfer-In'}
 else if TypeSubType = '55' then Result :=  '+' {'Commission Rebate Purchase'}
 else if TypeSubType = '56' then Result :=  '+' {'Purchase PAC'}
 else if TypeSubType = '58' then Result :=  '+' {'Internal Nominee Transfer-In'}
 else if AllTrim(TypeSubType) = '6'  then Result :=  '-' {'Redemption'}
 else if TypeSubType = '61' then Result :=  '-' {'Switch-Out'}
 else if TypeSubType = '62' then Result :=  GivenSign {'Redemption Adjustment'}
 else if TypeSubType = '64' then Result :=  '-' {'External Nominee Transfer-Out'}
 else if TypeSubType = '67' then Result :=  '-' {'AWD/SWD withdrawal plan'}
 else if TypeSubType = '68' then Result :=  '-' {'Internal Nominee Transfer-Out'}
 else if AllTrim(TypeSubType) = '7'  then Result := GivenSign { 'Split/Consolidation'}
 else if TypeSubType = '72' then Result :=  GivenSign {'Split Adjustment'}
 else if TypeSubType = '81' then Result :=  GivenSign {'Switch'}
 else if TypeSubType = '84' then Result :=  GivenSign {'External Nominee Transfer'}
 else if TypeSubType = '88' then Result :=  GivenSign {'Internal Nominee Transfer'}
 else if AllTrim(TypeSubType) = '9'  then Result := GivenSign { 'Issue Certificate'}
 else if AllTrim(TypeSubType) = '0'  then Result := GivenSign {'Certificate File'}
 else if AllTrim(TypeSubType) = 'A'  then Result := GivenSign; {'Average Cost-Fund Company'}
end;


Function ConvertAccountTypeCodeToDescr(AccountType:String):String;
begin
  If      AccountType = '01' then result := 'OPEN'
  else If AccountType = '02' then result := 'RRSP'
  else If AccountType = '04' then result := 'RRIF'
  else If AccountType = '05' then result := 'RESP-IND'
  else If AccountType = '06' then result := 'RESP-FAM'
  else If AccountType = '07' then result := 'DPSP'
  else If AccountType = '08' then result := 'RHOSP'
  else If AccountType = '09' then result := 'OTHER'
  else If AccountType = '10' then result := 'LIF'
  else If AccountType = '11' then result := 'LIRA'
  else If AccountType = '12' then result := 'LRIF'
  else If AccountType = '13' then result := 'RRTF';
end;

Function ConvertAccountTypeDescrToCode(AccountTypeDescr:String):String;
begin
  Result :='??';
  AccountTypeDescr:= UpperCase(AccountTypeDescr);
  If      AccountTypeDescr = 'OPEN' then result := '01'
  else If AccountTypeDescr = 'RRSP' then result := '02'
  else If AccountTypeDescr = 'RRIF' then result := '04'
  else If AccountTypeDescr = 'RESP-IND' then result := '05'
  else If AccountTypeDescr = 'RESP-FAM' then result := '06'
  else If AccountTypeDescr = 'DPSP' then result := '07'
  else If AccountTypeDescr = 'RHOSP' then result := '08'
  else If AccountTypeDescr = 'OTHER' then result := '09'
  else If AccountTypeDescr = 'LIF' then result := '10'
  else If AccountTypeDescr = 'LIRA' then result := '11'
  else If AccountTypeDescr = 'LRIF' then result := '12';
end;



Procedure ConnectToFundServ(FrmHandle:THandle);
Var h : THandle;
 ConnectPgm:String;
 NullString: array[0..79] of Char;
begin
  ConnectPgm := HoRec.FsCommunicationProgram;
  StrPCopy(NullString, ConnectPgm);
  h := ShellExecute(FrmHandle, Nil, NullString, Nil, Nil, SW_RESTORE);
  If H<=32 then
  Begin
   ShowMessage('Program cannot execute. Error Code = '+IntToStr(h));
   SomeCaption := 'Error codes';
   PopSomeFile(AppDir+'\'+'SHELLERR.D',SomeCaption);
  end;
end;

Function ConvertFSMonthCode(MonthCode:String):String;
begin
 MonthCode := UpperCase(MonthCode);
 If      MonthCode = 'A' then result := 'January'
 else If MonthCode = 'B' then result := 'February'
 else If MonthCode = 'C' then result := 'March'
 else If MonthCode = 'D' then result := 'April'
 else If MonthCode = 'E' then result := 'May'
 else If MonthCode = 'F' then result := 'June'
 else If MonthCode = 'G' then result := 'July'
 else If MonthCode = 'H' then result := 'August'
 else If MonthCode = 'I' then result := 'September'
 else If MonthCode = 'J' then result := 'October'
 else If MonthCode = 'K' then result := 'November'
 else If MonthCode = 'L' then result := 'December'

 else If MonthCode = 'M' then result := '(Test) Jan'
 else If MonthCode = 'N' then result := '(Test) Feb'
 else If MonthCode = 'O' then result := '(Test) Mar'
 else If MonthCode = 'P' then result := '(Test) Apr'
 else If MonthCode = 'Q' then result := '(Test) May'
 else If MonthCode = 'R' then result := '(Test) Jun'
 else If MonthCode = 'S' then result := '(Test) Jul'
 else If MonthCode = 'T' then result := '(Test) Aug'
 else If MonthCode = 'U' then result := '(Test) Sep'
 else If MonthCode = 'V' then result := '(Test) Oct'
 else If MonthCode = 'W' then result := '(Test) Nov'
 else If MonthCode = 'Z' then result := '(Test) Dec'
 else result := '??????';
end;

Function BackUpFpClients:Boolean;
Var FlName,DestinFile:String;DefaultFile:String;
begin
 FlName:='FPBACKUP_'+RemoveChar(FormatDateTime('yyyy-mm-dd',Now),'-')
 +'.MDB';
 DefaultFile := 'F:\'+FlName;
 DestinFile:= InputBox('FP Data Base Back-up',
  'Enter destination file', DefaultFile);
 If FileExists(DestinFile) then
 begin
  showMessage('This file name already exists');
  exit;
 end;

 If Not DirectoryExists(ExtractFileDir(DestinFile)) then
 begin
  ShowMessage('Invalid directory ' +ExtractFileDir(DestinFile));
  exit;
 end;
 {CopyFile(?, DestinFile);}
end;

Function ConvertDateToMDD(Dt:TDateTime):String;
{MDD  8.3 format}
Const ProductionMonths = 'ABCDEFGHIJKL';
Var YYYY,MM,DD:Word; M:string; //[1];
begin
  DecodeDate(Dt,YYYY,MM,DD);
  m:=ProductionMonths[mm];
  result := m+PaddZero(IntToStr(DD),2);
end;


Function GetMarStatus(RetNo:Integer):Integer;
Var ProfileFNo:Integer;
begin
 ProfileFNo:=GetFormNo('PROFILE');
 Result:=6;
 If FetchElmFNo(RetNo,ProfileFNo,9)>'' then result:=1
 else If FetchElmFNo(RetNo,ProfileFNo,79)>'' then result:=2
 else If FetchElmFNo(RetNo,ProfileFNo,10)>'' then result:=3
 else If FetchElmFNo(RetNo,ProfileFNo,11)>'' then result:=4
 else If FetchElmFNo(RetNo,ProfileFNo,13)>'' then result:=5
 else If FetchElmFNo(RetNo,ProfileFNo,14)>'' then result:=6;
end;

Function GetMarStatusDescription(Marst:Integer):String;
begin
 Case MarSt of
  1: Result:='Married';
  2: Result:='Common Law';
  3: Result:='Widow(er)';
  4: Result:='Divorced';
  5: Result:='Separated';
  6: Result:='Single';
 end;
end;


procedure UnzipAFile(FrmHandle:THandle;FlName:String);
Var h : THandle;
 PgmToRun:String;
 NullString: array[0..79] of Char;
begin
  PgmtoRun:= InputBox('Input Box', 'Enter WinZip directory', 'c:\Program Files\WinZip\WinZip32.Exe');
  StrPCopy(NullString, PgmToRun);
  h := ShellExecute(FrmHandle, Nil, NullString, Nil, Nil, SW_RESTORE);
  If H<=32 then
  Begin
   ShowMessage('Program cannot execute. Error Code = '+IntToStr(h));
   //SomeList := TStringList.Create;
   SomeCaption := 'Error codes';
   PopSomeFile(AppDir+'\'+'SHELLERR.D',SomeCaption);
 end;
end;

Function CalcDealerCommission(Gross:Real;GN:String;FeRate,DSCRate:Real):Real;
begin
 If GN = 'N' then
  Result := Gross * FeRate/100
 else
  Result := Gross * DscRate /100;
end;

Function CalcAgentCommission(DealerCommission:Real;AgentRate:Real):Real;
begin
  Result := DealerCommission * AgentRate/100;
end;

Function CalcCoAgentCommission(AgCommission:Real;CoAgentRate:Real):Real;
begin
  Result := AgCommission * CoAgentRate/100;
end;

Function GetFundAndRateType(FundCode,Gn:String):String;
begin
  If GN = 'N' then
   result:=FundCode+'FE'
 else
  result:=FundCode+'DSC';
end;

Function GetT1ProgramCommand:String;
Var TempList:TStringList;YearSupported:String;
begin
 Result:='';
 If FileExists(AppDir+'\'+'T1Link.d') then
 begin
     TempList:=TStringList.Create;
     TempList.LoadFromFile(AppDir+'\'+'T1Link.d');
     YearSupported:=AllTrim(TempList[0]);
     Result:=TempList[1]+'\'+'FP'+YearSupported+'.EXE';
     If not FileExists(Result) then result:='';
     TempList.free;
     Exit;
 end;
end;


Function GetT1Year:String;
Var TempList:TStringList;
begin
 result := T1AppYear;
end;

Function NoClient(RetNo: integer):Boolean;
begin
 If (RetNo>0) and (RetInMem>=1) then
 begin
    If Length(GetSinNo(RetNo)) <> 9 then
    begin
     result:=True;
     ShowMessage('You must enter the Client Social Insurance Number or 9 characters');
     exit;
    end
    else
    begin
     Result:=False;
     Exit;
    end;
 end
 else   {no return}
 Begin
  Result := True;
  ShowMessage('You must open a client file first');
  exit;
 end;
 Result := false;
end;

Function CurrentCostOfLivingDone(RetNo:Integer):Boolean;
begin
 Result:=False;
 If Vl(FetchElm(RetNo,'LIVINGEXP_2',120)) >0 then
  result := True;
end;

Function RetirementCostOfLivingDone(RetNo:Integer):Boolean;
begin
 Result:=False;
 If Vl(FetchElm(RetNo,'LIVINGEXP_2',122)) >0 then
  result := True;
end;

Function GetRandomNo(ThisRange:Integer):Integer;
begin
 Randomize;
 Result := Random(ThisRange); {Random(32767);}
end;

Function FetchADate:String;
begin
  Result := GetCalendar;
end;


Function CopyToOutBox(FileName,NewFileName,FromDir,ToDir:string):Integer;
{Var FileNameZ:Array[0..40] of Char;}
begin
 If CopyFile(FromDir+'\'+FileName, ToDir+'\'+NewFileName) then
   result:=0
 else
   Result:=-1;
end;

Function CalcProbate(Estate:Real;Prv:String):Real;
begin
 If Estate<=0 then begin Result :=0;Exit;End;
 If Prv = 'ON' then
 begin
  If Estate <1000 then begin result:=0;exit;end;
  If Estate <= 50000 then
   Result :=  Estate * 0.5/100
  else
   Result := 250+ (Estate-50000) * 1.5/100;
   //(50000/1000) * 5 + + ((Estate-50000)/1000) * 15;
  exit;
 end;

 If Prv= 'AB' then
 begin
   If Estate <=10000 then result :=25
   else If (Estate > 10000) and (Estate <=25000) then result :=100
   else If (Estate > 25000) and (Estate <=125000) then result :=200
   else If (Estate > 125000) and (Estate <=250000) then result :=300
   else If (Estate > 250000)  then result :=400;
   {
    begin  Result := (Estate/10000) *25; exit; end;
    If Result > 6000 then result := 6000;
   }
 end;

 If Prv = 'BC' then
 begin
  If (Estate >0) and (Estate <= 25000) then begin Result := 0;exit; end
  else If (Estate > 25000) and (Estate <= 50000) then  begin result:=Estate * 0.6/100; exit; end
  else If (Estate > 50000)  then begin  Result := 150 + (Estate-50000) * 1.4/100; exit; end;
 end;

 If Prv = 'MB' then
 begin
  If Estate <= 10000 then  begin Result := 70;exit; end;
  If Estate  > 10000  then begin  Result := 70 + (Estate-10000) * 0.7/100; exit; end;
 end;


 If Prv = 'NB' then
 begin
  If Estate <= 5000 then begin Result := 25;exit; end;
  If (Estate > 5000) and (Estate <= 10000) then  begin Result := 50; exit; end;
  If (Estate > 10000) and (Estate <= 15000) then  begin Result := 75; exit; end;
  If (Estate > 15000) and (Estate <= 20000) then  begin Result := 100; exit; end;
  If Estate > 20000 then  begin Result := (Estate - 20000) * 0.5/100; exit; end;
 end;

 If Prv = 'NL' then
 begin
  If Estate <= 1000 then  begin Result := 85;exit; end;
  If Estate  > 1000  then begin  Result := 85 + (Estate-1000) * 0.5/100; exit; end;
 end;

 If Prv = 'NT' then
 begin
  If Estate <= 10000 then begin Result := 25;exit; end;
  If (Estate > 10000) and (Estate <= 25000) then  begin Result := 100; exit; end;
  If (Estate > 25000) and (Estate <= 125000) then  begin Result := 200; exit; end;
  If (Estate > 125000) and (Estate <= 250000) then  begin Result := 300; exit; end;
  If Estate > 250000 then Result := 400;
 end;

 If Prv = 'NS' then
 begin
  If Estate <= 10000 then begin Result := 70;exit; end;
  If (Estate > 10000) and (Estate <= 25000) then  begin Result := 176; exit; end;
  If (Estate > 25000) and (Estate <= 50000) then  begin Result := 293; exit; end;
  If (Estate > 50000) and (Estate <= 100000) then  begin Result := 820; exit; end;
  If Estate > 100000 then  begin Result := 820+(Estate - 100000) * 1.385/100; exit; end;
 end;

 If Prv = 'NU' then
 begin
  If Estate <= 10000 then begin Result := 25;exit; end;
  If (Estate > 10000) and (Estate <= 25000) then  begin Result := 100; exit; end;
  If (Estate > 25000) and (Estate <= 125000) then  begin Result := 200; exit; end;
  If (Estate > 125000) and (Estate <= 250000) then  begin Result := 300; exit; end;
  If Estate > 250000 then Result := 400;
 end;

 If Prv = 'PE' then
 begin
  If Estate <= 10000 then begin Result := 50;exit; end;
  If (Estate > 10000) and (Estate <= 25000) then  begin Result := 100; exit; end;
  If (Estate > 25000) and (Estate <= 50000) then  begin Result := 200; exit; end;
  If (Estate > 50000) and (Estate <= 100000) then  begin Result := 400; exit; end;
  If Estate > 100000 then  begin Result := 400+(Estate - 100000) * 0.4/100; exit; end;
 end;

 If Prv = 'QC' then result:=0;

 If Prv = 'SK' then
 begin
  Result := Estate * 0.7/100;
  Exit;
 end;

 If Prv = 'YT' then
 begin
  If Estate <= 25000 then
   Result := 0
  Else
   Result := 140;
 end;

end;

Function ReplaceChar(S,Ch1,Ch2:String):string;
Var i:integer;
begin
 result :='';
 For i:=1 to Length(s) do
  If s[i] <> Ch1 then result := result+S[i]
  else result := Result+Ch2;
end;


function GetShortName(sLongName:string):string;
Const MaxPath=250;
var
  sShortName    : string;
  nShortNameLen : integer;
  ZString1: Array[0..255] of Char;
  ZString2: Array[0..255] of Char;

begin
  {SetLength(sShortName,MAX_PATH );}
   SetLength(sShortName,MaxPath);
  nShortNameLen :=GetShortPathName(
     StrPCopy(ZString1,sLongName),
     StrPCopy(ZString2,sShortName),
     MaxPath - 1);
   { GetShortPathName(PChar(sLongName),PChar(sShortName),MAX_PATH - 1);}

  if( 0=nShortNameLen) then
  begin
    Result := '';
    exit;
  end;
  SetLength(sShortName,nShortNameLen );
  Result := sShortName;
end;

function __GetLongName(sShortName:string;var bError:boolean):string;
var
  bAddSlash : boolean;
  SearchRec : TSearchRec;
  nStrLen   : integer;
begin
  bError    := False;
  Result    := sShortName;
  nStrLen   := Length(sShortName );
  bAddSlash := False;

  if( '\' = sShortName[nStrLen]) then
  begin
    bAddSlash := True;
    SetLength( sShortName,nStrLen - 1 );
    dec(nStrLen);
  end;

  if ((nStrLen-Length( ExtractFileDrive(sShortName))) > 0)then
  begin
    if( 0 = FindFirst(sShortName,faAnyFile,SearchRec)) then
    begin
      Result := ExtractFilePath(sShortName) + SearchRec.Name;
      if (bAddSlash)then
      begin
        Result := Result + '\';
      end;
    end else
    begin
      // handle errors...
      bError := True;
    end;

   { FindClose(SearchRec);}
  end;
end;


function GetLongName(sShortName : string ):string;
var  s :string; p: integer; bError : boolean;
begin
  Result := sShortName;
  s := '';
  p := Pos( '\', sShortName );
  while( p > 0 )do
  begin
    s := __GetLongName( s + Copy( sShortName, 1, p ),bError );
    Delete( sShortName, 1, p );
    p := Pos( '\', sShortName );

    if( bError )then
      Exit;
  end;
  if( '' <> sShortName )then
  begin
    s := __GetLongName(s + sShortName, bError);

    if( bError )then
      Exit;
  end;
  Result := s;
end;

(*
  Function GetLongFilename
  Parameters:
   shortname: filename or path to convert. This can be a
              fully qualified filename or a path relative
              to the current directory. It can contain long
              and/or short forms for the names.
  Returns:
   fully qualified filename using the long names for all
        elements
   of the path.
  Description:
   Recursively uses FindFirst to find the long names for
   the path elements.
  Error Conditions:
   Will raise an exception if any part of the path was not
        found.
 Created: 15.01.98 14:09:26 by P. Below
*)


Function GetLongFilename(shortname:String):String;

  Function GetL(shortname:String):String;
    Var
      srec: TSearchRec;
    Begin
      { Lob off the last element of the passed name. If we
        received only a root name, e.g. c:\, ExtractFileDir returns
        the path unchanged. }
      Result := ExtractFileDir(shortname);
      If (Result <> shortname) Then Begin
        { We still have an unconverted path element. So
        convert the last one in the current shortname and combine
        the resulting long name with what we get by calling
        ourselves recursively with the rest of the path. }
        If FindFirst( shortname, faAnyfile, srec ) = 0 Then
        try
          Result := GetL( Result )+'\'+srec.Name;
        finally
          ShowMessage('Closing it'); {FindClose(srec);}
        end
        Else
          raise Exception.CreateFmt('Path %s does not exist!', [shortname]);
        End
      Else
        { Only the root remains. Remove the backslash since
        the caller will add it back anyway. }
        Delete(Result, length(result),1);
    End;

Begin
  { Create fully qualified path and pass it to the converter. }
  Result := GetL(ExpandFilename(shortname));
End;

Function GetFileExtension(FlName:String):String;
begin
 Result:= ExtractFileExt(FlName);
 Result:=MidStr(Result,2,3);
end;

Function GetRetirementTaxRate(RetNo:Integer):Real;
Begin
 Result:=CalcMarginalRate(Vl(FetchElm(RetNo,'INCNEED_2',122)));
end;

Function GetYahooUrl(PageId,FundId,Exchange,timeperiod:String):String;
Var
  i,TokenPos:Integer;TempList:Tstringlist;WordList:TstringList;
     GenericUrl:String;
begin
 Result:='';
 TempList:=TStringList.Create;
 WordList:=TStringList.Create;
 TempList.LoadFromFile(Appdir+'\'+'YhMfUrls.d');
 For i:=0 to TempList.count-1 do
 begin
   ParseWords(TempList[i],'@',WordList);
   If WordList[0]=PageId then //found
   begin
    GenericUrl:=WordList[1];
    TokenPos:=GetPositionOfSubstring('1111111',GenericUrl);
    If TokenPos >0 then ReplaceAString(GenericUrl,TokenPos,7,FundId);
    TokenPos:=GetPositionOfSubstring('22',GenericUrl);
    If Exchange = 'US' then Exchange:='';
    If TokenPos >0 then ReplaceAString(GenericUrl,TokenPos,2,Exchange);
    If Exchange='' then ReplaceAString(GenericUrl,TokenPos-1,1,'');
    Result:=GenericUrl;
    Templist.free;
    WordList.Free;
    exit;
   end;  //found
 end; //i
 Templist.free;
 WordList.Free;
end;

Function GetPositionOfSubstring(ss,s:String):Integer;
begin
 Result := pos(UpperCase(ss), Uppercase(s));
end;

Procedure ShowFundDataOnWeb(PageId,FundId,Exchange,timeperiod:String);
Var Url:String;  h:THandle;
 ZString : Array[0..150] of Char;
 Ptr : Pchar;
begin
 Screen.Cursor :=crHourGlass;
 Url:=GetYahooUrl(PageId,FundId,Exchange,TimePeriod);
 If Url='' then
 begin
   ShowMessage('Cannot establish the correct web address');
   Screen.Cursor :=crDefault;
   exit;
 end;
 Ptr := StrPCopy(ZString,Url);
 If Url>'' then h := ShellExecute(Application.MainForm.Handle,'open',Ptr,Nil,Nil,Sw_Show);
 If H<=32 then ShowMessage('Connection failed');
 Screen.Cursor :=crDefault;
end;

procedure AnalyseAFundFromYahoo(PageId,FundId,Exchange:String);
Var Url,CaptureFileName:String;
    TempString : array[0..79] of char; h:THandle;
begin
 If (PageId = 'Profile')
 or (PageId = 'Performance')
 or (PageId = 'Holdings') then
 begin
  Screen.Cursor :=crHourGlass;
  Url:=GetYahooUrl(PageId,FundId,Exchange,'');
  CaptureFileName:= CaptureWebDir+'\'
       +ReplaceChar(FundId,'*','_')+'_'+ PageId+'.Htm';
  GetTheHtmlDoc(Url,CaptureFileName);
  Screen.Cursor :=crDefault;
 end;

 If MidStr(PageId,4,5) = 'chart' then
 begin
   Screen.Cursor :=crHourGlass;
   FundId:=ReplaceChar(FundId,'*', '_');
   Url:=GetYahooUrl(PageId,LowerCase(FundId),LowerCase(Exchange),LeftStr(PageId,2));
   StrPCopy(TempString, Url);
   h:=ShellExecute(0, Nil, TempString, Nil, Nil, SW_NORMAL);
   if h <=32  then ShowMessage('Failed');
   Screen.Cursor :=crDefault;
 end;
end;

procedure GetTheHtmlDoc(Url:String;CaptureFileName:String);
Var i:Integer;h:THandle;FlName:String;
   TempString : array[0..79] of char;
 //20150819  Igor   NMHTTP1 : TNMHTTP;
   Memo1:TMemo;
Begin
 //20150819  Igor  NMHTTP1 := TNMHTTP.Create(Application);
  Memo1:=TMemo.Create(Application);
  //Memo1.Clear;
 //20150819  Igor  NMHTTP1.Get(Url);
 //20150819  Igor  Memo1.Text := NMHTTP1.Body;
 { If NMHTTP1.CookieIn <> '' then
    ShowMessage('Cookie:'+#13#10+NMHTTP1.CookieIn);}
  Memo1.lines.SaveToFile(CaptureFileName);
  StrPCopy(TempString, CaptureFileName);
  h:=ShellExecute(0, Nil, TempString, Nil, Nil, SW_NORMAL);
  if h <=32  then
   ShowMessage('Failed');
  Memo1.Free;
 //20150819  Igor  NMHTTP1.Free;
end;

Function GetValueFromInternet(Url:String;Parameter:String):String;
Var i,j,k,l:Integer;h:THandle;FlName:String;TempList:Tstringlist;
   TempString : array[0..79] of char;
 //20150819  Igor   NMHTTP1 : TNMHTTP;
   Memo1:TMemo;
begin
  Result:='';
 //20150819  Igor  NMHTTP1 := TNMHTTP.Create(Application);
  Memo1:=TMemo.Create(Application);
 //20150819  Igor  NMHTTP1.Get(Url);
 //20150819  Igor  Memo1.Text := NMHTTP1.Body;
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
           //20150819  IgorNMHTTP1.Free;
          TempList.Free;
          exit;
         end; //found keyword
     end; // checked 3 lines for $
   end; //found parameter
  end; //i
 //20150819  Igor NMHTTP1.Free;
 TempList.Free;
end;

Procedure FindKeywordPosition(Var Txt:AnsiString;Var keyW:String;Var KeyWPosition:Integer;Delim1,Delim2:String);
//enclosed in delimiters
Var i,Size,Cursor_position:Integer;
begin
 Txt :=Rtrim(Txt)+' ';  //one space to allow for logic
 Size:=Length(Txt)+1;
 KeyW :='';
 KeyWPosition:=0;
 If AllTrim(Txt) ='' then exit;
 i:=1;
 Repeat
  if Txt[i] = Delim1 then
  begin
     KeyWPosition:=i+1;
     cursor_position:=I;
     I:=I+1;
     while (Txt[i] <>Delim2) and (I<size) do
           begin KeyW:=KeyW+Txt[i]; I:=I+1;end;
  end;
  If i>Size then exit;
  Inc(i);   {?}
 until i>size;
End;

Function GetPresentationDate(RetNo:Integer):String;
begin
 Result:=FormatDateTime('yyyy-mm-dd',Now);
  //FetchElm(RetNo,'PROFILE',41);
end;


Function ConvertToIFICFundType(OldType:String):String;
begin
Result:='';
If      OldType='AB' then result:='7'
else If OldType='AC' then result:='14'
else If OldType='BB' then result:='9'
else If OldType='BC' then result:='31'
else If OldType='CB' then result:='13'
else If OldType='CC' then result:='27'
else If OldType='DB' then result:='6'
else If OldType='DC' then result:='29'
else If OldType='EB' then result:='8'
else If OldType='EC' then result:='28'
else If OldType='FB' then result:='23'
else If OldType='FC' then result:='21'
else If OldType='GB' then result:='5'
else If OldType='GC' then result:='30'
else If OldType='HB' then result:='12'
else If OldType='IB' then result:='11'
else If OldType='JB' then result:='17'
else If OldType='KB' then result:='10'
else If OldType='LB' then result:='18'
else If OldType='MB' then result:='33'
else If OldType='NB' then result:='34'
else If OldType='OB' then result:='16'
else If OldType='PB' then result:='24'
else If OldType='QB' then result:='1'
else If OldType='RB' then result:='2'
else If OldType='SB' then result:='15'
else If OldType='TB' then result:='26'
else If OldType='UB' then result:='4'
else If OldType='VB' then result:='3'
else If OldType='WB' then result:='19'
else If OldType='XB' then result:='32'
else If OldType='YB' then result:='25'
else If OldType='ZB' then result:='20'
else If OldType='ZZ' then result:='22';
end;

Procedure GetIncomeStream(StartBal:Real;IndexBy:Real;Years:Integer;StreamList:TStrings);
Var
  Values:Array of real; //dynamic array
  i: integer;
begin
 StreamList.Clear;
 SetLength(Values, years);
 Values[0]:=StartBal;
 For i:=1 to Years-1 do
 begin
  Values[i]:=Values[i-1]+Values[i-1]*IndexBy/100;
 end;
 For i:=0 to Years-1 do StreamList.Add(FormatFloat('########.##',Values[i]));
end;

Procedure GenChartBMP(ChartHeader: String; TempCanvas: TBitMap; R: TRect;
  HorizontalList: TStringList; VerticalList: TStringList);
Var
  Tot: Real;
  Chart1: TChart;
  R1: TRect;
  I: Integer;
  ThisSeries: TBarSeries;
  F: TForm;
begin
  //20160411 Igor >>>
  F := TForm.Create(nil);
  F.Visible := False;
  Chart1 := TChart.Create(F);
  Chart1.Parent := F;
  //20160411 Igor <<<
  With Chart1 do
  begin
    Title.Font.color := clBlack;
    Title.Font.Size := 12;
    Title.Font.Style := [fsBold];
    Title.Text.clear;
    Title.Text.Add(ChartHeader);

    LeftAxis.Automatic := False;
    LeftAxis.Minimum := GetMinValInList(VerticalList);
    LeftAxis.Minimum := 1.10 * LeftAxis.Minimum;
    LeftAxis.Maximum := GetMaxValInList(VerticalList);
    LeftAxis.Maximum := 1.10 * LeftAxis.Maximum;
    Legend.Visible := False;
    AxisVisible := True;
    Gradient.Visible := True;
    Gradient.StartColor := $008080FF; { pinkish }
    Gradient.EndColor := clAqua;
  end;
  { add series }
  ThisSeries := TBarSeries.Create(Chart1);
  TeeEraseBack := False;
  Chart1.Addseries(ThisSeries);
  With ThisSeries do
  Begin
    Marks.Visible := False; { no yellow boxes on top of Bar }
    BarStyle := bsRectGradient; { Rectangle; }
    BarBrush.color := clRed;
  end;

  With ThisSeries do
  Begin
    clear;
    { apply data }
    If VerticalList.Count < 1 then
      exit;
    I := 0;
    Repeat
      Add(Round(Vl(VerticalList[I])), HorizontalList[I], clTeeColor);
      inc(I, 1); { every  1,2 or 3years }
    until I > VerticalList.Count - 1;
  end;
  Chart1.Draw(TempCanvas.Canvas, R);
  Chart1.free;
  F.Free; //20160411 Igor
end;

Function GetMinValInList(AList:TStringList):Real;
var
  i: integer;
Begin
 result :=0;
 For i:=0 to AList.Count-1 do
 begin
   If Vl(AList[i]) < result then
     result :=Vl(AList[i]);
 end;
end;

Function GetMaxValInList(AList:TStrings):Real;
var
  i: integer;
Begin
 result :=0;
 For i:=0 to AList.Count-1 do
 begin
   If Vl(AList[i]) > result then
     result :=Vl(AList[i]);
 end;
end;

Function StrToTwoDecimals(S:String):String;
Var i,k:integer;
begin
  {DecimalSeparator :='.';}
  Result :='';
  k:=0; {dec position}
  For i:=1 to Length(S) do If S[i] ='.' then k:=i;

  If k>0 then
  begin
    For i:=1 to k-1 do
      begin
       If S[i] in ['-','0','1','2','3','4','5','6','7','8','9'] then
       result := Result+S[i];
      end;
    Result := Result +'.';
    For i:=k+1 to K+1+3 do  {3 decimals}
      begin
       If S[i] in ['0','1','2','3','4','5','6','7','8','9'] then
       result := Result+S[i];
      end;
  end
  else
   begin
    For i:=1 to Length(s) do
    If S[i] in ['-','0','1','2','3','4','5','6','7','8','9'] then
       result := Result+S[i];
   end;
end;

Function GetNonShRate(RetNo:Integer):Real;
begin
 Result:=Vl(FetchElm(RetNo,'RETPLAN',45));
end;

Function GetSheltRate(RetNo:Integer):Real;
begin
 Result:=Vl(FetchElm(RetNo,'RETPLAN',46));
end;


Function GetSemiShRate(RetNo:Integer):Real;
begin
 Result:=Vl(FetchElm(RetNo,'RETPLAN',47));
end;

Function GetOtherRate(RetNo:Integer):Real;
begin
 Result:=Vl(FetchElm(RetNo,'RETPLAN',48));
end;

Function IsRocheSystem:Boolean;
begin
  Result:=False;
  If UpperCase(leftStr(Licensee,9)) ='THE ROCHE' then
    result := True;
//  If UpperCase(LeftStr(HoRec.BusinessName,5)) ='ROCHE' then result := True;
end;


Function GetIntDivCapGpercent(AssetCls:String):String;
Var i:Integer;TempList:TStringList;ClsLength:Integer;
begin
 Result:='';
 ClsLength:=Length(AssetCls);
 TempList:=TStringList.Create;
 TempList.LoadFromFile(AppDir+'\'+'AssetCls.d');
 For i:=0 to TempList.Count-1 do
 begin
  If AssetCls=LeftStr(TempList[i],ClsLength) then
   begin Result:=MidStr(TempList[i],21,13);TempList.Free;exit;end;
 end;
 TempList.Free;
end;

Function GetAssumedIntDivCapG(RetNo: integer; AssetCls:String):String;
Var FNo:Integer;ClsLength:Integer;
begin
 Result:='';
 FNo:=GetFormNo('ASSUME');
 If AssetCls='Cash' then begin result:=FetchElmFNo(RetNo,FNo,21);exit;end
 else If AssetCls='Income' then begin result:=FetchElmFNo(RetNo,FNo,25);exit;end
 else if AssetCls='Growth' then begin result:=FetchElmFNo(RetNo,FNo,27);exit;end
 else if AssetCls='Balanced' then begin result:=FetchElmFNo(RetNo,FNo,71);exit;end
 else if AssetCls='Income & Growth' then begin result:=FetchElmFNo(RetNo,FNo,29);exit;end
 else if AssetCls='Global Growth' then begin result:=FetchElmFNo(RetNo,FNo,31);exit;end
 else if AssetCls='Aggressive Growth' then begin result:=FetchElmFNo(RetNo,FNo,33);exit;end;
end;


Function GetHistoricalRateOfReturn(AssetCls:String):String;
Var i:Integer;TempList:TStringList;ClsLength:Integer;
begin
 Result:='';
 ClsLength:=Length(AssetCls);
 TempList:=TStringList.Create;
 TempList.LoadFromFile(AppDir+'\'+'AssetCls.d');
 For i:=0 to TempList.Count-1 do
 begin
  If AssetCls=LeftStr(TempList[i],ClsLength) then
   begin Result:=AllTrim(MidStr(TempList[i],35,5));TempList.Free;exit;end;
 end;
 TempList.Free;
end;

Function GetAssumedHistRateOfReturn(RetNo: integer; AssetCls:String):String;
Var FNo:Integer;
begin
 Result:='';
 FNo:=GetFormNo('ASSUME');
 If AssetCls='Cash' then begin result:=FetchElmFNo(RetNo,FNo,22);exit;end
 else if AssetCls='Income' then begin result:=FetchElmFNo(RetNo,FNo,26);exit;end
 else if AssetCls='Growth' then begin result:=FetchElmFNo(RetNo,FNo,28);exit;end
 else if AssetCls='Income & Growth' then begin result:=FetchElmFNo(RetNo,FNo,30);exit;end
 else if AssetCls='Global Growth' then begin result:=FetchElmFNo(RetNo,FNo,32);exit;end
 else if AssetCls='Aggressive Growth' then begin result:=FetchElmFNo(RetNo,FNo,34);exit;end;
end;

Function IsAgentDemo:Boolean;
begin
  Result:=False;
  If UpperCase(HoRec.DealerCode) ='XYZ1' then result := True;
end;

Function GetCurYear:String;
begin
 result:=LeftStr(FormatDateTime('yyyy-mm-dd',Now),4);
end;


Procedure ReadUdlInfo(UdlFileName:String;Var ProviderName:String;Var DataSourceName:String);
begin
 If Not FileExists(AppDir+'\'+UdlFileName) then
 begin
   ProviderName:='Microsoft.Jet.OLEDB.4.0';
   If LeftStr(UpperCase(UdlFileName),4)='FPCL' then
     DataSourceName:=AppDir+'\'+'FpClients\FpClients.mdb'
   else If LeftStr(UpperCase(UdlFileName),4)='FUND' then
     DataSourceName:=AppDir+'\'+'FundBase\FundBase.mdb';
   Exit;
 end;
 // parse UDL data
 ParseUdlInfo(UdlFileName,ProviderName,DataSourceName);
end;

Procedure ParseUdlInfo(UdlFileName:String;Var ProviderName:String;Var DataSourceName:String);
Var TempList:TStringList;
 i,j,k:Integer;WList:TStringList;
begin
  TempList:=TStringList.Create;
  WList:=TStringList.Create;
  If Not FileExists(UdlFileName) then
  begin
   Exit;
  end;
  TempList.LoadFromFile(UdlFileName);
  For i:=0 to TempList.count-1 do
  begin
    If LeftStr(TempList[i],8) = 'Provider' then
    begin
     ParseWords(TempList[i],';',WList);
     For j:=0 to WList.count-1 do
     begin
      If LeftStr(WList[j],8) = 'Provider' then
      begin
       k:=AnsiPos('=',WList[j]);
       ProviderName:=AllTrim(MidStr(WList[j],K+1,254));
      end;
      If LeftStr(WList[j],11) = 'Data Source' then
      begin
       k:=AnsiPos('=',WList[j]);
       DataSourceName:=AllTrim(MidStr(TempList[i],K+1,254));
      end;
    end; //j
   end; //provider line
  end; //i
  TempList.Free;
  WList.Free;
end;

Procedure SaveUdlInfo(UdlFile:String;Provider:String;DataSource:String);
Var TempList:TStringList;
begin
  // CreateUDLFile(UdlFile, Provider, DataSource);
   TempList:=TStringList.Create;
   TempList.Add('[oledb]');
   TempList.Add('; Everything after this line is an OLE DB initstring');
   TempList.add('Provider = '+Provider+';');
   TempList.add('Data Source = '+DataSource+';');
   TempList.SavetoFile(AppDir+'\'+UdlFile);
   TempList.Free;
end;


Function CountEducationKids(RetNo:Integer):Integer;
Var i,k,ProfFNo:Integer;
begin
  result:=0;
  ProfFNo:=GetFormNo('PROFILE');
  i:=43; //index to Profile form
  k:=101;
  Repeat   {name and university}
   If (FetchElmFNo(RetNo,ProfFNo,i)>'') //nam
   and (FetchElmFNo(RetNo,ProfFNo,i+2)>'') //birthdate
   and (UpperCase(FetchElmFNo(RetNo,ProfFNo,k))='X')  //attending
   and (UpperCase(FetchElmFNo(RetNo,ProfFNo,k+10))>'') //years
   then Inc(Result);
   Inc(i,4);
   Inc(k,1)
   until i>75;
end;

Function GetEduIndexForAKid(RetNo:Integer;WhichNo:Integer):Integer;
Var i,k,ProfFNo,cnt:Integer;
begin
  result:=0;
  Cnt:=0;
  ProfFNo:=GetFormNo('PROFILE');
  i:=43; //index to Profile form
  k:=101;
  Repeat   {name and university}
   If (FetchElmFNo(RetNo,ProfFNo,i)>'')
   and (FetchElmFNo(RetNo,ProfFNo,i+2)>'')
   and (UpperCase(FetchElmFNo(RetNo,ProfFNo,k))='X')
   then Inc(Cnt);
   If Cnt=WhichNo then begin result:=i;exit;end;
   Inc(i,4);
   Inc(k,1);
   until i>75;
end;


Function GetTuitionCost(Prv:String):Real;
Var i:Integer;TempList:TstringList;
begin
 Result:=0;
 TempList:=TStringList.Create;
 TempList.LoadFromFile(appDir+'\'+'Tuition.d');
 For i:=0 to Templist.count-1 do
 begin
  If Prv=LeftStr(Templist[i],2) then
   begin
    Result:=Vl(AllTrim(MidStr(Templist[i],6,8)));
    TempList.Free;
    exit;
   end;
 end;
TempList.Free;
end;

Function GetTuitionEscal(Prv:String):String;
Var i:Integer;TempList:TstringList;
begin
 Result:='';
 TempList:=TStringList.Create;
 TempList.LoadFromFile(appDir+'\'+'Tuition.d');
 For i:=0 to Templist.count-1 do
 begin
  If Prv=LeftStr(Templist[i],2) then
   begin
    Result:=AllTrim(MidStr(Templist[i],15,3));
    TempList.Free;
    exit;
   end;
 end;
TempList.Free;
end;


procedure StartT1;
Var TempList1:TStringList;
    tempstring : Array[0..80] of Char;
begin
  If IsT1Installed = false then exit;
  TempList1:=TstringList.Create;
  TempList1.Add('START');
  TempLIst1.SaveToFile(BlackBoxDir+'\'+'T1BlBox1.txt');
  StrPCopy(TempString, GetT1ProgramCommand); //'C:\delphi\t1\t12002.exe');
  ShellExecute(0, Nil, TempString, Nil, Nil, SW_NORMAL);
  TempList1.Free;
  IsT1Open:=True;
end;

procedure StopT1;
Var TempList1:TStringList;
begin
  If Not DirectoryExists(BlackBoxDir) then
   ForceDirectories(BlackBoxDir);
  TempList1:=TstringList.Create;
  TempList1.Add('STOP');
  TempLIst1.SaveToFile(BlackBoxDir+'\'+'T1BlBox1.txt');
  TempList1.Free;
  IsT1Open:=False;
end;

Procedure GetEduYearsList(RetNo:Integer;EduYearsList:TStrings);
Var i,j,k,m,FNo,StartYear:Integer;FInst:String;
begin
 EduYearsList.Clear;
 k:=CountEducationKids(RetNo);
 //mke List of education years

 For i:=1 to k do
 begin
   FInst:='#'+AllTrim(IntToStr(i));
   FNo:=GetFormNo('EDUPLN'+FInst);
   StartYear:=MyStrToInt(FetchElmFNo(RetNo,FNo,6));
   If StartYear>0 then
   begin
     EduYearsList.Add(AllTrim(IntToStr(StartYear)));
     m:=MyStrToInt(FetchElmFNo(RetNo,FNo,7));    //years of educ
     for j:=1 to m-1 do
      EduYearsList.Add(IntToStr(StartYear+1));
   end;
 end;
end;

Procedure BuildLiabilityEvents(RetNo:Integer);
Const Typ1='Mortgage';
      Typ2='CarLoan';
      Typ3='Other';
Var i,ii,j,FNo,J1,J2:Integer;
    //LiabilitiesQ:TAdoQuery;WhereClause:String;
    FromYear,ToYear:string; //[4];
    MortgageAmount,AutosAmount,OtherAmount:Real; //,YearlyAmount:Real;
    MonthlyMortgage,MonthlyAuto,MonthlyOther:Real;
    cnt,Year,iStartYear,iFromYear,iToYear:Integer; sYear:string; //[4];
    Principal,Interest:Real; Years:Integer;
    PeriodNoList,InterestPaidList,PrincipalPaidList,BalanceRemainingList:TStringList;
begin
  PeriodNoList:=TStringList.Create;
  InterestPaidList:=TStringList.Create;
  PrincipalPaidList:=TStringList.Create;
  BalanceRemainingList:=TStringList.Create;

  for j :=0 to (FList.Count - 1) do
  begin
   FRec := FList.Items[j];
   If (Frec.FormName='MORTGAGES')
   and (Ret[RetNo].FrmHasData[Frec.FormNo]) then
   begin
    FNo:=Frec.FormNo;
    i:=0;
    Repeat
     iStartYear:=MyStrToInt(AppYear);
     FromYear:=FetchElmFNo(RetNo,FNo,i+3);
     iFromYear:=MyStrToInt(FromYear);
     ToYear  :=FetchElmFNo(RetNo,FNo,i+8);
     iToYear:=MyStrToInt(ToYear);

     Principal:= vl(FetchElmFNo(RetNo,FNo,i+2));
     Interest:= vl(FetchElmFNo(RetNo,FNo,i+5));
     Years:=MyStrToInt(ToYear)-MyStrToInt(FromYear)+1;
     If Principal=0 then Break;
     If Years<0 then Years:=0;

     PeriodNoList.Clear;
     InterestPaidList.Clear;

     PrincipalPaidList.Clear;
     BalanceRemainingList.Clear;
     GetMortgageTable(Principal,Interest,Years,
          PeriodNoList,InterestPaidList,PrincipalPaidList,BalanceRemainingList);
     Cnt:=0;Year:=iFromYear;
     For ii:=0 to PeriodNoList.count-1 do
     begin
       Inc(Cnt);
       If cnt=12 then    //get it every 12 periods as incoming from Mortgage calc is by month)
       begin
         Cnt:=0;
         sYear:=AllTrim(IntToStr(Year));
         MortgageAmount:=Vl(BalanceRemainingList[ii]);
         MonthlyMortgage:=Vl(FetchElmFNo(RetNo,FNo,i+6));  //not calculated as below!
         //MonthlyMortgage:=Vl(AllTrim(InterestPaidList[ii]))+Vl(PrincipalPaidList[ii]);
         //put it a year at a time, a type of liab at a time
         PutLiabilityEventInProjection(RetNo,sYear,sYear,MortgageAmount,0,0,MonthlyMortgage,0,0);
       end;
       If cnt=0 then Inc(Year);
     end; //ii
     Inc(i,12);
    until i>253;
   end; //mortgages
  end; //j flist

  //carloans
  for j :=0 to (FList.Count - 1) do
  begin
   FRec := FList.Items[j];
   If (Frec.FormName='CARLOANS') and (Ret[RetNo].FrmHasData[Frec.FormNo]) then
   begin
    FNo:=Frec.FormNo;
    i:=0;
    Repeat
     iStartYear:=MyStrToInt(AppYear);
     FromYear:=FetchElmFNo(RetNo,FNo,i+3);
     iFromYear:=MyStrToInt(FromYear);
     ToYear  :=FetchElmFNo(RetNo,FNo,i+8);
     iToYear:=MyStrToInt(ToYear);
     Principal:= vl(FetchElmFNo(RetNo,FNo,i+2));
     Interest:= vl(FetchElmFNo(RetNo,FNo,i+5));
     Years:=MyStrToInt(ToYear)-MyStrToInt(FromYear)+1;
     If Principal=0 then Break;
     If Years<0 then Years:=0;

     PeriodNoList.Clear;
     InterestPaidList.Clear;
     PrincipalPaidList.Clear;
     BalanceRemainingList.Clear;
     GetPaymentsTable(Principal,Interest,Years,
      PeriodNoList,InterestPaidList,PrincipalPaidList,BalanceRemainingList);
     Cnt:=0;Year:=iFromYear;
     For ii:=0 to PeriodNoList.count-1 do
     begin
       Inc(Cnt);
       If cnt=12 then    //get it every 12 periods (incoming is by month)
       begin
         Cnt:=0;
         sYear:=AllTrim(IntToStr(Year));
         AutosAmount:=Vl(BalanceRemainingList[ii]);
         MonthlyAuto:=Vl(FetchElmFNo(RetNo,FNo,i+6));  //not calculated as below!
          //Vl(AllTrim(InterestPaidList[ii]))+Vl(PrincipalPaidList[ii]);
         //put it a year at a time, a type of liab at a time
         PutLiabilityEventInProjection(RetNo,sYear,sYear,0,AutosAmount,0,0,MonthlyAuto,0);
       end;
       If cnt=0 then Inc(Year);
     end; //ii
     Inc(i,12);
     until i>349;
   end; //carloans
  end; //j flist

  //OTHERLTL
  for j :=0 to (FList.Count - 1) do
  begin
   FRec := FList.Items[j];
   If (Frec.FormName='OTHERLTL') and (Ret[RetNo].FrmHasData[Frec.FormNo]) then
   begin
    FNo:=Frec.FormNo;
    i:=0;
    Repeat
     iStartYear:=MyStrToInt(AppYear);
     FromYear:=FetchElmFNo(RetNo,FNo,i+3);
     iFromYear:=MyStrToInt(FromYear);
     ToYear  :=FetchElmFNo(RetNo,FNo,i+8);
     iToYear:=MyStrToInt(ToYear);
     Principal:= vl(FetchElmFNo(RetNo,FNo,i+2));
     Interest:= vl(FetchElmFNo(RetNo,FNo,i+5));
     Years:=MyStrToInt(ToYear)-MyStrToInt(FromYear)+1;
     If Principal=0 then Break;
     If Years<0 then Years:=0;

     PeriodNoList.Clear;
     InterestPaidList.Clear;
     PrincipalPaidList.Clear;
     BalanceRemainingList.Clear;
     GetPaymentsTable(Principal,Interest,Years,
      PeriodNoList,InterestPaidList,PrincipalPaidList,BalanceRemainingList);
     Cnt:=0;Year:=iFromYear;
     For ii:=0 to PeriodNoList.count-1 do
     begin
       Inc(Cnt);
       If cnt=12 then    //get it every 12 periods (incoming is by month)
       begin
         Cnt:=0;
         sYear:=AllTrim(IntToStr(Year));
         OtherAmount:=Vl(BalanceRemainingList[ii]);  //20090605
         //OtherAmount:=Vl(BalanceRemainingList[i]);
         MonthlyOther:=Vl(FetchElmFNo(RetNo,FNo,i+6));  //not calculated as below!
          //Vl(InterestPaidList[i])+Vl(PrincipalPaidList[i]);
         //put it a year at a time, a type of liab at a time
         PutLiabilityEventInProjection(RetNo,sYear,sYear,0,0,OtherAmount,0,0,MonthlyOther);
       end;
       If cnt=0 then Inc(Year);
     end; //ii
     Inc(i,11);
     until i>320;
   end; //otherltl
  end; //j flist


  PeriodNoList.Free;
  InterestPaidList.Free;
  PrincipalPaidList.Free;
  BalanceRemainingList.Free;
End;

Procedure PutLiabilityEventInProjection(RetNo:Integer;FromYear:String;ToYear:String;
  MortgageAmount,AutosAmount,OtherAmount,MonthlyMortgage,MonthlyAuto,MonthlyOther:Real);
//for fixed amount contributions or withdrwals
Var I,j,FNo:integer; Sep :string; //[1];
Begin
 For i:=0 to RetirementParms.NumbPeriods do //LiabilitiesProjectionList.Count-1 do
 begin
  LiabilitiesProjectionRec := LiabilitiesProjectionList[i];
  {Check against events}
  If YearInEventRange(IntToStr(LiabilitiesProjectionRec.Year),FromYear,ToYear)
   then
   begin
    LiabilitiesProjectionRec.Mortgages:=LiabilitiesProjectionRec.Mortgages+MortgageAmount;
    LiabilitiesProjectionRec.Automobiles:=LiabilitiesProjectionRec.Automobiles+AutosAmount;
    LiabilitiesProjectionRec.Other:=LiabilitiesProjectionRec.Other+OtherAmount;

    LiabilitiesProjectionRec.MonthlyMortgage:=
      LiabilitiesProjectionRec.MonthlyMortgage+MonthlyMortgage;
    LiabilitiesProjectionRec.MonthlyAuto:=
      LiabilitiesProjectionRec.MonthlyAuto+MonthlyAuto;
    LiabilitiesProjectionRec.MonthlyOther:=
      LiabilitiesProjectionRec.MonthlyOther+MonthlyOther;

    Break;  //no reason to continue as from and to dates are the same
   end;
 end; //i
end;


Procedure BuildFixedAssetsProjection(RetNo:Integer);
Var i,StartAge:Integer;
    PrevRec:TFixedAssetsProjectionRec;
    GrowthRateAutos,
    GrowthRateHomes,
    GrowthRateVacationPr,
    GrowthRateIncomeProp,
    GrowthRateOtherFixed:Real;
    FNo:Integer;
    StartingAutos:Real;
    AutosDepreciation:Real;
begin
  FNo:=GetFormNo('ASSUME');
  GrowthRateAutos:=Vl(FetchElmFNo(RetNo,FNo,36))/100;
  GrowthRateHomes:=Vl(FetchElmFNo(RetNo,FNo,23))/100;
  GrowthRateVacationPr:=Vl(FetchElmFNo(RetNo,FNo,24))/100;
  GrowthRateIncomeProp:=Vl(FetchElmFNo(RetNo,FNo,35))/100;
  GrowthRateOtherFixed:=Vl(FetchElmFNo(RetNo,FNo,39))/100;

  GetRetirementParms(RetNo);
  {initialize}
 // FixedAssetsProjectionList.Clear;
 // FixedAssetsProjectionList.Capacity:=RetirementParms.NumbPeriods+2;
  StartAge := GetPlanStartAge(RetNo);

  For i:=0 to RetirementParms.NumbPeriods do
  begin
   //New(FixedAssetsProjectionRec);
   FixedAssetsProjectionRec :=FixedAssetsProjectionList.Items[i];
   FixedAssetsProjectionRec.PeriodNo      := i;
   FixedAssetsProjectionRec.Year          := (RetirementParms.StartYear)+i;
   FixedAssetsProjectionRec.Age           := StartAge+i;
   FixedAssetsProjectionRec.Homes     := 0;

   FixedAssetsProjectionRec.Autos   := 0;
   FixedAssetsProjectionRec.Homes   := 0;
   FixedAssetsProjectionRec.VacationPr  := 0;
   FixedAssetsProjectionRec.IncomeProp := 0;
   FixedAssetsProjectionRec.OtherFixed  := 0;
   FixedAssetsProjectionRec.Total  := 0;

   FixedAssetsProjectionRec.AutosOrigCost   := 0;
   FixedAssetsProjectionRec.HomesOrigCost   := 0;
   FixedAssetsProjectionRec.VacationPrOrigCost  := 0;
   FixedAssetsProjectionRec.IncomePropOrigCost := 0;
   FixedAssetsProjectionRec.OtherFixedOrigCost  := 0;

   FixedAssetsProjectionRec.AutosCapGain   := 0;
   FixedAssetsProjectionRec.VacationPrCapGain  := 0;
   FixedAssetsProjectionRec.IncomePropCapGain := 0;
   FixedAssetsProjectionRec.OtherFixedCapGain  := 0;
  // FixedAssetsProjectionList.Add(FixedAssetsProjectionRec);
  end;

  //calcs opening balances and orig costof all fixed assets
  BuildFixedAssetsEvents(RetNo);

  For i:=0 to RetirementParms.NumbPeriods do
  begin
    FixedAssetsProjectionRec := FixedAssetsProjectionList.Items[i];
    If i=0 then
    begin
     PrevRec:=FixedAssetsProjectionList.Items[0];
     StartingAutos:=FixedAssetsProjectionRec.Autos;
     AutosDepreciation:=StartingAutos*GrowthRateAutos;
    end
    Else  //i>0 : calculate based on appreciation %
    begin
      PrevRec:=FixedAssetsProjectionList.Items[i-1];
      FixedAssetsProjectionRec.Autos       :=PrevRec.Autos+AutosDepreciation;
      FixedAssetsProjectionRec.Homes       :=PrevRec.Homes+(PrevRec.Homes+FixedAssetsProjectionRec.Homes) * GrowthRateHomes;
      FixedAssetsProjectionRec.VacationPr  :=PrevRec.VacationPr+(PrevRec.VacationPr+FixedAssetsProjectionRec.VacationPr) * GrowthRateVacationPr;
      FixedAssetsProjectionRec.IncomeProp  :=PrevRec.IncomeProp+(PrevRec.IncomeProp+FixedAssetsProjectionRec.IncomeProp) * GrowthRateIncomeProp;
      FixedAssetsProjectionRec.OtherFixed  :=PrevRec.OtherFixed+(PrevRec.OtherFixed+FixedAssetsProjectionRec.OtherFixed) * GrowthRateOtherFixed;

      FixedAssetsProjectionRec.AutosCapGain       :=FixedAssetsProjectionRec.Autos - FixedAssetsProjectionRec.AutosOrigCost;
      FixedAssetsProjectionRec.HomesCapGain       :=FixedAssetsProjectionRec.Homes - FixedAssetsProjectionRec.HomesOrigCost;
      FixedAssetsProjectionRec.VacationPrCapGain  :=FixedAssetsProjectionRec.VacationPr - FixedAssetsProjectionRec.VacationPrOrigCost;
      FixedAssetsProjectionRec.IncomePropCapGain  :=FixedAssetsProjectionRec.IncomeProp - FixedAssetsProjectionRec.IncomePropOrigCost;
      FixedAssetsProjectionRec.OtherFixedCapGain  :=FixedAssetsProjectionRec.OtherFixed - FixedAssetsProjectionRec.OtherFixedOrigCost;

      If FixedAssetsProjectionRec.Autos <0 then FixedAssetsProjectionRec.Autos:=0;
      If FixedAssetsProjectionRec.Homes <0 Then FixedAssetsProjectionRec.Homes:=0;
      If FixedAssetsProjectionRec.VacationPr  <0 Then FixedAssetsProjectionRec.VacationPr:=0;
      If FixedAssetsProjectionRec.IncomeProp <0  Then FixedAssetsProjectionRec.IncomeProp:=0;
      If FixedAssetsProjectionRec.OtherFixed <0       Then FixedAssetsProjectionRec.OtherFixed:=0;
      If FixedAssetsProjectionRec.Total  <0       Then FixedAssetsProjectionRec.Total:=0;
    end;
    // calc total
    FixedAssetsProjectionRec.Total:=
        FixedAssetsProjectionRec.Autos
        +FixedAssetsProjectionRec.Homes
        +FixedAssetsProjectionRec.VacationPr
        +FixedAssetsProjectionRec.IncomeProp
        +FixedAssetsProjectionRec.OtherFixed;
  end;{i}
end; {procedure}

Procedure BuildFixedAssetsEvents(RetNo:Integer);
// get current value at the asofdate (currnt year or future year)
Var {AssetsQ:TAdoQuery;WhereClause:String;}
  AsOfYear,ToYear:string; //[4];
  Autos,Homes,VacationPr,IncomeProp,OtherFixed,OtherAssets:Real;
  AutosOrigCost,HomesOrigCost,VacationPrOrigCost,
  IncomePropOrigCost,OtherFixedOrigCost:Real;
  FNo,i,k:integer;
begin
  //initialize beg balances
  Autos:=0;
  Homes:=0;
  VacationPr:=0;
  IncomeProp:=0;
  OtherFixed:=0;
  //initialize orig cost
  AutosOrigCost:=0;
  HomesOrigCost:=0;
  VacationPrOrigCost:=0;
  IncomePropOrigCost:=0;
  OtherFixedOrigCost:=0;

  AsOfYear:=IntToStr(RetirementParms.StartYear);
  For k:=1 to 5 do
  begin
   FNo:=GetFormNo('REALEST#'+IntToStR(k));
   If FNo=0 then break;
   If Ret[RetNo].FrmHasData[FNo] then
   begin
    //homes
    i:=3;
    Repeat
      HomesOrigCost:=HomesOrigCost+Vl(FetchElmFNo(RetNo,FNo,i));
      Homes:=Homes+Vl(FetchElmFNo(RetNo,FNo,i+1));
      //AsOfYear:=FetchElmFNo(RetNo,FNo,i+2);
      PutFixedAssetsStartBalanceInProjection(RetNo,AsOfYear,
       Autos,Homes,VacationPr,IncomeProp,OtherFixed,
       AutosOrigCost,HomesOrigCost,VacationPrOrigCost,IncomePropOrigCost,OtherFixedOrigCost);
      Inc(i,9);
    until i>39;
    //vacation properties
    i:=48;
    Repeat
      VacationPrOrigCost:=VacationPrOrigCost+Vl(FetchElmFNo(RetNo,FNo,i));
      VacationPr:=VacationPr+Vl(FetchElmFNo(RetNo,FNo,i+1));
      //AsOfYear:=FetchElmFNo(RetNo,FNo,i+2);
      PutFixedAssetsStartBalanceInProjection(RetNo,AsOfYear,
       Autos,Homes,VacationPr,IncomeProp,OtherFixed,
       AutosOrigCost,HomesOrigCost,VacationPrOrigCost,IncomePropOrigCost,
       OtherFixedOrigCost);
      Inc(i,9);
    until i>84;
    //investm properties
    i:=93;
    Repeat
      IncomePropOrigCost:=IncomePropOrigCost+Vl(FetchElmFNo(RetNo,FNo,i));
      IncomeProp:=IncomeProp+Vl(FetchElmFNo(RetNo,FNo,i+1));
      //AsOfYear:=FetchElmFNo(RetNo,FNo,i+2);
      PutFixedAssetsStartBalanceInProjection(RetNo,AsOfYear,
       Autos,Homes,VacationPr,IncomeProp,OtherFixed,
       AutosOrigCost,HomesOrigCost,VacationPrOrigCost,IncomePropOrigCost,
       OtherFixedOrigCost);
      Inc(i,9);
    until i>228;
   end; //has data
  end; //k

  //Autos
  For k:=1 to 5 do
  begin
   FNo:=GetFormNo('AUTOS#'+IntToStR(k));
   If FNo=0 then break;
   If Ret[RetNo].FrmHasData[FNo] then
   begin
    i:=3;
    Repeat
      AutosOrigCost:=AutosOrigCost+Vl(FetchElmFNo(RetNo,FNo,i));
      Autos:=Autos+Vl(FetchElmFNo(RetNo,FNo,i+1));
      //AsOfYear:=FetchElmFNo(RetNo,FNo,i+2);
      PutFixedAssetsStartBalanceInProjection(RetNo,AsOfYear,
       Autos,Homes,VacationPr,IncomeProp,OtherFixed,
       AutosOrigCost,HomesOrigCost,VacationPrOrigCost,IncomePropOrigCost,
       OtherFixedOrigCost);
      Inc(i,8);
    until i>211;
   end; //has data
  end; //k

  //othfixed
  For k:=1 to 5 do
  begin
   FNo:=GetFormNo('OTHFIXED#'+IntToStR(k));
   If FNo=0 then break;
   If Ret[RetNo].FrmHasData[FNo] then
   begin
    i:=3;
    Repeat
      OtherFixedOrigCost:=OtherFixedOrigCost+Vl(FetchElmFNo(RetNo,FNo,i));
      OtherFixed:=OtherFixed+Vl(FetchElmFNo(RetNo,FNo,i+1));
      //AsOfYear:=FetchElmFNo(RetNo,FNo,i+2);
      PutFixedAssetsStartBalanceInProjection(RetNo,AsOfYear,
       Autos,Homes,VacationPr,IncomeProp,OtherFixed,
       AutosOrigCost,HomesOrigCost,VacationPrOrigCost,IncomePropOrigCost,
       OtherFixedOrigCost);
      Inc(i,8);
    until i>211;
   end; //has data
  end; //k
end;

Procedure BuildBusinessProjection(RetNo:Integer);
Var i,StartAge:Integer;
    PrevRec: TBusinessProjectionRec;
    GrowthRateBusNonIncorp,
    GrowthRateBusIncorp,
    GrowthRateOther:Real;
    FNo:Integer;
begin
  FNo:=GetFormNo('ASSUME');
  GrowthRateBusNonIncorp:=Vl(FetchElmFNo(RetNo,FNo,37))/100;
  GrowthRateBusIncorp:=Vl(FetchElmFNo(RetNo,FNo,38))/100;

  GetRetirementParms(RetNo);
  {initialize}
  //BusinessProjectionList.Clear;
  //BusinessProjectionList.Capacity:=RetirementParms.NumbPeriods+2;
  StartAge := GetPlanStartAge(RetNo);

  For i:=0 to RetirementParms.NumbPeriods do
  begin
   //New(BusinesssProjectionRec);
   BusinesssProjectionRec :=BusinessProjectionList.Items[i];
   BusinesssProjectionRec.PeriodNo      := i;
   BusinesssProjectionRec.Year          := (RetirementParms.StartYear)+i;
   BusinesssProjectionRec.Age           := StartAge+i;

   BusinesssProjectionRec.BusNonIncorp  := 0;
   BusinesssProjectionRec.BusIncorp  := 0;
   BusinesssProjectionRec.Other       := 0;
   BusinesssProjectionRec.Total  := 0;

   BusinesssProjectionRec.BusNonIncorpOrigCost  := 0;
   BusinesssProjectionRec.BusIncorpOrigCost  := 0;
   BusinesssProjectionRec.OtherOrigCost  := 0;

   BusinesssProjectionRec.BusNonIncorpCapGain  := 0;
   BusinesssProjectionRec.BusIncorpCapGain  := 0;
   BusinesssProjectionRec.OtherCapGain  := 0;
  end;

  //calcs opening balances and orig costof all fixed assets
  BuildBusinessEvents(RetNo);

  For i:=0 to RetirementParms.NumbPeriods do //BusinessProjectionList.Count-1 do
  begin
    BusinesssProjectionRec := BusinessProjectionList.Items[i];
    If i=0 then
     PrevRec:=BusinessProjectionList.Items[0]
    Else  //calculate based on appreciation %
    begin
      PrevRec:=BusinessProjectionList.Items[i-1];
      BusinesssProjectionRec.BusNonIncorp:=PrevRec.BusNonIncorp+(PrevRec.BusNonIncorp+BusinesssProjectionRec.BusNonIncorp) * GrowthRateBusNonIncorp;
      BusinesssProjectionRec.BusIncorp   :=PrevRec.BusIncorp+(PrevRec.BusIncorp+BusinesssProjectionRec.BusIncorp) * GrowthRateBusIncorp;
      BusinesssProjectionRec.Other       :=PrevRec.Other +(PrevRec.Other+BusinesssProjectionRec.Other) * GrowthRateOther;

      BusinesssProjectionRec.BusNonIncorpCapGain:=BusinesssProjectionRec.BusNonIncorp - BusinesssProjectionRec.BusNonIncorpOrigCost;
      BusinesssProjectionRec.BusIncorpCapGain   :=BusinesssProjectionRec.BusIncorp - BusinesssProjectionRec.BusIncorpOrigCost;
      BusinesssProjectionRec.OtherCapGain       :=BusinesssProjectionRec.Other    - BusinesssProjectionRec.OtherOrigCost;

      If BusinesssProjectionRec.BusNonIncorp <0 Then BusinesssProjectionRec.BusNonIncorp:=0;
      If BusinesssProjectionRec.BusIncorp  <0   Then BusinesssProjectionRec.BusIncorp:=0;
      If BusinesssProjectionRec.Other <0       Then BusinesssProjectionRec.Other:=0;
      If BusinesssProjectionRec.Total  <0       Then BusinesssProjectionRec.Total:=0;
    end;
    // calc total
    BusinesssProjectionRec.Total:=
       BusinesssProjectionRec.BusNonIncorp
      +BusinesssProjectionRec.BusIncorp
      +BusinesssProjectionRec.Other;
  end;{i}
end; {procedure}



Procedure BuildBusinessEvents(RetNo:Integer);
// get current value at the asofdate (currnt year or future year)
Var {AssetsQ:TAdoQuery;WhereClause:String;}
  AsOfYear,ToYear:string; //[4];
  BusIncorp,BusNonIncorp,Other:Real;
  BusIncorpOrigCost,BusNonIncorpOrigCost,OtherOrigCost:Real;
  FNo,i,k:integer;
begin
  //initialize beg balances
  BusIncorp:=0;
  BusNonIncorp:=0;
  Other:=0;
  AsOfYear:=IntToStr(RetirementParms.StartYear);
  //initialize orig cost
  BusIncorpOrigCost:=0;
  BusNonIncorpOrigCost:=0;
  OtherOrigCost:=0;

  //business
  For k:=1 to 5 do
  begin
   FNo:=GetFormNo('BUSINESS#'+IntToStR(k));
   If FNo=0 then break;
   If Ret[RetNo].FrmHasData[FNo] then
   begin
    //nonincorp
    i:=3;
    Repeat
      BusNonIncorpOrigCost:=BusNonIncorpOrigCost+Vl(FetchElmFNo(RetNo,FNo,i));
      BusNonIncorp:=BusNonIncorp+Vl(FetchElmFNo(RetNo,FNo,i+1));
      //AsOfYear:=FetchElmFNo(RetNo,FNo,i+2);
      PutBusinessStartBalanceInProjection(RetNo,AsOfYear,
      BusIncorp,BusNonIncorp,Other,BusIncorpOrigCost,BusNonIncorpOrigCost,OtherOrigCost);
      Inc(i,9);
    until i>120;

    //Busincorp
    i:=129;
    Repeat
      BusIncorpOrigCost:=BusIncorpOrigCost+Vl(FetchElmFNo(RetNo,FNo,i));
      BusIncorp:=BusIncorp+Vl(FetchElmFNo(RetNo,FNo,i+1));
      //AsOfYear:=FetchElmFNo(RetNo,FNo,i+2);
      PutBusinessStartBalanceInProjection(RetNo,AsOfYear,
       BusIncorp,BusNonIncorp,Other,
       BusIncorpOrigCost,BusNonIncorpOrigCost,OtherOrigCost);
      Inc(i,9);
    until i>200;
   end; //has data
  end; //k
end;



Procedure  PutFixedAssetsStartBalanceInProjection(RetNo:Integer;AsOfYear:String;
       Autos,Homes,VacationPr,IncomeProp,OtherFixed,
       AutosOrigCost,HomesOrigCost,VacationPrOrigCost,IncomePropOrigCost,
       OtherFixedOrigCost:Real);

//for fixed amount contributions or withdrwals
Var I,j,FNo:integer; Sep :string; //[1];
Begin
 //For i:=0 to FixedAssetsProjectionList.Count-1 do
 For i:=0 to RetirementParms.NumbPeriods do
 begin
  FixedAssetsProjectionRec := FixedAssetsProjectionList[i];
  //Put it in any record that has year >= FromYear wich is the AsOfDate of asset/like purchase date
  If (IntToStr(FixedAssetsProjectionRec.Year) = AsOfYear) then
   begin
    FixedAssetsProjectionRec.Autos:=Autos;
    FixedAssetsProjectionRec.Homes:=Homes;
    FixedAssetsProjectionRec.VacationPr:=VacationPr;
    FixedAssetsProjectionRec.IncomeProp:=IncomeProp;
    FixedAssetsProjectionRec.OtherFixed:=OtherFixed;

    FixedAssetsProjectionRec.AutosOrigCost:=AutosOrigCost;
    FixedAssetsProjectionRec.HomesOrigCost:=HomesOrigCost;
    FixedAssetsProjectionRec.VacationPrOrigCost:=VacationPrOrigCost;
    FixedAssetsProjectionRec.IncomePropOrigCost:=IncomePropOrigCost;
    FixedAssetsProjectionRec.OtherFixedOrigCost:=OtherFixedOrigCost;
   end;
 end; //i
end;

Procedure  PutBusinessStartBalanceInProjection(RetNo:Integer;AsOfYear:String;
       BusIncorp,BusNonIncorp,Other,
       BusIncorpOrigCost,BusNonIncorpOrigCost,OtherOrigCost:Real);

//for fixed amount contributions or withdrwals
Var I,j,FNo:integer; Sep :string; //[1];
Begin
 For i:=0 to RetirementParms.NumbPeriods do //BusinessProjectionList.Count-1 do
 begin
  BusinesssProjectionRec := TBusinessProjectionRec(BusinessProjectionList[i]);
  //Put it in any record that has year >= FromYear wich is the AsOfDate of asset/like purchase date
  If (IntToStr(BusinesssProjectionRec.Year) = AsOfYear) then
   begin
    BusinesssProjectionRec.BusNonIncorp:=BusNonIncorp;
    BusinesssProjectionRec.BusIncorp:=BusIncorp;
    BusinesssProjectionRec.Other:=Other;

    BusinesssProjectionRec.BusNonIncorpOrigCost:=BusNonIncorpOrigCost;
    BusinesssProjectionRec.BusIncorpOrigCost:=BusIncorpOrigCost;
    BusinesssProjectionRec.OtherOrigCost:=OtherOrigCost;
   end;
 end; //i
end;


Function GetMonthyMortgage(Principal:Real;Interest:Real;Years:Integer;Compounding:Integer):Real;
var
 Periods:Integer;
 mif      :double;
 Q     :double;
begin
 Result:=0;
 If (Years=0) or (Principal=0) then exit;
 Periods := Years* 12;
 mif := 1 + interest/(100 * Compounding);
 mif := XToY(mif,1/(12/Compounding))-1;
 if Mif>0 then
 begin
  Q := (1/mif) * ( 1 - XToY ( (1+ interest/(100*Compounding)), - (Periods/(12/Compounding))));
  Result:=Principal / Q;
 end
 else
 begin
  result:=0;
 end;
end;

procedure GetMortgageTable(Principal:Real;Interest:Real;Years:Integer;
  PeriodNoList,InterestPaidList,PrincipalPaidList,BalanceRemainingList:TStrings);
  //Var PeriodNoList:TStringList;Var InterestPaidList:TStringList;
  //Var PrincipalPaidList:TStringList;Var BalanceRemainingList:TStringList);
//assumes semi-year amortization
var
 Periods:Integer;
 mif      :double;
 Code,i     :Integer;
 InterestPaid        :double;
 PrincipalPaid       :double;
 Payment:Real;
 BalanceRemaining, Q     :double;
 S                   :String;
Mstr,Istr, Pstr, Bstr     :String [15];
begin
If Interest=0 then interest:=0.000000001;
If (Years=0) or (Principal=0) then exit;
Payment:=0;
Periods := Years* 12;
BalanceRemaining:=Principal;
mif := 1 + interest/200;
mif := XToY(mif,1/6)-1;
Q := (1/mif) * ( 1 - XToY ( (1+ interest/200), - (Periods/6)));
Payment := BalanceRemaining / Q;

mif := 1 + interest/200;
mif := XToY(mif,1/6)-1;

PeriodNoList.Clear;
InterestPaidList.Clear;
PrincipalPaidList.Clear;

for i := 1 to periods do
begin
  InterestPaid:=mif * BalanceRemaining;
  PrincipalPaid:=Payment - InterestPaid;
  BalanceRemaining := BalanceRemaining - PrincipalPaid;
  Str (InterestPaid:15:2, Istr);
  Str (PrincipalPaid:15:2, Pstr);
  Str (BalanceRemaining:15:2, Bstr);
  Str (i:3, Mstr);
  PeriodNoList.Add(Mstr);
  InterestPaidList.Add(Istr);
  PrincipalPaidList.Add(PStr);
  BalanceRemainingList.Add(Bstr);
 end;
end;

procedure GetPaymentsTable(Principal:Real;Interest:Real;Years:Integer;
  PeriodNoList,InterestPaidList, PrincipalPaidList,BalanceRemainingList:TStrings);
  //Var PeriodNoList:TStringList;Var InterestPaidList:TStringList;
  //Var PrincipalPaidList:TStringList;Var BalanceRemainingList:TStringList);
//assumes yearly amortization
var
 Periods:Integer;
 mif      :double;
 Code,i     :Integer;
 InterestPaid        :double;
 PrincipalPaid       :double;
 Payment:Real;
 BalanceRemaining, Q     :double;
 S                   :String;
Mstr,Istr, Pstr, Bstr     :String [15];
begin
 If (Years=0) or (Principal=0) then exit;
 Payment:=0;
 Periods := Years* 12;
 BalanceRemaining:=Principal;
 mif := 1 + interest/100;
 mif := XToY(mif,1/12)-1;
 If Mif>0 then
 begin
 Q := (1/mif) * ( 1 - XToY ( (1+ interest/100), - (Periods/12)));
 Payment := BalanceRemaining / Q;
 end
 else
 begin
  Payment:=0;
 end;
 mif := 1 + interest/100;
 mif := XToY(mif,1/12)-1;

 PeriodNoList.Clear;
 InterestPaidList.Clear;
 PrincipalPaidList.Clear;

 for i := 1 to periods do
 begin
   InterestPaid:=mif * BalanceRemaining;
   PrincipalPaid:=Payment - InterestPaid;
   BalanceRemaining := BalanceRemaining - PrincipalPaid;
   Str (InterestPaid:15:2, Istr);
   Str (PrincipalPaid:15:2, Pstr);
   Str (BalanceRemaining:15:2, Bstr);
   Str (i:3, Mstr);
   PeriodNoList.Add(Mstr);
   InterestPaidList.Add(Istr);
   PrincipalPaidList.Add(PStr);
   BalanceRemainingList.Add(Bstr);
 end;
end;

Function IsT1Installed:Boolean;
Begin
  Result:=False;
  If FileExists(GetT1ProgramCommand) then result:=True;
end;

Function GetDedLimit(EarnedInc,PriorYrPA,PriorYrUnusedRoom:Real;Year:Integer):Real;
begin
 Result:=MaxR(0,
  MinR(EarnedInc * 0.18,GetDollarLimit(Year)-PriorYrPA+PriorYrUnusedRoom));

end;

Function GetDollarLimit(Year:Integer):Real;
Var
  DollarLimit: Array[0..100] of real;
  i, Yr:Integer;
begin
 Result:=0;
 If Year<2002 then exit;
 If Year=2002 then Result:=13500
 else if Year=2003 then result:=14500
 else if Year=2004 then result:=15500
 else if Year=2005 then result:=16500
 else if Year=2006 then result:=18000
 else if Year=2007 then result:=19000
 else if Year=2008 then result:=20000
 else if Year=2009 then result:=21000
 else if Year=2010 then result:=22000
 else
 begin
  DollarLimit[0]:=22000; //as of 2010
  i:=0;
  Repeat
   DollarLimit[i+1]:=DollarLimit[i] * 1.03198;
   Result:=DollarLimit[i+1];
   Inc(i);
  until i>Year-2010;
 end;
end;

Function CalcEstimatedTax(TotIncome:Real;Dividends:Real):Real;
Var TempList:TStringList;
  IncArray:Array of real;
  TaxArray:Array of real;
  i: integer;
begin
 Templist:=TsTringList.Create;
 TempList.LoadFromFile(Appdir+'\'+'TaxRates.d');
 SetLength(IncArray, TempList.count);
 SetLength(TaxArray, TempList.count);
 For i:=0 to TempList.Count-1 do
 begin
   IncArray[i]:= Vl(AllTrim(LeftStr(TempList[i],11)));
   TaxArray[i]:= Vl(AllTrim(MidStr(TempList[i],12,8)));
 end;

 For i:=0 to High(IncArray) do
 begin
  If TotIncome<IncArray[i] then begin result:=0;exit;end;
  If (TotIncome>=IncArray[i]) and (TotIncome<IncArray[i+1]) then
  begin
   If TaxArray[i+1]-TaxArray[i]>0 then
   begin
    result:=MaxR(0,
      TaxArray[i]
     +(TaxArray[i] * ((TotIncome-IncArray[i])/ (TaxArray[i+1]-TaxArray[i])))/100
     -Dividends * 0.20);    //13.33 + 5.10 for provincial
    Exit;
   end
   else
     result:=MaxR(0,
      TaxArray[i]-Dividends * 0.1843);    //13.33 + 5.10 for provincial
   exit;
  end;
 end;

end;

//20170901 Igor>>>
//Function ExceedsMaxReturnsAllowed:Boolean;
//begin
// Result:=false;
// If IsDemoVersion then
// begin
//   If CountDBRecords > 1 then
//   begin
//    result:=True;
//    Exit;
//   end;
// end;
//
// If IsLimitedVersion then
// begin
//   If CountDBRecords > LimitedVersionReturns then
//   begin
//    result:=True;
//    Exit;
//   end;
// end;
//
//end;
//
//Function CountDBRecords:Integer;
//Var ADConnection: TADConnection;
//    Table1: TADTable;
//begin
//  //20150922 Igor
//  ADConnection:= TADConnection.Create(Application);
//  Table1 := TADTable.Create(Application);
//  SetTableName(ADConnection, Table1, OptRec.Dir_Cur + '\' + ClientsDBLite, ClientsTableLite, '');
//
//  Result :=Table1.RecordCount;
//  Table1.Close;
//  Table1.Free;
//  ADConnection.Free;
//end;
//20170901 Igor<<<

Function StripInstNo(FormName: String): string;
var   {T4#1  yields T4}
i :integer;
begin
 i := 1;
 while (i <= Length(FormName)) and not (FormName[i] ='#') do inc(i);
 Result := copy(FormName,1,i-1);
end;

Function GetDefaultDataBaseDir:String;
begin
 Result:='C:\FpClients0'+RightStr(AppYear,1);
end;

// ***************
Function GetOntTCD(RetNo:Integer):Real;
begin
 Result:=Vl(FetchElm(RetNo,'OPG_10',41));
end;

Procedure SaveScreenSettings(Sc:Real;ScChar:Real;ScChange:Real;LeftPanelWidth:LongInt);
Var TempList:TStringList;
begin
 TempList:=TStringList.Create;
 TempList.Add(FormatFloat('##.##',Sc));
 TempList.Add(FormatFloat('##.##',ScChar));
 TempList.Add(FormatFloat('##.##',ScChange));
 TempList.Add(IntToStr(LeftPanelWidth));
 TempList.SaveToFile(AppDir+'\'+'ScrSize.d');
 TempList.Free;
end;

Procedure GetScreenSettings(Var Sc:Real;Var ScChar:Real;Var ScChange:Real;Var LeftPanelWidth:LongInt);
Var TempList:TStringList;
begin
 Sc:=1;ScChar:=1;ScChange:=0;LeftPanelWidth:=Screen.Width div 7;
 TempList:=TStringList.Create;
 If FileExists(AppDir+'\'+'ScrSize.d') then
 begin
  TempList.LoadFromFile(AppDir+'\'+'ScrSize.d');
  Sc:=Vl(TempList[0]);
  ScChar:=Vl(TempList[1]);
  ScChange:=Vl(TempList[2]);
  LeftPanelWidth:=MyStrToInt(TempList[3]);
 end;
 TempList.Free;
end;

Procedure InitMostRecentFiles(HowMany:Integer);
//20171201 Igor>>>
var
  i: Integer;
  s: string;
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
        SqlLoadDBFromFile(ADConnection, AQuery, OptRec.Dir_Cur + '\' + ClientsDBLite, '');
        if ADConnection.Connected then
        begin
          with AQuery do
          begin
            SQL.Add('Select * from ' + ClientsTableLite);
            Sql.Add(' ORDER BY Updated_Dt DESC');
            Prepare;
            open;
            First;
            while not EOF do
            begin
              s := PaddR(AllTrim(AQuery.FieldByName('First_Name').AsString) + ' ' +
                AllTrim(AQuery.FieldByName('Last_Name').AsString), 30) + ' ' +
                PaddR(AQuery.FieldByName('Updated_Dt').AsString, 10) + ' ' +
                PAddR(AQuery.FieldByName('Updated_tm').AsString, 10) + ' ' +
                PAddR(AQuery.FieldByName('File_Name').AsString, 15);
              TempList.Add(s);
              if TempList.Count > HowMany then
                break;
              Next;
            end;
          end;
        end;
      finally
        AQuery.Close;
        AQuery.Free;
        ADConnection.Free;
      end;
    except
      on E: Exception do
        MessageDlg(E.Message, mtError, [mbok], 0);
    end; //except
    for i := 0 to TempList.Count - 1 do
      TempList[i] := TempList[i] + ' ' + OptRec.Dir_Cur;  //add the dir
    TempList.SaveToFile(AppDir + '\' + RecentFlName);
  finally
    TempList.Free;
  end;
//20171201 Igor<<<
end;

Procedure UpdateMostRecentFiles(RetNo:Integer;Dir,FlName,Sin:String);
Var i,k,MaxReturns:Integer;
  //TempList1,TempList2:TStringList;
  TempList1:TMyStringList;
  s:String;
Begin
  TempList1:=TMyStringList.Create;
  If FileExists(AppDir+'\'+RecentFlName) then
  TempList1.LoadFromFile(AppDir+'\'+RecentFlName);
  //20160321 Igor
  s := RecentQuoteChar + AllTrim(GetFirstName(RetNo)) + ' ' + AllTrim(GetLastName(RetNo)) + RecentQuoteChar+RecentDelimiter +
       RecentQuoteChar + FormatDateTime('yyyy-mm-dd',Date) + RecentQuoteChar + RecentDelimiter +
       RecentQuoteChar + TimeToStr(Now) + RecentQuoteChar + RecentDelimiter +
       RecentQuoteChar + FlName + RecentQuoteChar + RecentDelimiter +
       RecentQuoteChar + Dir + RecentQuoteChar;
  //First remove it if it exists
  k:=IsInMostRecentReturns(FlName,TempList1);
  If K>-1 then TempList1.Delete(k);
  //then add it as first
  TempList1.Insert(0, s);
  //TempList1.Capacity := 30;
  if TempList1.Count > 30 then
    TempList1.Count := 30;
  TempList1.SaveToFile(AppDir+'\'+RecentFlName);
  TempList1.Free;
  MainFormFP.ShowMostRecentReturns;
end;

Function IsInMostRecentReturns(FlName: String; MostRecentList: TstringList): Integer; //20170313 Igor
var
  i: Integer;
  SL: TStringList;
  function GetFileName(ALine: String): string;
  begin
    SL.DelimitedText := ALine;
    if SL.Count >= 4 then
      Result := SL[3]
    else
      Result := '';
  end;
begin
  If MostRecentList.Count = 0 then
    exit(-1);
  FlName := AllTrim(FlName);
  SL := TStringList.Create;
  try
    SL.Delimiter := RecentDelimiter;
    SL.QuoteChar := RecentQuoteChar;
    For i := 0 to MostRecentList.Count-1 do
      if SameText(GetFileName(MostRecentList[I]), FlName) then //20170313 Igor
        Exit(I);
    Result := -1;
  finally
    SL.Free;
  end;
end;

Function FormatPhoneForRSI(s:String):String;
begin
 Result:=ReplaceChar(s,' ','');
 Result:=ReplaceChar(result,'-','');
 Result := LeftStr(Result,3)+' '+MidStr(result,4,6);
 Result := AllTrim(Result);
end;

Function GetDefaultScaling:Integer;
Const OriginalWidth=800; {I designed my form in 800x600 mode.}
      OriginalHeight=600;
begin
 Result:=OptRec.FormZoom;
 If (Result =0) or (Result < 50) or (result >200) then
 Begin
  If (Screen.width <=800) then begin Result:=100;exit;end;
  Result:=Round(((Screen.Width) / OriginalWidth) * 100);
 end;
end;

Function IncrementlastBackUpDir(LastBackUp:String):String;
Var k:Integer;OldNo,NewNo:String;
begin
 OldNo:=RightStr(Lastbackup,2);
 If NumbersOnly(OldNo) then
 begin
  NewNo:=PaddZero(IntToStr(MyStrToInt(OldNo)+1),2);
  Result:=LeftStr(LastBackUp,Length(LastBackUp)-2)+NewNo;
 end
 else
  result:=ExtractFileDir(LastBackUp)+'\'+'Backup01';
end;

function GetFileList(FDirectory, Filter: TFileName): TStringList;
var
  ARec: TSearchRec;
  Res: Integer;
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

Procedure SaveSingleOption(FieldNm, Value: string; AOptionsFileName: String = ''); //20160627 Igor
Var i:Integer;TempList:TStringList;
begin
  TempList:=TStringList.Create;
  if AOptionsFileName = '' then
    AOptionsFileName := AppDir+'\'+OptionsFlName;
  //create txt if does not exist
  If Not FileExists(AOptionsFileName) then TempList.SaveToFile(AOptionsFileName);

  TempList.LoadFromFile(AOptionsFileName);
  i:=IsInList(FieldNm,TempList);
  If i>-1 then
    Templist[i]:=LeftStr(TempList[i],20)+Value
  else
    Templist.Add(PaddR(UpperCase(FieldNm),20)+Value);
  TempList.SaveToFile(AOptionsFileName);
  TempList.Free;
end;

Function FromYesToX(YesNo:String):String;
Begin
 If UpperCase(YesNo) ='Y' then result:='X' else result:='';
end;


Function StringToBoolean(AString:String):Boolean;
Begin
 If UpperCase(AString)= 'X' then result:=True else Result:=False;
end;

Procedure LoadOptionsFileToMem;
Var TempList:TstringList;
begin
 TempList:=TStringList.Create;
 TempList.LoadFromFile(AppDir+'\'+ OptionsFlName);
 With OptRec do
 begin
  //Read Values
   Dir_Cur:=GetOptionValue('Dir_Cur',TempList);
   BackUpFrequency:=GetOptionValue('BackUpFrequency',TempList);
   BackUpDir:=GetOptionValue('BackUpDir',TempList);
   LastBackUpDir:=GetOptionValue('LastBackUpDir',TempList);
   Dir_Deflt:=GetOptionValue('Dir_Deflt',TempList);
   T1DataDir:=GetOptionValue('T1DataDir',TempList);
   Dir_LastYr:=GetOptionValue('Dir_LastYr',TempList);
   Dir_PgmLastYr:=GetOptionValue('Dir_PgmLastYr',TempList); //20160704 Igor
   Dir_DBFData:=GetOptionValue('Dir_DBFData',TempList);

   Prp_Name:=GetOptionValue('Prp_Name',TempList);

   Prp_EMail:=GetOptionValue('Prp_EMail',TempList);
   Prp_BusNo:=GetOptionValue('Prp_BusNo',TempList);

   Reviewer_Name:=GetOptionValue('Reviewer_Name',TempList);
   Reviewer_EMail:=GetOptionValue('Reviewer_EMail',TempList);
   Reviewer_Area:=GetOptionValue('Reviewer_Area',TempList);
   Reviewer_Tel:=GetOptionValue('Reviewer_Tel',TempList);

   Prp_Street:=GetOptionValue('Prp_Street',TempList);
   Prp_City:=GetOptionValue('Prp_City',TempList);
   Prp_Prov:=GetOptionValue('Prp_Prov',TempList);
   Prp_Postal:=GetOptionValue('Prp_Postal',TempList);
   Prp_Countr:=GetOptionValue('Prp_Countr',TempList);
   Prp_Area:=GetOptionValue('Prp_Area',TempList);
   Prp_Tel:=GetOptionValue('Prp_Tel',TempList);
   Prp_FxArea:=GetOptionValue('Prp_FxArea',TempList);
   Prp_Fax:=GetOptionValue('Prp_Fax',TempList);
   Prp_GSTNo:=GetOptionValue('Prp_GSTNo',TempList);
   Prp_Bill:=GetOptionValue('Prp_Bill',TempList);
   Prp_VSFee:=MyStrToInt(GetOptionValue('Prp_VSFee',TempList));
   Prp_SFee:=MyStrToInt(GetOptionValue('Prp_SFee',TempList));
   Prp_AFee:=MyStrToInt(GetOptionValue('Prp_AFee',TempList));
   Prp_CFee:=MyStrToInt(GetOptionValue('Prp_CFee',TempList));
   Prp_VCFee:=MyStrToInt(GetOptionValue('Prp_VCFee',TempList));
   Prp_Hour:=Vl(GetOptionValue('Prp_Hour',TempList));

   Prp_Dates:=StringToBoolean(GetOptionValue('Prp_Dates',TempList));
   Nfl_Prov:=GetOptionValue('Nfl_Prov',TempList);
   Nfl_City:=GetOptionValue('Nfl_City',TempList);
   Capitalization:=GetOptionValue('Capitalization',TempList);

   Prn_NameH:=StringToBoolean(GetOptionValue('Prn_NameH',TempList));
   Prn_SinH:=StringToBoolean(GetOptionValue('Prn_SinH',TempList));
   Prn_DateH:=StringToBoolean(GetOptionValue('Prn_DateH',TempList));
   Opr_Close:=StringToBoolean(GetOptionValue('Opr_Close',TempList));
   Opr_GstHst:=Vl(GetOptionValue('Opr_GstHst',TempList));

  //other optios
   ShowConsultantOnInv:=StringToBoolean(GetOptionValue('ShowConsultantOnInv',TempList));
   UseFastPrint:=StringToBoolean(GetOptionValue('UseFastPrint',TempList));
   UseProperName:=StringToBoolean(GetOptionValue('UseProperName',TempList));
   NoTypeAhead:=StringToBoolean(GetOptionValue('NoTypeAhead',TempList));

   ShowVisitedForms:=StringToBoolean(GetOptionValue('ShowVisitedForms',TempList));
   ShowInvoiceWarning:=StringToBoolean(GetOptionValue('ShowInvoiceWarning',TempList));
   FirstReturnColor:=GetOptionValue('FirstReturnColor',TempList);
   //invoice footter
   InvFoot1:=GetOptionValue('InvFoot1',TempList);
   InvFoot2:=GetOptionValue('InvFoot2',TempList);
   InvFoot3:=GetOptionValue('InvFoot3',TempList);
   InvFoot4:=GetOptionValue('InvFoot4',TempList);
   InvFoot5:=GetOptionValue('InvFoot5',TempList);

   DataInBold:=StringToBoolean(GetOptionValue('DataInBold',TempList));
   NoBarCode:=StringToBoolean(GetOptionValue('NoBarCode',TempList));

   ActiveBoxColor:=StrToInt(GetOptionValue('ActiveBoxColor',TempList));
  {shared options
   HideMostRecent:=StringToBoolean(GetOptionValue('HideMostRecent',TempList));
   Prn_LMargin:=GetOptionValue('Prn_LMargin',TempList);
   Prn_RMargin:=GetOptionValue('Prn_RMargin',TempList);
   Prn_FontIncr:=GetOptionValue('Prn_FontIncr',TempList);
   UpdateFrequency:=GetOptionValue('UpdateFrequency',TempList);
  }
  GetOverloadedProperty; //20170112 Igor
end;
 TempList.Free;
end;

Procedure InitOptions; //20160627 Igor
begin
  //20190213 Igor >>>
  if CheckIsCloud(true) then
    //if not SameText(CloudDataDir, '') then //20190306 Igor
      SetDefaultOptions;
  //20190213 Igor <<<

  If Not FileExists(AppDir+'\'+OptionsFlName) then
  begin // if first run - try convert from old program
    if not ConvertToMultiApp(AppFP) then
    begin //if no old program or user cancel - load default param values
      SetDefaultOptions;
      LoadOptionsFileToMem;  //from txt to optrec
    end
  end
  else
    LoadOptionsFileToMem;  //from txt to optrec
end;

function BuildValue(ASource: String): String; //20160530 Igor
Begin
//20171204 Igor>>>
  if pos(c_DefDataDir,ASource)>0 then
    Result := StringReplace(ASource, c_DefDataDir, DefaultDataDir(AppFP), [rfReplaceAll,rfIgnoreCase])
//20171204 Igor<<<
  else
    Result := ASource;
  Result := Result;
End;

Function GetDefaultOptionsValue(const AOptionsName: String): String; //20160627 Igor
var
  I: Integer;
Begin
  for I := Low(OptionsArray) to High(OptionsArray) do
    if SameText(OptionsArray[I,0],AOptionsName) then
    Begin
      Result := BuildValue(OptionsArray[I, 1]);
      exit;
    End;
  Result := '';
End;

function GetDefaultOptions: TStringList; //20160627 Igor
var
  I: Integer;
  N,V: String;
Begin
  Result := TStringList.Create;
  for I := Low(OptionsArray) to High(OptionsArray) do
    if SameText(OptionsArray[I,3],'X') then
    begin
      N := OptionsArray[I,0];
      V := BuildValue(OptionsArray[I,1]);
      if V <> '' then
        Result.Values[N] := V
      else
        Result.Add(N+'=');
    end;
End;

function GetOptionsCaption(AOptionsName: String): String; //20160627 Igor
var
  I: Integer;
Begin
  for I := Low(OptionsArray) to High(OptionsArray) do
    if SameText(OptionsArray[I,0],AOptionsName) then
    Begin
      Result := OptionsArray[I, 2];
      if Result = '' then
        Result := AOptionsName;
      exit;
    End;
  Result := AOptionsName;
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

Procedure SetDefaultOptions; //20160523 Igor //20160627 Igor
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

// lSaveSingleOption('Opr-GstHst','6');
// lSaveSingleOption('Prp_Bill','2');
// lSaveSingleOption('Prp_VSFee','100');
// lSaveSingleOption('Prp_SFee','150');
// lSaveSingleOption('Prp_AFee','200');
// lSaveSingleOption('Prp_CFee','300');
// lSaveSingleOption('Prp_VCFee','400');
// lSaveSingleOption('Prp_Hour','60');
////display
// lSaveSingleOption('FormZoom',IntToStr(GetDefaultScaling));
// lSaveSingleOption('ActiveBoxColor',IntToStr(Rgb(255,128,128)));
// lSaveSingleOption('FirstReturnColor',IntToStr(RGB(195,255,255)));
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
//
// lSaveSingleOption('ShowFinWarning','');
// lSaveSingleOption('ShowConsultantOnInv','');
// lSaveSingleOption('UseFastPrint','');
// lSaveSingleOption('UseProperName','X');
//
// lSaveSingleOption('NoTypeAhead','');
// lSaveSingleOption('ShowInvoiceWarning','X');
// lSaveSingleOption('ShowSaluteWarning','X');
//
// lSaveSingleOption('UpdateFrequency','7');
// lSaveSingleOption('Nfl_Efile','X');
// lSaveSingleOption('Nfl_Prov','ON');
// lSaveSingleOption('Nfl_City','TORONTO');
//
// lSaveSingleOption('Capitalization','UpperCase');
// lSaveSingleOption('RolloverProgram','VisualTax');
//
// if assigned(APrevOptions) then
//   CompareOptions(APrevOptions, AppDir+'\'+OptionsFlName);

end;

Procedure ConvertCfgToOptionsFile(CfgTbl:TDataSet);
Var TempList,TempList1:TStringList;
begin
 With CfgTbl do
 Begin
   FormatSettings.DecimalSeparator:='.';     //20150819  Igor
   TempList:=TStringList.Create;
   SaveOptionValue('Dir_Cur',FieldByName('Dir_Cur').AsString,TempList);
   SaveOptionValue('Dir_Deflt',FieldByName('Dir_Deflt').AsString,TempList);
   SaveOptionValue('Dir_LastYr',FieldByName('Dir_LastYr').AsString,TempList);
   SaveOptionValue('Dir_PrvLYr',FieldByName('Dir_PrvLYr').AsString,TempList);
   SaveOptionValue('Dir_Train',FieldByName('Dir_Train').AsString,TempList);
   SaveOptionValue('Dir_Sample',FieldByName('Dir_Sample').AsString,TempList);
   SaveOptionValue('Dir_DBFData',FieldByName('Dir_DBFData').AsString,TempList);

   SaveOptionValue('Prp_Name',FieldByName('Prp_Name').AsString,TempList);

   SaveOptionValue('Prp_Street',FieldByName('Prp_Street').AsString,TempList);
   SaveOptionValue('Prp_City',FieldByName('Prp_City').AsString,TempList);
   SaveOptionValue('Prp_Prov',FieldByName('Prp_Prov').AsString,TempList);
   SaveOptionValue('Prp_Postal',FieldByName('Prp_Postal').AsString,TempList);
   SaveOptionValue('Prp_Countr',FieldByName('Prp_Countr').AsString,TempList);
   SaveOptionValue('Prp_Area',FieldByName('Prp_Area').AsString,TempList);
   SaveOptionValue('Prp_Tel',FieldByName('Prp_Tel').AsString,TempList);
   SaveOptionValue('Prp_FxArea',FieldByName('Prp_FxArea').AsString,TempList);
   SaveOptionValue('Prp_Fax',FieldByName('Prp_Fax').AsString,TempList);
   SaveOptionValue('Prp_DiscNo',FieldByName('Prp_DiscNo').AsString,TempList);
   SaveOptionValue('Prp_DiscNm',FieldByName('Prp_DiscNm').AsString,TempList);
   SaveOptionValue('Prp_GSTNo',FieldByName('Prp_GstNo').AsString,TempList);
   SaveOptionValue('Prp_VSFee',IntToStr(FieldByName('Prp_VSFee').AsInteger),TempList);
   SaveOptionValue('Prp_SFee',IntToStr(FieldByName('Prp_SFee').AsInteger),TempList);
   SaveOptionValue('Prp_AFee',IntToStr(FieldByName('Prp_AFee').AsInteger),TempList);
   SaveOptionValue('Prp_CFee',IntToStr(FieldByName('Prp_CFee').AsInteger),TempList);
   SaveOptionValue('Prp_VCFee',IntToStr(FieldByName('Prp_VCFee').AsInteger),TempList);
   SaveOptionValue('Prp_Kstrk',FormatFloat('######.##',FieldByName('Prp_Kstrk').AsFloat),TempList);
   SaveOptionValue('Prp_Hour',FormatFloat('######.##',FieldByName('Prp_Hour').AsFloat),TempList);
   SaveOptionValue('Prp_Bill',FieldByName('Prp_Bill').AsString,TempList);

   SaveOptionValue('Prp_Elect',BooleanToString(Boolean(FieldByName('Prp_Elect').AsInteger)),TempList);
   SaveOptionValue('Prp_EfRepr',BooleanToString(Boolean(FieldByName('Prp_EfRepr').AsInteger)),TempList);
   SaveOptionValue('Prp_Dates',BooleanToString(Boolean(FieldByName('Prp_Dates').AsInteger)),TempList);

   SaveOptionValue('Nfl_Prov',FieldByName('Nfl_Prov').AsString,TempList); {New File defqaults}
   SaveOptionValue('Nfl_City',FieldByName('Nfl_City').AsString,TempList);
   SaveOptionValue('Nfl_Disced',FieldByName('Nfl_Disced').AsString,TempList);
   SaveOptionValue('Nfl_Efile',BooleanToString(Boolean(FieldByName('Nfl_EFile').AsInteger)),TempList);

   SaveOptionValue('Prn_Shade',BooleanToString(Boolean(FieldByName('Prn_Shade').AsInteger)),TempList);
   SaveOptionValue('Prn_Head',BooleanToString(Boolean(FieldByName('Prn_Head').AsInteger)),TempList);
   SaveOptionValue('Prn_NameH',BooleanToString(Boolean(FieldByName('Prn_NameH').AsInteger)),TempList);
   SaveOptionValue('Prn_SinH', BooleanToString(Boolean(FieldByName('Prn_SinH').AsInteger)),TempList);
   SaveOptionValue('Prn_DateH',BooleanToString(Boolean(FieldByName('Prn_DateH').AsInteger)),TempList);
   SaveOptionValue('Prn_Disclm',FieldByName('Prn_Disclm').AsString,TempList);
   SaveOptionValue('Prn_Logo',BooleanToString(Boolean(FieldByName('Prn_Logo').AsInteger)),TempList);
   SaveOptionValue('Opr_Recalc',BooleanToString(Boolean(FieldByName('Opr_Recalc').AsInteger)),TempList);
   SaveOptionValue('Opr_Close', BooleanToString(Boolean(FieldByName('Opr_Close').AsInteger)),TempList);
   SaveOptionValue('Opr_FPres', IntToStr(FieldByName('Opr_FPres').AsInteger),TempList);
   SaveOptionValue('Opr_GSTHst',FormatFloat('######.##',FieldByName('Opr_GSTHst').AsFloat),TempList);

    //other options
   TempList1:=TStringList.Create;
   If FileExists(AppDir+'OthOpt.d') then
   Begin
    TempList1.LoadFromFile(AppDir+'OthOpt.d');
    SaveOptionValue('ShowFinWarning',FromYesToX(TempList1[1]),TempList);
    SaveOptionValue('ShowConsultantOnInv',FromYesToX(TempList1[2]),TempList);
    SaveOptionValue('UseFastPrint',FromYesToX(TempList1[3]),TempList);
    SaveOptionValue('UseProperName',FromYesToX(TempList1[3]),TempList);
    SaveOptionValue('UseFormSearch',FromYesToX(TempList1[4]),TempList);
    SaveOptionValue('OtherSlipsButtons',FromYesToX(TempList1[4]),TempList);
    SaveOptionValue('UseBusUseOfHome',FromYesToX(TempList1[5]),TempList);
    SaveOptionValue('RolloverT4T5',FromYesToX(TempList1[6]),TempList);
    SaveOptionValue('ShowVisitedForms',FromYesToX(TempList1[7]),TempList);
    SaveOptionValue('ShowInvoiceWarning',FromYesToX(TempList1[8]),TempList);
    SaveOptionValue('ShowInvoiceEfCharge',FromYesToX(TempList1[9]),TempList);
    SaveOptionValue('ShowSaluteWarning',FromYesToX(TempList1[10]),TempList);
    SaveOptionValue('CVSetting',TempList1[11],TempList);
    SaveOptionValue('T1013AuthorLevel',TempList1[12],TempList);
  end;
  //update frequency
  TempList1.Clear;
  If FileExists(AppDir+'\'+'UpdSch.Txt') then
  begin
   TempList1.LoadFromFile(AppDir+'\'+'UpdSch.Txt');
   SaveOptionValue('UpdateFrequency',TempList1[0],TempList);
  end;

  //Ef_method
  TempList1.Clear;
  If FileExists(AppDir+'\'+'EfMethod.d') then
  begin
   TempList1.LoadFromFile(AppDir+'\'+'EfMethod.d');
   SaveOptionValue('Ef_Method',TempList1[0],TempList);
  end;

  //Inv Footer
  TempList1.Clear;
  If FileExists(AppDir+'\'+'InvFoot.d') then
  begin
   TempList1.LoadFromFile(AppDir+'\'+'InvFoot.d');
   SaveOptionValue('InvFoot1',TempList1[0],TempList);
   SaveOptionValue('InvFoot2',TempList1[1],TempList);
   SaveOptionValue('InvFoot3',TempList1[2],TempList);
   SaveOptionValue('InvFoot4',TempList1[3],TempList);
   SaveOptionValue('InvFoot5',TempList1[4],TempList);
  end;
 End; //with
 TempList.SaveToFile(AppDir+'\'+OptionsFlName);
 TempList.Free;
 TempList1.Free;
end;

Function IsFormTheDefaultSearch:Boolean;
Var TempList:TStringList;s:String;
begin
  Result:=OptRec.UseFormSearch;
end;

Function ValidShortProvince(s:string):Boolean;
Var i:integer;
begin
 result := false;
 For i:=Low(PrvShort) to High(PrvShort) do
  If s = PrvShort[i] then begin result :=true;exit;end
end;

Procedure IsAnyWhereInList(Astring:String; AList: TstringList; ResultsList:Tstrings);
var i,j,LengthOfKeyWord:Integer;S:String;
begin
   j:=0;
   AString:=UpperCase(AllTrim(AString));
   LengthOfKeyWord:=Length(AString);
   For i := 0 to AList.Count-1 do
   begin
    j:=Pos(AString,UpperCase(AList[i]));
    If j>0 then
    begin
     s:=PaddR(AllTrim(IntToStr(i)),4);
     ResultsList.Add(s+AList[i]);
    end;
   end;
end;


Function IsExactlyInList(Astring:String; SomeList: TstringList):Integer;
var i:Integer;
begin
   Result := -1;
   For i := 0 to SomeList.Count-1 do
   if AllTrim(Astring) = AllTrim(SomeList[i]) then
    begin
     Result := i;
     exit;
    end;
end;

Function IsOkToOpenReturn(DataDir:String;FlName:String;Sin:String):Boolean;
Var s:String;
Begin
 Result:=False;
 If FlName = '' then exit;
 If Not FileExists(DataDir+'\'+ClientsDBLite) AND  //20150922 Igor
    Not FileExists(DataDir+'\'+ClientsTable_dbf)  then //20170412 Igor
 begin
  showMessage('Data directory has not been defined'+
  Chr(13)+'Use Configure -> General Options -> Data Directories');
  exit;
 end;

 If IsDataDirectoryGood(DataDir) = False then exit;
//20170901 Igor>>>
 If AppFP.ExceedsMaxReturnsAllowed(False) then
  begin
//   ShowMessage('Number of files exceeds maximum allowed '
//   +'('+IntToStr(LimitedVersionReturns)+')'+
//   Chr(13)+' in the FP Limited version'
//   +Chr(13)+'Please delete some FP files');
   Exit;
  end;
  //20170901 Igor<<<

 (*
 If IsRetInMemory(Sin)>0 then
 begin
  if MessageDlg('File for the same SIN is already in memory.'+chr(13)+'Create duplicate copy?',
    mtInformation, [mbYes, mbNo], 0) = mrNo then exit;
 end;
 *)
 Result:=True;
end;

Function AllowedToFormPrint(RetNo:Integer):Boolean;
begin
 result := True;
 If (LicenseLevel in anyMulti) and (Ret[RetNo].Changed) then
 begin
    ShowMessage('Please save file first or enter the ADMIN password');
//    if YouknowTheAdminPassword then begin result:=True;exit;end;
    Result := False;
 end;
end;

Function CreateNewDataDir:String;
var
DataDir : string; //[60];
ThisResult : integer;
ClickedOK: Boolean;
begin
  If LicenseLevel=llLimited then
    DataDir:=LimitedVersionDir
  else
   DataDir := Appdir+'\Data';
  DataDir := InputBox('Create Data Directory','Enter Full path', DataDir);
  ThisResult := CreateDataDirectory(AppDir,DataDir);
  Case ThisResult of
         0: ShowMessage('Directory successfully created');
        -1: ShowMessage('Directory already exists!');
        -2: ShowMessage('Directory already contains a client data base');
        -3: ShowMessage('Directory cannot be created');
        -4: ShowMessage('Cannot initialize the Data Base');
        -5: ShowMessage('You must use a sub-directory i.e. D:\xxx');
   end;
   If ThisResult=0 then Result:=DataDir else Result :='';
end;

Function AllowedToFullPrint(RetNo:Integer):Boolean;
begin
 result := True;
 If LicenseLevel in anyMulti then
 begin
   If (Ret[RetNo].Changed) then
   begin
    ShowMessage('Please save file first or enter the ADMIN password');
    result:= YouknowTheAdminPassword; //active in all other AppIds!?
   end;
 end;
end;

Procedure ResortFormsToPrint(FormsToPrint:TStringList);
//comes as sssnFFFFFFFFF  i.e. 1011T2124-1#1
//take the -1#1 and put it under the sss then resort
var i,k1,k2:Integer;TempList:TStringList; Rec:String;
 SeqNo:Integer;SeqNoString:String;
begin
 SeqNo:=0;  //new seq
 TempList:=TStringList.Create;

 FormsToPrint.Sorted:=False;
 For i:=0 to FormsToPrint.Count-1 do
 begin
   Rec:=FormsToPrint[i];
   k1:=Pos('_',Rec);
   K2:=Pos('#',rec);
   If (k1>0) and (k2>0) then
   begin
     Templist.Add
      (
        LeftStr(Rec,4)
       +PaddR(AllTrim(MidStr(Rec,k2,3)),3)+PaddR(AllTrim(MidStr(Rec,k1,3)),3)
       +MidStr(Rec,5,10)
       );
   end
   else
   begin
     Templist.Add
      (
       LeftStr(Rec,4)
       +Space(6)
       +MidStr(Rec,5,10)
       );
   end;
 end;

 TempList.sorted:=True;

 FormsToPrint.Clear;
 For i:=0 to TempList.count-1 do
 begin
  Rec:=TempList[i];
  FormsToPrint.Add(LeftStr(Rec,4)+MidStr(Rec,11,20));
 end;
 TempList.Free;
end;

Function CopyMoveReturn(CopyOrMove:String;FromDir:String;ToDir:String;FlName:String):Boolean;
Var ForceResult,CopyResult,InitDbResult:boolean; ReadResult:Integer;
PrpStatus,EFstatus,Notes:String;
  RetNo: integer;
begin
 Result:=False;
 CopyResult:=False;
 InitDbResult:=False;
  //20160327 Igor >>>
  If FileExists(ToDir+'\'+ClientsTable_dbf) then
  begin
    ShowMessage(ToDir + CHR(13)
              +'The data directory is NOT compatible with the Multi-App version.'+#13+
               'Please use another data directory, such as ' + OptRec.Dir_Cur  +' in the Copy/Move return window');
    exit;
  end;
  //20160327 Igor <<<<
 If Not DirectoryExists(ToDir) then
 begin
  ForceResult:=ForceDirectories(ToDir);
  If ForceResult=False then Exit;
 end;
 CopyResult:=CopyFile(FromDir+'\'+FlName,ToDir+'\'+FlName);
 If CopyResult= false then exit;
 // init db if not thre
 If Not FileExists(ToDir+'\'+ClientsDBLite) then //20150922 Igor
 begin
   InitDbResult:=InitDataBase(AppDir,ToDir);
   if InitDbResult = false then Exit;
 end;
 //read file
 RetNo:=ReadReturn(ToDir,FlName);
 If RetNo < 1 then exit;

 PrpStatus := FetchElm(RetNo,'STATUS',4);
 If Not Numeric(PrpStatus) then PrpStatus :='00';
 EFStatus  := FetchElm(RetNo,'STATUS',15);
 If Not Numeric(EFStatus) then EFStatus :='00';
 Notes     := FetchElm(RetNo,'STATUS',14);
 UpdateClientsTable(RetNo,ToDir,FlName);
 UpdateMostRecentFiles(RetNo,ToDir,FlName,'');
 //If RetNo >0 then
 RemoveReturnFromMemory(RetNo);
 If CopyOrMove='M' then DeleteReturn(FromDir,FlName);
 Result:=True;
end;

Function RealNumeric(S:string):Boolean;
Var i:integer;
begin
 If s ='' then begin Result := false;exit;end;
 For i:= 1 to Length(S) do
 If S[i] in ['.','0','1','2','3','4','5','6','7','8','9'] then
   Result := True
  else
   begin Result := False;Exit; end;
end;

Function ValidEMail(s:String):Boolean;
Begin
 Result:=True;
 If s='' then Exit;
 if (Pos('@',s) <= 0)
 or (Pos('.',s) <= 0) Then result:=False;
end;

Function GetAnyPathMoreThan8Chars(Dir:String):String;
Var i:integer;Wlist:TStringList;
{returns dir part that is more than 8 chars, else nil}
begin
 Result := '';
 Wlist := TStringList.Create;
 ParseWords(Dir,'\',WList);
 For i:=0 to Wlist.count-1 do
 begin
  If Length(wlist[i]) >8 then
  begin
   Result:=WList[i];
   Wlist.Free;
   exit;
  end;
 end;
 Wlist.Free;
end;

Function IsFormAClientLetter(FName:String):Boolean;
begin
 Result:=False;
 If (FName='CLETTER')
 or (FName='EXECSUM')
 or (FName='PIPEDA')
 or (FName='ENGAGE')
 or (FName='CUSTINV')
 or (FName='ALETTER')  //for miscellaneous letters
 then result:=True;
end;

function isCollectionForm(const AFormName: String): Boolean;//20170409 Igor
begin
  Result := SameText(AFormName, 'ASSETSUM') or
            SameText(AFormName, 'LIABSUM');
end;

Function GetDfmFormsDir:String;
begin
 If IsDevelopmentMode then
  Result:=AppDir+'\'+'FPForms'
 else
  Result:=AppDir;
end;

Function IsInvoiceLocked(RetNo:Integer):Boolean;
begin
 Result:=False;
 //????
 If UpperCase(FetchElm(RetNo,'INV_2',85))= 'Y' then result:=True;
end;

procedure BuildSuperEntries(FullFlName:String);
Var i,j:Integer;DataList,ElmList,TempList:TStringList;
    Dir,S:String;
begin
EXIT;
end;

Function FieldHasAddingTape(RetNo:Integer;FName:String;Elm:Integer):Boolean;
Begin
  Result:=False;
end;

function GetFormAbrevNameWithNoInst(FormNo: integer):String;
var
 i: Integer;
 begin
 Result := '';
  for i :=0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      if (FRec.FormNo = FormNo) then
        Result := FRec.FormAbrev;
    end;
 end;

Procedure GetElmsInError(RetNo:Integer;FName:String);
Var i:Integer;AuditFName:String;
begin
 ElmsInError.Clear;
 FName:=AllTrim(UpperCase(FName));
 For i:=0 to Ret[RetNo].AuditList.count-1 do
 begin
  //AuditFname:=AllTrim(UpperCase(MidStr(Ret[RetNo].AuditList[i],60,10)));
  AuditFname:=AllTrim(UpperCase(Ret[RetNo].AuditRec[i].Form));
  If FName=AuditFName then
  begin
    ElmsInError.Add(IntToStr(Ret[RetNo].AuditRec[i].Elm)
         +' '+Ret[RetNo].AuditRec[i].Description);
  end;
 end;
end;

Procedure GetFrmDataListFromFullDataList(FrmNm:String;DataList,FrmDataList:TStringList);
//data list is image of disk file
Var i,j,ElmNo:Integer;
     WList:TstringList;
     Rec:String;
begin
 //????
 Try
  j:=0;
  FrmDataList.Clear;
  If LeftStr(DataList[0],2) <> 'FP' then exit;
  WList:=TstringList.Create;
  For i:=1 to DataList.Count-1 do
  begin
   Rec:=DataList[i];
   ParseWords(Rec+delimiter,Delimiter,WList);
   If (WList[0] = 'F') and (WList[1]=FRmNm) then  //found frm record
   begin
    //j:=i+1;
    For j:=i+1 to DataList.Count-1 do
    begin
     Rec:=DataList[j];
     ParseWords(Rec+Delimiter,Delimiter,WList);
     If LeftStr(Rec,2)='F'+Delimiter then Exit;
     If (WList[0]='D') then FrmDataList.Add(Rec);
    end;
   end;  //frm found
  end; //i
 except
  ShowMessage(rec);
 end; //try
end;


Function LinkToSelf(InitialFormName:String;TargetFormName:String):Boolean;
begin
 Result:=False;
 If ExtractFormRootName(InitialFormName)=ExtractFormRootName(TargetFormName)
 then Result:=True;
end;

Function GetLetterFileName(RetNo:Integer;FName:String):String;
Begin
 If FName='CLETTER' then Result := AppDir+'\'+'CLetter.RTF';
 If FName='EXECSUM' then Result := AppDir+'\'+'ExecSum.RTF';
 If FName='PIPEDA' then Result := AppDir+'\'+'PIPEDALetter.RTF';
 If FName='ENGAGE' then Result := AppDir+'\'+'EngagementLetter.RTF';
 //If FName='CUSTINV' then Result := AppDir+'\'+'CustInvLetter.RTF';
 If FName='ALETTER' then Result := AppDir+'\'+SomeLetterName;  //global variable
End;

function GetInterpretedRichEdit(RetNo:Integer;LetterName:String;ARichEdit:TRichEdit): Boolean; //20160819 igor
Var i,j:integer; ErrorC : boolean;txt:string;
   Memo1:TMemo;KeyWList:TStringList;
   TempFileName :String;
   EkRtf1:TEkRtf;
   AStream:TMemoryStream;
   KeyW:String;
   FName,FName1:String;
   Elm:Integer;
   IsAmount:String;
   LineNumber:Integer;
   Args:TEkUdfArgs;
   ArgCount:Integer;
   aResult:TEkReportVariable; //TObject;
Begin
  Result := False; //20160819 Igor
 if Not FileExists(LetterName) then
 begin
  ShowMessage('Template '+LetterName +' was not found');
  Exit;
 end;
 ARichEdit.ReadOnly:=False;

 ARichEdit.Visible:=False;
 ARichedit.Lines.LoadFromFile(LetterName);
 KeyWList:=TStringList.Create;
 LoadDataDict;
 GetKeyWListFromRichEdit(ARichEdit,KeyWList);

 KeyWList.SaveToFile(AppDir+'\'+'Temp1.txt');
 With MainFormFP.EkRtf1 do
 begin
      ClearVars;
      For i:=0 to KeyWList.Count-1 do
      begin
       KeyW:=KeyWList[i];
       DataDictList.GetKeyWAttributes(KeyW,FName,Elm,IsAmount);
       FormatSettings.DecimalSeparator := '.';  //20150819  Igor
       If UpperCase(LeftStr(IsAmount,1))='Y' then
        CreateVar(KeyW,Vl(FetchElm(RetNo,FName,Elm)))

       else If KeyW='Date' then CreateVar(KeyW,DateToMonthDayYear(Date))

       else If LeftStr(KeyW,5)='Line_' then
        begin
         IsAmount:='Y';
         if Length(KeyW)=8 then  LineNumber:=StrToInt(RightStr(KeyW,3));
         if Length(KeyW)=9 then  LineNumber:=StrToInt(RightStr(KeyW,4));
          CreateVar(KeyW,Ret[RetNo].Ln[LineNumber]);
        end

       else If KeyW='This_TaxYear' then CreateVar(KeyW,AppYear)
       else If KeyW='Next_TaxYear' then CreateVar(KeyW,IntToStr(AppYearInt+1))

       else If LeftStr(KeyW,5)='Form_' then
        begin
         IsAmount:='';
         FName1:=UpperCase(AllTrim(MidStr(KeyW,6,10)));
         If FormHasInstanceIndicator(RetNo, FName1) then
           FName1:=FName1+'#1';
         If GetFormNo(FName1)>0 then
         begin
           If Ret[RetNo].FrmHasData[GetFormNo(FName1)] then
             CreateVar(KeyW,'Y')  //Form =Yes meaning has data
           else
             CreateVar(KeyW,'N');
         end;
        end  //form_
       Else
       begin
        If ((KeyW='Client_CorporateName')
         or (KeyW='Client_Address1')
         or (KeyW='Client_Address2')
         or (KeyW='Client_City')
         or (KeyW='Client_Contact'))  then
         begin
          If OptRec.UseProperName then
           CreateVar(KeyW,ConvertToProper(FetchElm(RetNo,FName,Elm)))
          else
           CreateVar(KeyW,FetchElm(RetNo,FName,Elm));
         end
        else
         CreateVar(KeyW,FetchElm(RetNo,FName,Elm));
       end;
      end;

      //NOW REPLACE $+brackets with slashes and currency function for EKRTF formating
      InsertBackFunction(ARichEdit, '$[', ']', ', 2)]') ;
      InsertBackFunction(ARichEdit, '$ [', ']', ', 2)]') ;

      ReplaceRtfDelimiters(ARichEdit, '$[' , '[fcur(' );
      ReplaceRtfDelimiters(ARichEdit, '$ [' , '[fcur(' );


      //NOW REPLACE brackets with slashes for EKRTF
      //and Put the display FIXR for formatting before streaming it
      ReplaceRtfDelimiters(ARichEdit,'[',KeyWDelimiter1);
      ReplaceRtfDelimiters(ARichEdit,']',KeyWDelimiter2);
      AddDisplayFormatToRTF(ARichEdit,KeyWList);

      ARichEdit.Visible:=True;
      KeyWList.Free;

      ARichEdit.Lines.SaveToFile(AppDir+'\'+'TempRtf.rtf'); //20160819 igor
      InFile:=AppDir+'\'+'TempRtf.rtf'; //LetterName; //20160819 igor
      AStream:=TMemoryStream.Create;
      Try
       ExecuteStream([],AStream);
       ARichEdit.Lines.LoadFromStream(AStream);
       Result := True; //20160819 Igor
      Except
        Result := False; //20160819 Igor
      end;
      AStream.Free;
 end; //with
end;

Procedure ExtractSectionLabels(FName:String;LblSectList,SomeList:TStrings);
Var i,j:Integer;s:String;
begin
  For i:=0 to LblSectList.count-1 do
  begin
     s:=LblSectList[i];
     If AllTrim(LeftStr(S,10)) = Fname then //got right rec
     begin
      If AllTrim(MidStr(s,81,15)) = '' then //it is a header rec
      begin
       SomeList.Add(S);
       For j:=i+1 to LblSectList.count-1 do //get lbls related to fname
       begin
        s:=LblSectList[j];
        If AllTrim(MidStr(S,82,10))=FName then
         SomeList.Add(s)
       else
        Exit; //begin  LblSectList.Free; Exit; end;
       end; //j
      end; //header rec
     end;  //found fname
  end;  //i
end;

Procedure CreateDefaultDataDirectories;
//20170803 Igor>>>
begin
  if not CheckIsCloud(true) and (LicenseLevel in AnyLimited) then//20170902 Igor //20180503 Igor
  begin
    if DirectoryExists(LimitedVersionDir) = False then
    begin
      if not SysUtils.ForceDirectories(LimitedVersionDir) then
      begin
        ShowMessage('Data directory ' + LimitedVersionDir + ' cannot be created');
        exit;
      end;
      if InitDataBase(AppDir, LimitedVersionDir) then
        ShowMessage('A Data Directory has been created: ' + LimitedVersionDir);
    end;
    SaveSingleOption('Dir_Cur', LimitedVersionDir);
    SaveSingleOption('Dir_Deflt', LimitedVersionDir);
  end
  else  //not limited version
  begin
  //20171201 Igor>>>
    if (DirectoryExists(DefaultDataDir(AppFP) + '\Data') = False) or
       (not FileExists(DefaultDataDir(AppFP) + '\Data' + '\' + ClientsDBLite)) then //20150922 Igor
    begin
      if not SysUtils.ForceDirectories(DefaultDataDir(AppFP) + '\Data') then
      begin
        ShowMessage('Data directory ' + DefaultDataDir(AppFP) + '\Data' + ' cannot be created');
        exit;
      end;
      if InitDataBase(AppDir, DefaultDataDir(AppFP) + '\Data') then
        if not CheckIsCloud(true) then //20180503 Igor 
        ShowMessage('A default Data Directory has been created: ' + DefaultDataDir(AppFP) + '\Data' + Chr(13) +
                    'You can change it via Configure | General options');
    end;
    SaveSingleOption('Dir_Cur', DefaultDataDir(AppFP) + '\Data');
    SaveSingleOption('Dir_Deflt', DefaultDataDir(AppFP) + '\Data');
    //20171201 Igor<<<
  end;
//20170803 Igor<<<
end;


//20170225 >>> Igor Move to FP_2027Declare
//const
//  PswElm = 17;
//  c_LastYearElm = 32;
//20170225 <<<

Function GetReturnPsw(Datadir:string;FlName:string):String;
begin
  GetFilePsw(Datadir,FlName,PswElm,Result, AppFP.SQLLitePassword.PassRFArray); //20160415 Igor
end;

function  CheckReturnPsw(Datadir:string;FlName:string):integer;
begin
  Result := CheckFilePsw(Datadir,FlName,PswElm, AppFP.SQLLitePassword.PassRFArray); //20160415 Igor
end;

Procedure StoreReturnPsw(RetNo:Integer;RetPsw:String);
begin
 StoreElm(RetNo,'STATUS',PswElm,EncryptPsw(RetPsw,9999));
end;

Procedure RemoveReturnPsw(RetNo:Integer);
begin
 StoreElm(RetNo,'STATUS',PswElm,'');
end;


Function IncludeFormInPrint(RetNo:Integer;FNm:String):boolean;
//Var RetNo:Integer;
begin
 result := true;
//????
end;

function GetMaxFormNumber:integer;
var
 i:integer;
 mFormNum:Integer;
begin
  Result := FormsLimit;
  EXIT;  //we use 600
end;

function GetFormNumberFields(FNo: integer):integer;
begin
  Result := FList.GetFormNumberFields(FNo);
end;

Function GetKeyWListFromRichEdit(ARichEdit:TRichEdit;KeyWList:TStrings):Boolean;
Var
  Delim1List,Delim2List:TStringList;
  KeyW,tempKeyWFull:String;
  i, StartPos:Integer;
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

function ConvertToProper(s: string):string;
var  i,iLen, iIndex: integer;WList:TStringList;SBuffer:String;
begin

   Result:='';
   iLen := Length(s);
   If iLen=0 then exit;
   s:= Uppercase(MidStr(s, 1, 1)) + Lowercase(MidStr(s,2, iLen));

   Wlist := TStringList.Create;
   ParseWords(s,' ',WList);
   For i:=0 to Wlist.count-1 do
   begin
     SBuffer:=WList[i];
     sBuffer:=UpperCase(MidStr(sBuffer, 1, 1)) + Lowercase(MidStr(SBuffer,2,Length(Sbuffer)));
     WList[i]:=sBuffer;
     //o'connor
     If midstr(SBuffer,2,1)=Chr(39) then
      WList[i]:=LeftStr(sBuffer,2)+UpperCase(MidStr(sBuffer,3,1))+midStr(Sbuffer,4,100)
     //RR
     else If UpperCase(LeftStr(SBuffer,2))='RR' then
      WList[i]:=UpperCase(leftStr(sBuffer,2))+midStr(Sbuffer,3,100)
     else If Length(SBuffer)=2 then
     begin
      If (UpperCase(LeftStr(SBuffer,2))='NE')
      or (UpperCase(LeftStr(SBuffer,2))='SE')
      or (UpperCase(LeftStr(SBuffer,2))='NW')
      or (UpperCase(LeftStr(SBuffer,2))='SW') then
       WList[i]:=UpperCase(leftStr(sBuffer,2)+midStr(Sbuffer,3,100))
     end;
   end;

   result:='';
   For i:=0 to Wlist.count-1 do  Result:=Result+Wlist[i]+' ';
   Result:=AllTrim(Result);

   Wlist.Free;
end;

procedure InsertBackFunction(ARichEdit:TRichEdit;InSearch, InSecondSearch, InReplace: string);
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

Procedure ReplaceRtfDelimiters(ARichEdit:TRichEdit;FromDelim,ToDelim:String);
begin
 ARichEdit.SelStart:=0;
 ARichEdit.SelectAll;
 ARichEdit.Paragraph.Alignment := paLeftJustify; //20160819 Igor
 ReplaceRtfText(ARichEdit,FromDelim, ToDelim);
end;

Procedure AddDisplayFormatToRtf(ARichEdit:TRichEdit;KeyWList:TStringList);
// i.e. [Taxable_amount] s/b FNum(Taxable_amount)
begin
//
end;

Procedure ReadTheValue(TempList:TstringList;FrmNm:String;Elm1,Elm2:Integer;Var Val1:String;Var Val2:String);
{templist is the tax return data}
Var i,j:Integer;
     WList:TstringList;
     Rec:String;
begin
  Val1:='';
  Val2:='';
  WList:=TstringList.Create;
  For i:=1 to TempList.Count-2 do   //-2 otherwise it abends
  begin
   Rec:=TempList[i];
   ParseWords(Rec,Delimiter,WList);
   If (WList[0] = 'F') and (WList[1]=FRmNm) then
   begin
    j:=i+1;
    Repeat
     Rec:=TempList[j];
     ParseWords(Rec,Delimiter,WList);
     If (WList[0]='D') then
     begin
      If Vl(WList[1])=Elm1 then Val1:=WList[2];
      If Vl(WList[1])=Elm2 then Val2:=WList[2];
     end;
     Inc(j);
    until (j>TempList.Count-2) or (LeftStr(Rec,2)='F'+Delimiter); {end form data}
   end; {within form nm}
  end; {i}
  WList.Free;
end;

Function FirstTimeClient(RetNo:Integer):Boolean;
begin
 //????
 Result:=False;
 If UpperCase(FetchElm(RetNo,'INFO',88))='X' then result:=True;
end;

Procedure GetDelimiterPositionsInRtf(ARichEdit: TRichEdit; SearchText: string;DelimList:TStrings);
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

Function IsConditionalRtfStatement(KeyW:String):Boolean;
//for letters
begin
 Result:=False;
 If (UpperCase(LeftStr(KeyW,4)) = 'IF (')
 Or (UpperCase(LeftStr(KeyW,3)) = 'IF(')
 Or (UpperCase(LeftStr(KeyW,7)) = 'ELSIF (')
 Or (UpperCase(LeftStr(KeyW,6)) = 'ELSIF(') then
 Result:=True;
end;


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
End;

procedure ReplaceRtfText(ARichEdit:TRichEdit;InSearch, InReplace: string) ;
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


Procedure GetLoginNames(TempList:TStringList);
begin
 If FileExists(AppDir+'\'+'LoginNames') then
  TempList.LoadFromFile(AppDir+'\'+'LoginNames');
end;

Procedure UpdateLoginNames(Nm:String);
Var TempList:TStringList;
begin
 TempList:=TStringList.Create;
 Nm:=UpperCase(Nm);
 If FileExists(AppDir+'\'+'LoginNames') then
  TempList.LoadFromFile(AppDir+'\'+'LoginNames');
 If IsInList(Nm,TempList) < 0 then TempList.Add(Nm);
 TempList.SaveToFile(AppDir+'\'+'LoginNames');
 TempList.Free;
end;

Procedure InitRichEditStorage(RetNo:Integer);
//strings will hold ponters to richdit fields
Var i:Integer;
begin
end;


//---------------------------New Functions Added---------------------------------------------


procedure PrintAtAngle(AText:String;ACanvas:TCanvas;Xpos:Integer;YPos:Integer;FontSize:Integer;AtAngle:Integer);
var
  lf: TLogfont;
begin
    //begindoc;
    Acanvas.font.Name := 'Times New Roman'; //'Arial';
    Acanvas.font.Size := FontSize;
    Acanvas.font.Color := RGB(230,230,230); //clSilver;
    Acanvas.font.Style := [fsBold];
    GetObject(Acanvas.font.handle, Sizeof(lf), @lf);
    lf.lfescapement := AtAngle; //450;
    lf.lforientation := AtAngle; //450;
    ACanvas.Font.handle := CreateFontIndirect( lf );
    Acanvas.TextOut(XPos, YPos, AText);
    ACanvas.Font.Handle := 0;
    //EndDoc;
end;

Function RemoveHyphens(S:string):string;
Var i:integer;
begin
 Result:='';
 For i:=1 to Length(s) do
   If s[i] <>'-' then result:=result+s[i];
end;

Procedure InsertKeyWToDataDict(FormName:String;AnEditBox:TvtEdit);
Var KeyW:String;s:String;
    //20150918 igor
    FDConnection: TADConnection;
    Table1: TADTable;
begin
  //20150918 Igor
  FDConnection := TADConnection.Create(nil);
  Table1 := TADTable.Create(nil);
  SetTableName(FDConnection, Table1, AppDir + '\' + DictDBLite, DictTableLite, 'KeyWord');

   KeyW:=ExtractNonInstFormName(FormName)+
      '_'+IntToStr(GetFieldId(AnEditBox.Name));
   if Table1.FindKey([KeyW]) = False then
   Begin
    Table1.Insert;
    Table1.FieldByName('FormName').AsString:=ExtractNonInstFormName(FormName);
    Table1.FieldByName('Field_No').AsInteger:=GetFieldId(AnEditBox.Name);
    Table1.FieldByName('Descr').AsString:=FormName+' cell number'+IntToStr(GetFieldId(AnEditBox.Name));
    If AnEditBox.vtInputType = vtDollar then
     Table1.FieldByName('Is_Amount').AsString:='Y'
    else
     Table1.FieldByName('Is_Amount').AsString:='';
   end;
   s:= InputBox('Input Box', 'Enter a keyWord name for this data field', '');
   If s = '' then begin ShowMessage('Cancelled'); Table1.Close; Table1.Free; FDConnection.Free; Exit;end;
   s:=ReplaceChar(s,' ','_');
   s:=RemoveChar(s,'#');
   Table1.FieldByName('KeyWord').AsString:=s;
   Table1.Post;

   Table1.Close;
   Table1.Free;
   FDConnection.Free;

   ShowMessage('The keyWord was added with name: '+S
     +Chr(13)+' '
     +'You can further refine/delete keywords by clicking on Configure | Data Dictionary');
end;

Function GetFldMemFormNo(RetNo:Integer;RefFormName,RefFieldId:String):Integer;
Var I,FNo:integer;FrmNm:String;
const
  FName = 'FLDMEM';
begin
  Result:=0;
  for i := FList.FirstInstNo(FName) to FList.Count-1 do
  begin
    FRec := FList.Items[i];
    if FRec.FormName<>FName then break;
    begin
      FNo := FRec.FormNo;
       If (FetchElmFNo(RetNo,FNo,17) = RefFormName)
       and (FetchElmFNo(RetNo,FNo,18) = RefFieldId) then
        result := FNo;
    end;
  end;
end;

Function GetTrTopicFromLineRef(FormName:String;FieldId:Integer):String;
Var i:Integer;LineRef:TStringList;
begin
  result :='';
  LineRef := TStringList.Create;
  LineRef.LoadFromFile(AppDir+'\'+'Effields.d');
  For i:= 0 to LineRef.Count -1 do
  begin
   If FormName = AllTrim(MidStr(LineRef[i],81,9)) then
   begin
    If FieldId = MyStrToInt(AllTrim(MidStr(LineRef[i],91,3))) then
     begin
      result :=ReplaceChar(AllTrim(LeftStr(LineRef[i],4)),'*','');
      break;
     end;
   end; {same formname}
  end; {i loop}
  LineRef.Free;
end;

Function IsValidTrustNo(S:String):Boolean;
//T12345678
begin
 Result:=True;
 If s='' then Exit;
 If UpperCase(LeftStr(s,1))<>'T' then begin result := False;exit;end;
 If Length(s) <> 9 then begin result := False;exit;end;
 If Not Numeric(MidStr(S,2,8)) then begin result := False;exit;end;
end;

Function GetFNoOfFirstInstance(FName:String;FNo:Integer):Integer;
begin
  Result:=FNo;
  If IsFormMultiInst(FName) then
   Result:=GetFormNo(ExtractNonInstFormName(Fname)+'#1');
end;

Function LandscapeFormsInFedReturn(RetNo:Integer):Boolean;
begin
 Result:=False;
 If (Ret[RetNo].FrmHasData[GetFormNo('S8#1')])
 or (Ret[RetNo].FrmHasData[GetFormNo('S9')])
 then result :=True;
end;

Function LandscapeFormsInONTReturn(RetNo:Integer):Boolean;
begin
 Result:=False;
 If (Ret[RetNo].FrmHasData[GetFormNo('OS8#1')])
 or (Ret[RetNo].FrmHasData[GetFormNo('OPRMTAX')])
 then result :=True;
end;

Function LandscapeFormsInALBReturn(RetNo:Integer):Boolean;
begin
 Result:=False;
 If (Ret[RetNo].FrmHasData[GetFormNo('AS10')])
 or (Ret[RetNo].FrmHasData[GetFormNo('AS13')])
 then result :=True;
end;


function ModifyFormOrText(FileToConvertFrom:string;ConversionType:String):Boolean;
var
  InputStream, OutputStream : TFileStream;
  FileToConvertTo : string;
begin
  Result := True;

  FileToConvertFrom := FileToConvertFrom;//ExtractFileName(FileToConvertFrom);

  FileToConvertTo := FileToConvertFrom;

  { change file extensions as appropriate }
  If ConversionType='FORM' then
  begin
    FileToConvertFrom := ChangeFileext(FileToConvertFrom, '.TXT');
    FileToConvertTo := ChangeFileext(FileToConvertFrom, '.DFM');
  end
  Else If ConversionType='TEXT' then
  begin
    FileToConvertFrom := ChangeFileExt(FileToConvertFrom, '.DFM');
    FileToConvertTo := ChangeFileExt(FileToConvertFrom, '.TXT');
  end;
  if not FileExists(FileToConvertFrom) then
  begin
   showmessage('File ' + FileToConvertFrom + ' does not exist');
   result := false;
   exit;
  end;
  try
    try
      // Create a file stream for the specified file
      InputStream  := TFileStream.Create(FileToConvertFrom, fmOpenRead);
      OutputStream := TFileStream.Create(FileToConvertTo, fmCreate);

      // perform the selected conversion

      If ConversionType ='FORM' then
      begin
        ObjectTextToResource(InputStream, OutputStream);
      end
      Else If ConversionType ='TEXT' then
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
       Result := False;
       showmessage('Form Failed: ' + FileToConvertFrom);
      end;
    end;
  finally
    InputStream.Free;
    OutputStream.Free;
  end;
end;

procedure ModifyAllForms;
//Var  Type TDFMorTXT = (ConvertToForm, ConvertToText);
Var i,j:Integer;TempList:TStringList; FName,DfmFileName:String;
Begin
   Screen.Cursor:=crHourGlass;
   TempList:=TStringList.Create;
   Try
    for i:=0 to FList.count - 1 do
    begin
     FRec := FList.Items[i];
     FName:=Frec.FormInstName; if FName = '' then continue;
     MainFormFP.BitBtn1.Caption:=FName;
     DfmFileName:=GetDfmFileName(FName);
     If FileExists(DfmFileName) then
     Begin
      //convertDfmtoTxt(ToDir,FlName);
      ModifyFormOrText(DfmFileName,'TEXT');
      TempList.LoadFromFile(ChangeFileExt(DfmFileName,'.txt'));
      for j:=0 to TempList.count - 1 do
      begin
       if Pos('vtVertSeparator',TempList[j]) > 0 then
       begin
        TempList[j] := '';
       end;
      end;
     TempList.SaveToFile((ChangeFileExt(DfmFileName,'.txt')));
     ModifyFormOrText(ChangeFileExt(DfmFileName,'.txt'),'FORM');
     end;
    end;
   Except;
   end;
   Screen.Cursor:=crDefault;
   TempList.Free;
   ShowMessage('Done');
end;


Function IncrString(s:String;ByValue:Integer):String;
begin
 Result:='';
 If s>'' then result:= IntToStr(MyStrToInt(s)+ByValue);
end;

Procedure FixAProperty;
Var i,j:Integer;TempList,vtCalcList:Tstringlist; StartPos:Integer;
   FName,DfmFileName:String;
   vtCalcElmName:String;
Begin
   //FIX vtCalc for all forms based on a list with Fname and Elm
   Screen.Cursor:=crHourGlass;
   vtCalcList:=TStringList.Create;
   TempList:=TStringList.Create;
   vtCalcList.loadfromfile(appdir + '\vtCalcLinkList.txt');
   Try
    for i:=0 to vtCalcList.count - 1 do
    begin
     //FRec := FList.Items[i];
     //FName:=Frec.FormInstName;
     FName:= AllTrim(leftStr(vtCalcList[i],10));
     DfmFileName:=GetDfmFileName(FName);
     If FileExists(DfmFileName) then
     Begin
      //convertDfmtoTxt(ToDir,FlName);
      MainFormFP.bitbtn1.Caption := FName;
      ModifyFormOrText(DfmFileName,'TEXT');
      TempList.LoadFromFile(ChangeFileExt(DfmFileName,'.txt'));

      vtCalcElmName := AllTrim(midStr(vtCalcList[i],10,20));
      StartPos := TempList.indexof('  object ' + vtCalcElmName + ': TvtEdit');
     if StartPos > -1 then
     begin
      for j:=StartPos to StartPos + 40 do //TempList.count - 1 do
      begin
       if Pos('vtDataSource',TempList[j]) > 0 then
       begin
        if Pos(uppercase('end'),uppercase(TempList[j])) > 0 then
        begin
         vtCalcList[i] := paddR(vtCalcList[i],40) + 'Failed..............';
         break;
        end;
        TempList[j]   := '    vtDataSource = vtLinked';
        vtCalcList[i] := paddR(vtCalcList[i],40) + 'Changed!??';
        break;
       end;
      end;
     end
     else
     begin
        vtCalcList[i] := paddR(vtCalcList[i],40) + 'Failed..............';
     end;
     TempList.SaveToFile((ChangeFileExt(DfmFileName,'.txt')));
     vtCalcList.SaveToFile(appdir + '\vtCalcList.txt');
     //convertTxttoDfm(ToDir,FlName);
     ModifyFormOrText(ChangeFileExt(DfmFileName,'.txt'),'FORM');
     end;
    end;
   Except;
   end;
   vtCalcList.free;
   TempList.free;
   Screen.Cursor:=crDefault;
   ShowMessage('Done');
   exit;
end;

Function PrintLabels(DataDir,FileNm:String):boolean;
var
  ADConnection: TADConnection;
  Tbl: TADTable;
  i,RecNo,LineCnt,MxLinesPerPage,PageCnt:integer;
  PrnFile: TextFile;
  XPos :LongInt;YPos : LongInt;
  InpFile :TextFile;InpKey:String;
  PixPerInX, PixPerInY : Integer;
  LabelPosX, LabelPosY : Integer;
  TopMargin,LeftMargin,LabelHeight, LabelWidth, VertIncr, HorizLabelGap
     : Integer;
  Line1,Line2,Line3,Line4,Line5:String;
begin
 {Set up label parameters}

  PixPerInX := GetDeviceCaps(Printer.Handle,LOGPIXELSX);
  PixPerInY := GetDeviceCaps(Printer.Handle,LOGPIXELSY);
  TopMargin  := Trunc(0.5 *  PixPerInY);
  LeftMargin := Trunc(1/8 *  PixPerInY);
  LabelHeight:= Trunc(1   * PixPerInY);  {1 inch}
  LabelWidth := Trunc(2.5 * PixPerInX);    {2.5 inches}
  VertIncr :=  Trunc(PixPerInY * (1/6));   {6 lines per inch}
  HorizLabelGap := Trunc(1/8 *  PixPerInX);

  {open the input file of keys}
  AssignFile(InpFile, FileNm);
  Reset(InpFile);
  {start printer}
  Printer.BeginDoc;
  { Get data from data base}
  //20150922 Igor
  ADConnection:= TADConnection.Create(Application);
  Tbl := TADTable.Create(Application);
  SetTableName(ADConnection, Tbl, DataDir + '\' + ClientsDBLite, ClientsTableLite, 'FILE_NAME');

  RecNo :=0;
  while not Eof(InpFile) do
  begin
    ReadLn(InpFile, InpKey);
    if Tbl.FindKey([InpKey]) then
     begin
      Inc(RecNo);
      If RecNo >30 then begin RecNo :=1; Printer.NewPage; end;
      Line1 := Tbl.FieldByName('Corp_Name').AsString;
      Line2 := Tbl.FieldByName('STREET').AsString;
      Line3 := Tbl.FieldByName('CITY').AsString;
      Line4 := Tbl.FieldByName('PROVINCE').AsString
               +', '+Tbl.FieldByName('POSTAL').AsString;

      If RecNo < 11 then  {left label}
        begin
         LabelPosX := LeftMargin;
         LabelPosY := TopMargin+(RecNo-1)*LabelHeight;
        end;
      If (RecNo >10) and (RecNo < 21) then  {Midle label}
         begin
         LabelPosX := LeftMargin+LabelWidth+HorizLabelGap;
         LabelPosY := TopMargin+(RecNo-11)*LabelHeight;
         end;
      If (RecNo >20) and (RecNo <31) then  {right label}
          begin
          LabelPosX := LeftMargin+2 *LabelWidth+3 * HorizLabelGap;
          LabelPosY := TopMargin+(RecNo-21)*LabelHeight;
          end;
      PrintALabel(LabelPosX,LabelPosY,Line1,Line2,Line3,Line4,Line5);
     end;
  end; {end while}

  CloseFile(InpFile);
  Tbl.Free;
  ADConnection.Free;
  Printer.EndDoc;
  Result := True;
end;

Procedure PrintALabel(LabelPosX,LabelPosY:integer;Line1,Line2,Line3,Line4,Line5:String);
{pos in pixels}
Var
XPos, YPos, VertIncr,PixPerInX,PixPerInY : Integer;
begin
  Printer.Canvas.Font.Name := 'Arial';
  PixPerInX := GetDeviceCaps(Printer.Handle,LOGPIXELSX);
  PixPerInY := GetDeviceCaps(Printer.Handle,LOGPIXELSY);
  Printer.Canvas.Font.Size := 8;
  XPos := LabelPosX +2;
  YPos := LabelPosY+2;
  VertIncr := Trunc(PixPerInY * (1/6));
  Printer.Canvas.Font.Style := [fsBold];
  Printer.Canvas.TextOut(XPos,YPos,Line1);
  Printer.Canvas.Font.Style := [];
  Printer.Canvas.TextOut(XPos,YPos+1 * VertIncr,Line2);
  Printer.Canvas.TextOut(XPos,YPos+2 * VertIncr,Line3);
  Printer.Canvas.TextOut(XPos,YPos+3 * VertIncr,Line4);
  Printer.Canvas.TextOut(XPos,YPos+4 * VertIncr,Line5);
end;

Procedure InitPredictiveFiles;
Var TempList:TStringList;
begin
 TempList:=TStringList.Create;
 TempList.Add(' ');
 If FileExists(AppDir+'\'+'CorpBn.txt')= false then
  TempList.SaveToFile(AppDir+'\'+'CorpBn.txt');

 If FileExists(AppDir+'\'+'CorpNm.txt')= false then
  TempList.SaveToFile(AppDir+'\'+'CorpNm.txt');

 If FileExists(AppDir+'\'+'Cities.txt')= false then
  TempList.SaveToFile(AppDir+'\'+'Cities.txt');

 If FileExists(AppDir+'\'+'Charity.txt')= false then
  TempList.SaveToFile(AppDir+'\'+'Charity.txt');


end;

Function FindWord(ThisWord,Ln:String):Integer;
Var Place:Integer;
begin
 Result := pos(UpperCase(ThisWord), Uppercase(Ln));
end;

procedure ConnectToWeb(Url:String);
Var h:THandle;
begin
  Screen.Cursor :=crHourGlass;
  h := ShellExecute(Application.MainForm.Handle,'open',Pchar(''+Url),Nil,Nil,Sw_Show);
  If H<=32 then
   ShowMessage('Connection failed');
  Screen.Cursor :=crDefault;
end;


procedure ShowPdf(PgmPath,PgmFile:String);
Var h : Thandle;
begin
 h := ShellExecute(Application.Handle, Nil, PChar(''+PgmFile),PChar(''),PChar(''+PgmPath), SW_RESTORE);
 If H<=32 then ShowMessage('File '+ Pgmfile+ ' not found ');
end;

Function GetFastPrintIndicator:Boolean; //20160901 Igor
//Var TempList:TStringList;s:String;
begin
  Result:=OptRec.UseFastPrint;
// Result := false;
// TempList := TstringList.Create;
// TempList.LoadFromFile(AppDir+'\'+'OthOpt.D');
// s:=TempList[1];
// If UpperCase(s[30]) = 'Y' then result := True;
// Templist.Free;
end;

Procedure BuildExperience(FrmNm:String;FromElm,ToElm,ByElm:Integer;FlName:String;ElmList:TStringList;DataList:TStringList);
// For a given form
// for a set of elms
// From values in datalist (image of tax return data file)
Var i,j,BnElm:Integer;s:String;TempList:TStringList;
begin
    TempList:=TStringList.Create;
    ElmList.Clear;
    j:=FromElm;
    Repeat
     ElmList.Add(FillLeftZeros(AllTrim(IntToStr(j)),3));
     Inc(j,ByElm);
    until j>ToElm;
    PutValuesInELmList(FrmNm,DataList,ElmList);

    (*
    If UpperCase(FlName)='CorpBn.txt' then
    begin  //add corp name after the BN i.e. nn   bn  CorpNm
     For i:=0 to ElmList.Count-1 do
     begin
      ElmList[i] := ElmList[i] +' '+GetSuperCorpName(ElmList[i]);
     end;
    end;
    *)
    If FileExists(AppDir+'\'+FlName) then TempList.LoadFromFile(AppDir+'\'+FlName);
    For j:=0 to ElmList.Count-1 do
    begin
     s:=MidStr(ElmList[j],6,255);
     If (S>'') and (IsStringInList(s,TempList)=-1) and (s<>'"') then TempList.Add(s);
    end;
    For i:=0 to TempList.count-1 do TempList[i] := UpperCase(TempList[i]);

    TempList.Sorted:=True;
    TempList.SaveToFile(AppDir+'\'+FlName);
    TempList.Free;
end;

Function InitDataBase(AppDir: string; DataDir: string): boolean;
//20170803 Igor>>>
var
  Err: String;
begin
  Result := CopyDB(AppFP.ClientsDBLite, Appdir, DataDir, Err); //20150922 Igor
  if not Result then
    MessageDlg(Err, mtError, [mbOk], 0);
//20170803 Igor<<<
end;

Procedure AutoFormatDate(Var Value:String);
begin
 If ((Length(Value) =8) and Numeric(Value))
 or (Length(Value)=10)
 then
 begin
  Value:=RemoveChar(Value,'-');
  Value:=RemoveChar(Value,'/');
  Value:=LeftStr(value,4)+'-'+MidStr(value,5,2)+'-'+RightStr(value,2);
 end;
end;

function GetFormAbrevName(FormNo: integer):String;
var
 i: Integer;
 begin
 Result := '';
  for i :=0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      if (FRec.FormNo = FormNo) then
        Result := FRec.FormAbrev+' ' +Frec.FormInst;
    end;
 end;

Function GetHowToFormat(FrmName:String;Elm:Integer):Integer;
begin
 result :=2; {no decimals}
 //If ((FrmName = 'AT1_1') and ((Elm =42) or  (elm=43))) then result :=0;
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

Function GetFldTapeFormNo(RetNo:Integer;RefFormName,RefFieldId:String):Integer;
Var I,FNo:integer;FrmNm:String;
const
  FName='FLDTAPE';
begin
  Result:=0;
  for i := FList.FirstInstNo(FName) to FList.Count-1 do
  begin
    FRec := FList.Items[i];
    if FRec.FormName <> fname then break;
    begin
      FNo := FRec.FormNo;
       If (FetchElmFNo(RetNo,FNo,121) = RefFormName)
       and (FetchElmFNo(RetNo,FNo,122) = RefFieldId) then
       begin
        result := FNo;
        exit; //DoDi
       end;
    end;
  end;
end;

Function EditDate(S:String;MnYear,MxYear:integer):Boolean;
{In form yyyy/mm/dd??? yyyy-mm-dd!}
begin
  Result := EditDateYMD(s,MnYear,MxYear,'-');
end;

Function GetRetName(RetNo:integer): string;
begin
 Result := Rtrim(FetchElm(RetNo,FirstFormName,1))+', '
   +Rtrim(FetchElm(RetNo,FirstFormName,2));
 If Result =',' then result := '(Un-named)';
end;


Function CreateDataDirectory(Appdir: string; DataDir:string): integer;
{return codes
 0 : OK
 -1 : Directory exists
 -2 : Already contains data base
 -3 : Dir cannot be created
 -4 : Cannot copy Data Bases
 -5 : must have a slash with subdirectory
 }
begin
  result :=0;
  If (Length(DataDir)<3) or (Pos('\',DataDir)=0) then begin result:=-5;exit;end;
  If DirectoryExists(DataDir) then
   begin result := -1; exit; end;
  If FileExists(DataDir+'\'+ ClientsDBLite) then //20150922 Igor
     begin Result := -2; exit; end;

  {now create and copy data bases}
  {$I-}   {so that the ioresult can be effective}
  ForceDirectories(DataDir);
  //MkDir(DataDir);
  if IOResult <> 0 then
       begin result := -3; exit; end;
  If InitDataBase(AppDir,DataDir) = false then
     begin result := -4; exit;end;
end;

Procedure PutValuesInElmList(FrmNm:String;DataList:TStringList;ElmList:TStringList);
//DataList is the tax return data, Returns populated ElmList nnn  value
Var i,j,k,ElmNo:Integer;
     WList:TstringList;
     Rec:String;
begin
  If ElmList.Count<1 then exit;
 Try
  If LeftStr(DataList[0],2) <> 'FP' then exit;

  WList:=TstringList.Create;
  For i:=1 to DataList.Count-1 do
  begin
   Rec:=DataList[i];
   ParseWords(Rec,Delimiter,WList);
   If (WList[0] = 'F') and (WList[1]=FRmNm) then  //found form record
   begin
    j:=i+1;
    Repeat
     Rec:=DataList[j];
     ParseWords(Rec,Delimiter,WList);
     If (WList[0]='D') then      //wlist[2] has the actual data
     begin
       For k:=0 to ElmList.Count-1 do
       begin
         ElmNo:=MyStrToInt(MidStr(ElmList[k],1,3));
         If Vl(WList[1])=ElmNo then ElmList[k]:= PaddR(ElmList[k],4)+' '+WList[2];
       end;
     end; //end detail rec
     Inc(j);
    until (j>DataList.Count-1) or (LeftStr(Rec,2)='F'+Delimiter); {end form data}
   end; {within form nm}
  end; {i}
 Except
 end;
 WList.Free;
end;

Function IsStringInList(s:String;Alist:TStringList):Integer;
{return item index of a given string}
Var i:Integer;
begin
 result :=-1;
 For i:=0 to Alist.count-1 do
 If UpperCase(s) = UpperCase(Alist[i]) then
 begin
   result := i;
   exit;
 end;
end;

Function GetFormRlNm(FName: String):String;
Var I :integer;
begin
Result :='';
Result:=RTrim(FName);
for i :=0 to (FList.Count - 1) do
  begin
     FRec := FList.Items[i];
     If FName = FRec.FormName
      then Result := FRec.FormRlNm;
   end;
End;


Function GetFormHeight(FName:string):Integer;
Var I:integer;
begin
 Result:=1050;
 FName := ExtractNonInstFormName(FName);
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If Frec.FormName = fname then
   begin
    if Frec.FormHeight < 700 then
       result := 700
    else
       result := Frec.FormHeight;
    Exit;
   end;
 end;
end;

Function IsFieldInElmsInError(s:String;Alist:TStringList):Integer;
{return item index of a given string}
Var i:Integer;
begin
 result :=-1;
 s:=AllTrim(UpperCase(s));
 For i:=0 to Alist.count-1 do
 begin
  If s = AllTrim(UpperCase(LeftStr(Alist[i],3))) then
  begin
    result := i;
    exit;
  end;
 end;
end;

function IsLandscape(FName: String):Boolean;
begin
  Result := FList.ByFormName(FName).Landscape;
End;

Function GetFormType(FName:String):String;
begin
  Result := FList.byFormName(FName).FormType;
end;

Procedure InitModelPortfolioFile;
Var RetNo,FormNo:Integer;k:Integer;
Begin
  // If IsLimitedVersion then exit;
   RetNo:=CreateNewReturn;
   if RetNo < 1 then begin ShowOpenReturnFailure(RetNo, '', ''); exit; end;

   begin
    //RetNo:=k;
    FormNo := GetFormNo('PROFILE');
    InitFormData(RetNo,FormNo);
    StoreElm(RetNo,FormNo,3,ModelPortfoliosSIN);  //sin
    StoreElm(RetNo,FormNo,2,'ModelPortfolios');  //Last Name
    StoreElm(RetNo,FormNo,27, FormatDateTime('yyyy-mm-dd',Date));  //BirthDate
    SaveReturn(RetNo,AppDir,ModelPortfoliosFlName,True,False);
    CloseReturn(RetNo,True);
   end;
End;

Procedure SaveModelPortfolio(RetNo:Integer);
Begin
  SaveReturn(RetNo,AppDir,ModelPortfoliosFlName,True,False);
End;

Procedure ImportModelPortfolio(ToRetNo:Integer;FormName:String);
Var
  I,FNo,FromRetNo:Integer;
  FName,FromFInst,ToFInst,FRootName:String;
Begin
(* Button clicked in PORTFOLIO#... form (=FormName?).
 FromRetNo is new return!?
 Seems to open an standard return 'ModelPortfolios' as FromRetNo,
 containing some portfolio# forms.
 User selects the FromFInst (#x) to clone into ToRetNo as ToFInst.

 Since FromRetNo is closed afterwards, it will be handled all here.
*)
  If LeftStr(FormName,10)<>'PORTFOLIO#' then
    exit; //message? - this should never happen
  ToFInst:=ExtractFormInst(FormName);
  try
  FromRetNo := OpenModelPortfolioFile(True); //ShowSw is ignored!?
  //find and put model portfolios on a list
   SomeList.Clear;  // := TStringList.Create;
   //FNonInst:= ExtractNonInstFormName('PORTFOLIO');
   for i :=0 to (FList.Count - 1) do
   begin
      FRec := FList.Items[i];
      //If (Frec.FormName = 'PORTFOLIO') and (Ret[RetNo].FrmHasData[Frec.FormNo]) then
      //If (Frec.FormName = 'PORTFOLIO') and (Ret[ToRetNo].FrmHasData[Frec.FormNo]) then
      If (Frec.FormName = 'PORTFOLIO') and (Ret[FromRetNo].FrmHasData[Frec.FormNo]) then
      begin
        FNo:=Frec.FormNo;
        Somelist.Add(PaddR(FRec.FormInst,4)+' '+FetchElmFNo(FromRetNo,FNo,2));
      end; //found the form
   end;  //i
   If SomeList.count=0 then
   begin
    ShowMessage('There are no model portfolios');
    Exit;
   End;
   SomeCaption := 'Select a Model Portfolio';
   SelectedString := PopSomeList(SomeList,SomeCaption);
   If SelectedString > '' then
   begin
    FromFInst:=AllTrim(LeftStr(SelectedString,4));
    CloneForm(FromRetNo,'PORTFOLIO'+FromFInst,ToRetNo,'PORTFOLIO'+ToFInst); {fromR,FromF,ToR}
    OpenForm(ToRetNo,GetFormNo('PORTFOLIO'+ToFInst),0);
    ShowTimedMsg('Done',1500);
   End;
  finally
    SomeList.Clear;
    CloseReturn(FromRetNo,True);
  end;
end;

function OpenModelPortfolioFile(ShowSw:Boolean): integer;
//Procedure OpenModelPortfolioFile(RetNo:Integer;ShowSw:Boolean);
Begin
  Result := OpenReturn(AppDir,ModelPortfoliosFlName,ShowSw);
End;

Function GetRetNoFromSin(Sin:String):Integer;
Var I:integer;
begin
 Result := 0;
 If Sin ='' then exit;
 for i :=0 to (RetList.Count - 1) do
 begin
   RetRec := RetList.Items[i];
   if Assigned(RetRec) then //20160331 Igor
   Begin
     If GetSinNo(RetRec.RetNo) = Sin then
     begin
       Result:=RetRec.RetNo;
       Exit;
     end;
   End;
 end;
end;

Procedure InitTaxRec;
begin
 With TaxRec do
 begin
   Age:=0;
   MaritalStatus:=6;
   Province:='';
   PartYear:=365;
   TaxableIncome:=0;
   ActualDividendsNonElig:=0;
   ActualDividendsElig:=0;
   ActualCapitalGains:=0;
   EligiblePensionIncome:=0;
   SpouseNetIncome:=0;
 end;
end;


Function MkFileName(RetNo:Integer):String;
begin
 Result:=UpperCase(
         LeftStr(FetchElm(RetNo,'PROFILE',2)+' '+FetchElm(RetNo,'PROFILE',1),30)
         +' '+GetPlanDate(RetNo)+' '+GetSinNo(RetNo)
         );
end;

Function GetPlanDate(RetNo:Integer):String;
begin
 Result:=FetchElm(RetNo,'PROFILE',80);

end;

Procedure LoadTreeView(FlName:String;SectionId:Integer);
Var i,j,k:Integer;TempList1,TempList2:TStringList;
begin
  FrmTreeDescr.Clear;
  FrmTreeForms.Clear;
  FrmTreeFType.Clear;

  TempList1     :=TStringList.Create;
  TempList2     :=TStringList.Create;

  TempList1.LoadFromFile(AppDir+'\'+FlName); //'TreeView.d');
  k:=0; //where the section starts
  For i:=0 to TempList1.count-1 do
  begin
    If LeftStr(TempList1[i],2) ='$'+IntToStr(SectionId) then
    begin
      k:=i;
      Break;  //go below
    end;
  end;

  i:=k;
  Repeat
   FrmTreeForms.Add(MidStr(TempList1[i],61,20));
   FrmTreeFType.Add(MidStr(TempList1[i],81,1));
   FrmTreeDescr.Add(LeftStr(TempList1[i],60));
   If LeftStr(TempList1[i],1) ='$' then
    TempList2.Add(MidStr(TempList1[i],2,59))  //100
   Else
     TempList2.Add(LeftStr(TempList1[i],59));
   Inc(i,1);
  until i>TempList1.Count-1;

  TempList2.SaveToFile(AppDir+'\'+'TreeView2.d');
  TempList1.Free;
  TempList2.Free;
end;

Procedure InitIncProjectionFromCashFlow(RetNo:Integer);
Var k,m,FNo,CashFlFNo:Integer;
begin
  FNo:=GetFormNo('INCPROJECTION');
  CashFlFNo:=GetFormNo('CASHFLOW');
  k:=0;m:=0; //client amounts K=4=spouse  m:=0 to 1 (Cl /Sp in CashFl)
    Repeat
     StoreElm(RetNo,FNo,9+k,FetchElmFNo(RetNo,CashFlFNo,5+m));  //empl
     StoreElm(RetNo,FNo,41+k,FetchElmFNo(RetNo,CashFlFNo,8+m));//cpp
     StoreElm(RetNo,FNo,49+k,FetchElmFNo(RetNo,CashFlFNo,11+m)); //OAS if Tv[49+k]=0 then Tv[49+k]:=Vl(FetchElmFNo(RetNo,CashFlFNo,11+m)); //OAS
     StoreElm(RetNo,FNo,57+k,FetchElmFNo(RetNo,CashFlFNo,14+m)); //other pens If Tv[57+k]=0 then Tv[57+k]:=Vl(FetchElmFNo(RetNo,CashFlFNo,14+m)); //other pens
     StoreElm(RetNo,FNo,81+k,FetchElmFNo(RetNo,CashFlFNo,20+m)); //interest If Tv[81+k]=0 then Tv[81+k]:=Vl(FetchElmFNo(RetNo,CashFlFNo,20+m)); //interest
     StoreElm(RetNo,FNo,89+k,FetchElmFNo(RetNo,CashFlFNo,23+m)); //txbl div If Tv[89+k]=0 then Tv[89+k]:=Vl(FetchElmFNo(RetNo,CashFlFNo,23+m)); //txbl div
     StoreElm(RetNo,FNo,241+k,FetchElmFNo(RetNo,CashFlFNo,109+m)); //txbl div If Tv[89+k]=0 then Tv[89+k]:=Vl(FetchElmFNo(RetNo,CashFlFNo,23+m)); //txbl div
     StoreElm(RetNo,FNo,97+k,FetchElmFNo(RetNo,CashFlFNo,26+m)); //other inv If Tv[89+k]=0 then Tv[97+k]:=Vl(FetchElmFNo(RetNo,CashFlFNo,26+m)); //other inv
     StoreElm(RetNo,FNo,105+k,FetchElmFNo(RetNo,CashFlFNo,85+m)); //rental If Tv[105+k]=0 then Tv[105+k]:=Vl(FetchElmFNo(RetNo,CashFlFNo,85+m)); //rental
     StoreElm(RetNo,FNo,113+k,FetchElmFNo(RetNo,CashFlFNo,32+m)); //self empl If Tv[113+k]=0 then Tv[113+k]:=Vl(FetchElmFNo(RetNo,CashFlFNo,32+m)); //self empl
     StoreElm(RetNo,FNo,121+k,FetchElmFNo(RetNo,CashFlFNo,35+m)); //divid priv If Tv[121+k]=0 then Tv[121+k]:=Vl(FetchElmFNo(RetNo,CashFlFNo,35+m)); //divid priv
     StoreElm(RetNo,FNo,129+k,FetchElmFNo(RetNo,CashFlFNo,38+m)); //empl insur If Tv[129+k]=0 then Tv[129+k]:=Vl(FetchElmFNo(RetNo,CashFlFNo,38+m)); //empl insur
     StoreElm(RetNo,FNo,137+k,FetchElmFNo(RetNo,CashFlFNo,41+m)); //net lmt partn If Tv[137+k]=0 then Tv[137+k]:=Vl(FetchElmFNo(RetNo,CashFlFNo,41+m)); //net lmt partn
     StoreElm(RetNo,FNo,145+k,FetchElmFNo(RetNo,CashFlFNo,44+m)); //txbl support If Tv[145+k]=0 then Tv[145+k]:=Vl(FetchElmFNo(RetNo,CashFlFNo,44+m)); //txbl support
     StoreElm(RetNo,FNo,153+k,FetchElmFNo(RetNo,CashFlFNo,47+m)); //w-comp If Tv[153+k]=0 then Tv[153+k]:=Vl(FetchElmFNo(RetNo,CashFlFNo,47+m)); //w-comp
     StoreElm(RetNo,FNo,161+k,FetchElmFNo(RetNo,CashFlFNo,50+m)); //soc assist If Tv[161+k]=0 then Tv[161+k]:=Vl(FetchElmFNo(RetNo,CashFlFNo,50+m)); //soc assist
     StoreElm(RetNo,FNo,169+k,FetchElmFNo(RetNo,CashFlFNo,53+m)); //non-txbl If Tv[169+k]=0 then Tv[169+k]:=Vl(FetchElmFNo(RetNo,CashFlFNo,53+m)); //non-txbl
     StoreElm(RetNo,FNo,177+k,FetchElmFNo(RetNo,CashFlFNo,56+m)); //other If Tv[177+k]=0 then Tv[177+k]:=Vl(FetchElmFNo(RetNo,CashFlFNo,56+m)); //other
     StoreElm(RetNo,FNo,185+k,FetchElmFNo(RetNo,CashFlFNo,97+m)); //tot adj If Tv[185+k]=0 then Tv[185+k]:=Vl(FetchElmFNo(RetNo,CashFlFNo,97+m)); //tot adj

     Inc(k,4);
     Inc(m,1);
    until K>4;

end;


Function PopulateAssetsDbf(RetNo:Integer):Integer;
Const MxInst=5;
Var i,Inst,NetWFNo,FNo:Integer;FInst:String;
    ADConnection: TADConnection;
    Table1: TADTable;
begin
 Result:=0;
 //20150923 Igor
 ADConnection:= TADConnection.Create(Application);
 Table1 := TADTable.Create(Application);
 SetTableName(ADConnection, Table1, OptRec.Dir_Cur + '\' + AssetsDBLite, AssetsTableLite, 'AssetType');

 Table1.Edit;
 NetWFNo:=GetFormNo('NETWORTH');
 //Cash
 If vl(FetchElmFNo(RetNo,NetWFNo,41))>0 then
 begin
 For Inst:=1 to MxInst do
 begin
   FInst:='#'+AllTrim(IntToStr(Inst));
   FNo:=GetFormNo('CASH'+FInst);
   If Ret[RetNo].FrmHasData[FNo] then
   begin
    i:=3;
    Repeat
      If vl(FetchElmFNo(RetNo,FNo,i))>0 then
      begin
       Table1.FieldByName('AssetType').AsString:='Cash and Banks';
       Table1.FieldByName('Descr').AsString:=FetchElmFNo(RetNo,FNo,i-1);
       Table1.FieldByName('Account').AsString:=FetchElmFNo(RetNo,FNo,i-2);
       Table1.FieldByName('Supplier').AsString:='';
       Table1.FieldByName('Account').AsString:=FetchElmFNo(RetNo,FNo,i-2);
       Table1.FieldByName('OrigCost').AsFloat:=0; //FetchElmFNo(RetNo,FNo,i-2);
       Table1.FieldByName('Units').AsFloat:=0; //FetchElmFNo(RetNo,FNo,i-2);
       Table1.FieldByName('CurVal').AsFloat:=vl(FetchElmFNo(RetNo,FNo,i));
       Table1.Insert;
      end;
     Inc(i,9);
    until i>264;
   end;
  end; //inst

  //after all done
  Table1.Close;
  Table1.Free;
  ADConnection.Free;
 end;
end;

Function GetPrintTemplate:string;
begin
  {select print set}
 result :='';
 SomeList.Clear;  // := TStringList.Create;
 SomeCaption := 'Select Print Template';
 SomeList.Add('Client');
 SomeList.Add('Preparer');
 SomeList.Add('Other 1');
 SomeList.Add('Other 2');
 SomeList.Add('Other 3');
 Application.CreateForm(TPoplistFP_2012,PopList);
 PopList.ShowModal;
 PopList.Release;
 if      SelectedString = 'Client'    then result := 'CLINTSET.D'
 else if SelectedString = 'Preparer'  then result := 'PREPSET.D'
 else if SelectedString = 'Other 1'   then result := 'OTH1SET.D'
 else if SelectedString = 'Other 2'   then result := 'OTH2SET.D'
 else if SelectedString = 'Other 3'   then result := 'OTH3SET.D';
end;

Function FormAllowed(Fname:String):Boolean;
begin
 Result:=True;
 If (Fname='ACCOUNTS') or (FName='BUYFUNDS') or (FName='SELLFUNDS')  then
 begin
  If ((IsAgentVersion) or (isDealerVersion))
   then begin result:=True;Exit;End
  else
   Result:=False;
 end;
end;

Function GetIndexedAmount(StartBal:Real;IndexBy:Real;Years:Integer):Real;
Var AList:TStringList;
    i:Integer;
    Values:Array of real; //dynamic array
begin
 If Years<=0 then begin result:=StartBal;Exit;End;
 AList:=TStringList.Create;
 AList.Clear;
 SetLength(Values, years);
 Values[0]:=StartBal;
 For i:=1 to Years-1 do
 begin
  Values[i]:=Values[i-1]+Values[i-1]*IndexBy/100;
 end;
 Result:=Values[Years-1];
 AList.Free;
end;

Function GetTaxOnBase(Bracket,PrevBracket,PrevPercent,PrevBaseTax:Real):Real;
begin
  Result:=Round((Bracket- PrevBracket) * PrevPercent/100)+PrevBaseTax;
end;


Procedure SaveT1LineDataInTXSUM(RetNo:Integer;Whom:Integer);
Var i,FNo:Integer; TaxSumList:TStringList;ElmNo:Integer;LineId:Integer;
Begin
  If Whom=0 then FNo:=GetFormNo('TXSUM_1') else FNo:=GetFormNo('TXSUM_2');
  with Ret[RetNo].Frm[Fno] do
  begin
   TaxSumList := TstringList.Create;
   TaxSumList.LoadFromFile(AppDir +'\'+ 'TAXSUM.D');
   StoreElm(RetNo,FNo,2,AllTrim(ClientFirstName(RetNo))+', '+AllTrim(ClientLastName(RetNo)));
   StoreElm(RetNo,FNo,11,GetSinNo(RetNo));
   StoreElm(RetNo,FNo,8,GetT1Year); //YearOfTaxData;
   For i := 0 to TaxSumList.Count-1 do
   begin
     ElmNo := MyStrToInt(LeftStr(TaxSumList[i],3));
     LineId := MyStrToInt(MidStr(TaxSumList[i],5,3));
     If (ElmNo>0) and (LineId>0) then
     begin
      If Whom=0 then
        StoreElm(RetNo,FNo,ElmNo,FormatFloat('#########.##',Ret[RetNo].LnTaxPayer[LineId]))   //20110510 TV[ElmNo] :=Ret[RetNo].Ln[LineId]
      else
        StoreElm(RetNo,FNo,ElmNo,FormatFloat('#########.##',Ret[RetNo].LnSpouse[LineId]));   //20110510 TV[ElmNo] :=Ret[RetNo].Ln[LineId]
     end;
   end;
  end; {End with}
  Taxsumlist.free;
end;

function  LicenseLevel: eLicenseLevel;
begin
  Result := AppFP.LicenseLevel;
end;

function  LicenseName: string;
begin
  Result := AppFP.ProductName;
end;

Function IsEnterpriseVersion: Boolean; //20231211 Igor
begin
  Result := LicenseLevel = llEnterprise;
end;


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
  Result := False;
  FlName := Trim(ADS.FieldByName('File_Name').AsString);
  If FlName = '' then
  Begin
    AErr := 'Skip record. FileName is empty';
    exit;
  End;
  If Not fileExists(IncludeTrailingBackslash(ASrcDir)+FlName) then
  Begin
    AErr := 'Skip record. File "'+IncludeTrailingBackslash(ASrcDir)+FlName+'" is missing';
    exit;
  End;
  If FileExists(IncludeTrailingBackslash(ADstDir) + FlName) AND not AOverride then //20160615 Igor
  begin
    AErr := 'Record skipped. File "' + FlName + '" exists in destination folder.';
    Exit;
  end;

  WorkRetNo:=ReadReturn(ASrcDir, FlName);
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

    For j:=11 to 11 do StoreElm(WorkRetNo,FNo,j,User.UserName);//20170112 Igor
    For j:=12 to 12 do StoreElm(WorkRetNo,FNo,j,FormatDateTime('yyyy-mm-dd',Date));
    {DateToStr(Date));}
    For j:=13 to 13 do StoreElm(WorkRetNo,FNo,j,TimeToStr(SysUtils.Time));
    if Ret[WorkRetNo].Locked then
      Ret[WorkRetNo].Locked := False;
    If not FileExists(IncludeTrailingBackslash(ADstDir) + FlName) or AOverride then   //20160615 Igor //20160617 Igor
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

function GetLastYearFile(ARetNo: Integer): String; //20160701 Igor
Begin
  result := FetchElm(ARetNo, 'STATUS', c_LastYearElm);
End;

procedure SetLastYearFile(const ARetNo: Integer; AValue: String); //20160701 Igor
begin
  StoreElm(ARetNo, 'STATUS', c_LastYearElm, AValue);
end;

Function IsValidLastYearPgmFolder(AShowMessage: Boolean;
  out AErrorMessage: String): Boolean; //20160704 Igor
Var LastYearPgm,
  LastYearBpl: String;
begin
  AErrorMessage := '';
  Result:=False;
  If OptRec.Dir_PgmLastYr='' then
  begin
    AErrorMessage := 'You should first enter the program directory you used last year'
                +Chr(13)+'See Configure | General Options | Data Directories.'+#13+
                '(Need restart program after configure last year directory)';
    if AShowMessage then
      ShowMessage(AErrorMessage);
    Exit;
  end;
  If (DirectoryExists(OptRec.Dir_PgmLastYr) = false) then
  Begin
    AErrorMessage := 'Last year program’s directory "' + OptRec.Dir_PgmLastYr + '" does not exist.' //20160710 Igor
                  +Chr(13)+'See Configure | General Options | Data Directories'+#13+
                  'You need to Exit and restart the program after changing last year’s data directory';
    if AShowMessage then
      ShowMessage(AErrorMessage);
    exit;
  End;
  If FileExists(OptRec.Dir_PgmLastYr+'\'+FormsDBLite)=false then
  Begin
    if FileExists(OptRec.Dir_PgmLastYr+'\'+ChangeFileExt(FormsDBLite,'.DBF')) = False then
    Begin
      AErrorMessage := 'Last Year'+Chr(39)+'s directory "' + OptRec.Dir_PgmLastYr + '" does not have a VisualTax form data base' //20160710 Igor
                  +Chr(13)+'See Configure | General Options | Data Directories';
      if AShowMessage then
        ShowMessage(AErrorMessage);
      Exit;
    End;
  End;
  LastYearPgm := AppName+IntToStr(StrToInt(AppYear)-1)+'.EXE';
  LastYearBpl := 'vt'+AppName+'_'+IntToStr(StrToInt(AppYear)-1)+'.bpl';
  If not FileExists(OptRec.Dir_PgmLastYr+'\'+LastYearPgm) AND
     not FileExists(OptRec.Dir_PgmLastYr+'\'+LastYearBpl) then
  Begin
     AErrorMessage := 'Last Year'+Chr(39)+'s directory "' + OptRec.Dir_PgmLastYr + '" does not have a VisualTax system files' //20160710 Igor
                  +Chr(13)+'See Configure | General Options | Data Directories';
     if AShowMessage then
       ShowMessage(AErrorMessage);
    exit;
  End;
  //all tests passed
  result:=True;
end;

function isValidLastYearDataFolder(AShowMessage: Boolean;
  out AErrorMessage: String): Boolean; //20160704 Igor
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

  //20160711 Igor
  If (DirectoryExists(OptRec.Dir_LastYr) = false) then
  Begin
    AErrorMessage := 'Last year data directory "' + OptRec.Dir_LastYr + '" does not exist.' //20160710 Igor
                  +Chr(13)+'See Configure | General Options | Data Directories';
    if AShowMessage then //20160516 Igor
      ShowMessage(AErrorMessage);
    exit;
  End;

  If not FileExists(OptRec.Dir_LastYr+'\' + OptRec.ClientsDBLite) then
  begin
    if not FileExists(OptRec.Dir_LastYr+'\' + ClientsTable_dbf) then
    Begin
      AErrorMessage := 'Last Year'+Chr(39)+'s directory "' + OptRec.Dir_LastYr + '" does not have a VisualTax Client data base' //20160710 Igor
                    +Chr(13)+'See Configure | General Options | Data Directories';
      if AShowMessage then
        ShowMessage(AErrorMessage);
      Exit;
    End;
  end;
  result := True;
End;

procedure InitLastYearFormsTable; //20160704 Igor
var
  LastYearDir: string;
  F: TextFile;
begin
  LastYearDir := OptRec.Dir_PgmLastYr;
  If not DirectoryExists(LastYearDir) then Exit;
  If FileExists(LastYearDir+'\'+FormsDBLite) then
  Begin
    FullPathFPScr_LastYear := LastYearDir+'\'+FormsDBLite; //use original db file
  End
  else
  if Fileexists(LastYearDir+'\'+ChangeFileExt(FormsDBLite,'.DBF')) then
  begin
    FullPathFPScr_LastYear := LastYearDir+'\'+ChangeFileExt(FormsDBLite,'.DBF'); //use converted db
  end
  else
    exit; //bad directory
  If not FileExists(LastYearDir+'\'+FieldsListD) then
  begin //create empty file
    assign(F,LastYearDir+'\'+FieldsListD);
    rewrite(F);
    CloseFile(F);
  end;

  FLastYearList := TFListFP.Create(AppFP, FormsLimit, FieldsLimit, FullPathFPScr_LastYear, FormsTableLite, LastYearDir);
  //20160710 Igor
  if not FLastYearList.InitFormsTable(LastYearDir, FullPathFPScr_LastYear, FormsTableLite) then
  Begin
    freeAndNil(FLastYearList);
    exit;
  End;
end;

Function GetRenamedFName(FName: String): String; //20160704 Igor
Var
  Templist: TStringList;
  FInst: String;
  i: integer;
begin
  Result:=Fname;
  if FileExists(AppDir+'\'+'Substit.d') then
  begin
    TempList:=TStringList.Create;
    TempList.LoadFromFile(AppDir+'\'+'Substit.d');
    FInst:=ExtractFormInst(FName);
    FName:=ExtractFormRootName(FName);
    For i := 0 to templist.count - 1 do
      If UpperCase(FName) = RTrim(UpperCase(LeftStr(TempList[i],10))) then
      begin
        Result := UpperCase(AllTrim(MidStr(TempList[i],14,10)));
        Result := Result + FInst;
        TempList.Free;
        Exit;
      end;
      TempList.Free;
  end;
end;

function GetLastYearFormNo(FormName: String):Integer; //20160704 Igor
begin
   Result:=FLastYearList.ByFormName(UpperCase(FormName)).FormNo;
end;

function GetLastYearFormName(FormNo: integer):String; //20160704 Igor
begin
  Result := FLastYearList.GetFormName(FormNo);
end;

Function ShowUnconvertedLastYear(RNo:Integer): Boolean; //20160704 Igor
begin
  Result:=False;
  If RNo = 0 then
    exit;
  Result := Ret[RNo].IsLastYearReturn;
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

End.
