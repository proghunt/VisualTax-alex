T1Info.S[1]=SIN^INFO^3
T1[5]=Birthdate^INFO^9
T1Info.S[2]=Title^INFO^33
T1Info.S[3]=FirstNM^INFO^2
T1Info.S[4]=LastNm^INFO^5
T1Info.S[5]=Apartment^INFO^22
T1Info.S[6]=CareOf^INFO^8
T1Info.S[7]=Street^INFO^6
T1Info.S[49]=po box^INFO^68
T1Info.S[62]=RR^INFO^163
T1Info.S[8]=City^INFO^10
T1Info.S[9]=Province^INFO^14
T1Info.S[10]=Postal^INFO^15
T1Info.S[11]=PhoneArea^INFO^54
T1Info.S[11]=PhoneNo^INFO^55
T1Info.S[35]=workphone^INFO^72
T1Info.B[23]=Gender^INFO^23
T1Info.B[4]=NOA^INFO^49
T1Info.B[10]=MarStatus^INFO^11
T1Info.B[11]=ProvResidence^INFO^1
T1Info.S[12]=ProvSelfEmpl^INFO^21
T1Info.B[1]=EfileIt^INFO^46
T1Info.B[0]=Disabled^INFO^87 
T1Info.B[15]=RepresentClient^INFO^58
T1Info.B[25]=ContactIndicator^INFO^53
T1Info.B[2]=Discounted^INFO^47
T1Info.B[14]=Elections^INFO^43
T1Info.S[21]=SpouseSin^INFO^4
T1Info.S[23]=SpouseFirstName^INFO^20
T1Info[1]=SpouseBirthDate^INFO^59
T1Info.S[36]=FaxArea^INFO^62
T1Info.S[36]=FaxNo^INFO^63
T1Info.S[37]=EMail^INFO^64
T1Info.S[38]=ClientId^INFO^67

T1DependantTable.S[0,0]=DepSin1^DEPEND^7
T1DependantTable.S[0,1]=DepFirstName1^DEPEND^5
T1DependantTable.S[0,2]=DepLastName1^DEPEND^6
T1DependantTable.B[0,1]=DepRelationship1^DEPEND^11
T1DependantTable.B[0,2]=Equiv to spouse^DEPEND^19
T1DependantTable[0,1]=DepBirthDate1^DEPEND^10
T1DependantTable.S[0,4]=Infirmity^DEPEND^12

T1DependantTable.S[1,0]=DepSin2^DEPEND^22
T1DependantTable.S[1,1]=DepFirstName2^DEPEND^20
T1DependantTable.S[1,2]=DepLastName2^DEPEND^21
T1DependantTable.B[1,1]=DepRelationship2^DEPEND^26
T1DependantTable.B[1,2]=Equiv to spouse^DEPEND^34
T1DependantTable[1,1]=DepBirthDate2^DEPEND^25
T1DependantTable.S[1,4]=Infirmity2^DEPEND^27

T1DependantTable.S[2,0]=DepSin3^DEPEND^37
T1DependantTable.S[2,1]=DepFirstName3^DEPEND^35
T1DependantTable.S[2,2]=DepLastName3^DEPEND^36
T1DependantTable.B[2,1]=DepRelationship3^DEPEND^41
T1DependantTable.B[2,2]=Equiv to spouse^DEPEND^49
T1DependantTable[2,1]=DepBirthDate3^DEPEND^40
T1DependantTable.S[2,4]=Infirmity3^DEPEND^42

T1DependantTable.S[3,0]=DepSin4^DEPEND^52
T1DependantTable.S[3,1]=DepFirstName4^DEPEND^50
T1DependantTable.S[3,2]=DepLastName4^DEPEND^51
T1DependantTable.B[3,1]=DepRelationship4^DEPEND^56
T1DependantTable.B[3,2]=Equiv to spouse^DEPEND^64
T1DependantTable[3,1]=DepBirthDate4^DEPEND^55
T1DependantTable.S[3,4]=Infirmity4^DEPEND^57

T1DependantTable.S[4,0]=DepSin4^DEPEND^67
T1DependantTable.S[4,1]=DepFirstName4^DEPEND^65
T1DependantTable.S[4,2]=DepLastName4^DEPEND^66
T1DependantTable.B[4,1]=DepRelationship4^DEPEND^71
T1DependantTable.B[4,2]=Equiv to spouse^DEPEND^79
T1DependantTable[4,1]=DepBirthDate4^DEPEND^70
T1DependantTable.S[4,4]=Infirmity4^DEPEND^72

T1DependantTable.S[5,0]=DepSin4^DEPEND^82
T1DependantTable.S[5,1]=DepFirstName4^DEPEND^80
T1DependantTable.S[5,2]=DepLastName4^DEPEND^81
T1DependantTable.B[5,1]=DepRelationship4^DEPEND^86
T1DependantTable.B[5,2]=Equiv to spouse^DEPEND^94
T1DependantTable[5,1]=DepBirthDate4^DEPEND^85
T1DependantTable.S[5,4]=Infirmity4^DEPEND^87

T1DependantTable.S[6,0]=DepSin4^DEPEND^97
T1DependantTable.S[6,1]=DepFirstName4^DEPEND^95
T1DependantTable.S[6,2]=DepLastName4^DEPEND^96
T1DependantTable.B[6,1]=DepRelationship4^DEPEND^101
T1DependantTable.B[6,2]=Equiv to spouse^DEPEND^109
T1DependantTable[6,1]=DepBirthDate4^DEPEND^100
T1DependantTable.S[6,4]=Infirmity4^DEPEND^102

T1OtherIncome[4]=Gst Rebate^OTHEMPL^5

BeginningCF[1]=RspDedLimit^RRSP^1
T1RRSPDeduction[36]=Rrsp Earned income last yr^RRSP^2
T1RRSPDeduction[13]=Tot HBP withdrawal^RRSP^100 //import only  ??
T1RRSPDeduction[75]=Tot LLP withdrawal^RRSP^99 //import only  ??
T1RRSPDeduction[25]=HBP bal^RRSP^80 //import only  ??
T1RRSPDeduction[77]=LLP bal^RRSP^84 //import only  ??

BeginningCF[2]=UndeductedContr^CFR^31 //Changed to single page
BeginningCF[7]=LtdPartnershipLoss^DIRECT^6
BeginningCF[8]=ListedPersPropLoss^S3^98
BeginningCF[17]=CNIL T936 ExpensesPriorYrs^CFR^29 //Changed to single page
BeginningCF[18]=CNIL T936 IncomePriorYears^CFR^30 //Changed to single page
BeginningCF[26]=fed Tuition^S11^13
BeginningCF[40]=prov Tuition^S11PRV^13
BeginningCF[27]=MovingExpenses^CFR^38		//Changed to single page
BeginningCF[30]=MinTaxCarryOver^CFR^39 		//Changed to single page
BeginningCF[33]=InvTaxCredit^T2038^137 		//Changed to single page
BeginningCF[34]=CEE^T1229^1
BeginningCF[35]=CDE^T1229^2
BeginningCF[36]=COGPE^T1229^3
BeginningCF[38]=ForExplAndDev^T1229^4
BeginningCF[39]=Depletion^T1229^48

// student loan
T1Student[14]=Student loan^STLOAN^15
T1Student[18]=Student loan^STLOAN^19
T1Student[22]=Student loan^STLOAN^23
T1Student[26]=Student loan^STLOAN^27

//Non-Capital Losses
T1NonCapitalLosses[1]=NonCapLoss94^CFR^102	//Changed to single page	
T1NonCapitalLosses[5]=NonCapLoss95^CFR^107	//Changed to single page
T1NonCapitalLosses[8]=NonCapLoss96^CFR^112	//Changed to single page
T1NonCapitalLosses[11]=NonCapLoss97^CFR^117	//Changed to single page
T1NonCapitalLosses[14]=NonCapLoss98^CFR^122	//Changed to single page
T1NonCapitalLosses[17]=NonCapLoss99^CFR^127	//Changed to single page
T1NonCapitalLosses[20]=NonCapLoss2000^CFR^132	//Changed to single page

//Restricted Farm Loss
T1NonCapitalLosses[41]=RestrFarmLoss91^CFR^205	//Changed to single page
T1NonCapitalLosses[45]=RestrFarmLoss92^CFR^210	//Changed to single page
T1NonCapitalLosses[48]=RestrFarmLoss93^CFR^215	//Changed to single page
T1NonCapitalLosses[51]=RestrFarmLoss94^CFR^220	//Changed to single page
T1NonCapitalLosses[54]=RestrFarmLoss95^CFR^225	//Changed to single page
T1NonCapitalLosses[57]=RestrFarmLoss96^CFR^230	//Changed to single page
T1NonCapitalLosses[60]=RestrFarmLoss97^CFR^235	//Changed to single page
T1NonCapitalLosses[63]=RestrFarmLoss98^CFR^240	//Changed to single page
T1NonCapitalLosses[66]=RestrFarmLoss99^CFR^245	//Changed to single page
T1NonCapitalLosses[69]=RestrFarmLoss2000^CFR^250	//Changed to single page

//Farm Loss
T1NonCapitalLosses[91]=FarmLoss91^CFR^146	//Changed to single page
T1NonCapitalLosses[95]=FarmLoss92^CFR^151	//Changed to single page
T1NonCapitalLosses[98]=FarmLoss93^CFR^156	//Changed to single page
T1NonCapitalLosses[101]=FarmLoss94^CFR^161	//Changed to single page
T1NonCapitalLosses[104]=FarmLoss95^CFR^166	//Changed to single page
T1NonCapitalLosses[107]=FarmLoss96^CFR^171	//Changed to single page
T1NonCapitalLosses[110]=FarmLoss97^CFR^176	//Changed to single page
T1NonCapitalLosses[113]=FarmLoss98^CFR^181	//Changed to single page
T1NonCapitalLosses[116]=FarmLoss99^CFR^186	//Changed to single page
T1NonCapitalLosses[119]=FarmLoss2000^CFR^191	//Changed to single page

T1NonCapitalLosses[130]=LimitedPartnLoss^CFR^73

//Net Capital Losses
T1NetCapitalLosses[21]=CapLoss-PreMay23To85^CFR^465	//Changed to single page
T1NetCapitalLosses[22]=CapLoss-May2285ToBefr88^CFR^470	//Changed to single page
T1NetCapitalLosses[23]=CapLoss-88and89^CFR^475		//Changed to single page
T1NetCapitalLosses[24]=CapLoss-90to99^CFR^480		//Changed to single page
T1NetCapitalLosses[34]=CapLoss-2000^CFR^485		//Changed to single page
T1NetCapitalLosses[35]=CapLoss-others^CFR^515		//?? only this one 2006?? and not others?

T1NetCapitalLosses[38]=Incl rate-2000^CFR^410		//Changed to single page
T1NetCapitalLosses[38]=Incl rate-2000^CFR^40		//Changed to single page

T1Donations[20]=Donations96^DON^136
T1Donations[23]=Donations97^DON^141
T1Donations[26]=Donations98^DON^90
T1Donations[29]=Donations99^DON^95
T1Donations[32]=Donations2000^DON^100

T1139.S[0,3]=T1139#1-Bus name^T1139#1^38	//Changed to single page
T1139[0,16]=T1139#1-ReservLYr1^T1139#1^8	//?????? this one and below
T1139[0,4]=T1139#1-AddIncLYr1^T1139#1^10
T1139[0,10]=T1139#1-1995Inc1^T1139#1^12
T1139[0,36]=T1139#1-ReservLYr2^T1139#1^20
T1139[0,21]=T1139#1-AddIncLYr2^T1139#1^22
T1139[0,30]=T1139#1-1995Inc2^T1139#1^24

T1139.S[1,3]=T1139#2-Bus name^T1139#2^38
T1139[1,2]=T1139#2-ReservLYr1^T1139#2^8
T1139[1,4]=T1139#2-AddIncLYr1^T1139#2^10
T1139[1,10]=T1139#2-1995Inc1^T1139#2^12
T1139[1,36]=T1139#2-ReservLYr2^T1139#2^20
T1139[1,24]=T1139#2-AddIncLYr2^T1139#2^22
T1139[1,30]=T1139#2-1995Inc2^T1139#2^24

//slips
T3Table.s[0,0]=T3#1-Name^T3#1^1
T3Table.s[1,0]=T3#2-Name^T3#2^1
T3Table.s[2,0]=T3#3-Name^T3#3^1
T3Table.s[3,0]=T3#4-Name^T3#4^1
T3Table.s[4,0]=T3#5-Name^T3#5^1
T3Table.s[5,0]=T3#6-Name^T3#6^1
T3Table.s[6,0]=T3#7-Name^T3#7^1
T3Table.s[7,0]=T3#8-Name^T3#8^1
T3Table.s[8,0]=T3#9-Name^T3#9^1
T3Table.s[9,0]=T3#10-Name^T3#10^1
T3Table.s[10,0]=T3#11-Name^T3#11^1
T3Table.s[11,0]=T3#12-Name^T3#12^1
T3Table.s[12,0]=T3#13-Name^T3#13^1
T3Table.s[13,0]=T3#14-Name^T3#14^1
T3Table.s[14,0]=T3#15-Name^T3#15^1
T3Table.s[15,0]=T3#16-Name^T3#16^1
T3Table.s[16,0]=T3#17-Name^T3#17^1
T3Table.s[17,0]=T3#18-Name^T3#18^1
T3Table.s[18,0]=T3#19-Name^T3#19^1
T3Table.s[19,0]=T3#20-Name^T3#20^1
//T3Table.s[x,19]=T3#1-Name^T3#y^3

T4Table.s[0,0]=T4#1-Name^T4#1^1
T4Table.s[1,0]=T4#2-Name^T4#2^1
T4Table.s[2,0]=T4#3-Name^T4#3^1
T4Table.s[3,0]=T4#4-Name^T4#4^1
T4Table.s[4,0]=T4#5-Name^T4#5^1
//T4Table.s[x,0]=T4#1-Name^T4#y^1

T4ATable.s[0,0]=T4A#1-Name^T4A#1^15
T4ATable.s[1,0]=T4A#2-Name^T4A#2^15
T4ATable.s[2,0]=T4A#3-Name^T4A#3^15
T4ATable.s[3,0]=T4A#4-Name^T4A#4^15
T4ATable.s[4,0]=T4A#5-Name^T4A#5^15
T4ATable.s[5,0]=T4A#1-Name^T4A#6^15
T4ATable.s[6,0]=T4A#2-Name^T4A#7^15
T4ATable.s[7,0]=T4A#3-Name^T4A#8^15
T4ATable.s[8,0]=T4A#4-Name^T4A#9^15
//T4ATable.s[x,0]=T4A#1-Name^T4A#y^1

T5Table.s[0,0]=T5MULT#1-Name^T5MULT#1^1
T5Table[0,0]=T5MULT#1-%^T5MULT#1^2
T5Table.s[1,0]=T5MULT#1-Name^T5MULT#1^23
T5Table[1,0]=T5MULT#1-%^T5MULT#1^24
T5Table.s[2,0]=T5MULT#1-Name^T5MULT#1^45
T5Table[2,0]=T5MULT#1-%^T5MULT#1^46
T5Table.s[3,0]=T5MULT#1-Name^T5MULT#1^67
T5Table[3,0]=T5MULT#1-%^T5MULT#1^68
T5Table.s[4,0]=T5MULT#1-Name^T5MULT#1^89
T5Table[4,0]=T5MULT#1-%^T5MULT#1^90

T5Table.s[5,0]=T5MULT#2-Name^T5MULT#2^1
T5Table[5,0]=T5MULT#1-%^T5MULT#2^2
T5Table.s[6,0]=T5MULT#2-Name^T5MULT#2^23
T5Table[6,0]=T5MULT#1-%^T5MULT#2^24
T5Table.s[7,0]=T5MULT#2-Name^T5MULT#2^45
T5Table[7,0]=T5MULT#1-%^T5MULT#2^46
T5Table.s[8,0]=T5MULT#2-Name^T5MULT#2^67
T5Table[8,0]=T5MULT#1-%^T5MULT#2^68
T5Table.s[9,0]=T5MULT#2-Name^T5MULT#2^89
T5Table[9,0]=T5MULT#1-%^T5MULT#2^90

T5Table.s[10,0]=T5MULT#2-Name^T5MULT#3^1
T5Table[10,0]=T5MULT#1-%^T5MULT#3^2
T5Table.s[11,0]=T5MULT#2-Name^T5MULT#3^23
T5Table[11,0]=T5MULT#1-%^T5MULT#3^24
T5Table.s[12,0]=T5MULT#2-Name^T5MULT#3^45
T5Table[12,0]=T5MULT#1-%^T5MULT#3^46
T5Table.s[13,0]=T5MULT#2-Name^T5MULT#3^67
T5Table[13,0]=T5MULT#1-%^T5MULT#3^68
T5Table.s[14,0]=T5MULT#2-Name^T5MULT#3^89
T5Table[14,0]=T5MULT#1-%^T5MULT#3^90

T5Table.s[15,0]=T5MULT#2-Name^T5MULT#4^1
T5Table[15,0]=T5MULT#1-%^T5MULT#4^2
T5Table.s[16,0]=T5MULT#2-Name^T5MULT#4^23
T5Table[16,0]=T5MULT#1-%^T5MULT#4^24
T5Table.s[17,0]=T5MULT#2-Name^T5MULT#4^45
T5Table[17,0]=T5MULT#1-%^T5MULT#4^46
T5Table.s[18,0]=T5MULT#2-Name^T5MULT#4^67
T5Table[18,0]=T5MULT#1-%^T5MULT#4^68
T5Table.s[19,0]=T5MULT#2-Name^T5MULT#4^89
T5Table[20,0]=T5MULT#1-%^T5MULT#4^90

T5Table.s[20,0]=T5MULT#2-Name^T5MULT#5^1
T5Table[20,0]=T5MULT#1-%^T5MULT#5^2
T5Table.s[21,0]=T5MULT#2-Name^T5MULT#5^23
T5Table[22,0]=T5MULT#1-%^T5MULT#5^24
T5Table.s[22,0]=T5MULT#2-Name^T5MULT#5^45
T5Table[22,0]=T5MULT#1-%^T5MULT#5^46
T5Table.s[23,0]=T5MULT#2-Name^T5MULT#5^67
T5Table[24,0]=T5MULT#1-%^T5MULT#5^68
T5Table.s[24,0]=T5MULT#2-Name^T5MULT#5^89
T5Table[25,0]=T5MULT#1-%^T5MULT#5^90

T5Table.s[26,0]=T5MULT#2-Name^T5MULT#6^1
T5Table[26,0]=T5MULT#1-%^T5MULT#6^2
T5Table.s[27,0]=T5MULT#2-Name^T5MULT#6^23
T5Table[27,0]=T5MULT#1-%^T5MULT#6^24
T5Table.s[28,0]=T5MULT#2-Name^T5MULT#6^45
T5Table[28,0]=T5MULT#1-%^T5MULT#6^46
T5Table.s[29,0]=T5MULT#2-Name^T5MULT#6^67
T5Table[29,0]=T5MULT#1-%^T5MULT#6^68
T5Table.s[30,0]=T5MULT#2-Name^T5MULT#6^89
T5Table[30,0]=T5MULT#1-%^T5MULT#6^90

// Statements ---------------------------------------------------------------------------

//T2125---------------------------------------------------------------------------
T2125[x,1]=T2125#1-Fiscal1^T2125#y^4		//Changed to single page
T2125[x,2]=T2125#1-Fiscal2^T2125#y^5		//Changed to single page
T2125.S[x,6]=T2125#1-SIC^T2125#y^12		//Changed to single page
T2125.B[x,2]=T2125#1-BusOrComm^T2125#y^73	//Changed to single page
T2125.S[x,3]=T2125#1-Bus name^T2125#y^8		//Changed to single page
T2125.S[x,5]=T2125#1-adress1^T2125#y^10		//Changed to single page
T2125.S[x,7]=T2125#1-City^T2125#y^13		//Changed to single page
T2125.S[x,8]=T2125#1-postal^T2125#y^14		//Changed to single page
T2125.S[x,4]=T2125#1-main Product^T2125#y^9	//Changed to single page
T2125.S[x,9]=T2125#1-partnership id^T2125#y^15	//Changed to single page
T2125.S[x,11]=T2125#1-taxShelterNo^T2125#y^16	//Changed to single page
T2125.S[x,12]=T2125#1-BusNum^T2125#y^19		//Changed to single page
T2125Owners[x,0,0]=T2125#1-Percent^T2125#y^18	//Changed to single page
T2125[x,12]=T2125#1-GrossInc^T2125#y^23		//Changed to single page

T2125Client[x,37]=T2125#1-CFHomeUseCF^T2125#y^231	//Changed to single page
T2125CEC[x,1]=T2125#1-CFCEC^T2125#y^642			//Changed to single page

T2125Owners.S[x,2,0]=T2125#1-Partn1FirstNm^T2125#y^258	//Changed to single page
T2125Owners.S[x,2,1]=T2125#1-Partn1LastNm^T2125#y^248	//Changed to single page
//T2125Owners.S[x,2,2]=T2125#1-Partn1Sin^T2125#y^000	//vt field does not exist?
T2125Owners.S[x,2,3]=T2125#1-Partn1Adress1^T2125#y^245	//Changed to single page

T2125Owners.S[x,3,0]=T2125#1-Partn2FirstNm^T2125#y^259	//Changed to single page
T2125Owners.S[x,3,1]=T2125#1-Partn2LastNm^T2125#y^264	//Changed to single page
//T2125Owners.S[x,3,2]=T2125#1-Partn2Sin^T2125#y^000	//vt field does not exist?
T2125Owners.S[x,3,3]=T2125#1-Partn2dress1^T2125#y^263	//Changed to single page

T2125Owners.S[x,4,0]=T2125#1-Partn3FirstNm^T2125#y^260	//Changed to single page
T2125Owners.S[x,4,1]=T2125#1-Partn3LastNm^T2125#y^267	//Changed to single page
//T2125Owners.S[x,4,2]=T2125#1-Partn3Sin^T2125#y^000	//vt field does not exist?
T2125Owners.S[x,4,3]=T2125#1-Partn3dress1^T2125#y^266	//Changed to single page

T2125Owners.S[x,5,0]=T2125#1-Partn4FirstNm^T2125#y^261	//Changed to single page
T2125Owners.S[x,5,1]=T2125#1-Partn4LastNm^T2125#y^270	//Changed to single page
//T2125Owners.S[x,5,2]=T2125#1-Partn4Sin^T2125#y^71	//vt field does not exist?
T2125Owners.S[x,5,3]=T2125#1-Partn4dress1^T2125#y^269	//Changed to single page

T2125Owners[x,1,0]=T2125#1-SpousePercent^T2125#y^238	//Changed to single page
T2125Owners[x,2,0]=T2125#1-Partn1Percent^T2125#y^241	//Changed to single page
T2125Owners[x,3,0]=T2125#1-Partn2Percent^T2125#y^244	//Changed to single page
T2125Owners[x,4,0]=T2125#1-Partn3Percent^T2125#y^247	//Changed to single page
T2125Owners[x,5,0]=T2125#1-Partn4Percent^T2125#y^250	//Changed to single page

//T2121 ---------------------------------------------------------------------------
T2121[x,1]=T2121#1-Fiscal1^T2121#y^4		//Changed to single page
T2121[x,2]=T2121#1-Fiscal2^T2121#y^5		//Changed to single page
T2121.S[x,6]=T2121#1-SIC^T2121#y^11		//Changed to single page
T2121.S[x,3]=T2121#1-Boat name^T2121#y^8	//Changed to single page
T2121.S[x,13]=T2121#1-adress1^T212#y^61		//Changed to single page
//T2121.S[x,14]=T2121#1-City^T2121#y^13		//Changed to single page
T2121.S[x,15]=T2121#1-postal^T2121#y^75		//Changed to single page
//T2121.S[x,16]=T2121#1-Province^T2121#y^14????????????
T2121.S[x,4]=T2121#1-main Product^T2121#y^9	//Changed to single page
T2121.S[x,10]=T2121#1-Account Num^T2121#y^15	//Changed to single page
T2121.S[x,11]=T2121#1-taxShelterNo^T2121#y^14 	//Changed to single page
T2121.S[x,12]=T2121#1-BusNum1^T2121#y^12	//Changed to single page
T2121Owners[x,0,0]=T2121#1-Percent^T2121#y^18	//Changed to single page
T2121[x,17]=T2121#1-GrossInc^T2121#y^20		//Changed to single page

T2121Client[x,37]=T2121#1-CFHomeUse^T2121#y^128	//Changed to single page
T2121CEC[x,1]=T2121#1-CF CEC^T2121#y^523	//Changed to single page

T2121Owners.S[x,2,0]=T2121#1-Partn1FirstNm^T2121#y^258	//Changed to single page
T2121Owners.S[x,2,1]=T2121#1-Partn1LastNm^T2121#y^248	//Changed to single page
//T2121Owners.S[x,2,2]=T2121#1-Partn1Sin^T2121#y^40	//vt field does not exist
T2121Owners.S[x,2,3]=T2121#1-Partn1Adress1^T2121#y^245	//Changed to single page

T2121Owners.S[x,3,0]=T2121#1-Partn2FirstNm^T2121#y^259	//Changed to single page
T2121Owners.S[x,3,1]=T2121#1-Partn2LastNm^T2121#y^264	//Changed to single page
//T2121Owners.S[x,3,2]=T2121#1-Partn2Sin^T2121#y^42	
T2121Owners.S[x,3,3]=T2121#1-Partn2dress1^T2121#y^263	//Changed to single page

T2121Owners.S[x,4,0]=T2121#1-Partn3FirstNm^T2121#y^260	//Changed to single page
T2121Owners.S[x,4,1]=T2121#1-Partn3LastNm^T2121#y^267	//Changed to single page
//T2121Owners.S[x,4,2]=T2121#1-Partn3Sin^T2121#y^44	
T2121Owners.S[x,4,3]=T2121#1-Partn3dress1^T2121#y^266	//Changed to single page

T2121Owners.S[x,5,0]=T2121#1-Partn4FirstNm^T2121#y^261	//Changed to single page
T2121Owners.S[x,5,1]=T2121#1-Partn4LastNm^T2121#y^270	//Changed to single page
//T2121Owners.S[x,5,2]=T2121#1-Partn4Sin^T2121#y^46	
T2121Owners.S[x,5,3]=T2121#1-Partn4dress1^T2121#y^269	//Changed to single page

T2121Owners[x,1,0]=T2121#1-SpousePercent^T2121#y^238	//Changed to single page
T2121Owners[x,2,0]=T2121#1-Partn1Percent^T2121#y^241	//Changed to single page
T2121Owners[x,3,0]=T2121#1-Partn2Percent^T2121#y^244	//Changed to single page
T2121Owners[x,4,0]=T2121#1-Partn3Percent^T2121#y^247	//Changed to single page
T2121Owners[x,5,0]=T2121#1-Partn4Percent^T2121#y^250	//Changed to single page

//T2042 --------------------------------------------------------------------------
T2042[x,1]=T2042#1-Fiscal1^T2042#y^4		//Changed to single page
T2042[x,2]=T2042#1-Fiscal2^T2042#y^5		//Changed to single page
T2042.S[x,8]=T2042#1-SIC^T2042#y^17		//Changed to single page
T2042.S[x,3]=T2042#1-farm name^T2042#y^8	//Changed to single page
T2042.S[x,4]=T2042#1-adress1^T2042#y^10		//Changed to single page
T2042.S[x,5]=T2042#1-City^T2042#y^12		//Changed to single page
T2042.S[x,6]=T2042#1-postal^T2042#y^13		//Changed to single page
//T2042[x,3]=T2042#1-Acres owned^T204#y^000	//vt field does not exist?
//T2042[x,4]=T2042#1-Acres farmed^T2042#y^000	//vt field does not exist?
T2042.S[x,12]=T2042#1-partnership id^T2042#y^18	//Changed to single page
T2042.S[x,13]=T2042#1-taxShelterNo^T2042#y^20	//Changed to single page
T2042.S[x,14]=T2042#1-BusNum1^T2042#y^21	//Changed to single page
T2042Owners[x,0,0]=T2042#1-Percent^T2042#y^24	//Changed to single page
T2042[x,43]=T2042#1-GrossInc^T2042#y^26		//??

T2042Client[x,37]=T2042#1-CFHomeUseCF^T2042#y^632	//Changed to single page
T2042CEC[x,1]=T2042#1-CFCEC^T2042#y^549		//Changed to single page

T2042Owners.S[x,2,0]=T2042#1-Partn1FirstNm^T2042#y^644	//Changed to single page
T2042Owners.S[x,2,1]=T2042#1-Partn1LastNm^T2042#y^666	//Changed to single page
//T2042Owners.S[x,2,2]=T2042#1-Partn1Sin^T2042#y^000	//vt field does not exist?
T2042Owners.S[x,2,3]=T2042#1-Partn1Adress1^T2042#y^647	//Changed to single page

T2042Owners.S[x,3,0]=T2042#1-Partn2FirstNm^T2042#y^648	//Changed to single page
T2042Owners.S[x,3,1]=T2042#1-Partn2LastNm^T2042#y^668	//Changed to single page
//T2042Owners.S[x,3,2]=T2042#1-Partn2Sin^T2042#y^000	//vt field does not exist?
T2042Owners.S[x,3,3]=T2042#1-Partn2dress1^T2042#y^651	//Changed to single page

T2042Owners.S[x,4,0]=T2042#1-Partn3FirstNm^T2042#y^652	//Changed to single page
T2042Owners.S[x,4,1]=T2042#1-Partn3LastNm^T2042#y^670	//Changed to single page
//T2042Owners.S[x,4,2]=T2042#1-Partn3Sin^T2042#y^71	//vt field does not exist?
T2042Owners.S[x,4,3]=T2042#1-Partn3dress1^T2042#y^655	//Changed to single page

T2042Owners.S[x,5,0]=T2042#1-Partn4FirstNm^T2042#y^656	//Changed to single page
T2042Owners.S[x,5,1]=T2042#1-Partn4LastNm^T2042#y^672	//Changed to single page
//T2042Owners.S[x,5,2]=T2042#1-Partn4Sin^T2042#y^000	//vt field does not exist?
T2042Owners.S[x,5,3]=T2042#1-Partn4dress1^T2042#y^659	//Changed to single page

T2042Owners.S[x,6,0]=T2042#1-Partn4FirstNm^T2042#y^660	//Changed to single page
T2042Owners.S[x,6,1]=T2042#1-Partn4LastNm^T2042#y^674	//Changed to single page
//T2042Owners.S[x,6,2]=T2042#1-Partn4Sin^T2042#y^000	//vt field does not exist?
T2042Owners.S[x,6,3]=T2042#1-Partn4dress1^T2042#y^663	//Changed to single page

T2042Owners[x,1,0]=T2042#1-SpousePercent^T2042#y^642	//Changed to single page
T2042Owners[x,2,0]=T2042#1-Partn1Percent^T2042#y^646	//Changed to single page
T2042Owners[x,3,0]=T2042#1-Partn2Percent^T2042#y^650	//Changed to single page
T2042Owners[x,4,0]=T2042#1-Partn3Percent^T2042#y^654	//Changed to single page
T2042Owners[x,5,0]=T2042#1-Partn4Percent^T2042#y^658	//Changed to single page
T2042Owners[x,6,0]=T2042#1-Partn4Percent^T2042#y^662	//Changed to single page

//T776 ---------------------------------------------------------------------------
T776[x,1]=T776#1-from date^T776#y^3		//Changed to single page
T776[x,2]=T776#1-to date^T776#y^6		//Changed to single page
T776.S[x,6]=T776#1-partnershId^T776#y^11	//Changed to single page
T776.S[x,7]=T776#1-tax sh no^T776#y^13		//Changed to single page
T776.S[x,8]=T776#1-bus no^T776#y^15		//Changed to single page
T776Owners[x,0,0]=T776#1-percent^T776#y^18	//Changed to single page
T776[x,31]=T776#1-Income^T776#y^47		//Changed to single page

T776IncomeTable.S[x,0,0]=T776#1-str^T776#y^45		//Changed to single page
T776IncomeTable.S[x,0,1]=T776#1-city^T776#y^45		//Changed to single page
T776IncomeTable.S[x,0,2]=T776#1-Prov^T776#y^45		//Changed to single page
T776IncomeTable.S[x,0,3]=T776#1-postal^T776#y^45	//Changed to single page
T776IncomeTable[x,0,0]=T776#1-Units^T776#y^46		//Changed to single page

T776IncomeTable.S[x,1,0]=T776#1-str^T776#y^48		//Changed to single page
T776IncomeTable.S[x,1,1]=T776#1-city^T776#y^48		//Changed to single page
T776IncomeTable.S[x,1,2]=T776#1-Prov^T776#y^48		//Changed to single page
T776IncomeTable.S[x,1,3]=T776#1-postal^T776#y^48	//Changed to single page
T776IncomeTable[x,1,0]=T776#1-Units^T776#y^49		//Changed to single page

T776IncomeTable.S[x,2,0]=T776#1-str^T776#y^51		//Changed to single page
T776IncomeTable.S[x,2,1]=T776#1-city^T776#y^51		//Changed to single page
T776IncomeTable.S[x,2,2]=T776#1-Prov^T776#y^51		//Changed to single page
T776IncomeTable.S[x,2,3]=T776#1-postal^T776#y^51	//Changed to single page
T776IncomeTable[x,2,0]=T776#1-Units^T776#y^52		//Changed to single page

T776Owners[x,1,0]=T776#1-sp percent^T776#y^24		//Changed to single page

T776Owners.S[x,2,0]=T776#1-prtn1 f-name^T776#y^25	//Changed to single page
T776Owners.S[x,2,1]=T776#1-prtn1 l-name^T776#y^26	//Changed to single page
//T776Owners.S[x,2,2]=T776#1-prtn1 sin^T776#y^120	//vt field does not exist?
T776Owners.S[x,2,3]=T776#1-prtn1 addr^T776#y^121	//Changed to single page
T776Owners[x,2,0]=T776#1-prtnr1 percent^T776#y^28	//Changed to single page

T776Owners.S[x,3,0]=T776#1-prtn2 f-name^T776#y^29	//Changed to single page
T776Owners.S[x,3,1]=T776#1-prtn2 l-name^T776#y^30	//Changed to single page
//T776Owners.S[x,3,2]=T776#1-prtn2 sin^T776#y^122	//vt field does not exist?	
T776Owners.S[x,3,3]=T776#1-prtn2 addr^T776#y^123	//Changed to single page
T776Owners[x,3,1]=T776#1-prtnr2 percent^T776#y^32	//Changed to single page

T776Owners.S[x,4,0]=T776#1-prtn3 f-name^T776#y^33	//Changed to single page
T776Owners.S[x,4,1]=T776#1-prtn3 l-name^T776#y^34	//Changed to single page
//T776Owners.S[x,4,2]=T776#1-prtn3 sin^T776#y^124	//vt field does not exist?
T776Owners.S[x,4,3]=T776#1-prtn3 addr^T776#y^125	//Changed to single page
T776Owners[x,4,0]=T776#1-prtnr3 percent^T776#y^36	//Changed to single page

T776Owners.S[x,5,0]=T776#1-prtn4 f-name^T776#y^37	//Changed to single page
T776Owners.S[x,5,1]=T776#1-prtn4 l-name^T776#y^38	//Changed to single page
//T776Owners.S[x,5,2]=T776#1-prtn4 sin^T776#y^126	//vt field does not exist?
T776Owners.S[x,5,3]=T776#1-prtn4 addr^T776#y^127	//Changed to single page
T776Owners[x,5,0]=T776#1-prtnr4 percent^T776#y^40	//Changed to single page

T776Owners.S[x,6,0]=T776#1-prtn5 f-name^T776#y^41	//Changed to single page
T776Owners.S[x,6,2]=T776#1-prtn5 l-name^T776#y^42	//Changed to single page
T776Owners.S[x,6,1]=T776#1-prtn5 addr^T776#y^129	//Changed to single page
//T776Owners.S[x,6,3]=T776#1-prtn5 sin^T776#y^128	//vt field does not exist?
T776Owners[x,6,0]=T776#1-prtnr5 percent^T776#y^44	//Changed to single page

//T1163 ---------------------------------------------------------------------------
T1163.S[13]=NISA No^T1163#1^20		//Changed to single page

//T1164 ---------------------------------------------------------------------------
T1164.S[0,1]=Farm name^T1163#1^201	//Changed to single page
T1164.S[0,3]=address^T1163#1^203	//Changed to single page
T1164.S[0,29]=City^T1163#1^204		//Changed to single page
T1164.S[0,30]=Province^T1163#1^205	//Changed to single page
T1164.S[0,23]=Postal^T1163#1^206	//Changed to single page
//T1164.S[0,2]=Bus no^T1163#1^210	//??
T1164Owners[0,0,0]=Percent^T1163#1^210	//Changed to single page

//T1163 owners ---------------------------------------------------------------------------
T1164Owners.S[0,1,0]=Partner1-FN^T1163#1^630	//Changed to single page
T1164Owners.S[0,1,1]=Partner1-LN^T1163#1^631	//Changed to single page
T1164Owners[0,1,0]=Partner1-Percent^T1163#1^632	//Changed to single page
T1164Owners.S[0,1,2]=Partner1-SIN^T1163#1^634	//Changed to single page

T1164Owners.S[0,2,0]=Partner2-FN^T1163#1^35	//Changed to single page
T1164Owners.S[0,2,1]=Partner2-LN^T1163#1^36	//Changed to single page
T1164Owners[0,2,0]=Partner2-Percent^T1163#1^37	//Changed to single page
T1164Owners.S[0,2,2]=Partner2-SIN^T1163#1^39	//Changed to single page

T1164Owners.S[0,3,0]=Partner3-FN^T1163#1^40	//Changed to single page
T1164Owners.S[0,3,1]=Partner3-LN^T1163#1^41	//Changed to single page
T1164Owners[0,3,0]=Partner3-Percent^T1163#1^42	//Changed to single page
T1164Owners.S[0,3,2]=Partner3-SIN^T1163#1^44	//Changed to single page

T1164Owners.S[0,4,0]=Partner4-FN^T1163#1^45	//Changed to single page
T1164Owners.S[0,4,1]=Partner4-LN^T1163#1^46	//Changed to single page
T1164Owners[0,4,0]=Partner4-Percent^T1163#1^47	//Changed to single page
T1164Owners.S[0,4,2]=Partner4-SIN^T1163#1^49	//Changed to single page

T1164Owners.S[0,5,0]=Partner5-FN^T1163#1^50	//Changed to single page
T1164Owners.S[0,5,1]=Partner5-LN^T1163#1^51	//Changed to single page
T1164Owners[0,5,0]=Partner5-Percent^T1163#1^52	//Changed to single page
T1164Owners.S[0,5,2]=Partner5-SIN^T1163#1^54	//Changed to single page

//T1273 ---------------------------------------------------------------------------
T1163.S[0,13]=NISANo PIN^T1273#1^20	//Changed to single page
T1164.S[0,24]=NISANo IndCode^T1273#1^34	//Changed to single page

//only for T1273 below
T1163.S[0,20]=District nm^T1273#1^27	//Changed to single page

//T1163.S[0,2]=distr no^T1273#1^28 //automatic
//T1163.S[0,15]=Quarter^T1273#1^29
//T1163.S[0,4]=section^T1273#1^30
//T1163.S[0,5]=District^T1273#1^31
//T1163.S[0,6]=Range^T1273#1^37
//T1163.S[0,16]=Range^T1273#1^38

T1164.S[0,1]=Farm name^T1273#1^201	//Changed to single page
T1164.S[0,3]=address^T1273#1^204	//Changed to single page
T1164.S[0,29]=City^T1273#1^205		//Changed to single page
//T1164.S[0,30]=Province^T1273#1^5
T1164.S[0,23]=Postal^T1273#1^206	//Changed to single page
//T1164.S[0,2]=Bus no^T1163#1^10

//T1273 owners ---------------------------------------------------------------------------
T1164Owners[0,0,0]=Percent^T1273#1^210		//Changed to single page
T1164Owners[0,1,0]=Partner1-Percent^T1273#1^632	//Changed to single page

T1164Owners.S[0,2,0]=Partner2-FN^T1273#1^635	//Changed to single page
T1164Owners.S[0,2,1]=Partner2-LN^T1273#1^636	//Changed to single page
T1164Owners[0,2,0]=Partner2-Percent^T1273#1^637	//Changed to single page
//T1164Owners.S[0,2,2]=Partner2-SIN^T1273#1^639	

T1164Owners.S[0,3,0]=Partner3-FN^T1273#1^640	//Changed to single page
T1164Owners.S[0,3,1]=Partner3-LN^T1273#1^641	//Changed to single page
T1164Owners[0,3,0]=Partner3-Percent^T1273#1^642	//Changed to single page
//T1164Owners.S[0,3,2]=Partner3-SIN^T1273#1^644	

T1164Owners.S[0,4,0]=Partner4-FN^T1273#1^645	//Changed to single page
T1164Owners.S[0,4,1]=Partner4-LN^T1273#1^646	//Changed to single page
T1164Owners[0,4,0]=Partner4-Percent^T1273#1^647	//Changed to single page
//T1164Owners.S[0,4,2]=Partner4-SIN^T1273#1^649

T1164Owners.S[0,5,0]=Partner5-FN^T1273#1^650	//Changed to single page
T1164Owners.S[0,5,1]=Partner5-LN^T1273#1^651	//Changed to single page
T1164Owners[0,5,0]=Partner5-Percent^T1273#1^652	//Changed to single page
//T1164Owners.S[0,5,2]=Partner5-SIN^T1273#1^654


//cca ----------- table or class - either one works
//2125
T2125CCATable[x,0,0]=T2125#1-class1^T2125#y^301		//Changed to single page
T2125CCATable[x,0,2]=T2125#1-UCC1Start^T2125#y^302	//Changed to single page
T2125CCATable[x,1,0]=T2125#1-class2^T2125#y^311		//Changed to single page
T2125CCATable[x,1,2]=T2125#1-UCC2^T2125#y^312		//Changed to single page
T2125CCATable[x,2,0]=T2125#1-class3^T2125#y^321		//Changed to single page
T2125CCATable[x,2,2]=T2125#1-UCC3^T2125#y^322		//Changed to single page
T2125CCATable[x,3,0]=T2125#1-class4^T2125#y^331		//Changed to single page
T2125CCATable[x,3,2]=T2125#1-UCC4^T2125#y^332		//Changed to single page
T2125CCATable[x,4,0]=T2125#1-class5^T2125#y^341		//Changed to single page
T2125CCATable[x,4,2]=T2125#1-UCC5^T2125#y^342		//Changed to single page
T2125CCATable[x,5,0]=T2125#1-class5^T2125#y^351		//Changed to single page
T2125CCATable[x,5,2]=T2125#1-UCC5^T2125#y^352		//Changed to single page
T2125CCATable[x,6,0]=T2125#1-class5^T2125#y^361		//Changed to single page
T2125CCATable[x,6,2]=T2125#1-UCC5^T2125#y^362		//Changed to single page
T2125CCATable[x,7,0]=T2125#1-class5^T2125#y^371		//Changed to single page
T2125CCATable[x,7,2]=T2125#1-UCC5^T2125#y^372		//Changed to single page

T2121CCATable[x,0,0]=T2121#1-class1^T2121#y^137		//Changed to single page
T2121CCATable[x,0,2]=T2121#1-UCC1^T2121#y^138		//Changed to single page
T2121CCATable[x,1,0]=T2121#1-class2^T2121#y^147		//Changed to single page
T2121CCATable[x,1,2]=T2121#1-UCC2^T2121#y^148		//Changed to single page
T2121CCATable[x,2,0]=T2121#1-class3^T2121#y^157		//Changed to single page
T2121CCATable[x,2,2]=T2121#1-UCC3^T2121#y^158		//Changed to single page
T2121CCATable[x,3,0]=T2121#1-class4^T2121#y^167		//Changed to single page
T2121CCATable[x,3,2]=T2121#1-UCC4^T2121#y^168		//Changed to single page
T2121CCATable[x,4,0]=T2121#1-class5^T2121#y^177		//Changed to single page
T2121CCATable[x,4,2]=T2121#1-UCC5^T2121#y^178		//Changed to single page
T2121CCATable[x,5,0]=T2121#1-class5^T2121#y^187		//Changed to single page
T2121CCATable[x,5,2]=T2121#1-UCC5^T2121#y^188		//Changed to single page
T2121CCATable[x,6,0]=T2121#1-class5^T2121#y^197		//Changed to single page
T2121CCATable[x,6,2]=T2121#1-UCC5^T2121#y^198		//Changed to single page
T2121CCATable[x,7,0]=T2121#1-class5^T2121#y^207		//Changed to single page
T2121CCATable[x,7,2]=T2121#1-UCC5^T2121#y^208		//Changed to single page

T2042CCATable[x,0,0]=T2042#1-class1^T2042#y^401	//Changed to single page
T2042CCATable[x,0,2]=T2042#1-UCC1^T2042#y^402	//Changed to single page
T2042CCATable[x,1,0]=T2042#1-class2^T2042#y^411	//Changed to single page
T2042CCATable[x,1,2]=T2042#1-UCC2^T2042#y^412	//Changed to single page
T2042CCATable[x,2,0]=T2042#1-class3^T2042#y^421	//Changed to single page
T2042CCATable[x,2,2]=T2042#1-UCC3^T2042#y^422	//Changed to single page
T2042CCATable[x,3,0]=T2042#1-class4^T2042#y^431	//Changed to single page
T2042CCATable[x,3,2]=T2042#1-UCC4^T2042#y^432	//Changed to single page
T2042CCATable[x,4,0]=T2042#1-class5^T2042#y^441	//Changed to single page
T2042CCATable[x,4,2]=T2042#1-UCC5^T2042#y^442	//Changed to single page
T2042CCATable[x,5,0]=T2042#1-class5^T2042#y^451	//Changed to single page
T2042CCATable[x,5,2]=T2042#1-UCC5^T2042#y^452	//Changed to single page
T2042CCATable[x,6,0]=T2042#1-class5^T2042#y^461	//Changed to single page
T2042CCATable[x,6,2]=T2042#1-UCC5^T2042#y^462	//Changed to single page
T2042CCATable[x,7,0]=T2042#1-class5^T2042#y^471	//Changed to single page
T2042CCATable[x,7,2]=T2042#1-UCC5^T2042#y^472	//Changed to single page

//t776 cls nd cca
T776CCATable[x,0,0]=T776#1-Class^T776#y^201	//Changed to single page
T776CCATable[x,1,0]=T776#1-Class^T776#y^210	//Changed to single page
T776CCATable[x,2,0]=T776#1-Class^T776#y^219	//Changed to single page
T776CCATable[x,3,0]=T776#1-Class^T776#y^228	//Changed to single page
T776CCATable[x,4,0]=T776#1-Class^T776#y^237	//Changed to single page
T776CCATable[x,5,0]=T776#1-Class^T776#y^246	//Changed to single page
T776CCATable[x,6,0]=T776#1-Class^T776#y^255	//Changed to single page
T776CCATable[x,0,2]=T776#1-UCC^T776#y^202	//Changed to single page
T776CCATable[x,1,2]=T776#1-UCC^T776#y^211	//Changed to single page
T776CCATable[x,2,2]=T776#1-UCC^T776#y^220	//Changed to single page
T776CCATable[x,3,2]=T776#1-UCC^T776#y^229	//Changed to single page
T776CCATable[x,4,2]=T776#1-UCC^T776#y^238	//Changed to single page
T776CCATable[x,5,2]=T776#1-UCC^T776#y^247	//Changed to single page
T776CCATable[x,6,2]=T776#1-UCC^T776#y^256	//Changed to single page


//nisa cca
//T1273 cca 
T1164CCATable[0,0,0]=T1175#1-class1^T1175H#1^1	//Changed to single page
T1164CCATable[0,0,2]=T1175#1-UCC1^T1175H#1^2	//Changed to single page
T1164CCATable[0,1,0]=T1175#1-class2^T1175H#y^11	//Changed to single page
T1164CCATable[0,1,2]=T1175#1-UCC2^T1175H#1^12	//Changed to single page
T1164CCATable[0,2,0]=T1175#1-class3^T1175H#1^21	//Changed to single page
T1164CCATable[0,2,2]=T1175#1-UCC3^T1175H#1^22	//Changed to single page
T1164CCATable[0,3,0]=T1175#1-class4^T1175H#1^31	//Changed to single page
T1164CCATable[0,3,2]=T1175#1-UCC4^T1175H#1^32	//Changed to single page
T1164CCATable[0,4,0]=T1175#1-class5^T1175H#1^41	//Changed to single page
T1164CCATable[0,4,2]=T1175#1-UCC5^T1175H#1^42	//Changed to single page
T1164CCATable[0,5,0]=T1175#1-class5^T1175H#1^51	//Changed to single page
T1164CCATable[0,5,2]=T1175#1-UCC5^T1175H#1^52	//Changed to single page
T1164CCATable[0,6,0]=T1175#1-class5^T1175H#1^61	//Changed to single page
T1164CCATable[0,6,2]=T1175#1-UCC5^T1175H#1^62	//Changed to single page
T1164CCATable[0,7,0]=T1175#1-class5^T1175H#1^71	//Changed to single page
T1164CCATable[0,7,2]=T1175#1-UCC5^T1175H#1^72	//Changed to single page
//T1163 cca 
T1164CCATable[0,0,0]=T1175#1-class1^T1175#1^1	//Changed to single page
T1164CCATable[0,0,2]=T1175#1-UCC1^T1175#1^2	//Changed to single page
T1164CCATable[0,1,0]=T1175#1-class2^T1175#y^11	//Changed to single page
T1164CCATable[0,1,2]=T1175#1-UCC2^T1175#1^12	//Changed to single page
T1164CCATable[0,2,0]=T1175#1-class3^T1175#1^21	//Changed to single page
T1164CCATable[0,2,2]=T1175#1-UCC3^T1175#1^22	//Changed to single page
T1164CCATable[0,3,0]=T1175#1-class4^T1175#1^31	//Changed to single page
T1164CCATable[0,3,2]=T1175#1-UCC4^T1175#1^32	//Changed to single page
T1164CCATable[0,4,0]=T1175#1-class5^T1175#1^41	//Changed to single page
T1164CCATable[0,4,2]=T1175#1-UCC5^T1175#1^42	//Changed to single page
T1164CCATable[0,5,0]=T1175#1-class5^T1175#1^51	//Changed to single page
T1164CCATable[0,5,2]=T1175#1-UCC5^T1175#1^52	//Changed to single page
T1164CCATable[0,6,0]=T1175#1-class5^T1175#1^61	//Changed to single page
T1164CCATable[0,6,2]=T1175#1-UCC5^T1175#1^62	//Changed to single page
T1164CCATable[0,7,0]=T1175#1-class5^T1175#1^71	//Changed to single page
T1164CCATable[0,7,2]=T1175#1-UCC5^T1175#1^72	//Changed to single page

//end cca

//5 Year Summary
//Income
T1TaxSummary[1,1]=101 Employment Income^YRSUM^009
T1TaxSummary[2,1]=101 Employment Income^YRSUM^010
T1TaxSummary[3,1]=101 Employment Income^YRSUM^011
T1TaxSummary[4,1]=101 Employment Income^YRSUM^012

T1TaxSummary[1,2]=113 OAS^YRSUM^024
T1TaxSummary[2,2]=113 OAS^YRSUM^025
T1TaxSummary[3,2]=113 OAS^YRSUM^026
T1TaxSummary[4,2]=113 OAS^YRSUM^027

T1TaxSummary[1,3]=114 Canada or Quebec Pension^YRSUM^029
T1TaxSummary[2,3]=114 Canada or Quebec Pension^YRSUM^030
T1TaxSummary[3,3]=114 Canada or Quebec Pension^YRSUM^031
T1TaxSummary[4,3]=114 Canada or Quebec Pension^YRSUM^032

T1TaxSummary[1,4]=115 Other pensions^YRSUM^039
T1TaxSummary[2,4]=115 Other pensions^YRSUM^040
T1TaxSummary[3,4]=115 Other pensions^YRSUM^041
T1TaxSummary[4,4]=115 Other pensions^YRSUM^042

T1TaxSummary[1,150]=116 Split Pension income^YRSUM^229

T1TaxSummary[1,140]=117 Universal Child Care Benifit^YRSUM^219
T1TaxSummary[2,140]=117 Universal Child Care Benifit^YRSUM^220

T1TaxSummary[1,5]=119 UI benefits^YRSUM^044
T1TaxSummary[2,5]=119 UI benefits^YRSUM^045
T1TaxSummary[3,5]=119 UI benefits^YRSUM^046
T1TaxSummary[4,5]=119 UI benefits^YRSUM^047

T1TaxSummary[1,6]=120 Taxable dividends^YRSUM^049
T1TaxSummary[2,6]=120 Taxable dividends^YRSUM^050
T1TaxSummary[3,6]=120 Taxable dividends^YRSUM^051
T1TaxSummary[4,6]=120 Taxable dividends^YRSUM^052

T1TaxSummary[1,7]=121 Interest^YRSUM^054
T1TaxSummary[2,7]=121 Interest^YRSUM^055
T1TaxSummary[3,7]=121 Interest^YRSUM^056
T1TaxSummary[4,7]=121 Interest^YRSUM^057

T1TaxSummary[1,8]=122 Partnership Income^YRSUM^059
T1TaxSummary[2,8]=122 Partnership Income^YRSUM^060
T1TaxSummary[3,8]=122 Partnership Income^YRSUM^061
T1TaxSummary[4,8]=122 Partnership Income^YRSUM^062

T1TaxSummary[1,9]=126 Rental income - Net^YRSUM^064
T1TaxSummary[2,9]=126 Rental income - Net^YRSUM^065
T1TaxSummary[3,9]=126 Rental income - Net^YRSUM^066
T1TaxSummary[4,9]=126 Rental income - Net^YRSUM^067

T1TaxSummary[1,10]=127 Taxable capital gains^YRSUM^069
T1TaxSummary[2,10]=127 Taxable capital gains^YRSUM^070
T1TaxSummary[3,10]=127 Taxable capital gains^YRSUM^071
T1TaxSummary[4,10]=127 Taxable capital gains^YRSUM^072

T1TaxSummary[1,11]=128 Alimony/separation income^YRSUM^074
T1TaxSummary[2,11]=128 Alimony/separation income^YRSUM^075
T1TaxSummary[3,11]=128 Alimony/separation income^YRSUM^076
T1TaxSummary[4,11]=128 Alimony/separation income^YRSUM^077

T1TaxSummary[1,12]=129 RRSP income^YRSUM^079
T1TaxSummary[2,12]=129 RRSP income^YRSUM^080
T1TaxSummary[3,12]=129 RRSP income^YRSUM^081
T1TaxSummary[4,12]=129 RRSP income^YRSUM^082

T1TaxSummary[1,13]=130 Other income^YRSUM^084
T1TaxSummary[2,13]=130 Other income^YRSUM^085
T1TaxSummary[3,13]=130 Other income^YRSUM^086
T1TaxSummary[4,13]=130 Other income^YRSUM^087

T1TaxSummary[1,14]=135 Business income^YRSUM^089
T1TaxSummary[2,14]=135 Business income^YRSUM^090
T1TaxSummary[3,14]=135 Business income^YRSUM^091
T1TaxSummary[4,14]=135 Business income^YRSUM^092

T1TaxSummary[1,16]=150 Total Income^YRSUM^129
T1TaxSummary[2,16]=150 Total Income^YRSUM^130
T1TaxSummary[3,16]=150 Total Income^YRSUM^131
T1TaxSummary[4,16]=150 Total Income^YRSUM^132

//NET INCOME
//T1[102]=206 Pension adjustment^YRSUM^134

T1TaxSummary[1,20]=207 RPP  contributions^YRSUM^139
T1TaxSummary[2,20]=207 RPP  contributions^YRSUM^140
T1TaxSummary[3,20]=207 RPP  contributions^YRSUM^141
T1TaxSummary[4,20]=207 RPP  contributions^YRSUM^142

T1TaxSummary[1,21]=208 RRSP contributions^YRSUM^144
T1TaxSummary[2,21]=208 RRSP contributions^YRSUM^145
T1TaxSummary[3,21]=208 RRSP contributions^YRSUM^146
T1TaxSummary[4,21]=208 RRSP contributions^YRSUM^147

//T1[105]=209 Sask Pension Plan^YRSUM^149

T1TaxSummary[1,151]=210 Deduction Pension Split^YRSUM^234
T1TaxSummary[2,151]=210 Deduction Pension Split^YRSUM^235
T1TaxSummary[3,151]=210 Deduction Pension Split^YRSUM^236
T1TaxSummary[4,151]=210 Deduction Pension Split^YRSUM^237

T1TaxSummary[1,22]=212 Union, professional dues^YRSUM^154
T1TaxSummary[2,22]=212 Union, professional dues^YRSUM^155
T1TaxSummary[3,22]=212 Union, professional dues^YRSUM^156
T1TaxSummary[4,22]=212 Union, professional dues^YRSUM^157

T1TaxSummary[1,153]=213 UCCB Repayment^YRSUM^239
T1TaxSummary[2,153]=213 UCCB Repayment^YRSUM^240
T1TaxSummary[3,153]=213 UCCB Repayment^YRSUM^241
T1TaxSummary[4,153]=213 UCCB Repayment^YRSUM^242

T1TaxSummary[1,23]=214 Child care expenses^YRSUM^159
T1TaxSummary[2,23]=214 Child care expenses^YRSUM^160
T1TaxSummary[3,23]=214 Child care expenses^YRSUM^161
T1TaxSummary[4,23]=214 Child care expenses^YRSUM^162

T1TaxSummary[1,17]=215 disability support^YRSUM^164
T1TaxSummary[2,17]=215 disability support^YRSUM^165
T1TaxSummary[3,17]=215 disability support^YRSUM^166
T1TaxSummary[4,17]=215 disability support^YRSUM^167

T1TaxSummary[1,24]=217 Business investment losses^YRSUM^169
T1TaxSummary[2,24]=217 Business investment losses^YRSUM^170
T1TaxSummary[3,24]=217 Business investment losses^YRSUM^171
T1TaxSummary[4,24]=217 Business investment losses^YRSUM^172

T1TaxSummary[1,25]=219 Moving expenses^YRSUM^174
T1TaxSummary[2,25]=219 Moving expenses^YRSUM^175
T1TaxSummary[3,25]=219 Moving expenses^YRSUM^176
T1TaxSummary[4,25]=219 Moving expenses^YRSUM^177

T1TaxSummary[1,26]=220 Alimony^YRSUM^179
T1TaxSummary[2,26]=220 Alimony^YRSUM^180
T1TaxSummary[3,26]=220 Alimony^YRSUM^181
T1TaxSummary[4,26]=220 Alimony^YRSUM^182

T1TaxSummary[1,27]=221 Carrying charges^YRSUM^184
T1TaxSummary[2,27]=221 Carrying charges^YRSUM^185
T1TaxSummary[3,27]=221 Carrying charges^YRSUM^186
T1TaxSummary[4,27]=221 Carrying charges^YRSUM^187

T1TaxSummary[1,18]=224 Expl-dev^YRSUM^189
T1TaxSummary[2,18]=224 Expl-dev^YRSUM^190
T1TaxSummary[3,18]=224 Expl-dev^YRSUM^191
T1TaxSummary[4,18]=224 Expl-dev^YRSUM^192

T1TaxSummary[1,28]=229 Other employment expenses^YRSUM^194
T1TaxSummary[2,28]=229 Other employment expenses^YRSUM^195
T1TaxSummary[3,28]=229 Other employment expenses^YRSUM^196
T1TaxSummary[4,28]=229 Other employment expenses^YRSUM^197

T1TaxSummary[1,29]=235 Social Benefits repayment^YRSUM^204
T1TaxSummary[2,29]=235 Social Benefits repayment^YRSUM^205
T1TaxSummary[3,29]=235 Social Benefits repayment^YRSUM^206
T1TaxSummary[4,29]=235 Social Benefits repayment^YRSUM^207

T1TaxSummary[1,30]=232 Other deductions^YRSUM^199
T1TaxSummary[2,30]=232 Other deductions^YRSUM^200
T1TaxSummary[3,30]=232 Other deductions^YRSUM^201
T1TaxSummary[4,30]=232 Other deductions^YRSUM^202

T1TaxSummary[1,31]=236 Net Income^YRSUM^209
T1TaxSummary[2,31]=236 Net Income^YRSUM^210
T1TaxSummary[3,31]=236 Net Income^YRSUM^211
T1TaxSummary[4,31]=236 Net Income^YRSUM^212

//TAXABLE INCOME
//T1[123]=248 Employee home reloc. loan^YRSUM^014
T1TaxSummary[1,19]=248 Empl hom rel^YRSUM^314
T1TaxSummary[2,19]=248 Empl hom rel^YRSUM^315
T1TaxSummary[3,19]=248 Empl hom rel^YRSUM^316
T1TaxSummary[4,19]=248 Empl hom rel^YRSUM^317

//T1[124]=249 Stock and shares deduction^YRSUM^319
T1TaxSummary[1,41]=249 Stock and shares deduction^YRSUM^319
T1TaxSummary[2,41]=249 Stock and shares deduction^YRSUM^320
T1TaxSummary[3,41]=249 Stock and shares deduction^YRSUM^321
T1TaxSummary[4,41]=249 Stock and shares deduction^YRSUM^322


//T1[125]=250 Other payments deduction^YRSUM^324
T1TaxSummary[1,42]=250 Other payments deduction^YRSUM^324
T1TaxSummary[2,42]=250 Other payments deduction^YRSUM^325
T1TaxSummary[3,42]=250 Other payments deduction^YRSUM^326
T1TaxSummary[4,42]=250 Other payments deduction^YRSUM^327

//T1[126]=251 Losses of other years^YRSUM^329
T1TaxSummary[1,43]=251 Losses of other years^YRSUM^329
T1TaxSummary[2,43]=251 Losses of other years^YRSUM^330
T1TaxSummary[3,43]=251 Losses of other years^YRSUM^331
T1TaxSummary[4,43]=251 Losses of other years^YRSUM^332

//T1TaxSummary[1,43]=252 Non-cap losses of other yrs^YRSUM^334
//T1TaxSummary[1,43]=253 Net Cap losses of other yrs^YRSUM^339

T1TaxSummary[1,44]=254 Capital gains deduction^YRSUM^344
T1TaxSummary[2,44]=254 Capital gains deduction^YRSUM^345
T1TaxSummary[3,44]=254 Capital gains deduction^YRSUM^346
T1TaxSummary[4,44]=254 Capital gains deduction^YRSUM^347

//T1[130]=255 Northern residents ded.^YRSUM^349
T1TaxSummary[1,45]=255 Northern residents ded.^YRSUM^349
T1TaxSummary[2,45]=255 Northern residents ded.^YRSUM^350
T1TaxSummary[3,45]=255 Northern residents ded.^YRSUM^351
T1TaxSummary[4,45]=255 Northern residents ded.^YRSUM^352

T1TaxSummary[1,46]=256 Additional deductions^YRSUM^354
T1TaxSummary[2,46]=256 Additional deductions^YRSUM^355
T1TaxSummary[3,46]=256 Additional deductions^YRSUM^356
T1TaxSummary[4,46]=256 Additional deductions^YRSUM^357

T1TaxSummary[1,47]=260 Taxable Income^YRSUM^359
T1TaxSummary[2,47]=260 Taxable Income^YRSUM^360
T1TaxSummary[3,47]=260 Taxable Income^YRSUM^361
T1TaxSummary[4,47]=260 Taxable Income^YRSUM^362

//NONREFUNDABLE TAX CREDITS
T1TaxSummary[1,60]=300 Basic personal amount^YRSUM^364
T1TaxSummary[2,60]=300 Basic personal amount^YRSUM^365
T1TaxSummary[3,60]=300 Basic personal amount^YRSUM^366
T1TaxSummary[4,60]=300 Basic personal amount^YRSUM^367

T1TaxSummary[1,61]=301 Age amount^YRSUM^369
T1TaxSummary[2,61]=301 Age amount^YRSUM^370
T1TaxSummary[3,61]=301 Age amount^YRSUM^371
T1TaxSummary[4,61]=301 Age amount^YRSUM^372

//Schedule1[098]=303 Spousal amount^YRSUM^374
T1TaxSummary[1,62]=303 Spousal amount^YRSUM^374
T1TaxSummary[2,62]=303 Spousal amount^YRSUM^375
T1TaxSummary[3,62]=303 Spousal amount^YRSUM^376
T1TaxSummary[4,62]=303 Spousal amount^YRSUM^377

//Schedule1[099]=305 Equivalent to spouse amt^YRSUM^79


T1TaxSummary[1,155]=306 Infirm dependants^YRSUM^384
T1TaxSummary[2,155]=306 Infirm dependants^YRSUM^385
T1TaxSummary[3,155]=306 Infirm dependants^YRSUM^386
T1TaxSummary[4,155]=306 Infirm dependants^YRSUM^387

T1TaxSummary[1,157]=308 CPP contribut.^YRSUM^394
T1TaxSummary[2,157]=308 CPP contribut.^YRSUM^395
T1TaxSummary[3,157]=308 CPP contribut.^YRSUM^396
T1TaxSummary[4,157]=308 CPP contribut.^YRSUM^397

//Schedule1[102]=310 CPP on self-empl. earnings^YRSUM^399

//Schedule1[103]=312 UIC premiums^YRSUM^404

T1TaxSummary[1,66]=314 Pension Income Amount^YRSUM^409
T1TaxSummary[2,66]=314 Pension Income Amount^YRSUM^410
T1TaxSummary[3,66]=314 Pension Income Amount^YRSUM^411
T1TaxSummary[4,66]=314 Pension Income Amount^YRSUM^412

//Schedule1[105]=315 Caregiver amount^YRSUM^414

T1TaxSummary[1,67]=316 Disability for self^YRSUM^419
T1TaxSummary[2,67]=316 Disability for self^YRSUM^420
T1TaxSummary[3,67]=316 Disability for self^YRSUM^421
T1TaxSummary[4,67]=316 Disability for self^YRSUM^422

T1TaxSummary[1,69]=318 Disability for dependants^YRSUM^424
T1TaxSummary[2,69]=318 Disability for dependants^YRSUM^425
T1TaxSummary[3,69]=318 Disability for dependants^YRSUM^426
T1TaxSummary[4,69]=318 Disability for dependants^YRSUM^427

T1TaxSummary[1,34]=319 Interest paid on your student loans^YRSUM^429
T1TaxSummary[2,34]=319 Interest paid on your student loans^YRSUM^430
T1TaxSummary[3,34]=319 Interest paid on your student loans^YRSUM^431
T1TaxSummary[4,34]=319 Interest paid on your student loans^YRSUM^432

//Schedule1[???]=320 Tuition fees for self^YRSUM^434
//Schedule1[???]=322 Education amount for self^YRSUM^444
//Schedule1[110]=324 Transfers from child^YRSUM^454
//Schedule1[111]=326 Transfers from spouse^YRSUM^459
//Schedule1[112]=330 Medical expenses^YRSUM^464

T1TaxSummary[1,70]=332 Medical expenses^YRSUM^469
T1TaxSummary[2,70]=332 Medical expenses^YRSUM^470
T1TaxSummary[3,70]=332 Medical expenses^YRSUM^471
T1TaxSummary[4,70]=332 Medical expenses^YRSUM^472

T1TaxSummary[1,72]=338 Non-refundable Tax credits^YRSUM^474
T1TaxSummary[2,72]=338 Non-refundable Tax credits^YRSUM^475
T1TaxSummary[3,72]=338 Non-refundable Tax credits^YRSUM^476
T1TaxSummary[4,72]=338 Non-refundable Tax credits^YRSUM^477

T1TaxSummary[1,73]=349 Charitable donations^YRSUM^479
T1TaxSummary[2,73]=349 Charitable donations^YRSUM^480
T1TaxSummary[3,73]=349 Charitable donations^YRSUM^481
T1TaxSummary[4,73]=349 Charitable donations^YRSUM^482

T1TaxSummary[1,74]=350 Total Non-Refundable Crdts^YRSUM^484
T1TaxSummary[2,74]=350 Total Non-Refundable Crdts^YRSUM^485
T1TaxSummary[3,74]=350 Total Non-Refundable Crdts^YRSUM^486
T1TaxSummary[4,74]=350 Total Non-Refundable Crdts^YRSUM^487

//TOTAL PAYABLE
T1TaxSummary[1,90]=406 Federal Tax^YRSUM^609
T1TaxSummary[2,90]=406 Federal Tax^YRSUM^610
T1TaxSummary[3,90]=406 Federal Tax^YRSUM^611
T1TaxSummary[4,90]=406 Federal Tax^YRSUM^612

T1TaxSummary[1,97]=410 Fed. pol. contr. tax credit^YRSUM^619
T1TaxSummary[1,97]=410 Fed. pol. contr. tax credit^YRSUM^620
T1TaxSummary[1,97]=410 Fed. pol. contr. tax credit^YRSUM^621
T1TaxSummary[1,97]=410 Fed. pol. contr. tax credit^YRSUM^622

//Schedule1[123]=412 Investment tax credit^YRSUM^624
//Schedule1[124]=413 Labour-Sponsored Funds,Cost^YRSUM^629

T1TaxSummary[1,98]=414 Labour-Sponsored Funds Crdt^YRSUM^634
T1TaxSummary[2,98]=414 Labour-Sponsored Funds Crdt^YRSUM^635
T1TaxSummary[3,98]=414 Labour-Sponsored Funds Crdt^YRSUM^636
T1TaxSummary[4,98]=414 Labour-Sponsored Funds Crdt^YRSUM^637

T1TaxSummary[1,37]=418 Additional tax on RESP income^YRSUM^639
T1TaxSummary[2,37]=418 Additional tax on RESP income^YRSUM^640
T1TaxSummary[3,37]=418 Additional tax on RESP income^YRSUM^641
T1TaxSummary[4,37]=418 Additional tax on RESP income^YRSUM^642

//T1[???]=419 Federal individual surtax^YRSUM^644

T1TaxSummary[1,35]=420 Net Federal Tax^YRSUM^649
T1TaxSummary[2,35]=420 Net Federal Tax^YRSUM^650
T1TaxSummary[3,35]=420 Net Federal Tax^YRSUM^651
T1TaxSummary[4,35]=420 Net Federal Tax^YRSUM^652

T1TaxSummary[1,100]=421 CPP on self-employment^YRSUM^654
T1TaxSummary[2,100]=421 CPP on self-employment^YRSUM^655
T1TaxSummary[3,100]=421 CPP on self-employment^YRSUM^656
T1TaxSummary[4,100]=421 CPP on self-employment^YRSUM^657

T1TaxSummary[1,101]=422 Social Benefits Repayment^YRSUM^659
T1TaxSummary[2,101]=422 Social Benefits Repayment^YRSUM^660
T1TaxSummary[3,101]=422 Social Benefits Repayment^YRSUM^661
T1TaxSummary[4,101]=422 Social Benefits Repayment^YRSUM^662

T1TaxSummary[1,102]=428 Provincial Tax^YRSUM^664
T1TaxSummary[2,102]=428 Provincial Tax^YRSUM^665
T1TaxSummary[3,102]=428 Provincial Tax^YRSUM^666
T1TaxSummary[4,102]=428 Provincial Tax^YRSUM^667

//T1[???]=431 Net Provincial Tax^YRSUM^734

T1TaxSummary[1,103]=435 Total Tax Payable^YRSUM^669
T1TaxSummary[2,103]=435 Total Tax Payable^YRSUM^670
T1TaxSummary[3,103]=435 Total Tax Payable^YRSUM^671
T1TaxSummary[4,103]=435 Total Tax Payable^YRSUM^672

//TOTAL CREDITS
T1TaxSummary[1,110]=437 Total Tax per slips^YRSUM^674
T1TaxSummary[2,110]=437 Total Tax per slips^YRSUM^675
T1TaxSummary[3,110]=437 Total Tax per slips^YRSUM^676
T1TaxSummary[4,110]=437 Total Tax per slips^YRSUM^677

//T1[???]=438 Quebec Tax deducted xfer^YRSUM^679
//T1[???]=439 Tax applicable to Fed. Tax^YRSUM^684

T1TaxSummary[1,0]=440 Refundable Quebec Abatement^YRSUM^689
T1TaxSummary[2,0]=440 Refundable Quebec Abatement^YRSUM^690
T1TaxSummary[3,0]=440 Refundable Quebec Abatement^YRSUM^691
T1TaxSummary[4,0]=440 Refundable Quebec Abatement^YRSUM^692

T1TaxSummary[1,159]=448 CPP Overpayment^YRSUM^694
T1TaxSummary[2,159]=448 CPP Overpayment^YRSUM^695
T1TaxSummary[3,159]=448 CPP Overpayment^YRSUM^696
T1TaxSummary[4,159]=448 CPP Overpayment^YRSUM^697

//T1[320]=450 UI Overpayment^YRSUM^698

T1TaxSummary[1,116]=454 Refund of ITC^YRSUM^704
T1TaxSummary[2,116]=454 Refund of ITC^YRSUM^705
T1TaxSummary[3,116]=454 Refund of ITC^YRSUM^706
T1TaxSummary[4,116]=454 Refund of ITC^YRSUM^707

//T1[322]=456 Part XII.2 Tax Credit^YRSUM^709

T1TaxSummary[1,113]=457 Empl/Partner GST rebate^YRSUM^714
T1TaxSummary[2,113]=457 Empl/Partner GST rebate^YRSUM^715
T1TaxSummary[3,113]=457 Empl/Partner GST rebate^YRSUM^716
T1TaxSummary[4,113]=457 Empl/Partner GST rebate^YRSUM^717

T1TaxSummary[1,114]=476 Tax paid by instalments^YRSUM^719
T1TaxSummary[2,114]=476 Tax paid by instalments^YRSUM^720
T1TaxSummary[3,114]=476 Tax paid by instalments^YRSUM^721
T1TaxSummary[4,114]=476 Tax paid by instalments^YRSUM^722

T1TaxSummary[1,115]=479 Provincial Tax Credits^YRSUM^729
T1TaxSummary[2,115]=479 Provincial Tax Credits^YRSUM^730
T1TaxSummary[3,115]=479 Provincial Tax Credits^YRSUM^731
T1TaxSummary[4,115]=479 Provincial Tax Credits^YRSUM^732

//T1[???]=480 Alberta SS Plan Credit^YRSUM^000

T1TaxSummary[1,118]=485 Refund^YRSUM^744
T1TaxSummary[2,118]=485 Refund^YRSUM^745
T1TaxSummary[3,118]=485 Refund^YRSUM^746
T1TaxSummary[4,118]=485 Refund^YRSUM^747
