[MAP]

//INFO----------------
Info.IssuerAddress.Name=^^EMPL^1
Info.IssuerAddress.AddressLine1=^^EMPL^2
Info.IssuerAddress.City=^^EMPL^3
Info.IssuerAddress.Province=^^EMPL^4
Info.IssuerAddress.PostalCode=^^EMPL^5
Info.IssuerAddress.Country=^^EMPL^6

Info.ContactAddress.FirstName=^^EMPL^7
Info.ContactAddress.LastName=^^EMPL^8
Info.ContactAddress.Phone=Phone Area^AREA^EMPL^9
Info.ContactAddress.Phone=Phone No^PHONE^EMPL^10
Info.ContactAddress.PhoneExtension=^^EMPL^41

Info.Issuer.BusinessNumber=^^EMPL^19
Info.Issuer.ProprietorSin=^^EMPL^29

////Info.Issuer.PrincipalSin=^^EMPL^30
///Info.Issuer.QcIDNumber=^^EMPL^16
Info.SigningAddress.FirstName=^^EMPL^11
Info.SigningAddress.LastName=^^EMPL^12
Info.SigningAddress.Phone=Phone Area^AREA^EMPL^14
Info.SigningAddress.Phone=Phone No^PHONE^EMPL^15
Info.SigningAddress.PhoneExtension=^^EMPL^32
Info.SigningAddress.PositionOrOffice=^^EMPL^13

//T4Slips
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

//T5Slips
T5Slips.T5[y].Actual.Transit=^^T5#y^30
T5Slips.T5[y].Actual.RecipientIdentificationNumber=^^T5#y^11
T5Slips.T5[y].Actual.RecipientName=^^T5#y^19
T5Slips.T5[y].RecipientAddress.AddressLine1=^^T5#y^20
T5Slips.T5[y].RecipientAddress.City=^^T5#y^21
T5Slips.T5[y].RecipientAddress.Province=^^T5#y^22
T5Slips.T5[y].RecipientAddress.PostalCode=^^T5#y^23
T5Slips.T5[y].RecipientAddress.Country=^^T5#y^32

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