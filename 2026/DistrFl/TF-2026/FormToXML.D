// Structure
// 0 - Form Name(format: Form or ParentForm:Form)
// 1 - Data type
// 2 - Edit boxes number
// 3 - Max Size
// 4 - Tag
// 5 - Field box number
// 6 - tags for FieldCode & others

// Data types
// S - string
// B - boolean
// AV - array editbox with values
// N - Number

T5013FIN	S	1	15	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:PartnershipAccountNumber>
T5013FIN	S	7	175	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:PartnershipSegment1Name>
T5013FIN	S	8	175	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:PartnershipSegment2Name>
T5013FIN	S	9	175	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:PartnershipOperatingSegment1Name>
T5013FIN	S	10	175	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:PartnershipOperatingSegment2Name>
T5013FIN	B	11,12	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:PhysicalAddressChangeIndicator>
T5013FIN	S	13	30	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:PhysicalAddress><ols:AddressLine1Text>
T5013FIN	S	14	30	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:PhysicalAddress><ols:AddressLine2Text>
T5013FIN	S	15	30	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:PhysicalAddress><ols:MunicipalityName>
T5013FIN	S	16	2	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:PhysicalAddress><ols:ProvinceTerritoryStateCode>
T5013FIN	S	17	3	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:PhysicalAddress><ols:CountryCode>
T5013FIN	S	18	10	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:PhysicalAddress><ols:PostalZipCode>
T5013FIN	B	36,37	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:AmendedReturnIndicator>
T5013FIN	S	38	10	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:FiscalPeriodStartDate>
T5013FIN	S	39	10	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:FiscalPeriodEndDate>
T5013FIN	B	40,41	2	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:EndMembersIndicator>
T5013FIN	B	42,43	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:FirstYearFilingIndicator>
T5013FIN	S	44	10	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:PartnershipCreateDate>
T5013FIN	S	45	7	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:T5013SlipsCount>
T5013FIN	B	47,48	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:FinalReturnIndicator>
T5013FIN	S	49	15	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:FunctionalCurrencyName>
T5013FIN	B	46,157	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:PartnershipResidencyIndicator>
T5013FIN	AV	53,54,55,56,57,58,59,61:01,02,03,08,11,12,13,19	2	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:TypeOfPartnershipCode>
T5013FIN	S	155,156	60	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:OtherPartnershipTypeName>
T5013FIN	N	62	6	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:TaxShelterIdentificationNumber>
T5013FIN	B	65,66	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:MemberOfAnotherPartnershipAttachmentIndicator>
T5013FIN	B	67,68	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:MemberTransactionsAttachmentIndicator>
T5013FIN	B	67,70	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:NonResidentNonArmsLengthTransactionsTotalOverThresholdIndicator>
T5013FIN	B	158,159	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:PartnershipForeignAffiliatesIndicator>
T5013FIN	B	71,72	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:DonationsAttachmentIndicator>
T5013FIN	B	73,74	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:MultipleJurisdictionAttachmentIndicator>
T5013FIN	B	75,76	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:CapitalGainsAttachmentIndicator>
T5013FIN	B	77,78	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:CapitalCostsAttachmentIndicator>
T5013FIN	B	81,82	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:ResourceDeductionsAttachmentIndicator>
T5013FIN	B	83,84	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:ITCCalculationAttachmentIndicator>
T5013FIN	B	85,86	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:ScientificResearchAttachmentIndicator>
T5013FIN	B	87,88	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:AllocateRenouncedAttachmentIndicator>
T5013FIN	B	89,90	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:ForeignPropertyAttachmentIndicator>
T5013FIN	B	3,4	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:JournalismTaxCreditsAttachmentIndicator>
T5013FIN	B	5,6	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:FarmersCreditIndicator>
T5013FIN	B	50,51	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:AirQualityCreditIndicator>
T5013FIN	B	93,94	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:InternationalFinancialReportingStandardsIndicator>
T5013FIN	B	95,96	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:MultipleNomineeIndicator>
T5013FIN	B	97,98	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:NomineeRequirementToFileIndicator>
T5013FIN	B	99,100	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:NewNomineeIndicator>
T5013FIN	B	101,102	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:AllocateTaxDeductionAtSourceIndicator>
T5013FIN	B	103,104	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:ElectionsMadeIndicator>
T5013FIN	B	105,106	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:PredecessorIndicator>
T5013FIN	N	107	9	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:PredecessorPartnershipBusinessNumber>
T5013FIN	B	109,110	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:InactiveIndicator>
T5013FIN	B	111,112	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:ImmigrateToCanadaIndicator>
T5013FIN	B	113,114	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:EmmigrateFromCanadaIndicator>
T5013FIN	B	115,116	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:HadSubcontractorsIndicator>
T5013FIN	B	117,118	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:FarmFishCashReportingIndicator>
T5013FIN	B	119,120	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:PubliclyTradedIndicator>
T5013FIN	B	121,122	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:T5008IssuedIndicator>
T5013FIN	B	123,124	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:NR4ReturnFiledIndicator>
T5013FIN	S	125	7	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:NonResidentAccountNumber>
T5013FIN	B	126,127	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:NR4SlipIssuedIndicator>
T5013FIN	B	128,129	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:SpecificInvestmentFlowThroughPartnershipIndicator>
T5013FIN	N	130	15	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:NonPortfolioEarningsAmount>
T5013FIN	N	131	15	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:PartIXTaxPayableAmount>
T5013FIN	N	132	15	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:Schedule52LateFilingPenaltyAmount>
T5013FIN	N	133	15	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:T5013RemittedAmount>
T5013FIN	S	136,137	175	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:DesignatedPartner><ols:DesignatedPartnerEntityFullName>
T5013FIN	S	138	15	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:DesignatedPartner><ols:DesignatedPartnerEntityIdentificationNumber>
T5013FIN	S	139	30	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:PrincipalPromoter><ols:PrincipalPromoterFamilyName>
T5013FIN	S	140	30	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:PrincipalPromoter><ols:PrincipalPromoterGivenName>
T5013FIN	S	141	15	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:PrincipalPromoter><ols:PrincipalPromoterIdentificationNumber>
T5013FIN	S	142	30	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:CertificationDetails><ols:CertificationFamilyName>
T5013FIN	S	143	30	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:CertificationDetails><ols:CertificationGivenName>
T5013FIN	S	144	30	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:CertificationDetails><ols:CertificationPositionTitleName>
T5013FIN	S	145	10	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:CertificationDetails><ols:CertificationDate>
T5013FIN	S	146,147	30	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:CertificationDetails><ols:CertifierTelephoneNumber>
T5013FIN	AV	153,154:1,2	1	<olsbr:OLSBRT5013Data><ols:PartnershipFinancialReturnData><ols:CorrespondenceLanguageIndicator>

// PS1 P:FieldCodeAmountRule - ParameterName in the code
T5013FIN:PS1	B	27,28	1	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:NilIndicator>
T5013FIN:PS1	N	5	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	500
T5013FIN:PS1	N	151	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	101
T5013FIN:PS1	N	6	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	104
T5013FIN:PS1	N	7	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	105
T5013FIN:PS1	N	8	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	106
T5013FIN:PS1	N	11	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	109
T5013FIN:PS1	N	152	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	110
T5013FIN:PS1	N	12	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	111
T5013FIN:PS1	N	13	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	112
T5013FIN:PS1	N	14	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	114
T5013FIN:PS1	N	15	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	115
T5013FIN:PS1	N	16	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	116
T5013FIN:PS1	N	17	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	117
T5013FIN:PS1	N	18	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	118
T5013FIN:PS1	N	19	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	119
T5013FIN:PS1	N	20	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	120
T5013FIN:PS1	N	21	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	121
T5013FIN:PS1	N	22	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	122
T5013FIN:PS1	N	23	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	123
T5013FIN:PS1	N	26	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	124
T5013FIN:PS1	N	25	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	126
T5013FIN:PS1	N	24	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	127
T5013FIN:PS1	N	46	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	150
T5013FIN:PS1	N	48	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	152
T5013FIN:PS1	N	50	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	154
T5013FIN:PS1	N	51	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	155
T5013FIN:PS1	N	52	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	156
T5013FIN:PS1	N	32	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	199
T5013FIN:PS1	N	39	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	501
T5013FIN:PS1	N	40	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	502
T5013FIN:PS1	N	41	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	503
T5013FIN:PS1	N	155	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	504
T5013FIN:PS1	N	45	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	505
T5013FIN:PS1	N	56	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	201
T5013FIN:PS1	N	57	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	202
T5013FIN:PS1	N	58	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	203
T5013FIN:PS1	N	59	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	204
T5013FIN:PS1	N	60	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	205
T5013FIN:PS1	N	61	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	206
T5013FIN:PS1	N	63	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	208
T5013FIN:PS1	N	64	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	209
T5013FIN:PS1	N	65	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	210
T5013FIN:PS1	N	66	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	211
T5013FIN:PS1	N	67	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	212
T5013FIN:PS1	N	68	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	213
T5013FIN:PS1	N	69	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	214
T5013FIN:PS1	N	70	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	215
T5013FIN:PS1	N	71	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	216
T5013FIN:PS1	N	72	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	217
T5013FIN:PS1	N	73	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	218
T5013FIN:PS1	N	74	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	219
T5013FIN:PS1	N	75	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	220
T5013FIN:PS1	N	76	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	221
T5013FIN:PS1	N	77	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	222
T5013FIN:PS1	N	78	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	223
T5013FIN:PS1	N	79	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	224
T5013FIN:PS1	N	81	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	226
T5013FIN:PS1	N	82	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	227
T5013FIN:PS1	N	83	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	228
T5013FIN:PS1	N	84	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	229
T5013FIN:PS1	N	85	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	230
T5013FIN:PS1	N	86	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	231
T5013FIN:PS1	N	87	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	232
T5013FIN:PS1	N	88	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	234
T5013FIN:PS1	N	89	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	236
T5013FIN:PS1	N	90	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	237
T5013FIN:PS1	N	91	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	238
T5013FIN:PS1	N	153	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	239
T5013FIN:PS1	N	103	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	506
T5013FIN:PS1	N	105	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	300
T5013FIN:PS1	N	106	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	301
T5013FIN:PS1	N	107	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	302
T5013FIN:PS1	N	108	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	303
T5013FIN:PS1	N	109	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	304
T5013FIN:PS1	N	110	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	305
T5013FIN:PS1	N	111	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	306
T5013FIN:PS1	N	112	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	307
T5013FIN:PS1	N	113	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	308
T5013FIN:PS1	N	114	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	309
T5013FIN:PS1	N	115	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	310
T5013FIN:PS1	N	116	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	311
T5013FIN:PS1	N	117	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	312
T5013FIN:PS1	N	118	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	313
T5013FIN:PS1	N	119	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	314
T5013FIN:PS1	N	120	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	315
T5013FIN:PS1	N	121	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	316
T5013FIN:PS1	N	154	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	347
T5013FIN:PS1	N	134	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	401
T5013FIN:PS1	N	135	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	402
T5013FIN:PS1	N	136	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	403
T5013FIN:PS1	N	137	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	404
T5013FIN:PS1	N	139	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	407
T5013FIN:PS1	N	140	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	408
T5013FIN:PS1	N	141	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	409
T5013FIN:PS1	N	142	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	410
T5013FIN:PS1	N	143	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	411
T5013FIN:PS1	N	144	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	414
T5013FIN:PS1	N	145	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	416
T5013FIN:PS1	N	146	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	417
T5013FIN:PS1	N	148	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	510
T5013FIN:PS1	N	149	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:Schedule1LineAmounts>	P:FieldCodeAmountRule	511
T5013FIN:PS1	S	92	60	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:OtherSchedule1LineAmount><ols1:OtherSchedule1CodeAndText>	P:FieldCodeCharacter60TextRule	600
T5013FIN:PS1	S	94	60	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:OtherSchedule1LineAmount><ols1:OtherSchedule1CodeAndText>	P:FieldCodeCharacter60TextRule	601
T5013FIN:PS1	S	96	60	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:OtherSchedule1LineAmount><ols1:OtherSchedule1CodeAndText>	P:FieldCodeCharacter60TextRule	602
T5013FIN:PS1	S	98	60	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:OtherSchedule1LineAmount><ols1:OtherSchedule1CodeAndText>	P:FieldCodeCharacter60TextRule	603
T5013FIN:PS1	S	100	60	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:OtherSchedule1LineAmount><ols1:OtherSchedule1CodeAndText>	P:FieldCodeCharacter60TextRule	604
T5013FIN:PS1	S	122	60	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:OtherSchedule1LineAmount><ols1:OtherSchedule1CodeAndText>	P:FieldCodeCharacter60TextRule	700
T5013FIN:PS1	S	124	60	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:OtherSchedule1LineAmount><ols1:OtherSchedule1CodeAndText>	P:FieldCodeCharacter60TextRule	701
T5013FIN:PS1	S	126	60	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:OtherSchedule1LineAmount><ols1:OtherSchedule1CodeAndText>	P:FieldCodeCharacter60TextRule	702
T5013FIN:PS1	S	128	60	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:OtherSchedule1LineAmount><ols1:OtherSchedule1CodeAndText>	P:FieldCodeCharacter60TextRule	703
T5013FIN:PS1	S	130	60	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:OtherSchedule1LineAmount><ols1:OtherSchedule1CodeAndText>	P:FieldCodeCharacter60TextRule	704
T5013FIN:PS1	N	93	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:OtherSchedule1LineAmount><ols1:OtherSchedule1CodeAndAmount>	P:FieldCodeAmountRule	290
T5013FIN:PS1	N	95	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:OtherSchedule1LineAmount><ols1:OtherSchedule1CodeAndAmount>	P:FieldCodeAmountRule	291
T5013FIN:PS1	N	97	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:OtherSchedule1LineAmount><ols1:OtherSchedule1CodeAndAmount>	P:FieldCodeAmountRule	292
T5013FIN:PS1	N	99	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:OtherSchedule1LineAmount><ols1:OtherSchedule1CodeAndAmount>	P:FieldCodeAmountRule	293
T5013FIN:PS1	N	101	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:OtherSchedule1LineAmount><ols1:OtherSchedule1CodeAndAmount>	P:FieldCodeAmountRule	294
T5013FIN:PS1	N	123	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:OtherSchedule1LineAmount><ols1:OtherSchedule1CodeAndAmount>	P:FieldCodeAmountRule	390
T5013FIN:PS1	N	125	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:OtherSchedule1LineAmount><ols1:OtherSchedule1CodeAndAmount>	P:FieldCodeAmountRule	391
T5013FIN:PS1	N	127	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:OtherSchedule1LineAmount><ols1:OtherSchedule1CodeAndAmount>	P:FieldCodeAmountRule	392
T5013FIN:PS1	N	129	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:OtherSchedule1LineAmount><ols1:OtherSchedule1CodeAndAmount>	P:FieldCodeAmountRule	393
T5013FIN:PS1	N	131	15	<olsbr:OLSBRT5013Data><ols1:T5013Schedule1Data><ols1:OtherSchedule1LineAmount><ols1:OtherSchedule1CodeAndAmount>	P:FieldCodeAmountRule	394
// PS2
T5013FIN:PS2	TS	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2GiftsAndDonationsDetails>
T5013FIN:PS2	SV	60	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2GiftsAndDonationsDetails><ols2:CharitableGiftTypeName>
T5013FIN:PS2	S	60	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2GiftsAndDonationsDetails><ols2:RecipientName>
T5013FIN:PS2	S	10	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2GiftsAndDonationsDetails><ols2:GiftOrContributionDate>
T5013FIN:PS2	S	175	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2GiftsAndDonationsDetails><ols2:PropertyDescriptionText>
T5013FIN:PS2	S	175	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2GiftsAndDonationsDetails><ols2:DonorName>
T5013FIN:PS2	N	15	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2GiftsAndDonationsDetails><ols2:GiftValueAmount>
T5013FIN:PS2	N	15	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2GiftsAndDonationsDetails><ols2:EligibleAmount>
T5013FIN:PS2	TE	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2GiftsAndDonationsDetails>
T5013FIN:PS2	T	"Charitable donations",7,8,9,10,6,5	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2GiftsAndDonationsDetails>
T5013FIN:PS2	T	"Charitable donations",13,14,14,16,12,11	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2GiftsAndDonationsDetails>
T5013FIN:PS2	T	"Charitable donations",19,20,21,22,18,17	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2GiftsAndDonationsDetails>
T5013FIN:PS2	T	"Charitable donations",25,26,27,28,24,23	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2GiftsAndDonationsDetails>
T5013FIN:PS2	T	"Gifts of certified cultural property",57,58,59,60,56,55	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2GiftsAndDonationsDetails>
T5013FIN:PS2	T	"Gifts of certified cultural property",63,64,65,66,62,61	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2GiftsAndDonationsDetails>
T5013FIN:PS2	T	"Gifts of certified cultural property",69,70,71,72,68,67	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2GiftsAndDonationsDetails>
T5013FIN:PS2	T	"Gifts of certified ecologically sensitive land",76,77,78,79,75,74	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2GiftsAndDonationsDetails>
T5013FIN:PS2	T	"Gifts of certified ecologically sensitive land",82,83,84,85,81,80	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2GiftsAndDonationsDetails>
T5013FIN:PS2	T	"Gifts of certified ecologically sensitive land",88,89,90,91,87,86	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2GiftsAndDonationsDetails>
T5013FIN:PS2	TS	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2PoliticalContributionDetails>
T5013FIN:PS2	SV	60	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2PoliticalContributionDetails><ols2:PoliticalDonationTypeName>
T5013FIN:PS2	S	175	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2PoliticalContributionDetails><ols2:RegisteredPartyName>
T5013FIN:PS2	S	175	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2PoliticalContributionDetails><ols2:ConstituencyAssociationName>
T5013FIN:PS2	S	175	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2PoliticalContributionDetails><ols2:CandidateName>
T5013FIN:PS2	S	10	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2PoliticalContributionDetails><ols2:GiftOrContributionDate>
T5013FIN:PS2	N	175	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2PoliticalContributionDetails><ols2:DonorName>
T5013FIN:PS2	N	15	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2PoliticalContributionDetails><ols2:EligibleAmount>
T5013FIN:PS2	TE	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2PoliticalContributionDetails>
T5013FIN:PS2	T	"Federal political contributions",94,95,96,97,98,93	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2PoliticalContributionDetails>
T5013FIN:PS2	T	"Federal political contributions",100,101,102,103,104,99	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2PoliticalContributionDetails>
T5013FIN:PS2	T	"Federal political contributions",106,107,108,109,110,105	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2PoliticalContributionDetails>
T5013FIN:PS2	T	"Provincial or territorial political contributions",113,114,115,116,117,112	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2PoliticalContributionDetails>
T5013FIN:PS2	T	"Provincial or territorial political contributions",119,120,121,122,123,118	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2PoliticalContributionDetails>
T5013FIN:PS2	T	"Provincial or territorial political contributions",125,126,127,128,129,124	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2PoliticalContributionDetails>
T5013FIN:PS2	T	"Municipal political contributions",154,155,156,157,158,153	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2PoliticalContributionDetails>
T5013FIN:PS2	T	"Municipal political contributions",160,161,162,163,164,159	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2PoliticalContributionDetails>
T5013FIN:PS2	T	"Municipal political contributions",166,167,168,169,170,165	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data><ols2:Schedule2PoliticalContributionDetails>
T5013FIN:PS2	N	171	15	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data>MunicipalContributionTotalEligibleAmount>
T5013FIN:PS2	N	130	15	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data>ProvincialTerritryContributionTotalEligibleAmount>
T5013FIN:PS2	N	111	15	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data>FederalContributionTotalEligibleAmount>
T5013FIN:PS2	N	92	15	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data>EcologicalGiftsTotalEligibleAmount>
T5013FIN:PS2	N	73	15	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data>CulturalProperytGiftsTotalEligibleAmount>
T5013FIN:PS2	N	29	15	<olsbr:OLSBRT5013Data><ols2:T5013Schedule2Data>CharitableDonationsTotalEligibleAmount>
// PS5
T5013FIN:PS5	TS	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5RegionalJurisdictionAllocationDetails>
T5013FIN:PS5	SV	3	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5RegionalJurisdictionAllocationDetails><ols5:Schedule5RegionAllocationCode>
T5013FIN:PS5	B2	1	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5RegionalJurisdictionAllocationDetails><ols5:Schedule5AllocationIndicator>
T5013FIN:PS5	SV	3	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5RegionalJurisdictionAllocationDetails><ols5:Schedule5SalariesAndWagesCode>
T5013FIN:PS5	N	15	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5RegionalJurisdictionAllocationDetails><ols5:Schedule5SalariesAndWagesAmount>
T5013FIN:PS5	SV	3	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5RegionalJurisdictionAllocationDetails><ols5:Schedule5GrossRevenueCode>
T5013FIN:PS5	N	15	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5RegionalJurisdictionAllocationDetails><ols5:Schedule5GrossRevenueAmount>
T5013FIN:PS5	TE	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5RegionalJurisdictionAllocationDetails>
T5013FIN:PS5	T	"003",6|7,"100",8,"200",9	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5RegionalJurisdictionAllocationDetails>
T5013FIN:PS5	T	"004",10|11,"101",12,"201",13	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5RegionalJurisdictionAllocationDetails>
T5013FIN:PS5	T	"005",14|15,"102",16,"202",17	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5RegionalJurisdictionAllocationDetails>
T5013FIN:PS5	T	"007",18|19,"103",20,"203",21	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5RegionalJurisdictionAllocationDetails>
T5013FIN:PS5	T	"008",22|23,"104",24,"204",25	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5RegionalJurisdictionAllocationDetails>
T5013FIN:PS5	T	"009",26|27,"105",28,"205",29	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5RegionalJurisdictionAllocationDetails>
T5013FIN:PS5	T	"011",30|31,"106",32,"206",33	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5RegionalJurisdictionAllocationDetails>
T5013FIN:PS5	T	"013",34|35,"107",36,"207",37	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5RegionalJurisdictionAllocationDetails>
T5013FIN:PS5	T	"015",38|39,"108",40,"208",41	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5RegionalJurisdictionAllocationDetails>
T5013FIN:PS5	T	"017",42|43,"109",44,"209",45	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5RegionalJurisdictionAllocationDetails>
T5013FIN:PS5	T	"019",46|47,"110",48,"210",49	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5RegionalJurisdictionAllocationDetails>
T5013FIN:PS5	T	"021",50|51,"111",52,"211",53	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5RegionalJurisdictionAllocationDetails>
T5013FIN:PS5	T	"023",54|55,"112",56,"212",57	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5RegionalJurisdictionAllocationDetails>
T5013FIN:PS5	T	"025",58|59,"113",60,"213",61	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5RegionalJurisdictionAllocationDetails>
T5013FIN:PS5	T	"026",62|63,"114",64,"214",65	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5RegionalJurisdictionAllocationDetails>
T5013FIN:PS5	T	"027",66|67,"115",68,"215",69	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5RegionalJurisdictionAllocationDetails>
T5013FIN:PS5	N	70	15	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5SalariesAndWagesAllocationTotalAmount>
T5013FIN:PS5	N	71	15	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5JurisdictionSalariesWagesGrossRevenueDetails><ols5:Schedule5GrossRevenueAllocationTotalAmount>
T5013FIN:PS5	TS	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5AllocationByOtherPartnershipDetails>
T5013FIN:PS5	S	60	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5AllocationByOtherPartnershipDetails><ols5:Schedule5OtherPartnershipName>
T5013FIN:PS5	S	15	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5AllocationByOtherPartnershipDetails><ols5:Schedule5OtherPartnershipAccountNumber>
T5013FIN:PS5	B2	1	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5AllocationByOtherPartnershipDetails><ols5:Schedule5AllocationFromOtherPartnershipIndicator>
T5013FIN:PS5	TE	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5AllocationByOtherPartnershipDetails>
T5013FIN:PS5	T	72,73,74|75	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5AllocationByOtherPartnershipDetails>
T5013FIN:PS5	T	76,77,78|79	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5AllocationByOtherPartnershipDetails>
T5013FIN:PS5	T	80,81,82|83	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5AllocationByOtherPartnershipDetails>
T5013FIN:PS5	T	84,85,86|87	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5AllocationByOtherPartnershipDetails>
T5013FIN:PS5	T	88,89,90|91	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5AllocationByOtherPartnershipDetails>
T5013FIN:PS5	T	92,93,94|95	<olsbr:OLSBRT5013Data><ols5:T5013Schedule5Data><ols5:Schedule5AllocationByOtherPartnershipDetails>
// PS6
// PS6 Part 1
T5013FIN:PS6	TS	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QSBCSharesDetails>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QSBCSharesDetails><ols6:QSBCShareCount>
T5013FIN:PS6	S	60	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QSBCSharesDetails><ols6:QSBCShareClassName>
T5013FIN:PS6	S	175	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QSBCSharesDetails><ols6:QSBCName>
T5013FIN:PS6	S	10	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QSBCSharesDetails><ols6:QSBCShareAcquisitionDate>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QSBCSharesDetails><ols6:QSBCShareProceedsOfDispositionAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QSBCSharesDetails><ols6:QSBCShareAdjustedCostBaseAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QSBCSharesDetails><ols6:QSBCShareOutlaysAndExpensesAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QSBCSharesDetails><ols6:QSBCShareGainLossAmount>
T5013FIN:PS6	TE	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QSBCSharesDetails>
T5013FIN:PS6	T	1,2,3,4,5,6,7,8	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QSBCSharesDetails>
T5013FIN:PS6	T	9,10,11,12,13,14,15,16	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QSBCSharesDetails>
T5013FIN:PS6	T	17,18,19,20,21,22,23,24	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QSBCSharesDetails>
T5013FIN:PS6	T	25,26,27,28,29,30,31,32	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QSBCSharesDetails>
T5013FIN:PS6	T	33,34,35,36,37,38,39,40	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QSBCSharesDetails>
T5013FIN:PS6	N	44	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QSBCSharesTotalAmount>
T5013FIN:PS6	N	423	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part1Portion1Amount>
T5013FIN:PS6	N	424	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part1Portion2Amount>
// PS6 Part 2
T5013FIN:PS6	TS	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPDetails>
T5013FIN:PS6	S	175	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPDetails><ols6:QFFPAddressOrLegalDescriptionText>
T5013FIN:PS6	S	10	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPDetails><ols6:QFFPAcquisitionDate>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPDetails><ols6:QFFPProceedsOfDispositionAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPDetails><ols6:QFFPAdjustedCostBaseAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPDetails><ols6:QFFPOutlaysAndExpensesAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPDetails><ols6:QFFPGainLossAmount>
T5013FIN:PS6	TE	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPDetails>
T5013FIN:PS6	T	45,46,47,48,49,50	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPDetails>
T5013FIN:PS6	T	51,52,53,54,55,56	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPDetails>
T5013FIN:PS6	T	57,58,59,60,61,62	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPDetails>
T5013FIN:PS6	T	63,64,65,66,67,68	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPDetails>
T5013FIN:PS6	T	69,70,71,72,73,74	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPDetails>
T5013FIN:PS6	N	78	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPTotalAmount>
T5013FIN:PS6	N	425	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part2Portion1Amount>
T5013FIN:PS6	N	426	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part2Portion2Amount>
// PS6 Part 3
T5013FIN:PS6	TS	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPForeclosuresAndRepossessionsDetails>
T5013FIN:PS6	S	175	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPForeclosuresAndRepossessionsDetails><ols6:QFFPForeclosuresAndRepossessionsDescription>
T5013FIN:PS6	S	175	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPForeclosuresAndRepossessionsDetails><ols6:QFFPForeclosuresAndRepossessionsAddressOrLegalDescriptionText>
T5013FIN:PS6	S	10	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPForeclosuresAndRepossessionsDetails><ols6:QFFPForeclosuresAndRepossessionsAcquisitionDate>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPForeclosuresAndRepossessionsDetails><ols6:QFFPForeclosuresAndRepossessionsProceedsOfDispositionAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPForeclosuresAndRepossessionsDetails><ols6:QFFPForeclosuresAndRepossessionsAdjustedCostBaseAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPForeclosuresAndRepossessionsDetails><ols6:QFFPForeclosuresAndRepossessionsOutlaysAndExpensesAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPForeclosuresAndRepossessionsDetails><ols6:QFFPForeclosuresAndRepossessionsGainLossAmount>
T5013FIN:PS6	TE	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPForeclosuresAndRepossessionsDetails>
T5013FIN:PS6	T	79,80,81,82,83,84,85	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPForeclosuresAndRepossessionsDetails>
T5013FIN:PS6	T	86,87,88,89,90,91,92	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPForeclosuresAndRepossessionsDetails>
T5013FIN:PS6	T	93,94,95,96,97,98,99	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPForeclosuresAndRepossessionsDetails>
T5013FIN:PS6	T	100,101,102,103,104,105,106	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPForeclosuresAndRepossessionsDetails>
T5013FIN:PS6	T	107,108,109,110,111,112,113	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPForeclosuresAndRepossessionsDetails>
T5013FIN:PS6	N	117	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPForeclosuresAndRepossessionsTotalAmount>
T5013FIN:PS6	N	425	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part3Portion1Amount>
T5013FIN:PS6	N	433	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part3Portion2Amount>
// PS6 Part 4
T5013FIN:PS6	TS	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6MutualFundUnitsAndSharesDetails>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6MutualFundUnitsAndSharesDetails><ols6:MutualFundUnitsAndSharesCount>
T5013FIN:PS6	S	60	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6MutualFundUnitsAndSharesDetails><ols6:MutualFundUnitsAndSharesClassDescription>
T5013FIN:PS6	S	175	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6MutualFundUnitsAndSharesDetails><ols6:MutualFundUnitsAndSharesName>
T5013FIN:PS6	S	10	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6MutualFundUnitsAndSharesDetails><ols6:MutualFundUnitsAndSharesAcquisitionDate>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6MutualFundUnitsAndSharesDetails><ols6:MutualFundUnitsAndSharesProceedsOfDispositionAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6MutualFundUnitsAndSharesDetails><ols6:MutualFundUnitsAndSharesAdjustedCostBaseAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6MutualFundUnitsAndSharesDetails><ols6:MutualFundUnitsAndSharesOutlaysAndExpensesAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6MutualFundUnitsAndSharesDetails><ols6:MutualFundUnitsAndSharesGainLossAmount>
T5013FIN:PS6	TE	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6MutualFundUnitsAndSharesDetails>
T5013FIN:PS6	T	118,119,120,121,122,123,124,125	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6MutualFundUnitsAndSharesDetails>
T5013FIN:PS6	T	126,127,128,129,130,131,132,133	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6MutualFundUnitsAndSharesDetails>
T5013FIN:PS6	T	134,135,136,137,138,139,140,141	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6MutualFundUnitsAndSharesDetails>
T5013FIN:PS6	T	142,143,144,145,146,147,148,149	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6MutualFundUnitsAndSharesDetails>
T5013FIN:PS6	T	150,151,152,153,154,155,156,157	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6MutualFundUnitsAndSharesDetails>
T5013FIN:PS6	N	161	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6MutualFundUnitsAndSharesTotalAmount>
T5013FIN:PS6	N	434	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part4Portion1Amount>
T5013FIN:PS6	N	436	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part4Portion2Amount>
// PS6 Part 5
T5013FIN:PS6	TS	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6RealEstateDepreciablePropertyandOtherPropertiesDetails>
T5013FIN:PS6	S	175	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6RealEstateDepreciablePropertyandOtherPropertiesDetails><ols6:RealEstateDepreciablePropertyandOtherPropertiesAddressOrLegalDescriptionText>
T5013FIN:PS6	S	10	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6RealEstateDepreciablePropertyandOtherPropertiesDetails><ols6:RealEstateDepreciablePropertyandOtherPropertiesAcquisitionDate>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6RealEstateDepreciablePropertyandOtherPropertiesDetails><ols6:RealEstateDepreciablePropertyandOtherPropertiesProceedsOfDispositionAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6RealEstateDepreciablePropertyandOtherPropertiesDetails><ols6:RealEstateDepreciablePropertyandOtherPropertiesAdjustedCostBaseAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6RealEstateDepreciablePropertyandOtherPropertiesDetails><ols6:RealEstateDepreciablePropertyandOtherPropertiesOutlaysAndExpensesAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6RealEstateDepreciablePropertyandOtherPropertiesDetails><ols6:RealEstateDepreciablePropertyandOtherPropertiesGainLossAmount>
T5013FIN:PS6	TE	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6RealEstateDepreciablePropertyandOtherPropertiesDetails>
T5013FIN:PS6	T	162,163,164,165,166,167	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6RealEstateDepreciablePropertyandOtherPropertiesDetails>
T5013FIN:PS6	T	168,169,170,171,172,173	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6RealEstateDepreciablePropertyandOtherPropertiesDetails>
T5013FIN:PS6	T	174,175,176,177,178,179	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6RealEstateDepreciablePropertyandOtherPropertiesDetails>
T5013FIN:PS6	T	180,181,182,183,184,185	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6RealEstateDepreciablePropertyandOtherPropertiesDetails>
T5013FIN:PS6	T	186,187,188,189,190,191	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6RealEstateDepreciablePropertyandOtherPropertiesDetails>
T5013FIN:PS6	N	195	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6RealEstateDepreciablePropertyandOtherPropertiesTotalAmount>
T5013FIN:PS6	N	437	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part5Portion1Amount>
T5013FIN:PS6	N	438	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part5Portion2Amount>
// PS6 Part 6
T5013FIN:PS6	TS	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6BondsDebenturesAndSimilarPropertiesDetails>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6BondsDebenturesAndSimilarPropertiesDetails><ols6:BondsDebenturesAndSimilarPropertiesFaceValue>
T5013FIN:PS6	S	10	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6BondsDebenturesAndSimilarPropertiesDetails><ols6:BondsDebenturesAndSimilarPropertiesMaturityDate>
T5013FIN:PS6	S	175	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6BondsDebenturesAndSimilarPropertiesDetails><ols6:BondsDebenturesAndSimilarPropertiesIssuerName>
T5013FIN:PS6	S	10	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6BondsDebenturesAndSimilarPropertiesDetails><ols6:BondsDebenturesAndSimilarPropertiesIssuanceDate>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6BondsDebenturesAndSimilarPropertiesDetails><ols6:BondsDebenturesAndSimilarPropertiesProceedsOfDispositionAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6BondsDebenturesAndSimilarPropertiesDetails><ols6:BondsDebenturesAndSimilarPropertiesAdjustedCostBaseAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6BondsDebenturesAndSimilarPropertiesDetails><ols6:BondsDebenturesAndSimilarPropertiesOutlaysAndExpensesAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6BondsDebenturesAndSimilarPropertiesDetails><ols6:BondsDebenturesAndSimilarPropertiesGainLossAmount>
T5013FIN:PS6	TE	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6BondsDebenturesAndSimilarPropertiesDetails>
T5013FIN:PS6	T	196,197,198,199,200,201,202,203	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6BondsDebenturesAndSimilarPropertiesDetails>
T5013FIN:PS6	T	204,205,206,207,208,209,210,211	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6BondsDebenturesAndSimilarPropertiesDetails>
T5013FIN:PS6	T	212,213,214,215,216,217,218,219	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6BondsDebenturesAndSimilarPropertiesDetails>
T5013FIN:PS6	T	220,221,222,223,224,225,226,227	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6BondsDebenturesAndSimilarPropertiesDetails>
T5013FIN:PS6	T	228,229,230,231,232,233,234,235	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6BondsDebenturesAndSimilarPropertiesDetails>
T5013FIN:PS6	N	239	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6BondsDebenturesAndSimilarPropertiesTotalAmount>
T5013FIN:PS6	N	439	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part6Portion1Amount>
T5013FIN:PS6	N	440	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part6Portion2Amount>
// PS6 Part 7
T5013FIN:PS6	TS	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6PersonalUsePropertyDetails>
T5013FIN:PS6	S	175	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6PersonalUsePropertyDetails><ols6:PersonalUsePropertyDescription>
T5013FIN:PS6	S	10	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6PersonalUsePropertyDetails><ols6:PersonalUsePropertyAcquisitionDate>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6PersonalUsePropertyDetails><ols6:PersonalUsePropertyProceedsOfDispositionAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6PersonalUsePropertyDetails><ols6:PersonalUsePropertyAdjustedCostBaseAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6PersonalUsePropertyDetails><ols6:PersonalUsePropertyOutlaysAndExpensesAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6PersonalUsePropertyDetails><ols6:PersonalUsePropertyGainAmount>
T5013FIN:PS6	TE	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6PersonalUsePropertyDetails>
T5013FIN:PS6	T	240,241,242,243,244,245	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6PersonalUsePropertyDetails>
T5013FIN:PS6	T	246,247,248,249,250,251	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6PersonalUsePropertyDetails>
T5013FIN:PS6	T	252,253,254,255,256,257	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6PersonalUsePropertyDetails>
T5013FIN:PS6	T	258,259,260,261,262,263	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6PersonalUsePropertyDetails>
T5013FIN:PS6	T	264,265,266,267,268,269	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6PersonalUsePropertyDetails>
T5013FIN:PS6	N	273	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6PersonalUsePropertyTotalAmount>
T5013FIN:PS6	N	441	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part7Portion1Amount>
T5013FIN:PS6	N	442	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part7Portion2Amount>
// PS6 Part 8
T5013FIN:PS6	TS	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6ListedPersonalPropertyDetails>
T5013FIN:PS6	S	175	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6ListedPersonalPropertyDetails><ols6:ListedPersonalPropertyDescription>
T5013FIN:PS6	S	10	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6ListedPersonalPropertyDetails><ols6:ListedPersonalPropertyAcquisitionDate>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6ListedPersonalPropertyDetails><ols6:ListedPersonalPropertyProceedsOfDispositionAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6ListedPersonalPropertyDetails><ols6:ListedPersonalPropertyAdjustedCostBaseAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6ListedPersonalPropertyDetails><ols6:ListedPersonalPropertyOutlaysAndExpensesAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6ListedPersonalPropertyDetails><ols6:ListedPersonalPropertyGainAmount>
T5013FIN:PS6	TE	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6ListedPersonalPropertyDetails>
T5013FIN:PS6	T	274,275,276,277,278,279	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6ListedPersonalPropertyDetails>
T5013FIN:PS6	T	280,281,282,283,284,285	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6ListedPersonalPropertyDetails>
T5013FIN:PS6	T	286,287,288,289,290,291	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6ListedPersonalPropertyDetails>
T5013FIN:PS6	T	292,293,294,295,296,297	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6ListedPersonalPropertyDetails>
T5013FIN:PS6	T	298,299,300,301,302,303	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6ListedPersonalPropertyDetails>
T5013FIN:PS6	N	307	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6ListedPersonalPropertyTotalAmount>
T5013FIN:PS6	N	443	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part8Portion1Amount>
T5013FIN:PS6	N	444	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part8Portion2Amount>
// PS6 Part 9
T5013FIN:PS6	TS	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6OtherGainsLossesExceptGiftsOfCertainCapitalPropertyDetails>
T5013FIN:PS6	S	175	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6OtherGainsLossesExceptGiftsOfCertainCapitalPropertyDetails><ols6:OtherGainLossPropertyDescription>
T5013FIN:PS6	S	10	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6OtherGainsLossesExceptGiftsOfCertainCapitalPropertyDetails><ols6:OtherGainLossPropertyAcquisitionDate>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6OtherGainsLossesExceptGiftsOfCertainCapitalPropertyDetails><ols6:OtherGainLossPropertyProceedsOfDispositionAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6OtherGainsLossesExceptGiftsOfCertainCapitalPropertyDetails><ols6:OtherGainLossPropertyAdjustedCostBaseAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6OtherGainsLossesExceptGiftsOfCertainCapitalPropertyDetails><ols6:OtherGainLossPropertyOutlaysAndExpensesAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6OtherGainsLossesExceptGiftsOfCertainCapitalPropertyDetails><ols6:OtherGainLossPropertyGainAmount>
T5013FIN:PS6	TE	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6OtherGainsLossesExceptGiftsOfCertainCapitalPropertyDetails>
T5013FIN:PS6	T	308,309,310,311,312,313	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6OtherGainsLossesExceptGiftsOfCertainCapitalPropertyDetails>
T5013FIN:PS6	T	314,315,316,317,318,319	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6OtherGainsLossesExceptGiftsOfCertainCapitalPropertyDetails>
T5013FIN:PS6	T	320,321,322,323,324,325	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6OtherGainsLossesExceptGiftsOfCertainCapitalPropertyDetails>
T5013FIN:PS6	T	326,327,328,329,330,331	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6OtherGainsLossesExceptGiftsOfCertainCapitalPropertyDetails>
T5013FIN:PS6	T	332,333,334,335,336,337	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6OtherGainsLossesExceptGiftsOfCertainCapitalPropertyDetails>
T5013FIN:PS6	N	341	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6OtherGainsLossesExceptGiftsOfCertainCapitalPropertyTotalAmount>
T5013FIN:PS6	N	445	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part9Portion1Amount>
T5013FIN:PS6	N	446	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part9Portion2Amount>
// PS6 Part 10
T5013FIN:PS6	TS	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6GiftsOfCertainCapitalPropertyDetails>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6GiftsOfCertainCapitalPropertyDetails><ols6:GiftsOfCertainCapitalPropertyFaceValue>
T5013FIN:PS6	S	10	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6GiftsOfCertainCapitalPropertyDetails><ols6:GiftsOfCertainCapitalPropertyMaturityDate>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6GiftsOfCertainCapitalPropertyDetails><ols6:GiftsOfCertainCapitalPropertyCount>
T5013FIN:PS6	S	60	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6GiftsOfCertainCapitalPropertyDetails><ols6:GiftsOfCertainCapitalPropertyClassDescription>
T5013FIN:PS6	S	175	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6GiftsOfCertainCapitalPropertyDetails><ols6:GiftsOfCertainCapitalPropertyIssuerName>
T5013FIN:PS6	S	175	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6GiftsOfCertainCapitalPropertyDetails><ols6:GiftsOfCertainCapitalPropertyAddressOrLegalDescriptionText>
T5013FIN:PS6	S	10	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6GiftsOfCertainCapitalPropertyDetails><ols6:GiftsOfCertainCapitalPropertyAcquisitionDate>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6GiftsOfCertainCapitalPropertyDetails><ols6:GiftsOfCertainCapitalPropertyProceedsOfDispositionAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6GiftsOfCertainCapitalPropertyDetails><ols6:GiftsOfCertainCapitalPropertyAdjustedCostBaseAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6GiftsOfCertainCapitalPropertyDetails><ols6:GiftsOfCertainCapitalPropertyOutlaysAndExpensesAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6GiftsOfCertainCapitalPropertyDetails><ols6:GiftsOfCertainCapitalPropertyGainAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6GiftsOfCertainCapitalPropertyDetails><ols6:GiftsOfCertainCapitalPropertyEligibleAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6GiftsOfCertainCapitalPropertyDetails><ols6:GiftsOfCertainCapitalPropertyGainSubjectToZeroInclusionRateAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6GiftsOfCertainCapitalPropertyDetails><ols6:GiftsOfCertainCapitalPropertyGainSubjectTo50PercentInclusionRateAmount>
T5013FIN:PS6	TE	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6GiftsOfCertainCapitalPropertyDetails>
T5013FIN:PS6	T	342,343,344,345,346,347,372,373,374,375,376,377,378,379	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6GiftsOfCertainCapitalPropertyDetails>
T5013FIN:PS6	T	348,349,350,351,352,353,380,381,382,383,384,385,386,387	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6GiftsOfCertainCapitalPropertyDetails>
T5013FIN:PS6	T	354,355,356,357,358,359,388,389,390,391,392,393,394,395	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6GiftsOfCertainCapitalPropertyDetails>
T5013FIN:PS6	T	360,361,362,363,364,365,396,397,398,399,400,401,402,403	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6GiftsOfCertainCapitalPropertyDetails>
T5013FIN:PS6	T	366,367,368,369,370,371,404,405,406,407,408,409,410,411	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6GiftsOfCertainCapitalPropertyDetails>
T5013FIN:PS6	N	417	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6GiftsOfCertainCapitalPropertyZeroInclusionTotalAmount>
T5013FIN:PS6	N	418	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6GiftsOfCertainCapitalPropertyTotalAmount>
T5013FIN:PS6	N	447	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part10Portion1Amount>
T5013FIN:PS6	N	448	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part10Portion2Amount>
T5013FIN:PS6	N	449	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part10Portion3Amount>
T5013FIN:PS6	N	450	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part10Portion4Amount>
T5013FIN:PS6	N	451	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part10Portion5Amount>
// PS6 Part 11
T5013FIN:PS6	N	419	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6CapitalGainsLossesFromAllT5AndT4PSSlipsAmount>
T5013FIN:PS6	N	420	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6CapitalGainsLossesFromAllT3SlipsAmount>
T5013FIN:PS6	N	452	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part11Portion1Amount>
T5013FIN:PS6	N	453	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part11Portion2Amount>
T5013FIN:PS6	N	454	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part11Portion3Amount>
T5013FIN:PS6	N	455	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part11Portion4Amount>
// PS6 Part 12
// On CRA site and in our program we haven't line 880 for the next tag <ols6:Schedule6InterestInPartnershipAmount> (Note: use for form version T5013 SCH 6 E (22))
//T5013FIN:PS6	N	45n	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6InterestInPartnershipAmount>
T5013FIN:PS6	N	456	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part12Portion1Amount>
T5013FIN:PS6	N	457	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part12Portion2Amount>
T5013FIN:PS6	N	458	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part12Portion3Amount>
// PS6 Part 13
T5013FIN:PS6	TS	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QualifyingTransferToEmployeeOwnershipTrustDetails>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QualifyingTransferToEmployeeOwnershipTrustDetails><ols6:QualifyingTransferCount>
T5013FIN:PS6	S	60	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QualifyingTransferToEmployeeOwnershipTrustDetails><ols6:QualifyingTransferClassDescription>
T5013FIN:PS6	S	175	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QualifyingTransferToEmployeeOwnershipTrustDetails><ols6:QualifyingTransferCorporationName>
T5013FIN:PS6	S	10	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QualifyingTransferToEmployeeOwnershipTrustDetails><ols6:QualifyingTransferAcquisitionDate>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QualifyingTransferToEmployeeOwnershipTrustDetails><ols6:QualifyingTransferProceedsOfDispositionAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QualifyingTransferToEmployeeOwnershipTrustDetails><ols6:QualifyingTransferAdjustedCostBaseAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QualifyingTransferToEmployeeOwnershipTrustDetails><ols6:QualifyingTransferOutlaysAndExpensesAmount>
T5013FIN:PS6	N	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QualifyingTransferToEmployeeOwnershipTrustDetails><ols6:QualifyingTransferGainAmount>
T5013FIN:PS6	TE	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QualifyingTransferToEmployeeOwnershipTrustDetails>
T5013FIN:PS6	T	460,461,462,463,464,465,466,467	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QualifyingTransferToEmployeeOwnershipTrustDetails>
T5013FIN:PS6	T	468,469,470,471,472,473,474,475	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QualifyingTransferToEmployeeOwnershipTrustDetails>
T5013FIN:PS6	T	476,477,478,479,480,481,482,483	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QualifyingTransferToEmployeeOwnershipTrustDetails>
T5013FIN:PS6	T	484,485,486,487,488,489,490,491	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QualifyingTransferToEmployeeOwnershipTrustDetails>
T5013FIN:PS6	T	492,493,494,495,496,497,498,499	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QualifyingTransferToEmployeeOwnershipTrustDetails>
T5013FIN:PS6	N	503	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:QualifyingTransferGainTotalAmount>
T5013FIN:PS6	N	504	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part13Portion1Amount>
T5013FIN:PS6	N	505	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part13Portion2Amount>
// PS6 Part 14
T5013FIN:PS6	N	506	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QSBCSharesDeductionAmount>
T5013FIN:PS6	N	507	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPDeductionAmount>
T5013FIN:PS6	N	508	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QFFPForeclosuresAndRepossessionsAmount>
T5013FIN:PS6	N	509	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6QualifyingTransferToEmployeeOwnershipTrustAmount>
T5013FIN:PS6	N	510	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part14Portion1Amount>
T5013FIN:PS6	N	511	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part14Portion2Amount>
T5013FIN:PS6	N	512	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part14Portion3Amount>
T5013FIN:PS6	N	513	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part14Portion4Amount>
T5013FIN:PS6	N	514	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part14Portion5Amount>
T5013FIN:PS6	N	515	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part14Portion6Amount>
T5013FIN:PS6	N	516	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part14Portion7Amount>
T5013FIN:PS6	N	517	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part14Portion8Amount>
// PS6 Part 15
// On CRA site and in our program we haven't line 990 for the next tag <ols6:Schedule6CapitalGainsLossesAmount> (Note: use for form version T5013 SCH 6 E (22))
//T5013FIN:PS6	N	51n	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6CapitalGainsLossesAmount>
T5013FIN:PS6	N	518	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part15TotalCapitalGains1Amount>
T5013FIN:PS6	N	519	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part15TotalCapitalGains2Amount>
T5013FIN:PS6	N	520	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part15DeemedCapitalGains1Amount>
T5013FIN:PS6	N	521	15	<olsbr:OLSBRT5013Data><ols6:T5013Schedule6Data><ols6:Schedule6Part15DeemedCapitalGains2Amount>
// PS8
T5013FIN:PS8	B	45,61	1	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:AssociatedEPOPIndicator>
T5013FIN:PS8	TS	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	S	175	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails><ols8:EPOPName>
T5013FIN:PS8	S	15	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails><ols8:IDNumber>
T5013FIN:PS8	N	9	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails><ols8:PercentageAssigned>
T5013FIN:PS8	TE	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	T	528,529,530	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	T	531,532,533	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	T	534,535,536	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	T	537,538,539	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	T	540,541,542	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	T	543,544,545	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	T	546,547,548	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	T	549,550,551	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	T	552,553,554	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	T	555,556,557	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	T	558,559,560	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	T	561,562,563	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	T	564,565,566	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	T	567,568,569	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	T	570,571,572	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	T	573,574,575	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	T	576,577,578	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	T	579,580,581	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	T	582,583,584	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	T	585,586,587	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	T	588,589,590	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	T	591,592,593	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	T	594,595,596	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	T	597,598,599	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8AgreementDetails>
T5013FIN:PS8	N	29	15	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:ImmediateExpensingLimitAmount>
T5013FIN:PS8	B	4,5	1	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:CcpcIndicator>
T5013FIN:PS8	B	157,173	1	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:MultipleSourceIncomeIndicator>
T5013FIN:PS8	N	215	15	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:NetIncomePreCCA>
T5013FIN:PS8	TS	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails>
T5013FIN:PS8	S	175	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails><ols8:SourceOfIncome>
T5013FIN:PS8	N	15	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails><ols8:IncomePreCCADeductions>
T5013FIN:PS8	N	15	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails><ols8:AggregateDiep>
T5013FIN:PS8	TE	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails>
T5013FIN:PS8	T	601,602,603	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails>
T5013FIN:PS8	T	604,605,606	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails>
T5013FIN:PS8	T	607,608,609	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails>
T5013FIN:PS8	T	610,611,612	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails>
T5013FIN:PS8	T	613,614,615	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails>
T5013FIN:PS8	T	616,617,618	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails>
T5013FIN:PS8	T	619,620,621	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails>
T5013FIN:PS8	T	622,623,624	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails>
T5013FIN:PS8	T	625,626,627	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails>
T5013FIN:PS8	T	628,629,630	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails>
T5013FIN:PS8	T	631,632,633	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails>
T5013FIN:PS8	T	634,635,636	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails>
T5013FIN:PS8	T	637,638,639	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails>
T5013FIN:PS8	T	640,641,642	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails>
T5013FIN:PS8	T	643,644,645	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails>
T5013FIN:PS8	T	646,647,648	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails>
T5013FIN:PS8	T	649,650,651	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails>
T5013FIN:PS8	T	652,653,654	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails>
T5013FIN:PS8	T	655,656,657	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails>
T5013FIN:PS8	T	658,659,660	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails>
T5013FIN:PS8	T	661,662,663	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails>
T5013FIN:PS8	T	664,665,666	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8IncomeDetails>
T5013FIN:PS8	TS	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails>
T5013FIN:PS8	S	13	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails><ols8:CCAClassNumber>
T5013FIN:PS8	N	15	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails><ols8:OpeningUCCAmount>
T5013FIN:PS8	N	15	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails><ols8:CCAAcquisitionCostAmount>
T5013FIN:PS8	N	15	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails><ols8:CCAAcquisitionCostDIEPAmount>
T5013FIN:PS8	N	15	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails><ols8:CCANetAdjustmentAmount>
T5013FIN:PS8	N	15	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails><ols8:CCADispositionAssistanceReceivedAmount>
T5013FIN:PS8	N	15	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails><ols8:CCADispositionRepaidAmount>
T5013FIN:PS8	N	15	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails><ols8:CCADispositionProceedsAmount>
T5013FIN:PS8	N	15	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails><ols8:CCADispositionProceedsDIEPAmount>
T5013FIN:PS8	N	15	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails><ols8:CCAUndepreciatedCapitalCostDIEPAmount>
// Next field valid just for 2022 tax year
//T5013FIN:PS8	N	15	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails><ols8:CCAIncomeEarnedAmount>
T5013FIN:PS8	N	15	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails><ols8:CCAImmediateExpensingAmount>
T5013FIN:PS8	N	15	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails><ols8:CCANonPropertyZEVAcquisitionAmount>
T5013FIN:PS8	N	6	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails><ols8:CCARatePercent>
T5013FIN:PS8	N	15	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails><ols8:CCARecaptureAmount>
T5013FIN:PS8	N	15	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails><ols8:CCATerminalLossAmount>
T5013FIN:PS8	N	15	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails><ols8:ClaimedCCAAmount>
T5013FIN:PS8	N	15	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails><ols8:ClosingUCCAmount>
T5013FIN:PS8	TE	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails>
T5013FIN:PS8	T	6,7,8,463,9,265,278,10,400,424,437,252,330,17,18,19,20,21	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails>
T5013FIN:PS8	T	22,23,24,464,25,266,279,26,401,425,438,253,331,33,34,35,36,37	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails>
T5013FIN:PS8	T	38,39,40,465,41,267,280,42,402,426,439,254,332,49,50,51,52,53	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails>
T5013FIN:PS8	T	54,55,56,466,57,268,281,58,403,427,440,255,333,65,66,67,68,69	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails>
T5013FIN:PS8	T	70,71,72,467,73,269,282,74,404,428,441,256,334,81,82,83,84,85	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails>
T5013FIN:PS8	T	86,87,88,468,89,270,283,90,405,429,442,257,335,97,98,99,100,101	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails>
T5013FIN:PS8	T	102,103,104,469,105,271,284,106,406,430,443,258,336,113,114,115,116,117	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails>
T5013FIN:PS8	T	118,119,120,470,121,272,285,122,407,431,444,259,337,129,130,131,132,133	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails>
T5013FIN:PS8	T	134,135,136,471,137,273,286,138,408,432,445,260,338,145,146,147,148,149	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails>
T5013FIN:PS8	T	150,151,152,472,153,274,287,154,409,433,446,261,339,161,162,163,164,165	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails>
T5013FIN:PS8	T	166,167,168,473,169,275,288,170,410,434,447,262,340,177,178,179,180,181	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails>
T5013FIN:PS8	T	182,183,184,474,185,276,289,186,411,435,448,263,341,193,194,195,196,197	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails>
T5013FIN:PS8	T	198,199,200,475,201,277,290,202,412,436,449,264,342,209,210,211,212,213	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:Schedule8CapitalCostAllowanceDetails>
T5013FIN:PS8	N	230	15	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:CCARecaptureTotalAmount>
T5013FIN:PS8	N	231	15	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:TerminalLossTotalAmount>
T5013FIN:PS8	N	232	15	<olsbr:OLSBRT5013Data><ols8:T5013Schedule8Data><ols8:ClaimedCCATotalAmount>
// PS8-1 (This set of tags is for information relating to class 43.1 or class 43.2 assets.)
// On CRA site and in our program we haven't form version T5013 SCH8-1. Created structure only and commented
//T5013FIN:PS8-1	TS	<olsbr:OLSBRT5013Data><ols8-1:T5013Schedule8-1Data>
//T5013FIN:PS8-1	S	13	<olsbr:OLSBRT5013Data><ols8-1:T5013Schedule8-1Data><ols8-1:CCAClassNumber>
//T5013FIN:PS8-1	N	2	<olsbr:OLSBRT5013Data><ols8-1:T5013Schedule8-1Data><ols8-1:CCAAssetTypeCode>
//T5013FIN:PS8-1	S	2	<olsbr:OLSBRT5013Data><ols8-1:T5013Schedule8-1Data><ols8-1:TaxJurisdictionCode>
//T5013FIN:PS8-1	N	6	<olsbr:OLSBRT5013Data><ols8-1:T5013Schedule8-1Data><ols8-1:CCAAssetAllocatedPercent>
//T5013FIN:PS8-1	TE	<olsbr:OLSBRT5013Data><ols8-1:T5013Schedule8-1Data>
//T5013FIN:PS8-1	T	1,2,3,4	<olsbr:OLSBRT5013Data><ols8-1:T5013Schedule8-1Data>
// PS09
T5013FIN:PS9	TS	<olsbr:OLSBRT5013Data><ols9:T5013Schedule9Data><ols9:Schedule9ListofPartnerships>
T5013FIN:PS9	S	175	<olsbr:OLSBRT5013Data><ols9:T5013Schedule9Data><ols9:Schedule9ListofPartnerships><ols9:RelatedEntityFullName>
T5013FIN:PS9	S	3	<olsbr:OLSBRT5013Data><ols9:T5013Schedule9Data><ols9:Schedule9ListofPartnerships><ols9:RelatedEntityFormationJurisdictionCode>
T5013FIN:PS9	S	9	<olsbr:OLSBRT5013Data><ols9:T5013Schedule9Data><ols9:Schedule9ListofPartnerships><ols9:RelatedEntityIdentificationNumber>
T5013FIN:PS9	N	2	<olsbr:OLSBRT5013Data><ols9:T5013Schedule9Data><ols9:Schedule9ListofPartnerships><ols9:EntityRelationTypeCode>
T5013FIN:PS9	TE	<olsbr:OLSBRT5013Data><ols9:T5013Schedule9Data><ols9:Schedule9ListofPartnerships>
T5013FIN:PS9	T	6,7,8,9	<olsbr:OLSBRT5013Data><ols9:T5013Schedule9Data><ols9:Schedule9ListofPartnerships>
T5013FIN:PS9	T	14,15,16,17	<olsbr:OLSBRT5013Data><ols9:T5013Schedule9Data><ols9:Schedule9ListofPartnerships>
T5013FIN:PS9	T	22,23,24,25	<olsbr:OLSBRT5013Data><ols9:T5013Schedule9Data><ols9:Schedule9ListofPartnerships>
T5013FIN:PS9	T	30,31,32,33	<olsbr:OLSBRT5013Data><ols9:T5013Schedule9Data><ols9:Schedule9ListofPartnerships>
T5013FIN:PS9	T	38,39,40,41	<olsbr:OLSBRT5013Data><ols9:T5013Schedule9Data><ols9:Schedule9ListofPartnerships>
T5013FIN:PS9	T	46,47,48,49	<olsbr:OLSBRT5013Data><ols9:T5013Schedule9Data><ols9:Schedule9ListofPartnerships>
T5013FIN:PS9	T	54,55,56,57	<olsbr:OLSBRT5013Data><ols9:T5013Schedule9Data><ols9:Schedule9ListofPartnerships>
T5013FIN:PS9	T	62,63,64,65	<olsbr:OLSBRT5013Data><ols9:T5013Schedule9Data><ols9:Schedule9ListofPartnerships>
T5013FIN:PS9	T	70,71,72,73	<olsbr:OLSBRT5013Data><ols9:T5013Schedule9Data><ols9:Schedule9ListofPartnerships>
T5013FIN:PS9	T	78,79,80,81	<olsbr:OLSBRT5013Data><ols9:T5013Schedule9Data><ols9:Schedule9ListofPartnerships>
T5013FIN:PS9	T	86,87,88,89	<olsbr:OLSBRT5013Data><ols9:T5013Schedule9Data><ols9:Schedule9ListofPartnerships>
// PS12
// PS12 - Part 1
T5013FIN:PS12	N	5	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	100
T5013FIN:PS12	N	6	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	112
T5013FIN:PS12	N	7	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	114
T5013FIN:PS12	N	8	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	116
T5013FIN:PS12	N	11	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	124
T5013FIN:PS12	N	12	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	126
T5013FIN:PS12	N	15	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	150
T5013FIN:PS12	N	78	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	152
T5013FIN:PS12	N	74	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	154
T5013FIN:PS12	N	79	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	156
T5013FIN:PS12	N	16	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	160
T5013FIN:PS12	N	33	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	170
// PS12 - Part 2
T5013FIN:PS12	N	17	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	200
T5013FIN:PS12	N	18	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	214
T5013FIN:PS12	N	19	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	216
T5013FIN:PS12	N	22	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	224
T5013FIN:PS12	N	23	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	226
T5013FIN:PS12	N	26	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	250
T5013FIN:PS12	N	80	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	252
T5013FIN:PS12	N	81	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	254
T5013FIN:PS12	N	82	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	256
T5013FIN:PS12	N	27	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	260
T5013FIN:PS12	N	83	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	262
T5013FIN:PS12	N	73	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	270
// PS12 - Part 3
T5013FIN:PS12	N	28	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	300
T5013FIN:PS12	N	29	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	314
T5013FIN:PS12	N	30	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	316
T5013FIN:PS12	N	34	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	324
T5013FIN:PS12	N	35	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	326
T5013FIN:PS12	N	38	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	350
T5013FIN:PS12	N	84	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	352
T5013FIN:PS12	N	85	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	354
T5013FIN:PS12	N	86	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	356
T5013FIN:PS12	N	39	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	360
T5013FIN:PS12	N	87	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	362
T5013FIN:PS12	N	92	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12LineAmounts>	P:FieldCodeAmountRule	370
T5013FIN:PS12	TS	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12ForeignResourceExpenses><ols12:Schedule12ForeignResourceExpensesLineItems>
T5013FIN:PS12	S	3	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12ForeignResourceExpenses><ols12:Schedule12ForeignResourceExpensesLineItems><ols12:Schedule12ForeignCountryName>
T5013FIN:PS12	N	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12ForeignResourceExpenses><ols12:Schedule12ForeignResourceExpensesLineItems><ols12:Schedule12CurrentYearExpensesAmount>
T5013FIN:PS12	N	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12ForeignResourceExpenses><ols12:Schedule12ForeignResourceExpensesLineItems><ols12:Schedule12TransferAdditionsAmount>
T5013FIN:PS12	N	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12ForeignResourceExpenses><ols12:Schedule12ForeignResourceExpensesLineItems><ols12:Schedule12OtherAdditionsAmount>
T5013FIN:PS12	N	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12ForeignResourceExpenses><ols12:Schedule12ForeignResourceExpensesLineItems><ols12:Schedule12TransferDeductionsAmount>
T5013FIN:PS12	N	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12ForeignResourceExpenses><ols12:Schedule12ForeignResourceExpensesLineItems><ols12:Schedule12OtherDeductionsAmount>
T5013FIN:PS12	N	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12ForeignResourceExpenses><ols12:Schedule12ForeignResourceExpensesLineItems><ols12:Schedule12ExpensesLineTotalAmount>
T5013FIN:PS12	N	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12ForeignResourceExpenses><ols12:Schedule12ForeignResourceExpensesLineItems><ols12:Schedule12InterestAndFinancingExpensesAmount>
T5013FIN:PS12	N	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12ForeignResourceExpenses><ols12:Schedule12ForeignResourceExpensesLineItems><ols12:Schedule12ForeignResourceIncomeAmount>
T5013FIN:PS12	TE	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12ForeignResourceExpenses><ols12:Schedule12ForeignResourceExpensesLineItems>
T5013FIN:PS12	T	40,41,42,43,44,45,46,88,47	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12ForeignResourceExpenses><ols12:Schedule12ForeignResourceExpensesLineItems>
T5013FIN:PS12	T	48,49,50,51,52,53,54,89,55	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12ForeignResourceExpenses><ols12:Schedule12ForeignResourceExpensesLineItems>
T5013FIN:PS12	T	56,57,58,59,60,61,62,90,63	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12ForeignResourceExpenses><ols12:Schedule12ForeignResourceExpensesLineItems>
T5013FIN:PS12	T	64,65,66,67,68,69,70,91,71	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12ForeignResourceExpenses><ols12:Schedule12ForeignResourceExpensesLineItems>
T5013FIN:PS12	N	72	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12ForeignResourceExpenses><ols12:Schedule12ForeignResourceExpensesTotalAmount>
T5013FIN:PS12	N	93	15	<olsbr:OLSBRT5013Data><ols12:T5013Schedule12Data><ols12:Schedule12ForeignResourceExpenses><ols12:Schedule12InterestAndFinancingExpensesTotalAmount>
// PS50
T5013FIN:PS50	N	6	15	<olsbr:OLSBRT5013Data><ols50:T5013Schedule50Data><ols50:Schedule50PartnersCount>
T5013FIN:PS50	N	7	15	<olsbr:OLSBRT5013Data><ols50:T5013Schedule50Data><ols50:Schedule50DisposedInterestPartnersCount>
T5013FIN:PS50	N	8	15	<olsbr:OLSBRT5013Data><ols50:T5013Schedule50Data><ols50:Schedule50NomineesAgentsCount>
T5013FIN:PS50	N	9	15	<olsbr:OLSBRT5013Data><ols50:T5013Schedule50Data><ols50:Schedule50NetIncomeTotalForAllPartnersAmount>
T5013FIN:PS50	S2	30,11	175	<olsbr:OLSBRT5013Data><ols50:T5013Schedule50Data><ols50:Schedule50PartnersAtYearEnd><ols50:Schedule50PartnerName>
T5013FIN:PS50	S	13	15	<olsbr:OLSBRT5013Data><ols50:T5013Schedule50Data><ols50:Schedule50PartnersAtYearEnd><ols50:Schedule50PartnerAccountNumber>
T5013FIN:PS50	N	14	2	<olsbr:OLSBRT5013Data><ols50:T5013Schedule50Data><ols50:Schedule50PartnersAtYearEnd><ols50:Schedule50PartnerTypeCode>
T5013FIN:PS50	N	15	2	<olsbr:OLSBRT5013Data><ols50:T5013Schedule50Data><ols50:Schedule50PartnersAtYearEnd><ols50:Schedule50PartnerCode>
T5013FIN:PS50	N	16	8	<olsbr:OLSBRT5013Data><ols50:T5013Schedule50Data><ols50:Schedule50PartnersAtYearEnd><ols50:Schedule50PartnerOwnershipPercent>
T5013FIN:PS50	B2	12,29	1	<olsbr:OLSBRT5013Data><ols50:T5013Schedule50Data><ols50:Schedule50PartnersAtYearEnd><ols50:Schedule50PartnerInterestDisposedOfIndicator>
T5013FIN:PS50	N	17	15	<olsbr:OLSBRT5013Data><ols50:T5013Schedule50Data><ols50:Schedule50PartnersAtYearEnd><ols50:Schedule50PartnerLineAmounts>	P:FieldCodeAmountRule	220
T5013FIN:PS50	N	18	15	<olsbr:OLSBRT5013Data><ols50:T5013Schedule50Data><ols50:Schedule50PartnersAtYearEnd><ols50:Schedule50PartnerLineAmounts>	P:FieldCodeAmountRule	300
T5013FIN:PS50	N	19	15	<olsbr:OLSBRT5013Data><ols50:T5013Schedule50Data><ols50:Schedule50PartnersAtYearEnd><ols50:Schedule50PartnerLineAmounts>	P:FieldCodeAmountRule	310
T5013FIN:PS50	N	25	15	<olsbr:OLSBRT5013Data><ols50:T5013Schedule50Data><ols50:Schedule50PartnersAtYearEnd><ols50:Schedule50PartnerLineAmounts>	P:FieldCodeAmountRule	320
T5013FIN:PS50	N	26	15	<olsbr:OLSBRT5013Data><ols50:T5013Schedule50Data><ols50:Schedule50PartnersAtYearEnd><ols50:Schedule50PartnerLineAmounts>	P:FieldCodeAmountRule	330
T5013FIN:PS50	N	27	15	<olsbr:OLSBRT5013Data><ols50:T5013Schedule50Data><ols50:Schedule50PartnersAtYearEnd><ols50:Schedule50PartnerLineAmounts>	P:FieldCodeAmountRule	340
T5013FIN:PS50	N	28	15	<olsbr:OLSBRT5013Data><ols50:T5013Schedule50Data><ols50:Schedule50PartnersAtYearEnd><ols50:Schedule50PartnerLineAmounts>	P:FieldCodeAmountRule	350
T5013FIN:PS50	N	31	15	<olsbr:OLSBRT5013Data><ols50:T5013Schedule50Data><ols50:Schedule50PartnersAtYearEnd><ols50:Schedule50PartnerLineAmounts>	P:FieldCodeAmountRule	410
T5013FIN:PS50	N	32	15	<olsbr:OLSBRT5013Data><ols50:T5013Schedule50Data><ols50:Schedule50PartnersAtYearEnd><ols50:Schedule50PartnerLineAmounts>	P:FieldCodeAmountRule	420
T5013FIN:PS50	N	33	15	<olsbr:OLSBRT5013Data><ols50:T5013Schedule50Data><ols50:Schedule50PartnersAtYearEnd><ols50:Schedule50PartnerLineAmounts>	P:FieldCodeAmountRule	430
// PS52
T5013FIN:PS52	TS	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52RenouncedResourceExpensesDetails>
T5013FIN:PS52	S	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52RenouncedResourceExpensesDetails><ols52:RREIssuingCorporationIdentificationNumber>
T5013FIN:PS52	S	10	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52RenouncedResourceExpensesDetails><ols52:RREEffectiveRenunciationDate>
T5013FIN:PS52	N	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52RenouncedResourceExpensesDetails><ols52:RRECEEAmount>
T5013FIN:PS52	N	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52RenouncedResourceExpensesDetails><ols52:RRECanadianDevelopmentExpensesAmount>
T5013FIN:PS52	N	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52RenouncedResourceExpensesDetails><ols52:RRECCEInterestFreePeriodAmount>
T5013FIN:PS52	TE	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52RenouncedResourceExpensesDetails>
T5013FIN:PS52	T	9,10,12,13,14	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52RenouncedResourceExpensesDetails>
T5013FIN:PS52	T	16,17,18,19,20	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52RenouncedResourceExpensesDetails>
T5013FIN:PS52	T	22,23,24,25,26	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52RenouncedResourceExpensesDetails>
T5013FIN:PS52	T	28,29,30,31,32	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52RenouncedResourceExpensesDetails>
T5013FIN:PS52	N	33	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:TotalCEEAmount>
T5013FIN:PS52	N	34	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:TotalCanadianDevelopmentExpensesAmount>
T5013FIN:PS52	N	35	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:TotalCEEInterestFreePeriodAmount>
T5013FIN:PS52	TS	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52AllocatedAssistanceDetails>
T5013FIN:PS52	S	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52AllocatedAssistanceDetails><ols52:AllocatedAssistanceIssuingCorporationIdentificationNumber>
T5013FIN:PS52	S	10	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52AllocatedAssistanceDetails><ols52:AllocatedAssistanceEffectiveRenunciationDate>
T5013FIN:PS52	N	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52AllocatedAssistanceDetails><ols52:AllocatedAssistanceCCEAmount>
T5013FIN:PS52	N	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52AllocatedAssistanceDetails><ols52:AllocatedAssistanceCanadianDevelopmentExpensesAmount>
T5013FIN:PS52	TE	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52AllocatedAssistanceDetails>
T5013FIN:PS52	T	37,38,39,40	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52AllocatedAssistanceDetails>
T5013FIN:PS52	T	42,43,44,45	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52AllocatedAssistanceDetails>
T5013FIN:PS52	T	47,48,49,50	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52AllocatedAssistanceDetails>
T5013FIN:PS52	T	52,53,54,55	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52AllocatedAssistanceDetails>
T5013FIN:PS52	N	56	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:TotalAssistanceCCEAmount>
T5013FIN:PS52	N	57	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:TotalAssistanceCanadianDevelopmentExpensesAmount>
T5013FIN:PS52	TS	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedITCDetails>
T5013FIN:PS52	S	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedITCDetails><ols52:ITCIssuingCorporationIdentificationNumber>
T5013FIN:PS52	S	10	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedITCDetails><ols52:ITCEffectiveRenunciationDate>
T5013FIN:PS52	N	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedITCDetails><ols52:ITCMiningExplorationAmount>
T5013FIN:PS52	N	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedITCDetails><ols52:ITCInterestFreePeriodAmount>
T5013FIN:PS52	N	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedITCDetails><ols52:ITCMineralExplorationCmetcAmount>
T5013FIN:PS52	N	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedITCDetails><ols52:ITCInterestFreePeriodCmetcAmount>
T5013FIN:PS52	TE	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedITCDetails>
T5013FIN:PS52	T	59,60,61,62,122,126	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedITCDetails>
T5013FIN:PS52	T	64,65,66,67,123,127	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedITCDetails>
T5013FIN:PS52	T	69,70,71,72,124,128	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedITCDetails>
T5013FIN:PS52	T	74,75,76,77,125,129	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedITCDetails>
T5013FIN:PS52	N	78	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:TotalITCMiningExplorationAmount>
T5013FIN:PS52	N	79	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:TotalITCInterestFreePeriodAmount>
T5013FIN:PS52	N	130	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:TotalITCMineralExplorationCmetcAmount>
T5013FIN:PS52	N	131	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:TotalITCInterestFreePeriodCmetcAmount>

T5013FIN:PS52	TS	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedProvincialTaxCreditDetails>
T5013FIN:PS52	S	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedProvincialTaxCreditDetails><ols52:QualifiedIssuingCorporationIdentificationNumber>
T5013FIN:PS52	N	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedProvincialTaxCreditDetails><ols52:QualifiedProvincialTaxCredits>	P:FieldCodeAmountRule	402
T5013FIN:PS52	N	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedProvincialTaxCreditDetails><ols52:QualifiedProvincialTaxCredits>	P:FieldCodeAmountRule	403
T5013FIN:PS52	N	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedProvincialTaxCreditDetails><ols52:QualifiedProvincialTaxCredits>	P:FieldCodeAmountRule	404
T5013FIN:PS52	N	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedProvincialTaxCreditDetails><ols52:QualifiedProvincialTaxCredits>	P:FieldCodeAmountRule	405
T5013FIN:PS52	N	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedProvincialTaxCreditDetails><ols52:QualifiedProvincialTaxCredits>	P:FieldCodeAmountRule	406
T5013FIN:PS52	N	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedProvincialTaxCreditDetails><ols52:QualifiedProvincialTaxCredits>	P:FieldCodeAmountRule	407
T5013FIN:PS52	N	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedProvincialTaxCreditDetails><ols52:QualifiedProvincialTaxCredits>	P:FieldCodeAmountRule	408
T5013FIN:PS52	N	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedProvincialTaxCreditDetails><ols52:QualifiedProvincialTaxCredits>	P:FieldCodeAmountRule	409
T5013FIN:PS52	TE	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedProvincialTaxCreditDetails>
T5013FIN:PS52	T	81,82,132,83,136,84,140,85,144	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedProvincialTaxCreditDetails>
T5013FIN:PS52	T	87,88,133,89,137,90,141,91,145	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedProvincialTaxCreditDetails>
T5013FIN:PS52	T	93,94,134,95,138,96,142,97,146	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedProvincialTaxCreditDetails>
T5013FIN:PS52	T	99,100,135,101,139,102,143,103,147	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52QualifiedProvincialTaxCreditDetails>

T5013FIN:PS52	N	104	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52TotalQualifiedProvincialTaxCredits>	P:FieldCodeAmountRule	141
T5013FIN:PS52	N	7	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52TotalQualifiedProvincialTaxCredits>	P:FieldCodeAmountRule	151
T5013FIN:PS52	N	105	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52TotalQualifiedProvincialTaxCredits>	P:FieldCodeAmountRule	143
T5013FIN:PS52	N	8	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52TotalQualifiedProvincialTaxCredits>	P:FieldCodeAmountRule	153
T5013FIN:PS52	N	106	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52TotalQualifiedProvincialTaxCredits>	P:FieldCodeAmountRule	144
T5013FIN:PS52	N	114	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52TotalQualifiedProvincialTaxCredits>	P:FieldCodeAmountRule	154
T5013FIN:PS52	N	107	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52TotalQualifiedProvincialTaxCredits>	P:FieldCodeAmountRule	145
T5013FIN:PS52	N	148	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52TotalQualifiedProvincialTaxCredits>	P:FieldCodeAmountRule	155
T5013FIN:PS52	N	5	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52PenaltyCalculation><ols52:Schedule52ExpensePenaltyAmount>
T5013FIN:PS52	N	112	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52PenaltyCalculation><ols52:Schedule52AssistancePenaltyAmount>
T5013FIN:PS52	N	116	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52PenaltyCalculation><ols52:Schedule52CalculatedExpensePenaltyAmount>
T5013FIN:PS52	N	117	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52PenaltyCalculation><ols52:Schedule52CalculatedAssistancePenaltyAmount>
T5013FIN:PS52	N	118	15	<olsbr:OLSBRT5013Data><ols52:T5013Schedule52Data><ols52:Schedule52PenaltyCalculation><ols52:Schedule52TotalPenaltyAmount>
// PS58
T5013FIN:PS58	B2	8,9	1	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58MeetConditions>
T5013FIN:PS58	S	10	10	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58FromDate>
T5013FIN:PS58	S	11	10	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58ToDate>
T5013FIN:PS58	N	12	7	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58QCJODesignationNumber>
T5013FIN:PS58	TS	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	S	175	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails><ols58:Schedule58NameOfEligibleNewsroomEmployee>
T5013FIN:PS58	N	9	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails><ols58:Schedule58SINOfEligibleNewsroomEmployee>
T5013FIN:PS58	N	15	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails><ols58:Schedule58SalaryOrWagesPayable>
T5013FIN:PS58	N	15	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails><ols58:Schedule58AmountOfAssistanceReceivedOrReceivable>
T5013FIN:PS58	N	15	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails><ols58:Schedule58QualifyingLabourExpenditure>
T5013FIN:PS58	N	15	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails><ols58:Schedule58LabourTaxCredit>
T5013FIN:PS58	TE	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	28,29,30,31,356,35	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	36,37,38,39,357,43	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	44,45,46,47,358,51	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	52,53,54,55,359,59	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	60,61,62,63,360,67	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	68,69,70,71,361,75	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	76,77,78,79,362,83	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	84,85,86,87,363,91	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	92,93,94,95,364,99	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	100,101,102,103,365,107	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	108,109,110,111,366,115	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	116,117,118,119,367,123	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	124,125,126,127,368,131	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	132,133,134,135,369,139	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	140,141,142,143,370,147	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	148,149,150,151,371,155	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	156,157,158,159,372,163	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	164,165,166,167,373,171	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	172,173,174,175,374,179	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	180,181,182,183,375,187	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	188,189,190,191,376,195	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	196,197,198,199,377,203	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	204,205,206,207,378,211	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	212,213,214,215,379,219	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	220,221,222,223,380,227	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	228,229,230,231,381,235	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	236,237,238,239,382,243	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	T	244,245,246,247,383,251	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditDetails>
T5013FIN:PS58	N	17	15	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58AmountReceivedFromTheAidToPublishers>
T5013FIN:PS58	N	18	15	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58CanadianJournalismLabourTaxCreditNetAmount>
T5013FIN:PS58	TS	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58AllocationOfCreditToEligibleMembersOfAPartnershipDetails>
T5013FIN:PS58	S	175	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58AllocationOfCreditToEligibleMembersOfAPartnershipDetails><ols58:Schedule58NameOfEligiblePartner>
T5013FIN:PS58	S	15	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58AllocationOfCreditToEligibleMembersOfAPartnershipDetails><ols58:Schedule58SINBusinessNumberTrustAccountNumberOfEligiblePartner>
T5013FIN:PS58	N	15	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58AllocationOfCreditToEligibleMembersOfAPartnershipDetails><ols58:Schedule58AmountAllocated>
T5013FIN:PS58	TE	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58AllocationOfCreditToEligibleMembersOfAPartnershipDetails>
T5013FIN:PS58	T	252,253,255	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58AllocationOfCreditToEligibleMembersOfAPartnershipDetails>
T5013FIN:PS58	T	256,257,259	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58AllocationOfCreditToEligibleMembersOfAPartnershipDetails>
T5013FIN:PS58	T	260,261,263	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58AllocationOfCreditToEligibleMembersOfAPartnershipDetails>
T5013FIN:PS58	T	264,265,267	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58AllocationOfCreditToEligibleMembersOfAPartnershipDetails>
T5013FIN:PS58	T	268,269,271	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58AllocationOfCreditToEligibleMembersOfAPartnershipDetails>
T5013FIN:PS58	T	272,273,275	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58AllocationOfCreditToEligibleMembersOfAPartnershipDetails>
T5013FIN:PS58	T	276,277,279	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58AllocationOfCreditToEligibleMembersOfAPartnershipDetails>
T5013FIN:PS58	T	280,281,283	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58AllocationOfCreditToEligibleMembersOfAPartnershipDetails>
T5013FIN:PS58	T	284,285,287	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58AllocationOfCreditToEligibleMembersOfAPartnershipDetails>
T5013FIN:PS58	T	288,289,291	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58AllocationOfCreditToEligibleMembersOfAPartnershipDetails>
T5013FIN:PS58	T	292,293,295	<olsbr:OLSBRT5013Data><ols58:T5013Schedule58Data><ols58:Schedule58AllocationOfCreditToEligibleMembersOfAPartnershipDetails>
//PS63
T5013FIN:PS63	N	4	15	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:TotalFarmExpensesAmount>
T5013FIN:PS63	N	5	15	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:MandatoryInventoryAdjustmentsAmount>
T5013FIN:PS63	N	6	15	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:OptionalValueOfInventoryAmount>
T5013FIN:PS63	N	7	15	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:NonArmsLengthTransactionsAmount>
T5013FIN:PS63	N	10	15	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:GrossEligibleFarmingExpensesAmount>
T5013FIN:PS63	TS	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63CalculationOfCreditDetails>
T5013FIN:PS63	SV	2	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63CalculationOfCreditDetails><ols63:Schedule63CalculationOfCreditDesignatedProvinceCode>
T5013FIN:PS63	N	15	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63CalculationOfCreditDetails><ols63:Schedule63GrossRevenueAmount>
T5013FIN:PS63	N	15	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63CalculationOfCreditDetails><ols63:Schedule63TotalGrossRevenueAmount>
T5013FIN:PS63	N	15	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63CalculationOfCreditDetails><ols63:Schedule63SalariesAndWagesPaidAmount>
T5013FIN:PS63	N	15	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63CalculationOfCreditDetails><ols63:Schedule63TotalSalariesAndWagesPaidAmount>
T5013FIN:PS63	N	15	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63CalculationOfCreditDetails><ols63:Schedule63EligibleFarmingExpensesAmount>
T5013FIN:PS63	N	15	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63CalculationOfCreditDetails><ols63:Schedule63TaxCreditForYearWhichFiscalPeriodStartedAmount>
T5013FIN:PS63	N	15	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63CalculationOfCreditDetails><ols63:Schedule63TaxCreditForYearWhichFiscalPeriodEndedAmount>
T5013FIN:PS63	N	15	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63CalculationOfCreditDetails><ols63:Schedule63PartnershipAllocationAmount>
T5013FIN:PS63	N	15	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63CalculationOfCreditDetails><ols63:Schedule63TotalAmount>
T5013FIN:PS63	TE	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63CalculationOfCreditDetails>
T5013FIN:PS63	T	"NL",259,260,262,263,267,316,318,319,335	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63CalculationOfCreditDetails>
T5013FIN:PS63	T	"PE",268,269,271,272,276,321,323,324,340	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63CalculationOfCreditDetails>
T5013FIN:PS63	T	"NS",277,278,280,281,285,326,328,329,341	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63CalculationOfCreditDetails>
T5013FIN:PS63	T	"NB",286,287,289,290,294,331,333,334,342	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63CalculationOfCreditDetails>
T5013FIN:PS63	T	"ON",11,12,14,15,19,63,65,66,83	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63CalculationOfCreditDetails>
T5013FIN:PS63	T	"MB",20,21,23,24,28,68,70,71,84	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63CalculationOfCreditDetails>
T5013FIN:PS63	T	"SK",29,30,32,33,37,73,75,76,85	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63CalculationOfCreditDetails>
T5013FIN:PS63	T	"AB",38,39,41,42,46,78,80,81,86	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63CalculationOfCreditDetails>
T5013FIN:PS63	N	82	15	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63DesignatedProvincesTotal>
T5013FIN:PS63	N	92	15	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63TotalCreditAllocatedAmount>
T5013FIN:PS63	N	93	15	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63TotalReturnOfuelChargeAmount>

T5013FIN:PS63	TS	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>
T5013FIN:PS63	S	175	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63MemberName>
T5013FIN:PS63	S	15	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63MemberAccountNumber>
T5013FIN:PS63	N	9	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63MemberProportionPercent>
T5013FIN:PS63	NT	2	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	TE	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>
T5013FIN:PS63	T	94,95,96,0	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>
T5013FIN:PS63	T	101,102,103,1	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>
T5013FIN:PS63	T	108,109,110,2	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>
T5013FIN:PS63	T	115,116,117,3	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>
T5013FIN:PS63	T	122,123,124,4	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>
T5013FIN:PS63	T	129,130,131,5	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>
T5013FIN:PS63	T	136,137,138,6	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>
T5013FIN:PS63	T	143,144,145,7	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>
T5013FIN:PS63	T	150,151,152,8	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>
T5013FIN:PS63	T	157,158,159,9	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>
T5013FIN:PS63	T	164,165,166,1	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>
T5013FIN:PS63	T	171,172,173,11	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>
T5013FIN:PS63	T	178,179,180,12	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>
T5013FIN:PS63	T	185,186,187,13	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>
T5013FIN:PS63	T	192,193,194,14	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>
T5013FIN:PS63	T	199,200,201,15	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>
T5013FIN:PS63	T	206,207,208,16	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>
T5013FIN:PS63	T	213,214,215,17	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>
T5013FIN:PS63	T	220,221,222,18	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>
T5013FIN:PS63	T	227,228,229,19	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>
T5013FIN:PS63	T	234,235,236,20	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>
T5013FIN:PS63	T	241,242,243,21	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>
T5013FIN:PS63	T	248,249,250,22	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails>

T5013FIN:PS63	NTS	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	SV	2	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails><ols63:Schedule63AllocationOfCreditDesignatedProvinceCode>
T5013FIN:PS63	N	15	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails><ols63:Schedule63AllocationAmount>
T5013FIN:PS63	NTE	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	TT	"NL"|97,"PE"|98,"NS"|99,"NB"|100,"ON"|343,"MB"|366,"SK"|389,"AB"|412	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	TT	"NL"|104,"PE"|105,"NS"|106,"NB"|107,"ON"|344,"MB"|367,"SK"|390,"AB"|413	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	TT	"NL"|111,"PE"|112,"NS"|113,"NB"|114,"ON"|345,"MB"|368,"SK"|391,"AB"|414	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	TT	"NL"|118,"PE"|119,"NS"|120,"NB"|121,"ON"|346,"MB"|369,"SK"|392,"AB"|415	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	TT	"NL"|125,"PE"|126,"NS"|127,"NB"|128,"ON"|347,"MB"|370,"SK"|393,"AB"|416	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	TT	"NL"|132,"PE"|133,"NS"|134,"NB"|135,"ON"|348,"MB"|371,"SK"|394,"AB"|417	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	TT	"NL"|139,"PE"|140,"NS"|141,"NB"|142,"ON"|349,"MB"|372,"SK"|395,"AB"|418	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	TT	"NL"|146,"PE"|147,"NS"|148,"NB"|149,"ON"|350,"MB"|373,"SK"|396,"AB"|419	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	TT	"NL"|153,"PE"|154,"NS"|155,"NB"|156,"ON"|351,"MB"|374,"SK"|397,"AB"|420	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	TT	"NL"|160,"PE"|161,"NS"|162,"NB"|163,"ON"|352,"MB"|375,"SK"|398,"AB"|421	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	TT	"NL"|167,"PE"|168,"NS"|169,"NB"|170,"ON"|353,"MB"|376,"SK"|399,"AB"|422	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	TT	"NL"|174,"PE"|175,"NS"|176,"NB"|177,"ON"|354,"MB"|377,"SK"|400,"AB"|423	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	TT	"NL"|181,"PE"|182,"NS"|183,"NB"|184,"ON"|355,"MB"|378,"SK"|401,"AB"|424	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	TT	"NL"|188,"PE"|189,"NS"|190,"NB"|191,"ON"|356,"MB"|379,"SK"|402,"AB"|425	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	TT	"NL"|195,"PE"|196,"NS"|197,"NB"|198,"ON"|357,"MB"|380,"SK"|403,"AB"|426	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	TT	"NL"|202,"PE"|203,"NS"|204,"NB"|205,"ON"|358,"MB"|381,"SK"|404,"AB"|427	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	TT	"NL"|209,"PE"|210,"NS"|211,"NB"|212,"ON"|359,"MB"|382,"SK"|405,"AB"|428	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	TT	"NL"|216,"PE"|217,"NS"|218,"NB"|219,"ON"|360,"MB"|383,"SK"|406,"AB"|429	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	TT	"NL"|223,"PE"|224,"NS"|225,"NB"|226,"ON"|361,"MB"|384,"SK"|407,"AB"|430	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	TT	"NL"|230,"PE"|231,"NS"|232,"NB"|233,"ON"|362,"MB"|385,"SK"|408,"AB"|431	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	TT	"NL"|237,"PE"|238,"NS"|239,"NB"|240,"ON"|363,"MB"|386,"SK"|409,"AB"|432	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	TT	"NL"|244,"PE"|245,"NS"|246,"NB"|247,"ON"|364,"MB"|387,"SK"|410,"AB"|433	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
T5013FIN:PS63	TT	"NL"|251,"PE"|252,"NS"|253,"NB"|254,"ON"|365,"MB"|388,"SK"|411,"AB"|434	<olsbr:OLSBRT5013Data><ols63:T5013Schedule63Data><ols63:Schedule63AllocationOfCreditDetails><ols63:Schedule63AllocationAmountDetails>
//PS65
//This set of tags is for information relating to Schedule 65 Air Quality Improvement Tax Credit. (only applicable to periods between Sept 1, 2021 and Dec 31, 2022)
T5013FIN:PS65	TS	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails>
T5013FIN:PS65	S	175	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails><ols65:Schedule65NameAddress>
T5013FIN:PS65	N	15	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails><ols65:Schedule65QualifyingExpenditures>
T5013FIN:PS65	N	15	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails><ols65:Schedule65AmountAssistance>
T5013FIN:PS65	N	15	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails><ols65:Schedule65TotalQualifyExpendPartnershipCreditPriorFiscal>
T5013FIN:PS65	N	15	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails><ols65:Schedule65TotalQualifyingExpenditures>
T5013FIN:PS65	N	15	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails><ols65:Schedule65TotalPerLocationExpense>
T5013FIN:PS65	N	15	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails><ols65:Schedule65CumulativeQualifyingExpendituresPartnership>
T5013FIN:PS65	TE	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails>
T5013FIN:PS65	T	74,75,76,78,79,82,83	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails>
T5013FIN:PS65	T	84,85,86,88,89,92,93	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails>
T5013FIN:PS65	T	94,95,96,98,99,102,103	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails>
T5013FIN:PS65	T	104,105,106,108,109,112,113	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails>
T5013FIN:PS65	T	114,115,116,118,119,122,123	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails>
T5013FIN:PS65	T	124,125,126,128,129,132,133	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails>
T5013FIN:PS65	T	134,135,136,138,139,142,143	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails>
T5013FIN:PS65	T	144,145,146,148,149,152,153	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails>
T5013FIN:PS65	T	154,155,156,158,159,162,163	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails>
T5013FIN:PS65	T	164,165,166,168,169,172,173	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails>
T5013FIN:PS65	T	174,175,176,178,179,182,183	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails>
T5013FIN:PS65	T	184,185,186,188,189,192,193	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails>
T5013FIN:PS65	T	194,195,196,198,199,202,203	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails>
T5013FIN:PS65	T	204,205,206,208,209,212,213	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails>
T5013FIN:PS65	T	214,215,216,218,219,222,223	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails>
T5013FIN:PS65	T	224,225,226,228,229,232,233	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails>
T5013FIN:PS65	T	234,235,236,238,239,242,243	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails>
T5013FIN:PS65	T	244,245,246,248,249,252,253	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65LocationExpenseDetails>
//Part 2
T5013FIN:PS65	TS	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AgreementBetweenEntitiesDetails>
T5013FIN:PS65	S	175	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AgreementBetweenEntitiesDetails><ols65:Schedule65NameEligibleEntity>
T5013FIN:PS65	S	15	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AgreementBetweenEntitiesDetails><ols65:Schedule65Part2IdentificationNumber>
T5013FIN:PS65	N	9	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AgreementBetweenEntitiesDetails><ols65:Schedule65PercentageAssignedAgreement>
T5013FIN:PS65	TE	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AgreementBetweenEntitiesDetails>
T5013FIN:PS65	T	261,262,263	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AgreementBetweenEntitiesDetails>
T5013FIN:PS65	T	264,265,266	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AgreementBetweenEntitiesDetails>
T5013FIN:PS65	T	267,268,269	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AgreementBetweenEntitiesDetails>
T5013FIN:PS65	T	270,271,272	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AgreementBetweenEntitiesDetails>
T5013FIN:PS65	T	273,274,275	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AgreementBetweenEntitiesDetails>
T5013FIN:PS65	T	276,277,278	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AgreementBetweenEntitiesDetails>
T5013FIN:PS65	T	279,280,281	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AgreementBetweenEntitiesDetails>
T5013FIN:PS65	T	282,283,284	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AgreementBetweenEntitiesDetails>
T5013FIN:PS65	T	285,286,287	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AgreementBetweenEntitiesDetails>
T5013FIN:PS65	T	288,289,290	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AgreementBetweenEntitiesDetails>
T5013FIN:PS65	T	291,292,293	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AgreementBetweenEntitiesDetails>
T5013FIN:PS65	T	294,295,296	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AgreementBetweenEntitiesDetails>
T5013FIN:PS65	T	297,298,299	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AgreementBetweenEntitiesDetails>
//Part 3
T5013FIN:PS65	N	10	15	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65TotalLocationExpenses>
T5013FIN:PS65	N	11	9	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65Percentage>
T5013FIN:PS65	N	13	15	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65TotalVentilationExpensePriorFiscal>
T5013FIN:PS65	N	16	15	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65TotalVentilationExpense>
T5013FIN:PS65	N	17	15	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65CumulativeTotalVentilationExpense>
//Part 4
T5013FIN:PS65	N	18	15	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65Field500>
T5013FIN:PS65	N	19	15	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AirQualityImprovTaxCreditAllocatedPartnerships>
T5013FIN:PS65	N	22	15	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AirQualityImprovTaxCredit>
//Part 5
T5013FIN:PS65	TS	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AllocationOfCreditDetails>
T5013FIN:PS65	S	175	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AllocationOfCreditDetails><ols65:Schedule65NameQualifyingMember>
T5013FIN:PS65	S	15	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AllocationOfCreditDetails><ols65:Schedule65Part5IdentificationNumber>
T5013FIN:PS65	N	9	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AllocationOfCreditDetails><ols65:Schedule65SpecifiedProportionQualifyingMember>
T5013FIN:PS65	N	15	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AllocationOfCreditDetails><ols65:Schedule65AmountAllocated>
T5013FIN:PS65	TE	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AllocationOfCreditDetails>
T5013FIN:PS65	T	24,42,59,300	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AllocationOfCreditDetails>
T5013FIN:PS65	T	25,43,60,301	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AllocationOfCreditDetails>
T5013FIN:PS65	T	26,44,61,302	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AllocationOfCreditDetails>
T5013FIN:PS65	T	27,45,62,303	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AllocationOfCreditDetails>
T5013FIN:PS65	T	28,46,63,304	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AllocationOfCreditDetails>
T5013FIN:PS65	T	29,47,64,305	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AllocationOfCreditDetails>
T5013FIN:PS65	T	30,48,65,306	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AllocationOfCreditDetails>
T5013FIN:PS65	T	31,49,66,307	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AllocationOfCreditDetails>
T5013FIN:PS65	T	32,50,67,308	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AllocationOfCreditDetails>
T5013FIN:PS65	T	33,51,68,309	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AllocationOfCreditDetails>
T5013FIN:PS65	T	34,52,69,310	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AllocationOfCreditDetails>
T5013FIN:PS65	T	35,53,70,311	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AllocationOfCreditDetails>
T5013FIN:PS65	T	36,54,71,312	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AllocationOfCreditDetails>
T5013FIN:PS65	T	37,55,72,313	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AllocationOfCreditDetails>
T5013FIN:PS65	T	38,56,73,314	<olsbr:OLSBRT5013Data><ols65:T5013Schedule65Data><ols65:Schedule65AllocationOfCreditDetails>
//PS 75
//Part 1
T5013FIN:PS75	TS	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75CalculationDetails>
T5013FIN:PS75	S	13	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75CalculationDetails><ols75:CalculationCCAClassNumberText>
T5013FIN:PS75	N	2	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75CalculationDetails><ols75:CalculationPropertyDescriptionCode>
T5013FIN:PS75	S	2	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75CalculationDetails><ols75:CalculationProvince>
T5013FIN:PS75	S	10	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75CalculationDetails><ols75:CalculationAvailableForUseDate>
T5013FIN:PS75	S	175	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75CalculationDetails><ols75:CalculationDesignatedWorkSite>
T5013FIN:PS75	N	15	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75CalculationDetails><ols75:CalculationCapitalCostAmount>
T5013FIN:PS75	N	15	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75CalculationDetails><ols75:CalculationAdjustmentsAmount>
T5013FIN:PS75	N	15	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75CalculationDetails><ols75:CalculationAssistanceRepaidAmount>
T5013FIN:PS75	N	15	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75CalculationDetails><ols75:CalculationEligibleAmount>
T5013FIN:PS75	N	6	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75CalculationDetails><ols75:CalculationSpecifiedPercentage>
T5013FIN:PS75	N	15	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75CalculationDetails><ols75:CalculationITCAmount>
T5013FIN:PS75	B1	1	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75CalculationDetails><ols75:CalculationElecting>
T5013FIN:PS75	TE	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75CalculationDetails>
T5013FIN:PS75	T	4,5,22,23,24,25,26,27,76,77,78,79	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75CalculationDetails>
T5013FIN:PS75	T	6,7,28,29,30,31,32,33,80,81,82,83	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75CalculationDetails>
T5013FIN:PS75	T	8,9,34,35,36,37,38,39,84,85,86,87	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75CalculationDetails>
T5013FIN:PS75	T	10,11,40,41,42,43,44,45,88,89,90,91	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75CalculationDetails>
T5013FIN:PS75	T	12,13,46,47,48,49,50,51,92,93,94,95	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75CalculationDetails>
T5013FIN:PS75	T	14,15,52,53,54,55,56,57,96,97,98,99	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75CalculationDetails>
T5013FIN:PS75	N	185	15	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75CalculationAllocatedAmount>
T5013FIN:PS75	N	186	15	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75CalculationTotalAmount>
//Part 2
T5013FIN:PS75	TS	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationDetails>
T5013FIN:PS75	S	175	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationDetails><ols75:AllocationMemberNameText>
T5013FIN:PS75	S	15	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationDetails><ols75:AllocationAccountNumber>
T5013FIN:PS75	N	6	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationDetails><ols75:AllocationProportionPercentage>
T5013FIN:PS75	N	15	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationDetails><ols75:AllocationAllocatedAmount>
T5013FIN:PS75	TE	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationDetails>
T5013FIN:PS75	T	18,19,20,21	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationDetails>
T5013FIN:PS75	T	58,59,60,61	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationDetails>
T5013FIN:PS75	T	62,63,64,65	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationDetails>
T5013FIN:PS75	T	66,67,68,69	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationDetails>
T5013FIN:PS75	T	70,71,72,73	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationDetails>
//Part 3
T5013FIN:PS75	TS	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75RecaptureDetails>
T5013FIN:PS75	S	13	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75RecaptureDetails><ols75:RecaptureCCAClassNumberText>
T5013FIN:PS75	S	2	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75RecaptureDetails><ols75:RecapturePropertyDescriptionCode>
T5013FIN:PS75	S	2	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75RecaptureDetails><ols75:RecaptureProvince>
T5013FIN:PS75	N	15	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75RecaptureDetails><ols75:RecaptureITCAmount>
T5013FIN:PS75	N	15	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75RecaptureDetails><ols75:RecapturePropertyValueAmount>
T5013FIN:PS75	N	15	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75RecaptureDetails><ols75:RecaptureCapitalCostAmount>
T5013FIN:PS75	N	15	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75RecaptureDetails><ols75:RecaptureCalculationAmount>
T5013FIN:PS75	N	15	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75RecaptureDetails><ols75:RecaptureITCRecapturedAmount>
T5013FIN:PS75	TE	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75RecaptureDetails>
T5013FIN:PS75	T	100,101,114,115,116,117,118,119	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75RecaptureDetails>
T5013FIN:PS75	T	102,103,120,121,122,123,124,125	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75RecaptureDetails>
T5013FIN:PS75	T	104,105,126,127,128,129,130,131	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75RecaptureDetails>
T5013FIN:PS75	T	106,107,132,133,134,135,136,137	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75RecaptureDetails>
T5013FIN:PS75	T	108,109,138,139,140,141,142,143	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75RecaptureDetails>
T5013FIN:PS75	T	110,111,144,145,146,147,148,149	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75RecaptureDetails>
T5013FIN:PS75	N	168	15	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75RecaptureAllocatedAmount>
T5013FIN:PS75	N	169	15	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75RecaptureTotalAmount>
//Part 4
T5013FIN:PS75	TS	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationRecaptureDetails>
T5013FIN:PS75	S	175	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationRecaptureDetails><ols75:AllocationRecaptureMemberNameText>
T5013FIN:PS75	S	15	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationRecaptureDetails><ols75:AllocationRecaptureAccountNumber>
T5013FIN:PS75	N	6	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationRecaptureDetails><ols75:AllocationRecaptureProportionPercentage>
T5013FIN:PS75	N	15	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationRecaptureDetails><ols75:AllocationRecaptureAllocatedAmount>
T5013FIN:PS75	TE	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationRecaptureDetails>
T5013FIN:PS75	T	74,75,112,113	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationRecaptureDetails>
T5013FIN:PS75	T	150,151,152,153	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationRecaptureDetails>
T5013FIN:PS75	T	154,155,156,157	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationRecaptureDetails>
T5013FIN:PS75	T	158,159,160,161	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationRecaptureDetails>
T5013FIN:PS75	T	162,163,164,165	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationRecaptureDetails>
//Part 5
T5013FIN:PS75	TS	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AttestationElectionDetails>
T5013FIN:PS75	S	175	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AttestationElectionDetails><ols75:AttestationElectionLastName>
T5013FIN:PS75	S	175	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AttestationElectionDetails><ols75:AttestationElectionFirstName>
T5013FIN:PS75	S	175	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AttestationElectionDetails><ols75:AttestationElectionPositionOfficeRank>
T5013FIN:PS75	S	10	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AttestationElectionDetails><ols75:AttestationElectionDate>
T5013FIN:PS75	S	175	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AttestationElectionDetails><ols75:AttestationElectionTelephoneNumber>
T5013FIN:PS75	TE	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AttestationElectionDetails>
T5013FIN:PS75	T	170,171,172,173,174	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AttestationElectionDetails>
//Part 6
T5013FIN:PS75	TS	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75LabourRequirementsDetails>
T5013FIN:PS75	B2	1	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75LabourRequirementsDetails><ols75:ElectedToMeetLabourRequirements>
T5013FIN:PS75	N	13	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75LabourRequirementsDetails><ols75:NumberOfCoveredWorkersPaidBelowWageRequirements>
T5013FIN:PS75	N	13	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75LabourRequirementsDetails><ols75:TotalNumberOfDays>
T5013FIN:PS75	N	15	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75LabourRequirementsDetails><ols75:WageRequirementsAmount>
T5013FIN:PS75	N	13	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75LabourRequirementsDetails><ols75:TotalHoursOfLabourRequiredByApprentices>
T5013FIN:PS75	N	13	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75LabourRequirementsDetails><ols75:TotalHoursOfLabourPerformedByApprentices>
T5013FIN:PS75	N	15	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75LabourRequirementsDetails><ols75:ApprenticeshipRequirementsAmount>
T5013FIN:PS75	N	15	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75LabourRequirementsDetails><ols75:LabourRequirementsAmount>
T5013FIN:PS75	N	15	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75LabourRequirementsDetails><ols75:LabourRequirementsTotalAmount>
T5013FIN:PS75	TE	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75LabourRequirementsDetails>
T5013FIN:PS75	T	16|17,176,177,178,179,180,181,182,183	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75LabourRequirementsDetails>
//Part 7
T5013FIN:PS75	TS	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationOfLabourRequirementsDetails>
T5013FIN:PS75	S	175	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationOfLabourRequirementsDetails><ols75:AllocationOfLabourRequirementsMemberNameText>
T5013FIN:PS75	S	15	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationOfLabourRequirementsDetails><ols75:AllocationOfLabourRequirementsAccountNumber>
T5013FIN:PS75	N	6	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationOfLabourRequirementsDetails><ols75:AllocationOfLabourRequirementsProportionPercentage>
T5013FIN:PS75	N	15	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationOfLabourRequirementsDetails><ols75:AllocationOfLabourRequirementsAllocatedAmount>
T5013FIN:PS75	TE	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationOfLabourRequirementsDetails>
T5013FIN:PS75	T	166,167,175,188	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationOfLabourRequirementsDetails>
T5013FIN:PS75	T	189,190,191,192	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationOfLabourRequirementsDetails>
T5013FIN:PS75	T	193,194,195,196	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationOfLabourRequirementsDetails>
T5013FIN:PS75	T	197,198,199,200	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationOfLabourRequirementsDetails>
T5013FIN:PS75	T	201,202,203,204	<olsbr:OLSBRT5013Data><ols75:T5013Schedule75Data><ols75:Schedule75AllocationOfLabourRequirementsDetails>
//PS78
//Part 1
T5013FIN:PS78	S	4	10	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78NRCANProjectCode>
T5013FIN:PS78	S	6	10	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78FirstDayCommercialOperationsDate>
T5013FIN:PS78	B	7,5	1	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78CRDReportFilled>
T5013FIN:PS78	S	8	10	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78CRDProducedDisclosedDate>
T5013FIN:PS78	TS	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails>
T5013FIN:PS78	S	2	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails><ols78:ExpenditureCCAClassNumberText>
T5013FIN:PS78	S	2	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails><ols78:ExpenditureDescriptionCode>
T5013FIN:PS78	B	1	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails><ols78:ExpenditureDualUseEquipement>
T5013FIN:PS78	S	175	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails><ols78:ExpenditureProvinceAndWorkSite>
T5013FIN:PS78	N	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails><ols78:ExpenditureCurrentYearAmount>
T5013FIN:PS78	N	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails><ols78:ExpenditureAdjustmentsAmount>
T5013FIN:PS78	N	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails><ols78:ExpenditureAssistanceRepaidAmount>
T5013FIN:PS78	N	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails><ols78:ExpenditureEligibleExpenditureAmount>
T5013FIN:PS78	N	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails><ols78:ExpenditureQualifiedExpenditureFormulaAmount>
T5013FIN:PS78	N	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails><ols78:ExpenditureQualifiedCCUSExpenditureAmount>
T5013FIN:PS78	N	6	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails><ols78:ExpenditureSpecifiedPercentage>
T5013FIN:PS78	N	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails><ols78:ExpenditureITCCurrentYearAmount>
T5013FIN:PS78	B	1	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails><ols78:ExpenditureElecting>
T5013FIN:PS78	TE	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails>
T5013FIN:PS78	T	9,10,11,13,14,15,16,17,18,19,20,21,22	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails>
T5013FIN:PS78	T	23,24,25,27,28,29,30,31,32,33,34,35,36	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails>
T5013FIN:PS78	T	37,38,39,41,42,43,44,45,46,47,48,49,50	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails>
T5013FIN:PS78	T	51,52,53,55,56,57,58,59,60,61,62,63,64	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails>
T5013FIN:PS78	T	65,66,67,69,70,71,72,73,74,75,76,77,78	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails>
T5013FIN:PS78	T	79,80,81,83,84,85,86,87,88,89,90,91,92	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails>
T5013FIN:PS78	T	93,94,95,97,98,99,100,101,102,103,104,105,106	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails>
T5013FIN:PS78	T	107,108,109,111,112,113,114,115,116,117,118,119,120	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails>
T5013FIN:PS78	T	121,122,123,125,126,127,128,129,130,131,132,133,134	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails>
T5013FIN:PS78	T	135,136,137,139,140,141,142,143,144,145,146,147,149	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ExpenditureDetails>
T5013FIN:PS78	N	149	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78CummulativeCurrentFiscalYearAmount>
T5013FIN:PS78	N	150	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78CummulativePreviousFiscalYearAmount>
T5013FIN:PS78	N	151	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78CurrentFiscalYearAmount>
T5013FIN:PS78	N	152	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78RefurbishmentTaxCreditAmount>
T5013FIN:PS78	N	153	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ITCAllocatedFromPartnershipAmount>
T5013FIN:PS78	N	154	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ITCAmount>
//Part 2
T5013FIN:PS78	TS	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationDetails>
T5013FIN:PS78	S	175	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationDetails><ols78:AllocationMemberNameText>
T5013FIN:PS78	S	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationDetails><ols78:AllocationAccountNumber>
T5013FIN:PS78	N	6	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationDetails><ols78:AllocationProportionPercentage>
T5013FIN:PS78	N	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationDetails><ols78:AllocationAllocatedAmount>
T5013FIN:PS78	TE	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationDetails>
T5013FIN:PS78	T	12,26,40,54	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationDetails>
T5013FIN:PS78	T	68,82,96,110	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationDetails>
T5013FIN:PS78	T	124,138,254,255	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationDetails>
T5013FIN:PS78	T	256,257,258,259	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationDetails>
T5013FIN:PS78	T	260,261,262,263	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationDetails>
//Part 3
T5013FIN:PS78	TS	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AttestationElectionDetails>
T5013FIN:PS78	S	175	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AttestationElectionDetails><ols78:AttestationElectionLastName>
T5013FIN:PS78	S	175	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AttestationElectionDetails><ols78:AttestationElectionFirstName>
T5013FIN:PS78	S	175	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AttestationElectionDetails><ols78:AttestationElectionPositionOfficeRank>
T5013FIN:PS78	S	10	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AttestationElectionDetails><ols78:AttestationElectionDate>
T5013FIN:PS78	S	175	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AttestationElectionDetails><ols78:AttestationElectionTelephoneNumber>
T5013FIN:PS78	TE	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AttestationElectionDetails>
T5013FIN:PS78	T	155,156,157,158,159	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AttestationElectionDetails>
//Part 4
T5013FIN:PS78	TS	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78LabourRequirementsDetails>
T5013FIN:PS78	B2	1	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78LabourRequirementsDetails><ols78:ElectedToMeetLabourRequirements>
T5013FIN:PS78	N	13	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78LabourRequirementsDetails><ols78:NumberOfCoveredWorkersPaidBelowWageRequirements>
T5013FIN:PS78	N	13	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78LabourRequirementsDetails><ols78:TotalNumberOfDays>
T5013FIN:PS78	N	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78LabourRequirementsDetails><ols78:WageRequirementsAmount>
T5013FIN:PS78	N	13	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78LabourRequirementsDetails><ols78:TotalHoursOfLabourRequiredByApprentices>
T5013FIN:PS78	N	13	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78LabourRequirementsDetails><ols78:TotalHoursOfLabourPerformedByApprentices>
T5013FIN:PS78	N	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78LabourRequirementsDetails><ols78:ApprenticeshipRequirementsAmount>
T5013FIN:PS78	N	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78LabourRequirementsDetails><ols78:LabourRequirementsAmount>
T5013FIN:PS78	N	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78LabourRequirementsDetails><ols78:LabourRequirementsTotalAmount>
T5013FIN:PS78	TE	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78LabourRequirementsDetails>
T5013FIN:PS78	T	160|161,162,163,164,165,166,167,168,169	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78LabourRequirementsDetails>
//Part 5
T5013FIN:PS78	TS	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationOfLabourRequirementsDetails>
T5013FIN:PS78	S	175	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationOfLabourRequirementsDetails><ols78:AllocationOfLabourRequirementsMemberNameText>
T5013FIN:PS78	S	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationOfLabourRequirementsDetails><ols78:AllocationOfLabourRequirementsAccountNumber>
T5013FIN:PS78	N	6	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationOfLabourRequirementsDetails><ols78:AllocationOfLabourRequirementsProportionPercentage>
T5013FIN:PS78	N	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationOfLabourRequirementsDetails><ols78:AllocationOfLabourRequirementsAllocatedAmount>
T5013FIN:PS78	TE	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationOfLabourRequirementsDetails>
T5013FIN:PS78	T	264,265,266,267	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationOfLabourRequirementsDetails>
T5013FIN:PS78	T	268,269,270,271	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationOfLabourRequirementsDetails>
T5013FIN:PS78	T	272,273,274,275	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationOfLabourRequirementsDetails>
T5013FIN:PS78	T	276,277,278,279	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationOfLabourRequirementsDetails>
T5013FIN:PS78	T	280,281,282,283	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationOfLabourRequirementsDetails>
//Part 6
T5013FIN:PS78	N	1	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78ProjectPeriod>
T5013FIN:PS78	TS	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxEligibleUseDetails>
T5013FIN:PS78	N	6	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxEligibleUseDetails><ols78:ProjectedEligibleUsePercentage>
T5013FIN:PS78	N	6	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxEligibleUseDetails><ols78:ActualEligibleUsePercentage>
T5013FIN:PS78	TE	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxEligibleUseDetails>
T5013FIN:PS78	T	170,171	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxEligibleUseDetails>
T5013FIN:PS78	T	172,173	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxEligibleUseDetails>
T5013FIN:PS78	T	174,175	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxEligibleUseDetails>
T5013FIN:PS78	T	176,177	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxEligibleUseDetails>
T5013FIN:PS78	T	178,179	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxEligibleUseDetails>
T5013FIN:PS78	T	180,181	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxEligibleUseDetails>
T5013FIN:PS78	N	182	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78RODCummulativePreviousFiscalYearAmount>
T5013FIN:PS78	N	183	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78RODCummulativeCurrentFiscalYearAmount>
T5013FIN:PS78	N	184	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78RODCurrentTaxCreditAmount>
T5013FIN:PS78	N	185	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78DCRCummulativeFiscalYearAmount>
T5013FIN:PS78	N	186	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78DCRAmountDeterminedForLine603>
T5013FIN:PS78	N	187	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78DCRDevelopmentTaxCreditPaidAmount>
T5013FIN:PS78	N	188	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78DCRAmount>
T5013FIN:PS78	N	189	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78RCRRefurbishmentCurrentOrPreviousFiscalPeriod>
T5013FIN:PS78	N	190	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78RCRAmountDeterminedForLine607>
T5013FIN:PS78	N	191	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78RCRRefurbishmentPreviouslyPaid>
T5013FIN:PS78	N	192	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78RCRAmount>
T5013FIN:PS78	TS	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxDetails>
T5013FIN:PS78	S	2	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxDetails><ols78:TaxCCAClassNumberText>
T5013FIN:PS78	S	2	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxDetails><ols78:TaxDescriptionCode>
T5013FIN:PS78	N	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxDetails><ols78:TaxITCAmount>
T5013FIN:PS78	N	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxDetails><ols78:TaxProceedAmount>
T5013FIN:PS78	N	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxDetails><ols78:TaxQualifiedExpenditureAmount>
T5013FIN:PS78	N	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxDetails><ols78:TaxTotalField616F>
T5013FIN:PS78	N	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxDetails><ols78:TaxRecoveryAmount>
T5013FIN:PS78	N	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxDetails><ols78:TaxTotalField618H>
T5013FIN:PS78	TE	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxDetails>
T5013FIN:PS78	T	193,194,195,196,197,198,199,200	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxDetails>
T5013FIN:PS78	T	201,202,203,204,205,206,207,208	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxDetails>
T5013FIN:PS78	T	209,210,211,212,213,214,215,216	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxDetails>
T5013FIN:PS78	T	217,218,219,220,221,222,223,224	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxDetails>
T5013FIN:PS78	T	225,226,227,228,229,230,231,232	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxDetails>
T5013FIN:PS78	T	233,234,235,236,237,238,239,240	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxDetails>
T5013FIN:PS78	T	241,242,243,244,245,246,247,248	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxDetails>
T5013FIN:PS78	N	249	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78DevelopmentPropertyDispositionAmount>
T5013FIN:PS78	N	250	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78RefurbishmentPropertyDispositionAmount>
T5013FIN:PS78	N	251	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxAllocatedFromPartnershipsAmount>
T5013FIN:PS78	N	252	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78TaxPayableTotalAmount>
//Part 7
T5013FIN:PS78	TS	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationOfPartXII7Details>
T5013FIN:PS78	S	175	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationOfPartXII7Details><ols78:AllocationOfPartXII7MemberNameText>
T5013FIN:PS78	S	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationOfPartXII7Details><ols78:AllocationOfPartXII7AccountNumber>
T5013FIN:PS78	N	6	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationOfPartXII7Details><ols78:AllocationOfPartXII7ProportionPercentage>
T5013FIN:PS78	N	15	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationOfPartXII7Details><ols78:AllocationOfPartXII7AllocatedAmount>
T5013FIN:PS78	TE	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationOfPartXII7Details>
T5013FIN:PS78	T	284,285,286,287	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationOfPartXII7Details>
T5013FIN:PS78	T	288,289,290,291	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationOfPartXII7Details>
T5013FIN:PS78	T	292,293,294,295	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationOfPartXII7Details>
T5013FIN:PS78	T	296,297,298,299	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationOfPartXII7Details>
T5013FIN:PS78	T	300,301,302,303	<olsbr:OLSBRT5013Data><ols78:T5013Schedule78Data><ols78:Schedule78AllocationOfPartXII7Details>
//PS100
T5013FIN:PS100	B	185,211	1	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:NilIndicator>
//Assets
T5013FIN:PS100	TS	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	S	4	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts><ccms:FieldCode>
T5013FIN:PS100	N	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts><ccms:FieldAmount>
T5013FIN:PS100	TE	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	5,6	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	7,8	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	9,10	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	11,12	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	13,14	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	15,16	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	17,18	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	19,20	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	21,22	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	23,24	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	25,26	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	27,28	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	29,30	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	31,32	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	33,34	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	35,36	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	37,38	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	39,40	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	41,42	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	43,44	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	45,46	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	47,48	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	49,50	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	51,52	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	53,54	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	55,56	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	57,58	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	59,60	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	61,62	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	63,64	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	65,66	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	67,68	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	69,70	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	71,72	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	73,74	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	75,76	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
//Liabilities
T5013FIN:PS100	T	78,79	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	80,81	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	82,83	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	84,85	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	86,87	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	88,89	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	90,91	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	92,93	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	94,95	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	96,97	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	98,99	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	100,101	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	102,103	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	104,105	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	106,107	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	108,109	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	110,111	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	112,113	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	114,115	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	116,117	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	118,119	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	120,121	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	122,123	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	124,125	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	126,127	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	128,129	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	130,131	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	132,133	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	134,135	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	136,137	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	138,139	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	140,141	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	142,143	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	144,145	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	146,147	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
T5013FIN:PS100	T	148,149	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>
// Fixed codes
T5013FIN:PS100	N	77	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	2599
T5013FIN:PS100	N	150	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3499
T5013FIN:PS100	N	212	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3540
T5013FIN:PS100	N	213	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3541
T5013FIN:PS100	N	214	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3542
T5013FIN:PS100	N	215	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3543
T5013FIN:PS100	N	216	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3570
T5013FIN:PS100	N	217	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3580
T5013FIN:PS100	N	218	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3545
T5013FIN:PS100	N	219	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3546
T5013FIN:PS100	N	220	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3547
T5013FIN:PS100	N	221	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3548
T5013FIN:PS100	N	222	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3550
T5013FIN:PS100	N	223	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3551
T5013FIN:PS100	N	224	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3552
T5013FIN:PS100	N	225	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3553
T5013FIN:PS100	N	226	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3554
//T5013FIN:PS100	N	227	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3560
T5013FIN:PS100	N	228	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3561
T5013FIN:PS100	N	229	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3562
T5013FIN:PS100	N	230	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3563
T5013FIN:PS100	N	231	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3564
T5013FIN:PS100	N	232	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3571
T5013FIN:PS100	N	184	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3580
T5013FIN:PS100	N	186	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3560
T5013FIN:PS100	N	187	15	<olsbr:OLSBRT5013Data><ols100:T5013Schedule100Data><ols100:Schedule100LineAmounts>	P:FieldCodeAmountRule	3575
//PS 125
T5013FIN:PS125	B	350,351	1	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:NilIndicator>
T5013FIN:PS125	S	5	175	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:OperatingNameText>
T5013FIN:PS125	S	6	60	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:OperationDescriptionText>
T5013FIN:PS125	S	304	2	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:SequenceNumber>
//Non-farming revenue
T5013FIN:PS125	TS	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	S	4	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts><ccms:FieldCode>
T5013FIN:PS125	N	15	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts><ccms:FieldAmount>
T5013FIN:PS125	TE	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	7,8	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	9,10	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	11,12	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	13,14	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	15,16	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	17,18	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	19,20	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	21,22	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	23,24	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	25,26	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	27,28	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	29,30	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	31,32	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	33,34	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	35,36	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	37,38	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	39,40	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	41,42	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	43,44	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	45,46	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	47,48	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	49,50	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	51,52	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	53,54	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	55,56	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	57,58	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	59,60	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	61,62	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	63,64	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	65,66	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
//Non-farming expenses Cost of sales
T5013FIN:PS125	T	68,69	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	70,71	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	72,73	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	74,75	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	76,77	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	78,79	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	80,81	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	82,83	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	84,85	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	86,87	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	88,89	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	90,91	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	92,93	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	94,95	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	96,97	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	98,99	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	100,101	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	102,103	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	104,105	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	106,107	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	108,109	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	110,111	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	112,113	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	114,115	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	116,117	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	118,119	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	120,121	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	122,123	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	124,125	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
//Non-farming expenses Operation expenses
T5013FIN:PS125	T	128,129	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	130,131	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	132,133	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	134,135	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	136,137	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	138,139	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	140,141	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	142,143	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	144,145	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	146,147	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	148,149	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	150,151	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	152,153	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	154,155	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	156,157	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	158,159	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	160,161	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	162,163	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	164,165	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	166,167	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	168,169	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	170,171	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	172,173	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	174,175	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	176,177	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	178,179	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	180,181	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	182,183	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
//Farming revenue
T5013FIN:PS125	T	189,190	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	191,192	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	193,194	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	195,196	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	197,198	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	199,200	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	201,202	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	203,204	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	206,207	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	208,209	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	210,211	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	212,213	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	214,215	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	216,217	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	218,219	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	220,221	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	222,223	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	224,225	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	226,227	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	228,229	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	230,231	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
//Farming expenses
T5013FIN:PS125	T	232,233	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	234,235	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	236,237	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	238,239	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	240,241	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	242,243	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	244,245	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	246,247	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	248,249	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	250,251	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	252,253	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	254,255	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	256,257	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	258,259	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	260,261	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	262,263	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	264,265	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	266,267	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	268,269	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	270,271	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	272,273	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
//Extraordinary items
T5013FIN:PS125	T	277,278	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	279,280	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	281,282	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	283,284	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	285,286	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	287,288	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	289,290	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	291,292	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	293,294	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	295,296	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
T5013FIN:PS125	T	297,298	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>
// Fixed codes
T5013FIN:PS125	N	67	15	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>	P:FieldCodeAmountRule	8299
T5013FIN:PS125	N	127	15	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>	P:FieldCodeAmountRule	8518
T5013FIN:PS125	N	185	15	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>	P:FieldCodeAmountRule	9367
T5013FIN:PS125	N	187	15	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>	P:FieldCodeAmountRule	9368
T5013FIN:PS125	N	188	15	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>	P:FieldCodeAmountRule	9369
T5013FIN:PS125	N	205	15	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>	P:FieldCodeAmountRule	9659
T5013FIN:PS125	N	275	15	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>	P:FieldCodeAmountRule	9898
T5013FIN:PS125	N	352	15	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>	P:FieldCodeAmountRule	9899
T5013FIN:PS125	N	353	15	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>	P:FieldCodeAmountRule	9970
T5013FIN:PS125	N	276	15	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>	P:FieldCodeAmountRule	9899
T5013FIN:PS125	N	334	15	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>	P:FieldCodeAmountRule	7000
T5013FIN:PS125	N	335	15	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>	P:FieldCodeAmountRule	7002
T5013FIN:PS125	N	336	15	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>	P:FieldCodeAmountRule	7004
T5013FIN:PS125	N	337	15	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>	P:FieldCodeAmountRule	7006
T5013FIN:PS125	N	338	15	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>	P:FieldCodeAmountRule	7008
T5013FIN:PS125	N	339	15	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>	P:FieldCodeAmountRule	7010
T5013FIN:PS125	N	340	15	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>	P:FieldCodeAmountRule	7020
T5013FIN:PS125	N	341	15	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>	P:FieldCodeAmountRule	9998
T5013FIN:PS125	N	303	15	<olsbr:OLSBRT5013Data><ols125:T5013Schedule125Data><ols125:Schedule125LineAmounts>	P:FieldCodeAmountRule	9999
//PS130
//Part 1
T5013FIN:PS130	TS	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130ExemptExpensesDetails>
T5013FIN:PS130	S	175	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130ExemptExpensesDetails><ols130:NameOfPSAText>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130ExemptExpensesDetails><ols130:BorrowOrOtherFinancingAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130ExemptExpensesDetails><ols130:InterestAndFinancingExpensesAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130ExemptExpensesDetails><ols130:IncomeAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130ExemptExpensesDetails><ols130:LossAmount>
T5013FIN:PS130	TE	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130ExemptExpensesDetails>
T5013FIN:PS130	T	6,7,8,16,26	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130ExemptExpensesDetails>
T5013FIN:PS130	T	9,10,11,12,27	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130ExemptExpensesDetails>
T5013FIN:PS130	T	13,14,15,17,28	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130ExemptExpensesDetails>
T5013FIN:PS130	T	18,19,20,21,29	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130ExemptExpensesDetails>
T5013FIN:PS130	T	22,23,24,25,30	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130ExemptExpensesDetails>
T5013FIN:PS130	N	31	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130Part1AColumn4TotalAmount>
T5013FIN:PS130	N	32	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130Part1AColumn5TotalAmount>
//Part 1B
T5013FIN:PS130	TS	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InfoOnBorrowingsDetails>
T5013FIN:PS130	SV	2	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InfoOnBorrowingsDetails><ols130:InfoOnBorrowingsRelationshipCode>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InfoOnBorrowingsDetails><ols130:InfoOnBorrowingsBorrowedAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InfoOnBorrowingsDetails><ols130:InfoOnBorrowingsNotionalAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InfoOnBorrowingsDetails><ols130:InfoOnBorrowingsParagraphAVariableAIFEAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InfoOnBorrowingsDetails><ols130:InfoOnBorrowingsParagraphEVariableAIFEAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InfoOnBorrowingsDetails><ols130:InfoOnBorrowingsParagraphAVariableBIFEAmount>
T5013FIN:PS130	TE	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InfoOnBorrowingsDetails>
T5013FIN:PS130	T	"01",33,34,35,36,37	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InfoOnBorrowingsDetails>
T5013FIN:PS130	T	"02",41,44,47,50,38	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InfoOnBorrowingsDetails>
T5013FIN:PS130	T	"03",42,45,48,51,39	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InfoOnBorrowingsDetails>
T5013FIN:PS130	T	"04",43,46,49,52,40	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InfoOnBorrowingsDetails>
T5013FIN:PS130	N	53	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130Part1BTable1Column4TotalAmount>
T5013FIN:PS130	N	54	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130Part1BTable1Column5TotalAmount>
T5013FIN:PS130	N	55	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130Part1BTable1Column6TotalAmount>
T5013FIN:PS130	TS	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InfoOnLoansDetails>
T5013FIN:PS130	SV	2	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InfoOnLoansDetails><ols130:InfoOnLoansRelationshipCode>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InfoOnLoansDetails><ols130:InfoOnLoansLoanAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InfoOnLoansDetails><ols130:InfoOnLoansNotionalAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InfoOnLoansDetails><ols130:InfoOnLoansParagraphDVariableAIFRAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InfoOnLoansDetails><ols130:InfoOnLoansParagraphAVariableBIFRAmount>
T5013FIN:PS130	TE	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InfoOnLoansDetails>
T5013FIN:PS130	T	"01",56,57,58,59	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InfoOnLoansDetails>
T5013FIN:PS130	T	"02",60,63,66,69	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InfoOnLoansDetails>
T5013FIN:PS130	T	"03",61,64,67,70	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InfoOnLoansDetails>
T5013FIN:PS130	T	"04",62,65,68,71	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InfoOnLoansDetails>
T5013FIN:PS130	N	72	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130Part1BTable2Column4TotalAmount>
T5013FIN:PS130	N	73	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130Part1BTable2Column5TotalAmount>
//Part 2
T5013FIN:PS130	TS	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingExpensesDetails>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingExpensesDetails><ols130:InterestPaidOrPayableAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingExpensesDetails><ols130:InterestPaidOrPayableOtherAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingExpensesDetails><ols130:DeductibleUnderAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingExpensesDetails><ols130:CapitalCostAllowanceAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingExpensesDetails><ols130:TerminallossAttributableToIFEAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingExpensesDetails><ols130:InterestPaidOrPayableDeductibleAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingExpensesDetails><ols130:IFELossDeductibleAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingExpensesDetails><ols130:IFECapitalLossReducesAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingExpensesDetails><ols130:IncludedInInterestAndFinancingExpenseAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingExpensesDetails><ols130:ReducesIFEForYearAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingExpensesDetails><ols130:IFELeaseFinancingAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingExpensesDetails><ols130:IFEControlledForeignAffiliateAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingExpensesDetails><ols130:IFEReceivedOrReceivableAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingExpensesDetails><ols130:IFEGainIncludedInIncomeAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingExpensesDetails><ols130:IFETotalAmount>
T5013FIN:PS130	TE	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingExpensesDetails>
T5013FIN:PS130	T	74,75,76,77,78,79,80,81,82,83,84,85,87,88,90	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingExpensesDetails>
//Part 3
T5013FIN:PS130	TS	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130CapitalizedIFEDetails>
T5013FIN:PS130	S	13	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130CapitalizedIFEDetails><ols130:ClassNumberText>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130CapitalizedIFEDetails><ols130:IFEInOpeningUCCAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130CapitalizedIFEDetails><ols130:IFEAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130CapitalizedIFEDetails><ols130:UCCThatIsIFEAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130CapitalizedIFEDetails><ols130:TerminalLossThatIsIFEAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130CapitalizedIFEDetails><ols130:CCAThatIsIFEAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130CapitalizedIFEDetails><ols130:IFEInEndingUCCAmount>
T5013FIN:PS130	TE	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130CapitalizedIFEDetails>
T5013FIN:PS130	T	91,96,101,106,111,116,121	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130CapitalizedIFEDetails>
T5013FIN:PS130	T	92,97,102,107,112,117,122	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130CapitalizedIFEDetails>
T5013FIN:PS130	T	93,98,103,108,113,118,123	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130CapitalizedIFEDetails>
T5013FIN:PS130	T	94,99,104,109,114,119,124	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130CapitalizedIFEDetails>
T5013FIN:PS130	T	95,100,105,110,115,120,125	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130CapitalizedIFEDetails>
T5013FIN:PS130	N	126	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130Part3Column5TotalAmount>
T5013FIN:PS130	N	127	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130Part3Column6TotalAmount>
//Part 4
T5013FIN:PS130	TS	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingRevenuesDetails>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingRevenuesDetails><ols130:InterestReceivedOrReceivableAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingRevenuesDetails><ols130:IncludedInIncomeAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingRevenuesDetails><ols130:FeeOrSimilarAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingRevenuesDetails><ols130:IFRReceivedOrReceivableAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingRevenuesDetails><ols130:IFRGainIncludedInIncomeAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingRevenuesDetails><ols130:IFRLeaseFinancingAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingRevenuesDetails><ols130:IFRControlledForeignAffiliateAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingRevenuesDetails><ols130:PaidOrPayableDeductibleAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingRevenuesDetails><ols130:IFRLossDeductibleAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingRevenuesDetails><ols130:IFRCapitalLossReducesAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingRevenuesDetails><ols130:IncludedInPartnershipIFRAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingRevenuesDetails><ols130:ExemptFromTaxAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingRevenuesDetails><ols130:IFRTotalAmount>
T5013FIN:PS130	TE	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingRevenuesDetails>
T5013FIN:PS130	T	128,129,130,131,132,133,134,136,137,138,139,140,142	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130InterestFinancingRevenuesDetails>
//Part 5
T5013FIN:PS130	TS	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130AllocationMembersDetails>
T5013FIN:PS130	S	175	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130AllocationMembersDetails><ols130:MemberName>
T5013FIN:PS130	S	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130AllocationMembersDetails><ols130:MemberIDNumber>
T5013FIN:PS130	N	6	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130AllocationMembersDetails><ols130:MemberProportionAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130AllocationMembersDetails><ols130:ShareOfVariableAofIFEAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130AllocationMembersDetails><ols130:ShareOfVariableBofIFEAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130AllocationMembersDetails><ols130:ShareOfVariableAofIFRAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130AllocationMembersDetails><ols130:ShareOfVariableBofIFRAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130AllocationMembersDetails><ols130:TerminaLossIFEAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130AllocationMembersDetails><ols130:CapitalCostAllowanceIFEAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130AllocationMembersDetails><ols130:ShareIncomeDerivedFromExemptIFEAmount>
T5013FIN:PS130	N	15	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130AllocationMembersDetails><ols130:ShareLossDerivedFromExemptIFEAmount>
T5013FIN:PS130	TE	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130AllocationMembersDetails>
T5013FIN:PS130	T	151,161,171,181,191,201,211,221,231,241,251	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130AllocationMembersDetails>
T5013FIN:PS130	T	152,162,172,182,192,202,212,222,232,242,252	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130AllocationMembersDetails>
T5013FIN:PS130	T	153,163,173,183,193,203,213,223,233,243,253	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130AllocationMembersDetails>
T5013FIN:PS130	T	154,164,174,184,194,204,214,224,234,244,254	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130AllocationMembersDetails>
T5013FIN:PS130	T	155,165,175,185,195,205,215,225,235,245,255	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130AllocationMembersDetails>
T5013FIN:PS130	T	156,166,176,186,196,206,216,226,236,246,256	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130AllocationMembersDetails>
T5013FIN:PS130	T	157,167,177,187,197,207,217,227,237,247,257	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130AllocationMembersDetails>
T5013FIN:PS130	T	158,168,178,188,198,208,218,228,238,248,258	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130AllocationMembersDetails>
T5013FIN:PS130	T	159,169,179,189,199,209,219,229,239,249,259	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130AllocationMembersDetails>
T5013FIN:PS130	T	160,170,180,190,200,210,220,230,240,250,260	<olsbr:OLSBRT5013Data><ols130:T5013Schedule130Data><ols130:Schedule130AllocationMembersDetails>
//PS140
T5013FIN:PS140	N	4	15	<olsbr:OLSBRT5013Data><ols140:T5013Schedule140Data><ols140:Schedule140LineAmounts>	P:FieldCodeAmountRule	9970
T5013FIN:PS140	N	6	15	<olsbr:OLSBRT5013Data><ols140:T5013Schedule140Data><ols140:Schedule140LineAmounts>	P:FieldCodeAmountRule	9975
T5013FIN:PS140	N	8	15	<olsbr:OLSBRT5013Data><ols140:T5013Schedule140Data><ols140:Schedule140LineAmounts>	P:FieldCodeAmountRule	9976
T5013FIN:PS140	N	10	15	<olsbr:OLSBRT5013Data><ols140:T5013Schedule140Data><ols140:Schedule140LineAmounts>	P:FieldCodeAmountRule	9980
T5013FIN:PS140	N	12	15	<olsbr:OLSBRT5013Data><ols140:T5013Schedule140Data><ols140:Schedule140LineAmounts>	P:FieldCodeAmountRule	9985
T5013FIN:PS140	N	14	15	<olsbr:OLSBRT5013Data><ols140:T5013Schedule140Data><ols140:Schedule140LineAmounts>	P:FieldCodeAmountRule	9990
T5013FIN:PS140	N	16	15	<olsbr:OLSBRT5013Data><ols140:T5013Schedule140Data><ols140:Schedule140LineAmounts>	P:FieldCodeAmountRule	9995
T5013FIN:PS140	N	18	15	<olsbr:OLSBRT5013Data><ols140:T5013Schedule140Data><ols140:Schedule140LineAmounts>	P:FieldCodeAmountRule	9998
T5013FIN:PS140	N	25	15	<olsbr:OLSBRT5013Data><ols140:T5013Schedule140Data><ols140:Schedule140LineAmounts>	P:FieldCodeAmountRule	9999
//PS141
T5013FIN:PS141	B	14,15	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	111
T5013FIN:PS141	B0	6,7	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	095
T5013FIN:PS141	B0	32,33	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	097
T5013FIN:PS141	B	34	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	300
T5013FIN:PS141	B	35	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	301
T5013FIN:PS141	B	36	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	302
T5013FIN:PS141	B	16	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	303
T5013FIN:PS141	B	17	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	304
T5013FIN:PS141	B	40	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	305
T5013FIN:PS141	B0	38,39	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	099
T5013FIN:PS141	B	12,13	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	101
T5013FIN:PS141	B	18,19	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	104
T5013FIN:PS141	B	20,21	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	105
T5013FIN:PS141	B	22,23	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	106
T5013FIN:PS141	B	24,25	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	107
T5013FIN:PS141	B	26,27	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	108
T5013FIN:PS141	B	28,29	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	109
T5013FIN:PS141	B	30,31	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	200
T5013FIN:PS141	N	37	15	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	210
T5013FIN:PS141	N	77	15	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	215
T5013FIN:PS141	N	79	15	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	220
T5013FIN:PS141	N	80	15	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	225
T5013FIN:PS141	N	81	15	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	230
T5013FIN:PS141	N	83	15	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	235
T5013FIN:PS141	N	76	15	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	211
T5013FIN:PS141	N	78	15	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	216
T5013FIN:PS141	N	82	15	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	231
T5013FIN:PS141	N	84	15	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	236
T5013FIN:PS141	B	85,86	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	250
T5013FIN:PS141	B	87,88	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	255
T5013FIN:PS141	B	89,90	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	260
T5013FIN:PS141	B	91,92	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	265
T5013FIN:PS141	B	42,43	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	310
T5013FIN:PS141	B	44,45	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	311
T5013FIN:PS141	B	46,47	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	312
T5013FIN:PS141	B	48,49	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	313
T5013FIN:PS141	B	50,51	1	<olsbr:OLSBRT5013Data><ols141:T5013Schedule141Data><ols141:Schedule141LineAmounts>	P:FieldCodeAmountRule	314