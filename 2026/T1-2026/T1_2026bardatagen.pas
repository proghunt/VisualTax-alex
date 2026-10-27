unit T1_2026bardatagen;

{ Notes:
  Inputs: BatchOper: PRTU, TRTU, PSEND, TSEND
  SomeList : First entry has the data directory
  i.e: C:\Data
  12345678.9
  45434567.1
  and then the Names of files for RTU
  IT MUST be copied to RetFiles list(defined here) because
  SomeList is used concurrently by the OpenReturn
}

interface

uses SysUtils, FileCtrl, WinTypes, Messages, Classes, Controls, Forms, StdCtrls,
  Dialogs, Graphics, extctrls, T1_2026TrimStr, T1_2026T1Rtns, T1_2026Declare,
  T1_2026Common, T1_2026Common2, T1_2026EFRules, // T1_2026PopList,
  T1_2026build813,
  T1_2026Pdf417,
  IOUtils // for if directory exists
    ;

Const
  SOFTRELEASE = '20260131'; //20290214 //'20250312'; //20250311 //'20240404'; //'20240223'; //in 2 places Decalare and here //20240406

Const
  DEVELOPER = '064'; { Visual Tax }

Const
  CrLf = Chr(13) + Chr(10);

Const
   FixedFormatLength = 487; //jz//20260216- CarbonRebate removed,
 // FixedFormatLength = 488; //jz//20250304 Retroactive Climate Action removed, fixed length one less //489  // 20240211 //490; //482; //20230124 //20200217

Const
  SFDFixedFormatLength = 568;
  // 20180124 567; //20140124 368; //2009 386; //20100111 389; //{280 in 2000} {T1 records}  //20110114

  // T1REC FIXED PART
Type
  AFX = Record
    RECLEN: String[4]; // 1-4
    RECTYPE: String[2]; // 5-6
    TaxYear: String[4]; // 7-10
    DISCNUMBER: String[8]; // 11-18
    SIN: String[9];
    BIRTHYYYY: String[4];
    BIRTHMM: String[2];
    BIRTHDD: String[2];
    PRVOFRES: String[2];
    PRVOFTAX: String[2];
    MARSTATUS: String[1];
    SPOUSESIN: String[9];
    SPOUSENAME: String[4];
    FIRSTNAME: String[30];
    LASTNAME: String[30];
    CAREOFNAME: String[26];
    STREET: String[60]; // pos 140-199
    CITY: String[50];
    PROVINCE: String[2];
    POSTAL: String[6];
    EMAIL: String[75];
    ProvMoveDate: String[8];
    HomeAddressChange: String[1];
    CLAREA: String[3];
    CLPHONE: String[7];
    LANGUAGE: String[1];
    SPOUSENETINC: String[9];
    SPOUSEUCCB: String[9];
    SPOUSEUCCBREPAY: String[9];

    ISDECEASED: String[1];
    DATEOFDEATH: String[8];
    ISPREBANKRUPT: String[1];
    POSTBANKRUPTNI: String[9];
    POSTBANKRUPTADJNI: String[9];

    // NOT USED in BarCode -----
    DATEOFBANKRUPTCY: String[8];

    SFDRECS: String[2];
    DEVELOPER: String[3];
    SOFTCODE: String[1];
    SoftSerialNumber: String[37]; // 20141226   //blank?
    SOFTRELEASE: String[8];

    FDEADLINE: String[1];
    CANCITIZEN: String[1];
    ELECTION: String[2];
    Aborigvalue: String[1];
    // Aborig lands NL, YT Was FnCvalue -> AborigValue   //20170116 //jz//20250304 BC removed from Aborigvalue as per ch8-24e.pdf
    NTLandsTlicho: String[1]; // pos 464
    // 20140124 //20170116 NT Tlicho resident //renamded 20170116
    NTLandsDeline: String[1]; // 465 // 20140124 20170116 NT Deline resident
    YTFIRSTNation: String[5]; // 466 to 470  //pos 466-470
    // Yukon First nation settlement  renamed from firstnation
    SelfGovFNation: String[1]; // 471
    // 20121225  //BC, NT and YT  self-governing  YtCitizenFn //jz//20250304 BC removed as per ch8-24e.pdf
    PresentPrv: String[2]; // 472 to 473
    IndianExemptIncome: String[1]; // 474
    ReservedField: String[8]; // 20200217   //475-482

    //CarbonRebate: String[1]; //jz//20260216 //Fx.CarbonRebate removed as per https://www.cra-arc.gc.ca/advanced/t1-efile-netfile/ch8-25e.pdf //jz//20250304 //added as per ch8-24e.pdf

    //ClimateAction: String[1]; //jz//20250304 //removed as per ch8-24e.pdf
    //RetroClimateAction: String[1]; // 484 for nb //jz//20250304 //removed as per ch8-24e.pdf

    MaritalStatuschangeDate: String[4]; // 485-488
    ConsentOrganAndTissue: String[1]; // 489     //490
    // TsawwassenResidence: String[1];         //20240210488
    // TsawwassenFirstNationIndicator: String[1];  //20240210      //489 //20230127
  end;

  // SFD FIXED TYPE for partners section
Type
  PartnerRec = Record
    PFirstName: String[30];
    PLastName: String[30];
    PSin: String[8];
    PPerCent: String[6]; // new 2005
  end;

  // SFD FIXED TYPE
Type
  ASfdFX = Record
    RECLEN: String[4];
    RECTYPE: String[2];
    SFDREC: String[2];
    BUSTYPE: String[2]; // 20180201 instead of 1

    FARMPROV: String[2];
    NAICS: String[6];
    SIN: String[9];
    BUSNAME: String[30];
    BUSADDRESS: String[30];
    BUSPOSTAL: String[6];
    BUSFISCSTART: String[8];
    BUSFISCEND: String[8];
    // ACROWNED       : String[9];  //out  //20110114
    // ACRFARMED      : String[9];  //out  //20110114
    ACCMETHOD: String[1];
    BUSPARTNID: String[9];
    BUSPERCENT: String[4]; { was }
    BUSTAXSHELTNO: String[8];
    BUSFINALYR: String[1];
    BUSNUMBER: String[15];
    // 20140124
    InternetPages: String[4];
    WebAddr1: String[96];
    WebAddr2: String[96];
    WebPercent: String[3]; // 20160121  //20160121 //String[3];

    P1FIRSTNAME: String[30];
    P1LASTNAME: String[30];
    P1SIN: String[8]; // from 9 //20110114
    P1OWNPERCENT: String[6];
    P2FIRSTNAME: String[30];
    P2LASTNAME: String[30];
    P2SIN: String[8]; // from 9 //20110114
    P2OWNPERCENT: String[6];
    P3FIRSTNAME: String[30];
    P3LASTNAME: String[30];
    P3SIN: String[8]; // //from 9 //20110114
    P3OWNPERCENT: String[6];

    PRec: Array [1 .. 6] of PartnerRec;
  end;

  // 1013 FIXED TYPE
Type
  A1013FX = Record
    UDN: string[25];
    // part 1
    taxPayerFirstName: string[30];
    taxPayerlastName: string[30];
    SIN: string[9];
    TrustName: String[60]; // 20180205
    // part 2
    repID: string[7];
    groupID: string[6];
    BN: string[9];
    authLevel: string[1];
    repFirstNameAssociated: string[30];
    repLastNameAssociated: string[30];
    BNNameAssociated: string[60];
    // part 3
    repFirstName: string[30];
    repLastName: string[30];
    repBusinessName: string[60];
    repTelephoneNumber: string[10];
    repExt: string[6];
    repFax: string[10];
    allTaxYearsCB: string[1];
    authLevelAllYears: string[1];
    specificTaxYearsCB: string[1];
    // tables
    specificTaxYears: array [1 .. 10] of string[4];
    specificauthLevel: array [1 .. 10] of string[1];
    // part 4
    expiryDate: string[8];
    // part 5
    cancelAllCB: string[1];
    cancelSpecificCB: string[1];
    repFirstNameCancel: string[30];
    repLastNameCancel: string[30];
    repBusinessCancel: string[60];
    repIDCancel: string[7];
    groupIDCancel: string[6];
    BNCancel: string[9];
    // part 6
    PrintName: string[60];
    LegalSignitureCB: string[1];
    SignitureDate: string[8];
    VendorCertCode: string[4];
  end;

  (*
    //T1REC FIXED PART
    Type
    AFX  = Record
    RECLEN          : String[4];
    RECTYPE         : String[2];
    TaxYear         : String[4];
    DISCNUMBER      : String[8];
    SIN             : String[9];
    BIRTHYYYY       : String[4];
    BIRTHMM         : String[2];
    BIRTHDD         : String[2];
    PRVOFRES        : String[2];
    PRVOFTAX        : String[2];
    MARSTATUS       : String[1];
    SPOUSESIN       : String[9];
    SPOUSENAME      : String[4];
    FIRSTNAME       : String[30];
    LASTNAME        : String[30];
    CAREOFNAME      : String[26];
    STREET          : String[60];
    CITY            : String[50];
    PROVINCE        : String[2];
    POSTAL          : String[6];
    ProvMoveDate    : String[8];  //20121226  NEW
    HomeAddressChange : String[1]; //20121226  NEW
    CLAREA          : String[3];
    CLPHONE         : String[7];
    LANGUAGE        : String[1];
    GSTYESNO        : String[1];
    SPOUSENETINC    : String[9];
    SPOUSEUCCB      : String[9];
    SPOUSEUCCBREPAY : String[9];

    //new in 2008  27 bytes
    ISDECEASED      : String[1];
    DATEOFDEATH     : String[8];
    ISPREBANKRUPT   : String[1];
    POSTBANKRUPTNI  : String[9];
    POSTBANKRUPTADJNI  : String[9];

    DATEOFBANKRUPTCY:String[8];    //NOT USED in BarCode


    SFDRECS         : String[2];
    DEVELOPER       : String[3];
    SOFTCODE        : String[1];
    SOFTRELEASE     : String[8];
    FDEADLINE       : String[1];
    CANCITIZEN      : String[1];
    ELECTION        : String[2];
    FNCvalue        : String[1];
    NTLands         : String[1];  //20140124
    FIRSTNation     : String[5];
    CitizenFN     : String[1];   //20121225  NEW
    PresentPrv      : String[2];
    end;

    //SFD FIXED TYPE for partners section
    Type
    PartnerRec = Record
    PFirstName    :String[30];
    PLastName     :String[30];
    PSin          :String[8];
    PPerCent      :String[6];  //new 2005
    end;

    //SFD FIXED TYPE
    Type
    ASfdFX   = Record
    RECLEN         : String[4];
    RECTYPE        : String[2];
    SFDREC         : String[2];
    BUSTYPE        : String[1];
    FARMPROV       : String[2];
    NAICS          : String[6];
    SIN            : String[9];
    BUSNAME        : String[30];
    BUSADDRESS     : String[30];
    BUSPOSTAL      : String[6];
    BUSFISCSTART   : String[8];
    BUSFISCEND     : String[8];
    // ACROWNED       : String[9];  //out  //20110114
    // ACRFARMED      : String[9];  //out  //20110114
    ACCMETHOD      : String[1];
    BUSPARTNID     : String[9];
    BUSPERCENT     : String[4];   {was}
    BUSTAXSHELTNO  : String[8];
    BUSFINALYR     : String[1];
    BUSNUMBER      : String[15];
    //20140124
    InternetPages  : String[4];
    WebAddr1       : String[96];
    WebAddr2       : String[96];
    WebPercent     : String[3];

    P1FIRSTNAME    : String[30];
    P1LASTNAME     : String[30];
    P1SIN          : String[8];  //from 9 //20110114
    P1OWNPERCENT   : String[6];
    P2FIRSTNAME    : String[30];
    P2LASTNAME     : String[30];
    P2SIN          : String[8];  //from 9 //20110114
    P2OWNPERCENT   : String[6];
    P3FIRSTNAME    : String[30];
    P3LASTNAME     : String[30];
    P3SIN          : String[8];  // //from 9 //20110114
    P3OWNPERCENT   : String[6];

    PRec : Array[1..6] of PartnerRec;
    end;

    //1013 FIXED TYPE
    Type
    A1013FX   = Record
    UDN                : string[25];
    //part 1
    taxPayerFirstName  : string[30];
    taxPayerlastName   : string[30];
    SIN                : string[9];
    //part 2
    repID              : string[7];
    groupID            : string[6];
    BN                 : string[9];
    authLevel          : string[1];
    repFirstNameAssociated : string[30];
    repLastNameAssociated  : string[30];
    BNNameAssociated       : string[60];
    //part 3
    repFirstName       : string[30];
    repLastName        : string[30];
    repBusinessName    : string[60];
    repTelephoneNumber : string[10];
    repExt             : string[6];
    repFax             : string[10];
    allTaxYearsCB      : string[1];
    authLevelAllYears  : string[1];
    specificTaxYearsCB : string[1];
    //tables
    specificTaxYears   : array[1..10] of string[4];
    specificauthLevel  : array[1..10] of string[1];
    //part 4
    expiryDate         : string[8];
    //part 5
    cancelAllCB        : string[1];
    cancelSpecificCB   : string[1];
    repFirstNameCancel : string[30];
    repLastNameCancel  : string[30];
    repBusinessCancel  : string[60];
    repIDCancel        : string[7];
    groupIDCancel      : string[6];
    BNCancel           : string[9];
    //part 6
    PrintName          : string[60];
    LegalSignitureCB   : string[1];
    SignitureDate      : string[8];
    VendorCertCode     : string[4];
    end;
  *)

Procedure clearPRecArray;
Procedure SaveBarDataToText;
// Procedure SaveTeRecText;
Procedure SaveT1RecToText(Buf: AnsiString); // 20220427

Function ExcludeFormsInMult(FName: String; FrmSource: String; LLine: Integer)
  : Boolean; // 20190206

Procedure PrepareT1Rec(RetNo: Integer);
Procedure AppendT1Rec;
procedure CreateBarCode(SplitBarDataArray: Array of AnsiString;
  var BarCodeImageArray: Array of TImage);

Procedure PrepareSFDRec(RetNo: Integer; SFDFormName: String);
Procedure AppendSFDRec(RetNo: Integer; SFDFormName: String);
// ApendSfdRec  //20140124
procedure CreateSFDBarCode(SFDBarDataArray: Array of AnsiString;
  var BarCodeImageArray: Array of TImage);

Procedure Prepare1013Rec(RetNo: Integer; FormName1013: String);
Procedure Append1013Rec;
procedure Create1013BarCode(BarData1013: AnsiString;
  var BarCodeImage1013: TImage);
procedure DrawQRCode(AData: string; ACanvas: TCanvas; ARect: TRect);
// 20180307 Igor

Procedure FindSFDFormNamesForBarCode(RetNo: Integer;
  Var BarFormNames: TStringList);
Procedure PrepareRental(RetNo: Integer; FInst: String);
Procedure PrepareBusiness(RetNo: Integer; FInst: String);
Procedure PrepareFishing(RetNo: Integer; FInst: String);
Procedure PrepareFarming(RetNo: Integer; FInst: String);
Procedure PrepareT777(RetNo: Integer; FInst: String);
// Procedure PrepareT777S(RetNo: Integer; FInst: String);
Procedure PrepareTL2(RetNo: Integer; FInst: String);
Procedure PrepareT2091(RetNo: Integer; FInst: String);

Function FormatBusPercent(s: string): String;

Function GetStreet(RetNo: Integer): String;
Function GetNetFileAmount(RetNo: Integer; LLine: Integer; LType: string;
  FName: string; ElmNo: Integer; Rule: Integer): String;
Procedure AddStringToBuffers(LLine: Integer; s: String);
Procedure RemoveLastDashFromBuffers;
// Function IsEfOverride(Lline:Integer):Boolean;
// Function GetEfOverride(Lline:Integer):real;
Function GetAmount(RetNo: Integer; LLine: Integer; LType: string; FName: string;
  ElmNo: Integer; Rule: Integer): String;
Function FormatFourDigitPercent(s: string): String;
// Function FormatBusPercent(s:string):String;

Var

  Fx: AFX;
  SFD: ASfdFX;
  FX1013: A1013FX;
  EFlines: TStringList;
  TRANSMTYPE: String;
  RTUNumber: String;
  BatchOper: String;
  DataDir: string;
  EncDir: String;
  FlName: String; { the output RTU }
  RetFile: String; { the return file being processed }
  F1: TextFile; { output file }
  TotT1Recs: Integer;
  VariableBuffer, FxRec, SFDFxRec, FX1013Rec: AnsiString;
  RetFiles: TStringList;
  SfdRecNumber: Integer; { sfd counter on each return }

Implementation

uses
  vtCommon, T1_2026,
  vtMulti, // 20170115
  T1_2026Clients,
  vtTrimStr, vtShared,
  DelphiZXIngQRCode; // 20180307 Igor

Procedure PrepareT1Rec(RetNo: Integer);
Var
  i, Rule, LLine, ElmNo: Integer;
  LType: string[1];
  FName: string[12];
  s: string;
  LLineString: String[5]; // 20200102

  TempList1, TempList2: TStringList;
  FrmSource: string;

Begin
  VariableBuffer := '';
  { FIXED PART }
  Fx.RECTYPE := '01'; // as per the specs
  Fx.TaxYear := AppYear;
  If FetchElm(RetNo, 'INFO', 102) > '' then // 20130124
    // If FetchElm(RetNo,'T1',47) ='3' then {discounted return}
    Fx.DISCNUMBER := OptRec.Prp_DiscNo
  ELSE
    Fx.DISCNUMBER := '00000000';
  Fx.SIN := RemoveHyphens(FetchElm(RetNo, 'T1', 3));
  Fx.BIRTHYYYY := PaddZero(LeftStr(FetchElm(RetNo, 'T1', 9), 4), 4);
  Fx.BIRTHMM := PaddZero(MidStr(FetchElm(RetNo, 'T1', 9), 6, 2), 2);
  Fx.BIRTHDD := PaddZero(RightStr(FetchElm(RetNo, 'T1', 9), 2), 2);

  Fx.PRVOFRES := Ret[RetNo].PROVINCE;
  Fx.PRVOFTAX := Ret[RetNo].PROVINCE;
  if FetchElm(RetNo, 'T2203', 110) > '' then
    Fx.PRVOFTAX := 'MJ'; // 20200211
  // ---------------------------------------------
  Fx.MARSTATUS := IntToStr(Ret[RetNo].MARSTATUS);
  Fx.SPOUSESIN := FetchElm(RetNo, 'T1', 4);
  Fx.SPOUSEUCCB := AllTrim(NoDecimal(FloatToStr(GetSpouseUCCB(RetNo))));
  Fx.SPOUSEUCCBREPAY :=
    AllTrim(NoDecimal(FloatToStr(Vl(FetchElm(RetNo, 'INFO', 162)))));
  IF Fx.SPOUSESIN = '' THEN
    Fx.SPOUSESIN := '000000000';
  Fx.SPOUSENAME := UpperCase(FetchElm(RetNo, 'T1', 20));
  Fx.FIRSTNAME := UpperCase(FetchElm(RetNo, 'T1', 2));
  Fx.LASTNAME := UpperCase(LeftStr(FetchElm(RetNo, 'T1', 5), 30));
  Fx.CAREOFNAME := UpperCase(FetchElm(RetNo, 'T1', 8));
  Fx.STREET := UpperCase(GetStreet(RetNo));
  Fx.CITY := UpperCase(FetchElm(RetNo, 'T1', 10));
  If Length(FetchElm(RetNo, 'T1', 14)) = 2 then
    Fx.PROVINCE := FetchElm(RetNo, 'T1', 14)
  else
    Fx.PROVINCE := GetShortPrv(FetchElm(RetNo, 'T1', 14));
  Fx.POSTAL := Mtrim(FetchElm(RetNo, 'T1', 15));
  Fx.EMAIL := AllTrim(FetchElm(RetNo, 'INFO', 64)); // 20170115
  If FetchElm(RetNo, 'INFO', 171) > '' then
    Fx.ProvMoveDate := ReplaceChar(FetchElm(RetNo, 'INFO', 171), '-', '')
  Else
    Fx.ProvMoveDate := '00000000';
  If FetchElm(RetNo, 'INFO', 169) > '' then // 20121227
    Fx.HomeAddressChange := '1'
  Else
    Fx.HomeAddressChange := '0'; // 20180122 //FX.HomeAddressChange :='2';
  Fx.CLAREA := PaddZero(FetchElm(RetNo, 'T1', 441), 3);
  Fx.CLPHONE := PaddZero(RemoveHyphens(Mtrim(FetchElm(RetNo, 'T1', 442))), 7);

  If FetchElm(RetNo, 'T1', 34) > '' then
    Fx.LANGUAGE := '1'
  else
    Fx.LANGUAGE := '2';

  Fx.SPOUSENETINC :=
    PaddZero(NoDecimal(FloatToStr(Vl(FetchElmFNo(RetNo, InfoFno, 19)))), 9);
  // 20190131
  // Fx.SPOUSENETINC := PaddZero(NoDecimal(FloatToStr(SpouseIncome(RetNo))), 9);
  IF SpouseIncome(RetNo) <= 0 THEN
    Fx.SPOUSENETINC := '000000000';
  If (Ret[RetNo].MARSTATUS > 2) and (FetchElm(RetNo, 'T1', 65) = '') then
    Fx.SPOUSENETINC := '000000000'; { death }

  // new in 2008
  If ISDECEASED(RetNo) then
  begin
    Fx.ISDECEASED := '1';
    Fx.DATEOFDEATH := ReplaceChar(FetchElm(RetNo, 'INFO', 24), '-', '')
  end
  else
  begin
    Fx.ISDECEASED := '0';
    Fx.DATEOFDEATH := '00000000';
  end;

  If IsPreBankruptcyReturn(RetNo) then
  begin
    Fx.ISPREBANKRUPT := '1';
    Fx.POSTBANKRUPTNI :=
      PaddZero(NoDecimal(FloatToStr(Vl(FetchElm(RetNo, 'BANKRPT', 13)))), 9);
    Fx.DATEOFBANKRUPTCY := ReplaceChar(FetchElm(RetNo, 'BANKRPT', 1), '-', '')

  end
  else
  begin
    Fx.ISPREBANKRUPT := '0';
    Fx.POSTBANKRUPTNI := '000000000';
    Fx.DATEOFBANKRUPTCY := '00000000';
  end;

  Fx.SFDRECS := PaddZero(IntToStr(GetNumberOfSFDsForBarcode(RetNo)), 2);
  Fx.DEVELOPER := DEVELOPER;
  Fx.SOFTCODE := 'F';
  // 'D';20120112  //20100110 D=EOLPlus, B=EOL  C=NetFile E=XML plus  F=XML EOL
  // 20170115
  Fx.SoftSerialNumber := LeftStr(GetAuthorizationKey, 37);
  // 20141226   //was 40  //20170116
  If LicenseLevel = llLimited then
    Fx.SoftSerialNumber := ''; // 20170115

  Fx.SOFTRELEASE := SOFTRELEASE;

  If FetchElm(RetNo, 'T1', 36) > '' then
    Fx.FDEADLINE := '1'
  else
    Fx.FDEADLINE := '0';


  Fx.CANCITIZEN := '0';                                                         //jz//20250217 - default is 0
  If      UpperCase(FetchElm(RetNo, 'T1', 164)) > '' then Fx.CANCITIZEN := '1'  //jz//20250217 - add if is 1
  else If UpperCase(FetchElm(RetNo, 'T1', 165)) > '' then Fx.CANCITIZEN := '2';


  Fx.ELECTION := '00';
  If UpperCase(FetchElm(RetNo, 'T1', 43)) > '' then
    Fx.ELECTION := '01'
  else if UpperCase(FetchElm(RetNo, 'T1', 44)) > '' then
    Fx.ELECTION := '02';

  // 20170115
  Fx.SelfGovFNation := '0';
  IF (Ret[RetNo].PROVINCE = 'YT') then
  begin
    If (FetchElm(RetNo, 'INFO', 132) > '') then
      Fx.SelfGovFNation := '1'; // YtCitizenFn //20170116
  end;
  IF (Ret[RetNo].PROVINCE = 'NT') then
  begin
    If (FetchElm(RetNo, 'INFO', 23) > '') then
      Fx.SelfGovFNation := '1'; // YtCitizenFn //20170116
  end;

  //jz//20250304 BC removed from SelfGovFNation as per ch8-24e.pdf
  {
  IF (Ret[RetNo].PROVINCE = 'BC') then
  begin
    If (FetchElm(RetNo, 'INFO', 23) > '') then
      Fx.SelfGovFNation := '1'; // YtCitizenFn //20170116
  end;
  }

  // 20170116
  Fx.Aborigvalue := '0';
  IF (Ret[RetNo].PROVINCE = 'NL') Or  //(Ret[RetNo].PROVINCE = 'BC') Or //jz//20250304 BC removed as per ch8-24e.pdf
    (Ret[RetNo].PROVINCE = 'YT') then
  begin
    If FetchElm(RetNo, 'INFO', 218) > '' then
      Fx.Aborigvalue := '1'; // else FX.AborigValue:='0';
    If FetchElm(RetNo, 'INFO', 219) > '' then
      Fx.Aborigvalue := '2';
  end;

  // 20170116
  Fx.NTLandsTlicho := '0'; // 20170116
  If Ret[RetNo].PROVINCE = 'NT' then
  begin
    If FetchElm(RetNo, 'INFO', 90) > '' then
      Fx.NTLandsTlicho := '1'; // else FX.NTLandsTlicho:='0';
    If FetchElm(RetNo, 'INFO', 137) > '' then
      Fx.NTLandsTlicho := '2';
  end;

  Fx.NTLandsDeline := '0'; // 20170116
  If Ret[RetNo].PROVINCE = 'NT' then
  begin
    If FetchElm(RetNo, 'INFO', 268) > '' then
      Fx.NTLandsDeline := '1'; // else FX.NTLandsDeline:='0';
    If FetchElm(RetNo, 'INFO', 269) > '' then
      Fx.NTLandsDeline := '2';
  end;
  // ------------------------------

  If GetFirstNationNumber(RetNo) > '' then
    Fx.YTFIRSTNation := GetFirstNationNumber(RetNo)
  else
    Fx.YTFIRSTNation := '00000';

  Fx.PresentPrv := PaddR(FetchElm(RetNo, 'T1', 66), 2); // 20170116
  // 20200128
  if FetchElm(RetNo, 'INFO', 128) > '' then
    Fx.IndianExemptIncome := '1'
  Else
    Fx.IndianExemptIncome := '0';

  Fx.ReservedField := '   00000'; // 20200217

  //jz//20260216 //Fx.CarbonRebate removed as per https://www.cra-arc.gc.ca/advanced/t1-efile-netfile/ch8-25e.pdf
  {
  Fx.CarbonRebate := '0';
  if Ret[RetNo].PROVINCE = 'NB' then
  Begin
    if FetchElmFNo(RetNo, InfoFno, 198) > '' then // 20240211
      Fx.CarbonRebate := '1'
    Else
      Fx.CarbonRebate := '2';
  End
  Else if FetchElmFNo(RetNo, InfoFno, 198) > '' then // 20240211
    Fx.CarbonRebate := '1';
  }

   //jz//20250304 //ClimateAction renamed to CarbonRebate as per ch8-24e.pdf <<<
  {
  // 20240210  //con
  Fx.ClimateAction := '0';
  if Ret[RetNo].PROVINCE = 'NB' then
  Begin
    if FetchElmFNo(RetNo, InfoFno, 198) > '' then // 20240211
      Fx.ClimateAction := '1'
    Else
      Fx.ClimateAction := '2';
  End
  Else if FetchElmFNo(RetNo, InfoFno, 198) > '' then // 20240211
    Fx.ClimateAction := '1';
   //jz//20250304 //ClimateAction removed as per ch8-24e.pdf <<<
  }

   //jz//20250304 //RetroClimateAction removed as per ch8-24e.pdf <<<
  {
  // jz 20240209 <<<
  Fx.RetroClimateAction := '0'; // 20240211
  if Ret[RetNo].PROVINCE = 'NB' then
  begin
    if FetchElmFNo(RetNo, InfoFno, 225) > '' then
      Fx.RetroClimateAction := '1' // 20240211
    else
      Fx.RetroClimateAction := '2'
  end;
  // jz 20240209 >>>
  }
  //jz//20250304 //RetroClimateAction removed as per ch8-24e.pdf >>>

  Fx.MaritalStatuschangeDate := '0000';
  If (FetchElmFNo(RetNo, InfoFno, 39) > '') and
    (FetchElmFNo(RetNo, InfoFno, 40) > '') then
    Fx.MaritalStatuschangeDate := FetchElmFNo(RetNo, InfoFno, 39) +
      FetchElmFNo(RetNo, InfoFno, 40);

  // jz 20240209 <<< removed as per specs
  // Fx.TsawwassenResidence:='0'; //when we do '2'???
  // If FetchElmFNo(RetNo,INFOFNo,190)>'' then Fx.TsawwassenResidence:='1';
  // 20230227
  // FX.TsawwassenFirstNationIndicator:='0';

  // If FetchElmFNo(RetNo,INFOFNo,194)>'' then Fx.TsawwassenFirstNationIndicator:='1';
  // If FetchElmFNo(RetNo,INFOFNo,195)>'' then FX.TsawwassenFirstNationIndicator:='2';

  { //20230127   Was it First nation as above?
    Fx.TsawwassenMembership:='0';
    If FetchElmFNo(RetNo,INFOFNo,194)>'' then
    Fx.TsawwassenMembership:='1'
    else  //20230127
    Fx.TsawwassenMembership:='2';
  }

  //jz//20240218 >>>
  Fx.ConsentOrganAndTissue := '0';
  //jz//20250216 //only have value if is correct prov
  if (Ret[Retno].Province = 'ON') or
     (Ret[Retno].Province = 'NU') or
     (Ret[Retno].Province = 'BC') or
     (Ret[RetNo].PROVINCE = 'AB')   //jz 20250216 - ab added as per ch5-25e.pdf
  then
  Begin
     If FetchElm(RetNo, 'T1', 505) > '' then
        Fx.ConsentOrganAndTissue := '1'
     Else If FetchElm(RetNo, 'T1', 506) > '' then //20240515
        Fx.ConsentOrganAndTissue := '2';
  end;




  // ---------------------FREE FORMAT PART ----------------------------------------------
  EFlines := TStringList.Create;
  //20250130
  EFlines.LoadFromFile(AppDir + '\' + GetEfileDname(RetNo));
  //EFlines.LoadFromFile(AppDir + '\' + 'EFLINE.D');


  { 12345678901234567890123
    {Format nnnnn$ fffffffff elm rrr }

  // jz 20190206
  if IsMultJurisdiction(RetNo) then
  Begin
    TempList1 := TStringList.Create;
    for i := 0 to EFlines.Count - 1 do
    begin
      TempList1.add(EFlines[i]);
    end;

    // temp 20220419
    // LLine := MyStrToInt(AllTrim(LeftStr(EFlines[i], 5)));
    // if lline=58340 then Showmessage('58340');
    // temp 20220419

    // for i:=0 to Eflines.Count-2 do begin TempList1.add(Eflines[i]);end; //remove the last entry of the Efiles.d
    TempList2 := TStringList.Create;
    TempList2.LoadFromFile(AppDir + '\' + 'EFLINET2203.D');
    EFlines.Clear;
    // combine them
    for i := 0 to TempList1.Count - 1 do
      EFlines.add(TempList1[i]);
    for i := 0 to TempList2.Count - 1 do
      EFlines.add(TempList2[i]);
    TempList1.Free;
    TempList2.Free;
  End;

  For i := 0 to EFlines.Count - 1 do
  begin
    // 20190709 Igor >>>
    LLine := MyStrToInt(AllTrim(LeftStr(EFlines[i], 5)));
    LType := UpperCase(MidStr(EFlines[i], 6, 1));
    FName := AllTrim(MidStr(EFlines[i], 8, 9));
    ElmNo := MyStrToInt(AllTrim(MidStr(EFlines[i], 18, 3)));
    FrmSource := MidStr(EFlines[i], 31, 7); // for MJ //jz 20190206
    If MidStr(EFlines[i], 22, 1) = 'R' then
      Rule := MyStrToInt(AllTrim(MidStr(EFlines[i], 23, 5))) // 20191128
    else
      Rule := 0;

    // if ((LLINE=60999) and (GetSinNo(RetNo)='870001138')) then rule:=0; //20190323  //MJ ONE

    If LLine > 0 then // 20191129
    begin
      // if lline=60720 then Begin Showmessage('60720');end;  //20230511

      s := GetAmount(RetNo, LLine, LType, FName, ElmNo, Rule);

      if (LLine = 17905) and (s = '0') then
        s := ''; // 20231228

      //20240405
      if Immigrant(RetNo) then begin If (LLine = 52920) and (s = '0') then s := '0';end;
      if Immigrant(RetNo) then begin if (LLine = 52930) and (s = '0') then s := '0';end;
      //---------------------

      if (LLine = 46000) or (LLine = 46100) or (LLine = 46200) then
        s := ''; // tdd not alloed in bar code //20200204

      if (LLine = 42100) and (s = '0') then
        s := ''; // 20220207  CPP payable
      if (LLine = 44800) and (s = '0') then
        s := ''; // 20220207 CPP overpayment

      If (LLine = 50340) and (Vl(FetchElm(RetNo, 'EFMEMO', 24)) = 1) and
        (Vl(FetchElm(RetNo, 'EFMEMO', 23)) = 5034) then
        s := '1';

      If LLine = 48900 then
      Begin
        s := GetEfilerNo; // 20150112
        If FetchElm(RetNo, 'INFO', 103) > '' then
          s := ''; // volunteer    //20150118
      end;

      If (LLine = 31000) and (s = '0') Then
        s := ''; // 20170215
      If (LLine = 22200) and (s = '0') Then
        s := ''; // 20170215
      // 20190709 Igor <<<

      if (LLine = 40600) and (s = '0') then
        s := ''; // 20200205
      if (LLine = 41700) and (s = '0') then
        s := ''; // 20200205
      if (LLine = 50320) then
        L50320Val := s; // 20200206

      if (LLine = 50372) then
      begin
        if s > '' then
          s := AddleadingZeros(s, 2); // needs 2 digits //20200211 //20200213
      end;

     //20251227cz
     {form deleted
      // 20200205
      If LLine = 63790 then
      Begin
        if Ret[RetNo].PROVINCE = 'YT' then
        begin
          if UpperCase(FetchElm(RetNo, 'S14YT', 1)) = 'X' then
            s := '1'
          else
            s := '2'; // 20240214
        end
        Else
          s := '';
      End;
    }
      { //20240104
        //20200211  only case #72 and in bar code. Efile was ok
        If GetSinno(RetNo)='870001062' then  //58200 instead of 30800 and 58300 instead of 31200
        begin
        if (LLine=30800) then s:='';
        if (LLine=31200) then s:='';
        //above must show on the kfs
        end;
      }
      // --------------------------------
      If s > '' then
      begin
        If LLine < 100 then
          LLineString := PaddZero(IntToStr(LLine), 3)
        else
          LLineString := IntToStr(LLine);
        s := ReplaceChar(s, '-', '&');

        if IsMultJurisdiction(RetNo) = false then // jz 20190206
        begin
          VariableBuffer := VariableBuffer + LLineString + s + '-';
          // ShowMessage(LLineString + s);
        end
        else
        begin
          if ExcludeFormsInMult(FName, FrmSource, LLine) = false then
            VariableBuffer := VariableBuffer + LLineString + s + '-';
        end;
      end; // If s > ''
    end;
  end;

  RemoveLastDashFromBuffers;

  // ShowMessage('Bara data size= '+VariableBuffer);
  // ShowMessage('Bara data size= '+IntToStr(Length(VariableBuffer)));

  EFlines.Free;
End;

// 20190206 is a duplicate ExcludeFormsInMult in unit Unit T1_2026EfileRtns;
Function ExcludeFormsInMult(FName: String; FrmSource: String; LLine: Integer)
  : Boolean; // 20180404
Var
  Nm: String;
Begin
  Result := false;
  FName := UpperCase(FName);
  FrmSource := UpperCase(FrmSource);

  If FName = 'MB428A' Then
    exit; // 20180405  allow it

  If MidStr(FName, 3, 3) = '428' then
  Begin
    if FName = 'YT428' then // 20230510
    Begin
      if LLine = 63810 then
      begin
        Result := false;
        Showmessage('63810');
      end; // allow it
    end
    Else
    Begin
      Result := True;
      exit; // do not allow it
    end;
  end; // do not allow it //20180406

  if (FName = 'S6') and (LLine = 38108) then
  begin
    Result := false;
    exit;
  End; // allowe it //20220428

  // 20220428
  If FName = 'ON479A' then // provincial credits
  Begin
    if LLine = 63047 then
    begin
      Result := false;
      exit;
    End; // allowe it //20220427
    if LLine = 63050 then
    begin
      Result := false;
      exit;
    End; // allowe it //20220511
    Result := True;
    exit;
  End;

  If MidStr(FName, 3, 3) = '479' then // provincial credits
  Begin
    // ADDED TODAY //20220427
    if LLine = 63047 then
    begin
      Result := false;
      exit;
    End; // allowe it //20220427
    if LLine = 63050 then
    begin
      Result := false;
      exit;
    End; // allowe it //20220427

    // ----------20230511 make then 5 digit numbers------------------
    if LLine = 60760 then
    begin
      Result := false;
      exit;
    End; // 20180405  //allow it
    if LLine = 60999 then
    begin
      Result := false;
      exit;
    End; // 20180405  //allow it
    if LLine = 60480 then
    begin
      Result := false;
      exit;
    End; // 20180404  //allow it
    if LLine = 6392 then
    begin
      Result := false;
      exit;
    End; // 20180404  //allow it Case 3 for YT

    if LLine = 60720 then
    begin
      Result := false;
      exit;
    End; // 20230511  //allow it

    { no good
      //on479 allow it //20200520
      if Lline=63255 then begin Result:=False;Exit;End;
      if Lline=63260 then begin Result:=False;Exit;End;
      if Lline=63270 then begin Result:=False;Exit;End;
    }
    Result := True;
    exit;
  end;
  if FName = 'S2PRV' then
  Begin
    Result := True;
    exit;
  end; // do not allow it
  if FName = 'S11PRV' then
  Begin
    Result := True;
    exit;
  end; // do not allow it
  if FrmSource = 'FORM428' then
  Begin
    Result := True;
    exit;
  end; // do not allow it //20180404
end;

Procedure AppendSFDRec(RetNo: Integer; SFDFormName: String);
// 2014 was AppendSfd
var
  i: Integer;
  BarDataList: TStringList;
  s: String;
begin
  i := SFDFixedFormatLength + Length(VariableBuffer) + Length('-EOD');
  SFD.RECLEN := PaddZero(IntToStr(i), 4);
  If LeftStr(Fx.RECLEN, 1) = ' ' then
    Fx.RECLEN := '0' + Ltrim(Fx.RECLEN);

  SFDFxRec := '';

  if LeftStr(SFDFormName, 6) = 'T2091#' then
    SFD.BUSTYPE := '11'; // 20180201

  SFDFxRec := PaddZero(SFD.RECLEN, 4) + PaddZero(SFD.RECTYPE, 2) +
    PaddZero(SFD.SFDREC, 2) + PaddZero(SFD.BUSTYPE, 2)
  // PaddZero(SFD.BUSTYPE,1) //20180123
    + PaddR(SFD.FARMPROV, 2) + PaddZero(SFD.ACCMETHOD, 1) +
    PaddZero(SFD.NAICS, 6) + PaddZero(SFD.SIN, 9);
  SFDFxRec := SFDFxRec + PaddR(SFD.BUSNAME, 30) + PaddR(SFD.BUSADDRESS, 30) +
    PaddR(SFD.BUSPOSTAL, 6) + PaddR(SFD.BUSFISCSTART, 8) +
    PaddR(SFD.BUSFISCEND, 8);
  SFDFxRec := SFDFxRec + PaddZero(SFD.BUSPARTNID, 9);
  SFDFxRec := SFDFxRec + PaddZero(SFD.BUSPERCENT, 4) + PaddR(SFD.BUSTAXSHELTNO,
    8) // 20160128 //SFD.BUSTAXSHELTNO //PaddZero(SFD.BUSTAXSHELTNO,8)  //20160121
    + PaddZero(SFD.BUSFINALYR, 1) + PaddR(SFD.BUSNUMBER, 15);

  SFDFxRec := SFDFxRec + PaddR(SFD.InternetPages, 4) + PaddR(SFD.WebAddr1, 96) +
    PaddR(SFD.WebAddr2, 96) + PaddL(SFD.WebPercent, 3); // 20160127

  SFDFxRec := SFDFxRec + PaddR(SFD.PRec[1].PFirstName, 30) +
    PaddR(SFD.PRec[1].PLastName, 30) + PaddZero(SFD.PRec[1].PSin, 8) +
    PaddZero(SFD.PRec[1].PPerCent, 6);
  SFDFxRec := SFDFxRec + PaddR(SFD.PRec[2].PFirstName, 30) +
    PaddR(SFD.PRec[2].PLastName, 30) + PaddZero(SFD.PRec[2].PSin, 8) +
    PaddZero(SFD.PRec[2].PPerCent, 6);
  SFDFxRec := SFDFxRec + PaddR(SFD.PRec[3].PFirstName, 30) +
    PaddR(SFD.PRec[3].PLastName, 30) + PaddZero(SFD.PRec[3].PSin, 8) +
    PaddZero(SFD.PRec[3].PPerCent, 6);

  BarData := '';
  For i := 1 to Length(SFDFxRec) do
    BarData := BarData + MidAnsiStr(SFDFxRec, i, 1);
  For i := 1 to Length(VariableBuffer) do
    BarData := BarData + MidAnsiStr(VariableBuffer, i, 1);

  BarData := BarData + '-EOD';

end;

Procedure AppendT1Rec;
Var
  i: Integer;
  s: string;
Begin

  i := FixedFormatLength + Length(VariableBuffer) + Length('-EOD');
  Fx.RECLEN := PaddZero(IntToStr(i), 4);

  If LeftStr(Fx.RECLEN, 1) = ' ' then
    Fx.RECLEN := '0' + Ltrim(Fx.RECLEN);

  FxRec := PaddZero(Fx.RECLEN, 4) + PaddR(Fx.RECTYPE, 2) + PaddR(Fx.TaxYear, 4)
    + PaddZero(Fx.DISCNUMBER, 8) + PaddR(Fx.SIN, 9);
  FxRec := FxRec + PaddR(Fx.BIRTHYYYY, 4) + PaddR(Fx.BIRTHMM, 2) +
    PaddR(Fx.BIRTHDD, 2) + PaddR(Fx.PRVOFRES, 2) + PaddR(Fx.PRVOFTAX, 2);
  FxRec := FxRec + PaddR(Fx.MARSTATUS, 1) + PaddZero(Fx.SPOUSESIN, 9) +
    PaddR(Fx.SPOUSENAME, 4) + PaddR(Fx.FIRSTNAME, 30) + PaddR(Fx.LASTNAME, 30);

  FxRec := FxRec + PaddR(Fx.CAREOFNAME, 26) + PaddR(Fx.STREET, 60) +
    PaddR(Fx.CITY, 50) + PaddR(Fx.PROVINCE, 2) + PaddR(Fx.POSTAL, 6) +
    PaddR(Fx.EMAIL, 75) // 20141226
    + PaddR(Fx.ProvMoveDate, 8) + PaddR(Fx.HomeAddressChange, 1); // 20121227

  FxRec := FxRec + PaddZero(Fx.CLAREA, 3) + PaddZero(Fx.CLPHONE, 7) +
    PaddR(Fx.LANGUAGE, 1); // 20170115  //+PaddZero(FX.GSTYESNO,1);
  FxRec := FxRec + PaddZero(Fx.SPOUSENETINC, 9) + PaddZero(Fx.SPOUSEUCCB, 9) +
    PaddZero(Fx.SPOUSEUCCBREPAY, 9);
  FxRec := FxRec + PaddZero(Fx.ISDECEASED, 1) + PaddZero(Fx.DATEOFDEATH, 8) +
    PaddZero(Fx.ISPREBANKRUPT, 1) + PaddZero(Fx.POSTBANKRUPTNI, 9) +
    PaddZero(Fx.POSTBANKRUPTADJNI, 9);
  // +PaddZero(FX.DATEOFBANKRUPTCY,8);  //20100110    //20121227
  FxRec := FxRec + PaddZero(Fx.SFDRECS, 2) + PaddR(Fx.DEVELOPER, 3) +
    PaddR(Fx.SOFTCODE, 1) + PaddR(Fx.SoftSerialNumber, 37) // 20141226
    + PaddR(Fx.SOFTRELEASE, 8);
  FxRec := FxRec + PaddZero(Fx.FDEADLINE, 1) + PaddZero(Fx.CANCITIZEN, 1) +
    PaddZero(Fx.ELECTION, 2) // ok so far
    + PaddZero(Fx.Aborigvalue, 1) // for nl,bc,yt,nt
    + PaddZero(Fx.NTLandsTlicho, 1)
  // new for 2013 NT community lands  1-5 //20140124
    + PaddZero(Fx.NTLandsDeline, 1) // 20170116
    + PaddZero(Fx.YTFIRSTNation, 5) // yt
    + PaddZero(Fx.SelfGovFNation, 1) // 20121227  bc and yt  //20170115
  // +PaddZero(Fx.CitizenFN,1)   //20121227  bc and yt
    + PaddR(Fx.PresentPrv, 2) + Fx.IndianExemptIncome // 20200129 jz
    + Fx.ReservedField; // 20200217  //con


  //jz//20260216 //Fx.CarbonRebate removed as per ch8-24e.pdf //jz//20250304 //Fx.CarbonRebate added, ClimateAction and RetroClimateAction removed as per ch8-24e.pdf
  //FxRec := FxRec + Fx.CarbonRebate   //Fx.ClimateAction + Fx.RetroClimateAction
  FxRec := FxRec + Fx.MaritalStatuschangeDate + Fx.ConsentOrganAndTissue;


  {
    FxRec := FxRec  + Fx.RetroClimateAction               //20230125
    + Fx.MaritalStatuschangeDate
    //+ Fx.TsawwassenResidence   //jz 20240209
    //+ Fx.TsawwassenFirstNationIndicator
    + Fx.ConsentOrganAndTissue;
  }

  BarData := '';
  For i := 1 to Length(FxRec) do
    BarData := BarData + MidStr(FxRec, i, 1);

  // 20240211  *** DIAGNOSTC TOOL :  Check the value of any item on the fixed part of the bat data
  // Showmessage(MidStr(Bardata,483,1));  //this tells us what we have on position 483
  // Showmessage(MidStr(Bardata,485,4));  //this tells us what we have on position 485 to 488 - Mar status change
  // *******************************************************************
  if Length(BarData) <> FixedFormatLength then
    Showmessage('Fixed BarData size is incorrect'); // 20240211
  // ShowTimedMsg('Fixed BarData size is incorrect',1200);
  // 20240211  preferable but not accessible in this unit

  For i := 1 to Length(VariableBuffer) do
    BarData := BarData + MidStr(VariableBuffer, i, 1);

  BarData := BarData + '-EOD';

  SaveT1RecToText(BarData); // 20220429

  // Showmessage('Bardata ='+bardata);    //20220427
end;

Procedure Prepare1013Rec(RetNo: Integer; FormName1013: String);

  Function monthDayToJulian(month, Day: Word): Integer;
  var
    MonthDays: Array [1 .. 12] of Integer;
    i, total: Integer;
  begin
    MonthDays[1] := 31;
    MonthDays[2] := 28;
    MonthDays[3] := 31;
    MonthDays[4] := 30;
    MonthDays[5] := 31;
    MonthDays[6] := 30;
    MonthDays[7] := 31;
    MonthDays[8] := 31;
    MonthDays[9] := 30;
    MonthDays[10] := 31;
    MonthDays[11] := 30;
    MonthDays[12] := 31;

    total := 0;
    for i := 1 to month - 1 do
    begin
      total := total + MonthDays[i];
    end;
    total := total + Day;
    Result := total;
  end;

  Function CBXto1(valu: string): string;
  begin
    Result := '';
    if AllTrim(UpperCase(valu)) = 'X' then
      Result := '1';
  end;

Var
  i, j, Rule, LLine, ElmNo: Integer;
  LType: string[1];
  FName: string[12];
  s: string;
  LLineString: String[4];

  Present: TDateTime;
  Year, month, Day, Hour, Min, Sec, MSec: Word;
  jmonthDay: Integer;
Begin
  Present := Now();
  DecodeDate(Present, Year, month, Day);
  DecodeTime(Present, Hour, Min, Sec, MSec);
  jmonthDay := monthDayToJulian(month, Day);
  FX1013.UDN := PaddZero(FetchElm(RetNo, FormName1013, 9), 9) + AppYear +
    PaddZero(IntToStr(jmonthDay), 3) + PaddZero(IntToStr(Hour), 2) +
    PaddZero(IntToStr(Min), 2) + PaddZero(IntToStr(Sec), 2) +
    PaddZero(IntToStr(MSec), 3);

  // showmessage(PaddZero(inttostr(jmonthDay),3));
  // showmessage('Hour ' + IntToStr(Hour) + '  Minute ' + IntToStr(Min) + '  sec:' + IntToStr(Sec) + '   milisec: ' + IntToStr(MSec));
  // showmessage(FX1013.UDN);
  // showmessage(inttostr(Length(FX1013.UDN)));

  // part 1
  FX1013.taxPayerFirstName := UpperCase(FetchElm(RetNo, FormName1013, 3));
  FX1013.taxPayerlastName := UpperCase(FetchElm(RetNo, FormName1013, 4));
  FX1013.SIN := FetchElm(RetNo, FormName1013, 9);
  if Length(FetchElm(RetNo, FormName1013, 12)) > 1 then
    FX1013.SIN := FetchElm(RetNo, FormName1013, 12); // Trust Account

  FX1013.TrustName := FetchElm(RetNo, FormName1013, 41);
  // part 2
  FX1013.repID := UpperCase(FetchElm(RetNo, FormName1013, 27));

  FX1013.groupID := UpperCase(FetchElm(RetNo, FormName1013, 8));
  If AllTrim(FX1013.groupID) = 'G' then
    FX1013.groupID := ''; // 20180201

  FX1013.BN := UpperCase(FetchElm(RetNo, FormName1013, 28));
  FX1013.authLevel := UpperCase(FetchElm(RetNo, FormName1013, 32));
  FX1013.repFirstNameAssociated := UpperCase(FetchElm(RetNo, FormName1013, 34));
  FX1013.repLastNameAssociated := UpperCase(FetchElm(RetNo, FormName1013, 35));
  FX1013.BNNameAssociated := UpperCase(FetchElm(RetNo, FormName1013, 38));
  // part 3
  FX1013.repFirstName := UpperCase(FetchElm(RetNo, FormName1013, 15));
  FX1013.repLastName := UpperCase(FetchElm(RetNo, FormName1013, 22));
  FX1013.repBusinessName := UpperCase(FetchElm(RetNo, FormName1013, 17));
  FX1013.repTelephoneNumber := FetchElm(RetNo, FormName1013, 18) +
    StringReplace(FetchElm(RetNo, FormName1013, 19), '-', '',
    [rfReplaceAll, rfIgnoreCase]);
  FX1013.repExt := FetchElm(RetNo, FormName1013, 23);
  FX1013.repFax := FetchElm(RetNo, FormName1013, 24) +
    StringReplace(FetchElm(RetNo, FormName1013, 25), '-', '',
    [rfReplaceAll, rfIgnoreCase]);
  FX1013.allTaxYearsCB := CBXto1(FetchElm(RetNo, FormName1013, 101));
  FX1013.authLevelAllYears := UpperCase(FetchElm(RetNo, FormName1013, 103));
  FX1013.specificTaxYearsCB := CBXto1(FetchElm(RetNo, FormName1013, 132));

  // tables
  j := 0;
  for i := 1 to 10 do
  begin
    FX1013.specificTaxYears[i] :=
      UpperCase(FetchElm(RetNo, FormName1013, 105 + j));
    FX1013.specificauthLevel[i] :=
      UpperCase(FetchElm(RetNo, FormName1013, 106 + j));
    inc(j, 2);
  end;
  // part 4
  FX1013.expiryDate := ReplaceChar(FetchElm(RetNo, FormName1013, 129), '-', '');
  // part 5
  FX1013.cancelAllCB := CBXto1(FetchElm(RetNo, FormName1013, 14));
  FX1013.cancelSpecificCB := CBXto1(FetchElm(RetNo, FormName1013, 16));
  FX1013.repFirstNameCancel := UpperCase(FetchElm(RetNo, FormName1013, 1));
  FX1013.repLastNameCancel := UpperCase(FetchElm(RetNo, FormName1013, 31));
  FX1013.repBusinessCancel := UpperCase(FetchElm(RetNo, FormName1013, 2));
  FX1013.repIDCancel := UpperCase(FetchElm(RetNo, FormName1013, 6));

  FX1013.groupIDCancel := UpperCase(FetchElm(RetNo, FormName1013, 10));
  If AllTrim(FX1013.groupIDCancel) = 'G' then
    FX1013.groupIDCancel := ''; // 20180201

  FX1013.BNCancel := UpperCase(FetchElm(RetNo, FormName1013, 7));
  // Part 6
  FX1013.PrintName := UpperCase(FetchElm(RetNo, FormName1013, 133));
  FX1013.LegalSignitureCB := CBXto1(FetchElm(RetNo, FormName1013, 33));
  if FX1013.LegalSignitureCB = '' then
    FX1013.LegalSignitureCB := '0';

  FX1013.SignitureDate := ReplaceChar(FetchElm(RetNo, FormName1013,
    131), '-', '');
  FX1013.VendorCertCode := '064F';
  //for release date see Declare
End;

Procedure Append1013Rec;

  Function writeValu(valuCode, valu, delim: string): string;
  begin
    Result := '';
    if AllTrim(valu) > '' then
      Result := valuCode + valu + delim;
  end;

var
  i: Integer;
  BarDataList: TStringList;
  s, delim, valu: String;

begin
  delim := '*';
  FX1013Rec := '';
  FX1013Rec := '1013+1*';
  FX1013Rec := FX1013Rec + '800' + FX1013.UDN + delim;

  // part 1  //20180205  modify for trust
  If AllTrim(FX1013.taxPayerFirstName) > '' then
    FX1013Rec := FX1013Rec + '801' + FX1013.taxPayerFirstName + delim;
  If AllTrim(FX1013.taxPayerlastName) > '' then
    FX1013Rec := FX1013Rec + '802' + FX1013.taxPayerlastName + delim;
  If AllTrim(FX1013.SIN) > '' then
    FX1013Rec := FX1013Rec + '803' + FX1013.SIN + delim;
  // it could be sin or trust account as per 1013preparerec

  If AllTrim(FX1013.TrustName) > '' then
    FX1013Rec := FX1013Rec + '804' + LeftStr(FX1013.TrustName, 60) + delim;
  // it could be sin or trust account as per 1013preparerec

  (*
    //part 1
    FX1013Rec:= FX1013Rec +   '801'+FX1013.taxPayerFirstName+delim +
    '802'+FX1013.taxPayerlastName+delim +
    '803'+FX1013.SIN+delim;
  *)
  // part 2
  FX1013Rec := FX1013Rec + writeValu('810', FX1013.repID, delim) +
    writeValu('811', FX1013.groupID, delim) + writeValu('812', FX1013.BN, delim)
    + writeValu('813', FX1013.authLevel, delim) +
    writeValu('814', FX1013.repFirstNameAssociated, delim) +
    writeValu('815', FX1013.repLastNameAssociated, delim) +
    writeValu('816', FX1013.BNNameAssociated, delim);

  // part 3
  FX1013Rec := FX1013Rec + writeValu('820', FX1013.repFirstName, delim) +
    writeValu('821', FX1013.repLastName, delim) +
    writeValu('822', FX1013.repBusinessName, delim);
  FX1013Rec := FX1013Rec + writeValu('823', FX1013.repTelephoneNumber, delim) +
    writeValu('824', FX1013.repExt, delim) + writeValu('825', FX1013.repFax,
    delim) + writeValu('826', FX1013.allTaxYearsCB, delim);
  FX1013Rec := FX1013Rec + writeValu('827', FX1013.authLevelAllYears, delim) +
    writeValu('828', FX1013.specificTaxYearsCB, delim);

  for i := 1 to 10 do
    FX1013Rec := FX1013Rec + writeValu('829', FX1013.specificTaxYears[i],
      '+' + IntToStr(i) + delim);
  for i := 1 to 10 do
    FX1013Rec := FX1013Rec + writeValu('830', FX1013.specificauthLevel[i],
      '+' + IntToStr(i) + delim);

  // part 4
  FX1013Rec := FX1013Rec + writeValu('836', FX1013.expiryDate, delim);
  // part 5
  FX1013Rec := FX1013Rec + writeValu('841', FX1013.cancelAllCB, delim) +
    writeValu('842', FX1013.cancelSpecificCB, delim);
  FX1013Rec := FX1013Rec + writeValu('843', FX1013.repFirstNameCancel, delim) +
    writeValu('844', FX1013.repLastNameCancel, delim) +
    writeValu('845', FX1013.repBusinessCancel, delim);
  FX1013Rec := FX1013Rec + writeValu('846', FX1013.repIDCancel, delim) +
    writeValu('847', FX1013.groupIDCancel, delim) +
    writeValu('848', FX1013.BNCancel, delim);
  // part 6
  FX1013Rec := FX1013Rec + writeValu('854', FX1013.PrintName, delim) +
    writeValu('855', FX1013.LegalSignitureCB, delim) +
    writeValu('856', FX1013.SignitureDate, delim) +
    writeValu('862', FX1013.VendorCertCode, delim);

  BarData := '';
  For i := 1 to Length(FX1013Rec) do
    BarData := BarData + MidStr(FX1013Rec, i, 1);

  BarData := BarData + 'EOD';
  // showmessage(BarData);
end;

// 20200102
Function GetAmount(RetNo: Integer; LLine: Integer; LType: string; FName: string;
  ElmNo: Integer; Rule: Integer): String;
Var
  LAmount: real;
  LSAmount: String;
  FNo: Integer;
begin
  case Rule of
    0:
      begin
        FName := Ltrim(RTrim(FName));
        If LType = 'N' then
        begin
          If FName = '' then
          begin
            Result := FloatToStr(Ret[RetNo].Lnn[LLine])
            // 20200102 LLine insted of ElmNo
          end
          else
            Result := Ltrim(RTrim(FetchElm(RetNo, FName, ElmNo)));

          If Vl(Result) = 0 then
            Result := '';

          If Vl(Result) < 0 then
            Result := '&' + MidStr(Result, 2, 30);
          exit;
        end;

        IF FName = '' THEN
          LAmount := Ret[RetNo].Lnn[LLine] // instead of ElmNo
        ELSE
        begin
          LAmount := Vl(FetchElm(RetNo, FName, ElmNo));
        end;
      end;
  else
    LAmount := DoRules(RetNo, Rule); { RETURNS LAMOUNT }
  end;

  If (LLine > 0) then
    if IsEFOverride(RetNo, LLine) then
      LAmount := GetEFOverride(RetNo, LLine);

  If (LAmount = 0) and (FName = '') and (ElmNo = 26000) then
  // 26000 onstead of 260
  begin
    Result := '0';
    exit;
  end;
  IF LAmount = 0 THEN
  begin
    Result := '';
    exit;
  end;

  { Convert LAMOUNT to String }
  IF (LType = '$') THEN
  begin
    Result := IntToStr(Round(LAmount)); { CENTS }
  end;
  IF (LType = 'N') then
    Result := IntToStr(Round(LAmount));

  IF LType = 'C' THEN
  begin
    Result := IntToStr(Round(LAmount * 100)); { CENTS }
  end;

  Result := AllTrim(Result);
  If LAmount < 0 then
    Result := '&' + MidStr(Result, 2, 30);
end;

(*
  Function GetAmount(RetNo: Integer; LLine: Integer; LType: string; FName: string;
  ElmNo: Integer; Rule: Integer): String;
  Var
  LAmount: real;
  LSAmount: String;
  FNo: Integer;
  begin
  case Rule of
  0:
  begin
  FName := Ltrim(RTrim(FName));
  If LType = 'N' then
  begin
  If FName = '' then
  begin
  result := FloatToStr(Ret[RetNo].Lnn[ElmNo])
  end
  else
  result := Ltrim(RTrim(FetchElm(RetNo, FName, ElmNo)));

  If Vl(result) = 0 then
  result := '';

  If Vl(result) < 0 then
  result := '&' + MidStr(result, 2, 30);
  exit;
  end;

  IF FName = '' THEN
  LAmount := Ret[RetNo].Lnn[ElmNo]
  ELSE
  begin
  LAmount := Vl(FetchElm(RetNo, FName, ElmNo));
  end;
  end;
  else
  LAmount := DoRules(RetNo, Rule); { RETURNS LAMOUNT }
  end;

  If (LLine > 0) then
  if IsEFOverride(RetNo, LLine) then
  LAmount := GetEFOverride(RetNo, LLine);

  If (LAmount = 0) and (FName = '') and (ElmNo = 260) then
  begin
  result := '0';
  exit;
  end;
  IF LAmount = 0 THEN
  begin
  result := '';
  exit;
  end;

  { Convert LAMOUNT to String }
  IF (LType = '$') THEN
  begin
  result := IntToStr(Round(LAmount)); { CENTS }
  end;
  IF (LType = 'N') then
  result := IntToStr(Round(LAmount));

  IF LType = 'C' THEN
  begin
  result := IntToStr(Round(LAmount * 100)); { CENTS }
  end;

  result := AllTrim(result);
  If LAmount < 0 then
  result := '&' + MidStr(result, 2, 30);
  end;
*)
Procedure RemoveLastDashFromBuffers;
begin
  If RightStr(VariableBuffer, 1) = '-' THEN
    VariableBuffer := LeftStr(VariableBuffer, Length(VariableBuffer) - 1);
end;

Procedure AddStringToBuffers(LLine: Integer; s: String);
begin
  VariableBuffer := VariableBuffer + IntToStr(LLine) + s + '-';
end;

Function FormatFourDigitPercent(s: string): String;
Var
  s1: String[10];
  x: real;
begin
  If Vl(s) >= 100 then
  begin
    Result := '0000';
    exit;
  end;
  x := 100 * Vl(s);
  s1 := FloatToStr(x);
  Result := AllTrim(PaddZero(ExtractIntegerPart(s1), 4));
end;

Function GetNetFileAmount(RetNo: Integer; LLine: Integer; LType: string;
  FName: string; ElmNo: Integer; Rule: Integer): String;
Var
  LAmount: real;
  LSAmount: String;
  FNo: Integer;
begin
  // if lline=41800 then Showmessage('41800');  //20230125

  If RetNo < 1 then
  begin
    Showmessage('LLNINE ' + IntToStr(LLine) + ' is not accessible');
    exit;
  End; // 20111227

  case Rule of
    0:
      begin
        FName := Ltrim(RTrim(FName));
        If LType = 'N' then
        begin
          If FName = '' then
          begin
            Result := FloatToStr(Ret[RetNo].Lnn[LLine]); // 20191127
            // result := FloatToStr(Ret[RetNo].Lnn[ElmNo])
          end
          else
            Result := Ltrim(RTrim(FetchElm(RetNo, FName, ElmNo)));

          If Vl(Result) = 0 then
            Result := '';
          exit;
        end;

        IF FName = '' THEN
          LAmount := Ret[RetNo].Lnn[LLine]
          /// /20191127
        ELSE
        begin
          LAmount := Vl(FetchElm(RetNo, FName, ElmNo));
        end;
      end;
  else
    LAmount := DoRules(RetNo, Rule); { RETURNS LAMOUNT }
  end;

  If (LLine > 0) then
    if IsEFOverride(RetNo, LLine) then
    Begin
      LAmount := GetEFOverride(RetNo, LLine);
    End;

  If (LAmount = 0) and (FName = '') and (ElmNo = 260) then
  begin
    Result := '0';
    exit;
  end;
  IF LAmount = 0 THEN
  begin
    Result := '';
    exit;
  end;

  { Convert LAMOUNT to String }
  IF (LType = '$') THEN
  begin
    Result := IntToStr(Round(LAmount)); { CENTS }
  end;
  IF (LType = 'N') then
    Result := AllTrim(IntToStr(Round(LAmount)));

  IF LType = 'C' THEN // means cents
  begin
    Result := AllTrim(IntToStr(Round(LAmount * 100))); { CENTS }
  end;

  Result := AllTrim(Result);

end;

// 20171220
Function GetStreet(RetNo: Integer): String;
// var InfoFNo: Integer;
Begin
  // 20180116
  // InfoFNo := GetFormNo('INFO');
  Result := '';
  If FetchElmFNo(RetNo, InfoFno, 163) > '' then
    Result := FetchElmFNo(RetNo, InfoFno, 163) + ' '; // rr
  If FetchElmFNo(RetNo, InfoFno, 68) > '' then
    Result := Result + FetchElmFNo(RetNo, InfoFno, 68) + ' '; // po box
  If FetchElmFNo(RetNo, InfoFno, 22) > '' then
    Result := Result + FetchElmFNo(RetNo, InfoFno, 22) + ' '; // aptm
  Result := Result + FetchElmFNo(RetNo, InfoFno, 6); // str;
  {
    Function GetStreet(RetNo:Integer):String;
    Begin
    Result := FetchElm(RetNo,'T1',6);
    If FetchElm(RetNo,'T1',22)>'' then  result:=Result+' '+FetchElm(RetNo,'T1',22); //apartm
    If FetchElm(RetNo,'T1',68)>'' then result:=result+' '+FetchElm(RetNo,'T1',68);  //PO Box
    If FetchElm(RetNo,'T1',163)>'' then result:=result+' '+FetchElm(RetNo,'T1',163);  //RR
  }
end;

Procedure PrepareSFDRec(RetNo: Integer; SFDFormName: String);
Var
  i: Integer;
  FInst: String;
Begin
  FInst := ExtractFormInst(SFDFormName);
  If SFDFormName = 'T776' + FInst then
  begin
    PrepareRental(RetNo, FInst);
  end
  Else If SFDFormName = 'T2125' + FInst then
  begin
    PrepareBusiness(RetNo, FInst);
  end
  Else If SFDFormName = 'T2121' + FInst then
  begin
    PrepareFishing(RetNo, FInst);
  end
  Else If SFDFormName = 'T2042' + FInst then
  begin
    PrepareFarming(RetNo, FInst);
  end
  Else If (SFDFormName = 'T777' + FInst) then // and (Frec.FormInst>'')  then
  begin
    PrepareT777(RetNo, FInst);
  end

  { //20240120
    Else If (SFDFormName = 'T777S' + FInst) then //20210220
    begin
    PrepareT777S(RetNo, FInst);
    end
  }

  Else If (SFDFormName = 'TL2' + FInst) then
  begin
    PrepareTL2(RetNo, FInst);
  end
  Else If (SFDFormName = 'T2091' + FInst) then // jz T2091 20180123
  begin
    PrepareT2091(RetNo, FInst);
  end
end;

Procedure PrepareRental(RetNo: Integer; FInst: String);
Var
  i, LLine, ElmNo, Rule: Integer;
  LType: string[1];
  FName: string[12];
  s: string;
begin
  VariableBuffer := '';
  SFD.RECTYPE := '03';
  SfdRecNumber := SfdRecNumber + 1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber), 2);
  SFD.BUSTYPE := '1';
  SFD.NAICS := FetchElm(RetNo, 'T776' + FInst, 19);
  SFD.BUSNAME := FetchElm(RetNo, 'T776' + FInst, 109);
  SFD.SIN := RemoveHyphens(FetchElm(RetNo, 'T1', 3));
  If AllTrim(SFD.BUSNAME) = '' then
    SFD.BUSNAME := GetFirstName(RetNo) + ' ' + GetLastName(RetNo);
  SFD.BUSADDRESS := FetchElm(RetNo, 'T776' + FInst, 110) + ' ' +
    FetchElm(RetNo, 'T776' + FInst, 112);
  SFD.BUSPOSTAL := Mtrim(FetchElm(RetNo, 'T776' + FInst, 111));
  SFD.BUSFISCSTART := RemoveHyphens(FetchElm(RetNo, 'T776' + FInst, 3));
  SFD.BUSFISCEND := RemoveHyphens(FetchElm(RetNo, 'T776' + FInst, 6));
  // SFD.AcrOwned :='';      //20110114
  // SFD.AcrFarmed:='';      //20110114

  SFD.ACCMETHOD := '0'; // 20180131
  {
    If AllTrim(FetchElm(RetNo,'T776'+FInst,4))>'' THEN
    SFD.AccMethod:='1'
    ELSE
    SFD.AccMethod:='2';
  }

  SFD.BUSPARTNID := FetchElm(RetNo, 'T776' + FInst, 11);
  SFD.BUSPERCENT := FormatFourDigitPercent(FetchElm(RetNo, 'T776' + FInst, 18));
  SFD.BUSTAXSHELTNO := FetchElm(RetNo, 'T776' + FInst, 13);
  If AllTrim(FetchElm(RetNo, 'T776' + FInst, 9)) > '' THEN
    SFD.BUSFINALYR := '1'
  ELSE
    SFD.BUSFINALYR := '2';

  SFD.BUSNUMBER := FetchElm(RetNo, 'T776' + FInst, 15); // 20180131
  {
    +FetchElm(RetNo,'T776'+FInst,16)
    +FetchElm(RetNo,'T776'+FInst,17);
  }
  // prec is blank
  clearPRecArray;

  i := 0;
  If Vl(FetchElm(RetNo, 'T776' + FInst, 24)) > 0 then
  begin
    inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T776' + FInst, 22), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T776' + FInst, 117), 30);
    // SFD.Prec[i].PSin       := PaddZero(FetchElm(RetNo,'T776'+FInst,118),8);  //20180201
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T776' + FInst, 24));
  end;
  If Vl(FetchElm(RetNo, 'T776' + FInst, 28)) > 0 then
  begin
    inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T776' + FInst, 25), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T776' + FInst, 26), 30);
    // SFD.Prec[i].PSin       := PaddZero(FetchElm(RetNo,'T776'+FInst,120),8);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T776' + FInst, 28));
  end;
  If Vl(FetchElm(RetNo, 'T776' + FInst, 32)) > 0 then
  begin
    inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T776' + FInst, 29), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T776' + FInst, 30), 30);
    // SFD.Prec[i].PSin       := PaddZero(FetchElm(RetNo,'T776'+FInst,122),8);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T776' + FInst, 32));
  end;
  If Vl(FetchElm(RetNo, 'T776' + FInst, 36)) > 0 then
  begin
    inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T776' + FInst, 33), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T776' + FInst, 34), 30);
    // SFD.Prec[i].PSin       := PaddZero(FetchElm(RetNo,'T776'+FInst,124),8);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T776' + FInst, 36));
  end;
  If Vl(FetchElm(RetNo, 'T776' + FInst, 40)) > 0 then
  begin
    inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T776' + FInst, 37), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T776' + FInst, 38), 30);
    // SFD.Prec[i].PSin       := PaddZero(FetchElm(RetNo,'T776'+FInst,126),8);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T776' + FInst, 40));
  end;
  If Vl(FetchElm(RetNo, 'T776' + FInst, 44)) > 0 then
  begin
    inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T776' + FInst, 41), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T776' + FInst, 42), 30);
    // SFD.Prec[i].PSin       := PaddZero(FetchElm(RetNo,'T776'+FInst,128),8);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T776' + FInst, 44));
  end;

  EFlines := TStringList.Create;
  EFlines.LoadFromFile(AppDir + '\' + 'EFRLINE.D');

  For i := 1 to 5 do
  begin
  end;

  { Free format SFD }
  // BuildDtlFGS740(RetNo);
  { 12345678901234567890123
    {Format nnnn $ fffffffff elm rrr }
  For i := 0 to EFlines.Count - 1 do
  begin
    LLine := MyStrToInt(LeftStr(EFlines[i], 5)); // 20190709 Igor
    LType := MidStr(EFlines[i], 6, 1);
    FName := AllTrim(MidStr(EFlines[i], 8, 9)) + FInst;
    ElmNo := MyStrToInt(MidStr(EFlines[i], 17, 3));
    If MidStr(EFlines[i], 22, 3) = '' then
      Rule := 0
    else
      Rule := MyStrToInt(MidStr(EFlines[i], 22, 3));

    s := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
    If LLine = 9946 then
    begin
      If (s = '') and (Vl(FetchElm(RetNo, 'T776' + FInst, 56)) <> 0) then
        s := '1';
    end;
    If s > '' then
    begin
      s := ReplaceChar(s, '-', '&');
      AddStringToBuffers(LLine, s);
      // BuildDtlTIA820(RetNo,AllTrim(IntToStr(LLine)),s);
    end;
  end;
  RemoveLastDashFromBuffers;
  EFlines.Free;
end;

Procedure PrepareBusiness(RetNo: Integer; FInst: String);
Var
  i, LLine, ElmNo, Rule: Integer;
  LType: string[1];
  FName: string[12];
  s: string;
begin
  VariableBuffer := '';
  SFD.RECTYPE := '03';
  SfdRecNumber := SfdRecNumber + 1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber), 2);
  If FetchElm(RetNo, 'T2125' + FInst, 82) > '' then
    SFD.BUSTYPE := '2'
  else If FetchElm(RetNo, 'T2125' + FInst, 90) > '' then
    SFD.BUSTYPE := '3';

  SFD.NAICS := FetchElm(RetNo, 'T2125' + FInst, 12);
  SFD.SIN := RemoveHyphens(FetchElm(RetNo, 'T1', 3));

  SFD.BUSNAME := FetchElm(RetNo, 'T2125' + FInst, 8);
  If AllTrim(SFD.BUSNAME) = '' then
    SFD.BUSNAME := GetFirstName(RetNo) + ' ' + GetLastName(RetNo);

  SFD.BUSADDRESS := FetchElm(RetNo, 'T2125' + FInst, 10) + ' ' +
    FetchElm(RetNo, 'T2125' + FInst, 13);
  SFD.BUSPOSTAL := Mtrim(FetchElm(RetNo, 'T2125' + FInst, 14));
  SFD.BUSFISCSTART := RemoveHyphens(FetchElm(RetNo, 'T2125' + FInst, 4));
  SFD.BUSFISCEND := RemoveHyphens(FetchElm(RetNo, 'T2125' + FInst, 5));

  // SFD.ACCMETHOD := '0'; // 20170204
  // 20190201
  SFD.ACCMETHOD := '1'; // accrual be default
  If AllTrim(FetchElm(RetNo, 'T2125' + FInst, 22)) > '' THEN
    SFD.ACCMETHOD := '2';
  {
    If AllTrim(FetchElm(RetNo,'T2125'+FInst,11))>'' THEN
    SFD.AccMethod:='1'
    ELSE
    SFD.AccMethod:='2';
  }
  SFD.BUSPARTNID := FetchElm(RetNo, 'T2125' + FInst, 15);
  SFD.BUSPERCENT := FormatFourDigitPercent
    (FetchElm(RetNo, 'T2125' + FInst, 18));
  SFD.BUSTAXSHELTNO := FetchElm(RetNo, 'T2125' + FInst, 16);

  If AllTrim(FetchElm(RetNo, 'T2125' + FInst, 6)) > '' THEN
    SFD.BUSFINALYR := '1'
  ELSE
    SFD.BUSFINALYR := '2';

  SFD.BUSNUMBER := FetchElm(RetNo, 'T2125' + FInst, 19) +
    FetchElm(RetNo, 'T2125' + FInst, 20) + FetchElm(RetNo, 'T2125' + FInst, 21);

  // 20140124
  SFD.InternetPages := FetchElm(RetNo, 'T2125' + FInst, 49);
  If Vl(SFD.InternetPages) = 0 then
    SFD.InternetPages := '0'; // 20170204
  SFD.WebAddr1 := FetchElm(RetNo, 'T2125' + FInst, 25);
  SFD.WebAddr2 := FetchElm(RetNo, 'T2125' + FInst, 27);
  SFD.WebPercent := PaddL(FetchElm(RetNo, 'T2125' + FInst, 51), 3); // 20160127
  If Vl(SFD.WebPercent) = 0 then
    SFD.WebPercent := Space(3); // 20160121

  // Prec is blank
  clearPRecArray;

  i := 0;
  If Vl(FetchElm(RetNo, 'T2125' + FInst, 238)) > 0 then
  begin
    inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2125' + FInst, 257), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2125' + FInst, 239), 30);
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T2125' + FInst, 242), 8);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2125' + FInst, 238));
  end;
  If Vl(FetchElm(RetNo, 'T2125' + FInst, 241)) > 0 then
  begin
    inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2125' + FInst, 258), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2125' + FInst, 248), 30);
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T2125' + FInst, 262), 8);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2125' + FInst, 241));
  end;
  If Vl(FetchElm(RetNo, 'T2125' + FInst, 244)) > 0 then
  begin
    inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2125' + FInst, 259), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2125' + FInst, 264), 30);
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T2125' + FInst, 265), 8);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2125' + FInst, 244));
  end;
  If Vl(FetchElm(RetNo, 'T2125' + FInst, 247)) > 0 then
  begin
    inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2125' + FInst, 260), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2125' + FInst, 267), 30);
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T2125' + FInst, 268), 8);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2125' + FInst, 247));
  end;
  If Vl(FetchElm(RetNo, 'T2125' + FInst, 250)) > 0 then
  begin
    inc(i);
    // 20090211  was T2123
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2125' + FInst, 261), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2125' + FInst, 270), 30);
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T2125' + FInst, 271), 8);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2125' + FInst, 250));
  end;

  EFlines := TStringList.Create;
  EFlines.LoadFromFile(AppDir + '\' + 'EFBLINE.D');

  For i := 1 to 5 do
  begin
  end;
  // free format SFD
  // BuildDtlFGS740(RetNo);
  { 12345678901234567890123
    {Format nnnn $ fffffffff elm rrr }
  For i := 0 to EFlines.Count - 1 do
  begin
    LLine := MyStrToInt(LeftStr(EFlines[i], 4));
    LType := MidStr(EFlines[i], 6, 1);
    FName := AllTrim(MidStr(EFlines[i], 8, 9)) + FInst;
    ElmNo := MyStrToInt(MidStr(EFlines[i], 17, 3));
    If MidStr(EFlines[i], 22, 3) = '' then
      Rule := 0
    else
      Rule := MyStrToInt(MidStr(EFlines[i], 22, 3));

    s := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
    If LLine = 9946 then
    begin
      If (s = '') and (Vl(FetchElm(RetNo, 'T2125' + FInst, 32)) <> 0) then
        s := '1';
    end;
    If s > '' then
    begin
      s := ReplaceChar(s, '-', '&');
      AddStringToBuffers(LLine, s);
    end;
  end;
  RemoveLastDashFromBuffers;
  EFlines.Free;
end;

Procedure PrepareFishing(RetNo: Integer; FInst: String);
Var
  i, LLine, ElmNo, Rule: Integer;
  LType: string[1];
  FName: string[12];
  s: string;
begin
  VariableBuffer := '';
  SFD.RECTYPE := '03';
  SfdRecNumber := SfdRecNumber + 1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber), 2);
  SFD.BUSTYPE := '4';
  SFD.NAICS := FetchElm(RetNo, 'T2121' + FInst, 11);
  SFD.SIN := RemoveHyphens(FetchElm(RetNo, 'T1', 3));

  SFD.BUSNAME := FetchElm(RetNo, 'T2121' + FInst, 8); // 20110118
  // SFD.BUSNAME:=FetchElm(RetNo,'T2121'+FInst,61);
  If AllTrim(SFD.BUSNAME) = '' then
    SFD.BUSNAME := GetFirstName(RetNo) + ' ' + GetLastName(RetNo);

  // 20130124
  SFD.BUSADDRESS := FetchElm(RetNo, 'T2121' + FInst, 61);
  SFD.BUSPOSTAL := Mtrim(FetchElm(RetNo, 'T2121' + FInst, 75));

  (*
    SFD.BUSADDRESS:=FetchElm(RetNo,'T2121'+FInst,75)+
    ' '+FetchElm(RetNo,'T2121'+FInst,77);
    SFD.BUSPOSTAL:=MTrim(FetchElm(RetNo,'T2121'+FInst,78));
  *)
  SFD.BUSFISCSTART := RemoveHyphens(FetchElm(RetNo, 'T2121' + FInst, 4));
  SFD.BUSFISCEND := RemoveHyphens(FetchElm(RetNo, 'T2121' + FInst, 5));
  // SFD.AcrOwned :=PaddZero('',9);
  // SFD.AcrFarmed:=PaddZero('',9);

  If AllTrim(FetchElm(RetNo, 'T2121' + FInst, 19)) > '' THEN
    SFD.ACCMETHOD := '1'
  ELSE
    SFD.ACCMETHOD := '2';

  SFD.BUSPARTNID := PaddZero(FetchElm(RetNo, 'T2121' + FInst, 12), 9);
  SFD.BUSPERCENT := FormatFourDigitPercent
    (FetchElm(RetNo, 'T2121' + FInst, 18));
  SFD.BUSTAXSHELTNO := FetchElm(RetNo, 'T2121' + FInst, 14);
  // 20170215 //PaddZero(FetchElm(RetNo,'T2121'+FInst,14),8);
  If AllTrim(FetchElm(RetNo, 'T2121' + FInst, 6)) > '' THEN
    SFD.BUSFINALYR := '1'
  ELSE
    SFD.BUSFINALYR := '2';

  SFD.BUSNUMBER := FetchElm(RetNo, 'T2121' + FInst, 15); // 20130124
  // 20140124
  // 20170116 was t2125
  SFD.InternetPages := FetchElm(RetNo, 'T2121' + FInst, 86);
  If Vl(SFD.InternetPages) = 0 then
    SFD.InternetPages := '0'; // 20170204
  SFD.WebAddr1 := FetchElm(RetNo, 'T2121' + FInst, 82);
  SFD.WebAddr2 := FetchElm(RetNo, 'T2121' + FInst, 83);
  SFD.WebPercent := PaddL(FetchElm(RetNo, 'T2121' + FInst, 88), 3); // 20160127
  If Vl(SFD.WebPercent) = 0 then
    SFD.WebPercent := Space(3); // 20160121

  clearPRecArray;

  i := 0;
  If Vl(FetchElm(RetNo, 'T2121' + FInst, 505)) > 0 then
  begin
    inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2121' + FInst, 503), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2121' + FInst, 537), 30);
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T2121' + FInst, 538), 8);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2121' + FInst, 505));
  end;
  If Vl(FetchElm(RetNo, 'T2121' + FInst, 509)) > 0 then
  begin
    inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2121' + FInst, 507), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2121' + FInst, 539), 30);
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T2121' + FInst, 540), 8);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2121' + FInst, 509));
  end;
  If Vl(FetchElm(RetNo, 'T2121' + FInst, 513)) > 0 then
  begin
    inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2121' + FInst, 511), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2121' + FInst, 541), 30);
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T2121' + FInst, 542), 8);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2121' + FInst, 513));
  end;
  if Vl(FetchElm(RetNo, 'T2121' + FInst, 517)) > 0 then { ? }
  begin
    inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2121' + FInst, 515), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2121' + FInst, 543), 30);
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T2121' + FInst, 544), 8);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2121' + FInst, 517));
  end;

  If Vl(FetchElm(RetNo, 'T2121' + FInst, 521)) > 0 then
  begin
    inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2121' + FInst, 519), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2121' + FInst, 545), 30);
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T2121' + FInst, 546), 8);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2121' + FInst, 521));
  end;

  { FREE FORMAT PART }
  EFlines := TStringList.Create;
  EFlines.LoadFromFile(AppDir + '\' + 'EFILINE.D');
  For i := 0 to EFlines.Count - 1 do
  begin
    LLine := MyStrToInt(LeftStr(EFlines[i], 4));
    LType := MidStr(EFlines[i], 6, 1);
    FName := AllTrim(MidStr(EFlines[i], 8, 9)) + FInst;
    ElmNo := MyStrToInt(MidStr(EFlines[i], 17, 3));
    If MidStr(EFlines[i], 22, 3) = '' then
      Rule := 0
    else
      Rule := MyStrToInt(MidStr(EFlines[i], 22, 3));

    s := GetAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
    If LLine = 9946 then
    begin
      If (s = '') and (Vl(FetchElm(RetNo, 'T2121' + FInst, 35)) <> 0) then
        s := '1';
    end;

    If s > '' then
    begin
      s := ReplaceChar(s, '-', '&');
      AddStringToBuffers(LLine, s);
      // RtuContents.Add(IntToStr(LLine)+'='+s);
    end;
  end;
  RemoveLastDashFromBuffers;
  EFlines.Free;
End;

Procedure PrepareFarming(RetNo: Integer; FInst: String);
Var
  i, LLine, ElmNo, Rule: Integer;
  LType: string[1];
  FName: string[12];
  s: string;
begin
  VariableBuffer := '';
  SFD.RECTYPE := '03';
  SfdRecNumber := SfdRecNumber + 1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber), 2);
  SFD.BUSTYPE := '5';
  SFD.FARMPROV := '  '; // ????
  SFD.BUSNAME := FetchElm(RetNo, 'T2042' + FInst, 8);
  SFD.NAICS := FetchElm(RetNo, 'T2042' + FInst, 17);
  SFD.SIN := RemoveHyphens(FetchElm(RetNo, 'T1', 3));

  If AllTrim(SFD.BUSNAME) = '' then
    SFD.BUSNAME := GetFirstName(RetNo) + ' ' + GetLastName(RetNo);
  SFD.BUSADDRESS := FetchElm(RetNo, 'T2042' + FInst, 10) + ' ' +
    FetchElm(RetNo, 'T2042' + FInst, 12);
  SFD.BUSPOSTAL := Mtrim(FetchElm(RetNo, 'T2042' + FInst, 13));
  SFD.BUSFISCSTART := RemoveHyphens(FetchElm(RetNo, 'T2042' + FInst, 4));
  SFD.BUSFISCEND := RemoveHyphens(FetchElm(RetNo, 'T2042' + FInst, 5));
  // SFD.AcrOwned :=FetchElm(RetNo,'T2042'+FInst,9);
  // SFD.AcrFarmed:=FetchElm(RetNo,'T2042'+FInst,11);

  If AllTrim(FetchElm(RetNo, 'T2042' + FInst, 15)) > '' THEN
    SFD.ACCMETHOD := '1'
  ELSE
    SFD.ACCMETHOD := '2';

  SFD.BUSPARTNID := FetchElm(RetNo, 'T2042' + FInst, 18);
  SFD.BUSPERCENT := FormatFourDigitPercent
    (FetchElm(RetNo, 'T2042' + FInst, 24));
  SFD.BUSTAXSHELTNO := FetchElm(RetNo, 'T2042' + FInst, 20);
  If AllTrim(FetchElm(RetNo, 'T2042' + FInst, 6)) > '' THEN
    SFD.BUSFINALYR := '1'
  ELSE
    SFD.BUSFINALYR := '2';

  SFD.BUSNUMBER := FetchElm(RetNo, 'T2042' + FInst, 21) +
    FetchElm(RetNo, 'T2042' + FInst, 22) + FetchElm(RetNo, 'T2042' + FInst, 23);

  // 20140124
  // 20160127
  SFD.InternetPages := FetchElm(RetNo, 'T2042' + FInst, 63);
  If Vl(SFD.InternetPages) = 0 then
    SFD.InternetPages := '0'; // 20170204

  SFD.WebAddr1 := FetchElm(RetNo, 'T2042' + FInst, 25);
  SFD.WebAddr2 := FetchElm(RetNo, 'T2042' + FInst, 11);
  SFD.WebPercent := PaddL(FetchElm(RetNo, 'T2042' + FInst, 70), 3); // 20160127
  If Vl(SFD.WebPercent) = 0 then
    SFD.WebPercent := Space(3); // 20160121

  clearPRecArray;

  i := 0;
  If Vl(FetchElm(RetNo, 'T2042' + FInst, 642)) > 0 then
  begin
    inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2042' + FInst, 640), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2042' + FInst, 664), 30);
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T2042' + FInst, 665), 8);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2042' + FInst, 642));
  end;
  If Vl(FetchElm(RetNo, 'T2042' + FInst, 646)) > 0 then
  begin
    inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2042' + FInst, 644), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2042' + FInst, 666), 30);
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T2042' + FInst, 667), 8);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2042' + FInst, 646));
  end;
  If Vl(FetchElm(RetNo, 'T2042' + FInst, 650)) > 0 then
  begin
    inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2042' + FInst, 648), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2042' + FInst, 668), 30);
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T2042' + FInst, 669), 8);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2042' + FInst, 650));
  end;
  If Vl(FetchElm(RetNo, 'T2042' + FInst, 654)) > 0 then
  begin
    inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2042' + FInst, 652), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2042' + FInst, 670), 30);
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T2042' + FInst, 671), 8);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2042' + FInst, 654));
  end;
  If Vl(FetchElm(RetNo, 'T2042' + FInst, 658)) > 0 then
  begin
    inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2042' + FInst, 656), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2042' + FInst, 672), 30);
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T2042' + FInst, 673), 8);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2042' + FInst, 658));
  end;
  If Vl(FetchElm(RetNo, 'T2042' + FInst, 662)) > 0 then
  begin
    inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2042' + FInst, 660), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2042' + FInst, 674), 30);
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T2042' + FInst, 675), 8);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2042' + FInst, 662));
  end;

  EFlines := TStringList.Create;
  EFlines.LoadFromFile(AppDir + '\' + 'EFFLINE.D');

  For i := 1 to 5 do
  begin
  end;
  { Free format SFD }
  // BuildDtlFGS740(RetNo);
  { 12345678901234567890123
    {Format nnnn $ fffffffff elm rrr }
  For i := 0 to EFlines.Count - 1 do
  begin
    LLine := MyStrToInt(LeftStr(EFlines[i], 4));
    LType := MidStr(EFlines[i], 6, 1);
    FName := AllTrim(MidStr(EFlines[i], 8, 9)) + FInst;
    ElmNo := MyStrToInt(MidStr(EFlines[i], 17, 3));
    If MidStr(EFlines[i], 22, 3) = '' then
      Rule := 0
    else
      Rule := MyStrToInt(MidStr(EFlines[i], 22, 3));

    s := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
    If LLine = 9946 then
    begin
      If (s = '') and (Vl(FetchElm(RetNo, 'T2042' + FInst, 66)) <> 0) then
        s := '1';
    end;

    If LLine = 9899 then
    begin
      If (s = '') and (Vl(FetchElm(RetNo, 'T2042' + FInst, 66)) <> 0) and
        (Vl(FetchElm(RetNo, 'T2042' + FInst, 148)) = 0) then
        s := '1';
    end;

    If LLine = 9946 then { restricted farm loss }
    begin
      If (s > '') and (Vl(FetchElm(RetNo, 'T2042' + FInst, 150)) <> 0) then
      begin
        s := AllTrim(IntToStr(Round(Vl(FetchElm(RetNo, 'T2042' + FInst,
          149)))));
      end;
    end;
    If s > '' then
    begin
      s := ReplaceChar(s, '-', '&');
      AddStringToBuffers(LLine, s);
      // BuildDtlTIA820(RetNo,AllTrim(IntToStr(LLine)),s);
    end;
  end;
  RemoveLastDashFromBuffers;
  EFlines.Free;
end;

Procedure PrepareT777(RetNo: Integer; FInst: String);
Var
  i, LLine, ElmNo, Rule: Integer;
  LType: string[1];
  s: string;
  FName: string[12];
begin
  VariableBuffer := '';
  SFD.RECTYPE := '03';
  SfdRecNumber := SfdRecNumber + 1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber), 2);
  SFD.BUSTYPE := '7';
  SFD.NAICS := '';
  SFD.SIN := RemoveHyphens(FetchElm(RetNo, 'INFO', 3));
  SFD.BUSNAME := '';
  SFD.BUSADDRESS := '';
  SFD.BUSPOSTAL := '';
  SFD.BUSFISCSTART := '00000000'; // 20170215
  SFD.BUSFISCEND := '00000000'; // 20170215
  SFD.InternetPages := ''; // 20170204
  // SFD.AcrOwned :='';
  // SFD.AcrFarmed:='';
  SFD.ACCMETHOD := '';
  SFD.BUSPARTNID := '';
  SFD.BUSPERCENT := '';
  SFD.BUSTAXSHELTNO := '';
  SFD.BUSFINALYR := '';

  SFD.BUSNUMBER := '';

  clearPRecArray;

  EFlines := TStringList.Create;
  EFlines.LoadFromFile(AppDir + '\' + 'EFT777.D');

  { ---- }

  {
    BuildDtlTFS900(RetNo);
    BuildDtlFGS990(RetNo);
    BuildDtlTIA1020ForT777(RetNo);
    BuildDtlFGS1100(RetNo);
  }

  { Free format SFD fot t777 }
  { 12345678901234567890123
    {Format nnnn $ fffffffff elm rrr }
  For i := 0 to EFlines.Count - 1 do
  begin
    // ShowMessage(Eflines[i]);
    LLine := MyStrToInt(LeftStr(EFlines[i], 4));
    LType := MidStr(EFlines[i], 6, 1);
    FName := AllTrim(MidStr(EFlines[i], 8, 9)); // +FInst;
    ElmNo := MyStrToInt(MidStr(EFlines[i], 17, 3));
    If MidStr(EFlines[i], 22, 3) = '' then
      Rule := 0
    else
      Rule := MyStrToInt(MidStr(EFlines[i], 22, 3));
    s := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
    If (s > '') and (LLine > 0) then
    begin
      s := ReplaceChar(s, '-', '&');
      AddStringToBuffers(LLine, s);
      // BuildDtlTIA1180(RetNo,AllTrim(IntToStr(LLine)),s);
    end;
  end;
  RemoveLastDashFromBuffers;
  EFlines.Free;
end;

(*
  Procedure PrepareT777S(RetNo: Integer; FInst: String);
  Var
  i, LLine, ElmNo, Rule: Integer;
  LType: string[1];
  s: string;
  FName: string[12];
  begin
  VariableBuffer := '';
  SFD.RECTYPE := '03';
  SfdRecNumber := SfdRecNumber + 1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber), 2);
  SFD.BUSTYPE := '13'; //'7'; //20221206
  SFD.NAICS := '';
  SFD.SIN := RemoveHyphens(FetchElm(RetNo, 'INFO', 3));
  SFD.BUSNAME := '';
  SFD.BUSADDRESS := '';
  SFD.BUSPOSTAL := '';
  SFD.BUSFISCSTART := '00000000'; // 20170215
  SFD.BUSFISCEND := '00000000'; // 20170215
  SFD.InternetPages := ''; // 20170204
  // SFD.AcrOwned :='';
  // SFD.AcrFarmed:='';
  SFD.ACCMETHOD := '';
  SFD.BUSPARTNID := '';
  SFD.BUSPERCENT := '';
  SFD.BUSTAXSHELTNO := '';
  SFD.BUSFINALYR := '';

  SFD.BUSNUMBER := '';

  clearPRecArray;

  EFlines := TStringList.Create;
  EFlines.LoadFromFile(AppDir + '\' + 'EFT777S.D');

  { ---- }

  {
  BuildDtlTFS900(RetNo);
  BuildDtlFGS990(RetNo);
  BuildDtlTIA1020ForT777(RetNo);
  BuildDtlFGS1100(RetNo);
  }

  { Free format SFD fot t777 }
  { 12345678901234567890123
  {Format nnnn $ fffffffff elm rrr }
  For i := 0 to EFlines.Count - 1 do
  begin
  // ShowMessage(Eflines[i]);
  LLine := MyStrToInt(LeftStr(EFlines[i], 4));
  LType := MidStr(EFlines[i], 6, 1);
  FName := AllTrim(MidStr(EFlines[i], 8, 9)); // +FInst;
  ElmNo := MyStrToInt(MidStr(EFlines[i], 17, 3));
  If MidStr(EFlines[i], 22, 3) = '' then
  Rule := 0
  else
  Rule := MyStrToInt(MidStr(EFlines[i], 22, 3));
  s := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
  If (s > '') and (LLine > 0) then
  begin
  s := ReplaceChar(s, '-', '&');
  AddStringToBuffers(LLine, s);
  // BuildDtlTIA1180(RetNo,AllTrim(IntToStr(LLine)),s);
  end;
  end;
  RemoveLastDashFromBuffers;
  EFlines.Free;
  end;
*)

Procedure PrepareT2091(RetNo: Integer; FInst: String); // jz T2091 20180123
Var
  i, LLine, ElmNo, Rule: Integer;
  LType: string[1];
  s: string;
  FName: string[12];
begin
  VariableBuffer := '';
  // ????????????????????????????????????????????????????????????????????????????
  SFD.RECTYPE := '03';
  SfdRecNumber := SfdRecNumber + 1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber), 2);
  SFD.BUSTYPE := '11'; // 20180123 Con
  SFD.NAICS := '';
  SFD.SIN := RemoveHyphens(FetchElm(RetNo, 'INFO', 3));
  SFD.BUSNAME := '';
  SFD.BUSADDRESS := '';
  SFD.BUSPOSTAL := '';
  SFD.BUSFISCSTART := '00000000'; // 20170215
  SFD.BUSFISCEND := '00000000'; // 20170215
  SFD.InternetPages := ''; // 20170204
  SFD.ACCMETHOD := '';
  SFD.BUSPARTNID := '';
  SFD.BUSPERCENT := '';
  SFD.BUSTAXSHELTNO := '';
  SFD.BUSFINALYR := '';
  SFD.BUSNUMBER := '';
  // ????????
  clearPRecArray;
  EFlines := TStringList.Create;
  EFlines.LoadFromFile(AppDir + '\' + 'EFT2091.D');

  // Free format SFD for t2091
  // 12345678901234567890123
  // Format nnnn $ fffffffff elm rrr

  For i := 0 to EFlines.Count - 1 do
  begin
    LLine := MyStrToInt(LeftStr(EFlines[i], 4));
    LType := MidStr(EFlines[i], 6, 1);
    FName := AllTrim(MidStr(EFlines[i], 8, 9)) + FInst;
    ElmNo := MyStrToInt(MidStr(EFlines[i], 17, 3));
    If MidStr(EFlines[i], 22, 3) = '' then
      Rule := 0
    else
      Rule := MyStrToInt(MidStr(EFlines[i], 22, 3));
    s := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
    If LLine = 9956 then
      s := AddleadingZeros(s, 2); // 20180208
    If s > '' then
    begin
      s := ReplaceChar(s, '-', '&');
      AddStringToBuffers(LLine, s);
    end;
  end;
  RemoveLastDashFromBuffers;
  EFlines.Free;
end;

Procedure PrepareTL2(RetNo: Integer; FInst: String);
Var
  i, LLine, ElmNo, Rule: Integer;
  LType: string[1];
  s: string;
  FName: string[12];
begin
  VariableBuffer := '';
  SFD.RECTYPE := '03';
  SfdRecNumber := SfdRecNumber + 1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber), 2);
  SFD.BUSTYPE := '8';
  SFD.NAICS := '';
  SFD.SIN := RemoveHyphens(FetchElm(RetNo, 'INFO', 3));
  SFD.BUSNAME := '';
  SFD.BUSADDRESS := '';
  SFD.BUSPOSTAL := '';
  SFD.BUSFISCSTART := '00000000'; // 20170215
  SFD.BUSFISCEND := '00000000'; // 20170215
  SFD.InternetPages := ''; // 20170204
  // SFD.AcrOwned :='';
  // SFD.AcrFarmed:='';
  SFD.ACCMETHOD := '';
  SFD.BUSPARTNID := '';
  SFD.BUSPERCENT := '';
  SFD.BUSTAXSHELTNO := '';
  SFD.BUSFINALYR := '';
  SFD.BUSNUMBER := '';

  clearPRecArray;

  EFlines := TStringList.Create;
  EFlines.LoadFromFile(AppDir + '\' + 'EFTL2.D');

  // Free format SFD for 2091
  // 12345678901234567890123
  // Format nnnn $ fffffffff elm rrr
  For i := 0 to EFlines.Count - 1 do
  begin
    LLine := MyStrToInt(LeftStr(EFlines[i], 4));
    LType := MidStr(EFlines[i], 6, 1);
    FName := AllTrim(MidStr(EFlines[i], 8, 9)) + FInst;
    // FName := AllTrim(MidStr(Eflines[i],8,9));
    ElmNo := MyStrToInt(MidStr(EFlines[i], 17, 3));
    If MidStr(EFlines[i], 22, 3) = '' then
      Rule := 0
    else
      Rule := MyStrToInt(MidStr(EFlines[i], 22, 3));
    s := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
    If s > '' then
    begin
      s := ReplaceChar(s, '-', '&');
      AddStringToBuffers(LLine, s);
      // BuildDtlTIA1180(RetNo,AllTrim(IntToStr(LLine)),s);
    end;
  end;
  RemoveLastDashFromBuffers;
  EFlines.Free;
end;

Function FormatBusPercent(s: string): String;
Var
  s1: String[3];
  x: real;
begin
  If Vl(s) = 100 then
  begin
    Result := '00';
    exit;
  end;
  Result := FormatFloat('000000', Vl(s) * 10000); // 4 decimals
end;

Procedure SaveBarDataToText;
var
  s, Filename: String;
  txt: TextFile;
  i: Integer;
  BarDataList: TStringList;
Begin
  Filename := AppDir + '\BarCodedata.txt';
  AssignFile(txt, Filename);

  IF FileExists(Filename) Then
    Append(txt)
  Else
    Rewrite(txt);

  i := 0;
  Write(txt, BarData + CrLf);

  (*
    Repeat
    s:=MidStr(BarData,i,255);
    Write (txt,s+CrLf);
    if Pos('EOD',s) > 0 then
    Write (txt,'----------------------------------------------------------------------------------------------------'+CrLf);
    Inc(i,255);
    until i>Length(BarData);
  *)
  Flush(txt); // ensures that the text was actually written to file
  closefile(txt);

End;

// Not in effect //20220429  only for testing
Procedure SaveT1RecToText(Buf: AnsiString); // 20220427
var
  s, FileDirectory, Filename: String;
  // txtFile: TextFile;
  // i: Integer;
  T1RecList: TStringList;
Begin
  T1RecList := TStringList.Create;
  FileDirectory := AppDir + '\EolFiles\';
  Filename := 'T1Rec.txt';

  if not TDirectory.Exists(FileDirectory) then
  // jz 20240228 //create dir if doesnt exist as if dir doesnt exist printing would fail
    TDirectory.CreateDirectory(FileDirectory);

  T1RecList.add(Buf);
  T1RecList.SaveToFile(FileDirectory + Filename);
  T1RecList.Free;

  (*
    IF FileExists(Filename) then Rewrite(txtFile);
    i := 0;
    Write(txtFile, BarData + CrLf);
    Flush(txtFile); // ensures that the text was actually written to file
    closefile(txtFile);
  *)
End;

Procedure FindSFDFormNamesForBarCode(RetNo: Integer;
  Var BarFormNames: TStringList);
Var
  i: Integer;
Begin
  for i := 0 to (FList.Count - 1) do
  begin
    // if i = 294 then showmessage('stop');
    FRec := FList.Items[i];
    If ((FRec.FormInst > '') and
      (Ret[RetNo].FormHasData[FRec.FormName + FRec.FormInst])) then // 20160613
    begin
      If (FRec.FormName = 'T776') then
        BarFormNames.add(FRec.FormName + FRec.FormInst)
      Else If (FRec.FormName = 'T2125') then
        BarFormNames.add(FRec.FormName + FRec.FormInst)
      Else If (FRec.FormName = 'T2121') then
        BarFormNames.add(FRec.FormName + FRec.FormInst)
      Else If (FRec.FormName = 'T2042') then
        BarFormNames.add(FRec.FormName + FRec.FormInst)
      Else If (FRec.FormName = 'TL2') then
        BarFormNames.add(FRec.FormName + FRec.FormInst)
      Else If (FRec.FormName = 'T2091') then // jz 20180123 T2091
        BarFormNames.add(FRec.FormName + FRec.FormInst)

      Else If (FRec.FormName = 'T777') then
      // jz 20210218  moved from below as was in wrong place never gets to it
        BarFormNames.add(FRec.FormName + FRec.FormInst);

    end;

    {
      Else if Ret[RetNo].FormHasData[FRec.FormName + FRec.FormInst] then
      // 20160813
      begin
      If (FRec.FormName = 'T777') then
      BarFormNames.Add(FRec.FormName + FRec.FormInst)
      end;
    }

  end;
end;

Procedure clearPRecArray;
var
  i: Integer;
begin
  For i := 1 to 6 do
  begin
    SFD.PRec[i].PFirstName := '';
    SFD.PRec[i].PLastName := '';
    SFD.PRec[i].PSin := '';
    SFD.PRec[i].PPerCent := '';
  end;
end;

procedure CreateBarCode(SplitBarDataArray: Array of AnsiString;
  var BarCodeImageArray: Array of TImage);
// 20150727
var
  i, n, codeLength, ImageArrayPos: Integer;
  FileIDFieldVar, TempFileIDFieldVar: String;
  MyPDF: TPDF417;
begin
  ImageArrayPos := 0;
  for i := low(SplitBarDataArray) to High(SplitBarDataArray) do
  begin
    BarCodeImageArray[ImageArrayPos] := TImage.Create(Application);

    BarCodeImageArray[ImageArrayPos].Height := 200;
    BarCodeImageArray[ImageArrayPos].width := 400;

    BarCodeImageArray[ImageArrayPos].Transparent := True;
    BarCodeImageArray[ImageArrayPos].AutoSize := false;

    MyPDF := TPDF417.Create(nil);
    MyPDF.resetMacroPDF();

    MyPDF.PDFMode := PDF_BINARY; // PDF_TEXT;

    MyPDF.width := BarCodeImageArray[ImageArrayPos].width;
    MyPDF.Height := BarCodeImageArray[ImageArrayPos].Height;

    MyPDF.BarWidthPixels := 1;
    MyPDF.BarHeightPixels := 3;

    MyPDF.TopMargin := 0; // 10;
    MyPDF.LeftMargin := 0; // 10;

    MyPDF.AutoFit := True;

    MyPDF.PDFECLevel := 4; // error checking

    MyPDF.code := '';
    MyPDF.code := SplitBarDataArray[i];

    if High(SplitBarDataArray) > 0 then
    begin
      if i = High(SplitBarDataArray) then
      begin
        MyPDF.MacroPDFLastSegment := True;
      end
      else
      begin
        MyPDF.MacroPDFLastSegment := false;
      end;

      // MyPdf.PDFMacroFileId       := leftStr('1' + leftstr(RSIApprovalCode,2) + FileIDFieldVar,7);

      MyPDF.PDFMacroSegmentCount := High(SplitBarDataArray) + 1;
      MyPDF.PDFMacroSegment := i;
    end;

    codeLength := Length(MyPDF.code);

    MyPDF.PDFColumns := 14; // 14
    MyPDF.PDFRows := 59; // 50

    MyPDF.paintBarcode(BarCodeImageArray[ImageArrayPos].Canvas);

    // showmessage('Col:' + inttostr(MyPdf.PDFColumns) + ' Row: ' + inttostr(MyPdf.PDFRows));

    MyPDF.Free;

    inc(ImageArrayPos, 1);
  end;
end;

// 20150727 procedure CreateSFDBarCode(SFDBarDataArray:Array of String;var BarCodeImageArray:Array of TImage);
procedure CreateSFDBarCode(SFDBarDataArray: Array of AnsiString;
  var BarCodeImageArray: Array of TImage);
var
  i, n, codeLength, ImageArrayPos: Integer;
  FileIDFieldVar, TempFileIDFieldVar: String;
  MyPDF: TPDF417;
begin
  ImageArrayPos := 0;
  for i := low(SFDBarDataArray) to High(SFDBarDataArray) do
  begin
    BarCodeImageArray[ImageArrayPos] := TImage.Create(Application);

    BarCodeImageArray[ImageArrayPos].Height := 200;
    BarCodeImageArray[ImageArrayPos].width := 400;

    BarCodeImageArray[ImageArrayPos].Transparent := True;
    BarCodeImageArray[ImageArrayPos].AutoSize := false;

    MyPDF := TPDF417.Create(nil);
    MyPDF.resetMacroPDF();

    MyPDF.PDFMode := PDF_BINARY; // PDF_TEXT;

    MyPDF.width := BarCodeImageArray[ImageArrayPos].width;
    MyPDF.Height := BarCodeImageArray[ImageArrayPos].Height;

    MyPDF.BarWidthPixels := 1;
    MyPDF.BarHeightPixels := 3;

    MyPDF.TopMargin := 0; // 10;
    MyPDF.LeftMargin := 0; // 10;

    MyPDF.AutoFit := True;

    MyPDF.PDFECLevel := 4; // error checking

    MyPDF.code := '';
    MyPDF.code := SFDBarDataArray[i];

    // MyPdf.MacroPDFLastSegment:=true;
    // MyPdf.PDFMacroFileId       := leftStr('1' + leftstr(RSIApprovalCode,2) + FileIDFieldVar,7);
    // MyPdf.PDFMacroSegmentCount := 1; //High(SFDBarDataArray) + 1;
    // MyPdf.PDFMacroSegment      := 1; //i;

    codeLength := Length(MyPDF.code);

    MyPDF.PDFColumns := 14; // 14
    MyPDF.PDFRows := 59; // 50

    MyPDF.paintBarcode(BarCodeImageArray[ImageArrayPos].Canvas);

    // showmessage('Col:' + inttostr(MyPdf.PDFColumns) + ' Row: ' + inttostr(MyPdf.PDFRows));
    MyPDF.Free;
    inc(ImageArrayPos, 1);
  end;
end;

procedure DrawQRCode(AData: string; ACanvas: TCanvas; ARect: TRect);
// 20180307 Igor
var
  QRCode: TDelphiZXingQRCode;
  QRCodeBitmap, ScaleBitmap: TBitmap;
  Row, Column: Integer;
  Scale: Double;
  width, Height: Integer;
begin
  QRCode := TDelphiZXingQRCode.Create;
  QRCodeBitmap := TBitmap.Create;
  ScaleBitmap := TBitmap.Create;
  try
    QRCode.Data := AData;
    QRCode.Encoding := qrISO88591;
    QRCode.QuietZone := 2;
    QRCodeBitmap.SetSize(QRCode.Rows, QRCode.Columns);
    for Row := 0 to QRCode.Rows - 1 do
    begin
      for Column := 0 to QRCode.Columns - 1 do
      begin
        if (QRCode.IsBlack[Row, Column]) then
        begin
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clBlack;
        end
        else
        begin
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clWhite;
        end;
      end;
    end;

    if ((QRCodeBitmap.width > 0) and (QRCodeBitmap.Height > 0)) then
    begin
      width := ARect.Right - ARect.Left;
      Height := ARect.Bottom - ARect.Top;
      if (width < Height) then
      begin
        Scale := width / QRCodeBitmap.width;
      end
      else
      begin
        Scale := Height / QRCodeBitmap.Height;
      end;
      ScaleBitmap.width := width;
      ScaleBitmap.Height := Height;
      ScaleBitmap.Canvas.StretchDraw(Rect(0, 0, width, width), QRCodeBitmap);
      // ScaleBitmap.SaveToFile('QR.bmp');
      ACanvas.Draw(ARect.Left, ARect.Top, ScaleBitmap);
    end;
  finally
    QRCode.Free;
    QRCodeBitmap.Free;
    ScaleBitmap.Free;
  end;
end;

procedure Create1013BarCode(BarData1013: AnsiString;
  var BarCodeImage1013: TImage);
// 20150727 procedure Create1013BarCode(BarData1013:String;var BarCodeImage1013:TImage);
var
  i, n, codeLength, ImageArrayPos: Integer;
  FileIDFieldVar, TempFileIDFieldVar: String;
  MyPDF: TPDF417;
begin
  BarCodeImage1013 := TImage.Create(Application);

  with BarCodeImage1013 do
  begin
    Height := 200;
    width := 400;
    Transparent := True;
    AutoSize := false;
  end;

  MyPDF := TPDF417.Create(nil);
  with MyPDF do
  begin
    MyPDF.resetMacroPDF();

    MyPDF.PDFMode := PDF_BINARY; // PDF_TEXT;
    MyPDF.width := BarCodeImage1013.width;
    MyPDF.Height := BarCodeImage1013.Height;
    MyPDF.BarWidthPixels := 1;
    MyPDF.BarHeightPixels := 3;
    MyPDF.TopMargin := 0; // 10;
    MyPDF.LeftMargin := 0; // 10;
    MyPDF.AutoFit := True;
    MyPDF.PDFECLevel := 4; // error checking
    MyPDF.code := '';
    MyPDF.code := BarData1013;
    MyPDF.PDFColumns := 14; // 14
    MyPDF.PDFRows := 59; // 50
  end;
  codeLength := Length(MyPDF.code);

  MyPDF.paintBarcode(BarCodeImage1013.Canvas);

  MyPDF.Free;
end;

end.
