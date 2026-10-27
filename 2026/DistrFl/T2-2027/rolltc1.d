[MAP]

//Provincial Jurisdiction
//Info.HeadOfficeAddress.Province=Provincial Jurisdiction^Transform:ProvinceShortToFull^T2^2
T2.ProvincialTax.Jurisdiction=Provincial Jurisdiction^Transform:ProvinceShortToFull^T2^2
// Info
Info.Activity.MainActivity=Naics^^T2^203
Info.Activity.Description1=princ pruct 1^^T2^208
Info.Activity.Percentage1=percent of prod^%^T2^209
Info.Activity.Description2=princ pruct 2^^T2^210
Info.Activity.Percentage2=percent of prod^%^T2^211
Info.Activity.Description3=princ pruct 3^^T2^212
Info.Activity.Percentage3=percent of prod^%^T2^213
Info.Corporation.Type=Corp type^Radio:[1=51,2=56,3=59,4=52,5=57]^T2^51
Info.Corporation.OtherCorpType=Oth corp descr^^T2^60
Info.Filing.YearStart=startYear^INCYEAR^T2^10
Info.Filing.YearEnd=endYear^INCYEAR^T2^11
Info.Filing.MemberOfPartnership=Prof Corp^Radio:[1=24,2=25]^T2^24
Info.HeadOfficeAddress.CareOf=co name^^T2^23
Info.HeadOfficeAddress.AddressLine1=HO street^^T2^12
Info.HeadOfficeAddress.AddressLine2=HO str2^^T2^13
Info.HeadOfficeAddress.City=ho city^^T2^16
Info.HeadOfficeAddress.Province=HO prov^^T2^17
Info.HeadOfficeAddress.PostalCode=ho postal^^T2^20
Info.HeadOfficeAddress.ZipCode=ho postal^&^T2^20
Info.HeadOfficeAddress.Country=HO country^^T2^19
Info.ID.CorporationName=Corp Name^^T2^3
Info.ID.BusinessNumber=BN^^T2^1
Info.LocationOfBooks.AddressLine1=lb str^^T2^38
Info.LocationOfBooks.AddressLine2=lb str2^^T2^41
Info.LocationOfBooks.City=lb city^^T2^44
Info.LocationOfBooks.Province=lb prov^^T2^45
Info.LocationOfBooks.PostalCode=lb postal^^T2^47
Info.LocationOfBooks.ZipCode=lb postal^&^T2^47
Info.LocationOfBooks.Country=lb country^^T2^46
Info.MailingAddress.AddressLine1=ml str^^T2^26
Info.MailingAddress.AddressLine2=ml str2^^T2^27
Info.MailingAddress.City=ml city^^T2^32
Info.MailingAddress.Province=ml prov^^T2^33
Info.MailingAddress.PostalCode=ml postal^^T2^35
Info.MailingAddress.ZipCode=ml postal^&^T2^35
Info.MailingAddress.Country=ml country^^T2^34
Info.Residency.ResidentOfCanada=Residency^Radio:[1=48,2=49]^T2^49
Info.Residency.Country=For country nm^^T2^50
Info.Residency.ClaimingExemption=Exempt under treaty^[1=63,2=64]^T2^63
Info.Residency.NonResidentCorpIncomeType=Exempt sec 149^Radio:[1=53,2=54,3=55,4=58]^T2^53

// Alberta INFO. Must be done first to enable other Alberta data
AT1.Identification.AccountNumber=Alb account^^AT1^9
AT1.Filing.NatureOfBusiness=Alb SIC^^AT1^58

// S8
S8.CCATable[y].ClassNumber=CCA class^EXTRACT^S8#1^y:6,28,50,72,94,116,138,160,181,204
S8.CCATable[y].UCCEndOfYear=CCA UCC^^S8#1^y:7,29,51,73,95,117,139,161,182,205

//  s9
S9.RelatedAndAssociated[y].CorpName=^^S9^y:4,13,22,31,40,49,58,67,76,85,94,103,112,121,130,139,148,157,166,175
S9.RelatedAndAssociated[y].Country=^^S9^y:5,14,23,32,41,50,59,68,77,86,95,104,113,122,131,140,149,158,167,176
S9.RelatedAndAssociated[y].BusinessNumber=^^S9^y:6,15,24,33,42,51,60,69,78,87,96,105,114,123,132,141,150,159,168,177
S9.RelatedAndAssociated[y].RelationshipCode=^^S9^y:7,16,25,34,43,52,61,70,79,88,97,106,115,124,133,142,151,160,169,178
S9.RelatedAndAssociated[y].CommonSharesCount=^^S9^y:8,17,26,35,44,53,62,71,80,89,98,107,116,125,134,143,152,161,170,179
S9.RelatedAndAssociated[y].CommonSharesPercent=^%^S9^y:9,18,27,36,45,54,63,72,81,90,99,108,117,126,135,144,153,162,171,180
S9.RelatedAndAssociated[y].PreferredSharesCount=^^S9^y:10,19,28,37,46,55,64,73,82,91,100,109,118,127,136,145,154,163,172,181
S9.RelatedAndAssociated[y].PreferredSharesPercent=^%^S9^y:11,20,29,38,47,56,65,74,83,92,101,110,119,128,137,146,155,164,173,182
S9.RelatedAndAssociated[y].BookValue=^^S9^y:12,21,30,39,48,57,66,75,84,93,102,111,120,129,138,147,156,165,174,183

// S23
S23.AllocateBusinessLimit[y].CorpName=^^S23^y:5,11,17,23,29,35,41,47,53,59,65,71,77,83,89,55,101,107,113,119
S23.AllocateBusinessLimit[y].BusinessNumber=^^S23^y:6,12,18,24,30,36,42,48,54,60,66,72,78,84,90,56,102,108,114,120
S23.AllocateBusinessLimit[y].AssociationCode=^^S23^y:7,13,19,25,31,37,43,49,55,61,67,73,79,85,91,57,103,109,115,121
S23.AllocateBusinessLimit[y].BusinessLimitBeforeAllocation=^^S23^y:8,14,20,26,32,38,44,50,56,62,68,74,80,86,92,58,104,110,116,122
S23.AllocateBusinessLimit[y].BusinessLimitPercent=^%^S23^y:9,15,21,27,33,39,45,51,57,63,69,75,81,87,93,59,105,111,117,123
///S23.AllocateBusinessLimit[y].BusinessLimitAllocated=^^S23^y:10,16,22,28,34,40,46,52,58,64,70,76,82,88,94,60,106,112,118,124

// S4Worksheet
S4Worksheet.NonCapitalLosses.CurrentYearNonCapitalLosses.EndBalance=^^S4WS^642
S4Worksheet.NonCapitalLosses[y].EndBalance=^^S4WS^y:635,628,621,614,607,600,593,586,579,572,565,558,551,544,537,530,523,516,509,502

S4Worksheet.FarmLosses[y].PriorYearEndBalance=^^S4WS^y:796,789,782,775,768,761,754,747,740,733,726,719,712,705,698,691,684,677,670,663
S4Worksheet.FarmLosses.CurrentYearFarmLosses.EndBalance=^^S4WS^803

S4Worksheet.RestrictedFarmLosses[y].PriorYearEndBalance=^^S4WS^y:957,950,943,936,929,922,915,908,901,894,887,880,873,866,859,852,845,838,831,824
S4Worksheet.RestrictedFarmLosses.CurrentYearRestrictedFarmLosses.EndBalance=^^S4WS^964

S4Worksheet.LPPLosses[y].PriorYearEndBalance=^^S4WS^y:75,69,63,57,51,45,98
S4Worksheet.LPPLosses.CurrentYearLLPLosses.EndBalance=^^S4WS^81

// S50

S50.Shareholders[y].Name=^^S50^y:4,9,14,19,24,29,34,39,44,49,54,59,64,69,74,79,84,89,94,99,104,109,114,119,124
S50.Shareholders[y].BusinessNumber=^^S50^y:5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100,105,110,115,120,125
S50.Shareholders[y].SIN=^^S50^y:6,11,16,21,26,31,36,41,46,51,56,61,66,71,76,81,86,91,96,101,106,111,116,126
S50.Shareholders[y].TrustNumber=^^S50^y:132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156
S50.Shareholders[y].CommonShares=^%^S50^y:7,12,17,22,27,32,37,42,47,52,57,62,67,72,77,82,87,92,97,102,107,112,117,122,127
S50.Shareholders[y].PreferredShares=^%^S50^y:8,13,18,23,28,33,38,43,48,53,58,63,68,73,78,83,88,93,98,103,108,113,118,123,128

// S100
S100.ClosingBalance.CurrentYear=RE^^S100^44


// T2sition=certif position^^T2^744
T2.Certification.PhoneNumber=Certif tel^AREA^T2^755
T2.Certification.Phone
T2.AdditionalInformation.Inactive=Corp Inactive^Radio:[1=201,2=202]^T2^201
T2.Certification.PoNumber=Certif tel^PHONE^T2^746
T2.Certification.ContactPhoneNumber=certif contact tel^AREA^T2^756
T2.Certification.ContactPhoneNumber=certif contact tel^PHONE^T2^750
T2.Certification.ContactName=Certif contact Name^^T2^749
T2.Certification.ContactSameAsSigning=Certif contact Same^Radio:[1=747,2=748]^T2^748


// Jurisdictions
Jurisdictions.Required.NLRequired=Jurisd^Transform:[1=Newfoundland]^T2^2
Jurisdictions.Required.NLORequired=Jurisd^Transform:[1=NFLD Offshore]^T2^2
Jurisdictions.Required.PERequired=Jurisd^Transform:[1=Prince Edward Island]|&^T2^2
Jurisdictions.Required.NSRequired=Jurisd^Transform:[1=Nova Scotia]|&^T2^2
Jurisdictions.Required.NSORequired=Jurisd^Transform:[1=N.S. Offshore]|&^T2^2
Jurisdictions.Required.NBRequired=Jurisd^Transform:[1=New Brunswick]|&^T2^2
Jurisdictions.Required.ONRequired=Jurisd^Transform:[1=Ontario]|&^T2^2
Jurisdictions.Required.MBRequired=Jurisd^Transform:[1=Manitoba]|&^T2^2
Jurisdictions.Required.SKRequired=Jurisd^Transform:[1=Saskatchewan]|&^T2^2
Jurisdictions.Required.BCRequired=Jurisd^Transform:[1=British Columbia]|&^T2^2
Jurisdictions.Required.YTRequired=Jurisd^Transform:[1=Yukon Territory]|&^T2^2
Jurisdictions.Required.NTRequired=Jurisd^Transform:[1=Northwest Territories]|&^T2^2
Jurisdictions.Required.NURequired=Jurisd^Transform:[1=Nunavut]|&^T2^2
Jurisdictions.Required.ABRequired=Jurisd^Transform:[1=Alberta]|&^T2^2
Jurisdictions.Required.QCRequired=Jurisd^Transform:[1=Quebec]|&^T2^2
Jurisdictions.Required.CO17OnLineFileIneligible

// T2FiveYearSummary
T2FiveYearSummary.PartITax[y].RefundableTaxOnInvestmentIncome=^^COMPSUM^y:64,65,66,67,68
T2FiveYearSummary.PartITax[y].SmallBusinessDeduction=^^COMPSUM^y:74,75,76,77,78
T2FiveYearSummary.PartITax[y].FederalTaxAbatement=^^COMPSUM^y:79,80,81,82,83
T2FiveYearSummary.PartITax[y].ManufacturingAndProcessingProfitsDeduction=^^COMPSUM^y:84,85,86,87,88
T2FiveYearSummary.PartITax[y].InvestmentCredit=^^COMPSUM^y:99,100,101,102,103
T2FiveYearSummary.PartITax[y].PartITaxPayable=^^COMPSUM^y:109,110,111,112,113
T2FiveYearSummary.Summary[y].PartITaxPayable=^^COMPSUM^y:114,115,116,117,118
T2FiveYearSummary.Summary[y].PartIISurtaxPayable=^^COMPSUM^y:59,60,61,62,63
T2FiveYearSummary.Summary[y].PartIII1TaxPayable=^^COMPSUM^y:119,120,121,122,123
T2FiveYearSummary.Summary[y].PartIVTaxPayable=^^COMPSUM^y:124,125,126,127,128
T2FiveYearSummary.Summary[y].NetProvincialTerritorialTaxPayable=^^COMPSUM^y:139,140,141,142,143
T2FiveYearSummary.Summary[y].ProvincialTaxLargeCorporations=^^COMPSUM^y:144,145,146,147,148
T2FiveYearSummary.Summary[y].InvestmentTaxCreditRefund=^^COMPSUM^y:159,160,161,162,163
T2FiveYearSummary.Summary[y].DividendRefund=^^COMPSUM^y:164,165,166,167,168
T2FiveYearSummary.Summary[y].TaxInstalmentsPaid=^^COMPSUM^y:189,190,191,192,193
T2FiveYearSummary.TaxableIncome[y].NetIncome=^^COMPSUM^y:19,20,21,22,23
T2FiveYearSummary.TaxableIncome[y].CharitableDonations=^^COMPSUM^y:24,25,26,27,28
T2FiveYearSummary.TaxableIncome[y].TaxableDividends=^^COMPSUM^y:29,30,31,32,33
T2FiveYearSummary.TaxableIncome[y].TaxableIncome=^^COMPSUM^y:44,45,46,47,48
T2FiveYearSummary.TaxableIncome[y].ActiveBusinessIncome=^^COMPSUM^y:49,50,51,52,53


// AT1
AT1.CorporationAddress.Description=^^AT1^67
AT1.CorporationAddress.AddressLine1=^^AT1^3
AT1.CorporationAddress.AddressLine2=^^AT1^4
AT1.CorporationAddress.City=^^AT1^5
AT1.CorporationAddress.Province=^^AT1^26
AT1.CorporationAddress.PostalCode=^^AT1^28
AT1.CorporationAddress.Country=^^AT1^27
AT1.Filing.NatureOfBusiness=Alb SIC^^AT1^58
AT1.Filing.TypeOfCorporation=^Radio:[1=32,2=33,3=34,4=35,5=36]^AT1^32
AT1.Filing.OtherSpecialCorpType=^Radio:[1=38,2=39,3=13,4=15,5=16]^AT1^38
AT1.Identification.CorporationName=^^AT1^1
AT1.Identification.OperatingName=^^AT1^2
AT1.Identification.AccountNumber=Alb account^^AT1^9
AT1.Identification.ContactName=^^AT1^29
AT1.Identification.ContactPhoneNumber=^^AT1^30
AT1.Identification.ContactFaxNumber=^^AT1^31


[Transform:ProvinceShortToFull]
AB=Alberta
BC=British Columbia
MB=Manitoba
NB=New Brunswick
NL=Newfoundland and Labrador
NT=Northwest Territories
NS=Nova Scotia
NU=Nunavut
ON=Ontario
PE=Prince Edward Island
QC=Quebec
SK=Saskatchewan
YT=Yukon
MJ=Multiple