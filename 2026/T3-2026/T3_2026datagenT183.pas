Unit T3_2026datagenT183;

interface

uses Dialogs, Controls, SysUtils;
//Classes, XSuperObject, System.StrUtils, Variants;

const
  SoftwareID_T3            = '064';    //20230209
  SoftwareID_T1135         = '064AA';  //20230209 //t1135 uses a diffrent software id = 064AA
  SoftwareRevisionDate     = '2026-03-20'; //jz//20260320 - update release date after MJ and T3SP certification // '2026-03-15'; //jz//20260315 - updated release date //20250301 //'2023-02-07';

type
  TT3T183data = record

    trustNumber                       : string;     //trustNumber
    softwareId                        : string;     //softwareId

    softwareRevisionDate              : string;     //softwareRevisionDate
    firstTimeFilerIndicator           : string;     //firstTimeFilerIndicator

    testCaseIdentifier                : string;     //testCaseIdentifier

    additionalTaxReturnIndicator      : string;     //additionalTaxReturnIndicator

    originatingIp                     : string;     //originatingIp

    TransmitterEFilerNumber           : string;     //transmitterEFilerNumber

    PasswordId                        : string;     //passwordId
    TaxPrepEfilerNumber               : string;     //taxPreparerEfilerNumber
    TaxPrepEfilerPassword             : string;     //taxPreparerEfilerPassword
    TaxPrepReturnControlNumber        : string;     //taxPreparerReturnControlNumber

    PreparerAuthIndicator             : string;     //taxPreparerAuthorizationIndicator
    PreparerAuthExpiryDate            : string;     //taxPreparerAuthorizationExpiryDate

    TaxPrepPreAssessRevContactCode    : string;     //taxPreparerPreAssessmentReviewContactCode
    TaxPrepPostAssessRevContactCode   : string;     //taxPreparerPostAssessmentReviewContactCode

    taxProDataRepId                   : string;     //representativeId

    t183ESigIndicator                 : string;     //t183ElectronicSignatureIndicator
    t183ESigDate                      : string;     //t183ElectronicSignatureDate
    t183ESigTime                      : string;     //t183ElectronicSignatureTime

    Function getT183element(index:Integer):variant;

end;

function getT83data(RetNo:integer;isProd:boolean;returnType:string;TestCaseId:string=''):TT3T183data; //20240129 Igor
//function getTrustNumber(RetNo:Integer; IsProd:boolean): String; //jz 20240326
function getDcnSeqNoForT1135(RetNo:Integer;OnLineNo:String):String;
implementation

uses
T3_2026, vtCommon, vtTrimStr, T3_2026Declare, T3_2026TrimStr;

//  SysUtils, DateUtils, vtCommon, vtTrimStr, vtShared,
//  T3_2026,T3_2026declare,T3_2026trimstr, T3_2026Efrules, T3_2026Common2,
//  Vcl.Dialogs, Vcl.Controls; //20211220 Igor



function getT83data(RetNo:integer;isProd:boolean;returnType:string;TestCaseId:string):TT3T183data; //20240129 Igor
var
 i,j : integer; sss:string;
 cd:string;
 t183data:TT3T183data;
 OnLineNo, Password, Url, NetFileDir: string;
begin

  GetEOLParms(OnlineNo,Password,Url,NetFileDir);


  t183data.trustNumber                      := GetTrustNumber(RetNo, ReturnType, isProd); //jz 20240326
  //t183data.softwareId                       := SoftwareID; //20230209

  //jz 20240326
  if returnType = 'T1135' then
    t183data.softwareId                       := SoftwareID_T1135
  else //if returnType = 'T3' then // and others
    t183data.softwareId                       := SoftwareID_T3;



  t183data.softwareRevisionDate             := SoftwareRevisionDate;
  t183data.firstTimeFilerIndicator          := booltostr(SameText(FetchElm(RetNo, 'T3', 27), 'X')); //booltostr(SameText(FetchElm(RetNo, 'EFMEMO', 1), 'X'));

  t183data.additionalTaxReturnIndicator                                             := 'false';
  if FetchElm(RetNo,'EFMEMO',43) = 'Y' then t183data.additionalTaxReturnIndicator   := 'true';  //jz//20260222 - was hardecoded false, added field to be able to change for T3RET CERT17QC

  t183data.testCaseIdentifier := '';
  //20240129 Igor >>>
  if not isProd and (TestCaseId <> '-') then
  begin
    if not TestCaseId.IsEmpty then
          t183data.testCaseIdentifier := TestCaseId
    else if MessageDlg('Insert TestCaseID?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          t183data.testCaseIdentifier := inttostr(GetTestCaseId(RetNo, FetchElm(RetNo,'EFMEMO',17)));  // optional
  end;
  //20240129 Igor <<<

  t183data.originatingIp                    := '0.0.0.0';

  t183data.TransmitterEFilerNumber          := OnLineNo;

  t183data.PasswordId                       := Password;
  t183data.TaxPrepEfilerNumber              := OnLineNo;
  t183data.TaxPrepEfilerPassword            := Password;


  if returnType = 'T1135' then
    t183data.TaxPrepReturnControlNumber       := GetDcnSeqNoForT1135(RetNo,OnLineNo)
  else //if returnType = 'T3' then //jz 20240326
    t183data.TaxPrepReturnControlNumber       := Copy(FetchElm(RetNo,'T183TRUST',21), 6, 8);

  //20230208
  //20230209 Igor >>>
  If FetchElm(RetNo,'EFMEMO',49)>'' then
    t183data.PreparerAuthIndicator:= 'true'
  else
    t183data.PreparerAuthIndicator:= 'false';
  //20230209 Igor <<<
  If FetchElm(RetNo,'EFMEMO',50)>'' then t183data.PreparerAuthExpiryDate:=FetchElm(RetNo,'EFMEMO',50); //  := '2022-11-23';

  if returnType = 'T1135' then
  begin
    //cd:= '0';     //20230208 client
    if SameText(FetchElm(RetNo,'EFMEMO',2),'CONTACT_EFILER_BY_MAIL') then cd:='2'
    else if SameText(FetchElm(RetNo,'EFMEMO',2),'CONTACT_WITH_CLIENT') then cd:='3'
    else cd:='1';
    t183data.TaxPrepPreAssessRevContactCode   := cd;

    //cd:='0';    //20230208
    if SameText(FetchElm(RetNo,'EFMEMO',3),'CONTACT_EFILER_BY_MAIL') then cd:='2'
    else If SameText(FetchElm(RetNo,'EFMEMO',3),'CONTACT_WITH_CLIENT') then cd:='3'
    else cd:='1';
    t183data.TaxPrepPostAssessRevContactCode  := cd;

  end
  else //if returnType = 'T3' then  //T3 and other return type //jz 20240326
  begin  //20230208
    t183data.TaxPrepPreAssessRevContactCode   := AllTrim(FetchElm(RetNo, 'EFMEMO', 2));
    t183data.TaxPrepPostAssessRevContactCode  := AllTrim(FetchElm(RetNo, 'EFMEMO', 3));
  end;

  //If UpperCase(FetchElm(RetNo,'T183TRUST',39))='Y' then   //repid  //20230228
  t183data.taxProDataRepId := FetchElm(RetNo,'T183TRUST',35); //20230228//OptRec.Prp_RepresentativeId;

  if FetchElm(RetNo, 'T183TRUST', 38) = 'Y' then
  begin
    if returnType = 'T1135' then
      t183data.t183ESigIndicator                := '1'
    else //if returnType = 'T3' then //and others            //jz 20240326
      t183data.t183ESigIndicator                := 'True';


    t183data.t183ESigDate                       := FetchElm(RetNo,'T183TRUST',8);
    if t183data.t183ESigDate = '' then
       t183data.t183ESigDate                    := FormatDateTime('yyyy-mm-dd', Now);

    t183data.t183ESigTime                       := FetchElm(RetNo,'T183TRUST',11);
    if t183data.t183ESigTime = '' then
       t183data.t183ESigTime                    := FormatDateTime('hh:nn:ss', Now);

  end
  else
  begin
    if returnType = 'T1135' then
      t183data.t183ESigIndicator                := '0'
    else //returnType = 'T3' then //and others //jz 20240326
      t183data.t183ESigIndicator                := 'False';
  end;

  {
  //**** override if needed for certification
  if not isProd then
  begin
    //sss := FetchElm(RetNo,'EFMEMO',17); if sss > '' then t183data.testCaseIdentifier            := sss;

    sss := FetchElm(RetNo,'EFMEMO',41); if sss > '' then t183data.softwareId                    := sss;
    sss := FetchElm(RetNo,'EFMEMO',42); if sss > '' then t183data.softwareRevisionDate          := sss;
    sss := FetchElm(RetNo,'EFMEMO',43); if sss > '' then t183data.additionalTaxReturnIndicator  := sss;

    sss := FetchElm(RetNo,'EFMEMO',44); if sss > '' then t183data.transmitterEFilerNumber       := sss;
    sss := FetchElm(RetNo,'EFMEMO',45); if sss > '' then t183data.passwordId                    := sss;
    sss := FetchElm(RetNo,'EFMEMO',46); if sss > '' then t183data.taxPrepEfilerNumber           := sss;
    sss := FetchElm(RetNo,'EFMEMO',47); if sss > '' then t183data.taxPrepEfilerPassword         := sss;
    sss := FetchElm(RetNo,'EFMEMO',48); if sss > '' then t183data.taxPrepReturnControlNumber    := sss;

    //sss := FetchElm(RetNo,'EFMEMO',49); if sss > '' then t183data.preparerAuthIndicator         := sss;
    //sss := FetchElm(RetNo,'EFMEMO',50); if sss > '' then t183data.preparerAuthExpiryDate        := sss;

\    sss := FetchElm(RetNo,'EFMEMO',51); if sss > '' then t183data.taxProDataRepId               := sss;

    sss := FetchElm(RetNo,'EFMEMO',52); if sss > '' then t183data.t183ESigDate                  := sss;
    sss := FetchElm(RetNo,'EFMEMO',53); if sss > '' then t183data.t183ESigTime                  := sss;
  end;
  //****
  }

  result := t183data;

end;



{ //jz 20240326
function GetTrustNumber(RetNo:Integer; IsProd:boolean): String;
begin
  if IsProd then
    Result := 'T' + FetchElm(RetNo, 'T3', 2)
  else  //is test
    Result := 'A' + FetchElm(RetNo, 'T3', 2);
end;
}

function getDcnSeqNoForT1135(RetNo:Integer;OnLineNo:String):String;
Var YYYY,MM,DD,Hour,Min,Sec,Msec :word;
 SMM, SDD, SMin,SSec,SMSec : string[2];
 Syyyy:String[4];
 sBirthday:String[2];
 SAppYear:String[2];
begin
   Delay(1);  //to inceasethe second
   DecodeDate(Now,YYYY,MM,DD);
   DecodeTime(Now,Hour,Min,Sec,Msec);
   Syyyy:=AllTrim(IntToStr(YYYY));
   SMM   := LTrim(RTrim(IntToStr(MM)));

   sAppYear:=RightStr(AppYear,2);  //20150128
   SDD   := Ltrim(Rtrim(IntToStr(dd)));
   SMIN  := Ltrim(Rtrim(IntToStr(Min)));
   SSec   := AllTrim(IntToStr(Sec));
   SMSec:=LTrim(RTrim(IntToStr(MSec)));
   If Length(SMM)   =1 then SMM   := '0'+SMM;
   If Length(SDD)   =1 then SDD   := '0'+Sdd;
   If Length(SMIN)  =1 then SMin  := '0'+SMin;
   If Length(SSec)  =1 then SSec  := '0'+SSec;
   If Length(SMSec) =1 then SMSec:= '0'+SMSec;
  // Result:=OnlineNo+smm+Sdd+SSec+SMSec;    //20050128

   // What Birthdate should be used here?
   Result:=sAppYear+Sdd+SSec+{RightStr(GetBirthdate(RetNo),1)+}RightStr(SMSec,1);    //2005

   //If length(result)<> 13 then result:='';
end;





function TT3T183data.getT183element(index:integer):variant;
begin
  Case index of
    1 : result := self.trustNumber;
    2 : result := self.softwareId;

    3 : result := self.softwareRevisionDate;
    4 : result := self.firstTimeFilerIndicator;

    5 : result := self.testCaseIdentifier;

    6 : result := self.additionalTaxReturnIndicator;

    7 : result := self.originatingIp;

    8 : result := self.TransmitterEFilerNumber;

    9 : result := self.PasswordId;
    10: result := self.TaxPrepEfilerNumber;
    11: result := self.TaxPrepEfilerPassword;
    12: result := self.TaxPrepReturnControlNumber;

    13: result := self.PreparerAuthIndicator;
    14: result := self.PreparerAuthExpiryDate;

    15: result := self.TaxPrepPreAssessRevContactCode;
    16: result := self.TaxPrepPostAssessRevContactCode;

    17: result := self.taxProDataRepId;

    18: result := self.t183ESigIndicator;
    19: result := self.t183ESigDate;
    20: result := self.t183ESigTime;
  end;
end;


end.
