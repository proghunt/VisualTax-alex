unit T3_2026dataGen;

//notation:  B1220 is the fieldcode 1220  which happens to be in S1  (AformsS1 elm 97)  //20190331

interface

uses Classes, StrUtils; //,Dialogs,SysUtils,T3_2026declare,T3_2026trimstr;

const
 indent = 3;
 indentM = 6;
 indentMM = 9;
 indentMMM = 12;
 indentMMMM = 15;
 indentMMMMM = 18;

 Type
  AT3Rec  = Record
    //Ind=Individual Ben=Beneficiary
    IndBenSurname                               : String[20];
    IndBenFirstName                             : String[12];
    IndBenInitial                               : String[1];
    IndBenSurname2                              : String[20];
    IndBenFirstName2                            : String[12];
    IndBenInitial2                              : String[1];
    CorpBenNameLn1                              : String[30];
    CorpBenNameLn2                              : String[30];
    BenAddressLn1                               : String[30];
    BenAddressLn2                               : String[30];
    BenCity                                     : String[28];
    BenProvince                                 : String[2];
    BenCountryCode                              : String[3];
    BenPostalCode                               : String[10];
    IndBenSIN                                   : String[9];
    BusinessNumber                              : String[15];
    BenTrustAccountNumber                       : String[9];
    TrustAccountNumber                          : String[9];
    //Report Type Code                          : String[1];
    BeneficiaryCode                             : String[1];
    ITCCode                                     : String[1]; //Investment tax credit code

    //T3 amounts
    CapitalGains                                : String[11];
    Period2CapitalGains                         : String[11];
    Period3CapitalGains                         : String[11];
    ActualAmountDividendNotEligible             : String[11];
    OtherIncome                                 : String[11];
    TotalCapitalGainsEligible                   : String[11];
    Period2CapitalGainsEligible                 : String[11];
    Period3CapitalGainsEligible                 : String[11];
    TaxableAmountDividendsNotEligible           : String[11];
    Period2InsuranceSegregatedFundCapitalLosses : String[11];
    Period3InsuranceSegregatedFundCapitalLosses : String[11];
    DividendTaxCreditNotEligible                : String[11];
    ActualAmountEligibleDividends               : String[11];
    TaxableAmountEligibleDividends              : String[11];
    DividendTaxCreditEligibleDividends          : String[11];

    //T3 other info
    LumpSumPensionBenefits                      : String[11];
    ForeignBusIncome                            : String[11];
    ForeignNonBusIncome                         : String[11];
    EligiblePensionIncome                       : String[11];
    ForeignBusinessIncometaxPaid                : String[11];
    ForeignNonBusinessIncomeTaxPaid             : String[11];
    EligibleDeathBenefits                       : String[11];
    InsuranceSegregatedFundCapitalLosses        : String[11];
    PartXII2TaxCredit                           : String[11];
    InvestmentCostExpenditure                   : String[11];
    ITCTaxCredit                                : String[11];
    AmountsResultingCostBaseAdjustment          : String[11];
    OtherCredits                                : String[11];
    PensionIncomeEligibleTransfer               : String[11];
    RetiringAllowanceEligibleTransfer           : String[11];
    CharitableDonationsGiftsCommunalOrg         : String[11];

    //T3 Summary
    //TrustAccountNumber                          : String[9]; declared above
    TrustNameLn1                                : String[30];
    TrustNameLn2                                : String[30];
    TrusteeExecutorAdminName                    : String[30];
    TrusteeAddressLn1                           : String[30];
    TrusteeAddressLn2                           : String[30];
    TrusteeCity                                 : String[28];
    TrusteeProvinceCode                         : String[2];
    TrusteeCountryCode                          : String[3];
    TrusteePostalCode                           : String[10];
    ContactName                                 : String[22];
    ContactAreaCode                             : String[3];
    ContactTelephoneNumber                      : String[8];
    ContactExtension                            : String[5];
    TaxationYear                                : String[4];
    //Report Type Code                          : String[1];
    TotalNumberT3SlipRecords                    : String[7];
    StartTrustTaxYearDay                        : String[2];
    StartTrustTaxYearMonth                      : String[2];
    StartTrustTaxYearYear                       : String[4];
    EndTrustTaxYearDay                          : String[2];
    EndTrustTaxYearMonth                        : String[2];
    EndTrustTaxYearYear                         : String[4];

    //T3 totals amounts
    TotalCapitalGains                           : String[13];
    TotalLumpSumPensionBenefits                 : String[13];
    TotalActualDividendsNotEligible             : String[13];
    TotalActualEligibleDividends                : String[13];
    TotalTaxableEligibleDividends               : String[13];
    TotalDividendTaxCreditEligible              : String[13];
    TotalForeignBusinessIncome                  : String[13];
    TotalForeignNonBusinessIncome               : String[13];
    TotalOtherIncome                            : String[13];
    TotalCapitalGainsEligibleDeduction          : String[13];
    TotalEligiblePensionincome                  : String[13];
    TotalTaxableDividendsNotEligible            : String[13];
    TotalForeignBusinessIncomeTaxPaid           : String[13];
    TotalForeignNonBusinessIncomeTaxPaid        : String[13];
    TotalEligibleDeathBenefits                  : String[13];
    TotalPensionIncomeEligibleTransfer          : String[13];
    TotalRetiringAllowanceEligibleTransfer      : String[13];
    TotalCharitableDonations                    : String[13];
    TotalInsuranceSegregatedFundCapitalLosses   : String[13];
    TotalPartXII2TaxCredit                      : String[13];
    TotalDividendTaxCreditNotEligible           : String[13];
    TotalEligibleITC                            : String[13];
    TotalITC                                    : String[13];
    TotalOtherCredits                           : String[13];
 end; //type AT3Rec

 //20180314 Igor >>>
 Type
  AT3RetRec  = Record
    TaxYearEndTrustResidenceCountryCode         : String[3];
    TrustCanadianResidenceProvinceCode          : String[2];
    TrustName                                   : String[60];
    TrustAccountNumber                          : String[9];
    TrusteeName                                 : String[60];
    TrusteeAddressLine1Text                     : String[30];
    TrusteeAddressLine2Text                     : String[30];
    TrusteeMunicipalityName                     : String[28];
    TrusteeProvinceStateCode                    : String[2];
    TrusteeCountryCode                          : String[3];
    TrusteePostalZipCode                        : String[10];
    TrusteePhoneAreaCode                        : String[3];
    TrusteePhoneNumber                          : String[8]; //String[3]; //20180317 CON
    TrusteePhoneExtensionNumber                 : String[5];
    NonTrusteeContactName                       : String[60];
    NonTrusteeAddressLine1Text                  : String[30];
    NonTrusteeAddressLine2Text                  : String[30];
    NonTrusteeMunicipalityName                  : String[28];
    NonTrusteeProvinceStateCode                 : String[2];
    NonTrusteeCountryCode                       : String[3];
    NonTrusteePostalZipCode                     : String[10];
    NonTrusteePhoneAreaCode                     : String[3];
    NonTrusteePhoneNumber                       : String[8]; ////String[3]; //20180317 CON
    NonTrusteePhoneExtensionNumber              : String[5];
    SettlementLandName                          : String[60];
    SettlementLandNumber                        : String[5];
    TrustBusinessIncomeProvince                 : String[60];
    TrustCanadianResidentStartYear              : String[4];
    TrustCanadianResidentStartMonth             : String[2];
    TrustCanadianResidentStartDay               : String[2];
    TrustCanadianResidentEndYear                : String[4];
    TrustCanadianResidentEndMonth               : String[2];
    TrustCanadianResidentEndDay                 : String[2];
    TrustDeemedCanadianResidentIndicator        : String[1];
    TrustForeignResidentCountry                 : String[60];
    TrustCorrespondenceLanguageCode             : String[1];
    TrustTypeCode                               : String[3];
    TrustTypeDescription                        : String[60];
    TestatorDeathYear                           : String[4];
    TestatorDeathMonth                          : String[2];
    TestatorDeathDay                            : String[2];
    TestatorSIN                                 : String[9];
    TrustCreateYear                             : String[4];
    TrustCreateMonth                            : String[2];
    TrustCreateDay                              : String[2];
    NonProfitorganizationBN                     : String[15];
    TrustFiscalPeriodStartYear                  : String[4];
    TrustFiscalPeriodStartMonth                 : String[2];
    TrustFiscalPeriodStartDay                   : String[2];
    TrustFiscalPeriodEndYear                    : String[4];
    TrustFiscalPeriodEndMonth                   : String[2];
    TrustFiscalPeriodEndDay                     : String[2];
    FirstYearFilingIndicator                    : String[1];
    TrustPreviousGeneralIncomeTaxReturnTaxYear  : String[4];
    TrustDocumentFilingMethod                   : String[9];
    TrustFinalGeneralIncomeTaxReturnIndicator   : String[1];
    TrustWindupYear                             : String[4];
    TrustWindupMonth                            : String[2];
    TrustWindupDay                              : String[2];
    TrustForeignPropertyCostExceedingIndicator  : String[1];
    ElectingTrustIndicator                      : String[1];
    TrustNonResidentIncomeElectionYear          : String[4];

    TrustIncomeBeneficiaryAllocationRequiredIndicator         : String[1];
    TrustNonCashAssetBeneficiaryDistributionIndicator         : String[1];
    TrustBeneficiaryChangeIndicator                           : String[1];
    TrustDeemedDispositionBeneficiaryDeathIndicator           : String[1];
    TrustDeemedDispositionBeneficiaryDeathYear                : String[4];
    TrustDeemedDispositionBeneficiaryDeathMonth               : String[2];
    TrustDeemedDispositionBeneficiaryDeathDay                 : String[2];
    TrustNonArmsLengthDebtTransactionIndicator                : String[1];
    TrustNonArmsLengthDebtTransactionYear                     : String[4];
    TrustCapitalIncomeInterestOwnershipChangeIndicator        : String[1];
    TrustCapitalIncomeInterestOwnershipChangeYear             : String[4];
    TrustPrivateCorporationShareHolderIndicator               : String[1];
    TrustAdditionalContributionPropertyReceiptIndicator       : String[1];
    TrustAdditionalContributionPropertyReceiptYear            : String[4];
    PublicTrustIndicator                                      : String[1];
    TrustInternationalFinancialReportingStandardIndicator     : String[1];
    TrustLossRestrictionEventIndicator                        : String[1];
    TrustLossRestrictionEventYear                             : String[4];
    TrustLossRestrictionEventMonth                            : String[2];
    TrustLossRestrictionEventDay                              : String[2];

    TaxableCapitalGainAmount                        : String[13];
    PensionIncomeAmount                             : String[13];
    TaxableCanadianCorporationActualDividendAmount  : String[13];
    ForeignInvestmentIncomeAmount                   : String[13];
    OtherInvestmentIncomeAmount                     : String[13];
    BusinessGrossIncomeAmount                       : String[13];
    BusinessNetIncomeAmount                         : String[13];
    FarmingFishingGrossIncomeAmount                 : String[13];
    FarmingFishingNetIncomeAmount                   : String[13];
    RealEstatePropertyRentalGrossIncomeAmount       : String[13];
    RealEstatePropertyRentalNetIncomeAmount         : String[13];
    AgriInvestFund2IncomeAmount                     : String[13];
    TrustBeneficiarySpouseAliveCommunalOrganizationAgriInvestFund2IncomeAmount : String[13];
    DeemedPropertyDispositionNetIncomeAmount        : String[13];
    OtherIncomeAmount                               : String[13];
    InvestmentFeeInterestPaidAmount                 : String[13];
    TrusteeFeeAmount                                : String[13];
    NonDeductibleTrusteeFeeAmount                   : String[13];
    AllowableBusinessInvestmentLossAmount           : String[13];
    GrossIncomeOtherDeductionAmount                 : String[13];
    TrustTaxableBeneficiaryPropertyExpenseBenefitAmount       : String[13];
    TrustTaxableOtherBeneficiaryBenefitAmount       : String[13];
    TrustAllocationIncomeAmount                     : String[13];
    TrustRetainedAllocationIncomeAmount             : String[13];
    TrustDeductibleAllocationIncomeAmount           : String[13];
    TrustRetainedDividendGrossUpAmount              : String[13];
    NetIncomeAmount                                 : String[13];
    NonCapitalLossCarryforwardAmount                : String[13];
    NetCapitalLossCarryforwardAmount                : String[13];
    NetIncomeOtherDeductionDescription              : String[13];
    NetIncomeOtherDeductionAmount                   : String[13];
    TaxableIncomeAmount                             : String[13];
    TotalTaxPayableAmount                           : String[13];
    IncomeTaxBalanceAmount                          : String[13];

    B1011                             : String[13];
    B1012                             : String[13];
    B1021                             : String[13];
    B1022                             : String[13];
    B1031                             : String[13];
    B1032                             : String[13];
    B1041                             : String[13];
    B1042                             : String[13];
    B1051                             : String[13];
    B1052                             : String[13];
    B1061                             : String[13];
    B1062                             : String[13];
    B1071                             : String[13];
    B1072                             : String[13];
    B1080                             : String[13];
    B1100                             : String[13];
    B1130                             : String[13];
    B1170                             : String[13];
    B1191                             : String[13];
    B1646                             : String[13];
    B1091                             : String[13];
    B1092                             : String[13];
    B1220                             : String[13];

    B8110                             : String[13];
    B8120                             : String[13];
    B8160                             : String[13];
    B8170                             : String[13];
    B8180                             : String[13];
    B8190                             : String[13];
    B8239                             : String[13];
    B8240                             : String[13];

    B9001                             : String[13];
    B9002                             : String[13];
    B9003                             : String[13];
    B9004                             : String[13];
    SlipIndividualAttributedAmountIndicator       : String[1];
    IncomeEqualAllocationIndicator                : String[1];

    B921_1                            : String[13];
    B921_2                            : String[13];
    B921_3                            : String[13];
    B922_1                            : String[13];
    B922_2                            : String[13];
    B923_1                            : String[13];
    B923_2                            : String[13];
    B923_3                            : String[13];
    B924_1                            : String[13];
    B924_2                            : String[13];
    B924_3                            : String[13];
    B925_1                            : String[13];
    B925_2                            : String[13];
    B925_3                            : String[13];
    B926_1                            : String[13];
    B926_2                            : String[13];
    B926_3                            : String[13];
    B949_1                            : String[13];
    B949_2                            : String[13];
    B949_3                            : String[13];
    B930_1                            : String[13];
    B930_2                            : String[13];
    B930_3                            : String[13];
    B931_1                            : String[13];
    B932_1                            : String[13];
    B932_3                            : String[13];
    B933_1                            : String[13];
    B933_2                            : String[13];
    B933_3                            : String[13];
    B934_1                            : String[13];
    B934_2                            : String[13];
    B934_3                            : String[13];
    B935_1                            : String[13];
    B935_2                            : String[13];
    B937_1                            : String[13];
    B937_2                            : String[13];
    B938_1                            : String[13];
    B939_1                            : String[13];
    B939_3                            : String[13];
    B940_1                            : String[13];
    B940_2                            : String[13];
    B940_3                            : String[13];
    B941_1                            : String[13];
    B941_2                            : String[13];
    B941_3                            : String[13];
    B942_1                            : String[13];
    B942_2                            : String[13];
    B942_3                            : String[13];
    B945_1                            : String[13];
    B945_2                            : String[13];
    B945_3                            : String[13];
    B946_1                            : String[13];
    B946_2                            : String[13];
    B947_1                            : String[13];
    B947_2                            : String[13];
    B948_1                            : String[13];
    B948_2                            : String[13];
    B950_1                            : String[13];
    B950_3                            : String[13];
    B951_1                            : String[13];
    B951_3                            : String[13];

    B12030                            : String[13];
    B12040                            : String[13];
    B12050                            : String[13];
    B12060                            : String[13];
    B12080                            : String[13];
    B12090                            : String[13];
    B12110                            : String[13];
    B12120                            : String[13];
    B12130                            : String[13];
    B12160                            : String[13];
    B12170                            : String[13];
    B12220                            : String[13];
    B12221                            : String[13];
    B12240                            : String[13];
    B12260                            : String[13];
    B12270                            : String[13];
    B12680                            : String[13];
    B12760                            : String[13];
    B12690                            : String[13];
 end;
 //20180314 Igor <<<


 procedure addSubmissionTag(tag:String;Var XmlList:tstringlist);

 Procedure PrepareT3SummaryRec(RetNo:Integer;FName:String);
 Procedure PrepareT3SlipRec(RetNo:Integer;FName:String);
 Procedure PrepareT3RetRec(RetNo:Integer); //20180314 Igor
 procedure createT3XML(RetNo:Integer;DataTypeCode:String;SubmitRef:String;Var T3XmlList:tstringlist);
 procedure createT3RetXML(RetNo:Integer;DataTypeCode:String;SubmitRef:String;Var T3XmlList:tstringlist); //20180314 Igor

 Procedure PrepareT619(Var T619XmlList:TStringList;RetNo:integer;DataTypeCode:String;SubmitRef:String);

 Function ReplaceSpecialChar(info:String):String;
 Function FixPostal(s:String):String;

var
T3Rec    : AT3Rec;
T3RetRec : AT3RetRec; //20180314 Igor


implementation

uses //Classes,Dialogs,
  SysUtils, DateUtils, //20180314 Igor
  vtCommon,
  T3_2026,T3_2026declare,T3_2026trimstr,
  vtTrimStr, vtShared, T3_2026Common2, Variants; //20180314 Igor

Procedure PrepareT3RetRec(RetNo:Integer); //20180314 Igor
var
  AYear, AMonth, ADay: string;
  AFormT3, AFormS1, AFormS8, AFormS9, AFormS12: string;

  procedure PrepareDate(ADate: String);
  var arr: TArray<String>;
  begin
    AYear := '';
    AMonth := '';
    ADay := '';
    if Trim(ADate) = '' then Exit;
    arr := ADate.Split(['-'], ExcludeEmpty);
    if Length(arr) < 3 then Exit;
    AYear := AddLeadingZeros(arr[0], 4);
    AMonth := AddLeadingZeros(arr[1], 2);
    ADay := AddLeadingZeros(arr[2], 2);
  end;

  function Checked(AValue: string): boolean;
  begin
    Result := SameText(AValue, 'X');
  end;

  function GetYesNo(AFormName: string; AYesIndex, ANoIndex: integer): string;
  begin
    if Checked(FetchElm(RetNo, AFormName, AYesIndex)) then
      Result := 'Y'
    else if Checked(FetchElm(RetNo, AFormName, ANoIndex)) then
      Result := 'N'
    else
      Result := '';
  end;

begin

  AFormT3 := 'T3';
  AFormS1 := 'S1';
  AFormS8 := 'S8';
  AFormS9 := 'S9';
  AFormS12 := 'S12';

  with T3RetRec do
  begin
    TaxYearEndTrustResidenceCountryCode         := LeftStr(FetchElm(RetNo, AFormT3, 11), 2);
    TrustCanadianResidenceProvinceCode          := GetShortPrv(FetchElm(RetNo, AFormT3, 9));
    TrustName                                   := FetchElm(RetNo, AFormT3, 1);
    TrustAccountNumber                          := 'T' + FetchElm(RetNo, AFormT3, 2);
    TrusteeName                                 := FetchElm(RetNo, AFormT3, 3);
    TrusteeAddressLine1Text                     := LeftStr(FetchElm(RetNo, AFormT3, 4), 30);
    TrusteeAddressLine2Text                     := MidStr(FetchElm(RetNo, AFormT3, 4), 31, 30);
    TrusteeMunicipalityName                     := FetchElm(RetNo, AFormT3, 7);
    TrusteeProvinceStateCode                    := FetchElm(RetNo, AFormT3, 67); //20180329
    TrusteeCountryCode                          := '';
    TrusteePostalZipCode                        := FetchElm(RetNo, AFormT3, 8);
    TrusteePhoneAreaCode                        := FetchElm(RetNo, AFormT3, 5);
    TrusteePhoneNumber                          := FetchElm(RetNo, AFormT3, 6);
    TrusteePhoneExtensionNumber                 := '';
    //NonTrusteeContactName                       :=
    NonTrusteeAddressLine1Text                  := LeftStr(FetchElm(RetNo, AFormT3, 21), 30);
    NonTrusteeAddressLine2Text                  := MidStr(FetchElm(RetNo, AFormT3, 21), 31, 30);
    NonTrusteeMunicipalityName                  := FetchElm(RetNo, AFormT3, 57);
    NonTrusteeProvinceStateCode                 := FetchElm(RetNo, AFormT3, 68); //20183103
    NonTrusteeCountryCode                       := '';
    NonTrusteePostalZipCode                     := FetchElm(RetNo, AFormT3, 58);
    NonTrusteePhoneAreaCode                     := FetchElm(RetNo, AFormT3, 12);
    NonTrusteePhoneNumber                       := FetchElm(RetNo, AFormT3, 13);
    NonTrusteePhoneExtensionNumber              := '';
    SettlementLandName                          := FetchElm(RetNo, AFormT3, 18);
    SettlementLandNumber                        := FetchElm(RetNo, AFormT3, 19);
    TrustBusinessIncomeProvince                 := FetchElm(RetNo, AFormT3, 10);

    PrepareDate(FetchElm(RetNo, AFormT3, 22));
    TrustCanadianResidentStartYear              := AYear;
    TrustCanadianResidentStartMonth             := AMonth;
    TrustCanadianResidentStartDay               := ADay;

    PrepareDate(FetchElm(RetNo, AFormT3, 52));
    TrustCanadianResidentEndYear                := AYear;
    TrustCanadianResidentEndMonth               := AMonth;
    TrustCanadianResidentEndDay                 := ADay;
    TrustDeemedCanadianResidentIndicator        := GetYesNo(AFormT3, 56, 76);
    TrustForeignResidentCountry                 := FetchElm(RetNo, AFormT3, 61);

    if Checked(FetchElm(RetNo, AFormT3, 47)) then
      TrustCorrespondenceLanguageCode        := 'E'
    else if Checked(FetchElm(RetNo, AFormT3, 59)) then
      TrustCorrespondenceLanguageCode        := 'F'
    else
      TrustCorrespondenceLanguageCode        := '';

    //20180329
    If      FetchElm(RetNo, AFormT3, 43) > '' then TrustTypeCode:='903'
    Else If FetchElm(RetNo, AFormT3, 45) > '' then TrustTypeCode:='904'
    Else If FetchElm(RetNo, AFormT3, 81) > '' then TrustTypeCode:=FetchElm(RetNo, AFormT3, 81);

    TrustTypeDescription                        := FetchElm(RetNo, AFormT3, 82) + FetchElm(RetNo, AFormT3, 83);

    PrepareDate(FetchElm(RetNo, AFormT3, 20));
    TestatorDeathYear                           := AYear;
    TestatorDeathMonth                          := AMonth;
    TestatorDeathDay                            := ADay;

    TestatorSIN                                 := FetchElm(RetNo, AFormT3, 25);

    PrepareDate(FetchElm(RetNo, AFormT3, 51));
    TrustCreateYear                             := AYear;
    TrustCreateMonth                            := AMonth;
    TrustCreateDay                              := ADay;

    NonProfitorganizationBN                     := FetchElm(RetNo, AFormT3, 44);

    PrepareDate(FetchElm(RetNo, AFormT3, 14));
    TrustFiscalPeriodStartYear                  := AYear;
    TrustFiscalPeriodStartMonth                 := AMonth;
    TrustFiscalPeriodStartDay                   := ADay;

    PrepareDate(FetchElm(RetNo, AFormT3, 17));
    TrustFiscalPeriodEndYear                    := AYear;
    TrustFiscalPeriodEndMonth                   := AMonth;
    TrustFiscalPeriodEndDay                     := ADay;
    FirstYearFilingIndicator                    := GetYesNo(AFormT3, 27, 26);
    TrustPreviousGeneralIncomeTaxReturnTaxYear  := FetchElm(RetNo, AFormT3, 28);

    if Checked(FetchElm(RetNo, AFormT3, 72)) then
      TrustDocumentFilingMethod        := 'WITHT3APP'
    else if Checked(FetchElm(RetNo, AFormT3, 30)) then
      TrustDocumentFilingMethod        := 'WITHT1'
    else
      TrustDocumentFilingMethod        := '';

    TrustFinalGeneralIncomeTaxReturnIndicator   := GetYesNo(AFormT3, 49, 22);

    PrepareDate(FetchElm(RetNo, AFormT3, 54));
    TrustWindupYear                             := AYear;
    TrustWindupMonth                            := AMonth;
    TrustWindupDay                              := ADay;

    TrustForeignPropertyCostExceedingIndicator  := GetYesNo(AFormT3, 363, 362);
    ElectingTrustIndicator                      := GetYesNo(AFormT3, 128, 127);
    TrustNonResidentIncomeElectionYear          := FetchElm(RetNo, AFormT3, 129);

    TrustIncomeBeneficiaryAllocationRequiredIndicator         := GetYesNo(AFormT3, 131, 130);
    TrustNonCashAssetBeneficiaryDistributionIndicator         := GetYesNo(AFormT3, 135, 134);
    TrustBeneficiaryChangeIndicator                           := GetYesNo(AFormT3, 33, 34);
    TrustDeemedDispositionBeneficiaryDeathIndicator           := GetYesNo(AFormT3, 35, 36);

    PrepareDate(FetchElm(RetNo, AFormT3, 42));
    TrustDeemedDispositionBeneficiaryDeathYear                := AYear;
    TrustDeemedDispositionBeneficiaryDeathMonth               := AMonth;
    TrustDeemedDispositionBeneficiaryDeathDay                 := ADay;

    TrustNonArmsLengthDebtTransactionIndicator                := GetYesNo(AFormT3, 139, 138);
    TrustNonArmsLengthDebtTransactionYear                     := FetchElm(RetNo, AFormT3, 150);
    TrustCapitalIncomeInterestOwnershipChangeIndicator        := GetYesNo(AFormT3, 37, 38);
    TrustCapitalIncomeInterestOwnershipChangeYear             := FetchElm(RetNo, AFormT3, 41);
    TrustPrivateCorporationShareHolderIndicator               := GetYesNo(AFormT3, 39, 40);
    TrustAdditionalContributionPropertyReceiptIndicator       := GetYesNo(AFormT3, 158, 157);
    TrustAdditionalContributionPropertyReceiptYear            := FetchElm(RetNo, AFormT3, 159);
    PublicTrustIndicator                                      := GetYesNo(AFormT3, 141, 152);
    TrustInternationalFinancialReportingStandardIndicator     := GetYesNo(AFormT3, 153, 154);
    TrustLossRestrictionEventIndicator                        := GetYesNo(AFormT3, 70, 71);

    PrepareDate(FetchElm(RetNo, AFormT3, 69));
    TrustLossRestrictionEventYear                             := AYear;
    TrustLossRestrictionEventMonth                            := AMonth;
    TrustLossRestrictionEventDay                              := ADay;

    TaxableCapitalGainAmount                        := FetchElm(RetNo, AFormT3, 101);
    PensionIncomeAmount                             := FetchElm(RetNo, AFormT3, 102);
    TaxableCanadianCorporationActualDividendAmount  := FetchElm(RetNo, AFormT3, 103);
    ForeignInvestmentIncomeAmount                   := FetchElm(RetNo, AFormT3, 104);
    OtherInvestmentIncomeAmount                     := FetchElm(RetNo, AFormT3, 105);
    BusinessGrossIncomeAmount                       := FetchElm(RetNo, AFormT3, 106);
    BusinessNetIncomeAmount                         := FetchElm(RetNo, AFormT3, 107);
    FarmingFishingGrossIncomeAmount                 := FetchElm(RetNo, AFormT3, 108);
    FarmingFishingNetIncomeAmount                   := FetchElm(RetNo, AFormT3, 109);
    RealEstatePropertyRentalGrossIncomeAmount       := FetchElm(RetNo, AFormT3, 112);
    RealEstatePropertyRentalNetIncomeAmount         := FetchElm(RetNo, AFormT3, 113);
    AgriInvestFund2IncomeAmount                     := FetchElm(RetNo, AFormT3, 114);
    TrustBeneficiarySpouseAliveCommunalOrganizationAgriInvestFund2IncomeAmount := FetchElm(RetNo, AFormT3, 115);
    DeemedPropertyDispositionNetIncomeAmount        := FetchElm(RetNo, AFormT3, 116);
    OtherIncomeAmount                               := FetchElm(RetNo, AFormT3, 124);
    InvestmentFeeInterestPaidAmount                 := FetchElm(RetNo, AFormT3, 227);
    TrusteeFeeAmount                                := FetchElm(RetNo, AFormT3, 228);
    NonDeductibleTrusteeFeeAmount                   := FetchElm(RetNo, AFormT3, 229);
    AllowableBusinessInvestmentLossAmount           := FetchElm(RetNo, AFormT3, 232);
    GrossIncomeOtherDeductionAmount                 := FetchElm(RetNo, AFormT3, 244);
    TrustTaxableBeneficiaryPropertyExpenseBenefitAmount       := FetchElm(RetNo, AFormT3, 248);
    TrustTaxableOtherBeneficiaryBenefitAmount       := FetchElm(RetNo, AFormT3, 249);
    TrustAllocationIncomeAmount                     := FetchElm(RetNo, AFormT3, 202);
    TrustRetainedAllocationIncomeAmount             := FetchElm(RetNo, AFormT3, 203);
    TrustDeductibleAllocationIncomeAmount           := FetchElm(RetNo, AFormT3, 253);
    TrustRetainedDividendGrossUpAmount              := FetchElm(RetNo, AFormT3, 255);
    NetIncomeAmount                                 := FetchElm(RetNo, AFormT3, 256);
    if NetIncomeAmount='' then NetIncomeAmount:='0';   //20180319               //NEW LINE
    NonCapitalLossCarryforwardAmount                := FetchElm(RetNo, AFormT3, 265);
    NetCapitalLossCarryforwardAmount                := FetchElm(RetNo, AFormT3, 266);
    NetIncomeOtherDeductionDescription              := FetchElm(RetNo, AFormT3, 268);
    NetIncomeOtherDeductionAmount                   := FetchElm(RetNo, AFormT3, 269);
    TaxableIncomeAmount                             := '0';   //20190401
    TotalTaxPayableAmount                           := '0.00';
    IncomeTaxBalanceAmount                          := '0.00';

    B1011                             := FetchElm(RetNo, AFormS1, 105);
    B1012                             := FetchElm(RetNo, AFormS1, 106);
    B1021                             := FetchElm(RetNo, AFormS1, 113);
    B1022                             := FetchElm(RetNo, AFormS1, 114);
    B1031                             := FetchElm(RetNo, AFormS1, 18);
    B1032                             := FetchElm(RetNo, AFormS1, 19);
    B1041                             := FetchElm(RetNo, AFormS1, 60);
    B1042                             := FetchElm(RetNo, AFormS1, 61);
    B1051                             := FetchElm(RetNo, AFormS1, 35);
    B1052                             := FetchElm(RetNo, AFormS1, 36);
    B1061                             := FetchElm(RetNo, AFormS1, 38);
    B1062                             := FetchElm(RetNo, AFormS1, 81);
    B1071                             := FetchElm(RetNo, AFormS1, 84);
    B1072                             := FetchElm(RetNo, AFormS1, 87);
    B1080                             := FetchElm(RetNo, AFormS1, 88);
    B1100                             := FetchElm(RetNo, AFormS1, 89);
    B1130                             := FetchElm(RetNo, AFormS1, 91);
    B1170                             := '0';
    B1191                             := FetchElm(RetNo, AFormS1, 129);
    B1646                             := FetchElm(RetNo, AFormS1, 96);
    B1091                             := FetchElm(RetNo, AFormS1, 115);
    B1092                             := FetchElm(RetNo, AFormS1, 118);
    B1220                             := FetchElm(RetNo, AFormS1, 97);

    B8110                             := FetchElm(RetNo, AFormS8, 4);
    B8120                             := FetchElm(RetNo, AFormS8, 13);
    B8160                             := FetchElm(RetNo, AFormS8, 15);
    B8170                             := FetchElm(RetNo, AFormS8, 16);
    B8180                             := FetchElm(RetNo, AFormS8, 17);
    B8190                             := FetchElm(RetNo, AFormS8, 38);
    B8239                             := FetchElm(RetNo, AFormS8, 23);
    B8240                             := FetchElm(RetNo, AFormS8, 29);

    B9001                             := FetchElm(RetNo, AFormS9, 3);
    B9002                             := FetchElm(RetNo, AFormS9, 4);
    B9003                             := FetchElm(RetNo, AFormS9, 124);
    B9004                             := FetchElm(RetNo, AFormS9, 125);
    SlipIndividualAttributedAmountIndicator       := GetYesNo(AFormS9, 1, 2);
    IncomeEqualAllocationIndicator                := GetYesNo(AFormS9, 5, 6);

    B921_1                            := FetchElm(RetNo, AFormS9, 7);
    B921_2                            := FetchElm(RetNo, AFormS9, 8);
    B921_3                            := FetchElm(RetNo, AFormS9, 9);
    B922_1                            := FetchElm(RetNo, AFormS9, 11);
    B922_2                            := FetchElm(RetNo, AFormS9, 12);
    B923_1                            := FetchElm(RetNo, AFormS9, 14);
    B923_2                            := FetchElm(RetNo, AFormS9, 15);
    B923_3                            := FetchElm(RetNo, AFormS9, 16);
    B924_1                            := FetchElm(RetNo, AFormS9, 18);
    B924_2                            := FetchElm(RetNo, AFormS9, 19);
    B924_3                            := FetchElm(RetNo, AFormS9, 20);
    B925_1                            := FetchElm(RetNo, AFormS9, 22);
    B925_2                            := FetchElm(RetNo, AFormS9, 23);
    B925_3                            := FetchElm(RetNo, AFormS9, 24);
    B926_1                            := FetchElm(RetNo, AFormS9, 26);
    B926_2                            := FetchElm(RetNo, AFormS9, 27);
    B926_3                            := FetchElm(RetNo, AFormS9, 28);
    B949_1                            := FetchElm(RetNo, AFormS9, 109);
    B949_2                            := FetchElm(RetNo, AFormS9, 110);
    B949_3                            := FetchElm(RetNo, AFormS9, 111);
    B930_1                            := FetchElm(RetNo, AFormS9, 34);
    B930_2                            := FetchElm(RetNo, AFormS9, 35);
    B930_3                            := FetchElm(RetNo, AFormS9, 36);
    B931_1                            := FetchElm(RetNo, AFormS9, 38);
    B932_1                            := FetchElm(RetNo, AFormS9, 40);
    B932_3                            := FetchElm(RetNo, AFormS9, 41);
    B933_1                            := FetchElm(RetNo, AFormS9, 43);
    B933_2                            := FetchElm(RetNo, AFormS9, 44);
    B933_3                            := FetchElm(RetNo, AFormS9, 45);
    B934_1                            := FetchElm(RetNo, AFormS9, 47);
    B934_2                            := FetchElm(RetNo, AFormS9, 48);
    B934_3                            := FetchElm(RetNo, AFormS9, 49);
    B935_1                            := FetchElm(RetNo, AFormS9, 51);
    B935_2                            := FetchElm(RetNo, AFormS9, 52);
    B937_1                            := FetchElm(RetNo, AFormS9, 63);
    B937_2                            := FetchElm(RetNo, AFormS9, 64);
    B938_1                            := FetchElm(RetNo, AFormS9, 66);
    B939_1                            := FetchElm(RetNo, AFormS9, 68);
    B939_3                            := FetchElm(RetNo, AFormS9, 69);
    B940_1                            := FetchElm(RetNo, AFormS9, 71);
    B940_2                            := FetchElm(RetNo, AFormS9, 72);
    B940_3                            := FetchElm(RetNo, AFormS9, 73);
    B941_1                            := FetchElm(RetNo, AFormS9, 75);
    B941_2                            := FetchElm(RetNo, AFormS9, 76);
    B941_3                            := FetchElm(RetNo, AFormS9, 77);
    B942_1                            := FetchElm(RetNo, AFormS9, 84);
    B942_2                            := FetchElm(RetNo, AFormS9, 106);
    B942_3                            := FetchElm(RetNo, AFormS9, 107);
    B945_1                            := FetchElm(RetNo, AFormS9, 79);
    B945_2                            := FetchElm(RetNo, AFormS9, 80);
    B945_3                            := FetchElm(RetNo, AFormS9, 81);
    B946_1                            := FetchElm(RetNo, AFormS9, 54);
    B946_2                            := FetchElm(RetNo, AFormS9, 55);
    B947_1                            := FetchElm(RetNo, AFormS9, 57);
    B947_2                            := FetchElm(RetNo, AFormS9, 58);
    B948_1                            := FetchElm(RetNo, AFormS9, 60);
    B948_2                            := FetchElm(RetNo, AFormS9, 61);
    B950_1                            := FetchElm(RetNo, AFormS9, 114);
    B950_3                            := FetchElm(RetNo, AFormS9, 113);
    B951_1                            := FetchElm(RetNo, AFormS9, 117);
    B951_3                            := FetchElm(RetNo, AFormS9, 116);

    B12030                            := FetchElm(RetNo, AFormS12, 24);
    B12040                            := '';
    B12050                            := FetchElm(RetNo, AFormS12, 6);
    B12060                            := FetchElm(RetNo, AFormS12, 7);
    B12080                            := FetchElm(RetNo, AFormS12, 10);
    B12090                            := FetchElm(RetNo, AFormS12, 11);
    B12110                            := FetchElm(RetNo, AFormS12, 14);
    B12120                            := FetchElm(RetNo, AFormS12, 15);
    B12130                            := FetchElm(RetNo, AFormS12, 16);
    B12160                            := FetchElm(RetNo, AFormS12, 21);
    B12170                            := FetchElm(RetNo, AFormS12, 22);
    B12220                            := FetchElm(RetNo, AFormS12, 135);
    B12221                            := FetchElm(RetNo, AFormS12, 26);
    B12240                            := FetchElm(RetNo, AFormS12, 137);
    B12260                            := FetchElm(RetNo, AFormS12, 142);
    B12270                            := '0';
    B12680                            := FetchElm(RetNo, AFormS12, 203);
    B12760                            := FetchElm(RetNo, AFormS12, 201);
    B12690                            := FetchElm(RetNo, AFormS12, 202);
  end;
end;

Procedure PrepareT3SlipRec(RetNo:Integer;FName:String);
var
elm:integer;
d,periodEnding:string;
payerName,BenAddress:string;
begin
  //FName := 'T3SUPL#1';

  with T3Rec do
  begin

    IndBenSurname                               := FetchElm(RetNo,FName,26);
    IndBenFirstName                             := FetchElm(RetNo,FName,64);
    IndBenInitial                               := FetchElm(RetNo,FName,63);

    //??IndBenSurname2                              := FetchElm(RetNo,FName,); //fields not available on form
    //??IndBenFirstName2                            := FetchElm(RetNo,FName,);
    //??IndBenInitial2                              := FetchElm(RetNo,FName,);

    CorpBenNameLn1                              := leftstr(FetchElm(RetNo,FName,26),30);
    if length(FetchElm(RetNo,FName,26)) > 30 then
      CorpBenNameLn2                            := midstr(FetchElm(RetNo,FName,26),31,30)
    else
      CorpBenNameLn2                            := '';

    BenAddress := FetchElm(RetNo,FName,27);
    BenAddressLn1                               := leftStr(BenAddress,30);
    BenAddressLn2                               := midStr(BenAddress,31,30);;

    BenCity                                     := FetchElm(RetNo,FName,28);
    BenProvince                                 := FetchElm(RetNo,FName,29);
    BenCountryCode                              := FetchElm(RetNo,FName,66);
    BenPostalCode                               := RemoveChar(FetchElm(RetNo,FName,65),' ');

    BeneficiaryCode                             := FetchElm(RetNo,FName,4);

    IndBenSIN                                   := '000000000';
    BusinessNumber                              := '000000000RC0000';
    BenTrustAccountNumber                       := 'T00000000';        //???

    //20110512
    if      (BeneficiaryCode = '1') or (BeneficiaryCode = '2') then IndBenSIN      := FetchElm(RetNo,FName,1) //beneficiary is individual or beneficiary is joint beneficiary
    else if BeneficiaryCode = '3' then BusinessNumber := FetchElm(RetNo,FName,1) //beneficiary is corporation
    //else if BeneficiaryCode = '4' then BenTrustAccountNumber := 'T' + FetchElm(RetNo,FName,1) //beneficiary is association
    else if uppercase(leftstr(FetchElm(RetNo,FName,1),1)) = 'T' then BenTrustAccountNumber := FetchElm(RetNo,FName,1) //beneficiary is association
    else if BeneficiaryCode = '5' then //beneficiary is government
    else
        IndBenSIN      := FetchElm(RetNo,FName,46);


{
    IndBenSIN                                   := FetchElm(RetNo,FName,46);
    BusinessNumber                              := FetchElm(RetNo,FName,1) + 'RC0000';   //???
    BenTrustAccountNumber                       := 'T' + FetchElm(RetNo,FName,2);        //???
    TrustAccountNumber                          := 'T' + FetchElm(RetNo,FName,2);        //???
}


    TrustAccountNumber                          := 'T' + FetchElm(RetNo,FName,2);        //???


    //ReportTypeCode                              := FetchElm(RetNo,FName,3); got from datatypecode, datatypecode used directly

    //Investment tax credit code
    If FetchElm(RetNo,FName,67)='12'      then ITCCode  := '1'
    Else If FetchElm(RetNo,FName,67)='3A' then ITCCode  := '2'
    Else If FetchElm(RetNo,FName,67)='3B' then ITCCode  := '3'
    Else If FetchElm(RetNo,FName,67)='4B' then ITCCode  := '4'
    Else If FetchElm(RetNo,FName,67)='11' then ITCCode  := '5'
    Else If FetchElm(RetNo,FName,67)='07' then ITCCode  := '6'
    Else If FetchElm(RetNo,FName,67)='13' then ITCCode  := '7'
    else ITCCode :='';

    (* 20110521
    if (FetchElm(RetNo,'T2038',10)     = 'X') or (FetchElm(RetNo,'T2038',13)= 'X')  then ITCCode  := '1' //code 12
    else if FetchElm(RetNo,'T2038',2)  = 'X'                                        then ITCCode  := '2' //code 3A
    else if (FetchElm(RetNo,'T2038',5) ='X')  or (FetchElm(RetNo,'T2038',6)  = 'X') then ITCCode  := '3' //code 3B
    else if FetchElm(RetNo,'T2038',9)  = 'X'                                        then ITCCode  := '4' //code 4B
    //else if FetchElm(RetNo,'T2038',) = 'X'                                        then //ITCCode  := '5' //code 11 ???
    else if FetchElm(RetNo,'T2038',50) = 'X'                                        then ITCCode  := '6' //code 07
    //else if FetchElm(RetNo,'T2038',) = 'X'                                        then //ITCCode  := '7' //code 13 ???
    else ITCCode :='';
    *)
    //T3 amounts
    CapitalGains                                := FetchElm(RetNo,FName,5);
    //Period2CapitalGains                         := FetchElm(RetNo,FName,); //periods no longer in use??
    //Period3CapitalGains                         := FetchElm(RetNo,FName,); //periods no longer in use??
    ActualAmountDividendNotEligible             := FetchElm(RetNo,FName,7);
    OtherIncome                                 := FetchElm(RetNo,FName,10);
    TotalCapitalGainsEligible                   := FetchElm(RetNo,FName,12);
    //Period2CapitalGainsEligible                 := FetchElm(RetNo,FName,); periods no longer in use??
    //Period3CapitalGainsEligible                 := FetchElm(RetNo,FName,); periods no longer in use??
    TaxableAmountDividendsNotEligible           := FetchElm(RetNo,FName,14);
    //Period2InsuranceSegregatedFundCapitalLosses := FetchElm(RetNo,FName,); periods no longer in use??
    //Period3InsuranceSegregatedFundCapitalLosses := FetchElm(RetNo,FName,); periods no longer in use??
    DividendTaxCreditNotEligible                := FetchElm(RetNo,FName,21);
    ActualAmountEligibleDividends               := FetchElm(RetNo,FName,56);
    TaxableAmountEligibleDividends              := FetchElm(RetNo,FName,55);
    DividendTaxCreditEligibleDividends          := FetchElm(RetNo,FName,54);

    //T3 other info
    LumpSumPensionBenefits                      := FetchElm(RetNo,FName,6);
    ForeignBusIncome                            := FetchElm(RetNo,FName,8);
    ForeignNonBusIncome                         := FetchElm(RetNo,FName,9);
    EligiblePensionIncome                       := FetchElm(RetNo,FName,13);
    ForeignBusinessIncometaxPaid                := FetchElm(RetNo,FName,15);
    ForeignNonBusinessIncomeTaxPaid             := FetchElm(RetNo,FName,16);
    EligibleDeathBenefits                       := FetchElm(RetNo,FName,17);
    InsuranceSegregatedFundCapitalLosses        := FetchElm(RetNo,FName,19);
    PartXII2TaxCredit                           := FetchElm(RetNo,FName,20);
    InvestmentCostExpenditure                   := FetchElm(RetNo,FName,22);
    ITCTaxCredit                                := FetchElm(RetNo,FName,23);
    AmountsResultingCostBaseAdjustment          := FetchElm(RetNo,FName,49);
    OtherCredits                                := FetchElm(RetNo,FName,18);
    PensionIncomeEligibleTransfer               := FetchElm(RetNo,FName,51);
    RetiringAllowanceEligibleTransfer           := FetchElm(RetNo,FName,52);
    CharitableDonationsGiftsCommunalOrg         := FetchElm(RetNo,FName,53);
  end; //with T3Rec

end;

Procedure PrepareT3SummaryRec(RetNo:Integer;FName:String);

    function ZtoB(s:string):string;
    begin
        result := s;
        if s = '' then
            result:=''
    end;

var
elm:integer;

d,trustTaxDate:string;
TrustName,payerName:string;
begin
  FName := 'T3SUM';

  with T3Rec do
  begin
    TrustName                                   := FetchElm(RetNo,'T3',1);
    TrustNameLn1                                := leftStr(TrustName, 30);
    TrustNameLn2                                := midStr(TrustName, 31, 30);
    TrusteeExecutorAdminName                    := FetchElm(RetNo,'T3',3);

    TrusteeAddressLn1                           := FetchElm(RetNo,'T3',4); //FetchElm(RetNo,FName,14);
    TrusteeAddressLn2                           := FetchElm(RetNo,'T3',7); //FetchElm(RetNo,FName,17);

   //20110521 NOT AVAILABLE
   // TrusteeCity                                 := FetchElm(RetNo,FName,28);
   // TrusteeProvinceCode                         := FetchElm(RetNo,FName,29);
   // TrusteeCountryCode                          := FetchElm(RetNo,FName,66);
    TrusteePostalCode                           := FetchElm(RetNo,'T3',8);

    ContactName                                 := FetchElm(RetNo,FName,3);
    ContactAreaCode                             := FetchElm(RetNo,Fname,4);
    ContactTelephoneNumber                      := RemoveChar(FetchElm(RetNo,FName,5),'');
    ContactExtension                            := ''; //FetchElm(RetNo,FName,26);  //20110521

    TaxationYear                                := leftStr(FetchElm(RetNo,FName,12),4);
    //Report Type Code                          := FetchElm(RetNo,FName,);
    TotalNumberT3SlipRecords                    := FetchElm(RetNo,FName,15);

    d := FetchElm(RetNo,FName,9);
    trustTaxDate := d[9]+d[10];
    StartTrustTaxYearDay                        := trustTaxDate;
    trustTaxDate := d[6]+d[7];
    StartTrustTaxYearMonth                      := trustTaxDate;
    trustTaxDate := d[1]+d[2]+d[3]+d[4];
    StartTrustTaxYearYear                       := trustTaxDate;

    d := FetchElm(RetNo,FName,12);
    trustTaxDate := d[9]+d[10];
    EndTrustTaxYearDay                          := trustTaxDate;
    trustTaxDate := d[6]+d[7];
    EndTrustTaxYearMonth                        := trustTaxDate;
    trustTaxDate := d[1]+d[2]+d[3]+d[4];
    EndTrustTaxYearYear                         := trustTaxDate;

    //T3 totals amounts

    TotalCapitalGains                           := FormatFloat( '0.00',Vl(FetchElm(RetNo,FName,16)) );
    TotalActualDividendsNotEligible             := FormatFloat( '0.00',Vl(FetchElm(RetNo,FName,18)) );
    TotalActualEligibleDividends                := FormatFloat( '0.00',Vl(FetchElm(RetNo,FName,19)) );
    TotalTaxableEligibleDividends               := FormatFloat( '0.00',Vl(FetchElm(RetNo,FName,10)) );
    TotalDividendTaxCreditEligible              := FormatFloat( '0.00',Vl(FetchElm(RetNo,FName,20)) );
    TotalOtherIncome                            := FormatFloat( '0.00',Vl(FetchElm(RetNo,FName,21)) );
    TotalCapitalGainsEligibleDeduction          := FormatFloat( '0.00',Vl(FetchElm(RetNo,FName,22)) );
    TotalTaxableDividendsNotEligible            := FormatFloat( '0.00',Vl(FetchElm(RetNo,FName,24)) );
    TotalDividendTaxCreditNotEligible           := FormatFloat( '0.00',Vl(FetchElm(RetNo,FName,33)) );

    TotalLumpSumPensionBenefits                 := FormatFloat('0.00',TotMultiple(RetNo,'T3SUPL',6) );
    TotalForeignBusinessIncome                  := FormatFloat('0.00',TotMultiple(RetNo,'T3SUPL',8) );
    TotalForeignNonBusinessIncome               := FormatFloat('0.00',TotMultiple(RetNo,'T3SUPL',9) );
    TotalEligiblePensionincome                  := FormatFloat('0.00',TotMultiple(RetNo,'T3SUPL',13) );
    TotalForeignBusinessIncomeTaxPaid           := FormatFloat('0.00',TotMultiple(RetNo,'T3SUPL',15) );
    TotalForeignNonBusinessIncomeTaxPaid        := FormatFloat('0.00',TotMultiple(RetNo,'T3SUPL',16) );
    TotalEligibleDeathBenefits                  := FormatFloat('0.00',TotMultiple(RetNo,'T3SUPL',17) );
    TotalPensionIncomeEligibleTransfer          := FormatFloat('0.00',TotMultiple(RetNo,'T3SUPL',51) );
    TotalRetiringAllowanceEligibleTransfer      := FormatFloat('0.00',TotMultiple(RetNo,'T3SUPL',52) );
    TotalCharitableDonations                    := FormatFloat('0.00',TotMultiple(RetNo,'T3SUPL',53) );
    TotalInsuranceSegregatedFundCapitalLosses   := FormatFloat('0.00',TotMultiple(RetNo,'T3SUPL',19) );
    TotalPartXII2TaxCredit                      := FormatFloat('0.00',TotMultiple(RetNo,'T3SUPL',20) );
    TotalITC                                    := FormatFloat('0.00',TotMultiple(RetNo,'T3SUPL',23) );
    TotalOtherCredits                           := FormatFloat('0.00',TotMultiple(RetNo,'T3SUPL',18) );

  end; //with T3Rec
end;


procedure addSubmissionTag(tag:String;Var XmlList:tstringlist);
begin
    if uppercase(tag) = 'BEGIN' then
    begin
        XmlList.add('<?xml version="1.0" encoding="UTF-8"?>');
        XmlList.add('<Submission xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
        XmlList.add('xsi:noNamespaceSchemaLocation="layout-topologie.xsd">');
    end
    else if uppercase(tag) = 'END' then
        XmlList.add('</Submission>')
    else
        ErrorMsg('Submission tag error');
end;

procedure createT3XML(RetNo:Integer;DataTypeCode:String;SubmitRef:String;Var T3XmlList:tstringlist);
var
i:integer;s:String;
TotalT3SlipRecords:integer;
begin

 addSubmissionTag('BEGIN',T3XmlList);
 PrepareT619(T3XmlList,RetNo,DataTypeCode,SubmitRef); //T619

 TotalT3SlipRecords := GetHighestT3SuplInstance(RetNo); //CountAllT3Slips(RetNo); //20120404

 T3XmlList.add(Space(indent) + '<Return>');
 T3XmlList.add(Space(indentM) + '<T3>');

 //T3Slip-----------------------------------------------------------------------
 for i:=1 to TotalT3SlipRecords do
 begin
   If (Ret[RetNo].FrmHasData[GetFormNo('T3SUPL#'+inttostr(i))])
   and (UpperCase(FetchElm(RetNo,'T3SUPL#'+inttostr(i),41)) = 'Y')  //20120416  //only residents
   then  //20120404
   Begin
    PrepareT3SlipRec(RetNo,'T3SUPL#'+inttostr(i));

    T3XmlList.add(Space(indentMM) + '<T3Slip>');

    // if T3Rec.CorpBenNameLn1 > '' then
    If T3Rec.BeneficiaryCode >'2'  then  //20120404
    begin
        T3XmlList.add(Space(indentMMM) + '<ENTPRS_BNFY_NM>');
        //T3XmlList.add(Space(indentMMMM) + '<l1_nm>'+ T3Rec.IndBenSurname +'</l1_nm>'); //required 30 alphanumeric //20120404
        T3XmlList.add(Space(indentMMMM) + '<l1_nm>'+ T3Rec.CorpBenNameLn1 +'</l1_nm>'); //required 30 alphanumeric
        if T3Rec.CorpBenNameLn2 > '' then T3XmlList.add(Space(indentMMMM) + '<l2_nm>'+ T3Rec.CorpBenNameLn2 +'</l2_nm>');  //20120404
        T3XmlList.add(Space(indentMMM) + '</ENTPRS_BNFY_NM>');
    end
    else
    begin
        T3XmlList.add(Space(indentMMM) + '<BNFY_NM>');
        T3XmlList.add(Space(indentMMMM) + '<snm>'+ T3Rec.IndBenSurname +'</snm>'); //required 20 alphanumeric
        T3XmlList.add(Space(indentMMMM) + '<gvn_nm>'+ T3Rec.IndBenFirstName +'</gvn_nm>');
        If AllTrim(T3Rec.IndBenInitial) >'' then T3XmlList.add(Space(indentMMMM) + '<init>'+ T3Rec.IndBenInitial +'</init>');
        T3XmlList.add(Space(indentMMM) + '</BNFY_NM>');

        //???
        //T3XmlList.add(Space(indentMMM) + '<SEC_BNFY_NM>');
        //T3XmlList.add(Space(indentMMMM) + '<sec_snm>'+ T3Rec.IndBenSurname2 +'</sec_snm>'); //required 20 alphanumeric
        //T3XmlList.add(Space(indentMMMM) + '<sec_gvn_nm>'+ T3Rec.IndBenFirstName2 +'</sec_gvn_nm>');
        //T3XmlList.add(Space(indentMMMM) + '<sec_init>'+ T3Rec.IndBenInitial2 +'</sec_init>');
        //T3XmlList.add(Space(indentMMM) + '</SEC_BNFY_NM>');
    end;

    T3XmlList.add(Space(indentMMM) + '<BNFY_ADDR>'); //not required???
    T3XmlList.add(Space(indentMMMM) + '<addr_l1_txt>'+ T3Rec.BenAddressLn1 +'</addr_l1_txt>');
    if T3Rec.BenAddressLn2 > '' then
       T3XmlList.add(Space(indentMMMM) + '<addr_l2_txt>'+ T3Rec.BenAddressLn2 +'</addr_l2_txt>');
    T3XmlList.add(Space(indentMMMM) + '<cty_nm>'+ T3Rec.BenCity +'</cty_nm>');
    T3XmlList.add(Space(indentMMMM) + '<prov_cd>'+ T3Rec.BenProvince +'</prov_cd>');
    T3XmlList.add(Space(indentMMMM) + '<cntry_cd>'+ T3Rec.BenCountryCode +'</cntry_cd>');
    T3XmlList.add(Space(indentMMMM) + '<pstl_cd>'+ T3Rec.BenPostalCode +'</pstl_cd>');
    T3XmlList.add(Space(indentMMM) + '</BNFY_ADDR>');

    T3XmlList.add(Space(indentMMM) + '<sin>'+ T3Rec.IndBenSIN +'</sin>'); //required, 9 numeric
    if AllTrim(T3Rec.BusinessNumber) = '' then T3Rec.BusinessNumber := '000000000RP0000';
    T3XmlList.add(Space(indentMMM) + '<bn>'+ T3Rec.BusinessNumber +'</bn>'); //required, 15 alphanumeric, 9 digits RP 4 digits, example 000000000RP0000
    if T3Rec.BenTrustAccountNumber = '' then T3Rec.BenTrustAccountNumber := 'T00000000';
    T3XmlList.add(Space(indentMMM) + '<bnfy_tr_acct_nbr>'+ T3Rec.BenTrustAccountNumber +'</bnfy_tr_acct_nbr>'); //required 1 alpha, 8 numeric, example: T00000000
    if T3Rec.TrustAccountNumber = '' then T3Rec.TrustAccountNumber := 'T00000000';
    T3XmlList.add(Space(indentMMM) + '<tr_acct_nbr>'+ T3Rec.TrustAccountNumber +'</tr_acct_nbr>'); //required 1 alpha, 8 numeric
    T3XmlList.add(Space(indentMMM) + '<rpt_tcd>'+ DataTypeCode +'</rpt_tcd>'); //required 1 alpha
    T3XmlList.add(Space(indentMMM) + '<bnfy_cd>'+ T3Rec.BeneficiaryCode +'</bnfy_cd>'); //required 1 numeric

    if T3Rec.ITCCode > ''      then   T3XmlList.add(Space(indentMMM) + '<itc_cd>'+ T3Rec.ITCCode +'</itc_cd>');

    //T3 Amounts
    T3XmlList.add(Space(indentMMM) + '<T3_AMT>');
    if T3Rec.CapitalGains > ''                         then   T3XmlList.add(Space(indentMMMM) + '<cgamt>'+ T3Rec.CapitalGains +'</cgamt>');
    //if T3Rec.Period2CapitalGains > ''                  then   T3XmlList.add(Space(indentMMMM) + '<prd_2_cgamt>'+ T3Rec.Period2CapitalGains +'</prd_2_cgamt>');
    //if T3Rec.Period3CapitalGains > ''                  then   T3XmlList.add(Space(indentMMMM) + '<prd_3_cgamt>'+ T3Rec.Period3CapitalGains +'</prd_3_cgamt>');
    if T3Rec.ActualAmountDividendNotEligible > ''      then   T3XmlList.add(Space(indentMMMM) + '<actl_dvnd_amt>'+ T3Rec.ActualAmountDividendNotEligible +'</actl_dvnd_amt>');
    if T3Rec.OtherIncome > ''                          then   T3XmlList.add(Space(indentMMMM) + '<oth_incamt>'+ T3Rec.OtherIncome +'</oth_incamt>');
    if T3Rec.TotalCapitalGainsEligible > ''            then   T3XmlList.add(Space(indentMMMM) + '<elg_dedn_cgamt>'+ T3Rec.TotalCapitalGainsEligible +'</elg_dedn_cgamt>');
    //if T3Rec.Period2CapitalGainsEligible > ''          then   T3XmlList.add(Space(indentMMMM) + '<prd_2_elg_cgamt>'+ T3Rec.Period2CapitalGainsEligible +'</prd_2_elg_cgamt>');
    //if T3Rec.Period3CapitalGainsEligible > ''          then   T3XmlList.add(Space(indentMMMM) + '<prd_3_elg_cgamt>'+ T3Rec.Period3CapitalGainsEligible +'</prd_3_elg_cgamt>');
    if T3Rec.TaxableAmountDividendsNotEligible > ''    then   T3XmlList.add(Space(indentMMMM) + '<tx_dvnd_amt>'+ T3Rec.TaxableAmountDividendsNotEligible +'</tx_dvnd_amt>');
    //if T3Rec.Period2InsuranceSegregatedFundCapitalLosses > '' then   T3XmlList.add(Space(indentMMMM) + '<prd_2_insu_clamt>'+ T3Rec.Period2InsuranceSegregatedFundCapitalLosses +'</prd_2_insu_clamt>');
    //if T3Rec.Period3InsuranceSegregatedFundCapitalLosses > '' then   T3XmlList.add(Space(indentMMMM) + '<prd_3_insu_clamt>'+ T3Rec.Period3InsuranceSegregatedFundCapitalLosses +'</prd_3_insu_clamt>');
    if T3Rec.DividendTaxCreditNotEligible > ''         then   T3XmlList.add(Space(indentMMMM) + '<dvnd_tx_cr_amt>'+ T3Rec.DividendTaxCreditNotEligible +'</dvnd_tx_cr_amt>');
    if T3Rec.ActualAmountEligibleDividends > ''        then   T3XmlList.add(Space(indentMMMM) + '<actl_elg_dvamt>'+ T3Rec.ActualAmountEligibleDividends +'</actl_elg_dvamt>');
    if T3Rec.TaxableAmountEligibleDividends > ''       then   T3XmlList.add(Space(indentMMMM) + '<tx_elg_dvnd_pamt>'+ T3Rec.TaxableAmountEligibleDividends +'</tx_elg_dvnd_pamt>');
    if T3Rec.DividendTaxCreditEligibleDividends > ''   then   T3XmlList.add(Space(indentMMMM) + '<enhn_dvtc_amt>'+ T3Rec.DividendTaxCreditEligibleDividends +'</enhn_dvtc_amt>');
    T3XmlList.add(Space(indentMMM) + '</T3_AMT>');

    //T3 other info    //cannot have more than 6. will not pass xml schema. Supposed to create other slip
    T3XmlList.add(Space(indentMMM) + '<OTH_INFO>');

    if T3Rec.LumpSumPensionBenefits > ''               then   T3XmlList.add(Space(indentMMMM) + '<pens_lsp_amt>'+ T3Rec.LumpSumPensionBenefits +'</pens_lsp_amt>');
    if T3Rec.ForeignBusIncome > ''                     then   T3XmlList.add(Space(indentMMMM) + '<fgn_bus_incamt>'+ T3Rec.ForeignBusIncome +'</fgn_bus_incamt>');
    if T3Rec.ForeignNonBusIncome > ''                  then   T3XmlList.add(Space(indentMMMM) + '<fgn_nbus_incamt>'+ T3Rec.ForeignNonBusIncome +'</fgn_nbus_incamt>');
    if T3Rec.EligiblePensionIncome > ''                then   T3XmlList.add(Space(indentMMMM) + '<elg_pens_incamt>'+ T3Rec.EligiblePensionIncome +'</elg_pens_incamt>');
    if T3Rec.ForeignBusinessIncometaxPaid > ''         then   T3XmlList.add(Space(indentMMMM) + '<fgn_bus_tx_amt>'+ T3Rec.ForeignBusinessIncometaxPaid +'</fgn_bus_tx_amt>');
    if T3Rec.ForeignNonBusinessIncomeTaxPaid > ''      then   T3XmlList.add(Space(indentMMMM) + '<fgn_tx_amt>'+ T3Rec.ForeignNonBusinessIncomeTaxPaid +'</fgn_tx_amt>');
    if T3Rec.EligibleDeathBenefits > ''                then   T3XmlList.add(Space(indentMMMM) + '<dth_ben_amt>'+ T3Rec.EligibleDeathBenefits +'</dth_ben_amt>');
    if T3Rec.InsuranceSegregatedFundCapitalLosses > '' then   T3XmlList.add(Space(indentMMMM) + '<insu_fnd_clamt>'+ T3Rec.InsuranceSegregatedFundCapitalLosses +'</insu_fnd_clamt>');
    if T3Rec.PartXII2TaxCredit > ''                    then   T3XmlList.add(Space(indentMMMM) + '<XII_2_tx_cr_amt>'+ T3Rec.PartXII2TaxCredit +'</XII_2_tx_cr_amt>');
    if T3Rec.InvestmentCostExpenditure > ''            then   T3XmlList.add(Space(indentMMMM) + '<invs_cost_examt>'+ T3Rec.InvestmentCostExpenditure +'</invs_cost_examt>');
    if T3Rec.ITCTaxCredit > ''                         then   T3XmlList.add(Space(indentMMMM) + '<itc_amt>'+ T3Rec.ITCTaxCredit +'</itc_amt>');
    if T3Rec.AmountsResultingCostBaseAdjustment > ''   then   T3XmlList.add(Space(indentMMMM) + '<amt_rslt_acb_amt>'+ T3Rec.AmountsResultingCostBaseAdjustment +'</amt_rslt_acb_amt>');
    if T3Rec.OtherCredits > ''                         then   T3XmlList.add(Space(indentMMMM) + '<oth_cr_amt>'+ T3Rec.OtherCredits +'</oth_cr_amt>');
    if T3Rec.PensionIncomeEligibleTransfer > ''        then   T3XmlList.add(Space(indentMMMM) + '<pens_trnsf_amt>'+ T3Rec.PensionIncomeEligibleTransfer +'</pens_trnsf_amt>');
    if T3Rec.RetiringAllowanceEligibleTransfer > ''    then   T3XmlList.add(Space(indentMMMM) + '<rtir_alwnc_amt>'+ T3Rec.RetiringAllowanceEligibleTransfer +'</rtir_alwnc_amt>');
    if T3Rec.CharitableDonationsGiftsCommunalOrg > ''  then   T3XmlList.add(Space(indentMMMM) + '<chrty_dons_amt>'+ T3Rec.CharitableDonationsGiftsCommunalOrg +'</chrty_dons_amt>');

    T3XmlList.add(Space(indentMMM) + '</OTH_INFO>');
    T3XmlList.add(Space(indentMM) + '</T3Slip>');
  end; //i
 end;//END T3Slip-------------------------------------------------------------------

 PrepareT3SummaryRec(RetNo,'T3SUM');
 //T3Summary--------------------------------------------------------------------
 T3XmlList.add(Space(indentMM) + '<T3Summary>');
 T3XmlList.add(Space(indentMMM) + '<tr_acct_nbr>'+ T3Rec.TrustAccountNumber +'</tr_acct_nbr>');

 //not applicable
// s:='N'; if FetchElm(RetNo,'T3',27)>'' then s:='Y';   ////20190331
// T3XmlList.add(Space(indentMMM) + '<tr_frst_yr_fil_ind>'+ ???T3Rec.TrustAccountNumber +'</tr_frst_yr_fil_ind>'); //20190331

 T3XmlList.add(Space(indentMMM) + '<TR_NM>');
 T3XmlList.add(Space(indentMMMM) + '<l1_nm>'+ T3Rec.TrustNameLn1 +'</l1_nm>');
 if T3Rec.TrustNameLn2 > '' then
    T3XmlList.add(Space(indentMMMM) + '<l2_nm>'+ T3Rec.TrustNameLn2 +'</l2_nm>');
 T3XmlList.add(Space(indentMMM) + '</TR_NM>');

 T3XmlList.add(Space(indentMMM) + '<tre_exctr_admnr_nm>'+ T3Rec.TrusteeExecutorAdminName +'</tre_exctr_admnr_nm>');

 T3XmlList.add(Space(indentMMM) + '<TRE_ADDR>');
 T3XmlList.add(Space(indentMMMM) + '<addr_l1_txt>'+ T3Rec.TrusteeAddressLn1 +'</addr_l1_txt>');
 if T3Rec.TrusteeAddressLn2 > '' then T3XmlList.add(Space(indentMMMM) + '<addr_l2_txt>'+ T3Rec.TrusteeAddressLn2 +'</addr_l2_txt>');
 If T3Rec.TrusteeCity >'' then T3XmlList.add(Space(indentMMMM) + '<cty_nm>'+ T3Rec.TrusteeCity +'</cty_nm>');
 If T3Rec.TrusteeProvinceCode>'' then T3XmlList.add(Space(indentMMMM) + '<prov_cd>'+ T3Rec.TrusteeProvinceCode +'</prov_cd>');
 If T3Rec.TrusteeCountryCode>'' then T3XmlList.add(Space(indentMMMM) + '<cntry_cd>'+ T3Rec.TrusteeCountryCode +'</cntry_cd>');
 T3XmlList.add(Space(indentMMMM) + '<pstl_cd>'+ T3Rec.TrusteePostalCode +'</pstl_cd>');
 T3XmlList.add(Space(indentMMM) + '</TRE_ADDR>');

 T3XmlList.add(Space(indentMMM) + '<CNTC>');
 T3XmlList.add(Space(indentMMMM) + '<cntc_nm>'+ T3Rec.ContactName +'</cntc_nm>');
 T3XmlList.add(Space(indentMMMM) + '<cntc_area_cd>'+ T3Rec.ContactAreaCode +'</cntc_area_cd>');
 T3XmlList.add(Space(indentMMMM) + '<cntc_phn_nbr>'+ T3Rec.ContactTelephoneNumber +'</cntc_phn_nbr>');
 If AllTrim(T3Rec.ContactExtension)>'' then
   T3XmlList.add(Space(indentMMMM) + '<cntc_extn_nbr>'+ T3Rec.ContactExtension +'</cntc_extn_nbr>');
 T3XmlList.add(Space(indentMMM) + '</CNTC>');

 T3XmlList.add(Space(indentMMM) + '<tx_yr>'+ T3Rec.TaxationYear +'</tx_yr>');
 T3XmlList.add(Space(indentMMM) + '<rpt_tcd>'+ DataTypeCode +'</rpt_tcd>');
 T3XmlList.add(Space(indentMMM) + '<slp_cnt>'+ T3Rec.TotalNumberT3SlipRecords +'</slp_cnt>');

 T3XmlList.add(Space(indentMMM) + '<TR_TX_SDT>');
 T3XmlList.add(Space(indentMMMM) + '<dy>'+ T3Rec.StartTrustTaxYearDay +'</dy>');
 T3XmlList.add(Space(indentMMMM) + '<mo>'+ T3Rec.StartTrustTaxYearMonth +'</mo>');
 T3XmlList.add(Space(indentMMMM) + '<yr>'+ T3Rec.StartTrustTaxYearYear +'</yr>');
 T3XmlList.add(Space(indentMMM) + '</TR_TX_SDT>');

 T3XmlList.add(Space(indentMMM) + '<TR_TX_NDT>');
 T3XmlList.add(Space(indentMMMM) + '<sec_dy>'+ T3Rec.EndTrustTaxYearDay +'</sec_dy>');
 T3XmlList.add(Space(indentMMMM) + '<sec_mo>'+ T3Rec.EndTrustTaxYearMonth +'</sec_mo>');
 T3XmlList.add(Space(indentMMMM) + '<sec_yr>'+ T3Rec.EndTrustTaxYearYear +'</sec_yr>');
 T3XmlList.add(Space(indentMMM) + '</TR_TX_NDT>');

 //T3 Totals
 T3XmlList.add(Space(indentMMM) + '<T3_TAMT>');
 if T3Rec.TotalCapitalGains <> '0.00'                       then  T3XmlList.add(Space(indentMMMM) + '<tot_cgamt>'+ T3Rec.TotalCapitalGains +'</tot_cgamt>');
 if T3Rec.TotalLumpSumPensionBenefits <> '0.00'             then  T3XmlList.add(Space(indentMMMM) + '<tot_pens_lsp_amt>'+ T3Rec.TotalLumpSumPensionBenefits +'</tot_pens_lsp_amt>');
 if T3Rec.TotalActualDividendsNotEligible <> '0.00'         then  T3XmlList.add(Space(indentMMMM) + '<tot_actl_dvnd_amt>'+ T3Rec.TotalActualDividendsNotEligible +'</tot_actl_dvnd_amt>');
 if T3Rec.TotalActualEligibleDividends <> '0.00'            then  T3XmlList.add(Space(indentMMMM) + '<tot_actl_elg_dvamt>'+ T3Rec.TotalActualEligibleDividends +'</tot_actl_elg_dvamt>');
 if T3Rec.TotalTaxableEligibleDividends <> '0.00'           then  T3XmlList.add(Space(indentMMMM) + '<tot_tx_elg_dvamt>'+ T3Rec.TotalTaxableEligibleDividends +'</tot_tx_elg_dvamt>');
 if T3Rec.TotalDividendTaxCreditEligible <> '0.00'          then  T3XmlList.add(Space(indentMMMM) + '<tot_enhn_dvtc_amt>'+ T3Rec.TotalDividendTaxCreditEligible +'</tot_enhn_dvtc_amt>');
 if T3Rec.TotalForeignBusinessIncome <> '0.00'              then  T3XmlList.add(Space(indentMMMM) + '<tot_fgn_bus_incamt>'+ T3Rec.TotalForeignBusinessIncome +'</tot_fgn_bus_incamt>');
 if T3Rec.TotalForeignNonBusinessIncome <> '0.00'           then  T3XmlList.add(Space(indentMMMM) + '<tot_fgn_nbus_amt>'+ T3Rec.TotalForeignNonBusinessIncome +'</tot_fgn_nbus_amt>');
 if T3Rec.TotalOtherIncome <> '0.00'                        then  T3XmlList.add(Space(indentMMMM) + '<tot_oth_incamt>'+ T3Rec.TotalOtherIncome +'</tot_oth_incamt>');
 if T3Rec.TotalCapitalGainsEligibleDeduction <> '0.00'      then  T3XmlList.add(Space(indentMMMM) + '<tot_elg_dedn_cgamt>'+ T3Rec.TotalCapitalGainsEligibleDeduction +'</tot_elg_dedn_cgamt>');
 if T3Rec.TotalEligiblePensionincome <> '0.00'              then  T3XmlList.add(Space(indentMMMM) + '<tot_pens_incamt>'+ T3Rec.TotalEligiblePensionincome +'</tot_pens_incamt>');
 if T3Rec.TotalTaxableDividendsNotEligible <> '0.00'        then  T3XmlList.add(Space(indentMMMM) + '<tot_tx_dvnd_amt>'+ T3Rec.TotalTaxableDividendsNotEligible +'</tot_tx_dvnd_amt>');
 if T3Rec.TotalForeignBusinessIncomeTaxPaid <> '0.00'       then  T3XmlList.add(Space(indentMMMM) + '<tot_fgn_bus_tx_amt>'+ T3Rec.TotalForeignBusinessIncomeTaxPaid +'</tot_fgn_bus_tx_amt>');
 if T3Rec.TotalForeignNonBusinessIncomeTaxPaid <> '0.00'    then  T3XmlList.add(Space(indentMMMM) + '<tot_fgn_itx_amt>'+ T3Rec.TotalForeignNonBusinessIncomeTaxPaid +'</tot_fgn_itx_amt>');
 if T3Rec.TotalEligibleDeathBenefits <> '0.00'              then  T3XmlList.add(Space(indentMMMM) + '<tot_dth_ben_amt>'+ T3Rec.TotalEligibleDeathBenefits +'</tot_dth_ben_amt>');
 if T3Rec.TotalPensionIncomeEligibleTransfer <> '0.00'      then  T3XmlList.add(Space(indentMMMM) + '<tot_pens_trnsf_amt>'+ T3Rec.TotalPensionIncomeEligibleTransfer +'</tot_pens_trnsf_amt>');
 if T3Rec.TotalRetiringAllowanceEligibleTransfer <> '0.00'  then  T3XmlList.add(Space(indentMMMM) + '<tot_rtir_alwnc_amt>'+ T3Rec.TotalRetiringAllowanceEligibleTransfer +'</tot_rtir_alwnc_amt>');
 if T3Rec.TotalCharitableDonations <> '0.00'                then  T3XmlList.add(Space(indentMMMM) + '<tot_chrty_dons_amt>'+ T3Rec.TotalCharitableDonations +'</tot_chrty_dons_amt>');
 if T3Rec.TotalInsuranceSegregatedFundCapitalLosses <> '0.00' then  T3XmlList.add(Space(indentMMMM) + '<tot_insu_fnd_clamt>'+ T3Rec.TotalInsuranceSegregatedFundCapitalLosses +'</tot_insu_fnd_clamt>');
 if T3Rec.TotalPartXII2TaxCredit <> '0.00'                  then  T3XmlList.add(Space(indentMMMM) + '<tot_XII_2_cr_amt>'+ T3Rec.TotalPartXII2TaxCredit +'</tot_XII_2_cr_amt>');
 if T3Rec.TotalDividendTaxCreditNotEligible <> '0.00'       then  T3XmlList.add(Space(indentMMMM) + '<tot_dvnd_tx_cr_amt>'+ T3Rec.TotalDividendTaxCreditNotEligible +'</tot_dvnd_tx_cr_amt>');
// if T3Rec.TotalEligibleITC <> '0.00'                        then  T3XmlList.add(Space(indentMMMM) + '<tot_elg_invs_amt>'+ T3Rec.TotalEligibleITC +'</tot_elg_invs_amt>');
 if T3Rec.TotalITC <> '0.00'                                then  T3XmlList.add(Space(indentMMMM) + '<tot_itc_amt>'+ T3Rec.TotalITC +'</tot_itc_amt>');
 if T3Rec.TotalOtherCredits <> '0.00'                       then  T3XmlList.add(Space(indentMMMM) + '<totr_cr_amt>'+ T3Rec.TotalOtherCredits +'</totr_cr_amt>');
 T3XmlList.add(Space(indentMMM) + '</T3_TAMT>');
 T3XmlList.add(Space(indentMM) + '</T3Summary>');
 //END T3Summary----------------------------------------------------------------

 T3XmlList.add(Space(indentM) + '</T3>');
 T3XmlList.add(Space(indent) + '</Return>');

 addSubmissionTag('END',T3XmlList);

end;

procedure createT3RetXML(RetNo:Integer;DataTypeCode:String;SubmitRef:String;Var T3XmlList:tstringlist); //20180314 Igor
type TSkipType = (stSkipIfEmpty, stDontSkipIfEmpty);
var
  i: integer;

  procedure AddBeginTag(AIndent: integer; AName: string);
  begin
    T3XmlList.Add(Space(AIndent) + '<'+ AName +'>');
  end;

  procedure AddEndTag(AIndent: integer; AName: string);
  begin
    T3XmlList.Add(Space(AIndent) + '</'+ AName +'>');
  end;

  procedure AddTag(AIndent: integer; AName, AValue: string; ASkip: TSkipType = stSkipIfEmpty);
  Var k:Integer;
  begin
    //20190401 Formatting special cases
   If (AName='TotalTaxPayableAmount')
   Or (AName='IncomeTaxBalanceAmount')
   //Or (AName='TrustRetainedDividendGrossUpAmount')
   then
   //ok
   Else
   Begin
    K:=Pos('.',Avalue);
    If K>0 then AValue:=LeftStr(Avalue,k-1);
   End;
   If (AName='TrustRetainedDividendGrossUpAmount') and (aValue>'') then
   Begin
    K:=Pos('.',Avalue);
    If K>0 then AValue:=LeftStr(Avalue,k-1);
    Avalue:=Avalue+'.00';
   End;
   //-------------------------------------------------
   if SameText(Trim(AValue), '') and (ASkip = stSkipIfEmpty) then Exit;
   if SameText(Trim(AValue), '') then
      T3XmlList.Add(Space(AIndent) + '<'+ AName +'/>')
   else
      T3XmlList.Add(Space(AIndent) + '<'+ AName +'>' + ReplaceSpecialChar(AValue) + '</'+ AName +'>');
  end;

  procedure AddDate(AIndent: integer; AName, AYear, AMonth, ADay: string; ASkip: TSkipType = stSkipIfEmpty);
  begin
    if SameText(AYear, '') and SameText(AMonth, '') and SameText(ADay, '') and (ASkip = stSkipIfEmpty) then Exit;
    T3XmlList.Add(Space(AIndent) + '<'+ AName +'>');
    AddTag(AIndent + 3, 'Year', AYear, stDontSkipIfEmpty);
    AddTag(AIndent + 3, 'Month', AMonth, stDontSkipIfEmpty);
    AddTag(AIndent + 3, 'Day', ADay, stDontSkipIfEmpty);
    T3XmlList.Add(Space(AIndent) + '</'+ AName +'>');
  end;

  function IsAnyNonEmpty(Arr: Variant): boolean;
  var I: integer;
  begin
    Result := false;
    for I := VarArrayLowBound(Arr, 1) to VarArrayHighBound(Arr, 1) do
      if not SameText(String(VarArrayGet(Arr, [I])), '') then
      begin
        Result := true;
        Exit;
      end;
  end;

  function IsAnyEmpty(Arr: Variant): boolean;
  var I: integer;
  begin
    Result := false;
    for I := VarArrayLowBound(Arr, 1) to VarArrayHighBound(Arr, 1) do
      if SameText(String(VarArrayGet(Arr, [I])), '') then
      begin
        Result := true;
        Exit;
      end;
  end;


begin
  addSubmissionTag('BEGIN', T3XmlList);
  PrepareT619(T3XmlList,RetNo, DataTypeCode, SubmitRef); //T619
  PrepareT3RetRec(RetNo);

  T3XmlList.add(Space(indent) + '<Return>');
  T3XmlList.add(Space(indentM) + '<T3GEN>');

  with T3RetRec do
  begin
    AddBeginTag(indentM, 'TrustIdentInformation');
    AddTag(indentMM, 'SummaryReportTypeCode', 'O');
    //AddTag(indentMM, 'OriginalSummaryReportTypeCode', 'O');
    AddTag(indentMM, 'TaxYearEndTrustResidenceCountryCode', TaxYearEndTrustResidenceCountryCode);
    AddTag(indentMM, 'TrustCanadianResidenceProvinceCode', TrustCanadianResidenceProvinceCode);
    AddTag(indentMM, 'TrustName', TrustName, stDontSkipIfEmpty);
    AddTag(indentMM, 'TrustAccountNumber', TrustAccountNumber, stDontSkipIfEmpty);
    AddTag(indentMM, 'TrusteeName', TrusteeName, stDontSkipIfEmpty);

    AddBeginTag(indentMM, 'TrusteeMailingAddress');
    AddTag(indentMMM, 'AddressLine1Text', TrusteeAddressLine1Text, stDontSkipIfEmpty);
    AddTag(indentMMM, 'AddressLine2Text', TrusteeAddressLine2Text);
    AddTag(indentMMM, 'MunicipalityName', TrusteeMunicipalityName, stDontSkipIfEmpty);
    AddTag(indentMMM, 'ProvinceStateCode', TrusteeProvinceStateCode, stDontSkipIfEmpty);
    AddTag(indentMMM, 'CountryCode', TrusteeCountryCode);
    AddTag(indentMMM, 'PostalZipCode', TrusteePostalZipCode, stDontSkipIfEmpty);
    AddEndTag(indentMM, 'TrusteeMailingAddress');

    if IsAnyNonEmpty(VarArrayOf([
                    TrusteePhoneAreaCode,
                    TrusteePhoneNumber,
                    TrusteePhoneExtensionNumber
                             ])) then
    begin
      AddBeginTag(indentMM, 'TrusteePhoneNumber');
      AddTag(indentMMM, 'PhoneAreaCode', TrusteePhoneAreaCode, stDontSkipIfEmpty);
      AddTag(indentMMM, 'PhoneNumber', TrusteePhoneNumber, stDontSkipIfEmpty);
      AddTag(indentMMM, 'PhoneExtensionNumber', TrusteePhoneExtensionNumber);
      AddEndTag(indentMM, 'TrusteePhoneNumber');
    end;

    AddTag(indentMM, 'NonTrusteeContactName', NonTrusteeContactName);

    if IsAnyNonEmpty(VarArrayOf([
                    NonTrusteeAddressLine1Text,
                    NonTrusteeAddressLine2Text,
                    NonTrusteeMunicipalityName,
                    NonTrusteeProvinceStateCode,
                    NonTrusteeCountryCode,
                    NonTrusteePostalZipCode
                             ])) then
    begin
      AddBeginTag(indentMM, 'NonTrusteeContactMailingAddress');
      AddTag(indentMMM, 'AddressLine1Text', NonTrusteeAddressLine1Text, stDontSkipIfEmpty);
      AddTag(indentMMM, 'AddressLine2Text', NonTrusteeAddressLine2Text);
      AddTag(indentMMM, 'MunicipalityName', NonTrusteeMunicipalityName, stDontSkipIfEmpty);
      AddTag(indentMMM, 'ProvinceStateCode', NonTrusteeProvinceStateCode, stDontSkipIfEmpty);
      AddTag(indentMMM, 'CountryCode', NonTrusteeCountryCode);
      AddTag(indentMMM, 'PostalZipCode', NonTrusteePostalZipCode, stDontSkipIfEmpty);
      AddEndTag(indentMM, 'NonTrusteeContactMailingAddress');
    end;

    if IsAnyNonEmpty(VarArrayOf([
                    NonTrusteePhoneAreaCode,
                    NonTrusteePhoneNumber,
                    NonTrusteePhoneExtensionNumber
                             ])) then
    begin
      AddBeginTag(indentMM, 'NonTrusteeContactPhoneNumber');
      AddTag(indentMMM, 'PhoneAreaCode', NonTrusteePhoneAreaCode, stDontSkipIfEmpty);
      AddTag(indentMMM, 'PhoneNumber', NonTrusteePhoneNumber, stDontSkipIfEmpty);
      AddTag(indentMMM, 'PhoneExtensionNumber', NonTrusteePhoneExtensionNumber);
      AddEndTag(indentMM, 'NonTrusteeContactPhoneNumber');
    end;

    if IsAnyNonEmpty(VarArrayOf([
                    SettlementLandName,
                    SettlementLandNumber
                             ])) then
    begin
      AddBeginTag(indentMM, 'DesignatedAboriginalSettlementLandResidenceInformation');
      AddTag(indentMMM, 'SettlementLandName', SettlementLandName, stDontSkipIfEmpty);
      AddTag(indentMMM, 'SettlementLandNumber', SettlementLandNumber, stDontSkipIfEmpty);
      AddEndTag(indentMM, 'DesignatedAboriginalSettlementLandResidenceInformation');
    end;

    If TrustBusinessIncomeProvince>'' then  //20190331
      AddTag(indentMM, 'TrustBusinessIncomeProvince', TrustBusinessIncomeProvince, stDontSkipIfEmpty);

    AddDate(indentMM, 'TrustCanadianResidentStartDate',
                TrustCanadianResidentStartYear,
                TrustCanadianResidentStartMonth,
                TrustCanadianResidentStartDay);
    AddDate(indentMM, 'TrustCanadianResidentEndDate',
                TrustCanadianResidentEndYear,
                TrustCanadianResidentEndMonth,
                TrustCanadianResidentEndDay);
    AddTag(indentMM, 'TrustDeemedCanadianResidentIndicator', TrustDeemedCanadianResidentIndicator);
    AddTag(indentMM, 'TrustForeignResidentCountry', TrustForeignResidentCountry);
    AddTag(indentMM, 'TrustCorrespondenceLanguageCode', TrustCorrespondenceLanguageCode);
    AddTag(indentMM, 'TrustTypeCode', TrustTypeCode, stDontSkipIfEmpty);
    AddTag(indentMM, 'TrustTypeDescription', TrustTypeDescription);

    if IsAnyNonEmpty(VarArrayOf([
                    TestatorDeathYear,
                    TestatorDeathMonth,
                    TestatorDeathDay,
                    TestatorSIN
                             ])) then
    begin
      AddBeginTag(indentMM, 'TestamentaryTrustInformation');
      AddDate(indentMMM, 'TestatorDeathDate',
                  TestatorDeathYear,
                  TestatorDeathMonth,
                  TestatorDeathDay, stDontSkipIfEmpty);
      AddTag(indentMMM, 'TestatorSIN', TestatorSIN, stDontSkipIfEmpty);
      AddEndTag(indentMM, 'TestamentaryTrustInformation');
    end;

    if IsAnyNonEmpty(VarArrayOf([
                    TrustCreateYear,
                    TrustCreateMonth,
                    TrustCreateDay,
                    NonProfitorganizationBN
                             ])) then
    begin
      AddBeginTag(indentMM, 'InterVivosTrustInformation');
      AddDate(indentMMM, 'TrustCreateDate',
                  TrustCreateYear,
                  TrustCreateMonth,
                  TrustCreateDay, stDontSkipIfEmpty);
      AddTag(indentMMM, 'NonProfitorganizationBN', NonProfitorganizationBN);
      AddEndTag(indentMM, 'InterVivosTrustInformation');
    end;

    AddDate(indentMM, 'TrustFiscalPeriodStartDate',
                TrustFiscalPeriodStartYear,
                TrustFiscalPeriodStartMonth,
                TrustFiscalPeriodStartDay, stDontSkipIfEmpty);
    AddDate(indentMM, 'TrustFiscalPeriodEndDate',
                TrustFiscalPeriodEndYear,
                TrustFiscalPeriodEndMonth,
                TrustFiscalPeriodEndDay, stDontSkipIfEmpty);
    AddTag(indentMM, 'FirstYearFilingIndicator', FirstYearFilingIndicator);

    if FetchElm(RetNo,'T3',27)>''  then //First year filing  //20190401
    Begin
     if IsAnyNonEmpty(VarArrayOf([
                    TrustPreviousGeneralIncomeTaxReturnTaxYear,
                    TrustDocumentFilingMethod
                             ])) then
     begin
       AddBeginTag(indentMM, 'FirstYearFilingIndicatorGroup');
       AddTag(indentMMM, 'TrustPreviousGeneralIncomeTaxReturnTaxYear', TrustPreviousGeneralIncomeTaxReturnTaxYear);
       AddTag(indentMMM, 'TrustDocumentFilingMethod', TrustDocumentFilingMethod);
       AddEndTag(indentMM, 'FirstYearFilingIndicatorGroup');
     end;
    End;

    AddTag(indentMM, 'TrustFinalGeneralIncomeTaxReturnIndicator', TrustFinalGeneralIncomeTaxReturnIndicator);
    AddDate(indentMM, 'TrustWindupDate',
                TrustWindupYear,
                TrustWindupMonth,
                TrustWindupDay);
    AddTag(indentMM, 'TrustForeignPropertyCostExceedingIndicator', TrustForeignPropertyCostExceedingIndicator);

    AddEndTag(indentM, 'TrustIdentInformation');
    AddBeginTag(indentM, 'TrustOtherInformation');

    AddTag(indentMM, 'ElectingTrustIndicator', ElectingTrustIndicator, stDontSkipIfEmpty);
    AddTag(indentMM, 'TrustNonResidentIncomeElectionYear', TrustNonResidentIncomeElectionYear);
    AddTag(indentMM, 'TrustIncomeBeneficiaryAllocationRequiredIndicator', TrustIncomeBeneficiaryAllocationRequiredIndicator, stDontSkipIfEmpty);
    AddTag(indentMM, 'TrustNonCashAssetBeneficiaryDistributionIndicator', TrustNonCashAssetBeneficiaryDistributionIndicator, stDontSkipIfEmpty);
    AddTag(indentMM, 'TrustBeneficiaryChangeIndicator', TrustBeneficiaryChangeIndicator, stDontSkipIfEmpty);
    AddTag(indentMM, 'TrustDeemedDispositionBeneficiaryDeathIndicator', TrustDeemedDispositionBeneficiaryDeathIndicator, stDontSkipIfEmpty);
    AddDate(indentMM, 'TrustDeemedDispositionBeneficiaryDeathDate',
                TrustDeemedDispositionBeneficiaryDeathYear,
                TrustDeemedDispositionBeneficiaryDeathMonth,
                TrustDeemedDispositionBeneficiaryDeathDay);
    AddTag(indentMM, 'TrustNonArmsLengthDebtTransactionIndicator', TrustNonArmsLengthDebtTransactionIndicator, stDontSkipIfEmpty);
    AddTag(indentMM, 'TrustNonArmsLengthDebtTransactionYear', TrustNonArmsLengthDebtTransactionYear);
    AddTag(indentMM, 'TrustCapitalIncomeInterestOwnershipChangeIndicator', TrustCapitalIncomeInterestOwnershipChangeIndicator, stDontSkipIfEmpty);
    AddTag(indentMM, 'TrustCapitalIncomeInterestOwnershipChangeYear', TrustCapitalIncomeInterestOwnershipChangeYear);
    AddTag(indentMM, 'TrustPrivateCorporationShareHolderIndicator', TrustPrivateCorporationShareHolderIndicator, stDontSkipIfEmpty);
    AddTag(indentMM, 'TrustAdditionalContributionPropertyReceiptIndicator', TrustAdditionalContributionPropertyReceiptIndicator, stDontSkipIfEmpty);
    AddTag(indentMM, 'TrustAdditionalContributionPropertyReceiptYear', TrustAdditionalContributionPropertyReceiptYear);
    AddTag(indentMM, 'PublicTrustIndicator', PublicTrustIndicator, stDontSkipIfEmpty);
    AddTag(indentMM, 'TrustInternationalFinancialReportingStandardIndicator', TrustInternationalFinancialReportingStandardIndicator, stDontSkipIfEmpty);
    AddTag(indentMM, 'TrustLossRestrictionEventIndicator', TrustLossRestrictionEventIndicator, stDontSkipIfEmpty);
    AddDate(indentMM, 'TrustLossRestrictionEventDate',
                TrustLossRestrictionEventYear,
                TrustLossRestrictionEventMonth,
                TrustLossRestrictionEventDay);

    AddEndTag(indentM, 'TrustOtherInformation');

   AddBeginTag(indentM, 'TrustTotalIncome'); //required tag even tho all children are optional?
   if Vl(FetchElm(RetNo,'T3',126))>0 then //total income
   Begin
    AddTag(indentMM, 'TaxableCapitalGainAmount', TaxableCapitalGainAmount); //20180317
   // AddTag(indentMM, 'TaxableCapitalGainAmount', TaxableCapitalGainAmount);
    AddTag(indentMM, 'PensionIncomeAmount', PensionIncomeAmount);
    AddTag(indentMM, 'TaxableCanadianCorporationActualDividendAmount', TaxableCanadianCorporationActualDividendAmount);
    AddTag(indentMM, 'ForeignInvestmentIncomeAmount', ForeignInvestmentIncomeAmount);
    AddTag(indentMM, 'OtherInvestmentIncomeAmount', OtherInvestmentIncomeAmount);
    AddTag(indentMM, 'BusinessGrossIncomeAmount', BusinessGrossIncomeAmount);
    AddTag(indentMM, 'BusinessNetIncomeAmount', BusinessNetIncomeAmount);
    AddTag(indentMM, 'FarmingFishingGrossIncomeAmount', FarmingFishingGrossIncomeAmount);
    AddTag(indentMM, 'FarmingFishingNetIncomeAmount', FarmingFishingNetIncomeAmount);
    AddTag(indentMM, 'RealEstatePropertyRentalGrossIncomeAmount', RealEstatePropertyRentalGrossIncomeAmount);
    AddTag(indentMM, 'RealEstatePropertyRentalNetIncomeAmount', RealEstatePropertyRentalNetIncomeAmount);
    AddTag(indentMM, 'AgriInvestFund2IncomeAmount', AgriInvestFund2IncomeAmount);
    AddTag(indentMM, 'TrustBeneficiarySpouseAliveCommunalOrganizationAgriInvestFund2IncomeAmount', TrustBeneficiarySpouseAliveCommunalOrganizationAgriInvestFund2IncomeAmount);
    AddTag(indentMM, 'DeemedPropertyDispositionNetIncomeAmount', DeemedPropertyDispositionNetIncomeAmount);
    AddTag(indentMM, 'OtherIncomeAmount', OtherIncomeAmount);
   end;
   AddEndTag(indentM, 'TrustTotalIncome');

   AddBeginTag(indentM, 'TrustNetIncome');
   if Vl(FetchElm(RetNo,'T3',256))>0 then //total income
   Begin
    AddTag(indentMM, 'InvestmentFeeInterestPaidAmount', InvestmentFeeInterestPaidAmount);
    AddTag(indentMM, 'TrusteeFeeAmount', TrusteeFeeAmount);
    AddTag(indentMM, 'NonDeductibleTrusteeFeeAmount', NonDeductibleTrusteeFeeAmount);
    AddTag(indentMM, 'AllowableBusinessInvestmentLossAmount', AllowableBusinessInvestmentLossAmount);
    AddTag(indentMM, 'GrossIncomeOtherDeductionAmount', GrossIncomeOtherDeductionAmount);
    AddTag(indentMM, 'TrustTaxableBeneficiaryPropertyExpenseBenefitAmount', TrustTaxableBeneficiaryPropertyExpenseBenefitAmount);
    AddTag(indentMM, 'TrustTaxableOtherBeneficiaryBenefitAmount', TrustTaxableOtherBeneficiaryBenefitAmount);
    AddTag(indentMM, 'TrustAllocationIncomeAmount', TrustAllocationIncomeAmount);
    AddTag(indentMM, 'TrustRetainedAllocationIncomeAmount', TrustRetainedAllocationIncomeAmount);
    AddTag(indentMM, 'TrustDeductibleAllocationIncomeAmount', TrustDeductibleAllocationIncomeAmount);
    AddTag(indentMM, 'TrustRetainedDividendGrossUpAmount', TrustRetainedDividendGrossUpAmount);
   end;
   AddTag(indentMM, 'NetIncomeAmount', NetIncomeAmount);
   AddEndTag(indentM, 'TrustNetIncome');

    AddBeginTag(indentM, 'TrustTaxableIncome');
    AddTag(indentMM, 'NonCapitalLossCarryforwardAmount', NonCapitalLossCarryforwardAmount);
    AddTag(indentMM, 'NetCapitalLossCarryforwardAmount', NetCapitalLossCarryforwardAmount);
    AddTag(indentMM, 'NetIncomeOtherDeductionDescription', NetIncomeOtherDeductionDescription);
    AddTag(indentMM, 'NetIncomeOtherDeductionAmount', NetIncomeOtherDeductionAmount);
    AddTag(indentMM, 'TaxableIncomeAmount', TaxableIncomeAmount, stDontSkipIfEmpty);

    AddEndTag(indentM, 'TrustTaxableIncome');

   //  ---------------------------------
    AddBeginTag(indentM, 'TrustTaxSummary');

    AddTag(indentMM, 'TotalTaxPayableAmount', TotalTaxPayableAmount, stDontSkipIfEmpty);
    AddTag(indentMM, 'IncomeTaxBalanceAmount', IncomeTaxBalanceAmount, stDontSkipIfEmpty);

    AddEndTag(indentM, 'TrustTaxSummary');

    //-------------------------------------------------------

    if Ret[RetNo].FrmHasData[GetFormNo('S1')] then
    begin
     AddBeginTag(indentM, 'Schedule1');
     if IsAnyNonEmpty(VarArrayOf([B1011, B1012])) then
     begin
       AddBeginTag(indentMM, 'QualifiedSmallBusinessCorporationShareDisposition');
       AddTag(indentMMM, 'GrossDispositionAmount', B1011);
       AddTag(indentMMM, 'NetDispositionAmount', B1012);
       AddEndTag(indentMM, 'QualifiedSmallBusinessCorporationShareDisposition');
     end;

     if IsAnyNonEmpty(VarArrayOf([B1021, B1022])) then
     begin
       AddBeginTag(indentMM, 'QualifiedFarmFishingPropertyDisposition');
       AddTag(indentMMM, 'GrossDispositionAmount', B1021);
       AddTag(indentMMM, 'NetDispositionAmount', B1022);
       AddEndTag(indentMM, 'QualifiedFarmFishingPropertyDisposition');
     end;

     if IsAnyNonEmpty(VarArrayOf([B1031, B1032])) then
     begin
       AddBeginTag(indentMM, 'UnitShareDisposition');
       AddTag(indentMMM, 'GrossDispositionAmount', B1031);
       AddTag(indentMMM, 'NetDispositionAmount', B1032);
       AddEndTag(indentMM, 'UnitShareDisposition');
     end;

     if IsAnyNonEmpty(VarArrayOf([B1041, B1042])) then
     begin
       AddBeginTag(indentMM, 'BondDebenturePromissoryNoteDisposition');
       AddTag(indentMMM, 'GrossDispositionAmount', B1041);
       AddTag(indentMMM, 'NetDispositionAmount', B1042);
       AddEndTag(indentMM, 'BondDebenturePromissoryNoteDisposition');
     end;

     if IsAnyNonEmpty(VarArrayOf([B1051, B1052])) then
     begin
       AddBeginTag(indentMM, 'RealEstatePropertyDisposition');
       AddTag(indentMMM, 'GrossDispositionAmount', B1051);
       AddTag(indentMMM, 'NetDispositionAmount', B1052);
       AddEndTag(indentMM, 'RealEstatePropertyDisposition');
     end;

     if IsAnyNonEmpty(VarArrayOf([B1061, B1062])) then
     begin
       AddBeginTag(indentMM, 'PersonalUsePropertyDisposition');
       AddTag(indentMMM, 'GrossDispositionAmount', B1061);
       AddTag(indentMMM, 'DispositionCapitalGainAmount', B1062);
       AddEndTag(indentMM, 'PersonalUsePropertyDisposition');
     end;

     if IsAnyNonEmpty(VarArrayOf([B1071, B1072, B1080])) then
     begin
      AddBeginTag(indentMM, 'ListedPersonalPropertyDisposition');
      AddTag(indentMMM, 'GrossDispositionAmount', B1071);
      AddTag(indentMMM, 'NetDispositionAmount', B1072);
      AddTag(indentMMM, 'DeemedOtherYearListedPersonalPropertyDispositionCapitalLossAmount', B1080);
      AddEndTag(indentMM, 'ListedPersonalPropertyDisposition');
     end;

     if IsAnyNonEmpty(VarArrayOf([B1100, B1130, B1170, B1191, B1646])) then
     begin
       AddTag(indentMM, 'InformationSlipCapitalGainLossAmount', B1100);
       AddTag(indentMM, 'BusinessInvestmentLossConvertedCapitalLossAmount', B1130);
       AddTag(indentMM, 'TotalPreviousCurrentYearCapitalPropertyDispositionReserveDifferenceAmount', B1170);
       AddTag(indentMM, 'NonEligibleCapitalPropertyGiftCapitalGainAmount', B1191);
       AddTag(indentMM, 'FinalIndividualIncomeTaxReturnTransferredCapitalLossAmount', B1646);
     end;

     if IsAnyNonEmpty(VarArrayOf([B1091, B1092])) then
     begin
       AddBeginTag(indentMM, 'NonQualifiedInvestmentDisposition');
       AddTag(indentMMM, 'GrossDispositionAmount', B1091);
       AddTag(indentMMM, 'NetDispositionAmount', B1092);
       AddEndTag(indentMM, 'NonQualifiedInvestmentDisposition');
     end;

     AddTag(indentMM, 'TotalTaxableCapitalGainNetCapitalLossAmount', B1220);
     AddEndTag(indentM, 'Schedule1');
    end;  //s1


    //-------------------------------------------------------
    if Ret[RetNo].FrmHasData[GetFormNo('S8')] then
    begin
     AddBeginTag(indentM, 'Schedule8');
     AddBeginTag(indentMM, 'InvestmentIncomeAndCarryingCharges');

     if IsAnyNonEmpty(VarArrayOf([B8110, B8120])) then
     begin
       AddBeginTag(indentMMM, 'TaxableCanadianCorporationDividendIncome');
       AddTag(indentMMMM, 'ActualNonEligibleDividendAmount', B8110);
       AddTag(indentMMMM, 'ActualEligibleDividendAmount', B8120);
       AddEndTag(indentMMM, 'TaxableCanadianCorporationDividendIncome');
     end;

     if IsAnyNonEmpty(VarArrayOf([B8160, B8170, B8180, B8190])) then
     begin
      AddBeginTag(indentMMM, 'InvestmentExpense');
      AddTag(indentMMMM, 'LoanInterestAmount', B8160);
      AddTag(indentMMMM, 'ManagementFeeAmount', B8170);
      AddTag(indentMMMM, 'CounselFeeAmount', B8180);
      AddTag(indentMMMM, 'OtherExpenseAmount', B8190);
      AddEndTag(indentMMM, 'InvestmentExpense');
     end;

     AddEndTag(indentMM, 'InvestmentIncomeAndCarryingCharges');
     if IsAnyNonEmpty(VarArrayOf([B8239, B8240])) then
     begin
       AddBeginTag(indentMM, 'RetainedDividendGrossUp');
       AddTag(indentMMM, 'NonResidentBeneficiaryAllocationEligibleDividendAmount', B8239);
       AddTag(indentMMM, 'NonResidentBeneficiaryAllocationNonEligibleDividendAmount', B8240);
       AddEndTag(indentMM, 'RetainedDividendGrossUp');
     end;
     AddEndTag(indentM, 'Schedule8');
    end; //s8


    //--------S9 -----------------------------------------------
   if Ret[RetNo].FrmHasData[GetFormNo('S9')] then
   Begin
    AddBeginTag(indentM, 'Schedule9');
    AddBeginTag(indentMM, 'TotalIncomeAllocationDesignation');
    if IsAnyNonEmpty(VarArrayOf([
          B9001, B9002, B9003, B9004,
          SlipIndividualAttributedAmountIndicator,
          IncomeEqualAllocationIndicator
                              ])) then
     begin
       AddBeginTag(indentMMM, 'IncomeAllocationDesignationStatement');
       AddTag(indentMMMM, 'IncomeAllocationBeneficiaryCount', B9001);
       AddTag(indentMMMM, 'ResidentBeneficiaryAllocationNonSlipIncomeAmount', B9002);
       AddTag(indentMMMM, 'NonTaxableBeneficiaryAllocationIncomeAmount', B9003);
       AddTag(indentMMMM, 'SecurityTransactionStatementAllocationTaxableCapitalGainAmount', B9004);
       AddTag(indentMMMM, 'SlipIndividualAttributedAmountIndicator', SlipIndividualAttributedAmountIndicator);
       AddTag(indentMMMM, 'IncomeEqualAllocationIndicator', IncomeEqualAllocationIndicator);
       AddEndTag(indentMMM, 'IncomeAllocationDesignationStatement');
     end;

     AddBeginTag(indentMMM, 'IncomeAllocationDesignation');

     if IsAnyNonEmpty(VarArrayOf([B921_1, B921_2, B921_3])) then
     begin
       AddBeginTag(indentMMMM, 'TaxableCapitalGain');
       AddTag(indentMMMMM, 'ResidentBeneficiaryAmount', B921_1);
       AddTag(indentMMMMM, 'NonResidentBeneficiaryAmount', B921_2);
       AddTag(indentMMMMM, 'PreferredBeneficiaryElectionAmount', B921_3);
       AddEndTag(indentMMMM, 'TaxableCapitalGain');
     end;

     if IsAnyNonEmpty(VarArrayOf([B922_1, B922_2])) then
     begin
       AddBeginTag(indentMMMM, 'LumpSumPensionIncome');
       AddTag(indentMMMMM, 'ResidentBeneficiaryAmount', B922_1);
       AddTag(indentMMMMM, 'NonResidentBeneficiaryAmount', B922_2);
       AddEndTag(indentMMMM, 'LumpSumPensionIncome');
     end;

     if IsAnyNonEmpty(VarArrayOf([B923_1, B923_2, B923_3])) then
     begin
      AddBeginTag(indentMMMM, 'ActualNonEligibleDividend');
      AddTag(indentMMMMM, 'ResidentBeneficiaryAmount', B923_1);
      AddTag(indentMMMMM, 'NonResidentBeneficiaryAmount', B923_2);
      AddTag(indentMMMMM, 'PreferredBeneficiaryElectionAmount', B923_3);
      AddEndTag(indentMMMM, 'ActualNonEligibleDividend');
     end;

    if IsAnyNonEmpty(VarArrayOf([B924_1, B924_2, B924_3])) then
    begin
      AddBeginTag(indentMMMM, 'ForeignBusinessIncome');
      AddTag(indentMMMMM, 'ResidentBeneficiaryAmount', B924_1);
      AddTag(indentMMMMM, 'NonResidentBeneficiaryAmount', B924_2);
      AddTag(indentMMMMM, 'PreferredBeneficiaryElectionAmount', B924_3);
      AddEndTag(indentMMMM, 'ForeignBusinessIncome');
    end;

    if IsAnyNonEmpty(VarArrayOf([B925_1, B925_2, B925_3])) then
    begin
      AddBeginTag(indentMMMM, 'ForeignNonBusinessIncome');
      AddTag(indentMMMMM, 'ResidentBeneficiaryAmount', B925_1);
      AddTag(indentMMMMM, 'NonResidentBeneficiaryAmount', B925_2);
      AddTag(indentMMMMM, 'PreferredBeneficiaryElectionAmount', B925_3);
      AddEndTag(indentMMMM, 'ForeignNonBusinessIncome');
    end;

    if IsAnyNonEmpty(VarArrayOf([B926_1, B926_2, B926_3])) then
    begin
      AddBeginTag(indentMMMM, 'OtherIncome');
      AddTag(indentMMMMM, 'ResidentBeneficiaryAmount', B926_1);
      AddTag(indentMMMMM, 'NonResidentBeneficiaryAmount', B926_2);
      AddTag(indentMMMMM, 'PreferredBeneficiaryElectionAmount', B926_3);
      AddEndTag(indentMMMM, 'OtherIncome');
    end;

    if IsAnyNonEmpty(VarArrayOf([B949_1, B949_2, B949_3])) then
    begin
      AddBeginTag(indentMMMM, 'ActualEligibleDividendAmount');
      AddTag(indentMMMMM, 'ResidentBeneficiaryAmount', B949_1);
      AddTag(indentMMMMM, 'NonResidentBeneficiaryAmount', B949_2);
      AddTag(indentMMMMM, 'PreferredBeneficiaryElectionAmount', B949_3);
      AddEndTag(indentMMMM, 'ActualEligibleDividendAmount');
    end;

    AddEndTag(indentMMM, 'IncomeAllocationDesignation');

    AddEndTag(indentMM, 'TotalIncomeAllocationDesignation');

    AddBeginTag(indentMM, 'OtherAmountDesignationSummary');

    if IsAnyNonEmpty(VarArrayOf([B930_1, B930_2, B930_3])) then
    begin
      AddBeginTag(indentMMM, 'EligibleTaxableCapitalGain');
      AddTag(indentMMMM, 'ResidentBeneficiaryAmount', B930_1);
      AddTag(indentMMMM, 'NonResidentBeneficiaryAmount', B930_2);
      AddTag(indentMMMM, 'PreferredBeneficiaryElectionAmount', B930_3);
      AddEndTag(indentMMM, 'EligibleTaxableCapitalGain');
    end;

    if IsAnyNonEmpty(VarArrayOf([B931_1])) then
    begin
      AddBeginTag(indentMMM, 'QualifyingPensionIncome');
      AddTag(indentMMMM, 'ResidentBeneficiaryAmount', B931_1);
      AddEndTag(indentMMM, 'QualifyingPensionIncome');
    end;

    if IsAnyNonEmpty(VarArrayOf([B932_1, B932_3])) then
    begin
      AddBeginTag(indentMMM, 'TaxableNonEligibleDividend');
      AddTag(indentMMMM, 'ResidentBeneficiaryAmount', B932_1);
      AddTag(indentMMMM, 'PreferredBeneficiaryElectionAmount', B932_3);
      AddEndTag(indentMMM, 'TaxableNonEligibleDividend');
    end;

    if IsAnyNonEmpty(VarArrayOf([B933_1, B933_2, B933_3])) then
    begin
      AddBeginTag(indentMMM, 'ForeignBusinessIncomeTaxPaid');
      AddTag(indentMMMM, 'ResidentBeneficiaryAmount', B933_1);
      AddTag(indentMMMM, 'NonResidentBeneficiaryAmount', B933_2);
      AddTag(indentMMMM, 'PreferredBeneficiaryElectionAmount', B933_3);
      AddEndTag(indentMMM, 'ForeignBusinessIncomeTaxPaid');
    end;

    if IsAnyNonEmpty(VarArrayOf([B934_1, B934_2, B934_3])) then
    begin
      AddBeginTag(indentMMM, 'ForeignNonBusinessIncomeTaxPaid');
      AddTag(indentMMMM, 'ResidentBeneficiaryAmount', B934_1);
      AddTag(indentMMMM, 'NonResidentBeneficiaryAmount', B934_2);
      AddTag(indentMMMM, 'PreferredBeneficiaryElectionAmount', B934_3);
      AddEndTag(indentMMM, 'ForeignNonBusinessIncomeTaxPaid');
    end;

    if IsAnyNonEmpty(VarArrayOf([B935_1, B935_2])) then
    begin
      AddBeginTag(indentMMM, 'EligibleDeathBenefit');
      AddTag(indentMMMM, 'ResidentBeneficiaryAmount', B935_1);
      AddTag(indentMMMM, 'NonResidentBeneficiaryAmount', B935_2);
      AddEndTag(indentMMM, 'EligibleDeathBenefit');
    end;

    if IsAnyNonEmpty(VarArrayOf([B937_1, B937_2])) then
    begin
      AddBeginTag(indentMMM, 'InsuranceSegregatedFundNetCapitalLoss');
      AddTag(indentMMMM, 'ResidentBeneficiaryAmount', B937_1);
      AddTag(indentMMMM, 'NonResidentBeneficiaryAmount', B937_2);
      AddEndTag(indentMMM, 'InsuranceSegregatedFundNetCapitalLoss');
    end;

    if IsAnyNonEmpty(VarArrayOf([B938_1])) then
    begin
      AddBeginTag(indentMMM, 'PartXII2TaxCredit');
      AddTag(indentMMMM, 'ResidentBeneficiaryAmount', B938_1);
      AddEndTag(indentMMM, 'PartXII2TaxCredit');
    end;

    if IsAnyNonEmpty(VarArrayOf([B939_1, B939_3])) then
    begin
      AddBeginTag(indentMMM, 'NonEligibleDividendTaxCredit');
      AddTag(indentMMMM, 'ResidentBeneficiaryAmount', B939_1);
      AddTag(indentMMMM, 'PreferredBeneficiaryElectionAmount', B939_3);
      AddEndTag(indentMMM, 'NonEligibleDividendTaxCredit');
    end;

    if IsAnyNonEmpty(VarArrayOf([B940_1, B940_2, B940_3])) then
    begin
      AddBeginTag(indentMMM, 'InvestmentCostExpenditure');
      AddTag(indentMMMM, 'ResidentBeneficiaryAmount', B940_1);
      AddTag(indentMMMM, 'NonResidentBeneficiaryAmount', B940_2);
      AddTag(indentMMMM, 'PreferredBeneficiaryElectionAmount', B940_3);
      AddEndTag(indentMMM, 'InvestmentCostExpenditure');
    end;

    if IsAnyNonEmpty(VarArrayOf([B941_1, B941_2, B941_3])) then
    begin
      AddBeginTag(indentMMM, 'InvestmentTaxCredit');
      AddTag(indentMMMM, 'ResidentBeneficiaryAmount', B941_1);
      AddTag(indentMMMM, 'NonResidentBeneficiaryAmount', B941_2);
      AddTag(indentMMMM, 'PreferredBeneficiaryElectionAmount', B941_3);
      AddEndTag(indentMMM, 'InvestmentTaxCredit');
    end;

    if IsAnyNonEmpty(VarArrayOf([B942_1, B942_2, B942_3])) then
    begin
      AddBeginTag(indentMMM, 'CostBaseAdjustment');
      AddTag(indentMMMM, 'ResidentBeneficiaryAmount', B942_1);
      AddTag(indentMMMM, 'NonResidentBeneficiaryAmount', B942_2);
      AddTag(indentMMMM, 'PreferredBeneficiaryElectionAmount', B942_3);
      AddEndTag(indentMMM, 'CostBaseAdjustment');
    end;

    if IsAnyNonEmpty(VarArrayOf([B945_1, B945_2, B945_3])) then
    begin
      AddBeginTag(indentMMM, 'OtherCredit');
      AddTag(indentMMMM, 'ResidentBeneficiaryAmount', B945_1);
      AddTag(indentMMMM, 'NonResidentBeneficiaryAmount', B945_2);
      AddTag(indentMMMM, 'PreferredBeneficiaryElectionAmount', B945_3);
      AddEndTag(indentMMM, 'OtherCredit');
    end;

    if IsAnyNonEmpty(VarArrayOf([B946_1, B946_2])) then
    begin
      AddBeginTag(indentMMM, 'YouthQualifyingAnnuityPensionIncome');
      AddTag(indentMMMM, 'ResidentBeneficiaryAmount', B946_1);
      AddTag(indentMMMM, 'NonResidentBeneficiaryAmount', B946_2);
      AddEndTag(indentMMM, 'YouthQualifyingAnnuityPensionIncome');
    end;

    if IsAnyNonEmpty(VarArrayOf([B947_1, B947_2])) then
    begin
      AddBeginTag(indentMMM, 'TransferrableRetiringAllowance');
      AddTag(indentMMMM, 'ResidentBeneficiaryAmount', B947_1);
      AddTag(indentMMMM, 'NonResidentBeneficiaryAmount', B947_2);
      AddEndTag(indentMMM, 'TransferrableRetiringAllowance');
    end;

    if IsAnyNonEmpty(VarArrayOf([B948_1, B948_2])) then
    begin
      AddBeginTag(indentMMM, 'EligibleCharitableDonation');
      AddTag(indentMMMM, 'ResidentBeneficiaryAmount', B948_1);
      AddTag(indentMMMM, 'NonResidentBeneficiaryAmount', B948_2);
      AddEndTag(indentMMM, 'EligibleCharitableDonation');
    end;

    if IsAnyNonEmpty(VarArrayOf([B950_1, B950_3])) then
    begin
      AddBeginTag(indentMMM, 'TaxableEligibleDividend');
      AddTag(indentMMMM, 'ResidentBeneficiaryAmount', B950_1);
      AddTag(indentMMMM, 'PreferredBeneficiaryElectionAmount', B950_3);
      AddEndTag(indentMMM, 'TaxableEligibleDividend');
    end;

    if IsAnyNonEmpty(VarArrayOf([B951_1, B951_3])) then
    begin
      AddBeginTag(indentMMM, 'EligibleDividendTaxCredit');
      AddTag(indentMMMM, 'ResidentBeneficiaryAmount', B951_1);
      AddTag(indentMMMM, 'PreferredBeneficiaryElectionAmount', B951_3);
      AddEndTag(indentMMM, 'EligibleDividendTaxCredit');
    end;

    AddEndTag(indentMM, 'OtherAmountDesignationSummary');
    AddEndTag(indentM, 'Schedule9');
   End; //S9


   //---------------S12----------------------------------------
   if Ret[RetNo].FrmHasData[GetFormNo('S12')] then
   Begin
    AddBeginTag(indentM, 'Schedule12');
    AddBeginTag(indentMM, 'TrustMinimumTaxNetAdjustedTaxableIncome');

    AddTag(indentMMM, 'TrustRetainedNonTaxableCapitalGainAmount', B12030);
    AddTag(indentMMM, 'IncomeTaxApplicationRuleFortyElectedPensionBenefitAmount', B12040);

    if IsAnyNonEmpty(VarArrayOf([B12050, B12060])) then
    begin
      AddBeginTag(indentMMM, 'RentalPropertyInvestment');
      AddTag(indentMMMM, 'CapitalCostAllowanceCarryingChargeAmount', B12050);
      AddTag(indentMMMM, 'PreDeductionAdjustmentNetIncomeAmount', B12060);
      AddEndTag(indentMMM, 'RentalPropertyInvestment');
    end;

    if IsAnyNonEmpty(VarArrayOf([B12080, B12090])) then
    begin
      AddBeginTag(indentMMM, 'FilmPropertyInvestment');
      AddTag(indentMMMM, 'CapitalCostAllowanceCarryingChargeAmount', B12080);
      AddTag(indentMMMM, 'PreDeductionAdjustmentNetIncomeAmount', B12090);
      AddEndTag(indentMMM, 'FilmPropertyInvestment');
    end;

    if IsAnyNonEmpty(VarArrayOf([B12110, B12120, B12130])) then
    begin
      AddBeginTag(indentMMM, 'NaturalResourceInvestment');
      AddTag(indentMMMM, 'NaturalResourceDeductionAllowanceCarryingChargeAmount', B12110);
      AddTag(indentMMMM, 'PreDeductionAdjustmentResourceProductionIncomeAmount', B12120);
      AddTag(indentMMMM, 'NaturalResourcePropertyIncomeAmount', B12130);
      AddEndTag(indentMMM, 'NaturalResourceInvestment');
    end;

    AddTag(indentMMM, 'TrustLimitedPartnershipTaxShelterLossAmount', B12160);
    AddTag(indentMMM, 'TrustLimitedPartnershipNetCarryingChargeAmount', B12170);
    AddTag(indentMMM, 'FirstGroupPriorYearAdjustedNonCapitalLossCarryforwardAmount', B12220);
    AddTag(indentMMM, 'SecondGroupPriorYearAdjustedNonCapitalLossCarryforwardAmount', B12221);
    AddTag(indentMMM, 'PriorYearAdjustedNetCapitalLossCarryforwardAmount', B12240);
    AddTag(indentMMM, 'TaxableIncomeBasicExemptionAmount', B12260);
    AddTag(indentMMM, 'MinimumTaxNetAdjustedTaxableIncomeAmount', B12270);

    AddEndTag(indentMM, 'TrustMinimumTaxNetAdjustedTaxableIncome');

    if IsAnyNonEmpty(VarArrayOf([B12680, B12760, B12690])) then
    begin
      AddBeginTag(indentMM, 'TrustMinimumTaxCarryover');
      AddTag(indentMMM, 'PriorYearMinimumTaxCarryoverAmount', B12680);
      AddTag(indentMMM, 'ExpiredPriorYearUnappliedMinimumTaxCarryoverAmount', B12760);
      AddTag(indentMMM, 'NextYearAvailableMinimumTaxCarryoverAmount', B12690);
      AddEndTag(indentMM, 'TrustMinimumTaxCarryover');
    end;
    AddEndTag(indentM, 'Schedule12');
   end; //s12
   //-------------------------------------------------------

  end; //with T3RetRec //20180329

  T3XmlList.add(Space(indentM) + '</T3GEN>');
  T3XmlList.add(Space(indent) + '</Return>');

  addSubmissionTag('END', T3XmlList);
end;



Function ReplaceSpecialChar(info:String):String;
Begin
 info := ReplaceChar(info,'&','&amp;');
 info := ReplaceChar(info, '<' , '&lt;' );
 info := ReplaceChar(info,'"','&quot;');
 info := ReplaceChar(info,'>','&gt;');
 info := ReplaceChar(info,'''','&apos;');

 //info := ReplaceChar(info,'.','');  //20180316 CON dangerous converts dollars to 100 times more

 result := info;

End;

Function FixPostal(s:String):String;
{remove space or dash}
begin
 Result := RemoveChar(s,' ');
 result := RemoveChar(Result,'-');
end;

//jz//20250323 - Procedure PrepareT619 same in  T3_2026dataGen, T4T5_2026dataGen and TF_2026dataGen EXCEPT:
//                  TF_2026dataGen has 3 extra lines:
//                  - ContName:= Info;
//                  - ContArea:=LeftStr(OptRec.Prp_Area,3);
//                  - ContPhone:=RemoveChar(LeftStr(OptRec.Prp_Tel,8),' ');

//                  T4T5_2026dataGen may not be using PrepareT619 in T4T5_2026dataGen:
//                  - using PrepareXmitterinfo in T4T5_2026PrepareXml instead ???
//20260107 Igor >>>
procedure PrepareT619(var T619XmlList: TStringList; RetNo: Integer; DataTypeCode: string; SubmitRef: string);
var
  Info, Lang: string;
begin
  T619XmlList.add(Space(indent) + '<T619>');

  //Required up to 15 alphanumeric
  T619XmlList.add(Space(indentM) + '<TransmitterAccountNumber>');

  //20260323
  info:= OptRec.Prp_TransmitterNo;
  if (Length(info) = 9) then
      T619XmlList.add(Space(indentMM) + '<bn9>' + OptRec.Prp_TransmitterNo + '</bn9>)')
    else
      T619XmlList.add(Space(indentMM) + '<bn15>' + OptRec.Prp_TransmitterNo + '</bn15>');

  {
  if not FetchElm(RetNo, 'T3', 2).IsEmpty() then
  begin
    T619XmlList.add(Space(indentMM) + '<trust>T' + FetchElm(RetNo, 'T3', 2) + '</trust>')
  end
  else
  begin
    info:= OptRec.Prp_TransmitterNo;
    if (Length(info) = 9) then
      T619XmlList.add(Space(indentMM) + '<bn9>' + OptRec.Prp_TransmitterNo + '</bn9>)')
    else
      T619XmlList.add(Space(indentMM) + '<bn15>' + OptRec.Prp_TransmitterNo + '</bn15>');
  end;
 }
  //<trust></trust> -1 alpha, 8 numeric, example: T00000000
  //<nr4></nr4>     - 3 alpha, 6 numeric, example: AAA000000

  T619XmlList.add(Space(indentM) + '</TransmitterAccountNumber>');

  //Required (if logged in using Represent a client (RAC) application) -7 alphanumeric
  if not OptRec.Prp_RepId.IsEmpty() then
  begin
    T619XmlList.add(Space(indentM) + '<TransmitterRepID>');
    T619XmlList.add(Space(indentMM) + '<RepID>' + OptRec.Prp_TransmitterAccountRepId + '</RepID>');  //jz//20250324
    T619XmlList.add(Space(indentM) + '</TransmitterRepID>');
  End;

  //? required 8
  T619XmlList.add(Space(indentM) + '<sbmt_ref_id>' + SubmitRef + '</sbmt_ref_id>');

  //jz//20250323 - removed <<
  {
  // need code to find selected: [23][24][25] required 1 alpha
  //T619XmlList.add(Space(indentM) + '<rpt_tcd>' + DataTypeCode + '</rpt_tcd>');
  //[1] 2 alpha (MM), 6 numeric
  //T619XmlList.add(Space(indentM) + '<trnmtr_nbr>' + 'MM' +  LeftStr(OptRec.Prp_TransmitterNo,6) + '</trnmtr_nbr>'); //LeftStr(OptRec.Prp_XmitNo,6) +
  //? required 1 numeric, 1,2,3,4
  //T619XmlList.add(Space(indentM) + '<trnmtr_tcd>' + OptRec.Prp_TransmitterType + '</trnmtr_tcd>'); //OptRec.Prp_XmitCd +
  }
  //jz//20250323 - removed >>

  //[29] required 6 numeric
  T619XmlList.add(Space(indentM) + '<summ_cnt>' + '1' + '</summ_cnt>');

  //[27][28] required 1 alpha e, f
  Lang:= IfThen(not FetchElm(RetNo, 'T619_1', 28).IsEmpty(), 'F', 'E');
  T619XmlList.add(Space(indentM) + '<lang_cd>' + Lang + '</lang_cd>');

  T619XmlList.add(Space(indentM) + '<TransmitterName>'); //jz//20250323 - replaced <TRNMTR_NM>
  info:= ReplaceSpecialChar(LeftStr(OptRec.Prp_Name, 30));
  //[2] required first 30 alphanumeric
  T619XmlList.add(Space(indentMM) + '<l1_nm>' + info + '</l1_nm>');
  //20260107 Igor
  {info:= ReplaceSpecialChar(MidStr(OptRec.Prp_name, 31, 30));
  //[2] required second 30 alphanumeric
  If info > '' then
  begin
   T619XmlList.add(Space(indentMM) + '<l2_nm>' + info + '</l2_nm>');
  end;}

  T619XmlList.add(Space(indentM) + '</TransmitterName>'); //jz//20250323 - replaced </TRNMTR_NM>

  T619XmlList.add(Space(indentM) + '<TransmitterCountryCode>CAN</TransmitterCountryCode>'); //20260107 Igor

  //jz//20250323 - removed <<
  {
  T619XmlList.add(Space(indentM) + '<TRNMTR_ADDR>');
  info := ReplaceSpecialChar(LeftStr(OptRec.Prp_Street,30));
  //[3] required 1st 30 alphanumeric
  T619XmlList.add(Space(indentMM) + '<addr_l1_txt>' + info + '</addr_l1_txt>');
  //[3] required 2nd 30 alphanumeric
  info := ReplaceSpecialChar(MidStr(OptRec.Prp_Street,31,30));
  If info > '' then
  begin
  T619XmlList.add(Space(indentMM) + '<addr_l2_txt>' + info + '</addr_l2_txt>');
  end;
  info := ReplaceSpecialChar(LeftStr(OptRec.Prp_City,28));
  //[30] required 28 alphanumeric
  T619XmlList.add(Space(indentMM) + '<cty_nm>' + info + '</cty_nm>');
  //[4] required 2 alpha
  T619XmlList.add(Space(indentMM) + '<prov_cd>' + LeftStr(OptRec.Prp_Prov,2) + '</prov_cd>');
  //? required 3 alphanumeric
  T619XmlList.add(Space(indentMM) + '<cntry_cd>' + OptRec.Prp_countr + '</cntry_cd>');
  //[5] required 10 alphanumeric
  T619XmlList.add(Space(indentMM) + '<pstl_cd>' + LeftStr(FixPostal(OptRec.Prp_Postal),10) + '</pstl_cd>');
  T619XmlList.add(Space(indentM) + '</TRNMTR_ADDR>');
  }
  //jz//20250323 - removed >>

  T619XmlList.add(Space(indentM) + '<CNTC>');

  info:= ReplaceSpecialChar(LeftStr(OptRec.Prp_ContactName, 22));
  //[8] required 22 alphanumeric, omit titles
  T619XmlList.add(Space(indentMM) + '<cntc_nm>' + info + '</cntc_nm>');

  //[6] - first 3 numbers
  T619XmlList.add(Space(indentMM) + '<cntc_area_cd>' + LeftStr(OptRec.Prp_Area,3) + '</cntc_area_cd>');

  //[6] - last 7 numbers 3 then '-' then last 4  - needs validation on input
  T619XmlList.add(Space(indentMM) + '<cntc_phn_nbr>' + RemoveChar(LeftStr(OptRec.Prp_Tel, 8), ' ') + '</cntc_phn_nbr>');

  //?Transmitter Contact Extension Number. Not required - Up to 12 numeric.
  //T619XmlList.add(Space(indentM) + '<cntc_extn_nbr>' + LeftStr(FetchElm(RetNo,'T619_1',5))' + '</cntc_extn_nbr>';

  // 20130402
  T619XmlList.add(Space(indentMM) + '<cntc_email_area>' + AllTrim(LeftStr(OptRec.Prp_EMail, 60)) + '</cntc_email_area>');
  //<sec_cntc_email_area></sec_cntc_email_area> //Transmitter Second Contact Email. NOT Required parameter - Up to 60 alphanumeric. //20260107 Igor
  T619XmlList.add(Space(indentM) + '</CNTC>');
  T619XmlList.add(Space(indent) + '</T619>');
end;
//20260107 Igor <<<

end.
