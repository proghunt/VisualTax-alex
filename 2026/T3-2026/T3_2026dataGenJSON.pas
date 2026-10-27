unit T3_2026dataGenJSON;

interface

uses Classes, XSuperObject, System.StrUtils, Variants, uADCompClient, System.IOUtils, vtDatabase; //20240129 Igor

const TRANSMISSIONS_DELIMITER = '{==DELIMITER==}'; //20240129 Igor

procedure createEfileJson(RetNo:Integer; FormName:String; Var T3JsonList:tstringlist; ProdOrTest:String); //20240118 Igor

implementation

uses
  SysUtils, DateUtils, vtCommon, vtTrimStr, vtShared, vtMulti, //20240118 Igor
  T3_2026datagenT183, T3_2026,T3_2026declare,T3_2026trimstr, T3_2026Efrules, T3_2026Common2,
  Vcl.Dialogs, Vcl.Controls, //20211220 Igor
  System.Math; //20250317 Igor

var CurrTestCaseId: string; //20240129 Igor

function StripNonNumbers(inputString: string): string; //20240118 Igor //20240119 Igor
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(inputString) do
  begin
    if CharInSet(inputString[i], ['0'..'9']) then
      Result := Result + inputString[i];
  end;
end;

{ //jz 20240326
function GetTrustNumber(ARetNo: integer; AFormName: string; AElmNo: integer; ProdOrTest:String): String; //20240118 Igor //20240119 Igor
begin
  if ProdOrTest = 'P' then
    Result := 'T' + StripNonNumbers(FetchElm(ARetNo, AFormName, AElmNo))
  else
    Result := 'A' + StripNonNumbers(FetchElm(ARetNo, AFormName, AElmNo));
end;
}

procedure SplitPhoneNumber(APhoneNumber: string; var ACountryCode, AAreaCode, ALocalNumber: string); //20240118 Igor
begin
  APhoneNumber := StripNonNumbers(APhoneNumber);
  ALocalNumber := Copy(APhoneNumber, Length(APhoneNumber) - 6, 7);
  AAreaCode := Copy(APhoneNumber, Length(APhoneNumber) - 9, 3);
  ACountryCode := Copy(APhoneNumber, 1, Length(APhoneNumber) - 12);
  if ACountryCode.IsEmpty then
    ACountryCode := '1';
end;

function PrepareDate(AValue: string): string; //20240118 Igor
begin
  Result := ReplaceStr(AValue, '/', '-');
end;

// open json file and save if with the same formatting as we use, it is easier to compare test and submitted files
procedure ReSaveJson(AFileName: string); //20240118 Igor
begin
  if not FileExists(AFileName) then Exit; //20240129 Igor
  with TStringList.Create do
  try
    LoadFromFile(AFileName);
    Text := SO(Text).AsJSON(true);
    SaveToFile(AFileName);
  finally
    Free;
  end;
end;

//jz 20240326
function GenerateJsonHeader(RetNo:Integer;T3ReturnType,ProdOrTest:String): ISuperObject; //20211130 Igor //20211220 Igor
var OnLineNo, Password, Url, NetFileDir: string;
    sss:string;
    t183data:TT3T183data;
begin
  //20240129 Igor >>>
  t183data := getT83data(RetNo,ProdOrTest='P',T3ReturnType,CurrTestCaseId);  //jz 20240326 add returntype var //GetEOLParms(OnLineNo, Password, Url, NetFileDir);
  CurrTestCaseId := t183data.testCaseIdentifier;
  if CurrTestCaseId.IsEmpty then
    CurrTestCaseId := '-'; // to prevent request for testcase for second and other transmissions (beno)
  //20240129 Igor <<<

  Result := SO;
  Result.S['trustNumber'] := t183data.trustNumber; //GetTrustNumber(RetNo, ProdOrTest); //20211204 Igor
  Result.S['softwareId'] :=  t183data.softwareId;  //SoftwareID;

  Result.S['softwareRevisionDate'] := t183data.softwareRevisionDate; //SoftwareRevisionDate;
  Result.B['firstTimeFilerIndicator'] := strtobool(t183data.firstTimeFilerIndicator); //SameText(FetchElm(RetNo, 'EFMEMO', 1), 'X'); //20211223 Igor

  Result.B['additionalTaxReturnIndicator'] := strtobool(t183data.additionalTaxReturnIndicator); //false;

  if t183data.testCaseIdentifier > '' then
    Result.I['testCaseIdentifier'] := strtoint(t183data.testCaseIdentifier);  // optional

  Result.S['originatingIp'] := t183data.originatingIp; //'0.0.0.0';

  Result.O['taxProfessionalData'] := SO;
  with TSuperObject(Result.O['taxProfessionalData']) do
  begin
    S['transmitterEFilerNumber'] := t183data.TransmitterEFilerNumber; //OnLineNo;
    S['passwordId'] := t183data.PasswordId; //Password;
    S['taxPreparerEfilerNumber'] := t183data.TaxPrepEfilerNumber; //OnLineNo;
    S['taxPreparerEfilerPassword'] := t183data.TaxPrepEfilerPassword; //Password;
    S['taxPreparerReturnControlNumber'] := t183data.TaxPrepReturnControlNumber; //Copy(FetchElm(RetNo,'T183TRUST',21), 6, 8); //20220120 Igor

    B['taxPreparerAuthorizationIndicator'] := strtobool(t183data.PreparerAuthIndicator); //true;
    //if strtobool(t183data.PreparerAuthIndicator) then
    if FetchElm(RetNo,'EFMEMO',50)>'' then   //20230320
      S['taxPreparerAuthorizationExpiryDate'] := t183data.PreparerAuthExpiryDate; //'2023-12-31'; //20221210

    S['taxPreparerPreAssessmentReviewContactCode'] := t183data.TaxPrepPreAssessRevContactCode; //AllTrim(FetchElm(RetNo, 'EFMEMO', 2)); //20220308
    S['taxPreparerPostAssessmentReviewContactCode'] := t183data.TaxPrepPostAssessRevContactCode; //AllTrim(FetchElm(RetNo, 'EFMEMO', 3)); //20220308

    if FetchElm(RetNo,'T183TRUST',35)>'' then    //20230302
      S['representativeId'] := t183data.taxProDataRepId; //optrec.Prp_RepresentativeId;

    //20211215 Igor <<<
    with TSuperObject(O['t183ElectronicSignature']) do
    begin
      if SameText(FetchElm(RetNo, 'T183TRUST', 38), 'Y') then
      begin
        B['t183ElectronicSignatureIndicator'] := strtobool(t183data.t183ESigIndicator); //true;
        S['t183ElectronicSignatureDate'] := t183data.t183ESigDate; //FormatDateTime('yyyy-mm-dd', Now);
        //S['t183ElectronicSignatureDate'] := ReplaceChar(t183data.t183ESigDate,'/','-'); //20230326 //FormatDateTime('yyyy-mm-dd', Now);
       S['t183ElectronicSignatureTime'] := t183data.t183ESigTime; //FormatDateTime('hh:nn:ss', Now);
      end
      else
        B['t183ElectronicSignatureIndicator'] := false;
    end;
  end;

end;

function GenerateJsonTrustIdentification(RetNo:Integer;ProdOrTest:String): ISuperObject; //20211130 Igor //20211220 Igor
var cProvinces, cProvince: string;
    arrProvinces: TArray<string>;
    idx: integer;
begin
  Result := SO;
  //20220120 Igor >>>
  with TSuperObject(Result.O['trustIdentifier']) do
  begin
    S['countryOfResidence'] := GetCountry3FromCountry2(Copy(FetchElm(RetNo, 'T3', 11), 1, 2));
    if S['countryOfResidence'].IsEmpty then S['countryOfResidence'] := 'CAN';

    if FetchElm(RetNo,'T3',56)>'' then  //deemed resident
    Begin
     if FetchElm(RetNo,'T3',61)>'' then S['countryOfResidence']:=FetchElm(RetNo,'T3',61);
    End;

    //20250314 Igor >>>
    cProvince := FetchElm(RetNo, 'T3', 9);
    if GetShortPrv(cProvince).Equals('ZZ') then cProvince:= ''; //202602016 Igor
    if not cProvince.IsEmpty then
      S['provinceOfResidence'] := GetShortPrv(cProvince);
    //20250314 Igor <<<
    S['trustName'] := FetchElm(RetNo, 'T3', 1);
    S['trustAccountNumber'] := GetTrustNumber(RetNo, 'T3', ProdOrTest='P'); //jz 20240326 //S['trustAccountNumber'] := GetTrustNumber(RetNo, 'T3', 2, ProdOrTest); //20211204 Igor //20240118 Igor
  end;
  with TSuperObject(Result.O['primaryTrusteeContactInformation']) do
  begin
    B['trusteeNameChangeIndicator'] := false; //???
    if SameText(FetchElm(RetNo, 'T3', 136), 'X') then
    begin
      B['isIndividualIndicator'] := SameText(FetchElm(RetNo, 'T3', 136), 'X');
      with TSuperObject(O['trusteeContactInformation']) do
      begin
        with TSuperObject(O['individualName']) do
        begin
          S['firstName'] := Leftstr(FetchElm(RetNo, 'T3', 3),30);  //20230328
          S['lastName'] := LeftStr(FetchElm(RetNo, 'T3', 53),30);  //20230328
        end;

        with TSuperObject(O['address']) do
        begin
          S['addressLineOne'] := FetchElm(RetNo, 'T3', 4);
          //S['addressLineTwo'] := ''; //20211215 Igor
          S['city'] := FetchElm(RetNo, 'T3', 7);
          if not FetchElm(RetNo, 'T3', 67).IsEmpty and (FetchElm(RetNo, 'T3', 67) <> 'ZZ') then
            S['provinceTerritoryState'] := FetchElm(RetNo, 'T3', 67);
          if not FetchElm(RetNo, 'T3', 8).IsEmpty then
            S['globalPostalZipCode'] := ReplaceChar(FetchElm(RetNo, 'T3', 8),' ','');  //20220329
          S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3', 23));
          if S['country'].IsEmpty then S['country'] := 'CAN';
        end;

        //20211229 Igor >>>
        if not AllTrim(FetchElm(RetNo, 'T3', 5)).IsEmpty
           and
           not AllTrim(FetchElm(RetNo, 'T3', 6)).IsEmpty then
          with TSuperObject(O['telephoneNumber']) do
          begin
            S['countryCode'] := '1';
            S['areaCode'] := FetchElm(RetNo, 'T3', 5);
            S['localNumber'] := RemoveChar(FetchElm(RetNo, 'T3', 6), '-'); //20211201 Igor
          end;
        //20211229 Igor <<<
      end;
    end;

    if SameText(FetchElm(RetNo, 'T3', 137), 'X') then
    begin
      B['isNonIndividualIndicator'] := SameText(FetchElm(RetNo, 'T3', 137), 'X');
      with TSuperObject(O['nonIndividualTrusteeContactInformation']) do
      begin
        S['nonIndividualName'] := FetchElm(RetNo, 'T3', 143);
        //20211201 Igor >>>
        if not Trim(FetchElm(RetNo, 'T3', 55)).IsEmpty and not Trim(FetchElm(RetNo, 'T3', 60)).IsEmpty then
          with TSuperObject(O['contactPerson']) do
          begin
            if not Trim(FetchElm(RetNo, 'T3', 55)).IsEmpty then
              S['firstName'] := FetchElm(RetNo, 'T3', 55);
            if not Trim(FetchElm(RetNo, 'T3', 60)).IsEmpty then
              S['lastName'] := FetchElm(RetNo, 'T3', 60);
          end;
        //20211201 Igor <<<

        with TSuperObject(O['address']) do
        begin
          S['addressLineOne'] := FetchElm(RetNo, 'T3', 64);
          //S['addressLineTwo'] := '';
          S['city'] := FetchElm(RetNo, 'T3', 65);
          S['provinceTerritoryState'] := FetchElm(RetNo, 'T3', 66);
          S['globalPostalZipCode'] := ReplaceChar(FetchElm(RetNo, 'T3', 74),' ',''); //20220329
          S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3', 73));
          if S['country'].IsEmpty then
            S['country'] := 'CAN';
        end;

        //20211229 Igor >>>
        if not AllTrim(FetchElm(RetNo, 'T3', 62)).IsEmpty
           and
           not AllTrim(FetchElm(RetNo, 'T3', 63)).IsEmpty then
          with TSuperObject(O['telephoneNumber']) do
          begin
            S['countryCode'] := '1';
            S['areaCode'] := FetchElm(RetNo, 'T3', 62);
            S['localNumber'] := RemoveChar(FetchElm(RetNo, 'T3', 63), '-'); //20211201 Igor
          end;
        //20211229 Igor <<<
      end;
    end;
  end;

  //20211229 Igor >>>
  //20250314 Igor >>>

  //jz//20260306 - removed as per OpenAPI_changes_20260113.txt
  //if FetchElm(RetNo, 'T3', 142) > '' then
  //  Result.B['isMailingAddressSameAsAddressIndicator'] := true;


  If FetchElm(RetNo, 'T3', 75) > ''  Then  //20231214
  //20250314 Igor <<<
  Begin
   //Result.B['isMailingAddressSameAsAddressIndicator'] := FetchElm(RetNo, 'T3', 142) > '';  //220308
   //if not Result.B['isMailingAddressSameAsAddressIndicator'] then    //not same addres

   //why was this removed? needed for cert5 //20231214
   with TSuperObject(Result.O['mailingInformation']) do
   begin
     S['careOf'] := FetchElm(RetNo, 'T3', 75);

     with TSuperObject(O['address']) do
     begin
       S['addressLineOne'] := FetchElm(RetNo, 'T3', 21);
       //S['addressLineTwo'] := '';
       S['city'] := FetchElm(RetNo, 'T3', 57);
       S['provinceTerritoryState'] := FetchElm(RetNo, 'T3', 68);
       S['globalPostalZipCode'] := ReplaceChar(FetchElm(RetNo, 'T3', 58),' ',''); //20020329
       S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3', 24));
       if S['country'].IsEmpty then S['country'] := 'CAN';
     end;

     if not AllTrim(FetchElm(RetNo, 'T3', 12)).IsEmpty
        and
        not AllTrim(FetchElm(RetNo, 'T3', 13)).IsEmpty then
       with TSuperObject(O['telephoneNumber']) do
       begin
         S['countryCode'] := '1';
         S['areaCode'] := FetchElm(RetNo, 'T3', 12);
         S['localNumber'] := RemoveChar(FetchElm(RetNo, 'T3', 13), '-'); //20231215
       end;
   end; //end with
  end; //end if
  //20211229 Igor <<<








  //20231215
  if SameText(FetchElm(RetNo, 'T3', 16), 'X') then
  begin
    Result.B['trustResidentOnDesignatedAboriginalSettlementLandIndicator'] := TRUE;
    if (not String(FetchElm(RetNo, 'T3', 18) + FetchElm(RetNo, 'T3', 19)).IsEmpty) then
      Result.S['aboriginalSettlementNumber'] := FetchElm(RetNo, 'T3', 18) + '_' + FetchElm(RetNo, 'T3', 19);
  end;



  { ??? //20220307
  Result.B['trustResidentOnDesignatedAboriginalSettlementLandIndicator'] := SameText(FetchElm(RetNo, 'T3', 16), 'X');
  if (not String(FetchElm(RetNo, 'T3', 18) + FetchElm(RetNo, 'T3', 19)).IsEmpty) then
    Result.S['aboriginalSettlementNumber'] := FetchElm(RetNo, 'T3', 18) + '_' + FetchElm(RetNo, 'T3', 19);

  cProvinces := UpperCase(Trim(FetchElm(RetNo, 'T3', 10)));
  arrProvinces := cProvinces.Split([','], ExcludeEmpty);
  for idx := 0 to Length(arrProvinces) - 1 do
  begin
    cProvince := Trim(arrProvinces[idx]);
    if MatchText(cProvince, ['AB','BC','MB','NB','NL','NS','NT','NU','ON','PE','QC','SK','YT','EX']) then
        with Result.A['provinceOfBusiness'] do //20211215 Igor
          Add(cProvince)
    else
      raise Exception.Create(cProvince + ' is not a valid province code');
  end;
  }


  //jzmj2024_1
  //20250314 Igor >>>
  if IsMultiJurisdiction(RetNo) then
  begin
    //jz//20260314 - CRA wants it to be MJ even when GetMjAllocBusinessIncomeProv is only one, not sure that is correct but cannot find specs
    //               so, when a MJ return, whatever is put on 'T3' elm 10 is given priority and if blank then try to calc it with GetMjAllocBusinessIncomeProv
    //               NOTE: it might be the case that if it is a MJ return then provinceOfBusiness is always MJ, again cannot find specs
    if Trim(FetchElm(RetNo, 'T3', 10)) > '' then  Result.S['provinceOfBusiness'] := Trim(FetchElm(RetNo, 'T3', 10))
    else                                          Result.S['provinceOfBusiness'] := GetMjAllocBusinessIncomeProv(RetNo);
  end
  else if not Trim(FetchElm(RetNo, 'T3', 10)).IsEmpty then
    Result.S['provinceOfBusiness'] := FetchElm(RetNo, 'T3', 10);
  //20250314 Igor <<<

  //20220307
  with TSuperObject(Result.O['trustResidencyInformation']) do
  begin
    if not Trim(FetchElm(RetNo, 'T3', 22)).IsEmpty then
      S['becameResident'] := FetchElm(RetNo, 'T3', 22);
    if not Trim(FetchElm(RetNo, 'T3', 52)).IsEmpty then
      S['ceasedResidency'] := FetchElm(RetNo, 'T3', 52);

    B['trustDeemedCanadianResidentIndicator'] := SameText(FetchElm(RetNo, 'T3', 56), 'X');
    //if not Trim(FetchElm(RetNo, 'T3', 56)).IsEmpty then  S['trustDeemedCanadianResidentIndicator'] :=FetchElm(RetNo, 'T3', 56);    //20220307
    if not Trim(FetchElm(RetNo, 'T3', 61)).IsEmpty then
      S['deemedResidentCountry'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3', 61));
    if (SameText(FetchElm(RetNo, 'T3', 47), 'X')) then
      S['languageOfCorrespondence'] := 'ENGLISH'
    else if (SameText(FetchElm(RetNo, 'T3', 59), 'X')) then
      S['languageOfCorrespondence'] := 'FRENCH';
  end;
  //20220120 Igor <<<


  {
  with TSuperObject(Result.O['trustResidencyInformation']) do
  begin
    if not Trim(FetchElm(RetNo, 'T3', 22)).IsEmpty then
      S['becameResident'] := FetchElm(RetNo, 'T3', 22);
    if not Trim(FetchElm(RetNo, 'T3', 52)).IsEmpty then
      S['ceasedResidency'] := FetchElm(RetNo, 'T3', 52);
    B['trustDeemedCanadianResidentIndicator'] := SameText(FetchElm(RetNo, 'T3', 56), 'X');
    if not Trim(FetchElm(RetNo, 'T3', 61)).IsEmpty then
      S['deemedResidentCountry'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3', 61));
    if (SameText(FetchElm(RetNo, 'T3', 47), 'X')) then
      S['languageOfCorrespondence'] := 'ENGLISH'
    else if (SameText(FetchElm(RetNo, 'T3', 59), 'X')) then
      S['languageOfCorrespondence'] := 'FRENCH';
  end;
  //20220120 Igor <<<
  }
end;

function GenerateJsonTrustTypeInformation(RetNo:Integer): ISuperObject; //20211130 Igor //20220120 Igor
var cTrustType: string;
begin
  Result := SO;
  If FetchElm(RetNo, 'T3', 43)>'' then cTrustType := 'TYPE_903';
  If FetchElm(RetNo, 'T3', 45)>'' then cTrustType := 'TYPE_904';
  If FetchElm(RetNo, 'T3', 81)>'' Then cTrustType := 'TYPE_'+FetchElm(RetNo, 'T3', 81);
  {//20220309
  cTrustType := FetchElm(RetNo, 'T3', 81);
  if cTrustType.IsEmpty then
    cTrustType := 'TYPE_903';
  if not cTrustType.StartsWith('TYPE_') then
    cTrustType := 'TYPE_' + cTrustType;
  }
  Result.S['trustType'] := cTrustType;

// changed to y/n rather than x box
// any reason for the if?
//  if FetchElm(RetNo,'T3',51)>'' then //intervivos  //20220311
//  Begin
     //Result.B['isNonProfitOrganizationIndicator'] := SameText(FetchElm(RetNo, 'T3', 84), 'X');
//   end;

 //20230105 changed to y/n rather than x box
  if FetchElm(RetNo, 'T3', 84)='Y' then
    Result.B['isNonProfitOrganizationIndicator'] := true;
  if FetchElm(RetNo, 'T3', 84)='N' then
    Result.B['isNonProfitOrganizationIndicator'] := false;

  if not Trim(FetchElm(RetNo, 'T3', 44)).IsEmpty then
    Result.S['nonProfitBusinessNumber'] := FetchElm(RetNo, 'T3', 44);
  if not Trim(FetchElm(RetNo, 'T3', 51)).IsEmpty then
    Result.S['trustCreationDate'] := FetchElm(RetNo, 'T3', 51);
  if not Trim(FetchElm(RetNo, 'T3', 20)).IsEmpty then
    Result.S['testatorDeathDate'] := FetchElm(RetNo, 'T3', 20); //46 ??
  if not Trim(FetchElm(RetNo, 'T3', 25)).IsEmpty then
    Result.S['deceasedSocialInsuranceNumber'] := FetchElm(RetNo, 'T3', 25);
end;

function GenerateJsonFilingInformation(RetNo:Integer): ISuperObject; //20211130 Igor
begin
  Result := SO;
  Result.S['trustFiscalPeriodStart'] := FetchElm(RetNo, 'T3', 14);
  Result.S['trustFiscalPeriodEnd'] := FetchElm(RetNo, 'T3', 17);
  Result.B['firstYearFilingIndicator'] := SameText(FetchElm(RetNo, 'T3', 27), 'X');
  if FetchElm(RetNo,'T3',27)='X' then //20220329
  begin
    //Do nothing first year

    //no, if first year says to do this??
    //why removed? required in cert5, changed ATTACHED to SENT //20231214  {//20220312
    if (SameText(FetchElm(RetNo, 'T3', 29), 'X')) then
      Result.S['trustDocumentFilingMethod'] := 'SENT'
    else if (SameText(FetchElm(RetNo, 'T3', 72), 'X')) then
      Result.S['trustDocumentFilingMethod'] := 'WITH_T3_APP'
    else if (SameText(FetchElm(RetNo, 'T3', 30), 'X')) then
      Result.S['trustDocumentFilingMethod'] := 'WITH_T1';

  end
  Else
   Result.I['previousFilingYear'] := MyStrToInt(FetchElm(RetNo, 'T3', 28));

  Result.B['trustFinalReturnIndicator'] := SameText(FetchElm(RetNo, 'T3', 49), 'X'); //20211227 Igor
  if not Trim(FetchElm(RetNo, 'T3', 54)).IsEmpty then
    Result.S['trustWindupDate'] := FetchElm(RetNo, 'T3', 54);
end;

function GenerateJsonOtherInformation(RetNo:Integer): ISuperObject; //20211130 Igor
begin
  //T3ret jacket required questions, line 1 - 12 , 13 - 14
  Result := SO;
  Result.B['electingTrustIndicator']                              := SameText(FetchElm(RetNo,   'T3', 128), 'X');
  if not Trim(FetchElm(RetNo, 'T3', 129)).IsEmpty then
    Result.I['trustNonResidentIncomeElectionYear']                := MyStrToInt(FetchElm(RetNo, 'T3', 129));
  Result.B['trustIncomePaymentToBeneficiariesRequired']           := SameText(FetchElm(RetNo,   'T3', 131), 'X');
  Result.B['trustDistributedNonCashAssetsToBeneficiary']          := SameText(FetchElm(RetNo,   'T3', 135), 'X');
  Result.B['trustBeneficiariesChanged']                           := SameText(FetchElm(RetNo,   'T3', 33), 'X');
  Result.B['trustDeemedDispositionBeneficiaryDeathIndicator']     := SameText(FetchElm(RetNo,   'T3', 35), 'X');
  if not Trim(FetchElm(RetNo, 'T3', 42)).IsEmpty then
    Result.S['trustDeemedDispositionBeneficiaryDeathDate']        := FetchElm(RetNo, 'T3', 42);
  Result.B['trustNonArmsLengthDebtTransactionIndicator']          := SameText(FetchElm(RetNo,   'T3', 139), 'X');
  if not Trim(FetchElm(RetNo, 'T3', 150)).IsEmpty then
    Result.I['trustNonArmsLengthDebtTransactionYear']             := MyStrToInt(FetchElm(RetNo, 'T3', 150));
  Result.B['trustCapitalIncomeInterestOwnershipChangeIndicator']  := SameText(FetchElm(RetNo,   'T3', 37), 'X');
  if not Trim(FetchElm(RetNo, 'T3', 41)).IsEmpty then
    Result.I['trustCapitalIncomeInterestOwnershipChangeYear']     := MyStrToInt(FetchElm(RetNo, 'T3', 41));
  Result.B['trustHoldsSharesInPrivateCorporation']                := SameText(FetchElm(RetNo,   'T3', 39), 'X');
  Result.B['trustAdditionalContributionPropertyReceiptIndicator'] := SameText(FetchElm(RetNo,   'T3', 158), 'X');
  if not Trim(FetchElm(RetNo, 'T3', 159)).IsEmpty then
    Result.I['trustAdditionalContributionPropertyReceiptYear']    := MyStrToInt(FetchElm(RetNo, 'T3', 159));
  Result.B['publicTrust']                                         := SameText(FetchElm(RetNo,   'T3', 141), 'X');
  Result.B['trustUsedInternationalFinancialReportingStandards']   := SameText(FetchElm(RetNo,   'T3', 153), 'X');
  Result.B['trustLossRestrictionEventIndicator']                  := SameText(FetchElm(RetNo,   'T3', 70), 'X');
  if not Trim(FetchElm(RetNo, 'T3', 69)).IsEmpty then
    Result.I['trustLossRestrictionEventDate']                     := MyStrToInt(FetchElm(RetNo, 'T3', 69));



  //NOT SURE WHY THIS WAS REMOVED ?? SAYS : "con checked advised by john", I DEFINITELY DID NOT ADVISE THIS

  // 20230320 if FetchElm(RetNo, 'T3', 78)>'' then Result.B['assetsHeldListedUnderParagraph150NotExceeding50kIndicator'] := True;   //SameText(FetchElm(RetNo, 'EFMEMO', 38), 'X'); //20211227 Igor
  //Else Result.B['assetsHeldListedUnderParagraph150NotExceeding50kIndicator'] := False; //20220314  //SameText(FetchElm(RetNo, 'EFMEMO', 38), 'X'); //20211227 Igor

  {//20230320    //con checked advised by john
  If FetchElm(RetNo, 'T3', 80)>'' then Result.B['trustRequiredToHoldFundsUnderRelevantRulesIndicator']        := True;  //SameText(FetchElm(RetNo, 'EFMEMO', 37), 'X'); //20211227 Igor
  }

  {
  //not sure why it was changed from sametext, does it not work????
Result.B['assetsHeldListedUnderParagraph150NotExceeding50kIndicator'] := SameText(FetchElm(RetNo, 'EFMEMO', 38), 'X'); //20211227 Igor
Result.B['trustRequiredToHoldFundsUnderRelevantRulesIndicator'] := SameText(FetchElm(RetNo, 'EFMEMO', 37), 'X'); //20211227 Igor
  }

  //20231129
  //20250314 Igor >>>
  if FetchElm(RetNo, 'T3', 79)>'' then
    Result.B['assetsHeldListedUnderParagraph150NotExceeding50kIndicator'] := True
  Else
    Result.B['assetsHeldListedUnderParagraph150NotExceeding50kIndicator'] := False;

  If FetchElm(RetNo, 'T3', 144)>'' then
    Result.B['trustRequiredToHoldFundsUnderRelevantRulesIndicator'] := True
  Else
    Result.B['trustRequiredToHoldFundsUnderRelevantRulesIndicator'] := False;

  If FetchElm(RetNo, 'T3', 176)>'' then
    Result.B['interestOrFinancingExpensesIndicator'] := True
  Else
    Result.B['interestOrFinancingExpensesIndicator'] := False;

  If FetchElm(RetNo, 'T3', 178)>'' then
    Result.B['unitTrustUnderSubSection108Indicator'] := True
  Else
    Result.B['unitTrustUnderSubSection108Indicator'] := False;

  If FetchElm(RetNo, 'T3', 165)>'' then
    Result.B['trustWhichAllUnitsListedOnStockExchangeIndicator'] := True
  Else
    Result.B['trustWhichAllUnitsListedOnStockExchangeIndicator'] := False;
  //20250314 Igor <<<

  //jz//20260201 - add new indicator
  If FetchElm(RetNo, 'T3', 183)>'' then
    Result.B['trustMeetConditionsInParagraph150Indicator'] := True
  Else
    Result.B['trustMeetConditionsInParagraph150Indicator'] := False;

  //jz//20260201 - add new indicator
  If FetchElm(RetNo, 'T3', 185)>'' then
    Result.B['propertyForSpecifiedPurposeIndicator'] := True
  Else
    Result.B['propertyForSpecifiedPurposeIndicator'] := False;

  //jz//20260201 - add new indicator
  If            FetchElm(RetNo, 'T3', 187)>'' then
    Result.B['indigenousGroupsIndicator'] := True
  Else
    Result.B['indigenousGroupsIndicator'] := False;



  //20260109 Igor >>>
  //Result.B['trustUsedInternationalFinancialReportingStandards']:= SameText(FetchElm(RetNo, 'T3', 183), 'X'); //What parameter name should be for new field??? //20260109 Igor
  //Result.B['trustUsedInternationalFinancialReportingStandards']:= SameText(FetchElm(RetNo, 'T3', 185), 'X'); //What parameter name should be for new field??? //20260109 Igor
  //Result.B['trustUsedInternationalFinancialReportingStandards']:= SameText(FetchElm(RetNo, 'T3', 187), 'X'); //What parameter name should be for new field??? //20260109 Igor
  //20260109 Igor <<<
{

  Result := SO;
  Result.B['electingTrustIndicator'] := SameText(FetchElm(RetNo, 'EFMEMO', 6), 'X'); //20211227 Igor
  if not Trim(FetchElm(RetNo, 'T3', 129)).IsEmpty then
    Result.I['trustNonResidentIncomeElectionYear'] := MyStrToInt(FetchElm(RetNo, 'T3', 129));
  Result.B['trustIncomePaymentToBeneficiariesRequired'] := SameText(FetchElm(RetNo, 'EFMEMO', 7), 'X'); //20211227 Igor
  Result.B['trustDistributedNonCashAssetsToBeneficiary'] := SameText(FetchElm(RetNo, 'EFMEMO', 8), 'X'); //20211227 Igor
  Result.B['trustBeneficiariesChanged'] := SameText(FetchElm(RetNo, 'EFMEMO', 10), 'X'); //20211227 Igor
  Result.B['trustDeemedDispositionBeneficiaryDeathIndicator'] := SameText(FetchElm(RetNo, 'EFMEMO', 11), 'X'); //20211227 Igor
  if not Trim(FetchElm(RetNo, 'T3', 42)).IsEmpty then
    Result.S['trustDeemedDispositionBeneficiaryDeathDate'] := FetchElm(RetNo, 'T3', 42);
  Result.B['trustNonArmsLengthDebtTransactionIndicator'] := SameText(FetchElm(RetNo, 'EFMEMO', 12), 'X'); //20211227 Igor
  if not Trim(FetchElm(RetNo, 'T3', 150)).IsEmpty then
    Result.I['trustNonArmsLengthDebtTransactionYear'] := MyStrToInt(FetchElm(RetNo, 'T3', 150));
  Result.B['trustCapitalIncomeInterestOwnershipChangeIndicator'] := SameText(FetchElm(RetNo, 'EFMEMO', 13), 'X'); //20211227 Igor
  if not Trim(FetchElm(RetNo, 'T3', 41)).IsEmpty then
    Result.I['trustCapitalIncomeInterestOwnershipChangeYear'] := MyStrToInt(FetchElm(RetNo, 'T3', 41));
  Result.B['trustHoldsSharesInPrivateCorporation'] := SameText(FetchElm(RetNo, 'EFMEMO', 14), 'X'); //20211227 Igor
  Result.B['trustAdditionalContributionPropertyReceiptIndicator'] := SameText(FetchElm(RetNo, 'EFMEMO', 15), 'X'); //20211227 Igor
  if not Trim(FetchElm(RetNo, 'T3', 159)).IsEmpty then
    Result.I['trustAdditionalContributionPropertyReceiptYear'] := MyStrToInt(FetchElm(RetNo, 'T3', 159));
  Result.B['publicTrust'] := SameText(FetchElm(RetNo, 'EFMEMO', 16), 'X'); //20211227 Igor
  Result.B['trustUsedInternationalFinancialReportingStandards'] := SameText(FetchElm(RetNo, 'T3', 153), 'X'); //20211227 Igor
  Result.B['trustLossRestrictionEventIndicator'] := SameText(FetchElm(RetNo, 'EFMEMO', 70), 'X');
  if not Trim(FetchElm(RetNo, 'T3', 69)).IsEmpty then
    Result.I['trustLossRestrictionEventDate'] := MyStrToInt(FetchElm(RetNo, 'T3', 69));
  //20220120 Igor >>>

  //20220308  //File compare did not like it - developer

  //20220312
  if FetchElm(RetNo, 'EFMEMO', 38)>'' then
    Result.B['assetsHeldListedUnderParagraph150NotExceeding50kIndicator'] := True;   //SameText(FetchElm(RetNo, 'EFMEMO', 38), 'X'); //20211227 Igor
  //Else Result.B['assetsHeldListedUnderParagraph150NotExceeding50kIndicator'] := False; //20220314  //SameText(FetchElm(RetNo, 'EFMEMO', 38), 'X'); //20211227 Igor

  If FetchElm(RetNo, 'EFMEMO', 37)>'' then
   Result.B['trustRequiredToHoldFundsUnderRelevantRulesIndicator'] := True;  //SameText(FetchElm(RetNo, 'EFMEMO', 37), 'X'); //20211227 Igor
  //Else Result.B['trustRequiredToHoldFundsUnderRelevantRulesIndicator'] := False; //20220314 //SameText(FetchElm(RetNo, 'EFMEMO', 37), 'X'); //20211227 Igor
  {
  Result.B['assetsHeldListedUnderParagraph150NotExceeding50kIndicator'] := SameText(FetchElm(RetNo, 'EFMEMO', 38), 'X'); //20211227 Igor
  Result.B['trustRequiredToHoldFundsUnderRelevantRulesIndicator'] := SameText(FetchElm(RetNo, 'EFMEMO', 37), 'X'); //20211227 Igor
  }
  //20220120 Igor <<<
end;

function GenerateJsonMemoIndicators(RetNo:Integer): ISuperObject; //20211123 Igor //20211227 Igor
var indicatorStatus : boolean;
begin
  Result := SO;
  Result.B['alterEgoIndicator'] := SameText(FetchElm(RetNo, 'EFMEMO', 36), 'X');
  Result.B['preferredBeneficiaryIndicator'] := SameText(FetchElm(RetNo, 'EFMEMO', 35), 'X');

  indicatorStatus := SameText(FetchElm(RetNo, 'EFMEMO', 22), 'X');
  Result.B['mutualFundReorganizatonIndicator'] := indicatorStatus;
  if indicatorStatus then
   Result.S['mutualFundReorganizatonDate'] := FetchElm(RetNo, 'EFMEMO', 54);

  Result.B['mutualFundExtensionApprovalIndicator'] := SameText(FetchElm(RetNo, 'EFMEMO', 21), 'X');

  indicatorStatus := SameText(FetchElm(RetNo, 'EFMEMO', 20), 'X');
  Result.B['insuranceSegregatedFundReorganizationIndicator'] := indicatorStatus;
  if indicatorStatus then
   Result.S['insuranceSegregatedFundReorganizationDate'] := FetchElm(RetNo, 'EFMEMO', 55);

  Result.B['insuranceSegregatedFundExtensionApprovalIndicator'] := SameText(FetchElm(RetNo, 'EFMEMO', 19), 'X');
  Result.B['mutualFundElectingDec15FPEIndicator'] := SameText(FetchElm(RetNo, 'EFMEMO', 18), 'X');
end;

function GenerateReturnLines(RetNo:Integer;Section:string;InstNo:Integer = -1): ISuperArray; //20211123 Igor
		  //20260312 Igor >>>
		  function CheckSymbolsAfterPoint(aFloatVal: string = '0'): string;
		  begin
		    if (Length(aFloatVal) > 0) and (Pos('.', aFloatVal) = 0) then
		      Result:= aFloatVal + '.00'
		    else
		    if (Pos('.', aFloatVal) > 0) then
		    begin
		      if ((Length(aFloatVal) - Pos('.', aFloatVal)) = 1) then
		        Result:= aFloatVal + '0'
		      else
		        Result:= aFloatVal;
		    end else
		      Result:= aFloatVal;
		  end;
		  //20260312 Igor <<<
var Eflines: TStringList;
    A: TArray<string>;
    Line, Value, FormName, FieldType: string;
    I, Counter, ElmId, RuleId, LLine: integer; //20211223 Igor
    //20220321 Igor >>>
    ElmIdYes, ElmIdNo: integer;
    HasTwoElms: boolean;
    Elms, ValueYes, ValueNo: string;
    //20220321 Igor <<<

    rVal:real;
begin
  Result := SA;
  Eflines := TStringList.Create;
  try
    Eflines.LoadFromFile(AppDir+'\'+'EFLINE.D');
    Counter := 0;
    for I := 0 to Eflines.Count - 1 do
    begin
      HasTwoElms := false; //20220321 Igor 
      if Trim(Eflines.Strings[I]) = '' then continue;
      A := Eflines.Strings[I].Split(['|']);
      if Length(A) < 5 then continue;
      if not SameText(Trim(A[4]), Section) then continue;
      Line := Trim(A[0]);

      //If (LeftStr(line,2)='12') then ShowMessage('Line ;= '+Line);   //2202030707

      FieldType := Trim(A[1]);
      FormName := Trim(A[2]);
      if InstNo <> -1 then
        FormName := FormName + '#' + IntToStr(InstNo);

      if (IsMultiJurisdiction(RetNo)) and ( (FormName = 'T3AB') or (FormName = 'T3BC') or (FormName = 'T3MB') or
                                            (FormName = 'T3NB') or (FormName = 'T3NL') or (FormName = 'T3NS') or
                                            (FormName = 'T3NT') or (FormName = 'T3NU') or (FormName = 'T3ON') or
                                            (FormName = 'T3PE') or (FormName = 'T3SK') or (FormName = 'T3YT')
                                          )
      then
      begin
        if FormName = 'T3SK' then //not the same elms as reg form, continue until find the MJ version
          continue;

        FormName := 'T3MJ' + FormName[3] + FormName[4];
      end
      else if not IsMultiJurisdiction(RetNo) then
      begin
        if pos('MJ', FormName) > 0 then
          continue;
      end;


      //jz//20260313 - why is this done?? remove
      //if (Line.Equals('13401') or Line.Equals('13402') or Line.Equals('13410') or Line.Equals('13412') or Line.Equals('13414') or Line.Equals('13415') or Line.Equals('13418'))
      //and (not GetShortPrv(FetchElm(RetNo, 'T3', 9)).Equals('ON') or ((FetchElm(RetNo, 'T3', 9)).IsEmpty and FetchElm(RetNo, 'T3', 67).Equals('ON'))) then continue; //20260204 Igor


      //20211126 Igor >>>
      // skip if form has no data
      //jz//2026 - add "if not IsEfOverride" condition so overrides do no depend on form having data
      If (not Ret[RetNo].FormHasData[FormName]) and (not IsEfOverride(RetNo, MyStrToInt(Line))) then
        continue;
      //20211126 Igor <<<

      //20220321 Igor >>>
      Elms := Trim(A[3]);
      if SameText(FieldType, 'B') and (Pos(',', Elms) > 0) then
      begin
        HasTwoElms := true;
        ElmIdYes := StrToIntDef(Copy(Elms, 1, Pos(',', Elms) - 1), 0);
        ElmIdNo := StrToIntDef(Copy(Elms, Pos(',', Elms) + 1, Length(Elms)), 0);
        if ElmIdYes = 0 then
          raise Exception.Create('ElmdId for Yes edit is incorrect in EFLINE.D as line '+ IntToStr(I));
        if ElmIdNo = 0 then
          raise Exception.Create('ElmdId for No edit is incorrect in EFLINE.D as line '+ IntToStr(I));
        ValueYes := FetchElm(RetNo, FormName, ElmIdYes);
        ValueNo := FetchElm(RetNo, FormName, ElmIdNo);
        Value := '';
        if not ValueYes.IsEmpty then
          Value := '1'
        else if not ValueNo.IsEmpty then
          Value := '2';
      end
      else
      begin
        ElmId := StrToIntDef(Elms, 0);
        if ElmId = 0 then
          raise Exception.Create('ElmdId is incorrect in EFLINE.D as line '+ IntToStr(I));
        {RuleId := 0;
        if Length(A) >= 4 then
          RuleId := StrToIntDef(A[3], 0);
        if RuleId <> 0 then
          Value := DoRules(RetNo, RuleId)
        else
          Value := FetchElm(RetNo, FormName, ElmId);}
        Value := FetchElm(RetNo, FormName, ElmId);
      end;
      //20220321 Igor <<<

      //20211223 Igor >>>
      LLine := MyStrToInt(Line);
      If (LLine > 0) and IsEFOverride(RetNo, LLine) then
        Value := GetEFOverride(RetNo, LLine);
      //20211223 Igor <<<

      if not Line.IsEmpty and (not Value.IsEmpty or (SameText(FieldType, 'B') and not HasTwoElms)) then //20220321 Igor
      begin
        with TSuperObject(Result.O[Counter]) do
        begin
          S['fieldCode'] := Line;
          if SameText(FieldType, 'B') then
          begin
            //20220321 Igor >>>
            if HasTwoElms then
              I['fieldValue'] := StrToInt(Value)
            else if SameText(Value, 'X') then
              I['fieldValue'] := 1
            else
              I['fieldValue'] := 2;
            //20220321 Igor <<<
          end
          //20211126 Igor >>>
          else if SameText(FieldType, '$') or SameText(FieldType, 'N') then //20240118 Igor
            I['fieldValue'] := Trunc(SimpleRoundTo(Vl(Value), 0)) //20250318 Igor
          //20211126 Igor <<<

          //20231218
          else if SameText(FieldType, 'S') then
          begin
            S['fieldValue'] := Value
          end
          else if SameText(FieldType, 'D') then
          begin
            Value := StringReplace(Value, '-', '',[rfReplaceAll, rfIgnoreCase]);
            Value := StringReplace(Value, '/', '',[rfReplaceAll, rfIgnoreCase]);
            Value := StringReplace(Value, '' , '',[rfReplaceAll, rfIgnoreCase]);
            S['fieldValue'] := Value;
          end
          else if SameText(FieldType, '$/c') then
          begin
            xx:=StrToFloat(CheckSymbolsAfterPoint(Value));

            //jz//20260313
            //StrToFloat(CheckSymbolsAfterPoint(Value)); added by Alex in hopes of solving .00 not showing with full amounts
            //didnt seem to work, solve with manuallyfixNoDecimalOnDollarCentsIssueBecauseCouldntDoItRight for now
            F['fieldValue']:= StrToFloat(CheckSymbolsAfterPoint(Value)); //20260312 Igor //F['fieldValue']:= Vl(Value);

            //S['fieldValue'] := FormatFloat( '0.00', Vl(Value) ) ;  ////20231218 make show both decimals  //F['fieldValue'] := Vl(Value);
          end
          else
          begin
            F['fieldValue'] := Vl(Value);
          end;

        end;
        Inc(Counter);
      end;
    end; //i efline
  finally
    Eflines.Free;
  end;
end;

function GenerateT776Submissions(RetNo:Integer): ISuperArray; //20220120 Igor
var InstNo, J, FNo, Counter, Counter2: integer;
    cFormName, cTemp, cNameAndAddress, cAmount, cValue: string;
    CoOwners, RentalProperties: ISuperArray;

const arrCoOwners: array[0..5,0..4] of integer =
  (
    (22,117,119,23,24),
    (25,26,121,27,28),
    (29,30,123,31,32),
    (33,34,125,35,36),
    (37,38,127,39,40),
    (41,42,129,43,44)
  );

begin
  cFormName := 'T776';
  Result := SA;
  InstNo := 1;
  Counter := 0;
  while True do
  begin
    FNo := GetFormNo(cFormName+'#'+AllTrim(IntToStr(InstNo)));
    if FNo > 0 then
    begin
      with TSuperObject(Result.O[Counter]) do
      begin
        S['fullName'] := FetchElm(RetNo, FNo, 1);

        if FetchElm(RetNo, FNo, 2) > '' then S['socialInsuranceNumber'] := FetchElm(RetNo, FNo, 2);

        with TSuperObject(O['businessAddress']) do
        begin
          S['streetAddress'] := FetchElm(RetNo, FNo, 110);
          //S['streetAddressLine2'] := '';
          S['city'] := FetchElm(RetNo, FNo, 112);
          S['province'] := FetchElm(RetNo, FNo, 120);
          S['postalCode'] := ReplaceChar(FetchElm(RetNo, FNo, 111),' ',''); //20220329
        end;
        S['fiscalPeriodStart'] := FetchElm(RetNo, FNo, 3);
        S['fiscalPeriodEnd'] := FetchElm(RetNo, FNo, 6); //20211215 Igor
        B['finalYearOfRentalOperationIndicator'] := SameText(FetchElm(RetNo, FNo, 9), 'X');
        I['partnershipPercent'] := MyStrToInt(FetchElm(RetNo, FNo, 18)); //20211215 Igor
        S['naicsCode'] := FetchElm(RetNo, FNo, 19);
        //20220331
        if FetchElm(RetNo, FNo, 13)>'' then S['taxShelterIdentificationNumber'] := FetchElm(RetNo, FNo, 13);
        if FetchElm(RetNo, FNo, 11)>'' then S['partnershipBusinessNumber'] := FetchElm(RetNo, FNo, 11);
        //S['preparerName'] := FetchElm(RetNo, FNo, 12);
        if FetchElm(RetNo, FNo, 15)>'' then S['businessAccountNumber'] := FetchElm(RetNo, FNo, 15);

        CoOwners := SA;
        Counter2 := 0;
        for J := 0 to 5 do
        begin
          cNameAndAddress := '';
          cTemp := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][0]));
          if not cTemp.IsEmpty then
            cNameAndAddress := cNameAndAddress + ' ' + cTemp;
          cTemp := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][1]));
          if not cTemp.IsEmpty then
            cNameAndAddress := cNameAndAddress + ' ' + cTemp;
          cTemp := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][2]));
          if not cTemp.IsEmpty then
            cNameAndAddress := cNameAndAddress + ' ' + cTemp;
          cNameAndAddress := Trim(cNameAndAddress);
          cAmount := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][3]));
          cValue := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][4]));
          if not cNameAndAddress.IsEmpty and not cAmount.IsEmpty and not cValue.IsEmpty then
          begin
            with CoOwners.O[Counter2] do
            begin
              S['nameAndAddress'] := cNameAndAddress;
              F['netLossOrIncome'] := Vl(cAmount);
              I['ownershipPercentage'] := MyStrToInt(cValue);
            end;
            inc(Counter2);
          end;
        end;
        if CoOwners.Length > 0 then
          A['coOwnersDetails'] := CoOwners;

        RentalProperties := SA;
        Counter2 := 0;
        for J in [45,48,51] do
        begin
          cNameAndAddress := Trim(FetchElm(RetNo, FNo, J));
          cAmount := Trim(FetchElm(RetNo, FNo, J+1));
          cValue := Trim(FetchElm(RetNo, FNo, J+2));
          if not cNameAndAddress.IsEmpty and not cAmount.IsEmpty and not cValue.IsEmpty then
          begin
            with RentalProperties.O[Counter2] do
            begin
              S['rentalPropertiesAddress'] := cNameAndAddress;
              I['numberOfUnits'] := MyStrToInt(cAmount);
              I['grossRents'] := MyStrToInt(cValue);
            end;
            inc(Counter2);
          end;
        end;
        if RentalProperties.Length > 0 then
          A['rentalPropertiesIncome'] := RentalProperties;

        A['returnLines'] := GenerateReturnLines(RetNo, cFormName, InstNo);
      end;
      Inc(Counter);
    end
    else
      break;
    inc(InstNo);
  end;
end;

function GenerateT2125Submissions(RetNo:Integer): ISuperArray; //20220120 Igor
var InstNo, J, FNo, Counter, Counter2: integer;
    cFormName, cTemp, cNameAndAddress, cAmount, cValue, Val: string;
    WebPageAddresses, CoOwners: ISuperArray;

const arrCoOwners: array[0..4,0..6] of integer =
  (
    (257,239,236,78,60,237,238),
    (258,248,245,61,62,240,241),
    (259,264,263,63,64,243,244),
    (260,267,266,65,67,246,247),
    (261,270,269,68,69,249,250)
  );

begin
  cFormName := 'T2125';
  Result := SA;
  InstNo := 1;
  Counter := 0;
  while True do
  begin
    FNo := GetFormNo(cFormName+'#'+AllTrim(IntToStr(InstNo)));
    if FNo > 0 then
    begin
      with TSuperObject(Result.O[Counter]) do
      begin
        S['fullName'] := FetchElm(RetNo, FNo, 1) + ' ' + FetchElm(RetNo, FNo, 2); //mjjz2024 //FetchElm(RetNo, FNo, 2); // + ' ' + FetchElm(RetNo, FNo, 2); //T3 only //20220309
        S['socialInsuranceNumber'] := StringReplace(FetchElm(RetNo, FNo, 3), '-', '',[rfReplaceAll, rfIgnoreCase]); //FetchElm(RetNo, FNo, 3);
        S['businessName'] := FetchElm(RetNo, FNo, 8);
        S['businessAccountNumber'] := FetchElm(RetNo, FNo, 19);
        with TSuperObject(O['businessAddress']) do
        begin
          S['streetAddress'] := FetchElm(RetNo, FNo, 10);
          //S['streetAddressLine2'] := '';
          S['city'] := FetchElm(RetNo, FNo, 13);
          S['province'] := FetchElm(RetNo, FNo, 53);
          S['postalCode'] := ReplaceChar(FetchElm(RetNo, FNo, 14),' ',''); //20220329
        end;
        S['fiscalPeriodStart'] := FetchElm(RetNo, FNo, 4);
        S['fiscalPeriodEnd'] := FetchElm(RetNo, FNo, 5);
        B['finalBusinessYearIndicator'] := SameText(FetchElm(RetNo, FNo, 6), 'X');

        val := FetchElm(RetNo, FNo, 9); if val > '' then S['mainProductOrService'] := val;  //jz//20260320 - exclude if blank

        S['naicsCode'] := FetchElm(RetNo, FNo, 12);
        if SameText(FetchElm(RetNo, FNo, 22), 'X') then
          S['accountingMethodType'] := 'CASH'
        else if SameText(FetchElm(RetNo, FNo, 11), 'X') then
          S['accountingMethodType'] := 'ACCRUAL'; //20211215 Igor
        if not FetchElm(RetNo, FNo, 16).IsEmpty then
          S['taxShelterIdentificationNumber'] := FetchElm(RetNo, FNo, 16);
        if not FetchElm(RetNo, FNo, 15).IsEmpty then
          S['partnershipBusinessNumber'] := FetchElm(RetNo, FNo, 15);
        if not FetchElm(RetNo, FNo, 18).IsEmpty then
          I['partnershipPercent'] := MyStrToInt(FetchElm(RetNo, FNo, 18));
        {
        // TODO our form contains two lines for preparer name and address, probably it should be changed to match json schema
        S['preparerName'] := FetchElm(RetNo, FNo, 12);
        with TSuperObject(O['preparerAddress']) do
        begin
          S['streetAddress'] := FetchElm(RetNo, FNo, 14);
          S['streetAddressLine2'] := '';
          S['city'] := FetchElm(RetNo, FNo, 16);
          S['province'] := FetchElm(RetNo, FNo, 17);
          S['postalCode'] := FetchElm(RetNo, FNo, 118);
        end;
        }

        if Vl(FetchElm(RetNo,FNo,49))=0 then
        //do nothing  //20220309
        Else
        Begin
         if not FetchElm(RetNo, FNo, 49).IsEmpty then
           I['incomeEarnedWebPageCount'] := MyStrToInt(FetchElm(RetNo, FNo, 49));

         WebPageAddresses := SA;
         Counter2 := 0;
         for J in [25,27,47,48,50] do
         begin
           cValue := Trim(FetchElm(RetNo, FNo, J));
           if not cValue.IsEmpty then
           begin
             with WebPageAddresses.O[Counter2] do
             begin
               S['uniformResourceLocator'] := cValue;
             end;
             inc(Counter2);
           end;
         end;
         if WebPageAddresses.Length > 0  then A['webPageAddress'] := WebPageAddresses;
         I['internetGrossIncomePercent'] := MyStrToInt(FetchElm(RetNo, FNo, 51));
        end;


        CoOwners := SA;
        Counter2 := 0;
        for J := 0 to 4 do
        begin
          cNameAndAddress := '';
          cTemp := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][0]));
          if not cTemp.IsEmpty then
            cNameAndAddress := cNameAndAddress + ' ' + cTemp;
          cTemp := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][1]));
          if not cTemp.IsEmpty then
            cNameAndAddress := cNameAndAddress + ' ' + cTemp;
          cTemp := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][2]));
          if not cTemp.IsEmpty then
            cNameAndAddress := cNameAndAddress + ' ' + cTemp;
          cTemp := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][3]));
          if not cTemp.IsEmpty then
            cNameAndAddress := cNameAndAddress + ' ' + cTemp;
          cTemp := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][4]));
          if not cTemp.IsEmpty then
            cNameAndAddress := cNameAndAddress + ' ' + cTemp;
          cNameAndAddress := Trim(cNameAndAddress);
          cAmount := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][5]));
          cValue := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][6]));
          if not cNameAndAddress.IsEmpty and not cAmount.IsEmpty and not cValue.IsEmpty then
          begin
            with CoOwners.O[Counter2] do
            begin
              S['nameAndAddress'] := cNameAndAddress;
              S['netLossOrIncome'] := cAmount;
              S['ownershipPercentage'] := cValue;
            end;
            inc(Counter2);
          end;
        end;
        if CoOwners.Length > 0 then
          A['coOwnersDetails'] := CoOwners;
        A['returnLines'] := GenerateReturnLines(RetNo, cFormName, InstNo);
      end;
      Inc(Counter);
    end
    else
      break;
    inc(InstNo);
  end;
end;

function GenerateT2121Submissions(RetNo:Integer): ISuperArray; //20220120 Igor
var InstNo, J, FNo, Counter, Counter2: integer;
    cFormName, cTemp, cNameAndAddress, cAmount, cValue: string;
    WebPageAddresses, CoOwners: ISuperArray;

const arrCoOwners: array[0..4,0..6] of integer =
  (
    (503,537,506,269,270,504,505),
    (507,539,510,271,272,508,509),
    (511,541,514,273,274,512,513),
    (515,543,518,275,276,516,517),
    (519,545,522,283,284,520,521)
  );

begin
  cFormName := 'T2121';
  Result := SA;
  InstNo := 1;
  Counter := 0;
  while True do
  begin
    FNo := GetFormNo(cFormName+'#'+AllTrim(IntToStr(InstNo)));
    if FNo > 0 then
    begin
      with TSuperObject(Result.O[Counter]) do
      begin
        S['fullName'] := FetchElm(RetNo, FNo, 1) + ' ' + FetchElm(RetNo, FNo, 2);
        S['socialInsuranceNumber'] := FetchElm(RetNo, FNo, 3);
        if FetchElm(RetNo, FNo, 29) > '' then S['vesselRegistrationNumber'] := FetchElm(RetNo, FNo, 29);
        if FetchElm(RetNo, FNo, 15) > '' then S['businessAccountNumber'] := FetchElm(RetNo, FNo, 15);
        S['boatName'] := FetchElm(RetNo, FNo, 8);
        S['fiscalPeriodStart'] := FetchElm(RetNo, FNo, 4);
        S['fiscalPeriodEnd'] := FetchElm(RetNo, FNo, 5);
        B['lastYearOfFishingIndicator'] := SameText(FetchElm(RetNo, FNo, 6), 'X');
        S['mainSpecies'] := FetchElm(RetNo, FNo, 9);
        S['naicsCode'] := FetchElm(RetNo, FNo, 11);
        if SameText(FetchElm(RetNo, FNo, 76), 'X') then
          S['accountingMethodType'] := 'CASH'
        else if SameText(FetchElm(RetNo, FNo, 19), 'X') then
          S['accountingMethodType'] := 'ACCRUAL'; //20211215 Igor
        if FetchElm(RetNo, FNo, 14)>'' then
          S['taxShelterIdentificationNumber'] := FetchElm(RetNo, FNo, 14);
        if FetchElm(RetNo, FNo, 12)>'' then
          S['partnershipBusinessNumber'] := FetchElm(RetNo, FNo, 12);
        I['partnershipPercent'] := MyStrToInt(FetchElm(RetNo, FNo, 18));
        {
        // TODO our form contains two lines for preparer name and address, probably it should be changed to match json schema
        S['preparerName'] := FetchElm(RetNo, FNo, 12);
        with TSuperObject(O['preparerAddress']) do
        begin
          S['streetAddress'] := FetchElm(RetNo, FNo, 14);
          S['streetAddressLine2'] := '';
          S['city'] := FetchElm(RetNo, FNo, 16);
          S['province'] := FetchElm(RetNo, FNo, 17);
          S['postalCode'] := FetchElm(RetNo, FNo, 118);
        end;
        }
        if FetchElm(RetNo,FNo,86)<>'0' then
          I['incomeEarnedWebPageCount'] := MyStrToInt(FetchElm(RetNo, FNo, 86));

        WebPageAddresses := SA;
        Counter2 := 0;
        for J in [82,83,84,85,87] do
        begin
          cValue := Trim(FetchElm(RetNo, FNo, J));
          if not cValue.IsEmpty then
          begin
            with WebPageAddresses.O[Counter2] do
            begin
              S['uniformResourceLocator'] := cValue;
            end;
            inc(Counter2);
          end;
        end;
        if WebPageAddresses.Length > 0 then
          A['webPageAddress'] := WebPageAddresses;

        if Vl(FetchElm(RetNo,FNo,88))<>0 then
          I['internetGrossIncomePercent'] := MyStrToInt(FetchElm(RetNo, FNo, 88));

        CoOwners := SA;
        Counter2 := 0;
        for J := 0 to 4 do
        begin
          cNameAndAddress := '';
          cTemp := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][0]));
          if not cTemp.IsEmpty then
            cNameAndAddress := cNameAndAddress + ' ' + cTemp;
          cTemp := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][1]));
          if not cTemp.IsEmpty then
            cNameAndAddress := cNameAndAddress + ' ' + cTemp;
          cTemp := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][2]));
          if not cTemp.IsEmpty then
            cNameAndAddress := cNameAndAddress + ' ' + cTemp;
          cTemp := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][3]));
          if not cTemp.IsEmpty then
            cNameAndAddress := cNameAndAddress + ' ' + cTemp;
          cTemp := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][4]));
          if not cTemp.IsEmpty then
            cNameAndAddress := cNameAndAddress + ' ' + cTemp;
          cNameAndAddress := Trim(cNameAndAddress);
          cAmount := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][5]));
          cValue := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][6]));
          if not cNameAndAddress.IsEmpty and not cAmount.IsEmpty and not cValue.IsEmpty then
          begin
            with CoOwners.O[Counter2] do
            begin
              S['nameAndAddress'] := cNameAndAddress;
              S['netLossOrIncome'] := cAmount;
              S['ownershipPercentage'] := cValue;
            end;
            inc(Counter2);
          end;
        end;
        if CoOwners.Length > 0 then
          A['coOwnersDetails'] := CoOwners;

        A['returnLines'] := GenerateReturnLines(RetNo, cFormName, InstNo);
      end;
      Inc(Counter);
    end
    else
      break;
    inc(InstNo);
  end;
end;

function GenerateT2042Submissions(RetNo:Integer): ISuperArray; //20220120 Igor
var InstNo, J, FNo, Counter, Counter2: integer;
    cFormName, cTemp, cNameAndAddress, cAmount, cValue, val: string;
    WebPageAddresses, CoOwners: ISuperArray;

const arrCoOwners: array[0..5,0..6] of integer =
  (
    (640,664,643,78,84,641,642),
    (644,666,647,79,85,645,646),
    (648,668,651,80,86,649,650),
    (652,670,655,81,87,653,654),
    (656,672,659,82,88,657,658),
    (660,674,663,83,89,661,662)
  );

begin
  cFormName := 'T2042';
  Result := SA;
  InstNo := 1;
  Counter := 0;
  while True do
  begin
    FNo := GetFormNo(cFormName+'#'+AllTrim(IntToStr(InstNo)));
    if FNo > 0 then
    begin
      with TSuperObject(Result.O[Counter]) do
      begin
        S['fullName'] := FetchElm(RetNo, FNo, 1) + ' ' + FetchElm(RetNo, FNo, 2);
        S['socialInsuranceNumber'] := FetchElm(RetNo, FNo, 3);
        S['farmName'] := FetchElm(RetNo, FNo, 8);
        with TSuperObject(O['businessAddress']) do
        begin
          S['streetAddress'] := FetchElm(RetNo, FNo, 10);
          //S['streetAddressLine2'] := '';
          S['city'] := FetchElm(RetNo, FNo, 12);
          S['province'] := FetchElm(RetNo, FNo, 71);
          S['postalCode'] := ReplaceChar(FetchElm(RetNo, FNo, 13),' ',''); //20220706
        end;
        If FetchElm(RetNo, FNo, 21)>'' then  S['businessAccountNumber'] := FetchElm(RetNo, FNo, 21); //20220628

        S['fiscalPeriodStart'] := FetchElm(RetNo, FNo, 4);
        S['fiscalPeriodEnd'] := FetchElm(RetNo, FNo, 5);

        if SameText(FetchElm(RetNo, FNo, 6), 'X') then B['lastYearOfFarmingIndicator'] := true;
        if SameText(FetchElm(RetNo, FNo, 7), 'X') then B['lastYearOfFarmingIndicator'] := false;


        val := FetchElm(RetNo, FNo, 16); if val > '' then S['mainProductOrService'] := val; //jz//20260320 - exclude if blank

        S['naicsCode'] := FetchElm(RetNo, FNo, 17);
        if SameText(FetchElm(RetNo, FNo, 14), 'X') then
          S['accountingMethodType'] := 'CASH'
        else if SameText(FetchElm(RetNo, FNo, 15), 'X') then
          S['accountingMethodType'] := 'ACCRUAL'; //20211215 Igor
        If FetchElm(RetNo, FNo, 20)>'' then  S['taxShelterIdentificationNumber'] := FetchElm(RetNo, FNo, 20);  //20220628
        If FetchElm(RetNo, FNo, 18)>'' then  S['partnershipBusinessNumber'] := FetchElm(RetNo, FNo, 18);   //20220628

        I['partnershipPercent'] := MyStrToInt(FetchElm(RetNo, FNo, 24));

        if Vl(FetchElm(RetNo,FNo,63))=0 then begin end //do nothing
        else
          if not FetchElm(RetNo, FNo, 63).IsEmpty then
            I['incomeEarnedWebPageCount'] := MyStrToInt(FetchElm(RetNo, FNo, 63));

        WebPageAddresses := SA;
        Counter2 := 0;
        for J in [25,11,34,35,69] do
        begin
          cValue := Trim(FetchElm(RetNo, FNo, J));
          if not cValue.IsEmpty then
          begin
            with WebPageAddresses.O[Counter2] do
            begin
              S['uniformResourceLocator'] := cValue;
            end;
            inc(Counter2);
          end;
        end;
        if WebPageAddresses.Length > 0 then
          A['webPageAddress'] := WebPageAddresses;

        if Vl(FetchElm(RetNo, FNo, 70))>0 then   //20220321
          I['internetGrossIncomePercent'] := MyStrToInt(FetchElm(RetNo, FNo, 70));

        CoOwners := SA;
        Counter2 := 0;
        for J := 0 to 5 do
        begin
          cNameAndAddress := '';
          cTemp := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][0]));
          if not cTemp.IsEmpty then
            cNameAndAddress := cNameAndAddress + ' ' + cTemp;
          cTemp := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][1]));
          if not cTemp.IsEmpty then
            cNameAndAddress := cNameAndAddress + ' ' + cTemp;
          cTemp := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][2]));
          if not cTemp.IsEmpty then
            cNameAndAddress := cNameAndAddress + ' ' + cTemp;
          cTemp := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][3]));
          if not cTemp.IsEmpty then
            cNameAndAddress := cNameAndAddress + ' ' + cTemp;
          cTemp := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][4]));
          if not cTemp.IsEmpty then
            cNameAndAddress := cNameAndAddress + ' ' + cTemp;
          cNameAndAddress := Trim(cNameAndAddress);
          cAmount := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][5]));
          cValue := Trim(FetchElm(RetNo, FNo, arrCoOwners[J][6]));
          if not cNameAndAddress.IsEmpty and not cAmount.IsEmpty and not cValue.IsEmpty then
          begin
            with CoOwners.O[Counter2] do
            begin
              S['nameAndAddress'] := cNameAndAddress;
              S['netLossOrIncome'] := cAmount;
              S['ownershipPercentage'] := cValue;
            end;
            inc(Counter2);
          end;
        end;
        if CoOwners.Length > 0 then
          A['coOwnersDetails'] := CoOwners;

        A['returnLines'] := GenerateReturnLines(RetNo, cFormName, InstNo);
      end;
      Inc(Counter);
    end
    else
      break;
    inc(InstNo);
  end;
end;


//20231211
function GenerateS15Submissions(RetNo:Integer): ISuperObject;


//
// when fix remove this procedure on T3_2026Efile: fixBenoSubmissionBecauseCouldntDoItRight
//

            function GeneratebenoReportableEntities(RetNo:Integer): ISuperObject;
            var
             ss:string;
            begin
              Result :=SO;

              ss:='';
              if FetchElm(RetNo, 'S15', 5)  = 'X' then ss:= 'ADD_REPORTABLE_ENTITY';
              if FetchElm(RetNo, 'S15', 6)  = 'X' then ss:= 'MODIFY_REPORTABLE_ENTITY';
              if ss>'' then
                Result.S['reportableEntityAction']      := ss;

              ss:='';
              if FetchElm(RetNo, 'S15', 7)  = 'X' then ss:= 'TRUSTEE';
              if FetchElm(RetNo, 'S15', 8)  = 'X' then ss:= 'SETTLOR';
              if FetchElm(RetNo, 'S15', 9)  = 'X' then ss:= 'BENEFICIARY';
              if FetchElm(RetNo, 'S15', 10) = 'X' then ss:= 'CONTROLLING_PERSON';
              if ss>'' then
                Result.S['reportableEntityType']        := ss;

              ss:='';
              if FetchElm(RetNo, 'S15', 11) = 'X' then ss:= 'NATURAL_PERSON';
              if FetchElm(RetNo, 'S15', 12) = 'X' then ss:= 'CORPORATION';
              if FetchElm(RetNo, 'S15', 13) = 'X' then ss:= 'TRUST';
              if FetchElm(RetNo, 'S15', 14) = 'X' then ss:= 'OTHER';
              if ss>'' then
                Result.S['entityClassification']        := ss;

              ss:=FetchElm(RetNo, 'S15', 15);
              if ss > '' then
                Result.S['notNaturalPersonEntityName']  := ss;

              ss:=FetchElm(RetNo, 'S15', 16);
              if ss > '' then
                Result.S['naturalPersonGivenName']      := ss;

              ss:=FetchElm(RetNo, 'S15', 17);
              if ss > '' then
                Result.S['naturalPersonFamilyName']     := ss;

              ss:=FetchElm(RetNo, 'S15', 18);
              if ss > '' then
                Result.S['naturalPersonBirthDate']      := ss;


              ss:='';
              if FetchElm(RetNo, 'S15', 19) = 'X' then ss:= 'SIN';
              if FetchElm(RetNo, 'S15', 20) = 'X' then ss:= 'TTN';
              if FetchElm(RetNo, 'S15', 21) = 'X' then ss:= 'ITN';
              if FetchElm(RetNo, 'S15', 22) = 'X' then ss:= 'BN';
              if FetchElm(RetNo, 'S15', 23) = 'X' then ss:= 'TN';
              if FetchElm(RetNo, 'S15', 24) = 'X' then ss:= 'INTERNATIONAL';
              if ss > '' then
                Result.S['taxIdentificationNumberType'] := ss;

              ss:=FetchElm(RetNo, 'S15', 28);
              if ss > '' then
                Result.S['taxIdentificationNumber'] := ss;

              with TSuperObject(result.O['benoAddress']) do
              begin
                ss:=FetchElm(RetNo, 'S15', 29); if ss > '' then S['addressLineOne']            := ss;
                ss:=FetchElm(RetNo, 'S15', 31); if ss > '' then S['city']                      := ss;
                ss:=FetchElm(RetNo, 'S15', 32); if ss > '' then S['provinceTerritoryState']    := ss;
                ss:=FetchElm(RetNo, 'S15', 61); if ss > '' then S['globalPostalZipCode']       := ss;
                ss:=FetchElm(RetNo, 'S15', 30); if ss > '' then S['country']                   := ss;
              end;

              if result.O['benoAddress'].Count = 0 then
                Result.Remove('benoAddress');

              ss:='';
              if FetchElm(RetNo, 'S15', 25) = 'X' then ss:='CAN';
              if FetchElm(RetNo, 'S15', 26) = 'X' then ss:='USA';
              if FetchElm(RetNo, 'S15', 27) = 'X' then ss:= FetchElm(RetNo, 'S15', 60);
              if ss > '' then
                Result.S['otherCountryOfResidence']     := ss;

              if FetchElm(RetNo, 'S15', 34) + FetchElm(RetNo, 'S15', 35) > '' then
                Result.B['entityAssociationEndAction']  := SameText(FetchElm(RetNo, 'S15', 34), 'X');

            end;

var
  cFormName, cTemp, cValue: string;
  Counter : integer;
begin

  Result := SO;

  if FetchElm(RetNo, 'S15', 1) + FetchElm(RetNo, 'S15', 2) > '' then
    Result.B['firstTrustDeclaration']         := SameText(FetchElm(RetNo, 'S15', 1), 'X');
  if FetchElm(RetNo, 'S15', 3) + FetchElm(RetNo, 'S15', 4) > '' then
    Result.B['trustChanged']                  := SameText(FetchElm(RetNo, 'S15', 3), 'X');

  Result.B['finalTransmissionIndicator']    := TRUE; //if there are no / no more ebtries to part Bs
  //Result.I['additionalTransmissionCount']   := 0;     //number of part Bs

  Result.O['benoReportableEntities'] := GeneratebenoReportableEntities(RetNo);
  if result.O['benoReportableEntities'].Count = 0 then
    Result.Remove('benoReportableEntities');

end;


//20220326 by igor
function GenerateT1055Submissions(RetNo:Integer): ISuperObject;
var cFormName, cTemp, cValue: string;
begin
  Result := SO;
  cFormName := 'T1055';

   //20220325 Igor >>>
  if FetchElm(RetNo,'T1055',51)>'' then
  Begin
   with TSuperObject(Result.O['deceasedBenificiaryName']) do
   Begin
     cValue := '';
     cTemp := Trim(FetchElm(RetNo, cFormName, 5));
     if not cTemp.IsEmpty then cValue := cValue + ' ' + cTemp;
     S['firstName'] := cValue;

     cValue := '';
     cTemp := Trim(FetchElm(RetNo, cFormName, 6));
     if not cTemp.IsEmpty then cValue := cValue + ' ' + cTemp;
     S['lastName'] := cValue;
   end; //decesed benificiary

   cValue := '';
   cTemp := Trim(FetchElm(RetNo, cFormName, 7));
   if not cTemp.IsEmpty then
     cValue := cValue + ' ' + cTemp;
   cTemp := Trim(FetchElm(RetNo, cFormName, 8));
   if not cTemp.IsEmpty then cValue := cValue + ' ' + cTemp;
   cTemp := Trim(FetchElm(RetNo, cFormName, 9));
   if not cTemp.IsEmpty then cValue := cValue + ' ' + cTemp;
   cTemp := Trim(FetchElm(RetNo, cFormName, 10));
   if not cTemp.IsEmpty then  cValue := cValue + ' ' + cTemp;
   Result.S['deceasedBenificiaryAddress'] := Trim(cValue);
   Result.S['benificiarySocialInsuranceNumber'] := FetchElm(RetNo, cFormName, 11);
   Result.S['deceasedBenificiaryDateOfDeath'] := FetchElm(RetNo, cFormName, 12);
   End //option elm=51

  //20220316
  else if FetchElm(RetNo,'T1055',52)>'' then
  Begin
   //20220318 Igor >>>
   with TSuperObject(Result.O['deceasedSettlorName']) do
   Begin
     {
     cValue := '';
     cTemp := Trim(FetchElm(RetNo, cFormName, 4));
     if not cTemp.IsEmpty then cValue := cValue + ' ' + cTemp;
     S['firstName'] := cValue; //20220318 Igor
     cValue := '';
     cTemp := Trim(FetchElm(RetNo, cFormName, 13));
     if not cTemp.IsEmpty then cValue := cValue + ' ' + cTemp;
     S['lastName'] := cValue;  //20220318 Igor
      }
     S['firstName'] := Trim(FetchElm(RetNo, cFormName, 4));
     S['lastName']  := Trim(FetchElm(RetNo, cFormName, 13));

   end; //decesed settlor

   cValue := '';
   cTemp := Trim(FetchElm(RetNo, cFormName, 14));
   if not cTemp.IsEmpty then
     cValue := cValue + ' ' + cTemp;
   cTemp := Trim(FetchElm(RetNo, cFormName, 15));
   if not cTemp.IsEmpty then cValue := cValue + ' ' + cTemp;
   cTemp := Trim(FetchElm(RetNo, cFormName, 16));
   if not cTemp.IsEmpty then cValue := cValue + ' ' + cTemp;
   cTemp := Trim(FetchElm(RetNo, cFormName, 17));
   if not cTemp.IsEmpty then  cValue := cValue + ' ' + cTemp;
   Result.S['settlorAddress'] := Trim(cValue); //20220316
   Result.S['settlorSocialInsuranceNumber'] := FetchElm(RetNo, cFormName, 18);
   Result.S['deceasedSettlorDateOfDeath'] := FetchElm(RetNo, cFormName, 19);

   if FetchElm(RetNo, cFormName, 20) > '' then
   begin
    Result.B['propertyTransferredIndicator'] := True;
    Result.S['ceasedToBeResidentDate'] := FetchElm(RetNo, cFormName, 22);
   end;



 End //option elm=52

 else if FetchElm(RetNo,'T1055',53)>'' then
 Begin
   Result.B['propertyTransferredIndicator'] := SameText(FetchElm(RetNo, cFormName, 20), 'X');
   if SameText(FetchElm(RetNo, cFormName, 20), 'X') then
     Result.S['ceasedToBeResidentDate'] := FetchElm(RetNo, cFormName, 22);
 end;
 //20220318 Igor >>>
 Result.A['returnLines'] := GenerateReturnLines(RetNo, cFormName);
 if Result.A['returnLines'].Length = 0 then
   Result.Remove('returnLines');
 //20220318 Igor <<<
 //20220325 Igor <<<
end;

(*
//20220316
function GenerateT1055Submissions(RetNo:Integer): ISuperObject;
var cFormName, cTemp, cValue: string;
begin
  Result := SO;
  cFormName := 'T1055';

  //20220316
  if FetchElm(RetNo,'T1055',52)>'' then
  Begin
   //20220318 Igor >>>
   with TSuperObject(Result.O['deceasedSettlorName']) do
   Begin
     cValue := '';
     cTemp := Trim(FetchElm(RetNo, cFormName, 4));
     if not cTemp.IsEmpty then cValue := cValue + ' ' + cTemp;
     S['firstName'] := cValue; //20220318 Igor

     cValue := '';
     cTemp := Trim(FetchElm(RetNo, cFormName, 13));
     if not cTemp.IsEmpty then cValue := cValue + ' ' + cTemp;
     S['lastName'] := cValue;  //20220318 Igor
   end; //decesed settlor

   cValue := '';
   cTemp := Trim(FetchElm(RetNo, cFormName, 14));
   if not cTemp.IsEmpty then
     cValue := cValue + ' ' + cTemp;
   cTemp := Trim(FetchElm(RetNo, cFormName, 15));
   if not cTemp.IsEmpty then cValue := cValue + ' ' + cTemp;
   cTemp := Trim(FetchElm(RetNo, cFormName, 16));
   if not cTemp.IsEmpty then cValue := cValue + ' ' + cTemp;
   cTemp := Trim(FetchElm(RetNo, cFormName, 17));
   if not cTemp.IsEmpty then  cValue := cValue + ' ' + cTemp;
   Result.S['settlorAddress'] := Trim(cValue); //20220316
   Result.S['settlorSocialInsuranceNumber'] := FetchElm(RetNo, cFormName, 18);
   Result.S['deceasedSettlorDateOfDeath'] := FetchElm(RetNo, cFormName, 19);
   Result.B['propertyTransferredIndicator'] := SameText(FetchElm(RetNo, cFormName, 20), 'X');

   //20220318 Igor >>>
   Result.A['returnLines'] := GenerateReturnLines(RetNo, cFormName);
   if Result.A['returnLines'].Length = 0 then
     Result.Remove('returnLines');
   //20220318 Igor <<<
  End; //option elm=52
end;
*)

function GenerateT3FFTSubmissions(RetNo:Integer): ISuperObject; //20220120 Igor
var cFormName, cTemp, cValue: string;
begin
  Result := SO;
  cFormName := 'T3FFT#1';
  Result.A['returnLines'] := GenerateReturnLines(RetNo, cFormName);
  if Result.A['returnLines'].Length = 0 then //20220318 Igor
    Result.Remove('returnLines');
end;

function GetRefundCode(AValue: string): string; //20211123 Igor
begin
  if Copy(AValue, 1, 1) = '0' then
    Result := 'ISSUE_OVERPAYMENT_00'
  else if Copy(AValue, 1, 1) = '1' then
    Result := 'TRANSFER_OVERPAYMENT_01'
  else if Copy(AValue, 1, 1) = '2' then
    Result := 'HOLD_OVERPAYMENT_02'
  else
    //20240118 Igor >>>
    //raise Exception.Create('Refund Code was not defined correctly');
    Result := '';
    //20240118 Igor <<<
end;

type //20240129 Igor
  TBenoEntity = record
    EntityAction: string;
    EntityType: string;
    EntityClassification: string;
    NotNaturalPersonEntityName: string;
    NaturalPersonGivenName: string;
    NaturalPersonFamilyName: string;
    NaturalPersonBirthDate: string;
    TaxIdentificationNumberType: string;
    TaxIdentificationNumber: string;
    AddressLineOne: string;
    City: string;
    ProvinceTerritoryState: string;
    GlobalPostalZipCode: string;
    Country: string;
    OtherCountryOfResidence: string;
    EntityAssociationEndAction: boolean;
end;

function GetBenoEntities(RetNo: integer): TArray<TBenoEntity>; //20240129 Igor
var Inst, I: integer;
    cFormName: string;
    Conn: TADConnection;
    Q: TADQuery;
begin
  if FetchElm(RetNo, 'S15#1', 33) > '' then  //large beno
  begin
    // collect entities from BenoTable
    Conn := TADConnection.Create(nil);
    Q := TADQuery.Create(nil);
    try
      Conn.LoginPrompt := false;
      Conn.DriverName := 'SQLite';
      Conn.Params.Values['Database'] := TPath.Combine(OptRec.Dir_Cur, AppT3_2026.ClientsDBLite);
      Conn.Params.Values['Password'] := Pswd(GC_SQLLitePasswordVersion, false);
      try
        Conn.Connected := True;
      except
        Conn.Params.Values['Password'] := '';
        Conn.Connected := True;
      end;
      Q.Connection := Conn;
      Q.SQL.Text :=
        ' SELECT * FROM BenoTable '+
        ' WHERE TrustAccountNumber = :TrustAccountNumber '+
        ' ORDER BY Id';
      Q.ParamByName('TrustAccountNumber').Value := FetchElm(RetNo, 'T3', 2);
      Q.Open;
      Q.FetchAll;
      SetLength(Result, Q.RecordCount);
      I := 0;
      while not Q.Eof do
      begin
        if SameText(Q.FieldByName('EntityAction').AsString, 'A') then
          Result[I].EntityAction := 'ADD_REPORTABLE_ENTITY'
        else if SameText(Q.FieldByName('EntityAction').AsString, 'M') then
          Result[I].EntityAction := 'MODIFY_REPORTABLE_ENTITY'
        else
          raise Exception.Create('Reportable Entity Action is not selected in Entity #'+ I.ToString);

        if SameText(Q.FieldByName('EntityType').AsString, 'T') then
          Result[I].EntityType := 'TRUSTEE'
        else if SameText(Q.FieldByName('EntityType').AsString, 'S') then
          Result[I].EntityType := 'SETTLOR'
        else if SameText(Q.FieldByName('EntityType').AsString, 'B') then
          Result[I].EntityType := 'BENEFICIARY'
        else if SameText(Q.FieldByName('EntityType').AsString, 'C') then
          Result[I].EntityType := 'CONTROLLING_PERSON'
        else
          raise Exception.Create('Reportable Entity Type is not selected in Entity #'+ I.ToString);

        if SameText(Q.FieldByName('EntityClassification').AsString, 'N') then
          Result[I].EntityClassification := 'NATURAL_PERSON'
        else if SameText(Q.FieldByName('EntityClassification').AsString, 'C') then
          Result[I].EntityClassification := 'CORPORATION'
        else if SameText(Q.FieldByName('EntityClassification').AsString, 'T') then
          Result[I].EntityClassification := 'TRUST'
        else if SameText(Q.FieldByName('EntityClassification').AsString, 'O') then
          Result[I].EntityClassification := 'OTHER'
        else
          raise Exception.Create('Entity Classification is not selected in Entity #'+ I.ToString);

        if SameText(Q.FieldByName('EntityClassification').AsString, 'T') then
        begin
          Result[I].NaturalPersonGivenName := Q.FieldByName('NaturalPersonGivenName').AsString;
          Result[I].NaturalPersonFamilyName := Q.FieldByName('NaturalPersonFamilyName').AsString;
          if Q.FieldByName('NaturalPersonBirthDate').AsString > '' then
            Result[I].NaturalPersonBirthDate := PrepareDate(Q.FieldByName('NaturalPersonBirthDate').AsString);
        end
        else
          Result[I].NotNaturalPersonEntityName := Q.FieldByName('NotNaturalPersonEntityName').AsString;

        Result[I].TaxIdentificationNumberType := Q.FieldByName('TaxIdentificationNumberType').AsString;
        Result[I].TaxIdentificationNumber := Q.FieldByName('TaxIdentificationNumber').AsString;
        Result[I].OtherCountryOfResidence := Q.FieldByName('OtherCountryOfResidence').AsString;

        Result[I].AddressLineOne := Q.FieldByName('AddressLineOne').AsString;
        Result[I].City := Q.FieldByName('City').AsString;
        Result[I].ProvinceTerritoryState := Q.FieldByName('ProvinceTerritoryState').AsString;
        Result[I].GlobalPostalZipCode := Q.FieldByName('GlobalPostalZipCode').AsString;
        Result[I].Country := Q.FieldByName('Country').AsString;

        Result[I].EntityAssociationEndAction := Q.FieldByName('EntityAssociationEndAction').AsBoolean;

        Q.Next;
        inc(I);
      end;
    finally
      Q.Free;
      Conn.Free;
    end;
  end
  else
  begin
    // collect entities from S15 forms
    for Inst := 1 to 100 do
    begin
      cFormName := 'S15#' + Inst.ToString;
      FormNo := FList.ByFormName(cFormName).FormNo;
      if RetList[RetNo].FrmHasData[FormNo] then
      begin
        //20250311 Igor >>>
        if (FetchElm(RetNo, cFormName, 2) > '') and (FetchElm(RetNo, cFormName, 4) > '') then
          continue;
        //20250311 Igor <<<
        SetLength(Result, Length(Result) + 1);
        I := Length(Result) - 1;
        if FetchElm(RetNo, cFormName, 5) > '' then
           Result[I].EntityAction := 'ADD_REPORTABLE_ENTITY'
        else if FetchElm(RetNo, cFormName, 6) > '' then
           Result[I].EntityAction := 'MODIFY_REPORTABLE_ENTITY'
        else
            raise Exception.Create(cFormName +' Reportable Entity Action is not selected');

        if FetchElm(RetNo, cFormName, 7) > '' then
           Result[I].EntityType := 'TRUSTEE'
        else if FetchElm(RetNo, cFormName, 8) > '' then
           Result[I].EntityType := 'SETTLOR'
        else if FetchElm(RetNo, cFormName, 9) > '' then
           Result[I].EntityType := 'BENEFICIARY'
        else if FetchElm(RetNo, cFormName, 10) > '' then
           Result[I].EntityType := 'CONTROLLING_PERSON'
        else
           raise Exception.Create(cFormName + ' Reportable Entity Type is not selected');

        if FetchElm(RetNo, cFormName, 11) > '' then
           Result[I].EntityClassification := 'NATURAL_PERSON'
        else if FetchElm(RetNo, cFormName, 12) > '' then
           Result[I].EntityClassification := 'CORPORATION'
        else if FetchElm(RetNo, cFormName, 13) > '' then
           Result[I].EntityClassification := 'TRUST'
        else if FetchElm(RetNo, cFormName, 14) > '' then
           Result[I].EntityClassification := 'OTHER'
        else
           raise Exception.Create(cFormName + ' Entity Classification is not selected');

        if FetchElm(RetNo, cFormName, 11) > '' then
        begin
           Result[I].NaturalPersonGivenName := FetchElm(RetNo, cFormName, 16);
           Result[I].NaturalPersonFamilyName := FetchElm(RetNo, cFormName, 17);
           if FetchElm(RetNo, cFormName, 18) > '' then
             Result[I].NaturalPersonBirthDate := PrepareDate(FetchElm(RetNo, cFormName, 18));
        end
        else
           Result[I].NotNaturalPersonEntityName := FetchElm(RetNo, cFormName, 15);

        if FetchElm(RetNo, cFormName, 19) > '' then
           Result[I].TaxIdentificationNumberType := 'SIN'
        else if FetchElm(RetNo, cFormName, 20) > '' then
           Result[I].TaxIdentificationNumberType := 'TTN'
        else if FetchElm(RetNo, cFormName, 21) > '' then
           Result[I].TaxIdentificationNumberType := 'ITN'
        else if FetchElm(RetNo, cFormName, 22) > '' then
           Result[I].TaxIdentificationNumberType := 'BN'
        else if FetchElm(RetNo, cFormName, 23) > '' then
           Result[I].TaxIdentificationNumberType := 'TN'
        else if FetchElm(RetNo, cFormName, 24) > '' then
           Result[I].TaxIdentificationNumberType := 'INTERNATIONAL';

        Result[I].TaxIdentificationNumber := FetchElm(RetNo, cFormName, 28);

        if FetchElm(RetNo, cFormName, 25) > '' then
           Result[I].OtherCountryOfResidence := 'CAN'
        else if FetchElm(RetNo, cFormName, 26) > '' then
           Result[I].OtherCountryOfResidence := 'USA'
        else if FetchElm(RetNo, cFormName, 27) > '' then
           Result[I].OtherCountryOfResidence := FetchElm(RetNo, cFormName, 60);

        Result[I].AddressLineOne := FetchElm(RetNo, cFormName, 29);
        Result[I].City := FetchElm(RetNo, cFormName, 31);
        Result[I].ProvinceTerritoryState := FetchElm(RetNo, cFormName, 32);
        Result[I].GlobalPostalZipCode := FetchElm(RetNo, cFormName, 61);
        Result[I].Country := GetCountry3FromCountry2(FetchElm(RetNo, cFormName, 30));
        if Result[I].Country.IsEmpty then
           Result[I].Country := 'CAN';
        Result[I].EntityAssociationEndAction := FetchElm(RetNo, cFormName, 34) > '';
      end; //end if FrmHasData
    end; //end for
  end; //else
end;

function GenerateBenoSubmissions(RetNo: integer): TArray<ISuperObject>; //20240118 Igor //20240129 Igor
var cFormName, cTemp: string;
    J, FormNo, Inst, Counter, TransmissionsCount: integer;
    Entities: TArray<TBenoEntity>;

    function GenerateEntitiesTransmission(ASeqNo: integer): ISuperArray;  //20240129 Igor
    var Inst, Counter: integer;
    begin
      Result := SA;
      Counter := 0;
      for Inst := (ASeqNo - 1) * 10000 to ASeqNo * 10000 - 1 do
      begin
        if Inst >= Length(Entities) then break;
        with TSuperObject(Result.O[Counter]) do
        begin
          S['reportableEntityAction'] := Entities[Inst].EntityAction;
          S['reportableEntityType'] := Entities[Inst].EntityType;
          S['entityClassification'] := Entities[Inst].EntityClassification;

          if Entities[Inst].EntityClassification = 'NATURAL_PERSON' then
          begin
            S['naturalPersonGivenName'] := Entities[Inst].NaturalPersonGivenName;
            S['naturalPersonFamilyName'] := Entities[Inst].NaturalPersonFamilyName;
            if Entities[Inst].NaturalPersonBirthDate > '' then
              S['naturalPersonBirthDate'] := Entities[Inst].NaturalPersonBirthDate;
          end
          else
            S['notNaturalPersonEntityName'] := Entities[Inst].NotNaturalPersonEntityName;




          if Entities[Inst].TaxIdentificationNumberType > '' then
            S['taxIdentificationNumberType'] := Entities[Inst].TaxIdentificationNumberType;

          if Entities[Inst].TaxIdentificationNumber > '' then
            S['taxIdentificationNumber'] := Entities[Inst].TaxIdentificationNumber;

          if Entities[Inst].OtherCountryOfResidence > '' then
            S['otherCountryOfResidence'] := Entities[Inst].OtherCountryOfResidence;

          with TSuperObject(O['benoAddress']) do
          begin
            S['addressLineOne'] := Entities[Inst].AddressLineOne;
            S['city'] := Entities[Inst].City;
            S['provinceTerritoryState'] := Entities[Inst].ProvinceTerritoryState;
            S['globalPostalZipCode'] := Entities[Inst].GlobalPostalZipCode;
            S['country'] := Entities[Inst].Country;
          end;

          B['entityAssociationEndAction'] := Entities[Inst].EntityAssociationEndAction;

          inc(Counter);
        end;
      end;
    end;
begin
  cFormName := 'S15';
  Entities := GetBenoEntities(RetNo);
  TransmissionsCount := Length(Entities) div 10000;
  SetLength(Result, TransmissionsCount + 1);
  Result[0] := SO;
  Result[0].B['firstTrustDeclaration'] := FetchElm(RetNo, cFormName, 1) > '';
  Result[0].B['trustChanged'] := FetchElm(RetNo, cFormName, 3) > '';
  Result[0].B['finalTransmissionIndicator'] := TransmissionsCount = 0;
  //20250311 Igor >>>
  if Length(Entities) > 0 then
  begin
    //20250311 Igor >>>
    if TransmissionsCount > 0 then
      Result[0].I['additionalTransmissionCount'] := TransmissionsCount;
    //20250311 Igor <<<
    Result[0].A['benoReportableEntities'] := GenerateEntitiesTransmission(1);
    for J := 36 to 59 do
    begin
      cTemp := FetchElm(RetNo, cFormName, J);
      if not cTemp.IsEmpty then
      begin
        if Result[0].S['unknownBeneficiariesInfo'] <> '' then
          Result[0].S['unknownBeneficiariesInfo'] := Result[0].S['unknownBeneficiariesInfo'] + ' ';
        Result[0].S['unknownBeneficiariesInfo'] := Result[0].S['unknownBeneficiariesInfo'] + cTemp;
      end;
    end;

    for J := 1 to TransmissionsCount do
    begin
      Result[J] := SO;
      Result[J].O['header'] := SO;
      Result[J].A['additionalReportableEntities'] := GenerateEntitiesTransmission(J+1);
      Result[J].I['sequenceNumber'] := J;
      Result[J].B['finalTransmissionIndicator'] := J = TransmissionsCount;
    end;
  end;
  //20250311 Igor <<<
end;


procedure addSection216(RetNo:Integer;var JSON:ISuperObject);
var
  s, section216Code:string;
begin

  s := FetchElm(RetNo,'EFMEMO',60) + FetchElm(RetNo,'EFMEMO',62)+FetchElm(RetNo,'EFMEMO',64);

  if s > ''then
  begin
    if FetchElm(RetNo,'EFMEMO',60)>'' then
      section216Code := FetchElm(RetNo,'EFMEMO',60)
    else If FetchElm(RetNo,'EFMEMO',62) >'' then
      section216Code := FetchElm(RetNo,'EFMEMO',62)
    else If FetchElm(RetNo,'EFMEMO',64)>'' then
      section216Code := FetchElm(RetNo,'EFMEMO',64);

    JSON.B['section216Indicator'] := true;
    JSON.S['section216Type']      := section216Code;

  end;
end;

//jz 20240326 add returntype
procedure createT3RetJson(RetNo:Integer;T3ReturnType:String;Var T3JsonList:tstringlist;ProdOrTest:String); //20210902 Igor //20211220 Igor //20240118 Igor
var
  JSON: ISuperObject;
  rc,cTemp: string;
  //20240129 Igor >>>
  BenoTransmissions: TArray<ISuperObject>;
  J: integer;
  //20240129 Igor <<<
begin
  JSON := SO;

  JSON.O['header'] := GenerateJsonHeader(RetNo,T3ReturnType,ProdOrTest); //jz 20240326

  addSection216(RetNo,JSON);

  JSON.O['trustIdentification'] := GenerateJsonTrustIdentification(RetNo,ProdOrTest);
  JSON.O['trustTypeInformation'] := GenerateJsonTrustTypeInformation(RetNo);
  JSON.O['filingInformation'] := GenerateJsonFilingInformation(RetNo);
  JSON.B['foreignPropertyInExcessOf100000'] := SameText(FetchElm(RetNo, 'T3', 363), 'X');
  JSON.O['otherInformation'] := GenerateJsonOtherInformation(RetNo);
  //20211123 Igor >>>
  JSON.O['memoIndicators'] := GenerateJsonMemoIndicators(RetNo);  // is is not filled properly
  JSON.A['returnLines'] := GenerateReturnLines(RetNo, 'T3RET');

  rc := GetRefundCode(FetchElm(RetNo, 'T3', 326));
  if rc>'' then
    JSON.S['refundCode'] := rc;   //20240308 //JSON.S['refundCode'] := GetRefundCode(FetchElm(RetNo, 'T3', 326));




  //20211123 Igor <<<


{
  //if FetchElm(RetNo, 'T3', 81) = '324' then //if type of trust is mutual fund //from test cases seems type of fund does not matter?
  if SameText(FetchElm(RetNo, 'T3', 56), 'Y') then
    JSON.B['siftMutualFundTrustIndicator'] := true
  else if SameText(FetchElm(RetNo, 'T3', 56), 'N') then
    JSON.B['siftMutualFundTrustIndicator'] := false;

  //moved to diff form? is X not Y/N box
  if SameText(FetchElm(RetNo, 'EFMEMO', 56), 'X') then
    JSON.B['siftMutualFundTrustIndicator'] := true;
}

  //moved to diff form? should be Y/N because test cases requires it to be false, true or not there (blank)
  if SameText(FetchElm(RetNo, 'EFMEMO', 56), 'Y') then
    JSON.B['siftMutualFundTrustIndicator'] := true;
  if SameText(FetchElm(RetNo, 'EFMEMO', 56), 'N') then
    JSON.B['siftMutualFundTrustIndicator'] := false;



  //20211126 Igor >>>
  If Ret[RetNo].FormHasData['T776'] then
    JSON.A['t776Submissions']   := GenerateT776Submissions(RetNo);
  If Ret[RetNo].FormHasData['T2125'] then
    JSON.A['t2125Submissions']  := GenerateT2125Submissions(RetNo);
  If Ret[RetNo].FormHasData['T2121'] then
    JSON.A['t2121Submissions']  := GenerateT2121Submissions(RetNo);
  If Ret[RetNo].FormHasData['T2042'] then
    JSON.A['t2042Submissions']  := GenerateT2042Submissions(RetNo);
  If Ret[RetNo].FormHasData['T1055'] then
    JSON.O['t1055Submission']   := GenerateT1055Submissions(RetNo);

  //keep last
  If Ret[RetNo].FormHasData['S15'] then
  //20240129 Igor >>>
  begin
    BenoTransmissions := GenerateBenoSubmissions(RetNo);
    JSON.O['benoSubmission']     := BenoTransmissions[0];
  end;
  //20240129 Igor <<<



  //20220120 Igor >>>
  {
  If Ret[RetNo].FormHasData['T3FFT#1'] then
  begin
    JSON.O['t3FftSubmission'] := GenerateT3FFTSubmissions(RetNo);
    if ISuperObject(JSON.O['t3FftSubmission']).Count = 0 then
      JSON.Remove('t3FftSubmission');
  end;
  }
  //20220120 Igor <<<
  //20211126 Igor <<<
  T3JSONList.Text := JSON.AsJSON(true);

  //20240129 Igor >>>
  if Length(BenoTransmissions) > 1 then
    for J := 1 to Length(BenoTransmissions) - 1 do
    begin
      BenoTransmissions[J].O['header'] := GenerateJsonHeader(RetNo,T3ReturnType,ProdOrTest);  //jz 20240326
      T3JSONList.Add(TRANSMISSIONS_DELIMITER);
      T3JSONList.Add(BenoTransmissions[J].AsJSON(true));
    end;
  //20240129 Igor <<<
end;

procedure createT3MJson(RetNo:Integer;T3ReturnType:string;Var T3JsonList:tstringlist;ProdOrTest:String); //20211123 Igor //20211220 Igor //20220120 Igor //20240118 Igor
var
  JSON: ISuperObject;
  cTemp: string;
  //20240129 Igor >>>
  BenoTransmissions: TArray<ISuperObject>;
  J: integer;
  //20240129 Igor <<<

  function GetDateValue(AFormName: string; AYear, AMonth, ADay: integer): string;
  var cYear, cMonth, cDay: string;
  begin
    cYear := Trim(FetchElm(RetNo, AFormName, AYear));
    cMonth := Trim(FetchElm(RetNo, AFormName, AMonth));
    cDay := Trim(FetchElm(RetNo, AFormName, ADay));
    if not cYear.IsEmpty and not cMonth.IsEmpty and not cDay.IsEmpty then
      Result := cYear + '-' + cMonth + '-' + cDay
    else
      Result := '';
  end;

begin
  //20220321
  //20240118 Igor >>>
//  ShowMessage('T3M-Efile not currenyly available'); 
//  Exit;
  //20240118 Igor <<<


  JSON := SO;
  JSON.O['header'] := GenerateJsonHeader(RetNo,T3ReturnType,ProdOrTest);       //jz 20240326
  // not sure if we need to use here T3M edits
  with TSuperObject(JSON.O['trustIdentifier']) do
  begin
    //20211130 Igor >>
    S['countryOfResidence'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3', 11));
    if S['countryOfResidence'].IsEmpty then
      S['countryOfResidence'] := 'CAN';
    S['provinceOfResidence'] := GetShortPrv(FetchElm(RetNo, 'T3', 9));
    S['trustName'] := FetchElm(RetNo, 'T3', 1);
    S['trustAccountNumber'] := GetTrustNumber(RetNo, 'T3', ProdOrTest='P'); //jz 20240326  S['trustAccountNumber'] := GetTrustNumber(RetNo, 'T3', 2, ProdOrTest); //20211204 Igor //20240118 Igor
    //20211130 Igor <<<
  end;
  JSON.I['taxYear'] := MyStrToInt(FetchElm(RetNo, 'T3M', 57));
  JSON.B['trusteeNameChangeIndicator'] := false; //??? //20211215 Igor
  //20240118 Igor >>>
  with TSuperObject(JSON.O['nonIndividualTrusteeContactInformation']) do
  begin
    S['nonIndividualName'] := FetchElm(RetNo, 'T3', 143);
    //20211201 Igor >>>
    if not Trim(FetchElm(RetNo, 'T3', 55)).IsEmpty and not Trim(FetchElm(RetNo, 'T3', 60)).IsEmpty then
      with TSuperObject(O['contactPerson']) do
      begin
        if not Trim(FetchElm(RetNo, 'T3', 55)).IsEmpty then
          S['firstName'] := FetchElm(RetNo, 'T3', 55);
        if not Trim(FetchElm(RetNo, 'T3', 60)).IsEmpty then
          S['lastName'] := FetchElm(RetNo, 'T3', 60);
      end;
    //20211201 Igor <<<

    with TSuperObject(O['address']) do
    begin
      S['addressLineOne'] := FetchElm(RetNo, 'T3', 64);
      //S['addressLineTwo'] := ''; //20211215 Igor
      S['city'] := FetchElm(RetNo, 'T3', 65);
      S['provinceTerritoryState'] := FetchElm(RetNo, 'T3', 66);
      S['globalPostalZipCode'] := FetchElm(RetNo, 'T3', 74);
      S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3', 73));
      //20211130 Igor >>>
      if S['country'].IsEmpty then
        S['country'] := 'CAN';
      //20211130 Igor <<<
    end;

    //20211229 Igor >>>
    if not AllTrim(FetchElm(RetNo, 'T3', 62)).IsEmpty
         and
         not AllTrim(FetchElm(RetNo, 'T3', 63)).IsEmpty then
      with TSuperObject(O['telephoneNumber']) do
      begin
        S['countryCode'] := '1';
        S['areaCode'] := FetchElm(RetNo, 'T3', 62);
        S['localNumber'] := FetchElm(RetNo, 'T3', 63);
      end;
    //20211229 Igor <<<
  end;
  //20240118 Igor <<<

  //20211229 Igor >>>
  //20240118 Igor >>>
  //20250314 Igor >>>

  //jz//20260306 - removed as per OpenAPI_changes_20260113.txt
  //if FetchElm(RetNo, 'T3', 142) > '' then
  //  JSON.B['isMailingAddressSameAsAddressIndicator'] := true;

  if FetchElm(RetNo, 'T3', 75) > '' then
  //20250314 Igor <<<
  //20240118 Igor <<<
    with TSuperObject(JSON.O['mailingInformation']) do
    begin
      S['careOf'] := FetchElm(RetNo, 'T3', 75);

      with TSuperObject(O['address']) do
      begin
        S['addressLineOne'] := FetchElm(RetNo, 'T3', 21);
        //S['addressLineTwo'] := '';
        S['city'] := FetchElm(RetNo, 'T3', 57);
        S['provinceTerritoryState'] := FetchElm(RetNo, 'T3', 68);
        S['globalPostalZipCode'] := FetchElm(RetNo, 'T3', 58);
        S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3', 24));
        //20211130 Igor >>>
        if S['country'].IsEmpty then
          S['country'] := 'CAN';
        //20211130 Igor <<<
      end;

      if not AllTrim(FetchElm(RetNo, 'T3', 12)).IsEmpty
         and
         not AllTrim(FetchElm(RetNo, 'T3', 13)).IsEmpty then
        with TSuperObject(O['telephoneNumber']) do
        begin
          S['countryCode'] := '1';
          S['areaCode'] := FetchElm(RetNo, 'T3', 12);
          S['localNumber'] := RemoveChar(FetchElm(RetNo, 'T3', 13), '-'); //20211201 Igor
        end;
    end;
  //20211229 Igor <<<
  JSON.S['provinceOfSite'] := FetchElm(RetNo, 'T3M', 22);
  if (SameText(FetchElm(RetNo, 'T3M', 23), 'X')) then
    JSON.S['trusteeCorrespondenceLanguageCode'] := 'ENGLISH'
  else if (SameText(FetchElm(RetNo, 'T3M', 24), 'X')) then
    JSON.S['trusteeCorrespondenceLanguageCode'] := 'FRENCH';

  if (SameText(FetchElm(RetNo, 'T3M', 26), 'X')) then
    JSON.S['trustType'] := 'MINING_RECLAMATION'
  else if (SameText(FetchElm(RetNo, 'T3M', 27), 'X')) then
    JSON.S['trustType'] := 'WASTE'
  else if (SameText(FetchElm(RetNo, 'T3M', 28), 'X')) then
    JSON.S['trustType'] := 'QUARRY'
  else if (SameText(FetchElm(RetNo, 'T3M', 29), 'X')) then
    JSON.S['trustType'] := 'PIPELINE';
  //20240118 Igor >>>
  JSON.S['trustCreateDate'] := PrepareDate(FetchElm(RetNo, 'T3M', 30));
  if FetchElm(RetNo, 'T3M', 48) > '' then
    JSON.S['trustWindupDate'] := FetchElm(RetNo, 'T3M', 35);
  JSON.B['firstYearFilingIndicator'] := FetchElm(RetNo, 'T3M', 33) > '';
  if FetchElm(RetNo, 'T3M', 38) > '' then
    JSON.I['numberOfBeneficiaries'] := MyStrToInt(FetchElm(RetNo, 'T3M', 38));
  if FetchElm(RetNo, 'T3M', 39) > '' then
    JSON.I['contributionAmountMadeToTrust']:= Round(Vl(FetchElm(RetNo, 'T3M', 39))); //Vl(FetchElm(RetNo, 'T3M', 39)) //20260209 Igor
  if FetchElm(RetNo, 'T3M', 48) > '' then
    JSON.F['withdrawnAmountFromTrust'] := Vl(FetchElm(RetNo, 'T3M', 40));

  JSON.A['returnLines'] := GenerateReturnLines(RetNo, 'T3M');
  if FetchElm(RetNo, 'T3M', 48) > '' then
    JSON.S['refundCode'] := GetRefundCode(FetchElm(RetNo, 'T3M', 48)); //20211215 Igor

  If Ret[RetNo].FormHasData['S15'] then
  //20240129 Igor >>>
  begin
    BenoTransmissions := GenerateBenoSubmissions(RetNo);
    JSON.O['benoSubmission']     := BenoTransmissions[0];
  end;
  //20240129 Igor <<<
  //20240118 Igor <<<
  
  T3JSONList.Text := JSON.AsJSON(true);
  //20240129 Igor >>>
  if Length(BenoTransmissions) > 1 then
    for J := 1 to Length(BenoTransmissions) - 1 do
    begin
      BenoTransmissions[J].O['header'] := GenerateJsonHeader(RetNo,T3ReturnType,ProdOrTest); //jz 20240326
      T3JSONList.Add(TRANSMISSIONS_DELIMITER);
      T3JSONList.Add(BenoTransmissions[J].AsJSON(true));
    end;
  //20240129 Igor <<<
end;

function GetRCAContributionsReceived(RetNo: integer): ISuperArray; //20240118 Igor
var I, Counter: integer;
    DateValue, AmountValue: string;
begin
  Result := SA;
  Counter := 0;
  for I := 0 to 11 do
  begin
    DateValue := FetchElm(RetNo, 'T3RCA', 57 + I * 3);
    AmountValue := FetchElm(RetNo, 'T3RCA', 59 + I * 3);
    if not DateValue.IsEmpty and not AmountValue.IsEmpty then
    begin
      with TSuperObject(Result.O[Counter]) do
      begin
        S['dateContributionReceived'] := DateValue;
        F['amount'] := Vl(AmountValue);
      end;
      Inc(Counter);
    end;
  end;
end;

//jz 20240326
procedure createT3RCAJson(RetNo:Integer;T3ReturnType:string;Var T3JsonList:tstringlist;ProdOrTest:String); //20240118 Igor
var
  JSON: ISuperObject;
  JArr: ISuperArray;
  LCountryCode, LArea, LPhoneNumber: string;
  //20240129 Igor >>>
  BenoTransmissions: TArray<ISuperObject>;
  J: integer;
  //20240129 Igor <<<
begin
  JSON := SO;
  JSON.O['header'] := GenerateJsonHeader(RetNo,T3ReturnType,ProdOrTest); //jz 20240326
  JSON.I['taxYear'] := MyStrToInt(FetchElm(RetNo, 'T3RCA', 229));
  JSON.B['firstReturnIndicator'] := FetchElm(RetNo, 'T3RCA', 218) > '';
  JSON.B['finalReturnIndicator'] := FetchElm(RetNo, 'T3RCA', 220) > '';
  JSON.S['trustName'] := FetchElm(RetNo, 'T3RCA', 1);
  JSON.S['trustNumber'] := GetTrustNumber(RetNo, T3ReturnType, ProdOrTest='P'); //jz 20240326 //JSON.S['trustNumber'] := GetTrustNumber(RetNo, 'T3RCA', 2, ProdOrTest);
  if FetchElm(RetNo, 'T3RCA', 223) > '' then
    JSON.S['correspondenceLanguageCode'] := 'FRENCH'
  else
    JSON.S['correspondenceLanguageCode'] := 'ENGLISH';

  with TSuperObject(JSON.O['primaryTrusteeContactInformation']) do
  begin
    B['trusteeNameChangeIndicator'] := false;
    if SameText(FetchElm(RetNo, 'T3RCA', 224), 'X')  then
    begin
      B['isIndividualIndicator'] := true;
      with TSuperObject(O['IndividualTrusteeContactInformation']) do
      begin
        S['firstName'] := FetchElm(RetNo, 'T3RCA', 3);
        S['lastName'] := FetchElm(RetNo, 'T3RCA', 4);

        with TSuperObject(O['address']) do
        begin
          S['addressLineOne'] := FetchElm(RetNo, 'T3RCA', 6);
          S['city'] := FetchElm(RetNo, 'T3RCA', 7);
          S['provinceTerritoryState'] := FetchElm(RetNo, 'T3RCA', 8);
          S['globalPostalZipCode'] := FetchElm(RetNo, 'T3RCA', 10);
          S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3RCA', 9));
          if S['country'].IsEmpty then
            S['country'] := 'CAN';
        end;

        with TSuperObject(O['telephoneNumber']) do
        begin
          SplitPhoneNumber(FetchElm(RetNo, 'T3RCA', 5), LCountryCode, LArea, LPhoneNumber);
          S['countryCode'] := LCountryCode;
          S['areaCode'] := LArea;
          S['localNumber'] := LPhoneNumber;
        end;
      end;
    end
    else if SameText(FetchElm(RetNo, 'T3RCA', 225), 'X') then
    begin
      B['isNonIndividualIndicator'] := true;
      with TSuperObject(O['nonIndividualTrusteeContactInformation']) do
      begin
        S['nonIndividualName'] := FetchElm(RetNo, 'T3RCA', 11);
        if not Trim(FetchElm(RetNo, 'T3RCA', 12)).IsEmpty and not Trim(FetchElm(RetNo, 'T3RCA', 13)).IsEmpty then
          with TSuperObject(O['contactPerson']) do
          begin
            if not Trim(FetchElm(RetNo, 'T3RCA', 12)).IsEmpty then
              S['firstName'] := FetchElm(RetNo, 'T3RCA', 12);
            if not Trim(FetchElm(RetNo, 'T3RCA', 13)).IsEmpty then
              S['lastName'] := FetchElm(RetNo, 'T3RCA', 13);
          end;

        with TSuperObject(O['address']) do
        begin
          S['addressLineOne'] := FetchElm(RetNo, 'T3RCA', 15);
          //S['addressLineTwo'] := '';
          S['city'] := FetchElm(RetNo, 'T3RCA', 16);
          S['provinceTerritoryState'] := Copy(FetchElm(RetNo, 'T3RCA', 17), 1, 2);
          S['globalPostalZipCode'] := FetchElm(RetNo, 'T3RCA', 19);
          S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3RCA', 18));
          if S['country'].IsEmpty then
            S['country'] := 'CAN';
        end;

        if not AllTrim(FetchElm(RetNo, 'T3RCA', 14)).IsEmpty then
          with TSuperObject(O['telephoneNumber']) do
          begin
            SplitPhoneNumber(FetchElm(RetNo, 'T3RCA', 14), LCountryCode, LArea, LPhoneNumber);
            S['countryCode'] := LCountryCode;
            S['areaCode'] := LArea;
            S['localNumber'] := LPhoneNumber;
          end;
      end;
    end;
  end;

  JSON.B['termsChangedIndicator'] := FetchElm(RetNo, 'T3RCA', 27) > '';
  JSON.B['transferReportedIndicator'] := FetchElm(RetNo, 'T3RCA', 29) > '';
  JSON.B['amountReturnedDistributedIndicator'] := FetchElm(RetNo, 'T3RCA', 41) > '';
  if FetchElm(RetNo, 'T3RCA', 43) > '' then
    JSON.S['payrollAccountNumber'] := FetchElm(RetNo, 'T3RCA', 43);
  if FetchElm(RetNo, 'T3RCA', 44) > '' then
    JSON.S['nonresRemittanceAccountNumber'] := FetchElm(RetNo, 'T3RCA', 44);
  JSON.I['numberMembersReceivedContributions'] := MyStrToInt(FetchElm(RetNo, 'T3RCA', 47));
  JSON.B['propertyDistributedIndicator'] := FetchElm(RetNo, 'T3RCA', 45) > '';
  JSON.B['propertyAcquiredDisposedIndicator'] := FetchElm(RetNo, 'T3RCA', 48) > '';
  JSON.B['propertyLeasedUsedIndicator'] := FetchElm(RetNo, 'T3RCA', 50) > '';
  JSON.B['trustLoanDateIndicator'] := FetchElm(RetNo, 'T3RCA', 52) > '';
  if JSON.B['trustLoanDateIndicator'] then
    JSON.S['trustLoanDate'] := FetchElm(RetNo, 'T3RCA', 52);
  JSON.B['otherCustodianTrustNumberIndicator'] := FetchElm(RetNo, 'T3RCA', 53) > '';
  if JSON.B['otherCustodianTrustNumberIndicator'] then
    JSON.S['otherCustodianTrustNumber'] := 'T'+FetchElm(RetNo, 'T3RCA', 53);
  JSON.B['finalDeterminationDateIndicator'] := FetchElm(RetNo, 'T3RCA', 54) > '';
  if JSON.B['finalDeterminationDateIndicator'] then
    JSON.S['finalDeterminationDate'] := FetchElm(RetNo, 'T3RCA', 54);
  JSON.B['rcaTrustCanRsdntAndNotMeetSubSctn15012'] := FetchElm(RetNo, 'T3RCA', 55) > '';
  //20260202 Igor >>>
  JSON.B['specifiedArrangementTrustIndicator']:= FetchElm(RetNo, 'T3RCA', 233) > '';          //20260202 Igor
  JSON.B['trustMeetConditionsInParagraph150Indicator']:= FetchElm(RetNo, 'T3RCA', 244) > '';  //20260202 Igor

  //20260202 Igor <<<
  JArr := GetRCAContributionsReceived(RetNo);
  if JArr.Length > 0 then
    JSON.A['contributionsReceived'] := JArr;

  JSON.A['returnLines'] := GenerateReturnLines(RetNo, 'T3RCA');

  If Ret[RetNo].FormHasData['S15'] then
  //20240129 Igor >>>
  begin
    BenoTransmissions := GenerateBenoSubmissions(RetNo);
    JSON.O['benoSubmission']     := BenoTransmissions[0];
  end;
  //20240129 Igor <<<

  T3JSONList.Text := JSON.AsJSON(true);
  //20240129 Igor >>>
  if Length(BenoTransmissions) > 1 then
    for J := 1 to Length(BenoTransmissions) - 1 do
    begin
      BenoTransmissions[J].O['header'] := GenerateJsonHeader(RetNo,T3ReturnType,ProdOrTest);     //jz 20240326
      T3JSONList.Add(TRANSMISSIONS_DELIMITER);
      T3JSONList.Add(BenoTransmissions[J].AsJSON(true));
    end;
  //20240129 Igor <<<
end;

procedure createT3ATHJson(RetNo:Integer;T3ReturnType:string;Var T3JsonList:tstringlist;ProdOrTest:String); //20240118 Igor
var
  JSON: ISuperObject;
  LCountryCode, LArea, LPhoneNumber: string;
  //20240129 Igor >>>
  BenoTransmissions: TArray<ISuperObject>;
  J: integer;
  //20240129 Igor <<<
begin
  JSON := SO;
  JSON.O['header'] := GenerateJsonHeader(RetNo,T3ReturnType,ProdOrTest);
  JSON.B['isFirstYearFiling'] := FetchElm(RetNo, 'T3ATH', 3) > '';
  with TSuperObject(JSON.O['athleteName']) do
  begin
    S['firstName'] := FetchElm(RetNo, 'T3ATH', 6);
    S['lastName'] := FetchElm(RetNo, 'T3ATH', 1);
  end;
  JSON.S['trustNumber'] := GetTrustNumber(RetNo,T3ReturnType,ProdOrTest='P'); //jz 20240326 //JSON.S['trustNumber'] := GetTrustNumber(RetNo, 'T3ATH', 7, ProdOrTest);
  with TSuperObject(JSON.O['athleteAddress']) do
  begin
    S['addressLineOne'] := FetchElm(RetNo, 'T3ATH', 8);
    S['city'] := FetchElm(RetNo, 'T3ATH', 10);
    S['provinceTerritoryState'] := Copy(FetchElm(RetNo, 'T3ATH', 11), 1, 2);
    S['globalPostalZipCode'] := FetchElm(RetNo, 'T3ATH', 13);
    S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3ATH', 12));
    if S['country'].IsEmpty then
      S['country'] := 'CAN';
  end;

  if FetchElm(RetNo, 'T3ATH', 9) > '' then
    JSON.S['athleteSocialInsuranceNumber'] := FetchElm(RetNo, 'T3ATH', 9);

  with TSuperObject(JSON.O['primaryTrusteeContactInformation']) do
  begin
    B['trusteeNameChangeIndicator'] := false;
    if SameText(FetchElm(RetNo, 'T3ATH', 63), 'X')  then
    begin
      B['isIndividualIndicator'] := true;
      with TSuperObject(O['trusteeContactInformation']) do
      begin
        with TSuperObject(O['individualName']) do
        begin
          S['firstName'] := FetchElm(RetNo, 'T3ATH', 14);
          S['lastName'] := FetchElm(RetNo, 'T3ATH', 15);
        end;

        with TSuperObject(O['address']) do
        begin
          S['addressLineOne'] := FetchElm(RetNo, 'T3ATH', 17);
          S['city'] := FetchElm(RetNo, 'T3ATH', 18);
          S['provinceTerritoryState'] := Copy(FetchElm(RetNo, 'T3ATH', 19), 1, 2);
          S['globalPostalZipCode'] := FetchElm(RetNo, 'T3ATH', 21);
          S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3ATH', 20));
          if S['country'].IsEmpty then
            S['country'] := 'CAN';
        end;

        with TSuperObject(O['telephoneNumber']) do
        begin
          SplitPhoneNumber(FetchElm(RetNo, 'T3ATH', 16), LCountryCode, LArea, LPhoneNumber);
          S['countryCode'] := LCountryCode;
          S['areaCode'] := LArea;
          S['localNumber'] := LPhoneNumber;
        end;
      end;
    end
    else if SameText(FetchElm(RetNo, 'T3ATH', 64), 'X') then
    begin
      B['isNonIndividualIndicator'] := true;
      with TSuperObject(O['nonIndividualTrusteeContactInformation']) do
      begin
        S['nonIndividualName'] := FetchElm(RetNo, 'T3ATH', 22);
        if not Trim(FetchElm(RetNo, 'T3ATH', 24)).IsEmpty and not Trim(FetchElm(RetNo, 'T3ATH', 26)).IsEmpty then
          with TSuperObject(O['contactPerson']) do
          begin
            if not Trim(FetchElm(RetNo, 'T3ATH', 24)).IsEmpty then
              S['firstName'] := FetchElm(RetNo, 'T3ATH', 24);
            if not Trim(FetchElm(RetNo, 'T3ATH', 26)).IsEmpty then
              S['lastName'] := FetchElm(RetNo, 'T3ATH', 26);
          end;

        with TSuperObject(O['address']) do
        begin
          S['addressLineOne'] := FetchElm(RetNo, 'T3ATH', 27);
          //S['addressLineTwo'] := '';
          S['city'] := FetchElm(RetNo, 'T3ATH', 28);
          S['provinceTerritoryState'] := Copy(FetchElm(RetNo, 'T3ATH', 29), 1, 2);
          S['globalPostalZipCode'] := FetchElm(RetNo, 'T3ATH', 31);
          S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3ATH', 30));
          if S['country'].IsEmpty then
            S['country'] := 'CAN';
        end;

        if not AllTrim(FetchElm(RetNo, 'T3ATH', 26)).IsEmpty then
          with TSuperObject(O['telephoneNumber']) do
          begin
            SplitPhoneNumber(FetchElm(RetNo, 'T3ATH', 26), LCountryCode, LArea, LPhoneNumber);
            S['countryCode'] := LCountryCode;
            S['areaCode'] := LArea;
            S['localNumber'] := LPhoneNumber;
          end;
      end;
    end;
  end;

  if FetchElm(RetNo, 'T3ATH', 32) > '' then
    with TSuperObject(JSON.O['booksAndRecordsAddress']) do
    begin
      S['addressLineOne'] := FetchElm(RetNo, 'T3ATH', 32);
      S['city'] := FetchElm(RetNo, 'T3ATH', 33);
      S['provinceTerritoryState'] := Copy(FetchElm(RetNo, 'T3ATH', 34), 1, 2);
      S['globalPostalZipCode'] := FetchElm(RetNo, 'T3ATH', 36);
      S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3ATH', 35));
      if S['country'].IsEmpty then
        S['country'] := 'CAN';
    end;

  if FetchElm(RetNo, 'T3ATH', 23) > '' then
    JSON.S['rcaaaRegistrationNumber'] := FetchElm(RetNo, 'T3ATH', 23);

  JSON.I['taxYear'] := MyStrToInt(FetchElm(RetNo, 'T3ATH', 5));
  JSON.S['trustProvinceOfResidence'] := Copy(FetchElm(RetNo, 'T3ATH', 67), 1, 2);

  if FetchElm(RetNo, 'T3ATH', 66) > '' then
    JSON.S['trusteeCorrespondenceLanguage'] := 'FRENCH'
  else
    JSON.S['trusteeCorrespondenceLanguage'] := 'ENGLISH';

  JSON.S['trustCreateDate'] := PrepareDate(FetchElm(RetNo, 'T3ATH', 39));
  JSON.B['trustCeasedIndicator'] := FetchElm(RetNo, 'T3ATH', 37) > '';
  if FetchElm(RetNo, 'T3ATH', 40) > '' then
    JSON.S['trustEndWindupDate'] := PrepareDate(FetchElm(RetNo, 'T3ATH', 40));

  JSON.B['amateurAthleteNotExpressTrust'] := FetchElm(RetNo, 'T3ATH', 41) > '';
  JSON.B['assetsHeldListedUnderParagraph150NotExceeding50kIndicator'] := FetchElm(RetNo, 'T3ATH', 43) > '';
  JSON.B['trustMeetConditionsInParagraph150Indicator']:= FetchElm(RetNo, 'T3ATH', 70) > ''; //20260202 Igor
  //JSON.B['trustMeetTheConditions']:= FetchElm(RetNo, 'T3ATH', 70) > ''; //What parameter name should be for new field??? //20260109 Igor

  JSON.A['returnLines'] := GenerateReturnLines(RetNo, 'T3ATH');

  If Ret[RetNo].FormHasData['S15'] then
  //20240129 Igor >>>
  begin
    BenoTransmissions := GenerateBenoSubmissions(RetNo);
    JSON.O['benoSubmission']     := BenoTransmissions[0];
  end;
  //20240129 Igor <<<

  T3JSONList.Text := JSON.AsJSON(true);
  //20240129 Igor >>>
  if Length(BenoTransmissions) > 1 then
    for J := 1 to Length(BenoTransmissions) - 1 do
    begin
      BenoTransmissions[J].O['header'] := GenerateJsonHeader(RetNo,T3ReturnType,ProdOrTest);
      T3JSONList.Add(TRANSMISSIONS_DELIMITER);
      T3JSONList.Add(BenoTransmissions[J].AsJSON(true));
    end;
  //20240129 Igor <<<
end;

//jz 20240326
procedure createT3DJson(RetNo:Integer;T3ReturnType:string;Var T3JsonList:tstringlist;ProdOrTest:String); //20240118 Igor
var
  JSON: ISuperObject;
  LCountryCode, LArea, LPhoneNumber: string;
begin
  JSON := SO;
  JSON.O['header'] := GenerateJsonHeader(RetNo,T3ReturnType,ProdOrTest); //jz 20240326
  JSON.B['amendedReturnIndicator'] := FetchElm(RetNo, 'T3D', 1) > '';
  JSON.B['firstYearFilingIndicator'] := FetchElm(RetNo, 'T3D', 3) > '';
  JSON.I['taxYear'] := MyStrToInt(FetchElm(RetNo, 'T3D', 262));
  JSON.S['trustPlanName'] := FetchElm(RetNo, 'T3D', 5);
  JSON.S['trustNumber'] := GetTrustNumber(RetNo,T3ReturnType,ProdOrTest='P'); //jz 20240326 //JSON.S['trustNumber'] := GetTrustNumber(RetNo, 'T3D', 6, ProdOrTest);
  JSON.S['provinceOfResidence'] := FetchElm(RetNo, 'T3D', 7);
  JSON.S['planRegistrationNumber'] := FetchElm(RetNo, 'T3D', 8);
  if FetchElm(RetNo, 'T3D', 10) > '' then
    JSON.S['correspondenceLanguageCode'] := 'FRENCH'
  else
    JSON.S['correspondenceLanguageCode'] := 'ENGLISH';

  with TSuperObject(JSON.O['primaryTrusteeContactInformation']) do
  begin
    B['trusteeNameChangeIndicator'] := false;
    if SameText(FetchElm(RetNo, 'T3D', 41), 'X')  then
    begin
      B['isIndividualIndicator'] := true;
      with TSuperObject(O['trusteeContactInformation']) do
      begin
        with TSuperObject(O['individualName']) do
        begin
          S['firstName'] := FetchElm(RetNo, 'T3D', 11);
          S['lastName'] := FetchElm(RetNo, 'T3D', 12);
        end;

        with TSuperObject(O['address']) do
        begin
          S['addressLineOne'] := FetchElm(RetNo, 'T3D', 14);
          S['city'] := FetchElm(RetNo, 'T3D', 15);
          S['provinceTerritoryState'] := Copy(FetchElm(RetNo, 'T3D', 16), 1, 2);
          S['globalPostalZipCode'] := FetchElm(RetNo, 'T3D', 18);
          S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3D', 17));
          if S['country'].IsEmpty then
            S['country'] := 'CAN';
        end;

        with TSuperObject(O['telephoneNumber']) do
        begin
          SplitPhoneNumber(FetchElm(RetNo, 'T3D', 13), LCountryCode, LArea, LPhoneNumber);
          S['countryCode'] := LCountryCode;
          S['areaCode'] := LArea;
          S['localNumber'] := LPhoneNumber;
        end;
      end;
    end
    else if SameText(FetchElm(RetNo, 'T3D', 260), 'X') then
    begin
      B['isNonIndividualIndicator'] := true;
      with TSuperObject(O['nonIndividualTrusteeContactInformation']) do
      begin
        S['nonIndividualName'] := FetchElm(RetNo, 'T3D', 19);
        if not Trim(FetchElm(RetNo, 'T3D', 20)).IsEmpty and not Trim(FetchElm(RetNo, 'T3D', 21)).IsEmpty then
          with TSuperObject(O['contactPerson']) do
          begin
            if not Trim(FetchElm(RetNo, 'T3D', 20)).IsEmpty then
              S['firstName'] := FetchElm(RetNo, 'T3D', 20);
            if not Trim(FetchElm(RetNo, 'T3D', 21)).IsEmpty then
              S['lastName'] := FetchElm(RetNo, 'T3D', 21);
          end;

        with TSuperObject(O['address']) do
        begin
          S['addressLineOne'] := FetchElm(RetNo, 'T3D', 23);
          //S['addressLineTwo'] := '';
          S['city'] := FetchElm(RetNo, 'T3D', 24);
          S['provinceTerritoryState'] := Copy(FetchElm(RetNo, 'T3D', 25), 1, 2);
          S['globalPostalZipCode'] := FetchElm(RetNo, 'T3D', 27);
          S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3D', 26));
          if S['country'].IsEmpty then
            S['country'] := 'CAN';
        end;

        if not AllTrim(FetchElm(RetNo, 'T3D', 22)).IsEmpty then
          with TSuperObject(O['telephoneNumber']) do
          begin
            SplitPhoneNumber(FetchElm(RetNo, 'T3D', 22), LCountryCode, LArea, LPhoneNumber);
            S['countryCode'] := LCountryCode;
            S['areaCode'] := LArea;
            S['localNumber'] := LPhoneNumber;
          end;
      end;
    end;
  end;

  if FetchElm(RetNo, 'T3D', 29) > '' then
    with TSuperObject(JSON.O['booksAndRecordsAddress']) do
    begin
      S['addressLineOne'] := FetchElm(RetNo, 'T3D', 29);
      S['city'] := FetchElm(RetNo, 'T3D', 28);
      S['provinceTerritoryState'] := Copy(FetchElm(RetNo, 'T3D', 30), 1, 2);
      S['globalPostalZipCode'] := FetchElm(RetNo, 'T3D', 32);
      S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3D', 31));
      if S['country'].IsEmpty then
        S['country'] := 'CAN';
    end;

  JSON.S['trustCreateDate'] := PrepareDate(FetchElm(RetNo, 'T3D', 33));
  if FetchElm(RetNo, 'T3D', 34) > '' then
    JSON.S['trustWindupDate'] := PrepareDate(FetchElm(RetNo, 'T3D', 34));
  JSON.B['fileRelatedT3RetIndicator'] := FetchElm(RetNo, 'T3D', 35) > '';
  if FetchElm(RetNo, 'T3D', 37) > '' then
    JSON.S['t3RetRelatedTrustAccountNumber'] := FetchElm(RetNo, 'T3D', 37); //jz 20240326 //JSON.S['t3RetRelatedTrustAccountNumber'] := GetTrustNumber(RetNo, 'T3D', 37, ProdOrTest);
  if FetchElm(RetNo, 'T3D', 38) > '' then
    JSON.S['revocationEffectiveDate'] := PrepareDate(FetchElm(RetNo, 'T3D', 38));
  if FetchElm(RetNo, 'T3D', 39) > '' then
    JSON.S['newTrusteeName'] := FetchElm(RetNo, 'T3D', 39);
  if FetchElm(RetNo, 'T3D', 40) > '' then
    JSON.S['assetsTransferDate'] := PrepareDate(FetchElm(RetNo, 'T3D', 40));

  JSON.A['returnLines'] := GenerateReturnLines(RetNo, 'T3D');

  if FetchElm(RetNo, 'T3D', 57) > '' then
    JSON.S['refundCode'] := GetRefundCode(FetchElm(RetNo, 'T3D', 57));

  T3JSONList.Text := JSON.AsJSON(true);
end;

//jz 20240326
procedure createT3PJson(RetNo:Integer;T3ReturnType:string;Var T3JsonList:tstringlist;ProdOrTest:String); //20240118 Igor
var
  JSON: ISuperObject;
  LCountryCode, LArea, LPhoneNumber: string;
begin
  JSON := SO;
  JSON.O['header'] := GenerateJsonHeader(RetNo,T3ReturnType,ProdOrTest); //jz 20240326
  JSON.B['amendedReturnIndicator'] := FetchElm(RetNo, 'T3P', 1) > '';
  JSON.B['firstYearFilingIndicator'] := FetchElm(RetNo, 'T3P', 3) > '';
  JSON.I['taxYear'] := MyStrToInt(FetchElm(RetNo, 'T3P', 5));
  JSON.S['pensionPlanName'] := FetchElm(RetNo, 'T3P', 6);
  JSON.S['trustNumber'] := GetTrustNumber(RetNo,T3ReturnType,ProdOrTest='P'); //jz 20240326 //JSON.S['trustNumber'] := GetTrustNumber(RetNo, 'T3P', 7, ProdOrTest);
  JSON.S['provinceOfResidence'] := FetchElm(RetNo, 'T3P', 8);
  JSON.S['registrationNumber'] := FetchElm(RetNo, 'T3P', 9);
  if FetchElm(RetNo, 'T3P', 11) > '' then
    JSON.S['trusteeCorrespondenceLanguageCode'] := 'FRENCH'
  else
    JSON.S['trusteeCorrespondenceLanguageCode'] := 'ENGLISH';

  with TSuperObject(JSON.O['primaryTrusteeContactInformation']) do
  begin
    B['trusteeNameChangeIndicator'] := false;
    if SameText(FetchElm(RetNo, 'T3P', 12), 'X')  then
    begin
      B['isIndividualIndicator'] := true;
      with TSuperObject(O['trusteeContactInformation']) do
      begin
        with TSuperObject(O['individualName']) do
        begin
          S['firstName'] := FetchElm(RetNo, 'T3P', 13);
          S['lastName'] := FetchElm(RetNo, 'T3P', 14);
        end;

        with TSuperObject(O['address']) do
        begin
          S['addressLineOne'] := FetchElm(RetNo, 'T3P', 16);
          S['city'] := FetchElm(RetNo, 'T3P', 17);
          S['provinceTerritoryState'] := Copy(FetchElm(RetNo, 'T3P', 18), 1, 2);
          S['globalPostalZipCode'] := FetchElm(RetNo, 'T3P', 20);
          S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3P', 19));
          if S['country'].IsEmpty then
            S['country'] := 'CAN';
        end;

        with TSuperObject(O['telephoneNumber']) do
        begin
          SplitPhoneNumber(FetchElm(RetNo, 'T3P', 15), LCountryCode, LArea, LPhoneNumber);
          S['countryCode'] := LCountryCode;
          S['areaCode'] := LArea;
          S['localNumber'] := LPhoneNumber;
        end;
      end;
    end
    else if SameText(FetchElm(RetNo, 'T3P', 66), 'X') then
    begin
      B['isNonIndividualIndicator'] := true;
      with TSuperObject(O['nonIndividualTrusteeContactInformation']) do
      begin
        S['nonIndividualName'] := FetchElm(RetNo, 'T3P', 21);
        if not Trim(FetchElm(RetNo, 'T3P', 22)).IsEmpty and not Trim(FetchElm(RetNo, 'T3P', 23)).IsEmpty then
          with TSuperObject(O['contactPerson']) do
          begin
            if not Trim(FetchElm(RetNo, 'T3P', 22)).IsEmpty then
              S['firstName'] := FetchElm(RetNo, 'T3P', 22);
            if not Trim(FetchElm(RetNo, 'T3P', 23)).IsEmpty then
              S['lastName'] := FetchElm(RetNo, 'T3P', 23);
          end;

        with TSuperObject(O['address']) do
        begin
          S['addressLineOne'] := FetchElm(RetNo, 'T3P', 25);
          //S['addressLineTwo'] := '';
          S['city'] := FetchElm(RetNo, 'T3P', 26);
          S['provinceTerritoryState'] := Copy(FetchElm(RetNo, 'T3P', 27), 1, 2);
          S['globalPostalZipCode'] := FetchElm(RetNo, 'T3P', 29);
          S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3P', 28));
          if S['country'].IsEmpty then
            S['country'] := 'CAN';
        end;

        if not AllTrim(FetchElm(RetNo, 'T3P', 24)).IsEmpty then
          with TSuperObject(O['telephoneNumber']) do
          begin
            SplitPhoneNumber(FetchElm(RetNo, 'T3P', 24), LCountryCode, LArea, LPhoneNumber);
            S['countryCode'] := LCountryCode;
            S['areaCode'] := LArea;
            S['localNumber'] := LPhoneNumber;
          end;
      end;
    end;
  end;

  if FetchElm(RetNo, 'T3P', 30) > '' then
    with TSuperObject(JSON.O['booksAndRecordsAddress']) do
    begin
      S['addressLineOne'] := FetchElm(RetNo, 'T3P', 30);
      S['city'] := FetchElm(RetNo, 'T3D', 31);
      S['provinceTerritoryState'] := Copy(FetchElm(RetNo, 'T3P', 32), 1, 2);
      S['globalPostalZipCode'] := FetchElm(RetNo, 'T3P', 34);
      S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3P', 33));
      if S['country'].IsEmpty then
        S['country'] := 'CAN';
    end;

  JSON.S['trustCreateDate'] := PrepareDate(FetchElm(RetNo, 'T3P', 35));
  if FetchElm(RetNo, 'T3P', 36) > '' then
    JSON.S['trustCeasedToExistDate'] := PrepareDate(FetchElm(RetNo, 'T3P', 36));
  JSON.B['fileRelatedT3RetIndicator'] := FetchElm(RetNo, 'T3P', 37) > '';
  if FetchElm(RetNo, 'T3P', 39) > '' then
    JSON.S['t3RetRelatedTrustAccountNumber'] := FetchElm(RetNo, 'T3P', 39);  //jz 20240326 //JSON.S['t3RetRelatedTrustAccountNumber'] := GetTrustNumber(RetNo, 'T3P', 39, ProdOrTest);
  if FetchElm(RetNo, 'T3P', 67) > '' then
    JSON.S['trustTransferred'] := FetchElm(RetNo, 'T3P', 67);
  if FetchElm(RetNo, 'T3P', 68) > '' then
    JSON.S['fundsTransferredDate'] := PrepareDate(FetchElm(RetNo, 'T3P', 68));

  JSON.A['returnLines'] := GenerateReturnLines(RetNo, 'T3P');

  if FetchElm(RetNo, 'T3P', 44) > '' then
    JSON.S['refundCode'] := GetRefundCode(FetchElm(RetNo, 'T3P', 44));

  T3JSONList.Text := JSON.AsJSON(true);
end;

//jz 20240326
procedure createT3PRPJson(RetNo:Integer;T3ReturnType:string;Var T3JsonList:tstringlist;ProdOrTest:String); //20240118 Igor
var
  JSON: ISuperObject;
  LCountryCode, LArea, LPhoneNumber: string;
begin
  JSON := SO;
  JSON.O['header'] := GenerateJsonHeader(RetNo,T3ReturnType,ProdOrTest); //jz 20240326
  JSON.B['amendedReturnIndicator'] := FetchElm(RetNo, 'T3PRP', 1) > '';
  JSON.B['firstYearFilingIndicator'] := FetchElm(RetNo, 'T3PRP', 4) > '';
  JSON.I['taxYear'] := MyStrToInt(FetchElm(RetNo, 'T3PRP', 6));
  JSON.S['planName'] := FetchElm(RetNo, 'T3PRP', 7);
  JSON.S['trustNumber'] := GetTrustNumber(RetNo,T3ReturnType,ProdOrTest='P'); //jz 20240326 //JSON.S['trustNumber'] := GetTrustNumber(RetNo, 'T3PRP', 8, ProdOrTest);
  JSON.S['trustProvinceOfResidence'] := FetchElm(RetNo, 'T3PRP', 9);
  JSON.S['planRegistrationNumber'] := FetchElm(RetNo, 'T3PRP', 10);
  if FetchElm(RetNo, 'T3PRP', 12) > '' then
    JSON.S['trustCorrespondenceLanguageCode'] := 'FRENCH'
  else
    JSON.S['trustCorrespondenceLanguageCode'] := 'ENGLISH';

  with TSuperObject(JSON.O['primaryTrusteeContactInformation']) do
  begin
    B['trusteeNameChangeIndicator'] := false;
    if SameText(FetchElm(RetNo, 'T3PRP', 3), 'X')  then
    begin
      B['isIndividualIndicator'] := true;
      with TSuperObject(O['trusteeContactInformation']) do
      begin
        with TSuperObject(O['individualName']) do
        begin
          S['firstName'] := FetchElm(RetNo, 'T3PRP', 13);
          S['lastName'] := FetchElm(RetNo, 'T3PRP', 14);
        end;

        with TSuperObject(O['address']) do
        begin
          S['addressLineOne'] := FetchElm(RetNo, 'T3PRP', 16);
          S['city'] := FetchElm(RetNo, 'T3PRP', 17);
          S['provinceTerritoryState'] := Copy(FetchElm(RetNo, 'T3PRP', 18), 1, 2);
          S['globalPostalZipCode'] := FetchElm(RetNo, 'T3PRP', 20);
          S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3PRP', 19));
          if S['country'].IsEmpty then
            S['country'] := 'CAN';
        end;

        with TSuperObject(O['telephoneNumber']) do
        begin
          SplitPhoneNumber(FetchElm(RetNo, 'T3PRP', 15), LCountryCode, LArea, LPhoneNumber);
          S['countryCode'] := LCountryCode;
          S['areaCode'] := LArea;
          S['localNumber'] := LPhoneNumber;
        end;
      end;
    end
    else if SameText(FetchElm(RetNo, 'T3PRP', 52), 'X') then
    begin
      B['isNonIndividualIndicator'] := true;
      with TSuperObject(O['nonIndividualTrusteeContactInformation']) do
      begin
        S['nonIndividualName'] := FetchElm(RetNo, 'T3PRP', 21);
        if not Trim(FetchElm(RetNo, 'T3PRP', 22)).IsEmpty and not Trim(FetchElm(RetNo, 'T3PRP', 23)).IsEmpty then
          with TSuperObject(O['contactPerson']) do
          begin
            if not Trim(FetchElm(RetNo, 'T3PRP', 22)).IsEmpty then
              S['firstName'] := FetchElm(RetNo, 'T3PRP', 22);
            if not Trim(FetchElm(RetNo, 'T3PRP', 23)).IsEmpty then
              S['lastName'] := FetchElm(RetNo, 'T3PRP', 23);
          end;

        with TSuperObject(O['address']) do
        begin
          S['addressLineOne'] := FetchElm(RetNo, 'T3PRP', 25);
          //S['addressLineTwo'] := '';
          S['city'] := FetchElm(RetNo, 'T3PRP', 26);
          S['provinceTerritoryState'] := Copy(FetchElm(RetNo, 'T3PRP', 27), 1, 2);
          S['globalPostalZipCode'] := FetchElm(RetNo, 'T3PRP', 29);
          S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3PRP', 28));
          if S['country'].IsEmpty then
            S['country'] := 'CAN';
        end;

        if not AllTrim(FetchElm(RetNo, 'T3PRP', 24)).IsEmpty then
          with TSuperObject(O['telephoneNumber']) do
          begin
            SplitPhoneNumber(FetchElm(RetNo, 'T3PRP', 24), LCountryCode, LArea, LPhoneNumber);
            S['countryCode'] := LCountryCode;
            S['areaCode'] := LArea;
            S['localNumber'] := LPhoneNumber;
          end;
      end;
    end;
  end;

  if FetchElm(RetNo, 'T3PRP', 30) > '' then
    with TSuperObject(JSON.O['booksAndRecordsAddress']) do
    begin
      S['addressLineOne'] := FetchElm(RetNo, 'T3PRP', 30);
      S['city'] := FetchElm(RetNo, 'T3PRP', 31);
      S['provinceTerritoryState'] := Copy(FetchElm(RetNo, 'T3PRP', 32), 1, 2);
      S['globalPostalZipCode'] := FetchElm(RetNo, 'T3PRP', 34);
      S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3PRP', 33));
      if S['country'].IsEmpty then
        S['country'] := 'CAN';
    end;

  JSON.S['trustCreateDate'] := PrepareDate(FetchElm(RetNo, 'T3PRP', 35));
  if FetchElm(RetNo, 'T3PRP', 36) > '' then
    JSON.S['trustWindupDate'] := PrepareDate(FetchElm(RetNo, 'T3PRP', 36));
  JSON.B['fileRelatedT3RetIndicator'] := FetchElm(RetNo, 'T3PRP', 37) > '';
  if FetchElm(RetNo, 'T3PRP', 39) > '' then
    JSON.S['t3RetRelatedTrustAccountNumber'] := FetchElm(RetNo, 'T3PRP', 39);   //jz 20240326 //JSON.S['t3RetRelatedTrustAccountNumber'] := GetTrustNumber(RetNo, 'T3PRP', 39, ProdOrTest);
  if FetchElm(RetNo, 'T3PRP', 40) > '' then
    JSON.S['transfereeName'] := FetchElm(RetNo, 'T3PRP', 40);
  if FetchElm(RetNo, 'T3PRP', 41) > '' then
    JSON.S['dateTransferred'] := PrepareDate(FetchElm(RetNo, 'T3PRP', 41));

  JSON.A['returnLines'] := GenerateReturnLines(RetNo, 'T3PRP');

  if FetchElm(RetNo, 'T3PRP', 46) > '' then
    JSON.S['refundCode'] := GetRefundCode(FetchElm(RetNo, 'T3PRP', 46));

  T3JSONList.Text := JSON.AsJSON(true);
end;

                                       //jz 20240326
procedure createT3GRJson(RetNo:Integer;T3ReturnType:string;Var T3JsonList:tstringlist;ProdOrTest:String); //20240118 Igor
var
  JSON: ISuperObject;
  LCountryCode, LArea, LPhoneNumber: string;
begin
  JSON := SO;
  JSON.O['header'] := GenerateJsonHeader(RetNo,T3ReturnType,ProdOrTest); //jz 20240326
  JSON.B['isAmendedReturnIndicator'] := FetchElm(RetNo, 'T3GR', 1) > '';
  JSON.B['firstYearFilingIndicator'] := FetchElm(RetNo, 'T3GR', 3) > '';
  JSON.I['taxYear'] := MyStrToInt(FetchElm(RetNo, 'T3GR', 5));
  if FetchElm(RetNo, 'T3GR', 6) > '' then
    JSON.S['trustType'] := 'RRSP'
  else if FetchElm(RetNo, 'T3GR', 7) > '' then
    JSON.S['trustType'] := 'RRIF'
  else if FetchElm(RetNo, 'T3GR', 8) > '' then
    JSON.S['trustType'] := 'RESP'
  else if FetchElm(RetNo, 'T3GR', 9) > '' then
    JSON.S['trustType'] := 'RDSP';
  JSON.S['specimenPlanOrFundName'] := FetchElm(RetNo, 'T3GR', 11);
  JSON.S['trustAccountNumber'] := GetTrustNumber(RetNo,T3ReturnType,ProdOrTest='P');  //jz 20240326 //JSON.S['trustAccountNumber'] := GetTrustNumber(RetNo, 'T3GR', 12, ProdOrTest);
  JSON.S['trustProvinceOfResidence'] := FetchElm(RetNo, 'T3GR', 13);
  JSON.S['specimenPlanOrFundApprovalNumber'] := FetchElm(RetNo, 'T3GR', 14);
  if FetchElm(RetNo, 'T3GR', 16) > '' then
    JSON.S['trustCorrespondenceLanguageCode'] := 'FRENCH'
  else
    JSON.S['trustCorrespondenceLanguageCode'] := 'ENGLISH';
  JSON.B['fileRelatedT3RetIndicator'] := FetchElm(RetNo, 'T3GR', 49) > '';
  if FetchElm(RetNo, 'T3GR', 51) > '' then
    JSON.S['t3RetRelatedTrustAccountNumber'] := FetchElm(RetNo, 'T3GR', 51);  //jz 20240326  //JSON.S['t3RetRelatedTrustAccountNumber'] := GetTrustNumber(RetNo, 'T3GR', 51, ProdOrTest);

  with TSuperObject(JSON.O['primaryTrusteeContactInformation']) do
  begin
    B['trusteeNameChangeIndicator'] := false;
    if SameText(FetchElm(RetNo, 'T3GR', 17), 'X')  then
    begin
      B['isIndividualIndicator'] := true;
      with TSuperObject(O['trusteeContactInformation']) do
      begin
        with TSuperObject(O['individualName']) do
        begin
          S['firstName'] := FetchElm(RetNo, 'T3GR', 18);
          S['lastName'] := FetchElm(RetNo, 'T3GR', 19);
        end;

        with TSuperObject(O['address']) do
        begin
          S['addressLineOne'] := FetchElm(RetNo, 'T3GR', 21);
          S['city'] := FetchElm(RetNo, 'T3GR', 22);
          S['provinceTerritoryState'] := Copy(FetchElm(RetNo, 'T3GR', 23), 1, 2);
          S['globalPostalZipCode'] := FetchElm(RetNo, 'T3GR', 25);
          S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3GR', 24));
          if S['country'].IsEmpty then
            S['country'] := 'CAN';
        end;

        with TSuperObject(O['telephoneNumber']) do
        begin
          SplitPhoneNumber(FetchElm(RetNo, 'T3GR', 20), LCountryCode, LArea, LPhoneNumber);
          S['countryCode'] := LCountryCode;
          S['areaCode'] := LArea;
          S['localNumber'] := LPhoneNumber;
        end;
      end;
    end
    else if SameText(FetchElm(RetNo, 'T3GR', 26), 'X') then
    begin
      B['isNonIndividualIndicator'] := true;
      with TSuperObject(O['nonIndividualTrusteeContactInformation']) do
      begin
        S['nonIndividualName'] := FetchElm(RetNo, 'T3GR', 27);
        if not Trim(FetchElm(RetNo, 'T3GR', 28)).IsEmpty and not Trim(FetchElm(RetNo, 'T3GR', 29)).IsEmpty then
          with TSuperObject(O['contactPerson']) do
          begin
            if not Trim(FetchElm(RetNo, 'T3GR', 28)).IsEmpty then
              S['firstName'] := FetchElm(RetNo, 'T3GR', 28);
            if not Trim(FetchElm(RetNo, 'T3GR', 29)).IsEmpty then
              S['lastName'] := FetchElm(RetNo, 'T3GR', 29);
          end;

        with TSuperObject(O['address']) do
        begin
          S['addressLineOne'] := FetchElm(RetNo, 'T3GR', 31);
          //S['addressLineTwo'] := '';
          S['city'] := FetchElm(RetNo, 'T3GR', 32);
          S['provinceTerritoryState'] := Copy(FetchElm(RetNo, 'T3GR', 33), 1, 2);
          S['globalPostalZipCode'] := FetchElm(RetNo, 'T3GR', 35);
          S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3GR', 34));
          if S['country'].IsEmpty then
            S['country'] := 'CAN';
        end;

        if not AllTrim(FetchElm(RetNo, 'T3GR', 30)).IsEmpty then
          with TSuperObject(O['telephoneNumber']) do
          begin
            SplitPhoneNumber(FetchElm(RetNo, 'T3GR', 30), LCountryCode, LArea, LPhoneNumber);
            S['countryCode'] := LCountryCode;
            S['areaCode'] := LArea;
            S['localNumber'] := LPhoneNumber;
          end;
      end;
    end;
  end;

  if FetchElm(RetNo, 'T3GR', 43) > '' then
    with TSuperObject(JSON.O['booksAndRecordsAddress']) do
    begin
      S['addressLineOne'] := FetchElm(RetNo, 'T3GR', 43);
      S['city'] := FetchElm(RetNo, 'T3GR', 46);
      S['provinceTerritoryState'] := Copy(FetchElm(RetNo, 'T3GR', 45), 1, 2);
      S['globalPostalZipCode'] := FetchElm(RetNo, 'T3GR', 48);
      S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3GR', 47));
      if S['country'].IsEmpty then
        S['country'] := 'CAN';
    end;

  if FetchElm(RetNo, 'T3GR', 36) > '' then
    with TSuperObject(JSON.O['careOfMailingInformation']) do
    begin
      S['careOf'] := FetchElm(RetNo, 'T3GR', 36);

      with TSuperObject(O['address']) do
      begin
        S['addressLineOne'] := FetchElm(RetNo, 'T3GR', 38);
        //S['addressLineTwo'] := '';
        S['city'] := FetchElm(RetNo, 'T3GR', 39);
        S['provinceTerritoryState'] := FetchElm(RetNo, 'T3GR', 40);
        S['globalPostalZipCode'] := FetchElm(RetNo, 'T3GR', 42);
        S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3GR', 41));
        //20211130 Igor >>>
        if S['country'].IsEmpty then
          S['country'] := 'CAN';
        //20211130 Igor <<<
      end;

      if not AllTrim(FetchElm(RetNo, 'T3GR', 37)).IsEmpty then
        with TSuperObject(O['telephoneNumber']) do
        begin
          SplitPhoneNumber(FetchElm(RetNo, 'T3GR', 37), LCountryCode, LArea, LPhoneNumber);
          S['countryCode'] := LCountryCode;
          S['areaCode'] := LArea;
          S['localNumber'] := LPhoneNumber;
        end;
    end;

  JSON.A['returnLines'] := GenerateReturnLines(RetNo, 'T3GR');

  if FetchElm(RetNo, 'T3GR', 66) > '' then
    JSON.S['refundCode'] := GetRefundCode(FetchElm(RetNo, 'T3GR', 66));

  T3JSONList.Text := JSON.AsJSON(true);
end;
                                       //jz 20240326
procedure createT3RIJson(RetNo:Integer;T3ReturnType:string;Var T3JsonList:tstringlist;ProdOrTest:String); //20240118 Igor
var
  JSON: ISuperObject;
  LCountryCode, LArea, LPhoneNumber: string;
begin
  JSON := SO;
  JSON.O['header'] := GenerateJsonHeader(RetNo,T3ReturnType,ProdOrTest);   //jz 20240326
  JSON.B['amendedReturnIndicator'] := FetchElm(RetNo, 'T3RI', 1) > '';
  JSON.B['firstYearFilingIndicator'] := FetchElm(RetNo, 'T3RI', 3) > '';

  JSON.S['registeredInvestmentName'] := FetchElm(RetNo, 'T3RI', 5);
  JSON.S['registrationNumber'] := FetchElm(RetNo, 'T3RI', 8);
  JSON.S['trustNumber'] := GetTrustNumber(RetNo,T3ReturnType,ProdOrTest='P'); //jz 20240326  //JSON.S['trustNumber'] := GetTrustNumber(RetNo, 'T3RI', 6, ProdOrTest);
  JSON.S['provinceOfResidence'] := Copy(FetchElm(RetNo, 'T3RI', 7), 1, 2);
  if FetchElm(RetNo, 'T3RI', 10) > '' then
    JSON.S['correspondenceLanguageCode'] := 'FRENCH'
  else
    JSON.S['correspondenceLanguageCode'] := 'ENGLISH';

  with TSuperObject(JSON.O['primaryTrusteeContactInformation']) do
  begin
    B['trusteeNameChangeIndicator'] := false;
    if SameText(FetchElm(RetNo, 'T3RI', 11), 'X')  then
    begin
      B['isIndividualIndicator'] := true;
      with TSuperObject(O['trusteeContactInformation']) do
      begin
        with TSuperObject(O['individualName']) do
        begin
          S['firstName'] := FetchElm(RetNo, 'T3RI', 12);
          S['lastName'] := FetchElm(RetNo, 'T3RI', 13);
        end;

        with TSuperObject(O['address']) do
        begin
          S['addressLineOne'] := FetchElm(RetNo, 'T3RI', 15);
          S['city'] := FetchElm(RetNo, 'T3RI', 16);
          S['provinceTerritoryState'] := Copy(FetchElm(RetNo, 'T3RI', 17), 1, 2);
          S['globalPostalZipCode'] := FetchElm(RetNo, 'T3RI', 19);
          S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3RI', 18));
          if S['country'].IsEmpty then
            S['country'] := 'CAN';
        end;

        with TSuperObject(O['telephoneNumber']) do
        begin
          SplitPhoneNumber(FetchElm(RetNo, 'T3RI', 14), LCountryCode, LArea, LPhoneNumber);
          S['countryCode'] := LCountryCode;
          S['areaCode'] := LArea;
          S['localNumber'] := LPhoneNumber;
        end;
      end;
    end
    else if SameText(FetchElm(RetNo, 'T3RI', 48), 'X') then
    begin
      B['isNonIndividualIndicator'] := true;
      with TSuperObject(O['nonIndividualTrusteeContactInformation']) do
      begin
        S['nonIndividualName'] := FetchElm(RetNo, 'T3RI', 20);
        if not Trim(FetchElm(RetNo, 'T3RI', 21)).IsEmpty and not Trim(FetchElm(RetNo, 'T3RI', 22)).IsEmpty then
          with TSuperObject(O['contactPerson']) do
          begin
            if not Trim(FetchElm(RetNo, 'T3RI', 21)).IsEmpty then
              S['firstName'] := FetchElm(RetNo, 'T3RI', 21);
            if not Trim(FetchElm(RetNo, 'T3RI', 22)).IsEmpty then
              S['lastName'] := FetchElm(RetNo, 'T3RI', 22);
          end;

        with TSuperObject(O['address']) do
        begin
          S['addressLineOne'] := FetchElm(RetNo, 'T3RI', 24);
          //S['addressLineTwo'] := '';
          S['city'] := FetchElm(RetNo, 'T3RI', 25);
          S['provinceTerritoryState'] := Copy(FetchElm(RetNo, 'T3RI', 26), 1, 2);
          S['globalPostalZipCode'] := FetchElm(RetNo, 'T3RI', 28);
          S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3RI', 27));
          if S['country'].IsEmpty then
            S['country'] := 'CAN';
        end;

        if not AllTrim(FetchElm(RetNo, 'T3RI', 23)).IsEmpty then
          with TSuperObject(O['telephoneNumber']) do
          begin
            SplitPhoneNumber(FetchElm(RetNo, 'T3RI', 23), LCountryCode, LArea, LPhoneNumber);
            S['countryCode'] := LCountryCode;
            S['areaCode'] := LArea;
            S['localNumber'] := LPhoneNumber;
          end;
      end;
    end;
  end;

  JSON.S['fiscalPeriodStartDate'] := PrepareDate(FetchElm(RetNo, 'T3RI', 29));
  JSON.S['fiscalPeriodEndDate'] := PrepareDate(FetchElm(RetNo, 'T3RI', 30));
  if FetchElm(RetNo, 'T3RI', 31) > '' then
    JSON.S['registeredInvestmentCreateDate'] := PrepareDate(FetchElm(RetNo, 'T3RI', 31));
  if FetchElm(RetNo, 'T3RI', 32) > '' then
    JSON.S['registeredInvestmentCeasedToExistDate'] := PrepareDate(FetchElm(RetNo, 'T3RI', 32));

  JSON.B['fileRelatedT3RetIndicator'] := FetchElm(RetNo, 'T3RI', 33) > '';
  if FetchElm(RetNo, 'T3RI', 35) > '' then
    JSON.S['t3RetRelatedTrustAccountNumber'] := FetchElm(RetNo, 'T3RI', 35); //jz 20240326 //JSON.S['t3RetRelatedTrustAccountNumber'] := GetTrustNumber(RetNo, 'T3RI', 35, ProdOrTest);
  if FetchElm(RetNo, 'T3RI', 235) > '' then
    JSON.S['revokeNotificationDate'] := PrepareDate(FetchElm(RetNo, 'T3RI', 235));

  JSON.A['returnLines'] := GenerateReturnLines(RetNo, 'T3RI');

  if FetchElm(RetNo, 'T3RI', 43) > '' then
    JSON.S['refundCode'] := GetRefundCode(FetchElm(RetNo, 'T3RI', 43));

  T3JSONList.Text := JSON.AsJSON(true);
end;
                                      //jz 20240326
procedure createT3SJson(RetNo:Integer;T3ReturnType:string;Var T3JsonList:tstringlist;ProdOrTest:String); //20240118 Igor
var
  JSON: ISuperObject;
  LCountryCode, LArea, LPhoneNumber: string;
begin
  JSON := SO;
  JSON.O['header'] := GenerateJsonHeader(RetNo,T3ReturnType,ProdOrTest);  //jz 20240326
  //JSON.B['amendedReturnIndicator'] := FetchElm(RetNo, 'T3S', 1) > '';
  JSON.B['firstYearFilingIndicator'] := FetchElm(RetNo, 'T3S', 3) > '';

  JSON.S['trustPlanName'] := FetchElm(RetNo, 'T3S', 1);
  JSON.S['trustNumber'] := GetTrustNumber(RetNo,T3ReturnType,ProdOrTest='P');  //jz 20240326 //JSON.S['trustNumber'] := GetTrustNumber(RetNo, 'T3S', 7, ProdOrTest);
  if FetchElm(RetNo, 'T3S', 6) > '' then
    JSON.S['planRegistrationNumber'] := FetchElm(RetNo, 'T3S', 6);

  with TSuperObject(JSON.O['primaryTrusteeContactInformation']) do
  begin
    B['trusteeNameChangeIndicator'] := false;
    if SameText(FetchElm(RetNo, 'T3S', 63), 'X')  then
    begin
      B['isIndividualIndicator'] := true;
      with TSuperObject(O['trusteeContactInformation']) do
      begin
        with TSuperObject(O['individualName']) do
        begin
          S['firstName'] := FetchElm(RetNo, 'T3S', 17);
          S['lastName'] := FetchElm(RetNo, 'T3S', 18);
        end;

        with TSuperObject(O['address']) do
        begin
          S['addressLineOne'] := FetchElm(RetNo, 'T3S', 14);
          S['city'] := FetchElm(RetNo, 'T3S', 15);
          S['provinceTerritoryState'] := Copy(FetchElm(RetNo, 'T3S', 10), 1, 2);
          S['globalPostalZipCode'] := FetchElm(RetNo, 'T3S', 16);
          S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3S', 12));
          if S['country'].IsEmpty then
            S['country'] := 'CAN';
        end;

        with TSuperObject(O['telephoneNumber']) do
        begin
          SplitPhoneNumber(FetchElm(RetNo, 'T3S', 19), LCountryCode, LArea, LPhoneNumber);
          S['countryCode'] := LCountryCode;
          S['areaCode'] := LArea;
          S['localNumber'] := LPhoneNumber;
        end;
      end;
    end
    else if SameText(FetchElm(RetNo, 'T3S', 13), 'X') then
    begin
      B['isNonIndividualIndicator'] := true;
      with TSuperObject(O['nonIndividualTrusteeContactInformation']) do
      begin
        S['nonIndividualName'] := FetchElm(RetNo, 'T3S', 20);
        if not Trim(FetchElm(RetNo, 'T3S', 21)).IsEmpty and not Trim(FetchElm(RetNo, 'T3S', 22)).IsEmpty then
          with TSuperObject(O['contactPerson']) do
          begin
            if not Trim(FetchElm(RetNo, 'T3S', 21)).IsEmpty then
              S['firstName'] := FetchElm(RetNo, 'T3S', 21);
            if not Trim(FetchElm(RetNo, 'T3S', 22)).IsEmpty then
              S['lastName'] := FetchElm(RetNo, 'T3S', 22);
          end;

        with TSuperObject(O['address']) do
        begin
          S['addressLineOne'] := FetchElm(RetNo, 'T3S', 24);
          //S['addressLineTwo'] := '';
          S['city'] := FetchElm(RetNo, 'T3S', 25);
          S['provinceTerritoryState'] := Copy(FetchElm(RetNo, 'T3S', 26), 1, 2);
          S['globalPostalZipCode'] := FetchElm(RetNo, 'T3S', 28);
          S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3S', 27));
          if S['country'].IsEmpty then
            S['country'] := 'CAN';
        end;

        if not AllTrim(FetchElm(RetNo, 'T3S', 23)).IsEmpty then
          with TSuperObject(O['telephoneNumber']) do
          begin
            SplitPhoneNumber(FetchElm(RetNo, 'T3S', 23), LCountryCode, LArea, LPhoneNumber);
            S['countryCode'] := LCountryCode;
            S['areaCode'] := LArea;
            S['localNumber'] := LPhoneNumber;
          end;
      end;
    end;
  end;

  if FetchElm(RetNo, 'T3S', 29) > '' then
    with TSuperObject(JSON.O['booksAndRecordsAddress']) do
    begin
      S['addressLineOne'] := FetchElm(RetNo, 'T3S', 29);
      S['city'] := FetchElm(RetNo, 'T3S', 30);
      S['provinceTerritoryState'] := Copy(FetchElm(RetNo, 'T3S', 31), 1, 2);
      S['globalPostalZipCode'] := FetchElm(RetNo, 'T3S', 33);
      S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T3S', 32));
      if S['country'].IsEmpty then
        S['country'] := 'CAN';
    end;

  JSON.S['trustProvinceOfResidence'] := Copy(FetchElm(RetNo, 'T3S', 11), 1, 2);
  JSON.I['taxYear'] := MyStrToInt(FetchElm(RetNo, 'T3S', 5));
  if FetchElm(RetNo, 'T3S', 9) > '' then
    JSON.S['trusteeCorrespondenceLanguageCode'] := 'FRENCH'
  else
    JSON.S['trusteeCorrespondenceLanguageCode'] := 'ENGLISH';

  JSON.S['trustCreateDate'] := PrepareDate(FetchElm(RetNo, 'T3S', 34));
  if FetchElm(RetNo, 'T3S', 35) > '' then
    JSON.S['trustEndWindupDate'] := PrepareDate(FetchElm(RetNo, 'T3S', 35));

  JSON.B['fileRelatedT3RetIndicator'] := FetchElm(RetNo, 'T3S', 36) > '';
  if FetchElm(RetNo, 'T3S', 38) > '' then
    JSON.S['t3RetRelatedTrustAccountNumber'] := FetchElm(RetNo, 'T3S', 38); //jz 20240326 //JSON.S['t3RetRelatedTrustAccountNumber'] := GetTrustNumber(RetNo, 'T3S', 38, ProdOrTest);

  JSON.A['returnLines'] := GenerateReturnLines(RetNo, 'T3S');

  if FetchElm(RetNo, 'T3S', 46) > '' then
    JSON.S['refundCode'] := GetRefundCode(FetchElm(RetNo, 'T3S', 46));

  T3JSONList.Text := JSON.AsJSON(true);
end;


//jz 20240326
procedure createT1061Json(RetNo:Integer;T3ReturnType:string;Var T3JsonList:tstringlist;ProdOrTest:String); //20240118 Igor

          function GenerateT1061BenoQuestions(RetNo:Integer;ProdOrTest:String): ISuperObject;
          begin
            Result := SO;
            if FetchElm(RetNo, 'T1061', 1)>'' then Result.B['assetsHeldListedUnderParagraph150NotExceeding50kIndicator'] := True
                                              Else Result.B['assetsHeldListedUnderParagraph150NotExceeding50kIndicator'] := False;

            If FetchElm(RetNo, 'T1061', 3)>'' then Result.B['amateurAthleteNotExpressTrustIndicator']                     := True
                                              Else Result.B['amateurAthleteNotExpressTrustIndicator']                     := False;
          end;

var
  s:string;
  JSON: ISuperObject;
  LCountryCode, LArea, LPhoneNumber: string;
begin
  JSON := SO;

  //required
  JSON.O['header'] := GenerateJsonHeader(RetNo,T3ReturnType,ProdOrTest);

  //required
  JSON.O['benoQuestions'] := GenerateT1061BenoQuestions(RetNo,ProdOrTest);

  //required
  s := fetchElm(RetNo, 'T1061', 7);
  JSON.I['taxYear'] :=  MyStrToInt(s);

  //required
  //s := fetchElm(RetNo, 'T1061', 6);
  JSON.S['trustAccountNumber'] := GetTrustNumber(RetNo,T3ReturnType,ProdOrTest='P');

  s := fetchElm(RetNo, 'T1061', 5);
  if s > '' then  JSON.S['rcaaaRegistrationNumber'] := s;

  //required
  If fetchElm(RetNo, 'T1061', 37)>'' then JSON.S['trustCorrespondenceLanguageCode']        := 'FRENCH'
                                     else JSON.S['trustCorrespondenceLanguageCode']        := 'ENGLISH';

  s := FetchElm(RetNo, 'T1061', 35);
  if s > '' then JSON.I['trustReturnCount'] := MyStrToInt(s);

  //required
  with TSuperObject(JSON.O['primaryTrusteeContactInformation']) do
  begin
    B['trusteeNameChangeIndicator'] := false;
    if SameText(FetchElm(RetNo, 'T1061', 38), 'X')  then
    begin
      B['isIndividualIndicator'] := true;
      with TSuperObject(O['trusteeContactInformation']) do
      begin
        with TSuperObject(O['individualName']) do
        begin
          S['firstName'] := FetchElm(RetNo, 'T1061', 8);
          S['lastName']  := FetchElm(RetNo, 'T1061', 9);
        end;

        with TSuperObject(O['address']) do
        begin
          S['addressLineOne']         := FetchElm(RetNo, 'T1061', 17);
          S['city']                   := FetchElm(RetNo, 'T1061', 12);
          S['provinceTerritoryState'] := Copy(FetchElm(RetNo, 'T1061', 13), 1, 2);
          S['globalPostalZipCode']    := FetchElm(RetNo, 'T1061', 15);
          S['country']                := GetCountry3FromCountry2(FetchElm(RetNo, 'T1061', 14));
          if S['country'].IsEmpty then
            S['country'] := 'CAN';
        end;

        with TSuperObject(O['telephoneNumber']) do
        begin
          SplitPhoneNumber(FetchElm(RetNo, 'T1061', 10), LCountryCode, LArea, LPhoneNumber);
          S['countryCode']  := LCountryCode;
          S['areaCode']     := LArea;
          S['localNumber']  := LPhoneNumber;
        end;
      end;
    end
    else if SameText(FetchElm(RetNo, 'T1061', 39), 'X') then
    begin
      B['isNonIndividualIndicator'] := true;
      with TSuperObject(O['nonIndividualTrusteeContactInformation']) do
      begin
        S['nonIndividualName'] := FetchElm(RetNo, 'T1061', 16);
        if not Trim(FetchElm(RetNo, 'T1061', 11)).IsEmpty and not Trim(FetchElm(RetNo, 'T1061', 18)).IsEmpty then
          with TSuperObject(O['contactPerson']) do
          begin
            if not Trim(FetchElm(RetNo, 'T1061', 11)).IsEmpty then
              S['firstName'] := FetchElm(RetNo, 'T1061', 11);
            if not Trim(FetchElm(RetNo, 'T1061', 18)).IsEmpty then
              S['lastName'] := FetchElm(RetNo, 'T1061', 18);
          end;

        with TSuperObject(O['address']) do
        begin
          S['addressLineOne'] := FetchElm(RetNo, 'T1061', 20); //S['addressLineTwo'] := '';
          S['city'] := FetchElm(RetNo, 'T1061', 21);
          S['provinceTerritoryState'] := Copy(FetchElm(RetNo, 'T1061', 22), 1, 2);
          S['globalPostalZipCode'] := FetchElm(RetNo, 'T1061', 24);
          S['country'] := GetCountry3FromCountry2(FetchElm(RetNo, 'T1061', 23));
          if S['country'].IsEmpty then
            S['country'] := 'CAN';
        end;

        if not AllTrim(FetchElm(RetNo, 'T1061', 19)).IsEmpty then
          with TSuperObject(O['telephoneNumber']) do
          begin
            SplitPhoneNumber(FetchElm(RetNo, 'T1061', 19), LCountryCode, LArea, LPhoneNumber);
            S['countryCode'] := LCountryCode;
            S['areaCode'] := LArea;
            S['localNumber'] := LPhoneNumber;
          end;
      end;
    end;
  end;   //with TSuperObject(JSON.O['primaryTrusteeContactInformation'])


  //if mailing address is different than the one above
  if FetchElm(RetNo, 'T1061', 40) > '' then
  begin
    with TSuperObject(JSON.O['careOfAddress']) do
    begin
      S['careOf'] := FetchElm(RetNo, 'T1061', 25);

      with TSuperObject(O['address']) do
      begin
        S['addressLineOne']         := FetchElm(RetNo, 'T1061', 27); //S['addressLineTwo'] := '';
        S['city']                   := FetchElm(RetNo, 'T1061', 28);
        S['provinceTerritoryState'] := FetchElm(RetNo, 'T1061', 29);
        S['globalPostalZipCode']    := FetchElm(RetNo, 'T1061', 31);
        S['country']                := GetCountry3FromCountry2(FetchElm(RetNo, 'T1061', 30));
        //20211130 Igor >>>
        if S['country'].IsEmpty then
          S['country'] := 'CAN';
        //20211130 Igor <<<
      end;

      if not AllTrim(FetchElm(RetNo, 'T1061', 26)).IsEmpty then
        with TSuperObject(O['telephoneNumber']) do
        begin
          SplitPhoneNumber(FetchElm(RetNo, 'T1061', 26), LCountryCode, LArea, LPhoneNumber);
          S['countryCode'] := LCountryCode;
          S['areaCode'] := LArea;
          S['localNumber'] := LPhoneNumber;
        end;
    end;
  end; // end if mailing address is different than the one above

  T3JSONList.Text := JSON.AsJSON(true);
end;




procedure createEfileJson(RetNo:Integer; FormName:String; Var T3JsonList:tstringlist; ProdOrTest:String); //20240118 Igor
begin
  CurrTestCaseId := ''; //20240129 Igor
  if SameText(FormName, 'T3') then
    createT3RetJson(RetNo, FormName, T3JsonList, ProdOrTest)
  else if SameText(FormName, 'T3M') then
    createT3MJson(RetNo, FormName, T3JsonList, ProdOrTest)
  else if SameText(FormName, 'T3RCA') then
    createT3RCAJson(RetNo, FormName, T3JsonList, ProdOrTest)
  else if SameText(FormName, 'T3ATH') then
    createT3ATHJson(RetNo, FormName, T3JsonList, ProdOrTest)
  else if SameText(FormName, 'T3D') then
    createT3DJson(RetNo, FormName, T3JsonList, ProdOrTest)
  else if SameText(FormName, 'T3P') then
    createT3PJson(RetNo, FormName, T3JsonList, ProdOrTest)
  else if SameText(FormName, 'T3PRP') then
    createT3PRPJson(RetNo, FormName, T3JsonList, ProdOrTest)
  else if SameText(FormName, 'T3GR') then
    createT3GRJson(RetNo, FormName, T3JsonList, ProdOrTest)
  else if SameText(FormName, 'T3RI') then
    createT3RIJson(RetNo, FormName, T3JsonList, ProdOrTest)
  else if SameText(FormName, 'T3S') then
    createT3SJson(RetNo, FormName, T3JsonList, ProdOrTest)
  else if SameText(FormName, 'T1061') then          //jz 20240326
    createT1061Json(RetNo, FormName, T3JsonList, ProdOrTest);

end;

initialization

  (*
  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3ATHIND_Cert88_MB_TE_TC1247.json');
  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3ATHIND_Cert65_MB_TE_TC1097.json');
  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3ATHIND_Cert66_SK_TE_TC1098.json');
  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3M_Cert87_QC_TE_TC1246.json');
  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3M_Cert63_QC_TE_TC1095.json');
  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3M_Cert64_QC_TE_TC1096.json');
  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3RCA_Cert67_QC_TE_TC1099.json');
  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3RCA_Cert68_BC_TE_TC1100.json');
  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3RCA_Cert89_BC_TE_TC1248.json');
  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3S_Cert86_ON_TE_TC1245.json');
  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3S_Cert61_ON_TE_TC1093.json');
  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3S_Cert62_ON_TE_TC1094.json');

  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3D_Cert70_ON_TE_TC1240.json');
  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3D_Cert71_BC_TE_TC1241.json');
  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3GR_Cert76_ON_TE_TC1230.json');
  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3GR_Cert77_AB_TE_TC1231.json');
  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3GR_Cert78_AB_TE_TC1232.json');
  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3GR_Cert79_BC_TE_TC1233.json');
  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3P_Cert72_ON_TE_TC1242.json');
  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3P_Cert73_ON_TE_TC1243.json');
  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3PRP_Cert74_ON_TE_TC1244.json');
  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3PRP_Cert75_ON_TE_TC1229.json');
  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3RI_Cert84_AB_TE_TC1238.json');
  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3RI_Cert85_AB_TE_TC1239.json');

  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3_RET_Cert45_MULTIBENO_TE_TC1077.json');
  ReSaveJson('c:\vtPrograms\2023\DistrFl\T3-2023\EolFiles\T3_RET_Cert45_MULTIBENO_TE_TC1077_1.json');
  *)

  SetRoundMode(rmNearest); //20250312 Igor

end.
