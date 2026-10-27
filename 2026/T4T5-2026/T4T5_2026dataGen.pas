unit T4T5_2026dataGen;

interface

uses Classes; //,Dialogs,SysUtils,T4T5_2026declare,T4T5_2026trimstr;

const
 indent = 3;
 indentM = 6;
 indentMM = 9;
 indentMMM = 12;
 indentMMMM = 15;
 indentMMMMM = 18;
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


 procedure addSubmissionTag(tag:String;Var XmlList:tstringlist);
 Procedure PrepareT5018Rec(RetNo:Integer;FName:String);
 Procedure PrepareT5018SlipRec(RetNo:Integer;FName:String);
 Procedure createT5018XML(RetNo:Integer;DataTypeCode:String;SubmitRef:String;var T5018XmlList:tstringlist);

 Procedure PrepareT3SummaryRec(RetNo:Integer;FName:String);
 Procedure PrepareT3SlipRec(RetNo:Integer;FName:String);
 procedure createT3XML(RetNo:Integer;DataTypeCode:String;SubmitRef:String;Var T3XmlList:tstringlist);

 procedure PrepareT619(Var T619XmlList:TStringList;RetNo:integer;DataTypeCode:String;SubmitRef:String);

 Function ReplaceSpecialChar(info:String):String;
 Function FixPostal(s:String):String;

var
T5018Rec : AT5018Rec;
T3Rec    : AT3Rec;

implementation

uses //Classes,Dialogs,
  SysUtils,
  vtCommon,
  T4T5_2026,T4T5_2026declare,T4T5_2026trimstr,
  vtTrimStr, vtShared;

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


procedure createT3XML(RetNo:Integer;DataTypeCode:String;SubmitRef:String;Var T3XmlList:tstringlist);
var
i:integer;
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


Function ReplaceSpecialChar(info:String):String;
Begin
 info := ReplaceChar(info,'&','&amp;');
 info := ReplaceChar(info, '<' , '&lt;' );
 info := ReplaceChar(info,'"','&quot;');
 info := ReplaceChar(info,'>','&gt;');
 info := ReplaceChar(info,'''','&apos;');
 info := ReplaceChar(info,'.','');

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
Procedure PrepareT619(Var T619XmlList:TStringList;RetNo:integer;DataTypeCode:String;SubmitRef:String);
Var
 Info,Lang:String;
begin
  if OptRec.Prp_RepId.IsEmpty() then //20260728 Alex
  begin //20260728 Alex
    T619XmlList.add(Space(indent) + '<T619>');

    //Required up to 15 alphanumeric
    T619XmlList.add(Space(indentM) + '<TransmitterAccountNumber>');

    info:=OptRec.Prp_TransmitterNo;
    If Length(info)=9 then
      T619XmlList.add(Space(indentMM) + '<bn9>' + OptRec.Prp_TransmitterNo + '</bn9>)')
    Else
      T619XmlList.add(Space(indentMM) + '<bn15>' +OptRec.Prp_TransmitterNo + '</bn15>');

    //<trust></trust> -1 alpha, 8 numeric, example: T00000000
    //<nr4></nr4>     - 3 alpha, 6 numeric, example: AAA000000

    T619XmlList.add(Space(indentM) + '</TransmitterAccountNumber>');
  end else //20260728 Alex
  //Required (if logged in using Represent a client (RAC) application) -7 alphanumeric
  If OptRec.Prp_RepId > '' then
  begin
    T619XmlList.add(Space(indentM) + '<TransmitterRepID>');
    T619XmlList.add(Space(indentMM) + '<RepID>'+OptRec.Prp_RepId+'</RepID>');  //20250116
    T619XmlList.add(Space(indentM) + '</TransmitterRepID>');
  End;

  //? required 8
  T619XmlList.add(Space(indentM) + '<sbmt_ref_id>' + SubmitRef + '</sbmt_ref_id>');

        //jz//20250323 - removed <<
        {
        // need code to find selected: [23][24][25] required 1 alpha
        //T619XmlList.add(Space(indentM) + '<rpt_tcd>' + DataTypeCode + '</rpt_tcd>');
        //[1] 2 alpha (MM), 6 nume  ric
        //T619XmlList.add(Space(indentM) + '<trnmtr_nbr>' + 'MM' +  LeftStr(OptRec.Prp_TransmitterNo,6) + '</trnmtr_nbr>'); //LeftStr(OptRec.Prp_XmitNo,6) +
        //? required 1 numeric, 1,2,3,4
        //T619XmlList.add(Space(indentM) + '<trnmtr_tcd>' + OptRec.Prp_TransmitterType + '</trnmtr_tcd>'); //OptRec.Prp_XmitCd +
        }
        //jz//20250323 - removed >>

  //[29] required 6 numeric
  T619XmlList.add(Space(indentM) + '<summ_cnt>' + '1' + '</summ_cnt>');

  //[27][28] required 1 alpha e, f
  Lang:='E';If FetchElm(RetNo,'T619_1',28)>'' then Lang:='F';
  T619XmlList.add(Space(indentM) + '<lang_cd>' + Lang + '</lang_cd>');

  T619XmlList.add(Space(indentM) + '<TransmitterName>'); //jz//20250323 - replaced <TRNMTR_NM>
    //jz//20250630 - required first 35 alphanumeric //[2] required first 30 alphanumeric
    info := ReplaceSpecialChar(LeftStr(OptRec.Prp_Name,35));
    T619XmlList.add(Space(indentMM) + '<l1_nm>' + info + '</l1_nm>');

    //jz//20250630 - no longer allows second line
    {
    info := ReplaceSpecialChar(MidStr(OptRec.Prp_name,31,30));
    //[2] required second 30 alphanumeric
    If info > '' then
    begin
     T619XmlList.add(Space(indentMM) + '<l2_nm>' + info + '</l2_nm>');
    end;
    }
  T619XmlList.add(Space(indentM) + '</TransmitterName>'); //jz//20250323 - replaced </TRNMTR_NM>

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

  //? required 3 alphanumeric //FetchElm(ARetNo, 'EMPL', EMPL_COUNTRY)
  T619XmlList.add(Space(indentM) + '<TransmitterCountryCode>' + 'CAN' + '</TransmitterCountryCode>'); //20260105 Igor

  T619XmlList.add(Space(indentM) + '<CNTC>');

  info := ReplaceSpecialChar(LeftStr(OptRec.Prp_ContactName,22));
  //[8] required 22 alphanumeric, omit titles
  T619XmlList.add(Space(indentMM) + '<cntc_nm>' + info + '</cntc_nm>');

  //[6] - first 3 numbers
  T619XmlList.add(Space(indentMM) + '<cntc_area_cd>' + LeftStr(OptRec.Prp_Area,3) + '</cntc_area_cd>');

  //[6] - last 7 numbers 3 then '-' then last 4  - needs validation on input
  T619XmlList.add(Space(indentMM) + '<cntc_phn_nbr>' + RemoveChar(LeftStr(OptRec.Prp_Tel,8),' ') + '</cntc_phn_nbr>');

  //? not required 4 numeric
  //T619XmlList.add(Space(indentM) + '<cntc_extn_nbr>' + LeftStr(FetchElm(RetNo,'T619_1',5))' + '</cntc_extn_nbr>';

  // 20130402
  T619XmlList.add(Space(indentMM) + '<cntc_email_area>' + AllTrim(LeftStr(OptRec.Prp_EMail,60)) + '</cntc_email_area>');

  T619XmlList.add(Space(indentM) + '</CNTC>');

  T619XmlList.add(Space(indent) + '</T619>');
end;
//20260107 Igor <<<


end.
