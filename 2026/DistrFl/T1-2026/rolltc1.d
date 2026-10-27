[MAP]
//INFO----------------

Info.ID.SIN=SIN^SIN^INFO^3
Info.ID.BirthDate=Birthdate^DATE^INFO^9
Info.ID.Title=Title^^INFO^33
Info.ID.FirstName=FirstNM^^INFO^2
Info.ID.LastName=LastNm^^INFO^5
Info.Address.Apartment=Apartment^^INFO^22
Info.Address.CareOf=CareOf^^INFO^8
Info.Address.Street=Street^^INFO^6
Info.Address.POBox=PO Box^^INFO^68
Info.Address.RuralRoute=RR^^INFO^163
Info.Address.City=City^^INFO^10
Info.Address.Province=Province^Transform:ProvinceFullToShort^INFO^14
Info.Address.PostalCode=Postal^UPPERCASE^INFO^15
Info.Address.HomePhone=Phone Area Code^AREA^INFO^54
Info.Address.HomePhone=Phone No^PHONE^INFO^55
Info.Address.WorkPhone=Phone work area Code^AREA^INFO^71
Info.Address.WorkPhone=Phone work No^PHONE^INFO^72
Info.Address.WorkPhoneExtension=Phone work Ext^^INFO^114
Info.Address.MobilePhone=Cell Phone area code^AREA^INFO^74
Info.Address.MobilePhone=Cell phone No^PHONE^INFO^75
Info.Address.Fax=Faxareacode^AREA^INFO^62
Info.Address.Fax=FaxNo^PHONE^INFO^63
///=Pager AreaCode^AREA^INFO^118
///=Pager Number^PHONE^INFO^117

Info.Address.Email=EMail^^INFO^64
Info.ID.MaritalStatus=MarStatus^Radio:[1=11,2=12,3=13,4=16,5=17,6=18]^INFO^11
Info.Residency.ProvinceDec31=ProvResidence^Transform:ProvinceIDtoFull^INFO^1
Info.Residency.ProvinceSelfEmployment=ProvSelfEmpl^^INFO^21
Info.Filing.OnlineMail=EfileIt^Transform:[3=X]^INFO^46
Info.Filing.CanadianCitizen=CND Citizen^X^INFO^164
Info.Filing.AuthorizeElectionsCanada=Elections^X^INFO^43
Info.SpouseID.SIN=SpouseSin^SIN^INFO^4
Info.SpouseID.FirstName=SpouseFirstName^^INFO^20
Info.SpouseID.LastName=SpouseLastName^^INFO^45
Info.SpouseID.BirthDate=SpouseBirthDate^DATE^INFO^59

RRSPContributions.PriorYearRRSPLimit.M[0]=RSP lim^^RRSP^1
RRSPContributions.PriorYearTotals.M[4]=Unclaimed Contr^^CFR^31

RRSPContributions.HBPRepayments.M[1]=HBP balance^^RRSP^80
RRSPContributions.LLPRepayments.M[1]=LLP balance^^RRSP^84

T936.NetInvestmentLoss.M[1]=CNILExpensesPriorYrs^^CFR^29
T936.NetInvestmentLoss.M[4]=CNILIncomePriorYears^^CFR^30

S11.Education.M[0]=Tuition cf Fed^^S11^13
//=Tuition cf prv^^S11PRV^13

StudentLoanInterestWorksheet.StudentLoan[3].StartingBalance=student loan-2012^^STLOAN^15
StudentLoanInterestWorksheet.StudentLoan[2].StartingBalance=student loan-2013^^STLOAN^19
StudentLoanInterestWorksheet.StudentLoan[1].StartingBalance=student loan-2014^^STLOAN^23
StudentLoanInterestWorksheet.StudentLoan[0].StartingBalance=student loan-2015^^STLOAN^27

//=MovingExpenses^^CFR^38

//!!!!!!!form "RESEXP" not found in VT
T1229.CumulativeExplorationExpense.M[0]=CEE^^RESEXP^1
T1229.CumulativeDevelopmentExpense.M[0]=CDE^^RESEXP^2
T1229.CumulativeOilAndGasExpense.M[0]=COGPE^^RESEXP^3
///=ForExplAndDev^^RESEXP^4

///=Notes 1^^PRIVAT#1^2
///=Notes 1^^PRIVAT#1^3
///=Notes 1^^PRIVAT#1^4
///=Notes 1^^PRIVAT#1^5
///=Notes 1^^PRIVAT#1^6
///=Notes 1^^PRIVAT#1^7
///=Notes 1^^PRIVAT#1^8
///=Notes 1^^PRIVAT#1^9
///=Notes 1^^PRIVAT#1^10
///=Notes 1^^PRIVAT#1^11

NonCapitalLosses.NonCapital[9].StartBalance=NonCapLoss2009^+^CFR^102
NonCapitalLosses.NonCapital[8].StartBalance=NonCapLoss2009^+^CFR^102
NonCapitalLosses.NonCapital[7].StartBalance=NonCapLoss2009^+^CFR^102
NonCapitalLosses.NonCapital[6].StartBalance=NonCapLoss2009^+^CFR^102
NonCapitalLosses.NonCapital[5].StartBalance=NonCapLoss2010^^CFR^107
NonCapitalLosses.NonCapital[4].StartBalance=NonCapLoss2011^^CFR^112
NonCapitalLosses.NonCapital[3].StartBalance=NonCapLoss2012^^CFR^117
NonCapitalLosses.NonCapital[2].StartBalance=NonCapLoss2013^^CFR^122
NonCapitalLosses.NonCapital[1].StartBalance=NonCapLoss2014^^CFR^127
NonCapitalLosses.NonCapital[0].StartBalance=NonCapLoss2015^^CFR^132

NonCapitalLosses.RestrictedFarm[9].StartBalance=RestrFarmLoss2006^^CFR^205
NonCapitalLosses.RestrictedFarm[8].StartBalance=RestrFarmLoss2007^^CFR^210
NonCapitalLosses.RestrictedFarm[7].StartBalance=RestrFarmLoss2008^^CFR^215
NonCapitalLosses.RestrictedFarm[6].StartBalance=RestrFarmLoss2009^^CFR^220
NonCapitalLosses.RestrictedFarm[5].StartBalance=RestrFarmLoss2010^^CFR^225
NonCapitalLosses.RestrictedFarm[4].StartBalance=RestrFarmLoss2011^^CFR^230
NonCapitalLosses.RestrictedFarm[3].StartBalance=RestrFarmLoss2012^^CFR^235
NonCapitalLosses.RestrictedFarm[2].StartBalance=RestrFarmLoss2013^^CFR^240
NonCapitalLosses.RestrictedFarm[1].StartBalance=RestrFarmLoss2014^^CFR^245
NonCapitalLosses.RestrictedFarm[0].StartBalance=RestrFarmLoss2015^^CFR^250

NonCapitalLosses.FarmingFishing[9].StartBalance=FarmLoss2006^^CFR^146
NonCapitalLosses.FarmingFishing[8].StartBalance=FarmLoss2007^^CFR^151
NonCapitalLosses.FarmingFishing[7].StartBalance=FarmLoss2008^^CFR^156
NonCapitalLosses.FarmingFishing[6].StartBalance=FarmLoss2009^^CFR^161
NonCapitalLosses.FarmingFishing[5].StartBalance=FarmLoss2010^^CFR^166
NonCapitalLosses.FarmingFishing[4].StartBalance=FarmLoss2011^^CFR^171
NonCapitalLosses.FarmingFishing[3].StartBalance=FarmLoss2012^^CFR^176
NonCapitalLosses.FarmingFishing[2].StartBalance=FarmLoss2013^^CFR^181
NonCapitalLosses.FarmingFishing[1].StartBalance=FarmLoss2014^^CFR^186
NonCapitalLosses.FarmingFishing[0].StartBalance=FarmLoss2015^^CFR^191

//dependants -------------------------------------------------
Dependant[0].Identification.FirstName=Dep#1 First Name^^DEPEND^5
Dependant[0].Identification.LastName=Dep#1 Last Name^^DEPEND^6
Dependant[0].Identification.SIN=Dep#1 SIN^SIN^DEPEND^7
Dependant[0].Identification.DateOfBirth=Dep#1 Birth Day^DATE^DEPEND^10
Dependant[0].Identification.Relationship=Dep#1^Transform:RELATIONSHIP^DEPEND^11

Dependant[1].Identification.FirstName=Dep#2 First Name^^DEPEND^20
Dependant[1].Identification.LastName=Dep#2 Last Name^^DEPEND^21
Dependant[1].Identification.SIN=Dep#2 SIN^SIN^DEPEND^22
Dependant[1].Identification.DateOfBirth=Dep#2 Birth Day^DATE^DEPEND^25
Dependant[1].Identification.Relationship=Dep#2^Transform:RELATIONSHIP^DEPEND^26

Dependant[2].Identification.FirstName=Dep#3 First Name^^DEPEND^35
Dependant[2].Identification.LastName=Dep#3 Last Name^^DEPEND^36
Dependant[2].Identification.SIN=Dep#3 SIN^SIN^DEPEND^37
Dependant[2].Identification.DateOfBirth=Dep#3 Birth Day^DATE^DEPEND^40
Dependant[2].Identification.Relationship=Dep#3^Transform:RELATIONSHIP^DEPEND^41

Dependant[3].Identification.FirstName=Dep#4 First Name^^DEPEND^50
Dependant[3].Identification.LastName=Dep#4 Last Name^^DEPEND^51
Dependant[3].Identification.SIN=Dep#4 SIN^SIN^DEPEND^52
Dependant[3].Identification.DateOfBirth=Dep#4 Birth Day^DATE^DEPEND^55
Dependant[3].Identification.Relationship=Dep#4^Transform:RELATIONSHIP^DEPEND^56

Dependant[4].Identification.FirstName=Dep#5 First Name^^DEPEND^65
Dependant[4].Identification.LastName=Dep#5 Last Name^^DEPEND^66
Dependant[4].Identification.SIN=Dep#5 SIN^SIN^DEPEND^67
Dependant[4].Identification.DateOfBirth=Dep#5 Birth Day^DATE^DEPEND^70
Dependant[4].Identification.Relationship=Dep#5^Transform:RELATIONSHIP^DEPEND^71

Dependant[5].Identification.FirstName=Dep#6 First Name^^DEPEND^80
Dependant[5].Identification.LastName=Dep#6 Last Name^^DEPEND^81
Dependant[5].Identification.SIN=Dep#6 SIN^SIN^DEPEND^82
Dependant[5].Identification.DateOfBirth=Dep#6 Birth Day^DATE^DEPEND^85
Dependant[5].Identification.Relationship=Dep#6^Transform:RELATIONSHIP^DEPEND^86

Dependant[6].Identification.FirstName=Dep#7 First Name^^DEPEND^95
Dependant[6].Identification.LastName=Dep#7 Last Name^^DEPEND^96
Dependant[6].Identification.SIN=Dep#7 SIN^SIN^DEPEND^97
Dependant[6].Identification.DateOfBirth=Dep#7 Birth Day^DATE^DEPEND^100
Dependant[6].Identification.Relationship=Dep#7^Transform:RELATIONSHIP^DEPEND^101

Dependant[7].Identification.FirstName=Dep#8 First Name^^DEPEND^110
Dependant[7].Identification.LastName=Dep#8 Last Name^^DEPEND^111
Dependant[7].Identification.SIN=Dep#8 SIN^SIN^DEPEND^112
Dependant[7].Identification.DateOfBirth=Dep#8 Birth Day^DATE^DEPEND^115
Dependant[7].Identification.Relationship=Dep#8^Transform:RELATIONSHIP^DEPEND^116

Dependant[8].Identification.FirstName=Dep#9 First Name^^DEPEND^125
Dependant[8].Identification.LastName=Dep#9 Last Name^^DEPEND^126
Dependant[8].Identification.SIN=Dep#9 SIN^SIN^DEPEND^127
Dependant[8].Identification.DateOfBirth=Dep#9 Birth Day^DATE^DEPEND^130
Dependant[8].Identification.Relationship=Dep#9^Transform:RELATIONSHIP^DEPEND^131
//end dependants -------------------------------------------------

NetCapitalLosses.LossBalance.M[0]=CapLoss-pre85^^CFR^465
NetCapitalLosses.LossBalance.M[1]=CapLoss-May2285ToBefr88^^CFR^470
NetCapitalLosses.LossBalance.M[2]=CapLoss-88and89^^CFR^475
NetCapitalLosses.LossBalance.M[4]=CapLoss-1999^^CFR^480
NetCapitalLosses.LossBalance.M[6]=CapLoss-2000^^CFR^485
T657.CarryForward[Y].CapitalGainsDeduction=CapLoss-Year^+^CFR^Transform:CapLoss:<T657.CarryForward[Y].Year>

NetCapitalLosses.LossBalance.InclusionRate=Incl rate-2000^%^CFR^040

DonationsWorkSheet.DonationsCarryforwardLastYear.StartBalance=Donations2011^^DON^136
DonationsWorkSheet.DonationsCarryforward[3].StartBalance=Donations2012^^DON^141
DonationsWorkSheet.DonationsCarryforward[2].StartBalance=Donations2013^^DON^90
DonationsWorkSheet.DonationsCarryforward[1].StartBalance=Donations2014^^DON^95
DonationsWorkSheet.DonationsCarryforward[0].StartBalance=Donations2015^^DON^100

// comp summary-------------------------------------------------
T15YearSummary.Income[Y].Employment=101 Employment Income^^YRSUM^Y:009,10,11,12
//T15YearSummary.Income[0].=102 Commissions on T4's^^YRSUM^014,15,16,17
T15YearSummary.Income[Y].OtherEmployment=104 Other employment income^^YRSUM^Y:019,20,21,22
T15YearSummary.Income[Y].OAS=113 OAS^^YRSUM^Y:024,25,26,27
T15YearSummary.Income[Y].CPP=114 Canada or Quebec Pension^^YRSUM^Y:029,30,31,32
///=152 Disability benefits^^YRSUM^034
T15YearSummary.Income[Y].Pension=115 Other pensions^^YRSUM^Y:039,40,41,42
T15YearSummary.Income[Y].EI=119 UI benefits^^YRSUM^Y:044,45,46,47
T15YearSummary.Income[Y].TaxableDividends=120 Taxable dividends^^YRSUM^Y:049,50,51,52
T15YearSummary.Income[Y].Investment=121 Interest^^YRSUM^Y:054,55,56,57
T15YearSummary.Income[Y].Partnership=122 Partnership Income^^YRSUM^Y:059,60,61,62
T15YearSummary.Income[Y].Rental=126 Rental income - Net^^YRSUM^Y:064,65,66,67
T15YearSummary.Income[Y].CapitalGains=127 Taxable capital gains^^YRSUM^Y:069,70,71,72
T15YearSummary.Income[Y].SupportPayments=128 Alimony/separation income^^YRSUM^Y:074,75,76,77
T15YearSummary.Income[Y].RRSP=129 RRSP income^^YRSUM^Y:079,80,81,82
T15YearSummary.Income[Y].Other=130 Other income^^YRSUM^Y:084,85,86,87
///=135 Business income^^YRSUM^Y:089,90,91,92
///=137 Professional income^^YRSUM^Y:094,95,96,97
///=139 Commission income^^YRSUM^Y:099,100,101,102
///=141 Farming income^^YRSUM^Y:104,105,106,107
///=143 Fishing income^^YRSUM^Y:109,110,111,112
//FC000\000R=133 Worker's Compensation^^YRSUM^094
///=145 Social assistance payments^^YRSUM^Y:119,120,121,122
///=146 Net federal supplement^^YRSUM^Y:124,125,126,127
T15YearSummary.Income[Y].TotalIncome=150 Total Income^^YRSUM^Y:129,130,131,132

///=206 Pension adjustment^^YRSUM^Y:134,135,136,137
T15YearSummary.NetIncome[Y].RPP=207 RPP  contributions^^YRSUM^Y:139,140,141,142
T15YearSummary.NetIncome[Y].RRSP=208 RRSP contributions^^YRSUM^Y:144,145,146,147
///=209 Sask Pension Plan^^YRSUM^Y:149,150,151,152
T15YearSummary.NetIncome[Y].SplitPension=210 Deduction for Pension split^^YRSUM^Y:234,235,236,237
T15YearSummary.NetIncome[Y].Dues=212 Union\ professional dues^^YRSUM^Y:154,155,156,157
T15YearSummary.NetIncome[Y].ChildCare=214 Child care expenses^^YRSUM^Y:159,160,161,162
T15YearSummary.NetIncome[Y].DisabilitySupport=215 Attendant care expenses^^YRSUM^Y:164,165,166,167
T15YearSummary.NetIncome[Y].ABIL=217 Business investment losses^^YRSUM^Y:169,170,171,172
T15YearSummary.NetIncome[Y].MovingExpenses=219 Moving expenses^^YRSUM^Y:174,175,176,177
T15YearSummary.NetIncome[Y].SupportPayments=220 Alimony/separation paid^^YRSUM^Y:179,180,181,182
T15YearSummary.NetIncome[Y].CarryingCharges=221 Carrying charges^^YRSUM^Y:184,185,186,187
T15YearSummary.NetIncome[Y].CPP=222 Deduction for CPP/QPP on S/E^^YRSUM^Y:224,225,226,227
T15YearSummary.NetIncome[Y].Exploration=224 Expl. and development^^YRSUM^Y:189,190,191,192
T15YearSummary.NetIncome[Y].OtherEmployment=229 Other employment expenses^^YRSUM^Y:194,195,196,197
T15YearSummary.NetIncome[Y].ClergyResidence=231 Clergy regidence deduction^^YRSUM^Y:214,215,216,217
T15YearSummary.NetIncome[Y].Other=232 Other deductions^^YRSUM^Y:199,200,201,202
T15YearSummary.NetIncome[Y].SocialBenefitsRepayment=235 Social Benefits repayment^^YRSUM^Y:204,205,206,207
T15YearSummary.NetIncome[Y].NetIncome=236 Net Income^^YRSUM^Y:209,210,211,212
//FC000\000R=237 Acc. frwrd avrg withdrawal^^YRSUM^309
T15YearSummary.TaxableIncome[Y].CanadianForces=244 Canadian forces/Police deduction^^YRSUM^Y:489,490,491,492
T15YearSummary.TaxableIncome[Y].EmployeeHomeRelocation=248 Employee home reloc. loan^^YRSUM^Y:314,315,316,317
T15YearSummary.TaxableIncome[Y].SecurityOptions=249 Stock and shares deduction^^YRSUM^Y:319,320,321,322
T15YearSummary.TaxableIncome[Y].OtherPayments=250 Other payments deduction^^YRSUM^Y:324,325,326,327
T15YearSummary.TaxableIncome[Y].LimitedPartnershipLosses=251 Losses of other years^^YRSUM^Y:329,330,331,332
T15YearSummary.TaxableIncome[Y].NonCapitalLosses=252 Non-cap losses of other yrs^^YRSUM^Y:334,335,336,337
T15YearSummary.TaxableIncome[Y].NetCapitalLosses=253 Net Cap losses of other yrs^^YRSUM^Y:339,340,341,342
T15YearSummary.TaxableIncome[Y].CapitalGainsDeduction=254 Capital gains deduction^^YRSUM^Y:344,345,346,347
T15YearSummary.TaxableIncome[Y].NorthernResidents=255 Northern residents ded.^^YRSUM^Y:349,350,351,352
T15YearSummary.TaxableIncome[Y].AdditionalDeductions=256 Additional deductions^^YRSUM^Y:354,355,356,357
T15YearSummary.TaxableIncome[Y].TaxableIncome=260 Taxable Income^^YRSUM^Y:359,360,361,362

T15YearSummary.NRTC[Y].BasicPersonalAmount=300 Basic personal amount^^YRSUM^Y:364,365,366,367
T15YearSummary.NRTC[Y].AgeAmount=301 Age amount^^YRSUM^Y:369,370,371,372
T15YearSummary.NRTC[Y].SpouseAmount=303 Spousal amount^^YRSUM^Y:374,375,376,377
T15YearSummary.NRTC[Y].EligibleDependant=305 Equivalent to spouse amt^^YRSUM^Y:379,380,381,382
T15YearSummary.NRTC[Y].InfirmDependants=306 Infirm dependants^^YRSUM^Y:384,385,386,387
T15YearSummary.NRTC[Y].CPPContributions=308 CPP contribut.^^YRSUM^Y:394,395,396,397
T15YearSummary.NRTC[Y].CPPOnSelfEmployment=310 CPP on self-empl. earnings^^YRSUM^Y:399,400,401,402
T15YearSummary.NRTC[Y].EIEmployment=312 UIC premiums^^YRSUM^Y:404,405,406,407
T15YearSummary.NRTC[Y].PensionIncome=314 Pension Income Amount^^YRSUM^Y:409,410,411,412
T15YearSummary.NRTC[Y].Caregiver=315 Caregiver amount^^YRSUM^Y:414,415,416,417
T15YearSummary.NRTC[Y].DisabilitySelf=316 Disability for self^^YRSUM^Y:419,420,421,422
T15YearSummary.NRTC[Y].DisabilityDependant=318 Disability for dependants^^YRSUM^Y:424,425,426,427
T15YearSummary.NRTC[Y].StudentLoanInterest=319 Interest paid on your student loans^^YRSUM^Y:429,430,431,432
//FC000\000R=320 Tuition fees for self^^YRSUM^434
//FC000\000R=322 Education amount for self^^YRSUM^444
T15YearSummary.NRTC[Y].Tuition=323 Tuition and education^^YRSUM^Y:449,450,451,452
T15YearSummary.NRTC[Y].TuitionTransfer=324 Transfers from child^^YRSUM^Y:454,455,456,457
T15YearSummary.NRTC[Y].AmountsFromSpouse=326 Transfers from spouse^^YRSUM^Y:459,460,461,462
///=330 Medical expenses^^YRSUM^Y:464,465,466,467
T15YearSummary.NRTC[Y].NetMedical=332 Medical expenses^^YRSUM^Y:469,470,471,472
T15YearSummary.NRTC[Y].TotalCreditsBeforeDonations=338 Non-refundable Tax credits^^YRSUM^Y:474,475,476,477
T15YearSummary.NRTC[Y].Donations=349 Charitable donations^^YRSUM^Y:479,480,481,482
T15YearSummary.NRTC[Y].TotalNonRefundableCredits=350 Total Non-Refundable Crdts^^YRSUM^Y:484,485,486,487

T15YearSummary.TotalPayable[1].TotalFederalTax=406 Federal Tax^^YRSUM^Y:609,610,611,612
T15YearSummary.TotalPayable[Y].PoliticalContributions=410 Fed. pol. contr. tax credit^^YRSUM^Y:619,620,621,622
T15YearSummary.TotalPayable[Y].ITC=412 Investment tax credit^^YRSUM^Y:624,625,626,627
///=413 Labour-Sponsored Funds\Cost^^YRSUM^Y:629,630,631,632
T15YearSummary.TotalPayable[Y].LabourSponsoredFunds=414 Labour-Sponsored Funds Crdt^^YRSUM^Y:634,635,636,637
T15YearSummary.TotalPayable[Y].SpecialTaxes=418 Additional tax on RESP income^^YRSUM^Y:639,640,641,642
//FC000\000R=419 Federal individual surtax^^YRSUM^Y:644
T15YearSummary.TotalPayable[Y].NetFederalTax=420 Net Federal Tax^^YRSUM^Y:649,650,651,652
T15YearSummary.TotalPayable[Y].SelfEmploymentCPP=421 CPP on self-employment^^YRSUM^Y:654,655,656,657
T15YearSummary.TotalPayable[Y].SocialBenefitsRepayment=422 Social Benefits Repayment^^YRSUM^Y:659,660,661,662
T15YearSummary.TotalPayable[Y].ProvincialTerritorialTax=428 Provincial Tax^^YRSUM^Y:664,665,666,667
//FC000\000R=431 Net Provincial Tax^^YRSUM^734
T15YearSummary.TotalPayable[Y].TotalTaxPayable=435 Total Tax Payable^^YRSUM^Y:669,670,671,672
T15YearSummary.TotalCredits[Y].IncomeTaxDeducted=437 Total Tax per slips^^YRSUM^Y:674,675,676,677
//FC000\000R=438 Quebec Tax deducted xfer^^YRSUM^679
//FC000\000R=439 Tax applicable to Fed. Tax^^YRSUM^684
T15YearSummary.TotalCredits[Y].RefundableQCAbatement=440 Refundable Quebec Abatement^^YRSUM^Y:689,690,691,692
T15YearSummary.TotalCredits[Y].CPPOverpayment=448 CPP Overpayment^^YRSUM^Y:694,695,696,697
T15YearSummary.TotalCredits[Y].EIOverpayment=450 UI Overpayment^^YRSUM^Y:699,700,701,702
T15YearSummary.TotalCredits[Y].RefundOfITC=454 Refund of ITC^^YRSUM^Y:704,705,706,707
T15YearSummary.TotalCredits[Y].TrustTaxCredit=456 Part XII.2 Tax Credit^^YRSUM^Y:709,710,711,712
T15YearSummary.TotalCredits[Y].GSTHSTRebate=457 Empl/Partner GST rebate^^YRSUM^Y:714,715,716,717
T15YearSummary.TotalCredits[Y].TaxPaid=476 Tax paid by instalments^^YRSUM^Y:719,720,721,722
//FC000\000R=478 Forward averaging tax crdt^^YRSUM^724
T15YearSummary.TotalCredits[Y].ProvincialTerritorialTaxCredits=479 Provincial Tax Credits^^YRSUM^Y:729,730,731,732
//FC000\000R=480 Alberta SS Plan Credit^^YRSUM^734
T15YearSummary.TotalCredits[Y].RefundBalanceOwing=484 Refund^^YRSUM^Y:739,740,741,742
///=485 Balance Due^^YRSUM^Y:744,745,746,747

// //2125-------------------------------------------------
T2125Forms[y].T2125.Identification.FiscalPeriodStart=T2125#y-Fiscal1^INCYEAR^T2125#y^4
T2125Forms[y].T2125.Identification.FiscalPeriodEnd=T2125#y-Fiscal2^INCYEAR^T2125#y^5
T2125Forms[y].T2125.Identification.TypeOfBusinessIncome=T2125#y-BusOrComm^Radio:[1=73,2=73,3=74]^T2125#y^73
T2125Forms[y].T2125.Identification.BusinessName=T2125#y-Bus name^^T2125#y^8
T2125Forms[y].T2125.Identification.Address=T2125#y-adress1^^T2125#y^10
T2125Forms[y].T2125.Identification.City=T2125#y-City^^T2125#y^13
T2125Forms[y].T2125.Identification.Province=T2125#y-City^&^T2125#y^13
T2125Forms[y].T2125.Identification.PostalCode=T2125#y-postal^^T2125#y^14
T2125Forms[y].T2125.Identification.MainProduct=T2125#y-main Product^^T2125#y^9
T2125Forms[y].T2125.Identification.IndustryCode=T2125#y-NAICS^^T2125#y^12
T2125Forms[y].T2125.Identification.PartnershipBusinessNumber=T2125#y-partnership id^^T2125#y^15
T2125Forms[y].T2125.Identification.TaxShelterNumber=T2125#y-taxShelterNo^^T2125#y^16
T2125Forms[y].T2125.Identification.AccountNumber=T2125#y-BusNum1^^T2125#y^19
///=T2125#y-BusNum2^^T2125#y^20
///=T2125#y-BusNum3^^T2125#y^21
T2125Forms[y].T2125.PartnerDetails.Allocation=T2125#y-Percent^%^T2125#y^18
// FC036\0035R=T2125#y-GrossInc^^T2125#y^623
T2125Forms[y].T2125.BusinessUseOfHome.M[14]=T2125#y-CFHomeUseCF^^T2125#y^231
T2125Forms[y].T2125CEC.CEC.M[0]=T2125#y-CFCEC^^T2125#y^642

T2125Forms[y].T2125.OtherPartners[y1].Allocation=T2125#y-spouse percent^%^T2125#y^Y1:238,241,244,247,250
T2125Forms[y].T2125.OtherPartners[y1].FirstName=T2125#y-Partn1FirstNm^^T2125#y^Y1:257,258,259,260,261
T2125Forms[y].T2125.OtherPartners[y1].LastName=T2125#y-Partn1LastNm^^T2125#y^Y1:239,248,264,267,270
///=T2125#y-Partn1Sin^^T2125#y^362
T2125Forms[y].T2125.OtherPartners[y1].City=T2125#y-Partn1Adress1^^T2125#y^Y1:236,245,263,266,269
T2125Forms[y].T2125.OtherPartners[y1].Province=T2125#y-Partn1Adress1^&^T2125#y^Y1:236,245,263,266,269
T2125Forms[y].T2125.OtherPartners[y1].PostalCode=T2125#y-Partn1Adress1^&^T2125#y^Y1:236,245,263,266,269

// //776-------------------------------------------------
T776Forms[y].T776.Identification.FiscalPeriodStart=T776 #y-from date^INCYEAR^T776#y^3
T776Forms[y].T776.Identification.FiscalPeriodEnd=T776 #y-to date^INCYEAR^T776#y^6

///=T776 #y-Rental Name^^T776#y^109
///=T776 #y-Rental Addy^^T776#y^110
///=T776 #y-Rentat Post^UPPERCASE^T776 #y^111

T776Forms[y].T776.Identification.PartnershipBusinessNumber=T776 #y-partnershId^^T776#y^11
T776Forms[y].T776.Identification.TaxShelterNumber=T776 #y-tax sh no^^T776#y^13
T776Forms[y].T776.Identification.AccountNumber=T776 #y-bus no^^T776#y^15
///=T776 #y-bus no^^T776#y^16
///=T776 #y-bus no^^T776#y^17
T776Forms[y].T776.PartnerDetails.Allocation=T776 #y-percent^%^T776#y^18

T776Forms[y].T776.IncomeDetails[y1].GrossRents=T776 #y-Income^^T776#y^y1:47,50,53
T776Forms[y].T776.IncomeDetails[y1].Address=T776 #y-str^^T776#y^y1:45,48,51
T776Forms[y].T776.IncomeDetails[y1].City=T776 #y-str^&^T776#y^y1:45,48,51
T776Forms[y].T776.IncomeDetails[y1].Province=T776 #y-str^&^T776#y^y1:45,48,51
T776Forms[y].T776.IncomeDetails[y1].PostalCode=T776 #y-str^&^T776#y^y1:45,48,51
T776Forms[y].T776.IncomeDetails[y1].NumberOfUnits=T776 #y-Units^^T776#y^y1:46,49,52

//?need? T776Forms[y].T776.OtherIncome[y1].Description=T776 #y-Other income Descr^&^T776#y^54
//?need? T776Forms[y].T776.OtherIncome[y1].Amount=T776 #y-Other income Amount^+^T776#y^55

T776Forms[y].T776.OtherPartners[y1].FirstName=T776 #y-prtn1 f-name^^T776#y^y1:22,25,29,33,37,41
T776Forms[y].T776.OtherPartners[y1].LastName=T776 #y-prtn1 l-name^^T776#y^y1:117,26,30,34,38,42
///=T776 #y-prtn1 sin^^T776#y^120
T776Forms[y].T776.OtherPartners[y1].Address=T776 #y-prtn1 addr^^T776#y^y1:119,121,123,125,127,129
T776Forms[y].T776.OtherPartners[y1].Allocation=T776 #y-sp percent^%^T776#y^y1:24,28,32,36,40,44


// T2121 Fishing-------------------------------------------------
T2121Forms[y].T2121.Identification.FiscalPeriodStart=T2121#y-Fiscal1^INCYEAR^T2121#y^4
T2121Forms[y].T2121.Identification.FiscalPeriodEnd=T2121#y-Fiscal2^INCYEAR^T2121#y^5
T2121Forms[y].T2121.Identification.IndustryCode=T2121#y-Industry Code^NAICS^T2121#y^11
T2121Forms[y].T2121.Identification.BoatName=T2121#y-Boat name^^T2121#y^8
T2121Forms[y].T2121.Identification.VesselRegistrationNumber=T2121#y-CV license^^T2121#y^29
//=T2121#y-addr^^T2121#y^75
T2121Forms[y].T2121.Identification.City=T2121#y-City^^T2121#y^61
T2121Forms[y].T2121.Identification.Province=T2121#y-postal^^T2121#y^89
T2121Forms[y].T2121.Identification.PostalCode=T2121#y-postal^^T2121#y^75
T2121Forms[y].T2121.Identification.MainProduct=T2121#y-Main Species^^T2121#y^9
T2121Forms[y].T2121.Identification.PartnershipBusinessNumber=T2121#y-partnership id^^T2121#y^12
T2121Forms[y].T2121.Identification.TaxShelterNumber=T2121#y-taxShelterNo^^T2121#y^14
T2121Forms[y].T2121.Identification.AccountNumber=T2121#y-BusNum1^^T2121#y^15
///=T2121#y-BusNum2^^T2121#y^16
///=T2121#y-BusNum3^^T2121#y^17
T2121Forms[y].T2121.PartnerDetails.Allocation=T2121#y-Percent^%^T2121#y^18
T2121Forms[y].T2121.Income.GrossIncome=T2121#y-GrossInc^^T2121#y^35

///=T2121#y-CFHomeUse^^T2121#y^328
T2121Forms[y].T2121CEC.CEC.M[y]=T2121#y-CFCEC^^T2121#y^523

T2121Forms[y].T2121.OtherPartners[y1].Allocation=T2121#y-Sp percent^%^T2121#y^y1:505,509,513,517,521
T2121Forms[y].T2121.OtherPartners[y1].FirstName=T2121#y-Partn1FirstNm^^T2121#y^y1:503,507,511,515,519
T2121Forms[y].T2121.OtherPartners[y1].LastName=T2121#y-Partn1LastNm^^T2121#y^y1:537,539,541,543,545
///=T2121#y-Partn1Sin^^T2121#y^540
T2121Forms[y].T2121.OtherPartners[y1].Address=T2121#y-Partn1Adress1^^T2121#y^y1:506,510,514,518,522
T2121Forms[y].T2121.OtherPartners[y1].City=T2121#y-Partn1Adress1^&^T2121#y^y1:506,510,514,518,522
T2121Forms[y].T2121.OtherPartners[y1].Province=T2121#y-Partn1Adress1^&^T2121#y^y1:506,510,514,518,522
T2121Forms[y].T2121.OtherPartners[y1].PostalCode=T2121#y-Partn1Adress1^&^T2121#y^y1:506,510,514,518,522
// // T2121 Fishing END -------------------------------------------------

// //T2042 Farming-------------------------------------------------
T2042Forms[y].T2042.FarmIdentification.FiscalPeriodStart=T2042#y-Fiscal1^INCYEAR^T2042 #y^4
T2042Forms[y].T2042.FarmIdentification.FiscalPeriodEnd=T2042#y-Fiscal2^INCYEAR^T2042 #y^5
T2042Forms[y].T2042.FarmIdentification.IndustryCode=T2042#y-Industry Code^NAICS^T2042 #y^17
T2042Forms[y].T2042.FarmIdentification.FarmName=T2042#y-Farm Name^^T2042 #y^8
T2042Forms[y].T2042.FarmIdentification.Address=T2042#y-Farm Address1^^T2042 #y^10
T2042Forms[y].T2042.FarmIdentification.City=T2042#y-City^^T2042 #y^12
T2042Forms[y].T2042.FarmIdentification.Province=T2042#y-Prov^^T2042 #y^71
T2042Forms[y].T2042.FarmIdentification.PostalCode=T2042#y-Postal^^T2042 #y^13
///=T2042#y-Acres owned^^T2042 #y^9
///=T2042#y-Acres farmed^^T2042 #y^11
T2042Forms[y].T2042.FarmIdentification.MainProduct=T2042#y-Main Product^^T2042 #y^16
T2042Forms[y].T2042.FarmIdentification.PartnershipBusinessNumber=T2042#y-partnership id^^T2042 #y^18
T2042Forms[y].T2042.FarmIdentification.TaxShelterNumber=T2042#y-taxShelterNo^^T2042 #y^20
T2042Forms[y].T2042.FarmIdentification.AccountNumber=T2042#y-BusNum1^^T2042 #y^21
///=T2042#y-BusNum2^^T2042 #y^22
///=T2042#y-BusNum3^^T2042 #y^23
T2042Forms[y].T2042.PartnerDetails.Allocation=T2042#y-Percent^%^T2042 #y^24
T2042Forms[y].T2042.Income.GrossIncome=T2042#y-GrossInc^^T2042 #y^66

T2042Forms[y].T2042.BusinessUseOfHome.M[14]=T2042#y-CFHomeUseCF^^T2042#y^632

T2042Forms[y].T2042CEC.CEC.M[y]=T2042#y-CFCEC^^T2042#y^549

T2042Forms[y].T2042.OtherPartners[y1].Allocation=T2042#y-Sp percent^%^T2042#y^y1:642,646,650,654,658,662
T2042Forms[y].T2042.OtherPartners[y1].FirstName=T2042#y-Partn1FirstNm^^T2042#y^y1:640,644,648,652,656,660
T2042Forms[y].T2042.OtherPartners[y1].LastName=T2042#y-Partn1LastNm^^T2042#y^y1:664,666,668,670,672,674
///=T2042#y-Partn1Sin^^T2042#y^667
T2042Forms[y].T2042.OtherPartners[y1].Address=T2042#y-Partn1Adress1^&^T2042#y^y1:643,647,651,655,659,663
T2042Forms[y].T2042.OtherPartners[y1].City=T2042#y-Partn1Adress1^&^T2042#y^y1:643,647,651,655,659,663
T2042Forms[y].T2042.OtherPartners[y1].Province=T2042#y-Partn1Adress1^&^T2042#y^y1:643,647,651,655,659,663
T2042Forms[y].T2042.OtherPartners[y1].PostalCode=T2042#y-Partn1Adress1^&^T2042#y^y1:643,647,651,655,659,663

//T2042 Farming END-------------------------------------------------

//T2125 cca-------------------------------------------------
T2125Forms[y].T2125CCA.CCATable[y1].ClassNumber=T2125#y-class1^TEST^T2125#y^y1:301,311,321,331,341,351,361,371
T2125Forms[y].T2125CCA.CCATable[y1].UCCStartOfYear=T2125#y-UCC1^^T2125#y^y1:302,312,322,332,342,352,362,372
//T2125 cca END-------------------------------------------------

//T2121 CCA-------------------------------------------------
T2121Forms[y].T2121CCA.CCATable[y1].ClassNumber=T2121#y-class1^^T2121#y^y1:137,147,157,167,177,187,197,207
T2121Forms[y].T2121CCA.CCATable[y1].UCCStartOfYear=T2121#y-UCC1^^T2121#y^y1:138,148,158,168,178,188,198,208
//T2121 CCA END-------------------------------------------------

//T2042 CCA-------------------------------------------------
T2042Forms[y].T2042CCA.CCATable[y1].ClassNumber=T2042#y-class1^^T2042#y^y1:401,411,421,431,441,451,461,471
T2042Forms[y].T2042CCA.CCATable[y1].UCCStartOfYear=T2042#y-UCC1^^T2042#y^y1:402,412,422,432,442,452,462,472
//T2042 CCA END-------------------------------------------------

//T776 CCA-------------------------------------------------
T776Forms[y].T776CCA.CCATable[y1].ClassNumber=T776_2#y-Class^^T776#y^201,210,219,228,237
T776Forms[y].T776CCA.CCATable[y1].UCCStartOfYear=T776_2#y-Class^^T776#y^202,211,220,229,238
//T776 CCA END-------------------------------------------------

//transform sector
[Transform:ProvinceFullToShort]
Alberta=AB
British Columbia=BC
Manitoba=MB
New Brunswick=NB
Newfoundland and Labrador=NL
Northwest Territories=NT
Nova Scotia=NS
Nunavut=NU
Ontario=ON
Prince Edward Island=PE
Quebec=QC
Saskatchewan=SK
Yukon=YT
Group #1.test.row #4.Value#
[Transform:ProvinceIDtoFull]
1=Alberta
2=British Columbia
3=Manitoba
4=New Brunswick
5=Newfoundland and Labrador
6=Northwest Territories
7=Nova Scotia
8=Nunavut
9=Ontario
10=Prince Edward Island
11=Quebec
12=Saskatchewan
13=Yukon

[Transform:CheckBox]
1=X

[Transform:ResidencyStatus]
1=X
2=X
3=X
4=X
5=X

[Transform:RELATIONSHIP]
1=Child
2=Son
3=Daughter
4=Parent
5=Father
6=Mother
7=Grandchild
8=Brother
9=Sister
10=Son-in-law
11=Daughter-in-law
12=Uncle
13=Aunt
14=Nephew
15=Niece
16=Grandparent
17=Great Grandparent

[Transform:CapLoss]
2001=490
2002=495
2003=500
2004=505
2005=510
2006=515
2007=520
2008=525
2009=530
2010=535
2011=540
2012=545
2013=550
2014=555
2015=560