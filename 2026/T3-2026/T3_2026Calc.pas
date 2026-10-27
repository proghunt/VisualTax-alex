 unit T3_2026calc;

interface
uses

 SysUtils,
 WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
 Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,ComCtrls,
 T3_2026Declare, T3_2026common, T3_2026common2, T3_2026TrimStr,
 T3_2026Calc1, T3_2026Calc2,
 T3_2026Calc3, T3_2026CalcBus,
 T3_2026Calndr,
 //_2023CalcMj,  //20231201
 XSuperObject
 ;  //20130216

 //Procedure populateTestCasesJSON(RetNo: integer; FName: String; FNo: integer);



 procedure SIFT(RetNo: integer;FName: string;FNo: integer);

 procedure T3ON(RetNo: integer;FName: string;FNo: integer);
 procedure T3AB(RetNo: integer;FName: string;FNo: integer);
 procedure T3BC(RetNo: integer;FName: string;FNo: integer);
 procedure T3NB(RetNo: integer;FName: string;FNo: integer);
 procedure T3NS(RetNo: integer;FName: string;FNo: integer);
 procedure T3NL(RetNo: integer;FName: string;FNo: integer);
 procedure T3NU(RetNo: integer;FName: string;FNo: integer);
 procedure T3NT(RetNo: integer;FName: string;FNo: integer);
 procedure T3MB(RetNo: integer;FName: string;FNo: integer);
 procedure T3SK(RetNo: integer;FName: string;FNo: integer);
 procedure T3PE(RetNo: integer;FName: string;FNo: integer);
 procedure T3YT(RetNo: integer;FName: string;FNo: integer);

 Procedure T3MJ(RetNo: Integer; FName: string; FNo: Integer);

 Function usedInMJ(RetNo: Integer;Fname:string):boolean;

 Procedure T2000(RetNo:integer;FName:string;FNo:integer);   //20211111 Igor

 //20231129
 Procedure T3RCA(RetNo:integer;FName:string;FNo:integer);  //20231129
 Procedure T3M(RetNo:integer;FName:string;FNo:integer);   //20211111 Igor
 Procedure T3ATH(RetNo:integer;FName:string;FNo:integer);   //20211111 Igor
 Procedure T3S(RetNo:integer;FName:string;FNo:integer);   //20211111 Igor
 //Procedure T3P(RetNo:integer;FName:string;FNo:integer);   //20211111 Igor //20240118 Igor
 Procedure T3RI(RetNo:integer;FName:string;FNo:integer);   //20211111 Igor
 Procedure T1159(RetNo:integer;FName:string;FNo:integer);   //20211111 Igor
 Procedure T3D(RetNo:integer;FName:string;FNo:integer);   //20211111 Igor
 Procedure T1061(RetNo:integer;FName:string;FNo:integer);   //jz 20240326

 Procedure T3AO(RetNo: integer; FName: String; FNo: integer);
 //Procedure T7DRQR(RetNo: integer; FName: String; FNo: integer);
 Procedure EFMEMO(RetNo:integer;FName:string;FNo:integer);
 Procedure S15(RetNo:integer;FName:string;FNo:integer); //20240129 Igor
 Procedure TX19(RetNo:integer;FName:string;FNo:integer); //20180425
 //20170923  (relocated from Trimstr
 Procedure InitConstants;
 Procedure InitPrvConstants(Prv: String);

 //Procedure InitPRVDividendRates(Prv: String); // 20160801 //jz2025update-rev1: NO LONGER USUED, done in InitPRVConstants with array
 // Function GetPrvIndex(Prv: String): Integer; //20220209 Igor

 //20170609
 Procedure T1079(RetNo: integer; FName: String;FNo: integer);
 Procedure T1079WS(RetNo: integer; FName: String;FNo: integer);

 Procedure TESTFRM(RetNo: integer; FName: String;FNo: integer);
 Function IsFormElmInTfPropDynList(FName:String;Fld:Integer):Boolean;
 Procedure PRVCR(RetNo: integer; FName: String;FNo: integer);
 Procedure UsedFrm(RetNo: integer; FName: String;FNo: integer);
 Procedure CalcUsedFrm(RetNo: integer);
 Procedure Autos(RetNo:integer;FName:string;FNo:integer);
 Procedure ASSETSB(RetNo:integer;FName:string;FNo:integer);
 Procedure T3INCOME(RetNo: integer; FName: String;FNo: integer);
 Procedure T5INCOME(RetNo: integer; FName: String;FNo: integer);
 Procedure T5013INC(RetNo: integer; FName: String;FNo: integer);
 Procedure FLDTAPE(RetNo: integer; FName: String;FNo: integer);
 Procedure T3OTHDED(RetNo: integer; FName: String;FNo: integer);
 Procedure FldMEM(RetNo: integer; FName: String;FNo: integer);
 Procedure CutPast(RetNo:integer;FName:string;FNo:integer);
 Procedure ClearAllProvTaxForms(RetNo:Integer);
 procedure STATUS(RetNo: integer; FName: String;FNo: integer);
 Procedure ClearThisForm(RetNo:integer;FName:string);
 Function GetSurtaxReduction(RetNo:Integer;Bft:Real):Real;
 Procedure CalcMultiPageForm(RetNo:integer;FName:string);
 Procedure CalcPrvTaxAndCredits(RetNo:integer);
 Function S1SectionII(RetNo, FNo:Integer):Boolean;
 Function S1SectionIII(RetNo, FNo:Integer):Boolean;
 Function S1SectionIV(RetNo, FNo:Integer):Boolean;
 Function CalcInclusionRate(RetNo, FNo:Integer):Real;
 Function CalcBCSurtax(RetNo:Integer;ATax:Real):Real;


 procedure T3(RetNo: integer; FName: string; FNo: integer);
 procedure T183TRUST(RetNo: integer; FName: string; FNo: integer); //20211222
 procedure S1(RetNo: integer;FName: string;FNo: integer);
 procedure S1SUPQ(RetNo:integer;FName:string;FNo:integer);
 procedure S2(RetNo: integer;FName: string;FNo: integer);
 procedure S1A(RetNo: integer;FName: string;FNo: integer);

 procedure S3(RetNo: integer;FName: string;FNo: integer);

 procedure S4(RetNo: integer;FName: string;FNo: integer);

 procedure S5(RetNo: integer;FName: string;FNo: integer);
 procedure S6(RetNo: integer;FName: string;FNo: integer);
 procedure S7(RetNo: integer;FName: string;FNo: integer);
 procedure S8(RetNo: integer;FName: string;FNo: integer);

 procedure S9(RetNo: integer;FName: string;FNo: integer);

 procedure S10(RetNo: integer;FName: string;FNo: integer);

 procedure S11(RetNo: integer;FName: string;FNo: integer);
 procedure S11A(RetNo: integer;FName: string;FNo: integer); //20170325

 procedure S12(RetNo: integer;FName: string;FNo: integer);

 procedure T3ADJ(RetNo: integer;FName: string;FNo: integer);
 procedure PENSINC(RetNo: integer;FName: string;FNo: integer);
 procedure ABIL(RetNo: integer;FName: string;FNo: integer);
 Procedure T184(RetNo:integer;FName:string;FNo:integer); //20220127 Igor
 Procedure T1135(RetNo:integer;FName:string;FNo:integer);

 Procedure T1055(RetNo:integer;FName:string;FNo:integer);

 procedure T3Sl1(RetNo: integer;FName: string;FNo: integer);
 procedure T3Sl23(RetNo: integer;FName: string;FNo: integer);
 procedure T3Sl4(RetNo: integer;FName: string;FNo: integer);


 procedure T3LOSS(RetNo: integer; FName: String;FNo: integer);

 procedure T3DON(RetNo: integer; FName: String;FNo: integer);

 Procedure LETR_1(RetNo: integer; FName: String;FNo: integer);
 Procedure LETR_2(RetNo: integer; FName: String;FNo: integer);
 Procedure ADDINFO(RetNo: integer; FName: String;FNo: integer);
 Procedure NR6(RetNo: integer; FName: String;FNo: integer);
// Procedure T3OTHDED(RetNo: integer; FName: String;FNo: integer);
 Procedure NR6INSTR(RetNo: integer; FName: String;FNo: integer);
 Procedure CALCALL(RetNo: integer);
 Procedure CalcFullT3(RetNo:Integer);
 Procedure T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo:Integer);//20160310 Igor
 procedure S130(RetNo: Integer; FName: string; FNo: Integer); //20260302 Igor
 { I M P L E M E N T A T I O N }
implementation

Uses T3_2026ChildWinNew, T3_2026Main, vtTrimStr, T3_2026,
  vtShared, vtCommon, vtChild, System.Math;

Procedure CalcMultiPageForm(RetNo:integer;FName:string);
Var i,n:integer;Root:string[10];
begin
   n:=GetFormMxPg(FName);
   Root := ExtractFormRootName(FName);
   If Root = 'PAGE_' Then begin Calc(RetNo,FName);exit;end;
   For i:=1 to n do
     Calc(RetNo,Root+'_'+IntToStr(i)+ExtractFormInst(FName));
end;

//20241103
Procedure InitPRVConstants(Prv: String);
  //jz//20250731 - big and small prv Div Rates need to be copied directlty from CRA T3ON, T3BC, etc
  Const
    Elements =12;
    prvArray                  : array  [1..Elements] of string = ('AB'    , 'BC'    , 'MB'      , 'NB'    , 'NL'     , 'NS'    , 'NT'      , 'NU'   , 'ON'      , 'PE'    , 'SK'     , 'YT');
    PrvDivRateBigValueArray0  : array  [1..Elements] of string = ('29.48' , '43.58' , '29.0526' , '50.84' , '22.88'  , '32.14' , '41.7632' , '20'   , '36.3158' , '38.13' , '39.95'  , '43.65');
    PrvDivRateValueArray0     : array  [1..Elements] of string = ('16.74' , '15'    , '6.0068'  , '21.08' , '24.533' , '11.50' , '46'      , '20'   , '22.895'  , '10'    , '19.312' , '5.10');

    PrvDivRateBigValueArray1  : array  [1..Elements] of string = ('29.48' , '43.58' , '29.0526' , '50.84' , '22.88'  , '32.14' , '41.7632' , '20'   , '36.3158' , '38.13' , '39.95'  , '43.65');
    PrvDivRateValueArray1     : array  [1..Elements] of string = ('16.74' , '15'    , '6.0068'  , '21.08' , '24.533' , '11.50' , '46'      , '20'   , '22.895'  , '10'    , '19.312' , '5.10');

  Var
    i:integer;
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

  {$region ' ON '}
  If Prv = 'ON' then // See 5006.c
  begin
    Cpi := 1.065;    //2013

    PrvConstant[0].PrvRate1 := '5.05'; // 2026
    PrvConstant[1].PrvRate1 := '5.05'; // 2026
    PrvConstant[0].PrvRate2 := '9.15'; // 2026
    PrvConstant[1].PrvRate2 := '9.15'; // 2026
    PrvConstant[0].PrvRate3 := '11.16'; // 2026
    PrvConstant[1].PrvRate3 := '11.16'; // 2026
    PrvConstant[0].PrvRate4 := '12.16'; // 2026
    PrvConstant[1].PrvRate4 := '12.16'; // 2026
    PrvConstant[0].PrvRate5 := '13.16'; // 2026
    PrvConstant[1].PrvRate5 := '13.16'; // 2026
                                            //jz2025update-rev1: as per form
    PrvConstant[0].PrvBracket1 := 538981.00; //52886.00; //2026
    PrvConstant[1].PrvBracket1 := 53891.00; //52886.00; //2026
    PrvConstant[0].PrvBracket2 := 107785.00; //105775.00; //2026
    PrvConstant[1].PrvBracket2 := 107785.00; //105775.00; //2026
    PrvConstant[0].PrvBracket3 := 150000.00; //2026
    PrvConstant[1].PrvBracket3 := 150000.00; //2026
    PrvConstant[0].PrvBracket4 := 220000.00; //2026
    PrvConstant[1].PrvBracket4 := 220000.00; //2026

    PrvConstant[0].PrvBracketTax1 := 0;
    PrvConstant[1].PrvBracketTax1 := 0;
    PrvConstant[0].PrvBracketTax2 := 2721.50; //2670.74; //2026
    PrvConstant[1].PrvBracketTax2 := 2721.50; //2670.74; //2026
    PrvConstant[0].PrvBracketTax3 := 7652.80; //7510.09; //2026
    PrvConstant[1].PrvBracketTax3 := 7652.80; //7510.09; //2026
    PrvConstant[0].PrvBracketTax4 := 12363.99; //12445.60; //2026
    PrvConstant[1].PrvBracketTax4 := 12363.99; //12445.60; //2026
    PrvConstant[0].PrvBracketTax5 := 20875.99; //20957.60; //2026
    PrvConstant[1].PrvBracketTax5 := 20875.99; //20957.60; //2026

    // 5006c Donations and gifts
    PrvConstant[0].PrvDonRate1 := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1 := vl(PrvConstant[1].PrvRate1);

    // 5006c Donations and gifts
    PrvConstant[0].PrvDonRate2 := 11.16; // 2023
    PrvConstant[1].PrvDonRate2 := 11.16; // 2023
  end; // ON
  {$endregion ' ON '}

  {$region ' AB '}
  if Prv.Equals('AB') then
  begin
    Cpi := 1.024;

    PrvConstant[0].PrvRate1 := '8';     // 2026 //jz2025update-rev1: new tax bracket
    PrvConstant[1].PrvRate1 := '8';     // 2026
    PrvConstant[0].PrvRate2 := '10';    // 2026
    PrvConstant[1].PrvRate2 := '10';    // 2026
    PrvConstant[0].PrvRate3 := '12.0';  // 2026
    PrvConstant[1].PrvRate3 := '12.0';  // 2026
    PrvConstant[0].PrvRate4 := '13.0';  // 2026
    PrvConstant[1].PrvRate4 := '13.0';  // 2026
    PrvConstant[0].PrvRate5 := '14.0';  // 2026
    PrvConstant[1].PrvRate5 := '14.0';  // 2026
    PrvConstant[0].PrvRate6 := '15.0';  // 2026
    PrvConstant[1].PrvRate6 := '15.0';  // 2026

    PrvConstant[0].PrvBracket1 := 61200; //60000;    // 2026 //jz2025update-rev1: new tax bracket
    PrvConstant[1].PrvBracket1 := 61200; //60000;    // 2026
    PrvConstant[0].PrvBracket2 := 154259; //151234;   //2026
    PrvConstant[1].PrvBracket2 := 154259; //151234;   //2026
    PrvConstant[0].PrvBracket3 := 185111; //181481;   //2026
    PrvConstant[1].PrvBracket3 := 185111; //181481;   //2026
    PrvConstant[0].PrvBracket4 := 246813; //241974;   //2026
    PrvConstant[1].PrvBracket4 := 246813; //241974;   //2026
    PrvConstant[0].PrvBracket5 := 370220; //362961;   //2026
    PrvConstant[1].PrvBracket5 := 370220; //362961;   //2026

    PrvConstant[0].PrvBracketTax1 := 0;           //2026 //jz2025update-rev1: new tax bracket
    PrvConstant[1].PrvBracketTax1 := 0;           //2026
    PrvConstant[0].PrvBracketTax2 := 4896;// 4800.00;     //2026 // Round(PrvConstant[1].PrvBracketTax1+PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1)/100)+
    PrvConstant[1].PrvBracketTax2 := 4896;// 4800.00;     //2026 // Round(PrvConstant[1].PrvBracketTax1+PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1)/100)+
    PrvConstant[0].PrvBracketTax3 := 14201.90;// 13923.40;   //2026
    PrvConstant[1].PrvBracketTax3 := 14201.90;// 13923.40;   //2026
    PrvConstant[0].PrvBracketTax4 := 17904.14;// 17553.04;   //2026
    PrvConstant[1].PrvBracketTax4 := 17904.14;// 17553.04;   //2026 // Round(PrvConstant[1].PrvBracketTax3+(PrvConstant[1].PrvBracket3 - PrvConstant[1].PrvBracket2) * vl(PrvConstant[1].PrvRate3)/100);
    PrvConstant[0].PrvBracketTax5 := 25925.40;// 25417.13;    //2026
    PrvConstant[1].PrvBracketTax5 := 25925.40;// 25417.13;    //2026
    PrvConstant[0].PrvBracketTax6 := 43202.38;// 42355.31;    //2026
    PrvConstant[1].PrvBracketTax6 := 43202.38;// 42355.31;    //2026


    // 5009c bottom page 1
    PrvConstant[0].PrvDonRate1 := 60; //2026 //20231207//vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1 := 60; //2026 //vl(PrvConstant[1].PrvRate1);

    // 5009d Line 5896
    PrvConstant[0].PrvDonRate2 := 21.00; // 2026
    PrvConstant[1].PrvDonRate2 := 21.00; // 2026


  end; // ab
  {$endregion ' AB '}

  {$region ' MB '}
  if Prv.Equals('MB') then
  begin
    Cpi := 1.000;
    // 5007-c
    PrvConstant[0].PrvBracket1 := 47000; // 2026
    PrvConstant[1].PrvBracket1 := 47000; // 2026
    PrvConstant[0].PrvBracket2 := 100000; // 2026
    PrvConstant[1].PrvBracket2 := 100000; // 2026

    // 5007-c
    PrvConstant[0].PrvRate1 := '10.8'; // 2026
    PrvConstant[1].PrvRate1 := '10.8'; // 2026
    PrvConstant[0].PrvRate2 := '12.75'; // 2026
    PrvConstant[1].PrvRate2 := '12.75'; // 2026
    PrvConstant[0].PrvRate3 := '17.4'; // 2026
    PrvConstant[1].PrvRate3 := '17.4'; // 2026

    // 5007-c
    PrvConstant[0].PrvBracketTax1 := 0;
    PrvConstant[1].PrvBracketTax1 := 0;
    PrvConstant[0].PrvBracketTax2 := 5076.00; // 2026
    PrvConstant[1].PrvBracketTax2 := 5076.00; // 2026   // Round(PrvConstant[1].PrvBracketTax1+PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1)/100);
    PrvConstant[0].PrvBracketTax3 := 11833.50;// 2026
    PrvConstant[1].PrvBracketTax3 := 11833.50;// 2026  Round(PrvConstant[1].PrvBracketTax2+(PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2)/100);


    // 5007-c bottom page 1
    PrvConstant[0].PrvDonRate1 := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1 := vl(PrvConstant[1].PrvRate1);

    // 5007-c bottom page 1
    PrvConstant[0].PrvDonRate2 := 17.4; // 2026
    PrvConstant[1].PrvDonRate2 := 17.4; // 2026

    // 5007-d line 6152
    //done all at once at end of this procedure
    {
    PrvConstant[0].PrvDivRate := '0.7835'; // 2024
    PrvConstant[1].PrvDivRate := '0.7835'; // 2024

    // 5007-d line 6152
    PrvConstant[0].PrvDivRateBig := '8'; // 2024
    PrvConstant[1].PrvDivRateBig := '8'; // 2024
    }
  end;
  {$endregion ' MB '}

  {$region ' BC '}
  if Prv.Equals('BC') then
  begin
    Cpi := 1.007;
    // from 5010-c
    PrvConstant[0].PrvBracket1 := 50363; //49279; //2026 //jz2025update-rev1: updated //47937; // 2024
    PrvConstant[1].PrvBracket1 := 50363; //49279; //2026  //47937; // 2024
    PrvConstant[0].PrvBracket2 := 100728; //98560; //2026   //95875; // 2024
    PrvConstant[1].PrvBracket2 := 100728; //98560; //2026   //95875; // 2024
    PrvConstant[0].PrvBracket3 := 115648; //113158; //2026   //110076; // 2024
    PrvConstant[1].PrvBracket3 := 115648; //113158; //2026   //110076; // 2024
    PrvConstant[0].PrvBracket4 := 140430; //137407; //2026   //133664; // 2024  //20250226
    PrvConstant[1].PrvBracket4 := 140430; //137407; //2026   //133664; // 2024
    PrvConstant[0].PrvBracket5 := 190405; //186306; //2026   //181232; // 2024
    PrvConstant[1].PrvBracket5 := 190405; //186306; //2026   //181232; // 2024
    PrvConstant[0].PrvBracket6 := 265545; //259829; //2026   //252752; // 2024
    PrvConstant[1].PrvBracket6 := 265545; //259829; //2026   //252752; // 2024

    // from 5010-c
    PrvConstant[0].PrvRate1 := '5.60'; //'5.06';  // 2026 //jz2025update-rev1: no change for 2025
    PrvConstant[1].PrvRate1 := '5.60'; //'5.06';  // 2026
    PrvConstant[0].PrvRate2 := '7.70';  // 2026
    PrvConstant[1].PrvRate2 := '7.70';  // 2026
    PrvConstant[0].PrvRate3 := '10.50'; // 2026
    PrvConstant[1].PrvRate3 := '10.50'; // 2026
    PrvConstant[0].PrvRate4 := '12.29'; // 2026
    PrvConstant[1].PrvRate4 := '12.29'; // 2026
    PrvConstant[0].PrvRate5 := '14.70'; // 2026
    PrvConstant[1].PrvRate5 := '14.70'; // 2026
    PrvConstant[0].PrvRate6 := '16.80'; // 2026
    PrvConstant[1].PrvRate6 := '16.80'; // 2026
    PrvConstant[0].PrvRate7 := '20.50'; // 2026
    PrvConstant[1].PrvRate7 := '20.50'; // 2026

    // from 5010-c
    PrvConstant[0].PrvBracketTax1 := 0; //2026 //jz2025update-rev1:
    PrvConstant[1].PrvBracketTax1 := 0; //2026
    PrvConstant[0].PrvBracketTax2 := 2820.33; //2493.52; //2026   //2425.61; // 2024
    PrvConstant[1].PrvBracketTax2 := 2820.33; //2493.52; //2026   //2425.61; // 2024    // Round(PrvConstant[1].PrvBracketTax1+PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1)/100);
    PrvConstant[0].PrvBracketTax3 := 6698.43; //6288.15; //2026   //6116.84; // 2024  Round(PrvConstant[0].PrvBracketTax2+(PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2)/100);
    PrvConstant[1].PrvBracketTax3 := 6698.43; //6288.15; //2026   //6116.84; // 2024  Round(PrvConstant[1].PrvBracketTax2+(PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2)/100);
    PrvConstant[0].PrvBracketTax4 := 8265.03; //7820.94; //2026   //7607.94; // 2024 7245.73; // 2022  Round(PrvConstant[0].PrvBracketTax3+(PrvConstant[0].PrvBracket3 - PrvConstant[0].PrvBracket2) * vl(PrvConstant[0].PrvRate3)/100);
    PrvConstant[1].PrvBracketTax4 := 8265.03; //7820.94; //2026   //7607.94; // 2024  Round(PrvConstant[1].PrvBracketTax3+(PrvConstant[1].PrvBracket3 - PrvConstant[1].PrvBracket2) * vl(PrvConstant[1].PrvRate3)/100);
    PrvConstant[0].PrvBracketTax5 := 11310.74; //10801.15; //2026   //10506.91;  // Round(GetTaxOnBase(PrvConstant[0].PrvBracket4,PrvConstant[0].PrvBracket3,Vl(PrvConstant[0].PrvRate4),PrvConstant[0].PrvBracketTax4));
    PrvConstant[1].PrvBracketTax5 := 11310.74; //10801.15; //2026   //10506.91;  // 2024  Round(GetTaxOnBase(PrvConstant[1].PrvBracket4,PrvConstant[1].PrvBracket3,Vl(PrvConstant[1].PrvRate4),PrvConstant[1].PrvBracketTax4));
    PrvConstant[0].PrvBracketTax6 := 18657.07; //17989.30; //2026   //17499.40; // 2024
    PrvConstant[1].PrvBracketTax6 := 18657.07; //17989.30; //2026   //17499.40; // 2024  Round(GetTaxOnBase(PrvConstant[1].PrvBracket5,PrvConstant[1].PrvBracket4,Vl(PrvConstant[1].PrvRate5),PrvConstant[1].PrvBracketTax5));
    PrvConstant[0].PrvBracketTax7 := 31280.59; //30341.16; //2026   //29514.78; // 2024
    PrvConstant[1].PrvBracketTax7 := 31280.59; //30341.16; //2026   //29514.78; // 2024


    // from 5010-c bottom of page 1
    PrvConstant[0].PrvDonRate1 := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1 := vl(PrvConstant[1].PrvRate1);

    // from 5010-c bottom of page 1
    PrvConstant[0].PrvDonRate2 := 16.8; // 2023
    PrvConstant[1].PrvDonRate2 := 16.8; // 2023

  end; { bc }
  {$endregion ' BC '}

  {$region ' NL '}
  if Prv.Equals('NL') then
  begin
    Cpi := 1.009; // 2020

    // from 5001-c
    PrvConstant[0].PrvBracket1 := 44678; //44192; //2026
    PrvConstant[1].PrvBracket1 := 44678; //44192; //2026
    PrvConstant[0].PrvBracket2 := 89354; //88382; //2026
    PrvConstant[1].PrvBracket2 := 89354; //88382; //2026
    PrvConstant[0].PrvBracket3 := 159528; //157792; //2026
    PrvConstant[1].PrvBracket3 := 159528; //157792; //2026
    PrvConstant[0].PrvBracket4 := 223340; //220910; //2026
    PrvConstant[1].PrvBracket4 := 223340; //220910; //2026
    PrvConstant[0].PrvBracket5 := 285319; //282214; //2026
    PrvConstant[1].PrvBracket5 := 285319; //282214; //2026
    PrvConstant[0].PrvBracket6 := 570638; //564429; //2026
    PrvConstant[1].PrvBracket6 := 570638; //564429; //2026
    PrvConstant[0].PrvBracket7 := 1141275; //1128858; //2026
    PrvConstant[1].PrvBracket7 := 1141275; //1128858; //2026

    // from 5001-c
    PrvConstant[0].PrvRate1 := '8.7'; // 2026
    PrvConstant[1].PrvRate1 := '8.7'; // 2026
    PrvConstant[0].PrvRate2 := '14.5'; // 2026
    PrvConstant[1].PrvRate2 := '14.5'; // 2026
    PrvConstant[0].PrvRate3 := '15.80'; // 2026
    PrvConstant[1].PrvRate3 := '15.80'; // 2026
    PrvConstant[0].PrvRate4 := '17.80'; // 2026
    PrvConstant[1].PrvRate4 := '17.80'; // 2026
    PrvConstant[0].PrvRate5 := '19.80'; // 2026
    PrvConstant[1].PrvRate5 := '19.80'; // 2026
    PrvConstant[0].PrvRate6 := '20.80'; // 2026
    PrvConstant[1].PrvRate6 := '20.80'; // 2026
    PrvConstant[0].PrvRate7 := '21.30'; // 2026
    PrvConstant[1].PrvRate7 := '21.30'; // 2026
    PrvConstant[0].PrvRate8 := '21.80'; // 2026
    PrvConstant[1].PrvRate8 := '21.80'; // 2026

    // from 5001-c
    PrvConstant[0].PrvBracketTax1 := 0;
    PrvConstant[1].PrvBracketTax1 := 0;
    PrvConstant[0].PrvBracketTax2 := 3886.99; //3844.70; //2026
    PrvConstant[1].PrvBracketTax2 := 3886.99; //3844.70; //2026 Round(PrvConstant[1].PrvBracketTax1+PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1)/100);
    PrvConstant[0].PrvBracketTax3 := 10365.01; //10252.25; //2026
    PrvConstant[1].PrvBracketTax3 := 10365.01; //10252.25; //2026 Round(PrvConstant[1].PrvBracketTax2+(PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2)/100);
    PrvConstant[0].PrvBracketTax4 := 21452.50; //21219.03; //2026
    PrvConstant[1].PrvBracketTax4 := 21452.50; //21219.03; //2026 Round(PrvConstant[1].PrvBracketTax3+(PrvConstant[1].PrvBracket3 - PrvConstant[1].PrvBracket2) * vl(PrvConstant[1].PrvRate3)/100);
    PrvConstant[0].PrvBracketTax5 := 32811.03; //32454.04; //2026
    PrvConstant[1].PrvBracketTax5 := 32811.03; //32454.04; //2026 Round(PrvConstant[1].PrvBracketTax4+(PrvConstant[1].PrvBracket4 - PrvConstant[1].PrvBracket3) * vl(PrvConstant[1].PrvRate4)/100); //was tax 4 20150907
    PrvConstant[0].PrvBracketTax6 := 45082.88; //44592.23; //2026 Round(PrvConstant[0].PrvBracketTax4+(PrvConstant[0].PrvBracket4 - PrvConstant[0].PrvBracket3) * vl(PrvConstant[0].PrvRate4)/100);
    PrvConstant[1].PrvBracketTax6 := 45082.88; //44592.23; //2026 Round(PrvConstant[1].PrvBracketTax4+(PrvConstant[1].PrvBracket4 - PrvConstant[1].PrvBracket3) * vl(PrvConstant[1].PrvRate4)/100); //was tax 4 20150907
    PrvConstant[0].PrvBracketTax7 := 104429.23; //103292.95; //2026 Round(PrvConstant[0].PrvBracketTax4+(PrvConstant[0].PrvBracket4 - PrvConstant[0].PrvBracket3) * vl(PrvConstant[0].PrvRate4)/100);
    PrvConstant[1].PrvBracketTax7 := 104429.23; //103292.95; //2026 Round(PrvConstant[1].PrvBracketTax4+(PrvConstant[1].PrvBracket4 - PrvConstant[1].PrvBracket3) * vl(PrvConstant[1].PrvRate4)/100); //was tax 4 20150907
    PrvConstant[0].PrvBracketTax8 := 225974.91; //223516.33; //2026 Round(PrvConstant[0].PrvBracketTax4+(PrvConstant[0].PrvBracket4 - PrvConstant[0].PrvBracket3) * vl(PrvConstant[0].PrvRate4)/100);
    PrvConstant[1].PrvBracketTax8 := 225974.91; //223516.33; //2026 Round(PrvConstant[1].PrvBracketTax4+(PrvConstant[1].PrvBracket4 - PrvConstant[1].PrvBracket3) * vl(PrvConstant[1].PrvRate4)/100); //was tax 4 20150907



    // from 5001-c bottom page 1
    PrvConstant[0].PrvDonRate1 := 8.7; //2025
    PrvConstant[1].PrvDonRate1 := 8.7; //2025 vl(PrvConstant[1].PrvRate1);

    // from 5001-c bottom page 1
    PrvConstant[0].PrvDonRate2 := 21.8; //2025
    PrvConstant[1].PrvDonRate2 := 21.8; //2025

  end; // NL
  {$endregion ' NL '}

  {$region ' SK '}
  if Prv.Equals('SK') then
  begin
    Cpi := 1.017;

    // from 5008-c                       //jz2025update-rev1:as per form
    PrvConstant[0].PrvBracket1:= 54532.00; //53463.00; //2026
    PrvConstant[1].PrvBracket1:= 54532.00; //53463.00; //2026
    PrvConstant[0].PrvBracket2:= 155805.00; //152750.00; //2026
    PrvConstant[1].PrvBracket2:= 155805.00; //152750.00; //2026

    // from 5008-c                       //jz2025update-rev1:as per form
    PrvConstant[0].PrvRate1:= '10.50'; // 2026
    PrvConstant[1].PrvRate1:= '10.50'; // 2026
    PrvConstant[0].PrvRate2:= '12.50'; // 2026
    PrvConstant[1].PrvRate2:= '12.50'; // 2026
    PrvConstant[0].PrvRate3:= '14.50'; // 2026
    PrvConstant[1].PrvRate3:= '14.50'; // 2026

    // from 5008-c
    PrvConstant[0].PrvBracketTax1:= 0; // 2026
    PrvConstant[1].PrvBracketTax1:= 0; // 2026
    PrvConstant[0].PrvBracketTax2:= 5725.86; //5613.62; //2026 Round(PrvConstant[0].PrvBracketTax1+PrvConstant[0].PrvBracket1 * vl(PrvConstant[0].PrvRate1)/100);
    PrvConstant[1].PrvBracketTax2:= 5725.86; //5613.62; //2026 Round(PrvConstant[1].PrvBracketTax1+PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1)/100);
    PrvConstant[0].PrvBracketTax3:= 18384.99; //18024.49; //2026 Round(PrvConstant[0].PrvBracketTax2+(PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2)/100);
    PrvConstant[1].PrvBracketTax3:= 18384.99; //18024.49; //2026 Round(PrvConstant[1].PrvBracketTax2 + (PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2) / 100);


    // from 5008-c bottom page 1
    PrvConstant[0].PrvDonRate1:= vl(PrvConstant[0].PrvRate1); // 20251117 Igor
    PrvConstant[1].PrvDonRate1:= vl(PrvConstant[1].PrvRate1); // 20251117 Igor

    // 5008c
    PrvConstant[0].PrvDonRate2:= vl(PrvConstant[0].PrvRate3); // 20251117 Igor
    PrvConstant[1].PrvDonRate2:= vl(PrvConstant[1].PrvRate3); // 20251117 Igor

  end; // sk
  {$endregion ' SK '}

  {$region ' NT '}
  if Prv.Equals('NT') then
  begin
    Cpi := 1.017;

    // from 5012-c                          //jz2025update-rev1: changed as per form
    PrvConstant[0].PrvBracket1 := 53003.00; //51964.00; // 2026
    PrvConstant[1].PrvBracket1 := 53003.00; //51964.00; // 2026
    PrvConstant[0].PrvBracket2 := 106009.00; //103930.00; // 2026
    PrvConstant[1].PrvBracket2 := 106009.00; //103930.00; // 2026
    PrvConstant[0].PrvBracket3 := 172346.00; //168967.00; // 2026
    PrvConstant[1].PrvBracket3 := 172346.00; //168967.00; // 2026

    // from 5012-c
    PrvConstant[0].PrvRate1 := '5.9'; //2026
    PrvConstant[1].PrvRate1 := '5.9'; //2026
    PrvConstant[0].PrvRate2 := '8.6'; //2026
    PrvConstant[1].PrvRate2 := '8.6'; //2026
    PrvConstant[0].PrvRate3 := '12.2'; //2026
    PrvConstant[1].PrvRate3 := '12.2'; //2026
    PrvConstant[0].PrvRate4 := '14.05'; //2026
    PrvConstant[1].PrvRate4 := '14.05'; //2026

    // from 5012-c                            //jz2025update-rev1: changed as per form
    PrvConstant[0].PrvBracketTax1 := 0;
    PrvConstant[1].PrvBracketTax1 := 0;
    PrvConstant[0].PrvBracketTax2 := 3127.18; //3065.88; //2026 Round(PrvConstant[0].PrvBracketTax1 + PrvConstant[0].PrvBracket1 * vl(PrvConstant[0].PrvRate1) / 100);
    PrvConstant[1].PrvBracketTax2 := 3127.18; //3065.88; //2026 Round(PrvConstant[1].PrvBracketTax1 + PrvConstant[1].PrvBracket1 *      vl(PrvConstant[1].PrvRate1) / 100);
    PrvConstant[0].PrvBracketTax3 := 7685.69; //7534.95; //2026 Round(PrvConstant[0].PrvBracketTax2 + (PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2) / 100);
    PrvConstant[1].PrvBracketTax3 := 7685.69; //7534.95; //2026 Round(PrvConstant[1].PrvBracketTax2 + (PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2) / 100);
    PrvConstant[0].PrvBracketTax4 := 15778.81; //15469.47; //2026 Round(PrvConstant[0].PrvBracketTax3 + (PrvConstant[0].PrvBracket3 - PrvConstant[0].PrvBracket2) * vl(PrvConstant[0].PrvRate3) / 100);
    PrvConstant[1].PrvBracketTax4 := 15778.81; //15469.47; //2026 Round(PrvConstant[1].PrvBracketTax3 + (PrvConstant[1].PrvBracket3 - PrvConstant[1].PrvBracket2) * vl(PrvConstant[1].PrvRate3) / 100);


    // from 5012-c bottom page 1
    PrvConstant[0].PrvDonRate1 := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1 := vl(PrvConstant[1].PrvRate1);

    // from 5012-c bottom page 1
    PrvConstant[0].PrvDonRate2 := 14.05; // 2023
    PrvConstant[1].PrvDonRate2 := 14.05; // 2023

  end; // NT
  {$endregion ' NT '}

  {$region ' NB '}
  if Prv.Equals('NB') then
  begin
    Cpi := 1.017;
    // from 5004-c
    PrvConstant[0].PrvBracket1 := 52333; //51306; //2026
    PrvConstant[1].PrvBracket1 := 52333; //51306; //2026
    PrvConstant[0].PrvBracket2 := 104666; //102614; //2026
    PrvConstant[1].PrvBracket2 := 104666; //102614; //2026
    PrvConstant[0].PrvBracket3 := 193861; //190060; //2026
    PrvConstant[1].PrvBracket3 := 193861; //190060; //2026

    // from 5004-c
    PrvConstant[0].PrvRate1 := '9.40'; // 2026 //jz2025update-rev1: no change
    PrvConstant[1].PrvRate1 := '9.40'; // 2026
    PrvConstant[0].PrvRate2 := '14.00'; // 2026
    PrvConstant[1].PrvRate2 := '14.00'; // 2026
    PrvConstant[0].PrvRate3 := '16.00'; // 2026
    PrvConstant[1].PrvRate3 := '16.00'; // 2026
    PrvConstant[0].PrvRate4 := '19.50'; // 2026
    PrvConstant[1].PrvRate4 := '19.50'; // 2026

    // from 5004-c
    PrvConstant[0].PrvBracketTax1 := 0;
    PrvConstant[1].PrvBracketTax1 := 0;
    PrvConstant[0].PrvBracketTax2 := 4919.30; //4822.76; //2026 //4696.05; // 2024  Round(PrvConstant[0].PrvBracketTax1+PrvConstant[0].PrvBracket1 * vl(PrvConstant[0].PrvRate1)/100);
    PrvConstant[1].PrvBracketTax2 := 4919.30; //4822.76; //2026 //4696.05; // 2024  Round(PrvConstant[1].PrvBracketTax1+PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1)/100);
    PrvConstant[0].PrvBracketTax3 := 12245.92; //12005.88; //2026 //11690.17; // 2024  //2019 //Round(PrvConstant[0].PrvBracketTax2+(PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2)/100);
    PrvConstant[1].PrvBracketTax3 := 12245.92; //12005.88; //2026 //11690.17; // 2024  //Round(PrvConstant[1].PrvBracketTax2+(PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2)/100);
    PrvConstant[0].PrvBracketTax4 := 26517.12; //25997.24; //2026 //25313.85; // 2024  Round(PrvConstant[0].PrvBracketTax3+(PrvConstant[0].PrvBracket3 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[0].PrvRate3)/100);
    PrvConstant[1].PrvBracketTax4 := 26517.12; //25997.24; //2026 //25313.85; // 2024  Round(PrvConstant[1].PrvBracketTax3+(PrvConstant[1].PrvBracket3 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate3)/100);


    // from 5004-c bottom page 1
    PrvConstant[0].PrvDonRate1 := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1 := vl(PrvConstant[1].PrvRate1);

    // from 5004-c bottom page 1
    PrvConstant[0].PrvDonRate2 := 17.95; // 2023
    PrvConstant[1].PrvDonRate2 := 17.95; // 2023

  end; // NB
  {$endregion ' NB '}

  {$region ' PE '}
  if Prv.Equals('PE') then
  begin
    Cpi := 1.000;
    // from 5002-c  //20260117
    PrvConstant[0].PrvBracket1:= 33928; //33328; //2026
    PrvConstant[1].PrvBracket1:= 33928; //33368; //2026
    PrvConstant[0].PrvBracket2:= 65820; //64656; //2026
    PrvConstant[1].PrvBracket2:= 65820; //64656; //2026
    PrvConstant[0].PrvBracket3:= 106890; //105000; //2026
    PrvConstant[1].PrvBracket3:= 106890; //105000; //2026
    PrvConstant[0].PrvBracket4:= 142520; //140000; //2026
    PrvConstant[1].PrvBracket4:= 142520; //140000; //2026
    PrvConstant[0].PrvBracket5:= 200000; //2026
    PrvConstant[1].PrvBracket5:= 200000; //2026

    // from 5002-c
    PrvConstant[0].PrvRate1:= '9.50'; //2026
    PrvConstant[1].PrvRate1:= '9.50'; //2026
    PrvConstant[0].PrvRate2:= '13.47'; //2026
    PrvConstant[1].PrvRate2:= '13.47'; //2026
    PrvConstant[0].PrvRate3:= '16.60'; //2026
    PrvConstant[1].PrvRate3:= '16.60'; //2026
    PrvConstant[0].PrvRate4:= '17.62'; //2026
    PrvConstant[1].PrvRate4:= '17.62'; //2026
    PrvConstant[0].PrvRate5:= '19.00'; //2026
    PrvConstant[1].PrvRate5:= '19.00'; //2026
    PrvConstant[0].PrvRate6:= '20.00'; //2026
    PrvConstant[1].PrvRate6:= '20.00'; //2026

    // from 5002-c
    PrvConstant[0].PrvBracketTax1:= 0;
    PrvConstant[1].PrvBracketTax1:= 0;
    PrvConstant[0].PrvBracketTax2:= 3223.16; //3166.16; //2026 Round(PrvConstant[0].PrvBracketTax1+PrvConstant[0].PrvBracket1 * vl(PrvConstant[0].PrvRate1)/100);
    PrvConstant[1].PrvBracketTax2:= 3223.16; //3166.16; //2026 Round(PrvConstant[1].PrvBracketTax1+PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1)/100);
    PrvConstant[0].PrvBracketTax3:= 7519.01; //7386.04; //2026 Round(PrvConstant[0].PrvBracketTax2+(PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2)/100);
    PrvConstant[1].PrvBracketTax3:= 7519.01; //7386.04; //2026 Round(PrvConstant[1].PrvBracketTax2+(PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2)/100);
    PrvConstant[0].PrvBracketTax4:= 14336.63; //14083.15; //2026 Round(PrvConstant[0].PrvBracketTax2+(PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2)/100);
    PrvConstant[1].PrvBracketTax4:= 14336.63; //14083.15; //2026 Round(PrvConstant[1].PrvBracketTax2+(PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2)/100);
    PrvConstant[0].PrvBracketTax5:= 20614.64; //20250.15 ; //2026 Round(PrvConstant[0].PrvBracketTax2+(PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2)/100);
    PrvConstant[1].PrvBracketTax5:= 20614.64; //20250.15; //2026 Round(PrvConstant[1].PrvBracketTax2+(PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2)/100);
    PrvConstant[0].PrvBracketTax6:= 31535.84; //2026
    PrvConstant[1].PrvBracketTax6:= 31535.84; //2026

    // from 5002-c bottom page 1
    PrvConstant[0].PrvDonRate1 := vl(PrvConstant[0].PrvRate1); // 20251117 Igor //Used in UT3MJPE
    PrvConstant[1].PrvDonRate1 := vl(PrvConstant[1].PrvRate1); // 20251117 Igor //Used in UT3MJPE

    // from 5002-c bottom page 1
    PrvConstant[0].PrvDonRate2 := vl(PrvConstant[0].PrvRate5); //jz//20250731 //16.7; // 2023
    PrvConstant[1].PrvDonRate2 := vl(PrvConstant[0].PrvRate5); //jz//20250731 //16.7; // 2023

    // from 5002-d Line 6152
    //PrvDivRate and PrvDivRateBig values in array at beginning and populated all at once at end of this procedure see PrvDivRateValueArray0 and PrvDivRateBigValueArray0
   // from 5002-c top page 2
    PrvConstant[0].PrvOverseasRate := 57.5; // 2023
    PrvConstant[1].PrvOverseasRate := 57.5; // 2023

    // from 5002-c top page 2
    PrvConstant[0].PrvAmtCarryOverRate := 57.50; // 20251117 Igor
    PrvConstant[1].PrvAmtCarryOverRate := 57.50; // 20251117 Igor
  end; // pe
  {$endregion ' PE '}

  {$region ' NU '}
  if Prv.Equals('NU') then
  begin
    Cpi := 1.015; // 2018

    // from 5014-c                  //jz2025update-rev1: as per form
    PrvConstant[0].PrvBracket1 := 55801.00; //54707.00; //2026
    PrvConstant[1].PrvBracket1 := 55801.00; //54707.00; //2026
    PrvConstant[0].PrvBracket2 := 111602.00; //109413.00; //2026
    PrvConstant[1].PrvBracket2 := 111602.00; //109413.00; //2026
    PrvConstant[0].PrvBracket3 := 181439.00; //177881.00; //2026
    PrvConstant[1].PrvBracket3 := 181439.00; //177881.00; //2026

    // from 5014-c
    PrvConstant[0].PrvRate1 := '4'; // 2026
    PrvConstant[1].PrvRate1 := '4'; // 2026
    PrvConstant[0].PrvRate2 := '7'; // 2026
    PrvConstant[1].PrvRate2 := '7'; // 2026
    PrvConstant[0].PrvRate3 := '9'; // 2026
    PrvConstant[1].PrvRate3 := '9'; // 2026
    PrvConstant[0].PrvRate4 := '11.5'; // 2026
    PrvConstant[1].PrvRate4 := '11.5'; // 2026

    // from 5014-c                     //jz2025update-rev1: as per form
    PrvConstant[0].PrvBracketTax1 := 0; // 2024
    PrvConstant[1].PrvBracketTax1 := 0; // 2024
    PrvConstant[0].PrvBracketTax2 := 2232.04; //2188.28; //2026 //Round(PrvConstant[0].PrvBracketTax1 + PrvConstant[0].PrvBracket1 * vl(PrvConstant[0].PrvRate1) / 100);
    PrvConstant[1].PrvBracketTax2 := 2232.04; //2188.28; //2026 //Round(PrvConstant[1].PrvBracketTax1 + PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1) / 100);
    PrvConstant[0].PrvBracketTax3 := 6138.11; //6017.70; //2026 //Round(PrvConstant[0].PrvBracketTax2 + (PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2) / 100);
    PrvConstant[1].PrvBracketTax3 := 6138.11; //6017.70; //2026 //Round(PrvConstant[1].PrvBracketTax2 + (PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2) / 100);
    PrvConstant[0].PrvBracketTax4 := 12423.44; //12179.82; //2026 //Round(PrvConstant[0].PrvBracketTax3 + (PrvConstant[0].PrvBracket3 - PrvConstant[0].PrvBracket2) * vl(PrvConstant[0].PrvRate3) / 100);
    PrvConstant[1].PrvBracketTax4 := 12423.44; //12179.82; //2026 //Round(PrvConstant[1].PrvBracketTax3 + (PrvConstant[1].PrvBracket3 - PrvConstant[1].PrvBracket2) * vl(PrvConstant[1].PrvRate3) / 100);

    // from 5014-c bottom page 1
    PrvConstant[0].PrvDonRate1 := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1 := vl(PrvConstant[1].PrvRate1);

    // from 5014-c bottom page 1
    PrvConstant[0].PrvDonRate2 := 11.5; // 2023
    PrvConstant[1].PrvDonRate2 := 11.5; // 2023

    // from 5014-d Line 6152
    //PrvDivRate and PrvDivRateBig values in array at beginning and populated all at once at end of this procedure see PrvDivRateValueArray0 and PrvDivRateBigValueArray0
    {
    //PrvConstant[0].PrvDivRate :=
    //PrvConstant[1].PrvDivRate :=
    //PrvConstant[0].PrvDivRateBig :=
    //PrvConstant[1].PrvDivRateBig :=
    }

    // from 5014-c top page 2
    PrvConstant[0].PrvOverseasRate := 45; // 2023
    PrvConstant[1].PrvOverseasRate := 45; // 2023

    // from 5014-c top page 2
    PrvConstant[0].PrvAmtCarryOverRate := 45; // 20251117 Igor
    PrvConstant[1].PrvAmtCarryOverRate := 45; // 20251117 Igor
  end; // nu
  {$endregion ' NU '}

  {$region ' YT '}
  if Prv.Equals('YT') then
  begin
    Cpi := 1.017;

    // from 5011-c                          //jz2025update-rev1:as per form
    PrvConstant[0].PrvBracket1:= 58523.00; //57375.00; //2026
    PrvConstant[1].PrvBracket1:= 58523.00; //57375.00; //2026
    PrvConstant[0].PrvBracket2:= 117045.00; //114750.00; //2026
    PrvConstant[1].PrvBracket2:= 117045.00; //114750.00; //2026
    PrvConstant[0].PrvBracket3:= 181440.00; //177882.00; //2026
    PrvConstant[1].PrvBracket3:= 181440.00; //177882.00; //2026
    PrvConstant[0].PrvBracket4:= 500000.00; //2026
    PrvConstant[1].PrvBracket4:= 500000.00; //2026

    // from 5011-c
    PrvConstant[0].PrvRate1:= '6.40'; // 2024
    PrvConstant[1].PrvRate1:= '6.40'; // 2024
    PrvConstant[0].PrvRate2:= '9.00'; // 2024
    PrvConstant[1].PrvRate2:= '9.00'; // 2024
    PrvConstant[0].PrvRate3:= '10.90'; // 2024
    PrvConstant[1].PrvRate3:= '10.90'; // 2024
    PrvConstant[0].PrvRate4:= '12.80'; // 2024
    PrvConstant[1].PrvRate4:= '12.80'; // 2024
    PrvConstant[0].PrvRate5:= '15.00'; // 2024
    PrvConstant[1].PrvRate4:= '15.00'; // 2024

    // from 5011-c                            //jz2025update-rev1:as per form
    PrvConstant[0].PrvBracketTax1:= 0;
    PrvConstant[1].PrvBracketTax1:= 0;
    PrvConstant[0].PrvBracketTax2:= 3745.47; //3672.00; //2026 Round(PrvConstant[0].PrvBracketTax1 + PrvConstant[0].PrvBracket1 * vl(PrvConstant[0].PrvRate1) / 100);
    PrvConstant[1].PrvBracketTax2:= 3745.47; //3672.00; //2026 Round(PrvConstant[1].PrvBracketTax1 + PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1) / 100);
    PrvConstant[0].PrvBracketTax3:= 9012.45; //8835.75; //2026 Round(PrvConstant[0].PrvBracketTax2 + (PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2) / 100);
    PrvConstant[1].PrvBracketTax3:= 9012.45; //8835.75; //2026 Round(PrvConstant[1].PrvBracketTax2 + (PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2) / 100);
    PrvConstant[0].PrvBracketTax4:= 16031.51; //15717.14; //2026 Round(PrvConstant[0].PrvBracketTax3 + (PrvConstant[0].PrvBracket3 - PrvConstant[0].PrvBracket2) * vl(PrvConstant[0].PrvRate3) / 100);
    PrvConstant[1].PrvBracketTax4:= 16031.51; //15717.14; //2026 Round(PrvConstant[1].PrvBracketTax3 + (PrvConstant[1].PrvBracket3 - PrvConstant[1].PrvBracket2) * vl(PrvConstant[1].PrvRate3) / 100);
    PrvConstant[0].PrvBracketTax5:= 56807.19; //56948.24; //2026 Round(PrvConstant[0].PrvBracketTax4 + (PrvConstant[0].PrvBracket4 - PrvConstant[0].PrvBracket3) * vl(PrvConstant[0].PrvRate4) / 100);
    PrvConstant[1].PrvBracketTax5:= 56807.19; //56948.24; //2026 Round(PrvConstant[1].PrvBracketTax4 + (PrvConstant[1].PrvBracket4 - PrvConstant[1].PrvBracket3) * vl(PrvConstant[1].PrvRate4) / 100);

    // from 5011-c bottom page 1
    PrvConstant[0].PrvDonRate1 := vl(PrvConstant[0].PrvRate1); // 20251117 Igor //jzAmalg-20251124
    PrvConstant[1].PrvDonRate1 := vl(PrvConstant[1].PrvRate1); // 20251117 Igor

    // from 5011-c bottom page 1
    PrvConstant[0].PrvDonRate2 := vl(PrvConstant[0].PrvRate4); // 20251117 Igor //jzAmalg-20251124
    PrvConstant[1].PrvDonRate2 := vl(PrvConstant[0].PrvRate4); // 20251117 Igor //jzAmalg-20251124


    // from 5011-c top page 2
    PrvConstant[0].PrvOverseasRate := 42.67; // 2023
    PrvConstant[1].PrvOverseasRate := 42.67; // 2023

    // from 5011-c top page 2
    PrvConstant[0].PrvAmtCarryOverRate := 42.67; // 2023
    PrvConstant[1].PrvAmtCarryOverRate := 42.67; // 2023

  end; // yt
  {$endregion ' YT '}

  {$region ' NS '}
  if Prv.Equals('NS') then
  begin
    Cpi := 1.000;

    // from 5003-c                //jz2025update-rev1: update brackets as per form
    PrvConstant[0].PrvBracket1 := 30995.00; //30507.00; //2026
    PrvConstant[1].PrvBracket1 := 30995.00; //30507.00; //2026
    PrvConstant[0].PrvBracket2 := 61991.00; //61015; //2026
    PrvConstant[1].PrvBracket2 := 61991.00; //61015; //2026
    PrvConstant[0].PrvBracket3 := 97417.00; //95883.00; //2026
    PrvConstant[1].PrvBracket3 := 97417.00; //95883.00; //2026
    PrvConstant[0].PrvBracket4 := 157124.00; //154650.00; //2026
    PrvConstant[1].PrvBracket4 := 157124.00; //154650.00; //2026

    // from 5003-c
    PrvConstant[0].PrvRate1 := '8.79';  // 2026
    PrvConstant[1].PrvRate1 := '8.79';  // 2026
    PrvConstant[0].PrvRate2 := '14.95'; // 2026
    PrvConstant[1].PrvRate2 := '14.95'; // 2026
    PrvConstant[0].PrvRate3 := '16.67'; // 2026
    PrvConstant[1].PrvRate3 := '16.67'; // 2026
    PrvConstant[0].PrvRate4 := '17.5';  // 2026
    PrvConstant[1].PrvRate4 := '17.5';  // 2026
    PrvConstant[0].PrvRate5 := '21';    // 2026
    PrvConstant[1].PrvRate5 := '21';    // 2026

    // from 5003-c                    //jz2025update-rev1: update base amount as per form
    PrvConstant[0].PrvBracketTax1 := 0;
    PrvConstant[1].PrvBracketTax1 := 0;
    PrvConstant[0].PrvBracketTax2 := 2724.46; //2681.57; //2026
    PrvConstant[1].PrvBracketTax2 := 2724.46; //2681.57; //2026 // Round(PrvConstant[1].PrvBracketTax1 + PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1) / 100);
    PrvConstant[0].PrvBracketTax3 := 7358.36; //7242.51; //2026 // Round(PrvConstant[0].PrvBracketTax2+(PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2)/100);
    PrvConstant[1].PrvBracketTax3 := 7358.36; //7242.51; //2026 // Round(PrvConstant[1].PrvBracketTax2 + (PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2) / 100);
    PrvConstant[0].PrvBracketTax4 := 13263.88; //13055.01; //2026 // Round(PrvConstant[0].PrvBracketTax3+(PrvConstant[0].PrvBracket3 - PrvConstant[0].PrvBracket2) * vl(PrvConstant[0].PrvRate3)/100);
    PrvConstant[1].PrvBracketTax4 := 13263.88; //13055.01; //2026 // Round(PrvConstant[1].PrvBracketTax3+(PrvConstant[1].PrvBracket3 - PrvConstant[1].PrvBracket2) * vl(PrvConstant[1].PrvRate3)/100);
    PrvConstant[0].PrvBracketTax5 := 23712.60; //23339.23; //2026 // Round(GetTaxOnBase(PrvConstant[0].PrvBracket4,PrvConstant[0].PrvBracket3,Vl(PrvConstant[0].PrvRate4),PrvConstant[0].PrvBracketTax4));
    PrvConstant[1].PrvBracketTax5 := 23712.60; //23339.23; //2026 // Round(PrvConstant[1].PrvBracketTax4+(PrvConstant[1].PrvBracket4 - PrvConstant[1].PrvBracket3) * vl(PrvConstant[1].PrvRate4)/100);

    // from 5003-c bottom page 1
    PrvConstant[0].PrvDonRate1 := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1 := vl(PrvConstant[1].PrvRate1);

    // from 5003-c bottom page 1
    PrvConstant[0].PrvDonRate2 := 21; // 2023
    PrvConstant[1].PrvDonRate2 := 21; // 2023



    // from 5003-c top page 2
    PrvConstant[0].PrvOverseasRate := 57.5; // 2023
    PrvConstant[1].PrvOverseasRate := 57.5; // 2023

    // from 5003-c top page 2
    PrvConstant[0].PrvAmtCarryOverRate := 57.5; // 2023
    PrvConstant[1].PrvAmtCarryOverRate := 57.5; // 2023

  end; // ns
  {$endregion ' NS '}

  //jz//20250731 - enter all the PrvDivRate and PrvDivRateBig values
  for i := low(prvArray) to high(prvArray) do
  begin
    If Prv = prvArray[i] then
    begin
      PrvConstant[0].PrvDivRate    := PrvDivRateValueArray0[i];
      PrvConstant[1].PrvDivRate    := PrvDivRateValueArray1[i];

      PrvConstant[0].PrvDivRateBig := PrvDivRateBigValueArray0[i];
      PrvConstant[1].PrvDivRateBig := PrvDivRateBigValueArray1[i];
    end;
  end;

end;

//20250409 from JURA
Procedure T3(RetNo:integer;FName:string;FNo:integer);
Var i:Integer;
s:String; //20160207
begin
 //20211031
 LoadTv (RetNo, Fname, FNo);
 with Ret[RetNo].Frm[FNo] do
  begin
   if Strings[155]='' then Strings[155]:='T3Ret' ; //20240203   Return type

    //option 1
   If Strings[136]+Strings[137]='' then Strings[136]:='X';
   if Strings[136]='' then
   Begin
    for i:=3 to 8 do strings[i]:='';
    Strings[53]:='';Strings[67]:='';Strings[23]:='';
   End;
   //option 2
   if Strings[137]='' then
   Begin
    Strings[55]:='';Strings[60]:='';Strings[62]:='';Strings[63]:='';
    for i:=64 to 66 do Strings[i]:='';
    Strings[73]:='';Strings[74]:='';
   End;

   If Strings[14]+Strings[17] = '' then
     begin
      Strings[14] :=AppYear+'-01-01';
      Strings[17] :=AppYear+'-12-31';
     end;
   //If Strings[9] = '' then Strings[9] :=PrvLong[GetPrvIndex(OptRec.Nfl_Prov)]; //20250314 Igor cra tests have this field empty
   //if CertificationMode then Strings[9]:='';  //province 20170122 //20231203

   If Strings[15]+Strings[16] = '' then Strings[15]:='X';
   If Strings[16]='' then begin Strings[18]:='';Strings[19]:='';end;  //20231215 change [15] to [16]

   {If Strings[11]+Strings[12] = '' then Strings[12] :='X';}
   If Strings[26]+Strings[27] = '' then Strings[26] :='X';
   If Strings[27]='X' then Strings[28]:='';  //20220329 //first yer then orior yr blank
   If Strings[33]+Strings[34] = '' then Strings[34] :='X';  //20190328
   If Strings[35]+Strings[36] = '' then Strings[36] :='X';  //20190328
   //If Strings[34]+Strings[35] = '' then Strings[34] :='X';

   If Strings[37]+Strings[38] = '' then Strings[38] :='X';
  // If Strings[41]+Strings[45] = '' then Strings[41] :='X';
   If Strings[48]+Strings[49] = '' then Strings[48] :='X';
   If Strings[47]+Strings[59] = '' then Strings[47] :='X';
   //If Strings[79]+Strings[80] = '' then Strings[79] :='X'; //20250311 Igor
   If Strings[56]+Strings[76]='' then Strings[76]:='X';
   If Strings[31]+Strings[32] = '' then Strings[32] :='X';
   If Strings[363]+Strings[362] = '' then Strings[362] :='X';
   if CertificationMode=True then strings[362]:='';  //20230228

   //20180317
   if Strings[21]='' then
   Begin
    Strings[12]:='';
    Strings[13]:='';
    Strings[57]:='';
    Strings[68]:='';
    Strings[58]:='';
   End;

   //mailing address
   //20250312 Igor >>> we cannot have ths auto calculated because CRA test cases does not work with it
   //if Strings[75]+Strings[21]>'' then Strings[142]:='X';  //20231214 this should be > not =        //if Strings[75]+Strings[21]='' then Strings[142]:='X';  //20220308
   //if Strings[75]+Strings[21]='' then Strings[142]:='';   //20231214 if blank then remove X
   //20250312 Igor <<<

   //20161227 //20160505 Igor
   If IsIntervivos(RetNo)=False then
   Begin
    Strings[84]:='';
    //20160207
    s:=GetTrustTypeDescription(Strings[81]);
    Strings[82]:=LeftStr(s,60);// Strings[82]:=LeftStr(s,72);
   End;
   //type from trusttypes.d
   if Strings[81]>'' then begin Strings[43]:='';Strings[45]:='';end; //20220304
   if Strings[81]='' then Strings[82]:='';  //20220305

   //-----------------------
   HomeProv            :=UpperCase(GetShortPrv(Strings[9])); //20260118
   Ret[RetNo].Province :=          GetShortPrv(Strings[9]);  //jz//20260212 removing this causes errors, why both HomeProv and Ret[RetNo].Province???//20260118 //home province //FetchElm(RetNo,'T3',9));



   //s:=Ret[RetNo].Province;    //20260118

   Ret[RetNo].TrustYear := GetTrustYear(RetNo);
   If Ret[RetNo].TrustYear > AppYear then RY:=1 else RY:=0;
   InitPrvConstants(Ret[RetNo].Province);

   If CertificationMode then
   begin
    for i:=10 to 341 do Strings[i]:='';  //20230203
    //for i:=1 to 341 do Strings[i]:='';
   end;

   If OptRec.Capitalization='ProperCase' then
   begin
    Strings[1]:=ConvertToProper(Strings[1]);
    Strings[3]:=ConvertToProper(Strings[3]);
    Strings[4]:=ConvertToProper(Strings[4]);
    Strings[7]:=ConvertToProper(Strings[7]);
   end
   else
   begin
    Strings[1]:=UpperCase(Strings[1]);
    Strings[3]:=UpperCase(Strings[3]);
    Strings[4]:=UpperCase(Strings[4]);
    Strings[7]:=UpperCase(Strings[7]);
   end;

  end;

  //PAGE pg2 -------------------------------------------------------------------

 with Ret[RetNo].Frm[FNo] do
  begin
   //jz//20260315 - if not amended cannot have revision number
   If       Strings[32] > ''                         then strings[78] := ''
   else if (Strings[31] > '') and (strings[78] = '')  then strings[78] := 'R0';

   //20161227
   If Strings[127]+Strings[128] = '' then Strings[127] :='X';
   If Strings[130]+Strings[131] = '' then Strings[130] :='X';
   if Strings[135]+Strings[134]='XX' then begin Strings[135]:='';Strings[134]:='';end;   //20190331
   If Strings[135]+Strings[134] = '' then Strings[134] :='X';

   If Strings[33]+Strings[34] = '' then Strings[34] :='X'; //20160210
   If Strings[35]+Strings[36] = '' then Strings[36] :='X';

   If Strings[138]+Strings[139] = '' then Strings[138] :='X';
   If Strings[37]+Strings[38] = '' then Strings[38] :='X';  //20170122

   if Length(Strings[39]+Strings[40])>1 then begin Strings[39]:='';Strings[40]:='';end; //20190331
   if strings[39]='N'  then Strings[39]:='';
   if strings[40]='N'  then Strings[40]:='';
   If Strings[39]+Strings[40] = '' then Strings[40] :='X';

   If Strings[157]+Strings[158] = '' then Strings[157] :='X';
   If Strings[141]+Strings[152] = '' then Strings[152] :='X';
   If Strings[153]+Strings[154] = '' then Strings[154] :='X';
   If Strings[70]+Strings[71] = '' then Strings[71] :='X';

   //20250327 Igor >>>
   If Strings[79] + Strings[80] = '' then
     Strings[79]:= 'X';
   If Strings[144] + Strings[149] = '' then
     Strings[149] := 'X';
   If Strings[176] + Strings[177] = '' then
     Strings[177] := 'X';
   If Strings[178] + Strings[179] = '' then
     Strings[179] := 'X';
   If Strings[165] + Strings[166] = '' then
     Strings[166] := 'X';
   //20250327 Igor <<<

   //jz//20260307 - set default for newly added elms
   If Strings[183] + Strings[184] = '' then
     Strings[184] := 'X';
   If Strings[185] + Strings[186] = '' then
     Strings[186] := 'X';
   If Strings[187] + Strings[188] = '' then
     Strings[188] := 'X';
   if Strings[169] + Strings[170] = '' then Strings[170]:= 'X'; //20260930 Alex
   if not Strings[169].Equals('X') then Strings[164]:= ''; //20260930 Alex

   //20190331
   if Length(Strings[42])<8 then  Strings[42]:='';
   if Length(Strings[69])<8 then  Strings[69]:='';

   if Not Numeric(Strings[41]) then  Strings[41]:='';
   if Length(Strings[41])>4 then  Strings[41]:='';

   if Not Numeric(Strings[159]) then  Strings[159]:='';
   if Length(Strings[159])>4 then  Strings[159]:='';

   if Not Numeric(Strings[129]) then  Strings[129]:='';
   if Length(Strings[129])>4 then  Strings[129]:='';

   If CertificationMode then
   begin
    for i:=127 to 147 do Strings[i]:='';
    for i:=157 to 159 do Strings[i]:='';
    for i:=152 to 154 do Strings[i]:='';
    Strings[141]:='';
    //20170121
    for i:=33 to 34 do Strings[i]:='';
    for i:=35 to 36 do Strings[i]:='';
    for i:=37 to 38 do Strings[i]:='';
    for i:=39 to 40 do Strings[i]:='';   //20170122
    for i:=70 to 71 do Strings[i]:='';
   end;

   {Total Income}
   Tv[101] := MaxR(0,Vl(FetchElm (RetNo, 'S1', 97))); //20250324//MaxR(0,Vl(FetchElm (RetNo, 'S1', 246)));
    //20131228
    // If UpperCase(FetchElm(RetNo,'T1055',36)) = 'Y' then
    If Vl(FetchElm (RetNo, 'T1055', 303))>0 then
      Tv[101] := MaxR(0,Vl(FetchElm (RetNo, 'T1055', 303)));

    Tv[102] := Vl (FetchElm (RetNo, 'PENSINC', 46));
    Tv[103] := Vl (FetchElm (RetNo, 'S8', 1));
    if SiftTrust(RetNo)=True then Tv[103]:=0; //20240108

    Tv[140] := Vl (FetchElm (RetNo, 'S8', 4));
    if SiftTrust(RetNo)=True then Tv[140]:=0; //20240108


  //  Tv[77]  := Vl (FetchElm (RetNo, 'S8', 42)); //j 20122014

    Tv[104] := Vl (FetchElm (RetNo, 'S8', 5));
    Tv[105] := Vl (FetchElm (RetNo, 'S8', 14));

    //20170827 Page 2 of T3

    //business
    Tv[106] := TotMultiple(RetNo,'T2125',32)+Ret[RetNo].T5013GrossIncome;
    Tv[107] := TotMultiple(RetNo,'T2125',106)+Ret[RetNo].T5013BusIncome+Ret[RetNo].T3FBusInc1+Ret[RetNo].T3FBusInc2+Ret[RetNo].T3FBusInc3;

    {Farming}
    Tv[108] := TotMultiple(RetNo,'T2042',66)+TotMultiple(RetNo,'T2121',35); //20161227
    Tv[109] := TotMultiple(RetNo,'T2042',148)+Ret[RetNo].T5013FarmIncome+
                TotMultiple(RetNo,'T2121',74)+Ret[RetNo].T5013FishIncome;

   {rental}
    Tv[112] := TotMultiple(RetNo,'T776',56);
    Tv[113] := TotMultiple(RetNo,'T776',106)+Ret[RetNo].T5013RentIncome;

    Tv[116]:= Vl(FetchElm(RetNo,'T1055',227));
    Strings[160]:='T3 Box 22, T4AP Box 20, T5 Box 17, T5013 Boxes 114/120 other income';
    // see Trimstr
     Tv[161]:=Ret[RetNo].T3Pens+Ret[RetNo].T5Royalty+Ret[RetNo].T5013OthInc
       +Ret[RetNo].T4APOthInc;  //20211210

    Tv[123] := Tv[161]+Tv[118] + Tv[120] + Tv[122];
    Tv[124] := Tv[123];
    Tv[125] := 0;
    Tv[163]:= Vl(FetchElm(RetNo, 'S130', 460)); //20260302 Igor
    //Tv[125]:= Tv[125] + Tv[101] + Tv[102] + Tv[103] + Tv[104] + Tv[105] + Tv[107] + Tv[109] + Tv[113] + Tv[114] + Tv[116] + Tv[163] + Tv[124]; //+Tv[111] //20250119 //jz2025update-rev1: REMOVED FROM FORM -Tv[164]
    Tv[125]:= Tv[125] + Tv[101] + Tv[102] + Tv[103] + Tv[104] + Tv[105] + Tv[107] + Tv[109] + Tv[113] + Tv[114] + Tv[116] + Tv[163] + Tv[156] + Tv[124]; //20260930 Alex // Field 156 add to calculation, because line 13 added on the form
    Tv[126] := Tv[125];
  //  ShowMessage('After 126 '+FetchElm(Retno,'T3',272));   //20170305
 end;

  //PAGE pg3 -------------------------------------------------------------------

 with Ret[RetNo].Frm[FNo] do
  begin
    If Strings[260] ='' then Strings[260] :='Y';
    If Strings[261] ='' then Strings[261] :='Y';
    If Strings[262] ='' then Strings[262] :='Y';
    If Strings[263] ='' then Strings[263] :='Y';

    Tv[201] := Tv[126]; //Vl(FetchElm(RetNo,'PAGE_2',26));
    Tv[227] := Vl (FetchElm (RetNo, 'S8', 25));
    Tv[230] := MaxR(0,Tv[228] - Tv[229]);
    Tv[231] := Tv[230];
    Tv[232] := Vl(FetchElm(RetNo,'ABIL',57));

    //20240119
    //jz2025update-rev1: REMOVED FROM FORM
    //Tv[173]:=Vl(FetchElm(RetNo,'S1',248));
    //Tv[156]:=Vl(FetchElm(RetNo,'S1',255));

    Tv[243] := 0;

    i := 234;
    Repeat
      Tv[243] := Tv[243] + Tv[i];
      i := i + 2;
    until ( i > 242);

    Tv[244] := Tv[243];
    Tv[245] := Tv[227] + Tv[231] + Tv[232] + Tv[244];
    Tv[246] := Tv[245];
    Tv[247] := Tv[201] - Tv[246];
    Tv[250] := Tv[248] + Tv[249];
    Tv[251] := Tv[250];
    Tv[252] := Tv[247] + Tv[251];

    Tv[202]  := Vl (FetchElm (RetNo, 'S9', 33))+Vl(FetchElm (RetNo, 'AVLBLE',64)); //20220328  //under section 13.... //20220329
               // Vl(FetchElm (RetNo, 'AVLBLE',57)); //20220328  //under section 13....
    if UpperCase(Strings[77])<> 'Y' then
      Tv[203]:=Vl(FetchElm(RetNo,'AVLBLE',64)); //20220329
    //Tv[202]  := Vl (FetchElm (RetNo, 'S9', 33));
    Tv[204] := MaxR(0,Tv[202]-Tv[203]);
    Tv[253] := Tv[204];
    Tv[254] := Tv[252] - Tv[253]; //20220321 //MaxR(0,Tv[252] - Tv[253]);  //20220314

    Tv[255] := Vl (FetchElm (RetNo, 'S8', 32));
    if SiftTrust(RetNo)=True then Tv[255]:=0; //20240108

    Tv[256] := Tv[254] + Tv[255];
    //step 4
    Tv[85]:=Tv[256];
    If Ret[RetNo].FrmHasdata[GetFormNo('T3LOSS')] then
      Tv[265]:=Vl(FetchElm(RetNo,'T3LOSS',42));
    If Ret[RetNo].FrmHasdata[GetFormNo('T3LOSS')] then
      Tv[266]:=Vl(FetchElm(RetNo,'T3LOSS',208));
    Tv[171]:= Vl(FetchElm(RetNo, 'S130', 466)); //20260302 Igor //Tv[171]:=  user or s130
   //20211031
    Tv[92]:=0;
    for i:=86 to 91 do Tv[92]:=Tv[92]+Tv[i];
    Tv[92]:=Tv[92]+Tv[171];  //20250119
    Tv[269]:=Tv[92];
    //If Ret[RetNo].FrmHasdata[GetFormNo('T3OTHDED')] then Tv[269]:=Vl(FetchElm(RetNo,'T3OTHDED',6));

    Tv[270] := Tv[265] + Tv[266]+Tv[269]; //20180318 //Tv[269]; //20161227  //267
    Tv[271] := Tv[270];
   // Tv[172]:=
    Tv[272] :=MaxR(0,Tv[85] - Tv[271]); //20220310{ Need logic for min tax here and sch 11 & 12 ?}

    Tv[162]:=vl(FetchElm(RetNo,'S10',36));  //20250119

   If SubjectToMinTax(RetNo) then
      Tv[310] := Vl(FetchElm(RetNo,'S12',232))  //jz//20250815 was commented out for some reason but should be
   else
   begin
      Tv[310] := Vl(FetchElm(RetNo,'S11', 112));  //20250324
      If SiftTrust(RetNo) then //20250317 Igor
        Tv[310]:=Vl(FetchElm(RetNo,'SIFT', 12)); //20240108
   end;

    Tv[311] := GetTotProvTax(RetNo);
    if SiftTrust(RetNo)=True then Tv[311]:=Vl(FetchElm(RetNo,'SIFT',18));//20240108

    Tv[312] := Vl (FetchElm (RetNo, 'S10', 15));
    Tv[313] := Tv[162]+Tv[310] + Tv[311] + Tv[312]; //20250119
    Tv[314] := Tv[313];
  //  Tv[316] := Vl(FetchElm(RetNo,'T3OTHDED',13)); //20220304
    Tv[302] := MaxR(0,Tv[316]-Tv[301]);
    Tv[303] := Tv[302];
    //{Tv[16] := ? tax per info slips}

    Tv[317] := Vl(FetchElm(RetNo,'S11',114));
    If (SubjectToMinTax(RetNo)) and (Ret[RetNo].Province = 'QC') then
         Tv[317] := Vl(FetchElm(RetNo,'S12',247));  //jz//20260223 - wrong elm, change from 147

    //Tv[318] := Vl(FetchElm(RetNo,'T2038',123));
    Tv[318] := Vl(FetchElm(RetNo,'T2038',135));  //jz//20260223 - new T1 version ported over has different elms

    Tv[174] := Vl(FetchElm(RetNo,'T1098',116));   //jz//20260308 - added T1098 form
    Tv[175]:= Vl(FetchElm(RetNo, 'T1099', 64)); //20261006 Alex - added T1099 form

    Tv[319]:=Vl(FetchElm(RetNo,'T184',142)); //jz2025update-rev1: moved from pg5 below, not sure why it was there
    if not Strings[81].Equals('324') then Tv[319]:= 0; //20260216 Igor //Ret[Retno].TrustType <> IvMutualFund

    Tv[320]:=Ret[RetNo].T3Xii;

    //Tv[180]:= Tv[315]+Tv[303]+Tv[317]+Tv[318]+Tv[174]+Tv[319]+Tv[320]; //jz2025update-rev1: new field added
    Tv[180]:= Tv[315] + Tv[303] + Tv[317] + Tv[318] + Tv[174] + Tv[175] + Tv[319] + Tv[320]; //20260930 Alex update-rev2: new field added

    {
    //jz2025update-rev1: not sure why this is here, as is done below on pg5
    Tv[322] := Tv[315]+Tv[303];
    for i := 317 to 321 do
      Tv[322] := Tv[322] + Tv[i];
    TV[323] := Tv[322];
    Tv[324] := Tv[314] - Tv[323];
    }

 end;
  //Step 5PAGE pg4 -------------------------------------------------------------------

  With Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin

    //lines 59 - 75 are vtuser //jz2025update-rev1: new field added

    //20211031
    Tv[132]:=0;
    for i:=93 to 100 do Tv[132]:=Tv[132]+Tv[i];

    //Tv[132]:= Tv[132] + Tv[110] + Tv[111] + Tv[145] + Tv[146] + Tv[147] + Tv[148] + Tv[151] + Tv[181] + Tv[182]; //jz2025update-rev1: new fields added to total
    Tv[132]:= Tv[132] + Tv[110] + Tv[111] + Tv[146] + Tv[147] + Tv[181] + Tv[182]; //20260930 Alex update-rev2: fields: 145, 148, 151 removd from total and form

    Tv[133]:=Tv[132];
    Tv[322]:= Tv[180]+Tv[133]; //jz2025update-rev1  //Tv[315]+Tv[303]+Tv[317]+Tv[318]+Tv[174]+Tv[319]+Tv[320]+Tv[133]; //20250119  +Tv[175]
    Tv[323]:=Tv[322];
    Tv[324]:=Tv[314]-Tv[323];  //20220321

    If Frm[FNo].Strings[328]= '' then Frm[FNo].Strings[328] := OptRec.Prp_Name;
    If Frm[FNo].Strings[329]= '' then Frm[FNo].Strings[329] := OptRec.Prp_Street;
    If Frm[FNo].Strings[330]= '' then Frm[FNo].Strings[330] := OptRec.Prp_City;
    If Frm[FNo].Strings[331]= '' then Frm[FNo].Strings[331] := OptRec.Prp_Prov;
    If Frm[FNo].Strings[332]= '' then Frm[FNo].Strings[332] := OptRec.Prp_Postal;
    If Frm[FNo].Strings[333]= '' then Frm[FNo].Strings[333] := OptRec.Prp_Area;
    If Frm[FNo].Strings[334]= '' then Frm[FNo].Strings[334] := OptRec.Prp_Tel;

   // If UpperCase(Frm[FNo].Strings[341]) = 'Y' then
    Frm[FNo].Strings[340]:=OptRec.Prn_Disclm;
    // 'Prepared without audit from information supplied by client';
    If Frm[FNo].Strings[341] = '' then  //20201216
      Frm[FNo].Strings[341]:=  FormatDateTime('yyyy-mm-dd',Now);
    if CertificationMode then
    begin
      For i:=328 to 339 do Frm[FNo].Strings[i]:='';
      Frm[FNo].Strings[341]:='';   //20201216
    end;

   If FetchElm(RetNo,'T3',326)='' then Frm[FNo].Strings[326]:='0';  //20211214
   if CertificationMode=True then Frm[FNo].Strings[326]:='';
 end;

 if CertificationMode then            //20180226
 Begin
  Somelist:=TstringList.Create;
  Somelist.Add('2');
  Somelist.Add('9');Somelist.Add('15');Somelist.Add('14');Somelist.Add('27');Somelist.Add('26');
  Somelist.Add('148');Somelist.Add('127');Somelist.Add('130');Somelist.Add('134');Somelist.Add('34');
  Somelist.Add('36');Somelist.Add('138');Somelist.Add('38');Somelist.Add('40');Somelist.Add('157');
  Somelist.Add('152');Somelist.Add('154');Somelist.Add('71');Somelist.Add('339');Somelist.Add('');
  Somelist.Add('160'); //20180303
  ClearElmValues(RetNo,FNo,SomeList);
  Somelist.Free;
 End;

 SaveTv (RetNo, Fname, FNo);
end;


Procedure S2(RetNo:integer;FName:string;FNo:integer);
Var i:Integer;
begin
 LoadTv (RetNo, Fname, FNo);
 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
  //jz2025update-rev1:
  Tv[6]  := Tv[4]  - Tv[5];
  Tv[9]  := Tv[7]  - Tv[8];
  Tv[12] := Tv[10] - Tv[11];

  Tv[3] := Tv[4]+Tv[7]+Tv[10];
  Tv[2] := Tv[5]+Tv[8]+Tv[11];
  Tv[1] := Tv[6]+Tv[9]+Tv[12];
 end;
 SaveTv (RetNo, Fname, FNo);
end;

procedure ABIL(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;x:real;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   i := 3;
   Repeat
    {?ABIL  negative check}
    Tv[i+3] := Tv[i]-Tv[i+1]-Tv[i+2];
    If Tv[i+3] >0 then Tv[i+3] :=0;
    Tv[i+3] := Abs(Tv[i+3]);
    Inc(i,6);
   until i > 33;
   Tv[79]:=Ret[RetNo].T5013Abil;
   Tv[38]:= Tv[6]+Tv[12]+Tv[18]+Tv[24]+Tv[30]+Tv[36]+Tv[79];
   Tv[66] := Tv[38];


   Tv[42] := Tv[41] * 2;
   Tv[44] := Tv[43] * 3/2;
   Tv[48] := Tv[47] * 3/2;
   Tv[50] := Tv[49] * 4/3;
   If Vl(Strings[61])>0 then
    Tv[60] := Tv[59] * (1/Vl(Strings[61]))
   else
    Tv[60]:=0;
   Tv[40]:=Tv[39] * 2;
   Tv[58]:=Tv[52] * 2;
   Tv[64]:=Tv[63] * 2;
   Tv[77]:=Tv[76] * 2;
   Tv[51]:= Tv[42]+Tv[44]+Tv[48]+Tv[50]+Tv[60]+Tv[40]+Tv[58]+Tv[64]+Tv[77];

   Tv[53] := Tv[73]+Tv[74]+Tv[75]+Tv[62]+Tv[46]+Tv[69]+Tv[72]+Tv[78];
   Tv[54] := Tv[53];

   Tv[56] := MaxR(0,Tv[51]-Tv[54]);
   Tv[65] := MinR(Tv[66],Tv[56]);
   Tv[55]:=Tv[65];


   Tv[67]:= Tv[55];
   Tv[68]:=MaxR(0,Tv[66]-Tv[67]);
   Strings[71]:='0.50';
   Tv[70]:=Tv[68];
   Tv[57]:= Tv[70] * Vl(Strings[71]);
   if UpperCase(Strings[37])='Y' then Tv[57]:=Tv[45];

  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;



Procedure S3(RetNo:integer;FName:string;FNo:integer);
Var i,S2FNo:Integer;
begin
S2FNo:=GetFormNo('S2');  //20150122
LoadTv (RetNo, Fname, FNo);
With Ret[RetNo], Ret[RetNo].Frm[FNo] do
begin
  Tv[1]:=Vl(FetchElm (RetNo, 'S1', 106))
       + Vl(FetchElm (RetNo, 'S1', 114));
  //20150122
  Tv[2]:= Vl(FetchElmFNo(RetNo,S2FNo,6))
         +Vl(FetchElmFNo(RetNo,S2FNo,21))
         +Vl(FetchElmFNo(RetNo,S2FNo,3))
         +Vl(FetchElmFNo(RetNo,S2FNo,24))
         +Vl(FetchElmFNo(RetNo,S2FNo,9))
         +Vl(FetchElmFNo(RetNo,S2FNo,27));
  // + Vl (FetchElm (RetNo, 'S2', 9 ));

  Tv[5]:= Tv[1]+Tv[2];

  //jz2025update-rev1: added/changed  -->
  Tv[4]:= Tv[5]/2;
  Tv[8]:= Tv[4];
  Tv[12] :=Vl(FetchElm (RetNo, 'S1', 97))+Vl(FetchElm (RetNo, 'T1055', 305))- Vl(FetchElm(RetNo,'S1',68))/2;
  Tv[14] :=minR(Tv[8],Tv[12]);
  //jz2025update-rev1 <--

  Tv[15] := MaxR(0,MinR (Tv[8], Tv[12]));  //20191218
  Tv[16] := Vl (FetchElm (RetNo, 'T3', 266));
  Tv[17] := Tv[12]; //20191218
  Tv[18] := Tv[15];
  Tv[19] := Tv[17] - Tv[18];
  Tv[20] := MaxR (0, (Tv[16] - Tv[19]));
  Tv[21] := Vl (FetchElm (RetNo, 'T3', 232));
  Tv[22] := Tv[20] + Tv[21];
  Tv[23] := Tv[22];
  Tv[24] := MaxR (0, (Tv[15] - Tv[23]));
  {Part II}
  Tv[26] := Tv[15];
  Tv[27] := Tv[25] + Tv[26];
  Tv[28] := Tv[27];
  {Tv[29] := ? CNIL c/f}
  Tv[30] := Vl(FetchElm(RetNo,'S3',129));
  Tv[31] := MaxR(0,Tv[29] - Tv[30]);
  Tv[32] := Tv[23];
  Tv[33] := Tv[31] + Tv[32];
  Tv[34] := Vl (FetchElm (RetNo, 'S4', 122));
  Tv[35] := Tv[33] + Tv[34];
  Tv[36] := Tv[35];
  Tv[37] := MaxR(0,Tv[28] - Tv[36]);
  {Part III}
  Tv[38] := Tv[24];
  Tv[39] := Tv[37];
  {TV[40] := ? line 332 prv year}
  {TV[41] := ? line 930, prv yr}
  Tv[42] := Tv[40] + Tv[41];
  Tv[43] := Tv[42];
  Tv[44] := MaxR (0, (Tv[39] - Tv[43]));
  Tv[45] := Tv[44];
  Tv[46] := MinR (Tv[45], Tv[38]);
end;

//S3 Pg 2 ----------------------------------------------------------------------

With Ret[RetNo], Ret[RetNo].Frm[FNo] do
begin
 i := 101;
 Repeat
  Tv[i+2] := Tv[i+1]*(1/2);
  Tv[i+3] := MinR(Tv[i],Tv[i+2]);
  Inc(i,4);
 Until (i > 109);
 i :=113;
 Repeat
  Tv[i+2] := Tv[i+1]*(2/3);
  Tv[i+3] := MinR(Tv[i],Tv[i+2]);
  Inc(i,4);
 Until (i > 117);

 i := 121;
 Repeat
  Tv[i+2] := Tv[i+1]*(3/4);
  Tv[i+3] := MinR(Tv[i],Tv[i+2]);
  Inc(i,4);
 Until (i > 125);

 Tv[129] :=0;
 i:=104;
 Repeat
  Tv[129] := Tv[129]+Tv[i];
  Inc(i,4);
 Until (i > 128);
end;
SaveTv (RetNo, Fname, FNo);
end;

Procedure S4(RetNo:integer;FName:string;FNo:integer);
Var i:Integer;
begin
 LoadTv (RetNo, Fname, FNo);
 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
  Tv[1] := Vl(FetchElm(RetNo,'T3',227));    //20260117
  Tv[3] := Vl(FetchElm(RetNo,'T3',231));
  If Vl(FetchElm(RetNo,'T3',113)) <0 then
   Tv[6] :=ABS(Vl(FetchElm(RetNo,'T3',113)))
  else
   Tv[6] :=0;

  Tv[9] := Vl (FetchElm (RetNo, 'T3', 266));
  Tv[10] := Vl (FetchElm (RetNo, 'S3', 20));
  Tv[11] := Tv[9] - Tv[10];
  Tv[12] := Tv[11];
  Tv[13] := 0;
  for i := 1 to 8 do
      Tv[13] := Tv[13] + Tv[i];
  Tv[13] := Tv[13] + Tv[12];

  //Tv[14] := prv year S4, vtUSER
  Tv[14] := maxR(0,Tv[14]);         //jz//20260320 - stop from entering a neg amount

  Tv[15] := Tv[13] + Tv[14];
  Tv[16] := Tv[15];
 end;

 //s4 pg 2 ----------------------------------------------------------------------
 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
  Tv[106] := Tv[16]; //Vl(FetchElm (RetNo, 'S4_1', 16));
  Tv[102]:=  Vl(FetchElm (RetNo, 'S8', 13));
  Tv[101]:=Tv[102] * 1.38;      //20130201
  //20160130
  Tv[21]:=vl(FetchElm(RetNo,'S8',4));
  Tv[20]:=Tv[21]*1.15; //20191217  //Tv[21]*1.16; //1.17;

  Tv[109] := Vl(FetchElm (RetNo, 'T3', 104));
  Tv[110] := Vl(FetchElm (RetNo, 'T3', 105));
  Tv[111] := MaxR(0,Vl (FetchElm (RetNo, 'T3', 113)));
  {Tv[112] := ?}
  {Tv[113] := ?}

  Tv[114] := Vl(FetchElm (RetNo, 'S1', 97))
             + Vl(FetchElm (RetNo, 'T1055', 164))
             + Vl(FetchElm (RetNo, 'S3', 9));
  Tv[115] := Vl(FetchElm (RetNo, 'S11', 142)); //20211217
     //FetchElm (RetNo, 'S3', 15));     //20211217//Tv[115] := Vl(FetchElm (RetNo, 'S3', 15));

  Tv[116] := Tv[114] - Tv[115];
  Tv[117] := Tv[116];

  Tv[118] := Tv[101]+Tv[20]+Tv[109]+Tv[110]+Tv[111]+Tv[112]+Tv[113]+tv[117];
  {20160130
  for i := 108 to 113 do Tv[118] := Tv[118] + Tv[i];
  Tv[118] := Tv[118] + Tv[117];
  }
  Tv[120] := Tv[118] + Tv[119];
  Tv[121] := Tv[120];
  Tv[122] := MaxR (0, (Tv[106] - Tv[121]));
 end;
 SaveTv (RetNo, Fname, FNo);
end;

Procedure S5(RetNo:integer;FName:string;FNo:integer);
Var i:Integer;
begin
 LoadTv (RetNo, Fname, FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
  if (Strings[1]>'') or (Strings[2]>'')
  Or (CertificationMode)   //20170122
  then  //20160802
     //ok
    else
    begin
     for i:=7 to 83 do Tv[i] :=0;
     SaveTv (RetNo, Fname, FNo);
     exit;
    end;

    //Part B
    Tv[7] := Vl(FetchElm (RetNo, 'S3', 46));
    Tv[8] := Vl(FetchElm (RetNo, 'S9', 37)) +Vl(FetchElm (RetNo, 'S9', 140)); //20160130  Vl(FetchElm (RetNo, 'S9', 122));
    Tv[9] := MaxR(0,Tv[7] - Tv[8]);
    Tv[10] := Tv[9];
    Tv[11] := Tv[24];
    Tv[12] := Tv[34];
    Tv[13] := MaxR (0, (Tv[11] - Tv[12]));
    Tv[14] := Tv[13];
    Tv[15] := MaxR(0,Tv[10] - Tv[14]);
    Tv[16] := Tv[15];
    Tv[20] := MaxR(0,vl(FetchElm(RetNo,'S3',11))); {Tv[23];}
    Tv[21] := Tv[98]; //MinR(Tv[49],Tv[98]); //20160130MinR(Tv[66],Tv[83]);  //20160205
    Tv[22] := MinR(Tv[21],MinR(Tv[16],Tv[20]));

    //Chart 1
    Tv[17] := Tv[34];
    Tv[18] := MaxR(0,Tv[5] - Tv[17]);
    Tv[19] := Tv[18];
    Tv[24] := Tv[4] + Tv[19] + Tv[23];
    //Chart 2
    Tv[33] := Tv[25] + Tv[26] + Tv[27] + Tv[28] + Tv[29] + Tv[30] + Tv[31] + Tv[32];
    Tv[34] := Tv[33];

    //Chart 3
    Tv[37] := Tv[36] / 4;
    Tv[39] := Tv[38] / 3;
    Tv[41] := Tv[40] /3;
    Tv[45] := Tv[35] + Tv[36] + Tv[37] + Tv[38] + Tv[39] + Tv[40] + Tv[41] + Tv[42] + Tv[43] + Tv[44];

    //Part 1a  //20160205
    Tv[46]:=406800;
    Tv[49]:=250000;  //20170122
    If UpperCase(Strings[110])='Y' then
    Begin
     //Tv[46]:=406800; //20160130 //If Tv[46]>250000 then Tv[46]:=250000;
     Tv[47] := Tv[45];
     Tv[48] := MaxR(0,Tv[46] - Tv[47]);
     Tv[49] := Tv[48];
     Tv[50] := Vl(FetchElm(RetNO, 'S1', 106));
     Tv[51] := Vl(FetchElm(RetNO, 'S1', 114));
     Tv[55] := Vl(FetchElm(RetNO, 'S2', 21));
     Tv[54] := Vl(FetchElm(RetNO, 'S2', 24));
     Tv[56] := Vl(FetchElm(RetNO, 'S2', 27));
     Tv[52] := Vl(FetchElm(RetNO, 'T1055', 206));
     Tv[53] := Vl(FetchElm(RetNO, 'T1055', 214));

     Tv[57]  := Tv[50] + Tv[51] + Tv[55] + Tv[54] + Tv[56] + Tv[52] + Tv[53];
     Tv[58] := Tv[57] * 0.5;
     Tv[62] :=Vl(FetchElm(RetNo,'S3',9)); //20160205  //MinR(Tv[49],Tv[58]);//MinR(Tv[49],Tv[61]);

     Tv[59]:=Tv[58]+Tv[62];
     Tv[60]:=Tv[59];
     Tv[61]:=MinR(Tv[49],Tv[60]);
    End
    Else
    Begin
     For i:=47 to 62 do begin Tv[i]:=0; end;
    end;

    // Section 1b
    Tv[63]:= 400000;
    If UpperCase(Strings[111])='Y' then
    Begin
     TV[84] := TV[96]+Tv[83];
     TV[85] := MaxR(0,TV[63] - TV[84]);
     TV[86] := TV[85];
     Tv[64] := Tv[45];
     Tv[65] := MaxR(0,Tv[86] - Tv[64]);
     Tv[67] := MaxR(0,Vl(FetchElm(RetNO, 'S1', 106)));
     Tv[68] := MaxR(0,Vl(FetchElm(RetNO, 'S1', 114)));
     Tv[69] := MaxR(0,Vl(FetchElm(RetNO, 'S2', 21)));
     Tv[70] := MaxR(0,Vl(FetchElm(RetNO, 'S2', 24)));
     Tv[71] := MaxR(0,Vl(FetchElm(RetNO, 'S2', 27)));
     Tv[72] := MaxR(0,Vl(FetchElm (RetNO,'T1055', 206)));
     Tv[73] := MaxR(0,Vl(FetchElm (RetNO, 'T1055', 214)));
     Tv[74]  := Tv[67] + Tv[68] + Tv[69] + Tv[70] + Tv[71] + Tv[72] + Tv[73];
     Tv[75] := Tv[74] * 0.5;
     Tv[76] := Vl(FetchElm (RetNO, 'S3', 9));
     Tv[77] := MaxR(0,Tv[75] - Tv[76]);
     Tv[78] := Tv[77];
     Tv[79] := MinR(Tv[65],Tv[78]);
    End
    Else
    Begin
     For i:=84 to 86 do begin Tv[i]:=0;end;
     For i:=64 to 65 do begin Tv[i]:=0;end;
     For i:=67 to 79 do begin Tv[i]:=0;end;
    end;

    //Part 1c
    Tv[87] := 375000; //250000;  //20160205
    If UpperCase(Strings[112])='Y' then
    Begin
     Tv[88] := tv[83]; //Tv[45];  //20160205
     Tv[89] := MaxR(0,Tv[87] - Tv[88]);
     Tv[90] := Tv[89];
     Tv[99] :=Tv[45]; //20160205
     Tv[100]:=MaxR(0,Tv[90] - Tv[99]);

     Tv[91] := MaxR(0,Vl(FetchElm(RetNO, 'S2', 21)));  //20160205
     Tv[92] := MaxR(0,Vl(FetchElm(RetNO, 'S2', 24)));  //20160205
     Tv[93] := MaxR(0,Vl(FetchElm(RetNO, 'S2', 27)));  //20160205
     Tv[94] := Tv[91] + Tv[92] + Tv[93];
     Tv[95] := Tv[94] * 0.5;
     Tv[96] := MinR(Tv[90],Tv[96]);
    End
    Else
    Begin
     For i:=88 to 96 do begin Tv[i]:=0;end;
     For i:=99 to 100 do begin Tv[i]:=0;end;
    end;

    //Part 1d  //20160205  revised section
    TV[80] := 250000; //400000; //20160130 //375000;   //20160205
    If UpperCase(Strings[113])='Y' then
    Begin
    Tv[81]:=Tv[45];
    Tv[97]:= MaxR(0,Tv[80] - Tv[81]);
    Tv[101]:=Tv[97];
    Tv[102]:=MaxR(0,Vl(FetchElm(RetNo,'S2',6)));
    Tv[103]:=MaxR(0,Vl(FetchElm(RetNo,'S2',3)));
    Tv[104]:=MaxR(0,Vl(FetchElm(RetNo,'S2',9)));
    Tv[105]:=Tv[102]+Tv[103]+Tv[104];
    Tv[82]:=Tv[105]/2;   //20160217
    Tv[83]:=MinR(Tv[101],Tv[82]); //20160217
    end
    Else
    Begin
     For i:=81 to 83 do begin Tv[i]:=0; end;
     Tv[97]:=0;
     For i:=101 to 105  do begin Tv[i]:=0; end;
    end;

    //------------------------
    //section 1e  //20160205
    Tv[106]:=Tv[61];
    Tv[107]:=Tv[79];
    Tv[108]:=Tv[96];
    Tv[109]:=Tv[83];
    //20161227
    Tv[114]:=Tv[106]+Tv[107]+Tv[108]+Tv[109];
    Tv[98]:=Tv[114]; //Tv[106]+Tv[107]+Tv[108]+Tv[109];
 end;
 SaveTv (RetNo, Fname, FNo);
end;



Procedure S6(RetNo:integer;FName:string;FNo:integer);
Var i:Integer;x:real;s:String;
begin
 LoadTv (RetNo, Fname, FNo);
 with Ret[RetNo].Frm[FNo] do
  begin
   //Strings[1] := GetTrustYear(RetNo);
   Strings[1]:=GetT3TrustName(RetNo);
   s:=GetT3AccountNumber (RetNo);   //temp 20230228
   //s:='T'+GetT3AccountNumber (RetNo);
   Strings[2]:= MidStr(s,1,2);
   Strings[3]:= MidStr(s,3,4);
   Strings[4]:= MidStr(s,7,2);


   i:=10;x:=0; Tv[41]:=0;
   Repeat
    x:=x+Tv[i];
    Inc(i,5);
   until i>40;
   Tv[5] := MaxR(0,40000-x);
   If Certificationmode then Tv[5]:=0;
   i:=5;Tv[41]:=0;
   Repeat
    Tv[41]:=Tv[41]+Tv[i];
    Inc(i,5);
   until i>40;
  end;
SaveTv (RetNo, Fname, FNo);
end;

Procedure S7(RetNo:integer;FName:string;FNo:integer);
Var i:Integer;
begin
 LoadTv (RetNo, Fname, FNo);
 with Ret[RetNo].Frm[FNo] do
  begin
    Tv[4]:=Tv[3];  //20160217
    Tv[7]:=Tv[6];
    Tv[20] := Tv[2] + Tv[12] + Tv[14] + Tv[16];
    Tv[21]:=Tv[3]+Tv[19]+Tv[5]+Tv[6]+Tv[8]+Tv[9]+Tv[11]+Tv[13]+Tv[15]+Tv[17]+Tv[18];
    Tv[22] := Tv[7] + Tv[10];
    Tv[23] := Tv[26]+Tv[4];
    //Tv[21] := 0;
    //for i := 2 to 18 do Tv[21] := Tv[21] + Tv[i];
    //Tv[21] := MaxR(0,Tv[21] - Tv[20] - Tv[22] - Tv[23]); {Convoluted but fast}

    Tv[25] := Tv[20];
    Tv[24] := Tv[21];
    Tv[1] := Tv[25]+Tv[24];

    Tv[1]:=MinR(Tv[1],
            MinR(Vl(FetchElm(RetNo,'T3',102)),
            Vl(FetchElm(RetNo,'T3',252))));

  end;
 SaveTv (RetNo, Fname, FNo);
end;

Procedure S8(RetNo:integer;FName:string;FNo:integer);
Var i:Integer;
begin
 LoadTv (RetNo, Fname, FNo);
 with Ret[RetNo].Frm[FNo] do
  begin
    {bring from worksheet}
    //Tv[51]:=TotMultiple(RetNo,'INVSTM',58);  //20160204
    //If GetT3StartYear(RetNo)>'2013-12-31' then Tv[42]:=0;  //20150101  //20160205
    Tv[4] := TotMultiple(RetNo,'INVSTM',58);//MaxR(0,TotMultiple(RetNo,'INVSTM',58)-Tv[42]);  {div}  //20150101

    Tv[13] := TotMultiple(RetNo,'INVSTM',83); {div elig}
    if SiftTrust(RetNo)=True then Tv[13]:=0;   //20240109

    Tv[1]:=Tv[4]+Tv[13]; //20160204  //Tv[4]+Tv[42]+Tv[13];  //20141229
    Tv[2] := Vl(FetchElm(RetNo,'FINVSTM',44));
    Tv[3] := Vl(FetchElm(RetNo,'FINVSTM',86));
    Tv[5] := Tv[2] + Tv[3];

    Tv[6] := TotMultiple(RetNo,'INVSTM',60); {int bonds}
    Tv[8] := TotMultiple(RetNo,'INVSTM',62); {oth depos}
    Tv[9] := TotMultiple(RetNo,'INVSTM',64); {mortg}
    Tv[12]:= TotMultiple(RetNo,'INVSTM',66); {oth  invest}
    Tv[14] := Tv[6] + Tv[8]+Tv[9] + Tv[10]+Tv[12];

    Tv[37]:=Ret[RetNo].T5013CarrCharg;
    Tv[38]:=Tv[19]+Tv[37];
    Tv[25] := Tv[15] + Tv[16] + Tv[17] + Tv[38];

    //gross up
    Tv[33]:=Tv[13];
    Tv[31]:= Vl (FetchElm (RetNo, 'S9', 112));
    Tv[24]:=MaxR(0,Tv[33]-Tv[31]);
    Tv[23] := Vl (FetchElm (RetNo, 'S9', 27));
    Tv[22]:=MaxR(0,Tv[24]-Tv[23]);
    //If Ry=0 then      //20110324
    //begin
    Strings[41]:='38';
    Strings[40]:='38';
    //end
    {
    Else
    begin
     Strings[41]:='38';
     Strings[40]:='38';
    end;
    }
    Tv[21]:=Tv[22] * Vl(Strings[40])/100;  //20110324//44/100;  //20110201
    Tv[34]:=Tv[21];

    Tv[26] := Tv[4];
    Tv[27] := Vl (FetchElm (RetNo, 'S9', 17));
    Tv[28] := MaxR(0,Tv[26] - Tv[27]);
    Tv[29]:= Vl (FetchElm (RetNo, 'S9', 27));
    Tv[30] := MaxR(0,Tv[28] - Tv[29]);
    //Strings[39]:='25'; //20211213
    //20181113 Igor >>>
    Strings[39]:='15'; //'16'; //20191206
    if RY=1 then Strings[39]:='15'; //20160802
    //20181113 Igor <<<

    Tv[36] := Tv[30] * Vl(Strings[39])/100; //Tv[30] * 0.25;  //20140624
    //If Ry=1 then Tv[36] := Tv[30] * 0.18; //20140615
    Tv[35]:=Tv[36];
    Tv[32]:=Tv[34]+Tv[35];  //20160204
    (* 20160204
    //do  S8A first //20141229
    Tv[44]:=Tv[42];
    Tv[45]:=Vl(FetchElm(RetNo,'S9',129));
    Tv[46]:=MaxR(0,Tv[44]-Tv[45]);
    Tv[48]:=MaxR(0,Tv[46]-Tv[47]);
    Tv[49]:=25;
    Tv[50]:=Tv[48]*25/100;
    Tv[43]:=Tv[50]; //20141229
    Tv[32]:=Tv[34]+Tv[35]; //  20160204 +Tv[43];  //20141229
    *)
  end;
 SaveTv (RetNo, Fname, FNo);
end;


Procedure S9(RetNo:integer;FName:string;FNo:integer);
Var i,SlipFNo:Integer; InclRate,x:Real;  {fed from T3 slip supplementaries}
begin
 InclRate:=FetchInclusionRate(RetNo);
 LoadTv (RetNo, Fname, FNo);
 with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
   //20220312 If Frm[FNo].Strings[1]+Frm[FNo].Strings[2] = '' then  begin Frm[FNo].Strings[1]:= '';Frm[FNo].Strings[2]:= 'X';end;

    // 20220209 Igor >>>
    // default for Count Slips Automatically
    If Frm[FNo].Strings[88] + Frm[FNo].Strings[89] = '' then
      Frm[FNo].Strings[89] := 'X'; //20240129 Igor
    if Frm[FNo].Strings[88] = 'X' then
      Frm[FNo].Strings[3] :=IntToStr(CountAllT3Slips(RetNo)); //)+StrToInt(Frm[FNo].Strings[86])); //to be done 20211118
    //20220312

    if Frm[FNo].Strings[3] = '0' then Frm[FNo].Strings[3] := ''; //mjjz2024

    If (Frm[FNo].Strings[1]>'') and (Frm[FNo].Strings[2]>'') then begin Frm[FNo].Strings[1]:= ''; Frm[FNo].Strings[2]:= '';end;//20220312
    If (Frm[FNo].Strings[5]>'') and (Frm[FNo].Strings[6]>'') then begin Frm[FNo].Strings[5]:= ''; Frm[FNo].Strings[6]:= '';end;//20220312
    If (Frm[FNo].Strings[86]>'') and (Frm[FNo].Strings[87]>'') then begin Frm[FNo].Strings[86]:= ''; Frm[FNo].Strings[97]:= '';end;//20220312

    If CertificationMode then
    begin
     Frm[FNo].Strings[1]:= '';
     Frm[FNo].Strings[2]:= '';
     Frm[FNo].Strings[5]:= '';
     Frm[FNo].Strings[6]:= '';
     Frm[FNo].Strings[3]:= '';
     Frm[FNo].Strings[4]:= '';
    end;

    //PART A
    {get various amounts}
    Tv[7] := T3BoxRes[21]    * InclRate; //20220320// CON: must heve the icl rate 20211201 Igor !!! not sure that it is correct, but it fixes differences with example test case
    Tv[8] := T3BoxNonRes[21] * InclRate;
    Tv[9] := T3BoxPref[21]   * InclRate;

    Tv[11] := T3BoxRes[22];
    Tv[12] := T3BoxNonRes[22];

    //20150117
    Tv[14] := T3BoxRes[23];  //20160204 -Tv[126];
    Tv[15] := T3BoxNonRes[23]; //20160204 -Tv[127];
    Tv[16] := T3BoxPref[23]; //20160204  -Tv[128];


    Tv[18] := T3BoxRes[24];
    Tv[19] := T3BoxNonRes[24];
    Tv[20] := T3BoxPref[24];

    Tv[22] := T3BoxRes[25];
    Tv[23] := T3BoxNonRes[25];  //was dummied out //20220320  //manual??  //20220314
    Tv[24] := T3BoxPref[25];

    Tv[26] := T3BoxRes[26];
    Tv[27] := T3BoxNonRes[26];  //20220320 //was dummied out //manual??  //20220314
    Tv[28] := T3BoxPref[26];

    Tv[109] := T3BoxRes[49];
    Tv[110] := T3BoxNonRes[49];
    Tv[111] := T3BoxPref[49];
    //Part A add horizontally
    i:=7; Tv[i+3] := Tv[i] + Tv[i+1] + Tv[i+2];
    i:=14; Tv[i+3] := Tv[i] + Tv[i+1] + Tv[i+2];
    i:=18; Tv[i+3] := Tv[i] + Tv[i+1] + Tv[i+2];
    i:=22; Tv[i+3] := Tv[i] + Tv[i+1] + Tv[i+2];
    i:=26; Tv[i+3] := Tv[i] + Tv[i+1] + Tv[i+2];
    i:=109; Tv[i+3] := Tv[i] + Tv[i+1] + Tv[i+2];
    if SiftTrust(retNo)=True then Begin Tv[112]:=0;end; //20240109 then

    //Part A totals  //20141229
    Tv[30]:= Tv[7]+Tv[11]+Tv[14]+Tv[18]+Tv[22]+Tv[26]+Tv[109]; //20160204 +Tv[126];
    Tv[31]:= Tv[8]+Tv[12]+Tv[15]+Tv[19]+Tv[23]+Tv[27]+Tv[110]; //20160204 +Tv[127];
    Tv[32]:= Tv[9]+Tv[16]+Tv[20]+Tv[24]+Tv[28]+Tv[111]; //20160204 +Tv[128];
    Tv[33]:=Tv[10]+Tv[13]+Tv[17]+Tv[21]+Tv[25]+Tv[29]+Tv[112]; //20160204 +Tv[129];

    Tv[85]:=Tv[30]+Tv[31]+Tv[32];   //20202006
     //20180319
    Tv[34] := T3BoxRes[30]     * InclRate;
    Tv[35] := T3BoxNonRes[30]  * InclRate;
    Tv[36] := T3BoxPref[30]    * InclRate;

    Tv[38] := T3BoxRes[31];
    If Frm[FNo].Strings[123]='' then Tv[40] := T3BoxRes[32];  //20120330
    If Frm[FNo].Strings[123]='' then Tv[41] := T3BoxPref[32]; //20120330

    Tv[43] := T3BoxRes[33];
    Tv[44] := T3BoxNonRes[33];
    Tv[45] := T3BoxPref[33];

    Tv[47] := T3BoxRes[34];
    //Tv[48] := T3BoxNonRes[34];  //20220313 MANUAL???
    Tv[49] := T3BoxPref[34];

    Tv[51] := T3BoxRes[35];
    Tv[52] := T3BoxNonRes[35];

    Tv[54] := T3BoxRes[46];
    Tv[55] := T3BoxNonRes[46];

    Tv[57] := T3BoxRes[47];
    Tv[58] := T3BoxNonRes[47];

    Tv[60] := T3BoxRes[48];
    Tv[61] := T3BoxNonRes[48];

    x:=Tv[109]; //20120330
    If Frm[FNo].Strings[123]='' then   //no override
    Begin
     Tv[114]:= x * 1.38; //If RY=0 then  Tv[114]:= x * 1.38  Else Tv[114]:= x * 1.38;
    end;
    If Frm[FNo].Strings[123]='' then Tv[113]:= Tv[111];

    Tv[118]:=Tv[114];


    If RY=0 then
    begin
     Tv[117]:=Tv[118] * 15.0198/100;
     Tv[116]:=Tv[113]* 15.0198/100;
    end
    else
    begin
     Tv[117]:=Tv[118] * 15.0198/100;
     Tv[116]:=Tv[113] * 15.0198/100;
    end;



    Tv[105]:=Tv[114]+Tv[113];
    Tv[115]:=Tv[117]+Tv[116];

    if SiftTrust(retNo)=True then   //20240109
    Begin
       Tv[114]:=0; //20240109 then
       Tv[113]:=0;
       Tv[106]:=0;
       Tv[113]:=0;
       for i:=115 to 118  do Tv[i]:=0;
    end;

    If CertificationMode then
    begin
     Tv[54] := 0;
     Tv[55] := 0;

     Tv[57] := 0;
     Tv[58] := 0;

     Tv[60] := 0;
     Tv[61] := 0;
    end;

    Tv[63] := T3BoxRes[37];
    Tv[64] := T3BoxNonRes[37];

    Tv[66] := T3BoxRes[38];


    Tv[68] := T3BoxRes[39];
    Tv[69] := T3BoxPref[39];

    Tv[71] := T3BoxRes[40];
    Tv[72] := T3BoxNonRes[40];
    Tv[73] := T3BoxPref[40];

    Tv[75] := T3BoxRes[41];
    Tv[76] := T3BoxNonRes[41];
    Tv[77] := T3BoxPref[41];

    Tv[112]:=Tv[109]+Tv[110]+Tv[111];
    if SiftTrust(retNo)=True then Begin Tv[112]:=0;end; //20240109 then

    {Tv[34] thr' Tv[84] ?}
    // rows with all 3 columns
   // i:=119; Tv[i+3] := Tv[i] + Tv[i+1] + Tv[i+2];  //20141229
    i:=34; Tv[i+3] := Tv[i] + Tv[i+1] + Tv[i+2];
    i:=43; Tv[i+3] := Tv[i] + Tv[i+1] + Tv[i+2];
    i:=47; Tv[i+3] := Tv[i] + Tv[i+1] + Tv[i+2];
    i:=71; Tv[i+3] := Tv[i] + Tv[i+1] + Tv[i+2];
    i:=75; Tv[i+3] := Tv[i] + Tv[i+1] + Tv[i+2];
    i:=84; Tv[i+3] := Tv[i] + Tv[i+1] + Tv[i+2];
    i:=79; Tv[i+3] := Tv[i] + Tv[i+1] + Tv[i+2];

   // Othr rows
   Tv[13]:=Tv[11]+Tv[12];
   Tv[39]:=Tv[38];
   Tv[42]:=Tv[40]+Tv[41];
   Tv[53]:=Tv[51]+Tv[52];
   Tv[65]:=Tv[63]+Tv[64];
   Tv[67]:=Tv[66];
   Tv[56]:=Tv[54]+Tv[55];
   Tv[59]:=Tv[57]+Tv[58];
   Tv[62]:=Tv[60]+Tv[61];
   Tv[105]:=Tv[114]+Tv[113];
   Tv[115]:=Tv[117]+Tv[116];
   (*
   //20141229
   Tv[132]:=Tv[130]+Tv[131];
   Tv[136]:=Tv[134]+Tv[135];
   *)

    Tv[84] := Ret[RetNo].T3BoxRes[42];
    Tv[106] := Ret[RetNo].T3BoxNonRes[42];
    Tv[107] := Ret[RetNo].T3BoxPref[42];
    Tv[108]:=Tv[84]+Tv[106]+Tv[107];

    Tv[79] := Ret[RetNo].T3BoxRes[45];
    Tv[80] := Ret[RetNo].T3BoxNonRes[45];
    Tv[81] := Ret[RetNo].T3BoxPref[45];
    Tv[82]:=Tv[79]+Tv[80]+Tv[81];

    Tv[104] := Tv[42];
    Tv[39] := Tv[38];
    Tv[67] := Tv[66];
    Tv[70] := Tv[68] + Tv[69];
    Tv[82] := Tv[79]+Tv[80]+Tv[81];
  end;
 SaveTv (RetNo, Fname, FNo);
end;


Procedure S10(RetNo:integer;FName:string;FNo:integer);
Var i:Integer;
begin
 LoadTv (RetNo, Fname, FNo);
 with Ret[RetNo].Frm[FNo] do
  begin
    {20170331
    If (Ret[RetNo].TrustType = TestamSpousal)
    or (Ret[RetNo].TrustType = TestamOther)
    or (Ret[RetNo].TrustType = IvMutualFund)
     then
     Strings[38]:='N';
    }

    Tv[1 ] := Vl (FetchElm (RetNo, 'T3', 107)) +
              Vl (FetchElm (RetNo, 'T3', 109));
             // Vl (FetchElm (RetNo, 'T3', 111));//20161227
    Tv[2 ] := Vl (FetchElm (RetNo, 'T3', 113));
    {Tv[5] := ? }
    Tv[6 ] := 0;
    for i := 1 to 5 do
        Tv[6 ] := Tv[6] + Tv[i];
    Tv[7 ] := Vl (FetchElm (RetNo, 'S9', 30));
    Tv[8 ] := Vl (FetchElm (RetNo, 'S9', 31));

    Tv[9 ] := Tv[7] + Tv[8];
    Tv[10] := Tv[9];
    Tv[11] := Vl (FetchElm (RetNo, 'T3', 249));
    Tv[12] := Tv[10] - Tv[11];
    Tv[13] := Tv[12];
    Tv[14] := MinR (Tv[6], Tv[13]);
    Tv[15] := Tv[14] * 0.40;//Tv[14] * 0.36;  //20161227
    {Part XII.2}
    Tv[16] := Vl(FetchElm (RetNo, 'S9', 31));
    Tv[19] := Tv[13];
    Tv[17] := Tv[15];
    If Tv[19] >0 then
      Tv[18] := (Tv[16] / Tv[19]) * Tv[17]
    else
      Tv[18] :=0;
    Tv[20] := MaxR(0,Tv[15] - Tv[18]);


    If UpperCase(Strings[38]) <> 'Y' then
    begin
       for i:=1 to 20 do Tv[i]:=0;
    end;
   (*
    Tv[22] := Vl (FetchElm (RetNo, 'S9', 31));
    Tv[24] := Tv[22] + Tv[23];
    Tv[25] := Tv[24];
    Tv[30] := Tv[18];
    Tv[31] := 0;
    for i := 26 to 30 do
        Tv[31] := Tv[31] + Tv[i];
    Tv[32] := Tv[31];
    Tv[33] := Tv[25] - Tv[32];
    If Strings[35] >'' then Tv[34] := Tv[33] * Vl(Strings[35]) /100;
    {Tv[34] ? NR4}
    Tv[37] := Tv[34] - Tv[36];
   *)
  end;

 //s10 pg2 ---------------------------------------------------------------------

 with Ret[RetNo].Frm[FNo] do
  begin
   If Strings[121]='' then Strings[121]:='NR';

   If UpperCase(Strings[119])<>'Y' then
   begin
    For i:=101 to 143 do Tv[i]:=0;
    SaveTv(RetNo, Fname, FNo);
    Exit;
   end;

    Tv[122] := Vl (FetchElm (RetNo, 'S9', 31));
    Tv[124] := Tv[122] + Tv[123];
    Tv[125] := Tv[124];

    //Tv[26]:=Tv[20];
    Tv[130]:= Tv[18]; //Vl(FetchElm(RetNo,'S10_1',18));
    Tv[131]:= Tv[126]+Tv[127]+Tv[129]+Tv[130];
    Tv[132]:= Tv[131];

    //Tv[43]:=Tv[18];
    Tv[133]:=MaxR(0,Tv[125]-Tv[132]+Tv[143]);
    {
    Tv[30] := Vl(FetchElm(RetNo,'S10_1',18));
    Tv[31] := 0;
    for i := 26 to 30 do
        Tv[31] := Tv[31] + Tv[i];
    Tv[32] := Tv[31];
    Tv[33] := Tv[25] - Tv[32]+Tv[43];
    }
    If Strings[135]='' then Strings[135]:='25'; //20220305
    If Strings[135] >'' then Tv[134] := Tv[133] * Vl(Strings[135]) /100;
    {Tv[34] ? NR4}
    Tv[137] := Tv[134] - Tv[136];  //20220305

    Tv[104]:=Tv[101]+Tv[102]+Tv[103];
    //Tv[4]:=Tv[3];
    Tv[106]:=Tv[104]-Tv[105];

    Tv[107]:=MaxR(0,Tv[106]);
    Tv[108]:=AllocatedNonResTaxableGains(RetNo);
    Tv[109]:=AllocatedTaxableGains(RetNo);

    If Tv[109]<>0 then
      Tv[110]:=Tv[108]/Tv[109]
    else
      Tv[110]:=0;

    Tv[111]:=Tv[110];
    Tv[112]:=Tv[107] * Tv[111];

    Tv[113]:=Tv[108];
    Tv[114]:=Tv[113] *2;
    Tv[115]:=MinR(Tv[112],Tv[114]);

    Tv[116]:=Tv[108];
    Tv[117]:=Tv[115];
    Tv[118]:=Tv[117]  * (1/2);
    Tv[120]:=Tv[116]-Tv[118];
    //Tv[20]:=Tv[19];

  //  Tv[138]:=Tv[106];
  //  Tv[139]:=Tv[109];
  //  Tv[140]:=Tv[139] * 2;
    Tv[141]:=MaxR(0,MinR(Tv[138],Tv[140]));
    Tv[142]:=Tv[138]-Tv[141];
   end;

 SaveTv (RetNo, Fname, FNo);
end;


//20160908 several changes
Procedure S11(RetNo:integer;FName:string;FNo:integer);
Var
 i:Integer;

 SurtaxReduction :real;
 x,y,z,w,t:real;

 ss:string;
begin
 {GetFederalRates;}
 LoadTv (RetNo, Fname, FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
    For i:= 2 to 22 do begin Strings[i]:='';Tv[i]:=0;end;
    For i:= 56 to 62 do begin Strings[i]:='';Tv[i]:=0;end;
    For i:= 67 to 73 do begin Strings[i]:='';Tv[i]:=0;end;

    InitConstants;
   //20170909
    Strings[48]:=FormatFloat('###,###',Constant[RY].Bracket1);
    Strings[49]:=FormatFloat('###,###',Constant[RY].Bracket1);
    Strings[50]:=FormatFloat('###,###',Constant[RY].Bracket2);
    Strings[51]:=FormatFloat('###,###',Constant[RY].Bracket2);
    Strings[64]:=FormatFloat('###,###',Constant[RY].Bracket3);
    Strings[52]:=FormatFloat('###,###',Constant[RY].Bracket3);
    Strings[43]:=FormatFloat('###,###',Constant[RY].Bracket4);
    Strings[44]:=FormatFloat('###,###',Constant[RY].Bracket4);

    Ret[RetNo].Frm[FNo].Strings[5]:= '0.00';
    Ret[RetNo].Frm[FNo].Strings[17]:= '0.00';  //20160216
    Tv[6]:=Constant[RY].Bracket1;
    Tv[7]:=Constant[RY].Bracket2;
    Tv[57]:=Constant[RY].Bracket3;
    Tv[68]:=Constant[RY].Bracket4; //20160807
    Strings[11]:= Constant[RY].Rate1;
    Strings[12]:= Constant[RY].Rate2;
    Strings[13]:= Constant[RY].Rate3;
    Strings[59]:= Constant[RY].Rate4;
    Strings[70]:= Constant[RY].Rate5;  //20170122
    Tv[17]:= Constant[RY].BracketTax1;
    Tv[18]:= Constant[RY].BracketTax2;
    Tv[19]:= Constant[RY].BracketTax3;
    Tv[61]:= Constant[RY].BracketTax4;
    Tv[72]:= Constant[RY].BracketTax5;  //20160807
    If CertificationMode then Strings[5]:='0.00';
   //-----------------------------------------------


    //Tv[1] :=Round(GetTrustTxbl(RetNo));  //20220310
    t := GetTrustTxbl(RetNo);
    if t < 1 then
      Tv[1] := t
    else
      Tv[1] := Round(t);

    Tv[54]:=33;    //20211204
    //If GetStartTrustYear(RetNo) >'2015' then Tv[54]:=33; // else  Tv[54]:=29; //20160807

    If (OtherThanQreAndQdt(RetNo)=True)
    then
    begin
      Tv[53]:=Tv[1];
      //If GetYearEnd(RetNo) >'2015' then Tv[54]:=33 else  Tv[54]:=29; //20160807   //20170305   //20211204
      Tv[23] := Tv[53] * Tv[54]/100;
      If SiftTrust(retNo)=True then Tv[23]:=Vl(FetchElm(RetNo,'SIFT',12)); //20240108
    end
    Else  //20160811
    Begin
     Tv[53]:=0;
   //  Tv[54]:=0;
     Tv[23]:=0;
    End;


     If Tv[1] <=Constant[RY].Bracket1 then
        begin
         Tv[2] := Tv[1];
         Tv[8] := MaxR(0,Tv[2]-vl(Ret[RetNo].Frm[FNo].Strings[5]));
         Tv[14] := Tv[8] * Vl(Strings[11])/100;
         Tv[20] := Tv[14]+Tv[17];
        end;

     If (Tv[1] > Constant[RY].Bracket1) and (Tv[1] <= Constant[RY].Bracket2) then
        begin
         Tv[3] := Tv[1];
         Tv[9] := MaxR(0,Tv[3]-Tv[6]);
         Tv[15] := Tv[9] * Vl(Strings[12])/100;
         Tv[21] := Tv[15]+Tv[18];
        end;

     If (Tv[1] > Constant[RY].Bracket2) and (Tv[1] <=Constant[RY].Bracket3) then
        begin
         Tv[4] := Tv[1];
         Tv[10] := MaxR(0,Tv[4]-Tv[7]);
         Tv[16] := Tv[10] * Vl(Strings[13])/100;
         Tv[22] := Tv[16]+Tv[19];
        end;


     If (Tv[1] > Constant[RY].Bracket3) and (Tv[1] <=Constant[RY].Bracket4) then
     begin
         Tv[56] := Tv[1];
         Tv[58] := MaxR(0,Tv[56]-Tv[57]);
         Tv[60] := Tv[58] * Vl(Strings[59])/100;
         Tv[62] := Tv[60]+Tv[61];
     end;

     if Tv[1] > Constant[RY].Bracket4 then
     Begin
        Tv[67] := Tv[1];
        Tv[69]:=MaxR(0,Tv[67]-Tv[68]);
        Tv[71] := Tv[69] * Vl(Strings[70])/100;
        Tv[73]:=Tv[71]+Tv[72];
     End;


    //after top tax brackets
    If OtherThanQreAndQdt(RetNo)=True then
    begin
    // if IsDraft = false then   //20170121
     if CertificationMode=False then   //20180317
     Begin
     //20160808
      For i:= 2 to 22 do begin Strings[i]:='';Tv[i]:=0;end;
      For i:= 56 to 62 do begin Strings[i]:='';Tv[i]:=0;end;
      For i:= 67 to 73 do begin Strings[i]:='';Tv[i]:=0;end;
     end;
    end;

  //S11 pg 2 -------------------------------------------------------------------

  with Ret[RetNo].Frm[FNo] do
  begin
    x:= Tv[20]; //Vl(FetchElm(RetNo,'S11_1',20));
    y:= Tv[21]; //Vl(FetchElm(RetNo,'S11_1',21));
    z:= Tv[22]; //Vl(FetchElm(RetNo,'S11_1',22));
    w:= Tv[62]; //Vl(FetchElm(RetNo,'S11_1',62));

    if OtherThanQreAndQDt(RetNo) = True then
    Tv[138]:=Tv[23]
    Else
    Begin
     Tv[138]:=MaxR(MaxR(x,y),MaxR(z,w));
     Tv[138]:=MaxR(Tv[138],Tv[73]); //20160802
     Tv[138]:= MaxR(Tv[138],Tv[23]); //MaxR(Tv[138],Vl(FetchElm(RetNo,'S11_1',23)));
    end;

    Tv[26]:= vl(FetchElm (RetNo, 'T1098', 197)) + vl(FetchElm (RetNo, 'T1099', 67)); //20261006 Alex //vl(FetchElm (RetNo, 'T1098', 197)); //jz//20260308 - T1098 added
    Tv[27]:= vl(FetchElm (RetNo, 'T1098', 182)) + vl(FetchElm (RetNo, 'T1099', 65)) + vl(FetchElm (RetNo, 'T1099', 66)); //20261006 Alex //vl(FetchElm (RetNo, 'T1098', 182)); //jz//20260308 - T1098 added

    Tv[140]:=Tv[138]+Tv[24]+Tv[26]+Tv[27];  //jz//20260307 - add T1098 lines //20180108 Tv[138]+Tv[139]+Tv[24];   //20170122

    Tv[101]:= Vl (FetchElm (RetNo, 'S8', 34));
    Tv[120]:=Tv[101] * 54.5455/100; //Tv[1] * 61.1111/100;  //20110201
    if Tv[140]=0 then Tv[120]:=0;  //20220310

    Tv[121]:= Vl (FetchElm (RetNo, 'S8', 35));
    //20141229
    //20181106 Igor >>>
    Tv[122]:= Tv[121] * 69.2308/100; //72.7273/100; // 20180108  //20191218
    If Ry=1 then Tv[122]:= Tv[121] * 69.2308/100; // 20160807
    if Tv[140]=0 then Tv[122]:=0;  //20220310

    //20181106 Igor <<<
    Tv[141]:=Tv[120]+Tv[122]; //+Tv[43];  //20160204

    Tv[123]:=Tv[141];

    Tv[142]:=Vl(FetchElm(RetNo,'S11A',34)); //20170325
    if Tv[142] > MaxR(0,Tv[140]-Tv[123]) then Tv[142]:=MaxR(0,Tv[140]-Tv[123]);

    Tv[144]:= Tv[123]+Tv[142];
    Tv[145]:= Tv[144];
    Tv[115]:= MaxR(0,Tv[140]-Tv[145]);
    Tv[143]:= Vl(FetchElm(RetNo,'S12',207));
    Tv[146]:=MaxR(0,Tv[115]-Tv[143]);

  //if GetShortPrv(FetchElm(RetNo, 'T3', 9)).Equals('ZZ') then use this instead??
  If Ret[RetNo].Province = 'ZZ' then
  begin
      Tv[102]:= Tv[146]; // If Tv[102]=0 then Tv[102]:= Tv[146]; //20220311
      Tv[103] := Tv[102] * 48 /100;
     end
  else
  begin
   Tv[102] :=0;
   Tv[103]:=0;
  end;

  Tv[104]:=Tv[146]+Tv[103];

  Tv[45]:=Tv[104];   //20170301
  x:= MaxR(0,Vl(FetchElm(RetNo,'T3FFT#1',18))
               +Vl(FetchElm(RetNo,'T3FFT#2',18))
               +Vl(FetchElm(RetNo,'T3FFT#3',18)));


  If Ret[RetNo].Province <> 'ZZ' then {res trust only gets For Tax cr}
   Tv[33]:=x   // Tv[105] := x  //20170321
  else
   Tv[33]:=0;  //20170321 Tv[105] :=0;

  Tv[106] := Vl(FetchElm(RetNo,'POLIT',22));
  Tv[107] := CalcFedPolitCredit(Tv[106]);   //20130217
  {Fed Political Contrib calc exactly like many provinces eg MN}

  Tv[108] := MaxR(0,Vl(FetchElm(RetNo,'T2038',92))-Vl(FetchElm(RetNo,'S9',78))); //jz//20260307 from 'T2038',143 to match new T2038

  Tv[110] :=Tv[33]+Tv[107]+Tv[108]+Tv[109]+Tv[116]+Tv[117];  //20170324
  //Tv[105]+Tv[107]+Tv[108]+Tv[109]+Tv[116]+Tv[117];
  Tv[111] := Tv[110];
  Tv[118] := MaxR(0,Tv[45]-Tv[111]); //20170301
  Tv[112] := Tv[118]+Tv[119];

  ss := Ret[RetNo].Province;

  if (Ret[RetNo].Province = 'QC') or GetShortPrv(FetchElm(RetNo, 'T3', 9)).Equals('QC') then //20260216 Igor
  begin
   if Strings[25]='' then Strings[25]:='Y'; //20220315
   if UpperCase(Strings[25])='Y' then
   Begin
     Tv[113]:=Tv[146];
     If SubjectToMinTax(RetNo) then
       Tv[113]:=Vl(FetchElm(RetNo,'S12',227)) //20211217
   End;
   Tv[114] := Tv[113] * 16.5/100;
  end
  else
  begin
   Tv[113] :=0;
   Tv[114] := 0;
  end;
 end;
 end;  //??
 SaveTv (RetNo, Fname, FNo);
end;



Function GetSurtaxReduction(RetNo:Integer;Bft:real):real;
Var x:Real;
begin
 If Bft > 12500 then begin result :=0;exit;end;
 If Bft <= 8333 then begin result :=(Bft * 0.03)/2;exit;end;
 If ((Bft > 8333) and (Bft <= 12500)) then
   begin
    result :=MaxR(0,125-(Bft -8333)* 0.03);
    exit;
   end;
end;



procedure S12(RetNo: integer;FName: string;FNo: integer);
Var i:Integer;
begin
  LoadTv (RetNo, Fname, FNo);

  With Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
   //20250329
   if strings[61]='' then
   Begin
    for i:=1 to 60 do begin Strings[i]:='';Tv[i]:=0;end;
    for i:=63 to 545 do begin Strings[i]:='';Tv[i]:=0;end;
    SaveTv(RetNo, Fname, FNo);
    Exit;
   End;

    InitConstants; //20170122

//S12 PAGE 1 - part 1 ---elm 1 TO 134----------------
    Tv[1]  :=Vl(FetchElm (RetNO, 'S1', 97)); //20250329 //Vl(FetchElm (RetNO, 'S1', 271)); //20250329
    Tv[28] := Vl(FetchElm (RetNO, 'T1055', 164)); //line 2
    Tv[2]  := Vl(FetchElm (RetNO, 'S9', 10)); //line 3
    Tv[4]  := MaxR(0,(Tv[1] + Tv[28]) - Tv[2]); //line 4

    Tv[30] := Vl(FetchElm (RetNO, 'S1A', 32)) + Vl(FetchElm (RetNO, 'S1A', 77)); //jz//20260222
    Tv[31] := Vl(FetchElm (RetNO, 'S1A', 148));                                  //jz//20260222 - form changed
    Tv[32] := Tv[30] - Tv[31];                                                   //jz//20260222 - //* (Tv[31]/100);
    strings[63] := '30';
    Tv[33] := Tv[32] * vl(strings[63])/100; //line 7                                      //jz//20260222

    Tv[24] := Tv[4] + Tv[33];
    Tv[25] := Tv[24];             //line 8

    //Tv[6] := ; //user?
    Tv[7] := maxR(0,Tv[7]);  // otherwise vtuser?; //line 10

    Tv[8]  := Tv[6] - Tv[7];
    Tv[9]  := Tv[8];        //line 11

    //Tv[10] := ; //user? //line 12
    Tv[11] := maxR(0,Tv[11]); // otherwise vtuser?; //line 13

    Tv[12] := Tv[10] - Tv[11];
    Tv[13] := Tv[12]; //line 14

    //Tv[14] := ; //user? //line 15
    Tv[15] := maxR(0,Tv[15]); // otherwise vtuser?; //line 16
    Tv[16] := maxR(0,Tv[16]); // otherwise vtuser?; //line 17

    Tv[17] := Tv[15] + Tv[16];
    Tv[18] := Tv[17];          //line 18

    Tv[19] := Tv[14] - Tv[18];
    Tv[20] := Tv[19];          //line 19

    //Tv[21] := ; //user?      //line 20
    //Tv[22] := ; //user?      //line 21

    Tv[23] := Tv[25] + Tv[9] + Tv[13] + Tv[20] + Tv[21] + Tv[22]; //line 22

    Tv[126] := vl(fetchElm(RetNo, 'T3', 255)); //line 23
    Tv[58]  := Tv[23] - Tv[126]; //line 26
    Tv[134] := vl(fetchElm(RetNo, 'T3', 272)); //line 27
    //end PAGE 1 ----------------------------
  end; {end with}

//S12 PAGE 2 ---------------------------------------------------------------------

  With Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    //Tv[135] := ; //vtuser? //line 28a
    //Tv[26]  := ; //vtuser? //line 28b
    //Tv[34]  := ; //line 29
    TV[36] := 50; //line 30
    Tv[35] := Tv[34] * Tv[36]/100; //line 31
    //Tv[137] := ; //vtuser? //line 32
    Tv[37]:= Tv[58] + Tv[134] + Tv[135] + Tv[26] + Tv[35] + Tv[137]; //line 33 //20260204 Igor //Tv[37] := Tv[58] + Tv[135] + Tv[26] + Tv[35] + Tv[137]; //line 33
      // Tv[58] + Tv[134] + Tv[135] + Tv[26] + Tv[35] + Tv[137]; //line 33

      //Tv[38] := ; vtuser? //line 32
      //Tv[39] := ; vtuser? //line 33
      //Tv[40] := ; vtuser? //line 34
      //Tv[64] := ; vtuser? //line 35

    Tv[41] := Tv[38] + Tv[39] + Tv[40] + Tv[64];  //line 36
    Tv[42]:=50;                                   //line 37
    Tv[43] := Tv[41] * Tv[42]/100;                //line 38
    Tv[44] := Tv[43];                             //line 38

    Tv[141] := Tv[37] + Tv[44]; //MaxR(0,Tv[136] - Tv[140]); //line 39
     //20170122

    //---------------------------------------
    Tv[142]:=0;    //29250329 default
    if (FetchElm(RetNo,'T3',41)>'') //GRE
    and (LeftStr(FetchElm(RetNo,'T3',14),4)<'2024') then Tv[142]:=40000; //gaduated rate
    if IsDisabilityTrust(RetNo) then TV[142]:= 177882; //20260204 Igor //173205;
    {
    if IsQre(RetNo) then
      Tv[142] :=40000 //line 41
    else
      Tv[142] :=0;    //line 41
    }


    If IsT3Return(RetNo)=False then Tv[142]:=0; //line 41
    //below ???
    If Ret[RetNo].FrmHasdata[GetFormNo('S6')] then
      Tv[142] := MaxR(0,Vl(FetchElm(RetNo,'S6',5))); //line 41
    //If CertificationMode then Tv[142]:=0; //line 41
    //---------------------------------------

    Tv[143] := MaxR (0, (Tv[141] - Tv[142]));
    //end part 1---

    //page 2 part 2 ELM 101 TO 124
    //Tv[101] vtuser line 43
    //Tv[102] vtuser line 44
    //Tv[45]  vtuser line 45

    Tv[103] := Tv[101] + Tv[102] + Tv[45]; //line 46
    //Tv[104] := Tv[103];
    Tv[165] := 20.5; //line 47 20.5%
    Tv[105] := Tv[103] * (Tv[165] / 100.0); //20260218 Igor

    Tv[106] := TotMultiple(RetNo,'T3FFT', 1);
    Tv[166] := 66.67;
    Tv[107] := Tv[106] * (Tv[166] / 100.0); //line 49
    Tv[108] := TotMultiple(RetNo,'T3FFT', 7); //line 50
    Tv[109] := Tv[107] + Tv[108];
    Tv[110] := MinR (Tv[105], Tv[109]);
    Tv[111] := TotMultiple(RetNo,'T3FFT',18);
    Tv[112] := MaxR (Tv[110], Tv[111]);

    //page 2 PART 3 obligation for min tax
    Tv[113] := Tv[143];
    Tv[167] := 20.5;
    Tv[114] := Tv[113] * (Tv[167] /100.0);
    Tv[115] := Vl (FetchElm (RetNo, 'S11', 142)); //20211217 Vl (FetchElm (RetNo, 'S11', 37));

    Tv[56] := 80;                       //jz//2025updateforgotenT3//202508 - had as Tv[156]
    Tv[57] := Tv[115] * (TV[56]/100); //jz//2025updateforgotenT3//202508  - had as Tv[157] and had Tv[156]

    Tv[59]  := Tv[57]; //jz//2025updateforgotenT3//202508  - had as Tv[157]
    Tv[60]  := Vl(FetchElm (RetNo, 'S11', 109)) + Vl(FetchElm (RetNo, 'S11', 117));
    Tv[116] := Tv[114] - Tv[59] - Tv[60];
    Tv[117] := Tv[116];
    Tv[118] := Tv[112];
    Tv[119] := MaxR(0,Tv[117] - Tv[118]);
    Tv[120] := Vl (FetchElm (RetNo, 'S11', 112));
    Tv[121] := Vl (FetchElm (RetNo, 'S11', 103));
    Tv[122] := Tv[120] - Tv[121];
    Tv[123] := Tv[122];
    Tv[124] := MaxR (0, (Tv[119] - Tv[123]));
    //end PART 3
  end; //end with



//S12 PAGE 3 Elms 222 to 202 -------------------------------------------
  With Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    If CertificationMode then for i:=201 to 270 do begin Frm[Fno].Strings[i]:='';Tv[i]:=0;end;
    //20211217

    if SubjectToMinTax(RetNo)=false then
    begin
     for i:=225 to 230 do  begin Tv[i]:=0;end;
     Tv[232]:=0;
     for i:=246 to 261 do begin Tv[i]:=0; end;
    end
    Else
    begin
     Tv[225] := Vl(FetchElm (RetNo, 'S11', 146));  //20170322    // Tv[225] := Vl(FetchElm (RetNo, 'S11', 101));
     Tv[226] := Tv[117]; //Vl(FetchElm (RetNo, 'S12_2', 17));
     Tv[227] := MaxR (Tv[225], Tv[226]);

     Tv[228] := Tv[119]; //Vl(FetchElm (RetNo, 'S12_2', 19));

     Tv[268]:=48;

     If CertificationMode then begin tV[268]:=48;Tv[268]:=48;end; //20250322

     If Ret[RetNo].Province = 'ZZ' then
      begin
       Tv[229] := Tv[227];
       Tv[230] := Tv[229] * (Tv[268] /100.0);
      end
     else
      begin Tv[229] :=0;Tv[230] :=0;end;

     Tv[232] := Tv[228] + Tv[230]; //Tv[231];
     Tv[272]:=16.5;
     If CertificationMode then begin Tv[272]:=16.5;end;
     If Ret[RetNo].Province = 'QC' then
     begin
      Tv[246] := Tv[227];
      Tv[247] := Tv[246] * (Tv[272] /100.0);
     end
     else
     begin
       Tv[246]:=0;
       Tv[247] :=0;
     end;

     //PART 6 of Pafe 3
     Tv[248] := Tv[117];//Vl (FetchElm (RetNo, 'S12_2', 17));
     Tv[249] := Vl (FetchElm (RetNo, 'S11', 146));

     //jz//2025updateforgotenT3//202508 - previously unpopulated
     //Tv[46] := vtUser for now - profile seems to get it from T2038 line 15, not sure about recapture, ours out of date and form says not competed
     Tv[47] := vl(FetchElm(RetNo, 'S11', 107));
     Tv[54] := vl(FetchElm(RetNo, 'S11', 116));
     Tv[55] := vl(FetchElm(RetNo, 'S11', 109)) + vl(FetchElm(RetNo, 'S11', 117));
     Tv[48] := Tv[249]-Tv[46]-Tv[47]-Tv[54]-Tv[55];

     Tv[250] := Tv[112];
     Tv[251] := Tv[111];
     Tv[252] := MaxR(0,Tv[250] - Tv[251]);
     Tv[253] := Tv[106];  //TotMultiple(RetNo,'T3FFT', 1); //jz//2025updateforgotenT3//202508 - gets from previous elm to save time, bad coding, if do this should be a var instead
     Tv[254] := Tv[108];  //TotMultiple(RetNo,'T3FFT', 7); //jz//2025updateforgotenT3//202508 - gets from previous elm to save time, bad coding, if do this should be a var instead
     Tv[255] := Tv[253] + Tv[254];

     Tv[256] := Tv[252];
     if Tv[255] > 0 then Tv[5]   := Tv[109] / Tv[255];
     Tv[27]  := Tv[256] * Tv[5];
     Tv[258] := Tv[27];

     //jz//2025updateforgotenT3//202508 - not sure where these elms are
     {
     Tv[257]:= Tv[109]; //Vl(FetchElm (RetNo, 'S12_2', 9));
     Tv[262]:= Tv[255];
     if Tv[262] <> 0 then
       Tv[258] := Tv[256] * Tv[257]/ Tv[255]
     else
       Tv[258] :=0;
     }

     Tv[259] := Tv[48] + Tv[258]; //jz//2025updateforgotenT3//202508 - Tv[249] + Tv[258];
     Tv[260] := Tv[259];
     Tv[261] := MaxR(0,Tv[248] - Tv[260]);
    end; //end mintax true

    { //jz//2025updateforgotenT3//202508 - not sure where these elms are
    //S12 PAGE 4 LAST PAGE (no instructions -----------------
    If UpperCase(Strings[311])='Y' then
    begin
    Tv[301]:=Vl(FetchElm(RetNo,'S1',97));
    Tv[303]:=Tv[301]+Tv[302];
    Tv[304]:=Tv[303] * 3/5;

    Tv[305]:=(3/5) * (Vl(FetchElm(RetNo,'S9',10))); //+Vl(FetchElm(RetNo,'S9',112)));
    // Tv[306]:=0.30 * Vl(FetchElm(RetNo,'S1',67));
    Tv[307]:=0.30 * Vl(FetchElm(RetNo,'S1',129));
    Tv[308]:=Tv[305]+Tv[307];
    Tv[309]:=Tv[308];
    Tv[310]:=Tv[304]-Tv[309];
    end
    Else
    for i:=301 to 310 do Tv[i]:=0;
    }

    // Part 7
    //Tv[203]:= vtUser
    Tv[204]:=Vl(FetchElm(RetNo,'S11',115)); //20211217  //Tv[27]; //Vl(FetchElm(RetNo,'S11',115));  //Tv[27];

    //jz//2025updateforgotenT3//202508 - previously unpopulated
    //Tv[49] := vtUser for now - profile seems to get it from T2038 line 15, not sure about recapture, ours out of date and form says not competed
    Tv[50] := vl(FetchElm(RetNo, 'S11', 107));
    Tv[51] := vl(FetchElm(RetNo, 'S11', 116));
    Tv[52] := vl(FetchElm(RetNo, 'S11', 109)) + vl(FetchElm(RetNo, 'S11', 117));
    Tv[53] := Tv[204]-Tv[49]-Tv[50]-Tv[51]-Tv[52];

    Tv[205]:= Tv[117];
    Tv[206]:= MaxR(0,Tv[53]-Tv[205]); //jz//2025updateforgotenT3//202508 - MaxR(0,Tv[204]-Tv[205]);

    Tv[207]:= MinR(Tv[203],Tv[206]);
    Tv[208]:= MaxR(0,Tv[203]-Tv[207]);
    Tv[209]:= Tv[261];
    Tv[210]:= Tv[208]+Tv[209];
    //Tv[201]:= vtUser
    Tv[202]:= MaxR(0,Tv[210]-Tv[201]);
  end; //with ret



//??? S12 pg 5 ---------------------------------------------------------------------
  (*
   with Ret[RetNo].Frm[Fno] do
   begin
     //j???
     Tv[17]:=Vl(FetchElm(RetNo,'S12',207));
     Tv[2]:=Tv[17] * 37.5/100;
     Tv[3]:=Tv[1]+Tv[2];
     Tv[4]:=Vl(FetchElm(RetNo,'T3ON',31));
  Tv[5]:=Vl(FetchElm(RetNo,'T3ON',32))+Vl(FetchElm(RetNo,'T3ON',34));
     Tv[6]:=MaxR(0,Tv[4]-Tv[5]);
     Tv[7]:=MinR(Tv[3],Tv[6]);
     If UpperCase(Strings[15]) = 'Y' then
      Tv[8]:=Tv[16]
     else
      Tv[8]:=Tv[7];
     Tv[9]:=MaxR(0,Tv[3]-Tv[8]);
     Tv[10]:=Vl(FetchElm(RetNo,'S12',515)); //Vl(FetchElm(RetNo,'T3ON',15));
     Tv[11]:= Tv[9]+Tv[10];
     Tv[14]:= Vl(FetchElm(RetNo,'S12',201));
     Tv[12]:=Tv[14]* 37.5/100;
     Tv[13]:=MaxR(0,Tv[11]-Tv[12]);
   end;
  *)

//S12 PAGE 4 ---------------------------------------------------------------------
  With Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    For i:=501 to 573 do Tv[i]:=0;
    {Rates}
    Tv[502] := 62.1; //20261006 Alex //60; //jz2025update-rev1: changed rate from 58; //20180210  54.7; //20170108
    Tv[505] :=57.5;
    Tv[508] :=57;
    Tv[513] :=57.5;
    Tv[66]:= 24.63; //20261006 Alex
    //tv[517] :=33.67; //40.33;//39.03; //39.67;  //20110208 //20261006 Alex
    If RY=1 then Tv[517]:=33.67;
    Tv[520] :=50;

    Tv[524]:=50;
    Tv[530]:=35;
    Tv[535]:= 40; //20261006 Alex //34.9;//33.7; //38;//36.8; //39.67; //20260204 Igor
    Tv[541]:=45;
    Tv[544]:=45;
    Tv[547]:= 43.90; //42.67; //44;  //20160204 //20260204 Igor

    {lines}
    If Ret[RetNo].Province='NL' then Tv[501]:=Tv[261]; //Vl(FetchElm(RetNo,'S12_3',61));
    If Ret[RetNo].Province='NS' then Tv[504]:=Tv[261]; //Vl(FetchElm(RetNo,'S12_3',61));
    If Ret[RetNo].Province='NB' then begin Tv[548]:=Tv[248];Tv[549]:=Tv[249];end; //20130311 //20130311 //Vl(FetchElm(RetNo,'S12_3',48));
    If Ret[RetNo].Province='PE' then Tv[512]:=Tv[261]; //Vl(FetchElm(RetNo,'S12_3',61));
    If Ret[RetNo].Province='ON' then
    begin
      Tv[65]:= Tv[261]; //20261006 Alex
      //if IsMultiJurisdiction(RetNo) then Tv[516]:= vl(FetchElm(RetNo,'T3MJON',40))   //jz//2025updateforgotenT3//202508 //20261006 Alex
      //                              else Tv[516]:= vl(FetchElm(RetNo,'T3ON'  ,40));  //jz//2025updateforgotenT3//202508 //20261006 Alex
    end;
    If Ret[RetNo].Province='MB' then
    begin
      Tv[510]:=Tv[248]; //Vl(FetchElm(RetNo,'S12_3',48));
      Tv[511]:=Tv[249]; //Vl(FetchElm(RetNo,'S12_3',49));
    end;
    If Ret[RetNo].Province='SK' then
    begin
     Tv[549]:=Tv[248]; //Vl(FetchElm(RetNo,'S12_3',48));
     Tv[550]:=Tv[249]; //Vl(FetchElm(RetNo,'S12_3',49));
    end;
    If Ret[RetNo].Province='AB' then
    begin
     Tv[551]:=Tv[248]; //Vl(FetchElm(RetNo,'S12_3',48));
     Tv[552]:=Tv[249]; //Vl(FetchElm(RetNo,'S12_3',49));
    end;
    //20260204 Igor >>>
    if Ret[RetNo].Province.Equals('BC') or GetShortPrv(FetchElm(RetNo, 'T3', 9)).Equals('BC') then
    begin
      Tv[537]:= Tv[261]; //20260204 Igor
     //Tv[534]:=Tv[248]; //Vl(FetchElm(RetNo,'S12_3',48)); //20260204 Igor //The field index 534 not found on the form!
     //Tv[536]:=Tv[249]; //Vl(FetchElm(RetNo,'S12_3',49)); //20260204 Igor //The field index 536 not found on the form!
    end;
    //20260204 Igor <<<
    If Ret[RetNo].Province='NU' then Tv[540]:=Tv[261]; //Vl(FetchElm(RetNo,'S12_3',61));
    If Ret[RetNo].Province='NT' then Tv[543]:=Tv[261]; //Vl(FetchElm(RetNo,'S12_3',61));
    If Ret[RetNo].Province='YT' then Tv[546]:=Tv[261]; //Vl(FetchElm(RetNo,'S12_3',61));

    {Calcs}
    {NF} Tv[503]:=Tv[501] * Tv[502]/100;
    {NS} Tv[506]:=Tv[504] * Tv[505]/100;
    {NB} //Tv[514]:=Tv[249]; //Vl(FetchElm(RetNo,'S12_3',49));
         Tv[507]:=MaxR(0,Tv[548]-Tv[514]);
         Tv[509]:=Tv[507] * Tv[508]/100;
    {PE} Tv[525]:=Tv[512] * Tv[513]/100;
    {ON} Tv[515]:= Tv[65] * Tv[66] / 100;//Tv[516] * Tv[517]/100; //20261006 Alex
    {MB} Tv[519]:=MaxR(0,Tv[510]-Tv[511]);
         Tv[518]:=Tv[519] * Tv[520]/100;
    {SK} Tv[523]:=MaxR(0,Tv[549]-Tv[550]);
         Tv[528]:=Tv[523] * Tv[524]/100;

    {AB} Tv[529]:=MaxR(0,Tv[551]-Tv[552]);
         Tv[533]:=Tv[529] * Tv[530]/100;

    {BC} //Tv[537]:=MaxR(0,Tv[534]-Tv[536]); //20260204 Igor
         Tv[538]:=Tv[537] * Tv[535]/100;

    {NU} Tv[539]:=Tv[540] * Tv[541]/100;
    {NT} Tv[542]:=Tv[543] * Tv[544]/100;
    {YT} Tv[545]:=Tv[546] * Tv[547]/100;
  end;

//S12 END PAGE 4 ---------------------------------------------------------------------

  SaveTv (RetNo, Fname, FNo);

end;




procedure SIFT(RetNo: integer;FName: string;FNo: integer);
begin
  LoadTv (RetNo, Fname, FNo);
  With Ret[RetNo].Frm[FNo] Do
  begin
    //pg 1
    //chart 1
    Tv[1]:= Vl(FetchElm(RetNo,'T3',272));
    //Tv[3]:= ???
    if vl(Strings[3]) > 0 then
      Tv[4]:= Tv[2] / (vl(Strings[3])/100)
    else
      Tv[4]:=0;
    Tv[5] := MinR(Tv[1],Tv[4]);

    //chart 2
    Tv[6]:= Tv[1];
    strings[7]:= '33';
    Tv[8]:= Tv[6] * vl(strings[7]) / 100;

    Tv[9]:= Tv[5];
    //strings[10]:= ???;
    Tv[11]:= Tv[9] * vl(strings[10]) / 100;
    Tv[12]:= Tv[8] + Tv[11];

    Tv[13]:= Tv[5];
    //strings[14]:= ???;
    Tv[15]:= Tv[13] * vl(strings[14]) / 100;

    //chart 3
    Tv[16]:= Tv[1];
    Tv[17]:= Tv[5];
    Tv[18]:= MaxR(0, Tv[16] - Tv[17]);

    //chart 4
    Tv[19]:= Vl(FetchElm(RetNo,'T3',85));;
    Tv[20]:= Tv[5];
    Tv[21]:= MaxR(0, Tv[19] - Tv[20]);

    //chart 5
    Tv[22]:= Vl(FetchElm(RetNo,'S9',112));
    Tv[23]:= Tv[2];                         //jz//20260319 - change from unassigned
    Tv[24]:= MaxR(0, Tv[22] - Tv[23]);

    //pg 2
    //chart 6
    Tv[25]:= MaxR( 0, Vl(FetchElm(RetNo,'T3',85)) - Tv[17]);
    Tv[26]:= Vl(FetchElm(RetNo,'T3',85));
    if Tv[26] > 0 then
      Tv[27]:= Tv[25] / Tv[26];

    If SubjectToMinTax(RetNo) then
      Tv[28]:= Vl(FetchElm(RetNo,'S12',227))
    else
      Tv[28]:= Vl(FetchElm(RetNo,'S11',146));

    Tv[29]:= Tv[27];
    Tv[30]:= Tv[28] * Tv[29];
    Tv[31]:= 16.5;                        //jz//20260319 - assign as per form
    Tv[32]:= Tv[30] * Tv[31]/100;         //jz//20260319 - add "/100" as is percent

    //chart 7
    //Tv[33]:= ???;
    //Tv[34]:= ???;
    Tv[35]:= Tv[33] * Tv[34] / 100;


    //Tv[36]:= ???;
    //Tv[37]:= ???;
    Tv[38]:= Tv[36] * Tv[37] / 100;
    Tv[39]:= Tv[35] + Tv[38];

    //chart 8
    //part A
    //Tv[40]:= ???;
    //Tv[41]:= ???;
    Tv[42]:= Tv[40] * Tv[41] / 100;

    //Tv[43]:= ???;
    //Tv[44]:= ???;
    Tv[45]:= Tv[43] * Tv[44] / 100;
    Tv[46]:= Tv[42] + Tv[45];

    //part B
    //Tv[47]:= ???;
    //Tv[48]:= ???;
    Tv[49]:= Tv[47] * Tv[48] / 100;

    //Tv[50]:= ???;

    //Tv[51]:= ???;
    TV[52]:= 0.1;                 //strings[52]:= '.1';
    Tv[53]:= Tv[51] * Tv[52];    //Tv[53]:= Tv[51] * vl(strings[52]);

    Tv[54]:= Tv[50] + Tv[53];
  end;
 SaveTv (RetNo, Fname, FNo);  //20230123
 end;




Procedure CALCALL(RetNo: integer);
Var i: integer;Fnm : string[10];
begin
 //20180319
{
 //charity
 Calc(RetNo,'T3010');
 Calc(RetNo,'T1235#1');
 Calc(RetNo,'T1236#1');
}
// PopulateT5018G(RetNo);
 //If IsT3Return(RetNo) = True then
 CalcFullT3(RetNo);
// If Ret[RetNo].FrmHasData[GetFormNo('T5013FIN')] = True then CalcFullT5013(RetNo);
 //If GetCharityBN(RetNo)>'' then begin  Calc(RetNo,'T1259B'); end;  //20110213
 Ret[RetNo].CalcStatus := True;
end;


Procedure ClearAllProvTaxForms(RetNo:Integer);
Var i:Integer; FNo:Integer;
begin

  if not GetShortPrv(FetchElm(RetNo, 'T3', 9)).Equals('ON') or GetShortPrv(FetchElm(RetNo, 'T3', 9)).IsEmpty then ClearThisForm(RetNo, 'T3ON'); //20260309 Igor
  if not GetShortPrv(FetchElm(RetNo, 'T3', 9)).Equals('AB') or GetShortPrv(FetchElm(RetNo, 'T3', 9)).IsEmpty then ClearThisForm(RetNo, 'T3AB'); //20260309 Igor
  if not GetShortPrv(FetchElm(RetNo, 'T3', 9)).Equals('BC') or GetShortPrv(FetchElm(RetNo, 'T3', 9)).IsEmpty then ClearThisForm(RetNo, 'T3BC'); //20260309 Igor
  if not GetShortPrv(FetchElm(RetNo, 'T3', 9)).Equals('MB') or GetShortPrv(FetchElm(RetNo, 'T3', 9)).IsEmpty then ClearThisForm(RetNo, 'T3MB'); //20260309 Igor
  if not GetShortPrv(FetchElm(RetNo, 'T3', 9)).Equals('NB') or GetShortPrv(FetchElm(RetNo, 'T3', 9)).IsEmpty then ClearThisForm(RetNo, 'T3NB'); //20260309 Igor
  if not GetShortPrv(FetchElm(RetNo, 'T3', 9)).Equals('NS') or GetShortPrv(FetchElm(RetNo, 'T3', 9)).IsEmpty then ClearThisForm(RetNo, 'T3NS'); //20260309 Igor
  //for T3NL //20150205  keep [42 and 49
  FNo:= GetFormNo('T3NL');
  For i:= 1 to 41 do StoreElm(RetNo, FNo, i, ''); //20150205
  For i:= 43 to 48 do StoreElm(RetNo, FNo, i, ''); //20150205
  For i:= 50 to 70 do StoreElm(RetNo, FNo, i, ''); //20150205
  Calc(RetNo, 'T3NL');

  if not GetShortPrv(FetchElm(RetNo, 'T3', 9)).Equals('NU') or GetShortPrv(FetchElm(RetNo, 'T3', 9)).IsEmpty then ClearThisForm(RetNo, 'T3NU'); //20260309 Igor
  if not GetShortPrv(FetchElm(RetNo, 'T3', 9)).Equals('NT') or GetShortPrv(FetchElm(RetNo, 'T3', 9)).IsEmpty then ClearThisForm(RetNo, 'T3NT'); //20260309 Igor
  if not GetShortPrv(FetchElm(RetNo, 'T3', 9)).Equals('PE') or GetShortPrv(FetchElm(RetNo, 'T3', 9)).IsEmpty then ClearThisForm(RetNo, 'T3PE'); //20260309 Igor
  if not GetShortPrv(FetchElm(RetNo, 'T3', 9)).Equals('SK') or GetShortPrv(FetchElm(RetNo, 'T3', 9)).IsEmpty then ClearThisForm(RetNo, 'T3SK'); //20260309 Igor
  if not GetShortPrv(FetchElm(RetNo, 'T3', 9)).Equals('YT') or GetShortPrv(FetchElm(RetNo, 'T3', 9)).IsEmpty then ClearThisForm(RetNo, 'T3YT'); //20260309 Igor

{

 ClearThisForm(RetNo,'T3ON');
 ClearThisForm(RetNo,'T3AB');
 ClearThisForm(RetNo,'T3BC');
 ClearThisForm(RetNo,'T3MB');
 ClearThisForm(RetNo,'T3NB');
 ClearThisForm(RetNo,'T3NS');
 //for T3NL //20150205  keep [42 and 49
 FNo:=GetFormNo('T3NL');
 For i:=1 to 41 do StoreElm(RetNo,FNo,i,''); //20150205
 For i:=43 to 48 do StoreElm(RetNo,FNo,i,''); //20150205
 For i:=50 to 70 do StoreElm(RetNo,FNo,i,''); //20150205
 Calc(RetNo,'T3NL');

 ClearThisForm(RetNo,'T3NU');
 ClearThisForm(RetNo,'T3NT');
 ClearThisForm(RetNo,'T3PE');
 ClearThisForm(RetNo,'T3SK');
 ClearThisForm(RetNo,'T3YT');
}
end;

Procedure CalcFullT3(RetNo:Integer);
var
  i: integer;
  Fnm: string[10];
begin
  InitConstants;

  with Ret[RetNo] do
  begin
    T183TRUST(RetNo, 'T183TRUST', GetFormno('T183TRUST' )); //20240329

    InitFormData(RetNo,GetFormNo('T3PFT'));
    AddPageInstance('T3FFT','#2');
    AddPageInstance('T3FFT','#3');

    ClearAllProvTaxForms(RetNo);

    T5INCOMEProcess(RetNo,T5Interest,T5FInterest,T5Pens,T5Royalty,T5NonElgblGains,T5Dividends,T5DividendsEligible,
           T5FNonBusInc1,T5FNonBusInc2,T5FNonBusInc3,
           T5FNonBusTax1,T5FNonBusTax2,T5FNonBusTax3);

    T3INCOMEProcess(RetNo,
          T3OthInc,T3Pens,T3itc,
          T3xii,
          T3ElgblQSB1,T3ElgblQFP1,
          T3ElgblOTH1,T3ElgblOTH2,T3ElgblOTH3,
          T3NonElgblGains1,T3Dividends,T3DividendsEligible,
          T3FNonBusInc1,T3FNonBusInc2,T3FNonBusInc3,
          T3FNonBusTax1,T3FNonBusTax2,T3FNonBusTax3,
          T3FBusInc1,T3FBusInc2,T3FBusInc3,
          T3FBusTax1,T3FBusTax2,T3FBusTax3,
          T3FarmElgbl,T3OthElgbl,T3QFPElgbl,
          T3ElgblQSB2,T3ElgblQFP2,
          T3ElgblQSB3,T3ElgblQFP3,
          T3NonElgblGains2,T3NonElgblGains3,T3FCapGains);

    //20210910
    // T4AP(RetNo,'T4AP#1',GetFormNo('T4AP'));
    T4APIncomeProcess(RetNo,T4APOthInc,T4APIncTax);

    T5013IncProcess(RetNo,
        T5013LimitedInc,T5013OthInc,T5013ITC,
        T5013ActDiv,T5013ActDivEligible,
        T5013CarrCharg,
        T5013CDE,T5013CEE,T5013COGPE,T5013FDE,T5013RecapDepl,
        T5013FedPol, T5013ProvPol,T5013Don,T5013Gifts,T5013Abil,
        T5013FNonBusInc1,T5013FNonBusInc2,T5013FNonBusInc3,
        T5013FNonBusTax1,T5013FNonBusTax2,T5013FNonBusTax3,
        T5013FBusInc1,T5013FBusInc2,T5013FBusInc3,
        T5013FBusTax1,T5013FBusTax2,T5013FBusTax3,
        T5013Interest,T5013Tax,T5013ResAllow,T5013FInterest,
        T5013GrossIncome,T5013BusIncome,T5013FarmIncome,T5013FishIncome,T5013RentIncome);

    //??? order?
    SumSlips(RetNo,'ALL');
    RecalcBusStatements(RetNo);
    EFMEMO(RetNo, 'EFMEMO', GetFormno('EFMEMO' )); //20220307
    POLIT(RetNo, 'POLIT', GetFormno('POLIT' ));
    ABIL(RetNo, 'ABIL', GetFormno('ABIL' ));
    INVSTM(RetNo, 'INVSTM#1', GetFormno('INVSTM#1' ));
    FINVSTM(RetNo, 'FINVSTM', GetFormno('FINVSTM' ));
    S2(RetNo, 'S2', GetFormno('S2' )); //reserves from T5013
    S8 (RetNo, 'S8', GetFormno('S8' )); {Need foreign income for AVLBLE}
    T3OTHDED(RetNo, 'T3OTHDED', GetFormno('T3OTHDED'));
    {get tot income}
    T3(RetNo,'T3', GetFormNo('T3'));
    AssetsB(RetNo,'ASSETSB#1', GetFormNo('ASSETSB#1'));  //20110409
    T1079(RetNo, 'T1079', GetFormno('T1079'));  //20220217
    T1255(RetNo, 'T1255#1', GetFormno('T1255#1'));  //20220327
    S1(RetNo, 'S1', GetFormno('S1'));
    T3(RetNo,'T3', GetFormNo('T3')); //pg2
    S1A(RetNo, 'S1A', GetFormno('S1A'));

    S3 (RetNo, 'S3', GetFormno('S3'));
    S4(RetNo, 'S4', GetFormno('S4'));
    S5(RetNo, 'S5', GetFormno('S5'));
    S7 (RetNo, 'S7', GetFormno('S7' ));
    S8 (RetNo, 'S8', GetFormno('S8' )); {Need foreign income for AVLBLE}
    T3(RetNo,'T3', GetFormNo('T3')); {establish tot income} //pg2
    AVLBLE(RetNo, 'AVLBLE', GetFormno('AVLBLE' )); {gets from Pg2 and S8}
    CalcT3Slips(RetNo);
    SumT3Boxes(RetNo);
    S9(RetNo, 'S9', GetFormno('S9'));
    S15(RetNo, 'S15#1', GetFormno('S15#1'));  //20240314

    T3A(RetNo,'T3A', GetFormNo('T3A'));
    T3LOSS(RetNo,'T3LOSS', GetFormNo('T3LOSS'));

    T3OTHDED(RetNo,'T3OTHDED', GetFormNo('T3OTHDED'));
    T3(RetNo,'T3', GetFormNo('T3')); {establish tot income} //??? order??? pg3

    S8(RetNo, 'S8', GetFormno('S8' )); {after S9}
    T3FFT(RetNo,'T3FFT#1', GetFormNo('T3FFT#1'));

    If GetFormNo('T3FFT#2') >0 then T3FFT(RetNo,'T3FFT#2', GetFormNo('T3FFT#2'));
    If GetFormNo('T3FFT#3') >0 then T3FFT(RetNo,'T3FFT#3', GetFormNo('T3FFT#3'));

    AVLBLE(RetNo, 'AVLBLE', GetFormno('AVLBLE' )); {gets from Pg2 and S8}
    SumT3Boxes(RetNo);
    S9(RetNo, 'S9', GetFormno('S9'));
    T3(RetNo,'T3', GetFormNo('T3')); //??? order? pg3

    S4(RetNo, 'S4', GetFormno('S4'));
    T3(RetNo,'T3', GetFormNo('T3')); {nneded by min tax S12} //??? order?? pg4

    S10(RetNo, 'S10', GetFormno('S10' )); {after S9 and Pg2}
    T2038(RetNo, 'T2038', GetFormno('T2038'));
    T3DON(RetNo, 'T3DON', GetFormno('T3DON' ));

    S11(RetNo, 'S11', GetFormno('S11' ));
    //ShowMessage('Txbl income= '+FetchElm(RetNo,'S11',1));

    T3DON(RetNo, 'T3DON', GetFormno('T3DON' ));  //201170325
    S11A(RetNo, 'S11A', GetFormno('S11A' ));  //201170325

    T2038(RetNo, 'T2038', GetFormno('T2038'));
    T3(RetNo,'T3', GetFormNo('T3'));   //20170305
    S11(RetNo, 'S11', GetFormno('S11' ));
    //ShowMessage('bfr t3fft Txbl income= '+FetchElm(RetNo,'S11',1));
    T3DON(RetNo, 'T3DON', GetFormno('T3DON' ));  //201170325
    S11A(RetNo, 'S11A', GetFormno('S11A' ));  //201170325

    T3FFT(RetNo,'T3FFT#1', GetFormNo('T3FFT#1'));
    If GetFormNo('T3FFT#2') >0 then T3FFT(RetNo,'T3FFT#2', GetFormNo('T3FFT#2'));
    If GetFormNo('T3FFT#3') >0 then T3FFT(RetNo,'T3FFT#3', GetFormNo('T3FFT#3'));
    T3(RetNo,'T3', GetFormNo('T3'));   //20180330
    //ShowMessage('after t3fft Txbl income= '+FetchElm(RetNo,'S11',1));
    S11(RetNo, 'S11', GetFormno('S11' ));
    T3DON(RetNo, 'T3DON', GetFormno('T3DON' ));  //201170325
    S11A(RetNo, 'S11A', GetFormno('S11A' ));  //201170325
    S12 (RetNo, 'S12', GetFormno('S12' ));
    T3(RetNo,'T3', GetFormNo('T3'));   //20170305
    //ShowMessage('Before S11 Txbl income= '+FetchElm(RetNo,'T3',272));
    S11(RetNo, 'S11', GetFormno('S11' ));
    //ShowMessage('after S11 Txbl income= '+FetchElm(RetNo,'T3',272));

    SIFT(RetNo, 'SIFT', GetFormno('SIFT' ));

    //T3MJ(RetNo,'T3MJ', GetFormNo('T3MJ'));   //20231202

    CalcPrvTaxAndCredits(RetNo);

    T3(RetNo,'T3', GetFormNo('T3'));   //20180330
    //ShowMessage('after prv tax cred  Txbl income= '+FetchElm(RetNo,'T3',272));
    T3PFT(RetNo, 'T3PFT', GetFormno('T3PFT'));
    //ShowMessage('After T3PFT Txbl income= '+FetchElm(RetNo,'S11',1));

    for I :=1 to 1 do  //20230106
    Begin
      T2043A(RetNo, 'T2043A#1', GetFormNo('T2043A#1'));
      // T2043A(RetNo,'T2043A#'+IntToStr(i), GetFormNo('T2043#'+IntToStr(i));end; //20230106
    end;
    T2043(RetNo,'T2043', GetFormNo('T2043')); //20230106
    CalcPrvTaxAndCredits(RetNo);
    T3(RetNo,'T3', GetFormNo('T3')); //??? order?? pg4
    S11(RetNo, 'S11', GetFormno('S11'));  //20180330
    T3(RetNo,'T3', GetFormNo('T3')); //20180330
    T183TRUST(RetNo,'T183TRUST', GetFormNo('T183TRUST')); //20220120 Igor
    T184(RetNo,'T184', GetFormNo('T184')); //20220209 Igor

    T3SUM(RetNo,'T3SUM', GetFormNo('T3SUM'));
    T3AO(RetNo,'T3AO', GetFormNo('T3AO')); //20220326
    //T7DRQR(RetNo,'T7DRQR', GetFormNo('T7DRQR')); //20220326

    UpdateAllDataIndicators(RetNo);
    T3(RetNo,'T3', GetFormNo('T3')); //pg2
    CreatePrBnfr(RetNo);
    STATUS(RetNo,'STATUS', GetFormNo('STATUS'));
    S130(RetNo, 'S130', GetFormno('S130'));    //20260302 Igor
    T1098(RetNo, 'T1098', GetFormno('T1098')); //jz//20260309
    T1099(RetNo, 'T1099', GetFormno('T1099')); //20261006 Alex
 end;
end;

Procedure CalcPrvTaxAndCredits(RetNo: integer); //20231203
Var i, T3MjFno:Integer;
begin
 T3ON(RetNo, 'T3ON', GetFormno('T3ON'));
 T3AB(RetNo, 'T3AB', GetFormno('T3AB'));
 T3BC(RetNo, 'T3BC', GetFormno('T3BC'));
 T3NB(RetNo, 'T3NB', GetFormno('T3NB'));
 T3NS(RetNo, 'T3NS', GetFormno('T3NS'));
 T3NL(RetNo, 'T3NL', GetFormno('T3NL'));
 T3NU(RetNo, 'T3NU', GetFormno('T3NU'));
 T3NT(RetNo, 'T3NT', GetFormno('T3NT'));
 T3MB(RetNo, 'T3MB', GetFormno('T3MB'));
 T3PE(RetNo, 'T3PE', GetFormno('T3PE'));
 T3SK(RetNo, 'T3SK', GetFormno('T3SK'));
 T3YT(RetNo, 'T3YT', GetFormno('T3YT'));

 If IsMultiJurisdiction(RetNo) then   //20231203
 Begin
   T3MJON(RetNo, 'T3MJON', GetFormno('T3MJON'));
   T3MJAB(RetNo, 'T3MJAB', GetFormno('T3MJAB'));
   T3MJBC(RetNo, 'T3MJBC', GetFormno('T3MJBC'));
   T3MJNB(RetNo, 'T3MJNB', GetFormno('T3MJNB'));
   T3MJNS(RetNo, 'T3MJNS', GetFormno('T3MJNS'));
   T3MJNL(RetNo, 'T3MJNL', GetFormno('T3MJNL'));
   T3MJNU(RetNo, 'T3MJNU', GetFormno('T3MJNU'));
   T3MJNT(RetNo, 'T3MJNT', GetFormno('T3MJNT'));
   T3MJMB(RetNo, 'T3MJMB', GetFormno('T3MJMB'));
   T3MJPE(RetNo, 'T3MJPE', GetFormno('T3MJPE'));
   T3MJSK(RetNo, 'T3MJSK', GetFormno('T3MJSK'));
   T3MJYT(RetNo, 'T3MJYT', GetFormno('T3MJYT'));

   T3MJ(RetNo, 'T3MJ', GetFormno('T3MJ'));
 End
 Else
 Begin
  For i:=1 to 243 do
  begin
    T3MJFNo:=GetFormNo('T3MJ');
    StoreElm(RetNo,T3MjFNo,i,'');
  end;
 End;

end;


Procedure AUTOEXP(RetNo: integer; FName: String;FNo: integer);
begin
  {CalcAutoExp(RetNo,FName,FNo,'O');}  {other}
end;

Procedure T3Sl1(RetNo:integer;FName:string;FNo:integer);
Var i,NumSlips:Integer; PercentAlloc : real; Tp:string[1];
begin
end;

Procedure T3Sl23(RetNo:integer;FName:string;FNo:integer);
Var i,NumSlips:Integer; PercentAlloc : real; Tp:string[1];
begin
 {No calc not displayed}
end;

Procedure T3Sl4(RetNo:integer;FName:string;FNo:integer);
Var i,NumSlips:Integer; PercentAlloc : real; Tp:string[1];
begin
  {No calc not displayed}
end;



Procedure AddInfo(RetNo:integer;FName:string;FNo:integer);
begin
 LoadTv(RetNo,FName,FNo);
 With Ret[RetNo].Frm[FNo] do
 begin
  Strings[1] := OptRec.Prp_Name;
 end;
SaveTv(RetNo,FName,FNo);
end;

procedure LETR_1(RetNo: integer; FName: String;FNo: integer);
begin
PrepLetter(RetNo,FName,FNo,1);
end;

procedure LETR_2(RetNo: integer; FName: String;FNo: integer);
begin
PrepLetter(RetNo,FName,FNo,2);
end;

Procedure T184(RetNo:integer;FName:string;FNo:integer); //20220127 Igor
var
  ProvinceNo, I: Integer;
begin
  LoadTv(RetNo,FName,FNo);
  With ret[RetNo].Frm[FNo] do
  begin
    Tv[1] := Vl(FetchElm(RetNo,'T3',272));
    Tv[2] := 33;
    Tv[3] := Tv[1] * Tv[2] / 100;

    Tv[5] := 33;
    Tv[6] := Tv[4] * Tv[5] / 100;
    Tv[7] := Vl(FetchElm(RetNo,'S11',112));

    Tv[9] := MinR(Tv[3], MinR(Tv[6], Tv[7]));
    Tv[10] := Tv[8] + Tv[9];
    Tv[12] := Tv[10] - Tv[11];
    Tv[13] := Tv[12];
    Tv[14] := 100;
    Tv[15] := 16.5;
    Tv[16] := Tv[12] * Tv[14] / Tv[15];
    //Tv[16] := Tv[12] * Tv[15] / Tv[14];
    Tv[19] := Tv[17] + Tv[18];
    Tv[22] := Tv[20] + Tv[21];
    Tv[23] := Tv[22];
    Tv[24] := MaxR(0, Tv[19]-Tv[23]);
    Tv[25] := Tv[24];
    Tv[26] := Tv[16] + Tv[24];
    Tv[28] := Tv[26] * Tv[27];
    Tv[29] := Tv[27] + Tv[17];
    Tv[30] := Tv[28] / Tv[29];
    Tv[32] := 2;
    Tv[33] := Tv[31] * Tv[32];
    Tv[34] := Tv[30] - Tv[33];
    Tv[35] := Tv[34];
    Tv[36] := 16.5;
    Tv[37] := Tv[35] * Tv[36] / 100; //20260218 Igor
    Tv[38] := MinR(Tv[12], Tv[37]);

   //Section 2
  {1 - 'NEWFOUNDLAND AND LABRADOR',
   2 - 'PRINCE EDWARD ISLAND',
   3 - 'NOVA SCOTIA',
   4 - 'NEW BRUNSWICK',
   5 - 'QUEBEC',
   6 - 'ONTARIO',
   7 - 'MANITOBA',
   8 - 'SASKATCHEWAN',
   9 - 'ALBERTA',
   10 - 'BRITISH COLUMBIA',
   11 - 'NORTHWEST TERRITORIES',
   12 - 'YUKON TERRITORY',
   13 - 'NON RESIDENT',
   14 - 'NUNAVUT'); }

    Tv[39] := PrvRate184[1];  //NL
    Tv[40] := PrvRate184[3];  //NS
    Tv[41] := PrvRate184[4];  //NB
    Tv[42] := PrvRate184[2];  //PE
    Tv[43] := PrvRate184[8];  //SK
    Tv[44] := PrvRate184[10]; //BC
    Tv[45] := PrvRate184[11]; //NT
    Tv[46] := PrvRate184[12]; //YK
    Tv[47] := PrvRate184[14]; //NU

    ProvinceNo := GetPrvIndex(Ret[RetNo].Province);

    Tv[48] := Tv[38];
    if ProvinceNo = 0 then
      Tv[49] := 0
    else
      Tv[49] := PrvRate184[ProvinceNo];
    Tv[50] := Tv[48] * Tv[49] / 100;

    //Section 3 ONTARIO  //202203
    if Ret[RetNo].province='ON' then
    begin
     Tv[51] := Vl(FetchElm(RetNo,'T3',272));
     Tv[52] := 20.53;
     Tv[53] := Tv[51] * Tv[52] / 100;
     Tv[54] := Tv[4];
     Tv[55] := 20.53;
     Tv[56] := Tv[54] * Tv[55] / 100;
     Tv[57] := Vl(FetchElm(RetNo,'T3ON',39)) - Vl(FetchElm(RetNo,'T3ON',79));
     Tv[58] := MinR(Tv[53], MinR(Tv[56], Tv[57]));
     Tv[61] := Tv[59] - Tv[60];
     Tv[63] := Tv[61] - Tv[62];
     Tv[64] := Tv[63];
     Tv[65] := Tv[58] + Tv[64];
     Tv[66] := Tv[34];
     strings[67] := '10.265';                     //jz//20260222 change to string to capture third decimal place
     Tv[68] := Tv[66] * vl(strings[67]) / 100;
     Tv[69] := MinR(Tv[65], Tv[68]);
    end
    Else
    begin
     for i:=51 to 69 do begin Tv[i]:=0;end;
    end;

    if Abs(Tv[12] - Tv[38]) < 0.01 then
    begin
      Tv[70] := Tv[65];
      Tv[71] := Tv[69];

      Tv[73] := Tv[71] + Tv[72];
      Tv[74] := Tv[73];
      Tv[75] := MaxR(0, Tv[70] - Tv[74]);

      Tv[80] := Tv[77] + Tv[78] + Tv[79];

      Tv[81] := Tv[80];

      //TV[84] := Tv[77]+Tv[78]+Tv[79];  //20220319  //jz//20230110 why is this?

      Tv[85] := Tv[82] + Tv[83] + Tv[84];
      Tv[86] := Tv[85];

      Tv[87] := Tv[81] + Tv[86];
      Tv[88] := Tv[87];

      Tv[89] :=MaxR(0,Tv[76] - Tv[88]); //20230110 CON  Tv[76] + Tv[88];
      //Tv[89] := Tv[76] - Tv[88];    //jz//20230110 should be minus not +
    end
    else
    begin
      for I := 70 to 89 do
        Tv[I] := 0;
    end;

    Tv[90] := Tv[69] + Tv[75] + Tv[89];

    //20220319  section 4
    if Ret[RetNo].province='MB' then
    begin
     Tv[91] := Vl(FetchElm(RetNo,'T3',272));
     Tv[92] := Tv[4];
     Tv[93] := MinR(Tv[91], Tv[92]);
     Tv[94] := 17.4;
     Tv[95] := Tv[93] * Tv[94] / 100;
     Tv[96] := Vl(FetchElm(RetNo,'T3MB',53));
     Tv[97] := MinR(Tv[95], Tv[96]);
     Tv[99] := Tv[97] + Tv[98];

     Tv[102] := Tv[100] + Tv[101];
     Tv[103] := Tv[102];
     Tv[104] := Tv[99] + Tv[103];
    // TODO: Need to check if I understood this condition correctly
    // If the trust has earned income in more than one province or territory, and it has no taxable income for the year, multiply the amount
    // by the proportion of the amount that would be its Manitoba income for that year if its total income for the year were $1,000.
     Tv[105] := Tv[34];
     Tv[106] := 8.7;
     Tv[107] := Tv[105] * Tv[106] / 100;
     Tv[108] := MinR(Tv[104], Tv[107]);
    end
    Else
    Begin
     for i:=91 to 99 do Tv[i]:=0;
     for i:=100 to 108 do Tv[i]:=0;
   end;


    //Section 5
    if Ret[RetNo].province='AB' then
    begin
     Tv[110] := Vl(FetchElm(RetNo,'T3',272));
     Tv[111] := 15;
     Tv[112] := Tv[110] * Tv[111] / 100;
     Tv[113] := Tv[4];
     Tv[114] := 15;
     Tv[115] := Tv[113] * Tv[114] / 100;
     Tv[116] := Vl(FetchElm(RetNo,'T3AB',56));

     Tv[117] := MinR(Tv[112], MinR(Tv[115], Tv[116]));
     Tv[118] := Tv[109] + Tv[117];

     Tv[120] := Tv[118] - Tv[119];

     Tv[122] := Tv[120];
     Tv[123] := 100;
     Tv[124] := 7.5;
     Tv[121] := Tv[122] * Tv[123] / Tv[124];
     Tv[125] := Tv[25];
     Tv[126] := Tv[121] + Tv[125];

     Tv[127] := Tv[27];
     Tv[128] := Tv[126];
     Tv[129] := Tv[127] * Tv[128];

     Tv[130] := Tv[29];
     Tv[131] := Tv[129] / Tv[130];
     Tv[132] := Tv[33];
     Tv[133] := Tv[131] - Tv[132];
     Tv[134] := 7.5;
     Tv[135] := Tv[133] * Tv[134] / 100;
     Tv[136] := MinR(Tv[120], Tv[135]);
    end
    Else
    Begin
     for i:=109 to 136 do begin Tv[i]:=0;End;
    End;

    //Section 6
    Tv[137] := Tv[38];
    Tv[138] := Tv[50];
    Tv[139] := Tv[90];
    Tv[140] := Tv[108];
    Tv[141] := Tv[136];

    Tv[142] := Tv[137] + Tv[138] + Tv[139] + Tv[140] + Tv[141];
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure T1135(RetNo:integer;FName:string;FNo:integer); //20160310 Igor
Var i,j,Elm,ArrayNo:Integer;BoxesPerRow:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   //20180309
   Strings[9]:='X';  //20220325
   if Strings[9]='' then  //NO t3 return
   Begin
    for i:=1 to 64 do begin Strings[i]:=''; Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
    Exit;
   End;


   With Ret[RetNo].Frm[FNo] do
   begin

    Strings[65] := ifAmendedPopulateInitialRevNum(RetNo,FName); //jz//20260318

    //if       strings[22] = ''                         then Strings[65] := ''    //20220326
    //else if (strings[22] > '') and (strings[65] = '') then Strings[65] := 'R0'; //jz//20260315 - if not amended cannot have revision number

    Strings[21]:='';  //If Strings[21]='' then Strings[21]:='CAD';  //20150204
    Strings[23]:='';
    Strings[24]:='';

    Strings[6] := '';
    Strings[7] := '';
    Strings[8] := '';
    Strings[30] := '';

    //20160820
     Strings[10] := GetT3TrustName(RetNo);
     Strings[11] := GetT3AccountNumber(RetNo);
     Strings[12]:='';   //partnership box

     if FetchElm(RetNo,'T3',136)>'' then  //individual
     Begin
      If strings[15]='' then Strings[15] :=FetchElm(RetNo,'T3',4);    // street
      If Strings[17]='' then Strings[17] :=FetchElm(RetNo,'T3',7);    //city
      If Strings[63]='' then Strings[63] :=FetchElm(RetNo,'T3',67);   //prov
      If Strings[16]='' then Strings[16] :=FetchElm(RetNo,'T3',8);  //postal
     end;

     if FetchElm(RetNo,'T3',137)>'' then  //Company
     Begin
      If strings[15]='' then Strings[15] :=FetchElm(RetNo,'T3',64);    // street
      If Strings[17]='' then Strings[17] :=FetchElm(RetNo,'T3',65);    //city
      If Strings[63]='' then Strings[63] :=FetchElm(RetNo,'T3',66);   //prov
      If Strings[16]='' then Strings[16] :=FetchElm(RetNo,'T3',74);  //postal
     end;

   //20160227 Igor <<<<
    Strings[14]:='';;
    //20150125
    Strings[19]:=FetchElm(RetNo,'T3',14); //AppYear+'-'+'01-01';
    Strings[20]:=FetchElm(RetNo,'T3',17); //AppYear+'-'+'12-31';

    if Strings[42]>'' then //20180303 >=250000
    begin
      Strings[34]:='';Strings[86]:='X';
    end;


    //20160124
    If Strings[60]>'' then
    begin
     Strings[60]:=FormatFloat('########0',Round(Vl(Strings[60])));
     If Vl(Strings[60])=0 then Strings[60]:='0';
    end;
    If Strings[64]>'' then
    Begin
     Strings[64]:=FormatFloat('########0',Round(Vl(Strings[64])));
     If Vl(Strings[64])=0 then Strings[64]:='0';
    end;

    {
    // WHY HERE in T3?
    //20150208
    If FetchElm(RetNo,'INFO',68)>'' then Strings[15]:=FetchElm(RetNo,'INFO',6)+' '+'PO box '+FetchElm(RetNo,'INFO',68); //20140330
    If FetchElm(RetNo,'INFO',163)>'' then Strings[15]:=FetchElm(RetNo,'INFO',6)+' '+'RR '+FetchElm(RetNo,'INFO',163); //20140330
    }
    If Strings[28]='' then Strings[28]:='CAN';  //20150208
    If Strings[29]='' then Strings[29]:='N';  //20150208  //Preparer

    Strings[18] := AppYear;
    if Strings[72]=''  then  //20230205
      Strings[72] := FetchElm(RetNo,'T3',333)+'-'+FetchElm(RetNo,'T3',334);//20181217  //+LeftStr(FetchElm(RetNo,'INFO',113),6);  //20150207
    If Strings[73] = '' then Strings[73] := FormatDateTime('yyyy-mm-dd',Now);

    If UpperCase(Strings[29])='Y' then     //20220318
    Begin
     If Strings[74]='' then Strings[74] := OptRec.Prp_Name;
     If Strings[75]='' then Strings[75] := OptRec.Prp_Street;
     If Strings[78]='' then Strings[78] := OptRec.Prp_City;
     If Strings[79]='' then Strings[79] := OptRec.Prp_Prov;
     If Strings[76]='' then Strings[76] := OptRec.Prp_Postal;
     {If Strings[77]='' then}
     If Strings[77]='' then  Strings[77] := OptRec.Prp_Area+'-'+OptRec.Prp_Tel; //20150209
     //20220128 Igor <<<
    end
    else
    begin
     Strings[74]:='';
     Strings[75]:='';
     Strings[78]:='';
     Strings[79]:='';
     Strings[76]:='';
     Strings[77]:='';
    end;

    Tv[69] := Trunc(Tv[69]);

    ArrayNo:=1;
    BoxesPerRow:=5;
    T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo);  //20160124
    Tv[18]:=0;Tv[31]:=0;
    Elm:=ArrayNo*10000+StrToInt('4'); //for field id 10003 on the first row i form
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     //If Vl(FetchElmFNoDynamic(RetNo,FNo,Elm))=0 then StoreElmDynamic(RetNo,FNo,elm,FormatFloat('########0',Round(Vl(FetchElmFNoDynamic(RetNo,FNo,Elm))))); //??  20160124
     Tv[18]:=Tv[18]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('5');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[31]:=Tv[31]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;


    ArrayNo:=2;
    BoxesPerRow:=6; //GetDynamicBoxesPerRow(FName,???StrToInt(IntTostr(ArrayNo)+'0001'));
    T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo);  //20160124
    Tv[32]:=0;Tv[33]:=0;Tv[43]:=0;
    Elm:=ArrayNo*10000+StrToInt('4'); //for field id 10003 on the first row i form
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[32]:=Tv[32]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('5');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[33]:=Tv[33]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('6');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[43]:=Tv[43]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;

    ArrayNo:=3;
    BoxesPerRow:=6;
    T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo);            //20160124
    Tv[40]:=0;Tv[41]:=0;Tv[45]:=0;
    Elm:=ArrayNo*10000+StrToInt('4'); //for field id 10003 on the first row i form
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[40]:=Tv[40]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('5');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[41]:=Tv[41]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('6');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[45]:=Tv[45]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;

    ArrayNo:=4;
    BoxesPerRow:=7;
    T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo);    //20160124
    Tv[51]:=0;Tv[52]:=0;Tv[54]:=0;Tv[56]:=0;
    Elm:=ArrayNo*10000+StrToInt('4'); //for field id 10003 on the first row i form
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[51]:=Tv[51]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('5');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[52]:=Tv[52]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('6');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[54]:=Tv[54]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('7');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[56]:=Tv[56]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;

    ArrayNo:=5;
    BoxesPerRow:=6; //GetDynamicBoxesPerRow(FName,???StrToInt(IntTostr(ArrayNo)+'0001'));
    T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo);
    Tv[61]:=0;Tv[62]:=0;Tv[68]:=0;
    Elm:=ArrayNo*10000+StrToInt('4'); //for field id 10003 on the first row i form
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[61]:=Tv[61]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('5');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[62]:=Tv[62]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('6');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[68]:=Tv[68]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;

    ArrayNo:=6;
    BoxesPerRow:=6;
    T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo);
    Tv[81]:=0;Tv[82]:=0;Tv[85]:=0;
    Elm:=ArrayNo*10000+StrToInt('4'); //for field id 10003 on the first row i form
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[81]:=Tv[81]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('5');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[82]:=Tv[82]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('6');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[85]:=Tv[85]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;

    //20150103
    ArrayNo:=7;
    BoxesPerRow:=6;
    T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo);
    Tv[37]:=0;Tv[38]:=0;Tv[44]:=0;
    Elm:=ArrayNo*10000+StrToInt('4'); //for field id 10003 on the first row i form
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[37]:=Tv[37]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('5');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[38]:=Tv[38]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('6');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[44]:=Tv[44]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
   end;
  end;
 SaveTv(RetNo,FName,FNo);

end;


Procedure S1(RetNo:integer;FName:string;FNo:integer);
var i: integer;x:Real;
Begin
   LoadTv(RetNo,FName,FNo);
   With Ret[RetNo], Ret[RetNo].Frm[FNo] do
   begin

   //jz2025update-rev1: period  1 removed -->
   {
    Tv[104] := Tv[101] - Tv[102] - Tv[103];
        Tv[116] := TotMultiple(RetNo,'S1SUPQ',141);
        Tv[117] := TotMultiple(RetNo,'S1SUPQ',142);
           Tv[105] :=Tv[101] + Tv[116]+Tv[90];
    Tv[106] := Tv[104] + Tv[117]+Tv[124];
       //Qfarm
        Tv[137]:=Tv[134]-Tv[135]-Tv[136]; //20160205  //20160130
        Tv[15] := TotMultiple(RetNo,'S1SUPQ',179);
        Tv[32] := TotMultiple(RetNo,'S1SUPQ',180);
           Tv[113] := Tv[70] + Tv[15]+ Tv[125];
    Tv[114] :=  Tv[137]+Tv[32]+ Tv[126];  //20161227
       //shares
        Tv[7] := Tv[4] - Tv[5] - Tv[6];
    Tv[14] := Tv[11] - Tv[12] - Tv[13];

  Tv[16] := TotMultiple(RetNo,'S1SUPPL',71); //Vl(FetchElm(RetNo,'S1SUPPL',71));
  Tv[17] := TotMultiple(RetNo,'S1SUPPL',72); //Vl(FetchElm(RetNo,'S1SUPPL',72));

    Tv[18] := Tv[4] + Tv[11] + Tv[16];
    Tv[19] := Tv[7] + Tv[14] + Tv[17]
           + Vl(FetchElm(RetNo,'S1A',32))+Vl(FetchElm(RetNo,'S1A',33));
        //RE
    Tv[25] := Tv[22] - Tv[23] - Tv[24];
    Tv[31] := Tv[28] - Tv[29] - Tv[30];

  Tv[33] := TotMultiple(RetNo,'S1SUPPL',91); //Vl(FetchElm(RetNo,'S1SUPPL',91));
  Tv[34] := TotMultiple(RetNo,'S1SUPPL',92); //Vl(FetchElm(RetNo,'S1SUPPL',92));

    Tv[35] := Tv[22] + Tv[28] + Tv[33];
    Tv[36] := Tv[25] + Tv[31] + Tv[34];
        //Bonds
    Tv[46] := Tv[43] - Tv[44] - Tv[45];
    Tv[56] := Tv[53] - Tv[54] - Tv[55];

  Tv[58] := TotMultiple(RetNo,'S1SUPPL',125); //Vl(FetchElm(RetNo,'S1SUPPL',125));
  Tv[59] := TotMultiple(RetNo,'S1SUPPL',126); //Vl(FetchElm(RetNo,'S1SUPPL',126));

    Tv[60] := Tv[43] + Tv[53] + Tv[58];
    Tv[61] := Tv[46] + Tv[56] + Tv[59]
           + Vl(FetchElm(RetNo,'S1A',77))+ Vl(FetchElm(RetNo,'S1A',78));
        //pers use
    Tv[78] := Tv[75] - Tv[76] - Tv[77];
  Tv[49]:=Vl(FetchElm(RetNo,'T1079',85));  //20170609
  If Ret[RetNo].FrmHasdata[GetFormNo('T1255#1')]  then
    Tv[49]:=TotMultiple(RetNo,'T1255',137); //Vl(FetchElm(RetNo,'T1255#1',85));  //20220327
    Tv[81] := Tv[78] + Tv[80]+Tv[49];  //20170609
        //lpp
        Tv[64] := Tv[63] - Tv[85] - Tv[86];
        Tv[84]:=Tv[63];
        Tv[87]:=Tv[64];
    Tv[131] := MaxR(0,Tv[87] - Tv[88]);

  Tv[246]:= Tv[106]+Tv[114]+Tv[19]+Tv[61]+Tv[36]+ Tv[81]+Tv[131]; //202503246 //20250317 Igor

   //tfsa
  Tv[112]:=Tv[109]-Tv[110]-Tv[111];
  Tv[115]:=Tv[109]+Tv[119];
  Tv[118]:=Tv[112]+Tv[120];
  }
  //jz2025update-rev1: period  1 removed  <--



  //qualified small bus ------------------------------------
  Tv[121]:=Tv[128]-TV[123]-Tv[122];

  Tv[178] := TotMultiple(RetNo,'S1SUPQ',141); //line 1011 //jz//20260220 - get from corresponding elm in S1SUPQ
  Tv[179] := TotMultiple(RetNo,'S1SUPQ',142); //line 1012 //jz//20260220 - get from corresponding elm in S1SUPQ, was previously wrong  //Tv[179]:=Tv[178];


  {
  Tv[70] := TotMultiple(RetNo, 'T5013', 77); //jz//20260314 from T1--> Tv[168]:=TotMultiple(RetNo, 'T5013', 77);
  If Vl(FetchElm(RetNo,'T3MULT',11)) > 0 then  //20250510  eligible
    Tv[69]:= TotMultiple(RetNo, 'T3MULT', 328); //jz//20260111 - remove the Tv[169] +  //not 304 //20260106
  }



  //jz//20260315 - bring amounts from T5013, T3 slips
  Tv[70] := TotMultiple(RetNo, 'T5013INC', 13) + TotMultiple(RetNo, 'T3INCOME', 25);
  Tv[68] := Tv[70];

  Tv[98]:=Tv[128]+Tv[178]+Tv[70];
  Tv[95]:=Tv[121]+Tv[179]+Tv[68];

  //qualified farm/fishing ------------------------------------
  Tv[187]:=Tv[184]-Tv[185]-Tv[186];  //jz2025update-rev1: fixed 187 from 87

  Tv[180] := TotMultiple(RetNo,'S1SUPQ',179); //line 1021 //jz//20260220 - get from corresponding elm in S1SUPQ
  Tv[181] := TotMultiple(RetNo,'S1SUPQ',180); //line 1022 //jz//20260220 - get from corresponding elm in S1SUPQ, was previously wrong  //Tv[181]:=Tv[180];

  //jz//20260315 - bring amounts from T5013, T3 slips
  Tv[67] := TotMultiple(RetNo, 'T5013INC', 12) + TotMultiple(RetNo, 'T3INCOME', 24);
  Tv[69] := Tv[67];

  Tv[72]:=Tv[184]+Tv[180]+Tv[67];   //jz//20260315 - add Tv[67]
  Tv[71]:=Tv[187]+Tv[181]+Tv[69];


  //traded shares ------------------------------------
  Tv[171]:=Tv[174]-Tv[173]-Tv[172];
  Tv[164]:=Tv[167]-Tv[166]-Tv[165];   //20260330

  Tv[163] := TotMultiple(RetNo,'S1SUPPL',71); //line 1031 //jz//20260220 - get from corresponding elm in S1SUPPL
  Tv[162] := TotMultiple(RetNo,'S1SUPPL',72); //line 1032 //jz//20260220 - get from corresponding elm in S1SUPPL, was previously wrong  //Tv[162]:=Tv[163];

  Tv[161]:=Tv[174]+Tv[167]+Tv[163];
  Tv[160]:=Tv[171]+Tv[164]+Tv[162];



  //bonds, debentures, promissory, crypto, etc ------------------------------------
  Tv[152]:=Tv[155]-Tv[154]-Tv[153];
  Tv[144]:=Tv[147]-Tv[146]-Tv[145];

  Tv[143] := TotMultiple(RetNo,'S1SUPPL',125);  //line 1041 //jz//20260219 - get from corresponding elm in S1SUPPL
  Tv[142] := TotMultiple(RetNo,'S1SUPPL',126);  //line 1042 //jz//20260219 - seems wrong, get from corresponding elm in S1SUPPL  Tv[142]:=Tv[143];                   //jz2025update-rev1: changed from Tv[141]; is that correct??

  Tv[141]:=TV[155]+Tv[147]+Tv[143];
  Tv[140]:=Tv[152]+Tv[144]+Tv[142];

  //real estate ------------------------------------
  Tv[227]:=Tv[230]-Tv[229]-Tv[228];
  Tv[221]:=Tv[224]-Tv[223]-Tv[222];

  Tv[220] := TotMultiple(RetNo,'S1SUPPL',91);  //line 1051 //jz//20260219 - get from corresponding elm in S1SUPPL
  Tv[219] := TotMultiple(RetNo,'S1SUPPL',92);  //line 1052 //jz//20260219 - seems wrong, get from corresponding elm in S1SUPPL  Tv[219]:=Tv[220];

  Tv[218]:=Tv[230]+Tv[224]+Tv[220];
  Tv[217]:=Tv[227]+Tv[221]+Tv[219];

  //Personal use property ------------------------------------
  Tv[211]:=Tv[214]-Tv[213]-Tv[212];

  Tv[235]:=Vl(FetchElm(RetNo,'T1079',85));                //jz//20260220 - Tv[49] //20170609
  If Ret[RetNo].FrmHasdata[GetFormNo('T1255#1')]  then
    Tv[235]:=TotMultiple(RetNo,'T1255',137);               //jz//20260220 - Tv[49] //Vl(FetchElm(RetNo,'T1255#1',85));  //20220327

  //Tv[210]:=supplementary sheet      //jz2025update-rev1: get from where??? vtUser
  Tv[190]:=Vl(FetchElm(RetNo,'T3INCOME',6));  //20260328

  TV[191]:=Tv[214];
  Tv[209]:=Tv[211]+Tv[235]+Tv[210];

  //Listed personal property ------------------------------------
  Tv[188]:=Tv[189]-Tv[205]-Tv[204];
  Tv[206]:=Tv[189];
  Tv[203]:=TV[188];

  //Tv[202]:=???

  Tv[201]:=Tv[203]-Tv[202];

  //Tv[68]:= Tv[95]+Tv[71]+Tv[160]+Tv[140]+Tv[217]+Tv[209];



  //jz2025update-rev1: period 1 removed
  {-----------------------
  //period 1
  Tv[66]:= Tv[246];
  Tv[62]:=Tv[66]+Tv[89]+Tv[57];
  Tv[92]:=TV[62]-Tv[91];
  Tv[94]:=Tv[92]+Tv[93];

  Tv[65]:=Tv[94]-Tv[67];
  Tv[127]:=Tv[65]+Tv[96];
  }

  //Tv[236]:=Tv[68];

  //Tv[190]:=vtUser
  //Tv[192]:=vtUser
  Tv[193]:=Tv[95]+Tv[71]+Tv[160]+Tv[140]+Tv[217]+Tv[209] + ////jz2025update-rev1
           Tv[201]+Tv[190]+Tv[192];
  //Tv[194]:=vtUser
  Tv[243]:=Tv[193]-Tv[194];
  Tv[195]:=vl(fetchelm(RetNo, 'S2', 1)); //jz//20260220 as per form instruction, was vtUser
  Tv[196]:=Tv[243]+Tv[195];
  Tv[197]:=vl(fetchelm(RetNo, 'S1A',82)); //jz//20260220 as per form instruction, was vtUser
  Tv[198]:=Tv[196]-Tv[197];
  //Tv[199]:=vtUser
  //Tv[200]:=vtUser
  Tv[233]:=Tv[198]+Tv[200];  //????

  Tv[244]:=Tv[233]*50/100;

  //Tv[245] := Tv[118] + Tv[242]; //20250317 Igor
  //Tv[97]:=Tv[244]+TV[245];
  //Tv[246]:=Tv[244]+Tv[245]; //20250317 Igor Tv[97]:=Tv[244]+Tv[245];

  Tv[249]:=Tv[244];                 //from prev page

  //non qualified investments for TFSA, FHSA, RRSP, ETC
  Tv[248]:=Tv[239]-Tv[240]-Tv[241];
  Tv[247]:=Tv[239];
  Tv[242]:=Tv[248];

  Tv[97] :=Tv[249]+TV[242];

  end;
 {save data}
 SaveTv(RetNo,FName,FNo);
end;

Procedure S1SUPQ(RetNo:integer;FName:string;FNo:integer);
var i,k: integer;
Begin
   LoadTv(RetNo,FName,FNo);
   With Ret[RetNo], Ret[RetNo].Frm[FNo] do
   begin
   //Qual Shares
     i := 4; //k:=187;
     Tv[141] :=0;Tv[142] :=0;//Tv[182]:=0;Tv[183]:=0;
     Tv[179]:=0;Tv[180]:=0;
   //  TV[216]:=0;Tv[215]:=0;
     repeat
      Tv[i+3] := Tv[i] - Tv[i+1]-Tv[i+2];
      Tv[141] := Tv[141]+Tv[i];
      Tv[142] := Tv[142]+Tv[i+3];
      inc(i,7);
     until i > 137;
    // Tv[182]:=Tv[141] * (100-Tv[181])/100;
    // Tv[216]:=Tv[214] * (100-Tv[181])/100;

    // Tv[183]:=Tv[142] * (100-Tv[181])/100;
    // Tv[215]:=Tv[213] * (100-Tv[181])/100;
   //Qual Farm
     i := 145;
     //k:=207;
     Tv[179] :=0;Tv[180] :=0;Tv[220]:=0;Tv[219]:=0;
     repeat
      Tv[i+3] := Tv[i] - Tv[i+1]-Tv[i+2];
      Tv[179] := Tv[179]+Tv[i];
      Tv[180] := Tv[180]+Tv[i+3];
      inc(i,6);
     until i > 175;
    // Tv[185]:=Tv[179] * (100-Tv[184])/100;
    // Tv[186]:=Tv[180] * (100-Tv[184])/100;

    // Tv[220]:=Tv[218] * (100-Tv[184])/100;
    // Tv[219]:=Tv[217] * (100-Tv[184])/100;
 end;
 SaveTv(RetNo,FName,FNo);
end;

Function S1SectionII(RetNo, FNo: Integer):Boolean;
begin
 Result := false;
 with Ret[RetNo].Frm[FNo] do
 begin
   If ((Tv[1]>0) and (Tv[2]>0) and (Tv[15]>0))
   or
      ((Tv[1]<0) and (Tv[2]<0) and (Tv[15]<0)) then
   begin result := True;exit;end;

   If Tv[1] = 0 then
   begin
    If ((Tv[2]>0) and (Tv[15]>0))
    or ((Tv[2]<0) and (Tv[15]<0)) then
     begin result := True;exit;end;
   end;

   If Tv[2] =0 then
   begin
    If ((Tv[1]>0) and (Tv[15]>0))
    or ((Tv[1]<0) and (Tv[15]<0)) then
     begin result := True;exit;end;
   end;

   If Tv[15] =0 then
   begin
    If ((Tv[1]>0) and (Tv[2]>0))
    or ((Tv[1]<0) and (Tv[2]<0)) then
     begin result := True;exit;end;
   end;
 end;
end;


Function S1SectionIII(RetNo, FNo:Integer):Boolean;
begin
 Result := false;
 with Ret[RetNo].Frm[FNo] do
 begin
   If (Tv[1]>0) and (Tv[2]>0) and (Tv[16]>0) and (Tv[15]<0)
      and (Tv[1]<>0)
      and (Tv[2]<>0)
      and (Tv[3]<>0)
      and (Tv[15]<>0)
      and (Tv[16]<>0) then
    begin result := True;exit;end;

   If (Tv[1]<0) and (Tv[2]<0) and (Tv[16]<0) and (Tv[15]>0)
      and (Tv[1]<>0)
      and (Tv[2]<>0)
      and (Tv[3]<>0)
      and (Tv[15]<>0)
      and (Tv[16]<>0) then
    begin result := True;exit;end;
  end;
end;

Function S1SectionIV(RetNo, FNo:Integer):Boolean;
begin
 Result := false;
 with Ret[RetNo].Frm[FNo] do
 begin
   If (Tv[3]>0) and (Tv[15]>0)
      and (Tv[3]<>0)
      and (Tv[15]<>0) then
    begin result := True;exit;end;

   If (Tv[3]<0) and (Tv[15]<0)
      and (Tv[3]<>0)
      and (Tv[15]<>0) then
   begin result := True;exit;end;
 end;
end;

Function CalcInclusionRate(RetNo, FNo:Integer):Real;
Var YrEnd:String;
begin
  with Ret[RetNo].Frm[FNo] do
  begin
   {66.6666}
   If ((Tv[1] =0) and (Tv[3]<>0) and (Tv[16]<>0)) then
   begin
    If ((Tv[3] >0) and (Tv[16] >0))
    or ((Tv[3] <0) and (Tv[16] <0))
    then begin result := 0.6666;exit;end; {66.6666;exit;end;}
   end;

   If Tv[2] <>0 then
   begin
    If ((Tv[2] >0) and (Tv[3]>0) and (Tv[16] >0))
    or ((Tv[2] <0) and (Tv[3]<0) and (Tv[16] <0))
    then begin result := 0.6666;exit;end; {66.6666;exit;end;}
   end;

   {75}
   If Tv[16] <>0 then
   begin
    If ((Tv[1] >0) and (Tv[3]>0) and (Tv[16] >0))
    or ((Tv[1] <0) and (Tv[3]<0) and (Tv[16] <0))
    then begin result := 0.75;exit;end; {75;exit;end;}
   end;
   {if all above fails}
   YrEnd:=FetchElm(RetNo,'T3',17);
   If Yrend<'2000-02-28' then result := 0.75;
   If (Yrend>'2000-02-27') and (YrEnd <'2000-10-18') then result := 0.6666;
   If Yrend>'2000-10-17' then result := 0.50;
   {Result := 50;}
  end;
end;


Procedure T3ON(RetNo:integer;FName:string;FNo:integer);
Var i,k :integer; SpRetNo,WhichRetNo:integer;


        Procedure calcT3ONChart1(RetNo: integer; FName: String; FNo: integer);
        begin

             with Ret[RetNo].Frm[FNo] do
             begin
               //Dividend tax credit  //20170114
               Tv[53]:=Vl(FetchElm(RetNo,'S8',34));

               Strings[60]:=PrvConstant[RY].PrvDivRate;  //20180108
               Strings[35]:=PrvConstant[RY].PrvDivRateBig; //20180108
                  //20231203
               if CertificationMode=True then
               Begin
                 Strings[60]:=PrvConstant[0].PrvDivRate;
                 Strings[35]:=PrvConstant[RY].PrvDivRateBig; //20180108
               End;

               Tv[52]:=Tv[53]* Vl(PrvConstant[RY].PrvDivRateBig)/100;
               Tv[33]:=Vl(FetchElm(RetNo,'S8',35));
               Tv[34]:=Tv[33]*Vl(PrvConstant[RY].PrvDivRate)/100;
               Tv[84]:=Tv[52]+Tv[34];

             end;
        end;

        //jz//20260220 - alot was wrong, revamp
        Procedure calcT3ONChart2(RetNo: integer; FName: String; FNo: integer);
        var i:integer;
        begin
            //--chart 2 --87 to 103---------
            with Ret[RetNo].Frm[FNo] do
            begin

              //keep rates out of if so always shows then
              strings[81]  := '24.63';  //jz//20260220 - what happeed to these changes?? change again //jz2025update-rev1:update value and change to an editbox
              strings[100] := '56';     //jz//20260220 - what happeed to these changes?? change again ////jz2025update-rev1:update value and change to an editbox
              Tv[54]:=Tv[64];
              Tv[55]:=Tv[65];

              if Vl(FetchElm(RetNo,'S12',124))>0 then //MIN TAX
              begin
                Tv[87] := Vl(FetchElm(RetNo,'S12',124));
                Tv[88] := Tv[87] * vl(strings[81])/100;

                if OtherThanQREAndQdt(RetNo)then
                Begin
                   Tv[89]:=Tv[88];
                   Tv[90]:=Tv[89]*vl(Ret[RetNo].Frm[FNo].Strings[100])/100; //Tv[100]/100;    //20211205
                End
                else           //(lines 40 to 46 apply only to GRE or QDT. Other trusts should leave those lines blank, enter “0” on line 47, and continue at line 48.)
                Begin
                  Tv[89]:=0;Tv[90]:=0; //clear

                  Tv[91]:=Tv[88];
                  Tv[92]:=Tv[39];
                  Tv[93]:=Tv[91]+Tv[92];

                  //Complete lines 43 to 47 only if the amount on line 42 is more than $5,710. Otherwise, enter the amount from line 38 on line 48.
                  if Tv[93] > Tv[64] then
                  begin
                    Tv[94]:=Tv[93];
                    Tv[95]:=MaxR(0,Tv[94]-Tv[54]) * 20/100;  //20231121

                    Tv[96]:=Tv[93];
                    Tv[97]:=MaxR(0,Tv[96]-Tv[55]) * 36/100; //20231121

                    Tv[98]:=Tv[95]+Tv[97];

                    Tv[99]:=Tv[49];
                    Tv[102]:=MaxR(0,Tv[98]-Tv[99]); //Tv[100]; //20230212
                  end
                  else    //more than $5,710, clear
                  begin
                    for i:=94 to 99 do Tv[i]:=0; Tv[102]:=0;
                  end;
                End;
                Tv[103]:=Tv[88]+Tv[90]+Tv[102]; //ln48
              End     //end if MINTAX
              Else    //no min tax, clear
              begin
                  Tv[81]:=0; for i:=87 to 103 do Tv[i]:=0;
              end;
            end; //end with
        end; //end calcT3ONChart2

  //20170114
Begin
 if Certificationmode=True then   //20231203
 Begin
  Ret[RetNo].Province:='ON';
  Ret[RetNo].FrmHasdata[FNo]:=True;
 end;
 InitPrvConstants('ON');
 If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);

 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
 For i:=1 to 69 do Tv[i]:=0;
 //20141231
 For i:=2 to 22 do Tv[i]:=0;
 For i:=156 to 162 do Tv[i]:=0;
 For i:=117 to 121 do Tv[i]:=0;
 For i:=123 to 124 do Tv[i]:=0;  //20160811

 //20260118
 if CalcThisProvince(RetNo,'ON')=false then
 Begin
     For i:=1 to 124 do Tv[i]:=0;
     SaveTv(RetNo,FName,FNo);
     Exit;
 End;

 Tv[1]:= GetTrustTxbl(RetNo);

 With PrvConstant[RY] do
    begin
     Ret[RetNo].Frm[FNo].Strings[66]:=FormatFloat('###,###',PrvBracket1);
     Ret[RetNo].Frm[FNo].Strings[67]:=FormatFloat('###,###',PrvBracket1);
     Ret[RetNo].Frm[FNo].Strings[68]:=FormatFloat('###,###',PrvBracket2);
     Ret[RetNo].Frm[FNo].Strings[70]:=FormatFloat('###,###',PrvBracket2);
     Ret[RetNo].Frm[FNo].Strings[61]:=FormatFloat('###,###',PrvBracket3);
     Ret[RetNo].Frm[FNo].Strings[71]:=FormatFloat('###,###',PrvBracket3);
     Ret[RetNo].Frm[FNo].Strings[72]:=FormatFloat('###,###',PrvBracket4);
     Ret[RetNo].Frm[FNo].Strings[69]:=FormatFloat('###,###',PrvBracket4);

     Ret[RetNo].Frm[FNo].Strings[5]:= '0.00';
     Tv[6]   :=PrvBracket1;
     Tv[7]   :=PrvBracket2;
     Tv[157] :=PrvBracket3;
     Tv[118] :=PrvBracket4;

     Tv[11]  := Vl(PrvConstant[RY].PrvRate1);
     Tv[12]  := Vl(PrvConstant[RY].PrvRate2);
     Tv[13]  := Vl(PrvConstant[RY].PrvRate3);
     Tv[159] := Vl(PrvConstant[RY].PrvRate4);
     Tv[120] := Vl(PrvConstant[RY].PrvRate5);

     Tv[57]:= Vl(PrvConstant[RY].PrvRate5);

     Tv[17]:= PrvConstant[RY].PrvBracketTax1;
     Tv[18]:= PrvConstant[RY].PrvBracketTax2;
     Tv[19]:= PrvConstant[RY].PrvBracketTax3;
     Tv[161]:= PrvConstant[RY].PrvBracketTax4;
     Tv[123]:= PrvConstant[RY].PrvBracketTax5;

     Tv[58]:= PrvConstant[RY].PrvDonRate1;
     Tv[59]:= 11.16;   //20170114
     Tv[37]:= 17.41; //20211030 //PrvConstant[RY].PrvDonRate2;  //Tv[37]:=17.41; //20201209  //donation rate all other trusts

     //20231203
     Ret[RetNo].Frm[FNo].Strings[60]:= PrvConstant[RY].PrvDivRate;
     Ret[RetNo].Frm[FNo].Strings[35]:= PrvConstant[RY].PrvDivRateBig;

     if CertificationMode=True then //20231203
       Begin
        Ret[RetNo].Frm[FNo].Strings[60]:= PrvConstant[RY].PrvDivRate;
        Ret[RetNo].Frm[FNo].Strings[35]:= PrvConstant[RY].PrvDivRateBig; //20201209
       end;


     Tv[55]:= PrvConstant[RY].PrvAmtCarryOverRate;

     //jz2025update-rev1:
     Tv[62] := 20; Tv[104] := 20; 
     Tv[63] := 36; Tv[105] := 36;



     {CERTIFICATION  20201209 dummy out this section Open New, set ONT provinve, open T3ON and click Recalc
     //20170305
     //BETTER override the amounts directly on the form
     }
     //-------------------------------------------


     If (OtherThanQreAndQdt(RetNo)=True) then
     Begin
        If CertificationMode=False then
        Begin
         Tv[57]:= Vl(PrvConstant[RY].PrvRate5);
         //20181219
         For i:=2 to 22 do Tv[i]:=0;
         For i:=156 to 162 do Tv[i]:=0;
         For i:=117 to 121 do begin Tv[i]:=0; Ret[RetNo].Frm[FNo].Strings[i]:='';end;
         For i:=123 to 124 do Tv[i]:=0;  //20160811
       end;
     End;
    // else Tv[57]:=0;
     //---------------------------------------------------------
      //20261006 Alex >>>
     if Ry = 0 then   //20250226    //jz2025update-rev1: update Tv[64],Tv[65] as per form
     begin
       Tv[64]:= 5818; //5710; //20261006 Alex
       Tv[65]:= 7446; //7307; //20261006 Alex
       Tv[54]:= Tv[64];
       Tv[55]:= Tv[65];
     end else
     begin
       Tv[64]:= 5818; //5710; //20261006 Alex
       Tv[65]:= 7446; //7307; //20261006 Alex
       Tv[54]:= Tv[64];
       Tv[55]:= Tv[65];
     end;
      //20261006 Alex <<<
  end;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[8] := MaxR(0,Tv[2]-vl(Frm[FNo].Strings[5]));
     Tv[14] := Tv[8] * Vl(Frm[FNo].Strings[11])/100;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Vl(Frm[FNo].Strings[12])/100;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
   and (Tv[1] <PrvConstant[RY].PrvBracket3)
   then
   begin
     Tv[4] := Tv[1];
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Vl(Frm[FNo].Strings[13])/100;
     Tv[22] := Tv[16] + Tv[19];
   end;
   //20130202
   If (Tv[1] > PrvConstant[RY].PrvBracket3)
    and (Tv[1] <PrvConstant[RY].PrvBracket4)     //20141231
   then
   begin
     Tv[156] := Tv[1];
     Tv[158] := MaxR(0,Tv[156]-Tv[157]);
     Tv[160] := Tv[158] * Vl(Frm[FNo].Strings[159])/100;
     Tv[162] := Tv[160] + Tv[161];
   end;

   //20141231
   If (Tv[1] > PrvConstant[RY].PrvBracket4)
   then
   begin
     Tv[117] := Tv[1];
     Tv[119] := MaxR(0,Tv[117]-Tv[118]);
     Tv[121] := Tv[119] * Vl(Frm[FNo].Strings[120])/100;
     Tv[124] := Tv[121] + Tv[123];
   end;

   //20160811
   Tv[57]:=20.53;  //20170114
   If OtherThanQreAndQdt(RetNo)=True then
   Begin
     Tv[23] := Tv[1];
     Tv[24]:=Tv[23] * Tv[57]/100;
   end
   Else
   Begin
     Tv[23]:=0;
     Tv[24]:=0;
   End;

   //20170326
   Tv[25]:= Vl(FetchElm(RetNo,'S11A',15));  //20170326 //  Tv[25]:= Vl(FetchElm(RetNo,'S11',38));
   //20170327
   Tv[28]:=0;
   Tv[41]:=0;

   If Tv[25]>200 then
   begin
    Tv[26]:=200;
    If (IsQre(RetNo)) or (IsQdt(RetNo)) then
      Begin
        Tv[28]:=MaxR(0,Tv[25]-200);
        Tv[41]:=0;
      end
      Else
      Begin
        Tv[41] :=MaxR(0,Tv[25]-200);
        Tv[28]:=0;
      end;
    end  //>200
    else
    begin
     Tv[26]:=Tv[25];
     Tv[28]:=0;
     Tv[41]:=0;
    end;


    Tv[27] := Tv[26] * Tv[58]/100;
    Tv[29] := Tv[28] * Tv[59]/100;
    Tv[38] := Tv[41] * Tv[37]/100;
    Tv[30] := Tv[27]+Tv[29]+Tv[38];

    If OtherThanQreAndQdt(RetNo)=True then
      Tv[31] := Tv[24]
    else
    Begin
      Tv[31] := MaxR(MaxR(Tv[20],Tv[162]),MaxR(Tv[21],Tv[22]));
      Tv[31] := MaxR(Tv[31],Tv[124]);  //20141231
    end;

    Tv[83]:=Tv[31]+Tv[82];
    Tv[32] := Tv[30];
    Tv[73]:=MaxR(0,Tv[31]-Tv[32]);   //20141231

    Tv[74]:=Tv[73];

    calcT3ONChart1(RetNo,FName,FNo);

    Tv[75]:=Tv[84];
    Tv[76]:=MaxR(0,Tv[74]-Tv[75]);   //20141231
    Tv[77]:=Vl(FetchElm(RetNo,'S11',143)); //20141231
    strings[81]:= '24.63';
    Tv[78]:=Tv[77] * vl(strings[81])/100; // 24.63/100; //jz2025update-rev1: as per form //33.67/100; and change to field


    //dividends at the bottom of form //20141231
    Tv[53] := Vl(FetchElm(RetNo,'S8',34));
    Tv[33] := Vl(FetchElm(RetNo,'S8',35));
    Tv[81] := Vl(FetchElm(RetNo,'S8',43));      //20141231
    Tv[52]:=  Tv[53] * Vl(Ret[RetNo].Frm[FNo].Strings[35])/100;
    Tv[34] := Tv[33] * Vl(Ret[RetNo].Frm[FNo].Strings[60])/100;
    Tv[83]:=  Tv[81] * Vl(Ret[RetNo].Frm[FNo].Strings[82])/100;
    Tv[84]:=Tv[52]+Tv[34]+Tv[83];   //20141231
    Tv[36]:=MinR(Tv[76],Tv[78]);
    Tv[39] := MaxR(0,Tv[73]-Tv[36]);

    if OtherThanQREAndQdt(RetNo)=False then  //they are QRE or QDT   //20170301
    Begin
      Tv[42] := Tv[39];
     Tv[43] := MaxR(0,Tv[42] - Tv[64]);
     Tv[44] := Tv[43] * Tv[62]/100;

     Tv[45] := Tv[39];
     Tv[46] := MaxR(0,Tv[45]-Tv[65]);
     Tv[47] := Tv[46]* Tv[63]/100;
     Tv[48] := Tv[44]+Tv[47];
     Tv[49] := Tv[48];
    End
    Else
    Begin
      for i:=42 to 49 do Tv[i]:=0;
    End;

    Tv[50] := Tv[39]+Tv[49];
    Tv[85]:=Tv[80]; //Tv[50];   //20210310
    Tv[79]:=Tv[84];
    Tv[80]:=MaxR(0,Tv[50]-Tv[79]);  //20210312 //MaxR(0,Tv[85]-Tv[79]);  //20170106

    Tv[85]:=Tv[80];  //20210312

    calcT3ONChart2(RetNo,FName,FNo);

    if Vl(FetchElm(RetNo,'S12',124))>0 then  //20231121
      Tv[40]:=Tv[103]  //20231121
    else
      Tv[40]:=0;

    Tv[86]:=Tv[85]+Tv[40]; //Tv[80]+Tv[40];  //20210312
    Tv[51] := GetPrvForTaxCredit(RetNo);
    Tv[56] := MaxR(0,Tv[86]-Tv[51]);

  end;
  StoreElm(RetNo,FNo,17,'0.00'); //jz//20260220 why ??????????????????????  //20180226
 SaveTv(RetNo,FName,FNo);
end;

Procedure T3BC(RetNo:integer;FName:string;FNo:integer);
Var i:Integer;
Begin
 if Certificationmode=True then   //20231203
 Begin
  Ret[RetNo].Province:='BC';
  Ret[RetNo].FrmHasdata[FNo]:=True;
 end;
 InitPrvConstants('BC');
 If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);

 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
   //20260118
   if CalcThisProvince(RetNo,'BC')=false then
   Begin
     For i:=1 to 130 do Tv[i]:=0;
     SaveTv(RetNo,FName,FNo);
     Exit;
   End;

   Tv[1]:= GetTrustTxbl(RetNo);

   //initilize  columns
   For i:=2 to 22 do Tv[i]:=0;
   For i:=66 to 79 do Tv[i]:=0;
   For i:=85 to 90 do Tv[i]:=0;
   For i:=124 to 129 do Tv[i]:=0;


   //20170114
   With PrvConstant[RY] do
      begin
       Ret[RetNo].Frm[FNo].Strings[23] :=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[24] :=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[25] :=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[26] :=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[27] :=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[28] :=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[29] :=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[29] :=FormatFloat('###,###',PrvBracket4);
       Ret[RetNo].Frm[FNo].Strings[91] :=FormatFloat('###,###',PrvBracket4);
       Ret[RetNo].Frm[FNo].Strings[92] :=FormatFloat('###,###',PrvBracket5);
       Ret[RetNo].Frm[FNo].Strings[119]:=FormatFloat('###,###',PrvBracket5);
       Ret[RetNo].Frm[FNo].Strings[56] :=FormatFloat('###,###',PrvBracket6);
       Ret[RetNo].Frm[FNo].Strings[118]:=FormatFloat('###,###',PrvBracket6);

       //20181106 Igor <<<

       //Tv[5] := 0;
       Ret[RetNo].Frm[FNo].Strings[5] := '0.00';
       //20180226
       Tv[6]:=   PrvBracket1;
       Tv[7]:=   PrvBracket2;
       Tv[67]:=  PrvBracket3;
       Tv[74]:=  PrvBracket4;
       Tv[86]:=  PrvBracket5; //20181106 Igor  //20181129 con
       Tv[125]:= PrvBracket6;

       Tv[11]:=  Vl(PrvConstant[RY].PrvRate1);
       Tv[12]:=  Vl(PrvConstant[RY].PrvRate2);
       Tv[13]:=  Vl(PrvConstant[RY].PrvRate3);
       Tv[69]:=  Vl(PrvConstant[RY].PrvRate4);
       Tv[76]:=  Vl(PrvConstant[RY].PrvRate5);
       Tv[88]:=  Vl(PrvConstant[RY].PrvRate6); //20181106 Igor //20181129 con
       Tv[127]:= Vl(PrvConstant[RY].PrvRate7);

       Tv[17]:= PrvConstant[RY].PrvBracketTax1;
       Tv[18]:= PrvConstant[RY].PrvBracketTax2;
       Tv[19]:= PrvConstant[RY].PrvBracketTax3;
       Tv[71]:= PrvConstant[RY].PrvBracketTax4;
       Tv[78]:= PrvConstant[RY].PrvBracketTax5;
       Tv[90]:= PrvConstant[RY].PrvBracketTax6; //20181106 Igor //20181129 con
       Tv[129]:= PrvConstant[RY].PrvBracketTax7;

       //20201206
       Tv[32]:= 20.5; //20201206 /Vl(PrvConstant[RY].PrvRate6);

       Tv[36]:= 5.06;
       Tv[39]:= 16.8;
       Tv[93]:= 20.5;
       Tv[96]:= 5.06;
       Tv[99]:= 20.5;

       Strings[82]:= PrvConstant[RY].PrvDivRateBig;  //43.58;
       Strings[44]:= PrvConstant[RY].PrvDivRate;  //15.0; //

      //20231203
      if CertificationMode=True then
      Begin
       Strings[82]:= PrvConstant[RY].PrvDivRateBig;  //43.58;
       Strings[44]:= PrvConstant[RY].PrvDivRate;  //15.0; //
      End;


       Tv[47]:= 34.9; //jz2025update-rev1: updated as per form //33.7; //PrvConstant[RY].PrvAmtCarryOverRate;
       //polit chart
       Tv[117]:=550;
       Tv[114]:=75;
       Tv[121]:=300;
       Tv[123]:=500;
     end;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   StoreElm(RetNo,FNo,17,'0.00'); //20180226
   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[8] := MaxR(0,Tv[2] - vl(Frm[FNo].Strings[5]) );
     Tv[14] := Tv[8] * Vl(Frm[FNo].Strings[11])/100;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Vl(Frm[FNo].Strings[12])/100;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
    and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[4] := Tv[1];
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Tv[13]/100;
     Tv[22] := Tv[16] + Tv[19];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket3)
    and (Tv[1] <= PrvConstant[RY].PrvBracket4) then
   begin
     Tv[66] := Tv[1];
     Tv[68] := MaxR(0,Tv[66]-Tv[67]);
     Tv[70] := Tv[68] * Tv[69]/100;
     Tv[72] := Tv[70] + Tv[71];
   end;

   //20181106 Igor >>>  //20181129 con
   If (Tv[1] > PrvConstant[RY].PrvBracket4)
     and (Tv[1] <= PrvConstant[RY].PrvBracket5) then
   begin
     Tv[73] := Tv[1];
     Tv[75] := MaxR(0,Tv[73]-Tv[74]);
     Tv[77] := Tv[75] * Tv[76]/100;
     Tv[79] := Tv[77] + Tv[78];
   end;

   //20181129 con
   If (Tv[1] > PrvConstant[RY].PrvBracket5)
   and (Tv[1] <= PrvConstant[RY].PrvBracket6)
   then
   begin
     Tv[85] := Tv[1];
     Tv[87] := MaxR(0,Tv[85]-Tv[86]);
     Tv[89] := Tv[87] * Tv[88]/100;
     Tv[57] := Tv[89] + Tv[90];
   end;

   //20201207
   If (Tv[1] > PrvConstant[RY].PrvBracket6)
   then
   begin
     Tv[124] := Tv[1];
     Tv[126] := MaxR(0,Tv[124]-Tv[125]);
     Tv[128] := Tv[126] * Tv[127]/100;
     Tv[130] := Tv[128] + Tv[129];
   end;


  // Tv[32]:=20.5; //see top assignments //20201206 16.8;  //20170114  // 20181106 Igor
   If OtherThanQreAndQdt(RetNo)=True then
    Tv[31] := Tv[1]
   else
    Tv[31]:=0;
   Tv[33]:=Tv[31] * Tv[32]/100;

   Tv[34]:= Vl(FetchElm(RetNo,'S11A',15));  //20170326

   If (IsQre(RetNo)) or (IsQdt(RetNo)) then
   Begin
    If Tv[34]>200 then
    begin
     Tv[35]:=200;
     Tv[38] :=MaxR(0,Tv[34]-200);
    end
    else
    begin
     Tv[35]:=Tv[34];
     Tv[38]:=0;
    end;
    if CertificationMode=false then  //20211204
    Begin
     Tv[37] := Tv[35] * Tv[36]/100;
     Tv[40] := Tv[38] * Tv[39]/100;
     Tv[41] := Tv[37]+Tv[40];
     Tv[94]:=Tv[37]+Tv[40]+Tv[41];
    End;
   end;

   If (OtherThanQreAndQdt(RetNo)=True) then  //If IsIntervivos(RetNo) then
   begin
     if Tv[34]>200 then
     Begin
      Tv[95]:=200;
      Tv[98]:=Tv[34]-200;
     end
     Else
     Begin
      Tv[95]:=Tv[34];
      Tv[98]:=0;
     End;
     Tv[97]:=Tv[95]*Tv[96]/100;
     Tv[100]:=Tv[98]*Tv[99]/100;
     Tv[105]:=Tv[97]+Tv[100];
   end
   Else
   Begin
    For i:=95 to 100 do begin Tv[i]:=0; end;
    Tv[105]:=0
   End;
   Tv[112]:=MaxR(Tv[94],Tv[105]);

   Tv[42] := MaxR(Tv[20],MaxR(Tv[21],Tv[22]));
   Tv[42]:= MaxR(MaxR(Tv[42],Tv[72]),Tv[79]);
   Tv[42]:= MaxR(Tv[42],Tv[57]);
   Tv[42]:= MaxR(Tv[42],Tv[130]);

   If (OtherThanQreAndQdt(RetNo)=True) then Tv[42]:=Tv[33];  //20211212

   Tv[84]:=Tv[42]+Tv[59];  //20170113
   Tv[65] := Tv[41];
   Tv[83] := Vl(FetchElm(RetNo,'S8',34));
   Tv[43] := Vl(FetchElm(RetNo,'S8',35))+Vl(FetchElm(RetNo,'S8',43)); //20141231

   //20231222 CZ
   Tv[81]:= Tv[83] * Vl(Strings[82])/100;
   Tv[45]:= Tv[43] * Vl(Strings[44])/100;
   //=====================
   Tv[46] := Vl(FetchElm(RetNo,'S11',143)); //Vl(FetchElm(RetNo,'S11',43));
   Tv[48] := Tv[46] * Tv[47]/100;
   Tv[49] := Tv[65]+Tv[81]+Tv[45]+Tv[48];
   Tv[50] := Tv[49];

   Tv[51] := MaxR(0,Tv[84]-Tv[50]);   //20170113

   Tv[60]:=Tv[51];    //20211125
   If SubjectToMinTax(RetNo) then
    Tv[52] :=  Vl(FetchElm(RetNo,'S12',538))
   else
    Tv[52]:=0;
   Tv[53] := Tv[60]+Tv[52];   //20211125

   Tv[54] := GetPrvForTaxCredit(RetNo);
   Tv[55] := MaxR(0,Tv[53] - Tv[54]);
   TV[58] := Vl(FetchElm(RetNo,'PRVCR',2));
   Tv[62]:= MaxR(0,Tv[55]-Tv[58]);  //20230212
   Tv[64]:= MaxR(0,Tv[62] - Tv[61]); //Tv[55];
 end;
 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
    //Instructions
   Frm[FNo].Strings[103] := '0.00';
   StoreElm(RetNo,FNo,107,'0.00'); //20180226
   Tv[110]:=100;
   Tv[114]:=75;
   Tv[117]:=550;
   Tv[121]:=300;
   Tv[123]:=500;
 end;
 Ret[RetNo].Frm[FNo].Strings[17] := '0.00';
 Ret[RetNo].Frm[FNo].Strings[107] := '0.00';

 SaveTv(RetNo,FName,FNo);

end;

Function CalcBCSurtax(RetNo:Integer;ATax:Real):Real;
begin
 Result := MaxR(0,ATax-BcToni[RY].SurtaxThresh1) * BcToni[RY].SurtaxRate1/100
          + MaxR(0,ATax-BcToni[RY].SurtaxThresh2) * BcToni[RY].SurtaxRate2/100;
end;

Procedure T3NS(RetNo:integer;FName:string;FNo:integer);
Var i:integer;
Begin
 if Certificationmode=True then   //20231203
 Begin
  Ret[RetNo].Province:='NS';
  Ret[RetNo].FrmHasdata[FNo]:=True;
 end;
 InitPrvConstants('NS');
 If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);


 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
   //20260118
   if CalcThisProvince(RetNo,'NS')=false then
   Begin
     For i:=1 to 79 do Tv[i]:=0;
     SaveTv(RetNo,FName,FNo);
     Exit;
   End;

   Tv[1]:= GetTrustTxbl(RetNo);

   With PrvConstant[RY] do
      begin
       Ret[RetNo].Frm[FNo].Strings[60]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[61]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[62]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[63]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[68]:=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[42]:=FormatFloat('###,###',PrvBracket3);  //20110210
       Ret[RetNo].Frm[FNo].Strings[67]:=FormatFloat('###,###',PrvBracket4);
       Ret[RetNo].Frm[FNo].Strings[72]:=FormatFloat('###,###',PrvBracket4);

       //Tv[5] := 0;
       Ret[RetNo].Frm[FNo].Strings[5]:= '0.00';
       Tv[6]:=PrvBracket1;
       Tv[7]:=PrvBracket2;
       Tv[57]:=PrvBracket3;
       Tv[74]:=PrvBracket4;

       Tv[11]:= Vl(PrvConstant[RY].PrvRate1);
       Tv[12]:= Vl(PrvConstant[RY].PrvRate2);
       Tv[13]:= Vl(PrvConstant[RY].PrvRate3);
       Tv[59]:= Vl(PrvConstant[RY].PrvRate4);
       Tv[76]:= Vl(PrvConstant[RY].PrvRate5);

       Tv[17]:= PrvConstant[RY].PrvBracketTax1;
       Tv[18]:= PrvConstant[RY].PrvBracketTax2;
       Tv[19]:= PrvConstant[RY].PrvBracketTax3;
       Tv[65]:= PrvConstant[RY].PrvBracketTax4;
       Tv[78]:= PrvConstant[RY].PrvBracketTax5;

       Tv[50]:= Vl(PrvConstant[RY].PrvRate5); //PrvConstant[RY].PrvIntervivosRate;
       Tv[51]:= PrvConstant[RY].PrvDonRate1;
       Tv[52]:= PrvConstant[RY].PrvDonRate2;

       Strings[53]:= PrvConstant[RY].PrvDivRate;
       Strings[69]:= PrvConstant[RY].PrvDivRateBig;
       if CertificationMode=True then
       Begin
         Ret[RetNo].Frm[FNo].Strings[53]:=PrvConstant[0].PrvDivRate;
         Ret[RetNo].Frm[FNo].Strings[69]:=PrvConstant[RY].PrvDivRateBig; //20180108
       End;


       Tv[50]:=Vl(PrvConstant[RY].PrvRate5); //PrvConstant[RY].PrvIntervivosRate;

       Tv[54]:= PrvConstant[RY].PrvAmtCarryOverRate;
     end;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[8] := MaxR(0,Tv[2]-vl(Frm[FNo].Strings[5]));
     Tv[14] := Tv[8] * Tv[11]/100;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Tv[12]/100;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
   and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[4] := Tv[1];
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Tv[13]/100;
     Tv[22] := Tv[16] + Tv[19];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket3)
   and (Tv[1] <= PrvConstant[RY].PrvBracket4) then
   begin
     Tv[56] := Tv[1];
     Tv[58] := MaxR(0,Tv[56]-Tv[57]);
     Tv[64] := Tv[58] * Tv[59]/100;
     Tv[66] := Tv[64] + Tv[65];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket4) then
   begin
     Tv[73] := Tv[1];
     Tv[75] := MaxR(0,Tv[73]-Tv[74]);
     Tv[77] := Tv[75] * Tv[76]/100;
     Tv[79] := Tv[77] + Tv[78];
   end;

   If OtherThanQreAndQdt(RetNo)=True then
    Tv[23] := Tv[1]
   else
    Tv[23]:=0;
   Tv[24]:=Tv[23] * Tv[50]/100;

   Tv[25]:=Vl(FetchElm(RetNo,'S11A',15));  //20170326  Vl(FetchElm(RetNo,'S11',38));
   If Tv[25]>200 then
   begin
    Tv[27]:=200;
    Tv[29] :=MaxR(0,Tv[25]-200);
   end
   else
   begin
    Tv[27]:=Tv[25];
    Tv[29]:=0;
   end;
   Tv[26] := Tv[27] * Tv[51]/100;
   Tv[28] := Tv[29] * Tv[52]/100;
   Tv[30] := Tv[26]+Tv[28];

   If OtherThanQreAndQdt(RetNo)=True then
     Tv[31] := Tv[24]
   else
   begin        //20110210
     Tv[31] := MaxR(MaxR(Tv[20],Tv[21]),MaxR(Tv[22],Tv[66]));
     Tv[31]:=MaxR(Tv[31],Tv[79]);
   end;
   Tv[44]:=Tv[31]+Tv[43]; //20170113

   Tv[32] := Tv[30];
   Tv[71] := Vl(FetchElm(RetNo,'S8',34));
   Tv[33] := Vl(FetchElm(RetNo,'S8',35))+Vl(FetchElm(RetNo,'S8',43)); //20141231

   Tv[70] := Tv[71] * Tv[69]/100;
   Tv[34] := Tv[33] * Tv[53]/100;

   Tv[35] := Vl(FetchElm(RetNo,'S11',143)); //Vl(FetchElm(RetNo,'S11',43));  //20160813
   Tv[36] := Tv[35] * Tv[54]/100;
   Tv[37] := Tv[32]+Tv[70]+Tv[34]+Tv[36];
   Tv[38] := Tv[37];
   Tv[39] := MaxR(0,Tv[44]-Tv[38]);
   If SubjectToMinTax(RetNo) then
    Tv[40] :=  Vl(FetchElm(RetNo,'S12',506))
   else
    Tv[40]:=0;
   Tv[41] := Tv[39]+Tv[40];
   (* 20110208
   Tv[42]:= Tv[41];
   Tv[43]:= MaxR(0,(Tv[42]-10000)*10/100);
   Tv[44]:= Tv[41]+Tv[43];
   *)
   Tv[45] := GetPrvForTaxCredit(RetNo);
   Tv[46] :=Vl(FetchElm(RetNo,'POLIT',82));

   Tv[47]:=CalcPolitCredit('NS',Tv[46]);

   Tv[55]:= Tv[45]+Tv[47];
   Tv[48] := Tv[55];
   Tv[49] := MaxR(0,Tv[41] - Tv[48]); //  20110208  MaxR(0,Tv[44] - Tv[48]);
 end;
 StoreElm(RetNo,FNo,17,'0.00'); //20180226
 SaveTv(RetNo,FName,FNo);

End;

Procedure T3NB(RetNo:integer;FName:string;FNo:integer);
Var i:integer;x,y,z:real;
Begin
 if Certificationmode=True then   //20231203
 Begin
  Ret[RetNo].Province:='NB';
  Ret[RetNo].FrmHasdata[FNo]:=True;
 end;

 InitPrvConstants('NB');
 If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);

 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
   //20260118
   if CalcThisProvince(RetNo,'NB')=false then
   Begin
     For i:=1 to 46 do Tv[i]:=0;
     SaveTv(RetNo,FName,FNo);
     Exit;
   End;

   Tv[1]:= GetTrustTxbl(RetNo);
   //many changes 20160211  thouout the routine
   With PrvConstant[RY] do
   begin
       Ret[RetNo].Frm[FNo].Strings[42]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[43]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[44]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[66]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[65]:=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[47]:=FormatFloat('###,###',PrvBracket3);
    //20231121   Ret[RetNo].Frm[FNo].Strings[48]:=FormatFloat('###,###',PrvBracket4);
    //20231121   Ret[RetNo].Frm[FNo].Strings[84]:=FormatFloat('###,###',PrvBracket4);  //20170121
     //20170114
      // Ret[RetNo].Frm[FNo].Strings[49]:=FormatFloat('###,###',PrvBracket5);
      // Ret[RetNo].Frm[FNo].Strings[83]:=FormatFloat('###,###',PrvBracket5);

       Ret[RetNo].Frm[FNo].Strings[6]:= '0.00';
       Ret[RetNo].Frm[FNo].Strings[17]:= '0.00';  //20181209
       Tv[5]:=PrvBracket1;
       Tv[73]:=PrvBracket2;
       Tv[7]:=PrvBracket3;
     //  Tv[57]:=PrvBracket4;
     //  Tv[77]:=PrvBracket5;

       Tv[11]:= Vl(PrvConstant[RY].PrvRate1);
       Tv[12]:= Vl(PrvConstant[RY].PrvRate2);
       Tv[71]:= Vl(PrvConstant[RY].PrvRate3);
       Tv[13]:= Vl(PrvConstant[RY].PrvRate4);
     //  Tv[59]:= Vl(PrvConstant[RY].PrvRate5);
     //  Tv[79]:= Vl(PrvConstant[RY].PrvRate6);


       Tv[17]:= PrvConstant[RY].PrvBracketTax1;
       Tv[18]:= PrvConstant[RY].PrvBracketTax2;
       Tv[67]:= PrvConstant[RY].PrvBracketTax3;
       Tv[19]:= PrvConstant[RY].PrvBracketTax4;
     //  Tv[61]:= PrvConstant[RY].PrvBracketTax5;
     //  Tv[81]:= PrvConstant[RY].PrvBracketTax6;

       Tv[50]:= 19.50; //20231121//Vl(PrvConstant[RY].PrvRate6); //20160211
       Tv[51]:= PrvConstant[RY].PrvDonRate1;
       Tv[52]:= PrvConstant[RY].PrvDonRate2;
   end;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[8] := MaxR(0,Tv[2]-vl(Frm[FNo].Strings[6]));
     Tv[14] := Tv[8] * Tv[11]/100;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[9] := MaxR(0,Tv[3]-Tv[5]);
     Tv[15] := Tv[9] * Tv[12]/100;
     Tv[21] := Tv[15] + Tv[18];
   end;


   If (Tv[1] > PrvConstant[RY].PrvBracket2)
    and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[75] := Tv[1];
     Tv[72] := MaxR(0,Tv[75]-Tv[73]);
     Tv[70] := Tv[72] * Tv[71]/100;
     Tv[74] := Tv[70] + Tv[67];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket3) then
   // and (Tv[1] <= PrvConstant[RY].PrvBracket4) then
   begin
     Tv[4] := Tv[1];
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Tv[13]/100;
     Tv[22] := Tv[16] + Tv[19];
   end;

  {//20231121
    If (Tv[1] > PrvConstant[RY].PrvBracket4) then
   // and (Tv[1] <= PrvConstant[RY].PrvBracket5) then
   begin
     Tv[55] := Tv[1];
     Tv[58] := MaxR(0,Tv[55]-Tv[57]);
     Tv[60] := Tv[58] * Tv[59]/100;
     Tv[56] := Tv[60] + Tv[61];
   end;
  }
   {
   If (Tv[1] > PrvConstant[RY].PrvBracket5) then
   begin
     Tv[76] := Tv[1];
     Tv[78] := MaxR(0,Tv[76]-Tv[77]);
     Tv[80] := Tv[78] * Tv[79]/100;
     Tv[82] := Tv[80] + Tv[81];
   end;
   }

    Strings[53]:= PrvConstant[RY].PrvDivRate; //20201209
    Strings[62]:= PrvConstant[RY].PrvDivRateBig;
    if CertificationMode=True then
    Begin
      Ret[RetNo].Frm[FNo].Strings[53]:=PrvConstant[0].PrvDivRate;
      Ret[RetNo].Frm[FNo].Strings[62]:=PrvConstant[RY].PrvDivRateBig; //20180108
    End;
    Tv[54]:= PrvConstant[RY].PrvAmtCarryOverRate;

  //Tv[50]:=19.50; //20.30;  //20170114  //20231209
  If OtherThanQreAndQdt(RetNo)=True then
    Tv[23] := Tv[1]
   else
    Tv[23]:=0;

   Tv[24]:=Tv[23] * Tv[50]/100;
   Tv[25]:= Vl(FetchElm(RetNo,'S11A',15));  //20170326  Tv[25]:= Vl(FetchElm(RetNo,'S11A',15));  //20170326 Tv[25]:= Vl(FetchElm(RetNo,'S11',38));

   If Tv[25]>200 then
   begin
    Tv[27]:=200;
    Tv[29] :=MaxR(0,Tv[25]-200);
   end
   else
   begin
    Tv[27]:=Tv[25];
    Tv[29]:=0;
   end;
   Tv[26] := Tv[27] * Tv[51]/100;
   Tv[28] := Tv[29] * Tv[52]/100;
   Tv[30] := Tv[26]+Tv[28];

   If Tv[24]>0 then
     Tv[31] := Tv[24]
   else
   Begin
     Tv[31] := MaxR(MaxR(Tv[20],Tv[21]),MaxR(Tv[74],Tv[22]));
     Tv[31]:= MaxR(Tv[31],MaxR(Tv[56],Tv[82]));
   end;

   Tv[86]:=Tv[31]+Tv[85]; //20170114
   Tv[32] := Tv[30];

   Tv[64] := Vl(FetchElm(RetNo,'S8',34));
   Tv[33] := Vl(FetchElm(RetNo,'S8',35));
   Tv[63]:=Tv[64]*Tv[62]/100;
   Tv[34] := Tv[33] * Vl(Ret[RetNo].Frm[FNo].Strings[53])/100; // 20181106 Igor

   //20160211
  // Tv[65] := Vl(FetchElm(RetNo,'S8',43)); ///20141231
  //Tv[67]:=Tv[65]*Tv[66]/100;
   Tv[35] := Vl(FetchElm(RetNo,'S11',143)); //Vl(FetchElm(RetNo,'S11',43));  //20160813
   Tv[36] := Tv[35] * Tv[54]/100;

   Tv[37] := Tv[32]+Tv[63]+Tv[34]+Tv[36]; //Tv[32]+Tv[63]+Tv[34]+Tv[67]+Tv[36];  //20141231
   Tv[38] := Tv[37];
   Tv[39] := MaxR(0,Tv[86]-Tv[38]);
   If SubjectToMinTax(RetNo) then
      Tv[40]:=Vl(FetchElm(RetNo,'S12',509))
   else
      Tv[40]:=0;
   If SubjectToMinTax(RetNo) then
    Tv[41] := Tv[40]
   else
    Tv[41]:= Tv[39];
   Tv[45] := GetPrvForTaxCredit(RetNo);
   Tv[68]:=MaxR(0,Tv[41]-Tv[45]);  //20141231
   //Tv[69]=manual
   Tv[46] := MaxR(0,Tv[68] - Tv[69]);        //20141231
  end;
  SaveTv(RetNo,FName,FNo);
end;



//20260306 Igor >>>
procedure T3RCA(RetNo: Integer; FName: string; FNo: Integer);
var
  i, k: Integer;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    Strings[231] := ifAmendedPopulateInitialRevNum(RetNo,FName); //jz//20260318

    //use only one option data
    if Strings[224].Equals('') then
      for i:= 3 to 10 do
        Strings[i]:= '';

    if Strings[225].Equals('') then
      for i:= 11 to 19 do
        Strings[i]:= '';

    //Step 2 Part 1
    Tv[93]:= 0;
    i:= 59;
    repeat
      Tv[93]:= Tv[93] + Tv[i];
      Inc(i, 3);
    until i > 92;
    Tv[94]:= Tv[93] * 2;

    //Step 2 Part 2
    Tv[131]:= 0;
    i:= 97;
    repeat
      Tv[131]:= Tv[131]  +Tv[i];  //20240327
      //It used to be Tv[97]:=Tv[97]+Tv[i]; duplicating a user entry amunt each time...
      Inc(i, 3);
    until (i > 130);

    //Page 3. Step 2. Part 3
    Tv[138]:= 0;
    i:= 134;
    repeat
      Tv[138]:= Tv[138] + Tv[i];
      Inc(i, 3);
    until (i > 138);
    Tv[139]:= Tv[138]*2;

    //Page 3. Step 3
    Tv[237]:= PCPM(Tv[236], 0.50); //20260306 Igor
    Tv[238]:= MinR(Tv[238], MinR(Tv[235], Tv[237]));
    Tv[239]:= Tv[238] * 2;
    Tv[240]:= Tv[235] - Tv[238];

    //Page 3. Step 4
    Tv[141]:= TV[94];
    Tv[142]:= Tv[131];
    Tv[143]:= Tv[139];
    Tv[144]:= Tv[141] + Tv[142] + Tv[143];
    Tv[145]:= PCPM(Tv[144], 0.50); //20260306 Igor
    Tv[146]:= Tv[145];
    Tv[148]:= Tv[140] + Tv[146];
    Tv[152]:= Tv[149] + Tv[150] + Tv[151];
    Tv[156]:= Tv[153] + Tv[154] + Tv[155];
    Tv[157]:= MaxR(0, Tv[152] - Tv[156]);
    Tv[158]:= PCPM(Tv[157], 0.50); //20260306 Igor
    Tv[159]:= Tv[158];
    Tv[160]:= Tv[148] + Tv[158];

    //Page 4
    Tv[165]:= Tv[164] * 2;
    Tv[147]:= Tv[239];
    Tv[167]:= Tv[161] + Tv[162] + Tv[163] + Tv[165] + Tv[166] + Tv[147];
    TV[168]:= Tv[160];
    Tv[169]:= Tv[167];
    Tv[170]:= PCPM(Tv[169], 0.50); //20260306 Igor
    Tv[171]:= Tv[170];
    Tv[172]:= MaxR(0, Tv[168] - Tv[171]);
    Tv[173]:= Tv[172]; //20260209 Igor
    Tv[175]:= PCPM(Tv[174], 0.50); //20260306 Igor //where is 174?
    Tv[176]:= Tv[173] - Tv[175];
    Tv[184]:= MaxR(Tv[178], Tv[181]);
    Tv[185]:= MaxR(Tv[179], Tv[182]);
    Tv[186]:= MaxR(Tv[180], Tv[183]);
    Tv[187]:= Tv[184] + Tv[185] + Tv[186];
    Tv[189]:= Tv[177] + Tv[187] + Tv[188];

    //Page 5
    Tv[194]:= MaxR(Tv[172], MaxR(Tv[176], Tv[189]));
    Tv[198]:= Tv[195] - Tv[196] + Tv[197];
    Tv[199]:= Tv[198];
    Tv[200]:= Tv[194] - Tv[199];
    Tv[202]:= PCPM(Tv[201], 0.50); //20260306 Igor
    Tv[204]:= Tv[203];
    Tv[206]:= Tv[202] + Tv[204] - Tv[205];
    Tv[209]:= Tv[207] + Tv[208];
    Tv[210]:= Tv[209];
    Tv[211]:= Tv[200] + Tv[206] - Tv[210];
    Tv[212]:= MaxR(0, Tv[211]);
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20260306 Igor <<<





Procedure T3MB(RetNo:integer;FName:string;FNo:integer);
var
  i,k: integer;
  excludeElms: set of 2..24;
Begin
 if Certificationmode=True then   //20231203
 Begin
  Ret[RetNo].Province:='MB';
  Ret[RetNo].FrmHasdata[FNo]:=True;
 end;

 InitPrvConstants('MB');

 If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);
 LoadTv(RetNo,FName,FNo);

 with Ret[RetNo].Frm[FNo] do
 begin
   //20260118
   if CalcThisProvince(RetNo,'MB')=false then
   Begin
     For i:=1 to 123 do Tv[i]:=0;
     SaveTv(RetNo,FName,FNo);
     Exit;
   End;

   Tv[1]:= GetTrustTxbl(RetNo);

   With PrvConstant[RY] do
      begin
       Ret[RetNo].Frm[FNo].Strings[60]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[61]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[62]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[63]:=FormatFloat('###,###',PrvBracket2);


       //Tv[5] := 0;
       Ret[RetNo].Frm[FNo].Strings[5]:= '0.00';
       Tv[6]:=PrvBracket1;
       Tv[7]:=PrvBracket2;

       Tv[11]:= Vl(PrvConstant[RY].PrvRate1);
       Tv[12]:= Vl(PrvConstant[RY].PrvRate2);
       Tv[13]:= Vl(PrvConstant[RY].PrvRate3);

       Tv[17]:= PrvConstant[RY].PrvBracketTax1;
       Tv[18]:= PrvConstant[RY].PrvBracketTax2;
       Tv[19]:= PrvConstant[RY].PrvBracketTax3;

       //20170305
       If (OtherThanQreAndQdt(RetNo)=True) then
          Tv[54]:= Vl(PrvConstant[RY].PrvRate3)
       else
          Tv[54]:=0;

       Tv[54]:=Vl(PrvConstant[RY].PrvRate3); //20191223

       Tv[55]:= PrvConstant[RY].PrvDonRate1;
       Tv[56]:= PrvConstant[RY].PrvDonRate2;

       Ret[RetNo].Frm[FNo].Strings[57]:= PrvConstant[RY].PrvDivRate;
       Ret[RetNo].Frm[FNo].Strings[33]:= PrvConstant[RY].PrvDivRateBig; //20201209


       if CertificationMode=True then //20231203
       Begin
        Ret[RetNo].Frm[FNo].Strings[57]:= PrvConstant[RY].PrvDivRate;
        Ret[RetNo].Frm[FNo].Strings[33]:= PrvConstant[RY].PrvDivRateBig; //20201209
       end;
       Ret[RetNo].Frm[FNo].Strings[66]:= PrvConstant[RY].PrvDivRateStart2013;

       Tv[58]:= PrvConstant[RY].PrvAmtCarryOverRate;
       Tv[59]:= 10.8; {%}
     end;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin

   //jz//20260322 - with GreAndQdt brackets and OtherThanQreAndQdt, clear the amounts of consequence, leave fixed amounts
   excludeElms := [5..6,11..13,17..19];
   for i := 2 to 24 do
    if not(i in excludeElms) then
      Tv[i] := 0;

   //jz//20260322 - rearrange to make duplicate calc less likely
   If OtherThanQreAndQdt(RetNo) then
    Tv[23] := Tv[1]
   else
   begin
     If Tv[1] <= PrvConstant[RY].PrvBracket1 then
     begin
       Tv[2] := Tv[1];
       Tv[8] := MaxR(0,Tv[2]-vl(Frm[FNo].Strings[5]));
       Tv[14] := Tv[8] * Tv[11]/100;
       Tv[20] := Tv[14] + Tv[17];
     end
     else if (Tv[1] > PrvConstant[RY].PrvBracket1)
      and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
     begin
       Tv[3] := Tv[1];
       Tv[9] := MaxR(0,Tv[3]-Tv[6]);
       Tv[15] := Tv[9] * Tv[12]/100;
       Tv[21] := Tv[15] + Tv[18];
     end
     else if (Tv[1] > PrvConstant[RY].PrvBracket2) then
     begin
       Tv[4] := Tv[1];
       Tv[10] := MaxR(0,Tv[4]-Tv[7]);
       Tv[16] := Tv[10] * Tv[13]/100;
       Tv[22] := Tv[16] + Tv[19];
     end;
   end;

   Tv[24]:=Tv[23] * Tv[54]/100;
   Tv[25]:= Vl(FetchElm(RetNo,'S11',38));
   If Tv[25]>200 then
   begin
    Tv[26]:=200;
    Tv[28] :=MaxR(0,Tv[25]-200);
   end
   else
   begin
    Tv[26]:=Tv[25];
    Tv[28]:=0;
   end;
   Tv[27] := Tv[26] * Tv[55]/100;
   Tv[29] := Tv[28] * Tv[56]/100;
   Tv[30] := Tv[27]+Tv[29];

   If OtherThanQreAndQdt(RetNo)=True then
     Tv[31] := Tv[24]
   else
     Tv[31] := MaxR(MaxR(Tv[20],Tv[21]),Tv[22]);

  // Tv[66]:=Tv[31]+Tv[65];  //20170113  //20231121
  {Tv[32] := Tv[30];}
   Tv[35] := Vl(FetchElm(RetNo,'S8',34));
   Tv[37] := Vl(FetchElm(RetNo,'S8',35));
  // Tv[65] := Vl(FetchElm(RetNo,'S8',43)); //20231121  //20141231
   Tv[66]:= Tv[31] + Tv[65]; //20260216 Igor
   Tv[34] := Tv[35] * Vl(Ret[RetNo].Frm[FNo].Strings[33])/100;
   Tv[38] := Tv[37] * Vl(Ret[RetNo].Frm[FNo].Strings[57])/100;
   Tv[67] := Tv[65] * Vl(Ret[RetNo].Frm[FNo].Strings[66])/100;
   //Tv[67] := Tv[65] * Vl(Ret[RetNo].Frm[FNo].Strings[57])/100;

   Tv[39] := Vl(FetchElm(RetNo,'S11',143)); //Vl(FetchElm(RetNo,'S11',43));  //20160813
   Tv[40] := Tv[39] * Tv[58]/100;

   ////jz2025update-rev1: family tax ben box 14120 removed
   {
   //20180227
   Tv[41]:= MaxR(0,2065-(GetTrustNetIncome(RetNo) *9/100));
   if Certificationmode=True then Tv[41]:=0; //20230212
   Tv[59]:=10.8;
   Tv[42] := Tv[41]* Tv[59]/100;
   }

   if Certificationmode=True then Tv[42]:=0; //20230212
   if Ret[RetNo].Province <> 'MB' then Tv[42]:=0;
   //If CertificationMode then Begin Tv[41]:=0; Tv[42]:=0;end;  //20120216
   If Tv[41]<0 then Tv[42]:=0;
   Tv[64]:=MaxR(0,Tv[31]-Tv[42]);//20231121 //MaxR(0,Tv[66]-Tv[42]);
   Tv[36]:=Tv[30];
   Tv[43] := Tv[36]+Tv[34]+Tv[38]+Tv[67]+Tv[40]; //20141231
   Tv[44] := Tv[43];
   Tv[45]:= MaxR(0, Tv[66] - Tv[44]); //20260216 Igor //MaxR(0,Tv[64]-Tv[44]);
   If SubjectToMinTax(RetNo) then
    Tv[46] :=  Vl(FetchElm(RetNo,'S12',518))
   else
    Tv[46]:=0;
   Tv[47] := Tv[45]+Tv[46];
   Tv[50] := GetPrvForTaxCredit(RetNo);
   Tv[48] :=Vl(FetchElm(RetNo,'POLIT',102));
   Tv[49]:=CalcPolitCredit('MB',Tv[48]);
   Tv[51] := Tv[49]+Tv[50];
   Tv[52] := Tv[51];
   Tv[53] := MaxR(0,Tv[47] - Tv[52]);
 end;

  //instructions
  With Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
   Frm[FNo].Strings[103]:= '0.00';
   Tv[110]:=400;
   Tv[114]:=300;
   Tv[117]:=750;
   Tv[121]:=475;
   Tv[123]:=1000; //650; //20181207
  end;

 StoreElm(RetNo,FNo,17,'0.00'); //20180226
 StoreElm(RetNo,FNo,107,'0.00'); //20180226
 SaveTv(RetNo,FName,FNo);
end;

Procedure T3AB(RetNo:integer;FName:string;FNo:integer);
Var i:integer;x,y,z:real;s:string;
Begin
 if Certificationmode=True then   //20231203
 Begin
  Ret[RetNo].Province:='AB';
  Ret[RetNo].FrmHasdata[FNo]:=True;
 end;

 InitPrvConstants('AB');
 If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);

 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
   //20260118
   if CalcThisProvince(RetNo,'AB')=false then
   Begin
     For i:=1 to 98 do Tv[i]:=0;
     SaveTv(RetNo,FName,FNo);
     Exit;
   End;

   Tv[1]:= GetTrustTxbl(RetNo);

   With PrvConstant[RY] do
      begin
       Ret[RetNo].Frm[FNo].Strings[02]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[03]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[13]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[14]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[64]:=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[65]:=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[66]:=FormatFloat('###,###',PrvBracket4);
       Ret[RetNo].Frm[FNo].Strings[63]:=FormatFloat('###,###',PrvBracket4);
       Ret[RetNo].Frm[FNo].Strings[67]:=FormatFloat('###,###',PrvBracket5); //jz2025update-rev1:new bracket as per form
       Ret[RetNo].Frm[FNo].Strings[68]:=FormatFloat('###,###',PrvBracket5);

       Ret[RetNo].Frm[FNo].Strings[43]:= '0.00';
       Ret[RetNo].Frm[FNo].Strings[74]:= '0.00';
       Tv[75]:=PrvBracket2;
       Tv[76]:=PrvBracket3;
       Tv[77]:=PrvBracket4;
       Tv[78]:=PrvBracket5;

       Tv[45]:= Vl(PrvRate1);
       Tv[84]:= Vl(PrvRate2);
       Tv[85]:= Vl(PrvRate3);
       Tv[86]:= Vl(PrvRate4);
       Tv[87]:= Vl(PrvRate5);
       Tv[88]:= Vl(PrvRate6);

       Ret[RetNo].Frm[FNo].Strings[47]:= FormatFloat('00.00',PrvBracketTax1);
       Tv[94]:= PrvBracketTax2;
       Tv[95]:= PrvBracketTax3;
       Tv[96]:= PrvBracketTax4;
       Tv[97]:= PrvBracketTax5;
       Tv[98]:= PrvBracketTax6;


       //jz2025update-rev1: -- where are these??
       Tv[57]:= Vl(PrvRate5); //PrvConstant[RY].PrvIntervivosRate;
       Tv[58]:= PrvDonRate1;
       Tv[59]:= PrvDonRate2;
     end;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   If Tv[1] <= PrvConstant[RY].PrvBracket1 then //jz2025update-rev1:new bracket as per form
   begin
     Tv[42] := Tv[1];
     Tv[44] := MaxR(0,Tv[42]-vl(Frm[FNo].Strings[43]));
     Tv[46] := Tv[44] * Tv[45]/100;
     Tv[48] := Tv[46] + Tv[47];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[69] := Tv[1];
     Tv[79] := MaxR(0,Tv[69]-vl(Frm[FNo].Strings[74]));
     Tv[89] := Tv[79] * Tv[84]/100;
     Tv[99] := Tv[89] + Tv[94];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
   and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[70] := Tv[1];
     Tv[80] := MaxR(0,Tv[70]-Tv[75]);
     Tv[90] := Tv[80] * Tv[85]/100;
     Tv[100] := Tv[90] + Tv[95];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket3)
   and (Tv[1] <= PrvConstant[RY].PrvBracket4) then
   begin
     Tv[71] := Tv[1];
     Tv[81] := MaxR(0,Tv[71]-Tv[76]);
     Tv[91] := Tv[81] * Tv[86]/100;
     Tv[10] := Tv[91] + Tv[96];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket4)
   and (Tv[1] <= PrvConstant[RY].PrvBracket5) then
   begin
     Tv[72] := Tv[1];
     Tv[82] := MaxR(0,Tv[72]-Tv[77]);
     Tv[92] := Tv[82] * Tv[87]/100;
     Tv[11] := Tv[92] + Tv[97];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket5) then
   begin
     Tv[73] := Tv[1];
     Tv[83] := MaxR(0,Tv[73]-Tv[78]);
     Tv[93] := Tv[83] * Tv[88]/100;
     Tv[12] := Tv[93] + Tv[98];
   end;


   Tv[23] := Tv[1];

   If OtherThanQreAndQdt(RetNo)=True then Tv[24]:=Tv[23] * 15/100; //20160209  //20170305
    //If IsIntervivos(RetNo) then Tv[24]:=Tv[23] * 11.25/100; //20160209
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
  Tv[58]:= PrvConstant[RY].PrvDonRate1;
  Tv[21]:=21;

  Tv[61]:= PrvConstant[RY].PrvAmtCarryOverRate;

  Tv[25]:= Vl(FetchElm(RetNo,'S11A',15));  //20170326 Tv[25]:= Vl(FetchElm(RetNo,'S11',38));

   If Tv[25]>200 then
   begin
    Tv[26]:=200;
    Tv[28] :=MaxR(0,Tv[25]-200);
   end
   else
   begin
    Tv[26]:=Tv[25];
    Tv[28]:=0;
   end;

   Tv[27] := Tv[26] * Tv[58]/100;  //ab
   Tv[22] := Tv[28] * Tv[21]/100; //20231212 jz
  //Tv[22] := Tv[28] * Tv[58]/100;

   Tv[18] := Tv[27] + Tv[22];


   If Tv[24]>0 then ////jz2025update-rev1: this if and the below If (OtherThanQreAndQdt(RetNo)=True) seem redundant
     Tv[31]:=Tv[24]
   Else
   begin
     Tv[31] :=MaxR(Tv[48],Tv[99]);                  //jz2025update-rev1: added new bracket
     Tv[31] :=MaxR(Tv[31],MaxR(Tv[100],Tv[10]));
     Tv[31] :=MaxR(Tv[31],MaxR(Tv[11],Tv[12]));
   end;

   If (OtherThanQreAndQdt(RetNo)=True) then Tv[31]:=Tv[24];  //20211212 //jz2025update-rev1: should this be the if above??
   Tv[16]:=Tv[31]+Tv[15];




   Tv[32] := tv[18];  //Tv[31];  //20120218
   Tv[9] := Vl(FetchElm(RetNo,'S8',34));
   Tv[33] := Vl(FetchElm(RetNo,'S8',35));
   Tv[13]:= Vl(FetchElm(RetNo,'S8',43));  //20141231

   Strings[60]:= PrvConstant[RY].PrvDivRate;
   Strings[7]:=PrvConstant[RY].PrvDivRateBig;

   if CertificationMode=True then
   Begin
    s:=PrvConstant[RY].PrvDivRate;  //temp for test
    Strings[60]:=PrvConstant[RY].PrvDivRate;
    Strings[7]:=PrvConstant[RY].PrvDivRateBig; //20180108
   End;
   Tv[8] := Tv[9] * Vl(Strings[7])/100;
   Tv[34] := Tv[33] * Vl(Strings[60])/100;

   Tv[35] := Vl(FetchElm(RetNo,'S11',143)); //Vl(FetchElm(RetNo,'S11',43));  //20160813
   Tv[36] := Tv[35] * Tv[61]/100;

   Tv[37] := Tv[32]+Tv[8]+Tv[34]+Tv[36];  //20141231
   Tv[38] := Tv[37];
   Tv[39] := MaxR(0,Tv[16]-Tv[38]);  //20170113
   If SubjectToMinTax(RetNo) then
    Tv[40] :=  Vl(FetchElm(RetNo,'S12',533))
   else
    Tv[40]:=0;
   Tv[41]:=Tv[39]+Tv[40]; //20120807

   Tv[51] := GetPrvForTaxCredit(RetNo);

   // 20181106 Igor >>>
   {Tv[44] :=Vl(FetchElm(RetNo,'POLIT',35))+Vl(FetchElm(RetNo,'POLIT',38))
            +Vl(FetchElm(RetNo,'POLIT',41));
   Tv[3]:=MinR(1000,CalcPolitCredit('AB',Tv[44]));//Tv[45]:=CalcPolitCredit('AB',Tv[44]); //20100225
   Tv[2]:=Vl(FetchElm(RetNo,'POLIT',143)); //senatorial  //20170106
   Tv[5]:=MinR(1000,CalcPolitCredit('AB',Tv[44])); //Tv[143]));  //20170106
   Tv[6]:=Tv[3]+Tv[5];
   Tv[45]:=Tv[6];
  //20170106
   Tv[17]:=Tv[45];
   Tv[46]:=Tv[51]+Tv[45];
   Tv[52]:=Tv[46]; }
   Tv[56]:=MaxR(0,Tv[41]-Tv[51]);  //20170113
   // 20181106 Igor <<<

   {
   Tv[19]:=Vl(FetchElm(RetNo,'PRVCR',6));
   Tv[20]:=Tv[19]*10/100;
   Tv[2]:=Tv[20];
   Tv[46] := Tv[51]+Tv[45]+Tv[2];
   Tv[52] := Tv[46];
   Tv[56] := MaxR(0,Tv[41] - Tv[52]);
   }
   //Instructions
   Frm[FNo].Strings[103] := '0.00';
   Tv[110]:=200;
   Tv[114]:=150;
   Tv[117]:=1100;
   Tv[121]:=600;
   Tv[123]:=1000;
 end;
 SaveTv(RetNo,FName,FNo);
end;


Procedure T3NL(RetNo:integer;FName:string;FNo:integer);
Var i:integer;x,y,z:real;
Begin
 if Certificationmode=True then   //20231203
 Begin
  Ret[RetNo].Province:='NL';
  Ret[RetNo].FrmHasdata[FNo]:=True;
 end;

 InitPrvConstants('NL');
 If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
   For i:=12 to 20  do Tv[i]:=0;  //20240329 //last 3 columns
   For i:=49 to 54  do Tv[i]:=0;  //20240329 //last 3 columns
   For i:=69 to 104 do Tv[i]:=0;  //20240329 //20160321 //20160505 Igor

   //20260118
   if CalcThisProvince(RetNo,'NL')=false then //MJjz2024//if Ret[RetNo].Province <> 'NL' then  //20150101
   Begin
     For i:=1 to 103 do Tv[i]:=0;
     SaveTv(RetNo,FName,FNo);
     Exit;
   End;
   (*   //20260118
   if not CalcThisProvince(RetNo,'NL') then //MJjz2024//if Ret[RetNo].Province <> 'NL' then  //20150101
   Begin
    if Certificationmode=False then  //20211205
    Begin
     For i:=1 to 103 do Tv[i]:=0;
     SaveTv(RetNo,FName,FNo);
     Exit;
    end;  //20150101
   end;
  *)
   //20160208
   Tv[1]:= GetTrustTxbl(RetNo);
   xx:=Tv[1];

   With PrvConstant[RY] do
      begin
       Ret[RetNo].Frm[FNo].Strings[2]:=FormatFloat('###,###',PrvBracket1);

       Ret[RetNo].Frm[FNo].Strings[3] :=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[64]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[65]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[66]:=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[63]:=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[67]:=FormatFloat('###,###',PrvBracket4);
       Ret[RetNo].Frm[FNo].Strings[68]:=FormatFloat('###,###',PrvBracket4);

       //jz2022
       //New begin ---------------------------------------------------------------
       Ret[RetNo].Frm[FNo].Strings[6] :=FormatFloat('###,###',PrvBracket5);
       Ret[RetNo].Frm[FNo].Strings[7] :=FormatFloat('###,###',PrvBracket5);
       Ret[RetNo].Frm[FNo].Strings[8] :=FormatFloat('###,###',PrvBracket6);
       Ret[RetNo].Frm[FNo].Strings[9] :=FormatFloat('###,###',PrvBracket6);
       Ret[RetNo].Frm[FNo].Strings[10]:=FormatFloat('###,###',PrvBracket7);
       Ret[RetNo].Frm[FNo].Strings[11]:=FormatFloat('###,###',PrvBracket7);
       //New end -----------------------------------------------------------------

       //showmessage (FormatFloat('###,###',PrvBracket4) + ' ' + FormatFloat('###,###',PrvBracket5) + ' ' + FormatFloat('###,###',PrvBracket6) + ' ' +  FormatFloat('###,###',PrvBracket7) );

       Ret[RetNo].Frm[FNo].Strings[74]:= '0.00';
       Ret[RetNo].Frm[FNo].Strings[94]:= '0.00';
       Tv[75]:=PrvBracket1;
       Tv[76]:=PrvBracket2;
       Tv[77]:=PrvBracket3;
       Tv[78]:=PrvBracket4;

       //jz2022
       //New begin ---------------------------------------------------------------
       Tv[15]:=PrvBracket5;
       Tv[16]:=PrvBracket6;
       Tv[17]:=PrvBracket7;
       //New end -----------------------------------------------------------------



       Tv[84]:= Vl(PrvConstant[RY].PrvRate1);
       Tv[85]:= Vl(PrvConstant[RY].PrvRate2);
       Tv[86]:= Vl(PrvConstant[RY].PrvRate3);
       Tv[87]:= Vl(PrvConstant[RY].PrvRate4);
       Tv[88]:= Vl(PrvConstant[RY].PrvRate5);

       //jz2022
       //New begin ---------------------------------------------------------------
       Tv[45]:= Vl(PrvConstant[RY].PrvRate6);
       Tv[46]:= Vl(PrvConstant[RY].PrvRate7);
       Tv[48]:= Vl(PrvConstant[RY].PrvRate8);
       //New end -----------------------------------------------------------------


       Tv[94]:= PrvConstant[RY].PrvBracketTax1;
       Tv[95]:= PrvConstant[RY].PrvBracketTax2;
       Tv[96]:= PrvConstant[RY].PrvBracketTax3;
       Tv[97]:= PrvConstant[RY].PrvBracketTax4;
       Tv[98]:= PrvConstant[RY].PrvBracketTax5;

       //jz2022
       //New begin ---------------------------------------------------------------
       Tv[52]:= PrvConstant[RY].PrvBracketTax6;
       Tv[53]:= PrvConstant[RY].PrvBracketTax7;
       Tv[54]:= PrvConstant[RY].PrvBracketTax8;
       //New end -----------------------------------------------------------------

       Tv[57]:= Vl(PrvConstant[RY].PrvRate8);  //jz2022
       Tv[58]:= PrvConstant[RY].PrvDonRate1;
       Tv[59]:= PrvConstant[RY].PrvDonRate2;

     end;
  end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin

   If OtherThanQreAndQdt(RetNo)=false then   //20240329
   begin

     If Tv[1] <= PrvConstant[RY].PrvBracket1 then
     begin
       Tv[69] := Tv[1];
       Tv[79] := MaxR(0,Tv[69]-vl(Frm[FNo].Strings[74]));
       Tv[89] := Tv[79] * Tv[84]/100;
       Tv[99] := Tv[89] + Tv[94];
     end;

     If (Tv[1] > PrvConstant[RY].PrvBracket1)
      and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
     begin
       Tv[70] := Tv[1];
       Tv[80] := MaxR(0,Tv[70]-Tv[75]);
       Tv[90] := Tv[80] * Tv[85]/100;
       Tv[100] := Tv[90] + Tv[95];
     end;

     If (Tv[1] > PrvConstant[RY].PrvBracket2)
     and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
     begin
       Tv[71] := Tv[1];
       Tv[81] := MaxR(0,Tv[71]-Tv[76]);
       Tv[91] := Tv[81] * Tv[86]/100;         //20250325
       Tv[101] := Tv[91] + Tv[96];
     end;

     If (Tv[1] > PrvConstant[RY].PrvBracket3)
     and (Tv[1] <= PrvConstant[RY].PrvBracket4) then
     begin
       Tv[72] := Tv[1];
       Tv[82] := MaxR(0,Tv[72]-Tv[77]);
       Tv[92] := Tv[82] * Tv[87]/100;
       Tv[102] := Tv[92] + Tv[97];
     end;


     If (Tv[1] > PrvConstant[RY].PrvBracket4)
     and (Tv[1] <= PrvConstant[RY].PrvBracket5) then //new jz2022
     begin
       Tv[73] := Tv[1];
       Tv[83] := MaxR(0,Tv[73]-Tv[78]);
       Tv[93] := Tv[83] * Tv[88]/100;
       Tv[103] := Tv[93] + Tv[98];
     end;


     //jz2022
     //New begin ---------------------------------------------------------------
     If (Tv[1] > PrvConstant[RY].PrvBracket5)
     and (Tv[1] <= PrvConstant[RY].PrvBracket6) then
     begin
       Tv[12] := Tv[1];
       Tv[18] := MaxR(0,Tv[12]-Tv[15]);
       Tv[49] := Tv[18] * Tv[45]/100;
       Tv[55] := Tv[49] + Tv[52];
     end;

     If (Tv[1] > PrvConstant[RY].PrvBracket6)
     and (Tv[1] <= PrvConstant[RY].PrvBracket7) then //20240329
     begin
       Tv[13] := Tv[1];
       Tv[19] := MaxR(0,Tv[13]-Tv[16]);
       Tv[50] := Tv[19] * Tv[46]/100;
       Tv[62] := Tv[50] + Tv[53];
     end;

     If (Tv[1] > PrvConstant[RY].PrvBracket7) then //20240329
     begin
       Tv[14]  := Tv[1];
       Tv[20]  := MaxR(0,Tv[14]-Tv[17]);
       Tv[51]  := Tv[20] * Tv[48]/100;
       Tv[104] := Tv[51] + Tv[54];
     end;

     //New end -----------------------------------------------------------------


   end;

   Tv[61]:= PrvConstant[RY].PrvAmtCarryOverRate;

   If OtherThanQreAndQdt(RetNo)=True then
    Tv[23] := Tv[1]
   else
    Tv[23]:=0;
   Tv[24]:=Tv[23] * Tv[57]/100;

   Tv[25]:=Vl(FetchElm(RetNo,'S11A',15)); //20211217 //Vl(FetchElm(RetNo,'S11',38));
   If Tv[25]>200 then
   begin
    Tv[26]:=200;
    Tv[28] :=MaxR(0,Tv[25]-200);
   end
   else
   begin
    Tv[26]:=Tv[25];
    Tv[28]:=0;
   end;
   Tv[27] := Tv[26] * Tv[58]/100;
   Tv[29] := Tv[28] * Tv[59]/100;
   Tv[30] := Tv[27]+Tv[29];
   If OtherThanQreAndQdt(RetNo)=True then
     Tv[31] := Tv[24]
   else
   begin
     Tv[31] := MaxR(MaxR(Tv[99],MaxR(Tv[100],Tv[101])),(MaxR(Tv[102],Tv[103])));
     Tv[31] := MaxR( Tv[31], MaxR( Tv[55], MaxR( Tv[62],Tv[104]))); //20240329
   end;



   Tv[5]:=Tv[31]+Tv[4]; //20170114
   Tv[32] := Tv[30];


   Tv[42]:=Vl(FetchElm(RetNo,'S8',34));

   //20221128
   Ret[RetNo].Frm[FNo].Strings[44]:= PrvConstant[RY].PrvDivRateBig; //20231210 //FormatFloat('##.####',22.879); //Tv[44]:= 19.61;;
   Tv[47]:= Tv[42] * Vl(Ret[RetNo].Frm[FNo].Strings[44])/100;  //Tv[44]/100;

   // 20181106 Igor >>>
   {Tv[50]:= 28.22;
   Tv[51]:=TV[49]*Tv[50]/100;}


   Tv[33] := MaxR(0,Vl(FetchElm(RetNo,'S8',35)){-Tv[49]});  //20180108
   //Tv[60]:= 24.09;
   //20191206
   Ret[RetNo].Frm[FNo].Strings[60]:= PrvConstant[0].PrvDivRate; //20231210  //gFormatFloat('##.####',24.533); //20221128 //26.833
   Tv[34] := Tv[33] * Vl(Ret[RetNo].Frm[FNo].Strings[60])/100;
   Tv[35] :=   Vl(FetchElm(RetNo,'S11',143)); // Vl(FetchElm(RetNo,'S11',43));  //20160813
   Tv[61]:=58; //20180107 54.7;   //20170114
   Tv[36] := Tv[35] * Tv[61]/100;

   Tv[37] := Tv[32]+Tv[47]+{Tv[51]+}Tv[34]+Tv[36];  //20170119
   // 20181106 Igor <<<
   Tv[38] := Tv[37];
   Tv[39] := MaxR(0,Tv[5]-Tv[38]);
   If SubjectToMinTax(RetNo) then
    Tv[40] :=  Vl(FetchElm(RetNo,'S12',503))
   else
    Tv[40]:=0;
   Tv[41] := Tv[39]+Tv[40];

   //Tv[44]:=Tv[41];   //+Tv[42]; 20110201

   Tv[43] := GetPrvForTaxCredit(RetNo);
   Tv[56] := MaxR(0,Tv[41] - Tv[43]); //MaxR(0,Tv[44] - Tv[43]); //20150210
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure T3NU(RetNo:integer;FName:string;FNo:integer);
Var i:integer;x,y,z:real;
Begin
 if Certificationmode=True then   //20231203
 Begin
  Ret[RetNo].Province:='NU';
  Ret[RetNo].FrmHasdata[FNo]:=True;
 end;

 InitPrvConstants('NU');
 If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
   //20260118
   if CalcThisProvince(RetNo,'NU')=false then
   Begin
     For i:=1 to 116 do Tv[i]:=0;
     SaveTv(RetNo,FName,FNo);
     Exit;
   End;

   Tv[1]:= GetTrustTxbl(RetNo);

   With PrvConstant[RY] do
      begin
       Ret[RetNo].Frm[FNo].Strings[47]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[48]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[49]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[50]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[51]:=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[52]:=FormatFloat('###,###',PrvBracket3);


       //Tv[5] := 0;
       Ret[RetNo].Frm[FNo].Strings[5]:= '0.00';
       Tv[6]:=PrvBracket1;
       Tv[7]:=PrvBracket2;
       Tv[57]:=PrvBracket3;

       Tv[11]:= Vl(PrvConstant[RY].PrvRate1);
       Tv[12]:= Vl(PrvConstant[RY].PrvRate2);
       Tv[13]:= Vl(PrvConstant[RY].PrvRate3);
       Tv[59]:= Vl(PrvConstant[RY].PrvRate4);

       Tv[17]:= PrvConstant[RY].PrvBracketTax1;
       Tv[18]:= PrvConstant[RY].PrvBracketTax2;
       Tv[19]:= PrvConstant[RY].PrvBracketTax3;
       Tv[61]:= PrvConstant[RY].PrvBracketTax4;

       Tv[63]:= Vl(PrvConstant[RY].PrvRate4); //PrvConstant[RY].PrvIntervivosRate;
       Tv[64]:= PrvConstant[RY].PrvDonRate1;
       Tv[65]:= PrvConstant[RY].PrvDonRate2;
       Strings[66]:= PrvConstant[RY].PrvDivRate;
       Strings[68]:= PrvConstant[RY].PrvDivRateBig;

       if CertificationMode=True then
       Begin
         Ret[RetNo].Frm[FNo].Strings[66]:=PrvConstant[0].PrvDivRate;
         Ret[RetNo].Frm[FNo].Strings[68]:=PrvConstant[RY].PrvDivRateBig; //20180108
       End;

       Tv[67]:= PrvConstant[RY].PrvAmtCarryOverRate;
     end;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[8] := MaxR(0,Tv[2]-vl(Frm[FNo].Strings[5]));
     Tv[14] := Tv[8] * Tv[11]/100;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Tv[12]/100;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
    and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[4] := Tv[1];
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Tv[13]/100;
     Tv[22] := Tv[16] + Tv[19];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket3) then
   begin
     Tv[55] := Tv[1];
     Tv[58] := MaxR(0,Tv[55]-Tv[57]);
     Tv[60] := Tv[58] * Tv[59]/100;
     Tv[56] := Tv[60] + Tv[61];
   end;

   If OtherThanQreAndQdt(RetNo)=True then
    Tv[23] := Tv[1]
   else
    Tv[23]:=0;
   Tv[24]:=Tv[23] * Tv[63]/100;
   Tv[25]:= Vl(FetchElm(RetNo,'S11A',15));  //20170326  Tv[25]:= Vl(FetchElm(RetNo,'S11',38));
   If Tv[25]>200 then
   begin
    Tv[27]:=200;
    Tv[29] :=MaxR(0,Tv[25]-200);
   end
   else
   begin
    Tv[27]:=Tv[25];
    Tv[29]:=0;
   end;
   Tv[26] := Tv[27] * Tv[64]/100;
   Tv[28] := Tv[29] * Tv[65]/100;
   Tv[30] := Tv[26]+Tv[28];

   If OtherThanQreAndQdt(RetNo)=True then
     Tv[31] := Tv[24]
   else
     Tv[31] := MaxR(MaxR(Tv[20],Tv[21]),MaxR(Tv[22],Tv[56]));

   Tv[32] := Tv[30];

   Tv[70] := Vl(FetchElm(RetNo,'S8',34));
   Tv[33] := Vl(FetchElm(RetNo,'S8',35))+Vl(FetchElm(RetNo,'S8',43)); //20141231
   Tv[69] := Tv[70] * Tv[68]/100;
   Tv[34] := Tv[33] * Tv[66]/100;

   Tv[35] :=  Vl(FetchElm(RetNo,'S11',143));  //20160813
   Tv[36] := Tv[35] * Tv[67]/100;

   Tv[37] := Tv[32]+Tv[69]+Tv[34]+Tv[36];
   Tv[38] := Tv[37];
   Tv[39] := MaxR(0,Tv[31]-Tv[38]);
   If SubjectToMinTax(RetNo) then
    Tv[40] :=  Vl(FetchElm(RetNo,'S12',539))
   else
    Tv[40]:=0;
   Tv[41]:=Tv[39]+Tv[40];
   {
   If SubjectToMinTax(RetNo) then
    Tv[41] := Tv[40]
   else
    Tv[41]:= Tv[39];
   }
   Tv[45] := GetPrvForTaxCredit(RetNo);
   Tv[42] :=Vl(FetchElm(RetNo,'POLIT',130));
   Tv[43]:=CalcPolitCredit('NU',Tv[42]);
   Tv[54] := Tv[45]+Tv[43]; //+Tv[44]; 20120212
   Tv[62] := Tv[54];
   Tv[46] := MaxR(0,Tv[41] - Tv[62]);

   Tv[110]:=400;
   Tv[114]:=300;
   Tv[117]:=750;
   Tv[121]:=475;
   Tv[123]:=650;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
  Frm[FNo].Strings[103]:= '0.00';
  Tv[110]:=100;
  Tv[114]:=100;
  Tv[116]:=500;
 end;

 StoreElm(RetNo,FNo,17,'0.00'); //20180226
 StoreElm(RetNo,FNo,107,'0.00'); //20180226
 SaveTv(RetNo,FName,FNo);

end;

Procedure T3PE(RetNo:integer;FName:string;FNo:integer);
Var i:integer;x,y,z:real;
Begin
 if Certificationmode=True then   //20231203
 Begin
  Ret[RetNo].Province:='PE';
  Ret[RetNo].FrmHasdata[FNo]:=True;
 end;
 InitPrvConstants('PE');
 If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);

 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
   //20260118
   if CalcThisProvince(RetNo,'PE')=false then
   Begin
     For i:=1 to 81 do Tv[i]:=0;
     SaveTv(RetNo,FName,FNo);
     Exit;
   End;

   Tv[1]:= GetTrustTxbl(RetNo);


   With PrvConstant[RY] do
      begin
       Ret[RetNo].Frm[FNo].Strings[66]:=FormatFloat('###,###',PrvBracket1);

       Ret[RetNo].Frm[FNo].Strings[67]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[68]:=FormatFloat('###,###',PrvBracket2);

       Ret[RetNo].Frm[FNo].Strings[69]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[63]:=FormatFloat('###,###',PrvBracket3);

       //20250226
       Ret[RetNo].Frm[FNo].Strings[48]:=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[64]:=FormatFloat('###,###',PrvBracket4);

       Ret[RetNo].Frm[FNo].Strings[48]:=FormatFloat('###,###',PrvBracket4); //20261006 Alex
       Ret[RetNo].Frm[FNo].Strings[64]:=FormatFloat('###,###',PrvBracket5); //20261006 Alex

       Ret[RetNo].Frm[FNo].Strings[62]:=FormatFloat('###,###',PrvBracket5); //20261006 Alex

       Ret[RetNo].Frm[FNo].Strings[5]:= '0.00';
       Tv[6]:=PrvBracket1;
       Tv[7]:=PrvBracket2;
       Tv[71]:=PrvBracket3;
       Tv[52]:=PrvBracket4; //20261006 Alex
       Tv[77]:=PrvBracket5; //20261006 Alex

       Tv[11]:= Vl(PrvConstant[RY].PrvRate1);
       Tv[12]:= Vl(PrvConstant[RY].PrvRate2);
       Tv[13]:= Vl(PrvConstant[RY].PrvRate3);
       Tv[73]:= Vl(PrvConstant[RY].PrvRate4);
       Tv[65]:= Vl(PrvConstant[RY].PrvRate5); //20261006 Alex
       Tv[79]:= Vl(PrvConstant[RY].PrvRate6); //20261006 Alex

       Tv[17]:= PrvConstant[RY].PrvBracketTax1;
       Tv[18]:= PrvConstant[RY].PrvBracketTax2;
       Tv[19]:= PrvConstant[RY].PrvBracketTax3;
       Tv[75]:= PrvConstant[RY].PrvBracketTax4;
       Tv[83]:= PrvConstant[RY].PrvBracketTax5; //20261006 Alex
       Tv[81]:= PrvConstant[RY].PrvBracketTax6; //20261006 Alex

       Tv[57]:= Vl(PrvConstant[RY].PrvRate5); //jz//20250731 //Vl(PrvConstant[RY].PrvRate3); //PrvConstant[RY].PrvIntervivosRate;
       Tv[58]:= PrvConstant[RY].PrvDonRate1;
       Tv[59]:= PrvConstant[RY].PrvDonRate2;

       Strings[60]:= PrvConstant[RY].PrvDivRate;
       Strings[49]:= PrvConstant[RY].PrvDivRateBig;
       Strings[55]:= PrvConstant[RY].PrvDivRateStart2013;

       if CertificationMode=True then
       Begin
         Ret[RetNo].Frm[FNo].Strings[60]:=PrvConstant[0].PrvDivRate;
         Ret[RetNo].Frm[FNo].Strings[49]:=PrvConstant[RY].PrvDivRateBig; //20180108
       End;

       Tv[61]:= PrvConstant[RY].PrvAmtCarryOverRate;

     end;
  end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[8] := MaxR(0,Tv[2]-vl(Frm[FNo].Strings[5]));
     Tv[14] := Tv[8] * Tv[11]/100;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Tv[12]/100;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
   and (Tv[1] <= PrvConstant[RY].PrvBracket3)
   then
   begin
     Tv[4] := Tv[1];
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Tv[13]/100;
     Tv[22] := Tv[16] + Tv[19];
   end;
   //20250226
   If (Tv[1] > PrvConstant[RY].PrvBracket3)
   and (Tv[1] <= PrvConstant[RY].PrvBracket4)
   then
   begin
     Tv[70] := Tv[1];
     Tv[72] := MaxR(0,Tv[70]-Tv[71]);
     Tv[74] := Tv[72] * Tv[73]/100;
     Tv[45] := Tv[74] + Tv[75];
   end;

   //20261006 Alex >>>
   if (Tv[1] > PrvConstant[RY].PrvBracket4) and (Tv[1] <= PrvConstant[RY].PrvBracket5) then
   begin
     Tv[51]:= Tv[1];
     Tv[56]:= MaxR(0, Tv[51] - Tv[52]);
     Tv[82]:= Tv[56] * Tv[65] / 100;
     Tv[84]:= Tv[82] + Tv[83];
   end;
   //20261006 Alex <<<

   If (Tv[1] > PrvConstant[RY].PrvBracket5) //20261006 Alex
   then
   begin
     Tv[76] := Tv[1];
     Tv[78] := MaxR(0,Tv[76]-Tv[77]);
     Tv[80] := Tv[78] * Tv[79]/100;
     Tv[46] := Tv[80] + Tv[81];
   end;
   // end of
   If OtherThanQreAndQdt(RetNo)=True then
    Tv[23] := Tv[1]
   else
    Tv[23]:=0;
   Tv[24]:=Tv[23] * Tv[57]/100;
   Tv[25]:= Vl(FetchElm(RetNo,'S11A',15));  //20170326 //Tv[25]:= Vl(FetchElm(RetNo,'S11',38));
   If Tv[25]>200 then
   begin
    Tv[26]:=200;
    Tv[28] :=MaxR(0,Tv[25]-200);
   end
   else
   begin
    Tv[26]:=Tv[25];
    Tv[28]:=0;
   end;
   Tv[27] := Tv[26] * Tv[58]/100;
   Tv[29] := Tv[28] * Tv[59]/100;
   Tv[30] := Tv[27]+Tv[29];

   If OtherThanQreAndQdt(RetNo)=True then
     Tv[31] := Tv[24]
   else
   Begin  //20250526
     Tv[31]:= MaxR(MaxR(Tv[20],Tv[21]),Tv[22]);
     Tv[31]:= MaxR(Tv[31], MaxR(Tv[45], MaxR(Tv[84], Tv[46]))); //20261006 Alex
   End;

   Tv[55]:=Tv[31]+Tv[54];

   Tv[32] := Tv[30];
   Tv[53] := Vl(FetchElm(RetNo,'S8',34));
   Tv[33] := Vl(FetchElm(RetNo,'S8',35));
   Tv[54] := Vl(FetchElm(RetNo,'S8',43));  //20141231
   Tv[50] := Tv[53] * Tv[49]/100;
   Tv[34] := Tv[33] * Tv[60]/100;
   Tv[62] := Tv[54] * Tv[55]/100;
   Tv[35] :=  Vl(FetchElm(RetNo,'S11',143));  //20160813
   Tv[36] := Tv[35] * Tv[61]/100;

   Tv[37] := Tv[32]+Tv[50]+Tv[34]+Tv[62]+Tv[36];  //20141231
   Tv[38] := Tv[37];
   Tv[39] := MaxR(0,Tv[55]-Tv[38]); //20160106
   If SubjectToMinTax(RetNo) then
    Tv[40] :=  Vl(FetchElm(RetNo,'S12',525))
   else
    Tv[40]:=0;
   Tv[41] := Tv[39]+Tv[40];
   Tv[43] := GetPrvForTaxCredit(RetNo);
   Tv[44]:= MaxR(0,Tv[41]-Tv[43]);
   {
   //Tv[47]:= Tv[41];

   //Tv[51] := MaxR(0,(Tv[47]-12500) * 10/100);
   //Tv[51]:=MaxR(0,(Tv[47]-12500) * 10/100);
   //If RY=1 then Tv[51]:=MaxR(0,(Tv[47]-12500) * 10/100);  //2013

   Tv[42]:= Tv[41]+Tv[51];
   Tv[43] := GetPrvForTaxCredit(RetNo);
   Tv[44] :=Vl(FetchElm(RetNo,'POLIT',52));
   Tv[45]:=CalcPolitCredit('PE',Tv[44]);
   Tv[46] := Tv[43]+Tv[45];
   Tv[52] := Tv[46];
   Tv[56] := MaxR(0,Tv[42] - Tv[52]);
   }
 end;

 //Intructions
 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   Frm[FNo].Strings[103]:= '0.00';
   Tv[110]:=100;
   Tv[114]:=75;
   Tv[117]:=550;
   Tv[121]:=300;
   Tv[123]:=500;
 end;

 StoreElm(RetNo,FNo,17,'0.00'); //20180226
 StoreElm(RetNo,FNo,107,'0.00'); //20180226
 SaveTv(RetNo,FName,FNo);
end;

Procedure T3SK(RetNo:integer;FName:string;FNo:integer);
Var i:integer;x,y,z:real;
Begin
 if Certificationmode=True then   //20231203
 Begin
  Ret[RetNo].Province:='SK';
  Ret[RetNo].FrmHasdata[FNo]:=True;
 end;
 InitPrvConstants('SK');
 If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);

 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
   //20260118
   if CalcThisProvince(RetNo,'SK')=false then
   Begin
     For i:=1 to 59 do Tv[i]:=0;
     SaveTv(RetNo,FName,FNo);
     Exit;
   End;

   Tv[1]:= GetTrustTxbl(RetNo);

   With PrvConstant[RY] do
      begin
       Ret[RetNo].Frm[FNo].Strings[66]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[67]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[68]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[69]:=FormatFloat('###,###',PrvBracket2);

       //Tv[5] := 0;
       Ret[RetNo].Frm[FNo].Strings[5]:= '0.00';
       Tv[6]:=PrvBracket1;
       Tv[7]:=PrvBracket2;

       Tv[11]:= Vl(PrvConstant[RY].PrvRate1);
       Tv[12]:= Vl(PrvConstant[RY].PrvRate2);
       Tv[13]:= Vl(PrvConstant[RY].PrvRate3);

       Tv[17]:= PrvConstant[RY].PrvBracketTax1;
       Tv[18]:= PrvConstant[RY].PrvBracketTax2;
       Tv[19]:= PrvConstant[RY].PrvBracketTax3;

       Tv[57]:= Vl(PrvConstant[RY].PrvRate3); //PrvConstant[RY].PrvIntervivosRate;
       Tv[58]:= PrvConstant[RY].PrvDonRate1;
       Tv[59]:= PrvConstant[RY].PrvDonRate2;

       Ret[Retno].Frm[Fno].Strings[60]:= PrvConstant[RY].PrvDivRate; //20170121
       Ret[Retno].Frm[Fno].Strings[49]:= PrvConstant[RY].PrvDivRateBig;
       Strings[55]:= PrvConstant[RY].PrvDivRateStart2013;

       if CertificationMode=True then
       Begin
         Ret[RetNo].Frm[FNo].Strings[60]:=PrvConstant[0].PrvDivRate;
         Ret[RetNo].Frm[FNo].Strings[49]:=PrvConstant[RY].PrvDivRateBig; //20180108
       End;

       Tv[61]:= 50.00; //PrvConstant[RY].PrvAmtCarryOverRate; //20260218 Igor //https://www.canada.ca/content/dam/cra-arc/formspubs/pbg/t3sk/t3sk-25e.pdf
     end;
  end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[8] := MaxR(0,Tv[2]-vl(Frm[FNo].Strings[5]));
     Tv[14] := Tv[8] * Tv[11]/100;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Tv[12]/100;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2) then
   begin
     Tv[4] := Tv[1];
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Tv[13]/100;
     Tv[22] := Tv[16] + Tv[19];
   end;

   If OtherThanQreAndQdt(RetNo)=True then
    Tv[23] := Tv[1]
   else
    Tv[23]:=0;
   Tv[24]:=Tv[23] * Tv[57]/100;

   Tv[25]:= Vl(FetchElm(RetNo,'S11A',15));  //20170326  Tv[25]:= Vl(FetchElm(RetNo,'S11',38));

   If Tv[25]>200 then
   begin
    Tv[26]:=200;
    Tv[28] :=MaxR(0,Tv[25]-200);
   end
   else
   begin
    Tv[26]:=Tv[25];
    Tv[28]:=0;
   end;
   Tv[27] := Tv[26] * Tv[58]/100;
   Tv[29] := Tv[28] * Tv[59]/100;
   Tv[30] := Tv[27]+Tv[29];

   If OtherThanQreAndQdt(RetNo)=True then
     Tv[31] := Tv[24]
   else
     Tv[31] := MaxR(MaxR(Tv[20],Tv[21]),Tv[22]);

   Tv[48]:=Tv[31]+Tv[47];  //20170113
   Tv[32] := Tv[30];
   Tv[53] := Vl(FetchElm(RetNo,'S8',34));
   Tv[33] := Vl(FetchElm(RetNo,'S8',35));
   Tv[54] := Vl(FetchElm(RetNo,'S8',43));  //20141231
   Tv[50] := Tv[53] * Vl(Ret[Retno].Frm[FNo].Strings[49])/100;   //20170121
   Tv[34] := Tv[33] * Vl(Ret[Retno].Frm[FNo].Strings[60])/100; //Tv[60]/100;  //20170121
   Tv[62] := Tv[54] * Tv[55]/100;    //20141231
   Tv[35] := Vl(FetchElm(RetNo,'S11',143)); // Vl(FetchElm(RetNo,'S11',43)); //20160813
   Tv[36] := Tv[35] * Tv[61]/100;

   Tv[37] := Tv[32]+Tv[50]+Tv[34]+Tv[62]+Tv[36];  //20141231
   Tv[38] := Tv[37];
   Tv[39] := MaxR(0,Tv[48]-Tv[38]);
   If SubjectToMinTax(RetNo) then
    Tv[40] :=  Vl(FetchElm(RetNo,'S12',528))
   else
    Tv[40]:=0;
   Tv[41] := MaxR(Tv[39],Tv[40]);
   TV[42] := Vl(FetchElm(RetNo,'PRVCR',4));
   TV[43] := Vl(FetchElm(RetNo,'PRVCR',5));
   Tv[51] := GetPrvForTaxCredit(RetNo);

   Tv[44] :=Vl(FetchElm(RetNo,'POLIT',140));
   Tv[45]:=CalcPolitCredit('SK',Tv[44]);
   Tv[46] := Tv[51]+Tv[45]+Tv[42]+Tv[43]; //20230212
   Tv[52] := Tv[46];
   Tv[56] := MaxR(0,Tv[41] - Tv[52]);
  end;
  //Intructions
  With Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
   Frm[FNo].Strings[103]:= '0.00';
   Tv[110]:=400;
   Tv[114]:=300;
   Tv[117]:=750;
   Tv[121]:=475;
   Tv[123]:=650;
  end;

 StoreElm(RetNo,FNo,17,'0.00'); //20180226
 StoreElm(RetNo,FNo,107,'0.00'); //20180226
 SaveTv(RetNo,FName,FNo);
end;

Procedure T3NT(RetNo:integer;FName:string;FNo:integer);
Var i:integer;x,y,z:real;
Begin
 if Certificationmode=True then   //20231203
 Begin
  Ret[RetNo].Province:='NT';
  Ret[RetNo].FrmHasdata[FNo]:=True;
 end;

 InitPrvConstants('NT');
 If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);

 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
   //20260118
   if CalcThisProvince(RetNo,'NT')=false then
   Begin
     For i:=1 to 123 do Tv[i]:=0;
     SaveTv(RetNo,FName,FNo);
     Exit;
   End;

   Tv[1]:= GetTrustTxbl(RetNo);

   With PrvConstant[RY] do
      begin
       Ret[RetNo].Frm[FNo].Strings[47]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[48]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[49]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[50]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[51]:=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[52]:=FormatFloat('###,###',PrvBracket3);


       //Tv[5] := 0;
       Ret[RetNo].Frm[FNo].Strings[5]:= '0.00';
       Tv[6]:=PrvBracket1;
       Tv[7]:=PrvBracket2;
       Tv[57]:=PrvBracket3;

       Tv[11]:= Vl(PrvConstant[RY].PrvRate1);
       Tv[12]:= Vl(PrvConstant[RY].PrvRate2);
       Tv[13]:= Vl(PrvConstant[RY].PrvRate3);
       Tv[59]:= Vl(PrvConstant[RY].PrvRate4);

       Tv[17]:= PrvConstant[RY].PrvBracketTax1;
       Tv[18]:= PrvConstant[RY].PrvBracketTax2;
       Tv[19]:= PrvConstant[RY].PrvBracketTax3;
       Tv[61]:= PrvConstant[RY].PrvBracketTax4;

       Tv[63]:= Vl(PrvConstant[RY].PrvRate4); //PrvConstant[RY].PrvIntervivosRate;
       Tv[62]:= PrvConstant[RY].PrvDonRate1;
       Tv[65]:= PrvConstant[RY].PrvDonRate2;

       Ret[RetNo].Frm[FNo].Strings[66]:= PrvConstant[RY].PrvDivRate;
       Ret[RetNo].Frm[FNo].Strings[68]:=PrvConstant[RY].PrvDivRateBig;  //20120216

       if CertificationMode=True then
       Begin
         Ret[RetNo].Frm[FNo].Strings[66]:=PrvConstant[0].PrvDivRate;
         Ret[RetNo].Frm[FNo].Strings[68]:=PrvConstant[RY].PrvDivRateBig; //20180108
       End;

       Tv[67]:= PrvConstant[RY].PrvAmtCarryOverRate;
     end;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[8] := MaxR(0,Tv[2]-vl(Frm[FNo].Strings[5]));
     Tv[14] := Tv[8] * Tv[11]/100;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Tv[12]/100;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
    and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[4] := Tv[1];
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Tv[13]/100;
     Tv[22] := Tv[16] + Tv[19];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket3) then
   begin
     Tv[55] := Tv[1];
     Tv[58] := MaxR(0,Tv[55]-Tv[57]);
     Tv[60] := Tv[58] * Tv[59]/100;
     Tv[56] := Tv[60] + Tv[61];
   end;

   If OtherThanQreAndQdt(RetNo)=True then
    Tv[23] := Tv[1]
   else
    Tv[23]:=0;

   Tv[24]:=Tv[23] * Tv[63]/100;
   Tv[25]:= Vl(FetchElm(RetNo,'S11A',15));  //20170326  Tv[25]:= Vl(FetchElm(RetNo,'S11',25));
   If Tv[25]>200 then
   begin
    Tv[27]:=200;
    Tv[29] :=MaxR(0,Tv[25]-200);
   end
   else
   begin
    Tv[27]:=Tv[25];
    Tv[29]:=0;
   end;
   Tv[26] := Tv[27] * Tv[62]/100;
   Tv[28] := Tv[29] * Tv[65]/100;
   Tv[30] := Tv[26]+Tv[28];

   If OtherThanQreAndQdt(RetNo)=True then
     Tv[31] := Tv[24]
   else
     Tv[31] := MaxR(MaxR(Tv[20],Tv[21]),MaxR(Tv[22],Tv[56]));

   Tv[53]:=Tv[31]+Tv[44];  //20170113
   Tv[32] := Tv[30];
   Tv[70] := Vl(FetchElm(RetNo,'S8',34));
   Tv[69] := Tv[70] * Vl(Ret[RetNo].Frm[FNo].Strings[68])/100; //Tv[68]/100;    20120216

   Tv[33] := Vl(FetchElm(RetNo,'S8',35));
   // Tv[53] := Vl(FetchElm(RetNo,'S8',43)); //20141231  //20170502
   Tv[34] := Tv[33] * Vl(Ret[RetNo].Frm[FNo].Strings[66])/100;
  //Tv[75] := Tv[53] * Vl(Ret[RetNo].Frm[FNo].Strings[74])/100;

   Tv[35] :=  Vl(FetchElm(RetNo,'S11',143));  //20160813
   Tv[36] := Tv[35] * Tv[67]/100;
   Tv[37] := Tv[32]+Tv[69]+Tv[34]; //+Tv[75]+Tv[36];  //20170502

   Tv[38] := Tv[37];
   Tv[39] := MaxR(0,Tv[53]-Tv[38]);
   If SubjectToMinTax(RetNo) then
    Tv[40] :=  Vl(FetchElm(RetNo,'S12',542))
   else
    Tv[40]:=0;

   //20170502
   Tv[39]:=MaxR(0,Tv[53]-Tv[38]);
   Tv[41]:=Tv[39]+Tv[40];

   Tv[45] := GetPrvForTaxCredit(RetNo);
   Tv[42] :=Vl(FetchElm(RetNo,'POLIT',62));
   Tv[43]:=CalcPolitCredit('NT',Tv[42]);
   Tv[54] := Tv[45]+Tv[43];  //+Tv[44]; //20170502
   Tv[64] := Tv[54];
   Tv[46] := MaxR(0,Tv[41] - Tv[64]);
 end;
 //Instructions
 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
  Frm[FNo].Strings[103]:= '0.00';
  Tv[110]:=100;
  Tv[114]:=100;
  Tv[116]:=500;
 end;

 StoreElm(RetNo,FNo,17,'0.00'); //20180226
 StoreElm(RetNo,FNo,107,'0.00'); //20180226
 SaveTv(RetNo,FName,FNo);
end;

//20260309 Igor >>>
procedure T3YT(RetNo: Integer; FName: string; FNo: Integer);
var
  i: Integer;
  x, y, z: Real;

  function T3YTLine19(): Currency; //20260309 Igor
  begin
     result:= 0;

     with Ret[RetNo].Frm[FNo] do
     begin
       //--> Line 19 – Minimum Tax Carryover  //jz2025update-rev1:new calc for ln19 as per form
                //Tv[35] := Vl(FetchElm(RetNo,'S11',143)); line changed//Vl(FetchElm(RetNo,'S11',43));  //20160813
                //Tv[67]:= PrvConstant[RY].PrvAmtCarryOverRate;    //jz2025update-rev1:line changed
                //Tv[73]:=; //vtUser
                //Tv[74]:= //Vl(FetchElm(RetNo,'S11',143)); //vtUser as well??

       Tv[75]:= MaxR(0, Tv[73] - Tv[74]);
       Tv[85]:= Vl(FetchElm(RetNo, 'S11', 143)); //jz2025update
       Tv[86]:= minR(Tv[75], Tv[85]);
       Tv[87]:= 44.14; //??? does this percent come from somewhere other than this form?
       Tv[88]:= PCPM(Tv[86], Tv[87] / 100); //20260309 Igor
       Tv[89]:= MaxR(0, Tv[85] - Tv[75]); //20260309 Igor
       Tv[90]:= 43.90; //??? does this percent come from somewhere other than this form?
       Tv[91]:= PCPM(Tv[89], Tv[90] / 100); //20260309 Igor
       Tv[92]:= Tv[88] + Tv[91]; //20260309 Igor (+) not the (*)
       Result:= Tv[92]; //Tv[36]:= Tv[92]; //Tv[35] * Tv[67]/100;
     end;
     //<-- Line 19 – Minimum Tax Carryover  //jz2025update-rev1:as per form
  end;

begin
  if (Certificationmode = True) then   //20231203
  begin
    Ret[RetNo].Province:= 'YT';
    Ret[RetNo].FrmHasdata[FNo]:= True;
  end;

  xx:= Ret[RetNo].Frm[FNo].Tv[36];

  InitPrvConstants('YT');
  if (Ret[RetNo].Frm[FNo].Count = 0) then InitFormData(RetNo, FNo);

  xx:= Ret[RetNo].Frm[FNo].Tv[36];
  LoadTv(RetNo, FName, FNo);
  xx:= Ret[RetNo].Frm[FNo].Tv[36];

  with Ret[RetNo].Frm[FNo] do
  begin
    //20260118
    if not CalcThisProvince(RetNo, 'YT') then
    begin
      for i:= 1 to 123 do Tv[i]:= 0;

      SaveTv(RetNo, FName, FNo);
      Exit;
    end;

    xx:= Ret[RetNo].Frm[FNo].Tv[36];
    Tv[1]:= GetTrustTxbl(RetNo);

    //Changed a lot 20160209
    with PrvConstant[RY] do
    begin
      Ret[RetNo].Frm[FNo].Strings[47]:= FormatFloat('###,###', PrvBracket1);
      Ret[RetNo].Frm[FNo].Strings[48]:= FormatFloat('###,###', PrvBracket1);
      Ret[RetNo].Frm[FNo].Strings[49]:= FormatFloat('###,###', PrvBracket2);
      Ret[RetNo].Frm[FNo].Strings[77]:= FormatFloat('###,###', PrvBracket2);
      Ret[RetNo].Frm[FNo].Strings[76]:= FormatFloat('###,###', PrvBracket3);
      Ret[RetNo].Frm[FNo].Strings[50]:= FormatFloat('###,###', PrvBracket3);
      Ret[RetNo].Frm[FNo].Strings[51]:= FormatFloat('###,###', PrvBracket4);
      Ret[RetNo].Frm[FNo].Strings[52]:= FormatFloat('###,###', PrvBracket4);

      //Tv[5]:= 0;
      Ret[RetNo].Frm[FNo].Strings[5]:= '0.00';
      Tv[6]:= PrvBracket1;
      Tv[82]:= PrvBracket2;
      Tv[7]:= PrvBracket3;
      Tv[57]:= PrvBracket4;

      Tv[11]:= Vl(PrvConstant[RY].PrvRate1);
      Tv[12]:= Vl(PrvConstant[RY].PrvRate2);
      Tv[80]:= Vl(PrvConstant[RY].PrvRate3);
      Tv[13]:= Vl(PrvConstant[RY].PrvRate4);
      Tv[59]:= Vl(PrvConstant[RY].PrvRate5);

      Tv[17]:= PrvConstant[RY].PrvBracketTax1;
      Tv[18]:= PrvConstant[RY].PrvBracketTax2;
      Tv[78]:= PrvConstant[RY].PrvBracketTax3;
      Tv[19]:= PrvConstant[RY].PrvBracketTax4;
      Tv[61]:= PrvConstant[RY].PrvBracketTax5;

      Tv[44]:= Vl(PrvConstant[RY].PrvRate5); //PrvConstant[RY].PrvIntervivosRate;
      Tv[53]:= PrvConstant[RY].PrvDonRate1;
      Tv[62]:= PrvConstant[RY].PrvDonRate2;

      Strings[63]:= PrvConstant[RY].PrvDivRate;
      Strings[70]:= PrvConstant[RY].PrvDivRateBig;

      if (CertificationMode = True) then
      begin
        Ret[RetNo].Frm[FNo].Strings[63]:= PrvConstant[0].PrvDivRate;
        Ret[RetNo].Frm[FNo].Strings[70]:= PrvConstant[RY].PrvDivRateBig; //20180108
      end;
    end;
  end;

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    if (Tv[1] <= PrvConstant[RY].PrvBracket1) then
    begin
      Tv[2]:= Tv[1];
      Tv[8]:= MaxR(0, Tv[2] - Tv[5]); //20260309 Igor //vl(Frm[FNo].Strings[5]));
      Tv[14]:= PCPM(Tv[8], Tv[11] / 100); //20260309 Igor
      Tv[20]:= Tv[14] + Tv[17];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket1) and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
    begin
      Tv[3]:= Tv[1];
      Tv[9]:= MaxR(0, Tv[3] - Tv[6]);
      Tv[15]:= PCPM(Tv[9], Tv[12] / 100); //20260309 Igor
      Tv[21]:= Tv[15] + Tv[18];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket2) and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
    begin
      Tv[84]:= Tv[1];
      Tv[81]:= MaxR(0, Tv[84] - Tv[82]);
      Tv[79]:= PCPM(Tv[81], Tv[80] / 100); //20260309 Igor
      Tv[83]:= Tv[79] + Tv[78];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket3) and (Tv[1] <= PrvConstant[RY].PrvBracket4) then
    begin
      Tv[4]:= Tv[1];
      Tv[10]:= MaxR(0, Tv[4] - Tv[7]);
      Tv[16]:= PCPM(Tv[10], Tv[13] / 100); //20260309 Igor
      Tv[22]:= Tv[16] + Tv[19];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket4) then
    begin
      Tv[55]:= Tv[1];
      Tv[58]:= MaxR(0, Tv[55] - Tv[57]);
      Tv[60]:= PCPM(Tv[58], Tv[59] / 100); //20260309 Igor
      Tv[56]:= Tv[60] + Tv[61];
    end;

    if (OtherThanQreAndQdt(RetNo) = True) then Tv[23]:= Tv[1] else Tv[23]:= 0;

    Tv[24]:= PCPM(Tv[23], Tv[44] / 100); //20260309 Igor
    Tv[25]:= Vl(FetchElm(RetNo, 'S11A', 15));  //20170326 Tv[25]:= Vl(FetchElm(RetNo,'S11',38));

    if (Tv[25] > 200) then
    begin
      Tv[27]:= 200;
      Tv[29]:= MaxR(0, Tv[25] - 200);
    end else
    begin
      Tv[27]:= Tv[25];
      Tv[29]:= 0;
    end;

    Tv[26]:= PCPM(Tv[27], Tv[53] / 100); //20260309 Igor
    Tv[28]:= PCPM(Tv[29], Tv[62] / 100); //20260309 Igor
    Tv[30]:= Tv[26] + Tv[28];

    if (OtherThanQreAndQdt(RetNo) = True) then
      Tv[31]:= Tv[24]
    else
    begin
      Tv[31]:= MaxR(MaxR(Tv[20], Tv[21]), MaxR(Tv[83], Tv[22]));
      Tv[31]:= MaxR(Tv[31], Tv[56]);
    end;
    Tv[66]:= Tv[31] + Tv[45]; //20170113
    //-------------------------------
    Tv[32]:= Tv[30];
    Tv[72]:= Vl(FetchElm(RetNo, 'S8', 34));
    Tv[33]:= Vl(FetchElm(RetNo, 'S8', 35));
    //Tv[73]:= Vl(FetchElm(RetNo,'S8',43)); //jz//20260306 elm repurposed //20141231

    Tv[71]:= PCPM(Tv[72], Vl(Strings[70]) / 100); //20260309 Igor //Tv[70]/100;
    Tv[34]:= PCPM(Tv[33], Vl(Strings[63]) / 100); //20260309 Igor //Tv[63]/100;
    //Tv[75]:= Tv[73] * Tv[74] / 100; //20260309 Igor. This field should be calculated in the Line 19 block

    //jz//20260306 - move Line 19 to own procedure
    //Tv[36]:= T3YTLine19();
    //20260309 Igor >>>
    Tv[75]:= MaxR(0, Tv[73] - Tv[74]);
    Tv[85]:= Vl(FetchElm(RetNo, 'S11', 143)); //jz2025update
    Tv[86]:= minR(Tv[75], Tv[85]);
    Tv[87]:= 45.71; //44.14; //??? does this percent come from somewhere other than this form? //20261006 Alex
    Tv[88]:= PCPM(Tv[86], Tv[87] / 100); //20260309 Igor
    Tv[89]:= MaxR(0, Tv[85] - Tv[75]); //20260309 Igor
    Tv[90]:= 43.90; //??? does this percent come from somewhere other than this form?
    Tv[91]:= PCPM(Tv[89], Tv[90] / 100); //20260309 Igor
    Tv[92]:= Tv[88] + Tv[91]; //20260309 Igor (+) not the (*)
    Tv[36]:= Tv[92];
    //20260309 Igor <<<

    Tv[37]:= Tv[32] + Tv[71] + Tv[34] + Tv[36];//Tv[32]+Tv[71]+Tv[34]+tv[75]+Tv[36]; //20191217
    Tv[38]:= Tv[37];
    Tv[39]:= MaxR(0, Tv[31] - Tv[38]);

    if SubjectToMinTax(RetNo) then Tv[40]:= Vl(FetchElm(RetNo, 'S12', 545)) else Tv[40]:= 0;

    Tv[41]:= Tv[39] + Tv[40];
    //----------------------------------
    //Tv[68]:= Tv[41];
    //Tv[45]:= MaxR(0, (Tv[68]-6000)*5/100);
    //Tv[66]:= Tv[41]+Tv[45];

    Tv[65]:= GetPrvForTaxCredit(RetNo);
    Tv[42]:= Vl(FetchElm(RetNo, 'POLIT', 122));
    Tv[43]:= CalcPolitCredit('YT', Tv[42]);
    Tv[54]:= Tv[65] + Tv[43];
    Tv[64]:= Tv[54];
    Tv[46]:= MaxR(0, Tv[41] - Tv[64]);//MaxR(0,Tv[66] - Tv[64]); //20160217
  end;

  //Instructions
  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    Frm[FNo].Strings[103]:= '0.00';
    Tv[110]:= 400;
    Tv[114]:= 300;
    Tv[117]:= 750;
    Tv[121]:= 475;
    Tv[123]:= 650;
  end;

  StoreElm(RetNo, FNo, 17, '0.00'); //20180226
  StoreElm(RetNo, FNo, 107, '0.00'); //20180226
  xx:= Ret[RetNo].Frm[FNo].Tv[36];

  SaveTv(RetNo, FName, FNo);
end;
//20260309 Igor <<<

Procedure S1A(RetNo:integer;FName:string;FNo:integer);
var i: integer;
Begin
   LoadTv(RetNo,FName,FNo);
   With Ret[RetNo].Frm[FNo] do
   begin
     //Shares -->
     Tv[31] :=0;Tv[32] :=0;Tv[33]:=0;
     i := 4;
     repeat
     Tv[i+3] := MaxR(0,Tv[i] - Tv[i+1]-Tv[i+2]);
     If Tv[i]>0 then
      Tv[i+5]:= Tv[i+3] * Tv[i+4]/Tv[i]
     else
      Tv[i+5]:=0;
     Tv[i+6]:= MaxR(0,Tv[i+3] - Tv[i+5]);
     Tv[31] := Tv[31]+Tv[i];
     Tv[32] := Tv[32]+Tv[i+5];
     Tv[33] := Tv[33]+Tv[i+6];
     inc(i,10);
     until i > 24;

     i := 86;            //20120216
     repeat
     Tv[i+3] := MaxR(0,Tv[i] - Tv[i+1]-Tv[i+2]);
     If Tv[i]>0 then
      Tv[i+5]:= Tv[i+3] * Tv[i+4]/Tv[i]
     else
      Tv[i+5]:=0;
     Tv[i+6]:= MaxR(0,Tv[i+3] - Tv[i+5]);
     Inc(i);
     until i>86;

     Tv[31] := Tv[31]+Tv[86];
     Tv[32] := Tv[32]+Tv[91];
     Tv[33] := Tv[33]+Tv[92];

     //Shares <--

     //Bonds -->
     i := 38;
     Tv[76] :=0;Tv[77] :=0;Tv[78]:=0;
     repeat
     Tv[i+3] := MaxR(0,Tv[i] - Tv[i+1]-Tv[i+2]);
     If Tv[i]>0 then
      Tv[i+5]:= Tv[i+3] * Tv[i+4]/Tv[i]
     else
      Tv[i+5]:=0;

     Tv[i+6]:= MaxR(0,Tv[i+3] - Tv[i+5]);
     Tv[76] := Tv[76]+Tv[i];
     Tv[77] := Tv[77]+Tv[i+5];
     Tv[78] := Tv[78]+Tv[i+6];
     inc(i,11);
     until i > 60;

     //jz2025update-rev1: missing addition of the last line
     Tv[76] := Tv[76]+Tv[69];
     Tv[77] := Tv[77]+Tv[74];
     Tv[78] := Tv[78]+Tv[75];
     //Bonds <--


     //jz2025update-rev1: this seems to not reffer to whats on the form
     {
     //land -->
     Tv[72] := MaxR(0,Tv[69] - Tv[70]-Tv[71]);
     Tv[74]:=Tv[72]+Tv[73]/2;
     Tv[75]:=MaxR(0,Tv[72]-Tv[74]);
     Tv[77]:=Tv[77]+Tv[74];
     Tv[78]:=Tv[78]+Tv[75];
     //land <--
     }

     //jz2025update-rev1: as per the form
     //land -->
     i := 114;
     Tv[110] :=0;Tv[111] :=0;Tv[257]:=0;
     repeat
     Tv[i+3] := MaxR(0,Tv[i] - Tv[i+1]-Tv[i+2]);
     If Tv[i]>0 then
      Tv[i+5]:= Tv[i+3] * Tv[i+4]/Tv[i]
     else
      Tv[i+5]:=0;

     Tv[i+6]:= MaxR(0,Tv[i+3] - Tv[i+5]);

     Tv[110] := Tv[110]+Tv[i];
     Tv[111] := Tv[111]+Tv[i+5];
     Tv[257] := Tv[257]+Tv[i+6];
     inc(i,9);
     until i > 141;
     //land <--




     //totals
     //Tv[79] := Tv[32]+Tv[77];
     //Tv[81] := MaxR(0,Tv[79]-Tv[80]);
     //Strings[83]:= '1/2';
     //Tv[84]:=Tv[81] * 1/2;
     //Tv[85]:=Tv[84];
     //Tv[86]:=Tv[80];
     //Tv[83] := Tv[81] * 0.50;
     //Tv[82]:=Tv[85]+Tv[86];

     Tv[82]:=Tv[32]+Tv[77]+Tv[111]; //jz2025update-rev1: added Tv[111] as per form
   end;
 SaveTv(RetNo,FName,FNo);
end;


Procedure ClearThisForm(RetNo:integer;FName:string);
var i,n,FNo :integer;
begin

 Fno := GetFormNo(FName);
 If (Fno >0) and (Ret[RetNo].Frm[FNo].Count >0)  then
 begin
   n := GetNumbFields(FName);
   for i:= 1 to n do //20260216 Igor
     if (FName.Equals('T3MB') and (i <> 65)) or not FName.Equals('T3MB') then //20260216 Igor
       StoreElm(RetNo, FNo, i, '');  //20120127
   //Begin Ret[Retno].Frm[FNo].Strings[i] := '';Tv[i]:=0;end;
 Calc(RetNo,FName);
 end;
end;

procedure STATUS(RetNo: integer; FName: String;FNo: integer);
Var I: integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   {
   Strings[1] := GetCorpName(RetNo);
   Strings[3] := GetTaxationYearEnd(RetNo);
   Strings[4] := Ret[RetNo].PrpStatus;
   }
   Strings[15] := OptRec.Prp_Name;
   Strings[16] :=OptRec.Prp_Street;
   Strings[17] :=OptRec.Prp_City;
   Strings[18] :=OptRec.Prp_Prov;
   Strings[19] :=OptRec.Prp_Postal;
   Strings[20] :=OptRec.Prp_Area+' '+OptRec.Prp_Tel;
   Strings[21] :=OptRec.Prp_Fax;

  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


Procedure T1055(RetNo:integer;FName:string;FNo:integer);
var i: integer;
Begin
   LoadTv(RetNo,FName,FNo);
   With Ret[RetNo], Ret[RetNo].Frm[FNo] do
   begin
    Frm[FNo].Strings[1] := FetchElm(RetNo,'T3',1);
    Frm[FNo].Strings[2] := FetchElm(RetNo,'T3',2);
    Frm[FNo].Strings[3] := FetchElm(RetNo,'T3',17);

    If UpperCase(Frm[FNo].Strings[23])<>'Y' then   //20130503
    begin
     For i:=4 to 307 do begin Frm[FNo].Strings[i]:=''; Tv[i]:=0;end;
     SaveTv(RetNo,FName,FNo);
     Exit;
    end;

    if Frm[FNo].Strings[51]>'' then
    //ok
    Else //remove data
    Begin
      for i:=7 to 12 do begin Frm[FNo].Strings[i]:='';end;
    End;

   if Frm[FNo].Strings[52]>'' then
    //ok
    Else //remove data
    Begin
     Frm[FNo].Strings[4]:='';
     Frm[FNo].Strings[13]:='';
     for i:=14 to 19 do begin Frm[FNo].Strings[i]:='';end;
    End;

   if Frm[FNo].Strings[53]>'' then
   Begin
    //ok
   end
   else //remove data //jz //20230117 do not remove data so both A and B and C and F can work with D and E such as in cert34
   begin
      //for i:=20 to 22 do begin Frm[FNo].Strings[i]:='';end;
   end;

   end;

   // T1055 pg 2 ---------------------------------------------------------------

   With Ret[RetNo], Ret[RetNo].Frm[FNo] do
   begin
        //20220318
        {QSB}
    	Tv[168] := Tv[148] - Tv[149]; // - Tv[157];
    	Tv[204] := Tv[201] - Tv[202]; // - Tv[203];
        {Tv[224] := T5013ElgblQSB1+T3ElgblQSB1;}
       	Tv[205] := Tv[148] + Tv[201] + Tv[190];
    	Tv[206] := Tv[168] + Tv[204] + Tv[224];
      Tv[43]:=Tv[206];
       {Qfarm}
        //20160210
       // Tv[34]:=Tv[31]-Tv[32]-Tv[33];
      //  Tv[40]:=Tv[37]-Tv[38]-Tv[39];
      //  Tv[41]:=Tv[34]+Tv[40];
        //---
    	Tv[212] := Tv[209] - Tv[210]; // - Tv[211];
        {Tv[226] := T5013ElgblQFP1+T3ElgblQFP1;}
     	Tv[213] := Tv[209] + Tv[225];
    	Tv[214] := Tv[212] + Tv[226];
      //Tv[214]:=Tv[41]+Tv[42];    //20160210
      Tv[44]:=Tv[214];
       {shares}
    	Tv[107] := Tv[104] - Tv[105]; // - Tv[106];
    	Tv[114] := Tv[111] - Tv[112]; // - Tv[113];

      Tv[116] := TotMultiple(RetNo,'S1SUPPL',71); //Vl(FetchElm(RetNo,'S1SUPPL',71));
      Tv[117] := TotMultiple(RetNo,'S1SUPPL',72); //Vl(FetchElm(RetNo,'S1SUPPL',72)); //20130503

    	Tv[118] := Tv[104] + Tv[111] + Tv[116];
    	Tv[119] := Tv[107] + Tv[114] + Tv[117];
      Tv[45]:=Tv[119];
        {RE}
    	Tv[125] := Tv[122] - Tv[123]; // - Tv[124];
    	Tv[131] := Tv[128] - Tv[129]; // - Tv[130];
      Tv[133] := TotMultiple(RetNo,'S1SUPPL',91); //Vl(FetchElm(RetNo,'S1SUPPL',91));
      Tv[134] := TotMultiple(RetNo,'S1SUPPL',92); //Vl(FetchElm(RetNo,'S1SUPPL',92));
    	Tv[135] := Tv[122] + Tv[128] + Tv[133];
    	Tv[136] := Tv[125] + Tv[131] + Tv[134];
      Tv[46]:=Tv[136];
        {Bonds}
    	Tv[146] := Tv[143] - Tv[144] - Tv[145];
    	Tv[156] := Tv[153] - Tv[154] - Tv[155];
      Tv[158] := TotMultiple(RetNo,'S1SUPPL',125); //Vl(FetchElm(RetNo,'S1SUPPL',125));
      Tv[159] := TotMultiple(RetNo,'S1SUPPL',126); //Vl(FetchElm(RetNo,'S1SUPPL',126));
    	Tv[160] := Tv[143] + Tv[153] + Tv[158];
    	Tv[161] := Tv[146] + Tv[156] + Tv[159];
      Tv[47]:=Tv[161];
        {pers use}
        //Tv[25]:=Tv[180]; //20131228
    	Tv[178] := Tv[175] - Tv[176] - Tv[177];
        //Tv[180]:=Tv[25];
    	Tv[181] := Tv[178] + Tv[180];
      Tv[48]:=Tv[181]; //Tv[175]+Tv[25];   //20131228

        {lpp}
      Tv[27]:=Tv[184]; //20131228
    	Tv[187] := Tv[184] - Tv[185]; // - Tv[186];
    	Tv[188] := MaxR(0,Tv[187] - Tv[198]);
      Tv[28]:=Tv[187];  //20131228

      //jz2025update-rev1:field [138] doesnt actaully exist on the form, remove and go straight to tv[50]
    	//Tv[138] := Tv[206]+Tv[214]+Tv[119]+ Tv[136]+Tv[161]+Tv[181]+Tv[188];
      Tv[50]  := Tv[206]+Tv[214]+Tv[119]+ Tv[136]+Tv[161]+Tv[181]+Tv[188];

     	Tv[162] := Tv[50];
      //Tv[163] := FetchInclusionRate(RetNo);
      Tv[164] := Tv[162] * (1/2); //Tv[163];
      Tv[165] := MaxR(0,Tv[164]);
      If Vl(FetchElm(RetNo,'S1',97)) <0 then
         Tv[166] := ABS(Vl(FetchElm(RetNo,'S1',97)))
      else
         Tv[166]:=0;
      Tv[167] := MaxR(0,Tv[165]-Tv[166]);
      Tv[169] := Tv[167];

      Tv[195] := Tv[171]+Tv[192]+Tv[196];
      Tv[216]:=Tv[172]+Tv[193]+Tv[197];

      Tv[217]:=Tv[189]+Tv[194]+Tv[215];
      Tv[218] := Tv[217];                   //20160210
      Tv[221] := MaxR(0,Tv[219]-Tv[220]);
      Tv[222] := Tv[221];
      Tv[227] := Tv[169]+Tv[218]+Tv[222]+Tv[223];
   end;

   // T1055 pg 3 ---------------------------------------------------------------
   With Ret[RetNo], Ret[RetNo].Frm[FNo] do
   begin
    If (Tv[164]<0) and   //cap loss   //20131228 Line 25
       (Vl(FetchElm(RetNo,'S1',97))>0)  then  //line 23   //20131229
    Begin
     Tv[301] := MaxR(0,Vl(FetchElm(RetNo,'S1',97))); //20131229//MaxR(0,Vl(FetchElm(RetNo,'S1_4',12)));
      //20160210
     If Tv[164]<0 then
       Tv[302] := ABS(Tv[164])
     Else
       Tv[302]:=0;

     Tv[303] := MaxR(0,Tv[301]-Tv[302]);
    end
    Else
    begin
      Tv[301] :=0;
      Tv[302] :=0;
      Tv[303] :=0;
    end;
    Tv[304]:=Vl(FetchElm(RetNo,'T3',310))+Vl(FetchElm(RetNo,'T3',311));
    Tv[307] := MaxR(0,Tv[304]-Tv[306]);
   end;

   SaveTv(RetNo,FName,FNo);

 end;


Procedure PENSINC(RetNo:integer;FName:string;FNo:integer);
var i: integer;
Begin
   LoadTv(RetNo,FName,FNo);
   With Ret[RetNo], Ret[RetNo].Frm[FNo] do
   begin
    i:=2;
    Tv[9]:=0;
    Repeat
     Tv[9]:=Tv[9]+Tv[i];
     Inc(i,2);
    until I>8;

    i:=11;
    Tv[18]:=0;
    Repeat
     Tv[18]:=Tv[18]+Tv[i];
     Inc(i,2);
    until I>17;

    i:=20;
    Tv[27]:=0;
    Repeat
     Tv[27]:=Tv[27]+Tv[i];
     Inc(i,2);
    until I>26;

    i:=29;
    Tv[36]:=0;
    Repeat
     Tv[36]:=Tv[36]+Tv[i];
     Inc(i,2);
    until I>35;

    i:=38;
    Tv[45]:=0;
    Repeat
     Tv[45]:=Tv[45]+Tv[i];
     Inc(i,2);
    until I>44;

    Tv[46]:=Tv[9]+Tv[18]+Tv[27]+Tv[36]+Tv[45];
   end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure CutPast(RetNo:integer;FName:string;FNo:integer);
var i: integer;
Begin
  With Ret[RetNo].Frm[FNo] do
  begin
   Strings[8]:=Strings[5]+'-recalced';
  end;
  For i:=1 to 24 do StoreElm(RetNo,FNo,i,Ret[RetNo].Frm[FNo].Strings[i]);
 (*
 // If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);
   //1.
   LoadTv(RetNo,FName,FNo);
   With Ret[RetNo] do
   begin
   end;
 SaveTv(RetNo,FName,FNo);
 *)
end;

Procedure FldMEM(RetNo: integer; FName: String;FNo: integer);
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
  end;
  SaveTv(RetNo,FName,FNo);
end;


Procedure T3ADJ(RetNo: integer; FName: String;FNo: integer);
Var i,j : integer; //FInst:String[4];
    S,SnapShotDir,FileNm,ln:String;
    PrevAmount,RevisedAmount:Real;
   // BeforeList:TStringList;
    //LnList,AmtList,BeforeList,AfterList,NetList:TStringList;
   // LnDescrList:TStringList;
begin
   LoadTv(RetNo,FName,FNo);
   with Ret[RetNo].Frm[Fno] do
   begin
    Strings[14]:='T'+GetT3AccountNumber(RetNo);
    Strings[13]:=FetchElm(RetNo,'T3',14);
    Strings[22]:=FetchElm(RetNo,'T3',17);
    Strings[1] := GetT3TrustName(RetNo);
    Strings[118] :=FetchElm(RetNo,'T3',3);
    If Strings[2]+Strings[4]='' then Strings[2]:='X';
    //home teleph
    //If Strings[16]='' then Strings[16]:=FetchElm(RetNo,'INFO',54)+' '+FetchElm(RetNo,'INFO',55);
    If Strings[20]='' then Strings[20]:='Y';

    If Strings[2]>'' then
    begin
     Strings[5]:='';
     Strings[7]:='';
     Strings[9]:='';
     Strings[11]:='';
    end;
   // If Strings[13] = '' then Strings[13] := AppYear;
    If UpperCase(Strings[20])='N' then
    begin
     Strings[3] := '';
     Strings[6] := '';
     Strings[8] := '';
     Strings[10] := '';
     Strings[12] := '';
     Strings[17]:='';
     Strings[18]:='';
    end
    else
    begin
     Strings[3] := OptRec.Prp_Name;
     Strings[6] := OptRec.Prp_Street;
     Strings[8] := OptRec.Prp_City;
     Strings[10] := OptRec.Prp_Prov;
     Strings[12] := OptRec.Prp_Postal;
    end;

   // Strings[14] := FetchElm(RetNo,'INFO',3);

    //Revised amounts only
    i:=23;
    repeat
      Tv[i+3]:=Tv[i+4]-Tv[i+2];
      Strings[i]:=LeftStr(Strings[i],4);
      //Strings[i]:=RemoveChar(Strings[i],'*');
      Inc(i,5);
     until i>108;

     If Strings[15] = '' then Strings[15] := DateToMonthDayYear(Date);
     If Strings[19] =''
      then Strings[19]:= FetchElm(RetNo,'T3',12)+' '+FetchElm(RetNo,'T3',13);

    // If Strings[19]='' then Strings[19] := OptRec.Prp_Area + ' ' + OptRec.Prp_Tel;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure NR6(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   If Strings[1]='' then Strings[1]:=AppYear;
   Tv[32]:=0;Tv[33]:=0;Tv[34]:=0;
   i:=40;
   Repeat
    Tv[i+2]:=Tv[i]-Tv[i+1];
    Tv[32]:=Tv[32]+Tv[i];
    Tv[33]:=Tv[33]+Tv[i+1];
    Tv[34]:=Tv[34]+Tv[i+2];
    Inc(i,7);
   until i>75;
   If Strings[31]='' then Strings[31]:=FormatDateTime('yyyy-mm-dd',Now);
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure NR6INSTR(RetNo: integer; FName: String;FNo: integer);
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   If Strings[1]='' then Strings[1]:=AppYear;
  end;
  SaveTv(RetNo,FName,FNo);
end;


procedure T3DON(RetNo: integer; FName: String;FNo: integer);
Var Cn,Us,CnCf,UsCf,TotCf,Remaining: real; I: integer;
begin
 EXIT;  //20180124
  LoadTv(RetNo,FName,FNo);
  CnCf:=0;UsCf:=0;
  with Ret[RetNo].Frm[Fno] do
  begin
     If Strings[134]='' then Strings[134]:='N';
     cn  :=0; us :=0;
     Tv[2]:=Ret[RetNo].T5013Don;
     If Strings[2] > '' then Strings[2] :='';   {no us for slips}
     If Strings[7] > '' then Strings[7] :='';
     cn :=0;
     i := 17;
     Repeat  {first column}
      If UpperCase(Strings[i+1]) = 'X'then
        us := us+tv[i]
      else
        cn := cn + Tv[i];
      Inc(i,6);
     Until i > 83;

     i := 4;
     Repeat   {Second column}
      If UpperCase(Strings[i+1]) = 'X'then
        us := us+tv[i]
      else
        cn := cn + Tv[i];
      Inc(i,5);
     Until i > 14;

     i := 20;
     Repeat   {Second column}
      If UpperCase(Strings[i+1]) = 'X'then
        us := us+tv[i]
      else
        cn := cn + Tv[i];
      Inc(i,6);
     Until i > 86;
     Cn:=cn+Tv[177]+Tv[2];
     Us:=Us+Tv[178];

     Tv[175]:=cn+Tv[1];  //20130217
     Tv[176]:=Us+Tv[7]+Tv[11];     //20130217
     Tv[88] := Tv[175]+Tv[176]; //cn+Us;

     //cultural gifts      //20120218
   //  Tv[170]:=Ret[RetNo].T5013Gifts;  //20090416
   //  Tv[172]:=Tv[169]+Tv[170]+Tv[171];
     //If Tv[173]=0 then Tv[173]:=Tv[172]; //manual input
   //  Tv[174]:=MaxR(0,Tv[172]-Tv[173]);

    {PRIOR YEARS}
     Strings[135]  := GetPrvYear(AppYear,5);
     Strings[140]  := GetPrvYear(AppYear,4);
     Strings[89]  := GetPrvYear(AppYear,3);
     Strings[94]  := GetPrvYear(AppYear,2);
     Strings[99]  := GetPrvYear(AppYear,1);
     Strings[104] := AppYear;

    {current year row}
    Tv[105] := Tv[88];
    {get portion applied from each year}
    Remaining :=MaxR(0,GetTrustNetIncome(RetNo));
    Remaining:=MinR(Remaining,Tv[127]);  //max calculated
   i:=136;
    Repeat
     If Tv[i] < Remaining then
       begin
        If UpperCase(Strings[134]) <> 'Y' then Tv[i+1] := Tv[i];
        Remaining := Remaining-Tv[i+1];
       end
     else
       begin
        If UpperCase(Strings[134]) <> 'Y' then Tv[i+1] := Remaining;
        Remaining := 0;
       end;
      Inc(i,5);
    until i > 141;

    i:=90;
    Repeat
     If Tv[i] < Remaining then
       begin
        If UpperCase(Strings[134]) <> 'Y' then Tv[i+1] := Tv[i];
        Remaining := Remaining-Tv[i+1];
       end
     else
       begin
        If UpperCase(Strings[134]) <> 'Y' then Tv[i+1] := Remaining;
        Remaining := 0;
       end;
      Inc(i,5);
    until i > 105;

    {prior year : Horizontal}

     i := 136;
     Repeat
      Tv[i+3] := MaxR(0,Tv[i] - Tv[i+1] - Tv[I+2]);
      Inc(i,5);
     until i > 141;


     i := 90;
     Repeat
      Tv[i+3] := MaxR(0,Tv[i] - Tv[i+1] - Tv[I+2]);
      Inc(i,5);
     until i > 105;

    {prior year : Vertical}

     Tv[109]:=AddColumns(136,141,5)+AddColumns(90,105,5);
     Tv[110]:=AddColumns(137,142,5)+AddColumns(91,106,5);
     Tv[111]:=AddColumns(138,143,5)+AddColumns(92,107,5);
     Tv[112]:=AddColumns(139,144,5)+AddColumns(93,108,5);

     {Calculate credit}
     Tv[113]:=Tv[175];Tv[114]:=Tv[176];Tv[115]:=Tv[113]+Tv[114];
     Tv[118]:=Tv[136]+Tv[141]+Tv[90]+Tv[95]+Tv[100];Tv[116]:=MaxR(0,Tv[118]-Tv[117]);
     Tv[119]:=Tv[113]+Tv[116];Tv[120]:=Tv[114]+Tv[117];Tv[121]:=Tv[115]+Tv[118];
     Tv[124]:=MaxR(0,GetTrustNetIncome(RetNo)); //Ret[RetNo].Ln[236];
     Tv[122] := MaxR(0,Tv[124] - Tv[123]);
     Tv[145]:=Tv[122]*75/100;
     Tv[146]:= Tv[123]* 75/100;
     Tv[147]:=Tv[145]+Tv[146];
     Tv[150]:=Tv[148]+Tv[149];
     Tv[153]:=Tv[151]+Tv[152];
     Tv[156]:=Tv[154]+Tv[155];
     //20120218
    // Tv[157]:=Tv[154]; //MaxR(0,Tv[148]+Tv[151]+Tv[154]);
    // Tv[158]:=MaxR(0,Tv[149]+Tv[152]+Tv[155]);
    // Tv[157]:=MaxR(0,Tv[148]+Tv[151]-Tv[154]);
    // Tv[158]:=MaxR(0,Tv[149]+Tv[152]-Tv[155]);
    // Tv[159]:=Tv[157]+Tv[158];
     Tv[160]:=Tv[154]*0.25; //Tv[157]*25/100;  //20120218
     Tv[161]:=Tv[155]*25/100; //Tv[158]*25/100;
     Tv[162]:=Tv[160]+Tv[161];
     Tv[165]:=Tv[163]+Tv[164];
     Tv[166]:=Tv[163]*25/100;Tv[167]:=Tv[164]*25/100;Tv[168]:=Tv[166]+Tv[167];
     Tv[125]:=MinR(Tv[119],Tv[145]+Tv[160]+Tv[166]);
     Tv[126]:=MinR(Tv[120],Tv[146]+Tv[161]+Tv[167]);
     Tv[127]:=MinR(Tv[121],Tv[125]+Tv[126]);

     Tv[128] :=MinR(Tv[110],MinR(Tv[119], Tv[125]));
     Tv[130] :=Tv[110];
     Tv[129] := MaxR(0,Tv[130]-Tv[128]);
     Tv[131]:=MaxR(0,Tv[119]-Tv[128]);Tv[132]:=MaxR(0,Tv[120]-Tv[129]);
     Tv[133]:=Tv[131]+Tv[132];
    {cultural,ecological}

    Tv[140] := Tv[135] + Tv[137] +Tv[139];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

procedure T3LOSS(RetNo: integer; FName: String;FNo: integer);
Var
    i,Yr: integer;
    CurrentInclRate,AdjFact,TxblGains,RemGains,NetApplied,TotalApplied,Adjusted,
    PriorInclRate,{TxblIncome,}NonCapLimit,FarmLimit,RestrFarmLimit:Real;
    AutoSw :boolean;

    //pg 2
    Cfr1FNo: integer;
    IR,AdjFactor1,AdjFactor2,MaxLimit:Real;
begin

 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo], Ret[RetNo].Frm[FNo] do
 Begin
  AutoSw:=True;
  // If Frm[FNo].Strings[204] = '' then Frm[FNo].Strings[204]:='Y';
  // AutoSw := (UpperCase(Frm[FNo].Strings[204])='Y');
   {Enter years in non cap loss}
   Yr := MyStrToInt(AppYear)-7;
   If ry=1 then Yr:=MyStrToInt(AppYear)-6;
   i := 1;
   Repeat
    Frm[FNo].Strings[i] := IntToStr(Yr);
    Inc(i,5);
    Yr := Yr+1;
   until i > 36;
   {Enter years in non farm loss}
   Yr := MyStrToInt(AppYear)-10;
   If RY=1 then Yr := MyStrToInt(AppYear)-9;
   i := 45;
   Repeat
    Frm[FNo].Strings[i] := IntToStr(Yr);
    Inc(i,5);
    Yr := Yr+1;
   until i > 95;
   {Enter years in restr farm loss}
   Yr := MyStrToInt(AppYear)-10;
   If RY=1 then Yr := MyStrToInt(AppYear)-9;
   i := 104;
   Repeat
    Frm[FNo].Strings[i] := IntToStr(Yr);
    Inc(i,5);
    Yr := Yr+1;
   until i > 154;

   {current year loss}
   Tv[37] := Vl(FetchElm(RetNo,'T3A',31)); {other non-cap}
   Tv[96] := Vl(FetchElm(RetNo,'T3A',44)); {farming/fish }
   Tv[155] := Vl(FetchElm(RetNo,'T3A',124)); {Restr farm }
   {Loss C/B}
   Tv[38] := Vl(FetchElm(RetNo,'T3A',38)); {other non-cap}
   Tv[97] := Vl(FetchElm(RetNo,'T3A',48)); {farming/fish c/b}
   Tv[156] := Vl(FetchElm(RetNo,'T3A',128)); {Restr farm c/b}

   {calc txbl income against wich to apply non cap/farm losses}
   //TxblIncome := GetTrustTxblBfrLosses(RetNo); //GetTxblIncBfrLosses(RetNo);

   {apply restricted farm losses}
   RestrFarmLimit := Tv[165]; //Ret[RetNo].Ln[141];
   If RestrFarmLimit <0 then RestrFarmLimit :=0; {apply only if positive farm income}
   If AutoSw then
   begin
    i := 105;
    Repeat
      Tv[i+1] := MinR(Tv[i], RestrFarmLimit);
      RestrFarmLimit := MaxR(0,RestrFarmLimit- Tv[i+1]);
      Inc(i,5);
    until i>150;
   end;

   {apply farm losses}
   FarmLimit:=Tv[164];
   If AutoSw then
   begin
    i := 46;
    Repeat
      Tv[i+1] := MinR(Tv[i], FarmLimit);
      FarmLimit := MaxR(0,FarmLimit - Tv[i+1]);
      Inc(i,5);
    until i>91;
   end;

   {apply non cap losses}
   NonCapLimit:=Tv[163];
   If AutoSw then
   begin
    i := 2;
    Repeat
      Tv[i+1] := MinR(Tv[i], NonCapLimit);
      NonCapLimit := MaxR(0,NonCapLimit- Tv[i+1]);
      Inc(i,5);
    until i>32;
   end;

  {calc section non cap losses}
  i:= 2;
  repeat
 //  If i=2 then Tv[i+2]:=MaxR(0,Tv[i]-Tv[i+1]); //20141231
   Tv[i+3] := MaxR(0,Tv[i] - Tv[i+1]-Tv[i+2]);
   Inc(i,5);
  until i>37;
  Tv[41] := AddColumns(2,37,5);
  Tv[42] := AddColumns(3,38,5);
  Tv[43] := AddColumns(4,39,5);
  Tv[44] := AddColumns(5,40,5);

  {calc section farm losses}
  i:= 46;
  repeat
 //  If i=46 then Tv[i+2]:=MaxR(0,Tv[i]-Tv[i+1]);          //20141231
   Tv[i+3] := MaxR(0,Tv[i] - Tv[i+1]-Tv[i+2]);
   Inc(i,5);
  until i>96;
  Tv[100] := AddColumns(46,96,5);
  Tv[101] := AddColumns(47,97,5);
  Tv[102] := AddColumns(48,98,5);
  Tv[103] := AddColumns(49,99,5);

  {calc section restr farm losses}
  i:= 105;
  repeat
 //  If i=105 then Tv[i+2]:=MaxR(0,Tv[i]-Tv[i+1]); //20141231
   Tv[i+3] := MaxR(0,Tv[i] - Tv[i+1]-Tv[i+2]);
   Inc(i,5);
  until i>155;
  Tv[159] := AddColumns(105,155,5);
  Tv[160] := AddColumns(106,156,5);
  Tv[161] := AddColumns(107,157,5);
  Tv[162] := AddColumns(108,158,5);

  //what are these?
  Tv[193] := AddColumns(163,188,5)+Tv[198]+Tv[211]+Tv[206]+Tv[221]+Tv[216];
  Tv[194] := AddColumns(164,189,5)+Tv[199]+Tv[212]+Tv[207]+Tv[222]+Tv[217];
  Tv[195] := AddColumns(165,190,5)+Tv[200]+Tv[213]+Tv[208]+Tv[223]+Tv[218];
  Tv[196] := AddColumns(166,191,5)+Tv[201]+Tv[214]+Tv[209]+Tv[224]+Tv[219];
  Tv[197] := AddColumns(167,192,5)+Tv[202]+Tv[215]+Tv[210]+Tv[225]+Tv[220];

  //listed
  Tv[170]:=MaxR(0,Tv[166]-Tv[168]+Tv[169]);
 end;

// T3LOSS pg 2 -----------------------------------------------------------------
 with Ret[RetNo].Frm[FNo] do
 Begin
   IR:=Tv[10];
   If IR=0 then IR:=50; //0.50;
  {-------------  {Net cap losses -----------}

   //Get unupplied adjusted losses
   i := 265;     //20130217
   Repeat
    AdjFactor1:=1;AdjFactor2:=1;
    if i=275 then begin AdjFactor1:=3/4;AdjFactor2:=4/3;end;
    if i=280 then begin AdjFactor1:=2/3;AdjFactor2:=3/2;end;
    if i=285 then begin //yr 2000
       IR:=IR/100;
       AdjFactor1:=1/(2*IR) ;
       AdjFactor2:=2 * IR;
    end;
    Tv[i+1]:=Tv[i] * AdjFactor1;    //c
    Tv[207]:=Tv[207]+Tv[i+1];//Tv[7]:=Tv[7]+Tv[i+1];             //20130217
    Inc(i,5);
   until i>385; //20220215


   MaxLimit:=Tv[201];
   RemGains:=MaxLimit;
   NetApplied :=0;
   TotalApplied:=0;
   //Apply
   i := 265;
   Tv[207]:=0;   //20130217
   Tv[208]:=0;Tv[233]:=0;
   Repeat
    AdjFactor2:=1;
    if i=275 then AdjFactor2:=4/3;
    if i=280 then AdjFactor2:=3/2;
    if i=285 then
    begin //yr 2000
       IR:=Tv[210];
       AdjFactor2:=(2 * IR)/100;
    end;
    Tv[i+2]:=MinR(RemGains,Tv[i+1]);
    NetApplied := Tv[i+2];
    Tv[i+3]:=MaxR(0,Tv[i+1]-Tv[i+2]);  //e
    Tv[i+4] := Tv[i+3] * AdjFactor2;
    Tv[233]:=Tv[233]+Tv[i+4];
    TotalApplied:= TotalApplied+NetApplied;
    RemGains := MaxR(0,MaxLimit - TotalApplied);
    Tv[207]:=Tv[207]+Tv[i+1];
    Tv[208]:=Tv[208]+Tv[i+2];
    Inc(i,5);
   until i>385; //375; //20220215

  //current year
   Tv[202] := Vl(FetchElm(RetNo,'T3A',101));
   Tv[203]:=Tv[202];
   Tv[204]:= Vl(FetchElm(RetNo,'T3A',105));
   Tv[205]:=MaxR(0,Tv[203]-Tv[204]);
   Tv[206]:=Tv[205];  //20130329
   Tv[234]:=Tv[233]+Tv[206];
 end;

 SaveTv(RetNo,FName,FNo);

end;

Procedure T3OTHDED(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   {
   Tv[1]:=Vl(FetchElm(RetNo,'T3LOSS',101))+Vl(FetchElm(RetNo,'T3LOSS',160));
   Tv[2]:=Vl(FetchElm(RetNo,'T3LOSS',168));
   }
   Tv[6]:=Tv[1]+Tv[2]+Tv[3]+Tv[4]+Tv[5];
   Tv[9]:=Ret[RetNo].T5013Tax;
   Tv[13]:=Tv[9]+Tv[11]+Tv[12];
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure FLDTAPE(RetNo: integer; FName: String;FNo: integer);
Var RefFormName:String;
    //20220121 Igor >>>
    TapeStr: string;
    Idx: integer;
    //20220121 Igor <<<
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FormatSettings.DecimalSeparator:='.';  //needed
    Tv[125]:=AddColumns(1,60,1);
    RefFormName:= Strings[121];
    //If UpperCase(LeftStr(Strings[121],3))='MED' then begin Strings[123]:='';Strings[124]:='X';end;
    //20220121 Igor >>>
    If (Tv[125] <> 0) and (Strings[123] + Strings[124] = '') then
    begin
      Strings[123] := 'X';
      Strings[124] := '';
    end;
    TapeStr := RefFormName + '|' + Strings[122];
    If (UpperCase(Strings[123])='X') and (RefFormName>'') then
    begin
      StoreElm(RetNo,GetFormNo(RefFormName),MyStrToInt(Strings[122]),
       FormatFloat('########.##',TV[125]));
      if not ret[RetNo].TapesList.Find(TapeStr, Idx) then
        ret[RetNo].TapesList.Add(TapeStr);
    end
    else if ret[RetNo].TapesList.Find(TapeStr, Idx) then
      ret[RetNo].TapesList.Delete(Idx);
    //20220121 Igor <<<
  end;
  SaveTv(RetNo,FName,FNo);
  If (UpperCase(Ret[RetNo].Frm[FNo].Strings[123])='X')
   and (RefFormName>'') then
  begin
    Calc(RetNo,RefFormName);
  end;
  {CalcAllForms(RetNo);}
  //MainForm.UpdateTaxPanel(RetNo);
end;

Procedure T3INCOME(RetNo: integer; FName: String;FNo: integer);
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   If Strings[37]='' then Strings[37]:=GetT3TrustName(RetNo);
   If Tv[3]>100 then Tv[3]:=100;
   If Tv[38]>100 then Tv[38]:=100;
   Tv[2]:=MaxR(0,100-Tv[3]-Tv[38]);
   If Tv[4] =0 then Tv[4]:=1.0;
   If Tv[6]>0 then
   begin
    If Tv[11]>Tv[6] then Tv[11]:=Tv[6];
   end;
   Strings[29] :='3';
   //20090319
   If UpperCase(Strings[39])<>'Y' then
     Tv[32]:=MinR(10000,Tv[18]);
   Tv[33]:=MaxR(0,Tv[18]-Tv[32]);
  end;
  SaveTv(RetNo,FName,FNo);
  Sumslips(RetNo,'ALL');
end;

Procedure T5INCOME(RetNo: integer; FName: String;FNo: integer);
Var DistribAmount,ThisPercent:Real;i,j,Inst,k:Integer;FInst:String[4];x:Real;ExchRate:String;
begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   //put slip numbers based on FInst
   Inst:=MyStrToInt(AllTrim(MidStr(FInst,2,3)));
   k:=(Inst-1)*5+1; //first slip
   i:=22; Repeat Strings[i]:='#'+IntToStr(k); Inc(i,22); Inc(k,1); until i>110; //next column
   i:=136; j:=22; Repeat Strings[i]:=Strings[j];Inc(i); Inc(j,22); until i>140;

   Strings[15] := FetchElm(RetNo,'T3',1);
   //Strings[17] := AppYear;
   Strings[37]:=FInst;

   For k:=0 to 4 do
   begin
    //currency
    If Strings[21+k*22]='' then begin Strings[21+K*22]:='CAN';Strings[4+k*22]:='';end;
    //percent
    If Tv[2+k*22]>100 then Tv[2+k*22]:=100;
    If Tv[3+k*22]>100 then Tv[3+k*22]:=100;
    If Tv[81+k*22]>100 then Tv[81+k*22]:=100;
    Tv[2+k*22]:=MaxR(0,100-Tv[3+k*22]-Tv[81+k*22]);
    ExchRate:=Strings[4+k*22];
    If ExchRate='' then ExchRate:='1';
    ThisPercent:=100; //Tv[2+k*22];
    DistribAmount:= Tv[7+k*22] * Vl(ExchRate);
    DistribAmount := DistribAmount * ThisPercent /100;
    Tv[18+k*22] := MaxR(0,DistribAmount- (Tv[19+k*22]+Tv[20+k*22]));
   end;

   //Init total column
   For i:=116 to 123 do Tv[i]:=0;
   Tv[126]:=0;
   For i:=128 to 130 do Tv[i]:=0;
    Tv[146]:=0;
   //TOTALS
    i:=141;
    Repeat
     For k:=0 to 4 do
     begin
     If Tv[i+k]<>0 then
      begin
       ExchRate:=Strings[4+K*22];
       If ExchRate='' then ExchRate:='1';
       ThisPercent:=100; //Tv[2+k*22];
       Tv[146]:=Tv[146]+Tv[i+k]*Vl(ExchRate)*ThisPercent/100;
      end;
     end;
     Inc(i,1);
    until i>141;

    i:=6;
    Repeat
     For k:=0 to 4 do
     begin
      If Tv[i+k*22]<>0 then
      begin
       ExchRate:=Strings[4+K*22];
       If ExchRate='' then ExchRate:='1';
       ThisPercent:=100; //Tv[2+k*22];
       Tv[i+22*5]:=Tv[i+22*5]+Tv[i+k*22]*Vl(ExchRate)*ThisPercent/100;
      end;
     end;
     Inc(i,1);
    until i>13;

    i:=16;
    Repeat
     For k:=0 to 4 do
     begin
     If Tv[i+k*22]<>0 then
      begin
       ExchRate:=Strings[4+K*22];
       If ExchRate='' then ExchRate:='1';
       ThisPercent:=100; //Tv[2+k*22];
       Tv[i+22*5]:=Tv[i+22*5]+Tv[i+k*22]*Vl(ExchRate)*ThisPercent/100;
      end;
     end;
     Inc(i,1);
    until i>16;

   (*
    ///add distr amount
    For i:=128 to 130 do Tv[i]:=0;
    i:=18;
    Repeat
     Tv[i+5*22]:=Tv[i]+Tv[i+22]+Tv[i+44]+Tv[i+66]+Tv[i+88];
     Inc(i,1);
    until i>20;

   //completed indicator
   For i:=131 to 135 do Strings[i]:='';
   x:=AddColumns(6,13,1)+Tv[141]; If x>0 then Strings[131]:='Y';
   x:=AddColumns(28,35,1)+Tv[142]; If x>0 then Strings[132]:='Y';
   x:=AddColumns(50,57,1)+Tv[143]; If x>0 then Strings[133]:='Y';
   x:=AddColumns(72,79,1)+Tv[144]; If x>0 then Strings[134]:='Y';
   x:=AddColumns(94,101,1)+Tv[145]; If x>0 then Strings[135]:='Y';
  *)
  end;
  SaveTv(RetNo,FName,FNo);
  SumSlips(RetNo,'ALL');  //it covers T5INCOME processing
end;


Procedure T5013Inc(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   If Tv[11] =0 then
   begin
    Tv[12]:=0;Tv[13]:=0;Tv[42]:=0;
   end;
   Tv[42] := Tv[11] -(Tv[12]+Tv[13]);
  end;
  SaveTv(RetNo,FName,FNo);
end;

//20191225 with AIIP
Procedure Autos(RetNo: integer; FName: string; FNo: integer);
Var
  i, MaxBusDays, BusDays: integer;
  FInst: String[4];
  Aiipfactor:Real;   //20190215
  k, Gst, Pst: Real;
  Line5K, Line6K, Line7K: Real;
  Yr: String[4];
  TotalDays, DaysBeforeJuly1, DaysAfterJuly1: integer;
  StartLease, ENdLease: String;
  { StmList:TStringList; } MaxCCA: Real;
  BusPercent: Real;
Begin
  // ConvertOldAutoExpDates(RetNo,FNo);
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[3] := GetFirstName(RetNo);
  //  Strings[5] := GetSpouseFirstName(RetNo);  //20191225
    Strings[9] := GetFirstName(RetNo);

    i := 216;
    Repeat
      If Strings[i + 4] > '' then
        Tv[i] := 0;
      If Tv[i] > 100 then
        Tv[i] := 100;
      If Strings[i - 1] = '' then
        Tv[i] := 0; // no statement
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

    If (Vl(Strings[4]) = 0) and (Vl(Strings[7]) = 0) then
    begin
      Strings[4] := '1';
      Strings[7] := '1';
    end;
    If Vl(Strings[7]) < Vl(Strings[4]) then
      Strings[7] := Strings[4];

    For i := 0 to 0 do
    begin
      If Vl(Strings[7 + i]) > 0 then
        Tv[122 + i] := Tv[119 + i] * (Vl(Strings[4 + i]) / Vl(Strings[7 + i]))
      else
        Tv[122 + i] := 0;

      { Lease }
      Yr := LeftStr(Strings[57 + i], 4);
      StartLease := Strings[57 + i];
      ENdLease := Strings[60 + i];
      If (StartLease > '') and (ENdLease > '') then
        // TotalDays:=DateDiff(YYYY_mm_ddToMMDDYYYY(StartLease),YYYY_mm_ddToMMDDYYYY(EndLease));
        TotalDays := DateDiff(YMDtoDate(StartLease), YMDtoDate(ENdLease));
      // 20160119 Igor
      // DaysBeforeJuly1:=DateDiff(YYYY_mm_ddToMMDDYYYY(StartLease),YYYY_mm_ddToMMDDYYYY(MinString('2006-07-01',EndLease)));
      DaysBeforeJuly1 := DateDiff(YMDtoDate(StartLease),
        YMDtoDate(MinString('2006-07-01', ENdLease))); // 20160119 Igor
      // DaysAfterJuly1:=DateDiff(YYYY_mm_ddToMMDDYYYY(MaxString('2006-07-01',StartLease)),YYYY_mm_ddToMMDDYYYY(EndLease));
      DaysAfterJuly1 := DateDiff(YMDtoDate(MaxString('2006-07-01', StartLease)),
        YMDtoDate(ENdLease)); // 20160119 Igor

      If DaysBeforeJuly1 < 0 then
        DaysBeforeJuly1 := 0;
      If DaysAfterJuly1 < 0 then
        DaysAfterJuly1 := 0;
      Line5K := GetLine5K(Yr);
      Gst := Line5K * Tv[126 + i] / 100;
      Pst := Line5K * Vl(Strings[63 + i]) / 100;
      If Yr < '1991' then
      begin
        Gst := 0;
        Pst := 0;
      end;

      k := Line5K + Gst + Pst;
      Tv[78 + i] := MaxR(k, Tv[75 + i]) * 0.85;

      Line6K := GetLine6K(Yr);
      Gst := Line6K * Tv[126 + i] / 100;
      Pst := Line6K * Vl(Strings[63 + i]) / 100;
      If Yr < '1991' then
      begin
        Gst := 0;
        Pst := 0;
      end;
      k := Line6K + Gst + Pst;
      Tv[81 + i] := MaxR(0, ((k * Tv[72 + i]) / 30) - Tv[69 + i]);

      Line7K := GetLine7K(Yr);
      Gst := Line7K * Tv[126 + i] / 100;
      Pst := Line7K * Vl(Strings[63 + i]) / 100;
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
      If Vl(Strings[106 + i]) = 0 then
        Tv[109 + i] := 0;
      Tv[112 + i] := Vl(Strings[106 + i]) * Tv[109 + i];
      Tv[115 + i] := MinR(Tv[103 + i], Tv[112 + i]);

      { interest }
      If UpperCase(Strings[28]) <> 'Y' then
        Tv[19] := Tv[115];

      { Lease }
      If UpperCase(Strings[29]) <> 'Y' then
        Tv[16] := Tv[99];
      Tv[42 + i] := Tv[10 + i] + Tv[19 + i] + Tv[22 + i] + Tv[25 + i] +
        Tv[13 + i] + Tv[16 + i] + Tv[32 + i] + Tv[36 + i];
      If Vl(Strings[7 + i]) > 0 then
        Tv[45 + i] := Tv[42 + i] * (Vl(Strings[4 + i]) / Vl(Strings[7 + i]))
      else
        Tv[45 + i] := 0;
      Tv[54 + i] := MaxR(0, Tv[45 + i] + Tv[48 + i] + Tv[51 + i]);
    end;
    If Tv[109] = 0 then
      Tv[109] := 10; // 20140120

    // CCA
    i := 0;
    Strings[131] := Strings[1];

    If LeftStr(Strings[137], 4) = AppYear then
      Tv[140] := 0;
    Tv[191] := MaxR(0, Tv[140] - Tv[188]);

    Tv[149] := MaxR(0, Tv[143] - Tv[146]);
    // pst ??
    Tv[152] := Tv[149] * Tv[197] / 100;
    Tv[155] := Tv[149] * Tv[200] / 100;

    Tv[6] := Tv[149] + Tv[152] + Tv[155] + Tv[146]; // includes trade in
    Tv[8] := Tv[6] * (1 - Vl(Strings[4]) / Vl(Strings[7]));
    Tv[194] := Tv[6];
    // calc gst/pst for 34000
    If Strings[134] = '10.1' then
      Tv[194] := MinR(34000 + 34000 * Tv[197] / 100 + 34000 * Tv[200] /100, Tv[6]); //20230221
     // Tv[194] := MinR(30000 + 30000 * Tv[197] / 100 + 30000 * Tv[200] /100, Tv[6]);
    Tv[158] := Tv[194];

    //20190313
    if Strings[137]>'2018-11-20' then Strings[34]:='X';
    if Tv[26]>Tv[158] then Tv[26]:=Tv[158];

    if Strings[34]='' then begin Tv[26]:=0; Tv[27]:=0;Tv[33]:=0;Tv[30]:=0 end; //20190216

    // disp
    Tv[14] := Tv[15] * (1 - Vl(Strings[4]) / Vl(Strings[7]));
    Tv[17] := Tv[15] - Tv[14];
    Tv[18] := Tv[15];


    Strings[170] := '30';
    //------------------autos  -----------

    Tv[24] := Tv[191] + Tv[158] - Tv[18]; // ucc after additions/disposals
    Tv[27]:=MaxR(0,Tv[18]-Tv[158]+Tv[26]);  //20190215

    //Aiipfactor
    if Strings[134]='43.1' then Aiipfactor:=2.33333
    Else if Strings[134]='43.2' then Aiipfactor:=1
    Else if Strings[134]='53' then Aiipfactor:=1
    Else Aiipfactor:=0.5;
    Tv[33]:=AiiPFactor;

    Tv[30]:=MaxR(0,(Tv[26]-Tv[27])*Tv[33]);  //20190216

    Tv[164] := MaxR(0, Tv[158] -Tv[26]- Tv[18]) / 2;   //20190313
    // else Tv[164]:=0; //adj for additions
    If (Strings[182] > '') or (Tv[24] < 0) then
      Tv[164] := 0; // if class empty or recapture then no Adj
    Tv[167] := Tv[24] +Tv[30] - Tv[164]; // base for CCA
    Strings[170] := '30';

    //  --------  autos -------------
    MaxBusDays:=365; //20260321
    {
    // prorate for short years
    MaxBusDays := 0;
    // may 15 2008 Get MaxBusdays
    If Tv[216] > 0 then
      MaxBusDays := CalcBusDays(RetNo, Strings[215]);
    If Tv[222] > 0 then
    begin
      If CalcBusDays(RetNo, Strings[221]) > MaxBusDays then
        MaxBusDays := CalcBusDays(RetNo, Strings[221]);
    end;
    If Tv[228] > 0 then
    begin
      If CalcBusDays(RetNo, Strings[227]) > MaxBusDays then
        MaxBusDays := CalcBusDays(RetNo, Strings[227]);
    end;
    }

     // AUTOS CCA  //////////////////////
    //20260321
    If Tv[219]=0 then begin if Tv[216]=0 then tv[219]:=0 else Tv[219]:=MinR(1,GetShortYearFactor(RetNo));end;
    If Tv[225]=0 then begin if Tv[222]=0 then tv[225]:=0 else Tv[225]:=MinR(1,GetShortYearFactor(RetNo));end;
    If Tv[231]=0 then begin if Tv[217]=0 then tv[231]:=0 else Tv[231]:=MinR(1,GetShortYearFactor(RetNo));end;
    if Tv[219]>1 then Tv[219]:=1;
    if Tv[225]>1 then Tv[219]:=1;
    if Tv[231]>1 then Tv[231]:=1;
    ////////////////////////////////////

    If Strings[206] = '' then
    begin
      Tv[173] := Tv[167] * Vl(Strings[170]) / 100; //20260321  * MaxBusDays / 365; //Constant[RY].FullYear; //20260221 cca for the year
      // 20140324  //empty and 10.1 cca=50%
      If (Strings[134] = '10.1') and (Strings[182] > '') then Tv[173] := Tv[173] / 2;  //???
    end;

    // autos
    Maxbusdays:=365;  //20260321
    i := 215;
    Repeat
      If Strings[i] > '' then //statement is entered
      begin
         //BusDays := 365; //CalcBusDays(RetNo, Strings[i]); //20260321
         Tv[i + 3] := Tv[173] * (Tv[i + 1] / 100) * Tv[i+4]; // BusDays / MaxBusDays //20260321
         xx:=Tv[i+3];
        //else Tv[i + 3] := 0;
      end
      Else
      begin
        Tv[i + 2] := 0;
        Tv[i + 4] := 0;  //20260322
      end;
      Inc(i, 6);
    until i > 227;

    xx:=Tv[173];
    Tv[176] := Tv[24] - Tv[173] - Tv[178]; // uccend

    Tv[21] := 0; // terminal loss
    Tv[12] := 0; // recapture

    // recapture
    If Tv[24] < 0 then // recapture
    begin
      Tv[12] := ABS(Tv[24]);
      Tv[173] := 0;
      Tv[167] := 0; // base amount
      Strings[170] := ''; // rate
      Tv[176] := 0; // ending ucc
      If Strings[134] = '10.1' then
        Tv[12] := 0;
    end;

    If Strings[182] > '' then // class empty
    begin
      If Tv[173] > 0 then // Feb 23 2008
      begin
        Tv[21] := Tv[24]; // term loss
        If Strings[134] <> '10.1' then // 20140324
          Tv[173] := 0; // cca
        Tv[167] := 0; // base amount
        Strings[170] := ''; // rate
        Tv[176] := 0; // ucc end
        If Strings[134] = '10.1' then
          Tv[21] := 0;
      end;
    end;

    // summary
    // Tv[122]:=Tv[173];
    Tv[90] := Tv[54];
    Tv[93] := Tv[173] * Vl(Strings[4]) / Vl(Strings[7]);
    Tv[185] := Tv[90] + Tv[93];

{
    //20260322 - already done , but also not applicable any longer, using user input instead

    i := 215;
    Repeat
      If Strings[i] > '' then
      begin
        BusDays := CalcBusDays(RetNo, Strings[i]);
        Tv[i + 2] := Tv[54] * Tv[i + 1] / 100;

        If MaxBusDays > 0 then
          Tv[i + 3] := Tv[93] * (Tv[i + 1] / 100) * BusDays / MaxBusDays
          // may 26 2008
        else
          Tv[i + 3] := 0;
      end
      Else
      begin
        Tv[i + 2] := 0;
        Tv[i + 3] := 0;
      end;
      Inc(i, 6);
    until i > 227;
}
  end; { End with }
  SaveTv(RetNo, FName, FNo);
  // Now recalc bus statements
  // RecalcBusStatements(RetNo); //,StmList);
  // StmList.Free;
End;

//20190202
Procedure AssetsB(RetNo: integer; FName: string; FNo: integer);
Var
  i, j: integer;
  FInst: String[4]; // k,Gst,Pst:real;
  { StmList:TStringList; } BPercent: Real;
  BusDays, MaxBusDays: integer;
  MaxCCA: Real;
  BStmFNo: integer;
  BstmFInst: String;
  BstmFName: String;
  AiiPFactor:real;
Begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    If Strings[10] = '' then
      Strings[10] := 'Y';
    If FInst > '#1' then
      Strings[10] := FetchElm(RetNo, 'ASSETSB#1', 10);

   i:=216;
   Repeat
    If Tv[i]>100 then Tv[i]:=100;
    If Strings[i-1]='' then Tv[i]:=0;  //no statement
    Tv[i+2]:=Tv[173] * Tv[i]/100;
    If IsSharedStatement(RetNo,Strings[i-1]) then Tv[i+3]:=Tv[i];
    Inc(i,6);
   until i>228;

    Tv[2] := Tv[216] + Tv[222] + Tv[228];
    Tv[11] := Tv[219] + Tv[225] + Tv[231];

    if Strings[137]>'2018-11-20' then begin Strings[41]:='X'; Strings[42]:='';end; //20190310

    // CCA
    Strings[131] := Strings[1];
    Tv[12] := Tv[30] + Tv[31] + Tv[32] + Tv[33] + Tv[34];
    Tv[8] := Tv[12] * Tv[4] / 100;
    Tv[158] := MaxR(0, Tv[12] - Tv[8]);

    if Strings[41]='' then begin Tv[37]:=0; Tv[38]:=0;Tv[40]:=0;Tv[39]:=0 end; //20190216


    Tv[14] := Tv[15] * Tv[4] / 100;
    Tv[17] := MaxR(0, Tv[15] - Tv[14]);

    Tv[18] := Tv[17]; // April 4 2008
    If Strings[13] = '' then
      Strings[170] := GetCCaRate(Strings[134]);

    // May 15, 2008  New calculation
    Tv[29] := Tv[191] + Tv[158] - Tv[18]; // ucc after additions/disposals

    if Tv[37]>Tv[158] then Tv[37]:=Tv[158];

    Tv[38]:=MaxR(0,Tv[18]-Tv[158]+Tv[37]);
    //Aiipfactor
    if Strings[134]='43.1' then Aiipfactor:=2.33333
    Else if Strings[134]='43.2' then Aiipfactor:=1
    Else if Strings[134]='53' then Aiipfactor:=1
    Else Aiipfactor:=0.5;
    Tv[40]:=AiiPFactor;
    Tv[39]:=MaxR(0,(Tv[37]-Tv[38]) * AiipFactor);  //20190216

    Tv[164] := MaxR(0, Tv[158] -Tv[37] - Tv[18]) / 2; //20190312
    If Strings[134] = '52' then Tv[164]:=0;  // no half year rule
    If (Strings[6] > '') or (Tv[29] < 0) then  Tv[164] := 0; // if class empty or recapture then no Adj

    Tv[167] := Tv[29] +Tv[39] - Tv[164]; // base for CCA
    If Strings[13] = '' then
      Strings[170] := GetCCaRate(Strings[134]);

    MaxBusDays := 365; // FIX logic //20260321
    //////////////////////
    //20260321
    If Tv[219]=0 then begin if Tv[216]=0 then tv[219]:=0 else Tv[219]:=MinR(1,GetShortYearFactor(RetNo));end;
    If Tv[225]=0 then begin if Tv[222]=0 then tv[225]:=0 else Tv[225]:=MinR(1,GetShortYearFactor(RetNo));end;
    If Tv[231]=0 then begin if Tv[217]=0 then tv[231]:=0 else Tv[231]:=MinR(1,GetShortYearFactor(RetNo));end;
    if Tv[219]>1 then Tv[219]:=1;
    if Tv[225]>1 then Tv[219]:=1;
    if Tv[231]>1 then Tv[231]:=1;
    ////////////////////////////////////
    {
    MaxBusDays := 0;
    // may 15 2008 Get MaxBusdays
    If Tv[216] > 0 then
      MaxBusDays := CalcBusDays(RetNo, Strings[215]);
    If Tv[222] > 0 then
    begin
      If CalcBusDays(RetNo, Strings[221]) > MaxBusDays then
        MaxBusDays := CalcBusDays(RetNo, Strings[221]);
    end;
    If Tv[228] > 0 then
    begin
      If CalcBusDays(RetNo, Strings[227]) > MaxBusDays then
        MaxBusDays := CalcBusDays(RetNo, Strings[227]);
    end;
    }
    // prorate for short years
    If Strings[206] = '' then
    begin
       Tv[177] := Tv[167] * Vl(Strings[170]) / 100 * MaxBusDays / 365; //20260321
     // Tv[177] := Tv[167] * Vl(Strings[170]) / 100 * MaxBusDays / Constant[RY].FullYear; // cca for the year
      xx:=Tv[177];
    end;

    Tv[16] := 0; // terminal loss
    Tv[19] := 0; // recapture
    Tv[173] := Tv[177];
    Tv[176] := Tv[29] - Tv[173]; // uccend
    If Strings[28] > '' then
      Tv[176] := Tv[27]; // march 20 2008



    // recapture
    If Tv[29] < 0 then // recapture
    begin
      Tv[19] := ABS(Tv[29]);
      Tv[177] := 0;
      Tv[173] := 0;
      Tv[167] := 0; // base amount
      Strings[170] := ''; // rate
      Tv[176] := 0; // ending ucc
    end;
    // end may 15 2008

    If Strings[6] > '' then // term loss
    begin
      If Tv[177] > 0 then // Feb 23 2008
      begin
        Tv[16] := Tv[167]; // term loss
        Tv[177] := 0; // cca
        Tv[173] := 0; // cca
        Tv[167] := 0; // base amount
        Strings[170] := ''; // rate
        Tv[176] := 0; // ucc end
      end;
    end;

    i := 215;
    Repeat
      If Strings[i] > '' then
      begin
        BusDays := 365; //CalcBusDays(RetNo, Strings[i]); //20260321
        If MaxBusDays > 0 then
          Tv[i + 3] := Tv[177] * (Tv[i + 1] / 100) * Tv[i+4] // BusDays / MaxBusDays //20260321
          // may 26 2008
        else
          Tv[i + 3] := 0;
      end
      Else
      begin
        Tv[i + 2] := 0;
        Tv[i + 3] := 0;
      end;
      Inc(i, 6);
    until i > 227;

    // 20110109
    If Strings[36] > '' then // record keeping only
    begin
      Tv[164] := 0;
      Tv[167] := 0;
      Tv[177] := 0;
      Tv[173] := 0;
      Tv[16] := 0;
      Tv[19] := 0;
      Tv[27] := 0;
      Tv[176] := Tv[29];
      Tv[218] := 0;
      Tv[224] := 0;
      Tv[230] := 0; // 20110326
    end;
  end; { End with }
  SaveTv(RetNo, FName, FNo);
  // Now recalc bus statements
  // RecalcBusStatements(RetNo); //,StmList);
  // StmList.Free;
End;

Procedure UsedFrm(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    //nothing
  end;
  SaveTv(RetNo,FName,FNo);
end;


Procedure PRVCR(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    If Tv[4]>1000 then Tv[4]:=1000;
  end;
  SaveTv(RetNo,FName,FNo);
end;


Procedure CalcUsedFrm(RetNo: integer);
Var
  i,FNo:Integer;FName:String;
  MyPageControl:TPageControl;
  MyTabSheet : TTabSheet;
begin
  EXIT;  //20240329
  FName:='USEDFRM';
  FNo:=GetFormNo(FName);
  Try
  //MyChild:=MainForm.ActiveMDIChild as TMyChild;
  MyPageControl:=GetChild(RetNo).Pages; //GetPageControl(MyChild);
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    For i:=1 to 30 do begin Strings[i]:='';end;
    For i:=0 to MyPageControl.PageCount-1 do
    begin
      MyTabSheet:=MyPageControl.Pages[i];
      If i<=30 then
        //if +1 is removed then the info screen is not included....
        Strings[i+1]:=MyTabSheet.Caption;
    end;
   // Strings[31]:=FormName;         //20130214
  end;
  SaveTv(RetNo,FName,FNo);
  Except
  end;
end;

Function IsFormElmInTfPropDynList(FName:String;Fld:Integer):Boolean;
//if on thec list the elm is NOT vtDollar
Var i:Integer;s:String;
Begin
 Result:=False;
 s:=RTrim(PaddR(Fname,10)+PaddR(IntToStr(fld),6));
 For i:=0 to T3PropDynList.Count-1 do
 begin
  If s=LeftStr(T3PropDynList[i],16) then begin Result:=True;Exit;end;
 end;
end;


Procedure TESTFRM(RetNo: integer; FName: String;FNo: integer);
Var i,Elm,ArrayNo:Integer;BoxesPerRow:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   //Array 1 math
   ArrayNo:=1;
   BoxesPerRow:=12; //GetDynamicBoxesPerRow(FName,???StrToInt(IntTostr(ArrayNo)+'0001'));
   Tv[1]:=0;
   Elm:=ArrayNo*10000+StrToInt('3'); //for field id 10003 on the first row i form
   For i:=0 to MaxDynamicElmsPerForm do
   begin
    Tv[1]:=Tv[1]+Vl(FetchElmFNo(RetNo,FNo,Elm));
    Elm:=Elm+BoxesPerRow;
   end;
   //Array 2 math
   ArrayNo:=2;
   BoxesPerRow:=2;
   Tv[29]:=0;
   Tv[30]:=0;
   Elm:=ArrayNo*10000+StrToInt('1'); //array comes as 1, 2 so elm s/b 10001, 10013 etc //first box '1'
   For i:=0 to MaxDynamicElmsPerForm do
   begin
    Tv[29]:=Tv[29]+Vl(FetchElmFNo(RetNo,FNo,Elm));
    Tv[30]:=Tv[30]+Vl(FetchElmFNo(RetNo,FNo,Elm+1));
    Elm:=Elm+BoxesPerRow;
   end;
  end;
 // StoreElm(RetNo,FNo,1,FormatFloat('#######.##',Tv[1]));
 SaveTv(RetNo,FName,FNo);   //20110131
end;


Procedure T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo:Integer);//20160310 Igor
Var j,Elm:Integer;
Begin
  Elm:= ArrayNo*10000+StrToInt('1'); //firstColumn
  If FetchElmFNo(RetNo,FNo,Elm)='' then
  begin
     For j:=1 to 4 do Begin StoreElm(RetNo,FNo,Elm+j,'');end;
  end;
end;

//20170325
procedure S11A(RetNo: integer; FName: String;FNo: integer);
const
  IncomeThreshhold = 258482; //20261006 Alex //253414; //jz2025update-rev1 //2025022  6235675; //221708;  //20231121

var
  i: Integer;
  x: Real;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   if IsQre(RetNo) = false then Tv[4]:=0;
   Tv[5]:=MaxR(0,Tv[1]+Tv[2]+Tv[3]-Tv[4]);

   Tv[6]:=GetTrustNetIncome(RetNo); //Vl(FetchElm(RetNo,'T3',256);

   strings[38] := '75';                   //jz2025update-rev1: added field for percent
   Tv[7]:=Tv[6] *vl(strings[38]) /100;

   if Tv[5]<Tv[7] then
   begin
    Tv[8]:=0;
    Tv[9]:=0;
   end;

   Tv[10]:=MinR(GetTrustNetIncome(RetNo), Tv[7]+Tv[8]+Tv[9]);
   Tv[11]:=MinR(Tv[5],Tv[10]);

   if IsQre(RetNo) = false then Tv[13]:=0;

   Tv[14]:=MaxR(0,Tv[11]+Tv[12]-Tv[13]);
   //Tv[15]:=Tv[14]; //let user chhose claim //20220325
   if Tv[15]>Tv[14] then  //20220325
   Begin
    Tv[15]:=Tv[14];
   End;
   //if Tv[16]>Tv[15] then Tv[16]:=Tv[15];
   //Tv[24]:=Tv[5]-Tv[15];   //c/f to next year  //20220325 //20261006 Alex


   Tv[17]:=MinR(200,Tv[15]);
   Tv[18]:=MaxR(0,Tv[15]-Tv[17]);

   strings[39] := '33';                  //jz2025update-rev1: added field for percent
   strings[40] := '29';                  //jz2025update-rev1: added field for percent
   strings[41] := '14'; //20261006 Alex //'14.5';                //jz2025update-rev1: update percentage as per form, added field for percent


   If (IsQre(RetNo)) or (IsQdt(RetNo)) then
   Begin
    Tv[19]:=Tv[18];
    //Tv[20]:=Tv[16]; //20261006 Alex
    //Tv[21]:=MaxR(0,Tv[19]-Tv[20]); //20261006 Alex

    Tv[22]:= GetTrustTxbl(RetNo);
    Tv[25]:= IncomeThreshhold; //221708; //20221128 //20230228
    Tv[26]:=MaxR(0,Tv[22]-Tv[25]);
    //20220325
    Tv[27]:=MinR(Tv[21],Tv[26]);
    Tv[28]:=Tv[27]* 33/100;
    Tv[29]:=MaxR(0,Tv[18]-Tv[27]);
   End
   Else   //other than GRE or QDT
   Begin   //other than GRE or QDT
    Tv[19]:=Tv[18];
    //Tv[20]:=Tv[16]; //20261006 Alex
    //Tv[21]:=MaxR(0,Tv[19]-Tv[20]); //20261006 Alex
    Tv[22]:= GetTrustTxbl(RetNo);
    Tv[25]:=IncomeThreshhold;  //20230228 216511; //202211125
    Tv[26]:=MaxR(0,Tv[22]-Tv[25]);
    Tv[27]:=Tv[21];

    Tv[28]:=Tv[27]*vl(strings[39])/100;       //jz2025update-rev1: added field for percent, populated above
    Tv[29]:=MaxR(0,Tv[18]-Tv[27]);
    Tv[30]:=Tv[29]*vl(strings[40])/100;       //jz2025update-rev1: added field for percent, populated above
    Tv[31]:=Tv[17];
    Tv[32]:=Tv[31]*vl(strings[41])/100;   	  //jz2025update-rev1: added field for percent, populated above
    Tv[33]:=Tv[28]+Tv[30]+Tv[32];
   End;

   Tv[30]:= Tv[29] * vl(strings[40])/100; 	//jz2025update-rev1: added field for percent, populated above
   Tv[31]:=Tv[17];
   Tv[32]:=Tv[31] * vl(strings[41])/100;	//jz2025update-rev1: added field for percent, populated above

   Tv[34]:=Tv[28]+Tv[30]+Tv[32];
   if UpperCase(Strings[35])='Y' then Tv[34]:=Tv[36];

 (*
   //20211210
   If (IsQre(RetNo)) or (IsQdt(RetNo)) then
   Begin
    Tv[19]:=Tv[18];
    Tv[20]:=Tv[16];
    Tv[21]:=MaxR(0,Tv[19]-Tv[20]);

    Tv[22]:= GetTrustTxbl(RetNo);
    Tv[25]:=216511; //202211125
    Tv[26]:=MaxR(0,Tv[22]-Tv[25]);

    Tv[27]:=MinR(Tv[21],Tv[26]);
    Tv[28]:=Tv[27]* 33/100;
    Tv[29]:=MaxR(0,Tv[18]-Tv[27]);
   End
   Else   //other than GRE or QDT
   Begin
    Tv[19]:=Tv[18];
    Tv[20]:=Tv[16];
    Tv[21]:=MaxR(0,Tv[19]-Tv[20]);
    Tv[22]:= GetTrustTxbl(RetNo);
    Tv[25]:=216511; //202211125
    Tv[26]:=MaxR(0,Tv[22]-Tv[25]);
    Tv[27]:=Tv[21];
    Tv[28]:=Tv[27];
    Tv[29]:=MaxR(0,Tv[18]-Tv[27]);

    Tv[30]:=Tv[29]*33/100;
    Tv[31]:=Tv[17];
    Tv[32]:=Tv[31]*15/100;
    Tv[33]:=Tv[28]+Tv[30]+Tv[32];
   End;

   Tv[30]:= Tv[29] * 29/100;
   Tv[31]:=Tv[17];
   Tv[32]:=Tv[31] * 15/100;
   Tv[34]:=Tv[28]+Tv[30]+Tv[32];
   if UpperCase(Strings[35])='Y' then Tv[34]:=Tv[36];
  *)
  end;
 SaveTv(RetNo,FName,FNo);   //20110131
end;


 //20170609
Procedure T1079(RetNo: integer; FName: String;FNo: integer);
Var i,T3FNo:Integer; EligForPlusOne:Boolean;
begin
  T3FNo:=GetFormNo('T3');
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   Strings[140]:=IntToStr(MyStrToInt(Strings[3])+MyStrToInt(Strings[4])+MyStrToInt(Strings[139])); //20220217
   Strings[5]:=FetchElmFNo(RetNo,T3FNo,1);
   if Strings[6]=''  then
     Strings[6]:=FetchElmFNo(RetNo,T3FNo,4)+' '+FetchElmFNo(RetNo,T3FNo,7)+' '
               +FetchElmFNo(RetNo,T3FNo,67)+' '+FetchElmFNo(RetNo,T3FNo,8); //address

   if Strings[7]='' then Strings[7]:=FormatDateTime('yyyy-mm-dd',Now);

   Strings[24]:=IntToStr(MyStrToInt(Strings[22])+MyStrToInt(Strings[23]));
   Strings[27]:=IntToStr(MyStrToInt(Strings[25])+MyStrToInt(Strings[26]));

   Strings[19]:=Strings[140];
   Strings[27]:=IntToStr(MyStrToInt(Strings[20])+MyStrToInt(Strings[26])+MyStrToInt(Strings[25]));

   if UpperCase(Strings[154])='Y' then eligForPlusOne:=True else eligForPlusOne:=False;

   if Strings[153]='Y' then  //20220217
   Begin
    Tv[34]:=Tv[28];
    Tv[35]:=Tv[30];
    Tv[36]:=Tv[29];
    Tv[37]:=Tv[35]+Tv[36];
    Tv[38]:=Tv[37];
    Tv[39]:=Tv[34]-Tv[38];
    Tv[40]:=Tv[39];
    Strings[41]:=Strings[19];
    If eligForPlusOne then Strings[41]:=IntToStr(MyStrToInt(Strings[19])+1);//20220217
    Tv[42]:=Tv[40]*vl(Strings[41]); //20220217//MyStrToInt(Strings[41]);
    Strings[43]:=Strings[27];
    if MyStrtoInt(Strings[43])>0 then
     Tv[44]:=Tv[42]/Vl(Strings[43])
    Else
     Tv[44]:=0;
    Tv[45]:=Tv[44];
    Tv[46]:=MaxR(0,Tv[39]-Tv[45]);
    end
   Else
   Begin
    Tv[34]:=0;
    Tv[35]:=0;
    Tv[36]:=0;
    Tv[37]:=0;
    Tv[38]:=0;
    Tv[39]:=0;
    Tv[40]:=0;
    Tv[42]:=0;
    Tv[44]:=0;
    Tv[45]:=0;
    Tv[46]:=0;
   End;

   //if UpperCase(Strings[153]) ='Y' then Strings[141]:='N';  //20220217

   if UpperCase(Strings[141]) ='Y' then
   Begin
    Strings[146]:='Y';
    Strings[143]:='Y';
    Strings[144]:='Y';
    Strings[145]:='Y';
   end
   Else
   Begin
    {
    Strings[146]:='N';
    Strings[143]:='N';
    Strings[144]:='N';
    Strings[145]:='N';
    }
   End;

   if UpperCase(Strings[146]) ='Y' then
   Begin
    Tv[24]:=Tv[22];
    Tv[60]:=TV[21];
    Tv[63]:=MaxR(0,Tv[24]-Tv[60]);
    Tv[71]:=Tv[63];
    Tv[72]:=Tv[28];
    Tv[73]:=MaxR(0,Tv[71]-Tv[72]);

    Strings[74]:=IntToStr(MyStrToInt(strings[26])+MyStrToInt(strings[25]));
    if MyStrToInt(Strings[74])>0 then Tv[75]:=Tv[73]/Vl(Strings[74]) else Tv[75]:=0; //20220217
    Tv[76]:=Tv[74]+Tv[75];
    Tv[77]:=Tv[73];
   End
   Else
   Begin
    Tv[24]:=0;
    Tv[60]:=0;
    Tv[63]:=0;
    Tv[71]:=0;
    Tv[72]:=0;
    Tv[73]:=0;
    Strings[74]:='';
    Tv[75]:=0;
    Tv[76]:=0;
    Tv[77]:=0;
   End;

   if UpperCase(Strings[143]) ='Y' then
   Begin
    Tv[78]:=Tv[28];
    Tv[79]:=Tv[22];
    Tv[91]:=tv[23];
    Tv[92]:=Tv[29];
    Tv[93]:=Tv[79]+Tv[91]+Tv[92];
    Tv[94]:=Tv[93];
    TV[95]:=Tv[78]-Tv[94];
    Tv[96]:=Tv[95];
    Strings[97]:=Strings[3];
    Tv[98]:=Tv[96]*Vl(Strings[97]);
    Strings[99]:=Strings[20];
    If Vl(strings[100])>0 then Tv[100]:=Tv[98]/Vl(Strings[99]) else Tv[100]:=0;
    Tv[101]:=Tv[100];
    Tv[142]:=MaxR(0,Tv[95]-Tv[101]);
   End
   Else
   Begin
    Tv[78]:=0;
    Tv[79]:=0;
    Tv[91]:=0;
    Tv[92]:=0;
    Tv[93]:=0;
    Tv[94]:=0;
    TV[95]:=0;
    Tv[96]:=0;
    Strings[97]:='';
    Tv[98]:=0;
    Strings[99]:='';
    Tv[100]:=0;
    Tv[101]:=0;
    Tv[142]:=0;
   end;


   if UpperCase(Strings[144]) ='Y' then
   Begin
    Tv[102]:=Tv[22];
    Tv[103]:=Tv[28];
    Tv[104]:=Tv[101]-Tv[103];
   end
   Else
   Begin
    Tv[102]:=0;
    Tv[103]:=0;
    Tv[104]:=0;
   end;

   if UpperCase(Strings[145]) ='Y' then
   Begin
    Tv[105]:=Tv[77];
    Tv[106]:=Tv[142];
    Tv[107]:=Tv[105]-Tv[106];
    tv[108]:=Tv[104];
    Tv[109]:=MaxR(0,Tv[107]-Tv[108]);
    Tv[110]:=Tv[109];
   end
   Else
   Begin
    Tv[105]:=0;
    Tv[106]:=0;
    Tv[107]:=0;
    tv[108]:=0;
    Tv[109]:=0;
    Tv[110]:=0;
   end;

   if UpperCase(Strings[86]) ='Y' then
   Begin
    Strings[147]:='Y';
    Strings[148]:='Y';
    Strings[149]:='Y';
    Strings[150]:='Y';
    Strings[151]:='Y';
    Strings[152]:='Y';
   End
   Else
   begin
    {
    Strings[147]:='N';
    Strings[148]:='N';
    Strings[149]:='N';
    Strings[150]:='N';
    Strings[151]:='N';
    Strings[152]:='N';
    }
   end;

   if UpperCase(Strings[147]) ='Y' then
   Begin
    Tv[47]:=Tv[32];
    Tv[48]:=Tv[31];
    Tv[49]:=Tv[47]-Tv[48];
    Tv[50]:=Tv[49];
    Strings[51]:=IntToStr(MyStrToInt(Strings[22])+1);
    Tv[52]:=Tv[50]*MyStrToInt(Strings[51]);
    Strings[53]:=Strings[25];
    if MyStrtoInt(Strings[53])>0 then
     Tv[54]:=Tv[52]/Vl(Strings[53])
    Else
     Tv[54]:=0;
    Tv[55]:=Tv[54];
    Tv[56]:=MaxR(0,Tv[49]-Tv[55]);
   end
   Else
   begin
    for i:=47 to 56 do begin Tv[i]:=0;Strings[i]:='';end;
   end;

   if UpperCase(Strings[148]) ='Y' then
   Begin
   Tv[57]:=Tv[28];
   Tv[58]:=Tv[32];
   Tv[59]:=Tv[33];
   //Tv[60]:=Tv[29];
   Tv[61]:=Tv[58]+Tv[59]; //+Tv[60];  //20220217
   Tv[62]:=Tv[61];
   Tv[155]:=Tv[57]-Tv[62];

   Tv[64]:=Tv[63];
   Strings[65]:=Strings[23];
   Tv[66]:=Tv[64]*MyStrToInt(Strings[65]);
   Strings[67]:=Strings[26];
   if MyStrtoInt(Strings[67])>0 then Tv[68]:=Tv[66]/MyStrToInt(Strings[67]) Else Tv[68]:=0;
   Tv[69]:=Tv[68];
   Tv[70]:=MaxR(0,Tv[155]-Tv[69]);
   //Tv[63]:=MaxR(0,Tv[57]-Tv[62]);
   end
   Else
   Begin
   Tv[57]:=0;
   Tv[58]:=0;
   Tv[59]:=0;
   Tv[60]:=0;
   Tv[61]:=0;
   Tv[62]:=0;
   Tv[155]:=0;
   Tv[64]:=0;
   Strings[65]:='';
   Tv[66]:=0;
   Strings[67]:='';
   Tv[68]:=0;
   Tv[69]:=0;
   Tv[70]:=0;
   end;

   //B
   if UpperCase(Strings[149]) ='Y' then
   Begin
    Tv[111]:=Tv[28];
    Tv[112]:=Tv[22];
    Tv[113]:=Tv[33];
    Tv[114]:=Tv[29];
    Tv[115]:=Tv[112]+Tv[113]+Tv[114];
    Tv[116]:=Tv[115];
    Tv[117]:=Tv[111]-Tv[116];
    Tv[118]:=Tv[117];
    Strings[119]:=Strings[3];
    Tv[120]:=Tv[118]*MyStrToInt(Strings[119]);
    Strings[121]:=Strings[20];
    if MyStrtoInt(Strings[121])>0 then Tv[122]:=Tv[120]/MyStrToInt(Strings[121]) Else Tv[122]:=0;
    Tv[123]:=Tv[122];
    Tv[124]:=MaxR(0,Tv[117]-Tv[23]);
   end
   Else
   Begin
    Tv[111]:=0;
    Tv[112]:=0;
    Tv[113]:=0;
    Tv[114]:=0;
    Tv[115]:=0;
    Tv[116]:=0;
    Tv[117]:=0;
    Tv[118]:=0;
    Strings[119]:='';
    Tv[120]:=0;
    Strings[121]:='';
    Tv[122]:=0;
    Tv[123]:=0;
    Tv[124]:=0;
  end;
  //D
   if UpperCase(Strings[150]) ='Y' then
   Begin
    Tv[125]:=Tv[32];
    Tv[126]:=Tv[22];
    Tv[127]:=MaxR(0,Tv[125]-Tv[126]);
   end
   Else
   Begin
    Tv[125]:=0;
    Tv[126]:=0;
    Tv[127]:=0;
   end;

   //E
   if UpperCase(Strings[151]) ='Y' then
   Begin
    Tv[128]:=Tv[22];
    Tv[129]:=Tv[28];
    Tv[130]:=MaxR(0,Tv[128]-Tv[129]);
   end
   Else
   Begin
    Tv[128]:=0;
    Tv[129]:=0;
    Tv[130]:=0;
   end;

   //F
   if UpperCase(Strings[152]) ='Y' then
   Begin
    Tv[131]:=Tv[56];
    Tv[132]:=Tv[70];
    Tv[133]:=Tv[127];
    Tv[134]:=MaxR(0,Tv[131]+Tv[132]-Tv[133]);
    Tv[135]:=Tv[124];
    Tv[136]:=Tv[130];
    Tv[137]:=MaxR(0,Tv[134]+Tv[135]-Tv[136]);
    Tv[138]:=Tv[137];

   end
   Else
   Begin
    Tv[131]:=0;
    Tv[132]:=0;
    Tv[133]:=0;
    Tv[134]:=0;
    Tv[135]:=0;
    Tv[136]:=0;
    Tv[137]:=0;
    Tv[138]:=0;
   end;



   //PART 4
   Tv[80]:=Tv[110];
   Tv[81]:=Tv[138];

   if UpperCase(Strings[86])='Y' then
     Tv[82]:=MinR(Tv[80],Tv[81])
   Else
     Tv[82]:=Tv[110];

   if UpperCase(Strings[87])='Y' then
   begin
    Tv[83]:=Tv[82];
    Tv[84]:=Vl(FetchElm(RetNo,'T1079WS',74));
    Tv[85]:=MaxR(0,Tv[83]-Tv[84]);
   end
   Else
   Begin
    Tv[83]:=0;
    Tv[84]:=0;
    Tv[85]:=Tv[82];
   End;
  end;
  SaveTv(RetNo,FName,FNo);
end;

 //20170609
Procedure T1079WS(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;T1079FNo:Integer;
begin
  T1079FNo:=GetFormNo('T1079');
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   if UpperCase(Strings[75])<>'Y' then
   Begin
    for i:=1 to 74 do begin Strings[i]:='';Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
    Exit
   End;

   Strings[1]:=FetchElmFNo(RetNo,T1079FNo,22);
   Strings[3]:=IntToStr(MyStrToInt(Strings[1])+MyStrToInt(Strings[2]));

   Strings[4]:=FetchElmFNo(RetNo,T1079FNo,25);
   Strings[6]:=IntToStr(MyStrToInt(Strings[4])+MyStrToInt(Strings[5]));

   Tv[9]:=Vl(FetchElmFNo(RetNo,T1079FNo,31));
   Tv[11]:=Vl(FetchElmFNo(RetNo,T1079FNo,32));

   if Tv[7] >Tv[10] then
   Begin
    Tv[14]:=Tv[10];
    Tv[15]:=Tv[7];
    Tv[16]:=Tv[14] * 1.1;
    Tv[17]:=MaxR(0,Tv[15]-Tv[16]);
    Tv[18]:=Tv[17];
    Tv[19]:=Tv[14]-Tv[18];
   end
   Else
   begin
    Tv[14]:=0;
    Tv[15]:=0;
    Tv[16]:=0;
    Tv[17]:=0;
    Tv[18]:=0;
    Tv[19]:=Tv[10];
   end;
   Tv[20]:=Tv[19];
   Tv[21]:=Tv[8];
   Tv[22]:=Tv[20]-Tv[21];
   Tv[23]:=Tv[22];
   Strings[24]:=IntToStr(MyStrToInt(Strings[3])+1);
   Tv[25]:=Tv[23]*MyStrToInt(Strings[24]);
   Strings[26]:=Strings[6];
   if Vl(Strings[26])>0 then
    Tv[27]:=Tv[25] / Vl(Strings[26])
   Else
    Tv[27]:=0;
   Tv[28]:=Tv[27];
   Tv[29]:=Tv[22]-Tv[28];

   //Part 2
   if UpperCase(FetchElmFNo(RetNo,T1079FNo,86))='Y' then
   Begin
    // A
    Tv[30]:=Tv[11];
    Tv[31]:=Tv[9];
    Tv[32]:=Tv[30]-Tv[31];
    Tv[33]:=Tv[32];
    Strings[34]:=IntToStr(MyStrToInt(Strings[1])+1);
    Tv[35]:=Tv[33] * MyStrToInt(Strings[34]);
    Strings[36]:=Strings[4];
    if Vl(Strings[36])>0 then
     Tv[37]:=Tv[35] / MyStrToInt(Strings[36])
    Else
     Tv[37]:=0;
    Tv[38]:=Tv[37];
    Tv[39]:=MaxR(0,Tv[32]-Tv[38]);
    // B
    if Tv[11]>Tv[20] then
    Begin
     Tv[40]:=Tv[20];
     Tv[41]:=Tv[11];
     Tv[42]:=Tv[12];
     Tv[43]:=Tv[41]+Tv[42];
     Tv[44]:=Tv[43];
     Tv[45]:=Tv[40]-Tv[44];

     Tv[46]:=Tv[45];
     Strings[47]:=Strings[2];
     Tv[48]:=Tv[46] * MyStrToInt(Strings[47]);
     Strings[49]:=Strings[5];
     Tv[50]:=Tv[48] * MyStrToInt(Strings[49]);
     Tv[51]:=Tv[50];
     Tv[52]:=MaxR(0,Tv[45]-Tv[51]);
    End
    Else
    Begin
     for i:=40 to 52 do begin Strings[i]:='';Tv[i]:=0;end;
    End;
   End
   Else
   Begin
    for i:=30 to 64 do begin Strings[i]:='';Tv[i]:=0;end;
   End;
   //C
   Tv[53]:=Tv[11];
   Tv[54]:=Tv[20];
   Tv[55]:=MaxR(0,Tv[53]-Tv[54]);

   //D
   Tv[56]:=Tv[39];
   Tv[57]:=Tv[52];
   Tv[58]:=Tv[56]+Tv[57];
   //Tv[59]:=??
   Tv[60]:=MaxR(0,Tv[58]-Tv[59]);
   Tv[61]:=Tv[60];
   //E
   Tv[62]:=Tv[29];
   Tv[63]:=Tv[61];
   Tv[64]:=MinR(Tv[62],Tv[63]);
   //part 3
   if UpperCase(FetchElmFNo(RetNo,T1079FNo,86))='Y' then
    Tv[65]:=Tv[64]
   Else
    Tv[65]:=Tv[29];

   Tv[67]:=Tv[65]*MyStrtOint(Strings[66]);
   if Vl(Strings[68])>0 then
     Tv[69]:=Tv[67] * MyStrToInt(Strings[68])
   Else
    Tv[69]:=0;
   Tv[70]:=Tv[69];
   Tv[71]:=Tv[65]-Tv[70];
   Tv[72]:=Tv[71];
   Tv[73]:=Tv[13];
   Tv[74]:=MinR(Tv[72],Tv[73]);
  end;
  SaveTv(RetNo,FName,FNo);
end;


//20241103
Procedure InitConstants; // federal
Var
  Cpi: Real;
begin
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

  {
  Constant[0].DivOtherThanElig := 9.0301; // 2024 //see CRA D1
  Constant[1].DivOtherThanElig := 9.0301; // 2024 //see CRA D1

  Constant[0].DivElig := 15.0198; // 2024   //see CRA D1
  Constant[1].DivElig := 15.0198; // 2024   //see CRA D1
  //designated by issuing corp after informing its shareholders
  }
  // 20150903   // FCA=Family CareGiver Amount

  (*
  Constant[0].FCAAmount := 2616; // 2024  See S5
  Constant[1].FCAAmount := 2616; // 2024  See S5

  // http://www.cra-arc.gc.ca/tx/rgstrd/papspapar-fefespfer/lmts-eng.html  RRSP etc limits
  // 20161129  http://www.taxtips.ca/rrsp/rrspcontributionlimits.htm
  // 2017  http://www.taxtips.ca/rrsp/rrspcontributionlimits.htm //20160505 Igor
  Constant[0].MoneyPurchaseLimit := 32490; //2024 //prifi
  Constant[1].MoneyPurchaseLimit := 32490; //2024 //prifi

  *)
  // s1
  Constant[0].Rate1 := '14.0'; //'14.5'; // 2026 //jz2025update-rev1:udpated as per form
  Constant[1].Rate1 := '14.0'; //'14.5'; // 2026

  Constant[0].Rate2 := '20.5'; // 2026
  Constant[1].Rate2 := '20.5'; // 2026
  Constant[0].Rate3 := '26'; // 2026
  Constant[1].Rate3 := '26'; // 2026
  Constant[0].Rate4 := '29'; // 2026
  Constant[1].Rate4 := '29'; // 2026
  Constant[0].Rate5 := '33'; // 2026
  Constant[1].Rate5 := '33'; // 2026

  Constant[0].Bracket1 := 58523; //57375; //2026 //jz2025update-rev1:udpated as per form
  Constant[1].Bracket1 := 58523; //57375; //2026
  Constant[0].Bracket2 := 117045; //114750; //2026 //jz2025update-rev1:udpated as per form
  Constant[1].Bracket2 := 117045; //114750; //2026
  Constant[0].Bracket3 := 181440; //177882; //2026 //jz2025update-rev1:udpated as per form
  Constant[1].Bracket3 := 181440; //177882; //2026
  Constant[0].Bracket4 := 258482; //253414; //2026 //jz2025update-rev1:udpated as per form
  Constant[1].Bracket4 := 258482; //253414; //2026

  Constant[0].BracketTax1 := 0; // 2026
  Constant[1].BracketTax1 := 0; // 2026
  Constant[0].BracketTax2 := 8193.22; //8319.38; //2026 //jz2025update-rev1:udpated as per form
  Constant[1].BracketTax2 := 8193.22; //8319.38; //2026
  Constant[0].BracketTax3 := 20190.23; //20081.25; //2026 //jz2025update-rev1:udpated as per form
  Constant[1].BracketTax3 := 20190.23; //20081.25; //2026
  Constant[0].BracketTax4 := 36932.93; //36495.57; //2026 //jz2025update-rev1:udpated as per form
  Constant[1].BracketTax4 := 36932.93; //36495.57; //2026
  Constant[0].BracketTax5 := 59275.11; //58399.85; //2026 //jz2025update-rev1:udpated as per form
  Constant[1].BracketTax5 := 59275.11; //58399.85; //2026
  Constant[0].DonPercent := 75; // 2024 ??
  Constant[1].DonPercent := 75; // 2024 ??


  // s9 line 346
  Constant[0].DonRate1 := 15.00; // 2024  ??
  Constant[1].DonRate1 := 15.00; // 2024  ??
  // s9 line 348
  Constant[0].DonRate2 := 29; // 2024    ??
  Constant[1].DonRate2 := 29; // 2024    ??
end;


//20180425
Procedure TX19(RetNo:integer;FName:string;FNo:integer);
//Var i,SomeFNo:Integer;IR,X:Real;
Begin
  LoadTv(RetNo,FName,FNo);
  With ret[RetNo].Frm[FNo] do
  begin
   If Strings[24]>'' then //prepare it
   begin
     Strings[1]:= FetchElm(RetNo,'T3',1); //GetLastName(RetNo)+', '+GetFirstName(RetNo);
     Strings[2]:=FetchElm(RetNo,'T3',4)+' '+
                 FetchElm(RetNo,'T3',7)+', '+
                 FetchElm(RetNo,'T3',67)+' '+
                 FetchElm(RetNo,'T3',8);

     Strings[3]:=FetchElm(RetNo,'T3',2);
     if FetchElm(RetNo,'T3',20)>'' then
        Strings[4]:=FetchElm(RetNo,'T3',20)
     Else
        Strings[4]:=FetchElm(RetNo,'T3',46);

     Strings[16]:='X';
     If Strings[18]='' then Strings[18]:= FormatDateTime('yyyy-mm-dd',Date);
   end;
  end;
  SaveTv(RetNo,FName,FNo);
End;

//20240310
Procedure S15(RetNo:integer;FName:string;FNo:integer); //20240129 Igor
Var i:Integer;
    FInst: string;
begin
 FInst := ExtractFormInst(FName);
 LoadTv (RetNo, Fname, FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
  //20250327
  Strings[62]:='T'+FetchElm(RetNo,'T3',2);
  Strings[69]:=FetchElm(RetNo,'T3',14);
  Strings[70]:=FetchElm(RetNo,'T3',17);
  Strings[63]:=FetchElm(RetNo,'T3',1);
 // if Strings[25]>'' then Strings[30]:='CAN';
  if GetYearEnd(Retno)<'2023-12-31' then
  begin
   for i:=1 to 4 do Strings[i]:=''; //20240314
  end;

  if Finst>'#1' then  //20240309
  Begin
   for i:=36 to 59 do Strings[i]:='';
  end;

  {
  if FInst>'#1' then
  Begin
   for i:=1 to 4 do
   Begin
   End;
  End;
  }
  //if Strings[25]='' then Strings[30]:='CAN';  //country

  if Strings[11]>'' then //if naural person then No other name  allowed
  Begin
      //natural person with sin
      Strings[15]:='';
      //bn
      Strings[22]:='';
      Strings[65]:='';
      //20250729
      Strings[23]:='';
      Strings[67]:='';

      Strings[20]:='';
      Strings[66]:='';

      Strings[21]:='';
      Strings[28]:='';

      Strings[24]:='';
      Strings[68]:='';
  End ;

  {
  Else
  Begin
   Strings[19]:='';
   Strings[18]:='';
  End;
  }

  if Strings[12]>'' then    //corp
  begin
    Strings[16]:=''; //first
    Strings[17]:=''; //last name
    Strings[19]:='';
    Strings[64]:='';
   //20250729
    Strings[23]:='';
    Strings[67]:='';

    Strings[20]:='';
    Strings[66]:='';

    Strings[21]:='';
    Strings[28]:='';

    Strings[24]:='';
    Strings[68]:='';
  end;

  if Strings[13]>'' then    //T3 TN
  begin
    Strings[23]:='X';
    Strings[16]:=''; //first
    Strings[17]:=''; //last name
     //sin
     Strings[22]:='';
     Strings[65]:='';
     Strings[19]:='';
     Strings[64]:='';

     Strings[20]:='';
     Strings[66]:='';

     Strings[21]:='';
     Strings[28]:='';

     Strings[24]:='';
     Strings[68]:='';
  end;

  if Strings[25]>'' then //canadian
  Begin
   Strings[60]:='';
  End;
 end;
 SaveTv (RetNo, Fname, FNo);
end;

Procedure T183TRUST(RetNo:integer;FName:string;FNo:integer);
Var i:Integer;T3FNo:Integer;
begin
 //20201215
 T3FNo:=GetFormNo('T3');
 LoadTv (RetNo, Fname, FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
  //20240329
  if Strings[17]+Strings[41]+ Strings[4]+ Strings[12]+ Strings[40]+ Strings[42]+ Strings[14]+
  Strings[13]+ Strings[43]+ Strings[44]+ Strings[45]=''
  then Strings[17]:='X';

  Strings[1]:=FetchElmFNo(RetNo,T3FNo,11);
  If Strings[1]='' then Strings[1]:=FetchElm(RetNo,T3FNo,9);
  Strings[3]:=LeftStr(FetchElmFNo(RetNo,T3FNo,2),8); //account 20220307

  Strings[9]:=AppYear;
  if UpperCase(LeftStr(Strings[35],1))='R' then
     Strings[9]:=Strings[9]+Uppercase(strings[35]); //20220324  AMENDED

  if UpperCase(Strings[39])='Y' then Strings[35]:=OptRec.Prp_RepresentativeId; //202302f28
  //if MasktheAccount(RetNo)=True then Strings[3]:=GetMaskedAccount(RetNo); //20230210
  Strings[28]:= FetchElmFNo(RetNo,T3FNo,1); //name of trust
  //Strings[33]:= ?? //athlete Where is the various types? T3RET VS ATHLETE etc?

  If FetchElmFNo(RetNo,T3FNo,136)>'' then  //option 1 Individual trustee
  Begin
   Strings[10]:= FetchElmFNo(RetNo,T3FNo,3)+' '+FetchElm(RetNo,T3FNo,53);  //nm
   Strings[34]:=FetchElmFNo(RetNo,T3FNo,5)+'-'+FetchElm(RetNo,T3FNo,6);   //tel
   Strings[2]:=FetchElmFNo(RetNo,T3FNo,4);                                 //str
   Strings[31]:=FetchElmFNo(RetNo,T3FNo,7);                                //city
   Strings[5]:=FetchElmFNo(RetNo,T3FNo,67);                                 //prov
   Strings[6]:=FetchElmFNo(RetNo,T3FNo,23);                               // country
   Strings[32]:=FetchElmFNo(RetNo,T3FNo,8);                               // postal
  end
  Else
  Begin
   Strings[10]:=FetchElmFNo(RetNo,T3FNo,143);
   Strings[34]:=FetchElmFNo(RetNo,T3FNo,62)+'-'+FetchElm(RetNo,T3FNo,63);
   Strings[2]:=FetchElmFNo(RetNo,T3FNo,64);
   Strings[31]:=FetchElmFNo(RetNo,T3FNo,65);
   Strings[5]:=FetchElmFNo(RetNo,T3FNo,66);
   Strings[6]:=FetchElmFNo(RetNo,T3FNo,73);
   Strings[32]:=FetchElmFNo(RetNo,T3FNo,74);
  End;


   If Strings[17]>'' then
   Begin
    Tv[15]:=Vl(FetchElmFNo(RetNo,T3FNo,126));  //lin 12
    Tv[16]:=Vl(FetchElmFNo(RetNo,T3FNo,256));  //lin 31
    Tv[18]:=Vl(FetchElmFNo(RetNo,T3FNo,272));  //lin 43
    Tv[19]:=Vl(FetchElmFNo(RetNo,T3FNo,314));  //lin 47
    Tv[22]:=Vl(FetchElmFNo(RetNo,T3FNo,323));  //lin 65
    Tv[23]:=Vl(FetchElmFNo(RetNo,T3FNo,324));  //lin 66 bal due
   end
   Else
   begin //20240326
    Tv[15]:=0; Tv[16]:=0;
    Tv[18]:=0; Tv[19]:=0;
    Tv[22]:=0; Tv[23]:=0;
   end;


   If Strings[4]>'' then //T3RCA
   Begin
    Tv[25]:=Vl(FetchElm(RetNo,'T3RCA',200));  //lin 44
    Tv[26]:=Vl(FetchElm(RetNo,'T3RCA',206));
    Tv[27]:=Vl(FetchElm(RetNo,'T3RCA',211));  //lin 52
   END;


   If Strings[12]>'' then //t3auth
   Begin
    Tv[29]:=Vl(FetchElm(RetNo,'T3ATH',53));
    Tv[30]:=Vl(FetchElm(RetNo,'T3ATH',55));
   end;

   If Strings[40]>'' then //t3d
   Begin
    Tv[29]:=Vl(FetchElm(RetNo,'T3D',48));
    Tv[30]:=Vl(FetchElm(RetNo,'T3D',55));
   end;

   If Strings[13]>'' then //t3agr
   Begin
    Tv[29]:=Vl(FetchElm(RetNo,'T3GR',62));
    Tv[30]:=Vl(FetchElm(RetNo,'T3GR',64));
   end;

   If Strings[41]>'' then //T3m
   Begin
    Tv[29]:=Vl(FetchElm(RetNo,'T3M',44));
    Tv[30]:=Vl(FetchElm(RetNo,'T3M',46));
   end;

   If Strings[42]>'' then //T3P
   Begin
    Tv[29]:=Vl(FetchElm(RetNo,'T3P',40));
    Tv[30]:=Vl(FetchElm(RetNo,'T3P',42));
   end;

   If Strings[14]>'' then //T3PRP
   Begin
    Tv[29]:=Vl(FetchElm(RetNo,'T3PRP',42));
    Tv[30]:=Vl(FetchElm(RetNo,'T3PRP',44));
   end;

   If Strings[43]>'' then //T3RIP
   Begin
    Tv[29]:=Vl(FetchElm(RetNo,'T3RI',39));
    Tv[30]:=Vl(FetchElm(RetNo,'T3RI',41));
   end;

   If Strings[44]>'' then //T3S
   Begin
    Tv[29]:=Vl(FetchElm(RetNo,'T3S',42));
    Tv[30]:=Vl(FetchElm(RetNo,'T3S',44));
   end;

   if (strings[17]>'') then  //20240327
   Begin
     //remove SP return amounts if selection is the main T3 ret
     Tv[25]:=0;TV[26]:=0;Tv[27]:=0;Tv[29]:=0;Tv[30]:=0;
   End;
   if Strings[4]>'' then  begin Tv[29]:=0;Tv[30]:=0; end
   Else  Begin  Tv[25]:=0;TV[26]:=0;Tv[27]:=0;  End;
   If (strings[45]>'') then  //1061 then all zero
   Begin
    Tv[15]:=0; Tv[16]:=0; Tv[18]:=0; Tv[19]:=0; Tv[22]:=0; Tv[23]:=0;
    Tv[25]:=0;TV[26]:=0;Tv[27]:=0;Tv[29]:=0;Tv[30]:=0;
   End;



   //t1aut-ind
   {
   //Strings[12]
   //Strings[13]
   //Strings[14]
   Tv[29]:=Vl(FetchElm(RetNo,??T3FNo,126);  //lin 190
   Tv[30]:=Vl(FetchElm(RetNo,??T3FNo,126);  //lin 090
   }

   //part c
   //Strings[20]:= leave blank
    Strings[24]:=GetEolAgentNo;
   //20220120 Igor >>>
   //Part D
   If ((FetchElm(RetNo, 'STATUS', 22) <> '02') // not EF accepted
      and (FetchElm(RetNo, 'STATUS', 22) <> '04')) // not EF waiting ack
    then
    Begin
      If (GetEolAgentNo > '') then
      begin
       Strings[21] := GetDcnSeqNoEOL(RetNo, GetEolAgentNo); // replace it
      end;
    end;
    If Strings[8]='' then Strings[8]:=FormatDateTime('yyyy-mm-dd',Now);
    Strings[8]:=ReplaceChar(Strings[8],'/','-'); //20230326
    If Strings[11]='' then Strings[11]:='12:00:00';  //???
 end;
 SaveTv (RetNo, Fname, FNo);
end;


Procedure EFMEMO(RetNo:integer;FName:string;FNo:integer); //20211223
Var i:Integer;s:String;
begin
 LoadTv (RetNo, Fname, FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
  //20230208
  If Strings[2]='' then Strings[2]:='CONTACT_WITH_CLIENT';
  If Strings[3]='' then Strings[3]:='CONTACT_WITH_CLIENT';

  if Strings[56] = 'X' then Strings[56] := 'Y'; //20232612 //beacuse changed on the form from checkbox to Y/N, can remove next year 2024

  //20240302
  if strings[59]>'' then Strings[60]:='SECTION216_1' else Strings[60]:='';
  if strings[61]>'' then Strings[62]:='SECTION216_4' else Strings[62]:='';
  if strings[63]>'' then Strings[64]:='SECTION216_5' else Strings[64]:=''; end;
 SaveTv (RetNo, Fname, FNo);
end;

// 20240329
Procedure T3AO(RetNo: integer; FName: String; FNo: integer);
var
  i:integer;
  AmountOwing: Real;
  sin,s: String;
  AmountPaid: Real;
  AmountPaidString:String;
Begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  Begin
    Strings[8]:='T'+FetchElm(RetNo,'T3',2);
    Strings[1]:=Strings[8]; //bottom part

    AmountOwing := vl(FetchElm(RetNo,'T3',324)); //ret[RetNo].Lnn[48500];
    if AmountOwing<=1 then
    Begin
     for i:=1 to 23 do begin Tv[i]:=0;Strings[i]:='';end;
     Exit;
    End;

    Tv[11]:=AmountOwing;
    AmountPaid := Tv[23];// vl(Strings[11]); // 20180319
    //If AmountPaid > AmountOwing then AmountPaid := AmountOwing;
      //Strings[11] := FormatFloat('#,###,###,0.00', AmountPaid);
    //Strings[23] := justright(FormatFloat('#,###,###.00', AmountPaid), 13);

    // bottom part
    Tv[2]:=Amountpaid;
    Tv[12]:=AmountOwing - AmountPaid;

    Strings[1] := Strings[8]; // GetSinNo(RetNo); //20180310 CON 9:54 PM
    Strings[4] := '01';
   // sin:=ReplaceChar(Strings[8],'-','');  //leftStr(ReformatSinWithSpaceInBetween(Strings[8]),8);//already spaces
    AmountPaidString:=FormatFloat('#######', AmountPaid);
    {
    s := '0100090001000700'
        + AddLeadingZeros('T'+MidStr(strings[8],2,8), 15)
        +'00000000'
        + AddLeadingZeros(AmountPaidString, 10)   //+ AddLeadingZeros(IntToStr(Trunc(AmountPaid * 100)), 10)
        + '010009';
     Strings[10] := s + CalcCheckDigitForT3AOOCR(s);
    }

   (*T1
    s := '0100090001000700' + AddLeadingZeros(FetchElm(RetNo, 'INFO', 3), 15) +
      '00000000' + AddLeadingZeros(IntToStr(Trunc(AmountPaid * 100)), 10)
      + '010009';
    Strings[10] := s + CalcCheckDigitForT7DROCR(s);
    *)
    Strings[10] := s + CalcCheckDigitForT3AOOCR(s);  //20240329
    //Strings[10] := s + CalcCheckDigitForT7DROCR(s);
    //Strings[2] := justright(FormatFloat('#,###,###.00', AmountPaid), 13);
    //Strings[12] := justright(FormatFloat('#,###,###.00', AmountOwing), 13);
  End;
  SaveTv(RetNo, FName, FNo);
End;

(*
 Procedure populateTestCasesJSON(RetNo: integer; FName: String; FNo: integer);
 var

  json         : ISuperObject;
  node         : ISuperObject;
  item         : IMember;

  openDialogD  : TOpenDialog;

 begin

  openDialogD := TOpenDialog.Create(nil); // Create the open dialog object - assign to our open dialog variable
  openDialogD.InitialDir := 'C:\Users\suppo\Documents\CRA specs\VT-2023-For T1-2023-T2-2024-et\T3-2023\Test Cases'; //GetCurrentDir; // Set up the starting directory to be the current one
  openDialogD.Options := [ofFileMustExist]; // Only allow existing files to be selected

  openDialogD.Filter := 'JSON|*.JSON'; //Allow only .dpr and .pas files to be selected

  openDialogD.FilterIndex := 2; // Select pascal files as the starting filter type

  // Display the open file dialog
  if openDialogD.Execute
  then ShowMessage('File : '+openDialogD.FileName)
  else ShowMessage('Open file was cancelled');

  json := TSuperObject.ParseFile(openDialogD.FileName, TRUE);

  openDialogD.Free;  //Free up the dialog

{
  for item in json['follows.nodes'].AsArray do
  begin
    node := item.AsObject;
    ShowMessage(node.S['username']);
  end;
 }

 end;

procedure ParseJSON;
var
  JSONText: string;
  JSON: ISuperObject;
begin
  // Retrieve JSON as a string into JSONText variable any way you like.
  JSON := SO(JSONText);
  ProcessObject(JSON.AsObject);
end;

procedure ProcessObject(const aAsObject: TSuperTableString; const aPrefix: string = '');
var
  Names: ISuperObject;
  Name: string;
  Items: ISuperObject;
  Item: ISuperObject;
  idx: Integer;
  Value: string;
  ArrayItem: ISuperObject;
begin
  if Assigned(aAsObject) then
  begin
    Names := aAsObject.GetNames;
    Items := aAsObject.GetValues;

    for idx := 0 to Items.AsArray.Length - 1 do
    begin
      Name := Names.AsArray[idx].AsString;
      Item := Items.AsArray[idx];
      if Item.DataType = stObject then
        Value := '<Object>'
      else if Item.DataType = stArray then
        Value := '<Array>'
      else
        Value := Item.AsString;

      if SameText(Name, 'id') then
        WriteLn(Format('%s: %s', [aPrefix + Name, Value]));

      if Item.DataType = stArray then
        for ArrayItem in Item do
          ProcessObject(ArrayItem.AsObject, aPrefix + Name + '.');

      if Item.DataType = stObject then
        ProcessObject(Item.AsObject, aPrefix + Name + '.');
    end;
  end;
end;
 *)


Procedure T3M(RetNo:integer;FName:string;FNo:integer);   //20211111 Igor
var i,k: integer;
Begin
  LoadTv(RetNo,FName,FNo);
  With ret[RetNo].Frm[FNo] do
  begin
   Tv[1]:= GetTrustTxbl(RetNo);
   Strings[69] := ifAmendedPopulateInitialRevNum(RetNo,FName); //jz//20260318
   If Strings[56]='' then Strings[56]:= FormatDateTime('yyyymmdd',Date);
   Strings[49] := Strings[41];
   Strings[50] := Strings[41];
   Tv[41] := vl(Strings[41]);
   Tv[49] := Tv[41];
   Tv[50] := Tv[41];
   Tv[42] := Tv[41] * 0.15;
   Strings[42] := FormatFloat('#0.00',Tv[42]);
   Tv[51] := vl(Strings[51]);
   Tv[43] := Tv[41] * Tv[51]/100;
   Strings[43] := FormatFloat('###.##',Tv[43]);
   Tv[44] := Tv[42] + TV[43];
   Strings[44] := FormatFloat('###.##',Tv[44]);
   TV[45] := vl(Strings[45]);
   TV[46] := Tv[44] - Tv[45];
   Strings[46] := FormatFloat('###.##',Tv[46]);
  end;
  SaveTv(RetNo,FName,FNo);
end;
//20260209 Igor >>>
procedure T3S(RetNo: Integer; FName: string; FNo: Integer); //20211111 Igor
var
  i, k: Integer;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    Strings[52] := ifAmendedPopulateInitialRevNum(RetNo,FName); //jz//20260318

    Tv[41]:= Round(Vl(FetchElm(RetNo, 'T2000', 174))); //Vl(FetchElm(RetNo, 'T2000', 174)) //20260209 Igor
    Tv[42]:= Vl(FetchElm(RetNo, 'T2000', 168)) + Vl(FetchElm(RetNo, 'T2000', 169)) + Vl(FetchElm(RetNo, 'T2000', 170)) + Vl(FetchElm(RetNo, 'T2000', 171)); //20260209 Igor //Tv[41];
    Tv[44]:= Tv[42] - Tv[43];
  end;

  SaveTv(RetNo, FName, FNo);
end;


//20260209 Igor <<<
//20251107 Igor >>>
procedure T3RI(RetNo: Integer; FName: string; FNo: Integer);
var
  i, k: Integer;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    Strings[244] := ifAmendedPopulateInitialRevNum(RetNo,FName); //jz//20260318
    //Page 3
    Tv[133]:= 0;
    Tv[134]:= 0;
    for i:= 0 to 11 do
    begin
      k:= 6 * i;
      //Tv[62 + k]:= Tv[61 + k] * 0.01;


      xx:= (Tv[64 + k]);
      if (Tv[64 + k] = 0) then        //jz//20260305 - use TV but dfm was vtstrings so didnt work, change dfm to vtDollar for ease, probably should be stirngs tho so should change dfm to vtString and calc to strings one day
        Tv[65 + k]:= 0
      else
        Tv[65 + k]:= Round(Tv[63 + k] / Tv[64 + k]);// * 100; //20260209 Igor

      xx:= (Tv[63 + k]);
      xx:= (Tv[64 + k]);
      xx:= (Tv[65 + k]);
      xx:= Round(Tv[63 + k] / Tv[64 + k]);// * 100; //20260209 Igor

      Tv[66 + k]:= Tv[61 + k] * Tv[65 + k] / 100;
      Tv[134]:= Tv[134] + Tv[66 + k];
      //Tv[133]:= Tv[133] + Tv[61 + k]; //jz//20260305 - why would 133 be the amount from 61?
    end;
    Tv[133]:= Tv[134] * 0.01; //jz//20260305 - as per form
    Tv[36]:= Tv[133];

    //Page 4
    Tv[231]:= 0;
    for i:= 0 to 1 do
    begin
      k:= 4 * i;
      Tv[138 + k]:= MaxR(Tv[136 + k] - Tv[137 + k], 0);
      Tv[231]:= Tv[231] + Tv[138 + k];
    end;
    Tv[232]:= Tv[231] * 0.01;
    Tv[37]:= Tv[232];

    Tv[233]:= 0;
    for i:= 0 to 1 do
    begin
      k:= 4 * i;
      Tv[186 + k]:= MaxR(Tv[184 + k] - Tv[185 + k], 0);
      Tv[233]:= Tv[233] + Tv[186 + k];
    end;
    Tv[234]:= Tv[233] * 0.01; //20260209 Igor
    Tv[38]:= Tv[234];

    Tv[39]:= Tv[36] + Tv[37] + Tv[38];
    Tv[41]:= Tv[39] - Tv[40];
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20251107 Igor <<<

Procedure T3D(RetNo:integer;FName:string;FNo:integer);   //20211111 Igor
var i,k: integer; ss:string;
Begin
  LoadTv(RetNo,FName,FNo);
  With ret[RetNo].Frm[FNo] do
  begin

    Strings[340] := ifAmendedPopulateInitialRevNum(RetNo,FName); //jz//20260318

    //20240118 Igor >>>
    Tv[70]:=Tv[60]+Tv[63]+Tv[66]+Tv[69];

    Tv[83]:=Tv[73]+Tv[76]+Tv[79]+Tv[82];

    Tv[88]:=Tv[86]-Tv[87];
    Tv[93]:=Tv[91]-Tv[92];
    Tv[98]:=Tv[96]-Tv[97];
    Tv[103]:=Tv[101]-Tv[102];
    Tv[104]:=Tv[88]+Tv[93]+Tv[98]+Tv[103];

    Tv[109]:=Tv[107]-Tv[108];
    Tv[114]:=Tv[112]-Tv[113];
    Tv[119]:=Tv[117]-Tv[118];
    Tv[124]:=Tv[122]-Tv[123];
    Tv[129]:=Tv[127]-Tv[128];
    Tv[134]:=Tv[132]-Tv[133];
    Tv[139]:=Tv[137]-Tv[138];
    Tv[140]:=Tv[109]+Tv[114]+Tv[119]+Tv[124]+Tv[129]+Tv[134]+Tv[139];

    Tv[141]:=Tv[104]-Tv[140];
    Tv[142]:=Tv[141]*50/100;

    Tv[267]:=Tv[265]+Tv[266];
    Tv[273]:=Tv[271]+Tv[272];
    Tv[279]:=Tv[277]+Tv[278];
    Tv[285]:=Tv[283]+Tv[284];
    Tv[291]:=Tv[289]+Tv[290];
    Tv[297]:=Tv[295]+Tv[296];
    Tv[303]:=Tv[301]+Tv[302];
    Tv[309]:=Tv[307]+Tv[308];
    Tv[315]:=Tv[313]+Tv[314];
    Tv[321]:=Tv[319]+Tv[320];
    Tv[327]:=Tv[325]+Tv[326];
    Tv[333]:=Tv[331]+Tv[332];

    Tv[269]:=Tv[267]-Tv[268];
    Tv[275]:=Tv[273]-Tv[274];
    Tv[281]:=Tv[279]-Tv[280];
    Tv[287]:=Tv[285]-Tv[286];
    Tv[293]:=Tv[291]-Tv[292];
    Tv[299]:=Tv[297]-Tv[298];
    Tv[305]:=Tv[303]-Tv[304];
    Tv[311]:=Tv[309]-Tv[308];
    Tv[317]:=Tv[315]-Tv[316];
    Tv[323]:=Tv[321]-Tv[322];
    Tv[329]:=Tv[327]-Tv[328];
    Tv[335]:=Tv[333]-Tv[334];

    Tv[337]:=Tv[269]+Tv[275]+Tv[281]+Tv[287]+Tv[293]+Tv[299]+
             Tv[305]+Tv[311]+Tv[317]+Tv[323]+Tv[329]+Tv[335];
    Tv[338]:=Tv[270]+Tv[276]+Tv[282]+Tv[288]+Tv[294]+Tv[300]+
             Tv[306]+Tv[312]+Tv[318]+Tv[324]+Tv[330]+Tv[336];

    Tv[143]:=Tv[337];
    Tv[144]:=Tv[338];
    Tv[145]:=Tv[143]+Tv[144];
    Tv[146]:=Tv[145]*1/100;
    Tv[147]:=Vl(FetchElm(RetNo,'T2000',174));

    Tv[150]:=Tv[148]-Tv[149];
    Tv[153]:=Tv[151]-Tv[152];
    Tv[156]:=Tv[154]-Tv[155];
    Tv[159]:=Tv[157]-Tv[158];
    Tv[162]:=Tv[160]-Tv[161];
    Tv[165]:=Tv[163]-Tv[164];
    Tv[168]:=Tv[166]-Tv[167];
    Tv[171]:=Tv[169]-Tv[170];
    Tv[174]:=Tv[172]-Tv[173];
    Tv[177]:=Tv[175]-Tv[176];
    Tv[180]:=Tv[178]-Tv[179];
    Tv[183]:=Tv[181]-Tv[182];

    Tv[184]:=Tv[150]+Tv[153]+Tv[156]+Tv[159]+Tv[162]+Tv[165]+
             Tv[168]+Tv[171]+Tv[174]+Tv[177]+Tv[180]+Tv[183];
    Tv[185]:=Tv[184]*1/100;

    Tv[191]:=MinR(Tv[188],Tv[190]);
    Tv[197]:=MinR(Tv[194],Tv[196]);
    Tv[203]:=MinR(Tv[200],Tv[202]);
    Tv[209]:=MinR(Tv[206],Tv[208]);
    Tv[215]:=MinR(Tv[212],Tv[214]);

    Tv[216]:=Tv[191]+Tv[197]+Tv[203]+Tv[209]+Tv[215];

    Tv[222]:=Tv[219]-Tv[221];
    Tv[228]:=Tv[225]-Tv[227];
    Tv[234]:=Tv[231]-Tv[233];
    Tv[240]:=Tv[237]-Tv[239];
    Tv[246]:=Tv[242]-Tv[244];

    Tv[247]:=Tv[222]+Tv[228]+Tv[234]+Tv[240]+Tv[246];

    Tv[251]:=MaxR(Tv[249]-Tv[250],0);
    Tv[253]:=Tv[251]-Tv[252];
    Tv[254]:=Tv[253];
    Tv[255]:=Tv[248]-Tv[254];

    // summary
    Tv[42]:=Tv[70];
    Tv[43]:=Tv[83];
    Tv[44]:=Tv[142];
    Tv[45]:=Tv[146];
    Tv[46]:=Tv[147];
    Tv[47]:=Tv[185];

    Tv[48]:=Tv[42]+Tv[43]+Tv[44]+Tv[45]+Tv[46]+Tv[47];
    Tv[261]:=Tv[48]-Tv[49];
    Tv[50]:=Tv[216];
    Tv[51]:=Tv[247];
    Tv[52]:=Tv[255];
    Tv[53]:=Tv[50]+Tv[51]+Tv[52];
    Tv[54]:=Tv[53];
    Tv[55]:=Tv[261]-Tv[54];
    //20240118 Igor <<<

  end;
  SaveTv(RetNo,FName,FNo);
end;

(* //20240118 Igor
Procedure T3P(RetNo:integer;FName:string;FNo:integer);   //20211111 Igor
var i,k: integer;
Begin
  LoadTv(RetNo,FName,FNo);
  With ret[RetNo].Frm[FNo] do
  begin
   Tv[42]:=Tv[40]-Tv[41];
   Tv[44]:=Tv[42]-Tv[43];


  end;
  SaveTv(RetNo,FName,FNo);
end;
*)

//20240317
Procedure T3ATH(RetNo:integer;FName:string;FNo:integer);
var i,k: integer;
Begin
//20231201
LoadTv(RetNo,FName,FNo);
With ret[RetNo].Frm[FNo] do
begin
Strings[68] := ifAmendedPopulateInitialRevNum(RetNo,FName); //jz//20260318
Tv[47]:=Tv[45]+Tv[46];
Tv[48]:=Tv[47];
Tv[49]:=Tv[48]*2/3;
   Tv[50]:= Vl(FetchElm(RetNo,'T2000',172));
   Tv[51]:= Tv[50];
   Tv[52]:= Tv[49];
   Tv[53]:= Tv[51]+Tv[52];
   Tv[55]:=Tv[53]-Tv[54];
end;
SaveTv(RetNo,FName,FNo);
end;



Procedure T1159(RetNo:integer;FName:string;FNo:integer);   //20211111 Igor
var i,k: integer;
Begin
  LoadTv(RetNo,FName,FNo);
  With ret[RetNo].Frm[FNo] do
  begin
  end;
  SaveTv(RetNo,FName,FNo);
end;


Procedure T1061(RetNo:integer;FName:string;FNo:integer);   //jz T1061
var i,k: integer;
Begin
  LoadTv(RetNo,FName,FNo);
  With ret[RetNo].Frm[FNo] do
  begin

    Strings[43] := ifAmendedPopulateInitialRevNum(RetNo,FName); //jz//20260318

    //if strings[6] = '' then strings[6] := GetTrustNumber(); //FetchElm(RetNo,'T3',2);

    if strings[38] = '' then
    begin
      for i := 8  to 10 do strings[i]:='';
      for i := 12 to 15 do strings[i]:='';
      strings[17]:='';
    end;

    if strings[39] = '' then
    begin
      strings[16]:='';
      strings[11]:='';
      for i := 18 to 24 do strings[i]:='';
    end;

    if strings[40] = '' then
    begin
      for i := 25 to 31 do strings[i]:='';
    end;

  end;
  SaveTv(RetNo,FName,FNo);
end;



Procedure T3MJ(RetNo: Integer; FName: string; FNo: Integer);
var
  i, k, PrvNdx, HomePrvNdx, CurrentPrvNdx: Integer;
  T3FNo:Integer;
  NetIncome, SelfIncome, ExcessIncome, x,y, BfedTax: Real;
  NegExcessIncome:Real; //20230513
  NonHomePrvIncome: Real; // 20170422
  CurrentPrv: string[2];
  SelfEmplPrv: String;

  Prv: String;
  AllocPercent: Boolean; // 20170422
  OnLineNo, PassWord, Url, NetFileDir:String; //20220416

Begin
  //20260118
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
   (*
    //20260118
    If (IsEnterpriseVersion=True)then
    //ok
    //or (UpperCase(InputBox('Input Box', 'PSW', ''))='N/A') then //does not work
     //ok
    Else
     Strings[110]:=''; //202312  STOP MJ unless Enterprise //20231223
   *)
  {//20240322
    //20231223
    If (IsEnterpriseVersion=True)
    or (GetEfilerNo='B0865') then
     //ok
    Else
     Strings[110]:=''; //202312  STOP MJ unless Enterprise //20231223
  }

    If Frm[FNo].Strings[110]='' then  //no MJ
    Begin
     For i:=1 to 109 do Tv[i]:=0;  //20231202
     For i:=1 to 111 do Tv[i]:=0;  //20231202
     //For i:=1 to 243 do Tv[i]:=0;  //20231202
     SaveTv(RetNo, FName, FNo);
     Exit;
    end;

    {
    //If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'N/A' then exit;  //20230309
    End;
    }

    T3FNo:=GetFormNo('T3');  //20231203
    Tv[1] := Vl(FetchElmFNo(RetNo,T3FNo,256)); //Lnn[23600] + Vl(FetchElm(RetNo, 'T1206', 3));
    Tv[2] := MaxR(0,Vl(FetchElmFNo(RetNo,T3FNo,107))+Vl(FetchElmFNo(RetNo,T3FNo,109))); //20231226
    //Tv[3] := Tv[1] - Tv[2];
    x:=Tv[2];  //temp for debugging
    Tv[3] := MaxR(0, Tv[1] - Tv[2]); //20230513
    y:=Tv[3];
    If Tv[1] - Tv[2]<0 then NegExcessIncome:=ABS(Tv[1] - Tv[2]);  //20230513

    NetIncome := Tv[1];
    SelfIncome := Tv[2];
    ExcessIncome := Tv[3];

    if Frm[FNo].Strings[121] + Frm[FNo].Strings[122] = '' then
      Frm[FNo].Strings[122] := 'X';  //20240425 defaut to col not %

    AllocPercent := True;
    if Frm[FNo].Strings[122] > '' then AllocPercent := false;

    For i := 95 to 99 do
      Tv[i] := 0; // 20170423 //to 101 do Tv[i]:=0;  //totals

    // zeroout     //20170423
    i := 6;
    Repeat
      Tv[i] := 0;
      Inc(i, 7);
    until i > 90;

    For i := 76 to 78 do
      Tv[i] := 0;
    Tv[80] := 0; // For i:=75 to 78 do Tv[i]:=0; Tv[80]:=0;

    For i := 83 to 85 do
      Tv[i] := 0;
    Tv[87] := 0;

    For i := 104 to 106 do
      Tv[i] := 0;
    Tv[108] := 0;

    PrvNdx := GetPrvIndex(Province); // i.e. 1=nfld, 2:= pei, etc

    If ret[RetNo].Province = 'NL' then
      HomePrvNdx := 4;
    If ret[RetNo].Province = 'PE' then
      HomePrvNdx := 11;
    If ret[RetNo].Province = 'NS' then
      HomePrvNdx := 18;
    If ret[RetNo].Province = 'NB' then
      HomePrvNdx := 25;
    If ret[RetNo].Province = 'QC' then
      HomePrvNdx := 32;
    If ret[RetNo].Province = 'ON' then
      HomePrvNdx := 39;
    If ret[RetNo].Province = 'MB' then
      HomePrvNdx := 46;
    If ret[RetNo].Province = 'SK' then
      HomePrvNdx := 53;
    If ret[RetNo].Province = 'AB' then
      HomePrvNdx := 60;
    If ret[RetNo].Province = 'BC' then
      HomePrvNdx := 67;
    If ret[RetNo].Province = 'YT' then
      HomePrvNdx := 74;
    If ret[RetNo].Province = 'NT' then
      HomePrvNdx := 81;
    If ret[RetNo].Province = 'NU' then
      HomePrvNdx := 102;
    If ret[RetNo].Province = 'ZZ' then
      HomePrvNdx := 88;

    // 20170422
    if AllocPercent = false then
    Begin
      i := 4;
      Repeat
        if SelfIncome > 0 then
        Begin
          Tv[i] := 0;
        end;
        Inc(i, 7);
        If i = 95 then
          Inc(i, 7);
      until i > 102; //to include NU //88;
    end;


    //add percentages on non home province
   //20231227
    i := 4;
    x := 0;
    Tv[95] := 100;
    NonHomePrvIncome := 0;
    Repeat
     // If i = 95 then Inc(i, 7); // 20100415 //does not count only 102 for nunuvat and 88 outsite canada
      If i <> HomePrvNdx then x := x + Tv[i];
      If i <> HomePrvNdx then NonHomePrvIncome := NonHomePrvIncome + Tv[i + 1];
      Inc(i, 7);
    until i > 88; //88;
    // do fpr 102 Nunuvat
    i := 102;
    If i <> HomePrvNdx then x := x + Tv[i];
    If i <> HomePrvNdx then NonHomePrvIncome := NonHomePrvIncome + Tv[i + 1];

   (*
    //add percentages on non home province
    i := 4;
    x := 0;
    Tv[95] := 100;
    NonHomePrvIncome := 0;
    Repeat
      If i = 95 then Inc(i, 7); // 20100415 //does not count only 102 for nunuvat and 88 outsite canada
      If i <> HomePrvNdx then
        x := x + Tv[i];
      If i <> HomePrvNdx then
        NonHomePrvIncome := NonHomePrvIncome + Tv[i + 1];
      Inc(i, 7);
    until i > 102; //88;
   *)
    Tv[HomePrvNdx] := MaxR(0, 100 - x); // 20100415
    if AllocPercent = false then
      Tv[95] := 0;

    // 20180326
    i := 4;
    Tv[96] := 0;
    Repeat
      Tv[96] := Tv[i + 1];
      Inc(i, 7);
      If i = 95 then
        Inc(i, 7);
    until i > 88;
    Tv[96] := Tv[96] + Tv[103];

    // 20170422
    //calc amount i+1
    i := 4;
    Repeat
      If AllocPercent then  //use % instead of amount
      Begin
        Tv[i + 1] := SelfIncome * Tv[i] / 100;
        If i = HomePrvNdx then
          Tv[i + 2] := ExcessIncome
        else
          Tv[i + 2] := 0; // 20110125
        Tv[i + 3] := Tv[i + 1] + Tv[i + 2];

        Inc(i, 7);
        If i = 95 then
          Inc(i, 7);
      End
      Else // based on income
      begin
        If i = HomePrvNdx then
          Tv[i + 1] := MaxR(0, Tv[2] - NonHomePrvIncome);
        Tv[i] := 0;
        If i = HomePrvNdx then
          Tv[i + 2] := ExcessIncome
        else
          Tv[i + 2] := 0; // 20110125
        Tv[i + 3] := Tv[i + 1] + Tv[i + 2];

        Inc(i, 7);
        If i = 95 then
        Begin
           Inc(i, 7);
           Tv[96]:=Tv[96]-Tv[103]; //20180404 10PM
        End;
      end;
    until i > 102; //to include NU //88;



   // 20180413
    i := 5;
    Tv[96]:=0;
    Repeat
      Tv[96] := Tv[96] + Tv[i];
      Inc(i, 7);
    until i > 89;
    Tv[96]:=Tv[96]+Tv[103];

    //20230513 ===========Handle neg excess income ==============
    i:=4;
    Tv[98]:=0;
    Repeat
     if (Tv[i+1]>0) and (Tv[96]>0) then
       Tv[I+3]:=MaxR(0,Tv[i+3]-(NegExcessIncome *(Tv[i+1]/Tv[96])));
     Inc(i,7);
    Until i>88;
    //now NU for i:=102
    i:=102;
    if (Tv[i+1]>0) and (Tv[96]>0) then
      Tv[I+3]:=MaxR(0,Tv[i+3]-(NegExcessIncome *(Tv[i+1]/Tv[96])));
    //==================================================
    // 20180326
    i := 4;
    Repeat
      //20230513 Prepare % allocation for tax calculations
      //--------------------
      if (Tv[i] > 0) or (Tv[i+1] > 0) or (Tv[i+2] > 0) then   //MJjz20240115  If Tv[i] > 0 then  //20231227
       Frm[FNo].strings[i + 4] :=  FormatFloat('0.0000', (Tv[i + 3] / Tv[1]) * 100)
      else
       Frm[FNo].strings[i + 4] := '';

     //tempReal :=  (Tv[i + 3] / Tv[1]) * 100;

      //  ------------------------
      Tv[97] := Tv[97] + Tv[i + 2];
      Tv[98] := Tv[98] + Tv[i + 3];
      Tv[99] := Tv[99] + Tv[i + 4];
      Inc(i, 7);
      // If i=95 then Inc(i,7);
    until i > 88; // to include NU //88;
    //for NU  //20231227
    i:=102;
    if (Tv[i] > 0) or (Tv[i+1] > 0) or (Tv[i+2] > 0) then   //MJjz20240305 //If Tv[I] > 0 then
       Frm[FNo].strings[i + 4] :=  FormatFloat('0.0000', (Tv[i + 3] / Tv[1]) * 100)
    else
      Frm[FNo].strings[i + 4] := '';

    Tv[97] := Tv[97] + Tv[104];
    Tv[98] := Tv[98] + Tv[105];

    Frm[FNo].Strings[99] := '100.0000';

    //20190323
    Tv[96]:=0;
    Tv[96]:=Tv[96]+Tv[5]+Tv[12]+Tv[19]+Tv[26]+Tv[33]+Tv[40]+Tv[47]+Tv[54];
    Tv[96]:=Tv[96]+Tv[61]+Tv[68]+Tv[75]+Tv[82]+Tv[103]+Tv[89];


    //20190323
    Tv[96]:=0;
    Tv[96]:=Tv[96]+Tv[5]+Tv[12]+Tv[19]+Tv[26]+Tv[33]+Tv[40]+Tv[47]+Tv[54];
    Tv[96]:=Tv[96]+Tv[61]+Tv[68]+Tv[75]+Tv[82]+Tv[103]+Tv[89];

    Tv[94] := 0;

     // pg 3  //202312103
    with ret[RetNo].Frm[FNo] do
    begin
    For i := 231 to 243 do Tv[i] := 0;
    //20231201
     Tv[231] := Vl(FetchElm(RetNo, 'T3MJNL', 56));
     Tv[232] := Vl(FetchElm(RetNo, 'T3MJPE', 44));
     Tv[233] := Vl(FetchElm(RetNo, 'T3MJNS', 49));
     Tv[234] := Vl(FetchElm(RetNo, 'T3MJNB', 46)); //jz 20240219
     Tv[235] := Vl(FetchElm(RetNo, 'T3MJON', 56));
     Tv[236] := Vl(FetchElm(RetNo, 'T3MJMB', 53));
     Tv[237] := Vl(FetchElm(RetNo, 'T3MJSK', 64));
     Tv[238] := Vl(FetchElm(RetNo, 'T3MJAB', 56));
     Tv[239] := Vl(FetchElm(RetNo, 'T3MJBC', 64));
     Tv[240] := Vl(FetchElm(RetNo, 'T3MJYT', 46));
     Tv[241] := Vl(FetchElm(RetNo, 'T3MJNT', 46));
     Tv[242] := Vl(FetchElm(RetNo, 'T3MJNU', 46));
     Tv[243] := AddColumns(231, 242, 1);
    end;

    //Prov tax  bring from last page
    Tv[10] := TV[231]; //Vl(FetchElm(RetNo, 'T2203', 981));  // NF
    Tv[17] := Tv[232]; //Vl(FetchElm(RetNo, 'T2203', 982));  // PE
    Tv[24] := Tv[233]; //Vl(FetchElm(RetNo, 'T2203', 983));  // NS
    Tv[31] := Tv[234]; //Vl(FetchElm(RetNo, 'T2203', 984));  // NB
    Tv[38] := 0;                                  // QC
    Tv[45] := Tv[235]; //Vl(FetchElm(RetNo, 'T2203', 985));  // ON
    Tv[52] := TV[236]; //Vl(FetchElm(RetNo, 'T2203', 986));  // MB
    Tv[59] := Tv[237]; //Vl(FetchElm(RetNo, 'T2203', 987));  // SK
    Tv[66] := Tv[238]; //Vl(FetchElm(RetNo, 'T2203', 988));  // AB

    Tv[73] := Tv[239]; //Vl(FetchElm(RetNo, 'T2203', 989));  // BC
    Tv[80] := Tv[240]; //Vl(FetchElm(RetNo, 'T2203', 990));  // YT
    Tv[87] := Tv[241]; //Vl(FetchElm(RetNo, 'T2203', 991));  // NT
    Tv[108] := Tv[242]; //Vl(FetchElm(RetNo, 'T2203', 992)); // NU
    //total tax //20200411
    i:=10;
    Tv[117]:=0;
    Repeat
     Tv[117]:=Tv[117]+Tv[i];
     Inc(i,7);
    Until i>87;
    Tv[117]:=Tv[117]+Tv[108];
  end;

  // pg 2  //20231208
  with ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    //if income allocated to "OTHER"
    if Tv[91]>0 then //mjjz2024
    begin
      Tv[201] := Vl(FetchElm(RetNo,'S11',146)); //line 11
      Tv[202] :=Tv[201];
      // outside can
      Tv[203] := vl(strings[92]); //Tv[91]; //mjjz2024
      Tv[204] := Tv[202]*Vl(Strings[92])/100;
      strings[206] := '48';
      Tv[207] := Tv[204] * vl(strings[206]) / 100;
      // enter to S11 ????
    end
    else
    begin
     for i:=202 to 204 do Tv[i]:=0;
     for i:=206 to 207 do Tv[i]:=0;
    end;

    // qu abatement
    if Tv[35]>0 then //mjjz2024 //Tv[33]>0
    Begin
     Tv[208] := Tv[201];
     if SubjectToMinTax(RetNo) then Tv[208]:=Vl(FetchElm(RetNo,'S12',227));
     Strings[209] := Strings[36];
     Tv[210] := Tv[208] * Vl(Strings[209]) / 100;
     strings[211] := '16.5';  //mjjz2024
     Tv[212] := Tv[210] * vl(strings[211]) / 100;  //mjjz2024
    end
    Else
    begin
     for i:=208 to 212 do Tv[i]:=0;
    end;
  end; //with

  SaveTv(RetNo, FName, FNo);
End;

//20260209 Igor >>>
procedure T2000(RetNo: Integer; FName: string; FNo: Integer);
var
  i,k: Integer;
  totalSum: Real;

  procedure CalcIJKLMN(aI, aK, aKMax: Integer; aMode: Integer = 0); //20260209 Igor
  begin
    with Ret[RetNo].Frm[FNo] do
      repeat
        case aMode of
          0: Tv[aK]:= Tv[aI] * 0.01;
          1: Tv[aK]:= Tv[aI] - Tv[aI + 1];
          2: Tv[aK]:= MinR(Tv[aI], Tv[aI + 1]);
        end;
        Inc(aI, 13);
        Inc(aK, 13);
      until aK > aKMax;
  end;

  procedure CalcTotalIJKLMN(aK, aKMax, aResultIdx: Integer); //20260209 Igor
  begin
    totalSum:= 0;
    repeat
      totalSum:= totalSum + Ret[RetNo].Frm[FNo].Tv[aK];
      Inc(aK, 13);
    until aK > aKMax;
    Ret[RetNo].Frm[FNo].Tv[aResultIdx]:= totalSum;
  end;

begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    CalcIJKLMN(12, 19, 162, 0); //20260209 Igor //col I //i:= 12;k:= 19;repeat Tv[k]:= Tv[i] * 0.01; Inc(i, 13); Inc(k, 13); until k > 162;
    CalcIJKLMN(13, 20, 163, 0); //20260209 Igor //col J //i:= 13;k:= 20;repeat Tv[k]:= Tv[i] * 0.01;Inc(i, 13);Inc(k, 13);until k > 163;
    CalcIJKLMN(14, 21, 164, 0); //20260209 Igor //col K //i:= 14;k:= 21;repeat Tv[k]:= Tv[i] * 0.01;Inc(i, 13);Inc(k, 13);until k > 164;
    CalcIJKLMN(15, 22, 165, 1); //20260209 Igor //col L //i:= 15;k:= 22;repeat Tv[k]:= Tv[i] - Tv[i + 1];Inc(i, 13);Inc(k, 13);until k > 165;
    CalcIJKLMN(21, 23, 166, 2); //20260209 Igor //col M //i:= 21;k:= 23;repeat Tv[k]:= MinR(Tv[i], Tv[i + 1]);Inc(i, 13);Inc(k, 13);until k > 166;
    CalcIJKLMN(17, 24, 167, 1); //20260209 Igor //col N //i:= 17;k:= 24;repeat Tv[k]:= Tv[i] - Tv[i + 1];Inc(i, 13);Inc(k, 13);until k > 167;

    CalcTotalIJKLMN(19, 162, 168); //20260209 Igor //col I SUM //k:= 19;totalSum:= 0;repeat totalSum:= totalSum + Tv[k];Inc(k, 13);until k > 162;Tv[168]:= totalSum;
    CalcTotalIJKLMN(20, 163, 169); //20260209 Igor //col J SUM //k:= 20;totalSum:= 0;repeat totalSum:= totalSum + Tv[k];Inc(k, 13);until k > 163;Tv[169]:= totalSum;
    CalcTotalIJKLMN(23, 166, 170); //20260209 Igor //col M SUM //k:= 23;totalSum:= 0;repeat totalSum:= totalSum + Tv[k];Inc(k, 13);until k > 166;Tv[170]:= totalSum;
    CalcTotalIJKLMN(24, 167, 171); //20260209 Igor //col N SUM //k:= 24;totalSum:= 0;repeat totalSum:= totalSum + Tv[k];Inc(k, 13);until k > 167;Tv[171]:= totalSum;

    Tv[172]:= Round(Tv[168] + Tv[169] + Tv[170] + Tv[171]); //Tv[168] + Tv[169] + Tv[170] + Tv[171]; //20260209 Igor
    Tv[174]:= (Tv[168] + Tv[169] + Tv[170] + Tv[171]) - Tv[173];// Tv[172] - Tv[173]; //20260209 Igor
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20260209 Igor <<<

(*
Procedure T2000(RetNo:integer;FName:string;FNo:integer);   //20211111 Igor
var i,k: integer;
Begin
  LoadTv(RetNo,FName,FNo);
  With ret[RetNo].Frm[FNo] do
  begin
  end;
  SaveTv(RetNo,FName,FNo);
end;
*)


Function usedInMJ(RetNo: Integer;Fname:string):boolean;
begin
  if      (Fname = 'T3MJON') and (FetchElm(RetNo, 'T3MJ', 43)  > '' ) then result := true
  else if (Fname = 'T3MJAB') and (FetchElm(RetNo, 'T3MJ', 64)  > '' ) then result := true
  else if (Fname = 'T3MJBC') and (FetchElm(RetNo, 'T3MJ', 71)  > '' ) then result := true
  else if (Fname = 'T3MJMB') and (FetchElm(RetNo, 'T3MJ', 50)  > '' ) then result := true
  else if (Fname = 'T3MJNB') and (FetchElm(RetNo, 'T3MJ', 29)  > '' ) then result := true
  else if (Fname = 'T3MJNL') and (FetchElm(RetNo, 'T3MJ', 8)   > '' ) then result := true
  else if (Fname = 'T3MJNU') and (FetchElm(RetNo, 'T3MJ', 106) > '' ) then result := true
  else if (Fname = 'T3MJNS') and (FetchElm(RetNo, 'T3MJ', 22)  > '' ) then result := true
  else if (Fname = 'T3MJPE') and (FetchElm(RetNo, 'T3MJ', 15)  > '' ) then result := true
  else if (Fname = 'T3MJSK') and (FetchElm(RetNo, 'T3MJ', 57)  > '' ) then result := true
  else if (Fname = 'T3MJYT') and (FetchElm(RetNo, 'T3MJ', 78)  > '' ) then result := true
  else if (Fname = 'T3MJNT') and (FetchElm(RetNo, 'T3MJ', 85)  > '' ) then result := true
  else result := false;
end;


//20260302 Igor >>>
procedure S130(RetNo: Integer; FName: string; FNo: Integer);
var
  i, k: Integer;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    if (Strings[3] = '') or (Strings[4] <> '') then
    begin
      for i:= 7 to 22 do Strings[i]:= '';
      Tv[10]:= 0; Tv[14]:= 0; Tv[18]:= 0; Tv[22]:= 0;
    end;
    Tv[468]:= Tv[10] + Tv[14] + Tv[18] + Tv[22];

    if (Strings[5] = '') or (Strings[6] <> '') then
    begin
      for i:= 23 to 47 do Strings[i]:= '';
      for i:= 23 to 47 do Tv[i]:= 0;
    end;
    Tv[68]:= Tv[25] + Tv[30] + Tv[35] + Tv[40] + Tv[45];
    Tv[69]:= Tv[26] + Tv[31] + Tv[36] + Tv[41] + Tv[46];
    Tv[70]:= Tv[27] + Tv[32] + Tv[37] + Tv[42] + Tv[47];
    Tv[71]:= Tv[50] + Tv[55] + Tv[60] + Tv[65];
    Tv[72]:= Tv[51] + Tv[56] + Tv[61] + Tv[66];
    Tv[73]:= Tv[52] + Tv[57] + Tv[62] + Tv[67];
    Tv[90]:= Tv[76] + Tv[80] + Tv[84] + Tv[88];
    Tv[91]:= Tv[77] + Tv[81] + Tv[85] + Tv[89];

    Tv[97]:= Tv[94] - Tv[95] - Tv[96];
    Tv[103]:= Tv[100] - Tv[101] - Tv[102];
    Tv[109]:= Tv[106] - Tv[107] - Tv[108];
    Tv[115]:= Tv[112] - Tv[113] - Tv[114];
    Tv[121]:= Tv[118] - Tv[119] - Tv[120];
    Tv[127]:= Tv[124] - Tv[125] - Tv[126];
    Tv[128]:= Tv[97] + Tv[103] + Tv[109] + Tv[115] + Tv[121] + Tv[127];

    Tv[130]:= Tv[71];
    Tv[135]:= Tv[72];
    Tv[140]:= Tv[128];
    Tv[144]:= Tv[73];
    Tv[473]:= Tv[144] + Tv[145] + Tv[472];
    Tv[146]:= MinR(0, Tv[143] - Tv[473]);

    Tv[150]:= Tv[148] + Tv[149];
    Tv[157]:= Tv[155] + Tv[156];
    Tv[164]:= Tv[162] + Tv[163];
    Tv[171]:= Tv[169] + Tv[170];
    Tv[178]:= Tv[176] + Tv[177];

    i:= 151;
    while i <= 179 do
    begin
      if (Tv[pred(i)] > 0) then Tv[i]:= Tv[pred(i)];
      inc(i, 7);
    end;

    if (Tv[152] > Tv[150]) then Tv[152]:= Tv[150];
    if (Tv[159] > Tv[157]) then Tv[159]:= Tv[157];
    if (Tv[166] > Tv[164]) then Tv[166]:= Tv[164];
    if (Tv[173] > Tv[171]) then Tv[173]:= Tv[171];
    if (Tv[180] > Tv[178]) then Tv[180]:= Tv[178];
    Tv[182]:= Tv[151] + Tv[158] + Tv[165] + Tv[172] + Tv[179];
    Tv[183]:= Tv[152] + Tv[159] + Tv[166] + Tv[173] + Tv[180];

    Tv[132]:= Tv[183];
    Tv[134]:= Tv[182];

    if (Tv[151] = 0) then Tv[153]:= MaxR(0, Tv[150] - Tv[152]) else Tv[153]:= 0;
    if (Tv[158] = 0) then Tv[160]:= MaxR(0, Tv[157] - Tv[159]) else Tv[160]:= 0;
    if (Tv[165] = 0) then Tv[167]:= MaxR(0, Tv[164] - Tv[166]) else Tv[167]:= 0;
    if (Tv[172] = 0) then Tv[174]:= MaxR(0, Tv[171] - Tv[173]) else Tv[174]:= 0;
    if (Tv[179] = 0) then Tv[181]:= MaxR(0, Tv[178] - Tv[180]) else Tv[181]:= 0;

    Tv[186]:= Tv[184] + Tv[185];
    Tv[191]:= Tv[189] + Tv[190];
    Tv[196]:= Tv[194] + Tv[195];
    Tv[201]:= Tv[199] + Tv[200];
    Tv[206]:= Tv[204] + Tv[205];
    Tv[211]:= Tv[209] + Tv[210];
    Tv[216]:= Tv[214] + Tv[215];
    Tv[221]:= Tv[219] + Tv[220];
    Tv[226]:= Tv[224] + Tv[225];
    Tv[231]:= Tv[229] + Tv[230];

    if (Tv[187] > Tv[186]) then Tv[187]:= Tv[186];
    if (Tv[192] > Tv[191]) then Tv[192]:= Tv[191];
    if (Tv[197] > Tv[196]) then Tv[197]:= Tv[196];
    if (Tv[202] > Tv[201]) then Tv[202]:= Tv[201];
    if (Tv[207] > Tv[206]) then Tv[207]:= Tv[206];
    if (Tv[212] > Tv[211]) then Tv[212]:= Tv[211];
    if (Tv[217] > Tv[216]) then Tv[217]:= Tv[216];
    if (Tv[222] > Tv[221]) then Tv[222]:= Tv[221];
    if (Tv[227] > Tv[226]) then Tv[227]:= Tv[226];
    if (Tv[232] > Tv[231]) then Tv[232]:= Tv[231];

    Tv[188]:= Tv[186] - Tv[187];
    Tv[193]:= Tv[191] - Tv[192];
    Tv[198]:= Tv[196] - Tv[197];
    Tv[203]:= Tv[201] - Tv[202];
    Tv[208]:= Tv[206] - Tv[207];
    Tv[213]:= Tv[211] - Tv[212];
    Tv[218]:= Tv[216] - Tv[217];
    Tv[223]:= Tv[221] - Tv[222];
    Tv[228]:= Tv[226] - Tv[227];
    Tv[234]:= Tv[231] - Tv[232];

    Tv[235]:= Tv[187] + Tv[192] + Tv[197] + Tv[202] + Tv[207] + Tv[212] + Tv[217] + Tv[222] + Tv[227] + Tv[232];

    //Calc totals of Part 2A
    Tv[133]:= Tv[235];
    Tv[143]:= Tv[130] + Tv[131] + Tv[469] + Tv[470] + Tv[132] + Tv[133] + Tv[134] + Tv[135] + Tv[137] + Tv[138] + Tv[139] + Tv[471] + Tv[140] + Tv[141] + Tv[142];
    Tv[473]:= Tv[144] + Tv[145] + Tv[472];
    Tv[146]:= MaxR(0, Tv[143] - Tv[473]);

    //Part 2D Variable A
    Tv[238]:= Tv[90];
    Tv[243]:= Tv[129] + Tv[233] + Tv[236] + Tv[238] + Tv[239] + Tv[240] + Tv[241] + Tv[242];

    //Part 2D Variable B
    Tv[245]:= Tv[91];
    Tv[237]:= Tv[245] + Tv[246] + Tv[247] + Tv[248] + Tv[249] + Tv[250];
    Tv[251]:= MaxR(0, Tv[243] - Tv[237]);

    //Part 2E Variable A
    if (Tv[256] <> 0) then Tv[258]:= (Tv[261] * Tv[260]) / Tv[256];
    i:= 266;
    while i <= 284 do
    begin
      if (Tv[i - 4] <> 0) then Tv[i]:= (Tv[i - 2] * Tv[i - 1]) / Tv[i - 4];
      inc(i, 6);
    end;
    Tv[285]:= Tv[258] + Tv[266] + Tv[272] + Tv[278] + Tv[284];
    Tv[290]:= Tv[286] - (Tv[287] + Tv[474] + Tv[288] + Tv[289]); //20261006 Alex

    //Part 2E Variable B
    Tv[291]:= Tv[146];
    Tv[298]:= Tv[285];
    Tv[301]:= Tv[70];

    //Part 2E
    Tv[305]:= Tv[291] + Tv[292] + Tv[293] + Tv[295] + Tv[296] + Tv[297] + Tv[298] + Tv[299] + Tv[300] + Tv[301] + Tv[302] + Tv[303] + Tv[304];
    Tv[306]:= Tv[251];
    Tv[313]:= Tv[69];
    Tv[315]:= Tv[306] + Tv[307] + Tv[308] + Tv[309] + Tv[310] + Tv[311] + Tv[312] + Tv[313] + Tv[314];
    Tv[316]:= MaxR(0, Tv[290] + Tv[305] - Tv[315]);

    //Part 2F
    Tv[317]:= Tv[316];
    Tv[318]:= 30; //30% by the Note 3
    Tv[319]:= Tv[317] * (Tv[318] / 100);
    Tv[320]:= Tv[319];
    Tv[321]:= Tv[251];
    Tv[326]:= MinR(Tv[322], Tv[323]);
    Tv[325]:= 30; //30% by the Note 3
    Tv[324]:= Tv[326] * (Tv[325] / 100);
    Tv[327]:= Tv[324];
    Tv[328]:= Tv[321] - Tv[327];
    Tv[329]:= Tv[328];
    Tv[330]:= Tv[320] + Tv[329];
    Tv[331]:= Tv[146];
    Tv[332]:= maxr(0,Tv[330] - Tv[331]); //jz//20260304 - add maxr(0, ... is not on the form but test case makes it seem like should be

    //Part 2G
    Tv[336]:= Tv[146];
    Tv[338]:= Tv[316];
    Tv[339]:= 30; //30% by the Note 3
    Tv[340]:= Tv[338] * (Tv[339] / 100);
    Tv[341]:= Tv[251];
    if (Tv[337] <> 0) then Tv[342]:= Tv[341] + Tv[337] else Tv[342]:= Tv[341] + Tv[340];
    Tv[343]:= Tv[336] - Tv[342];

    //Part 2H
    Tv[354]:= Tv[345] + Tv[348] + Tv[351];
    Tv[355]:= Tv[346] + Tv[349] + Tv[352];
    Tv[356]:= Tv[347] + Tv[350] + Tv[353];
    Tv[357]:= Tv[354] + Tv[355] + Tv[356];
    Tv[358]:= Tv[334];
    Tv[359]:= Tv[357] + Tv[358];
    Tv[335]:= Tv[359];
    Tv[344]:= MinR(Tv[335], Tv[343]);
    Tv[361]:= Tv[344];
    Tv[362]:= Tv[359] - Tv[361];

    //Part 2I
    Tv[364]:= Tv[332];
    Tv[365]:= Tv[468];
    Tv[366]:= Tv[364] + Tv[365];
    Tv[367]:= MinR(Tv[363], Tv[366]);

    //Part 2J
    Tv[368]:= Tv[146];
    Tv[370]:= 30; //30% by the Note 3
    Tv[371]:= Tv[316];
    Tv[372]:= Tv[371] * (Tv[370] / 100);
    Tv[341]:= Tv[251];
    if (Tv[369] <> 0) then Tv[373]:= Tv[369] else Tv[373]:= Tv[372];
    Tv[374]:= Tv[251];
    Tv[375]:= Tv[468];
    Tv[376]:= Tv[367];
    Tv[377]:= MinR(0, Tv[375] - Tv[376]);
    Tv[378]:= Tv[344];
    Tv[379]:= Tv[143];
    //Tv[380]:= Tv[???]; //????
    if (Tv[379] <> 0) then Tv[381]:= Tv[379] else Tv[381]:= Tv[380];

    //jz//20260304 - change to string to capture decimal points
    //Tv[382]:= MaxR(0, (Tv[368] - (Tv[373] + Tv[374] + Tv[377] + Tv[378])) / Tv[381]);
    strings[382]:= FormatFloat( '#.####', MaxR(0, (Tv[368] - (Tv[373] + Tv[374] + Tv[377] + Tv[378])) / Tv[381]) );


    //Part 2K
    Tv[383]:= Tv[143];
    Tv[384]:= Tv[128];
    Tv[385]:= Tv[142];
    Tv[386]:= MaxR(0, Tv[383] - Tv[384] - Tv[385]);   //jz//20260304 - max not min
    //Tv[387]:= Tv[382];
    strings[387] := strings[382];                     //jz//20260304 - change to string to capture decimal points
    Tv[388]:= Tv[386] * vl(strings[387]); //Tv[387];  //jz//20260304 - change to string to capture decimal points

    //Part 2L
    //Tv[390]:= Tv[130]; //Line 1 of the Part 2A. Is it right, that we should use this line amount?
    //Tv[396]:= Tv[132]; //Line 2 of the Part 2A. Is it right, that we should use this line amount?
    //Tv[402]:= Tv[133]; //Line 3 of the Part 2A. Is it right, that we should use this line amount?
    //Tv[408]:= Tv[134]; //Line 4 of the Part 2A. Is it right, that we should use this line amount?
    //Tv[414]:= Tv[135]; //Line 5 of the Part 2A. Is it right, that we should use this line amount?
    //Tv[420]:= Tv[142]; //Line 7 of the Part 2A. Is it right, that we should use this line amount?

    i:= 391;
    while i <= 421 do
    begin
      if (Tv[pred(i)] <> 0) then strings[i]:= strings[382]; //Tv[i]:= Tv[382]; //jz//20260304 - change to string to capture decimal points
      inc(i, 6);
    end;

    i:= 392;
    while i <= 422 do
    begin
      Tv[i]:= Tv[i - 2] * vl(strings[i - 1]);  //Tv[i - 1]; //jz//20260304 - change to string to capture decimal points
      inc(i, 6);
    end;

    i:= 394;
    while i <= 424 do
    begin
      Tv[i]:= Tv[i - 2] * (Tv[i - 1] / 100);
      inc(i, 6);
    end;

    Tv[425]:= Tv[394] + Tv[400] + Tv[406] + Tv[412] + Tv[418] + Tv[424];

    i:= 429;
    while i <= 449 do
    begin
      Tv[i]:= Tv[i - 2] * (Tv[i - 1] / 100);
      inc(i, 4);
    end;
    Tv[450]:= Tv[429] + Tv[433] + Tv[437] + Tv[441] + Tv[445] + Tv[449];

    //Part 2M
    Tv[451]:= Tv[140];
    strings[452]:= strings[382];          //Tv[452]:= Tv[382];  //jz//20260304 - change to string to capture decimal points
    Tv[453]:= Tv[451] * vl(strings[452]); //tv[452]             //jz//20260304 - change to string to capture decimal points

    //Part 2N
    Tv[456]:= Tv[454] - Tv[455];
    Tv[457]:= Tv[456];
    //Calc some values from the Part 2I
    Tv[363]:= Tv[457];
    Tv[367]:= MinR(Tv[363], Tv[366]);
    //Calc some values from the Part 2F
    Tv[333]:= Tv[367];
    Tv[334]:= Tv[332] - Tv[333];
    //Continue calculation of the Part 2N
    Tv[458]:= Tv[388];
    Tv[459]:= Tv[453];
    Tv[460]:= Tv[458] + Tv[459];
    Tv[461]:= Tv[460];
    Tv[462]:= Tv[425];
    Tv[463]:= Tv[450];
    Tv[464]:= Tv[462] + Tv[463];
    Tv[465]:= Tv[464];
    Tv[466]:= minr(Tv[466],Tv[367]); //jz//20260304 - form says cannot be more than, does not mean assign to
    Tv[467]:= Tv[457] + Tv[461] + Tv[465] - Tv[466];
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20260302 Igor <<<

initialization
  SetRoundMode(rmNearest); //20250312 Igor

end.