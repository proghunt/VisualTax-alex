Unit T1_2026Calc;

{ ?  T4RIF box 24: excess amount : no processing done
}
interface


uses
  SysUtils, Math, //20251219 Math lib added for IfThen using in the code.
  WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  System.Generics.Collections,  //20230801
  Forms, StdCtrls, Dialogs, DBctrls, ExtCtrls, {$WARN UNIT_PLATFORM OFF}FileCtrl{$WARN UNIT_PLATFORM ON}, ComCtrls,
  T1_2026Declare, T1_2026common, T1_2026common2, T1_2026TrimStr, T1_2026T1Rtns,
  T1_2026T1Rtns2, T1_2026Calc1, T1_2026Calc2, // 20160119 Igor
  T1_2026Calc3, T1_2026Calc4, T1_2026CalcBus, T1_2026CalcCpl,
  T1_2026CalcMj {,UPopList, UCalndr} , vtEditBox, // 20160119 Igor

  RxRichEd; // 20160819 Igor (It must be the last)


Procedure T106(RetNo: integer; FName: String; FNo: integer);
Procedure T106SL(RetNo: integer; FName: String; FNo: integer);
Procedure HOMEWS(RetNo: integer; FName: string; FNo: integer); //jz//20260127 - not discontinued //20260106 discontinued
Procedure T1134(RetNo: integer; FName: String;FNo: integer); //20230801
Procedure T1134S(RetNo: integer; FName: String;FNo: integer); //20230801

Procedure LN30000(RetNo: integer; FName: String; FNo: integer); // 20200821
Procedure LN34990(RetNo: integer; FName: String; FNo: integer); // 20260103

Procedure T1SALDIV(RetNo: integer; FName: String; FNo: integer); // 20200821
Procedure CalcPrintJacket(RetNo: integer); // 20200222
Function PrecalcS6(RetNo: integer): Boolean; // 20190407
//procedure transferS2MJtoS2MJxx(RetNo: integer; s2T2203Prov: string); // 20190208

Function SpouseTosiInEffect(RetNo: integer; InfoFormNo: integer): Boolean;
Function GetSpouseSplitIncome(RetNo, InfoFormNo: integer): Real;
Function GetSpouseTosiNetIncome(RetNo, InfoFormNo: integer): Real;
// for line 5912
Function GetDependantSplitIncome(RetNo, i, DependFNo: integer): Real;
Function GetDependantTosiTaxableIncome(RetNo, i, DependFNo: integer): Real;
Function GetDependantTosiL300ToL314(RetNo, i, DependFNo: integer): Real;
Function GetDependantTosiPrvTaxableIncome(RetNo, i, DependFNo: integer): Real;
// 20181220
Function GetTOSIPrvTax(RetNo: integer): Real;
Function TOSIinEffect(RetNo: integer): Boolean;
Function GetTOSINetIncome(RetNo: integer): Real;
Function GetTOSIFedTaxableIncome(RetNo: integer): Real;
Function GetTOSIPrvTaxableIncome(RetNo: integer): Real;

Procedure PopulateS14G(RetNo: integer);
Function GetClimateChangeAmount(RetNo: integer; Prov: String): Real;
//Function QualifiedForClimateAction(RetNo: integer): Boolean; //20220103
{
Procedure S14ON(RetNo: integer; FName: String; FNo: integer);
Procedure S14AB(RetNo: integer; FName: String; FNo: integer);
Procedure S14SK(RetNo: integer; FName: String; FNo: integer);
Procedure S14MB(RetNo: integer; FName: String; FNo: integer);
}

Procedure S14(RetNo: integer; FName: String; FNo: integer);
//Procedure S14YT(RetNo: integer; FName: String; FNo: integer); //20251227CZ

Procedure ZeroOutNonRefundableTaxCredits(RetNo: integer); // 20180428
Procedure T7DRQR(RetNo: integer; FName: String; FNo: integer); // 20180310
Procedure InitConstants;
Procedure InitPRVConstants(Prv: String);

Procedure T1OVP(RetNo: integer; FName: String; FNo: integer);
Procedure REFILEV(RetNo: integer; FName: String; FNo: integer); // 20170205
Procedure REFILEQ(RetNo: integer; FName: String; FNo: integer); // 20170205
Procedure T2036SUM(RetNo: integer; FName: String; FNo: integer); // 20170205
Procedure SCHSUPPL(RetNo: integer; FName: String; FNo: integer);
Procedure ONMTXWS(RetNo: integer; FName: String; FNo: integer);
// 20160116
Procedure CFRAFILL(RetNo: integer; FName: String; FNo: integer);
Procedure T5008Dtl(RetNo: integer; FName: String; FNo: integer);
Procedure CDE(RetNo: integer; FName: String; FNo: integer);

Procedure CPPADJ(RetNo: integer; FName: String; FNo: integer);
Procedure TaxChart(RetNo: integer; FName: String; FNo: integer); // 20141121
Procedure RC151(RetNo: integer; FName: String; FNo: integer);
Procedure RC381(RetNo: integer; FName: String; FNo: integer);
Procedure RC383(RetNo: integer; FName: String; FNo: integer);
Procedure PROVCTB(RetNo: integer; FName: String; FNo: integer);
Procedure T10141W(RetNo: integer; FName: String; FNo: integer);
Procedure T10142W(RetNo: integer; FName: String; FNo: integer);
Procedure T10142(RetNo: integer; FName: String; FNo: integer);
Procedure T1232(RetNo: integer; FName: String; FNo: integer);
Procedure T1129(RetNo: integer; FName: String; FNo: integer);
Procedure CPT20(RetNo: integer; FName: String; FNo: integer);
Function getIndexToADisabledDependant(RetNo: integer; k: integer): integer;
Function getIndexToACareGiverDependant(RetNo: integer; k: integer): integer;
Function GetT4Box38(RetNo: integer; EmployerName: String): Real;
Procedure CreateRc359Forms(RetNo: integer);
Function GetRC359Rate(RetNo: integer): Real;
Procedure RC359(RetNo: integer; FName: String; FNo: integer);
Procedure RC360(RetNo: integer; FName: String; FNo: integer);
Function IsFormElmInT1PropDynList(FName: String; Fld: integer): Boolean;
Procedure TESTFRM(RetNo: integer; FName: String; FNo: integer);
procedure MCREDIT(RetNo: integer; FName: String; FNo: integer);
procedure MXCREDIT(RetNo: integer; FName: String; FNo: integer);
Procedure T1ADJi(RetNo: integer; FName: String; FNo: integer);
procedure PRVSUM(RetNo: integer; FName: String; FNo: integer);
// Procedure RC310(RetNo: integer; FName: String;FNo: integer);  //20170126
Procedure BLANKPG(RetNo: integer; FName: String; FNo: integer);
Procedure ACBSUM(RetNo: integer; FName: String; FNo: integer);
Procedure CCALIST(RetNo: integer; FName: String; FNo: integer);
Procedure ExtractCCAList(RetNo: integer; Var RowNdx: integer; FNm: String;
  K1, K2, KBy: integer);
procedure RC201(RetNo: integer; FName: String; FNo: integer);
procedure RC210(RetNo: integer; FName: String; FNo: integer);
procedure T1032(RetNo: integer; FName: String; FNo: integer); // 20100627
procedure T1032WS(RetNo: integer; FName: String; FNo: integer);
procedure T1132(RetNo: integer; FName: String; FNo: integer);
procedure T1014(RetNo: integer; FName: String; FNo: integer);
procedure T10141(RetNo: integer; FName: String; FNo: integer);
//procedure T1005(RetNo: integer; FName: String; FNo: integer); //20220130
Procedure ASSETS(RetNo: integer; FName: string; FNo: integer);
Function CalcTransfereeLn314(RetNo: integer): Real; // pension deduction
Procedure CalcForOptimizeUpToTxbl(RetNo: integer);
Procedure CalcForOptimizeAfterTxbl(RetNo: integer);
Procedure CalcAllforOptimizeUpToTxbl(RetNo: integer);
Procedure CalcAllforOptimizeAfterTxbl(RetNo: integer);
Function CalcLn115(RetNo: integer): Real;
Function CalcLn15000(RetNo: integer): Real;
Function CalcLn23300(RetNo: integer): Real;  //20211113
Function CalcLn257(RetNo: integer): Real;
Procedure AUTO777(RetNo: integer; FName: String; FNo: integer);
Procedure OPTIMIZE(RetNo: integer; FName: String; FNo: integer);
Procedure WARNOFF(RetNo: integer; FName: String; FNo: integer);
Procedure CalcUsedFrm(RetNo: integer);
Procedure USEDFRM(RetNo: integer; FName: String; FNo: integer);
Procedure S10(RetNo: integer; FName: String; FNo: integer);
Procedure RC62(RetNo: integer; FName: String; FNo: integer);
Procedure FECONV(RetNo: integer; FName: String; FNo: integer);
Procedure ADOPT(RetNo: integer; FName: String; FNo: integer);
Procedure CLETTER(RetNo: integer; FName: String; FNo: integer);
Procedure BARCODE(RetNo: integer; FName: String; FNo: integer);

//Procedure T2201H(RetNo: integer; FName: String; FNo: integer);  //20220220

Procedure T1297(RetNo: integer; FName: String; FNo: integer);
Procedure T1299(RetNo: integer; FName: String; FNo: integer);

Procedure T2202(RetNo: integer; FName: String; FNo: integer);

Procedure T2201(RetNo: integer; FName: String; FNo: integer);

Procedure RC59(RetNo: integer; FName: string; FNo: integer);
Procedure RC267(RetNo: integer; FName: string; FNo: integer);
Procedure RC268(RetNo: integer; FName: string; FNo: integer);
Procedure RC269(RetNo: integer; FName: string; FNo: integer);
Procedure RC59I(RetNo: integer; FName: string; FNo: integer);

Procedure Test(RetNo: integer; FName: String; FNo: integer);

Procedure GetFamSumData(RetNo, RNo, k: integer); //20240123 Igor
//Procedure GetFamSumData(RNo, k: integer);
Procedure GetCurrentYrSum2Data(RNo, FNo, k: integer);
Procedure GetLastYrSum2Data(RNo, k: integer);
Function CalcPRVSpousalClaim(RetNo: integer; Ni: Real): Real;
Function PrvTaxBfrT2036(RetNo: integer): Real;
Procedure ClearThisForm(RetNo: integer; FName: string);
Procedure CalcMultiPageForm(RetNo: integer; FName: string);
Procedure CalcPrvTaxAndCredits(RetNo: integer);
Function CalcSpousalClaim(RetNo: integer; Ni: Real): Real;
// Procedure LoadTV(RetNo: integer;FName: string; FNo : integer);
// Procedure SaveTV(RetNo: integer;FName: string; FNo : integer);
Procedure Calc(RetNo: integer; FName: string);
Procedure CalcAffectedBy(RetNo: integer; FName: String);
procedure INFO(RetNo: integer; FName: string; FNo: integer);
procedure T1(RetNo: integer; FName: string; FNo: integer);
procedure T4(RetNo: integer; FName: string; FNo: integer);
Procedure T4RIF(RetNo: integer; FName: String; FNo: integer);
Procedure T4PS(RetNo: integer; FName: String; FNo: integer);
Procedure T4AP(RetNo: integer; FName: String; FNo: integer);
Procedure T4ARCA(RetNo: integer; FName: String; FNo: integer);
// Procedure T3(RetNo: integer; FName: String;FNo: integer);
Procedure T5(RetNo: integer; FName: String; FNo: integer);
Procedure T5MULT(RetNo: integer; FName: String; FNo: integer);
Procedure T3MULT(RetNo: integer; FName: String; FNo: integer);
Procedure OPECGB(RetNo: integer; FName: String; FNo: integer);
Procedure T5007(RetNo: integer; FName: String; FNo: integer);
Procedure T5013(RetNo: integer; FName: String; FNo: integer);
Procedure FPENS(RetNo: integer; FName: String; FNo: integer);
Procedure PTRANSIT(RetNo: integer; FName: String; FNo: integer);
Procedure CALCALL(RetNo: integer);
Procedure CalcFullReturn(RetNo: integer);
procedure NPAD(RetNo: integer; FName: String; FNo: integer);
procedure NPADC(RetNo: integer; FName: String; FNo: integer);
procedure ADDINFO(RetNo: integer; FName: String; FNo: integer);
procedure DEPEND(RetNo: integer; FName: String; FNo: integer);
procedure FAMSET(RetNo: integer; FName: String; FNo: integer);
procedure FORECLO(RetNo: integer; FName: String; FNo: integer);
procedure UNIOND(RetNo: integer; FName: String; FNo: integer);
procedure OTHEMPL(RetNo: integer; FName: String; FNo: integer);
procedure ABIL(RetNo: integer; FName: String; FNo: integer);
procedure AJCTC(RetNo: integer; FName: String; FNo: integer);
procedure DON(RetNo: integer; FName: String; FNo: integer);
procedure DONSUPL(RetNo: integer; FName: String; FNo: integer);
procedure RRSP(RetNo: integer; FName: String; FNo: integer);
procedure RRSPNXT(RetNo: integer; FName: String; FNo: integer);
procedure RPP(RetNo: integer; FName: String; FNo: integer);
procedure ACBOTHR(RetNo: integer; FName: String; FNo: integer);
procedure STATUS(RetNo: integer; FName: String; FNo: integer);
procedure FLTHRU(RetNo: integer; FName: String; FNo: integer);
procedure FPINFO(RetNo: integer; FName: String; FNo: integer);
procedure TAXSUM(RetNo: integer; FName: String; FNo: integer);
procedure FAMSUM(RetNo: integer; FName: String; FNo: integer);
procedure YRSUM2(RetNo: integer; FName: String; FNo: integer);
procedure GSTC(RetNo: integer; FName: String; FNo: integer);
Procedure AUTOEXP(RetNo: integer; FName: String; FNo: integer);
Procedure Autos(RetNo: integer; FName: string; FNo: integer);
Procedure FITNESS(RetNo: integer; FName: String; FNo: integer);
Procedure ARTS(RetNo: integer; FName: String; FNo: integer);
Procedure BCARTS(RetNo: integer; FName: String; FNo: integer);
Procedure MBARTS(RetNo: integer; FName: String; FNo: integer);
Procedure YTARTS(RetNo: integer; FName: String; FNo: integer);
Procedure MBFITNES(RetNo: integer; FName: String; FNo: integer);
procedure T1DD(RetNo: integer; FName: String; FNo: integer);
Procedure PTIMEWS(RetNo: integer; FName: String; FNo: integer);
{ two separate routines }
Procedure FLDMEM(RetNo: integer; FName: String; FNo: integer);
Procedure FLDTAPE(RetNo: integer; FName: String; FNo: integer);

{ I M P L E M E N T A T I O N }
implementation

Uses vtMulti, vtCommon, vtChild, vtDynData, // 20160119 Igor
  T1_2026, T1_2026ChildWinNew, T1_2026Main, // 20160119 Igor
  vtTrimStr, vtShared;

Procedure TaxChart(RetNo: integer; FName: String; FNo: integer); // 20141121
begin
  // CalcFedTaxByBrackets(RetNo,FNo,TxblInc,0);
end;

//20250928
Procedure InitConstants; // federal
Var
  Cpi: Real;
begin
 S8Fno:=GetFormNo('S8');  //20241222
  // 20190703
//Federal  https://www.canada.ca/en/revenue-agency/services/tax/individuals/frequently-asked-questions-individuals/adjustment-personal-income-tax-benefit-amounts.html
//Provincil:

  // https://www.advisor.ca/tax/tax-news/essential-tax-numbers-for-2017/
  // CPP: https://www.payworks.ca/payroll-legislation/CPPEI.asp

  (*
    Tax brackets:
    http://www.taxtips.ca/taxrates/canada.htm
    http://www.taxtips.ca/taxrates/on.htm  (similar for other provinces)

    Non-Refundable Credits
    http://www.taxtips.ca/nrcredits/tax-credits-2015-base.htm
  *)


  // 20170919
  { 0:current year, 1:=next year(planner) }
  // :=Round(oldamount*CPI);

  // ALSO:  https://www.ontario.ca/data/personal-income-tax-rates-and-credits
  // BEST SOURCE Rates and Non-refundable:
  // http://www.cra-arc.gc.ca/tx/ndvdls/fq/ndxtn-eng.html  CRA


  // CRA documents
  // http://www.cra-arc.gc.ca/tx/ndvdls/fq/txrts-eng.html  GOOD
  // http://www.cra-arc.gc.ca/nwsrm/fctshts
  // see T4127 guide for next year
  // http://www.cra-arc.gc.ca/tx/ndvdls/fq/txrts-eng.html#federal
  // http://www.cra-arc.gc.ca/nwsrm/fctshts/2015 Indexed amounts  ****

  { FEDERAL }   // See 5000-d issued by CRA in August
  Cpi := 1.063; // 2023 //1.022; // 2015 //1.028; //20120606

  Constant[0].DivOtherThanElig := 9.0301; // 2025 //see CRA D1
  Constant[1].DivOtherThanElig := 9.0301; // 2025 //see CRA D1

  Constant[0].DivElig := 15.0198; // 2025   //see CRA D1
  Constant[1].DivElig := 15.0198; // 2025   //see CRA D1
  //designated by issuing corp after informing its shareholders

  // 20150903   // FCA=Family CareGiver Amount
  Constant[0].FCAAmount:= 2687; // 2025  See S5
  Constant[1].FCAAmount:= 2687; // 2025  See S5

  // http://www.cra-arc.gc.ca/tx/rgstrd/papspapar-fefespfer/lmts-eng.html  RRSP etc limits
  // 20161129  http://www.taxtips.ca/rrsp/rrspcontributionlimits.htm
  // 2017  http://www.taxtips.ca/rrsp/rrspcontributionlimits.htm //20160505 Igor
  Constant[0].MoneyPurchaseLimit := 33810.00; //2025 //jz//20260118 //32490; //2024 //prifi
  Constant[1].MoneyPurchaseLimit := 33810.00; //2025 //jz//20260118 //32490; //2024 //prifi

  //20250927
  // t1
  Constant[0].Rate1 := '14.5'; // 2025
  Constant[1].Rate1 := '14.5'; // 2025

  Constant[0].Rate2 :=  '20.5'; // 2025
  Constant[1].Rate2 := '20.5'; // 2025

  Constant[0].Rate3 := '26'; // 2025
  Constant[1].Rate3 := '26'; // 2025

  Constant[0].Rate4 :='29'; // 2025
  Constant[1].Rate4 := '29'; // 20245

  Constant[0].Rate5 := '33'; // 2025
  Constant[1].Rate5 := '33'; // 2025

  Constant[0].Bracket1 := 57375; // 2025
  Constant[1].Bracket1 := 57375; // 2025

  Constant[0].Bracket2 := 114750; // 2025
  Constant[1].Bracket2 := 114750; // 2026

  Constant[0].Bracket3 := 177882; // 2025
  Constant[1].Bracket3 := 177882; // 2025

  Constant[0].Bracket4 := 253414; // 2025
  Constant[1].Bracket4 := 253414; // 2025

  Constant[0].BracketTax1 := 0; // 2025
  Constant[1].BracketTax1 := 0; // 2025

  // 20201130 added penies
  Constant[0].BracketTax2 := 8319.38; // 2025
  Constant[1].BracketTax2 := 8319.38; // 2025

  Constant[0].BracketTax3 := 20081.25; // 2025
  Constant[1].BracketTax3 := 20081.25; // 2025

  Constant[0].BracketTax4 := 36495.57; // 2025
  Constant[1].BracketTax4 := 36495.57; // 2025

  Constant[0].BracketTax5 := 58399.85; // 2025
  Constant[1].BracketTax5 := 58399.85; // 2025

  Constant[0].BasicPersonalAmount := 16129; // 2025
  Constant[1].BasicPersonalAmount := 16129; // 2025

  Constant[0].FullYear := 365; // 2025
  Constant[1].FullYear := 365; // 2025

  // from 5000g guide line 301
  Constant[0].MaxAgeAmount := 9028; // 2025
  Constant[1].MaxAgeAmount := 9028; // 2025

  // from 5000g guide line 30100, reduced when income exceeds
  Constant[0].AgeBaseAmount := 45522; // 2025
  Constant[1].AgeBaseAmount := 45522; // 2025

  // from 5000g guide line 301, eliminated when income exceeds
  Constant[0].AgeNIThreshHold := 105709; // 2025
  Constant[1].AgeNIThreshHold := 105709; // 2025

  // 5000g line 367
  Constant[0].KidClaim := 0; // 2025
  Constant[1].KidClaim := 0; // 2025

  // 5000d line 306, eliminated when dependant income exceeds
  Constant[0].InfirmDependBase := 20197; //2025  ???  Is it used?
  Constant[1].InfirmDependBase := 20197; //2025

  // Infirm dependant amount (18+ years of age), including Family Caregiver Amount (Federal & YT)
  Constant[0].MaxInfirmAmount := 8601; //2025
  Constant[1].MaxInfirmAmount := 8601; //2025

  // 5000d line 315, eliminated when relative's income exceeds
  Constant[0].CareGvrBase := 28798; // //2025 s5
  Constant[1].CareGvrBase := 28798; // 2025

  // 5000d line 315, for in-home care of parent or grandparent 65+ years of age, or of infirm adult relative(3)
  Constant[0].MaxCareGvr := 4732; // 2023 ???  //goes to line 31500 but where is it? See Caregvt form
  Constant[1].MaxCareGvr := 4732; // 2023

  // 5000g Line 316
  Constant[0].MaxDisability := 10138; // 2025
  Constant[1].MaxDisability := 10138; // 2025

  // 5000g Line 316, Disability amount supplement for taxpayers under 18 years of age
  Constant[0].MaxDisabSupl18 := 5914; // 2025
  Constant[1].MaxDisabSupl18 := 5914; // 2025

  // 5000d Line 316, reduced when total child care and attendant care expenses claimed for this taxpayer by anyone exceed
  Constant[0].DisabSuplBase := 3464; // 2025
  Constant[1].DisabSuplBase := 3464; // 2025

  // s1, Spouse or common-law partner / equivalent-to-spouse / eligible dependant amount (3) except PE(1)
  Constant[0].MaxSpousalAmount := 14928; // 2023  //???
  Constant[1].MaxSpousalAmount := 14928; // 2023

  // s1, Medical expense tax credit is for expenses in excess of the lesser of 3% of net income or
  Constant[0].MedicalLimit := 2834; // 2025
  Constant[1].MedicalLimit := 2834; // 2025

  // 5000g ln 331 The maximum $10,000 limit per eligible dependant has been removed. For more information, see page 46
  Constant[0].MaxMedicalExpense := 200000; // 2024 ???
  Constant[1].MaxMedicalExpense := 200000; // 2024

  //see odf 5000.d1
  // 5000d Line 452 base amount, see 5000.d worksheet line 452 Family net income threshold http://www.cra-arc.gc.ca/nwsrm/fctshts/2014/m11/fs141125-eng.html
  Constant[0].MedicalRefundBase := 33294; // 2025 //jz//20251215
  Constant[1].MedicalRefundBase := 33294;// 2025


  // 5000g line 452,  // 2017 Maximum supplement http://www.cra-arc.gc.ca/nwsrm/fctshts/2014/m11/fs141125-eng.html
  Constant[0].MedicalRefundSupplement := 1504; // 2025
  Constant[1].MedicalRefundSupplement := 1504; //1464; // 2025

  // 5000g line 452   // 2017 Minimum earnings threshold http://www.cra-arc.gc.ca/nwsrm/fctshts/2014/m11/fs141125-eng.html
  Constant[0].MedicalRefundMinThreshHold := 4390; //4083;  //2025
  Constant[1].MedicalRefundMinThreshHold := 4390; // 2026

  //Chpter 4
  // 5000g Line 308
  Constant[0].MaxCpp := 4430.10;  //20260109 added .10 //2025 //3867.50;  chpter 4
  Constant[1].MaxCpp := 4430.10;  //2025 //3867.50;

  // s8 line 6   // 2017 same  http://www.cra-arc.gc.ca/tx/bsnss/tpcs/pyrll/clcltng/cpp-rpc/cnt-chrt-pf-eng.html
  Constant[0].BasicCppExemption:= 3500;  //2025
  Constant[1].BasicCppExemption:= 3500;  //2025
  // 2017 same as  http://www.cra-arc.gc.ca/tx/bsnss/tpcs/pyrll/clcltng/cpp-rpc/cnt-chrt-pf-eng.html
  Constant[0].CPPRate := 0.0595; // 2025  with additional
  Constant[1].CPPRate := 0.0595; // 2025  with additional

  // 5000g Line 308   // 2018 http://www.cra-arc.gc.ca/tx/bsnss/tpcs/pyrll/clcltng/cpp-rpc/cnt-chrt-pf-eng.html
  Constant[0].MaxCppPensionableEarnings:= 71300; // 2025   //20241210
  Constant[1].MaxCppPensionableEarnings:= 71300; //2025

  // s8 line 7 maximum
  Constant[0].MaxCppEarnings := Constant[0].MaxCppPensionableEarnings - Constant[0].BasicCppExemption; // maxpensiinable less exemption 3,500
  Constant[1].MaxCppEarnings := Constant[1].MaxCppPensionableEarnings - Constant[0].BasicCppExemption;

  Constant[0].MaxAdditionalCppPensionableEarnings:= 81200; // 2025
  Constant[1].MaxAdditionalCppPensionableEarnings:= 81200; // 2025

    //20250131 CZ
  Constant[0].MaxAdditionalQPPPensionableEarnings:= 81200; // 2025
  Constant[1].MaxAdditionalQPPPensionableEarnings:= 81200; // 2025

  Constant[0].MaxAdditionalCppContributions:= 9900; // 2025
  Constant[1].MaxAdditionalCppContributions:= 9900; // 2025

  //20250131 cz
  Constant[0].MaxAdditionalQPPContributions:= 9900; // 2025
  Constant[1].MaxAdditionalQPPContributions:= 9900; // 2025

  // 20161119
  Constant[0].QPPRate := 0.0640; // 2025    //chapter 4
  Constant[1].QPPRate := 0.0640; // 2025

  Constant[0].MaxQpp := 4735.20; //4038.40; //2025  //hapter 4
  Constant[1].MaxQpp := 4735.20; //4038.40; // 2024

  // http://www.taxtips.ca/cppandei/eirates.htm  see QC section
  // BETTER http://www.revenuquebec.ca/en/entreprises/ras/calculer-ras/rqap/maxrevenusassurables.aspx

  Constant[0].UIRate:= 0.0164; // 2025           //chapter 4
  Constant[1].UIRate:= 0.0164; // 2025

  // http://www.taxtips.ca/cppandei/eirates.htm
  Constant[0].QCUIRate:= 0.0131; // 2025
  Constant[1].QCUIRate:= 0.0131; // 2025

  // http://www.taxtips.ca/cppandei/eirates.htm
  Constant[0].MaxUI52:= 1077.48; // 2025
  Constant[1].MaxUI52:= 1077.48; // 2025

  Constant[0].QCMaxUI52:= 860.67; // 2025
  Constant[1].QCMaxUI52:= 860.67; // 2025

  // same including qc //http://www.taxtips.ca/cppandei/eirates.htm
  Constant[0].MaxUIEarn52:= 65700; // 2025
  Constant[1].MaxUIEarn52:= 65700; // 2025

  //PPIP se S10 form
  // https://www.google.ca/search?sourceid=navclient&aq=&oq=ppip+rate&ie=UTF-8&rlz=1T4WZPC_enCA452CA452&q=ppip+rate&gs_l=hp..2.0i22i30l3.0.0.2.137361...........0.judAT9JptL0
  Constant[0].MaxPPIPEarnings :=98000; // 94000; // 2025
  Constant[1].MaxPPIPEarnings :=98000; // 2025
    // self empl
  Constant[0].SEPPIPRate := 0.878; // 2025
  Constant[1].SEPPIPRate := 0.878; // 2025
  // s10
  Constant[0].PPIPDeductionRate := 43.736; // 2025
  Constant[1].PPIPDeductionRate := 43.736; // 2025

  Constant[0].MaxPPIP := 484.12; //464.36; // 2025
  Constant[1].MaxPPIP := 484.12; // 2025

  // s10
  Constant[0].MaxSEPPIP := 860.44; //825.32;//798.98; // 2025
  Constant[1].MaxSEPPIP := 860.44; // 2025
  //----------------------------------
  Constant[0].PPIPRate := 0.494; // 2025
  Constant[1].PPIPRate := 0.494; // 2025



  // --------------------------------------------------------------

  // s11, 5000g line 323
  Constant[0].EducPerMonth := 0; // 2024  //???
  Constant[1].EducPerMonth := 0; // 2024  // 400; // 20180408

  Constant[0].PartEducPerMonth := 0; // 2024 // 120; // // 20180408
  Constant[1].PartEducPerMonth := 0; // 2024 // 120; // // 20180408

  // s11, 5000g line 326
  Constant[0].EducLimit := 5000; // 2024  ???
  Constant[1].EducLimit := 5000; // 2024

  // s9, 5000g line 349                                                    taxtips

  Constant[0].DonPercent := 75; // 2024 ???
  Constant[1].DonPercent := 75; // 2024

  // http://www.cra-arc.gc.ca/limits/
  // https://www.canada.ca/en/revenue-agency/services/tax/registered-plans-administrators/pspa/mp-rrsp-dpsp-tfsa-limits-ympe.html
  Constant[0].RSPLimit := 32490;//2025
  Constant[1].RSPLimit := 32490;//2025   //20250308

  // 5000g ln 235 //http://www.taxtips.ca/cppandei/eiclawback.htm
  Constant[0].UIBaseRep := 82125; //79000; // 2025
  Constant[1].UIBaseRep := 82125; //79000; // 2025

  // 5000g line 235 //Old age security repayment threshold http://www.cra-arc.gc.ca/nwsrm/fctshts/2014/m11/fs141125-eng.html
  Constant[0].OASBaseRep := 93454; //90997; // 2025
  Constant[1].OASBaseRep := 93454; //90997; // 2025

  // 5000g line 313
  Constant[0].MaxAdoption := 19580; // 2025
  Constant[1].MaxAdoption := 19580; // 2025

  // s1 ln363
  Constant[0].CanEmplAmount := 1471; // 2025   //20251109
  Constant[1].CanEmplAmount := 1471; // 2025    //20251109

  // s9 line 346
  Constant[0].DonRate1 := 15.00; // 2024  ???
  Constant[1].DonRate1 := 15.00; // 2024
  // s9 line 348
  Constant[0].DonRate2 := 29; // 2024    ???
  Constant[1].DonRate2 := 29; // 2024
end;

//20250918 Igor >>>
procedure InitPRVConstants(Prv: string);
var
  Cpi: Real;
begin
  // ALSO:  https://www.ontario.ca/data/personal-income-tax-rates-and-credits  //GOOD for Ontrio OTB MCredits
  // revised all on //20170922 as it was in the planning version of August. Not checked against CRA forms yet
  // 20160730  various changes in items [2] below for various provinces between July 22 to July 30
  { 0:current year, 1:=next year(planner) }
  // SEE ALSO GetMjPrvDisability
  /// www.taxtips.ca
  // http://www.ey.com/CA/en/Services/Tax/Tax-Calculators

  //HOW:  BRACKETS and PERSONAL AMOUNT from CRA 50xx.c PDF documents
  // i.e for ON from 5006-c-22e.pdf

  if (Prv = 'ON') then // See 5006.c
  begin
    Cpi := 1.065;    //2013

    {$region ' 5006-c '}
    PrvConstant[0].PrvBracket1:= 52886; // 2025
    PrvConstant[1].PrvBracket1:= 52886; // 2025
    PrvConstant[0].PrvBracket2:= 105775;// 2025
    PrvConstant[1].PrvBracket2:= 105775;// 2025
    PrvConstant[0].PrvBracket3:= 150000; // 2025
    PrvConstant[1].PrvBracket3:= 150000; // 2025
    PrvConstant[0].PrvBracket4:= 220000; // 2025
    PrvConstant[1].PrvBracket4:= 220000; // 2025

    PrvConstant[0].PrvRate1:= '5.05'; // 2025
    PrvConstant[1].PrvRate1:= '5.05'; // 2025
    PrvConstant[0].PrvRate2:= '9.15'; // 2025
    PrvConstant[1].PrvRate2:= '9.15'; // 2025
    PrvConstant[0].PrvRate3:= '11.16'; // 2025
    PrvConstant[1].PrvRate3:= '11.16'; // 2025
    PrvConstant[0].PrvRate4:= '12.16'; // 2025
    PrvConstant[1].PrvRate4:= '12.16'; // 2025
    PrvConstant[0].PrvRate5:= '13.16'; // 2025
    PrvConstant[1].PrvRate5:= '13.16'; // 2025

    PrvConstant[0].PrvBracketTax1:= 0;
    PrvConstant[1].PrvBracketTax1:= 0;
    PrvConstant[0].PrvBracketTax2:= 2670.74; // 2025
    PrvConstant[1].PrvBracketTax2:= 2670.74; // 2025
    PrvConstant[0].PrvBracketTax3:= 7510.09; // 2025
    PrvConstant[1].PrvBracketTax3:= 7510.09; // 2025
    PrvConstant[0].PrvBracketTax4:= 12445.60; //2025
    PrvConstant[1].PrvBracketTax4:= 12445.60; //2025
    PrvConstant[0].PrvBracketTax5:= 20957.60; // 2025
    PrvConstant[1].PrvBracketTax5:= 20957.60; // 2025

    PrvConstant[0].PrvPersAmount:= 12747; // 2025  // guide 5006-n line  5006-pc Line 5808   TaxTips
    PrvConstant[1].PrvPersAmount:= 12747; // 2025  // guide 5006-n line  5006-pc Line 5808   TaxTips

    PrvConstant[0].PrvAgeNIThreshHold:= 87817; //85428; // 2025
    PrvConstant[1].PrvAgeNIThreshHold:= 87817; // 2025

    // 5006c Spouse or common-law partner amount     // eliminated when spousal/dependant income exceeds
    PrvConstant[0].PrvSpouseBasicAmount:= 11905; // 2025
    PrvConstant[1].PrvSpouseBasicAmount:= 11905; // 2025

    // 5006c ln 5816     // 2017 Spouse or common-law partner / equivalent-to-spouse / eligible dependant
    PrvConstant[0].PrvMaxSpousalAmount:= 10823; // 2025
    PrvConstant[1].PrvMaxSpousalAmount:= 10823; // 2025

    // 5006c Line 5836
    PrvConstant[0].PrvMaxPensionAmount:= 1762; // 2025
    PrvConstant[1].PrvMaxPensionAmount:= 1762; // 2025

    // 5006c Donations and gifts
    PrvConstant[0].PrvDonRate1:= vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1:= vl(PrvConstant[1].PrvRate1);

    PrvConstant[0].PrvNonRefundRate:= vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvNonRefundRate:= vl(PrvConstant[1].PrvRate1);

    // 5006c Donations and gifts
    PrvConstant[0].PrvDonRate2:= 11.16; // 2025
    PrvConstant[1].PrvDonRate2:= 11.16; // 2025

    PrvConstant[0].PrvDivRate:= '2.9863'; // 2025
    PrvConstant[1].PrvDivRate:= '2.9863'; // 2025

    PrvConstant[0].PrvDivRateBig:= '10'; // 2025
    PrvConstant[1].PrvDivRateBig:= '10'; // 2025
    // 5006c
    PrvConstant[0].PrvOverseasRate:= 38.5; // 2023
    PrvConstant[1].PrvOverseasRate:= 38.5; // 2023

    // 5006c
    PrvConstant[0].PrvAmtCarryOverRate:= 33.67; // 2023
    PrvConstant[1].PrvAmtCarryOverRate:= 33.67; // 2023

    // 5006c -d? Line 5872     // 2017 Medical expense tax credit is for expenses in excess of the lesser of 3% of net income or
    PrvConstant[0].PrvMedicalLimit:= 2885; // 2025
    PrvConstant[1].PrvMedicalLimit:= 2885; // 2025
    {$endregion ' 5006-c '}

    {$region ' 5006-d '}
    // 5006d Line 5808
    PrvConstant[0].PrvMaxAgeAmount:= 6223; //6054; // 2025
    PrvConstant[1].PrvMaxAgeAmount:= 6223; //6054; // 2025

    // 5006d Line 5808        //from on428
    PrvConstant[0].PrvAgeBaseAmount:= 46330; //45068; // 2025
    PrvConstant[1].PrvAgeBaseAmount:= 46330; //45068; // 2025
    // 2017 reduced when income exceeds

    // 5006d line 5820    // 2017  eliminated when dependant income exceeds
    PrvConstant[0].PrvInfirmDependBase:= 11257; // 2023
    PrvConstant[1].PrvInfirmDependBase:= 11257; // 2023
//
    // 5006d line 5820     // 2017 Infirm dependant amount (18+ years of age), including Family Caregiver Amount
    PrvConstant[0].PrvMaxInfirmDependAmount:= 5591; // 2023
    PrvConstant[1].PrvMaxInfirmDependAmount:= 5591; // 2023

    // 5006d Line 5840     // 20171128 20862; //2017 -eliminated when relative's income exceeds
    PrvConstant[0].PrvCareGvrBase:= 26562; //25838; // 2025  see 5006-pc-24e.pdf
    PrvConstant[1].PrvCareGvrBase:= 25562; //5838; // 2025  see 5006-pc-24e.pdf

    // 5006d line 5840     //2017 Caregiver amount for in-home care of parent or grandparent 65+ years of age, or of infirm adult relative
    PrvConstant[0].PrvMaxCareGvr:= 6008; //5844; // 2025 //prrofile planning
    PrvConstant[1].PrvMaxCareGvr:= 6008; //5844; // 2025 //prrofile planning

    // 5006-d Line 5872     // 2017 Maximum medical expenses for other eligible dependants (each)
    PrvConstant[0].PrvMaxMedicalExpense:= 15551; //17147; // 2025
    PrvConstant[1].PrvMaxMedicalExpense:= 15551; //17147; // 2025

    // 5006d Line 5844 Base amount     // 2017 -reduced when total child care and attendant care expenses claimed for this taxpayer by anyone exceed
    PrvConstant[0].PrvDisabSuplBase:= 3518; //3422; // 2025
    PrvConstant[1].PrvDisabSuplBase:= 3518; //3422; // 2025
    {$endregion ' 5006-d '}

    {$region ' 5006-pc '}
    // 5006 pc line Line 5844
    PrvConstant[0].PrvMaxDisability:= 10298; //10017;// 2025
    PrvConstant[1].PrvMaxDisability:= 10298; //10017;// 2025

    // 5006 pc line Line 58440
    PrvConstant[0].PrvMaxDisabSupl18:= 6007; //5843; // 2025
    PrvConstant[1].PrvMaxDisabSupl18:= 6007; //5843; // 2025

    // 5006 pc Line 5833     // 2017 Eligible adoption expenses - maximum per child
    PrvConstant[0].PrvMaxAdoption:= 15127; // 2024    //from 5006-pc
    PrvConstant[1].PrvMaxAdoption:= 15127; // 2024    //from 5006-pc
    {$endregion ' 5006-pc '}

    {$region ' 5006-s11 '}
    // 5006s11 line 5918
    PrvConstant[0].PrvEducPerMonth:= 547; // 2023 ???? most likely 0
    PrvConstant[1].PrvEducPerMonth:= 547; // 2023 ???? most likely 0

    // 5006s11 line 5916
    PrvConstant[0].PrvPartEducPerMonth:= 164; // 2023     most likely 0
    PrvConstant[1].PrvPartEducPerMonth:= 164; // 2023     most likely 0

    // 5006s11
    PrvConstant[0].PrvMaxEducXfer:= 7033; // 2023
    PrvConstant[1].PrvMaxEducXfer:= 7033; // 2023
    {$endregion ' 5006-s11 '}
  end;

  if (Prv = 'AB') then //in 2022 all look the same as 2021 ????
  begin
    Cpi:= 1.024;

    {$region ' 5009-c '}
    //20221214
    // 20150907  New tax brackets
    PrvConstant[0].PrvRate1:= '8.0'; // 2025
    PrvConstant[1].PrvRate1:= '8.0'; // 2025
    PrvConstant[0].PrvRate2:= '10.0'; // 2025
    PrvConstant[1].PrvRate2:= '10.0'; // 2025
    PrvConstant[0].PrvRate3:= '12.0'; // 2025
    PrvConstant[1].PrvRate3:= '12.0'; // 2025
    PrvConstant[0].PrvRate4:= '13.0'; // 2025
    PrvConstant[1].PrvRate4:= '13.0'; // 2025
    PrvConstant[0].PrvRate5:= '14.0'; // 2025
    PrvConstant[1].PrvRate5:= '14.0'; // 2025
    PrvConstant[0].PrvRate6:= '15.0'; // 2025
    PrvConstant[1].PrvRate6:= '15.0'; // 2025

    PrvConstant[0].PrvBracket1:= 60000; // 2025
    PrvConstant[1].PrvBracket1:= 60000; // 2025
    PrvConstant[0].PrvBracket2:= 151234; // 2025
    PrvConstant[1].PrvBracket2:= 151234; // 2025
    PrvConstant[0].PrvBracket3:= 181481; // 2025
    PrvConstant[1].PrvBracket3:= 181481; // 2025
    PrvConstant[0].PrvBracket4:= 241974; // 2025
    PrvConstant[1].PrvBracket4:= 241974; // 2025
    PrvConstant[0].PrvBracket5:= 362961; // 2025
    PrvConstant[1].PrvBracket5:= 362961; // 2025

    PrvConstant[0].PrvBracketTax1:= 0.00;
    PrvConstant[1].PrvBracketTax1:= 0.00;
    PrvConstant[0].PrvBracketTax2:= 4800.00; // 2025
    PrvConstant[1].PrvBracketTax2:= 4800.00; // 2025
    PrvConstant[0].PrvBracketTax3:= 13923.40; // 2025 // Round(PrvConstant[1].PrvBracketTax1+PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1)/100)+
    PrvConstant[1].PrvBracketTax3:= 13923.40; // 2025 // Round(PrvConstant[1].PrvBracketTax1+PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1)/100)+
    PrvConstant[0].PrvBracketTax4:= 17553.04; // 2025
    PrvConstant[1].PrvBracketTax4:= 17553.04; // 2025
    PrvConstant[0].PrvBracketTax5:= 25417.13; //2025
    PrvConstant[1].PrvBracketTax5:= 25417.13; //2025 // Round(PrvConstant[1].PrvBracketTax3+(PrvConstant[1].PrvBracket3 - PrvConstant[1].PrvBracket2) * vl(PrvConstant[1].PrvRate3)/100);
    PrvConstant[0].PrvBracketTax6:= 42355.31; // 2025
    PrvConstant[1].PrvBracketTax6:= 42355.31; // 2025

    PrvConstant[0].PrvPersAmount:= 22323; // 2025
    PrvConstant[1].PrvPersAmount:= 22323; // 2025

    PrvConstant[0].PrvAgeNIThreshHold:= 87782; //85428; // 2025
    PrvConstant[1].PrvAgeNIThreshHold:= 87782; // 2025

    // 5009c Spouse or common-law partner amount
    PrvConstant[0].PrvSpouseBasicAmount:= 22323; // 2025
    PrvConstant[1].PrvSpouseBasicAmount:= 22323; // 2025

    PrvConstant[0].PrvMaxSpousalAmount:= 22323; // 2025
    PrvConstant[1].PrvMaxSpousalAmount:= 22323; // 2025

    // 5009c line 5836
    PrvConstant[0].PrvMaxPensionAmount:= 1719; // 2025
    PrvConstant[1].PrvMaxPensionAmount:= 1719; // 2025

    // 5009c
    PrvConstant[0].PrvMedicalLimit:= 2884; // 2025
    PrvConstant[1].PrvMedicalLimit:= 2884; // 2025

    // 5009c bottom page 1
    PrvConstant[0].PrvNonRefundRate:= vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvNonRefundRate:= vl(PrvConstant[1].PrvRate1);

    // 5009c bottom page 1
    PrvConstant[0].PrvDonRate1:= 60; // 2025
    PrvConstant[1].PrvDonRate1:= 60; // 2025

    // 5009c top page 2
    PrvConstant[0].PrvOverseasRate:= 35; // 2023
    PrvConstant[1].PrvOverseasRate:= 35; // 2023

    // 5009c top page 2
    PrvConstant[0].PrvAmtCarryOverRate:= 35; // 2023
    PrvConstant[1].PrvAmtCarryOverRate:= 35; // 2023

    {$endregion ' 5009-c '}

    {$region ' 5009-d '}
    // 5009d line 5808
    PrvConstant[0].PrvMaxAgeAmount:= 6221; // 2025
    PrvConstant[1].PrvMaxAgeAmount:= 6221; //6099; // 2025

    // 5009d line 5808
    PrvConstant[0].PrvAgeBaseAmount:= 46308; //45400; //2025
    PrvConstant[1].PrvAgeBaseAmount:= 46308; //45400; //2025

    // 5009d line 5820
    PrvConstant[0].PrvInfirmDependBase:= 21458; //21038; // 2026
    PrvConstant[1].PrvInfirmDependBase:= 21458; //21038; // 2025

    // 5009d line 5820
    PrvConstant[0].PrvMaxInfirmDependAmount:= 12922; //12669; // 2025
    PrvConstant[1].PrvMaxInfirmDependAmount:= 12922; //12669; // 2025

    // 5009d line 5840
    PrvConstant[0].PrvCareGvrBase:= 33467; //32811;  // 2025
    PrvConstant[1].PrvCareGvrBase:= 33467; //32811;  // 2025

    // 5009d line 5840
    PrvConstant[0].PrvMaxCareGvr:= 12922; //12669; // 2025
    PrvConstant[1].PrvMaxCareGvr:= 12922; //12669; // 2025

    // 5009d line 5872
    PrvConstant[0].PrvMaxMedicalExpense:= 13571; // 2023 ??
    PrvConstant[1].PrvMaxMedicalExpense:= 13571; // 2023

    // 5009d Line 5896
    PrvConstant[0].PrvDonRate2:= 21.00; // 2025
    PrvConstant[1].PrvDonRate2:= 21.00; // 2025

    // 5009d Line 6152
    PrvConstant[0].PrvDivRate:= '2.18'; // 2023
    PrvConstant[1].PrvDivRate:= '2.18'; // 2025

    // 5009d Line 6152
    PrvConstant[0].PrvDivRateBig:= '8.12'; // 2025
    PrvConstant[1].PrvDivRateBig:= '8.12'; // 2025

    // 5009d line 5844
    PrvConstant[0].PrvMaxDisability:= 17219; // 2025
    PrvConstant[1].PrvMaxDisability:= 17219; // 2025
    // 5009d line 5844
    PrvConstant[0].PrvMaxDisabSupl18:= 12922; //12669; // 2025
    PrvConstant[1].PrvMaxDisabSupl18:= 12922; //12669; // 2025

    // 5009d line 5844
    PrvConstant[0].PrvDisabSuplBase:= 3524; //3455; // 2025
    PrvConstant[1].PrvDisabSuplBase:= 3424; //3455; // 20254
    {$endregion ' 5009-d '}

    {$region ' 5009-pc '}
    // 5009pc line 5808                 //on428
    PrvConstant[0].PrvAgeNIThreshHold:= 87782; //86060; //2025
    PrvConstant[1].PrvAgeNIThreshHold:= 87782; //86060; //2025

    // 5009pc line 5833
    PrvConstant[0].PrvMaxAdoption:= 19354; //2025 //jz//20260112
    PrvConstant[1].PrvMaxAdoption:= 19354; //2025

    {$endregion ' 5009-pc '}

    {$region ' 5009-s11 '}
    // 5009s11
    PrvConstant[0].PrvPartEducPerMonth:= 226; // 2023
    PrvConstant[1].PrvPartEducPerMonth:= 226; // 2023

    // 5009s11
    PrvConstant[0].PrvEducPerMonth:= 753; // 2023
    PrvConstant[1].PrvEducPerMonth:= 753; // 2023

    // 5009s11
    PrvConstant[0].PrvMaxEducXfer:= 5000; // 2023
    PrvConstant[1].PrvMaxEducXfer:= 5000; // 2023
    {$endregion ' 5009-s11 '}
  end;

  if (Prv = 'MB') then
  begin
    Cpi:= 1.000;

    {$region ' 5007-c '}
    // 5007-c
    PrvConstant[0].PrvBracket1:= 47000; // 2025
    PrvConstant[1].PrvBracket1:= 47000; // 2025
    PrvConstant[0].PrvBracket2:= 100000; // 2025
    PrvConstant[1].PrvBracket2:= 100000; // 2025
    // 5007-c
    PrvConstant[0].PrvRate1:= '10.8'; // 2025
    PrvConstant[1].PrvRate1:= '10.8'; // 2025
    PrvConstant[0].PrvRate2:= '12.75'; // 2025
    PrvConstant[1].PrvRate2:= '12.75'; // 2025
    PrvConstant[0].PrvRate3:= '17.4'; // 2025
    PrvConstant[1].PrvRate3:= '17.4'; // 2025

    // 5007-c
    PrvConstant[0].PrvBracketTax1:= 0;
    PrvConstant[1].PrvBracketTax1:= 0;
    PrvConstant[0].PrvBracketTax2:= 5076.00; // 2025
    PrvConstant[1].PrvBracketTax2:= 5076.00; // 2025   // Round(PrvConstant[1].PrvBracketTax1+PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1)/100);
    PrvConstant[0].PrvBracketTax3:= 11833.50;// 2025
    PrvConstant[1].PrvBracketTax3:= 11833.50;// 2025  Round(PrvConstant[1].PrvBracketTax2+(PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2)/100);
    // 5007-c line 5804
    PrvConstant[0].PrvPersAmount:= 15780; // 2025
    PrvConstant[1].PrvPersAmount:= 15780; // 2025

    PrvConstant[0].PrvAgeNIThreshHold:= 52602; //85428; // 20251118
    PrvConstant[1].PrvAgeNIThreshHold:= 52602; // 2025


    // 5007-c Spouse or common-law partner amount
    PrvConstant[0].PrvSpouseBasicAmount:= 9134; // 2025
    PrvConstant[1].PrvSpouseBasicAmount:= 9134; // 2025

    // 5007-c line 5812
    PrvConstant[0].PrvMaxSpousalAmount:= 9134; // 2025
    PrvConstant[1].PrvMaxSpousalAmount:= 9134; // 2025

    // 5007-c line 5836, fed s1 line 314
    PrvConstant[0].PrvMaxPensionAmount:= 1000; // 2025
    PrvConstant[1].PrvMaxPensionAmount:= 1000; // 2025

    // 5007-c -d line 5872
    PrvConstant[0].PrvMedicalLimit:= 1728; // 2025
    PrvConstant[1].PrvMedicalLimit:= 1728; // 2025

    // 5007-c bottom page 1
    PrvConstant[0].PrvNonRefundRate:= vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvNonRefundRate:= vl(PrvConstant[1].PrvRate1);

    // 5007-c bottom page 1
    PrvConstant[0].PrvDonRate1:= vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1:= vl(PrvConstant[1].PrvRate1);

    // 5007-c bottom page 1
    PrvConstant[0].PrvDonRate2:= 17.4; // 2025
    PrvConstant[1].PrvDonRate2:= 17.4; // 2025

    // 5007-c line 6153
    PrvConstant[0].PrvOverseasRate:= 50; // 2023
    PrvConstant[1].PrvOverseasRate:= 50; // 2023

    // 5007-c line 6154
    PrvConstant[0].PrvAmtCarryOverRate:= 50; // 2023
    PrvConstant[1].PrvAmtCarryOverRate:= 50; // 2023
    {$endregion ' 5007-c '}

    {$region ' 5007-d '}
    // 5007-d line 5808
    PrvConstant[0].PrvMaxAgeAmount:= 3728; // 2025
    PrvConstant[1].PrvMaxAgeAmount:= 3728; // 2025

    // 5007-d line 5808
    PrvConstant[0].PrvAgeBaseAmount:= 27749; // 2025
    PrvConstant[1].PrvAgeBaseAmount:= 27749; // 2025

    // 5007-d line 5820
    PrvConstant[0].PrvInfirmDependBase:= 8720; // 2025
    PrvConstant[1].PrvInfirmDependBase:= 8720; // 2025

    // 5007-d line 5820
    PrvConstant[0].PrvMaxInfirmDependAmount:= 3605; // 2025
    PrvConstant[1].PrvMaxInfirmDependAmount:= 3605; // 2025

    // 5007-d line 5840
    PrvConstant[0].PrvCareGvrBase:= 15917; // 2025
    PrvConstant[1].PrvCareGvrBase:= 15917; // 2025

    // 5007-d line 5840
    PrvConstant[0].PrvMaxCareGvr:= 3605; // 2025
    PrvConstant[1].PrvMaxCareGvr:= 3605; // 2025

    // 5007-d  line 5872
    PrvConstant[0].PrvMaxMedicalExpense:= 10000; // 2023
    PrvConstant[1].PrvMaxMedicalExpense:= 10000; // 2023

    // 5007-d line 6152
    PrvConstant[0].PrvDivRate:= '0.7835'; // 2025
    PrvConstant[1].PrvDivRate:= '0.7835'; // 2025

    // 5007-d line 6152
    PrvConstant[0].PrvDivRateBig:= '8'; // 2025
    PrvConstant[1].PrvDivRateBig:= '8'; // 2025

    // 5007-d line 5848
    PrvConstant[0].PrvMaxDisability:= 6180; // 2025
    PrvConstant[1].PrvMaxDisability:= 6180; // 2025

    // 5007-d line 5844
    PrvConstant[0].PrvMaxDisabSupl18:= 3605; // 2025
    PrvConstant[1].PrvMaxDisabSupl18:= 3605; // 20254

    // 5007-d line 5844
    PrvConstant[0].PrvDisabSuplBase:= 2112; // 2025
    PrvConstant[1].PrvDisabSuplBase:= 2112; // 2025
    {$endregion ' 5007-d '}

    {$region ' 5007-pc '}
    // 5007-pc line 5808
    PrvConstant[0].PrvAgeNIThreshHold:= 52602; // 2025
    PrvConstant[1].PrvAgeNIThreshHold:= 52602; // 2025

    // 5007-pc line 5833
    PrvConstant[0].PrvMaxAdoption:= 10000; // 2023
    PrvConstant[1].PrvMaxAdoption:= 10000; // 2023
    {$endregion ' 5007-pc '}

    {$region ' 5007-s11 '}
    // 5007-s11
    PrvConstant[0].PrvPartEducPerMonth:= 120; // 2023
    PrvConstant[1].PrvPartEducPerMonth:= 120; // 2023

    // 5007-s11
    PrvConstant[0].PrvEducPerMonth:= 400; // 2023
    PrvConstant[1].PrvEducPerMonth:= 400; // 2023

    // 5007-s11
    PrvConstant[0].PrvMaxEducXfer:= 5000; // 2023
    PrvConstant[1].PrvMaxEducXfer:= 5000; // 2023
    {$endregion ' 5007-s11 '}
  end;

  if (Prv = 'BC') then
  begin
    Cpi := 1.007;

    {$region ' 5010-c '}
    // from 5010-c
    PrvConstant[0].PrvBracket1:= 49279; // 2025
    PrvConstant[1].PrvBracket1:= 49279; // 2025
    PrvConstant[0].PrvBracket2:= 98560; // 2025
    PrvConstant[1].PrvBracket2:= 98560; // 2025
    PrvConstant[0].PrvBracket3:= 113158; // 2025
    PrvConstant[1].PrvBracket3:= 113158; // 2025
    PrvConstant[0].PrvBracket4:= 137407; // 2025
    PrvConstant[1].PrvBracket4:= 137407; // 2025
    PrvConstant[0].PrvBracket5:= 186306; // 2025
    PrvConstant[1].PrvBracket5:= 186306; // 2025
    PrvConstant[0].PrvBracket6:= 259829; // 2025
    PrvConstant[1].PrvBracket6:= 259829; // 2025

    // from 5010-c
    PrvConstant[0].PrvRate1:= '5.06'; // 2025
    PrvConstant[1].PrvRate1:= '5.06'; // 2025
    PrvConstant[0].PrvRate2:= '7.7'; // 2025
    PrvConstant[1].PrvRate2:= '7.7'; // 2025
    PrvConstant[0].PrvRate3:=  '10.5'; // 2025
    PrvConstant[1].PrvRate3:= '10.5'; // 2025
    PrvConstant[0].PrvRate4:= '12.29'; // 2025
    PrvConstant[1].PrvRate4:= '12.29'; // 2025
    PrvConstant[0].PrvRate5:= '14.70'; // 2025
    PrvConstant[1].PrvRate5:= '14.70'; // 2025
    PrvConstant[0].PrvRate6:= '16.8'; // 2025
    PrvConstant[1].PrvRate6:= '16.8'; // 2025
    PrvConstant[0].PrvRate7:= '20.5'; // 2025
    PrvConstant[1].PrvRate7:= '20.5'; // 2025

    // from 5010-c
    PrvConstant[0].PrvBracketTax1:= 0;
    PrvConstant[1].PrvBracketTax1:= 0;
    PrvConstant[0].PrvBracketTax2:=2493.52;// 2025
    PrvConstant[1].PrvBracketTax2:= 2493.52;// 2025 // Round(PrvConstant[1].PrvBracketTax1+PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1)/100);
    PrvConstant[0].PrvBracketTax3:= 6288.15; // 2025  Round(PrvConstant[0].PrvBracketTax2+(PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2)/100);
    PrvConstant[1].PrvBracketTax3:= 6288.15; // 2025  Round(PrvConstant[1].PrvBracketTax2+(PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2)/100);
    PrvConstant[0].PrvBracketTax4:= 7820.94; // 2025 7245.73; // 2022  Round(PrvConstant[0].PrvBracketTax3+(PrvConstant[0].PrvBracket3 - PrvConstant[0].PrvBracket2) * vl(PrvConstant[0].PrvRate3)/100);
    PrvConstant[1].PrvBracketTax4:= 7820.94; // 2025  Round(PrvConstant[1].PrvBracketTax3+(PrvConstant[1].PrvBracket3 - PrvConstant[1].PrvBracket2) * vl(PrvConstant[1].PrvRate3)/100);
    PrvConstant[0].PrvBracketTax5:= 10801.15;  // 2025 Round(GetTaxOnBase(PrvConstant[0].PrvBracket4,PrvConstant[0].PrvBracket3,Vl(PrvConstant[0].PrvRate4),PrvConstant[0].PrvBracketTax4));
    PrvConstant[1].PrvBracketTax5:= 10801.15; // 2025  Round(GetTaxOnBase(PrvConstant[1].PrvBracket4,PrvConstant[1].PrvBracket3,Vl(PrvConstant[1].PrvRate4),PrvConstant[1].PrvBracketTax4));
    PrvConstant[0].PrvBracketTax6:= 17989.30; // 2025
    PrvConstant[1].PrvBracketTax6:= 17989.30; // 2025  Round(GetTaxOnBase(PrvConstant[1].PrvBracket5,PrvConstant[1].PrvBracket4,Vl(PrvConstant[1].PrvRate5),PrvConstant[1].PrvBracketTax5));
    PrvConstant[0].PrvBracketTax7:= 30341.16; // 2025
    PrvConstant[1].PrvBracketTax7:= 30341.16; // 2025

    // from 5010-c line 5804
    PrvConstant[0].PrvPersAmount:= 12932; // 2025
    PrvConstant[1].PrvPersAmount:= 12932; // 2025

    PrvConstant[0].PrvAgeNIThreshHold:= 81829; //85428; // 2025
    PrvConstant[1].PrvAgeNIThreshHold:= 81829; // 2025

    // from 5010-c
    PrvConstant[0].PrvSpouseBasicAmount:= 12181; // 2025
    PrvConstant[1].PrvSpouseBasicAmount:= 12181; // 2025

    // from 5010-c line 5812
    PrvConstant[0].PrvMaxSpousalAmount:= 11073; // 2025
    PrvConstant[1].PrvMaxSpousalAmount:= 11073; // 2025

    // from 5010-c line 5836
    PrvConstant[0].PrvMaxPensionAmount:= 1000; // 2025
    PrvConstant[1].PrvMaxPensionAmount:= 1000; // 2025

    // from 5010-c bottom of page 1
    PrvConstant[0].PrvNonRefundRate:= vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvNonRefundRate:= vl(PrvConstant[1].PrvRate1);

    // from 5010-c bottom of page 1
    PrvConstant[0].PrvDonRate1:= vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1:= vl(PrvConstant[1].PrvRate1);

    // from 5010-c bottom of page 1
    PrvConstant[0].PrvDonRate2:= 16.8; // 2023
    PrvConstant[1].PrvDonRate2:= 16.8; // 2023

    // from 5010-c -d line 6152
    PrvConstant[0].PrvDivRate:= '1.96'; // 2025
    PrvConstant[1].PrvDivRate:= '1.96'; // 2025
   // from 5010-d line 6152
    PrvConstant[0].PrvDivRateBig:= '12'; // 2024
    PrvConstant[1].PrvDivRateBig:= '12'; // 2024

    // from 5010-c -d line 6153 line 44
    PrvConstant[0].PrvOverseasRate:= 49.5; // 2023
    PrvConstant[1].PrvOverseasRate:= 49.5; // 2023

    // from 5010-c top of page 2
    PrvConstant[0].PrvAmtCarryOverRate:= 34.9; // 2025
    PrvConstant[1].PrvAmtCarryOverRate:= 34.9; // 2025
    {$endregion ' 5010-c '}

    {$region ' 5010-d '}
    // from 5010-d line 5808
    PrvConstant[0].PrvMaxAgeAmount:= 5799; // 2025
    PrvConstant[1].PrvMaxAgeAmount:= 5799; // 2025

    // from 5010-d Line 5808
    PrvConstant[0].PrvAgeBaseAmount:= 43169; //1993; // 2025
    PrvConstant[1].PrvAgeBaseAmount:= 43169; //41993; // 2025

    // from 5010-d Line 5820
    PrvConstant[0].PrvInfirmDependBase:= 11582; // 2023? nothing on .d
    PrvConstant[1].PrvInfirmDependBase:= 11582; // 2023

    // from 5010-d Line 5820
    PrvConstant[0].PrvMaxInfirmDependAmount:= 4946; // 2023?
    PrvConstant[1].PrvMaxInfirmDependAmount:= 4946; // 2023

    // from 5010-d Line 5840
    PrvConstant[0].PrvCareGvrBase:= 24810; // 24134; // 2025
    PrvConstant[1].PrvCareGvrBase:= 24810; //24134; // 2025

    // from 5010-d Line 5840
    PrvConstant[0].PrvMaxCareGvr:= 5659; //5505; // 2025
    PrvConstant[1].PrvMaxCareGvr:= 5659; //5505; // 2025

    // from 5010d or 5010c Line 5872
    PrvConstant[0].PrvMedicalLimit:= 2689; // 2025
    PrvConstant[1].PrvMedicalLimit:= 2689; // 2025

    // from 5010-d Line 5872
    PrvConstant[0].PrvMaxMedicalExpense:= 10000; // 2023
    PrvConstant[1].PrvMaxMedicalExpense:= 10000; // 2023


    // from 5010-d line 5844
    PrvConstant[0].PrvMaxDisability:= 9699; // 2025
    PrvConstant[1].PrvMaxDisability:= 9699; // 2025

    // from 5010-d line 5844
    PrvConstant[0].PrvMaxDisabSupl18:= 5659; //5505; // 2025
    PrvConstant[1].PrvMaxDisabSupl18:= 5659; //5505; // 2025

    // from 5010-d line 5844
    PrvConstant[0].PrvDisabSuplBase:= 3285; //3196; // 2024
    PrvConstant[1].PrvDisabSuplBase:= 3285; //3196; // 2024

    PrvConstant[0].PrvMaxAdoption:= 19580; //2025 //jz//20260111  //19066; // 2024
    PrvConstant[1].PrvMaxAdoption:= 19580; //2025 //jz//20260111  //19066; // 2024
    {$endregion ' 5010-d '}

    {$region ' 5010-pc '}
    // from 5010-pc Line 5808   Age amount
    PrvConstant[0].PrvAgeNIThreshHold:= 81829; //79600; // 2025
    PrvConstant[1].PrvAgeNIThreshHold:= 81829; //79600; // 2025
    {$endregion ' 5010-pc '}

    {$region ' 5010-s11 '}
    // from 5010-s11
    PrvConstant[0].PrvPartEducPerMonth:= 60; // 2023
    PrvConstant[1].PrvPartEducPerMonth:= 60; // 2023

    // from 5010-s11
    PrvConstant[0].PrvEducPerMonth:= 200; // 2023
    PrvConstant[1].PrvEducPerMonth:= 200; // 2023

    // from 5010-s11
    PrvConstant[0].PrvMaxEducXfer:= 5000; // 2023
    PrvConstant[1].PrvMaxEducXfer:= 5000; // 2023
    {$endregion ' 5010-s11 '}
  end;

  if (Prv = 'NL') then
  begin
    Cpi:= 1.009; // 2020

    {$region ' from 5001-c '}
    // Page 1
    PrvConstant[0].PrvBracket1:= 44192; //43108; // 2024  //20250219
    PrvConstant[1].PrvBracket1:= 44192; //43108; // 2024
    PrvConstant[0].PrvBracket2:= 88382; // 2025
    PrvConstant[1].PrvBracket2:= 88382; // 2025
    PrvConstant[0].PrvBracket3:= 157792;// 2025
    PrvConstant[1].PrvBracket3:= 157792;// 2025
    PrvConstant[0].PrvBracket4:= 220910; // 2025
    PrvConstant[1].PrvBracket4:= 220910; // 2025
    PrvConstant[0].PrvBracket5:= 282214; // 2025
    PrvConstant[1].PrvBracket5:= 282214; // 2025
    PrvConstant[0].PrvBracket6:= 564429; // 2025
    PrvConstant[1].PrvBracket6:= 564429; // 2025
    PrvConstant[0].PrvBracket7:= 1128858; // 2025
    PrvConstant[1].PrvBracket7:= 1128858; // 2025

    PrvConstant[0].PrvRate1:= '8.7'; // 2025
    PrvConstant[1].PrvRate1:= '8.7'; // 2025
    PrvConstant[0].PrvRate2:= '14.5'; // 2025
    PrvConstant[1].PrvRate2:= '14.5'; // 2025
    PrvConstant[0].PrvRate3:= '15.80'; // 2025
    PrvConstant[1].PrvRate3:= '15.80'; // 2025
    PrvConstant[0].PrvRate4:= '17.80'; // 2025
    PrvConstant[1].PrvRate4:= '17.80'; // 2025
    PrvConstant[0].PrvRate5:= '19.80'; // 2025
    PrvConstant[1].PrvRate5:= '19.80'; // 2025
    PrvConstant[0].PrvRate6:= '20.80'; // 2025
    PrvConstant[1].PrvRate6:= '20.80'; // 2025
    PrvConstant[0].PrvRate7:= '21.30'; // 2025
    PrvConstant[1].PrvRate7:= '21.30'; // 2025
    PrvConstant[0].PrvRate8:= '21.80'; // 2025
    PrvConstant[1].PrvRate8:= '21.80'; // 2025

    PrvConstant[0].PrvBracketTax1:= 0;
    PrvConstant[1].PrvBracketTax1:= 0;
    PrvConstant[0].PrvBracketTax2:= 3844.70; //2025
    PrvConstant[1].PrvBracketTax2:= 3844.70; //2025  Round(PrvConstant[1].PrvBracketTax1+PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1)/100);
    PrvConstant[0].PrvBracketTax3:= 10252.25; //2025
    PrvConstant[1].PrvBracketTax3:= 10252.25; //2025  Round(PrvConstant[1].PrvBracketTax2+(PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2)/100);
    PrvConstant[0].PrvBracketTax4:= 21219.03; // 2025
    PrvConstant[1].PrvBracketTax4:= 21219.03; // 2025  Round(PrvConstant[1].PrvBracketTax3+(PrvConstant[1].PrvBracket3 - PrvConstant[1].PrvBracket2) * vl(PrvConstant[1].PrvRate3)/100);
    PrvConstant[0].PrvBracketTax5:= 32454.04; // 2025
    PrvConstant[1].PrvBracketTax5:= 32454.04; // 2025  Round(PrvConstant[1].PrvBracketTax4+(PrvConstant[1].PrvBracket4 - PrvConstant[1].PrvBracket3) * vl(PrvConstant[1].PrvRate4)/100); //was tax 4 20150907
    PrvConstant[0].PrvBracketTax6:= 44592.23; // 2025  Round(PrvConstant[0].PrvBracketTax4+(PrvConstant[0].PrvBracket4 - PrvConstant[0].PrvBracket3) * vl(PrvConstant[0].PrvRate4)/100);
    PrvConstant[1].PrvBracketTax6:= 44592.23; // 2025  Round(PrvConstant[1].PrvBracketTax4+(PrvConstant[1].PrvBracket4 - PrvConstant[1].PrvBracket3) * vl(PrvConstant[1].PrvRate4)/100); //was tax 4 20150907
    PrvConstant[0].PrvBracketTax7:= 103292.95; // 2025 Round(PrvConstant[0].PrvBracketTax4+(PrvConstant[0].PrvBracket4 - PrvConstant[0].PrvBracket3) * vl(PrvConstant[0].PrvRate4)/100);
    PrvConstant[1].PrvBracketTax7:= 103292.95; // 2025  Round(PrvConstant[1].PrvBracketTax4+(PrvConstant[1].PrvBracket4 - PrvConstant[1].PrvBracket3) * vl(PrvConstant[1].PrvRate4)/100); //was tax 4 20150907
    PrvConstant[0].PrvBracketTax8:= 223516.33; // 2025 Round(PrvConstant[0].PrvBracketTax4+(PrvConstant[0].PrvBracket4 - PrvConstant[0].PrvBracket3) * vl(PrvConstant[0].PrvRate4)/100);
    PrvConstant[1].PrvBracketTax8:= 223516.33; // 2025  Round(PrvConstant[1].PrvBracketTax4+(PrvConstant[1].PrvBracket4 - PrvConstant[1].PrvBracket3) * vl(PrvConstant[1].PrvRate4)/100); //was tax 4 20150907

    PrvConstant[0].PrvPersAmount:= 11067; // 2025
    PrvConstant[1].PrvPersAmount:= 11067; // 2025

    PrvConstant[0].PrvAgeNIThreshHold:= 85806; //85428; // 2025
    PrvConstant[1].PrvAgeNIThreshHold:= 85806; // 2025


    PrvConstant[0].PrvSpouseBasicAmount:= 9948; // 2025
    PrvConstant[1].PrvSpouseBasicAmount:= 9948; // 2025

    PrvConstant[0].PrvMaxSpousalAmount:= 9043; // 2025
    PrvConstant[1].PrvMaxSpousalAmount:= 9043; // 2025

    // Page 2
    // from federal s1 or provincial 5001-c line 58360
    PrvConstant[0].PrvMaxPensionAmount:= 1000; // 2025
    PrvConstant[1].PrvMaxPensionAmount:= 1000; // 2025

    // from 5001-c bottom page 1
    PrvConstant[0].PrvMedicalLimit:= 2410; // 2025
    PrvConstant[1].PrvMedicalLimit:= 2410; // 2025

    // Do not using on the form 5001-c
    PrvConstant[0].PrvMaxMedicalExpense:= 10000; // 2023
    PrvConstant[1].PrvMaxMedicalExpense:= 10000; // 2023

    // from 5001-c bottom page 1
    PrvConstant[0].PrvNonRefundRate:= vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvNonRefundRate:= vl(PrvConstant[1].PrvRate1);

    // from 5001-c bottom page 1
    PrvConstant[0].PrvDonRate1:= 8.7; //2025
    PrvConstant[1].PrvDonRate1:= 8.7; //2025 vl(PrvConstant[1].PrvRate1);

    // from 5001-c bottom page 1
    PrvConstant[0].PrvDonRate2:= 21.8; //2025
    PrvConstant[1].PrvDonRate2:= 21.8; //2025

    // Do not using on the form 5001-c // from 5001-c top page 2
    PrvConstant[0].PrvOverseasRate:= 51.3; // 2023
    PrvConstant[1].PrvOverseasRate:= 51.3; // 2023
    // from 5001-c top page 2
    PrvConstant[0].PrvAmtCarryOverRate:= 60; // 2025
    PrvConstant[1].PrvAmtCarryOverRate:= 60; // 2025
    {$endregion ' from 5001-c '}

    {$region ' from 5001-pc '}

    // from 5001-pc Line 5808 Age Amount
    PrvConstant[0].PrvAgeNIThreshHold:= 85806; //83876; // 2025
    PrvConstant[1].PrvAgeNIThreshHold:= 85806; //83876; // 2025

    // from 5001-pc Line 5833
    PrvConstant[0].PrvMaxAdoption := 14935; // 2025 //jz//20251230 //14599; // 2024
    PrvConstant[1].PrvMaxAdoption := 14935; // 2025 //jz//20251230 //14599; // 2024

    {$endregion ' from 5001-pc '}

    {$region ' from 5001-d '}
    // from 5001-d line 5808
    PrvConstant[0].PrvMaxAgeAmount:= 7064; //6905; // 2025
    PrvConstant[1].PrvMaxAgeAmount:= 7064; //6905; // 2025

    // from 5001-d line 5808
    PrvConstant[0].PrvAgeBaseAmount:= 38712; //37842; // 2025
    PrvConstant[1].PrvAgeBaseAmount:= 38712; //37842; // 2025

    // from 5001-d line 5820
    PrvConstant[0].PrvInfirmDependBase:= 11067; //10818; // 2025
    PrvConstant[1].PrvInfirmDependBase:= 11067; //10818; // 2025

    // from 5001-d line 5820
    PrvConstant[0].PrvMaxInfirmDependAmount:= 3515; //3435; // 2025
    PrvConstant[1].PrvMaxInfirmDependAmount:= 3515; //3435; // 2025

    // from 5001-d line 5840
    PrvConstant[0].PrvCareGvrBase:= 20689; //20224; // 2025
    PrvConstant[1].PrvCareGvrBase:= 20689; //20224; // 2025

    // from 5001-d line 5840
    PrvConstant[0].PrvMaxCareGvr:= 3514; //3435; // 2025
    PrvConstant[1].PrvMaxCareGvr:= 3514; //3435; // 2025

    // from 5001-d Line 6152
    PrvConstant[0].PrvDivRate := '3.2'; // 2024
    PrvConstant[1].PrvDivRate := '3.2'; // 2024

    // from 5001-d Line 6152
    PrvConstant[0].PrvDivRateBig := '6.3'; // 2024
    PrvConstant[1].PrvDivRateBig := '6.3'; // 2024

    // from 5001-d line 5844
    PrvConstant[0].PrvMaxDisability:= 7467; // 2025 //20251208 Igor
    PrvConstant[1].PrvMaxDisability:= 7467; // 2025 //20251208 Igor

    // from 5001-d line 5844
    PrvConstant[0].PrvMaxDisabSupl18 := 3435; // 2024
    PrvConstant[1].PrvMaxDisabSupl18 := 3435; // 2024

    // from 5001-d line 5844
    PrvConstant[0].PrvDisabSuplBase := 2920; // 2024
    PrvConstant[1].PrvDisabSuplBase := 2920; // 2024
    {$endregion ' from 5001-d '}

    {$region ' from 5001-s11 '}
    // from 5001-s11
    PrvConstant[0].PrvPartEducPerMonth:= 60; // 2023
    PrvConstant[1].PrvPartEducPerMonth:= 60; // 2023
                                                  +
    // from 5001-s11                             +
    PrvConstant[0].PrvEducPerMonth:= 200; // 2023
    PrvConstant[1].PrvEducPerMonth:= 200; // 2023

    // from 5001-s11
    PrvConstant[0].PrvMaxEducXfer:= 5000; // 2023
    PrvConstant[1].PrvMaxEducXfer:= 5000; // 2023
    {$endregion ' from 5001-s11 '}
  end;

  if (Prv = 'SK') then
  begin
    Cpi:= 1.017;

    {$region ' from 5008-c '}
    // from 5008-c
    PrvConstant[0].PrvBracket1:= 53463; // 2025
    PrvConstant[1].PrvBracket1:= 53463; // 2025
    PrvConstant[0].PrvBracket2:= 152750; // 2025
    PrvConstant[1].PrvBracket2:= 152750; // 2025

    // from 5008-c
    PrvConstant[0].PrvRate1:= '10.50'; // 2025
    PrvConstant[1].PrvRate1:= '10.50'; // 2024
    PrvConstant[0].PrvRate2:= '12.50'; // 2025
    PrvConstant[1].PrvRate2:= '12.50'; // 2025
    PrvConstant[0].PrvRate3:= '14.50'; // 2025
    PrvConstant[1].PrvRate3:= '14.50'; // 2025

    // from 5008-c
    PrvConstant[0].PrvBracketTax1:= 0; // 2025
    PrvConstant[1].PrvBracketTax1:= 0; // 2025
    PrvConstant[0].PrvBracketTax2:= 5613.62; //2025  Round(PrvConstant[0].PrvBracketTax1+PrvConstant[0].PrvBracket1 * vl(PrvConstant[0].PrvRate1)/100);
    PrvConstant[1].PrvBracketTax2:= 5613.62; //2025  Round(PrvConstant[1].PrvBracketTax1+PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1)/100);
    PrvConstant[0].PrvBracketTax3:= 18024.49; // 2025   Round(PrvConstant[0].PrvBracketTax2+(PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2)/100);
    PrvConstant[1].PrvBracketTax3:= 18024.49; // 2025   Round(PrvConstant[1].PrvBracketTax2 + (PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2) / 100);

    // from 5008-c
    PrvConstant[0].PrvPersAmount:= 19491; // 2025
    PrvConstant[1].PrvPersAmount:= 19491; // 2025

    PrvConstant[0].PrvAgeNIThreshHold:= 81633; //85428; // 2025
    PrvConstant[1].PrvAgeNIThreshHold:= 81633; // 2025

    // from 5008-c
     PrvConstant[0].PrvMaxSpousalAmount:= 19491; // 2025
    PrvConstant[1].PrvMaxSpousalAmount:= 19491; // 2025

    // from 5008-c
    PrvConstant[0].PrvSpouseBasicAmount:= 21440; // 2025
    PrvConstant[1].PrvSpouseBasicAmount:= 21440; // 2025

    // from 5008-c Line 5836 from fed s1 line 314
    PrvConstant[0].PrvMaxPensionAmount:= 1000; // 2025
    PrvConstant[1].PrvMaxPensionAmount:= 1000; // 2025

    // from 5008-c
    PrvConstant[0].PrvMedicalLimit:= 2681; // 2025
    PrvConstant[1].PrvMedicalLimit:= 2681; // 2025

    PrvConstant[0].PrvMaxMedicalExpense:= 10000; // 2023
    PrvConstant[1].PrvMaxMedicalExpense:= 10000; // 2023

    // from 5008-c bottom page 1
    PrvConstant[0].PrvNonRefundRate:= vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvNonRefundRate:= vl(PrvConstant[1].PrvRate1);

    // from 5008-c bottom page 1
    PrvConstant[0].PrvDonRate1:= vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1:= vl(PrvConstant[1].PrvRate1);

    // 5008c
    PrvConstant[0].PrvDonRate2:= vl(PrvConstant[0].PrvRate3); // 2022 // 14.75;
    PrvConstant[1].PrvDonRate2:= vl(PrvConstant[1].PrvRate3); // 2022 // 14.75;

    // from 5008-c top page 2
    PrvConstant[0].PrvOverseasRate:= 50; // 2023
    PrvConstant[1].PrvOverseasRate:= 50; // 2023

    // from 5008-c top page 2
    PrvConstant[0].PrvAmtCarryOverRate:= 50; // 2023
    PrvConstant[1].PrvAmtCarryOverRate:= 50; // 2023

    {$endregion ' from 5008-c '}

    {$region ' from 5008-d '}
    // 5008d Line 5808
    PrvConstant[0].PrvMaxAgeAmount:= 5785; // 2025
    PrvConstant[1].PrvMaxAgeAmount:= 5785; // 2025
    // 5008d Line 5808
    PrvConstant[0].PrvAgeBaseAmount:= 43066;  //41933; // 2025
    PrvConstant[1].PrvAgeBaseAmount:= 43066; //41933; // 2025

    // from 5008-d Line 5820
    PrvConstant[0].PrvInfirmDependBase:= 21924; // 2025
    PrvConstant[1].PrvInfirmDependBase:= 21924; //18624; // 2025

    // from 5008-d Line 5820
    PrvConstant[0].PrvMaxInfirmDependAmount:= 13986; //2025
    PrvConstant[1].PrvMaxInfirmDependAmount:= 13986; //2025

    // from 5008-d Line 5840
    PrvConstant[0].PrvCareGvrBase:= 33094; //29499; // 2025
    PrvConstant[1].PrvCareGvrBase:= 33094; //29499; // 2025

    // from 5008-d Line 5840
    PrvConstant[0].PrvMaxCareGvr:= 13986; // 10894; // 2025
    PrvConstant[1].PrvMaxCareGvr:= 13986; //10894; // 2025

    // 5008d Line 6152
    PrvConstant[0].PrvDivRate:= '2.519'; // 2025
    PrvConstant[1].PrvDivRate:= '2.519'; // 2025
    // 5008d Line 6152
    PrvConstant[0].PrvDivRateBig:= '11'; // 2025
    PrvConstant[1].PrvDivRateBig:= '11'; // 2025

    // from 5008-d line 5848
    PrvConstant[0].PrvMaxDisability:= 13986; //10894; // 2025
    PrvConstant[1].PrvMaxDisability:= 13986; //10894; // 2025

    // from 5008-d line 5844
    PrvConstant[0].PrvMaxDisabSupl18:= 13986; //10894; // 2025
    PrvConstant[1].PrvMaxDisabSupl18:= 13986; //10894; // 2025

    // from 5008-d line 5844
    PrvConstant[0].PrvDisabSuplBase:= 3277; //3191; // 2025
    PrvConstant[1].PrvDisabSuplBase:= 3277; //3191; // 2025

    PrvConstant[0].PrvMaxAdoption:= 0; // 2023
    PrvConstant[1].PrvMaxAdoption:= 0; // 2023
    {$endregion ' from 5008-d '}

    {$region ' from 5008-pc '}
    // 5008pc Line 5808
    PrvConstant[0].PrvAgeNIThreshHold:= 81633; //79427; // 2025
    PrvConstant[1].PrvAgeNIThreshHold:= 81633; //79427; // 2025
    {$endregion ' from 5008-pc '}

    {$region ' from 5008-s11 '}
    // from 5008-s11
    PrvConstant[0].PrvEducPerMonth:= 400; // 2023
    PrvConstant[1].PrvEducPerMonth:= 400; // 2023

    // from 5008-s11
    PrvConstant[0].PrvPartEducPerMonth:= 120; // 2023
    PrvConstant[1].PrvPartEducPerMonth:= 120; // 2023

    // from 5008-s11
    PrvConstant[0].PrvMaxEducXfer:= 5000; // 2023
    PrvConstant[1].PrvMaxEducXfer:= 5000; // 2023
    {$endregion ' from 5008-s11 '}
  end;

  if (Prv = 'NT') then
  begin
    Cpi := 1.017;

    {$region ' 5012-c '}
    // from 5012-c
    PrvConstant[0].PrvBracket1:= 51964; // 2025
    PrvConstant[1].PrvBracket1:= 51964; // 2025
    PrvConstant[0].PrvBracket2:= 103930;// 2025
    PrvConstant[1].PrvBracket2:= 103930;// 2025
    PrvConstant[0].PrvBracket3:= 168967; // 2025
    PrvConstant[1].PrvBracket3:= 168967; // 2025

    // from 5012-c
    PrvConstant[0].PrvRate1:= '5.9'; // 2025
    PrvConstant[1].PrvRate1:= '5.9'; // 2025
    PrvConstant[0].PrvRate2:= '8.6'; // 2025
    PrvConstant[1].PrvRate2:= '8.6'; // 2025
    PrvConstant[0].PrvRate3:= '12.2'; // 2025
    PrvConstant[1].PrvRate3:= '12.2'; // 2025
    PrvConstant[0].PrvRate4:= '14.05'; // 2025
    PrvConstant[1].PrvRate4:= '14.05'; // 2025

    // from 5012-c
    PrvConstant[0].PrvBracketTax1:= 0;
    PrvConstant[1].PrvBracketTax1:= 0;
    PrvConstant[0].PrvBracketTax2:= 3065.88; //2025 Round(PrvConstant[0].PrvBracketTax1 + PrvConstant[0].PrvBracket1 * vl(PrvConstant[0].PrvRate1) / 100);
    PrvConstant[1].PrvBracketTax2:= 3065.88; //2025 Round(PrvConstant[1].PrvBracketTax1 + PrvConstant[1].PrvBracket1 *      vl(PrvConstant[1].PrvRate1) / 100);
    PrvConstant[0].PrvBracketTax3:= 7534.95; //2025 Round(PrvConstant[0].PrvBracketTax2 + (PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2) / 100);
    PrvConstant[1].PrvBracketTax3:= 7534.95; //2025 Round(PrvConstant[1].PrvBracketTax2 + (PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2) / 100);
    PrvConstant[0].PrvBracketTax4:= 15469.47; //2025 Round(PrvConstant[0].PrvBracketTax3 + (PrvConstant[0].PrvBracket3 - PrvConstant[0].PrvBracket2) * vl(PrvConstant[0].PrvRate3) / 100);
    PrvConstant[1].PrvBracketTax4:= 15469.47; //2025 Round(PrvConstant[1].PrvBracketTax3 + (PrvConstant[1].PrvBracket3 - PrvConstant[1].PrvBracket2) * vl(PrvConstant[1].PrvRate3) / 100);

    // from 5012-c
    PrvConstant[0].PrvPersAmount:= 17842; // 2025
    PrvConstant[1].PrvPersAmount:= 17842; // 2025

    // form 5012-c
    PrvConstant[0].PrvSpouseBasicAmount:= 17842; // 2025
    PrvConstant[1].PrvSpouseBasicAmount:= 17842; // 2025

    PrvConstant[0].PrvAgeNIThreshHold:= 103702; //85428; // 2025
    PrvConstant[1].PrvAgeNIThreshHold:= 103702; // 2025


    PrvConstant[0].PrvMaxSpousalAmount:= 17842;// 2025
    PrvConstant[1].PrvMaxSpousalAmount:= 17842;// 2025

    // from 5012-c line 5836 or fed s1 line 314
    PrvConstant[0].PrvMaxPensionAmount:= 1000; // 2024
    PrvConstant[1].PrvMaxPensionAmount:= 1000; // 2024

    // from 5012-c
    PrvConstant[0].PrvMedicalLimit:= 2834; // 2025
    PrvConstant[1].PrvMedicalLimit:= 2834; // 2025

    // from 5012-c bottom page 1
    PrvConstant[0].PrvNonRefundRate:= vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvNonRefundRate:= vl(PrvConstant[1].PrvRate1);

    // from 5012-c bottom page 1
    PrvConstant[0].PrvDonRate1:= vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1:= vl(PrvConstant[1].PrvRate1);

    // from 5012-c bottom page 1
    PrvConstant[0].PrvDonRate2:= 14.05; // 2025
    PrvConstant[1].PrvDonRate2:= 14.05; // 2025

    // from 5012-c top page 2
    PrvConstant[0].PrvOverseasRate:= 45; // 2025
    PrvConstant[1].PrvOverseasRate:= 45; // 2025

    // from 5012-c top page 2
    PrvConstant[0].PrvAmtCarryOverRate:= 45; // 2025
    PrvConstant[1].PrvAmtCarryOverRate:= 45; // 2025
    {$endregion ' 5012-c '}

    {$region ' 5012-d '}
    // from 5012-d Line 5808 Age amount
    PrvConstant[0].PrvMaxAgeAmount:= 8727; // 2025
    PrvConstant[1].PrvMaxAgeAmount:= 8727; // 2025

    // from 5012-d Line 5808 Age amount
    PrvConstant[0].PrvAgeBaseAmount:= 45522; // 2025
    PrvConstant[1].PrvAgeBaseAmount:= 45522; //44325; // 2025

    // from 5012-d line 5820
    PrvConstant[0].PrvInfirmDependBase:= 14305; // 2025
    PrvConstant[1].PrvInfirmDependBase:= 14305; // 2025

    // from 5012-d Line 5820
    PrvConstant[0].PrvMaxInfirmDependAmount:= 5915; // 2025
    PrvConstant[1].PrvMaxInfirmDependAmount:= 5915; //5759; // 2025

    // from 5012-d Line 5840
    PrvConstant[0].PrvCareGvrBase:= 26111; //25424; // 2025
    PrvConstant[1].PrvCareGvrBase:= 26111; //25424; // 2025

    // from 5012-d Line 5840
    PrvConstant[0].PrvMaxCareGvr:= 5914; // 5758; // 2024
    PrvConstant[1].PrvMaxCareGvr:= 5914; // 2025

    // 5012-d or 5012-pc Line 5872
    PrvConstant[0].PrvMaxMedicalExpense:= 5000; // 2023
    PrvConstant[1].PrvMaxMedicalExpense:= 5000; // 2023

    // from 5012-d Line 6152
    PrvConstant[0].PrvDivRate:= '6'; // 2024
    PrvConstant[1].PrvDivRate:= '6'; // 2024

    // from 5012-d Line 6152
    PrvConstant[0].PrvDivRateBig:= '11.5'; // 2024
    PrvConstant[1].PrvDivRateBig:= '11.5'; // 2024

    // from 5012-d line 5848
    PrvConstant[0].PrvMaxDisability:= 14469; // 2025
    PrvConstant[1].PrvMaxDisability:= 14469; // 2025

    // from 5012-d line 5844
    PrvConstant[0].PrvMaxDisabSupl18:= 5914; //5758; // 2025
    PrvConstant[1].PrvMaxDisabSupl18:= 5914; //5758; // 2025

    // from 5012-d line 5844
    PrvConstant[0].PrvDisabSuplBase:= 3464; //3373; // 2025
    PrvConstant[1].PrvDisabSuplBase:= 3464; //3373; // 2025

    PrvConstant[0].PrvMaxAdoption:= 0; // 2023
    PrvConstant[1].PrvMaxAdoption:= 0; // 2023
    {$endregion ' 5012-d '}

    {$region ' 5012-pc '}
    // guide nt 5012-pc line 5808
    PrvConstant[0].PrvAgeNIThreshHold:=103702; //100979; // 2025
    PrvConstant[1].PrvAgeNIThreshHold:=103702; //100979; // 2025
    {$endregion ' 5012-pc '}

    {$region ' 5012-s11 '}
    // from  5012-s11
    PrvConstant[0].PrvPartEducPerMonth:= 120; // 2023
    PrvConstant[1].PrvPartEducPerMonth:= 120; // 2023

    // from  5012-s11
    PrvConstant[0].PrvEducPerMonth:= 400; // 2023
    PrvConstant[1].PrvEducPerMonth:= 400; // 2023

    // from  5012-s11
    PrvConstant[0].PrvMaxEducXfer:= 5000; // 2023
    PrvConstant[1].PrvMaxEducXfer:= 5000; // 2023
    {$endregion ' 5012-s11 '}
  end;

  if (Prv = 'NB') then
  begin
    Cpi:= 1.017;

    {$region ' 5004-c '}
    // ?  two new brackes wetre introduced in 2015. Not implemented in this release
    // from 5004-c
    PrvConstant[0].PrvBracket1:= 51306; // 2025
    PrvConstant[1].PrvBracket1:= 51306; // 2025
    PrvConstant[0].PrvBracket2:= 102614; // 2025
    PrvConstant[1].PrvBracket2:= 102614; // 2025
    PrvConstant[0].PrvBracket3:= 190060; // 2025
    PrvConstant[1].PrvBracket3:= 190060; // 2025

    // from 5004-c
    PrvConstant[0].PrvRate1:= '9.40'; // 2025
    PrvConstant[1].PrvRate1:= '9.40'; // 2025
    PrvConstant[0].PrvRate2:= '14.00'; // 2025
    PrvConstant[1].PrvRate2:= '14.00'; // 2025
    PrvConstant[0].PrvRate3:= '16.00'; // 2025
    PrvConstant[1].PrvRate3:= '16.00'; // 2025
    PrvConstant[0].PrvRate4:= '19.50'; // 2025
    PrvConstant[1].PrvRate4:= '19.50'; // 2025

    // from 5004-c
    PrvConstant[0].PrvBracketTax1:= 0;
    PrvConstant[1].PrvBracketTax1:= 0;
    PrvConstant[0].PrvBracketTax2:= 4822.76; // 2025  Round(PrvConstant[0].PrvBracketTax1+PrvConstant[0].PrvBracket1 * vl(PrvConstant[0].PrvRate1)/100);
    PrvConstant[1].PrvBracketTax2:= 4822.76; // 2025  Round(PrvConstant[1].PrvBracketTax1+PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1)/100);
    PrvConstant[0].PrvBracketTax3:= 12005.88; // 2025  //2019 //Round(PrvConstant[0].PrvBracketTax2+(PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2)/100);
    PrvConstant[1].PrvBracketTax3:= 12005.88; // 2025  //Round(PrvConstant[1].PrvBracketTax2+(PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2)/100);
    PrvConstant[0].PrvBracketTax4:= 25997.24; // 2025  Round(PrvConstant[0].PrvBracketTax3+(PrvConstant[0].PrvBracket3 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[0].PrvRate3)/100);
    PrvConstant[1].PrvBracketTax4:= 25997.24; // 2025  Round(PrvConstant[1].PrvBracketTax3+(PrvConstant[1].PrvBracket3 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate3)/100);

    // from 5004-c
    PrvConstant[0].PrvPersAmount:= 13396; // 2025
    PrvConstant[1].PrvPersAmount:= 13396; // 2025

    PrvConstant[0].PrvAgeNIThreshHold:= 85192; //85428; // 2025
    PrvConstant[1].PrvAgeNIThreshHold:= 85192; // 2025

    // form 5004-c
    PrvConstant[0].PrvSpouseBasicAmount:= 11550; // 2025
    PrvConstant[1].PrvSpouseBasicAmount:= 11550; // 2025

    PrvConstant[0].PrvMaxSpousalAmount:= 10499;// 2025
    PrvConstant[1].PrvMaxSpousalAmount:= 10499;// 2025

    // from 5004-c line 5836 or fed s1 line 314
    PrvConstant[0].PrvMaxPensionAmount:= 1000; // 2025
    PrvConstant[1].PrvMaxPensionAmount:= 1000; // 2025

    // from 5004-c
    PrvConstant[0].PrvMedicalLimit:= 2798; //2025
    PrvConstant[1].PrvMedicalLimit:= 2798; //2025

    PrvConstant[0].PrvMaxMedicalExpense:= 10000; // 2023
    PrvConstant[1].PrvMaxMedicalExpense:= 10000; // 2023

    // from 5004-c bottom page 1
    PrvConstant[0].PrvNonRefundRate:= vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvNonRefundRate:= vl(PrvConstant[1].PrvRate1);

    // from 5004-c bottom page 1
    PrvConstant[0].PrvDonRate1:= vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1:= vl(PrvConstant[1].PrvRate1);

    // from 5004-c bottom page 1
    PrvConstant[0].PrvDonRate2:= 17.95; // 2023
    PrvConstant[1].PrvDonRate2:= 17.95; // 2023

    // from 5004-c top page 2
    PrvConstant[0].PrvOverseasRate:= 57; // 2025
    PrvConstant[1].PrvOverseasRate:= 57; // 2025

    // from 5004-c top page 2
    PrvConstant[0].PrvAmtCarryOverRate:= 57; // 2025
    PrvConstant[1].PrvAmtCarryOverRate:= 57; // 2025
    {$endregion ' 5004-c '}

    {$region ' 5004-pc '}
    // guide nt 5004-pc line 5808
    PrvConstant[0].PrvAgeNIThreshHold:= 85192; //82950; // 2025
    PrvConstant[1].PrvAgeNIThreshHold:= 85192; //82950; // 2025
    {$endregion ' 5004-pc '}

    {$region ' 5004-d '}
    // from 5004-d Line 5808 Age amount
    PrvConstant[0].PrvMaxAgeAmount:= 6037; //5878; //2025
    PrvConstant[1].PrvMaxAgeAmount:= 6037; //5878; //2025

    // from 5004-d Line 5808 Age amount
    PrvConstant[0].PrvAgeBaseAmount:= 44945; //43763; // 2025
    PrvConstant[1].PrvAgeBaseAmount:= 44945; //43763; // 2025

    // from 5004-d line 5820
    PrvConstant[0].PrvInfirmDependBase:= 14124; //13753; // 2025
    PrvConstant[1].PrvInfirmDependBase:= 14124; //13753; // 2025

    // from 5004-d Line 5820
    PrvConstant[0].PrvMaxInfirmDependAmount:= 5839; //5686; // 2025
    PrvConstant[1].PrvMaxInfirmDependAmount:= 5839; //5686; // 2025

    // from 5004-d Line 5840
    PrvConstant[0].PrvCareGvrBase:= 25781; //25103; // 2025
    PrvConstant[1].PrvCareGvrBase:= 25781; //25103; // 2025

    // from 5004-d Line 5840
    PrvConstant[0].PrvMaxCareGvr:= 5839; //5686; // 2025
    PrvConstant[1].PrvMaxCareGvr:= 5839; //5686; // 2025

    // from 5004-d Line 6152
    PrvConstant[0].PrvDivRate:= '2.75'; // 2025
    PrvConstant[1].PrvDivRate:= '2.75'; // 2025

    // from 5004-d Line 6152
    PrvConstant[0].PrvDivRateBig:= '14'; // 2025
    PrvConstant[1].PrvDivRateBig:= '14'; // 2025

    // from 5004-d line 5848
    PrvConstant[0].PrvMaxDisability:= 10010; //9747; // 2025
    PrvConstant[1].PrvMaxDisability:= 10010; //9747; // 2025

    // from 5004-d line 5844
    PrvConstant[0].PrvMaxDisabSupl18:= 5839; //5686; // 2025
    PrvConstant[1].PrvMaxDisabSupl18:= 5839; //5686; // 2025

    // from 5004-d line 5844
    PrvConstant[0].PrvDisabSuplBase:= 3420; //3330; // 2025
    PrvConstant[1].PrvDisabSuplBase:= 3420; //3330; // 2025

    PrvConstant[0].PrvMaxAdoption:= 0; // 2023
    PrvConstant[1].PrvMaxAdoption:= 0; // 2023
    {$endregion ' 5004-d '}

    {$region ' 5004-s11 '}
    // from  5004-s11
    PrvConstant[0].PrvPartEducPerMonth := 120; // 2023
    PrvConstant[1].PrvPartEducPerMonth := 120; // 2023

    // from  5004-s11
    PrvConstant[0].PrvEducPerMonth := 400; // 2023
    PrvConstant[1].PrvEducPerMonth := 400; // 2023

    // from  5004-s11
    PrvConstant[0].PrvMaxEducXfer := 5000; // 2023
    PrvConstant[1].PrvMaxEducXfer := 5000; // 2023
    {$endregion ' 5004-s11 '}
  end;

  if (Prv = 'PE') then //20241208 2 more brackets
  begin
    Cpi:= 1.000;

    {$region ' 5002-c '}
    PrvConstant[0].PrvBracket1:= 33328; // 2025
    PrvConstant[1].PrvBracket1:= 33328; // 2025
    PrvConstant[0].PrvBracket2:= 64656; // 2025
    PrvConstant[1].PrvBracket2:= 64656; // 2025
    PrvConstant[0].PrvBracket3:= 105000; // 2025
    PrvConstant[1].PrvBracket3:= 105000; // 20254
    PrvConstant[0].PrvBracket4:= 140000; // 2025
    PrvConstant[1].PrvBracket4:= 140000; // 2025

    //needs more brackets: yes //20241208
    PrvConstant[0].PrvRate1:= '9.5'; // 2025
    PrvConstant[1].PrvRate1:= '9.5'; // 2025
    PrvConstant[0].PrvRate2:= '13.47'; // 2025
    PrvConstant[1].PrvRate2:= '13.47'; // 2025
    PrvConstant[0].PrvRate3:= '16.6'; // 2025
    PrvConstant[1].PrvRate3:= '16.6'; // 2025
    PrvConstant[0].PrvRate4:= '17.62'; // 2025
    PrvConstant[1].PrvRate4:= '17.62'; // 2025
    PrvConstant[0].PrvRate5:= '19'; // 2025
    PrvConstant[1].PrvRate5:= '19'; // 2025

    PrvConstant[0].PrvBracketTax1:= 0;
    PrvConstant[1].PrvBracketTax1:= 0;
    PrvConstant[0].PrvBracketTax2:= 3166.16; //2025
    PrvConstant[1].PrvBracketTax2:= 3166.16; //2025
    PrvConstant[0].PrvBracketTax3:= 7386.04; //2025
    PrvConstant[1].PrvBracketTax3:= 7386.04; //2025
    PrvConstant[0].PrvBracketTax4:= 14083.15; //2025
    PrvConstant[1].PrvBracketTax4:= 14083.15; //2025
    PrvConstant[0].PrvBracketTax5:= 20250.15; //2025
    PrvConstant[1].PrvBracketTax5:= 20250.15; //2025

    PrvConstant[0].PrvPersAmount:= 14650; // 2025
    PrvConstant[1].PrvPersAmount:= 14650; // 2025

    // NOTE  **** 5816 elig dependant is hardcoded in S5prv
    // it does not follow the spousal parameters. Hardcode each year
    // from 5002-c
    PrvConstant[0].PrvSpouseBasicAmount:= 13687;  //2025
    PrvConstant[1].PrvSpouseBasicAmount:= 13687;  //2025

    // from 5002-c line 5815
    PrvConstant[0].PrvMaxSpousalAmount:= 12443;  //2025
    PrvConstant[1].PrvMaxSpousalAmount:= 12443;  //2025

    //Page 2
    // from 5002-c line 58360 Line 27
    PrvConstant[0].PrvMaxPensionAmount:= 1000; // 2025
    PrvConstant[1].PrvMaxPensionAmount:= 1000; // 2025

    // from 5002-c Line 44
    PrvConstant[0].PrvMedicalLimit:= 1678; // 2025
    PrvConstant[1].PrvMedicalLimit:= 1678; // 2025

    // from 5002-c bottom page 1
    PrvConstant[0].PrvNonRefundRate:= vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvNonRefundRate:= vl(PrvConstant[1].PrvRate1);

    // from 5002-c bottom page 1
    PrvConstant[0].PrvDonRate1:= vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1:= vl(PrvConstant[1].PrvRate1);

    // from 5002-c bottom page 1
    PrvConstant[0].PrvDonRate2:= 19; // 2025   //20250126
    PrvConstant[1].PrvDonRate2:= 19; // 2025

    //Page 3
    // from 5002-c top page 2
    PrvConstant[0].PrvOverseasRate:= 57.5; // 2025
    PrvConstant[1].PrvOverseasRate:= 57.5; // 2025
    // from 5002-c top page 2
    PrvConstant[0].PrvAmtCarryOverRate:= 57.5; // 2025
    PrvConstant[1].PrvAmtCarryOverRate:= 57.5; // 2025
    {$endregion ' 5002-c '}


    {$endregion ' 5002-pc '}

    {$region ' 5002-d '}

    PrvConstant[0].PrvAgeNIThreshHold:= 80000; //85428; // 2025
    PrvConstant[1].PrvAgeNIThreshHold:= 80000; // 2025

    // from 5002-d line 5808
    PrvConstant[0].PrvMaxAgeAmount:= 6510; //5595; // 2025
    PrvConstant[1].PrvMaxAgeAmount:= 6510; //5595; // 2025

    // from 5002-d line 5808
    PrvConstant[0].PrvAgeBaseAmount:= 36600; //33740; // 2025
    PrvConstant[1].PrvAgeBaseAmount:= 36600; //33740; // 2025

    // from 5002-d line 5820
    PrvConstant[0].PrvInfirmDependBase:= 7412; // 2025
    PrvConstant[1].PrvInfirmDependBase:= 7412; // 2025

    // from 5002-d line 5820
    PrvConstant[0].PrvMaxInfirmDependAmount:= 2446; // 2025
    PrvConstant[1].PrvMaxInfirmDependAmount:= 2446; // 2025

    // from 5002-d line 5840
    PrvConstant[0].PrvCareGvrBase:= 14399; // 2025
    PrvConstant[1].PrvCareGvrBase:= 14399; // 20254

    // from 5002-d line 5840
    PrvConstant[0].PrvMaxCareGvr:= 2446; // 2025
    PrvConstant[1].PrvMaxCareGvr:= 2446; // 2025

    PrvConstant[0].PrvMaxMedicalExpense:= 10000; // 2023
    PrvConstant[1].PrvMaxMedicalExpense:= 10000; // 2023

    // from 5002-d Line 6152
    PrvConstant[0].PrvDivRate:= '1.30'; // 2025
    PrvConstant[1].PrvDivRate:= '1.30'; // 2025
    // from 5002-d Line 6152
    PrvConstant[0].PrvDivRateBig:= '10.5'; // 2025
    PrvConstant[1].PrvDivRateBig:= '10.5'; // 2025

    // from 5002-d line 5848
    PrvConstant[0].PrvMaxDisability:= 6890; // 2025
    PrvConstant[1].PrvMaxDisability:= 6890; // 2025

    // from 5002-d line 5844
    PrvConstant[0].PrvMaxDisabSupl18:= 4019; // 2025
    PrvConstant[1].PrvMaxDisabSupl18:= 4019; // 2025

    // from 5002-d line 5844
    PrvConstant[0].PrvDisabSuplBase:= 2354; // 2025
    PrvConstant[1].PrvDisabSuplBase:= 2354; // 2025

    PrvConstant[0].PrvMaxAdoption:= 0; // 2024
    PrvConstant[1].PrvMaxAdoption:= 0; // 2024
    {$endregion ' 5002-d '}

    {$region ' 5002-s11 '}
    // from 5002-s11
    PrvConstant[0].PrvPartEducPerMonth:= 120; // 2023
    PrvConstant[1].PrvPartEducPerMonth:= 120; // 2023

    // from 5002-s11
    PrvConstant[0].PrvEducPerMonth:= 400; // 2023
    PrvConstant[1].PrvEducPerMonth:= 400; // 2023

    // from 5002-s11
    PrvConstant[0].PrvMaxEducXfer:= 5000; // 2023
    PrvConstant[1].PrvMaxEducXfer:= 5000; // 2023
    {$endregion ' 5002-s11 '}
  end;

  if (Prv = 'NU') then //20211125
  begin
    Cpi:= 1.015;

    {$region ' 5014-c '}
    // from 5014-c
    PrvConstant[0].PrvBracket1:= 54707; // 2025
    PrvConstant[1].PrvBracket1:= 54707; // 2025
    PrvConstant[0].PrvBracket2:= 109413; // 2025
    PrvConstant[1].PrvBracket2:= 109413; // 2025
    PrvConstant[0].PrvBracket3:= 177881; // 2025
    PrvConstant[1].PrvBracket3:= 177881; // 2025

    // from 5014-c
    PrvConstant[0].PrvRate1:= '4'; // 2025
    PrvConstant[1].PrvRate1:= '4'; // 2025
    PrvConstant[0].PrvRate2:= '7'; // 2025
    PrvConstant[1].PrvRate2:= '7'; // 2025
    PrvConstant[0].PrvRate3:= '9'; // 2025
    PrvConstant[1].PrvRate3:= '9'; // 2025
    PrvConstant[0].PrvRate4:= '11.5'; // 2025
    PrvConstant[1].PrvRate4:= '11.5'; // 2025

    // from 5014-c
    PrvConstant[0].PrvBracketTax1:= 0; // 2025
    PrvConstant[1].PrvBracketTax1:= 0; // 2025
    PrvConstant[0].PrvBracketTax2:= 2188.28; // 2025 Round(PrvConstant[0].PrvBracketTax1 + PrvConstant[0].PrvBracket1 * vl(PrvConstant[0].PrvRate1) / 100);
    PrvConstant[1].PrvBracketTax2:= 2188.28; // 2025 Round(PrvConstant[1].PrvBracketTax1 + PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1) / 100);
    PrvConstant[0].PrvBracketTax3:= 6017.70; // 2025 Round(PrvConstant[0].PrvBracketTax2 + (PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2) / 100);
    PrvConstant[1].PrvBracketTax3:= 6017.70; // 2025 Round(PrvConstant[1].PrvBracketTax2 + (PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2) / 100);
    PrvConstant[0].PrvBracketTax4:= 12179.82; // 2025 Round(PrvConstant[0].PrvBracketTax3 + (PrvConstant[0].PrvBracket3 - PrvConstant[0].PrvBracket2) * vl(PrvConstant[0].PrvRate3) / 100);
    PrvConstant[1].PrvBracketTax4:= 12179.82; // 2025  Round(PrvConstant[1].PrvBracketTax3 + (PrvConstant[1].PrvBracket3 - PrvConstant[1].PrvBracket2) * vl(PrvConstant[1].PrvRate3) / 100);

    // from 5014-c
    PrvConstant[0].PrvPersAmount:= 19274; // 2025
    PrvConstant[1].PrvPersAmount:= 19274; // 2025

    PrvConstant[0].PrvAgeNIThreshHold:= 127542; //85428; // 2025
    PrvConstant[1].PrvAgeNIThreshHold:= 127542; // 2025

    // from 5014-c
    PrvConstant[0].PrvSpouseBasicAmount:= 19274; // 2025
    PrvConstant[1].PrvSpouseBasicAmount:= 19274; // 2025

    // from 5014-c line 5836
    PrvConstant[0].PrvMaxPensionAmount:= 2000; // 2025
    PrvConstant[1].PrvMaxPensionAmount:= 2000; // 2025

    // from 5014-c
    PrvConstant[0].PrvMedicalLimit:= 2834; // 2025
    PrvConstant[1].PrvMedicalLimit:= 2834; // 2025

    PrvConstant[0].PrvMaxMedicalExpense:= 10000; // 2023
    PrvConstant[1].PrvMaxMedicalExpense:= 10000; // 2023

    // from 5014-c bottom page 1
    PrvConstant[0].PrvNonRefundRate:= vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvNonRefundRate:= vl(PrvConstant[1].PrvRate1);

    // from 5014-c bottom page 1
    PrvConstant[0].PrvDonRate1:= vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1:= vl(PrvConstant[1].PrvRate1);

    // from 5014-c bottom page 1
    PrvConstant[0].PrvDonRate2:= 11.5; // 2025
    PrvConstant[1].PrvDonRate2:= 11.5; // 2025

    // from 5014-c top page 2
    PrvConstant[0].PrvOverseasRate:= 45; // 2025
    PrvConstant[1].PrvOverseasRate:= 45; // 2025

    // from 5014-c top page 2
    PrvConstant[0].PrvAmtCarryOverRate:= 45; // 2025
    PrvConstant[1].PrvAmtCarryOverRate:= 45; // 2025
    {$endregion ' 5014-c '}

    {$region ' 5014-d '}
    // from 5014-d line 5808
    PrvConstant[0].PrvMaxAgeAmount:= 12303; // 2025
    PrvConstant[1].PrvMaxAgeAmount:= 12303; // 2025

    // from 5014-d line 5808
    PrvConstant[0].PrvAgeBaseAmount:= 45522; //44325; // 2025
    PrvConstant[1].PrvAgeBaseAmount:= 45522; //44325; // 2025

    // from 5014-d line 5820
    PrvConstant[0].PrvInfirmDependBase:= 14305; //13929; // 2025
    PrvConstant[1].PrvInfirmDependBase:= 14305; //13929; // 2025

    // from 5014-d line 5820
    PrvConstant[0].PrvMaxInfirmDependAmount:= 5914; //5759; // 2025
    PrvConstant[1].PrvMaxInfirmDependAmount:=5914; //5759; // 2025

    // from 5014-d line 5840
    PrvConstant[0].PrvCareGvrBase:= 26111; //25424; // 2025
    PrvConstant[1].PrvCareGvrBase:= 26111; //25424; // 2025

    // from 5014-d line 5840
    PrvConstant[0].PrvMaxCareGvr:= 5914; //5758; // 2025
    PrvConstant[1].PrvMaxCareGvr:= 5914; //5758; // 2025

    // from 5014-d Line 6152
    PrvConstant[0].PrvDivRate:= '2.61'; // 2025
    PrvConstant[1].PrvDivRate:= '2.61'; // 2025

    // from 5014-d Line 6152
    PrvConstant[0].PrvDivRateBig:= '5.51'; // 2025
    PrvConstant[1].PrvDivRateBig:= '5.51'; // 2025

    // from 5014-d line 5848
    PrvConstant[0].PrvMaxDisability:= 16405; // 2025
    PrvConstant[1].PrvMaxDisability:= 16405; // 2025

    // from 5014-d line 5844
    PrvConstant[0].PrvMaxDisabSupl18:= 5914; //5758; // 2025
    PrvConstant[1].PrvMaxDisabSupl18:= 5914; //5758; // 2025

    // from 5014-d line 5844
    PrvConstant[0].PrvDisabSuplBase:= 3464; //3373; // 2025
    PrvConstant[1].PrvDisabSuplBase:= 3464; //3373; // 2025

    PrvConstant[0].PrvMaxAdoption:= 0; // 2023
    PrvConstant[1].PrvMaxAdoption:= 0; // 2023
    {$endregion ' 5014-d '}

    {$region ' 5014-pc '}
    // from 5014-pc line 5808
    PrvConstant[0].PrvAgeNIThreshHold:= 127542; //124192; // 2025
    PrvConstant[1].PrvAgeNIThreshHold:= 127542; //124192; // 2025
    {$endregion ' 5014-pc '}

    {$region ' 5014-s11 '}
    // from 5014-s11
    PrvConstant[0].PrvPartEducPerMonth:= 120; // 2023
    PrvConstant[1].PrvPartEducPerMonth:= 120; // 2023

    // from 5014-s11
    PrvConstant[0].PrvEducPerMonth:= 400; // 2023
    PrvConstant[1].PrvEducPerMonth:= 400; // 2023

    // from 5014-s11
    PrvConstant[0].PrvMaxEducXfer:= 5000; // 2023
    PrvConstant[1].PrvMaxEducXfer:= 5000; // 2023
    {$endregion ' 5014-s11 '}

    {$region ' 5014-n '}
    // from 5014-n Line 5812
    PrvConstant[0].PrvMaxSpousalAmount:= 19274; //18767; // 2025
    PrvConstant[1].PrvMaxSpousalAmount:= 19274; //18767; // 2024
    {$endregion ' 5014-n '}
  end;

  if (Prv = 'YT') then
  begin
    Cpi:= 1.017;

    // ?  New tax bracket over $500000 Not implemented in this release
    {$region ' 5011-c '}
    // from 5011-c
    PrvConstant[0].PrvBracket1:= 57375; // 2025
    PrvConstant[1].PrvBracket1:= 57375; // 2025
    PrvConstant[0].PrvBracket2:= 114750; // 2025
    PrvConstant[1].PrvBracket2:= 114750; // 2025
    PrvConstant[0].PrvBracket3:= 177882; // 2025
    PrvConstant[1].PrvBracket3:= 177882; // 2025
    PrvConstant[0].PrvBracket4:= 500000; // 2025
    PrvConstant[1].PrvBracket4:= 500000; // 2025

    // from 5011-c
    PrvConstant[0].PrvRate1:= '6.40'; // 2025
    PrvConstant[1].PrvRate1:= '6.40'; // 2025
    PrvConstant[0].PrvRate2:= '9.00'; // 2025
    PrvConstant[1].PrvRate2:= '9.00'; // 2025
    PrvConstant[0].PrvRate3:= '10.90'; // 2025
    PrvConstant[1].PrvRate3:= '10.90'; // 2025
    PrvConstant[0].PrvRate4:= '12.80'; // 2025
    PrvConstant[1].PrvRate4:= '12.80'; // 2025
    PrvConstant[0].PrvRate5:= '15'; // 2025
    PrvConstant[1].PrvRate4:= '15'; // 2025

    // from 5011-c
    PrvConstant[0].PrvBracketTax1:= 0;
    PrvConstant[1].PrvBracketTax1:= 0;
    PrvConstant[0].PrvBracketTax2:= 3672.00; // 2025 Round(PrvConstant[0].PrvBracketTax1 + PrvConstant[0].PrvBracket1 * vl(PrvConstant[0].PrvRate1) / 100);
    PrvConstant[1].PrvBracketTax2:= 3672.00; // 2025 Round(PrvConstant[1].PrvBracketTax1 + PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1) / 100);
    PrvConstant[0].PrvBracketTax3:= 8835.75; // 2025 Round(PrvConstant[0].PrvBracketTax2 + (PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2) / 100);
    PrvConstant[1].PrvBracketTax3:= 8835.75; // 2025 Round(PrvConstant[1].PrvBracketTax2 + (PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2) / 100);
    PrvConstant[0].PrvBracketTax4:= 15717.14; // 2025 Round(PrvConstant[0].PrvBracketTax3 + (PrvConstant[0].PrvBracket3 - PrvConstant[0].PrvBracket2) * vl(PrvConstant[0].PrvRate3) / 100);
    PrvConstant[1].PrvBracketTax4:= 15717.14; // 2025 Round(PrvConstant[1].PrvBracketTax3 + (PrvConstant[1].PrvBracket3 - PrvConstant[1].PrvBracket2) * vl(PrvConstant[1].PrvRate3) / 100);
    PrvConstant[0].PrvBracketTax5:= 56948.24; // 2025 Round(PrvConstant[0].PrvBracketTax4 + (PrvConstant[0].PrvBracket4 - PrvConstant[0].PrvBracket3) * vl(PrvConstant[0].PrvRate4) / 100);
    PrvConstant[1].PrvBracketTax5:= 56948.24; // 2025 Round(PrvConstant[1].PrvBracketTax4 + (PrvConstant[1].PrvBracket4 - PrvConstant[1].PrvBracket3) * vl(PrvConstant[1].PrvRate4) / 100);

    // from 5011-c  //federal 30000
    PrvConstant[0].PrvPersAmount:= 16129; // 2025
    PrvConstant[1].PrvPersAmount:= 16129; // 2025

    // from 5011-c
    PrvConstant[0].PrvSpouseBasicAmount:= 14398; // 2023???
    PrvConstant[1].PrvSpouseBasicAmount:= 14398; // 2023

    // from 5011-c line 5836
    PrvConstant[0].PrvMaxPensionAmount:= 2000; // 2024
    PrvConstant[1].PrvMaxPensionAmount:= 2000; // 2024

    // from 5011-c
    PrvConstant[0].PrvMedicalLimit:= 2834; // 2025
    PrvConstant[1].PrvMedicalLimit:= 2834; // 2025

    PrvConstant[0].PrvMaxMedicalExpense:= 10000; // 2023
    PrvConstant[1].PrvMaxMedicalExpense:= 10000; // 2023

    // from 5011-c bottom page 1
    PrvConstant[0].PrvNonRefundRate:= vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvNonRefundRate:= vl(PrvConstant[1].PrvRate1);

    // from 5011-c bottom page 1
    PrvConstant[0].PrvDonRate1:= vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1:= vl(PrvConstant[1].PrvRate1);

    // from 5011-c bottom page 1
    PrvConstant[0].PrvDonRate2:= 12.80; // 2023
    PrvConstant[1].PrvDonRate2:= 12.80; // 2023

    // from 5011-c top page 2
    PrvConstant[0].PrvOverseasRate:= 44.14; // 2025
    PrvConstant[1].PrvOverseasRate:= 44.14; // 2025

    // from 5011-c top page 2
    PrvConstant[0].PrvAmtCarryOverRate:= 44.14; // 2025
    PrvConstant[1].PrvAmtCarryOverRate:= 44.14; // 2025
    {$endregion ' 5011-c '}

    {$region ' 5011-d '}
    // from 5011-d line 5808
    PrvConstant[0].PrvMaxAgeAmount:= 9028; // 2025 //jz//20260112
    PrvConstant[1].PrvMaxAgeAmount:= 9028; // 2025

    // from 5011-d line 5808
    PrvConstant[0].PrvAgeBaseAmount:= 39826; // 2023
    PrvConstant[1].PrvAgeBaseAmount:= 39826; // 2023

    // from 5011-d line 5820  //NOT USED in logic  As in federal
    PrvConstant[0].PrvInfirmDependBase:= 17670; // 2023
    PrvConstant[1].PrvInfirmDependBase:= 17670; // 2023

    // from 5011-d line 5820  //NOT USED in logic  As in federal
    PrvConstant[0].PrvMaxInfirmDependAmount:= 7525; // 2023
    PrvConstant[1].PrvMaxInfirmDependAmount:= 7525; // 2023

    // from 5011-d line 5840  //NOT USED in logic  As in federal
    PrvConstant[0].PrvCareGvrBase:= 25195; // 2023
    PrvConstant[1].PrvCareGvrBase:= 25195; // 2023

    // from 5011-d line 5840
    PrvConstant[0].PrvMaxCareGvr:= 4732; // 2023
    PrvConstant[1].PrvMaxCareGvr:= 4732; // 2023

    // from 5011-d Line 6152
    PrvConstant[0].PrvDivRate:= '0.67'; //2025
    PrvConstant[1].PrvDivRate:= '0.67'; //2025    // from 5011-d Line 6152

    PrvConstant[0].PrvDivRateBig:= '12.02'; // 2025
    PrvConstant[1].PrvDivRateBig:= '12.02'; // 2025

    // from 5011-d line 5848
    PrvConstant[0].PrvMaxDisability:= Constant[0].MaxDisability; //jz//20260327//MJCERT2025 - seems to be same as fed //8870; // 2023
    PrvConstant[1].PrvMaxDisability:= Constant[1].MaxDisability; //jz//20260327//MJCERT2025 - seems to be same as fed //8870; // 2023

    // from 5011-d line 5844
    PrvConstant[0].PrvMaxDisabSupl18:= 5174; // 2023
    PrvConstant[1].PrvMaxDisabSupl18:= 5174; // 2023

    // from 5011-d line 5844
    PrvConstant[0].PrvDisabSuplBase:= 3030; // 2023
    PrvConstant[1].PrvDisabSuplBase:= 3030; // 2023

    PrvConstant[0].PrvMaxAdoption:= 17131; // 2023
    PrvConstant[1].PrvMaxAdoption:= 19066; // 2024
    {$endregion ' 5011-d '}

    {$region ' 5011-pc '}
    // from 5011-pc line 5808
    PrvConstant[0].PrvAgeNIThreshHold:= 92479; // 2023
    PrvConstant[1].PrvAgeNIThreshHold:= 92479; // 2023
    {$endregion ' 5011-pc '}

    {$region ' 5011-n '}
    // from 5011-n Line 5812
    PrvConstant[0].PrvMaxSpousalAmount:= 14398; // 2023
    PrvConstant[1].PrvMaxSpousalAmount:= 14398; // 2023
    {$endregion ' 5011-n '}

    {$region ' 5011-s11 '}
    // from 5011-s11
    PrvConstant[0].PrvPartEducPerMonth:= 120; // 2023
    PrvConstant[1].PrvPartEducPerMonth:= 120; // 2023

    // from 5011-s11
    PrvConstant[0].PrvEducPerMonth:= 400; // 2023
    PrvConstant[1].PrvEducPerMonth:= 400; // 2023

    // from 5011-s11
    PrvConstant[0].PrvMaxEducXfer:= 5000; // 2023
    PrvConstant[1].PrvMaxEducXfer:= 5000; // 2023
    {$endregion ' 5011-s11 '}
  end;

  if (Prv = 'NS') then
  begin
    Cpi:= 1.000;

    {$region ' 5003-c '}
    PrvConstant[0].PrvBracket1:= 30507; // 2025
    PrvConstant[1].PrvBracket1:= 30507; // 2025
    PrvConstant[0].PrvBracket2:= 61015; // 2025
    PrvConstant[1].PrvBracket2:= 61015; // 2025
    PrvConstant[0].PrvBracket3:= 95883; // 2025
    PrvConstant[1].PrvBracket3:= 95883; // 2025
    PrvConstant[0].PrvBracket4:= 154650; // 2025
    PrvConstant[1].PrvBracket4:= 154650; // 2025

    // from 5003-c
    PrvConstant[0].PrvRate1:= '8.79'; // 2025
    PrvConstant[1].PrvRate1:= '8.79'; // 2025
    PrvConstant[0].PrvRate2:= '14.95'; // 2025
    PrvConstant[1].PrvRate2:= '14.95'; // 2025
    PrvConstant[0].PrvRate3:= '16.67'; // 2025
    PrvConstant[1].PrvRate3:= '16.67'; // 2025
    PrvConstant[0].PrvRate4:= '17.5'; // 2025
    PrvConstant[1].PrvRate4:= '17.5'; // 2025
    PrvConstant[0].PrvRate5:= '21'; // 2025
    PrvConstant[1].PrvRate5:= '21'; // 2025

    // from 5003-c
    PrvConstant[0].PrvBracketTax1:= 0;
    PrvConstant[1].PrvBracketTax1:= 0;
    PrvConstant[0].PrvBracketTax2:= 2681.57; //2024
    PrvConstant[1].PrvBracketTax2:= 2681.57; //2025   Round(PrvConstant[1].PrvBracketTax1 + PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1) / 100);
    PrvConstant[0].PrvBracketTax3:= 7242.51; //2025       Round(PrvConstant[0].PrvBracketTax2+(PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2)/100);
    PrvConstant[1].PrvBracketTax3:= 7242.51; //2025       Round(PrvConstant[1].PrvBracketTax2 + (PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2) / 100);    // from 5010-c
    PrvConstant[0].PrvBracketTax4:= 13055.01; // 2025    Round(PrvConstant[0].PrvBracketTax3+(PrvConstant[0].PrvBracket3 - PrvConstant[0].PrvBracket2) * vl(PrvConstant[0].PrvRate3)/100);
    PrvConstant[1].PrvBracketTax4:= 13055.01; // 2025     Round(PrvConstant[1].PrvBracketTax3+(PrvConstant[1].PrvBracket3 - PrvConstant[1].PrvBracket2) * vl(PrvConstant[1].PrvRate3)/100);
    PrvConstant[0].PrvBracketTax5:= 23339.23; // 2025   Round(GetTaxOnBase(PrvConstant[0].PrvBracket4,PrvConstant[0].PrvBracket3,Vl(PrvConstant[0].PrvRate4),PrvConstant[0].PrvBracketTax4));
    PrvConstant[1].PrvBracketTax5:= 23339.23; // 2025     Round(PrvConstant[1].PrvBracketTax4+(PrvConstant[1].PrvBracket4 - PrvConstant[1].PrvBracket3) * vl(PrvConstant[1].PrvRate4)/100);

    // from 5003-c
    PrvConstant[0].PrvPersAmount:= 11744; // 2025
    PrvConstant[1].PrvPersAmount:= 11744; // 2025

    PrvConstant[0].PrvAgeNIThreshHold:= 69055; //85428; // 2025
    PrvConstant[1].PrvAgeNIThreshHold:= 69055; // 2025

    // from 5003-c
    PrvConstant[0].PrvSpouseBasicAmount:= 12618; // 2025
    PrvConstant[1].PrvSpouseBasicAmount:= 12618; // 2025

    // from 5003-c
    PrvConstant[0].PrvMaxSpousalAmount:= 11744; // 2025
    PrvConstant[1].PrvMaxSpousalAmount:= 11744; // 2025

    // from 5003-c line 5836
    PrvConstant[0].PrvMaxPensionAmount:= 1173; // 2025
    PrvConstant[1].PrvMaxPensionAmount:= 1173; // 2025

    // from 5003-c
    PrvConstant[0].PrvMedicalLimit:= 1637; // 2025
    PrvConstant[1].PrvMedicalLimit:= 1637; // 2025

    PrvConstant[0].PrvMaxMedicalExpense:= 10000; // 2023
    PrvConstant[1].PrvMaxMedicalExpense:= 10000; // 2023

    // from 5003-c bottom page 1
    PrvConstant[0].PrvNonRefundRate:= vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvNonRefundRate:= vl(PrvConstant[1].PrvRate1);

    // from 5003-c bottom page 1
    PrvConstant[0].PrvDonRate1:= vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1:= vl(PrvConstant[1].PrvRate1);

    // from 5003-c bottom page 1
    PrvConstant[0].PrvDonRate2:= 21; // 2023
    PrvConstant[1].PrvDonRate2:= 21; // 2023

    // from 5003-c top page 2
    PrvConstant[0].PrvOverseasRate:= 57.5; // 2023
    PrvConstant[1].PrvOverseasRate:= 57.5; // 2023

    // from 5003-c top page 2
    PrvConstant[0].PrvAmtCarryOverRate:= 57.5; // 2023
    PrvConstant[1].PrvAmtCarryOverRate:= 57.5; // 2023
    {$endregion ' 5003-c '}

    {$region ' 5003-n '}

    // from 5003-n line 5808
    PrvConstant[0].PrvAgeNIThreshHold:= 69055; //59437; // 2025
    PrvConstant[1].PrvAgeNIThreshHold:= 69055; //59437; // 2025

    {$endregion ' 5003-n '}

    {$region ' 5003-d '}
    //needs supplement?
    // from 5003-d line 5808
    PrvConstant[0].PrvMaxAgeAmount:= 5734; //4141; // 2025
    PrvConstant[1].PrvMaxAgeAmount:= 5734; //4141; // 2025

    // from 5003-d line 5808
    PrvConstant[0].PrvAgeBaseAmount:= 30828; // 2025
    PrvConstant[1].PrvAgeBaseAmount:= 30828; // 2025

    // from 5003-d line 5820
    PrvConstant[0].PrvInfirmDependBase:= 8744; //11841; // 2025
    PrvConstant[1].PrvInfirmDependBase:= 8744; //11841; // 2025

    // from 5003-d line 5820
    PrvConstant[0].PrvMaxInfirmDependAmount:= 2885; //2798; // 2025
    PrvConstant[1].PrvMaxInfirmDependAmount:= 2885; //2798; // 2025

    // from 5003-d line 5840
    PrvConstant[0].PrvCareGvrBase:= 18575; // 2025
    PrvConstant[1].PrvCareGvrBase:= 18575; // 2025

    // from 5003-d line 5840
    PrvConstant[0].PrvMaxCareGvr:= 4898; // 2025
    PrvConstant[1].PrvMaxCareGvr:= 4898; // 2025

    // from 5003-d Line 6152
    PrvConstant[0].PrvDivRate:= '1.50'; // 2025
    PrvConstant[1].PrvDivRate:= '1.50; //2.99'; // 2025
    // from 5003-d Line 6152
    PrvConstant[0].PrvDivRateBig:= '8.85'; // 2025
    PrvConstant[1].PrvDivRateBig:= '8.85'; // 2025

    // from 5003-d line 5848
    PrvConstant[0].PrvMaxDisability:= 7341; // 2025
    PrvConstant[1].PrvMaxDisability:= 7341; // 2025
    // from 5003-d line 5844
    PrvConstant[0].PrvMaxDisabSupl18:= 3449; // 2025
    PrvConstant[1].PrvMaxDisabSupl18:= 3449; // 2025

    // from 5003-d line 5844
    PrvConstant[0].PrvDisabSuplBase:= 2346; // 2025
    PrvConstant[1].PrvDisabSuplBase:= 2346; // 2025

    PrvConstant[0].PrvMaxAdoption:= 0; // 2023
    PrvConstant[1].PrvMaxAdoption:= 0; // 2023
    {$endregion ' 5003-d '}

    {$region ' 5003-s11 '}
    // from 5003-s11
    PrvConstant[0].PrvPartEducPerMonth:= 60; // 2023
    PrvConstant[1].PrvPartEducPerMonth:= 60; // 2023

    // from 5003-s11
    PrvConstant[0].PrvEducPerMonth:= 200; // 2023
    PrvConstant[1].PrvEducPerMonth:= 200; // 2023

    // from 5003-s11
    PrvConstant[0].PrvMaxEducXfer:= 5000; // 2023
    PrvConstant[1].PrvMaxEducXfer:= 5000; // 2023
    {$endregion ' 5003-s11 '}
  end;
end;
//20250918 Igor <<<


procedure INFO(RetNo: integer; FName: String; FNo: integer);
var
  i, DaysInCan: integer;
  s: string;
  TempList: TStringList;
  x: Real;
  T1248FNo:Integer;
begin
  T1248FNo:=GetFormNo('T1248');
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin

   if Strings[245]>'' then Strings[250]:='';  //If property in QC then the other provinces is blank //20250506

   if Strings[242]+Strings[243]='' then Begin Strings[242]:='X';Strings[243]:='';End; //20240302

   if getResidencytype(retNo)='1' then Strings[226]:='X';  //main categories Canadian resident //20240215

   if (GetResidencyType(RetNo)<>'3') then
   Begin
    Strings[246]:='';  //20240428C  Defines code '4'  for 17700 ='4' deemed
    Strings[244]:='';  ////20240517  Remove the N/A on the Info
   end;
   if Strings[226]+Strings[227]+Strings[228]+Strings[229]
      +Strings[230]+Strings[231]+Strings[232]='' then Strings[226]:='X';  //20240126
   if FetchElm(RetNo,FNo,139)>'' then   //first time filer  //20240107
   Begin
    If Strings[233]='' then Strings[233]:=Strings[2];
    If Strings[235]='' then Strings[235]:='X'; //second name
    If Strings[234]='' then Strings[234]:=Strings[5];
   End;

   if IsFirstTimeFiler(retNo) = false then //20240223
   Begin
    Strings[233]:='';
    Strings[235]:='';
    Strings[234]:='';
   End;
    //set the 17700 field on T2048  //20240323
   if (IsCanadianResident(RetNo))
   Or (IsFactualResident(RetNo))
   then
   begin
     Strings[246]:='';  // 17700 - Deemed Other reasons  //20240428C
     StoreElm(RetNo,T1248FNo,1,'');StoreElm(RetNo,T1248FNo,2,'');StoreElm(RetNo,T1248FNo,3,'');
   end;

   If Strings[227]>'' then StoreElm(RetNo,T1248FNo,3,'X'); //factual resident

   //20240323
   if (Strings[251]='') and (Strings[252]='') then //items 1 and 2 are empty
   begin
    for i:=237 to 241 do begin Strings[i]:='';end;  //then sub-items musdt be empty
   end;

   //bankcruptcy //20240401
   if Strings[92]>'' then
   begin
    Strings[227]:='';
    Strings[228]:='';
    Strings[229]:='';
    Strings[230]:='';
    Strings[231]:='';
    Strings[232]:='';
   end;

   //  **************************************
   //non resident
   if Strings[251]>'' then StoreElm(RetNo,T1248FNo,1,'X'); //non Resident
   if Strings[252]>'' then StoreElm(RetNo,T1248FNo,2,'X'); //deemed non Resident
   //253 183 days??
  // if Strings[254]>'' then StoreElm(RetNo,T1248FNo,4,'X'); //non Resident other reasons //20240412

   if (Strings[228]>'') then    //NR wor deemed resident//202440425
   begin
    If Strings[43]+Strings[44]='' then Strings[44]:='X';
   end;

   //jz//NonResCERT-R1//202404
   if (Strings[254]='') then
   begin
    Strings[204]:=''; //deemed resident of quebec
    Strings[205]:=''; //quebec remission order
   end;
   if  Strings[204]='' then //jz//20250422
    Strings[205]:=''; //quebec remission order

   {no good applies only o case 10 and 11 But 12 has donations and it aplies?
   if Strings[238]>'' then    //NR with only taxable property sale //202440323
   begin
    Strings[73]:='X';  //zero out Fed Non refundable credits
    Strings[189]:='X'; //zero out Fed Non refundable credits
   end;
   }
   // *************************************************


   //needed  /20240428B
   if IsCanadianResident(RetNo)   then Strings[236]:='Canadian Resident';
   if IsFactualResident(RetNo)    then Strings[236]:='Factual Resident';

   If GetResidencyType(RetNo)='3' then Strings[236]:='Non-Resident or Deemed Resident';


{
   // --------------NEW CODE ------------------------------------
    //20260315
   If (IsDeemed183(retNo))  //Deemed resident 183 days
   then
   begin
    Strings[7]:='DEEMED RESIDENT';   //top of the form during printing of t1
    Strings[1]:='';
   end;
}



   //---------------------------------------------------------

   If GetResidencyType(RetNo)='4' then Strings[236]:='Immigrant';
   If GetResidencyType(RetNo)='5' then Strings[236]:='Emigrant';
   If GetResidencyType(RetNo)='6' then Strings[236]:='Deemed resident with permanent Business in Canada';
   If GetResidencyType(RetNo)='7' then Strings[236]:='Deemed resident with Business/Rental outside Canada';

   //20240214
   if Strings[239]>'' then  Strings[93]:='X' else Strings[93]:='';
   if Strings[241]>'' then  Strings[94]:='X' else Strings[94]:='';

   If (Strings[93]>'') and (Strings[94]>'') then Strings[94]:=''; //20240211

   //non residency section of the info //20240215
   Strings[81]:=Strings[251];
   Strings[82]:=Strings[252];
   Strings[83]:=Strings[253];
   Strings[84]:=Strings[254];

    //20210226 ELECTRONIC SIGNATURE
    if Strings[144] = '' then Strings[144] := 'N'; // 20200326  //e-signature
    if Strings[144] <> 'Y' then Strings[144] := ''; // 20200517
    if UpperCase(Strings[144])<>'Y' then begin Strings[158]:='';Strings[203]:='';end;                           //jz//20250314 - remove date to other forms T183 RC71
    if UpperCase(Strings[144])<>'Y' then begin Strings[153]:='';Strings[155]:='';end;                           //remove date time
    if (UpperCase(Strings[144])='Y') and (Strings[153]='') then strings[153]:=FormatDateTime('yyyy-mm-dd',Now); //add date
    if (UpperCase(Strings[144])='Y') and (Strings[155]='') then strings[155]:=TimeToHHMMDD(Now);                //add time
    //-----------------------------

    if UpperCase(strings[190]+strings[193])='XX' then Strings[193]:=''; //20230127
    if UpperCase(strings[194]+strings[195])='XX' then Strings[195]:=''; //20230127
    if UpperCase(strings[196]+strings[197])='XX' then Strings[197]:=''; //20230127
    if UpperCase(strings[218]+strings[219])='XX' then Strings[219]:=''; //20230127  //20230222
    //20220218 NCA
    if Strings[173]='' then
    Begin
     Strings[175]:='';
     Strings[176]:='';
     Strings[177]:='';

     Strings[159]:='';
     Strings[160]:='';
     Strings[174]:='';
     Strings[161]:='';
     Strings[172]:='';
     Strings[179]:='';
    End;
    // NCA
    Strings[161]:=LeftStr(Strings[161],3); //20220405
    if LeftStr(Strings[161],3)<>'USA' then  Strings[172]:='';   //20220216


    //20220218
    if Strings[173]>'' then  //Non Canadian mailing address
    Begin
     Strings[6]:=Strings[159];  //street
     Strings[22]:=''; //apartm
     Strings[68]:='';  //rural
     Strings[163]:='';  //RR
     Strings[10]:=Strings[174]; //'N/A';  //city //20240328
     Strings[14]:='ZZ';
     If LeftStr(Strings[161],3)='USA' then
      Strings[15]:=Strings[172] //postal
     else
      Strings[15]:=''; //'N/A';  //20240328

     Strings[8]:='';
     Strings[179]:=LeftStr(Strings[161],3);
    End;

    If AppYear = '2017' then
      Tv[168] := 0; // 20151127
    If ret[RetNo].SourceDataDir = OptRec.Dir_Planner then
      ret[RetNo].IsTaxPlan := True;
    If ret[RetNo].IsTaxPlan then
      RY := PlanningRy
    else
      RY := 0;

    // NOA //20190125
    // if Strings[183]>'' then  begin  Strings[180]:=''; Strings[181]:='';Strings[182]:=''; end;  //if paper NOA then no other option

    If ret[RetNo].CouplingSw then
    begin
      If GetSpRetNo(RetNo) > 0 then
      begin
        If Strings[65] > '' then
          StoreElm(GetSpRetNo(RetNo), FNo, 24, Strings[65]); // 20120204
        If ret[RetNo].IsTaxPlan then
          ret[GetSpRetNo(RetNo)].IsTaxPlan := True;
        // spouse's self empl indicator //20090102
        If IsSelfEmployed(GetSpRetNo(RetNo)) then
          Strings[36] := 'X'
        else
          Strings[36] := '';
        // Tv[168]:=Vl(FetchElm(RetNo,'RC310',15));  //deemed taxble cap gain   //20101201  //20170126
        // TOSI  //20181223
        Tv[29] := vl(FetchElm(GetSpRetNo(RetNo), 'T1206', 3));
        Tv[30] := vl(FetchElm(GetSpRetNo(RetNo), 'T1206', 4));
        Tv[47] := vl(FetchElm(GetSpRetNo(RetNo), 'T1206', 43));

      end;
    end;

    if Strings[24] = '' then
      Strings[142] := ''; // 20200221

    if Strings[24] = '' then
      Strings[259] := ''; // 20170101 if non deceased then election is blan;

    If HasDeceasedSpouse(RetNo) then
    // LeftStr(Strings[65],4)=AppYear then  //died during the year
    begin
      If (Strings[11] > '') or (Strings[12] > '') then
      begin
        Strings[11] := '';
        Strings[12] := '';
        Strings[13] := 'X';
      end;
    end;

    If RY = 1 then
      PlanYear := IntToStr(StrToInt(AppYear) + 1)
    else
      PlanYear := AppYear;
    If UpperCase(Strings[48]) = 'X' then
      Strings[8] := OptRec.Prp_Name;
    {//20260219
    If Strings[11] + Strings[12] + Strings[13] + Strings[16] + Strings[17] +
      Strings[18] = '' then Strings[18] := 'X';
    }

    If Strings[169] + Strings[170] = '' then
      Strings[170] := 'X';
    If Strings[169] + Strings[170] = 'XX' then
      Strings[170] := '';
    If Strings[169] = '' then
      Strings[171] := ''; // not moved
    Strings[47] := '';
    // field used to hold the discounter's indicator //20120207

   // If Strings[194]+Strings[195]='' then  Begin Strings[19]:=''; End; //bc tsaww

    For i := 25 to 28 do
    begin
      If Length(Strings[i]) = 1 then
        Strings[i] := '0' + Strings[i];
    end;

    If Strings[46] > '' then
      Strings[46] := 'X';
    If Strings[46] = '' then
    Begin
      Strings[77] := '';
      Strings[78] := '';
    end; // efileD
    { long prv to short }
    If Length(Strings[14]) > 2 then
    begin
      For i := 1 to High(PrvLong) do
      begin
        If UpperCase(Strings[14]) = UpperCase(PrvLong[i]) then
        begin
          Strings[14] := PrvShort[i];
          Break;
        end;
      end;
    end;

    Strings[200] := GetBirthmonth(RetNo); // 20130220
    Strings[201] := GetBirthDay(RetNo); // 20140105

    If (Strings[54] = '000') then
    begin
      Strings[54] := '';
      Strings[55] := '';
    end; // 20120304
    If LeftStr(Strings[55], 3) = '000' then
    begin
      Strings[54] := '';
      Strings[55] := '';
    end; // 20120304

    If AllTrim(Strings[34]) + AllTrim(Strings[35]) = '' then
      Strings[34] := 'X';
    If UpperCase(Strings[35]) = 'X' then
      Strings[34] := '';

    // ======================================
    // 20191212
    // 100=Prof, 104=Fees 101=Client; 102]:=Discounted 103]:=Volunteer
    if Strings[101] > '' then // client  //20191212
    begin
      Strings[100] := ''; // professional
      Strings[104] := ''; // compensation }
      Strings[102] := ''; // discounted
      Strings[103] := ''; // volunteer
    end;

    If OptRec.Nfl_Disced = '2' then // clent //20200122
    begin
      // leave prof 100 and 104 s optional
      Strings[100] := ''; // professional }
      Strings[104] := ''; // fees}
      Strings[101] := 'X'; // client
      Strings[102] := ''; // discounted
      Strings[103] := ''; // volunteer
    end;

    If OptRec.Nfl_Disced = '3' then // discounted   //20200122
    begin
      // leave prof 100 and 104 s optional
      Strings[102] := 'X'; // discounted
      Strings[101] := ''; // client
      Strings[103] := ''; // volunteer
    end;

    If OptRec.Nfl_Disced = '4' then // discounted   //20200122
    begin
      // leave prof 100 and 104 s optional
      Strings[100] := '';
      Strings[104] := '';
      Strings[101] := '';
      Strings[102] := ''; // client
      Strings[103] := 'X'; // volunteer
    end;


    if Strings[100] + Strings[104] + Strings[101] + Strings[102] +
      Strings[103] = '' then
    Begin
      Strings[100] := 'X';
      Strings[104] := 'X';
    end;; // default

    // =====================================================
    If IsHomeUse then
    begin
      Strings[100] := ''; { compens }
      Strings[104] := ''; { compens }
      Strings[101] := 'X';
      Strings[102] := '';
    end;
    s := UpperCase(Strings[1]); // 20171216  s:=Strings[1];
    ret[RetNo].Province := GetShortPrv(s);
    If (Strings[14] = '') and (ret[RetNo].Province <> 'ZZ') then
      Strings[14] := GetShortPrv(Strings[1]);

    if Strings[21] = '0' then
      Strings[21] := ''; // 20171216 Prov Convert from taxcycle comes as zero

    // 20150412
    If ret[RetNo].Province = 'ZZ' then
    begin
      Strings[220] := '';
      Strings[221] := '';
    end;

    If Strings[80] = '' then
      Strings[80] := Strings[2]; // friendly salutation
    { special returns }
    If Strings[70] = '' then
      Strings[70] := 'NA-Not applicable';
    If (ret[RetNo].Province <> 'ZZ') and (LeftStr(Strings[70], 2) = 'NR') then
      Strings[70] := 'NA-Not applicable';

    If Strings[164] + Strings[165] = '' then
    begin
      If OptRec.Prp_citizen = True then
      begin
        Strings[164] := 'X';
        Strings[165] := '';
      end;
    end;
    if Strings[178]>'' then begin Strings[164]:='';Strings[165]:='';end; //20220130 //not provided

    // If (ret[RetNo].Province = 'ZZ') then begin Strings[164]:='';Strings[165]:='X';end;
    // after knowing the province
    If Strings[164] > '' then // 20090126  //CANADIAN CITIZEN
    begin
      If Strings[43] + Strings[44] = '' then
        Strings[43] := 'X';
    end
    Else
    begin
      Strings[43] := '';
      Strings[44] := '';
    end;

    InitPRVConstants(ret[RetNo].Province);

    ret[RetNo].MarStatus := CalcMarStatus(RetNo);
    If (Strings[76] <> '1') then
      Strings[76] := '';
    If (ret[RetNo].MarStatus < 3) and (Strings[45] = '') then
      Strings[45] := Strings[5]; // sp last name
    ret[RetNo].Age := CalcAge(FetchElm(RetNo, 'INFO', 9));

    // If (UpperCase(Strings[29]) = 'X')  and (UpperCase(Strings[30])='X') then  Strings[30]:='';  //20141121
    // If UpperCase(Strings[128])='X' then begin Strings[29]:='';Strings[30]:='';end; //20141121

    Strings[7] := '';
    ret[RetNo].Deceased := IsDeceased(RetNo);


    //========  PRORATIONS ===========================================
    //======= IMMIGRANTS / EMIGRANTS // 20240423  USE RULE90  Apply only if rule90 is false

    //20240426   Default to Non-resident
      //if (GetResidencyType(retNo)='3')   //non res or deemed //jz//20260315 - no longer make this NR type have prov be 'NON RESIDENT'
      //or                                                                                                    //jz//20260315 - change 'or' to 'if'
    if (FetchElmFNo(RetNo,INFOFNO,246)>'')  //17700 is ticked for t17700='4'  //20240428C
      // Or (GetResidencyType(retNo)='6')  //special NR //20240426
    Or (GetResidencyType(retNo)='7')  //type 7 NR with bus or rental outside canada  //20240426
    or (IsSection116(RetNo))
    then
    begin
     Strings[1]:='NON RESIDENT';
     Ret[RetNo].Province:='ZZ';
    end;

    if (IsSection115(RetNo)) and (FetchElmFNo(RetNo,INFOFNO,276)>'') then //20240428
    Begin
     Strings[1]:='';
    // Ret[RetNo].Province:='ZZ';
    end;



    if isResident(RetNo) then  ret[RetNo].PartYear:=1;  //normal non refundable  //20240424
    if isFactualResident(RetNo) then  ret[RetNo].PartYear:=1;   //20230424C
    if isSection115(RetNo) then  ret[RetNo].PartYear:=1;   //20230424C   //nr with empl
    ret[RetNo].PartYear := 1;  //default //20240426
    if (Immigrant(RetNo)) or (Emigrant(RetNo)) then
    Begin
      if Rule90(retNo)>=90 then
       ret[RetNo].PartYear:=1
      Else
       ret[RetNo].PartYear := Rule90(retNo)/100;
    End
    //===========  NON RESIDENTS ----------Provinve ZZ----//20240423
    Else  //20240426
    Begin
     If (IsNonresident(retNo))   // Province = ZZ no immigrants/emigrants
     Or (IsDeemedNonRes(RetNo)) //(FetchElmFNo(RetNo,InfoFNo,252)>'')  //deemed NonRes //20240517
     //Or (IsSection115(RetNo))    //20240424B with empl  //20240517
     then
     Begin
      If (GetNonResPercent(RetNo)<90)    //and not deemed reidents
      and (IsDeemedRes183(RetNo)=false)
      and (IsDeemedResOther(RetNo)=false)
      // FetchElmFNo(RetNo,InfoFNo,253)+FetchElmFNo(RetNo,InfoFNo,254)='')  //20240517
      //and (FetchElmFNo(RetNo,InfoFNo,252)+FetchElmFNo(RetNo,InfoFNo,253)+FetchElmFNo(RetNo,InfoFNo,254)='') //20240424
      then
      begin
       ret[RetNo].PartYear := 0;
      end
      else
       ret[RetNo].PartYear := 1;
    End;  //20240426
   End;
   //=======================================================================
    s := ''; { string for bancrup and disc no }
    If (IsDeceased(RetNo)) Or (IsDeceasedNextYear(RetNo)) then // 20140219
    begin
      s := '            Estate of the late ' + Strings[2] + ' ' + Strings[5] +
        '  (' + Strings[24] + ' )' + Space(10);
    end;
    If IsSection217(RetNo) then
      s := '   SECTION 217 ELECTION';

    If ret[RetNo].Bankrupt = 1 then { pre-bunkrupty }
    begin
      ret[RetNo].PartYear := vl(FetchElm(RetNo, 'BANKRPT', 2)) /
        Constant[RY].FullYear;
      s := '  PRE-BANKRUPTCY RETURN  ' + '   Bankruptcy date: ' +
        FetchElm(RetNo, 'BANKRPT', 1);
    end;
    If ret[RetNo].Bankrupt = 2 then { post-bunkrupty }
    begin
      ret[RetNo].PartYear := vl(FetchElm(RetNo, 'BANKRPT', 3)) /
        Constant[RY].FullYear;
      s := '  POST-BANKRUPTCY RETURN  ' + ' Bankruptcy date: ' +
        FetchElm(RetNo, 'BANKRPT', 1);
    end;
    If ret[RetNo].Bankrupt = 3 then { trustee-bunkrupty }
    begin
      ret[RetNo].PartYear := 0;
      s := ' TRUSTEE BANKRUPTCY RETURN ' + ' Bankruptcy date: ' +
        FetchElm(RetNo, 'BANKRPT', 1);
    end;
    If (IsReturnDiscounted(RetNo)) and { return discounted }
      (FetchElm(RetNo, 'INFO', 51) = 'X') then { print disc No }
      s := 'Discounter No: ' + OptRec.Prp_discNo + ' ' + s;
    Strings[7] := s;

    ret[RetNo].CppMonths := GetCPPMonths(RetNo); { GetCPPProrate(RetNo); }
    Tv[19] := vl(FetchElm(RetNo, 'S2', 22));
    If Tv[19] > 0 then
      Strings[123] := '';

    // 20150321 relocated from above
    Tv[213] := MaxR(0, Tv[19] - Tv[214]); // 20150321
    If Strings[215] + Strings[216] = '' then // spouse date of entry empty
    begin
      Tv[213] := 0;
      Tv[214] := 0;
    end;

    { --------------- supplement }
    If Strings[50] = '' then
      Strings[50] := '0'; { fil deadline }

    // If Strings[52] = '' then  Strings[52] := '0'; { transfer ref }  //20191208
    // If Strings[53] = '' then  Strings[53] := '1'; { CV }            //20191208

    If Strings[56] = '' then
      Strings[56] := ''; { transfer ref }

    If Strings[112] = '' then
      Strings[112] := FormatDateTime('yyyy-mm-dd', Date);

    If UpperCase(Strings[58]) = 'Y' then
      Strings[58] := 'X'; // comes Y from profile
    If UpperCase(Strings[58]) = 'N' then
      Strings[58] := ''; // comes N from profile
    If FetchElm(RetNo, 'EFMEMO', 21) = '1' then // volunteer
      Strings[58] := '';
    If IsHomeUse then
      Strings[58] := '';
    If Strings[46] = '' then
      Strings[58] := '';

    // 20170105
    If UpperCase(Strings[105] + Strings[106]) = 'XX' then
    Begin
      Strings[105] := '';
      Strings[106] := '';
    End;

    // 20170318
    // pre-assesm rev contact
    If Strings[105] + Strings[106] = '' then
    begin // all blank
      If AllTrim(LeftStr(OptRec.CvSetting, 2)) = '2' then
      begin
        Strings[105] := 'X';
        Strings[106] := '';
      end
      else If AllTrim(LeftStr(OptRec.CvSetting, 2)) = '3' then
      begin
        Strings[105] := '';
        Strings[106] := 'X';
      end;
    end;

    // 20170318
    // post-assesm rev contact
    If Strings[134] + Strings[135] = '' then // 20170105
    // If Strings[133]+Strings[134]+Strings[135]='' then
    begin // all blank
      If AllTrim(LeftStr(OptRec.CvPostSetting, 2)) = '2' then
      begin // Strings[133] := '';  {compens}
        Strings[134] := 'X';
        Strings[135] := '';
      end
      else If AllTrim(LeftStr(OptRec.CvPostSetting, 2)) = '3' then
      begin
        Strings[134] := '';
        Strings[135] := 'X';
      end;
    end; // all blank

    If IsHomeUse then
    begin
      // Strings[104] := '';  {compens}
      Strings[105] := '';
      Strings[106] := '';
    end;

    // 20170105
    If UpperCase(Strings[134] + Strings[135]) = 'XX' then
    Begin
      Strings[134] := '';
      Strings[135] := '';
    End;

    If IsHomeUse then
    begin
      // Strings[133] := '';  {compens}
      Strings[134] := '';
      Strings[135] := '';
    end;

    // print
    If Strings[102] > '' then // discounted
    begin
      if Strings[38] = '' then
        Strings[38] := 'X'; // print T1153
      if Strings[51] = '' then
        Strings[51] := 'X'; // disc no on T1
      // alt address
      Strings[95] := '';
      Strings[96] := '';
      Strings[97] := '';
      Strings[98] := '';
      Strings[99] := '';
    end
    else
    begin // alt address
      Strings[51] := '';
      Strings[38] := '';
    end;

    If IsHomeUse then
    begin
      Strings[48] := ''; { compens }
      Strings[51] := '';
      Strings[38] := '';
    end;

    If (IsDeceased(RetNo)) or (IsPreBankruptcyReturn(RetNo)) or (IsHomeUse) then
    begin
      Strings[95] := '';
      Strings[96] := '';
      Strings[97] := '';
      Strings[98] := '';
      Strings[99] := '';
    end;

    // 20180311
    Strings[95] := '';
    Strings[96] := '';
    Strings[97] := '';
    Strings[98] := '';
    Strings[99] := '';

    If Strings[87] = '' then
      Strings[110] := ''; // first time disability
    If UpperCase(Strings[87]) <> 'X' then
      Strings[85] := '';

    if Strings[128] + Strings[133] = '' then
    begin
      Strings[128] := '';
      Strings[133] := 'X';
    end;
    if UpperCase(Strings[128] + Strings[133]) = 'XX' then
    begin
      Strings[128] := '';
      Strings[133] := 'X';
    end; // 20200208

    If Strings[90] = '' then
      for i := 206 to 210 do
      begin
        Strings[i] := '';
      end; // NT  20131129

    If ret[RetNo].Province <> 'NL' then
    begin
      Strings[127] := '';
      Strings[136] := '';
    end;
    If ret[RetNo].Province <> 'NT' then
    begin
      Strings[90] := '';
      Strings[137] := '';
    end;
    If ret[RetNo].Province <> 'YT' then
    begin
      Strings[132] := '';
      Strings[138] := '';
      Strings[41] := '';
      Strings[42] := '';
    end;


    If (ret[RetNo].Province <> 'NT') then
    begin
      Strings[268] := '';
      Strings[269] := '';
    end; // 20161231

    if Strings[268] = '' then
      Strings[273] := ''; // nt //20200222

    If GetSinNo(RetNo) > '' then
    begin
      If Strings[88] = '' then
      begin
        If (AllTrim(ret[RetNo].SourceFlName) = '') then
          Strings[88] := 'X'
        else
          Strings[88] := ''; // first time client
      end;
    end;
    { Alt address }
    // If Strings[49] = '' then Strings[49] := '00';    //20181227
    { mar status change }
    // mm dd
    If Strings[39] > '' then
    begin
      If (Not Numeric(Strings[39])) then
        Strings[39] := '';
      If vl(Strings[39]) > 12 then
        Strings[39] := '12';
      If Length(Strings[39]) < 2 then
        Strings[39] := PaddZero(Strings[39], 2);
    end;
    If Strings[40] > '' then
    begin
      If (Not Numeric(Strings[40])) then
        Strings[40] := '';
      If vl(Strings[40]) > 31 then
        Strings[40] := '31';
      If Length(Strings[40]) < 2 then
        Strings[40] := PaddZero(Strings[40], 2);
    end;

    If Strings[89] > '' then
    begin
      If (Not Numeric(Strings[89])) then
        Strings[89] := '';
      If vl(Strings[89]) > 2050 then
        Strings[89] := '2050';
    end;

    If Strings[102] > '' then
      Strings[107] := ''; // discounting no xfer to next yr

    // joint invoice
    If ret[RetNo].MarStatus > 2 then
    begin
      Strings[121] := '';
      Strings[129] := '';
      Strings[130] := '';
    end;
    If Strings[121] = '' then
    begin
      Strings[129] := '';
      Strings[130] := '';
      Strings[122] := '';
    end;
    If (Strings[121] > '') and (Strings[129] + Strings[130] = '') then
      Strings[129] := 'X';

    If Strings[121] > '' then // joint invoice
    begin
      If Strings[129] > '' then
      begin
        If Strings[122] = '' then
          Strings[122] := Strings[2] + ' and ' + Strings[20] + ' ' + Strings[5];
      end;
      If Strings[130] > '' then
      begin
        If Strings[122] = '' then
          Strings[122] := Strings[20] + ' and ' + Strings[2] + ' ' + Strings[5];
      end;
    end;

    If ret[RetNo].Province = 'YT' then
    begin
      Strings[41] := RemoveChar(GetFirstNationName(RetNo), '*'); // 20120111
      Strings[42] := GetFirstNationNumber(RetNo);
    end
    else
    begin
      Strings[41] := '';
      Strings[42] := '';
    end;
    If Strings[132] = '' then
    begin
      Strings[41] := '';
      Strings[42] := '';
    end;

    If FetchElm(RetNo, 'RC62#1', 2) > '' then
      Tv[131] := TotMultiple(RetNo, 'RC62', 22)
    else
      Tv[131] := 0;
    Tv[162] := TotMultiple(RetNo, 'RC62', 5);

    If (ret[RetNo].MarStatus > 3)
    and (ret[RetNo].MarStatus <> 5) //allow sin in separated //20221227
    and (Strings[39] + Strings[40] = '')
   // 20160228 and not mar st change
    then
      Strings[4] := ''; // Divorce, separated, single  //20110211

    // 20170128
    // client paid property taxes and/or rent
    if ret[RetNo].Province = 'ON' then
    begin
      if ret[RetNo].FrmHasData[GetFormNo('ONBEN')] then
      begin
        if vl(FetchElm(RetNo, 'ONBEN', 8)) > 0 then
          Strings[270] := 'X'; // prop taxes
        if vl(FetchElm(RetNo, 'ONBEN', 7)) > 0 then
          Strings[271] := 'X'; // rent
      end;
    end;

    if IsForEfile(RetNo) = False then // 20190124  NOA
    Begin
      for i := 180 to 183 do
      Begin
        Strings[i] := '';
      End;
    End;

    // WIIB  //if proson/NR  //20200310
    if Strings[166] > '' then
    begin
      Strings[149] := 'X';
      Strings[150] := '';
    end
    Else
    begin
      Strings[149] := '';
      Strings[150] := 'X';
    end;

    // TEMP 20190129
    // Strings[145]:=''; Strings[146]:='X';Strings[147]:='';Strings[148]:='X';Strings[149]:='';Strings[150]:='X';

    // CAPITALIZATION
    If Strings[184] + Strings[185] = '' then
      Strings[184] := 'X';
    If Strings[184] > '' then
    begin
      If OptRec.Capitalization = 'ProperCase' then
      begin
        Strings[2] := ConvertToProper(Strings[2]);
        Strings[5] := ConvertToProper(Strings[5]);
        Strings[57] := ConvertToProper(Strings[57]);
        Strings[8] := ConvertToProper(Strings[8]);
        Strings[6] := ConvertToProper(Strings[6]);
        Strings[22] := ConvertToProper(Strings[22]);
        Strings[68] := ConvertToProper(Strings[68]);
        Strings[10] := ConvertToProper(Strings[10]);
        Strings[20] := ConvertToProper(Strings[20]);
        Strings[45] := ConvertToProper(Strings[45]);
        Strings[33] := ConvertToProper(Strings[33]);
        Strings[80] := ConvertToProper(Strings[80]);
      end
      else If OptRec.Capitalization = 'UpperCase' then
      begin
        Strings[2] := UpperCase(Strings[2]);
        Strings[5] := UpperCase(Strings[5]);
        Strings[57] := UpperCase(Strings[57]);
        Strings[8] := UpperCase(Strings[8]);
        Strings[6] := UpperCase(Strings[6]);
        Strings[22] := UpperCase(Strings[22]);
        Strings[68] := UpperCase(Strings[68]);
        Strings[10] := UpperCase(Strings[10]);
        Strings[20] := UpperCase(Strings[20]);
        Strings[45] := UpperCase(Strings[45]);
        Strings[33] := UpperCase(Strings[33]);
        Strings[80] := UpperCase(Strings[80]);
      end;
    end; // capitalization

   //jz//20250319 - adjust with if else and move the copy to IsFirstTimeFiler elms after uppercase or propercase of name so it is same formating
   if IsFirstTimeFiler(retNo) then //20240223
   begin
    Strings[233]:=Strings[2]; //jz//20250319 //If Strings[233]='' //should not have an if for this , should always copy over from main first name elm [2]
    If Strings[235]='' then Strings[235]:='X'; //second name, keep the if as doesnt come from anywhere else
    Strings[234]:=Strings[5]; //jz//20250319  //If Strings[234]='' then //should not have an if for this , should always copy over from main last name elm [5] If Strings[233]='' then
   end
   else
   begin
    Strings[233]:='';
    Strings[235]:='';
    Strings[234]:='';
   end;

    //20260429
   if IsSection115(RetNo)=false then Strings[249]:=''; //no province allowed her
   if Strings[249]>'' then //Section115 with income from province
   begin
    Strings[1]:=GetLongprv(strings[249]); //20260429
    Ret[RetNo].Province:=strings[249];
   end;

       {
       if FetchElm(RetNo,FNo,139)>'' then   //first time filer  //20240107
       Begin

       ss := Strings[2];
       ss := Strings[233];
        Strings[233]:=Strings[2]; //jz//20250319 //If Strings[233]='' //should not have an if for this , should always copy over from main first name elm [2]
        If Strings[235]='' then Strings[235]:='X'; //second name, keep the if as doesnt come from anywhere else
        Strings[234]:=Strings[5]; //jz//20250319  //If Strings[234]='' then //should not have an if for this , should always copy over from main last name elm [5] If Strings[233]='' then
       End;
       if IsFirstTimeFiler(retNo) = false then //20240223
       Begin
        Strings[233]:='';
        Strings[235]:='';
        Strings[234]:='';
       End;
       }

  SetGroupBoxVisibility('OtherResidencyTypesGroup', Strings[243] = ''); //20240304 Igor
  end;
  SaveTv(RetNo, FName, FNo);
end;


procedure T1(RetNo: integer; FName: String; FNo: integer);
var
  i,S15FNo, DaysInCan: integer;
  s: string;
  TempList: TStringList;
  // InfoFNo: integer;
  T1139ReserveConv, T1139ReserveAlt, T1139Bus, T1139Prof, T1139Farm,
    T1139Fish: Real;
  SpRetNo: integer;
  x, TxblInc: Real; // 20190907
  NonResPercent:Real;
  //NonResWithEmpl:Boolean;  //jz//NonResCERT//202404 - remove var, use the function instead (or should have used var everywhere instead maybe??)
begin

  LoadTv(RetNo, FName, FNo);

  with ret[RetNo].Frm[FNo] do
  begin
    For i := 1 to 30 do  //20220522 do not include 31
    begin
      s:=FetchElmFNo(RetNo, InfoFNo, i);
      Strings[i] :=s;
      Tv[i] := vl(Strings[i]);
    end;

    if (Strings[253]>'') or (Strings[254]>'') then
      Strings[7]:='DEEMED RESIDENT'; //20260313

    For i := 32 to 36 do  //20220522 do not include 37
    begin
      Strings[i] := FetchElmFNo(RetNo, InfoFNo, i);
      Tv[i] := vl(Strings[i]);
    end;


    For i := 39 to 44 do
    begin
      Strings[i] := FetchElmFNo(RetNo, InfoFNo, i);
      Tv[i] := vl(Strings[i]);
    end;

    For i := 48 to 69 do // not 70
    begin
      Strings[i] := FetchElmFNo(RetNo, InfoFNo, i);
      Tv[i] := vl(Strings[i]);
    end;

    For i := 71 to 90 do
    begin
      Strings[i] := FetchElmFNo(RetNo, InfoFNo, i);
      Tv[i] := vl(Strings[i]);
    end;
    Strings[73]:=FetchElmFNo(RetNo, InfoFNo, 90);  //20240211  nt Taocko lands
    Strings[77]:=FetchElmFNo(RetNo, InfoFNo, 137);  //20240211

    Strings[78]:=FetchElmFNo(RetNo, InfoFNo, 39);  //mar st change  //20250101
    s:=Strings[78];
    Strings[79]:=FetchElmFNo(RetNo, InfoFNo, 40);  //mar st change  //20250101

    For i := 163 to 165 do
    begin
      Strings[i] := FetchElmFNo(RetNo, InfoFNo, i);
      Tv[i] := vl(Strings[i]);
    end;

    Tv[131] := vl(FetchElmFNo(RetNo, InfoFNo, 131));
    Tv[162] := vl(FetchElmFNo(RetNo, InfoFNo, 162));
    Strings[186] := FetchElmFNo(RetNo, InfoFNo, 186);
    Strings[61] := ret[RetNo].Province; // 20101210
    // form id      //20101210
    If ret[RetNo].Province = 'NL' then
      Strings[128] := '5001-R'
    else If ret[RetNo].Province = 'NS' then
      Strings[128] := '5003-R'
    else If ret[RetNo].Province = 'QC' then
      Strings[128] := '5005-R'
    else If ret[RetNo].Province = 'ON' then
      Strings[128] := '5006-R'
    else If ret[RetNo].Province = 'SK' then
      Strings[128] := '5008-R'
    else If ret[RetNo].Province = 'BC' then
      Strings[128] := '5010-R'
    else If ret[RetNo].Province = 'YT' then
      Strings[128] := '5011-R'
    else If ret[RetNo].Province = 'NT' then
      Strings[128] := '5012-R'
    else If ret[RetNo].Province = 'ZZ' then
      Strings[128] := '5013-R'
    Else
      Strings[128] := '5000-R';
    If Strings[29] + Strings[30] = '' then
      Strings[30] := 'X';
  end;

  // page 2
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    If UpperCase(FetchElm(RetNo, 'INFO', 128)) = 'X' then
      // indian exempt flag //20191210
      Frm[FNo].Strings[70] := 'X'
    Else
      Frm[FNo].Strings[70] := '';

    If UpperCase(FetchElm(RetNo, 'INFO', 86)) = 'X' then
    begin
      Frm[FNo].Strings[201] := 'X';
      Frm[FNo].Strings[202] := '';
    end
    else
    begin
      Frm[FNo].Strings[201] := '';
      Frm[FNo].Strings[202] := 'X';
    end;

    //20240428B
    If FetchElmFNo(RetNo,InfoFNo,246)>'' then //select othe Factual
    Begin
     Frm[FNo].Strings[504]:= FetchElmFNo(RetNo,InfoFNo,246);
     Frm[FNo].Strings[501]:= '';
     Frm[FNo].Strings[502]:= '';
     Frm[FNo].Strings[503]:= '';
    End
    Else
    Begin
     Frm[FNo].Strings[501]:= FetchElmFNo(RetNo,InfoFNo,251);
     Frm[FNo].Strings[502]:= FetchElmFNo(RetNo,InfoFNo,252);
     Frm[FNo].Strings[503]:= FetchElmFNo(RetNo,InfoFNo,253);
    End;

   //20230311
   //20250218 from John
   If (Ret[Retno].Province = 'ON')
   Or (Ret[Retno].Province = 'NU') //jz//20250216 NU not NL Or (Ret[Retno].Province = 'NL') then
   Or (Ret[Retno].Province = 'BC') //jz//20250216 add BC as well
   {  //20250218 from John
   if (Ret[Retno].Province = 'ON')
   Or (Ret[Retno].Province = 'NL')  then
   }
   then
   Begin
    if  Frm[FNo].Strings[505]+ Frm[FNo].Strings[506]='' then
    Begin
        Frm[FNo].Strings[505]:='';
        Frm[FNo].Strings[506]:='X';
    End;
   End;

    // Aborinilal residency sections  //20200222
    With ret[RetNo].Frm[FNo] do
    begin
      if ret[RetNo].Province = 'BC' then // 20200222
      Begin
        If FetchElmFNo(RetNo, InfoFNo, 202) > '' then
        begin
          Strings[517] := 'X';
          Strings[518] := '';
        end
        else
        begin
          Strings[517] := '';
          Strings[518] := '';
        end;
        If FetchElmFNo(RetNo, InfoFNo, 204) > '' then
        begin
          Strings[519] := 'X';
          Strings[520] := '';
        end
        else
        begin
          Strings[519] := '';
          Strings[520] := '';
        end;
      End;

      if ret[RetNo].Province = 'NL' then // 20200222
      Begin
        If FetchElmFNo(RetNo, InfoFNo, 127) > '' then
        begin
          Strings[521] := 'X';
          Strings[522] := '';
        end
        else
        begin
          Strings[521] := '';
          Strings[522] := '';
        end;
        If FetchElmFNo(RetNo, InfoFNo, 204) > '' then
        begin
          Strings[519] := 'X';
          Strings[520] := '';
        end
        else
        begin
          Strings[519] := '';
          Strings[520] := '';
        end;
      End;

      if ret[RetNo].Province = 'NT' then // 20200222
      Begin
        If FetchElmFNo(RetNo, InfoFNo, 90) > '' then
        begin
          Strings[505] := 'X';
          Strings[506] := '';
        end
        else
        begin
          Strings[505] := '';
          Strings[506] := '';
        end;
        If FetchElmFNo(RetNo, InfoFNo, 268) > '' then
        begin
          Strings[507] := 'X';
          Strings[508] := '';
        end
        else
        begin
          Strings[507] := '';
          Strings[508] := '';
        end;
        If FetchElmFNo(RetNo, InfoFNo, 273) > '' then
        begin
          Strings[509] := 'X';
          Strings[510] := '';
        end
        else
        begin
          Strings[509] := '';
          Strings[510] := '';
        end;
      End;

      if ret[RetNo].Province = 'YT' then // 20200222
      Begin
        If FetchElmFNo(RetNo, InfoFNo, 132) > '' then
        begin
          Strings[511] := 'X';
          Strings[512] := '';
        end
        else
        begin
          Strings[511] := '';
          Strings[512] := '';
        end;
        If FetchElmFNo(RetNo, InfoFNo, 41) > '' then
        begin
          Strings[513] := FetchElmFNo(RetNo, InfoFNo, 41);
          Strings[514] := FetchElmFNo(RetNo, InfoFNo, 42);
        end
        else
        begin
          Strings[513] := '';
          Strings[514] := '';
        end;
        If FetchElmFNo(RetNo, InfoFNo, 23) > '' then
        begin
          Strings[515] := 'X';
          Strings[516] := '';
        end
        else
        begin
          Strings[515] := '';
          Strings[516] := '';
        end;
      End;

      if ret[RetNo].Province = 'ZZ' then // 202203m1
      Begin
       Strings[524]:=FetchElm(RetNo,'INFO',69);
       Strings[501]:=FetchElm(RetNo,'INFO',81);
       Strings[502]:=FetchElm(RetNo,'INFO',82);
       Strings[503]:=FetchElm(RetNo,'INFO',83);
       Strings[504]:=FetchElm(RetNo,'INFO',84);
      End;


      //CMA CI indicator //20240404 climate change
     // Frm[FNo].Strings[198]:= FetchElmFNo(RetNo,InfoFNo,198); //2026f212 cz

    end; // with

    Lnn[10100] := calcLnn10100(RetNo); //jz//20260202 - make as a function (in trimStr)
    xx := Lnn[10100];

    // 20131215
    Lnn[10105] := TotMultiple(RetNo, 'T4', 47); // 20191216

    Lnn[10120] := T4Commissions;
    // 20111114
    Lnn[10400] := vl(FetchElm(RetNo, 'OTHEMPL', 16));
    // 20120411 + Vl(FetchElm(RetNo,'RC268',7));
    // Lnn[10400] := Vl(FetchElm(RetNo,'OTHEMPL',16));

    Lnn[11300] := TotMultiple(RetNo, 'T4AOAS', 2) + T4APOAS;

    Lnn[11400] := T4APCppBnf; // 20190218

    Lnn[11410] := T4APDisabBnf;

    T4RIFProcess(RetNo, T4RIFOthInc, T4RIFPens, T4RIFTax, T4RifAnnuity,
      T4RIFSpBox16, T4RIFSpBox20, T4RIFSpBox24);

    // pension
    Lnn[11500] := CalcLn115(RetNo);
    Lnn[11600] := 0;
    If UpperCase(FetchElm(RetNo, 'T1032', 34)) = 'Y' then
    begin
      If GetSinNo(RetNo) = GetPensionerSinNo(RetNo) then
        Lnn[11600] := 0
      else
        Lnn[11600] := vl(FetchElm(RetNo, 'T1032', 17));
    end
    else
      Lnn[11600] := 0;

    // uccb  //20230125
    Tv[238]:=0;
    Tv[32]:=0;

    If FetchElm(RetNo, 'RC62#1', 7) > '' then
    begin
      Tv[32] := TotMultiple(RetNo, 'RC62', 22);
      Tv[238] := 0;
    end
    else
    begin
     // Tv[32] := 0;
      If FetchElm(RetNo, 'RC62#1', 1) > '' then
        Tv[238] := TotMultiple(RetNo, 'RC62', 22)
      else
        Tv[32]:=0; //Tv[238] := 0;  //20230125
    end;

    Tv[242] := vl(FetchElm(RetNo, 'OTHINC', 33)); // 20131215
    Lnn[10130] := Tv[242]; // 20130922
    Lnn[11700] := Tv[238];
    Lnn[11701] := Tv[32];

    Lnn[11900] := MaxR(0, TotMultiple(RetNo, 'T4E', 2) - TotMultiple(RetNo,
      'T4E', 14));

    // if Ret[RetNo].Province <> 'QC' then Tv[259]:=0;  //20191214  //20200221

    Tv[259] := TotMultiple(RetNo, 'T4E', 20); // 20200301
    If Tv[259] > Tv[210] then
      Tv[259] := Tv[210]; // 20200222
    Lnn[11905] := Tv[259]; // /20191214

    Lnn[12000] := vl(FetchElm(RetNo, 'S4', 17));
    Lnn[12500] := TotMultiple(RetNo, 'T4A', 56);
    Lnn[12010] := vl(FetchElm(RetNo, 'S4', 66));
    // MaxR(0,Lnn[12000]-GetEligibleDividends(RetNo));
    Lnn[12100] := vl(FetchElm(RetNo, 'S4', 42));
    Lnn[12200] := vl(FetchElm(RetNo, 'OTHINC', 30));
    // Vl(FetchElm(RetNo,'S4',47)); //20130126
    Lnn[12599] := TotMultiple(RetNo, 'T776', 56);
    Lnn[12600] := TotMultiple(RetNo, 'T776', 106);

    // 20110814
    Lnn[12700] :=MaxR(0, vl(FetchElm(RetNo, 'S3', 339))); //20250514 //92401209 //MaxR(0, vl(FetchElm(RetNo, 'S3', 97)));
    If IsDeceased(RetNo) then //
    Begin
      //20250514
      xx:=vl(FetchElm(RetNo, 'DEATH', 11));
      if xx>0 then Lnn[12700] := xx; //vl(FetchElm(RetNo, 'DEATH', 11)); // 20150316
    end;
    //else Lnn[12700] :=MaxR(0, vl(FetchElm(RetNo, 'S3', 339))); //292401209 //MaxR(0, vl(FetchElm(RetNo, 'S3', 97)));
   // LNN[12701]:=Vl(FetchElm(RetNo,'S3',353)); //20241211  //20250422  deleted

    Lnn[12800] := vl(FetchElm(RetNo, 'DIRECT', 1));
    Lnn[12900] := vl(FetchElm(RetNo, 'RRSP', 74)) +
      vl(FetchElm(RetNo, 'RRSP', 77)) + T4RspIncome +
      vl(FetchElm(RetNo, 'T2205', 16));

   //===============
    //20231209
    Lnn[12905] := TotMultiple(RetNo,'T4FHSA',4)+TotMultiple(RetNo,'T4FHSA',6); //20231215
    Tv[46]:=LNN[12905];

    Lnn[12906] := TotMultiple(RetNo,'T4FHSA',5)+TotMultiple(RetNo,'T4FHSA',7);
    Tv[47]:=LNN[12906];
    //===============


    Lnn[13000] := vl(FetchElm(RetNo, 'OTHINC', 25));
    Lnn[13010] := TotMultiple(RetNo, 'T4A', 47); // 20191124

    { all Self Empl lines }
    TotT1139(RetNo, T1139ReserveConv, T1139ReserveAlt, T1139Bus, T1139Prof,
      T1139Farm, T1139Fish);
    // 20190709 Igor >>>
    { i := 135;
      repeat
      Lnn[i] := 0;
      i := i + 2;
      until i > 143; }
    Lnn[13500] := 0;
    Lnn[13700] := 0;
    Lnn[13900] := 0;
    Lnn[14100] := 0;
    Lnn[14300] := 0;
    { i := 162;
      repeat
      Lnn[i] := 0;
      i := i + 2;
      until i > 170; }
    Lnn[13499] := 0;
    Lnn[13699] := 0;
    Lnn[13899] := 0;
    Lnn[14099] := 0;
    Lnn[14299] := 0;
    // 20190709 Igor <<<

    TotT2125(RetNo);
    { T1139 }
    If T1139Bus <> 0 then
      Lnn[13500] := T1139Bus;

    If T1139Prof <> 0 then
      Lnn[13700] := T1139Prof;
    { Farming }

    Lnn[14099] := TotMultiple(RetNo, 'T2042', 66) + TotMultiple(RetNo, 'T1163',
      352) + TotMultiple(RetNo, 'T1273', 352);

    Lnn[14100] := TotMultiple(RetNo, 'T2042', 148) + TotMultiple(RetNo, 'T1163',
      616) + TotMultiple(RetNo, 'T1273', 616);

    // 20190516
    if (UpperCase(FetchElm(RetNo, 'BUSSUM', 162)) = 'Y') and
      (vl(FetchElm(RetNo, 'BUSSUM', 163)) > 0) then
    begin
      Lnn[14100] := vl(FetchElm(RetNo, 'BUSSUM', 168));
    end;

    If T1139Farm <> 0 then
      Lnn[14100] := T1139Farm;

    { Fishing }
    Lnn[14299] := TotMultiple(RetNo, 'T2121', 35);
    Lnn[14300] := TotMultiple(RetNo, 'T2121', 74);
    If T1139Fish <> 0 then
      Lnn[14300] := T1139Fish;
    Lnn[12799] := vl(FetchElm(RetNo, 'DIRECT', 7));
    Lnn[14400] := TotMultiple(RetNo, 'T5007', 2); { T5007/10 }
    Lnn[14500] := TotMultiple(RetNo, 'T5007', 3); { T5007/11 }
    Lnn[14600] := TotMultiple(RetNo, 'T4AOAS', 4);
    Lnn[14700] := Lnn[14400] + Lnn[14500] + Lnn[14600]; // lnn[14700
    Lnn[15000] := CalcLn15000(RetNo);
    { move amounts to form }
    Tv[203] := Lnn[10100];
    Tv[260] := Lnn[10105]; // 20191216
    Tv[204] := Lnn[10120];
    Tv[205] := Lnn[10400];
    Tv[206] := Lnn[11300];
    Tv[207] := Lnn[11400];
    Tv[208] := Lnn[11410];
    Tv[209] := Lnn[11500];
    Tv[240] := Lnn[11600];
    Tv[238] := Lnn[11700];

   // Tv[32] := Lnn[11701];  //20230125

    Tv[210] := Lnn[11900];
    Tv[211] := Lnn[12000];
    Tv[239] := Lnn[12010];
    Tv[212] := Lnn[12100];
    Tv[213] := Lnn[12200];
    Tv[241] := Lnn[12500];
    Tv[214] := Lnn[12599];
    Tv[215] := Lnn[12600];
    Tv[216] := Lnn[12700];
    Tv[217] := Lnn[12800];
    Tv[237] := Lnn[12799];
    Tv[218] := Lnn[12900];
    Tv[220] := Lnn[13000];
    Tv[40] := Lnn[13010];
    Tv[221] := Lnn[13499];
    Tv[222] := Lnn[13500];
    Tv[223] := Lnn[13699];
    Tv[224] := Lnn[13700];
    Tv[225] := Lnn[13899];
    Tv[226] := Lnn[13900];
    Tv[227] := Lnn[14099];
    Tv[228] := Lnn[14100];
    Tv[229] := Lnn[14299];
    Tv[230] := Lnn[14300];
    Tv[231] := Lnn[14400];
    Tv[232] := Lnn[14500];
    Tv[233] := Lnn[14600];
    Tv[234] := Lnn[14700];
    Tv[235] := Lnn[14700];
    //20211113
    //Tv[236] := Lnn[15000]; //see below
    Tv[531]:=0; //LNN[12701];  //20241211  //20250422  deleted  zero it out
    Tv[532]:=Tv[216]-Tv[531]; //20241220
    Tv[533]:=Tv[532];

    Tv[23]:=Tv[203]+Tv[205]+Tv[206]+Tv[207]+Tv[209]+Tv[240]
            +Tv[238]+Tv[210]+Tv[211]+Tv[212]+Tv[213]+Tv[241]
             +Tv[215]       //+Tv[216]
             +Tv[533]    ////20241211
             +Tv[217]+Tv[218]+Tv[220]
            +Tv[46]+Tv[47]    //20231209
            +Tv[40]; //20220224 added 216
    Tv[31]:=Tv[222]+Tv[224]+Tv[226]+Tv[228]+Tv[230];
    Tv[37]:=Tv[31];
    Tv[39]:=Tv[23]+Tv[37];
    Tv[236] := Tv[39]+Tv[235]; //Lnn[15000];
  end;

  // page 4
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    { ni section }
    Lnn[20600] := T4PAdj + T4APAdj + vl(FetchElm(RetNo, 'RC268', 16)) +
      vl(FetchElm(RetNo, 'RC267', 7)) + vl(FetchElm(RetNo, 'RC269', 21));

    // 20091204
    Lnn[20810] := vl(FetchElm(RetNo, 'RRSP', 101)); // 20130822

    Lnn[20700] := vl(FetchElm(RetNo, 'RPP', 28)) +
                  vl(FetchElm(RetNo, 'RC268', 7)) + vl(FetchElm(RetNo, 'RC267', 3)) +
                  vl(FetchElm(RetNo, 'RC269', 17));

    Lnn[20800] := vl(FetchElm(RetNo, 'S7', 9));

    Lnn[20805] := vl(FetchElm(RetNo, 'S15',21)); //20240604  //,vl(FetchElm(RetNo, 'S15',23)));//20231207
   // Lnn[20805] := MaxR(vl(FetchElm(RetNo, 'S15',21)),vl(FetchElm(RetNo, 'S15',23)));//20231207
    Tv[33]:=Lnn[20805]; //20231209

    Lnn[21000] := 0;
    If UpperCase(FetchElm(RetNo, 'T1032', 34)) = 'Y' then
    begin
      // dealing with pensiorer return
      If GetSinNo(RetNo) = GetPensionerSinNo(RetNo) then
        // If RetNo=GetPensionerRetNo(RetNo) then
        // If GetSinNo(RetNo) =FetchElm(RetNo,'T1032',4) then
        Lnn[21000] := vl(FetchElm(RetNo, 'T1032', 17))
    end
    Else
      Lnn[21000] := 0;

    Lnn[21300] := TotMultiple(RetNo, 'RC62', 3);
  //  Lnn[21698] := Vl(???
    { ln 212 : union, 214:ch care,215:attend care }
    { 208 RRSP done in S7 }
    { 212 DONE IN union }
    Lnn[22700] := vl(FetchElm(RetNo, 'ABIL', 46)); // 20191126

   // Lnn[21698] := vl(FetchElm(RetNo, 'ABIL', 58));//20250420//Lnn[21698] := vl(FetchElm(RetNo, 'ABIL', 52)); //jz//20250402
    Lnn[21699] := vl(FetchElm(RetNo, 'ABIL', 66)); //20251209//vl(FetchElm(RetNo, 'ABIL', 61));//20250420

    Lnn[21700] := vl(FetchElm(RetNo, 'ABIL', 57));
    Lnn[21900] := TotMultiple(RetNo, 'T1M', 128);
    Lnn[21999] := vl(FetchElm(RetNo, 'DIRECT', 8));

    Lnn[23100] := vl(FetchElm(RetNo, 'T1223', 120));
    Lnn[22000] := vl(FetchElm(RetNo, 'DIRECT', 2));
    Lnn[22100] := vl(FetchElm(RetNo, 'S4', 61));

    //Lnn[22200] := vl(FetchElm(RetNo, 'S8', 204)); //202501220 //jz//20250326 - Lnn22200  should not get set here, what about the other lnns??

    Lnn[22300] := vl(FetchElm(RetNo, 'S10', 27));
    Lnn[22400] := vl(FetchElm(RetNo, 'T1229', 66));
    Lnn[22900] := vl(FetchElm(RetNo, 'OTHDED', 41));

    Lnn[23200] := vl(FetchElm(RetNo, 'OTHDED', 21));
   // Lnn[23210] := TotMultiple(RetNo,'T4A',98)+ToTmultiple(RetNo,'T4E',22);  //20230303   //20211113
    Lnn[23300] := CalcLn23300(RetNo);

    //Lnn[23400] := MaxR(0, Lnn[15000] - Lnn[23300]);
    //{ ln 235 :soc repay }
    //Lnn[23600] := Lnn[23400] - Lnn[23500]; //20241208 //MaxR(0, Lnn[23400] - Lnn[23500]);

    //jz//20250221 <<
    Lnn[23400] := Lnn[15000] - Lnn[23300]; //allow to show negative as per form instruction line 56 box 23400 //MaxR(0, Lnn[15000] - Lnn[23300]);     { ln 235 :soc repay }
    Lnn[23600] := Lnn[23400] - Lnn[23500];
    if Lnn[23600] < 0 then
    begin
      is23600Negative := true;                //would it be helpful to have an indicator?
      Lnn23600NegativeAmount := Lnn[23600];   //catpure negative value to use where applicable
      Lnn[23600] := 0;                        //jz//20250221 make 0 as still does not allow negative as per form instruction line 58 box 23600
    end
    else
    begin
      is23600Negative := false;
      Lnn23600NegativeAmount := 0;
    end;
    //jz//20250221 >>




    { Calc TxblInc }
    Lnn[24400] := TotMultiple(RetNo, 'T4', 24);
    Lnn[24900] := vl(FetchElm(RetNo, 'OTHDED', 51));

    //Lnn[24901]:= Tv[535]; //20250215
    xx:=Lnn[24901];
    xx:=Tv[535];

    If UpperCase(Frm[FNo].Strings[340]) = 'Y' then
      Lnn[25000] := Tv[341];

    Lnn[25100] := vl(FetchElm(RetNo, 'CFR', 75));
    // Vl(FetchElm(RetNo,'DIRECT',6));
    Lnn[25200] := GetTotPrevYrsLossApplied(RetNo);

    If IsDeceased(RetNo) then
      Lnn[25300] := vl(FetchElm(RetNo, 'DEATH', 28))
    else
      Lnn[25300] := vl(FetchElm(RetNo, 'CFR', 432));

    If Bankrupt = 2 then { post-bankrpt }
    begin
      Lnn[25100] := 0;
      Lnn[25200] := 0;
      Lnn[25300] := 0;
    end;
    If Bankrupt = 3 then { trustee }
    begin
      // Lnn[248] := 0; //20181109
      Lnn[25000] := 0;
      Lnn[25500] := 0;
      Lnn[25600] := 0;
    end;

    Lnn[25395] := TotMultiple(RetNo, 'T2048', 18); //jz/20250128 - T2048 is a multi instance form //vl(FetchElm(RetNo, 'T2048', 18));

    { 254 in sch }
    //Lnn[25400] := vl(FetchElm(RetNo, 'T657', 11)); //not  221)); //2260203
    Lnn[25400] := vl(FetchElm(RetNo, 'T657', 221)); //no, why not 221, change for now, REVISIT)); ??? //jz//20260111

    { 255 in sch }
    { 256 in sch }
    Lnn[25700] := CalcLn257(RetNo); // 20191126
   // Lnn[26000] := Lnn[23600] - Lnn[25700];  //20241211
    { move amounts to form }
    { ------ }
    Tv[301] := Tv[236]; //Lnn[15000];  //20241221
    Tv[302] := Lnn[20600];
    Tv[303] := Lnn[20700];
    Tv[345] := Lnn[20810]; // 20130822
    Tv[304] := Lnn[20800];
    Tv[343] := Lnn[21000];
    Tv[306] := Lnn[21200];
    Tv[344] := Lnn[21300];
    Tv[307] := Lnn[21400];
    Tv[308] := Lnn[21500];

   // Tv[534] := Lnn[21698]; //jz//20250402
    Tv[309] := Lnn[21699];

    Tv[310] := Lnn[21700];
    Tv[311] := Lnn[21900];
    Tv[323] := Lnn[21999];
    Tv[312] := Lnn[22000];
    Tv[337] := Lnn[22200];  //20250117
    Tv[313] := Lnn[22100];
    Tv[56] :=  Lnn[22215]; // 20191118
    Tv[314] := Lnn[22400];
    Tv[315] := Lnn[22900];
    Tv[324] := Lnn[23100];
    Tv[317] := Lnn[23200];
  //  Tv[57]  := Lnn[23210];  //20211113    //20231124 OUT
    Tv[318] := Lnn[23300];
    Tv[319] := Lnn[23300]; //20241221
    Tv[320] := Tv[301]-Tv[319]; //Lnn[23400]; //20241221
    Tv[321] := Lnn[23500];

    //Tv[322] := Tv[320]-Tv[321]; //20250221 //MaxR(0,Tv[320]-Tv[321]); //Lnn[23600];  //20241221
    Tv[322] := Lnn[23600]; //jz//20250221 //MaxR(0,Tv[320]-Tv[321]); //Lnn[23600];  //20241221

    Tv[261] := Tv[322]; //Lnn[23600]; // 20241221
    { ------ }
    // Tv[325] := Lnn[248];  //20181109
    Tv[336] := Lnn[24400];  //20241211
    Tv[326] := Lnn[24900];

    //Lnn[24901]:=Tv[535]; //20250215
    Tv[535] := Lnn[24901]; //jz//20250315
    xx:=Lnn[24901];
    xx:=Tv[535];


    Tv[327] := Lnn[25000];
    Tv[328] := Lnn[25100];
    Tv[329] := Lnn[25200];
    Tv[330] := Lnn[25300];

    Tv[536] := Lnn[25395]; //jz//20250402

    Tv[331] := Lnn[25400];
    Tv[332] := Lnn[25500];
    Tv[333] := Lnn[25600];

    Tv[334] := Lnn[25700]; // 20191126
    Tv[335] := Lnn[25700];

    //jz//20260215 - lines removed
    //Tv[537] := Tv[261]-Tv[335];  //20241211
    //Tv[538] := 0;  //Lnn[2599]; //20250409   //20250421
    Lnn[25999]:=0; //20250409     //jz//20260215 - also removed but leave so to clear anything that might be there

    Tv[339] := MaxR(0,Tv[261]-Tv[335]); //jz//20260215 - updated as Tv[537],Tv[538] removed  //MaxR(0,Tv[537]-Tv[538]);  //20250221

    //Tv[336] := Lnn[24400]; moved above
    //Tv[339] := Tv[537]-TV[538]; //20241211 //20250221
    Tv[51] := Lnn[22300]; // 20191127
    Lnn[26000]:=Tv[339];

    If Lnn[23200] > 0 then
      Frm[FNo].Strings[338] := 'See Other Deductions schedule'
    else
      Frm[FNo].Strings[338] := '';

    If Lnn[25600] > 0 then
      Frm[FNo].Strings[316] := 'See Other Deductions schedule'
    else
      Frm[FNo].Strings[316] := '';
  end;


  // 20190006 =====NONRES====================================================================
  // Step 5  Used to be S1

  NonResPercent:=GetNonResPercent(RetNo);

  {
  //jz//NonResCERT//202404 - use function instead (altho maybe better to have used var?)
  With ret[RetNo] do
  Begin
    if FetchElm(RetNo, 'INFO', 276) > '' then
      NonResWithEmpl := True
    else
      NonResWithEmpl := False;
  end;
  }

  // ===========   NON REFUNDABLE TAX CREDITS ==========================
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    NonResPercent:=GetNonResPercent(RetNo); //extra //20240423
    LN30000(RetNo, 'LN30000', Ln30000FNo);
    xx:=ret[RetNo].PartYear;  //20240423
    if isSection217(RetNo) then ret[RetNo].PartYear:=1; //202404278

    Lnn[30000] := ret[RetNo].Lnn[30000] * ret[RetNo].PartYear;
    //20250118
    Tv[106]:=Lnn[31000];  //LNN done in S8

    Frm[FNo].Strings[63] := WhichTaxForm(RetNo, ret[RetNo].Province);
    // 20090411
    Tv[88] := MaxR(0, ret[RetNo].Lnn[26000]);

   // If IsSection216(RetNo) then Tv[88] := vl(FetchElm(RetNo, 'T1159', 37)); //20240430

    If IsSection217(RetNo) then      //20220412
    Begin
     If ret[RetNo].Lnn[26000]>=vl(FetchElm(RetNo, 'SNRESA', 18)) then
      Tv[88]:=ret[RetNo].Lnn[26000]
     Else
      Tv[88]:=vl(FetchElm(RetNo, 'SNRESA', 18));
    end;

    TxblInc := Tv[88]; // 20141119

    CalcFedTaxByBrackets(RetNo, FNo, TxblInc, 0); // 20141118   //index 0

    // 20171209
    Lnn[30100] := vl(FetchElm(RetNo, 'AGEDED', 8));
    
    //if NonResWithEmpl=True then Begin if NonResPercent<90 then Lnn[30100] := 0;end; //20220408
    if (NonResWithEmpl(RetNo)) and (NonResPercent<90) then Lnn[30100] := 0; //jz//NonResCERT//202404
    Tv[100] := CalcSpousalClaim(RetNo, SpouseIncome(RetNo));
    Lnn[30300] := Tv[100];
    if (NonResWithEmpl(RetNo)) and (NonResPercent<90) then Lnn[30300] := 0; //jz//NonResCERT//202404 if NonResWithEmpl=True then Begin if NonResPercent<90 then Lnn[30300] := 0;end; //20220408
    Tv[102] := vl(FetchElm(RetNo, 'S5', 21)); // 20191110
    Lnn[30400] := Tv[102]; // Tv[104];  //20191109
    if (NonResWithEmpl(RetNo)) and (NonResPercent<90) then Lnn[30400] := 0; //jz//NonResCERT//202404 if NonResWithEmpl=True then Begin if NonResPercent<90 then Lnn[30400] := 0;end; //20220408


    if Tv[109]>6000 then Tv[109]:=6000; //for line 31220   firefighter
    if Tv[110]>6000 then Tv[119]:=6000; //for line 312400  Search andRescue

    Tv[101] := vl(FetchElm(RetNo, 'S5', 63)); // 20171112  Ln 304
    Lnn[30425] := Tv[101];
    if (NonResWithEmpl(RetNo)) and (NonResPercent<90) then Lnn[30425] := 0; //jz//NonResCERT//202404 if NonResWithEmpl=True then Begin if NonResPercent<90 then Lnn[30425] := 0;end; //20220408

    Frm[FNo].Strings[83] := FetchElm(RetNo, 'DEPEND', 54);
    Tv[104] := MyStrToInt(Frm[FNo].Strings[83]) * (Constant[RY].FCAAmount) * PartYear; // 20150905

    if (IsMultjurisdiction(Retno)) and (TV[104]=0) then  //maybe overriden 20240506
      Strings[83]:='';

    Lnn[30500] := Tv[104]; // Tv[104];  //20191109
    if (NonResWithEmpl(RetNo)) and (NonResPercent<90) then Lnn[30500] := 0; //jz//NonResCERT//202404 if NonResWithEmpl=True then Begin if NonResPercent<90 then Lnn[30500] := 0;end; //20220408

    // 20171112
    // Lnn[30450] :=0;
    Tv[103] := vl(FetchElm(RetNo, 'S5', 31)); // 20171112  Ln 307
    Lnn[30450] := Tv[103];
    if (NonResWithEmpl(RetNo)) and (NonResPercent<90) then Lnn[30450] := 0; //jz//NonResCERT//202404 if NonResWithEmpl=True then Begin if NonResPercent<90 then Lnn[30450] := 0;end; //20220408
    // Lnn[30450] :=0;

    { 305,306,308,310,312,314, in sch also  368, 369 in S10? }

    Tv[114] := MinR(Constant[RY].CanEmplAmount, ret[RetNo].Lnn[10100] + ret[RetNo].Lnn[10400]); // 20110405

    If IsPostBankruptcyReturn(RetNo) then
      Tv[114] := vl(FetchElm(RetNo, 'BANKRPT', 14));
    if IsNonResident(RetNo) then //20240425
    Begin
     //if (NonResWithEmpl=True) //20240517
     If (NonResPercent<90) and
        (not(IsDeemedResOther(RetNo))) and
        (not(IsDeemedResOther(RetNo))) and
        (not(IsDeemedRes183(RetNo)))        //jz//NonResCERT-R1 //202404 - add so deemed Resother also applicable (should it be all deemed canada??)
     then 
       Tv[114]:=0; ///Allow only if nonrespercent >=90
    end;
    Lnn[31260] := Tv[114];  //20240425

    If (ret[RetNo].Province = 'QC') or (IsDeemedResQuebec(RetNo)) then //jz//NonResCERT-R1 //202404
      Lnn[31205] := MinR(Constant[RY].MaxPPIP, TotMultiple(RetNo, 'T4', 44))
    else
      Lnn[31205] := 0;

    Tv[116] := vl(FetchElm(RetNo, 'HOMEBUY', 4));
    Lnn[31270] := Tv[116];
    Lnn[31350]:= MinR(0{Tv[158]}, 500); // 20210318 //20251210 Igor
    //Lnn[31350] := MinR(Tv[158], 2000); // 20201123
    Lnn[31400] := GetLn314(RetNo);
    Lnn[31215] := vl(FetchElm(RetNo, 'S10', 31)); // 20191219
    Tv[108] := Lnn[31217];

    SaveTv(RetNo, FName, FNo);  //20220603 MUST be saved, othrwise it will be lost due to StLoan
    STLOAN(RetNo, 'STLOAN', GetFormNo('STLOAN')); //20220519
    LoadTv(RetNo, FName, FNo);

    Lnn[31900] := vl(FetchElm(RetNo, 'STLOAN', 40)); // see stloak //20220520

    If ret[RetNo].Age >= 18 then
      Lnn[31600] := vl(FetchElm(RetNo, 'DISAB18', 1))
    else
      Lnn[31600] := vl(FetchElm(RetNo, 'DISAB18', 11));

    Lnn[31800] := vl(FetchElm(RetNo, 'TRANSF', 71)); //20240529 ALREADY % applied in TRANSF *  vl(FetchElm(RetNo, 'TRANSF', 69)) / 100; alrasdy
    //x:=Vl(FetchElm(RetNo,'S5',4)); If X>0 then Lnn[31800] :=x; //20231123 //20231117

    { 326 in sch }
    Lnn[33099] := vl(FetchElm(RetNo, 'MEDICAL', 112)); //20231127

    //20211113
    Tv[67]:=Lnn[23600];
    Tv[69]:=Tv[67]*3/100;
    Tv[42]:=CalcMedicalLimit(RetNo);
    Tv[48]:=MaxR(0,Tv[41]-Tv[42]);

    // ln 331 in
    Tv[48] := vl(FetchElm(RetNo, 'MEDICAL', 160)); // MaxR(0,Tv[41] - Tv[42]);
    Tv[49] := Lnn[33199];
    Tv[50] := Tv[48] + Tv[49];

    // 20190709 Igor >>>
    If Bankrupt = 3 then { trustee }
    begin
      // for i:=300 to 332 do Lnn[i] :=0;
      Lnn[30000] := 0;
      Lnn[30100] := 0;
      Lnn[30200] := 0;
      Lnn[30300] := 0;
      Lnn[30425] := 0;
      Lnn[30400] := 0;
      Lnn[30600] := 0;    //What is this? npt on T1
      Lnn[30450] := 0;

      Lnn[30800] := 0;
      Lnn[30900] := 0;
      Lnn[31000] := 0;
      Lnn[31100] := 0;
      Lnn[31200] := 0;
      Lnn[31300] := 0;
      Lnn[31400] := 0;
      //Lnn[315] := 0;
      Lnn[31600] := 0;  //in bankcruptchy section
      Lnn[31217] := 0;
      Lnn[31800] := 0;
      Lnn[31900] := 0;
      Lnn[32000] := 0;
      Lnn[32100] := 0;
      Lnn[32200] := 0;
      Lnn[32300] := 0;
      Lnn[32400] := 0;
      Lnn[32010] := 0;
      Lnn[32600] := 0;
      Lnn[32700] := 0;
      Lnn[32020] := 0;
      Lnn[32900] := 0;
      Lnn[33099] := 0;
      Lnn[33199] := 0;
      Lnn[33200] := 0;
    end;
    // 20190709 Igor <<<

    // 20131214
    If (Rc381InEffect(RetNo) = False) and (ret[RetNo].Province = 'QC') then
    begin
      Lnn[30800] := MinR(Constant[RY].MaxQpp, GetActualQPPPremiums(RetNo));
    end;


    if (FetchElm(RetNo, 'INFO', 73) > '') or
       (NonResWithEmpl(RetNo))            or
       (IsSection116(retno))                  //jz//NonResCERT-R2//20250415
    then
    Begin
      ZeroOutNonRefundableTaxCredits(retNo);
    End;

    // unconditional NO Non refundable up ti line 326 and bfrmedical //explicit command






    // 20201222
    Tv[187] := Lnn[30000] + Lnn[30100] + Lnn[30300] + Lnn[30400] + Lnn[30425] +
      Lnn[30450] + Lnn[30500];
    Tv[188] := Tv[187];

    Lnn[31220]:=Tv[109]; //20231123  Volunteer
    Lnn[31240]:=Tv[110]; //20231123  Volunteer

    //20231123
    Lnn[31300]:=TotMultiple(RetNo,'ADOPT',66);  //20231123
    Tv[117]:= LNN[31300];

    Tv[115]:=TotMultiple(RetNo,'HOMEWS',170);  //20231208
    Lnn[31285]:=Tv[115];

    Tv[58] := Lnn[30800] + Lnn[31000] + Lnn[31200] + Lnn[31217] +
      Lnn[31220] + Lnn[31240] + Lnn[31205] + Lnn[31210] + Lnn[31215] +
      Lnn[31260] + Lnn[31270] + Lnn[31285] + Lnn[31300] + Lnn[31350];
    Tv[59]:=Tv[58];
    Tv[60]:=Tv[188]+Tv[59]+LNN[31400];
    Tv[62]:=Tv[60]+Lnn[31600]+Lnn[31800];

    Lnn[32300]:=Vl(FetchElm(RetNo,'S11',1)); //20240125
    //20231122
    Tv[94]:=Vl(FetchElm(RetNo,'S11',21));
    Lnn[32300]:=Tv[94];

    //20231123
    Tv[95]:=Vl(FetchElm(RetNo,'TRANSF',3));
    if Tv[95]=0 then Tv[95]:=Vl(FetchElm(RetNo,'TRANSF',72)); //20240303
    //if Tv[95]=0 then Vl(FetchElm(RetNo,'TRANSF',72));
    Lnn[32400]:=Tv[95];
    If IsPreBankruptcyReturn(RetNo) then  //20231127 copied from above
      Lnn[32400] := Lnn[32400] * vl(FetchElm(RetNo, 'BANKRPT', 2)) / 365;

    //=============================
    Tv[65]:=Tv[62]+Lnn[31900] + Lnn[32300] + Lnn[32400] + Lnn[32600];
    //=========================

     If (FetchElm(RetNo, 'INFO', 73) > '')   // user command to zeroout the NonRef
       Or ((FetchElm(RetNo, 'INFO', 276) > '')  // NR with Empl income selection //20220301 //jz//NonResCERT//202404 - NOTE - this was checked, seemingly appropriately but zeros 33200 which cra wants for NonRes Cert ONE
       and (vl(FetchElm(RetNo, 'SNRESB', 2)) < 90))
       then  //220230424 //not 3 wivj is i.e. 0.60
     begin
       Lnn[33099] := 0;
       Tv[41] := 0;
       Tv[48] := 0;
       Lnn[33199] := 0;
       Tv[49] := 0;
       Tv[50] := 0;
       Lnn[33200] := 0;
       Tv[136] := 0;
       Lnn[34900] := 0;
       Tv[140] := 0;
     end;

    Tv[136]:=Tv[50]; //20240514
    Lnn[33200]:=Tv[136]; //20240514

    {
    If GetResidencyType(RetNo) = '6' then
    begin
    Tv[65]:=Tv[62]+Tv[93]+Tv[94]+Tv[95]+Tv[96];
    xx:=Tv[65];
           //Tv[62]+Lnn[31900] + Lnn[32300] + Lnn[32400] + Lnn[32600]; //20240515
    end;
    }



    xx := Tv[65];
    xx := LNN[33200];
    xx := GetLine51200FromRc269(RetNo);
    xx := Tv[65] + LNN[33200]+GetLine51200FromRc269(RetNo);

    //jz//20250306 - use the Tv so overrides work - this maybe a problem throughout
    Tv[137] := Tv[65] + LNN[33200] + GetLine51200FromRc269(RetNo); //jz//20260203 - change to function vl(FetchElm(RetNo, 'RC269', 51));
    Lnn[33500]  := Tv[137];

    xx := Lnn[33500];

    //20240424 adjust subtotal before madical and Donations  but remove medical
    If ShouldZeroOutNonRefLines(RetNo)=True then
    begin
     if IsSection116(retNo) then   //20240425
     begin
      Tv[137]:=Lnn[31600] +Lnn[31900] +Lnn[32300];
     end;
    end;

    Tv[138] := vl(Constant[RY].Rate1);


    //jz//20250306 - use the Tv so overrides work - this maybe a problem throughout
    Tv[139]     := Lnn[33500] * vl(Constant[RY].Rate1) / 100;
    Lnn[33800]  := Tv[139];
    Tv[80]:=vl(FetchElm(RetNo, 'LN34990', 6));  //top up //20260104
    // 20111104
    Lnn[32900] := vl(FetchElm(RetNo, 'S9', 18));
    Lnn[33300] := vl(FetchElm(RetNo, 'S9', 19));
    Lnn[33400] := vl(FetchElm(RetNo, 'S9', 20));

    Lnn[33700] := vl(FetchElm(RetNo, 'S9', 4));
    Lnn[33900] := vl(FetchElm(RetNo, 'S9', 5));
    Lnn[34000] := vl(FetchElm(RetNo, 'S9', 9));  //alloweed donations bfr optimization
    Lnn[34200] := vl(FetchElm(RetNo, 'S9', 10));
    Lnn[34210] := vl(FetchElm(RetNo, 'S9', 24));
    Lnn[32005] := vl(FetchElm(RetNo, 'S9', 12));

    Lnn[34900] := vl(FetchElm(RetNo, 'S9', 12));  //donation credit

    Calc(RetNo, 'LN34990'); //jz//20260116 - was not getting updated / calced, make sure it is
    Lnn[34990] :=vl(FetchElm(RetNo, 'LN34990', 6));  //jz//20260116 //top up //20260104
      //Lnn[34990] := Tv[80];  //20260104
      //Tv[80]     :=vl(FetchElm(RetNo, 'LN34990', 6));  //top up //20260104

    Lnn[35000] := Lnn[33800] + Lnn[34900] +Lnn[34990];  //20260104

    { move }
    If Lnn[30000]>16129 then Lnn[30000]:=16129; //15705;  //20241020 //20251115
    Tv[98] := Lnn[30000];
    Tv[99] := Lnn[30100];
    Tv[102] := Lnn[30400];
    // Tv[104] := Lnn[30400];
    Tv[105] := Lnn[30800];
    Tv[106] := Lnn[31000];

    Tv[107] := Lnn[31200];
    Lnn[31200]:= Tv[107]; //jz//NonResCERT//202404 - save back to line for override
    Tv[114] := Lnn[31260];
    Tv[111] := Lnn[31205];
    Tv[112] := Lnn[31210];
    Tv[113] := Lnn[31215];
    Tv[117] := Lnn[31300];
    //Tv[158] := Lnn[31350];  //20211113 //20251210 Igor
    Tv[118] := Lnn[31400];

    Tv[91] := Lnn[31600];
    Tv[92] := Lnn[31800];
    Tv[93] := Lnn[31900];
    Tv[94] := Lnn[32300]; { ? new combined line }
    Tv[95] := Lnn[32400];
    Tv[96] := Lnn[32600];
    Tv[41] := Lnn[33099];
    Tv[42] := CalcMedicalLimit(RetNo);  //needed ?
    Tv[136]:=Tv[50];  //20240514
    Lnn[33200] := Tv[50];
    Tv[137] := Lnn[33500];
    Tv[139] := Lnn[33800];
    Tv[140] := vl(FetchElm(RetNo, 'S9', 12)); // Lnn[34900];  //20181109
    Tv[80]  := Lnn[34990];  //20260103

    Tv[55] := Lnn[35000];

    //====================================
    //20240424 adjust subtotal before madical and Donations  but remove medical
    If ShouldZeroOutNonRefLines(RetNo)=True
    then
    begin
     Tv[65]:=Lnn[31600] +Lnn[31900] +Lnn[32300];
     Tv[136]:=Tv[50]; //Tv[65]; //skip medi; //cal  //20240514B
     ZerooutNonRefLines(RetNo);

     (*

     //=========  //20240514 ====adjust for donations =================
     if (isNonResident(RetNo))
     and (FetchElm(RetNo,'SNRESB',4)='Y')
     and (IsSection116(RetNo))
     and (NonRespercent<90)
     then      //20240501  these  fiels are not on the Efile submissionb'
     begin
      Lnn[33500]:=Tv[65]-Vl(FetchElm(RetNo,'DON',88));  //Remove donations
      Tv[136]:=Tv[50];  //20240514
      Tv[137]:=Lnn[33500]; //adjust for Donations
      Tv[139]:=Tv[137]*vl(Constant[RY].Rate1)/100;
      Lnn[33800]:=Tv[139];
      Tv[55]:=Tv[139]+Tv[140];
      Lnn[35000]:=Tv[55];
     end;
     *)
     //================================================================
    end;

    // SECOND PAGE of Step 5
    Frm[FNo].Strings[135] :=
      ReplaceChar(WhichTaxForm(RetNo, ret[RetNo].Province), '1', '2');
    Tv[150] := MaxR(MaxR(Tv[157], Tv[175]), MaxR(Tv[182], Tv[196]));
    Tv[150] := MaxR(Tv[150], Tv[252]);

    Tv[141] := vl(FetchElm(RetNo, 'T1206', 52)); // 20180216
    Tv[132] := Tv[150] + Tv[141];

    //20250505

    Tv[71]:=ret[retno].Lnn[35000];
    // xx:=Tv[71];
    //ret[retno].Lnn[35000]:=Tv[71];
    //yy:=ret[retno].Lnn[35000];

    If ShouldZeroOutNonRefLines(RetNo)=True then ZeroOutNonRefLines(RetNo);   //20240424  second time
    //20220317
    if (Province='ZZ')
    and (IsDeemedResident(RetNo)=false)  //20240325
    then
    Begin
     if Vl(FetchElm(RetNo,'SNRESB',2))<90 then //2021
     Begin
      If (IsSection217(RetNo)=True)
      then
       Tv[71]:=vl(FetchElm(RetNo, 'SNRESB', 11))
       Else
        Tv[71]:=vl(FetchElm(RetNo, 'SNRESB', 16));
      End;
    End;

    //IMPORTANT Statement below to synvronize TAXSUM, T1 and GFAMSUM ANDYRDUM  //20240501
    //IMPORTANT Maybe it could be in all CASE unconditional (Next Year)
    if (isNonResident(RetNo)) and (FetchElm(RetNo,'SNRESB',4)='Y')then Lnn[35000]:=Tv[71];  //20240501

    Tv[143] := vl(FetchElm(RetNo, 'DTC', 17));

    Tv[144]:=vl(FetchElm(RetNo, 'T691', 321));  // 20250224
    //Tv[144] := vl(FetchElm(RetNo, 'T691', 316));  // 20250220//vl(FetchElm(RetNo, 'T691', 321));

    If Bankrupt = 2 { post bankrpt }
    then
      Tv[144] := 0;
    Tv[145] := Tv[71]+ Tv[143] + Tv[144];  // + Tv[144]; 20211113
    Tv[146] := Tv[145];

    Tv[147]:=MaxR(0,Tv[132]-Tv[146]); //20220409
    //-------------------------------------
    Tv[72]:=Tv[147]; //20220410 //normal returns
    Tv[53]:=0;  //fed surtax

    //--------------------------
    If (Province='ZZ')  //20220410   //if only income from selling propertyin qc then NO fed Surtax   // Or (NonResWithEmpl=True)  //20230415
    then
    Begin
     Tv[53]:=Tv[147]*48/100;
     //20240402
     if (FetchElmFNo(RetNo,InfoFNo,252)>'')  //deemed nores
     and (FetchElmFNo(RetNo,InfoFNo,238)>'')  //sect 116 disposed property
     and (FetchElmFNo(RetNo,InfoFNo,245)>'')   //property in QC
     then Tv[53]:=0;
     //

     Tv[72]:=Tv[147]+Tv[53];  //20220409
    end;

    {//20230417
    if (NonResWithEmpl=True) then
    begin
      Tv[53]:=Tv[147]*48/100;
      Tv[72]:=Tv[147]+Tv[53];  //20220409
    end;
    }

    if IsMultJurisdiction(RetNo) =true then
    begin
     Tv[53]:=Vl(FetchElm(RetNo,'T2203',207)); //222030421
     Tv[72]:=Tv[147]+Tv[53];  //20220409
    end;

    Tv[82] := TotMultiple(RetNo, 'T2209', 18);
    if Tv[82]>Ret[RetNo].Lnn[42900] then Tv[82]:=Ret[RetNo].Lnn[42900]; //20210508

    //20220226
    //Tv[147] := MaxR(0, Tv[130] - Tv[146]); //20220301 ?????
    // if SubjectToMinTax(RetNo) then Tv[147]:=Vl(FetchElm(RetNo,'T691',208));//20200109 //20200109
    Tv[74]:=MaxR(0,Tv[72]-TV[82]);//MaxR(0,Tv[147]-TV[82]);  //202200409

    Tv[75]:= 0; //20251212 Igor //Vl(FetchElm(RetNo,'T2038',51)); //20220226
    Tv[76]:=Tv[74]+Tv[75];  //20220226
     //20220226  from below
    Tv[149]:= FedLoggingTaxCredit(RetNo, vl(FetchElm(RetNo, 'DIRECT', 10)) +
      vl(FetchElm(RetNo, 'DIRECT', 12)), vl(FetchElm(RetNo, 'DIRECT', 11)) +
      vl(FetchElm(RetNo, 'DIRECT', 13))); // both bc and QC
    //fed loggong tax credit
    Tv[52]:=MaxR(0,Tv[76]-Tv[149]); //20220226
    //Tv[52]:=Tv[76]+Tv[149]; //20220226


    //Tv[52] := MaxR(0, Tv[54] + vl(FetchElm(RetNo, 'T2038', 73)) - Tv[82] -Tv[149]);
    //Tv[52] := MaxR(0, Tv[54] + vl(FetchElm(RetNo, 'T2038', 73)) - Tv[82]);
    // 20151219
    If SubjectToMinTax(RetNo) then
      Tv[52] := MaxR(0, Tv[52]); // 20160104

    // 20130211
    Tv[119] := vl(FetchElm(RetNo, 'POLIT', 6));
    // total contr //Vl(FetchElm(RetNo,'POLIT',20));
    Tv[120] := GetFedPolCredit(RetNo, Tv[119]);
    if Tv[120]>Tv[52] then Tv[120]:=Tv[52]; //Polit credit should not be more than fed tax //20211229


    // 20130307
    Tv[121] := Ret[RetNo].LNN[41200];  //20240225
     // vl(FetchElm(RetNo, 'T2038', 143)) + vl(FetchElm(RetNo, 'T2038', 125)) + T3ITC;
    If (Bankrupt = 1) or (Bankrupt = 2) { pre and post }
    then
      Tv[121] := 0;

    Tv[122] := vl(FetchElm(RetNo, 'T5006', 151));
    Tv[123] := vl(FetchElm(RetNo, 'T5006', 157));

    {//20220226 see above
    // tv[76]
    Tv[149] := FedLoggingTaxCredit(RetNo, vl(FetchElm(RetNo, 'DIRECT', 10)) +
      vl(FetchElm(RetNo, 'DIRECT', 12)), vl(FetchElm(RetNo, 'DIRECT', 11)) +
      vl(FetchElm(RetNo, 'DIRECT', 13))); // both bc and QC
    }
    Tv[124] :=Tv[120] + Tv[121] + Tv[123]; //20211212 //Tv[149] + Tv[120] + Tv[121] + Tv[123];
    Tv[125] := MaxR(0, Tv[124]);

    //20260316
    Tv[126] := MaxR(0, Tv[52] - Tv[125]);
    If SubjectToMinTax(RetNo) then Tv[126] := MaxR(0, vl(FetchElm(RetNo, 'T691', 213)));
    {//20260316
    Tv[126] := MaxR(0, Tv[52] - Tv[125]); // /20250404
    Tv[126] := MaxR(0, Tv[126]); // -Tv[76]);  //reduce by logging  //20120113
   //jz//20250404 - MINTAX amount should go here, why removed? does the logging reduction still apply???
    If SubjectToMinTax(RetNo) then Tv[126] := MaxR(0, vl(FetchElm(RetNo, 'T691', 213)));
    }

    Tv[90] := vl(FetchElm(RetNo, 'SNRC', 107));
    If IsSection217(RetNo) = False then
      Tv[90] := 0;

    Tv[129] := MaxR(0, Tv[126] - Tv[90]);
    Tv[148] := Vl(FetchElm(RetNo,'S6',97)); //20231126 //TotMultiple(RetNo, 'RC210', 1);
    if Ret[RetNo].province='QC' then
     Tv[148] := Vl(FetchElm(RetNo,'S6QC',97)); //20231126 //TotMultiple(RetNo, 'RC210', 1);

    // what if QC??
    If IsPreBankruptcyReturn(RetNo) then Tv[148] := 0;
    // 20171207
    Tv[127] := vl(FetchElm(RetNo, 'T1172', 111)) +
      vl(FetchElm(RetNo, 'T1172', 114));
    If ret[RetNo].Province = 'QC' then
      Tv[127] := vl(FetchElm(RetNo, 'T1172', 119));
    Tv[127] := Tv[127] + TotMultiple(RetNo, 'RC359', 14); // 20121120
    Tv[127] := Tv[127] + vl(FetchElm(RetNo, 'T5006', 43)); // 20131127

    Tv[128] := MaxR(0, Tv[129] + Tv[148] + Tv[127]);   //see above tv[126] - tbv[90]
    if TOSIinEffect(RetNo) then
      Tv[128] := Tv[127] + vl(FetchElm(RetNo, 'T1206', 12));
    // 20181215 //20190224
    Lnn[40424] := Tv[141];
    Lnn[40425] := Tv[143];
    Lnn[40427] := Tv[144];
    Lnn[42900] := Tv[147];
    Lnn[41450] := Tv[90];

    Lnn[40400] := Tv[132]; //29241230
    Lnn[40500] := Tv[82];
    Lnn[40600] := Tv[52];
    Lnn[40900] := Tv[119];
    Lnn[41000] := Tv[120];
    Lnn[41200] := Tv[121];
    Lnn[41300] := Tv[122];
    Lnn[41400] := Tv[123];
    Lnn[41500] := Tv[148];
    Lnn[41600] := Tv[125];
    Lnn[41700] := Tv[126];
    Lnn[41800] := Tv[127]; // Tv[129];  //20191127
    Lnn[42000] := Tv[128]; // 20190922
  end;

  // ============================================================================
  // page 4
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    If ShowUnconvertedLastYear(RetNo) then exit;
    Lnn[42000] := Tv[128]; // Vl(FetchElm(RetNo, 'S1', 128));   //20191109
    Lnn[42200] := Lnn[23500];

    Lnn[44100] := Vl(FetchElm(RetNo,'YT432',5));  //20230510
    Lnn[43200] := Vl(FetchElm(RetNo,'YT432',12)); //20230505 //added
    //42800 Prov tax
    if (TOSIInEffect(RetNo)) and (Ret[RetNo].Province<>'ON')
    then
         Lnn[42800] :=Vl(FetchElm(RetNo,'T1206',115));  //20220109

    If iSMultJurisdiction(RetNo) then Lnn[42800]:=Vl(FetchElm(RetNo,'T2203',993));  //20220428

    Lnn[43500] := Lnn[42000] + Lnn[42100] + Lnn[42120] + Lnn[42200] + Lnn[42800];
       // +LNN[41700]+Lnn[41500]+LNN[41800]+Lnn[31000]+Lnn[42200];   //temp only

    //If ret[RetNo].Province = 'YT' then //20230505
     Lnn[43500] := Lnn[43500] + Lnn[43200];

    Lnn[43700] := GetTotalTaxDeducted(RetNo);

    If UpperCase(FetchElm(RetNo, 'T1032', 34)) = 'Y' then
    begin
      // pensioner
      If GetSinNo(RetNo) = GetPensionerSinNo(RetNo) then
        Lnn[43700] := MaxR(0, Lnn[43700] - vl(FetchElm(RetNo, 'T1032', 28)))
      else // transferee
        Lnn[43700] := Lnn[43700] + vl(FetchElm(RetNo, 'T1032', 28));
    end;

    If ret[RetNo].Province <> 'QC' then
      Lnn[43700] := Lnn[43700] + TotMultiple(RetNo, 'T4E', 11);
    { QC tax on T4E }

    { Lnn[45000] UI overp done in ln 31200 }

    Lnn[45000]:= Vl(FetchElm(RetNo,'T2204',10));  //20240517

    If Lnn[45000] < 1 then
      Lnn[45000] := 0;


    Lnn[45200] := vl(FetchElm(RetNo, 'MEDREF', 17));
    Lnn[45300] := vl(FetchElm(RetNo, 'S6', 65));
    if ret[RetNo].Province = 'QC' then
      Lnn[45300] := vl(FetchElm(RetNo, 'S6QC', 65)); // 20171205

    // 20201215
    Tv[523] := Lnn[45350]; //vl(FetchElm(RetNo, 'S11', 15)); //20230323
    // Lnn[45350]:=Tv[523];
    Lnn[45355]:=TotMultiple(RetNo,'S12',170);  //20231205
    Tv[410]:= Lnn[45355];

    Lnn[45600] := T3XII;

    Lnn[45700] := vl(FetchElm(RetNo, 'GST370', 26));  //20260301  //cz

    Lnn[47600] := vl(FetchElm(RetNo, 'DIRECT', 4));
    Tv[424] := Lnn[47600]; // 20180301

    // 20161119
    Tv[457] := vl(FetchElm(RetNo, 'SCHSUPPL', 115));
    Lnn[46800] := Tv[457]; // school supplies
    Tv[458] := MinR(1000, Tv[457] * 25 / 100);  //20211228
    Lnn[46900] := Tv[458];

    // 20201222
    Tv[455] := TotMultiple(RetNo, 'T5013', 9); // @0200214
    Lnn[47555] := Tv[455];
    Lnn[47556] := Tv[461];   //20210102

    Tv[409] := Lnn[45300];
    Tv[411] := Lnn[42000]; // 20191109
    Tv[412] := Lnn[42100];

    Tv[453] := Lnn[42120];
    Tv[413] := Lnn[42200];


    {//20230417
    //20230415
    If (Province='ZZ')
    //Or (NonResWithEmpl=True)
    then
    begin
      LNN[42800]:=0;  //NO provincial tax
      Tv[416]:=0;
    end;
    }
    Tv[416] := Lnn[42800];

    If (Province = 'YT')
    Or (Vl(FetchElm(RetNo,'T2203',77))>0)  //inc from YT  //20230505
    then
      Tv[403] := Lnn[43200]
    else
      Tv[403] := 0;
    Tv[417] := Lnn[43500];
    Lnn[43500] := Tv[417];
    Tv[415] := Lnn[43500]; // 20201222
    Tv[418] := Lnn[43700];

    { quebec }
    If UpperCase(ret[RetNo].Frm[FNo].Strings[425]) <> 'Y' then
    begin
      If (ret[RetNo].Province = 'QC') or (IsDeemedResQuebec(RetNo)) then  //jz//NonResCERT-R1 //202404 - add  IsDeemedResQuebec
        Tv[445] := XferToQuebec(RetNo) * 0.45
      else
        Tv[445] := 0;
    end;
    If Tv[445] > Tv[418] * 0.45 then
      Tv[445] := Tv[418] * 0.45;
    
    If (ret[RetNo].Province <> 'QC') and (not(IsDeemedResQuebec(RetNo))) then //jz//NonResCERT-R1 //202404 - add  IsDeemedResQuebec
      Tv[445] := 0;

    Lnn[43800] := Tv[445];
    Tv[446] := MaxR(0, Tv[418] - Tv[445]);
    Tv[447] := Tv[446];
    If (ret[RetNo].Province = 'QC') or
       (IsMultJurisdiction(RetNo) = True) or
       (IsDeemedResQuebec(RetNo)) or //jz//NonResCERT-R1 //202404 - add  IsDeemedResQuebec
       (FetchElmFNo(RetNo,InfoFNo,245)>'')   //property in QC //jz//NonResCERT-R1 //202404 - add
    then
      Tv[448] := GetQuebecAbat(RetNo, False)
    else
      Tv[448] := 0;

    //jz//NonResCERT-R1 //202404 - not sure what this is for, seems opposite, remove
    {
    //20240402
    if (FetchElmFNo(RetNo,InfoFNo,252)>'')  //deemed nores
    and (FetchElmFNo(RetNo,InfoFNo,238)>'')  //sect 116 disposed property
    and (FetchElmFNo(RetNo,InfoFNo,245)>'')   //property in QC
    then Tv[448]:=0;
}


    Lnn[43850] := Tv[447]; //Lnn[43900] := Tv[447];  //20230218
    Lnn[44000] := Tv[448];
    //If IsMultJurisdiction(RetNo) then Lnn[44000] := vl(FetchElm(RetNo, 'T2203', 212));   //jz//20260325//MJCERT2025 - this is already accounted for GetQuebecAbat above

   //========================
    //20231209
    x := GetClimateChangeAmount(RetNo, ret[RetNo].Province);
    if ret[RetNo].Province = 'NB' then x := 0; // 20191223 No climate change for NB
    Lnn[45110] := x; // 20181124
    {//20231209
    Tv[33] := GetClimateChangeAmount(RetNo, ret[RetNo].Province);
    if ret[RetNo].Province = 'NB' then Tv[33] := 0; // 20191223 No climate change for NB
    Lnn[45110] := Tv[33]; // 20181124
    }
    //========================
    If Province = 'YT' then
      Tv[404] := Lnn[44100]
    else
      Tv[404] := 0;

    If Province = 'QC' then  Lnn[44800] := 0; // 20201216

    Tv[419] := Lnn[44800];

    Tv[420] := Lnn[45000];
    If Province = 'QC' then
    begin
      Tv[450] := Lnn[31210];
      Tv[451] := MaxR(0, Tv[420] - Tv[450]);
      Tv[452] := Tv[451];
    end
    else
    begin
      Tv[450] := 0;
      Tv[451] := 0;
      Tv[452] := 0;
    end;
    Lnn[45100] := Tv[452]; // 20200103
    Tv[426] := Lnn[45200];
    Tv[421] := Lnn[45400];
    Tv[422] := Lnn[45600];
    Tv[423] := Lnn[45700];


    if IsMultJurisdiction(RetNo) then  //20240507
    begin
     //if GetSinNo(RetNo)='870002029' then Lnn[47900]:=642.50;  //test case #7
    end;

    if IsMultJurisdiction(RetNo) then  //20240508
    begin
     //if GetSinNo(RetNo)='870001476' then Lnn[47900]:=9986.74;  //Test case #6
    end;

    if IsMultJurisdiction(RetNo) then  //20240508
    begin
     // if GetSinNo(RetNo)='870000338' then 61470 =      //test case 5
    end;

    //870000338
    if IsMultJurisdiction(RetNo) then    //jz//20260325//MJCERT2025 - add back becuase seems to be neccessary //does not work
    begin
     Lnn[47900]:=
                   Vl(FetchElm(RetNo,'ON479',126))
                  //+Vl(FetchElm(RetNo,'S12NB',170))  //jz//20260325 - not sure about this form, remove for now, keep the actual prov credits
                  //+Vl(FetchElm(RetNo,'T1129',9))    //jz//20260325 - not sure about this form, remove for now
                  +Vl(FetchElm(RetNo,'PE428',86))
                  +Vl(FetchElm(RetNo,'MB479',163))
                  +Vl(FetchElm(RetNo,'SK479',15))
                  +Vl(FetchElm(RetNo,'YT479',33))     //jz//20260325 - +Vl(FetchElm(RetNo,'YT428',33))
                  +Vl(FetchElm(RetNo,'AB428',15))
                  +Vl(FetchElm(RetNo,'BC479',18))     //jz//20260325 - BC was missing
                  +Vl(FetchElm(RetNo,'NT479',32))
                  +Vl(FetchElm(RetNo,'NU479',34))
                  //+Vl(FetchElm(RetNo,'T225',109))   //jz//20260325 - not sure about this form, remove for now
                  +Vl(FetchElm(RetNo,'NL479',4));
    end;


    Tv[427] := Lnn[47900];
    //xx:=Tv[427];
    //T2043 farming  //20220414
    Lnn[47556]:=Vl(FetchElm(RetNo,'T2043',38)); //31)); //20221206
    Tv[461]:=Lnn[47556];

    Lnn[47555] := Tv[455]; // 20201222

    Lnn[47557]:=TotMultiple(RetNo,'T5013',54); //20240104
    Tv[432]:= Lnn[47557];   //20240104
   // TV[432]:= Vl(FetchElm(RetNo,'T2039',67));  //20221215
   //???? Lnn[47557] := Tv[432]; // 20221127

    {does not affet it
    //20230508 Otherwise we lose 47900 if Mult jurisdictions
    //if Ret[RetNo].Province='NL' then 870000338     //20230508
    if Ret[RetNo].Province='NS' then
    begin
     Ret[RetNo].Lnn[47900]:=Vl(FetchElm(RetNo,'NS479]',4));     //20230508
     Tv[427]:=Ret[RetNo].Lnn[47900];
    end;
    }
    {//20240104
    If GetSinNo(RetNo)='870000338' then //case Five MJ   //20230509
    Begin
      Ret[RetNo].Lnn[47900]:=100; //Vl(FetchElm(RetNo,'MB479]',163));     //20230508
      Tv[427]:=Ret[RetNo].Lnn[47900];
    End;
    }
    //20240104  and //20240506
    If GetSinNo(RetNo)='870001203' then //case ten  MJ   //20230510
    Begin
      Ret[RetNo].Lnn[47900]:=500; //Vl(FetchElm(RetNo,'MB479]',163));     //20240507  to be revised
      Tv[427]:=Ret[RetNo].Lnn[47900];
    End;

    {did not help //20240506
    //=====================
    //20240506
    if Ret[RetNo].Province='NS' then
    begin
     Ret[RetNo].Lnn[47900]:=Vl(FetchElm(RetNo,'NS479]',4));     //20230508
     //Tv[427]:=Ret[RetNo].Lnn[47900];
    end;
    // ========================
    }
    Lnn[48200] := Lnn[43850] + Lnn[44000] + Lnn[44800] //20230218 // 20190110 //Lnn[48200] := Lnn[43900] + Lnn[44000] + Lnn[44800] // 20190110
      + Lnn[45110] // 20181124
      + Lnn[45200] + Lnn[45300] + Lnn[45350] // 20201215
      + Lnn[45355]  //20231209
      + Lnn[45400] + Lnn[45600] + Lnn[45700] + Lnn[47555] // 20201222
      + Lnn[47556]  //20210102
      + Lnn[47557]  //20221127
      + Lnn[46900] + Lnn[47600] + Lnn[47900];

    If Province = 'QC' then
      Lnn[48200] := Lnn[48200] + Lnn[45100] // 20200110 add 00 to 482 and 451
    else
      Lnn[48200] := Lnn[48200] + Lnn[45000]; // 20200110 add 00 to 482 and 451
    If ret[RetNo].Province = 'YT' then
      Lnn[48200] := Lnn[48200] + Lnn[44100]; // 20200110 add 00 to 482 and 451

    Tv[428] := Lnn[48200];
    Tv[449] := Tv[428];
    Tv[429] := Lnn[43500] - Lnn[48200];
    ret[RetNo].Balance := Tv[429];
    If ret[RetNo].Balance < 0 then { refund }
    begin
      Lnn[48400] := ABS(ret[RetNo].Balance);
      Lnn[48500] := 0;
    end
    else { balance due }
    begin
      Lnn[48500] := ABS(ret[RetNo].Balance);
      Lnn[48400] := 0;
    end;

    Tv[430] := Lnn[48400];
    Tv[431] := Lnn[48500];
    Lnn[48600] := Tv[432];

    If Province = 'ON' then
    begin
      Tv[406] := Tv[430];
      If Tv[406] = 0 then
        Tv[401] := 0;
      Tv[402] := MaxR(0, Tv[406] - Tv[401]);
      Lnn[46500] := Tv[401];
      If Tv[401] > 0 then
        Lnn[46600] := Tv[402]
      else
        Lnn[46600] := 0;
    end
    else
    begin
      Tv[406] := 0;
      Tv[401] := 0;
      Tv[402] := 0;
      Lnn[46500] := 0;
      Lnn[46600] := 0;
    end;

    { cl phone }
    Frm[FNo].Strings[441] := FetchElm(RetNo, 'INFO', 54);
    Frm[FNo].Strings[442] := FetchElm(RetNo, 'INFO', 55);

    If FetchElm(RetNo, 'EFMEMO', 21) <> '1' then // not volunteer
    begin
      Frm[FNo].Strings[437] := OptRec.Prp_Name;
      Frm[FNo].Strings[438] := OptRec.Prp_Street;
      Frm[FNo].Strings[444] := OptRec.Prp_City + ', ' + OptRec.Prp_Prov + ', ' +
        OptRec.Prp_Postal;
      Frm[FNo].Strings[439] := OptRec.Prp_Area;
      Frm[FNo].Strings[440] := OptRec.Prp_Tel;
    end
    else
    begin
      Frm[FNo].Strings[437] := '';
      Frm[FNo].Strings[438] := '';
      Frm[FNo].Strings[444] := '';
      Frm[FNo].Strings[439] := '';
      Frm[FNo].Strings[440] := '';
    end;

    If IsHomeUse then
    begin
      Frm[FNo].Strings[437] := '';
      Frm[FNo].Strings[438] := '';
      Frm[FNo].Strings[444] := '';
      Frm[FNo].Strings[439] := '';
      Frm[FNo].Strings[440] := '';
    end;

    If OptRec.Prp_Dates then
      Frm[FNo].Strings[443] := DateToMonthDayYear(Date);
    Frm[FNo].Strings[454] := GetLine489EfileNo(RetNo); // 20130129
    Frm[FNo].Strings[433] := FetchElm(RetNo, 'T1DD', 2);
    Frm[FNo].Strings[434] := FetchElm(RetNo, 'T1DD', 3);
    Frm[FNo].Strings[435] := FetchElm(RetNo, 'T1DD', 4);
    If Length(OptRec.Prn_Disclm) > 0 then
      Frm[FNo].Strings[414] := OptRec.Prn_Disclm
    else
      Frm[FNo].Strings[414] := '';
    // F490 fees
    If UpperCase(Frm[FNo].Strings[407]) = 'Y' then
    begin
      Frm[FNo].Strings[407] := 'X';
      Frm[FNo].Strings[408] := '';
    end; // prv release //20181204

    // 20181204
    Frm[FNo].Strings[407] := FetchElmFNo(RetNo, InfoFNo, 100);
    Frm[FNo].Strings[408] := FetchElmFNo(RetNo, InfoFNo, 104);
    if Frm[FNo].Strings[407] + Frm[FNo].Strings[408] = '' then
    begin
      Frm[FNo].Strings[407] := 'X';
      Frm[FNo].Strings[408] := '';
    end;

    If UpperCase(Frm[FNo].Strings[407]) = '' then
    begin
      Frm[FNo].Strings[437] := '';
      Frm[FNo].Strings[438] := '';
      Frm[FNo].Strings[444] := '';
      Frm[FNo].Strings[439] := '';
      Frm[FNo].Strings[440] := '';
    end;
    // 20191211
    If FetchElmFNo(RetNo, InfoFNo, 104) > '' then
    begin
      Frm[FNo].Strings[407] := 'X';
      Frm[FNo].Strings[408] := '';
    end
    Else
    begin
      Frm[FNo].Strings[407] := '';
      Frm[FNo].Strings[408] := 'X';
    end;
  end;

  SaveTv(RetNo, FName, FNo);

end;

Procedure CalcMultiPageForm(RetNo: integer; FName: string);
Var
  i, n: integer;
  Root: string[10];
begin
  n := GetFormMxPg(FName);
  Root := ExtractFormRootName(FName);
  If Root = 'PAGE_' Then
  begin
    Calc(RetNo, FName);
    exit;
  end;
  For i := 1 to n do
    Calc(RetNo, Root + '_' + IntToStr(i) + ExtractFormInst(FName));
end;

Procedure CalcAffectedBy(RetNo: integer; FName: string);
var
  i, k, FNo: integer;
  NonInst: string[10];
  FInst: string[4];
begin
  // ShowMessage('Entering Affected routine');
  NonInst := ExtractNonInstFormName(FName);
  { following before normal affected }
  With ret[RetNo] do
  begin
    If NonInst = 'T101' then
      T101Process(RetNo, T101CEE, T101AllowCEE, T101CDE, T101AllowCDE,
        T101COGPE, T101AllowCOGPE)
    else If NonInst = 'T102' then
      T102Process(RetNo, T102CEE, T102AllowCEE, T102CDE, T102AllowCDE,
        T102COGPE, T102AllowCOGPE, T102PShipInc)

    else If NonInst = 'T4' then
    begin
      Calc(RetNo, 'T2121#1');
      Calc(RetNo, 'T1');
    end
    else If NonInst = 'T4A' then
    begin
      Calc(RetNo, 'T2125#1');
      Calc(RetNo, 'T1');
    end;
  end;
  { affected }
  FList.CalcAffectedBy(RetNo, FName); // 20160119 Igor
  // K :=11;
  // For i := 0 to AffectedList.Count - 1 do
  // begin
  // If NonInst = Rtrim(LeftStr(AffectedList[i],10)) then
  // begin
  // Finst := ExtractFormInst(FName);
  // Repeat
  // If RTrim(MidStr(AffectedList[i],k,9)) > '' then
  // begin
  // FNo := GetFormNo(RTrim(MidStr(AffectedList[i],k,9)));
  // If Fno >0 then  {effected is single}
  // Calc(RetNo,RTrim(MidStr(AffectedList[i],k,9)))
  // else
  // begin
  // Fno:=GetFormNo(RTrim(MidStr(AffectedList[i],k,9))+FInst); //20101020
  // If FNo>0 then Calc(RetNo,RTrim(MidStr(AffectedList[i],k,9))+FInst);
  // end;
  // end;
  // K := K+10;
  // until k > 111;
  // end; {matching}
  // end; {do}
  // ShowMessage('Affected routine finished');
end;

Procedure T4(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  MxEarn: Real;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    If Strings[20] = '' then
      Strings[20] := ret[RetNo].Province;
    Strings[21] := FetchElm(RetNo, 'INFO', 3);
    Strings[22] := FetchElm(RetNo, 'INFO', 5);
    Strings[23] := FetchElm(RetNo, 'INFO', 2);

    // 20160216 Igor
    // 20160204  Values below may come from Autofill as 0 or 1 so need to convert them
    If Strings[7] = '0' then
      Strings[7] := '';
    If Strings[7] = '1' then
      Strings[7] := 'X';
    If Strings[18] = '0' then
      Strings[18] := '';
    If Strings[18] = '1' then
      Strings[18] := 'X';

   // If Tv[10] > Constant[RY].MaxCppPensionable then Tv[10] := Constant[0].MaxCppPensionable; //20241120

    If (Strings[18] = '') and (UpperCase(Strings[36]) <> 'Y') then //220250205
    //If (Strings[8] = '') and (UpperCase(Strings[36]) <> 'Y') then
      Tv[9] := Tv[2]; // no eiexempt - no override
    If Tv[11] = 0 then { non st indian }
    begin
      If (Tv[2] > 0) then
      begin
        MxEarn := Constant[RY].MaxUIEarn52;

        If UpperCase(Strings[36]) <> 'Y' then // 20150331
        begin
          If Tv[9] > Tv[2] then
            Tv[9] := MinR(Tv[2], MxEarn);
        end;

      end;
    end;
    If Tv[9] > Constant[RY].MaxUIEarn52 then
      Tv[9] := Constant[RY].MaxUIEarn52;

    If UpperCase(Strings[37]) <> 'Y' then
      Tv[19] := 0;
    If UpperCase(Strings[7]) = 'X' then
      Tv[10] := 0;
    If UpperCase(Strings[18]) = 'X' then
      Tv[9] := 0;
    // 20160216 Igor
    If UpperCase(Strings[60]) = 'X' then
      Tv[43] := 0; // 20160212
    // below: coming from Autofill as false = 0
    If vl(Strings[46]) = 0 then
      Strings[46] := ''; // 20160213  empl code
    // If Vl(Strings[46)) = 1 then Strings[46]:='X';  //20160213
    If vl(Strings[60]) = 0 then
      Strings[60] := ''; // 20160213   PPIP exempt
    If vl(Strings[60]) = 1 then
      Strings[60] := 'X'; // 20160213   PPIP exempt

    For i := 2 to 6 do
      If Tv[i] < 0 then
        Tv[i] := 0;
    For i := 8 to 10 do
      If Tv[i] < 0 then
        Tv[i] := 0;
    For i := 14 to 16 do
      If Tv[i] < 0 then
        Tv[i] := 0;
    For i := 25 to 33 do
      If Tv[i] < 0 then
        Tv[i] := 0;
    If Tv[35] = 0 then
      Tv[35] := Tv[32];
  end;
  SaveTv(RetNo, FName, FNo);
end;

// 20160505 Igor
Procedure T2201(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  OtherFNo: integer;
  FInst: String;
  DepRec: TDepRec;
  DependId: String; // 20160411
begin
  FInst := ExtractFormInst(FName); // 20160611
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    // 20160411
    // If Length(Strings[36]+Strings[35])>2 then Begin Strings[36]:='';Strings[35]:='';end; //20160411
    // If Strings[36]+Strings[35]='' then Strings[36]:='X'; //20160411
    // Strings[27] := 'T2201H' + FInst; // 20160611   //20190301

   // OtherFNo := GetFormNo('T2201H' + FInst); // 20160611  //20220220

    (* 20150131
      If ((FetchElmFNo(RetNo,OtherFNo,102) = 'X')
      and
      ( FetchElmFNo(RetNo,OtherFNo,104)
      +FetchElmFNo(RetNo,OtherFNo,106)
      +FetchElmFNo(RetNo,OtherFNo,108)
      +FetchElmFNo(RetNo,OtherFNo,110)>''))
      then
      Strings[30]:='X'
      else
      Strings[30]:='';
    *)

    // 20160411
    If UpperCase(Strings[30]) = 'X' then // 20160409
    begin
      If Strings[36] > '' then
      Begin
        Strings[1] := GetFirstName(RetNo);
        Strings[2] := GetLastName(RetNo);
        Strings[4] := UpperCase(FetchElm(RetNo, 'INFO', 109));
        Strings[5] := UpperCase(FetchElm(RetNo, 'INFO', 108));
        Strings[29] := GetSinNo(RetNo);
        Strings[6] := FetchElm(RetNo, 'INFO', 6) + ' ' +
          FetchElm(RetNo, 'INFO', 22);
        Strings[7] := FetchElm(RetNo, 'INFO', 68);
        Strings[8] := FetchElm(RetNo, 'INFO', 10);
        Strings[9] := FetchElm(RetNo, 'INFO', 14);
        Strings[10] := FetchElm(RetNo, 'INFO', 15);
        Strings[11] := FetchElm(RetNo, 'INFO', 9);
      end;
    end; // 20160414

    If Strings[36] > '' then // 20160414
    begin
      If Strings[24] = '' then
        Strings[24] := FetchElm(RetNo, 'INFO', 54);
      If Strings[25] = '' then
        Strings[25] := FetchElm(RetNo, 'INFO', 55);
    end;

    If Strings[26] = '' then
      Strings[26] := GetSigningDate(RetNo);
    // FormatDateTime('yyyy-mm-dd',Date);

    // other pages
    // Strings[1]:=AppYear;
    // 20160414
    Strings[201] := Strings[1] + ' ' + Strings[2];
   // Strings[304] := Strings[201];  //20220429
    Strings[404] := Strings[201];
    Strings[512] := Strings[201];
    Strings[612] := Strings[201];
    Strings[719] := Strings[201];
    Strings[814] := Strings[201];

  end;
  SaveTv(RetNo, FName, FNo);
end;

(*
// 20160505 Igor
Procedure T2201H(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  FInst: String;
begin
  FInst := ExtractFormInst(FName); // 20160411
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := 'T2201' + FInst; // 20160411
  end;
  SaveTv(RetNo, FName, FNo);
end;
*)

Procedure OPECGB(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  MxEarn: Real;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Tv[3] := Tv[2];
    Tv[4] := Tv[3] * 1.1;
    Tv[5] := MaxR(0, Tv[1] - Tv[4]);
    Tv[7] := Tv[5] + Tv[6];
    Tv[8] := Tv[7];
    Tv[9] := MaxR(0, Tv[2] - Tv[8]);
    Tv[11] := Tv[9] * Tv[10];
    Tv[12] := MaxR(0, Tv[9] - Tv[11]);
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T4RIF(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[14] := FetchElm(RetNo, 'INFO', 3);
    Strings[9] := FetchElm(RetNo, 'INFO', 5);
    Strings[10] := FetchElm(RetNo, 'INFO', 2);
    Strings[11] := AppYear;
    // Tv[3]:=0;  //box 18 not taxable - info only
    If ShowUnconvertedLastYear(RetNo) then
      Strings[11] := GetLastYearTaxYear;
    Strings[17] := 'Jump to T2205';
  end;
  SaveTv(RetNo, FName, FNo);
  SumSlips(RetNo, 'T4RIF');
end;

Procedure T4PS(RetNo: integer; FName: String; FNo: integer);
var
  Indic: String;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    If Strings[13] = '' then
      Strings[13] := AppYear;
    If ShowUnconvertedLastYear(RetNo) then
      Strings[13] := GetLastYearTaxYear;
    Strings[12] := FetchElm(RetNo, 'INFO', 3);
    Strings[1] := FetchElm(RetNo, 'INFO', 5) + ', ' +
      FetchElm(RetNo, 'INFO', 2);
  end;
  SaveTv(RetNo, FName, FNo);
  // needed otherwise it does not work  //20121123
  Indic := FetchElm(RetNo, 'RC359#1', 21);   //220260103
  StoreElm(RetNo, GetFormNo('RC359#1'),21,Indic);  //['N'); //20260103 ???
 // StoreElm(RetNo, GetFormNo('RC359#1'), 21, 'N');
  //StoreElm(RetNo, GetFormNo('RC359#1'), 21, 'Y'); //220260103
  CreateRc359Forms(RetNo);
  CalcFullReturn(RetNo); // 20121123
  StoreElm(RetNo, GetFormNo('RC359#1'), 21, Indic);
end;

Procedure T4AP(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[9] := AppYear;
    // If ShowUnconvertedLastYear(RetNo) then Strings[9]:=GetLastYearTaxYear;
    Strings[10] := FetchElm(RetNo, 'INFO', 3);
    Strings[1] := FetchElm(RetNo, 'INFO', 5) + ', ' +
      FetchElm(RetNo, 'INFO', 2);
    Tv[4] := Tv[11] + Tv[13] + Tv[14] + Tv[15] + Tv[16] + Tv[5];
    If Tv[2] > Tv[4] then
      Tv[2] := Tv[4]; // indian diability exempt  //20121213
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T4ARCA(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[17] := AppYear;
    Strings[8] := GetSinNo(RetNo);
  end;
  SaveTv(RetNo, FName, FNo);
end;



//20250105CZ  Removed the oneby Alex
Procedure T3MULT(RetNo: integer; FName: String; FNo: integer);
Var
  ThisPercent: Real;
  i, j, Inst, k: integer;
  FInst: String[4];
  x: Real;
  ExchRate: String;
begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[4] := 'ACBFRM';
    // put slip numbers based on FInst
    Inst := MyStrToInt(AllTrim(MidStr(FInst, 2, 3)));
    k := (Inst - 1) * 5 + 1; // first slip
    i := 29;
    Repeat
      Strings[i] := '#' + IntToStr(k);
      Inc(i, 1);
      Inc(k, 1);
    until i > 33; // next column
    i := 11;
    j := 29;
    Repeat
      Strings[i] := Strings[j];
      Inc(i);
      Inc(j, 1);
    until i > 15;

    Strings[1] := FetchElm(RetNo, 'INFO', 5) + ', ' +
      FetchElm(RetNo, 'INFO', 2);
    Strings[2] := FInst;

    For k := 0 to 4 do
    begin
      // currency
      If Strings[59 + k] = '' then
      begin
        Strings[59 + k] := 'CAN';
        Strings[65 + k] := '';
      end;
      // percent
      If Tv[35 + k] > 100 then
        Tv[35 + k] := 100;
      If Tv[41 + k] > 100 then
        Tv[41 + k] := 100;
      If Tv[47 + k] > 100 then
        Tv[47 + k] := 100;
      Tv[35 + k] := MaxR(0, 100 - Tv[41 + k] - Tv[47 + k]);
      ExchRate := Strings[65 + k];
      If ExchRate = '' then
      begin
        ExchRate := '1.0';
        Strings[65 + k] := '';
      end;
      ThisPercent := Tv[35 + k];
    end;

    // ------------Init total column
    i := 76;
    Repeat
      Tv[i] := 0;
      Inc(i, 6);
    until i > 232;

    //52 to 57 //20250112
    i:=298;
    Repeat
      Tv[i] := 0;
      Inc(i, 6);
    until i > 328;

    Tv[334]:=0;  //box 58
    Tv[340]:=0;  //box 59
    //--------------------------------

    // vertical box 30 ap gains elig for deduction  //20131221
    For k := 0 to 4 do
    begin
      Tv[83 + k] := Tv[203 + k] + Tv[197 + k];
    end;

    // death benefit   box 35
    i := 137;
    Repeat
      For k := 0 to 4 do
      begin
        If UpperCase(Strings[3]) <> 'Y' then
          Tv[i + k + 6] := MinR(10000, Tv[i + k]);
        Tv[i + k + 12] := MaxR(0, Tv[i + k] - Tv[i + k + 6]);
      end;
      Inc(i, 6);
    until i > 37;

    // Foreign cap gains box 21
    i := 191;
    For k := 0 to 4 do
      If Tv[i + k] > Tv[77 + k] then
        Tv[i + k] := Tv[77 + k];
   //--------------------------------------------

    // TOTALS by row
    i := 71;  //box 50
    Repeat
      For k := 0 to 4 do
      begin
        ExchRate := Strings[65 + k];
        If ExchRate = '' then
          ExchRate := '1';
        ThisPercent := Tv[35 + k];
        Tv[i + 5] := Tv[i + 5] + Tv[i + k] * vl(ExchRate) * ThisPercent / 100;
      end;
      Inc(i, 6);
    until i > 227;

    If Tv[154] > 10000 then Tv[154] := 10000;  //death taxable amount

    i := 293;  //boxes 52 to 57
    Repeat
      For k := 0 to 4 do
      begin
        ExchRate := Strings[65 + k];
        If ExchRate = '' then ExchRate := '1';
        ThisPercent := Tv[35 + k];
        Tv[i + 5] := Tv[i + 5] + Tv[i + k] * vl(ExchRate) * ThisPercent / 100;
      end;
      Inc(i, 6);
    until i > 323;

    i := 329;  //boxes 58
    For k := 0 to 4 do
    begin
        ExchRate := Strings[65 + k];
        If ExchRate = '' then ExchRate := '1';
        ThisPercent := Tv[35 + k];
        Tv[i + 5] := Tv[i + 5] + Tv[i + k] * vl(ExchRate) * ThisPercent / 100;
    end;

    i := 335;  //boxes 59
    For k := 0 to 4 do
    begin
        ExchRate := Strings[65 + k];
        If ExchRate = '' then ExchRate := '1';
        ThisPercent := Tv[35 + k];
        Tv[i + 5] := Tv[i + 5] + Tv[i + k] * vl(ExchRate) * ThisPercent / 100;
    end;


    // completed indicator
    For i := 233 to 237 do Strings[i] := '';  //slip used

    For k := 0 to 4 do
    begin
      i := 71;
      Repeat
        If Tv[i + k] <> 0 then
          Strings[233 + k] := 'Y'; // 20160724
        Inc(i, 6);
      until i > 227;
    end;

  end;
  SaveTv(RetNo, FName, FNo);
  SumSlips(RetNo, 'T3MULT');
end;

Procedure T5(RetNo: integer; FName: String; FNo: integer);
Var
  DistribAmount: Real;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[15] := FetchElm(RetNo, 'INFO', 5) + ', ' +
      FetchElm(RetNo, 'INFO', 2);
    Strings[17] := AppYear;
    If ShowUnconvertedLastYear(RetNo) then
      Strings[17] := GetLastYearTaxYear;
    If Strings[21] = '' then
    begin
      Strings[21] := 'Canadian Dollar';
      Strings[4] := '1.0';
    end;

    If Tv[2] = 0 then
      Strings[3] := '';
    If Tv[2] > 100 then
      Tv[2] := 100;
    If Tv[2] = 100 then
    begin
      Tv[2] := 0;
      Strings[3] := '';
    end;

    DistribAmount := Tv[7] * vl(Strings[4]);
    If Tv[2] > 0 then
      DistribAmount := DistribAmount * Tv[2] / 100;
    Tv[18] := MaxR(0, DistribAmount - (Tv[19] + Tv[20]));
  end;
  SaveTv(RetNo, FName, FNo);
  SumSlips(RetNo, 'T5');
end;

Procedure T5MULT(RetNo: integer; FName: String; FNo: integer);
Var
  DistribAmount, ThisPercent: Real;
  i, j, Inst, k: integer;
  FInst: String[4];
  x: Real;
  ExchRate: String;
begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[39] := GetSinNo(RetNo); // 20200808
    // put slip numbers based on FInst
    Inst := MyStrToInt(AllTrim(MidStr(FInst, 2, 3)));
    k := (Inst - 1) * 5 + 1; // first slip
    i := 22;
    Repeat
      Strings[i] := '#' + IntToStr(k);
      Inc(i, 22);
      Inc(k, 1);
    until i > 110; // next column
    i := 136;
    j := 22;
    Repeat
      Strings[i] := Strings[j];
      Inc(i);
      Inc(j, 22);
    until i > 140;

    Strings[15] := FetchElm(RetNo, 'INFO', 5) + ', ' +
      FetchElm(RetNo, 'INFO', 2);
    Strings[17] := AppYear;
    If ShowUnconvertedLastYear(RetNo) then
      Strings[17] := GetLastYearTaxYear;
    Strings[37] := FInst;

    For k := 0 to 4 do
    begin
      // currency
      If Strings[21 + k * 22] = '' then
      begin
        Strings[21 + k * 22] := 'CAN';
        Strings[4 + k * 22] := '';
      end;
      // percent
      If Tv[2 + k * 22] > 100 then
        Tv[2 + k * 22] := 100;
      If Tv[3 + k * 22] > 100 then
        Tv[3 + k * 22] := 100;
      If Tv[81 + k * 22] > 100 then
        Tv[81 + k * 22] := 100;
      // allow ony one box for box 17 and box 19 20110507
      If Tv[180 + k * 22] > 0 then
        Tv[11 + k * 22] := 0;
      If Tv[181 + k * 22] > 0 then
        Tv[13 + k * 22] := 0;
      Tv[2 + k * 22] := MaxR(0, 100 - Tv[3 + k * 22] - Tv[81 + k * 22]);
      ExchRate := Strings[4 + k * 22];

      {//20230305
      If Strings[21 + k * 22]>'' and (Strings[21 + k * 22])<>'CAN' then
       ExchangeRate:=GetExchRate(???);  Good for T5's wor Autofilling T5 slips
      }
      If ExchRate = '' then ExchRate := '1';

      ThisPercent := Tv[2 + k * 22];
      DistribAmount := Tv[7 + k * 22] * vl(ExchRate); // 20110507
      DistribAmount := DistribAmount * ThisPercent / 100;

      Tv[18 + k * 22] :=
        MaxR(0, DistribAmount - (Tv[19 + k * 22] + Tv[20 + k * 22]));
    end;

    // Init total column
    Tv[146]:=0; //20250112
    For i := 116 to 121 do Tv[i] := 0;  //20250112
    Tv[290] := 0;
    Tv[122]:=0;
    Tv[187]:=0;
    Tv[123]:=0;
    Tv[291] := 0;
    Tv[126] := 0;
    For i := 128 to 130 do Tv[i] := 0;
    // TOTALS
    i := 141;
    Repeat
      For k := 0 to 4 do
      begin
        If Tv[i + k] <> 0 then
        begin
          ExchRate := Strings[4 + k * 22];
          If ExchRate = '' then
            ExchRate := '1';
          ThisPercent := Tv[2 + k * 22];
          Tv[146] := Tv[146] + Tv[i + k] * vl(ExchRate) * ThisPercent / 100;
        end;
      end;
      Inc(i, 1);
    until i > 141;

    i := 6;   //most lines
    Repeat
      For k := 0 to 4 do
      begin
        If Tv[i + k * 22] <> 0 then
        begin
          ExchRate := Strings[4 + k * 22];
          If ExchRate = '' then
            ExchRate := '1';
          ThisPercent := Tv[2 + k * 22];
          // If ThisPercent = 0 Then ThisPercent:=100;
          Tv[i + 22 * 5] := Tv[i + 22 * 5] + Tv[i + k * 22] * vl(ExchRate) *
            ThisPercent / 100;
        end;
      end;
      Inc(i, 1);
    until i > 13;


    i := 182;  //box34
    Repeat
      For k := 0 to 4 do
      begin
        If Tv[i + k * 1] <> 0 then
        begin
          ExchRate := Strings[4 + k * 22];
          If ExchRate = '' then ExchRate := '1';
          ThisPercent := Tv[2 + k * 22];
          Tv[i + 1 * 5] := Tv[i + 1 * 5] + Tv[i + k * 1] * vl(ExchRate) * ThisPercent / 100;
        end;
      end;
      Inc(i, 1);
    until i > 182;


    (* //2025043
     // 20250418  box34
    i:=182;
    Tv[187]:=0;  //20260423
    xx:=0;
    For k := 0 to 4 do
    begin
       ExchRate := Strings[4 + k];
       If ExchRate = '' then ExchRate := '1';
       ThisPercent := Tv[2 + k*22];
       Tv[i +  5] := Tv[i + 5] + Tv[i + k] * vl(ExchRate) * ThisPercent / 100;
    end;
    *)

    //7,8, 9 , 10, 11

    i := 180; // invention
    Repeat
      For k := 0 to 4 do
      begin
        If Tv[i + k * 22] <> 0 then
        begin
          ExchRate := Strings[4 + k * 22];
          If ExchRate = '' then ExchRate := '1';
          ThisPercent := Tv[2 + k * 22];
          // If ThisPercent = 0 Then ThisPercent:=100;
          Tv[i + 22 * 5] := Tv[i + 22 * 5] + Tv[i + k * 22] * vl(ExchRate) *
            ThisPercent / 100;
        end;
      end;
      Inc(i, 1);
    until i > 181; //180;  //20250112  do not include 192 diffrent index of k increment=1

    i := 181; // annuities-interest
    If Tv[i + k * 22] <> 0 then
    begin
       ExchRate := Strings[4 + k * 22];
       If ExchRate = '' then ExchRate := '1';
       ThisPercent := Tv[2 + k * 22];
       xx:=Tv[i + 22 * 5] + Tv[i + k * 22] * vl(ExchRate) * ThisPercent / 100;
       Tv[i + 22 * 5] := Tv[i + 22 * 5] + Tv[i + k * 22] * vl(ExchRate) * ThisPercent / 100;
    end;

    i:=16;
    For k := 0 to 4 do
    begin
       ExchRate := Strings[4 + k * 22];
       If ExchRate = '' then ExchRate := '1';
       ThisPercent := Tv[2 + k * 22];
       Tv[i + 22 * 5] := Tv[i + 22 * 5] + Tv[i + k * 22] * vl(ExchRate) * ThisPercent / 100;
    end;

    /// add distr amount
    i := 18;
    Repeat
      Tv[i + 5 * 22] := Tv[i] + Tv[i + 22] + Tv[i + 44] + Tv[i + 66] +
        Tv[i + 88];
      Inc(i, 1);
    until i > 20;

    // completed indicator //20250412
    For i := 131 to 135 do Strings[i] := ''; // 20160724
    x := AddColumns(6, 13, 1) + Tv[141] + Tv[180] + Tv[181]+Tv[12]+Tv[182];
    If x > 0 then  Strings[131] := 'Y'; // 20110507

    x := AddColumns(28, 35, 1) + Tv[142] + Tv[202] + Tv[203]+Tv[34]+Tv[183];
    If x > 0 then Strings[132] := 'Y';

    x := AddColumns(50, 57, 1) + Tv[143] + Tv[224] + Tv[225]+Tv[56]+Tv[184];
    If x > 0 then Strings[133] := 'Y';

    x := AddColumns(72, 79, 1) + Tv[144] + Tv[246] + Tv[247]+Tv[78]+Tv[185];
    If x > 0 then Strings[134] := 'Y';

    x := AddColumns(94, 101, 1) + Tv[145] + Tv[268] + Tv[269]+Tv[100]+Tv[186];
    If x > 0 then Strings[135] := 'Y';

  end;
  SaveTv(RetNo, FName, FNo);
  SumSlips(RetNo, 'T5'); // it covers T5MULT processing
end;

Procedure T5007(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[6] := FetchElm(RetNo, 'INFO', 3);
    Strings[7] := FetchElm(RetNo, 'INFO', 5);
    Strings[8] := FetchElm(RetNo, 'INFO', 2);
    Strings[5] := AppYear;
    If ShowUnconvertedLastYear(RetNo) then
      Strings[5] := GetLastYearTaxYear;
    If vl(Strings[4]) > 1 then Strings[4] := '1';
    If UpperCase(Strings[10]) <> 'Y' then
      Strings[9] := FormatFloat('###', vl(Strings[4]) * 100);
    if (Strings[4]='0') or (Strings[4]='0.00') then Strings[9]:='0.00'; //20230317

  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T5013(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    // 20140130
    If Strings[39] = '' then
      Strings[39] := AppYear;
    If Strings[38] = '' then
      Strings[38] := '12';
    Strings[8] := GetSinNo(RetNo);
    // If Strings[39]>'' then
    Strings[62] := FetchElm(RetNo, 'INFO', 5) + ', ' +
      FetchElm(RetNo, 'INFO', 2);

    Tv[64] := Tv[5] * 1.16; // 1.17; // Tv[64]:=Tv[5] * 1.18; //20180115
    // If RY=1 then  Tv[64]:=Tv[5] * 1.17;  //20160813  //20170630

    Tv[60] := Tv[61] * 1.38;
    // 20130223 1.41;  //1.44;    //20120331    //evry year

    Tv[42]:=0; //202504501

    {//20250401
    If Tv[11] = 0 then
    begin
      Tv[12] := 0;
      Tv[13] := 0;
      Tv[42] := 0;
    end;
    Tv[42] := Tv[11] - (Tv[12] + Tv[13]);

    if Tv[51]>0 then //20250328
    begin
     Tv[11]:=Tv[51]-Tv[76];  //period 2 [76] is user entry
    end
    Else
    Begin
     Tv[11]:=0;
     Tv[76]:=0;
    End;
    }

  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure FPENS(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    If AllTrim(Strings[2]) > '3' then
      Strings[2] := '3';
    If Strings[3] = '' then
      Strings[3] := '1.0';
    // 20100911
    If UpperCase(Strings[7]) = 'Y' then
    begin
      Tv[6] := Tv[4] * 0.15;
      If UpperCase(Strings[13]) = 'Y' then
        Tv[6] := Tv[4] * 0.50;
    end
    else
    begin
      Strings[7] := 'N';
      Strings[13] := 'N';
    end;
    Tv[10] := Tv[4] * vl(Strings[3]);
    Tv[11] := Tv[5] * vl(Strings[3]);
    Tv[12] := Tv[6] * vl(Strings[3]);
    Strings[8] := 'EFMEMO';
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure FECONV(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    If Strings[5] = '' then
      Strings[5] := 'Y';
    Tv[4] := Tv[3] * vl(Strings[2]);
  end;
  SaveTv(RetNo, FName, FNo);
end;

procedure T1DD(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);

  with ret[RetNo].Frm[FNo] do
  begin
    If (IsHomeUse) or (Strings[32] = '') then
    begin
      for i := 1 to 30 do
      begin
        Tv[i] := 0;
        Strings[i] := '';
      end;
      SaveTv(RetNo, FName, FNo);
      exit;
    end;
    (* keep it for the time being
      //20140127
      for i:=1 to 30 do
      begin Tv[i]:=0;Strings[i]:='';
      end;
      SaveTv(RetNo,FName,FNo);
      Exit;
    *)
    // 20101205
    If (IsPreBankruptcyReturn(RetNo)) or (IsDeceased(RetNo)) then
    begin
      for i := 1 to 30 do
      begin
        Tv[i] := 0;
        Strings[i] := '';
      end;
      SaveTv(RetNo, FName, FNo);
      exit;
    end;

    Strings[16] := GetFirstName(RetNo);
    Strings[17] := GetLastName(RetNo);
    Strings[18] := FetchElm(RetNo, 'INFO', 6);
    If FetchElm(RetNo, 'INFO', 22) > '' then
      Strings[18] := Strings[18] + ' ' + 'Apartment ' + FetchElm(RetNo, 'INFO',
        22); // 20140330
    If FetchElm(RetNo, 'INFO', 68) > '' then
      Strings[18] := Strings[18] + ' ' + 'PO box ' + FetchElm(RetNo, 'INFO',
        68); // 20140330
    If FetchElm(RetNo, 'INFO', 163) > '' then
      Strings[18] := Strings[18] + ' ' + 'RR ' + FetchElm(RetNo, 'INFO', 163);
    // 20140330

    Strings[20] := FetchElm(RetNo, 'INFO', 10);
    Strings[21] := ReplaceChar(FetchElm(RetNo, 'INFO', 15), ' ', '');
    Strings[22] := FetchElm(RetNo, 'INFO', 14);
    Strings[15] := 'X';
    Strings[23] := GetSinNo(RetNo);
    Strings[5] := ReplaceChar(GetBirthdate(RetNo), '-', '');
    Strings[4] := RemoveChar(RemoveChar(Strings[4], '-'), ' '); // 20150219
    Strings[12] := RemoveChar(Strings[12], '-');
    Strings[6] := RemoveChar(Strings[6], '-');
    If (Strings[19] > '') or (Strings[24] > '') then
      Strings[1] := GetSinNo(RetNo)
    Else
      Strings[1] := '';
    If Strings[26] = '' then
      Strings[26] := FetchElm(RetNo, 'T1', 441);
    If Strings[27] = '' then
      Strings[27] := FetchElm(RetNo, 'T1', 442);
    If Strings[28] = '' then
      Strings[28] := FormatDateTime('yyyy/mm/dd', Date);
    If Strings[12] + Strings[13] = '' then
      Strings[12] := 'X';
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure MCREDIT(RetNo: integer; FName: String; FNo: integer);
//https://www.savvynewcanadians.com/ontario-trillium-benefit-dates/
// http://www.fin.gov.on.ca/en/credit/oeptc/index.html  Ont Energy...
// http://www.fin.gov.on.ca/en/credit/noec/index.html  Northen Energy
// http://www.fin.gov.on.ca/en/credit/shptg/index.html   oshptg
Const
  // 20260411
  OnBasicCr =378; //371; // 360; //345; //324; //316; //20210227 //313;
  OnBaseMarried = 36309; //35632; //34661; //33169; //31144; //30415; //29581;  //20210227
  OnBaseSingle = 29047; //28506; //27729; //26535; //24916; //24332; //23665; // 23156; // //20210227
  // Const OnBasicCr=291; OnBaseMarried=27985; OnBaseSingle=22388; //20160327; //20160505 Igor
  // BCHSTCr=230; BCClimateCr=115.50;SkBasicCr=223;
Var
  i, k, GstcFNo: integer;
  OnbenFNo: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    GstcFNo := GetFormNo('GSTC');
    For i := 1 to 70 do
    begin
      Tv[i] := 0;
      Strings[i] := '';
    end; // clear it
    If IsDeceased(RetNo) then // 20120309
    begin
      SaveTv(RetNo, FName, FNo);
      exit;
    end;

    If ret[RetNo].Province <> 'ON' then
    Begin
      For i := 1 to 58 do
        Tv[i] := 0; // kill ostc, osttb
      SaveTv(RetNo, FName, FNo);
      exit;
    end;

    Tv[11] := vl(FetchElm(RetNo, 'OEPTC', 14));

    // ostc
    If (ret[RetNo].Age >= 18) // s/b 18 for next year to get it
      or (vl(FetchElmFNo(RetNo, GstcFNo, 8)) > 0) // spouse claim
      or (UpperCase(FetchElmFNo(RetNo, GstcFNo, 3)) = 'Y') then // elig dep
      Tv[1] := OnBasicCr
    else
      Tv[1] := 0;
    If vl(FetchElmFNo(RetNo, GstcFNo, 8)) > 0 then
      Tv[2] := OnBasicCr
    else
      Tv[2] := 0; // spouse
    Strings[52] := FetchElmFNo(RetNo, GstcFNo, 2);
    Tv[53] := OnBasicCr;
    Tv[3] := vl(Strings[52]) * Tv[53];
    Tv[4] := Tv[1] + Tv[2] + Tv[3];

    Tv[5] := vl(FetchElmFNo(RetNo, GstcFNo, 6)); // family income
    If (ret[RetNo].MarStatus < 3) Or (FetchElmFNo(RetNo, GstcFNo, 3) = 'Y') then
      Tv[6] := OnBaseMarried;
    // 20160130 27571; //20150210 //married or elig dep
    If (ret[RetNo].MarStatus > 2) and (FetchElmFNo(RetNo, GstcFNo, 3) <> 'Y')
    then
      Tv[6] := OnBaseSingle; // 20160130 22057; //20150210 //single no elig dep
    If FetchElmFNo(RetNo, GstcFNo, 29) = 'Y' then
      Tv[6] := OnBaseSingle;

    Tv[7] := MaxR(0, Tv[5] - Tv[6]);
    Tv[8] := Tv[7] * 4 / 100;
    Tv[54] := Tv[8];
    Tv[9] := MaxR(0, Tv[4] - Tv[54]);
    Tv[10] := Tv[9];

    // 20150221
    Strings[71] := FetchElm(RetNo, 'GSTC', 31);
    If UpperCase(Strings[71]) <> 'Y' then
    begin
      For i := 1 to 10 do
        Tv[i] := 0;
      Tv[52] := 0;
      Tv[53] := 0;
      Tv[54] := 0;
    end;

    // NOEC //20240228
    Tv[16] := 0;
    If FetchElm(RetNo, 'ONBEN', 9) > '' then
    Begin
      // 20170226
      If (ret[RetNo].MarStatus < 3) Or (FetchElmFNo(RetNo, GstcFNo, 3) = 'Y')
      then
        Tv[16] :=277; // 265; //20220219 249; //243; //241; // 20210227
      //20260413
      If (ret[RetNo].MarStatus > 2) and (FetchElmFNo(RetNo, GstcFNo, 3) <> 'Y')
      then
        Tv[16] := 189; //172; //162; //158; //157; // 20220219
      // 148; //20160226 143; //20150210 141;//20140208 //137; //136.92; //single no elig dep
      If FetchElmFNo(RetNo, GstcFNo, 29) = 'Y' then
        Tv[16] := 189; //172; //162; //158; //157; // 20210227

      Tv[17] := vl(FetchElmFNo(RetNo, GstcFNo, 6)); // fam income
      // 20180303
      If (ret[RetNo].MarStatus < 3) Or (FetchElmFNo(RetNo, GstcFNo, 3) = 'Y')
      then
        Tv[18] := 63635; //20230219; //54748; //54258; // 53246; //52100;  // 20210227

      If (ret[RetNo].MarStatus > 2) and (FetchElmFNo(RetNo, GstcFNo, 3) <> 'Y')
      then
        Tv[18] := 50833; //46436; //20260413
      If FetchElmFNo(RetNo, GstcFNo, 29) = 'Y' then
        Tv[18] := 50833; //46436; //20260413 //20230219
      Tv[19] := MaxR(0, Tv[17] - Tv[18]);
      Tv[20] := Tv[19] * 1 / 100;
      Tv[22] := Tv[20];
      Tv[21] := MaxR(0, Tv[16] - Tv[22]);
      Tv[23] := Tv[21];
    end
    Else
    Begin
      For i := 16 to 23 do
        Tv[i] := 0;
    end;

    // -------------------------------

    Tv[12] := Tv[11] + Tv[10] + Tv[23];
    Tv[13] := Tv[12] / 12;

    // OSHPTG
    If (ret[RetNo].Age >= 64) and (vl(FetchElm(RetNo, 'ONBEN', 8)) > 0) then
    Begin
      Tv[59] := 500;
      Tv[63] := ret[RetNo].Lnn[23600];
      If HasDeceasedSpouse(RetNo) = False then
        Tv[63] := Tv[63] + vl(FetchElm(RetNo, 'INFO', 19)); // 20120309

      // 20120324
      If (OntarioInvoluntarySeparation(RetNo)) // involuntary  //20120324
        or (IsSpouseNonResident(RetNo)) then // non resident
        Tv[63] := ret[RetNo].Lnn[23600]; // exclude spouse

      If (ret[RetNo].MarStatus > 2) then
        Tv[64] := 35000
      else
      Begin
        Tv[64] := 45000; //50000; //20230622 //20230219 45000; //45000;
        If HasDeceasedSpouse(RetNo) = True then
          Tv[64] := 35000; // 20120309
        // 20120324
        If (OntarioInvoluntarySeparation(RetNo)) // involuntary  //20120324
          or (IsSpouseNonResident(RetNo)) then // non resident
          Tv[64] := 35000; // exclude spouse
      end;

      Tv[65] := MaxR(0, Tv[63] - Tv[64]);
      Tv[66] := Tv[65] * 3.33 / 100;
      Tv[70] := Tv[66];
      Tv[67] := MaxR(0, Tv[59] - Tv[70]);
      Tv[15] := Tv[67];
      /// 3;
      If IsDeceased(RetNo) then // 20110309
      begin
        Tv[59] := 0;
        For i := 63 to 66 do
          Tv[i] := 0;
        Tv[70] := 0;
        Tv[67] := 0;
        Tv[15] := 0;
      end;
    end
    else
    begin
      Tv[59] := 0;
      For i := 63 to 66 do
        Tv[i] := 0;
      Tv[70] := 0;
      Tv[67] := 0;
      Tv[15] := 0;
    end;
    If FetchElm(RetNo, 'ONBEN', 4) = '' then
    begin
      Tv[59] := 0;
      For i := 63 to 66 do
        Tv[i] := 0;
      Tv[70] := 0;
      Tv[67] := 0;
      Tv[15] := 0;
    end;

    // 20170128
    // copy declaration from ONBEN
    OnbenFNo := GetFormNo('ONBEN');
    For i := 80 to 127 do
    Begin
      Strings[i] := FetchElmFNo(RetNo, OnbenFNo, i);
      Tv[i] := vl(FetchElmFNo(RetNo, OnbenFNo, i));
      Tv[78] := vl(FetchElmFNo(RetNo, OnbenFNo, 78));
    End;
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure GSTC(RetNo: integer; FName: String; FNo: integer);
// https://www.canada.ca/en/revenue-agency/services/tax/individuals/frequently-asked-questions-individuals/adjustment-personal-income-tax-benefit-amounts.html
// http://www.cra-arc.gc.ca/tx/ndvdls/fq/ndxtn-eng.html //20170317
// see http://www.cra-arc.gc.ca/nwsrm5/fctshts/2014/m11/fs141125-eng.html
Const
  // 20260409
  BaseCredit  = 445;// '4349; //340
  ChildCredit = 234; //184; //179; //171; //161; //157;
  BaseAmount1 = 11564; //11039; //11039; //10544; //9919; //9686;
  BaseAmount2 = 46432; //45521; //45521; //44324; //42335; //39826; //38892; //38507;


Var
  i, k, MCreditFNo, SpRetNo: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    // 20150119
    // If Strings[1]='' then  //20150221
    Strings[1] := 'Y'; // default to Y
    If Strings[31] = '' then
    begin
      If ret[RetNo].MarStatus > 2 then
        Strings[31] := 'Y'; // 20150218
    end;
    // 20110312
    If UpperCase(Strings[1]) <> 'Y' then
    begin
      For i := 2 to 39 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      SaveTv(RetNo, FName, FNo);
      exit;
    end;

    If ((ret[RetNo].Age >= 18)) // 20150318
      Or ((ret[RetNo].Age < 19) and (ret[RetNo].MarStatus < 3))
    // less than 19 and married
      Or ((ret[RetNo].Age < 19) and (CountKidsUnder6(RetNo) > 0))
    // less than 19 but have kids
    then
      // ok
    Else
      Strings[1] := 'N';

    If (UpperCase(Strings[1]) = 'Y') and (Strings[23] = '') then
      Strings[23] := 'Y';
    If ret[RetNo].Province = 'ZZ' then
      Strings[1] := 'N'; { non resident }
    If ret[RetNo].Deceased = True then
      Strings[1] := 'N'; { deceased }

    Strings[2] := FetchElm(RetNo, 'DEPEND', 1);

    If UpperCase(LeftStr(Strings[1], 1)) <> 'Y' then
    begin
      Strings[2] := '';
      Strings[3] := '';
      For i := 4 to 28 do
        Tv[i] := 0;
    end
    else
    begin
      If ret[RetNo].Lnn[30400] > 0 then
        Strings[3] := 'Y'
      else
        Strings[3] := '';

      If UpperCase(Strings[23]) = 'N' then
      begin
        Strings[2] := '';
        Strings[3] := '';
      end;

      Tv[4] := ret[RetNo].Lnn[23600];
      If TOSIinEffect(RetNo) then
        Tv[4] := GetTOSINetIncome(RetNo); // 20190115
      If ret[RetNo].MarStatus < 3 then
      Begin
        Tv[5] := SpouseIncome(RetNo);
      end
      else
        Tv[5] := 0;
      If UpperCase(Strings[29]) = 'Y' then Tv[5] := 0; // 20120324

      Tv[24] := GetTotalUCCB(RetNo) + GetTotalRDSP(RetNo);
      // +GetRc310Income(RetNo); //20170126
      Tv[6] := Tv[4] + Tv[5] - Tv[24];

      Tv[7] := BaseCredit;
      If ret[RetNo].MarStatus < 3 then
        Tv[8] := BaseCredit
      else
        Tv[8] := 0;
      If FetchElm(RetNo, 'INFO', 167) > '' then
        Tv[8] := 0; // 20120221 Spouse nonres or in prison
      If UpperCase(Strings[29]) = 'Y' then
      begin
        Tv[8] := 0;
      end;
      If UpperCase(Strings[30]) <> 'Y' then // 20130318
      Begin
        If ret[RetNo].Lnn[30400] > 0 then
          Tv[9] := BaseCredit
        else
          Tv[9] := 0;
      end
      Else
        Tv[9] := 0;

      If UpperCase(Strings[3]) <> 'Y' then
        Strings[10] := Strings[2]
      else
      begin
        k := MyStrToInt(Strings[2]) - 1; { exclude eq to spouse }
        If k < 0 then
          k := 0;
        Strings[10] := IntToStr(k);
      end;

      Tv[11] := vl(Strings[10]) * ChildCredit;

      Tv[32]:= Vl(strings[33])*ChildCredit*50/100;        //202260411

      //additional Ceredit

      if (Ret[RetNo].MarStatus>2) and (Ret[RetNo].MarStatus<5)
      And (Vl(Strings[10])=0) and (Vl(Strings[33])=0)  //Single parent no kids
      then
          Tv[34]:=ChildCredit
      Else
      begin
        Tv[34]:=0;
        Tv[12] := Tv[6];
        Tv[13] := BaseAmount1;
        Tv[14] := MaxR(0, Tv[12] - Tv[13]);
        Tv[15] := MinR(ChildCredit, 0.02 * Tv[14]);
      end;

      If (ret[RetNo].MarStatus > 2)and (vl(Strings[2]) + vl(Strings[3]) > 0)
      then
        Tv[15] := ChildCredit;

      Tv[16] := Tv[7] + Tv[8] + Tv[9] + Tv[11] + Tv[32]+ Tv[15];  //2026411
      Tv[17] := Tv[6];
      Tv[18] := BaseAmount2;
      Tv[19] := MaxR(0, Tv[17] - Tv[18]);
      Tv[20] := Tv[19] * 0.05;
      Tv[21] := MaxR(0, Tv[16] - Tv[20]);
      If Tv[21] < 1 then Tv[21] := 0;
      Tv[22] := Tv[21] / 4;
      Tv[25] := Tv[22];
      Tv[26] := Tv[22];
      Tv[27] := Tv[22];
      Tv[28] := Tv[22];

    end;
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure PRVSUM(RetNo: integer; FName: String; FNo: integer);
var
  i, k, ElmNo, SpRetNo: integer;
  RNo: integer;
  Prov: String;
  s: string[15];
  XX428FNo: integer;
begin

  LoadTv(RetNo, FName, FNo); { needed for initialization }

  with ret[RetNo].Frm[FNo] do
  begin
    Strings[242] := GetLastName(RetNo); // original retno
    If ret[RetNo].IsTaxPlan then
      Strings[241] := PlanYear + ' PLANNER'
    Else
      Strings[241] := AppYear;
    Strings[243] := GetFirstName(RetNo);
    Strings[245] := GetSinNo(RetNo);
    // spouse
    Strings[244] := GetSpouseFirstName(RetNo);
    Strings[246] := FetchElm(RetNo, 'INFO', 4);

    SpRetNo := GetSpRetNo(RetNo);
    If (SpRetNo = 0) then { spouse does not exist or not loaded }
    begin
      Strings[332] := '';
    end;
  end;
  k := 0;
  // NOTE: ALL DATA work via RNO , except Save
  For k := 0 to 1 do // ???
  Begin
    If k = 0 then
      RNo := RetNo;
    If k = 1 then
    begin
      If SpRetNo = 0 then
        Break;
      RNo := SpRetNo;
    end;

    // If RNo=0 then RNo:=1;  //otherwise it fails Rno:=0

    with ret[RNo].Frm[FNo] do
    begin
      // data
      Prov := ret[RNo].Province;
      Strings[331 + k] := Prov;
      XX428FNo := GetFormNo(Prov + '428');
      If Prov <> 'QC' then
      begin
        Tv[251 + k] := vl(FetchElmFNo(RNo, XX428FNo, 23)); // 5804
        Tv[253 + k] := vl(FetchElmFNo(RNo, XX428FNo, 24)); // 5808
        Tv[255 + k] := vl(FetchElmFNo(RNo, XX428FNo, 28)); // 5812
        Tv[257 + k] := vl(FetchElmFNo(RNo, XX428FNo, 29)); // 5816
        Tv[259 + k] := vl(FetchElmFNo(RNo, XX428FNo, 30)); // 5820
      end;
      If Prov = 'YT' then
        Tv[261 + k] := vl(FetchElmFNo(RNo, XX428FNo, 25)) // 5825   //YT only
      else
        Tv[261 + k] := 0; // 5825   //NON-YT
      Tv[263 + k] := ret[RNo].Lnn[30800]; // 5824
      Tv[265 + k] := ret[RNo].Lnn[31000]; // 5828
      Tv[267 + k] := ret[RNo].Lnn[31200]; // 5832
      Tv[269 + k] := ret[RNo].Lnn[31217]; // 5829

      Tv[271 + k] := 0;
      If Prov = 'AB' then
        Tv[271 + k] := vl(FetchElmFNo(RNo, XX428FNo, 51)) // 5833  //adoption
      Else If Prov = 'BC' then
        Tv[271 + k] := vl(FetchElmFNo(RNo, XX428FNo, 51)) // 5833  //adoption
      Else If Prov = 'NL' then
        Tv[271 + k] := vl(FetchElmFNo(RNo, XX428FNo, 51)) // 5833  //adoption
      Else If Prov = 'ON' then
        Tv[271 + k] := vl(FetchElmFNo(RNo, XX428FNo, 51)) // 5833  //adoption
      Else If Prov = 'MB' then
        Tv[271 + k] := vl(FetchElmFNo(RNo, XX428FNo, 51)) // 5833  //adoption
      Else If Prov = 'YT' then
        Tv[271 + k] := vl(FetchElmFNo(RNo, XX428FNo, 51)) // 5833  //adoption
          ;
      If Prov <> 'QC' then
        Tv[273 + k] := vl(FetchElmFNo(RNo, XX428FNo, 34)); // 5836  //20101219
      If Prov = 'MB' then
        Tv[275 + k] := vl(FetchElmFNo(RNo, XX428FNo, 67)) // 5838  //mb, YT
      else If Prov = 'YT' then
        Tv[275 + k] := vl(FetchElmFNo(RNo, XX428FNo, 26)) // 5838  //mb, YT
      else
        Tv[275 + k] := 0;
      If Prov <> 'QC' then
      Begin
        Tv[277 + k] := vl(FetchElmFNo(RNo, XX428FNo, 35)); // 5840
        Tv[279 + k] := vl(FetchElmFNo(RNo, XX428FNo, 36)); // 5844
        Tv[281 + k] := vl(FetchElmFNo(RNo, XX428FNo, 37)); // 5848
        Tv[283 + k] := vl(FetchElmFNo(RNo, XX428FNo, 38)); // 5852
        Tv[285 + k] := vl(FetchElmFNo(RNo, XX428FNo, 39)); // 5856
        Tv[287 + k] := vl(FetchElmFNo(RNo, XX428FNo, 40)); // 5860
        Tv[289 + k] := vl(FetchElmFNo(RNo, XX428FNo, 41)); // 5864
        if (Prov = 'ON') or (Prov = 'SK') then
        begin
          Tv[277 + k] := 0;
          Tv[287 + k] := 0;
        end; // 20200420
      end;
      If Prov = 'MB' then
        Tv[291 + k] := vl(FetchElmFNo(RNo, XX428FNo, 71)) // 6147  //MB
      else
        Tv[291 + k] := 0;

      If Prov = 'SK' then
        Tv[293 + k] := vl(FetchElmFNo(RNo, XX428FNo, 67)) // 5822  //SK
      Else
        Tv[293 + k] := 0;

      If Prov = 'SK' then
        Tv[295 + k] := vl(FetchElmFNo(RNo, XX428FNo, 66)) // 5821  //sk
      Else
        Tv[295 + k] := 0; // 5821  //non-sk

      If Prov = 'NS' then
        Tv[297 + k] := vl(FetchElmFNo(RNo, XX428FNo, 74)) // 5823  //ns nu  pe
      else If Prov = 'NU' then
        Tv[297 + k] := vl(FetchElmFNo(RNo, XX428FNo, 73)) // 5823  //ns nu  pe
      else If Prov = 'PE' then
        Tv[297 + k] := vl(FetchElmFNo(RNo, XX428FNo, 68)) // 5823  //ns nu  pe
      else
        Tv[297 + k] := 0;

      If Prov = 'NS' then
        Tv[299 + k] := vl(FetchElmFNo(RNo, XX428FNo, 75)) // 5849   //ns
      else
        Tv[299 + k] := 0;

      If Prov = 'SK' then
        Tv[301 + k] := vl(FetchElmFNo(RNo, XX428FNo, 51)) // 5879 //SK
      else
        Tv[301 + k] := 0;

      If Prov <> 'QC' then
      begin
        Tv[303 + k] := vl(FetchElmFNo(RNo, XX428FNo, 42)); // 5868
        Tv[305 + k] := vl(FetchElmFNo(RNo, XX428FNo, 45)); // 5872
        Tv[307 + k] := vl(FetchElmFNo(RNo, XX428FNo, 46)); // 5876
        Tv[309 + k] := vl(FetchElmFNo(RNo, XX428FNo, 48)); // 5880
        Tv[311 + k] := vl(FetchElmFNo(RNo, XX428FNo, 50)); // rate
        Tv[313 + k] := vl(FetchElmFNo(RNo, XX428FNo, 52)); // 5884
        Tv[315 + k] := vl(FetchElmFNo(RNo, XX428FNo, 59)); // 5896
        Tv[317 + k] := vl(FetchElmFNo(RNo, XX428FNo, 61)); // 6150
      end;

      // init other credits
      Tv[319 + k] := 0; // 6151 tax on split
      Tv[321 + k] := 0; // 6152  //dividend tax credit
      Tv[323 + k] := 0; // 6153  //overseas
      Tv[325 + k] := 0; // 6154  min tax carry over
      Tv[327 + k] := 0; // prov foreign
      Tv[329 + k] := 0; // 6310  //pol
      If Prov = 'AB' then
      begin
        Tv[319 + k] := vl(FetchElmFNo(RNo, XX428FNo, 8)); // 6151 tax on split
        Tv[321 + k] := vl(FetchElmFNo(RNo, XX428FNo, 103));
        // 6152  //dividend tax credit
        Tv[323 + k] := vl(FetchElmFNo(RNo, XX428FNo, 105)); // 6153  //overseas
        Tv[325 + k] := vl(FetchElmFNo(RNo, XX428FNo, 107));
        // 6154  min tax carry over
        Tv[327 + k] := vl(FetchElmFNo(RNo, XX428FNo, 111)); // prov foreign
        Tv[329 + k] := vl(FetchElmFNo(RNo, XX428FNo, 114)); // pol credit
      end

      Else If Prov = 'BC' then
      begin
        Tv[319 + k] := vl(FetchElmFNo(RNo, XX428FNo, 133)); // 6151 tax on split
        Tv[321 + k] := vl(FetchElmFNo(RNo, XX428FNo, 138));
        // 6152  //dividend tax credit
        Tv[323 + k] := vl(FetchElmFNo(RNo, XX428FNo, 140)); // 6153  //overseas
        Tv[325 + k] := vl(FetchElmFNo(RNo, XX428FNo, 142));
        // 6154  min tax carry over
        Tv[327 + k] := vl(FetchElmFNo(RNo, XX428FNo, 148)); // prov foreign
        Tv[329 + k] := vl(FetchElmFNo(RNo, XX428FNo, 125)); // pol
      end

      Else If Prov = 'MB' then
      begin
        Tv[319 + k] := vl(FetchElmFNo(RNo, XX428FNo, 112)); // 6151 tax on split
        Tv[321 + k] := vl(FetchElmFNo(RNo, XX428FNo, 107));
        // 6152  //dividend tax credit
        Tv[323 + k] := vl(FetchElmFNo(RNo, XX428FNo, 162)); // 6153  //overseas
        Tv[325 + k] := vl(FetchElmFNo(RNo, XX428FNo, 164));
        // 6154  min tax carry over
        Tv[327 + k] := vl(FetchElmFNo(RNo, XX428FNo, 144)); // prov foreign
        Tv[329 + k] := vl(FetchElmFNo(RNo, XX428FNo, 121)); // pol
      end

      Else If Prov = 'NB' then
      begin
        Tv[319 + k] := vl(FetchElmFNo(RNo, XX428FNo, 102)); // 6151 tax on split
        Tv[321 + k] := vl(FetchElmFNo(RNo, XX428FNo, 108));
        // 6152  //dividend tax credit
        Tv[323 + k] := vl(FetchElmFNo(RNo, XX428FNo, 110)); // 6153  //overseas
        Tv[325 + k] := vl(FetchElmFNo(RNo, XX428FNo, 111));
        // 6154  min tax carry over
        Tv[327 + k] := vl(FetchElmFNo(RNo, XX428FNo, 118)); // prov foreign
        Tv[329 + k] := vl(FetchElmFNo(RNo, XX428FNo, 145)); // pol
      end

      Else If Prov = 'NL' then
      begin
        Tv[319 + k] := vl(FetchElmFNo(RNo, XX428FNo, 102)); // 6151 tax on split
        Tv[321 + k] := vl(FetchElmFNo(RNo, XX428FNo, 111));
        // 6152  //dividend tax credit
        Tv[323 + k] := vl(FetchElmFNo(RNo, XX428FNo, 116)); // 6153  //overseas
        Tv[325 + k] := vl(FetchElmFNo(RNo, XX428FNo, 123));
        // 6154  min tax carry over
        Tv[327 + k] := vl(FetchElmFNo(RNo, XX428FNo, 132)); // prov foreign
        Tv[329 + k] := vl(FetchElmFNo(RNo, XX428FNo, 108)); // pol
      end

      Else If Prov = 'NS' then
      begin
        Tv[319 + k] := vl(FetchElmFNo(RNo, XX428FNo, 102)); // 6151 tax on split
        Tv[321 + k] := vl(FetchElmFNo(RNo, XX428FNo, 107));
        // 6152  //dividend tax credit
        Tv[323 + k] := vl(FetchElmFNo(RNo, XX428FNo, 110)); // 6153  //overseas
        Tv[325 + k] := vl(FetchElmFNo(RNo, XX428FNo, 113));
        // 6154  min tax carry over
        Tv[327 + k] := vl(FetchElmFNo(RNo, XX428FNo, 119)); // prov foreign
        Tv[329 + k] := vl(FetchElmFNo(RNo, XX428FNo, 125)); // pol
      end

      Else If Prov = 'NT' then
      begin
        Tv[319 + k] := vl(FetchElmFNo(RNo, XX428FNo, 102)); // 6151 tax on split
        Tv[321 + k] := vl(FetchElmFNo(RNo, XX428FNo, 107));
        // 6152  //dividend tax credit
        Tv[323 + k] := vl(FetchElmFNo(RNo, XX428FNo, 110)); // 6153  //overseas
        Tv[325 + k] := vl(FetchElmFNo(RNo, XX428FNo, 113));
        // 6154  min tax carry over
        Tv[327 + k] := vl(FetchElmFNo(RNo, XX428FNo, 119)); // prov foreign
        Tv[329 + k] := vl(FetchElmFNo(RNo, XX428FNo, 125)); // pol
      end

      Else If Prov = 'NU' then
      begin
        Tv[319 + k] := vl(FetchElmFNo(RNo, XX428FNo, 102)); // 6151 tax on split
        Tv[321 + k] := vl(FetchElmFNo(RNo, XX428FNo, 107));
        // 6152  //dividend tax credit
        Tv[323 + k] := vl(FetchElmFNo(RNo, XX428FNo, 110)); // 6153  //overseas
        Tv[325 + k] := vl(FetchElmFNo(RNo, XX428FNo, 113));
        // 6154  min tax carry over
        Tv[327 + k] := vl(FetchElmFNo(RNo, XX428FNo, 119)); // prov foreign
        Tv[329 + k] := vl(FetchElm(RNo, 'NU479', 16)); // pol  //!!!
      end

      Else If Prov = 'ON' then
      begin
        Tv[319 + k] := vl(FetchElmFNo(RNo, XX428FNo, 131)); // 6151 tax on split
        Tv[321 + k] := vl(FetchElmFNo(RNo, XX428FNo, 136));
        // 6152  //dividend tax credit
        Tv[323 + k] := vl(FetchElmFNo(RNo, XX428FNo, 138)); // 6153  //overseas
        Tv[325 + k] := vl(FetchElmFNo(RNo, XX428FNo, 140));
        // 6154  min tax carry over
        Tv[327 + k] := vl(FetchElmFNo(RNo, XX428FNo, 153)); // prov foreign
        Tv[329 + k] := vl(FetchElm(RNo, 'ON479', 103)); // pol  //!!!
      end

      Else If Prov = 'PE' then
      begin
        Tv[319 + k] := vl(FetchElmFNo(RNo, XX428FNo, 102)); // 6151 tax on split
        Tv[321 + k] := vl(FetchElmFNo(RNo, XX428FNo, 108));
        // 6152  //dividend tax credit
        Tv[323 + k] := vl(FetchElmFNo(RNo, XX428FNo, 117)); // 6153  //overseas
        Tv[325 + k] := vl(FetchElmFNo(RNo, XX428FNo, 142));
        // 6154  min tax carry over
        Tv[327 + k] := vl(FetchElmFNo(RNo, XX428FNo, 154)); // prov foreign
        Tv[329 + k] := vl(FetchElmFNo(RNo, XX428FNo, 110)); // pol
      end

      Else If Prov = 'SK' then
      begin
        Tv[319 + k] := vl(FetchElmFNo(RNo, XX428FNo, 102)); // 6151 tax on split
        Tv[321 + k] := vl(FetchElmFNo(RNo, XX428FNo, 108));
        // 6152  //dividend tax credit
        Tv[323 + k] := vl(FetchElmFNo(RNo, XX428FNo, 111)); // 6153  //overseas
        Tv[325 + k] := vl(FetchElmFNo(RNo, XX428FNo, 114));
        // 6154  min tax carry over
        Tv[327 + k] := vl(FetchElmFNo(RNo, XX428FNo, 118)); // prov foreign
        Tv[329 + k] := vl(FetchElmFNo(RNo, XX428FNo, 121)); // pol
      end

      Else If Prov = 'YT' then
      begin
        Tv[319 + k] := vl(FetchElmFNo(RNo, XX428FNo, 133)); // 6151 tax on split
        Tv[321 + k] := vl(FetchElmFNo(RNo, XX428FNo, 108));
        // 6152  //dividend tax credit
        Tv[323 + k] := vl(FetchElmFNo(RNo, XX428FNo, 128)); // 6153  //overseas
        Tv[325 + k] := vl(FetchElmFNo(RNo, XX428FNo, 126));
        // 6154  min tax carry over
        Tv[327 + k] := vl(FetchElmFNo(RNo, XX428FNo, 104)); // prov foreign
        Tv[329 + k] := vl(FetchElm(RNo, 'YT479', 10)); // pol  //!!!
      end;

      // other
      Tv[333 + k] := ret[RNo].Lnn[47900]; // 479 credits
      Tv[335 + k] := ret[RNo].Lnn[42800]; // provincial tax
    end; // with
  End; // K
  SaveTv(RetNo, FName, FNo);
end;

procedure TAXSUM(RetNo: integer; FName: String; FNo: integer);
var
  i, ElmNo, LineId: integer;
  Apt: string[12];
  s: string[15];
begin
  // used taxsum.d also
  LoadTv(RetNo, FName, FNo); { needed for initialization }
  with ret[RetNo].Frm[FNo] do
  begin
    If ret[RetNo].IsTaxPlan then
      Strings[8] := PlanYear + ' PLANNER'
    Else
      Strings[8] := AppYear;
    If ShowUnconvertedLastYear(RetNo) then
      Strings[8] := GetLastYearTaxYear;
    Strings[2] := GetFirstName(RetNo) + ' ' + GetLastName(RetNo);
    Strings[16] := UpperCase(FetchElm(RetNo, 'INFO', 46));
    If IsReturnDiscounted(RetNo) then
      Strings[17] := 'Y'
    else
      Strings[17] := 'N';

    // 20190308
    If (UpperCase(FetchElmFNo(RetNo, InfoFNo, 191)) = 'X') then
      Strings[22] := 'Y'
    else
      Strings[22] := 'N';
    Strings[11] := GetSinNo(RetNo);
    If FetchElm(RetNo, 'INFO', 22) > '' then
      Apt := ',' + RTrim(FetchElm(RetNo, 'INFO', 22))
    else
      Apt := '';
    Strings[3] := RTrim(FetchElm(RetNo, 'INFO', 6)) + RTrim(Apt) + ' ' +
      RTrim(FetchElm(RetNo, 'INFO', 68)) + ', ' +
      RTrim(FetchElm(RetNo, 'INFO', 10)) + ', ' +
      RTrim(FetchElm(RetNo, 'INFO', 14)) + ', ' +
      RTrim(FetchElm(RetNo, 'INFO', 15));
    If Strings[3] = ', , ,' then
      Strings[3] := '';

    Strings[5] := GetAreaCode(RetNo)+' '+ GetPhoneNo(RetNo);  //20220310
    Strings[178]:=FetchElmFNo(RetNo,InfoFno,74)+' '+FetchElmFNo(RetNo,InfoFno,75);  //20220310
    Strings[6] := FetchElm(RetNo, 'INFO', 9); { birthdate }
    Strings[157] := IntToStr(CalcAge(Strings[6]));
    Strings[9] := GetShortPrv(FetchElm(RetNo, 'INFO', 1)); { prov of res }
    Strings[10] := IntToStr(CalcDaysInCan(RetNo));

    // 20160317 //20160505 Igor
    If (UpperCase(FetchElm(RetNo, 'GSTC', 31)) = 'Y') and
      (vl(FetchElm(RetNo, 'GSTC', 22)) > 0) then
      Strings[12] := 'Y'
    else
      Strings[12] := 'N';
    {
      If FetchElm(RetNo,'INFO',29)> '' then
      Strings[12] := 'Y' else Strings[12] :='N';
    }
   // Tv[81]:=Vl(FetchElm(RetNo,'S14EST',11));  //CCR carbon
    Strings[148] := FetchElm(RetNo, 'GSTC', 2); { gst kids }
    Strings[13] := MarDescr[ret[RetNo].MarStatus]; { marital }
    If ret[RetNo].MarStatus < 3 then
      Strings[14] := LeftStr(FetchElm(RetNo, 'INFO', 20) + ' ' +
        GetSpouseLastName(RetNo), 20) { spouse name }
    else
      Strings[14] := '';
    Strings[15] := GetSpouseBirthDate(RetNo); { spouse birthdate }
    Strings[18] := FetchElm(RetNo, 'INFO', 4); { spouse sin }

    Tv[19] := SpouseIncome(RetNo);
    Tv[23] := ret[RetNo].Lnn[23600] + SpouseIncome(RetNo);
    Tv[174] := vl(FetchElm(RetNo, 'MCREDIT', 13)); // 20120126
    s := LeftStr(FetchElm(RetNo, 'S5', 8) + ' ' + FetchElm(RetNo, 'S5', 9), 15);
    Strings[20] := s;
    Strings[21] := GetEligDepBirthdate(RetNo);
    // DepFetchElm(RetNo,'S5',13);  {Equiv birthdate}  //20130312
    Tv[25] := vl(FetchElm(RetNo, 'S5', 20)); { Equiv spouse income }
    Strings[24] := FetchElm(RetNo, 'S5', 10); // 20110425 {SIN}

    Strings[27] := FetchElm(RetNo, 'DEPEND', 1); { < 19 }
    Strings[28] := FetchElm(RetNo, 'DEPEND', 2); { infirm }
    Strings[29] := FetchElm(RetNo, 'DEPEND', 4); { infirm over 18 }

    Strings[136] := OptRec.Prp_Name;
    Strings[138] := OptRec.Prp_Area + ' ' + OptRec.Prp_Tel;

    If OptRec.Prp_Dates then
      Strings[4] := DateToMonthDayYear(Date);
    Strings[1] := OptRec.Prp_FxArea + ' ' + OptRec.Prp_Fax;

    Tv[103] := vl(FetchElm(RetNo, 'CFR', 144)); { non cap losses }
    // Tv[106] := Vl(FetchElm(RetNo, 'S1', 44)); { tax on slpit income } //???? 20191220
    Tv[107] := vl(FetchElm(RetNo, 'CFR', 203)); { farm/fish losses }
    Tv[113] := vl(FetchElm(RetNo, 'CFR', 262)); { restr farm losses }
    Tv[116] := vl(FetchElm(RetNo, 'CFR', 399)) + vl(FetchElm(RetNo, 'CFR', 406)
      ); // 20111223
    // Vl(FetchElm(RetNo,'CFR',535))+Vl(FetchElm(RetNo,'CFR',405));  //20110301
    // {net cap losses} Vl(FetchElm(RetNo,'CFR',434)); {net cap losses}

    Tv[126] := vl(FetchElm(RetNo, 'T691', 324)); { min tax }
    Tv[137] := vl(FetchElm(RetNo, 'S11', 1)); { tuition fees } //20260328
    Tv[140] := vl(FetchElm(RetNo, 'DON', 133)); { donations }
    Tv[141] := vl(FetchElm(RetNo, 'S7', 20)); { deduction room }
    Tv[142] := vl(FetchElm(RetNo, 'S7', 10)); { undeducted rrsp contr }
    Tv[143] := TotMultiple(RetNo, 'T1M', 129); { moving }

    Tv[144] := vl(FetchElm(RetNo, 'S11', 11)); { tuition/educ }
    Tv[161] := vl(FetchElm(RetNo, 'S11PRV', 11)); { tuition/educ }
    Tv[145] := vl(FetchElm(RetNo, 'CTB', 70)); { CTB }
    If UpperCase(FetchElm(RetNo, 'GSTC', 31)) = 'Y' then // 20150218
      Tv[146] := vl(FetchElm(RetNo, 'GSTC', 22)) { GST cr }
    else
      Tv[146] := 0;

    Tv[147] := vl(FetchElm(RetNo, 'RC71', 4)); { Disc. paid }
    Tv[149] := vl(FetchElm(RetNo, 'STLOAN', 41));
    Tv[118] := vl(FetchElm(RetNo, 'T1', 53));
    Tv[179]:=Ret[RetNo].Lnn[47556];  //20221218
    Tv[180]:=Ret[RetNo].Lnn[47557];  //20221218
    Tv[181]:=Ret[RetNo].Lnn[20805];  //20240216
    // Vl(FetchElm(RetNo, 'S1', 110)); //20191220
    Tv[120] := vl(FetchElm(RetNo, 'T1', 82));
    // Vl(FetchElm(RetNo, 'S1', 117));  //20191220
    Tv[131] := vl(FetchElm(RetNo, 'RRSPNXT', 14));
    Tv[156] := vl(FetchElm(RetNo, 'RRSP', 96)); // HBP bal
    Tv[155] := vl(FetchElm(RetNo, 'RRSP', 95)); // LLP bal
    For i := 0 to TaxSumList.Count - 1 do
    begin
      ElmNo := MyStrToInt(LeftStr(TaxSumList[i], 3));
      LineId := MyStrToInt(MidStr(TaxSumList[i], 5, 5)); // 20190709 Igor
      Tv[ElmNo] := ret[RetNo].Lnn[LineId];
    end;

    if IsMultJurisdiction(RetNo) then
      Tv[104] := vl(FetchElm(RetNo, 'T2203', 993)); // 20180006



  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure FAMSUM(RetNo: integer; FName: String; FNo: integer);
var
  i, SpRetNo, ElmNo, LineId: integer;
  Apt: string[12];
  s: string[15];
  FamilyTotal: Real;
begin
  LoadTv(RetNo, FName, FNo); { needed for initialization }
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[202] := GetLastName(RetNo);

    If Strings[201] = '' then
    begin
      If OptRec.Prp_Dates then
        Strings[201] := FormatDateTime('yyyy-mm-dd', Date);
    end;
    SpRetNo := GetSpRetNo(RetNo);
    If (SpRetNo = 0) then { spouse does not exist }
    begin
      Strings[2] := '';
      Strings[4] := '';
      Strings[6] := '';
      Strings[8] := '';
    end;

    If ret[RetNo].MarStatus > 2 then
    begin
      i := 11;
      Repeat
        Tv[i] := 0;
        Inc(i, 2);
      until i > 197;
      Tv[210] := 0; // uccb
    end;

    If ret[RetNo].IsTaxPlan then
      Strings[9] := PlanYear + ' PLANNER'
    Else
      Strings[9] := AppYear;
    Strings[1] := GetFirstName(RetNo);
    Strings[3] := GetFirstName(RetNo);
    Strings[5] := GetSinNo(RetNo);
    Strings[7] := IntToStr(CalcAge(FetchElm(RetNo, 'INFO', 9)));

    Strings[2] := GetSpouseFirstName(RetNo);
    Strings[4] := GetSpouseFirstName(RetNo);
    Strings[6] := FetchElm(RetNo, 'INFO', 4);
    If FetchElm(RetNo, 'INFO', 59) > '' then
      Strings[8] := IntToStr(CalcAge(FetchElm(RetNo, 'INFO', 59)));

    Strings[198] := OptRec.Prp_Name;
    Strings[199] := OptRec.Prp_Area + ' ' + OptRec.Prp_Tel;
    Strings[200] := OptRec.Prp_FxArea + ' ' + OptRec.Prp_Fax;

    // now bring TV data
    GetFamSumData(RetNo, RetNo, 0); // k=0 for elm //20240123 Igor //GetFamSumData(RetNo, 0); // k=0 for elm
    If SpRetNo > 0 then
     GetFamSumData(RetNo, SpRetNo, 1); // k=1: elm+1 //20240123 Igor
    {
    If SpRetNo > 0 then
      GetFamSumData(SpRetNo, 1); // k=1: elm+1
    }

    FamilyTotal := Tv[192] + Tv[193] - Tv[190] - Tv[191];

    If FamilyTotal >= 0 then
      Strings[212] := 'Family Refund'
    else
      Strings[212] := 'Family Owing';
    Tv[211] := ABS(FamilyTotal);
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure YRSUM2(RetNo: integer; FName: String; FNo: integer);
var
  i, ElmNo, LineId: integer;
  Apt: string[12];
  s: string[15];
begin
  LoadTv(RetNo, FName, FNo); { needed for initialization }
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[5] := GetSinNo(RetNo);
    Strings[202] := GetFirstName(RetNo) + ' ' + GetLastName(RetNo);
    Strings[201] := FormatDateTime('yyyy-mm-dd', Date); // 20150314
    Strings[7] := IntToStr(CalcAge(FetchElm(RetNo, 'INFO', 9)));
    Strings[9] := AppYear;
    Strings[6] := IntToStr(MyStrToInt(AppYear) - 1);
    Strings[3] := Strings[9];
    Strings[4] := Strings[6];

    Strings[198] := OptRec.Prp_Name;
    Strings[199] := OptRec.Prp_Area + ' ' + OptRec.Prp_Tel;
    Strings[200] := OptRec.Prp_FxArea + ' ' + OptRec.Prp_Fax;

    // now bring TV data
    GetCurrentYrSum2Data(RetNo, FNo, 0); // k=0 for current yr
    GetLastYrSum2Data(RetNo, 1); // k=1 for last year data

  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

Procedure GetFamSumData(RetNo, RNo, k: integer); //20240123 Igor
//Procedure GetFamSumData(RNo, k: integer);
Var FNo:Integer;
begin
  FNo:=GetFormNo('FAMSUM');
  with ret[RetNo].Frm[FNo], ret[RNo] do //20240123 Igor
  begin
    // tot income
    Tv[10 + k] := Lnn[10100]; // +Lnn[10400];
    Tv[227 + k] := Lnn[10400];
    Tv[12 + k] := Lnn[11300];
    Tv[14 + k] := Lnn[11400];
    Tv[16 + k] := Lnn[11500];
    Tv[213 + k] := Lnn[11600];
    Tv[209 + k] := Lnn[11700];
    Tv[18 + k] := Lnn[11900];
    Tv[20 + k] := Lnn[12000];
    Tv[22 + k] := Lnn[12100];
    Tv[24 + k] := Lnn[12200];
    Tv[225 + k] := Lnn[12500];
    Tv[26 + k] := Lnn[12600];
    Tv[28 + k] := Lnn[12700];
    Tv[30 + k] := Lnn[12800];
    Tv[32 + k] := Lnn[12900];
    Tv[34 + k] := Lnn[13000];
    Tv[108 + k] := Lnn[13010]; // 20200301
    Tv[36 + k] := Lnn[13500] + Lnn[13700] + Lnn[13900]
      + Lnn[14100] + Lnn[14300];
    Tv[38 + k] := Lnn[14400];
    Tv[40 + k] := Lnn[14500];
    Tv[42 + k] := Lnn[14600];
    Tv[44 + k] := Lnn[15000];
    // net income
    Tv[46 + k] := Lnn[20700];
    Tv[48 + k] := Lnn[20800];
    Tv[215 + k] := Lnn[21000];
    Tv[52 + k] := Lnn[21200];
    Tv[217 + k] := Lnn[21300];
    Tv[54 + k] := Lnn[21400];
    Tv[56 + k] := Lnn[21500];
    Tv[58 + k] := Lnn[21700];
    Tv[60 + k] := Lnn[21900];
    Tv[62 + k] := Lnn[22000];
    Tv[64 + k] := Lnn[22100];
    Tv[66 + k] := Lnn[22200];
    Tv[68 + k] := Lnn[22400];
    Tv[70 + k] := Lnn[22900];
    Tv[72 + k] := Lnn[23100];
    Tv[74 + k] := Lnn[23200];
    Tv[76 + k] := Lnn[23500];
    Tv[78 + k] := Lnn[23600];
    // taxable income
    Tv[140 + k] := Lnn[24400];
    Tv[80 + k] := Lnn[45110]; // 20181124
    Tv[82 + k] := Lnn[24900];
    Tv[84 + k] := Lnn[25000];
    Tv[86 + k] := Lnn[25100];
    Tv[88 + k] := Lnn[25200];
    Tv[90 + k] := Lnn[25300];
    Tv[92 + k] := Lnn[25400];
    Tv[94 + k] := Lnn[25500];
    Tv[96 + k] := Lnn[25600];
    Tv[98 + k] := Lnn[26000];

    // non ref
    Tv[100 + k] := Lnn[30000];
    Tv[102 + k] := Lnn[30100];
    Tv[104 + k] := Lnn[30300];
    Tv[246 + k] := Lnn[30425]; // 20180130
    Tv[106 + k] := Lnn[30400];
    Tv[248 + k] := Lnn[30450]; // 20180130
    Tv[223 + k] := Lnn[30500]; // 20200222
    // Tv[108+k]:= Lnn[306];
    Tv[110 + k] := Lnn[30800];
    Tv[112 + k] := Lnn[31000];
    Tv[114 + k] := Lnn[31200];
    Tv[205 + k] := Lnn[31260];
    // Tv[207 + k] := Lnn[364];  //20181109

    // Tv[194 + k] := Lnn[368];   //20200102
    Tv[233 + k] := Lnn[31270];
    // 20111211
    // Tv[231 + k] := Lnn[370];  //20200102
    Tv[244 + k] := Lnn[31285]; // 20170311
    Tv[240 + k] := Lnn[31220];

    Tv[203 + k] := Lnn[31300];
    Tv[118 + k] := Lnn[31350]; // 20201123
    Tv[116 + k] := Lnn[31400];
    // Tv[118+k]:= Lnn[315];
    Tv[120 + k] := Lnn[31600];
    Tv[194 + k] := Lnn[31217];
    Tv[122 + k] := Lnn[31800];
    Tv[124 + k] := Lnn[31900];
    Tv[126 + k] := Lnn[32300];
    Tv[128 + k] := Lnn[32400];
    Tv[130 + k] := Lnn[32600];
    Tv[132 + k] := Lnn[33200];
    // Tv[134 + k] := Lnn[346];//20200102
    Tv[136 + k] := Lnn[34900]; // 20200131
    Tv[138 + k] := Lnn[35000]; // 20200131
    // tax payable
    Tv[142 + k] := Lnn[40425];
    Tv[144 + k] := Lnn[40427];
    Tv[146 + k] := vl(FetchElm(RNo, 'T1', 53));
    // Vl(FetchElm(RNo, 'S1', 110)); //20191220  surtax
    Tv[148 + k] := vl(FetchElm(RNo, 'T1', 82)); // fed for tx cr
    Tv[150 + k] := Lnn[40600];
    Tv[152 + k] := Lnn[41000];
    Tv[154 + k] := Lnn[41200];
    Tv[156 + k] := Lnn[41400];
    Tv[229 + k] := Lnn[41700];
    Tv[158 + k] := Lnn[41800];
    Tv[160 + k] := Lnn[42000]; // 20200204
    Tv[162 + k] := Lnn[42800];
    Tv[164 + k] := Lnn[42100]; // 20200216
    Tv[166 + k] := Lnn[42200]; // 20200216
    Tv[168 + k] := Lnn[43500];
    // ref credits
    Tv[170 + k] := Lnn[43700];
    Tv[172 + k] := Lnn[44800];
    Tv[174 + k] := Lnn[45000];
    Tv[176 + k] := Lnn[45200];
    Tv[219 + k] := Lnn[45300];
    Tv[242 + k] := Lnn[45350]; // 20201215

    Tv[178 + k] := Lnn[45400];
    Tv[180 + k] := Lnn[45600];
    Tv[182 + k] := Lnn[45700];
    // Tv[242 + k] := Lnn[459]; // //20200102 20160220 //20160223 Igor
    Tv[184 + k] := Lnn[47900];
    Tv[186 + k] := Lnn[47600];
    Tv[188 + k] := Lnn[48200]; // 20200312
    // balance
    Tv[190 + k] := Lnn[48500];
    Tv[192 + k] := Lnn[48400];
    // ctb, gstc
    Tv[235 + k] := vl(FetchElm(RNo, 'CTB', 70));

    If UpperCase(FetchElm(RNo, 'GSTC', 31)) = 'Y' then
      // 20150218  Show GST credit
      Tv[237 + k] := vl(FetchElm(RNo, 'GSTC', 22))
    Else
      Tv[237 + k] := 0;
  end;
end;

procedure DON(RetNo: integer; FName: String; FNo: integer);
Var
  Cn, Us, CnCf, UsCf, TotCf, MaxDon, Remaining,x: Real;
  SpRetNo, i, S9FNo: integer; // ,S9FNo: integer; //20171226
begin
  S9FNo := GetFormNo('S9');
  LoadTv(RetNo, FName, FNo);
  CnCf := 0;
  UsCf := 0;
  SpRetNo := 0;
  With ret[RetNo].Frm[FNo] do
  begin
    // ditto handling
    i := 22;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 6];
      Inc(i, 6);
    until i > 82;

    If IsDitto(Strings[8]) then
      Strings[8] := Strings[3];
    If IsDitto(Strings[13]) then
      Strings[13] := Strings[8];
    i := 19;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 6];
      Inc(i, 6);
    until i > 85;

    If (ret[RetNo].MarStatus > 2) and (vl(Strings[179]) = 0) then
    begin
      If (ret[RetNo].MarStatus = 3) and MarStatusChanged(RetNo) then // 20110326
        // do not do anything
      else
        Tv[179] := 100;
    end;

    // if Strings[187]>'' then Strings[179]:='100'; //20170225    Force on this spousen out again

    If Tv[179] > 100 then
      Strings[179] := '100'; // Tv[179]:=100;  //20170225

    Tv[1] := ret[RetNo].T4Don + ret[RetNo].T4ADon + ret[RetNo].T5013Don;
    Strings[6] := 'Y';
    If ret[RetNo].CouplingSw = True then
    begin
      SpRetNo := GetSpRetNo(RetNo);
      If SpRetNo > 0 then
        Tv[11] := ret[SpRetNo].T4Don + ret[SpRetNo].T4ADon +
          ret[SpRetNo].T5013Don;
    end;
    Cn := 0;
    Us := 0;
    If Strings[2] > '' then
      Strings[2] := ''; { no us for slips }
    If Strings[7] > '' then
      Strings[7] := '';
    Cn := Tv[1] + Tv[11];
    i := 17;
    Repeat { first column }
      If UpperCase(Strings[i + 1]) = 'X' then
        Us := Us + Tv[i]
      else
        Cn := Cn + Tv[i];
      Inc(i, 6);
    Until i > 83;

    i := 4;
    Repeat { Second column }
      If UpperCase(Strings[i + 1]) = 'X' then
        Us := Us + Tv[i]
      else
        Cn := Cn + Tv[i];
      Inc(i, 5);
    Until i > 14;

    i := 20;
    Repeat { Second column }
      If UpperCase(Strings[i + 1]) = 'X' then
        Us := Us + Tv[i]
      else
        Cn := Cn + Tv[i];
      Inc(i, 6);
    Until i > 86;

    Tv[180] := MaxR(0, Cn - Tv[182]); // 20191212
    Tv[181] := Us;
    // 20171226
    // S9FNo:=GetFormNo('S9');
    // Tv[183]:= Vl(FetchElmFNo(RetNo,S9FNo,18))+Vl(FetchElmFNo(RetNo,S9FNo,19))+Vl(FetchElmFNo(RetNo,S9FNo,20));

    Tv[177] := TotMultiple(RetNo, 'DONSUPL', 175);
    Tv[178] := TotMultiple(RetNo, 'DONSUPL', 176);
    Tv[186] := Tv[182] + Tv[183];
    // 20171226
    Tv[184] := Tv[180] + Tv[177] + Tv[186] + Tv[7] + Tv[187]; // 20191212
    // Tv[184] := Tv[180] + Tv[177] + Tv[183] + Tv[7] + Tv[187]; // 20150311
    Tv[185] := Tv[181] + Tv[178] + Tv[188] + Tv[189] + Tv[190];

    Tv[175] := Tv[184] * Tv[179] / 100;
    Tv[176] := Tv[185] * Tv[179] / 100;
    Cn := Tv[175];
    Us := Tv[176];
    Tv[88] := Tv[175]+Tv[176]; //Cn + Us;  //20260405
    // cultural gifts
    Tv[170] := ret[RetNo].T5013Gifts;
    Tv[172] := Tv[169] + Tv[170] + Tv[171];
    If Tv[173] > Tv[172] then
      Tv[173] := Tv[172];
    Tv[174] := MaxR(0, Tv[172] - Tv[173]);

    { PRIOR YEARS }
    Strings[135] := GetPrvYear(AppYear, 5);
    Strings[140] := GetPrvYear(AppYear, 4);
    Strings[89] := GetPrvYear(AppYear, 3);
    Strings[94] := GetPrvYear(AppYear, 2);
    Strings[99] := GetPrvYear(AppYear, 1);
    Strings[104] := AppYear;

    { current year row }
    Tv[105] := Tv[88];

    // If UpperCase(Strings[134])<>'Y' then Tv[106]:=Vl(FetchElm(RetNo,'S9',12)); //20210219

    Tv[143] := 0;
    Tv[92] := 0;
    Tv[97] := 0;
    Tv[102] := 0; // disallow Expiry on other years //20130224

    { get portion applied from each year }
    x:=CalcMaxDonations(RetNo);
    Remaining := MinR(CalcMaxDonations(RetNo), MaxR(0, Tv[136] - Tv[138]) +
      Tv[141] + Tv[90] + Tv[95] + Tv[100] + Tv[105]);

    Remaining := MinR(Remaining,Tv[147]); //ret[RetNo].Lnn[23600] * 0.75); //20210301
    //Remaining := MinR(Remaining, Tv[127]); // max calculated   //20210221 //put back

    i := 136;
    Repeat
      if Tv[137]<0 then Tv[137]:=0; //20210228

      if Tv[141]=0 then Tv[142]:=0; //20210221
      if Tv[i+1]>Tv[i] then Tv[i+1]:=Tv[i]; //2021022
      If Tv[i] < Remaining then
      begin
        If UpperCase(Strings[134]) <> 'Y' then
        Begin
          Tv[i + 1] := Tv[i];
          If i = 136 then
            Tv[i + 1] := MaxR(0, Tv[i] - Tv[i + 2]); // 20130224
          if Tv[137]<0 then Tv[137]:=0; //20210228
        end;
        Remaining := Remaining - Tv[i + 1];
      end
      else
      begin
        If UpperCase(Strings[134]) <> 'Y' then
          Tv[i + 1] := Remaining;
        Remaining := 0;
      end;
      Inc(i, 5);
    until i > 141;

    i := 90;
    Repeat
      If Tv[i] < Remaining then
      begin
        If UpperCase(Strings[134]) <> 'Y' then
          Tv[i + 1] := Tv[i];
        Remaining := Remaining - Tv[i + 1];
      end
      else
      begin
        If UpperCase(Strings[134]) <> 'Y' then
          Tv[i + 1] := Remaining;
        Remaining := 0;
      end;
      Inc(i, 5);
    until i > 105;

    { prior year : Horizontal }

    i := 136;
    Repeat
      Tv[i + 3] := MaxR(0, Tv[i] - Tv[i + 1] - Tv[i + 2]);
      Inc(i, 5);
    until i > 141;

    i := 90;
    Repeat
      Tv[i + 3] := MaxR(0, Tv[i] - Tv[i + 1] - Tv[i + 2]);
      Inc(i, 5);
    until i > 105;

    { prior year : Vertical }

    Tv[109] := AddColumns(136, 141, 5) + AddColumns(90, 105, 5);
    Tv[110] := AddColumns(137, 142, 5) + AddColumns(91, 106, 5);
    Tv[111] := AddColumns(138, 143, 5) + AddColumns(92, 107, 5);
    Tv[112] := AddColumns(139, 144, 5) + AddColumns(93, 108, 5);

    //20210315
    If Tv[191] > MinR(Vl(FetchElmFNo(RetNo,S9FNo,40)),Vl(FetchElmFNo(RetNo,S9FNo,8))) then
        Tv[191]:=MinR(Vl(FetchElmFNo(RetNo,S9FNo,40)),Vl(FetchElmFNo(RetNo,S9FNo,8)));

    { Calculate credit }
    Tv[113] := Tv[175]; //Tv[106]; //Experimental
    Tv[114] := Tv[176];
    Tv[115] := Tv[113] + Tv[114];
    // 20130224  reduce by expired the oldest year

    Tv[118] := MaxR(0, Tv[136] - Tv[138]) + Tv[142] + Tv[91] + Tv[96] + Tv[101]; //20210304
   // Tv[118] := MaxR(0, Tv[136] - Tv[138]) + Tv[141] + Tv[90] + Tv[95] + Tv[100]; //20210304


    Tv[116] := MaxR(0, Tv[118] - Tv[117]);

    Tv[119] := Tv[113] + Tv[116];
    Tv[120] := Tv[114] + Tv[117];
    Tv[121] := Tv[115] + Tv[118];
    Tv[124] := ret[RetNo].Lnn[23600];
    Tv[122] := MaxR(0, Tv[124] - Tv[123]);
    If IsDeceased(RetNo) = False then
    Begin
      Tv[145] := Tv[122] * 75 / 100;
      Tv[146] := Tv[123] * 75 / 100;
    end
    else
    Begin // do not restrict if deceased  //20131215
      Tv[145] := Tv[122];
      Tv[146] := Tv[123];
    end;

    Tv[147] := Tv[145] + Tv[146];
    Tv[150] := Tv[148] + Tv[149];
    Tv[153] := Tv[151] + Tv[152];
    Tv[156] := Tv[154] + Tv[155];
    Tv[157] := MaxR(0, Tv[148] + Tv[151] - Tv[154]);
    Tv[158] := MaxR(0, Tv[149] + Tv[152] - Tv[155]);
    Tv[159] := Tv[157] + Tv[158];
    Tv[160] := Tv[157] * 25 / 100;
    Tv[161] := Tv[158] * 25 / 100;
    Tv[162] := Tv[160] + Tv[161];
    Tv[165] := Tv[163] + Tv[164];
    Tv[166] := Tv[163] * 25 / 100;
    Tv[167] := Tv[164] * 25 / 100;
    Tv[168] := Tv[166] + Tv[167];

    Tv[125] := vl(FetchElm(RetNo, 'S9', 26)); // 20210219

    Tv[126] := Tv[146] + Tv[161] + Tv[167];
    If ret[RetNo].Deceased then
    begin
      Tv[125] := Tv[122];
      Tv[126] := Tv[123];
    end;


    MaxDon := CalcMaxDonations(RetNo);
    Tv[128]:=Vl(FetchElm(RetNo,'S9',12));  //20210227   Tv[128] := MinR(Tv[110], MinR(Tv[119], MaxDon));

    Tv[129] := MinR(Tv[120], Tv[126]); // 200090117
    // Tv[130] :=Tv[110];
    // Tv[129] := MaxR(0,Tv[130]-Tv[128]);
    Tv[130] := Tv[128] + Tv[129];

    Ret[RetNo].Lnn[34900]:=Tv[130]; //20210221

    //20210301
    Tv[131] :=Tv[112];
    Tv[132] :=0;
    Tv[133] := Tv[131] + Tv[132];


    {
    Tv[131] := MaxR(0, Tv[119] - Tv[128]);
    Tv[132] := MaxR(0, Tv[120] - Tv[129]);
    Tv[133] := Tv[131] + Tv[132];
    }
    { cultural,ecological }
    Tv[135] := ret[RetNo].T5013Gifts;
    Tv[140] := Tv[135] + Tv[137] + Tv[139];
  end; { End with }
  SaveTv(RetNo, FName, FNo);

  If (ret[RetNo].CouplingSw) and (OptimizeBtnClicked = False) then
  begin
    StoreElm(RetNo, GetFormNo('OPTIMIZE'), 9, FormatFloat('###.##', ret[RetNo].Frm[FNo].Tv[179]));
    StoreElm(RetNo, GetFormNo('OPTIMIZE'), 12,
      FormatFloat('###.##', 100 - ret[RetNo].Frm[FNo].Tv[179]));
  end;
  // 20170226
  If (ret[RetNo].CouplingSw) and (GetSpRetNo(RetNo) > 0) then
  begin
    SpRetNo := GetSpRetNo(RetNo);
    If ret[SpRetNo].Frm[FNo].Count = 0 then
      InitFormData(SpRetNo, FNo);
    StoreElm(SpRetNo, FNo, 179, FormatFloat('###.##',
      100 - vl(ret[RetNo].Frm[FNo].Strings[179])));
  end;

end;


procedure DONSUPL(RetNo: integer; FName: String; FNo: integer);
Var
  Cn, Us, CnCf, UsCf, TotCf, Remaining: Real;
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  CnCf := 0;
  UsCf := 0;
  with ret[RetNo].Frm[FNo] do
  begin
    // ditto handling
    i := 4;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 3];
      Inc(i, 3);
    until i > 182;

    Cn := 0;
    Us := 0;
    i := 2;
    Repeat { first column }
      If UpperCase(Strings[i + 1]) = 'X' then
        Us := Us + Tv[i]
      else
        Cn := Cn + Tv[i];
      Inc(i, 3);
    Until i > 173;
    Tv[175] := Cn;
    Tv[176] := Us;
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure RRSP(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer; // 20160119 Igor
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Tv[3] := Round(Tv[2] * 0.18);
    Tv[4] := Constant[RY].RSPLimit;
    Tv[5] := MinR(Tv[3], Tv[4]);
    Tv[6] := Tv[5];
    If Tv[7] < 0 then
      Tv[7] := 0;
    Tv[13] := MaxR(0, Tv[6] - Tv[7]);
    Tv[15] := Tv[13] + Tv[14];
    Tv[16] := Tv[15] + Tv[10];
    Tv[12] := Tv[16] - Tv[8]; // MaxR(0,Tv[16] - Tv[8]);

    If Tv[1] <> 0 then
    begin
      Tv[11] := Tv[1];
      Tv[12] := Tv[1];
    end
    else
      Tv[11] := Tv[12];
    If Tv[11] < 0 then
      Tv[11] := 0;

    Tv[40] := 0;
    Tv[41] := 0;
    i := 17;
    Repeat
      Tv[i + 2] := Tv[i] + Tv[i + 1];
      Tv[40] := Tv[40] + Tv[i];
      Tv[41] := Tv[41] + Tv[i + 1];
      Inc(i, 4);
    until i > 37;
    Tv[42] := Tv[40] + Tv[41];

    Tv[67] := 0;
    Tv[68] := 0;
    i := 44;
    Repeat
      Tv[i + 2] := Tv[i] + Tv[i + 1];
      Tv[67] := Tv[67] + Tv[i];
      Tv[68] := Tv[68] + Tv[i + 1];
      Inc(i, 4);
    until i > 64;
    Tv[69] := Tv[67] + Tv[68];
    Tv[70] := Tv[42] + Tv[69];

    // HBP
    If Tv[80] > 35000 then Tv[80] := 35000; // 20210318
    //If Tv[80] > 25000 then Tv[80] := 25000; // 20110304

    Tv[82] := MaxR(0, Tv[80] - Tv[81]);
    If vl(Strings[83]) > 15 then
      Strings[83] := '15';
    If vl(Strings[83]) < 0 then
      Strings[83] := '';

    If UpperCase(LeftStr(Strings[88], 1)) <> 'Y' then
    begin
      If vl(Strings[83]) > 0 then
        Tv[72] := Round(Tv[82] / vl(Strings[83]))
      else
        Tv[72] := 0;
    end;
    If IsPreBankruptcyReturn(RetNo) then
      Tv[73] := 0;
    Tv[74] := MaxR(0, Tv[72] - Tv[73]);
    If IsPreBankruptcyReturn(RetNo) then
      Tv[74] := 0;

    // llp
    If Tv[84] > 20000 then Tv[84] := 20000;
    Tv[86] := MaxR(0, Tv[84] - Tv[85]);
    If vl(Strings[87]) > 10 then
      Strings[87] := '10';
    If vl(Strings[87]) < 0 then
      Strings[87] := '';
    If UpperCase(Strings[88]) <> 'Y' then
    begin
      If vl(Strings[87]) > 0 then
        Tv[75] := Round(Tv[86] / vl(Strings[87]))
      else
        Tv[75] := 0;
    end;
    If IsPreBankruptcyReturn(RetNo) then
      Tv[76] := 0;
    Tv[77] := MaxR(0, Tv[75] - Tv[76]);
    If IsPreBankruptcyReturn(RetNo) then
      Tv[77] := 0;

    // calc new HBP balance
    Tv[90] := Tv[82]; // + TotMultiple(RetNo, 'T4RSP', 21); //20230512
    Tv[92] := Tv[73] + Tv[74];
    Tv[96] := Tv[90] - Tv[92] + Tv[94];

    // calc new LLP balance
    Tv[89] := Tv[86] + TotMultiple(RetNo, 'T4RSP', 7);
    Tv[91] := Tv[76] + Tv[77];
    Tv[95] := Tv[89] - Tv[91] + Tv[93];

    Strings[78] := 'S7';
    // info from Autofill //20180215
    Tv[183] := 0;
    Tv[184] := 0;
    i := 136;
    Repeat
      Tv[183] := Tv[183] + Tv[i];
      Tv[184] := Tv[184] + Tv[i + 1];
      Inc(i, 5);
    Until i > 181;

  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure RRSPNXT(RetNo: integer; FName: String; FNo: integer);
Var
  T1FNo: integer;
begin
  // 20101213
  T1FNo := GetFormNo('T1');
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin

    Tv[2] := vl(FetchElmFNo(RetNo, T1FNo, 203)) +
      vl(FetchElmFNo(RetNo, T1FNo, 205)) + vl(FetchElmFNo(RetNo, T1FNo, 215)) +
      vl(FetchElmFNo(RetNo, T1FNo, 217)) + vl(FetchElmFNo(RetNo, T1FNo, 222)) +
      vl(FetchElmFNo(RetNo, T1FNo, 224)) + vl(FetchElmFNo(RetNo, T1FNo, 226)) +
      vl(FetchElmFNo(RetNo, T1FNo, 228)) + vl(FetchElmFNo(RetNo, T1FNo, 230)) +
      vl(FetchElm(RetNo, 'T4AP#1', 13));
    Tv[2] := Tv[2] - vl(FetchElmFNo(RetNo, T1FNo, 306)) -
      vl(FetchElmFNo(RetNo, T1FNo, 312)) - vl(FetchElmFNo(RetNo, T1FNo, 315));

    Tv[3] := Round(Tv[2] * 0.18);
    Tv[4] := 33810; //Constant[1].RSPLimit;  //20251119
    Tv[5] := MinR(Tv[3], Tv[4]);
    Tv[6] := Tv[5];
    Tv[7] := vl(FetchElmFNo(RetNo, T1FNo, 302));
    Tv[9] := MaxR(0, Tv[6] - Tv[7]);
    Tv[16] := Tv[9] + Tv[15];
    Tv[10] := vl(FetchElm(RetNo, 'S7', 20));
    Tv[17] := MaxR(0, Tv[16] + Tv[10]);
    Tv[11] := MaxR(0, Tv[17] - Tv[8]);

    Tv[13] := vl(FetchElm(RetNo, 'S7', 10));
    Tv[14] := MaxR(0, Tv[11] - Tv[13]);
    If ret[RetNo].Age + 1 > 71 then
      Tv[14] := 0;
    If Tv[1] > 0 then
      Tv[14] := Tv[1];
  end; { with }
  SaveTv(RetNo, FName, FNo);
end;

procedure RPP(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);

  with ret[RetNo].Frm[FNo] do
  begin
    { ? deceased individual }
    Tv[1] := ret[RetNo].T4Rpp + ret[RetNo].T4ARpp;
    Tv[30] := Tv[1] + Tv[31] + Tv[29];
    Tv[2] := ret[RetNo].T4PastRppW + ret[RetNo].T4PastRppWNot + ret[RetNo]
      .T4APastRppW + ret[RetNo].T4APastRppWNot;
    Tv[3] := MaxR(0, Tv[30] - Tv[2]);

    // Tv[4]:= TotMultiple(RetNo,'T4',30)+Tv[32];
    Tv[4] := TotMultiple(RetNo, 'T4', 30) + Tv[32] + TotMultiple(RetNo, 'T4A',
      37); // 20110414
    Tv[6] := 3500;
    Tv[8] := MaxR(0, Tv[4] - Tv[5]);
    Tv[9] := vl(Strings[7]) * 3500;
    Tv[10] := Tv[5];
    Tv[11] := MaxR(0, Tv[9] - Tv[10]);
    Tv[12] := MinR(MinR(Tv[8], Tv[6]), Tv[11]);
    Tv[33] := MaxR(0, Tv[8] - Tv[12]);

    Tv[13] := TotMultiple(RetNo, 'T4', 29) + Tv[34] + TotMultiple(RetNo, 'T4A',
      26); // 20110414
    // Tv[13]:= TotMultiple(RetNo,'T4',29)+Tv[34];
    Tv[15] := MaxR(0, Tv[13] - Tv[14]);
    Tv[16] := Tv[15];
    Tv[17] := 3500;
    Tv[18] := Tv[3];
    Tv[19] := Tv[12];
    Tv[20] := Tv[18] + Tv[19];
    Tv[21] := Tv[20];
    Tv[22] := MaxR(0, Tv[17] - Tv[21]);
    Tv[23] := Tv[22];
    Tv[24] := MinR(Tv[16], Tv[23]);
    Tv[35] := MaxR(0, Tv[16] - Tv[24]);
    Tv[25] := Tv[3];
    Tv[26] := Tv[12];
    Tv[27] := Tv[24];
    Tv[28] := Tv[25] + Tv[26] + Tv[27];
  end; { End with }
  SaveTv(RetNo, FName, FNo);

end;

procedure ACBOTHR(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    i := 1;
    repeat
      Tv[i + 6] := Tv[i + 2] + Tv[i + 5];
      i := i + 9;
    until i > 109;

  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure STATUS(RetNo: integer; FName: String; FNo: integer);
Var
  i, k: integer; // EfErr:TstringList;EfErrFile:string;  20140126
begin
  with ret[RetNo].Frm[FNo] do
  begin
    If Strings[17] > '' then
      Strings[32] := '**********'; // to cover the psw
    // EfErr := TstringList.Create;
    Strings[1] := GetLastName(RetNo) + ', ' + GetFirstName(RetNo);
    Strings[3] := GetSinNo(RetNo);
    Strings[4] := ret[RetNo].PrpStatus;
    Strings[35] := GetPrpStatusDescr(Strings[4]);
    Strings[15] := ret[RetNo].EfStatus;
    Strings[36] := GetEfStatusDescr(Strings[15]);

    If Strings[5] = '' then
      Strings[5] := Strings[11];
    If Strings[6] = '' then
      Strings[6] := Strings[12];
    If Strings[7] = '' then
      Strings[7] := Strings[13];

    (* 20140126
      If FetchEfMethod(RetNo) = 'PROP' then
      begin
      For i:=24 to 29 do Strings[i] :=''; {remove old error codes}
      EfErrFile := OptRec.Ef_DataDir+'\'+LeftStr(GetSinNo(RetNo),8)+
      '.'+RightStr(GetSinNo(RetNo),1)+'EF';
      If FileExists(EFErrFile) then
      begin
      EfErr.LoadFromFile(EfErrFile);
      k:=24;i:=0;
      Repeat
      Strings[k] := EfErr[i];
      Inc(k);Inc(i);
      until (K>29) or (i>EfErr.Count-1);
      end;
      end;
    *)

  end; { End with }
  // EfErr.Free;  //20140126
  { SaveTv(RetNo,FName,FNo); }
end;

procedure FLTHRU(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  TotCapGain, TotReduction, BfrBusDed: Real;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    i := 51;
    Tv[151] := 0;
    Tv[152] := 0;
    repeat
      TotCapGain := Tv[i + 1] + Tv[i + 2];
      Tv[i + 3] := MinR(Tv[i], TotCapGain);
      Tv[151] := Tv[151] + Tv[i + 3];
      BfrBusDed := MaxR(0, Tv[i] - Tv[i + 3]);
      If UpperCase(Strings[i + 4]) = 'X' then
      begin
        Tv[i + 5] := BfrBusDed * 1 / 2;
        Tv[i + 7] := MinR(Tv[i + 5], Tv[i + 6]);
        Tv[152] := Tv[152] + Tv[i + 7];
        Tv[i + 8] := Tv[i + 7] * 2;
      end
      else
      begin
        Tv[i + 5] := 0;
        Tv[i + 7] := 0;
        Tv[i + 8] := 0;
      end;
      Tv[i + 9] := MaxR(0, BfrBusDed - Tv[i + 8]);
      i := i + 10;
    until i > 141;
    { remove ending balance if property sold }
    For i := 1 to 10 do { 10 properties }
      If Strings[i * 5 - 1] > '' then
        Tv[i * 10 + 50] := 0;
  end; { End with }
  SaveTv(RetNo, FName, FNo);

end;

procedure ABIL(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  x: Real;
  CfrFno: integer; // 20181129
begin
  LoadTv(RetNo, FName, FNo);
  CfrFno := GetFormNo('CFR');
  with ret[RetNo].Frm[FNo] do
  begin
    i := 3;
    Repeat
      { ?ABIL  negative check }
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
      If Tv[i + 3] > 0 then
        Tv[i + 3] := 0;
      Tv[i + 3] := ABS(Tv[i + 3]);
      Inc(i, 6);
    until i > 33;
    Tv[38] := Tv[6] + Tv[12] + Tv[18] + Tv[24] + Tv[30] + Tv[36];
    Tv[66] := Tv[38];
    Tv[67] := Tv[55];
    Tv[68] := MaxR(0, Tv[66] - Tv[67]);
    Strings[71] := '0.50';
    Tv[70] := Tv[68];
    Tv[57] := Tv[70] * vl(Strings[71]);
    if UpperCase(Strings[37]) = 'Y' then
      Tv[57] := Tv[45];
    { reduction }
    Tv[41] := vl(FetchElmFNo(RetNo, CfrFno, 16));
    Tv[43] := vl(FetchElmFNo(RetNo, CfrFno, 17));
    Tv[47] := vl(FetchElmFNo(RetNo, CfrFno, 26)) +
      vl(FetchElmFNo(RetNo, CfrFno, 27));
    Tv[49] := vl(FetchElmFNo(RetNo, CfrFno, 18)) +
      vl(FetchElmFNo(RetNo, CfrFno, 19)) + vl(FetchElmFNo(RetNo, CfrFno, 20));
    Tv[59] := vl(FetchElmFNo(RetNo, CfrFno, 36));

    Tv[39] := vl(FetchElmFNo(RetNo, CfrFno, 44)) +
      vl(FetchElmFNo(RetNo, CfrFno, 49)) + vl(FetchElmFNo(RetNo, CfrFno, 56)) +
      vl(FetchElmFNo(RetNo, CfrFno, 62)) + vl(FetchElmFNo(RetNo, CfrFno, 69)) +
      vl(FetchElmFNo(RetNo, CfrFno, 60)) + vl(FetchElmFNo(RetNo, CfrFno, 80)) +
      vl(FetchElmFNo(RetNo, CfrFno, 86)) + vl(FetchElmFNo(RetNo, CfrFno, 91)) +
      vl(FetchElmFNo(RetNo, CfrFno, 96)) + vl(FetchElmFNo(RetNo, CfrFno, 266)) +
      vl(FetchElmFNo(RetNo, CfrFno, 271)) + vl(FetchElmFNo(RetNo, CfrFno, 276))
      + vl(FetchElmFNo(RetNo, CfrFno, 281)) + vl(FetchElmFNo(RetNo, CfrFno, 286))
      + vl(FetchElmFNo(RetNo, CfrFno, 291)) // 20181112
      + vl(FetchElmFNo(RetNo, CfrFno, 296)) + vl(FetchElmFNo(RetNo, CfrFno, 301))   // 20201017
      //20231111
      + vl(FetchElmFNo(RetNo, CfrFno, 306))
      + vl(FetchElmFNo(RetNo, CfrFno, 311))
      + vl(FetchElmFNo(RetNo, CfrFno, 316))
      + vl(FetchElmFNo(RetNo, CfrFno, 321))
      + vl(FetchElmFNo(RetNo, CfrFno, 326))   //20251115
      + vl(FetchElmFNo(RetNo, CfrFno, 330))
      ;

    Tv[42] := Tv[41] * 2;
    Tv[44] := Tv[43] * 3 / 2;
    Tv[48] := Tv[47] * 3 / 2;
    Tv[50] := Tv[49] * 4 / 3;
    Strings[61] := FormatFloat('#0.00000',
      vl(FetchElmFNo(RetNo, CfrFno, 40)) / 100);

    Tv[60] := (Tv[59]/50)*100; // 20250331   * (1 / vl(Strings[61]))
    {
    If vl(Strings[61]) > 0 then
      Tv[60] := Tv[59] * (1 / vl(Strings[61]))
    else
      Tv[60] := 0;
    }
    Tv[40] := Tv[39] * 2;

    Tv[51] := Tv[42] + Tv[44] + Tv[48] + Tv[50] + Tv[60] + Tv[40];

    Tv[53] := Tv[73] + Tv[74] + Tv[75] + Tv[62] + Tv[46];
    Tv[54] := Tv[53];
    Tv[56] := MaxR(0, Tv[51] - Tv[54]);

    Tv[65] := MinR(Tv[66], Tv[56]);
    //Tv[52]:=MaxR(0,Tv[65]-Tv[55]);   //20251115
    Tv[55] := Tv[65];
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure AJCTC(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  x: Real;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    i := 3;
    Tv[101] := 0;
    Tv[102] := 0;
    Repeat
      Tv[i + 1] := MinR(20000, Tv[i]);
      Tv[i + 2] := Tv[i + 1] * 0.10;
      Tv[101] := Tv[101] + Tv[i + 1];
      Tv[102] := Tv[102] + Tv[i + 2];
      Inc(i, 5);
    until i > 98;
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure UNIOND(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo], ret[RetNo].Frm[FNo] do
  Begin
    Tv[1] := T4Union;
    Tv[14] := Tv[1];
    i := 3;
    repeat
      Tv[14] := Tv[14] + Tv[i];
      i := i + 2;
    until i > 13;
    Lnn[21200] := Tv[14];
  end;
  SaveTv(RetNo, FName, FNo);
end;

procedure NPAD(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  Begin
    Strings[1] := GetLastName(RetNo) + ', ' + GetFirstName(RetNo);
    Strings[2] := AppYear;
    Strings[4] := GetSinNo(RetNo);
  end;
  SaveTv(RetNo, FName, FNo);
end;

procedure NPADC(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  Begin
    Strings[1] := AppYear;
    Strings[2] := GetLastName(RetNo) + ', ' + GetFirstName(RetNo);
    Strings[3] := GetSinNo(RetNo);
    If Tv[30] = 0 then
      Tv[30] := 100;
    If Tv[58] = 0 then
      Tv[58] := 100;
    If Tv[75] = 0 then
      Tv[75] := 100;
    Tv[29] := 0;
    i := 6;
    Repeat
      Tv[29] := Tv[29] + Tv[i];
      Inc(i, 2);
    until i > 28;
    Tv[31] := Tv[29] * Tv[30] / 100;

    Tv[57] := 0;
    i := 34;
    Repeat
      Tv[57] := Tv[57] + Tv[i];
      Inc(i, 2);
    until i > 56;
    Tv[59] := Tv[57] * Tv[58] / 100;

    Tv[74] := 0;
    i := 61;
    Repeat
      Tv[74] := Tv[74] + Tv[i];
      Inc(i, 2);
    until i > 73;
    Tv[76] := Tv[74] * Tv[75] / 100;
  end;
  SaveTv(RetNo, FName, FNo);
end;

procedure ADDINFO(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo] do
  Begin
    Frm[FNo].Strings[31] := FetchElm(RetNo, 'INFO', 2) + ', ' +
      FetchElm(RetNo, 'INFO', 5);
    ret[RetNo].Frm[FNo].Strings[1] := OptRec.Prp_Name;
    If ret[RetNo].Frm[FNo].Strings[2] = '' then
    begin
      ret[RetNo].Frm[FNo].Strings[2] := User.Prep_Name; // 20170112 Igor
      // If LeftStr(LicenseLevel,8) <> 'T1 Multi' then
      If LicenseLevel in anyMulti then // 20160119 Igor
        ret[RetNo].Frm[FNo].Strings[2] := User.UserName; // 20170112 Igor
    end;
  end;
  SaveTv(RetNo, FName, FNo);
end;

procedure OTHEMPL(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo], ret[RetNo].Frm[FNo] do
  Begin
    { ? only one entry from T4A in othempl }
    Tv[1] := T4AOthEmpl;
    Tv[2] := T5OthEmpl;
    // 20110507 //TotMultiple(RetNo,'T4A',35); obsolete  //20110118  not needed
    Tv[3] := TotMultiple(RetNo, 'T4PS', 5); { box 35 }
    Tv[10] := TotMultiple(RetNo, 'T4', 19);
    Tv[11] := Tv[17] + Tv[19] + Tv[21];
    Tv[16] := 0;
    Tv[16] := Tv[1];

    // 20151024
    i := 2; // 20110507;
    Repeat
      Tv[16] := Tv[16] + Tv[i];
      Inc(i);
    until i > 6; // skip director fees [7]
    i := 8; // 20110507;
    Repeat
      Tv[16] := Tv[16] + Tv[i];
      Inc(i);
    until i > 10;

    { //20151024
      i :=2; // 20110507;
      Repeat
      Tv[16] := Tv[16] +Tv[i];
      Inc(i);
      until i >10;
    }

    Tv[16] := Tv[16] + Tv[11] + Tv[13] + Tv[15];
  end;
  SaveTv(RetNo, FName, FNo);
end;

procedure DEPEND(RetNo: integer; FName: String; FNo: integer); // 20181222 jjj
Var
  i, j, jj, J2, J3, j4, j5, j6, j7, k, K1, K2, K3, RNo, Less18, SpRetNo, jjj,
    Infirm18Orless, InfirmEq18, EquivSpouse, Over18Infirm: integer;
  OntInfirmOver18: integer;
  T1206FNo: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  Begin
    If Tv[160] > 100 then
      Tv[160] := 100;
    // If Strings[161]='' then Strings[161]:='Y';
    If Strings[38] = '' then
      Strings[38] := 'N';
    If (Strings[23] = 'Y') or (Strings[23] = 'N') then
      // {ok}
    else
      Strings[23] := 'N';
    If Strings[24] = '' then
      Strings[24] := 'N';
    If Tv[160] > 0 then
      Strings[140] := 'Y'; // Feb 2008
    Less18 := 0;
    Infirm18Orless := 0;
    InfirmEq18 := 0;
    EquivSpouse := 0;
    Over18Infirm := 0;
    OntInfirmOver18 := 0; // 20180310
    { count dependants }
    i := 5;
    j := 263;
    jj := 172;
    J2 := 163;
    J3 := 191;
    j4 := 141;
    j5 := 150;

    T1206FNo := GetFormNo('T1206'); // 20181223
    jjj := 301;
    Repeat
      If (Strings[i] > '') then
      begin
        // Load TOSI
        Strings[jjj] := Strings[i]; // first name
        Strings[jjj + 1] := GetLastName(RetNo); // Last name
        RNo := FindReturnNoFromSin(Strings[i + 2]);
        If RNo > 0 then // coupling return
        Begin
          Tv[jjj + 2] := vl(FetchElmFNo(RNo, T1206FNo, 3)); // spli income
          Tv[jjj + 3] := vl(FetchElmFNo(RNo, T1206FNo, 4)); // TOSI Net Inc
          Tv[jjj + 4] := vl(FetchElmFNo(RNo, T1206FNo, 43));
          // TOSI Fed txbl Inc
          Tv[jjj + 5] := vl(FetchElmFNo(RNo, T1206FNo, 64)); // 201812125
        End;

        // ----
        Strings[jj] := Strings[i]; // Last name
        If Strings[i + 1] = '' then
          Strings[i + 1] := GetLastName(RetNo);
        Strings[i + 2] := RemoveChar(Strings[i + 2], '-'); // sin
        If Strings[i + 9] = '' then
          Strings[i + 9] := FetchElm(RetNo, 'INFO', 6); { Str }
        If Strings[i + 10] = '' then
          Strings[i + 10] := FetchElm(RetNo, 'INFO', 10); { city }
        If Strings[i + 12] = '' then
          Strings[i + 12] := FetchElm(RetNo, 'INFO', 14); { prov }
        If Strings[i + 13] = '' then
          Strings[i + 13] := FetchElm(RetNo, 'INFO', 15); { Str }
      end
      Else // 20111114
      begin
        Strings[i + 1] := '';
        Strings[i + 2] := '';
        Strings[i + 9] := '';
        Strings[i + 5] := '';
        Strings[i + 6] := '';
        Strings[i + 7] := '';
        Tv[i + 8] := 0;
        Strings[i + 10] := '';
        Strings[i + 11] := '';
        Strings[i + 12] := '';
        Strings[i + 13] := '';
        Strings[i + 14] := '';
        // other columns
        Strings[j] := '';
        Strings[jj] := '';
        Strings[J2] := '';
        Strings[J3] := '';
        Strings[j4] := '';
        Tv[j5] := 0;

        Strings[jjj] := '';
        Strings[jjj + 1] := '';
        Tv[jjj + 2] := 0;
        Tv[jjj + 3] := 0;
        Tv[jjj + 4] := 0;
      end;
      // April 4 2008 and 20090516
      If UpperCase(Strings[140]) <> 'Y' then
        Strings[i + 14] := 'N'; // elig
      // 20130301
      If (UpperCase(Strings[i + 7]) = 'Y') or (UpperCase(Strings[i + 7]) = 'N')
        or (UpperCase(Strings[i + 7]) = '') then
        // ok
      Else If Length(Strings[i + 7]) > 1 then
        Strings[i + 7] := 'Y'; // came from prev yr as description of disability

      If CalcAge(Strings[i + 5]) > 17 then
        Strings[J2] := 'N'; // young kids only
      If Strings[i] > '' then
        Tv[i + 11] := Tv[160]
      else
        Tv[i + 11] := 0;
      If Strings[i + 5] > '' then { birthdate }
      begin
        If Strings[i + 6] = '' then
          Strings[i + 6] := 'Child';

        If CalcAge(Strings[i + 5]) <= 18 then
        begin
          If (Strings[i + 6] = 'Son') or (Strings[i + 6] = 'Child') or
            (Strings[i + 6] = 'Daughter') or (Strings[i + 6] = 'GrandChild')
          then
            Inc(Less18);
          If (UpperCase(Strings[i + 7]) = 'Y') or (UpperCase(Strings[J3]) = 'Y')
          // disabled
            or (UpperCase(Strings[j4]) = 'Y') // infirm   //20180307
          then
          Begin
            Inc(Infirm18Orless); // 20131220
          end;
          // If UpperCase(Strings[i+7])='Y' then Inc(Infirm18OrLess);
          If (CalcAge(Strings[i + 5]) = 18) and (UpperCase(Strings[i + 7]) = 'Y')
          then
            Inc(InfirmEq18);
        end
        else
        begin
          If UpperCase(Strings[i + 7]) = 'Y' then
            Inc(Over18Infirm);
          if ret[RetNo].Province = 'ON' then // 20180310
          Begin
            if (Strings[i + 7] <> 'Y') and (UpperCase(Strings[j4]) = 'Y') then
              Inc(OntInfirmOver18, 1); // if no disablility but infirm
          End;
        end;

        //??  peculiar
        { equiv to spouse: if 18 or over and not infirm, do not claim unless Parent }
        If (Strings[i + 6] <> 'Parent') and (Strings[i + 6] <> 'GrandParent')
        then // i.e. such as Child
        begin
          // 20130107
          If (CalcAge(Strings[i + 5]) > 18) and
            (UpperCase(Strings[i + 7]) <> 'Y') // disability
            and (UpperCase(Strings[J3]) <> 'Y') // FCA
          then
            Strings[i + 14] := '';
          // if 0ver 18 and not infirm the kill eligible  //20121118  ??
        end;

        {
       //=================  LOGIC FOR CARE GIVER  Createed 20210323 NOT put in production
        // parent, grandparent, brother, sister, aunt, uncle, niece, or nephew
         If (Strings[i + 6] <> 'Parent') and (Strings[i + 6] <> 'GrandParent')
         and (Strings[i + 6] <> 'Brother') and (Strings[i + 6] <> 'Sister')
         and (Strings[i + 6] <> 'Aunt') and (Strings[i + 6] <> 'Uncle')
         and (Strings[i + 6] <> 'Niece') and (Strings[i + 6] <> 'Nephew')
          Then Strings[j4]:='';
         If UpperCase(Strings[j3])<>'Y' then Strings[j4]:='';
         If CalcAge(Strings[i + 5])<19 then  Strings[j4]:='';
      //=================
       }

        If UpperCase(Strings[i + 14]) = 'Y' then
          Inc(EquivSpouse);
        // calc child age //20101207
        If Strings[i + 5] > '' then
          Strings[j] := IntToStr(CalcAge(Strings[i + 5]));
      end;
      i := i + 15;
      j := j + 1;
      jj := jj + 1;
      Inc(J2, 1);
      Inc(J3, 1);
      Inc(j4, 1);
      Inc(j5, 1); // 20121216
      Inc(jjj, 7); // 20181222
    until i > 125;
  end;
  { ? % claim }
  with ret[RetNo].Frm[FNo] do
  begin
    If UpperCase(Strings[38]) <> 'Y' then
    begin
      Strings[1] := IntToStr(Less18);
      Strings[3] := IntToStr(EquivSpouse);
      Strings[2] := IntToStr(Infirm18Orless);
      Strings[4] := IntToStr(Over18Infirm);
      Strings[53] := IntToStr(InfirmEq18);
      // kids for Lines 366 //20121112
      i := 5;
      j := 191; // ndx to FCA
      k := 263; // ndx to age
      K1 := 0;
      K2 := 0;
      K3 := 163; // ndx to Claim on 367
      Strings[201] := 'N'; // 20130105 Elig with FCA
      Repeat
        If MyStrToInt(Strings[k]) < 18 then
        begin
          If (UpperCase(Strings[j]) <> 'Y') and (UpperCase(Strings[K3]) = 'Y')
          then
            K1 := K1 + 1; // fca No, Claim kids=Y
          If (UpperCase(Strings[j]) = 'Y') and (UpperCase(Strings[K3]) = 'Y')
          then
            K2 := K2 + 1; // fca yes, Claim kids=Y
          // 20130105
          If (UpperCase(Strings[i + 14]) = 'Y') and (vl(Strings[k]) <= 18) and
            (UpperCase(Strings[j]) = 'Y') then // Elig <=18 and FCA
            Strings[201] := 'Y';
        end;
        Inc(i, 15);
        Inc(j, 1);
        Inc(k, 1);
        Inc(K3, 1);
      until i > 125;
      Strings[162] := IntToStr(K1); // for line 366
      Strings[54] := IntToStr(K2); // for line 352
    end;

    If UpperCase(Strings[23]) <> 'Y' then
    begin
      Strings[8] := Strings[1];
      Strings[9] := IntToStr(MyStrToInt(Strings[4]) + MyStrToInt(Strings[2]) +
        OntInfirmOver18); // 20180310
      If (MyStrToInt(Strings[8]) + MyStrToInt(Strings[9]) = 0)
      { no dependants entered }
      then { no dependants/no override on this spouse, borrow from other spouse }
      begin
        SpRetNo := GetSpRetNo(RetNo);
        If (SpRetNo > 0) then { spouse exists }
        begin
          Strings[8] := FetchElm(SpRetNo, 'DEPEND', 1);
          // FetchElm(SpRetNo,'DEPEND',8); //20160224
          Strings[9] := FetchElm(SpRetNo, 'DEPEND', 9);
          ret[SpRetNo].FormHasData[GetFormName(SpRetNo, FNo)] := True;
        end;
      end;
    end;
    { bring dependant's net income }
    If UpperCase(Strings[24]) = 'Y' then { fill income switch }
    begin
      i := 7;
      k := 150;
      Repeat
        If Strings[i] > '' then // sin exists
        begin
          RNo := FindReturnNoFromSin(Strings[i]);
          If RNo > 0 then
          begin
            Tv[i + 6] := ret[RNo].Lnn[23600];
            Tv[k] := MaxR(0, ret[RNo].Lnn[26000]);
            If ret[RNo].Lnn[31600] > 0 then
              Strings[i + 5] := 'Y'; // 'Disabled';  //20130306
          end;
        end;
        Inc(i, 15);
        Inc(k, 1)
      until i > 127;
    end;

    { figure out caregiver }
    i := 10;
    k := 141; { birthdate }
    Repeat
      If UpperCase(Strings[k]) = 'Y' then
      begin
        If CareGiverEligible(RetNo, Strings[i], Strings[i + 1], Strings[i + 2],
          vl(Strings[i + 3])) then // 20130601
          // ok
        else
          Strings[k] := '';
        If Strings[i - 5] + Strings[i - 4] = '' then
          Strings[k] := '';
      end;
      Inc(i, 15);
      Inc(k);
    until i > 130;
    // Figure out taxable income
    i := 13; // ndx to net inc
    k := 150; // ndx to taxable
    repeat
      If UpperCase(Strings[24]) <> 'Y' then // do not fill from return
      begin
        If Tv[k] = 0 then
          Tv[k] := Tv[i];
      end;
      Inc(i, 15);
      Inc(k, 1);
    until i > 133;
  end;

  SaveTv(RetNo, FName, FNo);

  If (ret[RetNo].CouplingSw) and (OptimizeBtnClicked = False) then
  begin
    StoreElm(RetNo, GetFormNo('OPTIMIZE'), 34, FormatFloat('###.##', ret[RetNo].Frm[FNo].Tv[160]));
    StoreElm(RetNo, GetFormNo('OPTIMIZE'), 36,
      FormatFloat('###.##', 100 - ret[RetNo].Frm[FNo].Tv[160]));
  end;

end;

Function CalcSpousalClaim(RetNo: integer; Ni: Real): Real;
begin
  // 20121115
  Result := vl(FetchElm(RetNo, 'S5', 7));
end;

// 20110616
Function CalcPRVSpousalClaim(RetNo: integer; Ni: Real): Real;
Var
  x: Real; // InfoFNo:Integer;
begin
  Result := 0;
  If Rule90(RetNo) <90 then //= False then // NI comes as normal, else modify it
  Begin
    If (FetchElmFNo(RetNo, InfoFNo, 215) > '') and
      (vl(FetchElmFNo(RetNo, InfoFNo, 213)) > 0) then
      Ni := vl(FetchElmFNo(RetNo, InfoFNo, 213)); // newcomer spouse  //20131213
  end;
  If (ret[RetNo].MarStatus < 3) or
    (IsSpouseDeceased(RetNo) and (ret[RetNo].MarStatus = 3))
  // allow spousal claim
  then
    Result := MaxR(0, PrvConstant[RY].PrvSpouseBasicAmount * ret[RetNo].PartYear - Ni);

  If IsPreBankruptcyReturn(RetNo) then
  begin
    Result := CalcSpousalClaim(RetNo, Ni); // prorated  //20090109

    If (ret[RetNo].MarStatus < 3) or
      (IsSpouseDeceased(RetNo) and (ret[RetNo].MarStatus = 3)) then
      // or widower whose spouse died during year
      Result := MinR(PrvConstant[RY].PrvMaxSpousalAmount,
        MaxR(0, PrvConstant[RY].PrvSpouseBasicAmount - Ni)); // 20090109
    If Result > PrvConstant[RY].PrvMaxSpousalAmount Then
      Result := PrvConstant[RY].PrvMaxSpousalAmount;

    Result := Result * ret[RetNo].PartYear; // 2090109
  End;
  If Result > PrvConstant[RY].PrvMaxSpousalAmount then
    Result := PrvConstant[RY].PrvMaxSpousalAmount;
end;

Procedure CalcFullReturn(RetNo: integer);
Var
  i,k, SpRetNo: integer;
  FNm: string[10];
  FNo: integer;
  s: String;
begin
  if IsVtClient then exit; // 20210112 //20210115 Igor
  // CrossAppRoutineSample; //20200820 Experiment - see procedure
  If ShowUnconvertedLastYear(RetNo) then exit;
  If ret[RetNo].IsLastYearReturn then
    exit; // 20160314 Igor

  With ret[RetNo] do
  begin
    Calc(RetNo,'T1248');
    SumSlips(RetNo, 'T4'); // 20200821  //to handle changes by SALDIV  ???

    // Checked to see if T4/T5 got populated by SalDiv.  They do  //20200821
    // SumSlips(RetNo,'T4');  //20200821  //to handle changes by SALDIV
    // SumSlips(RetNo,'T5');  //20200821  //to handle changes by SALDIV
    // ShowMessage('in T1 Empl Income '+FormatFloat('#########',Ret[RetNo].lnn[10100]));
    // ShowMessage('in T1 Elig div '+FetchElm(RetNo,'DTC',14));

    // 201901421
    FNo := AddNextInstance(RetNo, 'T2209#1'); // creates #2
    If FNo > 0 then
      FNo := AddNextInstance(RetNo, 'T2209#2'); // Creates #3

    EFMEMO(RetNo, 'EFMEMO', GetFormNo('EFMEMO')); // 20130130
    Lnn[368] := 0; // 20130108  Eliminated in 2010?
    If UpperCase(FetchElm(RetNo, 'RC359#1', 21)) = 'Y' then
      CreateRc359Forms(RetNo); // 20121120
    // 20101221
    If ret[RetNo].Lnn[15000] = 0 then
      StoreElm(RetNo, GetFormNo('EFMEMO'), 20, '7')
    Else
      StoreElm(RetNo, GetFormNo('EFMEMO'), 20, '');

    RC62(RetNo, 'RC62#1', GetFormNo('RC62#1')); // 20110125

    FNo := GetFormNo('T2036');
    InitFormData(RetNo, FNo);
    INFO(RetNo, 'INFO', GetFormNo('INFO'));
    // 20160216 Igor
    CDE(RetNo, 'CDE', GetFormNo('CDE')); // 20160203
    T1212(RetNo, 'T1212', GetFormNo('T1212'));
    PTIMEWS(RetNo, 'PTIMEWS', GetFormNo('PTIMEWS')); // 20120220
    T4A(RetNo, 'T4A#1', GetFormNo('T4A#1')); // 20120220
    T4AProcess(RetNo, T4AOthInc, T4APens, T4ARpp, T4APAdj, T4AOthEmpl, T4ADon,
      T4ATax, T4ANorthA, T4ANorthB, T4APastRppW, T4APastRppWNot, T4AResp,
      T4ARespEduc, T4AResp22, T4AAnnuity, T4ARDSP,T4ACovidIncome);  //20210315
    OTHEMPL(RetNo, 'OTHEMPL', GetFormNo('OTHEMPL'));
    CPT20(RetNo, 'CPT20', GetFormNo('CPT20')); // 20121211
    DEPEND(RetNo, 'DEPEND', GetFormNo('DEPEND')); // first depend then optimize
    S5SUPL(RetNo, 'S5SUPL', GetFormNo('S5SUPL')); // 20180120
    S5(RetNo, 'S5', GetFormNo('S5')); // first depend then optimize  //20121118
    S5PRV(RetNo, 'S5PRV', GetFormNo('S5PRV')); // 20180120

    T2205(RetNo, 'T2205', GetFormNo('T2205')); // spousal rif/rsp
    PNSDED(RetNo, 'PNSDED', GetFormNo('PNSDED'));
    T1032(RetNo, 'T1032', GetFormNo('T1032'));
    T1229(RetNo, 'T1229', GetFormNo('T1229'));
    T1223(RetNo, 'T1223', GetFormNo('T1223'));
    If vl(FetchElm(RetNo, 'T1223', 120)) > 0 then
      ret[RetNo].FormHasData['T1223'] := True
    else
      ret[RetNo].FormHasData['T1223'] := False;

    RESINC(RetNo, 'RESINC', GetFormNo('RESINC'));

    //20220223
    T5MULTProcess(RetNo, T5Interest, T5Pens, T5NonElgblGains, T5Dividends,
        T5DividendsEligible, T5FNonBusInc1, T5FNonBusInc2, T5FNonBusInc3,
        T5FNonBusTax1, T5FNonBusTax2, T5FNonBusTax3, T5OthEmpl);

    S4(RetNo, 'S4', GetFormNo('S4'));
    OTHINC(RetNo, 'OTHINC', GetFormNo('OTHINC'));
    ABIL(RetNo, 'ABIL', GetFormNo('ABIL'));

    for i := 1 to 10 do // 20200523
    Begin
      s := AllTrim(IntToStr(i));
      if GetFormNo('T5008#' + s) > 0 then
        T5008(RetNo, 'T5008#' + s, GetFormNo('T5008#' + s));
    End;

    T2091(RetNo, 'T2091#1', GetFormNo('T2091#1'));   //20200412
    k:=GetFormNo('T2091#2'); If K>0 then T2091(RetNo, 'T2091#2', GetFormNo('T2091#2'));   //20200412

    T1255(RetNo, 'T1255#1', GetFormNo('T1255#1'));   //20200412
    k:=GetFormNo('T1255#2');If k>0 then T1255(RetNo, 'T1255#2', k);   //20220429

    T209W(RetNo, 'T209W#1', GetFormNo('T209W#1'));   //20220127
    k:=GetFormNo('T209W#2'); if K>0 then T209W(RetNo, 'T209W#2', k);   //20220127
    //again //20220127
    T2091(RetNo, 'T2091#1', GetFormNo('T2091#1'));   //20200412
    k:=GetFormNo('T2091#2'); If k>0 then T2091(RetNo, 'T2091#2', k);   //20200412

    S3(RetNo, 'S3', GetFormNo('S3'));
    S3(RetNo, 'S3', GetFormNo('S3')); // again

    T2048(RetNo, 'T2048#1', GetFormNo('T2048#1'));      //jz//20250401
    k:=GetFormNo('T2048#2'); if K>0 then T2048(RetNo, 'T2048#2', k);   //jz//20250401 - add so to calc 2nd instance, dont think this is necessary but ohters have it so leave it for now

    T24EOT(RetNo, 'T24EOT', GetFormNo('T24EOT'));   //jz//20250401

    RPP(RetNo, 'RPP', GetFormNo('RPP'));
    RRSP(RetNo, 'RRSP', GetFormNo('RRSP'));

    RecalcBusStatements(RetNo); // 20081226

    S7(RetNo, 'S7', GetFormNo('S7'));
    RC268(RetNo, 'RC268', GetFormNo('RC268')); // 20200229
    RRSPNXT(RetNo, 'RRSPNXT', GetFormNo('RRSPNXT'));

    T929(RetNo, 'T929', GetFormNo('T929')); { depends on earned income }
    UNIOND(RetNo, 'UNIOND', GetFormNo('UNIOND'));
    T777MOB(RetNo, 'T777MOB' + '#1', GetFormNo('T777MOB' + '#1'));  //20221211
    T777(RetNo, 'T777' + '#1', GetFormNo('T777' + '#1'));  //20210307

    OTHDED(RetNo, 'OTHDED', GetFormNo('OTHDED')); { depends on others/i.e FTC }
    DISAB18(RetNo, 'DISAB18', GetFormNo('DISAB18'), ''); // 20200410
    TRANSF(RetNo, 'TRANSF', GetFormNo('TRANSF'));

    T936(RetNo, 'T936', GetFormNo('T936'));

    { T1139 1 case }
    T1139(RetNo, 'T1139' + '#1', GetFormNo('T1139' + '#1'));


    T1(RetNo, 'T1', GetFormNo('T1'));


    //jz//NonResCERT-R2 - ZeroOutNonRefundableTaxCredits doesnt work here as T1 is recalled after it, move it into procedure T1 itsself
    {
    // too soon T2043A(RetNo, 'T2043A#1', GetFormNo('T2043A#1')); //20220416
    if FetchElmFNo(RetNo,InfoFNo,73)>'' then ZeroOutNonRefundableTaxCredits(retNo);//20240323
    if (NonResWithEmpl(RetNo)) or (IsSection116(retno)) then  //jz//NonResCERT-R2//20250415
    Begin
     ZeroOutNonRefundableTaxCredits(retNo);
    End;
    }

    CLAW(RetNo, 'CLAW', GetFormNo('CLAW'));
    T1(RetNo, 'T1', GetFormNo('T1'));
    RC62(RetNo, 'RC62#1', GetFormNo('RC62#1'));
    { for page 3 taxable income and ref credits }
    If (ret[RetNo].FormHasData['T2222']) then
    begin
      T2222(RetNo, 'T2222', GetFormNo('T2222'));
      ret[RetNo].Lnn[25500] := vl(FetchElm(RetNo, 'T2222', 109));
      T1(RetNo, 'T1', GetFormNo('T1')); { again }
    end
    else
      ret[RetNo].Lnn[25500] := 0;
    T1A(RetNo, 'T1A', GetFormNo('T1A'));

    //if FetchElmFNo(RetNo,InfoFno,250)='BC' then    // TaxbGains from BC

    T1(RetNo, 'T1', GetFormNo('T1')); { again }

    CAREGVR(RetNo, 'CAREGVR', GetFormNo('CAREGVR')); // 20130510
    S5(RetNo, 'S5', GetFormNo('S5'));
    T929(RetNo, 'T929', GetFormNo('T929')); { depends on earned income }

    OTHDED(RetNo, 'OTHDED', GetFormNo('OTHDED'));
    S15(RetNo, 'S15', GetFormNo('S15'));  //20231207
    T1(RetNo, 'T1', GetFormNo('T1'));

    if IsMultJurisdiction(RetNo) then  //20240601
    Begin
     //20241110
     Calc(RetNo,'ABMJ');  //20240604
     Calc(RetNo,'BCMJ');
     Calc(RetNo,'MBMJ');
     Calc(RetNo,'NSMJ');
     Calc(RetNo,'NBMJ');
     Calc(RetNo,'NLMJ');
     Calc(RetNo,'NTMJ');
     Calc(RetNo,'NUMJ');
     Calc(RetNo,'ONMJ');
     Calc(RetNo,'PEMJ');
     Calc(RetNo,'SKMJ');
     Calc(RetNo,'YTMJ');
    End;
   
   (*
    if IsMultJurisdiction(RetNo) then  //20240601
    Begin
     Calc(RetNo,'ABMJWS');  //20240604
     Calc(RetNo,'BCMJWS');
     Calc(RetNo,'MBMJWS');
     Calc(RetNo,'NSMJWS');
     Calc(RetNo,'NBMJWS');
     Calc(RetNo,'NLMJWS');
     Calc(RetNo,'NTMJWS');
     Calc(RetNo,'NUMJWS');
     Calc(RetNo,'ONMJWS');
     Calc(RetNo,'PEMJWS');
     Calc(RetNo,'SKMJWS');
     Calc(RetNo,'YTMJWS');
    End;
   *)
    { refndbl credits }
    AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED'),'');
    DTC(RetNo, 'DTC', GetFormNo('DTC'));
    S11(RetNo, 'S11', GetFormNo('S11'));
    S2(RetNo, 'S2', GetFormNo('S2')); { calc 308/310/421/448 }
   // Lnn[44800] := 0; { to be replaced by S8/T2204/RC381 }  //20241223
    // CPPAdj(RetNo,'CPPADJ',GetFormno('CPPADJ'));  //20130302

    S8(RetNo, 'S8', GetFormNo('S8')); { calc 308/310/421/448 }

    // If ret[RetNo].Province='QC' then
    S8Q(RetNo, 'S8Q', GetFormNo('S8Q')); { calc 308/310/421/448 }  // 20131211
    T2204(RetNo, 'T2204', GetFormNo('T2204'));
    CPPADJ(RetNo, 'CPPADJ', GetFormNo('CPPADJ')); // 20150220
    RC381(RetNo, 'RC381', GetFormNo('RC381')); // 20131201
    T90(RetNo, 'T90', GetFormNo('T90')); // 20191209
    S10(RetNo, 'S10', GetFormNo('S10'));
    TOOLEXP(RetNo, 'TOOLEXP', GetFormNo('TOOLEXP'));
    CLAW(RetNo, 'CLAW', GetFormNo('CLAW'));
    SCHSUPPL(RetNo, 'SCHSUPPL', GetFormNo('SCHSUPPL')); // 20170128

    T1(RetNo, 'T1', GetFormNo('T1'));

    // ShowMessage('doing a full calc C section');
    { BFR DONATIONS }
    FITNESS(RetNo, 'FITNESS', GetFormNo('FITNESS'));
    // ARTS(RetNo,'ARTS',GetFormNo('ARTS'));

    MEDICAL(RetNo, 'MEDICAL', GetFormNo('MEDICAL'));
    MEDPRV(RetNo, 'MEDPRV', GetFormNo('MEDPRV')); // 20120324

    // 20141119
    TaxChart(RetNo, 'TAXCHART', GetFormNo('TAXCHART'));
    // S1A(RetNo,'S1A',GetFormno('S1A'));   //20161117
    // S1(RetNo, 'S1', GetFormNo('S1'));  //20191109
    DTC(RetNo, 'DTC', GetFormNo('DTC'));

    DON(RetNo, 'DON', GetFormNo('DON'));
    S9(RetNo, 'S9', GetFormNo('S9')); // 20210221

    FORECLO(RetNo, 'FORECLO', GetFormNo('FORECLO'));
    MEDREF(RetNo, 'MEDREF', GetFormNo('MEDREF'));
    PNSDED(RetNo, 'PNSDED', GetFormNo('PNSDED')); { for line 314 }

    T2043A(RetNo, 'T2043A#1', GetFormNo('T2043A#1')); //20220416
    //ShowMessage('T2043A#1 '+FormatFloat('######',Vl(FetchElmFNo(RetNo,GetFormNo('T2043A#1'),7))));

    T1(RetNo, 'T1', GetFormNo('T1')); { Again }
    STLOAN(RetNo, 'STLOAN', GetFormNo('STLOAN')); //20220519

    { agter refndb optimize losses }
    CFRAFILL(RetNo, 'CFRAFILL', GetFormNo('CFRAFILL')); { again }
    CFR(RetNo, 'CFR', GetFormNo('CFR')); { again }
    ret[RetNo].Lnn[25300] := 0;
    Lnn[25400] := 0;
    CFR(RetNo, 'CFR', GetFormNo('CFR')); // puts back Lnn[253]
    If IsDeceased(RetNo) then
      Death(RetNo, 'DEATH', GetFormNo('DEATH')); // puts back Lnn[253]
    T936(RetNo, 'T936', GetFormNo('T936'));

    T2043(RetNo, 'T2043', GetFormNo('T2043'));  //20230125
    T1(RetNo, 'T1', GetFormNo('T1')); { Again }

    T936(RetNo, 'T936', GetFormNo('T936')); // july 20 2008

    T657(RetNo, 'T657', GetFormNo('T657'));
   // T657NEW(RetNo, 'T657NEW', GetFormNo('T657NEW'));

    S11(RetNo, 'S11', GetFormNo('S11'));

    T778(RetNo, 'T778', GetFormNo('T778')); { depends on earned income }

    TOOLEXP(RetNo, 'TOOLEXP', GetFormNo('TOOLEXP')); // 20110330

    T1(RetNo, 'T1', GetFormNo('T1'));

    { for page 4 }
    T1206(RetNo, 'T1206', GetFormNo('T1206'));

    POLIT(RetNo, 'POLIT', GetFormNo('POLIT'));

    SNRC(RetNo, 'SNRC', GetFormNo('SNRC')); // 20110315
    SNRESA(RetNo, 'SNRESA', GetFormNo('SNRESA'));
    SNRESB(RetNo, 'SNRESB', GetFormNo('SNRESB'));

    TaxChart(RetNo, 'TAXCHART', GetFormNo('TAXCHART'));

    // 20190404
    TRANSF(RetNo, 'TRANSF', GetFormNo('TRANSF'));
    TRANSF(RetNo, 'PTRANSF', GetFormNo('PTRANSF'));

    // S1(RetNo, 'S1', GetFormNo('S1'));

    T1159(RetNo, 'T1159', GetFormNo('T1159'));
    // T626(RetNo,'T626#1',GetFormno('T626#1'));  //20090525  //20161119
    STLOAN(RetNo, 'STLOAN', GetFormNo('STLOAN'));

    DON(RetNo, 'DON', GetFormNo('DON'));
    S9(RetNo, 'S9', GetFormNo('S9'));

    PTRANSIT(RetNo, 'PTRANSIT', GetFormNo('PTRANSIT'));
    HOMEBUY(RetNo, 'HOMEBUY', GetFormNo('HOMEBUY'));

    TaxChart(RetNo, 'TAXCHART', GetFormNo('TAXCHART'));
    // S1A(RetNo,'S1A',GetFormno('S1A')); //20141121  //20161117
    // S1(RetNo, 'S1', GetFormNo('S1'));

    { AMT }
    T1A(RetNo, 'T1A', GetFormNo('T1A')); { needed by AMt/Addtl ded }
    T691(RetNo, 'T691', GetFormNo('T691'));

    T2038(RetNo, 'T2038', GetFormNo('T2038'));
    T691(RetNo, 'T691', GetFormNo('T691'));

    STLOAN(RetNo, 'STLOAN', GetFormNo('STLOAN'));
    FORINC(RetNo, 'FORINC', GetFormNo('FORINC'));

    // ShowMessage('doing a full calc D section');
    T2209(RetNo, 'T2209#1', GetFormNo('T2209#1'));
    FNo := GetFormNo('T2209#2'); // 20121226
    If FNo > 0 then
    Begin
      T2209(RetNo, 'T2209#2', FNo);
    end;

    FNo := GetFormNo('T2209#3'); // 20121226
    If FNo > 0 then // 20101020
    Begin
      T2209(RetNo, 'T2209#3', FNo);
    End;

    T2036(RetNo, 'T2036', GetFormNo('T2036'));

    MEDPRV(RetNo, 'MEDPRV', GetFormNo('MEDPRV'));
    CAREPRV(RetNo, 'CAREPRV', GetFormNo('CAREPRV')); // 20130510
    S5PRV(RetNo, 'S5PRV', GetFormNo('S5PRV'));
    S11PRV(RetNo, 'S11PRV', GetFormNo('S11PRV'));
    if Ret[RetNo].Province='YT' then
        S11PRVYT(RetNo,'S11PRVYT',GetFormNo('S11PRVYT')); //20220220  details for provincial

    S2PRV(RetNo, 'S2PRV', GetFormNo('S2PRV'));
    T1221(RetNo, 'T1221', GetFormNo('T1221'));
    T1231(RetNo, 'T1231', GetFormNo('T1231'));
    T1241(RetNo, 'T1241', GetFormNo('T1241'));

    // 20110315
    SNRC(RetNo, 'SNRC', GetFormNo('SNRC'));
    SNRESA(RetNo, 'SNRESA', GetFormNo('SNRESA'));
    SNRESB(RetNo, 'SNRESB', GetFormNo('SNRESB'));

    TaxChart(RetNo, 'TAXCHART', GetFormNo('TAXCHART'));
    // S1A(RetNo,'S1A',GetFormno('S1A')); //20141121  //20161117
    // S1(RetNo, 'S1', GetFormNo('S1'));

    T691(RetNo, 'T691', GetFormNo('T691')); // 20120112 solved recal if mintax

    TaxChart(RetNo, 'TAXCHART', GetFormNo('TAXCHART'));
    // S1A(RetNo,'S1A',GetFormno('S1A')); //20141121  //20161117
    // S1(RetNo, 'S1', GetFormNo('S1'));

    T1(RetNo, 'T1', GetFormNo('T1'));

   // If ret[RetNo].Province = 'MB' then T1005(RetNo, 'T1005', GetFormNo('T1005')); //20220130
    If ret[RetNo].Province = 'BC' then // 20130126
    begin
      T1014(RetNo, 'T1014', GetFormNo('T1014'));
      T10141W(RetNo, 'T10141W#1', GetFormNo('T10141W#1'));
      T10141(RetNo, 'T10141', GetFormNo('T10141'));
      T10142W(RetNo, 'T10142W#1', GetFormNo('T10142W#1'));
      T10142(RetNo, 'T10142', GetFormNo('T10142'));
    end;
    // ShowMessage('doing a full calc E section');
    ADOPT(RetNo, 'ADOPT#1', GetFormNo('ADOPT#1'));
    ONMTXWS(RetNo, 'ONMTXWS', GetFormNo('ONMTXWS')); // 20220224
    CalcPrvTaxAndCredits(RetNo);
    S11PRV(RetNo, 'S11PRV', GetFormNo('S11PRV'));
    PTRANSF(RetNo, 'PTRANSF', GetFormNo('PTRANSF'));

    T2036(RetNo, 'T2036', GetFormNo('T2036'));
    //T2036SUM(RetNo, 'T2036SUM', GetFormNo('T2036SUM'));     //jz//20260202 - form no longer used?? remove code and from database -- should remove pas/dfm as well //20170205
    BankRpt(RetNo, 'BANKRPT', GetFormNo('BANKRPT')); // 20110104

    //BCARTS(RetNo, 'BCARTS', GetFormNo('BCARTS'));  //jz//20251210 - causes access violation, has the form been removed??
    MBARTS(RetNo, 'MBARTS', GetFormNo('MBARTS'));  //20260109 //jz//20251210 - causes access violation, has the form been removed??
    YTARTS(RetNo, 'YTARTS', GetFormNo('YTARTS'));

    CalcPrvTaxAndCredits(RetNo); { again }

    If ret[RetNo].FormHasData['T1229'] then //20220429
      T1229(RetNo, 'T1229', GetFormNo('T1229'));

    If ret[RetNo].FormHasData['T2038'] then
      T2038(RetNo, 'T2038', GetFormNo('T2038'));


    T1172(RetNo, 'T1172', GetFormNo('T1172'));
    // T691(RetNo,'T691',GetFormno('T691'));  //20120112
    T2209(RetNo, 'T2209#1', GetFormNo('T2209#1')); // 20120112

    TaxChart(RetNo, 'TAXCHART', GetFormNo('TAXCHART'));
    // S1(RetNo, 'S1', GetFormNo('S1'));

    S6(RetNo, 'S6', GetFormNo('S6'));
    S6QC(RetNo, 'S6QC', GetFormNo('S6QC')); // 20171204

   // S14(RetNo, 'S14', GetFormNo('S14')); // 20220220
   // S14EST(RetNo, 'S14EST', GetFormNo('S14EST')); // 20220220
   // S14(RetNo, 'S14', GetFormNo('S14')); // 20220220
   // S14EST(RetNo, 'S14EST', GetFormNo('S14EST')); // 20220220 //agin

   // S14YT(RetNo, 'S14YT', GetFormNo('S14YT')); // 20181124 //20251227

    GST370(RetNo, 'GST370', GetFormNo('GST370')); // 20190314
   // T1B(RetNo, 'T1B', GetFormNo('T1B'));  //20221207
   // T2039(RetNo, 'T2039', GetFormNo('T2039'));  //20221215  //20240204
   //T2043(RetNo, 'T2043', GetFormNo('T2043'));  //20220201


    T1(RetNo, 'T1', GetFormNo('T1'));
    { miscellaneous }

    T1033(RetNo, 'T1033', GetFormNo('T1033'));
    EFMEMO(RetNo, 'EFMEMO', GetFormNo('EFMEMO'));
    RC71(RetNo, 'RC71', GetFormNo('RC71'));
    T4Sum(RetNo, 'T4SUM#1', GetFormNo('T4SUM#1'));
    T1A(RetNo, 'T1A', GetFormNo('T1A'));
    CFR(RetNo, 'CFR', GetFormNo('CFR'));
    GSTC(RetNo, 'GSTC', GetFormNo('GSTC'));
    OEPTC(RetNo, 'OEPTC', GetFormNo('OEPTC'));
    GSTC(RetNo, 'GSTC', GetFormNo('GSTC'));
    MCREDIT(RetNo, 'MCREDIT', GetFormNo('MCREDIT'));
    MXCREDIT(RetNo, 'MXCREDIT', GetFormNo('MXCREDIT'));
    T183(RetNo, 'T183', GetFormNo('T183'));
    T1153(RetNo, 'T1153', GetFormNo('T1153'));
    PROVCTB(RetNo, 'PROVCTB', GetFormNo('PROVCTB'));
    CTB(RetNo, 'CTB', GetFormNo('CTB'));
    FPCHECK(RetNo, 'FPCHECK', GetFormNo('FPCHECK'));
    DIAGNO(RetNo, 'DIAGNO', GetFormNo('DIAGNO')); // 20130209
    // WARNOFF(RetNo,'WARNOFF',GetFormno('WARNOFF'));  //20130209
    TAXSUM(RetNo, 'TAXSUM', GetFormNo('TAXSUM')); // 20120227
    FAMSUM(RetNo, 'FAMSUM', GetFormNo('FAMSUM')); // 20120304
    BUSSUM(RetNo, 'BUSSUM', GetFormNo('BUSSUM')); // 20160813 CON
    RENTSUM(RetNo, 'RENTSUM', GetFormNo('RENTSUM')); // 20160813 CON
    INVFORMS(RetNo, 'INVFORMS', GetFormNo('INVFORMS')); // 20160813 CON

    // 20120203
    YRSUM(RetNo, 'YRSUM', GetFormNo('YRSUM'));
    YRSUM2(RetNo, 'YRSUM2', GetFormNo('YRSUM2'));
    // 20110109
    T2125SUM(RetNo, 'T2125SUM#1', GetFormNo('T2125SUM#1'));
    T2121SUM(RetNo, 'T2121SUM#1', GetFormNo('T2121SUM#1'));
    T2042SUM(RetNo, 'T2042SUM#1', GetFormNo('T2042SUM#1'));
    T1163SUM(RetNo, 'T1163SUM#1', GetFormNo('T1163SUM#1'));
    T1273SUM(RetNo, 'T1273SUM#1', GetFormNo('T1273SUM#1'));
    T776SUM(RetNo, 'T776SUM#1', GetFormNo('T776SUM#1'));

    T1135(RetNo, 'T1135', GetFormNo('T1135')); // 20160126
    T400A(RetNo, 'T400A', GetFormNo('T400A')); // 20200208
    StoreBeforeAfterOptimize(RetNo); // 20110403

     //202251220
    if Ret[RetNo].FrmHasData[GetFormNo('T106')] then // 20220718
    Begin
      T106(RetNo, 'T106', GetFormNo('T106'));
      for i := 1 to 20 do
      Begin
        k := GetFormNo('T106SL' + '#' + AllTrim(IntToStr(i)));
        if Ret[RetNo].FrmHasData[k] then
          Calc(RetNo, 'T106SL#' + AllTrim(IntToStr(i)), k);
      End;
    End;

    If fetchElm(RetNo,'RC151',57)>'' then
      RC151(RetNo, 'RC151', GetFormNo('RC151')); //20230330
    RRSPNXT(RetNo, 'RRSPNXT', GetFormNo('RRSPNXT')); // 20200223
    REFILEQ(RetNo, 'REFILEQ', GetFormNo('REFILEQ')); // 20170329
    T7DRQR(RetNo, 'T7DRQR', GetFormNo('T7DRQR')); // 20180310
    CONSENT(RetNo, 'CONSENT', GetFormNo('CONSENT#1')); // 20200212
    T185(RetNo, 'T185', GetFormNo('T185')); // 20210213
    PopulateS14G(RetNo);
    //UHT(RetNo, 'UHT#1', GetFormNo('UHT#1')); // 20230626 //20240717 Igor
    // 20181125  //so the Efile has only one form to deal with
    CalcPrintJacket(RetNo); // 20200222

    //20230811 Igor >>>
    T1134(RetNo, 'T1134#1', GetFormNo('T1134#1')); //20260513
    //T1134(RetNo, 'T1134', GetFormNo('T1134'));   //20260513
    for i := 1 to 10 do // 20200523
    Begin
      s := AllTrim(IntToStr(i));
      if GetFormNo('T1134S#' + s) > 0 then
        T1134S(RetNo, 'T1134S#' + s, GetFormNo('T1134S#' + s));
    End;
    //20230811 Igor <<<

    ret[RetNo].CalcStatus := True;
    // ShowMessage('Full recalc routine finished');
  end;
end;


Procedure CALCALL(RetNo: integer);
Var
  SpRetNo, ParentRetNo, FNo: integer;
Begin

  If ShowUnconvertedLastYear(RetNo) then  exit;
  CalcFullReturn(RetNo); { Current return }
  { calc spouse's return }
  SpRetNo := GetSpRetNo(RetNo);
  If SpRetNo > 0 then
  begin
    If ret[SpRetNo].CouplingSw then
    begin
      if ret[SpRetNo].MarStatus < 3 then
        StoreElm(SpRetNo, InfoFNo, 65, FetchElmFNo(RetNo, InfoFNo, 24));
      // store death date  //20190127
      ApplySharedStatements(RetNo, SpRetNo);
      CplXfer(RetNo, SpRetNo);
      CalcFullReturn(SpRetNo);
      ret[SpRetNo].Changed := True;
      FNo := GetFormNo('S2');
      S2(RetNo, 'S2', FNo);
      CalcFullReturn(RetNo); // 20170306 //20170316 Igor
    end;
  end;
  { recalc parent's return }
  ParentRetNo := GetParentRetNo(FetchElm(RetNo, 'INFO', 3));

  If ParentRetNo > 0 then
  begin
    If ret[ParentRetNo].CouplingSw then
    begin
      CalcFullReturn(ParentRetNo);
      ret[ParentRetNo].Changed := True;
    end;
  end;
end;


Procedure ClearThisForm(RetNo: integer; FName: string);
var
  i, n, FNo: integer;
begin
  FNo := GetFormNo(FName);
  If (FNo > 0) and (ret[RetNo].Frm[FNo].Count > 0) then
  begin
    n := GetFormNumberFields(GetFormNo(FName));
    For i := 1 to n do
      ret[RetNo].Frm[FNo].Strings[i] := '';
    Calc(RetNo, FName);
    ret[RetNo].Changed := True;
  end;
end;

Procedure AUTOEXP(RetNo: integer; FName: String; FNo: integer);
begin
  // CalcAutoExp(RetNo,FName,FNo,'O');  {other}
end;

Procedure AUTO(RetNo: integer; FName: String; FNo: integer);
begin
  CalcAuto(RetNo, FName, FNo, 'O'); { other }
end;

Procedure FAMSET(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    { }
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure FORECLO(RetNo: integer; FName: String; FNo: integer);
Var
  SpRetNo: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    SpRetNo := GetSpRetNo(RetNo);
    If SpRetNo > 0 then { spouse does not exist }
    begin
      Tv[1] := ret[SpRetNo].Lnn[12700];
      Tv[2] := vl(FetchElmFNo(SpRetNo, GetFormNo('S3'), 122));
      Tv[3] := vl(FetchElmFNo(SpRetNo, GetFormNo('S3'), 72));
    end;
    Tv[4] := CalcMortgageForeclosure(Tv[1], Tv[2], Tv[3]);
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure FLDMEM(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure FLDTAPE(RetNo: integer; FName: String; FNo: integer);
Var
  RefFormName: String;
  //20220121 Igor >>>
  TapeStr: string;
  Idx: integer;
  //20220121 Igor <<<
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    FormatSettings.DecimalSeparator := '.'; // needed //20160119 Igor
    Tv[125] := AddColumns(1, 60, 1);
    RefFormName := Strings[121];
    If UpperCase(LeftStr(Strings[121], 3)) = 'MED' then
    begin
      Strings[123] := '';
      Strings[124] := 'X';
    end;
    // 20101207
    If (Tv[125] <> 0) and (Strings[123] + Strings[124] = '') then
    begin
      Strings[123] := 'X';
      Strings[124] := '';
    end;

    //20220121 Igor >>>
    TapeStr := RefFormName + '|' + Strings[122];
    If (UpperCase(Strings[123]) = 'X') and (RefFormName > '') then
    begin
      StoreElm(RetNo, GetFormNo(RefFormName), MyStrToInt(Strings[122]),
        FormatFloat('########.##', Tv[125]));
      if not ret[RetNo].TapesList.Find(TapeStr, Idx) then
        ret[RetNo].TapesList.Add(TapeStr);
    end
    else if ret[RetNo].TapesList.Find(TapeStr, Idx) then
      ret[RetNo].TapesList.Delete(Idx);
    //20220121 Igor <<<
  end;
  SaveTv(RetNo, FName, FNo);
  If (UpperCase(ret[RetNo].Frm[FNo].Strings[123]) = 'X') and (RefFormName > '')
  then
    Calc(RetNo, RefFormName);
end;

Procedure FPINFO(RetNo: integer; FName: String; FNo: integer);
begin
  { }
end;

Procedure CalcPrvTaxAndCredits(RetNo: integer);
Var
  i, PtransfFNo, S5PrvFNo, CarePrvFNo, Disab18FNo, T2203FNo, AgeDedFNo: integer;
  // 20180323
  S11MjForm: String; // 20180325
  SpRetNo: integer; // 20200410
  X:REAL;
begin

  T2203Prov := ''; // 20180401
  AgeDedFNo := GetFormNo('AGEDED');
  ret[RetNo].Lnn[42800] := 0;
  ret[RetNo].Lnn[47900] := 0;

  ON428A(RetNo, 'ON428A', GetFormNo('ON428A'));
  // 20200302 to clear if no ontario

  If CalcThisProvince(RetNo, 'ON') then { if residence or mult jurisd }
  begin
    ONMTXWS(RetNo, 'ONMTXWS', GetFormNo('ONMTXWS')); // 20161231
    ON428(RetNo, 'ON428', GetFormNo('ON428'));
    RC360(RetNo, 'RC360', GetFormNo('RC360')); // 20171207
    ON428A(RetNo, 'ON428A', GetFormNo('ON428A'));   //20221228
    ON428(RetNo, 'ON428', GetFormNo('ON428')); // 20171207
    ON428A(RetNo, 'ON428A', GetFormNo('ON428A')); // 20171207
    S11PRV(RetNo, 'S11PRV', GetFormNo('S11PRV'));
    ret[RetNo].Lnn[42800] := vl(FetchElm(RetNo, 'ON428', 122));

    If ret[RetNo].Province = 'ON' then
    begin
      ONBEN(RetNo, 'ONBEN', GetFormNo('ONBEN'));
      ON479(RetNo, 'ON479', GetFormNo('ON479'));
      ON479A(RetNo, 'ON479A', GetFormNo('ON479A')); // 20191121
    end;
  end;

  if CalcThisProvince(RetNo, 'AB') then { Prv = 'AB'   then }
  begin
    LN61545(RetNo, 'LN61545', GetFormNo('LN61545'));
    AB428(RetNo, 'AB428', GetFormNo('AB428'));  //2025
    RC360(RetNo, 'RC360', GetFormNo('RC360')); // 20171207
    AB428(RetNo, 'AB428', GetFormNo('AB428')); // 20171207
    S11PRV(RetNo, 'S11PRV', GetFormNo('S11PRV'));

    ret[RetNo].Lnn[42800] := vl(FetchElm(RetNo, 'AB428', 117));
  end;

  if CalcThisProvince(RetNo, 'BC') then
  begin
    BCDON(RetNo, 'BCDON', GetFormNo('BCDON')); // donations and gifts
    BC428(RetNo, 'BC428', GetFormNo('BC428'));
    RC360(RetNo, 'RC360', GetFormNo('RC360')); // 20171207
    BC428(RetNo, 'BC428', GetFormNo('BC428'));
    S11PRV(RetNo, 'S11PRV', GetFormNo('S11PRV'));
    // BC428(RetNo,'BC428',GetFormno('BC428'));
    ret[RetNo].Lnn[42800] := vl(FetchElm(RetNo, 'BC428', 131));
    If ret[RetNo].Province = 'BC' then
      BC479(RetNo, 'BC479', GetFormNo('BC479'));
  end;

  MB428A(RetNo, 'MB428A', GetFormNo('MB428A')); // 20101215
  MBMJA(RetNo, 'MBMJA', GetFormNo('MBMJA')); // 20190205

  if CalcThisProvince(RetNo, 'MB') then
  begin
   // T1005(RetNo, 'T1005', GetFormNo('T1005')); // 20220130
    MBFITNES(RetNo, 'MBFITNES', GetFormNo('MBFITNES'));
    T1241(RetNo, 'T1241', GetFormNo('T1241')); // 20111211

    MB428ws(RetNo, 'MB428ws', GetFormNo('MB428ws')); //jz//20251219

    MB428(RetNo, 'MB428', GetFormNo('MB428'));
    RC360(RetNo, 'RC360', GetFormNo('RC360')); // 20171207
    MB428(RetNo, 'MB428', GetFormNo('MB428'));
    T12561(RetNo, 'T12561', GetFormNo('T12561')); // 20110122
    T12562(RetNo, 'T12562', GetFormNo('T12562')); // 20110122
    T1256(RetNo, 'T1256', GetFormNo('T1256')); // 20110122
    S11PRV(RetNo, 'S11PRV', GetFormNo('S11PRV'));
    ret[RetNo].Lnn[42800] := vl(FetchElm(RetNo, 'MB428', 145));
    If ret[RetNo].Province = 'MB' then
      MB479(RetNo, 'MB479', GetFormNo('MB479'));
  end;

  if CalcThisProvince(RetNo, 'NB') then
  begin
    T1258(RetNo, 'T1258', GetFormNo('T1258')); // 20131203
    NB428(RetNo, 'NB428', GetFormNo('NB428'));
    RC360(RetNo, 'RC360', GetFormNo('RC360')); // 20171207
    NB428(RetNo, 'NB428', GetFormNo('NB428'));
    S11PRV(RetNo, 'S11PRV', GetFormNo('S11PRV'));
    // NB428(RetNo,'NB428',GetFormno('NB428'));  //put it back 20170225  no help
    ret[RetNo].Lnn[42800] := vl(FetchElm(RetNo, 'NB428', 150));
    S12NB(RetNo, 'S12NB', GetFormNo('S12NB'));
    // to pick up the only credit Home renovation from S12NB
  end;

  if CalcThisProvince(RetNo, 'NL') then
  begin
    NL428(RetNo, 'NL428', GetFormNo('NL428'));
    RC360(RetNo, 'RC360', GetFormNo('RC360')); // 20171207
    NL428(RetNo, 'NL428', GetFormNo('NL428'));
    T1297(RetNo, 'T1297', GetFormNo('T1297')); // 20110122
    S11PRV(RetNo, 'S11PRV', GetFormNo('S11PRV'));
    T1272(RetNo, 'T1272', GetFormNo('T1272'));
    T1129(RetNo, 'T1129', GetFormNo('T1129'));    //20211123
    NL479(RetNo, 'NL479', GetFormNo('NL479'));    //20211123
    ret[RetNo].Lnn[42800] := vl(FetchElm(RetNo, 'NL428', 121));
  end;
  if CalcThisProvince(RetNo, 'NT') then
  begin
    NT428(RetNo, 'NT428', GetFormNo('NT428'));
    RC360(RetNo, 'RC360', GetFormNo('RC360')); // 20171207
    NT428(RetNo, 'NT428', GetFormNo('NT428'));
    S11PRV(RetNo, 'S11PRV', GetFormNo('S11PRV'));
    ret[RetNo].Lnn[42800] := vl(FetchElm(RetNo, 'NT428', 120));
    NT479(RetNo, 'NT479', GetFormNo('NT479'));
  end;

  if CalcThisProvince(RetNo, 'SK') then
  begin
    SK428(RetNo, 'SK428', GetFormNo('SK428'));
    T1279(RetNo, 'T1279', GetFormNo('T1279'));  //20231212
    RC360(RetNo, 'RC360', GetFormNo('RC360')); // 20171207
    T1279(RetNo, 'T1279', GetFormNo('T1279'));  //20231212
    SK428(RetNo, 'SK428', GetFormNo('SK428'));
    SK479(RetNo, 'SK479',GetFormno('SK479'));  //20211221
    S11PRV(RetNo, 'S11PRV', GetFormNo('S11PRV'));
  //S12SK(RetNo, 'S12SK', GetFormNo('S12SK'));  //20220225
    ret[RetNo].Lnn[42800] := vl(FetchElm(RetNo, 'SK428', 137));
  end;

  if CalcThisProvince(RetNo, 'NU') then
  begin
    NU428(RetNo, 'NU428', GetFormNo('NU428'));
    RC360(RetNo, 'RC360', GetFormNo('RC360')); // 20171207
    NU428(RetNo, 'NU428', GetFormNo('NU428'));
    S11PRV(RetNo, 'S11PRV', GetFormNo('S11PRV'));
    ret[RetNo].Lnn[42800] := vl(FetchElm(RetNo, 'NU428', 120));
    If ret[RetNo].Province = 'NU' then
      NU479(RetNo, 'NU479', GetFormNo('NU479'));
  end;

  if CalcThisProvince(RetNo, 'NS') then
  begin
  //  NS5804(RetNo, 'NS5804', GetFormNo('NS5804')); // 20181123 //20251216
    NS5812(RetNo, 'NS5812', GetFormNo('NS5812')); // 20181123
    NS5816(RetNo, 'NS5816', GetFormNo('NS5816')); // 20181123
    NS479(RetNo, 'NS479', GetFormNo('NS479'));  //20221211
    NS428(RetNo, 'NS428', GetFormNo('NS428'));
    RC360(RetNo, 'RC360', GetFormNo('RC360')); // 20171207
    NS428(RetNo, 'NS428', GetFormNo('NS428'));
    T1285(RetNo, 'T1285', GetFormNo('T1285')); // 20110122
    S11PRV(RetNo, 'S11PRV', GetFormNo('S11PRV'));
    ret[RetNo].Lnn[42800] := vl(FetchElm(RetNo, 'NS428', 123));
    T224(RetNo, 'T224', GetFormNo('T224')); // 20210420
    T225(RetNo, 'T225', GetFormNo('T225')); // 20200507
  end;

  if CalcThisProvince(RetNo, 'PE') then
  begin
    PE428(RetNo, 'PE428', GetFormNo('PE428'));
    RC360(RetNo, 'RC360', GetFormNo('RC360')); // 20171207
    PE428(RetNo, 'PE428', GetFormNo('PE428'));
    S11PRV(RetNo, 'S11PRV', GetFormNo('S11PRV'));
    ret[RetNo].Lnn[42800] := vl(FetchElm(RetNo, 'PE428', 112));
  end;

  if CalcThisProvince(RetNo, 'YT') then
  begin
    YT428(RetNo, 'YT428', GetFormNo('YT428'));
    RC360(RetNo, 'RC360', GetFormNo('RC360')); // 20171207
    YT428(RetNo, 'YT428', GetFormNo('YT428'));
    S11PRV(RetNo, 'S11PRV', GetFormNo('S11PRV'));
    ret[RetNo].Lnn[42800] := vl(FetchElm(RetNo, 'YT428', 123));
    YT432(RetNo, 'YT432', GetFormNo('YT432'));
    YT479(RetNo, 'YT479', GetFormNo('YT479'));
  end;

  If TOSIinEffect(RetNo) then // niSplitIncome(RetNo) then // 20181222
  begin
    T1206(RetNo, 'T1206', GetFormNo('T1206'));
    if ret[RetNo].FrmHasData[GetFormNo('T1206')] then
    Begin
      if ret[RetNo].Province <> 'ON' then // 20181222
        ret[RetNo].Lnn[42800] := vl(FetchElm(RetNo, 'T1206', 115)); // 20181222

      if ret[RetNo].Province = 'ON' then // 20220120
      Begin
       StoreElm(RetNo,GetFormNo('ON428'),164,FetchElm(RetNo,'T1206',112));
       On428(RetNo, 'ON428', GetFormNo('ON428'));
      End;
    end;
  end;
  // ===========================================================

  { Tax and credits }
  CalcPrvTaxAndCreditsMJ(RetNo);  //jz//20260325//MJCERT2025
  //jz//20260325//MJCERT2025 - moved to own procedure
  (*
  If IsMultJurisdiction(RetNo) then
  begin
    InitPRVConstants(ret[RetNo].Province); // 20170510  //to start with
    // Init 20013
    T2203FNo := GetFormNo('T2203');
    //20240506 Igor >>>
    LoadTv(RetNo, 'T2203', T2203FNo);
    //============
    //INIT the columns in part 3
    for i := 300 to 899 do
    Begin
      ret[RetNo].Frm[T2203FNo].Tv[i] := 0;
    end; // 20130403
    // sk ab bc
    ret[RetNo].Frm[T2203FNo].Tv[119]:=0;  //20240507
    //=================
    SaveTv(RetNo, 'T2203', T2203FNo);

    T2203(RetNo, 'T2203', GetFormNo('T2203'));
    ClearAllMJS2S11(RetNo);
    InitMjS11(RetNo);
    InitMjS2(RetNo);

    T2203NLAgeDed := 0;
    T2203PEAgeDed := 0;
    T2203NSAgeDed := 0;
    T2203NBAgeDed := 0;
    T2203ONAgeDed := 0;
    T2203MBAgeDed := 0;
    T2203SKAgeDed := 0;
    T2203ABAgeDed := 0;
    T2203BCAgeDed := 0;
    T2203YTAgeDed := 0;
    T2203NTAgeDed := 0;
    T2203NUAgeDed := 0;

    // 20170508 disability transfer
    // init to zero
    T2203NLDisabxfer := 0;
    T2203PEDisabxfer := 0;
    T2203NSDisabxfer := 0;
    T2203NBDisabxfer := 0;
    T2203ONDisabxfer := 0;
    T2203MBDisabxfer := 0;
    T2203SKDisabxfer := 0;
    T2203ABDisabxfer := 0;
    T2203BCDisabxfer := 0;
    T2203YTDisabxfer := 0;
    T2203NTDisabxfer := 0;
    T2203NUDisabxfer := 0;

    T2203NLTuitionXfer := 0;
    T2203PETuitionXfer := 0;
    T2203NSTuitionXfer := 0;
    T2203NBTuitionXfer := 0;
    T2203ONTuitionXfer := 0;
    T2203MBTuitionXfer := 0;
    T2203SKTuitionXfer := 0;
    T2203ABTuitionXfer := 0;
    T2203BCTuitionXfer := 0;
    T2203YTTuitionXfer := 0;
    T2203NTTuitionXfer := 0;
    T2203NUTuitionXfer := 0;

    // 20180326
    T2203NLSpousexfer := 0;
    T2203PESpousexfer := 0;
    T2203NSSpousexfer := 0;
    T2203NBSpousexfer := 0;
    T2203ONSpousexfer := 0;
    T2203MBSpousexfer := 0;
    T2203SKSpousexfer := 0;
    T2203ABSpousexfer := 0;
    T2203BCSpousexfer := 0;
    T2203YTSpousexfer := 0;
    T2203NTSpousexfer := 0;
    T2203NUSpousexfer := 0;

    T2203NLInfirmAmount := 0;
    T2203PEInfirmAmount := 0;
    T2203NSInfirmAmount := 0;
    T2203NBInfirmAmount := 0;
    T2203ONInfirmAmount := 0;
    T2203MBInfirmAmount := 0;
    T2203SKInfirmAmount := 0;
    T2203ABInfirmAmount := 0;
    T2203BCInfirmAmount := 0;
    T2203YTInfirmAmount := 0;
    T2203NTInfirmAmount := 0;
    T2203NUInfirmAmount := 0;

    T2203NLDisab := 0;
    T2203PEDisab := 0;
    T2203NSDisab := 0;
    T2203NBDisab := 0;
    T2203ONDisab := 0;
    T2203MBDisab := 0;
    T2203SKDisab := 0;
    T2203ABDisab := 0;
    T2203BCDisab := 0;
    T2203YTDisab := 0;
    T2203NTDisab := 0;
    T2203NUDisab := 0;

    // 20180323
    Disab18FNo := GetFormNo('DISAB18');

    // calc all Provincial 428 for spouse when spouse is mult, then calc the t2203 provinces
    If ret[RetNo].CouplingSw then
      SpRetNo := GetSpRetNo(RetNo); // 20200410
    // -------------

    T2203Prov := 'NL';
    S11MjForm := 'S11MJ' + T2203Prov;
    If vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
    begin
      //AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED')); // 20180406  //t220516
     //f SpRetNo>0 then T2203NLAgeDed :=GetSpouseAgeDeductionForMJ(SpRetNo,T2203Prov); //20220516  //vl(FetchElm(RetNo, AgeDedFNo, 17));

      {20220516 Did not work yet
      If SpRetNo>0 then
      Begin
       StoreElm(spRetNo,T2203Prov+'428',24,FormatFloat('######.##',T2203NLAgeDed)); //20220516
       Ret[SpRetNo].FrmHasData[GetFormNo(T2203Prov+'428')]:=True;
      //Tv[24]:=GetAgeDeductionForMJ(RetNo,'NL');
      end;
      }

      S5PRV(RetNo, 'S5PRV', GetFormNo('S5PRV'));
      // to get dependants etc //20180401
      Calc(RetNo, T2203Prov + '428'); // 20180401

      DISAB18(RetNo, 'DISAB18', Disab18FNo, T2203Prov);
      T2203NLDisab := MaxR(vl(FetchElmFNo(RetNo, Disab18FNo, 14)),
        vl(FetchElmFNo(RetNo, Disab18FNo, 24)));

      If SpRetNo > 0 then NL428(SpRetNo, T2203Prov + '428', GetFormNo(T2203Prov + '428'));

      //S2MJNL(RetNo, 'S2MJ' + T2203Prov, GetFormNo('S2MJ' + T2203Prov),T2203Prov); // 20180324
      T2203NLSpousexfer := vl(FetchElm(RetNo,GetS2MjFNo(RetNo,T2203Prov) , 19));  //jz//20260325//MJCERT2025 - use GetS2MjFNo as 'S2MJ' + T2203Prov is not the correct form name / number gets wrong amount

      S11MJNL(RetNo, S11MjForm, GetFormNo(S11MjForm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 233, FetchElm(RetNo, S11MjForm, 21));
    end; // 20180314

    T2203Prov := 'PE';
    S11MjForm := 'S11MJ' + T2203Prov;
    If vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
    begin
      AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED')); // 20180406
      T2203PEAgeDed := vl(FetchElm(RetNo, AgeDedFNo, 17));

      S5PRV(RetNo, 'S5PRV', GetFormNo('S5PRV'));
      // to get dependants etc //20180401
      Calc(RetNo, T2203Prov + '428'); // 20180401

      DISAB18(RetNo, 'DISAB18', Disab18FNo, T2203Prov);

      T2203PEDisab := MaxR(vl(FetchElmFNo(RetNo, Disab18FNo, 14)),
        vl(FetchElmFNo(RetNo, Disab18FNo, 24)));

      If SpRetNo > 0 then
        PE428(SpRetNo, T2203Prov + '428', GetFormNo(T2203Prov + '428'));
      // 20200410 Do the spouse's xx428

      S2MJPE(RetNo, 'S2MJ' + T2203Prov, GetFormNo('S2MJ' + T2203Prov), T2203Prov); // 20180324
      T2203PESpousexfer := vl(FetchElm(RetNo, 'S2MJ' + T2203Prov, 19));

      S11MJPE(RetNo, S11MjForm, GetFormNo(S11MjForm), T2203Prov);

      StoreElm(RetNo, T2203FNo, 234, FetchElm(RetNo, S11MjForm, 21));
    end; // 20180314

    T2203Prov := 'NS';
    S11MjForm := 'S11MJ' + T2203Prov;
    If vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
    begin
      AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED')); // 20180406
      T2203NSAgeDed := vl(FetchElm(RetNo, AgeDedFNo, 17));

      S5PRV(RetNo, 'S5PRV', GetFormNo('S5PRV'));
      // to get dependants etc //20180401
      Calc(RetNo, T2203Prov + '428'); // 20180401

      DISAB18(RetNo, 'DISAB18', Disab18FNo, T2203Prov);
      T2203NSDisab := MaxR(vl(FetchElmFNo(RetNo, Disab18FNo, 14)),
        vl(FetchElmFNo(RetNo, Disab18FNo, 24)));

      If SpRetNo > 0 then
        NS428(SpRetNo, T2203Prov + '428', GetFormNo(T2203Prov + '428'));
      // 20200410 Do the spouse's xx428

      S2MJNS(RetNo, 'S2MJ' + T2203Prov, GetFormNo('S2MJ' + T2203Prov),
        T2203Prov); // 20180324

     //20220528  transferS2MJtoS2MJxx(RetNo, T2203Prov); // 20190208
      T2203NSSpousexfer := vl(FetchElm(RetNo, 'S2MJ' + T2203Prov, 19));
      S11MJNS(RetNo, S11MjForm, GetFormNo(S11MjForm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 235, FetchElm(RetNo, S11MjForm, 21));
    end; // 20180314

    T2203Prov := 'SK';
    S11MjForm := 'S11MJ' + T2203Prov;
    If vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
    begin
      AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED'));
      // to get dependants etc //20180401
      T2203SKAgeDed := vl(FetchElm(RetNo, AgeDedFNo, 17));

      S5PRV(RetNo, 'S5PRV', GetFormNo('S5PRV'));
      // to get dependants etc //20180401
      Calc(RetNo, T2203Prov + '428'); // 20180401

      DISAB18(RetNo, 'DISAB18', Disab18FNo, T2203Prov);
      T2203SKDisab := MaxR(vl(FetchElmFNo(RetNo, Disab18FNo, 14)),
        vl(FetchElmFNo(RetNo, Disab18FNo, 24)));

      If SpRetNo > 0 then
        SK428(SpRetNo, T2203Prov + '428', GetFormNo(T2203Prov + '428'));
      // 20200410 Do the spouse's xx428

      S2MJSK(RetNo, 'S2MJ' + T2203Prov, GetFormNo('S2MJ' + T2203Prov),
        T2203Prov); // 20180324
     //20220528  transferS2MJtoS2MJxx(RetNo, T2203Prov); // 20190208

      T2203SKSpousexfer := vl(FetchElm(RetNo, 'S2MJ' + T2203Prov, 19));
      S11MJSK(RetNo, S11MjForm, GetFormNo(S11MjForm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 239, FetchElm(RetNo, S11MjForm, 21));
    end; // 20180314

    T2203Prov := 'AB';
    S11MjForm := 'S11MJ' + T2203Prov;
    If vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
    begin
      AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED')); // 20180406
      T2203ABAgeDed := vl(FetchElm(RetNo, AgeDedFNo, 17));

      S5PRV(RetNo, 'S5PRV', GetFormNo('S5PRV'));
      // to get dependants etc //20180401
      Calc(RetNo, T2203Prov + '428'); // 20180401

      DISAB18(RetNo, 'DISAB18', Disab18FNo, T2203Prov);
      T2203ABDisab := MaxR(vl(FetchElmFNo(RetNo, Disab18FNo, 14)),
        vl(FetchElmFNo(RetNo, Disab18FNo, 24)));

      If SpRetNo > 0 then
        AB428(SpRetNo, T2203Prov + '428', GetFormNo(T2203Prov + '428'));
      // 20200410 Do the spouse's xx428

      S2MJAB(RetNo, 'S2MJ' + T2203Prov, GetFormNo('S2MJ' + T2203Prov), T2203Prov); // 20180324
     //20220528  transferS2MJtoS2MJxx(RetNo, T2203Prov); // 20190208
      T2203ABSpousexfer := vl(FetchElm(RetNo, 'S2MJ' + T2203Prov, 19));
      S11MJAB(RetNo, S11MjForm, GetFormNo(S11MjForm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 240, FetchElm(RetNo, S11MjForm, 21));
    end; // 20180314

    T2203Prov := 'BC';
    S11MjForm := 'S11MJ' + T2203Prov;
    If vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
    begin
      AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED')); // 20180406
      T2203BCAgeDed := vl(FetchElm(RetNo, AgeDedFNo, 17));

      S5PRV(RetNo, 'S5PRV', GetFormNo('S5PRV'));
      // to get dependants etc //20180401
      Calc(RetNo, T2203Prov + '428'); // 20180401
      DISAB18(RetNo, 'DISAB18', Disab18FNo, T2203Prov);
      T2203BCDisab := MaxR(vl(FetchElmFNo(RetNo, Disab18FNo, 14)),
        vl(FetchElmFNo(RetNo, Disab18FNo, 24)));

      If SpRetNo > 0 then
        BC428(SpRetNo, T2203Prov + '428', GetFormNo(T2203Prov + '428'));
      // 20200410 Do the spouse's xx428

      S2MJBC(RetNo, 'S2MJ' + T2203Prov, GetFormNo('S2MJ' + T2203Prov), T2203Prov); // 20180324
     // transferS2MJtoS2MJxx(RetNo, T2203Prov); // 20190208

      T2203BCSpousexfer := vl(FetchElm(RetNo, 'S2MJ' + T2203Prov, 19));
      S11MJBC(RetNo, S11MjForm, GetFormNo(S11MjForm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 241, FetchElm(RetNo, S11MjForm, 21));
    end; // 20180314

    T2203Prov := 'NB';
    S11MjForm := 'S11MJ' + T2203Prov;
    If vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
    begin
      AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED')); // 20180406
      T2203NBAgeDed := vl(FetchElm(RetNo, AgeDedFNo, 17));

      S5PRV(RetNo, 'S5PRV', GetFormNo('S5PRV'));
      // to get dependants etc //20180401
      Calc(RetNo, T2203Prov + '428'); // 20180401

      DISAB18(RetNo, 'DISAB18', Disab18FNo, T2203Prov);
      T2203NBDisab := MaxR(vl(FetchElmFNo(RetNo, Disab18FNo, 14)),
        vl(FetchElmFNo(RetNo, Disab18FNo, 24)));

      If SpRetNo > 0 then
        NB428(SpRetNo, T2203Prov + '428', GetFormNo(T2203Prov + '428'));
      // 20200410 Do the spouse's xx428

      S2MJNB(RetNo, 'S2MJ' + T2203Prov, GetFormNo('S2MJ' + T2203Prov),
        T2203Prov); // 20180324
    //  transferS2MJtoS2MJxx(RetNo, T2203Prov); // 20190208

      T2203NBSpousexfer := vl(FetchElm(RetNo, 'S2MJ' + T2203Prov, 19));
      S11MJNB(RetNo, S11MjForm, GetFormNo(S11MjForm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 236, FetchElm(RetNo, S11MjForm, 21));
    end; // 20180314

    T2203Prov := 'ON';
    S11MjForm := 'S11MJ' + T2203Prov;
    If vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
    begin
      AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED')); // 20180406
      T2203ONAgeDed := vl(FetchElm(RetNo, AgeDedFNo, 17));

      S5PRV(RetNo, 'S5PRV', GetFormNo('S5PRV'));
      // to get dependants etc //20180401
      StoreElm(RetNo, GetFormNo('T2203'), 232, FetchElm(RetNo, 'S5PRV', 98));
      // 20180401
      Calc(RetNo, T2203Prov + '428'); // 20180401

      DISAB18(RetNo, 'DISAB18', Disab18FNo, T2203Prov);
      T2203ONDisab := MaxR(vl(FetchElmFNo(RetNo, Disab18FNo, 14)),
        vl(FetchElmFNo(RetNo, Disab18FNo, 24)));

      If SpRetNo > 0 then
        ON428(SpRetNo, T2203Prov + '428', GetFormNo(T2203Prov + '428'));
      // 20200410 Do the spouse's xx428

      S2MJON(RetNo, 'S2MJ' + T2203Prov, GetFormNo('S2MJ' + T2203Prov),T2203Prov); // 20180324
    //  transferS2MJtoS2MJxx(RetNo, T2203Prov); //20220528
      // for i:=1 to 40 do Begin StoreElm(RetNo,'S2MJON',i,FetchElm(RetNo,'S2MJ#3',i));end;  //20190207 testing only

      T2203ONSpousexfer := vl(FetchElm(RetNo, 'S2MJ' + T2203Prov, 19));
      // StoreElm(RetNo,T2203FNo,517,FormatFloat('######.##',T2203ONSpouseXfer));   //20190205 not solved
      S11MJON(RetNo, S11MjForm, GetFormNo(S11MjForm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 237, FetchElm(RetNo, S11MjForm, 21));
    end; // 20180314

    T2203Prov := 'MB';
    S11MjForm := 'S11MJ' + T2203Prov;
    If vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
    begin
      AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED')); // 20180406
      T2203MBAgeDed := vl(FetchElm(RetNo, AgeDedFNo, 17));

      S5PRV(RetNo, 'S5PRV', GetFormNo('S5PRV'));
      // to get dependants etc //20180401
      Calc(RetNo, T2203Prov + '428'); // 20180401
      Calc(RetNo, 'MB428A'); // 20180401
      Calc(RetNo, 'MBMJA'); // 20190324

      DISAB18(RetNo, 'DISAB18', Disab18FNo, T2203Prov);
      T2203MBDisab := MaxR(vl(FetchElmFNo(RetNo, Disab18FNo, 14)),
        vl(FetchElmFNo(RetNo, Disab18FNo, 24)));

      If SpRetNo > 0 then
        MB428(SpRetNo, T2203Prov + '428', GetFormNo(T2203Prov + '428'));
      // 20200410 Do the spouse's xx428

      S2MJMB(RetNo, 'S2MJ' + T2203Prov, GetFormNo('S2MJ' + T2203Prov),
        T2203Prov); // 20180324
      //20220528 transferS2MJtoS2MJxx(RetNo, T2203Prov); // 20190208
      T2203MBSpousexfer := vl(FetchElm(RetNo, 'S2MJ' + T2203Prov, 19));
      S11MJMB(RetNo, S11MjForm, GetFormNo(S11MjForm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 238, FetchElm(RetNo, S11MjForm, 21));
    end; // 20180314

    T2203Prov := 'YT';
    S11MjForm := 'S11MJ' + T2203Prov;
    If vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
    begin
      AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED')); // 20180406
      T2203YTAgeDed := vl(FetchElm(RetNo, AgeDedFNo, 17));

      S5PRV(RetNo, 'S5PRV', GetFormNo('S5PRV'));
      // to get dependants etc //20180401
      Calc(RetNo, T2203Prov + '428'); // 20180401

      DISAB18(RetNo, 'DISAB18', Disab18FNo, T2203Prov);
      T2203YTDisab := MaxR(vl(FetchElmFNo(RetNo, Disab18FNo, 14)),
        vl(FetchElmFNo(RetNo, Disab18FNo, 24)));

      If SpRetNo > 0 then
        YT428(SpRetNo, T2203Prov + '428', GetFormNo(T2203Prov + '428'));
      // 20200410 Do the spouse's xx428

      S2MJYT(RetNo, 'S2MJ' + T2203Prov, GetFormNo('S2MJ' + T2203Prov),
        T2203Prov); // 20180324
     //20220528  transferS2MJtoS2MJxx(RetNo, T2203Prov); // 20190208
      T2203YTSpousexfer := vl(FetchElm(RetNo, 'S2MJ' + T2203Prov, 19));
      S11MJYT(RetNo, S11MjForm, GetFormNo(S11MjForm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 242, FetchElm(RetNo, S11MjForm, 21));
    end; // 20180314

    T2203Prov     := 'NT';
    S2MjFormNm    := 'S2MJ' + T2203Prov; //jz//20260325//MJCERT2025
    S11MjFormNm   := 'S11MJ' + T2203Prov;
    If vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
    begin
      AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED')); // 20180406
      T2203NTAgeDed := vl(FetchElm(RetNo, AgeDedFNo, 17));

      S5PRV(RetNo, 'S5PRV', GetFormNo('S5PRV'));
      // to get dependants etc //20180401
      Calc(RetNo, T2203Prov + '428'); // 20180401

      DISAB18(RetNo, 'DISAB18', Disab18FNo, T2203Prov);
      T2203NTDisab := MaxR(vl(FetchElmFNo(RetNo, Disab18FNo, 14)),
        vl(FetchElmFNo(RetNo, Disab18FNo, 24)));
      S2MJNT(RetNo, 'S2MJ' + T2203Prov, GetFormNo('S2MJ' + T2203Prov),T2203Prov); // 20180324
     //20220528  transferS2MJtoS2MJxx(RetNo, T2203Prov); // 20190208
      saveS2andS11MJAmounts()

      S2MJNT(RetNo, 'S2MJ' + T2203Prov, GetFormNo(S2MjForm),T2203Prov);           //jz//20260325//MJCERT2025 - ??? is GetFormNo('S2MJ' + T2203Prov) good enough in this case??
      T2203NTSpousexfer := vl(FetchElm(RetNo,GetS2MjFNo(RetNo,T2203Prov) , 19));  //jz//20260325//MJCERT2025 - use GetS2MjFNo as 'S2MJ' + T2203Prov is not the correct form name / number gets wrong amount
      StoreElm(RetNo, T2203FNo, 843,Formatfloat('#####.##',T2203NTSpousexfer));   //20240520

      S11MJNT(RetNo, S11MjForm, GetFormNo(S11MJForm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 243, FetchElm(RetNo, S11MjForm, 21));
    end; // 20180314

    T2203Prov := 'NU';
    S11MjForm := 'S11MJ' + T2203Prov;
    If (vl(GetMJAlloc(RetNo, T2203Prov)) > 0) Or
      (ret[RetNo].Province = T2203Prov)
    // should be in all of them //???? //2''22030401
    then
    begin
      AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED')); // 20180406
      T2203NUAgeDed := vl(FetchElm(RetNo, AgeDedFNo, 17));

      S5PRV(RetNo, 'S5PRV', GetFormNo('S5PRV'));
      // to get dependants etc //20180401
      Calc(RetNo, T2203Prov + '428'); // 20180401

      DISAB18(RetNo, 'DISAB18', Disab18FNo, T2203Prov);
      T2203NUDisab := MaxR(vl(FetchElmFNo(RetNo, Disab18FNo, 14)),
        vl(FetchElmFNo(RetNo, Disab18FNo, 24)));

      If SpRetNo > 0 then
        NS428(SpRetNo, T2203Prov + '428', GetFormNo(T2203Prov + '428')); //20240519
        //NS428(SpRetNo, T2203Prov + '428', GetFormNo(T2203Prov + '428'));
      // 20200410 Do the spouse's xx428

     //20220528  transferS2MJtoS2MJxx(RetNo, T2203Prov); // 20190208
      S2MJNU(RetNo, 'S2MJ' + T2203Prov, GetFormNo('S2MJ' + T2203Prov),T2203Prov); // 20180324
      T2203NUSpousexfer := vl(FetchElm(RetNo, 'S2MJ' + T2203Prov, 19));
      S11MJNU(RetNo, S11MjForm, GetFormNo(S11MjForm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 244, FetchElm(RetNo, S11MjForm, 21));
    end; // 20180314

    If ret[RetNo].Province = 'ON' then
      Calc(RetNo, 'ON479'); // 20180401
    If ret[RetNo].Province = 'NT' then
      Calc(RetNo, 'NT479'); // 20180401
    If ret[RetNo].Province = 'BC' then
      Calc(RetNo, 'BC479'); // 20180401
    If ret[RetNo].Province = 'NU' then
      Calc(RetNo, 'NU479'); // 20180401

    // ------------------------------------------------
    PtransfFNo := GetFormNo('PTRANSF');
    CarePrvFNo := GetFormNo('CAREPRV'); // 20170510
    // Clear it
    for i := 0 to 158 do
    begin
      StoreElm(RetNo, PtransfFNo, i, '');
    end;

    If vl(GetMJAlloc(RetNo, 'NL')) > 0 then
    Begin
      T2203Prov := 'NL';
      PTRANSF(RetNo, 'PTRANSF', PtransfFNo);
      T2203NLDisabxfer := vl(FetchElm(RetNo, PtransfFNo, 71));
      T2203NLTuitionXfer := vl(FetchElm(RetNo, PtransfFNo, 72));
    end;
    If vl(GetMJAlloc(RetNo, 'PE')) > 0 then
    Begin
      T2203Prov := 'PE';
      PTRANSF(RetNo, 'PTRANSF', PtransfFNo);
      T2203PEDisabxfer := vl(FetchElm(RetNo, PtransfFNo, 71));

      If (ret[RetNo].Province <> 'PE') and (T2203PEDisabxfer > 0) then
        T2203PEDisabxfer := ret[RetNo].Lnn[31800]; // 20180406
      T2203PETuitionXfer := vl(FetchElm(RetNo, PtransfFNo, 72));
    end;
    If vl(GetMJAlloc(RetNo, 'NS')) > 0 then
    Begin
      T2203Prov := 'NS';
      PTRANSF(RetNo, 'PTRANSF', PtransfFNo);
      T2203NSDisabxfer := vl(FetchElm(RetNo, PtransfFNo, 71));
      T2203NSTuitionXfer := vl(FetchElm(RetNo, PtransfFNo, 72));
    end;
    If vl(GetMJAlloc(RetNo, 'NB')) > 0 then
    Begin
      T2203Prov := 'NB';
      PTRANSF(RetNo, 'PTRANSF', PtransfFNo);
      T2203NBDisabxfer := vl(FetchElm(RetNo, PtransfFNo, 71));
      T2203NBTuitionXfer := vl(FetchElm(RetNo, PtransfFNo, 72));
    end;
    If vl(GetMJAlloc(RetNo, 'ON')) > 0 then
    Begin
      T2203Prov := 'ON';
      PTRANSF(RetNo, 'PTRANSF', PtransfFNo);
      T2203ONDisabxfer := vl(FetchElm(RetNo, PtransfFNo, 71));
      T2203ONTuitionXfer := vl(FetchElm(RetNo, PtransfFNo, 72));
    end;
    If vl(GetMJAlloc(RetNo, 'MB')) > 0 then
    Begin
      T2203Prov := 'MB';
      PTRANSF(RetNo, 'PTRANSF', PtransfFNo);
      T2203MBDisabxfer := vl(FetchElm(RetNo, PtransfFNo, 71));
      T2203MBTuitionXfer := vl(FetchElm(RetNo, PtransfFNo, 72));
    end;
    If vl(GetMJAlloc(RetNo, 'SK')) > 0 then
    Begin
      T2203Prov := 'SK';
      PTRANSF(RetNo, 'PTRANSF', PtransfFNo);
      T2203SKDisabxfer := vl(FetchElm(RetNo, PtransfFNo, 71));
      T2203SKTuitionXfer := vl(FetchElm(RetNo, PtransfFNo, 72));
    end;
    If vl(GetMJAlloc(RetNo, 'AB')) > 0 then
    Begin
      T2203Prov := 'AB';
      PTRANSF(RetNo, 'PTRANSF', PtransfFNo);
      T2203ABDisabxfer := vl(FetchElm(RetNo, PtransfFNo, 71));
      T2203ABTuitionXfer := vl(FetchElm(RetNo, PtransfFNo, 72));
    end;
    If vl(GetMJAlloc(RetNo, 'BC')) > 0 then
    Begin
      T2203Prov := 'BC';
      PTRANSF(RetNo, 'PTRANSF', PtransfFNo);
      T2203BCDisabxfer := vl(FetchElm(RetNo, PtransfFNo, 71));
      T2203BCTuitionXfer := vl(FetchElm(RetNo, PtransfFNo, 72));
    end;
    If vl(GetMJAlloc(RetNo, 'YT')) > 0 then
    Begin
      T2203Prov := 'YT';
      PTRANSF(RetNo, 'PTRANSF', PtransfFNo);
      T2203YTDisabxfer := vl(FetchElm(RetNo, PtransfFNo, 71));
      T2203YTTuitionXfer := vl(FetchElm(RetNo, PtransfFNo, 72));
    end;
    If vl(GetMJAlloc(RetNo, 'NT')) > 0 then
    Begin
      T2203Prov := 'NT';
      PTRANSF(RetNo, 'PTRANSF', PtransfFNo);
      T2203NTDisabxfer := vl(FetchElm(RetNo, PtransfFNo, 71));
      T2203NTTuitionXfer := vl(FetchElm(RetNo, PtransfFNo, 72));
    end;
    If vl(GetMJAlloc(RetNo, 'NU')) > 0 then
    Begin
      T2203Prov := 'NU';
      PTRANSF(RetNo, 'PTRANSF', PtransfFNo);
      T2203NUDisabxfer := vl(FetchElm(RetNo, PtransfFNo, 71));
      T2203NUTuitionXfer := vl(FetchElm(RetNo, PtransfFNo, 72));
    end;

    T2203NLCareGiver := 0; // 20170509
    T2203PECareGiver := 0; // 20170509
    T2203NSCareGiver := 0; // 20170509
    T2203NBCareGiver := 0; // 20170509
    T2203ONCareGiver := 0; // 20170509
    T2203MBCareGiver := 0; // 20170509
    T2203SKCareGiver := 0; // 20170509
    T2203ABCareGiver := 0; // 20170509
    T2203BCCareGiver := 0; // 20170509
    T2203YTCareGiver := 0; // 20170509
    T2203NTCareGiver := 0; // 20170509
    T2203NUCareGiver := 0; // 20170509

    // 20170510
    S5PrvFNo := GetFormNo('S5PRV');
    If vl(GetMJAlloc(RetNo, 'NL')) > 0 then
    Begin
      T2203Prov := 'NL';
      CAREPRV(RetNo, 'CAREPRV', CarePrvFNo);
      S5PRV(RetNo, 'S5PRV', S5PrvFNo);
      T2203NLCareGiver := vl(FetchElm(RetNo, S5PrvFNo, 112));
      {NL} x:=vl(FetchElm(RetNo, S5PrvFNo, 112)); If X>0 then T2203NLCareGiver:=x;
      T2203NLInfirmAmount := vl(FetchElm(RetNo, S5PrvFNo, 87));
      T2203NLEligDepend := vl(FetchElm(RetNo, S5PrvFNo, 10));
    end;
    If vl(GetMJAlloc(RetNo, 'PE')) > 0 then
    Begin
      T2203Prov := 'PE';
      CAREPRV(RetNo, 'CAREPRV', CarePrvFNo);
      S5PRV(RetNo, 'S5PRV', S5PrvFNo);
      T2203PECareGiver := vl(FetchElm(RetNo, S5PrvFNo, 118));
      {PE} x:=vl(FetchElm(RetNo, S5PrvFNo, 118)); If X>0 then T2203PECareGiver:=x;
      T2203PEInfirmAmount := vl(FetchElm(RetNo, S5PrvFNo, 87));
      T2203PEEligDepend := vl(FetchElm(RetNo, S5PrvFNo, 10));
    end;
    If vl(GetMJAlloc(RetNo, 'NS')) > 0 then
    Begin
      T2203Prov := 'NS';
      CAREPRV(RetNo, 'CAREPRV', CarePrvFNo);
      S5PRV(RetNo, 'S5PRV', S5PrvFNo);
      T2203NSCareGiver := vl(FetchElm(RetNo, S5PrvFNo, 113));
      {NS} x:=vl(FetchElm(RetNo, S5PrvFNo, 113)); If X>0 then T2203NSCareGiver:=x;
      T2203NSInfirmAmount := vl(FetchElm(RetNo, S5PrvFNo, 87));
      T2203NSEligDepend := vl(FetchElm(RetNo, S5PrvFNo, 10));
    end;
    If vl(GetMJAlloc(RetNo, 'NB')) > 0 then
    Begin
      T2203Prov := 'NB';
      CAREPRV(RetNo, 'CAREPRV', CarePrvFNo);
      S5PRV(RetNo, 'S5PRV', S5PrvFNo);
      T2203NBCareGiver := vl(FetchElm(RetNo, S5PrvFNo, 111));
      {NB} x:=vl(FetchElm(RetNo, S5PrvFNo, 111)); If X>0 then T2203NBCareGiver:=x;
      T2203NBInfirmAmount := vl(FetchElm(RetNo, S5PrvFNo, 87));
      T2203NBEligDepend := vl(FetchElm(RetNo, S5PrvFNo, 10));
    end;
    If vl(GetMJAlloc(RetNo, 'ON')) > 0 then
    Begin
      T2203Prov := 'ON';
      CAREPRV(RetNo, 'CAREPRV', CarePrvFNo);
      S5PRV(RetNo, 'S5PRV', S5PrvFNo);
      T2203ONCareGiver := Ret[retno].Lnn[31400]; //vl(FetchElm(RetNo, S5PrvFNo, 90));  //20240521
      {ON} x:=vl(FetchElm(RetNo, S5PrvFNo, 116)); If X>0 then T2203ONCareGiver:=x;
      T2203ONInfirmAmount := vl(FetchElm(RetNo, S5PrvFNo, 87));
      T2203ONEligDepend := vl(FetchElm(RetNo, S5PrvFNo, 10));
    end;
    If vl(GetMJAlloc(RetNo, 'MB')) > 0 then
    Begin
      T2203Prov := 'MB';
      CAREPRV(RetNo, 'CAREPRV', CarePrvFNo);
      S5PRV(RetNo, 'S5PRV', S5PrvFNo);
      T2203MBCareGiver := vl(FetchElm(RetNo, S5PrvFNo, 110));
      {MB} x:=vl(FetchElm(RetNo, S5PrvFNo, 110)); If X>0 then T2203MBCareGiver:=x;
      T2203MBInfirmAmount := vl(FetchElm(RetNo, S5PrvFNo, 87));
      T2203MBEligDepend := vl(FetchElm(RetNo, S5PrvFNo, 10));
    end;
    If vl(GetMJAlloc(RetNo, 'SK')) > 0 then
    Begin
      T2203Prov := 'SK';
      CAREPRV(RetNo, 'CAREPRV', CarePrvFNo);
      S5PRV(RetNo, 'S5PRV', S5PrvFNo);
      T2203SKCareGiver := vl(FetchElm(RetNo, S5PrvFNo, 117));
      {SK} x:=vl(FetchElm(RetNo, S5PrvFNo, 117)); If X>0 then T2203SKCareGiver:=x;

      T2203SKInfirmAmount := vl(FetchElm(RetNo, S5PrvFNo, 87));
      // Calc(RetNo,T2203Prov+'428');  //20180402  //s/b in all
      T2203SKEligDepend := vl(FetchElm(RetNo, 'SK428', 40));   //20210410 insted of 29
      // 20180401 Vl(FetchElm(RetNo, S5PrvFNo, 10)); //maybe for AL?
    end;
    If vl(GetMJAlloc(RetNo, 'AB')) > 0 then
    Begin
      T2203Prov := 'AB';
      CAREPRV(RetNo, 'CAREPRV', CarePrvFNo);
      S5PRV(RetNo, 'S5PRV', S5PrvFNo);
      T2203ABCareGiver := vl(FetchElm(RetNo, S5PrvFNo, 100)); //90));
      x:=vl(FetchElm(RetNo, S5PrvFNo, 100)); If X>0 then T2203ABCareGiver:=x;
      T2203ABInfirmAmount := vl(FetchElm(RetNo, S5PrvFNo, 87));
      T2203ABEligDepend := vl(FetchElm(RetNo, S5PrvFNo, 10));
    end;
    If vl(GetMJAlloc(RetNo, 'BC')) > 0 then
    Begin
      T2203Prov := 'BC';
      CAREPRV(RetNo, 'CAREPRV', CarePrvFNo);
      S5PRV(RetNo, 'S5PRV', S5PrvFNo);
      T2203BCCareGiver := vl(FetchElm(RetNo, S5PrvFNo, 109));
      x:=vl(FetchElm(RetNo, S5PrvFNo, 109)); If X>0 then T2203bcCareGiver:=x;
      T2203BCInfirmAmount := vl(FetchElm(RetNo, S5PrvFNo, 87));
      T2203BCEligDepend := vl(FetchElm(RetNo, S5PrvFNo, 10));
    end;
    If vl(GetMJAlloc(RetNo, 'YT')) > 0 then
    Begin
      T2203Prov := 'YT';
      CAREPRV(RetNo, 'CAREPRV', CarePrvFNo);
      S5PRV(RetNo, 'S5PRV', S5PrvFNo);
      T2203YTCareGiver := vl(FetchElm(RetNo, S5PrvFNo, 110));
      T2203YTInfirmAmount := vl(FetchElm(RetNo, S5PrvFNo, 87));
      T2203YTEligDepend := vl(FetchElm(RetNo, S5PrvFNo, 10));
    end;
    If vl(GetMJAlloc(RetNo, 'NT')) > 0 then
    Begin
      T2203Prov := 'NT';
      CAREPRV(RetNo, 'CAREPRV', CarePrvFNo);
      S5PRV(RetNo, 'S5PRV', S5PrvFNo);
      T2203NTCareGiver := vl(FetchElm(RetNo, S5PrvFNo, 114));
      T2203NTInfirmAmount := vl(FetchElm(RetNo, S5PrvFNo, 87));
      T2203NTEligDepend := vl(FetchElm(RetNo, S5PrvFNo, 10));
    end;

    If vl(GetMJAlloc(RetNo, 'NU')) > 0 then
    Begin
      T2203Prov := 'NU';
      CAREPRV(RetNo, 'CAREPRV', CarePrvFNo);
      S5PRV(RetNo, 'S5PRV', S5PrvFNo);
      T2203NUCareGiver := vl(FetchElm(RetNo, S5PrvFNo, 115));
      T2203NUInfirmAmount := vl(FetchElm(RetNo, S5PrvFNo, 87));
      T2203NUEligDepend := vl(FetchElm(RetNo, S5PrvFNo, 10));
    end;


    // 20200410

    T2203(RetNo, 'T2203', GetFormNo('T2203')); // 20200404
    // calc taxes in each province  //20170515
    NLMJ(RetNo, 'NLMJ', GetFormNo('NLMJ'));
    PEMJ(RetNo, 'PEMJ', GetFormNo('PEMJ'));
    NSMJ(RetNo, 'NSMJ', GetFormNo('NSMJ'));
    NBMJ(RetNo, 'NBMJ', GetFormNo('NBMJ'));
    ONMJ(RetNo, 'ONMJ', GetFormNo('ONMJ'));
    MBMJ(RetNo, 'MBMJ', GetFormNo('MBMJ'));
    MBMJA(RetNo, 'MBMJA', GetFormNo('MBMJA'));
    SKMJ(RetNo, 'SKMJ', GetFormNo('SKMJ'));
    ABMJ(RetNo, 'ABMJ', GetFormNo('ABMJ'));
    BCMJ(RetNo, 'BCMJ', GetFormNo('BCMJ'));
    YTMJ(RetNo, 'YTMJ', GetFormNo('YTMJ'));  //20241122
    NTMJ(RetNo, 'NTMJ', GetFormNo('NTMJ'));
    NUMJ(RetNo, 'NUMJ', GetFormNo('NUMJ'));
    // ShowMessage(FormatFloat('########.##',T2203AbCareGiver));  //20180318

    T2203(RetNo, 'T2203', GetFormNo('T2203'));
    ret[RetNo].Lnn[42800] := vl(FetchElm(RetNo, 'T2203', 993));
  end; // end of MJ
*)
end;

Function PrvTaxBfrT2036(RetNo: integer): Real;
Var
  x: Real;
begin
  Result := 0;
  //20240510
  if IsMultJurisdiction(RetNo)=false then
  begin
   If ret[RetNo].Province = 'ON' then
    Result := MaxR(0, vl(FetchElm(RetNo, 'ON428', 152))); // 20180429
   If ret[RetNo].Province = 'AB' then
    Result := MaxR(0, vl(FetchElm(RetNo, 'AB428', 122)) +
      vl(FetchElm(RetNo, 'AB428', 103)));
   If ret[RetNo].Province = 'BC' then
    Result := MaxR(0, vl(FetchElm(RetNo, 'BC428', 145))); // 20190531
   If ret[RetNo].Province = 'MB' then
    Result := vl(FetchElm(RetNo, 'MB428', 127));
   If ret[RetNo].Province = 'NB' then
    Result := vl(FetchElm(RetNo, 'NB428', 117));
   If ret[RetNo].Province = 'NL' then
    Result := vl(FetchElm(RetNo, 'NL428', 128));
   If ret[RetNo].Province = 'NS' then
    Result := MaxR(0, vl(FetchElm(RetNo, 'NS428', 145)));
   If ret[RetNo].Province = 'NT' then
    Result := vl(FetchElm(RetNo, 'NT428', 118));
   If ret[RetNo].Province = 'NU' then
    Result := MaxR(0, vl(FetchElm(RetNo, 'NU428', 118)));
   If ret[RetNo].Province = 'PE' then
    Result := vl(FetchElm(RetNo, 'PE428', 153));
   If ret[RetNo].Province = 'SK' then
    Result := MaxR(0, vl(FetchElm(RetNo, 'SK428', 143)));
   If ret[RetNo].Province = 'YT' then
    Result := vl(FetchElm(RetNo, 'YT428', 105));
  end
  Else
  Begin
   If ret[RetNo].Province = 'ON' then
    Result := MaxR(0, vl(FetchElm(RetNo, 'ONMJ', 152))); // 20180429
   If ret[RetNo].Province = 'AB' then
    Result := MaxR(0, vl(FetchElm(RetNo, 'ABMJ', 122)) + vl(FetchElm(RetNo, 'ABMJ', 103)));
   If ret[RetNo].Province = 'BC' then  Result := MaxR(0, vl(FetchElm(RetNo, 'BCMJ', 31))); // 20240510
   If ret[RetNo].Province = 'MB' then  Result := vl(FetchElm(RetNo, 'MBMJ', 127));
   If ret[RetNo].Province = 'NB' then  Result := vl(FetchElm(RetNo, 'NBMJ', 117));
   If ret[RetNo].Province = 'NL' then  Result := vl(FetchElm(RetNo, 'NLMJ', 128));
   If ret[RetNo].Province = 'NS' then  Result := MaxR(0, vl(FetchElm(RetNo, 'NSMJ', 145)));
   If ret[RetNo].Province = 'NT' then  Result := vl(FetchElm(RetNo, 'NTMJ', 118));
   If ret[RetNo].Province = 'NU' then  Result := MaxR(0, vl(FetchElm(RetNo, 'NUMJ', 118)));
   If ret[RetNo].Province = 'PE' then  Result := vl(FetchElm(RetNo, 'PEMJ', 153));
   If ret[RetNo].Province = 'SK' then  Result := MaxR(0, vl(FetchElm(RetNo, 'SKMJ', 143)));
   If ret[RetNo].Province = 'YT' then  Result := vl(FetchElm(RetNo, 'YTMJ', 105));
  End;

end;

Procedure BARCODE(RetNo: integer; FName: String; FNo: integer);
Var
  i, Pg1FNo: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Pg1FNo := GetFormNo('T1');
    For i := 1 to 84 do
      Strings[i] := FetchElmFNo(RetNo, Pg1FNo, i);
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure Test(RetNo: integer; FName: String; FNo: integer);
Var
  i, Pg1FNo: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure CLETTER(RetNo: integer; FName: String; FNo: integer);
Var
  ARichEdit: TRichEdit;
begin
  ARichEdit := TRichEdit.Create(Application);
  ARichEdit.Visible := False;
  ARichEdit.Parent := MainFormT1; // 20160119 Igor
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure ADOPT(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[6] := 'Y';
    If Tv[5] > 100 then
      Tv[5] := 100;
    If Tv[5] < 0 then
      Tv[5] := 0;
    Tv[55] := 0;
    i := 8;
    Repeat
      Tv[55] := Tv[55] + Tv[i];
      Inc(i, 2);
    until i > 54;
    Tv[64] := Tv[57] + Tv[59] + Tv[61] + Tv[63];
    Tv[65] := MaxR(0, Tv[55] - Tv[64]);
    Tv[67] := Tv[65]; // provincial
    If Tv[65] > Constant[RY].MaxAdoption then
      Tv[65] := Constant[RY].MaxAdoption;
    If Tv[67] > PrvConstant[RY].PrvMaxAdoption then
      Tv[67] := PrvConstant[RY].PrvMaxAdoption;
    Tv[66] := Tv[65] * Tv[5] / 100;
    Tv[68] := Tv[67] * Tv[5] / 100;
    If (Strings[2] = '') or (CalcAge(Strings[2]) > 17) then
    begin
      Tv[66] := 0;
      Tv[68] := 0;
    end;
  end;
  SaveTv(RetNo, FName, FNo);

  If (ret[RetNo].CouplingSw) and (OptimizeBtnClicked = False) then
  begin
    StoreElm(RetNo, GetFormNo('OPTIMIZE'), 49, FormatFloat('###.##', ret[RetNo].Frm[FNo].Tv[5]));
    StoreElm(RetNo, GetFormNo('OPTIMIZE'), 50,
      FormatFloat('###.##', 100 - ret[RetNo].Frm[FNo].Tv[5]));
  end;
end;

Procedure PTRANSIT(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := 'Y'; // 20170720
    // march 30 2008
    If ret[RetNo].MarStatus > 2 then
    begin
      If Tv[79] = 0 then
        Tv[79] := 100;
      If Strings[1] > '' then
        Strings[1] := 'N';
    end;

    // ditto handling
    If IsDitto(Strings[84]) then
      Strings[84] := Strings[83];
    If IsDitto(Strings[4]) then
      Strings[4] := Strings[84];
    i := 7;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 3];
      Inc(i, 3);
    until i > 76;

    If Tv[79] > 100 then
      Tv[79] := 100;
    If Tv[79] < 0 then
      Tv[79] := 0;
    Tv[78] := Tv[81] + Tv[82] + AddColumns(5, 77, 3);
    Tv[2] := Tv[78] * Tv[79] / 100;
  end;
  SaveTv(RetNo, FName, FNo);

  If (ret[RetNo].CouplingSw) and (OptimizeBtnClicked = False) then
  begin
    StoreElm(RetNo, GetFormNo('OPTIMIZE'), 8, FormatFloat('###.##', ret[RetNo].Frm[FNo].Tv[79]));
    StoreElm(RetNo, GetFormNo('OPTIMIZE'), 11,
      FormatFloat('###.##', 100 - ret[RetNo].Frm[FNo].Tv[79]));
  end;
end;

Procedure RC62(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  FInst: String;
  S1, S2: String;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    FInst := ExtractFormInst(FName);

    If FInst = '#1' then
    begin
      // 20130518
      If (UpperCase(Strings[6]) <> 'Y') and (Strings[7] = '') then
      // no override and not claimed by depandant
      Begin
        If ret[RetNo].MarStatus < 3 then
        Begin
          If IsIncomeLowerForUCCB(RetNo) then
          begin
            Strings[1] := 'X';
            Strings[2] := '';
            Strings[7] := '';
            Strings[10] := '';
            Strings[8] := ''
          end
          else
          begin
            Strings[1] := '';
            Strings[2] := 'X';
            Strings[7] := '';
            Strings[10] := '';
            Strings[8] := '';
          end;
        end
        Else // sinle/divorced etc
        begin
          Strings[1] := 'X';
          Strings[2] := '';
          Strings[7] := '';
          Strings[10] := '';
          Strings[8] := '';
        end;
      end;
      // 20130413
      if Strings[7] > '' then // by dependant
      begin
        Strings[1] := '';
        Strings[2] := '';
      end;

      If UpperCase(Strings[6]) = 'Y' then
      // 20130413 >='' then //20130404 <> 'Y' then  //20100316   //override
      begin
        If (CountKidsUnder6(RetNo) = 0) or (ret[RetNo].MarStatus <> 6) then
        begin
          Strings[7] := '';
          Strings[8] := '';
        end; // no kids or not single

        If (ret[RetNo].MarStatus > 3) // 20150422  include widow
        // If (Ret[RetNo].MarStatus>2)
          and (Strings[7] = '') then
        begin
          Strings[1] := 'X';
          Strings[2] := '';
          Strings[7] := '';
          Strings[10] := '';
          Strings[8] := '';
        end;

        If ret[RetNo].MarStatus < 3 then // married
        begin
          If UpperCase(Strings[6]) = 'Y' then // 20130403
          begin
          end
          else
          Begin
            If IsIncomeLowerForUCCB(RetNo) then
            begin
              Strings[1] := 'X';
              Strings[2] := '';
              Strings[7] := '';
              Strings[10] := '';
              Strings[8] := ''
            end
            else
            begin
              Strings[1] := '';
              Strings[2] := 'X';
              Strings[7] := '';
              Strings[10] := '';
              Strings[8] := '';
            end;
          end;
        end;

        If Strings[7] > '' then
        begin
          If ret[RetNo].Lnn[30400] > 0 then
          begin
            Strings[10] := GetEligibleDependantId(RetNo);
            Strings[8] := GetEligibleDependantNameFromId(RetNo, Strings[10]);
          end;
        end;
      end; // override
    end // FInst=#1
    Else // FInst>#1
    begin
      Strings[7] := FetchElm(RetNo, 'RC62#1', 7);
      // Strings[10]:=FetchElm(RetNo,'RC62#1',10);  //why same name?  20170430
      Strings[8] := FetchElm(RetNo, 'RC62#1', 8);
    end;
  end; // with
  SaveTv(RetNo, FName, FNo);
end;

(* 20151114
  Procedure SPORTS(RetNo: integer; FName: String;FNo: integer);
  Var i:Integer;
  begin
  LoadTv(RetNo,FName,FNo);
  If (ret[RetNo].Province <> 'NS')
  and (IsMultJurisdiction(RetNo) = False) then
  begin
  For i:=1 to 61 do Tv[i]:=0;
  SaveTv(RetNo,FName,FNo);
  Exit;
  end;

  with ret[RetNo].Frm[FNo] do
  begin
  If Ret[RetNo].MarStatus > 2 then begin Tv[1]:=100;Tv[2]:=0;end;
  If Tv[2]>100 then Tv[2]:=100;
  Tv[1]:=MaxR(0,100-Tv[2]);
  Tv[15]:=AddColumns(8,14,2);
  Tv[16]:=MinR(500,Tv[15]);

  Tv[26]:=AddColumns(19,25,2);
  Tv[27]:=MinR(500,Tv[26]);

  Tv[37]:=AddColumns(30,36,2);
  Tv[38]:=MinR(500,Tv[37]);

  Tv[48]:=AddColumns(41,47,2);
  Tv[49]:=MinR(500,Tv[48]);

  Tv[59]:=AddColumns(52,58,2);
  Tv[60]:=MinR(500,Tv[59]);

  Tv[61]:=Tv[16]+Tv[27]+Tv[38]+Tv[49]+Tv[60];
  Tv[3]:=Tv[61] * Tv[1]/100;
  Tv[4]:=Tv[61] * Tv[2]/100;
  end;
  SaveTv(RetNo,FName,FNo);
  end;
*)

Procedure FITNESS(RetNo: integer; FName: String; FNo: integer);
Const
  MxFitness = 500; // 20161119  //1000;
Var
  i, k: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    If ret[RetNo].MarStatus > 2 then
    begin
      Tv[1] := 100;
      Tv[2] := 0;
    end;
    If Tv[2] > 100 then
      Tv[2] := 100;

    // ditto handling
    i := 9;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 13;

    i := 20;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 24;

    i := 31;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 35;

    i := 42;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 46;

    i := 53;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 57;

    Tv[1] := MaxR(0, 100 - Tv[2]);
    Tv[15] := AddColumns(8, 14, 2);
    Tv[16] := MinR(MxFitness, Tv[15]); // MinR(500,Tv[15]);
    If (Strings[62] > '') and (Tv[15] >= 100) then
      Tv[67] := 500
    else
      Tv[67] := 0; // 20111211

    Tv[26] := AddColumns(19, 25, 2);
    Tv[27] := MinR(MxFitness, Tv[26]); // MinR(500,Tv[26]);
    If (Strings[63] > '') and (Tv[26] >= 100) then
      Tv[68] := 500
    else
      Tv[68] := 0;

    Tv[37] := AddColumns(30, 36, 2);
    Tv[38] := MinR(MxFitness, Tv[37]); // MinR(500,Tv[37]);
    If (Strings[64] > '') and (Tv[37] >= 100) then
      Tv[69] := 500
    else
      Tv[69] := 0;

    Tv[48] := AddColumns(41, 47, 2);
    Tv[49] := MinR(MxFitness, Tv[48]); // MinR(500,Tv[48]);
    If (Strings[65] > '') and (Tv[48] >= 100) then
      Tv[70] := 500
    else
      Tv[70] := 0;

    Tv[59] := AddColumns(52, 58, 2);
    Tv[60] := MinR(MxFitness, Tv[59]); // MinR(500,Tv[59]);
    If (Strings[66] > '') and (Tv[59] >= 100) then
      Tv[71] := 500
    else
      Tv[71] := 0;
    If Tv[73] > Tv[72] then
      Tv[73] := Tv[72];
    Tv[61] := Tv[16] + Tv[27] + Tv[38] + Tv[49] + Tv[60] +
      AddColumns(67, 71, 1) + Tv[73];

    Tv[3] := Tv[61] * Tv[1] / 100;
    Tv[75] := Tv[3] * 15 / 100; // 20150126
    Tv[4] := Tv[61] * Tv[2] / 100;
    Tv[76] := Tv[4] * 15 / 100; // 20150126
    // total exp
    Tv[5] := 0;
    i := 15;
    Repeat
      Tv[5] := Tv[5] + Tv[i];
      Inc(i, 11);
    until i > 59;
    Tv[5] := Tv[5] + Tv[72];

    // YT claim
    If ret[RetNo].Province = 'YT' then
      Tv[77] := Tv[61] // 20171205
    Else
      Tv[77] := 0;

    // BC claim //20141118
    If ret[RetNo].Province = 'BC' then
      Tv[74] := MinR(500, Tv[16]) + MinR(500, Tv[27]) + MinR(500, Tv[38]) +
        MinR(500, Tv[49]) + MinR(500, Tv[60]) + AddColumns(67, 71, 1) + Tv[73]
    Else
      Tv[74] := 0;
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure ARTS(RetNo: integer; FName: String; FNo: integer);
Const
  MaxArt = 250;
  MaxArtDisab = 500; // 20161212 250;  //20161119
Var
  i, k: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    If ret[RetNo].MarStatus > 2 then
    begin
      Tv[1] := 100;
      Tv[2] := 0;
    end;
    If Tv[2] > 100 then
      Tv[2] := 100;

    // ditto handling
    i := 9;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 13;

    i := 20;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 24;

    i := 31;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 35;

    i := 42;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 46;

    i := 53;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 57;

    Tv[1] := MaxR(0, 100 - Tv[2]);
    Tv[15] := AddColumns(8, 14, 2);
    Tv[16] := MinR(MaxArt, Tv[15]); // 20161119 //MinR(500,Tv[15]);
    If (Strings[62] > '') and (Tv[15] >= 100) then
      Tv[67] := MaxArtDisab
    else
      Tv[67] := 0; // 20161213

    Tv[26] := AddColumns(19, 25, 2);
    Tv[27] := MinR(MaxArt, Tv[26]);
    If (Strings[63] > '') and (Tv[26] >= 100) then
      Tv[68] := MaxArtDisab
    else
      Tv[68] := 0;

    Tv[37] := AddColumns(30, 36, 2);
    Tv[38] := MinR(MaxArt, Tv[37]);
    If (Strings[64] > '') and (Tv[37] >= 100) then
      Tv[69] := MaxArtDisab
    else
      Tv[69] := 0;

    Tv[48] := AddColumns(41, 47, 2);
    Tv[49] := MinR(MaxArt, Tv[48]);
    If (Strings[65] > '') and (Tv[48] >= 100) then
      Tv[70] := MaxArtDisab
    else
      Tv[70] := 0;

    Tv[59] := AddColumns(52, 58, 2);
    Tv[60] := MinR(MaxArt, Tv[59]);
    If (Strings[66] > '') and (Tv[59] >= 100) then
      Tv[71] := MaxArtDisab
    else
      Tv[71] := 0;
    If Tv[73] > Tv[72] then
      Tv[73] := Tv[72];
    Tv[61] := Tv[16] + Tv[27] + Tv[38] + Tv[49] + Tv[60] +
      AddColumns(67, 71, 1) + Tv[73];
    Tv[3] := Tv[61] * Tv[1] / 100;
    Tv[4] := Tv[61] * Tv[2] / 100;
    // total exp
    Tv[5] := 0;
    i := 15;
    Repeat
      Tv[5] := Tv[5] + Tv[i];
      Inc(i, 11);
    until i > 59;
    Tv[5] := Tv[5] + Tv[72];
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure BCARTS(RetNo: integer; FName: String; FNo: integer); // 20161212
Const
  MaxArt = 500; // 20161124 250;  //20161119
Var
  i, k: integer;
  ArtsFNo: integer;
begin
  // ArtsFNo:=GetFormNo('ARTS');
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    If ret[RetNo].MarStatus > 2 then
    begin
      Tv[1] := 100;
      Tv[2] := 0;
    end;
    If Tv[2] > 100 then
      Tv[2] := 100;

    // ditto handling
    i := 9;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 13;

    i := 20;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 24;

    i := 31;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 35;

    i := 42;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 46;

    i := 53;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 57;

    Tv[1] := MaxR(0, 100 - Tv[2]);
    Tv[15] := AddColumns(8, 14, 2);
    Tv[16] := MinR(MaxArt, Tv[15]); // 20161119 //MinR(500,Tv[15]);
    If (Strings[62] > '') and (Tv[15] >= 100) then
      Tv[67] := MaxArt
    else
      Tv[67] := 0;

    Tv[26] := AddColumns(19, 25, 2);
    Tv[27] := MinR(MaxArt, Tv[26]);
    If (Strings[63] > '') and (Tv[26] >= 100) then
      Tv[68] := MaxArt
    else
      Tv[68] := 0;

    Tv[37] := AddColumns(30, 36, 2);
    Tv[38] := MinR(MaxArt, Tv[37]);
    If (Strings[64] > '') and (Tv[37] >= 100) then
      Tv[69] := MaxArt
    else
      Tv[69] := 0;

    Tv[48] := AddColumns(41, 47, 2);
    Tv[49] := MinR(MaxArt, Tv[48]);
    If (Strings[65] > '') and (Tv[48] >= 100) then
      Tv[70] := MaxArt
    else
      Tv[70] := 0;

    Tv[59] := AddColumns(52, 58, 2);
    Tv[60] := MinR(MaxArt, Tv[59]);
    If (Strings[66] > '') and (Tv[59] >= 100) then
      Tv[71] := MaxArt
    else
      Tv[71] := 0;
    If Tv[73] > Tv[72] then
      Tv[73] := Tv[72];
    Tv[61] := Tv[16] + Tv[27] + Tv[38] + Tv[49] + Tv[60] +
      AddColumns(67, 71, 1) + Tv[73];
    Tv[3] := Tv[61] * Tv[1] / 100;
    Tv[4] := Tv[61] * Tv[2] / 100;
    // total exp
    Tv[5] := 0;
    i := 15;
    Repeat
      Tv[5] := Tv[5] + Tv[i];
      Inc(i, 11);
    until i > 59;
    Tv[5] := Tv[5] + Tv[72];
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure MBARTS(RetNo: integer; FName: String; FNo: integer); // 20151212
Const
  MaxArt = 500; // 20161124 250;  //20161119
Var
  i, k: integer;
  ArtsFNo: integer;
begin
  // ArtsFNo:=GetFormNo('ARTS');
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    If ret[RetNo].MarStatus > 2 then
    begin
      Tv[1] := 100;
      Tv[2] := 0;
    end;
    If Tv[2] > 100 then Tv[2] := 100;

    // ditto handling
    i := 9;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 13;

    i := 20;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 24;

    i := 31;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 35;

    i := 42;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 46;

    i := 53;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 57;

    Tv[1] := MaxR(0, 100 - Tv[2]);

    Tv[15] := AddColumns(8, 14, 2);
    Tv[16] := MinR(MaxArt, Tv[15]);
    If (Strings[62] > '') and (Tv[15] >= 100) then
      Tv[67] := MaxArt
    else
      Tv[67] := 0;

    Tv[26] := AddColumns(19, 25, 2);
    Tv[27] := MinR(MaxArt, Tv[26]);
    If (Strings[63] > '') and (Tv[26] >= 100) then
      Tv[68] := MaxArt
    else
      Tv[68] := 0;

    Tv[37] := AddColumns(30, 36, 2);
    Tv[38] := MinR(MaxArt, Tv[37]);
    If (Strings[64] > '') and (Tv[37] >= 100) then
      Tv[69] := MaxArt
    else
      Tv[69] := 0;

    Tv[48] := AddColumns(41, 47, 2);
    Tv[49] := MinR(MaxArt, Tv[48]);
    If (Strings[65] > '') and (Tv[48] >= 100) then
      Tv[70] := MaxArt
    else
      Tv[70] := 0;

    Tv[59] := AddColumns(52, 58, 2);
    Tv[60] := MinR(MaxArt, Tv[59]);
    If (Strings[66] > '') and (Tv[59] >= 100) then
      Tv[71] := MaxArt
    else
      Tv[71] := 0;
    If Tv[73] > Tv[72] then
      Tv[73] := Tv[72];
    Tv[61] := Tv[16] + Tv[27] + Tv[38] + Tv[49] + Tv[60] +
      AddColumns(67, 71, 1) + Tv[73];
    Tv[3] := Tv[61] * Tv[1] / 100;
    Tv[4] := Tv[61] * Tv[2] / 100;
    // total exp
    Tv[5] := 0;
    i := 15;
    Repeat
      Tv[5] := Tv[5] + Tv[i];
      Inc(i, 11);
    until i > 59;
    Tv[5] := Tv[5] + Tv[72];
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure YTARTS(RetNo: integer; FName: String; FNo: integer); // 20161212
Const
  MaxArt = 500; // 20161124 250;  //20161119
Var
  i, k: integer;
  ArtsFNo: integer;
begin
  // ArtsFNo:=GetFormNo('ARTS');
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin

    If ret[RetNo].MarStatus > 2 then
    begin
      Tv[1] := 100;
      Tv[2] := 0;
    end;
    If Tv[2] > 100 then
      Tv[2] := 100;

    // ditto handling
    i := 9;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 13;

    i := 20;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 24;

    i := 31;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 35;

    i := 42;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 46;

    i := 53;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 57;

    Tv[1] := MaxR(0, 100 - Tv[2]);
    Tv[15] := AddColumns(8, 14, 2);
    Tv[16] := MinR(MaxArt, Tv[15]); // 20161119 //MinR(500,Tv[15]);
    If (Strings[62] > '') and (Tv[15] >= 100) then
      Tv[67] := MaxArt
    else
      Tv[67] := 0;

    Tv[26] := AddColumns(19, 25, 2);
    Tv[27] := MinR(MaxArt, Tv[26]);
    If (Strings[63] > '') and (Tv[26] >= 100) then
      Tv[68] := MaxArt
    else
      Tv[68] := 0;

    Tv[37] := AddColumns(30, 36, 2);
    Tv[38] := MinR(MaxArt, Tv[37]);
    If (Strings[64] > '') and (Tv[37] >= 100) then
      Tv[69] := MaxArt
    else
      Tv[69] := 0;

    Tv[48] := AddColumns(41, 47, 2);
    Tv[49] := MinR(MaxArt, Tv[48]);
    If (Strings[65] > '') and (Tv[48] >= 100) then
      Tv[70] := MaxArt
    else
      Tv[70] := 0;

    Tv[59] := AddColumns(52, 58, 2);
    Tv[60] := MinR(MaxArt, Tv[59]);
    If (Strings[66] > '') and (Tv[59] >= 100) then
      Tv[71] := MaxArt
    else
      Tv[71] := 0;
    If Tv[73] > Tv[72] then
      Tv[73] := Tv[72];
    Tv[61] := Tv[16] + Tv[27] + Tv[38] + Tv[49] + Tv[60] +
      AddColumns(67, 71, 1) + Tv[73];
    Tv[3] := Tv[61] * Tv[1] / 100;
    Tv[4] := Tv[61] * Tv[2] / 100;
    // total exp
    Tv[5] := 0;
    i := 15;
    Repeat
      Tv[5] := Tv[5] + Tv[i];
      Inc(i, 11);
    until i > 59;
    Tv[5] := Tv[5] + Tv[72];
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure MBFITNES(RetNo: integer; FName: String; FNo: integer);
Var
  i, k: integer;
  FitnessFNo: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin

    // copy federal
    // 20160219 //20160223 Igor
    If Strings[100] > '' then
    Begin
      FitnessFNo := GetFormNo('FITNESS');
      For i := 6 to 73 do
      begin
        Strings[i] := FetchElmFNo(RetNo, FitnessFNo, i);
        Tv[i] := vl(FetchElmFNo(RetNo, FitnessFNo, i));
      end;
    end;

    If ret[RetNo].MarStatus > 2 then
    begin
      Strings[1] := 'X';
      Strings[2] := '';
    end;
    If Strings[1] + Strings[2] = '' then
      Strings[1] := 'X';

    // taxpayer
    If (ret[RetNo].Age < 25) then // 20111121
    begin
      Strings[74] := GetFirstName(RetNo);
      If IsDisabled(RetNo) then
        Strings[85] := 'X'
      else
        Strings[85] := '';
    end
    Else
    begin
      Strings[74] := '(Does not qualify)';
      Strings[85] := '';
    end;
    // spouse
    If (CalcAge(GetSpouseBirthDate(RetNo)) < 25) and
      (CalcAge(GetSpouseBirthDate(RetNo)) > 17) then
    begin
      Strings[87] := GetSpouseFirstName(RetNo);
      If SpouseDisabled(RetNo) then
        Strings[98] := 'X'
      else
        Strings[98] := '';
    end
    Else
    begin
      Strings[87] := '(Does not qualify)';
      Strings[98] := '';
    end;

    // ditto handling
    i := 77;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 81;

    If IsDitto(Strings[88]) then
      Strings[88] := Strings[75];
    i := 90;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 94;

    If IsDitto(Strings[7]) then
      Strings[7] := Strings[75];
    i := 9;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 13;

    If IsDitto(Strings[18]) then
      Strings[18] := Strings[7];
    i := 20;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 24;

    If IsDitto(Strings[29]) then
      Strings[29] := Strings[18];
    i := 31;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 35;

    If IsDitto(Strings[40]) then
      Strings[40] := Strings[29];
    i := 42;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 46;

    If IsDitto(Strings[51]) then
      Strings[51] := Strings[40];
    i := 53;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 2];
      Inc(i, 2);
    until i > 57;
    // taxpayer
    Tv[83] := AddColumns(76, 82, 2);
    Tv[84] := MinR(500, Tv[83]);
    If (Strings[85] > '') and (Tv[83] > 100) then
      Tv[86] := 500
    else
      Tv[86] := 0;
    // spouse
    Tv[96] := AddColumns(89, 95, 2);
    Tv[97] := MinR(500, Tv[96]);
    If (Strings[98] > '') and (Tv[96] > 100) then
      Tv[99] := 500
    else
      Tv[99] := 0;

    Tv[15] := AddColumns(8, 14, 2);
    Tv[16] := MinR(500, Tv[15]);
    If (Strings[62] > '') and (Tv[15] > 100) then
      Tv[67] := 500
    else
      Tv[67] := 0;

    Tv[26] := AddColumns(19, 25, 2);
    Tv[27] := MinR(500, Tv[26]);
    If (Strings[63] > '') and (Tv[26] > 100) then
      Tv[68] := 500
    else
      Tv[68] := 0;

    Tv[37] := AddColumns(30, 36, 2);
    Tv[38] := MinR(500, Tv[37]);
    If (Strings[64] > '') and (Tv[37] > 100) then
      Tv[69] := 500
    else
      Tv[69] := 0;

    Tv[48] := AddColumns(41, 47, 2);
    Tv[49] := MinR(500, Tv[48]);
    If (Strings[65] > '') and (Tv[48] > 100) then
      Tv[70] := 500
    else
      Tv[70] := 0;

    Tv[59] := AddColumns(52, 58, 2);
    Tv[60] := MinR(500, Tv[59]);
    If (Strings[66] > '') and (Tv[59] > 100) then
      Tv[71] := 500
    else
      Tv[71] := 0;
    If Tv[73] > Tv[72] then
      Tv[73] := Tv[72];

    Tv[61] := Tv[84] + Tv[97] + Tv[16] + Tv[27] + Tv[38] + Tv[49] + Tv[60] +
      AddColumns(67, 71, 1) + Tv[86] + Tv[99] + Tv[73];
    If Strings[1] > '' then
      Tv[3] := Tv[61]
    else
      Tv[3] := 0;
    If Strings[2] > '' then
      Tv[4] := Tv[61]
    else
      Tv[4] := 0;
    // total exp
    Tv[5] := 0;
    i := 15;
    Repeat
      Tv[5] := Tv[5] + Tv[i];
      Inc(i, 11);
    until i > 59;
    Tv[5] := Tv[5] + Tv[72] + Tv[83] + Tv[96];
    // children+more childeren+taxpayer+spouse
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure S10(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);

  XXString:= ret[RetNo].Province;

  If (ret[RetNo].Province = 'QC') or (IsDeemedResQuebec(RetNo)) then //jz//NonResCERT-R1//202404 - make IsDeemedResQuebec also accptable
    // ok
  else
  Begin
    For i := 1 to 31 do
      ret[RetNo].Frm[FNo].Tv[i] := 0;
    ret[RetNo].Lnn[22300] := 0;
    ret[RetNo].Lnn[31210] := 0;
    ret[RetNo].Lnn[54377] := 0;
    ret[RetNo].Lnn[31215] := 0;
    ret[RetNo].Lnn[54375] := 0; // 20170118
    ret[RetNo].Lnn[54388] := 0;
    SaveTv(RetNo, FName, FNo);
    exit;
  end;

  with ret[RetNo].Frm[FNo] do
  begin
    Tv[1] := GetNonQCT4Box14(RetNo) + vl(FetchElm(RetNo, 'OTHEMPL', 11));
    // 20140614
    Tv[2] := Constant[RY].MaxPPIPEarnings;

    Tv[3] := GetPPIPInsurable(RetNo);
    Tv[4] := MaxR(0, Tv[2] - Tv[3]);
    //Tv[5] := Tv[4]; //jz//NonResCERT-R1//202404 - this is not corect here

    Tv[6] := MinR(Tv[1], Tv[4]); //jz//20251213 - change Tv[5] to Tv[4] as per form
    Strings[7] := FormatFloat('###.###', Constant[RY].PPIPRate);
    Tv[9] := MinR(Constant[RY].MaxPPIP, Tv[6] * vl(Strings[7])/100); //jz//20251213 - put back the /100, was right before // 100);//20251208 //Tv[8]; //cz

    XXString:= ret[RetNo].Province;
    
    If (ret[RetNo].Province <> 'QC') and (not(IsDeemedResQuebec(RetNo))) then //jz//NonResCERT-R1//202404 - make IsDeemedResQuebec(RetNo) also accptable
      Tv[9] := 0;

    Tv[10] := MinR(Constant[RY].MaxUIEarn52, ret[RetNo].T4UIEarnings);
    Strings[11] := FormatFloat('###.##', Constant[RY].QCUIRate * 100);
    // 20140614
    Tv[12] := MinR(Constant[RY].QCMaxUI52, Tv[10] * vl(Strings[11]) / 100);

    Tv[13] := ret[RetNo].T4UIPremium;
    Tv[14] := Tv[12];
    Tv[15] := MaxR(0, Tv[13] - Tv[14]);
    Tv[16] := Tv[15];
    Tv[5]  := minr(Tv[12],Tv[13]); //jz//NonResCERT-R1//202404 - was missing

    // 20140614
    Tv[18] := Constant[RY].MaxPPIPEarnings;
    Tv[19] := ret[RetNo].Lnn[10100] + vl(FetchElm(RetNo, 'OTHEMPL', 11));
    Tv[20] := MaxR(0, Tv[18] - Tv[19]);
    Tv[21] := MinR(Tv[17], Tv[20]);

    Strings[22] := FormatFloat('##0.000', Constant[RY].SEPPIPRate); // 20190208

    Tv[23] := MinR(Constant[RY].MaxSEPPIP, Tv[21] * vl(Strings[22]) / 100);
    Tv[24] := Tv[23];
    //Tv[25] := Tv[24];  //20241206
    Strings[26] := FormatFloat('###.###', Constant[RY].PPIPDeductionRate);
    Tv[28] := Tv[24] * Vl(strings[26])/100; //20241206
    Tv[28] := MinR(360.96,Tv[28]);   //20241206
    Tv[27] := Tv[28]; //Tv[25] * vl(Strings[26]) / 100;    Tv[28] := MinR(Tv[24],360.96);     //20241206

   // Tv[28] := MinR(Tv[24],360.96);
   // Tv[29] := Tv[27];   //20241206
   // Tv[30] := MaxR(0, Tv[28] - Tv[29]);
    //20241206
    Tv[31] := MaxR(0,Tv[24]-Tv[27]);
    Tv[31]:=MinR(Tv[31],Constant[RY].MaxPPIP);
    If ret[RetNo].Province <> 'QC' then Tv[31] := 0;

    ret[RetNo].Lnn[54375] := Tv[17];
    ret[RetNo].Lnn[54377] := Tv[1];
    ret[RetNo].Lnn[54388] := Tv[3];
    ret[RetNo].Lnn[22300] := Tv[27];
    ret[RetNo].Lnn[31215] := Tv[31];
    ret[RetNo].Lnn[31210] := Tv[9];
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure USEDFRM(RetNo: integer; FName: String; FNo: integer);
begin
  // nothing here
end;

Procedure CalcUsedFrm(RetNo: integer);
Var
  i, FNo: integer;
  FName: String;
  MyPageControl: TPageControl;
  MyTabSheet: TTabSheet;
begin
  FName := 'USEDFRM';
  FNo := GetFormNo(FName);
  Try
    // MyChild:=MainForm.ActiveMDIChild as TMyChild;
    MyPageControl := GetChild(RetNo).Pages;
    // GetPageControl(MyChild); //20160119 Igor
    LoadTv(RetNo, FName, FNo);
    with ret[RetNo].Frm[FNo] do
    begin
      For i := 1 to 30 do
      begin
        Strings[i] := '';
      end;
      For i := 0 to MyPageControl.PageCount - 1 do
      begin
        MyTabSheet := MyPageControl.Pages[i];
        If i <= 30 then
          // if +1 is removed then the info screen is not included....
          Strings[i + 1] := MyTabSheet.Caption;
      end;
      Strings[31] := MyPageControl.ActivePage.Caption;
      // FormName; //20160119 Igor
    end;
    SaveTv(RetNo, FName, FNo);
  Except
  end;
end;

Procedure WARNOFF(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  (*
    LoadTv(RetNo,FName,FNo);
    with ret[RetNo].Frm[FNo] do
    begin  //20130209
    For i:=0 to 50 do Strings[i]:='';
    for i:=Low(ret[RetNo].AuditRec) to High(ret[RetNo].AuditRec) do
    Strings[i]:=ret[RetNo].AuditRec[i].Category +
    '-'+ret[RetNo].AuditRec[i].Form+ '-'+ret[RetNo].AuditRec[i].Description;
    end;
    SaveTv(RetNo,FName,FNo);
  *)
end;

Procedure RC59(RetNo: integer; FName: string; FNo: integer);
Var
  i: integer;
Begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
    If UpperCase(Strings[65]) = 'Y' then
    begin
      Strings[6] := OptRec.Prp_Name;
      Strings[9] := LeftStr(OptRec.Prp_BusNo, 9);
    end;

    { 20171212
      //20160307 //20160505 Igor
      If UpperCase(Strings[4])='Y' then
      begin
      Strings[11]:=LeftStr(OptRec.Prp_BusNo,9);
      Strings[46] := OptRec.Prp_Name;
      Strings[73]:=OptRec.Prp_Area+' '+OptRec.Prp_tel;
      end;
    }
    // second page
    i := 17;
    Repeat
      If Strings[i + 1] > '' then
        Strings[i + 2] := '';
      If Strings[i + 4] > '' then
        Strings[i + 5] := '';
      Inc(i, 7);
    until i > 38;

    If Strings[52] = '' then
      Strings[52] := GetFirstName(RetNo);
    If Strings[53] = '' then
      Strings[53] := GetLastName(RetNo);
    If Strings[55] = '' then
      Strings[55] := FormatDateTime('yyyy-mm-dd', Date);
  end;
End;

Procedure RC59I(RetNo: integer; FName: string; FNo: integer);
Var
  i: integer;
Begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
  end;
End;

(* 20220130
Procedure T1005(RetNo: integer; FName: string; FNo: integer);
Begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := AppYear;
    If Length(Strings[2]) = 1 then
      Strings[2] := '0' + Strings[2];
    // 20111108 all calcs
    Tv[9] := Tv[13] + Tv[4];
    Tv[27] := 10;
    Tv[28] := MinR(500, Tv[9] * Tv[27] / 100); // instead of 2500 //20171119
    Tv[8] := Tv[9];
    Tv[5] := 60;
    Tv[14] := MinR(25000, Tv[8] * Tv[5] / 100);

    Tv[31] := Tv[29] + Tv[30];
    Tv[32] := Tv[31];
    Tv[33] := MaxR(0, Tv[14] - Tv[32]); // 20120122

    Tv[10] := vl(FetchElm(RetNo, 'MB428', 69));
    If IsMultJurisdiction(RetNo) = True then
      Tv[10] := vl(FetchElm(RetNo, 'MBMJ', 129));
    Tv[11] := MinR(Tv[28], MinR(Tv[33], Tv[10]));
    If IsDeceased(RetNo) then
      Tv[11] := MinR(Tv[33], Tv[10]); // 20150310

    { //20171119
      Tv[24]:=Tv[33];
      Tv[25]:=Tv[11];
      Tv[26]:=MaxR(0,Tv[24]-Tv[25]);
    }
    If Strings[12] = '' then
      Strings[12] := FormatDateTime('yyyy-mm-dd', Date);
    // 20090322
    If IsMultJurisdiction(RetNo) = True then
      Tv[10] := vl(FetchElm(RetNo, 'MBMJ', 129));
  end;
  SaveTv(RetNo, FName, FNo);
End;
*)
Procedure T1014(RetNo: integer; FName: string; FNo: integer);
Var
  i: integer;
Begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := AppYear;
    // 20130126
    If Strings[21] > '' then
      Tv[2] := 1000
    else
      Tv[2] := 0;
    If Strings[26] > '' then
      Tv[3] := 1000
    else
      Tv[3] := 0;
    Tv[4] := Tv[2] + Tv[3];
    If Strings[27] > '' then
      Tv[5] := 2000
    else
      Tv[5] := 0;
    If Strings[28] > '' then
      Tv[23] := 2500
    else
      Tv[23] := 0; // Tv[22]:=2500 else Tv[22]:=0; //20180123
    // If Strings[29]>'' then Tv[24]:=2500 else Tv[24]:=0; //20180123
    // Tv[6]:=Tv[22]+Tv[24];  //20180123
    // Tv[23]:=Tv[22]+Tv[24];   //Tv[6]; //20180123
    Tv[7] := Tv[5] + Tv[23]; // 20100124

    Tv[8] := 0;
    Tv[9] := 0;
    Tv[12] := 0; // 201801//For i:=8 to 12 do Tv[i]:=0;
    If ret[RetNo].Lnn[31600] > 0 then
      Strings[18] := 'X';

    If (Strings[18] > '') or (Strings[19] > '') then
    begin
      Tv[8] := Tv[4];
      Tv[9] := Tv[7];
      Tv[11] := Tv[8] + Tv[9] + Tv[10];
      Tv[25] := 50;
      Tv[12] := Tv[11] * Tv[25] / 100;
    end;

    Tv[13] := Tv[4];
    Tv[14] := Tv[7];
    Tv[15] := Tv[12];
    Tv[16] := Tv[13] + Tv[14] + Tv[15];
    If Strings[17] = '' then
      Strings[17] := FormatDateTime('yyyy-mm-dd', Date);
  end;
  SaveTv(RetNo, FName, FNo);
End;

Function CalcLn115(RetNo: integer): Real;
begin
  With ret[RetNo] do
  begin
    Result := T4APens + T3Pens + T5Pens + T4RIFPens + +GetRowFromSlip(RetNo,
      'FPENS', 4, 3, 0);
    If Age >= 65 then
      Result := Result + vl(FetchElm(RetNo, 'T2205', 30));
  end;
end;

Function CalcLn15000(RetNo: integer): Real;   //20241221 instead of ln150
begin
  With ret[RetNo] do
  begin
    Result := Lnn[10100] + Lnn[10400] + Lnn[11300] + Lnn[11400] + Lnn[11500] +
      Lnn[11600] + Lnn[11700] + Lnn[11900] + Lnn[12000] + Lnn[12100] +
      Lnn[12200] + Lnn[12500] + Lnn[12600] + Lnn[12700]
      - Lnn[12701]  //29241223  minus
      + Lnn[12800] + Lnn[12900] + Lnn[12905] + Lnn[12906] // 20231209
      + Lnn[13000] + Lnn[13010] // 20191126
      + Lnn[13500] + Lnn[13700] + Lnn[13900] + Lnn[14100] + Lnn[14300]+ Lnn[14700];
  end;
end;

Function CalcLn23300(RetNo: integer): Real;
begin
  With ret[RetNo] do
  begin
    Result := Lnn[20700] + Lnn[20800]+
      Lnn[20805]+           //20231207
      Lnn[21000] + Lnn[21200] + Lnn[21300] +
      Lnn[21400] + Lnn[21500] + Lnn[21700] + Lnn[21900] + Lnn[22000] +
      Lnn[22100] + Lnn[22200] + Lnn[22300] + LNN[22215] + Lnn[22400] +
      Lnn[22900] + Lnn[23100] + Lnn[23200]
      + GetLine51201FromRc269(RetNo); //jz//20260203 - use function //Vl(fetchelm(RetNo,'RC269',54));  //20250306
  end;
end;

Function CalcLn257(RetNo: integer): Real;
begin

  With ret[RetNo] do
  begin
    Result := Lnn[24400] + Lnn[24900]
              + LNN[24901]   //20241211
              + LNN[25395]  //20241211
              + Lnn[25000] + Lnn[25100] + Lnn[25200] +
      Lnn[25300] + Lnn[25400] + Lnn[25500] + Lnn[25600];
  end;
end;

Procedure CalcAllforOptimizeUpToTxbl(RetNo: integer);
Var
  FNo, SpRetNo: integer;
begin
  CalcForOptimizeUpToTxbl(RetNo);
  { calc spouse's return }
  SpRetNo := GetSpRetNo(RetNo);
  If SpRetNo > 0 then
  begin
    If ret[SpRetNo].CouplingSw then
    begin
      CplXfer(RetNo, SpRetNo); // without shared statements
      CalcForOptimizeUpToTxbl(SpRetNo);
      ret[SpRetNo].Changed := True;
      FNo := GetFormNo('S2');
      S2(RetNo, 'S2', FNo);
      CalcForOptimizeUpToTxbl(RetNo);
    end;
  end;
  UpdateChildTaxPanelOnly(RetNo);
  // Mychild.UpdateChildTaxPanel(RetNo); //20160119 Igor
end;

Procedure CalcAllforOptimizeAfterTxbl(RetNo: integer);
Var
  FNo, SpRetNo: integer;
begin
  CalcForOptimizeAfterTxbl(RetNo);
  { calc spouse's return }
  SpRetNo := GetSpRetNo(RetNo);
  If SpRetNo > 0 then
  begin
    If ret[SpRetNo].CouplingSw then
    begin
      CplXfer(RetNo, SpRetNo);
      CalcForOptimizeAfterTxbl(SpRetNo);
      ret[SpRetNo].Changed := True;
      FNo := GetFormNo('S2');
      S2(RetNo, 'S2', FNo);
      CalcForOptimizeAfterTxbl(RetNo);
    end;
  end;
  UpdateChildTaxPanelOnly(RetNo);
  // Mychild.UpdateChildTaxPanel(RetNo); //20160119 Igor
end;

Procedure CalcForOptimizeUpToTxbl(RetNo: integer);
Var
  OptimumMedical, TotalMedical, MedPercent: Real;
  MedFNo: integer;
begin
  With ret[RetNo] do
  Begin
    Calc(RetNo, 'T1032');
    Calc(RetNo, 'OPTIMIZE');
    // Total Income calc
    Lnn[11500] := CalcLn115(RetNo);
    Lnn[15000] := CalcLn15000(RetNo); // total inc
    Calc(RetNo, 'T1'); // does uccb for lower inc spouse
    // Net Income cal
    Lnn[23300] := CalcLn23300(RetNo);
    Lnn[23400] := MaxR(0, Lnn[15000] - Lnn[23300]); { ? }
    CLAW(RetNo, 'CLAW', GetFormNo('CLAW')); // Lnn[23500]
    Lnn[23600] := MaxR(0, Lnn[23400] - Lnn[23500]); // net income
    // Taxable income calc
    If (ret[RetNo].FormHasData['T2222']) then
    begin
      T2222(RetNo, 'T2222', GetFormNo('T2222'));
      ret[RetNo].Lnn[25500] := vl(FetchElm(RetNo, 'T2222', 109));
      // northern res depends on ni
    end
    else
      ret[RetNo].Lnn[25500] := 0;
    Calc(RetNo, 'CFR'); // affects loss application TXBL bfr losses
    Calc(RetNo, 'CFR'); // affects loss application TXBL bfr losses
    Calc(RetNo, 'T657'); // cap gains ded
    Lnn[25700] := CalcLn257(RetNo); // tot de from tot inc
   //Lnn[26000] := Lnn[23600] - Lnn[25700]; //20241211
    Calc(RetNo, 'T1');

    // lines needed for optimizing non ref
    Calc(RetNo, 'TAXCHART');
    // Calc(RetNo,'S1A');  //20141121   //20161117
    // Calc(RetNo, 'S1');

    CalcPrvTaxAndCredits(RetNo); // to establish prov txbl
  end;
end;

Procedure CalcForOptimizeAfterTxbl(RetNo: integer);
begin
  With ret[RetNo] do
  Begin
    // for Non refundable credits
    AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED'),''); // //Lnn[30100]  //Age amount
    // Lnn[30300] //Spousal amount is part of S1
    S2(RetNo, 'S2', GetFormNo('S2')); // Lnn[326]   //Spousal transfer
    PNSDED(RetNo, 'PNSDED', GetFormNo('PNSDED')); // for line 314
    T1032(RetNo, 'T1032', GetFormNo('T1032'));
    STLOAN(RetNo, 'STLOAN', GetFormNo('STLOAN'));
    // Lnn[31900]   //Student loan due to optimization
    CAREGVR(RetNo, 'CAREGVR', GetFormNo('CAREGVR')); // 20130510
    S5(RetNo, 'S5', GetFormNo('S5'));
    S11(RetNo, 'S11', GetFormNo('S11'));
    // (S11//Lnn[32000]   //tuition S11 depends on Taxbl income
    TRANSF(RetNo, 'TRANSF', GetFormNo('TRANSF')); // Calc(RetNo,'TRANSF');
    PTRANSIT(RetNo, 'PTRANSIT', GetFormNo('PTRANSIT'));
    HOMEBUY(RetNo, 'HOMEBUY', GetFormNo('HOMEBUY'));
    FITNESS(RetNo, 'FITNESS', GetFormNo('FITNESS'));
    // ARTS(RetNo,'ARTS',GetFormNo('ARTS'));
    ADOPT(RetNo, 'ADOPT#1', GetFormNo('ADOPT#1')); // Calc(RetNo,'ADOPT#1');
    MEDICAL(RetNo, 'MEDICAL', GetFormNo('MEDICAL'));

    //20210221
    DON(RetNo, 'DON', GetFormNo('DON')); // Calc(RetNo,'DON');
    S9(RetNo, 'S9', GetFormNo('S9')); // Calc(RetNo,'S9'); //Lnn[33200]
    DON(RetNo, 'DON', GetFormNo('DON')); // Calc(RetNo,'DON');
    S9(RetNo, 'S9', GetFormNo('S9')); // //T21210221

    TaxChart(RetNo, 'TAXCHART', GetFormNo('TAXCHART'));
    // S1A(RetNo,'S1A',GetFormNo('S1A'));  //20161117
    // S1(RetNo, 'S1', GetFormNo('S1'));

    POLIT(RetNo, 'POLIT', GetFormNo('POLIT')); // Calc(RetNo,'POLIT');
    MEDREF(RetNo, 'MEDREF', GetFormNo('MEDREF')); // Calc(RetNo,'MEDREF');
    T1(RetNo, 'T1', GetFormNo('T1'));
    // Ln 350   //non ref credits
    // PROVINCIAL
    AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED'),''); // for proviinial
    S2PRV(RetNo, 'S2PRV', GetFormNo('S2PRV')); // Calc(RetNo,'S2PRV');
    CAREPRV(RetNo, 'CAREPRV', GetFormNo('CAREPRV'));
    // Calc(RetNo,'CAREPRV');    //20130510
    S5PRV(RetNo, 'S5PRV', GetFormNo('S5PRV')); // Calc(RetNo,'S5PRV');
    PTRANSF(RetNo, 'PTRANSF', GetFormNo('PTRANSF')); // for prov
    PNSDED(RetNo, 'PNSDED', GetFormNo('PNSDED')); // for prov
    MEDPRV(RetNo, 'MEDPRV', GetFormNo('MEDPRV'));
    // Calc(RetNo,'MEDPRV'); //for proviinial
    S11PRV(RetNo, 'S11PRV', GetFormNo('S11PRV'));
    // Calc(RetNo,'S11PRV');   //based on taxable inc
    CalcPrvTaxAndCredits(RetNo);
    T1(RetNo, 'T1', GetFormNo('T1'));
    GSTC(RetNo, 'GSTC', GetFormNo('GSTC'));
    // Calc(RetNo,'GSTC');  //affected by NI
  end;
end;


Function CalcTransfereeLn314(RetNo: integer): Real; // pension deduction
Var
  x: Real;
  PNSDEDFNo, OptimizeFNo: integer;
  EligiblePension: Real;
  RNo: integer;
begin
  Result := MaxR(2000, vl(FetchElm(RNo, 'PNSDED', 8)));
  // amount for deductionIf

  exit;
end;

Procedure ASSETS(RetNo: integer; FName: string; FNo: integer);
Var
  i: integer;
  FInst: String[4]; // k,Gst,Pst:real;
  { StmList:TStringList; }
Begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
  end; { End with }
  // SaveTv(RetNo,FName,FNo);
End;


Procedure T1032WS(RetNo: integer; FName: string; FNo: integer);
Var
  T1032FNo: integer;
Begin
  T1032FNo := GetFormNo('T1032');
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Tv[1] := vl(FetchElmFNo(RetNo, T1032FNo, 10));
    Tv[3] := MaxR(0, Tv[1] - Tv[2]);
    If Tv[3] < 4000 then
    begin
      Tv[4] := Tv[3];
      Tv[5] := vl(FetchElmFNo(RetNo, T1032FNo, 32));
      Tv[6] := Tv[4] * Tv[5] / 100;
    end
    Else
    begin
      Tv[4] := 0;
      Tv[5] := 0;
      Tv[6] := 0;
    end;
    Tv[7] := vl(FetchElmFNo(RetNo, T1032FNo, 17));
    If Tv[3] > 4000 then
      Tv[8] := Tv[7]
    else
      Tv[8] := MinR(Tv[6], Tv[7]);
  end; { End with }
  SaveTv(RetNo, FName, FNo);
End;

Procedure OPTIMIZE(RetNo: integer; FName: string; FNo: integer);
// bring tot available, copy credit splits to corresponding credit schedules
Var
  i, SpRetNo, PensionerRetNo, TransfereeRetNo, T1032FNo, OthFNo: integer;
  RetToOptimize: integer;
begin
  // when the Optimize button is clicked see ChildWinNew
  LoadTv(RetNo, FName, FNo);

  With ret[RetNo].Frm[FNo] do
  begin
    If ret[RetNo].CouplingSw then
      SpRetNo := GetSpRetNo(RetNo);
    If SpRetNo = 0 then
      exit;
    Strings[55] :=
      'Swap returns (F8) to Optimize with the higher taxable income spouse';
    If Strings[56] + Strings[57] = '' then
      Strings[57] := 'X';
    If Strings[17] = '' then
      Strings[17] := 'Y';
    T1032FNo := GetFormNo('T1032');
    Strings[5] := FetchElmFNo(RetNo, T1032FNo, 34);
    If Strings[13] > '' then
      RetToOptimize := RetNo
    else
      RetToOptimize := SpRetNo;

    Tv[75] := Tv[22]; // 20150323

    PensionerRetNo := GetPensionerRetNo(RetNo);
    TransfereeRetNo := GetTransfereeRetNo(RetNo);
    If RetNo = PensionerRetNo then
    begin
      StoreElm(PensionerRetNo, T1032FNo, 32, Strings[24]); // % split
      StoreElm(TransfereeRetNo, T1032FNo, 32, Strings[24]); // % split
    end;

    // Taxable Income before splitting
    If (SpRetNo > 0) and (ret[RetNo].CouplingSw) then
    begin
      Tv[20] := ret[RetNo].Lnn[26000] + ret[RetNo].Lnn[21000] - ret[RetNo]
        .Lnn[11600];
      Tv[21] := ret[SpRetNo].Lnn[26000] - ret[SpRetNo].Lnn[11600] + ret[SpRetNo]
        .Lnn[21000];
    end;

    If Tv[20] >= Tv[21] then
    begin
      Strings[13] := 'X';
      Strings[14] := '';
    end
    else
    begin
      Strings[13] := '';
      Strings[14] := 'X';
    end;

    // PENSION months
    Strings[44] := FetchElmFNo(RetNo, T1032FNo, 11);
    Strings[42] := FetchElmFNo(RetNo, T1032FNo, 31);
    Strings[43] := Strings[42];

    // Spouse 1
    Strings[51] := FetchElm(RetNo, 'T1', 2);
    Strings[3] := Strings[51];
    Strings[40] := Strings[3];
    Strings[27] := Strings[3];
    Tv[19] := vl(FetchElm(RetNo, 'PNSDED', 3));
    If Tv[24] > 50 then
      Tv[24] := 50;
    If Tv[35] > 50 then
      Tv[35] := 50;
    If Tv[19] = 0 then
      Tv[24] := 0;
    If Tv[35] > 0 then
      Tv[24] := 0;
    If vl(Strings[42]) > 0 then
      Tv[28] := Tv[19] * (vl(Strings[44]) / vl(Strings[42])) * Tv[24] / 100
    else
      Tv[28] := 0;
    // Spouse 2
    If (SpRetNo > 0) and (ret[RetNo].CouplingSw) then
    begin
      Strings[52] := FetchElm(SpRetNo, 'T1', 2);
      Strings[4] := Strings[52];
      Strings[41] := Strings[4];
      Strings[30] := Strings[4];
      Tv[23] := vl(FetchElm(SpRetNo, 'PNSDED', 3));
      If Tv[24] > 50 then
        Tv[24] := 50;
      If Tv[23] = 0 then
        Tv[35] := 0;
      If Tv[35] > 0 then
        Tv[24] := 0;
      Tv[29] := Tv[28];
      If vl(Strings[43]) > 0 then
        Tv[39] := Tv[23] * (vl(Strings[44]) / vl(Strings[43])) * Tv[35] / 100
      else
        Tv[39] := 0;
      Tv[38] := Tv[39];
    end;
    Tv[32] := Tv[19] - Tv[28] + Tv[38];
    Tv[33] := Tv[23] + Tv[29] - Tv[39];

    If Strings[5] <> 'Y' then
    begin
      Tv[24] := 0;
      Tv[35] := 0;
      Tv[28] := 0;
      Tv[29] := 0;
      Tv[38] := 0;
      Tv[39] := 0;
      Tv[19] := 0;
      Tv[23] := 0;
      Tv[32] := 0;
      Tv[33] := 0;
    end;

    // OTHER SPLITS - Get total available - Also copy % to respective forms
    If (SpRetNo > 0) and (ret[RetNo].CouplingSw) then
    begin
      // DEPEND
      OthFNo := GetFormNo('DEPEND');
      Tv[53] := GetTot306(RetNo);
      Tv[54] := GetTot315(RetNo);
      Tv[37] := Tv[53] + Tv[54];
      If Tv[34] > 100 then
        Tv[34] := 100;
      Tv[36] := MaxR(0, 100 - Tv[34]);

      StoreElm(RetNo, OthFNo, 160, FormatFloat('###.##', Tv[34]));
      StoreElm(SpRetNo, OthFNo, 160, FormatFloat('###.##', Tv[36]));

      // TRANSFER DISAB Line 318
      OthFNo := GetFormNo('TRANSF');
      Tv[45] := vl(FetchElmFNo(RetNo, OthFNo, 71));
      If Tv[46] > 100 then
        Tv[46] := 100;
      If Tv[45] = 0 then
      begin
        Tv[46] := 0;
        Tv[47] := 0;
      end;
      Tv[47] := MaxR(0, 100 - Tv[46]);
      If Tv[45] = 0 then
      begin
        Tv[46] := 0;
        Tv[47] := 0;
      end;
      StoreElm(RetNo, OthFNo, 69, FormatFloat('###.##', Tv[46]));
      StoreElm(SpRetNo, OthFNo, 69, FormatFloat('###.##', Tv[47]));

      // TRANSFER DISAB Line 324
      Tv[61] := vl(FetchElmFNo(RetNo, OthFNo, 72));
      If Tv[61] = 0 then
        Tv[61] := vl(FetchElmFNo(SpRetNo, OthFNo, 72));
      If Tv[62] > 100 then
        Tv[62] := 100;
      If (Tv[62] > 0) and (Tv[62] < 100) then
        Tv[62] := 100;
      Tv[63] := MaxR(0, 100 - Tv[62]);
      If Tv[61] = 0 then
      begin
        Tv[62] := 0;
        Tv[63] := 0;
      end;
      StoreElm(RetNo, OthFNo, 70, FormatFloat('###.##', Tv[62]));
      StoreElm(SpRetNo, OthFNo, 70, FormatFloat('###.##', Tv[63]));
      // Medical
      // Medical-330
      OthFNo := GetFormNo('MEDICAL');
      Tv[2] := vl(FetchElmFNo(RetNo, OthFNo, 235));
      If Tv[1] > 100 then
        Tv[1] := 100;
      Tv[6] := 100 - Tv[1];
      If Tv[2] = 0 then
      begin
        Tv[1] := 0;
        Tv[6] := 0;
      end;
      StoreElm(RetNo, OthFNo, 233, FormatFloat('###.##', Tv[1]));
      StoreElm(SpRetNo, OthFNo, 233, FormatFloat('###.##', Tv[6]));
      // Medical-331
      Tv[58] := vl(FetchElmFNo(RetNo, OthFNo, 134));
      If Tv[59] > 100 then
        Tv[59] := 100;
      If Tv[58] = 0 then
      begin
        Tv[59] := 0;
        Tv[60] := 0;
      end;
      Tv[60] := 100 - Tv[59];
      If Tv[58] = 0 then
      begin
        Tv[59] := 0;
        Tv[60] := 0;
      end;
      StoreElm(RetNo, OthFNo, 236, FormatFloat('###.##', Tv[59]));
      StoreElm(SpRetNo, OthFNo, 236, FormatFloat('###.##', Tv[60]));

      // Donations
      OthFNo := GetFormNo('DON');
      Tv[10] := vl(FetchElmFNo(RetNo, OthFNo, 184)) +
        vl(FetchElmFNo(RetNo, OthFNo, 185)); // 20170225
      // Tv[10]:=TotMultiple(RetNo,'DON',184)+TotMultiple(RetNo,'DON',185);

      If Tv[9] > 100 then
        Tv[9] := 100;
      Tv[12] := MaxR(0, 100 - Tv[9]);
      If Tv[10] = 0 then
      begin
        Tv[9] := 0;
        Tv[12] := 0;
      end;
      StoreElm(RetNo, OthFNo, 179, FormatFloat('###.##', Tv[9]));
      StoreElm(SpRetNo, OthFNo, 179, FormatFloat('###.##', Tv[12]));
      // Poli
      OthFNo := GetFormNo('POLIT');
      Tv[16] := vl(FetchElmFNo(RetNo, OthFNo, 20));
      If Tv[15] > 100 then
        Tv[15] := 100;
      Tv[18] := MaxR(0, 100 - Tv[15]);
      If Tv[16] = 0 then
      begin
        Tv[15] := 0;
        Tv[18] := 0;
      end;
      StoreElm(RetNo, OthFNo, 19, FormatFloat('###.##', Tv[15]));
      StoreElm(SpRetNo, OthFNo, 19, FormatFloat('###.##', Tv[18]));

      // Adoption
      OthFNo := GetFormNo('ADOPT#1');
      Tv[48] := vl(FetchElmFNo(RetNo, OthFNo, 65));
      If Tv[49] > 100 then
        Tv[49] := 100;
      Tv[50] := MaxR(0, 100 - Tv[49]);
      If Tv[48] = 0 then
      begin
        Tv[49] := 0;
        Tv[50] := 0;
      end;
      StoreElm(RetNo, OthFNo, 5, FormatFloat('###.##', Tv[49]));
      StoreElm(SpRetNo, OthFNo, 5, FormatFloat('###.##', Tv[50]));
      StoreElm(RetNo, OthFNo, 6, 'Y');
      StoreElm(SpRetNo, OthFNo, 6, 'Y');

      // PTransit
      OthFNo := GetFormNo('PTRANSIT');
      Tv[7] := vl(FetchElmFNo(RetNo, OthFNo, 78));
      If Tv[8] > 100 then
        Tv[8] := 100;
      Tv[11] := MaxR(0, 100 - Tv[8]);
      If Tv[7] = 0 then
      begin
        Tv[8] := 0;
        Tv[11] := 0;
      end;
      StoreElm(RetNo, OthFNo, 79, FormatFloat('###.##', Tv[8]));

      // HomeBuy
      OthFNo := GetFormNo('HOMEBUY');
      Tv[66] := vl(FetchElmFNo(RetNo, OthFNo, 3));
      If Tv[67] > 100 then
        Tv[67] := 100;
      Tv[68] := MaxR(0, 100 - Tv[67]);
      If Tv[66] = 0 then
      begin
        Tv[67] := 0;
        Tv[68] := 0;
      end;
      StoreElm(RetNo, OthFNo, 1, FormatFloat('###.##', Tv[67]));
    end;
  end;
  SaveTv(RetNo, FName, FNo);
End;

Procedure T2202(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  Boxb, BoxC: Real;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Tv[65] := 0;
    Boxb := 0;
    BoxC := 0;
    i := 2;
    Repeat
      If vl(Strings[i + 1]) > 12 then
        Strings[i + 1] := '12';
      If vl(Strings[i + 2]) > 12 then
        Strings[i + 2] := '12';
      Tv[65] := Tv[65] + Tv[i];
      Boxb := Boxb + vl(Strings[i + 1]);
      BoxC := BoxC + vl(Strings[i + 2]);
      Inc(i, 4);
    until i > 62;
    If Boxb > 12 then
      Boxb := 12;
    If BoxC > 12 then
      BoxC := 12;
    If BoxC > 0 then
      Boxb := MinR(Boxb, 12 - BoxC);
    If Boxb < 0 then
      Boxb := 0;
    If IsPreBankruptcyReturn(RetNo) then
    begin
      if Boxb > vl(FetchElm(RetNo, 'BANKRPT', 2)) / 30 then
        Boxb := vl(FetchElm(RetNo, 'BANKRPT', 2)) / 30;
      if BoxC > vl(FetchElm(RetNo, 'BANKRPT', 2)) / 30 then
        BoxC := vl(FetchElm(RetNo, 'BANKRPT', 2)) / 30;
    end;
    Strings[66] := FormatFloat('###', Boxb);
    Strings[67] := FormatFloat('###', BoxC);
    // foreihn
    Tv[71] := Tv[69] * vl(Strings[70]); // 20200319
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T10141(RetNo: integer; FName: String; FNo: integer);
var
  i: integer;
  tempReal: Real;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := AppYear;
    Tv[2] := TotMultiple(RetNo, 'T10141W', 12); // Tv[12];
    Tv[3] := TotMultiple(RetNo, 'T10141W', 21); // Tv[21];
    Tv[4] := TotMultiple(RetNo, 'T10141W', 32); // Tv[32];
    Tv[5] := Tv[2] + Tv[3] + Tv[4];
    If Strings[6] = '' then
      Strings[6] := FormatDateTime('yyyy-mm-dd', Date); // 20130126
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T10141W(RetNo: integer; FName: String; FNo: integer);
var
  i: integer;
  tempReal: Real;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := AppYear;

    Strings[11] := '20'; // 20120123  //'15';
    Tv[12] := MinR(4000, Tv[10] * (vl(Strings[11]) / 100)); // 20101130

    Strings[14] := '15';
    Tv[15] := MinR(2500, Tv[13] * (vl(Strings[14]) / 100));
    Tv[16] := Tv[15];

    Strings[18] := '15';
    Tv[19] := MinR(3000, Tv[17] * (vl(Strings[18]) / 100));
    Tv[20] := Tv[19];

    Tv[21] := Tv[16] + Tv[20];

    // 20180110
    Strings[29] := '50';
    Strings[35] := '5.5';

    If UpperCase(Strings[33]) = 'Y' then // 20130126
    Begin
      // Enhanced Credit
      Tv[26] := Tv[12];
      Tv[27] := Tv[21];
      Tv[28] := Tv[26] + Tv[27];
      // Strings[29] := '50';
      Tv[30] := Tv[28] * (vl(Strings[29]) / 100);
      Tv[31] := Tv[30];

      // Strings[35] := '5.5';
      Tv[25] := Tv[34] * (vl(Strings[35]) / 100);
      Tv[37] := Tv[25];
      Tv[32] := Tv[31] + Tv[37]; // 20120123 //Tv[36];
    end
    Else
    Begin
      For i := 26 to 32 do
      begin
        Tv[i] := 0;
      end;
      Tv[34] := 0;
      Tv[35] := 0;
      Tv[37] := 0;
    end;
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T1132(RetNo: integer; FName: String; FNo: integer);
var
  tempReal: Real;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := GetFirstName(RetNo);
    Strings[2] := GetLastName(RetNo);
    Strings[3] := GetSinNo(RetNo);
    Strings[4] := AppYear;
    If UpperCase(Strings[21]) = 'Y' then // 20140327
    Begin
      Strings[7] := OptRec.Prp_FirstName;
      Strings[8] := OptRec.Prp_LastName;
      Strings[9] := OptRec.Prp_Name;
      Strings[10] := OptRec.Prp_Street;
      Strings[13] := OptRec.Prp_City;
      Strings[14] := OptRec.Prp_Prov;
      Strings[15] := OptRec.Prp_Postal;
      Strings[16] := OptRec.Prp_Countr;
    end;

    If Strings[19] = '' then
      Strings[19] := FetchElm(RetNo, 'INFO', 54);
    If Strings[18] = '' then
      Strings[18] := FetchElm(RetNo, 'INFO', 55);
    If Strings[17] = '' then
      Strings[17] := FormatDateTime('yyyy-mm-dd', Date);
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure RC201(RetNo: integer; FName: String; FNo: integer);
var
  tempReal: Real;
  // InfoFNo: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    If Strings[85] + Strings[86] = '' then
      Strings[86] := 'X'; // prepare and do not override
    If (Strings[87] > '') and (UpperCase(Strings[86]) = 'X') then
    Begin
      // InfoFNo := GetFormNo('INFO');
      Strings[1] := GetFirstName(RetNo);
      Strings[2] := GetLastName(RetNo);
      Strings[3] := GetSinNo(RetNo);
      Strings[4] := FetchElmFNo(RetNo, InfoFNo, 9);
      Strings[6] := FetchElmFNo(RetNo, InfoFNo, 54);
      Strings[5] := FetchElmFNo(RetNo, InfoFNo, 55);
      Strings[8] := FetchElmFNo(RetNo, InfoFNo, 71);
      Strings[7] := FetchElmFNo(RetNo, InfoFNo, 72);
      // addr
      If FetchElmFNo(RetNo, InfoFNo, 22) > '' then
        Strings[9] := FetchElmFNo(RetNo, InfoFNo, 22) + '-' +
          FetchElmFNo(RetNo, InfoFNo, 6)
      else
        Strings[9] := FetchElmFNo(RetNo, InfoFNo, 6);
      Strings[11] := FetchElmFNo(RetNo, InfoFNo, 68);
      Strings[12] := FetchElmFNo(RetNo, InfoFNo, 163);
      Strings[13] := FetchElmFNo(RetNo, InfoFNo, 10);
      Strings[14] := FetchElmFNo(RetNo, InfoFNo, 14);
      Strings[15] := FetchElmFNo(RetNo, InfoFNo, 15);

      // mar
      Strings[23] := FetchElmFNo(RetNo, InfoFNo, 11);
      Strings[24] := FetchElmFNo(RetNo, InfoFNo, 12);
      Strings[25] := FetchElmFNo(RetNo, InfoFNo, 13);
      Strings[26] := FetchElmFNo(RetNo, InfoFNo, 16);
      Strings[27] := FetchElmFNo(RetNo, InfoFNo, 17);
      Strings[28] := FetchElmFNo(RetNo, InfoFNo, 18);

      If Strings[39] + Strings[40] = '' then
        Strings[39] := 'X'; // 20200208
      If Strings[29] + Strings[30] = '' then
        Strings[29] := 'X';
      If Strings[31] + Strings[32] = '' then
        Strings[32] := 'X';
      If Strings[43] + Strings[44] = '' then
        Strings[43] := 'X';
      If Strings[45] + Strings[46] = '' then
        Strings[46] := 'X';
      If Strings[47] + Strings[48] = '' then
        Strings[48] := 'X';
      If Strings[49] + Strings[50] = '' then
        Strings[49] := 'X';
      // spouse
      Strings[34] := FetchElmFNo(RetNo, InfoFNo, 20);
      Strings[35] := FetchElmFNo(RetNo, InfoFNo, 45);
      Strings[36] := FetchElmFNo(RetNo, InfoFNo, 4);
      Strings[37] := FetchElmFNo(RetNo, InfoFNo, 59);
      Strings[15] := FetchElmFNo(RetNo, InfoFNo, 15);
    end;
    //20220203
    Tv[57] := Tv[51] + Tv[53] + Tv[55]+Tv[41];
    Tv[58] := Tv[52] + Tv[54] + Tv[56]+Tv[42];

    Tv[63] := Tv[57] + Tv[59] + Tv[61];
    Tv[64] := Tv[58] + Tv[60] + Tv[62];

    Tv[67] := MaxR(0, Tv[63] - Tv[65]);
    Tv[68] := MaxR(0, Tv[64] - Tv[66]);
    //20220203
    Tv[93]:=Tv[67]+Tv[88];
    Tv[94]:=Tv[68]+Tv[89];

    Tv[97]:=MaxR(0,Tv[93]-Tv[95]);
    Tv[98]:=MaxR(0,Tv[94]-Tv[96]);


    If Strings[81] = '' then
      Strings[81] := FormatDateTime('yyyy-mm-dd', Date);
    If Strings[82] = '' then
      Strings[82] := FormatDateTime('yyyy-mm-dd', Date);

  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure RC210(RetNo: integer; FName: String; FNo: integer);
var
  tempReal: Real;
  // InfoFNo: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[2] := AppYear;
    Strings[3] := GetSinNo(RetNo);
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure CCALIST(RetNo: integer; FName: String; FNo: integer);
var
  i, RowNdx, CCAFNo: integer;
begin
  CCAFNo := GetFormNo('CCALIST');
  CaptureLastYearCCA(RetNo);
  LoadTv(RetNo, FName, FNo);
  SaveTv(RetNo, FName, FNo);
end;

Procedure ExtractCCAList(RetNo: integer; Var RowNdx: integer; FNm: String;
  K1, K2, KBy: integer);
var
  i, j, CCAFNo, FNo: integer;
  FInst: String;
begin
  CCAFNo := GetFormNo('CCALIST');
  For i := 1 to 15 do
  begin
    FInst := '#' + AllTrim(IntToStr(i));
    FNo := GetFormNo(FNm + FInst);
    If FNo > 0 then
    begin
      If ret[RetNo].FormHasData[GetFormName(RetNo, FNo)] then
      begin
        j := K1;
        Repeat
          If (FetchElmFNo(RetNo, FNo, j) > '') and
            (FetchElmFNo(RetNo, FNo, j) <> '0') then
          begin
            StoreElm(RetNo, CCAFNo, RowNdx, FetchElmFNo(RetNo, FNo, j));
            StoreElm(RetNo, CCAFNo, RowNdx + 1, FormatFloat('########.##',
              vl(FetchElmFNo(RetNo, FNo, j + 1))));
            StoreElm(RetNo, CCAFNo, RowNdx + 2, FNm + FInst);
            Inc(j, KBy);
            RowNdx := RowNdx + 3;
          end
          else
          begin
            Inc(j, KBy);
          end;
        until (j > K2) Or (RowNdx > 169);
      end; // has data
    end; // Fno >0
  end;
end;

Procedure GetCurrentYrSum2Data(RNo, FNo, k: integer);
begin
  with ret[RNo].Frm[FNo], ret[RNo] do
  begin
    // tot income
    Tv[10 + k] := Lnn[10100];
    Tv[146 + k] := Lnn[10400];
    Tv[12 + k] := Lnn[11300];
    Tv[14 + k] := Lnn[11400];
    Tv[16 + k] := Lnn[11500];
    Tv[213 + k] := Lnn[11600];
    Tv[209 + k] := Lnn[11700];
    Tv[18 + k] := Lnn[11900];
    Tv[20 + k] := Lnn[12000];
    Tv[22 + k] := Lnn[12100];
    Tv[24 + k] := Lnn[12200];
    Tv[225 + k] := Lnn[12500];
    Tv[26 + k] := Lnn[12600];
    Tv[28 + k] := Lnn[12700];
    Tv[30 + k] := Lnn[12800];
    Tv[32 + k] := Lnn[12900];
    Tv[34 + k] := Lnn[13000];
    Tv[118 + k] := Lnn[13010]; // 20200301
    Tv[36 + k] := Lnn[13500] + Lnn[13700] + Lnn[13900]
      + Lnn[14100] + Lnn[14300];
    Tv[38 + k] := Lnn[14400];
    Tv[40 + k] := Lnn[14500];
    Tv[42 + k] := Lnn[14600];
    Tv[44 + k] := Lnn[15000];
    // net income
    Tv[46 + k] := Lnn[20700];
    Tv[48 + k] := Lnn[20800];
    Tv[215 + k] := Lnn[21000];
    Tv[52 + k] := Lnn[21200];
    Tv[217 + k] := Lnn[21300];
    Tv[54 + k] := Lnn[21400];
    Tv[56 + k] := Lnn[21500];
    Tv[58 + k] := Lnn[21700];
    Tv[60 + k] := Lnn[21900];
    Tv[62 + k] := Lnn[22000];
    Tv[64 + k] := Lnn[22100];
    Tv[66 + k] := Lnn[22200];
    Tv[108 + k] := Lnn[22215]; // 20200217
    Tv[68 + k] := Lnn[22400];
    Tv[70 + k] := Lnn[22900];
    Tv[72 + k] := Lnn[23100];
    Tv[74 + k] := Lnn[23200];
    Tv[76 + k] := Lnn[23500];
    Tv[78 + k] := Lnn[23600];
    // taxable income
    Tv[140 + k] := Lnn[24400];
    // Tv[80 + k] := Lnn[248];     //20181109
    Tv[82 + k] := Lnn[24900];
    Tv[84 + k] := Lnn[25000];
    Tv[86 + k] := Lnn[25100];
    Tv[88 + k] := Lnn[25200];
    Tv[90 + k] := Lnn[25300];
    Tv[92 + k] := Lnn[25400];
    Tv[94 + k] := Lnn[25500];
    Tv[96 + k] := Lnn[25600];
    Tv[98 + k] := Lnn[26000];

    // non ref
    Tv[100 + k] := Lnn[30000];
    Tv[102 + k] := Lnn[30100];
    Tv[104 + k] := Lnn[30300];
    Tv[106 + k] := Lnn[30400];
    Tv[246 + k] := Lnn[30425]; // 22230401
    Tv[248 + k] := Lnn[30450]; // 220180204
    Tv[223 + k] := Lnn[30500]; // 20200222
    Tv[110 + k] := Lnn[30800];
    Tv[112 + k] := Lnn[31000];
    Tv[114 + k] := Lnn[31200];
    Tv[205 + k] := Lnn[31260];
    // Tv[207 + k] := Lnn[364];   //20181109
    // Tv[221 + k] := Lnn[365];   //obsolete
    // Tv[211 + k] := Lnn[370]; // 20111211    obsolete
    Tv[196 + k] := Lnn[31220]; // 20111211
    // Tv[194 + k] := Lnn[368];  //obsolete
    Tv[228 + k] := Lnn[31270];
    Tv[203 + k] := Lnn[31300];
    Tv[194 + k] := Lnn[31350];
    Tv[116 + k] := Lnn[31400];
    Tv[120 + k] := Lnn[31600];
    Tv[230 + k] := Lnn[31217];
    Tv[122 + k] := Lnn[31800];
    Tv[124 + k] := Lnn[31900];
    Tv[126 + k] := Lnn[32300];
    Tv[128 + k] := Lnn[32400];
    Tv[130 + k] := Lnn[32600];
    Tv[132 + k] := Lnn[33200];
    Tv[134 + k] := Lnn[34900];
    Tv[138 + k] := Lnn[35000];
    // tax payable
    Tv[142 + k] := Lnn[40425];
    Tv[144 + k] := Lnn[40427];
    Tv[148 + k] := Lnn[40500]; // foreign tax credit //20200204
    Tv[150 + k] := Lnn[40600];
    Tv[152 + k] := Lnn[41000];
    Tv[154 + k] := Lnn[41200];
    Tv[156 + k] := Lnn[41400];
    Tv[136 + k] := Lnn[41700];
    Tv[158 + k] := Lnn[41800];
    Tv[160 + k] := Lnn[42000]; // 20200104
    Tv[162 + k] := Lnn[42800];
    Tv[164 + k] := Lnn[42100]; // 20200104  cpp
    Tv[166 + k] := Lnn[42200]; // 20200104
    Tv[168 + k] := Lnn[43500];
    // ref credits
    Tv[170 + k] := Lnn[43700];
    Tv[172 + k] := Lnn[44800];
    Tv[241 + k] := Lnn[45110]; // 20190220
    Tv[174 + k] := Lnn[45000];
    Tv[176 + k] := Lnn[45200];
    Tv[219 + k] := Lnn[45300];
    Tv[232 + k] := Lnn[45350]; // 20201215
    Tv[178 + k] := Lnn[45400];
    Tv[180 + k] := Lnn[45600];
    Tv[182 + k] := Lnn[45700];
    // Tv[232 + k] := Lnn[459]; // 20160126  459 obsolete in 2019
    Tv[184 + k] := Lnn[47900];
    Tv[186 + k] := Lnn[47600];
    Tv[188 + k] := Lnn[48200]; // 20200204
    // balance
    Tv[190 + k] := Lnn[48500];
    Tv[192 + k] := Lnn[48400];
  end;
end;

Procedure GetLastYrSum2Data(RNo, k: integer);
Var
  LastYrLnValue: Array [LastYrLnLowBound .. LastYrLnHighBound] of Real;
  TempList: TStringList;
  i, Ln, FNo, Elm: integer;
 // x:Real;
begin
  // populate last year's ln numbers from YrSum
  For i := LastYrLnLowBound to LastYrLnHighBound do LastYrLnValue[i] := 0;
  FNo :=GetFormNo('YRSUM'); //AllTrim(MidStr(TempList[i], 5, 7))); //20231221
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir + '\' + 'LastYrLn.d');
  For i := 0 to TempList.Count - 1 do
  begin
    Ln := MyStrToInt(LeftStr(TempList[i], 3));
    //FNo :=GetFormNo(AllTrim(MidStr(TempList[i], 5, 7))); //20231221
    Elm := MyStrToInt(AllTrim(MidStr(TempList[i], 14, 3)));
    If (Ln > 0) and (FNo > 0) and (Elm > 0) then
      LastYrLnValue[Ln] := vl(FetchElmFNo(RNo, FNo, Elm));
  end;


  FNo :=GetFormNo('YRSUM2'); //20232112  have to get the YRSUM2 formNo so to post to the correct form
  with ret[RNo].Frm[FNo] do
  begin
    // tot income
    Tv[10 + k] := LastYrLnValue[101];
   // x:=Tv[11];
    Tv[146 + k] := LastYrLnValue[104];
    Tv[12 + k] := LastYrLnValue[113];
    Tv[14 + k] := LastYrLnValue[114];
    Tv[16 + k] := LastYrLnValue[115];
    Tv[213 + k] := LastYrLnValue[116];
    Tv[209 + k] := LastYrLnValue[117];
    Tv[18 + k] := LastYrLnValue[119];
    Tv[20 + k] := LastYrLnValue[120];
    Tv[22 + k] := LastYrLnValue[121];
    Tv[24 + k] := LastYrLnValue[122];
    Tv[26 + k] := LastYrLnValue[126];
    Tv[28 + k] := LastYrLnValue[127];
    Tv[30 + k] := LastYrLnValue[128];
    Tv[32 + k] := LastYrLnValue[129];
    Tv[34 + k] := LastYrLnValue[130];
    Tv[36 + k] := LastYrLnValue[135] + LastYrLnValue[137] + LastYrLnValue[139] +
      LastYrLnValue[141] + LastYrLnValue[143];
    Tv[38 + k] := LastYrLnValue[144];
    Tv[40 + k] := LastYrLnValue[145];
    Tv[42 + k] := LastYrLnValue[146];
    Tv[44 + k] := LastYrLnValue[150];
    // net income
    Tv[46 + k] := LastYrLnValue[207];
    Tv[48 + k] := LastYrLnValue[208];
    Tv[50 + k] := LastYrLnValue[209];
    Tv[215 + k] := LastYrLnValue[210];
    Tv[52 + k] := LastYrLnValue[212];
    Tv[217 + k] := LastYrLnValue[213];
    Tv[54 + k] := LastYrLnValue[214];
    Tv[56 + k] := LastYrLnValue[215];
    Tv[58 + k] := LastYrLnValue[217];
    Tv[60 + k] := LastYrLnValue[219];
    Tv[62 + k] := LastYrLnValue[220];
    Tv[64 + k] := LastYrLnValue[221];
    Tv[66 + k] := LastYrLnValue[222];
    Tv[68 + k] := LastYrLnValue[224];
    Tv[70 + k] := LastYrLnValue[229];
    Tv[72 + k] := LastYrLnValue[231];
    Tv[74 + k] := LastYrLnValue[232];
    Tv[76 + k] := LastYrLnValue[235];
    Tv[78 + k] := LastYrLnValue[236];
    // taxable income
    Tv[140 + k] := LastYrLnValue[244];
    Tv[80 + k] := LastYrLnValue[248];
    Tv[82 + k] := LastYrLnValue[249];
    Tv[84 + k] := LastYrLnValue[250];
    Tv[86 + k] := LastYrLnValue[251];
    Tv[88 + k] := LastYrLnValue[252];
    Tv[90 + k] := LastYrLnValue[253];
    Tv[92 + k] := LastYrLnValue[254];
    Tv[94 + k] := LastYrLnValue[255];
    Tv[96 + k] := LastYrLnValue[256];
    Tv[98 + k] := LastYrLnValue[260];

    // non ref
    Tv[100 + k] := LastYrLnValue[300];
    Tv[102 + k] := LastYrLnValue[301];
    Tv[104 + k] := LastYrLnValue[303];
    Tv[246 + k] := LastYrLnValue[304];
    Tv[106 + k] := LastYrLnValue[305];
    Tv[248 + k] := LastYrLnValue[307];
    Tv[223 + k] := LastYrLnValue[367];
    Tv[110 + k] := LastYrLnValue[308];
    Tv[112 + k] := LastYrLnValue[310];
    Tv[114 + k] := LastYrLnValue[312];
    Tv[205 + k] := LastYrLnValue[363];
    Tv[207 + k] := LastYrLnValue[364];
    Tv[221 + k] := LastYrLnValue[365];
    Tv[228 + k] := LastYrLnValue[369]; // 20160505 Igor
    Tv[203 + k] := LastYrLnValue[313];
    Tv[116 + k] := LastYrLnValue[314];
    Tv[120 + k] := LastYrLnValue[316];
    Tv[230 + k] := LastYrLnValue[317];
    Tv[122 + k] := LastYrLnValue[318];
    Tv[124 + k] := LastYrLnValue[319];
    Tv[126 + k] := LastYrLnValue[323];
    Tv[128 + k] := LastYrLnValue[324];
    Tv[130 + k] := LastYrLnValue[326];
    Tv[132 + k] := LastYrLnValue[332];
    Tv[134 + k] := LastYrLnValue[349];
    Tv[138 + k] := LastYrLnValue[350];
    // tax payable
    Tv[142 + k] := LastYrLnValue[425];
    Tv[144 + k] := LastYrLnValue[427];
    Tv[148 + k] := LastYrLnValue[405]; // foreign tax credit
    Tv[150 + k] := LastYrLnValue[406];
    Tv[152 + k] := LastYrLnValue[410];
    Tv[154 + k] := LastYrLnValue[412];
    Tv[156 + k] := LastYrLnValue[414];
    Tv[136 + k] := LastYrLnValue[417];
    Tv[158 + k] := LastYrLnValue[418];
    Tv[160 + k] := LastYrLnValue[420];
    Tv[162 + k] := LastYrLnValue[428];
    Tv[164 + k] := LastYrLnValue[421];
    Tv[166 + k] := LastYrLnValue[422];
    Tv[168 + k] := LastYrLnValue[435];
    // ref credits
    Tv[170 + k] := LastYrLnValue[437];
    Tv[172 + k] := LastYrLnValue[448];
    Tv[241 + k] := LastYrLnValue[449]; // 20190220
    Tv[174 + k] := LastYrLnValue[450];
    Tv[176 + k] := LastYrLnValue[452];
    Tv[219 + k] := LastYrLnValue[453];
    Tv[178 + k] := LastYrLnValue[454];
    Tv[180 + k] := LastYrLnValue[456];
    Tv[182 + k] := LastYrLnValue[457];
    Tv[184 + k] := LastYrLnValue[479];
    Tv[186 + k] := LastYrLnValue[476];
    // Tv[188 + k] := LastYrLnValue[482];  //see below

    Tv[242] := CF_Climate2018; // LastYrLnValue[449]; // 20190220  again

    LastYrLnValue[482] := LastYrLnValue[437] + // 20200312
      LastYrLnValue[448] + CF_Climate2018 +
    // LastYrLnValue[449] +    //20200308  //20200312
      LastYrLnValue[450] + // 20200312
      LastYrLnValue[451] + // 20200312
      LastYrLnValue[452] + // 20200312
      LastYrLnValue[439] + // Xfer to QC
      LastYrLnValue[440] + // QC abatement
      LastYrLnValue[441] + // First nation
      LastYrLnValue[453] + LastYrLnValue[454] + LastYrLnValue[456] + LastYrLnValue
      [457] + LastYrLnValue[469] + // 20200312
      LastYrLnValue[479] + LastYrLnValue[476];

    // 20100320
    If k = 0 then
    begin
      { //20200312
        If ret[RNo].Province = 'QC' then
        LastYrLnValue[482] := LastYrLnValue[482] + LastYrLnValue[451]
        else
        LastYrLnValue[482] := LastYrLnValue[482] + LastYrLnValue[450];
      }
      Tv[188 + k] := LastYrLnValue[482];
    end
    Else
      Tv[188 + k] := vl(FetchElm(RNo, 'YRSUM', 759));

    // balance
    Tv[190 + k] := LastYrLnValue[485];
    Tv[192 + k] := LastYrLnValue[484];
  end;

  TempList.Free;
end;

Procedure ACBSUM(RetNo: integer; FName: String; FNo: integer);
var
  i, j, k, AcbSumFNo, ACBFNo: integer;
  FInst: String;
  AcbForm: String;
  Valu, TotValue: Real;
  Inst: integer;
begin
  FormatSettings.DecimalSeparator := '.';
  TotValue := 0;
  // get totvalue
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'ACBFRM' then
    Begin
      ACBFNo := FRec.FormNo;
      If (ret[RetNo].FormHasData[GetFormName(RetNo, ACBFNo)]) and
        (FetchElmFNo(RetNo, ACBFNo, 568) = '') then // no continuation
      begin
        Valu := vl(FetchElmFNo(RetNo, ACBFNo, 14)) *
          vl(FetchElmFNo(RetNo, ACBFNo, 5)) / 100;
        TotValue := TotValue + Valu;
      end;
    end;
  end;
  // store details into ACBSUM forms
  Inst := 1;
  FInst := '#' + AllTrim(IntToStr(Inst));
  AcbSumFNo := GetFormNo('ACBSUM' + FInst);
  For k := 1 to 361 do
    StoreElm(RetNo, AcbSumFNo, k, '');
  j := 1; // ndx to acbsum
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'ACBFRM' then
    Begin
      ACBFNo := FRec.FormNo;
      AcbForm := FRec.FormName + FRec.FormInst;
      If ret[RetNo].FormHasData[GetFormName(RetNo, ACBFNo)] then
      begin
        If j > 353 then
        begin
          Inst := Inst + 1;
          FInst := '#' + AllTrim(IntToStr(Inst));
          AcbSumFNo := GetFormNo('ACBSUM' + FInst);
          If (AcbSumFNo = 0) then
          begin
            AddPageInstance(RetNo, 'ACBSUM', FInst);
            AcbSumFNo := GetFormNo('ACBSUM' + FInst); { get it again }
            j := 1; // start from beginning
          end
          else
          begin
            For k := 1 to 361 do
              StoreElm(RetNo, AcbSumFNo, k, '');
            j := 1; // start from beginning
          end;
        end; // end of inst change
        If FetchElmFNo(RetNo, ACBFNo, 568) = '' then
        begin
          StoreElm(RetNo, AcbSumFNo, j, AcbForm);
          StoreElm(RetNo, AcbSumFNo, j + 1, FetchElmFNo(RetNo, ACBFNo, 4));
          // type
          StoreElm(RetNo, AcbSumFNo, j + 2, FetchElmFNo(RetNo, ACBFNo, 2));
          // item code
          StoreElm(RetNo, AcbSumFNo, j + 3, FetchElmFNo(RetNo, ACBFNo, 3));
          // description
          StoreElm(RetNo, AcbSumFNo, j + 4, FetchElmFNo(RetNo, ACBFNo, 12));
          // Units
          StoreElm(RetNo, AcbSumFNo, j + 5, FetchElmFNo(RetNo, ACBFNo, 13));
          // unit cost
          StoreElm(RetNo, AcbSumFNo, j + 6, FetchElmFNo(RetNo, ACBFNo, 5)); // %
          Valu := vl(FetchElmFNo(RetNo, ACBFNo, 14)) *
            vl(FetchElmFNo(RetNo, ACBFNo, 5)) / 100;
          StoreElm(RetNo, AcbSumFNo, j + 7, FormatFloat('#######.##', Valu));
          StoreElm(RetNo, AcbSumFNo, 361, FormatFloat('########.00', TotValue));
          ret[RetNo].FormHasData[GetFormName(RetNo, AcbSumFNo)] := True;
          Inc(j, 8);
        end;
      end;
    end;
    LoadTv(RetNo, FName, FNo);
    SaveTv(RetNo, FName, FNo);
  end;
end;

Procedure T1297(RetNo: integer; FName: String; FNo: integer);
var
  i: integer;
  tempReal: Real;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Tv[3] := Tv[1] + Tv[2];
    Tv[4] := MinR(50000, Tv[3]);

    Tv[5] := vl(FetchElm(RetNo, 'NL428', 120));
    Tv[6] := MinR(Tv[4], Tv[5]);

    Tv[7] := Tv[3];
    Tv[8] := Tv[6];
    Tv[9] := MaxR(0, Tv[7] - Tv[8]);
    Tv[12] := Tv[10] + Tv[11] + Tv[16];
    Tv[13] := Tv[12];
    Tv[14] := MaxR(0, Tv[9] - Tv[13]);

    If Strings[15] = '' then
      Strings[15] := FormatDateTime('yyyy-mm-dd', Date);
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T1299(RetNo: integer; FName: String; FNo: integer);
var
  i: integer;
  tempReal: Real;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := AppYear;
    Strings[2] := GetFirstName(RetNo) + ' ' + GetLastName(RetNo);
    Strings[3] := GetSinNo(RetNo);
    Strings[4] := FetchElm(RetNo, 'INFO', 6) + ' ' + FetchElm(RetNo, 'INFO', 22)
      + ' ' + FetchElm(RetNo, 'INFO', 68) + ' ' + FetchElm(RetNo, 'INFO', 163);
    Strings[5] := FetchElm(RetNo, 'INFO', 10) + ' ' + FetchElm(RetNo, 'INFO',
      14) + ' ' + FetchElm(RetNo, 'INFO', 15);

    Tv[9] := 65;
    Tv[10] := Tv[8] * Tv[9] / 100;
    Tv[11] := Tv[10];
    Tv[12] := Tv[7] + Tv[11];

    If vl(Strings[14]) < vl(Strings[13]) then
      Strings[14] := Strings[13];
    if vl(Strings[14]) > 0 then
      Strings[15] := FormatFloat('##0.00###', vl(Strings[13]) / vl(Strings[14]))
    Else
      Strings[15] := '';

    Strings[16] := Strings[15];
    Tv[17] := Tv[12] * vl(Strings[15]);

    {
      Strings[16] := Strings[13];
      Strings[28] := Strings[14];
      If vl(Strings[28]) > 0 then
      Tv[17] := Tv[15] * vl(Strings[16]) / vl(Strings[28])
      else
      Tv[17] := 0;
    }
    // Tv[18] := Tv[17];
    Tv[20] := Tv[17] + Tv[19];
    Tv[21] := 40;
    Tv[22] := MinR(100000, Tv[20] * Tv[21] / 100);

    // 20111108
    // Tv[24] := 10;
    // Tv[25] := Tv[23] * Tv[24] / 100;
    Tv[31] := 15;
    Tv[32] := Tv[30] * Tv[31] / 100;
    Tv[26] := Tv[32]; // 20140816
    // Tv[29] := Tv[25] + Tv[26]; // 20140816 //Tv[25]+Tv[32];
    Tv[27] := Tv[22] + Tv[26];
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure Calc(RetNo: integer; FName: string); { ALL FORMS IN CAPITAL }
Var
  i, FNo: integer;
Begin
  if IsVtClient then
    exit; // 20210112 //20210115 Igor
  FNo := GetFormNo(FName);
  If FNo = 0 then
    exit; { not found }
  If ret[RetNo].Frm[FNo].Count = 0 then
    InitFormData(RetNo, FNo);
  if FName = 'T1' then
  begin
    T1(RetNo, 'T1', FNo);
    exit;
  end
  else if FName = 'CDE' then
  begin
    CDE(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'FAMSET' then
  begin
    FAMSET(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'FORECLO' then
  begin
    FORECLO(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'USEDFRM' then
  begin
    USEDFRM(RetNo, FName, FNo);
    exit;
  end
  // else if FName = 'WARNOFF' then begin WARNOFF(RetNo,FName,FNo);exit; end
  else if FName = 'CLETTER' then
  begin
    CLETTER(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 5) = 'RC59#' then
  begin
    RC59(RetNo, FName, FNo);
    exit;
  end // 20171212
  else if FName = 'BARCODE' then
  begin
    BARCODE(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T1032' then
  begin
    T1032(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T1032WS' then
  begin
    T1032WS(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T1132' then
  begin
    T1132(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T1129' then
  begin
    T1129(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T1232' then
  begin
    T1232(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T10142' then
  begin
    T10142(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 7) = 'T10142W' then
  begin
    T10142W(RetNo, FName, FNo);
    exit;
  end
  { Slips }
  else if LeftStr(FName, 3) = 'T4#' then
  begin
    T4(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 4) = 'T4A#' then
  begin
    T4A(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 7) = 'T4ARCA#' then
  begin
    T4ARCA(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 5) = 'T4AP#' then
  begin
    T4AP(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 6) = 'T4RSP#' then
  begin
    T4RSP(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 6) = 'T4RIF#' then
  begin
    T4RIF(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 7) = 'T4AOAS#' then
  begin
    T4AOAS(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 5) = 'T4PS#' then
  begin
    T4PS(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 4) = 'T4E#' then
  begin
    T4E(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 7) = 'T3MULT#' then
  begin
    T3MULT(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 3) = 'T5#' then
  begin
    T5(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 7) = 'T5MULT#' then
  begin
    T5MULT(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 6) = 'T5007#' then
  begin
    T5007(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 6) = 'T5013#' then
  begin
    T5013(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 5) = 'T101#' then
  begin
    T101(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 5) = 'T102#' then
  begin
    T102(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 6) = 'T4SUM#' then
  begin
    T4Sum(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 7) = 'OPECGB#' then
  begin
    OPECGB(RetNo, FName, FNo);
    exit;
  end
  { Credits }
  else if FName = 'ON428' then
  begin
    ON428(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'ON479' then
  begin
    ON479(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'OEPTC' then
  begin
    OEPTC(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'ONBEN' then
  begin
    ONBEN(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T1241' then
  begin
    T1241(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T1256' then
  begin
    T1256(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T12561' then
  begin
    T12561(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T1258' then
  begin
    T1258(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T1272' then
  begin
    T1272(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'S2PRV' then
  begin
    S2PRV(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'S11PRV' then
  begin
    S11PRV(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 4) = 'S12#' then
  begin
    S12(RetNo, FName, FNo);
    exit;
  end
  //jz//20260127 - not discontinued //20260106 discontinued CZ
  else if LeftStr(FName, 7) = 'HOMEWS#' then  //20231209
  begin
    HOMEWS(RetNo, FName, FNo);
    exit;
  end



  else if FName = 'S12BC' then begin S12BC(RetNo, FName, FNo); exit;  end
//else if FName = 'S12SK' then begin S12BC(RetNo, FName, FNo); exit;  end //20220225 //20240131
  else if FName = 'S12NB' then begin S12NB(RetNo, FName, FNo); exit;  end // 20151102
  else if FName = 'BC428' then
  begin
    BC428(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'BC479' then
  begin
    BC479(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'NB428' then
  begin
    NB428(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'NL428' then
  begin
    NL428(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'NT428' then
  begin
    NT428(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'NT479' then
  begin
    NT479(RetNo, FName, FNo);
    exit;
  end

  else if FName = 'PE428' then
  begin
    PE428(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'MB479' then
  begin
    MB479(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'MB428' then
  begin
    MB428(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'MBFITNES' then
  begin
    MBFITNES(RetNo, FName, FNo);
    exit;
  end

  else if FName = 'SK428' then
  begin
    SK428(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'SK479' then begin SK479(RetNo,FName,FNo);exit; end  //20211229

  else if FName = 'YT428' then
  begin
    YT428(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'YT479' then
  begin
    YT479(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'AB428' then
  begin
    AB428(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'NS428' then
  begin
    NS428(RetNo, FName, FNo);
    exit;
  end

  else if FName = 'NSLS' then
  begin
    NSLS(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'NU428' then
  begin
    NU428(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'NU479' then
  begin
    NU479(RetNo, FName, FNo);
    exit;
  end

  else if FName = 'YT432' then
  begin
    YT432(RetNo, FName, FNo);
    exit;
  end

  {20220130
  else if FName = 'T1005' then
  begin
    T1005(RetNo, FName, FNo);
    exit;
  end
  }
  else if FName = 'T1014' then
  begin
    T1014(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 8) = 'T10141W#' then
  begin
    T10141W(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 8) = 'T10142W#' then
  begin
    T10142W(RetNo, FName, FNo);
    exit;
  end
  // else if FName = 'T1284'  then begin T1284(RetNo,FName,FNo);exit; end  //20171217
  else if FName = 'T1285' then
  begin
    T1285(RetNo, FName, FNo);
    exit;
  end

  // Schedules
  {
    else if FName = 'S1' then
    begin
    // S1(RetNo, FName, FNo);
    exit;
    end
  }
  else if FName = 'TAXCHART' then
  begin
    TaxChart(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'S2' then begin S2(RetNo, FName, FNo); exit; end
  else if FName = 'S3' then begin S3(RetNo, FName, FNo); exit; end
  else if LeftStr(FName, 6) = 'S3ACB#' then begin S3ACB(RetNo, FName, FNo); exit; end

  // 20250912 Igor >>>
  else if LeftStr(FName, 7) = 'S3SUPL#' then begin S3SUPL(RetNo, FName, FNo); exit; end
  else if LeftStr(FName, 8) = 'S3QSUPL#' then begin S3QSUPL(RetNo, FName, FNo); exit; end
  // 20250912 Igor <<<

  else if FName = 'S4' then
  begin
    S4(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'S5SUPL' then
  begin
    S5SUPL(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'S5' then
  begin
    S5(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'S6' then
  begin
    S6(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'S6QC' then
  begin
    S6QC(RetNo, FName, FNo);
    exit;
  end // 20171205
  else if FName = 'S5PRV' then
  begin
    S5PRV(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'S7' then
  begin
    S7(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'S8' then
  begin
    S8(RetNo, FName, FNo);
    exit;
  end
  // else if FName = 'CPPADJ'  then begin CPPADJ(RetNo,FName,FNo);exit; end  //20130302
  else if FName = 'S8Q' then
  begin
    S8Q(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'S9' then
  begin
    S9(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'MEDREF' then
  begin
    MEDREF(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'S11' then
  begin
    S11(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'S13' then
  begin
    S13(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'HOMEBUY' then
  begin
    HOMEBUY(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'AGEDED' then
  begin
    AGEDED(RetNo, FName, FNo,'');
    exit;
  end
  else if FName = 'DTC' then
  begin
    DTC(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'CAREGVR' then
  begin
    CAREGVR(RetNo, FName, FNo);
    exit;
  end // 20130510
  else if FName = 'CAREPRV' then
  begin
    CAREPRV(RetNo, FName, FNo);
    exit;
  end // 20130510
  else if FName = 'SNRESA' then
  begin
    SNRESA(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'SNRESB' then
  begin
    SNRESB(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'SNRC' then
  begin
    SNRC(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'CPT20' then
  begin
    CPT20(RetNo, FName, FNo);
    exit;
  end
  { Forms }
  else if LeftStr(FName, 6) = 'T1013#' then
  begin
    T1013(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'RC267' then
  begin
    RC267(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'RC268' then
  begin
    RC268(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'RC269' then
  begin
    RC269(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T1023' then
  begin
    T1023(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T183' then
  begin
    T183(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T1A' then
  begin
    T1A(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T1DD' then
  begin
    T1DD(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T1OVP' then
  begin
    T1OVP(RetNo, FName, FNo);
    exit;
  end // 20170624
  else if LeftStr(FName, 4) = 'T1M#' then
  begin
    T1M(RetNo, FName, FNo);
    exit;
  end

  else if FName = 'T1033' then
  begin
    T1033(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T2017' then
  begin
    T2017(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T2036' then
  begin
    T2036(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T2038' then
  begin
    T2038(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T2038I' then
  begin
    T2038I(RetNo, FName, FNo);
    exit;
  end

  else if LeftStr(FName, 6) = 'T2091#' then
  begin
    T2091(RetNo, FName, FNo);
    exit;
  end // 20180303
  else if LeftStr(FName, 6) = 'T1255#' then
  begin
    T1255(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T209W' then
  begin
    T209W(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T2097' then
  begin
    T2097(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T5004' then
  begin
    T5004(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T2202' then
  begin
    T2202(RetNo, FName, FNo);
    exit;
  end

  else if FName = 'T2203' then
  begin
    T2203(RetNo, FName, FNo);
    exit;
  end

  else if FName = 'T1153' then
  begin
    T1153(RetNo, FName, FNo);
    exit;
  end

  else if FName = 'T1159' then
  begin
    T1159(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T1161' then
  begin
    T1161(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 6) = 'T1161#' then
  begin
    T1161(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 6) = 'T1243#' then
  begin
    T1243(RetNo, FName, FNo);
    exit;
  end

  else if LeftStr(FName, 6) = 'T1170#' then
  begin
    T1170(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T1172' then
  begin
    T1172(RetNo, FName, FNo);
    exit;
  end

  else if FName = 'T1198' then
  begin
    T1198(RetNo, FName, FNo);
    exit;
  end

  else if FName = 'T1212' then
  begin
    T1212(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T1221' then
  begin
    T1221(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T1297' then
  begin
    T1297(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 6) = 'T1299#' then
  begin
    T1299(RetNo, FName, FNo);
    exit;
  end

  else if FName = 'T1231' then
  begin
    T1231(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'STATUS' then
  begin
    STATUS(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'PTIMEWS' then
  begin
    PTIMEWS(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'YRSUM' then
  begin
    YRSUM(RetNo, FName, FNo);
    exit;
  end // 20101206

  else if FName = 'T1135' then
  begin
    T1135(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'FPCHECK' then
  begin
    FPCHECK(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'FPINFO' then
  begin
    FPINFO(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'DIAGNO' then
  begin
    DIAGNO(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'PTRANSIT' then
  begin
    PTRANSIT(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'HOMEBUY' then
  begin
    HOMEBUY(RetNo, FName, FNo);
    exit;
  end
  // else if FName = 'SPORTS'  then begin SPORTS(RetNo,FName,FNo);exit; end  //20151114
  else if FName = 'FITNESS' then
  begin
    FITNESS(RetNo, FName, FNo);
    exit;
  end
  // else if FName = 'ARTS'  then begin ARTS(RetNo,FName,FNo);exit; end
  else if FName = 'T1ADJI' then
  begin
    T1ADJi(RetNo, FName, FNo);
    exit;
  end
  { Mult statements }
  else if LeftStr(FName, 6) = 'ADOPT#' then
  begin
    ADOPT(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 5) = 'RC62#' then
  begin
    RC62(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 6) = 'T1ADJ#' then
  begin
    T1ADJ(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 7) = 'ASSETS#' then
  begin
    ASSETS(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 6) = 'FLDMEM' then
  begin
    FLDMEM(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 7) = 'FLDTAPE' then
  begin
    FLDTAPE(RetNo, FName, FNo);
    exit;
  end

  else if LeftStr(FName, 5) = 'T1139' then
  begin
    T1139(RetNo, FName, FNo);
    exit;
  end

  else if FName = 'T1206' then // 20181215
  begin
    T1206(RetNo, FName, FNo);
    exit;
  end

  else if LeftStr(FName, 6) = 'AUTOS#' then
  begin
    Autos(RetNo, FName, FNo);
    exit;
  end

  else if LeftStr(FName, 8) = 'ASSETSB#' then
  begin
    AssetsB(RetNo, FName, FNo);
    exit;
  end


  else if LeftStr(FName, 8) = 'AUTO777#' then
  begin
    AUTO777(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 5) = 'FPENS' then
  begin
    FPENS(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 6) = 'T2125#' then
  begin
    T2125(RetNo, FName, FNo);
    exit;
  end

  else if LeftStr(FName, 9) = 'T2125SUM#' then
  begin
    T2125SUM(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 9) = 'T2121SUM#' then
  begin
    T2121SUM(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 9) = 'T2042SUM#' then
  begin
    T2042SUM(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 9) = 'T1163SUM#' then
  begin
    T1163SUM(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 9) = 'T1273SUM#' then
  begin
    T1273SUM(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 8) = 'T776SUM#' then
  begin
    T776SUM(RetNo, FName, FNo);
    exit;
  end

  else if LeftStr(FName, 5) = 'T2209' then
  begin
    T2209(RetNo, FName, FNo);
    exit;
  end

  else if LeftStr(FName, 5) = 'T2042' then
  begin
    T2042(RetNo, FName, FNo);
    exit;
  end

  else if LeftStr(FName, 4) = 'MIA#' then
  begin
    MIA(RetNo, FName, FNo);
    exit;
  end

  else if LeftStr(FName, 5) = 'T1163' then
  begin
    T1163(RetNo, FName, FNo);
    exit;
  end

  else if LeftStr(FName, 6) = 'T1175#' then
  begin
    T1175(RetNo, FName, FNo);
    exit;
  end // 20110109

  else if LeftStr(FName, 7) = 'T1175H#' then
  begin
    T1175H(RetNo, FName, FNo);
    exit;
  end

  else if LeftStr(FName, 5) = 'T1275' then
  begin
    T1275(RetNo, FName, FNo);
    exit;
  end

  else if LeftStr(FName, 6) = 'T1273#' then
  begin
    T1273(RetNo, FName, FNo);
    exit;
  end // 20110122 //20110109
  else if LeftStr(FName, 7) = 'T1273A1' then
  begin
    T1273A1(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 7) = 'T1273A2' then
  begin
    T1273A2(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 8) = 'T1273OTH' then
  begin
    T1273OTH(RetNo, FName, FNo);
    exit;
  end

  else if LeftStr(FName, 5) = 'T2121' then
  begin
    T2121(RetNo, FName, FNo);
    exit;
  end

  else if LeftStr(FName, 4) = 'T776' then
  begin
    T776(RetNo, FName, FNo);
    exit;
  end

  else if LeftStr(FName, 7) = 'ACBOTHR' then
  begin
    ACBOTHR(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 6) = 'PORTFL' then
  begin
    PORTFL(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 7) = 'ACBFRM#' then
  begin
    ACBFRM(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 7) = 'ACBSUM#' then
  begin
    ACBSUM(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 6) = 'FLTHRU' then
  begin
    FLTHRU(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 5) = 'NPAD#' then
  begin
    NPAD(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 5) = 'NPADC' then
  begin
    NPADC(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 6) = 'PRIVAT' then
  begin
    PRIVAT(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 7) = 'MEDSUPL' then
  begin
    MEDSUPL(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 7) = 'DONSUPL' then
  begin
    DONSUPL(RetNo, FName, FNo);
    exit;
  end
  { end multiples }
  else if FName = 'BUSSUM' then
  begin
    BUSSUM(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'RENTSUM' then
  begin
    RENTSUM(RetNo, FName, FNo);
    exit;
  end
  { ----- }

  else if FName = 'T2204' then
  begin
    T2204(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'S10' then
  begin
    S10(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T2205' then
  begin
    T2205(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T2222' then
  begin
    T2222(RetNo, FName, FNo);
    exit;
  end

  else if FName = 'T400A' then
  begin
    T400A(RetNo, FName, FNo);
    exit;
  end
  // else if LeftStr(FName,4) = 'T626'  then begin T626(RetNo,FName,FNo);exit; end   //20161119

  else if FName = 'T657' then
  begin
    T657(RetNo, FName, FNo);
    exit;
  end

  else if FName = 'T664' then
  begin
    T664(RetNo, FName, FNo);
    exit;
  end

  else if FName = 'T691' then
  begin
    T691(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T746' then
  begin
    T746(RetNo, FName, FNo);
    exit;
  end

  else if LeftStr(FName, 8) = 'T777MOB#' then // 20221211
  begin
    T777MOB(RetNo, FName, FNo);
    exit;
  end

  else if LeftStr(FName, 5) = 'T777#' then // 20200511
  begin
    T777(RetNo, FName, FNo);
    exit;
  end

  {
  // 202100117
  else if LeftStr(FName, 6) = 'T777S#' then // 20200511
  begin
    T777S(RetNo, FName, FNo);
    exit;
  end
  }
  else if FName = 'T778' then
  begin
    T778(RetNo, FName, FNo);
    exit;
  end

  else if FName = 'T79' then
  begin
    T79(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T81' then
  begin
    T81(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T929' then
  begin
    T929(RetNo, FName, FNo);
    exit;
  end

  else If FName = 'T936' then
  begin
    T936(RetNo, FName, FNo);
    exit;
  end

  else if LeftStr(FName, 4) = 'TL2#' then
  begin
    TL2(RetNo, FName, FNo);
    exit;
  end
  { MISCELLANEOUS }
  else if LeftStr(FName, 8) = 'CCAMULT#' then
  begin
    CCAMULT(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'STLOAN' then
  begin
    STLOAN(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'CCALIST' then
  begin
    CCALIST(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'TOOLEXP' then
  begin
    TOOLEXP(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 6) = 'T5008#' then
  begin
    T5008(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 9) = 'T5008DTL#' then
  begin
    T5008Dtl(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'UNIOND' then
  begin
    UNIOND(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'MEDICAL' then
  begin
    MEDICAL(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'MEDPRV' then
  begin
    MEDPRV(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'DEPEND' then
  begin
    DEPEND(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'OTHINC' then
  begin
    OTHINC(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'OTHDED' then
  begin
    OTHDED(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'INVOICE' then
  begin
    INVOICE(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 7) = 'INVGEN#' then
  begin
    INVGEN(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'INVFORMS' then
  begin
    INVFORMS(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'ADDINFO' then
  begin
    ADDINFO(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'TRANSF' then
  begin
    TRANSF(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'PTRANSF' then
  begin
    PTRANSF(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'DISAB18' then
  begin
    DISAB18(RetNo, FName, FNo, '');
    exit;
  end
  else if FName = 'ABIL' then
  begin
    ABIL(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'AJCTC' then
  begin
    AJCTC(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'DON' then
  begin
    DON(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'DEATH' then
  begin
    Death(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'TX19' then
  begin
    TX19(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'DIRECT' then
  begin
    DIRECT(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'PNSDED' then
  begin
    PNSDED(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'RRSP' then
  begin
    RRSP(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'RRSPNXT' then
  begin
    RRSPNXT(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'RPP' then
  begin
    RPP(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'BLANKPG' then
  begin
    BLANKPG(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 8) = 'REFILEV#' then
  begin
    REFILEV(RetNo, FName, FNo);
    exit;
  end // 20170404

  else if FName = 'POLIT' then
  begin
    POLIT(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'TAXSUM' then
  begin
    TAXSUM(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'PRVSUM' then
  begin
    PRVSUM(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'FAMSUM' then
  begin
    FAMSUM(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'YRSUM2' then
  begin
    YRSUM2(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'RC71' then
  begin
    RC71(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'RC72' then
  begin
    RC72(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'RC201' then
  begin
    RC201(RetNo, FName, FNo);
    exit;
  end
  else if LeftStr(FName, 5) = 'RC210' then
  begin
    RC210(RetNo, FName, FNo);
    exit;
  end
  // else if FName = 'RC310'    then begin RC310(RetNo,FName,FNo);exit; end  //20170126
  else if LeftStr(FName, 6) = 'RC359#' then
  begin
    RC359(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'RC360' then
  begin
    RC360(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'RC381' then
  begin
    RC381(RetNo, FName, FNo);
    exit;
  end
  // else if FName = 'RC381I' then begin  RC381I(RetNo, FName, FNo);  exit;
  else if FName = 'RC383' then
  begin
    RC383(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'GST370' then
  begin
    GST370(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'MCREDIT' then
  begin
    MCREDIT(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'GSTC' then
  begin
    GSTC(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'CTB' then
  begin
    CTB(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'PROVCTB' then
  begin
    PROVCTB(RetNo, FName, FNo);
    exit;
  end
  // else if FName = 'CATC'     then begin CATC(RetNo,FName,FNo);exit; end  //20171119
  else if FName = 'FORINC' then
  begin
    FORINC(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'BANKRPT' then
  begin
    BankRpt(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'CLAW' then
  begin
    CLAW(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'CFR' then
  begin
    CFR(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'CFRAFILL' then
  begin
    CFRAFILL(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'OLDLOSS' then
  begin
    OLDLOSS(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'RESINC' then
  begin
    RESINC(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T1223' then
  begin
    T1223(RetNo, FName, FNo);
    exit;
  end

  else if FName = 'T1229' then
  begin
    T1229(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'DEPLEXP' then
  begin
    DEPLEXP(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'EFADJ' then
  begin
    EFADJ(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'EFDOC' then
  begin
    EFDOC(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'T5006' then
  begin
    T5006(RetNo, FName, FNo);
    exit;
  end // 20131127
  else if FName = 'EFMEMO' then
  begin
    EFMEMO(RetNo, FName, FNo);
    exit;
  end

  else if LeftStr(FName, 6) = 'T2200#' then
  begin
    T2200(RetNo, FName, FNo);
    exit;
  end

  else if FName = 'S2MJYT' then // 20180331
  begin
    S2MJYT(RetNo, FName, FNo, T2203Prov);
    exit;
  end

  else if LeftStr(FName, 5) = 'T2201' then
  begin
    T2201(RetNo, FName, FNo);
    exit;
  end // 20160411 //20160505 Igor
  {//20220220
  else if LeftStr(FName, 6) = 'T2201H' then
  begin
    T2201H(RetNo, FName, FNo);
    exit;
  end // 20160411 //20160505 Igor
  }
  else if FName = 'FECONV' then
  begin
    FECONV(RetNo, FName, FNo);
    exit;
  end
  else if FName = 'OPTIMIZE' then
  begin
    OPTIMIZE(RetNo, FName, FNo);
    exit;
  end
  // else if FName = 'EFILEACK'  then begin EFILEACK(RetNo,FName,FNo);exit; end
  else if FName = 'TESTFRM' then
  begin
    TESTFRM(RetNo, FName, FNo);
    exit;
  end
  else
    exit;

end;
//20251008 Igor >>>
procedure RC267(RetNo: Integer; FName: string; FNo: Integer);
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    Tv[3]:= MinR(Tv[1], Tv[2]);
    Tv[5]:= Tv[4] * 0.18;
    Tv[8]:= Tv[5];
    Tv[6]:= Constant[RY].MoneyPurchaseLimit;
    Tv[7]:= MinR(Tv[8], Tv[6]);
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure RC268(RetNo: Integer; FName: string; FNo: Integer);
var
  i: Integer;
  x: Real;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    Tv[3]:= MinR(Tv[1], Tv[2]);
    Tv[4]:= vl(FetchElm(RetNo, 'RRSP', 11));
    Tv[5]:= vl(FetchElm(RetNo, 'S7', 6));
    Tv[6]:= MaxR(0, Tv[4] - Tv[5]);  //20220307
    Tv[7]:= MinR(Tv[3], Tv[6]);

    Tv[8]:= Constant[RY].MoneyPurchaseLimit;
    // Money purchase limit   //20101201
    Tv[11]:= Tv[10] * 10 / 100;
    Tv[13]:= Tv[10];
    Tv[14]:= Tv[13] * 10 / 100;
    Tv[20]:= MinR(Tv[12], Tv[14]);  //20210307
    Tv[15]:= Tv[20];   //20210307
    x:= 0;

    if Strings[17].Equals('') then Tv[9]:= 0 else x:= Tv[9]; // option used
    if Strings[18].Equals('') then Tv[11]:= 0 else x:= Tv[11];

    if Strings[19].Equals('') then
    begin
      Tv[12]:= 0;
      Tv[13]:= 0;
      Tv[14]:= 0;
      Tv[15]:= 0;
    end else
      x:= Tv[15];

    Tv[16]:= MinR(Tv[8], x);
  end;

  SaveTv(RetNo, FName, FNo);
end;


procedure RC269(RetNo: Integer; FName: string; FNo: Integer);
var
  i: integer;

  CppMonths, CppRetirementMonths: integer;
  CppProrate, CPPRetirementProrate: real;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin

    //proration ---------->>>>
    CppMonths:= GetCPPQPPMonthsForRC269(RetNo); // jz/20250227
    CppRetirementMonths:= getCPPRetirementMonths(RetNo, CppMonths); //jz//20250204 - change name of function from getCPPRetirementMonthsForS8

    strings[29] := inttostr(CppMonths);
    //If Vl(strings[29]) > 12 then strings[29]:= '12';

    if      CppRetirementMonths > 12 then CppRetirementMonths:= 12
    else if CppRetirementMonths = 0  then CppRetirementMonths:= 12; //jz//20260202 - if then 0 no proration

    CppProrate           := Vl(strings[29])     / 12;
    CPPRetirementProrate := CppRetirementMonths / 12;

    //<<<<---------- proration

    //Page 3                                                    //SHOULD HAAVE a CPPProrate??
    Tv[22]:= Constant[RY].MaxAdditionalCppPensionableEarnings   * CPPProrate;
    Tv[23]:= Constant[RY].MaxCppPensionableEarnings             * CPPProrate;
    Tv[25]:= Constant[RY].BasicCppExemption                     * CPPRetirementProrate;

//jz//20260118 - does not work
//    Tv[1] := IfThen(TotMultiple(RetNo, 'RC381', 3) > 0, TotMultiple(RetNo, 'RC381', 3), TotMultiple(RetNo, 'S8', 3)); //20251219 Igor //MinR(81200, Ret[RetNo].T4CPPEarnings);
//    Tv[56]:= IfThen(TotMultiple(RetNo, 'RC381', 4) > 0, TotMultiple(RetNo, 'RC381', 4), 0{TotMultiple(RetNo, 'S8Q', ???)}); //20251219 Igor
//    Tv[57]:= IfThen(TotMultiple(RetNo, 'S8', 139) > 0, TotMultiple(RetNo, 'S8', 139), // line 3 of Part 4 of your Schedule 8 (5000-S8)
//             IfThen(TotMultiple(RetNo, 'S8', 38) > 0, TotMultiple(RetNo, 'S8', 38), // or line 4 of Part 5 of your Schedule 8 (5000-S8)
//             IfThen(TotMultiple(RetNo, 'RC381', 352) > 0, TotMultiple(RetNo, 'RC381', 352), // or line 4 of Part 4 of your Form RC381
//             IfThen(TotMultiple(RetNo, 'RC381', 156) > 0, TotMultiple(RetNo, 'RC381', 156), 0)))); // or line 3 of Part 5 of your Form RC381 //20251219 Igor


    //jz//20260118 - were not multi forms so why using TotMultiple? doesnt seem to work, change to fetchElm
                // - use Rc381InEffect instead of if a value present as the condition
                // - rearrange for readablily
    Tv[1] := IfThen(Rc381InEffect(RetNo), vl(FetchElm(RetNo, 'RC381', 3)), vl(FetchElm(RetNo, 'S8', 3)));
    Tv[56]:= IfThen(Rc381InEffect(RetNo), vl(FetchElm(RetNo, 'RC381', 4)), 0); //vl(FetchElm(RetNo, 'S8Q', ???) //jz//20260203 not multi form do not use TotMultiple

    if Rc381InEffect(RetNo) then
      Tv[57]:=  IfThen(vl(FetchElm(RetNo, 'RC381', 352)) > 0, vl(FetchElm(RetNo, 'RC381', 352)),           // or line 4 of Part 4 of your Form RC381
                IfThen(vl(FetchElm(RetNo, 'RC381', 156)) > 0, vl(FetchElm(RetNo, 'RC381', 156)), 0))       // or line 3 of Part 5 of your Form RC381 //20251219 Igor
    else
      Tv[57]:=  IfThen(vl(FetchElm(RetNo, 'S8'   , 139)) > 0, vl(FetchElm(RetNo, 'S8'   , 139)),           // line 3 of Part 4 of your Schedule 8 (5000-S8)
                IfThen(vl(FetchElm(RetNo, 'S8'   ,  38)) > 0, vl(FetchElm(RetNo, 'S8'   ,  38)), 0));      // or line 4 of Part 5 of your Schedule 8 (5000-S8)

    Tv[3]:= Tv[1] + Tv[56] + Tv[57] + Tv[2]; //20251219 Igor
    Tv[8]:= MinR(Tv[3], Tv[22]);
    Tv[4]:= Tv[8];
    Tv[5]:= Tv[23];
    Tv[6]:= MinR(9900, MaxR(0, Tv[4] - Tv[5])); //jz//20260204 - min not max against 9900 amount //20251219 Igor
    Tv[7]:= Tv[6];
    Tv[26]:= Tv[4] - Tv[7];
    Tv[9]:= Tv[25];
    Tv[10]:= MinR(67800, MaxR(0, Tv[26] - Tv[9])); //20251014 Igor

    //Page 4
    Tv[34]:= Tv[10];
    Tv[35]:= MinR(3356.10, Tv[34] * 4.95 / 100);
    //20251219 Igor >>>
    Tv[43]:= Ret[RetNo].Lnn[30800];
    Tv[58]:= Ret[RetNo].Lnn[31000];
    Tv[59]:= Tv[43] + Tv[58];
    Tv[60]:= Tv[59];
    Tv[61]:= MaxR(0, Tv[35] - Tv[60]);
    Tv[36]:= Tv[10];
    Tv[37]:= MinR(678.00, Tv[36] * 1 / 100);
    Tv[38]:= Tv[7];
    Tv[39]:= MinR(396.00, Tv[38] * 4 / 100);
    Tv[40]:= Tv[37] + Tv[39];
    Tv[41]:= Tv[40];
    Tv[47]:= MinR(1074.00, Ret[RetNo].Lnn[22215]);
    Tv[62]:= Ret[RetNo].Lnn[22200];
    Tv[42]:= Tv[58];
    Tv[63]:= Tv[62] - Tv[42];
    Tv[44]:= Tv[63];
    Tv[46]:= Tv[44] * 0.5;
    Tv[48]:= Tv[47] + Tv[46];
    Tv[45]:= Tv[48];
    Tv[49]:= MaxR(0, Tv[41] - Tv[45]);

    //Tv[50]:= Tv[2];  //jz//20260118 - should be vtUser
    Tv[51]:= MinR(Tv[61], Tv[50]);
    Tv[52]:= Tv[51];
    Tv[53]:= Tv[50] - Tv[51];
    Tv[54]:= MinR(Tv[49], Tv[53]);
    Tv[55]:= Tv[52] + Tv[54];
    //20251219 Igor <<<

    //Page 5
    //Tv[11]:= vtUser
    Tv[30]:= Tv[50];
    Tv[31]:= Tv[55];
    Tv[32]:= MaxR(0, Tv[30] - Tv[31]);
    Tv[12]:= Tv[32];
    Tv[13]:= Tv[11] + Tv[12];
    Tv[27]:= 9;
    Tv[15]:= Tv[14] * Tv[27] / 100;

    Tv[24]:= Constant[RY].MoneyPurchaseLimit;      //jz//20260118 - add, not sure where this value was coming from previously
    Tv[16]:= Constant[RY].MoneyPurchaseLimit / 2;  //jz//20260118 - match the form for consistany/readability  //16905;

    Tv[17]:= MinR(MinR(Tv[13], Tv[15]), Tv[16]);

    //pens adjustment
    //Tv[18]:= vtUser
    Tv[28]:= 18;
    Tv[19]:= (Tv[18] * Tv[28]) / 100;
    Tv[20]:= Constant[RY].MoneyPurchaseLimit;
    Tv[21]:= MinR(Tv[19], Tv[20]);
  end;

  SaveTv(RetNo, FName, FNo);
end;



Procedure BLANKPG(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := 'Page left blank intentionally';
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure RC151(RetNo: integer; FName: String; FNo: integer); //20230330
Var
  i: integer; s:String;
begin
  LoadTv(RetNo, FName, FNo);

  with ret[RetNo].Frm[FNo] do
  begin
   If strings[57]='' then
   Begin
    for i:=1 to 56 do begin ret[RetNo].Frm[FNo].Strings[i]:='';end;
    SaveTv(RetNo, FName, FNo);
    Exit;
   End;

   Strings[1]:=FetchElmFNo(RetNo,InfoFNo,2);
   Strings[2]:=FetchElmFNo(RetNo,InfoFNo,5);
   Strings[3]:=FetchElmFNo(RetNo,InfoFNo,3);
   Strings[4]:=FetchElmFNo(RetNo,InfoFNo,9);
   Strings[5]:=FetchElmFNo(RetNo,InfoFNo,54)+' '+FetchElmFNo(RetNo,InfoFNo,55);
   Strings[6]:=FetchElmFNo(RetNo,InfoFNo,71)+' '+FetchElmFNo(RetNo,InfoFNo,72);
   if Strings[56]+Strings[8]='' then Strings[56]:='X';  //lang
   s:=FetchElmFNo(RetNo,InfoFNo,22); //apartm
   if s>'' then
    Strings[7]:=FetchElmFNo(RetNo,InfoFNo,22) +'-'+FetchElmFNo(RetNo,InfoFNo,6)
      +' '+FetchElmFNo(RetNo,InfoFNo,68) +' '+FetchElmFNo(RetNo,InfoFNo,163)
   else
    Strings[7]:=FetchElmFNo(RetNo,InfoFNo,6)
         +' '+FetchElmFNo(RetNo,InfoFNo,68) +' '+FetchElmFNo(RetNo,InfoFNo,163);
   Strings[45]:=FetchElmFNo(RetNo,InfoFNo,10);    //20250425
   Strings[12]:=FetchElmFNo(RetNo,InfoFNo,14);
   Strings[55]:=FetchElmFNo(RetNo,InfoFNo,15);
   //mr st
   Strings[16]:=FetchElmFNo(RetNo,InfoFNo,11);
   Strings[17]:=FetchElmFNo(RetNo,InfoFNo,12);
   Strings[18]:=FetchElmFNo(RetNo,InfoFNo,13);
   Strings[19]:=FetchElmFNo(RetNo,InfoFNo,16);
   Strings[20]:=FetchElmFNo(RetNo,InfoFNo,17);
   Strings[21]:=FetchElmFNo(RetNo,InfoFNo,18);
   //spouse
   Strings[24]:=FetchElmFNo(RetNo,InfoFNo,20);
   Strings[31]:=FetchElmFNo(RetNo,InfoFNo,45);
   Strings[32]:=FetchElmFNo(RetNo,InfoFNo,4);
   Strings[33]:=FetchElmFNo(RetNo,InfoFNo,59);
   Strings[19]:=FetchElmFNo(RetNo,InfoFNo,16);
   //new comer
   If (FetchElmFNo(RetNo,InfoFNo,26)>'') and (FetchElmFNo(RetNo,InfoFNo,25)>'') then
     Strings[36]:=AppYear+'-'+FetchElmFNo(RetNo,InfoFNo,26)+'-'+FetchElmFNo(RetNo,InfoFNo,25); //20230401
   //if Length(strings[36])=6 then Strings[36]:=LeftStr(strings[36],4); //202300406
   If Strings[53]='' then Strings[53]:=FormatDateTime('yyyy-mm-dd',Now);
   If Strings[54]='' then Strings[54]:=FormatDateTime('yyyy-mm-dd',Now);

  end;
  SaveTv(RetNo, FName, FNo);
end;





Procedure RC383(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  x: Real;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := GetLastName(RetNo);
    Strings[2] := GetFirstName(RetNo);
    Strings[3] := GetSinNo(RetNo);
    Tv[6] := Tv[4] + Tv[5];
    Tv[9] := Tv[7] + Tv[8];
    Tv[12] := Tv[10] + Tv[11];
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T1ADJi(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  LnDescrList: TStringList;
  LineDescripton: String;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    // get descriptions
    LnDescrList := TStringList.Create;
    LnDescrList.LoadFromFile(AppDir + '\' + 'T1Tls.d');
    i := 23;
    repeat
      If (Strings[i] > '') and (Strings[i + 1] = '') then
        Strings[i + 1] := GetLineDescription(MyStrToInt(Strings[i]),
          LnDescrList);
      // Tv[i+3]:=Tv[i+4]-Tv[i+2];
      // Strings[i]:=LeftStr(Strings[i],4);
      // Strings[i]:=RemoveChar(Strings[i],'*');
      Inc(i, 5);
    until i > 108;
    LnDescrList.Free;
    SaveTv(RetNo, FName, FNo);
  End;
end;

Function IsFormElmInT1PropDynList(FName: String; Fld: integer): Boolean;
// if on thec list the elm is NOT vtDollar
Var
  i: integer;
  s: String;
Begin
  Result := False;
  s := RTrim(PaddR(FName, 10) + PaddR(IntToStr(Fld), 6));
  For i := 0 to T1PropDynList.Count - 1 do
  begin
    If s = LeftStr(T1PropDynList[i], 16) then
    begin
      Result := True;
      exit;
    end;
  end;
end;

Procedure TESTFRM(RetNo: integer; FName: String; FNo: integer);
Var
  i, Elm, ArrayNo: integer;
  BoxesPerRow: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    // Array 1 math
    ArrayNo := 1;
    BoxesPerRow := 12;
    // GetDynamicBoxesPerRow(FName,???StrToInt(IntTostr(ArrayNo)+'0001'));
    Tv[1] := 0;
    Elm := ArrayNo * 10000 + StrToInt('3');
    // for field id 10003 on the first row i form
    For i := 0 to MaxDynamicElmsPerForm do
    begin
      // If Tv[Elm+4]>0 then Tv[Elm+4]:=Tv[Elm+3]/Tv[Elm+4];
      Tv[1] := Tv[1] + vl(FetchElmFNo(RetNo, FNo, Elm)); // 20160119 Igor
      Elm := Elm + BoxesPerRow;
    end;
    // Array 2 math
    ArrayNo := 2;
    BoxesPerRow := 2;
    Tv[29] := 0;
    Tv[30] := 0;
    Elm := ArrayNo * 10000 + StrToInt('1');
    // array comes as 1, 2 so elm s/b 10001, 10013 etc //first box '1'
    For i := 0 to MaxDynamicElmsPerForm do
    begin
      Tv[29] := Tv[29] + vl(FetchElmFNo(RetNo, FNo, Elm)); // 20160119 Igor
      Tv[30] := Tv[30] + vl(FetchElmFNo(RetNo, FNo, Elm + 1)); // 20160119 Igor
      Elm := Elm + BoxesPerRow;
    end;
  end;
  // StoreElm(RetNo,FNo,1,FormatFloat('#######.##',Tv[1]));
  SaveTv(RetNo, FName, FNo); // 20110131
end;

procedure MXCREDIT(RetNo: integer; FName: String; FNo: integer);
Const {OnBasicCr=260;}
  BCHSTCr = 230; // not used?
  BCClimateCr = 174; //20220226 135; // 115.50;  //20190223
  // 20170226
  SkBasicCr = 349; //20220226 //346; // 246;
  SkKidCredit = 137; //20220226 136; // 96;
  SkMaxCredit = 972; //20220226 964; // 684; // 20170226
  NSBasicCr = 255; // 223 //20130129
Var
  i, k, GstcFNo: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    GstcFNo := GetFormNo('GSTC');
    For i := 1 to 70 do
    begin
      Tv[i] := 0;
      Strings[i] := '';
    end; // clear it
    If ret[RetNo].Province = 'BC' then
    Begin
      // kill the Sales tax credit
      For i := 16 to 25 do
        Tv[i] := 0;
      Tv[1] := 0;
      Tv[27] := 0;
      Tv[26] := 0;

      // BC climate
      If (ret[RetNo].Age >= 19) or (vl(FetchElmFNo(RetNo, GstcFNo, 8)) > 0)
      // spouse claim
        or (UpperCase(FetchElmFNo(RetNo, GstcFNo, 3)) = 'Y') then // elig dep
        Tv[28] := BCClimateCr
      else
        Tv[28] := 0;
      If vl(FetchElmFNo(RetNo, GstcFNo, 8)) > 0 then
        Tv[29] := BCClimateCr
      else
        Tv[29] := 0; // spouse
      If UpperCase(FetchElmFNo(RetNo, GstcFNo, 3)) = 'Y' then
        Tv[30] := BCClimateCr
      else
        Tv[30] := 0; // elig dep

      k := MyStrToInt(FetchElmFNo(RetNo, GstcFNo, 2)); // kids
      If UpperCase(FetchElmFNo(RetNo, GstcFNo, 3)) = 'Y' then
        k := k - 1;;
      If k < 0 then
        k := 0; // less eligible
      Strings[38] := IntToStr(k);
      Tv[39] := 51; //20220226 40; // 34.50;  //20190223
      Tv[31] := vl(Strings[38]) * Tv[39];
      Tv[32] := Tv[28] + Tv[29] + Tv[30] + Tv[31];
      Tv[33] := vl(FetchElmFNo(RetNo, GstcFNo, 6)); // fam income
      // 20170226
      If (ret[RetNo].MarStatus < 3) Or (FetchElmFNo(RetNo, GstcFNo, 3) = 'Y')
      then
        Tv[34] := 42165; //20220226 40689; // 38880; // married or elig dep  //20190223
      If (ret[RetNo].MarStatus > 2) and (FetchElmFNo(RetNo, GstcFNo, 3) <> 'Y')
      then
        Tv[34] := 36142; //20220226 34876; // 33326;
      Tv[35] := MaxR(0, Tv[33] - Tv[34]);
      Tv[36] := Tv[35] * 4 / 100;
      Tv[56] := Tv[36];
      Tv[37] := MaxR(0, Tv[32] - Tv[56]);
      Tv[2] := Tv[37] / 4; // 20140323
    end
    Else
    Begin
      For i := 16 to 37 do
        Tv[i] := 0;
      Tv[1] := 0;
      Tv[2] := 0;
    end;

    // SK
    If ret[RetNo].Province = 'SK' then
    Begin
      Tv[40] := SkBasicCr;
      If vl(FetchElmFNo(RetNo, GstcFNo, 8)) > 0 then
        Tv[41] := SkBasicCr
      else
        Tv[41] := 0; // spouse
      If UpperCase(FetchElmFNo(RetNo, GstcFNo, 3)) = 'Y' then
        Tv[42] := SkBasicCr
      else
        Tv[42] := 0; // elig dep
      k := MyStrToInt(FetchElmFNo(RetNo, GstcFNo, 2)); // kids
      If UpperCase(FetchElmFNo(RetNo, GstcFNo, 3)) = 'Y' then
        k := k - 1;;
      If k < 0 then
        k := 0; // less eligible
      if k > 2 then
        k := 2;
      Strings[50] := IntToStr(k);
      Tv[51] := SkKidCredit; // 20160130 93; //20150209; //87;  //20130129
      Tv[43] := vl(Strings[50]) * Tv[51];
      Tv[44] := Tv[40] + Tv[41] + Tv[42] + Tv[44];

      Tv[45] := vl(FetchElmFNo(RetNo, GstcFNo, 6)); // fam income
      Tv[46] := 32301;
      // 20170226 //31878; //20160130 31342; //20150209 30465; //29204;  //20130129
      Tv[47] := MaxR(0, Tv[45] - Tv[46]);
      Tv[48] := Tv[47] * 2 / 100;
      Tv[57] := Tv[48];
      Tv[49] := MaxR(0, Tv[44] - Tv[57]);
      If Tv[49] > SkMaxCredit then
        Tv[49] := SkMaxCredit; // 20160130
      // If Tv[49]>skBasicCr *2 then Tv[49]:=skBasicCr *2; //620;  //20130129
      Tv[3] := Tv[49] / 4; // 20140323
    end
    Else
    Begin
      For i := 40 to 49 do
        Tv[i] := 0;
      Tv[3] := 0;
    end;
    // End;

    // NS  //20130407
    If ret[RetNo].Province = 'NS' then
    Begin
      Tv[58] := NSBasicCr;
      k := MyStrToInt(FetchElmFNo(RetNo, GstcFNo, 2)); // kids
      If UpperCase(FetchElmFNo(RetNo, GstcFNo, 3)) = 'Y' then
        k := k - 1;
      If k < 0 then
        k := 0; // less eligible
      // if K>2 then k:=2;
      Strings[59] := IntToStr(k);
      Tv[60] := 60;
      Tv[61] := vl(Strings[59]) * Tv[60];
      Tv[62] := Tv[58] + Tv[61];

      Tv[63] := vl(FetchElmFNo(RetNo, GstcFNo, 6)); // fam income
      Tv[64] := 30000;
      Tv[65] := MaxR(0, Tv[63] - Tv[64]);
      Tv[66] := Tv[65] * 5 / 100;
      Tv[67] := Tv[66];
      Tv[68] := MaxR(0, Tv[62] - Tv[67]);
    end
    Else
    Begin
      For i := 58 to 68 do
        Tv[i] := 0;
    end;

  End;

  If FetchElmFNo(RetNo, GstcFNo, 1) <> 'Y' then // 20110320
  begin
    For i := 1 to 69 do
      ret[RetNo].Frm[FNo].Tv[i] := 0; // kill ostc, osttb
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure PTIMEWS(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    If UpperCase(Strings[9]) <> 'Y' then
    begin
      For i := 1 to 8 do
        Tv[8] := 0;
      exit;
    end;
    Tv[3] := MinR(Tv[1], Tv[2]);
    Tv[4] := MaxR(0, Tv[1] - Tv[2]);
    Tv[5] := 500;
    Tv[6] := MinR(Tv[4], Tv[5]);
    Tv[7] := Tv[3] + Tv[6];
    Tv[8] := MaxR(0, Tv[1] - Tv[7]);
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure RC360(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  if CalcThisProvince(RetNo, 'SK') = False then
  begin
    For i := 1 to 23 do
    begin
      ret[RetNo].Frm[FNo].Strings[i] := '';
      ret[RetNo].Frm[FNo].Tv[i] := 0;
    end;
    SaveTv(RetNo, FName, FNo);
    exit;
  end;

  // 20210106
  with ret[RetNo].Frm[FNo] do
  begin
    i := 3;
    Tv[14] := 0;
    Repeat
      Tv[i + 2] := MinR(Tv[i], Tv[i + 1]);
      Tv[14] := Tv[14] + Tv[i + 2];
      Inc(i, 4);
    until i > 11;
    Tv[15] := 10;
    Tv[17] := Tv[14] * Tv[15] / 100;
    // Tv[17] := Tv[16];
    Tv[18] := Tv[17] + Tv[1]; // 20210106
    Tv[19] := vl(FetchElm(RetNo, 'SK428', 86));
    Tv[20] := MinR(Tv[18], Tv[19]);

    // Part2
    For i := 21 to 23 do
      Tv[i] := 0;
    If Tv[20] < Tv[18] then
    Begin
      Tv[21] := Tv[18];
      Tv[22] := Tv[20];
      Tv[23] := Tv[21] - Tv[22]; // MaxR(0,Tv[21]-Tv[22]);
    end;
  end;
  SaveTv(RetNo, FName, FNo);
end;
//20251008 Igor >>> //checked correct cz
function GetRC359Rate(RetNo: Integer): Real;
var
  ShortPrv: string;
begin
  ShortPrv:= Ret[RetNo].Province;

  if ShortPrv.Equals('AB') then Result:= 48 else
  if ShortPrv.Equals('BC') then Result:= 53.5 else // 49.8 // 47.7  //20201123
  if ShortPrv.Equals('MB') then Result:= 50.4 else
  if ShortPrv.Equals('NB') then Result:= 52.5 else //53.3  //20231127
  if ShortPrv.Equals('NL') then Result:= 54.8 else //20221214 // 20171203
  if ShortPrv.Equals('NS') then Result:= 54 else
  if ShortPrv.Equals('NT') then Result:= 47.05 else
  if ShortPrv.Equals('NU') then Result:= 44.5 else
  if ShortPrv.Equals('ON') then Result:= 53.53 else
  if ShortPrv.Equals('PE') then Result:= 52.00 else //20251014 Igor
  if ShortPrv.Equals('QC') then Result:= 33 else
  if ShortPrv.Equals('SK') then Result:= 47.5 else // 47.75 // 20181124
  if ShortPrv.Equals('YT') then Result:= 48
  else Result:= 49; //20251014 Igor // other
end;

procedure RC359(RetNo: Integer; FName: string; FNo: Integer);
var
  i: Integer;
begin
  LoadTv(RetNo, FName, FNo);

  //20260103CZ
  with Ret[RetNo].Frm[FNo] do
  begin
    Strings[21]:= 'N'; //20260103CZ
    //if UpperCase(Strings[21])='' then Strings[21]:= 'Y'; //20260103CZ
    Strings[1]:= GetLastName(RetNo);
    Strings[2]:= GetFirstName(RetNo);
    Strings[3]:= GetSinNo(RetNo);
    //20260103
    if Uppercase(Strings[21])='Y' then
    begin
     Tv[4]:=TotMultiple(RetNo,'T4PS',15);
     Tv[6]:=TotMultiple(RetNo,'T4',51)+TotMultiple(RetNo,'T4',75);
     Tv[7]:= MaxR(0, Tv[5] - Tv[6]);
     Tv[8]:= 20;
     Tv[9]:= Tv[7] * Tv[8] / 100;
     Tv[10]:= Tv[9];
     Tv[11]:= MaxR(0, Tv[4] - Tv[10]);
    end;
    Tv[13]:= GetRC359Rate(RetNo);
    Tv[14]:= Tv[11] * Tv[13] / 100; //20250205

    { removed the sin based overrides      //20260103
      //jz//20250405 - for testing
    if (GetSinNo(RetNo) = '870000650') and (fno = 338) then
    begin
      Tv[11]:= 2720;
      Tv[14]:= 1455.20;
    end;
    //jz//NonResCERT//202404
    if (GetSinNo(RetNo) = '870030848') and (fno = 338) then
    begin
      Tv[11]:= 2200;
      Tv[14]:= 1155.00;
    end;
   }
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20251008 Igor <<<

Function GetT4Box38(RetNo: integer; EmployerName: String): Real;
Var
  i: integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T4' then
    begin
      If UpperCase(FetchElmFNo(RetNo, FRec.FormNo, 1)) = EmployerName then
        Result := Result + vl(FetchElmFNo(RetNo, FRec.FormNo, 51));
    end;
  end;
end;

Procedure CreateRc359Forms(RetNo: integer);
Const
  ArraySize = 5;
Var
  i, j, k: integer;
  Found: Boolean;
  FNo: integer; // k1,k2:Integer;
  // embedded function
  Function GetEmptyEmployerIndex(Rc59Rec: Array of TRc359Rec;
    Employer: String): integer;
  Var
    j: integer;
    Found: Boolean;
  Begin
    Employer := UpperCase(Employer);
    Result := -1;
    Found := False;
    For j := low(ret[RetNo].Rc359Rec) to High(ret[RetNo].Rc359Rec) do
    begin
      If Employer = AllTrim(ret[RetNo].Rc359Rec[j].EmployerName) then
      begin
        Found := True; { break; } end;
    end; // j
    // find empty j
    If Found = True then
      Result := -1
    Else
    Begin
      For j := low(ret[RetNo].Rc359Rec) to High(ret[RetNo].Rc359Rec) do
      begin
        If AllTrim(ret[RetNo].Rc359Rec[j].EmployerName) = '' then
        Begin
          Result := j;
          exit;
        end; // empty emplname
      end; // j
    end; // j
  end; // function

begin // procedure
  If UpperCase(FetchElm(RetNo, 'RC359#1', 21)) <> 'Y' then
    exit;
  SetLength(ret[RetNo].Rc359Rec, ArraySize); // 20121120
  For j := low(ret[RetNo].Rc359Rec) to High(ret[RetNo].Rc359Rec) do
  begin
    ret[RetNo].Rc359Rec[j].EmployerName := '';
    ret[RetNo].Rc359Rec[j].Contr := 0;
    ret[RetNo].Rc359Rec[j].EmplInc := 0;
    ret[RetNo].Rc359Rec[j].EmplDed := 0;
  end;
  // Summarize Contributions from T4Ps
  // Get unique empoyers with Specified employee
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If UpperCase(FRec.FormName) = 'T4PS' then
    begin
      If (FetchElmFNo(RetNo, FRec.FormNo, 10) > '') and
        (vl(FetchElmFNo(RetNo, FRec.FormNo, 15)) > 0) then
      // specified employee and contr
      Begin
        j := GetEmptyEmployerIndex(ret[RetNo].Rc359Rec,
          FetchElmFNo(RetNo, FRec.FormNo, 14));
        If j >= 0 then
        Begin
          ret[RetNo].Rc359Rec[j].EmployerName :=
            UpperCase(FetchElmFNo(RetNo, FRec.FormNo, 14));
          ret[RetNo].Rc359Rec[j].Contr := 0;
          ret[RetNo].Rc359Rec[j].EmplInc := 0;
          ret[RetNo].Rc359Rec[j].EmplDed := 0;
        End;
      end; // specified empl
    end; // t4ps
  end; // i

  // now find T4Ps records of the same employer number
  For j := low(ret[RetNo].Rc359Rec) to High(ret[RetNo].Rc359Rec) do
  begin
    For i := 0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      If UpperCase(FRec.FormName) = 'T4PS' then
      begin
        If (FetchElmFNo(RetNo, FRec.FormNo, 10) > '') and
          (ret[RetNo].Rc359Rec[j].EmployerName = UpperCase(FetchElmFNo(RetNo,
          FRec.FormNo, 14))) then // specified employee of same employer
        Begin
          ret[RetNo].Rc359Rec[j].Contr := ret[RetNo].Rc359Rec[j].Contr +
            vl(FetchElmFNo(RetNo, FRec.FormNo, 15)); // contr
          ret[RetNo].Rc359Rec[j].EmplDed := ret[RetNo].Rc359Rec[j].EmplDed +
            vl(FetchElmFNo(RetNo, FRec.FormNo, 5)); // box 35 of T4PS
        end; // if =
      end; // t4ps
    end; // i
  end; // j

  // now find T4 records of the same employer number
  For j := low(ret[RetNo].Rc359Rec) to High(ret[RetNo].Rc359Rec) do
  begin
    for i := 0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      If UpperCase(FRec.FormName) = 'T4' then
      begin
        If ret[RetNo].Rc359Rec[j].EmployerName = UpperCase
          (FetchElmFNo(RetNo, FRec.FormNo, 1)) then // same employer
        Begin
          ret[RetNo].Rc359Rec[j].EmplInc := ret[RetNo].Rc359Rec[j].EmplInc +
            vl(FetchElmFNo(RetNo, FRec.FormNo, 2)); // emplinc box 14
          ret[RetNo].Rc359Rec[j].EmplDed := ret[RetNo].Rc359Rec[j].EmplDed +
            GetT4Box38(RetNo, ret[RetNo].Rc359Rec[j].EmployerName);
        end; // sameemployer
      end; // t4
    end; // i
  end; // j

  // now find T4A records of the same employer number
  For j := low(ret[RetNo].Rc359Rec) to High(ret[RetNo].Rc359Rec) do
  begin
    for i := 0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      If UpperCase(FRec.FormName) = 'T4A' then
      begin
        If ret[RetNo].Rc359Rec[j].EmployerName = UpperCase
          (FetchElmFNo(RetNo, FRec.FormNo, 81)) then // same employer
        Begin
          ret[RetNo].Rc359Rec[j].EmplInc := ret[RetNo].Rc359Rec[j].EmplInc +
            vl(FetchElmFNo(RetNo, FRec.FormNo, 32)); // wage loss
        end; // sameemployer
      end; // t4a
    end; // i
  end; // j

  // init existing RC359 forms
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If UpperCase(FRec.FormName) = 'RC359' then
    begin
      For j := 1 to 14 do
        StoreElm(RetNo, FRec.FormNo, j, '');
      If FetchElmFNo(RetNo, FRec.FormNo, 21) = '' then
        StoreElm(RetNo, FRec.FormNo, 21, 'Y');
    end;
  end;

  // create new RC59
  For j := low(ret[RetNo].Rc359Rec) to High(ret[RetNo].Rc359Rec) do
  begin
    FNo := GetFormNo('RC359#' + AllTrim(IntToStr(j + 1)));
    If FNo > 0 then
      // ok
    Else
    Begin
      AddPageInstance(RetNo, 'RC359', '#' + IntToStr(j + 1));
      FNo := GetFormNo('RC359#' + IntToStr(j + 1));
      If FNo = 0 then
        showMessage('Instance was not added');
    end;

    StoreElm(RetNo, FNo, 15, ret[RetNo].Rc359Rec[j].EmployerName);
    StoreElm(RetNo, FNo, 4, FormatFloat('########.##',
      ret[RetNo].Rc359Rec[j].Contr));
    StoreElm(RetNo, FNo, 5, FormatFloat('########.##',
      ret[RetNo].Rc359Rec[j].EmplInc));
    StoreElm(RetNo, FNo, 6, FormatFloat('########.##',
      ret[RetNo].Rc359Rec[j].EmplDed));

    Calc(RetNo, 'RC359#' + IntToStr(j + 1)); // 20121123
  end; // j
end; // procedure

Function getIndexToADisabledDependant(RetNo: integer; k: integer): integer;
// k is the sequence No #1, #2, #3 etc  (#1 goes to S5, #2 etc go to S5SUPPL
Var
  DependFNo, L, Cnt, BirthYr18, i: integer; // 20160119 Igor
Begin
  Result := 0; // it s/b the index to the First Name
  Cnt := 0;
  // k is #1, #2, etc
  DependFNo := GetFormNo('DEPEND');
  With ret[RetNo] do
  begin
    BirthYr18 := StrToInt(AppYear) - 18;
    L := 141; { index to caregiver indicator }
    i := 5;
    Repeat { for dep over 18 }
      if (FetchElmFNo(RetNo, DependFNo, i) > '') and { first name entered }
        (vl(LeftStr(FetchElmFNo(RetNo, DependFNo, i + 5), 4)) <= BirthYr18) and
        (FetchElmFNo(RetNo, DependFNo, i + 7) = 'Y') and
      // (FetchElmFNo(RetNo,DependFNo,i+7) > '') and
        (FetchElmFNo(RetNo, DependFNo, L) <> 'Y')
      { no caregiver March 16, 2006 }
      then { Infirm }
      begin
        Inc(Cnt);
        If Cnt = k then
        begin
          Result := i;
          exit;
        end; // result:=i+(k-1)*15;Exit;end;
      end;
      i := i + 15;
      L := L + 1;
    until i > 125;
  end; // with
end;

Function getIndexToACareGiverDependant(RetNo: integer; k: integer): integer;
// k is the sequence No #1, #2, #3 etc  (#1 goes to S5, #2 etc go to S5SUPPL
Var
  DependFNo, Cnt, L, L1, AgeNdx, i: integer; // 20160119 Igor
Begin
  Result := 0; // it sshould return the index to the First Name
  Cnt := 0;
  // k is #1, #2, etc as the first one is in S5 already
  DependFNo := GetFormNo('DEPEND');
  With ret[RetNo] do
  begin
    L := 191; // index to depend caregiver amount
    L1 := 141; // 20180225 infirm for caregiver  infirm index
    i := 5;
    AgeNdx := 263;
    Repeat
      if (FetchElmFNo(RetNo, DependFNo, i) > '') { first name entered }
        and (UpperCase(FetchElmFNo(RetNo, DependFNo, L)) = 'Y')
      // caregiver claim
      // and (VL(FetchElmFNo(RetNo,DependFNo,AgeNdx))>17)    //20180305  Tried but no good?
      // Seq problem Cargvr 18 last in dependants see Maria Roche
      then // caregiver
      begin
        Inc(Cnt);
        If Cnt = k then
        begin
          Result := i;
          exit;
        end;
      end;
      Inc(i, 15);
      Inc(L, 1);
      Inc(L1, 1);
      Inc(AgeNdx, 1); // 20180305
    until i > 125;
  end; // with
end;

//jz//20250313
Procedure CPT20(RetNo: integer; FName: String; FNo: integer);
Var
  i, k, K1: integer;
begin

  LoadTv(RetNo, FName, FNo);
  If UpperCase(ret[RetNo].Frm[FNo].Strings[80]) <> 'Y' then // 20121215
  begin
    for i := 1 to 161 do
    begin
      ret[RetNo].Frm[FNo].Tv[i] := 0;
      ret[RetNo].Frm[FNo].Strings[i] := '';
    end;
    SaveTv(RetNo, FName, FNo);
    exit;
  end;


  with ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := GetLastName(RetNo);
    Strings[2] := GetFirstName(RetNo);
    Strings[3] := GetSinNo(RetNo);
    Strings[4] := FetchElm(RetNo, 'INFO', 6) + ' ' + FetchElm(RetNo, 'INFO', 22);
    Strings[4] := Strings[4] + ' ' + FetchElm(RetNo, 'INFO', 68) + ' ' + FetchElm(RetNo, 'INFO', 163);   // street
    Strings[5] := FetchElm(RetNo, 'INFO', 10); // city
    Strings[6] := FetchElm(RetNo, 'INFO', 14); // prov
    Strings[7] := FetchElm(RetNo, 'INFO', 15); // Postal
  end;


  //CPT20 PART A - populate chart
  with ret[RetNo].Frm[FNo] do
  begin
    k:=90;
    for i := 0 to (FList.Count - 1) do //causes problem --> this is from previous calc, what problems does it cause?
    begin
      FRec := FList.Items[i];
      If FRec.FormName = 'T4' then
      begin
        Strings[k]  := FetchElmFNo(RetNo, FRec.FormNo, 1);        // employer's name
        //Tv[]        := vl(FetchElmFNo(RetNo, FRec.FormNo, 2));  // box 14 - emplyment income
        Tv[k+3]     := vl(FetchElmFNo(RetNo, FRec.FormNo, 10));   // box 26  - pensionable earnings
        //Tv[k+4]     := vl(FetchElmFNo(RetNo, FRec.FormNo, ??));   // box ?? - other employment earnings //USER INPUT??
        Tv[k+5]     := vl(FetchElmFNo(RetNo, FRec.FormNo, 3));    // box 16  - employee's CPP contributions
        Tv[k+6]     := vl(FetchElmFNo(RetNo, FRec.FormNo, 68));   // box 16a - employee's 2nd CPP contributions
        Tv[k+7]     := vl(FetchElmFNo(RetNo, FRec.FormNo, 4));    // box 17  - employee's QPP contributions
        Tv[k+8]     := vl(FetchElmFNo(RetNo, FRec.FormNo, 69));   // box 17a - employee's 2nd QPP contributions
        inc(k,9);
      end;
    end; // i
  end; //CPT20 PART A - populate chart

  //CPT20 PART A Totals
  with ret[RetNo].Frm[FNo] do
  begin
    //20250312
    For i:=156 to 161 do begin Tv[i]:=0; end; //clear total lines
    //(3) TOTAL
    i:=93;
    Repeat Tv[156]:=Tv[156]+Tv[i]; Inc(i,9); Until i>147;;
    //(4) TOTAL
    i:=94;
    Repeat Tv[157]:=Tv[157]+Tv[i]; Inc(i,9); Until i>148;
    //(5) TOTAL
    i:=95;
    Repeat Tv[158]:=Tv[158]+Tv[i]; Inc(i,9); Until i>149;
    //(6) TOTAL
    i:=96;
    Repeat Tv[159]:=Tv[159]+Tv[i]; Inc(i,9); Until i>150;
    //(7) TOTAL
    i:=97;
    Repeat Tv[160]:=Tv[160]+Tv[i]; Inc(i,9); Until i>151;
    //(8) TOTAL
    i:=98;
    Repeat Tv[161]:=Tv[161]+Tv[i]; Inc(i,9); Until i>152;
  end;   //end CPT20 PART A Totals



  //CPT20 PART B
  //ALL USER ??

  //CPT20 PART C
  with ret[RetNo].Frm[FNo] do
  begin
    Tv[8] := Tv[156]; //1
    Tv[9] := Tv[157]; //2
    Tv[10] := Tv[79]; //3
    Tv[11] := Tv[9] + Tv[10]; //4
    Tv[12] := Tv[11]; //4
    Tv[13] := Tv[8] + Tv[12]; //5
    //20251124
    If Tv[13] > Constant[RY].MaxAdditionalCppPensionableEarnings then Tv[13] :=Constant[RY].MaxAdditionalCppPensionableEarnings;
    //If Tv[13] > 73200 then Tv[13] := 73200;     //20251124
    Tv[14] := MaxR(vl(FetchElm(RetNo, 'RC381', 108)), vl(FetchElm(RetNo, 'S8', 108))); //6
    Tv[15] := MinR(Tv[8], Tv[14]); //7
    Tv[50] := MaxR(0,Tv[13]-Tv[15]); //8

    Tv[16] := Tv[158];          //9
    Tv[17] := Tv[16] / 0.0595;  //9

    Tv[48] := Tv[159];        //10
    Tv[49] := Tv[48] / 0.04;  //10  //2025/0326 - fix wrong tv

    Tv[18] := Tv[160];        //11
    Tv[51] := Tv[18] / 0.064; //11 //2025/0326 - fix wrong tv

    Tv[22] := Tv[161];        //12
    Tv[52] := Tv[22] / 0.04;  //12 //2025/0326 - fix wrong tv

    Tv[53] := Tv[17] + Tv[49] + Tv[51] + Tv[52];  //13
    Tv[54] := Tv[53];                             //13

    Tv[55] := maxr(0,Tv[50] - Tv[54]);  //14

    Tv[56] := minr(Tv[12], Tv[55]);     //15

    //Tv[19] //16 - USER
    If Tv[19] < 0 then Tv[19] := 0;             //16
    If Tv[19] > Tv[56] then Tv[19] := Tv[56];   //16

    //?? Tv[20] := MaxR(0, Tv[18] - Tv[19]); //17 //not sure what the constraint is supposed to be here
    Tv[20] := MaxR(0, Tv[55] - Tv[19]); //17 //jz//20250326 - line was missing
  end;  //end CPT20 PART C



  //CPT20 part D
  with ret[RetNo].Frm[FNo] do
  begin
    If Strings[21] = '' then
      Strings[21] := FormatDateTime('yyyy-mm-dd', Date);
    If Strings[23] = '' then
      Strings[23] := FetchElm(RetNo, 'INFO', 54) + ' ' + FetchElm(RetNo, 'INFO', 55);
  end;    //end CPT20 part D

  SaveTv(RetNo, FName, FNo);
end;


(*
Procedure CPT20(RetNo: integer; FName: String; FNo: integer);
Var
  i, k, K1: integer;
begin
  LoadTv(RetNo, FName, FNo);
  If UpperCase(ret[RetNo].Frm[FNo].Strings[80]) <> 'Y' then // 20121215
  begin
    For i := 1 to 79 do
    Begin
      ret[RetNo].Frm[FNo].Tv[i] := 0;
      ret[RetNo].Frm[FNo].Strings[i] := '';
    end;
    SaveTv(RetNo, FName, FNo);
    exit;
  end;

  with ret[RetNo].Frm[FNo] do
  begin
    //20250312
    For i:=156 to 161 do begin Tv[i]:=0; end; //tptal line

    i:=93;
    Repeat
     Tv[156]:=Tv[156]+Tv[i];
     Inc(i,9);
    Until i>147;;

    i:=94;
    Repeat
     Tv[157]:=Tv[157]+Tv[i];
     Inc(i,9);
    Until i>148;

    i:=95;
    Repeat
     Tv[158]:=Tv[158]+Tv[i];
     Inc(i,9);
    Until i>149;

    i:=96;
    Repeat
     Tv[159]:=Tv[159]+Tv[i];
     Inc(i,9);
    Until i>150;

    i:=97;
    Repeat
     Tv[160]:=Tv[160]+Tv[i];
     Inc(i,9);
    Until i>151;

    i:=98;
    Repeat
     Tv[161]:=Tv[161]+Tv[i];
     Inc(i,9);
    Until i>152;

  end;
  SaveTv(RetNo, FName, FNo);
end;
*)

Procedure T1232(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := AppYear;
    Strings[2] := GetFirstName(RetNo) + ' ' + GetLastName(RetNo);
    Strings[3] := GetSinNo(RetNo);
    Strings[4] := FetchElm(RetNo, 'INFO', 6) + ' ' + FetchElm(RetNo, 'INFO', 22)
      + ',' + FetchElm(RetNo, 'INFO', 10) + ',' + FetchElm(RetNo, 'INFO', 14) +
      ',' + FetchElm(RetNo, 'INFO', 15);
    Tv[6] := Tv[5];
    Tv[7] := Tv[6] * 15 / 100;
    Tv[9] := Tv[8] * 5 / 100;
    Tv[10] := Tv[7] + Tv[9];
    Tv[11] := Tv[10];
    Tv[14] := Tv[12] + Tv[13];
    Tv[15] := Tv[14];
    Tv[16] := Tv[11] + Tv[15];
    If Strings[17] = '' then
      Strings[17] := FormatDateTime('yyyy-mm-dd', Date);
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T1129(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := AppYear;
    Tv[3] := Tv[2];
    Tv[4] := Tv[3] * 15 / 100;
    Tv[7] := Tv[5] + Tv[6];
    Tv[8] := Tv[7];
    Tv[9] := Tv[4] + Tv[8];
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T10142(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := AppYear;
    Tv[2] := TotMultiple(RetNo, 'T10142W', 9);
    Tv[3] := TotMultiple(RetNo, 'T10142W', 18);
    Tv[4] := TotMultiple(RetNo, 'T10142W', 31);
    Tv[5] := Tv[2] + Tv[3] + Tv[4];
    If Strings[6] = '' then
      Strings[6] := FormatDateTime('yyyy-mm-dd', Date); // 20130126
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T10142W(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  MaxCredit: Real;
  FInst: String;
begin
  MaxCredit := 5250;
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    // Tv[4]:=MaxCredit;
    // Tv[6]:=MaxR(0,Tv[4]-Tv[5]);
    Tv[8] := 20;
    Tv[9] := MinR(MaxCredit, Tv[7] * Tv[8] / 100);
    // Tv[10]:=MinR(Tv[6],Tv[9]);
    // part 3
    Tv[12] := 20;
    Tv[13] := MinR(MaxCredit, Tv[11] * Tv[12] / 100);
    Tv[14] := Tv[13];
    Tv[16] := 20;
    Tv[32] := MinR(MaxCredit, Tv[15] * Tv[16] / 100);
    Tv[17] := Tv[32];
    Tv[18] := Tv[14] + Tv[17];
    // Part 4
    If UpperCase(Strings[36]) = 'Y' then // Tv[10]>0 then
    Begin
      // Tv[19]:=7875;
      // Tv[21]:=Tv[10];
      // Tv[33]:=Tv[20]+Tv[21];
      // Tv[22]:=Tv[33];
      // Tv[23]:=MaxR(0,Tv[19]-Tv[22]);   //20130126

      Tv[24] := Tv[9]; // Tv[10];
      Tv[25] := 50;
      Tv[34] := Tv[24] * Tv[25] / 100;
      Tv[26] := Tv[34];
      // Tv[27]:=MinR(Tv[23],Tv[26]);

      Tv[28] := Tv[18]; // Tv[18];
      Tv[29] := 50;
      Tv[35] := Tv[28] * Tv[29] / 100;
      Tv[30] := Tv[35];
      Tv[31] := Tv[26] + Tv[30]; // Tv[27]+Tv[30];
    end
    Else
    begin
      for i := 24 to 26 do
        Tv[i] := 0;
      for i := 28 to 31 do
        Tv[i] := 0;
      for i := 34 to 35 do
        Tv[i] := 0;
    end;
  end;
  SaveTv(RetNo, FName, FNo);
end;

(*
  Procedure CPPADJ(RetNo: integer; FName: String;FNo: integer);
  Var i,j:Integer;Cpt30Date:String;{Cpt30Months:Integer;}
  begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[Fno] do
  begin
  // If Strings[21]='' then Strings[21]:='Y';   //apply   //20131202
  If Strings[19]='' then Strings[19]:='N'; //override //20130318

  {  //20131202
  If (Vl(FetchElm(RetNo,'T4AP#1',8))>11)
  Or (Vl(FetchElm(RetNo,'T4AP#1',8))<1)
  then   //20130303
  begin
  Strings[1]:='';
  Strings[21]:='N';
  For i:=1 to 20 do Tv[i]:=0;
  SaveTv(RetNo,FName,FNo);
  Exit;
  end;  //20130318
  }
  //20120512
  If (MyStrToInt(FetchElm(RetNo,'T4AP#1',8))>0) and (MyStrToInt(FetchElm(RetNo,'T4AP#1',8))<12) then
  Strings[1]:= IntToStr(12 - MyStrToInt(FetchElm(RetNo,'T4AP#1',8)));

  Strings[2]:= FetchElm(RetNo,'T4AP#1',3);
  If (Vl(Strings[1])=0) and (Vl(Strings[2])=0) then  //20130303
  Strings[3]:='1.0000'
  else
  Strings[3]:= FormatFloat('##0.000000',(Vl(Strings[1])-Vl(Strings[2]))/12);  //20130303
  If Vl(Strings[3]) <0 then Strings[3]:='';  //20130303
  Tv[4]:=MinR(Constant[RY].MaxCppPensionable,ret[RetNo].T4CPPEarnings);
  With ret[RetNo] do
  begin
  Tv[5]:= (Lnn[12200]+Lnn[13500]+Lnn[13700]+Lnn[13900]+Lnn[14100]+Lnn[14300]);
  end;
  Tv[6]:=Constant[RY].MaxCppPensionable;
  Strings[7]:= FetchElm(RetNo,'T4AP#1',8);
  {
  Cpt30Date:=FetchElm(RetNo,'S8',22);
  If Cpt30Date='' then Cpt30Date:=FetchElm(RetNo,'T2204',35);
  Cpt30Months:=GetCpt30Months(retNo,Cpt30Date);
  If Cpt30Months>0 then
  Strings[8]:=IntToStr(12-Cpt30Months+1)
  Else
  Strings[8]:='';
  If Vl(Strings[8])>12 then Strings[8]:='';
  }
  If UpperCase(Strings[19])<> 'Y' then  //20130318  //override
  begin
  Strings[8]:=FetchElm(RetNo,'S8',20);
  If Vl(Strings[8])>12 then Strings[8]:='12';
  end;
  {
  //
  If Strings[8]='' then
  begin
  Cpt30Date:=FetchElm(RetNo,'T2204',35);
  Cpt30Months:=GetCpt30Months(retNo,Cpt30Date);
  If Cpt30Months>0 then
  Strings[8]:= IntToStr(Cpt30Months);
  end;
  }
  Strings[9]:='';
  If ret[RetNo].Age=70 then Strings[9]:=GetBirthMonth(RetNo);
  If IsDeceased(RetNo) then Strings[9]:=GetDeceasedMonth(RetNo) else Strings[9]:='';

  Tv[10]:=Tv[4]+Tv[5];
  Tv[11]:=Tv[6] * Vl(Strings[3]); //20130303 //Tv[3]; //20130303 //Constant[RY].BasicCppExemption * Tv[3];

  Tv[12]:=Constant[RY].BasicCppExemption * Vl(Strings[3]); //20130303 //Tv[3]; //Tv[11]; //20130303
  Tv[16]:= MaxR(0,Tv[10] - Tv[6] * MyStrToInt(Strings[1])/12); //8 pm //good for S8
  If Tv[10]>Tv[11] then
  begin
  Strings[14]:=Strings[7];
  Strings[15]:=Strings[8];
  If Vl(Strings[9])>Vl(Strings[8]) then Strings[15]:=Strings[9];
  Tv[13]:= (Constant[RY].BasicCppExemption * (MyStrToInt(Strings[14])-MyStrToInt(Strings[15])))/12;
  If Tv[13]<0 then Tv[13]:=0;  //20120320
  Tv[17]:=MinR(Tv[13],Tv[16]);
  end
  Else
  Begin
  Tv[18]:=Tv[12];
  For i:=13 to 18 do begin Strings[i]:='';Tv[i]:=0;end
  end;
  Tv[18]:=Tv[12]+Tv[17];
  end;
  SaveTv(RetNo,FName,FNo);
  end;
*)

Procedure PROVCTB(RetNo: integer; FName: String; FNo: integer); // 20130313
Var
  i: integer;
  CTBFNo: integer;
  BasicBenefit, BasicAmount, ReductionRate: Real;
begin
  LoadTv(RetNo, FName, FNo);
  CTBFNo := GetFormNo('CTB');
  with ret[RetNo].Frm[FNo] do
  begin

    If (UpperCase(FetchElmFNo(RetNo, CTBFNo, 71)) <> 'Y') Or
      (ret[RetNo].Province <> 'ON') then
    begin
      For i := 1 to 9 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      SaveTv(RetNo, FName, FNo);
      exit;
    end;
    Strings[10] := ret[RetNo].Province;
    If ret[RetNo].Province = 'ON' then
    Begin
      BasicBenefit := 1100;
      BasicAmount := 20000;
      ReductionRate := 8;
    end;
    {
      If ret[RetNo].Province='NL' then Begin BasicBenefit:=355;BasicAmount:=17397;ReductionRate:=6.44;end;
      If ret[RetNo].Province='YT' then Begin BasicBenefit:=690;BasicAmount:=30000;ReductionRate:=2.50;end;
      If ret[RetNo].Province='NS' then Begin BasicBenefit:=625;BasicAmount:=18000;ReductionRate:=8.93;end;
    }
    Strings[1] := IntToStr(CountKidsUnder18(RetNo));
    Tv[2] := vl(Strings[1]) * BasicBenefit;
    Tv[3] := vl(FetchElmFNo(RetNo, CTBFNo, 52));
    Tv[4] := BasicAmount;
    Tv[5] := MaxR(0, Tv[3] - Tv[4]);
    Tv[6] := ReductionRate;
    Tv[7] := Tv[5] * Tv[6] / 100;
    Tv[8] := Tv[7];
    Tv[9] := MaxR(0, Tv[2] - Tv[8]);
    Tv[11] := Tv[9] / 12;
  end;
  SaveTv(RetNo, FName, FNo);
end;

// 20150220
Procedure CPPADJ(RetNo: integer; FName: String; FNo: integer);
Var
  i, j: integer;
  Cpt30Date: String; { Cpt30Months:Integer; }
begin

  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    // If Strings[21]='' then Strings[21]:='Y';   //apply
    If Strings[19] = '' then
      Strings[19] := 'N'; // override //20130318
    // If UpperCase(FetchElm(RetNo,'T2204',33))='Y' then Strings[21]:='N';

    If (vl(FetchElm(RetNo, 'T4AP#1', 8)) > 11) Or
      (vl(FetchElm(RetNo, 'T4AP#1', 8)) < 1) then // 20130303
    begin
      Strings[1] := '';
      // Strings[21]:='N';
      For i := 1 to 20 do
        Tv[i] := 0;
      SaveTv(RetNo, FName, FNo);
      exit;
    end; // 20130318

    // 20120512
    If (MyStrToInt(FetchElm(RetNo, 'T4AP#1', 8)) > 0) and
      (MyStrToInt(FetchElm(RetNo, 'T4AP#1', 8)) < 12) then
      Strings[1] := IntToStr(12 - MyStrToInt(FetchElm(RetNo, 'T4AP#1', 8)));

    Strings[2] := FetchElm(RetNo, 'T4AP#1', 3);
    If (vl(Strings[1]) = 0) and (vl(Strings[2]) = 0) then // 20130303
      Strings[3] := '1.0000'
    else
      Strings[3] := FormatFloat('##0.000000', (vl(Strings[1]) - vl(Strings[2]))
        / 12); // 20130303
    If vl(Strings[3]) < 0 then
      Strings[3] := ''; // 20130303
    Tv[4] := MinR(Constant[RY].MaxCppPensionableEarnings, ret[RetNo].T4CPPEarnings);    //20241121
    With ret[RetNo] do
    begin
      Tv[5] := (Lnn[12200] + Lnn[13500] + Lnn[13700] + Lnn[13900] + Lnn[14100] +
        Lnn[14300]);
    end;

    Tv[6] := Constant[RY].MaxCppPensionableEarnings;   //20241121
    Strings[7] := FetchElm(RetNo, 'T4AP#1', 8);
    If UpperCase(Strings[19]) <> 'Y' then // 20130318  //override
    begin
      Strings[8] := FetchElm(RetNo, 'S8', 20);
      If vl(Strings[8]) > 12 then
        Strings[8] := '12';
    end;
    Strings[9] := '';
    If ret[RetNo].Age = 70 then
      Strings[9] := GetBirthmonth(RetNo);
    If IsDeceased(RetNo) then
      Strings[9] := GetDeceasedMonth(RetNo)
    else
      Strings[9] := '';
    Tv[20] := Tv[4] + Tv[5]; // 20150221
    Tv[10] := Tv[20];

    Tv[11] := Tv[6] * vl(Strings[3]);
    // 20130303 //Tv[3]; //20130303 //Constant[RY].BasicCppExemption * Tv[3];

    Tv[12] := Constant[RY].BasicCppExemption * vl(Strings[3]);
    // 20130303 //Tv[3]; //Tv[11]; //20130303

    Tv[16] := MaxR(0, Tv[10] - Tv[11]); // 20150221  //sunday
    // Tv[16]:= MaxR(0,Tv[10] - Tv[6] * MyStrToInt(Strings[1])/12); //8 pm //good for S8

    Strings[14] := Strings[7];
    Strings[15] := Strings[8];
    If vl(Strings[9]) > vl(Strings[8]) then
      Strings[15] := Strings[9];
    Tv[13] := (Constant[RY].BasicCppExemption * (MyStrToInt(Strings[14]) -
      MyStrToInt(Strings[15]))) / 12;
    If Tv[13] < 0 then
      Tv[13] := 0; // 20120320
    Tv[17] := MinR(Tv[13], Tv[16]);

    If Tv[10] <= Tv[11] then
      Tv[17] := 0; // 20150221
    Tv[18] := Tv[12] + Tv[17];
  end;
  SaveTv(RetNo, FName, FNo);
end;

// 20160116
Procedure CFRAFILL(RetNo: integer; FName: String; FNo: integer);
// 20160223 Igor
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    ret[RetNo].FrmHasData[FNo] := False;

    Tv[8] := 0;
    Tv[9] := 0;
    i := 287;
    Repeat
      If Tv[i] > 0 then
        Tv[8] := Tv[8] + Tv[i];
      If Tv[i] < 0 then
        Tv[9] := Tv[9] + ABS(Tv[i]);
      Inc(i, 5);
    until i > 382;
  end;
  SaveTv(RetNo, FName, FNo);
end;

// 20160116
Procedure T5008Dtl(RetNo: integer; FName: String; FNo: integer);
Begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
  end;
  SaveTv(RetNo, FName, FNo);
End;

// 20160116
Procedure CDE(RetNo: integer; FName: String; FNo: integer);
var
  i: integer;
  FPhone, FDesc: String;
  ProgramNo: integer;
Begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    // 20170205
    if UpperCase(Strings[9]) = 'EXTERNAL' then
      Strings[72] :=
        'Client may have an outstanding debt with another federal, provincial, or territorial government program';

    if UpperCase(Strings[8]) = 'SELF' then
      Strings[74] :=
        'The client may be eligible to claim the disability tax credit';

    if UpperCase(Strings[8]) = 'SPOUSE-COMMON-LAW' then
      Strings[74] :=
        'The client may be entitled to the transfer of the disability amount from his/her spouse/common-law partner';

    if UpperCase(Strings[8]) = 'DEPENDENTS' then
      Strings[74] :=
        'The client may be entitled to the transfer of the disability amount from one or more of his/her dependants';

    // 20180216
    // get the desription and Telephone number
    // if Strings[70]='ONSA' then Strings[71]:='1-866-750-6108';      //20170304
    i := 77;
    Repeat
      FPhone := '';
      FDesc := '';
      ProgramNo := 0;
      // ShowMessage(Strings[i]);
      if LeftStr(Strings[i], 1) = '#' then
        ProgramNo := MyStrToInt(MidStr(Strings[i], 2, 5))
      Else
        ProgramNo := MyStrToInt(Strings[i]);

      if ProgramNo > 0 then
      Begin
        if GetPhoneByProgramNumber(ProgramNo, FPhone, FDesc) then
        Begin
          Strings[i + 1] := FDesc;
          Strings[i + 2] := FPhone;
        End;
      end;
      Inc(i, 7);
    until i > 96;
  end;
  SaveTv(RetNo, FName, FNo);
End;

// 20170128
Procedure SCHSUPPL(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
Begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    i := 2;
    Tv[115] := 0;
    Repeat
      Tv[115] := Tv[115] + Tv[i];
      Inc(i, 2);
    until i > 114;
    if Tv[115] > 1000 then
      Tv[115] := 1000; // 20170306

  end;
  SaveTv(RetNo, FName, FNo);
End;

// 20161231
Procedure ONMTXWS(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  temp_value: real;
Begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    if (ret[RetNo].Province <> 'ON')
   // OR (vl(FetchElm(RetNo, 'T691', 249))=0) //20220224
    then
    Begin
      for i := 1 to 14 do
        Tv[i] := 0;
      exit;
    End;
    // 20170310
    if IsDeceased(RetNo) then
    begin
      for i := 1 to 14 do
        Tv[i] := 0;
      SaveTv(RetNo, FName, FNo);
      exit;
    end;

    Tv[1] := vl(FetchElm(RetNo, 'T691', 249));
    Tv[2] := Tv[1] * 24.63 / 100;    //20250419
    //Tv[2] := Tv[1] * 33.67 / 100;
    // Tv[3] := Tv[2];
    Tv[4] := vl(FetchElm(RetNo, 'ON428',143)); // 139)); // 20220224
    Tv[5] := Tv[2] + Tv[4];

    Tv[6] := Tv[5];
    Tv[8] := Tv[5]; // 20201202
    // 20231116
   //temp_value := Tv[6]; temp_value := MaxR(0, Tv[6] - 5315) * 20 / 100;
    Tv[7] := temp_value;

    //20241222
    If RY = 0 then
      Tv[7] := MaxR(0, Tv[6] - 5554) * 20 / 100
    Else
      Tv[7] := MaxR(0, Tv[6] - 5554) * 20 / 100;
    if RY = 0 then
      Tv[9] := MaxR(0, Tv[8] - 7108) * 36 / 100
    Else
      Tv[9] := MaxR(0, Tv[8] - 7108) * 36 / 100;

    Tv[10] := Tv[7] + Tv[9];
    Tv[11] := vl(FetchElm(RetNo, 'ON428', 151));
    Tv[12] := MaxR(0, Tv[10] - Tv[11]);
    Tv[13] := Tv[12];
    Tv[14] := Tv[2] + Tv[13];
  end;
  SaveTv(RetNo, FName, FNo);
End;

// 20170205
Procedure T2036SUM(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  T2036FNo1: integer;
Begin
  //jz//20260201 - form no longer used?? remove code and from database -- should remove pas/dfm as well
  {
  T2036FNo1 := GetFormNo('T2036');
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Tv[2] := vl(FetchElmFNo(RetNo, T2036FNo1, 2)) +
      vl(FetchElmFNo(RetNo, T2036FNo1, 13)) +
      vl(FetchElmFNo(RetNo, T2036FNo1, 24));
    Tv[3] := vl(FetchElmFNo(RetNo, T2036FNo1, 3)) +
      vl(FetchElmFNo(RetNo, T2036FNo1, 14)) +
      vl(FetchElmFNo(RetNo, T2036FNo1, 25));
    Tv[5] := vl(FetchElmFNo(RetNo, T2036FNo1, 5)) +
      vl(FetchElmFNo(RetNo, T2036FNo1, 16)) +
      vl(FetchElmFNo(RetNo, T2036FNo1, 27));
    Tv[6] := vl(FetchElmFNo(RetNo, T2036FNo1, 6)) +
      vl(FetchElmFNo(RetNo, T2036FNo1, 17)) +
      vl(FetchElmFNo(RetNo, T2036FNo1, 28));
    Tv[7] := vl(FetchElmFNo(RetNo, T2036FNo1, 7)) +
      vl(FetchElmFNo(RetNo, T2036FNo1, 18)) +
      vl(FetchElmFNo(RetNo, T2036FNo1, 29));
    // same
    Tv[8] := vl(FetchElmFNo(RetNo, T2036FNo1, 8));
    Tv[9] := vl(FetchElmFNo(RetNo, T2036FNo1, 9));
    Tv[19] := vl(FetchElmFNo(RetNo, T2036FNo1, 9));

    Tv[10] := vl(FetchElmFNo(RetNo, T2036FNo1, 10)) +
      vl(FetchElmFNo(RetNo, T2036FNo1, 21)) +
      vl(FetchElmFNo(RetNo, T2036FNo1, 32));
    Tv[11] := vl(FetchElmFNo(RetNo, T2036FNo1, 11)) +
      vl(FetchElmFNo(RetNo, T2036FNo1, 22)) +
      vl(FetchElmFNo(RetNo, T2036FNo1, 33));
  end;
  SaveTv(RetNo, FName, FNo);
  }
end;

Procedure REFILEQ(RetNo: integer; FName: String; FNo: integer); // 20170205
Var
  i, j: integer;
  FromInd, ToInx: integer;
  RefiledDir:string; //,RefileFolder: String;  //20240606
Begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    if Strings[101] = '' then
      Strings[101] := FetchElm(RetNo, GetFormNo('T183'), 36); // 20170404

    Strings[102]:= OptRec.Dir_Cur+'-RefiledReturns';  //20240606
    RefiledDir := MkRefiledDir(Strings[102]); //20240606

   // RefiledDir := MkRefiledDir; //(RefileFolder);
    Strings[8] := RefiledDir;   //?? not used?
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure REFILEV(RetNo: integer; FName: String; FNo: integer); // 20170205
Var
  i, j: integer;
  FInst: String[4];
  s, SnapShotDir, FileNm, Ln: String;
  PrevAmount, RevisedAmount: Real;
  BeforeList: TStringList;
  // LnList,AmtList,BeforeList,AfterList,NetList:TStringList;
  LnDescrList: TStringList;

Begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    // get descriptions
    LnDescrList := TStringList.Create;
    LnDescrList.LoadFromFile(AppDir + '\' + 'T1Tls.d');
    i := 23;
    repeat
      If (Strings[i] > '') and (Strings[i + 1] = '') then
        Strings[i + 1] := GetLineDescription(MyStrToInt(Strings[i]),
          LnDescrList);
      // Tv[i+3]:=Tv[i+4]-Tv[i+2];
      // Strings[i]:=LeftStr(Strings[i],4);
      // Strings[i]:=RemoveChar(Strings[i],'*');
      Inc(i, 5);
    until i > 248;
    LnDescrList.Free;
    SaveTv(RetNo, FName, FNo);
  End;
End;

Procedure T1OVP(RetNo: integer; FName: String; FNo: integer);
Var
  i, k, j: integer; // Pg3FNo:Integer;
  Age: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  Begin
    // 20170624
    Strings[1] := GetLastName(RetNo);
    Strings[2] := GetFirstName(RetNo);
    Strings[3] := GetSinNo(RetNo);
    Strings[525] := GetBirthdate(RetNo);
    // address
    Strings[4] := FetchElm(RetNo, 'INFO', 6) + ' ' + FetchElm(RetNo, 'INFO', 68)
      + FetchElm(RetNo, 'INFO', 22) + ' ' + FetchElm(RetNo, 'INFO', 163);
    // street rr po box apt
    Strings[5] := FetchElm(RetNo, 'INFO', 10) + ', ' + FetchElm(RetNo, 'INFO',
      14) + ' ' + FetchElm(RetNo, 'INFO', 15); // postal

    Tv[8] := MaxR(0, Tv[6] - Tv[7]);
    Tv[10] := Tv[8] - Tv[9]; // ?? remove  Thre is no 10,12 and 21
    Tv[12] := Tv[10] + Tv[11]; // remove

    Tv[13] := 0;
    i := 513;
    Repeat
      Tv[13] := Tv[13] + vl(FetchElmFNo(RetNo, FNo, i));
      Inc(i, 1);
    until i > 524;
    If UpperCase(Strings[21]) = 'Y' then
      Tv[12] := Tv[20]; // remove??
    Tv[15] := Tv[13] * 1 / 100;
    Strings[18] := FormatDateTime('yyyy-mm-dd', Date);

    i := 102;
    Repeat
      // If Strings[i]:=IntToStr(MyStrToInt(AppYear)-1) then Tv
      Tv[i + 3] := MaxR(0, Tv[i] + Tv[i + 1] - Tv[i + 2]);
      Inc(i, 6);
    until i > 132;

    Tv[139] := Tv[137] + Tv[138];

    // Part A
    Age := CalcAgeTo(ret[RetNo].Frm[FNo].Strings[525],
      IntToStr(MyStrToInt(AppYear) - 1) + '-12' + '-31');
    for k := 0 to 11 do
    Begin
      // first column
      if k = 0 then // first column
      Begin
        Tv[189] := Tv[8];
        Tv[225] := Tv[189] + Tv[201] + Tv[213];
        Tv[249] := Tv[225] - Tv[237];
      end
      Else
      Begin
        Tv[189 + k] := Tv[249 + k - 1]; // line 1
        Tv[225 + k] := Tv[189 + k] + Tv[201 + k] + Tv[213 + k]; // line 4
        Tv[249 + k] := Tv[225 + k] - Tv[237 + k]; // line 6
      End;
      // Tv[261 + k] := Tv[139];   //20200404
      Tv[285 + k] := Tv[261 + k] + Tv[273 + k];
      If Age >= 19 then
        Tv[297 + k] := 2000
      else
        Tv[297 + k] := 0;
      Tv[309 + k] := Tv[285 + k] + Tv[297 + k];
    end;

    // Part B
    // 20180210
    for k := 321 to 332 do
    begin
      if Tv[k] > Constant[RY].MoneyPurchaseLimit then
        Tv[k] := Constant[RY].MoneyPurchaseLimit;
    end;

    If UpperCase(Strings[526]) = 'X' then
    begin
      for k := 0 to 11 do
      begin
        Tv[345 + k] := MaxR(0, Tv[285 + k] - Tv[333 + k]);
        Tv[357 + k] := MaxR(0, Tv[321 + k] - Tv[345 + k]);
        Tv[369 + k] := MinR(Tv[321 + k], Tv[357 + k]);
        Tv[381 + k] := MaxR(0, Tv[249 + k] - Tv[309 + k]);
        Tv[393 + k] := MinR(Tv[369 + k], Tv[381 + k]);
      end;
    end
    else
    begin
      For j := 321 to 404 do
        Tv[j] := 0;
    end;

    // Part C
    for k := 0 to 5 do
    Begin
      Tv[405 + k] := MaxR(0, Tv[309 + k] + Tv[393 + k]);
      Tv[417 + k] := MaxR(0, Tv[249 + k] - Tv[405 + k]);

      Tv[411 + k] := MaxR(0, Tv[315 + k] + Tv[399 + k]);
      Tv[423 + k] := MaxR(0, Tv[255 + k] - Tv[411 + k]);
    end;

    // final calc amount due  //20170623
    Tv[13] := 0;
    for i := 417 to 422 do
      Tv[13] := Tv[13] + Tv[i];
    for i := 423 to 428 do
      Tv[13] := Tv[13] + Tv[i];
    Tv[15] := Tv[13] * 1 / 100;
    Tv[17] := Tv[15];
    if Tv[17] < 2 then
      Tv[17] := 0;
  End; // with
  SaveTv(RetNo, FName, FNo);
end;

// 20180310
Procedure T7DRQR(RetNo: integer; FName: String; FNo: integer);
var
  AmountOwing: Real;
  s: String;
  AmountPaid: Real;
Begin
  AmountOwing := ret[RetNo].Lnn[48500];
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  Begin
    AmountPaid := AmountOwing;
    if Strings[11] > '' then
    begin
      AmountPaid := vl(Strings[11]); // 20180319
      If AmountPaid > AmountOwing then
        AmountPaid := AmountOwing;
      Strings[11] := FormatFloat('#,###,###,0.00', AmountPaid);
    end;

    // upper part
    Strings[8] := ReformatSinWithSpaceInBetween(GetSinNo(RetNo));
    // 20180310 CON 9:54PM
    Strings[23] := justright(FormatFloat('#,###,###.00', AmountPaid), 13);
    // 20180319
    // Strings[23]:=justright(FormatFloat('#,###,###.00',AmountOwing),13);
    // if Strings[11]>'' then Strings[23]:=Strings[11];   //20180319

    // bottom part
    Strings[1] := Strings[8]; // GetSinNo(RetNo); //20180310 CON 9:54 PM
    // Strings[3] := '7';
    Strings[4] := '01';
    Strings[66] := GetFirstName(RetNo) + ' ' + GetLastName(RetNo);
    Strings[5] := FetchElm(RetNo, 'INFO', 6) + ' ' + FetchElm(RetNo, 'INFO', 22)
      + FetchElm(RetNo, 'INFO', 68);
    // Strings[6]:=FetchElm(RetNo,'INFO',68);
    Strings[6] := FetchElm(RetNo, 'INFO', 10); // city
    Strings[7] := AllTrim(FetchElm(RetNo, 'INFO', 14)); // prov
    Strings[9] := AllTrim(FetchElm(RetNo, 'INFO', 15));
    // OCR numbers  //20180310 CON 9:20 PM
    // 20180319
    s := '0100090001000700' + AddLeadingZeros(FetchElm(RetNo, 'INFO', 3), 15) +
      '00000000' + AddLeadingZeros(IntToStr(Trunc(AmountPaid * 100)), 10)
      + '010009';

    {
      S:='0100090001000700'+AddLeadingZeros(FetchElm(RetNo, 'INFO', 3), 15)
      +'00000000'+AddLeadingZeros(IntToStr(Trunc(Ret[RetNo].Lnn[48500] * 100)), 10)
      +'010009';
    }
    Strings[10] := s + CalcCheckDigitForT7DROCR(s);
    Strings[2] := justright(FormatFloat('#,###,###.00', AmountPaid), 13);
    Strings[12] := justright(FormatFloat('#,###,###.00', AmountOwing), 13);
    // 20190213 Igor
    // 20180319
    // Strings[2]:=justright(FormatFloat('#,###,###.00',AmountOwing),13);

  End;
  SaveTv(RetNo, FName, FNo);
End;


//20220408
Procedure ZeroOutNonRefundableTaxCredits(RetNo: integer); // 20180428
Var
  i: integer;
  NonResWithEmpl: Boolean;
  NonResPercent:Real;
Begin
  NonResPercent:=GetNonResPercent(RetNo);
  With ret[RetNo] do
  Begin
   if FetchElm(RetNo, 'INFO', 276) > '' then  //nr with empl
      NonResWithEmpl := True
   else
      NonResWithEmpl := False;

   if (NonResWithEmpl=True) then
   Begin
    if NonResPercent<90 then  //2022040409
    Begin //do not allow
     Lnn[30000] := 0; // Tv[23[:=0;   /20220408
     Lnn[30100] := 0;  //age ded
     Lnn[30300] := 0;  //spouse ded
     Lnn[30400] := 0;  //elig dep
     Lnn[30425] := 0;  //caregvr
     Lnn[30450] := 0;  //caregvr depend
     Lnn[30499] := 0;  //caregvr
     Lnn[30500] := 0;  //caregvr
    End;
   End;

   if (isSection216(retno))
   Or (isSection2161(retno)) //20260506
   then  //jz//NonResCERT-R2 20250415 - repeate the code from above as dont have time to look at it and change it
   Begin
     Lnn[30000] := 0; // Tv[23[:=0;   /20220408
     Lnn[30100] := 0;  //age ded
     Lnn[30300] := 0;  //spouse ded
     Lnn[30400] := 0;  //elig dep
     Lnn[30425] := 0;  //caregvr
     Lnn[30450] := 0;  //caregvr depend
     Lnn[30499] := 0;  //caregvr
     Lnn[30500] := 0;  //caregvr
   End;


   {
    Lnn[30000] := 0; // Tv[23[:=0;   /20220408
    Lnn[30100] := 0; // Tv[24]=0;
    Lnn[30300] := 0; // Tv[28]:=0;
    Lnn[30400] := 0; // Tv[74]:=0;
    Lnn[30425] := 0; // Tv[29]:=0;
    Lnn[30450] := 0; // Tv[75]:=0;

    If NonResWithEmpl = False then begin Lnn[30800] := 0; end; // Tv[31]:=0;end; //cpp

    Lnn[31000] := 0; // Tv[32]:=0;

    If NonResWithEmpl = False then begin Lnn[31200] := 0; end; // Tv[33]:=0;end; //eI

    Lnn[31217] := 0; // Tv[77]:=0;
    Lnn[31220] := 0; // Tv[79]:=0;
    Lnn[31240] := 0; // Tv[25]:=0;
    Lnn[31260] := 0; // Tv[65]:=0;
    Lnn[364] := 0; // Tv[66]:=0;
    Lnn[31285] := 0; // Tv[26]:=0;
    Lnn[31270] := 0; // Tv[78]:=0;
    Lnn[31300] := 0; // Tv[64]:=0;
    Lnn[31400] := 0; // Tv[34]:=0;
    If NonResWithEmpl = False then
    begin
      Lnn[31600] := 0;
    end; // Tv[35]:=0;end //disability for self
    Lnn[31800] := 0; // Tv[36]:=0;
    If NonResWithEmpl = False then
    begin
      Lnn[31900] := 0;
    end; // Tv[43]=0;end;  //interest loan
    If NonResWithEmpl = False then
    begin
      Lnn[32300] := 0;
    end; // Tv[37]:=0;end;  //Tuition
    Lnn[32400] := 0; // Tv[38]:=0;
    Lnn[32600] := 0; // Tv[39]:=0;
   }
  End;
End;


(*
// 20180428
Procedure ZeroOutNonRefundableTaxCredits(RetNo: integer); // 20180428
Var
  i: integer;
  NrWithEmpl: Boolean;
  NonResPercent:Real;
Begin
  With ret[RetNo] do
  Begin
    if FetchElm(RetNo, 'INFO', 276) > '' then
      NrWithEmpl := True
    else
      NrWithEmpl := False;

   // NonResPercent:=GetNonResPercent(RetNo);
    Lnn[30000] := 0; // Tv[23[:=0;   /20220408
    Lnn[30100] := 0; // Tv[24]=0;
    Lnn[30300] := 0; // Tv[28]:=0;
    Lnn[30400] := 0; // Tv[74]:=0;
    Lnn[30425] := 0; // Tv[29]:=0;
    Lnn[30450] := 0; // Tv[75]:=0;

    If NrWithEmpl = False then begin Lnn[30800] := 0; end; // Tv[31]:=0;end; //cpp

    Lnn[31000] := 0; // Tv[32]:=0;

    If NrWithEmpl = False then begin Lnn[31200] := 0; end; // Tv[33]:=0;end; //eI

    Lnn[31217] := 0; // Tv[77]:=0;
    Lnn[31220] := 0; // Tv[79]:=0;
    Lnn[31240] := 0; // Tv[25]:=0;
    Lnn[31260] := 0; // Tv[65]:=0;
    Lnn[364] := 0; // Tv[66]:=0;
    Lnn[31285] := 0; // Tv[26]:=0;
    Lnn[31270] := 0; // Tv[78]:=0;
    Lnn[31300] := 0; // Tv[64]:=0;
    Lnn[31400] := 0; // Tv[34]:=0;
    If NrWithEmpl = False then
    begin
      Lnn[31600] := 0;
    end; // Tv[35]:=0;end //disability for self
    Lnn[31800] := 0; // Tv[36]:=0;
    If NrWithEmpl = False then
    begin
      Lnn[31900] := 0;
    end; // Tv[43]=0;end;  //interest loan
    If NrWithEmpl = False then
    begin
      Lnn[32300] := 0;
    end; // Tv[37]:=0;end;  //Tuition
    Lnn[32400] := 0; // Tv[38]:=0;
    Lnn[32600] := 0; // Tv[39]:=0;
  End;
End;
*)

Procedure S14(RetNo: integer; FName: String; FNo: integer);
begin
  Exit;  //20221226
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
   if (Ret[RetNo].Province='ON')
   or (Ret[RetNo].Province='AB')
   or (Ret[RetNo].Province='MB')
   Or (Ret[RetNo].Province='SK')
   then
   Begin
     ret[RetNo].FrmHasData[FNo] :=True;
   End
   Else
    ret[RetNo].FrmHasData[FNo] :=False;

  // if Strings[2]>'' then ret[RetNo].FrmHasData[FNo] :=True;

   {
   If UpperCase(Strings[7])>'' then  //20220220
     ret[RetNo].FrmHasData[FNo] :=True
    else
     ret[RetNo].FrmHasData[FNo] :=False;
   }
  // Tv[11]:=Vl(FetchElm(RetNo,'S14EST',11));  //20260212
  end;
  SaveTv(RetNo, FName, FNo);
End;






Function GetClimateChangeAmount(RetNo: integer; Prov: String): Real;
Var
  S14FNo: integer;
Begin
  Result := 0;
  S14FNo := GetFormNo('S14' + UpperCase(Prov));
  If S14FNo > 0 then
    Result := vl(FetchElm(RetNo, S14FNo, 11));
End;

// 20181125
Procedure PopulateS14G(RetNo: integer);
Var
  i: integer;
  S14GFNo, S14PrvFNo: integer;
Begin
  S14GFNo := GetFormNo('S14G'); // 20191224
  For i := 1 to 21 do
  Begin
    StoreElm(RetNo, S14GFNo, i, '');
  end;
  if ret[RetNo].Province = 'NB' then
    exit; // 20191222 opted out
  if ret[RetNo].Province = 'YT' then
    exit; // 20191222 YT has its own format S14 shedule

  for i := 1 to 21 do
  Begin
    if S14PrvFNo > 0 then // 20191224
      StoreElm(RetNo, S14GFNo, i, FetchElmFNo(RetNo, S14PrvFNo, i));
  End;
End;

// 20190418
Function SpouseTosiInEffect(RetNo: integer; InfoFormNo: integer): Boolean;
Begin
  Result := False;
  If GetSpouseSplitIncome(RetNo, InfoFormNo) > 0 then
    Result := True;
End;

Function TOSIinEffect(RetNo: integer): Boolean;
Begin
  Result := False;
  if (vl(FetchElm(RetNo, 'T1206', 3)) > 0) // 20190211
    and (UpperCase(FetchElm(RetNo, 'T1206', 16)) = 'Y') then
    Result := True;
  // if Vl(FetchElm(RetNo,'T1206',4))>0 then Result:=True;
  // if Vl(FetchElm(RetNo,'T1206',4))<>Vl(FetchElm(RetNo,'T1206',51))  then Result:=True; //20190210
End;

// 20181220
Function GetTOSINetIncome(RetNo: integer): Real;
Begin
  Result := vl(FetchElm(RetNo, 'T1206', 4));
End;

// 20181220
Function GetTOSIFedTaxableIncome(RetNo: integer): Real;
Begin
  Result := vl(FetchElm(RetNo, 'T1206', 43));
End;

// 20181220
Function GetTOSIPrvTaxableIncome(RetNo: integer): Real;
Begin
  Result := vl(FetchElm(RetNo, 'T1206', 64)); // 31C
End;

// 20181221
Function GetTOSIPrvTax(RetNo: integer): Real;
Begin
  Result := vl(FetchElm(RetNo, 'T1206', 103)); // 31C
End;

Function GetDependantTosiL300ToL314(RetNo, i, DependFNo: integer): Real;
Var
  k: integer;
  // i:dependant name in Depend screen, k pointer to TOSI name on Depend
Begin
  k := Trunc((i / 15)) * 7 + 301;
  // index to TOSI name. So  k+4 is the Tosi taxable income
  Result := vl(FetchElmFNo(RetNo, DependFNo, k + 5));
End;

Function GetDependantSplitIncome(RetNo, i, DependFNo: integer): Real;
Var
  k: integer;
  // i:dependant name in Depend screen, k pointer to TOSI name on Depend
Begin
  k := Trunc((i / 15)) * 7 + 301;
  // index to TOSI name. So  k+2 is the split income
  Result := vl(FetchElmFNo(RetNo, DependFNo, k + 2));
End;

Function GetDependantTosiTaxableIncome(RetNo, i, DependFNo: integer): Real;
Var
  k: integer;
  // i:dependant name in Depend screen, k pointer to TOSI name on Depend
Begin
  k := Trunc((i / 15)) * 7 + 301;
  // index to TOSI name. So  k+4 is the Tosi taxable income
  Result := vl(FetchElmFNo(RetNo, DependFNo, k + 4));
End;

Function GetDependantTosiPrvTaxableIncome(RetNo, i, DependFNo: integer): Real;
Var
  k: integer;
  // i:dependant name in Depend screen, k pointer to TOSI name on Depend
Begin
  k := Trunc((i / 15)) * 7 + 301;
  // index to TOSI name. So  k+4 is the Tosi taxable income
  Result := vl(FetchElmFNo(RetNo, DependFNo, k + 5));
End;

Function GetSpouseSplitIncome(RetNo, InfoFormNo: integer): Real;
Begin
  Result := vl(FetchElmFNo(RetNo, InfoFormNo, 29));
End;

// 20181227
Function GetSpouseTosiNetIncome(RetNo, InfoFormNo: integer): Real;
Begin
  Result := vl(FetchElmFNo(RetNo, InfoFormNo, 30)); // for line 5912
End;

(* 20220528
// 20190208
procedure transferS2MJtoS2MJxx(RetNo: integer; s2T2203Prov: string);
var
  i, j: integer;
  toS2MJxx: string;

  FormName: string;
  FNo: integer;
begin
 // exit; // 20200412

  toS2MJxx := 'S2MJ' + s2T2203Prov;

  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'S2MJ' then
    begin
      FNo := FRec.FormNo;
      If ret[RetNo].FormHasData[FRec.FormInstName] then
      begin
        if LeftStr(FetchElmFNo(RetNo, FNo, 15), 2) = s2T2203Prov then
        begin
          for j := 1 to 40 do
          Begin
            StoreElm(RetNo, toS2MJxx, j, FetchElmFNo(RetNo, FNo, j));
          end;
        end;
      end;
    end;
  end;
end;
*)

Function PrecalcS6(RetNo: integer): Boolean; // 20190407 CWB Forces calc of S6
Begin
  if FetchElm(RetNo, 'S6', 20) = '' then // 20190408
  Begin
    Result := False;
    PrecalcS6 := True;
    S6(RetNo, 'S6', GetFormNo('S6'));
    Result := ret[RetNo].Lnn[45300] > 0;
    // PrecalcS6Sw is turned off by the calling routine, after getting the result
  End;
End;

// 20200222
Procedure CalcPrintJacket(RetNo: integer); // for printing purposes
var
  FName: String;
  FNo: integer;
  Prv: String; // enter the exta residency
  i, FromFNo: integer;
Begin
  Prv := UpperCase(ret[RetNo].Province);
  FName := UpperCase('T1' + Prv);
  FNo := GetFormNo(FName);
  FromFNo := GetFormNo('T1');
  LoadTv(RetNo, FName, FNo);
  for i := 1 to 550 do
  begin
    StoreElm(RetNo, FNo, i, FetchElm(RetNo, FromFNo, i));
  end;
  // CopySubstitute(RetNo,'T1',FName); //Clone from T1 to lets say T1NT
  ret[RetNo].FrmHasData[FNo] := True;
  SaveTv(RetNo, FName, FNo);
End;

// After March 17
Procedure AUTO777(RetNo: integer; FName: string; FNo: integer);
Var
  i: integer;
  Aiipfactor: Real;
  FInst: String[4];
  k, Gst, Pst: Real;
  Line5K, Line6K, Line7K: Real;
  Yr: String[4];
  TotalDays, DaysBeforeJuly1, DaysAfterJuly1: integer;
  StartLease, ENdLease: String;
  MaxCCA: Real;
  Aiip:Boolean;  //20250510
Begin
  // ConvertOldAutoExpDates(RetNo,FNo);
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin

    // If Strings[1] > '' then Strings[215] := 'T777#1'; //20200512
    if vl(Strings[134]) = 8 then
    Begin
      Strings[1] := 'Class 8 for T777'; // 20200510
      Strings[4] := '1';
      Strings[7] := '1';
      // remove expenses if class 8 //201200510
      Tv[217] := 0;
      Tv[219] := 0;
      Tv[10] := 0;
      Tv[19] := 0;
      Tv[22] := 0;
      Tv[25] := 0;
      Tv[13] := 0;
      Tv[16] := 0;
      Tv[32] := 0;
      Tv[36] := 0;
      Tv[42] := 0;
      Tv[45] := 0;
      Tv[48] := 0;
      Tv[54] := 0;
      Tv[103] := 0;
      Tv[109] := 0;
      Tv[106] := 0;
      Tv[112] := 0;
      Tv[115] := 0;
      Tv[78] := 0;
      Tv[81] := 0;
      Tv[84] := 0;
      Tv[99] := 0;
    End;

    Strings[3] := Strings[134]; // 201200510  cca at the top

    i := 216;
    Repeat
      If Tv[i] = 0 then
        Tv[i] := 100;
      If Tv[i] > 100 then
        Tv[i] := 100;
      If Strings[i - 1] = '' then
        Tv[i] := 0; // no statement
      Tv[i + 1] := Tv[i] * Tv[45] / 100;
      Tv[i + 2] := Tv[i] * Tv[122] / 100;
      Tv[i + 3] := Tv[48];
      Inc(i, 6); // dummy
    until i > 216; // 228;
    If (vl(Strings[4]) = 0) and (vl(Strings[7]) = 0) then
    begin
      Strings[4] := '1';
      Strings[7] := '1';
    end;
    If vl(Strings[7]) < vl(Strings[4]) then
      Strings[7] := Strings[4];

    Yr := LeftStr(Strings[57],4); //20260529

    For i := 0 to 0 do
    begin
      If vl(Strings[7 + i]) > 0 then
        Tv[122 + i] := Tv[119 + i] * (vl(Strings[4 + i]) / vl(Strings[7 + i])) *
          Tv[216] / 100 // 20200521
      else
        Tv[122 + i] := 0;

      { Lease }
      Yr := LeftStr(Strings[57 + i], 4);
      StartLease := Strings[57 + i];
      ENdLease := Strings[60 + i];
      If (StartLease > '') and (ENdLease > '') then
        TotalDays := DateDiff(YMDtoDate(StartLease), YMDtoDate(ENdLease));
      DaysBeforeJuly1 := DateDiff(YMDtoDate(StartLease),
        YMDtoDate(MinString('2006-07-01', ENdLease))); // 20160119 Igor
      DaysAfterJuly1 := DateDiff(YMDtoDate(MaxString('2006-07-01', StartLease)),
        YMDtoDate(ENdLease)); // 20160119 Igor

      If DaysBeforeJuly1 < 0 then
        DaysBeforeJuly1 := 0;
      If DaysAfterJuly1 < 0 then
        DaysAfterJuly1 := 0;

      if Tv[75]>0 then
       Tv[5]:=Tv[75]
      else
      Begin
       Line5K := GetLine5K(Yr);
       Tv[5]:=Line5k; //20260329
      end;
      //xx:=Line5k;

      Gst := Line5K * Tv[126 + i] / 100;
      Pst := Line5K * vl(Strings[63 + i]) / 100;
      If Yr < '1991' then
      begin
        Gst := 0;
        Pst := 0;
      end;

      k := Line5K + Gst + Pst;
      Tv[78 + i] := MaxR(k, Tv[75 + i]) * 0.85;

      Line6K := GetLine6K(Yr);
      Tv[8]:=Line6k;  //20260329

      Gst := Line6K * Tv[126 + i] / 100;
      Pst := Line6K * vl(Strings[63 + i]) / 100;
      If Yr < '1991' then
      begin
        Gst := 0;
        Pst := 0;
      end;
      k := Line6K + Gst + Pst;
      Tv[81 + i] := MaxR(0, ((k * Tv[72 + i]) / 30) - Tv[69 + i]);

      Line7K := GetLine7K(Yr);
      Tv[9]:=Line7k; //20260329
      Gst := Line7K * Tv[126 + i] / 100;
      Pst := Line7K * vl(Strings[63 + i]) / 100;
      If Yr < '1991' then
      begin
        Gst := 0;
        Pst := 0;
      end;
      k := Line7K + Gst + Pst;
      If Tv[78 + i] > 0 then
        Tv[84 + i] := k * Tv[66 + i] / Tv[78 + i]
      else
        Tv[84 + i] := 0;

      Tv[99 + i] := MinR(Tv[81 + i], Tv[84 + i]);
      { Interest }
      If Tv[109 + i] = 0 then
        Tv[109 + i] := 10;
      If vl(Strings[106 + i]) = 0 then
        Tv[109 + i] := 0;
      Tv[112 + i] := vl(Strings[106 + i]) * Tv[109 + i];
      Tv[115 + i] := MinR(Tv[103 + i], Tv[112 + i]);

      { interest }
      If UpperCase(Strings[28]) <> 'Y' then
        Tv[19] := Tv[115];

      { expense }
      If UpperCase(Strings[29]) <> 'Y' then
        Tv[16] := Tv[99];
      Tv[42 + i] := Tv[10 + i] + Tv[19 + i] + Tv[22 + i] + Tv[25 + i] +
        Tv[13 + i] + Tv[16 + i] + Tv[32 + i] + Tv[36 + i];
      If vl(Strings[7 + i]) > 0 then
        Tv[45 + i] := Tv[42 + i] * (vl(Strings[4 + i]) / vl(Strings[7 + i]))
      else
        Tv[45 + i] := 0;
      Tv[54 + i] := MaxR(0, Tv[45 + i] - Tv[48 + i]);
    end;

    // CCA
    Strings[131] := Strings[1];
    For i := 0 to 0 do
    begin
      If LeftStr(Strings[137], 4) = AppYear then
        Tv[140] := 0;
      Tv[191 + i] := MaxR(0, Tv[140 + i] - Tv[188 + i]);
      Tv[194 + i] := Tv[12 + i]; // 20200512
      If Strings[134 + i] = '10.1' then
       Tv[194 + i] := MinR(38000, Tv[12 + i]);  //20260415
        //Tv[194 + i] := MinR(37000, Tv[12 + i]);
    //  if Strings[134]='54' then TV[194]:=MinR(Tv[12],61000); //Cost 20260415 questionable

      Tv[149 + i] := MaxR(0, Tv[194 + i] - Tv[146 + i]);
      // pst ??
      Tv[152 + i] := Tv[149 + i] * Tv[197 + i] / 100;
      Tv[155 + i] := Tv[149 + i] * Tv[200 + i] / 100;  //20260415

      Tv[6 + i] := Tv[149 + i] + Tv[152 + i] + Tv[155 + i] + Tv[146 + i];
      // includes trade in

      if Strings[137] < '2024-01-01' then  Strings[34] := 'X'; // else Strings[34]:=''; // 20260508
      If Strings[34]>'' then Aiip:=True else Aiip:=false;  //20250510
     // if Strings[137] > '2019-11-20' then  Strings[34] := 'X'; // 20190313
     if (Aiip = True) and (Tv[26] = 0) then Tv[26] := Tv[6]; // 20200514
     // if (Strings[34] = 'X') and (Tv[26] = 0) then Tv[26] := Tv[6]; // 20200514
      if Tv[26] > Tv[6] then Tv[26] := Tv[6];

      if Aiip=false then //Strings[34] = '' then // qualifying for for aiip
      begin
        Tv[26] := 0;
        Tv[27] := 0;
        Tv[33] := 0;
        Tv[30] := 0
      end; // 20190216

      if Aiip=false then Tv[30]:=0; //Strings[34] = '') then Tv[30]:=0;   //20250508

      // 20190216 Aii
      Tv[24] := MaxR(0, Tv[191] + Tv[6] - Tv[15]);
      // i not needed it is from 0 to 0
      Tv[27] := MaxR(0, Tv[15] - Tv[6] + Tv[26]);

      // Aiipfactor
      if Strings[134] = '43.1' then
        Aiipfactor := 2.33333
      Else if Strings[134] = '43.2' then
        Aiipfactor := 1
      Else if Strings[134] = '53' then
        Aiipfactor := 1
      Else
        Aiipfactor := 0.5;

      // 20200512
      if (Strings[134] = '54') then
      Begin
        If Strings[137] > '2018-11-20' then
        begin
          Strings[34] := 'X'; Aiip:=True;
          Aiipfactor := 0.5;
        end; // qualified
        if (Strings[134] = '54') and (Strings[137] > '2019-03-18') then
        begin
          Strings[34] := 'X';  Aiip:=True;
          Aiipfactor := 2.33333333;
        end;
      End;

      if (Strings[134] = '55') and (Strings[137] > '2019-03-18') then
        Aiipfactor := 1.5;

      /// if Strings[34]>'' then Tv[26]:=Tv[6]; //eligb l for aiip

      Tv[33] := Aiipfactor;
      Tv[30] := MaxR(0, Tv[26] - Tv[27]) * Tv[33];

      Strings[170 + i] := '30';
      if Strings[134] = '8' then Strings[170 + i] := '20'; // 20200511

      Tv[164] := MaxR(0, Tv[6] - Tv[26] - Tv[15]) * 0.50;
      if Aiip=True then TV[164]:=Tv[30]; //0;  //20250510
      //if Aiip=false then TV[164]:=0;  //20250508 If AIIP //??

      Tv[167] := MaxR(0, Tv[24] + Tv[30] - Tv[164]);

      // 20190319
      If Strings[206] = '' then   //override
      begin
        Tv[173] := Tv[167] * (vl(Strings[170]) / 100);
        If (Strings[134] = '10.1') and (Strings[182] > '') then
          Tv[173] := Tv[173] / 2; // 20140324  //empty and 10.1 cca=50%
      end;

      If Strings[134 + i] = '10.1' then
      begin
        If (LeftStr(Strings[137 + i], 4) = AppYear) // bought/sold same year
          and (Tv[15 + i] > 0) then // disposed
        begin
          Tv[167 + i] := 0; // base for cca
          Tv[173 + i] := 0; // cca
          Tv[176 + i] := 0; // ucc end
        end;
        If (LeftStr(Strings[137 + i], 4) < AppYear) then // owned prv year
        begin
          If (Tv[15 + i] > 0) or (Strings[182 + i] > '') then
          // disposed in current year
          begin
            Tv[167 + i] := (Tv[191 + i] + Tv[6]) / 2; // base
            Tv[173 + i] := Tv[167 + i] * 0.30; // cca
          end;
        end;
        If Tv[15 + i] > 0 then
          Tv[176 + i] := 0; // disposed
      end;
      If UpperCase(Strings[182 + i]) = 'X' then
        Tv[176 + i] := 0; // class empty

      Tv[122 + i] := Tv[173 + i] * vl(Strings[4 + i]) / vl(Strings[7 + i]);

      // TV[173]:=Tv[122 + i];  //20260405   //20260415

      Tv[176] := MaxR(0, Tv[24] - Tv[173]); // 20190216

      // 20200512
      if (Strings[182] > '') then
        Tv[176] := 0;
      if (Strings[134] = '10.1') And (Tv[15] > 0) then
        Tv[176] := 0; // 20200512
    end;

    i := 215;   //jz//20260326 - NOTE: here, like everywhere else, does not require loop, but leave for now
    Repeat
      If Strings[i] > '' then
      begin
        Tv[i + 2] := Tv[45] * Tv[i + 1] / 100;
        Tv[i + 3] := Tv[173] * vl(Strings[4]) / vl(Strings[7]) *
          Tv[i + 1] / 100;
      end
      Else
      begin
        Tv[i + 2] := 0;
        Tv[i + 3] := 0;
      end;
      Inc(i, 6); // dummy
    until i > 215; // 227;

  end; { End with }
  SaveTv(RetNo, FName, FNo);
  // Now recalc bus statements
  // Calc(RetNo, 'T777'+FInst);  //20200511   //20200511
End;


Procedure T1SALDIV(RetNo: integer; FName: String; FNo: integer); // 20200821
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    //
  end; // with
  SaveTv(RetNo, FName, FNo);
end;

(* Experiment and simple working sample
  See also S4 that uses a form T1SalDiv being populated by the T2 app

  Procedure CroassappSample; //20200820
  Var i,j,FNo:integer; T2App:TApp; T2RetNo:Integer;  //20200820
  SalDivSet:TstringList;
  Begin
  T2App := AppList.AppFromName('T2');
  if not Assigned(T2App) then  begin  showmessage('T2 App was not found'); exit; end;
  T2RetNo:=-1;
  for I := 0 to RetList.Count - 1 do
  Begin
  if Assigned(RetList[I]) and (RetList[I].MyApp = T2App)
  // and SameText(RetList[I].SourceFlName, FlName)
  // and SameText(RetList[I].SourceDataDir,DataDir) {not sure if it is needed} //20200808
  then
  begin
  T2RetNo:=I;
  Break;
  end;
  End;

  if T2RetNo < 1 then
  begin
  ShowMessage('T1 cannot find the T2 return.'+
  Chr(13)+'Close the program and FIRST open the T2 return');
  Exit;
  end;

  SalDivSet:=TStringList.create;
  for i:=1 to 275 do  //one less    //try 0 to 274?
  Begin
  SalDivSet.Add(FetchElm(T2RetNo,'SALDIVSET',i)); //one more for easy ref to SalDivSet form in T2
  End;
  showMessage('Compensation in elm 6 of the T2 '+IntToStr(5)+' '+Saldivset[i]); //this seems to work??
  SalDivSet.free;
  //Retlist.CalcFullReturn(RetNo);  //for t1 here does not work
  //ReCalcEverything(T2RetNo); //this seems to work
  // OpenForm(RetNo,'TAXSUM',0);  //does not work but the T2RetNo works
  end;
*)

// 20201118
(*
//OLD routine 20210805 does not use variables
Procedure LN30000(RetNo: integer; FName: String; FNo: integer); // 20200821
Var
  i: integer;
  NetIncome: Real;
begin
  NetIncome := ret[RetNo].Lnn[23600];
  // 20201125
  If TOSIinEffect(RetNo) then
    NetIncome := GetTOSINetIncome(RetNo);
  // Ret[RetNo].Lnn[30000]:=GetPersonalAmountFromNetIncome(GetTOSINetIncome(RetNo));
  // everyyear
  LoadTv(RetNo, FName, FNo);
  // 20201122
  for i := 1 to 11 do
  begin
    Tv[i] := 0;
  End; // 20201122

  with ret[RetNo].Frm[FNo] do
  begin
    if NetIncome <= 150473 then
    Begin
      Tv[11] := 13229;
      ret[RetNo].Lnn[30000] := Tv[11];
      SaveTv(RetNo, FName, FNo);
      exit;
    End
    Else if NetIncome >= 214369 then
    Begin
      Tv[11] := 12298;
      ret[RetNo].Lnn[30000] := Tv[11];
      SaveTv(RetNo, FName, FNo);
      exit;
    End;
    Tv[1] := 12298;
    Tv[2] := 931;
    Tv[3] := NetIncome; // Ret[RetNo].Lnn[23600];
    Tv[4] := 150473;
    Tv[5] := MaxR(0, Tv[3] - Tv[4]); // 20201122

    Strings[6] := FormatFloat('###.#######', (Tv[5] / 63895));
    // 20201122 no round
    Tv[7] := vl(Strings[6]) * 931;
    Tv[8] := Tv[7];
    Tv[9] := MaxR(0, Tv[2] - Tv[8]); // 20201119
    Tv[10] := Tv[9];
    Tv[11] := MinR(13229, Tv[1] + Tv[10]);
    ret[RetNo].Lnn[30000] := Tv[11];
  end; // with
  SaveTv(RetNo, FName, FNo);
end;
*)
(* 20210805  NOT USED
Function GetPersonalAmountFromNetIncome(NetIncome: Real): Real; // 20201122
Var
  i: integer;
  s: String;
Begin
  for i := 1 to 11 do
  begin
    Tv[i] := 0;
  End; // 20201122
  if NetIncome <= 150473 then
  Begin
    Tv[11] := 13229;
    Result := Tv[11];
    exit;
  End
  Else if NetIncome >= 214369 then
  Begin
    Tv[11] := 12298;
    Result := Tv[11];
    exit;
  End;
  Tv[1] := 12298;
  Tv[2] := 931;
  Tv[3] := NetIncome;
  Tv[4] := 150473;
  Tv[5] := MaxR(0, Tv[3] - Tv[4]); // 20201122
  s := FormatFloat('###.#######', (Tv[5] / 63895)); // 20201124 //no round
  Tv[7] := vl(s) * 931;
  Tv[8] := Tv[7];
  Tv[9] := MaxR(0, Tv[2] - Tv[8]); // 20201119
  Tv[10] := Tv[9];
  Tv[11] := MinR(13229, Tv[1] + Tv[10]);
  Result := Tv[11];
end;
*)

// 20250927
Procedure LN30000(RetNo: integer; FName: String; FNo: integer); // 20200821
Var
  i: integer;
  NetIncome: Real;
  BaseAmount,IncomeThreshhold,NetInc1,NetInc2,Divider,Multiplier,SupplementAmount:Real;
 //20221204
 begin
   //2025 5000.d
   BaseAmount:=14538;  //14156;  //2025
   NetInc1:=177882; //173205; //151978;
   NetInc2:=253414; //246752; //216511;  //2025
   IncomeThreshhold:=NetInc1;
   SupplementAmount:=1591; //1549; //1387;
   Divider:=75532; //73547; //64533; //2025
  if Ry=1 then
  Begin
   //2025 5000.d
   BaseAmount:=14538;  //14156;  //2025
   NetInc1:=177882; //173205; //151978;
   NetInc2:=253414; //246752; //216511;  //2025
   IncomeThreshhold:=NetInc1;
   SupplementAmount:=1591; //1549; //1387;
   Divider:=75532; //73547; //64533; //2025
  End;


  NetIncome := SelectNetIncomeAmount(RetNo); //20250222 // ret[RetNo].Lnn[23600];
  if IsSection217(RetNo) then NetIncome:=Vl(FetchElm(Retno,'SNRESA',18));

  // 20201125
  If TOSIinEffect(RetNo) then
    NetIncome := GetTOSINetIncome(RetNo);
  // everyyear
  LoadTv(RetNo, FName, FNo);
  // 20201122

  with ret[RetNo].Frm[FNo] do
  begin
    for i := 1 to 11 do
    begin
      Tv[i] := 0;
    End; // 20201122

    if NetIncome <= NetInc1 then
    Begin
      Tv[11] :=Constant[RY].BasicPersonalAmount; //13229;
      ret[RetNo].Lnn[30000] := Tv[11];
      Tv[6]:=0;Strings[6]:='';
      SaveTv(RetNo, FName, FNo);
      exit;
    End
    Else if NetIncome >= NetInc2 then
    Begin
      Tv[11] :=BaseAmount; // 12298;
      ret[RetNo].Lnn[30000] := Tv[11];
      Tv[6]:=0;Strings[6]:='';
      SaveTv(RetNo, FName, FNo);
      exit;
    End;
    Tv[1] :=BaseAmount; // 12298;
    Tv[2] := SupplementAmount; //931;
    Tv[3] := NetIncome; // Ret[RetNo].Lnn[23600];
    Tv[4] := IncomeThreshhold; //150473;
    Tv[5] := MaxR(0, Tv[3] - Tv[4]); // 20201122

    Strings[6] := FormatFloat('##0.#######', (Tv[5] / Divider)); //FormatFloat('###.#######', (Tv[5] / 63895));
    // 20201122 no round
    Tv[7] := vl(Strings[6]) * SupplementAmount; //931;
    Tv[8] := Tv[7];
    Tv[9] := MaxR(0, Tv[2] - Tv[8]); // 20201119
    Tv[10] := Tv[9];
    Tv[11] := MinR(Constant[RY].BasicPersonalAmount, Tv[1] + Tv[10]);
    ret[RetNo].Lnn[30000] := Tv[11];
  end; // with
  SaveTv(RetNo, FName, FNo);
end;

Procedure LN34990(RetNo: integer; FName: String; FNo: integer); // 2026010300821
Var
  i: integer;
 begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
   Tv[1]:=ret[RetNo].Lnn[33800];
   Tv[2]:=Vl(FetchElm(RetNo,'S9',35));  //jz//20260116 - get value from s9 line 22 tv[35]
   Tv[3]:=Tv[1]+Tv[2];
   Tv[8]:=8319.38;                      //jz//20260116 - correct the amount from 83319.38;
   Tv[4]:=MaxR(0,Tv[3]-Tv[8]);
   Tv[5]:=3.45;
   Tv[6]:=Tv[4]*Tv[5]/100;
  end; // with
  SaveTv(RetNo, FName, FNo);
end;

//20230312 M14 version
procedure T1032(RetNo: integer; FName: String; FNo: integer);
Const Threshold=131483.45; //126350; //122733; //20250315
Var
  i, PensionerRetNo, TransfereeRetNo, SpRetNo, OptimizeFNo: integer;
  FromT4a, FromT4Rif, FromT4RSP, FromT4ARCA, x: Real;
  Qualified: Boolean;

begin
  PensionerRetNo := 0;
  TransfereeRetNo := 0;
  OptimizeFNo := GetFormNo('OPTIMIZE');
  If ret[RetNo].CouplingSw then
    SpRetNo := GetSpRetNo(RetNo)
  else
    SpRetNo := 0;

  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin

    if (ret[RetNo].MarStatus = 6) // single
      or (ret[RetNo].MarStatus = 4) // divorced
      or ((ret[RetNo].MarStatus = 5) and (FetchElm(RetNo, 'INFO', 188) = '')) Or
      (GetSinNo(RetNo) = '') Or (GetSpouseSin(RetNo) = '') then
    begin
      For i := 1 to 45 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      SaveTv(RetNo, FName, FNo);
      exit;
    end;

    If UpperCase(Strings[34]) = 'Y' then
      Qualified := True
    else
      Qualified := False;
    If Qualified = False then
    begin
      for i := 1 to 41 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      SaveTv(RetNo, FName, FNo);
      exit;
    end;

    Strings[43] := GetFirstName(RetNo);
    Strings[44] := GetSinNo(RetNo);

    Tv[39] := vl(FetchElm(RetNo, 'PNSDED', 3));
    If SpRetNo > 0 then
      Tv[48] := vl(FetchElm(SpRetNo, 'PNSDED', 3))
    else
    begin
      // If Strings[45]>'' then Tv[48]:=Tv[10]; causes problems
    end;

    Strings[46] := GetSpouseFirstName(RetNo);

    Strings[47] := GetSpouseSinNo(RetNo);
    If Strings[42] > '' then
    begin
      PensionerRetNo := GetRetNoFromSin(Strings[44]);
      TransfereeRetNo := GetRetNoFromSin(Strings[47]);
    end
    else
    begin
      If Strings[45] > '' then
        PensionerRetNo := GetRetNoFromSin(Strings[47]);
      TransfereeRetNo := GetRetNoFromSin(Strings[44]);
    end;

    // 20170305
    If TransfereeRetNo > 0 then // reciving spouse
    Begin
      Strings[6] := GetLastName(TransfereeRetNo);
      Strings[7] := GetFirstName(TransfereeRetNo);
      Strings[58] := FetchElm(SpRetNo, 'INFO', 15);
    End;

    If ret[RetNo].CouplingSw then
    begin
      If (PensionerRetNo = 0) or (TransfereeRetNo = 0) then
      begin
        for i := 1 to 33 do
        begin
          Strings[i] := '';
          Tv[i] := 0;
        end;
        for i := 35 to 41 do
        begin
          Strings[i] := '';
          Tv[i] := 0;
        end;
        SaveTv(RetNo, FName, FNo);
        exit;
      end;
    end;

    // Step 1
    // pensioner
    // Strings[1] := AppYear;  //20170118
    If PensionerRetNo > 0 then
    begin
      Strings[2] := GetLastName(PensionerRetNo); // FetchElm(RetNo,'INFO',5);
      Strings[3] := GetFirstName(PensionerRetNo); // FetchElm(RetNo,'INFO',2);
      Strings[4] := GetSinNo(PensionerRetNo); // FetchElm(RetNo,'INFO',3);
      // 20170204
      Strings[5] := FetchElm(PensionerRetNo, 'INFO', 6) // str
        + ' ' + FetchElm(PensionerRetNo, 'INFO', 22) // apartm
        + ' ' + FetchElm(PensionerRetNo, 'INFO', 68) // po box
        + ' ' + FetchElm(PensionerRetNo, 'INFO', 163) // RR
        + ', ' + FetchElm(PensionerRetNo, 'INFO', 10) // city
        + ', ' + FetchElm(PensionerRetNo, 'INFO', 14); // prov
      // +' '+ FetchElm(PensionerRetNo,'INFO',15);
      Strings[57] := FetchElm(PensionerRetNo, 'INFO', 15); // 20130127
    end;

    If TransfereeRetNo > 0 then
    begin
      // 20170204
      Strings[8] := FetchElm(TransfereeRetNo, 'INFO', 6) // str
        + ' ' + FetchElm(TransfereeRetNo, 'INFO', 22) // apartm
        + ' ' + FetchElm(TransfereeRetNo, 'INFO', 68) // po box
        + ' ' + FetchElm(TransfereeRetNo, 'INFO', 163) // RR
        + ', ' + FetchElm(TransfereeRetNo, 'INFO', 10) // city
        + ', ' + FetchElm(TransfereeRetNo, 'INFO', 14);
      If Strings[8] = Strings[5] then
        Strings[8] := ''; // 20170204
      Strings[58] := FetchElm(TransfereeRetNo, 'INFO', 15); // 20130127

      Strings[9] := GetSinNo(TransfereeRetNo);
      // Step 2
    end;

    If PensionerRetNo > 0 then
    begin
      If UpperCase(Strings[65]) <> 'Y' then // 20151120
        Tv[10] := vl(FetchElm(PensionerRetNo, 'PNSDED', 3));
      Tv[33] := TotMultiple(PensionerRetNo, 'T4A', 101); //20220108  // 20181125//TotMultiple(PensionerRetNo, 'T4A', 88); // 20181125
      If (MarStatusChanged(PensionerRetNo)) or (IsDeceased(PensionerRetNo)) then
        // warning
      else
      begin
        If Strings[11] = '' then
          Strings[11] := '12';
        If Strings[31] = '' then
          Strings[31] := '12';
      end;
    end;

    If Strings[11] = '' then
      Strings[11] := '12';
    If Strings[31] = '' then
      Strings[31] := '12';

    If IsSpouseDeceased(PensionerRetNo) then
    begin
      If UpperCase(Strings[49]) <> 'Y' then // 20120129
      Begin
        Strings[11] := IntToStr(GetMonthsForPensionSplit(PensionerRetNo,TransfereeRetNo)); // 20120129
      end;
    end;

    // Tv[33]:=?  It could be from T4A box 128 //20220108
    Tv[66] := MaxR(0, Tv[10] - Tv[33]); // 20181123


    if (PensionerRetNo>0) then //And (TransfereeRetNo>0 then
    Begin
     If ret[PensionerRetNo].Age >= 65 then
     Begin
       Tv[59] := TotMultiple(PensionerRetNo, 'T4ARCA', 2); // 20140115
       Tv[60] :=Threshold; //119,700; // Tv[33];  //20230312
       Tv[67] := Tv[66]; //Tv[59] + Tv[60];
       Tv[62]:= MaxR(0, Tv[60]- Tv[67]);
       Tv[68]:= Tv[62]; //MaxR(0, Threshold - Tv[66]); // 20230123
       Tv[61] := MinR(Tv[59], Tv[68]);//MinR(Tv[67], Tv[68]);
     End
     Else
     Begin
       Tv[59] :=0;
       Tv[60] :=Threshold; //119,700; // Tv[33];  //20230312
       Tv[67] :=0;
       Tv[62]:= 0;
       Tv[68]:= 0;
       Tv[61]:= 0;
     End;
    End;

  //===================================================


    If Tv[33]=Tv[33] then //if Vl(FetchElm(PensionerRetNo,'T1032',59))>0 then //if veteran benefits //20230316
    Begin
      Tv[85]:=Tv[33];
      Tv[78]:=Tv[66];
      Tv[79]:=Tv[61];
      Tv[80]:=Tv[78]+Tv[79];
      Tv[81]:=Threshold;
      Tv[82]:=Tv[80];
      Tv[83]:=MaxR(0,Tv[81]-Tv[82]);
      Tv[84]:=MinR(Tv[85],Tv[83]);
    End
    Else
    Begin
     Tv[85]:=0;
     for i:=78 to 84 do begin Tv[i]:=0;end;
    End;
    Tv[86]:=Tv[66]+Tv[61]+Tv[84];  //20230313

    If vl(Strings[11]) > 12 then Strings[11] := '12';
    If vl(Strings[31]) > 12 then Strings[31] := '12';
    If vl(Strings[11]) > vl(Strings[31]) then  Strings[11] := Strings[31];
    Tv[12] := tv[86]; //Tv[62]; // 201309922
    If (vl(Strings[11]) > 0) and (vl(Strings[31]) > 0) then
      Tv[13] := (vl(Strings[11]) / vl(Strings[31])) * Tv[12]
    else
      Tv[13] := 0;
    Tv[14] := Tv[13];
    If Tv[13] > 0 then
      Tv[14] := Tv[13]
    Else
      Tv[14]:=Tv[86];  //20230312
    Strings[15] := '50';
    Tv[16] := Tv[14] * vl(Strings[15]) / 100;

    // pensioner
    If Qualified then
    begin
      If UpperCase(Strings[42]) > '' then
      begin
        If Strings[43] = FetchElmFNo(RetNo, OptimizeFNo, 40) then
        // match by first name
        begin
          StoreElm(RetNo, OptimizeFNo, 24, Strings[32]);
          StoreElm(RetNo, OptimizeFNo, 35, '');
        end
      end
      else
      begin
        StoreElm(RetNo, OptimizeFNo, 35, Strings[32]);
        StoreElm(RetNo, OptimizeFNo, 24, '');
      end;
    end;
    // ste p 3
    If vl(Strings[32]) > 50 then Strings[32] := '50';   //%

    If Strings[38] <> 'Y' then
      Tv[17] := Tv[14] * vl(Strings[32]) / 100;       //x split %

    if Tv[17]>Tv[16] then Tv[17]:=Tv[16];

   {//20230403
    if (IsForRefile(RetNo)) and (vl(FetchElm(RetNo, 'REFILEQ', 105)) > 0)
    // 20190522
    then
    Begin
      Strings[38] := 'Y';    //105=11600  and 106=21000
      Tv[17] := MaxR(vl(FetchElm(RetNo, 'REFILEQ', 105)),
        vl(FetchElm(RetNo, 'REFILEQ', 106)))
    End;
  }
    // step 4

    // Pensioner
    // 20190312 Calc j again

    Tv[18]:=Tv[10];
    If Tv[61]=Tv[61] then //if Tv[61] > 0 then // line 8  //20230316
    //20220108
    Begin
     Tv[1]:=Tv[17];
     Tv[69]:=Tv[61];
     Tv[70]:=tv[86]; //Tv[60];    //20220109
     if Tv[70]<=0 then
        Strings[73]:='0.00000'
     Else
        Strings[73]:=FormatFloat('##0.00000',Tv[69]/Tv[70]);
     Tv[74]:=Tv[17];
     Tv[75]:=Vl(Strings[73]) * Tv[74];
     Tv[76]:=Tv[75];
     Tv[77]:=MaxR(0,Tv[1]-Tv[76]);
     Tv[87]:=Tv[77];
     Tv[20]:=Tv[18]-Tv[87];
    End;

    //------------------------------------------
    // Transferee
    If TransfereeRetNo > 0 then
      Tv[21] := vl(FetchElm(TransfereeRetNo, 'PNSDED', 3));
    If (TransfereeRetNo > 0) and (ret[TransfereeRetNo].Lnn[11500] = 0) and
      (ret[TransfereeRetNo].Lnn[12900] = 0) then
      Tv[21] := 0;
    If UpperCase(Strings[50]) <> 'Y' then
      Tv[22] :=tv[87]; // Tv[17]; // ??? NOTE?
    Tv[23] := MaxR(0, Tv[21] + Tv[22]);
    // step 5
    FromT4a := 0;
    FromT4Rif := 0;
    FromT4RSP := 0;
    FromT4ARCA := 0;
    If PensionerRetNo > 0 then
    begin
      TaxDeductedForEligiblePension(PensionerRetNo, FromT4a, FromT4Rif,
        FromT4RSP, FromT4ARCA);
      Tv[35] := FromT4a;
      Tv[36] := FromT4Rif;
      Tv[37] := FromT4RSP;
      Tv[64] := FromT4ARCA; // visible non printable
    end;
    Tv[41] := Tv[35] + Tv[36] + Tv[37] + Tv[40] + Tv[64]; //Tv[63]; // 20230315
    If PensionerRetNo > 0 then
    begin
      If UpperCase(Strings[65]) <> 'Y' then // 20151120
        Tv[24] := Tv[41];
    end;
    Tv[25] := Tv[24];
    Tv[26] := Tv[17];
    Tv[27] := tv[86]; //Tv[62]; // Tv[10];  //20131209
    If Tv[27] > 0 then
      Tv[28] := Tv[25] * Tv[26] / Tv[27]
    else
      Tv[28] := 0;

    // 20130124  ??
    If Strings[42] > '' then // pensioner
    begin
      Tv[51] := GetTotalTaxDeducted(RetNo); // Tv[24];  //20130127
      Tv[52] := Tv[28];
      Tv[53] := MaxR(0, Tv[51] - Tv[52]);
      Tv[54] := 0;
      Tv[55] := 0;
      Tv[56] := 0; // 20130127
    End
    Else if Strings[45] > '' then // transferee
    begin
      Tv[54] := GetTotalTaxDeducted(RetNo);
      Tv[55] := Tv[28];
      Tv[56] := Tv[51] - Tv[52];
      Tv[51] := 0;
      Tv[52] := 0;
      Tv[53] := 0; // 20130127
    End;

    // ??
    Tv[56] := Tv[54] + Tv[55];

    // Step 6
    If Strings[29] = '' then
      Strings[29] := FormatDateTime('yyyy-mm-dd', Date);
    If Strings[30] = '' then
      Strings[30] := FormatDateTime('yyyy-mm-dd', Date);

  end;
 SaveTv(RetNo, FName, FNo);
end;

//jz//20260413//CCAv7 - cleaned up comments
//**** NOTE **** same as from assetsb , any time there is a change in either the other should change as well
Procedure Autos(RetNo: integer; FName: string; FNo: integer);
const
  //jz//20260405 - add col vars
  Col1 =134;Col2 =191;Col3 =158;Col4 =44;Col5 =18;Col6 =24;Col7 =46;Col8 = 47;Col9 = 26;Col10= 49;Col11=50;
  Col12= 12;Col13= 27;Col14= 52;Col15=53;Col16=15;Col17=14;Col18=30;Col19=167;Col20=170;Col21=173;Col22=176;
  Col21Claimed=65; Col21Tloss=20;Col21Recapt=21;
  Col22T776=59;Col23T776=61;col24T776=62; //jz//20260409//CCAv3 - add col vars for T776
  Col23T776Claimed=67;
Var
  ss:string;
  i, MaxBusDays, BusDays: integer;
  cls:string;
  FInst: String[4];
  Aiipfactor, Riipfactor: Real; //CCAv6//jz//20260406 // 20190215
  k, Gst, Pst: Real;
  Line5K, Line6K, Line7K: Real;
  Yr: String[4];
  TotalDays, DaysBeforeJuly1, DaysAfterJuly1: integer;
  StartLease, ENdLease: String;
  MaxCCA: Real;
  BusPercent: Real;
  //20230417
  IsClassEmpty,AiipEligible,DiepEligible:Boolean; //jz//CCAv6
  col22override:integer; //CCAv11


  AlocToT776:boolean;
  usagePercent:real;      //jz//CCAv5
  fromAssetsB : boolean;  //jz//CCAv5

        procedure calcBusinessUseMaxCCA();
        var allowableCCA:real;
        begin
          with Ret[RetNo].Frm[FNo] do
          begin
            Tv[93]:=0; //max based on the KM used for business
            //jz//20260405
            //CCAv5 - if is assestsb is personal usage, if autos is km for business use
            if fromAssetsB then  usagePercent := (100 - vl(Ret[RetNo].Frm[FNo].Strings[4]))/100
                           else  usagePercent := vl(Ret[RetNo].Frm[FNo].Strings[4]) / vl(Ret[RetNo].Frm[FNo].Strings[7]);

            //jz//20260405 - have the KM prorated CCA based the overriden value, not instead of it
            allowableCCA := Tv[col21]     * usagePercent;
            Tv[93] := allowableCCA;

            allowableCCA := Tv[Col23T776] * usagePercent;
            Tv[64] := allowableCCA;

            //jz//20260417//CCAv9 put back override - this should be removed for next year
            if strings[206] > '' then  //CCAv11 - must keep as X box // changed to y/n box
            begin
              Tv[93] := Tv[177];
              Tv[64] := Tv[177];
            end;
          end;
        end;

        procedure calcMaxDays();
        begin
            //Prorate
            MaxBusDays := 0;

            If Ret[RetNo].Frm[FNo].Tv[216] > 0 then
            begin
              If CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[215]) > MaxBusDays then
                MaxBusDays := CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[215]);
            end;
            If Ret[RetNo].Frm[FNo].Tv[222] > 0 then
            begin
              If CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[221]) > MaxBusDays then
                MaxBusDays := CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[221]);
            end;
            If Ret[RetNo].Frm[FNo].Tv[228] > 0 then
            begin
              If CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[227]) > MaxBusDays then
                MaxBusDays := CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[227]);
            end;
        end;

Begin

  fromAssetsB := pos('ASSETSB',uppercase(fname)) > 0;

  // ConvertOldAutoExpDates(RetNo,FNo);
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    //jz//CCAv6 - default to Y on whether to post assets to bus statements
    if (fromAssetsB) and (strings[10]='') then strings[10]:='Y';


    Tv[2]   := Tv[216] + Tv[222] + Tv[228];
    Tv[11]  := Tv[219] + Tv[225] + Tv[231];

    If Strings[129] = '' then
      Strings[129] := 'Business Parking Fees';
    If Strings[130] = '' then
      Strings[130] := 'Supplementary Business Insurance';


    if fromAssetsB then
      Strings[4] := FormatFloat('###.##', maxR(0, minR(100,vl(Strings[4])) ))  //jz//CCAv5
    else
    begin
      If (vl(Strings[4]) = 0) and (vl(Strings[7]) = 0) then //make sure km usage is not zeros
        begin Strings[4] := '1'; Strings[7] := '1'; end;
      If vl(Strings[7]) < vl(Strings[4]) then               //make sure business km usage is not more than total usage
        Strings[7] := Strings[4];
    end;


    //CHART C - Lease ========================================================
    Yr := LeftStr(Strings[57], 4);
    StartLease := Strings[57];
    ENdLease := Strings[60];
    If (StartLease > '') and (ENdLease > '') then
      TotalDays := DateDiff(YMDtoDate(StartLease), YMDtoDate(ENdLease));
    DaysBeforeJuly1 := DateDiff(YMDtoDate(StartLease),
      YMDtoDate(MinString('2006-07-01', ENdLease))); // 20160119 Igor
    DaysAfterJuly1 := DateDiff(YMDtoDate(MaxString('2006-07-01', StartLease)),
      YMDtoDate(ENdLease)); // 20160119 Igor

    If DaysBeforeJuly1 < 0 then
      DaysBeforeJuly1 := 0;
    If DaysAfterJuly1 < 0 then
      DaysAfterJuly1 := 0;
    Line5K := GetLine5K(Yr);
    Gst := Line5K * Tv[126] / 100;
    Pst := Line5K * vl(Strings[63]) / 100;
    If Yr < '1991' then
    begin
      Gst := 0;
      Pst := 0;
    end;
    //-----------------------------------------------
   //removed by CZwhy?  20260329 if Tv[5]=0 then Tv[]:=Tv[75];  //20260329
    //if Tv[6]=0 then Tv[]:=Tv[75];  //20260329

    k := Line5K + Gst + Pst;

    Tv[78] := MaxR(k, Tv[75]) * 0.85;

    Line6K := GetLine6K(Yr);
    Gst := Line6K * Tv[126] / 100;
    Pst := Line6K * vl(Strings[63]) / 100;
    If Yr < '1991' then
    begin
      Gst := 0;
      Pst := 0;
    end;
    k := Line6K + Gst + Pst;
    Tv[81] := MaxR(0, ((k * Tv[72]) / 30) - Tv[69]);

    Line7K := GetLine7K(Yr);
    Gst := Line7K * Tv[126] / 100;
    Pst := Line7K * vl(Strings[63]) / 100;
    If Yr < '1991' then
    begin
      Gst := 0;
      Pst := 0;
    end;
    k := Line7K + Gst + Pst;
    If Tv[78] > 0 then
      Tv[84] := k * Tv[66] / Tv[78]
    else
      Tv[84] := 0;

    Tv[99] := MinR(Tv[81], Tv[84]);

    //Chart B - Interest =====================================================
    If Tv[109] = 0 then
      Tv[109] := 10;
    If vl(Strings[106]) = 0 then
      Tv[109] := 0;
    //20241217
    Tv[109]:=Tv[9]/30;

    Tv[112] := vl(Strings[106]) * Tv[109];
    Tv[115] := MinR(Tv[103], Tv[112]);

    { interest }
    If UpperCase(Strings[28]) <> 'Y' then
      Tv[19] := Tv[115];

    { Lease }
    If UpperCase(Strings[29]) <> 'Y' then
      Tv[16] := Tv[99];

    //Chart A - expenses =====================================================
    Tv[42] := Tv[10] + Tv[19] + Tv[22] + Tv[25] +
                  Tv[13] + Tv[16] + Tv[43] + Tv[32] + Tv[36];   //20210301
    If vl(Strings[7]) > 0 then
      Tv[45] := Tv[42] * (vl(Strings[4]) / vl(Strings[7]))
    else
      Tv[45] := 0;
    Tv[54] := MaxR(0, Tv[45] + Tv[48] + Tv[51]);

  end; //with

  //If Tv[109] = 0 then Tv[109] := 10; // 20241217


  //=========AUTOS CCA ==========================================================
  //cca
  with Ret[RetNo].Frm[FNo] do
  begin
   //20230521
   //20230502
   Cls:=Ret[RetNo].Frm[FNo].Strings[134];  //class

   //jz//CCAv5 move cls='12' condition and changed date '/' to '-' '2018/11/20' then
   if (Ret[RetNo].Frm[FNo].Strings[137]>'2018-11-20') and (trim(cls)<>'12') then
   Begin
    Ret[RetNo].Frm[FNo].Strings[55]:='X';  //aiip
    AiipEligible:=True;
   End
   Else
   Begin
    Ret[RetNo].Frm[FNo].Strings[55]:='';
    AiipEligible:=False;
   End;

   //20230516
   If (Ret[RetNo].Frm[FNo].Strings[6]='') or (UpperCase(Ret[RetNo].Frm[FNo].Strings[6])='X')
   then //ok
   Else Ret[RetNo].Frm[FNo].Strings[6]:='';

   //jz//CCAv6 //20260413
   if Strings[6]>'' then IsClassEmpty:=true
                    else IsClassEmpty:=false;

   //if Ret[RetNo].Frm[FNo].strings[55]>'' then Ret[RetNo].Frm[FNo].Strings[34]:='X'; //if aiip then halh year blank/exempt

   if Ret[RetNo].Frm[FNo].Strings[41]>'' then DiepEligible:=True else DiepEligible:=False; //20230515


   //AUTOS CCA New format with 22  //21 columns now
   // If IsDiepEligible(Cls,Ret[RetNo].Frm[FNo].Strings[137])=false then begin DiepEligible:=False;Ret[RetNo].Frm[FNo].Strings[41]:='';end; //20230515

    Strings[38]:=GetAiipFactor(Cls); //jz//20260406//CCAv2
    Strings[58]:=GetRiipFactor(Cls); //jz//20260406//CCAv2

    //20230515
    if Tv[33]=Tv[40] then Tv[33]:=0; //if cost = AiiFactor then zero it out (error in restructioring with new format of CCA
    //20230429
    Tv[152]:=Tv[143] * Tv[197]/100;
    Tv[155]:=Tv[143] * Tv[200]/100;
    Tv[56]:=MaxR(0,Tv[143]+Tv[152]+Tv[155]-Tv[39]); //jz//20260406//CCAv2

    Tv[col3]:=Tv[56];  //jz//20260406//CCAv2 158  //20230519

    //COLUMNS
    if diepEligible=true then //Ret[RetNo].Frm[FNo].Strings[43]>'' then //diep eligible //20230423
    begin
     if Tv[Col4]=0 then begin Tv[col4]:=Tv[Col3];Tv[44]:=Tv[Col4];end;
     if Tv[Col4]>Tv[col3] then begin Tv[Col4]:=Tv[Col3];Tv[44]:=Tv[Col3];End;
    end
    Else
     Tv[Col4]:=0;

    If Tv[Col5]=0 then Tv[Col6]:=0;  //User if no diep then no dispos of diep //20230516
    Tv[col7]:=Tv[col2]+Tv[Col3]-Tv[col5];
    Tv[col8]:=MaxR(0,Tv[col4]-Tv[col6]);

    If DiepEligible=false then Tv[col9]:=0; //useer?/ immediate expensing
    if Tv[Col9]>1500000 then Tv[col9]:=1500000;

    Tv[col10]:=Tv[col3]-Tv[col9]; //MaxR(0,Tv[col3]-Tv[col4]+Tv[col8]-Tv[col9]);
    Tv[col11]:=Tv[50]; //user
    Tv[col12]:=Tv[12];  //manual MaxR(0,Tv[col7]-Tv[col9]);
    Tv[col13]:=MaxR(0,Tv[col7]-Tv[col9]) ; //-Tv[col10]+Tv[col11]);   //??? //MaxR(0,Tv[col5]-Tv[col6]-Tv[col10]+Tv[col11]);   //???
    Tv[Col14]:=MaxR(0,Tv[col5]-TV[Col10]+Tv[Col11]+Tv[Col12]); //*AiipFactor); //MaxR(0,(Tv[col11]-Tv[col13])*AiipFactor);
    Tv[Col15]:=MaxR(0,(Tv[col11]-Tv[col14]))*Vl(Strings[38]); //factor)   //-Tv[col11]-Tv[col5])*(1/2)) //20230411  //Tv[Col15]:=MaxR(0,(Tv[col10]+Tv[col6]-Tv[col11]-Tv[col5])*(1/2)) //20230411
    Tv[Col16]:=MaxR(0,Tv[col14]-Tv[col11]); //jz//20260424 - wrong cols //MaxR(0,Tv[col12]-Tv[col14]); //Factor 2??
    Tv[Col17]:=MaxR(0,Tv[col12]-Tv[col16])* Vl(strings[58]); //jz//20260405 - form wrong, fix col16 not col14

    if (Strings[34]='') and //not exempt half-year rule
       (Tv[col3]>0)         //jz//20260406//CCAv2 - there are current year adjustments
    then Tv[Col18]:=maxr(0,(Tv[Col10]-Tv[col11]-Tv[col12]-Tv[Col5])* (1/2) )  //jz//20260424 - add maxr for no negative
    else Tv[Col18]:=0;

    Tv[Col19]:=Tv[Col13]+Tv[col15]+Tv[Col17]-Tv[col18];     //jz//20260405 - form wrong, fix - +Tv[Col16]-Tv[col17];

    Ret[RetNo].Frm[FNo].Strings[col20]:=GetCCARate(Cls); //20260405

    Tv[col21] := (tv[col19] * (vl(strings[col20])/100)) + tv[col9];   //jz//20260406//CCAv2 - no more override, strait to col21 instead of 177 first  //jz//20260405 - as per changed form

    //jz//20260420 - NOTE **** adding the claim, overrides and moving elms messes up order, re assign both 'claimed' and last cols here after Override
    //               Tv[col21Claimed] Tv[col23T776Claimed] Tv[col22] Tv[col24T776] re assigned at end as well

    //If not(overrideCCA) then Tv[Col21]:=Tv[177];  //if not override apply amount //jz//20260406//CCAv2

    Tv[col21Claimed] := Tv[8]; //CCAv11 - total amount claimed
    if fromAssetsB  then col22override := 28
                    else col22override := 23;
    //if Strings[col22override]='' then //CCAv11 - put override back  //jz//20260406//CCAv2 - no more col 22 override
    Tv[col22]     := maxR(0,Tv[col7]-Tv[col21Claimed]); //jz//CCAv11 - TV[col21]); //jz//20260407//CCAv2 - cannot be neg - change as per form //Tv[Col19]-TV[177];
    //============== ending ucc =================================================
    //jz//20260409 - add for T776
    // T776 CHART B begin ======================================================
    strings[588] := strings[col1]; //set same cls
    i := 492; //Tv[427] := 0; //Repeat
      if (strings[i + 1] > '') and (strings[i + 1] <> '0') then
        Tv[i + 2] := Tv[i - 1] * Vl(strings[i]) / Vl(strings[i + 1])
      else
        Tv[i + 2] := 0;
    // T776 CHART B end ========================================================

    Tv[col22T776] := maxR(0,Tv[494]);
    Tv[col23T776] := maxR(0,Tv[col21] - TV[col22T776]);
    Tv[col23T776Claimed] := Tv[8]; //CCAv11 - total amount claimed
    Tv[col24T776] := maxR(0,Tv[col7]  - TV[col23T776Claimed]); //jz//CCAv11 - TV[col23T776]);

    //------------- Summarize on the top summary  -----------------------------

   //Init some totals
    Tv[90]          :=0;  //Tot Expense fot each auto
    Tv[Col21Tloss]  :=0;  //Terminal loss [20]
    Tv[Col21Recapt] :=0;  //Recapture [21]

    calcBusinessUseMaxCCA();
    ////jz//20260405 - calcBusinessUseCCAmax based on KM used for business is done above
    //               - if is assetsb, calcs personal use
    //                 there is repittion here of calculating milage max why???

    //find cca for each business statement
    //20230519
    Tv[90] := Tv[54]; //jz//20260410//CCAv4 - move to before to be populated for b% prorated calc
    Tv[8]:=0; //total CCA takem add up all business //20230610
    //CCAv9 - clears override field that were removed before me
    //    for i:=233 to 235 do Ret[RetNo].Frm[FNo].Strings[i]:=''; //*** NO override allowed here
    i := 215;  //pick it up from tv[173]  = total cca for all
    Repeat
        If (Ret[RetNo].Frm[FNo].Strings[i]   > '')   and
           (Ret[RetNo].Frm[FNo].Strings[i+1] > '')
        then
        begin
          BusDays := CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[i]);
          calcMaxDays();
          If MaxBusDays > 0 then
          Begin
            Tv[i + 2] := Tv[90] * Tv[i + 1] / 100; //jz//20260410//CCAv4

            //jz//20260409//CCAv3
            if pos('T776',strings[i]) = 0 then
              Tv[i + 3] := Tv[93] * (Tv[i + 1] / 100) * BusDays / MaxBusDays
            else
            begin
              Tv[i + 3] := Tv[64] * (Tv[i + 1] / 100) * BusDays / MaxBusDays;
              AlocToT776 := true                   //jz//20260410//CCAv4
            end;

            Tv[8]:=Tv[8]+Tv[i+3]; //20230716
          End; //end max days
        end
        Else
        begin
          Tv[i + 2] := 0;
          Tv[i + 3] := 0;
        end;
        Inc(i, 6);
    until i > 227;

    if not AlocToT776 then tv[64] := 0; //jz//20260410//CCAv4 if no alocation to 776 then make zero

    //jz//20260421//CCAv12  - adding the claim and moving elms messes up order, re assign both 'claimed' and last cols here after Override
    //                      - move before Terminal loss or Recapture
    Tv[col21Claimed]      := Tv[8];
    Tv[col23T776Claimed]  := Tv[8];
    Tv[col22]             := maxR(0,Tv[col7]-Tv[col21Claimed]); //put back original //20260602 //maxR(0,Tv[col7]-Tv[173]);
    Tv[col24T776]         := maxR(0,Tv[col7]-TV[col23T776Claimed]); // //put back original //20260602 //-TV[173]);

    //Terminal loss or Recapture begin =======================================
    If IsClassEmpty then //jz//CCAv6 //(Ret[RetNo].Frm[FNo].Strings[6] > '') then //class empty
    begin
      if Cls='10.1' then  //no term loss or recapture
      Begin
        Tv[Col21Tloss] :=0;
        Tv[Col21Recapt]:=0;
      end
      else
      begin
        //jz//20260421//CCAv12  - clear regardless of if Terminal loss or Recapture
        Tv[93]:=0; Tv[218]:=0;Tv[224]:=0;Tv[230]:=0;Tv[8]:=0;  //20240309 NO CCA amounts
        Tv[64]:=0; //jz//20260412//CCAv5 - clear T776 CCA amount also

        Tv[col21Claimed]      := 0; //jz//20260421//CCAv12  - clear the claim as well as due to code order won't recalc
        Tv[col23T776Claimed]  := 0;

        If Tv[Col7]<0 then  //IF Recapture //20230501
        begin   //ucc + additions < UCC after dispositions then recapturoe
          Tv[Col21Recapt] := ABS(Tv[Col7]) * usagePercent; //jz//CCAv5 //(Vl(Ret[RetNo].Frm[FNo].Strings[4])/Vl(Ret[RetNo].Frm[FNo].Strings[7])); //prorate by km use//20240309
          //Tv[Col21]    := 0; // max cca  //jz//202604006//CCAv2 - change to col21 from 177 but not in use anymore anyway
          Tv[Col15]      := 0;   //jz//202604006//CCAv2 - still col15????????????????
          Tv[Col16]      := 0;   //Term loss //jz//202604006//CCAv2 -  chnge to Col19 from Col16
          Tv[Col21]      := 0;   //CCA  //jz//202604006//CCAv2 - change to col21 from col8

          Strings[col20]  := '';  //Rate //jz//202604006//CCAv2 - change to col20 from col17
          Tv[Col21Tloss]  := 0;   //jz//202604006//CCAv2 - change to Col21Tloss from 20
        end
        else    //IF Terminal loss
        begin
          Tv[Col21Tloss] := ABS(Tv[Col7]) * usagePercent; //jz//CCAv5 //(Vl(Ret[RetNo].Frm[FNo].Strings[4])/vl(Ret[RetNo].Frm[FNo].Strings[7]));   //prorate km //20230309

          Tv[col21]       :=0; //Tv[173] := 0; //jz//202604006//CCAv2 - change to col21 from col8
          Tv[col22]       :=0; //Tv[167] := 0; // base amount  //jz//202604006//CCAv2 - change to col22 from col9
          Tv[col23T776]   :=0; //jz//20260412//CCAv5 - clear T776 CCA amounts also - not sure this is rigght, how does col223T776 get handled??
          Tv[col24T776]   :=0; //jz//20260412//CCAv5 - clear T776 CCA amounts also
          Tv[col21Recapt] :=0; //recapture //jz//202604006//CCAv2 - change to col21-Recapt from 21
          Strings[col20]  := '';  //Rate //jz//202604006//CCAv2 - change to col20 from col17 / [170]
          Tv[col22]       :=0; //Tv[176] := 0; //ending ucc 21 //jz//202604006//CCAv2 - change to col22 from 21 which was actually wrong
        end;
      end;
    end;
    //Terminal loss or Recapture end =========================================

  end; //with cca

  SaveTv(RetNo, FName, FNo); //20230501 Igor
end; //end Procedure Autos



//20260403
//20230515
(*
Procedure Autos(RetNo: integer; FName: string; FNo: integer);
const
  //jz//20260405 - add col vars
  Col1 =134;Col2 =191;Col3 =158;Col4 =44;Col5 =18;Col6 =24;Col7 =46;Col8 = 47;Col9 = 26;Col10= 49;Col11=50;
  Col12= 12;Col13= 27;Col14= 52;Col15=53;Col16=15;Col17=14;Col18=30;Col19=167;Col20=170;Col21=173;Col22=176;
  Col21Tloss=20;Col21Recapt=21;
  Col22T776=59;Col23T776=61;col24T776=62; //jz//20260409//CCAv3 - add col vars for T776
Var
  ss:string;
  i, MaxBusDays, BusDays: integer;
  cls:string;
  FInst: String[4];
  Aiipfactor, Riipfactor: Real; //CCAv6//jz//20260406 // 20190215
  k, Gst, Pst: Real;
  Line5K, Line6K, Line7K: Real;
  Yr: String[4];
  TotalDays, DaysBeforeJuly1, DaysAfterJuly1: integer;
  StartLease, ENdLease: String;
  { StmList:TStringList; } MaxCCA: Real;
  BusPercent: Real;
  //20230417
  IsClassEmpty,AiipEligible,DiepEligible:Boolean; //jz//CCAv6
  //Col1,Col2,Col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,col22:Integer;
  //overrideCCA:boolean; //jz//20260406//CCAv2

  allowableCCA:real;
  AlocToT776:boolean;
  usagePercent:real;      //jz//CCAv5
  fromAssetsB : boolean;  //jz//CCAv5
        procedure calcBusinessUseMaxCCA();
        begin
          with Ret[RetNo].Frm[FNo] do
          begin
            Tv[93]:=0; //max based on the KM used for business
            //jz//20260405
            //allowableCCA := Tv[col19] * (vl(Ret[RetNo].Frm[FNo].Strings[Col20])/100);   //usage Tv[93]:= Tv[col16] * (vl(Ret[RetNo].Frm[FNo].Strings[Col17])/100);   //usage
            //allowableCCA := allowableCCA  * vl(Ret[RetNo].Frm[FNo].Strings[4]) / vl(Ret[RetNo].Frm[FNo].Strings[7]);  //mileage //20230716

            //Tv[177]:= allowableCCA; //MaxCCA based on mileage //jz//20260405 - remove override check as changed override to 173 //If Ret[RetNo].Frm[FNo].Strings[206] = '' then
            {if overrideCCA then Tv[93] := Tv[col21] //then it is whatever the override is
            else                Tv[93] := allowableCCA;
            }

            //CCAv5 - if is assestsb is personal usage, if autos is km for business use
            if fromAssetsB then  usagePercent := (100 - vl(Ret[RetNo].Frm[FNo].Strings[4]))/100
                           else  usagePercent := vl(Ret[RetNo].Frm[FNo].Strings[4]) / vl(Ret[RetNo].Frm[FNo].Strings[7]);

            //jz//20260405 - have the KM prorated CCA based the overriden value, not instead of it
            allowableCCA := Tv[col21]     * usagePercent;
            Tv[93] := allowableCCA;

            allowableCCA := Tv[Col23T776] * usagePercent;
            Tv[64] := allowableCCA;

          end;
        end;

        procedure calcMaxDays();
        begin
            //Prorate
            MaxBusDays := 0;
            If Ret[RetNo].Frm[FNo].Tv[216] > 0 then
              MaxBusDays := CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[215]);
            If Ret[RetNo].Frm[FNo].Tv[222] > 0 then
            begin
              If CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[221]) > MaxBusDays then
                MaxBusDays := CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[221]);
            end;
            If Ret[RetNo].Frm[FNo].Tv[228] > 0 then
            begin
              If CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[227]) > MaxBusDays then
                MaxBusDays := CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[227]);
            end;
        end;

Begin

  fromAssetsB := pos('ASSETSB',uppercase(fname)) > 0;
  // ConvertOldAutoExpDates(RetNo,FNo);
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    //overrideCCA := (strings[206] = 'X'); //jz//20260406//CCAv2 - override checkbox removed
    {//20260403 CZ  Why we have the following:
    Strings[3] := GetFirstName(RetNo);
    Strings[5] := GetSpouseFirstName(RetNo);
    Strings[9] := GetFirstName(RetNo);
    }
    //jz - already does this more comprehensively below ??
    {
    i := 216;
    Repeat
      If Strings[i + 4] > '' then
        Tv[i] := 0;
      If Tv[i] > 100 then Tv[i] := 100;
     // If Strings[i - 1] = '' then Tv[i] := 0; // no statement //20230717 allow % with no statement
      If Strings[i + 4] = '' then // no partner
      begin
        If IsSharedStatement(RetNo, Strings[i - 1]) then
          Tv[i + 3] := Tv[i];
      end;
      Tv[i + 1] := Tv[i] * Tv[90] / 100;
      if pos('T776',strings[i-1]) > 0 then Tv[i + 2] := Tv[i] * Tv[64] / 100
                                      else Tv[i + 2] := Tv[i] * Tv[93] / 100;
      Inc(i, 6);
    until i > 228;
    }

    //jz//CCAv6 - default to Y on whether to post assets to bus statements
    if (fromAssetsB) and (strings[10]='') then strings[10]:='Y';
    Tv[2] := Tv[216] + Tv[222] + Tv[228];
    Tv[11] := Tv[219] + Tv[225] + Tv[231];

    If Strings[129] = '' then
      Strings[129] := 'Business Parking Fees';
    If Strings[130] = '' then
      Strings[130] := 'Supplementary Business Insurance';

    if fromAssetsB then
      Strings[4] := FormatFloat('###.##', maxR(0, minR(100,vl(Strings[4])) ))  //jz//CCAv5
    else
    begin
      If (vl(Strings[4]) = 0) and (vl(Strings[7]) = 0) then //make sure km usage is not zeros
        begin Strings[4] := '1'; Strings[7] := '1'; end;
      If vl(Strings[7]) < vl(Strings[4]) then               //make sure business km usage is not more than total usage
        Strings[7] := Strings[4];
    end;

    For i := 0 to 0 do
    begin
      //CCAv6   this is handled in calcMaxDays??
      {
      If vl(Strings[7 + i]) > 0 then
        Tv[122 + i] := Tv[119 + i] * usagePercent; //(vl(Strings[4 + i]) / vl(Strings[7 + i]))
      else
        Tv[122 + i] := 0;
      }

      //CHART C - Lease ========================================================
      Yr := LeftStr(Strings[57 + i], 4);
      StartLease := Strings[57 + i];
      ENdLease := Strings[60 + i];
      If (StartLease > '') and (ENdLease > '') then
        TotalDays := DateDiff(YMDtoDate(StartLease), YMDtoDate(ENdLease));
      DaysBeforeJuly1 := DateDiff(YMDtoDate(StartLease),
        YMDtoDate(MinString('2006-07-01', ENdLease))); // 20160119 Igor
      DaysAfterJuly1 := DateDiff(YMDtoDate(MaxString('2006-07-01', StartLease)),
        YMDtoDate(ENdLease)); // 20160119 Igor

      If DaysBeforeJuly1 < 0 then
        DaysBeforeJuly1 := 0;
      If DaysAfterJuly1 < 0 then
        DaysAfterJuly1 := 0;
      Line5K := GetLine5K(Yr);
      Gst := Line5K * Tv[126 + i] / 100;
      Pst := Line5K * vl(Strings[63 + i]) / 100;
      If Yr < '1991' then
      begin
        Gst := 0;
        Pst := 0;
      end;
      //-----------------------------------------------
     //removed by CZwhy?  20260329 if Tv[5]=0 then Tv[]:=Tv[75];  //20260329
      //if Tv[6]=0 then Tv[]:=Tv[75];  //20260329

      k := Line5K + Gst + Pst;

      Tv[78 + i] := MaxR(k, Tv[75 + i]) * 0.85;

      Line6K := GetLine6K(Yr);
      Gst := Line6K * Tv[126 + i] / 100;
      Pst := Line6K * vl(Strings[63 + i]) / 100;
      If Yr < '1991' then
      begin
        Gst := 0;
        Pst := 0;
      end;
      k := Line6K + Gst + Pst;
      Tv[81 + i] := MaxR(0, ((k * Tv[72 + i]) / 30) - Tv[69 + i]);

      Line7K := GetLine7K(Yr);
      Gst := Line7K * Tv[126 + i] / 100;
      Pst := Line7K * vl(Strings[63 + i]) / 100;
      If Yr < '1991' then
      begin
        Gst := 0;
        Pst := 0;
      end;
      k := Line7K + Gst + Pst;
      If Tv[78 + i] > 0 then
        Tv[84 + i] := k * Tv[66 + i] / Tv[78 + i]
      else
        Tv[84 + i] := 0;

      Tv[99 + i] := MinR(Tv[81 + i], Tv[84 + i]);
      //Chart B - Interest =====================================================

      If Tv[109 + i] = 0 then
        Tv[109 + i] := 10;
      If vl(Strings[106 + i]) = 0 then
        Tv[109 + i] := 0;
      //20241217
      Tv[109+i]:=Tv[9]/30;   //tv[9] ot tv[9+i]??

      Tv[112 + i] := vl(Strings[106 + i]) * Tv[109 + i];
      Tv[115 + i] := MinR(Tv[103 + i], Tv[112 + i]);

      { interest }
      If UpperCase(Strings[28]) <> 'Y' then
        Tv[19] := Tv[115];

      { Lease }
      If UpperCase(Strings[29]) <> 'Y' then
        Tv[16] := Tv[99];
      //Chart A - expenses =====================================================
      Tv[42 + i] := Tv[10 + i] + Tv[19 + i] + Tv[22 + i] + Tv[25 + i] +
        Tv[13 + i] + Tv[16 + i] + Tv[43] + Tv[32 + i] + Tv[36 + i];   //20210301
      If vl(Strings[7 + i]) > 0 then
        Tv[45 + i] := Tv[42 + i] * (vl(Strings[4 + i]) / vl(Strings[7 + i]))
      else
        Tv[45 + i] := 0;
      Tv[54 + i] := MaxR(0, Tv[45 + i] + Tv[48 + i] + Tv[51 + i]);
    end;
    //If Tv[109] = 0 then Tv[109] := 10; // 20241217
  end;

  //=========AUTOS CCA ==========================================================
  //cca
  with Ret[RetNo].Frm[FNo] do
  begin
   //20230521
   //20230502
   Cls:=Ret[RetNo].Frm[FNo].Strings[134];  //class

   //jz//CCAv5 move cls='12' condition and changed date '/' to '-' '2018/11/20' then
   if (Ret[RetNo].Frm[FNo].Strings[137]>'2018-11-20') and (trim(cls)<>'12') then
   Begin
    Ret[RetNo].Frm[FNo].Strings[55]:='X';  //aiip
    AiipEligible:=True;
   End
   Else
   Begin
    Ret[RetNo].Frm[FNo].Strings[55]:='';
    AiipEligible:=False;
   End;

   //20230516
   If (Ret[RetNo].Frm[FNo].Strings[6]='') or (UpperCase(Ret[RetNo].Frm[FNo].Strings[6])='X')
   then //ok
   Else Ret[RetNo].Frm[FNo].Strings[6]:='';

   //jz//CCAv6 //20260413
   if Strings[6]>'' then IsClassEmpty:=true
                    else IsClassEmpty:=false;
   //if Ret[RetNo].Frm[FNo].strings[55]>'' then Ret[RetNo].Frm[FNo].Strings[34]:='X'; //if aiip then halh year blank/exempt
   if Ret[RetNo].Frm[FNo].Strings[41]>'' then DiepEligible:=True else DiepEligible:=False; //20230515


  //AUTOS CCA New format with 22  //21 columns now
   // If IsDiepEligible(Cls,Ret[RetNo].Frm[FNo].Strings[137])=false then begin DiepEligible:=False;Ret[RetNo].Frm[FNo].Strings[41]:='';end; //20230515

	{//jz//CCAv5 - move to above, combine with 2018-11-20 date condition 
    if cls='12' then
    begin
      Ret[RetNo].Frm[FNo].Strings[55] := '';  //no Aiip  //?? 20230404
    end; // 20200703
	}

    //jz//20260406//CCAv2 - put in function
    {
    // Aiipfactor //jz//20260406
    if      (cls = '43.1') or
            (cls = '54')   or
            (cls = '56')
                              then Aiipfactor := 1.5
    else if  cls = '55'       then Aiipfactor := 7/8
    else if (cls = '43.2') or
            (cls = '53')
                              then Aiipfactor := 1/2
    //does this need extra coding  /date checks? //proposed changes, for properties included in Class 44, 46, or 50
                                                 //acquired after April 15, 2024, and that became available for use in 2025
    else if cls = '44'        then Aiipfactor := 3     //
    else if cls = '46'        then Aiipfactor := 1/3
    else if cls = '50'        then Aiipfactor := 9/11

    else                           Aiipfactor := 0;
    strings[38] := floattostr(Aiipfactor);
    }

    Strings[38]:=GetAiipFactor(Cls); //jz//20260406//CCAv2


    //jz//20260406//CCAv2 - put in function
    {



    // Riipfactor //jz//20260406
    //Under proposed changes, for ZEVs acquired after 2024 and RIIPs that became available for use in 2025
    if       cls = '44'       then Riipfactor := 3
    else if (cls = '43.1') or
            (cls = '46')   or
            (cls = '54')   or
            (cls = '56')
                              then Riipfactor := 2 + (1/3)
    else if  cls = '55'       then Riipfactor := 1.5
    else if  cls = '53'       then Riipfactor := 1
    else if  cls = '50'       then Riipfactor := 9/11
    else if (cls = '12') or
            (cls = '13') or
            (cls = '14') or
            (cls = '15') or
            (cls = '59')
                              then Riipfactor := 0
    Else                           Riipfactor := 0.5;
    strings[58] := floattostr(Riipfactor);
    }
    Strings[58]:=GetRiipFactor(Cls); //jz//20260406//CCAv2

    //20230515
    if Tv[33]=Tv[40] then Tv[33]:=0; //if cost = AiiFactor then zero it out (error in restructioring with new format of CCA
    //20230429
    Tv[152]:=Tv[143] * Tv[197]/100;
    Tv[155]:=Tv[143] * Tv[200]/100;
    Tv[56]:=MaxR(0,Tv[143]+Tv[152]+Tv[155]-Tv[39]); //jz//20260406//CCAv2

    Tv[col3]:=Tv[56];  //jz//20260406//CCAv2 158  //20230519

    //COLUMNS
    if diepEligible=true then //Ret[RetNo].Frm[FNo].Strings[43]>'' then //diep eligible //20230423
    begin
     if Tv[Col4]=0 then begin Tv[col4]:=Tv[Col3];Tv[44]:=Tv[Col4];end;
     if Tv[Col4]>Tv[col3] then begin Tv[Col4]:=Tv[Col3];Tv[44]:=Tv[Col3];End;
    end
    Else
     Tv[Col4]:=0;

    If Tv[Col5]=0 then Tv[Col6]:=0;  //User if no diep then no dispos of diep //20230516
    Tv[col7]:=Tv[col2]+Tv[Col3]-Tv[col5];
    Tv[col8]:=MaxR(0,Tv[col4]-Tv[col6]);
    If DiepEligible=false then Tv[col9]:=0; //useer?/ immediate expensing
    if Tv[Col9]>1500000 then Tv[col9]:=1500000;
    Tv[col10]:=Tv[col3]-Tv[col9]; //MaxR(0,Tv[col3]-Tv[col4]+Tv[col8]-Tv[col9]);
    Tv[col11]:=Tv[50]; //user
    Tv[col12]:=Tv[12];  //manual MaxR(0,Tv[col7]-Tv[col9]);
    Tv[col13]:=MaxR(0,Tv[col7]-Tv[col9]) ; //-Tv[col10]+Tv[col11]);   //??? //MaxR(0,Tv[col5]-Tv[col6]-Tv[col10]+Tv[col11]);   //???
    Tv[Col14]:=MaxR(0,Tv[col5]-TV[Col10]+Tv[Col11]+Tv[Col12]); //*AiipFactor); //MaxR(0,(Tv[col11]-Tv[col13])*AiipFactor);
    Tv[Col15]:=MaxR(0,(Tv[col11]-Tv[col14]))*Vl(Strings[38]); //factor)   //-Tv[col11]-Tv[col5])*(1/2)) //20230411
      //Tv[Col15]:=MaxR(0,(Tv[col10]+Tv[col6]-Tv[col11]-Tv[col5])*(1/2)) //20230411
    Tv[Col16]:=MaxR(0,Tv[col12]-Tv[col14]); //Factor 2??
    Tv[Col17]:=MaxR(0,Tv[col12]-Tv[col16])* Vl(strings[58]); //jz//20260405 - form wrong, fix col16 not col14
    if (Strings[34]='') and //not exempt half-year rule
       (Tv[col3]>0)         //jz//20260406//CCAv2 - there are current year adjustments
    then Tv[Col18]:=(Tv[Col10]-Tv[col11]-Tv[col12]-Tv[Col5])* (1/2)
    else Tv[Col18]:=0;
    Tv[Col19]:=Tv[Col13]+Tv[col15]+Tv[Col17]-Tv[col18];     //jz//20260405 - form wrong, fix - +Tv[Col16]-Tv[col17];

    Ret[RetNo].Frm[FNo].Strings[col20]:=GetCCARate(Cls); //20260405    
	{
    if      (trim(strings[col1]) = '10')   or
            (trim(strings[col1]) = '10.1') or
            (trim(strings[col1]) = '54')
    then
      strings[Col20]:='30'
    else if (trim(strings[col1]) = '55') then
      strings[Col20]:='40';
	}

    xx:=Tv[173];

    Tv[col21] := (tv[col19] * (vl(strings[col20])/100)) + tv[col9];   //jz//20260406//CCAv2 - no more override, strait to col21 instead of 177 first  //jz//20260405 - as per changed form
    //If not(overrideCCA) then Tv[Col21]:=Tv[177];  //if not override apply amount //jz//20260406//CCAv2

    //xx:=Tv[177];
    xx:=Tv[173];
    xx:=Tv[Col21];

    //if Strings[23]='' then //jz//20260406//CCAv2 - no more col 22 override
    Tv[col22]     := maxR(0,Tv[col7]-TV[col21]); //jz//20260407//CCAv2 - cannot be neg - change as per form //Tv[Col19]-TV[177];

    //jz//20260409 - add for T776
    // T776 chart b begin ======================================================

    strings[588] := strings[col1]; //set same cls
    i := 492; //Tv[427] := 0; //Repeat
      if (strings[i + 1] > '') and (strings[i + 1] <> '0') then
        Tv[i + 2] := Tv[i - 1] * Vl(strings[i]) / Vl(strings[i + 1])
      else
        Tv[i + 2] := 0;
    // T776 chart b end ========================================================

    Tv[col22T776] := maxR(0,Tv[494]);
    Tv[col23T776] := maxR(0,Tv[col21] - TV[col22T776]);
    Tv[col24T776] := maxR(0,Tv[col7]  - TV[col23T776]);
    //------------- Summarize on the top summary  -----------------------------

   //Init some totals
    //Tv[20]          :=0;  //tot expense for statement
    //Tv[21]         :=0;  //tot cca for a statement
    //Tv[93]          :=0;  //Tot CCA for each auto  // done in calcBusinessUseCCAmax

    Tv[90]          :=0;  //Tot Expense fot each auto
    Tv[Col21Tloss]  :=0;  //Terminal loss [20]
    Tv[Col21Recapt] :=0;  //Recapture [21]

    calcBusinessUseMaxCCA();
    ////jz//20260405 - calcBusinessUseCCAmax based on KM used for business is done above
    //               - if is assetsb, calcs personal use
    //                 there is repittion here of calculating milage max why???

     //find cca for each business statement
     //20230519
     Tv[90] := Tv[54]; //jz//20260410//CCAv4 - move to before to be populated for b% prorated calc
     Tv[8]:=0; //total CCA takem add up all business //20230610
     for i:=233 to 235 do Ret[RetNo].Frm[FNo].Strings[i]:=''; //*** NO override allowed here
     i := 215;  //pick it up from tv[173]  = total cca for all
     Repeat
        If (Ret[RetNo].Frm[FNo].Strings[i] > '')   and
          (Ret[RetNo].Frm[FNo].Strings[i+1] > '')
        then
        begin
          BusDays := CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[i]);
          calcMaxDays();
          If MaxBusDays > 0 then
          Begin
            Tv[i + 2] := Tv[90] * Tv[i + 1] / 100; //jz//20260410//CCAv4
            xx:=Tv[90] * Tv[i + 1] / 100;
            xx:=Tv[90];
            xx:=Tv[i + 1];
            xx:=tv[i + 2];
            xx:=tv[217];

            //jz//20260409//CCAv3
            if pos('T776',strings[i]) = 0 then
              Tv[i + 3] := Tv[93] * (Tv[i + 1] / 100) * BusDays / MaxBusDays
            else
            begin
              Tv[i + 3] := Tv[64] * (Tv[i + 1] / 100) * BusDays / MaxBusDays;
              AlocToT776 := true                   //jz//20260410//CCAv4
            end;

            Tv[8]:=Tv[8]+Tv[i+3]; //20230716

                    //jz//20260409//CCAv3 - not sure why all this checking, above works fine
                    //20230610    //20230717: [206] hs the override: If overriden inoreany statementpercent%
                    {
                    if (i+3=218) then
                    begin
                      Tv[i + 3] := Tv[93] * (Tv[i + 1] / 100) * BusDays / MaxBusDays;         //jz//20260405 - Tv[93] from Tv[177]
                      //if Ret[RetNo].Frm[FNo].Strings[206]=''  then  //no override on cca    //jz//20260405 -  remove override check as override moved to 173
                      //  Tv[i + 3] :=Tv[i + 3] *(vl(Ret[RetNo].Frm[FNo].Strings[4]) / vl(Ret[RetNo].Frm[FNo].Strings[7]));  //jz//20260405 - milage already accounted for  in [93] //mileage  //20230716
                      Tv[8]:=Tv[8]+Tv[i+3]; //20230716
                    end;

                    if (i+3=224) then
                    Begin
                      Tv[i + 3] := Tv[93] * (Tv[i + 1] / 100) * BusDays / MaxBusDays;   //% usage  //jz//20260405 - Tv[93] from Tv[177]
                     //if Ret[RetNo].Frm[FNo].Strings[206]=''  then                               //jz//20260405 -  remove override check as override moved to 173
                     //  Tv[i + 3] :=Tv[i + 3] *(vl(Ret[RetNo].Frm[FNo].Strings[4]) / vl(Ret[RetNo].Frm[FNo].Strings[7])); //jz//20260405 - milage already accounted for in [93] //mileage  //20230716
                     Tv[8]:=Tv[8]+Tv[i+3]; //20230716
                    End;
                    if (i+3=230) then
                    Begin
                     Tv[i + 3] := Tv[93] * (Tv[i + 1] / 100) * BusDays / MaxBusDays;    //jz//20260405 - Tv[93] from Tv[177]
                     //if Ret[RetNo].Frm[FNo].Strings[206]=''  then                     //jz//20260405 -  remove override check as override moved to 173
                     //  Tv[i + 3] :=Tv[i + 3] *(vl(Ret[RetNo].Frm[FNo].Strings[4]) / vl(Ret[RetNo].Frm[FNo].Strings[7])); //jz//20260405 - milage already accounted for in [93]  //mileage  //20230716
                     Tv[8]:=Tv[8]+Tv[i+3]; //20230716
                    End;
                    // Ret[RetNo].Frm[FNo].Strings[206] = '' then Tv[177]:= Tv[i + 3]; //20230525 Igor probably not needed? //20230716
                    }
          End; //end max days
        end
        Else
        begin
          Tv[i + 2] := 0;
          Tv[i + 3] := 0;
        end;
        Inc(i, 6);
     until i > 227;

     if not AlocToT776 then tv[64] := 0; //jz//20260410//CCAv4 if no alocation to 776 then make zero


      //Terminal loss or Recapture begin =======================================
      If IsClassEmpty then //jz//CCAv6 //(Ret[RetNo].Frm[FNo].Strings[6] > '') then //class empty
      begin
        if Cls='10.1' then  //no term loss or recapture
        Begin
          Tv[Col21Tloss] :=0;
          Tv[Col21Recapt]:=0;
        end
        else
        begin
          If Tv[Col7]<0 then  //20230501  Recapture
          begin   //ucc + additions < UCC after dispositions then recapturoe
            Tv[93]:=0; Tv[218]:=0;Tv[224]:=0;Tv[230]:=0;Tv[8]:=0;  //20240309 NO CCA amounts
            Tv[64]:=0; //jz//20260412//CCAv5 - clear T776 CCA amount also

            Tv[Col21Recapt] := ABS(Tv[Col7]) * usagePercent; //jz//CCAv5 //(Vl(Ret[RetNo].Frm[FNo].Strings[4])/Vl(Ret[RetNo].Frm[FNo].Strings[7])); //prorate by km use//20240309

            //Tv[Col21]    := 0; // max cca  //jz//202604006//CCAv2 - change to col21 from 177 but not in use anymore anyway
            Tv[Col15]      := 0;   //jz//202604006//CCAv2 - still col15????????????????
            Tv[Col16]      := 0;   //Term loss //jz//202604006//CCAv2 -  chnge to Col19 from Col16
            Tv[Col21]      := 0;   //CCA  //jz//202604006//CCAv2 - change to col21 from col8

           Strings[col20]  := '';  //Rate //jz//202604006//CCAv2 - change to col20 from col17
           Tv[Col21Tloss]  := 0;   //jz//202604006//CCAv2 - change to Col21Tloss from 20
          end
          else //Terminal loss
          begin
            Tv[93]:=0; Tv[218]:=0;Tv[224]:=0;Tv[230]:=0;Tv[8]:=0;  //20240309  NO CCA amounts

            Tv[64]:=0; //jz//20260412//CCAv5 - clear T776 CCA amount also

            Tv[Col21Tloss] := ABS(Tv[Col7]) * usagePercent; //jz//CCAv5 //(Vl(Ret[RetNo].Frm[FNo].Strings[4])/vl(Ret[RetNo].Frm[FNo].Strings[7]));   //prorate km //20230309


            //Tv[177]         := 0;               //jz//202604006//CCAv2 - no longer in use
            Tv[col21]       :=0; //Tv[173] := 0; //jz//202604006//CCAv2 - change to col21 from col8
            Tv[col22]       :=0; //Tv[167] := 0; // base amount  //jz//202604006//CCAv2 - change to col22 from col9
            Tv[col23T776]       :=0; //jz//20260412//CCAv5 - clear T776 CCA amounts also - not sure this is rigght, how does col223T776 get handled??
            Tv[col24T776]       :=0; //jz//20260412//CCAv5 - clear T776 CCA amounts also
            Tv[col21Recapt] :=0; //recapture //jz//202604006//CCAv2 - change to col21-Recapt from 21
            Strings[col20]  := '';  //Rate //jz//202604006//CCAv2 - change to col20 from col17 / [170]
            Tv[col22]       :=0; //Tv[176] := 0; //ending ucc 21 //jz//202604006//CCAv2 - change to col22 from 21 which was actually wrong
          end;
        end;
      end;
      //Terminal loss or Recapture end =========================================
  end; //with cca

  SaveTv(RetNo, FName, FNo); //20230501 Igor
end; //end Procedure Autos
*)


                              //Procedure Autos bak
						    //====================================

						     //Tv[col12]+Tv[col14]-Tv[col15]; //   //base amount  //??deduct diep amount -Tv[Col4];  //20230411
						    // ????  If Ret[RetNo].Frm[FNo].Strings[13]='' then Ret[RetNo].Frm[FNo].Strings[col17]:=GetCCARate(Cls);


						    //Initialize cca, Term loss and Recapture
						  (*//20260404

						    Tv[Col18]:=0 ; //cca
						    Tv[20]:=0; //term loss
						    Tv[21]:=0; //recapture

						    Tv[93]:=0; //max based on business use
						    //Prorate
						    MaxBusDays := 0;
						    If Tv[216] > 0 then
						      MaxBusDays := CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[215]);
						    If Tv[222] > 0 then
						    begin
						      If CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[221]) > MaxBusDays then
						        MaxBusDays := CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[221]);
						    end;
						    If Tv[228] > 0 then
						    begin
						      If CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[227]) > MaxBusDays then
						        MaxBusDays := CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[227]);
						    end;

						    Tv[93]:= Tv[col16] * (vl(Ret[RetNo].Frm[FNo].Strings[Col17])/100);   //usage
						    Tv[93]:=Tv[93] * vl(Ret[RetNo].Frm[FNo].Strings[4]) / vl(Ret[RetNo].Frm[FNo].Strings[7]);  //mileage //20230716
						    If Ret[RetNo].Frm[FNo].Strings[206] = '' then Tv[177]:=Tv[93]; //MaxCCA based on mileage  //20230716

						    //prorate the maxCCA for short years   MaxCCA=Tv[177]
						     If Ret[RetNo].Frm[FNo].Strings[206] = '' then   //202added minRr    //20230526 CON  //max CCA for the year
						      Tv[177] :=Tv[col18] * vl(Ret[RetNo].Frm[FNo].Strings[170])/100 +Tv[col9];
						     //find cca for each business statement
						     //20230519
						     Tv[8]:=0; //total CCA takem add up all business //20230610
						     for i:=233 to 235 do Ret[RetNo].Frm[FNo].Strings[i]:=''; //*** NO override allowed here
						     i := 215;  //pick it up from tv[173]  = total cca for all
						     Repeat
						      If (Ret[RetNo].Frm[FNo].Strings[i] > '') And (Ret[RetNo].Frm[FNo].Strings[i+1] > '')
						      then
						      begin
						        BusDays := CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[i]);
						        If MaxBusDays > 0 then
						        Begin
						          //20230610    //20230717: [206] hs the override: If overriden inoreany statementpercent%
						          if (i+3=218) then
						          begin
						            Tv[i + 3] := Tv[177]* (Tv[i + 1] / 100) * BusDays / MaxBusDays;
						            if Ret[RetNo].Frm[FNo].Strings[206]=''  then
						               Tv[i + 3] :=Tv[i + 3] *(vl(Ret[RetNo].Frm[FNo].Strings[4]) / vl(Ret[RetNo].Frm[FNo].Strings[7]));  //mileage  //20230716
						            Tv[8]:=Tv[8]+Tv[i+3]; //20230716
						          end;

						          if (i+3=224) then
						          Begin
						           Tv[i + 3] := Tv[177]* (Tv[i + 1] / 100) * BusDays / MaxBusDays;   //% usage
						           if Ret[RetNo].Frm[FNo].Strings[206]=''  then
						              Tv[i + 3] :=Tv[i + 3] *(vl(Ret[RetNo].Frm[FNo].Strings[4]) / vl(Ret[RetNo].Frm[FNo].Strings[7]));  //mileage  //20230716
						           Tv[8]:=Tv[8]+Tv[i+3]; //20230716
						          End;

						          if (i+3=230) then
						          Begin
						           Tv[i + 3] := Tv[177]* (Tv[i + 1] / 100) * BusDays / MaxBusDays;
						           if Ret[RetNo].Frm[FNo].Strings[206]=''  then
						             Tv[i + 3] :=Tv[i + 3] *(vl(Ret[RetNo].Frm[FNo].Strings[4]) / vl(Ret[RetNo].Frm[FNo].Strings[7]));  //mileage  //20230716
						           Tv[8]:=Tv[8]+Tv[i+3]; //20230716
						          End;
						         // Ret[RetNo].Frm[FNo].Strings[206] = '' then Tv[177]:= Tv[i + 3]; //20230525 Igor probably not needed? //20230716
						        End;
						        //else  Tv[i + 3] := 0;
						      end
						      Else
						      begin
						        Tv[i + 2] := 0;
						        Tv[i + 3] := 0;
						      end;
						     // Tv[8]:=Tv[8]+Tv[i+3]; //20230716 //20230610
						      Inc(i, 6);
						     until i > 227;

						     Tv[173]:=Tv[8];
						     xx:=Tv[8];

						     If Ret[RetNo].Frm[FNo].Strings[206] > '' then
						     Begin
						      Tv[173]:=Tv[177];
						     end;

						     Tv[col18]:=Tv[173]; //Tv[177]; //20230716
						     xx:=Tv[col18];
						     If Ret[RetNo].Frm[FNo].Strings[23]='' then  Tv[Col19]:=MaxR(0,Tv[Col7]-Tv[177]); //20240317
						     //20230516
						     Tv[90] := Tv[54];
						     //terminal loss or Recaoture
						    If (Ret[RetNo].Frm[FNo].Strings[6] > '') //class empty
						    then //20230411 class empty Tv[Col7]<0 then // term loss
						    begin
						     if Cls='10.1' then  //no term loss or recapture
						     Begin
						      Tv[20]:=0;
						      Tv[21]:=0;
						     end      *
						     Else
						     Begin
						      If Tv[Col7]<0 then  //20230501  Recapture
						      Begin   //ucc + additions < UCC after dispositions then recapturoe
						         Tv[93]:=0; Tv[218]:=0;Tv[224]:=0;Tv[230]:=0;Tv[8]:=0;  //20240309 NOO CCA amounts
						         Tv[21] :=ABS(Tv[Col7]) * (Vl(Ret[RetNo].Frm[FNo].Strings[4])/Vl(Ret[RetNo].Frm[FNo].Strings[7])); //prorate by km use//20240309
						         Tv[177] := 0; // max cca
						         Tv[Col15]:=0;
						         Tv[Col16]:=0; //Term loss
						         Tv[Col18]:=0; //CCA  Tv[173] := 0; // cca
						         Ret[RetNo].Frm[FNo].Strings[col17]:=''; //Rate Strings[170] := ''; // rate
						         Tv[20]:=0; //Tv[176] := 0; // ucc end
						      end
						      Else //Terminal loss
						      Begin
						       Tv[93]:=0; Tv[218]:=0;Tv[224]:=0;Tv[230]:=0;Tv[8]:=0;  //20240309  NO CCA amounts
						       Tv[20] := ABS(Tv[Col7]) * (Vl(Ret[RetNo].Frm[FNo].Strings[4])/vl(Ret[RetNo].Frm[FNo].Strings[7]));   //prorate km //20230309
						       Tv[177] := 0;
						       tv[col18]:=0; //Tv[173] := 0;
						       Tv[col19]:=0; //Tv[167] := 0; // base amount
						       Tv[21]:=0; //recapture
						       Ret[RetNo].Frm[FNo].Strings[col17]:=''; //Strings[170] := ''; // rate
						       Tv[21]:=0; //Tv[176] := 0; // ending ucc
						      End;
						    end;

						     //copy Col[] data into the ELM'sof the form
						    {//needed?  20260403
						    Tv[158]:=Tv[Col3];
						    Tv[44]:=Tv[Col4];
						    Tv[18]:=Tv[Col5];
						    Tv[24]:=Tv[Col6];
						    Tv[46]:=Tv[Col7];
						    Tv[47]:=Tv[Col8];
						    Tv[26]:=Tv[Col9];
						    Tv[49]:=Tv[Col10];

						    Tv[50]:=Tv[Col11];
						    Tv[12]:=Tv[Col12];
						    Tv[27]:=Tv[Col13];
						    Tv[52]:=Tv[Col14];
						    Tv[53]:=Tv[Col15];
						    Tv[14]:=Tv[Col16];
						    Tv[30]:=Tv[Col17];
						    }
						   //Tv[173]:=Tv[Col18];  //does nor work-is not needed
						   // Tv[176]:=Tv[Col19];
						   end;
						 end;
						  SaveTv(RetNo, FName, FNo); //20230501 Igor
						end;


						(* //20260403
						//20230515
						Procedure Autos(RetNo: integer; FName: string; FNo: integer);
						Var
						  i, MaxBusDays, BusDays: integer;
						  cls:string;
						  FInst: String[4];
						  Aiipfactor: Real; // 20190215
						  k, Gst, Pst: Real;
						  Line5K, Line6K, Line7K: Real;
						  Yr: String[4];
						  TotalDays, DaysBeforeJuly1, DaysAfterJuly1: integer;
						  StartLease, ENdLease: String;
						  { StmList:TStringList; } MaxCCA: Real;
						  BusPercent: Real;
						  //20230417
						  AiipEligible:Boolean;
						  DiepEligible:Boolean;
						  Col1,Col2,Col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19:Integer;
						Begin
						  //20230501 Igor >>>
						  Col1 := 134;
						  Col2 := 191;
						  Col3 := 158;
						  Col4 := 44;
						  Col5 := 18;
						  Col6 := 24;
						  Col7 := 46;
						  Col8 := 47;
						  Col9 := 26;
						  Col10 := 49;
						  Col11 := 50;
						  Col12 := 27;
						  Col13 := 52;
						  Col14 := 53;
						  Col15 := 30;
						  Col16 := 167;
						  Col17 := 170;
						  Col18 := 173;
						  Col19 := 176;
						  //20230501 Igor <<<

						  // ConvertOldAutoExpDates(RetNo,FNo);
						  FInst := ExtractFormInst(FName);
						  LoadTv(RetNo, FName, FNo);
						  with ret[RetNo].Frm[FNo] do
						  begin
						    Strings[3] := GetFirstName(RetNo);
						    Strings[5] := GetSpouseFirstName(RetNo);
						    Strings[9] := GetFirstName(RetNo);

						    i := 216;
						    Repeat
						      If Strings[i + 4] > '' then
						        Tv[i] := 0;
						      If Tv[i] > 100 then Tv[i] := 100;
						     // If Strings[i - 1] = '' then Tv[i] := 0; // no statement //20230717 allow % with no statement
						      If Strings[i + 4] = '' then // no partner
						      begin
						        If IsSharedStatement(RetNo, Strings[i - 1]) then
						          Tv[i + 3] := Tv[i];
						      end;
						      Tv[i + 1] := Tv[i] * Tv[90] / 100;
						      Tv[i + 2] := Tv[i] * Tv[93] / 100;
						      Inc(i, 6);
						    until i > 228;

						    Tv[2] := Tv[216] + Tv[222] + Tv[228];
						    Tv[11] := Tv[219] + Tv[225] + Tv[231];

						    If Strings[129] = '' then
						      Strings[129] := 'Business Parking Fees';
						    If Strings[130] = '' then
						      Strings[130] := 'Supplementary Business Insurance';

						    If (vl(Strings[4]) = 0) and (vl(Strings[7]) = 0) then
						    begin
						      Strings[4] := '1';
						      Strings[7] := '1';
						    end;
						    If vl(Strings[7]) < vl(Strings[4]) then
						      Strings[7] := Strings[4];

						    For i := 0 to 0 do
						    begin
						      If vl(Strings[7 + i]) > 0 then
						        Tv[122 + i] := Tv[119 + i] * (vl(Strings[4 + i]) / vl(Strings[7 + i]))
						      else
						        Tv[122 + i] := 0;

						      { Lease }
						      Yr := LeftStr(Strings[57 + i], 4);
						      StartLease := Strings[57 + i];
						      ENdLease := Strings[60 + i];
						      If (StartLease > '') and (ENdLease > '') then
						        TotalDays := DateDiff(YMDtoDate(StartLease), YMDtoDate(ENdLease));
						      DaysBeforeJuly1 := DateDiff(YMDtoDate(StartLease),
						        YMDtoDate(MinString('2006-07-01', ENdLease))); // 20160119 Igor
						      DaysAfterJuly1 := DateDiff(YMDtoDate(MaxString('2006-07-01', StartLease)),
						        YMDtoDate(ENdLease)); // 20160119 Igor

						      If DaysBeforeJuly1 < 0 then
						        DaysBeforeJuly1 := 0;
						      If DaysAfterJuly1 < 0 then
						        DaysAfterJuly1 := 0;
						      Line5K := GetLine5K(Yr);
						      Gst := Line5K * Tv[126 + i] / 100;
						      Pst := Line5K * vl(Strings[63 + i]) / 100;
						      If Yr < '1991' then
						      begin
						        Gst := 0;
						        Pst := 0;
						      end;
						      //-----------------------------------------------
						     //removed by CZwhy?  20260329 if Tv[5]=0 then Tv[]:=Tv[75];  //20260329
						      //if Tv[6]=0 then Tv[]:=Tv[75];  //20260329

						      k := Line5K + Gst + Pst;

						      Tv[78 + i] := MaxR(k, Tv[75 + i]) * 0.85;

						      Line6K := GetLine6K(Yr);
						      Gst := Line6K * Tv[126 + i] / 100;
						      Pst := Line6K * vl(Strings[63 + i]) / 100;
						      If Yr < '1991' then
						      begin
						        Gst := 0;
						        Pst := 0;
						      end;
						      k := Line6K + Gst + Pst;
						      Tv[81 + i] := MaxR(0, ((k * Tv[72 + i]) / 30) - Tv[69 + i]);

						      Line7K := GetLine7K(Yr);
						      Gst := Line7K * Tv[126 + i] / 100;
						      Pst := Line7K * vl(Strings[63 + i]) / 100;
						      If Yr < '1991' then
						      begin
						        Gst := 0;
						        Pst := 0;
						      end;
						      k := Line7K + Gst + Pst;
						      If Tv[78 + i] > 0 then
						        Tv[84 + i] := k * Tv[66 + i] / Tv[78 + i]
						      else
						        Tv[84 + i] := 0;

						      Tv[99 + i] := MinR(Tv[81 + i], Tv[84 + i]);
						      { Interest }

						      If Tv[109 + i] = 0 then
						        Tv[109 + i] := 10;
						      If vl(Strings[106 + i]) = 0 then
						        Tv[109 + i] := 0;
						      //20241217
						      Tv[109+i]:=Tv[9]/30;   //tv[9] ot tv[9+i]??

						      Tv[112 + i] := vl(Strings[106 + i]) * Tv[109 + i];
						      Tv[115 + i] := MinR(Tv[103 + i], Tv[112 + i]);

						      { interest }
						      If UpperCase(Strings[28]) <> 'Y' then
						        Tv[19] := Tv[115];

						      { Lease }
						      If UpperCase(Strings[29]) <> 'Y' then
						        Tv[16] := Tv[99];
						      Tv[42 + i] := Tv[10 + i] + Tv[19 + i] + Tv[22 + i] + Tv[25 + i] +
						        Tv[13 + i] + Tv[16 + i] + Tv[43] + Tv[32 + i] + Tv[36 + i];   //20210301
						      If vl(Strings[7 + i]) > 0 then
						        Tv[45 + i] := Tv[42 + i] * (vl(Strings[4 + i]) / vl(Strings[7 + i]))
						      else
						        Tv[45 + i] := 0;
						      Tv[54 + i] := MaxR(0, Tv[45 + i] + Tv[48 + i] + Tv[51 + i]);
						    end;
						    //If Tv[109] = 0 then Tv[109] := 10; // 20241217
						  end;
						    //===================================================================

						  with Ret[RetNo].Frm[FNo] do
						  begin
						   //20230521
						   //InitTeminal los and Recapture
						   Tv[20]:=0;
						   Tv[21]:=0;

						   //20230502
						   Cls:=Ret[RetNo].Frm[FNo].Strings[134];  //class

						   if Ret[RetNo].Frm[FNo].Strings[137]>'2018/11/20' then
						   Begin
						    Ret[RetNo].Frm[FNo].Strings[55]:='X';
						    AiipEligible:=True;
						   End
						   Else
						   Begin
						    Ret[RetNo].Frm[FNo].Strings[55]:='';
						    AiipEligible:=False;
						   End;

						   //20230516
						   If (Ret[RetNo].Frm[FNo].Strings[6]='') or (UpperCase(Ret[RetNo].Frm[FNo].Strings[6])='X')
						   then
						   //ok
						   Else
						    Ret[RetNo].Frm[FNo].Strings[6]:='';

						   if Ret[RetNo].Frm[FNo].strings[55]>'' then Ret[RetNo].Frm[FNo].Strings[34]:='X'; //if aiip then halh year blank/exempt

						   if Ret[RetNo].Frm[FNo].Strings[41]>'' then DiepEligible:=True else DiepEligible:=False; //20230515


						  //AUTOS CCA New format with 19 columns
						   // If IsDiepEligible(Cls,Ret[RetNo].Frm[FNo].Strings[137])=false then begin DiepEligible:=False;Ret[RetNo].Frm[FNo].Strings[41]:='';end; //20230515

						    if cls='12' then
						    begin
						      Ret[RetNo].Frm[FNo].Strings[55] := '';  //no Aiip  //?? 20230404
						    end; // 20200703

						    // Aiipfactor
						    if cls = '43.1' then
						      Aiipfactor := 2.33333
						    Else if cls = '43.2' then
						      Aiipfactor := 1
						    Else if cls = '53' then
						      Aiipfactor := 1
						    Else
						      Aiipfactor := 0.5;
						    Tv[40] := Aiipfactor;
						    if (cls = '12') or (cls = '14') or (cls = '15')
						    then
						      Aiipfactor := 0; // 20200703

						    //20230515
						    if Tv[33]=Tv[40] then Tv[33]:=0; //if cost = AiiFactor then zero it out (error in restructioring with new format of CCA
						    //20230429
						    Tv[152]:=Tv[143] * Tv[197]/100;
						    Tv[155]:=Tv[143] * Tv[200]/100;
						    Tv[56]:=Tv[143]+Tv[152]+Tv[155];  //20230516
						    Tv[158]:=MaxR(0,Tv[56]-Tv[39]);   //20230519

						    //COLUMNS

						    Tv[col3]:=Tv[158]; //20230520 // MaxR(0, Tv[12] - Tv[8]); //net cos for business Tv[158]

						    if diepEligible=true then //Ret[RetNo].Frm[FNo].Strings[43]>'' then //diep eligible //20230423
						    begin
						     if Tv[Col4]=0 then begin Tv[col4]:=Tv[Col3];Tv[44]:=Tv[Col4];end;
						     if Tv[Col4]>Tv[col3] then begin Tv[Col4]:=Tv[Col3];Tv[44]:=Tv[Col3];End;
						    end
						    Else
						     Tv[Col4]:=0;

						    If Tv[Col5]=0 then Tv[Col6]:=0;  //User if no diep then no dispos of diep //20230516
						    Tv[col7]:=Tv[col2]+Tv[Col3]-Tv[col5];
						    Tv[col8]:=MaxR(0,Tv[col4]-Tv[col6]);
						    If DiepEligible=false then Tv[col9]:=0; //useer?/ immediate expensing
						    if Tv[Col9]>1500000 then Tv[col9]:=1500000;
						    Tv[col10]:=MaxR(0,Tv[col3]-Tv[col4]+Tv[col8]-Tv[col9]);
						    Tv[col11]:=Tv[50]; //user
						    Tv[col12]:=MaxR(0,Tv[col7]-Tv[col9]);
						    Tv[col13]:=MaxR(0,Tv[col5]-Tv[col6]-Tv[col10]+Tv[col11]);
						    Tv[Col14]:=MaxR(0,(Tv[col11]-Tv[col13])*AiipFactor);

						    if Ret[RetNo].Frm[FNo].strings[34]='' then   //20230515 50 5 rule exempt
						      Tv[Col15]:=MaxR(0,(Tv[col10]+Tv[col6]-Tv[col11]-Tv[col5])*(1/2)) //20230411
						    Else
						      Tv[Col15]:=0;

						    Tv[Col16]:=Tv[col12]+Tv[col14]-Tv[col15]; //   //base amount  //??deduct diep amount -Tv[Col4];  //20230411
						    If Ret[RetNo].Frm[FNo].Strings[13]='' then Ret[RetNo].Frm[FNo].Strings[col17]:=GetCCARate(Cls);


						    //Initialize cca, Term loss and Recapture
						    Tv[Col18]:=0 ; //cca
						    Tv[20]:=0; //term loss
						    Tv[21]:=0; //recapture



						    Tv[93]:=0; //max based on business use
						    //Prorate
						    MaxBusDays := 0;
						    If Tv[216] > 0 then
						      MaxBusDays := CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[215]);
						    If Tv[222] > 0 then
						    begin
						      If CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[221]) > MaxBusDays then
						        MaxBusDays := CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[221]);
						    end;
						    If Tv[228] > 0 then
						    begin
						      If CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[227]) > MaxBusDays then
						        MaxBusDays := CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[227]);
						    end;

						    Tv[93]:= Tv[col16] * (vl(Ret[RetNo].Frm[FNo].Strings[Col17])/100);   //usage
						    Tv[93]:=Tv[93] * vl(Ret[RetNo].Frm[FNo].Strings[4]) / vl(Ret[RetNo].Frm[FNo].Strings[7]);  //mileage //20230716
						    If Ret[RetNo].Frm[FNo].Strings[206] = '' then Tv[177]:=Tv[93]; //MaxCCA based on mileage  //20230716

						    //prorate the maxCCA for short years   MaxCCA=Tv[177]
						     If Ret[RetNo].Frm[FNo].Strings[206] = '' then   //202added minRr    //20230526 CON  //max CCA for the year
						      Tv[177] := Tv[col16] * vl(Ret[RetNo].Frm[FNo].Strings[Col17])/100 +Tv[col9];
						      //Tv[177] := (Tv[col16] * vl(Ret[RetNo].Frm[FNo].Strings[Col17]) / 100 * MaxBusDays / Constant[RY].FullYear)+Tv[col9];

						     //Tv[173] := Tv[8]; //20230716 //Tv[177]    //see below

						     //find cca for each business statement
						     //20230519
						     Tv[8]:=0; //total CCA takem add up all business //20230610
						     for i:=233 to 235 do Ret[RetNo].Frm[FNo].Strings[i]:=''; //*** NO override allowed here
						     i := 215;  //pick it up from tv[173]  = total cca for all
						     Repeat
						      If (Ret[RetNo].Frm[FNo].Strings[i] > '') And (Ret[RetNo].Frm[FNo].Strings[i+1] > '')
						      then
						      begin
						        BusDays := CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[i]);
						        If MaxBusDays > 0 then
						        Begin
						          //20230610    //20230717: [206] hs the override: If overriden inoreany statementpercent%
						          if (i+3=218) then
						          begin
						            Tv[i + 3] := Tv[177]* (Tv[i + 1] / 100) * BusDays / MaxBusDays;
						            if Ret[RetNo].Frm[FNo].Strings[206]=''  then
						               Tv[i + 3] :=Tv[i + 3] *(vl(Ret[RetNo].Frm[FNo].Strings[4]) / vl(Ret[RetNo].Frm[FNo].Strings[7]));  //mileage  //20230716
						            Tv[8]:=Tv[8]+Tv[i+3]; //20230716
						          end;

						          if (i+3=224) then
						          Begin
						           Tv[i + 3] := Tv[177]* (Tv[i + 1] / 100) * BusDays / MaxBusDays;   //% usage
						           if Ret[RetNo].Frm[FNo].Strings[206]=''  then
						              Tv[i + 3] :=Tv[i + 3] *(vl(Ret[RetNo].Frm[FNo].Strings[4]) / vl(Ret[RetNo].Frm[FNo].Strings[7]));  //mileage  //20230716
						           Tv[8]:=Tv[8]+Tv[i+3]; //20230716
						          End;

						          if (i+3=230) then
						          Begin
						           Tv[i + 3] := Tv[177]* (Tv[i + 1] / 100) * BusDays / MaxBusDays;
						           if Ret[RetNo].Frm[FNo].Strings[206]=''  then
						             Tv[i + 3] :=Tv[i + 3] *(vl(Ret[RetNo].Frm[FNo].Strings[4]) / vl(Ret[RetNo].Frm[FNo].Strings[7]));  //mileage  //20230716
						           Tv[8]:=Tv[8]+Tv[i+3]; //20230716
						          End;
						         // Ret[RetNo].Frm[FNo].Strings[206] = '' then Tv[177]:= Tv[i + 3]; //20230525 Igor probably not needed? //20230716
						        End;
						        //else  Tv[i + 3] := 0;
						      end
						      Else
						      begin
						        Tv[i + 2] := 0;
						        Tv[i + 3] := 0;
						      end;
						     // Tv[8]:=Tv[8]+Tv[i+3]; //20230716 //20230610
						      Inc(i, 6);
						     until i > 227;

						     Tv[173]:=Tv[8];
						     xx:=Tv[8];

						     If Ret[RetNo].Frm[FNo].Strings[206] > '' then
						     Begin
						      Tv[173]:=Tv[177];
						     end;

						     Tv[col18]:=Tv[173]; //Tv[177]; //20230716
						     //Tv[Col18]:= Tv[Col18] * (Tv[4]/Tv[7]); //20260403  Temp
						     xx:=Tv[col18];
						     If Ret[RetNo].Frm[FNo].Strings[23]='' then  Tv[Col19]:=MaxR(0,Tv[Col7]-Tv[177]); //20240317
						     //If Ret[RetNo].Frm[FNo].Strings[23]='' then  Tv[Col19]:=MaxR(0,Tv[Col7]-Tv[Col18]);

						     //20230516
						     Tv[90] := Tv[54];
						    // Tv[185] := Tv[90] + Tv[93];  //not known elm //20230716

						   //terminal loss or Recaoture
						    If (Ret[RetNo].Frm[FNo].Strings[6] > '') //class empty
						    then //20230411 class empty Tv[Col7]<0 then // term loss
						    begin
						     if Cls='10.1' then  //no term loss or recapture
						     Begin
						      Tv[20]:=0;
						      Tv[21]:=0;
						     end
						     Else
						     Begin
						      If Tv[Col7]<0 then  //20230501  Recapture
						      Begin   //ucc + additions < UCC after dispositions then recapturoe
						         Tv[93]:=0; Tv[218]:=0;Tv[224]:=0;Tv[230]:=0;Tv[8]:=0;  //20240309 NOO CCA amounts
						         Tv[21] :=ABS(Tv[Col7]) * (Vl(Ret[RetNo].Frm[FNo].Strings[4])/Vl(Ret[RetNo].Frm[FNo].Strings[7])); //prorate by km use//20240309
						         Tv[177] := 0; // max cca
						         Tv[Col15]:=0;
						         Tv[Col16]:=0; //Term loss
						         Tv[Col18]:=0; //CCA  Tv[173] := 0; // cca
						         Ret[RetNo].Frm[FNo].Strings[col17]:=''; //Rate Strings[170] := ''; // rate
						         Tv[20]:=0; //Tv[176] := 0; // ucc end
						      end
						      Else //Terminal loss
						      Begin
						       Tv[93]:=0; Tv[218]:=0;Tv[224]:=0;Tv[230]:=0;Tv[8]:=0;  //20240309  NO CCA amounts
						       Tv[20] := ABS(Tv[Col7]) * (Vl(Ret[RetNo].Frm[FNo].Strings[4])/vl(Ret[RetNo].Frm[FNo].Strings[7]));   //prorate km //20230309
						       Tv[177] := 0;
						       tv[col18]:=0; //Tv[173] := 0;
						       Tv[col19]:=0; //Tv[167] := 0; // base amount
						       Tv[21]:=0; //recapture
						       Ret[RetNo].Frm[FNo].Strings[col17]:=''; //Strings[170] := ''; // rate
						       Tv[21]:=0; //Tv[176] := 0; // ending ucc
						      End;
						    end;

						     //copy Col[] data into the ELM'sof the form
						    Tv[158]:=Tv[Col3];
						    Tv[44]:=Tv[Col4];
						    Tv[18]:=Tv[Col5];
						    Tv[24]:=Tv[Col6];
						    Tv[46]:=Tv[Col7];
						    Tv[47]:=Tv[Col8];
						    Tv[26]:=Tv[Col9];
						    Tv[49]:=Tv[Col10];
						    Tv[50]:=Tv[Col11];
						    Tv[27]:=Tv[Col12];
						    Tv[52]:=Tv[Col13];
						    Tv[53]:=Tv[Col14];
						    Tv[30]:=Tv[Col15];
						    Tv[167]:=Tv[Col16];
						    Tv[170]:=Tv[Col17];
						   //Tv[173]:=Tv[Col18];  //does nor work-is not needed
						    Tv[176]:=Tv[Col19];
						   end;
						 end;
						  SaveTv(RetNo, FName, FNo); //20230501 Igor
						end;
						*) //Procedure Autos bak


//20251223 Igor >>>
procedure T1134(RetNo: integer; FName: String;FNo: integer);
var
  i: Integer;
  ArrayNo, BoxesPerRow, Elm, ElmDormancy, LastElm, RowCount: Integer;
  AccountNumbers, ForeignAffiliates: TList<string>;
  IncorrectElmIDs: TList<Integer>;
  Value: string;
  MyScrollBox: TvtScrollBox;
begin
 //EXIT;    //20260513

  if FNo=0 then exit; //20260513

  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    for i:= 6 to 14 do Strings[i]:= '';  //rempve t2/t3/partbersh info data o

    Strings[1]:= 'X';   //set for individual
    Strings[2]:= GetFirstName(RetNo);
    Strings[3]:= GetLastName(RetNo);
    Strings[5]:= GetSinNo(RetNo);
    //address of entity
    Strings[15]:= FetchElm(RetNo, 'T1', 6); //20260212 Igor   //street
    Strings[16]:= FetchElm(RetNo, 'T1', 10); //City
    Strings[17]:= FetchElm(RetNo, 'T1', 14); //prov
    Strings[18]:= FetchElm(RetNo, 'T1', 15); //Postal

    if Strings[19].Equals('') then Strings[19]:= AppYear + '-01-01'; //Fisc start
    if Strings[20].Equals('') then Strings[20]:= AppYear + '-12-31'; //Fisc end;

    if Strings[141].Equals('') then Strings[141]:= 'CAN';
    //Otherwise user must select from FCounty.d (No need to maintain anothe table of countries for 2 to 3 char conversion it is an incostistency by CRA

    Strings[142]:= IntToStr(CountMultipleInstances(RetNo, 'T1134S'));

    //Strings[143]:= FetchElm(RetNo,'T2',743); //fname
    //Strings[144]:= FetchElm(RetNo,'T2',742); //Ln
    //Strings[147]:= date
    //if Strings[148].Equals('') then Strings[148]:= FetchElm(RetNo, 'T2', 744); //Position
    //if Strings[23].Equals('') then Strings[23]:= UpperCase(FetchElm(RetNo, 'T2', 743) + ' ' + FetchElm(RetNo, 'T2', 742));

    AccountNumbers:= TList<String>.Create;
    ForeignAffiliates:= TList<String>.Create;
    IncorrectElmIDs:= TList<Integer>.Create;
    try
      if Assigned(RetList[RetNo].MyChild) and (RetList[RetNo].MyChild.ActiveForm <> nil) and SameText(RetList[RetNo].MyChild.ActiveForm.FormName, 'T1134') then
        MyScrollBox:= RetList[RetNo].MyChild.ActiveForm;

      //Reporting taxpayer account number
      AccountNumbers.Add(Strings[5]); //20251229 Igor

      //Individuals
      ArrayNo:= 1;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000 + 10;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);
      for i:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, Elm);

        if not Value.IsEmpty and (AccountNumbers.IndexOf(Value) = -1) then AccountNumbers.Add(Value);

        Elm:= Elm + BoxesPerRow;
      end;

      //Corporations
      ArrayNo:= 2;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000 + 8;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);
      for i:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, Elm);

        if not Value.IsEmpty and (AccountNumbers.IndexOf(Value) = -1) then AccountNumbers.Add(Value);

        Elm:= Elm + BoxesPerRow;
      end;

      // trusts
      ArrayNo:= 3;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000 + 8;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);
      for i:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, Elm);

        if not Value.IsEmpty and (AccountNumbers.IndexOf(Value) = -1) then AccountNumbers.Add(Value);

        Elm:= Elm + BoxesPerRow;
      end;

      //Partnerships
      ArrayNo:= 4;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000 + 8;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);
      for i:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, Elm);

        if not Value.IsEmpty and (AccountNumbers.IndexOf(Value) = -1) then AccountNumbers.Add(Value);

        Elm:= Elm + BoxesPerRow;
      end;

      //Pre populate B other information
      ArrayNo:= 5;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000 + 1;
      LastElm:= Elm;
      //Remove existing account numbers and collect ids with incorrect account numbers
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);
      for i:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, Elm);
        if not Value.IsEmpty then
        begin
          if (AccountNumbers.IndexOf(Value) >= 0) then AccountNumbers.Remove(Value) else IncorrectElmIDs.Add(Elm);
        end else
          IncorrectElmIDs.Add(Elm);

        Elm:= Elm + BoxesPerRow;
        LastElm:= Elm;
      end;

      //Remove rows with incorrect account numbers
      for i:= pred(IncorrectElmIDs.Count) downto 0 do
        if (IncorrectElmIDs[i] < LastElm) then RetList[RetNo].Frm[FNo].DeleteRowData(IncorrectElmIDs[i]);

      //Add new AccountNumbers
      for i:= 0 to pred(AccountNumbers.Count) do
      begin
        Strings[LastElm]:= AccountNumbers.Items[i];
        LastElm:= LastElm + BoxesPerRow;
      end;

      IncorrectElmIDs.Clear;

      //Collect foreign affiliates for 3.D section related corporations
      ArrayNo:= 6;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000 + 3;
      ElmDormancy:= ArrayNo * 10000 + 8;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);
      for i:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, Elm);

        if not Value.IsEmpty and (ForeignAffiliates.IndexOf(Value) = -1) and (FetchElmFNo(RetNo, FNo, ElmDormancy) = 'X') then ForeignAffiliates.Add(Value);

        Elm:= Elm + BoxesPerRow;
        ElmDormancy:= ElmDormancy + BoxesPerRow;
      end;

      //Foreign affiliate
      ArrayNo:= 7;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000 + 1;
      ElmDormancy:= ArrayNo * 10000 + 9;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);
      for i:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, Elm);
        Value:= FetchElmFNo(RetNo, FNo, Elm + 3); //We need to use other FA in dormant section

        if not Value.IsEmpty and (ForeignAffiliates.IndexOf(Value) = -1) and (FetchElmFNo(RetNo, FNo, ElmDormancy) = 'X') then ForeignAffiliates.Add(Value);

        Elm:= Elm + BoxesPerRow;
        ElmDormancy:= ElmDormancy + BoxesPerRow;
      end;

      //Pre populate 3.D dormant foreign affiliates
      ArrayNo:= 10;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000 + 1;
      LastElm:= Elm;

      //Remove existing account numbers and collect ids with incorrect account numbers
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      for i:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, Elm);
        if not Value.IsEmpty then
        begin
          if (ForeignAffiliates.IndexOf(Value) >= 0) then ForeignAffiliates.Remove(Value) else IncorrectElmIDs.Add(Elm);
        end else
          IncorrectElmIDs.Add(Elm);

        Elm:= Elm + BoxesPerRow;
        LastElm:= Elm;
      end;

      //Remove rows with incorrect foreign affiliate names
      for i:= pred(IncorrectElmIDs.Count) downto 0 do
        if (IncorrectElmIDs[i] < LastElm) then RetList[RetNo].Frm[FNo].DeleteRowData(IncorrectElmIDs[i]);

      //Add new foreign affiliate names
      for i:= 0 to pred(ForeignAffiliates.Count) do
      begin
        Strings[LastElm]:= ForeignAffiliates.Items[i];
        LastElm:= LastElm + BoxesPerRow;
      end;

      //Refresh dynamic rows
      if Assigned(MyScrollBox) then MyScrollBox.RebuildDynamicRows;
    finally
      FreeAndNil(AccountNumbers);
      FreeAndNil(ForeignAffiliates);
      FreeAndNil(IncorrectElmIDs);
    end;
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20251223 Igor <<<

//20180612
Procedure T1134S(RetNo: integer; FName: String;FNo: integer); //20230510 Igor
Var i, j, ArrayNo, BoxesPerRow, Elm, RowCount:Integer;
    ArrGroupList: TArray<T1134GroupItem>;
    Value, v: string;
begin
  //EXIT; //20260513
  if FNo=0 then exit; //20260513

  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin

    //20230718 //JZ  shouldnt be done here but did it so to not distrirb the efile for now>>>
    Strings[167] := ExtractFormInst(FName) + ' of ' + inttostr(CountMultipleInstances(RetNo,ExtractNonInstFormName(FName))); // NonInstFormName

    v := '';
    if      trim(Strings[3]) = '1' then v:= 'New'
    else if trim(Strings[3]) = '2' then v:= 'Unmodified'
    else if trim(Strings[3]) = '3' then v:= 'Amended'
    else if trim(Strings[3]) = '4' then v:= 'Delete (Close)';
    Strings[168] := v;

    v := '';
    if      trim(Strings[175]) = '1' then v:= 'Duplicate'
    else if trim(Strings[175]) = '2' then v:= 'Filed in Error'
    else if trim(Strings[175]) = '3' then v:= 'Other';
    Strings[169] := v;
    // <<<


    //20230411 Igor >>>
    Strings[4] := GetT1134ForeignAffiliatesIdentificationNumber(RetNo, Strings[35]);

    ArrGroupList := GetT1134GroupList(RetNo);

    ArrayNo := 1;
    BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
    Elm := ArrayNo * 10000 + 1;
    RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
    For i := 0 to RowCount - 1 do
    begin
      Value := FetchElmFNo(RetNo, FNo, Elm);
      Strings[Elm + 1] := '';
      Strings[Elm + 2] := '';
      Strings[Elm + 3] := '';
      Strings[Elm + 4] := '';
      if not Value.IsEmpty then
        for j := 0 to Length(ArrGroupList) - 1 do
          if SameText(Value, ArrGroupList[j].Name) then
          begin
            case ArrGroupList[j].AccountType of
              atIndividual: Strings[Elm + 2] := ArrGroupList[j].AccountNumber;
              atCorporation: Strings[Elm + 1] := ArrGroupList[j].AccountNumber;
              atTrust: Strings[Elm + 3] := ArrGroupList[j].AccountNumber;
              atPartnership: Strings[Elm + 4] := ArrGroupList[j].AccountNumber
            end;
            break;
          end;
      Elm := Elm + BoxesPerRow;
    end;

    ArrayNo := 4;
    BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
    Elm := ArrayNo * 10000 + 1;
    RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
    For i := 0 to RowCount - 1 do
    begin
      Value := FetchElmFNo(RetNo, FNo, Elm);
      Strings[Elm + 1] := '';
      Strings[Elm + 2] := '';
      Strings[Elm + 3] := '';
      Strings[Elm + 4] := '';
      if not Value.IsEmpty then
        for j := 0 to Length(ArrGroupList) - 1 do
          if SameText(Value, ArrGroupList[j].Name) then
          begin
            case ArrGroupList[j].AccountType of
              atIndividual: Strings[Elm + 2] := ArrGroupList[j].AccountNumber;
              atCorporation: Strings[Elm + 1] := ArrGroupList[j].AccountNumber;
              atTrust: Strings[Elm + 3] := ArrGroupList[j].AccountNumber;
              atPartnership: Strings[Elm + 4] := ArrGroupList[j].AccountNumber
            end;
            break;
          end;
      Elm := Elm + BoxesPerRow;
    end;

    ArrayNo := 12;
    BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
    Elm := ArrayNo * 10000 + 1;
    RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
    For i := 0 to RowCount - 1 do
    begin
      Value := FetchElmFNo(RetNo, FNo, Elm);
      for j := 0 to Length(ArrGroupList) - 1 do
        if SameText(Value, ArrGroupList[j].Name) then
        begin
          Strings[Elm + 1] := ArrGroupList[j].AccountNumber;
          break;
        end;
      Elm := Elm + BoxesPerRow;
    end;

    ArrayNo := 13;
    BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
    Elm := ArrayNo * 10000 + 1;
    RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
    For i := 0 to RowCount - 1 do
    begin
      Value := FetchElmFNo(RetNo, FNo, Elm);
      for j := 0 to Length(ArrGroupList) - 1 do
        if SameText(Value, ArrGroupList[j].Name) then
        begin
          Strings[Elm + 1] := ArrGroupList[j].AccountNumber;
          break;
        end;
      Elm := Elm + BoxesPerRow;
    end;

    ArrayNo := 15;
    BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
    Elm := ArrayNo * 10000 + 1;
    RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
    For i := 0 to RowCount - 1 do
    begin
      Value := FetchElmFNo(RetNo, FNo, Elm);
      for j := 0 to Length(ArrGroupList) - 1 do
        if SameText(Value, ArrGroupList[j].Name) then
        begin
          Strings[Elm + 1] := ArrGroupList[j].AccountNumber;
          break;
        end;
      Elm := Elm + BoxesPerRow;
    end;

    Tv[78]:=Tv[74]+Tv[75];
    Tv[82]:=Tv[80]+Tv[81];
    Tv[86]:=Tv[84]+Tv[85];
    Tv[90]:=Tv[88]+Tv[89];
    Tv[94]:=Tv[92]+Tv[93];
    Tv[98]:=Tv[96]+Tv[97];
    Tv[102]:=Tv[100]+Tv[101];
    Tv[106]:=Tv[104]+Tv[105];
    Tv[110]:=Tv[108]+Tv[109];

    Tv[145]:=0;
    for i in [58,128,130,132,134,136,138,140,142,144] do Tv[145]:=Tv[145]+Tv[i];
    Tv[146]:=0;
    for i in [59,129,131,133,135,137,139,141,143] do Tv[146]:=Tv[146]+Tv[i];
    //20230411 Igor <<<
  end;
  SaveTv(RetNo,FName,FNo);
end;




(* //20240812
//20180507   //20230831 Copied by Con from T2-2024
Procedure T1134(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
    //20230510 Igor >>>
    ArrayNo, BoxesPerRow, Elm, ElmDormancy, LastElm, RowCount: Integer;
    AccountNumbers, ForeignAffiliates: TList<string>;
    IncorrectElmIDs: TList<Integer>;
    Value: string;
    MyScrollBox: TvtScrollBox;
    //20230510 Igor <<<
begin
  LoadTv(RetNo,FName,FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
   for i:=1 to 5 do begin Strings[i]:='';end;
   for i:=9 to 14 do begin Strings[i]:='';end;

   //T1 Only //20230801 Con
   Strings[1]:='X'; //T1 //20230801 Con
   Strings[2]:=GetFirstName(RetNo);
   Strings[3]:=GetLastName(RetNo);
   Strings[5]:=GetSinNo(RetNo); //T1
   //20230811 Igor >>>
   Strings[6]:=''; //T2
   Strings[9]:=''; //T3
   Strings[12]:=''; //T5013
   //20230811 Igor <<<
  // Strings[7]:=GetCorpName(RetNo);  //to be replaced for T1 by Con  //20230801
  // Strings[8]:=GetCorpBusNo(RetNo); //to be replaced for T1 by Con  //20230801

  {
   //T2 only  //20230801
   Strings[15]:=FetchElm(RetNo,'T2',12); //str
   Strings[16]:=FetchElm(RetNo,'T2',16); //City
   Strings[17]:=FetchElm(RetNo,'T2',17); //prov
   Strings[18]:=FetchElm(RetNo,'T2',20); //Postal

   Strings[19]:=FetchElm(RetNo,'T2',10); //Fisc start
   Strings[20]:=FetchElm(RetNo,'T2',11); //Fisc end;
   }

   if Strings[141]=''then Strings[141]:='CAN';  //20180703 CON  (normally  this would come from T2 elm
   //otherwise user must select from FCounty.d (No need to maintain anothe table of countries for 2 to 3 char conversion
   // it is an incostistency by CRA
   Strings[142]:=IntToStr(CountMultipleInstances(RetNo,'T1134S')); //20180612

  //T2 only //20230801 Con
  // Strings[143]:= FetchElm(RetNo,'T2',743); //fname
  // Strings[144]:= FetchElm(RetNo,'T2',742); //Ln
   //Strings[147]:= date
   {T2 Only
   If Strings[148]='' then Strings[148]:= FetchElm(RetNo,'T2',744); //Position
   If Strings[23]='' then Strings[23]:=UpperCase(FetchElm(RetNo,'T2',743)+' '+FetchElm(RetNo,'T2',742));
   }

    //20230510 Igor >>>
    AccountNumbers := TList<String>.Create;
    ForeignAffiliates := TList<String>.Create;
    IncorrectElmIDs := TList<Integer>.Create;
    try
      if Assigned(RetList[RetNo].MyChild) and
         (RetList[RetNo].MyChild.ActiveForm <> nil) and
         SameText(RetList[RetNo].MyChild.ActiveForm.FormName, 'T1134') then
        MyScrollBox := RetList[RetNo].MyChild.ActiveForm;

      // reporting taxpayer account number
      AccountNumbers.Add(Strings[5]);  //20230811 Igor

      // individuals
      ArrayNo := 1;

      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];

      Elm := ArrayNo * 10000 + 10;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo, FNo, Elm);
        if not Value.IsEmpty and (AccountNumbers.IndexOf(Value) = -1) then
          AccountNumbers.Add(Value);
        Elm := Elm + BoxesPerRow;
      end;

      // corporations
      ArrayNo := 2;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000 + 8;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo, FNo, Elm);
        if not Value.IsEmpty and (AccountNumbers.IndexOf(Value) = -1) then
          AccountNumbers.Add(Value);
        Elm := Elm + BoxesPerRow;
      end;

      // trusts
      ArrayNo := 3;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000 + 8;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo, FNo, Elm);
        if not Value.IsEmpty and (AccountNumbers.IndexOf(Value) = -1) then
          AccountNumbers.Add(Value);
        Elm := Elm + BoxesPerRow;
      end;

      // partnerships
      ArrayNo := 4;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000 + 8;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo, FNo, Elm);
        if not Value.IsEmpty and (AccountNumbers.IndexOf(Value) = -1) then
          AccountNumbers.Add(Value);
        Elm := Elm + BoxesPerRow;
      end;

      // pre populate B other information
      ArrayNo := 5;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000 + 1;
      LastElm := Elm;
      // remove existing account numbers and collect ids with incorrect account numbers
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo, FNo, Elm);
        if not Value.IsEmpty then
        begin
          if (AccountNumbers.IndexOf(Value) >= 0) then
            AccountNumbers.Remove(Value)
          else
            IncorrectElmIDs.Add(Elm);
        end
        else
          IncorrectElmIDs.Add(Elm);
        Elm := Elm + BoxesPerRow;
        LastElm := Elm;
      end;

      // remove rows with incorrect account numbers
      For i := IncorrectElmIDs.Count - 1 downto 0 do
        if IncorrectElmIDs[i] < LastElm then
          RetList[RetNo].Frm[FNo].DeleteRowData(IncorrectElmIDs[i]);

      // add new AccountNumbers
      For i := 0 to AccountNumbers.Count - 1 do
      begin
        Strings[LastElm] := AccountNumbers.Items[i];
        LastElm := LastElm + BoxesPerRow;
      end;

      IncorrectElmIDs.Clear;

      // collect foreign affiliates for 3.D section
      // related corporations
      ArrayNo := 6;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000 + 3;
      ElmDormancy := ArrayNo * 10000 + 8;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo, FNo, Elm);
        //20230601 Igor >>> in case if we will need to auto populate these values
        //Strings[Elm + 1] := GetT1134ForeignAffiliatesIdentificationNumber(RetNo, Value);
        //Strings[Elm + 2] := GetT1134ForeignAffiliatesCountryCode(RetNo, Value);
        //20230601 Igor <<<
        if not Value.IsEmpty and (ForeignAffiliates.IndexOf(Value) = -1) and (FetchElmFNo(RetNo, FNo, ElmDormancy) = 'X') then
          ForeignAffiliates.Add(Value);
        Elm := Elm + BoxesPerRow;
        ElmDormancy := ElmDormancy + BoxesPerRow;
      end;

      // foreign affiliate
      ArrayNo := 7;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000 + 1;
      ElmDormancy := ArrayNo * 10000 + 9;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo, FNo, Elm);
        Value := FetchElmFNo(RetNo, FNo, Elm + 3); //20230601 Igor   we need to use other FA in dormant section
        if not Value.IsEmpty and (ForeignAffiliates.IndexOf(Value) = -1) and (FetchElmFNo(RetNo, FNo, ElmDormancy) = 'X') then
          ForeignAffiliates.Add(Value);
        Elm := Elm + BoxesPerRow;
        ElmDormancy := ElmDormancy + BoxesPerRow;
      end;

      // pre populate 3.D dormant foreign affiliates
      ArrayNo := 10;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000 + 1;
      LastElm := Elm;
      // remove existing account numbers and collect ids with incorrect account numbers
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo, FNo, Elm);
        if not Value.IsEmpty then
        begin
          if (ForeignAffiliates.IndexOf(Value) >= 0) then
            ForeignAffiliates.Remove(Value)
          else
            IncorrectElmIDs.Add(Elm);
        end
        else
          IncorrectElmIDs.Add(Elm);
        Elm := Elm + BoxesPerRow;
        LastElm := Elm;
      end;

      // remove rows with incorrect foreign affiliate names
      For i := IncorrectElmIDs.Count - 1 downto 0 do
        if IncorrectElmIDs[i] < LastElm then
          RetList[RetNo].Frm[FNo].DeleteRowData(IncorrectElmIDs[i]);

      // add new foreign affiliate names
      For i := 0 to ForeignAffiliates.Count - 1 do
      begin
        Strings[LastElm] := ForeignAffiliates.Items[i];
        LastElm := LastElm + BoxesPerRow;
      end;

      // refresh dynamic rows
      if Assigned(MyScrollBox) then
        MyScrollBox.RebuildDynamicRows;
    finally
      FreeAndNil(AccountNumbers);
      FreeAndNil(ForeignAffiliates);
      FreeAndNil(IncorrectElmIDs);
    end;
    //20230510 Igor <<<
  end;
  SaveTv(RetNo,FName,FNo);
end;

//20230801 Copied from T2-2024 Con
//20180612
Procedure T1134S(RetNo: integer; FName: String;FNo: integer); //20230510 Igor
Var i, j, ArrayNo, BoxesPerRow, Elm, RowCount:Integer;
    ArrGroupList: TArray<T1134GroupItem>;
    Value, v: string;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin

    //20230718 //JZ  shouldnt be done here but did it so to not distrirb the efile for now>>>
    Strings[167] := ExtractFormInst(FName) + ' of ' + inttostr(CountMultipleInstances(RetNo,ExtractNonInstFormName(FName))); // NonInstFormName

    v := '';
    if      trim(Strings[3]) = '1' then v:= 'New'
    else if trim(Strings[3]) = '2' then v:= 'Unmodified'
    else if trim(Strings[3]) = '3' then v:= 'Amended'
    else if trim(Strings[3]) = '4' then v:= 'Delete (Close)';
    Strings[168] := v;

    v := '';
    if      trim(Strings[175]) = '1' then v:= 'Duplicate'
    else if trim(Strings[175]) = '2' then v:= 'Filed in Error'
    else if trim(Strings[175]) = '3' then v:= 'Other';
    Strings[169] := v;
    // <<<


    //20230411 Igor >>>
    Strings[4] := GetT1134ForeignAffiliatesIdentificationNumber(RetNo, Strings[35]);

    ArrGroupList := GetT1134GroupList(RetNo);

    ArrayNo := 1;
    BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
    Elm := ArrayNo * 10000 + 1;
    RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
    For i := 0 to RowCount - 1 do
    begin
      Value := FetchElmFNo(RetNo, FNo, Elm);
      Strings[Elm + 1] := '';
      Strings[Elm + 2] := '';
      Strings[Elm + 3] := '';
      Strings[Elm + 4] := '';
      if not Value.IsEmpty then
        for j := 0 to Length(ArrGroupList) - 1 do
          if SameText(Value, ArrGroupList[j].Name) then
          begin
            case ArrGroupList[j].AccountType of
              atIndividual: Strings[Elm + 2] := ArrGroupList[j].AccountNumber;
              atCorporation: Strings[Elm + 1] := ArrGroupList[j].AccountNumber;
              atTrust: Strings[Elm + 3] := ArrGroupList[j].AccountNumber;
              atPartnership: Strings[Elm + 4] := ArrGroupList[j].AccountNumber
            end;
            break;
          end;
      Elm := Elm + BoxesPerRow;
    end;

    ArrayNo := 4;
    BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
    Elm := ArrayNo * 10000 + 1;
    RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
    For i := 0 to RowCount - 1 do
    begin
      Value := FetchElmFNo(RetNo, FNo, Elm);
      Strings[Elm + 1] := '';
      Strings[Elm + 2] := '';
      Strings[Elm + 3] := '';
      Strings[Elm + 4] := '';
      if not Value.IsEmpty then
        for j := 0 to Length(ArrGroupList) - 1 do
          if SameText(Value, ArrGroupList[j].Name) then
          begin
            case ArrGroupList[j].AccountType of
              atIndividual: Strings[Elm + 2] := ArrGroupList[j].AccountNumber;
              atCorporation: Strings[Elm + 1] := ArrGroupList[j].AccountNumber;
              atTrust: Strings[Elm + 3] := ArrGroupList[j].AccountNumber;
              atPartnership: Strings[Elm + 4] := ArrGroupList[j].AccountNumber
            end;
            break;
          end;
      Elm := Elm + BoxesPerRow;
    end;

    ArrayNo := 12;
    BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
    Elm := ArrayNo * 10000 + 1;
    RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
    For i := 0 to RowCount - 1 do
    begin
      Value := FetchElmFNo(RetNo, FNo, Elm);
      for j := 0 to Length(ArrGroupList) - 1 do
        if SameText(Value, ArrGroupList[j].Name) then
        begin
          Strings[Elm + 1] := ArrGroupList[j].AccountNumber;
          break;
        end;
      Elm := Elm + BoxesPerRow;
    end;

    ArrayNo := 13;
    BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
    Elm := ArrayNo * 10000 + 1;
    RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
    For i := 0 to RowCount - 1 do
    begin
      Value := FetchElmFNo(RetNo, FNo, Elm);
      for j := 0 to Length(ArrGroupList) - 1 do
        if SameText(Value, ArrGroupList[j].Name) then
        begin
          Strings[Elm + 1] := ArrGroupList[j].AccountNumber;
          break;
        end;
      Elm := Elm + BoxesPerRow;
    end;

    ArrayNo := 15;
    BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
    Elm := ArrayNo * 10000 + 1;
    RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
    For i := 0 to RowCount - 1 do
    begin
      Value := FetchElmFNo(RetNo, FNo, Elm);
      for j := 0 to Length(ArrGroupList) - 1 do
        if SameText(Value, ArrGroupList[j].Name) then
        begin
          Strings[Elm + 1] := ArrGroupList[j].AccountNumber;
          break;
        end;
      Elm := Elm + BoxesPerRow;
    end;

    Tv[78]:=Tv[74]+Tv[75];
    Tv[82]:=Tv[80]+Tv[81];
    Tv[86]:=Tv[84]+Tv[85];
    Tv[90]:=Tv[88]+Tv[89];
    Tv[94]:=Tv[92]+Tv[93];
    Tv[98]:=Tv[96]+Tv[97];
    Tv[102]:=Tv[100]+Tv[101];
    Tv[106]:=Tv[104]+Tv[105];
    Tv[110]:=Tv[108]+Tv[109];

    Tv[145]:=0;
    for i in [58,128,130,132,134,136,138,140,142,144] do Tv[145]:=Tv[145]+Tv[i];
    Tv[146]:=0;
    for i in [59,129,131,133,135,137,139,141,143] do Tv[146]:=Tv[146]+Tv[i];
    //20230411 Igor <<<
  end;
  SaveTv(RetNo,FName,FNo);
end;
*)

//jz//20260127-- should not have been removed //20260106
Procedure HOMEWS(RetNo: integer; FName: string; FNo: integer);
var
  i, j: integer;
  x,x1, x2: Real;
Begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
    // Strings[172]:='Y';
    If ret[RetNo].MarStatus > 2 then
    begin
      If Tv[171] = 0 then
        Tv[171] := 100;
      Tv[172] := 0;
      // If Strings[172]>'' then Strings[172]:='N';
    end;
    If Tv[171] > 100 then
      Tv[171] := 100;
    If Tv[171] + Tv[172] > 100 then Tv[172] := 0;
    if ret[RetNo].MarStatus < 3 then
      Tv[172] := 100 - Tv[171]; // 20161127

    // ditto handling
    i := 7;
    repeat
      If IsDitto(Strings[i]) then
        Strings[i] := Strings[i - 5];
      If IsDitto(Strings[i + 1]) then
        Strings[i + 1] := Strings[i + 1 - 5];
      inc(i, 5);
    until i > 157;

    Tv[161] := 0;
    i := 5;
    Repeat
      Tv[161] := Tv[161] + Tv[i];
      x:=Tv[i];   //temp debug  //20231209
      inc(i, 5);
    until i > 160;
    Tv[161] := Tv[161] + Tv[162];
    Tv[165] := MinR(20000, MaxR(0, Tv[161])); //20221127 MinR(10000, MaxR(0, Tv[161]));
    Tv[166] := Tv[165] * (MaxR(0, (100 - Tv[171]) / 100));
    Tv[170] := MaxR(0, Tv[165] - Tv[166]);
    X1:=Tv[171];
  end;
  SaveTv(RetNo, FName, FNo);

  If (ret[RetNo].CouplingSw) and (OptimizeBtnClicked = False) then
  begin
    StoreElm(RetNo, GetFormNo('OPTIMIZE'), 64, FormatFloat('###.##', X1));  //20231208
    StoreElm(RetNo, GetFormNo('OPTIMIZE'), 65, FormatFloat('###.##', 100 - X1));
  end;
end;

//jz//20260210 - new code for updated form
Procedure RC381(RetNo: integer; FName: String; FNo: integer);

  //jz//20260210 - not sure this is a good idea but use for ease of programming, there must be a better way of doing it
  const prt3Ln: array[1..93] of integer =
                  (
//001,002,003,004,005,006,007,008,009,010,011,012,013,014,015,016,017,018,019,
000,000,005,000,000,000,000,000,000,000,017,000,000,000,000,000,000,000,019,
//020,021,022,023,024,025,026,027,028,029,030,031,032,033,034,035,036,037,038,039,
000,000,000,000,272,273,000,000,000,000,000,280,000,000,000,000,000,000,000,288,
//040,041,042,043,044,045,046,047,048,049,050,051,052,053,054,055,056,057,058,059,
000,000,000,000,296,297,000,300,000,302,303,000,306,307,308,000,311,312,000,315,
//060,061,062,063,064,065,066,067,068,069,070,071,072,073,074,075,076,077,078,079,
317,318,319,000,322,323,000,326,328,329,333,000,000,000,000,000,470,000,000,000,
//080,081,082,083,084,085,086,087,088,089,090,091,092,093
000,208,000,337,000,000,000,000,000,000,000,000,000,000
                  );


Var
  i: integer;
  CppMonths: integer;
  CPPProrate, qppProrate, x,x1, MxCpp, MxQpp,TempValue: Real;
  StopMonth, Birthmonth: String;

  CPPRetirementMonths: integer;
  CPPRetirementProrate: Real;

  SkipPart4, SkipPart5: Boolean;
  sumLnnNo, sumElmNo: integer;

  {
  //jz//20260210 - was going to use but changed my mind, leave here for now

prt3Ln003Amt,prt3Ln011Amt,prt3Ln019Amt,prt3Ln024Amt,prt3Ln025Amt,prt3Ln031Amt,
prt3Ln039Amt,prt3Ln044Amt,prt3Ln045Amt,prt3Ln047Amt,prt3Ln049Amt,prt3Ln050Amt,
prt3Ln052Amt,prt3Ln053Amt,prt3Ln054Amt,prt3Ln056Amt,prt3Ln057Amt,prt3Ln059Amt,
prt3Ln060Amt,prt3Ln061Amt,prt3Ln062Amt,prt3Ln064Amt,prt3Ln065Amt,prt3Ln067Amt,
prt3Ln068Amt,prt3Ln069Amt,prt3Ln070Amt,prt3Ln081Amt,prt3Ln083Amt:real;
  }




//-------------------

                      Function getPensionableNetSelfEmploymentEarnings(RetNo: integer):real;
                      begin
                         //20250206
 result:=(Ret[RetNo].Lnn[12200]+Vl(FetchElm(RetNo,'T1',37))) * CPPProrate;

                         If IsDeceased(RetNo) then
result:=(Ret[RetNo].Lnn[12200]+Vl(FetchElm(RetNo,'T1',37)));

                               //used this , changed to above which is the same pretty much
                               // (ret[RetNo].Lnn[12200] + ret[RetNo].Lnn[13500] +
                               //   ret[RetNo].Lnn[13700] + ret[RetNo].Lnn[13900] +
                               //   ret[RetNo].Lnn[14100] + ret[RetNo].Lnn[14300]) * CPPProrate;//1

                                //If IsDeceased(RetNo) then
                                //  Tv[349] := (ret[RetNo].Lnn[12200] + ret[RetNo].Lnn[13500] + ret[RetNo].Lnn
                                //    [13700] + ret[RetNo].Lnn[13900] + ret[RetNo].Lnn[14100] + ret[RetNo].Lnn
                                //    [14300]); // 20141114

                                //result := maxR(0,result);

                      end;



//-------------------

                      Procedure ClearPart4;
                      Var
                        i: integer;
                      Begin
                        with ret[RetNo].Frm[FNo] do
                        begin
                          for i := 349 to 369 do Tv[i] := 0;
                          for i := 11 to 153 do Tv[i] := 0;
                        end;
                      end;

                      Procedure ClearPart5;
                      Var
                        i: integer;
                      Begin
                        with ret[RetNo].Frm[FNo] do
                        begin
                          for i := 154 to 261 do  Tv[i] := 0; // 20200129
                          for i := 370 to 395 do Tv[i] := 0; // 20200129
                        end;
                      end;

//-------------------

                      Function requireRC381Part3ab(RetNo, FNo, fromPart:integer):boolean;
                      begin
                        result := false;

                        //requirePart3ab different when from 4 or 5

                        if fromPart = 4 then
                        begin
                          //Note: If lines 70 and 83 are both "0", return to Part 3 (page 7) and follow the instructions to calculate your claim for the tax
                          //credit, deduction, and overpayment for the contributions on your employment income
                          if (ret[RetNo].Frm[FNo].Tv[170] = 0) and  (ret[RetNo].Frm[FNo].Tv[102] = 0) then
                            result := true;
                        end
                        else if fromPart = 5 then
                        begin
                          //Note: If lines 68 and 81 are both "0", return to Part 3 (page 7) and follow the instructions to calculate your claim for the
                          //tax credit and deduction for the contributions on your employment income
                          if (ret[RetNo].Frm[FNo].Tv[405] = 0) and  (ret[RetNo].Frm[FNo].Tv[248] = 0) then
                            result := true;
                        end;
                      end;

                      Function requireRC381Part4(RetNo, FNo:integer):boolean;
                      begin
                          result := false;

                          //if ( ( getPensionableNetSelfEmploymentEarnings(RetNo) > 0 ) or (FetchElm(RetNo, 'CPT20', 80) = 'Y') ) and   //replace IsSelfEmployed with getPensionableNetSelfEmploymentEarnings

                          //jz//20250614//s8rev+rc381rev - add (Ret[RetNo].Lnn[12200] > 0)
                          if ( ( IsSelfEmployed(RetNo) ) or (Ret[RetNo].Lnn[12200] > 0) or (FetchElm(RetNo, 'CPT20', 80) = 'Y') ) and
                             ( Ret[RetNo].lnn[10100] > 0 ) and
                             ( ret[RetNo].Province <> 'QC' )
                          then
                            result := true;
                      end;

//-------------------

                      Function requireRC381Part5(RetNo, FNo:integer):boolean;
                      begin
                          result := false;

                          //If  ( ( getPensionableNetSelfEmploymentEarnings(RetNo) > 0 ) or (FetchElm(RetNo, 'CPT20', 80) = 'Y') ) and  //replace IsSelfEmployed with getPensionableNetSelfEmploymentEarnings

                          //jz//20250614//s8rev+rc381rev - add (Ret[RetNo].Lnn[12200] > 0)
                          If  ( ( IsSelfEmployed(RetNo)  ) or (Ret[RetNo].Lnn[12200] > 0) or (FetchElm(RetNo, 'CPT20', 80) = 'Y') ) and
                              ( Ret[RetNo].lnn[10100] > 0 ) and
                              ( Ret[RetNo].Province = 'QC' )
                          then
                            result := true;
                      end;

//-------------------

                      Procedure rc381Part3ab(RetNo, FNo:integer);
                      begin
                        //jz//20250227 add 3a,3b if else
                        //part 3a line 69 positive but not zero
                        if not (ret[RetNo].Frm[FNo].Tv[prt3Ln[69]] <= 0) then
                        begin
                          //page 8
                          with ret[RetNo].Frm[FNo] do
                          begin
                            Tv[333]:=Tv[prt3Ln[52]];  //70
                            Tv[330]:=Tv[prt3Ln[59]];  //71
                            Tv[331]:=Tv[prt3Ln[67]];  //72
                            Tv[332]:=Tv[330]+Tv[331]; //73
                            Tv[334]:=Tv[prt3Ln[69]];  //74
                          end;
                        end
                        //part 3b line 69 is 0 or less than
                        else
                        begin
                          with ret[RetNo].Frm[FNo] do
                          begin
                            //jz//20260210 - form changes >-->-------------------->

                            //If line 53 is positive or "0", enter the amount from line 52 at line 75 and line 81, and continue at
                            //line 82. If not, enter the amount from line 49 and continue at line 76.
                            if Tv[prt3Ln[53]]>=0 then
                            begin
                              Tv[335]:=Tv[prt3Ln[52]]; //ln75
                              Tv[208]:=Tv[prt3Ln[52]]; //ln81 //jz//20260210- change back //20251217 Igor - change from Tv[208] to [209]
                            end
                            else
                            begin
                              Tv[335]:=Tv[302]; //ln75

                              xx := Tv[302];
                              xx := Tv[335];

                              Tv[470]:= abs(Tv[prt3Ln[52]]); //ln76

                              //If the amount at line 53 is negative and line 60 is positive,
                              //enter whichever is less: amount from line 60 or line 76. If not, enter "0".
                              if (Tv[prt3Ln[53]] < 0) and (Tv[prt3Ln[60]] > 0) then
                                Tv[471]:= minR(Tv[prt3Ln[60]],Tv[470])  //ln77
                              else
                                Tv[471]:= 0;       //ln77

                              Tv[472]:= Tv[471];       //ln77

                              Tv[473]:= Tv[470] - Tv[471]; //ln78
                              Tv[474]:= Tv[335] + Tv[472]; //ln79

                              //If line 68 and line 78 are both positive, enter whichever is less. If not, enter "0"
                              if (Tv[prt3Ln[68]] > 0) and (Tv[473] > 0) then  Tv[475]:= minr(Tv[prt3Ln[68]],Tv[473]) //ln80
                              else             Tv[475]:= 0;                            //ln80

                              Tv[208]:= Tv[474] + Tv[475]; //ln81

                            end;

                            //jz//20260210 - form changes <--<--------------------<

                                      //jz//20260210 - all this is wrong when did the form change?????
                                      {
  Tv[476]:= Tv[328] * vl(Strings[8]);//ln81
  Tv[477]:= Tv[475] - Tv[476];//ln82

  //If line 81 is positive, complete line 83. If not, enter "0" and continue at line 84.
  if Tv[476] > 0 then
  begin
    //If line 60 is positive or "0", enter the amount from line 81.
    //If line 60 is negative, multiply the amount from line 81 by 83.1933%.
    if Tv[317] >= 0 then
      Tv[478]:= Tv[476] //ln83
    else
      Tv[478]:= Tv[476] * (83.1933 / 100); //ln83
  end
  else
    Tv[478]:= 0;//ln83

  //If line 82 is positive, complete line 84. If not, enter "0" and continue at line 85.
  if Tv[477] > 0 then
  begin
    //If line 60 is positive or "0", enter the amount from line 82.
    //If line 60 is negative, multiply the amount from line 82 by 84.3750%.
    if Tv[317] >= 0 then
      Tv[479]:= Tv[477]//ln84
    else
       Tv[479]:= Tv[477] * (84.3750 / 100);//ln84
  end
  else
    Tv[479]:= 0;//ln83


  Tv[202]:= Tv[478] + Tv[479];//ln85
  Tv[203]:= Tv[202];//ln85
  Tv[208]:= Tv[474] + Tv[203];//ln86


end;
                                      }
                            //jz//s8rev+rc381rev//20250531 <--<--------------------<



                            //jz//20260210 >-->-------------------->
                            //If line 60 is positive or "0", enter the amount from line 59 at line 82 and line 88, and continue at
                            //line 89. If not, enter the amount from line 56 and continue at line 83.
                            if Tv[prt3Ln[60]]>=0 then  //line 87
                            Begin
                              Tv[336]:=Tv[prt3Ln[59]];  //82
                              Tv[212]:=Tv[prt3Ln[59]];  //88
                            end
                            Else
                            Begin
                              Tv[336]:=Tv[prt3Ln[56]];  //82

                              if Tv[prt3Ln[60]] < 0 then
                                Tv[337]:=ABS(Tv[317]);  //83

                              //If line 53 is positive, enter whichever is less:
                              //amount from line 53 or line 83. If not, enter "0".
                              if Tv[prt3Ln[53]]>0 then Tv[214]:=MinR(Tv[prt3Ln[53]],Tv[337]) //84
                              else Tv[214]:=0;                           //84

                              Tv[339]:=Tv[214];         //84
                              Tv[340]:=Tv[337]-Tv[214]; //85
                              Tv[209]:=Tv[336]+Tv[339]; //86

                              //If line 68 and line 85 are both positive, enter whichever is less: amount from line 85 or
                              //the result of line 68 minus line 80. If not, enter "0".
                              if (Tv[prt3Ln[68]] > 0) and (Tv[340] > 0) then Tv[211]:=minr(Tv[340],Tv[prt3Ln[68]]-Tv[475])   //87
                              else             Tv[211]:=0;                                     //87

                              Tv[212]:=Tv[209]+Tv[211]; //93
                            end;

                            //jz//20260210 <--<--------------------<

                            //jz//20260210 >-->-------------------->

                            //If line 68 is positive or "0", enter the amount from line 67 at line 89
                            //and line 92, and continue at line 93. If not, enter the amount from line 64
                            //and continue at line 90.
                            if Tv[prt3Ln[68]]>=0 then //line 68 //jz//20250327 - add > as per cra email
                            begin
                               Tv[342]:=Tv[prt3Ln[67]]; //89
                               Tv[346]:=Tv[prt3Ln[67]]; //89
                            end
                            else
                            begin
                              Tv[342]:=Tv[prt3Ln[64]]; //89

                              if Tv[prt3Ln[68]] < 0 then
                                Tv[343]:=ABS(Tv[prt3Ln[68]]);  //90

                              //Tv[344]
                              If Tv[prt3Ln[61]] > 0 then Tv[344]:=MinR(Tv[prt3Ln[61]],tv[343])  //91
                              Else  Tv[344]:=0;                            //91

                              Tv[345]:=Tv[342]+Tv[344];  //92
                              Tv[346]:=Tv[345];  //92
                            end;

                            Tv[348]:=Tv[212]+Tv[346];  //93
                            //jz//20260210 <--<--------------------<

                          end; //end with page8
                        end; //end else part 3b
                      end;


//-------------------


                      Procedure rc381Part4(RetNo, FNo:integer);
                      begin

                          //NOTE: elm clearing and if satisfies self employment, have employment and not in QC is done somewhere else

                              //PART 4, page 10
                              with ret[RetNo].Frm[FNo] do
                              begin
                                Tv[349] := getPensionableNetSelfEmploymentEarnings(RetNo);

                                If GetPlacementOfficeIncome(RetNo) > 0 then
                                  Tv[349] := MaxR(0, Tv[349] - GetPlacementOfficeIncome(RetNo));//1

                                Tv[350] := vl(FetchElm(RetNo, 'CPT20', 19));//2
                                Tv[351] := vl(FetchElm(RetNo, 'CPT20', 20));//3
                                Tv[352] := maxR(0,Tv[349] + Tv[350] + Tv[351]);   //4 //profile and TCycle do not allow negative for somereason

                                Tv[353] := Tv[19];//5


{
                                //If line 61 of Part 3 is positive, complete lines 6 to 12.
                                //If not, enter "0" on line 12 and continue at line 13.
                                if Tv[318] > 0 then // line 61 in Part3
                                begin
                                  Tv[11] := Tv[300];          //6
                                  Tv[12] := Tv[303];          //7
                                  Tv[13] := Tv[11] - Tv[12];  //8
                                  Tv[14] := Tv[13];           //8
                                  Tv[15] := Tv[308];          //9
                                  Tv[16] := Tv[312];          //10
                                  Tv[18] := Tv[15] - Tv[16];  //11
                                  Tv[20] := Tv[18];           //11
                                  Tv[21] := Tv[14] + Tv[20];  //12
                                  Tv[22] := Tv[21];           //12
                                end
                                else
                                  Tv[22] := 0; //12

                                Tv[23] := Tv[353] + Tv[22]; //13

                                //If line 61 of Part 3 is negative and line 68 of Part 3 is positive, complete lines 14 to 25.
                                //If not, enter "0" on line 25 and continue at line 26.

                                if (Tv[318] < 0) and (Tv[328] > 0) then
                                begin
                                  Tv[433] := abs(Tv[318]);    //14
                                  Tv[24] := Tv[300];          //15
                                  Tv[25] := Tv[303];          //16
                                  Tv[26] := Tv[24] - Tv[25];  //17
                                  Tv[27] := Tv[26];           //17
                                  Tv[28] := Tv[308];          //18
                                  Tv[29] := Tv[312];          //19
                                  Tv[30] := Tv[28] - Tv[29];  //20
                                  Tv[31] := Tv[30];           //20

                                  //(if negative, enter as a positive amount; if not, enter "0")
                                  Tv[32] := Tv[27] + Tv[31];  //21
                                  if Tv[32] < 0 then
                                    Tv[32] := abs(Tv[32])
                                  else Tv[32] := 0;           //21
                              //PART 4, page 10 //end; //cant use with start and end on new pages as if spans pages

                              // PART 4, Page 11 //with ret[RetNo].Frm[FNo] do begin ////cant use with start and end on new pages as if spans pages
                                  Tv[33] := Tv[23];      //22

                                  xx := Tv[33];
                                  xx := Tv[23];

                                  //If line 21 is positive and less than line 14, enter the result of
                                  //line 21 divided by line 14 (calculated to the fifth decimal place without
                                  //rounding). If not, enter "0".
                                  if (Tv[32] > 0) and (Tv[32] < Tv[433]) then
                                    strings[34] := FormatFloat('#.00000', Tv[32] / Tv[433]) //23
                                  else
                                    strings[34] := '0';               //23

                                  //If line 69 of Part 3 is positive or "0", enter whichever is less: line 21 or
                                  //line 68 of Part 3. If not, enter the result of line 21 multiplied by the rate
                                  //at line 23.
                                  if Tv[329] >= 0 then
                                    Tv[35] := minr(Tv[32], Tv[328])     //24
                                  else
                                    Tv[35] := Tv[32] * vl(strings[34]); //24

                                  Tv[36] := minR(Tv[32],Tv[35]);      //25
                                  Tv[37] := Tv[36];      //25
                                end
                                else
                                  Tv[37] := 0; //25
}

                                //jz//20260208
                                //If line 61 of Part 3 is:
                                //• "0", do not complete lines 6 to 24. Enter the amount from line 5 on line 26 and continue at line 27.
                                //• positive, complete lines 6 to 13 only, and continue at line 25.
                                //• negative, enter the amount from line 5 on line 13 and continue at line 14.
                                if      Tv[318] = 0 then // line 61 in Part3 is 0
                                begin
                                  Tv[38] := Tv[353];         //26
                                end
                                else
                                begin
                                  if Tv[318] > 0 then // line 61 in Part3 is +
                                  begin
                                    Tv[11] := Tv[300]; //6
                                    Tv[12] := Tv[303]; //7
                                    Tv[13] := Tv[11] - Tv[12]; //8
                                    Tv[14] := Tv[13];  //8
                                    Tv[15] := Tv[308]; //9
                                    Tv[16] := Tv[312]; //10
                                    Tv[18] := Tv[15] - Tv[16]; //11
                                    Tv[20] := Tv[18];  //11
                                    Tv[21] := Tv[14] + Tv[20]; //12
                                    Tv[22] := Tv[21];  //12
                                    Tv[23] := Tv[353] + Tv[22]; //13
                                  end
                                  else                     // line 61 in Part3 is -
                                  begin
                                    Tv[22] := 0; //12
                                    Tv[23] := Tv[353]; //13

                                    Tv[433]:= abs(Tv[318]); //14
                                    Tv[24] := Tv[19];  //15
                                    Tv[25] := Tv[272]; //16
                                    Tv[26] := Tv[24] - Tv[25]; //17
                                    Tv[27] := Tv[26];  //17
                                    if Tv[27] < 0 then Tv[28] := abs(Tv[27])  //17A
                                    else               Tv[28] := 0;           //17A
                                    Tv[29] := Tv[288]; //18
                                    Tv[466]:= Tv[296]; //19
                                    Tv[30] := Tv[29] - Tv[466]; //20
                                    Tv[31] := Tv[30];  //20

                                    //If line 17 and line 20 are both negative or either amount is "0", enter "0".
                                    //If line 17 is positive, enter the amount from line 17 (show in brackets).
                                    //If line 20 is positive, enter whichever is less: amount from line 20 or line 17A.
                                    if ((Tv[27] < 0) and (Tv[31] < 0) ) or
                                       ((Tv[27] = 0) or  (Tv[31] = 0) )
                                    then                    Tv[32] := 0                     //21
                                    else if Tv[27] > 0 then Tv[32] := Tv[27]                //21
                                    else if Tv[31] > 0 then Tv[32] := minR(Tv[31],Tv[28]);  //21
                                    xx := Tv[32];

                                    //If line 17A is more than line 14, enter "1". If not, enter the result of line 17A divided by line 14
                                    //(calculated to the fifth decimal place without rounding).
                                    if      Tv[28]  > Tv[433] then strings[33] := '1'                                    //22
                                    else if Tv[433] > 0  then strings[33] := FormatFloat('#.00000', Tv[28]/Tv[433]); //22
                                    xx := Tv[33];

                                    //If line 69 of Part 3 is positive or "0", enter whichever is less: amount from line 68 of Part 3 or
                                    //line 17A. If not, enter the result of line 68 of Part 3 multiplied by the rate at line 22.
                                    if Tv[329] >= 0 then Tv[34] := minr(Tv[328],Tv[28])       //23
                                    else                 Tv[34] := Tv[328] * vl(strings[33]); //23
                                    xx := Tv[34];

                                    Tv[35] := minr(Tv[28],Tv[34]);       //24
                                  end;

                                  Tv[36] := Tv[23];  //25
                                  Tv[37] := Tv[32];  //25A
                                  Tv[38] := Tv[35]+Tv[36]+Tv[37]; //26
                                end;

                                Tv[39]  := Tv[38]; //27
                                Tv[45]  := Tv[39] * 16.80672;  //27


                                //jz//20260208
                                //If line 61 of Part 3 is:
                                //• "0", do not complete lines 29 to 39. Complete line 28 and enter the amount on line 40 and continue at line 41.
                                //• positive, complete lines 28 to 32 only, and continue at line 40.
                                //• negative, complete line 28 and enter "0" at line 31 and continue at line 32.

                                Tv[361] := Tv[288];  //28  -put outside the if as always complete 28

                                if      Tv[318] = 0 then    // line 61 in Part3 is 0
                                begin
                                  Tv[86]  := Tv[361]; //40
                                end
                                else
                                begin
                                  if Tv[318] > 0 then  // line 61 in Part3 is +
                                  begin
                                    Tv[46]  := Tv[318];  //29
                                    Tv[47]  := Tv[22]; //30
                                    Tv[48]  := Tv[46]-Tv[47] ; //31
                                    Tv[49]  := Tv[48]; //31
                                    Tv[50]  := Tv[361] - Tv[49]; //32
                                    Tv[51]  := Tv[50]; //32
                                  end
                                  else                      // line 61 in Part3 is -
                                  begin
                                    Tv[49]  := 0;  //31
                                    Tv[50]  := Tv[361] - Tv[49]; //32
                                    Tv[51]  := Tv[50]; //32

                                    Tv[54]  := abs(Tv[318]); //33

                                    if Tv[28] > 0 then Tv[65] := minR(Tv[28],Tv[54])  //34
                                    else               Tv[65] := 0;                   //34

                                    Tv[85]  := Tv[54] - Tv[65];  //35

                                    if Tv[328] > 0 then Tv[81] := Tv[328]             //34
                                    else                Tv[81] := 0;                  //34

                                    Tv[82]  := Tv[35];   //37
                                    Tv[83]  := Tv[81] - Tv[82];  //38
                                    Tv[84]  := minR(Tv[85],Tv[83]); //39
                                  end;

                                  Tv[86]  := Tv[51] + Tv[80] + Tv[84];   //40

                                end;

                                Tv[87]  := Tv[86];     //41
                                strings[467] := '15.625';    //41
                                Tv[88]  := Tv[87] * vl(strings[467]); //41
                                Tv[89]  := Tv[45] + Tv[88];    //42



{
                                Tv[361] := Tv[288];  //28

                                if Tv[318] > 0 then
                                begin
                                  Tv[46]  := Tv[318];         //29
                                  Tv[47]  := Tv[22];          //30
                                  Tv[48]  := Tv[46]-Tv[47] ;  //31
                                  Tv[49]  := Tv[48];          //31
                                end
                                else
                                  Tv[49]  := 0;               //31


                                Tv[50]  := Tv[361] - Tv[49];  //32
                                Tv[51]  := Tv[50];            //32


                                //If line 61 of Part 3 is negative and line 68 of Part 3 is positive,
                                //complete lines 33 to 39. If not, enter "0" on line 39 and continue at line 40
                                if (Tv[318] < 0) and (Tv[328] > 0) then
                                begin
                                  Tv[54]  := abs(Tv[318]);    //33
                                  Tv[65]  := Tv[32];          //34
                                  Tv[80]  := Tv[54] - Tv[65]; //35
                                  Tv[81]  := Tv[328];         //36
                                  Tv[82]  := Tv[37];          //37
                                  Tv[83]  := Tv[81] - Tv[82]; //38
                                  Tv[84]  := minR(Tv[80],Tv[83]); //39
                                  Tv[85]  := Tv[84];          //39
                                end
                                else
                                  Tv[85]  := 0; //39
}
                              end;
                              // PART 4, Page 11

                              // PART 4, Page 12
                              with ret[RetNo].Frm[FNo] do
                              begin
                                Tv[90]  := Tv[273]; //43
                                //If line 68 of Part 3 is positive, complete lines 44 to 46.
                                //If not, enter "0" on line 46 and continue at line 47.
                                if Tv[328] > 0 then
                                begin
                                  Tv[91]  := Tv[319]; //44
                                  Tv[95]  := Tv[323]; //45
                                  Tv[96]  := Tv[91]-Tv[95]; //46
                                  Tv[97]  := Tv[96];  //46
                                end
                                else
                                  Tv[97]  := 0;               //46

                                Tv[98]  := Tv[90] - Tv[97];   //47
                                Tv[124]  := Tv[98];           //47


                                Tv[125]  := Tv[297];          //48
                                //If line 68 of Part 3 is positive, complete lines 49 to 51.
                                //If not, enter "0" on line 51 and continue at line 52.
                                if Tv[328] > 0 then
                                begin
                                  Tv[126]  := Tv[328]; //49
                                  Tv[128]  := Tv[97];  //50
                                  Tv[131]  := Tv[126] - Tv[128]; //51
                                  Tv[132]  := Tv[131]; //51
                                end
                                else
                                  Tv[132]  := 0;           //52

                                Tv[134]  := Tv[125] - Tv[132]; //52
                                Tv[135]  := Tv[134]; //52
                                Tv[136]  := Tv[124] + Tv[135]; //53

                                //If line 61 of Part 3 is positive and line 68 of Part 3 is negative, complete lines 54 and 55.
                                //If not, enter "0" on line 55 and continue at line 56
                                if (Tv[318] > 0) and (Tv[328] < 0) then
                                begin
                                  Tv[137]  := abs(Tv[328]); //54
                                  Tv[138]  := minR(Tv[318],Tv[137]);  //55
                                  Tv[139]  := Tv[138];     //55
                                end
                                else
                                  Tv[139]  := 0;     //55

                                Tv[140]  := Tv[136] + Tv[139];  //56

                                Tv[141]  := Tv[106];     //57
                                Tv[142]  := Tv[108];     //58
                                Tv[143]  := maxR(0,minR(Tv[141]-Tv[142], 67800)); //59
                                Tv[144]  := Tv[89];    //60
                                Tv[145]  := maxR(0,Tv[143] - Tv[144]);//61
                                Tv[146]  := minR(Tv[352], Tv[145]);   //62

                                //If line 3 of Part 3 is less than line 58, complete lines 63 to 69.
                                //If not, enter "0" on line 69 and continue at line 70.
                                if Tv[5] < Tv[142]then
                                begin
                                  Tv[147]  := Tv[142];        //63
                                  Tv[159]  := Tv[5];          //64
                                  Tv[160]  := Tv[147] - Tv[159]; //65

                                  if Tv[160] < 0 then
                                  begin
                                    Tv[160] := 0;
                                    Tv[169] := 0;
                                  end
                                  else
                                  begin
                                    Tv[161]  := Tv[352];  //66
                                    Tv[162]  := Tv[143];  //67
                                    Tv[163]  := maxR(0,Tv[161]-Tv[162]);  //68
                                    Tv[166]  := Tv[163];  //68
                                    Tv[167]  := maxR(0,Tv[160]-Tv[166]);  //69
                                    Tv[169]  := Tv[167];  //69
                                  end;
                                end
                                else
                                  Tv[169] := 0;        //69

                                Tv[170]  := Tv[146]-Tv[169];    //70

                              end;
                              // PART 4, Page 12

                              // PART 4, Page 13  =============
                              with ret[RetNo].Frm[FNo] do
                              begin
                                Tv[172]  := Tv[352];    //71
                                Tv[177]  := Tv[17];     //72
                                Tv[178]  := Tv[280];    //73
                                Tv[180]  := Tv[172]+Tv[177]+Tv[178];  //74

                                //If line 74 is more than line 57, complete lines 75 to 83.
                                //If not, enter "0" on line 83 and continue at line 84.
                                if Tv[180] > Tv[141] then
                                begin
                                  Tv[92]  := Tv[109];    //75
                                  Tv[181] := Tv[140];    //76
                                  Tv[93]  := Tv[181] / 0.04;  //76
                                  Tv[94]  := maxr(0,Tv[92] - Tv[93]); //77
                                  Tv[99]  := Tv[352];    //78
                                  Tv[55]  := Tv[160];    //79
                                  Tv[101] := Tv[99] - Tv[55]; //80
                                  Tv[100] := Tv[170];    //81
                                  Tv[56]  := Tv[101] - Tv[100]; //82
                                  Tv[102] := MinR(Tv[94], Tv[56]);    //83
                                end
                                else
                                begin
                                  Tv[102] := 0;  //83
                                end;

                                //Note: If lines 70 and 83 are both "0", return to Part 3 (page 7) and follow the instructions to calculate your claim for the tax
                                //credit, deduction, and overpayment for the contributions on your employment income
                                if requireRC381Part3ab(RetNo, FNo, 4) then //leave part 4 and go to part 3ab
                                begin
                                  rc381Part3ab(RetNo, FNo);
                                  exit; //else or exit???? //do not continue this after
                                end;
                                //else or exit?

                                Tv[104] := Tv[170];           //84
                                Tv[105] := MinR(6712.20, Tv[104] * 9.9 / 100); //84
                                Tv[107] := Tv[170];          //85
                                Tv[52] := MinR(1356, Tv[107] * 2 / 100);    //85
                                Tv[110] := Tv[102];          //86
                                Tv[111] := MinR(792, Tv[110] * 8 / 100);    //86
                                Tv[112] := Tv[52] + Tv[111];      //87
                                Tv[113] := Tv[112];          //87
                                Tv[118] := Tv[105] + Tv[113];     //88
                                Tv[53] := MaxR(0, Tv[329]);   //89
                                Tv[120] := Tv[53] * 2;  //89

                                //Line 88 minus 89. If positive, enter the amount (in dollars and cents) on line 42100 of your
                                //return and continue at line 92. If negative, show in brackets and continue at line 91.
                                Tv[121] := Tv[118] - Tv[120]; //90
                                if Tv[121] > 0 then
                                begin
                                  Tv[122] := 0;  //91
                                  Tv[123] := 0;  //91
                                end
                                else
                                begin
                                  Tv[122] := abs(Tv[121]);   //91
                                  Tv[123] := Tv[122] * (50 / 100);  //91
                                end;

                              end;
                              // PART 4, Page 13  =============


                              // PART 4, Page 14  =============
                              with ret[RetNo].Frm[FNo] do
                              begin
                                //If line 53 of Part 3 is positive or "0", enter the amount from line 52 of Part 3 at line 92 and line 98,
                                //and continue at line 99. If not, enter the amount from line 49 of Part 3 and continue at line 93.
                                if Tv[307] >= 0 then
                                begin
                                  Tv[182] := Tv[306]; //92
                                  Tv[127] := Tv[306]; //98
                                end
                                else
                                begin
                                  Tv[182] := Tv[302];       //92
                                  Tv[186] := abs(Tv[307]);  //93

                                  if Tv[317] > 0 then
                                    Tv[187] := minR(Tv[186],Tv[317])  //94
                                  else
                                    Tv[187] := 0;

                                  Tv[188] := Tv[187];  //94
                                  Tv[189] := Tv[186] - Tv[188]; //95
                                  Tv[191] := Tv[182] + Tv[188]; //96

                                  //If line 68 of Part 3 and line 95 are both positive, enter whichever is less.
                                  //If not, enter "0".
                                  if (Tv[328] > 0) and (Tv[189] > 0) then
                                    Tv[192] := minR(Tv[328],Tv[189])    //97
                                  else
                                    Tv[192] := 0;      //97

                                  Tv[127] := Tv[191] + Tv[192]; //98
                                end;

                                //If line 60 of Part 3 is positive or "0", enter the amount from line 59 of Part 3 at line 99 and line 105,
                                //and continue at line 106. If not, enter the amount from line 56 of Part 3 and continue at line 100.
                                if Tv[317] >= 0 then
                                begin
                                  Tv[133] := Tv[315]; //99
                                  Tv[199] := Tv[315]; //105
                                end
                                else
                                begin
                                  Tv[133] := Tv[311];       //99
                                  Tv[193] := abs(Tv[317]);  //100


                                  if Tv[307] > 0 then
                                    Tv[194] := minR(Tv[307], Tv[193])   //101
                                  else
                                      Tv[194] := 0;      //101

                                  Tv[195] := Tv[194];      //101

                                  Tv[196] := Tv[193] - Tv[195]; //102
                                  Tv[197] := Tv[133] + Tv[195]; //103

                                  //If line 68 of Part 3 and line 102 are both positive, enter whichever is less: amount from line 102
                                  //or the result of line 68 of Part 3 minus line 97. If not, enter "0".
                                  if (Tv[328] > 0) and (Tv[196] > 0) then
                                    Tv[198] := MINr(Tv[196], Tv[328]-Tv[192])   //104
                                  else
                                    Tv[198] := 0; //104

                                  Tv[199] := Tv[197] + Tv[198];           //105
                                end;

                                //If line 68 of Part 3 is positive or "0", enter the amount from line 67 of
                                //Part 3 at line 106 and line 109, and continue at line 110. If not, enter the
                                //amount from line 64 of Part 3 and continue at line 107
                                if Tv[328] >= 0 then
                                begin
                                  Tv[200] := Tv[326]; //106
                                  Tv[206] := Tv[326]; //109
                                end
                                else
                                begin
                                  Tv[200] := Tv[322];       //106
                                  Tv[202] := abs(Tv[328]);  //107

                                  //If line 61 of Part 3 is positive and line 68 of Part 3 is negative,
                                  //enter whichever is less: amount from line 61 of Part 3 or line 107.
                                  //If not, enter "0"
                                  if Tv[318] > 0 then
                                    Tv[203] := minR(Tv[318],Tv[202])  //108
                                  else
                                    Tv[203] := 0;  //108

                                  Tv[206] := Tv[200] + Tv[203]; //109
                                end;

                                Tv[148] := Tv[199] + Tv[206]; //110


                              end;
                              // PART 4, Page 14  =============

                              // PART 4, Page 15  =============
                              with ret[RetNo].Frm[FNo] do
                              begin
                                Tv[149]:=Tv[105];  //111
                                Tv[150]:=Tv[149]*(50/100); //111
                                //NOTE - line 31000 populated at summary //Ret[RetNo].lnn[31000] := Tv[150];  //20241210 ???

                                Tv[57]:=Tv[52];  //112
                                Tv[151]:=Tv[57]*50/100;  //112

                                Tv[58]:=Tv[150]+Tv[151]; //113
                                Tv[59]:=MaxR(0, Tv[329]);  //114
                                Tv[60]:=Tv[58]-Tv[59]; //115

                                Tv[61]:=MinR(Tv[58],Tv[59]);  //A

                                xx:= Tv[58];
                                xx:= Tv[59];
                                xx:= Tv[61];


                                Tv[62]:=Tv[61]*83.1933/100;  //116
                                Tv[63]:=Tv[62];  //117
                                Tv[64]:=Tv[61]-Tv[63]; //118

                                Tv[66]:=Tv[150]; //119

                                Tv[67] :=Tv[62];  //120
                                Tv[68] := Tv[66] - Tv[67];  //121
                                Tv[69] :=Tv[68];  //121
                                Tv[215]:=Tv[151]; //122
                                Tv[70] :=Tv[215]; //122
                                Tv[71] :=Tv[64];  //123
                                Tv[72] :=Tv[70]-TV[71]; //124
                                Tv[73] :=Tv[72];  //124
                                Tv[74] :=Tv[111]; //125
                                Tv[75] :=Tv[74]*50/100; //125
                                Tv[76] :=Tv[75];  //126

                                //jz//20260210
                                //If line 115 is negative, enter it as a positive amount.
                                //If line 115 is positive or "0", enter the amount from line 126 on line 128
                                //and continue at line 129.
                                if Tv[60] < 0 then
                                begin
                                  Tv[77]:=Abs(Tv[60]);     //127
                                  Tv[78] := maxR(0,Tv[76] - Tv[77]);  //128
                                  Tv[79] := Tv[78];    //128
                                end
                                else
                                begin
                                  Tv[79]:=Tv[76];  //127
                                end;
                                Tv[153]:= Tv[69]+Tv[70]+Tv[73]+Tv[75]+Tv[79]; //129
                               end;
                              // PART 4, Page 15  =============

                      end; //rc381Part4();

//-------------------

                      Procedure rc381Part5(RetNo, FNo:integer);
                      begin

                            //PART 5 residents of QC with self employment and employment income
                            //check if have self employment, have employment and is in QC

                            //PART 5, Page 16
                            with ret[RetNo].Frm[FNo] do
                            begin

                              if Tv[154] < 0 then Tv[154] := 0; //1
                              //Tv[155] := vtUser  //2
                              Tv[156] := Tv[154] + Tv[155];  //3

                              Tv[157] := Tv[19];//line4 //line 19 of Part 3

                              //jz20260208
                              //If line 61 of Part 3 is:
                              //• "0", do not complete lines 5 to 23. Enter the amount from line 4 on line 24 and continue at line 25.
                              //• positive, complete lines 5 to 12 only, and continue at line 24.
                              //• negative, enter the amount from line 4 on line 12 and continue at line 13.
                              if Tv[318] = 0 then           // line 61 in Part3 is zero
                              begin
                                Tv[247] := Tv[157]; //24
                              end
                              else
                              begin
                                if Tv[318] > 0 then         // line 61 in Part3 is +
                                begin
                                  Tv[216] := Tv[300];  //5
                                  Tv[217] := Tv[303];  //6
                                  Tv[218] := Tv[216] - Tv[217]; //7
                                  Tv[219] := Tv[218];  //7
                                  Tv[220] := Tv[308];  //8
                                  Tv[227] := Tv[312];  //9
                                  Tv[228] := Tv[220] - Tv[227]; //10
                                  Tv[229] := Tv[228];  //10
                                  Tv[230] := Tv[219] + Tv[229]; //11
                                  Tv[231] := Tv[230];  //11
                                  Tv[232] := Tv[157] - Tv[231]; //12

                                  Tv[242] := 0;  //20 clear just in case
                                  Tv[246] := 0;  //23
                                end
                                else                        // line 61 in Part3 is -
                                begin
                                  Tv[231] := 0;        //11
                                  Tv[232] := Tv[157];  //12

                                  Tv[233] := abs(Tv[318]); //13
                                  Tv[234] := Tv[19];   //14
                                  Tv[235] := Tv[272];  //15
                                  Tv[236] := Tv[234] - Tv[235]; //16

                                  if Tv[236] < 0 then Tv[237] := abs(Tv[236])  //16A
                                                 else Tv[237] := 0;            //16A

                                  Tv[238] := Tv[288];  //17
                                  Tv[239] := Tv[296];  //18
                                  //Tv[240] := Tv[238] - Tv[239];    //19 removed
                                  Tv[241] := Tv[238] - Tv[239];  //19


                                  //If line 16 and line 19 are both negative or either amount is "0", enter "0".
                                  //If line 16 is positive, enter the amount from line 16 (show in brackets).
                                  //If line 19 is positive, enter whichever is less: amount from line 19 or line 16A.
                                  if ((Tv[236] < 0) and (Tv[241] < 0) ) or
                                     ((Tv[236] = 0) or  (Tv[241] = 0) )
                                  then Tv[242] := 0                      //20
                                  else if Tv[236] > 0 then Tv[242] := Tv[236]                //20
                                  else if Tv[241] > 0 then Tv[242] := minR(Tv[241],Tv[237]); //20
                                  xx := Tv[242];

                                  //If line 16A is more than line 13, enter "1". If not, enter the result of line 16A
                                  //divided by line 13 (calculated to the fifth decimal place without rounding).
                                  if      Tv[237] > Tv[233] then strings[243] := '1'  //21
                                  else if Tv[233] > 0  then strings[243] := FormatFloat('#.00000', Tv[237] / Tv[233]) //21//do not div by zero
                                  else  strings[243] := '0'; //21

                                  //If line 69 of Part 3 is positive or "0", enter whichever is less:
                                  //amount from line 68 of Part 3 or line 16A. If not, enter the result of
                                  //line 68 of Part 3 multiplied by the rate at line 21.
                                  if Tv[329] >= 0 then
                                    Tv[244] := minr(Tv[328], Tv[237])       //22
                                  else
                                    Tv[244] := Tv[238] * vl(strings[243]);  //22

                                  Tv[245] := minR(Tv[237],Tv[244]);        //23
                                  Tv[246] := Tv[245];        //23
                                end;
                                Tv[247]  := Tv[232]+Tv[242]+Tv[246];         //24
                              end;
                            end;
                            //PART 5, page 16

                            //PART 5, Page 17
                            with ret[RetNo].Frm[FNo] do
                            begin
                              Tv[164]  := Tv[247]; //25
                              Tv[165]  := Tv[164] * 16.80672; //25


                              //If line 61 of Part 3 is:
                              //• "0", do not complete lines 26 to 37. Complete line 26 and enter the amount on line 38 and continue at line 39.
                              //• positive, complete lines 26 to 30 only, and continue at line 38.
                              //• negative, complete line 26 and enter "0" at line 29 and continue at line 30.

                              Tv[261] := Tv[288];             //26
                              if      Tv[318] = 0 then       // line 61 in Part3 is 0
                              begin
                                Tv[362] := Tv[261];           //26
                              end
                              else
                              begin
                                if Tv[318] > 0 then     // line 61 in Part3 is +
                                begin
                                  Tv[168]  := Tv[318]; //27
                                  Tv[173]  := Tv[231]; //28
                                  Tv[174]  := Tv[168]-Tv[173]; //29
                                  Tv[175]  := Tv[174]; //29
                                  Tv[338]  := Tv[261] - Tv[175]; //30
                                  Tv[341]  := Tv[338]; //30
                                end
                                else                      // line 61 in Part3 is -
                                begin
                                  Tv[175]  := 0; //29
                                  Tv[338]  := Tv[261] - Tv[175]; //30
                                  Tv[341]  := Tv[338]; //30

                                  Tv[347]  := abs(Tv[318]);  //31

                                  //If line 16A is positive, enter whichever is less:
                                  //amount from line 16A or line 31. If not, enter "0".
                                  if Tv[237] > 0 then Tv[354] := minR(Tv[237],Tv[347])  //32
                                                 else Tv[354] := 0;                     //32

                                  Tv[355]  := Tv[347]-Tv[354]; //33

                                  //If line 33 and line 16 are both positive, enter the amount from line 16.
                                  //If line 33 is "0" and line 19 is positive, enter the amount from line 19
                                  //(show in brackets). If not, enter "0".
                                  if      (Tv[355] > 0) and (Tv[236] > 0) then Tv[359] := Tv[236]   //33A
                                  else if (Tv[355] = 0) and (Tv[241] > 0) then Tv[359] := Tv[241]   //33A
                                  else              Tv[359] := 0;        //33A
                                  xx := Tv[359];

                                  if Tv[328] > 0 then Tv[356] := Tv[328]   //34
                                  else                Tv[356]  := 0;        //34

                                  Tv[357]  := Tv[246];     //35
                                  Tv[358]  := Tv[356]-Tv[357];     //36

                                  Tv[360]  := minr(Tv[355],Tv[358]);  //37
                                end;
                                Tv[362]  := Tv[341]+Tv[359]+Tv[360];  //38
                              end;

                              Tv[363]  := Tv[362];     //39
                              Tv[364]  := Tv[363]*15.625;    //39
                              Tv[365]  := Tv[165]+Tv[364];     //40

                              end;
                              // PART 5, Page 17


                              // PART 5, Page 18
                              with ret[RetNo].Frm[FNo] do
                              begin
                                Tv[176]  := Tv[273]; //41

                                //If line 68 of Part 3 is positive, complete lines 42 to 44.
                                //If not, enter "0" on line 44 and continue at line 45.
                                if Tv[328] > 0 then
                                begin
                                  Tv[366]  := Tv[319]; //42
                                  Tv[367]  := Tv[323]; //43
                                  Tv[368]  := Tv[366]-Tv[367]; //44
                                  Tv[369]  := Tv[368]; //44
                                end
                                else
                                  Tv[369]  := 0; //44

                                Tv[370]  := Tv[176] - Tv[369]; //45
                                Tv[371]  := Tv[370]; //45

                                Tv[190]  := Tv[297]; //46

                                //If line 68 of Part 3 is positive, complete lines 47 to 49.
                                //If not, enter "0" on line 49 and continue at line 50.
                                if Tv[328] > 0 then
                                begin
                                  Tv[372]  := Tv[328]; //47
                                  Tv[373]  := Tv[369]; //48
                                  Tv[374]  := Tv[372]-Tv[373]; //49
                                  Tv[375]  := Tv[374]; //49
                                end
                                else
                                  Tv[375]  := 0; //49

                                Tv[376]  := Tv[190]-Tv[375]; //50
                                Tv[377]  := Tv[376]; //50
                                Tv[378]  := Tv[371]-Tv[377]; //51

                                //If line 61 of Part 3 is positive and line 68 of Part 3 is negative, complete lines 52 and 53.
                                //If not, enter "0" on line 53 and continue at line 54.
                                if (Tv[318] > 0) and (Tv[328] < 0) then
                                begin
                                  Tv[379]  := abs(Tv[328]); //52
                                  Tv[380]  := minR(Tv[318],Tv[379]);  //53
                                  Tv[381]  := Tv[380];     //53
                                end
                                else
                                  Tv[381]  := 0;     //53

                                Tv[382]  := Tv[378] + Tv[381];  //54

                                Tv[221]  := Tv[115];     //55
                                Tv[222]  := Tv[116];     //56
                                Tv[223]  := maxR(0,minR(Tv[221]-Tv[222], 67800)); //57
                                Tv[224]  := Tv[365];     //58
                                Tv[225]  := maxR(0,Tv[223]-Tv[224]);  //59
                                Tv[226]  := minR(Tv[156],Tv[225]);    //60

                                //If line 3 of Part 3 is less than line 56, complete lines 61 to 67.
                                //If not, enter "0" on line 67 and continue at line 68.
                                if Tv[5] < Tv[222]then
                                begin
                                  Tv[383]  := Tv[222]; //61
                                  Tv[384]  := Tv[5]; //62
                                  Tv[385]  := Tv[383] - Tv[384]; //63

                                  if Tv[385] < 0 then
                                  begin
                                    Tv[385] := 0; //63
                                    Tv[396] := 0; //67
                                  end
                                  else
                                  begin
                                    Tv[386]  := Tv[156];  //64
                                    Tv[387]  := Tv[223];  //65
                                    Tv[388]  := maxR(0,Tv[386]-Tv[387]);  //66
                                    Tv[389]  := Tv[388];  //66
                                    Tv[390]  := maxR(0,Tv[385]-Tv[389]);  //67
                                    Tv[396]  := Tv[390];  //67
                                  end;
                                end
                                else
                                  Tv[396]  := 0;         //67

                                Tv[405]  := Tv[226]-Tv[396];    //68

                              end;
                              // PART 5, Page 18

                              // PART 5, Page 19  =============
                              with ret[RetNo].Frm[FNo] do
                              begin
                                Tv[420]  := Tv[156];    //69
                                Tv[421]  := Tv[17];     //70
                                Tv[424]  := Tv[280];    //71
                                Tv[426]  := Tv[420]+Tv[421]+Tv[424];  //72

                                //If line 72 is more than line 55, complete lines 73 to 81.
                                //If not, enter "0" on line 81 and continue at line 82.
                                if Tv[426] > Tv[221] then
                                begin
                                  Tv[427] := Tv[117];    //73
                                  Tv[429] := Tv[382];    //74
                                  Tv[430] := Tv[429] / 0.04;  //74
                                  Tv[432] := maxr(0,Tv[427] - Tv[430]); //75
                                  Tv[434] := Tv[156];    //76
                                  Tv[435] := Tv[385];    //77
                                  Tv[436] := Tv[434] - Tv[435];   //78
                                  Tv[438] := Tv[405];    //79
                                  Tv[439] := Tv[436] - Tv[438]; //80
                                  Tv[248] := MinR(Tv[432], Tv[439]);    //81
                                end
                                else
                                begin
                                  Tv[248] := 0;    //81
                                end;

                                //Note: If lines 68 and 81 are both "0", return to Part 3 (page 7) and follow the instructions to calculate your claim for the
                                //tax credit and deduction for the contributions on your employment income
                                if requireRC381Part3ab(RetNo, FNo, 5) then //leave part 5 and go to part 3ab
                                begin
                                  rc381Part3ab(RetNo, FNo);
                                  exit; //else or exit???? //do not continue this after
                                end;

                                Tv[249] := Tv[405];          //82
                                Tv[250] := MinR(7322.40, Tv[249] * 0.108);  //82
                                Tv[251] := Tv[405];          //83
                                Tv[252] := MinR(1356, Tv[251] * 0.02);      //83
                                Tv[253] := Tv[248];      //84
                                Tv[254] := MinR(792, Tv[253] * 0.08);   //84
                                Tv[255] := Tv[252] + Tv[254]; //85
                                Tv[256] := Tv[255];      //85
                                Tv[257] := Tv[250] + Tv[256]; //86
                                if Tv[329] > 0 then
                                begin
                                  Tv[258] := Tv[329];      //87
                                  Tv[259] := Tv[258] * 2; //87
                                end
                                else
                                begin
                                  Tv[258] := 0;      //87
                                  Tv[259] := 0;      //87
                                end;
                                Tv[260] := Tv[257] - Tv[259]; //88

                              end;
                              // PART 5, Page 19  =============

                              // PART 5, Page 20  =============
                              with ret[RetNo].Frm[FNo] do
                              begin
                                //If line 53 of Part 3 is positive or "0", enter the amount from line 52 of Part 3 at line 89 and line 95,
                                //and continue at line 96. If not, enter the amount from line 49 of Part 3 and continue at line 90.
                                if Tv[307] >= 0 then
                                begin
                                  Tv[441] := Tv[306]; //89
                                  Tv[505] := Tv[306]; //95
                                end
                                else
                                begin
                                  Tv[441] := Tv[302];       //89
                                  Tv[442] := abs(Tv[307]);  //90

                                  //If line 53 of Part 3 is negative and line 60 of Part 3 is positive,
                                  //enter whichever is less: amount from line 60 of Part 3 or line 90.
                                  //If not, enter "0".
                                  if Tv[317] > 0 then
                                    Tv[444] := minR(Tv[317],Tv[442])  //91
                                  else
                                    Tv[444] := 0;    //91

                                  Tv[445] := Tv[444];  //91
                                  Tv[447] := Tv[442] - Tv[445]; //92
                                  Tv[448] := Tv[441] + Tv[445]; //93

                                  //If line 68 of Part 3 and line 92 are both positive, enter whichever is less. If not, enter "0
                                  if (Tv[328] > 0) and (Tv[447] > 0) then
                                    Tv[450] := minR(Tv[328],Tv[447])    //94
                                  else
                                    Tv[450] := 0;      //94

                                  Tv[505] := Tv[448] + Tv[450];   //95
                                end;

                                //If line 60 of Part 3 is positive or "0", enter the amount from line 59 of Part 3 at line 96 and line 102,
                                //and continue at line 103. If not, enter the amount from line 56 of Part 3 and continue at line 97.
                                if Tv[317] >= 0 then
                                begin
                                  Tv[451] := Tv[315];       //96
                                  Tv[460] := Tv[315];       //102
                                end
                                else
                                begin
                                  Tv[451] := Tv[311];       //96
                                  Tv[453] := abs(Tv[317]);  //97


                                  if Tv[307] > 0 then
                                    Tv[454] := minR(Tv[307], Tv[453])   //98
                                  else
                                      Tv[454] := 0;      //98
                                  Tv[456] := Tv[454];      //98

                                  Tv[457] := Tv[453] - Tv[456];   //99
                                  Tv[458] := Tv[451] + Tv[456];   //100

                                  //If line 68 of Part 3 and line 99 are both positive, enter whichever is less: amount from line 99 or
                                  //the result of line 68 of Part 3 minus line 94. If not, enter "0
                                  if (Tv[328] > 0) and (Tv[457] > 0) then
                                    Tv[459] := minR(Tv[457], Tv[328]-Tv[450])   //101
                                  else
                                    Tv[459] := 0; //101

                                  Tv[460] := Tv[458] + Tv[459];           //102
                                end;

                                //If line 68 of Part 3 is positive or "0", enter the amount from line 67 of
                                //Part 3 at line 103 and line 106, and continue at line 107. If not, enter the
                                //amount from line 64 of Part 3 and continue at line 104
                                if Tv[328] >= 0 then
                                begin
                                  Tv[461] := Tv[326]; //103
                                  Tv[464] := Tv[326]; //106
                                end
                                else
                                begin
                                  Tv[461] := Tv[322];       //103
                                  Tv[462] := abs(Tv[328]);  //104

                                  //If line 61 of Part 3 is positive and line 68 of Part 3 is negative,
                                  //enter whichever is less: amount from line 61 of Part 3 or line 104.
                                  //If not, enter "0"
                                  if Tv[318] > 0 then
                                    Tv[463] := minR(Tv[318],Tv[462])  //105
                                  else
                                    Tv[463] := 0;    //105

                                  Tv[464] := Tv[461] + Tv[463]; //106
                                end;

                                Tv[391] := Tv[460] + Tv[464]; //107

                              end;
                              // PART 5, Page 20  =============

                              // PART 5, Page 21  =============
                              with ret[RetNo].Frm[FNo] do
                              begin


                                Tv[392] := Tv[250];       //108
                                Tv[393] := Tv[392] * 0.5; //108

                                Tv[397] := Tv[252];       //109
                                Tv[394] := Tv[397] * 0.5; //109

                                Tv[398] := Tv[393] + Tv[394]; //110

                                if Tv[329] > 0 then
                                  Tv[399] := Tv[329]   //111
                                else
                                  Tv[399] := 0;        //111

                                Tv[400] := Tv[398] - Tv[399]; //112

                                Tv[401] := MinR(Tv[398], Tv[399]);  //A
                                Tv[402] := Tv[401] * 0.84375; //113
                                Tv[403] := Tv[402];  //114
                                Tv[404] := Tv[401] - Tv[403]; //115

                                Tv[406] := Tv[393];//116
                                Tv[407] := Tv[402];//117
                                Tv[408] := Tv[406] - Tv[407]; //118
                                Tv[409] := Tv[408];  //118
                                Tv[465] := Tv[394];  //119
                                Tv[410] := Tv[465];  //119
                                Tv[411] := Tv[404];  //120
                                Tv[412] := Tv[410] - Tv[411]; //121
                                Tv[413] := Tv[412];  //121
                                Tv[414] := Tv[254];  //122
                                Tv[415] := Tv[414] * 0.5;  //122
                                Tv[416] := Tv[415];  //123

                                //jz//20260216 - change on form not captured, fix form, update code to reflect
                                //If line 112 is negative, enter it as a positive amount.
                                //If line 112 is positive or "0", enter the amount from line 123 on line 125
                                //and continue at line 126.
                                if Tv[400] < 0 then
                                begin
                                  Tv[417] := abs(Tv[400]); //124
                                  Tv[418] := Tv[416] - Tv[417]; //125
                                  Tv[419] := Tv[418];  //125
                                end
                                else
                                  Tv[419] := Tv[416];  //124  //jz//20260216 - as per form Tv[417] := Tv[416];  //124

                                Tv[395] := Tv[409] + Tv[410] + Tv[413] + Tv[415] + Tv[419]; //126

                              end;
                              // PART 5, Page 21  =============

                      end; //END rc381Part5

//-------------------

begin  //Procedure RC381(RetNo: integer; FName: String; FNo: integer);

  LoadTv(RetNo, FName, FNo);

  //jz//20250227 ///clear all $ in RC381 before starting, extremly necessary due to all the ifs
  for i:= 1 to 509 do
  begin
    //skip init of user input elms //20250313
    //doesnt do much as these are vtStrings and they are not blankded, only vtDollar
    if (i=129) or (i=130) or  //pg2 - Date CPT30 was signed with Employer (YYYY-MM-DD)
       (i=42)  or (i=43)  or  //pg2 - Election or revocation
       (i=40)  or (i=41)      //pg3 - number of months that CPP/QPP applied
    then begin continue end
    else begin ret[RetNo].Frm[FNo].Tv[i] := 0; end;
  end;



  if Rc381InEffect(RetNo) = False then  //20250118
  begin
   With Ret[RetNo] do
   Begin
     SaveTv(RetNo, FName, FNo); //jz//20250305 - save the clear that happens above
     EXIT;
     {//20250120
     Lnn[31000]:=0;
     Lnn[22200]:=0;
     Lnn[30800]:=0;
     Lnn[22215]:=0;
     Lnn[44800]:=0;
     Lnn[50329]:=0;
     Lnn[50330]:=0;
     Lnn[50331]:=0;
     Lnn[50339]:=0;
     Lnn[50340]:=0;
     Lnn[50371]:=0;
     Lnn[50329]:=0;

     Lnn[50341]:=0;
     Lnn[50372]:=0;
     Lnn[50373]:=0;
     Lnn[50374]:=0;
     Lnn[50399]:=0;
     EXIT;  //209241222
     }
   end;
  end;

  ret[RetNo].Lnn[30800] := 0;
  ret[RetNo].Lnn[44800] := 0;
  ret[RetNo].Lnn[42100] := 0;
  ret[RetNo].Lnn[22200] := 0;
  ret[RetNo].Lnn[31000] := 0;

  //RC381 PG2
  with ret[RetNo].Frm[FNo] do
  begin
    // 20140315
    If vl(Strings[42]) > 12 then
      Strings[42] := '12'; // 20130315
    If vl(Strings[42]) = 0 then
      Strings[42] := ''; // 20130315

    If Strings[42] > '' then
      Strings[42] := AddLeadingZeros(Strings[42], 2);
    StopMonth := Strings[42]; // 20140315
    If (vl(StopMonth) > 12) then
    begin
      StopMonth := '12';
      Strings[42] := '12';
    end; // 20140315

    If (ret[RetNo].Age < 65) or (ret[RetNo].Age > 70) then
    begin
      StopMonth := '';
      Strings[42] := '';
    end;

    If ret[RetNo].Age = 65 then
    begin
      Birthmonth := MidStr(GetDateOfBirth(RetNo), 6, 2);
      If (StopMonth > '') and (StopMonth < Birthmonth) then
      begin
        StopMonth := '';
        Strings[42] := '';
      end;
    end;
    If ret[RetNo].Age = 70 then
    begin
      Birthmonth := MidStr(GetDateOfBirth(RetNo), 6, 2);
      If MyStrToInt(StopMonth) < 1 then
      begin
        StopMonth := '';
        Strings[42] := '';
      end;
    end;

    //RC381 PG3
    StopMonth := AllTrim(IntToStr(MyStrToInt(Strings[42]) - 1));
    If UpperCase(Strings[44]) <> 'Y' then
    Begin
      // cpp
      CppMonths := GetCppMonthsForRc381(RetNo);
      CPPRetirementMonths:= getCPPRetirementMonths(RetNo, CppMonths); //jz//20250204 - add CppRetirementMonths

      If vl(Strings[42]) > 0 then
        CppMonths := MyStrToInt(StopMonth); // 20140316
      If CppMonths < 0 then CppMonths := 0; // 20130304
      Strings[40] := IntToStr(CppMonths);
      // qpp
      Strings[41] := IntToStr(GetQppMonthsForRc381(RetNo));
      If (ret[RetNo].Age >= 70) then Strings[41] := '12'; // 20131211
    end;

    If vl(Strings[40]) > 12 then Strings[40] := '12';
    If vl(Strings[41]) > 12 then Strings[41] := '12';

    if      CPPRetirementMonths > 12 then CPPRetirementMonths:= 12
    else if CPPRetirementMonths = 0  then CPPRetirementMonths:= 12; //jz//20260202 - if then 0 no proration

    CPPRetirementProrate:= CPPRetirementMonths / 12;

    CPPProrate := vl(Strings[40]) / 12;
    qppProrate := vl(Strings[41]) / 12;

  //use 0 instead of RY  retirn yer if assitional related, 1 would meand for next yer = iknown
  //Max cpp related
  //20241121 ===
  //??? //20241121GetMaxCPPAdditionalAmounts(RetNo,Months,MaxAdditionalCPPPensionableEarnings,MaxAdditionalCppContributions:Real);
  //--
  Tv[103]:= Constant[RY].MaxAdditionalCppPensionableEarnings  * CPPProrate;
  Tv[106]:= Constant[RY].MaxCppPensionableEarnings            * CPPProrate;           //as in old Tv[10
  Tv[108]:= Constant[RY].BasicCppExemption                    * CPPRetirementProrate;  //jz//20250204 - change to CppRetirementMonths //20241210//Constant[RY].BasicCppExemption;
  Tv[109]:= Constant[RY].MaxAdditionalCPPContributions        * CPPProrate;  //20241210//Constant[0].MaxAdditionalCPPContributions;

  //Max Qpp related - //jz//20250227 use qppProrate not CPPProrate
  Tv[114]:= Constant[RY].MaxAdditionalQppPensionableEarnings  * qppProrate;
  Tv[115]:= Constant[RY].MaxCPPPensionableEarnings            * qppProrate;  //as in old Tv[10  //20250212 //instead odmaxqpp (thesame)
  Tv[116]:= Constant[RY].BasicCppExemption                    * qppProrate; //20241210//Constant[RY].BasicCppExemption; //same as CPP
  Tv[117]:= Constant[RY].MaxAdditionalQppContributions        * qppProrate; //20241210//Constant[0].MaxAdditionalQppContributions;

 end; //jz 20241120 - added this end and changed location of end of comment below

  //PART3
  //page 5 and Page 6 Page 7 and page 8
  with ret[RetNo].Frm[FNo] do
  begin
    //20241121                   *4.
    Tv[3] := GetCPPPensionableEarnings(RetNo, Constant[RY].MaxAdditionalQPPPensionableEarnings); //jz//20250321 - Constant[RY].MaxCPPPensionable);//1
    Tv[4] := GetQPPPensionableEarnings(RetNo, Constant[RY].MaxAdditionalQPPPensionableEarnings); //jz//20250321 - Constant[RY].MaxCPPPensionable);//2
    Tv[5]:=Tv[3]+Tv[4];//5
    Tv[6]:=Tv[3];//4
    Tv[7]:=Tv[5];//5

    If Tv[7] > 0 then                                       //jz//20260216 - avoid division by zero
    begin
      //jz//20260216 - take 6 decimal places to avoid rounding on 5th decimal then
                  // - take 7 spots from the begining so to get the unrounded 5 decimal places as per form instruction
      Strings[8] := FormatFloat('0.000000', Tv[6] / Tv[7]); //6
      Strings[8] := leftstr(Strings[8],7);                  //6
    end
    else
      Strings[8] := '';                                     //6


   Tv[152]:=Tv[103] * Vl(Strings[8]);  //e //7
   TV[158]:=Tv[106] * Vl(Strings[8]);  //c //8
   TV[171]:=Tv[108] * Vl(Strings[8]);  //f //9
   TV[179]:=Tv[109] * Vl(Strings[8]);  //d //10

   Tv[17]:=MinR(Tv[3],Tv[152]);//11


   if Tv[5]>TV[106] then //jz//20250227 [115] wrong elm //if Tv[5]>TV[115] then   //20250212
   begin
    Tv[119]:=Tv[17];//12
    Tv[183]:=Tv[158];//13
    Tv[184]:=maxR(0,Tv[119]-Tv[183]); //14 //jz20251128 - as per form update/cra email
   end
   Else
   Begin
    Tv[119]:=0;//12
    Tv[183]:=0;//13
    Tv[184]:=0;//14
   end;

   Tv[185]:=MinR(Tv[179],Tv[184]);//15
   Tv[262]:=Tv[17]-Tv[185]; //if neg? //16
   Tv[263]:=Tv[171];//17

   Tv[264]:=Maxr(0,Tv[262]-Tv[263]);//18
   Tv[19]:= GetActualCPPPremiums(RetNo); // 50340 //19
   Tv[265]:=Tv[19];
   Tv[266]:=Tv[265]*83.1933/100;  //20241217 //20

   Tv[267]:=Tv[19]-Tv[266];//21
   Tv[268]:=Tv[264];
   Tv[269]:=MinR(3356.10, Tv[268] * 4.95/100);//22 //jz//2025formupdate - new max from 3217.50
   Tv[270]:=Tv[264]; //20241211
   Tv[271]:=MinR(678, Tv[270] * 1/100);//23 //jz//2025formupdate - new max from 650
   Tv[272]:=Tv[269]+Tv[271];//24
   Tv[273]:=GetBox16AFromT4Slips(RetNo);//25
   Tv[274]:=Tv[185];
   Tv[275]:=MinR(396.00,Tv[274]*(4/100)); //26 //jz//2025formupdate - new max from 188
  end;  //with page 5

  //page 6
  with ret[RetNo].Frm[FNo] do
  begin
   Tv[276]:=TV[114]-Tv[152];  //20250212 //27
   Tv[277]:=TV[115]-Tv[158];   //20250212 //28
   Tv[278]:=TV[116]-Tv[171];  //20250212 //29
   Tv[279]:=TV[117]-Tv[179];  //20250212 //30
   Tv[280]:=MinR(Tv[4],Tv[276]);//31

   if Tv[5] > Tv[115] then
   begin
     Tv[281]:=TV[280];//32
     Tv[282]:=TV[277];//33
     Tv[283]:=maxr(0,TV[281]-Tv[282]);//34  //jz20251128 - as per form update/cra email
     Tv[284]:=MinR(Tv[279],Tv[283]);//35
   end
   else
   begin
     Tv[281]:=0;//32
     Tv[282]:=0;//33
     Tv[283]:=0;//34
     Tv[284]:=0;//35
   end;
   Tv[285]:=TV[280]-TV[284];//36

   Tv[286]:=TV[278];//37
   Tv[287]:=MaxR(0,TV[285]-Tv[286]);//38
   Tv[288]:=GetBox17FromT4Slips(RetNo);//39
   Tv[289]:=Tv[288]; //20250216 Igor
   Tv[290]:=Tv[289]*84.375/100;//40
   Tv[291]:=TV[288]-Tv[290];//41
   Tv[292]:=Tv[287];
   Tv[293]:=MinR(3661.20,Tv[292]*5.4/100);//42 //jz//2025formupdate - new max from 3510.00
   Tv[294]:=Tv[287];
   Tv[295]:=MinR(678.00,Tv[294]*1/100);//43  //jz//2025formupdate - new max from 650
   Tv[296]:=Tv[293]+Tv[295];//44
   Tv[297] := GetBox17AFromT4Slips(RetNo); //20250216 Igor //45
   Tv[298] := Tv[284]; //jz//20250309  //Tv[297]; //20250216 Igor
   Tv[299]:=MinR(396.00, Tv[298] * 4/100);//20250217 Igor //46 //jz//2025formupdate - new max from 188
  end;

   //page 7
  with ret[RetNo].Frm[FNo] do
  begin
   Tv[300]:=TV[266];//47
   Tv[301]:=TV[290];//48
   Tv[302]:=TV[300]+Tv[301];//49
   Tv[303]:=TV[269];//50
   Tv[304]:=TV[293];//51
   Tv[305]:=TV[303]+Tv[304];
   Tv[306]:=TV[305];//52
   Tv[307]:=TV[302]-tv[306];//53
   Tv[308]:=TV[267];//54
   Tv[309]:=TV[291];//55
   Tv[310]:=TV[308]+Tv[309];
   Tv[311]:=TV[310];//56
   Tv[312]:=TV[271];//57
   Tv[313]:=TV[295];//58
   Tv[314]:=TV[312]+tv[313];
   Tv[315]:=TV[314];//59
   Tv[316]:=TV[311]-tv[315];
   Tv[317]:=TV[316];//60
   Tv[318]:=TV[307]+tv[317];//61

   Tv[319]:=TV[273];//62
   Tv[320]:=TV[297];//63
   Tv[321]:=Tv[319]+Tv[320]; //TV[307];  //20241123
   Tv[322]:=TV[321];//64
   Tv[323]:=TV[275];//65
   Tv[324]:=TV[299];//66
   Tv[325]:=TV[323]+Tv[324];
   Tv[326]:=TV[325];//67
   Tv[327]:=TV[322]-Tv[326];
   Tv[328]:=TV[327];//68
   Tv[329]:=TV[318]+Tv[328];//69
  end; //with page 7

  if requireRC381Part4(RetNo,FNo) then
    rc381Part4(RetNo,FNo)
  else if requireRC381Part5(RetNo,FNo) then
    rc381Part5(RetNo,FNo)
  else
    rc381Part3ab(RetNo,FNo);

  //22200
  //Tv[204] := Tv[395];
  //Ret[RetNo].lnn[22200] := Tv[395]; //lnn values set in summary

  //20250131 Igor <<<
  //=====================================

    //SUMMARY   rc381 ----------------------------------------------------
    with ret[RetNo].Frm[FNo] do  //20241222
    Begin

     sumLnnNo := 22200; sumElmNo := 204;
     Tv[sumElmNo]:=MaxR(Tv[153],Tv[395]);
     Ret[RetNo].LNN[sumLnnNo]:=Tv[sumElmNo];


     sumLnnNo := 22215; sumElmNo := 210;
     Tv[sumElmNo] := MaxR(MaxR(MaxR(Tv[332],Tv[348]),Tv[148]),Tv[391]); //20241222
     Ret[RetNo].LNN[sumLnnNo]:= Tv[sumElmNo];


     sumLnnNo := 30800; sumElmNo := 207;
     Tv[sumElmNo]:= MaxR(MaxR(Tv[333],Tv[208]),MaxR(Tv[127],Tv[505])); //jz//s8rev+rc381rev//20250609 - added Tv[208], Tv[505] //Tv[207]:=MaxR(MaxR(Tv[333],Tv[335]),MaxR(Tv[127],Tv[208])); //jz//s8rev+rc381rev//20250531 - added Tv[208]
     Ret[RetNo].LNN[sumLnnNo]:=Tv[sumElmNo];


     sumLnnNo := 31000; sumElmNo := 201;
     Tv[sumElmNo]:= MaxR(Tv[150],Tv[393]); //jz//s8rev+rc381rev//20250609 - added [393]
     Ret[RetNo].LNN[sumLnnNo]:=Tv[sumElmNo];


     sumLnnNo := 42100;sumElmNo := 205;
     Tv[sumElmNo]:= MaxR(0,Tv[121]);
     Ret[RetNo].LNN[sumLnnNo]:=Tv[sumElmNo];


     sumLnnNo := 44800; sumElmNo := 213;
     Tv[sumElmNo]:= MaxR(Tv[334],Tv[123]);  //overpayment //20241223
     Ret[RetNo].LNN[sumLnnNo]:=Tv[sumElmNo];


     sumLnnNo := 50310; sumElmNo := 423;
     Tv[sumElmNo]:= Calc5031(RetNo);   //20250502


     sumLnnNo := 50329; sumElmNo := 422;
     Tv[sumElmNo]:= Tv[4];
     Ret[RetNo].LNN[sumLnnNo]:=Tv[sumElmNo];


     sumLnnNo := 50330; sumElmNo := 425;
     Tv[sumElmNo]:= Tv[288];
     Ret[RetNo].LNN[sumLnnNo]:=Tv[sumElmNo];


     sumLnnNo := 50331; sumElmNo := 428;
     Tv[sumElmNo]:= Tv[297];
     Ret[RetNo].LNN[sumLnnNo]:=Tv[sumElmNo];


     //** note: this is different than below --> 50339 vs 50399
     sumLnnNo := 50339; sumElmNo := 437;
     Tv[sumElmNo]:= Tv[3];
     Ret[RetNo].LNN[sumLnnNo]:=Tv[sumElmNo];


     //** note: this is different than above --> 50339 vs 50399
     sumLnnNo := 50399; sumElmNo := 455;
     Tv[sumElmNo]:= Tv[351];
     Ret[RetNo].LNN[sumLnnNo]:=Tv[sumElmNo];


     sumLnnNo := 50340; sumElmNo := 440;
     Tv[sumElmNo]:= Tv[19];
     Ret[RetNo].LNN[sumLnnNo]:=Tv[sumElmNo];


     sumLnnNo := 50341; sumElmNo := 443;
     Tv[sumElmNo]:= Tv[273];
     Ret[RetNo].LNN[sumLnnNo]:=Tv[sumElmNo];


     sumLnnNo := 50371; sumElmNo := 431;
     Tv[sumElmNo]:= Tv[154];
     Ret[RetNo].LNN[sumLnnNo]:=Tv[sumElmNo];


     sumLnnNo := 50372; sumelmNo:=446;
     strings[sumelmNo]:= strings[42];  //jz//20250301 - stop contributing cpp

     sumLnnNo := 50373; sumelmNo:=449;
     Tv[sumElmNo]:= MaxR(Tv[350],Tv[155]);
     Ret[RetNo].LNN[sumLnnNo]:=Tv[sumElmNo];

     sumLnnNo := 50374; sumelmNo:=452;
     strings[sumelmNo]:= strings[43];  //jz//20250301 - revoke election


   end; //end with SUMMARY   rc381  page 18

  SaveTv(RetNo, FName, FNo); //20241122

end; // END RC381




//20251223 Igor >>>
procedure T106(RetNo: Integer; FName: string; FNo: Integer);
var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    if Strings[3].Equals('') then Strings[3]:= '1  New';
    if Strings[3].Equals('3   Amended') then Strings[78]:= 'AMENDED';

    for i:= 4 to 15 do Strings[i]:= '';
    if Strings[110].Equals('') then Strings[110]:= '1  New';
    Strings[16]:= 'X';
    if Strings[2].Equals('') then Strings[2] := 'CAN';

    Strings[17]:= GetFirstName(RetNo);
    Strings[18]:= GetLastName(RetNo);
    Strings[22]:= GetSinNo(RetNo);
    Strings[23]:= FetchElm(RetNo, 'T1', 22) + ' ' + FetchElm(RetNo, 'T1', 6);
    Strings[24]:= FetchElm(RetNo, 'T1', 10);
    Strings[25]:= FetchElm(RetNo, 'T1', 14);
    Strings[26]:= FetchElm(RetNo, 'T1', 15);

    if Strings[27].Equals('') then Strings[27]:= AppYear + '-01-01';
    if Strings[28].Equals('') then Strings[28]:= AppYear + '-12-31';

    Strings[32]:= IntToStr(CountMultipleInstances(RetNo, 'T106SL'));
    Tv[33]:= TotMultipleExludingDeletedSlips(RetNo, 'T106SL', 174, 110, '4   Delete (Close)');
    Tv[34]:= Vl(FetchElm(RetNo, 'T1', 236)); //20251223 Igor

    for i:= 35 to 38 do Strings[i]:= LeftStr(Strings[i], 6); // NAICS Replacing CleanUp routine in ChildWinNew

    Strings[60]:= LeftStr(Strings[60], 3); // Functional currency Replacing CleanUp routine in ChildWinNew
    Strings[2]:= LeftStr(Strings[2], 3); // Functional currency Replacing CleanUp routine in ChildWinNew

    //Section 2
    if (Strings[29] + Strings[30]).Equals('') then Strings[30]:= 'X';
    if (Strings[39] + Strings[40]).Equals('') then Strings[40]:= 'X';
    if (Strings[41] + Strings[42]).Equals('') then Strings[42]:= 'X';
    if (Strings[65] + Strings[66]).Equals('') then Strings[66]:= 'X';
    if Strings[66].Equals('') then Strings[67]:= '';
    if (Strings[68] + Strings[69]).Equals('') then Strings[69]:= 'X';
    if (Strings[70] + Strings[71]).Equals('') then Strings[71]:= 'X';
    if (Strings[45] + Strings[46]).Equals('') then Strings[46]:= 'X';
    if (Strings[49] + Strings[50]).Equals('') then Strings[50]:= 'X';
    if (Strings[51] + Strings[52]).Equals('') then Strings[52]:= 'X';
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure T106SL(RetNo: Integer; FName: string; FNo: Integer);
var
  i, k: Integer;
  FInst: string;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    FInst:= ExtractFormInst(FName);
    Strings[124]:= MidStr(FInst, 2, 3);

    if Strings[110].Equals('') then Strings[110]:= '1  New';

    Strings[125]:= IntToStr(CountMultipleInstances(RetNo, 'T106SL'));
    // FillHeader(RetNo,FNo,1,2,3);
    Strings[6]:= 'X';
    Strings[7]:= GetSinNo(RetNo);
    Strings[8]:= AppYear + '-01-01';
    Strings[9]:= AppYear + '-12-31';

    if (Strings[14] + Strings[15] + Strings[16]) = '' then Strings[14]:= '';

    Tv[92]:= Tv[120] + AddColumns(32, 88, 4) + Tv[126] + Tv[130] + Tv[134];
    // 20180719 was missing elms in addition Tv[92]:=Tv[120]+AddColumns(32,88,4);
    Tv[94]:= Tv[122] + AddColumns(34, 90, 4) + Tv[128] + Tv[132] + Tv[136];
    // was missing elms in addition Tv[94]:=Tv[122]+AddColumns(34,90,4);

    i:= 96;
    Tv[108]:= 0;
    Tv[109]:= 0;
    repeat
      Tv[i + 3]:= MaxR(0, Tv[i] + Tv[i + 1] - Tv[i + 2]);
      Tv[108]:= Tv[108] + Tv[i + 1];
      Tv[109]:= Tv[109] + Tv[i + 2];
      Inc(i, 4);
    until i > 104;

    Tv[179]:= Tv[176] + Tv[177] - Tv[178];
    Tv[108]:= Tv[108] + Tv[177];
    Tv[109]:= Tv[109] + Tv[178];

    i:= 138;
    k:= 0;
    Tv[171]:= 0;
    Tv[172]:= 0;
    Tv[173]:= 0;
    repeat
      k:= k + MyStrToInt(Strings[i]);
      Tv[171]:= Tv[171] + Tv[i + 1];
      Tv[172]:= Tv[172] + Tv[i + 2];
      Tv[173]:= Tv[173] + Tv[i + 3];
      Inc(i, 4);
    until i > 166;
    Strings[170]:= IntToStr(k);
    Tv[174]:= Tv[92] + Tv[94] + Tv[108] + Tv[109] + Tv[172] + Tv[173];
    Tv[114]:= Tv[111] + Tv[112] - Tv[113];
    Tv[118]:= Tv[115] + Tv[116] - Tv[117];
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20251223 Igor <<<

End.

