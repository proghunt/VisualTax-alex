[MAP]

//INFO----------------
Info.ContactAddress.Name=^^EMPL^1
Info.ContactAddress.AddressLine1=^^EMPL^2
Info.ContactAddress.City=^^EMPL^3
Info.ContactAddress.Province=^^EMPL^4
Info.ContactAddress.PostalCode=^^EMPL^5
Info.ContactAddress.Country=^^EMPL^6
Info.ContactAddress.FirstName=^^EMPL^7
Info.ContactAddress.LastName=^^EMPL^8
Info.ContactAddress.Phone=Phone Area^AREA^EMPL^9
Info.ContactAddress.Phone=Phone No^PHONE^EMPL^10
Info.ContactAddress.PhoneExtension=^^EMPL^41
Info.Issuer.BusinessNumber=^^EMPL^19
Info.Issuer.ProprietorSin=^^EMPL^29
Info.Issuer.PrincipalSin=^^EMPL^30
Info.Issuer.QcIDNumber=^^EMPL^16
Info.SigningAddress.FirstName=^^EMPL^11
Info.SigningAddress.LastName=^^EMPL^12
Info.SigningAddress.Phone=Phone Area^AREA^EMPL^14
Info.SigningAddress.Phone=Phone No^PHONE^EMPL^15
Info.SigningAddress.PhoneExtension=^^EMPL^32
Info.SigningAddress.PositionOrOffice=^^EMPL^13

//T4Slips
T4Slips.T4[y].Actual.EmploymentIncome=^^T4#y^18
T4Slips.T4[y].Actual.CppContributions=^^T4#y^19
T4Slips.T4[y].Actual.QppContributions=^^T4#y^20
T4Slips.T4[y].Actual.EiPremiums=^^T4#y^21
T4Slips.T4[y].Actual.RppContributions=^^T4#y^22
T4Slips.T4[y].Actual.IncomeTaxDeducted=^^T4#y^24
T4Slips.T4[y].Actual.EiInsurableEarnings=^^T4#y^25
T4Slips.T4[y].Actual.PensionableEarnings=^^T4#y^26
T4Slips.T4[y].Actual.UnionDues=^^T4#y^27
T4Slips.T4[y].Actual.CharitableDonations=^^T4#y^28
T4Slips.T4[y].Actual.RegistrationNumber=^^T4#y^29
T4Slips.T4[y].Actual.PensionAdjustment=^^T4#y^23
T4Slips.T4[y].Actual.PpipInsurableEarnings=^^T4#y^46
T4Slips.T4[y].Actual.PpipPremiums=^^T4#y^45
T4Slips.T4[y].Employee.SIN=^^T4#y^7
T4Slips.T4[y].Employee.Province=^^T4#y^6
T4Slips.T4[y].Employee.ExemptionCppQpp=^Transform:[1=X]^T4#y^8
T4Slips.T4[y].Employee.ExemptionEi=^Transform:[1=X]^T4#y^9
T4Slips.T4[y].Employee.ExemptionPpip=^Transform:[1=X]^T4#y^44
T4Slips.T4[y].Employee.EmploymentCode=^^T4#y^10
T4Slips.T4[y].EmployeeAddress.FirstName=^^T4#y^12
T4Slips.T4[y].EmployeeAddress.LastName=^^T4#y^11
T4Slips.T4[y].EmployeeAddress.Initial=^^T4#y^13
T4Slips.T4[y].EmployeeAddress.AddressLine1=^^T4#y^14
T4Slips.T4[y].EmployeeAddress.City=^^T4#y^15
T4Slips.T4[y].EmployeeAddress.Province=^^T4#y^17
T4Slips.T4[y].EmployeeAddress.PostalCode=^^T4#y^16
T4Slips.T4[y].EmployeeAddress.Country=^^T4#y^43
T4Slips.T4[y].Payroll.NetPayForTheYear=^^T4#y^103

//T5Slips
T5Slips.T5[y].Actual.ActualDividendsNonEligible=^^T5#y^7
T5Slips.T5[y].Actual.TaxableDividendsNonEligible=^^T5#y^8
T5Slips.T5[y].Actual.TaxCreditNonEligible=^^T5#y^9
T5Slips.T5[y].Actual.Interest=^^T5#y^5
T5Slips.T5[y].Actual.Interest=^^T5#y^5
T5Slips.T5[y].Actual.ForeignCurrency=^^T5#y^29
T5Slips.T5[y].Actual.Transit=^^T5#y^30
T5Slips.T5[y].Actual.CapitalGains=^^T5#y^6
T5Slips.T5[y].Actual.RecipientAccount=^^T5#y^31
T5Slips.T5[y].Actual.RecipientIdentificationNumber=^^T5#y^11
T5Slips.T5[y].Actual.RecipientName=^^T5#y^19
T5Slips.T5[y].RecipientAddress.AddressLine1=^^T5#y^20
T5Slips.T5[y].RecipientAddress.City=^^T5#y^21
T5Slips.T5[y].RecipientAddress.Province=^^T5#y^22
T5Slips.T5[y].RecipientAddress.PostalCode=^^T5#y^23
T5Slips.T5[y].RecipientAddress.Country=^^T5#y^32
T5Slips.T5[y].Rl3Amounts.ActualDividendsEligible=^^T5#y^2
T5Slips.T5[y].Rl3Amounts.TaxableDividends=^^T5#y^3
T5Slips.T5[y].Rl3Amounts.DividendTaxCredit=^^T5#y^4


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
