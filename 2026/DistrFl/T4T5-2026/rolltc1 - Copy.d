[MAP]
//INFO----------------

Info.ID.BusinessNumber=BN^^T2^1
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
Info.ID.CorporationName=Corp Name^^T2^3

Info.HeadOfficeAddress.AddressLine1=HO street^^T2^12
Info.HeadOfficeAddress.AddressLine2=HO str2^^T2^13
Info.HeadOfficeAddress.City=ho city^^T2^16
Info.HeadOfficeAddress.Province=HO prov^^T2^17
Info.HeadOfficeAddress.Country=HO country^^T2^19
Info.HeadOfficeAddress.PostalCode=ho postal^^T2^20
Info.HeadOfficeAddress.ZipCode=ho postal^&^T2^20
Info.HeadOfficeAddress.CareOf=co name^^T2^23

Info.MailingAddress.AddressLine1=ml str^^T2^26
Info.MailingAddress.AddressLine2=ml str2^^T2^27
Info.MailingAddress.City=ml city^^T2^32
Info.MailingAddress.Province=ml prov^^T2^33
Info.MailingAddress.PostalCode=ml postal^^T2^35
Info.MailingAddress.ZipCode=ml postal^&^T2^35
Info.MailingAddress.Country=ml country^^T2^34

Info.LocationOfBooks.AddressLine1=lb str^^T2^38
Info.LocationOfBooks.AddressLine2=lb str2^^T2^41
Info.LocationOfBooks.City=lb city^^T2^44
Info.LocationOfBooks.Province=lb prov^^T2^45
Info.LocationOfBooks.PostalCode=lb postal^^T2^47
Info.LocationOfBooks.ZipCode=lb postal^&^T2^47
Info.LocationOfBooks.Country=lb country^^T2^46

Info.Corporation.Type=Corp type^Radio:[1=51,2=56,3=59,4=52,5=57]^T2^51
Info.Corporation.OtherCorpType=Oth corp descr^^T2^60

Info.Filing.YearStart=startYear^INCYEAR^T2^10
Info.Filing.YearEnd=endYear^INCYEAR^T2^11

Info.Residency.ResidentOfCanada=Residency^Radio:[1=48,2=49]^T2^49
Info.Residency.Country=For country nm^^T2^50

Info.Filing.MemberOfPartnership=Prof Corp^Radio:[1=24,2=25]^T2^24

Info.Residency.ClaimingExemption=Exempt under treaty^[1=63,2=64]^T2^63

Info.Residency.NonResidentCorpIncomeType=Exempt sec 149^Radio:[1=53,2=54,3=55,4=58]^T2^53

T2.AdditionalInformation.Inactive=Corp Inactive^Radio:[1=201,2=202]^T2^201
///=Maj bus act changed^X^T2^203
///=Maj bus act^^T2^205
///=Retail-Wholesale^X^T2^206
Info.Activity.Description1=princ pruct 1^^T2^208
Info.Activity.Description2=princ pruct 2^^T2^210
Info.Activity.Description3=princ pruct 3^^T2^212
Info.Activity.Percentage1=percent of prod^%^T2^209
Info.Activity.Percentage2=percent of prod^%^T2^211
Info.Activity.Percentage3=percent of prod^%^T2^213

///T2.RefundableDividendTaxOnHand.[?]=Rf div bal^^T2^527

///=DD branch^^T2^737
///=DD inst^^T2^738
//=DD account^^T2^739

T2.Certification.LastName=Certif Surn^^T2^742
T2.Certification.FirstName=Certif first nm^^T2^743
T2.Certification.Position=certif position^^T2^744

T2.Certification.PhoneNumber=Certif tel^AREA^T2^755
T2.Certification.PhoneNumber=Certif tel^PHONE^T2^746

T2.Certification.ContactSameAsSigning=Certif contact Same^Radio:[1=747,2=748]^T2^748
T2.Certification.ContactName=Certif contact Name^^T2^749
T2.Certification.ContactPhoneNumber=certif contact tel^AREA^T2^756
T2.Certification.ContactPhoneNumber=certif contact tel^PHONE^T2^750

//??????
///=CEC bal^^S10^4


AT1.Filing.BusinessNumber=Alb account^^AT1^9
AT1.Filing.NatureOfBusiness=Alb SIC^^AT1^58



///=Unused Part 1.3 cr^^S37^10


///=Yr Net cap loss^^S4^1

S4Worksheet.CurrentYearNonCapitalLosses.EndBalance=Non cap loss 1 prior^^S4WS^649
S4Worksheet.NonCapitalLosses[y].EndBalance=Non cap 2nd PRIOR^+^S4WS^Transform:NonCapLoss:<S4Worksheet.NonCapitalLosses[y].Year>
S4Worksheet.NonCapitalLossesOlder[y].EndBalance=Non cap 2nd PRIOR^+^S4WS^Transform:NonCapLoss:<S4Worksheet.NonCapitalLosses[y].Year>

S4Worksheet.CurrentYearFarmLosses.EndBalance=Farm loss^^S4WS^810
S4Worksheet.FarmLosses[y].EndBalance=Farm loss 1^+^S4WS^Transform:FarmLoss:<S4Worksheet.FarmLosses[y].Year>
S4Worksheet.FarmLossesOlder[y].EndBalance=Farm loss 1^+^S4WS^Transform:FarmLoss:<S4Worksheet.FarmLossesOlder[y].Year>

S4Worksheet.CurrentYearRestrictedFarmLosses.EndBalance=RFarm loss^^S4WS^971
S4Worksheet.RestrictedFarmLosses[y].EndBalance=RFarm loss 1^+^S4WS^Transform:RFarmLoss:<S4Worksheet.RestrictedFarmLosses[y].Year>
S4Worksheet.RestrictedFarmLossesOlder[y].EndBalance=RFarm loss 1^+^S4WS^Transform:RFarmLoss:<S4Worksheet.RestrictedFarmLossesOlder[y].Year>

S4Worksheet.CurrentYearLPPLosses.EndBalance=RFarm loss^^S4WS^87
S4Worksheet.LPPLosses[y].EndBalance=Listed property loss 1^+^S4WS^Transform:LPLoss:<S4Worksheet.LPPLosses[y].Year>

FC086\008R=Earned depletion^^S12^4
FC086\017R=Earned depletion^^S12^5
FC099\007R=Mining Exploration^^S12^15
FC085\013R=CCEE^^S12^101
FC085\032R=CCEE^^S12^102
FC084\014R=CCDE^^S12^201
FC084\033R=CCDE^^S12^202
FC083\012R=CCOGPE^^S12^301
FC083\031R=CCOGPE^^S12^302
FC088\008R=FEDExpl^^S12^401
FC088\027R=FedExpl^^S12^402

FC009\398R=ITC^^S31^237
FC009\657R=ITC-SRED^^S31^520

FC026\069R=S321^^S321^21
FC066\061R=S344^^S344^21
FC148\064R=S360^^S360^5
FC045\069R=S380^^S380^4
FC055\069R=S381^^S381^21
FC077\061R=S402^^S402^21
FC161\064R=S403^^S403^11
FC180\031R=S426^^S426^121

//S2 - Donations -----------------------------------------------------
FC006\049R=don end bal^^S2^205
FC006\050R=don end bal^^S2^210
FC006\051R=don end bal^^S2^215
FC006\052R=don end bal^^S2^220
FC006\053R=don end bal^^S2^225

//S2 - Gifts-----------------------------------------------------
FC006\138R=gifts end bal^^S2^239
FC006\139R=gifts end bal^^S2^244
FC006\140R=gifts end bal^^S2^249
FC006\141R=gifts end bal^^S2^254
FC006\142R=gifts end bal^^S2^259

//S2 - Cultural-----------------------------------------------------
FC006\162R=cult end bal^^S2^273
FC006\163R=cult end bal^^S2^278
FC006\164R=cult end bal^^S2^283
FC006\165R=cult end bal^^S2^288
FC006\166R=cult end bal^^S2^293

//S2 - ecological-----------------------------------------------------
FC006\186R=ecol end bal^^S2^307
FC006\187R=ecol end bal^^S2^312
FC006\188R=ecol end bal^^S2^317
FC006\189R=ecol end bal^^S2^3122
FC006\190R=ecol end bal^^S2^327


//CCA class-----------------------------------------------------
//Form instance 1
FC011\001R=CCA class^REMOVEifZERO^S8#1^6
FC011\501R=CCA UCC^^S8#1^7
FC011\002R=CCA class^REMOVEifZERO^S8#1^22
FC011\502R=CCA UCC^^S8#1^23
FC011\003R=CCA class^REMOVEifZERO^S8#1^38
FC011\503R=CCA UCC^^S8#1^39
FC011\004R=CCA class^REMOVEifZERO^S8#1^54
FC011\504R=CCA UCC^^S8#1^55
FC011\005R=CCA class^REMOVEifZERO^S8#1^70
FC011\505R=CCA UCC^^S8#1^71
FC011\006R=CCA class^REMOVEifZERO^S8#1^86
FC011\506R=CCA UCC^^S8#1^87
FC011\007R=CCA class^REMOVEifZERO^S8#1^102
FC011\507R=CCA UCC^^S8#1^103
FC011\008R=CCA class^REMOVEifZERO^S8#1^118
FC011\508R=CCA UCC^^S8#1^119
FC011\009R=CCA class^REMOVEifZERO^S8#1^134
FC011\509R=CCA UCC^^S8#1^135
FC011\010R=CCA class^REMOVEifZERO^S8#1^150
FC011\510R=CCA UCC^^S8#1^151
FC011\011R=CCA class^REMOVEifZERO^S8#1^166
FC011\511R=CCA UCC^^S8#1^167
FC011\012R=CCA class^REMOVEifZERO^S8#1^182
FC011\512R=CCA UCC^^S8#1^183
FC011\013R=CCA class^REMOVEifZERO^S8#1^198
FC011\513R=CCA UCC^^S8#1^199

//Form Instance 2
FC011\014R=CCA class^REMOVEifZERO^S8#2^6
FC011\514R=CCA UCC^^S8#2^7
FC011\015R=CCA class^REMOVEifZERO^S8#2^22
FC011\515R=CCA UCC^^S8#2^23
FC011\016R=CCA class^REMOVEifZERO^S8#2^38
FC011\516R=CCA UCC^^S8#2^39
FC011\017R=CCA class^REMOVEifZERO^S8#2^54
FC011\517R=CCA UCC^^S8#2^55
FC011\018R=CCA class^REMOVEifZERO^S8#2^70
FC011\518R=CCA UCC^^S8#2^71
FC011\019R=CCA class^REMOVEifZERO^S8#2^86
FC011\519R=CCA UCC^^S8#2^87
FC011\020R=CCA class^REMOVEifZERO^S8#2^102
FC011\520R=CCA UCC^^S8#2^103
FC011\021R=CCA class^REMOVEifZERO^S8#2^118
FC011\521R=CCA UCC^^S8#2^119
FC011\022R=CCA class^REMOVEifZERO^S8#2^134
FC011\522R=CCA UCC^^S8#2^135
FC011\023R=CCA class^REMOVEifZERO^S8#2^150
FC011\523R=CCA UCC^^S8#2^151
FC011\024R=CCA class^REMOVEifZERO^S8#2^166
FC011\524R=CCA UCC^^S8#2^167
FC011\025R=CCA class^REMOVEifZERO^S8#2^182
FC011\525R=CCA UCC^^S8#2^183
FC011\026R=CCA class^REMOVEifZERO^S8#2^198
FC011\526R=CCA UCC^^S8#2^199

//Form Instance 3
FC011\027R=CCA class^REMOVEifZERO^S8#3^6
FC011\527R=CCA UCC^^S8#3^7
FC011\028R=CCA class^REMOVEifZERO^S8#3^22
FC011\528R=CCA UCC^^S8#3^23
FC011\029R=CCA class^REMOVEifZERO^S8#3^38
FC011\529R=CCA UCC^^S8#3^39
FC011\030R=CCA class^REMOVEifZERO^S8#3^54
FC011\530R=CCA UCC^^S8#3^55
FC011\031R=CCA class^REMOVEifZERO^S8#3^70
FC011\531R=CCA UCC^^S8#3^71
FC011\032R=CCA class^REMOVEifZERO^S8#3^86
FC011\532R=CCA UCC^^S8#3^87
FC011\033R=CCA class^REMOVEifZERO^S8#3^102
FC011\533R=CCA UCC^^S8#3^103
FC011\034R=CCA class^REMOVEifZERO^S8#3^118
FC011\534R=CCA UCC^^S8#3^119
FC011\035R=CCA class^REMOVEifZERO^S8#3^134
FC011\535R=CCA UCC^^S8#3^135
FC011\036R=CCA class^REMOVEifZERO^S8#3^150
FC011\536R=CCA UCC^^S8#3^151
FC011\037R=CCA class^REMOVEifZERO^S8#3^166
FC011\537R=CCA UCC^^S8#3^167
FC011\038R=CCA class^REMOVEifZERO^S8#3^182
FC011\538R=CCA UCC^^S8#3^183
FC011\039R=CCA class^REMOVEifZERO^S8#3^198
FC011\539R=CCA UCC^^S8#3^199

//S8LH -----------------------------------------------------
FC010\001S=CCA-L Descr^^S8LH^11
FC010\001R=CCA-L start yr^DATE^S8LH^1
FC010\016R=CCA-L end yr^DATE^S8LH^2
FC010\031R=CCA-L orig cost^^S8LH^3
FC010\151R=CCA-L ucc^^S8LH^4
//-----------------------------
FC010\002S=CCA-L Descr^^S8LH^22
FC010\002R=CCA-L start yr^DATE^S8LH^12
FC010\017R=CCA-L end yr^DATE^S8LH^13
FC010\032R=CCA-L orig cost^^S8LH^14
FC010\152R=CCA-L ucc^^S8LH^15
//-----------------------------
FC010\003S=CCA-L Descr^^S8LH^33
FC010\003R=CCA-L start yr^DATE^S8LH^23
FC010\018R=CCA-L end yr^DATE^S8LH^24
FC010\033R=CCA-L orig cost^^S8LH^25
FC010\153R=CCA-L ucc^^S8LH^26
//-----------------------------
FC010\004S=CCA-L Descr^^S8LH^44
FC010\004R=CCA-L start yr^DATE^S8LH^34
FC010\019R=CCA-L end yr^DATE^S8LH^35
FC010\034R=CCA-L orig cost^^S8LH^36
FC010\154R=CCA-L ucc^^S8LH^37
//-----------------------------
FC010\005S=CCA-L Descr^^S8LH^55
FC010\005R=CCA-L start yr^DATE^S8LH^45
FC010\020R=CCA-L end yr^DATE^S8LH^46
FC010\035R=CCA-L orig cost^^S8LH^47
FC010\155R=CCA-L ucc^^S8LH^48
//-----------------------------
FC010\006S=CCA-L Descr^^S8LH^66
FC010\006R=CCA-L start yr^DATE^S8LH^56
FC010\021R=CCA-L end yr^DATE^S8LH^57
FC010\036R=CCA-L orig cost^^S8LH^58
FC010\156R=CCA-L ucc^^S8LH^59
//-----------------------------
FC010\007S=CCA-L Descr^^S8LH^77
FC010\007R=CCA-L start yr^DATE^S8LH^67
FC010\022R=CCA-L end yr^DATE^S8LH^68
FC010\037R=CCA-L orig cost^^S8LH^69
FC010\157R=CCA-L ucc^^S8LH^70
//-----------------------------
FC010\008S=CCA-L Descr^^S8LH^88
FC010\008R=CCA-L start yr^DATE^S8LH^78
FC010\023R=CCA-L end yr^DATE^S8LH^79
FC010\038R=CCA-L orig cost^^S8LH^80
FC010\158R=CCA-L ucc^^S8LH^81
//-----------------------------
FC010\009S=CCA-L Descr^^S8LH^99
FC010\009R=CCA-L start yr^DATE^S8LH^89
FC010\024R=CCA-L end yr^DATE^S8LH^90
FC010\039R=CCA-L orig cost^^S8LH^91
FC010\159R=CCA-L ucc^^S8LH^92
//-----------------------------
FC010\010S=CCA-L Descr^^S8LH^110
FC010\010R=CCA-L start yr^DATE^S8LH^100
FC010\025R=CCA-L end yr^DATE^S8LH^101
FC010\040R=CCA-L orig cost^^S8LH^102
FC010\160R=CCA-L ucc^^S8LH^103
//-----------------------------
FC010\011S=CCA-L Descr^^S8LH^121
FC010\011R=CCA-L start yr^DATE^S8LH^111
FC010\026R=CCA-L end yr^DATE^S8LH^112
FC010\041R=CCA-L orig cost^^S8LH^113
FC010\161R=CCA-L ucc^^S8LH^114
//-----------------------------
FC010\012S=CCA-L Descr^^S8LH^132
FC010\012R=CCA-L start yr^DATE^S8LH^122
FC010\027R=CCA-L end yr^S8LH^DATE^123
FC010\042R=CCA-L orig cost^^S8LH^124
FC010\162R=CCA-L ucc^^S8LH^125
//to from additional sheets----
FC010\013R=CCA-L start yr^DATE^S8LH^133
FC010\028R=CCA-L end yr^DATE^S8LH^134
FC010\043R=CCA-L orig cost^^S8LH^135
FC010\163R=CCA-L ucc^^S8LH^136

//S9 -----------------------------------------------------
FC034\001S=Shareholder^^S9^4
FC034\051S=Country^^S9^5
FC034\101S=Bus No^ADDRC^S9^6
FC034\001B=Code^^S9^7
FC034\001R=Comm shares^^S9^8
FC034\051R=Comm shares%^^S9^9
FC034\101R=Pref shares^^S9^10
FC034\151R=Pref shares%^^S9^11
FC034\201R=Bk Val Cap stock^^S9^12
//-----------------------------
FC034\002S=Shareholder^^S9^13
FC034\052S=Country^^S9^14
FC034\102S=Bus No^ADDRC^S9^15
FC034\002B=Code^^S9^16
FC034\002R=Comm shares^^S9^17
FC034\052R=Comm shares%^^S9^18
FC034\102R=Pref shares^^S9^19
FC034\152R=Pref shares%^^S9^20
FC034\202R=Bk Val Cap stock^^S9^21
//-----------------------------
FC034\003S=Shareholder^^S9^22
FC034\053S=Country^^S9^23
FC034\103S=Bus No^ADDRC^S9^24
FC034\003B=Code^^S9^25
FC034\003R=Comm shares^^S9^26
FC034\053R=Comm shares%^^S9^27
FC034\103R=Pref shares^^S9^28
FC034\153R=Pref shares%^^S9^29
FC034\203R=Bk Val Cap stock^^S9^30
//-----------------------------
FC034\004S=Shareholder^^S9^31
FC034\054S=Country^^S9^32
FC034\104S=Bus No^ADDRC^S9^33
FC034\004B=Code^^S9^34
FC034\004R=Comm shares^^S9^35
FC034\054R=Comm shares%^^S9^36
FC034\104R=Pref shares^^S9^37
FC034\154R=Pref shares%^^S9^38
FC034\204R=Bk Val Cap stock^^S9^39
//-----------------------------
FC034\005S=Shareholder^^S9^40
FC034\055S=Country^^S9^41
FC034\105S=Bus No^ADDRC^S9^42
FC034\005B=Code^^S9^43
FC034\005R=Comm shares^^S9^44
FC034\055R=Comm shares%^^S9^45
FC034\105R=Pref shares^^S9^46
FC034\155R=Pref shares%^^S9^47
FC034\205R=Bk Val Cap stock^^S9^48
//-----------------------------
FC034\006S=Shareholder^^S9^49
FC034\056S=Country^^S9^50
FC034\106S=Bus No^ADDRC^S9^51
FC034\006B=Code^^S9^52
FC034\006R=Comm shares^^S9^53
FC034\056R=Comm shares%^^S9^54
FC034\106R=Pref shares^^S9^55
FC034\156R=Pref shares%^^S9^56
FC034\206R=Bk Val Cap stock^^S9^57
//-----------------------------
FC034\007S=Shareholder^^S9^58
FC034\057S=Country^^S9^59
FC034\107S=Bus No^ADDRC^S9^60
FC034\007B=Code^^S9^61
FC034\007R=Comm shares^^S9^62
FC034\057R=Comm shares%^^S9^63
FC034\107R=Pref shares^^S9^64
FC034\157R=Pref shares%^^S9^65
FC034\207R=Bk Val Cap stock^^S9^66
//-----------------------------
FC034\008S=Shareholder^^S9^67
FC034\058S=Country^^S9^68
FC034\108S=Bus No^ADDRC^S9^69
FC034\008B=Code^^S9^70
FC034\008R=Comm shares^^S9^71
FC034\058R=Comm shares%^^S9^72
FC034\108R=Pref shares^^S9^73
FC034\158R=Pref shares%^^S9^74
FC034\208R=Bk Val Cap stock^^S9^75
//-----------------------------
FC034\009S=Shareholder^^S9^76
FC034\059S=Country^^S9^77
FC034\109S=Bus No^ADDRC^S9^78
FC034\009B=Code^^S9^79
FC034\009R=Comm shares^^S9^80
FC034\059R=Comm shares%^^S9^81
FC034\109R=Pref shares^^S9^82
FC034\159R=Pref shares%^^S9^83
FC034\209R=Bk Val Cap stock^^S9^84
//-----------------------------
FC034\010S=Shareholder^^S9^85
FC034\060S=Country^^S9^86
FC034\110S=Bus No^ADDRC^S9^87
FC034\010B=Code^^S9^88
FC034\010R=Comm shares^^S9^89
FC034\060R=Comm shares%^^S9^90
FC034\110R=Pref shares^^S9^91
FC034\160R=Pref shares%^^S9^92
FC034\210R=Bk Val Cap stock^^S9^93
//-----------------------------
FC034\011S=Shareholder^^S9^94
FC034\061S=Country^^S9^95
FC034\111S=Bus No^ADDRC^S9^96
FC034\011B=Code^^S9^97
FC034\011R=Comm shares^^S9^98
FC034\061R=Comm shares%^^S9^99
FC034\111R=Pref shares^^S9^100
FC034\161R=Pref shares%^^S9^101
FC034\211R=Bk Val Cap stock^^S9^102
//-----------------------------
FC034\012S=Shareholder^^S9^103
FC034\062S=Country^^S9^104
FC034\112S=Bus No^ADDRC^S9^105
FC034\012B=Code^^S9^106
FC034\012R=Comm shares^^S9^107
FC034\062R=Comm shares%^^S9^108
FC034\112R=Pref shares^^S9^109
FC034\162R=Pref shares%^^S9^110
FC034\212R=Bk Val Cap stock^^S9^111
//-----------------------------
FC034\013S=Shareholder^^S9^112
FC034\063S=Country^^S9^113
FC034\113S=Bus No^ADDRC^S9^114
FC034\013B=Code^^S9^115
FC034\013R=Comm shares^^S9^116
FC034\063R=Comm shares%^^S9^117
FC034\113R=Pref shares^^S9^118
FC034\163R=Pref shares%^^S9^119
FC034\213R=Bk Val Cap stock^^S9^120
//-----------------------------
FC034\014S=Shareholder^^S9^121
FC034\064S=Country^^S9^122
FC034\114S=Bus No^ADDRC^S9^123
FC034\014B=Code^^S9^124
FC034\014R=Comm shares^^S9^125
FC034\064R=Comm shares%^^S9^126
FC034\114R=Pref shares^^S9^127
FC034\164R=Pref shares%^^S9^128
FC034\214R=Bk Val Cap stock^^S9^129

//S13-cap gains -other reserves -----------------------------------------------------
FC012\001S=descr^^S13^4
FC012\031R=end bal^^S13^5
FC012\002S=descr^^S13^8
FC012\032R=end bal^^S13^9
FC012\003S=descr^^S13^12
FC012\033R=end bal^^S13^13
FC012\004S=descr^^S13^16
FC012\034R=end bal^^S13^17
FC012\005S=descr^^S13^20
FC012\035R=end bal^^S13^21
FC012\006S=descr^^S13^24
FC012\036R=end bal^^S13^25

//S50 -----------------------------------------------------
FC149\001S=Shareholder^^S50^4
FC149\018S=Bus No^^S50^5
FC149\035S=sin^^S50^6
FC149\065S=TrustNo^^S50^132
FC149\001R=Percent common^^S50^7
FC149\018R=Percent pref^^S50^8
//S50 -----------------------
FC149\002S=Shareholder^^S50^9
FC149\019S=Bus No^^S50^10
FC149\036S=sin^^S50^11
FC149\066S=TrustNo^^S50^133
FC149\002R=Percent common^^S50^12
FC149\019R=Percent pref^^S50^13
//S50 -----------------------
FC149\003S=Shareholder^^S50^14
FC149\020S=Bus No^^S50^15
FC149\037S=sin^^S50^16
FC149\067S=TrustNo^^S50^134
FC149\003R=Percent common^^S50^17
FC149\020R=Percent pref^^S50^18
//S50 -----------------------
FC149\004S=Shareholder^^S50^19
FC149\021S=Bus No^^S50^20
FC149\038S=sin^^S50^21
FC149\068S=TrustNo^^S50^135
FC149\004R=Percent common^^S50^22
FC149\021R=Percent pref^^S50^23
//S50 -----------------------
FC149\005S=Shareholder^^S50^24
FC149\022S=Bus No^^S50^25
FC149\039S=sin^^S50^26
FC149\069S=TrustNo^^S50^136
FC149\005R=Percent common^^S50^27
FC149\022R=Percent pref^^S50^28
//S50 -----------------------
FC149\006S=Shareholder^^S50^29
FC149\023S=Bus No^^S50^30
FC149\040S=sin^^S50^31
FC149\070S=TrustNo^^S50^137
FC149\006R=Percent common^^S50^32
FC149\023R=Percent pref^^S50^33
//S50 -----------------------
FC149\007S=Shareholder^^S50^34
FC149\024S=Bus No^^S50^35
FC149\041S=sin^^S50^36
FC149\071S=TrustNo^^S50^138
FC149\007R=Percent common^^S50^37
FC149\024R=Percent pref^^S50^38
//S50 -----------------------
FC149\008S=Shareholder^^S50^39
FC149\025S=Bus No^^S50^40
FC149\042S=sin^^S50^41
FC149\072S=TrustNo^^S50^139
FC149\008R=Percent common^^S50^42
FC149\025R=Percent pref^^S50^43
//S50 -----------------------
FC149\009S=Shareholder^^S50^44
FC149\026S=Bus No^^S50^45
FC149\043S=sin^^S50^46
FC149\073S=TrustNo^^S50^140
FC149\009R=Percent common^^S50^47
FC149\026R=Percent pref^^S50^48
//S50 -----------------------
FC149\010S=Shareholder^^S50^49
FC149\027S=Bus No^^S50^50
FC149\044S=sin^^S50^51
FC149\074S=TrustNo^^S50^141
FC149\010R=Percent common^^S50^52
FC149\027R=Percent pref^^S50^53
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

[Transform:NonCapLoss]
2015/12/31=642
2014/12/31=635
2013/12/31=628
2012/12/31=621
2011/12/31=614
2010/12/31=607
2009/12/31=600
2008/12/31=593
2007/12/31=586
2006/12/31=579
2005/12/31=572
2004/12/31=565
2003/12/31=558
2002/12/31=551
2001/12/31=544
2000/12/31=537
1999/12/31=530
1998/12/31=523
1997/12/31=516
1996/12/31=509
1995/12/31=502
[Transform:FarmLoss]
2015/12/31=803
2014/12/31=798
2013/12/31=791
2012/12/31=784
2011/12/31=777
2010/12/31=770
2009/12/31=763
2008/12/31=756
2007/12/31=749
2006/12/31=742
2005/12/31=735
2004/12/31=728
2003/12/31=721
2002/12/31=714
2001/12/31=707
2000/12/31=700
1999/12/31=693
1998/12/31=686
1997/12/31=679
1996/12/31=672
1995/12/31=665
[Transform:RFarmLoss]
2015/12/31=964
2014/12/31=957
2013/12/31=950
2012/12/31=943
2011/12/31=936
2010/12/31=929
2009/12/31=922
2008/12/31=915
2007/12/31=908
2006/12/31=901
2005/12/31=894
2004/12/31=887
2003/12/31=880
2002/12/31=873
2001/12/31=866
2000/12/31=859
1999/12/31=852
1998/12/31=845
1997/12/31=838
1996/12/31=831
1995/12/31=824
[Transform:LPLoss]
2015/12/31=81
2014/12/31=75
2013/12/31=69
2012/12/31=63
2011/12/31=57
2010/12/31=51
2009/12/31=45
2008/12/31=98
