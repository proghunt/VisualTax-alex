unit T2_2027calc4;

interface

{
  uses
  SysUtils,
  WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,
  UDeclare,common, common2,TrimStr;
}

Procedure StoreAlbHeader(RetNo, FNo, CorpNameElm, AccountElm,
  YearEndElm: Integer);
procedure AS51(RetNo: Integer; FName: string; FNo: Integer);
Procedure AT1013(RetNo: Integer; FName: string; FNo: Integer);
Procedure ACAPD(RetNo: Integer; FName: string; FNo: Integer);
Procedure ACAPDRE(RetNo: Integer; FName: string; FNo: Integer);
Procedure GetOperatingName(RetNo: Integer; Var S1: String; Var S2: String);
Function GetAlbNetInc(RetNo: Integer): Real;
Function GetAlbRevenue(RetNo: Integer): Real;
Function GetTOTRevenue(RetNo: Integer): Real;
Function GetTotSalaries(RetNo: Integer): Real;
Function GetAlbSalaries(RetNo: Integer): Real;
Procedure FillAlbHeader(RetNo, FormNo, AccountElm, YearEndElm: Integer);
{ Alberta }
Function GetAlbYearEnd(RetNo: Integer): String;

procedure AT1(RetNo: Integer; FName: string; FNo: Integer);
procedure AS1(RetNo: Integer; FName: string; FNo: Integer);
procedure AS2(RetNo: Integer; FName: string; FNo: Integer);
procedure AS3(RetNo: Integer; FName: string; FNo: Integer); // 20170624
procedure AS4(RetNo: Integer; FName: string; FNo: Integer);
Procedure AS5(RetNo: Integer; FName: string; FNo: Integer);
procedure AS6(RetNo: Integer; FName: string; FNo: Integer);
procedure AS7(RetNo: Integer; FName: string; FNo: Integer);
procedure AS8(RetNo: Integer; FName: string; FNo: Integer);
//Procedure AS9(RetNo: Integer; FName: string; FNo: Integer);  //20231024
Procedure AS9SUP(RetNo: Integer; FName: String; FNo: Integer);
Procedure AS9L(RetNo: Integer; FName: string; FNo: Integer);
procedure AS10(RetNo: Integer; FName: string; FNo: Integer);
procedure AS11(RetNo: Integer; FName: string; FNo: Integer);
procedure AS12(RetNo: Integer; FName: string; FNo: Integer);
procedure AS12SUP(RetNo: Integer; FName: string; FNo: Integer);
procedure AS13(RetNo: Integer; FName: string; FNo: Integer);
procedure AS14(RetNo: Integer; FName: string; FNo: Integer);
procedure AS14WS(RetNo: Integer; FName: string; FNo: Integer);
procedure AS15(RetNo: Integer; FName: string; FNo: Integer);
procedure AS16(RetNo: Integer; FName: string; FNo: Integer);
procedure AS17(RetNo: Integer; FName: string; FNo: Integer);
procedure AS18(RetNo: Integer; FName: string; FNo: Integer);
procedure AS20(RetNo: Integer; FName: string; FNo: Integer);
Procedure AS20WS(RetNo: Integer; FName: String; FNo: Integer);
procedure AS21(RetNo: Integer; FName: string; FNo: Integer);
procedure AS29(RetNo: Integer; FName: string; FNo: Integer);
Procedure AS29L(RetNo: Integer; FName: string; FNo: Integer);
Procedure AT1FEC(RetNo: Integer; FName: string; FNo: Integer);  //20230615 at100
Procedure ACONSENT(RetNo: Integer; FName: string; FNo: Integer);

implementation

Uses
  SysUtils,
  vtMulti, vtCommon,
  T2_2027, T2_2027Declare, T2_2027common, T2_2027common2, T2_2027TrimStr,
  T2_2027Calc, T2_2027Calc1,
  vtTrimStr, vtShared;

{ ******************** ALBERTA SCHEDULES ************ }
Procedure FillAlbHeader(RetNo, FormNo, AccountElm, YearEndElm: Integer);
Begin
  With Ret[RetNo].Frm[FormNo] do
  begin
    Strings[AccountElm] := GetAlbAccNo(RetNo);
    Strings[YearEndElm] := GetTaxationYearEnd(RetNo);
  end;
end;

Procedure StoreAlbHeader(RetNo, FNo, CorpNameElm, AccountElm,
  YearEndElm: Integer);
Begin
  StoreElm(RetNo, FNo, CorpNameElm, LeftStr(GetCorpName(RetNo), 60));
  StoreElm(RetNo, FNo, AccountElm, GetAlbAccNo(RetNo));
  StoreElm(RetNo, FNo, YearEndElm, GetTaxationYearEnd(RetNo));

end;

Procedure GetOperatingName(RetNo: Integer; Var S1: String; Var S2: String);
Var
  s: string;
  i, k: Integer;
Begin
  s := FetchElm(RetNo, 'S125#1', 4) + ' ';
  // FetchElm(RetNo,'GIFIIS#1',2)+' ';  //20150826
  k := Length(s) - 1;
  For i := 45 to Length(s) do
  begin
    If s[i] = ' ' then
    begin
      k := i - 1;
      break;
    end;
  end;
  S1 := LeftStr(s, k);
  S2 := MidStr(s, k + 1, 250);
end;

Procedure AT1(RetNo: Integer; FName: string; FNo: Integer);
Var
  S1, S2: String;
  TotRate: Real;
  i:integer;
begin
  LoadTv(RetNo, FName, FNo);

   with Ret[RetNo].Frm[FNo] do
   begin
      If  (Ret[RetNo].Province = 'AB')        or
          (Ret[RetNo].Province = 'MJ')        or
          (Vl(FetchElm(RetNo, 'S5', 197))>0)  or
          ((FetchElm(RetNo, 'AT1', 9))>'')
      then
      begin
            //continue
      end
      else
      begin
         For i:=4 to 95 do begin Strings[i]:='';Tv[i]:=0;End;
         //does not work?  ClearForm(RetNo,FName);
         SaveTv(RetNo,FName,FNo);
         exit;
      end;

    Strings[1] := GetCorpName(RetNo);
    { name/mailing address }
    S1 := '';
    S2 := '';
    GetOperatingName(RetNo, S1, S2);
    Strings[2] := S1;
    Strings[12] := S2;
    { mailing address }
    If UpperCase(Strings[65]) <> 'Y' then // 20150510
    Begin
      If FetchElm(RetNo, 'T2', 26) > '' then
      begin
        Strings[3] := FetchElm(RetNo, 'T2', 26);
        Strings[4] := FetchElm(RetNo, 'T2', 27);
        Strings[5] := FetchElm(RetNo, 'T2', 32); { city }
        Strings[6] := FetchElm(RetNo, 'T2', 33);
        Strings[7] := FetchElm(RetNo, 'T2', 34);
        Strings[8] := FetchElm(RetNo, 'T2', 35);
      end
      else
      begin
        Strings[3] := FetchElm(RetNo, 'T2', 12);
        Strings[4] := FetchElm(RetNo, 'T2', 13);
        Strings[5] := FetchElm(RetNo, 'T2', 16); { city }
        Strings[6] := FetchElm(RetNo, 'T2', 17);
        Strings[7] := FetchElm(RetNo, 'T2', 19);
        Strings[8] := FetchElm(RetNo, 'T2', 20);
      end;
    End;

   {
    // functional currency
    S1 := LeftStr(FetchElmFNo(RetNo, T2FNo, 72), 2);
    If S1 = '' then
    begin
     Strings[62] := ''; // 20111205
     Strings[60] := '';
     Strings[59] := '';
     Strings[56] := '';
     Strings[61] := '';
     Strings[80] := '';
    end;

    if      (S1='01') then  Strings[60]:='X'
    else if (S1='02') then  Strings[59]:='X'
    else if (S1='03') then  Strings[56]:='X'
    else if (S1='04') then  Strings[61]:='X'
    else if (S1='05') then  Strings[80]:='X';
    }
    {
    if S1 = '01' then  //us
    begin
      Strings[60] := 'X';
      Strings[59] := '';
      Strings[56] := '';
      Strings[61] := '';
      Strings[80] := '';
    end
    else if S1 = '02' then
    begin
      Strings[60] := '';
      Strings[59] := 'X';
      Strings[56] := '';
      Strings[61] := '';
      Strings[80] := '';
    end
    else if S1 = '03' then       //20240707
    begin
      Strings[60] := '';
      Strings[59] := '';
      Strings[56] := 'X';
      Strings[61] := '';
      Strings[80] := '';
    end
    else if S1 = '04' then
    begin
      Strings[60] := '';
      Strings[59] := '';
      Strings[56] := '';
      Strings[61] := 'X';
      Strings[80] := '';
    end
    else if S1 = '05' then   //202407/07  //cz
    begin
      Strings[60] := '';
      Strings[59] := '';
      Strings[56] := '';
      Strings[61] := '';
      Strings[80] := 'X';
    end;
    }


    If Strings[29] = '' then
    begin
      If FetchElm(RetNo, 'T2', 749) > '' then
        Strings[29] := FetchElm(RetNo, 'T2', 749)
      else
        Strings[29] := FetchElm(RetNo, 'T2', 743) + ' ' +
          FetchElm(RetNo, 'T2', 742);
    end;

    // functional currency

    If Strings[30] = '' then
    begin
      If FetchElm(RetNo, 'T2', 750) > '' then
        Strings[30] := FetchElm(RetNo, 'T2', 756) + ' ' +
          FetchElm(RetNo, 'T2', 750)
      else
        Strings[30] := FetchElm(RetNo, 'T2', 755) + ' ' +
          FetchElm(RetNo, 'T2', 746);
    end;

    If Ret[RetNo].CorpType = CCPC then
      Strings[32] := 'X'
    else
      Strings[32] := '';

    // 20130626
    If FetchElm(RetNo, 'T2', 24) > '' then
    begin
      Strings[33] := 'X';
      Strings[32] := '';
    end;
    If Strings[33] = 'X' then
      Strings[32] := '';

    Strings[63] := FetchElm(RetNo, 'T2', 30);
    Strings[64] := FetchElm(RetNo, 'T2', 31);

    If Ret[RetNo].CorpType = OtherPrivate then
      Strings[34] := 'X'
    else
      Strings[34] := '';
    If Ret[RetNo].CorpType = PublicCorp then
      Strings[35] := 'X'
    else
      Strings[35] := '';
    If Ret[RetNo].CorpType = Other then
      Strings[36] := 'X'
    else
      Strings[36] := '';

    Strings[37] := FetchElm(RetNo, 'T2', 60);
    Strings[40] := FetchElm(RetNo, 'T2', 36);
    Strings[41] := FetchElm(RetNo, 'T2', 37);

    Strings[10] := FetchElm(RetNo, 'T2', 1); { BN }

    Strings[11] := FetchElm(RetNo, 'T2', 10);
    Strings[14] := FetchElm(RetNo, 'T2', 11);
    If Strings[17] + Strings[18] = '' then
      Strings[18] := 'X';
    If Strings[48] + Strings[55] = '' then
      Strings[55] := 'X';
    Tv[42] := GetGrossRevenue(RetNo);
    Tv[43] := Vl(FetchElm(RetNo, 'S100', 89)); { 41 tot assets }  // 20160627
    // Tv[43] := Vl(FetchGifiElm(RetNo,'GIFIBS#1','2599'));  {41 tot assets}

    If (FetchElm(RetNo, 'T2', 39) > '') or (FetchElm(RetNo, 'T2', 42) > '') then
    begin
      Strings[44] := 'X';
      Strings[45] := '';
    end
    else
    begin
      Strings[44] := '';
      Strings[45] := 'X';
    end;
    If FetchElm(RetNo, 'T2', 39) > '' then
      Strings[49] := 'X'
    else
      Strings[49] := '';

    If FetchElm(RetNo, 'T2', 42) > '' then
      Strings[53] := 'X'
    else
      Strings[53] := '';

    { If Length(Strings[46]) <10 then Strings[46] :=''; }
    If Strings[58] = '' then
      Strings[58] := '9999';

    { special corp }
    Strings[38] := '';
    Strings[39] := '';
    Strings[13] := '';
    Strings[15] := ''; // Strings[16]:=''; //20151115
    If IsInvestmentCorp(RetNo) then
      Strings[38] := 'X';
    If IsMutualFundCorp(RetNo) then
      Strings[39] := 'X';
    If IsCooperativeCorp(RetNo) then
      Strings[13] := 'X';
    If IsCreditUnion(RetNo) then
      Strings[15] := 'X';
    If IsTaxExempt(RetNo) then
      Strings[16] := 'X'; // 20151115
  end; { end with }
  // SaveTv (RetNo, Fname, FNo);

  // AT1 pg2 --------------------------------------------------------------------

  // LoadTv (RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 101, 102);
    If Strings[104] + Strings[103] = '' then
      Strings[103] := 'X';
    If Strings[105] + Strings[106] = '' then
      Strings[106] := 'X';
    { check if in fact different txbl income }

    // TAXABLE INCOME TEST
    If Round(Vl(FetchElm(RetNo, 'T2', 230))) +
      Round(Vl(FetchElm(RetNo, 'T2', 231)))
    // -Round(Vl(FetchElm(RetNo,'T2',233))) //20210129
      <> Round(Vl(FetchElm(RetNo, 'AT1', 107))) then
    begin
      Strings[104] := 'X';
      Strings[103] := '';
    end
    else
    begin
      Strings[104] := '';
      Strings[103] := 'X';
    end;

    // if losses  //20210129
    If (Round(Vl(FetchElm(RetNo, 'T2', 230))) +
      Round(Vl(FetchElm(RetNo, 'T2', 231))) <= 0)
    // -Round(Vl(FetchElm(RetNo,'T2',233))) //20210129
      and (Round(Vl(FetchElm(RetNo, 'AT1', 107))) <= 0) then
    begin
      Strings[104] := '';
      Strings[103] := 'X';
    end;

    If Round(Vl(FetchElm(RetNo, 'AS12', 65))) <>
      Round(Vl(FetchElm(RetNo, 'AS12', 119))) then // 20210614
    begin
      Strings[104] := 'X';
      Strings[103] := '';
    end;

    If IsAlbTaxExempt(RetNo) then
    begin
      Strings[104] := '';
      Strings[103] := 'X';
    end;

    // ---------------------------------------
    { check if in fact different schedules }
    If AlbAnyDiffSchedule(RetNo) then
    begin
      Strings[105] := 'X';
      Strings[106] := '';
    end;

    If (Strings[103] > '') and (Strings[106] > '') then // both no
    begin
      Tv[107] := Vl(FetchElm(RetNo, 'T2', 230)) + Vl(FetchElm(RetNo, 'T2', 231))
        - Vl(FetchElm(RetNo, 'T2', 233));
    end;
    { if loss }
    If Vl(FetchElm(RetNo, 'T2', 232)) < 0 then
      Tv[107] := Vl(FetchElm(RetNo, 'S4', 19)) + Vl(FetchElm(RetNo, 'S4', 21));
    If IsAlbTaxExempt(RetNo) then
      Tv[107] := Vl(FetchElm(RetNo, 'T2', 232));

    If (Strings[104] > '') or (Strings[105] > '') then
      Tv[107] := Vl(FetchElm(RetNo, 'AS12', 119)); // not 130 (gone) //20220601

    If Ret[RetNo].AlbAlloc = 0 then
      Tv[107] := 0;
    Tv[108] := Vl(FetchElm(RetNo, 'AS5', 19));

    Strings[109] := GetAlbAllocationFactor(RetNo);
    If Ret[RetNo].AlbAlloc = 100 then
      Strings[109] := '1.00000';
    If Ret[RetNo].Province = 'AB' then
      Tv[110] := Round(MaxR(0, (Tv[107] - Tv[108]) * 1))
    else
      Tv[110] := MaxR(0, Round((Tv[107] - Tv[108]) * Vl(Strings[109])));

    If IsAlbTaxExempt(RetNo) then
      Tv[110] := 0;

    // 20181212
    (*
      Strings[134] := ''; //IntToStr(GetNumDays(RetNo,'01-04-2001','B'));
      Strings[135] := ''; //IntToStr(GetNumDays(RetNo,'31-03-2001','A')                -GetNumDays(RetNo,'31-03-2002','A'));
      Strings[141] := ''; //IntToStr(GetNumDays(RetNo,'31-03-2002','A')-GetNumDays(RetNo,'31-03-2003','A'));
    *)
    // Strings[138] :=''; // IntToStr(GetNumDays(RetNo,'31-03-2004','A')-GetNumDays(RetNo,'31-03-2006','A'));
    Strings[143] := '';
    // IntToStr(GetNumDays(RetNo,'31-03-2006','A')-GetNumDays(RetNo,'30-06-2015','A'));  ////20150713
    Strings[147] := IntToStr(GetNumDays(RetNo, '30-06-2015', 'A') -
      GetNumDays(RetNo, '30-06-2019', 'A')); // 20191029
    Strings[70] := IntToStr(GetNumDays(RetNo, '30-06-2019', 'A') -
      GetNumDays(RetNo, '31-12-2019', 'A')); // 20191029
    // 20200905
    Strings[71] := IntToStr(GetNumDays(RetNo, '31-12-2019', 'A') -
      GetNumDays(RetNo, '30-06-2020', 'A'));
    // 20191029//IntToStr(GetNumDays(RetNo,'31-12-2019','A'));  //20191029
    Strings[138] := IntToStr(GetNumDays(RetNo, '30-06-2020', 'A'));
    Strings[139] := IntToStr(Ret[RetNo].DaysInYear);

    // 20200905
    Tv[142] := 0;
    Tv[144] := Round(Tv[110] * 0.120 * MyStrToInt(Strings[147]) / Ret[RetNo]
      .DaysInYear);
    Tv[146] := Round(Tv[110] * 0.110 * MyStrToInt(Strings[70]) / Ret[RetNo]
      .DaysInYear);
    Tv[72] := Round(Tv[110] * 0.100 * MyStrToInt(Strings[71]) / Ret[RetNo]
      .DaysInYear);
    Tv[73] := Round(Tv[110] * 0.080 * MyStrToInt(Strings[138]) / Ret[RetNo]
      .DaysInYear);

    // 20191029
    TotRate := (0.120 * MyStrToInt(Strings[147]) + 0.110 *
      MyStrToInt(Strings[70]) + 0.100 * MyStrToInt(Strings[71]) + 0.080 *
      MyStrToInt(Strings[138])) / Ret[RetNo].DaysInYear;

    // 20150713
    TotRate := RoundN(TotRate, 5);
    Tv[111] := Round(Tv[110]) * TotRate; // 20191029

    Tv[112] := Vl(FetchElm(RetNo, 'AS1', 15));
    If IsAlbTaxExempt(RetNo) then
      Tv[112] := 0;
    // Tv[113] := Vl(FetchElm(RetNo,'AS11',14));
    Tv[114] := Vl(FetchElm(RetNo, 'AS4', 45));
    // Tv[115] := Vl(FetchElm(RetNo,'AS8',18));
    Tv[116] := Vl(FetchElm(RetNo, 'AS3', 15)); // 20170626

    Tv[117] := Tv[112] + Tv[114] + Tv[116]; // 20210529
    // Tv[117] := TV[112]+tv[113]+Tv[114]+Tv[115]+Tv[116];
    Tv[118] := MaxR(0, Tv[111] - Tv[117]);

   // Tv[149] := Vl(FetchElm(RetNo, 'AS9', 25));  //20231024

    Tv[74] := Vl(FetchElm(RetNo, 'AS29', 27)); //IEG //20250622B
    {
    If FetchElm(RetNo, 'AS29', 147) > '' then // if step 2
      Tv[74] := Vl(FetchElm(RetNo, 'AS29', 29)) // 20210711  //ieg
    else
      Tv[74] := 0;
    }
    Tv[120] := Vl(FetchElm(RetNo, 'AS6', 9));
    Tv[121] := Vl(FetchElm(RetNo, 'AS6', 12));

    //Tv[22] := Vl(FetchElm(RetNo, 'xxx', xx)); //jz VT49 not sure where it comes from / have the form in the program

    Tv[124] := Tv[74] + Tv[119] + Tv[68] + Tv[122] + Tv[22] + Tv[123] ; //jz VT49 added line 115: tv[22]
    // 20210706
    Tv[125] := Tv[118] - Tv[124];
    If Tv[125] >= 0 then
    begin
      If UpperCase(Strings[145]) <> 'Y' then
        Tv[126] := Tv[125];
    end
    else
      Tv[126] := 0;

    If Tv[125] < 0 then
    begin
      If Strings[127] = '' then
        Strings[127] := '1';
    end
    else
      Strings[127] := '';

    If Strings[130] = '' then
      Strings[130] := FetchElm(RetNo, 'T2', 742);
    If Strings[131] = '' then
      Strings[131] := FetchElm(RetNo, 'T2', 743);
    If Strings[132] = '' then
      Strings[132] := FetchElm(RetNo, 'T2', 744);
    If Strings[133] = '' then
      Strings[133] := FetchElm(RetNo, 'T2', 745);

    if Strings[75] + Strings[76] = '' then
      Strings[75] := 'X'; // 20211227
    if Strings[75] > '' then
      Strings[77] := OptRec.Prp_Name
    else
      Strings[77] := '';

    //20251216
    If Strings[134] = '' then Strings[134] := FetchElm(RetNo, 'T2', 755)+RemoveChar(FetchElm(RetNo, 'T2', 746),'-'); //20251216
    Strings[134] := RemoveChar(Strings[134],' '); //20251216
    Strings[134] := RemoveChar(Strings[134],'-'); //20251216
  end; { end with }
  SaveTv(RetNo, FName, FNo);
end;

Procedure AS1(RetNo: Integer; FName: string; FNo: Integer);
Var
  i: Integer;
  Regulation: Integer;
  k, j, m, x, y, z, S23FNo: Integer;
  AmountC: Real;
begin

  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    //20260628
    If (Ret[RetNo].Province = 'AB')
    or (Vl(FetchElm(RetNo, 'S5', 197))>0) then  //has AB income   //20260725
    //continue
    else
    begin
     For i:=1 to 144 do begin Strings[i]:='';Tv[i]:=0;End;
     //does not work?  ClearForm(RetNo,FName);
     SaveTv(RetNo,FName,FNo);
     exit;
    end;

    FillAlbHeader(RetNo, FNo, 1, 2);

    If IsAlbTaxExempt(RetNo) then
    begin
      For i := 3 to 25 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      SaveTv(RetNo, FName, FNo);
      // exit;
    end

    else if Ret[RetNo].CorpType <> CCPC then
    begin
      For i := 5 to 15 do
        Tv[i] := 0;
      SaveTv(RetNo, FName, FNo);
    end
    else
    begin
      if IsAssociated(RetNo) then
      begin
        Strings[3] := 'X';
        Strings[4] := '';
      end
      else
      begin
        Strings[3] := '';
        Strings[4] := 'X';
      end;

      Tv[5] := Vl(FetchElm(RetNo, 'AS12', 124));
      Tv[6] := Vl(FetchElm(RetNo, 'AS5', 19)); // Vl(FetchElm(RetNo,'AS5',9));
      Tv[7] := MaxR(0, Tv[5] - Tv[6]);
      Tv[8] := GetAlbTxblIncome(RetNo); { adj? }
      Tv[9] := Vl(FetchElm(RetNo, 'AS5', 19));
      Tv[10] := MaxR(0, Tv[8] - Tv[9]);
      Tv[11] := Vl(FetchElm(RetNo, 'AS1', 144));
      Tv[16] := Round(Tv[11] * 150 / 100);

      Tv[12] := MinR(Tv[7], MinR(Tv[10], Tv[11]));
      Tv[17] := MinR(Tv[7], MinR(Tv[10], Tv[16]));
      If Ret[RetNo].Province = 'AB' then
      begin
        Tv[19] := 0;
        Tv[20] := 0;
      end
      else
      begin
        Tv[19] := Vl(FetchElm(RetNo, 'S5', 259));
        Tv[20] := Vl(FetchElm(RetNo, 'S5', 261));
      end;

      If Ret[RetNo].Province = 'AB' then
        Strings[13] := '1.00000'
      else
      begin
        Strings[13] := GetAlbAllocationFactorForS1(RetNo);
      end;

      // 20150713
      Strings[14] := IntToStr(GetNumDays(RetNo, '31-03-2009', 'A') -
        GetNumDays(RetNo, '30-06-2015', 'A')); // 20150713
      Tv[26] := Round(Tv[11] * 250 / 100);
      Tv[27] := MinR(Tv[7], MinR(Tv[10], Tv[26]));
      Tv[28] := Round(Tv[27] * Vl(Strings[13]));
      Tv[29] := Round(Tv[28] * (Vl(Strings[14]) / Ret[RetNo].DaysInYear) *
        (7.0 / 100));

      // 20161122
      Strings[52] := IntToStr(GetNumDays(RetNo, '30-06-2015', 'A') -
        GetNumDays(RetNo, '31-12-2016', 'A')); // 20161122
      Tv[53] := Round(Tv[11] * 250 / 100);
      Tv[54] := MinR(Tv[7], MinR(Tv[10], Tv[53]));
      Tv[55] := Round(Tv[54] * Vl(Strings[13]));
      Tv[56] := Round(Tv[55] * (Vl(Strings[52]) / Ret[RetNo].DaysInYear) *
        (9.0 / 100)); // 20150716

      // 20161122
      Strings[66] := IntToStr(GetNumDays(RetNo, '31-12-2016', 'A') -
        GetNumDays(RetNo, '30-06-2019', 'A'));
      Tv[67] := Round(Tv[11] * 250 / 100);
      Tv[68] := MinR(Tv[7], MinR(Tv[10], Tv[67]));
      Tv[69] := Round(Tv[68] * Vl(Strings[13]));
      Tv[70] := Round(Tv[69] * (Vl(Strings[66]) / Ret[RetNo].DaysInYear) *
        (10.0 / 100));

      // 20191026
      Strings[71] := IntToStr(GetNumDays(RetNo, '30-06-2019', 'A') -
        GetNumDays(RetNo, '31-12-2019', 'A'));
      Tv[72] := Round(Tv[11] * 250 / 100);
      Tv[73] := MinR(Tv[7], MinR(Tv[10], Tv[72]));
      Tv[74] := Round(Tv[73] * Vl(Strings[13]));
      Tv[75] := Round(Tv[74] * (Vl(Strings[71]) / Ret[RetNo].DaysInYear) *
        (9.0 / 100));

      // 20200905
      Strings[12] := IntToStr(GetNumDays(RetNo, '31-12-2019', 'A') -
        GetNumDays(RetNo, '30-06-2020', 'A'));
      Tv[16] := Round(Tv[11] * 250 / 100);
      Tv[17] := MinR(Tv[7], MinR(Tv[10], Tv[16]));
      Tv[18] := Round(Tv[17] * Vl(Strings[13]));
      Tv[21] := Round(Tv[18] * (Vl(Strings[12]) / Ret[RetNo].DaysInYear) *
        (8.0 / 100));

      Strings[76] := IntToStr(GetNumDays(RetNo, '30-06-2020', 'A'));
      Tv[77] := Round(Tv[11] * 250 / 100);
      Tv[78] := MinR(Tv[7], MinR(Tv[10], Tv[77]));
      Tv[79] := Round(Tv[78] * Vl(Strings[13]));
      Tv[80] := Round(Tv[79] * (Vl(Strings[76]) / Ret[RetNo].DaysInYear) *
        (6.0 / 100));

      Strings[38] := IntToStr(Ret[RetNo].DaysInYear);
      Tv[15] := Tv[29] + Tv[56] + Tv[70] + Tv[75] + +Tv[21] + Tv[80];
      // 20200905
    end; // else
  end; { end with }

  // pg2 -------------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    //20240706  several changes
    If IsAlbTaxExempt(RetNo) then
    begin
      For i := 101 to 144 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      SaveTv(RetNo, FName, FNo);
    end
    else
    begin
      FillAlbHeader(RetNo, FNo, 101, 102);
      Strings[103] := IntToStr(GetTaxationYearEndYYYY(RetNo));
      S23FNo := GetFormNo('S23');
      If IsAssociated(RetNo) then
      begin
        i := 104;
        j := 105;
        k := 108;
        m := 145;
        Tv[140] := 0;
        Tv[157] := 0;
        Repeat
          Strings[i] := FetchElm(RetNo, 'S23', j - 100); // 20121006
          Strings[m] := FetchElm(RetNo, 'S23', j + 4 - 100);
          Tv[i + 2] := Round(200000 * Vl(Strings[m]) / 100);
          // Vl(FetchElm(RetNo,'S23',kk))/100;
          Tv[140] := Tv[140] + Tv[i + 2];
          Tv[157] := Tv[157] + Vl(Strings[m]);
          Inc(i, 3);
          Inc(j, 6);
          Inc(k, 5);
          // Inc(kk,6);
          Inc(m, 1);
        until i > 137;
        Strings[105] := GetAlbAccNo(RetNo);
        Tv[141] := Tv[106];
      end
      else
      begin
        For i := 104 to 140 do
        begin
          Strings[i] := '';
          Tv[i] := 0;
        end;
        Tv[141] := 200000;
      end;

      If Ret[RetNo].DaysInYear < 357 then
      begin
        // 20150714
        Tv[57] := Tv[141];
        Strings[58] := IntToStr(Ret[RetNo].DaysInYear);
        Tv[142] := Round(Tv[57] * Vl(Strings[58]) / 365);
      end
      else
        Tv[142] := Tv[141];


      Tv[22]:=Tv[142];
      Tv[23]:=Tv[142];
      //Tv[62] := Tv[142];
      //Tv[61] := Round(Tv[62] * Tv[65] / 11250);


      if GetTaxationYearEnd(RetNo)>='2022/04/07' then
      Begin
       Tv[64]:=Vl(FetchElm(RetNo,'T2',122));
       Tv[60] := Round(Tv[23] * Tv[64] / 90000);
       Tv[63]:=0;
       Tv[59]:=0;
      end
      Else  //before April 7
      Begin
       Tv[63]:=Vl(FetchElm(RetNo,'T2',338));
       Tv[59] := Round(Tv[22] * Tv[63] / 11250);
       Tv[64]:=0;
       Tv[60]:= 0;
      End;

      Tv[81] := Ret[RetNo].Ln[417];
      Tv[82] := MaxR(0, Tv[81] - 50000);
      Tv[83] := MinR(Tv[141], Tv[142]);
      Tv[84] := Tv[82];
      Tv[85] := Round((Tv[83] * Tv[84]) / 100000);
      AmountC:= MaxR(Tv[59], Tv[60]);  //20240706
      //AmountC := MaxR(Tv[59], MaxR(Tv[60], Tv[61]));
      Tv[86] := MaxR(AmountC, Tv[85]);
      Tv[87]:=0;
      if GetBegYearEnd(RetNo) > '2018/12/31' then
        Tv[88] := MinR(Tv[141], MaxR(0, Tv[142] - Tv[86]))
      else
        Tv[88] := 0;

      Tv[90]:=0;
      Tv[91] := MaxR(0, Tv[88] - Tv[89]);
      Tv[144] := MaxR(Tv[90], Tv[91]);
     {
      if GetNumDays(RetNo, '01-01-2019', 'B') > 0 then
        Tv[87] := MinR(Tv[141], MaxR(0, Tv[142] - AmountC))
      Else
        Tv[87] := 0;

      if GetBegYearEnd(RetNo) < '2019/01/01' then
        Tv[87] := MinR(Tv[141], MaxR(0, Tv[142] - AmountC))
      else
        Tv[87] := 0;

      if GetBegYearEnd(RetNo) > '2018/12/31' then
        Tv[88] := MinR(Tv[141], MaxR(0, Tv[142] - Tv[86]))
      else
        Tv[88] := 0;
      Tv[89] := Ret[RetNo].Ln[515];
      Tv[90] := MaxR(0, Tv[87] - Tv[89]);
      Tv[91] := MaxR(0, Tv[88] - Tv[89]);
      }
      // Tv[143]:=MaxR(Tv[142],MaxR(Tv[60],Tv[61]));
    end; // else
  end; { end with }
  SaveTv(RetNo, FName, FNo);
end;

(* //20191026
  Procedure AS1(RetNo:integer;FName:string;FNo:integer);
  Var i:Integer;Regulation:Integer;
  k,j,m,x,y,z,S23FNo:integer;
  begin

  LoadTv (RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin

  FillAlbHeader(RetNo,FNo,1,2);

  If IsAlbTaxExempt(RetNo) then
  begin
  For i:=3 to 25 do begin Strings[i]:='';Tv[i]:=0;end;
  SaveTv (RetNo, Fname, FNo);
  //exit;
  end

  else if Ret[RetNo].CorpType <> CCPC then
  begin
  For i:=5 to 15 do Tv[i]:=0;
  SaveTv (RetNo, Fname, FNo);
  end
  else
  begin
  if IsAssociated(RetNo) then
  begin
  Strings[3] := 'X'; Strings[4] :='';
  end
  else
  begin
  Strings[3] :='';Strings[4] :='X';
  end;


  Tv[5] := Vl(FetchElm(RetNo,'AS12',124));
  Tv[6] := Vl(FetchElm(RetNo,'AS5',19)); //Vl(FetchElm(RetNo,'AS5',9));
  Tv[7] := MaxR(0,Tv[5]-Tv[6]);
  Tv[8] := GetAlbTxblIncome(RetNo);  {adj?}
  Tv[9] := Vl(FetchElm(RetNo,'AS5',19));
  Tv[10] := MaxR(0,Tv[8]-Tv[9]);
  Tv[11] := Vl(FetchElm(RetNo,'AS1',144));
  Tv[16] := Round(Tv[11] * 150/100);

  Tv[12] := MinR(Tv[7],MinR(Tv[10],Tv[11]));
  Tv[17] := MinR(Tv[7],MinR(Tv[10],Tv[16]));
  If Ret[RetNo].Province = 'AB' then
  begin
  Tv[19]:=0;
  Tv[20]:=0;
  end
  else
  begin
  Tv[19] := Vl(FetchElm(RetNo,'S5',259));
  Tv[20] := Vl(FetchElm(RetNo,'S5',261));
  end;

  If Ret[RetNo].Province = 'AB' then
  Strings[13] := '1.00000'
  else
  begin
  Strings[13] := GetAlbAllocationFactorForS1(RetNo);
  end;
  Tv[14] := Round(Tv[12] * Vl(Strings[13]));
  Tv[18] := Round(Tv[17] * Vl(Strings[13]));

  Strings[42] := ''; //IntToStr(GetNumDays(RetNo,'31-03-2007','A')-GetNumDays(RetNo,'31-03-2008','A'));
  Tv[43]:=Round(Tv[11] * 215/100);
  Tv[44]:=MinR(Tv[7],MinR(Tv[10],Tv[43]));
  Tv[45]:=Round(Tv[44]*Vl(Strings[13]));
  Tv[46]:=Round(Tv[45] * (Vl(Strings[42])/Ret[RetNo].DaysInYear) *(7.0/100));

  Strings[47] := ''; //IntToStr(GetNumDays(RetNo,'31-03-2008','A')-GetNumDays(RetNo,'31-03-2009','A'));
  Tv[48]:=Round(Tv[11] * 230/100);
  Tv[49]:=MinR(Tv[7],MinR(Tv[10],Tv[48]));
  Tv[50]:=Round(Tv[49]*Vl(Strings[13]));
  Tv[51]:=Round(Tv[50] * (Vl(Strings[47])/Ret[RetNo].DaysInYear) *(7.0/100));

  //20150713
  Strings[14] :=IntToStr(GetNumDays(RetNo,'31-03-2009','A')-GetNumDays(RetNo,'30-06-2015','A'));  //20150713
  Tv[26]:=Round(Tv[11] * 250/100);
  Tv[27]:=MinR(Tv[7],MinR(Tv[10],Tv[26]));
  Tv[28]:=Round(Tv[27]*Vl(Strings[13]));
  Tv[29]:=Round(Tv[28] * (Vl(Strings[14])/Ret[RetNo].DaysInYear) *(7.0/100));

  //20161122
  Strings[52] :=IntToStr(GetNumDays(RetNo,'30-06-2015','A')-GetNumDays(RetNo,'31-12-2016','A')); //20161122
  Tv[53]:=Round(Tv[11] * 250/100);
  Tv[54]:=MinR(Tv[7],MinR(Tv[10],Tv[53]));
  Tv[55]:=Round(Tv[54]*Vl(Strings[13]));
  Tv[56]:=Round(Tv[55] * (Vl(Strings[52])/Ret[RetNo].DaysInYear) *(9.0/100));   //20150716

  //20161122
  Strings[66] :=IntToStr(GetNumDays(RetNo,'31-12-2016','A'));
  Tv[67]:=Round(Tv[11] * 250/100);
  Tv[68]:=MinR(Tv[7],MinR(Tv[10],Tv[67]));
  Tv[69]:=Round(Tv[68]*Vl(Strings[13]));
  Tv[70]:=Round(Tv[69] * (Vl(Strings[66])/Ret[RetNo].DaysInYear) *(10.0/100));


  Strings[38]:=IntToStr(Ret[RetNo].DaysInYear);
  Tv[15]:=Tv[46]+Tv[51]+Tv[29]+Tv[56]+Tv[70];  //20161122  //Tv[33]+Tv[37]+Tv[22]+Tv[25]+Tv[46]+Tv[51]+Tv[29]+Tv[56]+Tv[70];  //20161122
  end; //else
  end; { end with}

  //pg2 -------------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
  If IsAlbTaxExempt(RetNo) then
  begin
  For i:=101 to 144 do
  begin
  Strings[i]:='';Tv[i]:=0;
  end;
  SaveTv (RetNo, Fname, FNo);
  end
  else
  begin
  FillAlbHeader(RetNo,FNo,101,102);
  Strings[103] := IntToStr(GetTaxationYearEndYYYY(RetNo));
  S23FNo:=GetFormNo('S23');
  If IsAssociated(RetNo) then
  begin
  i:=104;j:=105;k:=108;
  m:=145;
  Tv[140] := 0;Tv[157]:=0;
  Repeat
  Strings[i] := FetchElm(RetNo,'S23',j-100);  //20121006
  Strings[m]:=FetchElm(RetNo,'S23',j+4-100);
  Tv[i+2] := Round(200000 * Vl(Strings[m])/100); //Vl(FetchElm(RetNo,'S23',kk))/100;
  Tv[140] := Tv[140]+Tv[i+2];
  Tv[157]:=Tv[157]+Vl(Strings[m]);
  Inc(i,3);
  Inc(j,6);
  Inc(k,5);
  //Inc(kk,6);
  Inc(m,1);
  until i>137;
  Strings[105] := GetAlbAccNo(RetNo);
  Tv[141]:=Tv[106]
  end
  else
  begin
  For i:=104 to 140 do begin Strings[i]:='';Tv[i] :=0; end;
  Tv[141] := 200000;
  end;

  If Ret[RetNo].DaysInYear <357 then
  begin
  //20150714
  Tv[57]:=Tv[141];
  Strings[58]:=IntToStr(Ret[RetNo].DaysInYear);
  Tv[142] := Round(Tv[57] * Vl(Strings[58])/365);
  end
  else
  Tv[142] := TV[141];

  Tv[62]:=Tv[142];
  Tv[59]:=Round(Tv[62]*Tv[63]/11250);
  Tv[60]:=Round(Tv[62]*Tv[64]/11250);
  Tv[61]:=Round(Tv[62]*Tv[65]/11250);
  Tv[143]:=MaxR(Tv[59],MaxR(Tv[60],Tv[61]));

  Tv[144] := MaxR(0,Tv[142]-Tv[143]);

  end; //else
  end; { end with}
  SaveTv (RetNo, Fname, FNo);
  end;
*)

Procedure AS2(RetNo: Integer; FName: string; FNo: Integer);
Var
  i: Integer;
  k, x, y, z: Real;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 1, 2);
    If Strings[3] + Strings[4] = '' then
      Strings[4] := 'X';
    If Strings[4] = 'X' then
      for i := 25 to 27 do
        Strings[i] := '';
    If Strings[4] = 'X' then
    begin
      Tv[5] := Vl(FetchElm(RetNo, 'S5', 193));
      Tv[6] := Vl(FetchElm(RetNo, 'S5', 270));
      Tv[7] := Vl(FetchElm(RetNo, 'S5', 195));
      Tv[8] := Vl(FetchElm(RetNo, 'S5', 272));
    end
    else
      For i := 5 to 8 do
        Tv[i] := 0;

    Tv[10] := Vl(FetchElm(RetNo, 'S5', 193));
    Tv[11] := Vl(FetchElm(RetNo, 'S5', 270));
    Tv[15] := Vl(FetchElm(RetNo, 'S5', 193));
    Tv[16] := Vl(FetchElm(RetNo, 'S5', 270));
    Tv[20] := Vl(FetchElm(RetNo, 'S5', 193));
    Tv[21] := Vl(FetchElm(RetNo, 'S5', 270));

    If (Vl(Strings[6]) = 0) or (Vl(Strings[8]) = 0) then
      k := 1
    else
      k := 1 / 2;
    Strings[9] := FormatFloat('##0.000000',
      (k * CalcAlbFactor(Vl(Strings[5]), Vl(Strings[6]), Vl(Strings[7]),
      Vl(Strings[8]))));
    { special }
    Strings[14] := FormatFloat('##0.000000',
      (1 / 2) * CalcAlbFactor(Vl(Strings[10]), Vl(Strings[11]), Vl(Strings[12]),
      Vl(Strings[13])));
    Strings[19] := FormatFloat('##0.000000',
      (1 / 2) * CalcAlbFactor(Vl(Strings[15]), Vl(Strings[16]), Vl(Strings[17]),
      Vl(Strings[18])));
    Strings[24] := FormatFloat('##0.000000',
      (1 / 2) * CalcAlbFactor(Vl(Strings[20]), Vl(Strings[21]), Vl(Strings[22]),
      Vl(Strings[23])));
    If Strings[25] = '' then
      For i := 10 to 14 do
        Tv[i] := 0;
    If Strings[26] = '' then
      For i := 15 to 18 do
        Tv[i] := 0;
    If Strings[27] = '' then
      For i := 20 to 24 do
        Tv[i] := 0;
    If IsAlbSpecialAlloc(RetNo) then
    begin
      Strings[3] := 'X';
      Strings[4] := '';
      For i := 5 to 8 do
        Tv[i] := 0;
      Strings[9] := '';
    end;
  end; { end with }
  // pg2 -------------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 101, 136);

    Tv[105] := Vl(FetchElm(RetNo, 'S5', 193));
    Tv[106] := Vl(FetchElm(RetNo, 'S5', 270));
    Tv[107] := Vl(FetchElm(RetNo, 'S5', 195));
    Tv[108] := Vl(FetchElm(RetNo, 'S5', 272));
    Tv[123] := Vl(FetchElm(RetNo, 'S5', 193));
    Tv[124] := Vl(FetchElm(RetNo, 'S5', 270));

    Strings[104] := FormatFloat('##0.000000',
      CalcAlbFactor(0, 0, Vl(Strings[102]), Vl(Strings[103])));

    Strings[109] := FormatFloat('##0.000000',
      (1 / 3) * CalcAlbFactor(Vl(Strings[105]), Vl(Strings[106]),
      2 * Vl(Strings[107]), Vl(Strings[108])));
    Strings[112] := FormatFloat('##0.000000',
      CalcAlbFactor(0, 0, Vl(Strings[110]), Vl(Strings[111])));
    Strings[117] := FormatFloat('##0.000000',
      (1 / 4) * CalcAlbFactor(Vl(Strings[113]), Vl(Strings[114]),
      3 * Vl(Strings[115]), Vl(Strings[116])));
    Strings[122] := FormatFloat('##0.000000',
      (1 / 2) * CalcAlbFactor(Vl(Strings[118]), Vl(Strings[119]),
      Vl(Strings[120]), Vl(Strings[121])));
    If Vl(Strings[128]) > 0 then
      x := Vl(Strings[127]) / Vl(Strings[128])
    else
      x := 0;
    Tv[129] := Round(MaxR(0, x * (Vl(FetchElm(RetNo, 'AT1', 107)) -
      Vl(FetchElm(RetNo, 'AT1', 107)))));

    If Vl(Strings[124]) > 0 then
      x := Vl(Strings[123]) / Vl(Strings[124])
    else
      x := 0;
    Tv[130] := Round(MaxR(0, x * (Vl(FetchElm(RetNo, 'AT1', 107)) -
      Vl(FetchElm(RetNo, 'AT1', 107))) - Tv[129]));
    If Vl(Strings[126]) > 0 then
      y := Vl(Strings[125]) / Vl(Strings[126])
    else
      y := 0;
    z := (Vl(FetchElm(RetNo, 'AT1', 107)) - Vl(FetchElm(RetNo, 'AT1', 107)));
    If z > 0 then
      x := Round((Tv[129] * y + Tv[130]) / z)
    else
      x := 0;
    Strings[131] := FormatFloat('##0.000000', x);

    Strings[135] := FormatFloat('##0.000000', CalcAlbFactor(Vl(Strings[113]),
      Vl(Strings[114]), Vl(Strings[115]), Vl(Strings[116])));

    If Strings[134] = '' then
      For i := 102 to 104 do
        Tv[i] := 0;
    If Strings[137] = '' then
      For i := 105 to 109 do
        Tv[i] := 0;
    If Strings[138] = '' then
      For i := 110 to 112 do
        Tv[i] := 0;
    If Strings[139] = '' then
      For i := 113 to 117 do
        Tv[i] := 0;
    If Strings[140] = '' then
      For i := 118 to 122 do
        Tv[i] := 0;
    If Strings[141] = '' then
      For i := 123 to 131 do
        Tv[i] := 0;
    If Strings[142] = '' then
      For i := 132 to 135 do
        Tv[i] := 0;
  end; { end with }
  SaveTv(RetNo, FName, FNo);
end;

// 20170624
Procedure AS3(RetNo: Integer; FName: string; FNo: Integer);
Var
  i, k, k1, At1FNo: Integer;
  MaxCredit: Real;
  Yend: String; // k1 = used row indicator

begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 1, 2);
    At1FNo := GetFormNo('AT1');
    MaxCredit := MaxR(0, Vl(FetchElmFNo(RetNo, At1FNo, 111)) // 068
      - Vl(FetchElmFNo(RetNo, At1FNo, 112)) // 070
      - Vl(FetchElmFNo(RetNo, At1FNo, 113)) // 071
      - Vl(FetchElmFNo(RetNo, At1FNo, 114)) // 072
      - Vl(FetchElmFNo(RetNo, At1FNo, 115))); // 074
    Tv[5] := MinR(MaxCredit, Tv[3] + Tv[4]);
    Tv[7] := MaxR(0, Tv[3] + Tv[4] - Tv[5] - Tv[6]);

    // cap investm
    MaxCredit := MaxR(0, Vl(FetchElmFNo(RetNo, At1FNo, 111)) // 068
      - Vl(FetchElmFNo(RetNo, At1FNo, 112)) // 070
      - Vl(FetchElmFNo(RetNo, At1FNo, 113)) // 071
      - Vl(FetchElmFNo(RetNo, At1FNo, 114)) // 072
      - Vl(FetchElmFNo(RetNo, At1FNo, 115)) // 074
      - Tv[5]);

    Tv[10] := MinR(MaxCredit, Tv[8] + Tv[9]);
    Tv[12] := MaxR(0, Tv[8] + Tv[9] - Tv[10] - Tv[11]);

    // -------
    Tv[13] := Tv[5] + Tv[10];
    Tv[14] := MaxR(0, Vl(FetchElmFNo(RetNo, At1FNo, 111)) // 068
      - Vl(FetchElmFNo(RetNo, At1FNo, 112)) // 070
      - Vl(FetchElmFNo(RetNo, At1FNo, 113)) // 071
      - Vl(FetchElmFNo(RetNo, At1FNo, 114)) // 072
      - Vl(FetchElmFNo(RetNo, At1FNo, 115))); // 074
    Tv[15] := MinR(Tv[13], Tv[14]); // 20170626

    // page 2

    // line 120
    for i := 120 to 124 do
    Begin
      Strings[i] := IntToStr(i - 120);
    End;
    // dates
    i := 16;
    k := 0;
    k1 := 136;
    Yend := GetTaxationYearEnd(RetNo);
    Repeat
      If Strings[i] = '' then
        Strings[i] := GetPrevYearEnd(Yend, k);
      Inc(i, 6);
      Inc(k, 1);
      Inc(k1, 1);
    until i > 40;

    Tv[18] := Tv[3]; // 20170626
    Tv[19] := Tv[5]; // 20170626
    i := 21;
    k1 := 136;
    Tv[46] := 0;
    Tv[47] := 0;
    Tv[48] := 0;
    Repeat
      Tv[i] := MaxR(0, Tv[i - 4] + Tv[i - 3] - Tv[i - 2] - Tv[i - 1]);
      Tv[46] := Tv[46] + Tv[i - 2];
      Tv[47] := Tv[47] + Tv[i - 1];
      Tv[48] := Tv[48] + Tv[i];
      if Tv[i - 4] + Tv[i - 3] + Tv[i - 2] + Tv[i - 1] > 0 then
        Strings[k1] := 'X' // row used
      else
        Strings[k1] := '';
      Inc(i, 6);
      Inc(k1, 1);
    Until i > 48;

    // cap inv.
    // line 220
    for i := 125 to 135 do
    Begin
      Strings[i] := IntToStr(i - 125);
    End;
    // dates
    i := 49;
    k := 0;
    Yend := GetTaxationYearEnd(RetNo);
    Repeat
      If Strings[i] = '' then
        Strings[i] := GetPrevYearEnd(Yend, k);
      Inc(i, 6);
      Inc(k, 1);
    until i > 109;

    Tv[51] := Tv[8]; // 20170626
    Tv[52] := Tv[10]; // 20170626
    i := 54;
    k1 := 141;
    Tv[115] := 0;
    Tv[116] := 0;
    Tv[117] := 0;
    Repeat
      Tv[i] := MaxR(0, Tv[i - 4] + Tv[i - 3] - Tv[i - 2] - Tv[i - 1]);
      Tv[115] := Tv[115] + Tv[i - 2];
      Tv[116] := Tv[116] + Tv[i - 1];
      Tv[117] := Tv[117] + Tv[i];
      if Tv[i - 4] + Tv[i - 3] + Tv[i - 2] + Tv[i - 1] > 0 then
        Strings[k1] := 'X' // row used
      else
        Strings[k1] := '';
      Inc(i, 6);
      Inc(k1, 1);
    Until i > 114;

  end; { end with }
  SaveTv(RetNo, FName, FNo);
end;

Procedure AS4(RetNo: Integer; FName: string; FNo: Integer);
Var
  i, j, k: Integer;
  S21FNo: Integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 1, 2);
    S21FNo := GetFormNo('S21');
    i := 3;
    j := 4;
    k := 46;
    Tv[43] := 0;
    repeat
      Strings[i] := FetchElmFNo(RetNo, S21FNo, j);
      Tv[i + 1] := Vl(FetchElmFNo(RetNo, S21FNo, j + 1));
      Strings[i + 2] := FetchElm(RetNo, 'AS1', 13); { see note on form? }
      If Vl(FetchElm(RetNo, 'AT1', 110)) > 0 then
        Tv[i + 3] := Round(Tv[i + 1] * Vl(Strings[i + 2]) *
          Vl(FetchElm(RetNo, 'AT1', 111)) / Vl(FetchElm(RetNo, 'AT1', 110)))
      else
        Tv[i + 3] := 0;

      Tv[i + 4] := MaxR(0, Vl(FetchElmFNo(RetNo, S21FNo, j + 2)) - MaxR(Tv[k],
        Vl(FetchElmFNo(RetNo, S21FNo, j + 3))));
      Tv[i + 5] := Vl(FetchElmFNo(RetNo, S21FNo, j + 8));
      Tv[i + 6] := Round(MaxR(0, (Tv[i + 4] - Tv[i + 5]) * Vl(Strings[i + 2])
        )); { Vl ? }
      Tv[i + 7] := MinR(Tv[i + 3], Tv[i + 6]);
      Tv[43] := Tv[43] + Tv[i + 7];
      Inc(i, 8);
      Inc(j, 9);
      Inc(k, 1);
    until i > 35;
    Tv[51] := 0;
    For i := 46 to 50 do
      Tv[51] := Tv[51] + Tv[i];
    Tv[44] := MaxR(0, Vl(FetchElm(RetNo, 'AT1', 111)) -
      Vl(FetchElm(RetNo, 'AT1', 112)) - Vl(FetchElm(RetNo, 'AT1', 113)));
    Tv[45] := MinR(Tv[43], Tv[44]);
  end; { end with }
  SaveTv(RetNo, FName, FNo);
end;

Procedure AS5(RetNo: Integer; FName: string; FNo: Integer);
Var
  i: Integer;
begin
  EXIT; // 20211025
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 1, 2);
    If Strings[3] + Strings[4] = '' then
      Strings[4] := 'X';
    If Strings[5] + Strings[6] = '' then
      Strings[6] := 'X';
    If Strings[16] = '' then
      Strings[16] := '3';
    // section c
    Tv[36] := AddColumns(23, 35, 4);
    Tv[38] := MaxR(0, Tv[36] + Tv[37]);

    Tv[7] := Vl(FetchElm(RetNo, 'AS7', 23));
    Tv[8] := MaxR(0, Vl(FetchElm(RetNo, 'AS12', 25)));
    If Tv[8] = 0 then
      Tv[8] := MaxR(0, Vl(FetchElm(RetNo, 'S1', 223)));
    Tv[10] := MaxR(0, Tv[7] - Tv[8] - Tv[9]);
    Tv[11] := Tv[38];
    Tv[12] := Tv[10] + Tv[11];
    Tv[13] := MaxR(0, Vl(FetchElm(RetNo, 'AT1', 107)));
    Tv[14] := MinR(Tv[12], MaxR(0, Tv[13] - Vl(FetchElm(RetNo, 'AS5', 163))));
    If UpperCase(Strings[18]) = 'Y' then
      Tv[14] := Tv[39];
    Tv[15] := MaxR(0, Tv[12] - Tv[14]);
    If Strings[16] = '3' then
      Strings[17] := '';
    If (Strings[16] = '1') or (Strings[16] = '2') then
      Tv[15] := 0;
    Tv[19] := Tv[14] + Vl(FetchElm(RetNo, 'AS5', 163));
  end; { end with }
  // AS5 pg2 ---------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 101, 102);
    i := 105;
    Tv[131] := 0;
    Tv[132] := 0;
    Repeat
      Tv[i + 2] := MaxR(0, Tv[i + 2]);
      If Tv[i] > 0 then
        Tv[i + 1] := 0;
      If Tv[i + 1] > 0 then
        Tv[i] := 0;
      If Tv[i] > 0 then
      begin
        If UpperCase(Strings[164]) <> 'Y' then
          Tv[i + 3] := MinR(Tv[i], Tv[i + 2]);
        Tv[i + 4] := MaxR(0, Tv[i] - Tv[i + 3]);
      end
      else
      begin
        If UpperCase(Strings[164]) <> 'Y' then
          Tv[i + 3] := MinR(Tv[i + 1], Tv[i + 2]);
        Tv[i + 4] := MaxR(0, Tv[i + 1] - Tv[i + 3]);
      end;
      Tv[131] := Tv[131] + Tv[i + 3];
      Tv[132] := Tv[132] + Tv[i + 4];
      Inc(i, 7);
    until i > 126;

    i := 135;
    Tv[161] := 0;
    Tv[162] := 0;
    Repeat
      Tv[i + 2] := MaxR(0, Tv[i + 2]);
      If Tv[i] > 0 then
        Tv[i + 1] := 0;
      If Tv[i + 1] > 0 then
        Tv[i] := 0;
      If Tv[i] > 0 then
      begin
        If UpperCase(Strings[164]) <> 'Y' then
          Tv[i + 3] := MinR(Tv[i], Tv[i + 2]);
        Tv[i + 4] := MaxR(0, Tv[i] - Tv[i + 3]);
      end
      else
      begin
        If UpperCase(Strings[164]) <> 'Y' then
          Tv[i + 3] := MinR(Tv[i + 1], Tv[i + 2]);
        Tv[i + 4] := MaxR(0, Tv[i + 1] - Tv[i + 3]);
      end;
      Tv[161] := Tv[161] + Tv[i + 3];
      Tv[162] := Tv[162] + Tv[i + 4];
      Inc(i, 7);
    until i > 156;

    Tv[163] := Tv[131] + Tv[161];
  end; { end with }
  SaveTv(RetNo, FName, FNo);

end;

Procedure AS6(RetNo: Integer; FName: string; FNo: Integer);
Const
  Qrt1From = '01-01';
  Qrt1To = '31-03';
  Qrt2From = '01-04';
  Qrt2To = '30-06';
  Qrt3From = '01-07';
  Qrt3To = '30-09';
  Qrt4From = '01-10';
  Qrt4To = '31-12';
Var
  i, j, k, n1, n2, n3, n4: Integer;
  Yr: String[4];
begin
  EXIT; // 20211025
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 1, 2);
    If Strings[3] + Strings[4] = '' then
      Strings[4] := 'X';
    Tv[5] := Vl(FetchElm(RetNo, 'AS7', 3)) + Vl(FetchElm(RetNo, 'AS7', 19)) -
      Vl(FetchElm(RetNo, 'AS7', 214)) + Vl(FetchElm(RetNo, 'AS7', 215));
    If UpperCase(Strings[3]) = 'X' then
      Tv[8] := Vl(FetchElm(RetNo, 'AS6', 111))
    else
    begin
      Strings[6] := IntToStr(Ret[RetNo].DaysInYear);
      If Vl(Strings[6]) > 365 then
        Strings[6] := '365';
      Tv[7] := Round(2000000 * (Vl(Strings[6]) / 365));
      Tv[8] := Tv[7];

      i := 18;
      repeat
        If Strings[i] = '' then
          Strings[i] := '0.2500';
        Inc(i, 5);
      until i > 38;

    end;
    Tv[10] := MinR(Tv[5], Tv[8]);
    Strings[11] := Strings[40];
    If Vl(Strings[40]) = 0 then
      Strings[11] := '0.2500';
    Tv[9] := Round(Tv[10] * Vl(Strings[11]));
    Tv[13] := Tv[9] - Tv[12]; { neg ? }
    { w avg }
    i := 17;
    k := 0;
    Repeat
      k := k + MyStrToInt(Strings[i]);
      Inc(i, 5);
    until i > 37;
    Strings[41] := IntToStr(k);

    // DO NOT round the factors below
    i := 17;
    Tv[40] := 0;
    Repeat
      If Vl(Strings[i + 1]) > 1 then
        Strings[i + 1] := ''; { only decimals }
      If k > 0 then
        Tv[i + 2] := Vl(Strings[i]) * Vl(Strings[i + 1]) / k
      else
        Tv[i + 2] := 0;
      Strings[i + 2] := FormatFloat('0.0000', Tv[i + 2]);
      Tv[40] := Tv[40] + Tv[i + 2];
      Inc(i, 5);
    until i > 37;
    Strings[40] := FormatFloat('0.0000', Tv[40]);
  end; { end with }
  // SaveTv (RetNo, Fname, FNo);

  // AS6 pg2 ---------------------------------------------------------------------

  // LoadTv (RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 101, 102);

    If Vl(Strings[6]) > 365 then
      Strings[6] := '365';
    Strings[107] := Strings[106];
    Tv[108] := Round(2000000 * (Vl(Strings[107]) / 365));

    If UpperCase(FetchElm(RetNo, 'AS6', 3)) = 'X' then
    begin
      { copy associated corp }
      i := 109;
      j := 104;
      repeat
        Strings[i] := FetchElm(RetNo, 'AS1', j);
        Strings[i + 1] := FetchElm(RetNo, 'AS1', j + 1);
        Inc(i, 3);
        Inc(j, 3);
      until i > 142;

    end;
    Tv[145] := Tv[108];
    Tv[111] := MaxR(0, Tv[145] - AddColumns(114, 144, 3));
  end; { end with }
  SaveTv(RetNo, FName, FNo);

end;

Procedure AS7(RetNo: Integer; FName: string; FNo: Integer);
Var
  i: Integer;
  FNoS51: Integer;
begin
  EXIT; // 20211025
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 1, 2);
    FNoS51 := GetFormNo('S51CRN');
    Tv[5] := Vl(FetchElmFNo(RetNo, FNoS51, 5)) +
      Vl(FetchElmFNo(RetNo, FNoS51, 6)) + Vl(FetchElmFNo(RetNo, FNoS51, 7));
    Tv[6] := Vl(FetchElmFNo(RetNo, FNoS51, 18));
    Tv[7] := Vl(FetchElmFNo(RetNo, FNoS51, 13));
    Tv[8] := Vl(FetchElmFNo(RetNo, FNoS51, 25));
    Tv[13] := AddColumns(3, 8, 1) + Tv[10];
    Tv[18] := Tv[15] + Tv[17];

    Tv[19] := Vl(FetchElm(RetNo, 'AS7', 157));
    Tv[20] := Vl(FetchElm(RetNo, 'AS7', 158));
    Tv[21] := Vl(FetchElm(RetNo, 'AS7', 159));
    Tv[22] := AddColumns(19, 21, 1);
    Tv[24] := Vl(FetchElm(RetNo, 'AS7', 217));
    Tv[23] := MaxR(0, Tv[13] + Tv[18] + Tv[22] - Tv[24]);
  end; { end with }
  // AS7 pg2 ---------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 101, 102);
    Tv[157] := AddColumns(106, 154, 6);
    Tv[158] := AddColumns(107, 155, 6);
    Tv[159] := AddColumns(108, 156, 6);

    i := 162;
    repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] + Tv[i + 2];
      Inc(i, 6);
    until i > 210;

    Tv[214] := AddColumns(162, 210, 6);
    Tv[215] := AddColumns(163, 211, 6);
    Tv[216] := AddColumns(164, 212, 6);
    Tv[217] := AddColumns(165, 213, 6);
  end; { end with }
  SaveTv(RetNo, FName, FNo);

end;

Procedure AS8(RetNo: Integer; FName: string; FNo: Integer);
Var
  i, j, S8FNo: Integer;
  x, y, z: Real;
begin
  EXIT; // 20211025
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 1, 2);
    { copy from POLIT }
    i := 3;
    j := 34;
    Repeat
      Strings[i] := FetchElm(RetNo, 'POLIT', j); { descr }
      Strings[i + 2] := FetchElm(RetNo, 'POLIT', j - 1); { date }
      Tv[i + 3] := Vl(FetchElm(RetNo, 'POLIT', j + 1)); { Amount }
      Inc(i, 4);
      Inc(j, 3);
    until i > 11;
    Strings[4] := FetchElm(RetNo, 'POLIT', 124); { receipt }
    Strings[8] := FetchElm(RetNo, 'POLIT', 125); { receipt }
    Strings[12] := FetchElm(RetNo, 'POLIT', 126); { receipt }
    Tv[24] := Vl(FetchElm(RetNo, 'POLIT', 128)); // from partnership
    Tv[15] := Vl(FetchElm(RetNo, 'POLIT', 129)); // from partnership

    Tv[23] := AddColumns(6, 14, 4);
    Tv[25] := Tv[23] + Tv[24] + Tv[15];
    // section A
    // All in 2004
    Strings[20] := '';

    i := 5;
    Repeat
      If (Strings[i] > '') and (Tv[i + 1] = 0) then
        Strings[i] := '';
      Inc(i, 4);
    until i > 13;

    i := 5;
    Repeat
      If Strings[i] = '' then
        // ok
      else
      begin
        If Strings[i] >= '2004/01/01' then
          Strings[20] := 'X'
        else
        begin
          Strings[20] := '';
          break;
        end;
      end;
      Inc(i, 4);
    until i > 13;
    If Tv[24] > 0 then
      Strings[20] := '';

    If Strings[20] > '' then
      Tv[19] := Tv[23] + Tv[15]
    else
      Tv[19] := 0;

    If Tv[19] <= 200 then
    begin
      x := Round(Tv[19] * 0.75);
      y := 0;
      z := 0;
    end
    else
    begin
      x := Round(200 * 0.75);
      y := Round(MinR(900, (Tv[19] - 200)) * 0.50);
      z := Round(MaxR(0, (Tv[19] - 1100)) * 0.3333);
    end;
    Tv[26] := x;
    Tv[27] := y;
    Tv[28] := z;

    Tv[29] := AddColumns(26, 28, 1);
    Tv[30] := MinR(Tv[29], 1000);

    Tv[16] := Tv[30];
    If Vl(FetchElm(RetNo, 'AS8', 108)) > 0 then
      Tv[16] := Vl(FetchElm(RetNo, 'AS8', 108));
    If Vl(FetchElm(RetNo, 'AS8', 122)) > 0 then
      Tv[16] := Vl(FetchElm(RetNo, 'AS8', 122));

    Tv[17] := MaxR(0, Vl(FetchElm(RetNo, 'AT1', 111)) -
      Vl(FetchElm(RetNo, 'AT1', 112)) - Vl(FetchElm(RetNo, 'AT1', 113)) -
      Vl(FetchElm(RetNo, 'AT1', 114)));
    Tv[18] := MinR(Tv[16], Tv[17]);

  end; { end with }
  // AS8 pg2----------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 101, 102);
    S8FNo := GetFormNo('AS8'); // ???
    If Vl(FetchElmFNo(RetNo, S8FNo, 30)) > 0 then // if section A used
    begin
      For i := 103 to 122 do
        Tv[i] := 0;
      SaveTv(RetNo, FName, FNo);
      EXIT;
    end;

    // section B
    // All in 2003
    Strings[123] := '';
    i := 5;
    Repeat
      If FetchElmFNo(RetNo, S8FNo, i) = '' then
        // ok
      else
      begin
        If FetchElmFNo(RetNo, S8FNo, i) < '2004/01/01' then
          Strings[123] := 'X'
        else
        begin
          Strings[123] := '';
          break;
        end;
      end;
      Inc(i, 4);
    until i > 13;

    If Vl(FetchElmFNo(RetNo, S8FNo, 15)) > 0 then
      Strings[123] := '';

    If Strings[123] > '' then
      Tv[103] := Vl(FetchElmFNo(RetNo, S8FNo, 23)) +
        Vl(FetchElmFNo(RetNo, S8FNo, 24))
    else
    begin
      for i := 103 to 108 do
        Tv[i] := 0;
    end;

    If Tv[103] > 0 then
    begin
      If Tv[103] <= 150 then
      begin
        x := Round(Tv[103] * 0.75);
        y := 0;
        z := 0;
      end
      else
      begin
        x := Round(150 * 0.75);
        y := Round(MinR(675, (Tv[103] - 150)) * 0.50);
        z := Round(MaxR(0, (Tv[103] - 825)) * 0.3333);
      end;
      Tv[104] := x;
      Tv[105] := y;
      Tv[106] := z;
    end
    Else
    begin
      Tv[104] := 0;
      Tv[105] := 0;
      Tv[106] := 0;
    end;
    Tv[107] := AddColumns(104, 106, 1);
    Tv[108] := MinR(Tv[107], 750);

    // section C
    If (FetchElmFNo(RetNo, S8FNo, 20) > '') or (Strings[123] > '') then
    begin
      For i := 109 to 122 do
        Tv[i] := 0;
      SaveTv(RetNo, FName, FNo);
      EXIT;
    end;
    If (LeftStr(GetBegYearEnd(RetNo), 4) = '2003') and
      (LeftStr(GetTaxationYearEnd(RetNo), 4) = '2004') then
    begin
      i := 5;
      Tv[109] := 0;
      Repeat
        If FetchElmFNo(RetNo, S8FNo, i) >= '2004/01/01' then
          Tv[109] := Tv[109] + Vl(FetchElmFNo(RetNo, S8FNo, i + 1));
        Inc(i, 4);
      until i > 13;
      Tv[109] := Tv[109] + Vl(FetchElmFNo(RetNo, S8FNo, 15));
      Tv[110] := Vl(FetchElmFNo(RetNo, S8FNo, 25));
    end
    else
    begin
      For i := 109 to 122 do
        Tv[i] := 0;
    end;
    If (Tv[109] = 0) or (Tv[110] = 0) then
    begin
      For i := 109 to 122 do
        Tv[i] := 0; // must have contr in 2003 and 2004
    end;
    Tv[111] := MinR(Tv[110], 150);
    Tv[112] := MaxR(0, Tv[109] - Tv[111]);
    Tv[113] := MinR(Tv[112], 50);
    Tv[114] := MaxR(0, Tv[110] - Tv[111] - Tv[113]);
    Tv[115] := MinR(Tv[114], 675);
    Tv[116] := MaxR(0, Tv[109] - Tv[111] - Tv[113] - Tv[115]);
    Tv[117] := MinR(Tv[116], 225);
    Tv[118] := MaxR(0, Tv[110] - Tv[111] - Tv[113] - Tv[115] - Tv[117]);
    Tv[119] := MinR(Tv[118], 900);
    Tv[120] := MaxR(0, Tv[109] - Tv[111] - Tv[113] - Tv[115] - Tv[117]
      - Tv[119]);
    Tv[121] := MinR(Tv[120], 300);
    Tv[122] := Round((Tv[111] + Tv[113]) * 75 / 100 + (Tv[115] + Tv[117]) * 50 /
      100 + (Tv[119] + Tv[121]) * 33.3 / 100);
  end; { end with }
  SaveTv(RetNo, FName, FNo);
end;

//20231024
(*
Procedure AS9(RetNo: Integer; FName: string; FNo: Integer);
Var
  i: Integer;
  T661FNo: Integer;
  x: Real;
  Tel: String;
begin
  // tow pass calculation: See guide to claiming the AB SR&ED
  T661FNo := GetFormNo('T661');
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    if GetTaxationYearEnd(RetNo) > '2019/12/31' then // 20210714
    Begin
      for i := 1 to 166 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      SaveTv(RetNo, FName, FNo);
      EXIT;
    end;
  end;

  with Ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := GetCorpName(RetNo);
    FillAlbHeader(RetNo, FNo, 2, 3);
    // 20141108
    Strings[98] := Strings[2];
    Strings[99] := Strings[3];

    If Vl(FetchElm(RetNo, 'AS9L', 148)) + Vl(FetchElm(RetNo, 'AS9L', 150)) = 0
    then // 20100201
    begin
      For i := 1 to 97 do
      Begin
        Tv[i] := 0;
        Strings[i] := '';
      end;
      SaveTv(RetNo, FName, FNo);
      EXIT;
    end;

    // FIRST PASS
    If Strings[100] + Strings[101] = '' then
      Strings[100] := 'X';
    If Strings[100] > '' then // step 1
    begin
      Tv[4] := 0;

      Tv[5] := Vl(FetchElm(RetNo, 'AS9L', 156));
      // 20210710 //Vl(FetchElm(RetNo,'AS9L',148));

      Tv[6] := Vl(FetchElm(RetNo, 'AS9L', 151));
      Tv[7] := Vl(FetchElm(RetNo, 'AS9L', 152));
      Tv[8] := 0; // Tv[23]; //line 011

      Tv[15] := MaxR(0, Tv[5] - Tv[6] + Tv[7] + Tv[8] + Tv[14]); // -Tv[13]
      // page 2
      If Strings[17] > '' then
        Tv[19] := Tv[40]
      else
        Tv[19] := 0;
      If Strings[18] > '' then
      begin
        Strings[103] := IntToStr(GetNumDays(RetNo, '31-12-2008', 'A'));
        Strings[104] := IntToStr(Ret[RetNo].DaysInYear);
        If IncludesFeb29(RetNo) then
          Strings[104] := '366'
        else
          Strings[104] := '365';
        Tv[20] := 4000000 * Vl(Strings[103]) / Vl(Strings[104]);
      end
      else
        Tv[20] := 0;

      If Strings[17] > '' then
        Tv[22] := Tv[19]
      else
        Tv[22] := Tv[20];

      // Tv[23]:=MinR(Tv[15],Tv[22]) * 10/100;//MinR(Tv[21],Tv[22]) * 10/100;  //20210713 Kill it eliminated Jan 1. 2021
      Tv[23] := Vl(FetchElm(RetNo, 'S32ASSIST', 22));
      // manual entry  //20210713
      Tv[24] := 0; // line 112
      Tv[25] := 0; // line 120
      Tv[102] := Tv[23];
      // page 3
      // 20141108
      // Strings[98]:=Strings[2];
      // Strings[99]:=Strings[3];

      If Strings[17] > '' then
      begin
        If Strings[34] = '' then
          Strings[34] := '365';
        If Strings[32] = '' then
          Strings[32] := GetBegYearEnd(RetNo);
        If Strings[33] = '' then
          Strings[33] := GetTaxationYearEnd(RetNo);

        Strings[34] := IntToStr(GetNumDays2(RetNo, Strings[32], Strings[33],
          '31-12-2008', 'A'));

        Strings[35] := Strings[34];
        Tv[36] := 4000000 * Vl(Strings[35]) / 365;
        If IsLeapYear(GetTaxationYearEndYYYY(RetNo)) then
          Tv[36] := 4000000 * Vl(Strings[35]) / 366; // ??

        Strings[38] := GetCorpName(RetNo);
        Strings[39] := Strings[2];
        Tv[37] := Tv[36];
        x := 0;
        i := 43;
        Repeat
          x := x + Tv[i];
          Inc(i, 3);
        until i > 97;
        Tv[40] := MaxR(0, Tv[37] - x);
        If Strings[31] = '' then
          Strings[31] := GetAlbAccNo(RetNo);
        If Strings[32] = '' then
          Strings[32] := GetBegYearEnd(RetNo);
        If Strings[33] = '' then
          Strings[33] := GetTaxationYearEnd(RetNo);
      end
      Else
      begin
        For i := 31 to 97 do
        begin
          Strings[i] := '';
          Tv[i] := 0;
        end;
      end;
      If Strings[26] = '' then
        Strings[26] := FetchElm(RetNo, 'AT1', 131) + ' ' +
          FetchElm(RetNo, 'AT1', 130);
      If Strings[27] = '' then
        Strings[27] := FetchElm(RetNo, 'AT1', 132);
      Tel := FetchElm(RetNo, 'AT1', 30);
      If Strings[28] = '' then
        Strings[28] := LeftStr(Tel, 3);
      Tel := RemoveChar(Tel, '(');
      Tel := RemoveChar(Tel, ')');
      Tel := RemoveChar(Tel, '-');
      Tel := RemoveChar(Tel, ' ');
      Tel := LeftStr(Tel, 3) + '-' + RightStr(Tel, 4);
      If Strings[29] = '' then
        Strings[29] := Tel;
      If Strings[30] = '' then
        Strings[30] := FormatDateTime('yyyy/mm/dd', Date);
    end
    else // step 2
    Begin
      // PASS 2
      Tv[4] := Vl(FetchElmFNo(RetNo, T661FNo, 168));
      Tv[5] := MaxR(0, Vl(FetchElm(RetNo, 'AS9L', 148)) - Tv[102]);
      If Tv[5] > Tv[4] then
        Tv[5] := Tv[4]; // 20121218
      Tv[6] := Vl(FetchElm(RetNo, 'AS9L', 151));
      Tv[7] := Vl(FetchElm(RetNo, 'AS9L', 152));
      Tv[8] := Tv[102];
      Tv[105] := Tv[23] - Tv[24]; // 20121218
      Tv[106] := TotMultiple(RetNo, 'AS9SUP', 22);
      If GetTaxationYearEnd(RetNo) > '2012/03/31' then
        Tv[106] := 0; // 20121218
      Tv[25] := Tv[105] - Tv[106]; // Tv[25]:=Tv[23]-Tv[24];  //20121218
    end;
  end; { end with }
  SaveTv(RetNo, FName, FNo);
end;
*)
Procedure AS9L(RetNo: Integer; FName: string; FNo: Integer);
Var
  i, j, T661FNo: Integer;
begin
  T661FNo := GetFormNo('T661');
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    if GetTaxationYearEnd(RetNo) > '2019/12/31' then // 20210714
    Begin
      for i := 1 to 170 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      SaveTv(RetNo, FName, FNo);
      EXIT;
    end;

    Strings[153] := GetCorpName(RetNo);
    FillAlbHeader(RetNo, FNo, 154, 155);

    // Load projects
    j := 1;
    for i := 0 to (FList.Count - 1) do
    begin
      if j > 134 then
        break;
      FRec := FList.Items[i];
      If FRec.FormName = 'S60' then
      begin
        Strings[j] := FetchElmFNo(RetNo, FRec.FormNo, 4);
        Strings[j + 1] := FetchElmFNo(RetNo, FRec.FormNo, 7);
        Inc(j, 7);
      end;
    end;

    Tv[148] := AddColumns(3, 143, 7);
    Tv[149] := AddColumns(4, 144, 7);
    Tv[150] := AddColumns(5, 145, 7);
    Tv[151] := AddColumns(6, 146, 7);
    Tv[152] := AddColumns(7, 147, 7);

   // Tv[156] := Tv[148];  //2025-622B
    /// /Tv[156]:=Vl(FetchElm(RetNo,'AS9',5));  //20210711

    Tv[170] := 0;
    i := 156;
    Repeat
      Tv[170] := Tv[170] + Tv[i];
      Inc(i, 1);
    Until i > 169;

    {
      Tv[170]:=Vl(FetchElmFNo(RetNo,T661FNo,168));  //final after prov credits
      Tv[156]:=Tv[170]-AddColumns(157,169,1); //other
    }
  end; { end with }
  SaveTv(RetNo, FName, FNo);
end;

(* 20150703
  Procedure AS9L(RetNo:integer;FName:string;FNo:integer);
  Var i,j,T661FNo:Integer;
  begin
  T661FNo:=GetFormNo('T661');
  LoadTv (RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
  Strings[153] := GetCorpName(RetNo);
  FillAlbHeader(RetNo,FNo,154,155);

  //Load projects
  j:=1;
  for i :=0 to (FList.Count - 1) do
  begin
  if j>134 then break;
  FRec := FList.Items[i];
  If Frec^.FormName = 'S60' then
  begin
  Strings[j]:=FetchElmFNo(RetNo,Frec^.FormNo,4);
  Strings[j+1]:=FetchElmFNo(RetNo,Frec^.FormNo,7);
  Inc(j,7);
  end;
  end;

  Tv[148]:=AddColumns(3,143,7);
  Tv[149]:=AddColumns(4,144,7);
  Tv[150]:=AddColumns(5,145,7);
  Tv[151]:=AddColumns(6,146,7);
  Tv[152]:=AddColumns(7,147,7);

  Tv[170]:=Vl(FetchElmFNo(RetNo,T661FNo,168));  //final after prov credits
  Tv[156]:=Tv[170]-AddColumns(157,169,1); //other
  end; { end with}
  SaveTv (RetNo, Fname, FNo);
  end;
*)

Procedure AS10(RetNo: Integer; FName: string; FNo: Integer);
Var
  i: Integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := GetCorpName(RetNo);
    FillAlbHeader(RetNo, FNo, 2, 3);
    If Strings[10] = '' then
      Strings[10] := GetPrevYearEnd(GetAlbYearEnd(RetNo), 1);
    If Strings[15] = '' then
      Strings[15] := GetPrevYearEnd(GetAlbYearEnd(RetNo), 2);
    If Strings[20] = '' then
      Strings[20] := GetPrevYearEnd(GetAlbYearEnd(RetNo), 3);
    If FetchElm(RetNo, 'T2', 72) > '' then
    begin
      Strings[53] := 'X';
      Strings[52] := '';
    end
    else
    begin
      Strings[53] := '';
      Strings[52] := 'X';
    end;

    If Vl(FetchElm(RetNo, 'AS21', 12)) < 0 then
      Tv[6] := Abs(Vl(FetchElm(RetNo, 'AS21', 12)))
    else
      Tv[6] := 0;
    Tv[7] := Abs(Vl(FetchElm(RetNo, 'AS21', 11))); // 20110523

    Strings[4] := '';
    Strings[5] := '';
    If Abs(Vl(FetchElm(RetNo, 'S4', 39))) > 0 then
      Strings[4] := 'X';
    Tv[8] := Abs(Vl(FetchElm(RetNo, 'S4', 39)));
    // 20111206  //resticted farm loss

    If Tv[6] = 0 then
    begin
      Tv[11] := 0;
      Tv[16] := 0;
      Tv[21] := 0;
    end;
    If Tv[7] = 0 then
    begin
      Tv[12] := 0;
      Tv[17] := 0;
      Tv[22] := 0;
    end;
    If Tv[8] = 0 then
    begin
      Tv[13] := 0;
      Tv[18] := 0;
      Tv[23] := 0;
    end;
    If Tv[9] = 0 then
    begin
      Tv[14] := 0;
      Tv[19] := 0;
      Tv[24] := 0;
    end;

    If (Tv[8] > 0) and (Strings[4] + Strings[5] = '') then
    begin
      Strings[4] := 'X';
      Strings[5] := '';
    end;

    If Tv[6] + Tv[7] + Tv[8] + Tv[9] = 0 then
    begin
      Strings[10] := '';
      Strings[15] := '';
      Strings[20] := '';
    end;
    If Tv[11] + Tv[12] + Tv[13] + Tv[14] = 0 then
      Strings[10] := '';
    If Tv[16] + Tv[17] + Tv[18] + Tv[19] = 0 then
      Strings[15] := '';
    If Tv[21] + Tv[22] + Tv[23] + Tv[24] = 0 then
      Strings[20] := '';

    // 20201202
    if Tv[9]=0 then  //20230706
      Tv[9] := Vl(FetchElm(RetNo, 'S4', 103)); // as federal current year loss
    {
      If Vl(FetchElm(RetNo,'AS18',35)) <0 then
      Tv[9] := Abs(Vl(FetchElm(RetNo,'AS18',35)))
      else
      Tv[9] := 0;
    }

    Tv[25] := AddColumns(11, 21, 5);
    Tv[26] := AddColumns(12, 22, 5);
    Tv[27] := AddColumns(13, 23, 5);

    Tv[29] := MaxR(0, Tv[6] - Tv[25]);
    Tv[30] := MaxR(0, Tv[7] - Tv[26]);
    Tv[31] := MaxR(0, Tv[8] - Tv[27]);
    Tv[32] := MaxR(0, Tv[9] - Tv[28]);

    If Strings[35] = '' then
      Strings[35] := GetInclRateForCarryBack(Strings[10]);
    If Strings[48] = '' then
      Strings[48] := GetInclRateForCarryBack(Strings[15]);
    If Strings[50] = '' then
      Strings[50] := GetInclRateForCarryBack(Strings[20]);

    If Vl(Strings[35]) > 1 then
      Strings[35] := '0.000000';
    If Vl(Strings[48]) > 1 then
      Strings[35] := '0.000000';
    If Vl(Strings[50]) > 1 then
      Strings[35] := '0.000000';

    If Tv[9] = 0 then
    begin
      Strings[35] := '';
      Strings[48] := '';
      Strings[50] := '';
      Tv[14] := 0;
      Tv[19] := 0;
      Tv[24] := 0;
    end;

    If Tv[14] = 0 then
      Tv[14] := Vl(FetchElm(RetNo, 'S4', 112));
    If Tv[19] = 0 then
      Tv[19] := Vl(FetchElm(RetNo, 'S4', 113));
    If Tv[24] = 0 then
      Tv[24] := Vl(FetchElm(RetNo, 'S4', 114));

    Tv[37] := Round(Vl(Strings[35]) * Tv[14]);
    Tv[49] := Round(Vl(Strings[48]) * Tv[19]);
    Tv[51] := Round(Vl(Strings[50]) * Tv[24]);
    Tv[28] := AddColumns(14, 24, 5);

    // APPLICANT
    // contact
    If Strings[33] = '' then
      Strings[33] := FetchElm(RetNo, 'AT1', 29);
    If Strings[34] = '' then
      Strings[34] := FetchElm(RetNo, 'AT1', 30);
    If Strings[36] = '' then
      Strings[36] := FetchElm(RetNo, 'AT1', 31);
    // mailing
    If Strings[38] = '' then
      Strings[38] := FetchElm(RetNo, 'AT1', 3); // str address
    If Strings[39] = '' then
      Strings[39] := FetchElm(RetNo, 'AT1', 4); // str address
    If Strings[40] = '' then
      Strings[40] := FetchElm(RetNo, 'AT1', 5); // city
    If Strings[41] = '' then
      Strings[41] := FetchElm(RetNo, 'AT1', 6); // prov
    If Strings[42] = '' then
      Strings[42] := FetchElm(RetNo, 'AT1', 7); // country
    If Strings[43] = '' then
      Strings[43] := FetchElm(RetNo, 'AT1', 8); // postal
    // certification
    If Strings[44] = '' then
      Strings[44] := FetchElm(RetNo, 'AT1', 130);
    If Strings[45] = '' then
      Strings[45] := FetchElm(RetNo, 'AT1', 131);
    If Strings[46] = '' then
      Strings[46] := FetchElm(RetNo, 'AT1', 132);
    // date
    If Strings[47] = '' then
      Strings[47] := FormatDateTime('yyyy/mm/dd', Date);
  end; { end with }
  SaveTv(RetNo, FName, FNo);
end;

Procedure AS11(RetNo: Integer; FName: string; FNo: Integer);
Var
  i, S1Fno: Integer;
begin
  EXIT; // 20211025
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 1, 2);
    If AlbDiffAdjubi(RetNo) then
      Tv[3] := Vl(FetchElm(RetNo, 'AS12', 129))
    else
      Tv[3] := Vl(FetchElm(RetNo, 'S27', 19));

    If FetchElm(RetNo, 'S27-1', 20) = 'Y' then { sm manufacturer }
      Tv[4] := Tv[3]
    else
      Tv[4] := Vl(FetchElm(RetNo, 'AS11', 109));

    Tv[5] := GetIncomeForAlbSBD(RetNo);
    Tv[6] := MaxR(0, Tv[4] - Tv[5]);
    Tv[7] := Vl(FetchElm(RetNo, 'AT1', 110));
    S1Fno := GetFormNo('AS1');
    Vl(FetchElmFNo(RetNo, S1Fno, 7));
    Vl(FetchElmFNo(RetNo, S1Fno, 10));
    Vl(FetchElmFNo(RetNo, S1Fno, 11));
    Tv[8] := MinR(Vl(FetchElmFNo(RetNo, S1Fno, 7)),
      MinR(Vl(FetchElmFNo(RetNo, S1Fno, 10)),
      Vl(FetchElmFNo(RetNo, S1Fno, 11))));
    If (Ret[RetNo].CorpType = CCPC)  //20250524 ?? ned change?
    then
      Tv[9] := Vl(FetchElm(RetNo, 'S7', 48)) { ? agreg invstm inc }
    else
      Tv[9] := 0;
    Tv[10] := Tv[8] + Tv[9];
    Strings[11] := FetchElm(RetNo, 'AT1', 109);
    Tv[12] := Round(Tv[10] * Vl(Strings[11]));
    Tv[13] := MaxR(0, Tv[7] - Tv[12]);
    Strings[15] := IntToStr(GetNumDays(RetNo, '01-04-2001', 'B'));
    Strings[16] := IntToStr(GetNumDays(RetNo, '31-03-2001', 'A'));
    Tv[14] := Round(MinR(Tv[6], Tv[13] * (StrToInt(Strings[15]) / Ret[RetNo]
      .DaysInYear) * 0.01));
  end; // end with
  // pg2 -------------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 101, 102);
    If Strings[110] = '' then
      Strings[110] := 'N';
    If UpperCase(Strings[10]) <> 'Y' then
    begin
      Tv[103] := Vl(FetchElm(RetNo, 'S27', 111));
      Tv[106] := Vl(FetchElm(RetNo, 'S27', 136));
    end;
    { Tv[5] := ? }
    Tv[104] := Round(Tv[105] * (100 / 85));
    If Tv[104] > Tv[103] then
      Tv[104] := Tv[103];

    { Tv[7] := ? }
    Tv[108] := Round(Tv[107] * (100 / 75));
    If Tv[108] > Tv[106] then
      Tv[108] := Tv[106];
    If Tv[103] + Tv[106] > 0 then
      Tv[109] := Round(Vl(FetchElm(RetNo, 'AS11', 3)) *
        ((Tv[104] + Tv[8]) / (Tv[103] + Tv[106])))
    else
      Tv[109] := 0;
  end; { end with }
  SaveTv(RetNo, FName, FNo);

end;

Procedure AS12(RetNo: Integer; FName: string; FNo: Integer);
Var
  i: Integer;
  x: Real;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    //20260628
    If (Ret[RetNo].Province = 'AB')
    or (Vl(FetchElm(RetNo, 'S5', 197))>0) then  //has AB income   //20260725
    //continue
    else
    begin
     For i:=1 to 124 do begin Strings[i]:='';Tv[i]:=0;End;
     //does not work?  ClearForm(RetNo,FName);
     SaveTv(RetNo,FName,FNo);
     exit;
    end;

    FillAlbHeader(RetNo, FNo, 1, 2);
    If Strings[45] = '' then
      Strings[45] := 'N';

    Tv[3] := Vl(FetchElm(RetNo, 'T2', 214));

    Tv[4] := Vl(FetchElm(RetNo, 'S1', 37));
    Tv[6] := Vl(FetchElm(RetNo, 'S1', 11));
    Tv[8] := Vl(FetchElm(RetNo, 'S1', 38));
   // Tv[10] := Vl(FetchElm(RetNo, 'S1', 39));    //20260726
   // Tv[12] := Vl(FetchElm(RetNo, 'S1', 12));     //20260726

    Tv[14] := Vl(FetchElm(RetNo, 'S1', 124));

    if Tv[15] = 0 then
      Tv[15] := Tv[14]; // 20200901
    Tv[16] := Vl(FetchElm(RetNo, 'S1', 210)); // 20200901
    If Tv[17] = 0 then
      Tv[17] := Tv[16]; // 20200901

    // Tv[16] := Vl(FetchElm(RetNo,'S1',210));
    // If Tv[17]=0 then Tv[17]:=Tv[16];

    Tv[18] := Vl(FetchElm(RetNo, 'S1', 129));
    If Tv[19] = 0 then
      Tv[19] := Tv[18];

    Tv[20] := Vl(FetchElm(RetNo, 'S1', 214));
    If Tv[21] = 0 then
      Tv[21] := Tv[20];

    Tv[22] := Vl(FetchElm(RetNo, 'S1', 221));
    If Tv[23] = 0 then
      Tv[23] := Tv[22];

    // Tv[24] := Vl(FetchElm(RetNo,'S51',306)); //20140428
    // Vl(FetchElm(RetNo,'S1',223));

    Tv[26] := Vl(FetchElm(RetNo, 'S1', 218));
    Tv[28] := Vl(FetchElm(RetNo, 'S1', 217));
    Tv[30] := Vl(FetchElm(RetNo, 'S1', 222));
    Tv[32] := Vl(FetchElm(RetNo, 'S1', 219));

    // 20210614
    Tv[34] := Vl(FetchElm(RetNo, 'S1', 45)); // as negative line 411
    If Vl(FetchElm(RetNo, 'S1', 131)) > 0 then
      Tv[34] := -Vl(FetchElm(RetNo, 'S1', 131)); // if recapture

    Tv[36] := Vl(FetchElm(RetNo, 'S1', 29));
    Tv[38] := Vl(FetchElm(RetNo, 'S1', 46));
    Tv[42] := Vl(FetchElm(RetNo, 'AS12SUP', 9));
    // Tv[47] := Vl(FetchElm(RetNo,'S51CRN',45));   //20140428
    // Tv[49] := Vl(FetchElm(RetNo,'S51CRN',49));  //20140428

    // 20120523
    Tv[5] := TotMultiple(RetNo, 'AS13', 232);
    Tv[7] := TotMultiple(RetNo, 'AS13', 230);
    Tv[9] := TotMultiple(RetNo, 'AS13', 231);
   // Tv[11] := MaxR(0, Vl(FetchElm(RetNo, 'AS14', 14)));  //20260726
   // Tv[13] := Vl(FetchElm(RetNo, 'AS14', 115));
    //if Tv[13] = 0 then  Tv[13] := Vl(FetchElm(RetNo, 'AS14WS', 30)); // 20171118 //20260726

    { ? missing }
    Tv[23] := Vl(FetchElm(RetNo, 'AS15', 12)) + Vl(FetchElm(RetNo, 'AS15', 11))
      + Vl(FetchElm(RetNo, 'AS15', 20));

    // alb resource allowance
    // Tv[25]:=Vl(FetchElm(RetNo,'AS51',170)); //allowance    //20140428
    If (Tv[25] = 0) then
      Tv[25] := -Vl(FetchElm(RetNo, 'AS51', 163)); // loss

    Tv[27] := Vl(FetchElm(RetNo, 'AS15', 121)) +
      Vl(FetchElm(RetNo, 'AS15', 122));
    Tv[29] := Vl(FetchElm(RetNo, 'AS15', 223)) +
      Vl(FetchElm(RetNo, 'AS15', 224));

    Tv[31] := Vl(FetchElm(RetNo, 'AS15', 411)) + Vl(FetchElm(RetNo, 'AS15', 412)
      ) + Vl(FetchElm(RetNo, 'AS15', 596)) + Vl(FetchElm(RetNo, 'AS15', 597)) +
      Vl(FetchElm(RetNo, 'AS15', 696)) + Vl(FetchElm(RetNo, 'AS15', 697));

    Tv[33] := Vl(FetchElm(RetNo, 'AS15', 319)) +
      Vl(FetchElm(RetNo, 'AS15', 320));

    If Vl(FetchElm(RetNo, 'AS16', 10)) < 0 then
      Tv[35] := Vl(FetchElm(RetNo, 'AS16', 10))
    else
      Tv[35] := Vl(FetchElm(RetNo, 'AS16', 12));

    Tv[37] := Vl(FetchElm(RetNo, 'AS17', 33));
    Tv[39] := Vl(FetchElm(RetNo, 'AS17', 32));

    Tv[41] := 0;
    Tv[41] := Vl(FetchElm(RetNo, 'AS12SUP', 21));

    // Tv[48] := Vl(FetchElm(RetNo,'S51CRN',44));  //20140428

    { remove equal values }
    i := 4;
    Repeat
      If Tv[i] = Tv[i + 1] then
      begin
        If i <> 36 then
        begin
          Tv[i] := 0;
          Tv[i + 1] := 0;
        end;
      end;
      Inc(i, 2);
    until i > 38;
    If Abs(Tv[35]) = Abs(Tv[34]) then
    begin
      Tv[35] := 0;
      Tv[34] := 0;
    end; // 20150520
    If Tv[42] = Tv[41] then
    begin
      Tv[42] := 0;
      Tv[41] := 0;
    end;
    If Tv[47] = Tv[48] then
    begin
      Tv[47] := 0;
      Tv[48] := 0;
    end;

    //20260722 Profl takes the ABS of TV[44], if negative use its ABS
    Tv[44] :=-Tv[4] + Tv[6] - Tv[8] - Tv[10] + Tv[14] - Tv[16]       //+ Tv[12]
      +Tv[18] - Tv[20] - Tv[22] - Tv[26] - Tv[28] - Tv[30] // 20140428 -Tv[24]
      - Tv[32] + Tv[36] - Tv[38] + Tv[42];
    /// /20140428 +Tv[49];   +Tv[47]  //20150510

    if Tv[34] > 0 then // 20210616
      Tv[44] := Tv[44] - Tv[34] // deduct the positive deduction
    Else
      Tv[44] := Tv[44] + Tv[34]; // add the negativerecapture

    // Tv[44]:=Tv[44]+Tv[34];   //20150510  It could be + or -

    Tv[40] := -Tv[5] + Tv[7] - Tv[9] + Tv[13] + Tv[15] - Tv[17] +    //  - Tv[11]
      Tv[19] - Tv[21] - Tv[23] - Tv[27] - Tv[29] - Tv[31] // 20140428 -Tv[25]
      - Tv[33] - Tv[35] + Tv[37] - Tv[39] + Tv[41] + Tv[46];
    // 20140428 +Tv[48];
    Tv[43] := Tv[3] - Tv[44] + Tv[40];
  end; { end with }
  // pg2 -------------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 101, 102);
    // federal 20140504
    With Ret[RetNo] do
    Begin
      Tv[51] := Tv[3];
      Tv[64] := Ln[311];
      Tv[63] := Ln[313] + Ln[314]; // Ln[320];   Ln[312]//20161113
      Tv[62] := Ln[320];
      Tv[61] := Ln[325];
      Tv[60] := Ln[331];
      Tv[59] := Ln[332];
      Tv[58] := Ln[333];
      Tv[56] := Ln[334];
      Tv[54] := Ln[335];
      Tv[25] := LN[336]; //20260726
      Tv[55] := Ln[340];
      Tv[57] := Ln[350];
      Tv[46] := Ln[352]; //20260726
      Tv[53] := Tv[64] + Tv[63] + Tv[62] + Tv[61] + Tv[60] + Tv[59] + Tv[58] +
        Tv[56] + Tv[54] + Tv[55] + Tv[57]; // subtotal
      Tv[65] := Tv[51] - Tv[53] + Tv[52];

      // Alb
      Tv[103] := Tv[43]; // GetAlbNetInc(RetNo);  //20201210
      Tv[104] := Vl(FetchElm(RetNo, 'AS20', 10));
      Tv[105] := Vl(FetchElm(RetNo, 'AS20', 110));
      Tv[106] := Ln[320];
      Tv[107] := Ln[325];
      Tv[108] := Vl(FetchElm(RetNo, 'AS21', 31));
      // If AlbDiffLoss(RetNo) then
      Tv[109] := Round(Vl(FetchElm(RetNo, 'AS21', 15)) *
        Vl(FetchInclusionRateString(RetNo)));

      // If AlbDiffLoss(RetNo) then
      Tv[110] := Vl(FetchElm(RetNo, 'AS21', 116));

      // If AlbDiffLoss(RetNo) then
      Tv[113] := Vl(FetchElm(RetNo, 'AS21', 115));

      // If AlbDiffLoss(RetNo) then
      Tv[116] := Vl(FetchElm(RetNo, 'AS21', 167));

      Tv[114] := Ln[340]; // Vl(FetchElm(RetNo,'T2',226));
      Tv[112] := Ln[350]; // Vl(FetchElm(RetNo,'T2',228));
      Tv[47]  := Ln[352];   //20260726
      Tv[117] := AddColumns(104, 110, 1) + Tv[113] + Tv[116] + Tv[114] +
        Tv[112]; // 20121007

      // If AlbDiffLoss(RetNo) then
      Tv[118] := Vl(FetchElm(RetNo, 'AS21', 10));
    end; // with

    Tv[119] := Tv[103] - Tv[117] + Tv[118];
    If (Tv[118] <> 0) and (Tv[103] - Tv[117] < 0) then
      Tv[119] := Tv[118];

    // 20220601 Tv[122] := Ret[RetNo].Ln[370]; //Vl(FetchElm(RetNo,'T2',233));
    // 20220601 Tv[130] := Tv[119]-Tv[122];

    If Strings[120] + Strings[121] = '' then
      Strings[121] := 'X';

    Tv[115] := Vl(FetchElm(RetNo, 'T2', 335));
    Tv[123] := Vl(FetchElm(RetNo, 'AS12', 40)) -
      Vl(FetchElm(RetNo, 'AS12', 44));
    Tv[124] := MaxR(0, Tv[115] + Tv[123]);

  end; { end with }
  SaveTv(RetNo, FName, FNo);

end;

Procedure AS12SUP(RetNo: Integer; FName: string; FNo: Integer);
Var
  i, As15FNo: Integer;
  x: Real;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 1, 2);
    { Fed }
    Tv[3] := Vl(FetchElm(RetNo, 'S1', 17)) - Vl(FetchElm(RetNo, 'S1', 40));
    Tv[5] := Vl(FetchElm(RetNo, 'S21', 101));
    Tv[9] := Tv[3] + Tv[4] - Tv[5] + Tv[6] + Tv[7] + Tv[8];

    { Alb }
    Tv[13] := Vl(FetchElm(RetNo, 'AS18', 36)) +
      Vl(FetchElm(RetNo, 'AS18', 172));
    // negatives are posted as income
    Tv[14] := 0;
    x := Vl(FetchElm(RetNo, 'AS15', 120));
    If x < 0 then
      Tv[14] := Tv[14] + Abs(x);
    x := Vl(FetchElm(RetNo, 'AS15', 125));
    If x < 0 then
      Tv[14] := Tv[14] + Abs(x);
    x := Vl(FetchElm(RetNo, 'AS15', 221));
    If x < 0 then
      Tv[14] := Tv[14] + Abs(x);
    x := Vl(FetchElm(RetNo, 'AS15', 409));
    If x < 0 then
      Tv[14] := Tv[14] + Abs(x);
    x := Vl(FetchElm(RetNo, 'AS15', 410));
    If x < 0 then
      Tv[14] := Tv[14] + Abs(x);

    As15FNo := GetFormNo('AS15');
    i := 531;
    Repeat
      x := Vl(FetchElmFNo(RetNo, As15FNo, i));
      If x < 0 then
        Tv[14] := Tv[14] + Abs(x);
      Inc(i, 1);
    until i > 535;
    i := 576;
    Repeat
      x := Vl(FetchElmFNo(RetNo, As15FNo, i));
      If x < 0 then
        Tv[14] := Tv[14] + Abs(x);
      Inc(i, 1);
    until i > 580;

    As15FNo := GetFormNo('AS15');
    i := 631;
    Repeat
      x := Vl(FetchElmFNo(RetNo, As15FNo, i));
      If x < 0 then
        Tv[14] := Tv[14] + Abs(x);
      Inc(i, 1);
    until i > 635;
    i := 676;
    Repeat
      x := Vl(FetchElmFNo(RetNo, As15FNo, i));
      If x < 0 then
        Tv[14] := Tv[14] + Abs(x);
      Inc(i, 1);
    until i > 680;

    Tv[15] := GetAlbActaDed(RetNo);
    Tv[21] := Tv[13] + Tv[14] - Tv[15] + Tv[18] + Tv[19];
  end;
  SaveTv(RetNo, FName, FNo);
end;





//jz//20260813  - re arragned to make easier to read/flow properly and removed obsolete code
//              - fixed recapture, added transfer of s8 class empty to as13 terminal loss, stopped terminal click if no Cls
//jz//20260810  - changed lease range to lease yr to match and be filled by s8 as well as work on its own in as13
//
//jz//20260809
//              - fixed rate ovr/terminal loss indicator issue when not copying from s8
//              - fixed date adding slash mistake
//jz//20260806
//              - totally redid transfer from s8
//              - added col vars for everything
//              - cleaned up code, hoping regular calc still works
//jz//20260805
//              - use GetPropertyType to judge if AIIP note:all RIIP and ZEV also considered AIIP for AB
//              - adjusted AIIP calc
//              - changed cols to var and added colinc such that do not need + k * 16 everywhere
//              - addressed various other issues
procedure AS13(RetNo: Integer; FName: string; FNo: Integer);
const
 Rows = 10;
Var
  //i, k, k1, j, w: Integer; //20260703 Alex
  i,k: Integer;

  OrigCostNdx, OrigCostS8Ndx:Integer;  //20260716cz

  FInst: String;
  S8FNo: Integer;
  Cls, s, S1, S2: String;
  TotColumn4: Real;

  //UccStart, Additions, Adjustments,
  Proceeds, UCC, HalfRuleAmount,
    UCCReduced: Real;

  //ImmediateExpensing: Real; // 20220730

  OverrideIndic, HalfYearIndic, TermLossIndic: String;

  Recapture, TerminalLoss, CCA, UCCEnd, z: Real;
  DaysInTaxYear: Integer; // > 365 then DaysInTaxYear := 365;
  // cls 13 relted

  // additional fields after aiip
  Aiip: Boolean;
  AdditionsAiip, AssistanceReceived, RepaidAmount, ProceedsAiip,
    NetCapCostAdditionsAiip, UccAdjustmentAiip, UccAdjustmentNONAiip: Real;
  Aiipfactor: String;

  s8propertyType,propertyType:string;

  OverrideBox, HalfRuleBox, TerminalLossBox: String;
  HalfYearAmount: Real;

  //LeaseStart, LeaseEnd: string;
  LeaseTerm: Real;

  LeaseAdjustedCost: Real; // RemainingLeaseTerm:Real;
  LeaseRate: string;  //LeaseMaxCca: Real;

  PurchaseDate: String;

  //CCARate:string; //Rate: String;

  x: Real;
  y: Real;

  FedS8FNo      : Integer;
  FedS8DtAcqNdx: Integer; //jz//202600805

  ln:integer;

  // columns first row index
  colOrigCost,colOrigCostInc,
  colPurchaseDate,colPurchasedateInc,
  colLeaseYrs,colLeaseYrsInc,
  S8colLeaseYrs,S8colLeaseYrsInc,

  colAIIP, colAIIPInc,
  s8colAIIP, s8colAIIPInc,
  colFactor, colFactorInc : integer;

  clsCol2,clsCol2Inc,
  clsCol3,clsCol3Inc  : integer;

  col11Ovr, col12Ovr  : integer;

  col1, col2, col3, col4, col5, col6, col7, col8, col9, col10,col11,col12,
  col13,col14,col15,col16,col17,col18,col19,col20,col21,col22,col23,col24 : integer;

  col1inc, col2inc, col3inc, col4inc, col5inc, col6inc, col7inc, col8inc, col9inc, col10inc,col11inc,col12inc,
  col13inc,col14inc,col15inc,col16inc,col17inc,col18inc,col19inc,col20inc,col21inc,col22inc,col23inc,col24inc  : integer;

  s8col1,  s8col1inc,  s8col2,  s8col2inc,  s8col3,  s8col3inc,  s8col4,  s8col4inc,  s8col5,  s8col5inc,  s8col6,  s8col6inc,
  s8col7, s8col7inc,   s8col8,  s8col8inc,  s8col9,  s8col9inc,  s8col10, s8col10inc, s8col11, s8col11inc, s8col12, s8col12inc,
  s8col13, s8col13inc, s8col14, s8col14inc, s8col15, s8col15inc, s8col16, s8col16inc, s8col17, s8col17inc, s8col18, s8col18inc,
  s8col19, s8col19inc, s8col20, s8coli20nc, s8col21, s8col21inc, s8col22, s8col22inc,
  s8colOrigCost, s8colOrigCostInc,
  s8colPurchaseDate, s8colPurchasedateInc,
  s8Col15factor, s8Col16factor,
  s8Col15factorInc, s8Col16factorInc : Integer;

  //colRateOVR,colRateOVRInc,
  //colOvr, colOvrInc,
  colHalfYr, colHalfYrInc,
  colTerminal, colTerminalInc,
  s8ColClassEmpty,s8ColClassEmptyInc : integer;

  col2Tot, col3Tot, col5Tot, col8Tot, col11Tot,
  col13Tot,col21Tot,col22Tot,col23Tot,col24Tot  : integer;

  populateFromFedS8:boolean;

                            //has to be below var declaration
                            //all this would probably be better as some combo of array and record??
                            procedure setColNDXs();
                            begin

                              colAIIP         := 356; colAIIPInc          := 1; s8colAIIP         := 293; s8colAIIPInc         := 1;
                              colOrigCost     := 371; colOrigCostInc      := 1; s8colOrigCost     := 313; s8colOrigCostInc     := 1;
                              colPurchaseDate := 236; colPurchasedateInc  := 1; s8colPurchaseDate := 233; s8colPurchasedateInc := 1;

                              colLeaseYrs     := 166; colLeaseYrsInc      := 1; s8colLeaseYrs     := 323; s8colLeaseYrsInc     := 1;


                              colFactor       := 343; colFactorInc        := 1; s8Col15factor     := 263; s8Col15factorInc     := 1;
                                                                                s8Col16factor     := 253; s8Col16factorInc     := 1;
                              clsCol2 := 384; clsCol2Inc := 1;
                              clsCol3 := 515; clsCol3Inc := 1;

                              col1  := 6;             col1inc  := 16;           s8col1 :=  6;         s8col1inc  := 22;
                              col2  := 7;             col2inc  := 16;           s8col2 :=  7;         s8col2inc  := 22;
                              col3  := 8;             col3inc  := 16;           s8col3 :=  8;         s8col3inc  := 22;
                              col4  := 463;           col4inc  := 1;            s8col4 :=  9;         s8col4inc  := 22;
                              col5  := 9;             col5inc  := 16;           s8col5 :=  10;        s8col5inc  := 22;
                              col6  := 265;           col6inc  := 1;            s8col6 :=  11;        s8col6inc  := 22;
                              col7  := 278;           col7inc  := 1;            s8col7 :=  12;        s8col7inc  := 22;
                              col8  := 10;            col8inc  := 16;           s8col8 :=  13;        s8col8inc  := 22;
                              col9  := 400;           col9inc  := 1;            s8col9 :=  14;        s8col9inc  := 22;
                              col10 := 11;            col10inc := 16;           s8col10 := 15;        s8col10inc := 22;
                              col11 := 424;           col11inc := 1;            s8col11 := 16;        s8col11inc := 22;
                              col12 := 437;           col12inc := 1;            s8col12 := 17;        s8col12inc := 22;
                              col13 := 450;           col13inc := 1;            s8col13 := 18;        s8col13inc := 22;
                              col14 := 252;           col14inc := 1;            s8col14 := 19;        s8col14inc := 22;
                              col15 := 476;           col15inc := 1;            s8col15 := 20;        s8col15inc := 22;
                              col16 := 291;           col16inc := 1;            s8col16 := 21;        s8col16inc := 22;
                              col17 := 304;           col17inc := 1;            s8col17 := 22;        s8col17inc := 22;
                              col18 := 317;           col18inc := 1;            s8col18 := 23;        s8col18inc := 22;
                              col19 := 330;           col19inc := 1;            s8col19 := 24;        s8col19inc := 22;
                              col20 := 17;            col20inc := 16;           s8col20 := 25;        s8coli20nc := 22;
                              col21 := 18;            col21inc := 16;           s8col21 := 26;        s8col21inc := 22;
                              col22 := 19;            col22inc := 16;           s8col22 := 27;        s8col22inc := 22;
                              col23 := 20;            col23inc := 16;
                              col24 := 21;            col24inc := 16;

                              col11Ovr := 216;        col12Ovr := 217;

                              //colRateOVR  := 489;     colRateOVRInc :=1;
                              //colOvr      := 14;      colOvrInc     :=16;

                              colHalfYr   := 15;      colHalfYrInc  :=16;
                              ColTerminal := 16;      ColTerminalInc:=16;       s8ColClassEmpty := 303;s8ColClassEmptyInc := 1;

                              col2Tot  := 249;
                              col3Tot  := 234;
                              col5Tot  := 250;
                              col8Tot  := 235;
                              col11Tot := 77;
                              col13Tot := 93;
                              col21Tot := 230;
                              col22Tot := 231;
                              col23Tot := 232;
                              col24Tot := 251;


                            end;


                            procedure incrAll();
                            begin
                              //maybe should seperate as13 and s8 incr?? leave for now

                              inc(clsCol2,clsCol2Inc);
                              inc(clsCol3,clsCol3Inc);

                              inc(colAIIP,        colAIIPInc);          inc(s8colAIIP,        s8colAIIPInc);
                              inc(colOrigCost,    colOrigCostInc);      inc(s8colOrigCost,    s8colOrigCostInc);
                              inc(colPurchaseDate,colPurchasedateInc);  inc(s8colPurchaseDate,s8colPurchasedateInc);
                              inc(colLeaseYrs,    colLeaseYrsInc);      inc(S8colLeaseYrs,    S8colLeaseYrsInc);
                              inc(colFactor,      colFactorInc);        inc(s8Col15factor,    s8Col15factorInc);
                              inc(s8Col16factor,  s8Col16factorInc);

                              inc(col1, col1inc);  inc(s8col1, s8col1inc);
                              inc(col2, col2inc);  inc(s8col2, s8col2inc);
                              inc(col3, col3inc);  inc(s8col3, s8col3inc);
                              inc(col4, col4inc);  inc(s8col4, s8col4inc);
                              inc(col5, col5inc);  inc(s8col5, s8col5inc);
                              inc(col6, col6inc);  inc(s8col6, s8col6inc);
                              inc(col7, col7inc);  inc(s8col7, s8col7inc);
                              inc(col8, col8inc);  inc(s8col8, s8col8inc);
                              inc(col9, col9inc);  inc(s8col9, s8col9inc);
                              inc(col10,col10inc); inc(s8col10,s8col10inc);
                              inc(col11,col11inc); inc(s8col11,s8col11inc);
                              inc(col12,col12inc); inc(s8col12,s8col12inc);
                              inc(col13,col13inc); inc(s8col13,s8col13inc);
                              inc(col14,col14inc); inc(s8col14,s8col14inc);
                              inc(col15,col15inc); inc(s8col15,s8col15inc);
                              inc(col16,col16inc); inc(s8col16,s8col16inc);
                              inc(col17,col17inc); inc(s8col17,s8col17inc);
                              inc(col18,col18inc); inc(s8col18,s8col18inc);
                              inc(col19,col19inc); inc(s8col19,s8col19inc);
                              inc(col20,col20inc); inc(s8col20,s8coli20nc);
                              inc(col21,col21inc); inc(s8col21,s8col21inc);
                              inc(col22,col22inc); inc(s8col22,s8col22inc);
                              inc(col23,col23inc);
                              inc(col24,col24inc);

                              //inc(colRateOVR,colRateOVRInc);
                              //inc(colOvr,      colOvrInc);

                              inc(colHalfYr,   colHalfYrInc);
                              inc(ColTerminal, ColTerminalInc);
                              inc(s8ColClassEmpty,s8ColClassEmptyInc);
                            end;

                            procedure populateClassSections();
                            begin
                              with Ret[RetNo].Frm[FNo] do
                              begin
                                // repeate class for each section from Part 2
                                Cls := AllTrim(Strings[col1]); // 20190719 //alltrim
                                Strings[clsCol2] := Cls; // 20190705
                                Strings[clsCol3] := Cls; // 20220730 //dupl/copy cless
                              end;
                            end;


                            procedure calcColTotals();
                            var i:integer;
                            begin
                              setColNDXs();

                              with Ret[RetNo].Frm[FNo] do
                              begin
                                Tv[col2Tot]  := 0;
                                Tv[col3Tot]  := 0;
                                Tv[col5Tot]  := 0;
                                Tv[col8Tot]  := 0;
                                Tv[col11Tot] := 0;
                                Tv[col13Tot] := 0;
                                Tv[col21Tot] := 0;
                                Tv[col22Tot] := 0;
                                Tv[col23Tot] := 0;
                                Tv[col24Tot] := 0;

                                for i := 1 to Rows do
                                begin
                                  Tv[col2Tot]  := Tv[col2Tot]  + Tv[col2];  //col2  total
                                  Tv[col3Tot]  := Tv[col3Tot]  + Tv[col3];  //col3  total
                                  Tv[col5Tot]  := Tv[col5Tot]  + Tv[col5];  //col5  total
                                  Tv[col8Tot]  := Tv[col8Tot]  + Tv[col8];  //col8  total
                                  Tv[col11Tot] := Tv[col11Tot] + Tv[col11]; //col11 total
                                  Tv[col13Tot] := Tv[col13Tot] + Tv[col13]; //col13 total
                                  Tv[col21Tot] := Tv[col21Tot] + Tv[col21]; //col21 total
                                  Tv[col22Tot] := Tv[col22Tot] + Tv[col22]; //col22 total
                                  Tv[col23Tot] := Tv[col23Tot] + Tv[col23]; //col23 total
                                  Tv[col24Tot] := Tv[col24Tot] + Tv[col24]; //col24 total

                                  incrAll();
                                end;

                              end;
                            end;



begin


  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    //20260628
    If (Ret[RetNo].Province = 'AB')
    or (Vl(FetchElm(RetNo, 'S5', 197))>0) then  //has AB income   //20260725
    //continue
    else
    begin
     For i:=1 to 524{488} do begin Strings[i]:='';Tv[i]:=0;End; //20260717 Alex
     //does not work?  ClearForm(RetNo,FName);
     SaveTv(RetNo,FName,FNo);
     exit;
    end;
  end;

  //START COPY FROM FED S8 ----------------------------->
  with Ret[RetNo].Frm[FNo] do
  begin
    setColNDXs();


    //S8FNo := GetFormNo('S8#1'); // 20220826
    //FInst := ExtractFormInst(FName);
    FInst := ExtractFormInst(FName);


    If Strings[3] = '' then Strings[3] := 'N'; // instead of 13  //20120201
    If UpperCase(Strings[3]) <> 'Y' then  //UpperCase(Strings[3]) <> 'Y' means if do not differ from fed s8
      populateFromFedS8 := true
    else
      populateFromFedS8 := false;

    If populateFromFedS8 then
    begin
      FedS8FNo := GetFormNo('S8' + FInst);

      If (FedS8FNo > 0) and (Ret[RetNo].Frm[FedS8FNo].Count > 0) then
      Begin

        for ln := 1 to Rows do
        begin

          //Col AIIP //jz//20260804 - for alberta purposes everything makes it eligible for AIIP
          s8propertyType := FetchElmFNo(RetNo, FedS8FNo, s8colAIIP);
          If  (s8propertyType='AIIP'   ) or
              (s8propertyType='RIIP'   ) or
              (s8propertyType='AIIPZEV') or
              (s8propertyType='RIIPZEV')
          then
            Strings[colAIIP]:='X'  //20260721CZ
          Else
            Strings[colAIIP]:='';   //20260717

          If  (s8propertyType='HALFYR') then Strings[colHalfYr]:='X'
                                        else Strings[colHalfYr]:='';

          tv[colOrigCost]           := Vl(FetchElmFNo(RetNo, FedS8FNo, s8colOrigCost));
          strings[colPurchaseDate]  :=    FetchElmFNo(RetNo, FedS8FNo, s8colPurchaseDate);
          strings[colLeaseYrs]      :=    FetchElmFNo(RetNo, FedS8FNo, s8colLeaseYrs);

          strings[col1] :=    FetchElmFNo(RetNo, FedS8FNo, s8col1);

          populateClassSections(); //Cls

          tv[col2]      := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col2));
          tv[col3]      := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col3));

          //tv[col4]      := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col)); ???

          tv[col5]      := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col6));  //adj
          tv[col6]      := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col7));  //adj assistance
          tv[col7]      := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col8));  //adj repaid
          tv[col8]      := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col9));  //proceeds disposition
          //tv[col9]      := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col));
          tv[col10]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col10)); //UCC before CCA claim
          //tv[col11]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col));
          //tv[col12]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col)); //immediate expensing
          //tv[col13]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col)); //cost of acquisitions on remainder
          //tv[col14]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col)); //cost of acquisitions from AIIP

          //tv[col15]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col));
          //tv[col16]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col));
          //tv[col17]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col));

          //col18
          if      (Vl(FetchElmFNo(RetNo, FedS8FNo, s8col15)) > 0) then tv[col18]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col15))    //UCC adjustment that is AIIP
          else if (Vl(FetchElmFNo(RetNo, FedS8FNo, s8col16)) > 0) then tv[col18]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col16))    //UCC adjustment that is AIIP
          else                                                         tv[col18]     := 0;
          //Relevant factor
          if      (Vl(FetchElmFNo(RetNo, FedS8FNo, s8Col15factor)) > 0) then  Strings[ColFactor]:= FetchElmFNo(RetNo, FedS8FNo, s8Col15factor)
          else if (Vl(FetchElmFNo(RetNo, FedS8FNo, s8Col16factor)) > 0) then  Strings[ColFactor]:= FetchElmFNo(RetNo, FedS8FNo, s8Col16factor)
          else                                                                Strings[ColFactor]:= '0';

          tv[col19]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col17));   //UCC adjustment other than AIIP
          strings[col20]:=    FetchElmFNo(RetNo, FedS8FNo, s8col18);    //CCA rate

          strings[ColTerminal]:= FetchElmFNo(RetNo, FedS8FNo, s8ColClassEmpty); //Class empty to terminal

          tv[col21]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col19));   //recapure
          tv[col22]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col20));   //terminal loss
          tv[col23]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col21));   //CCA
          tv[col24]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col22));   //year end UCC

          incrAll();

        end; //for

        calcColTotals();

      end;  //if (FedS8FNo > 0) and (Ret[RetNo].Frm[FedS8FNo].Count > 0)

      SaveTv(RetNo, FName, FNo);
      EXIT;
    end;    //if populateFromFedS8
  end; // with from copy from fed s8

  // <----------------------------- END COPY FROM FED S8

  setColNDXs();     //reset them again just in case

  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 1, 2); // 20190626
    DaysInTaxYear := Ret[RetNo].DaysInYear;
    If DaysInTaxYear > 365 then DaysInTaxYear := 365;

    If Strings[4] + Strings[5]  = '' then Strings[5]        := 'X';
    If Strings[col11Ovr]        = '' then Strings[col11Ovr] := 'N'; // 20221107
    If Strings[col12Ovr]        = '' then Strings[col12Ovr] := 'Y';


    for k := 0 to Rows-1 {12} do // 12 do //20260717 Alex - 10 rows only
    Begin

      //Col 1 ----------------------------------------
      populateClassSections(); //Cls

      // replace yyymmdd with yyy/mm/dd for date
      s := LeftStr(Strings[colPurchaseDate], 8);
      if (Length(s) = 8) and (Numeric(s)) then
        Strings[colPurchaseDate] := LeftStr(s, 4) + '/' + MidStr(s, 5, 2) + '/'+ RightStr(s, 2);  //jz20260809 - fixed date MidStr(s, 6, 2) to MidStr(s, 5, 2)

      If LeaseHold(Cls) then // if Cls='13' then
      begin
        if strings[ColLeaseYrs] = '' then
          LeaseTerm := 5 // Default;
        else
          LeaseTerm := vl(strings[ColLeaseYrs]);

        if LeaseTerm > 0 then //default LeaseTerm is 5 so shouldnt need condition but add just in case
          LeaseRate := FormatFloat('####.##', 100 / LeaseTerm);

        strings[ColLeaseYrs] := FormatFloat('##',LeaseTerm);

        //LeaseMaxCCA := Tv[colOrigCost] / LeaseTerm; // 20190611
        //20260717 Alex >>>
        //Rate := FormatFloat('####.##', 100 / LeaseTerm); // 20190601
        //Strings[col20] := Rate;
        //20260717 Alex <<<
        // if rate='INF' then ShowMessage('inf rate');

        // end;
      end;

      //Col AIIP ----------------------------------------
      //jz//20260805 - USE GetPropertyType instead of previous
      //propertyType := GetPropertyType(retNo, lCls, strings[lColAquiredDate], strings[lColAvailableDate], FetchElm(RetNo, 'T2', 10), FetchElm(RetNo, 'T2', 11));
      propertyType := GetPropertyType(retNo, strings[col1], leftstr(strings[colPurchaseDate],10), leftstr(strings[colPurchaseDate],10), FetchElm(RetNo, 'T2', 10), FetchElm(RetNo, 'T2', 11));
      If  (propertyType='AIIP'   ) or
          (propertyType='RIIP'   ) or
          (propertyType='AIIPZEV') or
          (propertyType='RIIPZEV')
      then
        Strings[colAIIP]:='X'  //20260721CZ
      Else
        Strings[colAIIP]:='';
      //jz//20260804
      if Strings[colAIIP] = 'X' then AIIP := TRUE else AIIP := FALSE;

      //Col HalfYr Terminal Loss (Class Empty)  ----------------------------------->
      //set up override indicators
      //If UpperCase(Strings[colOvr])     = 'O' then Strings[colOvr]    := 'Y'; // override
      If UpperCase(Strings[colHalfYr])  = 'H' then Strings[colHalfYr] := 'Y'; // half year

      if AIIP=True                            then Strings[colHalfYr] := 'N';  // half year

      if (AIIP=false) and (cls>'')            then Strings[colHalfYr] := 'Y'; // if not AIIP defualt to half year

      //If UpperCase(Strings[colOvr])      = 'X' then Strings[colOvr]       := 'Y'; // override
      If UpperCase(Strings[colHalfYr])   = 'X' then Strings[colHalfYr]    := 'Y'; // half year

      If UpperCase(Strings[colTerminal]) = 'X' then Strings[colTerminal]  := 'Y'; // Term loss
      If UpperCase(Strings[colTerminal]) = 'T' then Strings[colTerminal]  := 'Y'; // Term loss  //jz20260809

      If Cls = '' then
      begin
        Strings[colHalfYr]    := '';
        Strings[colTerminal]  := '';
      end;

      // <----------------------------------- end Col HalfYr Terminal Loss (Class Empty)

      //OverrideIndic := UpperCase(Strings[colOvr]);
      HalfYearIndic := UpperCase(Strings[colHalfYr]);
      TermLossIndic := UpperCase(Strings[colTerminal]);
      // calculate each Column mow
      //UccStart  := Tv[col2]; // col2
      //Additions := Tv[col3]; // col3

      //Col 2 USER INPUT ----------------------------------------
      //Col 3 USER INPUT  ----------------------------------------
      if (Cls = '10.1') and (PurchaseDate < GetTaxationYearStart(RetNo)) then Tv[col3] := 0; // no additions allowed
      //Col 4 USER INPUT  ----------------------------------------
      if DiepClass(Cls) = False then Tv[col4] := 0; // 20221115 //Tv[col2 + k * 16] := 0; // 20221107
      if Tv[col4] > Tv[col3]    then Tv[col4] := Tv[col3];

      //Col 5 USER INPUT ----------------------------------------
      //Col 6 USER INPUT ----------------------------------------
      Tv[col6] := MaxR(0, Tv[col6]); //20220621
      //Col 7 USER INPUT ----------------------------------------
      Tv[col7] := MaxR(0, Tv[col7]); //20220621
      //Col 8 USER INPUT ----------------------------------------
      Tv[col8] := MaxR(0, Tv[col8]);
      //Col 9 USER INPUT ----------------------------------------
      if DiepClass(Cls) = False then Tv[col9] := 0; // 20221015
      if Tv[col9] > Tv[col8]    then Tv[col9] := Tv[col8];



      //Col 10 ----------------------------------------
      //if Aiip = True then Tv[col10]:= 0 //20260720 Alex
      //else //20260720 Alex
      Tv[col10] := Tv[col2] + Tv[col3] + Tv[col5] - Tv[col8];

      //Col 11 USER INPUT semi automatic----------------------------------------
      if Strings[col11Ovr] = ''               then Strings[col11Ovr] := 'Y';
      if UpperCase(Strings[col11Ovr]) = 'Y'   then Tv[col11] := Tv[col4]; // 20221108
      if Tv[col11] > Tv[col4]                 then Tv[col11] := Tv[col4]; // 20221108

      //Col 12 USER INPUT semi automatic ----------------------------------------
      //       //20220827 imm expensing amount = designated
      If UpperCase(Strings[col12Ovr]) = 'Y' then       // autofill col 12
      Begin
        If  (Tv[col4] > 0) and (Tv[col12] = 0) then Tv[col12] := Tv[col4]; // 20221017
      end;
      if Tv[col12] > Tv[col4]                   then Tv[col12] := Tv[col11];
      if Ret[RetNo].CorpType <> CCPC            then Tv[col12] := 0; // 20221115

      //Col 13 ----------------------------------------
        //if Aiip = True then Tv[col13]:= 0 else  //20260720 Alex
      Tv[col13] := MaxR(0, Tv[col3] - Tv[col4] + Tv[col11] - Tv[col12]); // 20220912 MaxR

      //Col 14 ----------------------------------------
      //jz//20260804 - had it backwards, if AIIP then add to column, make vtCalc
      if Aiip = True  then Tv[col14] := MaxR(0, Tv[col13])  //20260717 Alex
                      else Tv[col14] := 0;                  //20260717 Alex


      //Col 15 ----------------------------------------
      Tv[col15] := MaxR(0, Tv[col10] - Tv[col12]);

      //Col 16 ----------------------------------------
      if Aiip = True  then Tv[col16] := MaxR(0, Tv[col8] - Tv[col9] + Tv[col6] - Tv[col13] + Tv[col14] - Tv[col7])
                      else Tv[col16] := 0;
      //Col 17 ----------------------------------------
      if Aiip = True  then Tv[col17] := MaxR(0, Tv[col14] - Tv[col16])
                      else Tv[col17] := 0;

      //Col 18 FACTOR ----------------------------------------
      AIIPfactor          := '';
      Strings[colFactor]  := '';
      if (Cls > '') and (Aiip = True)  then
      begin
        if tv[col17] > 0 then
        begin

          if      (propertyType = 'RIIP') or (propertyType = 'RIIPZEV') then
            AIIPfactor := getRIIPFactor(Cls,leftstr(Strings[colPurchaseDate],10),leftstr(Strings[colPurchaseDate],10))
          else if (propertyType = 'AIIP') or (propertyType = 'AIIPZEV') then
            AIIPfactor := getAIIPFactor(Cls,leftstr(Strings[colPurchaseDate],10),leftstr(Strings[colPurchaseDate],10));

        end;
        Strings[colFactor] := AIIPfactor;
      end;

      //Col 18 ----------------------------------------
      if AIIP = True  then  Tv[col18] := Tv[col17] * FractionToReal(Strings[colFactor])//;//20260717 Alex
                      else  Tv[col18]:= 0; //20260717 Alex

      //Col 19 ----------------------------------------
      //jz20260813 - half year - done if AIIP false not true as per instructions
      if AIIP = FALSE then Tv[col19]:= MaxR(0, (0.5 * (Tv[col13] - Tv[col14] - Tv[col6] +  Tv[col7] -  Tv[col8] + Tv[col9]) ) ) //20260720 Alex
                      else Tv[col19]:= 0; //20260717 Alex


      //Col 20 ----------------------------------------
      //CCA RATE //CCA RATE //CCA RATE //CCA RATE //CCA RATE //CCA RATE
      strings[col20] := GetCCARate(Cls);
      //jz20260814 - apply special cases here (leasehold, fast write off)
      if      LeaseHold(Cls) then
      begin
        strings[col20] := LeaseRate;
      end;

      //jz20260814 - fast write off not applicable
      //           - multiple rates apply for these, will not try to automate right now, will leave for user
      //           - small explaination put in Cls drop down d file
      {
      // fast write off //20190608 ----->
      else if (Cls = '24') or (Cls = '27') or (Cls = '29') or (Cls = '34') then
      begin
        strings[col20] := '100'; //CCArate // fast write off //20220802
        Strings[colHalfYr] := ''; // fast write off NO half year rule
        if AIIP = True then // 20190705
          Tv[col3] := 0; // additions
      end;
      // <----- fast write off //20190608
      }

      //jz - not sure why this matters but keep it
      if Vl(strings[col20]) = 100             then Strings[colHalfYr] := 'N';


      //Col 21 ----------------------------------------
      //recapture  //20260717 Alex >>>
      Tv[col21] := 0;
      if      ( Cls = '10.1')                               then Tv[col21] := 0               // 20230516
      else if (UpperCase(Strings[colTerminal]) = 'Y') and                                     //jz20260813 - only if Terminal
              (Tv[col10] < 0)                               then Tv[col21] := Abs(Tv[col10]);

      //Col 22 ----------------------------------------
      //Terminal loss
      Tv[col22] := 0;
      if  (UpperCase(Strings[colTerminal]) = 'Y') and (Tv[col10] > 0) //jz20260809
                        then Tv[col22] := Tv[col10];
      if (Cls = '10.1') then Tv[col22] := 0; // 20230516

      //Col 23 ----------------------------------------
      If (Tv[col21] = 0) and (Tv[col22] = 0) then       // There is CCA (no Termloss, no Recapture)
      begin
        Tv[col23] := ((Tv[col15] + Tv[col18] - Tv[col19]) * Vl(Strings[col20]) / 100) + Tv[col12];
        if Ret[RetNo].DaysInYear < 365 then begin Tv[col23] := Tv[col23] * Ret[RetNo].DaysInYear / 365; end;
      end
      Else //Termloss or recapture > 0 //20230512
      begin
        Tv[col23] := 0; // if recapture or term loss then CCA =0
        // proration:?
        if Ret[RetNo].DaysInYear < 365 then
        Begin
          // Tv[col21]:=Tv[col21] / 365;  //recapture
          // Tv[col22]:=Tv[col22] / 365; //terminal loss
        End;
      end;

      //Col 24 ----------------------------------------
      if UpperCase(Strings[colTerminal]) = 'Y' // term loss //jz20260809
      then
        Tv[col24] := 0 // no UCC end eny more
      Else
        Tv[col24] := MaxR(0, Tv[col10] - Tv[col23]);

      AdditionsAiip := Tv[col14];
      // assistance part of col 5
      // If Tv[265+k*1]>Tv[9+k*16] then Tv[265+k*1]:=Tv[9+k*16];  //20220621
      AssistanceReceived := Tv[col6];
      RepaidAmount := Tv[col7 * 1]; // col7
      // 20220621  //from aboeve //20220731
      // Proceeds:=Tv[col8+k*16];  //20220731


      ProceedsAiip := Tv[col16];

      HalfRuleAmount := 0;
      UCC := 0;
      UCCReduced := 0;
      Recapture := 0;
      TerminalLoss := 0;

      if Cls = '' then
      begin
        UCC             := 0; //UCC
        HalfRuleAmount  := 0; //HalfRuleAmount
        UCCReduced      := 0; //UCCReduced
        Recapture       := 0; //Recapture
        TerminalLoss    := 0; //TerminalLoss
        Tv[col23]       := 0; //CCA
        UCCEnd          := 0; //UCCEnd
      end;

      UCC := Tv[col2] + Tv[col3] + Tv[col5] - AssistanceReceived + RepaidAmount - Proceeds; // 20190606pm
      if (Cls = '10.1') and (Proceeds > 0) then
        UCC := Tv[col2] + Tv[col3] + Tv[col5] - AssistanceReceived + RepaidAmount; // 20190820 Get the CCA on disposal

      If LeaseHold(Cls) then // if cls='13' then //20190611
      Begin
        LeaseAdjustedCost := Tv[colOrigCost] - Tv[col2] + Tv[col3] + Tv[col5] - AssistanceReceived + RepaidAmount;
        UCCReduced := Tv[col2] + Tv[col3] + Tv[col5] - AssistanceReceived + RepaidAmount;
      End;

      If AIIP=True then HalfYearIndic:='N'; //20260705

      if AIIP = False then // 20190706
      Begin
        if UpperCase(HalfYearIndic) = 'Y' then         /// /20190605
        begin
          if UpperCase(OverrideIndic) <> 'Y' then // 20190605
          begin
            HalfRuleAmount :=
              MaxR(0, 0.5 * (Tv[col3] - AssistanceReceived + RepaidAmount - Proceeds));
            if LeaseHold(Cls) then
              HalfRuleAmount := MaxR(0, 0.5 * (Tv[col3] - Proceeds));
            // 20190613
            HalfRuleAmount := RoundCorrect(HalfRuleAmount);
          end;
        end
        else
          HalfRuleAmount := 0;


        // from below  //20220619
        if (Cls = '12') OR (Cls = '52') Or (Cls = '24') or (Cls = '27') or
          (Cls = '29') or (Cls = '34') // fast write off //20190622
        then
          UccAdjustmentNONAiip := 0; // 20190622
        UCCReduced := UCC - HalfRuleAmount;
        if LeaseHold(Cls) then
          UCCReduced := UCC; // 20190611
        ProceedsAiip := 0;
        NetCapCostAdditionsAiip := 0;
        UccAdjustmentAiip := 0;
      end // 20220619
      Else // If (Aiip=True) then
      Begin
        HalfRuleAmount := 0; // 20190608
        // 20190707
        ProceedsAiip := MaxR(0, Proceeds + AssistanceReceived - Tv[col3] +
                        AdditionsAiip - RepaidAmount);
        NetCapCostAdditionsAiip := MaxR(0, AdditionsAiip - ProceedsAiip);
        if (Cls = '10.1') and (Proceeds > 0) then
          NetCapCostAdditionsAiip := AdditionsAiip;

        UccAdjustmentAIIP     := NetCapCostAdditionsAiip * Vl(Aiipfactor);
        UccAdjustmentNONAIIP  := MaxR(0, 0.5 * (Tv[col3] - AdditionsAiip - AssistanceReceived +
                                 RepaidAmount - Proceeds)); // 20190622 moved from below

        if (Cls = '12') OR (Cls = '52') Or (Cls = '24') or (Cls = '27') or
          (Cls = '29') or (Cls = '34') then
          UccAdjustmentNONAiip := 0; // 20190622  //fast write off //20190622
      End; // 20220619
      //INCREMENTS //jz//20260805 move all to one place
      incrAll();
    End; // k 0 to 12  //k is the wow bing processed starts from k=0

    //TOTALS //jz//20260805 move totals all to one place
    calcColTotals();

  End; // with?
  SaveTv(RetNo, FName, FNo);
end;




(*
//jz//20260810  - changed lease range to lease yr to match and be filled by s8 as well as work on its own in as13
//
//jz//20260809
//              - fixed rate ovr/terminal loss indicator issue when not copying from s8
//              - fixed date adding slash mistake
//jz//20260806
//              - totally redid transfer from s8
//              - added col vars for everything
//              - cleaned up code, hoping regular calc still works
//jz//20260805
//              - use GetPropertyType to judge if AIIP note:all RIIP and ZEV also considered AIIP for AB
//              - adjusted AIIP calc
//              - changed cols to var and added colinc such that do not need + k * 16 everywhere
//              - addressed various other issues
procedure AS13(RetNo: Integer; FName: string; FNo: Integer);
const
 Rows = 10;
Var
  //i, k, k1, j, w: Integer; //20260703 Alex
  i,k: Integer;

  OrigCostNdx, OrigCostS8Ndx:Integer;  //20260716cz

  FInst: String;
  S8FNo: Integer;
  Cls, s, S1, S2: String;
  TotColumn4: Real;
  OriginalCost: Real;
  UccStart, Additions, Adjustments, Proceeds, UCC, HalfRuleAmount,
    UCCReduced: Real;

  ImmediateExpensing: Real; // 20220730

  OverrideIndic, HalfYearIndic, TermLossIndic: String;

  Recapture, TerminalLoss, CCA, UCCEnd, z: Real;
  DaysInTaxYear: Integer; // > 365 then DaysInTaxYear := 365;
  // cls 13 relted
  AssetInfo: String;
  // additional fields after aiip
  Aiip: Boolean;
  AdditionsAiip, AssistanceReceived, RepaidAmount, ProceedsAiip,
    NetCapCostAdditionsAiip, UccAdjustmentAiip, UccAdjustmentNONAiip: Real;
  Aiipfactor: String;

  s8propertyType,propertyType:string;

  OverrideBox, HalfRuleBox, TerminalLossBox: String;
  HalfYearAmount: Real;

  //LeaseStart, LeaseEnd: string;
  LeaseTerm: Real;

  LeaseAdjustedCost: Real; // RemainingLeaseTerm:Real;
  LeaseRate: string;  //LeaseMaxCca: Real;

  PurchaseDate: String;

  //CCARate:string; //Rate: String;

  x: Real;
  y: Real;

  FedS8FNo      : Integer;
  FedS8DtAcqNdx: Integer; //jz//202600805

  ln:integer;

  // columns first row index
  colOrigCost,colOrigCostInc,
  colPurchaseDate,colPurchasedateInc,
  colLeaseYrs,colLeaseYrsInc,
  S8colLeaseYrs,S8colLeaseYrsInc,

  colAIIP, colAIIPInc,
  s8colAIIP, s8colAIIPInc,
  colFactor, colFactorInc : integer;

  clsCol2,clsCol2Inc,
  clsCol3,clsCol3Inc : integer;

  col1, col2, col3, col4, col5, col6, col7, col8, col9, col10,col11,col12,
  col13,col14,col15,col16,col17,col18,col19,col20,col21,col22,col23,col24 : integer;

  col1inc, col2inc, col3inc, col4inc, col5inc, col6inc, col7inc, col8inc, col9inc, col10inc,col11inc,col12inc,
  col13inc,col14inc,col15inc,col16inc,col17inc,col18inc,col19inc,col20inc,col21inc,col22inc,col23inc,col24inc  : integer;

  s8col1,  s8col1inc,  s8col2,  s8col2inc,  s8col3,  s8col3inc,  s8col4,  s8col4inc,  s8col5,  s8col5inc,  s8col6,  s8col6inc,
  s8col7, s8col7inc,   s8col8,  s8col8inc,  s8col9,  s8col9inc,  s8col10, s8col10inc, s8col11, s8col11inc, s8col12, s8col12inc,
  s8col13, s8col13inc, s8col14, s8col14inc, s8col15, s8col15inc, s8col16, s8col16inc, s8col17, s8col17inc, s8col18, s8col18inc,
  s8col19, s8col19inc, s8col20, s8coli20nc, s8col21, s8col21inc, s8col22, s8col22inc,
  s8colOrigCost, s8colOrigCostInc,
  s8colPurchaseDate, s8colPurchasedateInc,
  s8Col15factor, s8Col16factor,
  s8Col15factorInc, s8Col16factorInc : Integer;

  //colRateOVR,colRateOVRInc,
  colOvr, colOvrInc,
  colHalfYr, colHalfYrInc,
  colTerminal, colTerminalInc : integer;

  col2Tot, col3Tot, col5Tot, col8Tot, col11Tot,
  col13Tot,col21Tot,col22Tot,col23Tot,col24Tot  : integer;

  populateFromFedS8:boolean;

                            //has to be below var declaration
                            //all this would probably be better as some combo of array and record??
                            procedure setColNDXs();
                            begin

                              colAIIP         := 356; colAIIPInc          := 1; s8colAIIP         := 293; s8colAIIPInc         := 1;
                              colOrigCost     := 371; colOrigCostInc      := 1; s8colOrigCost     := 313; s8colOrigCostInc     := 1;
                              colPurchaseDate := 236; colPurchasedateInc  := 1; s8colPurchaseDate := 233; s8colPurchasedateInc := 1;

                              colLeaseYrs     := 166; colLeaseYrsInc      := 1; s8colLeaseYrs     := 323; s8colLeaseYrsInc     := 1;


                              colFactor       := 343; colFactorInc        := 1; s8Col15factor     := 263; s8Col15factorInc     := 1;
                                                                                s8Col16factor     := 253; s8Col16factorInc     := 1;
                              clsCol2 := 384; clsCol2Inc := 1;
                              clsCol3 := 515; clsCol3Inc := 1;

                              col1  := 6;             col1inc  := 16;           s8col1 :=  6;         s8col1inc  := 22;
                              col2  := 7;             col2inc  := 16;           s8col2 :=  7;         s8col2inc  := 22;
                              col3  := 8;             col3inc  := 16;           s8col3 :=  8;         s8col3inc  := 22;
                              col4  := 463;           col4inc  := 1;            s8col4 :=  9;         s8col4inc  := 22;
                              col5  := 9;             col5inc  := 16;           s8col5 :=  10;        s8col5inc  := 22;
                              col6  := 265;           col6inc  := 1;            s8col6 :=  11;        s8col6inc  := 22;
                              col7  := 278;           col7inc  := 1;            s8col7 :=  12;        s8col7inc  := 22;
                              col8  := 10;            col8inc  := 16;           s8col8 :=  13;        s8col8inc  := 22;
                              col9  := 400;           col9inc  := 1;            s8col9 :=  14;        s8col9inc  := 22;
                              col10 := 11;            col10inc := 16;           s8col10 := 15;        s8col10inc := 22;
                              col11 := 424;           col11inc := 1;            s8col11 := 16;        s8col11inc := 22;
                              col12 := 437;           col12inc := 1;            s8col12 := 17;        s8col12inc := 22;
                              col13 := 450;           col13inc := 1;            s8col13 := 18;        s8col13inc := 22;
                              col14 := 252;           col14inc := 1;            s8col14 := 19;        s8col14inc := 22;
                              col15 := 476;           col15inc := 1;            s8col15 := 20;        s8col15inc := 22;
                              col16 := 291;           col16inc := 1;            s8col16 := 21;        s8col16inc := 22;
                              col17 := 304;           col17inc := 1;            s8col17 := 22;        s8col17inc := 22;
                              col18 := 317;           col18inc := 1;            s8col18 := 23;        s8col18inc := 22;
                              col19 := 330;           col19inc := 1;            s8col19 := 24;        s8col19inc := 22;
                              col20 := 17;            col20inc := 16;           s8col20 := 25;        s8coli20nc := 22;
                              col21 := 18;            col21inc := 16;           s8col21 := 26;        s8col21inc := 22;
                              col22 := 19;            col22inc := 16;           s8col22 := 27;        s8col22inc := 22;
                              col23 := 20;            col23inc := 16;
                              col24 := 21;            col24inc := 16;

                              //colRateOVR  := 489;     colRateOVRInc :=1;

                              colOvr      := 14;      colOvrInc     :=16;
                              colHalfYr   := 15;      colHalfYrInc  :=16;
                              ColTerminal := 16;      ColTerminalInc:=16;

                              col2Tot  := 249;
                              col3Tot  := 234;
                              col5Tot  := 250;
                              col8Tot  := 235;
                              col11Tot := 77;
                              col13Tot := 93;
                              col21Tot := 230;
                              col22Tot := 231;
                              col23Tot := 232;
                              col24Tot := 251;

                            end;


                            procedure incrAll();
                            begin
                              //maybe should seperate as13 and s8 incr?? leave for now

                              inc(clsCol2,clsCol2Inc);
                              inc(clsCol3,clsCol3Inc);

                              inc(colAIIP,        colAIIPInc);          inc(s8colAIIP,        s8colAIIPInc);
                              inc(colOrigCost,    colOrigCostInc);      inc(s8colOrigCost,    s8colOrigCostInc);
                              inc(colPurchaseDate,colPurchasedateInc);  inc(s8colPurchaseDate,s8colPurchasedateInc);
                              inc(colLeaseYrs,    colLeaseYrsInc);      inc(S8colLeaseYrs,    S8colLeaseYrsInc);
                              inc(colFactor,      colFactorInc);        inc(s8Col15factor,    s8Col15factorInc);
                              inc(s8Col16factor,  s8Col16factorInc);

                              inc(col1, col1inc);  inc(s8col1, s8col1inc);
                              inc(col2, col2inc);  inc(s8col2, s8col2inc);
                              inc(col3, col3inc);  inc(s8col3, s8col3inc);
                              inc(col4, col4inc);  inc(s8col4, s8col4inc);
                              inc(col5, col5inc);  inc(s8col5, s8col5inc);
                              inc(col6, col6inc);  inc(s8col6, s8col6inc);
                              inc(col7, col7inc);  inc(s8col7, s8col7inc);
                              inc(col8, col8inc);  inc(s8col8, s8col8inc);
                              inc(col9, col9inc);  inc(s8col9, s8col9inc);
                              inc(col10,col10inc); inc(s8col10,s8col10inc);
                              inc(col11,col11inc); inc(s8col11,s8col11inc);
                              inc(col12,col12inc); inc(s8col12,s8col12inc);
                              inc(col13,col13inc); inc(s8col13,s8col13inc);
                              inc(col14,col14inc); inc(s8col14,s8col14inc);
                              inc(col15,col15inc); inc(s8col15,s8col15inc);
                              inc(col16,col16inc); inc(s8col16,s8col16inc);
                              inc(col17,col17inc); inc(s8col17,s8col17inc);
                              inc(col18,col18inc); inc(s8col18,s8col18inc);
                              inc(col19,col19inc); inc(s8col19,s8col19inc);
                              inc(col20,col20inc); inc(s8col20,s8coli20nc);
                              inc(col21,col21inc); inc(s8col21,s8col21inc);
                              inc(col22,col22inc); inc(s8col22,s8col22inc);
                              inc(col23,col23inc);
                              inc(col24,col24inc);

                              //inc(colRateOVR,colRateOVRInc);

                              inc(colOvr,      colOvrInc);
                              inc(colHalfYr,   colHalfYrInc);
                              inc(ColTerminal, ColTerminalInc);
                            end;

                            procedure populateClassSections();
                            begin
                              with Ret[RetNo].Frm[FNo] do
                              begin
                                // repeate class for each section from Part 2
                                Cls := AllTrim(Strings[col1]); // 20190719 //alltrim
                                Strings[clsCol2] := Cls; // 20190705
                                Strings[clsCol3] := Cls; // 20220730 //dupl/copy cless
                              end;
                            end;


                            procedure calcColTotals();
                            var i:integer;
                            begin
                              setColNDXs();

                              with Ret[RetNo].Frm[FNo] do
                              begin
                                Tv[col2Tot]  := 0;
                                Tv[col3Tot]  := 0;
                                Tv[col5Tot]  := 0;
                                Tv[col8Tot]  := 0;
                                Tv[col11Tot] := 0;
                                Tv[col13Tot] := 0;
                                Tv[col21Tot] := 0;
                                Tv[col22Tot] := 0;
                                Tv[col23Tot] := 0;
                                Tv[col24Tot] := 0;

                                for i := 1 to Rows do
                                begin
                                  Tv[col2Tot]  := Tv[col2Tot]  + Tv[col2];  //col2  total
                                  Tv[col3Tot]  := Tv[col3Tot]  + Tv[col3];  //col3  total
                                  Tv[col5Tot]  := Tv[col5Tot]  + Tv[col5];  //col5  total
                                  Tv[col8Tot]  := Tv[col8Tot]  + Tv[col8];  //col8  total
                                  Tv[col11Tot] := Tv[col11Tot] + Tv[col11]; //col11 total
                                  Tv[col13Tot] := Tv[col13Tot] + Tv[col13]; //col13 total
                                  Tv[col21Tot] := Tv[col21Tot] + Tv[col21]; //col21 total
                                  Tv[col22Tot] := Tv[col22Tot] + Tv[col22]; //col22 total
                                  Tv[col23Tot] := Tv[col23Tot] + Tv[col23]; //col23 total
                                  Tv[col24Tot] := Tv[col24Tot] + Tv[col24]; //col24 total

                                  incrAll();
                                end;

                              end;
                            end;



begin


  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    //20260628
    If (Ret[RetNo].Province = 'AB')
    or (Vl(FetchElm(RetNo, 'S5', 197))>0) then  //has AB income   //20260725
    //continue
    else
    begin
     For i:=1 to 524{488} do begin Strings[i]:='';Tv[i]:=0;End; //20260717 Alex
     //does not work?  ClearForm(RetNo,FName);
     SaveTv(RetNo,FName,FNo);
     exit;
    end;
  end;

  //START COPY FROM FED S8 ----------------------------->
  with Ret[RetNo].Frm[FNo] do
  begin
    setColNDXs();


    //S8FNo := GetFormNo('S8#1'); // 20220826
    //FInst := ExtractFormInst(FName);
    FInst := ExtractFormInst(FName);


    If Strings[3] = '' then Strings[3] := 'N'; // instead of 13  //20120201
    If UpperCase(Strings[3]) <> 'Y' then  //UpperCase(Strings[3]) <> 'Y' means if do not differ from fed s8
      populateFromFedS8 := true
    else
      populateFromFedS8 := false;

    If populateFromFedS8 then
    begin
      FedS8FNo := GetFormNo('S8' + FInst);

      If (FedS8FNo > 0) and (Ret[RetNo].Frm[FedS8FNo].Count > 0) then
      Begin

        for ln := 1 to Rows do
        begin

          //Col AIIP //jz//20260804 - for alberta purposes everything makes it eligible for AIIP
          s8propertyType := FetchElmFNo(RetNo, FedS8FNo, s8colAIIP);
          If  (s8propertyType='AIIP'   ) or
              (s8propertyType='RIIP'   ) or
              (s8propertyType='AIIPZEV') or
              (s8propertyType='RIIPZEV')
          then
            Strings[colAIIP]:='X'  //20260721CZ
          Else
            Strings[colAIIP]:='';   //20260717

          If  (s8propertyType='HALFYR') then Strings[colHalfYr]:='X'
                                        else Strings[colHalfYr]:='';

          tv[colOrigCost]           := Vl(FetchElmFNo(RetNo, FedS8FNo, s8colOrigCost));
          strings[colPurchaseDate]  :=    FetchElmFNo(RetNo, FedS8FNo, s8colPurchaseDate);
          strings[colLeaseYrs]      :=    FetchElmFNo(RetNo, FedS8FNo, s8colLeaseYrs);

          strings[col1] :=    FetchElmFNo(RetNo, FedS8FNo, s8col1);

          populateClassSections(); //Cls

          tv[col2]      := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col2));
          tv[col3]      := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col3));

          //tv[col4]      := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col)); ???

          tv[col5]      := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col6));  //adj
          tv[col6]      := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col7));  //adj assistance
          tv[col7]      := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col8));  //adj repaid
          tv[col8]      := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col9));  //proceeds disposition
          //tv[col9]      := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col));
          tv[col10]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col10)); //UCC before CCA claim
          //tv[col11]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col));
          //tv[col12]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col)); //immediate expensing
          //tv[col13]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col)); //cost of acquisitions on remainder
          //tv[col14]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col)); //cost of acquisitions from AIIP

          //tv[col15]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col));
          //tv[col16]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col));
          //tv[col17]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col));

          //col18
          if      (Vl(FetchElmFNo(RetNo, FedS8FNo, s8col15)) > 0) then tv[col18]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col15))    //UCC adjustment that is AIIP
          else if (Vl(FetchElmFNo(RetNo, FedS8FNo, s8col16)) > 0) then tv[col18]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col16))    //UCC adjustment that is AIIP
          else                                                         tv[col18]     := 0;
          //Relevant factor
          if      (Vl(FetchElmFNo(RetNo, FedS8FNo, s8Col15factor)) > 0) then  Strings[ColFactor]:= FetchElmFNo(RetNo, FedS8FNo, s8Col15factor)
          else if (Vl(FetchElmFNo(RetNo, FedS8FNo, s8Col16factor)) > 0) then  Strings[ColFactor]:= FetchElmFNo(RetNo, FedS8FNo, s8Col16factor)
          else                                                                Strings[ColFactor]:= '0';

          tv[col19]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col17));   //UCC adjustment other than AIIP
          strings[col20]:=    FetchElmFNo(RetNo, FedS8FNo, s8col18);    //CCA rate
          tv[col21]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col19));   //recapure
          tv[col22]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col20));   //terminal loss
          tv[col23]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col21));   //CCA
          tv[col24]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col22));   //year end UCC

          incrAll();

        end; //for

        calcColTotals();

      end;  //if (FedS8FNo > 0) and (Ret[RetNo].Frm[FedS8FNo].Count > 0)

      SaveTv(RetNo, FName, FNo);
      EXIT;
    end;    //if populateFromFedS8
  end; // with from copy from fed s8

  // <----------------------------- END COPY FROM FED S8

  setColNDXs();     //reset them again just in case

  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 1, 2); // 20190626
    DaysInTaxYear := Ret[RetNo].DaysInYear;
    If DaysInTaxYear > 365 then DaysInTaxYear := 365;

    If Strings[4] + Strings[5] = '' then
      Strings[5] := 'X';
    If Strings[216] = '' then
      Strings[216] := 'N'; // 20221107
    If Strings[217] = '' then
      Strings[217] := 'Y';




    //jz//20260806 - what does this do??? --------->
    //             - doesnt seem to match up with much, leave for now but should it be removed?

    // INIT Totals //20190614
    i := 530;
    z := 0;
    Repeat
      if Strings[i - 2] = '' then
        Strings[i - 1] := ''; // 20230309
      z := z + Vl(Strings[i]);
      Inc(i, 3); // 20220912
    Until i > 599;

    Strings[13] := FormatFloat('###.####', z);

    If z > 100 then
      Strings[29] := '0'
    else
    Begin
      y := (Ret[RetNo].DaysInYear / 365) * (1500000 * Vl(Strings[530]) / 100);
      // the first on the list
      Strings[29] := FormatFloat('##,###,###', y);
    end;

    Tv[77] := 0;
    Tv[93] := 0; // DIEP UCC plus ImmeeditateExpensing column //20220730
    Tv[249] := 0;
    Tv[234] := 0;
    Tv[250] := 0;
    Tv[235] := 0;
    Tv[230] := 0;
    Tv[231] := 0;
    Tv[232] := 0;
    Tv[251] := 0;

    for i := 384 to 396 do
      Strings[i] := '';
    // initialize the bottom class numbers, then copy them //20190705
    for i := 515 to 527 do
      Strings[i] := '';
    // initialize the botom class numbers, then copy them //20190705


    //jz//20260806 <----------- what does this do???





    for k := 0 to Rows-1 {12} do // 12 do //20260717 Alex - 10 rows only
    Begin

      populateClassSections(); //Cls

      // replace yyymmdd with yyy/mm/dd for date
      s := LeftStr(Strings[colPurchaseDate], 8);
      if (Length(s) = 8) and (Numeric(s)) then
        Strings[colPurchaseDate] := LeftStr(s, 4) + '/' + MidStr(s, 5, 2) + '/'+ RightStr(s, 2);  //jz20260809 - fixed date MidStr(s, 6, 2) to MidStr(s, 5, 2)

      OriginalCost  := Tv[colOrigCost];
      AssetInfo     := Strings[colPurchaseDate];

      If LeaseHold(Cls) then // if Cls='13' then
      begin
        if strings[ColLeaseYrs] = '' then
          LeaseTerm := 5 // Default;
        else
          LeaseTerm := vl(strings[ColLeaseYrs]);

        if LeaseTerm > 0 then //default LeaseTerm is 5 so shouldnt need condition but add just in case
          LeaseRate := FormatFloat('####.##', 100 / LeaseTerm);

        strings[ColLeaseYrs] := FormatFloat('##',LeaseTerm);

        //LeaseMaxCCA := OriginalCost / LeaseTerm; // 20190611
        //20260717 Alex >>>
        //Rate := FormatFloat('####.##', 100 / LeaseTerm); // 20190601
        //Strings[col20] := Rate;
        //20260717 Alex <<<
        // if rate='INF' then ShowMessage('inf rate');

        // end;
      end;

      //CCA RATE
      strings[col20] := GetCCARate(Cls); //CCARate
      if      LeaseHold(Cls) then
      begin
        strings[col20] := LeaseRate; //CCARate
      end
      else if (Cls = '24') or (Cls = '27') or (Cls = '29') or (Cls = '34') then
      begin
        strings[col20] := '100'; //CCArate // fast write off //20220802
      end;


      //if not populateFromFedS8 then
      begin
        //jz//20260805 - USE GetPropertyType instead of previous
        //propertyType := GetPropertyType(retNo, lCls, strings[lColAquiredDate], strings[lColAvailableDate], FetchElm(RetNo, 'T2', 10), FetchElm(RetNo, 'T2', 11));
        propertyType := GetPropertyType(retNo, strings[col1], leftstr(strings[colPurchaseDate],10), leftstr(strings[colPurchaseDate],10), FetchElm(RetNo, 'T2', 10), FetchElm(RetNo, 'T2', 11));
        If  (propertyType='AIIP'   ) or
            (propertyType='RIIP'   ) or
            (propertyType='AIIPZEV') or
            (propertyType='RIIPZEV')
        then
          Strings[colAIIP]:='X'  //20260721CZ
        Else
          Strings[colAIIP]:='';
      end;
      //jz//20260804
      if Strings[colAIIP] = 'X' then Aiip := TRUE else Aiip := FALSE;

      // set up override indicatore
      If UpperCase(Strings[colOvr])     = 'O' then Strings[colOvr]    := 'Y'; // override
      If UpperCase(Strings[colHalfYr])  = 'H' then Strings[colHalfYr] := 'Y'; // half year
      if AIIP=True                            then Strings[colHalfYr] := 'N'; // half year
      if Vl(strings[col20]) = 100             then Strings[colHalfYr] := 'N';             //CCARate

      // 20190614 No half year rule for fast write off //20190614
      If UpperCase(Strings[colOvr])      = 'X' then Strings[colOvr]       := 'Y'; // override
      If UpperCase(Strings[colHalfYr])   = 'X' then Strings[colHalfYr]    := 'Y'; // half year

      If UpperCase(Strings[colTerminal]) = 'X' then Strings[colTerminal]  := 'Y'; // Term loss
      If UpperCase(Strings[colTerminal]) = 'T' then Strings[colTerminal]  := 'Y'; // Term loss  //jz20260809

      // 20221121 from further below
      OverrideIndic := UpperCase(Strings[colOvr]);
      HalfYearIndic := UpperCase(Strings[colHalfYr]);
      TermLossIndic := UpperCase(Strings[colTerminal]);

      // Rate := GetCCARate(Cls); //20221121
      //20260717 Alex >>>
      {If Strings[489 + k * 1] <> 'Y' then // override rate
        Strings[17 + k * 16] := GetCCARate(Cls); // 20221121
      Rate := Strings[17 + k * 16];}
      //20260717 Alex <<<

      // calculate each Column mow
      UccStart  := Tv[col2]; // col2
      Additions := Tv[col3]; // col3
      if DiepClass(Cls) = False then
        Tv[col4] := 0; // 20221115 //Tv[col2 + k * 16] := 0; // 20221107
      if DiepClass(Cls) = False then
        Tv[col9] := 0; // 20221015
      if Strings[216] = '' then
        Strings[216] := 'Y';
      // if DiepClass(Cls) = False then Tv[col11 + k * 1] := 0; // 20221015

      Adjustments := Tv[col5]; // cpl 5

      // if UpperCase(Strings[216])='Y' then Tv[col11+k*1]:=Tv[col5 + k * 1]; //20221108
      // if Tv[col11+k*1]>Tv[col5 + k * 1] then Tv[col5 + k * 1]:=Tv[col5 + k * 1]; //20221108

      // DiepUcc := Tv[col11 + k * 1]; // 20220826 //20221107
      Tv[77] := Tv[77] + Tv[col11];
      ImmediateExpensing := Tv[col12]; // 20220826
      Tv[93] := Tv[93] + ImmediateExpensing;

      // 20190607  Override section elms starting 14, 15, 16
      if (Aiip = False) and (Cls > '') then
      Begin
        If Strings[15 + k * 16] = '' then
          Strings[15 + k * 16] := 'Y'; // 20190605 half yer rule by default
      End;

      if Aiip = True then
        Strings[15 + k * 16] := ''; // 20190614 in O-H-T
      If (Cls = '24') or (Cls = '27') or (Cls = '29') or (Cls = '34') then
        Strings[15 + k * 16] := ''; // fast write off NO half year rule

      // Input validations
      if Cls = '10.1' then // 20190622
      Begin
        if PurchaseDate < GetTaxationYearStart(RetNo) then
          Tv[col3] := 0; // no additions allowed
      End;

      If (Aiip = False) and (Cls <> '56') then
        Tv[col14] := 0; // // 20220531 aiip portion of col 3

      AdditionsAiip := Tv[col14];
      // assistance part of col 5
      // If Tv[265+k*1]>Tv[9+k*16] then Tv[265+k*1]:=Tv[9+k*16];  //20220621
      Tv[col6] := MaxR(0, Tv[col6]); // col6 //20220621
      AssistanceReceived := Tv[col6];
      Tv[col7] := MaxR(0, Tv[col7]); // col 7 //20220621
      RepaidAmount := Tv[col7 * 1]; // col7
      Tv[col8] := MaxR(0, Tv[col8]);
      // 20220621  //from aboeve //20220731
      // Proceeds:=Tv[col8+k*16];  //20220731


      //jz//20260804 - dont solve for factor if is brought from s8
      //if not populateFromFedS8 then
      begin
        // aiip  related
        If Aiip = False then
        Begin
          Tv[col16] := 0;
          Tv[col17] := 0;
          Tv[colFactor] := 0;
          Tv[col18] := 0;
          Tv[col19] := 0;
        End;
        if Aiip = True then // 20190705
        Begin
          // fast write off //20190608
          if (Cls = '24') or (Cls = '27') or (Cls = '29') or (Cls = '34') then
          Begin
            Tv[col3] := 0; // additions
          End;

          Aiipfactor := '';
          if tv[col17] > 0 then
          begin

            if      (propertyType = 'RIIP')   or
                    (propertyType = 'RIIPZEV')
            then
              Aiipfactor := getRIIPFactor(Cls,leftstr(Strings[colPurchaseDate],10),leftstr(Strings[colPurchaseDate],10))
            else if (propertyType = 'AIIP')   or
                    (propertyType = 'AIIPZEV')
            then
              Aiipfactor := getAIIPFactor(Cls,leftstr(Strings[colPurchaseDate],10),leftstr(Strings[colPurchaseDate],10));

          end;
          Strings[colFactor] := Aiipfactor;
        End;
      End;

      ProceedsAiip := Tv[col16];

      HalfRuleAmount := 0;
      UCC := 0;
      UCCReduced := 0;
      Recapture := 0;
      TerminalLoss := 0;

      if Cls = '' then
      begin
        UCC := 0;
        HalfRuleAmount := 0;
        UCCReduced := 0;
        Recapture := 0;
        TerminalLoss := 0;
        CCA := 0;
        UCCEnd := 0;
      end;

      UCC := UccStart + Additions + Adjustments - AssistanceReceived +
        RepaidAmount - Proceeds; // 20190606pm
      if (Cls = '10.1') and (Proceeds > 0) then
        UCC := UccStart + Additions + Adjustments - AssistanceReceived +
          RepaidAmount; // 20190820 Get the CCA on disposal

      If LeaseHold(Cls) then // if cls='13' then //20190611
      Begin
        LeaseAdjustedCost := OriginalCost - UccStart + Additions + Adjustments - AssistanceReceived + RepaidAmount;
        UCCReduced := UccStart + Additions + Adjustments - AssistanceReceived + RepaidAmount;
      End;

      If Aiip=True then HalfYearIndic:='N'; //20260705

      if Aiip = False then // 20190706
      Begin
        if UpperCase(HalfYearIndic) = 'Y' then
        /// /20190605
        begin
          if UpperCase(OverrideIndic) <> 'Y' then // 20190605
          begin
            HalfRuleAmount :=
              MaxR(0, 0.5 * (Additions - AssistanceReceived + RepaidAmount -
              Proceeds));
            if LeaseHold(Cls) then
              HalfRuleAmount := MaxR(0, 0.5 * (Additions - Proceeds));
            // 20190613
            HalfRuleAmount := RoundCorrect(HalfRuleAmount);
          end;
        end
        else
          HalfRuleAmount := 0;


        // from below  //20220619
        if (Cls = '12') OR (Cls = '52') Or (Cls = '24') or (Cls = '27') or
          (Cls = '29') or (Cls = '34') // fast write off //20190622
        then
          UccAdjustmentNONAiip := 0; // 20190622
        UCCReduced := UCC - HalfRuleAmount;
        if LeaseHold(Cls) then
          UCCReduced := UCC; // 20190611
        ProceedsAiip := 0;
        NetCapCostAdditionsAiip := 0;
        UccAdjustmentAiip := 0;
      end // 20220619
      Else // If (Aiip=True) then
      Begin
        HalfRuleAmount := 0; // 20190608
        // 20190707
        ProceedsAiip := MaxR(0, Proceeds + AssistanceReceived - Additions +
          AdditionsAiip - RepaidAmount);
        NetCapCostAdditionsAiip := MaxR(0, AdditionsAiip - ProceedsAiip);
        if (Cls = '10.1') and (Proceeds > 0) then
          NetCapCostAdditionsAiip := AdditionsAiip;

        UccAdjustmentAiip := NetCapCostAdditionsAiip * Vl(Aiipfactor);
        UccAdjustmentNONAiip :=
          MaxR(0, 0.5 * (Additions - AdditionsAiip - AssistanceReceived +
          RepaidAmount - Proceeds)); // 20190622 moved from below

        if (Cls = '12') OR (Cls = '52') Or (Cls = '24') or (Cls = '27') or
          (Cls = '29') or (Cls = '34') then
          UccAdjustmentNONAiip := 0; // 20190622  //fast write off //20190622
      End; // 20220619

      //jz20260809 - fields not in use??
      {
      // put amounts on the S8 form
      Tv[12 + k * 16] := HalfRuleAmount; // ???
      if Aiip then
        Tv[12 + k * 16] := 0; // remove half ruleamount
      }

      // Col4
      if Tv[col4] > Tv[col3] then
        Tv[col4] := Tv[col3];

      // col9  user inout
      if Tv[col9] > Tv[col8] then
        Tv[col9] := Tv[col8];
      // col10
      //if Aiip = True then //20260720 Alex
      //  Tv[col10]:= 0 //20260720 Alex
      //else //20260720 Alex
      Tv[col10] := Tv[col2] + Tv[col3] +
        Tv[col5] - Tv[col8];

      // col11                    **
      if UpperCase(Strings[216]) = 'Y' then
        Tv[col11] := Tv[col4]; // 20221108
      if Tv[col11] > Tv[col4] then
        Tv[col11] := Tv[col4]; // 20221108

      // col12 //semi automatic  //20220827 imm expensing amount = designated
      If UpperCase(Ret[RetNo].Frm[FNo].Strings[217]) = 'Y' then
      // autofill col 12
      Begin
        If (Tv[col4] > 0) and (Tv[col12] = 0) then
          Tv[col12] := Tv[col4]; // 20221017
      end;

      if Tv[col12] > Tv[col4] then
        Tv[col12] := Tv[col11];
      if Ret[RetNo].CorpType <> CCPC then
        Tv[col12] := 0; // 20221115

      // col13
      //if Aiip = True then //20260720 Alex
      //  Tv[col13]:= 0 //20260720 Alex
      //else  //20260720 Alex
      Tv[col13] := MaxR(0, Tv[col3] - Tv[col4] +
        Tv[col11] - Tv[col12]); // 20220912 MaxR

      // col14 //jz//20260804 - had it backwards, if AIIP then add to column, make vtCalc
      if Aiip = True then
      begin
        Tv[col14] := MaxR(0, Tv[col13]); //20260717 Alex
      end
      else //20260717 Alex
        Tv[col14] := 0; //20260717 Alex

      //else //20260717 Alex
        //Tv[col14] := 0; //20260717 Alex
      // col15
      Tv[col15] := MaxR(0, Tv[col10] - Tv[col12]);
      // col16

      xx:=Tv[col8];
      xx:=Tv[col9];
      xx:=Tv[col6];
      xx:=Tv[col13];
      xx:=Tv[col14];
      xx:=Tv[col7] ;

      if Aiip = True then
        Tv[col16] := MaxR(0, Tv[col8] - Tv[col9] + Tv[col6] - Tv[col13] + Tv[col14] - Tv[col7]) // ? 54 and 56?
      else
        Tv[col16] := 0;
      // col17
      if Aiip = True then
        Tv[col17] := MaxR(0, Tv[col14] - Tv[col16])
        // ? 54 and 56?
      else
        Tv[col17] := 0;

      if Cls = '' then
      begin
        Aiipfactor := '';
        Strings[colFactor] := ''; // aiip factor
      end;


      xx:=Tv[col17];
      xx:=Vl(Strings[colFactor]);

      // col18
      if Aiip = True then //20260717 Alex
        Tv[col18] := Tv[col17] * FractionToReal(Strings[colFactor])//;//20260717 Alex
      else  //20260717 Alex
        Tv[col18]:= 0; //20260717 Alex
      // //? 54 and 56?

      // col19
      if Aiip = True then //20260717 Alex
      //Tv[col19] := MaxR(0, Tv[col13] - Tv[col14] - //20260720 Alex
      //  Tv[col6] - Tv[col17])//; // ? 54 and 56?  //20260720 Alex
        Tv[col19]:= MaxR(0, (Tv[col13] - Tv[col14] - Tv[col6] +  Tv[col7] -  Tv[col8] + Tv[col9]) * 0.5) //20260720 Alex
      else  //20260717 Alex
        Tv[col19]:= 0; //20260717 Alex

      //If not populateFromFedS8 then
      begin

        // col20 //jz20260810 - CCARate removed and Strings[col20]  assigned above;
        //Strings[col20] := CCARate;

        //jz20260810 - done above
        //CCARate := GetCCARate(Cls); // string //20190614  see beloq //20221121 //Rate:= Strings[17 + k * 16]; //20260717 Alex //jz//20260805 - should populate rate, use previous GetCCARate, not sure why changed
        {
        //jz20260809 - ACTUALLY just make vtCalc and remove this manual override //reinstate override, should this just be regular ovrride tho??
        if Strings[ColRateOVR] <> 'Y' then
          Strings[col20] := Rate  //20260717 Alex         // if Strings[Col20+K*16]='INF' then Strings[col20*k*16] := ''; //20220912
        else
          Rate := Strings[col20];
        }

        // col21 recapture
        //20260717 Alex >>>
        Tv[col21] := 0;
        if Tv[col10] < 0 then
          Tv[col21] := Abs(Tv[col10]);

        if (Cls = '10.1') then
          Tv[col21] := 0; // 20230516
      end;

      // col22 Terminal loss
      //If not populateFromFedS8 then
      begin
        Tv[col22] := 0;
        if (UpperCase(Strings[colTerminal]) = 'Y') and (Tv[col10] > 0) //jz20260809
        then
          Tv[col22] := Tv[col10];
        if (Cls = '10.1') then
          Tv[col22] := 0; // 20230516
      end;
      //20260717 Alex <<<

      // There is CCA
      If (Tv[col21] = 0) and (Tv[col22] = 0) then
      // RGRE IS CCA (No Term loss =0 andRecpt=0 )
      begin // normal no terminal loss or  recapture
        if UpperCase(Strings[14]) <> 'Y' then // no override);
        Begin
          Tv[col23] := (Tv[col15] + Tv[col18] - Tv[col19]) * Vl(Strings[col20]) / 100 + Tv[col12];
          CCA := Tv[col23]; // 20230322
          if Ret[RetNo].DaysInYear < 365 then
          Begin
            CCA := CCA * Ret[RetNo].DaysInYear / 365;
            Tv[col23] := CCA;
          End;
        End;
      end
      Else // case: recapture  or Term loss>0 //20230512
      begin
        CCA := 0;

        Tv[col23] := 0; // if recapture or term loss then CCA =0
        // proration:?
        if Ret[RetNo].DaysInYear < 365 then
        Begin
          // Tv[col21]:=Tv[col21]/ 365;  //recapture
          // Tv[col22]:=Tv[col22] / 365; //terminal loss
        End;
      end;


      if UpperCase(Strings[colTerminal]) = 'Y' // term loss //jz20260809
      then
        Tv[col24] := 0 // no UCC end eny more
      Else
        Tv[col24] := MaxR(0, Tv[col10] - Tv[col23]);

      incrAll();

    End; // k 0 to 12  //k is the wow bing processed starts from k=0
    //Totals //jz//20260805 move totals all to one place
    calcColTotals();

  End; // with?
  SaveTv(RetNo, FName, FNo);
end;
*)


(*
//jz//20260809
//              - fixed rate ovr/terminal loss indicator issue when not copying from s8
//              - fixed date adding slash mistake
//jz//20260806
//              - totally redid transfer from s8
//              - added col vars for everything
//              - cleaned up code, hoping regular calc still works
//jz//20260805
//              - use GetPropertyType to judge if AIIP note:all RIIP and ZEV also considered AIIP for AB
//              - adjusted AIIP calc
//              - changed cols to var and added colinc such that do not need + k * 16 everywhere
//              - addressed various other issues
procedure AS13(RetNo: Integer; FName: string; FNo: Integer);
const
 Rows = 10;
Var
  //i, k, k1, j, w: Integer; //20260703 Alex
  i,k: Integer;

  OrigCostNdx, OrigCostS8Ndx:Integer;  //20260716cz

  FInst: String;
  S8FNo: Integer;
  Cls, s, S1, S2: String;
  TotColumn4: Real;
  OriginalCost: Real;
  UccStart, Additions, Adjustments, Proceeds, UCC, HalfRuleAmount,
    UCCReduced: Real;

  ImmediateExpensing: Real; // 20220730

  OverrideIndic, HalfYearIndic, TermLossIndic: String;
  Rate: String;
  Recapture, TerminalLoss, CCA, UCCEnd, z: Real;
  DaysInTaxYear: Integer; // > 365 then DaysInTaxYear := 365;
  // cls 13 relted
  AssetInfo: String;
  // additional fields after aiip
  Aiip: Boolean;
  AdditionsAiip, AssistanceReceived, RepaidAmount, ProceedsAiip,
    NetCapCostAdditionsAiip, UccAdjustmentAiip, UccAdjustmentNONAiip: Real;
  Aiipfactor: String;

  s8propertyType,propertyType:string;

  OverrideBox, HalfRuleBox, TerminalLossBox: String;
  HalfYearAmount: Real;

  LeaseStart, LeaseEnd: string;
  LeaseTerm: Real;
  LeaseAdjustedCost: Real; // RemainingLeaseTerm:Real;
  PurchaseDate: String;
  LeaseMaxCca: Real;
  x: Real;
  y: Real;

  FedS8FNo      : Integer;
  FedS8DtAcqNdx: Integer; //jz//202600805

  ln:integer;

  // columns first row index
  colOrigCost,colOrigCostInc,
  colPurchaseDate,colPurchasedateInc,
  colAIIP, colAIIPInc,
  s8colAIIP, s8colAIIPInc,
  colFactor, colFactorInc : integer;

  clsCol2,clsCol2Inc,
  clsCol3,clsCol3Inc : integer;

  col1, col2, col3, col4, col5, col6, col7, col8, col9, col10,col11,col12,
  col13,col14,col15,col16,col17,col18,col19,col20,col21,col22,col23,col24 : integer;

  col1inc, col2inc, col3inc, col4inc, col5inc, col6inc, col7inc, col8inc, col9inc, col10inc,col11inc,col12inc,
  col13inc,col14inc,col15inc,col16inc,col17inc,col18inc,col19inc,col20inc,col21inc,col22inc,col23inc,col24inc  : integer;

  s8col1,  s8col1inc,  s8col2,  s8col2inc,  s8col3,  s8col3inc,  s8col4,  s8col4inc,  s8col5,  s8col5inc,  s8col6,  s8col6inc,
  s8col7, s8col7inc,   s8col8,  s8col8inc,  s8col9,  s8col9inc,  s8col10, s8col10inc, s8col11, s8col11inc, s8col12, s8col12inc,
  s8col13, s8col13inc, s8col14, s8col14inc, s8col15, s8col15inc, s8col16, s8col16inc, s8col17, s8col17inc, s8col18, s8col18inc,
  s8col19, s8col19inc, s8col20, s8coli20nc, s8col21, s8col21inc, s8col22, s8col22inc,
  s8colOrigCost, s8colOrigCostInc,
  s8colPurchaseDate, s8colPurchasedateInc,
  s8Col15factor, s8Col16factor,
  s8Col15factorInc, s8Col16factorInc : Integer;

  //colRateOVR,colRateOVRInc,
  colOvr, colOvrInc,
  colHalfYr, colHalfYrInc,
  colTerminal, colTerminalInc : integer;

  col2Tot, col3Tot, col5Tot, col8Tot, col11Tot,
  col13Tot,col21Tot,col22Tot,col23Tot,col24Tot  : integer;



  populateFromFedS8:boolean;

                            //has to be below var declaration
                            //all this would probably be better as some combo of array and record??
                            procedure setColNDXs();
                            begin

                              colAIIP         := 356; colAIIPInc          := 1; s8colAIIP         := 293; s8colAIIPInc         := 1;
                              colOrigCost     := 371; colOrigCostInc      := 1; s8colOrigCost     := 313; s8colOrigCostInc     := 1;
                              colPurchaseDate := 236; colPurchasedateInc  := 1; s8colPurchaseDate := 233; s8colPurchasedateInc := 1;
                              colFactor       := 343; colFactorInc        := 1; s8Col15factor     := 263; s8Col15factorInc     := 1;
                                                                                s8Col16factor     := 253; s8Col16factorInc     := 1;
                              clsCol2 := 384; clsCol2Inc := 1;
                              clsCol3 := 515; clsCol3Inc := 1;

                              col1  := 6;             col1inc  := 16;           s8col1 :=  6;         s8col1inc  := 22;
                              col2  := 7;             col2inc  := 16;           s8col2 :=  7;         s8col2inc  := 22;
                              col3  := 8;             col3inc  := 16;           s8col3 :=  8;         s8col3inc  := 22;
                              col4  := 463;           col4inc  := 1;            s8col4 :=  9;         s8col4inc  := 22;
                              col5  := 9;             col5inc  := 16;           s8col5 :=  10;        s8col5inc  := 22;
                              col6  := 265;           col6inc  := 1;            s8col6 :=  11;        s8col6inc  := 22;
                              col7  := 278;           col7inc  := 1;            s8col7 :=  12;        s8col7inc  := 22;
                              col8  := 10;            col8inc  := 16;           s8col8 :=  13;        s8col8inc  := 22;
                              col9  := 400;           col9inc  := 1;            s8col9 :=  14;        s8col9inc  := 22;
                              col10 := 11;            col10inc := 16;           s8col10 := 15;        s8col10inc := 22;
                              col11 := 424;           col11inc := 1;            s8col11 := 16;        s8col11inc := 22;
                              col12 := 437;           col12inc := 1;            s8col12 := 17;        s8col12inc := 22;
                              col13 := 450;           col13inc := 1;            s8col13 := 18;        s8col13inc := 22;
                              col14 := 252;           col14inc := 1;            s8col14 := 19;        s8col14inc := 22;
                              col15 := 476;           col15inc := 1;            s8col15 := 20;        s8col15inc := 22;
                              col16 := 291;           col16inc := 1;            s8col16 := 21;        s8col16inc := 22;
                              col17 := 304;           col17inc := 1;            s8col17 := 22;        s8col17inc := 22;
                              col18 := 317;           col18inc := 1;            s8col18 := 23;        s8col18inc := 22;
                              col19 := 330;           col19inc := 1;            s8col19 := 24;        s8col19inc := 22;
                              col20 := 17;            col20inc := 16;           s8col20 := 25;        s8coli20nc := 22;
                              col21 := 18;            col21inc := 16;           s8col21 := 26;        s8col21inc := 22;
                              col22 := 19;            col22inc := 16;           s8col22 := 27;        s8col22inc := 22;
                              col23 := 20;            col23inc := 16;
                              col24 := 21;            col24inc := 16;

                              //colRateOVR  := 489;     colRateOVRInc :=1;

                              colOvr      := 14;      colOvrInc     :=16;
                              colHalfYr   := 15;      colHalfYrInc  :=16;
                              ColTerminal := 16;      ColTerminalInc:=16;

                              col2Tot  := 249;
                              col3Tot  := 234;
                              col5Tot  := 250;
                              col8Tot  := 235;
                              col11Tot := 77;
                              col13Tot := 93;
                              col21Tot := 230;
                              col22Tot := 231;
                              col23Tot := 232;
                              col24Tot := 251;

                            end;


                            procedure incrAll();
                            begin
                              //maybe should seperate as13 and s8 incr?? leave for now

                              inc(clsCol2,clsCol2Inc);
                              inc(clsCol3,clsCol3Inc);

                              inc(colAIIP,        colAIIPInc);          inc(s8colAIIP,        s8colAIIPInc);
                              inc(colOrigCost,    colOrigCostInc);      inc(s8colOrigCost,    s8colOrigCostInc);
                              inc(colPurchaseDate,colPurchasedateInc);  inc(s8colPurchaseDate,s8colPurchasedateInc);
                              inc(colFactor,      colFactorInc);        inc(s8Col15factor,    s8Col15factorInc);
                              inc(s8Col16factor,  s8Col16factorInc);

                              inc(col1, col1inc);  inc(s8col1, s8col1inc);
                              inc(col2, col2inc);  inc(s8col2, s8col2inc);
                              inc(col3, col3inc);  inc(s8col3, s8col3inc);
                              inc(col4, col4inc);  inc(s8col4, s8col4inc);
                              inc(col5, col5inc);  inc(s8col5, s8col5inc);
                              inc(col6, col6inc);  inc(s8col6, s8col6inc);
                              inc(col7, col7inc);  inc(s8col7, s8col7inc);
                              inc(col8, col8inc);  inc(s8col8, s8col8inc);
                              inc(col9, col9inc);  inc(s8col9, s8col9inc);
                              inc(col10,col10inc); inc(s8col10,s8col10inc);
                              inc(col11,col11inc); inc(s8col11,s8col11inc);
                              inc(col12,col12inc); inc(s8col12,s8col12inc);
                              inc(col13,col13inc); inc(s8col13,s8col13inc);
                              inc(col14,col14inc); inc(s8col14,s8col14inc);
                              inc(col15,col15inc); inc(s8col15,s8col15inc);
                              inc(col16,col16inc); inc(s8col16,s8col16inc);
                              inc(col17,col17inc); inc(s8col17,s8col17inc);
                              inc(col18,col18inc); inc(s8col18,s8col18inc);
                              inc(col19,col19inc); inc(s8col19,s8col19inc);
                              inc(col20,col20inc); inc(s8col20,s8coli20nc);
                              inc(col21,col21inc); inc(s8col21,s8col21inc);
                              inc(col22,col22inc); inc(s8col22,s8col22inc);
                              inc(col23,col23inc);
                              inc(col24,col24inc);

                              //inc(colRateOVR,colRateOVRInc);

                              inc(colOvr,      colOvrInc);
                              inc(colHalfYr,   colHalfYrInc);
                              inc(ColTerminal, ColTerminalInc);
                            end;

                            procedure populateClassSections();
                            begin
                              with Ret[RetNo].Frm[FNo] do
                              begin
                                // repeate class for each section from Part 2
                                Cls := AllTrim(Strings[col1]); // 20190719 //alltrim
                                Strings[clsCol2] := Cls; // 20190705
                                Strings[clsCol3] := Cls; // 20220730 //dupl/copy cless
                              end;
                            end;


                            procedure calcColTotals();
                            var i:integer;
                            begin
                              setColNDXs();

                              with Ret[RetNo].Frm[FNo] do
                              begin
                                Tv[col2Tot]  := 0;
                                Tv[col3Tot]  := 0;
                                Tv[col5Tot]  := 0;
                                Tv[col8Tot]  := 0;
                                Tv[col11Tot] := 0;
                                Tv[col13Tot] := 0;
                                Tv[col21Tot] := 0;
                                Tv[col22Tot] := 0;
                                Tv[col23Tot] := 0;
                                Tv[col24Tot] := 0;

                                for i := 1 to Rows do
                                begin
                                  Tv[col2Tot]  := Tv[col2Tot]  + Tv[col2];  //col2  total
                                  Tv[col3Tot]  := Tv[col3Tot]  + Tv[col3];  //col3  total
                                  Tv[col5Tot]  := Tv[col5Tot]  + Tv[col5];  //col5  total
                                  Tv[col8Tot]  := Tv[col8Tot]  + Tv[col8];  //col8  total
                                  Tv[col11Tot] := Tv[col11Tot] + Tv[col11]; //col11 total
                                  Tv[col13Tot] := Tv[col13Tot] + Tv[col13]; //col13 total
                                  Tv[col21Tot] := Tv[col21Tot] + Tv[col21]; //col21 total
                                  Tv[col22Tot] := Tv[col22Tot] + Tv[col22]; //col22 total
                                  Tv[col23Tot] := Tv[col23Tot] + Tv[col23]; //col23 total
                                  Tv[col24Tot] := Tv[col24Tot] + Tv[col24]; //col24 total

                                  incrAll();
                                end;

                              end;
                            end;



begin


  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    //20260628
    If (Ret[RetNo].Province = 'AB')
    or (Vl(FetchElm(RetNo, 'S5', 197))>0) then  //has AB income   //20260725
    //continue
    else
    begin
     For i:=1 to 524{488} do begin Strings[i]:='';Tv[i]:=0;End; //20260717 Alex
     //does not work?  ClearForm(RetNo,FName);
     SaveTv(RetNo,FName,FNo);
     exit;
    end;
  end;

  //COPY FROM FED S8 -----------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    setColNDXs();
    FInst := ExtractFormInst(FName);

    If Strings[3] = '' then Strings[3] := 'N'; // instead of 13  //20120201
    If UpperCase(Strings[3]) <> 'Y' then  //UpperCase(Strings[3]) <> 'Y' means if do not differ from fed s8
      populateFromFedS8 := true
    else
      populateFromFedS8 := false;

    If populateFromFedS8 then
    begin
      FedS8FNo := GetFormNo('S8' + FInst);

      If (FedS8FNo > 0) and (Ret[RetNo].Frm[FedS8FNo].Count > 0) then
      Begin

        for ln := 1 to Rows do
        begin

          //Col AIIP //jz//20260804 - for alberta purposes everything makes it eligible for AIIP
          s8propertyType := FetchElmFNo(RetNo, FedS8FNo, s8colAIIP);
          If  (s8propertyType='AIIP'   ) or
              (s8propertyType='RIIP'   ) or
              (s8propertyType='AIIPZEV') or
              (s8propertyType='RIIPZEV')
          then
            Strings[colAIIP]:='X'  //20260721CZ
          Else
            Strings[colAIIP]:='';   //20260717

          If  (s8propertyType='HALFYR') then Strings[colHalfYr]:='X'
                                        else Strings[colHalfYr]:='';

          tv[colOrigCost]           := Vl(FetchElmFNo(RetNo, FedS8FNo, s8colOrigCost));
          strings[colPurchaseDate]  :=    FetchElmFNo(RetNo, FedS8FNo, s8colPurchaseDate);

          strings[col1] :=    FetchElmFNo(RetNo, FedS8FNo, s8col1);

          populateClassSections();

          tv[col2]      := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col2));
          tv[col3]      := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col3));

          //tv[col4]      := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col)); ???

          tv[col5]      := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col6));  //adj
          tv[col6]      := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col7));  //adj assistance
          tv[col7]      := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col8));  //adj repaid
          tv[col8]      := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col9));  //proceeds disposition
          //tv[col9]      := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col));
          tv[col10]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col10)); //UCC before CCA claim
          //tv[col11]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col));
          //tv[col12]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col)); //immediate expensing
          //tv[col13]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col)); //cost of acquisitions on remainder
          //tv[col14]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col)); //cost of acquisitions from AIIP

          //tv[col15]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col));
          //tv[col16]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col));
          //tv[col17]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col));

          //col18
          if      (Vl(FetchElmFNo(RetNo, FedS8FNo, s8col15)) > 0) then tv[col18]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col15))    //UCC adjustment that is AIIP
          else if (Vl(FetchElmFNo(RetNo, FedS8FNo, s8col16)) > 0) then tv[col18]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col16))    //UCC adjustment that is AIIP
          else                                                         tv[col18]     := 0;
          //Relevant factor
          if      (Vl(FetchElmFNo(RetNo, FedS8FNo, s8Col15factor)) > 0) then  Strings[ColFactor]:= FetchElmFNo(RetNo, FedS8FNo, s8Col15factor)
          else if (Vl(FetchElmFNo(RetNo, FedS8FNo, s8Col16factor)) > 0) then  Strings[ColFactor]:= FetchElmFNo(RetNo, FedS8FNo, s8Col16factor)
          else                                                                Strings[ColFactor]:= '0';

          tv[col19]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col17));   //UCC adjustment other than AIIP
          strings[col20]:=    FetchElmFNo(RetNo, FedS8FNo, s8col18);    //CCA rate
          tv[col21]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col19));   //recapure
          tv[col22]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col20));   //terminal loss
          tv[col23]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col21));   //CCA
          tv[col24]     := Vl(FetchElmFNo(RetNo, FedS8FNo, s8col22));   //year end UCC

          incrAll();

        end; //for

        calcColTotals();

      end;  //if (FedS8FNo > 0) and (Ret[RetNo].Frm[FedS8FNo].Count > 0)

      SaveTv(RetNo, FName, FNo);
      EXIT;
    end;    //if populateFromFedS8
  end; // with from copy from fed s8

  setColNDXs();     //reset them again just in case

  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 1, 2); // 20190626
    DaysInTaxYear := Ret[RetNo].DaysInYear;
    If DaysInTaxYear > 365 then DaysInTaxYear := 365;

    S8FNo := GetFormNo('S8#1'); // 20220826
    FInst := ExtractFormInst(FName);

    If Strings[4] + Strings[5] = '' then
      Strings[5] := 'X';
    If Strings[216] = '' then
      Strings[216] := 'N'; // 20221107
    If Strings[217] = '' then
      Strings[217] := 'Y';




    //jz//20260806 - what does this do??? --------->
    //             - doesnt seem to match up with much, leave for now but should it be removed?

    // INIT Totals //20190614
    i := 530;
    z := 0;
    Repeat
      if Strings[i - 2] = '' then
        Strings[i - 1] := ''; // 20230309
      z := z + Vl(Strings[i]);
      Inc(i, 3); // 20220912
    Until i > 599;

    Strings[13] := FormatFloat('###.####', z);

    If z > 100 then
      Strings[29] := '0'
    else
    Begin
      y := (Ret[RetNo].DaysInYear / 365) * (1500000 * Vl(Strings[530]) / 100);
      // the first on the list
      Strings[29] := FormatFloat('##,###,###', y);
    end;

    Tv[77] := 0;
    Tv[93] := 0; // DIEP UCC plus ImmeeditateExpensing column //20220730
    Tv[249] := 0;
    Tv[234] := 0;
    Tv[250] := 0;
    Tv[235] := 0;
    Tv[230] := 0;
    Tv[231] := 0;
    Tv[232] := 0;
    Tv[251] := 0;

    for i := 384 to 396 do
      Strings[i] := '';
    // initialize the bottom class numbers, then copy them //20190705
    for i := 515 to 527 do
      Strings[i] := '';
    // initialize the botom class numbers, then copy them //20190705


    //jz//20260806 <----------- what does this do???





    for k := 0 to Rows-1 {12} do // 12 do //20260717 Alex - 10 rows only
    Begin

      populateClassSections();

      //if not populateFromFedS8 then
      begin
        //jz//20260805 - USE GetPropertyType instead of previous
        //propertyType := GetPropertyType(retNo, lCls, strings[lColAquiredDate], strings[lColAvailableDate], FetchElm(RetNo, 'T2', 10), FetchElm(RetNo, 'T2', 11));
        propertyType := GetPropertyType(retNo, strings[col1], leftstr(strings[colPurchaseDate],10), leftstr(strings[colPurchaseDate],10), FetchElm(RetNo, 'T2', 10), FetchElm(RetNo, 'T2', 11));
        If  (propertyType='AIIP'   ) or
            (propertyType='RIIP'   ) or
            (propertyType='AIIPZEV') or
            (propertyType='RIIPZEV')
        then
          Strings[colAIIP]:='X'  //20260721CZ
        Else
          Strings[colAIIP]:='';
      end;
      //jz//20260804
      if Strings[colAIIP] = 'X' then Aiip := TRUE else Aiip := FALSE;

      // set up override indicatore
      If UpperCase(Strings[colOvr])     = 'O' then Strings[colOvr]    := 'Y'; // override
      If UpperCase(Strings[colHalfYr])  = 'H' then Strings[colHalfYr] := 'Y'; // half year
      if AIIP=True                            then Strings[colHalfYr] := 'N'; // half year
      if Vl(Rate) = 100                       then Strings[colHalfYr] := 'N';

      // 20190614 No half year rule for fast write off //20190614
      If UpperCase(Strings[colOvr])      = 'X' then Strings[colOvr]       := 'Y'; // override
      If UpperCase(Strings[colHalfYr])   = 'X' then Strings[colHalfYr]    := 'Y'; // half year

      If UpperCase(Strings[colTerminal]) = 'X' then Strings[colTerminal]  := 'Y'; // Term loss
      If UpperCase(Strings[colTerminal]) = 'T' then Strings[colTerminal]  := 'Y'; // Term loss  //jz20260809

      // 20221121 from further below
      OverrideIndic := UpperCase(Strings[colOvr]);
      HalfYearIndic := UpperCase(Strings[colHalfYr]);
      TermLossIndic := UpperCase(Strings[colTerminal]);

      // Rate := GetCCARate(Cls); //20221121
      //20260717 Alex >>>
      {If Strings[489 + k * 1] <> 'Y' then // override rate
        Strings[17 + k * 16] := GetCCARate(Cls); // 20221121
      Rate := Strings[17 + k * 16];}
      //20260717 Alex <<<

      OriginalCost := Tv[colOrigCost];
      AssetInfo := Strings[colPurchaseDate];
      // calculate each Column mow
      UccStart  := Tv[col2]; // col2
      Additions := Tv[col3]; // col3
      if DiepClass(Cls) = False then
        Tv[col4] := 0; // 20221115 //Tv[col2 + k * 16] := 0; // 20221107
      if DiepClass(Cls) = False then
        Tv[col9] := 0; // 20221015
      if Strings[216] = '' then
        Strings[216] := 'Y';
      // if DiepClass(Cls) = False then Tv[col11 + k * 1] := 0; // 20221015

      Adjustments := Tv[col5]; // cpl 5

      // if UpperCase(Strings[216])='Y' then Tv[col11+k*1]:=Tv[col5 + k * 1]; //20221108
      // if Tv[col11+k*1]>Tv[col5 + k * 1] then Tv[col5 + k * 1]:=Tv[col5 + k * 1]; //20221108

      // DiepUcc := Tv[col11 + k * 1]; // 20220826 //20221107
      Tv[77] := Tv[77] + Tv[col11];
      ImmediateExpensing := Tv[col12]; // 20220826
      Tv[93] := Tv[93] + ImmediateExpensing;

      // move down
      // Tv[col8+k*16]:=MaxR(0,Tv[col8+k*16]);  //20220621
      // Proceeds:=Tv[col8+k*16];

      if (LeaseHold(Cls)) and (UccStart > 0) Then
      begin
        { //20220913
          Additions := 0;
          Tv[col3 + k * 16] := 0;
        }
      end; // do not allow additions to 13 //20190705
      // 20190809  accept yyymmdd in case they entered yyyy/mm/dd
      If (Cls > '') then
      begin
        if Not LeaseHold(Cls) then
        Begin
          // replace yyymmdd with yyy/mm/dd for date
          s := LeftStr(Strings[colPurchaseDate], 8);
          if (Length(s) = 8) and (Numeric(s)) then
            Strings[colPurchaseDate] := LeftStr(s, 4) + '/' + MidStr(s, 5, 2) + '/'+ RightStr(s, 2);  //jz20260809 - fixed date MidStr(s, 6, 2) to MidStr(s, 5, 2)
        End
        Else // leasehold //cls='13')
        Begin
          s := Strings[colPurchaseDate];
          s := RemoveChar(s, '/');
          s := RemoveChar(s, '-');
          s := LeftStr(s, 16);
          if (Length(s) = 16) and (Numeric(s)) then
          Begin
            S1 := LeftStr(s, 8); // from date
            S1 := LeftStr(S1, 4) + '/' + MidStr(S1, 5, 2) + '/' +
              RightStr(S1, 2);
            S2 := RightStr(s, 8); // to date
            S2 := LeftStr(S2, 4) + '/' + MidStr(S2, 5, 2) + '/' +
              RightStr(S2, 2);
            Strings[colPurchaseDate] := S1 + '-' + S2;
          End;
        End;
      end; // cls>''

      // 20190607  Override section elms starting 14, 15, 16
      if (Aiip = False) and (Cls > '') then
      Begin
        If Strings[15 + k * 16] = '' then
          Strings[15 + k * 16] := 'Y'; // 20190605 half yer rule by default
      End;

      if Aiip = True then
        Strings[15 + k * 16] := ''; // 20190614 in O-H-T
      If (Cls = '24') or (Cls = '27') or (Cls = '29') or (Cls = '34') then
        Strings[15 + k * 16] := ''; // fast write off NO half year rule

      // Input validations
      if Cls = '10.1' then // 20190622
      Begin
        if PurchaseDate < GetTaxationYearStart(RetNo) then
          Tv[col3] := 0; // no additions allowed
      End;

      If (Aiip = False) and (Cls <> '56') then
        Tv[col14] := 0; // // 20220531 aiip portion of col 3

      AdditionsAiip := Tv[col14];
      // assistance part of col 5
      // If Tv[265+k*1]>Tv[9+k*16] then Tv[265+k*1]:=Tv[9+k*16];  //20220621
      Tv[col6] := MaxR(0, Tv[col6]); // col6 //20220621
      AssistanceReceived := Tv[col6];
      Tv[col7] := MaxR(0, Tv[col7]); // col 7 //20220621
      RepaidAmount := Tv[col7 * 1]; // col7
      Tv[col8] := MaxR(0, Tv[col8]);
      // 20220621  //from aboeve //20220731
      // Proceeds:=Tv[col8+k*16];  //20220731


      //jz//20260804 - dont solve for factor if is brought from s8
      //if not populateFromFedS8 then
      begin
        // aiip  related
        If Aiip = False then
        Begin
          Tv[col16] := 0;
          Tv[col17] := 0;
          Tv[colFactor] := 0;
          Tv[col18] := 0;
          Tv[col19] := 0;
        End;
        if Aiip = True then // 20190705
        Begin
          // fast write off //20190608
          if (Cls = '24') or (Cls = '27') or (Cls = '29') or (Cls = '34') then
          Begin
            Tv[col3] := 0; // additions
          End;

          Aiipfactor := '';
          if tv[col17] > 0 then
          begin

            if      (propertyType = 'RIIP')   or
                    (propertyType = 'RIIPZEV')
            then
              Aiipfactor := getRIIPFactor(Cls,leftstr(Strings[colPurchaseDate],10),leftstr(Strings[colPurchaseDate],10))
            else if (propertyType = 'AIIP')   or
                    (propertyType = 'AIIPZEV')
            then
              Aiipfactor := getAIIPFactor(Cls,leftstr(Strings[colPurchaseDate],10),leftstr(Strings[colPurchaseDate],10));

          end;
          Strings[colFactor] := Aiipfactor;
        End;
      End;

      ProceedsAiip := Tv[col16];

      HalfRuleAmount := 0;
      UCC := 0;
      UCCReduced := 0;
      Recapture := 0;
      TerminalLoss := 0;

      // get lease and orinal cost from decr box
      If LeaseHold(Cls) then // if Cls='13' then
      begin
        LeaseTerm := 5; // Default;
        // for class 13: 1234567890-1234567890
        s := ReplaceChar(AssetInfo, ',', '');
        LeaseStart := LeftStr(s, 10);
        LeaseEnd := MidStr(s, 12, 10);
        if (Length(LeaseStart) <> 10) or (Length(LeaseEnd) <> 10) then
          LeaseTerm := 0
        Else
        begin
          LeaseTerm := DateDiffYMD(LeaseStart, LeaseEnd) div 365;
          If (LeaseTerm > 0) and (LeaseTerm < 5) then
            LeaseTerm := 5;
        End;
        LeaseMaxCca := OriginalCost / LeaseTerm; // 20190611
        //20260717 Alex >>>
        {Rate := FormatFloat('####.##', 100 / LeaseTerm); // 20190601
        Strings[col20] := Rate;}
        //20260717 Alex <<<
        // if rate='INF' then ShowMessage('inf rate');

        // end;
      end;

      if Cls = '' then
      begin
        UCC := 0;
        HalfRuleAmount := 0;
        UCCReduced := 0;
        Recapture := 0;
        TerminalLoss := 0;
        CCA := 0;
        UCCEnd := 0;
      end;

      UCC := UccStart + Additions + Adjustments - AssistanceReceived +
        RepaidAmount - Proceeds; // 20190606pm
      if (Cls = '10.1') and (Proceeds > 0) then
        UCC := UccStart + Additions + Adjustments - AssistanceReceived +
          RepaidAmount; // 20190820 Get the CCA on disposal

      If LeaseHold(Cls) then // if cls='13' then //20190611
      Begin
        LeaseAdjustedCost := OriginalCost - UccStart + Additions + Adjustments -
          AssistanceReceived + RepaidAmount;
        UCCReduced := UccStart + Additions + Adjustments - AssistanceReceived +
          RepaidAmount;
      End;

      If Aiip=True then HalfYearIndic:='N'; //20260705

      if Aiip = False then // 20190706
      Begin
        if UpperCase(HalfYearIndic) = 'Y' then
        /// /20190605
        begin
          if UpperCase(OverrideIndic) <> 'Y' then // 20190605
          begin
            HalfRuleAmount :=
              MaxR(0, 0.5 * (Additions - AssistanceReceived + RepaidAmount -
              Proceeds));
            if LeaseHold(Cls) then
              HalfRuleAmount := MaxR(0, 0.5 * (Additions - Proceeds));
            // 20190613
            HalfRuleAmount := RoundCorrect(HalfRuleAmount);
          end;
        end
        else
          HalfRuleAmount := 0;


        // from below  //20220619
        if (Cls = '12') OR (Cls = '52') Or (Cls = '24') or (Cls = '27') or
          (Cls = '29') or (Cls = '34') // fast write off //20190622
        then
          UccAdjustmentNONAiip := 0; // 20190622
        UCCReduced := UCC - HalfRuleAmount;
        if LeaseHold(Cls) then
          UCCReduced := UCC; // 20190611
        ProceedsAiip := 0;
        NetCapCostAdditionsAiip := 0;
        UccAdjustmentAiip := 0;
      end // 20220619
      Else // If (Aiip=True) then
      Begin
        HalfRuleAmount := 0; // 20190608
        // 20190707
        ProceedsAiip := MaxR(0, Proceeds + AssistanceReceived - Additions +
          AdditionsAiip - RepaidAmount);
        NetCapCostAdditionsAiip := MaxR(0, AdditionsAiip - ProceedsAiip);
        if (Cls = '10.1') and (Proceeds > 0) then
          NetCapCostAdditionsAiip := AdditionsAiip;

        UccAdjustmentAiip := NetCapCostAdditionsAiip * Vl(Aiipfactor);
        UccAdjustmentNONAiip :=
          MaxR(0, 0.5 * (Additions - AdditionsAiip - AssistanceReceived +
          RepaidAmount - Proceeds)); // 20190622 moved from below

        if (Cls = '12') OR (Cls = '52') Or (Cls = '24') or (Cls = '27') or
          (Cls = '29') or (Cls = '34') then
          UccAdjustmentNONAiip := 0; // 20190622  //fast write off //20190622
      End; // 20220619

      //jz20260809 - fields not in use??
      {
      // put amounts on the S8 form
      Tv[12 + k * 16] := HalfRuleAmount; // ???
      if Aiip then
        Tv[12 + k * 16] := 0; // remove half ruleamount
      }

      // Col4
      if Tv[col4] > Tv[col3] then
        Tv[col4] := Tv[col3];

      // col9  user inout
      if Tv[col9] > Tv[col8] then
        Tv[col9] := Tv[col8];
      // col10
      //if Aiip = True then //20260720 Alex
      //  Tv[col10]:= 0 //20260720 Alex
      //else //20260720 Alex
      Tv[col10] := Tv[col2] + Tv[col3] +
        Tv[col5] - Tv[col8];

      // col11                    **
      if UpperCase(Strings[216]) = 'Y' then
        Tv[col11] := Tv[col4]; // 20221108
      if Tv[col11] > Tv[col4] then
        Tv[col11] := Tv[col4]; // 20221108

      // col12 //semi automatic  //20220827 imm expensing amount = designated
      If UpperCase(Ret[RetNo].Frm[FNo].Strings[217]) = 'Y' then
      // autofill col 12
      Begin
        If (Tv[col4] > 0) and (Tv[col12] = 0) then
          Tv[col12] := Tv[col4]; // 20221017
      end;

      if Tv[col12] > Tv[col4] then
        Tv[col12] := Tv[col11];
      if Ret[RetNo].CorpType <> CCPC then
        Tv[col12] := 0; // 20221115

      // col13
      //if Aiip = True then //20260720 Alex
      //  Tv[col13]:= 0 //20260720 Alex
      //else  //20260720 Alex
      Tv[col13] := MaxR(0, Tv[col3] - Tv[col4] +
        Tv[col11] - Tv[col12]); // 20220912 MaxR

      // col14 //jz//20260804 - had it backwards, if AIIP then add to column, make vtCalc
      if Aiip = True then
      begin
        Tv[col14] := MaxR(0, Tv[col13]); //20260717 Alex
      end
      else //20260717 Alex
        Tv[col14] := 0; //20260717 Alex

      //else //20260717 Alex
        //Tv[col14] := 0; //20260717 Alex
      // col15
      Tv[col15] := MaxR(0, Tv[col10] - Tv[col12]);
      // col16

      xx:=Tv[col8];
      xx:=Tv[col9];
      xx:=Tv[col6];
      xx:=Tv[col13];
      xx:=Tv[col14];
      xx:=Tv[col7] ;

      if Aiip = True then
        Tv[col16] := MaxR(0, Tv[col8] - Tv[col9] + Tv[col6] - Tv[col13] + Tv[col14] - Tv[col7]) // ? 54 and 56?
      else
        Tv[col16] := 0;
      // col17
      if Aiip = True then
        Tv[col17] := MaxR(0, Tv[col14] - Tv[col16])
        // ? 54 and 56?
      else
        Tv[col17] := 0;

      if Cls = '' then
      begin
        Aiipfactor := '';
        Strings[colFactor] := ''; // aiip factor
      end;


      xx:=Tv[col17];
      xx:=Vl(Strings[colFactor]);

      // col18
      if Aiip = True then //20260717 Alex
        Tv[col18] := Tv[col17] * FractionToReal(Strings[colFactor])//;//20260717 Alex
      else  //20260717 Alex
        Tv[col18]:= 0; //20260717 Alex
      // //? 54 and 56?

      // col19
      if Aiip = True then //20260717 Alex
      //Tv[col19] := MaxR(0, Tv[col13] - Tv[col14] - //20260720 Alex
      //  Tv[col6] - Tv[col17])//; // ? 54 and 56?  //20260720 Alex
        Tv[col19]:= MaxR(0, (Tv[col13] - Tv[col14] - Tv[col6] +  Tv[col7] -  Tv[col8] + Tv[col9]) * 0.5) //20260720 Alex
      else  //20260717 Alex
        Tv[col19]:= 0; //20260717 Alex

      //If not populateFromFedS8 then
      begin
        // col20
        Rate := GetCCARate(Cls); // string //20190614  see beloq //20221121 //Rate:= Strings[17 + k * 16]; //20260717 Alex //jz//20260805 - should populate rate, use previous GetCCARate, not sure why changed

        {
        //jz20260809 - ACTUALLY just make vtCalc and remove this manual override //reinstate override, should this just be regular ovrride tho??
        if Strings[ColRateOVR] <> 'Y' then
          Strings[col20] := Rate  //20260717 Alex         // if Strings[Col20+K*16]='INF' then Strings[col20*k*16] := ''; //20220912
        else
          Rate := Strings[col20];
        }

        // col21 recapture
        //20260717 Alex >>>
        Tv[col21] := 0;
        if Tv[col10] < 0 then
          Tv[col21] := Abs(Tv[col10]);

        if (Cls = '10.1') then
          Tv[col21] := 0; // 20230516
      end;

      // col22 Terminal loss
      //If not populateFromFedS8 then
      begin
        Tv[col22] := 0;
        if (UpperCase(Strings[colTerminal]) = 'Y') and (Tv[col10] > 0) //jz20260809
        then
          Tv[col22] := Tv[col10];
        if (Cls = '10.1') then
          Tv[col22] := 0; // 20230516
      end;
      //20260717 Alex <<<

      // col23 CCA
      If (Cls = '24') or (Cls = '27') or (Cls = '29') or (Cls = '34') then
      //20260717 Alex >>>
      begin
        Rate := '100'; // fast write off //20220802
        Strings[col20]:= Rate; //20260717 Alex
      end;
      //20260717 Alex <<<

      // There is CCA
      If (Tv[col21] = 0) and (Tv[col22] = 0) then
      // RGRE IS CCA (No Term loss =0 andRecpt=0 )
      begin // normal no terminal loss or  recapture
        if UpperCase(Strings[14]) <> 'Y' then // no override);
        Begin
          Tv[col23] := (Tv[col15] + Tv[col18] - Tv[col19]) * Vl(Rate) / 100 + Tv[col12];
          CCA := Tv[col23]; // 20230322
          if Ret[RetNo].DaysInYear < 365 then
          Begin
            CCA := CCA * Ret[RetNo].DaysInYear / 365;
            Tv[col23] := CCA;
          End;
        End;
      end
      Else // case: recapture  or Term loss>0 //20230512
      begin
        CCA := 0;

        Tv[col23] := 0; // if recapture or term loss then CCA =0
        // proration:?
        if Ret[RetNo].DaysInYear < 365 then
        Begin
          // Tv[col21]:=Tv[col21]/ 365;  //recapture
          // Tv[col22]:=Tv[col22] / 365; //terminal loss
        End;
      end;


      if UpperCase(Strings[colTerminal]) = 'Y' // term loss //jz20260809
      then
        Tv[col24] := 0 // no UCC end eny more
      Else
        Tv[col24] := MaxR(0, Tv[col10] - Tv[col23]);

      incrAll();

    End; // k 0 to 12  //k is the wow bing processed starts from k=0
    //Totals //jz//20260805 move totals all to one place
    calcColTotals();

  End; // with?
  SaveTv(RetNo, FName, FNo);
end;
*)



(*
//jz//20260805
//              - use GetPropertyType to judge if AIIP note:all RIIP and ZEV also considered AIIP for AB
//              - changed cols to var and added colinc such that do not need + k * 16 everywhere
//              - addressed various other issues
procedure AS13(RetNo: Integer; FName: string; FNo: Integer);

Var
  i, k, k1, j, w: Integer; //20260703 Alex
  OrigCostNdx, OrigCostS8Ndx:Integer;  //20260716cz

  FInst: String;
  S8FNo: Integer;
  Cls, s, S1, S2: String;
  TotColumn4: Real;
  OriginalCost: Real;
  UccStart, Additions, Adjustments, Proceeds, UCC, HalfRuleAmount,
    UCCReduced: Real;

  ImmediateExpensing: Real; // 20220730

  OverrideIndic, HalfYearIndic, TermLossIndic: String;
  Rate: String;
  Recapture, TerminalLoss, CCA, UCCEnd, z: Real;
  DaysInTaxYear: Integer; // > 365 then DaysInTaxYear := 365;
  // cls 13 relted
  AssetInfo: String;
  // additional fields after aiip
  Aiip: Boolean;
  AdditionsAiip, AssistanceReceived, RepaidAmount, ProceedsAiip,
    NetCapCostAdditionsAiip, UccAdjustmentAiip, UccAdjustmentNONAiip: Real;
  Aiipfactor: String;

  s8propertyType,propertyType:string;

  OverrideBox, HalfRuleBox, TerminalLossBox: String;
  HalfYearAmount: Real;

  LeaseStart, LeaseEnd: string;
  LeaseTerm: Real;
  LeaseAdjustedCost: Real; // RemainingLeaseTerm:Real;
  PurchaseDate: String;
  LeaseMaxCca: Real;
  x: Real;
  y: Real;

  FedS8FNo      : Integer;
  lCol15factor  : Integer; //20260717 Alex
  lCol16factor  : Integer; //20260717 Alex
  lColRelFactor : Integer; //20260717 Alex
  FedS8DtAcqNdx: Integer; //jz//202600805

  // columns first row index
  colOrigCost,colOrigCostInc,
  colPurchaseDate,colPurchasedateInc,
  colAIIP, colAIIPInc,
  colRelFactor, colRelFactorInc : integer;

  col1, col2, col3, col4, col5, col6, col7, col8, col9, col10,col11,col12,
  col13,col14,col15,col16,col17,col18,col19,col20,col21,col22,col23,col24 : integer;

  col1inc, col2inc, col3inc, col4inc, col5inc, col6inc, col7inc, col8inc, col9inc, col10inc,col11inc,col12inc,
  col13inc,col14inc,col15inc,col16inc,col17inc,col18inc,col19inc,col20inc,col21inc,col22inc,col23inc,col24inc  : integer;

  populateFromFedS8:boolean;


                            procedure setColNDXs(); //has to be below var
                            begin

                              colOrigCost     := 371; colOrigCostInc      := 1;
                              colPurchaseDate := 236; colPurchasedateInc  := 1;
                              colAIIP         := 356; colAIIPInc          := 1;
                              colRelFactor    := 343; colRelFactorInc     := 1;

                              col1  := 6;             col1inc  := 16;
                              col2  := 7;             col2inc  := 16;
                              col3  := 8;             col3inc  := 16;
                              col4  := 463;           col4inc  := 1;
                              col5  := 9;             col5inc  := 16;
                              col6  := 265;           col6inc  := 1;
                              col7  := 278;           col7inc  := 1;
                              col8  := 10;            col8inc  := 16;
                              col9  := 400;           col9inc  := 1;
                              col10 := 11;            col10inc := 16;
                              col11 := 424;           col11inc := 1;
                              col12 := 437;           col12inc := 1;
                              col13 := 450;           col13inc := 1;
                              col14 := 252;           col14inc := 1;
                              col15 := 476;           col15inc := 1;
                              col16 := 291;           col16inc := 1;
                              col17 := 304;           col17inc := 1;
                              col18 := 317;           col18inc := 1;
                              col19 := 330;           col19inc := 1;
                              col20 := 17;            col20inc := 16;
                              col21 := 18;            col21inc := 16;
                              col22 := 19;            col22inc := 16;
                              col23 := 20;            col23inc := 16;
                              col24 := 21;            col24inc := 16;

                            end;

begin

  setColNDXs(); //at least one col index is used in transfer from s8

  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    //20260628
    If (Ret[RetNo].Province = 'AB')
    or (Vl(FetchElm(RetNo, 'S5', 197))>0) then  //has AB income   //20260725
    //continue
    else
    begin
     For i:=1 to 524{488} do begin Strings[i]:='';Tv[i]:=0;End; //20260717 Alex
     //does not work?  ClearForm(RetNo,FName);
     SaveTv(RetNo,FName,FNo);
     exit;
    end;

    //copy from fed
    If Strings[3] = '' then Strings[3] := 'N'; // instead of 13  //20120201
    If UpperCase(Strings[3]) <> 'Y' then
      populateFromFedS8 := true
    else
      populateFromFedS8 := false;

    If populateFromFedS8 then
    begin
      FedS8FNo := GetFormNo('S8' + FInst);
      If (FedS8FNo > 0) and (Ret[RetNo].Frm[FedS8FNo].Count > 0) then
      Begin
        //20260702 Alex >>>  i= Alb  j:S8
        i:= 6; //AS13
        j:= 6; //S8
        k:= 384;
        w:= 293; //20260703 Alex
        k1:= 356; //20260703 Alex  ..aiip am propertype
        OrigCostNdx:=371; //by 1
        OrigCostS8Ndx:=313;
        lCol15factor:= 263; //20260717 Alex
        lCol16factor:= 253; //20260717 Alex
        lColRelFactor:= 343; //20260717 Alex

        FedS8DtAcqNdx:= 233;

        repeat
          //Col 200 and 001
          Strings[i]:= FetchElmFNo(RetNo, FedS8FNo, j);
          Tv[i]:= Vl(FetchElmFNo(RetNo, FedS8FNo, j));
          Strings[k]:= FetchElmFNo(RetNo, FedS8FNo, j);
          Tv[k]:= Vl(FetchElmFNo(RetNo, FedS8FNo, j));
          Tv[OrigCostNdx]:=Vl(FetchElmFNo(RetNo, FedS8FNo, OrigCostS8Ndx));

          //jz//20260805 - add date
          Strings[colPurchaseDate]:= FetchElmFNo(RetNo, FedS8FNo, FedS8DtAcqNdx);

          //Col 201 and 003
          Strings[i + 1]:= FetchElmFNo(RetNo, FedS8FNo, j + 1);
          Tv[i + 1]:= Vl(FetchElmFNo(RetNo, FedS8FNo, j + 1));
          //Col 203 and 005
          Strings[i + 2]:= FetchElmFNo(RetNo, FedS8FNo, j + 2);
          Tv[i + 2]:= Vl(FetchElmFNo(RetNo, FedS8FNo, j + 2));
          //Col 207 and 009
          Strings[i + 4]:= FetchElmFNo(RetNo, FedS8FNo, j + 8);
          Tv[i + 4]:= Vl(FetchElmFNo(RetNo, FedS8FNo, j + 8));
          //20260703 Alex >>>

          //Col AIIP
          //20260705cz
          //jz//20260804 - for alberta purposes everything makes it eligible for AIIP
          s8propertyType := FetchElmFNo(RetNo, FedS8FNo, w);
          If  (s8propertyType='AIIP'   ) or
              (s8propertyType='RIIP'   ) or
              (s8propertyType='AIIPZEV') or
              (s8propertyType='RIIPZEV')
          then
            Strings[k1]:='X'  //20260721CZ
          Else
            Strings[k1]:='';   //20260717
          //Strings[k1]:= FetchElmFNo(RetNo, FedS8FNo, w);
          //20260703 Alex <<<
          //20260717 Alex >>>
          //Col 212 in S8 and 013 (col 20) in AS13. Copy rate from S8
          Strings[i + 11]:= FetchElmFNo(RetNo, FedS8FNo, j + 17);

          //Relevant factor
          if (Vl(FetchElmFNo(RetNo, FedS8FNo, lCol15factor)) > 0) then Strings[lColRelFactor]:= FetchElmFNo(RetNo, FedS8FNo, lCol15factor) else
          if (Vl(FetchElmFNo(RetNo, FedS8FNo, lCol16factor)) > 0) then Strings[lColRelFactor]:= FetchElmFNo(RetNo, FedS8FNo, lCol16factor) else Strings[lColRelFactor]:= '0';

          //Recapture of CCA
          Tv[i + 12]:= Vl(FetchElmFNo(RetNo, FedS8FNo, j + 18));

          //Term loss
          Tv[i + 13]:= Vl(FetchElmFNo(RetNo, FedS8FNo, j + 19));
          //20260717 Alex <<<

          inc(i, 16);
          inc(j, 22);
          inc(k, 1);
          inc(k1, 1); //20260703 Alex
          inc(w, 1); //20260703 Alex
          inc(lCol15factor, 1); //20260717 Alex
          inc(lCol16factor, 1); //20260717 Alex
          inc(lColRelFactor, 1); //20260717 Alex
          //20260718
          Inc(OrigCostNdx,1);
          Inc(OrigCostS8Ndx,1);

          Inc(colPurchaseDate,colPurchaseDateInc);
          Inc(FedS8DtAcqNdx, 1);
        until (i > 204);

        {for i := 6 to 396 do // 232 do
        begin
          Strings[i] := FetchElmFNo(RetNo, FedS8FNo, i);
          Tv[i] := Vl(FetchElmFNo(RetNo, FedS8FNo, i));
        end;}
        //20260702 Alex <<<
      //20230610
        Strings[1] := FetchElm(RetNo,GetFormNo('AT1'),9);
        Strings[2] := FetchElm(RetNo,GetFormNo('T2'),11);
        Strings[29] := FetchElmFNo(RetNo,FedS8FNo,29);
        SaveTv(RetNo, FName, FNo);  //20260717 Alex
        //EXIT; //20260717 Alex
      end; // count
    end; // 'Y'
  end; // with

  setColNDXs();     //set them again as at least one index is used in above transfer from s8

  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 1, 2); // 20190626
    DaysInTaxYear := Ret[RetNo].DaysInYear;
    If DaysInTaxYear > 365 then DaysInTaxYear := 365;

    S8FNo := GetFormNo('S8#1'); // 20220826
    FInst := ExtractFormInst(FName);

    If Strings[4] + Strings[5] = '' then
      Strings[5] := 'X';
    If Strings[216] = '' then
      Strings[216] := 'N'; // 20221107
    If Strings[217] = '' then
      Strings[217] := 'Y';

    // INIT Totals //20190614
    i := 530;
    z := 0;
    Repeat
      if Strings[i - 2] = '' then
        Strings[i - 1] := ''; // 20230309
      z := z + Vl(Strings[i]);
      Inc(i, 3); // 20220912
    Until i > 599;

    Strings[13] := FormatFloat('###.####', z);

    If z > 100 then
      Strings[29] := '0'
    else
    Begin
      y := (Ret[RetNo].DaysInYear / 365) * (1500000 * Vl(Strings[530]) / 100);
      // the first on the list
      Strings[29] := FormatFloat('##,###,###', y);
    end;

    Tv[77] := 0;
    Tv[93] := 0; // DIEP UCC plus ImmeeditateExpensing column //20220730
    Tv[249] := 0;
    Tv[234] := 0;
    Tv[250] := 0;
    Tv[235] := 0;
    Tv[230] := 0;
    Tv[231] := 0;
    Tv[232] := 0;
    Tv[251] := 0;

    for i := 384 to 396 do
      Strings[i] := '';
    // initialize the bottom class numbers, then copy them //20190705
    for i := 515 to 527 do
      Strings[i] := '';
    // initialize the botom class numbers, then copy them //20190705

    for k := 0 to 9{12} do // 12 do //20260717 Alex - 10 rows only
    /// /k is the row being processed starts from k=0 //13 rows per section
    Begin
      // repeate class for each section from Part 2
      Cls := AllTrim(Strings[col1]); // 20190719 //alltrim
      Strings[384 + k * 1] := Cls; // 20190705
      Strings[515 + k * 1] := Cls; // 20220730 //dupl/copy cless

      // Rate := GetCCARate(Cls); // string //20190614  see beloq //20221121
      Rate:= Strings[17 + k * 16]; //20260717 Alex

      //jz//20260805 - USE GetPropertyType instead
      {
      //jz//20260804 - seems wrong, is AB different from fed?? adjust when applied but leave mostly for now
      if not populateFromFedS8 then
      begin
        //jz//20260801 - moved from below as AIIP var is used shortly after here and needs to be set -->
        // AIIP indicator//20190621
        // 20190705
        Strings[colAIIP] := '';
        if (Additions > 0) and (Cls > '') then
        Begin
          s := ReplaceChar(AssetInfo, ',', '');
          PurchaseDate := LeftStr(s, 10);
          if (PurchaseDate > '2018/11/20') or (GetTaxationYearStart(RetNo) > '2018/11/20')
          // 20220619 additions made after the Aiip date of 2018
          then
            Strings[colAIIP] := 'X' // then 10.1 is aiip
          Else
            Strings[colAIIP] := ''; // 20190705
        end;

        if (GetTaxationYearEnd(RetNo) > '2027/12/31') then
          Strings[colAIIP] := '';
        // NO AIIP after 2027? Check it then IF ALIVE! //20190704
        If Strings[colAIIP] > '' then
          Aiip := True
        else
          Aiip := False; // 20190614

        if Cls = '56' then
        Begin
          Aiip := False;
          Strings[colAIIP] := '';
        end; // 20220531

        // <-- jz//20260801 - moved from below as AIIP var is used shortly after here and needs to be set

      end;
      }

      //jz//20260805 - USE GetPropertyType instead of previous
      if not populateFromFedS8 then
      begin
        //propertyType := GetPropertyType(retNo, lCls, strings[lColAquiredDate], strings[lColAvailableDate], FetchElm(RetNo, 'T2', 10), FetchElm(RetNo, 'T2', 11));
        propertyType := GetPropertyType(retNo, strings[col1], leftstr(strings[colPurchaseDate],10), leftstr(strings[colPurchaseDate],10), FetchElm(RetNo, 'T2', 10), FetchElm(RetNo, 'T2', 11));
        If  (propertyType='AIIP'   ) or
            (propertyType='RIIP'   ) or
            (propertyType='AIIPZEV') or
            (propertyType='RIIPZEV')
        then
          Strings[colAIIP]:='X'  //20260721CZ
        Else
          Strings[colAIIP]:='';
      end;
      //jz//20260804
      if Strings[colAIIP] = 'X' then Aiip := TRUE else Aiip := FALSE;

      // set up override indicatore
      If UpperCase(Strings[14 + k * 16]) = 'O' then
        Strings[14 + k * 16] := 'Y'; // override
      If UpperCase(Strings[15 + k * 16]) = 'H' then
        Strings[15 + k * 16] := 'Y'; // half year

      if AIIP=True then
        Strings[15 + k * 16] := 'N'; // half year

      if Vl(Rate) = 100 then
        Strings[15 + k * 16] := 'N';
      // 20190614 No half year rule for fast write off //20190614
      If UpperCase(Strings[16 + k * 16]) = 'T' then
        Strings[16 + k * 16] := 'Y'; // Term loss
      If UpperCase(Strings[14 + k * 16]) = 'X' then
        Strings[14 + k * 16] := 'Y'; // override
      If UpperCase(Strings[15 + k * 16]) = 'X' then
        Strings[15 + k * 16] := 'Y'; // half year
      If UpperCase(Strings[16 + k * 16]) = 'X' then
        Strings[16 + k * 16] := 'Y'; // Term loss

      // 20221121 from further below
      OverrideIndic := UpperCase(Strings[14 + k * 16]);
      HalfYearIndic := UpperCase(Strings[15 + k * 16]);
      TermLossIndic := UpperCase(Strings[16 + k * 16]);

      // Rate := GetCCARate(Cls); //20221121
      //20260717 Alex >>>
      {If Strings[489 + k * 1] <> 'Y' then // override rate
        Strings[17 + k * 16] := GetCCARate(Cls); // 20221121
      Rate := Strings[17 + k * 16];}
      //20260717 Alex <<<

      OriginalCost := Tv[colOrigCost];
      AssetInfo := Strings[colPurchaseDate];
      // calculate each Column mow
      UccStart  := Tv[col2]; // col2
      Additions := Tv[col3]; // col3
      if DiepClass(Cls) = False then
        Tv[col4] := 0; // 20221115 //Tv[col2 + k * 16] := 0; // 20221107
      if DiepClass(Cls) = False then
        Tv[col9] := 0; // 20221015
      if Strings[216] = '' then
        Strings[216] := 'Y';
      // if DiepClass(Cls) = False then Tv[col11 + k * 1] := 0; // 20221015

      Adjustments := Tv[col5]; // cpl 5

      // if UpperCase(Strings[216])='Y' then Tv[col11+k*1]:=Tv[col5 + k * 1]; //20221108
      // if Tv[col11+k*1]>Tv[col5 + k * 1] then Tv[col5 + k * 1]:=Tv[col5 + k * 1]; //20221108

      // DiepUcc := Tv[col11 + k * 1]; // 20220826 //20221107
      Tv[77] := Tv[77] + Tv[col11];
      ImmediateExpensing := Tv[col12]; // 20220826
      Tv[93] := Tv[93] + ImmediateExpensing;

      // move down
      // Tv[col8+k*16]:=MaxR(0,Tv[col8+k*16]);  //20220621
      // Proceeds:=Tv[col8+k*16];

      if (LeaseHold(Cls)) and (UccStart > 0) Then
      begin
        { //20220913
          Additions := 0;
          Tv[col3 + k * 16] := 0;
        }
      end; // do not allow additions to 13 //20190705
      // 20190809  accept yyymmdd in case they entered yyyy/mm/dd
      If (Cls > '') then
      begin
        if Not LeaseHold(Cls) then
        Begin
          // replace yyymmdd with yyy/mm/dd for date
          s := LeftStr(Strings[colPurchaseDate], 8);
          if (Length(s) = 8) and (Numeric(s)) then
            Strings[colPurchaseDate] := LeftStr(s, 4) + '/' + MidStr(s, 6, 2) + '/'
              + RightStr(s, 2);
        End
        Else // leasehold //cls='13')
        Begin
          s := Strings[colPurchaseDate];
          s := RemoveChar(s, '/');
          s := RemoveChar(s, '-');
          s := LeftStr(s, 16);
          if (Length(s) = 16) and (Numeric(s)) then
          Begin
            S1 := LeftStr(s, 8); // from date
            S1 := LeftStr(S1, 4) + '/' + MidStr(S1, 5, 2) + '/' +
              RightStr(S1, 2);
            S2 := RightStr(s, 8); // to date
            S2 := LeftStr(S2, 4) + '/' + MidStr(S2, 5, 2) + '/' +
              RightStr(S2, 2);
            Strings[colPurchaseDate] := S1 + '-' + S2;
          End;
        End;
      end; // cls>''

      //jz//20260801 - move to above as AIIP var is used there for half year -->
      {
      {
      // AIIP indicator//20190621
      // 20190705
      Strings[colAIIP] := '';
      if (Additions > 0) and (Cls > '') then
      Begin
        s := ReplaceChar(AssetInfo, ',', '');
        PurchaseDate := LeftStr(s, 10);
        if (PurchaseDate > '2018/11/20') or
          (GetTaxationYearStart(RetNo) > '2018/11/20')
        // 20220619 additions made after the Aiip date of 2018
        then
          Strings[colAIIP] := 'X' // then 10.1 is aiip
        Else
          Strings[colAIIP] := ''; // 20190705
      end;

      if (GetTaxationYearEnd(RetNo) > '2027/12/31') then
        Strings[colAIIP] := '';
      // NO AIIP after 2027? Check it then IF ALIVE! //20190704
      If Strings[colAIIP] > '' then
        Aiip := True
      else
        Aiip := False; // 20190614
      if Cls = '56' then
      Begin
        Aiip := False;
        Strings[colAIIP] := '';
      end; // 20220531
      }
      // <-- jz//20260801 - move to above as AIIP var is used there for half year


      // 20190607  Override section elms starting 14, 15, 16
      if (Aiip = False) and (Cls > '') then
      Begin
        If Strings[15 + k * 16] = '' then
          Strings[15 + k * 16] := 'Y'; // 20190605 half yer rule by default
      End;

      if Aiip = True then
        Strings[15 + k * 16] := ''; // 20190614 in O-H-T
      If (Cls = '24') or (Cls = '27') or (Cls = '29') or (Cls = '34') then
        Strings[15 + k * 16] := ''; // fast write off NO half year rule
      { //20221121
        OverrideIndic := UpperCase(Strings[14 + k * 16]);
        HalfYearIndic := UpperCase(Strings[15 + k * 16]);
        TermLossIndic := UpperCase(Strings[16 + k * 16]);
      }

      // If UpperCase(OverrideIndic) <> 'Y' then Rate := GetCCARate(Cls); //20221121 see in beginning

      // Inpout validations
      if Cls = '10.1' then // 20190622
      Begin
        if PurchaseDate < GetTaxationYearStart(RetNo) then
          Tv[col3] := 0; // no additions allowed
      End;

      If (Aiip = False) and (Cls <> '56') then
        Tv[col14] := 0; // // 20220531 aiip portion of col 3

      AdditionsAiip := Tv[col14];
      // assistance part of col 5
      // If Tv[265+k*1]>Tv[9+k*16] then Tv[265+k*1]:=Tv[9+k*16];  //20220621
      Tv[col6] := MaxR(0, Tv[col6]); // col6 //20220621
      AssistanceReceived := Tv[col6];
      Tv[col7] := MaxR(0, Tv[col7]); // col 7 //20220621
      RepaidAmount := Tv[col7 * 1]; // col7
      Tv[col8] := MaxR(0, Tv[col8]);
      // 20220621  //from aboeve //20220731
      // Proceeds:=Tv[col8+k*16];  //20220731


      //jz//20260804 - dont solve for factor if is brought from s8
      if populateFromFedS8 then
      begin
        // aiip  related
        If Aiip = False then
        Begin
          Tv[col16] := 0;
          Tv[col17] := 0;
          Tv[colRelFactor] := 0;
          Tv[col18] := 0;
          Tv[col19] := 0;
        End;
        if Aiip = True then // 20190705
        Begin
          // fast write off //20190608
          if (Cls = '24') or (Cls = '27') or (Cls = '29') or (Cls = '34') then
          Begin
            Tv[col3] := 0; // additions
          End;
          // 20210328
          // Aiipfactor
          Aiipfactor := '';
          Strings[colRelFactor] := '';
          // if Cls = '' then Aiipfactor := ''; // 20190622
          if (Cls = '') or (Aiip = False) then
            Aiipfactor := ''; // default //20220801

          if Cls = '43.1' then
            Aiipfactor := '2.33333'
          Else if Cls = '43.2' then
            Aiipfactor := '1'
          Else if Cls = '53' then
            Aiipfactor := '1'
          Else if (Cls = '54') then
          Begin
            if Strings[colPurchaseDate] > '2019/03/18' then
            begin
              Strings[colAIIP] := 'X';
              Aiipfactor := '2.33333333';
            end
            Else If Strings[colPurchaseDate] > '2018/11/20' then
            begin
              Strings[colAIIP] := 'X';
              Aiipfactor := '0.5';
            end;
          End // aiip true
          Else if (Cls = '55') and (Strings[colPurchaseDate] > '2019/03/18') then
            Aiipfactor := '1.5'
          Else if (Cls = '56') then
            Aiipfactor := '2.333331' // 20210927
          Else if (Cls = '12') or (LeaseHold(Cls)) or (Cls = '14') or (Cls = '15')
          then
            Aiipfactor := '' // 20190806
          Else
            Aiipfactor := '0.5';
        End;

        Strings[colRelFactor] := Aiipfactor; //20260717 Alex
      end;


      ProceedsAiip := Tv[col16];

      HalfRuleAmount := 0;
      UCC := 0;
      UCCReduced := 0;
      Recapture := 0;
      TerminalLoss := 0;

      // get lease and orinal cost from decr box
      If LeaseHold(Cls) then // if Cls='13' then
      begin
        LeaseTerm := 5; // Default;
        // for class 13: 1234567890-1234567890
        s := ReplaceChar(AssetInfo, ',', '');
        LeaseStart := LeftStr(s, 10);
        LeaseEnd := MidStr(s, 12, 10);
        if (Length(LeaseStart) <> 10) or (Length(LeaseEnd) <> 10) then
          LeaseTerm := 0
        Else
        begin
          LeaseTerm := DateDiffYMD(LeaseStart, LeaseEnd) div 365;
          If (LeaseTerm > 0) and (LeaseTerm < 5) then
            LeaseTerm := 5;
        End;
        LeaseMaxCca := OriginalCost / LeaseTerm; // 20190611
        //20260717 Alex >>>
        {Rate := FormatFloat('####.##', 100 / LeaseTerm); // 20190601
        Strings[col20] := Rate;}
        //20260717 Alex <<<
        // if rate='INF' then ShowMessage('inf rate');

        // end;
      end;

      if Cls = '' then
      begin
        UCC := 0;
        HalfRuleAmount := 0;
        UCCReduced := 0;
        Recapture := 0;
        TerminalLoss := 0;
        CCA := 0;
        UCCEnd := 0;
      end;

      UCC := UccStart + Additions + Adjustments - AssistanceReceived +
        RepaidAmount - Proceeds; // 20190606pm
      if (Cls = '10.1') and (Proceeds > 0) then
        UCC := UccStart + Additions + Adjustments - AssistanceReceived +
          RepaidAmount; // 20190820 Get the CCA on disposal

      If LeaseHold(Cls) then // if cls='13' then //20190611
      Begin
        LeaseAdjustedCost := OriginalCost - UccStart + Additions + Adjustments -
          AssistanceReceived + RepaidAmount;
        UCCReduced := UccStart + Additions + Adjustments - AssistanceReceived +
          RepaidAmount;
      End;

      If Aiip=True then HalfYearIndic:='N'; //20260705

      if Aiip = False then // 20190706
      Begin
        if UpperCase(HalfYearIndic) = 'Y' then
        /// /20190605
        begin
          if UpperCase(OverrideIndic) <> 'Y' then // 20190605
          begin
            HalfRuleAmount :=
              MaxR(0, 0.5 * (Additions - AssistanceReceived + RepaidAmount -
              Proceeds));
            if LeaseHold(Cls) then
              HalfRuleAmount := MaxR(0, 0.5 * (Additions - Proceeds));
            // 20190613
            HalfRuleAmount := RoundCorrect(HalfRuleAmount);
          end;
        end
        else
          HalfRuleAmount := 0;


        // from below  //20220619
        if (Cls = '12') OR (Cls = '52') Or (Cls = '24') or (Cls = '27') or
          (Cls = '29') or (Cls = '34') // fast write off //20190622
        then
          UccAdjustmentNONAiip := 0; // 20190622
        UCCReduced := UCC - HalfRuleAmount;
        if LeaseHold(Cls) then
          UCCReduced := UCC; // 20190611
        ProceedsAiip := 0;
        NetCapCostAdditionsAiip := 0;
        UccAdjustmentAiip := 0;
      end // 20220619
      Else // If (Aiip=True) then
      Begin
        HalfRuleAmount := 0; // 20190608
        // 20190707
        ProceedsAiip := MaxR(0, Proceeds + AssistanceReceived - Additions +
          AdditionsAiip - RepaidAmount);
        NetCapCostAdditionsAiip := MaxR(0, AdditionsAiip - ProceedsAiip);
        if (Cls = '10.1') and (Proceeds > 0) then
          NetCapCostAdditionsAiip := AdditionsAiip;

        UccAdjustmentAiip := NetCapCostAdditionsAiip * Vl(Aiipfactor);
        UccAdjustmentNONAiip :=
          MaxR(0, 0.5 * (Additions - AdditionsAiip - AssistanceReceived +
          RepaidAmount - Proceeds)); // 20190622 moved from below

        if (Cls = '12') OR (Cls = '52') Or (Cls = '24') or (Cls = '27') or
          (Cls = '29') or (Cls = '34') then
          UccAdjustmentNONAiip := 0; // 20190622  //fast write off //20190622
      End; // 20220619
      // put amounts on the S8 form
      Tv[12 + k * 16] := HalfRuleAmount; // ???
      if Aiip then
        Tv[12 + k * 16] := 0; // remove half ruleamount

      // Col2
      Tv[249] := Tv[249] + Tv[col2];

      // Col3
      Tv[234] := Tv[234] + Tv[col3];

      // Col4
      if Tv[col4] > Tv[col3] then
        Tv[col4] := Tv[col3];
      Tv[250]:= Tv[250] + Tv[col5]; //20260717 Alex
      // Col8                                 -
      Tv[235] := Tv[235] + Tv[col8];
      // col9  user inout
      if Tv[col9] > Tv[col8] then
        Tv[col9] := Tv[col8];
      // col10
      //if Aiip = True then //20260720 Alex
      //  Tv[col10]:= 0 //20260720 Alex
      //else //20260720 Alex
      Tv[col10] := Tv[col2] + Tv[col3] +
        Tv[col5] - Tv[col8];

      // col11                    **
      if UpperCase(Strings[216]) = 'Y' then
        Tv[col11] := Tv[col4]; // 20221108
      if Tv[col11] > Tv[col4] then
        Tv[col11] := Tv[col4]; // 20221108

      Tv[77]:= Tv[77] + Tv[col11]; //20260717 Alex

      // col12 //semi automatic  //20220827 imm expensing amount = designated
      If UpperCase(Ret[RetNo].Frm[FNo].Strings[217]) = 'Y' then
      // autofill col 12
      Begin
        If (Tv[col4] > 0) and (Tv[col12] = 0) then
          Tv[col12] := Tv[col4]; // 20221017
      end;

      if Tv[col12] > Tv[col4] then
        Tv[col12] := Tv[col11];
      if Ret[RetNo].CorpType <> CCPC then
        Tv[col12] := 0; // 20221115

      // col13
      //if Aiip = True then //20260720 Alex
      //  Tv[col13]:= 0 //20260720 Alex
      //else  //20260720 Alex
      Tv[col13] := MaxR(0, Tv[col3] - Tv[col4] +
        Tv[col11] - Tv[col12]); // 20220912 MaxR

      Tv[93]:= Tv[93] + Tv[col13]; //20260717 Alex

      // col14 //jz//20260804 - had it backwards, if AIIP then add to column, make vtCalc
      if Aiip = True then
      begin
        Tv[col14] := MaxR(0, Tv[col13]); //20260717 Alex
      end
      else //20260717 Alex
        Tv[col14] := 0; //20260717 Alex

      //else //20260717 Alex
        //Tv[col14] := 0; //20260717 Alex
      // col15
      Tv[col15] := MaxR(0, Tv[col10] - Tv[col12]);
      // col16

      xx:=Tv[col8];
      xx:=Tv[col9];
      xx:=Tv[col6];
      xx:=Tv[col13];
      xx:=Tv[col14];
      xx:=Tv[col7] ;

      if Aiip = True then
        Tv[col16] := MaxR(0, Tv[col8] - Tv[col9] + Tv[col6] - Tv[col13] + Tv[col14] - Tv[col7]) // ? 54 and 56?
      else
        Tv[col16] := 0;
      // col17
      if Aiip = True then
        Tv[col17] := MaxR(0, Tv[col14] - Tv[col16])
        // ? 54 and 56?
      else
        Tv[col17] := 0;

      if Cls = '' then
      begin
        Aiipfactor := '';
        Strings[colRelFactor] := ''; // aiip factor
      end;


      xx:=Tv[col17];
      xx:=Vl(Strings[colRelFactor]);

      // col18
      if Aiip = True then //20260717 Alex
        Tv[col18] := Tv[col17] * FractionToReal(Strings[colRelFactor])//;//20260717 Alex
      else  //20260717 Alex
        Tv[col18]:= 0; //20260717 Alex
      // //? 54 and 56?

      // col19
      if Aiip = True then //20260717 Alex
      //Tv[col19] := MaxR(0, Tv[col13] - Tv[col14] - //20260720 Alex
      //  Tv[col6] - Tv[col17])//; // ? 54 and 56?  //20260720 Alex
        Tv[col19]:= MaxR(0, (Tv[col13] - Tv[col14] - Tv[col6] +  Tv[col7] -  Tv[col8] + Tv[col9]) * 0.5) //20260720 Alex
      else  //20260717 Alex
        Tv[col19]:= 0; //20260717 Alex

      // col20
      //Strings[col20] := Rate; //20260717 Alex
      // if Strings[Col20+K*16]='INF' then Strings[col20*k*16] := ''; //20220912
      // col21 recapture
      //20260717 Alex >>>
      If populateFromFedS8 then
      begin
        Tv[col21] := 0;
        if Tv[col10] < 0 then
          Tv[col21] := Abs(Tv[col10]);

        if (Cls = '10.1') then
          Tv[col21] := 0; // 20230516
      end;
      Tv[230]:= Tv[230] + Tv[col21];

      // col22 Terminal loss
      If populateFromFedS8 then
      begin
        Tv[col22] := 0;
        if (UpperCase(Strings[16]) = 'Y') and (Tv[col10] > 0)
        then
          Tv[col22] := Tv[col10];
        if (Cls = '10.1') then
          Tv[col22] := 0; // 20230516
      end;
      Tv[231] := Tv[231] + Tv[col22];
      //20260717 Alex <<<

      // col23 CCA
      If (Cls = '24') or (Cls = '27') or (Cls = '29') or (Cls = '34') then
      //20260717 Alex >>>
      begin
        Rate := '100'; // fast write off //20220802
        Strings[col20]:= Rate; //20260717 Alex
      end;
      //20260717 Alex <<<

      // There is CCA
      If (Tv[col21] = 0) and (Tv[col22] = 0) then
      // RGRE IS CCA (No Term loss =0 andRecpt=0 )
      begin // normal no gtterminal loss or  recapture
        if UpperCase(Strings[14]) <> 'Y' then // no override);
        Begin
          Tv[col23] := (Tv[col15] + Tv[col18] -
            Tv[col19]) * Vl(Rate) / 100 + Tv[col12];
          CCA := Tv[col23]; // 20230322
          if Ret[RetNo].DaysInYear < 365 then
          Begin
            CCA := CCA * Ret[RetNo].DaysInYear / 365;
            Tv[col23] := CCA;
          End;
        End;
      end
      Else // case: recapture  or Term loss>0 //20230512
      begin
        CCA := 0;

        Tv[col23] := 0; // if recapture or term loss then CCA =0
        // proration:?
        if Ret[RetNo].DaysInYear < 365 then
        Begin
          // Tv[col21]:=Tv[col21]/ 365;  //recapture
          // Tv[col22]:=Tv[col22] / 365; //terminal loss
        End;
      end;

      Tv[232] := Tv[232] + Tv[col23];

      if UpperCase(Strings[16 + k * 16]) = 'Y' // term loss
      then
        Tv[col24] := 0 // no UCC end eny more
      Else
        Tv[col24] := MaxR(0, Tv[col10] - Tv[col23]);

      Tv[251] := Tv[251] + Tv[col24];


      //jz//20260804
      inc(colOrigCost    , colOrigCostInc);
      inc(colPurchaseDate, colPurchasedateInc);
      inc(colAIIP,         colAIIPInc);
      inc(colRelFactor,    colRelFactorInc);

      inc(col1,  col1inc);
      inc(col2,  col2inc);
      inc(col3,  col3inc);
      inc(col4,  col4inc);
      inc(col5,  col5inc);
      inc(col6,  col6inc);
      inc(col7,  col7inc);
      inc(col8,  col8inc);
      inc(col9,  col9inc);
      inc(col10, col10inc);
      inc(col11, col11inc);
      inc(col12, col12inc);
      inc(col13, col13inc);
      inc(col14, col14inc);
      inc(col15, col15inc);
      inc(col16, col16inc);
      inc(col17, col17inc);
      inc(col18, col18inc);
      inc(col19, col19inc);
      inc(col20, col20inc);
      inc(col21, col21inc);
      inc(col22, col22inc);
      inc(col23, col23inc);
      inc(col24, col24inc);

    End; // k 0 to 12  //k is the wow bing processed starts from k=0

  End; // with?
  SaveTv(RetNo, FName, FNo);
end;
*)



(*
//jz//20260804 - adjusted AIIP calc
//             - changed cols to var and added colinc such that do not need + k * 16 everywhere
//             - addressed various other issues
procedure AS13(RetNo: Integer; FName: string; FNo: Integer);

                function FractionToReal(const S: string): Real;
                var
                  BarPos: Integer;
                  NumStr, DenomStr: string;
                  Num, Denom: Real;
                  CustomSettings: TFormatSettings;
                begin
                  //check if no value, '' causes error in StrToFloat for some reason
                  if S='' then begin Result := 0; exit;end;

                  // Initialize with standard system defaults
                  CustomSettings := TFormatSettings.Create;
                  // Explicitly force the separator to be a dot, error sometimes otherwise
                  CustomSettings.DecimalSeparator := '.';

                  BarPos := Pos('/', S); //Check for the division operator
                  // If no fraction bar, just convert as standard float and exit
                  if BarPos = 0 then begin Result := StrToFloat(S,CustomSettings); Exit; end;

                  // Extract numerator and denominator
                  NumStr   := Trim(Copy(S, 1, BarPos - 1));
                  DenomStr := Trim(Copy(S, BarPos + 1, Length(S)));

                  // Convert to Real and perform division
                  Num := StrToFloat(NumStr);
                  Denom := StrToFloat(DenomStr);

                  if Denom = 0 then
                    raise EConvertError.Create('Denominator cannot be zero');

                  Result := Num / Denom;
                end;

Var
  i, k, k1, j, w: Integer; //20260703 Alex
  OrigCostNdx, OrigCostS8Ndx:Integer;  //20260716cz

  FInst: String;
  S8FNo: Integer;
  Cls, s, S1, S2: String;
  TotColumn4: Real;
  OriginalCost: Real;
  UccStart, Additions, Adjustments, Proceeds, UCC, HalfRuleAmount,
    UCCReduced: Real;

  ImmediateExpensing: Real; // 20220730

  OverrideIndic, HalfYearIndic, TermLossIndic: String;
  Rate: String;
  Recapture, TerminalLoss, CCA, UCCEnd, z: Real;
  DaysInTaxYear: Integer; // > 365 then DaysInTaxYear := 365;
  // cls 13 relted
  AssetInfo: String;
  // additional fields after aiip
  Aiip: Boolean;
  AdditionsAiip, AssistanceReceived, RepaidAmount, ProceedsAiip,
    NetCapCostAdditionsAiip, UccAdjustmentAiip, UccAdjustmentNONAiip: Real;
  Aiipfactor: String;

  s8propertyType:string;

  OverrideBox, HalfRuleBox, TerminalLossBox: String;
  HalfYearAmount: Real;

  LeaseStart, LeaseEnd: string;
  LeaseTerm: Real;
  LeaseAdjustedCost: Real; // RemainingLeaseTerm:Real;
  PurchaseDate: String;
  LeaseMaxCca: Real;
  x: Real;
  y: Real;

  FedS8FNo: Integer;
  lCol15factor: Integer; //20260717 Alex
  lCol16factor: Integer; //20260717 Alex
  lColRelFactor: Integer; //20260717 Alex

  // columns first row index
  colPurchaseDate,colPurchasedateInc,
  colAIIP, colAIIPInc,
  colRelFactor, colRelFactorInc : integer;

  col1, col2, col3, col4, col5, col6, col7, col8, col9, col10,col11,col12,
  col13,col14,col15,col16,col17,col18,col19,col20,col21,col22,col23,col24 : integer;

  col1inc, col2inc, col3inc, col4inc, col5inc, col6inc, col7inc, col8inc, col9inc, col10inc,col11inc,col12inc,
  col13inc,col14inc,col15inc,col16inc,col17inc,col18inc,col19inc,col20inc,col21inc,col22inc,col23inc,col24inc  : integer;

  populateFromFedS8:boolean;
begin

  colPurchaseDate := 236; colPurchasedateInc  := 1;
  colAIIP         := 356; colAIIPInc          := 1;
  colRelFactor    := 343; colRelFactorInc     := 1;

  col1  := 6;             col1inc  := 16;
  col2  := 7;             col2inc  := 16;
  col3  := 8;             col3inc  := 16;
  col4  := 463;           col4inc  := 1;
  col5  := 9;             col5inc  := 16;
  col6  := 265;           col6inc  := 1;
  col7  := 278;           col7inc  := 1;
  col8  := 10;            col8inc  := 16;
  col9  := 400;           col9inc  := 1;
  col10 := 11;            col10inc := 16;
  col11 := 424;           col11inc := 1;
  col12 := 437;           col12inc := 1;
  col13 := 450;           col13inc := 1;
  col14 := 252;           col14inc := 1;
  col15 := 476;           col15inc := 1;
  col16 := 291;           col16inc := 1;
  col17 := 304;           col17inc := 1;
  col18 := 317;           col18inc := 1;
  col19 := 330;           col19inc := 1;
  col20 := 17;            col20inc := 16;
  col21 := 18;            col21inc := 16;
  col22 := 19;            col22inc := 16;
  col23 := 20;            col23inc := 16;
  col24 := 21;            col24inc := 16;



  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    //20260628
    If (Ret[RetNo].Province = 'AB')
    or (Vl(FetchElm(RetNo, 'S5', 197))>0) then  //has AB income   //20260725
    //continue
    else
    begin
     For i:=1 to 524{488} do begin Strings[i]:='';Tv[i]:=0;End; //20260717 Alex
     //does not work?  ClearForm(RetNo,FName);
     SaveTv(RetNo,FName,FNo);
     exit;
    end;

    //copy from fed
    If Strings[3] = '' then Strings[3] := 'N'; // instead of 13  //20120201
    If UpperCase(Strings[3]) <> 'Y' then
      populateFromFedS8 := false
    else
      populateFromFedS8 := true;

    If populateFromFedS8 then
    begin
      FedS8FNo := GetFormNo('S8' + FInst);
      If (FedS8FNo > 0) and (Ret[RetNo].Frm[FedS8FNo].Count > 0) then
      Begin
        //20260702 Alex >>>  i= Alb  j:S8
        i:= 6; //AS13
        j:= 6; //S8
        k:= 384;
        w:= 293; //20260703 Alex
        k1:= 356; //20260703 Alex  ..aiip am propertype
        OrigCostNdx:=371; //by 1
        OrigCostS8Ndx:=313;
        lCol15factor:= 263; //20260717 Alex
        lCol16factor:= 253; //20260717 Alex
        lColRelFactor:= 343; //20260717 Alex

        repeat
          //Col 200 and 001
          Strings[i]:= FetchElmFNo(RetNo, FedS8FNo, j);
          Tv[i]:= Vl(FetchElmFNo(RetNo, FedS8FNo, j));
          Strings[k]:= FetchElmFNo(RetNo, FedS8FNo, j);
          Tv[k]:= Vl(FetchElmFNo(RetNo, FedS8FNo, j));
          Tv[OrigCostNdx]:=Vl(FetchElmFNo(RetNo, FedS8FNo, OrigCostS8Ndx));
          //Col 201 and 003
          Strings[i + 1]:= FetchElmFNo(RetNo, FedS8FNo, j + 1);
          Tv[i + 1]:= Vl(FetchElmFNo(RetNo, FedS8FNo, j + 1));
          //Col 203 and 005
          Strings[i + 2]:= FetchElmFNo(RetNo, FedS8FNo, j + 2);
          Tv[i + 2]:= Vl(FetchElmFNo(RetNo, FedS8FNo, j + 2));
          //Col 207 and 009
          Strings[i + 4]:= FetchElmFNo(RetNo, FedS8FNo, j + 8);
          Tv[i + 4]:= Vl(FetchElmFNo(RetNo, FedS8FNo, j + 8));
          //20260703 Alex >>>

          //Col AIIP
          //20260705cz
          //jz//20260804 - for alberta purposes everything makes it eligible for AIIP
          s8propertyType := FetchElmFNo(RetNo, FedS8FNo, w);
          If  (s8propertyType='AIIP'   ) or
              (s8propertyType='RIIP'   ) or
              (s8propertyType='AIIPZEV') or
              (s8propertyType='RIIPZEV')
          then
            Strings[k1]:='X'  //20260721CZ
          Else
            Strings[k1]:='';   //20260717
          //Strings[k1]:= FetchElmFNo(RetNo, FedS8FNo, w);
          //20260703 Alex <<<
          //20260717 Alex >>>
          //Col 212 in S8 and 013 (col 20) in AS13. Copy rate from S8
          Strings[i + 11]:= FetchElmFNo(RetNo, FedS8FNo, j + 17);

          //Relevant factor
          if (Vl(FetchElmFNo(RetNo, FedS8FNo, lCol15factor)) > 0) then Strings[lColRelFactor]:= FetchElmFNo(RetNo, FedS8FNo, lCol15factor) else
          if (Vl(FetchElmFNo(RetNo, FedS8FNo, lCol16factor)) > 0) then Strings[lColRelFactor]:= FetchElmFNo(RetNo, FedS8FNo, lCol16factor) else Strings[lColRelFactor]:= '0';

          //Recapture of CCA
          Tv[i + 12]:= Vl(FetchElmFNo(RetNo, FedS8FNo, j + 18));

          //Term loss
          Tv[i + 13]:= Vl(FetchElmFNo(RetNo, FedS8FNo, j + 19));
          //20260717 Alex <<<

          inc(i, 16);
          inc(j, 22);
          inc(k, 1);
          inc(k1, 1); //20260703 Alex
          inc(w, 1); //20260703 Alex
          inc(lCol15factor, 1); //20260717 Alex
          inc(lCol16factor, 1); //20260717 Alex
          inc(lColRelFactor, 1); //20260717 Alex
          //20260718
          Inc(OrigCostNdx,1);
          Inc(OrigCostS8Ndx,1);
        until (i > 204);

        {for i := 6 to 396 do // 232 do
        begin
          Strings[i] := FetchElmFNo(RetNo, FedS8FNo, i);
          Tv[i] := Vl(FetchElmFNo(RetNo, FedS8FNo, i));
        end;}
        //20260702 Alex <<<
      //20230610
        Strings[1] := FetchElm(RetNo,GetFormNo('AT1'),9);
        Strings[2] := FetchElm(RetNo,GetFormNo('T2'),11);
        Strings[29] := FetchElmFNo(RetNo,FedS8FNo,29);
        SaveTv(RetNo, FName, FNo);  //20260717 Alex
        //EXIT; //20260717 Alex
      end; // count
    end; // 'Y'
  end; // with



  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 1, 2); // 20190626
    DaysInTaxYear := Ret[RetNo].DaysInYear;
    If DaysInTaxYear > 365 then DaysInTaxYear := 365;

    S8FNo := GetFormNo('S8#1'); // 20220826
    FInst := ExtractFormInst(FName);

    If Strings[4] + Strings[5] = '' then
      Strings[5] := 'X';
    If Strings[216] = '' then
      Strings[216] := 'N'; // 20221107
    If Strings[217] = '' then
      Strings[217] := 'Y';

    // INIT Totals //20190614
    i := 530;
    z := 0;
    Repeat
      if Strings[i - 2] = '' then
        Strings[i - 1] := ''; // 20230309
      z := z + Vl(Strings[i]);
      Inc(i, 3); // 20220912
    Until i > 599;

    Strings[13] := FormatFloat('###.####', z);

    If z > 100 then
      Strings[29] := '0'
    else
    Begin
      y := (Ret[RetNo].DaysInYear / 365) * (1500000 * Vl(Strings[530]) / 100);
      // the first on the list
      Strings[29] := FormatFloat('##,###,###', y);
    end;

    Tv[77] := 0;
    Tv[93] := 0; // DIEP UCC plus ImmeeditateExpensing column //20220730
    Tv[249] := 0;
    Tv[234] := 0;
    Tv[250] := 0;
    Tv[235] := 0;
    Tv[230] := 0;
    Tv[231] := 0;
    Tv[232] := 0;
    Tv[251] := 0;

    for i := 384 to 396 do
      Strings[i] := '';
    // initialize the bottom class numbers, then copy them //20190705
    for i := 515 to 527 do
      Strings[i] := '';
    // initialize the botom class numbers, then copy them //20190705

    for k := 0 to 9{12} do // 12 do //20260717 Alex - 10 rows only
    /// /k is the row being processed starts from k=0 //13 rows per section
    Begin
      // repeate class for each section from Part 2
      Cls := AllTrim(Strings[col1]); // 20190719 //alltrim
      Strings[384 + k * 1] := Cls; // 20190705
      Strings[515 + k * 1] := Cls; // 20220730 //dupl/copy cless

      // Rate := GetCCARate(Cls); // string //20190614  see beloq //20221121
      Rate:= Strings[17 + k * 16]; //20260717 Alex



      //jz//20260804 - seems wrong, is AB different from fed?? adjust when applied but leave mostly for now
      if not populateFromFedS8 then
      begin

        //jz//20260801 - moved from below as AIIP var is used shortly after here and needs to be set -->
        // AIIP indicator//20190621
        // 20190705
        Strings[colAIIP] := '';
        if (Additions > 0) and (Cls > '') then
        Begin
          s := ReplaceChar(AssetInfo, ',', '');
          PurchaseDate := LeftStr(s, 10);
          if (PurchaseDate > '2018/11/20') or (GetTaxationYearStart(RetNo) > '2018/11/20')
          // 20220619 additions made after the Aiip date of 2018
          then
            Strings[colAIIP] := 'X' // then 10.1 is aiip
          Else
            Strings[colAIIP] := ''; // 20190705
        end;

        if (GetTaxationYearEnd(RetNo) > '2027/12/31') then
          Strings[colAIIP] := '';
        // NO AIIP after 2027? Check it then IF ALIVE! //20190704
        If Strings[colAIIP] > '' then
          Aiip := True
        else
          Aiip := False; // 20190614

        if Cls = '56' then
        Begin
          Aiip := False;
          Strings[colAIIP] := '';
        end; // 20220531

        // <-- jz//20260801 - moved from below as AIIP var is used shortly after here and needs to be set

      end;

      //jz//20260804
      if Strings[colAIIP] = 'X' then Aiip := TRUE else Aiip := False;

      // set up override indicatore
      If UpperCase(Strings[14 + k * 16]) = 'O' then
        Strings[14 + k * 16] := 'Y'; // override
      If UpperCase(Strings[15 + k * 16]) = 'H' then
        Strings[15 + k * 16] := 'Y'; // half year

      if AIIP=True then
        Strings[15 + k * 16] := 'N'; // half year

      if Vl(Rate) = 100 then
        Strings[15 + k * 16] := 'N';
      // 20190614 No half year rule for fast write off //20190614
      If UpperCase(Strings[16 + k * 16]) = 'T' then
        Strings[16 + k * 16] := 'Y'; // Term loss
      If UpperCase(Strings[14 + k * 16]) = 'X' then
        Strings[14 + k * 16] := 'Y'; // override
      If UpperCase(Strings[15 + k * 16]) = 'X' then
        Strings[15 + k * 16] := 'Y'; // half year
      If UpperCase(Strings[16 + k * 16]) = 'X' then
        Strings[16 + k * 16] := 'Y'; // Term loss

      // 20221121 from further below
      OverrideIndic := UpperCase(Strings[14 + k * 16]);
      HalfYearIndic := UpperCase(Strings[15 + k * 16]);
      TermLossIndic := UpperCase(Strings[16 + k * 16]);

      // Rate := GetCCARate(Cls); //20221121
      //20260717 Alex >>>
      {If Strings[489 + k * 1] <> 'Y' then // override rate
        Strings[17 + k * 16] := GetCCARate(Cls); // 20221121
      Rate := Strings[17 + k * 16];}
      //20260717 Alex <<<

      OriginalCost := Tv[371 + k * 1];
      AssetInfo := Strings[colPurchaseDate];
      // calculate each Column mow
      UccStart  := Tv[col2]; // col2
      Additions := Tv[col3]; // col3
      if DiepClass(Cls) = False then
        Tv[col4] := 0; // 20221115 //Tv[col2 + k * 16] := 0; // 20221107
      if DiepClass(Cls) = False then
        Tv[col9] := 0; // 20221015
      if Strings[216] = '' then
        Strings[216] := 'Y';
      // if DiepClass(Cls) = False then Tv[col11 + k * 1] := 0; // 20221015

      Adjustments := Tv[col5]; // cpl 5

      // if UpperCase(Strings[216])='Y' then Tv[col11+k*1]:=Tv[col5 + k * 1]; //20221108
      // if Tv[col11+k*1]>Tv[col5 + k * 1] then Tv[col5 + k * 1]:=Tv[col5 + k * 1]; //20221108

      // DiepUcc := Tv[col11 + k * 1]; // 20220826 //20221107
      Tv[77] := Tv[77] + Tv[col11];
      ImmediateExpensing := Tv[col12]; // 20220826
      Tv[93] := Tv[93] + ImmediateExpensing;

      // move down
      // Tv[col8+k*16]:=MaxR(0,Tv[col8+k*16]);  //20220621
      // Proceeds:=Tv[col8+k*16];

      if (LeaseHold(Cls)) and (UccStart > 0) Then
      begin
        { //20220913
          Additions := 0;
          Tv[col3 + k * 16] := 0;
        }
      end; // do not allow additions to 13 //20190705
      // 20190809  accept yyymmdd in case they entered yyyy/mm/dd
      If (Cls > '') then
      begin
        if Not LeaseHold(Cls) then
        Begin
          // replace yyymmdd with yyy/mm/dd for date
          s := LeftStr(Strings[colPurchaseDate], 8);
          if (Length(s) = 8) and (Numeric(s)) then
            Strings[colPurchaseDate] := LeftStr(s, 4) + '/' + MidStr(s, 6, 2) + '/'
              + RightStr(s, 2);
        End
        Else // leasehold //cls='13')
        Begin
          s := Strings[colPurchaseDate];
          s := RemoveChar(s, '/');
          s := RemoveChar(s, '-');
          s := LeftStr(s, 16);
          if (Length(s) = 16) and (Numeric(s)) then
          Begin
            S1 := LeftStr(s, 8); // from date
            S1 := LeftStr(S1, 4) + '/' + MidStr(S1, 5, 2) + '/' +
              RightStr(S1, 2);
            S2 := RightStr(s, 8); // to date
            S2 := LeftStr(S2, 4) + '/' + MidStr(S2, 5, 2) + '/' +
              RightStr(S2, 2);
            Strings[colPurchaseDate] := S1 + '-' + S2;
          End;
        End;
      end; // cls>''

      //jz//20260801 - move to above as AIIP var is used there for half year -->
      {
      {
      // AIIP indicator//20190621
      // 20190705
      Strings[colAIIP] := '';
      if (Additions > 0) and (Cls > '') then
      Begin
        s := ReplaceChar(AssetInfo, ',', '');
        PurchaseDate := LeftStr(s, 10);
        if (PurchaseDate > '2018/11/20') or
          (GetTaxationYearStart(RetNo) > '2018/11/20')
        // 20220619 additions made after the Aiip date of 2018
        then
          Strings[colAIIP] := 'X' // then 10.1 is aiip
        Else
          Strings[colAIIP] := ''; // 20190705
      end;

      if (GetTaxationYearEnd(RetNo) > '2027/12/31') then
        Strings[colAIIP] := '';
      // NO AIIP after 2027? Check it then IF ALIVE! //20190704
      If Strings[colAIIP] > '' then
        Aiip := True
      else
        Aiip := False; // 20190614
      if Cls = '56' then
      Begin
        Aiip := False;
        Strings[colAIIP] := '';
      end; // 20220531
      }
      // <-- jz//20260801 - move to above as AIIP var is used there for half year


      // 20190607  Override section elms starting 14, 15, 16
      if (Aiip = False) and (Cls > '') then
      Begin
        If Strings[15 + k * 16] = '' then
          Strings[15 + k * 16] := 'Y'; // 20190605 half yer rule by default
      End;

      if Aiip = True then
        Strings[15 + k * 16] := ''; // 20190614 in O-H-T
      If (Cls = '24') or (Cls = '27') or (Cls = '29') or (Cls = '34') then
        Strings[15 + k * 16] := ''; // fast write off NO half year rule
      { //20221121
        OverrideIndic := UpperCase(Strings[14 + k * 16]);
        HalfYearIndic := UpperCase(Strings[15 + k * 16]);
        TermLossIndic := UpperCase(Strings[16 + k * 16]);
      }

      // If UpperCase(OverrideIndic) <> 'Y' then Rate := GetCCARate(Cls); //20221121 see in beginning

      // Inpout validations
      if Cls = '10.1' then // 20190622
      Begin
        if PurchaseDate < GetTaxationYearStart(RetNo) then
          Tv[col3] := 0; // no additions allowed
      End;

      If (Aiip = False) and (Cls <> '56') then
        Tv[col14] := 0; // // 20220531 aiip portion of col 3

      AdditionsAiip := Tv[col14];
      // assistance part of col 5
      // If Tv[265+k*1]>Tv[9+k*16] then Tv[265+k*1]:=Tv[9+k*16];  //20220621
      Tv[col6] := MaxR(0, Tv[col6]); // col6 //20220621
      AssistanceReceived := Tv[col6];
      Tv[col7] := MaxR(0, Tv[col7]); // col 7 //20220621
      RepaidAmount := Tv[col7 * 1]; // col7
      Tv[col8] := MaxR(0, Tv[col8]);
      // 20220621  //from aboeve //20220731
      // Proceeds:=Tv[col8+k*16];  //20220731


      //jz//20260804 - dont solve for factor if is brought from s8
      if populateFromFedS8 then
      begin
        // aiip  related
        If Aiip = False then
        Begin
          Tv[col16] := 0;
          Tv[col17] := 0;
          Tv[colRelFactor] := 0;
          Tv[col18] := 0;
          Tv[col19] := 0;
        End;
        if Aiip = True then // 20190705
        Begin
          // fast write off //20190608
          if (Cls = '24') or (Cls = '27') or (Cls = '29') or (Cls = '34') then
          Begin
            Tv[col3] := 0; // additions
          End;
          // 20210328
          // Aiipfactor
          Aiipfactor := '';
          Strings[colRelFactor] := '';
          // if Cls = '' then Aiipfactor := ''; // 20190622
          if (Cls = '') or (Aiip = False) then
            Aiipfactor := ''; // default //20220801

          if Cls = '43.1' then
            Aiipfactor := '2.33333'
          Else if Cls = '43.2' then
            Aiipfactor := '1'
          Else if Cls = '53' then
            Aiipfactor := '1'
          Else if (Cls = '54') then
          Begin
            if Strings[colPurchaseDate] > '2019/03/18' then
            begin
              Strings[colAIIP] := 'X';
              Aiipfactor := '2.33333333';
            end
            Else If Strings[colPurchaseDate] > '2018/11/20' then
            begin
              Strings[colAIIP] := 'X';
              Aiipfactor := '0.5';
            end;
          End // aiip true
          Else if (Cls = '55') and (Strings[colPurchaseDate] > '2019/03/18') then
            Aiipfactor := '1.5'
          Else if (Cls = '56') then
            Aiipfactor := '2.333331' // 20210927
          Else if (Cls = '12') or (LeaseHold(Cls)) or (Cls = '14') or (Cls = '15')
          then
            Aiipfactor := '' // 20190806
          Else
            Aiipfactor := '0.5';
        End;

        Strings[colRelFactor] := Aiipfactor; //20260717 Alex
      end;


      ProceedsAiip := Tv[col16];

      HalfRuleAmount := 0;
      UCC := 0;
      UCCReduced := 0;
      Recapture := 0;
      TerminalLoss := 0;

      // get lease and orinal cost from decr box
      If LeaseHold(Cls) then // if Cls='13' then
      begin
        LeaseTerm := 5; // Default;
        // for class 13: 1234567890-1234567890
        s := ReplaceChar(AssetInfo, ',', '');
        LeaseStart := LeftStr(s, 10);
        LeaseEnd := MidStr(s, 12, 10);
        if (Length(LeaseStart) <> 10) or (Length(LeaseEnd) <> 10) then
          LeaseTerm := 0
        Else
        begin
          LeaseTerm := DateDiffYMD(LeaseStart, LeaseEnd) div 365;
          If (LeaseTerm > 0) and (LeaseTerm < 5) then
            LeaseTerm := 5;
        End;
        LeaseMaxCca := OriginalCost / LeaseTerm; // 20190611
        //20260717 Alex >>>
        {Rate := FormatFloat('####.##', 100 / LeaseTerm); // 20190601
        Strings[col20] := Rate;}
        //20260717 Alex <<<
        // if rate='INF' then ShowMessage('inf rate');

        // end;
      end;

      if Cls = '' then
      begin
        UCC := 0;
        HalfRuleAmount := 0;
        UCCReduced := 0;
        Recapture := 0;
        TerminalLoss := 0;
        CCA := 0;
        UCCEnd := 0;
      end;

      UCC := UccStart + Additions + Adjustments - AssistanceReceived +
        RepaidAmount - Proceeds; // 20190606pm
      if (Cls = '10.1') and (Proceeds > 0) then
        UCC := UccStart + Additions + Adjustments - AssistanceReceived +
          RepaidAmount; // 20190820 Get the CCA on disposal

      If LeaseHold(Cls) then // if cls='13' then //20190611
      Begin
        LeaseAdjustedCost := OriginalCost - UccStart + Additions + Adjustments -
          AssistanceReceived + RepaidAmount;
        UCCReduced := UccStart + Additions + Adjustments - AssistanceReceived +
          RepaidAmount;
      End;

      If Aiip=True then HalfYearIndic:='N'; //20260705

      if Aiip = False then // 20190706
      Begin
        if UpperCase(HalfYearIndic) = 'Y' then
        /// /20190605
        begin
          if UpperCase(OverrideIndic) <> 'Y' then // 20190605
          begin
            HalfRuleAmount :=
              MaxR(0, 0.5 * (Additions - AssistanceReceived + RepaidAmount -
              Proceeds));
            if LeaseHold(Cls) then
              HalfRuleAmount := MaxR(0, 0.5 * (Additions - Proceeds));
            // 20190613
            HalfRuleAmount := RoundCorrect(HalfRuleAmount);
          end;
        end
        else
          HalfRuleAmount := 0;


        // from below  //20220619
        if (Cls = '12') OR (Cls = '52') Or (Cls = '24') or (Cls = '27') or
          (Cls = '29') or (Cls = '34') // fast write off //20190622
        then
          UccAdjustmentNONAiip := 0; // 20190622
        UCCReduced := UCC - HalfRuleAmount;
        if LeaseHold(Cls) then
          UCCReduced := UCC; // 20190611
        ProceedsAiip := 0;
        NetCapCostAdditionsAiip := 0;
        UccAdjustmentAiip := 0;
      end // 20220619
      Else // If (Aiip=True) then
      Begin
        HalfRuleAmount := 0; // 20190608
        // 20190707
        ProceedsAiip := MaxR(0, Proceeds + AssistanceReceived - Additions +
          AdditionsAiip - RepaidAmount);
        NetCapCostAdditionsAiip := MaxR(0, AdditionsAiip - ProceedsAiip);
        if (Cls = '10.1') and (Proceeds > 0) then
          NetCapCostAdditionsAiip := AdditionsAiip;

        UccAdjustmentAiip := NetCapCostAdditionsAiip * Vl(Aiipfactor);
        UccAdjustmentNONAiip :=
          MaxR(0, 0.5 * (Additions - AdditionsAiip - AssistanceReceived +
          RepaidAmount - Proceeds)); // 20190622 moved from below

        if (Cls = '12') OR (Cls = '52') Or (Cls = '24') or (Cls = '27') or
          (Cls = '29') or (Cls = '34') then
          UccAdjustmentNONAiip := 0; // 20190622  //fast write off //20190622
      End; // 20220619
      // put amounts on the S8 form
      Tv[12 + k * 16] := HalfRuleAmount; // ???
      if Aiip then
        Tv[12 + k * 16] := 0; // remove half ruleamount

      // Col2
      Tv[249] := Tv[249] + Tv[col2];

      // Col3
      Tv[234] := Tv[234] + Tv[col3];

      // Col4
      if Tv[col4] > Tv[col3] then
        Tv[col4] := Tv[col3];
      Tv[250]:= Tv[250] + Tv[col5]; //20260717 Alex
      // Col8                                 -
      Tv[235] := Tv[235] + Tv[col8];
      // col9  user inout
      if Tv[col9] > Tv[col8] then
        Tv[col9] := Tv[col8];
      // col10
      //if Aiip = True then //20260720 Alex
      //  Tv[col10]:= 0 //20260720 Alex
      //else //20260720 Alex
      Tv[col10] := Tv[col2] + Tv[col3] +
        Tv[col5] - Tv[col8];

      // col11                    **
      if UpperCase(Strings[216]) = 'Y' then
        Tv[col11] := Tv[col4]; // 20221108
      if Tv[col11] > Tv[col4] then
        Tv[col11] := Tv[col4]; // 20221108

      Tv[77]:= Tv[77] + Tv[col11]; //20260717 Alex

      // col12 //semi automatic  //20220827 imm expensing amount = designated
      If UpperCase(Ret[RetNo].Frm[FNo].Strings[217]) = 'Y' then
      // autofill col 12
      Begin
        If (Tv[col4] > 0) and (Tv[col12] = 0) then
          Tv[col12] := Tv[col4]; // 20221017
      end;

      if Tv[col12] > Tv[col4] then
        Tv[col12] := Tv[col11];
      if Ret[RetNo].CorpType <> CCPC then
        Tv[col12] := 0; // 20221115

      // col13
      //if Aiip = True then //20260720 Alex
      //  Tv[col13]:= 0 //20260720 Alex
      //else  //20260720 Alex
      Tv[col13] := MaxR(0, Tv[col3] - Tv[col4] +
        Tv[col11] - Tv[col12]); // 20220912 MaxR

      Tv[93]:= Tv[93] + Tv[col13]; //20260717 Alex

      // col14 //jz//20260804 - had it backwards, if AIIP then add to column, make vtCalc
      if Aiip = True then
      begin
        Tv[col14] := MaxR(0, Tv[col13]); //20260717 Alex
      end
      else //20260717 Alex
        Tv[col14] := 0; //20260717 Alex

      //else //20260717 Alex
        //Tv[col14] := 0; //20260717 Alex
      // col15
      Tv[col15] := MaxR(0, Tv[col10] - Tv[col12]);
      // col16

      xx:=Tv[col8];
      xx:=Tv[col9];
      xx:=Tv[col6];
      xx:=Tv[col13];
      xx:=Tv[col14];
      xx:=Tv[col7] ;

      if Aiip = True then
        Tv[col16] := MaxR(0, Tv[col8] - Tv[col9] + Tv[col6] - Tv[col13] + Tv[col14] - Tv[col7]) // ? 54 and 56?
      else
        Tv[col16] := 0;
      // col17
      if Aiip = True then
        Tv[col17] := MaxR(0, Tv[col14] - Tv[col16])
        // ? 54 and 56?
      else
        Tv[col17] := 0;

      if Cls = '' then
      begin
        Aiipfactor := '';
        Strings[colRelFactor] := ''; // aiip factor
      end;


      xx:=Tv[col17];
      xx:=Vl(Strings[colRelFactor]);

      // col18
      if Aiip = True then //20260717 Alex
        Tv[col18] := Tv[col17] * FractionToReal(Strings[colRelFactor])//;//20260717 Alex
      else  //20260717 Alex
        Tv[col18]:= 0; //20260717 Alex
      // //? 54 and 56?

      // col19
      if Aiip = True then //20260717 Alex
      //Tv[col19] := MaxR(0, Tv[col13] - Tv[col14] - //20260720 Alex
      //  Tv[col6] - Tv[col17])//; // ? 54 and 56?  //20260720 Alex
        Tv[col19]:= MaxR(0, (Tv[col13] - Tv[col14] - Tv[col6] +  Tv[col7] -  Tv[col8] + Tv[col9]) * 0.5) //20260720 Alex
      else  //20260717 Alex
        Tv[col19]:= 0; //20260717 Alex

      // col20
      //Strings[col20] := Rate; //20260717 Alex
      // if Strings[Col20+K*16]='INF' then Strings[col20*k*16] := ''; //20220912
      // col21 recapture
      //20260717 Alex >>>
      If populateFromFedS8 then
      begin
        Tv[col21] := 0;
        if Tv[col10] < 0 then
          Tv[col21] := Abs(Tv[col10]);

        if (Cls = '10.1') then
          Tv[col21] := 0; // 20230516
      end;
      Tv[230]:= Tv[230] + Tv[col21];

      // col22 Terminal loss
      If populateFromFedS8 then
      begin
        Tv[col22] := 0;
        if (UpperCase(Strings[16]) = 'Y') and (Tv[col10] > 0)
        then
          Tv[col22] := Tv[col10];
        if (Cls = '10.1') then
          Tv[col22] := 0; // 20230516
      end;
      Tv[231] := Tv[231] + Tv[col22];
      //20260717 Alex <<<

      // col23 CCA
      If (Cls = '24') or (Cls = '27') or (Cls = '29') or (Cls = '34') then
      //20260717 Alex >>>
      begin
        Rate := '100'; // fast write off //20220802
        Strings[col20]:= Rate; //20260717 Alex
      end;
      //20260717 Alex <<<

      // There is CCA
      If (Tv[col21] = 0) and (Tv[col22] = 0) then
      // RGRE IS CCA (No Term loss =0 andRecpt=0 )
      begin // normal no gtterminal loss or  recapture
        if UpperCase(Strings[14]) <> 'Y' then // no override);
        Begin
          Tv[col23] := (Tv[col15] + Tv[col18] -
            Tv[col19]) * Vl(Rate) / 100 + Tv[col12];
          CCA := Tv[col23]; // 20230322
          if Ret[RetNo].DaysInYear < 365 then
          Begin
            CCA := CCA * Ret[RetNo].DaysInYear / 365;
            Tv[col23] := CCA;
          End;
        End;
      end
      Else // case: recapture  or Term loss>0 //20230512
      begin
        CCA := 0;

        Tv[col23] := 0; // if recapture or term loss then CCA =0
        // proration:?
        if Ret[RetNo].DaysInYear < 365 then
        Begin
          // Tv[col21]:=Tv[col21]/ 365;  //recapture
          // Tv[col22]:=Tv[col22] / 365; //terminal loss
        End;
      end;

      Tv[232] := Tv[232] + Tv[col23];

      if UpperCase(Strings[16 + k * 16]) = 'Y' // term loss
      then
        Tv[col24] := 0 // no UCC end eny more
      Else
        Tv[col24] := MaxR(0, Tv[col10] - Tv[col23]);

      Tv[251] := Tv[251] + Tv[col24];


      //jz//20260804

      inc(colPurchaseDate, colPurchasedateInc);
      inc(colAIIP,         colAIIPInc);
      inc(colRelFactor,    colRelFactorInc);

      inc(col1,  col1inc);
      inc(col2,  col2inc);
      inc(col3,  col3inc);
      inc(col4,  col4inc);
      inc(col5,  col5inc);
      inc(col6,  col6inc);
      inc(col7,  col7inc);
      inc(col8,  col8inc);
      inc(col9,  col9inc);
      inc(col10, col10inc);
      inc(col11, col11inc);
      inc(col12, col12inc);
      inc(col13, col13inc);
      inc(col14, col14inc);
      inc(col15, col15inc);
      inc(col16, col16inc);
      inc(col17, col17inc);
      inc(col18, col18inc);
      inc(col19, col19inc);
      inc(col20, col20inc);
      inc(col21, col21inc);
      inc(col22, col22inc);
      inc(col23, col23inc);
      inc(col24, col24inc);

    End; // k 0 to 12  //k is the wow bing processed starts from k=0

  End; // with?
  SaveTv(RetNo, FName, FNo);
end;
*)



(*
procedure AS13(RetNo: Integer; FName: string; FNo: Integer);
// columns first row index
Const
  col1 = 6;
  col2 = 7;
  col3 = 8;
  col4 = 463;
  col5 = 9;
  col6 = 265;
  col7 = 278;
  col8 = 10;
  col9 = 400;
  col10 = 11;
  col11 = 424;
  col12 = 437;
  col13 = 450;
  col14 = 252;
  col15 = 476;
  col16 = 291;
  col17 = 304;
  col18 = 317;
  col19 = 330;
  col20 = 17;
  col21 = 18;
  col22 = 19;
  col23 = 20;
  col24 = 21;

Var
  i, k, k1, j, w: Integer; //20260703 Alex
  OrigCostNdx, OrigCostS8Ndx:Integer;  //20260716cz

  FInst: String;
  S8FNo: Integer;
  Cls, s, S1, S2: String;
  TotColumn4: Real;
  OriginalCost: Real;
  UccStart, Additions, Adjustments, Proceeds, UCC, HalfRuleAmount,
    UCCReduced: Real;

  ImmediateExpensing: Real; // 20220730

  OverrideIndic, HalfYearIndic, TermLossIndic: String;
  Rate: String;
  Recapture, TerminalLoss, CCA, UCCEnd, z: Real;
  DaysInTaxYear: Integer; // > 365 then DaysInTaxYear := 365;
  // cls 13 relted
  AssetInfo: String;
  // additional fields after aiip
  Aiip: Boolean;
  AdditionsAiip, AssistanceReceived, RepaidAmount, ProceedsAiip,
    NetCapCostAdditionsAiip, UccAdjustmentAiip, UccAdjustmentNONAiip: Real;
  Aiipfactor: String;

  OverrideBox, HalfRuleBox, TerminalLossBox: String;
  HalfYearAmount: Real;

  LeaseStart, LeaseEnd: string;
  LeaseTerm: Real;
  LeaseAdjustedCost: Real; // RemainingLeaseTerm:Real;
  PurchaseDate: String;
  LeaseMaxCca: Real;
  x: Real;
  y: Real;

  FedS8FNo: Integer;
  lCol15factor: Integer; //20260717 Alex
  lCol16factor: Integer; //20260717 Alex
  lColRelFactor: Integer; //20260717 Alex
begin

  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    //20260628
    If (Ret[RetNo].Province = 'AB')
    or (Vl(FetchElm(RetNo, 'S5', 197))>0) then  //has AB income   //20260725
    //continue
    else
    begin
     For i:=1 to 524{488} do begin Strings[i]:='';Tv[i]:=0;End; //20260717 Alex
     //does not work?  ClearForm(RetNo,FName);
     SaveTv(RetNo,FName,FNo);
     exit;
    end;

    If Strings[3] = '' then Strings[3] := 'N'; // instead of 13  //20120201

    If UpperCase(Strings[3]) <> 'Y' then { copy from fed }
    begin
      FedS8FNo := GetFormNo('S8' + FInst);
      If (FedS8FNo > 0) and (Ret[RetNo].Frm[FedS8FNo].Count > 0) then
      Begin
        //20260702 Alex >>>  i= Alb  j:S8
        i:= 6; //AS13
        j:= 6; //S8
        k:= 384;
        w:= 293; //20260703 Alex
        k1:= 356; //20260703 Alex  ..aiip am propertype
        OrigCostNdx:=371; //by 1
        OrigCostS8Ndx:=313;
        lCol15factor:= 263; //20260717 Alex
        lCol16factor:= 253; //20260717 Alex
        lColRelFactor:= 343; //20260717 Alex

        repeat
          //Col 200 and 001
          Strings[i]:= FetchElmFNo(RetNo, FedS8FNo, j);
          Tv[i]:= Vl(FetchElmFNo(RetNo, FedS8FNo, j));
          Strings[k]:= FetchElmFNo(RetNo, FedS8FNo, j);
          Tv[k]:= Vl(FetchElmFNo(RetNo, FedS8FNo, j));
          Tv[OrigCostNdx]:=Vl(FetchElmFNo(RetNo, FedS8FNo, OrigCostS8Ndx));
          //Col 201 and 003
          Strings[i + 1]:= FetchElmFNo(RetNo, FedS8FNo, j + 1);
          Tv[i + 1]:= Vl(FetchElmFNo(RetNo, FedS8FNo, j + 1));
          //Col 203 and 005
          Strings[i + 2]:= FetchElmFNo(RetNo, FedS8FNo, j + 2);
          Tv[i + 2]:= Vl(FetchElmFNo(RetNo, FedS8FNo, j + 2));
          //Col 207 and 009
          Strings[i + 4]:= FetchElmFNo(RetNo, FedS8FNo, j + 8);
          Tv[i + 4]:= Vl(FetchElmFNo(RetNo, FedS8FNo, j + 8));
          //20260703 Alex >>>
          //Col AIIP
          //20260705cz
          If FetchElmFNo(RetNo, FedS8FNo, w)='AIIP' then
            Strings[k1]:='X'  //20260721CZ
          Else
            Strings[k1]:='';   //20260717
          //Strings[k1]:= FetchElmFNo(RetNo, FedS8FNo, w);
          //20260703 Alex <<<
          //20260717 Alex >>>
          //Col 212 in S8 and 013 (col 20) in AS13. Copy rate from S8
          Strings[i + 11]:= FetchElmFNo(RetNo, FedS8FNo, j + 17);

          //Relevant factor
          if (Vl(FetchElmFNo(RetNo, FedS8FNo, lCol15factor)) > 0) then Strings[lColRelFactor]:= FetchElmFNo(RetNo, FedS8FNo, lCol15factor) else
          if (Vl(FetchElmFNo(RetNo, FedS8FNo, lCol16factor)) > 0) then Strings[lColRelFactor]:= FetchElmFNo(RetNo, FedS8FNo, lCol16factor) else Strings[lColRelFactor]:= '0';

          //Recapture of CCA
          Tv[i + 12]:= Vl(FetchElmFNo(RetNo, FedS8FNo, j + 18));

          //Term loss
          Tv[i + 13]:= Vl(FetchElmFNo(RetNo, FedS8FNo, j + 19));
          //20260717 Alex <<<

          inc(i, 16);
          inc(j, 22);
          inc(k, 1);
          inc(k1, 1); //20260703 Alex
          inc(w, 1); //20260703 Alex
          inc(lCol15factor, 1); //20260717 Alex
          inc(lCol16factor, 1); //20260717 Alex
          inc(lColRelFactor, 1); //20260717 Alex
          //20260718
          Inc(OrigCostNdx,1);
          Inc(OrigCostS8Ndx,1);
        until (i > 204);

        {for i := 6 to 396 do // 232 do
        begin
          Strings[i] := FetchElmFNo(RetNo, FedS8FNo, i);
          Tv[i] := Vl(FetchElmFNo(RetNo, FedS8FNo, i));
        end;}
        //20260702 Alex <<<
      //20230610
        Strings[1] := FetchElm(RetNo,GetFormNo('AT1'),9);
        Strings[2] := FetchElm(RetNo,GetFormNo('T2'),11);
        Strings[29] := FetchElmFNo(RetNo,FedS8FNo,29);
        SaveTv(RetNo, FName, FNo);  //20260717 Alex
        //EXIT; //20260717 Alex
      end; // count
    end; // 'Y'
  end; // with

  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 1, 2); // 20190626
    DaysInTaxYear := Ret[RetNo].DaysInYear;
    If DaysInTaxYear > 365 then DaysInTaxYear := 365;

    S8FNo := GetFormNo('S8#1'); // 20220826
    FInst := ExtractFormInst(FName);

    If Strings[4] + Strings[5] = '' then
      Strings[5] := 'X';
    If Strings[216] = '' then
      Strings[216] := 'N'; // 20221107
    If Strings[217] = '' then
      Strings[217] := 'Y';


    // INIT Totals //20190614
    i := 530;
    z := 0;
    Repeat
      if Strings[i - 2] = '' then
        Strings[i - 1] := ''; // 20230309
      z := z + Vl(Strings[i]);
      Inc(i, 3); // 20220912
    Until i > 599;
    Strings[13] := FormatFloat('###.####', z);

    If z > 100 then
      Strings[29] := '0'
    else
    Begin
      y := (Ret[RetNo].DaysInYear / 365) * (1500000 * Vl(Strings[530]) / 100);
      // the first on the list
      Strings[29] := FormatFloat('##,###,###', y);
    end;

    Tv[77] := 0;
    Tv[93] := 0; // DIEP UCC plus ImmeeditateExpensing column //20220730
    Tv[249] := 0;
    Tv[234] := 0;
    Tv[250] := 0;
    Tv[235] := 0;
    Tv[230] := 0;
    Tv[231] := 0;
    Tv[232] := 0;
    Tv[251] := 0;

    for i := 384 to 396 do
      Strings[i] := '';
    // initialize the bottom class numbers, then copy them //20190705
    for i := 515 to 527 do
      Strings[i] := '';
    // initialize the botom class numbers, then copy them //20190705
    for k := 0 to 9{12} do // 12 do //20260717 Alex - 10 rows only
    /// /k is the row being processed starts from k=0 //13 rows per section
    Begin
      // repeate class for each section from Part 2
      Cls := AllTrim(Strings[col1 + k * 16]); // 20190719 //alltrim
      Strings[384 + k * 1] := Cls; // 20190705
      Strings[515 + k * 1] := Cls; // 20220730 //dupl/copy cless

      // Rate := GetCCARate(Cls); // string //20190614  see beloq //20221121
      Rate:= Strings[17 + k * 16]; //20260717 Alex


      //jz//20260801 - moved from below as AIIP var is used shortly after here and needs to be set -->
      // AIIP indicator//20190621
      // 20190705
      Strings[356 + k * 1] := '';
      if (Additions > 0) and (Cls > '') then
      Begin
        s := ReplaceChar(AssetInfo, ',', '');
        PurchaseDate := LeftStr(s, 10);
        if (PurchaseDate > '2018/11/20') or
          (GetTaxationYearStart(RetNo) > '2018/11/20')
        // 20220619 additions made after the Aiip date of 2018
        then
          Strings[356 + k * 1] := 'X' // then 10.1 is aiip
        Else
          Strings[356 + k * 1] := ''; // 20190705
      end;

      if (GetTaxationYearEnd(RetNo) > '2027/12/31') then
        Strings[356 + k * 1] := '';
      // NO AIIP after 2027? Check it then IF ALIVE! //20190704
      If Strings[356 + k * 1] > '' then
        Aiip := True
      else
        Aiip := False; // 20190614
      if Cls = '56' then
      Begin
        Aiip := False;
        Strings[356 + k * 1] := '';
      end; // 20220531
      // <-- jz//20260801 - moved from below as AIIP var is used shortly after here and needs to be set


      // set up override indicatore
      If UpperCase(Strings[14 + k * 16]) = 'O' then
        Strings[14 + k * 16] := 'Y'; // override
      If UpperCase(Strings[15 + k * 16]) = 'H' then
        Strings[15 + k * 16] := 'Y'; // half year

      if AIIP=True then
        Strings[15 + k * 16] := 'N'; // half year

      if Vl(Rate) = 100 then
        Strings[15 + k * 16] := 'N';
      // 20190614 No half year rule for fast write off //20190614
      If UpperCase(Strings[16 + k * 16]) = 'T' then
        Strings[16 + k * 16] := 'Y'; // Term loss
      If UpperCase(Strings[14 + k * 16]) = 'X' then
        Strings[14 + k * 16] := 'Y'; // override
      If UpperCase(Strings[15 + k * 16]) = 'X' then
        Strings[15 + k * 16] := 'Y'; // half year
      If UpperCase(Strings[16 + k * 16]) = 'X' then
        Strings[16 + k * 16] := 'Y'; // Term loss

      // 20221121 from further below
      OverrideIndic := UpperCase(Strings[14 + k * 16]);
      HalfYearIndic := UpperCase(Strings[15 + k * 16]);
      TermLossIndic := UpperCase(Strings[16 + k * 16]);

      // Rate := GetCCARate(Cls); //20221121
      //20260717 Alex >>>
      {If Strings[489 + k * 1] <> 'Y' then // override rate
        Strings[17 + k * 16] := GetCCARate(Cls); // 20221121
      Rate := Strings[17 + k * 16];}
      //20260717 Alex <<<

      OriginalCost := Tv[371 + k * 1];
      AssetInfo := Strings[236 + k * 1];
      // calculate each Column mow
      UccStart := Tv[col2 + k * 16]; // col2
      Additions := Tv[col3 + k * 16]; // col3
      if DiepClass(Cls) = False then
        Tv[col4 + k * 1] := 0; // 20221115 //Tv[col2 + k * 16] := 0; // 20221107
      if DiepClass(Cls) = False then
        Tv[col9 + k * 1] := 0; // 20221015
      if Strings[216] = '' then
        Strings[216] := 'Y';
      // if DiepClass(Cls) = False then Tv[col11 + k * 1] := 0; // 20221015

      Adjustments := Tv[col5 + k * 16]; // cpl 5

      // if UpperCase(Strings[216])='Y' then Tv[col11+k*1]:=Tv[col5 + k * 1]; //20221108
      // if Tv[col11+k*1]>Tv[col5 + k * 1] then Tv[col5 + k * 1]:=Tv[col5 + k * 1]; //20221108

      // DiepUcc := Tv[col11 + k * 1]; // 20220826 //20221107
      Tv[77] := Tv[77] + Tv[col11 + k * 1];
      ImmediateExpensing := Tv[col12 + k * 1]; // 20220826
      Tv[93] := Tv[93] + ImmediateExpensing;

      // move down
      // Tv[col8+k*16]:=MaxR(0,Tv[col8+k*16]);  //20220621
      // Proceeds:=Tv[col8+k*16];

      if (LeaseHold(Cls)) and (UccStart > 0) Then
      begin
        { //20220913
          Additions := 0;
          Tv[col3 + k * 16] := 0;
        }
      end; // do not allow additions to 13 //20190705
      // 20190809  accept yyymmdd in case they entered yyyy/mm/dd
      If (Cls > '') then
      begin
        if Not LeaseHold(Cls) then
        Begin
          // replace yyymmdd with yyy/mm/dd for date
          s := LeftStr(Strings[236 + k * 1], 8);
          if (Length(s) = 8) and (Numeric(s)) then
            Strings[236 + k * 1] := LeftStr(s, 4) + '/' + MidStr(s, 6, 2) + '/'
              + RightStr(s, 2);
        End
        Else // leasehold //cls='13')
        Begin
          s := Strings[236 + k * 1];
          s := RemoveChar(s, '/');
          s := RemoveChar(s, '-');
          s := LeftStr(s, 16);
          if (Length(s) = 16) and (Numeric(s)) then
          Begin
            S1 := LeftStr(s, 8); // from date
            S1 := LeftStr(S1, 4) + '/' + MidStr(S1, 5, 2) + '/' +
              RightStr(S1, 2);
            S2 := RightStr(s, 8); // to date
            S2 := LeftStr(S2, 4) + '/' + MidStr(S2, 5, 2) + '/' +
              RightStr(S2, 2);
            Strings[236 + k * 1] := S1 + '-' + S2;
          End;
        End;
      end; // cls>''

      //jz//20260801 - move to above as AIIP var is used there for half year -->
      {
      {
      // AIIP indicator//20190621
      // 20190705
      Strings[356 + k * 1] := '';
      if (Additions > 0) and (Cls > '') then
      Begin
        s := ReplaceChar(AssetInfo, ',', '');
        PurchaseDate := LeftStr(s, 10);
        if (PurchaseDate > '2018/11/20') or
          (GetTaxationYearStart(RetNo) > '2018/11/20')
        // 20220619 additions made after the Aiip date of 2018
        then
          Strings[356 + k * 1] := 'X' // then 10.1 is aiip
        Else
          Strings[356 + k * 1] := ''; // 20190705
      end;

      if (GetTaxationYearEnd(RetNo) > '2027/12/31') then
        Strings[356 + k * 1] := '';
      // NO AIIP after 2027? Check it then IF ALIVE! //20190704
      If Strings[356 + k * 1] > '' then
        Aiip := True
      else
        Aiip := False; // 20190614
      if Cls = '56' then
      Begin
        Aiip := False;
        Strings[356 + k * 1] := '';
      end; // 20220531
      }
      // <-- jz//20260801 - move to above as AIIP var is used there for half year


      // 20190607  Override section elms starting 14, 15, 16
      if (Aiip = False) and (Cls > '') then
      Begin
        If Strings[15 + k * 16] = '' then
          Strings[15 + k * 16] := 'Y'; // 20190605 half yer rule by default
      End;

      if Aiip = True then
        Strings[15 + k * 16] := ''; // 20190614 in O-H-T
      If (Cls = '24') or (Cls = '27') or (Cls = '29') or (Cls = '34') then
        Strings[15 + k * 16] := ''; // fast write off NO half year rule
      { //20221121
        OverrideIndic := UpperCase(Strings[14 + k * 16]);
        HalfYearIndic := UpperCase(Strings[15 + k * 16]);
        TermLossIndic := UpperCase(Strings[16 + k * 16]);
      }

      // If UpperCase(OverrideIndic) <> 'Y' then Rate := GetCCARate(Cls); //20221121 see in beginning

      // Inpout validations
      if Cls = '10.1' then // 20190622
      Begin
        if PurchaseDate < GetTaxationYearStart(RetNo) then
          Tv[col3 + k * 16] := 0; // no additions allowed
      End;

      If (Aiip = False) and (Cls <> '56') then
        Tv[col14 + k * 1] := 0; // // 20220531 aiip portion of col 3

      AdditionsAiip := Tv[col14 + k * 1];
      // assistance part of col 5
      // If Tv[265+k*1]>Tv[9+k*16] then Tv[265+k*1]:=Tv[9+k*16];  //20220621
      Tv[col6 + k * 1] := MaxR(0, Tv[col6 + k * 1]); // col6 //20220621
      AssistanceReceived := Tv[col6 + k * 1];
      Tv[col7 + k * 1] := MaxR(0, Tv[col7 + k * 1]); // col 7 //20220621
      RepaidAmount := Tv[col7 * 1]; // col7
      Tv[col8 + k * 16] := MaxR(0, Tv[col8 + k * 16]);
      // 20220621  //from aboeve //20220731
      // Proceeds:=Tv[col8+k*16];  //20220731

      // aiip  related
      If Aiip = False then
      Begin
        Tv[col16 + k * 1] := 0;
        Tv[col17 + k * 1] := 0;
        Tv[343 + k * 1] := 0;
        Tv[col18 + k * 1] := 0;
        Tv[col19 + k * 1] := 0;
      End;
      if Aiip = True then // 20190705
      Begin
        // fast write off //20190608
        if (Cls = '24') or (Cls = '27') or (Cls = '29') or (Cls = '34') then
        Begin
          Tv[col3 + k * 16] := 0; // additions
        End;
        // 20210328
        // Aiipfactor
        Aiipfactor := '';
        Strings[343 + k * 1] := '';
        // if Cls = '' then Aiipfactor := ''; // 20190622
        if (Cls = '') or (Aiip = False) then
          Aiipfactor := ''; // default //20220801

        if Cls = '43.1' then
          Aiipfactor := '2.33333'
        Else if Cls = '43.2' then
          Aiipfactor := '1'
        Else if Cls = '53' then
          Aiipfactor := '1'
        Else if (Cls = '54') then
        Begin
          if Strings[236 + k] > '2019/03/18' then
          begin
            Strings[356 + k] := 'X';
            Aiipfactor := '2.33333333';
          end
          Else If Strings[236 + k] > '2018/11/20' then
          begin
            Strings[356 + k] := 'X';
            Aiipfactor := '0.5';
          end;
        End // aiip true
        Else if (Cls = '55') and (Strings[236 + k] > '2019/03/18') then
          Aiipfactor := '1.5'
        Else if (Cls = '56') then
          Aiipfactor := '2.333331' // 20210927
        Else if (Cls = '12') or (LeaseHold(Cls)) or (Cls = '14') or (Cls = '15')
        then
          Aiipfactor := '' // 20190806
        Else
          Aiipfactor := '0.5';
      End;

      if (UpperCase(Strings[3]) = 'Y') then Strings[343 + k * 1] := Aiipfactor; //20260717 Alex
      ProceedsAiip := Tv[col16 + k * 1];

      HalfRuleAmount := 0;
      UCC := 0;
      UCCReduced := 0;
      Recapture := 0;
      TerminalLoss := 0;

      // get lease and orinal cost from decr box
      If LeaseHold(Cls) then // if Cls='13' then
      begin
        LeaseTerm := 5; // Default;
        // for class 13: 1234567890-1234567890
        s := ReplaceChar(AssetInfo, ',', '');
        LeaseStart := LeftStr(s, 10);
        LeaseEnd := MidStr(s, 12, 10);
        if (Length(LeaseStart) <> 10) or (Length(LeaseEnd) <> 10) then
          LeaseTerm := 0
        Else
        begin
          LeaseTerm := DateDiffYMD(LeaseStart, LeaseEnd) div 365;
          If (LeaseTerm > 0) and (LeaseTerm < 5) then
            LeaseTerm := 5;
        End;
        LeaseMaxCca := OriginalCost / LeaseTerm; // 20190611
        //20260717 Alex >>>
        {Rate := FormatFloat('####.##', 100 / LeaseTerm); // 20190601
        Strings[col20 * k * 16] := Rate;}
        //20260717 Alex <<<
        // if rate='INF' then ShowMessage('inf rate');

        // end;
      end;

      if Cls = '' then
      begin
        UCC := 0;
        HalfRuleAmount := 0;
        UCCReduced := 0;
        Recapture := 0;
        TerminalLoss := 0;
        CCA := 0;
        UCCEnd := 0;
      end;

      UCC := UccStart + Additions + Adjustments - AssistanceReceived +
        RepaidAmount - Proceeds; // 20190606pm
      if (Cls = '10.1') and (Proceeds > 0) then
        UCC := UccStart + Additions + Adjustments - AssistanceReceived +
          RepaidAmount; // 20190820 Get the CCA on disposal

      If LeaseHold(Cls) then // if cls='13' then //20190611
      Begin
        LeaseAdjustedCost := OriginalCost - UccStart + Additions + Adjustments -
          AssistanceReceived + RepaidAmount;
        UCCReduced := UccStart + Additions + Adjustments - AssistanceReceived +
          RepaidAmount;
      End;

      If Aiip=True then HalfYearIndic:='N'; //20260705

      if Aiip = False then // 20190706
      Begin
        if UpperCase(HalfYearIndic) = 'Y' then
        /// /20190605
        begin
          if UpperCase(OverrideIndic) <> 'Y' then // 20190605
          begin
            HalfRuleAmount :=
              MaxR(0, 0.5 * (Additions - AssistanceReceived + RepaidAmount -
              Proceeds));
            if LeaseHold(Cls) then
              HalfRuleAmount := MaxR(0, 0.5 * (Additions - Proceeds));
            // 20190613
            HalfRuleAmount := RoundCorrect(HalfRuleAmount);
          end;
        end
        else
          HalfRuleAmount := 0;


        // from below  //20220619
        if (Cls = '12') OR (Cls = '52') Or (Cls = '24') or (Cls = '27') or
          (Cls = '29') or (Cls = '34') // fast write off //20190622
        then
          UccAdjustmentNONAiip := 0; // 20190622
        UCCReduced := UCC - HalfRuleAmount;
        if LeaseHold(Cls) then
          UCCReduced := UCC; // 20190611
        ProceedsAiip := 0;
        NetCapCostAdditionsAiip := 0;
        UccAdjustmentAiip := 0;
      end // 20220619
      Else // If (Aiip=True) then
      Begin
        HalfRuleAmount := 0; // 20190608
        // 20190707
        ProceedsAiip := MaxR(0, Proceeds + AssistanceReceived - Additions +
          AdditionsAiip - RepaidAmount);
        NetCapCostAdditionsAiip := MaxR(0, AdditionsAiip - ProceedsAiip);
        if (Cls = '10.1') and (Proceeds > 0) then
          NetCapCostAdditionsAiip := AdditionsAiip;

        UccAdjustmentAiip := NetCapCostAdditionsAiip * Vl(Aiipfactor);
        UccAdjustmentNONAiip :=
          MaxR(0, 0.5 * (Additions - AdditionsAiip - AssistanceReceived +
          RepaidAmount - Proceeds)); // 20190622 moved from below

        if (Cls = '12') OR (Cls = '52') Or (Cls = '24') or (Cls = '27') or
          (Cls = '29') or (Cls = '34') then
          UccAdjustmentNONAiip := 0; // 20190622  //fast write off //20190622
      End; // 20220619
      // put amounts on the S8 form
      Tv[12 + k * 16] := HalfRuleAmount; // ???
      if Aiip then
        Tv[12 + k * 16] := 0; // remove half ruleamount

      // Col2
      Tv[249] := Tv[249] + Tv[col2 + k * 16];

      // Col3
      Tv[234] := Tv[234] + Tv[col3 + k * 16];

      // Col4
      if Tv[col4 + k * 1] > Tv[col3 + k * 1] then
        Tv[col4 + k * 1] := Tv[col3 + k * 16];
      Tv[250]:= Tv[250] + Tv[col5 + k * 16]; //20260717 Alex
      // Col8                                 -
      Tv[235] := Tv[235] + Tv[col8 + k * 16];
      // col9  user inout
      if Tv[col9 + k * 1] > Tv[col8 + k * 16] then
        Tv[col9 + k * 1] := Tv[col8 + k * 16];
      // col10
      //if Aiip = True then //20260720 Alex
      //  Tv[col10 + k * 1]:= 0 //20260720 Alex
      //else //20260720 Alex
      Tv[col10 + k * 16] := Tv[col2 + k * 16] + Tv[col3 + k * 16] +
        Tv[col5 + k * 16] - Tv[col8 + k * 16];

      // col11                    **
      if UpperCase(Strings[216]) = 'Y' then
        Tv[col11 + k * 1] := Tv[col4 + k * 1]; // 20221108
      if Tv[col11 + k * 1] > Tv[col4 + k * 1] then
        Tv[col11 + k * 1] := Tv[col4 + k * 1]; // 20221108

      Tv[77]:= Tv[77] + Tv[col11 + k * 16]; //20260717 Alex

      // col12 //semi automatic  //20220827 imm expensing amount = designated
      If UpperCase(Ret[RetNo].Frm[FNo].Strings[217]) = 'Y' then
      // autofill col 12
      Begin
        If (Tv[col4 + k * 1] > 0) and (Tv[col12 + k * 1] = 0) then
          Tv[col12 + k * 1] := Tv[col4 + k * 1]; // 20221017
      end;

      if Tv[col12 + k * 1] > Tv[col4 + k * 1] then
        Tv[col12 + k * 1] := Tv[col11 + k * 1];
      if Ret[RetNo].CorpType <> CCPC then
        Tv[col12 + k * 1] := 0; // 20221115

      // col13
      //if Aiip = True then //20260720 Alex
      //  Tv[col13 + k * 1]:= 0 //20260720 Alex
      //else  //20260720 Alex
      Tv[col13 + k * 1] := MaxR(0, Tv[col3 + k * 16] - Tv[col4 + k * 1] +
        Tv[col11 + k * 1] - Tv[col12 + k * 1]); // 20220912 MaxR

      Tv[93]:= Tv[93] + Tv[col13 + k * 16]; //20260717 Alex

      // col14  user input
      if Aiip = True then
        Tv[col14 + k * 1] := 0 //20260717 Alex
      else //20260717 Alex
        Tv[col14 + k * 1] := MaxR(0, Tv[col13 + k * 1]); //20260717 Alex
      //else //20260717 Alex
        //Tv[col14 + k * 1] := 0; //20260717 Alex
      // col15
      Tv[col15 + k * 1] := MaxR(0, Tv[col10 + k * 16] - Tv[col12 + k * 1]);
      // col16
      if Aiip = True then
        Tv[col16 + k * 1] := MaxR(0, Tv[col8 + k * 16] - Tv[col9 + k * 1] +
          Tv[col6 + k * 1] - Tv[col13 + k * 1] + Tv[col14 + k * 1] -
          Tv[col7 + k * 1]) // ? 54 and 56?
      else
        Tv[col16 + k * 1] := 0;
      // col17
      if Aiip = True then
        Tv[col17 + k * 1] := MaxR(0, Tv[col14 + k * 1] - Tv[col16 + k * 1])
        // ? 54 and 56?
      else
        Tv[col17 + k * 1] := 0;

      if Cls = '' then
      begin
        Aiipfactor := '';
        Strings[343 + k * 1] := ''; // aiip factor
      end;

      // col18
      if Aiip = True then //20260717 Alex
      Tv[col18 + k * 1] := Tv[col17 + k * 1] * Vl(Strings[343 + k * 1])//;//20260717 Alex
      else  //20260717 Alex
        Tv[col18 + k * 1]:= 0; //20260717 Alex
      // //? 54 and 56?

      // col19
      if Aiip = True then //20260717 Alex
      //Tv[col19 + k * 1] := MaxR(0, Tv[col13 + k * 1] - Tv[col14 + k * 1] - //20260720 Alex
      //  Tv[col6 + k * 1] - Tv[col17 + k * 1])//; // ? 54 and 56?  //20260720 Alex
        Tv[col19 + k * 1]:= MaxR(0, (Tv[col13 + k * 1] - Tv[col14 + k * 1] - Tv[col6 + k * 1] +  Tv[col7 + k * 1] -  Tv[col8 + k * 1] + Tv[col9 + k * 1]) * 0.5) //20260720 Alex
      else  //20260717 Alex
        Tv[col19 + k * 1]:= 0; //20260717 Alex

      // col20
      //Strings[col20 + k * 16] := Rate; //20260717 Alex
      // if Strings[Col20+K*16]='INF' then Strings[col20*k*16] := ''; //20220912
      // col21 recapture
      //20260717 Alex >>>
      If (UpperCase(Strings[3]) = 'Y') then
      begin
        Tv[col21 + k * 16] := 0;
        if Tv[col10 + k * 16] < 0 then
          Tv[col21 + k * 16] := Abs(Tv[col10 + k * 16]);

        if (Cls = '10.1') then
          Tv[col21 + k * 16] := 0; // 20230516
      end;
      Tv[230]:= Tv[230] + Tv[col21 + k * 16];

      // col22 Terminal loss
      If (UpperCase(Strings[3]) = 'Y') then
      begin
        Tv[col22 + k * 16] := 0;
        if (UpperCase(Strings[16 + k * 16]) = 'Y') and (Tv[col10 + k * 16] > 0)
        then
          Tv[col22 + k * 16] := Tv[col10 + k * 16];
        if (Cls = '10.1') then
          Tv[col22 + k * 16] := 0; // 20230516
      end;
      Tv[231] := Tv[231] + Tv[col22 + k * 16];
      //20260717 Alex <<<

      // col23 CCA
      If (Cls = '24') or (Cls = '27') or (Cls = '29') or (Cls = '34') then
      //20260717 Alex >>>
      begin
        Rate := '100'; // fast write off //20220802
        Strings[col20 + k * 16]:= Rate; //20260717 Alex
      end;
      //20260717 Alex <<<

      // There is CCA
      If (Tv[col21 + k * 16] = 0) and (Tv[col22 + k * 16] = 0) then
      // RGRE IS CCA (No Term loss =0 andRecpt=0 )
      begin // normal no gtterminal loss or  recapture
        if UpperCase(Strings[14 + k * 16]) <> 'Y' then // no override);
        Begin
          Tv[col23 + k * 16] := (Tv[col15 + k * 1] + Tv[col18 + k * 1] -
            Tv[col19 + k * 1]) * Vl(Rate) / 100 + Tv[col12 + k * 1];
          CCA := Tv[col23 + k * 16]; // 20230322
          if Ret[RetNo].DaysInYear < 365 then
          Begin
            CCA := CCA * Ret[RetNo].DaysInYear / 365;
            Tv[col23 + k * 16] := CCA;
          End;
        End;
      end
      Else // case: recapture  or Term loss>0 //20230512
      begin
        CCA := 0;

        Tv[col23 + k * 16] := 0; // if recapture or term loss then CCA =0
        // proration:?
        if Ret[RetNo].DaysInYear < 365 then
        Begin
          // Tv[col21 + k * 16]:=Tv[col21 + k * 16]/ 365;  //recapture
          // Tv[col22 + k * 16]:=Tv[col22 + k * 16] / 365; //terminal loss
        End;
      end;

      Tv[232] := Tv[232] + Tv[col23 + k * 16];

      if UpperCase(Strings[16 + k * 16]) = 'Y' // term loss
      then
        Tv[col24 + k * 16] := 0 // no UCC end eny more
      Else
        Tv[col24 + k * 16] := MaxR(0, Tv[col10 + k * 16] - Tv[col23 + k * 16]);

      Tv[251] := Tv[251] + Tv[col24 + k * 16];
    End; // k 0 to 12  //k is the wow bing processed starts from k=0
  End; // with?
  SaveTv(RetNo, FName, FNo);
end;
*)



(*
  //20220602
  procedure AS13(RetNo: integer;FName: string;FNo: integer);
  Var i,k,K1:integer;
  FInst :String;
  FedS8FNo:Integer;
  Cls,s,S1,S2:String;
  OriginalCost:Real;
  UccStart,Additions,Adjustments,Proceeds,UCC,HalfRuleAmount,UCCReduced:Real;
  OverrideIndic,HalfYearIndic,TermLossIndic: String;
  Rate:String;
  Recapture, TerminalLoss,CCA,UCCEnd:Real;
  DaysInTaxYear:Integer;
  //cls 13 relted
  AssetInfo: String;
  //additional fields after aiip
  Aiip:Boolean;
  AdditionsAiip, AssistanceReceived, RepaidAmount,
  ProceedsAiip,NetCapCostAdditionsAiip,UccAdjustmentAiip, UccAdjustmentNONAiip:Real;
  Aiipfactor:String;

  OverrideBox,HalfRuleBox,TerminalLossBox:String;
  HalfYearAmount:Real;

  LeaseStart,LeaseEnd: string; LeaseTerm:Real; LeaseAdjustedCost:Real; // RemainingLeaseTerm:Real;
  PurchaseDate:String;
  LeaseMaxCca:Real;
  x:real;

  begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
  If Strings[3] ='' then Strings[3] :='N';  //instead of 13  //20120201

  If UpperCase(Strings[3]) <> 'Y' then {copy from fed}
  begin
  FedS8FNo:=GetFormNo('S8'+FInst);
  If (FedS8FNo>0) and (Ret[RetNo].Frm[FedS8FNo].Count >0) then
  Begin
  for i:=6 to 396 do //232 do
  begin
  Strings[i] := FetchElmFNo(RetNo,FedS8FNo,i);
  Tv[i] := Vl(FetchElmFNo(RetNo,FedS8FNo,i));
  end;
  SaveTv (RetNo, Fname, FNo);
  Exit;
  end;  //count
  end; //'Y'
  end;  //with

  with Ret[RetNo].Frm[Fno] do
  begin

  FillAlbHeader(RetNo,FNo,1,2);  //20190626

  DaysInTaxYear:=Ret[RetNo].DaysInYear;
  If DaysInTaxYear > 365 then DaysInTaxYear := 365;


  DaysInTaxYear:=Ret[RetNo].DaysInYear;
  If DaysInTaxYear > 365 then DaysInTaxYear := 365;

  //FROm FED
  // FInst := ExtractFormInst(FName);
  // LoadTv(RetNo,FName,FNo);
  // with Ret[RetNo].Frm[Fno] do
  // begin
  //  FillHeader(RetNo,FNo,1,2,3);
  //If Strings[4]+Strings[5] = '' then Strings[5] := 'X';

  //INIT Totals //20190614
  Tv[249]:=0;Tv[234]:=0;Tv[250]:=0;Tv[235]:=0;
  Tv[230]:=0;Tv[231]:=0;Tv[232]:=0;Tv[251]:=0;

  for I:=384 to 396 do Strings[i]:='';  //initialize the botom classes, then copy them //20190705

  for k:=0 to 12 do  //k=01 etc to pick up the right row
  Begin
  Cls:=AllTrim(Strings[6+k*16]);  //20190719 //alltrim
  Strings[384+k*1]:=Cls; //20190705
  Rate:=GetCCARate(Cls);  //string //20190614
  //20190605
  If UpperCase(Strings[14+k*16])='O' then Strings[14+k*16]:='Y'; //override
  If UpperCase(Strings[15+k*16])='H' then Strings[15+k*16]:='Y';  //half year
  if vl(Rate)=100 then Strings[15+k*16]:='N';  //20190614 No half year rule for fast write off //20190614
  If UpperCase(Strings[16+k*16])='T' then Strings[16+k*16]:='Y';  //Term loss

  If UpperCase(Strings[14+k*16])='X' then Strings[14+k*16]:='Y'; //override
  If UpperCase(Strings[15+k*16])='X' then Strings[15+k*16]:='Y';  //half year
  If UpperCase(Strings[16+k*16])='X' then Strings[16+k*16]:='Y';  //Term loss

  OriginalCost:=Tv[371+k*1];
  AssetInfo:=Strings[236+k*1];

  UccStart:=Tv[7+k*16];
  Additions:=Tv[8+k*16];
  Adjustments:=Tv[9+k*16];
  Proceeds:=Tv[10+k*16];

  if (LeaseHold(Cls)) and (UCCStart>0) Then begin Additions:=0;Tv[8+k*16]:=0;end;  //do not allow additions to 13 //20190705
  //20190809  accept yyymmdd in case they entered yyyy/mm/dd
  If (Cls>'') then
  begin
  if Not LeaseHold(Cls) then
  Begin
  //replace yyymmdd with yyy/mm/dd for date
  s:=LeftStr(Strings[236+k*1],8);
  if (Length(s)=8) and (Numeric(s)) then
  Strings[236+k*1]:=LeftStr(s,4)+'/'+MidStr(S,6,2)+'/'+RightStr(s,2);
  End
  Else //leasehold //cls='13')
  Begin
  s:=Strings[236+k*1];
  s:=RemoveChar(s,'/');
  s:=RemoveChar(s,'-');
  s:=LeftStr(s,16);
  if (Length(s)=16) and (Numeric(s)) then
  Begin
  s1:=LeftStR(S,8);  //from date
  S1:=LeftStr(s1,4)+'/'+MidStr(S1,5,2)+'/'+RightStr(s1,2);
  S2:=RightStr(S,8); //to date
  S2:=LeftStr(s2,4)+'/'+MidStr(S2,5,2)+'/'+RightStr(s2,2);
  Strings[236+k*1]:=S1+'-'+S2;
  End;
  End;
  end;

  //FROM federal

  // AIIP indicator//20190621
  // 20190705
  Strings[356 + k * 1] := '';
  if (Additions > 0) and (Cls > '') then
  Begin
  s := ReplaceChar(AssetInfo, ',', '');
  PurchaseDate := LeftStr(s, 10);
  if (PurchaseDate > '2018/11/20') or
  (GetTaxationYearStart(RetNo) > '2018/11/20')
  // 20220619 additions made after the Aiip date of 2018
  then
  Strings[356 + k * 1] := 'X' // then 10.1 is aiip
  Else
  Strings[356 + k * 1] := ''; // 20190705
  end;

  if (GetTaxationYearEnd(RetNo) > '2027/12/31') then
  Strings[356 + k * 1] := '';
  // NO AIIP after 2027? Check it then IF ALIVE! //20190704
  If Strings[356 + k * 1] > '' then
  Aiip := True
  else
  Aiip := False; // 20190614
  if Cls = '56' then
  Begin
  Aiip := False;
  Strings[356 + k * 1] := '';
  end; // 20220531
  //end of from Federal
  //20190607
  if (Aiip=False) and (cls>'') then
  Begin
  If Strings[15+k*16]='' then Strings[15+k*16]:='Y';  //20190605 half yer rule by default
  End;


  if Aiip=True then Strings[15+k*16]:='';    //20190614 in O-H-T
  If (cls='24')  or (cls='27') or(cls='29') or (cls='34') then Strings[15+k*16]:=''; //fast write off NO half year rule

  OverrideIndic:=UpperCase(Strings[14+k*16]);
  HalfYearIndic:=UpperCase(Strings[15+k*16]);
  TermLossIndic:=UpperCase(Strings[16+k*16]);

  If Uppercase(OverrideIndic) <> 'Y' then Rate:=GetCCARate(Cls);

  //Inpout validations
  if Cls='10.1' then  //20190622
  Begin
  if PurchaseDate < GetTaxationYearStart(RetNo) then Tv[8+k*16]:=0; //no additions allowed
  End;

  If (Aiip=False)
  and (cls<>'56') //20220531
  then Tv[252+k*1]:=0;  //aiip portion of col 3

  AdditionsAiip:=Tv[252+k*1];
  //assistance part of col 5
  If Tv[265+k*1]>Tv[9+k*16] then Tv[265+k*1]:=Tv[9+k*16];
  AssistanceReceived:=Tv[265+k*1];
  //repaid part of col 5
  If Tv[278+k*1]>Tv[9+k*16] then Tv[278+k*1]:=Tv[9+k*16]; //repaid
  RepaidAmount:=Tv[278+k*1];
  //both
  If Tv[265+k*1] + Tv[278+k*1]>Tv[9+k*16] then Tv[278+k*1]:=0;  //one has to go


  //aiip  related
  If Aiip=False then
  Begin
  Tv[291+k*1]:=0;
  Tv[304+k*1]:=0;
  Tv[343+k*1]:=0;
  Tv[317+k*1]:=0;
  Tv[330+k*1]:=0;
  End;
  if Aiip=True then  //20190705
  Begin
  //fast write off //20190608
  if (cls='24')  or (cls='27') or(cls='29') or (cls='34') then
  Begin
  Tv[8+k*16]:=0; //additions
  End;


  //20210328
  // Aiipfactor
  AiipFactor:='';
  Strings[343+k*1]:='';
  if Cls='' then Aiipfactor:=''; //20190622
  if Aiip=False then Aiipfactor := '';  //default

  if cls = '43.1' then Aiipfactor := '2.33333'
  Else if Cls = '43.2' then Aiipfactor := '1'
  Else if Cls = '53' then Aiipfactor := '1'

  Else if (Cls = '54') then
  Begin
  if Strings[236+k] > '2019/03/18' then
  begin
  Strings[356+k] := 'X';
  Aiipfactor := '2.33333333';
  end
  Else If Strings[236+k] > '2018/11/20' then
  begin
  Strings[356+k] := 'X';
  Aiipfactor := '0.5';
  end;
  End
  Else if (Cls = '55') and (Strings[236+k] > '2019/03/18') then Aiipfactor := '1.5'
  Else if (Cls = '56') then Aiipfactor := '2.333331'    //20210927
  Else if (cls='12') or (Leasehold(cls)) or (cls='14') or (cls='15') then Aiipfactor:=''  //20190806
  Else  Aiipfactor := '0.5';

  if cls='' then begin AiipFactor:='';Strings[343+k*1]:='';end;
  End;
  Strings[343+k*1]:=AiipFactor;

  ProceedsAiip:=Tv[291+k*1];

  HalfRuleAmount:=0;
  UCC:=0;
  UCCReduced:=0;
  Recapture:=0;
  TerminalLoss:=0;


  //get lease and orinal cost from decr box
  If Leasehold(cls) then //if Cls='13' then
  begin
  LeaseTerm:=5; //Default;
  //for class 13: 1234567890-1234567890
  s:=ReplaceChar(AssetInfo,',','');
  LeaseStart:=LeftStr(S,10);
  LeaseEnd:=MidStr(S,12,10);
  if (Length(LeaseStart)<>10) or (Length(LeaseEnd)<>10) then
  LeaseTerm :=0
  Else
  begin
  LeaseTerm := DateDiffYMD(LeaseStart,LeaseEnd) div 365;
  If (LeaseTerm>0) and (LeaseTerm<5) then LeaseTerm :=5;
  End;
  LeaseMaxCCA:=OriginalCost/LeaseTerm;  //20190611
  Rate:=FormatFloat('####.##',100/LeaseTerm);      //20190601
  Strings[17*k*16]:=Rate;
  end;

  if Cls = '' then
  begin
  UCC := 0;
  HalfRuleAmount := 0;
  UccReduced := 0;
  Recapture := 0;
  TerminalLoss := 0;
  CCA := 0;
  UCCEnd := 0;
  end;

  Ucc := UccStart + Additions + Adjustments - AssistanceReceived + RepaidAmount - Proceeds; //20190606pm
  if (Cls='10.1') and (Proceeds>0) then UCC:=UccStart + Additions + Adjustments - AssistanceReceived + RepaidAmount; //20190820 Get the CCA on disposal

  If LeaseHold(Cls) then //if cls='13' then //20190611
  Begin
  LeaseAdjustedCost:=OriginalCost-UccStart + Additions + Adjustments - AssistanceReceived + RepaidAmount;
  UccReduced:=UCCStart + Additions + Adjustments - AssistanceReceived + RepaidAmount;
  End;

  if AiiP=False then  //20190706
  Begin
  if UpperCase(HalfYearIndic) = 'Y' then   ////20190605
  begin
  if UpperCase(OverrideIndic) <> 'Y' then  //20190605
  begin
  HalfRuleAmount := MaxR(0, 0.5 * (Additions-AssistanceReceived+RepaidAmount-Proceeds));
  if LeaseHold(Cls) then HalfRuleAmount := MaxR(0, 0.5 * (Additions-Proceeds)); //20190613
  HalfRuleAmount := RoundCorrect(HalfRuleAmount);
  end;
  end
  else
  HalfRuleAmount := 0;
  end;

  If (Aiip=True) then
  Begin
  HalfRuleAmount:=0;   //20190608
  //20190707
  ProceedsAiip:=MaxR(0,Proceeds+AssistanceReceived-Additions+AdditionsAiiP-RepaidAmount);
  NetCapCostAdditionsAiip:=MaxR(0,AdditionsAiip-ProceedsAiip);
  UccAdjustmentAiip:=NetCapCostAdditionsAiip*vl(AiipFactor);

  UccAdjustmentNONAiip:=MaxR(0,0.5 * (Additions-AdditionsAiip-AssistanceReceived+RepaidAmount-Proceeds)); //20190622 moved from below
  if (CLS='12') OR (CLS='52') Or (cls='24')  or (cls='27') or(cls='29') or (cls='34') then UccAdjustmentNONAiip:=0; //20190622  //fast write off //20190622
  UCCReduced:=UccStart +additions+Adjustments-AssistanceReceived+RePaidAmount-Proceeds-UccAdjustmentNONAiip+UccAdjustmentAiip; //20190707
  //20190706
  if (cls='10.1') then //(PurchaseDate>'2018/11/20') then  //20190705
  Begin
  UccReduced:=Additions + Adjustments - AssistanceReceived + RepaidAmount+Round(Additions/2); //20190622
  end;
  End
  Else  //NO aiip
  Begin
  if (CLS='12') OR (CLS='52') Or (cls='24')  or (cls='27') or(cls='29') or (cls='34')  //fast write off //20190622
  then UccAdjustmentNONAiip:=0; //20190622
  UCCReduced := UCC - HalfRuleAmount;
  if LeaseHold(Cls) then UccReduced:=UCC;  //20190611
  ProceedsAiip:=0;
  NetCapCostAdditionsAiip:=0;
  UccAdjustmentAiip:=0;
  end;
  //put amounts on the S8 form
  Tv[12+k*16]:=HalfRuleAmount;
  if AiiP then Tv[12+k*16]:=0;   //remove half ruleamount
  Tv[11+k*16]:=UCCReduced;
  Strings[17+k*16]:=Rate;

  Tv[291+k*1]:=ProceedsAiip; //UccAdjustmentNONAiip;
  Tv[304+k*1]:=NetCapCostAdditionsAiip;
  Strings[343+k*1]:=AiipFactor;
  if Cls='' then Strings[343+k*1]:='';

  Tv[317+k*1]:=UccAdjustmentAiip;
  If Cls>'' then Tv[330+k*1]:=UccAdjustmentNONAiip;  //20190622

  //cca calcs
  if UCCReduced < 0 then
  begin
  //If cls<>'10.1' then  //20190820 If 10.1 we still want to claim CCA when disposed, but not recapture
  CCA := 0;
  TerminalLoss := 0;
  Recapture := ABS(UCCReduced);
  if Cls = '10.1' then Recapture:=0;
  end
  else  //positive ucc = CCA or Terminal loss upon disposal
  begin
  TerminalLoss := 0;
  Recapture := 0;

  //20221123 //do not round
  if Aiip then
  CCA:=UCCReduced * Vl(Rate)/100  //20190622
  else
  CCA:=UCCReduced * Vl(Rate) / 100;
  {
  //20190313
  if Aiip then
  CCA:=Round(UCCReduced * Vl(Rate)/100)  //20190622
  else
  CCA:=Round(UCCReduced * Vl(Rate) / 100);
  }

  if (LeaseHold(Cls)) and (AIIP=False) then  //20190613
  CCA := MinR(UCCReduced, LeaseMaxCCA);

  if (Leasehold(Cls)) then
  Begin
  //if (Aiip=False)  //20190725
  If (LeftStr(LeaseStart,4)=LeftStr(GetBegYearEnd(RetNo),4))
  then
  CCA:=Round(CCA/2); //20190705
  end;

  If (LeaseHold(Cls)) Then  //20190725
  Begin
  If (Aiip=true)
  and (LeftStr(LeaseStart,4)=LeftStr(GetBegYearEnd(RetNo),4))
  and (AdditionsAiip>0)
  then  CCA:=CCA *3; //first year  //20190725
  end;


  if (cls='24')  or (cls='27') or(cls='29') or (cls='34') then CCA:=UccReduced; //fast wrire offs 20190609
  if (cls='12') then CCA:=UccReduced; //20210623

  //20210526
  // If (IsLeapYear(GetTaxationYearStartYYYY(RetNo)) and //20210601

  //20210726
  if (isLeapYear(GetTaxationYearEndYYYY(RetNo))
  and (GetTaxationYearEnd(RetNo)>'2020/02/28')) then
  CCA:=CCA * Ret[RetNo].DaysInYear / 366
  Else
  CCA:=CCA * Ret[RetNo].DaysInYear / 365;


  if (cls='12') or (cls='24')  or (cls='27') or(cls='29') or (cls='34') then CCA:=UccReduced; //fast wrire offs 20210623

  if OverrideIndic='Y' then CCA:=Tv[20+k*16];

  if TermLossIndic='Y' then
  Begin
  TerminalLoss:=UccReduced+UCCAdjustmentNONAIIp; //20190626    //TerminalLoss:=UccReduced;
  Tv[19+k*16]:=TerminalLoss;
  Recapture:=0;
  Tv[18+k*16]:=0;
  CCA:=0;
  UccEnd :=0;
  End;


  UccEnd := MaxR(0, UCCReduced - CCA);

  if AiiP=False then
  UccEnd:=MaxR(0,UCCReduced-CCA+HalfRuleAmount)        //20190622
  Else //Aiip is true
  Begin
  UccEnd:=MaxR(0,UccReduced-CCA+UCCAdjustmentNONAIIp-UCCAdjustmentAIIp);  //20190707
  If Cls='10.1' then UccEnd:=MaxR(0,UCCReduced-CCA-UCCAdjustmentNONAIIp);  //20190707
  end;
  end;
  if (cls = '10.1') then begin TerminalLoss := 0;Recapture := 0;end; //20190607
  if (cls = '10.1') and (proceeds > 0) then
  begin
  CCA :=CCA/2; //Round(CCA/2);  //20221123
  UccEnd := 0;
  end;

  //20190626
  if (Recapture>0) or (TerminalLoss>0) then UCcEnd:=0;

  Tv[20+k*16]:=CCA;
  Tv[21+k*16]:=UccEnd;
  Tv[18+k*16]:=Recapture;
  Tv[19+k*16]:=TerminalLoss;

  //add to totals //20190614
  Tv[249]:=Tv[249]+uccStart;
  Tv[234]:=Tv[234]+Additions;
  Tv[250]:=Tv[250]+Adjustments;
  Tv[235]:=Tv[235]+Proceeds;

  Tv[230]:=Tv[230]+Recapture;
  Tv[231]:=Tv[231]+TerminalLoss;
  Tv[232]:=Tv[232]+CCA;
  Tv[251]:=Tv[251]+UccEnd;

  End; //k 0 to 12
  End; //with?
  SaveTv(RetNo,FName,FNo);
  end;
*)

// 20121221
Procedure AS14(RetNo: Integer; FName: string; FNo: Integer);
Var
  i: Integer;
  YearEndOnOrAfter2017: Boolean;
begin
  EXIT; // 20211025
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    if (GetTaxationYearEnd(RetNo) >= '2017/01/01') then
      YearEndOnOrAfter2017 := True
    Else
      YearEndOnOrAfter2017 := False;

    If Strings[21] = '' then
      Strings[21] := 'N';
    If UpperCase(Strings[21]) <> 'Y' then
    begin
      { copy from Fed }
      Tv[3] := Vl(FetchElm(RetNo, 'S10', 4));
      Tv[4] := Vl(FetchElm(RetNo, 'S10', 5));
      Tv[19] := Vl(FetchElm(RetNo, 'S10', 24));
      Tv[6] := Vl(FetchElm(RetNo, 'S10', 25));
      Tv[9] := Vl(FetchElm(RetNo, 'S10', 7));
      Tv[10] := Vl(FetchElm(RetNo, 'S10', 8));
      Tv[11] := Vl(FetchElm(RetNo, 'S10', 9));
      Tv[14] := Vl(FetchElm(RetNo, 'S10', 47));
      Tv[20] := Vl(FetchElm(RetNo, 'S10', 44));
    end;

    FillAlbHeader(RetNo, FNo, 1, 2);
    Tv[7] := Round((Tv[4] + Tv[6]) * (3 / 4));
    Tv[17] := Vl(FetchElm(RetNo, 'S10', 41));
    Tv[16] := Tv[17] / 2;
    Tv[18] := MaxR(0, Tv[7] - Tv[16]);
    Tv[8] := Tv[3] + Tv[18] + Tv[19]; // Tv[7];
    Tv[12] := Round(AddColumns(9, 11, 1) * (3 / 4));
    Tv[13] := Tv[8] - Tv[12];

    If UpperCase(Strings[21]) = 'Y' then // differ
    Begin
      If Tv[13] >= 0 then
      begin
        If Strings[22] = '' then
          Strings[22] := '7.0';
        Tv[14] := Round(MaxR(0, Tv[13] - Tv[20]) * Vl(Strings[22]) / 100);
        Tv[15] := MaxR(0, Tv[13] - Tv[20] - Tv[14]);
      end
      else
      begin
        Tv[14] := 0;
        Tv[15] := 0;
      end;
    end
    else
      Tv[15] := MaxR(0, Tv[13] - Tv[20] - Tv[14]);
    if GetTaxationYearEnd(RetNo) > '2016/12/31' then
    begin
      Tv[14] := 0;
      Tv[15] := 0;
    end;
  end; { end with }
  // pg2 -------------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    If Strings[21] <> 'Y' then
    begin
      { copy from Fed }
      Tv[107] := Vl(FetchElm(RetNo, 'S10', 15));
    end;
    If Tv[13] < 0 then
      Tv[101] := Abs(Tv[13])
    else
      Tv[101] := 0;

    Tv[108] := MaxR(0, Tv[104] + Tv[105] + Tv[106] - Tv[107]);
    Tv[102] := Vl(FetchElm(RetNo, 'S10', 48));
    Tv[110] := Tv[108] - Tv[102] - Tv[109];
    Tv[111] := MaxR(0, Tv[101] - Tv[110]);
    Tv[112] := Round(MaxR(0, Tv[106] - Tv[107]) * (1 / 2));
    Tv[113] := 0;
    If (GetTaxationYearEnd(RetNo) > '2000/02/27') and
      (GetTaxationYearEnd(RetNo) < '2000/10/18') then
      Tv[113] := Round(MaxR(0, Tv[111] - Tv[112]) * (8 / 9))
    else If GetTaxationYearEnd(RetNo) > '2000/10/17' then
      Tv[113] := Round(MaxR(0, Tv[111] - Tv[112]) * (2 / 3));

    Tv[114] := MinR(Tv[101], Tv[110]);

    If GetTaxationYearEnd(RetNo) > '2000/02/27' then
      Tv[115] := MaxR(0, Tv[113] + Tv[114])
    else
      Tv[115] := MaxR(0, Tv[101] - Tv[112]);

    // 20171118
    If (YearEndOnOrAfter2017 = True) then
    Begin
      If (DateWithinTaxYear('2016/12/31', RetNo)) then
      Begin
        Tv[114] := 0;
        Tv[115] := 0;
      End;
    End;

    If Tv[101] = 0 then
      for i := 101 to 115 do
        Tv[i] := 0;
  end; { end with }
  SaveTv(RetNo, FName, FNo);

end;

Procedure AS14WS(RetNo: Integer; FName: string; FNo: Integer);
Var
  i, AS14FNo: Integer;
  YearEndOnOrAfter2017, YearEndOnOrBfrJan2017: Boolean;
begin
  EXIT; // 20211025
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    AS14FNo := GetFormNo('AS14');
    FillAlbHeader(RetNo, FNo, 1, 2); // 20171118
    if Strings[3] = '' then
      Strings[3] := 'N';
    Tv[4] := MaxR(0, Vl(FetchElmFNo(RetNo, AS14FNo, 13))); // 20171118
    // Tv[5]:=??
    Tv[6] := Tv[4] + Tv[5];
    Tv[7] := Vl(FetchElmFNo(RetNo, AS14FNo, 101));
    Tv[8] := Round(Vl(FetchElmFNo(RetNo, AS14FNo, 113)) * 3 / 2);
    Tv[9] := Tv[7] - Tv[8];
    Tv[10] := MaxR(0, Tv[6] - Tv[9]);
    Tv[11] := Round(Tv[10] * 4 / 3);
    Tv[12] := Tv[11];
    Tv[13] := Tv[9];
    Tv[14] := Tv[12] + Tv[13];
    Tv[15] := Tv[4];
    Tv[16] := Tv[14] - Tv[15];
    Tv[17] := Tv[12] - Tv[16];
    // transitional
    if (GetTaxationYearEnd(RetNo) <= '2017/12/31') then
      YearEndOnOrBfrJan2017 := True
    Else
      YearEndOnOrBfrJan2017 := False;

    if (GetTaxationYearEnd(RetNo) >= '2017/01/01') then
      YearEndOnOrAfter2017 := True
    Else
      YearEndOnOrAfter2017 := False;

    If (YearEndOnOrAfter2017 = True) and (DateWithinTaxYear('2016/12/31', RetNo))
    then
    Begin // transitional rules
      if Strings[18] + Strings[19] = '' then
        Strings[19] := 'X';
      if Strings[18] > '' then // defer both income and capital gain
      Begin
        // Tv[20]:= user
        Tv[21] := Round(Tv[20] * 50 / 100);
        Tv[22] := Vl(FetchElmFNo(RetNo, AS14FNo, 113));
        Tv[23] := MinR(Tv[21], Tv[22]);
        Tv[24] := Tv[23] * 2;
        Tv[25] := Tv[20] - Tv[24];
        // 20171118 NO claim this year (deferred)
        Strings[26] := '';
        Strings[27] := '';
        for i := 28 to 34 do
        begin
          Tv[i] := 0;
        end;
      End
      Else
      Begin // NO to FIRST election
        for i := 20 to 24 do
        begin
          Tv[i] := 0;
        End;
        if Strings[18] = '' then
        begin
          if Strings[26] + Strings[27] = '' then
            Strings[27] := 'X';
        end;

        if Strings[26] > '' then // report as income
        Begin
          Tv[28] := Vl(FetchElmFNo(RetNo, AS14FNo, 113));
          Tv[29] := Tv[23];
          Tv[30] := Tv[28] - Tv[29];
          For i := 31 to 34 do
          begin
            Tv[i] := 0;
          End; // 20171117
        End;
        if Strings[27] > '' then // report Report s Cap gain
        Begin
          for i := 28 to 30 do
          begin
            Tv[i] := 0;
          end;
          Tv[31] := Vl(FetchElmFNo(RetNo, AS14FNo, 113));
          Tv[32] := Tv[23];
          Tv[33] := Tv[31] - Tv[32];
          Tv[34] := Tv[33] * 2;
        End;
      End;
    End
    Else
    Begin // NO transitional rules
      for i := 18 to 34 do
      Begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
    End;
  end; { end with }
  SaveTv(RetNo, FName, FNo);

end;

(*
  Procedure AS14(RetNo:integer;FName:string;FNo:integer);
  Var i:Integer;
  begin
  LoadTv (RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
  If Strings[21] = '' then Strings[21] :='N';
  If UpperCase(Strings[21]) <> 'Y' then
  begin
  {copy from Fed}
  Tv[3] := Vl(FetchElm(RetNo,'S10',4));
  Tv[4] := Vl(FetchElm(RetNo,'S10',5));
  Tv[19]:=Vl(FetchElm(RetNo,'S10',24));
  Tv[6] := Vl(FetchElm(RetNo,'S10',25));
  Tv[9] := Vl(FetchElm(RetNo,'S10',7));
  Tv[10] := Vl(FetchElm(RetNo,'S10',8));
  Tv[11] := Vl(FetchElm(RetNo,'S10',9));
  Tv[14] := Vl(FetchElm(RetNo,'S10',47));
  Tv[20]:=Vl(FetchElm(RetNo,'S10',44));
  end;

  FillAlbHeader(RetNo,FNo,1,2);
  Tv[7] := Round((Tv[4]+Tv[6]) * (3/4));
  Tv[17]:=Vl(FetchElm(RetNo,'S10',41));
  Tv[16]:=Tv[17]/2;
  Tv[18]:=MaxR(0,Tv[7]-Tv[16]);
  Tv[8] := Tv[3]+Tv[18]+Tv[19]; //Tv[7];
  Tv[12] := Round(AddColumns(9,11,1)* (3/4));
  Tv[13] := Tv[8]-Tv[12];

  If UpperCase(Strings[21]) = 'Y' then  // differ
  Begin
  If Tv[13] >=0 then
  begin
  If Strings[22]='' then Strings[22] := '7.0';
  Tv[14] :=Round(MaxR(0,Tv[13]-Tv[20]) * Vl(Strings[22])/100);
  Tv[15] := MaxR(0,Tv[13] - Tv[20] -Tv[14]);
  end
  else
  begin
  Tv[14] :=0;
  Tv[15] :=0;
  end;
  end
  else
  Tv[15] := MaxR(0,Tv[13] - Tv[20] -Tv[14]);
  end; { end with}
  //pg2 -------------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
  If UpperCase(FetchElm(RetNo,'AS14',21)) <> 'Y' then
  begin
  {copy from Fed}
  Tv[107] := Vl(FetchElm(RetNo,'S10',15));
  end;
  If Vl(FetchElm(RetNo,'AS14',13)) <0 then
  Tv[101] := ABS(Vl(FetchElm(RetNo,'AS14',13)))
  else
  Tv[101]:=0;

  Tv[108] := MaxR(0,Tv[104]+Tv[105]+Tv[106]-Tv[107]);
  Tv[102]:=Vl(FetchElm(RetNo,'S10',48));
  Tv[110]:=Tv[108]-Tv[102]-Tv[109];
  Tv[111]:= MaxR(0,Tv[101]-Tv[110]);
  Tv[112]:= Round(MaxR(0,Tv[106]-Tv[107]) * (1/2));
  Tv[113] :=0;
  If (GetTaxationYearEnd(RetNo) > '2000/02/27')
  and  (GetTaxationYearEnd(RetNo) < '2000/10/18') then
  Tv[113] := Round(MaxR(0,Tv[111] - Tv[112]) * (8/9))
  else If GetTaxationYearEnd(RetNo) > '2000/10/17' then
  Tv[113] :=  Round(MaxR(0,Tv[111] - Tv[112]) * (2/3));
  Tv[114] := MinR(Tv[101],Tv[110]);

  If GetTaxationYearEnd(RetNo) > '2000/02/27' then
  Tv[115] := MaxR(0,Tv[113]+Tv[114])
  else
  Tv[115] := MaxR(0,Tv[101]-Tv[112]);

  If Tv[1]=0 then
  for i:=101 to 115 do Tv[i]:=0;
  end; { end with}
  SaveTv (RetNo, Fname, FNo);

  end;
*)
Procedure AS15(RetNo: Integer; FName: string; FNo: Integer);
Var
  i, j, k: Integer;
  Mx: Real;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    If Strings[3] = '' then
      Strings[3] := 'N';
    If UpperCase(Strings[3]) <> 'Y' then
    begin
      { copy from fed }
      For i := 4 to 697 do
        Tv[i] := Vl(FetchElm(RetNo, 'S12', i)); // 20120920
      Tv[218] := Vl(FetchElm(RetNo, 'S12', 228));
      Tv[228] := Vl(FetchElm(RetNo, 'S12', 329));
    end;
    FillAlbHeader(RetNo, FNo, 1, 2);
    FillAlbHeader(RetNo, FNo, 25, 24);
    FillAlbHeader(RetNo, FNo, 31, 26);
    FillAlbHeader(RetNo, FNo, 32, 27);
    FillAlbHeader(RetNo, FNo, 33, 28);
    FillAlbHeader(RetNo, FNo, 34, 29);
    FillAlbHeader(RetNo, FNo, 35, 30);

    Tv[22] := MaxR(0, Tv[4] + Tv[6] - Tv[9]);
    Tv[23] := MaxR(0, Tv[5] + Tv[7] + Tv[8] - Tv[10]);
    Tv[13] := MaxR(0, Tv[22] - Tv[12]);
    Tv[14] := MaxR(0, Tv[23] - Tv[11]);

    Tv[19] := MaxR(0, Tv[15] + Tv[16] + Tv[17] - Tv[18]);
    Tv[21] := MaxR(0, Tv[19] - Tv[20]);
  end; { End with }
  // AS15 pg 2-------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    If UpperCase(FetchElm(RetNo, 'AS15', 3)) <> 'Y' then
    begin
      Tv[114] := Vl(FetchElm(RetNo, 'S12', 126));
      Tv[117] := Vl(FetchElm(RetNo, 'S12', 117)); // 20091215
      Tv[126] := Vl(FetchElm(RetNo, 'S12', 127)); // 20091215
    end;
    Tv[120] := Tv[101] + Tv[103] + Tv[114] + Tv[104] + Tv[106] + Tv[109] +
      Tv[111] - Tv[113] - Tv[115] - Tv[118] - Tv[117] - Tv[126];
    If Tv[120] > 0 then
    begin
      If Tv[121] > Tv[120] then
        Tv[121] := Tv[120];
    end;
    If Tv[120] <= 0 then
    begin
      Tv[121] := Tv[120];
    end;

    Tv[125] := Tv[102] + Tv[105] + Tv[107] + Tv[108] - Tv[116] - Tv[119];
    Tv[123] := MaxR(0, Tv[120] - Tv[121]);
    Tv[124] := MaxR(0, Tv[125] - Tv[122]);
  end; { End with }
  // AS15 pg 3-------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    Tv[221] := Tv[201] + Tv[203] + Tv[218] + Tv[204] + Tv[206] - Tv[208] -
      Tv[210] - Tv[212] - Tv[214] - Tv[216] - Tv[220] - Tv[227] - Tv[228];
    Tv[222] := Tv[202] + Tv[205] + Tv[207] - Tv[211] - Tv[217] - Tv[219]
      - Tv[209];
    Tv[225] := MaxR(0, Tv[221] - Tv[223]);
    Tv[226] := MaxR(0, Tv[222] - Tv[224]);
  end; { End with }
  // AS15 pg 4-------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    Tv[317] := Tv[301] + Tv[303] + Tv[304] + Tv[307] - Tv[309] - Tv[311] -
      Tv[313] - Tv[315];
    Tv[318] := Tv[302] + Tv[305] + Tv[306] - Tv[310] - Tv[314] - Tv[316];
    Tv[321] := MaxR(0, Tv[317] - Tv[319]);
    Tv[322] := MaxR(0, Tv[318] - Tv[320]);
  end; { End with }
  // AS15 pg 5-------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    Tv[409] := Tv[401] + Tv[404] - Tv[407]; // +Tv[403]  20140517
    Tv[410] := Tv[402] + Tv[405] + Tv[406] - Tv[408];
    Tv[413] := MaxR(0, Tv[409] - Tv[411]);
    Tv[414] := MaxR(0, Tv[410] - Tv[412]);
  end; { End with }
  // AS15 pg 6-------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    i := 501;
    k := 500;
    Tv[596] := 0;
    Tv[598] := 0;
    Tv[597] := 0;
    Tv[599] := 0;
    Repeat
      Tv[31 + k] := Tv[6 + k] + Tv[16 + k] + Tv[21 + k] - Tv[26 + k];
      // +Tv[11+k]  20140518
      If Tv[36 + k] > Tv[31 + k] then
        Tv[36 + k] := Tv[31 + k];
      If Tv[31 + k] < 0 then
      begin
        Tv[36 + k] := 0;
        Tv[41 + k] := 0;
      end
      else
      begin
        Tv[41 + k] := MaxR(0, Tv[31 + k] - Tv[36 + k]);
      end;

      Tv[76 + k] := Tv[56 + k] + Tv[61 + k] + Tv[66 + k] - Tv[71 + k];
      If Tv[81 + k] > Tv[76 + k] then
        Tv[81 + k] := Tv[76 + k];
      If Tv[76 + k] < 0 then
      begin
        Tv[81 + k] := 0;
        Tv[86 + k] := 0;
      end
      else
      begin
        Tv[86 + k] := MaxR(0, Tv[76 + k] - Tv[81 + k]);
      end;

      Tv[596] := Tv[596] + Tv[36 + k];
      Tv[597] := Tv[597] + Tv[81 + k];
      Tv[598] := Tv[598] + Tv[31 + k]; // 20140518
      Tv[599] := Tv[599] + Tv[76 + k]; // 20140518
      Inc(i);
      Inc(k);
    until i > 505;
  end; { End with }
  // AS15 pg 7-------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    i := 601;
    k := 600;
    Tv[696] := 0;
    Tv[697] := 0;
    Tv[700] := 0;
    Repeat
      Tv[31 + k] := Tv[6 + k] + Tv[11 + k] + Tv[16 + k] + Tv[21 + k] -
        Tv[26 + k];
      If Tv[31 + k] < 0 then
      begin
        Tv[36 + k] := 0;
        Tv[41 + k] := 0;
      end
      else
      begin
        Tv[41 + k] := MaxR(0, Tv[31 + k] - Tv[36 + k]);
      end;

      Tv[76 + k] := Tv[56 + k] + Tv[61 + k] + Tv[66 + k] - Tv[71 + k];
      If Tv[31 + k] < 0 then
      begin
        Tv[36 + k] := 0;
        Tv[41 + k] := 0;
      end
      else
      begin
        Tv[41 + k] := MaxR(0, Tv[31 + k] - Tv[36 + k]);
      end;

      Tv[696] := Tv[696] + Tv[36 + k];
      Tv[697] := Tv[697] + Tv[81 + k];
      Tv[700] := Tv[700] + Tv[31 + k];
      Inc(i);
      Inc(k);
    until i > 605;
  end; { End with }
  SaveTv(RetNo, FName, FNo);

end;

Procedure AS16(RetNo: Integer; FName: string; FNo: Integer);
Var
  i: Integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    //20260628
    If (Ret[RetNo].Province = 'AB')
    or (Vl(FetchElm(RetNo, 'S5', 197))>0) then  //has AB income   //20260725
    //continue
    else
    begin
     For i:=1 to 13 do begin Strings[i]:='';Tv[i]:=0;End;
     SaveTv(RetNo,FName,FNo);
     exit;
    end;

    If Strings[14] = '' then
      Strings[14] := 'N';
    If UpperCase(Strings[14]) <> 'Y' then
    begin
      Tv[3] :=Vl(FetchElm(RetNo, 'T661', 142)); //20260725  //Vl(FetchElm(RetNo, 'T661', 121));
      // Line 380  //20201202 //Vl(FetchElm(RetNo,'T661',123));
      Tv[4] := Vl(FetchElm(RetNo, 'T661', 125)) +
        Vl(FetchElm(RetNo, 'T661', 126)) + Vl(FetchElm(RetNo, 'T661', 127)) +
        Vl(FetchElm(RetNo, 'AT1', 74)); // 20210713
      Tv[5] := Vl(FetchElm(RetNo, 'T661', 128));
      Tv[6] := Vl(FetchElm(RetNo, 'T661', 129));
      Tv[7] := Vl(FetchElm(RetNo, 'T661', 131));
      Tv[8] := Vl(FetchElm(RetNo, 'T661', 132));
      Tv[9] := Vl(FetchElm(RetNo, 'T661', 133));
      Tv[17] := Vl(FetchElm(RetNo, 'T661', 134));
    end;
    FillAlbHeader(RetNo, FNo, 1, 2);
    Tv[10] := Tv[3] - Tv[4] - Tv[5] - Tv[6] + Tv[7] + Tv[8] + Tv[9] + Tv[17];
    If Tv[10] >= 0 then
    begin
      Tv[11] := Tv[10];
      Tv[12] := Tv[11];
      If UpperCase(Strings[15]) = 'Y' then
        Tv[12] := Tv[16];
      Tv[13] := MaxR(0, Tv[11] - Tv[12]);
    end
    else
    begin
      For i := 11 to 13 do
        Tv[i] := 0;
    end;

  end; { end with }
  SaveTv(RetNo, FName, FNo);
end;

Procedure AS17(RetNo: Integer; FName: string; FNo: Integer);
Var
  i: Integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    If Strings[34] = '' then
      Strings[34] := 'N';
    If UpperCase(Strings[34]) <> 'Y' then
    begin
      { copy from fed }
      For i := 3 to 20 do
        Tv[i] := Vl(FetchElm(RetNo, 'S13', i + 28));
      Tv[27] := Vl(FetchElm(RetNo, 'S13', 49));
      Tv[28] := Vl(FetchElm(RetNo, 'S13', 50));
      Tv[29] := Vl(FetchElm(RetNo, 'S13', 51));
    end;

    FillAlbHeader(RetNo, FNo, 2, 1);
    // 20140505
    Tv[30] := AddColumns(3, 9, 3) + AddColumns(15, 27, 3);
    Tv[31] := AddColumns(4, 10, 3) + AddColumns(16, 28, 3);
    Tv[32] := AddColumns(5, 11, 3) + AddColumns(17, 29, 3);
    Tv[33] := Tv[30] + Tv[31];
  end; { end with }
  SaveTv(RetNo, FName, FNo);
end;

Procedure AS18(RetNo: Integer; FName: string; FNo: Integer);
Var
  i: Integer;
begin
  LoadTv(RetNo, FName, FNo);
  If Ret[RetNo].AlbAlloc = 0 then
  begin
    For i := 1 to 172 do
    begin
      Ret[RetNo].Frm[FNo].Strings[i] := '';
      Ret[RetNo].Frm[FNo].Tv[i] := 0;
    end;
    SaveTv(RetNo, FName, FNo);
    EXIT;
  end;

  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 1, 2);
    If Strings[3] = '' then
      Strings[3] := 'N';
    If Strings[40] + Strings[41] = '' then
      Strings[41] := 'X';
    If UpperCase(Strings[3]) <> 'Y' then
    begin
      { Copy from details }
      Tv[4] := Vl(FetchElm(RetNo, 'ACAPD', 214));
      Tv[5] := Vl(FetchElm(RetNo, 'ACAPD', 215));
      Tv[6] := Vl(FetchElm(RetNo, 'ACAPD', 216));
      Tv[42] := Tv[4] - (Tv[5] + Tv[6]);
      Tv[43] := Vl(FetchElm(RetNo, 'S6', 218));

      Tv[7] := Tv[42] + Tv[43]; // Vl(FetchElm(RetNo,'ACAPD',217));

      Tv[8] := Vl(FetchElm(RetNo, 'ACAPD', 247));
      Tv[9] := Vl(FetchElm(RetNo, 'ACAPD', 248));
      Tv[10] := Vl(FetchElm(RetNo, 'ACAPD', 249));
      Tv[11] := Vl(FetchElm(RetNo, 'ACAPD', 250));

      Tv[12] := Vl(FetchElm(RetNo, 'ACAPD', 375));
      Tv[13] := Vl(FetchElm(RetNo, 'ACAPD', 483));
      Tv[14] := Vl(FetchElm(RetNo, 'ACAPD', 484));
      Tv[15] := Vl(FetchElm(RetNo, 'ACAPD', 376));

      Tv[16] := Vl(FetchElm(RetNo, 'ACAPD', 421));
      Tv[17] := Vl(FetchElm(RetNo, 'ACAPD', 487));
      Tv[18] := Vl(FetchElm(RetNo, 'ACAPD', 488));
      Tv[19] := Vl(FetchElm(RetNo, 'ACAPD', 422));

      Tv[20] := Vl(FetchElm(RetNo, 'ACAPD', 443));
      Tv[21] := Vl(FetchElm(RetNo, 'ACAPD', 491));
      Tv[22] := Vl(FetchElm(RetNo, 'ACAPD', 492));
      Tv[23] := Vl(FetchElm(RetNo, 'ACAPD', 444));

      Tv[24] := Vl(FetchElm(RetNo, 'ACAPD', 530));
      Tv[25] := Vl(FetchElm(RetNo, 'ACAPD', 531));
      Tv[26] := Vl(FetchElm(RetNo, 'ACAPD', 532));
      Tv[27] := Vl(FetchElm(RetNo, 'ACAPD', 533));
      Tv[28] := Vl(FetchElm(RetNo, 'ACAPD', 534));

      Tv[30] := Vl(FetchElm(RetNo, 'ACAPD', 679));
      Tv[31] := Vl(FetchElm(RetNo, 'ACAPD', 681));
      Tv[32] := Vl(FetchElm(RetNo, 'ACAPD', 683));
      // 20140505
      Tv[45] := Round(Tv[44] / 2);
      Tv[38] := Tv[45] + Tv[46];
      Tv[49] := Round(Tv[47] / 2);
      Tv[39] := Tv[49] + Tv[48]; // 20140506
      // Tv[38]:=Vl(FetchElm(RetNo,'ACAPD',674)); //Vl(FetchElm(RetNo,'ACAPD_5',14));
      // Tv[39]:=Vl(FetchElm(RetNo,'ACAPD',677));//Vl(FetchElm(RetNo,'ACAPD_5',17));
      Tv[34] := Tv[38] + Tv[39];
    end;
    Strings[37] := FetchAlbInclusionRateString(RetNo);
    i := 4;
    Repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
      Inc(i, 4);
    until i > 24;
    If Tv[23] < 0 then
      Tv[23] := 0;

    Tv[29] := AddColumns(7, 23, 4);
    If Tv[27] > 0 then
      Tv[29] := Tv[29] + Tv[27];
    If (Tv[27] > 0) and (Tv[27] > Tv[28]) then
      Tv[29] := Tv[29] - Tv[28];

    Tv[33] := Tv[29] + Tv[30] + Tv[31] - Tv[32]; { ? fetch them }
    Tv[34] := Tv[38] + Tv[39];
    Tv[35] := Tv[33] - Tv[34];

    Tv[36] := Round(MaxR(0, Tv[35] * Vl(Ret[RetNo].Frm[FNo].Strings[37])));
  end; { end with }
  // pg2 -------------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    If UpperCase(FetchElm(RetNo, 'AS18', 3)) <> 'Y' // ???
    then
    begin
      { copy from federal }
      For i := 104 to 166 do
      begin
        Strings[i] := FetchElm(RetNo, 'S6', i + 500); // PG4 OF S6
        Tv[i] := Vl(FetchElm(RetNo, 'S6', i + 500)); // PG4 OF S6
      end;
    end;
    FillAlbHeader(RetNo, FNo, 101, 102);

    Tv[167] := 0;
    Tv[168] := 0;
    Tv[169] := 0;
    Tv[170] := 0;

    i := 107;
    Repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2]; { Tv[I+1]+Tv[i+2]-TV[i]; }
      If Tv[i + 3] > 0 then
        Tv[i + 3] := 0;
      Tv[167] := Tv[167] + Tv[i];
      Tv[168] := Tv[168] + Tv[i + 1];
      Tv[169] := Tv[169] + Tv[i + 2];
      Tv[170] := Tv[170] + Tv[i + 3];
      Inc(i, 7);
    until i > 163;
    Tv[172] := Round(Tv[170] * Vl(FetchAlbInclusionRateString(RetNo)));
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

// 20140526
Procedure AS20(RetNo: Integer; FName: string; FNo: Integer);
Var
  i, ii, k, seqCnt: Integer;
  Yend: String;
  As20WSFno: Integer;
begin
  As20WSFno := GetFormNo('AS20WS');
  seqCnt := 0;
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    If (Ret[RetNo].Province = 'AB') or (GetTxblIncomeInProv(RetNo, 'AB') > 0)
    then
      // ok
    else
    begin
      For i := 101 to 123 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end; // moved from below pg2
      SaveTv(RetNo, FName, FNo);
      EXIT;
    end;

    If Strings[22] = '' then
      Strings[22] := 'N';
    // pick up from Federal
    If UpperCase(Strings[22]) <> 'Y' then
    begin
      { copy from federal }
      For i := 3 to 7 do
        Tv[i] := Vl(FetchElm(RetNo, 'S2', i - 1));
      For i := 13 to 17 do
        Tv[i] := Vl(FetchElm(RetNo, 'S2', i));
    end;

    Tv[3] := MaxR(0, Vl(FetchElm(RetNo, 'AS20WS', 234)) -
      Vl(FetchElm(RetNo, 'AS20WS', 230)) - Vl(FetchElm(RetNo, 'AS20WS', 340)));
    Tv[4] := Vl(FetchElm(RetNo, 'AS20WS', 207)) +
      Vl(FetchElm(RetNo, 'AS20WS', 341));

    FillAlbHeader(RetNo, FNo, 1, 2);
    If Strings[22] = '' then
      Strings[22] := 'N';
    Tv[6] := Vl(FetchElm(RetNo, 'S2', 5)); // 20140525  //transfers
    Tv[7] := Vl(FetchElm(RetNo, 'AS20WS', 230)); // 20140616
    Tv[5] := MaxR(0, Tv[3] - Tv[4]);
    Tv[8] := Tv[6] + Tv[7];

    Tv[24] := Vl(FetchElm(RetNo, 'S2', 28)); // adjustments
    Tv[9] := MaxR(0, Tv[5] + Tv[8] - Tv[24]);


    // Tv[10]:=MaxR(0,MinR(MinR(Tv[9],Tv[21]),GetAlbNetInc(RetNo))); //20120530
    // Vl(FetchElmFNo(RetNo,AS20wsFNo,235));

    If UpperCase(Strings[23]) = 'Y' then
      Tv[10] := MaxR(0, MinR(Tv[10], GetAlbNetInc(RetNo)))
    else
      Tv[10] := MaxR(0, MinR(MinR(Tv[9], Tv[21]), GetAlbNetInc(RetNo)));

    Tv[11] := MaxR(0, Tv[9] - Tv[10]);
    Tv[12] := Round(MaxR(0, GetAlbNetInc(RetNo) * 0.75));
    Tv[42] := MinR(Tv[16], Tv[17]);
    Tv[20] := Round((Tv[13] + Tv[14] + Tv[19]) * 0.25);
    Tv[21] := MaxR(0, Tv[12] + Tv[20]);
  end; { end with }
  // AS20 pg2 --------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 101, 102);
    If UpperCase(FetchElm(RetNo, 'AS20', 22)) <> 'Y' then
    begin
      { copy federal }
      Tv[103] := Vl(FetchElmFNo(RetNo, As20WSFno, 268)) -
        Vl(FetchElmFNo(RetNo, As20WSFno, 264)) +
        Vl(FetchElmFNo(RetNo, As20WSFno, 302)) -
        Vl(FetchElmFNo(RetNo, As20WSFno, 298)) +
        Vl(FetchElmFNo(RetNo, As20WSFno, 336)) -
        Vl(FetchElmFNo(RetNo, As20WSFno, 332));
      {
        Vl(FetchElm(RetNo,'S2',101))
        +Vl(FetchElm(RetNo,'S2',109))
        +Vl(FetchElm(RetNo,'S2',117));
      }
      Tv[104] := Vl(FetchElmFNo(RetNo, As20WSFno, 241)) +
        Vl(FetchElmFNo(RetNo, As20WSFno, 275)) +
        Vl(FetchElmFNo(RetNo, As20WSFno, 241)) +
        Vl(FetchElmFNo(RetNo, As20WSFno, 275));
      // Vl(FetchElm(RetNo,'S2',102));
      Tv[106] := Vl(FetchElm(RetNo, 'S2', 104)); // transfers
      // 20140616 Current year
      Tv[107] := Vl(FetchElm(RetNo, 'AS20WS', 264)) +
        Vl(FetchElm(RetNo, 'AS20WS', 298)) + Vl(FetchElm(RetNo, 'AS20WS', 332));
      { Vl(FetchElm(RetNo,'S2',105))
        +Vl(FetchElm(RetNo,'S2',113))
        +Vl(FetchElm(RetNo,'S2',121)); }
    end;
    Tv[105] := MaxR(0, Tv[103] - Tv[104]);
    Tv[108] := Tv[106] + Tv[107];
    Tv[112] := Vl(FetchElm(RetNo, 'S2', 28)); // adjustm
    Tv[109] := MaxR(0, Tv[105] + Tv[108] - Tv[112]);
    // warning //Tv[10] := MinR(Tv[9],GetTxblIncomeInProv(RetNo,'AB'));
    Tv[111] := MaxR(0, Tv[109] - Tv[110]);

    // carry  forward //20140510
    seqCnt := 0; // 20150511
    i := 27;
    k := 5;
    ii := 71;
    Yend := FetchElm(RetNo, 'AT1', 14);
    Repeat
      Strings[i] := GetPrevYearEnd(Yend, k);
      // 20150510
      If Tv[i + 1] + Tv[i + 2] + Tv[i + 3] + Tv[i + 4] > 0 then
      begin
        Inc(seqCnt); // 20150511
        Strings[ii] := IntToStr(seqCnt);
        If Strings[ii] = '0' then
          Strings[ii] := ''; // 20150510
      end
      Else
        Strings[ii] := '';

      i := i + 6;
      ii := ii + 1;
      k := k - 1;
    until i > 57;

    If UpperCase(Strings[25]) <> 'Y' then // 20140416
    Begin
      // get ending balances
      i := 28;
      k := 208; // charitb
      Repeat
        Tv[i] := Vl(FetchElmFNo(RetNo, As20WSFno, k));
        i := i + 6;
        k := k + 5;
      until i > 58;

      i := 29;
      k := 242; // gifts to can
      Repeat
        Tv[i] := Vl(FetchElmFNo(RetNo, As20WSFno, k));
        i := i + 6;
        k := k + 5;
      until i > 59;

      i := 30;
      k := 276; // certif cultural
      Repeat
        Tv[i] := Vl(FetchElmFNo(RetNo, As20WSFno, k));
        i := i + 6;
        k := k + 5;
      until i > 69;

      i := 31;
      k := 310; // ecological
      Repeat
        Tv[i] := Vl(FetchElmFNo(RetNo, As20WSFno, k));
        i := i + 6;
        k := k + 5;
      until i > 70;
    end;

    For i := 64 to 68 do
    Begin
      Tv[i] := 0;
    end;

    // add the table totals
    For k := 0 to 4 do
      Tv[64 + k] := AddColumns(28 + k, 58 + k, 6);
  end; { end with }
  SaveTv(RetNo, FName, FNo);
end;

(* 20140526
  Procedure AS20(RetNo:integer;FName:string;FNo:integer);
  Var i,k:Integer; Yend:String;
  begin
  LoadTv (RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
  If (Ret[RetNo].Province= 'AB')
  or (GetTxblIncomeInProv(RetNo,'AB') >0)
  then
  //ok
  else
  begin
  For i:=101 to 123 do begin Strings[i]:='';Tv[i]:=0;end; //moved from below pg2
  SaveTv(RetNo,FName,FNo);
  Exit;
  end;

  If Strings[22] ='' then Strings[22] :='N';
  If UpperCase(Strings[22]) <> 'Y' then
  begin
  {copy from federal}
  For i:=3 to 7 do Tv[i] := Vl(FetchElm(RetNo,'S2',i-1));
  For i:=13 to 17 do Tv[i] := Vl(FetchElm(RetNo,'S2',i));
  end;

  FillAlbHeader(RetNo,FNo,1,2);
  If Strings[22] = '' then Strings[22] :='N';
  Tv[6] := Vl(FetchElm(RetNo,'S2',5)); //20140525
  Tv[5] := MaxR(0,Tv[3]-Tv[4]);
  Tv[8] := Tv[6]+Tv[7];

  Tv[24]:=Vl(FetchElm(RetNo,'S2',28));
  Tv[9] := MaxR(0,Tv[5]+Tv[8]-Tv[24]);
  If UpperCase(Strings[23]) = 'Y' then
  Tv[10]:= MaxR(0,MinR(Tv[10],GetAlbNetInc(RetNo)))
  else
  Tv[10] := MaxR(0,MinR(MinR(Tv[9],Tv[21]),GetAlbNetInc(RetNo)));

  Tv[11] := MaxR(0,Tv[9] - Tv[10]);
  Tv[12]:= Round(MaxR(0,GetAlbNetInc(RetNo)* 0.75));
  Tv[42] := MinR(Tv[16],Tv[17]);
  Tv[20] := Round((Tv[13]+tv[14]+Tv[19]) * 0.25);
  Tv[21] := MaxR(0,Tv[12]+tv[20]);
  end; { end with}
  //AS20 pg2 --------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
  FillAlbHeader(RetNo,FNo,101,102);
  If UpperCase(FetchElm(RetNo,'AS20',22)) <> 'Y' then
  begin
  {copy federal}
  Tv[103] := Vl(FetchElm(RetNo,'S2',101))
  +Vl(FetchElm(RetNo,'S2',109))
  +Vl(FetchElm(RetNo,'S2',117));
  Tv[104] := Vl(FetchElm(RetNo,'S2',102));
  Tv[106] := Vl(FetchElm(RetNo,'S2',104));
  //20140524
  Tv[107] := Vl(FetchElm(RetNo,'S2',105))
  +Vl(FetchElm(RetNo,'S2',113))
  +Vl(FetchElm(RetNo,'S2',121));
  end;
  Tv[105] := MaxR(0,Tv[103]-Tv[104]);
  Tv[108] := Tv[106]+Tv[107];
  Tv[112]:=Vl(FetchElm(RetNo,'S2',28));
  Tv[109] := MaxR(0,Tv[105]+Tv[108] - Tv[112]);
  //warning //Tv[10] := MinR(Tv[9],GetTxblIncomeInProv(RetNo,'AB'));
  Tv[111] := MaxR(0,Tv[109] -Tv[110]);

  //carry  forward //20140510
  i:=27;k:=5;
  YEnd:=FetchElm(RetNo,'AT1',14);
  Repeat
  Strings[i]:=GetPrevYearEnd(Yend,K);
  i:=i+6;
  k:=k-1;
  until i>57;

  For i:=64 to 68 do Begin Tv[i]:=0;end;
  //add the table totals
  For k:=0 to 4 do Tv[64+k]:=AddColumns(28+k,58+k,6);

  end; { end with}
  SaveTv (RetNo, Fname, FNo);
  end;
*)

Procedure AS21(RetNo: Integer; FName: string; FNo: Integer);
// Var i,j,jj,k,S4FNo,S4WSFNo,SeqCnt,ii:Integer; //20150703
Var
  i, j, jj, k, S4FNo, S4WSFNo, i1: Integer;
  // 20150701 - i1 for small loop below
  Yend: String;
  seqCnt, ii: Integer; // 20150703
begin
  S4FNo := GetFormNo('S4');
  S4WSFNo := GetFormNo('S4WS');
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 1, 2);

    // make sure unsused tvs are zero
    i := 385;
    repeat
      Tv[i] := 0;
      Inc(i, 5);
    until i > 450; // 20140621

    If Strings[28] = '' then
      Strings[28] := 'N';
    If UpperCase(Strings[28]) <> 'Y' then // no diffrence comes from Fed
    begin
      Tv[41]:=Tv[53]; //20260727
      { copy from federal }
      Tv[5] := Vl(FetchElm(RetNo, 'T2', 219));
      Tv[6] := Vl(FetchElm(RetNo, 'T2', 220));
      Tv[7] := Vl(FetchElm(RetNo, 'T2', 227));

      Tv[30] := Vl(FetchElm(RetNo, 'T2', 228));
      Tv[10] := Vl(FetchElm(RetNo, 'T2', 231));
      Tv[11] := Vl(FetchElm(RetNo, 'S4', 13));
      // T2',213));//Vl(FetchElm(RetNo,'T2',213)); //20110523

      Tv[13] := Vl(FetchElm(RetNo, 'S4', 15));
      Tv[16] := Vl(FetchElm(RetNo, 'S4', 16)); // 20201208  expired losses
      Tv[17] := Vl(FetchElm(RetNo, 'AS10', 25));
      // Vl(FetchElm(RetNo,'S4',33)); //20110523
      Tv[23] := Vl(FetchElm(RetNo, 'S4', 18));
      Tv[31] := Vl(FetchElm(RetNo, 'S4', 21));
      Tv[33] := Vl(FetchElm(RetNo, 'S4', 23));
      Tv[34] := Vl(FetchElm(RetNo, 'S4', 24));

      Tv[14] := Vl(FetchElm(RetNo, 'S4', 101));
      Tv[15] := Vl(FetchElm(RetNo, 'S4', 108));
      Tv[18] := Vl(FetchElm(RetNo, 'S4', 102));
      If Vl(FetchElm(RetNo, 'AS18', 35)) < 0 then
        Tv[22] := Abs(Vl(FetchElm(RetNo, 'AS18', 33)))
        // net cap loss //20201208
        // Tv[22] := ABS(Vl(FetchElm(RetNo,'AS18',35)))
      else
        Tv[22] := 0;
      Tv[25] := Vl(FetchElm(RetNo, 'AS10', 28));
      { Vl(FetchElm(RetNo,'S4',115)); }
      Tv[26] := Vl(FetchElm(RetNo, 'S4', 106));
      Tv[21] := Vl(FetchElm(RetNo, 'S4', 109));
      Tv[27] := Vl(FetchElm(RetNo, 'S4', 110));
    end
    Else // alb differ
    Begin // different
      Tv[13] := Tv[338];
      Tv[22] := Abs(Vl(FetchElm(RetNo, 'AS18', 33))); // net cap loss //20201208
      // Tv[16] := Tv[7];  expired losses //20201208
      Tv[31] := Tv[340];

    end;

    FillAlbHeader(RetNo, FNo, 101, 102);
    Tv[3] := GetAlbNetInc(RetNo);
    Tv[8] := Tv[41]+ Tv[4] + Tv[5] + Tv[6] + Tv[30] +Tv[42];  //20260727
    Tv[9] := Tv[3] - Tv[8];
    If Tv[9] > 0 then
      Tv[9] := 0;
    Tv[12] := Tv[9] - Tv[10] + Tv[11];
    If Tv[12] > 0 then
      Tv[12] := 0;
    If UpperCase(FetchElm(RetNo, 'AS21', 28)) = 'Y' then
    begin
      Tv[17] := Vl(FetchElm(RetNo, 'AS10', 25));
      Tv[25] := Vl(FetchElm(RetNo, 'AS10', 28));
    end;
    Tv[20] := MaxR(0, Tv[13] - Tv[16]);
    Tv[29] := Abs(Tv[12]);
    Tv[32] := Tv[20] + Tv[23] + Tv[29];
    Tv[35] := Tv[14] + Tv[18] + Tv[22] + Tv[26];
    Tv[19] := MaxR(0, Tv[32] - Tv[31] - Tv[33] - Tv[34] - Tv[17]);

    Tv[24] := MaxR(0, Tv[35] - Tv[15] - Tv[21] - Tv[27] - Tv[25]);
  end; { end with }
  // AS21 pg2 --------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    If UpperCase(FetchElm(RetNo, 'AS21', 28)) <> 'Y' then
    begin
      { copy federal }
      { farm losses }
      Tv[103] := Vl(FetchElm(RetNo, 'S4', 117));
      Tv[105] := Vl(FetchElm(RetNo, 'S4', 118));
      Tv[109] := Vl(FetchElm(RetNo, 'S4', 120));
      Tv[111] := Vl(FetchElm(RetNo, 'S4', 121));
      Tv[117] := Vl(FetchElm(RetNo, 'AS10', 25));
      // 20110523  //Vl(FetchElm(RetNo,'S4',125));
      Tv[119] := Vl(FetchElm(RetNo, 'S4', 126));
      Tv[121] := Vl(FetchElm(RetNo, 'AS10', 26));
      // Vl(FetchElm(RetNo,'S4',145)); //20110523
      { Restricted losss }
      Tv[104] := Vl(FetchElm(RetNo, 'S4', 201));
      Tv[106] := Vl(FetchElm(RetNo, 'S4', 202));
      Tv[110] := Vl(FetchElm(RetNo, 'S4', 204));
      If FetchElm(RetNo, 'AS10', 4) > '' then
        Tv[112] := Vl(FetchElm(RetNo, 'S4', 205))
      Else
        Tv[112] := 0;
      Tv[118] := Vl(FetchElm(RetNo, 'S4', 208));
      Tv[120] := Vl(FetchElm(RetNo, 'S4', 209));
      If FetchElm(RetNo, 'AS10', 4) > '' then
        Tv[122] := Vl(FetchElm(RetNo, 'AS10', 27))
        // Vl(FetchElm(RetNo,'S4',215));
      Else
        Tv[122] := 0;
      { listed pers losses }
      Tv[125] := Vl(FetchElm(RetNo, 'S4', 217));
      Tv[126] := Vl(FetchElm(RetNo, 'S4', 218));
      Tv[128] := Vl(FetchElm(RetNo, 'S4', 220));
      If Vl(FetchElm(RetNo, 'AS18', 128)) > 0 then
        Tv[130] := Vl(FetchElm(RetNo, 'AS18', 28))
      else
        Tv[130] := Vl(FetchElm(RetNo, 'S4', 222));

      Tv[131] := Vl(FetchElm(RetNo, 'S4', 223));
      If FetchElm(RetNo, 'AS10', 5) > '' then
        Tv[132] := Vl(FetchElm(RetNo, 'AS10', 31))
        // Vl(FetchElm(RetNo,'S4',230));  //20110523
      Else
        Tv[132] := 0;

      { lim continuity }
      i := 134;
      j := 372;
      Repeat
        Strings[i] := FetchElm(RetNo, 'S4', j);
        Tv[i] := Vl(FetchElm(RetNo, 'S4', j));
        Tv[i + 1] := Vl(FetchElm(RetNo, 'S4', j + 1));
        Tv[i + 2] := Vl(FetchElm(RetNo, 'S4', j + 2));
        Tv[i + 3] := Vl(FetchElm(RetNo, 'S4', j + 3));
        Tv[i + 4] := Vl(FetchElm(RetNo, 'S4', j + 4));
        Tv[i + 5] := Vl(FetchElm(RetNo, 'S4', j + 5));
        Inc(i, 6);
        Inc(j, 7);
      until i > 158;
    end;
    FillAlbHeader(RetNo, FNo, 101, 102);
    Tv[107] := MaxR(0, Tv[103] - Tv[105]);
    Tv[113] := Tv[107] + Tv[109] + Tv[111];
    Tv[123] := MaxR(0, Tv[113] - Tv[115] - Tv[117] - Tv[119] - Tv[121]);

    Tv[108] := MaxR(0, Tv[104] - Tv[106]);
    Tv[114] := Tv[108] + Tv[110] + Tv[112];
    Tv[124] := MaxR(0, Tv[114] - Tv[116] - Tv[118] - Tv[120] - Tv[122]);

    Tv[127] := MaxR(0, Tv[125] - Tv[126]);
    Tv[129] := Tv[127] + Tv[128];
    Tv[133] := MaxR(0, Tv[129] - Tv[130] - Tv[131] - Tv[132]);

    Tv[164] := AddColumns(135, 159, 6);
    Tv[165] := AddColumns(136, 160, 6);
    Tv[166] := AddColumns(137, 161, 6);
    Tv[167] := AddColumns(138, 162, 6);
    Tv[168] := AddColumns(139, 163, 6);

    // pg 3  Non cap losses
    FillAlbHeader(RetNo, FNo, 36, 37);
    Yend := FetchElm(RetNo, 'AT1', 14);
    Strings[171] := Yend; // 20141121

    // For i:=338 to 341 do Tv[i]:=0; //totals
    For i1 := 338 to 341 do
      Tv[i1] := 0; // totals //20150701

    k := 0; // current year
    Strings[i] := IntToStr(k);
    Strings[i + 1] := GetPrevYearEnd(Yend, k);
    Tv[175] := Vl(FetchElm(RetNo, 'AS10', 25)); // loss carry back from alb

    // current year losses
    Tv[173] := Tv[29]; // 20201208 current year loss
    If UpperCase(FetchElm(RetNo, 'AS21', 28)) <> 'Y' then // no diff
    begin
      // Tv[173]:=Vl(FetchElmFNo(RetNo,S4WSFNo,649));  //20201208 //current yer loss
      // Tv[174]:=Vl(FetchElmFNo(RetNo,S4WSFNo,650));  //20201208 //adjustments
    end;
    Tv[177] := Tv[173] + Tv[174] - Tv[175];
    // 20201208  balance = 173=current year
    Tv[341] := Tv[341] + Tv[177];

    // other years
    seqCnt := 0; // 20150510  for rsi it needs the seq no of years in effect
    i := 178;
    ii := 471; // pointer to invisible column at the end;     //20150510
    k := 1;
    j := 641; // indexto S4Fws
    Repeat
      Strings[i] := IntToStr(k);
      Strings[i + 1] := GetPrevYearEnd(Yend, k);
      If UpperCase(FetchElm(RetNo, 'AS21', 28)) <> 'Y' then
      begin
        Tv[i + 2] := Vl(FetchElmFNo(RetNo, S4WSFNo, j + 1));
        Tv[i + 4] := Vl(FetchElmFNo(RetNo, S4WSFNo, j + 2));
        Tv[i + 6] := Vl(FetchElmFNo(RetNo, S4WSFNo, j + 3));
        If Vl(FetchElmFNo(RetNo, S4WSFNo, j + 5)) > 0 then // expired
        begin
          Tv[i + 2] := 0;
          Tv[i + 4] := 0;
          Tv[i + 6] := 0;
        end;
      end;

      Tv[i + 7] := MaxR(0, Tv[i + 2] + Tv[i + 4] - Tv[i + 6]); // 20201208
      If UpperCase(FetchElm(RetNo, 'AS21', 40)) <> 'Y' then
        // 20140621 to allow override on the origin noncapital losses balance (account for expired)
        Tv[i + 7] := MaxR(0, Tv[i + 2] + Tv[i + 4] - Tv[i + 6]); // 20201208
      // Tv[i+7]:=MaxR(0,Tv[i+2]+Tv[i+3]+Tv[i+4]-Tv[i+5]-Tv[i+6]);

      // 20150510
      If Tv[i + 2] + Tv[i + 4] + Tv[i + 6] + Tv[i + 7] > 0 then
      begin
        Inc(seqCnt);
        Strings[ii] := IntToStr(seqCnt);
        If Strings[ii] = '0' then
          Strings[ii] := ''; // 20150510
      end
      Else
        Strings[ii] := '';

      Tv[338] := Tv[338] + Tv[i + 2];
      Tv[339] := Tv[339] + Tv[i + 4];
      Tv[340] := Tv[340] + Tv[i + 6];
      Tv[341] := Tv[341] + Tv[i + 7];
      i := i + 8;
      ii := ii + 1;
      k := k + 1;
      j := j - 7;
    until i > 330;

    // Pg4
    FillAlbHeader(RetNo, FNo, 38, 39);
    For i := 453 to 455 do
      Tv[i] := 0; // totals
    // other years
    seqCnt := 0;
    i := 346;
    ii := 491; // index of the invisible last column
    k := 0;
    j := 633;
    Repeat
      Strings[i] := IntToStr(k);
      Strings[i + 1] := GetPrevYearEnd(Yend, k);
      // 20150520
      If Tv[i + 2] + Tv[i + 3] + Tv[i + 4] > 0 then
      begin
        Inc(seqCnt);
        Strings[ii] := IntToStr(seqCnt);
        If Strings[ii] = '0' then
          Strings[ii] := ''; // 20150520
      end
      Else
        Strings[ii] := '';

      Tv[453] := Tv[453] + Tv[i + 2];
      Tv[454] := Tv[454] + Tv[i + 3];
      Tv[455] := Tv[455] + Tv[i + 4];
      i := i + 5;
      ii := ii + 1;
      k := k + 1;
      j := j - 7
    until i > 446;

    //page 5 RIFE  //20260727
    //prior years
    //Tv[49]:=Tv[43]+Tv[44]-Tv[45];
    //Tv[50]:= Vl(FetchElm(RetNo,'S130',370));
    //Tv[51]:= Vl(FetchElm(RetNo,'S130',371));
    //Tv[52]:=??
    Tv[53]:=MinR(Tv[49],Tv[52]);

    Tv[46]:=Vl(FetchElm(RetNo,'S4',51));
    if Tv[47]>Tv[53] then Tv[47]:=Tv[53];
   // Tv[48]:=Tv[43]-  ???
  end; { end with }
  SaveTv(RetNo, FName, FNo);
end;


Procedure AS29(RetNo: Integer; FName: string; FNo: Integer);
Var
  i, j, k, m, AS29LFno: Integer;
  BaseAmount: Real;
  IEGAssociated: Boolean;
  x, tempAmount: real;
  //NetIEG: Real;
  //Step1: Boolean; //20250621
  allowedAmount: real;
  lesserline031andline108:real;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    if GetTaxationYearEnd(RetNo) < '2021/01/01' then
    Begin
      for i := 1 to 166 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      SaveTv(RetNo, FName, FNo);
      EXIT;
    end;

    // Pg1 ---- Pg1 ---- Pg1 ---- Pg1 ---- Pg1 ---- Pg1 ---- Pg1 ---- Pg1 ---- Pg1

    Strings[3] := GetCorpName(RetNo);
    Strings[1] := GetAlbAccNo(RetNo);
    Strings[2] := GetTaxationYearEnd(RetNo);

    {//202250621
    if Strings[146] > '' then
      Step1 := True
    else
      Step1 := False;
    }

    //20261005 Alex >>>
    //Tv[4] := MaxR(0, Vl(FetchElm(RetNo, 'T661', 121)) - Vl(FetchElm(RetNo, 'T661', 122))); // 20210714 // Vl(FetchElm(RetNo,'T661',168)); //-Vl(FetchElm(RetNo,'AS9L',149))--Vl(FetchElm(RetNo,'AS9L',151)); //20210713  deduct Other prov and  proxy 5.5
    if GetTaxationYearEnd(RetNo) < '2024/12/16' then //taxation years ending before December 16, 2024
      Tv[4]:= MaxR(0, Vl(FetchElm(RetNo, 'T661', 168))) //line 559 of T661
    else
    if GetTaxationYearEnd(RetNo) > '2024/12/15' then //taxation years ending after December 15, 2024
      Tv[4]:= MaxR(0, Vl(FetchElm(RetNo, 'T661', 331))); //line 557 of T661
    //20261005 Alex <<<

    AS29LFno := GetFormNo('AS29L'); // for Tv[5]

    if IsABStep1(RetNo) = True then
    Begin
     Tv[4] := 0; //202250621 // 20210710//if Step1 = True then Tv[4] := 0; // 20210710
     Tv[5] := Vl(FetchElmFNo(RetNo, AS29LFno, 148));//20250622B  //alberta//Vl(FetchElmFNo(RetNo, AS29LFno, 156)); //alberta
     Tv[8] := 0;  //Vl(FetchElm(RetNo, 'AT1', 74));  //Vl(FetchElm(RetNo, 'T661', 122));
     Tv[10]:=Tv[5];    //questinable CZ
    End
    Else   //after ALEX's
    if IsABStep2(RetNo) = True then
    Begin
     if IsAbStep2(RetNo) then Tv[5]:=Vl(FetchElmFNo(RetNo, AS29LFno, 156));  //20260703CZ
     // Tv[5] := Vl(FetchElmFNo(RetNo, AS29LFno, 148)); //alberta //not 156
      Tv[8] := ABNetIeg; //Vl(FetchElm(RetNo, 'AT1', 74));  //Vl(FetchElm(RetNo, 'T661', 122));
      Tv[10]:=Vl(FetchElmFNo(RetNo, AS29LFno, 156))+ABNetIeg;
    End
    Else if IsABStep3(RetNo) = True then
    Begin
      //Tv[5] := Vl(FetchElmFNo(RetNo, AS29LFno, 148)); //alberta //not 156
    End;
    {
    Else if IsABStep2(RetNo) = True then
    Begin
      //Tv[4] := 0; //202250621 // 20210710//if Step1 = True then Tv[4] := 0; // 20210710
      Tv[5] := Vl(FetchElmFNo(RetNo, AS29LFno, 148)); //alberta //not 156
      Tv[8] := ABNetIeg; //Vl(FetchElm(RetNo, 'AT1', 74));  //Vl(FetchElm(RetNo, 'T661', 122));
      Tv[10]:=Vl(FetchElmFNo(RetNo, AS29LFno, 156))+ABNetIeg;
    End
    Else if IsABStep3(RetNo) = True then
    Begin
      Tv[5] := Vl(FetchElmFNo(RetNo, AS29LFno, 148)); //alberta //not 156
    End;
    }


    Tv[6]:=Vl(FetchElmFNo(RetNo, AS29LFNo, 151)); // ////Vl(FetchElm(RetNo, 'T661', 141)); //fed proxy
    Tv[7]:=Tv[6];  //alb proxy?

    //Tv[10]:=Vl(FetchElmFNo(RetNo, AS29LFno, 3))+Tv[9]; //current corporation //20250621
    { //20250621
    // Calc rest of alb portion Line 005  //20210711
    i := 172; //second line of AS29L line 105
    k := 3;
    Repeat
      //If UpperCase(FetchElmFNo(RetNo, AS29LFno, i)) = 'Y' then //20250620 removed too old
      Tv[5] := Tv[5] + Vl(FetchElmFNo(RetNo, AS29LFno, k));
      Inc(i, 1);
      Inc(k, 7);
    Until i > 191;
   }


    //if IsABStep1(RetNo) = False then Tv[5] := MaxR(0, Tv[5] - Vl(FetchElm(RetNo, 'AT1', 74))); // exclude ieg //20250621
    //if Step1 = False then Tv[5] := MaxR(0, Tv[5] - Vl(FetchElm(RetNo, 'AT1', 74))); // exclude ieg
   //Tv[6], Tv[7] user input
   // 20210711
   //Tv[7] user input

    //if IsAbStep1(RetNo) = True then Tv[10] := Tv[5] - Tv[6] + Tv[7] + Tv[8] + Tv[9];

    if (Strings[11] < '1') or (Strings[11] > '4') then
      Strings[11] := '';

    // END Pg1 ----

    // Pg2 ---- Pg2 ---- Pg2 ---- Pg2 ---- Pg2 ---- Pg2 ---- Pg2 ---- Pg2 ---- Pg2

    if Strings[12] + Strings[13] = '' then
      Strings[13] := 'X';

    IEGAssociated := Strings[12] > '';

    if IEGAssociated then // associated
    Begin
      Tv[14] := Tv[53];  //line 102
      Tv[15] := 0;       //line 104 // 20210602
    end
    Else // Not associated
    Begin
      Strings[46] := IntToStr(GetNumDays(RetNo, '31-12-2020', 'A'));
      // 20210706 //IntToStr(Ret[RetNo].DaysInYear);
      if Strings[46] > '366' then
        Strings[46] := '366';
      Strings[47] := '365';

      //account for leap years //jz 20241130 clean up multiple if statments with one
      If (DateWithinTaxYear('2020/02/29', RetNo) = True) or (DateWithinTaxYear('2024/02/29', RetNo) = True) or
         (DateWithinTaxYear('2028/02/29', RetNo) = True) or (DateWithinTaxYear('2032/02/29', RetNo) = True)
      then
        Strings[47] := '366';

      Tv[15] := Round(4000000 * (Vl(Strings[46]) / Vl(Strings[47])));
    End; // end Not associated else

    //line 108
    if IEGAssociated then
      Tv[16] := Tv[14] // associated  from table below //20210712
    Else // Not associated
      Tv[16] := Tv[15]; //from line 104 // 20210723


    //Emploment Grant calc pg 2 start -----------

    Lesserline031andline108 := MinR(Tv[10], Tv[16]);  //jz 20241130 change var from x for readability   //x := MinR(Tv[10], Tv[16]);
    Tv[48] := lesserLine031andLine108; //x;
    Tv[17] := Round(lesserLine031andLine108 * 8 / 100); // MinR(Tv[10],Tv[16]) * 8/100;

    BaseAmount := 0;
    if Not IEGAssociated then
    Begin
            Tv[21] := Round((Tv[19] + Tv[20]) / 2);
            BaseAmount := Tv[21];
            Tv[49] := lesserLine031andLine108; //x;
            Tv[50] := BaseAmount;
            Tv[18] := Round((MaxR(0, lesserLine031andLine108 - BaseAmount)) * 12 / 100);
            Tv[25]:=0; //20250618 //Tv[250] := 0;
           // Tv[25]:=Vl(FetchElm(RetNo,'S33',114));  //20250609  Box 126
    End
    Else
    Begin // IS associated
            allowedAmount := Tv[247];
            Tv[25] := Tv[167]; //20250818
             //line 125 from line 325 //jz 20241129
           // Tv[250] := MinR(Tv[16], allowedAmount) * 12/100; //line 125 from line 325 //jz 20241129
            Tv[49] := 0;Tv[50] := 0;Tv[18] := 0;
    End;

    Strings[26] := FormatFloat('##0.00000', (40000000 - (Tv[25] - 10000000)) / 40000000);
   // Tv[26] := Vl(Strings[26]);  //jz//VT50//20250622

    if Tv[25] <= 10000000 then
    Begin
      Strings[26] := '1.00000';
      //Tv[26] := 1; //jz//VT50//20250622
    end;

    if Not IEGAssociated then
      Tv[27] := (Tv[17] + Tv[18])  * vl(strings[26])
       //* Tv[26] //jz//VT50//20250622 - change to use strings[26] rather than TV[26] //jz 20241130
    else // IS associated
      Tv[27] := (Tv[17] + Tv[250]) * vl(strings[26]);
      //* Tv[26]//jz//VT50//20250622 -  change to use strings[26] rather than TV[26]//jz 20241130
   {
    if Not IEGAssociated then
      Tv[27] := (Tv[17] + Tv[18]) * Tv[26]    //jz 20241130
    else // IS associated
      Tv[27] := (Tv[17] + Tv[250]) * Tv[26];  //jz 20241130
   }
    ABIEG:=Tv[27];

    Tv[29] := MaxR(0, Tv[27] - Tv[28]);
    AbNetIEG := Tv[29]; //Line 134

    // END Pg2 ----   // Pg3 ---- Pg3 ---- Pg3 ---- Pg3 ---- Pg3 ---- Pg3 ---- Pg3 ---- Pg3 ----
    Strings[30] := GetAlbAccNo(RetNo);
    Strings[31] := GetTaxationYearEnd(RetNo);

    if IEGAssociated then
    Begin
      If Strings[33] = '' then
        Strings[33] := FetchElm(RetNo, 'AT1', 11);
      If Strings[34] = '' then
        Strings[34] := FetchElm(RetNo, 'AT1', 14);
      Strings[35] := IntToStr(Ret[RetNo].DaysInYear - GetNumDays(RetNo,
        '01-01-2021', 'B')); // 20210604
      if Vl(Strings[35]) < 0 then
        Strings[35] := '';

      if Vl(Strings[35]) > 366 then
        Strings[35] := '366';
      Strings[36] := Strings[35];
      Tv[37] := (4000000 * Vl(Strings[36]) / Vl(Strings[35]));
      /// 365;  //20210604

      //clear totals

      Tv[38]  := 0; //line 270
      Tv[39]  := 0; //line 280
      Tv[40]  := 0; //line 290
      Tv[167] := 0; //line 300
      Tv[206] := 0; //line 275
      Tv[226] := 0; //line 310
      Tv[246] := 0; //line 320

      Strings[51]  := FetchElm(RetNo, 'T2', 1);   // This BN
      Strings[52]  := FetchElm(RetNo, 'AT1', 9);  // This Alb Account
      Strings[168] := FetchElm(RetNo, 'AT1', 14); // This Current Year End

      //
      i := 53;
      j := 148; // 20211025
      k := 207; m := 0; //jz 20241130

      Tv[38] := 4000000; // 20210712
      x := 0;
      repeat
        If i <> 53 then
          x := x + Tv[i]; // ignore the first row for allocation
        Tv[39] := Tv[39] + Tv[i + 1];
        Tv[40] := Tv[40] + Tv[i + 2];
        Tv[167] := Tv[167] + Tv[j];

        //line 267
        tempAmount := Tv[187 + m] - ( (Tv[54 + m*5] + Tv[55 + m*5]) / 2); //jz 20241130
        if Tv[187 + m] = 0 then
          Tv[k] := MaxR(0 , tempAmount) //do not allow to be negative //jz 20241130
        else
          Tv[k] := tempAmount;


        //line 268 - cant be mnore than line 267 and not negative
        if Tv[k + 20] > 0 then
          Tv[k + 20] := MinR(Tv[k], Tv[k + 20])
        else if Tv[k + 20] <= 0 then
          Tv[k + 20] := 0;

        Inc(i, 5);
        Inc(j, 1);
        Inc(k, 1); Inc(m, 1);
      until i > 143;

      Tv[53] := Tv[38] - x; // not negative //20210712

      Tv[206] := AddColumns(187, 205, 1); //line 275
      Tv[226] := AddColumns(207, 225, 1); //line 310

      Tv[246] := AddColumns(227, 245, 1); //line 320
      if Tv[246] > 0 then Tv[246] := MinR(Tv[226],Tv[246]);   //as per line 320 note

      Tv[247] := Tv[227];
    end
    Else // not associated for IEG so zero it out //20210602
    Begin
      for i := 32 to 40 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      for i := 51 to 145 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      for i := 148 to 247 do //jz 20241130 zero out new columns
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
    End;


    If Strings[41] = '' then
      Strings[41] := FetchElm(RetNo, 'AT1', 130); // last nm
    If Strings[43] = '' then
      Strings[43] := FetchElm(RetNo, 'AT1', 131); // first nm
    If Strings[42] = '' then
      Strings[42] := FetchElm(RetNo, 'AT1', 132); // title
    If Strings[44] = '' then
      Strings[44] := FetchElm(RetNo, 'AT1', 30); // telephone
    If Strings[45] = '' then
      Strings[45] := FetchElm(RetNo, 'AT1', 133); // title
  end; { end with }

  SaveTv(RetNo, FName, FNo);

  // Store the IEG in At1
  If IsAbStep1(RetNo) = True then
    StoreElm(RetNo, GetFormNo('AT1'), 74, FormatFloat('#########', AbNetIEG));
  // 20210711
  // 20210712
  If IsABStep1(RetNo) = False then // (final
  Begin
    Calc(RetNo, 'T661');
    T2(RetNo, 'T2', T2FNo);
  End;

  // 20210712    CAUSES LOOP
  // CalcFed(RetNo);
  // CalcAlb(RetNo);
  // 20210710

end;




(* //abandoned //20251121 Had no good revisions by Cona
Procedure AS29(RetNo: Integer; FName: string; FNo: Integer);
Var
  i, j, k, m, AS29LFno: Integer;
  BaseAmount: Real;
  IEGAssociated: Boolean;
  x, tempAmount: real;
  //NetIEG: Real;
  //Step1: Boolean; //20250621
  allowedAmount: real;
  lesserline031andline108:real;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    if GetTaxationYearEnd(RetNo) < '2021/01/01' then
    Begin
      for i := 1 to 166 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      SaveTv(RetNo, FName, FNo);
      EXIT;
    end;

    // Pg1 ---- Pg1 ---- Pg1 ---- Pg1 ---- Pg1 ---- Pg1 ---- Pg1 ---- Pg1 ---- Pg1

    Strings[3] := GetCorpName(RetNo);
    Strings[1] := GetAlbAccNo(RetNo);
    Strings[2] := GetTaxationYearEnd(RetNo);

    {//202250621
    if Strings[146] > '' then
      Step1 := True
    else
      Step1 := False;
    }


    //Tv[4] := MaxR(0, Vl(FetchElm(RetNo, 'T661', 121)) - Vl(FetchElm(RetNo, 'T661', 122))); //20251120
            // 20210714 // Vl(FetchElm(RetNo,'T661',168)); //-Vl(FetchElm(RetNo,'AS9L',149))--Vl(FetchElm(RetNo,'AS9L',151)); //20210713  deduct Other prov and  proxy 5.5

    AS29LFno := GetFormNo('AS29L'); // for Tv[5]

    //20251120 moved from below
    Tv[6]:=Vl(FetchElmFNo(RetNo, AS29LFNo, 151)); // ////Vl(FetchElm(RetNo, 'T661', 141)); //fed proxy
    Tv[7]:=Tv[6];  //alb proxy?

    if IsABStep1(RetNo) = True then
    Begin
     Tv[4] := 0; //202250621 // 20210710//if Step1 = True then Tv[4] := 0; // 20210710
     //Tv[5] := Vl(FetchElmFNo(RetNo, AS29LFno, 148));//20250622B //20251120
     Tv[8] := 0; //Vl(FetchElm(RetNo, 'AT1', 74));  //Vl(FetchElm(RetNo, 'T661', 122));
     Tv[10]:=Tv[5];
    End
    Else
    Begin  //20250621   //step2
     //Tv[4] := 0; //202250621 // 20210710//if Step1 = True then Tv[4] := 0; // 20210710
    // Tv[5] := Vl(FetchElmFNo(RetNo, AS29LFno, 156)); //alberta  //20251120
    // Tv[8] := ABNetIeg; //20251120 //Vl(FetchElm(RetNo, 'AT1', 74));  //Vl(FetchElm(RetNo, 'T661', 122));
    //20251120 from below
     Tv[10]:= Tv[5]-Tv[6]+Tv[7]+Tv[8]+Tv[9];  //Vl(FetchElmFNo(RetNo, AS29LFno, 156))+ABNetIeg; //20251120
    End;

    //20251120 moved above before step 1
    //Tv[6]:=Vl(FetchElmFNo(RetNo, AS29LFNo, 151)); // ////Vl(FetchElm(RetNo, 'T661', 141)); //fed proxy
    //Tv[7]:=Tv[6];  //alb proxy?

    //Tv[10]:=Vl(FetchElmFNo(RetNo, AS29LFno, 3))+Tv[9]; //current corporation //20250621
    { //20250621
    // Calc rest of alb portion Line 005  //20210711
    i := 172; //second line of AS29L line 105
    k := 3;
    Repeat
      //If UpperCase(FetchElmFNo(RetNo, AS29LFno, i)) = 'Y' then //20250620 removed too old
      Tv[5] := Tv[5] + Vl(FetchElmFNo(RetNo, AS29LFno, k));
      Inc(i, 1);
      Inc(k, 7);
    Until i > 191;    **
   }


    //if IsABStep1(RetNo) = False then Tv[5] := MaxR(0, Tv[5] - Vl(FetchElm(RetNo, 'AT1', 74))); // exclude ieg //20250621
    //if Step1 = False then Tv[5] := MaxR(0, Tv[5] - Vl(FetchElm(RetNo, 'AT1', 74))); // exclude ieg
   //Tv[6], Tv[7] user input
   // 20210711
   //Tv[7] user input

    //if IsAbStep1(RetNo) = True then Tv[10] := Tv[5] - Tv[6] + Tv[7] + Tv[8] + Tv[9];

    if (Strings[11] < '1') or (Strings[11] > '4') then
      Strings[11] := '';

    // END Pg1 ----

    // Pg2 ---- Pg2 ---- Pg2 ---- Pg2 ---- Pg2 ---- Pg2 ---- Pg2 ---- Pg2 ---- Pg2

    if Strings[12] + Strings[13] = '' then
      Strings[13] := 'X';

    IEGAssociated := Strings[12] > '';

    if IEGAssociated then // associated
    Begin
      Tv[14] := Tv[53];  //line 102
      Tv[15] := 0;       //line 104 // 20210602
    end
    Else // Not associated
    Begin
      Strings[46] := IntToStr(GetNumDays(RetNo, '31-12-2020', 'A'));
      // 20210706 //IntToStr(Ret[RetNo].DaysInYear);
      if Strings[46] > '366' then
        Strings[46] := '366';
      Strings[47] := '365';

      //account for leap years //jz 20241130 clean up multiple if statments with one
      If (DateWithinTaxYear('2020/02/29', RetNo) = True) or (DateWithinTaxYear('2024/02/29', RetNo) = True) or
         (DateWithinTaxYear('2028/02/29', RetNo) = True) or (DateWithinTaxYear('2032/02/29', RetNo) = True)
      then
        Strings[47] := '366';

      Tv[15] := Round(4000000 * (Vl(Strings[46]) / Vl(Strings[47])));
    End; // end Not associated else

    //line 108
    if IEGAssociated then
      Tv[16] := Tv[14] // associated  from table below //20210712
    Else // Not associated
      Tv[16] := Tv[15]; //from line 104 // 20210723


    //Emploment Grant calc pg 2 start -----------

    Lesserline031andline108 := MinR(Tv[10], Tv[16]);  //jz 20241130 change var from x for readability   //x := MinR(Tv[10], Tv[16]);
    Tv[48] := lesserLine031andLine108; //x;
    Tv[17] := Round(lesserLine031andLine108 * 8 / 100); // MinR(Tv[10],Tv[16]) * 8/100;

    BaseAmount := 0;
    if Not IEGAssociated then
    Begin
            Tv[21] := Round((Tv[19] + Tv[20]) / 2);
            BaseAmount := Tv[21];
            Tv[49] := lesserLine031andLine108; //x;
            Tv[50] := BaseAmount;
            Tv[18] := Round((MaxR(0, lesserLine031andLine108 - BaseAmount)) * 12 / 100);
            Tv[25]:=0; //20250618 //Tv[250] := 0;
           // Tv[25]:=Vl(FetchElm(RetNo,'S33',114));  //20250609  Box 126
    End
    Else
    Begin // IS associated
            allowedAmount := Tv[247];
            Tv[25] := Tv[167]; //20250818
             //line 125 from line 325 //jz 20241129
           // Tv[250] := MinR(Tv[16], allowedAmount) * 12/100; //line 125 from line 325 //jz 20241129
            Tv[49] := 0;Tv[50] := 0;Tv[18] := 0;
    End;

    Strings[26] := FormatFloat('##0.00000', (40000000 - (Tv[25] - 10000000)) / 40000000);
   // Tv[26] := Vl(Strings[26]);  //jz//VT50//20250622

    if Tv[25] <= 10000000 then
    Begin
      Strings[26] := '1.00000';
      //Tv[26] := 1; //jz//VT50//20250622
    end;

    if Not IEGAssociated then
      Tv[27] := (Tv[17] + Tv[18])  * vl(strings[26])
       //* Tv[26] //jz//VT50//20250622 - change to use strings[26] rather than TV[26] //jz 20241130
    else // IS associated
      Tv[27] := (Tv[17] + Tv[250]) * vl(strings[26]);
      //* Tv[26]//jz//VT50//20250622 -  change to use strings[26] rather than TV[26]//jz 20241130
   {
    if Not IEGAssociated then
      Tv[27] := (Tv[17] + Tv[18]) * Tv[26]    //jz 20241130
    else // IS associated
      Tv[27] := (Tv[17] + Tv[250]) * Tv[26];  //jz 20241130
   }
    ABIEG:=Tv[27];

    Tv[29] := MaxR(0, Tv[27] - Tv[28]);
    AbNetIEG := Tv[29];

    // END Pg2 ----   // Pg3 ---- Pg3 ---- Pg3 ---- Pg3 ---- Pg3 ---- Pg3 ---- Pg3 ---- Pg3 ----
    Strings[30] := GetAlbAccNo(RetNo);
    Strings[31] := GetTaxationYearEnd(RetNo);

    if IEGAssociated then
    Begin
      If Strings[33] = '' then
        Strings[33] := FetchElm(RetNo, 'AT1', 11);
      If Strings[34] = '' then
        Strings[34] := FetchElm(RetNo, 'AT1', 14);
      Strings[35] := IntToStr(Ret[RetNo].DaysInYear - GetNumDays(RetNo,
        '01-01-2021', 'B')); // 20210604
      if Vl(Strings[35]) < 0 then
        Strings[35] := '';

      if Vl(Strings[35]) > 366 then
        Strings[35] := '366';
      Strings[36] := Strings[35];
      Tv[37] := (4000000 * Vl(Strings[36]) / Vl(Strings[35]));
      /// 365;  //20210604

      //clear totals

      Tv[38]  := 0; //line 270
      Tv[39]  := 0; //line 280
      Tv[40]  := 0; //line 290
      Tv[167] := 0; //line 300
      Tv[206] := 0; //line 275
      Tv[226] := 0; //line 310
      Tv[246] := 0; //line 320

      Strings[51]  := FetchElm(RetNo, 'T2', 1);   // This BN
      Strings[52]  := FetchElm(RetNo, 'AT1', 9);  // This Alb Account
      Strings[168] := FetchElm(RetNo, 'AT1', 14); // This Current Year End

      //
      i := 53;
      j := 148; // 20211025
      k := 207; m := 0; //jz 20241130

      Tv[38] := 4000000; // 20210712
      x := 0;
      repeat
        If i <> 53 then
          x := x + Tv[i]; // ignore the first row for allocation
        Tv[39] := Tv[39] + Tv[i + 1];
        Tv[40] := Tv[40] + Tv[i + 2];
        Tv[167] := Tv[167] + Tv[j];

        //line 267
        tempAmount := Tv[187 + m] - ( (Tv[54 + m*5] + Tv[55 + m*5]) / 2); //jz 20241130
        if Tv[187 + m] = 0 then
          Tv[k] := MaxR(0 , tempAmount) //do not allow to be negative //jz 20241130
        else
          Tv[k] := tempAmount;


        //line 268 - cant be mnore than line 267 and not negative
        if Tv[k + 20] > 0 then
          Tv[k + 20] := MinR(Tv[k], Tv[k + 20])
        else if Tv[k + 20] <= 0 then
          Tv[k + 20] := 0;

        Inc(i, 5);
        Inc(j, 1);
        Inc(k, 1); Inc(m, 1);
      until i > 143;

      Tv[53] := Tv[38] - x; // not negative //20210712

      Tv[206] := AddColumns(187, 205, 1); //line 275
      Tv[226] := AddColumns(207, 225, 1); //line 310

      Tv[246] := AddColumns(227, 245, 1); //line 320
      if Tv[246] > 0 then Tv[246] := MinR(Tv[226],Tv[246]);   //as per line 320 note

      Tv[247] := Tv[227];
    end
    Else // not associated for IEG so zero it out //20210602
    Begin
      for i := 32 to 40 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      for i := 51 to 145 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      for i := 148 to 247 do //jz 20241130 zero out new columns
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
    End;


    If Strings[41] = '' then
      Strings[41] := FetchElm(RetNo, 'AT1', 130); // last nm
    If Strings[43] = '' then
      Strings[43] := FetchElm(RetNo, 'AT1', 131); // first nm
    If Strings[42] = '' then
      Strings[42] := FetchElm(RetNo, 'AT1', 132); // title
    If Strings[44] = '' then
      Strings[44] := FetchElm(RetNo, 'AT1', 30); // telephone
    If Strings[45] = '' then
      Strings[45] := FetchElm(RetNo, 'AT1', 133); // title
  end; { end with }

  SaveTv(RetNo, FName, FNo);

  // Store the IEG in At1
  If IsAbStep1(RetNo) = True then
    StoreElm(RetNo, GetFormNo('AT1'), 74, FormatFloat('#########', AbNetIEG));
  // 20210711
  // 20210712
  If IsABStep1(RetNo) = False then // (final
  Begin
    Calc(RetNo, 'T661');
    T2(RetNo, 'T2', T2FNo);
  End;

  // 20210712    CAUSES LOOP
  // CalcFed(RetNo);
  // CalcAlb(RetNo);
  // 20210710

end;
*)


Procedure AS29L(RetNo: Integer; FName: string; FNo: Integer);
Var
  i: Integer;
begin

  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin

    Strings[153] := GetCorpName(RetNo);
    Strings[154] := GetAlbAccNo(RetNo);
    Strings[155] := GetTaxationYearEnd(RetNo);

    Tv[148] := AddColumns(3, 143, 7);
    Tv[149] := AddColumns(4, 144, 7);
    Tv[150] := AddColumns(5, 145, 7);
    Tv[151] := AddColumns(6, 146, 7);
    Tv[152] := AddColumns(7, 147, 7);


    Tv[171]:=Vl(FetchElm(RetNo,'AS29',27));  //ABIEG   //20250622B
    // 20210707
    Tv[170] := 0;
    i := 156;
    Repeat
      Tv[170] := Tv[170] + Tv[i];
      Inc(i, 1);
    Until i > 169;

    Tv[156] := Maxr(0,Tv[148]-Tv[171]); // 20210722 //20250622B  Minus AB IEG
    // ?? Tv[170]:=Vl(FetchElmFNo(RetNo,T661FNo,168));  //final after prov credits
    // ? Tv[156]:=Tv[170]-AddColumns(157,169,1); //other

  end; { end with }
  SaveTv(RetNo, FName, FNo);
end;



Procedure AT1FEC(RetNo: Integer; FName: string; FNo: Integer);  //20230615 at100
Var
  i: Integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    Strings[153] := GetCorpName(RetNo);
    Strings[154] := GetAlbAccNo(RetNo);
    Strings[155] := GetTaxationYearEnd(RetNo);

  end; { end with }
  SaveTv(RetNo, FName, FNo);
end;

Function GetAlbYearEnd(RetNo: Integer): String;
begin
  Result := FetchElm(RetNo, 'AT1', 14) + '/' + FetchElm(RetNo, 'AT1', 15) + '/'
    + FetchElm(RetNo, 'AT1', 16);
end;

Function GetAlbSalaries(RetNo: Integer): Real;
begin
  Result := Vl(FetchElm(RetNo, 'S5', 193));
end;

Function GetTotSalaries(RetNo: Integer): Real;
begin
  Result := Vl(FetchElm(RetNo, 'S5', 270));
end;

Function GetAlbRevenue(RetNo: Integer): Real;
begin
  Result := Vl(FetchElm(RetNo, 'S5', 195));
end;

Function GetTOTRevenue(RetNo: Integer): Real;
begin
  Result := Vl(FetchElm(RetNo, 'S5', 272));
end;

Function GetAlbNetInc(RetNo: Integer): Real;
Begin
  Result := Vl(FetchElm(RetNo, 'AS12', 43));
end;

Procedure ACAPD(RetNo: Integer; FName: string; FNo: Integer);
Var
  i, j, AlbFNo, FedFNo, ACAPDREFno: Integer;
begin
  LoadTv(RetNo, FName, FNo);
  FedFNo := GetFormNo('S6');
  AlbFNo := GetFormNo('ACAPD');

  with Ret[RetNo].Frm[FNo] do
  begin
    If Strings[254] = '' then
      Strings[254] := 'N';
  end;

  // pg1 ------------------------------------------------------------------------
  If Ret[RetNo].AlbAlloc = 0 then
  begin
    For i := 1 to 700 do // 254 do    20120928
    begin
      StoreElm(RetNo, FNo, i, '');
      SaveTv(RetNo, FName, FNo);
      EXIT;
    end;
  end;

  If AlbDiffS6(RetNo) = False then
  begin { copy from federal }
    If (FedFNo > 0) and (Ret[RetNo].Frm[FedFNo].Count > 0) then
    begin
      InitFormData(RetNo, AlbFNo);
      for i := 4 to 700 do
        StoreElm(RetNo, AlbFNo, i, FetchElmFNo(RetNo, FedFNo, i));
      LoadTv(RetNo, FName, FNo);
    end;
  end;

  FillAlbHeader(RetNo, AlbFNo, 2, 3);
  FillAlbHeader(RetNo, AlbFNo, 477, 478);
  FillAlbHeader(RetNo, AlbFNo, 502, 503);
  FillAlbHeader(RetNo, AlbFNo, 602, 603);

  // calculate
  with Ret[RetNo].Frm[FNo] do
  begin
    If Strings[254] = '' then
      Strings[254] := 'N';
    Strings[1] := LeftStr(GetCorpName(RetNo), 60);
    If Strings[4] + Strings[5] = '' then
      Strings[5] := 'X';
    { Shares }
    i := 10;
    Tv[214] := 0;
    Tv[215] := 0;
    Tv[216] := 0;
    Tv[217] := 0;
    Repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
      Tv[214] := Tv[214] + Tv[i];
      Tv[215] := Tv[215] + Tv[i + 1];
      Tv[216] := Tv[216] + Tv[i + 2];
      Tv[217] := Tv[217] + Tv[i + 3];
      Inc(i, 8);
    until i > 210;

    { RE }
    ACAPDREFno := GetFormNo('ACAPDRE');
    Tv[247] := Vl(FetchElmFNo(RetNo, ACAPDREFno, 309));
    Tv[248] := Vl(FetchElmFNo(RetNo, ACAPDREFno, 310));
    Tv[249] := Vl(FetchElmFNo(RetNo, ACAPDREFno, 311));
    Tv[250] := Vl(FetchElmFNo(RetNo, ACAPDREFno, 312));

    // pg2 ------------------------------------------------------------------------
    with Ret[RetNo].Frm[FNo] do
    begin
      Strings[476] := LeftStr(GetCorpName(RetNo), 60);
      // FillAlbHeader(RetNo,FNo,477,478);
      { Bonds }
      i := 306;
      Tv[375] := 0;
      Tv[376] := 0;
      Tv[483] := 0;
      Tv[484] := 0;

      Repeat
        Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
        Tv[375] := Tv[375] + Tv[i];
        Tv[483] := Tv[483] + Tv[i + 1];
        Tv[484] := Tv[484] + Tv[i + 2];
        Tv[376] := Tv[376] + Tv[i + 3];
        Inc(i, 9);
      until i > 369;

      Tv[375] := Tv[375] + Tv[373]; // ???
      Tv[483] := Tv[483] + Tv[481];
      Tv[484] := Tv[484] + Tv[482];
      Tv[376] := Tv[376] + Tv[374];

      { Other prop }
      i := 380;
      Tv[421] := 0;
      Tv[422] := 0;
      Tv[487] := 0;
      Tv[488] := 0;
      Repeat
        Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
        Tv[421] := Tv[421] + Tv[i];
        Tv[487] := Tv[487] + Tv[i + 1];
        Tv[488] := Tv[488] + Tv[i + 2];
        Tv[422] := Tv[422] + Tv[i + 3];
        Inc(i, 7);
      until i > 415;
      // 20140608
      // Tv[421] := Tv[421]+Tv[419];
      // Tv[487] := Tv[487]+Tv[485];
      // Tv[488] := Tv[488]+Tv[486];
      // Tv[422] := Tv[422]+Tv[420];

      { Pers use }
      i := 425;
      Tv[443] := 0;
      Tv[444] := 0;
      Tv[491] := 0;
      Tv[492] := 0;
      Repeat
        Tv[i + 3] := MaxR(0, Tv[i] - Tv[i + 1] - Tv[i + 2]);
        Tv[443] := Tv[443] + Tv[i];
        Tv[491] := Tv[491] + Tv[i + 1];
        Tv[492] := Tv[492] + Tv[i + 2];
        Tv[444] := Tv[444] + Tv[i + 3];
        Inc(i, 6);
      until i > 437;
      // 20121007 ??? why add theses?
      // Tv[443] := Tv[443]+Tv[441];
      // Tv[491] := Tv[491]+Tv[489];
      // Tv[492] := Tv[492]+Tv[490];
      Tv[444] := Tv[444] + Tv[442];
    end;

    // pg3 ------------------------------------------------------------------------
    with Ret[RetNo].Frm[FNo] do
    begin
      Strings[501] := LeftStr(GetCorpName(RetNo), 60);
      { Listed prop }
      i := 507;
      Tv[530] := 0;
      Tv[531] := 0;
      Tv[532] := 0;
      Tv[533] := 0;

      Repeat
        Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
        Tv[530] := Tv[530] + Tv[i];
        Tv[531] := Tv[531] + Tv[i + 1];
        Tv[532] := Tv[532] + Tv[i + 2];
        Tv[533] := Tv[533] + Tv[i + 3];
        Inc(i, 7);
      until i > 521;

      { 20121006  REMOVED ???? what is 526
        Tv[530] := Tv[530]+Tv[526];
        Tv[531] := Tv[531]+Tv[527];
        Tv[532] := Tv[532]+Tv[528];
        Tv[533] := Tv[533]+Tv[529];
      }
      Tv[534] := Vl(FetchElm(RetNo, 'S4', 222));
      Tv[535] := Tv[533] - Tv[534];
    end;

    // pg4 ------------------------------------------------------------------------

    with Ret[RetNo].Frm[FNo] do
    begin
      Strings[601] := LeftStr(GetCorpName(RetNo), 60);
      // FillAlbHeader(RetNo,FNo,602,603);
      { abil }
      i := 607;
      Tv[667] := 0;
      Tv[668] := 0;
      Tv[669] := 0;
      Tv[670] := 0;
      Repeat
        Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2]; { Tv[I+1]+Tv[i+2]-TV[i]; }
        If Tv[i + 3] > 0 then
          Tv[i + 3] := 0;
        Tv[667] := Tv[667] + Tv[i];
        Tv[668] := Tv[668] + Tv[i + 1];
        Tv[669] := Tv[669] + Tv[i + 2];
        Tv[670] := Tv[670] + Tv[i + 3];
        Inc(i, 7);
      until i > 663;

      Tv[698] := Tv[670];
      Tv[686] := Tv[698] / 2;

      Tv[680] := Vl(FetchElm(RetNo, 'ACAPD', 217)) +
        Vl(FetchElm(RetNo, 'ACAPD', 250)) + Vl(FetchElm(RetNo, 'ACAPD', 376)) +
        Vl(FetchElm(RetNo, 'ACAPD', 422)) + Vl(FetchElm(RetNo, 'ACAPD', 444)) +
        MaxR(0, Vl(FetchElm(RetNo, 'ACAPD', 535)));

      Tv[681] := Vl(FetchElm(RetNo, 'S13', 28)) +
        Vl(FetchElm(RetNo, 'S13', 29));
      Tv[682] := Tv[680] + Tv[679] + Tv[681];
      Tv[683] := Vl(FetchElm(RetNo, 'S13', 30));
      Tv[684] := Tv[682] - Tv[683];

      Tv[672] := Tv[684];
      Tv[674] := Round(Tv[699] / 2);
      Tv[677] := Round(Tv[700] / 2);
      Tv[675] := Tv[674] + Tv[677];
      Tv[696] := Tv[675];
      Tv[678] := Tv[672] - Tv[696];
      Tv[697] := 0;
      If Tv[678] >= 0 then
        Tv[697] := Tv[678];
      Tv[685] := Tv[697] / 2;
    end; { End with }
  end; // else
  SaveTv(RetNo, FName, FNo);
end;

Procedure ACAPDRE(RetNo: Integer; FName: string; FNo: Integer);
Var
  i, j, FedFNo, AlbFNo: Integer;
begin
  If AlbDiffS6(RetNo) = False then
  begin { copy from federal }
    FedFNo := GetFormNo('S6RE');
    AlbFNo := GetFormNo('ACAPDRE');
    If (FedFNo > 0) and (Ret[RetNo].Frm[FedFNo].Count > 0) then
    begin
      InitFormData(RetNo, AlbFNo);
      for i := 1 to 312 do
        StoreElm(RetNo, AlbFNo, i, FetchElmFNo(RetNo, FedFNo, i));
    end;

    LoadTv(RetNo, FName, FNo);
    with Ret[RetNo].Frm[FNo] do
    begin
      { Real Est }
      i := 8;
      Tv[309] := 0;
      Tv[310] := 0;
      Tv[311] := 0;
      Tv[312] := 0;
      Repeat
        Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
        Tv[309] := Tv[309] + Tv[i];
        Tv[310] := Tv[310] + Tv[i + 1];
        Tv[311] := Tv[311] + Tv[i + 2];
        Tv[312] := Tv[312] + Tv[i + 3];
        Inc(i, 11);
      until i > 305;
      { Break r/e }
      Tv[313] := 0;
      Tv[314] := 0;
      Tv[315] := 0;
      (*
        Tv[126]:=0;Tv[127]:=0;Tv[128]:=0;
        i:=7;
        Repeat
        If WhichPeriod(Strings[i]) = 1 then Tv[126]:=Tv[126]+Tv[i+4]
        else If WhichPeriod(Strings[i]) = 2 then Tv[127]:=Tv[127]+Tv[i+4]
        else If WhichPeriod(Strings[i]) = 3 then Tv[128]:=Tv[128]+Tv[i+4];
        Inc(i,11);
        until i>117;
      *)
    end; { End with }
    SaveTv(RetNo, FName, FNo);
  end;

end;

// 20201204
Procedure ACONSENT(RetNo: Integer; FName: string; FNo: Integer);
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    if Strings[66] = '' then
      EXIT; // prepare this year not printed
    if Strings[66] > '' then
      Strings[64] := '';

    Strings[5] := GetAlbAccNo(RetNo);
    Strings[4] := GetCorpName(RetNo);

    // ? radiogrp.d ddoes not work!
    // if Strings[3]>'' then Strings[2]:='';
    // if Strings[7]>'' then Strings[6]:='';

    if Strings[2] > '' then // new authorization
    Begin
      if Strings[36] + Strings[37] = '' then
        Strings[36] := 'X';
    End;

    if Strings[7] > '' then
    begin
      if Strings[1] = '' then
        Strings[1] := OptRec.PRP_Email;
    end;
    Strings[12] := OptRec.Prp_Area;
    Strings[13] := OptRec.Prp_Tel;

    if Strings[3] > '' then // cancel
    begin
      // if cancel: Remove all Authorization sections
      Strings[4] := '';
      Strings[5] := '';
      Strings[6] := '';
      Strings[7] := '';
      Strings[1] := '';
      Strings[12] := '';
      Strings[13] := '';
      Strings[8] := '';
      Strings[20] := '';

      Strings[9] := '';
      Strings[10] := '';
      Strings[11] := '';
      Strings[14] := '';
    end;

    if Strings[2] > '' then // authorizinge
    Begin
      // if authorize remove cancellation data
      Strings[15] := '';
      Strings[16] := '';
      Strings[17] := '';
      Strings[18] := '';
      Strings[19] := '';
      Strings[21] := '';
    End;

    if Strings[36] = '' then // by telephone
    Begin
      Strings[6] := '';
      Strings[7] := '';
      Strings[1] := '';
      Strings[12] := '';
      Strings[13] := '';
    End;
    // 20211215
    Strings[38] := Strings[4];
    Strings[39] := Strings[5];

    { //20211215
      if Strings[37]='' then
      Begin
      Strings[8]:='';
      Strings[20]:='';
      Strings[34]:='';
      End;
    }
    // if Strings[35]='' then Strings[35]:='TRA.revenue@gov.ab.ca';
    If Strings[33] = '' then
      Strings[33] := FormatDateTime('yyyy/mm/dd', Date);
    // DateToMonthDayYear(Date);
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

Procedure AT1013(RetNo: Integer; FName: string; FNo: Integer);
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    If Strings[1] = '' then
      Strings[1] := 'Corporate Tax';
    Strings[5] := GetAlbAccNo(RetNo);
    Strings[4] := GetCorpName(RetNo);

    Strings[7] := OptRec.Prp_Name;
    Strings[8] := OptRec.Prp_Street;
    Strings[9] := OptRec.Prp_City;
    Strings[10] := OptRec.Prp_Prov;
    Strings[11] := OptRec.Prp_Postal;
    Strings[12] := OptRec.Prp_Area;
    Strings[13] := OptRec.Prp_Tel;

    If Strings[14] + Strings[15] + Strings[16] + Strings[17] + Strings[18] +
      Strings[19] = '' then
      Strings[14] := 'X';
    If Strings[21] = '' then
      Strings[21] := DateToMonthDayYear(Date);
  end; { End with }
  SaveTv(RetNo, FName, FNo);

end;

procedure AS51(RetNo: Integer; FName: string; FNo: Integer);
Var
  i, FedFNo, AlbFNo: Integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 1, 2);
    If Strings[5] = '' then
      Strings[5] := 'N';
  end; { End with }
  SaveTv(RetNo, FName, FNo);

  // AS51 pg2 -------------------------------------------------------------------
  // copy from federal
  If AlbDiffResourceData(RetNo) = False then
  begin
    FedFNo := GetFormNo('S51');
    AlbFNo := GetFormNo('AS51');
    If Ret[RetNo].Frm[FedFNo].Count = 0 then
      InitFormData(RetNo, AlbFNo);
    for i := 104 to 170 do
      StoreElm(RetNo, AlbFNo, i, FetchElmFNo(RetNo, FedFNo, i));
  end;

  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 101, 102);
    Tv[118] := AddColumns(104, 116, 2);
    Tv[119] := AddColumns(105, 117, 2);
    Tv[122] := Tv[118] + Tv[120];
    Tv[123] := Tv[119] + Tv[121];
    // expenses
    Tv[142] := Tv[122] - AddColumns(124, 140, 2);
    Tv[143] := Tv[123] - AddColumns(125, 141, 2);
    Tv[144] := TotMultiple(RetNo, 'S51P', 50);
    Tv[145] := TotMultiple(RetNo, 'S51P', 51);
    Tv[146] := Tv[142] + Tv[144];
    Tv[147] := Tv[143] + Tv[145];
    Tv[154] := Tv[146] - Tv[148] - Tv[150] - Tv[152];
    Tv[155] := Tv[147] - Tv[149] - Tv[151] - Tv[153];
    Tv[156] := Tv[154] + Tv[155];
    Tv[160] := Tv[154] - Tv[157];
    Tv[161] := Tv[155];
    Tv[162] := Tv[156] + Tv[159];

    If Tv[162] < 0 then
      Tv[163] := Round(Abs(Tv[162]) * 0.25)
    else
      Tv[163] := 0;

    Tv[164] := Round(MaxR(0, Tv[160] * 0.25));
    Tv[165] := Round(Tv[161] * 0.25);
    If (Tv[162] < 0) and (Tv[161] > 0) then
      Tv[165] := Round(Tv[161] * 0.25);
    If (Tv[162] < 0) and (Tv[161] < 0) then
      Tv[169] := 0;
    If Vl(FetchElm(RetNo, 'AS15', 22)) < 0 then
      Tv[166] := Abs(Vl(FetchElm(RetNo, 'AS15', 22)))
    else
      Tv[166] := 0;
    If Vl(FetchElm(RetNo, 'AS15', 23)) < 0 then
      Tv[167] := Abs(Vl(FetchElm(RetNo, 'AS15', 23)))
    else
      Tv[167] := 0;

    Tv[168] := Tv[164] - Tv[166];
    Tv[169] := Tv[165] - Tv[167];
    Tv[170] := Tv[168] + Tv[169];
    If Tv[163] > 0 then
      For i := 164 to 170 do
        Tv[i] := 0;

  end; { End with }
  // AS51 pg3 -------------------------------------------------------------------
  If AlbDiffResourceData(RetNo) = False then
  begin
    FedFNo := GetFormNo('S51');
    AlbFNo := GetFormNo('AS51');
    If Ret[RetNo].Frm[FedFNo].Count = 0 then
      InitFormData(RetNo, AlbFNo);
    for i := 204 to 253 do
      StoreElm(RetNo, AlbFNo, i, FetchElmFNo(RetNo, FedFNo, i));
  end;

  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 201, 202);
    Tv[204] := Vl(FetchElm(RetNo, 'AS51', 154));
    Tv[205] := Vl(FetchElm(RetNo, 'AS51', 155));
    Tv[206] := 0;
    If Vl(FetchElm(RetNo, 'AS15', 120)) < 0 then
      Tv[206] := Tv[206] + Abs(Vl(FetchElm(RetNo, 'AS15', 120)));
    If Vl(FetchElm(RetNo, 'AS12_3', 21)) < 0 then
      Tv[206] := Tv[206] + Abs(Vl(FetchElm(RetNo, 'S15_3', 21)));
    Tv[210] := Vl(FetchElm(RetNo, 'AS51', 150));
    Tv[211] := Vl(FetchElm(RetNo, 'AS51', 151));
    Tv[212] := Vl(FetchElm(RetNo, 'AS51', 152));
    Tv[213] := Vl(FetchElm(RetNo, 'AS51', 153));
    Tv[220] := AddColumns(204, 214, 2) - Tv[216] + Tv[218];
    Tv[221] := Tv[205] + Tv[207] + AddColumns(211, 215, 2) - Tv[217] + Tv[219];
    Tv[222] := Vl(FetchElm(RetNo, 'AS51', 170));
    Tv[223] := Vl(FetchElm(RetNo, 'AS51_4', 69));
    Tv[232] := Tv[220] - AddColumns(222, 230, 2);
    Tv[233] := Tv[221] - AddColumns(223, 231, 2);
    Tv[234] := Vl(FetchElm(RetNo, 'AS15', 121)); // cee expl
    Tv[236] := Vl(FetchElm(RetNo, 'AS15', 223)); // cde dev
    Tv[238] := Vl(FetchElm(RetNo, 'AS15', 319)); // cogpe
    Tv[242] := Tv[232] - AddColumns(234, 240, 2);
    Tv[243] := Tv[233] - AddColumns(235, 241, 2);
    Tv[244] := Tv[242] + Tv[243];
    Tv[245] := Tv[223];
    Tv[247] := Tv[244] + Tv[245] - Tv[246];
    If Tv[243] > 0 then
      Tv[248] := Round(Tv[243] * 0.25);
    Tv[249] := MinR(Tv[248], Vl(FetchElm(RetNo, 'AS15', 23)));
    Tv[250] := Round(4 * Tv[249]);
    Tv[251] := Tv[247] - Tv[250];
    If Tv[251] > 0 then
      Tv[252] := Round(Tv[251] * 0.25)
    else
      Tv[252] := 0;
    Tv[253] := MinR(Tv[252], Vl(FetchElm(RetNo, 'AS15', 22)));

  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

Procedure AS9SUP(RetNo: Integer; FName: String; FNo: Integer);
Var
  i: Integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 2, 3);
    // 20121223
    If GetTaxationYearEnd(RetNo) > '2012/03/31' then
    begin
      Tv[1] := 0;
      For i := 4 to 22 do
        Tv[i] := 0;
      SaveTv(RetNo, FName, FNo);
      EXIT;
    end;
    // Tv[4]:=Vl(FetchElm(RetNo,'T661',128));
    Tv[9] := MinR(Tv[4], Tv[5]);
    Tv[16] := Tv[4];
    If Tv[17] > 0 then
      Tv[10] := Tv[1] * Tv[16] / Tv[17]
    Else
      Tv[10] := 0;
    Tv[11] := MinR(Tv[9], Tv[10]);
    Tv[12] := Round(Tv[11] * 35 / 100);
    Tv[13] := MaxR(0, Tv[4] - Tv[10]);
    Tv[14] := MaxR(0, Tv[13]);
    Tv[15] := MaxR(0, Tv[5] - Tv[10]);
    Tv[19] := MaxR(0, Tv[15]);
    Tv[6] := MinR(Tv[14], Tv[19]);
    Tv[7] := Round(Tv[6] * 20 / 100);
    If UpperCase(Strings[21]) <> 'Y' then // 20130116
    Begin
      If Tv[20] > 0 then
        Tv[22] := (Tv[12] + Tv[7]) * (Tv[8] / Tv[20]) * 10 / 100
      Else
        Tv[22] := 0;
    end;
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure AS20WS(RetNo: Integer; FName: String; FNo: Integer);
Var
  i: Integer;
  S2FNo: Integer;
  DonLim: Real;
begin
  S2FNo := GetFormNo('S2');
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 1, 2);
    If (Ret[RetNo].Province = 'AB') or (GetTxblIncomeInProv(RetNo, 'AB') <> 0)
    then
    begin
      If UpperCase(Ret[RetNo].Frm[FNo].Strings[22]) <> 'Y' then
        For i := 204 to 340 do
        begin
          Strings[i] := FetchElmFNo(RetNo, S2FNo, i);
          Tv[i] := Vl(FetchElmFNo(RetNo, S2FNo, i));
        end;
    end
    else
    begin
      For i := 204 to 340 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      SaveTv(RetNo, FName, FNo);
      EXIT;
    end;


    // Calculate
    If UpperCase(Ret[RetNo].Frm[FNo].Strings[22]) = 'Y' then
    Begin
      { current year donations from federal S2 }
      Tv[230] := Vl(FetchElm(RetNo, 'S2', 473));
      // 20160416
      Tv[264] := Vl(FetchElm(RetNo, 'S2', 489)); // +Vl(FetchElm(RetNo,'S2',104));
      Tv[298] := Vl(FetchElm(RetNo, 'S2', 505)); // +Vl(FetchElm(RetNo,'S2',112));
      Tv[332] := Vl(FetchElm(RetNo, 'S2', 521)); // +Vl(FetchElm(RetNo,'S2',120));

      { Char don }
      // DonLim := Vl(FetchElm(RetNo,'AS20',21)); //Vl(FetchElm(RetNo,'S2',24)); {as calculated}
      DonLim := MaxR(0, MinR(MinR(Vl(FetchElm(RetNo, 'AS20', 9)),
        Vl(FetchElm(RetNo, 'AS20', 21))), GetAlbNetInc(RetNo)));
      i := 205;
      Repeat
        // Tv[i+1] := MinR(DonLim,Tv[i]);
        Tv[i + 3] := MaxR(0, Tv[i] - Tv[i + 1] - Tv[i + 2]);
        DonLim := MaxR(0, DonLim - Tv[i + 1]);
        Inc(i, 5);
      until i > 230;

      AddS2Spreadsheet(RetNo, FNo, 205, 234); // adds up columns

      Tv[234] := Tv[234] + Tv[340];
      Tv[236] := Tv[236] + Tv[341];
      Tv[341] := Tv[340];
      { Gifts to can }
      { Not available - leave the same lim
        DonLim := MaxR(0,
        MinR(GetTxblIncBeforeDonations(RetNo),
        MinR(Vl(FetchElm(RetNo,'S2',129)),GetNetInc(RetNo)-Tv[235])));
      }
      i := 239;
      Repeat
        // Tv[i+1] := MinR(DonLim,Tv[i]);
        Tv[i + 3] := MaxR(0, Tv[i] - Tv[i + 1] - Tv[i + 2]);
        DonLim := MaxR(0, DonLim - Tv[i + 1]);
        Inc(i, 5);
      until i > 264;

      AddS2Spreadsheet(RetNo, FNo, 239, 268);

      { Gifts of cultural }
      { Not available
        DonLim :=MaxR(0,
        MinR(GetTxblIncBeforeDonations(RetNo),
        MinR(Vl(FetchElm(RetNo,'S2',133)),
        GetNetInc(RetNo)-Tv[235]-Tv[269])));
      }
      i := 273;
      Repeat
        // Tv[i+1] := MinR(DonLim,Tv[i]);
        Tv[i + 3] := MaxR(0, Tv[i] - Tv[i + 1] - Tv[i + 2]);
        DonLim := MaxR(0, DonLim - Tv[i + 1]);
        Inc(i, 5);
      until i > 298;

      AddS2Spreadsheet(RetNo, FNo, 273, 302);

      { Gifts of ecological }
      { Not available
        DonLim := MaxR(0,
        MinR(GetTxblIncBeforeDonations(RetNo),
        MinR(Vl(FetchElm(RetNo,'S2',137)),
        GetNetInc(RetNo)-Tv[235]-Tv[269]-Tv[303])));
      }
      i := 307;
      Repeat
        // Tv[i+1] := MinR(DonLim,Tv[i]);
        Tv[i + 3] := MaxR(0, Tv[i] - Tv[i + 1] - Tv[i + 2]);
        DonLim := MaxR(0, DonLim - Tv[i + 1]);
        Inc(i, 5);
      until i > 332;

      AddS2Spreadsheet(RetNo, FNo, 307, 336);
    end;
  end;

  SaveTv(RetNo, FName, FNo);
end;

(*
procedure AS13(RetNo: Integer; FName: string; FNo: Integer);
// columns first row index
Const
  col1 = 6;
  col2 = 7;
  col3 = 8;
  col4 = 463;
  col5 = 9;
  col6 = 265;
  col7 = 278;
  col8 = 10;
  col9 = 400;
  col10 = 11;
  col11 = 424;
  col12 = 437;
  col13 = 450;
  col14 = 252;
  col15 = 476;
  col16 = 291;
  col17 = 304;
  col18 = 317;
  col19 = 330;
  col20 = 17;
  col21 = 18;
  col22 = 19;
  col23 = 20;
  col24 = 21;
Var
  i, k, k1: Integer;
  FInst: String;
  S8FNo: Integer;
  Cls, s, S1, S2: String;
  TotColumn4: Real;
  OriginalCost: Real;
  UccStart, Additions, Adjustments, Proceeds, UCC, HalfRuleAmount,
    UCCReduced: Real;

  ImmediateExpensing: Real; // 20220730

  OverrideIndic, HalfYearIndic, TermLossIndic: String;
  Rate: String;
  Recapture, TerminalLoss, CCA, UCCEnd, z: Real;
  DaysInTaxYear: Integer; // > 365 then DaysInTaxYear := 365;
  // cls 13 relted
  AssetInfo: String;
  // additional fields after aiip
  Aiip: Boolean;
  AdditionsAiip, AssistanceReceived, RepaidAmount, ProceedsAiip,
    NetCapCostAdditionsAiip, UccAdjustmentAiip, UccAdjustmentNONAiip: Real;
  Aiipfactor: String;

  OverrideBox, HalfRuleBox, TerminalLossBox: String;
  HalfYearAmount: Real;

  LeaseStart, LeaseEnd: string;
  LeaseTerm: Real;
  LeaseAdjustedCost: Real; // RemainingLeaseTerm:Real;
  PurchaseDate: String;
  LeaseMaxCca: Real;
  x: Real;
  y: Real;

  FedS8FNo: Integer;

begin

  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    //20260628
    If (Ret[RetNo].Province = 'AB')
    or (Vl(FetchElm(RetNo, 'S5', 198))>0) then  //has AB income   //20260628
    //continue
    else
    begin
     For i:=1 to 488 do begin Strings[i]:='';Tv[i]:=0;End;
     //does not work?  ClearForm(RetNo,FName);
     SaveTv(RetNo,FName,FNo);
     exit;
    end;

    If Strings[3] = '' then Strings[3] := 'N'; // instead of 13  //20120201

    If UpperCase(Strings[3]) <> 'Y' then { copy from fed }
    begin
      FedS8FNo := GetFormNo('S8' + FInst);
      If (FedS8FNo > 0) and (Ret[RetNo].Frm[FedS8FNo].Count > 0) then
      Begin
        for i := 6 to 396 do // 232 do
        begin
          Strings[i] := FetchElmFNo(RetNo, FedS8FNo, i);
          Tv[i] := Vl(FetchElmFNo(RetNo, FedS8FNo, i));
        end;
      //20230610
        Strings[1] := FetchElm(RetNo,GetFormNo('AT1'),9);
        Strings[2] := FetchElm(RetNo,GetFormNo('T2'),11);
        Strings[29] := FetchElmFNo(RetNo,FedS8FNo,29);
        SaveTv(RetNo, FName, FNo);
        EXIT;
      end; // count
    end; // 'Y'
  end; // with

  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 1, 2); // 20190626
    DaysInTaxYear := Ret[RetNo].DaysInYear;
    If DaysInTaxYear > 365 then DaysInTaxYear := 365;

    S8FNo := GetFormNo('S8#1'); // 20220826
    FInst := ExtractFormInst(FName);

    If Strings[4] + Strings[5] = '' then
      Strings[5] := 'X';
    If Strings[216] = '' then
      Strings[216] := 'N'; // 20221107
    If Strings[217] = '' then
      Strings[217] := 'Y';


    // INIT Totals //20190614
    i := 530;
    z := 0;
    Repeat
      if Strings[i - 2] = '' then
        Strings[i - 1] := ''; // 20230309
      z := z + Vl(Strings[i]);
      Inc(i, 3); // 20220912
    Until i > 599;
    Strings[13] := FormatFloat('###.####', z);

    If z > 100 then
      Strings[29] := '0'
    else
    Begin
      y := (Ret[RetNo].DaysInYear / 365) * (1500000 * Vl(Strings[530]) / 100);
      // the first on the list
      Strings[29] := FormatFloat('##,###,###', y);
    end;

    Tv[77] := 0;
    Tv[93] := 0; // DIEP UCC plus ImmeeditateExpensing column //20220730
    Tv[249] := 0;
    Tv[234] := 0;
    Tv[250] := 0;
    Tv[235] := 0;
    Tv[230] := 0;
    Tv[231] := 0;
    Tv[232] := 0;
    Tv[251] := 0;

    for i := 384 to 396 do
      Strings[i] := '';
    // initialize the bottom class numbers, then copy them //20190705
    for i := 515 to 527 do
      Strings[i] := '';
    // initialize the botom class numbers, then copy them //20190705
    for k := 0 to 12 do // 12 do
    /// /k is the row being processed starts from k=0 //13 rows per section
    Begin
      // repeate class for each section from Part 2
      Cls := AllTrim(Strings[col1 + k * 16]); // 20190719 //alltrim
      Strings[384 + k * 1] := Cls; // 20190705
      Strings[515 + k * 1] := Cls; // 20220730 //dupl/copy cless

      // Rate := GetCCARate(Cls); // string //20190614  see beloq //20221121

      // set up override indicatore
      If UpperCase(Strings[14 + k * 16]) = 'O' then
        Strings[14 + k * 16] := 'Y'; // override
      If UpperCase(Strings[15 + k * 16]) = 'H' then
        Strings[15 + k * 16] := 'Y'; // half year
      if Vl(Rate) = 100 then
        Strings[15 + k * 16] := 'N';
      // 20190614 No half year rule for fast write off //20190614
      If UpperCase(Strings[16 + k * 16]) = 'T' then
        Strings[16 + k * 16] := 'Y'; // Term loss
      If UpperCase(Strings[14 + k * 16]) = 'X' then
        Strings[14 + k * 16] := 'Y'; // override
      If UpperCase(Strings[15 + k * 16]) = 'X' then
        Strings[15 + k * 16] := 'Y'; // half year
      If UpperCase(Strings[16 + k * 16]) = 'X' then
        Strings[16 + k * 16] := 'Y'; // Term loss

      // 20221121 from further below
      OverrideIndic := UpperCase(Strings[14 + k * 16]);
      HalfYearIndic := UpperCase(Strings[15 + k * 16]);
      TermLossIndic := UpperCase(Strings[16 + k * 16]);

      // Rate := GetCCARate(Cls); //20221121
      If Strings[489 + k * 1] <> 'Y' then // override rate
        Strings[17 + k * 16] := GetCCARate(Cls); // 20221121
      Rate := Strings[17 + k * 16];

      OriginalCost := Tv[371 + k * 1];
      AssetInfo := Strings[236 + k * 1];
      // calculate each Column mow
      UccStart := Tv[col2 + k * 16]; // col2
      Additions := Tv[col3 + k * 16]; // col3
      if DiepClass(Cls) = False then
        Tv[col4 + k * 1] := 0; // 20221115 //Tv[col2 + k * 16] := 0; // 20221107
      if DiepClass(Cls) = False then
        Tv[col9 + k * 1] := 0; // 20221015
      if Strings[216] = '' then
        Strings[216] := 'Y';
      // if DiepClass(Cls) = False then Tv[col11 + k * 1] := 0; // 20221015

      Adjustments := Tv[col5 + k * 16]; // cpl 5

      // if UpperCase(Strings[216])='Y' then Tv[col11+k*1]:=Tv[col5 + k * 1]; //20221108
      // if Tv[col11+k*1]>Tv[col5 + k * 1] then Tv[col5 + k * 1]:=Tv[col5 + k * 1]; //20221108

      // DiepUcc := Tv[col11 + k * 1]; // 20220826 //20221107
      Tv[77] := Tv[77] + Tv[col11 + k * 1];
      ImmediateExpensing := Tv[col12 + k * 1]; // 20220826
      Tv[93] := Tv[93] + ImmediateExpensing;

      // move down
      // Tv[col8+k*16]:=MaxR(0,Tv[col8+k*16]);  //20220621
      // Proceeds:=Tv[col8+k*16];

      if (LeaseHold(Cls)) and (UccStart > 0) Then
      begin
        { //20220913
          Additions := 0;
          Tv[col3 + k * 16] := 0;
        }
      end; // do not allow additions to 13 //20190705
      // 20190809  accept yyymmdd in case they entered yyyy/mm/dd
      If (Cls > '') then
      begin
        if Not LeaseHold(Cls) then
        Begin
          // replace yyymmdd with yyy/mm/dd for date
          s := LeftStr(Strings[236 + k * 1], 8);
          if (Length(s) = 8) and (Numeric(s)) then
            Strings[236 + k * 1] := LeftStr(s, 4) + '/' + MidStr(s, 6, 2) + '/'
              + RightStr(s, 2);
        End
        Else // leasehold //cls='13')
        Begin
          s := Strings[236 + k * 1];
          s := RemoveChar(s, '/');
          s := RemoveChar(s, '-');
          s := LeftStr(s, 16);
          if (Length(s) = 16) and (Numeric(s)) then
          Begin
            S1 := LeftStr(s, 8); // from date
            S1 := LeftStr(S1, 4) + '/' + MidStr(S1, 5, 2) + '/' +
              RightStr(S1, 2);
            S2 := RightStr(s, 8); // to date
            S2 := LeftStr(S2, 4) + '/' + MidStr(S2, 5, 2) + '/' +
              RightStr(S2, 2);
            Strings[236 + k * 1] := S1 + '-' + S2;
          End;
        End;
      end; // cls>''

      // AIIP indicator//20190621
      // 20190705
      Strings[356 + k * 1] := '';
      if (Additions > 0) and (Cls > '') then
      Begin
        s := ReplaceChar(AssetInfo, ',', '');
        PurchaseDate := LeftStr(s, 10);
        if (PurchaseDate > '2018/11/20') or
          (GetTaxationYearStart(RetNo) > '2018/11/20')
        // 20220619 additions made after the Aiip date of 2018
        then
          Strings[356 + k * 1] := 'X' // then 10.1 is aiip
        Else
          Strings[356 + k * 1] := ''; // 20190705
      end;

      if (GetTaxationYearEnd(RetNo) > '2027/12/31') then
        Strings[356 + k * 1] := '';
      // NO AIIP after 2027? Check it then IF ALIVE! //20190704
      If Strings[356 + k * 1] > '' then
        Aiip := True
      else
        Aiip := False; // 20190614
      if Cls = '56' then
      Begin
        Aiip := False;
        Strings[356 + k * 1] := '';
      end; // 20220531

      // 20190607  Override section elms starting 14, 15, 16
      if (Aiip = False) and (Cls > '') then
      Begin
        If Strings[15 + k * 16] = '' then
          Strings[15 + k * 16] := 'Y'; // 20190605 half yer rule by default
      End;

      if Aiip = True then
        Strings[15 + k * 16] := ''; // 20190614 in O-H-T
      If (Cls = '24') or (Cls = '27') or (Cls = '29') or (Cls = '34') then
        Strings[15 + k * 16] := ''; // fast write off NO half year rule
      { //20221121
        OverrideIndic := UpperCase(Strings[14 + k * 16]);
        HalfYearIndic := UpperCase(Strings[15 + k * 16]);
        TermLossIndic := UpperCase(Strings[16 + k * 16]);
      }

      // If UpperCase(OverrideIndic) <> 'Y' then Rate := GetCCARate(Cls); //20221121 see in beginning

      // Inpout validations
      if Cls = '10.1' then // 20190622
      Begin
        if PurchaseDate < GetTaxationYearStart(RetNo) then
          Tv[col3 + k * 16] := 0; // no additions allowed
      End;

      If (Aiip = False) and (Cls <> '56') then
        Tv[col14 + k * 1] := 0; // // 20220531 aiip portion of col 3

      AdditionsAiip := Tv[col14 + k * 1];
      // assistance part of col 5
      // If Tv[265+k*1]>Tv[9+k*16] then Tv[265+k*1]:=Tv[9+k*16];  //20220621
      Tv[col6 + k * 1] := MaxR(0, Tv[col6 + k * 1]); // col6 //20220621
      AssistanceReceived := Tv[col6 + k * 1];
      Tv[col7 + k * 1] := MaxR(0, Tv[col7 + k * 1]); // col 7 //20220621
      RepaidAmount := Tv[col7 * 1]; // col7
      Tv[col8 + k * 16] := MaxR(0, Tv[col8 + k * 16]);
      // 20220621  //from aboeve //20220731
      // Proceeds:=Tv[col8+k*16];  //20220731

      // aiip  related
      If Aiip = False then
      Begin
        Tv[col16 + k * 1] := 0;
        Tv[col17 + k * 1] := 0;
        Tv[343 + k * 1] := 0;
        Tv[col18 + k * 1] := 0;
        Tv[col19 + k * 1] := 0;
      End;
      if Aiip = True then // 20190705
      Begin
        // fast write off //20190608
        if (Cls = '24') or (Cls = '27') or (Cls = '29') or (Cls = '34') then
        Begin
          Tv[col3 + k * 16] := 0; // additions
        End;
        // 20210328
        // Aiipfactor
        Aiipfactor := '';
        Strings[343 + k * 1] := '';
        // if Cls = '' then Aiipfactor := ''; // 20190622
        if (Cls = '') or (Aiip = False) then
          Aiipfactor := ''; // default //20220801

        if Cls = '43.1' then
          Aiipfactor := '2.33333'
        Else if Cls = '43.2' then
          Aiipfactor := '1'
        Else if Cls = '53' then
          Aiipfactor := '1'
        Else if (Cls = '54') then
        Begin
          if Strings[236 + k] > '2019/03/18' then
          begin
            Strings[356 + k] := 'X';
            Aiipfactor := '2.33333333';
          end
          Else If Strings[236 + k] > '2018/11/20' then
          begin
            Strings[356 + k] := 'X';
            Aiipfactor := '0.5';
          end;
        End // aiip true
        Else if (Cls = '55') and (Strings[236 + k] > '2019/03/18') then
          Aiipfactor := '1.5'
        Else if (Cls = '56') then
          Aiipfactor := '2.333331' // 20210927
        Else if (Cls = '12') or (LeaseHold(Cls)) or (Cls = '14') or (Cls = '15')
        then
          Aiipfactor := '' // 20190806
        Else
          Aiipfactor := '0.5';
      End;

      Strings[343 + k * 1] := Aiipfactor;
      ProceedsAiip := Tv[col16 + k * 1];

      HalfRuleAmount := 0;
      UCC := 0;
      UCCReduced := 0;
      Recapture := 0;
      TerminalLoss := 0;

      // get lease and orinal cost from decr box
      If LeaseHold(Cls) then // if Cls='13' then
      begin
        LeaseTerm := 5; // Default;
        // for class 13: 1234567890-1234567890
        s := ReplaceChar(AssetInfo, ',', '');
        LeaseStart := LeftStr(s, 10);
        LeaseEnd := MidStr(s, 12, 10);
        if (Length(LeaseStart) <> 10) or (Length(LeaseEnd) <> 10) then
          LeaseTerm := 0
        Else
        begin
          LeaseTerm := DateDiffYMD(LeaseStart, LeaseEnd) div 365;
          If (LeaseTerm > 0) and (LeaseTerm < 5) then
            LeaseTerm := 5;
        End;
        LeaseMaxCca := OriginalCost / LeaseTerm; // 20190611
        Rate := FormatFloat('####.##', 100 / LeaseTerm); // 20190601
        Strings[col20 * k * 16] := Rate;
        // if rate='INF' then ShowMessage('inf rate');

        // end;
      end;

      if Cls = '' then
      begin
        UCC := 0;
        HalfRuleAmount := 0;
        UCCReduced := 0;
        Recapture := 0;
        TerminalLoss := 0;
        CCA := 0;
        UCCEnd := 0;
      end;

      UCC := UccStart + Additions + Adjustments - AssistanceReceived +
        RepaidAmount - Proceeds; // 20190606pm
      if (Cls = '10.1') and (Proceeds > 0) then
        UCC := UccStart + Additions + Adjustments - AssistanceReceived +
          RepaidAmount; // 20190820 Get the CCA on disposal

      If LeaseHold(Cls) then // if cls='13' then //20190611
      Begin
        LeaseAdjustedCost := OriginalCost - UccStart + Additions + Adjustments -
          AssistanceReceived + RepaidAmount;
        UCCReduced := UccStart + Additions + Adjustments - AssistanceReceived +
          RepaidAmount;
      End;

      if Aiip = False then // 20190706
      Begin
        if UpperCase(HalfYearIndic) = 'Y' then
        /// /20190605
        begin
          if UpperCase(OverrideIndic) <> 'Y' then // 20190605
          begin
            HalfRuleAmount :=
              MaxR(0, 0.5 * (Additions - AssistanceReceived + RepaidAmount -
              Proceeds));
            if LeaseHold(Cls) then
              HalfRuleAmount := MaxR(0, 0.5 * (Additions - Proceeds));
            // 20190613
            HalfRuleAmount := RoundCorrect(HalfRuleAmount);
          end;
        end
        else
          HalfRuleAmount := 0;
        // from below  //20220619
        if (Cls = '12') OR (Cls = '52') Or (Cls = '24') or (Cls = '27') or
          (Cls = '29') or (Cls = '34') // fast write off //20190622
        then
          UccAdjustmentNONAiip := 0; // 20190622
        UCCReduced := UCC - HalfRuleAmount;
        if LeaseHold(Cls) then
          UCCReduced := UCC; // 20190611
        ProceedsAiip := 0;
        NetCapCostAdditionsAiip := 0;
        UccAdjustmentAiip := 0;
      end // 20220619
      Else // If (Aiip=True) then
      Begin
        HalfRuleAmount := 0; // 20190608
        // 20190707
        ProceedsAiip := MaxR(0, Proceeds + AssistanceReceived - Additions +
          AdditionsAiip - RepaidAmount);
        NetCapCostAdditionsAiip := MaxR(0, AdditionsAiip - ProceedsAiip);
        if (Cls = '10.1') and (Proceeds > 0) then
          NetCapCostAdditionsAiip := AdditionsAiip;

        UccAdjustmentAiip := NetCapCostAdditionsAiip * Vl(Aiipfactor);
        UccAdjustmentNONAiip :=
          MaxR(0, 0.5 * (Additions - AdditionsAiip - AssistanceReceived +
          RepaidAmount - Proceeds)); // 20190622 moved from below

        if (Cls = '12') OR (Cls = '52') Or (Cls = '24') or (Cls = '27') or
          (Cls = '29') or (Cls = '34') then
          UccAdjustmentNONAiip := 0; // 20190622  //fast write off //20190622
      End; // 20220619
      // put amounts on the S8 form
      Tv[12 + k * 16] := HalfRuleAmount; // ???
      if Aiip then
        Tv[12 + k * 16] := 0; // remove half ruleamount

      // Col2
      Tv[249] := Tv[249] + Tv[col2 + k * 16];

      // Col3
      Tv[234] := Tv[234] + Tv[col3 + k * 16];

      // Col4
      if Tv[col4 + k * 1] > Tv[col3 + k * 1] then
        Tv[col4 + k * 1] := Tv[col3 + k * 16];

      // Col8                                 -
      Tv[235] := Tv[235] + Tv[col8 + k * 16];
      // col9  user inout
      if Tv[col9 + k * 1] > Tv[col8 + k * 16] then
        Tv[col9 + k * 1] := Tv[col8 + k * 16];
      // col10
      Tv[col10 + k * 16] := Tv[col2 + k * 16] + Tv[col3 + k * 16] +
        Tv[col5 + k * 16] - Tv[col8 + k * 16];

      // col11                    **
      if UpperCase(Strings[216]) = 'Y' then
        Tv[col11 + k * 1] := Tv[col4 + k * 1]; // 20221108
      if Tv[col11 + k * 1] > Tv[col4 + k * 1] then
        Tv[col11 + k * 1] := Tv[col4 + k * 1]; // 20221108

      // col12 //semi automatic  //20220827 imm expensing amount = designated
      If UpperCase(Ret[RetNo].Frm[FNo].Strings[217]) = 'Y' then
      // autofill col 12
      Begin
        If (Tv[col4 + k * 1] > 0) and (Tv[col12 + k * 1] = 0) then
          Tv[col12 + k * 1] := Tv[col4 + k * 1]; // 20221017
      end;

      if Tv[col12 + k * 1] > Tv[col4 + k * 1] then
        Tv[col12 + k * 1] := Tv[col11 + k * 1];
      if Ret[RetNo].CorpType <> CCPC then
        Tv[col12 + k * 1] := 0; // 20221115

      // col13
      Tv[col13 + k * 1] := MaxR(0, Tv[col3 + k * 16] - Tv[col4 + k * 1] +
        Tv[col11 + k * 1] - Tv[col12 + k * 1]); // 20220912 MaxR
      // col14  user input
      if Aiip = True then
        Tv[col14 + k * 1] := MaxR(0, Tv[col13 + k * 1])
      else
        Tv[col14 + k * 1] := 0;
      // col15
      Tv[col15 + k * 1] := MaxR(0, Tv[col10 + k * 16] - Tv[col12 + k * 1]);
      // col16
      if Aiip = True then
        Tv[col16 + k * 1] := MaxR(0, Tv[col8 + k * 16] - Tv[col9 + k * 1] +
          Tv[col6 + k * 1] - Tv[col13 + k * 1] + Tv[col14 + k * 1] -
          Tv[col7 + k * 1]) // ? 54 and 56?
      else
        Tv[col16 + k * 1] := 0;
      // col17
      if Aiip = True then
        Tv[col17 + k * 1] := MaxR(0, Tv[col14 + k * 1] - Tv[col16 + k * 1])
        // ? 54 and 56?
      else
        Tv[col17 + k * 1] := 0;

      if Cls = '' then
      begin
        Aiipfactor := '';
        Strings[343 + k * 1] := ''; // aiip factor
      end;

      // col18
      Tv[col18 + k * 1] := Tv[col17 + k * 1] * Vl(Strings[343 + k * 1]);
      // //? 54 and 56?

      // col19
      Tv[col19 + k * 1] := MaxR(0, Tv[col13 + k * 1] - Tv[col14 + k * 1] -
        Tv[col6 + k * 1] - Tv[col17 + k * 1]); // ? 54 and 56?

      // col20
      Strings[col20 + k * 16] := Rate;
      // if Strings[Col20+K*16]='INF' then Strings[col20*k*16] := ''; //20220912
      // col21 recapture
      Tv[col21 + k * 16] := 0;
      if Tv[col10 + k * 16] < 0 then
        Tv[col21 + k * 16] := Abs(Tv[col10 + k * 16]);

      if (Cls = '10.1') then
        Tv[col21 + k * 16] := 0; // 20230516

      Tv[230] := Tv[230] + Tv[col21 + k * 16];

      // col22 Terminal loss
      Tv[col22 + k * 16] := 0;
      if (UpperCase(Strings[16 + k * 16]) = 'Y') and (Tv[col10 + k * 16] > 0)
      then
        Tv[col22 + k * 16] := Tv[col10 + k * 16];
      if (Cls = '10.1') then
        Tv[col22 + k * 16] := 0; // 20230516
      Tv[231] := Tv[231] + Tv[col22 + k * 16];

      // col23 CCA
      If (Cls = '24') or (Cls = '27') or (Cls = '29') or (Cls = '34') then
        Rate := '100'; // fast write off //20220802

      // There is CCA
      If (Tv[col21 + k * 16] = 0) and (Tv[col22 + k * 16] = 0) then
      // RGRE IS CCA (No Term loss =0 andRecpt=0 )
      begin // normal no gtterminal loss or  recapture
        if UpperCase(Strings[14 + k * 16]) <> 'Y' then // no override);
        Begin
          Tv[col23 + k * 16] := (Tv[col15 + k * 1] + Tv[col18 + k * 1] -
            Tv[col19 + k * 1]) * Vl(Rate) / 100 + Tv[col12 + k * 1];
          CCA := Tv[col23 + k * 16]; // 20230322
          if Ret[RetNo].DaysInYear < 365 then
          Begin
            CCA := CCA * Ret[RetNo].DaysInYear / 365;
            Tv[col23 + k * 16] := CCA;
          End;
        End;
      end
      Else // case: recapture  or Term loss>0 //20230512
      begin
        CCA := 0;

        Tv[col23 + k * 16] := 0; // if recapture or term loss then CCA =0
        // proration:?
        if Ret[RetNo].DaysInYear < 365 then
        Begin
          // Tv[col21 + k * 16]:=Tv[col21 + k * 16]/ 365;  //recapture
          // Tv[col22 + k * 16]:=Tv[col22 + k * 16] / 365; //terminal loss
        End;
      end;

      Tv[232] := Tv[232] + Tv[col23 + k * 16];

      if UpperCase(Strings[16 + k * 16]) = 'Y' // term loss
      then
        Tv[col24 + k * 16] := 0 // no UCC end eny more
      Else
        Tv[col24 + k * 16] := MaxR(0, Tv[col10 + k * 16] - Tv[col23 + k * 16]);

      Tv[251] := Tv[251] + Tv[col24 + k * 16];

    End; // k 0 to 12  //k is the wow bing processed starts from k=0
  End; // with?
  SaveTv(RetNo, FName, FNo);
  // y := Vl(FetchElmFNo(RetNo, FNo, 232)); //20220826
end;
*)


end.
