Unit T1_2026EfileRtns;
// imported 07-26

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  ExtCtrls, Menus, ComCtrls, OleCtrls, Buttons, ToolWin,
  ActnList, ImgList,
  shdocvw, Printers, Db, ActiveX, T1_2026Declare, T1_2026TrimStr,
  // T1_2026PopList,
  T1_2026Common, T1_2026Common2, T1_2026T1rtns, T1_2026Calc,
  T1_2026T1Rtns2, T1_2026RTU, ShellApi, T1_2026ChildWinNew, FileCtrl,
  T1_2026EolSetup;

Const
  ElemSep = '*';
  LineSep = EfDelim;
  GenericAgent = 'B6671'; // for efile on-line only
  SoftReleaseDate = EfileSoftReleaseDate;
  // 20231221 //'2023-12-21'; ///2023221 /'2023-03-07';  //20230512
  // '2022-02-20'; //20230307 //20220513 certified for MJ
  SoftReleaseDateEOL = EfileSoftReleaseDate;
  SoftReleaseDateNetFile = EfileSoftReleaseDate; // 20231221 SoftReleaseDate;

Type
  AFX = Record
    { T1REC FIXED PART }
    RECLEN: String[4];
    RECTYPE: String[2];
    PREPARERNO: String[5];
    SEQNO: String[8];
    PREPPSWD: String[7];
    DISCNUMBER: String[8];
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
    SECONDNAME: String[30]; // 20240223
    LASTNAME: String[30];
    CAREOFNAME: String[26];
    STREET: String[60];
    CITY: String[50];
    PROVINCE: String[2];
    POSTAL: String[6];
    PROVCHANGE: String[1]; // 20121201
    PROVDATECHANGE: String[10]; // 20121201
    CLAREA: String[3];
    CLPHONE: String[7];
    NAMECHANGE: String[1];
    ALTADDR: String[2];
    LANGUAGE: String[1];
    GSTYESNO: String[1];
    Email: String[75];
    SPOUSENETINC: String[9];
    SPOUSEUCCB: String[9];
    SPOUSEUCCBRepay: String[9];
    SpouseSelfEmpl: String[1];

    FirstTimeFiler: boolean;
    // jz 20240209   // Con 20240209 replaced by frunction

    // new in 2008  27 bytes
    ISDECEASED: String[1];
    DATEOFDEATH: String[10];
    ElectionToTaxDeceasedBeneficiaryIndicator: String[1]; // 20170101
    ISPREBANKRUPT: String[1];
    POSTBANKRUPTNI: String[9];
    DATEOFBANKRUPTCY: String[10];
    POSTBANKRUPTAdjustedNI: String[9]; // PostBankruptcyAdjustedNotIncomeAmount
    //
    SFDRECS: String[2];
    DEVELOPER: String[3];
    SOFTCODE: String[1];
    SOFTRELEASE: String[10];
    FDEADLINE: String[1];
    CLAUTHORIZE: String[1];
    AUTHORIZEEXPIRY: String[10];
    NOARetrievalAuth: String[1]; // 20170407
    PREASSESSMENT: String[1];
    POSTASSESSMENT: String[1];
    CANCITIZEN: String[1];
    ElectionsCanada: String[2];
    FNCValue: String[1]; // first nation
    FIRSTNation: String[5];
    CitizenFN: String[1]; // 20121219  NEW  //renamed from YTcitizen 20170108
    ProvEffectiveDate: String[10]; // 20121219  NEW
    PresentPrv: String[2];
    SelfEmplPrv: String[2]; // new
  end;

  // SFD FIXED TYPE for partners section
Type
  PartnerRec = Record
    PFirstName: String[30];
    PLastName: String[30];
    PSin: String[8];
    PPerCent: String[6]; // new 2005
  end;

Type
  ASfd = Record
    { SFD FIXEDTYPE }
    RECLEN: String[4];
    RECTYPE: String[2];
    PREPARERNO: String[5];
    SEQNO: String[8];
    SFDREC: String[2];
    BUSTYPE: String[1];
    SIC: String[6];
    SIN: String[9];
    BUSNAME: String[30];
    BusinessNumber: String[9]; // 20191127
    BUSADDRESS: String[30];
    BUSPOSTAL: String[6];
    BUSFISCSTART: String[10];
    BUSFISCEND: String[10];
    FarmStead: String[2]; // 20111207
    ACROWNED: String[9];
    ACRFARMED: String[9];
    ACCMETHOD: String[1];
    BUSPARTNID: String[9];
    BUSPERCENT: String[4]; { was }
    BUSTAXSHELTNO: String[8];
    BUSFINALYR: String[1];
    GSTACCNO: String[15];

    PRec: Array [1 .. 6] of PartnerRec;
  end;

Function ExcludeFormsInMult(RetNo: Integer; FName: String; FrmSource: String;
  LLine: Integer): boolean;
Function CleanUpTelephoneNo(S: String): String;
procedure BuildPartners(RetNo: Integer);
// Procedure BuildPartners;
Procedure BuildNISAContactInfo(RetNo: Integer; FName: String);
Procedure BuildHarmonizedContactInfo(RetNo: Integer; FName: String);
Function GetAlternateAddressCode(RetNo: Integer): String;
// Function MkXmlFileName(RetNo:Integer;NetFileDir:String):String;
procedure CreateXmlDataFile(RetNo: Integer; EolTaxFlName: String;
  ProdOrTest: String; OnLineMethod: String; Sender: TObject);
Procedure PrepareT1Rec(RetNo: Integer; ProdOrTest: String;
  OnLineMethod: String);

//procedure TagInsertbyRule(retNo, rule:integer; var XmlList:Tstringlist); //jz//20250322

Procedure BuildSfds(RetNo: Integer);
Procedure ClearPartnersInfo;
Function FgsHasData(RetNo: Integer; FNo: Integer;
  FromElm, ToElm, ByElm, k: Integer): boolean;
Function GetNumberOfSFDs(RetNo: Integer): Integer;
Function GetNumberOfSFDsForBarcode(RetNo: Integer): Integer;
Procedure BuildRental(RetNo: Integer; FInst: String);
Procedure BuildT777(RetNo: Integer; FInst: String);
// Procedure BuildT777S(RetNo: Integer; FInst: String);
Procedure BuildTL2(RetNo: Integer; FInst: String);
Procedure BuildT2091(RetNo: Integer; FInst: String); // 20180115
Procedure BuildT1255(RetNo: Integer; FInst: String); // 20180304
Procedure BuildBusiness(RetNo: Integer; FInst: String);
Procedure BuildFarming(RetNo: Integer; FInst: String);
Procedure BuildFishing(RetNo: Integer; FInst: String);
Procedure BuildT1163(RetNo: Integer; FInst: String);
Function Format1273Numerics(S: String; DecimalPlaces: Integer): String;
Function BuildCrop(RetNo: Integer; FNo: Integer; FromElm, ToElm, ByElm: Integer;
  k: Integer): Integer;
Procedure BuildT1273(RetNo: Integer; FInst: String);
Procedure BuildT1273Additional(RetNo: Integer; FInst: String);
Function BuildLiveStock(RetNo: Integer; FNo: Integer;
  FromElm, ToElm, ByElm: Integer; k: Integer): Integer;
Procedure BuildAdditionalLivestock(RetNo: Integer; FNo: Integer; Line: String;
  valu: String);
Procedure BuildT1273ALI(RetNo: Integer; FNo: Integer;
  FromElm, ToElm, ByElm, k: Integer);
Function BuildT1273PI(RetNo: Integer; FNo: Integer;
  FromElm, ToElm, ByElm, k: Integer): Integer;
Function BuildT1273DI(RetNo: Integer; FNo: Integer;
  FromElm, ToElm, ByElm, k: Integer): Integer;
Function BuildT1273AP(RetNo: Integer; FNo: Integer;
  FromElm, ToElm, ByElm, k: Integer): Integer;

Procedure BuildDtlIN2570(RetNo: Integer; PFirstNm, PLastNm: String);
Procedure BuildDtlTIA600(RetNo: Integer; PPerCent: String);
Procedure BuildLineValues(RetNo: Integer; LLineString: String; S: String);
Procedure BuildSfdLineValues(RetNo: Integer; LLineString: String; S: String);
Procedure BuildDtlTIA1180(RetNo: Integer; LLineString: String; S: String);
Procedure BuildDtlFGS850(RetNo: Integer);
Procedure BuildDtlTFS900(RetNo: Integer);
Procedure BuildDtlN3470(RetNo: Integer; BUSADDRESS, BUSPOSTAL: String);

var
  // OnLineNo,PassWord,FileName,Url,Refund:String;  //to be used by the uhtmlEfOnline
  DcnNo: Integer;
  F1: TextFile;
  SfdNo: Integer;
  EFlines: TStringList;
  CrLf: String;

  GroupCtrlNo: String;
  ISACtrlNo: String;
  NetFileDir: String;
  TxSetCnt: Integer;

  SegmentCnt: Integer;
  OnLineNo, PassWord, FileName, Url, Refund: String;
  // to be used bu the uhtmlEfOnline
  OnLineMethod, ProdOrTest: String;
  SfdRecNumber: Integer; { sfd counter on each return }
  SFDRECS, TotSfdRecs: Integer;

  Indent1, Indent2, Indent3, Indent4, Indent5, Indent6, Indent7, Indent8,
    Indent9, Indent10, Indent11: Integer;

  Fx: AFX;
  SFD: ASfd;

  userName, UserPassWord: string;
  SoapMsg: AnsiString;

  FormCnt: Integer;
  // T1EfileDir: String;
  sUrl: String;

  // XmlList:TStringList;

implementation

uses
  vtCommon,
  T1_2026, T1_2026main,
  vtTrimStr, vtShared;

Function GetNumberOfSFDs(RetNo: Integer): Integer;
Var
  RentSfds, BusSfds, ProfSfds, FarmSfds, FishSfds, NisaSfds, HCaisSfds,
    T777Sfds, TL2Sfds, T2091Sfds, T1255Sfds: Integer;
begin
  RentSfds := 0;
  BusSfds := 0;
  ProfSfds := 0;
  FarmSfds := 0;
  FishSfds := 0;
  NisaSfds := 0;
  HCaisSfds := 0;
  T777Sfds := 0;
  TL2Sfds := 0;
  T2091Sfds := 0; // 20180115
  T1255Sfds := 0; // 20180304
  // T777sSFDS := 0;
  CountSfds(RetNo, RentSfds, BusSfds, ProfSfds, FarmSfds, FishSfds, NisaSfds,
    HCaisSfds, T777Sfds, TL2Sfds, T2091Sfds, T1255Sfds); // 20180304
  Result := RentSfds + BusSfds + ProfSfds + FarmSfds + FishSfds + NisaSfds +
    HCaisSfds + T777Sfds + TL2Sfds + T2091Sfds + T1255Sfds;
  // 20210123
  If IsPreBankruptcyReturn(RetNo) then
    Result := 0;
end;

Function GetNumberOfSFDsForBarcode(RetNo: Integer): Integer; // 20210218
Var
  RentSfds, BusSfds, ProfSfds, FarmSfds, FishSfds, NisaSfds, HCaisSfds,
    T777Sfds, TL2Sfds, T2091Sfds, T1255Sfds: Integer;
begin
  RentSfds := 0;
  BusSfds := 0;
  ProfSfds := 0;
  FarmSfds := 0;
  FishSfds := 0;
  NisaSfds := 0;
  HCaisSfds := 0;
  T777Sfds := 0;
  TL2Sfds := 0;
  T2091Sfds := 0; // 20180115
  T1255Sfds := 0; // 20180304
  // T777sSFDS := 0;
  CountSfds(RetNo, RentSfds, BusSfds, ProfSfds, FarmSfds, FishSfds, NisaSfds,
    HCaisSfds, T777Sfds, TL2Sfds, T2091Sfds, T1255Sfds); // 20180304
  Result := RentSfds + BusSfds + ProfSfds + FarmSfds + FishSfds + NisaSfds +
    HCaisSfds + T777Sfds + TL2Sfds + T2091Sfds + T1255Sfds;
  // 20210123
  If IsPreBankruptcyReturn(RetNo) then
    Result := 0;
end;

Procedure BuildSfds(RetNo: Integer);
Var
  i: Integer;
  Rec: String;
  FInst: String;
  FNo: Integer;
begin
  If GetNumberOfSFDs(RetNo) < 1 then
    exit;
  XmlList.add(Space(Indent3) + '<t1:SelectedFinancialDataRecordCount>' +
    AddLeadingZeros(IntToStr(GetNumberOfSFDs(RetNo)), 2) +
    '</t1:SelectedFinancialDataRecordCount>');
  ClearPartnersInfo;
  SfdNo := 0;

  (* //20250110
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If Ret[RetNo].FormHasData[FRec.FormName + FRec.FormInst] then // 20160813
    begin
      // if bankruptcy??
      If (FRec.FormName = 'T776') and (FRec.FormInst > '') then
      begin
        Inc(SfdNo);
        ClearPartnersInfo;
        XmlList.add(Space(Indent3) + '<sfd:SelectedFinancialData>');
        XmlList.add(Space(Indent3) + '<sfd:RealEstateRentalData>');
        BuildRental(RetNo, FRec.FormInst);
        XmlList.add(Space(Indent3) + '</sfd:RealEstateRentalData>');
        XmlList.add(Space(Indent3) + '</sfd:SelectedFinancialData>');
      end;
    end;
  end;
  *)
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If (FRec.FormName = 'T2125') and (FRec.FormInst > '') then
    begin
      If Ret[RetNo].FormHasData[FRec.FormName + FRec.FormInst] then // 20160813
      begin
        Inc(SfdNo);
        ClearPartnersInfo;
        XmlList.add(Space(Indent3) + '<sfd:SelectedFinancialData>');
        FNo := GetFormNo(FRec.FormName + FRec.FormInst);
        If FetchElmFNo(RetNo, FNo, 82) > '' then
          XmlList.add(Space(Indent3) + '<sfd:BusinessActivityData>')
        Else
          XmlList.add(Space(Indent3) + '<sfd:ProfessionalActivityData>');
        BuildBusiness(RetNo, FRec.FormInst);
        If FetchElmFNo(RetNo, FNo, 82) > '' then
          XmlList.add(Space(Indent3) + '</sfd:BusinessActivityData>')
        else
          XmlList.add(Space(Indent3) + '</sfd:ProfessionalActivityData>');
        XmlList.add(Space(Indent3) + '</sfd:SelectedFinancialData>');
      end; // forname
    end;
  end; // i

  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If (FRec.FormName = 'T2121') and (FRec.FormInst > '') then
    begin
      If Ret[RetNo].FormHasData[FRec.FormName + FRec.FormInst] then // 20160813
      begin
        Inc(SfdNo);
        ClearPartnersInfo;
        XmlList.add(Space(Indent3) + '<sfd:SelectedFinancialData>');
        XmlList.add(Space(Indent3) + '<sfd:FishingActivityData>');
        BuildFishing(RetNo, FRec.FormInst);
        XmlList.add(Space(Indent3) + '</sfd:FishingActivityData>');
        XmlList.add(Space(Indent3) + '</sfd:SelectedFinancialData>');
      end;
    end;
  end; // i

  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If (FRec.FormName = 'T2042') and (FRec.FormInst > '') then
    begin
      If Ret[RetNo].FormHasData[FRec.FormName + FRec.FormInst] then // 20160813
      begin
        Inc(SfdNo);
        ClearPartnersInfo;
        XmlList.add(Space(Indent3) + '<sfd:SelectedFinancialData>');
        XmlList.add(Space(Indent3) + '<sfd:FarmingActivityData>');
        BuildFarming(RetNo, FRec.FormInst);
        XmlList.add(Space(Indent3) + '</sfd:FarmingActivityData>');
        XmlList.add(Space(Indent3) + '</sfd:SelectedFinancialData>');
      end;
    end;
  end;

  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If (FRec.FormName = 'T1163') and (FRec.FormInst > '') then
    begin
      If Ret[RetNo].FormHasData[FRec.FormName + FRec.FormInst] then // 20160813
      begin
        Inc(SfdNo);
        ClearPartnersInfo;
        XmlList.add(Space(Indent3) + '<sfd:SelectedFinancialData>');
        XmlList.add(Space(Indent3) +
          '<sfd:AgriStabilityAgriInvestProgramFarmingData>');
        BuildT1163(RetNo, FRec.FormInst);
        XmlList.add(Space(Indent3) +
          '</sfd:AgriStabilityAgriInvestProgramFarmingData>');
        XmlList.add(Space(Indent3) + '</sfd:SelectedFinancialData>');
      end;
    end;
  end;

  for i := 0 to (FList.Count - 1) do // 20111229
  begin
    FRec := FList.Items[i];
    If (FRec.FormName = 'T1273') and (FRec.FormInst > '') then
    begin
      If Ret[RetNo].FormHasData[FRec.FormName + FRec.FormInst] then // 20160813
      begin
        Inc(SfdNo);
        ClearPartnersInfo;
        BuildT1273(RetNo, FRec.FormInst);
      end;
    end;
  end;

  //20250110
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If Ret[RetNo].FormHasData[FRec.FormName + FRec.FormInst] then // 20160813
    begin
      // if bankruptcy??
      If (FRec.FormName = 'T776') and (FRec.FormInst > '') then
      begin
        Inc(SfdNo);
        ClearPartnersInfo;
        XmlList.add(Space(Indent3) + '<sfd:SelectedFinancialData>');
        XmlList.add(Space(Indent3) + '<sfd:RealEstateRentalData>');
        BuildRental(RetNo, FRec.FormInst);
        XmlList.add(Space(Indent3) + '</sfd:RealEstateRentalData>');
        XmlList.add(Space(Indent3) + '</sfd:SelectedFinancialData>');
      end;
    end;
  end;

  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If (FRec.FormName = 'T777') then
    begin
      If Ret[RetNo].FormHasData[FRec.FormName + FRec.FormInst] then // 20160813
      begin
        Inc(SfdNo);
        ClearPartnersInfo;
        XmlList.add(Space(Indent3) + '<sfd:SelectedFinancialData>');
        XmlList.add(Space(Indent3) + '<sfd:EmploymentExpenseData>');
        BuildT777(RetNo, FRec.FormInst);
        XmlList.add(Space(Indent3) + '</sfd:EmploymentExpenseData>');
        XmlList.add(Space(Indent3) + '</sfd:SelectedFinancialData>');
      end;
    end;
  end;

  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If (FRec.FormName = 'TL2') and (FRec.FormInst > '') then
    begin
      If Ret[RetNo].FormHasData[FRec.FormName + FRec.FormInst] then // 20160813
      begin
        Inc(SfdNo);
        ClearPartnersInfo;
        XmlList.add(Space(Indent3) + '<sfd:SelectedFinancialData>');
        XmlList.add(Space(Indent3) + '<sfd:MealLodgingExpenseData>');
        BuildTL2(RetNo, FRec.FormInst);
        XmlList.add(Space(Indent3) + '</sfd:MealLodgingExpenseData>');
        XmlList.add(Space(Indent3) + '</sfd:SelectedFinancialData>');
      end;
    end;
  end;

  // t2091    //20180115
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If (FRec.FormName = 'T2091') and (FRec.FormInst > '') then
    begin
      If Ret[RetNo].FormHasData[FRec.FormName + FRec.FormInst] then // 20160813
      begin
        Inc(SfdNo);
        ClearPartnersInfo;
        XmlList.add(Space(Indent3) + '<sfd:SelectedFinancialData>');
        XmlList.add(Space(Indent3) +
          '<sfd:DesignationPropertyPrincipalResidenceData>');
        BuildT2091(RetNo, FRec.FormInst);

        XmlList.add(Space(Indent3) +
          '</sfd:DesignationPropertyPrincipalResidenceData>');
        XmlList.add(Space(Indent3) + '</sfd:SelectedFinancialData>');
      end;
    end;
  end;

  // t1255  //20180304
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If (FRec.FormName = 'T1255') and (FRec.FormInst > '') then
    begin
      If Ret[RetNo].FormHasData[FRec.FormName + FRec.FormInst] then // 20160813
      begin
        Inc(SfdNo);
        ClearPartnersInfo;
        XmlList.add(Space(Indent3) + '<sfd:SelectedFinancialData>');
        XmlList.add(Space(Indent3) +
          '<sfd:DesignationPropertyPrincipalResidenceData>');
        BuildT1255(RetNo, FRec.FormInst); // 20180304

        XmlList.add(Space(Indent3) +
          '</sfd:DesignationPropertyPrincipalResidenceData>');
        XmlList.add(Space(Indent3) + '</sfd:SelectedFinancialData>');
      end;
    end;
  end;

  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    {
      If (FRec.FormName = 'T777S') then
      begin
      If Ret[RetNo].FormHasData[FRec.FormName + FRec.FormInst] then // 20160813
      begin
      Inc(SfdNo);
      ClearPartnersInfo;
      XmlList.add(Space(Indent3) + '<sfd:SelectedFinancialData>');
      XmlList.add(Space(Indent3) + '<sfd:EmploymentExpenseCovidData>');
      // 20221228
      BuildT777S(RetNo, FRec.FormInst);
      XmlList.add(Space(Indent3) + '</sfd:EmploymentExpenseCovidData>');
      // 20221228
      XmlList.add(Space(Indent3) + '</sfd:SelectedFinancialData>');
      end;
      end;
    }
  end;

end;

Procedure ClearPartnersInfo;
Var
  i: Integer;
Begin
  For i := 1 to 6 do
  begin
    SFD.PRec[i].PFirstName := '';
    SFD.PRec[i].PLastName := '';
    SFD.PRec[i].PSin := '';
    SFD.PRec[i].PPerCent := '';
  end;
end;

Procedure BuildRental(RetNo: Integer; FInst: String);
Var
  i, LLine, ElmNo, Rule: Integer;
  LType: string[1];
  FName: string[12];
  S: string;
begin
  If IsPreBankruptcyReturn(RetNo) then
    exit;
  SFD.RECTYPE := '03';
  SFD.PREPARERNO := Fx.PREPARERNO;
  SFD.SEQNO := Fx.SEQNO;
  SfdRecNumber := SfdRecNumber + 1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber), 2);
  SFD.BUSTYPE := '1';
  SFD.BUSNAME := FetchElm(RetNo, 'T776' + FInst, 109); // 20120302

  SFD.BUSADDRESS := FetchElm(RetNo, 'T776' + FInst, 110);
  // ReplaceReservedXMLCharacters(FetchElm(RetNo,'T776'+FInst,110));
  SFD.BUSPOSTAL := MTrim(FetchElm(RetNo, 'T776' + FInst, 111));
  SFD.BUSFISCSTART := FetchElm(RetNo, 'T776' + FInst, 3);
  // RemoveHyphens(FetchElm(RetNo,'T776'+FInst,3));  //20111206
  SFD.BUSFISCEND := FetchElm(RetNo, 'T776' + FInst, 6);
  // RemoveHyphens(FetchElm(RetNo,'T776'+FInst,6));   //20111206
  SFD.ACROWNED := '';
  SFD.ACRFARMED := '';

  If AllTrim(FetchElm(RetNo, 'T776' + FInst, 4)) > '' THEN
    SFD.ACCMETHOD := '1' // accrual
  ELSE
    SFD.ACCMETHOD := '2';
  SFD.SIC := FetchElm(RetNo, 'T776' + FInst, 19);
  SFD.SIN := RemoveHyphens(FetchElm(RetNo, 'INFO', 3));
  SFD.BUSPARTNID := FetchElm(RetNo, 'T776' + FInst, 11);
  SFD.BUSPERCENT := FormatFourDigitPercent(FetchElm(RetNo, 'T776' + FInst, 18));
  SFD.BUSTAXSHELTNO := FetchElm(RetNo, 'T776' + FInst, 13);
  If AllTrim(FetchElm(RetNo, 'T776' + FInst, 9)) > '' THEN
    SFD.BUSFINALYR := '1'
  ELSE
    SFD.BUSFINALYR := '2';

  SFD.GSTACCNO := FetchElm(RetNo, 'T776' + FInst, 15);

  // 20230204 used FormatFourDigitPercent
  // jz //20230206 actually needs new FormatSixDigitPercent as per specs
  i := 0;
  If Vl(FetchElm(RetNo, 'T776' + FInst, 24)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T776' + FInst, 22), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T776' + FInst, 117), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T776'+FInst,117),30));
    SFD.PRec[i].PPerCent := FormatSixDigitPercent
      (FetchElm(RetNo, 'T776' + FInst, 24));
    // FormatBusPercent(FetchElm(RetNo,'T776'+FInst,24));
  end;
  If Vl(FetchElm(RetNo, 'T776' + FInst, 28)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T776' + FInst, 25), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T776' + FInst, 26), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T776'+FInst,26),30));
    SFD.PRec[i].PPerCent := FormatSixDigitPercent
      (FetchElm(RetNo, 'T776' + FInst, 28));
  end;
  If Vl(FetchElm(RetNo, 'T776' + FInst, 32)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T776' + FInst, 29), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T776' + FInst, 30), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T776'+FInst,30),30));
    SFD.PRec[i].PPerCent := FormatSixDigitPercent
      (FetchElm(RetNo, 'T776' + FInst, 32));
  end;
  If Vl(FetchElm(RetNo, 'T776' + FInst, 36)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T776' + FInst, 33), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T776' + FInst, 34), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T776'+FInst,34),30));
    SFD.PRec[i].PPerCent := FormatSixDigitPercent
      (FetchElm(RetNo, 'T776' + FInst, 36));
  end;
  If Vl(FetchElm(RetNo, 'T776' + FInst, 40)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T776' + FInst, 37), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T776' + FInst, 38), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T776'+FInst,38),30));
    SFD.PRec[i].PPerCent := FormatSixDigitPercent
      (FetchElm(RetNo, 'T776' + FInst, 40));
  end;
  EFlines := TStringList.Create;
  EFlines.LoadFromFile(AppDir + '\' + 'EFRLINE.D');

  { ---- }

  If AllTrim(SFD.GSTACCNO) > '' then
    XmlList.add(Space(Indent4) + '<sfd:BusinessNumber>' + SFD.GSTACCNO +
      '</sfd:BusinessNumber>');
  XmlList.add(Space(Indent4) + '<sfd:NAICSCode>' + SFD.SIC +
    '</sfd:NAICSCode>');
  XmlList.add(Space(Indent4) + '<sfd:FiscalPeriodStartDate>' + SFD.BUSFISCSTART
    + '</sfd:FiscalPeriodStartDate>');
  XmlList.add(Space(Indent4) + '<sfd:FiscalPeriodEndDate>' + SFD.BUSFISCEND +
    '</sfd:FiscalPeriodEndDate>');
  If (AllTrim(SFD.BUSPARTNID) > '') then
    XmlList.add(Space(Indent4) + '<sfd:PartnershipNumber>' + SFD.BUSPARTNID +
      '</sfd:PartnershipNumber>');
  If (AllTrim(SFD.BUSTAXSHELTNO) > '') then
    XmlList.add(Space(Indent4) + '<sfd:TaxShelterNumber>' + SFD.BUSTAXSHELTNO +
      '</sfd:TaxShelterNumber>');

  If AllTrim(AllTrim(SFD.BUSADDRESS) + AllTrim(SFD.BUSPOSTAL)) > '' then
  begin
    XmlList.add(Space(Indent4) + '<sfd:BusinessAddress>');
    XmlList.add(Space(Indent4) + '<comm:BusinessAddressStreetText>' +
      ReplaceReservedXMLCharacters(AllTrim(SFD.BUSADDRESS)) +
      '</comm:BusinessAddressStreetText>');
    XmlList.add(Space(Indent4) + '<comm:AddressPostalCode>' +
      AllTrim(SFD.BUSPOSTAL) + '</comm:AddressPostalCode>');
    XmlList.add(Space(Indent4) + '</sfd:BusinessAddress>');
  end;

  If SFD.BUSPERCENT <> '0000' then
    XmlList.add(Space(Indent4) + '<sfd:BusinessOwnershipPercent>' +
      SFD.BUSPERCENT + '</sfd:BusinessOwnershipPercent>');
  If SFD.BUSFINALYR = '1' then
    XmlList.add(Space(Indent4) + '<sfd:FinalBusinessYearIndicator>' +
      SFD.BUSFINALYR + '</sfd:FinalBusinessYearIndicator>');

  If UpperCase(FetchElm(RetNo, 'T776' + FInst, 113)) <> 'Y' then // 20111213
    BuildPartners(RetNo);

  { Free format SFD }
  For i := 0 to EFlines.Count - 1 do
  begin
    LLine := myStrToInt(LeftStr(EFlines[i], 4));
    LType := MidStr(EFlines[i], 6, 1);
    FName := AllTrim(MidStr(EFlines[i], 8, 9)) + FInst;
    ElmNo := myStrToInt(MidStr(EFlines[i], 17, 3));
    If MidStr(EFlines[i], 22, 3) = '' then
      Rule := 0
    else
      Rule := myStrToInt(MidStr(EFlines[i], 22, 3));

    S := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
    // 20210419
    if LLine = 56120 then // 20200404
    Begin
      // 20210421
      // 20210102
      If IsMultJurisdiction(RetNo) then
      Begin
        If Vl(S) = 1 then
          S := '1';
      End;
    End;

    If LLine = 8299 then // no gross but Net  //20191208
    begin
      If (S = '') and (Vl(FetchElm(RetNo, 'T776' + FInst, 106)) <> 0) then
        S := '1';
    end;

    If LLine = 9946 then
    begin
      If (S = '') and (Vl(FetchElm(RetNo, 'T776' + FInst, 56)) <> 0) then
        S := '1';
    end;
    If S > '' then
      BuildLineValues(RetNo, AllTrim(IntToStr(LLine)), S);
  end;
  EFlines.Free;
end;

Procedure BuildBusiness(RetNo: Integer; FInst: String);
Var
  i, LLine, ElmNo, Rule, FNo: Integer;
  LType: string[1];
  FName: string[12];
  S: string;
begin
  If IsPreBankruptcyReturn(RetNo) then
    exit;

  SFD.RECTYPE := '03';
  SFD.PREPARERNO := Fx.PREPARERNO;
  SFD.SEQNO := Fx.SEQNO;
  SfdRecNumber := SfdRecNumber + 1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber), 2);
  If FetchElm(RetNo, 'T2125' + FInst, 82) > '' then
    SFD.BUSTYPE := '2'
  else If FetchElm(RetNo, 'T2125' + FInst, 90) > '' then
    SFD.BUSTYPE := '3';

  SFD.BUSNAME := ReplaceReservedXMLCharacters(FetchElm(RetNo, 'T2125' + FInst, 8)); // 20250219
  If AllTrim(SFD.BUSNAME) = '' then
    SFD.BUSNAME := GetFirstName(RetNo) + ' ' + GetLastName(RetNo);

  // 20180118
  SFD.BUSADDRESS := FetchElm(RetNo, 'T2125' + FInst, 10); // 20190325
  // +','+FetchElm(RetNo,'T2125'+FInst,13)+','+FetchElm(RetNo,'T2125'+FInst,53); //20180404
  // ReplaceReservedXMLCharacters(FetchElm(RetNo,'T2125'+FInst,10));
  // If AllTrim(SFD.BUSPOSTAL)>'' then       //20240206
  SFD.BUSPOSTAL := MTrim(FetchElm(RetNo, 'T2125' + FInst, 14));

  SFD.BUSFISCSTART := FetchElm(RetNo, 'T2125' + FInst, 4);
  // RemoveHyphens(FetchElm(RetNo,'T2125'+FInst,4));
  SFD.BUSFISCEND := FetchElm(RetNo, 'T2125' + FInst, 5);
  // RemoveHyphens(FetchElm(RetNo,'T2125'+FInst,5));
  SFD.ACROWNED := '';
  SFD.ACRFARMED := '';

  // 20190201
  SFD.ACCMETHOD := '1'; // accrual be default
  If AllTrim(FetchElm(RetNo, 'T2125' + FInst, 22)) > '' THEN
    SFD.ACCMETHOD := '2';
  {
    If AllTrim(FetchElm(RetNo,'T2125'+FInst,11))>'' THEN
    SFD.AccMethod:='1'   //accroual
    ELSE
    SFD.AccMethod:='2';  //cash
  }
  SFD.SIC := FetchElm(RetNo, 'T2125' + FInst, 12);
  SFD.SIN := RemoveHyphens(FetchElm(RetNo, 'INFO', 3));
  SFD.BUSPARTNID := FetchElm(RetNo, 'T2125' + FInst, 15);
  SFD.BUSPERCENT := FormatFourDigitPercent
    (FetchElm(RetNo, 'T2125' + FInst, 18));
  SFD.BUSTAXSHELTNO := FetchElm(RetNo, 'T2125' + FInst, 16);
  If AllTrim(FetchElm(RetNo, 'T2125' + FInst, 6)) > '' THEN
    SFD.BUSFINALYR := '1'
  ELSE
    SFD.BUSFINALYR := ' ';

  SFD.GSTACCNO := FetchElm(RetNo, 'T2125' + FInst, 19);

  i := 0;
  If Vl(FetchElm(RetNo, 'T2125' + FInst, 238)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2125' + FInst, 257), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2125' + FInst, 239), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T2125'+FInst,239),30));
    SFD.PRec[i].PSin := ''; // 00000000'; //20180101
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2125' + FInst, 238));
  end;
  If Vl(FetchElm(RetNo, 'T2125' + FInst, 241)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2125' + FInst, 258), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2125' + FInst, 248), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T2125'+FInst,248),30));
    SFD.PRec[i].PSin := ''; // '00000000';  //20180101
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2125' + FInst, 241));
  end;
  If Vl(FetchElm(RetNo, 'T2125' + FInst, 244)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2125' + FInst, 259), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2125' + FInst, 264), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T2125'+FInst,264),30));
    SFD.PRec[i].PSin := ''; // 00000000';  //20180101
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2125' + FInst, 244));
  end;
  If Vl(FetchElm(RetNo, 'T2125' + FInst, 247)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2125' + FInst, 260), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2125' + FInst, 267), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T2125'+FInst,267),30));
    SFD.PRec[i].PSin := ''; // 00000000';   //20180101
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2125' + FInst, 247));
  end;
  If Vl(FetchElm(RetNo, 'T2125' + FInst, 250)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2125' + FInst, 261), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2125' + FInst, 270), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T2125'+FInst,270),30));
    SFD.PRec[i].PSin := ''; // 20180101 00000000';
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2125' + FInst, 250));
  end;
  EFlines := TStringList.Create;
  EFlines.LoadFromFile(AppDir + '\' + 'EFBLINE.D');

  If (AllTrim(SFD.ACCMETHOD) > '') then
    XmlList.add(Space(Indent4) + '<sfd:AccountingMethodCode>' + SFD.ACCMETHOD +
      '</sfd:AccountingMethodCode>');
  If AllTrim(SFD.GSTACCNO) > '' then
    XmlList.add(Space(Indent4) + '<sfd:BusinessNumber>' + SFD.GSTACCNO +
      '</sfd:BusinessNumber>');
  XmlList.add(Space(Indent4) + '<sfd:NAICSCode>' + SFD.SIC +
    '</sfd:NAICSCode>');
  If AllTrim(SFD.BUSNAME) > '' then
    XmlList.add(Space(Indent4) + '<sfd:BusinessName>' +
      AllTrim(SFD.BUSNAME) + //jz//20250312 ReplaceReservedXMLCharacters is done above when populating SFD.BUSNAME
      '</sfd:BusinessName>');
  If (AllTrim(SFD.BUSPARTNID) > '') then
    XmlList.add(Space(Indent4) + '<sfd:PartnershipNumber>' + SFD.BUSPARTNID +
      '</sfd:PartnershipNumber>');
  If (AllTrim(SFD.BUSTAXSHELTNO) > '') then
    XmlList.add(Space(Indent4) + '<sfd:TaxShelterNumber>' + SFD.BUSTAXSHELTNO +
      '</sfd:TaxShelterNumber>');

  If AllTrim(AllTrim(SFD.BUSADDRESS) + AllTrim(SFD.BUSPOSTAL)) > '' then
  begin
    XmlList.add(Space(Indent4) + '<sfd:BusinessAddress>');
    XmlList.add(Space(Indent4) + '<comm:BusinessAddressStreetText>' +
      ReplaceReservedXMLCharacters(AllTrim(SFD.BUSADDRESS)) +
      '</comm:BusinessAddressStreetText>');
    XmlList.add(Space(Indent4) + '<comm:AddressPostalCode>' +
      AllTrim(SFD.BUSPOSTAL) + '</comm:AddressPostalCode>');
    XmlList.add(Space(Indent4) + '</sfd:BusinessAddress>');
  end;
  XmlList.add(Space(Indent4) + '<sfd:FiscalPeriodStartDate>' + SFD.BUSFISCSTART
    + '</sfd:FiscalPeriodStartDate>');
  XmlList.add(Space(Indent4) + '<sfd:FiscalPeriodEndDate>' + SFD.BUSFISCEND +
    '</sfd:FiscalPeriodEndDate>');
  If SFD.BUSPERCENT <> '0000' then
    XmlList.add(Space(Indent4) + '<sfd:BusinessOwnershipPercent>' +
      SFD.BUSPERCENT + '</sfd:BusinessOwnershipPercent>');
  If SFD.BUSFINALYR = '1' then // 202230204
    XmlList.add(Space(Indent4) + '<sfd:FinalBusinessYearIndicator>' +
      SFD.BUSFINALYR + '</sfd:FinalBusinessYearIndicator>');

  If UpperCase(FetchElm(RetNo, 'T2125' + FInst, 35)) <> 'Y' then // 20111213
    BuildPartners(RetNo);

  FNo := GetFormNo('T2125' + FInst); // 20131218
  If FNo > 0 then
  Begin
    If Vl(FetchElm(RetNo, 'T2125' + FInst, 49)) > 0 then
    begin
      XmlList.add(Space(Indent4) + '<sfd:IncomeEarnedWebPageCount>' +
        IntToStr(myStrToInt(FetchElmFNo(RetNo, FNo, 49))) +
        '</sfd:IncomeEarnedWebPageCount>');
      If FetchElmFNo(RetNo, FNo, 25) > '' then
        XmlList.add(Space(Indent4) + '<sfd:WebPageAddressText>' +
          FetchElmFNo(RetNo, FNo, 25) + '</sfd:WebPageAddressText>');
      If FetchElmFNo(RetNo, FNo, 27) > '' then
        XmlList.add(Space(Indent4) + '<sfd:WebPageAddressText>' +
          FetchElmFNo(RetNo, FNo, 27) + '</sfd:WebPageAddressText>');
      If FetchElmFNo(RetNo, FNo, 47) > '' then
        XmlList.add(Space(Indent4) + '<sfd:WebPageAddressText>' +
          FetchElmFNo(RetNo, FNo, 47) + '</sfd:WebPageAddressText>');
      If FetchElmFNo(RetNo, FNo, 48) > '' then
        XmlList.add(Space(Indent4) + '<sfd:WebPageAddressText>' +
          FetchElmFNo(RetNo, FNo, 48) + '</sfd:WebPageAddressText>');
      If FetchElmFNo(RetNo, FNo, 50) > '' then
        XmlList.add(Space(Indent4) + '<sfd:WebPageAddressText>' +
          FetchElmFNo(RetNo, FNo, 50) + '</sfd:WebPageAddressText>');
      XmlList.add(Space(Indent4) + '<sfd:InternetGrossIncomePercentage>' +
        FormatFloat('000', Vl(FetchElmFNo(RetNo, FNo, 51))) +
        '</sfd:InternetGrossIncomePercentage>');
    end;
  end;
  { Free format SFD }
  For i := 0 to EFlines.Count - 1 do
  begin
    LLine := myStrToInt(LeftStr(EFlines[i], 4));
    LType := MidStr(EFlines[i], 6, 1);
    FName := AllTrim(MidStr(EFlines[i], 8, 9)) + FInst;
    ElmNo := myStrToInt(MidStr(EFlines[i], 17, 3));
    If MidStr(EFlines[i], 22, 3) = '' then
      Rule := 0
    else
      Rule := myStrToInt(MidStr(EFlines[i], 22, 3));

    S := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);

    // 20210419
    if LLine = 56120 then // 20200404
    Begin
      // 20200102
      If IsMultJurisdiction(RetNo) then
      Begin
        If S = '1.00' then
        begin
          S := '1';
          LType := 'N';
        end;
      End;
    End;

    If LLine = 9946 then
    begin
      If (S = '') and (Vl(FetchElm(RetNo, 'T2125' + FInst, 32)) <> 0) then
        S := '1';
    end;
    If LLine = 9369 then
    begin
      If (S = '') and (Vl(FetchElm(RetNo, 'T2125' + FInst, 32)) <> 0) and
        (FetchElm(RetNo, 'T2125' + FInst, 35) = '') // no t5013
      then
        S := '1';
    end;
    If S > '' then
      BuildLineValues(RetNo, AllTrim(IntToStr(LLine)), S);
  end;
  EFlines.Free;
end;

Procedure BuildFarming(RetNo: Integer; FInst: String);
Var
  i, LLine, ElmNo, Rule, FNo: Integer;
  LType: string[1];
  FName: string[12];
  S: string;
begin
  If IsPreBankruptcyReturn(RetNo) then
    exit;
  SFD.RECTYPE := '03';
  SFD.PREPARERNO := Fx.PREPARERNO;
  SFD.SEQNO := Fx.SEQNO;
  SfdRecNumber := SfdRecNumber + 1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber), 2);
  SFD.BUSTYPE := '5';
  SFD.BUSNAME := FetchElm(RetNo, 'T2042' + FInst, 8); // 20240205
  If AllTrim(SFD.BUSNAME) = '' then
    SFD.BUSNAME := GetFirstName(RetNo) + ' ' + GetLastName(RetNo);

  SFD.BUSADDRESS := FetchElm(RetNo, 'T2042' + FInst, 10); // 20190325
  // +','+FetchElm(RetNo,'T2042'+FInst,12)+','+FetchElm(RetNo,'T2042'+FInst,71);  //20180404
  if AllTrim(SFD.BUSADDRESS) = ',,' then
    SFD.BUSADDRESS := ''; // 20181208

  // ReplaceReservedXMLCharacters(FetchElm(RetNo,'T2042'+FInst,10));
  SFD.BUSPOSTAL := MTrim(FetchElm(RetNo, 'T2042' + FInst, 13));
  SFD.BUSFISCSTART := FetchElm(RetNo, 'T2042' + FInst, 4);
  SFD.BUSFISCEND := FetchElm(RetNo, 'T2042' + FInst, 5);
  SFD.ACROWNED := FetchElm(RetNo, 'T2042' + FInst, 9);
  SFD.ACRFARMED := FetchElm(RetNo, 'T2042' + FInst, 11);
  If AllTrim(FetchElm(RetNo, 'T2042' + FInst, 15)) > '' THEN
    SFD.ACCMETHOD := '1'
  ELSE
    SFD.ACCMETHOD := '2';
  SFD.SIC := FetchElm(RetNo, 'T2042' + FInst, 17);
  SFD.SIN := RemoveHyphens(FetchElm(RetNo, 'INFO', 3));
  SFD.BUSPARTNID := FetchElm(RetNo, 'T2042' + FInst, 18);
  SFD.BUSPERCENT := FormatFourDigitPercent
    (FetchElm(RetNo, 'T2042' + FInst, 24));
  SFD.BUSTAXSHELTNO := FetchElm(RetNo, 'T2042' + FInst, 20);
  If AllTrim(FetchElm(RetNo, 'T2042' + FInst, 6)) > '' THEN
    SFD.BUSFINALYR := '1'
  ELSE
    SFD.BUSFINALYR := '2';
  SFD.GSTACCNO := FetchElm(RetNo, 'T2042' + FInst, 21);

  i := 0;
  If Vl(FetchElm(RetNo, 'T2042' + FInst, 642)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2042' + FInst, 640), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2042' + FInst, 664), 30);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2042' + FInst, 642));
  end;

  If Vl(FetchElm(RetNo, 'T2042' + FInst, 646)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2042' + FInst, 644), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2042' + FInst, 666), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T2042'+FInst,666),30));
    // SFD.PRec[i].PSin       := '00000000';
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2042' + FInst, 646));
  end;

  If Vl(FetchElm(RetNo, 'T2042' + FInst, 650)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2042' + FInst, 648), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2042' + FInst, 668), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T2042'+FInst,668),30));
    // SFD.PRec[i].PSin       := '00000000';
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2042' + FInst, 650));
  end;

  If Vl(FetchElm(RetNo, 'T2042' + FInst, 654)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2042' + FInst, 652), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2042' + FInst, 670), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T2042'+FInst,670),30));
    // SFD.PRec[i].PSin       := '00000000';
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2042' + FInst, 654));
  end;

  If Vl(FetchElm(RetNo, 'T2042' + FInst, 658)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2042' + FInst, 656), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2042' + FInst, 672), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T2042'+FInst,672),30));
    // SFD.PRec[i].PSin       := '00000000';
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2042' + FInst, 658));
  end;

  EFlines := TStringList.Create;
  EFlines.LoadFromFile(AppDir + '\' + 'EFFLINE.D');

  XmlList.add(Space(Indent4) + '<sfd:AccountingMethodCode>' + SFD.ACCMETHOD +
    '</sfd:AccountingMethodCode>');
  If AllTrim(SFD.GSTACCNO) > '' then
    XmlList.add(Space(Indent4) + '<sfd:BusinessNumber>' + SFD.GSTACCNO +
      '</sfd:BusinessNumber>');
  XmlList.add(Space(Indent4) + '<sfd:NAICSCode>' + SFD.SIC +
    '</sfd:NAICSCode>');
  If AllTrim(SFD.BUSNAME) > '' then
    XmlList.add(Space(Indent4) + '<sfd:FarmName>' + ReplaceReservedXMLCharacters
      (AllTrim(SFD.BUSNAME)) + '</sfd:FarmName>');
  If (AllTrim(SFD.BUSPARTNID) > '') then
    XmlList.add(Space(Indent4) + '<sfd:PartnershipNumber>' + SFD.BUSPARTNID +
      '</sfd:PartnershipNumber>');
  If (AllTrim(SFD.BUSTAXSHELTNO) > '') then
    XmlList.add(Space(Indent4) + '<sfd:TaxShelterNumber>' + SFD.BUSTAXSHELTNO +
      '</sfd:TaxShelterNumber>'); // 20141216
  If AllTrim(AllTrim(SFD.BUSADDRESS) + AllTrim(SFD.BUSPOSTAL)) > '' then
  begin
    XmlList.add(Space(Indent4) + '<sfd:FarmAddress>');
    If SFD.BUSADDRESS > '' then
      XmlList.add(Space(Indent4) + '<comm:BusinessAddressStreetText>' +
        ReplaceReservedXMLCharacters(AllTrim(SFD.BUSADDRESS)) +
        '</comm:BusinessAddressStreetText>'); // 20181208
    XmlList.add(Space(Indent4) + '<comm:AddressPostalCode>' +
      AllTrim(SFD.BUSPOSTAL) + '</comm:AddressPostalCode>');
    XmlList.add(Space(Indent4) + '</sfd:FarmAddress>');
  end;
  XmlList.add(Space(Indent4) + '<sfd:FiscalPeriodStartDate>' + SFD.BUSFISCSTART
    + '</sfd:FiscalPeriodStartDate>');
  XmlList.add(Space(Indent4) + '<sfd:FiscalPeriodEndDate>' + SFD.BUSFISCEND +
    '</sfd:FiscalPeriodEndDate>');
  If SFD.BUSPERCENT <> '0000' then
    XmlList.add(Space(Indent4) + '<sfd:BusinessOwnershipPercent>' +
      SFD.BUSPERCENT + '</sfd:BusinessOwnershipPercent>');
  If SFD.BUSFINALYR = '1' then
    XmlList.add(Space(Indent4) + '<sfd:FinalBusinessYearIndicator>' +
      SFD.BUSFINALYR + '</sfd:FinalBusinessYearIndicator>');

  If UpperCase(FetchElm(RetNo, 'T2042' + FInst, 68)) <> 'Y' then // 20111213
    BuildPartners(RetNo);

  FNo := GetFormNo('T2042' + FInst); // 20131226
  If FNo > 0 then
  Begin
    If Vl(FetchElm(RetNo, 'T2042' + FInst, 63)) > 0 then
    begin
      XmlList.add(Space(Indent4) + '<sfd:IncomeEarnedWebPageCount>' +
        IntToStr(myStrToInt(FetchElmFNo(RetNo, FNo, 63))) +
        '</sfd:IncomeEarnedWebPageCount>');
      If FetchElmFNo(RetNo, FNo, 25) > '' then
        XmlList.add(Space(Indent4) + '<sfd:WebPageAddressText>' +
          FetchElmFNo(RetNo, FNo, 25) + '</sfd:WebPageAddressText>');
      If FetchElmFNo(RetNo, FNo, 11) > '' then
        XmlList.add(Space(Indent4) + '<sfd:WebPageAddressText>' +
          FetchElmFNo(RetNo, FNo, 11) + '</sfd:WebPageAddressText>');
      If FetchElmFNo(RetNo, FNo, 34) > '' then
        XmlList.add(Space(Indent4) + '<sfd:WebPageAddressText>' +
          FetchElmFNo(RetNo, FNo, 34) + '</sfd:WebPageAddressText>');
      If FetchElmFNo(RetNo, FNo, 35) > '' then
        XmlList.add(Space(Indent4) + '<sfd:WebPageAddressText>' +
          FetchElmFNo(RetNo, FNo, 35) + '</sfd:WebPageAddressText>');
      If FetchElmFNo(RetNo, FNo, 69) > '' then
        XmlList.add(Space(Indent4) + '<sfd:WebPageAddressText>' +
          FetchElmFNo(RetNo, FNo, 69) + '</sfd:WebPageAddressText>');
      XmlList.add(Space(Indent4) + '<sfd:InternetGrossIncomePercentage>' +
        FormatFloat('000', Vl(FetchElmFNo(RetNo, FNo, 70))) +
        '</sfd:InternetGrossIncomePercentage>');
    end;
  end;

  { Free format SFD }
  For i := 0 to EFlines.Count - 1 do
  begin
    LLine := myStrToInt(LeftStr(EFlines[i], 4));
    LType := MidStr(EFlines[i], 6, 1);
    FName := AllTrim(MidStr(EFlines[i], 8, 9)) + FInst;
    ElmNo := myStrToInt(MidStr(EFlines[i], 17, 3));
    If MidStr(EFlines[i], 22, 3) = '' then
      Rule := 0
    else
      Rule := myStrToInt(MidStr(EFlines[i], 22, 3));

    S := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
    If LLine = 9946 then
    begin
      If (S = '') and (Vl(FetchElm(RetNo, 'T2042' + FInst, 66)) <> 0) then
        S := '1';
    end;

    If LLine = 9899 then
    begin
      If (S = '') and (Vl(FetchElm(RetNo, 'T2042' + FInst, 66)) <> 0) and
        (Vl(FetchElm(RetNo, 'T2042' + FInst, 148)) = 0) then
        S := '1';
    end;

    If LLine = 9946 then { restricted farm loss }
    begin
      If (S > '') and (Vl(FetchElm(RetNo, 'T2042' + FInst, 150)) <> 0) then
      begin
        S := AllTrim(IntToStr(Round(Vl(FetchElm(RetNo, 'T2042' + FInst,
          149)))));
      end;
    end;

    If S > '' then
      BuildLineValues(RetNo, AllTrim(IntToStr(LLine)), S);
  end;
  EFlines.Free;
end;

Procedure BuildT1163(RetNo: Integer; FInst: String);
Var
  i, LLine, ElmNo, Rule, FNo: Integer;
  LType: string[1];
  FName: string[12];
  S: string;
  cd: String;
  Rec: String; // cd to string no [1]
begin
  If IsPreBankruptcyReturn(RetNo) then
    exit;
  SFD.RECTYPE := '03';
  SFD.PREPARERNO := Fx.PREPARERNO;
  SFD.SEQNO := Fx.SEQNO;
  SfdRecNumber := SfdRecNumber + 1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber), 2);
  SFD.BUSTYPE := '6'; // done
  SFD.BUSNAME := FetchElm(RetNo, 'T1163' + FInst, 201); // 20120203
  SFD.BusinessNumber := FetchElm(RetNo, 'T1163' + FInst, 3); // 20181127

   //jz 20250121 only address as per cert12Agri cert
  SFD.BUSADDRESS := LeftStr(FetchElm(RetNo, 'T1163' + FInst, 203), 30);

  {
  SFD.BUSADDRESS := LeftStr(FetchElm(RetNo, 'T1163' + FInst, 203) + ',' +
    FetchElm(RetNo, 'T1163' + FInst, 204) + ',' + FetchElm(RetNo,
    'T1163' + FInst, 205), 30);
  // ReplaceReservedXMLCharacters(LeftStr(FetchElm(RetNo,'T1163'+FInst,203)+','+FetchElm(RetNo,'T1163'+FInst,204)+','+FetchElm(RetNo,'T1163'+FInst,205),30));
  }

  SFD.BUSPOSTAL := MTrim(FetchElm(RetNo, 'T1163' + FInst, 206));
  SFD.BUSFISCSTART := FetchElm(RetNo, 'T1163' + FInst, 213);
  SFD.BUSFISCEND := FetchElm(RetNo, 'T1163' + FInst, 214);
  SFD.ACROWNED := FetchElm(RetNo, 'T1163' + FInst, 217);
  SFD.ACRFARMED := FetchElm(RetNo, 'T1163' + FInst, 219);
  SFD.FarmStead := FetchElm(RetNo, 'T1163' + FInst, 32);
  SFD.ACCMETHOD := AllTrim(FetchElm(RetNo, 'T1163' + FInst, 212));

  SFD.SIC := AllTrim(FetchElm(RetNo, 'T1163' + FInst, 34)); // 20230104
  SFD.BUSPARTNID := FetchElm(RetNo, 'T1163' + FInst, 624);
  SFD.BUSPERCENT := FormatFourDigitPercent
    (FetchElm(RetNo, 'T1163' + FInst, 210));
  If AllTrim(FetchElm(RetNo, 'T1163' + FInst, 27)) > '' THEN
    SFD.BUSFINALYR := '1'
  ELSE
    SFD.BUSFINALYR := ''; // 20240203

  SFD.GSTACCNO := ''; // 20110520

  FNo := GetFormNo('T1163' + FInst);
  i := 0;
  If Vl(FetchElm(RetNo, 'T1163' + FInst, 632)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T1163' + FInst, 630), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T1163' + FInst, 631), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T1163'+FInst,631),30));
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T1163' + FInst, 634), 8);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T1163' + FInst, 632));
  end;

  If Vl(FetchElm(RetNo, 'T1163' + FInst, 637)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T1163' + FInst, 635), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T1163' + FInst, 636), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T1163'+FInst,636),30));
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T1163' + FInst, 639), 8);
    // 20100123
    If FetchElm(RetNo, 'T1163' + FInst, 648) > '' then
    begin
      SFD.PRec[i].PFirstName := '';
      SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T1163' + FInst, 648), 30);
      // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T1163'+FInst,648),30));
    end;
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T1163' + FInst, 637));
  end;

  If Vl(FetchElm(RetNo, 'T1163' + FInst, 642)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T1163' + FInst, 640), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T1163' + FInst, 641), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T1163'+FInst,641),30));
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T1163' + FInst, 644), 8);
    // 20100123
    If FetchElm(RetNo, 'T1163' + FInst, 653) > '' then
    begin
      SFD.PRec[i].PFirstName := '';
      SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T1163' + FInst, 653), 30);
      // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T1163'+FInst,653),30));
    end;
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T1163' + FInst, 642));
  end;

  If Vl(FetchElm(RetNo, 'T1163' + FInst, 647)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T1163' + FInst, 645), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T1163' + FInst, 646), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T1163'+FInst,646),30));
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T1163' + FInst, 649), 8);
    // 20100123
    If FetchElm(RetNo, 'T1163' + FInst, 658) > '' then
    begin
      SFD.PRec[i].PFirstName := '';
      SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T1163' + FInst, 658), 30);
      // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T1163'+FInst,658),30));
    end;
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T1163' + FInst, 647));
  end;

  If Vl(FetchElm(RetNo, 'T1163' + FInst, 652)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T1163' + FInst, 650), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T1163' + FInst, 651), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T1163'+FInst,651),30));
    // 20100123
    If FetchElm(RetNo, 'T1163' + FInst, 660) > '' then
    begin
      SFD.PRec[i].PFirstName := '';
      SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T1163' + FInst, 660), 30);
      // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T1163'+FInst,660),30));
    end;
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T1163' + FInst, 654), 8);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T1163' + FInst, 652));
  end;

  If Vl(FetchElm(RetNo, 'T1163' + FInst, 657)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T1163' + FInst, 655), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T1163' + FInst, 656), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T1163'+FInst,656),30));
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T1163' + FInst, 659), 8);
    // 20100123
    If FetchElm(RetNo, 'T1163' + FInst, 661) > '' then
    begin
      SFD.PRec[i].PFirstName := '';
      SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T1163' + FInst, 661), 30);
      // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T1163'+FInst,661),30));
    end;
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T1163' + FInst, 657));
  end;

  XmlList.add(Space(Indent4) + '<sfd:MainFarmsteadProvinceCode>' + SFD.FarmStead
    + '</sfd:MainFarmsteadProvinceCode>');
  XmlList.add(Space(Indent4) + '<sfd:AccountingMethodCode>' + SFD.ACCMETHOD +
    '</sfd:AccountingMethodCode>');
  XmlList.add(Space(Indent4) + '<sfd:NAICSCode>' + SFD.SIC +
    '</sfd:NAICSCode>');
  XmlList.add(Space(Indent4) + '<sfd:FarmName>' + ReplaceReservedXMLCharacters
    (AllTrim(SFD.BUSNAME)) + '</sfd:FarmName>');
  // 20191127
  If AllTrim(SFD.BusinessNumber) > '' then
    XmlList.add(Space(Indent4) + '<sfd:AgriStabilityAgriInvestBusinessNumber>' +
      AllTrim(SFD.BusinessNumber) +
      '</sfd:AgriStabilityAgriInvestBusinessNumber>');
  If (AllTrim(SFD.BUSPARTNID) > '') then
    XmlList.add(Space(Indent4) + '<sfd:PartnershipNumber>' + SFD.BUSPARTNID +
      '</sfd:PartnershipNumber>');
  If AllTrim(AllTrim(SFD.BUSADDRESS) + AllTrim(SFD.BUSPOSTAL)) > '' then
  begin
    XmlList.add(Space(Indent4) + '<sfd:FarmAddress>');
    XmlList.add(Space(Indent4) + '<comm:BusinessAddressStreetText>' +
      ReplaceReservedXMLCharacters(AllTrim(SFD.BUSADDRESS)) +
      '</comm:BusinessAddressStreetText>');
    XmlList.add(Space(Indent4) + '<comm:AddressPostalCode>' +
      AllTrim(SFD.BUSPOSTAL) + '</comm:AddressPostalCode>');
    XmlList.add(Space(Indent4) + '</sfd:FarmAddress>');
  end;

  // 20230125  Cell phone
  If (AllTrim(FetchElm(RetNo, 'T1163' + FInst, 38)) > '') // area
    and (AllTrim(FetchElm(RetNo, 'T1163' + FInst, 30)) > '') // cell no
  then // 20230115
  Begin
    XmlList.add(Space(Indent4) + '<sfd:ClientCellPhoneNumber>');
    // If FetchElm(RetNo,'T1163'+FInst,38)>'' then //area
    XmlList.add(Space(Indent4) + '<comm:TelephoneAreaCode>' + FetchElm(RetNo,
      'T1163' + FInst, 38) + '</comm:TelephoneAreaCode>');
    XmlList.add(Space(Indent4) + '<comm:TelephoneLocalNumber>' +
      Removechar(FetchElm(RetNo, 'T1163' + FInst, 30), '-') +
      '</comm:TelephoneLocalNumber>');
    XmlList.add(Space(Indent4) + '</sfd:ClientCellPhoneNumber>');
  End;

  // Fax  //20111212
  If AllTrim(FetchElm(RetNo, 'T1163' + FInst, 22) + FetchElm(RetNo,
    'T1163' + FInst, 21)) > '' then
  begin
    XmlList.add(Space(Indent4) + '<sfd:ClientFaxNumber>');
    XmlList.add(Space(Indent4) + '<comm:TelephoneAreaCode>' +
      AllTrim(Removechar(FetchElm(RetNo, 'T1163' + FInst, 22), '-')) +
      '</comm:TelephoneAreaCode>');
    XmlList.add(Space(Indent4) + '<comm:TelephoneLocalNumber>' +
      CleanUpTelephoneNo(FetchElm(RetNo, 'T1163' + FInst, 21)) +
      '</comm:TelephoneLocalNumber>');
    XmlList.add(Space(Indent4) + '</sfd:ClientFaxNumber>');
  end;

  // 20240203

  If FetchElm(RetNo, 'T1163' + FInst, 4) > '' then // 20190416
    XmlList.add(Space(Indent4) + '<sfd:ParticipantEmailAddress>' +
      CleanUpTelephoneNo(FetchElm(RetNo, 'T1163' + FInst, 4)) +
      '</sfd:ParticipantEmailAddress>'); // 20190417

  If FetchElm(RetNo, 'T1163' + FInst, 215) > '' then
    cd := '1'
  else
    cd := '0';
  XmlList.add(Space(Indent4) + '<sfd:FeederAssociationMemberIndicator>' + cd +
    '</sfd:FeederAssociationMemberIndicator>');
  If FetchElm(RetNo, 'T1163' + FInst, 216) > '' then
    cd := '1'
  else
    cd := '0';
  XmlList.add(Space(Indent4) + '<sfd:LandlordCropShareIndicator>' + cd +
    '</sfd:LandlordCropShareIndicator>');
  If FetchElm(RetNo, 'T1163' + FInst, 217) > '' then
    cd := '1'
  else
    cd := '0';
  XmlList.add(Space(Indent4) + '<sfd:TenantCropShareIndicator>' + cd +
    '</sfd:TenantCropShareIndicator>');
  XmlList.add(Space(Indent4) + '<sfd:FiscalPeriodStartDate>' + SFD.BUSFISCSTART
    + '</sfd:FiscalPeriodStartDate>');
  XmlList.add(Space(Indent4) + '<sfd:FiscalPeriodEndDate>' + SFD.BUSFISCEND +
    '</sfd:FiscalPeriodEndDate>');
  // bus type code
  If FetchElm(RetNo, 'T1163' + FInst, 207) > '' then
    cd := '1'
  else
    cd := '2';
  XmlList.add(Space(Indent4) +
    '<sfd:AgriStabilityAgriInvestProgramBusinessTypeCode>' + cd +
    '</sfd:AgriStabilityAgriInvestProgramBusinessTypeCode>');

  If SFD.BUSPERCENT <> '0000' then //jz 20250130
  begin
    XmlList.add(Space(Indent4) + '<sfd:BusinessOwnershipPercent>'
      + SFD.BUSPERCENT + '</sfd:BusinessOwnershipPercent>');     // + FetchElm(RetNo,'T1163'+FINST,210) + '</sfd:BusinessOwnershipPercent>');  //20240206
  end;

  If SFD.BUSFINALYR = '1' then // 20240203
    XmlList.add(Space(Indent4) + '<sfd:FinalBusinessYearIndicator>' +
      SFD.BUSFINALYR + '</sfd:FinalBusinessYearIndicator>'); // 20111212

  BuildPartners(RetNo);
  BuildNISAContactInfo(RetNo, 'T1163' + FInst);
  cd := AllTrim(FetchElm(RetNo, 'T1163' + FInst, 33));
  cd := AddLeadingZeros(cd, 2);
  XmlList.add(Space(Indent4) + '<sfd:FarmedYearCount>' + cd +
    '</sfd:FarmedYearCount>');
  cd := FetchElm(RetNo, 'T1163' + FInst, 20);
  cd := AddLeadingZeros(cd, 8);
  XmlList.add(Space(Indent4) +
    '<sfd:AgriStabilityAgriInvestProgramParticipantIDNumber>' + cd +
    '</sfd:AgriStabilityAgriInvestProgramParticipantIDNumber>');

  // 20120229
  If AllTrim(FetchElmFNo(RetNo, FNo, 9)) + AllTrim(FetchElmFNo(RetNo, FNo, 24)
    ) > '' then
  Begin
    If AllTrim(FetchElmFNo(RetNo, FNo, 9)) > '' then
      cd := '1'
    else
      cd := '2'; // 20120229
    XmlList.add(Space(Indent4) + '<sfd:PublicOfficeAAFCEmployeeIndicator>' + cd
      + '</sfd:PublicOfficeAAFCEmployeeIndicator>');
  end;

  cd := '';
  If FetchElm(RetNo, 'T1163' + FInst, 35) > '' then
    cd := '1'
  else
    cd := '2';
  If cd > '' then
    XmlList.add(Space(Indent4) + '<sfd:ProductionCycleCompletionIndicator>' + cd
      + '</sfd:ProductionCycleCompletionIndicator>');

  cd := ''; // 20121217
  If FetchElm(RetNo, 'T1163' + FInst, 25) > '' then
    cd := '1';
  If FetchElm(RetNo, 'T1163' + FInst, 26) > '' then
    cd := '2';
  If cd > '' then
    XmlList.add(Space(Indent4) + '<sfd:ProductionCycleDisasterIndicator>' + cd +
      '</sfd:ProductionCycleDisasterIndicator>');

  // 9950 $ T1163  169
  FNo := GetFormNo('T1163' + FInst);
  LLine := 9950;
  LType := '$';
  FName := 'T1163' + FInst;
  ElmNo := 305;
  Rule := 0;
  S := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
  If S > '' then
  begin
    // 20111212
    XmlList.add(Space(Indent4) + '<sfd:CommodityTotalReturnLine>');
    XmlList.add(Space(Indent4) + '<sfd:CommodityTotalFieldCode>' + '9950' +
      '</sfd:CommodityTotalFieldCode>'); // 20121215
    XmlList.add(Space(Indent4) + '<sfd:FieldAmount>' + S +
      '</sfd:FieldAmount>');
    // details Codes and amounts for 9950
    i := 219;
    FNo := GetFormNo('T1163' + FInst);
    Repeat
      LLine := myStrToInt(FetchElmFNo(RetNo, FNo, i));
      LType := '$';
      FName := 'T1163' + FInst;
      ElmNo := i + 1;
      Rule := 0;
      S := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
      If S > '' then
        BuildSfdLineValues(RetNo,
          AddLeadingZeros(AllTrim(IntToStr(LLine)), 3), S);
      Inc(i, 3);
    until i > 303;
    XmlList.add(Space(Indent4) + '</sfd:CommodityTotalReturnLine>');
  end; // 20111212

  // 9960 $ T1163  065
  FNo := GetFormNo('T1163' + FInst);
  LLine := 9960;
  LType := '$';
  FName := 'T1163' + FInst;
  ElmNo := 458;
  Rule := 0;
  S := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
  If S > '' then
  begin
    // 20111212
    XmlList.add(Space(Indent4) + '<sfd:CommodityTotalReturnLine>');
    XmlList.add(Space(Indent4) + '<sfd:CommodityTotalFieldCode>' + '9960' +
      '</sfd:CommodityTotalFieldCode>'); // 20121215
    XmlList.add(Space(Indent4) + '<sfd:FieldAmount>' + S +
      '</sfd:FieldAmount>');

    i := 402;
    FNo := GetFormNo('T1163' + FInst);
    Repeat
      LLine := myStrToInt(FetchElmFNo(RetNo, FNo, i));
      LType := '$';
      FName := 'T1163' + FInst;
      ElmNo := i + 1;
      Rule := 0;
      S := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
      If S > '' then
        BuildSfdLineValues(RetNo,
          AddLeadingZeros(AllTrim(IntToStr(LLine)), 3), S);
      Inc(i, 3);
    until i > 456;
    XmlList.add(Space(Indent4) + '</sfd:CommodityTotalReturnLine>');
  end;

  EFlines := TStringList.Create;
  EFlines.LoadFromFile(AppDir + '\' + 'EFNLINE.D');

  For i := 0 to EFlines.Count - 1 do
  begin
    LLine := myStrToInt(LeftStr(EFlines[i], 4));
    LType := MidStr(EFlines[i], 6, 1);
    FName := AllTrim(MidStr(EFlines[i], 8, 9)) + FInst;
    ElmNo := myStrToInt(MidStr(EFlines[i], 17, 3));
    If MidStr(EFlines[i], 22, 3) = '' then
      Rule := 0
    else
      Rule := myStrToInt(MidStr(EFlines[i], 22, 3));

    S := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
    If LLine = 9946 then
    begin
      If (S = '') and (Vl(FetchElm(RetNo, 'T1163' + FInst, 352)) <> 0) then
        S := '1';
    end;

    If LLine = 9946 then
    begin
      If (Vl(FetchElm(RetNo, 'T1163' + FInst, 676)) > 0) // rest farm loss
        and (Vl(FetchElm(RetNo, 'T1163' + FInst, 616)) < 0) then
        S := AllTrim(IntToStr(Round(Vl(FetchElm(RetNo, 'T1163' + FInst,
          675)))));
    end;

    If LLine = 9969 then // ni before adj
    begin
      If (S = '') and (Vl(FetchElm(RetNo, 'T1163' + FInst, 601)) <> 0) then
        S := '1';
    end;
    If S > '' then
      BuildLineValues(RetNo, AllTrim(IntToStr(LLine)), S);
  end;
  EFlines.Free;
end;

Procedure BuildFishing(RetNo: Integer; FInst: String);
Var
  i, LLine, ElmNo, Rule, FNo: Integer;
  LType: string[1];
  FName: string[12];
  S: string;
begin
  If IsPreBankruptcyReturn(RetNo) then
    exit;
  SFD.RECTYPE := '03';
  SFD.PREPARERNO := Fx.PREPARERNO;
  SFD.SEQNO := Fx.SEQNO;
  SfdRecNumber := SfdRecNumber + 1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber), 2);
  SFD.BUSTYPE := '4';

  SFD.BUSNAME := FetchElm(RetNo, 'T2121' + FInst, 8); // 20240205
  SFD.BUSADDRESS := '';
  SFD.BUSPOSTAL := '';

  SFD.BUSFISCSTART := FetchElm(RetNo, 'T2121' + FInst, 4);
  SFD.BUSFISCEND := FetchElm(RetNo, 'T2121' + FInst, 5);

  SFD.ACROWNED := '';
  SFD.ACRFARMED := '';

  If AllTrim(FetchElm(RetNo, 'T2121' + FInst, 19)) > '' THEN
    SFD.ACCMETHOD := '1'
  ELSE
    SFD.ACCMETHOD := '2';
  SFD.SIC := FetchElm(RetNo, 'T2121' + FInst, 11);
  SFD.SIN := RemoveHyphens(FetchElm(RetNo, 'INFO', 3));
  SFD.BUSPARTNID := FetchElm(RetNo, 'T2121' + FInst, 12);
  SFD.BUSPERCENT := FormatFourDigitPercent
    (FetchElm(RetNo, 'T2121' + FInst, 18));
  SFD.BUSTAXSHELTNO := FetchElm(RetNo, 'T2121' + FInst, 14);
  If AllTrim(FetchElm(RetNo, 'T2121' + FInst, 6)) > '' THEN
    SFD.BUSFINALYR := '1'
  ELSE
    SFD.BUSFINALYR := '2';
  SFD.GSTACCNO := FetchElm(RetNo, 'T2121' + FInst, 15);
  i := 0;
  If Vl(FetchElm(RetNo, 'T2121' + FInst, 505)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2121' + FInst, 503), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2121' + FInst, 537), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T2121'+FInst,537),30));
    // SFD.PRec[i].PSin       := '00000000';
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2121' + FInst, 505));
  end;
  If Vl(FetchElm(RetNo, 'T2121' + FInst, 509)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2121' + FInst, 507), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2121' + FInst, 539), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T2121'+FInst,539),30));
    // SFD.PRec[i].PSin       := '00000000';
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2121' + FInst, 509));
  end;
  If Vl(FetchElm(RetNo, 'T2121' + FInst, 513)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2121' + FInst, 511), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2121' + FInst, 541), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T2121'+FInst,541),30));
    // SFD.PRec[i].PSin       := '00000000';
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2121' + FInst, 513));
  end;
  if Vl(FetchElm(RetNo, 'T2121' + FInst, 517)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2121' + FInst, 515), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2121' + FInst, 543), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T2121'+FInst,543),30));
    // SFD.PRec[i].PSin       := '00000000';
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2121' + FInst, 517));
  end;

  If Vl(FetchElm(RetNo, 'T2121' + FInst, 521)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T2121' + FInst, 519), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T2121' + FInst, 545), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T2121'+FInst,545),30));
    // SFD.PRec[i].PSin       := '00000000';
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T2121' + FInst, 521));
  end;

  EFlines := TStringList.Create;
  EFlines.LoadFromFile(AppDir + '\' + 'EFILINE.D');

  XmlList.add(Space(Indent4) + '<sfd:AccountingMethodCode>' + SFD.ACCMETHOD +
    '</sfd:AccountingMethodCode>'); // 20141211
  If AllTrim(SFD.GSTACCNO) > '' then
    XmlList.add(Space(Indent4) + '<sfd:BusinessNumber>' + SFD.GSTACCNO +
      '</sfd:BusinessNumber>');
  XmlList.add(Space(Indent4) + '<sfd:NAICSCode>' + SFD.SIC +
    '</sfd:NAICSCode>');
  If AllTrim(SFD.BUSNAME) > '' then
    XmlList.add(Space(Indent4) + '<sfd:BoatName>' + ReplaceReservedXMLCharacters
      (AllTrim(SFD.BUSNAME)) + '</sfd:BoatName>');
  If (AllTrim(SFD.BUSPARTNID) > '') then
    XmlList.add(Space(Indent4) + '<sfd:PartnershipNumber>' + SFD.BUSPARTNID +
      '</sfd:PartnershipNumber>');
  If (AllTrim(SFD.BUSTAXSHELTNO) > '') then
    XmlList.add(Space(Indent4) + '<sfd:TaxShelterNumber>' + SFD.BUSTAXSHELTNO +
      '</sfd:TaxShelterNumber>');
  XmlList.add(Space(Indent4) + '<sfd:FiscalPeriodStartDate>' + SFD.BUSFISCSTART
    + '</sfd:FiscalPeriodStartDate>');
  XmlList.add(Space(Indent4) + '<sfd:FiscalPeriodEndDate>' + SFD.BUSFISCEND +
    '</sfd:FiscalPeriodEndDate>');
  If AllTrim(AllTrim(SFD.BUSADDRESS) + AllTrim(SFD.BUSPOSTAL)) > '' then
  begin
    XmlList.add(Space(Indent4) + '<sfd:BusinessAddress>');
    XmlList.add(Space(Indent4) + '<comm:BusinessAddressStreetText>' +
      ReplaceReservedXMLCharacters(AllTrim(SFD.BUSADDRESS)) +
      '</comm:BusinessAddressStreetText>');
    XmlList.add(Space(Indent4) + '<comm:AddressPostalCode>' +
      AllTrim(SFD.BUSPOSTAL) + '</comm:AddressPostalCode>');
    XmlList.add(Space(Indent4) + '</sfd:BusinessAddress>');
  end;

  If SFD.BUSPERCENT <> '0000' then
    XmlList.add(Space(Indent4) + '<sfd:BusinessOwnershipPercent>' +
      SFD.BUSPERCENT + '</sfd:BusinessOwnershipPercent>');
  If SFD.BUSFINALYR = '1' then
    XmlList.add(Space(Indent4) + '<sfd:FinalBusinessYearIndicator>' +
      SFD.BUSFINALYR + '</sfd:FinalBusinessYearIndicator>');
  If UpperCase(FetchElm(RetNo, 'T2121' + FInst, 27)) <> 'Y' then // 20111213
    BuildPartners(RetNo);

  FNo := GetFormNo('T2121' + FInst); // 20131226
  If FNo > 0 then
  Begin
    If Vl(FetchElm(RetNo, 'T2121' + FInst, 86)) > 0 then
    begin
      XmlList.add(Space(Indent4) + '<sfd:IncomeEarnedWebPageCount>' +
        IntToStr(myStrToInt(FetchElmFNo(RetNo, FNo, 86))) +
        '</sfd:IncomeEarnedWebPageCount>');
      If FetchElmFNo(RetNo, FNo, 82) > '' then
        XmlList.add(Space(Indent4) + '<sfd:WebPageAddressText>' +
          FetchElmFNo(RetNo, FNo, 82) + '</sfd:WebPageAddressText>');
      If FetchElmFNo(RetNo, FNo, 83) > '' then
        XmlList.add(Space(Indent4) + '<sfd:WebPageAddressText>' +
          FetchElmFNo(RetNo, FNo, 83) + '</sfd:WebPageAddressText>');
      If FetchElmFNo(RetNo, FNo, 84) > '' then
        XmlList.add(Space(Indent4) + '<sfd:WebPageAddressText>' +
          FetchElmFNo(RetNo, FNo, 84) + '</sfd:WebPageAddressText>');
      If FetchElmFNo(RetNo, FNo, 85) > '' then
        XmlList.add(Space(Indent4) + '<sfd:WebPageAddressText>' +
          FetchElmFNo(RetNo, FNo, 85) + '</sfd:WebPageAddressText>');
      If FetchElmFNo(RetNo, FNo, 87) > '' then
        XmlList.add(Space(Indent4) + '<sfd:WebPageAddressText>' +
          FetchElmFNo(RetNo, FNo, 87) + '</sfd:WebPageAddressText>');
      XmlList.add(Space(Indent4) + '<sfd:InternetGrossIncomePercentage>' +
        FormatFloat('000', Vl(FetchElmFNo(RetNo, FNo, 88))) +
        '</sfd:InternetGrossIncomePercentage>');
    end;
  end;

  { Free format SFD }
  For i := 0 to EFlines.Count - 1 do
  begin
    LLine := myStrToInt(LeftStr(EFlines[i], 4));
    LType := MidStr(EFlines[i], 6, 1);
    FName := AllTrim(MidStr(EFlines[i], 8, 9)) + FInst;
    ElmNo := myStrToInt(MidStr(EFlines[i], 17, 3));
    If MidStr(EFlines[i], 22, 3) = '' then
      Rule := 0
    else
      Rule := myStrToInt(MidStr(EFlines[i], 22, 3));

    S := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
    If LLine = 9946 then
    begin
      If (S = '') and (Vl(FetchElm(RetNo, 'T2121' + FInst, 35)) <> 0) then
        S := '1';
    end;
    If S > '' then
      BuildLineValues(RetNo, AllTrim(IntToStr(LLine)), S);
  end;
  EFlines.Free;
end;

Procedure BuildT1273(RetNo: Integer; FInst: String);
// like NISAA
Var
  i, LLine, ElmNo, Rule, FNo: Integer;
  LType: string[1];
  FName: string[12];
  S: string;
  cd: String;
  Rec: String;
begin
  If IsPreBankruptcyReturn(RetNo) then
    exit;
  SFD.RECTYPE := '03';
  SFD.PREPARERNO := Fx.PREPARERNO;
  SFD.SEQNO := Fx.SEQNO;
  SfdRecNumber := SfdRecNumber + 1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber), 2);
  SFD.BUSTYPE := '6'; // same with normal NISA
  SFD.BUSNAME := FetchElm(RetNo, 'T1273' + FInst, 201); // 20120302
  SFD.BusinessNumber := FetchElm(RetNo, 'T1273' + FInst, 4); // 20191127

  SFD.BUSADDRESS := FetchElm(RetNo, 'T1273' + FInst, 204);
  // ReplaceReservedXMLCharacters(FetchElm(RetNo,'T1273'+FInst,204));
  SFD.BUSPOSTAL := MTrim(FetchElm(RetNo, 'T1273' + FInst, 206));
  SFD.BUSFISCSTART := FetchElm(RetNo, 'T1273' + FInst, 213);
  SFD.BUSFISCEND := FetchElm(RetNo, 'T1273' + FInst, 214);
  SFD.ACROWNED := FetchElm(RetNo, 'T1273' + FInst, 217);
  SFD.ACRFARMED := FetchElm(RetNo, 'T1273' + FInst, 219);
  // ? rented
  SFD.ACCMETHOD := AllTrim(FetchElm(RetNo, 'T1273' + FInst, 212));
  SFD.FarmStead := FetchElm(RetNo, 'T1273' + FInst, 32);

  SFD.SIC := AllTrim(FetchElm(RetNo, 'T1273' + FInst, 34)); // 20230214
  SFD.BUSPARTNID := FetchElm(RetNo, 'T1273' + FInst, 624);
  SFD.BUSPERCENT := FormatFourDigitPercent
    (FetchElm(RetNo, 'T1273' + FInst, 210));
  If AllTrim(FetchElm(RetNo, 'T1273' + FInst, 35)) > '' THEN
    SFD.BUSFINALYR := '1'
  ELSE
    SFD.BUSFINALYR := '2';

  SFD.GSTACCNO := '';

  i := 0;
  If Vl(FetchElm(RetNo, 'T1273' + FInst, 632)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T1273' + FInst, 630), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T1273' + FInst, 631), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T1273'+FInst,631),30));
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T1273' + FInst, 634), 8);
    If FetchElm(RetNo, 'T1273' + FInst, 633) > '' then
      SFD.PRec[i].PSin := FetchElm(RetNo, 'T1273' + FInst, 633);
    // 20170427
    S := FetchElm(RetNo, 'T1273' + FInst, 632);
    SFD.PRec[i].PPerCent := FormatBusPercent(S); //
    // SFD.PRec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T1273'+FInst,632));  //20170427
  end;

  If Vl(FetchElm(RetNo, 'T1273' + FInst, 637)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T1273' + FInst, 635), 30);
    // 20110505
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T1273' + FInst, 636), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T1273'+FInst,636),30));
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T1273' + FInst, 639), 8);
    If FetchElm(RetNo, 'T1273' + FInst, 638) > '' then
      SFD.PRec[i].PSin := FetchElm(RetNo, 'T1273' + FInst, 638);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T1273' + FInst, 637));
  end;
  If Vl(FetchElm(RetNo, 'T1273' + FInst, 642)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T1273' + FInst, 640), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T1273' + FInst, 641), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T1273'+FInst,641),30));
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T1273' + FInst, 644), 8);
    If FetchElm(RetNo, 'T1273' + FInst, 643) > '' then
      SFD.PRec[i].PSin := FetchElm(RetNo, 'T1273' + FInst, 643);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T1273' + FInst, 642));
  end;
  If Vl(FetchElm(RetNo, 'T1273' + FInst, 647)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T1273' + FInst, 645), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T1273' + FInst, 646), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T1273'+FInst,646),30));
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T1273' + FInst, 649), 8);
    If FetchElm(RetNo, 'T1273' + FInst, 648) > '' then
      SFD.PRec[i].PSin := FetchElm(RetNo, 'T1273' + FInst, 648);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T1273' + FInst, 647));
  end;

  If Vl(FetchElm(RetNo, 'T1273' + FInst, 652)) > 0 then
  begin
    Inc(i);
    SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo, 'T1273' + FInst, 650), 30);
    SFD.PRec[i].PLastName := PaddR(FetchElm(RetNo, 'T1273' + FInst, 651), 30);
    // ReplaceReservedXmlCharacters(PaddR(FetchElm(RetNo,'T1273'+FInst,651),30));
    SFD.PRec[i].PSin := PaddZero(FetchElm(RetNo, 'T1273' + FInst, 654), 8);
    If FetchElm(RetNo, 'T1273' + FInst, 653) > '' then
      SFD.PRec[i].PSin := FetchElm(RetNo, 'T1273' + FInst, 653);
    SFD.PRec[i].PPerCent := FormatBusPercent
      (FetchElm(RetNo, 'T1273' + FInst, 652));
  end;

  // FIRST PART headers
  XmlList.add(Space(Indent3) + '<sfd:SelectedFinancialData>');
  XmlList.add(Space(Indent3) +
    '<sfd:AgriStabilityAgriInvestProgramFarmingData>');

  FNo := GetFormNo('T1273' + FInst);
  XmlList.add(Space(Indent4) + '<sfd:MainFarmsteadProvinceCode>' + SFD.FarmStead
    + '</sfd:MainFarmsteadProvinceCode>'); // 20120117
  XmlList.add(Space(Indent4) + '<sfd:AccountingMethodCode>' + SFD.ACCMETHOD +
    '</sfd:AccountingMethodCode>');
  XmlList.add(Space(Indent4) + '<sfd:NAICSCode>' + SFD.SIC +
    '</sfd:NAICSCode>');
  If AllTrim(SFD.BUSNAME) > '' then
    XmlList.add(Space(Indent4) + '<sfd:FarmName>' + ReplaceReservedXMLCharacters
      (AllTrim(SFD.BUSNAME)) + '</sfd:FarmName>');
  If AllTrim(SFD.BusinessNumber) > '' then
    XmlList.add(Space(Indent4) + '<sfd:AgriStabilityAgriInvestBusinessNumber>' +
      AllTrim(SFD.BusinessNumber) +
      '</sfd:AgriStabilityAgriInvestBusinessNumber>');
  If (AllTrim(SFD.BUSPARTNID) > '') then
    XmlList.add(Space(Indent4) + '<sfd:PartnershipNumber>' + SFD.BUSPARTNID +
      '</sfd:PartnershipNumber>');
  If AllTrim(AllTrim(SFD.BUSADDRESS) + AllTrim(SFD.BUSPOSTAL)) > '' then
  begin
    XmlList.add(Space(Indent4) + '<sfd:FarmAddress>');
    XmlList.add(Space(Indent4) + '<comm:BusinessAddressStreetText>' +
      ReplaceReservedXMLCharacters(LeftStr(AllTrim(SFD.BUSADDRESS), 30)) +
      '</comm:BusinessAddressStreetText>'); // 20120119
    XmlList.add(Space(Indent4) + '<comm:AddressPostalCode>' +
      AllTrim(SFD.BUSPOSTAL) + '</comm:AddressPostalCode>');
    XmlList.add(Space(Indent4) + '</sfd:FarmAddress>');
  end;

  { //removed from specs? //jz //20230206
    //client phones
    //20230129  phone  //20230204
    If (AllTrim(FetchElm(RetNo,'T1273'+FInst,1))>'')  //area
    and (AllTrim(FetchElm(RetNo,'T1273'+FInst,2))>'')  //phone
    then //20230115
    Begin
    XmlList.Add(Space(Indent4)+'<sfd:ClientTelephonePhoneNumber>');
    XmlList.Add(Space(Indent4)+'<comm:TelephoneAreaCode>'+FetchElm(RetNo,'T1273'+FInst,1)+'</comm:TelephoneAreaCode>');
    XmlList.Add(Space(Indent4)+'<comm:TelephoneLocalNumber>'+Removechar(FetchElm(RetNo,'T1273'+FInst,2),'-')+'</comm:TelephoneLocalNumber>');
    XmlList.Add(Space(Indent4)+'</sfd:ClientTelephonePhoneNumber>');
    End;
  }
  // 20230129  Cell phone  //20230204
  If (AllTrim(FetchElm(RetNo, 'T1273' + FInst, 38)) > '') // area
    and (AllTrim(FetchElm(RetNo, 'T1273' + FInst, 30)) > '') // cell no
  then // 20230115
  Begin
    XmlList.add(Space(Indent4) + '<sfd:ClientCellPhoneNumber>');
    XmlList.add(Space(Indent4) + '<comm:TelephoneAreaCode>' + FetchElm(RetNo,
      'T1273' + FInst, 38) + '</comm:TelephoneAreaCode>');
    XmlList.add(Space(Indent4) + '<comm:TelephoneLocalNumber>' +
      Removechar(FetchElm(RetNo, 'T1273' + FInst, 30), '-') +
      '</comm:TelephoneLocalNumber>');
    XmlList.add(Space(Indent4) + '</sfd:ClientCellPhoneNumber>');
  End;

  If (AllTrim(FetchElm(RetNo, 'T1273' + FInst, 22)) > '') // area
    and (AllTrim(FetchElm(RetNo, 'T1273' + FInst, 21)) > '') // Fax no
  then // 20230115
  Begin
    XmlList.add(Space(Indent4) + '<sfd:ClientFaxNumber>');
    XmlList.add(Space(Indent4) + '<comm:TelephoneAreaCode>' + FetchElm(RetNo,
      'T1273' + FInst, 22) + '</comm:TelephoneAreaCode>');
    XmlList.add(Space(Indent4) + '<comm:TelephoneLocalNumber>' +
      Removechar(FetchElm(RetNo, 'T1273' + FInst, 21), '-') +
      '</comm:TelephoneLocalNumber>');
    XmlList.add(Space(Indent4) + '</sfd:ClientFaxNumber>');
  End;
  // ====end client section =======================
  If FetchElm(RetNo, 'T1273' + FInst, 3) > '' then // 20190416
    XmlList.add(Space(Indent4) + '<sfd:ParticipantEmailAddress>' +
      CleanUpTelephoneNo(FetchElm(RetNo, 'T1273' + FInst, 3)) +
      '</sfd:ParticipantEmailAddress>'); // 20190417
  If FetchElm(RetNo, 'T1273' + FInst, 215) > '' then
    cd := '1'
  else
    cd := '0';
  XmlList.add(Space(Indent4) + '<sfd:FeederAssociationMemberIndicator>' + cd +
    '</sfd:FeederAssociationMemberIndicator>');
  If FetchElm(RetNo, 'T1273' + FInst, 216) > '' then
    cd := '1'
  else
    cd := '0';
  XmlList.add(Space(Indent4) + '<sfd:LandlordCropShareIndicator>' + cd +
    '</sfd:LandlordCropShareIndicator>');
  If FetchElm(RetNo, 'T1273' + FInst, 217) > '' then
    cd := '1'
  else
    cd := '0';
  XmlList.add(Space(Indent4) + '<sfd:TenantCropShareIndicator>' + cd +
    '</sfd:TenantCropShareIndicator>');
  XmlList.add(Space(Indent4) + '<sfd:FiscalPeriodStartDate>' + SFD.BUSFISCSTART
    + '</sfd:FiscalPeriodStartDate>');
  XmlList.add(Space(Indent4) + '<sfd:FiscalPeriodEndDate>' + SFD.BUSFISCEND +
    '</sfd:FiscalPeriodEndDate>');
  If FetchElm(RetNo, 'T1273' + FInst, 207) > '' then
    cd := '1'
  else
    cd := '2';


  XmlList.add(Space(Indent4) +
    '<sfd:AgriStabilityAgriInvestProgramBusinessTypeCode>' + cd +
    '</sfd:AgriStabilityAgriInvestProgramBusinessTypeCode>');

  If SFD.BUSPERCENT <> '0000' then       //jz//20260119 - do not add if 0
    XmlList.add(Space(Indent4) + '<sfd:BusinessOwnershipPercent>' + SFD.BUSPERCENT
                               + '</sfd:BusinessOwnershipPercent>');

  If SFD.BUSFINALYR = '1' then
    XmlList.add(Space(Indent4) + '<sfd:FinalBusinessYearIndicator>' +
      SFD.BUSFINALYR + '</sfd:FinalBusinessYearIndicator>'); // 20230204

  BuildPartners(RetNo);
  BuildHarmonizedContactInfo(RetNo, 'T1273' + FInst); // 20120118   //20230204

  cd := AllTrim(FetchElmFNo(RetNo, FNo, 33));
  cd := AddLeadingZeros(cd, 2);
  XmlList.add(Space(Indent4) + '<sfd:FarmedYearCount>' + cd +
    '</sfd:FarmedYearCount>');

  cd := FetchElmFNo(RetNo, FNo, 20);
  cd := AddLeadingZeros(cd, 8);
  XmlList.add(Space(Indent4) +
    '<sfd:AgriStabilityAgriInvestProgramParticipantIDNumber>' + cd +
    '</sfd:AgriStabilityAgriInvestProgramParticipantIDNumber>');

  cd := AllTrim(FetchElmFNo(RetNo, FNo, 26)); // 24  20100313
  If cd > '' then
    cd := '1'
  else
    cd := '2';
  If cd > '' then
    XmlList.add(Space(Indent4) + '<sfd:PublicOfficeAAFCEmployeeIndicator>' + cd
      + '</sfd:PublicOfficeAAFCEmployeeIndicator>');

  cd := AllTrim(FetchElmFNo(RetNo, FNo, 27));
  If cd > '' then
    XmlList.add(Space(Indent4) + '<sfd:DistrictCountyMunicipalityName>' + cd +
      '</sfd:DistrictCountyMunicipalityName>');

  cd := AddLeadingZeros(AllTrim(FetchElmFNo(RetNo, FNo, 28)), 3); // 20170108
  If cd > '' then
    XmlList.add(Space(Indent4) + '<sfd:DistrictCountyMunicipalityNumber>' + cd +
      '</sfd:DistrictCountyMunicipalityNumber>');

  XmlList.add(Space(Indent4) + '<sfd:CombinedFarmOperationData>');
  cd := AllTrim(FetchElmFNo(RetNo, FNo, 40));
  If cd > '' then
    cd := '1'
  else
    cd := '2';
  If cd > '' then
    XmlList.add(Space(Indent4) + '<sfd:CombinedFarmOperationIndicator>' + cd +
      '</sfd:CombinedFarmOperationIndicator>');
  cd := FetchElmFNo(RetNo, FNo, 41);
  If cd > '' then
  begin
    XmlList.add(Space(Indent4) + '<sfd:CombinedFarmOperationChange>');
    XmlList.add(Space(Indent4) + '<sfd:CombinedFarmOperationPIN>' + cd +
      '</sfd:CombinedFarmOperationPIN>');
    cd := FetchElmFNo(RetNo, FNo, 56);
    If cd > '' then
      cd := '1'
    else
      cd := '2';
    XmlList.add(Space(Indent4) + '<sfd:CombinedFarmOperationChangeCode>' + cd +
      '</sfd:CombinedFarmOperationChangeCode>');
    XmlList.add(Space(Indent4) + '</sfd:CombinedFarmOperationChange>');
  end;
  cd := FetchElmFNo(RetNo, FNo, 52);
  If cd > '' then
  begin
    XmlList.add(Space(Indent4) + '<sfd:CombinedFarmOperationChange>');
    XmlList.add(Space(Indent4) + '<sfd:CombinedFarmOperationPIN>' + cd +
      '</sfd:CombinedFarmOperationPIN>');
    cd := FetchElmFNo(RetNo, FNo, 58);
    If cd > '' then
      cd := '1'
    else
      cd := '2';
    XmlList.add(Space(Indent4) + '<sfd:CombinedFarmOperationChangeCode>' + cd +
      '</sfd:CombinedFarmOperationChangeCode>');
    XmlList.add(Space(Indent4) + '</sfd:CombinedFarmOperationChange>');
  end;
  cd := FetchElmFNo(RetNo, FNo, 53);
  If cd > '' then
  begin
    XmlList.add(Space(Indent4) + '<sfd:CombinedFarmOperationChange>');
    XmlList.add(Space(Indent4) + '<sfd:CombinedFarmOperationPIN>' + cd +
      '</sfd:CombinedFarmOperationPIN>');
    cd := FetchElmFNo(RetNo, FNo, 60);
    If cd > '' then
      cd := '1'
    else
      cd := '2';
    XmlList.add(Space(Indent4) + '<sfd:CombinedFarmOperationChangeCode>' + cd +
      '</sfd:CombinedFarmOperationChangeCode>');
    XmlList.add(Space(Indent4) + '</sfd:CombinedFarmOperationChange>');
  end;

  XmlList.add(Space(Indent4) + '</sfd:CombinedFarmOperationData>');
  If FetchElmFNo(RetNo, FNo, 69) > '' then
    cd := '1'
  else
    cd := '2';
  If cd > '' then
    XmlList.add(Space(Indent4) + '<sfd:ProductionCycleCompletionIndicator>' + cd
      + '</sfd:ProductionCycleCompletionIndicator>');

  cd := '';
  If FetchElmFNo(RetNo, FNo, 71) > '' then
    cd := '1';
  If FetchElmFNo(RetNo, FNo, 72) > '' then
    cd := '2';
  If cd > '' then
    XmlList.add(Space(Indent4) + '<sfd:ProductionCycleDisasterIndicator>' + cd +
      '</sfd:ProductionCycleDisasterIndicator>');

  EFlines := TStringList.Create;
  EFlines.LoadFromFile(AppDir + '\' + 'EFCLINE.D');

  // 9950 $ T1273
  FNo := GetFormNo('T1273' + FInst);
  LLine := 9950;
  LType := '$';
  FName := 'T1273' + FInst;
  ElmNo := 305;
  Rule := 0;
  S := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
  If S > '' then
  begin
    // 20111212
    XmlList.add(Space(Indent4) + '<sfd:CommodityTotalReturnLine>');
    XmlList.add(Space(Indent4) + '<sfd:CommodityTotalFieldCode>' + '9950' +
      '</sfd:CommodityTotalFieldCode>'); // 20121215
    XmlList.add(Space(Indent4) + '<sfd:FieldAmount>' + S +
      '</sfd:FieldAmount>');
    // details Codes and amounts for 9950
    i := 219;
    FNo := GetFormNo('T1273' + FInst);
    Repeat
      LLine := myStrToInt(FetchElmFNo(RetNo, FNo, i));
      LType := '$';
      FName := 'T1273' + FInst;
      ElmNo := i + 1;
      Rule := 0;
      S := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
      If S > '' then
        BuildSfdLineValues(RetNo,
          AddLeadingZeros(AllTrim(IntToStr(LLine)), 3), S);
      Inc(i, 3);
    until i > 303;
    XmlList.add(Space(Indent4) + '</sfd:CommodityTotalReturnLine>');
  end;

  // 9960 $ T1273   065
  FNo := GetFormNo('T1273' + FInst);
  LLine := 9960;
  LType := '$';
  FName := 'T1273' + FInst;
  ElmNo := 458;
  Rule := 0;
  S := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
  If S > '' then
  begin
    XmlList.add(Space(Indent4) + '<sfd:CommodityTotalReturnLine>');
    XmlList.add(Space(Indent4) + '<sfd:CommodityTotalFieldCode>' + '9960' +
      '</sfd:CommodityTotalFieldCode>'); // 20121215
    XmlList.add(Space(Indent4) + '<sfd:FieldAmount>' + S +
      '</sfd:FieldAmount>');

    i := 402;
    FNo := GetFormNo('T1273' + FInst);
    Repeat
      LLine := myStrToInt(FetchElmFNo(RetNo, FNo, i));
      LType := '$';
      FName := 'T1273' + FInst;
      ElmNo := i + 1;
      Rule := 0;
      S := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
      If S > '' then
        BuildSfdLineValues(RetNo,
          AddLeadingZeros(AllTrim(IntToStr(LLine)), 3), S);
      Inc(i, 3);
    until i > 456;
    XmlList.add(Space(Indent4) + '</sfd:CommodityTotalReturnLine>');
  end;

  For i := 0 to EFlines.Count - 1 do
  begin
    LLine := myStrToInt(LeftStr(EFlines[i], 4));
    LType := MidStr(EFlines[i], 6, 1);
    FName := AllTrim(MidStr(EFlines[i], 8, 9)) + FInst;
    ElmNo := myStrToInt(MidStr(EFlines[i], 17, 3));
    If MidStr(EFlines[i], 22, 3) = '' then
      Rule := 0
    else
      Rule := myStrToInt(MidStr(EFlines[i], 22, 3));

    S := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
    If LLine = 9946 then
    begin
      If (S = '') and (Vl(FetchElm(RetNo, 'T1273' + FInst, 352)) <> 0) then
        S := '1';
    end;

    If LLine = 9946 then
    begin
      If (Vl(FetchElm(RetNo, 'T1273' + FInst, 656)) > 0) // rest farm loss
        and (Vl(FetchElm(RetNo, 'T1273' + FInst, 616)) < 0) then
      begin
        S := AllTrim(IntToStr(Round(Vl(FetchElm(RetNo, 'T1273' + FInst,
          655)))));
      end;
    end;

    If LLine = 9969 then // ni before adj
    begin
      If (S = '') and (Vl(FetchElm(RetNo, 'T1273' + FInst, 601)) <> 0) then
        S := '1';
    end;
    If S > '' then
      BuildLineValues(RetNo, AllTrim(IntToStr(LLine)), S);
  end;
  // end first part
  XmlList.add(Space(Indent3) +
    '</sfd:AgriStabilityAgriInvestProgramFarmingData>');
  XmlList.add(Space(Indent3) + '</sfd:SelectedFinancialData>');

  XmlList.add(Space(Indent3) + '<sfd:SelectedFinancialData>');
  XmlList.add(Space(Indent3) +
    '<sfd:AgriStabilityAgriInvestProgramHarmonizedData>');
  BuildT1273Additional(RetNo, FInst); // 20111229
  XmlList.add(Space(Indent3) +
    '</sfd:AgriStabilityAgriInvestProgramHarmonizedData>');
  XmlList.add(Space(Indent3) + '</sfd:SelectedFinancialData>');

  EFlines.Free;
end;

Procedure BuildT1273Additional(RetNo: Integer; FInst: String); // page 7 and 8
// livestock etc
Var
  i, j, k, LLine, ElmNo, Rule, FNo: Integer;
  valu: String;
  LType: string[1];
  FName: string[12];
  S: string;
  cd: String[1];
  Rec: String;
begin
  If IsPreBankruptcyReturn(RetNo) then
    exit;
  // CROP   cr fgs   //fgs 1410
  XmlList.add(Space(Indent4) + '<sfd:FarmingOperationData>');

  FNo := GetFormNo('T1273' + FInst);
  If FetchElmFNo(RetNo, FNo, 805) > '' then
    valu := '1'
  else
    valu := '2'; // 20110317
  XmlList.add(Space(Indent4) + '<sfd:CropDisasterIndicator>' + valu +
    '</sfd:CropDisasterIndicator>');

  // pcodl  livestock
  If FetchElmFNo(RetNo, FNo, 950) > '' then
    valu := '1'
  else
    valu := '2';
  XmlList.add(Space(Indent4) + '<sfd:LivestockDisasterIndicator>' + valu +
    '</sfd:LivestockDisasterIndicator>');

  // contract numbers
  i := 952;
  /// 852;  20110317
  k := 1;
  Repeat
    valu := FetchElmFNo(RetNo, FNo, i);
    If FetchElmFNo(RetNo, FNo, i) > '' then
      XmlList.add(Space(Indent4) + '<sfd:ProductionInsuranceContractNumber>' +
        valu + '</sfd:ProductionInsuranceContractNumber>');
    Inc(k, 1);
    Inc(i, 1);
  until i > 957;

  // pcodc crop
  k := BuildCrop(RetNo, FNo, 859, 943, 7, 1); // page 7  //20101221
  FNo := GetFormNo('T1273A1' + '#1'); // 20130113
  If Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)] then
    BuildCrop(RetNo, FNo, 59, 143, 7, k); // additional crop
  // 20130113
  FNo := GetFormNo('T1273A1' + '#2');
  If Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)] then
    BuildCrop(RetNo, FNo, 59, 143, 7, k); // additional crop

  // unfarmable
  FNo := GetFormNo('T1273' + FInst);
  If Vl(FetchElmFNo(RetNo, FNo, 958)) + Vl(FetchElmFNo(RetNo, FNo, 959)) +
    Vl(FetchElmFNo(RetNo, FNo, 960)) + Vl(FetchElmFNo(RetNo, FNo, 961)) > 0 then
  Begin
    valu := FetchElmFNo(RetNo, FNo, 958);
    If valu > '' then
    begin
      XmlList.add(Space(Indent4) + '<sfd:CropFixedData>'); // 20120118
      XmlList.add(Space(Indent4 + 2) + '<sfd:CropTypeCode>' + '16' +
        '</sfd:CropTypeCode>');
      XmlList.add(Space(Indent4 + 2) + '<sfd:CropAcreQuantity>' +
        Format1273Numerics(valu, 3) + '</sfd:CropAcreQuantity>');
      XmlList.add(Space(Indent4) + '</sfd:CropFixedData>'); // 20120118
    end;

    valu := FetchElmFNo(RetNo, FNo, 959); // 20101221
    If valu > '' then
    begin
      XmlList.add(Space(Indent4) + '<sfd:CropFixedData>');
      XmlList.add(Space(Indent4 + 2) + '<sfd:CropTypeCode>' + '17' +
        '</sfd:CropTypeCode>');
      XmlList.add(Space(Indent4 + 2) + '<sfd:CropAcreQuantity>' +
        Format1273Numerics(valu, 3) + '</sfd:CropAcreQuantity>');
      XmlList.add(Space(Indent4) + '</sfd:CropFixedData>');
    end;

    valu := FetchElmFNo(RetNo, FNo, 960); // 20101221
    If valu > '' then
    begin
      XmlList.add(Space(Indent4) + '<sfd:CropFixedData>');
      XmlList.add(Space(Indent4 + 2) + '<sfd:CropTypeCode>' + '18' +
        '</sfd:CropTypeCode>');
      XmlList.add(Space(Indent4 + 2) + '<sfd:CropAcreQuantity>' +
        Format1273Numerics(valu, 3) + '</sfd:CropAcreQuantity>');
      XmlList.add(Space(Indent4) + '</sfd:CropFixedData>'); // 20120118
    end;

    valu := FetchElmFNo(RetNo, FNo, 961);
    If valu > '' then
    begin
      XmlList.add(Space(Indent4) + '<sfd:CropFixedData>');
      XmlList.add(Space(Indent4 + 2) + '<sfd:CropTypeCode>' + '19' +
        '</sfd:CropTypeCode>');
      XmlList.add(Space(Indent4 + 2) + '<sfd:CropAcreQuantity>' +
        Format1273Numerics(valu, 3) + '</sfd:CropAcreQuantity>');
      XmlList.add(Space(Indent4) + '</sfd:CropFixedData>'); // 20120118
    end;
    // XmlList.Add(Space(Indent4)+'</sfd:CropFixedData>');  //20120118
  end; // fixed data

  FNo := GetFormNo('T1273' + FInst);

  k := BuildLiveStock(RetNo, FNo, 807, 855, 4, 1);
  // k = last entry on main screen  //20101221

  For j := 1 to 9 do
  begin
    FNo := GetFormNo('T1273A1' + '#' + AllTrim(IntToStr(j))); // FInst;
    If FNo > 0 then
    begin
      If (Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)]) and
        ('#' + FetchElmFNo(RetNo, FNo, 3) = FInst) then
        k := BuildLiveStock(RetNo, FNo, 7, 55, 4, k); // aditional livestock
    end;
  end;

  // AL additional livestock
  FNo := GetFormNo('T1273' + FInst);
  If FgsHasData(RetNo, FNo, 1077, 1111, 1, 1) then // AL
  begin
    k := 1;
    valu := FetchElmFNo(RetNo, FNo, 1077);
    If valu > '' then
    begin
      Inc(k);
      BuildAdditionalLivestock(RetNo, FNo, '104', valu);
    end;
    valu := FetchElmFNo(RetNo, FNo, 1078);
    If valu > '' then
    begin
      Inc(k);
      BuildAdditionalLivestock(RetNo, FNo, '123', valu);
    end;
    valu := FetchElmFNo(RetNo, FNo, 1079);
    If valu > '' then
    begin
      Inc(k);
      BuildAdditionalLivestock(RetNo, FNo, '145', valu);
    end;

    valu := FetchElmFNo(RetNo, FNo, 1080);
    If valu > '' then
    begin
      Inc(k);
      BuildAdditionalLivestock(RetNo, FNo, '105', valu);
    end;
    valu := FetchElmFNo(RetNo, FNo, 1081);
    If valu > '' then
    begin
      Inc(k);
      BuildAdditionalLivestock(RetNo, FNo, '106', valu);
    end;
    valu := FetchElmFNo(RetNo, FNo, 1082);
    If valu > '' then
    begin
      Inc(k);
      BuildAdditionalLivestock(RetNo, FNo, '125', valu);
    end;
    valu := FetchElmFNo(RetNo, FNo, 1083);
    If valu > '' then
    begin
      Inc(k);
      BuildAdditionalLivestock(RetNo, FNo, '124', valu);
    end;

    valu := FetchElmFNo(RetNo, FNo, 1084);
    If valu > '' then
    begin
      Inc(k);
      BuildAdditionalLivestock(RetNo, FNo, '141', valu);
    end;
    valu := FetchElmFNo(RetNo, FNo, 1085);
    If valu > '' then
    begin
      Inc(k);
      BuildAdditionalLivestock(RetNo, FNo, '142', valu);
    end;

    valu := FetchElmFNo(RetNo, FNo, 1086);
    If valu > '' then
    begin
      Inc(k);
      BuildAdditionalLivestock(RetNo, FNo, '113', valu);
    end;
    valu := FetchElmFNo(RetNo, FNo, 1087);
    If valu > '' then
    begin
      Inc(k);
      BuildAdditionalLivestock(RetNo, FNo, '108', valu);
    end;
    valu := FetchElmFNo(RetNo, FNo, 1088);
    If valu > '' then
    begin
      Inc(k);
      BuildAdditionalLivestock(RetNo, FNo, '109', valu);
    end;
    valu := FetchElmFNo(RetNo, FNo, 1089);
    If valu > '' then
    begin
      Inc(k);
      BuildAdditionalLivestock(RetNo, FNo, '143', valu);
    end;
    valu := FetchElmFNo(RetNo, FNo, 1090);
    If valu > '' then
    begin
      Inc(k);
      BuildAdditionalLivestock(RetNo, FNo, '144', valu);
    end;
    valu := FetchElmFNo(RetNo, FNo, 1091);
    If valu > '' then
    begin
      Inc(k);
      BuildAdditionalLivestock(RetNo, FNo, '128', valu);
    end;

    BuildT1273ALI(RetNo, FNo, 1092, 1108, 4, 1); //

    For j := 1 to 9 do // productive capacity
    begin
      FNo := GetFormNo('T1273A2' + '#' + AllTrim(IntToStr(j))); // FInst;
      If FNo > 0 then
      begin
        If (Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)]) and
          ('#' + FetchElmFNo(RetNo, FNo, 3) = FInst) then
          BuildT1273ALI(RetNo, FNo, 92, 108, 4, k);
      end;
    end;
  end; // fgs has data

  // fgs PI
  FNo := GetFormNo('T1273' + FInst);
  If FgsHasData(RetNo, FNo, 1005, 1026, 3, 1) then // Purch inputs
  BEGIN
    FNo := GetFormNo('T1273' + FInst);
    k := BuildT1273PI(RetNo, FNo, 1005, 1026, 3, 1); // Purch inputs

    For j := 1 to 9 do
    begin
      FNo := GetFormNo('T1273A2' + '#' + AllTrim(IntToStr(j))); // FInst;
      If FNo > 0 then
      begin
        If (Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)]) and
          ('#' + FetchElmFNo(RetNo, FNo, 3) = FInst) then
          k := BuildT1273PI(RetNo, FNo, 5, 26, 3, k);
      end;
    end;
  END;

  // fgs DI
  FNo := GetFormNo('T1273' + FInst);
  If FgsHasData(RetNo, FNo, 1029, 1050, 3, 1) then
  BEGIN
    FNo := GetFormNo('T1273' + FInst);
    k := BuildT1273DI(RetNo, FNo, 1029, 1050, 3, 1);
    // 20130125 //page 9  //20120122 //??????? First entry no value!!!
    // k:=BuildT1273DI(RetNo,FNo,1029,1050,3,1); //page 9

    For j := 1 to 9 do
    begin
      FNo := GetFormNo('T1273A2' + '#' + AllTrim(IntToStr(j))); // FInst;
      If FNo > 0 then
      begin
        If (Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)]) and
          ('#' + FetchElmFNo(RetNo, FNo, 3) = FInst) then
          k := BuildT1273DI(RetNo, FNo, 29, 50, 3, k);
      end;
    end;
  END;

  // fgs AP
  FNo := GetFormNo('T1273' + FInst);
  If FgsHasData(RetNo, FNo, 1053, 1071, 3, 1) then
  BEGIN
    FNo := GetFormNo('T1273' + FInst);
    k := BuildT1273AP(RetNo, FNo, 1053, 1074, 3, 1);

    For j := 1 to 9 do
    begin
      FNo := GetFormNo('T1273A9' + '#' + AllTrim(IntToStr(j))); // FInst;
      If FNo > 0 then
      begin
        If (Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)]) and
          ('#' + FetchElmFNo(RetNo, FNo, 3) = FInst) then
          k := BuildT1273AP(RetNo, FNo, 53, 74, 3, k);
      end;
    end;
  END;
  XmlList.add(Space(Indent4) + '</sfd:FarmingOperationData>');
end;

Function BuildCrop(RetNo: Integer; FNo: Integer; FromElm, ToElm, ByElm: Integer;
  k: Integer): Integer;
// returns the last k used (howmany)
Var
  valu: string;
  Rec: String;
  i, unSeedElm: Integer; // 20101221
begin
  i := FromElm;
  unSeedElm := 76;
  If FromElm = 59 then
    unSeedElm := 162; // comes from T1273A1
  Repeat
    valu := FetchElmFNo(RetNo, FNo, i); // code
    If valu > '' then
    begin
      XmlList.add(Space(Indent4) + '<sfd:CropInventoryValuationData>');
      // code
      Rec := 'TIA' + ElemSep + 'E' + AddLeadingZeros(IntToStr(k), 2) + 'CD' +
        ElemSep + ElemSep + valu + LineSep + CrLf;
      XmlList.add(Space(Indent4 + 2) + '<sfd:CropTypeCode>' + valu +
        '</sfd:CropTypeCode>');

      // un
      valu := AllTrim(LeftStr(FetchElmFNo(RetNo, FNo, i + 2), 2));
      If valu > '' then
      begin
        valu := AddLeadingZeros(valu, 2); // 20120118
        XmlList.add(Space(Indent4 + 2) + '<sfd:CropMeasurementUnitCode>' + valu
          + '</sfd:CropMeasurementUnitCode>');
      end;

      // AC
      valu := Format1273Numerics(FetchElmFNo(RetNo, FNo, i + 3), 3);
      If valu > '' then
      begin
        Rec := 'TIA' + ElemSep + 'E' + AddLeadingZeros(IntToStr(k), 2) + 'AC' +
          ElemSep + ElemSep + ElemSep + valu + LineSep + CrLf;
        XmlList.add(Space(Indent4 + 2) + '<sfd:CropAcreQuantity>' + valu +
          '</sfd:CropAcreQuantity>');
      end;

      // <sfd:CropUnseedableAcreQuantity>0000</sfd:CropUnseedableAcreQuantity>
      // Unseedable  //20131222
      valu := AddLeadingZeros(Format1273Numerics(FetchElmFNo(RetNo, FNo,
        unSeedElm), 3), 4);
      // If valu >'' then
      // begin
      // Rec:= 'TIA'+ElemSep+'E'+AddLeadingZeros(IntToStr(k),2)+'AC'+ElemSep+ElemSep+ElemSep+valu+LineSep+Crlf;
      XmlList.add(Space(Indent4 + 2) + '<sfd:CropUnseedableAcreQuantity>' + valu
        + '</sfd:CropUnseedableAcreQuantity>');
      // end;

      // QP
      valu := Format1273Numerics(FetchElmFNo(RetNo, FNo, i + 4), 3);
      If valu > '' then
      begin
        Rec := 'TIA' + ElemSep + 'E' + AddLeadingZeros(IntToStr(k), 2) + 'QP' +
          ElemSep + ElemSep + ElemSep + valu + LineSep + CrLf;
        XmlList.add(Space(Indent4 + 2) + '<sfd:CropProducedQuantity>' + valu +
          '</sfd:CropProducedQuantity>');
      end;

      // EI
      valu := Format1273Numerics(FetchElmFNo(RetNo, FNo, i + 5), 3);
      If valu > '' then
      begin
        Rec := 'TIA' + ElemSep + 'E' + AddLeadingZeros(IntToStr(k), 2) + 'EI' +
          ElemSep + ElemSep + ElemSep + valu + LineSep + CrLf;

        if valu = '0' then
          valu := '0000'; // 20210106
        XmlList.add(Space(Indent4 + 2) + '<sfd:CropYearEndQuantity>' + valu +
          '</sfd:CropYearEndQuantity>');
      end;

      // MV
      valu := Format1273Numerics(FetchElmFNo(RetNo, FNo, i + 6), 2);
      If valu > '' then
      begin
        Rec := 'TIA' + ElemSep + 'E' + AddLeadingZeros(IntToStr(k), 2) + 'MV' +
          ElemSep + ElemSep + ElemSep + ElemSep + ElemSep + ElemSep + valu +
          LineSep + CrLf;
        XmlList.add(Space(Indent4 + 2) + '<sfd:CropYearEndPriceAmount>' + valu +
          '</sfd:CropYearEndPriceAmount>');
      end;
      XmlList.add(Space(Indent4) + '</sfd:CropInventoryValuationData>');
      Inc(k, 1);
    end;
    Inc(i, ByElm);
    Inc(unSeedElm); // 20131222
  until i > ToElm;
  Result := k;
end;

Function BuildLiveStock(RetNo: Integer; FNo: Integer;
  FromElm, ToElm, ByElm: Integer; k: Integer): Integer;
// returns the last k used (howmany)
Var
  valu: string;
  Rec: String;
  i: Integer;
begin
  i := FromElm;
  Repeat
    valu := FetchElmFNo(RetNo, FNo, i); // code
    If valu > '' then
    begin
      XmlList.add(Space(Indent4) + '<sfd:LivestockInventoryValuationData>');
      // code
      Rec := 'TIA' + ElemSep + 'E' + AddLeadingZeros(IntToStr(k), 2) + 'TCD' +
        ElemSep + ElemSep + valu + LineSep + CrLf;
      XmlList.add(Space(Indent4 + 2) + '<sfd:LivestockTypeCode>' + valu +
        '</sfd:LivestockTypeCode>');
      // EIL
      valu := Format1273Numerics(FetchElmFNo(RetNo, FNo, i + 2), 3);
      If valu > '' then
      begin
        Rec := 'TIA' + ElemSep + 'E' + AddLeadingZeros(IntToStr(k), 2) + 'EIL' +
          ElemSep + ElemSep + ElemSep + valu + LineSep + CrLf;
        XmlList.add(Space(Indent4 + 2) + '<sfd:LivestockYearEndQuantity>' + valu
          + '</sfd:LivestockYearEndQuantity>');
      end;

      // FMV
      valu := Format1273Numerics(FetchElmFNo(RetNo, FNo, i + 3), 2);
      If valu > '' then
      begin
        Rec := 'TIA' + ElemSep + 'E' + AddLeadingZeros(IntToStr(k), 2) + 'FMV' +
          ElemSep + ElemSep + ElemSep + ElemSep + ElemSep + ElemSep + valu +
          LineSep + CrLf;
        XmlList.add(Space(Indent4 + 2) + '<sfd:LivestockYearEndPriceAmount>' +
          valu + '</sfd:LivestockYearEndPriceAmount>');
      end;
      XmlList.add(Space(Indent4) + '</sfd:LivestockInventoryValuationData>');
      Inc(k, 1);
    end;
    Inc(i, ByElm);
  until i > ToElm;
  Result := k;
end;

Function Format1273Numerics(S: String; DecimalPlaces: Integer): String;
// comes as 123 or 1234.56  Needs 2 or 3 three decimals implied
var
  s1, s2: String;
begin
  s1 := ExtractIntegerPart(S);
  s2 := ExtractDecimalPart(S);
  Result := s1 + PaddRZero(s2, DecimalPlaces);
  Result := RmvLeadingZeros(Result);
  If Result = '' then
    Result := '0';
end;

Procedure BuildAdditionalLivestock(RetNo: Integer; FNo: Integer; Line: String;
  valu: String);
Var
  Rec: String;
begin
  valu := Format1273Numerics(valu, 3);
  Line := RmvLeadingZeros(Line); // 20120118
  Rec := 'TIA' + ElemSep + Line + ElemSep + ElemSep + ElemSep + valu +
    LineSep + CrLf;
  XmlList.add(Space(Indent4) + '<sfd:LivestockProductiveCapacityData>');
  XmlList.add(Space(Indent4 + 2) + '<sfd:LivestockTypeCode>' + Line +
    '</sfd:LivestockTypeCode>');
  XmlList.add(Space(Indent4 + 2) + '<sfd:LivestockQuantity>' + valu +
    '</sfd:LivestockQuantity>');
  XmlList.add(Space(Indent4) + '</sfd:LivestockProductiveCapacityData>');
end;

Procedure BuildT1273ALI(RetNo: Integer; FNo: Integer;
  FromElm, ToElm, ByElm, k: Integer);
Var
  i: Integer;
  valu, Rec: String;
begin
  i := FromElm;
  Repeat
    valu := FetchElmFNo(RetNo, FNo, i); // code
    If valu > '' then { code }
    begin
      // Valu:=AddLeadingZeros(Valu,4);
      valu := RmvLeadingZeros(valu); // 20120118
      Rec := 'TIA' + ElemSep + 'OTH' + ElemSep + ElemSep + valu + ElemSep +
        Format1273Numerics(FetchElmFNo(RetNo, FNo, i + 3), 3) + LineSep + CrLf;
      // 20111230
      XmlList.add(Space(Indent4) + '<sfd:LivestockProductiveCapacityData>');
      XmlList.add(Space(Indent4 + 2) + '<sfd:LivestockTypeCode>' + valu +
        '</sfd:LivestockTypeCode>');
      XmlList.add(Space(Indent4 + 2) + '<sfd:LivestockQuantity>' +
        Format1273Numerics(FetchElmFNo(RetNo, FNo, i + 3), 3) +
        '</sfd:LivestockQuantity>');
      XmlList.add(Space(Indent4) + '</sfd:LivestockProductiveCapacityData>');
    end;
    Inc(i, ByElm);
  until i > ToElm;
end;

Function BuildT1273PI(RetNo: Integer; FNo: Integer;
  FromElm, ToElm, ByElm, k: Integer): Integer;
Var
  valu: string;
  Rec: String;
  i: Integer; // 20101221
begin
  i := FromElm;
  Repeat
    valu := FetchElmFNo(RetNo, FNo, i); // code
    If valu > '' then
    begin
      XmlList.add(Space(Indent4) + '<sfd:PurchasedInputData>');
      valu := AddLeadingZeros(valu, 4);
      // SI, code, ending
      Rec := 'TIA' + ElemSep + 'E' + IntToStr(k) + 'PI' + ElemSep + ElemSep +
        AddLeadingZeros(valu, 3) + ElemSep + ElemSep + ElemSep + ElemSep +
        ExtractIntegerPart(FetchElmFNo(RetNo, FNo, i + 2)) + LineSep + CrLf;
      // leading zeros?
      XmlList.add(Space(Indent4 + 2) + '<sfd:PurchasedInputTypeCode>' +
        FetchElmFNo(RetNo, FNo, i) + '</sfd:PurchasedInputTypeCode>');
      XmlList.add(Space(Indent4 + 2) + '<sfd:PurchasedInputYearEndAmount>' +
        ExtractIntegerPart(FetchElmFNo(RetNo, FNo, i + 2)) +
        '</sfd:PurchasedInputYearEndAmount>');
      XmlList.add(Space(Indent4) + '</sfd:PurchasedInputData>');
      Inc(k, 1);
    end;
    Inc(i, ByElm);
  until i > ToElm;
  Result := k;
end;

Function BuildT1273DI(RetNo: Integer; FNo: Integer;
  FromElm, ToElm, ByElm, k: Integer): Integer;
Var
  valu: string;
  Rec: String;
  i: Integer; // 20101221
begin
  i := FromElm;
  Repeat
    valu := FetchElmFNo(RetNo, FNo, i); // code
    If (valu > '') and (FetchElmFNo(RetNo, FNo, i + 2) > '')
    // amount  //20130125
    then
    begin
      XmlList.add(Space(Indent4) + '<sfd:DeferredIncomeReceivableData>');
      // SI, code, ending
      valu := AddLeadingZeros(valu, 4);
      Rec := 'TIA' + ElemSep + 'E' + IntToStr(k) + 'DI' + ElemSep + ElemSep +
        AddLeadingZeros(valu, 3) + ElemSep + ElemSep + ElemSep + ElemSep +
        ExtractIntegerPart(FetchElmFNo(RetNo, FNo, i + 2)) + LineSep + CrLf;
      XmlList.add(Space(Indent4) + '<sfd:DeferredIncomeReceivableTypeCode>' +
        FetchElmFNo(RetNo, FNo, i) + '</sfd:DeferredIncomeReceivableTypeCode>');
      XmlList.add(Space(Indent4) + '<sfd:DeferredIncomeReceivableYearEndAmount>'
        + ExtractIntegerPart(FetchElmFNo(RetNo, FNo, i + 2)) +
        '</sfd:DeferredIncomeReceivableYearEndAmount>');
      XmlList.add(Space(Indent4) + '</sfd:DeferredIncomeReceivableData>');
      Inc(k, 1);
    end;
    Inc(i, ByElm);
  until i > ToElm;
  Result := k;
end;

Function BuildT1273AP(RetNo: Integer; FNo: Integer;
  FromElm, ToElm, ByElm, k: Integer): Integer;
Var
  valu: string;
  Rec: String;
  i: Integer; // 20101221
begin
  i := FromElm;
  Repeat
    valu := FetchElmFNo(RetNo, FNo, i); // code
    If valu > '' then
    begin
      XmlList.add(Space(Indent4) + '<sfd:AccountsPayableData>');
      valu := AddLeadingZeros(valu, 4);
      XmlList.add(Space(Indent4) + '<sfd:AccountsPayableTypeCode>' +
        FetchElmFNo(RetNo, FNo, i) + '</sfd:AccountsPayableTypeCode>');
      XmlList.add(Space(Indent4) + '<sfd:AccountsPayableYearEndAmount>' +
        ExtractIntegerPart(FetchElmFNo(RetNo, FNo, i + 2)) +
        '</sfd:AccountsPayableYearEndAmount>');
      XmlList.add(Space(Indent4) + '</sfd:AccountsPayableData>');
      Inc(k, 1);
    end;
    Inc(i, ByElm);
  until i > ToElm;
  Result := k;
end;

Procedure BuildDtlN1550(RetNo: Integer; SIN: String);
Var
  Rec: String;
begin
  Rec := 'N1' + ElemSep + '2K' + ElemSep + ElemSep + '50' + ElemSep + SIN +
    LineSep + CrLf;
  If AllTrim(SIN) > '' then // 20141216
    XmlList.add(Space(Indent4) + '<sfd:PartnerPIN>' + SIN +
      '</sfd:PartnerPIN>');
  Inc(SegmentCnt);
end;

Procedure BuildDtlIN2570(RetNo: Integer; PFirstNm, PLastNm: String);
Var
  Rec: String;
begin
  If AllTrim(PLastNm) > '' then
  // if there is last nm then firstnm s/b transmitted
  begin
    PFirstNm := AllTrim(PFirstNm);
    // 20100123
    If PFirstNm > '' then
    begin
      Rec := 'IN2' + ElemSep + '02' + ElemSep + PFirstNm + LineSep + CrLf;
      XmlList.add(Space(Indent4) + '<comm:GivenName>' +
        ReplaceReservedXMLCharacters(PFirstNm) + '</comm:GivenName>');
      Inc(SegmentCnt);
    end;
  end;
  PLastNm := AllTrim(PLastNm); // 20111204
  If PLastNm > '' then
  begin
    Rec := 'IN2' + ElemSep + '05' + ElemSep + AllTrim(PLastNm) + LineSep + CrLf;
    XmlList.add(Space(Indent4) + '<comm:FamilyName>' +
      ReplaceReservedXMLCharacters(PLastNm) + '</comm:FamilyName>');
    Inc(SegmentCnt);
  end;
end;

Procedure BuildDtlTIA600(RetNo: Integer; PPerCent: String);
Var
  Rec: String;
begin
  Rec := 'TIA' + ElemSep + 'POP' + ElemSep + ElemSep + ElemSep + ElemSep +
    ElemSep + PPerCent + LineSep + CrLf;
  XmlList.add(Space(Indent4) + '<sfd:PartnerBusinessOwnershipPercent>' +
    PPerCent + '</sfd:PartnerBusinessOwnershipPercent>');
  Inc(SegmentCnt);
end;

Procedure BuildLineValues(RetNo: Integer; LLineString: String; S: String);
Var
  Rec: String;
begin
  Rec := 'TIA' + ElemSep + LLineString + ElemSep + S + LineSep { 3 }
    + CrLf;
  If myStrToInt(LLineString) > 0 then // 20111209

    XmlList.add(Space(Indent4) + '<comm:ReturnLine>' + Chr(13) + Space(Indent5)
      // jz 20240507
      + '<comm:FieldCode>' + LLineString + '</comm:FieldCode>' + Chr(13) +
      Space(Indent5) // jz 20240507
      + '<comm:FieldValue>' + S + '</comm:FieldValue>' + Chr(13) +
      // jz 20240507
      Space(Indent4) + '</comm:ReturnLine>'); // jz 20240507

  // XmlList.add(Space(Indent4) + '<comm:ReturnLine>' + '<comm:FieldCode>' +
  // LLineString + '</comm:FieldCode>' + '<comm:FieldValue>' + S +
  // '</comm:FieldValue>' + '</comm:ReturnLine>');
  Inc(SegmentCnt);
end;

Procedure BuildSfdLineValues(RetNo: Integer; LLineString: String; S: String);
Var
  Rec: String;
begin
  //20250110
  If myStrToInt(LLineString) > 0 then // 20111209
    XmlList.add(Space(Indent4) + '<sfd:Commodity>'
    +Chr(13)+Space(Indent4)+'<sfd:CommodityCode>' + LLineString + '</sfd:CommodityCode>'
    +Chr(13)+Space(Indent4)+'<sfd:CommodityAmount>' + S +'</sfd:CommodityAmount>'
    +Chr(13)+Space(Indent4)+'</sfd:Commodity>');
  Inc(SegmentCnt);
end;

Procedure BuildDtlTIA1180(RetNo: Integer; LLineString: String; S: String);
Var
  Rec: String;
begin
  Rec := 'TIA' + ElemSep + LLineString + ElemSep + S + LineSep { 3 }
    + CrLf;
  XmlList.add(Space(Indent4) + Rec);
  Inc(SegmentCnt);
end;

Procedure BuildDtlTFS900(RetNo: Integer);
Var
  Rec: String;
Begin
  Rec := 'TFS' + ElemSep + 'ZZ' + ElemSep + 'EXC' + ElemSep + '55' + ElemSep +
    AllTrim(IntToStr(SfdNo)) + LineSep + CrLf;
  XmlList.add(Space(Indent4) + Rec);
  Inc(SegmentCnt);
end;

Procedure BuildDtlFGS850(RetNo: Integer);
Var
  Rec: String;
Begin
  Rec := 'FGS' + ElemSep + 'PP' + LineSep + CrLf;
  XmlList.add(Space(Indent4) + Rec);
  Inc(SegmentCnt);
end;

Procedure BuildDtlN3470(RetNo: Integer; BUSADDRESS, BUSPOSTAL: String);
Var
  Rec: String;
begin
  If AllTrim(BUSADDRESS) + AllTrim(BUSPOSTAL) > '' then
  begin
    Rec := 'N3' + ElemSep + AllTrim(BUSADDRESS) + ElemSep + AllTrim(BUSPOSTAL) +
      LineSep + CrLf;
    XmlList.add(Space(Indent4) + '<sfd:BusinessAddress>');
    XmlList.add(Space(Indent4) + '<comm:BusinessAddressStreetText>' +
      ReplaceReservedXMLCharacters(LeftStr(AllTrim(BUSADDRESS), 30)) +
      '</comm:BusinessAddressStreetText>');
    XmlList.add(Space(Indent4) + '<comm:BusinessAddressPostalCode>' +
      AllTrim(BUSPOSTAL) + '</comm:BusinessAddressPostalCode>');
    XmlList.add(Space(Indent4) + '</sfd:BusinessAddress>');
    Inc(SegmentCnt);
  end;
end;

Function FgsHasData(RetNo: Integer; FNo: Integer;
  FromElm, ToElm, ByElm, k: Integer): boolean;
Var
  valu: string;
  Rec: String;
  i: Integer;
begin
  Result := False;
  i := FromElm;
  Repeat
    valu := FetchElmFNo(RetNo, FNo, i); // code
    If valu > '' then
    begin
      Result := True;
      Break;
    end;
    Inc(i, ByElm);
  until i > ToElm;
end;

Procedure BuildT777(RetNo: Integer; FInst: String);
Var
  i, LLine, ElmNo, Rule: Integer;
  LType: string[1];
  S: string;
  FName: string[12];
begin
  If IsPreBankruptcyReturn(RetNo) then
    exit;
  SFD.RECTYPE := '03';
  SFD.SEQNO := Fx.SEQNO;
  SfdRecNumber := SfdRecNumber + 1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber), 2);
  SFD.BUSTYPE := '7';
  SFD.SIN := RemoveHyphens(FetchElm(RetNo, 'INFO', 3));

  EFlines := TStringList.Create;
  EFlines.LoadFromFile(AppDir + '\' + 'EFT777.D');

  { Free format SFD fot t777 }
  { 12345678901234567890123
    {Format nnnn $ fffffffff elm rrr }
  For i := 0 to EFlines.Count - 1 do
  begin
    // ShowMessage(Eflines[i]);
    LLine := myStrToInt(LeftStr(EFlines[i], 4));
    LType := MidStr(EFlines[i], 6, 1);
    FName := AllTrim(MidStr(EFlines[i], 8, 9)) + FInst; // +FInst;  //20200519
    ElmNo := myStrToInt(MidStr(EFlines[i], 17, 3));
    If MidStr(EFlines[i], 22, 3) = '' then
      Rule := 0
    else
      Rule := myStrToInt(MidStr(EFlines[i], 22, 3));
    S := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
    If S > '' then
      BuildLineValues(RetNo, AllTrim(IntToStr(LLine)), S); // 20111209
  end;
  EFlines.Free;
end;

(*
  Procedure BuildT777S(RetNo: Integer; FInst: String);
  Var
  i, LLine, ElmNo, Rule: Integer;
  LType: string[1];
  S: string;
  FName: string[12];
  begin
  If IsPreBankruptcyReturn(RetNo) then
  exit;
  SFD.RECTYPE := '13'; // 2022122
  SFD.SEQNO := Fx.SEQNO;
  SfdRecNumber := SfdRecNumber + 1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber), 2);
  SFD.BUSTYPE := '13'; // 20221226
  SFD.SIN := RemoveHyphens(FetchElm(RetNo, 'INFO', 3));

  EFlines := TStringList.Create;
  EFlines.LoadFromFile(AppDir + '\' + 'EFT777S.D');

  { Free format SFD fot t777 }
  { 12345678901234567890123
  {Format nnnn $ fffffffff elm rrr }
  For i := 0 to EFlines.Count - 1 do
  begin
  // ShowMessage(Eflines[i]);
  LLine := myStrToInt(LeftStr(EFlines[i], 4));
  LType := MidStr(EFlines[i], 6, 1);
  FName := AllTrim(MidStr(EFlines[i], 8, 9)) + FInst; // +FInst;  //20200519
  ElmNo := myStrToInt(MidStr(EFlines[i], 17, 3));
  If MidStr(EFlines[i], 22, 3) = '' then
  Rule := 0
  else
  Rule := myStrToInt(MidStr(EFlines[i], 22, 3));
  S := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
  If S > '' then
  BuildLineValues(RetNo, AllTrim(IntToStr(LLine)), S); // 20111209
  end;
  EFlines.Free;
  end;
*)
Procedure BuildTL2(RetNo: Integer; FInst: String);
Var
  i, LLine, ElmNo, Rule: Integer;
  LType: string[1];
  S: string;
  FName: string[12];
begin
  SFD.RECTYPE := '03';
  SFD.SEQNO := Fx.SEQNO;
  SfdRecNumber := SfdRecNumber + 1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber), 2);
  SFD.BUSTYPE := '8';
  SFD.SIN := RemoveHyphens(FetchElm(RetNo, 'INFO', 3));

  EFlines := TStringList.Create;
  EFlines.LoadFromFile(AppDir + '\' + 'EFTL2.D');

  { Free format SFD fot tl2 }
  { 12345678901234567890123
    {Format nnnn $ fffffffff elm rrr }
  For i := 0 to EFlines.Count - 1 do
  begin
    LLine := myStrToInt(LeftStr(EFlines[i], 4));
    LType := MidStr(EFlines[i], 6, 1);
    FName := AllTrim(MidStr(EFlines[i], 8, 9)) + FInst;
    // FName := AllTrim(MidStr(Eflines[i],8,9));
    ElmNo := myStrToInt(MidStr(EFlines[i], 17, 3));
    If MidStr(EFlines[i], 22, 3) = '' then
      Rule := 0
    else
      Rule := myStrToInt(MidStr(EFlines[i], 22, 3));
    S := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
    If S > '' then
      BuildLineValues(RetNo, AllTrim(IntToStr(LLine)), S); // 20111209
  end;
  EFlines.Free;
end;

Procedure BuildT2091(RetNo: Integer; FInst: String);
Var
  i, LLine, ElmNo, Rule: Integer;
  LType: string[1];
  S: string;
  FName: string[12];
  FNo: Integer; // 20180116
begin
  SFD.RECTYPE := '11';
  SFD.SEQNO := Fx.SEQNO;
  SfdRecNumber := SfdRecNumber + 1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber), 2);
  SFD.BUSTYPE := '11';
  SFD.SIN := RemoveHyphens(FetchElm(RetNo, 'INFO', 3));
  FNo := GetFormNo('T2091' + FInst);
  // 201801
  if FNo > 0 then
  Begin
    XmlList.add(Space(Indent3) + '<sfd:DesignationPropertyAddress>');
    XmlList.add(Space(Indent3) + '<comm:AddressStreetText>' +
      ReplaceReservedXMLCharacters(AllTrim(FetchElmFNo(RetNo, FRec.FormNo, 1)))
      + '</comm:AddressStreetText>'); // 20200601
    XmlList.add(Space(Indent3) + '<comm:AddressMunicipalityName>' +
      FetchElmFNo(RetNo, FRec.FormNo, 21) + '</comm:AddressMunicipalityName>');
    XmlList.add(Space(Indent3) + '<sfd:ProvinceTerritoryStateCode>' +
      FetchElmFNo(RetNo, FRec.FormNo, 19) +
      '</sfd:ProvinceTerritoryStateCode>');
    XmlList.add(Space(Indent3) + '<sfd:PostalZipCode>' +
      ReplaceChar(FetchElmFNo(RetNo, FRec.FormNo, 20), ' ', '') +
      '</sfd:PostalZipCode>');
    XmlList.add(Space(Indent3) + '<sfd:CountryCode>' + FetchElmFNo(RetNo,
      FRec.FormNo, 22) + '</sfd:CountryCode>');
    XmlList.add(Space(Indent3) + '</sfd:DesignationPropertyAddress>');
  end;

  EFlines := TStringList.Create;
  EFlines.LoadFromFile(AppDir + '\' + 'EFT2091.D');

  { Free format SFD fot t2091 }
  { 12345678901234567890123
    {Format nnnn $ fffffffff elm rrr }
  For i := 0 to EFlines.Count - 1 do
  begin
    LLine := myStrToInt(LeftStr(EFlines[i], 4));
    LType := MidStr(EFlines[i], 6, 1);
    FName := AllTrim(MidStr(EFlines[i], 8, 9)) + FInst;
    ElmNo := myStrToInt(MidStr(EFlines[i], 17, 3));
    If MidStr(EFlines[i], 22, 3) = '' then
      Rule := 0
    else
      Rule := myStrToInt(MidStr(EFlines[i], 22, 3));
    S := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
    If S > '' then
      BuildLineValues(RetNo, AllTrim(IntToStr(LLine)), S); // 20111209
  end;
  EFlines.Free;
end;

Procedure BuildT1255(RetNo: Integer; FInst: String);
Var
  i, LLine, ElmNo, Rule: Integer;
  LType: string[1];
  S: string;
  FName: string[12];
  FNo: Integer; // 20180116
begin
  SFD.RECTYPE := '11';
  SFD.SEQNO := Fx.SEQNO;
  SfdRecNumber := SfdRecNumber + 1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber), 2);
  SFD.BUSTYPE := '11';
  SFD.SIN := RemoveHyphens(FetchElm(RetNo, 'INFO', 3));
  FNo := GetFormNo('T1255' + FInst);
  // 201801
  if FNo > 0 then
  Begin
    XmlList.add(Space(Indent3) + '<sfd:DesignationPropertyAddress>');
    XmlList.add(Space(Indent3) + '<comm:AddressStreetText>' +
      ReplaceReservedXMLCharacters(AllTrim(FetchElmFNo(RetNo, FRec.FormNo, 1)))
      + '</comm:AddressStreetText>'); // 20200601
    XmlList.add(Space(Indent3) + '<comm:AddressMunicipalityName>' +
      FetchElmFNo(RetNo, FRec.FormNo, 21) + '</comm:AddressMunicipalityName>');
    XmlList.add(Space(Indent3) + '<sfd:ProvinceTerritoryStateCode>' +
      FetchElmFNo(RetNo, FRec.FormNo, 19) +
      '</sfd:ProvinceTerritoryStateCode>');
    XmlList.add(Space(Indent3) + '<sfd:PostalZipCode>' +
      ReplaceChar(FetchElmFNo(RetNo, FRec.FormNo, 20), ' ', '') +
      '</sfd:PostalZipCode>');
    XmlList.add(Space(Indent3) + '<sfd:CountryCode>' + FetchElmFNo(RetNo,
      FRec.FormNo, 22) + '</sfd:CountryCode>');
    XmlList.add(Space(Indent3) + '</sfd:DesignationPropertyAddress>');
  end;

  EFlines := TStringList.Create;
  EFlines.LoadFromFile(AppDir + '\' + 'EFT1255.D');

  { Free format SFD fot t2091 }
  { 12345678901234567890123
    {Format nnnn $ fffffffff elm rrr }
  For i := 0 to EFlines.Count - 1 do
  begin
    LLine := myStrToInt(LeftStr(EFlines[i], 4));
    LType := MidStr(EFlines[i], 6, 1);
    FName := AllTrim(MidStr(EFlines[i], 8, 9)) + FInst;
    ElmNo := myStrToInt(MidStr(EFlines[i], 17, 3));
    If MidStr(EFlines[i], 22, 3) = '' then
      Rule := 0
    else
      Rule := myStrToInt(MidStr(EFlines[i], 22, 3));
    S := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule);
    If S > '' then
      BuildLineValues(RetNo, AllTrim(IntToStr(LLine)), S); // 20111209
  end;
  EFlines.Free;
end;

Procedure PrepareT1Rec(RetNo: Integer; ProdOrTest: String;
  OnLineMethod: String);
Var
  i, Rule, LLine, ElmNo: Integer;
  LType: string[1];
  FName: string[12];
  S: string;
  LLineString: String[4];
Begin
  // If OnLineMethod='EOL' then DcnSeqNo:=GetDcnSeqNoEOL(RetNo,OnLineNo);  //20111208
  // EmptyTheBuffers;

  SfdRecNumber := 0;
  { FIXED PART }
  Fx.RECTYPE := '02';
  Fx.PREPARERNO := OptRec.Ef_PrepNo;
  Fx.PREPPSWD := OptRec.Ef_PsWord;
  If FetchElm(RetNo, 'INFO', 102) > '' then { discounted return } // 20120213
    Fx.DISCNUMBER := OptRec.Prp_DiscNo
  ELSE
    Fx.DISCNUMBER := ''; // '00000000'; //20191222
  Fx.SIN := RemoveHyphens(FetchElm(RetNo, 'T1', 3));
  Fx.SEQNO := LeftStr(Fx.SIN, 8);
  Fx.BIRTHYYYY := PaddZero(LeftStr(FetchElm(RetNo, 'T1', 9), 4), 4);
  Fx.BIRTHMM := PaddZero(MidStr(FetchElm(RetNo, 'T1', 9), 6, 2), 2);
  Fx.BIRTHDD := PaddZero(RightStr(FetchElm(RetNo, 'T1', 9), 2), 2);

  Fx.PRVOFRES := Ret[RetNo].PROVINCE;
  Fx.PRVOFTAX := Ret[RetNo].PROVINCE;
  Fx.MARSTATUS := IntToStr(Ret[RetNo].MARSTATUS);
  Fx.SPOUSESIN := FetchElm(RetNo, 'INFO', 4);
  IF AllTrim(Fx.SPOUSESIN) = '' THEN
    Fx.SPOUSESIN := '000000000';
  Fx.SPOUSENAME := FetchElm(RetNo, 'INFO', 20);

  Fx.FIRSTNAME := FetchElm(RetNo, 'T1', 2);
  Fx.SECONDNAME := FetchElm(RetNo, 'T1INFO', 235); // jz 20240223
  Fx.LASTNAME := LeftStr(FetchElm(RetNo, 'T1', 5), 30);

  // jz 20240209 <<<

  Fx.FirstTimeFiler := False;

  If IsFirstTimeFiler(RetNo) = True then
  // UpperCase(FetchElm(RetNo, 'INFO', 139)) > '' then 20240209 CON
    Fx.FirstTimeFiler := True;

  // jz 20240223<<<
  if Fx.FirstTimeFiler then
  begin
    if Fx.FIRSTNAME = '' then
      Fx.FIRSTNAME := 'X';
    if Fx.SECONDNAME = '' then
      Fx.SECONDNAME := 'X';
    If Fx.LASTNAME = '' then
      Fx.LASTNAME := 'X';
  end;
  // jz 20240223>>>

  // ReplaceReservedXmlCharacters(LeftStr(FetchElm(RetNo,'T1',5),30));
  Fx.CAREOFNAME := ReplaceReservedXMLCharacters
    (LeftStr(FetchElm(RetNo, 'INFO', 8), 26)); // 20220117
  // FetchElm(RetNo,'T1',8);   //        //ReplaceReservedXMLCharacters(FetchElm(RetNo,'T1',8)); //),'&','&amp;', [rfReplaceAll]);  //20120206
  Fx.STREET := GetStreet(RetNo);
  Fx.CITY := FetchElm(RetNo, 'T1', 10);
  If Length(FetchElm(RetNo, 'T1', 14)) = 2 then
    Fx.PROVINCE := FetchElm(RetNo, 'T1', 14)
  else
    Fx.PROVINCE := GetShortPrv(FetchElm(RetNo, 'T1', 14));
  Fx.POSTAL := MTrim(FetchElm(RetNo, 'T1', 15));
  If FetchElm(RetNo, 'INFO', 169) > '' then
    Fx.PROVCHANGE := '1'
  Else
    Fx.PROVCHANGE := '2';

  If FetchElm(RetNo, 'INFO', 171) > '' then
    Fx.PROVDATECHANGE := FetchElm(RetNo, 'INFO', 171)
  Else
    Fx.PROVDATECHANGE := '';

  Fx.CLAREA := FetchElm(RetNo, 'T1', 441); // 20120213
  Fx.CLPHONE := RemoveHyphens(MTrim(FetchElm(RetNo, 'T1', 442)));
  // 20120213 // PaddZero(RemoveHyphens(MTrim(FetchElm(RetNo,'T1',442))),7);

  (* //29221230
    //20191221
    If UpperCase(FetchElm(RetNo,'INFO',56)) > '' then  {changed name}  //20191227
    FX.NAMECHANGE := '2'
    Else
    FX.NAMECHANGE := '1';
  *)

  (* 20191221
    If UpperCase(FetchElm(RetNo,'INFO',56)) > '' then  {changed name}  //20120215
    FX.NAMECHANGE := '2'
    else
    FX.NAMECHANGE := '1';  //''; //20151203 //FX.NAMECHANGE := '1';  //''; //20151203
  *)

  Fx.Email := FetchElm(RetNo, 'INFO', 64);

  Fx.ALTADDR := '00'; // 20170101 GetAlternateAddressCode(RetNo);

  If FetchElm(RetNo, 'INFO', 34) > '' then
    Fx.LANGUAGE := '1'
  else
    Fx.LANGUAGE := '2';


  //If Vl(FetchElm(RetNo, 'INFO', 19)) <> 0 then // 20111206
  //jz//20250225 - negative SpouseNetIncomeAmount gives 149r error
  //jz//20250227 - only have amount if positive so operator in if from '<>' to '>'
  If Vl(FetchElm(RetNo, 'INFO', 19)) > 0 then
    Fx.SPOUSENETINC := NoDecimal(FetchElm(RetNo, 'INFO', 19))
  else
    Fx.SPOUSENETINC := '0';

  If (Ret[RetNo].MARSTATUS > 2) then // 20110222
  Begin
    If (FetchElm(RetNo, 'INFO', 120) = '') // no separation
      and (FetchElm(RetNo, 'INFO', 65) = '') // no death
      and (FetchElm(RetNo, 'INFO', 39) = '') // no mar status change
    then
      Fx.SPOUSENETINC := '0'; // '000000000'; //no separation  //20120221
  end;

  If Vl(FetchElm(RetNo, 'INFO', 131)) > 0 then
    Fx.SPOUSEUCCB := NoDecimal(FloatToStr(Vl(FetchElm(RetNo, 'INFO', 131))))
    // 20111206 AllTrim(NoDecimal(FloatToStr(Vl(FetchElm(RetNo,'INFO',131)))));   //20111206
  else
    Fx.SPOUSEUCCB := '0'; // 20180110 //2011109//fx.SpouseUccb:='';  //2011109
  If Vl(FetchElm(RetNo, 'INFO', 162)) > 0 then
    Fx.SPOUSEUCCBRepay :=
      AllTrim(NoDecimal(FloatToStr(Vl(FetchElm(RetNo, 'INFO', 162)))))
  else
    Fx.SPOUSEUCCBRepay := '0'; // 20180110 instead of Nil

  If FetchElm(RetNo, 'INFO', 36) > '' then
    Fx.SpouseSelfEmpl := '1'
  else
    Fx.SpouseSelfEmpl := '0';

  If FetchElm(RetNo, 'INFO', 24) > '' then // 20120305
  begin
    Fx.ISDECEASED := '1';
    Fx.DATEOFDEATH := FetchElm(RetNo, 'INFO', 24);
  end
  else
  begin
    Fx.ISDECEASED := '0';
    Fx.DATEOFDEATH := '';
  end;

  // 20170101
  If FetchElm(RetNo, 'INFO', 259) > '' then // 20120305
    Fx.ElectionToTaxDeceasedBeneficiaryIndicator := '1'
  else
    Fx.ElectionToTaxDeceasedBeneficiaryIndicator := '0';

  If IsPreBankruptcyReturn(RetNo) then
  begin
    Fx.ISPREBANKRUPT := '1';
    if Vl(FetchElm(RetNo, 'BANKRPT', 13)) > 0 then // 20180104
      Fx.POSTBANKRUPTNI :=
        NoDecimal(FloatToStr(Vl(FetchElm(RetNo, 'BANKRPT', 13))))
    Else
      Fx.POSTBANKRUPTNI :=
        NoDecimal(FloatToStr(Vl(FetchElm(RetNo, 'BANKRPT', 13))));
    // 20180110 //PaddZero(NoDecimal(FloatToStr(Vl(FetchElm(RetNo,'BANKRPT',13)))),9);
    Fx.DATEOFBANKRUPTCY := FetchElm(RetNo, 'BANKRPT', 1);

    if Vl(FetchElm(RetNo, 'BANKRPT', 22)) > 0 then // 20180110
      Fx.POSTBANKRUPTAdjustedNI :=
        NoDecimal(FloatToStr(Vl(FetchElm(RetNo, 'BANKRPT', 22))))
    Else
      Fx.POSTBANKRUPTAdjustedNI := '0';
    // 20200101; //20191213;//'0'; //NoDecimal(FloatToStr(Vl(FetchElm(RetNo,'BANKRPT',22)))),9);
  end
  else
  begin
    Fx.ISPREBANKRUPT := '0';
    Fx.POSTBANKRUPTNI := '000000000';
    Fx.DATEOFBANKRUPTCY := ''; // 20111206 '00000000';
  end;

  Fx.SFDRECS := PaddZero(IntToStr(SFDRECS), 2);
  Fx.DEVELOPER := DeveloperCode; // '064'; //DEVELOPER;  //20111204

  Fx.SOFTCODE := SoftCodeSuffix;
  if IsForRefile(RetNo) then
    Fx.SOFTCODE := 'R'; // 20170418

  // 20190126
  Fx.SOFTRELEASE := EfileSoftReleaseDate; // 20231221 SoftReleaseDate;
  If FetchElm(RetNo, 'T1', 36) > '' then
    Fx.FDEADLINE := '1'
  else
    Fx.FDEADLINE := '0';

  If UpperCase(FetchElm(RetNo, 'INFO', 191)) = 'X' then
    Fx.CLAUTHORIZE := '1'
  else
    Fx.CLAUTHORIZE := '0';

  Fx.AUTHORIZEEXPIRY := ''; //jz//20250308 - needs init to clear old data
  If FetchElm(RetNo, 'INFO', 192) > '' then
    Fx.AUTHORIZEEXPIRY := FetchElm(RetNo, 'INFO', 192); // 20191212

  // 20200126  used second half in 2018
  Fx.NOARetrievalAuth := '0'; // 0 = no, 1 = yes
  // Box 3
  if (FetchElm(RetNo, 'T183', 18)) > '' then
    Fx.NOARetrievalAuth := '1'; // Preparer will receive  //2019020

  Fx.PREASSESSMENT := '0';
  If FetchElm(RetNo, 'INFO', 105) > '' then
    Fx.PREASSESSMENT := '2'
  Else If FetchElm(RetNo, 'INFO', 106) > '' then
    Fx.PREASSESSMENT := '3';

  Fx.POSTASSESSMENT := '0';
  // If FetchElm(RetNo,'INFO',133) >'' then FX.POSTASSESSMENT:='1'    //20131203
  If FetchElm(RetNo, 'INFO', 134) > '' then
    Fx.POSTASSESSMENT := '2'
  Else If FetchElm(RetNo, 'INFO', 135) > '' then
    Fx.POSTASSESSMENT := '3';

  if FetchElm(RetNo, 'INFO', 164) + FetchElm(RetNo, 'INFO', 165) = '' then
    // 20220105
    Fx.CANCITIZEN := '0'
  Else
  Begin
    If FetchElm(RetNo, 'INFO', 164) > '' then
      Fx.CANCITIZEN := '1'
    else
      Fx.CANCITIZEN := '2';
  End;

  // 20220105
  If UpperCase(FetchElm(RetNo, 'T1', 43)) > '' then
    Fx.ElectionsCanada := '01'
  else If UpperCase(FetchElm(RetNo, 'T1', 44)) > '' then
    Fx.ElectionsCanada := '02';

  Fx.FNCValue := '';
  Fx.FNCValue := GetFncValue(RetNo);

  If GetFirstNationNumber(RetNo) > '' then
    Fx.FIRSTNation := GetFirstNationNumber(RetNo)
  else
    Fx.FIRSTNation := ''; // 20111206 '00000';

  // 20170108
  Fx.CitizenFN := '';
  If (Ret[RetNo].PROVINCE = 'YT') or (Ret[RetNo].PROVINCE = 'NT') // 20170108
  then
  Begin
    If FetchElm(RetNo, 'INFO', 23) > '' then
      Fx.CitizenFN := '1'
    Else
      Fx.CitizenFN := '2';
  end;

  // 20121219
  If FetchElm(RetNo, 'INFO', 171) > '' then
    Fx.ProvEffectiveDate := FetchElm(RetNo, 'INFO', 171)
  else
    Fx.ProvEffectiveDate := '';

  Fx.PresentPrv := FetchElm(RetNo, 'INFO', 66);
  Fx.SelfEmplPrv := FetchElm(RetNo, 'INFO', 21);
end;

Function GetAlternateAddressCode(RetNo: Integer): String;
Begin
  Result := '00';
  If FetchElm(RetNo, 'INFO', 95) > '' then
    Result := '00'
  Else If FetchElm(RetNo, 'INFO', 96) > '' then
    Result := '01'
  Else If FetchElm(RetNo, 'INFO', 97) > '' then
    Result := '02'
  Else If FetchElm(RetNo, 'INFO', 98) > '' then
    Result := '03'
  Else If FetchElm(RetNo, 'INFO', 99) > '' then
    Result := '04';
  If IsHomeUse then
    Result := '00';
end;

Procedure BuildNISAContactInfo(RetNo: Integer; FName: String);
Var
  Rec: String;
  FNo: Integer;
  cd: string;
begin
  FNo := GetFormNo(FName);
  // 201112104
  cd := AllTrim(FetchElmFNo(RetNo, FNo, 23));
  If cd > '' then
    cd := '1'
  else
    cd := '2';
  If cd <> '1' then
    exit;
  Rec := 'TIA' + ElemSep + 'CNI' + ElemSep + ElemSep + cd + LineSep + CrLf;
  XmlList.add(Space(Indent4) + '<sfd:ContactData>');
  XmlList.add(Space(Indent4) + '<sfd:ContactPersonIndicator>' + cd +
    '</sfd:ContactPersonIndicator>');
  Inc(SegmentCnt);

  If AllTrim(FetchElmFNo(RetNo, FNo, 23)) > '' then // there is contact
  begin
    // contact Last nm
    If AllTrim(FetchElmFNo(RetNo, FNo, 10) + FetchElmFNo(RetNo, FNo, 11)) > ''
    then
    begin
      Rec := 'IN2' + ElemSep + '05' + ElemSep +
        AllTrim(FetchElmFNo(RetNo, FNo, 11)) + LineSep + CrLf;
      XmlList.add(Space(Indent4) + '<sfd:ContactName>');
      XmlList.add(Space(Indent4 + 2) + '<comm:GivenName>' +
        AllTrim(FetchElmFNo(RetNo, FNo, 10)) + '</comm:GivenName>');
      // 20111209 //20120118 sfd to comm
      XmlList.add(Space(Indent4 + 2) + '<comm:FamilyName>' +
        AllTrim(FetchElmFNo(RetNo, FNo, 11)) + '</comm:FamilyName>');
      // 20120118
      XmlList.add(Space(Indent4) + '</sfd:ContactName>');
      Inc(SegmentCnt);
    end;
    // Business nm
    If AllTrim(FetchElmFNo(RetNo, FNo, 8)) > '' then
    begin
      Rec := 'IN2' + ElemSep + '11' + ElemSep +
        AllTrim(FetchElmFNo(RetNo, FNo, 8)) + LineSep + CrLf;
      XmlList.add(Space(Indent4) + '<sfd:ContactBusinessName>' +
        LeftStr(AllTrim(FetchElmFNo(RetNo, FNo, 8)), 30) +
        '</sfd:ContactBusinessName>'); // 20120119
      Inc(SegmentCnt);
    end;
    // contact address
    XmlList.add(Space(Indent4) + '<sfd:ContactAddress>');
    If AllTrim(FetchElmFNo(RetNo, FNo, 12)) > '' then
    begin
      Rec := 'N3' + ElemSep + AllTrim(FetchElmFNo(RetNo, FNo, 12)) +
        LineSep + CrLf;
      XmlList.add(Space(Indent4) + '<comm:BusinessAddressStreetText>' +
        LeftStr(AllTrim(FetchElmFNo(RetNo, FNo, 12)), 30) +
        '</comm:BusinessAddressStreetText>');
      Inc(SegmentCnt);
    end;
    // contact city,prov,postal
    If AllTrim(FetchElmFNo(RetNo, FNo, 13)) > '' then
    Begin
      Rec := 'N4' + ElemSep + AllTrim(FetchElmFNo(RetNo, FNo, 13)) + ElemSep +
        AllTrim(FetchElmFNo(RetNo, FNo, 14)) + ElemSep +
        Removechar(AllTrim(FetchElmFNo(RetNo, FNo, 15)), ' ') // +ElemSep
        + LineSep + CrLf;
      XmlList.add(Space(Indent4) + '<comm:AddressMunicipalityName>' +
        AllTrim(FetchElmFNo(RetNo, FNo, 13)) +
        '</comm:AddressMunicipalityName>');
      XmlList.add(Space(Indent4) + '<comm:AddressProvinceCode>' +
        AllTrim(FetchElmFNo(RetNo, FNo, 14)) + '</comm:AddressProvinceCode>');
      XmlList.add(Space(Indent4) + '<comm:AddressPostalCode>' +
        Removechar(AllTrim(FetchElmFNo(RetNo, FNo, 15)), ' ') +
        '</comm:AddressPostalCode>');
      Inc(SegmentCnt);
    end;
    XmlList.add(Space(Indent4) + '</sfd:ContactAddress>');
    // telephone
    If AllTrim(FetchElmFNo(RetNo, FNo, 17)) > '' then
    Begin
      XmlList.add(Space(Indent4) + '<sfd:ContactTelephoneNumber>');
      XmlList.add(Space(Indent4) + '<comm:TelephoneAreaCode>' +
        AllTrim(FetchElmFNo(RetNo, FNo, 16)) + '</comm:TelephoneAreaCode>');
      XmlList.add(Space(Indent4) + '<comm:TelephoneLocalNumber>' +
        CleanUpTelephoneNo(FetchElmFNo(RetNo, FNo, 17)) +
        '</comm:TelephoneLocalNumber>');
      XmlList.add(Space(Indent4) + '</sfd:ContactTelephoneNumber>');
    end;
    // 20230125  Cell phone
    If (AllTrim(FetchElmFNo(RetNo, FNo, 37)) > '') // area
      and (AllTrim(FetchElmFNo(RetNo, FNo, 31)) > '') // cell
    then // 20230115
    Begin
      XmlList.add(Space(Indent4) + '<sfd:ContactCellPhoneNumber>');
      XmlList.add(Space(Indent4) + '<comm:TelephoneAreaCode>' +
        FetchElmFNo(RetNo, FNo, 37) + '</comm:TelephoneAreaCode>');
      XmlList.add(Space(Indent4) + '<comm:TelephoneLocalNumber>' +
        CleanUpTelephoneNo(FetchElmFNo(RetNo, FNo, 31)) +
        '</comm:TelephoneLocalNumber>');
      XmlList.add(Space(Indent4) + '</sfd:ContactCellPhoneNumber>');
    End;

    // Fax
    If AllTrim(FetchElmFNo(RetNo, FNo, 19)) > '' then
    Begin
      XmlList.add(Space(Indent4) + '<sfd:ContactFaxNumber>');
      XmlList.add(Space(Indent4) + '<comm:TelephoneAreaCode>' +
        AllTrim(FetchElmFNo(RetNo, FNo, 18)) + '</comm:TelephoneAreaCode>');
      XmlList.add(Space(Indent4) + '<comm:TelephoneLocalNumber>' +
        CleanUpTelephoneNo(FetchElmFNo(RetNo, FNo, 19)) +
        '</comm:TelephoneLocalNumber>');
      XmlList.add(Space(Indent4) + '</sfd:ContactFaxNumber>');
    end;
    // calculationofbenefotscopyindicator only for T1273?  It is in sample
    XmlList.add(Space(Indent4) + '</sfd:ContactData>');
  end; // there is contact
end;

// not used
Procedure BuildHarmonizedContactInfo(RetNo: Integer; FName: String);
Var
  Rec: String;
  FNo: Integer;
  cd: string;
begin
  FNo := GetFormNo(FName);
  // 201112104
  cd := AllTrim(FetchElmFNo(RetNo, FNo, 64));
  If cd > '' then
    cd := '1'
  else
    cd := '2';
  If cd <> '1' then
    exit;
  Rec := 'TIA' + ElemSep + 'CNI' + ElemSep + ElemSep + cd + LineSep + CrLf;
  XmlList.add(Space(Indent4) + '<sfd:ContactData>');
  XmlList.add(Space(Indent4) + '<sfd:ContactPersonIndicator>' + cd +
    '</sfd:ContactPersonIndicator>');
  Inc(SegmentCnt);

  If AllTrim(FetchElmFNo(RetNo, FNo, 64)) > '' then // there is contact
  begin
    // contact Last nm
    If AllTrim(FetchElmFNo(RetNo, FNo, 10) + FetchElmFNo(RetNo, FNo, 11)) > ''
    then
    begin
      Rec := 'IN2' + ElemSep + '05' + ElemSep +
        AllTrim(FetchElmFNo(RetNo, FNo, 11)) + LineSep + CrLf;
      XmlList.add(Space(Indent4) + '<sfd:ContactName>');
      XmlList.add(Space(Indent4 + 2) + '<comm:GivenName>' +
        AllTrim(FetchElmFNo(RetNo, FNo, 10)) + '</comm:GivenName>'); // 20111209
      XmlList.add(Space(Indent4 + 2) + '<comm:FamilyName>' +
        AllTrim(FetchElmFNo(RetNo, FNo, 11)) + '</comm:FamilyName>');
      XmlList.add(Space(Indent4) + '</sfd:ContactName>');
      Inc(SegmentCnt);
    end;
    // Business nm
    If AllTrim(FetchElmFNo(RetNo, FNo, 65)) > '' then
    begin
      Rec := 'IN2' + ElemSep + '11' + ElemSep +
        AllTrim(FetchElmFNo(RetNo, FNo, 65)) + LineSep + CrLf;
      XmlList.add(Space(Indent4) + '<sfd:ContactBusinessName>' +
        LeftStr(AllTrim(FetchElmFNo(RetNo, FNo, 65)), 30) +
        '</sfd:ContactBusinessName>'); // 20120119
      Inc(SegmentCnt);
    end;
    // contact address
    XmlList.add(Space(Indent4) + '<sfd:ContactAddress>');
    If AllTrim(FetchElmFNo(RetNo, FNo, 12)) > '' then
    begin
      Rec := 'N3' + ElemSep + AllTrim(FetchElmFNo(RetNo, FNo, 12)) +
        LineSep + CrLf;
      XmlList.add(Space(Indent4) + '<comm:BusinessAddressStreetText>' +
        LeftStr(AllTrim(FetchElmFNo(RetNo, FNo, 12)), 30) +
        '</comm:BusinessAddressStreetText>'); // 20120119
      Inc(SegmentCnt);
    end;
    // contact city,prov,postal
    If AllTrim(FetchElmFNo(RetNo, FNo, 13)) > '' then
    Begin
      Rec := 'N4' + ElemSep + AllTrim(FetchElmFNo(RetNo, FNo, 13)) + ElemSep +
        AllTrim(FetchElmFNo(RetNo, FNo, 14)) + ElemSep +
        Removechar(AllTrim(FetchElmFNo(RetNo, FNo, 15)), ' ') // +ElemSep
        + LineSep + CrLf;
      XmlList.add(Space(Indent4) + '<comm:AddressMunicipalityName>' +
        AllTrim(FetchElmFNo(RetNo, FNo, 13)) +
        '</comm:AddressMunicipalityName>');
      XmlList.add(Space(Indent4) + '<comm:AddressProvinceCode>' +
        AllTrim(FetchElmFNo(RetNo, FNo, 14)) + '</comm:AddressProvinceCode>');
      XmlList.add(Space(Indent4) + '<comm:AddressPostalCode>' +
        Removechar(AllTrim(FetchElmFNo(RetNo, FNo, 15)), ' ') +
        '</comm:AddressPostalCode>');
      Inc(SegmentCnt);
    end;
    XmlList.add(Space(Indent4) + '</sfd:ContactAddress>');

    If (AllTrim(FetchElmFNo(RetNo, FNo, 16)) > '') // area
      and (AllTrim(FetchElmFNo(RetNo, FNo, 17)) > '') // tel
    then // 20230115
    Begin
      XmlList.add(Space(Indent4) + '<sfd:ContactTelephoneNumber>');
      XmlList.add(Space(Indent4) + '<comm:TelephoneAreaCode>' +
        FetchElmFNo(RetNo, FNo, 16) + '</comm:TelephoneAreaCode>');
      XmlList.add(Space(Indent4) + '<comm:TelephoneLocalNumber>' +
        Removechar(FetchElmFNo(RetNo, FNo, 17), '-') +
        '</comm:TelephoneLocalNumber>');
      XmlList.add(Space(Indent4) + '</sfd:ContactTelephoneNumber>');
    End;

    // 20230129  Cell phone  //20230204
    If (AllTrim(FetchElmFNo(RetNo, FNo, 37)) > '') // area
      and (AllTrim(FetchElmFNo(RetNo, FNo, 31)) > '') // cell no
    then // 20230115
    Begin
      XmlList.add(Space(Indent4) + '<sfd:ContactCellPhoneNumber>');
      XmlList.add(Space(Indent4) + '<comm:TelephoneAreaCode>' +
        FetchElmFNo(RetNo, FNo, 37) + '</comm:TelephoneAreaCode>');
      XmlList.add(Space(Indent4) + '<comm:TelephoneLocalNumber>' +
        Removechar(FetchElmFNo(RetNo, FNo, 31), '-') +
        '</comm:TelephoneLocalNumber>');
      XmlList.add(Space(Indent4) + '</sfd:ContactCellPhoneNumber>');
    End;

    If (AllTrim(FetchElmFNo(RetNo, FNo, 18)) > '') and
      (AllTrim(FetchElmFNo(RetNo, FNo, 19)) > '') then
    // +FetchElm(RetNo,'T1273'+FInst,3))>'' then  //20190417
    begin
      XmlList.add(Space(Indent4) + '<sfd:ContactFaxNumber>');
      XmlList.add(Space(Indent4) + '<comm:TelephoneAreaCode>' +
        AllTrim(Removechar(FetchElmFNo(RetNo, FNo, 18), '-')) +
        '</comm:TelephoneAreaCode>');
      XmlList.add(Space(Indent4) + '<comm:TelephoneLocalNumber>' +
        CleanUpTelephoneNo(FetchElmFNo(RetNo, FNo, 19)) +
        '</comm:TelephoneLocalNumber>');
      XmlList.add(Space(Indent4) + '</sfd:ContactFaxNumber>');
    end;

    cd := AllTrim(FetchElmFNo(RetNo, FNo, 50));
    If cd > '' then
      cd := '1'
    else
      cd := '2';
    XmlList.add(Space(Indent4) +
      '<sfd:CalculationOfBenefitsContactCopyIndicator>' + cd +
      '</sfd:CalculationOfBenefitsContactCopyIndicator>');

    XmlList.add(Space(Indent4) + '</sfd:ContactData>');
  end; // there is contact
end;

procedure CreateXmlDataFile(RetNo: Integer; EolTaxFlName: String;
  ProdOrTest: String; OnLineMethod: String; Sender: TObject);
Var
  Rec: String;
  i, Rule, LLine, ElmNo: Integer;
  FNo: Integer; // 20170323
  LType: string[1];
  FName: string[12];
  S: string;
  LLineString: String[5]; // String[4];  //20190730
  EFlines: TStringList;
  DcnSeqNo: String;
  TempList1, TempList2: TStringList; // 20170518
  Dummy: Real; // 20170519
  // for refile  //20170323
  j, k, mxAnswers: Integer;
  AnswerLetter: String;
  FromNdx, ToNdx: Integer;
  FrmSource: String; // 20170519
  tempSaveList:Tstringlist;
  //xmlFileList:Tstringlist;
begin
  Indent1 := 3;
  Indent2 := Indent1 + 3;
  Indent3 := Indent2 + 3;
  Indent4 := Indent3 + 3;
  Indent5 := Indent4 + 3;
  Indent6 := Indent5 + 3;
  Indent7 := Indent6 + 3;
  Indent8 := Indent7 + 3;
  Indent9 := Indent8 + 3;
  Indent10 := Indent9 + 3;
  Indent11 := Indent10 + 3;

  GetEOLParms(OnLineNo, PassWord, Url, NetFileDir); // 20110120
  DcnSeqNo := MidStr(FetchElm(RetNo, 'T183', 21), 6, 8); // 20140130

  PrepareT1Rec(RetNo, ProdOrTest, OnLineMethod);
  With XmlList do
  Begin
    // 20181126 changed 2025 to 2026
    // every year up the year by 1 i.e. change 2016 to 2017

    add('    <t1rq:EfileReturnRequest');
    add('       xmlns:ccms="http://www.cra-arc.gc.ca/xmlns/ccms/1-1-0"');
    add('       xmlns:comm="http://www.cra-arc.gc.ca/xmlns/comm/2026/1-0-0"');
    // 20241116
    // 20221221
    add('       xmlns:ef="http://www.cra-arc.gc.ca/xmlns/ef/2026/1-0-0"');
    // 20231228 Igor //20241116
    // 20221222
    add('       xmlns:sdt="http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0"');
    add('       xmlns:sfd="http://www.cra-arc.gc.ca/xmlns/sfd/2026/1-0-0"');
    // 20241116
    // 20221221
    add('       xmlns:t1="http://www.cra-arc.gc.ca/xmlns/t1/2026/1-0-0"');
    // 20231228 Igor  //20241116
    // 20221221
    add('       xmlns:t1135="http://www.cra-arc.gc.ca/xmlns/t1135/2021/1-0-0"');
    // 20231228 Igor  //20240115
    // 20221225
    // add('       xmlns:t1134="http://www.cra-arc.gc.ca/xmlns/t1134/2023/1-0-0"');   //20221225   //20230104
    add('       xmlns:t1rq="http://www.cra-arc.gc.ca/xmlns/t1rq/efilerequest/1-0-0"');
    add('       xmlns:tp="http://www.cra-arc.gc.ca/xmlns/tp/2026/1-0-0"');
    // 20231228 Igor
    add('       xmlns:xml="http://www.w3.org/XML/1998/namespace"');
    add('       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');

    // 20211228 Igor <<<
    // add('       xmlns:surv="http://www.cra-arc.gc.ca/xmlns/surv/1-0-0"');   //20210110
    add('       xsi:schemaLocation="http://www.cra-arc.gc.ca/xmlns/t1rq/efilerequest/1-0-0 t1wsefilerequest.xsd">');
    add('       <ef:TransmitterEfilerNumber>' + OnLineNo +
      '</ef:TransmitterEfilerNumber>');
    add('       <ef:PasswordID>' + PassWord + '</ef:PasswordID>');
    add('       <tp:TaxYear>' + AppYear + '</tp:TaxYear>');
    add('       <ef:EfileData>');
    add('           <ef:PasswordID>' + PassWord + '</ef:PasswordID>');
    // why again??????
    add('           <ef:DocumentControlNumber>');
    add('               <ef:TaxPreparerEfilerNumber>' + OnLineNo +
      '</ef:TaxPreparerEfilerNumber>');
    add('               <ef:TaxPreparerReturnControlNumber>' + DcnSeqNo +
      '</ef:TaxPreparerReturnControlNumber>');
    add('           </ef:DocumentControlNumber>');

    If AllTrim(Fx.DISCNUMBER) > '' then // 20191221
      add('           <ef:DiscounterRegistrationNumber>' + Fx.DISCNUMBER +
        '</ef:DiscounterRegistrationNumber>'); // 20141211

    if Fx.CLAUTHORIZE > '0' then // 20191221
    Begin
      add('           <ef:TaxPreparerAuthorizationIndicator>' + Fx.CLAUTHORIZE +
        '</ef:TaxPreparerAuthorizationIndicator>'); // 20141211
      If AllTrim(Fx.AUTHORIZEEXPIRY) > '' then // 20150210
        add('           <ef:TaxPreparerAuthorizationExpiryDate>' +
          Fx.AUTHORIZEEXPIRY + '</ef:TaxPreparerAuthorizationExpiryDate>');
      // 20141211
    end;

   if Fx.NOARetrievalAuth>'0' then  //20251125
    add('           <ef:EfilerNOARetrievalAuthorizationIndicator>' +
      Fx.NOARetrievalAuth + '</ef:EfilerNOARetrievalAuthorizationIndicator>');
    // 20170407
    add('           <ef:TaxPreparerPreAssessmentReviewContactCode>' +
      Fx.PREASSESSMENT + '</ef:TaxPreparerPreAssessmentReviewContactCode>');
    add('           <ef:TaxPreparerPostAssessmentReviewContactCode>' +
      Fx.POSTASSESSMENT + '</ef:TaxPreparerPostAssessmentReviewContactCode>');

    // 20201127
    if UpperCase(FetchElm(RetNo, 'T183', 26)) = 'Y' then
      S := '1'
    else
      S := '0'; // use electr signature
    add('      <ef:T183ElectronicSignatureData>');
    add('         <ef:T183ElectronicSignatureIndicator>' + S +
      '</ef:T183ElectronicSignatureIndicator>');
    if S = '1' then
    Begin
      S := FetchElm(RetNo, 'T183', 11); // 20221229 Date Signed
      if S > '' then
        add('         <ef:T183ElectronicSignatureDate>' + S +
          '</ef:T183ElectronicSignatureDate>');
      S := FetchElm(RetNo, 'T183', 12); // 20222229 Time Signed
      If S > '' then
      Begin
        S := ReplaceChar(S, '-', ':'); // 20221229s
        add('         <ef:T183ElectronicSignatureTime>' + S +
          '</ef:T183ElectronicSignatureTime>');
      End;
    End;
    add('      </ef:T183ElectronicSignatureData>');

    // 20240106
    if Ret[RetNo].FrmHasData[GetFormNo('RC71')] then
    Begin
      if UpperCase(FetchElm(RetNo, 'RC71', 39)) = 'Y' then   //20250315 elm 39
        S := '1'
      else
        S := '0'; // use electr signature
      add('      <ef:RC71ElectronicSignatureData>');
      add('      <ef:RC71ElectronicSignatureIndicator>' + S +
        '</ef:RC71ElectronicSignatureIndicator>');
      if S = '1' then
      begin
        add('      <ef:RC71ElectronicSignatureDate>' + FetchElm(RetNo, 'RC71',
          5) + '</ef:RC71ElectronicSignatureDate>');
        add('      <ef:RC71ElectronicSignatureTime>' + FetchElm(RetNo, 'RC71',
          38) + '</ef:RC71ElectronicSignatureTime>');
      end;
      add('     </ef:RC71ElectronicSignatureData>');
    End;


    If FetchElm(RetNo, 'T183', 23) > '' then // 20221226  //20230315
      add('         <ef:RepresentativeID>' + FetchElm(RetNo, 'T183', 23) +
        '</ef:RepresentativeID>'); // 20221226
    // Add('         <ef:RepresentativeID>'+OptRec.Prp_RepId+'</ef:RepresentativeID>');  //20221226
    add('       </ef:EfileData>');

    //s := (Sender as TBitBtn).Name;  //((Sender as TBitBtn).Name = 'TransmitBtn');

    // 20171220               //jz//20260123 I dont ever need to add the identifier unless it is to actaully submit
    If (ProdOrTest = 'T') and ((Sender as TBitBtn).Name = 'TransmitBtn') then  //and not(inJZtestmode) no inJZtestmode condition needed
    Begin
      If MessageDlg('Enter Test Case Identifier?', mtInformation, [mbYes, mbNo],0) = mrYes then // always use testcaseid
      Begin
        // ******  TEST CASE ID's for multiple provinces of the same SIN and have diffrent test case Id's*****************
        S := AllTrim(GetTestCaseId(RetNo, GetSinNo(RetNo))); // 20171220
        // case identifiers in testing

        //case 12 and agri12
        //If GetSinNo(RetNo) = '870000163' then S := '93';
        If GetSinNo(RetNo) = '870000163' then S := '93 or 95';  ////jz20250130 is one or the other depening on if AGRI

        // 26
        If GetSinNo(RetNo) = '870000353' then // case 26 multiple 20190201
        Begin
          if Ret[RetNo].PROVINCE = 'NT' then S := '211'
          Else if Ret[RetNo].PROVINCE = 'NB' then S := '730'
          Else If Ret[RetNo].PROVINCE = 'NL' then S := '733'
          Else If Ret[RetNo].PROVINCE = 'ON' then S := '735'
        End;

        // #7
        If GetSinNo(RetNo) = '870000114' then // case #7 multiple 20180107
        Begin
          if Ret[RetNo].PROVINCE = 'AB' then S := '42'
          Else If Ret[RetNo].PROVINCE = 'NB' then S := '45'
          Else If Ret[RetNo].PROVINCE = 'PE' then S := '50'
          Else If Ret[RetNo].PROVINCE = 'SK' then S := '55';
        End;

        // 31
        If GetSinNo(RetNo) = '870001369' then // case #31 multiple 20180107
        Begin
          if Ret[RetNo].PROVINCE = 'BC'      then S := '253'
          Else If Ret[RetNo].PROVINCE = 'MB' then S := '256'
          Else If Ret[RetNo].PROVINCE = 'NL' then S := '259'
          Else If Ret[RetNo].PROVINCE = 'NS' then S := '262'
          Else If Ret[RetNo].PROVINCE = 'NU' then S := '264'
          Else If Ret[RetNo].PROVINCE = 'ON' then S := '268';
        End;

        // 53
        If GetSinNo(RetNo) = '870000650' then // case 53 multiple 20180106
        Begin
          if Ret[RetNo].PROVINCE = 'BC' then S := '440'
          Else If Ret[RetNo].PROVINCE = 'MB' then S := '448'
          Else If Ret[RetNo].PROVINCE = 'ON' then S := '454'
          Else If Ret[RetNo].PROVINCE = 'QC' then S := '459'
          Else If Ret[RetNo].PROVINCE = 'YT' then S := '463';
        End;

        // refiled //20220122
        If GetSinNo(RetNo) = '87000240.9' then S := '973'; // cert1 10
        If GetSinNo(RetNo) = '87000241.7' then S := '977'; // cert2  40
        If GetSinNo(RetNo) = '87000084.1' then S := '981'; // Cert3 85
        If GetSinNo(RetNo) = '87000062.7' then S := '983'; // cert4  2
        // T1135 //20220122
        // If GetSinNo(RetNo) ='870000841' then s:='794';   //cert 35
        // If GetSinNo(RetNo) ='87000241.7' then s:='791';   //20200111
        // If GetSinNo(RetNo) ='87000084.1' then s:='792';   //20200111
        // If GetSinNo(RetNo) ='87000062.7' then s:='793';   //20200111

        inputquery('testcaseId', 'enter a value', S);
        (*
          //20230206
          if FetchelmFNo(RetNo,INFoFNo,223)>'' then //IsRefile
          begin
          inputquery('testcaseId', 'enter a value', s);
          {
          if LeftStr(GetLastName(RetNo),3) ='TEN' then s:='973'
          Else  if LeftStr(GetLastName(RetNo),5) ='FORTY' then s:='699'
          Else  if LeftStr(GetLastName(RetNo),10) ='EIGHTYFIVE' then s:='700'
          Else  if LeftStr(GetLastName(RetNo),3) ='TWO' then s:='701'
          Else  if LeftStr(GetLastName(RetNo),8) ='SIXTYTWO' then s:='702'
          Else  if LeftStr(GetLastName(RetNo),9) ='SIXTYNINE' then s:='703'
          Else  begin ShowMessage('TCI not found. Used 9999'); s:='9999';end;
          }
          end;
        *)
        if S > '' then
          add('       <comm:TestCaseIdentifier>' + S +
            '</comm:TestCaseIdentifier>') // 20171214
        Else
        Begin
          ShowMessage('TestCase number missing on Return: ' + GetSinNo(RetNo));
          // 20171220
        end

      End
      Else // no testcaseindicator
        add('       <comm:TestCaseIdentifier>9999</comm:TestCaseIdentifier>');
      // optional? //20171206
    End  // test
    Else // production remove it
    begin end; // 20230222  Add('       <comm:TestCaseIdentifier>9999</comm:TestCaseIdentifier>'); //optional? //20171206

    // 20230204 moved from above

    // jz 20240209 <<<
    If Fx.FirstTimeFiler then
    begin
      add('       <comm:FirstTimeFilerIndicator>' + '1' +
        '</comm:FirstTimeFilerIndicator>');
    end
    else
    begin
      add('       <comm:FirstTimeFilerIndicator>' + '0' +
        '</comm:FirstTimeFilerIndicator>'); // 20191227
    end;
    // jz 20240209 >>>

    add('       <comm:OriginatingIP>0.0.0.0</comm:OriginatingIP>'); // 20171206
    add('       <t1rq:TaxReturnForm>');

    add(Space(Indent2) + '<t1:T1Return>');
    add(Space(Indent4) + '<comm:SoftwareID>' + Fx.DEVELOPER + Fx.SOFTCODE +
      '</comm:SoftwareID>'); // 20111204
    add(Space(Indent4) + '<comm:SoftwareRevisionDate>' + Fx.SOFTRELEASE +
      '</comm:SoftwareRevisionDate>');
    // 20200106
    // 20170320
    if IsForRefile(RetNo) then
    Begin
      add(Space(Indent4) + '<t1:AmendedTaxReturnIndicator>' + '1' +
        '</t1:AmendedTaxReturnIndicator>');
    End;
    if FetchElmFNo(RetNo, InfoFNo, 141) > '' then // 20200115
      add(Space(Indent4) + '<t1:MultipleTaxYearReturnIndicator>' + '1' +
        '</t1:MultipleTaxYearReturnIndicator>');

    // 20191127  /needs work????
    add(Space(Indent2) + '<t1:AutoFillData>');

    // 20200213
    S := FetchElmFNo(RetNo, InfoFNo, 143);
    if S > '' then
    Begin
      add(Space(Indent4) + '<t1:AutoFillReturnIndicator>' + '1' +
        '</t1:AutoFillReturnIndicator>');
      add(Space(Indent4) + '<t1:AutoFillRequestDate>' + S +
        '</t1:AutoFillRequestDate>');
    End
    Else
      add(Space(Indent4) + '<t1:AutoFillReturnIndicator>' + '0' +
        '</t1:AutoFillReturnIndicator>');
    add(Space(Indent2) + '</t1:AutoFillData>');

    // --------------------------------------------
    add(Space(Indent3) + '<t1:TaxpayerData>');
    // TaxpayerBasicData     //20221221
    add(Space(Indent4) + '<tp:TaxpayerBasicData>');
    add(Space(Indent4 + 2) + '<tp:TaxpayerSocialInsuranceNumber>' + Fx.SIN +
      '</tp:TaxpayerSocialInsuranceNumber>');
    add(Space(Indent4 + 2) + '<tp:TaxYear>' + AppYear + '</tp:TaxYear>');
    add(Space(Indent4 + 2) + '<tp:TaxpayerBirthDate>' + Fx.BIRTHYYYY + '-' +
      Fx.BIRTHMM + '-' + Fx.BIRTHDD + '</tp:TaxpayerBirthDate>');
    add(Space(Indent4 + 2) + '<tp:SelfEmployedSpouseDeadlineIndicator>' +
      Fx.SpouseSelfEmpl + '</tp:SelfEmployedSpouseDeadlineIndicator>');
    add(Space(Indent4 + 2) + '</tp:TaxpayerBasicData>');
    // ----------------------------------------
    // TaxpayerMaritalStatusData //20221221
    add(Space(Indent4 + 2) + '<tp:TaxpayerMaritalStatusData>');
    add(Space(Indent4 + 2) + '<tp:TaxpayerMaritalStatusCode>' + Fx.MARSTATUS +
      '</tp:TaxpayerMaritalStatusCode>');
    S := '2';
    If FetchElmFNo(RetNo, InfoFNo, 39) > '' then
      S := '1';; // 20221222 //2=NO change
    add(Space(Indent4 + 2) + '<tp:TaxpayerMaritalStatusChangeIndicator>' + S +
      '</tp:TaxpayerMaritalStatusChangeIndicator>');
    If S = '1' then
      add(Space(Indent4 + 2) + '<tp:TaxpayerMaritalStatusChangeDate>' + AppYear
        + '-' + FetchElmFNo(RetNo, InfoFNo, 39) + '-' + FetchElmFNo(RetNo,
        InfoFNo, 40) + '</tp:TaxpayerMaritalStatusChangeDate>');
    add(Space(Indent4 + 2) + '</tp:TaxpayerMaritalStatusData>');

    add(Space(Indent4) + '<tp:TaxpayerResidenceData>');

    // ================================= //20240323
    // 20240426
    if (getResidencyType(RetNo) = '3') // non res aand deemed
      or (getResidencyType(RetNo) = '7') or (isSection116(RetNo))
    // 238 sect 116
      or (IsDeemedRes183(RetNo)) // 253
    then
    Begin
      Fx.PRVOFRES := 'EX'; // 20240428C
    end;

    add(Space(Indent4 + 2) + '<tp:TaxpayerYearEndResidenceProvinceCode>' +
      Fx.PRVOFRES + '</tp:TaxpayerYearEndResidenceProvinceCode>');
    // If FetchElmFNo(RetNo,InfoFNo,238)>'' then Fx.PRVOFRES:='EX'; //20240323    //sect 116
    // If FetchElmFNo(RetNo,InfoFNo,253)>'' then Fx.PRVOFRES:='EX'; //20240324 Deemed res 183 days

    If (isSection116(RetNo))
    // (FetchElmFNo(RetNo,InfoFNo,238)>'')      //section 116
      or (IsDeemedResident(RetNo)) // 20240325
    then
    Begin
      add(Space(Indent4 + 2) + '<tp:TaxpayerYearEndResidenceCountryCode>' +
        FetchElmFNo(RetNo, InfoFNo, 69) +
        '</tp:TaxpayerYearEndResidenceCountryCode>'); // 20240325
    End;

    //The valid values are: “1” – Yes “2” – No
    //This element is conditionally mandatory, present only when ResidencyType = 3 and field 17700 = 4.
    //jz//NonResCERT//202404 - entry on T1 form
    if (getResidencyType(RetNo) = '3') and   //is deemed res
       (FetchElm(RetNo, 'T1', 504) > '')  //17700 = 4
    then
    begin
      if (FetchElmFNo(RetNo, InfoFNo, 204) > '') then S:='1' else S:='2';

      add(Space(Indent4 + 2) + '<tp:DeemedResQCIndicator>' +
                                S + '</tp:DeemedResQCIndicator>');
      //This element is conditionally mandatory
      //present only when DeemedResQCIndicator = 1

      if (FetchElmFNo(RetNo, InfoFNo, 204) > '') then //FilingQROIndicator
      begin
        if (FetchElmFNo(RetNo, InfoFNo, 205) > '') then S:='1' else S:='2';

        add(Space(Indent4 + 2) + '<tp:FilingQROIndicator>' +
                                  S +
                                 '</tp:FilingQROIndicator>');
      end;
    end;
    { relocate belo
      +    If FetchElmFNo(RetNo,InfoFNo,230)>'' then  //emmigrant //20240323
      Begin
      add(Space(Indent4 +2) + '<tp:EmigrantDepartureDate>'
      +AppYear+'-'+FetchElmFNo(RetNo,INFOFNo,28)+'-'+FetchElmFNo(RetNo,INFOFNo,27)
      +'</tp:EmigrantDepartureDate>');
      End;
    }
    // ================
    // 20170101
    If FetchElm(RetNo, 'INFO', 66) > '' then
      add(Space(Indent4 + 2) + '<tp:TaxpayerCurrentResidenceProvinceCode>' +
        FetchElm(RetNo, 'INFO', 66) +
        '</tp:TaxpayerCurrentResidenceProvinceCode>');

    if (IsMultJurisdiction(RetNo)) then // 20170518
      add(Space(Indent4 + 2) + '<tp:MultipleJurisdictionIndicator>' + '1' +
        '</tp:MultipleJurisdictionIndicator>');

    If (Ret[RetNo].PROVINCE = 'NT') or (Ret[RetNo].PROVINCE = 'YT') then
    begin
      If (FetchElm(RetNo, 'INFO', 23) > '') then // 20191221
        add(Space(Indent4 + 2) + '<tp:FirstNationIdentificationIndicator>' + '1'
          + '</tp:FirstNationIdentificationIndicator>') // 20200101
      else if (FetchElm(RetNo, 'INFO', 23) > '') then
        add(Space(Indent4 + 2) + '<tp:FirstNationIdentificationIndicator>' + '2'
          + '</tp:FirstNationIdentificationIndicator>');
    end;

{
    //removed for BC as per  ch5-24e.pdf  should remove elm [197] and [197]????
    // 20230129
    if Ret[RetNo].PROVINCE = 'BC' then
    begin
      If FetchElm(RetNo, 'INFO', 196) > '' then
        add(Space(Indent4 + 2) + '<tp:FirstNationIdentificationIndicator>' + '1'
          + '</tp:FirstNationIdentificationIndicator>');
      If FetchElm(RetNo, 'INFO', 197) > '' then
        add(Space(Indent4 + 2) + '<tp:FirstNationIdentificationIndicator>' + '2'
          + '</tp:FirstNationIdentificationIndicator>');
    end;
}


    S := '';
    If FetchElm(RetNo, 'INFO', 206) > '' then
      S := '1';
    If FetchElm(RetNo, 'INFO', 207) > '' then
      S := '2';
    If FetchElm(RetNo, 'INFO', 208) > '' then
      S := '3';
    If FetchElm(RetNo, 'INFO', 209) > '' then
      S := '4';
    If FetchElm(RetNo, 'INFO', 210) > '' then
      S := '5';
    If FetchElm(RetNo, 'INFO', 41) > '' then // 20131226
    begin
      if Ret[RetNo].PROVINCE = 'YT' then
        add(Space(Indent4 + 2) + '<tp:YukonFirstNationsSettlementNumber>' +
          Fx.FIRSTNation + '</tp:YukonFirstNationsSettlementNumber>');
      // 20111214
    end;

    S := '';
    If Ret[RetNo].PROVINCE = 'NT' // 20170108
    then
    Begin
      If (FetchElm(RetNo, 'INFO', 90) > '') then
        S := '1'
      else
        S := '2';
      add(Space(Indent4 + 2) + '<tp:TlichoLandResidenceIndicator>' + S +
        '</tp:TlichoLandResidenceIndicator>');

      If (FetchElm(RetNo, 'INFO', 268) > '') then
        S := '1'
      else
        S := '2';
      add(Space(Indent4 + 2) + '<tp:DelineLandResidenceIndicator>' + S +
        '</tp:DelineLandResidenceIndicator>');
    end;

    //ABORIGINAL
    If (Ret[RetNo].PROVINCE = 'NL') or (Ret[RetNo].PROVINCE = 'YT')
                                                                          //(Ret[RetNo].PROVINCE = 'BC') //20250318 no longer applies to BC, removed
    // //20230504
    then
    begin
      S := FetchElm(RetNo, 'INFO', 218);    //ticked aboriginal box
      If S > '' then
        add(Space(Indent4 + 2) + '<tp:AboriginalLandResidenceIndicator>' + '1' +
          '</tp:AboriginalLandResidenceIndicator>');

      //jz 20250127 - handle seperatly so if left all blank then doesn't add the tag - done to comply with cert92 and cert67
      //jz//20250312- the 'NO', '2' does not need to be for a specific province
      S := FetchElm(RetNo, 'INFO', 219);
      if (S >'') then //and ( (Ret[Retno].Province='NL') or (Ret[Retno].Province='YT')) then //20250224
      Begin
        add(Space(Indent4 + 2) + '<tp:AboriginalLandResidenceIndicator>' + '2' +
          '</tp:AboriginalLandResidenceIndicator>');
      End;

    end;

{
    //not in effect, removed 20250318
    // 20230120+
    if Ret[RetNo].PROVINCE = 'BC' then
    begin
      if FetchElmFNo(RetNo, InfoFNo, 190) > '' then
        add(Space(Indent4 + 2) + '<tp:TsawwassenLandResidenceIndicator>' + '1' +
          '</tp:TsawwassenLandResidenceIndicator>');
    end;
    if (FetchElmFNo(RetNo, InfoFNo, 198) = '') and
      (FetchElmFNo(RetNo, InfoFNo, 225) = '') then
    Begin
    End;
    //not in effect, removed 20250318
    if Ret[RetNo].PROVINCE = 'BC' then
    begin
      S := FetchElmFNo(RetNo, InfoFNo, 194);
      if S > '' then // 20221230
        add(Space(Indent4 + 2) + '<tp:TsawwassenFirstNationIndicator>' + '1' +
          '</tp:TsawwassenFirstNationIndicator>');
      S := FetchElmFNo(RetNo, InfoFNo, 195); // 20230127
    end; // bc
}

    If AllTrim(Fx.ProvEffectiveDate) > '' then
      add(Space(Indent4 + 2) + '<tp:ProvinceOfResidenceEffectiveDate>' +
        Fx.ProvEffectiveDate + '</tp:ProvinceOfResidenceEffectiveDate>');

    // 20240325
    If FetchElmFNo(RetNo, InfoFNo, 230) > '' then // emmigrant //20240323
    Begin
      add(Space(Indent4 + 2) + '<tp:EmigrantDepartureDate>' + AppYear + '-' +
        FetchElmFNo(RetNo, InfoFNo, 28) + '-' + FetchElmFNo(RetNo, InfoFNo, 27)
        + '</tp:EmigrantDepartureDate>');
    End;

    If FetchElm(RetNo, 'INFO', 26) > '' then
      add(Space(Indent4 + 2) + '<tp:ImmigrantEntryDate>' + AppYear + '-' +
        FetchElm(RetNo, 'INFO', 26) + '-' + FetchElm(RetNo, 'INFO', 25) +
        '</tp:ImmigrantEntryDate>'); // 20131208


    add(Space(Indent4) + '</tp:TaxpayerResidenceData>');

    // TaxpayerSpouseData  //20221221
    If (AllTrim(Fx.SPOUSENAME) > '') Or (GetSpouseSin(RetNo) > '') then
    begin
      add(Space(Indent4) + '<tp:TaxpayerSpouseData>');
      If AllTrim(Fx.SPOUSESIN) > '' then
        add(Space(Indent5) + '<tp:SpouseSocialInsuranceNumber>' + Fx.SPOUSESIN +
          '</tp:SpouseSocialInsuranceNumber>');
      If AllTrim(Fx.SPOUSENAME) > '' then
        add(Space(Indent5) + '<tp:SpouseGivenName>' +
          ReplaceReservedXMLCharacters(Fx.SPOUSENAME) +
          '</tp:SpouseGivenName>');
      If AllTrim(Fx.SPOUSENETINC) > '' then
        add(Space(Indent5) + '<tp:SpouseNetIncomeAmount>' + Fx.SPOUSENETINC +
          '</tp:SpouseNetIncomeAmount>'); // 20180329
      If AllTrim(Fx.SPOUSEUCCB) > '' then
        add(Space(Indent5) + '<tp:SpouseUniversalChildCareBenefitAmount>' +
          Fx.SPOUSEUCCB + '</tp:SpouseUniversalChildCareBenefitAmount>');
      If AllTrim(Fx.SPOUSEUCCBRepay) > '' then
        add(Space(Indent5) + '<tp:SpouseUniversalChildCareRepaymentAmount>' +
          Fx.SPOUSEUCCBRepay + '</tp:SpouseUniversalChildCareRepaymentAmount>');
      add(Space(Indent4) + '</tp:TaxpayerSpouseData>');
    end;

    // ---------------TaxpayerContactData  ------------------
    add(Space(Indent4) + '<tp:TaxpayerContactData>');

    // jz 20240209 <<<
    add(Space(Indent4 + 2) + '<comm:TaxpayerName>');
    If Fx.FirstTimeFiler then
    begin
      add(Space(Indent5 + 2) + '<comm:GivenName/>');
      add(Space(Indent5 + 2) + '<comm:FamilyName/>');
    end
    else
    begin
      add(Space(Indent5 + 2) + '<comm:GivenName>' + ReplaceReservedXMLCharacters
        (Fx.FIRSTNAME) + '</comm:GivenName>');
      add(Space(Indent5 + 2) + '<comm:FamilyName>' +
        ReplaceReservedXMLCharacters(Fx.LASTNAME) + '</comm:FamilyName>');
    end;
    add(Space(Indent4 + 2) + '</comm:TaxpayerName>');
    // jz 20240209 >>>

    {
      if FetchElmFNo(RetNo,InfoFNo,139)='' then  //20240207 NO first time filer
      Begin
      add(Space(Indent4 + 2) + '<comm:TaxpayerName>'); add(Space(Indent4 + 2) + '<comm:GivenName>' + ReplaceReservedXMLCharacters
      (Fx.FIRSTNAME) + '</comm:GivenName>');
      add(Space(Indent4 + 2) + '<comm:FamilyName>' + ReplaceReservedXMLCharacters(Fx.LASTNAME) + '</comm:FamilyName>');
      end
      Else
      begin
      {//20240208
      s:=FetchElmFNo(RetNo,InfoFNo,233);
      add(Space(Indent4 + 2) + '<comm:TaxpayerName>'); add(Space(Indent4 + 2) + '<comm:GivenName>' + S + '</comm:GivenName>');
      //s:=FetchElmFNo(RetNo,InfoFNo,235); //20240108
      //add(Space(Indent4 + 2) + '<comm:SecondName>' + S +'</comm:SecondName>');
      s:=FetchElmFNo(RetNo,InfoFNo,234);
      add(Space(Indent4 + 2) + '<comm:FamilyName>' + S +'</comm:FamilyName>');

      end;

      add(Space(Indent4 + 2) + '</comm:TaxpayerName>');
    }

    S := FetchElmFNo(RetNo, InfoFNo, 56); // 20221230
    If S > '' then     // 20240204 Con
       add(Space(Indent4 + 2) + '<tp:SurnameChangeIndicator>' + '2' + //cz//20250319 changed from 1 to 2
      //add(Space(Indent4 + 2) + '<tp:SurnameChangeIndicator>' + '1' + //jz//20250308 changed rom 2 to 1
        '</tp:SurnameChangeIndicator>'); // 20230224

    (*
      // NameChangeIndicator
      S := FetchElmFNo(RetNo, InfoFNo, 56); // 20221230
      //20231228 Igor >>>
      If S > '' then
      add(Space(Indent4 + 2) + '<tp:SurnameChangeIndicator>'
      +S //'1' + //20240125
      +'</tp:SurnameChangeIndicator>'); // 20230224
      {
      else
      add(Space(Indent4 + 2) + '<tp:SurnameChangeIndicator>' + '1' +
      '</tp:SurnameChangeIndicator>');
      }
    *)
    add(Space(Indent4 + 2) + '<tp:ResidencyType>' + getResidencyType(RetNo) +
      '</tp:ResidencyType>'); // 20240126
    // add(Space(Indent4 + 2) + '<tp:ResidencyType>' + '1' + '</tp:ResidencyType>');

    // 20231228 Igor <<<
    // ----------------------------------------------------------
    If FetchElmFNo(RetNo, InfoFNo, 173) > '' then // if NCA address
    Begin
      // 20220115
      S := '1'; // canadian resident   //175
      if FetchElmFNo(RetNo, InfoFNo, 176) > '' then
        S := '2'; // non-resident
      if (FetchElmFNo(RetNo, InfoFNo, 177) > '') then
        S := '3'; // deemed non-resident
    End;

    // TaxpayerMailingAddress
    add(Space(Indent4) + '<tp:TaxpayerMailingAddress>');
    If AllTrim(Fx.CAREOFNAME) > '' then
      add(Space(Indent4 + 2) + '<comm:AddressCareOfLineText>' + Fx.CAREOFNAME +
        '</comm:AddressCareOfLineText>'); // 20220118
    If FetchElmFNo(RetNo, InfoFNo, 173) > '' then // if NCA address
    Begin
      add(Space(Indent4 + 2) + '<comm:NonCanadianMailingAddress>');
      add(Space(Indent4 + 2) + '<comm:AddressStreetText>' + FetchElmFNo(RetNo,
        InfoFNo, 159) + '</comm:AddressStreetText>'); // thre is NCA
      If FetchElmFNo(RetNo, InfoFNo, 160) > '' then
        add(Space(Indent4 + 2) + '<comm:GlobalAddressMunicipalityName>' +
          FetchElmFNo(RetNo, InfoFNo, 160) +
          '</comm:GlobalAddressMunicipalityName>');
      If FetchElmFNo(RetNo, InfoFNo, 174) > '' then
        add(Space(Indent4 + 2) + '<comm:StateCode>' + FetchElmFNo(RetNo,
          InfoFNo, 174) + '</comm:StateCode>');
      If (UpperCase(FetchElmFNo(RetNo, InfoFNo, 161)) = 'USA') or
        (UpperCase(FetchElmFNo(RetNo, InfoFNo, 161)) = 'UNITED STATES') then
      Begin
        add(Space(Indent4 + 2) + '<comm:USZipCode>');
        add(Space(Indent4 + 2) + '<comm:ZipCode>' + FetchElmFNo(RetNo, InfoFNo,
          172) + '</comm:ZipCode>');
        add(Space(Indent4 + 2) + '</comm:USZipCode>');
      End;
      add(Space(Indent4 + 2) + '<comm:CountryCode>' + LeftStr(FetchElmFNo(RetNo,
        InfoFNo, 161), 3) + '</comm:CountryCode>'); // 20220209
      add(Space(Indent4 + 2) + '</comm:NonCanadianMailingAddress>');
    end
    Else
    Begin
      add(Space(Indent4 + 2) + '<comm:CanadianMailingAddress>');
      add(Space(Indent4 + 2) + '<comm:AddressStreetText>' +
        ReplaceReservedXMLCharacters(Fx.STREET) + '</comm:AddressStreetText>');
      add(Space(Indent4 + 2) + '<comm:AddressMunicipalityName>' +
        ReplaceReservedXMLCharacters(Fx.CITY) +
        '</comm:AddressMunicipalityName>');
      add(Space(Indent4 + 2) + '<comm:AddressProvinceCode>' +
        ReplaceReservedXMLCharacters(Fx.PROVINCE) +
        '</comm:AddressProvinceCode>');
      add(Space(Indent4 + 2) + '<comm:AddressPostalCode>' + Fx.POSTAL +
        '</comm:AddressPostalCode>');
      add(Space(Indent4 + 2) + '</comm:CanadianMailingAddress>');
    end;

    //jz//20250224
    If FetchElm(RetNo, 'INFO', 247) > '' then
      add(Space(Indent4 + 2) + '<tp:HomeAddressSameAsMailingAddressIndicator>' +
        '1' + '</tp:HomeAddressSameAsMailingAddressIndicator>')
    else if FetchElm(RetNo, 'INFO', 248) > '' then
      add(Space(Indent4 + 2) + '<tp:HomeAddressSameAsMailingAddressIndicator>' +
        '2' + '</tp:HomeAddressSameAsMailingAddressIndicator>');

    // 20170117 //20121201
    add(Space(Indent4 + 2) + '</tp:TaxpayerMailingAddress>');
    If (AllTrim(Fx.CLAREA) > '') and (AllTrim(Fx.CLPHONE) > '') then // 20120213
    Begin
      add(Space(Indent4) + '<tp:TaxpayerHomeTelephoneNumber>');
      add(Space(Indent4 + 2) + '<comm:TelephoneAreaCode>' + Fx.CLAREA +
        '</comm:TelephoneAreaCode>');
      add(Space(Indent4 + 2) + '<comm:TelephoneLocalNumber>' +
        CleanUpTelephoneNo(Fx.CLPHONE) + '</comm:TelephoneLocalNumber>');
      add(Space(Indent4 + 2) + '</tp:TaxpayerHomeTelephoneNumber>');
    end;

    if AllTrim(Fx.Email) > '' then
      add(Space(Indent4) + '<tp:TaxpayerEmailAddress>' + Fx.Email +
        '</tp:TaxpayerEmailAddress>'); // 20141117

    add(Space(Indent4 + 2) + '<tp:CorrespondenceLanguageCode>' + Fx.LANGUAGE +
      '</tp:CorrespondenceLanguageCode>');

    add(Space(Indent4) + '</tp:TaxpayerContactData>');
    add(Space(Indent4) + '</t1:TaxpayerData>');

    add(Space(Indent4) + '<t1:RelatedProgramData>');
    add(Space(Indent4) + '<t1:CanadianCitizenshipIndicator>' + Fx.CANCITIZEN +
      '</t1:CanadianCitizenshipIndicator>');

    If FetchElm(RetNo, 'T1', 43) + FetchElm(RetNo, 'T1', 44) = '' then
      // 20220105
      // do nothing
    Else
      add(Space(Indent4) + '<t1:ElectionsCanadaAuthorizationIndicator>' +
        Fx.ElectionsCanada + '</t1:ElectionsCanadaAuthorizationIndicator>');

    S := UpperCase(FetchElm(RetNo, InfoFNo, 128)); // 20191210
    if S > '' then
      S := '1'
    else
      S := '0';
    add(Space(Indent4) + '<t1:IncomeTaxExemptIndianActIndicator>' + S +
      '</t1:IncomeTaxExemptIndianActIndicator>');


    if     (Ret[RetNo].PROVINCE = 'ON') // 20221224
        or (Ret[RetNo].PROVINCE = 'NU')
        or (Ret[RetNo].PROVINCE = 'BC') //jz 20250127
        or (Ret[RetNo].PROVINCE = 'AB') //jz 20251217 - ab added as per ch5-25e.pdf
    then
    Begin
      //jz//20250216
      S := '2'; //false by default //jz//20250216 *Must be present if province of residence is ON, BC or NU or AB.
      if (FetchElm(RetNo, 'T1', 505) > '') then //or //ON //jz//20250216 combine entries (FetchElm(RetNo, 'T1', 529) > '') or //NU (FetchElm(RetNo, 'T1', ???) > '')    //BC - needed a BC entry
        S := '1';  //true

      add(Space(Indent4) + '<t1:DonorConsentIndicator>' + S +
        '</t1:DonorConsentIndicator>'); // 20221222
    End;


    add(Space(Indent4) + '</t1:RelatedProgramData>'); // 20111202
    // relocated after taxpayerdata  //201112
    If IsPreBankruptcyReturn(RetNo) then
    Begin
      add(Space(Indent3) + '<t1:BankruptcyData>');
      add(Space(Indent3) + '<t1:BankruptcyIndicator>' + Fx.ISPREBANKRUPT +
        '</t1:BankruptcyIndicator>'); // t2001213 tp to t1
      add(Space(Indent3) + '<t1:PostBankruptcyNetIncomeAmount>' +
        Fx.POSTBANKRUPTNI + '</t1:PostBankruptcyNetIncomeAmount>');
      add(Space(Indent3) + '<t1:PostBankruptcyAdjustedNetIncomeAmount>' +
        Fx.POSTBANKRUPTAdjustedNI +
        '</t1:PostBankruptcyAdjustedNetIncomeAmount>'); // 20180110
      add(Space(Indent3) + '</t1:BankruptcyData>');
    end;

    If FetchElm(RetNo, 'INFO', 24) > '' then // 20120305
    Begin
      add(Space(Indent3) + '<t1:DeceasedData>');
      add(Space(Indent3) + '<t1:DeceasedIndicator>' + Fx.ISDECEASED +
        '</t1:DeceasedIndicator>'); // 20111213
      add(Space(Indent3) + '<t1:DeathDate>' + Fx.DATEOFDEATH +
        '</t1:DeathDate>');
      // 20170101
      add(Space(Indent3) + '<t1:ElectionToTaxDeceasedBeneficiaryIndicator>' +
        Fx.ElectionToTaxDeceasedBeneficiaryIndicator +
        '</t1:ElectionToTaxDeceasedBeneficiaryIndicator>');
      add(Space(Indent3) + '</t1:DeceasedData>');
    end;

    // 20170331
    IF IsForRefile(RetNo) then
    Begin
      FNo := GetFormNo('REFILEQ');
      If (FetchElmFNo(RetNo, FNo, 1) > '') Or (FetchElmFNo(RetNo, FNo, 2) > '')
        Or (FetchElmFNo(RetNo, FNo, 3) > '') Or
        (FetchElmFNo(RetNo, FNo, 4) > '') Or
        (FetchElmFNo(RetNo, FNo, 5) > '') Then
      Begin
        // Add(Space(Indent3)+'<surv:SurveyData>');
        For i := 1 to 5 do
        Begin
          if FetchElmFNo(RetNo, FNo, i) > '' then // surv section
          begin
            // Add(Space(Indent3)+'<surv:SurveyData>');  //20170331
            // Add(Space(Indent3)+'<surv:SurveyQuestionCode>'+IntToStr(i)+'</surv:SurveyQuestionCode>');   //20170331
            if i = 1 then
            Begin
              mxAnswers := 7;
              FromNdx := 11;
              ToNdx := 15;
            end;
            if i = 2 then
            Begin
              mxAnswers := 5;
              FromNdx := 21;
              ToNdx := 27;;
            end;
            if i = 3 then
            Begin
              mxAnswers := 5;
              FromNdx := 31;
              ToNdx := 35;;
            end;
            if i = 4 then
            Begin
              mxAnswers := 6;
              FromNdx := 41;
              ToNdx := 46;;
            end;
            if i = 5 then
            Begin
              mxAnswers := 5;
              FromNdx := 51;
              ToNdx := 55;;
            end;

            for j := FromNdx to ToNdx Do
            Begin
              k := j;
              if k = FromNdx + 0 then
                AnswerLetter := 'A';
              if k = FromNdx + 1 then
                AnswerLetter := 'B';
              if k = FromNdx + 2 then
                AnswerLetter := 'C';
              if k = FromNdx + 3 then
                AnswerLetter := 'D';
              if k = FromNdx + 4 then
                AnswerLetter := 'E';
              if k = FromNdx + 5 then
                AnswerLetter := 'F';
              if k = FromNdx + 6 then
                AnswerLetter := 'G';

              if FetchElmFNo(RetNo, FNo, k) > '' then
              Begin
                add(Space(Indent3) + '<surv:SurveyData>');
                add(Space(Indent3) + '<surv:SurveyQuestionCode>' + IntToStr(i) +
                  '</surv:SurveyQuestionCode>'); // 20170331
                add(Space(Indent3) + '<surv:SurveyAnswerCode>' + AnswerLetter +
                  '</surv:SurveyAnswerCode>');
                add(Space(Indent3) + '</surv:SurveyData>');
              end;
            End; // j
            // Add(Space(Indent3)+'</surv:SurveyData>');  //20170331
          end; // serv section
        End; // i
      End; // refile
    End;
  end;

  EFlines := TStringList.Create;
  EFlines.LoadFromFile(AppDir + '\' + GetEfileDname(RetNo)); //'EFLINE.D');

  // 20170518
  if IsMultJurisdiction(RetNo) then
  Begin
    TempList1 := TStringList.Create;
    for i := 0 to EFlines.Count - 1 do
    begin
      TempList1.add(EFlines[i]);
    end;
    // for i:=0 to Eflines.Count-2 do begin TempList1.add(Eflines[i]);end; //remove the last entry of the Efiles.d
    TempList2 := TStringList.Create;
    // TempList2.sorted:=true;  //20180326
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
  // *******************
  EFlines.Sorted := True; // 20210420
  // *******************
  // 20190728
  For i := 0 to EFlines.Count - 1 do
  begin
    LLine := myStrToInt(AllTrim(LeftStr(EFlines[i], 5)));
    LType := UpperCase(MidStr(EFlines[i], 6, 1));
    // UpperCase(MidStr(Eflines[i],5,1));
    FName := AllTrim(MidStr(EFlines[i], 8, 9));
    // AllTrim(MidStr(Eflines[i],7,9));

    ElmNo := myStrToInt(AllTrim(MidStr(EFlines[i], 18, 5)));
    FrmSource := MidStr(EFlines[i], 31, 7);
    // 20170519  FrmSource:=MidStr(Eflines[i],30,7);  //20170519

    // if LLine=60999 then showMessage(IntToStr(LLine));  //20200407
    // 20190728
    If MidStr(EFlines[i], 22, 1) = 'R' then
      Rule := myStrToInt(AllTrim(MidStr(EFlines[i], 23, 5)))
      // 20191128 instead of 4
    else
      Rule := 0;

    If (LLine > 0) then // 20191129
    begin
      if FName > '' then // 20191127
        S := GetNetFileAmount(RetNo, LLine, LType, FName, ElmNo, Rule)
      Else
        S := GetNetFileAmount(RetNo, LLine, LType, FName, LLine, Rule);

      If LLine = 61255 then // 20230317
      begin
        If (FetchElm(RetNo, 'T5007#1', 4) = '0') or
          (FetchElm(RetNo, 'T5007#1', 4) = '0.00') then
          S := '101';
      end;

      If LLine = 63051 then // 20221226
      begin
        If (FetchElm(RetNo, 'ON479', 11) > '') then
          S := '1'; // 20220422
        If (FetchElm(RetNo, 'ON479', 12) > '') then
          S := '2'; // 20220422
      end;

      If (LLine = 67062) and (FetchElm(RetNo, 'T2043', 1) > '') then
        S := '1'; // 20220422

      if (GetSinNo(RetNo) = '870001245') and (LLine = 17700) then S := '5'; // 20240125
      // 20240125 if (GetSinNo(RetNo) = '870000643') and (LLine = 58200) then S := FetchElm(RetNo, 'S5PRV', 87); // 20210104 //case 52 PE

      // =======================
      // 20240508 test case 5 mj



      //jz//MJCERT2024 - not valid for 2024 iteration of MJ CERT 
      {
      If (LLine = 60720) // 20240506
        and (IsMultJurisdiction(RetNo)) and (GetSinNo(RetNo) = '870000338') then
      Begin
        S := '1';
      End;

      If (LLine = 61470) and (IsMultJurisdiction(RetNo)) and
        (GetSinNo(RetNo) = '870000338') then
      Begin
        S := '1516'; // 20240506
      End;
      }
      // ============================================
      { no good
        If LLine = 17700 then  //20240323
        begin
        If Vl(S)>1 then s:='0'+s;
        end;
      }
      If (LLine > 0) and (LType = '$') and (Vl(S) = 0) then
        S := '';
      If (LLine > 0) and (LType = 'C') and (Vl(S) = 0) then
        S := '';

      // 20200404 Eilg dependant netincome
      if LLine = 51106 then // 20200404
      Begin
        if (S = '') and (Ret[RetNo].Lnn[30400] > 0) then
          S := '1';
      End;

      if LLine = 56120 then // 20200404
      Begin
        // 20200102
        If IsMultJurisdiction(RetNo) then // 20210415
        Begin
          if Vl(FetchElm(RetNo, 'T2203', 421)) > 0 then
            S := FetchElm(RetNo, 'T2203', 421);
          if Vl(FetchElm(RetNo, 'T2203', 501)) > 0 then
            S := FetchElm(RetNo, 'T2203', 501);
          if Vl(FetchElm(RetNo, 'T2203', 601)) > 0 then
            S := FetchElm(RetNo, 'T2203', 601);
          if Vl(FetchElm(RetNo, 'T2203', 801)) > 0 then
            S := FetchElm(RetNo, 'T2203', 801);
          if Vl(S) = 1 then
            S := '1' // 20210419
          Else
          Begin
            if Vl(S) > 1 then
              S := LeftStr(S, Length(S) - 3)
            Else
              S := '';
          end;
        End;
      End;

      { //jz//20251211 - seems that adding a 1 amount is no longer necessary when any of 50339, 50340, 50341 have a value - not said to be required in ch4-25e.pdf
      //jz//20250322 - S8/RC381 CPP lines CRA requires to be sent for processing if others have values
      if (LLine = 50339) or
         (LLine = 50340) or
         (LLine = 50341)
      then
      begin
        if (S = '') and  (ret[retno].Lnn[50339] + ret[retno].Lnn[50340] + ret[retno].Lnn[50341] > 0) then
        begin
          S := '1';
          if IsEFOverride(RetNo,LLine) then  //jz//20250331 - redo efmemo overide for these as it is required in certs
            S := FloatToStr(GetEFOverride(RetNo,LLine));
            if S='0' then S:='';
        end;
      end;
      }

      //jz//20250322 - RC381 QPP lines CRA requires to be sent for processing if others have values
      if (LLine = 50329) or
         (LLine = 50330) //or (LLine = 50331) //jz//s8rev+rc381rev//20250614 50331 is only "if applicable" aka has a value
      then
      begin
        if (S = '') and (ret[retno].Lnn[50329] + ret[retno].Lnn[50330] + ret[retno].Lnn[50331] > 0) then
        begin
          S := '1';
          if IsEFOverride(RetNo,LLine) then //jz//20250331 - redo efmemo overide for these as it is required in certs
            S := FloatToStr(GetEFOverride(RetNo,LLine));
            if S='0' then S:='';
        end;
      end;

      //IF HAS VALUE, IS NOT BLANK
      If S > '' then
      begin
        If LLine < 100 then
          LLineString := PaddZero(IntToStr(LLine), 5)
          // LLineString := PaddZero(IntToStr(LLine),3) //20190728
        else
          LLineString := IntToStr(LLine);

        if (LLine = 50340) and (GetEFOverride(RetNo, 50340) = 1) then //jz//20260131 - added 0 --> GetEFOverride(RetNo, 5034)
          S := '1';                                                   //20190101 as opposed to with cents
        if (LLine = 58209) then
          S := AddLeadingZeros(S, 2); // needs 2 digits //20191210
        if (LLine = 50372) then
          S := AddLeadingZeros(S, 2); // needs 2 digits //20200108
        if (LLine = 50374) then
          S := AddLeadingZeros(S, 2); // needs 2 digits //20210106

        // ---------------

        // if lline=63990 then ShowMessage('63990');  //20200331


        //jz//20250322
        //TagInsertbyRule(retNo, rule, XmlList);


        if IsMultJurisdiction(RetNo) = False then // 20170519
          XmlList.add(Space(Indent4) + '<comm:ReturnLine>' + Chr(13) // 20240115
            + '<comm:FieldCode>' + LLineString + '</comm:FieldCode>' + Chr(13)
            // 20240115
            + '<comm:FieldValue>' + S + '</comm:FieldValue>' + Chr(13)
            // 20240115
            + '</comm:ReturnLine>')
        Else
        Begin // multijurisdiction
          // if lline=63856 then showmessage('63856');

          if ExcludeFormsInMult(RetNo, FName, FrmSource, LLine) = False then                  //jz//20260326//MJCERT2025 - just for readability
            XmlList.add(Space(Indent4) + '<comm:ReturnLine>' + Chr(13) +
                        Space(Indent5) +                                                      // jz 20240507 //20240505 change spacong for file compare
                        '<comm:FieldCode>'  + LLineString + '</comm:FieldCode>' + Chr(13) +
                        Space(Indent5)      +                                                 // jz 20240507
                        '<comm:FieldValue>' + S + '</comm:FieldValue>' + Chr(13) +            // jz 20240507
                        Space(Indent4) + '</comm:ReturnLine>');                               // jz 20240507

          // XmlList.add(Space(Indent4)
          // + '<comm:ReturnLine>'
          // +'<comm:FieldCode>' + LLineString + '</comm:FieldCode>'
          // +chr(13)
          // + '<comm:FieldValue>' + S + '</comm:FieldValue>'
          // +Chr(13)
          // + '</comm:ReturnLine>');
        End;
      end; { s>'' }
    end; { if line or value exists }
  end; { i }

  // now build the businerss statements

  BuildSfds(RetNo);

  // footer  //20111202
  XmlList.add(Space(Indent2) + '</t1:T1Return>'); // this ends the t1 data
  XmlList.add('</t1rq:TaxReturnForm>');

  // jz 20240209 <<<
  If Fx.FirstTimeFiler then
  begin
    XmlList.add('<comm:GivenName>' +
                  ReplaceReservedXMLCharacters(FetchElmFNo(RetNo, InfoFNo, 233)) + //jz//20250321 - name transfered to here, get it from the actual box //(Fx.FIRSTNAME)
                '</comm:GivenName>');

    XmlList.add('<t1rq:SecondName>' +
                  ReplaceReservedXMLCharacters(FetchElmFNo(RetNo, InfoFNo, 235)) + '</t1rq:SecondName>');

    XmlList.add('<comm:FamilyName>' +
                  ReplaceReservedXMLCharacters(FetchElmFNo(RetNo, InfoFNo, 234)) + //jz//20250321 - name transfered to here, get it from the actual box //(Fx.LASTNAME) +
                '</comm:FamilyName>');

    // jz 20240223  //20240223
    // Fx.SECONDNAME) + '</t1rq:SecondName>'); //jz 20240223
  end;
  // jz 20240209 >>>

  XmlList.add('</t1rq:EfileReturnRequest>');

  // 20131217 //If OnlineMethod='EOL' then
  begin
    // XmlList.add(Space(Indent1)+'</efile:Efile>');  //20141122
    Try
        saveXMLWithNoCRAPasswordID(EolTaxFlName, XmlList, false); //(savelocation:string; aList:tstringlist; promtToSave:boolean);
        //XmlList.SaveToFile(EolTaxFlName); // 20111202
    Except
      on E: Exception do
        MessageDlg(E.Message, mtError, [mbok], 0); // 20130317
    end;

    // 20141204 - Create list of all Efile Codes
    If ProdOrTest = 'T' then
    begin
      If DirectoryExists(NetFileDir + '\EfValues') = False then
        ForceDirectories(NetFileDir + '\EfValues');
      CreateFileWithEFValues(EolTaxFlName, NetFileDir + '\EfValues' + '\' +
        GetLastName(RetNo) + '.VT');
    end;
  end;
end;

Procedure BuildPartners;
Var
  i: Integer;
Begin
  If (SFD.PRec[1].PPerCent = '') and (SFD.PRec[2].PPerCent = '') and
    (SFD.PRec[3].PPerCent = '') and (SFD.PRec[4].PPerCent = '') and
    (SFD.PRec[5].PPerCent = '') then
    exit;

  For i := 1 to 5 do
  begin
    If SFD.PRec[i].PPerCent > '' then
    begin
      If AllTrim(SFD.PRec[i].PFirstName + SFD.PRec[i].PLastName) > '' then
      // 20200101
      Begin
        XmlList.add(Space(Indent4) + '<sfd:PartnerCoOwnerData>');
        XmlList.add(Space(Indent4) + '<sfd:PartnerName>');
        BuildDtlIN2570(RetNo, SFD.PRec[i].PFirstName, SFD.PRec[i].PLastName);
        XmlList.add(Space(Indent4) + '</sfd:PartnerName>');
        BuildDtlN1550(RetNo, SFD.PRec[i].PSin); // pin
        BuildDtlTIA600(RetNo, SFD.PRec[i].PPerCent);
        XmlList.add(Space(Indent4) + '</sfd:PartnerCoOwnerData>');
      End;
      { 630-710 is for NISA }
    end;
  end;
end;

Function CleanUpTelephoneNo(S: String): String;
Begin
  S := Removechar(Removechar(S, ' '), '-');
  Result := AllTrim(S);
end;

// 20190206 is a duplicate ExcludeFormsInMult in unit T1_2026bardatagen;

Function ExcludeFormsInMult(RetNo: Integer; FName: String; FrmSource: String;
  LLine: Integer): boolean; // 20190327 add retno
Var
  Nm: String;
Begin
  Result := False;
  FName := UpperCase(FName);
  FrmSource := UpperCase(FrmSource);

  If LLine = 58300 then // 20190327
  begin
    if Ret[RetNo].PROVINCE = 'NL' then
    begin
      Result := False;
      exit;
    end // allow
    Else
    begin
      Result := True;
      exit;
    end // Exclude
  end;

  // ==== ******** 20190325  ALLOW THE FOLLOWING lines in Efile  Result=fase means allow it ******

  // some credit for non home province this is Yt cedit YT379 credit in a MultJurid of home NU
  
  
  if LLine = 62400 then //jz//20260328//MJCERT2025 - NS Search and rescue volunteer amount
  begin
    Result := False;
    exit;
  End;


  if LLine = 61545 then //jz//20260328//MJCERT2025 - Alberta supplemental tax credit
  begin
    Result := False;
    exit;
  End;

  if LLine = 61470 then //jz//20260328//MJCERT2025 - Family tax benefit
  begin
    Result := False;
    exit;
  End;

  if LLine = 63850 then //jz//20260329//MJCERT2025 - Yukon political contributions
  begin
    Result := False;
    exit;
  End;

  if LLine = 59800 then //jz//20260329//MJCERT2025 - Active families benefit for Saskatchewan
  begin
    Result := False;
    exit;
  End;

  if LLine = 60970 then //jz//20260329//MJCERT2025 - Reduction for dependants with a mental or physical infirmity: Number of dependants ON, MB
  begin
    Result := False;
    exit;
  End;

  if LLine = 60545 then // a bc clean building credit //20240508
  begin
    Result := False;
    exit;
  End; // 20180405  //allow it

  if LLine = 63856 then
  // some credit for non home province this is Yt cedit YT379 credit in a MultJurid of home NU
  begin
    Result := False;
    exit;
  End; // 20180405  //allow it

  if LLine = 63810 then // 20240508 Allow it
  begin
    Result := False;
    exit;
  End;

  if LLine = 63850 then // 20240508 Allow it
  begin
    Result := False;
    exit;
  End;

  if LLine = 63860 then
  begin
    Result := False;
    exit;
  End; // 20180405  //allow it

  if LLine = 60760 then
  begin
    Result := False;
    exit;
  End; // 20180405  //allow it

  if LLine = 60990 then
  begin
    Result := False;
    exit;
  End; // 20180405  //allow it
  if LLine = 60999 then
  begin
    Result := False;
    exit;
  End; // 20180405  //allow it  //20200407
  // if Lline=60480 then begin Result:=False;Exit;End;  //20180404  //allow it  //20200401

  if LLine = 63047 then
  begin
    Result := False;
    exit;
  End; // 20220414
  if LLine = 63800 then
  begin
    Result := False;
    exit;
  End; // 6392  //allow it Case 3 for YT

  if LLine = 60720 then
  begin
    Result := False;
    exit;
  End; // 20180405  //allow it

  if LLine = 63990 then
  begin
    Result := False;
    exit;
  End; // 6390  //allow it
  if LLine = 62140 then
  begin
    Result := False;
    exit;
  End; // On low income //20200331
  if LLine = 58220 then
  begin
    Result := False;
    exit;
  End; // 20190401
  // 20200520 On479 Selempl credit fields
  if LLine = 63255 then
  begin
    Result := False;
    exit;
  End; // allow it
  if LLine = 63260 then
  begin
    Result := False;
    exit;
  End; // allow it
  if LLine = 63270 then
  begin
    Result := False;
    exit;
  End;
  // 20200521
  if LLine = 63280 then
  begin
    Result := False;
    exit;
  End;
  if LLine = 63300 then
  begin
    Result := False;
    exit;
  End;
  //
  // Allow 5822 it to be picked up in the exclusions list
  // listed in EfLineT2203 to come from line 583 of T2203
  // Rule=5822 for Sk428  It picks up only if Province=SK
  // T2203 says: If ret[RetNo].Province = 'SK' Then Tv[683] := Vl(FetchElmFNo(RetNo, S428FNo, 67));
  

  if LLine = 61496 then //jz//20260325//MJCERT2025 - allow it
  begin
    Result := False;
    exit;
  End;

  if LLine = 58175 then // 20210422
  begin
    Result := False; // 20240506
    exit; // 20180405  //allow it  //20190326 //bc caregiver
  End;

  if LLine = 58340 then // 20220419
  begin
    Result := False;
    exit; // allow it
  End;

  if LLine = 61870 then
  begin
    Result := False;
    exit;
  End; // NL reduction //20190327
  if LLine = 61880 then
  begin
    Result := False;
    exit;
  End; // NL reduction //20190327

  if LLine = 58229 then
  begin
    Result := False;
    exit;
  End; // 6372 NS, PE? Number of kids //20190402

  if LLine = 62150 then
  begin
    Result := False;
    exit;
  End; // 6098 NS farm food //20190328
  if LLine = 63990 then
  begin
    Result := False;
    exit;
  End; // NU kds  //20200331

  // if Lline=898 then begin Result:=False;Exit;End;  //BC food bank //20190327 wrong num 5898

  If FName = 'MB428A' Then
  begin
    Result := False;
    exit;
  End; // 20180405  allow it //20190325
  If FName = 'MBMJA' Then
  begin
    Result := False;
    exit;
  End; // 20190207  allow it
  
  if LLine = 61268 then //jz//20260327//MJCERT2025 - allow fertility treatment as per TC4
  begin
    Result := False;
    exit;
  End;

  If MidStr(FName, 3, 3) = '428' then
  Begin
    Result := True;
    exit;
  end; // do not allow it //20180406

  If MidStr(FName, 3, 3) = '479' then
  Begin
    if LLine = 60760 then
    begin
      Result := False;
      exit;
    End; // 20180405  //allow it
    if LLine = 60999 then
    begin
      Result := False;
      exit;
    End; // 6099   //allow it
    if LLine = 60480 then
    begin
      Result := False;
      exit;
    End; // 20180404  //allow it
    if LLine = 63900 then
    begin
      Result := False;
      exit;
    End; // 6392 //allow it Case 3 for YT

    if LLine = 60720 then
    begin
      Result := False;
      exit;
    End; // 20180405  //allow it

    if LLine = 63990 then
    begin
      Result := False;
      exit;
    End; // 20200331  //ON allow it

    if LLine = 63050 then
    begin
      Result := False;
      exit;
    End; // 20200331  //ON allow it
    if LLine = 63855 then
    begin
      Result := False;
      exit;
    End; // 20200331  //ON allow it  //20200403

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

//jz//20250322
procedure TagInsertbyRule(retNo, rule:integer; var XmlList:Tstringlist);
begin

  if rule = 50339 then  //to avoid efile error 95548
  begin
    if ret[retno].Lnn[50339] + ret[retno].Lnn[50340] + ret[retno].Lnn[50341] > 0 then
    begin
      if ret[retno].Lnn[50339] = 0 then
      begin
        XmlList.add(Space(Indent4) + '<comm:ReturnLine>' + Chr(13)
                                   + '<comm:FieldCode>'  + '50339' + '</comm:FieldCode>' + Chr(13)
                                   + '<comm:FieldValue>' +  '1' + '</comm:FieldValue>' + Chr(13)
                                   + '</comm:ReturnLine>');
      end;
      if ret[retno].Lnn[50340] = 0 then
      begin
        XmlList.add(Space(Indent4) + '<comm:ReturnLine>' + Chr(13)
                                   + '<comm:FieldCode>'  + '50340' + '</comm:FieldCode>' + Chr(13)
                                   + '<comm:FieldValue>' +  '1' + '</comm:FieldValue>' + Chr(13)
                                   + '</comm:ReturnLine>');

      end;

      {//20251129 Case #7 fails because of $1 inserted
      if ret[retno].Lnn[50341] = 0 then
      begin
        XmlList.add(Space(Indent4) + '<comm:ReturnLine>' + Chr(13)
                                   + '<comm:FieldCode>'  + '50341' + '</comm:FieldCode>' + Chr(13)
                                   + '<comm:FieldValue>' +  '1' + '</comm:FieldValue>' + Chr(13)
                                   + '</comm:ReturnLine>')
      end;
      }
    end;
  end; //end rule = 50339

   //jz//s8rev+rc381rev//20250614 - rule does not seem to be in use but remove 50331 just in case
  if rule = 50329 then
  begin
    if ret[retno].Lnn[50329] + ret[retno].Lnn[50330] + ret[retno].Lnn[50331] > 0 then
    begin
      if ret[retno].Lnn[50329] = 0 then
      begin
        XmlList.add(Space(Indent4) + '<comm:ReturnLine>' + Chr(13)
                                   + '<comm:FieldCode>'  + '50329' + '</comm:FieldCode>' + Chr(13)
                                   + '<comm:FieldValue>' +  '1' + '</comm:FieldValue>' + Chr(13)
                                   + '</comm:ReturnLine>');
      end;
      if ret[retno].Lnn[50330] = 0 then
      begin
        XmlList.add(Space(Indent4) + '<comm:ReturnLine>' + Chr(13)
                                   + '<comm:FieldCode>'  + '50330' + '</comm:FieldCode>' + Chr(13)
                                   + '<comm:FieldValue>' +  '1' + '</comm:FieldValue>' + Chr(13)
                                   + '</comm:ReturnLine>');

      end;
      {     ////jz//s8rev+rc381rev//20250614 50331 is only "if applicable" aka has a value
      if ret[retno].Lnn[50331] = 0 then
      begin
        XmlList.add(Space(Indent4) + '<comm:ReturnLine>' + Chr(13)
                                   + '<comm:FieldCode>'  + '50331' + '</comm:FieldCode>' + Chr(13)
                                   + '<comm:FieldValue>' +  '1' + '</comm:FieldValue>' + Chr(13)
                                   + '</comm:ReturnLine>')
      end;
      }
    end;
  end; //end rule = 50329



end;




end.
