unit TF_2026dataGen;

interface
//20250519 Igor >>>
uses Classes
  , vtMulti
; //,Dialogs,SysUtils,TF_2026declare,TF_2026trimstr;
//20250519 Igor <<<
const
 indent = 3;
 indentM = 6;
 indentMM = 9;
 indentMMM = 12;
 indentMMMM = 15;
 indentMMMMM = 18;
//20250519 Igor >>>
 Tindent = 4;
 TindentM = 8;
 TindentMM = 12;
 TindentMMM = 16;
 TindentMMMM = 20;
 TindentMMMMM = 24;
 TindentMMMMMM = 28;
 TindentMMMMMMM = 32;
//20250519 Igor <<<
 Type
  AT5018Rec  = Record
    RecipLastName               : String[20];
    RecipFirstName              : String[12];
    RecipInitial                : String[1];
    RecipSIN                    : String[9];
    RecipAccountNumber          : String[15];
    RecipCorpPartnershipNameln1 : String[30];
    RecipCorpPartnershipNameln2 : String[30];
    RecipTypeCode               : String[1];
    RecipAddressLn1             : String[30];
    RecipAddressLn2             : String[30];
    RecipCity                   : String[28];
    RecipProv                   : String[2];
    RecipCountryCode            : String[3];
    RecipPostalCode             : String[10];
    AccountNumber               : String[15];
    SubContractorPayments       : String[12];
    RecipPartnershipFIN         : String[9];
    ReportTypeCode              : String[1];
    //AccountNumber               : String[15];
    PayerNameLn1                : String[30];
    PayerNameLn2                : String[30];
    PayerNameLn3                : String[30];
    PayerAddressLn1             : String[30];
    PayerAddressLn2             : String[30];
    PayerCity                   : String[28];
    PayerProvince               : String[2];
    PayerCountryCode            : String[3];
    PayerPostalCode             : String[10];
    ContactName                 : String[22];
    ContactAreaCode             : String[3];
    ContactTelephone            : String[8];
    ContactExtension            : String[5];
    PeriodEndingDay             : String[2];
    PeriodEndingmonth           : String[2];
    PeriodEndingYear            : String[4];
    TotalSlipRecords            : String[7];
    TotalSubContractorPayments  : String[14];
    //ReportTypeCode              : String[1];
 end; //type AT5018Rec

 //20180314 Igor >>>
 Type
  ANR4Rec  = Record
    nr_acct_nbr                                 : String[9];
    l1_nm                                       : String[30];
    l2_nm                                       : String[30];
    l3_nm                                       : String[30];
    addr_l1_txt                                 : String[30];
    addr_l2_txt                                 : String[30];
    cty_nm                                      : String[28];
    prov_cd                                     : String[2];
    cntry_cd                                    : String[3];
    pstl_cd                                     : String[10];
    cntc_nm                                     : String[22];
    cntc_area_cd                                : String[3];
    cntc_phn_nbr                                : String[3];
    cntc_extn_nbr                               : String[5];
    tx_yr                                       : String[4];
    slp_cnt                                     : String[7];
    rpt_tcd                                     : String[1];
    fileramendmentnote                          : String;
    tot_gro_1_incamt                            : String[13];
    tot_nr_tx_1_amt                             : String[13];
    tot_gro_2_incamt                            : String[13];
    tot_nr_tx_2_amt                             : String[13];
    tot_nrpt_incamt                             : String[13];
    tot_nr_nrpt_tx_amt                          : String[13];
  End;

 Type
  ANR4SlipRec  = Record
    is_individual                               : boolean;
    l1_nm                                       : String[35];
    l2_nm                                       : String[35];
    snm                                         : String[20];
    gvn_nm                                      : String[12];
    init                                        : String[1];
    sec_snm                                     : String[20];
    sec_gvn_nm                                  : String[12];
    sec_init                                    : String[1];
    addr_l1_txt                                 : String[30];
    addr_l2_txt                                 : String[30];
    cty_nm                                      : String[28];
    ste_cd                                      : String[2];
    cntry_cd                                    : String[3];
    fgn_pstl_cd                                 : String[10];
    tx_cntry_cd                                 : String[3];
    fssn_nbr                                    : String[20];
    nr_acct_nbr                                 : String[9];
    rcpnt_tcd                                   : String[1];
    payr_nbr                                    : String[20];
    inc_1_tcd                                   : String[2];
    crcy_1_cd                                   : String[3];
    tx_xmpt_1_cd                                : String[1];
    inc_2_tcd                                   : String[2];
    crcy_2_cd                                   : String[3];
    tx_xmpt_2_cd                                : String[1];
    gro_1_incamt                                : String[11];
    nr_tx_1_amt                                 : String[11];
    gro_2_incamt                                : String[11];
    nr_tx_2_amt                                 : String[11];
    rpt_tcd                                     : String[1];
  end;
 //20180314 Igor <<<

 //20240305 Igor >>>
 type AT5013Rec = record
   SummaryFilerAccountNumber                      : String;
   FilerNameLine1Text                             : String;
   FilerNameLine2Text                             : String;
   FilerNameLine3Text                             : String;
   AddressLine1Text                               : String;
   AddressLine2Text                               : String;
   CityName                                       : String;
   ProvinceStateCode                              : String;
   CountryCode                                    : String;
   PostalZipCode                                  : String;
   PartnershipReturnNomineeIndicationCode         : String;
   NomineeAgentAccountNumber                      : String;
   NomineeAgentName                               : String;
   TaxShelterIdentificationNumber                 : String;
   ContactName                                    : String;
   ContactAreaCode                                : String;
   ContactPhoneNumber                             : String;
   ContactExtensionNumber                         : String;
   FiscalPeriodStartYear                          : String;
   FiscalPeriodStartMonth                         : String;
   FiscalPeriodStartDay                           : String;
   FiscalPeriodEndYear                            : String;
   FiscalPeriodEndMonth                           : String;
   FiscalPeriodEndDay                             : String;
   TotalSlipCount                                 : String;
   SummaryReportTypeCode                          : String;
   fileramendmentnote                             : String;
   TotalLimitedPartnerBusinessIncomeAmount        : String;
   TotalNetBusinessIncomeAmount                   : String;
   TotalCapitalGainLossAmount                     : String;
   TotalCapitalCostAllowanceAmount                : String;
   TotalCanadianForeignNetRentalIncomeLossAmount  : String;
   TotalNetProfessionalIncomeLossAmount           : String;
   TotalRenouncedCanadianExplorationExpenseAmount : String;
   TotalRenouncedCanadianDevelopmentExpenseAmount : String;
   TotalITCQualifyingExpensesAmount               : String;
   TotalCarryingChargesAmount                     : String;
 end;

 type AT5013FinancialDetails = record
   FinancialDetailsFieldCode                      : String;
   FinancialDetailsJurisdictionCode               : String;
   FinancialDetailsFieldAmount                    : String;
 end;

 type AT5013OtherInformation = record
   OtherInformationFieldCode                      : String;
   OtherInformationJurisdictionCode               : String;
   OtherInformationFieldText                      : String;
 end;

 type AT5013SlipRec = record
   FamilyName                                     : String;
   GivenName                                      : String;
   NameInitialText                                : String;
   RecipientSIN                                   : String;
   BusinessNameLine1Text                          : String;
   BusinessNameLine2Text                          : String;
   RecipientBusinessNumber                        : String;
   RecipientTrustAccountNumber                    : String;
   AddressLine1Text                               : String;
   AddressLine2Text                               : String;
   CityName                                       : String;
   ProvinceStateCode                              : String;
   CountryCode                                    : String;
   PostalZipCode                                  : String;
   SlipFilerAccountNumber                         : String;
   SlipReportTypeCode                             : String;
   PartnershipPartnerCode                         : String;
   PartnerResidenceCountryCode                    : String;
   RecipientTypeCode                              : String;
   PartnerOwnershipPercent                        : String;
   LimitedPartnerBusinessIncomeAmount             : String;
   NetBusinessIncomeAmount                        : String;
   CapitalGainLossAmount                          : String;
   CapitalCostAllowanceAmount                     : String;
   T5013SlipFinancialDetails                      : TArray<AT5013FinancialDetails>;
   T5013SlipOtherInformation                      : TArray<AT5013OtherInformation>;
   procedure AddFinancialDetail(AFieldCode, AJurisdictionCode, AFieldAmount: string);
   procedure AddOtherInformation(AFieldCode, AJurisdictionCode, AFieldText: string);
 end;
 //20240305 Igor <<<

 //20250519 Igor >>>
type
  AT3010Rec = record
    VendorIdentifier: string;
    SoftwareProductIdentifier: string;
    FilingPeriodEnd: string;
    BN15: string;
    FormVersion: string;
    WebAddress: string;
    A1: string;
    A1ParentOrgName: string;
    A1ParentOrgBN: string;
    A2: string;
    A3: string;
    C1Activity: string;
    NewPrograms: string;
    OngoingPrograms: string;
    C3: string;
    C4: string;
    IsC6_2500: string;
    IsC6_2510: string;
    IsC6_2530: string;
    IsC6_2540: string;
    IsC6_2550: string;
    IsC6_2560: string;
    IsC6_2570: string;
    IsC6_2575: string;
    IsC6_2580: string;
    IsC6_2590: string;
    IsC6_2600: string;
    IsC6_2610: string;
    IsC6_2620: string;
    IsC6_2630: string;
    IsC6_2640: string;
    IsC6_2650: string;
    C6_OtherSpecify: string;
    C7: string;
    C7a: string;
    C7b: string;
    IsC7c_2730: string;
    IsC7c_2740: string;
    IsC7c_2750: string;
    IsC7c_2760: string;
    IsC7c_2770: string;
    IsC7c_2780: string;
    C7c_OtherSpecify: string;
    C7d: string;
    C8: string;
    C9: string;
    C10: string;
    C11: string;
    C12: string;
    C13: string;
    C14: string;
    C15: string;
    C16_5840: string;
    C16_5841: string;
    C16_5842: string;
    C16_5843: string;
    C17_5850: string;
    C18_5860: string;
    C18_5861: string;
    C18_5862: string;
    C18_5863: string;
    C18_5864: string;
    SectionDOrSchedule6: string;
    D1: string;
    D2_4050: string;
    D2_4400: string;
    D3_4490: string;
    D3_4565: string;
    D4_FinancialInfo_Code_4200_Amt: string;
    D4_FinancialInfo_Code_4350_Amt: string;
    D4_FinancialInfo_Code_4500_Amt: string;
    D4_FinancialInfo_Code_4510_Amt: string;
    D4_FinancialInfo_Code_4530_Amt: string;
    D4_FinancialInfo_Code_4570_Amt: string;
    D4_FinancialInfo_Code_4571_Amt: string;
    D4_FinancialInfo_Code_4575_Amt: string;
    D4_FinancialInfo_Code_4630_Amt: string;
    D4_FinancialInfo_Code_4640_Amt: string;
    D4_FinancialInfo_Code_4650_Amt: string;
    D4_FinancialInfo_Code_4700_Amt: string;
    D4_FinancialInfo_Code_4860_Amt: string;
    D4_FinancialInfo_Code_4810_Amt: string;
    D4_FinancialInfo_Code_4920_Amt: string;
    D4_FinancialInfo_Code_4950_Amt: string;
    D4_FinancialInfo_Code_5000_Amt: string;
    D4_FinancialInfo_Code_5010_Amt: string;
    D4_FinancialInfo_Code_5045_Amt: string;
    D4_FinancialInfo_Code_5050_Amt: string;
    D4_FinancialInfo_Code_5100_Amt: string;
    SectionE_Name: string;
    SectionE_Position: string;
    SectionE_Date: string;
    SecE_Telephone: string;
    SecF_F2_ContactName: string;
    SecF_F2_CompanyName: string;
    SecF_F2_Address1: string;
    SecF_F2_Address2: string;
    SecF_F2_City: string;
    SecF_F2_ProvinceState: string;
    SecF_F2_PostalZipCode: string;
    //SecF_F2_CountryCode: string; //20250529 Igor
    SecF_F2_Telephone: string;
    SecF_F2_SameAsSectionE: string;
    Schedule1_1: string;
    Schedule1_2: string;
    Schedule1_Q3_111: string;
    Schedule1_Q3_112: string;
    Schedule1_4: string;
    Schedule1_5: string;
    Schedule2_1_200: string;
    Schedule2_2_210: string;
    Sch2_2_210_FA_Name1: string;
    Sch2_2_210_FA_CountryCode1: string;
    Sch2_2_210_FA_Amount1: string;
    Sch2_2_210_FA_Name2: string;
    Sch2_2_210_FA_CountryCode2: string;
    Sch2_2_210_FA_Amount2: string;
    Sch2_2_210_FA_Name3: string;
    Sch2_2_210_FA_CountryCode3: string;
    Sch2_2_210_FA_Amount3: string;
    Sch2_2_210_FA_Name4: string;
    Sch2_2_210_FA_CountryCode4: string;
    Sch2_2_210_FA_Amount4: string;
    Sch2_2_210_FA_Name5: string;
    Sch2_2_210_FA_CountryCode5: string;
    Sch2_2_210_FA_Amount5: string;
    Sch2_2_3_CountryCode1: string;
    Sch2_2_3_CountryCode2: string;
    Sch2_2_3_CountryCode3: string;
    Sch2_2_3_CountryCode4: string;
    Sch2_2_3_CountryCode5: string;
    Sch2_2_3_CountryCode6: string;
    Sch2_2_3_CountryCode7: string;
    Sch2_2_3_CountryCode8: string;
    Sch2_2_3_CountryCode9: string;
    Sch2_2_3_CountryCode10: string;
    Schedule2_4: string;
    Schedule2_4_230: string;
    Schedule2_5: string;
    Schedule2_6: string;
    Schedule2_7: string;
    Sch2_7_Item1: string;
    Sch2_7_Value1: string;
    Sch2_7_Destination1: string;
    Sch2_7_CountryCode1: string;
    Sch2_7_Item2: string;
    Sch2_7_Value2: string;
    Sch2_7_Destination2: string;
    Sch2_7_CountryCode2: string;
    Sch2_7_Item3: string;
    Sch2_7_Value3: string;
    Sch2_7_Destination3: string;
    Sch2_7_CountryCode3: string;
    Sch2_7_Item4: string;
    Sch2_7_Value4: string;
    Sch2_7_Destination4: string;
    Sch2_7_CountryCode4: string;
    Sch2_7_Item5: string;
    Sch2_7_Value5: string;
    Sch2_7_Destination5: string;
    Sch2_7_CountryCode5: string;
    Schedule3_1a: string;
    Sch3_1b_305_Count: string;
    Sch3_1b_310_Count: string;
    Sch3_1b_315_Count: string;
    Sch3_1b_320_Count: string;
    Sch3_1b_325_Count: string;
    Sch3_1b_330_Count: string;
    Sch3_1b_335_Count: string;
    Sch3_1b_340_Count: string;
    Sch3_1b_345_Count: string;
    Schedule3_2a: string;
    Schedule3_2b: string;
    Schedule3_3: string;
    Schedule4_1_Name1: string;
    Schedule4_1_AtArmsLength1: string;
    Schedule4_1_Name2: string;
    Schedule4_1_AtArmsLength2: string;
    Schedule4_1_Name3: string;
    Schedule4_1_AtArmsLength3: string;
    Schedule4_1_Name4: string;
    Schedule4_1_AtArmsLength4: string;
    Schedule4_2_Name1: string;
    Schedule4_2_Value1: string;
    Schedule4_2_Type1: string;
    Schedule4_2_Name2: string;
    Schedule4_2_Value2: string;
    Schedule4_2_Type2: string;
    Schedule4_2_Name3: string;
    Schedule4_2_Value3: string;
    Schedule4_2_Type3: string;
    Schedule4_2_Name4: string;
    Schedule4_2_Value4: string;
    Schedule4_2_Type4: string;
    Schedule5_1_Kind_500: string;
    Schedule5_1_Kind_505: string;
    Schedule5_1_Kind_510: string;
    Schedule5_1_Kind_515: string;
    Schedule5_1_Kind_520: string;
    Schedule5_1_Kind_525: string;
    Schedule5_1_Kind_530: string;
    Schedule5_1_Kind_535: string;
    Schedule5_1_Kind_540: string;
    Schedule5_1_Kind_545: string;
    Schedule5_1_Kind_550: string;
    Schedule5_1_Kind_555: string;
    Schedule5_1_Kind_560: string;
    Schedule5_1_OtherSpecify: string;
    Schedule5_2_580: string;
    Schedule6_4020: string;
    Schedule6_4100_Value: string;
    Schedule6_4101_Value: string;
    Schedule6_4102_Value: string;
    Schedule6_4110_Value: string;
    Schedule6_4120_Value: string;
    Schedule6_4130_Value: string;
    Schedule6_4140_Value: string;
    Schedule6_4150_Value: string;
    Schedule6_4155_Value: string;
    Schedule6_4157_Value: string;
    Schedule6_4158_Value: string;
    Schedule6_4160_Value: string;
    Schedule6_4165_Value: string;
    Schedule6_4166_Value: string;
    Schedule6_4170_Value: string;
    Schedule6_4190_Value: string;
    Schedule6_4200_Value: string;
    Schedule6_4250_Value: string;
    Schedule6_4300_Value: string;
    Schedule6_4310_Value: string;
    Schedule6_4320_Value: string;
    Schedule6_4330_Value: string;
    Schedule6_4350_Value: string;
    Schedule6_4500_Value: string;
    Schedule6_5610_Value: string;
    Schedule6_4510_Value: string;
    Schedule6_4530_Value: string;
    Schedule6_4540_Value: string;
    Schedule6_4550_Value: string;
    Schedule6_4560_Value: string;
    Schedule6_4571_Value: string;
    Schedule6_4575_Value: string;
    Schedule6_4576_Value: string;
    Schedule6_4577_Value: string;
    Schedule6_4580_Value: string;
    Schedule6_4590_Value: string;
    Schedule6_4600_Value: string;
    Schedule6_4610_Value: string;
    Schedule6_4620_Value: string;
    Schedule6_4630_Value: string;
    Schedule6_4640_Value: string;
    Schedule6_4650_Value: string;
    Schedule6_4700_Value: string;
    Schedule6_Revenue_4655: string;
    Schedule6_4800_Value: string;
    Schedule6_4810_Value: string;
    Schedule6_4820_Value: string;
    Schedule6_4830_Value: string;
    Schedule6_4840_Value: string;
    Schedule6_4850_Value: string;
    Schedule6_4860_Value: string;
    Schedule6_4870_Value: string;
    Schedule6_4880_Value: string;
    Schedule6_4890_Value: string;
    Schedule6_4891_Value: string;
    Schedule6_4900_Value: string;
    Schedule6_4910_Value: string;
    Schedule6_4920_Value: string;
    Schedule6_4950_Value: string;
    Schedule6_5000_Value: string;
    Schedule6_5010_Value: string;
    Schedule6_5020_Value: string;
    Schedule6_5040_Value: string;
    Schedule6_5045_Value: string;
    Schedule6_5050_Value: string;
    Schedule6_5100_Value: string;
    Schedule6_Expenditures_4930: string;
    Schedule6_5500_Value: string;
    Schedule6_5510_Value: string;
    Schedule6_5750_Value: string;
    Schedule6_5900_Value: string;
    Schedule6_5910_Value: string;
    Schedule8_810_Value: string;
  end;

type
  AT1235InfoRec = record
    PInf_LastName: string;
    PInf_FirstName: string;
    PInf_Initial: string;
    PInf_Term_StartDate: string;
    PInf_Term_EndDate: string;
    PInf_Position: string;
    PInf_AtArmsLength: string;
    CInf_Address1: string; //20250529 Igor
    CInf_Address2: string; //20250529 Igor
    CInf_City: string;
    CInf_PostalZipCode: string;
    CInf_Telephone: string;
    CInf_DateOfBirth: string;
  end;

type
  AT1235SlipRec = record
    TotalNumberCharityOfficials: string;
    T1235SlipDetails: TArray<AT1235InfoRec>;

    procedure AddDetailInfo(aRetNo, aFormIndex: Integer; aPInf_LastNameId, aPInf_FirstNameId, aPInf_InitialId, aPInf_Term_StartDateId, aPInf_Term_EndDateId, aPInf_PositionId,
                            aPInf_AtArmsLengthYesId, aPInf_AtArmsLengthNoId, aCInf_AddressId, aCInf_CityId, aProvTerrId, aCInf_PostalZipCodeId, aCInf_TelephoneId, aCInf_DateOfBirthId: Integer);
  end;

type
  AT1236InfoRec = record
    OrganizationName: string;
    CharityIndicationCode: string;
    BusinessIdentifier: string;
    TotalAmount: string;
    CashAmount: string;
    NonCashAmount: string;
    PoliticalActivityUsage: string;
    PoliticalActivityUsageAmount: string;
    MunicipalityName: string;
    ProvinceName: string;
    CountryCode: string;
  end;

type
  AT1236SlipRec = record
    QualifiedDoneeCount: string;
    T1236SlipDetails: TArray<AT1236InfoRec>;

    procedure AddDetailInfo(aRetNo, aFormIndex: Integer; aOrganizationNameId, aCharityIndicationCodeYesId, aCharityIndicationCodeNoId, aBusinessIdentifierId, aMunicipalityNameId, aProvinceNameId, aCountryCodeId, aNonCashAmountId, TotalAmountId: Integer);
  end;

type
  AT1441InfoRec = record
    RecipientNAme: string;
    GrantPurpose: string;
    NonCashAmountDisbursed: string;
    CashAmountDisbursed: string;
    Country: string;
  end;

type
  AT1441SlipRec = record
    Count: string;
    T1441SlipDetails: TArray<AT1441InfoRec>;

    procedure AddDetailInfo(aRetNo, aFormIndex: Integer; aRecipientNAmeId, aGrantPurposeId, aNonCashAmountDisbursedId, aCashAmountDisbursedId, aCountryLine1Id, aCountryLine2Id: Integer);
  end;

type
  AT2081SecFRec = record
    Index: string;
    Year: string;
    Step1_Percentage: string;
    Step2_Percentage: string;
    Step3_Percentage: string;
    Step4_Percentage: string;
    Step5_Percentage: string;
    Step6_Percentage: string;
    Step7_Percentage: string;
  end;

type
  AT2081P2SecARec = record
    Percentage: string;
		Amount: string;
		Acquisition: string;
		Disposition: string;
  end;

type
  AT2081P2SecBRec = record
    NameOfPerson: string;
    Percentage: string;
		Amount: string;
		Acquisition: string;
		Disposition: string;
  end;

type
  AT2081Rec = record
    CorporationName: string;
		ClassOfShares: string;
    TotalIssuedShares: string;
    ShareValue: string;
    SharesListedOnStockExchange: string;
    SecB_Percentage905: string;
		SecB_Percentage910: string;
    SecB_Percentage915: string;
    SecB_Percentage920: string;
    SecC_Percentage925: string;
		SecC_Percentage930: string;
    SecC_Percentage935: string;
    SecC_Percentage940: string;
    SecD_PercentageBelow945: string;
		SecD_PercentageBelow950: string;
		SecD_PercentageBelow955: string;
		SecD_PercentageGreater941: string;
    SecD_PercentageGreater945: string;
    SecD_PercentageGreater946: string;
    SecD_PercentageGreater947: string;
    SecD_PercentageGreater948: string;
    SecD_PercentageGreater949: string;
    SecD_PercentageGreater950: string;
    SecD_PercentageGreater955: string;
    SecE_Percentage960: string;
    SecE_Percentage965: string;
    SecE_Percentage970: string;
    SecE_Percentage975: string;

    T2081SecFInfo: TArray<AT2081SecFRec>;

    ExcessTransactionsPresent: string;
    Part2SecAInfo: TArray<AT2081P2SecARec>;
    Part2SecBInfo: TArray<AT2081P2SecBRec>;

    procedure AddSecFInfo(aRetNo, aFormIndex: Integer; aIndexId, aYearId, aStep1_PercentageId, aStep2_PercentageId, aStep3_PercentageId, aStep4_PercentageId,
                          aStep5_PercentageId, aStep6_PercentageId, aStep7_PercentageId: Integer);
    procedure AddP2SecAInfo(aRetNo, aFormIndex: Integer; aPercentageId, aAmountId, aAcquisitionId, aDispositionId: Integer);
    procedure AddP2SecBInfo(aRetNo, aFormIndex: Integer; aNameOfPersonId, aPercentageId, aAmountId, aAcquisitionId, aDispositionId: Integer);
  end;
 //20250519 Igor <<<

 procedure addSubmissionTag(tag:String;Var XmlList:tstringlist);
 Procedure PrepareT5018Rec(RetNo:Integer;FName:String);
 Procedure PrepareT5018SlipRec(RetNo:Integer;FName:String);
 Procedure createT5018XML(RetNo:Integer;DataTypeCode:String;SubmitRef:String;var T5018XmlList:tstringlist);

 procedure PrepareT619(var T619XmlList: TStringList; RetNo: Integer; DataTypeCode: string; SubmitRef: string; aFormName: string = ''); //20260107 Igor

 //20180314 Igor >>>
 Procedure PrepareNR4SlipRec(RetNo: Integer; FName: String);
 Procedure PrepareNR4Rec(RetNo: Integer; FName: String);
 Procedure createNR4XML(RetNo: Integer; DataTypeCode: String; SubmitRef: String; var NR4XmlList: TStringList);
 //20180314 Igor <<<
 Function ReplaceSpecialChar(info:String):String;
 Function FixPostal(s:String):String;

 //20240305 Igor >>>
 Function GetT5013Rec(RetNo: Integer; FName: String): AT5013Rec;
 Function GetT5013SlipRec(RetNo: Integer; FName: String): AT5013SlipRec;
 Procedure createT5013XML(RetNo: Integer; DataTypeCode: String; SubmitRef: String; var AXmlList: TStringList);
 //20240305 Igor <<<

 //20250519 Igor >>>
 function GetT3010YesNoValue(aRetNo: Integer; aFieldIndex: Integer; aElmYes, aElmNo: integer): string;
 procedure addT3010SubmissionTag(aTag: String; Var aXmlList: tstringlist);
 function GetT3010Rec(aRetNo: Integer; aFName: String): AT3010Rec;
 procedure createT3010XML(aRetNo: Integer; aDataTypeCode: String; aSubmitRef: String; var aXmlList: TStringList);
 function GetT1235SlipRec(aRetNo: Integer; aFName: String): AT1235SlipRec;
 function GetT1236SlipRec(aRetNo: Integer; aFName: String): AT1236SlipRec;
 function GetT1441SlipRec(aRetNo: Integer; aFName: String): AT1441SlipRec;
 function GetT2081Rec(aRetNo: Integer; aFName: String): AT2081Rec;
 //20250519 Igor <<<
 
var
T5018Rec : AT5018Rec;
//20180314 Igor >>>
NR4Rec      : ANR4Rec;
NR4SlipRec  : ANR4SlipRec;

//20160316 CON  gloal variables
 ContName     : String[22];
 ContArea     : String[3];
 ContPhone    : String[10];
 ContExt      : String[5];

//20180314 Igor <<<

implementation

uses //Classes,Dialogs,
  SysUtils,
  vtCommon,
  TF_2026,TF_2026declare,TF_2026trimstr,
  vtTrimStr, vtShared;

Procedure PrepareNR4SlipRec(RetNo: Integer; FName: String); //20180314 Igor

  function Checked(AValue: string): boolean;
  begin
    Result := SameText(AValue, 'X');
  end;

begin
  with NR4SlipRec do
  begin
    is_individual := (FetchElm(RetNo, FName, 2) = '1') or (FetchElm(RetNo, FName, 2) = '2');
    if is_individual then
    begin
      snm          := FetchElm(RetNo, FName, 16);
      gvn_nm       := FetchElm(RetNo, FName, 17);
      init         := FetchElm(RetNo, FName, 18);
      sec_snm      := FetchElm(RetNo, FName, 19);
      sec_gvn_nm   := FetchElm(RetNo, FName, 20);
      sec_init     := FetchElm(RetNo, FName, 21);
    end
    else
    begin
      l1_nm        := FetchElm(RetNo, FName, 16);
      l2_nm        := FetchElm(RetNo, FName, 17);
    end;

    addr_l1_txt  := FetchElm(RetNo, FName, 22);
    addr_l2_txt  := FetchElm(RetNo, FName, 23);
    cty_nm       := FetchElm(RetNo, FName, 24);
    ste_cd       := FetchElm(RetNo, FName, 25);
    cntry_cd     := FetchElm(RetNo, FName, 27);
    fgn_pstl_cd  := FetchElm(RetNo, FName, 26);

    tx_cntry_cd  := FetchElm(RetNo, FName, 3);
    fssn_nbr     := FetchElm(RetNo, FName, 5);
    nr_acct_nbr  := FetchElm(RetNo, FName, 35);
    rcpnt_tcd    := FetchElm(RetNo, FName, 2);
    payr_nbr     := FetchElm(RetNo, FName, 4);
    inc_1_tcd    := FetchElm(RetNo, FName, 6);
    crcy_1_cd    := FetchElm(RetNo, FName, 7);
    tx_xmpt_1_cd := FetchElm(RetNo, FName, 10);
    inc_2_tcd    := FetchElm(RetNo, FName, 11);
    crcy_2_cd    := FetchElm(RetNo, FName, 12);
    tx_xmpt_2_cd := FetchElm(RetNo, FName, 15);
    gro_1_incamt := FetchElm(RetNo, FName, 8);
    nr_tx_1_amt  := FetchElm(RetNo, FName, 9);
    gro_2_incamt := FetchElm(RetNo, FName, 13);
    nr_tx_2_amt  := FetchElm(RetNo, FName, 14);
    if Checked(FetchElm(RetNo, FName, 101)) then
      rpt_tcd      := 'O'
    else if Checked(FetchElm(RetNo, FName, 102)) then
      rpt_tcd      := 'A'
    else if Checked(FetchElm(RetNo, FName, 103)) then
      rpt_tcd      := 'C'
    else
      rpt_tcd      := '';
  end;
end;

Procedure PrepareNR4Rec(RetNo: Integer; FName: String); //20180314 Igor
begin
  with NR4Rec do
  begin
    nr_acct_nbr        := FetchElm(RetNo, FName, 3);
    l1_nm              := LeftStr(FetchElm(RetNo, FName, 4), 30);
    l2_nm              := MidStr(FetchElm(RetNo, FName, 4), 31, 30);
    l3_nm              := '';
    addr_l1_txt        := FetchElm(RetNo, FName, 5);
    addr_l2_txt        := FetchElm(RetNo, FName, 6);
    cty_nm             := '';
    prov_cd            := FetchElm(RetNo, FName, 7);
    cntry_cd           := FetchElm(RetNo, FName, 26);
    pstl_cd            := FetchElm(RetNo, FName, 8);

    //20180316 CON
    cntc_nm            := ContName; //FetchElm(RetNo, FName, 20);
    cntc_area_cd       := ContArea; //FetchElm(RetNo, FName, 21);
    cntc_phn_nbr       := ContPhone; //FetchElm(RetNo, FName, 22);
    cntc_extn_nbr      := ContExt; //FetchElm(RetNo, FName, 23);


    tx_yr              := FetchElm(RetNo, FName, 1);
    slp_cnt            := FetchElm(RetNo, FName, 9);
    rpt_tcd            := ''; // filled later based on all slips - if there is one ammended, then A else O
    fileramendmentnote := '';

    tot_gro_1_incamt   := ''; // filled later - sum of all box 16 in NR4Slip
    tot_nr_tx_1_amt    := ''; // filled later - sum of all box 17 in NR4Slip
    tot_gro_2_incamt   := ''; // filled later - sum of all box 26 in NR4Slip
    tot_nr_tx_2_amt    := ''; // filled later - sum of all box 27 in NR4Slip
    tot_nrpt_incamt    := FetchElm(RetNo, FName, 12);
    tot_nr_nrpt_tx_amt := FetchElm(RetNo, FName, 13);
  end;
end;

Procedure createNR4XML(RetNo: Integer; DataTypeCode: String; SubmitRef: String; var NR4XmlList: TStringList); //20180314 Igor
var I: integer;
    FHasAmmended: boolean;
    Ftot_gro_1_incamt,
    Ftot_nr_tx_1_amt,
    Ftot_gro_2_incamt,
    Ftot_nr_tx_2_amt: currency;

  procedure AddBeginTag(AIndent: integer; AName: string);
  begin
    NR4XmlList.Add(Space(AIndent) + '<'+ AName +'>');
  end;

  procedure AddEndTag(AIndent: integer; AName: string);
  begin
    NR4XmlList.Add(Space(AIndent) + '</'+ AName +'>');
  end;

  procedure AddTag(AIndent: integer; AName, AValue: string);
  begin
    if SameText(Trim(AValue), '') then Exit;
    if SameText(Trim(AValue), '') then
      NR4XmlList.Add(Space(AIndent) + '<'+ AName +'/>')
    else
      NR4XmlList.Add(Space(AIndent) + '<'+ AName +'>' + ReplaceSpecialChar(AValue) + '</'+ AName +'>');
  end;

begin
  addSubmissionTag('BEGIN', NR4XmlList);

  PrepareT619(NR4XmlList, RetNo, DataTypeCode, SubmitRef, 'NR4'); //20260107 Igor

  PrepareNR4Rec(RetNo,'NR4SUM');

  AddBeginTag(indent, 'Return');
  AddBeginTag(indent, 'NR4');

  FHasAmmended := false;
  Ftot_gro_1_incamt   := 0.0;
  Ftot_nr_tx_1_amt    := 0.0;
  Ftot_gro_2_incamt   := 0.0;
  Ftot_nr_tx_2_amt    := 0.0;


  for I := 0 to FList.Count - 1 do
  begin
    FRec := FList.Items[I];
    If (FRec.FormName = 'NR4DET') {and (Vl(FetchElmFNo(RetNo, FRec.FormNo, 2)) > 0)} then
    Begin
      AddBeginTag(indentM, 'NR4Slip');
      PrepareNR4SlipRec(RetNo, FRec.FormName + FRec.FormInst);
      with NR4SlipRec do
      begin
        if is_individual then
        begin
          AddBeginTag(indentMM, 'RCPNT_NM');
          AddTag(indentMMM, 'snm', snm);
          AddTag(indentMMM, 'gvn_nm', gvn_nm);
          AddTag(indentMMM, 'init', init);
          AddEndTag(indentMM, 'RCPNT_NM');
          //20260220 Igor >>>
          if (sec_snm <> '') or (sec_gvn_nm <> '') or (sec_init <> '') then
          begin
            AddBeginTag(indentMM, 'SEC_RCPNT_NM');
            AddTag(indentMMM, 'sec_snm', sec_snm);
            AddTag(indentMMM, 'sec_gvn_nm', sec_gvn_nm);
            AddTag(indentMMM, 'sec_init', sec_init);
            AddEndTag(indentMM, 'SEC_RCPNT_NM');
          end;
        end else
        //20260220 Igor <<<
        begin
          AddBeginTag(indentMM, 'ENTPRS_NM');
          AddTag(indentMMM, 'l1_nm', l1_nm);
          AddTag(indentMMM, 'l2_nm', l2_nm);
          AddEndTag(indentMM, 'ENTPRS_NM');
        end;

        AddBeginTag(indentMM, 'RCPNT_ADDR');
        AddTag(indentMMM, 'addr_l1_txt', addr_l1_txt);
        AddTag(indentMMM, 'addr_l2_txt', addr_l2_txt);
        AddTag(indentMMM, 'cty_nm', cty_nm);
        AddTag(indentMMM, 'ste_cd', ste_cd);
        AddTag(indentMMM, 'cntry_cd', cntry_cd);
        AddTag(indentMMM, 'fgn_pstl_cd', fgn_pstl_cd);
        AddEndTag(indentMM, 'RCPNT_ADDR');

        AddTag(indentMM, 'tx_cntry_cd', tx_cntry_cd);
        AddTag(indentMM, 'fssn_nbr', fssn_nbr);
        AddTag(indentMM, 'nr_acct_nbr', nr_acct_nbr);
        AddTag(indentMM, 'rcpnt_tcd', rcpnt_tcd);
        AddTag(indentMM, 'payr_nbr', payr_nbr);
        AddTag(indentMM, 'inc_1_tcd', inc_1_tcd);
        AddTag(indentMM, 'crcy_1_cd', crcy_1_cd);
        AddTag(indentMM, 'tx_xmpt_1_cd', tx_xmpt_1_cd);
        AddTag(indentMM, 'inc_2_tcd', inc_2_tcd);
        AddTag(indentMM, 'crcy_2_cd', crcy_2_cd);
        AddTag(indentMM, 'tx_xmpt_2_cd', tx_xmpt_2_cd);

        AddBeginTag(indentMM, 'NR4_AMT');
        AddTag(indentMMM, 'gro_1_incamt', gro_1_incamt);
        AddTag(indentMMM, 'nr_tx_1_amt', nr_tx_1_amt);
        AddTag(indentMMM, 'gro_2_incamt', gro_2_incamt);
        AddTag(indentMMM, 'nr_tx_2_amt', nr_tx_2_amt);
        AddEndTag(indentMM, 'NR4_AMT');

        AddTag(indentMM, 'rpt_tcd', rpt_tcd);

        // calculations for summary
        if rpt_tcd = 'A' then
          FHasAmmended := true;

        Ftot_gro_1_incamt := Ftot_gro_1_incamt + Vl(FetchElm(RetNo, FRec.FormName + FRec.FormInst, 8)); // sum of all box 16 in NR4Slip
        Ftot_nr_tx_1_amt := Ftot_nr_tx_1_amt + Vl(FetchElm(RetNo, FRec.FormName + FRec.FormInst, 9)); // sum of all box 17 in NR4Slip
        Ftot_gro_2_incamt := Ftot_gro_2_incamt + Vl(FetchElm(RetNo, FRec.FormName + FRec.FormInst, 13)); // sum of all box 26 in NR4Slip
        Ftot_nr_tx_2_amt := Ftot_nr_tx_2_amt + Vl(FetchElm(RetNo, FRec.FormName + FRec.FormInst, 14)); // sum of all box 27 in NR4Slip
      end;
      AddEndTag(indentM, 'NR4Slip');
    End;
  end;

  with NR4Rec do
  begin
    if FHasAmmended then
      rpt_tcd := 'A'
    else
      rpt_tcd := 'O';
    tot_gro_1_incamt := Format('%.2f', [Ftot_gro_1_incamt]);
    tot_nr_tx_1_amt := Format('%.2f', [Ftot_nr_tx_1_amt]);
    tot_gro_2_incamt := Format('%.2f', [Ftot_gro_2_incamt]);
    tot_nr_tx_2_amt := Format('%.2f', [Ftot_nr_tx_2_amt]);

    AddBeginTag(indentM, 'NR4Summary');
    AddTag(indentMM, 'nr_acct_nbr', nr_acct_nbr);

    AddBeginTag(indentMM, 'PAYR_NM');
    AddTag(indentMMM, 'l1_nm', l1_nm);
    AddTag(indentMMM, 'l2_nm', l2_nm);
    AddTag(indentMMM, 'l3_nm', l3_nm);
    AddEndTag(indentMM, 'PAYR_NM');

    AddBeginTag(indentMM, 'PAYR_ADDR');
    AddTag(indentMMM, 'addr_l1_txt', addr_l1_txt);
    AddTag(indentMMM, 'addr_l2_txt', addr_l2_txt);
    AddTag(indentMMM, 'cty_nm', cty_nm);
    AddTag(indentMMM, 'prov_cd', prov_cd);
    AddTag(indentMMM, 'cntry_cd', cntry_cd);
    AddTag(indentMMM, 'pstl_cd', pstl_cd);
    AddEndTag(indentMM, 'PAYR_ADDR');

    //20180316
    AddBeginTag(indentMM, 'CNTC');
    AddTag(indentMMM, 'cntc_nm', ContName);        //20180316
    AddTag(indentMMM, 'cntc_area_cd', ContArea);
    AddTag(indentMMM, 'cntc_phn_nbr', ContPhone);
    AddTag(indentMMM, 'cntc_extn_nbr', ContExt);
    AddEndTag(indentMM, 'CNTC');

    {    //20180316  does not work
    AddBeginTag(indentMM, 'CNTC');
    AddTag(indentMMM, 'cntc_nm', cntc_nm);        //20180316
    AddTag(indentMMM, 'cntc_area_cd', cntc_area_cd);
    AddTag(indentMMM, 'cntc_phn_nbr', cntc_phn_nbr);
    AddTag(indentMMM, 'cntc_extn_nbr', cntc_extn_nbr);
    AddEndTag(indentMM, 'CNTC');
    }

    AddTag(indentMM, 'tx_yr', tx_yr);
    AddTag(indentMM, 'slp_cnt', slp_cnt);
    AddTag(indentMM, 'rpt_tcd', rpt_tcd);
    AddTag(indentMM, 'fileramendmentnote', fileramendmentnote);

    AddBeginTag(indentMM, 'NR4_TAMT');
    AddTag(indentMMM, 'tot_gro_1_incamt', tot_gro_1_incamt);
    AddTag(indentMMM, 'tot_nr_tx_1_amt', tot_nr_tx_1_amt);
    AddTag(indentMMM, 'tot_gro_2_incamt', tot_gro_2_incamt);
    AddTag(indentMMM, 'tot_nr_tx_2_amt', tot_nr_tx_2_amt);
    AddTag(indentMMM, 'tot_nrpt_incamt', tot_nrpt_incamt);
    AddTag(indentMMM, 'tot_nr_nrpt_tx_amt', tot_nr_nrpt_tx_amt);
    AddEndTag(indentMM, 'NR4_TAMT');

    AddEndTag(indentM, 'NR4Summary');
  end;

  AddEndTag(indent, 'NR4');
  AddEndTag(indent, 'Return');

  addSubmissionTag('END', NR4XmlList);
end;

Procedure PrepareT5018Rec(RetNo:Integer;FName:String);
var
elm:integer;
d,periodEnding:string;
payerName:string;
begin
  //FName := 'T5018S';
  T5018Rec.AccountNumber               := FetchElm(RetNo,FName,2);

  payerName := ReplaceSpecialChar( FetchElm(RetNo,FName,3) );
  T5018Rec.PayerNameLn1                := leftStr(payerName,30);
  T5018Rec.PayerNameLn2                := midStr(payerName,31,30);
  T5018Rec.PayerNameLn3                := midStr(payerName,61,30);

  T5018Rec.PayerAddressLn1             := ReplaceSpecialChar( FetchElm(RetNo,FName,5) );
  T5018Rec.PayerAddressLn2             := ReplaceSpecialChar( FetchElm(RetNo,FName,6) );

  T5018Rec.PayerCity                   := ReplaceSpecialChar( FetchElm(RetNo,FName,7) );
  T5018Rec.PayerProvince               := FetchElm(RetNo,FName,8);
  T5018Rec.PayerCountryCode            := FetchElm(RetNo,FName,22);
  T5018Rec.PayerPostalCode             := ReplaceChar(FetchElm(RetNo,FName,9),' ',''); //20130328

  T5018Rec.ContactName                 := ReplaceSpecialChar( FetchElm(RetNo,FName,14) +' '+ FetchElm(RetNo,FName,15) );

  T5018Rec.ContactAreaCode             := FetchElm(RetNo,FName,16);
  T5018Rec.ContactTelephone            := RemoveChar(FetchElm(RetNo,FName,17),' ');

  //T5018Rec.ContactExtension            := FetchElm(RetNo,FName,??); //not available on form

  d := FetchElm(RetNo,FName,1);
  periodEnding := d[9]+d[10];
  T5018Rec.PeriodEndingDay             := periodEnding;
  periodEnding := d[6]+d[7];
  T5018Rec.PeriodEndingmonth           := periodEnding;
  periodEnding := d[1]+d[2]+d[3]+d[4];
  T5018Rec.PeriodEndingYear            := periodEnding;

  T5018Rec.TotalSlipRecords            := IntToStr(CountT5018Slips(RetNo)); //FetchElm(RetNo,FName,12); //doesnt update properly when got from form
  T5018Rec.TotalSubContractorPayments  := FetchElm(RetNo,FName,13);

  //T5018Rec.ReportTypeCode              := DataTypeCode; //use DataTypeCode directly in createT5018XML
end;

Procedure PrepareT5018SlipRec(RetNo:Integer;FName:String);
var
 elm:integer;
 CorpPartnershipName:string;
begin
  T5018Rec.RecipFirstName              := ReplaceSpecialChar( FetchElm(RetNo,FName,6) );
  T5018Rec.RecipLastName               := ReplaceSpecialChar( FetchElm(RetNo,FName,7) );
  T5018Rec.RecipInitial                := FetchElm(RetNo,FName,8);

  T5018Rec.RecipAccountNumber          := FetchElm(RetNo,FName,3);
  T5018Rec.RecipSIN                    := FetchElm(RetNo,FName,4);
  T5018Rec.RecipPartnershipFIN         := FetchElm(RetNo,FName,5);

  CorpPartnershipName := ReplaceSpecialChar( FetchElm(RetNo,FName,9) );
  T5018Rec.RecipCorpPartnershipNameln1 := leftStr(CorpPartnershipName, 30);
  T5018Rec.RecipCorpPartnershipNameln2 := midStr(CorpPartnershipName, 31, 30);

  T5018Rec.RecipAddressLn1             := ReplaceSpecialChar( FetchElm(RetNo,FName,10) );
  T5018Rec.RecipAddressLn2             := ReplaceSpecialChar( FetchElm(RetNo,FName,11) );
  T5018Rec.RecipCity                   := ReplaceSpecialChar( FetchElm(RetNo,FName,12) );
  T5018Rec.RecipProv                   := FetchElm(RetNo,FName,13);
  T5018Rec.RecipPostalCode             := ReplaceChar(FetchElm(RetNo,FName,14),' ',''); //20130328
  T5018Rec.RecipCountryCode            := FetchElm(RetNo,FName,15);

  T5018Rec.SubContractorPayments       := FetchElm(RetNo,FName,2);
  T5018Rec.RecipPartnershipFIN         := FetchElm(RetNo,FName,5);

  //T5018Rec.AccountNumber               := FetchElm(RetNo,FName,17); //populated in PrepareT5018Rec
  //T5018Rec.ReportTypeCode              := DataTypeCode; //use DataTypeCode directly in createT5018XML
end;


procedure addSubmissionTag(tag:String;Var XmlList:tstringlist);
begin
    if uppercase(tag) = 'BEGIN' then
    begin   //
        //XmlList.add('<?xml version="1.0" encoding="UTF-8"?>');
        //XmlList.add('<Submission xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
        //XmlList.add('xsi:noNamespaceSchemaLocation="layout-topologie.xsd">');


        //jz//20250630
        XmlList.add('<?xml version="1.0" encoding="UTF-8"?>');
        XmlList.add('<Submission xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">');

    end
    else if uppercase(tag) = 'END' then
        XmlList.add('</Submission>')
    else
        ErrorMsg('Submission tag error');
end;

procedure createT5018XML(RetNo:Integer;DataTypeCode:String;SubmitRef:String;Var T5018XmlList:tstringlist);
var
i:integer;
begin

 addSubmissionTag('BEGIN', T5018XmlList);

 PrepareT619(T5018XmlList,RetNo,DataTypeCode,SubmitRef); //T619

 PrepareT5018Rec(RetNo,'T5018S');

 T5018XmlList.add('   <Return>');
 T5018XmlList.add('     <T5018>');


 for i :=0 to (FList.Count - 1) do
 begin
  FRec := FList.Items[i];
  If (Frec.FormName = 'T5018L')
  and (Vl(FetchElmFNo(RetNo,Frec.FormNo,2))>0)
  then
  Begin
    T5018XmlList.add('       <T5018Slip>');  //20130328
    PrepareT5018SlipRec(RetNo,Frec.FormName+Frec.FormInst);  //20130328
    if T5018Rec.RecipSIN > '' then
    begin
      T5018Rec.RecipTypeCode := '1';

      T5018XmlList.add('         <RCPNT_NM>');
      T5018XmlList.add('           <snm>'          + T5018Rec.RecipLastName +'</snm>');
      T5018XmlList.add('           <gvn_nm>'       + T5018Rec.RecipFirstName +'</gvn_nm>');
      If AllTrim(T5018Rec.RecipInitial) >'' then   //20130326
       T5018XmlList.add('           <init>'         + T5018Rec.RecipInitial +'</init>');
      T5018XmlList.add('         </RCPNT_NM>');

      //T5018XmlList.add('         <sin>'            + T5018Rec.RecipSIN +'</sin>');
      //T5018XmlList.add('         <rcpnt_bn>'       + '000000000RZ0000' +'</rcpnt_bn>');

      //T5018Rec.RecipSIN           :=  '000000000';       //<sin>
      T5018Rec.RecipAccountNumber :=  '000000000RZ0000'; //<rcpnt_bn>

    end
    else
    begin  //non individual
      T5018XmlList.add('         <CORP_PTNRP_NM>');
      T5018XmlList.add('           <l1_nm>'        + T5018Rec.RecipCorpPartnershipNameLn1 +'</l1_nm>');
      if T5018Rec.RecipCorpPartnershipNameLn2 > '' then
         T5018XmlList.add('           <l2_nm>'        + T5018Rec.RecipCorpPartnershipNameLn2 +'</l2_nm>');
      T5018XmlList.add('         </CORP_PTNRP_NM>');

      if T5018Rec.RecipPartnershipFIN > '' then
      begin
        T5018Rec.RecipTypeCode := '4';
        T5018XmlList.add('         <ptnrp_filr_id>'  + T5018Rec.RecipPartnershipFIN +'</ptnrp_filr_id>');

        T5018Rec.RecipSIN             := '000000000';      //<sin>
        T5018Rec.RecipAccountNumber   := '000000000RZ0000'; //<rcpnt_bn>
      end
      else
      begin
        T5018Rec.RecipTypeCode := '3';

        T5018Rec.RecipSIN              := '000000000';       //<sin>
        //T5018Rec.RecipAccountNumber    := '000000000RZ0000'; //<rcpnt_bn>

      end;
    end;

    T5018XmlList.add('         <rcpnt_tcd>'      + T5018Rec.RecipTypeCode +'</rcpnt_tcd>');
    T5018XmlList.add('         <RCPNT_ADDR>');
    T5018XmlList.add('            <addr_l1_txt>'  + T5018Rec.RecipAddressLn1 +'</addr_l1_txt>');
    if T5018Rec.RecipAddressLn2 > '' then
       T5018XmlList.add('           <addr_l2_txt>'  + T5018Rec.RecipAddressLn2 +'</addr_l2_txt>');
    T5018XmlList.add('           <cty_nm>'       + T5018Rec.RecipCity +'</cty_nm>');
    T5018XmlList.add('           <prov_cd>'      + T5018Rec.RecipProv +'</prov_cd>');
    T5018XmlList.add('           <cntry_cd>'     + T5018Rec.RecipCountryCode +'</cntry_cd>');
    T5018XmlList.add('           <pstl_cd>'      + T5018Rec.RecipPostalCode +'</pstl_cd>');
    T5018XmlList.add('         </RCPNT_ADDR>');

    //T5018XmlList.add('         <sin>'            + '000000000' +'</sin>'); //20130402
    T5018XmlList.add('         <sin>'            + T5018Rec.RecipSIN +'</sin>');
    T5018XmlList.add('         <rcpnt_bn>'       + T5018Rec.RecipAccountNumber +'</rcpnt_bn>');
    T5018XmlList.add('         <bn>'             + T5018Rec.AccountNumber + '</bn>');
    T5018XmlList.add('         <sbctrcr_amt>'    + T5018Rec.SubContractorPayments +'</sbctrcr_amt>');
    T5018XmlList.add('         <rpt_tcd>'        + DataTypeCode + '</rpt_tcd>');
    T5018XmlList.add('       </T5018Slip>');

  end;  //i
 end; //for TotalSlipRecords

T5018XmlList.add('       <T5018Summary>');
T5018XmlList.add('         <bn>'             + T5018Rec.AccountNumber +'</bn>');
T5018XmlList.add('         <PAYR_NM>');
T5018XmlList.add('           <l1_nm>'        + T5018Rec.PayerNameLn1 +'</l1_nm>');
if T5018Rec.PayerNameLn2 > '' then
    T5018XmlList.add('           <l2_nm>'        + T5018Rec.PayerNameLn2 +'</l2_nm>');
if T5018Rec.PayerNameLn3 > '' then
    T5018XmlList.add('           <l3_nm>'        + T5018Rec.PayerNameLn3 +'</l3_nm>');
T5018XmlList.add('         </PAYR_NM>');
T5018XmlList.add('         <PAYR_ADDR>');
if T5018Rec.PayerAddressLn1 > '' then
    T5018XmlList.add('           <addr_l1_txt>'  + T5018Rec.PayerAddressLn1 +'</addr_l1_txt>');
if T5018Rec.PayerAddressLn2 > '' then
    T5018XmlList.add('           <addr_l2_txt>'  + T5018Rec.PayerAddressLn2 +'</addr_l2_txt>');
if T5018Rec.PayerCity > '' then
    T5018XmlList.add('           <cty_nm>'       + T5018Rec.PayerCity +'</cty_nm>');
if T5018Rec.PayerProvince > '' then
    T5018XmlList.add('           <prov_cd>'      + T5018Rec.PayerProvince +'</prov_cd>');
if T5018Rec.PayerCountryCode > '' then
    T5018XmlList.add('           <cntry_cd>'     + T5018Rec.PayerCountryCode +'</cntry_cd>');
if T5018Rec.PayerPostalCode > '' then
    T5018XmlList.add('           <pstl_cd>'      + T5018Rec.PayerPostalCode +'</pstl_cd>');
T5018XmlList.add('         </PAYR_ADDR>');
T5018XmlList.add('         <CNTC>');
T5018XmlList.add('           <cntc_nm>'      + T5018Rec.ContactName +'</cntc_nm>');
T5018XmlList.add('           <cntc_area_cd>' + T5018Rec.ContactAreaCode +'</cntc_area_cd>');
T5018XmlList.add('           <cntc_phn_nbr>' + T5018Rec.ContactTelephone +'</cntc_phn_nbr>');
if T5018Rec.ContactExtension > '' then
    T5018XmlList.add('           <cntc_extn_nbr>'+ T5018Rec.ContactExtension +'</cntc_extn_nbr>');
T5018XmlList.add('         </CNTC>');
T5018XmlList.add('         <PRD_END_DT>');
T5018XmlList.add('           <dy>'           + T5018Rec.PeriodEndingDay +'</dy>');
T5018XmlList.add('           <mo>'           + T5018Rec.PeriodEndingMonth +'</mo>');
T5018XmlList.add('           <yr>'           + T5018Rec.PeriodEndingYear +'</yr>');
T5018XmlList.add('         </PRD_END_DT>');
T5018XmlList.add('         <slp_cnt>'        + T5018Rec.TotalSlipRecords +'</slp_cnt>');
T5018XmlList.add('         <tot_sbctrcr_amt>'+ T5018Rec.TotalSubContractorPayments +'</tot_sbctrcr_amt>');
T5018XmlList.add('         <rpt_tcd>'        + DataTypeCode + '</rpt_tcd>');
T5018XmlList.add('       </T5018Summary>');

T5018XmlList.add('     </T5018>');
T5018XmlList.add('   </Return>');

addSubmissionTag('END',T5018XmlList);
//T5018XmlList.add('</Submission>');

end;



Function ReplaceSpecialChar(info:String):String;
Begin
 info := ReplaceChar(info,'&','&amp;');
 info := ReplaceChar(info, '<' , '&lt;' );
 info := ReplaceChar(info,'"','&quot;');
 info := ReplaceChar(info,'>','&gt;');
 info := ReplaceChar(info,'''','&apos;');
// info := ReplaceChar(info,'.','');  //20180316 CREATES BIG PROBLEM WITH AMOUNTS

 result := info;

End;

Function FixPostal(s:String):String;
{remove space or dash}
begin
 Result := RemoveChar(s,' ');
 result := RemoveChar(Result,'-');
end;

Function GetT5013Rec(RetNo: Integer; FName: String): AT5013Rec; //20240305 Igor
var LYear, LMonth, LDay: string;

    procedure ParseDate(AValue: string);
    begin
      LYear := Copy(AValue, 1, 4);
      LMonth := Copy(AValue, 6, 2);
      LDay := Copy(AValue, 9, 2);
    end;

    Function GetYesNoValue(RetNo: Integer; FName: string; AElmYes, AElmNo: integer): string;
    begin
      if FetchElm(RetNo, FName, AElmYes) > '' then
        Result := 'Y'
      else if FetchElm(RetNo, FName, AElmNo) > '' then
        Result := 'N'
      else
        Result := '';
    end;
begin
  with Result do
  begin
    SummaryFilerAccountNumber := FetchElm(RetNo, FName, 5);
    FilerNameLine1Text := FetchElm(RetNo, 'T5013#1', 21);
    FilerNameLine2Text := '';
    FilerNameLine3Text := '';
    AddressLine1Text := FetchElm(RetNo, 'T5013#1', 22);
    AddressLine2Text := '';
    CityName := FetchElm(RetNo, 'T5013#1', 23);
    ProvinceStateCode := FetchElm(RetNo, 'T5013#1', 24);
    CountryCode := FetchElm(RetNo, 'T5013#1', 26);
    PostalZipCode := FetchElm(RetNo, 'T5013#1', 25);
    PartnershipReturnNomineeIndicationCode := GetYesNoValue(RetNo, FName, 6, 22);
    NomineeAgentAccountNumber := FetchElm(RetNo, FName, 11);
    NomineeAgentName := FetchElm(RetNo, FName, 9);
    TaxShelterIdentificationNumber := FetchElm(RetNo, FName, 13);
    ContactName := FetchElm(RetNo, FName, 64);
    ContactAreaCode := FetchElm(RetNo, FName, 16);
    ContactPhoneNumber := FetchElm(RetNo, FName, 66);
    ContactExtensionNumber := FetchElm(RetNo, FName, 17);
    ParseDate(FetchElm(RetNo, FName, 3));
    FiscalPeriodStartYear := LYear;
    FiscalPeriodStartMonth := LMonth;
    FiscalPeriodStartDay := LDay;
    ParseDate(FetchElm(RetNo, FName, 4));
    FiscalPeriodEndYear := LYear;
    FiscalPeriodEndMonth := LMonth;
    FiscalPeriodEndDay := LDay;
    TotalSlipCount := FetchElm(RetNo, FName, 8);
    if FetchElm(RetNo, 'T5013FIN', 36) > '' then
      SummaryReportTypeCode := 'A'
    else
      SummaryReportTypeCode := 'O';
    fileramendmentnote := ''; //???
    TotalLimitedPartnerBusinessIncomeAmount := FetchElm(RetNo, FName, 14);
    TotalNetBusinessIncomeAmount := FetchElm(RetNo, FName, 15);
    TotalCapitalGainLossAmount := FetchElm(RetNo, FName, 264);
    TotalCapitalCostAllowanceAmount := FetchElm(RetNo, FName, 266);
    TotalCanadianForeignNetRentalIncomeLossAmount := FetchElm(RetNo, FName, 7);
    TotalNetProfessionalIncomeLossAmount := FetchElm(RetNo, FName, 91);
    TotalRenouncedCanadianExplorationExpenseAmount := FetchElm(RetNo, FName, 149);
    TotalRenouncedCanadianDevelopmentExpenseAmount := FetchElm(RetNo, FName, 150);
    TotalITCQualifyingExpensesAmount := FetchElm(RetNo, FName, 154);
    TotalCarryingChargesAmount := FetchElm(RetNo, FName, 140);
  end;
end;

Function GetT5013SlipRec(RetNo: Integer; FName: String): AT5013SlipRec; //20240305 Igor

    procedure AddFinancialDetailValues(AFieldCodeId, AJurisdictionCodeId, AFieldAmountId: integer);
    begin
      Result.AddFinancialDetail(FetchElm(RetNo, FName, AFieldCodeId),
                                FetchElm(RetNo, FName, AJurisdictionCodeId),
                                FetchElm(RetNo, FName, AFieldAmountId));
    end;

    procedure AddOtherInformationValues(AFieldCodeId, AJurisdictionCodeId, AFieldTextId: integer);
    begin
      Result.AddOtherInformation(FetchElm(RetNo, FName, AFieldCodeId),
                                 FetchElm(RetNo, FName, AJurisdictionCodeId),
                                 FetchElm(RetNo, FName, AFieldTextId));
    end;
begin
  with Result do
  begin
    FamilyName := FetchElm(RetNo, FName, 15);
    GivenName := FetchElm(RetNo, FName, 80);
    NameInitialText := FetchElm(RetNo, FName, 81);
    RecipientSIN := FetchElm(RetNo, FName, 14);
    BusinessNameLine1Text := FetchElm(RetNo, 'T5013FIN', 7);
    BusinessNameLine2Text := FetchElm(RetNo, 'T5013FIN', 8);
    RecipientBusinessNumber := FetchElm(RetNo, 'T5013FIN', 1);
    RecipientTrustAccountNumber := FetchElm(RetNo, FName, 4);
    AddressLine1Text := FetchElm(RetNo, FName, 16);
    AddressLine2Text := '';
    CityName := FetchElm(RetNo, FName, 17);
    ProvinceStateCode := FetchElm(RetNo, FName, 18);
    CountryCode := FetchElm(RetNo, FName, 19);
    PostalZipCode := FetchElm(RetNo, FName, 20);
    SlipFilerAccountNumber := ''; // ???
    if FetchElm(RetNo, 'T5013FIN', 36) > '' then // ??? not sure if it is correct
      SlipReportTypeCode := 'A'
    else
      SlipReportTypeCode := 'O';
    PartnershipPartnerCode := FetchElm(RetNo, FName, 11);
    PartnerResidenceCountryCode := FetchElm(RetNo, FName, 10);
    RecipientTypeCode := FetchElm(RetNo, FName, 28);
    PartnerOwnershipPercent := FetchElm(RetNo, FName, 13);
    LimitedPartnerBusinessIncomeAmount := FetchElm(RetNo, FName, 7);
    NetBusinessIncomeAmount := FetchElm(RetNo, FName, 9);
    CapitalGainLossAmount := FetchElm(RetNo, FName, 12);
    CapitalCostAllowanceAmount := FetchElm(RetNo, FName, 27);

    AddFinancialDetailValues(32, 33, 34);
    AddFinancialDetailValues(35, 36, 37);
    AddFinancialDetailValues(38, 39, 40);
    AddFinancialDetailValues(41, 42, 43);
    AddFinancialDetailValues(44, 45, 46);
    AddFinancialDetailValues(47, 48, 49);
    AddFinancialDetailValues(50, 51, 52);
    AddFinancialDetailValues(53, 54, 55);
    AddFinancialDetailValues(56, 57, 58);
    AddFinancialDetailValues(59, 60, 61);
    AddFinancialDetailValues(62, 63, 64);
    AddFinancialDetailValues(65, 66, 67);

    AddOtherInformationValues(68, 69, 70);
    AddOtherInformationValues(71, 72, 73);
    AddOtherInformationValues(74, 75, 76);
    AddOtherInformationValues(77, 78, 79);
  end
end;

Procedure createT5013XML(RetNo: Integer; DataTypeCode: String; SubmitRef: String; var AXmlList: TStringList); //20240305 Igor
var I, J: integer;
    T5013Rec: AT5013Rec;
    T5013SlipRec: AT5013SlipRec;
    FHasAmmended: boolean;

  procedure AddBeginTag(AIndent: integer; AName: string);
  begin
    AXmlList.Add(Space(AIndent) + '<'+ AName +'>');
  end;

  procedure AddEndTag(AIndent: integer; AName: string);
  begin
    AXmlList.Add(Space(AIndent) + '</'+ AName +'>');
  end;

  procedure AddTag(AIndent: integer; AName, AValue: string);
  begin
    if SameText(Trim(AValue), '') then Exit;
    if SameText(Trim(AValue), '') then
      AXmlList.Add(Space(AIndent) + '<'+ AName +'/>')
    else
      AXmlList.Add(Space(AIndent) + '<'+ AName +'>' + ReplaceSpecialChar(AValue) + '</'+ AName +'>');
  end;

begin
  addSubmissionTag('BEGIN', AXmlList);

  PrepareT619(AXmlList, RetNo, DataTypeCode, SubmitRef); //T619

  T5013Rec := GetT5013Rec(RetNo,'T5013SUM');

  AddBeginTag(indent, 'Return');
  AddBeginTag(indent, 'T5013SlipAndSummary');

  FHasAmmended := false;

  for I := 0 to FList.Count - 1 do
  begin
    FRec := FList.Items[I];
    If (FRec.FormName = 'T5013') then
    Begin
      AddBeginTag(indentM, 'T5013SlipInformation');
      T5013SlipRec := GetT5013SlipRec(RetNo, FRec.FormName + FRec.FormInst);
      with T5013SlipRec do
      begin
        AddBeginTag(indentMM, 'RecipientName');
        AddTag(indentMMM, 'FamilyName', FamilyName);
        AddTag(indentMMM, 'GivenName', GivenName);
        AddTag(indentMMM, 'NameInitialText', NameInitialText);
        AddEndTag(indentMM, 'RecipientName');

        AddTag(indentMM, 'RecipientSIN', RecipientSIN);

        AddBeginTag(indentMM, 'BusinessName');
        AddTag(indentMMM, 'BusinessNameLine1Text', BusinessNameLine1Text);
        AddTag(indentMMM, 'BusinessNameLine2Text', BusinessNameLine2Text);
        AddEndTag(indentMM, 'BusinessName');

        AddTag(indentMM, 'RecipientBusinessNumber', RecipientBusinessNumber);
        AddTag(indentMM, 'RecipientTrustAccountNumber', RecipientTrustAccountNumber);

        AddBeginTag(indentMM, 'RecipientAddress');
        AddTag(indentMMM, 'AddressLine1Text', AddressLine1Text);
        AddTag(indentMMM, 'AddressLine2Text', AddressLine2Text);
        AddTag(indentMMM, 'CityName', CityName);
        AddTag(indentMMM, 'ProvinceStateCode', ProvinceStateCode);
        AddTag(indentMMM, 'CountryCode', CountryCode);
        AddTag(indentMMM, 'PostalZipCode', PostalZipCode);
        AddEndTag(indentMM, 'RecipientAddress');

        AddTag(indentMM, 'SlipFilerAccountNumber', SlipFilerAccountNumber);
        AddTag(indentMM, 'SlipReportTypeCode', SlipReportTypeCode);
        AddTag(indentMM, 'PartnershipPartnerCode', PartnershipPartnerCode);
        AddTag(indentMM, 'PartnerResidenceCountryCode', PartnerResidenceCountryCode);
        AddTag(indentMM, 'RecipientTypeCode', RecipientTypeCode);
        AddTag(indentMM, 'PartnerOwnershipPercent', PartnerOwnershipPercent);

        AddBeginTag(indentMM, 'T5013Amounts');
        AddTag(indentMMM, 'LimitedPartnerBusinessIncomeAmount', LimitedPartnerBusinessIncomeAmount);
        AddTag(indentMMM, 'NetBusinessIncomeAmount', NetBusinessIncomeAmount);
        AddTag(indentMMM, 'CapitalGainLossAmount', CapitalGainLossAmount);
        AddTag(indentMMM, 'CapitalCostAllowanceAmount', CapitalCostAllowanceAmount);
        AddEndTag(indentMM, 'T5013Amounts');

        for J := 0 to Length(T5013SlipFinancialDetails) - 1 do
        begin
          AddBeginTag(indentMM, 'T5013SlipFinancialDetails');
          AddTag(indentMMM, 'FinancialDetailsFieldCode', T5013SlipFinancialDetails[J].FinancialDetailsFieldCode);
          AddTag(indentMMM, 'FinancialDetailsJurisdictionCode', T5013SlipFinancialDetails[J].FinancialDetailsJurisdictionCode);
          AddTag(indentMMM, 'FinancialDetailsFieldAmount', T5013SlipFinancialDetails[J].FinancialDetailsFieldAmount);
          AddEndTag(indentMM, 'T5013SlipFinancialDetails');
        end;

        for J := 0 to Length(T5013SlipOtherInformation) - 1 do
        begin
          AddBeginTag(indentMM, 'T5013SlipOtherInformation');
          AddTag(indentMMM, 'OtherInformationFieldCode', T5013SlipOtherInformation[J].OtherInformationFieldCode);
          AddTag(indentMMM, 'OtherInformationJurisdictionCode', T5013SlipOtherInformation[J].OtherInformationJurisdictionCode);
          AddTag(indentMMM, 'OtherInformationFieldText', T5013SlipOtherInformation[J].OtherInformationFieldText);
          AddEndTag(indentMM, 'T5013SlipOtherInformation');
        end;
      end;
      AddEndTag(indentM, 'T5013SlipInformation');
    End;
  end;

  with T5013Rec do
  begin
    AddBeginTag(indentM, 'T5013SummaryInformation');
    AddTag(indentMM, 'SummaryFilerAccountNumber', SummaryFilerAccountNumber);

    AddBeginTag(indentMM, 'SummaryFilerName');
    AddTag(indentMMM, 'FilerNameLine1Text', FilerNameLine1Text);
    AddTag(indentMMM, 'FilerNameLine2Text', FilerNameLine2Text);
    AddTag(indentMMM, 'FilerNameLine3Text', FilerNameLine3Text);
    AddEndTag(indentMM, 'SummaryFilerName');

    AddBeginTag(indentMM, 'SummaryFilerAddress');
    AddTag(indentMMM, 'AddressLine1Text', AddressLine1Text);
    AddTag(indentMMM, 'AddressLine2Text', AddressLine2Text);
    AddTag(indentMMM, 'CityName', CityName);
    AddTag(indentMMM, 'ProvinceStateCode', ProvinceStateCode);
    AddTag(indentMMM, 'CountryCode', CountryCode);
    AddTag(indentMMM, 'PostalZipCode', PostalZipCode);
    AddEndTag(indentMM, 'SummaryFilerAddress');

    AddTag(indentMM, 'PartnershipReturnNomineeIndicationCode', PartnershipReturnNomineeIndicationCode);
    AddTag(indentMM, 'NomineeAgentAccountNumber', NomineeAgentAccountNumber);
    AddTag(indentMM, 'NomineeAgentName', NomineeAgentName);
    AddTag(indentMM, 'TaxShelterIdentificationNumber', TaxShelterIdentificationNumber);

    AddBeginTag(indentMM, 'SummaryFilerContact');
    AddTag(indentMMM, 'ContactName', ContactName);
    AddTag(indentMMM, 'ContactAreaCode', ContactAreaCode);
    AddTag(indentMMM, 'ContactPhoneNumber', ContactPhoneNumber);
    AddTag(indentMMM, 'ContactExtensionNumber', ContactExtensionNumber);
    AddEndTag(indentMM, 'SummaryFilerContact');

    AddBeginTag(indentMM, 'FiscalPeriodStartDate');
    AddTag(indentMMM, 'FiscalPeriodStartYear', FiscalPeriodStartYear);
    AddTag(indentMMM, 'FiscalPeriodStartMonth', FiscalPeriodStartMonth);
    AddTag(indentMMM, 'FiscalPeriodStartDay', FiscalPeriodStartDay);
    AddEndTag(indentMM, 'FiscalPeriodStartDate');

    AddBeginTag(indentMM, 'FiscalPeriodEndDate');
    AddTag(indentMMM, 'FiscalPeriodEndYear', FiscalPeriodEndYear);
    AddTag(indentMMM, 'FiscalPeriodEndMonth', FiscalPeriodEndMonth);
    AddTag(indentMMM, 'FiscalPeriodEndDay', FiscalPeriodEndDay);
    AddEndTag(indentMM, 'FiscalPeriodEndDate');

    AddTag(indentMM, 'TotalSlipCount', TotalSlipCount);
    AddTag(indentMM, 'SummaryReportTypeCode', SummaryReportTypeCode);
    AddTag(indentMM, 'fileramendmentnote', fileramendmentnote);

    AddBeginTag(indentMM, 'T5013TotalsAmount');
    AddTag(indentMMM, 'TotalLimitedPartnerBusinessIncomeAmount', TotalLimitedPartnerBusinessIncomeAmount);
    AddTag(indentMMM, 'TotalNetBusinessIncomeAmount', TotalNetBusinessIncomeAmount);
    AddTag(indentMMM, 'TotalCapitalGainLossAmount', TotalCapitalGainLossAmount);
    AddTag(indentMMM, 'TotalCapitalCostAllowanceAmount', TotalCapitalCostAllowanceAmount);
    AddTag(indentMMM, 'TotalCanadianForeignNetRentalIncomeLossAmount', TotalCanadianForeignNetRentalIncomeLossAmount);
    AddTag(indentMMM, 'TotalNetProfessionalIncomeLossAmount', TotalNetProfessionalIncomeLossAmount);
    AddTag(indentMMM, 'TotalRenouncedCanadianExplorationExpenseAmount', TotalRenouncedCanadianExplorationExpenseAmount);
    AddTag(indentMMM, 'TotalRenouncedCanadianDevelopmentExpenseAmount', TotalRenouncedCanadianDevelopmentExpenseAmount);
    AddTag(indentMMM, 'TotalITCQualifyingExpensesAmount', TotalITCQualifyingExpensesAmount);
    AddTag(indentMMM, 'TotalCarryingChargesAmount', TotalCarryingChargesAmount);
    AddEndTag(indentMM, 'T5013TotalsAmount');

    AddEndTag(indentM, 'T5013SummaryInformation');
  end;

  AddEndTag(indent, 'T5013SlipAndSummary');
  AddEndTag(indent, 'Return');

  addSubmissionTag('END', AXmlList);

end;

{ AT5013SlipRec }

procedure AT5013SlipRec.AddFinancialDetail(AFieldCode, AJurisdictionCode, //20240305 Igor
  AFieldAmount: string);
begin
  if AFieldCode.IsEmpty and AJurisdictionCode.IsEmpty and AFieldAmount.IsEmpty then
    Exit;
  SetLength(T5013SlipFinancialDetails, Length(T5013SlipFinancialDetails) + 1);
  with T5013SlipFinancialDetails[Length(T5013SlipFinancialDetails) - 1] do
  begin
    FinancialDetailsFieldCode := AFieldCode;
    FinancialDetailsJurisdictionCode := AJurisdictionCode;
    FinancialDetailsFieldAmount := AFieldAmount;
  end;
end;

procedure AT5013SlipRec.AddOtherInformation(AFieldCode, AJurisdictionCode, //20240305 Igor
  AFieldText: string);
begin
  if AFieldCode.IsEmpty and AJurisdictionCode.IsEmpty and AFieldText.IsEmpty then
    Exit;
  SetLength(T5013SlipOtherInformation, Length(T5013SlipOtherInformation) + 1);
  with T5013SlipOtherInformation[Length(T5013SlipOtherInformation) - 1] do
  begin
    OtherInformationFieldCode := AFieldCode;
    OtherInformationJurisdictionCode := AJurisdictionCode;
    OtherInformationFieldText := AFieldText;
  end;
end;


//jz//20250323 - Procedure PrepareT619 same in  T3_2025dataGen, T4T5_2025dataGen and TF_2026dataGen EXCEPT:
//                  TF_2026dataGen has 3 extra lines:
//                  - ContName:= Info;
//                  - ContArea:=LeftStr(OptRec.Prp_Area,3);
//                  - ContPhone:=RemoveChar(LeftStr(OptRec.Prp_Tel,8),' ');

//                  T4T5_2025dataGen may not be using PrepareT619 in T4T5_2025dataGen:
//                  - using PrepareXmitterinfo in T4T5_2025PrepareXml instead ???
//20260107 Igor >>>
procedure PrepareT619(var T619XmlList: TStringList; RetNo: Integer; DataTypeCode: string; SubmitRef: string; aFormName: string = '');
var
  Info, Lang: string;
begin
  T619XmlList.add(Space(indent) + '<T619>');

  if OptRec.Prp_RepId.IsEmpty then //20260727 Alex
  begin //20260727 Alex
	  //Required up to 15 alphanumeric
	  T619XmlList.add(Space(indentM) + '<TransmitterAccountNumber>');
	  //20260226CZ
	   info:= OptRec.Prp_TransmitterNo;
	   if (Length(info) = 9) then
		 T619XmlList.Add(Space(indentMM) + '<bn9>' + OptRec.Prp_TransmitterNo + '</bn9>)')
	   else
		 T619XmlList.Add(Space(indentMM) + '<bn15>' + OptRec.Prp_TransmitterNo + '</bn15>');

	  {    20260226cz
	  if aFormName.Equals('NR4') then
	  begin
		T619XmlList.Add(Space(indentMM) + '<nr4>' + UpperCase(FetchElm(RetNo, 'NR4SUM', 3)) + '</nr4>');
	  end else
	  begin
		info:= OptRec.Prp_TransmitterNo;
		if (Length(info) = 9) then
		  T619XmlList.Add(Space(indentMM) + '<bn9>' + OptRec.Prp_TransmitterNo + '</bn9>)')
		else
		  T619XmlList.Add(Space(indentMM) + '<bn15>' + OptRec.Prp_TransmitterNo + '</bn15>');
	  end;
	  }

	  //<trust></trust> -1 alpha, 8 numeric, example: T00000000
	  //<nr4></nr4>     - 3 alpha, 6 numeric, example: AAA000000

	  T619XmlList.add(Space(indentM) + '</TransmitterAccountNumber>');
  end else //20260727 Alex
  //Required (if logged in using Represent a client (RAC) application) -7 alphanumeric
  if not OptRec.Prp_RepId.IsEmpty() then //20260723 Alex
  begin
    T619XmlList.add(Space(indentM) + '<TransmitterRepID>');
    T619XmlList.add(Space(indentMM) + '<RepID>' + OptRec.Prp_RepId + '</RepID>'); //20260723 Alex
    T619XmlList.add(Space(indentM) + '</TransmitterRepID>');
  end;

  //? required 8
  //if OptRec.Prp_RepId.IsEmpty then //20260727 Alex
  if not SubmitRef.IsEmpty then //20260727 Alex
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
  //20250526 Igor >>>
  Lang:= 'E';
  //If FetchElm(RetNo,'T619_1',28)>'' then Lang:='F'; //20250526 Igor >>>

  T619XmlList.add(Space(indentM) + '<lang_cd>' + Lang + '</lang_cd>');

  T619XmlList.add(Space(indentM) + '<TransmitterName>'); //jz//20250323 - replaced <TRNMTR_NM>
  //jz//20250630 - required first 35 alphanumeric //[2] required first 30 alphanumeric
  info:= ReplaceSpecialChar(LeftStr(OptRec.Prp_Name, 35));
  T619XmlList.add(Space(indentMM) + '<l1_nm>' + info + '</l1_nm>');

  //jz//20250630 - no longer allows second line
  {info:= ReplaceSpecialChar(MidStr(OptRec.Prp_name,31,30));
  //[2] required second 30 alphanumeric
  If info > '' then
  begin
   T619XmlList.add(Space(indentMM) + '<l2_nm>' + info + '</l2_nm>');
  end; }

  T619XmlList.add(Space(indentM) + '</TransmitterName>'); //jz//20250323 - replaced </TRNMTR_NM>
  T619XmlList.add(Space(indentM) + '<TransmitterCountryCode>CAN</TransmitterCountryCode>');

  //jz//20250323 - removed <<
  {T619XmlList.add(Space(indentM) + '<TRNMTR_ADDR>');
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
  T619XmlList.add(Space(indentM) + '</TRNMTR_ADDR>'); }
  //jz//20250323 - removed >>

  T619XmlList.add(Space(indentM) + '<CNTC>');

  info:= ReplaceReservedXMLCharactersAndTruncate(OptRec.Prp_ContactName, 22);
  //[8] required 22 alphanumeric, omit titles
  T619XmlList.add(Space(indentMM) + '<cntc_nm>' + info + '</cntc_nm>');
  ContName:= Info;   //General use 20180316 CON

  //[6] - first 3 numbers
  T619XmlList.add(Space(indentMM) + '<cntc_area_cd>' + LeftStr(OptRec.Prp_Area, 3) + '</cntc_area_cd>');
  ContArea:= LeftStr(OptRec.Prp_Area, 3);  //General use 20180316 CON

  //[6] - last 7 numbers 3 then '-' then last 4  - needs validation on input
  T619XmlList.add(Space(indentMM) + '<cntc_phn_nbr>' + LeftStr(OptRec.Prp_Tel, 8) + '</cntc_phn_nbr>');
  ContPhone:= RemoveChar(LeftStr(OptRec.Prp_Tel,8), ' ');  //General use 20180316 CON

  //?Transmitter Contact Extension Number. Not required - Up to 12 numeric.
  //T619XmlList.add(Space(indentM) + '<cntc_extn_nbr>' + LeftStr(FetchElm(RetNo,'T619_1',5))' + '</cntc_extn_nbr>';

  if not OptRec.Prp_Email.IsEmpty() then T619XmlList.add(Space(indentMM) + '<cntc_email_area>' + AllTrim(OptRec.Prp_EMail) + '</cntc_email_area>');
  //<sec_cntc_email_area></sec_cntc_email_area> //Transmitter Second Contact Email. NOT Required parameter - Up to 60 alphanumeric. //20260107 Igor
  T619XmlList.add(Space(indentM) + '</CNTC>');
  T619XmlList.add(Space(indent) + '</T619>');
end;
// 20260107 Igor <<<

//20250519 Igor >>>
function GetT3010YesNoValue(aRetNo: Integer; aFieldIndex: Integer; aElmYes, aElmNo: integer): string;
begin
  if FetchElm(aRetNo, aFieldIndex, aElmYes) > '' then
    Result := '0001'
  else
  if ((aElmNo > 0) and (FetchElm(aRetNo, aFieldIndex, aElmNo) > '')) then
    Result:= '0002'
  else
    Result:= '';
end;

procedure addT3010SubmissionTag(aTag: String; Var aXmlList: tstringlist);
begin
    if UpperCase(aTag) = 'BEGIN' then
    begin
        aXmlList.add('<?xml version="1.0" encoding="UTF-8"?>');
        aXmlList.add('<ns0:CharityAnnualReturnVendorSubmission xmlns:ns0="http://www.cra-arc.gc.ca/xmlns/cha/t3010/5-0-0">');
    end
    else if UpperCase(aTag) = 'END' then
        aXmlList.add('</ns0:CharityAnnualReturnVendorSubmission>')
    else
        ErrorMsg('Submission tag error');
end;
//20260105 Igor >>>
procedure createT3010XML(aRetNo: Integer; aDataTypeCode: String; aSubmitRef: String; var aXmlList: TStringList);
var
  i, j: Integer;
  T3010Rec: AT3010Rec;
  T1235SlipRec: AT1235SlipRec;
  T1236SlipRec: AT1236SlipRec;
  T1441SlipRec: AT1441SlipRec;
  T2081Rec: AT2081Rec;

  procedure AddBeginTag(AIndent: integer; AName: string);
  begin
    AXmlList.Add(Space(AIndent) + '<'+ AName +'>');
  end;

  procedure AddEndTag(AIndent: integer; AName: string);
  begin
    AXmlList.Add(Space(AIndent) + '</'+ AName +'>');
  end;

  procedure AddTag(AIndent: integer; AName, AValue: string; aIsElmRequired: Boolean = false);
  begin
    if SameText(Trim(AValue), '') and not aIsElmRequired then Exit;
    if SameText(Trim(AValue), '') then
      AXmlList.Add(Space(AIndent) + '<'+ AName +'/>')
    else
      AXmlList.Add(Space(AIndent) + '<'+ AName +'>' + ReplaceSpecialChar(AValue) + '</'+ AName +'>');
  end;

  function GetRoundedFloatFalue(aFloatVal: string): string;
  begin
    Result:= '';
    if aFloatVal.IsEmpty() then exit;

    Result:= FloatToStr(Round(StrToFloatDef(aFloatVal, 0)));
  end;

  procedure AddD4_FinancialInfo_Block(aIndentBlock, aIndent: integer; aCode, aValue: string; aIsElmRequired: Boolean = false);
  begin
    if SameText(Trim(aValue), '') and not aIsElmRequired then Exit;

    AddBeginTag(aIndentBlock, 'D4_FinancialInfo');
    AddTag(aIndent, 'Code', aCode, False{True});
    AddTag(aIndent, 'Amount', GetRoundedFloatFalue(aValue), False{True});
    AddEndTag(aIndentBlock, 'D4_FinancialInfo');
  end;

  procedure AddSchedule2_210_line(aIndentBlock, aIndent: integer; aName, aCountryCode, aAmount: string);
  begin
    if (not aName.IsEmpty() and not aCountryCode.IsEmpty() and not aAmount.IsEmpty()) then
    begin
      AddBeginTag(aIndentBlock, 'ActivityDetail');
      AddTag(aIndent, 'Name', aName, False{True});
      AddTag(aIndent, 'CountryCode', aCountryCode, False{True});
      AddTag(aIndent, 'Amount', GetRoundedFloatFalue(aAmount), False{True});
      AddEndTag(aIndentBlock, 'ActivityDetail');
    end;
  end;

  procedure AddSchedule2_3_line(aIndent: integer; aCountryCode: string);
  begin
    if (not aCountryCode.IsEmpty()) then
    begin
			AddTag(aIndent, 'CountryCode', aCountryCode, False{True});
    end;
  end;

  procedure AddSchedule2_7_Export_line(aIndentBlock, aIndent: integer; aItem, aValue, aDestination, aCountryCode: string);
  begin
    if (not aItem.IsEmpty() and not aValue.IsEmpty() and not aDestination.IsEmpty() and not aCountryCode.IsEmpty()) then
    begin
      AddBeginTag(aIndentBlock, 'Export');
      AddTag(aIndent, 'Item', aItem, False{True});
      AddTag(aIndent, 'Value', GetRoundedFloatFalue(aValue), False{True});
      AddTag(aIndent, 'Destination', aDestination, False{True});
      AddTag(aIndent, 'CountryCode', aCountryCode, False{True});
      AddEndTag(aIndentBlock, 'Export');
    end;
  end;

  procedure AddSchedule3_1b_line(aIndentBlock, aIndent: integer; aPayCategory, aCount: string);
  begin
    if (not aPayCategory.IsEmpty() and not aCount.IsEmpty()) then
    begin
      AddBeginTag(aIndentBlock, 'RangeDetails');
      AddTag(aIndent, 'PayCategory', aPayCategory, False{True});
      AddTag(aIndent, 'Count', aCount, False{True});
      AddEndTag(aIndentBlock, 'RangeDetails');
    end;
  end;

  procedure AddSchedule4_1_line(aIndentBlock, aIndent: integer; aName, aAtArmsLength: string);
  begin
    if (not aName.IsEmpty() and not aAtArmsLength.IsEmpty()) then
    begin
      AddBeginTag(aIndentBlock, 'Detail');
      AddTag(aIndent, 'Name', aName, False{True});
      AddTag(aIndent, 'AtArmsLength', aAtArmsLength, False{True});
      AddEndTag(aIndentBlock, 'Detail');
    end;
  end;

  procedure AddSchedule4_2_line(aIndentBlock, aIndent: integer; aName, aValue, aType: string);
  begin
    if (not aName.IsEmpty() and not aValue.IsEmpty() and not aType.IsEmpty() and not aType.Equals('0000')) then
    begin
      AddBeginTag(aIndentBlock, 'Detail');
      AddTag(aIndent, 'Name', aName, False{True});
      AddTag(aIndent, 'Value', GetRoundedFloatFalue(aValue), False{True});
      AddTag(aIndent, 'Type', aType, False{True});
      AddEndTag(aIndentBlock, 'Detail');
    end;
  end;

  procedure AddSchedule6_Block_Line(aIndentBlock, aIndent: integer; aBlockName, aCode, aValue: string);
  begin
    if SameText(Trim(aValue), '') then Exit;

    AddBeginTag(aIndentBlock, aBlockName);
    AddTag(aIndent, 'Code', aCode, False{True});
    AddTag(aIndent, 'Amount', GetRoundedFloatFalue(aValue), False{True});
    AddEndTag(aIndent, aBlockName);
  end;

  procedure AddT2081_Line(aIndentBlock, aIndent: integer; aBlockName, aCodeName, aValueName, aCode, aValue: string);
  begin
    if SameText(Trim(aValue), '') then Exit;

    AddBeginTag(aIndentBlock, aBlockName);
    AddTag(aIndent, aCodeName, aCode, False{True});
    AddTag(aIndent, aValueName, aValue, False{True});
    AddEndTag(aIndent, aBlockName);
  end;

  procedure AddSecFBlock(aIndentBlock, aIndent, aIndentData: integer; aIndex, aYear, aPerc1, aPerc2, aPerc3, aPerc4, aPerc5, aPerc6, aPerc7: string);
  begin
    if aPerc1.IsEmpty and aPerc2.IsEmpty and aPerc3.IsEmpty and aPerc4.IsEmpty and aPerc5.IsEmpty and aPerc6.IsEmpty and aPerc7.IsEmpty then Exit;

    AddBeginTag(aIndentBlock, 'DivestmentObligation');
    AddTag(aIndent, 'Index', aIndex, False{True});
    AddTag(aIndent, 'Year', aYear, False{True});
    AddT2081_Line(aIndent, aIndentData, 'StepDetails', 'Step', 'Percentage', '0001', aPerc1);
    AddT2081_Line(aIndent, aIndentData, 'StepDetails', 'Step', 'Percentage', '0002', aPerc2);
    AddT2081_Line(aIndent, aIndentData, 'StepDetails', 'Step', 'Percentage', '0003', aPerc3);
    AddT2081_Line(aIndent, aIndentData, 'StepDetails', 'Step', 'Percentage', '0004', aPerc4);
    AddT2081_Line(aIndent, aIndentData, 'StepDetails', 'Step', 'Percentage', '0005', aPerc5);
    AddT2081_Line(aIndent, aIndentData, 'StepDetails', 'Step', 'Percentage', '0006', aPerc6);
    AddT2081_Line(aIndent, aIndentData, 'StepDetails', 'Step', 'Percentage', '0007', aPerc7);
    AddEndTag(TindentMMMMM, 'DivestmentObligation');
  end;

  procedure AddP2SecABlock(aIndentBlock, aIndent: Integer; aPercentage, aAmount, aAcquisition, aDisposition: string);
  begin
    if aPercentage.IsEmpty or aAmount.IsEmpty then Exit;

    AddBeginTag(aIndentBlock, 'ExcessTransactionByFoundation');
    AddTag(aIndent, 'Percentage', aPercentage, False{True});
    AddTag(aIndent, 'Amount', GetRoundedFloatFalue(aAmount), False{True});
    AddTag(aIndent, 'Acquisition', aAcquisition, False{True});
    AddTag(aIndent, 'Disposition', aDisposition, False{True});
    AddEndTag(TindentMMMMM, 'ExcessTransactionByFoundation');
  end;

  procedure AddP2SecBBlock(aIndentBlock, aIndent: Integer; aNameOfPerson, aPercentage, aAmount, aAcquisition, aDisposition: string);
  begin
    if aNameOfPerson.IsEmpty then Exit;

    AddBeginTag(aIndentBlock, 'ExcessTransactionByRelevantPersons');
    AddTag(aIndent, 'NameOfPerson', aNameOfPerson, False{True});
    AddTag(aIndent, 'Percentage', aPercentage, False{True});
    AddTag(aIndent, 'Amount', GetRoundedFloatFalue(aAmount), False{True});
    AddTag(aIndent, 'Acquisition', aAcquisition, False{True});
    AddTag(aIndent, 'Disposition', aDisposition, False{True});
    AddEndTag(TindentMMMMM, 'ExcessTransactionByRelevantPersons');
  end;

var
  lSlipFormCount: Integer;
begin
  addT3010SubmissionTag('BEGIN', AXmlList);
  T3010Rec:= GetT3010Rec(aRetNo, 'T3010');

  with T3010Rec do
  begin
    AddTag(Tindent, 'VendorIdentifier', VendorIdentifier, False{True});
    AddTag(Tindent, 'SoftwareProductIdentifier', SoftwareProductIdentifier, False{True});
    AddTag(Tindent, 'BN15', BN15, False{True});
    AddTag(Tindent, 'FilingPeriodEnd', FilingPeriodEnd, False{True});

    {$region 'CharityAnnualReturnSubmission'}
    AddBeginTag(Tindent, 'CharityAnnualReturnSubmission');
    AddTag(TindentM, 'FormVersion', FormVersion, False{True});

    {$region 'T3010'}
    AddBeginTag(TindentM, 'T3010');
    if not WebAddress.Equals('') or not A1.Equals('') or not A1ParentOrgName.Equals('') or not A1ParentOrgBN.Equals('') or not A2.Equals('') or not A3.Equals('') then
    begin
      AddBeginTag(TindentMM, 'SectionA');
      AddTag(TindentMMM, 'WebAddress', WebAddress);
      AddTag(TindentMMM, 'A1', A1, False{True});

      AddBeginTag(TindentMMM, 'A1Yes');
      if A1.Equals('0001') and (not A1ParentOrgName.Equals('') or not A1ParentOrgBN.Equals('')) then
      begin
        AddTag(TindentMMMM, 'A1ParentOrgName', A1ParentOrgName);
        AddTag(TindentMMMM, 'A1ParentOrgBN', A1ParentOrgBN);
      end;
      AddEndTag(TindentMMM, 'A1Yes');

      AddTag(TindentMMM, 'A2', A2, False{True});
      AddTag(TindentMMM, 'A3', A3, False{True});
      AddEndTag(TindentMM, 'SectionA');
    end;

    if not C1Activity.Equals('') or not NewPrograms.Equals('') or not OngoingPrograms.Equals('') or not C3.Equals('') or not C4.Equals('') or
       IsC6_2500.Equals('0001') or IsC6_2510.Equals('0001') or IsC6_2530.Equals('0001') or IsC6_2540.Equals('0001') or IsC6_2550.Equals('0001') or IsC6_2560.Equals('0001') or
       IsC6_2570.Equals('0001') or IsC6_2575.Equals('0001') or IsC6_2580.Equals('0001') or IsC6_2590.Equals('0001') or IsC6_2600.Equals('0001') or IsC6_2610.Equals('0001') or
       IsC6_2620.Equals('0001') or IsC6_2630.Equals('0001') or IsC6_2640.Equals('0001') or IsC6_2650.Equals('0001') or not C6_OtherSpecify.Equals('') or not C7.Equals('') or
       not C7a.Equals('') or not C7b.Equals('') or IsC7c_2730.Equals('0001') or IsC7c_2740.Equals('0001') or IsC7c_2750.Equals('0001') or IsC7c_2760.Equals('0001') or
       IsC7c_2770.Equals('0001') or IsC7c_2780.Equals('0001') or not C7c_OtherSpecify.Equals('') or not C7d.Equals('') or not C8.Equals('') or not C9.Equals('') or
       not C10.Equals('') or not C11.Equals('') or not C12.Equals('') or not C13.Equals('') or not C14.Equals('') or not C15.Equals('') or not C16_5840.Equals('') or
       not C16_5841.Equals('') or not C16_5842.Equals('') or not C16_5843.Equals('') or not C17_5850.Equals('') or not C18_5860.Equals('') or not C18_5861.Equals('') or
       not C18_5862.Equals('') or not C18_5863.Equals('') or not C18_5864.Equals('') then
    begin
      AddBeginTag(TindentMM, 'SectionC');
      AddTag(TindentMMM, 'C1Activity', C1Activity, False{True});

      if not NewPrograms.Equals('') or not OngoingPrograms.Equals('') then
      begin
        AddBeginTag(TindentMMM, 'C2');
        AddTag(TindentMMMM, 'NewPrograms', NewPrograms);
        AddTag(TindentMMMM, 'OngoingPrograms', OngoingPrograms, False{True});
        AddEndTag(TindentMMM, 'C2');
      end;

      AddTag(TindentMMM, 'C3', C3, False{True});
      AddTag(TindentMMM, 'C4', C4, False{True});

      if IsC6_2500.Equals('0001') or IsC6_2510.Equals('0001') or IsC6_2530.Equals('0001') or IsC6_2540.Equals('0001') or IsC6_2550.Equals('0001') or IsC6_2560.Equals('0001') or
         IsC6_2570.Equals('0001') or IsC6_2575.Equals('0001') or IsC6_2580.Equals('0001') or IsC6_2590.Equals('0001') or IsC6_2600.Equals('0001') or IsC6_2610.Equals('0001') or
         IsC6_2620.Equals('0001') or IsC6_2630.Equals('0001') or IsC6_2640.Equals('0001') or IsC6_2650.Equals('0001') or not C6_OtherSpecify.Equals('') then
      begin
        AddBeginTag(TindentMMM, 'C6');

        if (IsC6_2500.Equals('0001')) then AddTag(TindentMMMM, 'C6Activity', '2500');
        if (IsC6_2510.Equals('0001')) then AddTag(TindentMMMM, 'C6Activity', '2510');
        if (IsC6_2530.Equals('0001')) then AddTag(TindentMMMM, 'C6Activity', '2530');
        if (IsC6_2540.Equals('0001')) then AddTag(TindentMMMM, 'C6Activity', '2540');
        if (IsC6_2550.Equals('0001')) then AddTag(TindentMMMM, 'C6Activity', '2550');
        if (IsC6_2560.Equals('0001')) then AddTag(TindentMMMM, 'C6Activity', '2560');
        if (IsC6_2570.Equals('0001')) then AddTag(TindentMMMM, 'C6Activity', '2570');
        if (IsC6_2575.Equals('0001')) then AddTag(TindentMMMM, 'C6Activity', '2575');
        if (IsC6_2580.Equals('0001')) then AddTag(TindentMMMM, 'C6Activity', '2580');
        if (IsC6_2590.Equals('0001')) then AddTag(TindentMMMM, 'C6Activity', '2590');
        if (IsC6_2600.Equals('0001')) then AddTag(TindentMMMM, 'C6Activity', '2600');
        if (IsC6_2610.Equals('0001')) then AddTag(TindentMMMM, 'C6Activity', '2610');
        if (IsC6_2620.Equals('0001')) then AddTag(TindentMMMM, 'C6Activity', '2620');
        if (IsC6_2630.Equals('0001')) then AddTag(TindentMMMM, 'C6Activity', '2630');
        if (IsC6_2640.Equals('0001')) then AddTag(TindentMMMM, 'C6Activity', '2640');
        if (IsC6_2650.Equals('0001')) then
        begin
          AddTag(TindentMMMM, 'C6Activity', '2650');
          AddTag(TindentMMMM, 'OtherSpecify', C6_OtherSpecify);
        end;
        AddEndTag(TindentMMM, 'C6');
      end;

      AddTag(TindentMMM, 'C7', C7, False{True});
      AddTag(TindentMMM, 'C7a', GetRoundedFloatFalue(C7a));
      AddTag(TindentMMM, 'C7b', GetRoundedFloatFalue(C7b));

      if IsC7c_2730.Equals('0001') or IsC7c_2740.Equals('0001') or IsC7c_2750.Equals('0001') or IsC7c_2760.Equals('0001') or IsC7c_2770.Equals('0001') or IsC7c_2780.Equals('0001') then
      begin
        AddBeginTag(TindentMMM, 'C7c');
        if (IsC7c_2730.Equals('0001')) then AddTag(TindentMMMM, 'C7MethodOfPayment', '2730');
        if (IsC7c_2740.Equals('0001')) then AddTag(TindentMMMM, 'C7MethodOfPayment', '2740');
        if (IsC7c_2750.Equals('0001')) then AddTag(TindentMMMM, 'C7MethodOfPayment', '2750');
        if (IsC7c_2760.Equals('0001')) then AddTag(TindentMMMM, 'C7MethodOfPayment', '2760');
        if (IsC7c_2770.Equals('0001')) then AddTag(TindentMMMM, 'C7MethodOfPayment', '2770');
        if (IsC7c_2780.Equals('0001')) then
        begin
          AddTag(TindentMMMM, 'C7MethodOfPayment', '2780');
          AddTag(TindentMMMM, 'OtherSpecify', C7c_OtherSpecify);
        end;
        AddEndTag(TindentMM, 'C7c');
      end;

      AddTag(TindentMMM, 'C7d', C7d, False{True});
      AddTag(TindentMMM, 'C8', C8, False{True});
      AddTag(TindentMMM, 'C9', C9, False{True});
      AddTag(TindentMMM, 'C10', C10, False{True});
      AddTag(TindentMMM, 'C11', C11, False{True});
      AddTag(TindentMMM, 'C12', C12, False{True});
      AddTag(TindentMMM, 'C13', C13, False{True});
      AddTag(TindentMMM, 'C14', C14, False{True});
      AddTag(TindentMMM, 'C15', C15, False{True});

      if not C16_5840.Equals('') or not C16_5841.Equals('') or not C16_5842.Equals('') or not C16_5843.Equals('') then
      begin
        AddBeginTag(TindentMMM, 'C16');
        AddTag(TindentMMMM, 'C16_5840', C16_5840, False{True});
        AddTag(TindentMMMM, 'C16_5841', C16_5841);
        AddTag(TindentMMMM, 'C16_5842', GetRoundedFloatFalue(C16_5842));
        AddTag(TindentMMMM, 'C16_5843', GetRoundedFloatFalue(C16_5843));
        AddEndTag(TindentMMM, 'C16');
      end;

      if not C17_5850.Equals('') then
      begin
        AddBeginTag(TindentMMM, 'C17');
        AddTag(TindentMMMM, 'C17_5850', C17_5850, False{True});
        AddEndTag(TindentMMM, 'C17');
      end;

      if not C18_5860.Equals('') or not C18_5861.Equals('') or not C18_5862.Equals('') or not C18_5863.Equals('') or not C18_5864.Equals('') then
      begin
        AddBeginTag(TindentMMM, 'C18');
        AddTag(TindentMMMM, 'C18_5860', C18_5860, False{True});
        AddTag(TindentMMMM, 'C18_5861', C18_5861);
        AddTag(TindentMMMM, 'C18_5862', GetRoundedFloatFalue(C18_5862));
        AddTag(TindentMMMM, 'C18_5863', GetRoundedFloatFalue(C18_5863));
        AddTag(TindentMMMM, 'C18_5864', GetRoundedFloatFalue(C18_5864));
        AddEndTag(TindentMMM, 'C18');
      end;

      AddEndTag(TindentMM, 'SectionC');
    end;

    if not SectionDOrSchedule6.Equals('') then
    begin
      AddBeginTag(TindentMM, 'FinancialQuestionnaire');
      AddTag(TindentMMM, 'SectionDOrSchedule6', SectionDOrSchedule6, False{True});
      AddEndTag(TindentMM, 'FinancialQuestionnaire');
    end;

    if not D1.Equals('') or not D2_4050.Equals('') or not D2_4400.Equals('') or not D3_4490.Equals('') or not D3_4565.Equals('') or
       not D4_FinancialInfo_Code_4200_Amt.Equals('') or not D4_FinancialInfo_Code_4350_Amt.Equals('') or not D4_FinancialInfo_Code_4500_Amt.Equals('') or
       not D4_FinancialInfo_Code_4510_Amt.Equals('') or not D4_FinancialInfo_Code_4530_Amt.Equals('') or not D4_FinancialInfo_Code_4570_Amt.Equals('') or
       not D4_FinancialInfo_Code_4571_Amt.Equals('') or not D4_FinancialInfo_Code_4575_Amt.Equals('') or not D4_FinancialInfo_Code_4630_Amt.Equals('') or
       not D4_FinancialInfo_Code_4640_Amt.Equals('') or not D4_FinancialInfo_Code_4650_Amt.Equals('') or not D4_FinancialInfo_Code_4700_Amt.Equals('') or
       not D4_FinancialInfo_Code_4860_Amt.Equals('') or not D4_FinancialInfo_Code_4810_Amt.Equals('') or not D4_FinancialInfo_Code_4920_Amt.Equals('') or
       not D4_FinancialInfo_Code_4950_Amt.Equals('') or not D4_FinancialInfo_Code_5000_Amt.Equals('') or not D4_FinancialInfo_Code_5010_Amt.Equals('') or
       not D4_FinancialInfo_Code_5045_Amt.Equals('') or not D4_FinancialInfo_Code_5050_Amt.Equals('') or not D4_FinancialInfo_Code_5100_Amt.Equals('') then
    begin
      AddBeginTag(TindentMM, 'SectionD');
      AddTag(TindentMMM, 'D1', D1, False{True});
      AddTag(TindentMMM, 'D2_4050', D2_4050); //20250529 Igor
      AddTag(TindentMMM, 'D2_4400', D2_4400); //20250529 Igor
      AddTag(TindentMMM, 'D3_4490', D3_4490); //20250529 Igor
      AddTag(TindentMMM, 'D3_4565', D3_4565); //20250529 Igor

      AddD4_FinancialInfo_Block(TindentMMM, TindentMMMM, '4200', D4_FinancialInfo_Code_4200_Amt);
      AddD4_FinancialInfo_Block(TindentMMM, TindentMMMM, '4350', D4_FinancialInfo_Code_4350_Amt);
      if D3_4490.Equals('0001') then //20250529 Igor
        AddD4_FinancialInfo_Block(TindentMMM, TindentMMMM, '4500', D4_FinancialInfo_Code_4500_Amt); //20250529 Igor
      AddD4_FinancialInfo_Block(TindentMMM, TindentMMMM, '4510', D4_FinancialInfo_Code_4510_Amt);
      AddD4_FinancialInfo_Block(TindentMMM, TindentMMMM, '4530', D4_FinancialInfo_Code_4530_Amt);
      if D3_4565.Equals('0001') then //20250529 Igor
        AddD4_FinancialInfo_Block(TindentMMM, TindentMMMM, '4570', D4_FinancialInfo_Code_4570_Amt); //20250529 Igor
      AddD4_FinancialInfo_Block(TindentMMM, TindentMMMM, '4571', D4_FinancialInfo_Code_4571_Amt);
      AddD4_FinancialInfo_Block(TindentMMM, TindentMMMM, '4575', D4_FinancialInfo_Code_4575_Amt);
      AddD4_FinancialInfo_Block(TindentMMM, TindentMMMM, '4630', D4_FinancialInfo_Code_4630_Amt);
      AddD4_FinancialInfo_Block(TindentMMM, TindentMMMM, '4640', D4_FinancialInfo_Code_4640_Amt);
      AddD4_FinancialInfo_Block(TindentMMM, TindentMMMM, '4650', D4_FinancialInfo_Code_4650_Amt);
      AddD4_FinancialInfo_Block(TindentMMM, TindentMMMM, '4700', D4_FinancialInfo_Code_4700_Amt);
      AddD4_FinancialInfo_Block(TindentMMM, TindentMMMM, '4860', D4_FinancialInfo_Code_4860_Amt);
      AddD4_FinancialInfo_Block(TindentMMM, TindentMMMM, '4810', D4_FinancialInfo_Code_4810_Amt);
      AddD4_FinancialInfo_Block(TindentMMM, TindentMMMM, '4920', D4_FinancialInfo_Code_4920_Amt);
      AddD4_FinancialInfo_Block(TindentMMM, TindentMMMM, '4950', D4_FinancialInfo_Code_4950_Amt);
      AddD4_FinancialInfo_Block(TindentMMM, TindentMMMM, '5000', D4_FinancialInfo_Code_5000_Amt);
      AddD4_FinancialInfo_Block(TindentMMM, TindentMMMM, '5010', D4_FinancialInfo_Code_5010_Amt);
      AddD4_FinancialInfo_Block(TindentMMM, TindentMMMM, '5045', D4_FinancialInfo_Code_5045_Amt);
      AddD4_FinancialInfo_Block(TindentMMM, TindentMMMM, '5050', D4_FinancialInfo_Code_5050_Amt);
      AddD4_FinancialInfo_Block(TindentMMM, TindentMMMM, '5100', D4_FinancialInfo_Code_5100_Amt);
      AddEndTag(TindentMM, 'SectionD');
    end;

    if not SectionE_Name.Equals('') or not SectionE_Position.Equals('') or not SectionE_Date.Equals('') or not SecE_Telephone.Equals('') then
    begin
      AddBeginTag(TindentMM, 'SectionE');
      AddTag(TindentMMM, 'Name', SectionE_Name, False{True});
      AddTag(TindentMMM, 'Position', SectionE_Position, False{True});
      AddTag(TindentMMM, 'Date', SectionE_Date, False{True});

      if not SecE_Telephone.Equals('') then
      begin
        AddBeginTag(TindentMMM, 'TelephoneNumber');
        AddTag(TindentMMMM, 'Telephone', SecE_Telephone, False{True});
        AddEndTag(TindentMMM, 'TelephoneNumber');
      end;

      AddEndTag(TindentMM, 'SectionE');
    end;

    if not SecF_F2_ContactName.Equals('') or not SecF_F2_CompanyName.Equals('') or not SecF_F2_Address1.Equals('') or not SecF_F2_Address2.Equals('') or
       not SecF_F2_City.Equals('') or not SecF_F2_ProvinceState.Equals('') or not SecF_F2_PostalZipCode.Equals('') or not SecF_F2_Telephone.Equals('') or not SecF_F2_SameAsSectionE.Equals('') then
    begin
      AddBeginTag(TindentMM, 'SectionF');
      AddBeginTag(TindentMMM, 'F2');
      AddTag(TindentMMMM, 'ContactName', SecF_F2_ContactName, False{True});
      AddTag(TindentMMMM, 'CompanyName', SecF_F2_CompanyName);

      if not SecF_F2_Address1.Equals('') or not SecF_F2_Address2.Equals('') or not SecF_F2_City.Equals('') or not SecF_F2_ProvinceState.Equals('') or not SecF_F2_PostalZipCode.Equals('') then
      begin
        AddBeginTag(TindentMMMM, 'Address');
        AddTag(TindentMMMMM, 'Address1', SecF_F2_Address1, False{True});
        AddTag(TindentMMMMM, 'Address2', SecF_F2_Address2);
        AddTag(TindentMMMMM, 'City', SecF_F2_City, False{True});
        AddTag(TindentMMMMM, 'ProvinceState', SecF_F2_ProvinceState, False{True});
        AddTag(TindentMMMMM, 'PostalZipCode', SecF_F2_PostalZipCode, False{True});
    //		AddTag(TindentMMMMM, 'CountryCode', SecF_F2_CountryCode, True); //20250529 Igor
        AddEndTag(TindentMMMM, 'Address');
      end;

      if not SecF_F2_Telephone.Equals('') then
      begin
        AddBeginTag(TindentMMMM, 'Telephone');
        AddTag(TindentMMMMM, 'Telephone', SecF_F2_Telephone, False{True});
        AddEndTag(TindentMMMM, 'Telephone');
      end;

      AddTag(TindentMMMM, 'SameAsSectionE', SecF_F2_SameAsSectionE, False{True});
      AddEndTag(TindentMMM, 'F2');
      AddEndTag(TindentMM, 'SectionF');
    end;

    if A3.Equals('0001') then // if 1600 = Yes
    begin
      if not Schedule1_1.IsEmpty() or not Schedule1_2.IsEmpty() or not Schedule1_Q3_111.IsEmpty() and not Schedule1_Q3_112.IsEmpty() or not Schedule1_4.IsEmpty() and not Schedule1_5.IsEmpty() then
      begin
        AddBeginTag(TindentMM, 'Schedule1');
        AddTag(TindentMMM, 'Schedule1_1', Schedule1_1); //20250529 Igor
        AddTag(TindentMMM, 'Schedule1_2', Schedule1_2); //20250529 Igor

        if not Schedule1_Q3_111.IsEmpty() and not Schedule1_Q3_112.IsEmpty() then
        begin
          AddBeginTag(TindentMMM, 'Schedule1_3');
          AddTag(TindentMMMM, 'Schedule1_Q3_111', GetRoundedFloatFalue(Schedule1_Q3_111));
          AddTag(TindentMMMM, 'Schedule1_Q3_112', GetRoundedFloatFalue(Schedule1_Q3_112));
          AddEndTag(TindentMMM, 'Schedule1_3');
        end;

        AddTag(TindentMMM, 'Schedule1_4', Schedule1_4); //20250529 Igor
        AddTag(TindentMMM, 'Schedule1_5', Schedule1_5); //20250529 Igor
        AddEndTag(TindentMM, 'Schedule1');
      end;
    end;

    if C4.Equals('0001') then // if 2100 = Yes
    begin
      AddBeginTag(TindentMM, 'Schedule2');

      AddTag(TindentMMM, 'Schedule2_1_200', GetRoundedFloatFalue(Schedule2_1_200));
			AddTag(TindentMMM, 'Schedule2_2_210', Schedule2_2_210); //20250529 Igor

      if Schedule2_2_210.Equals('0001') then
      begin
        AddBeginTag(TindentMMM, 'Schedule2_2_210ForeignActivity');
        AddSchedule2_210_line(TindentMMMM, TindentMMMMM, Sch2_2_210_FA_Name1, Sch2_2_210_FA_CountryCode1, Sch2_2_210_FA_Amount1);
        AddSchedule2_210_line(TindentMMMM, TindentMMMMM, Sch2_2_210_FA_Name2, Sch2_2_210_FA_CountryCode2, Sch2_2_210_FA_Amount2);
        AddSchedule2_210_line(TindentMMMM, TindentMMMMM, Sch2_2_210_FA_Name3, Sch2_2_210_FA_CountryCode3, Sch2_2_210_FA_Amount3);
        AddSchedule2_210_line(TindentMMMM, TindentMMMMM, Sch2_2_210_FA_Name4, Sch2_2_210_FA_CountryCode4, Sch2_2_210_FA_Amount4);
        AddSchedule2_210_line(TindentMMMM, TindentMMMMM, Sch2_2_210_FA_Name5, Sch2_2_210_FA_CountryCode5, Sch2_2_210_FA_Amount5);
        AddEndTag(TindentMMM, 'Schedule2_2_210ForeignActivity');
      end;

      AddBeginTag(TindentMMM, 'Schedule2_3');

      AddSchedule2_3_line(TindentMMMM, Sch2_2_3_CountryCode1);
      AddSchedule2_3_line(TindentMMMM, Sch2_2_3_CountryCode2);
      AddSchedule2_3_line(TindentMMMM, Sch2_2_3_CountryCode3);
      AddSchedule2_3_line(TindentMMMM, Sch2_2_3_CountryCode4);
      AddSchedule2_3_line(TindentMMMM, Sch2_2_3_CountryCode5);
      AddSchedule2_3_line(TindentMMMM, Sch2_2_3_CountryCode6);
      AddSchedule2_3_line(TindentMMMM, Sch2_2_3_CountryCode7);
      AddSchedule2_3_line(TindentMMMM, Sch2_2_3_CountryCode8);
      AddSchedule2_3_line(TindentMMMM, Sch2_2_3_CountryCode9);
      AddSchedule2_3_line(TindentMMMM, Sch2_2_3_CountryCode10);
      AddEndTag(TindentMMM, 'Schedule2_3');

      AddTag(TindentMMM, 'Schedule2_4', Schedule2_4); //20250529 Igor
      if Schedule2_4.Equals('0001') then
        AddTag(TindentMMM, 'Schedule2_4_230', GetRoundedFloatFalue(Schedule2_4_230)); //20250529 Igor

			AddTag(TindentMMM, 'Schedule2_5', Schedule2_5); //20250529 Igor
			AddTag(TindentMMM, 'Schedule2_6', Schedule2_6); //20250529 Igor
			AddTag(TindentMMM, 'Schedule2_7', Schedule2_7); //20250529 Igor

      if Schedule2_7.Equals('0001') then
      begin
        AddBeginTag(TindentMMM, 'Exports');
        AddSchedule2_7_Export_line(TindentMMMM, TindentMMMMM, Sch2_7_Item1, Sch2_7_Value1, Sch2_7_Destination1, Sch2_7_CountryCode1);
        AddSchedule2_7_Export_line(TindentMMMM, TindentMMMMM, Sch2_7_Item2, Sch2_7_Value2, Sch2_7_Destination2, Sch2_7_CountryCode2);
        AddSchedule2_7_Export_line(TindentMMMM, TindentMMMMM, Sch2_7_Item3, Sch2_7_Value3, Sch2_7_Destination3, Sch2_7_CountryCode3);
        AddSchedule2_7_Export_line(TindentMMMM, TindentMMMMM, Sch2_7_Item4, Sch2_7_Value4, Sch2_7_Destination4, Sch2_7_CountryCode4);
        AddSchedule2_7_Export_line(TindentMMMM, TindentMMMMM, Sch2_7_Item5, Sch2_7_Value5, Sch2_7_Destination5, Sch2_7_CountryCode5);
        AddEndTag(TindentMMM, 'Exports');
      end;

      AddEndTag(TindentMM, 'Schedule2');
    end;

    if C9.Equals('0001') then
    begin
      AddBeginTag(TindentMM, 'Schedule3');
      AddTag(TindentMMM, 'Schedule3_1a', Schedule3_1a); //20250529 Igor

      AddBeginTag(TindentMMM, 'Schedule3_1b');
      AddSchedule3_1b_line(TindentMMMM, TindentMMMMM, '305', Sch3_1b_305_Count);
      AddSchedule3_1b_line(TindentMMMM, TindentMMMMM, '310', Sch3_1b_310_Count);
      AddSchedule3_1b_line(TindentMMMM, TindentMMMMM, '315', Sch3_1b_315_Count);
      AddSchedule3_1b_line(TindentMMMM, TindentMMMMM, '320', Sch3_1b_320_Count);
      AddSchedule3_1b_line(TindentMMMM, TindentMMMMM, '325', Sch3_1b_325_Count);
      AddSchedule3_1b_line(TindentMMMM, TindentMMMMM, '330', Sch3_1b_330_Count);
      AddSchedule3_1b_line(TindentMMMM, TindentMMMMM, '335', Sch3_1b_335_Count);
      AddSchedule3_1b_line(TindentMMMM, TindentMMMMM, '340', Sch3_1b_340_Count);
      AddSchedule3_1b_line(TindentMMMM, TindentMMMMM, '345', Sch3_1b_345_Count);
      AddEndTag(TindentMMM, 'Schedule3_1b');

      AddTag(TindentMMM, 'Schedule3_2a', Schedule3_2a);
      AddTag(TindentMMM, 'Schedule3_2b', GetRoundedFloatFalue(Schedule3_2b));
      AddTag(TindentMMM, 'Schedule3_3', GetRoundedFloatFalue(Schedule3_3));

      AddEndTag(TindentMM, 'Schedule3');
    end;

    if C10.Equals('0001') then
    begin
      AddBeginTag(TindentMM, 'Schedule4');
      AddBeginTag(TindentMMM, 'Schedule4_1');
      AddSchedule4_1_line(TindentMMMM, TindentMMMMM, Schedule4_1_Name1, Schedule4_1_AtArmsLength1);
      AddSchedule4_1_line(TindentMMMM, TindentMMMMM, Schedule4_1_Name2, Schedule4_1_AtArmsLength2);
      AddSchedule4_1_line(TindentMMMM, TindentMMMMM, Schedule4_1_Name3, Schedule4_1_AtArmsLength3);
      AddSchedule4_1_line(TindentMMMM, TindentMMMMM, Schedule4_1_Name4, Schedule4_1_AtArmsLength4);
      AddEndTag(TindentMMM, 'Schedule4_1');

      AddBeginTag(TindentMMM, 'Schedule4_2');
      AddSchedule4_2_line(TindentMMMM, TindentMMMMM, Schedule4_2_Name1, Schedule4_2_Value1, Schedule4_2_Type1);
      AddSchedule4_2_line(TindentMMMM, TindentMMMMM, Schedule4_2_Name2, Schedule4_2_Value2, Schedule4_2_Type2);
      AddSchedule4_2_line(TindentMMMM, TindentMMMMM, Schedule4_2_Name3, Schedule4_2_Value3, Schedule4_2_Type3);
      AddSchedule4_2_line(TindentMMMM, TindentMMMMM, Schedule4_2_Name4, Schedule4_2_Value4, Schedule4_2_Type4);
      AddEndTag(TindentMMM, 'Schedule4_2');

      AddEndTag(TindentMM, 'Schedule4');
    end;

    if C11.Equals('0001') then
    begin
      AddBeginTag(TindentMM, 'Schedule5');
      AddBeginTag(TindentMMM, 'Schedule5_1');
      if Schedule5_1_Kind_500.Equals('0001') then
        AddTag(TindentMMMM, 'Kind', '500');
      if Schedule5_1_Kind_505.Equals('0001') then
        AddTag(TindentMMMM, 'Kind', '505');
      if Schedule5_1_Kind_510.Equals('0001') then
        AddTag(TindentMMMM, 'Kind', '510');
      if Schedule5_1_Kind_515.Equals('0001') then
        AddTag(TindentMMMM, 'Kind', '515');
      if Schedule5_1_Kind_520.Equals('0001') then
        AddTag(TindentMMMM, 'Kind', '520');
      if Schedule5_1_Kind_525.Equals('0001') then
        AddTag(TindentMMMM, 'Kind', '525');
      if Schedule5_1_Kind_530.Equals('0001') then
        AddTag(TindentMMMM, 'Kind', '530');
      if Schedule5_1_Kind_535.Equals('0001') then
        AddTag(TindentMMMM, 'Kind', '535');
      if Schedule5_1_Kind_540.Equals('0001') then
        AddTag(TindentMMMM, 'Kind', '540');
      if Schedule5_1_Kind_545.Equals('0001') then
        AddTag(TindentMMMM, 'Kind', '545');
      if Schedule5_1_Kind_550.Equals('0001') then
        AddTag(TindentMMMM, 'Kind', '550');
      if Schedule5_1_Kind_555.Equals('0001') then
        AddTag(TindentMMMM, 'Kind', '555');
      if Schedule5_1_Kind_560.Equals('0001') then
      begin
        AddTag(TindentMMMM, 'Kind', '560');
        AddTag(TindentMMMM, 'OtherSpecify', Schedule5_1_OtherSpecify);
      end;
      AddEndTag(TindentMMM, 'Schedule5_1');
      AddTag(TindentMMM, 'Schedule5_2_580', GetRoundedFloatFalue(Schedule5_2_580));
      AddEndTag(TindentMM, 'Schedule5');
    end;

    if SectionDOrSchedule6.Equals('0002') then
    begin
      AddBeginTag(TindentMM, 'Schedule6');
      AddTag(TindentMMM, 'Schedule6_4020', Schedule6_4020); //20250529 Igor
      AddBeginTag(TindentMMM, 'Schedule6_Assets');
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Asset', '4100', Schedule6_4100_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Asset', '4101', Schedule6_4101_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Asset', '4102', Schedule6_4102_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Asset', '4110', Schedule6_4110_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Asset', '4120', Schedule6_4120_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Asset', '4130', Schedule6_4130_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Asset', '4140', Schedule6_4140_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Asset', '4150', Schedule6_4150_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Asset', '4155', Schedule6_4155_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Asset', '4157', Schedule6_4157_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Asset', '4158', Schedule6_4158_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Asset', '4160', Schedule6_4160_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Asset', '4165', Schedule6_4165_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Asset', '4166', Schedule6_4166_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Asset', '4170', Schedule6_4170_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Asset', '4190', Schedule6_4190_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Asset', '4200', Schedule6_4200_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Asset', '4250', Schedule6_4250_Value);
      AddEndTag(TindentMMM, 'Schedule6_Assets');

      AddBeginTag(TindentMMM, 'Schedule6_Liabilities');
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Liability', '4300', Schedule6_4300_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Liability', '4310', Schedule6_4310_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Liability', '4320', Schedule6_4320_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Liability', '4330', Schedule6_4330_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Liability', '4350', Schedule6_4350_Value);
      AddEndTag(TindentMMM, 'Schedule6_Liabilities');

      AddBeginTag(TindentMMM, 'Schedule6_Revenue');
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Revenue', '4500', Schedule6_4500_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Revenue', '4610', Schedule6_5610_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Revenue', '4510', Schedule6_4510_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Revenue', '4530', Schedule6_4530_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Revenue', '4540', Schedule6_4540_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Revenue', '4550', Schedule6_4550_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Revenue', '4560', Schedule6_4560_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Revenue', '4571', Schedule6_4571_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Revenue', '4575', Schedule6_4575_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Revenue', '4576', Schedule6_4576_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Revenue', '4577', Schedule6_4577_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Revenue', '4580', Schedule6_4580_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Revenue', '4590', Schedule6_4590_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Revenue', '4600', Schedule6_4600_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Revenue', '4610', Schedule6_4610_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Revenue', '4620', Schedule6_4620_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Revenue', '4630', Schedule6_4630_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Revenue', '4640', Schedule6_4640_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Revenue', '4650', Schedule6_4650_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Revenue', '4700', Schedule6_4700_Value);
      AddTag(TindentMMMM, 'Schedule6_Revenue_4655', GetRoundedFloatFalue(Schedule6_Revenue_4655));
      AddEndTag(TindentMMM, 'Schedule6_Revenue');

      AddBeginTag(TindentMMM, 'Schedule6_Expenditures');
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Expenditure', '4800', Schedule6_4800_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Expenditure', '4810', Schedule6_4810_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Expenditure', '4820', Schedule6_4820_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Expenditure', '4830', Schedule6_4830_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Expenditure', '4840', Schedule6_4840_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Expenditure', '4850', Schedule6_4850_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Expenditure', '4860', Schedule6_4860_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Expenditure', '4870', Schedule6_4870_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Expenditure', '4880', Schedule6_4880_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Expenditure', '4890', Schedule6_4890_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Expenditure', '4891', Schedule6_4891_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Expenditure', '4900', Schedule6_4900_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Expenditure', '4910', Schedule6_4910_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Expenditure', '4920', Schedule6_4920_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Expenditure', '4950', Schedule6_4950_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Expenditure', '5000', Schedule6_5000_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Expenditure', '5010', Schedule6_5010_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Expenditure', '5020', Schedule6_5020_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Expenditure', '5040', Schedule6_5040_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Expenditure', '5045', Schedule6_5045_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Expenditure', '5050', Schedule6_5050_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'Expenditure', '5100', Schedule6_5100_Value);
      AddTag(TindentMMMM, 'Schedule6_Expenditures_4930', GetRoundedFloatFalue(Schedule6_Expenditures_4930));
      AddEndTag(TindentMMM, 'Schedule6_Expenditures');

      AddBeginTag(TindentMMM, 'Schedule6_Other');
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'OtherFinInfo', '5500', Schedule6_5500_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'OtherFinInfo', '5510', Schedule6_5510_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'OtherFinInfo', '5750', Schedule6_5750_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'OtherFinInfo', '5900', Schedule6_5900_Value);
      AddSchedule6_Block_Line(TindentMMMM, TindentMMMMM, 'OtherFinInfo', '5910', Schedule6_5910_Value);
      AddEndTag(TindentMMM, 'Schedule6_Other');
      AddEndTag(TindentMM, 'Schedule6');
    end;

    if C17_5850.Equals('0001') and SectionDOrSchedule6.Equals('0002') then
    begin
      AddBeginTag(TindentMM, 'Schedule8');
      AddBeginTag(TindentMMM, 'Schedule8_CurrentFP');
			AddBeginTag(TindentMMMM, 'Schedule8_CurrentFPRequirement');
      AddSchedule6_Block_Line(TindentMMMMM, TindentMMMMMM, 'S8_CurrentFPRequirement', '810', Schedule8_810_Value);
      AddEndTag(TindentMMMM, 'Schedule8_CurrentFPRequirement'); //20250529 Igor
			AddEndTag(TindentMMM, 'Schedule8_CurrentFP'); //20250529 Igor
      AddEndTag(TindentMM, 'Schedule8');
    end;

    AddEndTag(TindentM, 'T3010');
    {$endregion 'T3010'}

    {$region 'T1235'}
    for i:= 0 to pred(FList.Count) do
    begin
      FRec:= FList.Items[i];

      if (FRec.FormName = 'T1235') and (Ret[aRetNo].FrmHasData[Frec.FormNo]) then
      begin
        T1235SlipRec:= GetT1235SlipRec(aRetNo, FRec.FormName + FRec.FormInst);

        if (StrToIntDef(T1235SlipRec.TotalNumberCharityOfficials, 0) > 0) then
        with T1235SlipRec do
        begin
          AddBeginTag(TindentM, 'T1235');
          AddTag(TindentMM, 'TotalNumberCharityOfficials', TotalNumberCharityOfficials);

          for j:= 0 to pred(length(T1235SlipDetails)) do
          with T1235SlipDetails[j] do
          begin
            if not PInf_LastName.IsEmpty() or not PInf_FirstName.IsEmpty() or not PInf_Initial.IsEmpty() or not PInf_Term_StartDate.IsEmpty() or not PInf_Term_EndDate.IsEmpty() or
               not PInf_Position.IsEmpty() or not PInf_AtArmsLength.IsEmpty() or not CInf_Address1.IsEmpty() or not CInf_Address2.IsEmpty() or not CInf_City.IsEmpty() or
               not CInf_PostalZipCode.IsEmpty() or not CInf_Telephone.IsEmpty() or not CInf_DateOfBirth.IsEmpty() then
            begin
              AddBeginTag(TindentMM, 'DirectorTrustee');

              if not PInf_LastName.IsEmpty() or not PInf_FirstName.IsEmpty() or not PInf_Initial.IsEmpty() or not PInf_Term_StartDate.IsEmpty() or not PInf_Term_EndDate.IsEmpty() or
                 not PInf_Position.IsEmpty() or not PInf_AtArmsLength.IsEmpty() then
              begin
                AddBeginTag(TindentMMM, 'PublicInformation');
                AddTag(TindentMMMM, 'LastName', PInf_LastName);
                AddTag(TindentMMMM, 'FirstName', PInf_FirstName);
                AddTag(TindentMMMM, 'Initial', PInf_Initial);

                if not PInf_Term_StartDate.IsEmpty() or not PInf_Term_EndDate.IsEmpty() then
                begin
                  AddBeginTag(TindentMMMM, 'Term');
                  AddTag(TindentMMMMM, 'StartDate', PInf_Term_StartDate);
                  AddTag(TindentMMMMM, 'EndDate', PInf_Term_EndDate);
                  AddEndTag(TindentMMMM, 'Term');
                end;

                AddTag(TindentMMMM, 'Position', PInf_Position);
                AddTag(TindentMMMM, 'AtArmsLength', PInf_AtArmsLength);
                AddEndTag(TindentMMM, 'PublicInformation');
              end;

              if not CInf_Address1.IsEmpty() or not CInf_Address2.IsEmpty() or not CInf_City.IsEmpty() or not CInf_PostalZipCode.IsEmpty() or not CInf_Telephone.IsEmpty() or not CInf_DateOfBirth.IsEmpty() then
              begin
                AddBeginTag(TindentMMM, 'ConfidentialInformation');

                if not CInf_Address1.IsEmpty() or not CInf_Address2.IsEmpty() or not CInf_City.IsEmpty() or not CInf_PostalZipCode.IsEmpty() then
                begin
                  AddBeginTag(TindentMMMM, 'Address');
                  AddTag(TindentMMMMM, 'Address1', CInf_Address1); //20250529 Igor
                  AddTag(TindentMMMMM, 'Address2', CInf_Address2); //20250529 Igor
                  AddTag(TindentMMMMM, 'City', CInf_City);
                  AddTag(TindentMMMMM, 'PostalZipCode', CInf_PostalZipCode);
                  AddEndTag(TindentMMMM, 'Address');
                end;

                if not CInf_Telephone.IsEmpty() then
                begin
                  AddBeginTag(TindentMMMM, 'Telephone');
                  AddTag(TindentMMMMM, 'Telephone', CInf_Telephone);
                  AddEndTag(TindentMMMM, 'Telephone');
                end;

                AddTag(TindentMMMM, 'DateOfBirth', CInf_DateOfBirth);
                AddEndTag(TindentMMM, 'ConfidentialInformation');
              end;

              AddEndTag(TindentMM, 'DirectorTrustee');
            end;
          end;
          AddEndTag(TindentM, 'T1235');
        end;
      end;
    end;
    {$endregion 'T1235'}

    {$region 'T2081'}
    if Schedule1_5.Equals('0001') then
    begin
      for i:= 0 to pred(FList.Count) do
      begin
        FRec:= FList.Items[i];

        if (FRec.FormName = 'T2081') then
        begin
          T2081Rec:= GetT2081Rec(aRetNo, FRec.FormName);
          with T2081Rec do
          if not CorporationName.IsEmpty() or not ClassOfShares.IsEmpty() or not TotalIssuedShares.IsEmpty() or not ShareValue.IsEmpty() or not SharesListedOnStockExchange.IsEmpty() or
             not SecB_Percentage905.IsEmpty() or not SecB_Percentage910.IsEmpty() or not SecB_Percentage915.IsEmpty() or not SecB_Percentage920.IsEmpty() or
             not SecC_Percentage925.IsEmpty() or not SecC_Percentage930.IsEmpty() or not SecC_Percentage935.IsEmpty() or not SecC_Percentage940.IsEmpty() or
             not SecD_PercentageBelow945.IsEmpty() or not SecD_PercentageBelow950.IsEmpty() or not SecD_PercentageBelow955.IsEmpty() or not SecD_PercentageGreater941.IsEmpty() or
               not SecD_PercentageGreater945.IsEmpty() or not SecD_PercentageGreater946.IsEmpty() or not SecD_PercentageGreater947.IsEmpty() or not SecD_PercentageGreater948.IsEmpty() or
               not SecD_PercentageGreater949.IsEmpty() or not SecD_PercentageGreater950.IsEmpty() or not SecD_PercentageGreater955.IsEmpty() or
               not SecE_Percentage960.IsEmpty() or not SecE_Percentage965.IsEmpty() or not SecE_Percentage970.IsEmpty() or not SecE_Percentage975.IsEmpty() or
               (Length(T2081SecFInfo) > 0) or not ExcessTransactionsPresent.IsEmpty() or (length(Part2SecAInfo) > 0) or (length(Part2SecBInfo) > 0) then
          begin
            AddBeginTag(TindentM, 'T2081');
            AddBeginTag(TindentMM, 'CorporateWorksheet');

            if not CorporationName.IsEmpty() or not ClassOfShares.IsEmpty() or not TotalIssuedShares.IsEmpty() or not ShareValue.IsEmpty() or not SharesListedOnStockExchange.IsEmpty() or
               not SecB_Percentage905.IsEmpty() or not SecB_Percentage910.IsEmpty() or not SecB_Percentage915.IsEmpty() or not SecB_Percentage920.IsEmpty() or
               not SecC_Percentage925.IsEmpty() or not SecC_Percentage930.IsEmpty() or not SecC_Percentage935.IsEmpty() or not SecC_Percentage940.IsEmpty() or
               not SecD_PercentageBelow945.IsEmpty() or not SecD_PercentageBelow950.IsEmpty() or not SecD_PercentageBelow955.IsEmpty() or not SecD_PercentageGreater941.IsEmpty() or
                 not SecD_PercentageGreater945.IsEmpty() or not SecD_PercentageGreater946.IsEmpty() or not SecD_PercentageGreater947.IsEmpty() or not SecD_PercentageGreater948.IsEmpty() or
                 not SecD_PercentageGreater949.IsEmpty() or not SecD_PercentageGreater950.IsEmpty() or not SecD_PercentageGreater955.IsEmpty() or
                 not SecE_Percentage960.IsEmpty() or not SecE_Percentage965.IsEmpty() or not SecE_Percentage970.IsEmpty() or not SecE_Percentage975.IsEmpty() or
                 (Length(T2081SecFInfo) > 0) then
            begin
              AddBeginTag(TindentMMM, 'Part1');

              if not CorporationName.IsEmpty() or not ClassOfShares.IsEmpty() or not TotalIssuedShares.IsEmpty() or not ShareValue.IsEmpty() or not SharesListedOnStockExchange.IsEmpty() then
              begin
                AddBeginTag(TindentMMMM, 'SectionA');
                AddTag(TindentMMMMM, 'CorporationName', CorporationName);
                AddTag(TindentMMMMM, 'ClassOfShares', ClassOfShares);
                AddTag(TindentMMMMM, 'TotalIssuedShares', TotalIssuedShares);
                AddTag(TindentMMMMM, 'ShareValue', ShareValue);
                AddTag(TindentMMMMM, 'SharesListedOnStockExchange', SharesListedOnStockExchange);
                AddEndTag(TindentMMMM, 'SectionA');
              end;

              if not SecB_Percentage905.IsEmpty() or not SecB_Percentage910.IsEmpty() or not SecB_Percentage915.IsEmpty() or not SecB_Percentage920.IsEmpty() then
              begin
                AddBeginTag(TindentMMMM, 'SectionB');
                AddT2081_Line(TindentMMMMM, TindentMMMMMM, 'OriginalHoldingPercentage', 'Code', 'Percentage', '905', SecB_Percentage905);
                AddT2081_Line(TindentMMMMM, TindentMMMMMM, 'OriginalHoldingPercentage', 'Code', 'Percentage', '910', SecB_Percentage910);
                AddT2081_Line(TindentMMMMM, TindentMMMMMM, 'OriginalHoldingPercentage', 'Code', 'Percentage', '915', SecB_Percentage915);
                AddT2081_Line(TindentMMMMM, TindentMMMMMM, 'OriginalHoldingPercentage', 'Code', 'Percentage', '920', SecB_Percentage920);
                AddEndTag(TindentMMMM, 'SectionB');
              end;

              if not SecC_Percentage925.IsEmpty() or not SecC_Percentage930.IsEmpty() or not SecC_Percentage935.IsEmpty() or not SecC_Percentage940.IsEmpty() then
              begin
                AddBeginTag(TindentMMMM, 'SectionC');
                AddT2081_Line(TindentMMMMM, TindentMMMMMM, 'FiscalEndHoldingPercentage', 'Code', 'Percentage', '925', SecC_Percentage925);
                AddT2081_Line(TindentMMMMM, TindentMMMMMM, 'FiscalEndHoldingPercentage', 'Code', 'Percentage', '930', SecC_Percentage930);
                AddT2081_Line(TindentMMMMM, TindentMMMMMM, 'FiscalEndHoldingPercentage', 'Code', 'Percentage', '935', SecC_Percentage935);
                AddT2081_Line(TindentMMMMM, TindentMMMMMM, 'FiscalEndHoldingPercentage', 'Code', 'Percentage', '940', SecC_Percentage940);
                AddEndTag(TindentMMMM, 'SectionC');
              end;

              if not SecD_PercentageBelow945.IsEmpty() or not SecD_PercentageBelow950.IsEmpty() or not SecD_PercentageBelow955.IsEmpty() or not SecD_PercentageGreater941.IsEmpty() or
                 not SecD_PercentageGreater945.IsEmpty() or not SecD_PercentageGreater946.IsEmpty() or not SecD_PercentageGreater947.IsEmpty() or not SecD_PercentageGreater948.IsEmpty() or
                 not SecD_PercentageGreater949.IsEmpty() or not SecD_PercentageGreater950.IsEmpty() or not SecD_PercentageGreater955.IsEmpty() then
              begin
                AddBeginTag(TindentMMMM, 'SectionD');
                AddT2081_Line(TindentMMMMM, TindentMMMMMM, 'ExcessPercentageBelowSpecifiedAmount', 'Code', 'Percentage', '945', SecD_PercentageBelow945);
                AddT2081_Line(TindentMMMMM, TindentMMMMMM, 'ExcessPercentageBelowSpecifiedAmount', 'Code', 'Percentage', '950', SecD_PercentageBelow950);
                AddT2081_Line(TindentMMMMM, TindentMMMMMM, 'ExcessPercentageBelowSpecifiedAmount', 'Code', 'Percentage', '955', SecD_PercentageBelow955);
                AddT2081_Line(TindentMMMMM, TindentMMMMMM, 'ExcessPercentageGreaterSpecifiedAmount', 'Code', 'Percentage', '941', SecD_PercentageGreater941);
                AddT2081_Line(TindentMMMMM, TindentMMMMMM, 'ExcessPercentageGreaterSpecifiedAmount', 'Code', 'Percentage', '945', SecD_PercentageGreater945);
                AddT2081_Line(TindentMMMMM, TindentMMMMMM, 'ExcessPercentageGreaterSpecifiedAmount', 'Code', 'Percentage', '946', SecD_PercentageGreater946);
                AddT2081_Line(TindentMMMMM, TindentMMMMMM, 'ExcessPercentageGreaterSpecifiedAmount', 'Code', 'Percentage', '947', SecD_PercentageGreater947);
                AddT2081_Line(TindentMMMMM, TindentMMMMMM, 'ExcessPercentageGreaterSpecifiedAmount', 'Code', 'Percentage', '948', SecD_PercentageGreater948);
                AddT2081_Line(TindentMMMMM, TindentMMMMMM, 'ExcessPercentageGreaterSpecifiedAmount', 'Code', 'Percentage', '949', SecD_PercentageGreater949);
                AddT2081_Line(TindentMMMMM, TindentMMMMMM, 'ExcessPercentageGreaterSpecifiedAmount', 'Code', 'Percentage', '950', SecD_PercentageGreater950);
                AddT2081_Line(TindentMMMMM, TindentMMMMMM, 'ExcessPercentageGreaterSpecifiedAmount', 'Code', 'Percentage', '955', SecD_PercentageGreater955);
                AddEndTag(TindentMMMM, 'SectionD');
              end;

              if not SecE_Percentage960.IsEmpty() or not SecE_Percentage965.IsEmpty() or not SecE_Percentage970.IsEmpty() or not SecE_Percentage975.IsEmpty() then
              begin
                AddBeginTag(TindentMMMM, 'SectionE');
                AddT2081_Line(TindentMMMMM, TindentMMMMMM, 'NetIncreaseDecreasePercentage', 'Code', 'Percentage', '960', SecE_Percentage960);
                AddT2081_Line(TindentMMMMM, TindentMMMMMM, 'NetIncreaseDecreasePercentage', 'Code', 'Percentage', '965', SecE_Percentage965);
                AddT2081_Line(TindentMMMMM, TindentMMMMMM, 'NetIncreaseDecreasePercentage', 'Code', 'Percentage', '970', SecE_Percentage970);
                AddT2081_Line(TindentMMMMM, TindentMMMMMM, 'NetIncreaseDecreasePercentage', 'Code', 'Percentage', '975', SecE_Percentage975);
                AddEndTag(TindentMMMM, 'SectionE');
              end;

              if (Length(T2081SecFInfo) > 0) then
              begin
                AddBeginTag(TindentMMMM, 'SectionF');
                for j:= 0 to pred(length(T2081SecFInfo)) do
                with T2081SecFInfo[j] do
                begin
                  AddSecFBlock(TindentMMMMM, TindentMMMMMM, TindentMMMMMMM, Index, Year, Step1_Percentage, Step2_Percentage, Step3_Percentage, Step4_Percentage, Step5_Percentage, Step6_Percentage, Step7_Percentage);
                end;
                AddEndTag(TindentMMMM, 'SectionF');
              end;

              AddEndTag(TindentMMM, 'Part1');
            end;

            if not ExcessTransactionsPresent.Equals('0002') then
            begin
              if not ExcessTransactionsPresent.IsEmpty() or (length(Part2SecAInfo) > 0) or (length(Part2SecBInfo) > 0) then
              begin
                AddBeginTag(TindentMMM, 'Part2');
                AddTag(TindentMMMM, 'ExcessTransactionsPresent', ExcessTransactionsPresent);

                if (length(Part2SecAInfo) > 0) then
                begin
                  AddBeginTag(TindentMMMM, 'SectionA');
                  for j:= 0 to pred(length(Part2SecAInfo)) do
                  with Part2SecAInfo[j] do
                  begin
                    AddP2SecABlock(TindentMMMMM, TindentMMMMMM, Percentage, Amount, Acquisition, Disposition);
                  end;
                  AddEndTag(TindentMMMM, 'SectionA');
                end;

                if (length(Part2SecBInfo) > 0) then
                begin
                  AddBeginTag(TindentMMMM, 'SectionB');
                  for j:= 0 to pred(length(Part2SecBInfo)) do
                  with Part2SecBInfo[j] do
                  begin
                    AddP2SecBBlock(TindentMMMMM, TindentMMMMMM, NameOfPerson, Percentage, Amount, Acquisition, Disposition);
                  end;
                  AddEndTag(TindentMMMM, 'SectionB');
                end;

                AddEndTag(TindentMMM, 'Part2');
              end;
            end;

            AddEndTag(TindentMM, 'CorporateWorksheet');
            AddEndTag(TindentM, 'T2081');
          end;
        end;
      end;
    end;
    {$endregion 'T2081'}

    AddEndTag(Tindent, 'CharityAnnualReturnSubmission');
    {$endregion 'CharityAnnualReturnSubmission'}

    {$region ' CharityGiftRecipients / T1236 '}
    if C3.Equals('0001') then
    begin
      lSlipFormCount:= 0;
      for i:= 0 to pred(FList.Count) do
      begin
        FRec:= FList.Items[i];
        if (FRec.FormName = 'T1236') and (Ret[aRetNo].FrmHasData[Frec.FormNo]) then
        begin
          T1236SlipRec:= GetT1236SlipRec(aRetNo, FRec.FormName + FRec.FormInst);
          lSlipFormCount:= lSlipFormCount + length(T1236SlipRec.T1236SlipDetails);
        end;
      end;

      AddBeginTag(Tindent, 'CharityGiftRecipients');
      AddTag(TindentM, 'Count', IntToStr(lSlipFormCount));
      AddBeginTag(TindentM, 'CharityGiftRecipientsList');

      for i:= 0 to pred(FList.Count) do
      begin
        FRec:= FList.Items[i];

        if (FRec.FormName = 'T1236') and (Ret[aRetNo].FrmHasData[Frec.FormNo]) then
        begin
          T1236SlipRec:= GetT1236SlipRec(aRetNo, FRec.FormName + FRec.FormInst);
          with T1236SlipRec do
          begin
            for j:= 0 to pred(length(T1236SlipDetails)) do
            with T1236SlipDetails[j] do
            if not OrganizationName.IsEmpty() or not BusinessIdentifier.IsEmpty() or not CharityIndicationCode.IsEmpty() or not TotalAmount.IsEmpty() or
               not NonCashAmount.IsEmpty() or not MunicipalityName.IsEmpty() or not ProvinceName.IsEmpty() then
            begin
              AddBeginTag(TindentMM, 'CharityGiftRecipient');

              AddTag(TindentMMM, 'OrganizationName', OrganizationName);
              AddTag(TindentMMM, 'BusinessIdentifier', BusinessIdentifier);
              AddTag(TindentMMM, 'CharityIndicationCode', CharityIndicationCode);
              AddTag(TindentMMM, 'TotalAmount', GetRoundedFloatFalue(TotalAmount));
//              AddTag(TindentMMM, 'CashAmount', CashAmount); // 20250703 Igor
              AddTag(TindentMMM, 'NonCashAmount', GetRoundedFloatFalue(NonCashAmount));
//              AddTag(TindentMMM, 'PoliticalActivityUsage', '0002'); // 20250703 Igor
//              AddTag(TindentMMM, 'PoliticalActivityUsageAmount', '0'); // 20250703 Igor
              AddTag(TindentMMM, 'MunicipalityName', MunicipalityName);
              AddTag(TindentMMM, 'ProvinceName', ProvinceName);
//              AddTag(TindentMMM, 'CountryCode', CountryCode); // 20250703 Igor

              AddEndTag(TindentMM, 'CharityGiftRecipient');
            end;
          end;
        end;
      end;
      AddEndTag(TindentM, 'CharityGiftRecipientsList');
      AddEndTag(Tindent, 'CharityGiftRecipients');
    end;
    {$endregion ' CharityGiftRecipients / T1236 '}

    {$region ' CharityGrantRecipients / T1441 '}
    if C16_5841.Equals('0001') then
    begin
      lSlipFormCount:= 0;
      for i:= 0 to pred(FList.Count) do
      begin
        FRec:= FList.Items[i];
        if (FRec.FormName = 'T1441') and (Ret[aRetNo].FrmHasData[Frec.FormNo]) then
        begin
          T1441SlipRec:= GetT1441SlipRec(aRetNo, FRec.FormName + FRec.FormInst);
          lSlipFormCount:= lSlipFormCount + length(T1441SlipRec.T1441SlipDetails);
        end;
      end;

      AddBeginTag(Tindent, 'CharityGrantRecipients');
      AddTag(TindentM, 'Count', IntToStr(lSlipFormCount));
      AddBeginTag(TindentM, 'CharityGrantRecipientsList');

      for i:= 0 to pred(FList.Count) do
      begin
        FRec:= FList.Items[i];

        if (FRec.FormName = 'T1441') and (Ret[aRetNo].FrmHasData[Frec.FormNo]) then
        begin
          AddBeginTag(TindentM, 'T1441');
          T1441SlipRec:= GetT1441SlipRec(aRetNo, FRec.FormName + FRec.FormInst);
          with T1441SlipRec do
          begin
            AddTag(TindentMM, 'Count', Count);

            for j:= 0 to pred(length(T1441SlipDetails)) do
            with T1441SlipDetails[j] do
            if not RecipientNAme.IsEmpty() or not GrantPurpose.IsEmpty() or not CashAmountDisbursed.IsEmpty() or not NonCashAmountDisbursed.IsEmpty() or not Country.IsEmpty() then
            begin
              AddBeginTag(TindentMM, 'CharityGrantRecipient');
              AddTag(TindentMMM, 'Name', RecipientNAme);
              AddTag(TindentMMM, 'GrantPurpose', GrantPurpose);
              AddTag(TindentMMM, 'CashAmountDisbursed', GetRoundedFloatFalue(CashAmountDisbursed));
              AddTag(TindentMMM, 'NonCashAmountDisbursed', GetRoundedFloatFalue(NonCashAmountDisbursed));
              AddTag(TindentMMM, 'Country', Country);
              AddEndTag(TindentMM, 'CharityGrantRecipient');
            end;
          end;
          AddEndTag(TindentM, 'T1441');
        end;
      end;
      AddEndTag(TindentM, 'CharityGrantRecipientsList');
      AddEndTag(Tindent, 'CharityGrantRecipients');
    end;
    {$endregion ' CharityGrantRecipients / T1441 '}

    addT3010SubmissionTag('END', AXmlList);
  end;
end;
//20260105 Igor <<<
function GetT3010Rec(aRetNo: Integer; aFName: String): AT3010Rec;

  function GetDorShed6Value(aRetNo: Integer; aFieldIndex: Integer; aElmYes: integer): string;
  begin
    if FetchElm(aRetNo, aFieldIndex, aElmYes) > '' then
      Result:= '0002'
    else
      Result:= '0001';
  end;

  function GetBoolValueByY_or_N(aRetNo: Integer; aFieldIndex: Integer; aElmYes: integer): string;
  begin
    if UpperCase(FetchElm(aRetNo, aFieldIndex, aElmYes)).Equals('Y') then
      Result := '0001'
    else
      Result:= '0002';
  end;

  function Getsch4_2_TypeValue(aRetNo: Integer; aFieldIndex: Integer; aElmOrg, aElmGov, aElmInd: integer): string;
  begin
    if (FetchElm(aRetNo, aFieldIndex, aElmOrg) > '') then
      Result:= '0001'
    else
    if (FetchElm(aRetNo, aFieldIndex, aElmGov) > '') then
      Result:= '0002'
    else
    if (FetchElm(aRetNo, aFieldIndex, aElmInd) > '') then
      Result:= '0003'
    else
      Result:= '0000';
  end;

var
  lCurrentDay, lCurrentMonth, lCurrentYear: word;
  lYear: string;
  lFormIndex: Integer;
  lAddress, lAddress1, lAddress2: string; //20250529 Igor
begin
  lFormIndex:= RetList[aRetNo].GetFormNo(aFName);

  DecodeDate(Now, lCurrentYear, lCurrentMonth, lCurrentDay);
  lYear:= Copy(IntToStr(pred(lCurrentYear)), 3, 4);

  with Result do
  begin
    VendorIdentifier:= '???';
    SoftwareProductIdentifier:= '???';
    FilingPeriodEnd:= LeftStr(FetchElm(aRetNo, lFormIndex, 1), 10); //20250529 Igor
    BN15:= LeftStr(FetchElm(aRetNo, lFormIndex, 2), 15);
    FormVersion:= lYear + 'a';
    WebAddress:= LeftStr(FetchElm(aRetNo, lFormIndex, 5), 200);
    A1:= GetT3010YesNoValue(aRetNo, lFormIndex, 9, 10);
    A1ParentOrgName:= LeftStr(FetchElm(aRetNo, lFormIndex, 11), 255);
    A1ParentOrgBN:= LeftStr(FetchElm(aRetNo, lFormIndex, 12), 15);
    A2:= GetT3010YesNoValue(aRetNo, lFormIndex, 13, 14);
    A3:= GetT3010YesNoValue(aRetNo, lFormIndex, 3, 4);
    C1Activity:= GetT3010YesNoValue(aRetNo, lFormIndex, 19, 20);
    NewPrograms:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 29) + ' ' + FetchElm(aRetNo, lFormIndex, 30) + ' ' + FetchElm(aRetNo, lFormIndex, 31) + ' ' + FetchElm(aRetNo, lFormIndex, 32) + ' ' + FetchElm(aRetNo, lFormIndex, 322) + ' ' + FetchElm(aRetNo, lFormIndex, 326) + ' ' + FetchElm(aRetNo, lFormIndex, 330) + ' ' + FetchElm(aRetNo, lFormIndex, 331) + ' ' + FetchElm(aRetNo, lFormIndex, 332) + ' ' + FetchElm(aRetNo, lFormIndex, 333) + ' ' + FetchElm(aRetNo, lFormIndex, 334) + ' ' + FetchElm(aRetNo, lFormIndex, 335) + ' ' + FetchElm(aRetNo, lFormIndex, 340)), 2500);
    OngoingPrograms:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 21) + ' ' + FetchElm(aRetNo, lFormIndex, 22) + ' ' + FetchElm(aRetNo, lFormIndex, 23) + ' ' + FetchElm(aRetNo, lFormIndex, 24) + ' ' + FetchElm(aRetNo, lFormIndex, 25) + ' ' + FetchElm(aRetNo, lFormIndex, 26) + ' ' + FetchElm(aRetNo, lFormIndex, 27) + ' ' + FetchElm(aRetNo, lFormIndex, 344) + ' ' + FetchElm(aRetNo, lFormIndex, 345) + ' ' + FetchElm(aRetNo, lFormIndex, 346) + ' ' + FetchElm(aRetNo, lFormIndex, 347) + ' ' + FetchElm(aRetNo, lFormIndex, 348) + ' ' + FetchElm(aRetNo, lFormIndex, 349)), 2500);
    C3:= GetT3010YesNoValue(aRetNo, lFormIndex, 94, 93);
    C4:= GetT3010YesNoValue(aRetNo, lFormIndex, 92, 91);
    IsC6_2500:= GetT3010YesNoValue(aRetNo, lFormIndex, 67, 0);
    IsC6_2510:= GetT3010YesNoValue(aRetNo, lFormIndex, 66, 0);
    IsC6_2530:= GetT3010YesNoValue(aRetNo, lFormIndex, 65, 0);
    IsC6_2540:= GetT3010YesNoValue(aRetNo, lFormIndex, 67, 0);
    IsC6_2550:= GetT3010YesNoValue(aRetNo, lFormIndex, 17, 0);
    IsC6_2560:= GetT3010YesNoValue(aRetNo, lFormIndex, 16, 0);
    IsC6_2570:= GetT3010YesNoValue(aRetNo, lFormIndex, 15, 0);
    IsC6_2575:= GetT3010YesNoValue(aRetNo, lFormIndex, 8, 0);
    IsC6_2580:= GetT3010YesNoValue(aRetNo, lFormIndex, 7, 0);
    IsC6_2590:= GetT3010YesNoValue(aRetNo, lFormIndex, 34, 0);
    IsC6_2600:= GetT3010YesNoValue(aRetNo, lFormIndex, 35, 0);
    IsC6_2610:= GetT3010YesNoValue(aRetNo, lFormIndex, 36, 0);
    IsC6_2620:= GetT3010YesNoValue(aRetNo, lFormIndex, 6, 0);
    IsC6_2630:= GetT3010YesNoValue(aRetNo, lFormIndex, 38, 0);
    IsC6_2640:= GetT3010YesNoValue(aRetNo, lFormIndex, 39, 0);
    IsC6_2650:= GetT3010YesNoValue(aRetNo, lFormIndex, 40, 0);
    C6_OtherSpecify:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 42) + ' ' + FetchElm(aRetNo, lFormIndex, 33) + ' ' + FetchElm(aRetNo, lFormIndex, 108)), 175);
    C7:= GetT3010YesNoValue(aRetNo, lFormIndex, 43, 44);

    C7a:= FetchElm(aRetNo, lFormIndex, 45);
		C7b:= FetchElm(aRetNo, lFormIndex, 46);
		IsC7c_2730:= GetT3010YesNoValue(aRetNo, lFormIndex, 98, 0);
    IsC7c_2740:= GetT3010YesNoValue(aRetNo, lFormIndex, 101, 0);
    IsC7c_2750:= GetT3010YesNoValue(aRetNo, lFormIndex, 97, 0);
    IsC7c_2760:= GetT3010YesNoValue(aRetNo, lFormIndex, 100, 0);
    IsC7c_2770:= GetT3010YesNoValue(aRetNo, lFormIndex, 96, 0);
    IsC7c_2780:= GetT3010YesNoValue(aRetNo, lFormIndex, 99, 0);
    C7c_OtherSpecify:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 102)), 175);

    C7d:= GetT3010YesNoValue(aRetNo, lFormIndex, 49, 50);
    C8:= GetT3010YesNoValue(aRetNo, lFormIndex, 48, 47);
    C9:= GetT3010YesNoValue(aRetNo, lFormIndex, 52, 51);
    C10:= GetT3010YesNoValue(aRetNo, lFormIndex, 54, 53);
    C11:= GetT3010YesNoValue(aRetNo, lFormIndex, 56, 55);
    C12:= GetT3010YesNoValue(aRetNo, lFormIndex, 58, 57);
    C13:= GetT3010YesNoValue(aRetNo, lFormIndex, 60, 59);
    C14:= GetT3010YesNoValue(aRetNo, lFormIndex, 62, 61);
    C15:= GetT3010YesNoValue(aRetNo, lFormIndex, 137, 136);
    C16_5840:= GetT3010YesNoValue(aRetNo, lFormIndex, 68, 69);
    C16_5841:= GetT3010YesNoValue(aRetNo, lFormIndex, 95, 130);
		C16_5842:= LeftStr(FetchElm(aRetNo, lFormIndex, 133), 5); //20250529 Igor
		C16_5843:= LeftStr(FetchElm(aRetNo, lFormIndex, 139), 13); //20250529 Igor
    C17_5850:= GetT3010YesNoValue(aRetNo, lFormIndex, 341, 342);
		C18_5860:= GetT3010YesNoValue(aRetNo, lFormIndex, 343, 350);
		C18_5861:= LeftStr(FetchElm(aRetNo, lFormIndex, 351), 5); //20250529 Igor
		C18_5862:= LeftStr(FetchElm(aRetNo, lFormIndex, 352), 13); //20250529 Igor
		C18_5863:= LeftStr(FetchElm(aRetNo, lFormIndex, 353), 13); //20250529 Igor
		C18_5864:= LeftStr(FetchElm(aRetNo, lFormIndex, 354), 13); //20250529 Igor

    SectionDOrSchedule6:= GetDorShed6Value(aRetNo, lFormIndex, 28);

    D1:= GetT3010YesNoValue(aRetNo, lFormIndex, 64, 70);
		D2_4050:= GetT3010YesNoValue(aRetNo, lFormIndex, 71, 72);
		D2_4400:= GetT3010YesNoValue(aRetNo, lFormIndex, 75, 76);
		D3_4490:= GetT3010YesNoValue(aRetNo, lFormIndex, 77, 78);
		D3_4565:= GetT3010YesNoValue(aRetNo, lFormIndex, 81, 82);

    //20250529 Igor >>>
    D4_FinancialInfo_Code_4200_Amt:= LeftStr(FetchElm(aRetNo, lFormIndex, 73), 16);
		D4_FinancialInfo_Code_4350_Amt:= LeftStr(FetchElm(aRetNo, lFormIndex, 74), 16);
    D4_FinancialInfo_Code_4500_Amt:= LeftStr(FetchElm(aRetNo, lFormIndex, 79), 16);
    D4_FinancialInfo_Code_4510_Amt:= LeftStr(FetchElm(aRetNo, lFormIndex, 80), 16);
    D4_FinancialInfo_Code_4530_Amt:= LeftStr(FetchElm(aRetNo, lFormIndex, 63), 16);
    D4_FinancialInfo_Code_4570_Amt:= LeftStr(FetchElm(aRetNo, lFormIndex, 83), 16);
    D4_FinancialInfo_Code_4571_Amt:= LeftStr(FetchElm(aRetNo, lFormIndex, 287), 16);
    D4_FinancialInfo_Code_4575_Amt:= LeftStr(FetchElm(aRetNo, lFormIndex, 84), 16);
    D4_FinancialInfo_Code_4630_Amt:= LeftStr(FetchElm(aRetNo, lFormIndex, 85), 16);
    D4_FinancialInfo_Code_4640_Amt:= LeftStr(FetchElm(aRetNo, lFormIndex, 86), 16);
    D4_FinancialInfo_Code_4650_Amt:= LeftStr(FetchElm(aRetNo, lFormIndex, 87), 16);
    D4_FinancialInfo_Code_4700_Amt:= LeftStr(FetchElm(aRetNo, lFormIndex, 88), 16);
    D4_FinancialInfo_Code_4860_Amt:= LeftStr(FetchElm(aRetNo, lFormIndex, 89), 16);
    D4_FinancialInfo_Code_4810_Amt:= LeftStr(FetchElm(aRetNo, lFormIndex, 90), 16);
    D4_FinancialInfo_Code_4920_Amt:= LeftStr(FetchElm(aRetNo, lFormIndex, 103), 16);
    D4_FinancialInfo_Code_4950_Amt:= LeftStr(FetchElm(aRetNo, lFormIndex, 104), 16);
    D4_FinancialInfo_Code_5000_Amt:= LeftStr(FetchElm(aRetNo, lFormIndex, 105), 16);
    D4_FinancialInfo_Code_5010_Amt:= LeftStr(FetchElm(aRetNo, lFormIndex, 106), 16);
    D4_FinancialInfo_Code_5045_Amt:= LeftStr(FetchElm(aRetNo, lFormIndex, 140), 16);
    D4_FinancialInfo_Code_5050_Amt:= LeftStr(FetchElm(aRetNo, lFormIndex, 107), 16);
		D4_FinancialInfo_Code_5100_Amt:= LeftStr(FetchElm(aRetNo, lFormIndex, 109), 16);

    SectionE_Name:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 110)), 175);
    SectionE_Position:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 111)), 30);
    SectionE_Date:= trim(FetchElm(aRetNo, lFormIndex, 112));
		SecE_Telephone:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 113)) + trim(FetchElm(aRetNo, lFormIndex, 114)), 20);

    SecF_F2_ContactName:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 121)), 175);
		SecF_F2_CompanyName:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 122)), 175);

    lAddress:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 123)), 60);
    lAddress1:= Copy(lAddress, 1, 30);
    lAddress2:= Copy(lAddress, 31, 60);
		SecF_F2_Address1:= lAddress1;
		SecF_F2_Address2:= lAddress2;
		SecF_F2_City:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 124)), 30);
		SecF_F2_ProvinceState:= LeftStr('', 30);
		SecF_F2_PostalZipCode:= LeftStr('', 12);
		//SecF_F2_CountryCode:= '';//20250529 Igor
		SecF_F2_Telephone:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 125)) + trim(FetchElm(aRetNo, lFormIndex, 126)), 20);
		SecF_F2_SameAsSectionE:= GetT3010YesNoValue(aRetNo, lFormIndex, 127, 128);

    Schedule1_1:= GetT3010YesNoValue(aRetNo, lFormIndex, 141, 142);
    Schedule1_2:= GetT3010YesNoValue(aRetNo, lFormIndex, 143, 144);
    Schedule1_Q3_111:= LeftStr(FetchElm(aRetNo, lFormIndex, 381), 14);
    Schedule1_Q3_112:= LeftStr(FetchElm(aRetNo, lFormIndex, 383), 14);
    Schedule1_4:= GetT3010YesNoValue(aRetNo, lFormIndex, 145, 146);
    Schedule1_5:= GetT3010YesNoValue(aRetNo, lFormIndex, 147, 148);

    Schedule2_1_200:= LeftStr(FetchElm(aRetNo, lFormIndex, 149), 13);
		Schedule2_2_210:= GetT3010YesNoValue(aRetNo, lFormIndex, 150, 151);
    Sch2_2_210_FA_Name1:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 152)) + ' ' + trim(FetchElm(aRetNo, lFormIndex, 385)), 175);
    Sch2_2_210_FA_CountryCode1:= FetchElm(aRetNo, lFormIndex, 153);
    Sch2_2_210_FA_Amount1:= trim(FetchElm(aRetNo, lFormIndex, 154));
    Sch2_2_210_FA_Name2:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 155)) + ' ' + trim(FetchElm(aRetNo, lFormIndex, 386)), 175);
    Sch2_2_210_FA_CountryCode2:= FetchElm(aRetNo, lFormIndex, 156);
    Sch2_2_210_FA_Amount2:= trim(FetchElm(aRetNo, lFormIndex, 157));
    Sch2_2_210_FA_Name3:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 158)) + ' ' + trim(FetchElm(aRetNo, lFormIndex, 387)), 175);
    Sch2_2_210_FA_CountryCode3:= FetchElm(aRetNo, lFormIndex, 159);
    Sch2_2_210_FA_Amount3:= trim(FetchElm(aRetNo, lFormIndex, 160));
    Sch2_2_210_FA_Name4:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 161)) + ' ' + trim(FetchElm(aRetNo, lFormIndex, 388)), 175);
    Sch2_2_210_FA_CountryCode4:= FetchElm(aRetNo, lFormIndex, 162);
    Sch2_2_210_FA_Amount4:= trim(FetchElm(aRetNo, lFormIndex, 163));
    Sch2_2_210_FA_Name5:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 164)) + ' ' + trim(FetchElm(aRetNo, lFormIndex, 389)), 175);
    Sch2_2_210_FA_CountryCode5:= FetchElm(aRetNo, lFormIndex, 165);
    Sch2_2_210_FA_Amount5:= trim(FetchElm(aRetNo, lFormIndex, 166));
    //20250529 Igor <<<

    Sch2_2_3_CountryCode1:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 167)), 2);
    Sch2_2_3_CountryCode2:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 168)), 2);
    Sch2_2_3_CountryCode3:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 169)), 2);
    Sch2_2_3_CountryCode4:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 170)), 2);
    Sch2_2_3_CountryCode5:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 171)), 2);
    Sch2_2_3_CountryCode6:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 172)), 2);
    Sch2_2_3_CountryCode7:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 173)), 2);
    Sch2_2_3_CountryCode8:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 174)), 2);
    Sch2_2_3_CountryCode9:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 175)), 2);
    Sch2_2_3_CountryCode10:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 176)), 2);

    Schedule2_4:= GetT3010YesNoValue(aRetNo, lFormIndex, 177, 178);
    Schedule2_4_230:= trim(FetchElm(aRetNo, lFormIndex, 179));
		Schedule2_5:= GetT3010YesNoValue(aRetNo, lFormIndex, 180, 181);
		Schedule2_6:= GetT3010YesNoValue(aRetNo, lFormIndex, 182, 183);
		Schedule2_7:= GetT3010YesNoValue(aRetNo, lFormIndex, 184, 185);

    Sch2_7_Item1:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 186)), 30);
    Sch2_7_Value1:= trim(FetchElm(aRetNo, lFormIndex, 187));
    Sch2_7_Destination1:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 188)), 175);
    Sch2_7_CountryCode1:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 189)), 2);
    Sch2_7_Item2:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 190)), 30);
    Sch2_7_Value2:= trim(FetchElm(aRetNo, lFormIndex, 191));
    Sch2_7_Destination2:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 192)), 175);
    Sch2_7_CountryCode2:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 193)), 2);
    Sch2_7_Item3:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 194)), 30);
    Sch2_7_Value3:= trim(FetchElm(aRetNo, lFormIndex, 195));
    Sch2_7_Destination3:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 196)), 175);
    Sch2_7_CountryCode3:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 197)), 2);
    Sch2_7_Item4:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 198)), 30);
    Sch2_7_Value4:= trim(FetchElm(aRetNo, lFormIndex, 199));
    Sch2_7_Destination4:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 200)), 175);
    Sch2_7_CountryCode4:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 201)), 2);
    Sch2_7_Item5:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 202)), 30);
    Sch2_7_Value5:= trim(FetchElm(aRetNo, lFormIndex, 203));
    Sch2_7_Destination5:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 204)), 175);
    Sch2_7_CountryCode5:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 205)), 2);

    //20250529 Igor >>>
    Schedule3_1a:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 206)), 5);
    Sch3_1b_305_Count:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 207)), 2);
    Sch3_1b_310_Count:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 208)), 2);
    Sch3_1b_315_Count:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 209)), 2);
    Sch3_1b_320_Count:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 210)), 2);
    Sch3_1b_325_Count:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 211)), 2);
    Sch3_1b_330_Count:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 212)), 2);
    Sch3_1b_335_Count:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 213)), 2);
    Sch3_1b_340_Count:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 214)), 2);
    Sch3_1b_345_Count:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 215)), 2);
    Schedule3_2a:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 216)), 5);
		Schedule3_2b:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 217)), 13);
		Schedule3_3:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 218)), 13);

    Schedule4_1_Name1:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 219)), 175);
    Schedule4_1_AtArmsLength1:= GetBoolValueByY_or_N(aRetNo, lFormIndex, 220);
    Schedule4_1_Name2:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 221)), 175);
    Schedule4_1_AtArmsLength2:= GetBoolValueByY_or_N(aRetNo, lFormIndex, 222);
    Schedule4_1_Name3:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 223)), 175);
    Schedule4_1_AtArmsLength3:= GetBoolValueByY_or_N(aRetNo, lFormIndex, 224);
    Schedule4_1_Name4:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 225)), 175);
    Schedule4_1_AtArmsLength4:= GetBoolValueByY_or_N(aRetNo, lFormIndex, 226);

    Schedule4_2_Name1:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 227)), 175);
    Schedule4_2_Value1:= trim(FetchElm(aRetNo, lFormIndex, 228));
    Schedule4_2_Type1:= Getsch4_2_TypeValue(aRetNo, lFormIndex, 229, 230, 231);
    Schedule4_2_Name2:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 232)), 175);
    Schedule4_2_Value2:= trim(FetchElm(aRetNo, lFormIndex, 233));
    Schedule4_2_Type2:= Getsch4_2_TypeValue(aRetNo, lFormIndex, 234, 235, 236);
    Schedule4_2_Name3:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 237)), 175);
    Schedule4_2_Value3:= trim(FetchElm(aRetNo, lFormIndex, 238));
    Schedule4_2_Type3:= Getsch4_2_TypeValue(aRetNo, lFormIndex, 239, 240, 241);
    Schedule4_2_Name4:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 242)), 175);
    Schedule4_2_Value4:= trim(FetchElm(aRetNo, lFormIndex, 243));
    Schedule4_2_Type4:= Getsch4_2_TypeValue(aRetNo, lFormIndex, 244, 245, 246);
    //20250529 Igor <<<

    Schedule5_1_Kind_500:= GetT3010YesNoValue(aRetNo, lFormIndex, 247, 0);
    Schedule5_1_Kind_505:= GetT3010YesNoValue(aRetNo, lFormIndex, 248, 0);
    Schedule5_1_Kind_510:= GetT3010YesNoValue(aRetNo, lFormIndex, 249, 0);
    Schedule5_1_Kind_515:= GetT3010YesNoValue(aRetNo, lFormIndex, 250, 0);
    Schedule5_1_Kind_520:= GetT3010YesNoValue(aRetNo, lFormIndex, 251, 0);
    Schedule5_1_Kind_525:= GetT3010YesNoValue(aRetNo, lFormIndex, 252, 0);
    Schedule5_1_Kind_530:= GetT3010YesNoValue(aRetNo, lFormIndex, 253, 0);
    Schedule5_1_Kind_535:= GetT3010YesNoValue(aRetNo, lFormIndex, 254, 0);
    Schedule5_1_Kind_540:= GetT3010YesNoValue(aRetNo, lFormIndex, 255, 0);
    Schedule5_1_Kind_545:= GetT3010YesNoValue(aRetNo, lFormIndex, 256, 0);
    Schedule5_1_Kind_550:= GetT3010YesNoValue(aRetNo, lFormIndex, 257, 0);
    Schedule5_1_Kind_555:= GetT3010YesNoValue(aRetNo, lFormIndex, 258, 0);
    Schedule5_1_Kind_560:= GetT3010YesNoValue(aRetNo, lFormIndex, 259, 0);
    Schedule5_1_OtherSpecify:= LeftStr(trim(FetchElm(aRetNo, lFormIndex, 260)) + ' ' + trim(FetchElm(aRetNo, lFormIndex, 390)) + ' ' + trim(FetchElm(aRetNo, lFormIndex, 391)), 175);
    Schedule5_2_580:= trim(FetchElm(aRetNo, lFormIndex, 261));

    Schedule6_4020:=  GetT3010YesNoValue(aRetNo, lFormIndex, 252, 263);
    Schedule6_4100_Value:= FetchElm(aRetNo, lFormIndex, 264);
    Schedule6_4101_Value:= FetchElm(aRetNo, lFormIndex, 355);
    Schedule6_4102_Value:= FetchElm(aRetNo, lFormIndex, 356);
    Schedule6_4110_Value:= FetchElm(aRetNo, lFormIndex, 265);
    Schedule6_4120_Value:= FetchElm(aRetNo, lFormIndex, 266);
    Schedule6_4130_Value:= FetchElm(aRetNo, lFormIndex, 267);
    Schedule6_4140_Value:= FetchElm(aRetNo, lFormIndex, 268);
    Schedule6_4150_Value:= FetchElm(aRetNo, lFormIndex, 269);
    Schedule6_4155_Value:= FetchElm(aRetNo, lFormIndex, 270);
    Schedule6_4157_Value:= FetchElm(aRetNo, lFormIndex, 357);
    Schedule6_4158_Value:= FetchElm(aRetNo, lFormIndex, 358);
    Schedule6_4160_Value:= FetchElm(aRetNo, lFormIndex, 271);
    Schedule6_4165_Value:= FetchElm(aRetNo, lFormIndex, 272);
    Schedule6_4166_Value:= FetchElm(aRetNo, lFormIndex, 273);
    Schedule6_4170_Value:= FetchElm(aRetNo, lFormIndex, 274);
    Schedule6_4190_Value:= FetchElm(aRetNo, lFormIndex, 359);
    Schedule6_4200_Value:= FetchElm(aRetNo, lFormIndex, 275);
    Schedule6_4250_Value:= FetchElm(aRetNo, lFormIndex, 281);

    Schedule6_4300_Value:= FetchElm(aRetNo, lFormIndex, 276);
    Schedule6_4310_Value:= FetchElm(aRetNo, lFormIndex, 277);
    Schedule6_4320_Value:= FetchElm(aRetNo, lFormIndex, 278);
    Schedule6_4330_Value:= FetchElm(aRetNo, lFormIndex, 279);
    Schedule6_4350_Value:= FetchElm(aRetNo, lFormIndex, 280);

    Schedule6_4500_Value:= FetchElm(aRetNo, lFormIndex, 282);
    Schedule6_5610_Value:= FetchElm(aRetNo, lFormIndex, 283);
    Schedule6_4510_Value:= FetchElm(aRetNo, lFormIndex, 285);
    Schedule6_4530_Value:= FetchElm(aRetNo, lFormIndex, 288);
    Schedule6_4540_Value:= FetchElm(aRetNo, lFormIndex, 289);
    Schedule6_4550_Value:= FetchElm(aRetNo, lFormIndex, 290);
    Schedule6_4560_Value:= FetchElm(aRetNo, lFormIndex, 291);
    Schedule6_4571_Value:= FetchElm(aRetNo, lFormIndex, 325);
    Schedule6_4575_Value:= FetchElm(aRetNo, lFormIndex, 292);
    Schedule6_4576_Value:= FetchElm(aRetNo, lFormIndex, 360);
    Schedule6_4577_Value:= FetchElm(aRetNo, lFormIndex, 361);
    Schedule6_4580_Value:= FetchElm(aRetNo, lFormIndex, 293);
    Schedule6_4590_Value:= FetchElm(aRetNo, lFormIndex, 294);
    Schedule6_4600_Value:= FetchElm(aRetNo, lFormIndex, 295);
    Schedule6_4610_Value:= FetchElm(aRetNo, lFormIndex, 296);
    Schedule6_4620_Value:= FetchElm(aRetNo, lFormIndex, 297);
    Schedule6_4630_Value:= FetchElm(aRetNo, lFormIndex, 298);
    Schedule6_4640_Value:= FetchElm(aRetNo, lFormIndex, 299);
    Schedule6_4650_Value:= FetchElm(aRetNo, lFormIndex, 300);
    Schedule6_4700_Value:= FetchElm(aRetNo, lFormIndex, 302);
    Schedule6_Revenue_4655:= LeftStr(FetchElm(aRetNo, lFormIndex, 301), 175); //20250529 Igor

    Schedule6_4800_Value:= FetchElm(aRetNo, lFormIndex, 303);
    Schedule6_4810_Value:= FetchElm(aRetNo, lFormIndex, 304);
    Schedule6_4820_Value:= FetchElm(aRetNo, lFormIndex, 305);
    Schedule6_4830_Value:= FetchElm(aRetNo, lFormIndex, 306);
    Schedule6_4840_Value:= FetchElm(aRetNo, lFormIndex, 307);
    Schedule6_4850_Value:= FetchElm(aRetNo, lFormIndex, 308);
    Schedule6_4860_Value:= FetchElm(aRetNo, lFormIndex, 309);
    Schedule6_4870_Value:= FetchElm(aRetNo, lFormIndex, 310);
    Schedule6_4880_Value:= FetchElm(aRetNo, lFormIndex, 311);
    Schedule6_4890_Value:= FetchElm(aRetNo, lFormIndex, 312);
    Schedule6_4891_Value:= FetchElm(aRetNo, lFormIndex, 313);
    Schedule6_4900_Value:= FetchElm(aRetNo, lFormIndex, 314);
    Schedule6_4910_Value:= FetchElm(aRetNo, lFormIndex, 315);
    Schedule6_4920_Value:= FetchElm(aRetNo, lFormIndex, 316);
    Schedule6_4950_Value:= FetchElm(aRetNo, lFormIndex, 318);
    Schedule6_5000_Value:= FetchElm(aRetNo, lFormIndex, 319);
    Schedule6_5010_Value:= FetchElm(aRetNo, lFormIndex, 320);
    Schedule6_5020_Value:= FetchElm(aRetNo, lFormIndex, 321);
    Schedule6_5040_Value:= FetchElm(aRetNo, lFormIndex, 323);
    Schedule6_5045_Value:= FetchElm(aRetNo, lFormIndex, 286);
    Schedule6_5050_Value:= FetchElm(aRetNo, lFormIndex, 324);
    Schedule6_5100_Value:= FetchElm(aRetNo, lFormIndex, 327);
    Schedule6_Expenditures_4930:= LeftStr(FetchElm(aRetNo, lFormIndex, 317), 175); //20250529 Igor

    Schedule6_5500_Value:= FetchElm(aRetNo, lFormIndex, 328);
    Schedule6_5510_Value:= FetchElm(aRetNo, lFormIndex, 329);
    Schedule6_5750_Value:= FetchElm(aRetNo, lFormIndex, 336);
    Schedule6_5900_Value:= FetchElm(aRetNo, lFormIndex, 337);
    Schedule6_5910_Value:= FetchElm(aRetNo, lFormIndex, 338);

    Schedule8_810_Value:= FetchElm(aRetNo, lFormIndex, 363);
  end;
end;

procedure AT1235SlipRec.AddDetailInfo(aRetNo, aFormIndex: Integer; aPInf_LastNameId, aPInf_FirstNameId, aPInf_InitialId, aPInf_Term_StartDateId, aPInf_Term_EndDateId, aPInf_PositionId,
                                  aPInf_AtArmsLengthYesId, aPInf_AtArmsLengthNoId, aCInf_AddressId, aCInf_CityId, aProvTerrId, aCInf_PostalZipCodeId, aCInf_TelephoneId, aCInf_DateOfBirthId: Integer);
var
  lLastName, lFirstName: string;
  lAddress, lAddress1, lAddress2: string; //20250529 Igor
begin
  lLastName:= FetchElm(aRetNo, aFormIndex, aPInf_LastNameId);
  lFirstName:= FetchElm(aRetNo, aFormIndex, aPInf_FirstNameId);

  if lLastName.IsEmpty or lFirstName.IsEmpty then Exit;

  SetLength(T1235SlipDetails, succ(Length(T1235SlipDetails)));
  with T1235SlipDetails[pred(Length(T1235SlipDetails))] do
  begin
    PInf_LastName:= LeftStr(FetchElm(aRetNo, aFormIndex, aPInf_LastNameId), 30); //20250529 Igor
    PInf_FirstName:= LeftStr(FetchElm(aRetNo, aFormIndex, aPInf_FirstNameId), 30); //20250529 Igor
    PInf_Initial:= LeftStr(FetchElm(aRetNo, aFormIndex, aPInf_InitialId), 3); //20250529 Igor
    PInf_Term_StartDate:= FetchElm(aRetNo, aFormIndex, aPInf_Term_StartDateId);
    PInf_Term_EndDate:= FetchElm(aRetNo, aFormIndex, aPInf_Term_EndDateId);
    PInf_Position:= LeftStr(FetchElm(aRetNo, aFormIndex, aPInf_PositionId), 30); //20250529 Igor
    PInf_AtArmsLength:= GetT3010YesNoValue(aRetNo, aFormIndex, aPInf_AtArmsLengthYesId, aPInf_AtArmsLengthNoId);
    //20250529 Igor >>>
    lAddress:= LeftStr(trim(FetchElm(aRetNo, aFormIndex, aCInf_AddressId)), 60);
    lAddress1:= Copy(lAddress, 1, 30);
    lAddress2:= Copy(lAddress, 31, 60);
    CInf_Address1:= lAddress1;
    CInf_Address2:= lAddress2;
    CInf_City:= LeftStr(Trim(FetchElm(aRetNo, aFormIndex, aCInf_CityId) + ' ' + FetchElm(aRetNo, aFormIndex, aProvTerrId)), 30);
    CInf_PostalZipCode:= LeftStr(FetchElm(aRetNo, aFormIndex, aCInf_PostalZipCodeId), 12);
    CInf_Telephone:= LeftStr(trim(FetchElm(aRetNo, aFormIndex, aCInf_TelephoneId)), 20);
    CInf_DateOfBirth:= FetchElm(aRetNo, aFormIndex, aCInf_DateOfBirthId);
    //20250529 Igor <<<
  end;
end;

function GetT1235SlipRec(aRetNo: Integer; aFName: String): AT1235SlipRec;
var
  lFormIndex: Integer;
begin
  lFormIndex:= RetList[aRetNo].GetFormNo(aFName);

  with Result do
  begin
    TotalNumberCharityOfficials:= FetchElm(aRetNo, lFormIndex, 85);

    AddDetailInfo(aRetNo, lFormIndex, 1, 2, 3, 86, 87, 10, 11, 12, 5, 6, 7, 8, 9, 4);
    AddDetailInfo(aRetNo, lFormIndex, 13, 14, 15, 88, 89, 22, 23, 24, 17, 18, 19, 20, 21, 16);
    AddDetailInfo(aRetNo, lFormIndex, 25, 26, 27, 90, 91, 34, 35, 36, 29, 30, 31, 32, 33, 28);
    AddDetailInfo(aRetNo, lFormIndex, 37, 37, 39, 92, 93, 46, 47, 48, 41, 42, 43, 44, 45, 40);
    AddDetailInfo(aRetNo, lFormIndex, 49, 50, 51, 94, 95, 58, 59, 60, 53, 54, 55, 56, 57, 52);
    AddDetailInfo(aRetNo, lFormIndex, 61, 62, 63, 96, 97, 70, 71, 72, 65, 66, 67, 68, 69, 64);
    AddDetailInfo(aRetNo, lFormIndex, 73, 74, 75, 98, 99, 82, 83, 84, 77, 78, 79, 80, 81, 76);
  end;
end;

procedure AT1236SlipRec.AddDetailInfo(aRetNo, aFormIndex: Integer; aOrganizationNameId, aCharityIndicationCodeYesId, aCharityIndicationCodeNoId, aBusinessIdentifierId,
                                      aMunicipalityNameId, aProvinceNameId, aCountryCodeId, aNonCashAmountId, TotalAmountId: Integer);
var
  lOrganizationName: string;
begin
  lOrganizationName:= FetchElm(aRetNo, aFormIndex, aOrganizationNameId);

  if lOrganizationName.IsEmpty then Exit;

  SetLength(T1236SlipDetails, succ(Length(T1236SlipDetails)));
  with T1236SlipDetails[pred(Length(T1236SlipDetails))] do
  begin
    OrganizationName:= LeftStr(FetchElm(aRetNo, aFormIndex, aOrganizationNameId), 60); //20250529 Igor
    CharityIndicationCode:= GetT3010YesNoValue(aRetNo, aFormIndex, aCharityIndicationCodeYesId, aCharityIndicationCodeNoId);
    BusinessIdentifier:= FetchElm(aRetNo, aFormIndex, aBusinessIdentifierId);
    TotalAmount:= FetchElm(aRetNo, aFormIndex, TotalAmountId);
    NonCashAmount:= FetchElm(aRetNo, aFormIndex, aNonCashAmountId);
    CashAmount:= ReplaceStr(FloatToStr(StrToFloatDef(TotalAmount, 0) - StrToFloatDef(NonCashAmount, 0)), ',', '.');
    PoliticalActivityUsage:= '0002';
    PoliticalActivityUsageAmount:= '0';
    MunicipalityName:= LeftStr(FetchElm(aRetNo, aFormIndex, aMunicipalityNameId), 30); //20250529 Igor
    ProvinceName:= LeftStr('', 30); //20250529 Igor
    CountryCode:= FetchElm(aRetNo, aFormIndex, aCountryCodeId);
  end;
end;

function GetT1236SlipRec(aRetNo: Integer; aFName: String): AT1236SlipRec;
var
  lFormIndex: Integer;
begin
  lFormIndex:= RetList[aRetNo].GetFormNo(aFName);

  with Result do
  begin
    SetLength(T1236SlipDetails, 0);
    QualifiedDoneeCount:= FetchElm(aRetNo, lFormIndex, 77);

    AddDetailInfo(aRetNo, lFormIndex, 1, 2, 3, 4, 78, 0, 115, 7, 8);
    AddDetailInfo(aRetNo, lFormIndex, 9, 10, 11, 12, 79, 0, 116, 15, 16);
    AddDetailInfo(aRetNo, lFormIndex, 17, 18, 19, 20, 80, 0, 117, 23, 24);
    AddDetailInfo(aRetNo, lFormIndex, 25, 26, 27, 28, 81, 0, 118, 31, 32);
    AddDetailInfo(aRetNo, lFormIndex, 33, 34, 35, 36, 82, 0, 119, 39, 40);
    AddDetailInfo(aRetNo, lFormIndex, 41, 42, 43, 44, 83, 0, 120, 47, 48);
    AddDetailInfo(aRetNo, lFormIndex, 49, 50, 51, 52, 84, 0, 121, 55, 56);
    AddDetailInfo(aRetNo, lFormIndex, 57, 58, 59, 60, 85, 0, 122, 63, 64);
    AddDetailInfo(aRetNo, lFormIndex, 65, 66, 67, 68, 86, 0, 123, 71, 72);
    AddDetailInfo(aRetNo, lFormIndex, 38, 45, 46, 53, 62, 0, 69, 54, 61);
  end;
end;

procedure AT1441SlipRec.AddDetailInfo(aRetNo, aFormIndex: Integer; aRecipientNAmeId, aGrantPurposeId, aNonCashAmountDisbursedId, aCashAmountDisbursedId, aCountryLine1Id, aCountryLine2Id: Integer);
var
  lRecipientNAme: string;
begin
  lRecipientNAme:= FetchElm(aRetNo, aFormIndex, aRecipientNAmeId);

  if lRecipientNAme.IsEmpty then Exit;

  SetLength(T1441SlipDetails, succ(Length(T1441SlipDetails)));
  with T1441SlipDetails[pred(Length(T1441SlipDetails))] do
  begin
    RecipientNAme:= LeftStr(FetchElm(aRetNo, aFormIndex, aRecipientNAmeId), 60);
    GrantPurpose:= LeftStr(FetchElm(aRetNo, aFormIndex, aGrantPurposeId), 1000);
    NonCashAmountDisbursed:= FetchElm(aRetNo, aFormIndex, aNonCashAmountDisbursedId);
    CashAmountDisbursed:= FetchElm(aRetNo, aFormIndex, aCashAmountDisbursedId);
    Country:= LeftStr(Trim(FetchElm(aRetNo, aFormIndex, aCountryLine1Id) + ' ' + FetchElm(aRetNo, aFormIndex, aCountryLine2Id)), 100);
  end;
end;

function GetT1441SlipRec(aRetNo: Integer; aFName: String): AT1441SlipRec;
var
  lFormIndex: Integer;
begin
  lFormIndex:= RetList[aRetNo].GetFormNo(aFName);

  with Result do
  begin
    SetLength(T1441SlipDetails, 0);

    Count:= FetchElm(aRetNo, lFormIndex, 24);

    AddDetailInfo(aRetNo, lFormIndex, 4, 5, 6, 7, 8, 25);
    AddDetailInfo(aRetNo, lFormIndex, 9, 10, 11, 12, 13, 26);
    AddDetailInfo(aRetNo, lFormIndex, 14, 15, 16, 17, 18, 27);
    AddDetailInfo(aRetNo, lFormIndex, 19, 20, 21, 22, 23, 28);
    AddDetailInfo(aRetNo, lFormIndex, 29, 30, 31, 32, 33, 34);
    AddDetailInfo(aRetNo, lFormIndex, 35, 36, 37, 38, 39, 40);
    AddDetailInfo(aRetNo, lFormIndex, 41, 42, 43, 44, 45, 46);
    AddDetailInfo(aRetNo, lFormIndex, 47, 48, 49, 50, 51, 52);
    AddDetailInfo(aRetNo, lFormIndex, 53, 54, 55, 56, 57, 58);
  end;
end;

procedure AT2081Rec.AddSecFInfo(aRetNo, aFormIndex: Integer; aIndexId, aYearId, aStep1_PercentageId, aStep2_PercentageId, aStep3_PercentageId, aStep4_PercentageId,
                          aStep5_PercentageId, aStep6_PercentageId, aStep7_PercentageId: Integer);
begin
  SetLength(T2081SecFInfo, succ(Length(T2081SecFInfo)));
  with T2081SecFInfo[pred(Length(T2081SecFInfo))] do
  begin
    Index:= IntToStr(aIndexId);
    Year:= '20' + FetchElm(aRetNo, aFormIndex, aYearId);
    Step1_Percentage:= FetchElm(aRetNo, aFormIndex, aStep1_PercentageId);
    Step2_Percentage:= FetchElm(aRetNo, aFormIndex, aStep2_PercentageId);
    Step3_Percentage:= FetchElm(aRetNo, aFormIndex, aStep3_PercentageId);
    Step4_Percentage:= FetchElm(aRetNo, aFormIndex, aStep4_PercentageId);
    Step5_Percentage:= FetchElm(aRetNo, aFormIndex, aStep5_PercentageId);
    Step6_Percentage:= FetchElm(aRetNo, aFormIndex, aStep6_PercentageId);
    Step7_Percentage:= FetchElm(aRetNo, aFormIndex, aStep7_PercentageId);
  end;
end;

procedure AT2081Rec.AddP2SecAInfo(aRetNo, aFormIndex: Integer; aPercentageId, aAmountId, aAcquisitionId, aDispositionId: Integer);
begin
  SetLength(Part2SecAInfo, succ(Length(Part2SecAInfo)));
  with Part2SecAInfo[pred(Length(Part2SecAInfo))] do
  begin
    Percentage:= FetchElm(aRetNo, aFormIndex, aPercentageId);
    Amount:= FetchElm(aRetNo, aFormIndex, aAmountId);
    Acquisition:= GetT3010YesNoValue(aRetNo, aFormIndex, aAcquisitionId, 0);
    Disposition:= GetT3010YesNoValue(aRetNo, aFormIndex, aDispositionId, 0);
  end;
end;

procedure AT2081Rec.AddP2SecBInfo(aRetNo, aFormIndex: Integer; aNameOfPersonId, aPercentageId, aAmountId, aAcquisitionId, aDispositionId: Integer);
begin
  SetLength(Part2SecBInfo, succ(Length(Part2SecBInfo)));
  with Part2SecBInfo[pred(Length(Part2SecBInfo))] do
  begin
    NameOfPerson:= FetchElm(aRetNo, aFormIndex, aNameOfPersonId);
    Percentage:= FetchElm(aRetNo, aFormIndex, aPercentageId);
    Amount:= FetchElm(aRetNo, aFormIndex, aAmountId);
    Acquisition:= GetT3010YesNoValue(aRetNo, aFormIndex, aAcquisitionId, 0);
    Disposition:= GetT3010YesNoValue(aRetNo, aFormIndex, aDispositionId, 0);
  end;
end;

function GetT2081Rec(aRetNo: Integer; aFName: String): AT2081Rec;
var
  lFormIndex: Integer;
begin
  lFormIndex:= RetList[aRetNo].GetFormNo(aFName);

  with Result do
  begin
    CorporationName:= LeftStr(FetchElm(aRetNo, lFormIndex, 3), 175);
		ClassOfShares:= LeftStr(FetchElm(aRetNo, lFormIndex, 4), 175);
    TotalIssuedShares:= FetchElm(aRetNo, lFormIndex, 5);
    ShareValue:= FetchElm(aRetNo, lFormIndex, 6);
    SharesListedOnStockExchange:= GetT3010YesNoValue(aRetNo, lFormIndex, 92, 91);

    SecB_Percentage905:= FetchElm(aRetNo, lFormIndex, 7);
		SecB_Percentage910:= FetchElm(aRetNo, lFormIndex, 9);
    SecB_Percentage915:= FetchElm(aRetNo, lFormIndex, 10);
    SecB_Percentage920:= FetchElm(aRetNo, lFormIndex, 8);

    SecC_Percentage925:= FetchElm(aRetNo, lFormIndex, 11);
		SecC_Percentage930:= FetchElm(aRetNo, lFormIndex, 13);
    SecC_Percentage935:= FetchElm(aRetNo, lFormIndex, 14);
    SecC_Percentage940:= FetchElm(aRetNo, lFormIndex, 12);

    SecD_PercentageBelow945:= FetchElm(aRetNo, lFormIndex, 15);
		SecD_PercentageBelow950:= FetchElm(aRetNo, lFormIndex, 16);
		SecD_PercentageBelow955:= FetchElm(aRetNo, lFormIndex, 17);
		SecD_PercentageGreater941:= FetchElm(aRetNo, lFormIndex, 18);
    SecD_PercentageGreater945:= FetchElm(aRetNo, lFormIndex, 14);
    SecD_PercentageGreater946:= FetchElm(aRetNo, lFormIndex, 19);
    SecD_PercentageGreater947:= FetchElm(aRetNo, lFormIndex, 20);
    SecD_PercentageGreater948:= FetchElm(aRetNo, lFormIndex, 21);
    SecD_PercentageGreater949:= FetchElm(aRetNo, lFormIndex, 22);
    SecD_PercentageGreater950:= FetchElm(aRetNo, lFormIndex, 23);
    SecD_PercentageGreater955:= FetchElm(aRetNo, lFormIndex, 24);

    SecE_Percentage960:= FetchElm(aRetNo, lFormIndex, 25);
    SecE_Percentage965:= FetchElm(aRetNo, lFormIndex, 26);
    SecE_Percentage970:= FetchElm(aRetNo, lFormIndex, 27);
    SecE_Percentage975:= FetchElm(aRetNo, lFormIndex, 28);

    AddSecFInfo(aRetNo, lFormIndex, 1, 29, 35, 40, 0, 0, 0, 44, 50);
    AddSecFInfo(aRetNo, lFormIndex, 2, 30, 36, 0, 0, 0, 43, 45, 51);
    AddSecFInfo(aRetNo, lFormIndex, 3, 31, 37, 0, 0, 42, 0, 46, 52);
    AddSecFInfo(aRetNo, lFormIndex, 4, 32, 38, 0, 0, 0, 0, 47, 53);
    AddSecFInfo(aRetNo, lFormIndex, 5, 33, 39, 0, 0, 0, 0, 48, 54);
    AddSecFInfo(aRetNo, lFormIndex, 6, 34, 0, 0, 41, 0, 0, 49, 55);

    ExcessTransactionsPresent:= GetT3010YesNoValue(aRetNo, lFormIndex, 56, 57);

    AddP2SecAInfo(aRetNo, lFormIndex, 58, 59, 60, 61);
    AddP2SecAInfo(aRetNo, lFormIndex, 62, 63, 64, 65);
    AddP2SecAInfo(aRetNo, lFormIndex, 66, 67, 68, 69);
    AddP2SecAInfo(aRetNo, lFormIndex, 70, 71, 72, 73);
    AddP2SecAInfo(aRetNo, lFormIndex, 74, 75, 76, 77);
    AddP2SecAInfo(aRetNo, lFormIndex, 78, 79, 80, 81);
    AddP2SecAInfo(aRetNo, lFormIndex, 82, 83, 84, 85);
    AddP2SecAInfo(aRetNo, lFormIndex, 86, 87, 88, 89);
    AddP2SecAInfo(aRetNo, lFormIndex, 90, 93, 94, 95);
    AddP2SecAInfo(aRetNo, lFormIndex, 96, 97, 98, 99);
    AddP2SecAInfo(aRetNo, lFormIndex, 100, 101, 102, 103);

    AddP2SecBInfo(aRetNo, lFormIndex, 104, 105, 106, 107, 108);
    AddP2SecBInfo(aRetNo, lFormIndex, 109, 110, 111, 112, 113);
    AddP2SecBInfo(aRetNo, lFormIndex, 114, 115, 116, 117, 118);
    AddP2SecBInfo(aRetNo, lFormIndex, 119, 120, 121, 122, 123);
    AddP2SecBInfo(aRetNo, lFormIndex, 124, 125, 126, 127, 128);
    AddP2SecBInfo(aRetNo, lFormIndex, 129, 130, 131, 132, 133);
    AddP2SecBInfo(aRetNo, lFormIndex, 134, 135, 136, 137, 138);
    AddP2SecBInfo(aRetNo, lFormIndex, 139, 140, 141, 142, 143);
    AddP2SecBInfo(aRetNo, lFormIndex, 144, 145, 146, 147, 148);
    AddP2SecBInfo(aRetNo, lFormIndex, 149, 150, 151, 152, 153);
    AddP2SecBInfo(aRetNo, lFormIndex, 154, 155, 156, 157, 158);
    AddP2SecBInfo(aRetNo, lFormIndex, 159, 160, 161, 162, 163);
  end;
end;
//20250519 Igor <<<

end.
