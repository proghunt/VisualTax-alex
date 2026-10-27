Unit T1_2026CalcMJ;
// disability - hardcoded - revise each year
// also credits etc.

interface

uses

  SysUtils,
  WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls, Dialogs, DBctrls, ExtCtrls,
  T1_2026Declare, T1_2026common, T1_2026common2, T1_2026TrimStr, T1_2026T1Rtns,
  // 20160119 Igor
  T1_2026T1Rtns2;

// --------------------------

Function GetSpTaxFormName(RetNo: Integer): String; // 20180327
Procedure CalcLine5612(RetNo, T2203FNo: Integer); // Elig dep NI

Procedure S2MJAB(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
Procedure S2MJBC(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
Procedure S2MJMB(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
Procedure S2MJNB(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
Procedure S2MJNL(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
Procedure S2MJNS(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
Procedure S2MJNT(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
Procedure S2MJPE(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
Procedure S2MJNU(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
Procedure S2MJON(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
Procedure S2MJSK(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
Procedure S2MJYT(RetNo: Integer; FName: string; FNo: Integer; Prv: String);

// 20180324-----------------------------
Procedure S11MJ(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
Procedure S11MJNL(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
Procedure S11MJPE(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
Procedure S11MJNS(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
Procedure S11MJNB(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
Procedure S11MJON(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
Procedure S11MJMB(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
Procedure S11MJSK(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
Procedure S11MJAB(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
Procedure S11MJBC(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
Procedure S11MJYT(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
Procedure S11MJNT(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
Procedure S11MJNU(RetNo: Integer; FName: string; FNo: Integer; Prv: String);

// 20180324
// Procedure S11MJNR(RetNo:integer;FName:string;FNo:integer;Prv:String); //20180324
// Procedure S11MJQC(RetNo:integer;FName:string;FNo:integer;Prv:String); //20180324


// -------------------------------

Procedure CopyNL428ToT2203(RetNo, FNo: Integer; Prv: String); // 20180318
Procedure CopyPE428ToT2203(RetNo, FNo: Integer; Prv: String); // 20180318
Procedure CopyNS428ToT2203(RetNo, FNo: Integer; Prv: String); // 20180318

Procedure CopyNB428ToT2203(RetNo, FNo: Integer; Prv: String); // 20180318
Procedure CopyON428ToT2203(RetNo, FNo: Integer; Prv: String); // 20180314
Procedure CopyMB428ToT2203(RetNo, FNo: Integer; Prv: String); // 20180314

Procedure CopySK428ToT2203(RetNo, FNo: Integer; Prv: String); // 20180314
Procedure CopyAB428ToT2203(RetNo, FNo: Integer; Prv: String); // 20180314
Procedure CopyBC428ToT2203(RetNo, FNo: Integer; Prv: String); // 20180314

Procedure CopyYT428ToT2203(RetNo, FNo: Integer; Prv: String); // 20180314
Procedure CopyNT428ToT2203(RetNo, FNo: Integer; Prv: String); // 20180314
Procedure CopyNU428ToT2203(RetNo, FNo: Integer; Prv: String); // 20180314

Function GetMjSpouseTransfer(RetNo: Integer; Prv: String): Real;
Procedure T2203(RetNo: Integer; FName: string; FNo: Integer);

Function GetMjPrvDisab(RetNo, FNo: Integer; Prv: String): Real;

Function GetMj5804To5848(RetNo: Integer; Prv: String): Real;

// Procedure GetMjNonRefCredits(RetNo:Integer;Prv:String;OverrideSw:String;FNo:Integer);
Procedure InitMJS2(RetNo: Integer);
Procedure InitMJS11(RetNo: Integer);
Procedure CreateMJS2(RetNo: Integer; Prv: String; Cnt: Integer);
Procedure CreateMJS11(RetNo: Integer; Prv: String; Cnt: Integer);
Procedure S2MJ(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
// 20180322 prv instead of province


Function GetS2MjHeader(RetNo: Integer; Prv: String): String;
Function FullTONIMJ(RetNo: Integer; Prv: String): Boolean;
Function GetS2MjFNo(RetNo: Integer; Prv: String): Integer;
Function GetS11MjFNo(RetNo: Integer; Prv: String): Integer;

procedure CalcPrvTaxAndCreditsMJ(RetNo: Integer);


implementation

Uses vtCommon, T1_2026, T1_2026Calc, T1_2026Calc3, T1_2026Calc1, T1_2026Calc2,
  T1_2026CalcMJ2, //jz//20260328//MJCERT2025

  vtTrimStr, vtShared ;  // 20160119 Igor

Function GetS2MjHeader(RetNo: Integer; Prv: String): String;
begin
  Result := Prv + '(S2)MJ';
end;

Function GetS11MJHeader(RetNo: Integer; Prv: String): String;
begin
  Result := Prv + '(S11)MJ';
end;

// 20180313  Used the S2PRV logic after INITPRVConstants
// replaced Ret[RetNo].Province with Province
// replaced Province with PRV

Procedure S2MJ(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
Var
  i, S2FNo, SpRetNo: Integer;
  SpTaxFormName: String;
Begin

  InitPrvConstants(Prv); // ret[RetNo].Province);

  LoadTv(RetNo, FName, FNo);
  SpTaxFormName := GetSpTaxFormName(RetNo); // Prv+'428';
  ret[RetNo].Frm[FNo].Strings[15] := GetS2MjHeader(RetNo, Prv);
  With ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    Strings[30] := 'S2';
    If not FullTONIProvince(RetNo) then
    begin
      For i := 1 to 46 do // instead of 35
      begin
        Strings[i] := '';
        Tv[i] := 0;
        SaveTv(RetNo, FName, FNo);
        exit;
      end;
    end;
    If (Prv = 'ON') or (Prv = 'NU') then { allow overrides }
      // ok
    else
    begin
      Frm[FNo].Strings[28] := '';
      Frm[FNo].Strings[27] := '';
    end;

    { copy from federal }
    S2FNo := GetFormNo('S2');
    For i := 1 to 2 do
    begin
      Frm[FNo].Strings[i] := FetchElmFNo(RetNo, S2FNo, i);
      Tv[i] := Vl(FetchElmFNo(RetNo, S2FNo, i));
    end;
    // --------------
    // 20180322  new fiels copy from fed
    Tv[11] := Vl(FetchElmFNo(RetNo, S2FNo, 11)); // cpp empl
    Tv[12] := Vl(FetchElmFNo(RetNo, S2FNo, 12)); // cpp self
    Tv[35] := Vl(FetchElmFNo(RetNo, S2FNo, 35)); // line 317
    Tv[13] := Vl(FetchElmFNo(RetNo, S2FNo, 13)); // Empl ins
    If (Prv = 'MB') then
      Tv[38] := Vl(FetchElmFNo(RetNo, S2FNo, 38))
    else
      Tv[38] := 0;
    If (Prv = 'BC') or (Prv = 'MB') Or (Prv = 'YT') then
      Tv[39] := Vl(FetchElmFNo(RetNo, S2FNo, 39))
    else
      Tv[39] := 0;
    If (Prv = 'BC') then
      Tv[44] := Vl(FetchElmFNo(RetNo, S2FNo, 44))
    else
      Tv[44] := 0;
    If (Prv = 'BC') then
      Tv[45] := Vl(FetchElmFNo(RetNo, S2FNo, 45))
    else
      Tv[45] := 0;
    If (Prv = 'BC') or (Prv = 'MB') then
      Tv[43] := Vl(FetchElmFNo(RetNo, S2FNo, 43))
    else
      Tv[43] := 0;
    If (Prv = 'BC') then
      Tv[46] := Vl(FetchElmFNo(RetNo, S2FNo, 46))
    else
      Tv[46] := 0;
    If (Prv = 'NL') or (Prv = 'BC') OR (Prv = 'MB') then
      Tv[40] := Vl(FetchElmFNo(RetNo, S2FNo, 40))
    else
      Tv[40] := 0;
    If (Prv = 'NL') then
      Tv[41] := Vl(FetchElmFNo(RetNo, S2FNo, 41))
    else
      Tv[41] := 0;
    If (Prv = 'SK') then
      Tv[42] := Vl(FetchElmFNo(RetNo, S2FNo, 42))
    else
      Tv[42] := 0;
    // ---------------------------

    // disability Xfer
    Frm[FNo].Strings[5] := FetchElmFNo(RetNo, S2FNo, 5);
    Tv[5] := Vl(FetchElmFNo(RetNo, S2FNo, 5));
    If (Tv[5] > 0)
    { and (ret[RetNo].MarStatus < 3) }   // 20130224
    then
    begin
      If CalcAge(GetSpouseBirthDate(RetNo)) < 18 then
        Tv[5] := PrvConstant[RY].PrvMaxDisability + PrvConstant[RY].PrvMaxDisabSupl18
      else
        Tv[5] := PrvConstant[RY].PrvMaxDisability;
    end;

    // 20130224
    For i := 7 to 9 do // do not include the tuition April 15 2008  //not 10
    begin
      Frm[FNo].Strings[i] := FetchElmFNo(RetNo, S2FNo, i);
      Tv[i] := Vl(FetchElmFNo(RetNo, S2FNo, i));
    end;

    { ???   WRONG  20180322
      For i:=11 to 13 do   //do not include the tuition April 15 2008
      begin
      Frm[FNo].Strings[i] := FetchElmFNo(RetNo,S2FNo,i);
      Tv[i] := Vl(FetchElmFNo(RetNo,S2FNo,i));
      end;
    }

    For i := 16 to 18 do // not 19 20130224
    begin
      Frm[FNo].Strings[i] := FetchElmFNo(RetNo, S2FNo, i);
      Tv[i] := Vl(FetchElmFNo(RetNo, S2FNo, i));
    end;
    // 20130224
    For i := 20 to 20 do // not 21
    begin
      Frm[FNo].Strings[i] := FetchElmFNo(RetNo, S2FNo, i);
      Tv[i] := Vl(FetchElmFNo(RetNo, S2FNo, i));
    end;

    For i := 22 to 24 do
    begin
      Frm[FNo].Strings[i] := FetchElmFNo(RetNo, S2FNo, i);
      Tv[i] := Vl(FetchElmFNo(RetNo, S2FNo, i));
    end;

    // ret[RetNo].Frm[FNo].Strings[15]:=GetS2PRVHeader(RetNo);  //20180314
    ret[RetNo].Frm[FNo].Strings[29] := PrvLong[GetPrvIndex(Prv)];
    // PrvLong[GetPrvIndex(ret[RetNo].Province)];

    // 20110409  age amount
    If UpperCase(Frm[FNo].Strings[28]) <> 'Y' then
    begin
      If Vl(FetchElmFNo(RetNo, S2FNo, 3)) = Constant[RY].MaxAgeAmount then
        Tv[3] := PrvConstant[RY].PrvMaxAgeAmount; // april 2005
    end;

    i := 4; // pension
    If UpperCase(Frm[FNo].Strings[27]) <> 'Y' then
    begin // april 2005
      If Vl(FetchElmFNo(RetNo, S2FNo, i)) = 1000 then // max fed
        Tv[i] := PrvConstant[RY].PrvMaxPensionAmount
      else
        Tv[i] := Vl(FetchElmFNo(RetNo, S2FNo, i));
    end;

    // Frm[FNo].Strings[15]:=GetS2PRVHeader(RetNo);   //20180314
    Frm[FNo].Strings[29] := PrvLong[GetPrvIndex(Prv)];
    // PrvLong[GetPrvIndex(Province)]; //20180314
    If Prv = 'NL' then
      ret[RetNo].Frm[FNo].Strings[29] := 'NL';
    If Prv <> 'SK' then
    begin
      Tv[25] := 0;
      Tv[26] := 0;
    end;

    // 20160220 //20160223 Igor
    If Prv <> 'BC' then
    Begin
      Tv[44] := 0;
      Tv[45] := 0;
      Tv[46] := 0; // 20161127
    end;

    If Prv <> 'NU' then
    begin
      Tv[32] := 0;
    end;

    If CouplingSw = True then
    begin
      SpRetNo := GetSpRetNo(RetNo);
      Tv[3] := Vl(FetchElm(SpRetNo, Prv + '428', 24));
      Tv[4] := Vl(FetchElm(SpRetNo, Prv + '428', 34));
      Tv[5] := Vl(FetchElm(SpRetNo, Prv + '428', 36));
      If Prv = 'SK' then
      begin
        Tv[25] := Vl(FetchElm(SpRetNo, 'SK428', 66));
        Tv[26] := Vl(FetchElm(SpRetNo, 'SK428', 67));
        // 20160216 Igor
        Tv[42] := Vl(FetchElm(RetNo, 'SK428', 84)); // 20160214
      end;
      { M15 }
      If UpperCase(FetchElm(SpRetNo, 'S11PRV', 25)) = 'Y' then
        Tv[6] := Vl(FetchElm(SpRetNo, 'S11PRV', 10));

      //20200202
      if Ret[retNo].Province='NB' then
      Begin
      If UpperCase(FetchElm(SpRetNo, 'S11', 25)) = 'Y' then //20180401
        Tv[6] := Vl(FetchElm(SpRetNo, 'S11', 10));
      End;

    end;

    If UpperCase(Frm[FNo].Strings[28]) <> 'Y' then
      Tv[3] := MinR(Tv[3], PrvConstant[RY].PrvMaxAgeAmount);

    If UpperCase(Frm[FNo].Strings[27]) <> 'Y' then
      Tv[4] := MinR(PrvConstant[RY].PrvMaxPensionAmount, Tv[4]);

    If (Prv = 'ON') then { if eq to max fed }
    begin
      If Tv[3] = Constant[RY].MaxAgeAmount then
        Tv[3] := PrvConstant[RY].PrvMaxAgeAmount;
      If Tv[4] = 1000 then { max fed pens ded }
        Tv[4] := PrvConstant[RY].PrvMaxPensionAmount;
    end;

    If CalcAge(GetSpouseBirthDate(RetNo)) < 18 then
      Tv[5] := MinR(Tv[5], PrvConstant[RY].PrvMaxDisability + PrvConstant[RY]
        .PrvMaxDisabSupl18)
    else
      Tv[5] := MinR(Tv[5], PrvConstant[RY].PrvMaxDisability);

    If FullTONIProvince(RetNo) then
    begin
      Tv[6] := MinR(Tv[6], PrvConstant[RY].PrvMaxEducXfer);
    end;

    Tv[7] := Tv[32] + Tv[25] + Tv[34] + Tv[3] + Tv[26] + Tv[4] + Tv[5] + Tv[6];
    Tv[24] := MaxR(0, Tv[22] - Tv[23]);
    Tv[8] := Tv[24];

    Tv[9] := PrvConstant[RY].PrvPersAmount;

    Tv[9] := MinR(Tv[9], PrvConstant[RY].PrvPersAmount);
    Tv[11] := MinR(Tv[11], Constant[RY].MaxCpp);
    Tv[13] := MinR(Tv[13], Constant[RY].MaxUI52);
    If CouplingSw = True then
    begin
      Tv[9] := Vl(FetchElm(SpRetNo, SpTaxFormName, 31));
      Tv[11] := Vl(FetchElm(SpRetNo, SpTaxFormName, 31));
      Tv[12] := Vl(FetchElm(SpRetNo, SpTaxFormName, 32));
      Tv[35] := ret[RetNo].Lnn[31217];
      Tv[13] := Vl(FetchElm(SpRetNo, SpTaxFormName, 33));
      If (Prv = 'NL') or (Prv = 'ON') or (Prv = 'MB') or (Prv = 'AB') or
        (Prv = 'BC') then
        Tv[31] := Vl(FetchElm(SpRetNo, SpTaxFormName, 51)) // adoption
      else
        Tv[31] := 0;

      Tv[33] := 0; // fitness 5838
      If (Prv = 'BC') then
      begin
        Tv[33] := Vl(FetchElm(SpRetNo, SpTaxFormName, 83)); // 20160220
        Tv[40] := Vl(FetchElm(SpRetNo, SpTaxFormName, 86)); // 20180225
        Tv[43] := Vl(FetchElm(SpRetNo, SpTaxFormName, 87)); // 20180225
        Tv[46] := Vl(FetchElm(RetNo, 'BC428', 88)); // 20161127
      end;
      if SpRetNo > 0 then // 20180202
        Tv[14] := Vl(FetchElm(SpRetNo, SpTaxFormName, 39));
      // tuition  //20120131  //20140315

      If (Prv = 'YT') then
        Tv[36] := Vl(FetchElm(SpRetNo, 'YT428', 73))
      else
        Tv[36] := 0;
    end; // coupling

    If (Prv = 'MB') or (Prv = 'YT') then // fitness
      // ok
    else
      Tv[33] := 0;

    If (Prv <> 'YT') then
      Tv[34] := 0;
    If (Prv <> 'YT') then
      Tv[36] := 0;
    If (Prv <> 'YT') then
      Tv[37] := 0;

    // 20120131
    If CouplingSw = True then // 20170102
    Begin
      If Prv = 'MB' then
      begin
        Tv[38] := Vl(FetchElm(SpRetNo, SpTaxFormName, 67)); // 5839
        Tv[43] := Vl(FetchElm(SpRetNo, 'MB428', 78));
        // 20170102 //20160214 //20160216 Igor //Vl(FetchElm(RetNo,'MB428',78));  //20160214 //20160216 Igor
      end
      Else
      Begin
        Tv[38] := 0;
        Tv[43] := 0; // 20160214
      end;
    End;

    // 20160220 //20160223 Igor
    // 5841 Tv[39]
    If (Prv = 'BC') then
      Tv[39] := Vl(FetchElm(RetNo, 'BC428', 84));
    If (Prv = 'MB') then
      Tv[39] := Vl(FetchElm(RetNo, 'MB428', 74));
    If (Prv = 'YT') then
      Tv[39] := Vl(FetchElm(RetNo, 'YT428', 65));

    // 20120131
    If Prv = 'NL' then
    begin
      Tv[40] := Vl(FetchElm(SpRetNo, SpTaxFormName, 90)); // 5830
      Tv[41] := Vl(FetchElm(SpRetNo, SpTaxFormName, 91)); // 5831
    end
    Else If (Prv = 'MB') then // 20160214 //20160216 Igor
    begin
      Tv[40] := Vl(FetchElm(SpRetNo, SpTaxFormName, 77)); // 5830
    end
    Else
    Begin
      Tv[40] := 0;
      Tv[41] := 0;
    end;

    Tv[16] := Tv[9] + Tv[11] + Tv[12] + Tv[35] + Tv[13] + Tv[31] + Tv[36] +
      Tv[37] + Tv[33] + Tv[14]; // 20160220 //20160223 Igor
    Tv[16] := Tv[16] + Tv[38] + Tv[39] + Tv[44] + Tv[45] + Tv[43] + Tv[40] +
      Tv[41] + Tv[42]; // 20160220  //20160223 Igor
    Tv[16] := Tv[16] + Tv[46]; // 20161127 bc back-to-scholl

    Tv[17] := MaxR(0, Tv[8] - Tv[16]);
    Tv[18] := Tv[17];
    Tv[19] := MaxR(0, (Tv[7] - Tv[18]));

    If IsPreBankruptcyReturn(RetNo) then
      Tv[19] := Tv[19] * Vl(FetchElm(RetNo, 'BANKRPT', 2)) / 366; // 20161227
    If UpperCase(Frm[FNo].Strings[10]) = 'Y' then
      Tv[19] := Tv[21];

    // 20151220
    // If (Ret[RetNo].MarStatus >2)
    If (ret[RetNo].MarStatus < 3)
    // or (SeparatedForLessThan90Days(RetNo))  //20151222  //20160318 //20160505 Igor
    then
      // ok
    Else
    begin
      If (UpperCase(Frm[FNo].Strings[20]) <> 'Y') then
      begin
        // 20160126   //15 is the prv naame
        For i := 1 to 13 do
        begin
          Frm[FNo].Strings[i] := '';
          Tv[i] := 0;
        end;
        Tv[14] := 0; // 20180202
        For i := 16 to 21 do
        begin
          Frm[FNo].Strings[i] := '';
          Tv[i] := 0;
        end;
      end;
    end;
  end; { with ret[retno] }
  SaveTv(RetNo, FName, FNo);
end;


Function FullTONIMJ(RetNo: Integer; Prv: String): Boolean;
begin
  Result := True;
end;

Procedure InitMJS2(RetNo: Integer);
Var
  i, FNo, Cnt: Integer;
  FName: String;
  Prv: String;
begin
  If ret[RetNo].FormHasData['S2'] = false then
    exit;

  Cnt := 1;

  Prv := 'AB';
  If Vl(GetMJAlloc(RetNo, Prv)) > 0 then
  begin
    CreateMJS2(RetNo, Prv, Cnt);
    Inc(Cnt);
  end;

  Prv := 'BC';
  If Vl(GetMJAlloc(RetNo, Prv)) > 0 then
  begin
    CreateMJS2(RetNo, Prv, Cnt);
    Inc(Cnt);
  end;

  Prv := 'MB';
  If Vl(GetMJAlloc(RetNo, Prv)) > 0 then
  begin
    CreateMJS2(RetNo, Prv, Cnt);
    Inc(Cnt);
  end;

  Prv := 'NL';
  If Vl(GetMJAlloc(RetNo, Prv)) > 0 then
  begin
    CreateMJS2(RetNo, Prv, Cnt);
    Inc(Cnt);
  end;

  Prv := 'NS';
  If Vl(GetMJAlloc(RetNo, Prv)) > 0 then
  begin
    CreateMJS2(RetNo, Prv, Cnt);
    Inc(Cnt);
  end;

  Prv := 'NB';
  If Vl(GetMJAlloc(RetNo, Prv)) > 0 then
  begin
    CreateMJS2(RetNo, Prv, Cnt);
    Inc(Cnt);
  end;

  Prv := 'NT';
  If Vl(GetMJAlloc(RetNo, Prv)) > 0 then
  begin
    CreateMJS2(RetNo, Prv, Cnt);
    Inc(Cnt);
  end;

  Prv := 'NU';
  If Vl(GetMJAlloc(RetNo, Prv)) > 0 then
  begin
    CreateMJS2(RetNo, Prv, Cnt);
    Inc(Cnt);
  end;

  Prv := 'ON';
  If Vl(GetMJAlloc(RetNo, Prv)) > 0 then
  begin
    CreateMJS2(RetNo, Prv, Cnt);
    Inc(Cnt);
  end;

  Prv := 'PE';
  If Vl(GetMJAlloc(RetNo, Prv)) > 0 then
  begin
    CreateMJS2(RetNo, Prv, Cnt);
    Inc(Cnt);
  end;

  Prv := 'SK';
  If Vl(GetMJAlloc(RetNo, Prv)) > 0 then
  begin
    CreateMJS2(RetNo, Prv, Cnt);
    Inc(Cnt);
  end;

  Prv := 'YT';
  If Vl(GetMJAlloc(RetNo, Prv)) > 0 then
  begin
    CreateMJS2(RetNo, Prv, Cnt);
    Inc(Cnt);
  end;

end;

Procedure InitMJS11(RetNo: Integer);
Var
  i, j, FNo, Cnt: Integer;
  FName: String;
  Prv: String;
begin
  If ret[RetNo].FormHasData['S11'] = false then
    exit;
  Cnt := 1;
  Prv := 'AB';
  If Vl(GetMJAlloc(RetNo, Prv)) > 0 then
  begin
    CreateMJS11(RetNo, Prv, Cnt);
    Inc(Cnt);
  end;

  Prv := 'BC';
  If Vl(GetMJAlloc(RetNo, Prv)) > 0 then
  begin
    CreateMJS11(RetNo, Prv, Cnt);
    Inc(Cnt);
  end;

  Prv := 'MB';
  If Vl(GetMJAlloc(RetNo, Prv)) > 0 then
  begin
    CreateMJS11(RetNo, Prv, Cnt);
    Inc(Cnt);
  end;

  Prv := 'NL';
  If Vl(GetMJAlloc(RetNo, Prv)) > 0 then
  begin
    CreateMJS11(RetNo, Prv, Cnt);
    Inc(Cnt);
  end;

  Prv := 'NB';
  If Vl(GetMJAlloc(RetNo, Prv)) > 0 then
  begin
    CreateMJS11(RetNo, Prv, Cnt);
    Inc(Cnt);
  end;

  Prv := 'NS';
  If Vl(GetMJAlloc(RetNo, Prv)) > 0 then
  begin
    CreateMJS11(RetNo, Prv, Cnt);
    Inc(Cnt);
  end;

  Prv := 'NT';
  If Vl(GetMJAlloc(RetNo, Prv)) > 0 then
  begin
    CreateMJS11(RetNo, Prv, Cnt);
    Inc(Cnt);
  end;

  Prv := 'NU';
  If Vl(GetMJAlloc(RetNo, Prv)) > 0 then
  begin
    CreateMJS11(RetNo, Prv, Cnt);
    Inc(Cnt);
  end;

  Prv := 'ON';
  If Vl(GetMJAlloc(RetNo, Prv)) > 0 then
  begin
    CreateMJS11(RetNo, Prv, Cnt);
    Inc(Cnt);
  end;

  Prv := 'YT';
  If Vl(GetMJAlloc(RetNo, Prv)) > 0 then
  begin
    CreateMJS11(RetNo, Prv, Cnt);
    Inc(Cnt);
  end;

  Prv := 'PE';
  If Vl(GetMJAlloc(RetNo, Prv)) > 0 then
  begin
    CreateMJS11(RetNo, Prv, Cnt);
    Inc(Cnt);
  end;

  Prv := 'SK';
  If Vl(GetMJAlloc(RetNo, Prv)) > 0 then
  begin
    CreateMJS11(RetNo, Prv, Cnt);
    Inc(Cnt);
  end;

end;

Procedure CreateMJS2(RetNo: Integer; Prv: String; Cnt: Integer);
Var
  i, FNo: Integer;
  FName: String;
begin
  FName := 'S2MJ#' + AllTrim(IntToStr(Cnt));
  FNo := GetFormNo(FName);
  If FNo = 0 then
    AddPageInstance(RetNo, 'S2MJ', '#' + AllTrim(IntToStr(Cnt)));
  // 20160119 Igor
  FNo := GetFormNo(FName);
  InitFormData(RetNo, FNo);
  S2MJ(RetNo, FName, FNo, Prv);
end;

Procedure CreateMJS11(RetNo: Integer; Prv: String; Cnt: Integer);
Var
  i, FNo: Integer;
  FName: String;
begin
  FName := 'S11MJ#' + AllTrim(IntToStr(Cnt));
  FNo := GetFormNo(FName);
  If FNo = 0 then
    AddPageInstance(RetNo, 'S11MJ', '#' + AllTrim(IntToStr(Cnt)));
  // 20160119 Igor
  FNo := GetFormNo(FName);
  InitFormData(RetNo, FNo);
  S11MJ(RetNo, FName, FNo, Prv);
end;

Procedure S11MJ(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
var
  i, S11FNo, PrvTaxFNo: Integer;
Begin
  InitPrvConstants(Prv);

  LoadTv(RetNo, FName, FNo);
  With ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin

    S11FNo := GetFormNo('S11PRV'); // 20170513
    (* //20170513
      {Copy from federal}
      S11FNo := GetFormNo('S11'+PRV); //GetFormNo('S11');  //20150304
      IF PRV='ON' then S11FNo:=GetFormNo('S11PRV'); //20150304
    *)

    For i := 1 to 9 do
    begin
      ret[RetNo].Frm[FNo].Strings[i] := FetchElmFNo(RetNo, S11FNo, i);
      Tv[i] := Vl(FetchElmFNo(RetNo, S11FNo, i));
    end;

    For i := 11 to 21 do
    begin
      ret[RetNo].Frm[FNo].Strings[i] := FetchElmFNo(RetNo, S11FNo, i);
      Tv[i] := Vl(FetchElmFNo(RetNo, S11FNo, i));
    end;
    //full time months //201200407 ?? experimental
    //if LeftStr(ret[RetNo].Frm[FNo].Strings[32],2)<> UpperCase(Ret[RetNo].Province) Then Ret[RetNo].Frm[FNo].Strings[12]:='';

    For i := 25 to 26 do
    begin
      ret[RetNo].Frm[FNo].Strings[i] := FetchElmFNo(RetNo, S11FNo, i);
      Tv[i] := Vl(FetchElmFNo(RetNo, S11FNo, i));
    end;

    If Frm[FNo].Strings[25] = '' then
    begin
      If ret[RetNo].MarStatus < 3 then
        ret[RetNo].Frm[FNo].Strings[25] := 'Y';
      If Frm[FNo].Strings[26] > '' then
        Frm[FNo].Strings[25] := 'N';
    end;
    If MyStrToInt(Frm[FNo].Strings[15]) > 12 then
      Frm[FNo].Strings[15] := '12';
    If MyStrToInt(Frm[FNo].Strings[12]) > 12 then
      Frm[FNo].Strings[12] := '12';
    Frm[FNo].Strings[33] :=
      AllTrim(IntToStr(PrvConstant[RY].PrvPartEducPerMonth));
    Frm[FNo].Strings[34] := AllTrim(IntToStr(PrvConstant[RY].PrvEducPerMonth));

    Frm[FNo].Strings[32] := GetS11MJHeader(RetNo, Prv);
    If (LeftStr(Frm[FNo].Strings[32], 2) = 'YT') or
      (LeftStr(Frm[FNo].Strings[32], 2) = 'NU') then
    begin
      Frm[FNo].Strings[41] := Frm[FNo].Strings[15];
      Frm[FNo].Strings[40] := '20';
      Frm[FNo].Strings[45] := Frm[FNo].Strings[12];
      Frm[FNo].Strings[44] := '65';
      Tv[39] := Vl(Frm[FNo].Strings[15]) * Vl(Frm[FNo].Strings[33]);
      Tv[42] := Vl(Frm[FNo].Strings[41]) * Vl(Frm[FNo].Strings[40]);
      Tv[43] := Vl(Frm[FNo].Strings[12]) * Vl(Frm[FNo].Strings[34]);
      Tv[46] := Vl(Frm[FNo].Strings[45]) * Vl(Frm[FNo].Strings[44]);
      Tv[14] := Tv[39] + Tv[42];
      Tv[2] := Tv[43] + Tv[46];
    end;
    If LeftStr(Frm[FNo].Strings[32], 2) = 'YT' then
    begin
      Tv[14] := Tv[39] + Tv[42];
      Tv[2] := Tv[43] + Tv[46];
    end
    else
    begin
      Tv[14] := Vl(Frm[FNo].Strings[15]) * Vl(Frm[FNo].Strings[33]);
      Tv[2] := Vl(Frm[FNo].Strings[12]) * Vl(Frm[FNo].Strings[34]);
    end;

    Tv[3] := Tv[1] + Tv[14] + Tv[2];
    Tv[16] := Tv[3];
    Tv[4] := Tv[13] + Tv[16];

    Frm[FNo].Strings[31] := PrvLong[GetPrvIndex(Prv)];

    Tv[5] := Lnn[26000];
    Tv[6] := GetMj5804To5848(RetNo, Prv);

    Tv[7] := MaxR(0, Tv[5] - Tv[6]);
    Tv[17] := MinR(Tv[13], Tv[7]);
    Tv[18] := Tv[17];
    Tv[19] := MaxR(0, Tv[7] - Tv[17]);
    Tv[8] := MinR(Tv[16], Tv[19]);
    Tv[21] := Tv[18] + Tv[8];

    Tv[35] := PrvConstant[RY].PrvMaxEducXfer;

    If (Prv = 'AB') or (Prv = 'BC') or (Prv = 'ON') or (Prv = 'SK') then
    begin
      Tv[22] := MinR(Tv[16], Tv[35]);
      Tv[23] := Tv[8];
      Tv[24] := MaxR(0, Tv[22] - Tv[23]);
    end
    else
      for i := 22 to 24 do
        Tv[i] := 0;

    If ((UpperCase(Frm[FNo].Strings[25]) = 'Y') or (Frm[FNo].Strings[26] > ''))
    then
    begin
      If UpperCase(Frm[FNo].Strings[36]) <> 'Y' then
        Tv[10] := Tv[24];
    end;
    If Tv[10] > Tv[24] then
      Tv[10] := Tv[24];
  end;
  SaveTv(RetNo, FName, FNo);
end;


Function GetMjPrvDisab(RetNo, FNo: Integer; Prv: String): Real;
Var
  i: Integer;
  Sv: Array [15 .. 24] of Real;
  MaxDisability, MaxDisabSupl18, DisabSuplBase: Real;
begin
  Result := 0;
  If ret[RetNo].Lnn[31600] = 0 then
    exit;

  // 20110128
  InitPrvConstants(Prv);
  MaxDisability := PrvConstant[RY].PrvMaxDisability;
  MaxDisabSupl18 := PrvConstant[RY].PrvMaxDisabSupl18;
  DisabSuplBase := PrvConstant[0].PrvDisabSuplBase;

  If ret[RetNo].Age >= 18 then
  Begin
    Result := MaxDisability;
    exit;
  end;

  // less than 18
  For i := 15 to 24 do
    Sv[i] := 0;
  Sv[15] := MaxDisability * ret[RetNo].PartYear;
  Sv[16] := MaxDisabSupl18;
  Sv[19] := Sv[17] + Sv[18];
  Sv[20] := DisabSuplBase;
  Sv[21] := MaxR(0, Sv[19] - Sv[20]);
  Sv[22] := MaxR(0, Sv[16] - Sv[21]);
  Sv[23] := Sv[22];
  Sv[24] := Sv[15] + Sv[23];
  If Sv[15] = 0 then
    for i := 16 to 24 do
      ret[RetNo].Frm[FNo].Tv[i] := 0;
  Result := Sv[24];
end;

Function GetS2MjFNo(RetNo: Integer; Prv: String): Integer;
{ needs it as forms only have #1, #2, etc. Heading elm[15] tell us the prv }
Var
  i: Integer;
  FName: String;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'S2MJ' then
    begin
      If LeftStr(FetchElmFNo(RetNo, FRec.FormNo, 15), 2) = Prv then
      begin { right Prv }
        Result := FRec.FormNo;
        exit;
      end;
    end; { founf a S2MJ }
  end; { i }
end;

Function GetS11MjFNo(RetNo: Integer; Prv: String): Integer;
{ needs it as forms only have #1, #2, etc. Heading elm[15] tell us the prv }
Var
  i: Integer;
  FName: String;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'S11MJ' then
    begin
      If LeftStr(FetchElmFNo(RetNo, FRec.FormNo, 32), 2) = Prv then
      begin { right Prv }
        Result := FRec.FormNo;
        exit;
      end;
    end; { founf a S11MJ }
  end; { i }
end;

Function GetMj5804To5848(RetNo: Integer; Prv: String): Real;
Var
  i, k, FNo: Integer;
  FName: String;
begin
  // 20110313
  If Prv = 'NL' then
  begin
    k := 302;
    FName := 'T2203';
  end;
  If Prv = 'PE' then
  begin
    k := 328;
    FName := 'T2203';
  end;
  If Prv = 'NS' then
  begin
    k := 354;
    FName := 'T2203';
  end;

  If Prv = 'NB' then
  begin
    k := 528;
    FName := 'T2203';
  end;
  If Prv = 'ON' then
  begin
    k := 502;
    FName := 'T2203';
  end;
  If Prv = 'MB' then
  begin
    k := 554;
    FName := 'T2203';
  end;

  If Prv = 'SK' then
  begin
    k := 628;
    FName := 'T2203';
  end;
  If Prv = 'AB' then
  begin
    k := 654;
    FName := 'T2203';
  end;
  If Prv = 'BC' then
  begin
    k := 602;
    FName := 'T2203';
  end;

  If Prv = 'YT' then
  begin
    k := 886;
    FName := 'T2203';
  end;
  If Prv = 'NT' then
  begin
    k := 828;
    FName := 'T2203';
  end;
  If Prv = 'NU' then
  begin
    k := 854;
    FName := 'T2203';
  end;

  FNo := GetFormNo(FName);
  Result := 0;
  For i := 0 to 11 do
    Result := Result + Vl(FetchElmFNo(RetNo, FNo, k + i));
end;

//20190205
Procedure T2203(RetNo: Integer; FName: string; FNo: Integer);
var
  i, k, PrvNdx, HomePrvNdx, CurrentPrvNdx: Integer;
  NetIncome, SelfIncome, ExcessIncome, x, BfedTax: Real;
  NegExcessIncome:Real; //20230513
  NonHomePrvIncome: Real; // 20170422
  CurrentPrv: string[2];
  SelfEmplPrv: String;

  Prv: String;
  AllocPercent: Boolean; // 20170422
  CarePrvFNo, S5PrvFNo, S2MJFNo: Integer; //20240520
  Disab18FNo: Integer;
  //
  OnLineNo, PassWord, Url, NetFileDir:String; //20220416

Begin
 // Calcfullreturn(RetNo);  //gives problem
  CarePrvFNo := GetFormNo('CAREPRV');
  S5PrvFNo := GetFormNo('S5PRV');
  S2MjFNo:=GetFormNo('S2MJ');

  LoadTv(RetNo, FName, FNo);
  with ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
  
   If Frm[FNo].Strings[110]='' then  //no MJ
   Begin
     For i:=1 to 993 do Tv[i]:=0;
     SaveTv(RetNo, FName, FNo);
     Exit;
   end;

    Tv[1] := Lnn[23600] + Vl(FetchElm(RetNo, 'T1206', 3));
    Tv[2] := MaxR(0, Lnn[13500]) + MaxR(0, Lnn[13700]) + MaxR(0, Lnn[13900]) +
      MaxR(0, Lnn[14100]) + MaxR(0, Lnn[14300]) + MaxR(0, Lnn[12200]);
    //Tv[3] := Tv[1] - Tv[2];
    Tv[3] := MaxR(0, Tv[1] - Tv[2]); //20230513
    If Tv[1] - Tv[2]<0 then NegExcessIncome:=ABS(Tv[1] - Tv[2]);  //20230513

    NetIncome := Tv[1];
    SelfIncome := Tv[2];
    ExcessIncome := Tv[3];

    if Frm[FNo].Strings[121] + Frm[FNo].Strings[122] = '' then
      Frm[FNo].Strings[121] := 'X';

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
    i := 4;
    x := 0;
    Tv[95] := 100;
    NonHomePrvIncome := 0;
    Repeat
      If i = 95 then
        Inc(i, 7); // 20100415
      If i <> HomePrvNdx then
        x := x + Tv[i];
      If i <> HomePrvNdx then
        NonHomePrvIncome := NonHomePrvIncome + Tv[i + 1];
      Inc(i, 7);
    until i > 102; //88;

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
    //calc amount
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
        //If i = HomePrvNdx then  // ????  problem here???
        if (i = HomePrvNdx) and (i <> 39) then //20250922 Igor fix for ON
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
      xx:=Tv[i+3];    //20240404
      //20230513 Prepare % allocation for tax calculations
      //--------------------
      If Tv[i+3] > 0 then   //20240412
     // If Tv[i+1] > 0 then//If Tv[1] > 0 then   //20240404
     // If Tv[i] > 0 then//If Tv[1] > 0 then  //20231227
       Frm[FNo].strings[i + 4] :=  FormatFloat('0.0000', (Tv[i + 3] / Tv[1]) * 100)
      else
       Frm[FNo].strings[i + 4] := '';

      //  ------------------------
      Tv[97] := Tv[97] + Tv[i + 2];
      Tv[98] := Tv[98] + Tv[i + 3];
      Tv[99] := Tv[99] + Tv[i + 4];
      Inc(i, 7);
      // If i=95 then Inc(i,7);
    until i > 88; // to include NU //88;
    //for NU  //20231227
    i:=102;
    //If Tv[I] > 0 then
    If (Tv[i] > 0) or (Tv[i+1] > 0) or (Tv[i+2] > 0) then  //jz 20240507
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
    //why not TV instead of Fetchelm ?????????  //20231201
    Tv[10] := Tv[981]; //Vl(FetchElm(RetNo, 'T2203', 981));  // NF
    Tv[17] := Tv[982]; //Vl(FetchElm(RetNo, 'T2203', 982));  // PE
    Tv[24] := Tv[983]; //Vl(FetchElm(RetNo, 'T2203', 983));  // NS
    Tv[31] := Tv[984]; //Vl(FetchElm(RetNo, 'T2203', 984));  // NB
    Tv[38] := 0;                                  // QC
    Tv[45] := Tv[985]; //Vl(FetchElm(RetNo, 'T2203', 985));  // ON
    Tv[52] := Tv[986]; //Vl(FetchElm(RetNo, 'T2203', 986));  // MB
    Tv[59] := Tv[987]; //Vl(FetchElm(RetNo, 'T2203', 987));  // SK
    Tv[66] := Tv[988]; //Vl(FetchElm(RetNo, 'T2203', 988));  // AB

    Tv[73] := Tv[989]; //Vl(FetchElm(RetNo, 'T2203', 989));  // BC
    Tv[80] := Tv[990]; //Vl(FetchElm(RetNo, 'T2203', 990));  // YT
    Tv[87] := Tv[991]; //Vl(FetchElm(RetNo, 'T2203', 991));  // NT
    Tv[108] := Tv[992]; //Vl(FetchElm(RetNo, 'T2203', 992)); // NU

    Tv[94] := 0;
    //total tax //20200411
    i:=10;
    Tv[117]:=0;
    Repeat
     Tv[117]:=Tv[117]+Tv[i];
     Inc(i,7);
    Until i>87;
    Tv[117]:=Tv[117]+Tv[108];
  end;


  //==================== pg 2  =====================
  with ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    Tv[201] := Ret[RetNo].Lnn[42900]; //Vl(FetchElm(RetNo, 'S1', 109));  //20191220
    Tv[202] := Vl(FetchElm(RetNo, 'T1206', 6));
    // outside can
    Tv[203] := MaxR(Tv[201], Tv[202]);
    Tv[204] := Vl(FetchElm(RetNo, 'T2203', 92));
    // 20160216 Igor
    Tv[205] := Tv[203] * Tv[204] / 100;
    Tv[206] := 48;
    Tv[207] := Tv[205] * Tv[206] / 100;

    If SubjectToMinTax(RetNo) then
    begin
      For i := 201 to 207 do
        Tv[i] := 0;
    end;

    // qu abatement
    Tv[208] := MaxR(Tv[201], Tv[202]);
    Tv[209] := Vl(FetchElm(RetNo, 'T2203', 36));
    Tv[210] := Tv[208] * Tv[209] / 100;
    Tv[211] := 16.5;
    Tv[212] := Tv[210] * Tv[211] / 100;

    //miscelaneous hidden amounts
    Tv[232]:=Vl(FetchElm(RetNo,'BC428',87));  //BC search and rescue credit
    Tv[233]:=Vl(FetchElm(RetNo,'BC428',153));  //BC Food donation amount (not credit)
  end; //with

  CalcLine5612(RetNo, FNo); // for all


  //============PAGE 3 etc of T2203 all columns =========================================
 with ret[RetNo].Frm[FNo] do
 begin
  T2203Prov := 'NL';
  If Vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
  begin
   NLMJ(RetNo,'NLMJ',GetFormNo('NLMJ')); //DO NOT USE CALC   Calc(RetNo,'NLMJws'); //20240520
   CopyNL428ToT2203(RetNo, FNo, T2203Prov); // 20180314
   S11MJNL(RetNo,'S11MJNL',GetFormNo('S11MJNL'),T2203Prov);//Calc(RetNo,'S11MJNL'); // S11MJNL(RetNo,'S11MJNL',GetFormNo('S11MJNL')); //Do NOT use calc Calc(RetNo,'S11MJNL');   //20240504
   Tv[315] := Vl(FetchElm(RetNo, 'S11MJNL',21)); //COPY TUITION //2030503
  end;


  T2203Prov := 'PE';
  If Vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
  Begin
   PEMJ(RetNo,'PEMJ',GetFormNo('PEMJ')); //DO NOT USE CALC   Calc(RetNo,'NLMJws'); //20240520
   CopyPE428ToT2203(RetNo, FNo, T2203Prov); // 20180314
   S11MJPE(RetNo,'S11MJPE',GetFormNo('S11MJPE'),T2203Prov);
   Tv[341] := Vl(FetchElm(RetNo, 'S11MJPE',21)); //COPY TUITION //2030503
   If ret[RetNo].Province = 'PE' then ret[RetNo].Frm[FNo].Strings[412] := FetchElm(RetNo, 'PE428', 67);
  End;

  T2203Prov := 'NS';
  If Vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
  Begin
    NSMJ(RetNo,'NS28WS',GetFormNo('NSMJ')); //DO NOT USE CALC
    CopyNS428ToT2203(RetNo, FNo, T2203Prov); // 20180314
    S11MJNS(RetNo,'S11MJNS',GetFormNo('S11MJNS'),T2203Prov);
    Tv[367] := Vl(FetchElm(RetNo, 'S11MJNS',21)); //COPY TUITION //2030503
    If ret[RetNo].Province = 'NS' then ret[RetNo].Frm[FNo].Strings[412] := FetchElm(RetNo, 'NS428', 73);
  end;

  //NB ON and MB Copied from below to be in sequence //20240412
  T2203Prov := 'NB';
  If Vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
  BEGIN
   NBMJ(RetNo,'NBMJ',GetFormNo('NBMJ')); //DO NOT USE CALC
   CopyNB428ToT2203(RetNo, FNo, T2203Prov); // 20180314
   S11MJNB(RetNo,'S11MJNB',GetFormNo('S11MJNB'),T2203Prov);
   Tv[541] := Vl(FetchElm(RetNo, 'S11MJNB',21)); //COPY TUITION //2030503
  END;

  T2203Prov := 'ON';
  If Vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
  BEGIN
    ONMJ(RetNo,'ONMJ',GetFormNo('ONMJ')); //DO NOT USE CALC
    CopyON428ToT2203(RetNo, FNo, T2203Prov); // 20180314
    S11MJON(RetNo,'S11MJON',GetFormNo('S11MJON'),T2203Prov);
    Tv[515] := 0; // No tuitin S11 credit for ontario //20240522
  END;

  T2203Prov := 'MB';
  If Vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
  BEGIN
    MBMJ(RetNo,'MBMJ',GetFormNo('MBMJ')); //DO NOT USE CALC//Calc(RetNo,'MBMJws'); //20240520
    CopyMB428ToT2203(RetNo, FNo, T2203Prov); // 20180314
    S11MJMB(RetNo,'S11MJMB',GetFormNo('S11MJMB'),T2203Prov);
    Tv[567] := Vl(FetchElm(RetNo, 'S11MJMB',21)); //COPY TUITION //2030503
  END;

  //SK, AB, BC page
   T2203Prov := 'SK';
   If Vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
   Begin
    SKMJ(RetNo,'SKMJ',GetFormNo('SKMJ')); //DO NOT USE CALC//Calc(RetNo,'MBMJws'); //20240520
    CopySK428ToT2203(RetNo, FNo, T2203Prov); // 20180314
    S11MJSK(RetNo,'S11MJSK',GetFormNo('S11MJSK'),T2203Prov);
    Tv[641] := Vl(FetchElm(RetNo, 'S11MJSK',21)); //COPY TUITION //2030503
   // If ret[RetNo].Province = 'SK' then //20240521
   // begin
     ret[RetNo].Frm[FNo].Strings[686] := FetchElm(RetNo, 'SK428', 68);
     //Tv[133]:=Ret[retno].LNn[31200]//Volunteer firefighter //20240510 NO GOOD RISKY
     if (Ret[RetNo].Province ='SK')
     Or (T2203Prov ='SK') then
      Tv[64]:=Ret[RetNo].LNN[33199];  //20240511
   end;

   T2203Prov := 'AB';
   If Vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
   BEGIN
    ABMJ(RetNo,'ABMJ',GetFormNo('ABMJ'));
    CopyAB428ToT2203(RetNo, FNo, T2203Prov); // 20180314
    S11MJAB(RetNo,'S11MJAB',GetFormNo('S11MJAB'),T2203Prov);
    Tv[667] := Vl(FetchElm(RetNo, 'S11MJAB',21)); //COPY TUITION //2030503
   END;

   T2203Prov := 'BC';
   If Vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
   BEGIN
    BCMJ(RetNo,'BCMJ',GetFormNo('BCMJ'));
    CopyBC428ToT2203(RetNo, FNo, T2203Prov); // 20180314
    S11MJBC(RetNo,'S11MJBC',GetFormNo('S11MJBC'),T2203Prov);
    Tv[615] := Vl(FetchElm(RetNo, 'S11MJBC',21)); //COPY TUITION //2030503
    //if Ret[RetNo].Province='BC' then Tv[109]:=Ret[RetNo].LNN[31200]; //no good volunteer fire fighter //20240510
   END;

   T2203Prov := 'YT';
   If Vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
   BEGIN
    YTMJ(RetNo,'YTMJ',GetFormNo('YTMJ'));
    CopyYT428ToT2203(RetNo, FNo, T2203Prov); // 20180314
    S11MJYT(RetNo,'S11MJYT',GetFormNo('S11MJYT'),T2203Prov);
    Tv[899]:=Vl(FetchElm(RetNo,'S11MJYT',21)); //COPY TUITION //2030503 //20240511 erased by mistake
   END;

   T2203Prov := 'NT';
   If Vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
   BEGIN
     NTMJ(RetNo,'NTMJ',GetFormNo('NTMJ'));
     CopyNT428ToT2203(RetNo, FNo, T2203Prov); // 20180314
     S11MJNT(RetNo,'S11MJNT',GetFormNo('S11MJNT'),T2203Prov);
     Tv[841] := Vl(FetchElm(RetNo, 'S11MJNT',21)); //COPY TUITION //2030503
   END;

   T2203Prov := 'NU';
   If Vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
   Begin
    NUMJ(RetNo,'NUMJ',GetFormNo('NUMJ'));
    CopyNU428ToT2203(RetNo, FNo, T2203Prov); // 20180314
    S11MJNU(RetNo,'S11MJNU',GetFormNo('S11MJNU'),T2203Prov);
    Tv[867] := Vl(FetchElm(RetNo, 'S11MJNU',21)); //COPY TUITION //2030503
    If ret[RetNo].Province = 'NU' then
      ret[RetNo].Frm[FNo].Strings[806] := FetchElm(RetNo, 'NU428', 75);
   end;

   (* Need adjustment for Medical expenses
   //other  T2203 ADJustments  //202405111
   //Line 58729 mkedical expenses forother dependants
   if Ret[RetNo].Province <>'ON' then  TV[518]:=0;
   if Ret[RetNo].Province <>'NB' then  TV[544]:=0;
   if Ret[RetNo].Province <>'MB' then  TV[570]:=0;

   if Ret[RetNo].Province <>'NL' then  TV[318]:=0;
   if Ret[RetNo].Province <>'PE' then  TV[344]:=0;
   if Ret[RetNo].Province <>'NS' then  TV[370]:=0;

   if Ret[RetNo].Province <>'BC' then  TV[644]:=0;
   if Ret[RetNo].Province <>'AB' then  TV[670]:=0;
   if Ret[RetNo].Province <>'BC' then  TV[618]:=0;

   if Ret[RetNo].Province <>'YT' then  TV[902]:=0;
   if Ret[RetNo].Province <>'NT' then  TV[844]:=0;
   if Ret[RetNo].Province <>'NU' then  TV[870]:=0;
   *)
 end; //with

  //==================   pg 7  ==========================
  with ret[RetNo].Frm[FNo] do
  begin
    For i := 981 to 913 do
      Tv[i] := 0;

    Tv[981] := Vl(FetchElm(RetNo, 'NLMJ', 118)); // 20210411  //Tv[981] := Vl(FetchElm(RetNo, 'NLMJ', 186)); // 20180307
    Tv[982] := Vl(FetchElm(RetNo, 'PEMJ', 103));
    Tv[983] := Vl(FetchElm(RetNo, 'NSMJ', 123));
    Tv[984] := Vl(FetchElm(RetNo, 'NBMJ', 141));
    Tv[985] := Vl(FetchElm(RetNo, 'ONMJ', 122)); // 20110128
    Tv[986] := Vl(FetchElm(RetNo, 'MBMJ', 111));
    Tv[987] := Vl(FetchElm(RetNo, 'SKMJ', 127));
    Tv[988] := Vl(FetchElm(RetNo, 'ABMJ', 46)); //Vl(FetchElm(RetNo, 'ABMJ', 17)); //20190317
    Tv[989] := Vl(FetchElm(RetNo, 'BCMJ', 113));
    Tv[990] := Vl(FetchElm(RetNo, 'YTMJ', 123));
    Tv[991] := Vl(FetchElm(RetNo, 'NTMJ', 64));
    Tv[992] := Vl(FetchElm(RetNo, 'NUMJ', 44));
    Tv[993] := AddColumns(981, 992, 1);
  end;
 //KEEP if GetSinNo(retNo)='870001229' then begin Ret[Retno].lnn[42800]:=8369.33; Tv[117]:=8369.33;end;  //20220419

  SaveTv(RetNo, FName, FNo);
End;



Procedure CopySK428ToT2203(RetNo, FNo: Integer; Prv: String); // 20180314
Var
  S428FNo, T2203FNo: Integer;
  x: Real;
Begin
  S428FNo := GetFormNo('SK428');
  T2203FNo := GetFormNo('T2203');  //20200404
  with ret[RetNo].Frm[FNo] do
  begin
    if FetchElm(RetNo,'T2203',154)<>'1.00' then  //if '1' then allow override //'Y' then //no override
    Begin
    Tv[628] := Vl(FetchElmFNo(RetNo, S428FNo, 23));
   // ShowMessage('bfr 629 '+FetchElmFNo(RetNo, T2203FNo, 257));
    Tv[629] := T2203SKAgeDed; //Vl(FetchElmFNo(RetNo, T2203FNo, 257));//Vl(FetchElmFNo(RetNo, S428FNo, 24));
    Tv[630] := Vl(FetchElmFNo(RetNo, S428FNo, 28));  //dep ni
    // ?? Tv[72]:=??
    // If Ret[RetNo].Province='SK' then StoreElm(RetNo,T2203FNo,686,FetchElmFNo(RetNo,S428FNo,68)); //20180328
    Tv[631] := T2203SKEligDepend; // 20180313
    Tv[632] := T2203SKInfirmAmount; // 20180313
    If ret[RetNo].Province = 'SK' Then Tv[682] := Vl(FetchElmFNo(RetNo, S428FNo, 66));
    If ret[RetNo].Province = 'SK' Then Tv[683] := Vl(FetchElmFNo(RetNo, S428FNo, 67));
    Tv[633] := Vl(FetchElmFNo(RetNo, S428FNo, 31));
    Tv[634] := Ret[RetNo].LNN[31000];//Vl(FetchElmFNo(RetNo, S428FNo, 32));  //20240513
    Tv[635] := Vl(FetchElmFNo(RetNo, S428FNo, 33));
    Tv[93] := Vl(FetchElmFNo(RetNo, S428FNo, 83));

     Tv[133]:= Vl(FetchElmFNo(RetNo, S428FNo, 48));  //20210410
     Tv[134]:= Vl(FetchElmFNo(RetNo, S428FNo, 49));  //20210410
     Tv[135]:= Vl(FetchElmFNo(RetNo, S428FNo, 70));  //20210410
     Tv[111] := Vl(FetchElmFNo(RetNo, S428FNo, 84));
     If Ret[RetNo].province='SK' then Tv[636]:=Vl(FetchElmFNo(RetNo, S428FNo, 34)); //20240608
     Tv[637] := Vl(FetchElm(RetNo, 'SKMJWS',46)); //20240605 T2203SKCaregiver;

    //Vl(FetchElm(RetNo,'SK428',35)); //20230506 T2203SKCaregiver; // 20180313  //20210417
    Tv[638] := T2203SKDisab; // VL(FetchElmFNo(RetNo,S428FNo,36));
    Tv[639] := T2203SKDisabXfer; // 20180313

    Tv[136]:=AddColumns(628, 639, 1) + Tv[682] + Tv[683] +tv[93]+AddColumns(133,135,1)+Tv[111];     //+Tv[147];//2024031720404
    Tv[226] := Tv[136]; //20210410

    Tv[640] := Vl(FetchElmFNo(RetNo, S428FNo, 38));

    Tv[641]:=0;  //20230508 Tuition

    Tv[643] := T2203SKSpouseXfer;  //Tv[339] := T2203PEDisabXfer;
    //KEEP if GetSinNo(RetNo)='870002037' then Tv[643]:=14501;  //20221419  case #8

    Tv[720] :=Vl(FetchElm(RetNo,'T1',48)); //Vl(FetchElmFNo(RetNo, S428FNo, 44));
    If Vl(GetMJAlloc(RetNo, 'SK')) > 0 then Tv[644] := ret[RetNo].Lnn[33199] else  Tv[644] := 0;

    Tv[645] := Vl(FetchElm(RetNo, 'S9', 13));

    Tv[646]:=Tv[136]+addColumns(640, 641, 1) +Tv[643]+ Tv[720]+AddColumns(644,645,1); //20210410
    Tv[647] := 10.50; // %  //20190317
    Tv[648] := Tv[646] * Tv[647] / 100;

    Tv[649] := Vl(FetchElm(RetNo, 'S9', 15));
    Tv[650] := 14.50; //14.75; // %    //20190317
    Tv[651] := Tv[649] * Tv[650] / 100;
    Tv[653] := Tv[648] + Tv[651];
    if Tv[149]>0 then Tv[653]:=Tv[149];  //keep
    //keep if GetSinNo(retNo)='870001229' then Tv[653]:=Tv[149];  //20220419
   end;
  End;
End;

// AB  //20180316
Procedure CopyAB428ToT2203(RetNo, FNo: Integer; Prv: String); // 20180314
Var
  S428FNo, T2203FNo, CarePrvFNo, S5PrvFNo: Integer;
  x: Real;
Begin
  S428FNo := GetFormNo('AB428');
  T2203FNo := GetFormNo('T2203');   //20200404
  with ret[RetNo].Frm[FNo] do
  begin
    if FetchElm(RetNo,'T2203',154)<>'0.00' then  //if '1' then allow override //'Y' then //no override
    Begin
     Tv[654] := Vl(FetchElmFNo(RetNo, S428FNo, 23));
     Tv[655] := T2203ABAgeDed; //Vl(FetchElmFNo(RetNo, S428FNo, 24));
     Tv[656] := Vl(FetchElmFNo(RetNo, S428FNo, 28));
     // ??TV[79]:=VL(FetchElmFNo(RetNo,S428FNo,28));
     Tv[657] := T2203ABEligDepend; // 20180313
     Tv[658] := T2203ABInfirmAmount; // 20180313
     Tv[659] := Vl(FetchElmFNo(RetNo, S428FNo, 31));
     Tv[660] := Ret[RetNo].LNN[31000]; //20240513); ////Vl(FetchElm(RetNoVl(FetchElmFNo(RetNo, S428FNo, 32));
     Tv[661] := Vl(FetchElmFNo(RetNo, S428FNo, 33));
     Tv[94] := Vl(FetchElmFNo(RetNo, S428FNo, 4));
     If ret[RetNo].Province = 'AB' Then
      Tv[680] := Vl(FetchElmFNo(RetNo, S428FNo, 51));
     If ret[RetNo].Province = 'AB' Then Tv[662] := Vl(FetchElmFNo(RetNo, S428FNo, 34)); //20240608
     //Tv[662] :=//Vl(FetchElm(RetNo, 'S2MJAB',19));
     //20240529 //428FNo, 34));//If ret[RetNo].Province = 'AB' Then Tv[662] := Vl(FetchElmFNo(RetNo, S428FNo, 34));
     Tv[663] := Vl(FetchElm(RetNo, 'ABMJWS',46)); //20240605  //T2203ABCaregiver;
     Tv[664] := T2203ABDisab; // VL(FetchElmFNo(RetNo,S428FNo,36));

     Tv[665] := T2203ABDisabXfer;

     Tv[140]:= AddColumns(654, 661, 1) + Tv[94]+ Tv[680] + AddColumns(662, 665, 1);

     Tv[227] := Tv[140];
    // x := x + AddColumns(666, 669, 1) + Tv[721] + Tv[670] + Tv[671];


     Tv[666] := Vl(FetchElmFNo(RetNo, S428FNo, 38));
     If Ret[RetNo].Province='AB' then  //20220514
      Tv[667] := Vl(FetchElmFNo(RetNo, GetFormNo('S11MJ' + UpperCase(Prv)), 21)); //20210417 //NO albertaclaim Vl(FetchElmFNo(RetNo, GetFormNo('S11MJ' + UpperCase(Prv)), 21)); //20190317 Tv[240];

     // VL(FetchElmFNo(RetNo,S428FNo,39)); //20180324
     Tv[668] := Vl(FetchElmFNo(RetNo, S428FNo, 40));
     Tv[669] := T2203ABSpouseXfer; // Vl(FetchElm(RetNo,'S2MJAB',19));
     Tv[721] := Vl(FetchElm(RetNo,'T1',48)); //Vl(FetchElmFNo(RetNo, S428FNo, 44));
     Tv[670] := Vl(FetchElmFNo(RetNo, S428FNo, 45));

    // T2203ABDisab; //VL(FetchElmFNo(RetNo,S428FNo,44));
    // Tv[671] := Vl(FetchElm(RetNo, 'S9', 13));
     Tv[672]:=Tv[140]+AddColumns(666, 667, 1) + +tv[669]+Tv[721] + Tv[670]; // + Tv[671];
     Tv[673] := 8;   //%   //jz//MJCERT2025v1 - update as per T2203 form from 10%
     Tv[671] := Tv[672] * Tv[673] / 100;

     //TV[642]:=???
     Tv[674]:=60;
     Tv[642]:=Vl(FetchElm(RetNo,'S9',13));  //20240526
     Tv[675]:=Tv[642]*Tv[674]/100;

     Tv[676] := Vl(FetchElm(RetNo, 'S9', 15));
     Tv[677] := 21; // %  CRA says 21?
     TV[164]:=Tv[676]*Tv[677]/100;

     //Tv[677] := Tv[675] * Tv[676] / 100;
     Tv[679] :=Tv[671]+Tv[675]+Tv[164];
     //Tv[674] + Tv[677]+Tv[164]; //20240317;
     if Tv[150]>0 then Tv[679]:=Tv[150];  //keep
    // if GetSinNo(retNo)='870002037' then Tv[679]:=Tv[150]; //StoreElm(RetNo,T2203FNo,679,FormatFloat('######.##',10867));  //20220415;
    // if GetSinNo(retNo)='870000338' then Tv[679]:=Tv[150]; //StoreElm(RetNo,T2203FNo,679,FormatFloat('######.##',10867));  //20220417;
   end;
  end;  //with
End;

// BC    //20180316
Procedure CopyBC428ToT2203(RetNo, FNo: Integer; Prv: String); // 20180314
Var
  S428FNo, T2203FNo: Integer;
  x: Real;
Begin
  //ShowMessage('t2203='+FormatFloat('########.##',Tv[245]));
  S428FNo := GetFormNo('BC428');
  T2203FNo := GetFormNo('T2203'); //20200404
  with ret[RetNo].Frm[FNo] do
  begin
     //20240507
    //if FetchElm(RetNo,'T2203',154)<>'1.00' then  //if '1' then allow override //'Y' then //no override
    //Begin
     Tv[602] := Vl(FetchElmFNo(RetNo, S428FNo, 23));
     Tv[603] := T2203BCAgeDed; //Vl(FetchElmFNo(RetNo, S428FNo, 24));
     Tv[604] := Vl(FetchElmFNo(RetNo, S428FNo, 28));
     // ??TV[86] :=??
     Tv[605] := T2203BCEligDepend; // 20180313
     //Tv[606] := T2203BCInfirmAmount; //20181110

     Tv[119] :=Vl(FetchElm(RetNo, 'BCMJWS',46));; //20240605 Vl(FetchElm(RetNo, 'S5PRV',109)); //bc caregiver multt juridsd chart in s5prv
     //if GetSinNo(RetNo)='870002037' then Tv[119]:=5701; //test case #8 //20240507
     //xx:=Tv[119];

     Tv[607] := Vl(FetchElmFNo(RetNo, S428FNo, 31));
     Tv[608] := Ret[RetNo].LNN[31000]; //Vl(FetchElmFNo(RetNo, S428FNo, 32));  //20240513
     Tv[609] := Vl(FetchElmFNo(RetNo, S428FNo, 33));
     Tv[100] := Vl(FetchElmFNo(RetNo, S428FNo, 82));
     If ret[RetNo].Province = 'BC' Then Tv[123] := Vl(FetchElmFNo(RetNo, S428FNo, 86));
     If ret[RetNo].Province = 'BC' Then Tv[124] := Vl(FetchElmFNo(RetNo, S428FNo, 87));
     If ret[RetNo].Province = 'BC' Then Tv[681] := Vl(FetchElmFNo(RetNo, S428FNo, 51));
     If ret[RetNo].Province = 'BC' Then Tv[610] := Vl(FetchElmFNo(RetNo, S428FNo, 34));
     Tv[612] := T2203BCDisab; // VL(FetchElmFNo(RetNo,S428FNo,36));
     Tv[613] := T2203BCDisabXfer;

     Tv[142]:=Vl(FetchElmFNo(RetNo, S428FNo, 59));   //20210415
     //20210410
     Tv[141]:=AddColumns(602, 605, 1)+Tv[119]+AddColumns(607, 609, 1)+ Tv[100]+Tv[123] + Tv[124] + Tv[681]+
               Tv[610]+AddColumns(612, 613, 1);
     Tv[228] := Tv[141];

     Tv[614] := Vl(FetchElmFNo(RetNo, S428FNo, 38));

     //20240504 Tv[615] := Vl(FetchElm(RetNo, 'S11MJBC',21));  //Vl(FetchElm(RetNo, 'S11',33));

     //if Ret[RetNo].Province='BC' then

     //If Ret[RetNo].Province='BC' then Tv[615]:=
       //Vl(FetchElmFNo(RetNo, GetFormNo('S11MJ' + UpperCase(Prv)), 21));
     Tv[616] := T2203BCTuitionXfer;        //20180402
     Tv[617] := T2203BCSpouseXfer; // Vl(FetchElm(RetNo,'S2MJBC',19));
     Tv[718] := Vl(FetchElm(RetNo,'T1',48)); //Vl(FetchElmFNo(RetNo, S428FNo, 44));
     Tv[618] := Vl(FetchElmFNo(RetNo, S428FNo, 45));
     Tv[619] := Vl(FetchElm(RetNo, 'S9', 13));
     Tv[120] := Vl(FetchElmFNo(RetNo, S428FNo, 154));  //Tv[245] ; //foodbank  //20190326

     Tv[620]:=Tv[141]+AddColumns(614, 617, 1)+Tv[718]+ Tv[618];
     Tv[621] := 5.06; // %
     Tv[622] := Tv[620] * Tv[621] / 100;
     //TV[142]:=???
     //Tv[120]=???
     Tv[627] := Tv[622] + Tv[142] + Tv[120];  //20210417
     if Tv[151]>0 then Tv[627]:=Tv[151];  //keep as override
     {
     Tv[623] := Vl(FetchElm(RetNo, 'S9', 15));
     Tv[624] := 16.80; //14.7; // %  //20190317
     Tv[625] := Tv[623] * Tv[624] / 100;
     Tv[120] := Vl(FetchElmFNo(RetNo, S428FNo, 154));  //20190328
     }
  end;
End;

// NS
Procedure CopyNS428ToT2203(RetNo, FNo: Integer; Prv: String); // 20180314
Var
  S428FNo, T2203FNo: Integer;
  x: Real; // T2203FNo: Integer;x:Real;//20180323
Begin
  S428FNo := GetFormNo('NS428');
  T2203FNo := GetFormNo('T2203');
  with ret[RetNo].Frm[FNo] do
  begin
    If vl(FetchElm(RetNo, 'T2203', 152)) <> 1 then //1= allow override
    Begin
      Tv[354] := Vl(FetchElmFNo(RetNo, S428FNo, 23));
      Tv[355] := T2203NSAgeDed;//Vl(FetchElmFNo(RetNo, S428FNo, 24));
      Tv[356] := Vl(FetchElm(RetNo, 'NS5812', 16)); //Vl(FetchElmFNo(RetNo, S428FNo, 28));  //20190321
      Tv[357] := Vl(FetchElmFNo(RetNo, S428FNo, 29)); //T2203NSEligDepend;    //20181202
      Tv[358] := T2203NSInfirmAmount;
      // If Ret[RetNo].Province='NS' then StoreElm(RetNo,T2203FNo,412,FetchElmFNo(RetNo,S428FNo,73)); //20180328
      If ret[RetNo].Province = 'NS' then
        Tv[414] := Vl(FetchElmFNo(RetNo, S428FNo, 74)); // 412?
      Tv[359] := Vl(FetchElmFNo(RetNo, S428FNo, 31));
      Tv[360] := Ret[RetNo].LNN[31000]; //20240513); Vl(FetchElmFNo(RetNo, S428FNo, 32));
      Tv[361] := Vl(FetchElmFNo(RetNo, S428FNo, 33));
      Tv[37] := Vl(FetchElmFNo(RetNo, S428FNo, 161));
      If ret[RetNo].Province = 'NS' then
        Tv[362] := Vl(FetchElmFNo(RetNo, S428FNo, 34));
      Tv[363] :=Vl(FetchElm(RetNo, 'NSMJWS',46)); //20240605 T2203NSCaregiver;
      Tv[364] := T2203NSDisab;
      // MaxR(VL(FetchElm(RetNo,'DISAB18',14)),VL(FetchElm(RetNo,'DISAB18',24))); //20180323 //VL(FetchElmFNo(RetNo,S428FNo,36));
      Tv[365] := T2203NSDisabXfer;

      Tv[127]:=AddColumns(354, 358, 1) + Tv[414] + AddColumns(359, 361, 1) + Tv[37]
             + AddColumns(362, 365, 1);
      Tv[222]:=Tv[127];

      Tv[366] := Vl(FetchElmFNo(RetNo, S428FNo, 38));
     // If Ret[RetNo].Province='NS' then  //20220514
      //20240504 Tv[367] := Vl(FetchElm(RetNo, 'S11',33)); //20230508
        // Vl(FetchElmFNo(RetNo, GetFormNo('S11MJ' + UpperCase(Prv)), 21)); //20190317 Tv[235]; //Vl(FetchElmFNo(RetNo, GetFormNo('S11MJ' + UpperCase(Prv)), 21));
      // VL(FetchElmFNo(RetNo,S428FNo,39)); //20180324
      Tv[368] := T2203NSTuitionXfer;
      Tv[369] := T2203NSSpouseXfer; // Vl(FetchElm(RetNo,'S2MJNS',19));

      Tv[408] := Vl(FetchElm(RetNo,'T1',48)); //Vl(FetchElmFNo(RetNo, S428FNo, 44));
      Tv[370] := Vl(FetchElmFNo(RetNo, S428FNo, 45));
      Tv[371] := Vl(FetchElm(RetNo, 'S9', 13));
    end;
    Tv[372] := Tv[127]+ AddColumns(366, 371, 1)+Tv[408];  //20210410

    Tv[373] := 8.79; // %
    Tv[374] := Tv[372] * Tv[373] / 100;

    Tv[375] := Vl(FetchElm(RetNo, 'S9', 15));
    Tv[376] := 21; // %
    Tv[377] := Tv[375] * Tv[376] / 100;
    Tv[378] := Tv[374];
    Tv[379] := Tv[377] + Tv[378];
    if Tv[157]>0 then Tv[379]:=Tv[157];  //keep
  end;
End;



// PE

Procedure CopyPE428ToT2203(RetNo, FNo: Integer; Prv: String); // 20180314
Var
  S428FNo, T2203FNo: Integer;
  x: Real; // , T2203FNo: Integer;x:Real;   //20180323
Begin
  S428FNo := GetFormNo('PE428');
  T2203FNo := GetFormNo('T2203');
  with ret[RetNo].Frm[FNo] do
  begin
    If Vl(FetchElm(RetNo, 'T2203', 384)) <> 1 then //1 allows overrides
    //If UpperCase(FetchElm(RetNo, 'T2203', 384)) <> 'Y' then // override
    Begin
      Tv[328] := Vl(FetchElmFNo(RetNo, S428FNo, 23));
      Tv[329] :=T2203PEAgeDed; //Vl(FetchElmFNo(RetNo, S428FNo, 24));
      Tv[330] := Vl(FetchElmFNo(RetNo, S428FNo, 28));

      Tv[331] := T2203PEEligDepend;
     // if Tv[331]>7780 then Tv[331]:=7780;  //20190328  //20210414

      Tv[332] := T2203PEInfirmAmount;
      // If Ret[RetNo].Province='PE' then StoreElm(RetNo,T2203FNo,412,FetchElmFNo(RetNo,S428FNo,67)); //20180328
      If ret[RetNo].Province = 'PE' then
        Tv[413] := Vl(FetchElmFNo(RetNo, S428FNo, 68)); // and 412???
      Tv[333] := Vl(FetchElmFNo(RetNo, S428FNo, 31));
      Tv[334] := Ret[RetNo].LNN[31000]; //20240513);Vl(FetchElmFNo(RetNo, S428FNo, 32));
      Tv[335] := Vl(FetchElmFNo(RetNo, S428FNo, 33));
      Tv[30] := Vl(FetchElmFNo(RetNo, S428FNo, 80));
      If ret[RetNo].Province = 'PE' then
        Tv[336] := Vl(FetchElmFNo(RetNo, S428FNo, 34));
      Tv[337] := Vl(FetchElm(RetNo, 'PEMJWS',46)); //20240605 T2203PECaregiver;
      Tv[338] := T2203PEDisab;
      Tv[339] := T2203PEDisabXfer;

      //If Ret[RetNo].Province<>'PE' then Tv[339]:=Ret[RetNo].Lnn[31800]; //20180406 ????
       // VL(FetchElmFNo(RetNo,S428FNo,37));
      If ret[RetNo].Province = 'PE' then Tv[422] := Vl(FetchElmFNo(RetNo, S428FNo, 75));
      //If ret[RetNo].Province = 'PE' then
      Tv[146]:=Vl(FetchElmFNo(RetNo, S428FNo, 43)); //20220413
      Tv[118]:=AddColumns(328, 332, 1) + Tv[413] + AddColumns(333, 335, 1) + Tv[30]
                +AddColumns(336, 339, 1) + Tv[422]
                +Tv[146]; //20220413
      Tv[221] := Tv[118];

      Tv[340] := Vl(FetchElmFNo(RetNo, S428FNo, 38));
      //If Ret[RetNo].Province='PE' then  //20220514
      //20240504 Tv[341] := Vl(FetchElm(RetNo, 'S11',33)); //20230508
        //Vl(FetchElmFNo(RetNo, GetFormNo('S11MJ' + UpperCase(Prv)), 21)); //20190317 //Tv[234]; //Vl(FetchElmFNo(RetNo, GetFormNo('S11MJ' + UpperCase(Prv)), 21)); //20180402 ALL PROV
      // 20180324//VL(FetchElmFNo(RetNo,S428FNo,39)); //20180324 //s1mj
      Tv[342] := T2203PETuitionXfer;

      Tv[343] := T2203PESpouseXfer;

      Tv[407] := Vl(FetchElm(RetNo,'T1',48)); //Vl(FetchElmFNo(RetNo, S428FNo, 44));

      Tv[344] := Vl(FetchElmFNo(RetNo, S428FNo, 45));
      Tv[345] := Vl(FetchElm(RetNo, 'S9', 13));
      Tv[346]:=Tv[118]+AddColumns(340,345,1) + Tv[146];  //20220404  146 wekllness
    End;

    Tv[346]:=Tv[118]+AddColumns(340, 343, 1) + Tv[407] + Tv[344] + Tv[345];
    Tv[347] := 9.5; //%  //jz//MJCERT2025v1 - update as per T2203 form from 9.65;  //jz//MJCERT2024//20250504
    Tv[348] := Tv[346] * Tv[347] / 100;

    Tv[349] := Vl(FetchElm(RetNo, 'S9', 15));
    Tv[350] := 19; //%   //jz//MJCERT2025v1 - update as per T2203 form from 18.75; // % //jz//MJCERT2024//20250504
    Tv[351] := Tv[349] * Tv[350] / 100;
    Tv[352] := Tv[348];
    Tv[353] := Tv[351] + Tv[352];
    if Tv[156]>0 then Tv[353]:=Tv[156];  //keep
  end;
End;

// NL
Procedure CopyNL428ToT2203(RetNo, FNo: Integer; Prv: String); // 20180314
Var
  S428FNo,T2203FNo: Integer;
  x: Real; // T2203FNo: Integer;x:Real; //20180323
Begin

  S428FNo := GetFormNo('NL428');
  T2203FNo:=GetFormNo('T2203');   //20200404
  with ret[RetNo].Frm[FNo] do
  begin
    Tv[302] := Vl(FetchElmFNo(RetNo, S428FNo, 23));
    Tv[303] := T2203NLAgeDed; //Vl(FetchElmFNo(RetNo, S428FNo, 24));
    Tv[304] := Vl(FetchElmFNo(RetNo, S428FNo, 28));
    Tv[305] := Vl(FetchElmFNo(RetNo, S428FNo, 29)); //20200405 T2203NLEligDepend; //if Tv[305]>7556 then Tv[305]:=7556; //20190328

    Tv[306] := T2203NLInfirmAmount;
    Tv[307] := Vl(FetchElmFNo(RetNo, S428FNo, 31));
    Tv[308] := Vl(FetchElmFNo(RetNo, S428FNo, 32));
    Tv[309] := Vl(FetchElmFNo(RetNo, S428FNo, 33));
    Tv[9] := Vl(FetchElmFNo(RetNo, S428FNo, 89));
    if Ret[RetNo].Province = 'NL' then Tv[16]:=Vl(FetchElmFNo(RetNo, S428FNo, 90)); //  else Tv[16]:=0; //20190326
    If ret[RetNo].Province = 'NL' then Tv[112]:=Vl(FetchElmFNo(RetNo, S428FNo, 48));  //accept even if not NL   //20200405
    If ret[RetNo].Province = 'NL' then Tv[23] := Vl(FetchElmFNo(RetNo, S428FNo, 91));
    If ret[RetNo].Province = 'NL' then Tv[410] := Vl(FetchElmFNo(RetNo, S428FNo, 51));

    Tv[310] := Vl(FetchElmFNo(RetNo, S428FNo, 34));
    Tv[311] := Vl(FetchElm(RetNo, 'NLMJWS',46)); //20240605 T2203NLCaregiver;
    Tv[312] := T2203NLDisab;
    // MaxR(VL(FetchElm(RetNo,'DISAB18',14)),VL(FetchElm(RetNo,'DISAB18',24))); //20180323 //VL(FetchElmFNo(RetNo,S428FNo,36));
    Tv[313] := T2203NLDisabXfer; // VL(FetchElmFNo(RetNo,S428FNo,37));

    //20210410
    Tv[113]:=AddColumns(302, 309, 1) + Tv[9] + Tv[16] +Tv[112] + Tv[23] + Tv[410] +
      AddColumns(310, 312, 1) + Tv[313];       //20200329 added Tv[112]
    Tv[220] := Tv[113];

    Tv[314] := Vl(FetchElmFNo(RetNo, S428FNo, 38));
    //20240504 Tv[315] := Vl(FetchElm(RetNo, 'S11',33)); //20230508
        // VL(FetchElmFNo(RetNo,S428FNo,39)); //20180324
    Tv[316] := T2203NLTuitionXfer;
    Tv[317] := T2203NLSpouseXfer;

    Tv[406] := Vl(FetchElm(RetNo,'T1',48)); //Vl(FetchElmFNo(RetNo, S428FNo, 44));
    Tv[318] := Vl(FetchElmFNo(RetNo, S428FNo, 45));
    Tv[319] := Vl(FetchElm(RetNo, 'S9', 13));

    {
   // summarize  Tv[220 to 231 keep track of subtotal for S11MJ
    //20210410
    Tv[220] := Tv[113]; // up to this point
    }
    Tv[320]:= Tv[113] + AddColumns(314, 317, 1) + Tv[406]+ AddColumns(318, 319, 1);

    Tv[321] := 8.7; // %
    Tv[322] := Tv[320] * Tv[321] / 100;

    Tv[323] := Vl(FetchElm(RetNo, 'S9', 15));
    Tv[324] := 21.8; //18.3; // %  //20240606
    Tv[325] := Tv[323] * Tv[324] / 100;
    Tv[326] := Tv[322];
    Tv[327] := Tv[325] + Tv[326];
    if Tv[148]>0 then Tv[327]:=Tv[148];
  end;
End;

// NB
Procedure CopyNB428ToT2203(RetNo, FNo: Integer; Prv: String); // 20180314
Var
  S428FNo, T2203FNo: Integer;
  x: Real;
Begin
  S428FNo := GetFormNo('NB428');
  T2203FNo := GetFormNo('T2203');  //2200404
  with ret[RetNo].Frm[FNo] do
  begin
    Tv[528] := Vl(FetchElmFNo(RetNo, S428FNo, 23));
    Tv[529] := T2203NBAgeDed; //Vl(FetchElmFNo(RetNo, S428FNo, 24));
    Tv[530] := Vl(FetchElmFNo(RetNo, S428FNo, 28));
    Tv[531] := T2203NBEligDepend;
    Tv[532] := T2203NBInfirmAmount;
    Tv[533] := Vl(FetchElmFNo(RetNo, S428FNo, 31));
    Tv[534] := Ret[RetNo].LNN[31000]; //20240513); Vl(FetchElmFNo(RetNo, S428FNo, 32));
    Tv[535] := Vl(FetchElmFNo(RetNo, S428FNo, 33));
    Tv[44] := Vl(FetchElmFNo(RetNo, S428FNo, 86));
    If ret[RetNo].Province = 'NB' then Tv[536] := Vl(FetchElmFNo(RetNo, S428FNo, 34));
    Tv[537] := Vl(FetchElm(RetNo, 'NBMJWS',46)); //20240605 //T2203NBCaregiver;
    Tv[538] := T2203NBDisab; // VL(FetchElmFNo(RetNo,S428FNo,36)); T2203XXDisab;
    Tv[539] := T2203NBDisabXfer;

    Tv[128]:= AddColumns(528, 535, 1) + Tv[44]
                +Tv[165]+Tv[166]        //20250425
                +AddColumns(536, 539, 1);  //20210410
    Tv[223]:=Tv[128];

    Tv[540] := Vl(FetchElmFNo(RetNo, S428FNo, 38));
    //20240504 Tv[541] :=Vl(FetchElm(RetNo, 'S11',33)); //20230508 //Vl(FetchElmFNo(RetNo, GetFormNo('S11MJ' + UpperCase(Prv)), 21)); //20200411 //not 21//20190317  0; //??? Tv[236]; //Vl(FetchElmFNo(RetNo, GetFormNo('S11MJ' + UpperCase(Prv)), 21)); //20190205
    Tv[581]:=Vl(FetchElmFNo(RetNo, S428FNo, 40)); //20200330
    Tv[543] := T2203NBSpouseXfer;//20200409 //Vl(FetchElm(RetNo,'S2PRV',19)); //TEM ????T2203NBSpouseXfer; // Vl(FetchElm(RetNo,'S2MJNB',19));
    Tv[594] := Vl(FetchElm(RetNo,'T1',48)); //Vl(FetchElmFNo(RetNo, S428FNo,153)); //20220421  //(FetchElmFNo(RetNo, S428FNo, 44));
    Tv[544] := Vl(FetchElmFNo(RetNo, S428FNo, 45));
    Tv[545] := Vl(FetchElm(RetNo, 'S9', 13));

    Tv[546]:=Tv[128]+ Tv[540] + Tv[541] + Tv[581]+Tv[543]+Tv[594]+Tv[544]+Tv[545]
                       ;
    Tv[547] := 9.40; //9.68; // %  //20220421
    Tv[548] := Tv[546] * Tv[547] / 100;

    Tv[549] := Vl(FetchElm(RetNo, 'S9', 15));
    Tv[550] := 17.95; // Tv[559]:=17.95; //%  20180327
    Tv[551] := Tv[549] * Tv[550] / 100;
    Tv[552] := Tv[548];
    Tv[553] := Tv[551] + Tv[552];
    if Tv[158]>0 then Tv[553]:=Tv[158];  //keep
   //keep if GetSinNo(RetNo)='870002003' then Tv[553]:=3329;   //20220415 #2 case
  end;
end;

// ON
Procedure CopyON428ToT2203(RetNo, FNo: Integer; Prv: String); // 20180314
Var
  S428FNo, T2203FNo: Integer;
  x: Real;
Begin
  S428FNo := GetFormNo('ON428');
  T2203FNo:= GetFormNo('T2203'); //GetFormNo('T2203FNo'); //20200404
  with ret[RetNo].Frm[FNo] do
  begin
    Tv[502] := Vl(FetchElmFNo(RetNo, S428FNo, 23));
    Tv[503] := T2203ONAgeDed; //Vl(FetchElmFNo(RetNo, S428FNo, 24));
    Tv[504] := Vl(FetchElmFNo(RetNo, S428FNo, 28));

    If Vl(GetMJAlloc(RetNo, 'ON')) > 0 then
      Tv[505] := T2203ONEligDepend
    else
      Tv[505] := 0;

    Tv[506] := Vl(FetchElmFNo(RetNo, S428FNo, 30)); //20200404 //MyStrToInt(FetchElm(RetNo,'S5',48)) * 4881; //S5 num claimed on line 307 for dep cearegiver //20190324
    //Tv[232]; Caragiver for each dependant //20190324

    Tv[507] := Vl(FetchElmFNo(RetNo, S428FNo, 31));
    Tv[508] := Ret[RetNo].LNN[31000]; //20240513); Vl(FetchElmFNo(RetNo, S428FNo, 32));
    Tv[509] := Vl(FetchElmFNo(RetNo, S428FNo, 33));
    Tv[51] := Vl(FetchElmFNo(RetNo, S428FNo, 116));
    If ret[RetNo].Province = 'ON' then
      Tv[592] := Vl(FetchElmFNo(RetNo, S428FNo, 51));
    If ret[RetNo].Province = 'ON' then
      Tv[510] := Vl(FetchElmFNo(RetNo, S428FNo, 34));
    Tv[512] := T2203ONDisab;
    Tv[513] := T2203ONDisabXfer;
    Tv[129]:=AddColumns(502, 509, 1) + Tv[51] + Tv[592] + Tv[510] + AddColumns(512, 513, 1); //20210410
    Tv[224] := Tv[129];   //20210410

    Tv[514] := Vl(FetchElmFNo(RetNo, S428FNo, 38));
    //Tv[515] := Vl(FetchElmFNo(RetNo, GetFormNo('S11MJ' + UpperCase(Prv)), 21)); //20190317   Tv[237];
    If ret[RetNo].Province = 'ON' then Tv[515]:=0;  //20181110
    Tv[516] := T2203ONTuitionXfer;
    If ret[RetNo].Province = 'ON' then Tv[516]:=0;  //20181110

    Tv[517] :=T2203ONSpouseXfer; // Vl(FetchElm(RetNo,'S2NJON',19)); //]
    Tv[595] := Vl(FetchElm(RetNo,'T1',48)); //Vl(FetchElmFNo(RetNo, S428FNo, 44));
    //If FetchElm(RetNo,'MEDPRV',1)='ON' then  //20220429  NO good all the time
    Tv[518] := Vl(FetchElmFNo(RetNo, S428FNo, 45));
    Tv[519] := Vl(FetchElm(RetNo, 'S9', 13));

    Tv[520]:=Tv[129]+AddColumns(514, 515, 1) +Tv[517]+ Tv[595] + Tv[518] + Tv[519]; //2019024

    Tv[521] := 5.05; // %
    Tv[522] := Tv[520] * Tv[521] / 100;

    Tv[523] := Vl(FetchElm(RetNo, 'S9', 15));
    Tv[524] := 11.16; // %
    Tv[525] := Tv[523] * Tv[524] / 100;
    Tv[526] := Tv[522];
    Tv[527] := Tv[525] + Tv[526];
    if Tv[159]>0 then Tv[527]:=Tv[159];  //keep

    Tv[591] := Vl(FetchElm(RetNo, 'ON428', 42)); // 2080325
  end;
End;

// MB
Procedure CopyMB428ToT2203(RetNo, FNo: Integer; Prv: String); // 20180314
Var
  S428FNo, T2203FNo: Integer;
  x: Real;
Begin
  S428FNo := GetFormNo('MB428');
  T2203FNo := GetFormNo('T2203');  //2200404
  with ret[RetNo].Frm[FNo] do
  begin
    Tv[554] := Vl(FetchElmFNo(RetNo, S428FNo, 23));
    Tv[555] := T2203MBAgeDed; //Vl(FetchElmFNo(RetNo, S428FNo, 24));
    Tv[556] := Vl(FetchElmFNo(RetNo, S428FNo, 28));
    If Vl(GetMJAlloc(RetNo, 'MB')) > 0 then
       Tv[557] :=T2203MBEligDepend; // Vl(FetchElmFno(RetNo,S428FNo,29)); //T2203MBEligDepend; //20180401
    Tv[558] := T2203MBInfirmAmount;
    If Vl(GetMJAlloc(RetNo, 'MB')) > 0 then
      Tv[559] := Vl(FetchElmFNo(RetNo, S428FNo, 31));
    Tv[560] := Ret[RetNo].LNN[31000]; //20240513);  Vl(FetchElmFNo(RetNo, S428FNo, 32));
    Tv[561] := Vl(FetchElmFNo(RetNo, S428FNo, 33));
    Tv[58] := Vl(FetchElmFNo(RetNo, S428FNo, 68));
    If ret[RetNo].Province = 'MB' then
      Tv[115] := Vl(FetchElmFNo(RetNo, S428FNo, 77));
    If ret[RetNo].Province = 'MB' then
      Tv[116] := Vl(FetchElmFNo(RetNo, S428FNo, 78));
    If ret[RetNo].Province = 'MB' then
      Tv[580] := Vl(FetchElmFNo(RetNo, S428FNo, 67));
    If ret[RetNo].Province = 'MB' then
      Tv[65] := Vl(FetchElmFNo(RetNo, S428FNo, 74));
    If ret[RetNo].Province = 'MB' then
      Tv[593] := Vl(FetchElmFNo(RetNo, S428FNo, 51));
    If ret[RetNo].Province = 'MB' then
      Tv[562] := Vl(FetchElmFNo(RetNo, S428FNo, 34));
    Tv[563] := Vl(FetchElm(RetNo, 'MBMJWS',46)); //20240605 //T2203MBCaregiver;
    Tv[564] := T2203MBDisab;
    Tv[565] := T2203MBDisabXfer;

    Tv[130]:=AddColumns(554, 561, 1) + Tv[58] + AddColumns(115, 116, 1) + Tv[580]+
           Tv[65] + Tv[593]+AddColumns(562,565,1);  //20210415
    Tv[225] :=Tv[130];  //for s11Mj

    Tv[566] := Vl(FetchElmFNo(RetNo, S428FNo, 38));
    //If Ret[RetNo].Province='MB' then  //20220514
    //20240504 Tv[567] :=Vl(FetchElm(RetNo, 'S11',33)); //20230508 //Vl(FetchElmFNo(RetNo, GetFormNo('S11MJ' + UpperCase(Prv)), 21)); //20190317  Tv[238]; //Vl(FetchElmFNo(RetNo, GetFormNo('S11MJ' + UpperCase(Prv)), 21));
    // VL(FetchElmFNo(RetNo,S428FNo,39)); //20180324
    Tv[568] := T2203MBTuitionXfer;
    Tv[569] := T2203MBSpouseXfer; // Vl(FetchElm(RetNo,'S2MJMB',19));
    Tv[597] := Vl(FetchElm(RetNo, 'MBMJA', 42)); // 20190207
    //Tv[597] := Vl(FetchElm(RetNo, 'MB428A', 42)); // 20180401
    Tv[596] := Vl(FetchElmFNo(RetNo, S428FNo, 44));
    Tv[570] := Vl(FetchElmFNo(RetNo, S428FNo, 45));
    Tv[571] := Vl(FetchElm(RetNo, 'S9', 13));

    Tv[572]:=Tv[130]+AddColumns(566, 569, 1) + Tv[597] + Tv[596] + Tv[570] + Tv[571];
    {
    // summarize
    x := 0;
    x := x + AddColumns(554, 561, 1) + Tv[58] + AddColumns(115, 116, 1) + Tv[580]
      + Tv[65] + Tv[593];
    x := x + AddColumns(562, 565, 1);
    Tv[225] := x;
    x := x + AddColumns(566, 569, 1) + Tv[597] + Tv[596] + Tv[570] + Tv[571];
    Tv[572] := x;
    }
    Tv[573] := 10.8; // %
    Tv[574] := Tv[572] * Tv[573] / 100;

    Tv[575] := Vl(FetchElm(RetNo, 'S9', 15));
    Tv[576] := 17.4; // %
    Tv[577] := Tv[575] * Tv[576] / 100;
    Tv[578] := Tv[574];
    Tv[579] := Tv[577] + Tv[578];
    if Tv[160]>0 then Tv[579]:=Tv[160];  //keep
  end;
End;

// -----------------------------------------------------
// YT
Procedure CopyYT428ToT2203(RetNo, FNo: Integer; Prv: String); // 20180314
Var
  S428FNo, T2203FNo: Integer;
  x: Real;
Begin
  S428FNo := GetFormNo('YT428');
  T2203FNo := GetFormNo('T2203');  //2200404
  with ret[RetNo].Frm[FNo] do
  begin
    Tv[886] := Vl(FetchElmFNo(RetNo, S428FNo, 23));
    Tv[887] := T2203YTAgeDed;//Vl(FetchElmFNo(RetNo, S428FNo, 24));
    Tv[888] := Vl(FetchElmFNo(RetNo, S428FNo, 28));
    Tv[125] := ret[RetNo].Lnn[30425];
    Tv[889] := Ret[Retno].Lnn[30400]; //T2203YTEligDepend; //20240519
    Tv[126] := Vl(FetchElmFNo(RetNo, S428FNo, 35));
    If (ret[RetNo].Province = 'YT') then
      Tv[807] := ret[RetNo].Lnn[30500]; // 20200230
    Tv[891] := Vl(FetchElmFNo(RetNo, S428FNo, 31));
    Tv[892] := Ret[RetNo].LNN[31000]; //20240513);Vl(FetchElmFNo(RetNo, S428FNo, 32));
    Tv[893] := Vl(FetchElmFNo(RetNo, S428FNo, 33));
    Tv[101] := Vl(FetchElmFNo(RetNo, S428FNo, 64));
    If (ret[RetNo].Province = 'YT') then
      Tv[803] := ret[RetNo].Lnn[31260]; // 20180328
   // If (ret[RetNo].Province = 'YT') then Tv[804] := ret[RetNo].Lnn[364]; //20181109
    If (ret[RetNo].Province = 'YT') then Tv[114] := Vl(FetchElmFNo(RetNo, S428FNo, 65));
    If (ret[RetNo].Province = 'YT') then
      Tv[805] := ret[RetNo].Lnn[31300]; // else Tv[805]:=0;
   // If (ret[RetNo].Province = 'YT') then Tv[127] := ret[RetNo].Lnn[31400];
    Tv[894] := Vl(FetchElmFNo(RetNo, S428FNo, 34));
    Tv[896] := Ret[RetNo].Lnn[31600]; //20240520 YT only //T2203YTDisab; // VL(FetchElmFNo(RetNo,S428FNo,36));
    Tv[897] := Ret[RetNo].Lnn[31800]; //20240519

    Tv[143]:=AddColumns(886, 888, 1) + Tv[125] + Tv[889] + Tv[126] + Tv[807] +
      AddColumns(891, 893, 1) + Tv[101] + Tv[803]
          +Tv[114] + Tv[805] + Tv[894] + AddColumns(896, 897, 1);
    Tv[229] := Tv[143];

    If Vl(GetMJAlloc(RetNo, 'YT')) > 0 then
      Tv[898] := ret[RetNo].Lnn[31900]; // else Tv[898]:=0;
    //If Ret[RetNo].Province='YT' then  //20220514
    //20240504 Tv[899] :=Vl(FetchElm(RetNo, 'S11',33)); //20230508
     // Vl(FetchElmFNo(RetNo, GetFormNo('S11MJ' + UpperCase(Prv)), 21)); //20190317  Tv[242]; //Vl(FetchElmFNo(RetNo, GetFormNo('S11MJ' + UpperCase(Prv)), 21));
    // VL(FetchElmFNo(RetNo,S428FNo,39)); //20180324
    Tv[900] := T2203YTTuitionXfer;
    Tv[901] := T2203YTSpouseXfer; //20240529 //20240520 //Vl(FetchElm(RetNo,'YT428',36));//20230410  //Vl(FetchElm(RetNo,'S2MJYT',19));
    Tv[883] := Vl(FetchElm(RetNo,'T1',48)); //Vl(FetchElmFNo(RetNo, S428FNo, 44));
    If Vl(GetMJAlloc(RetNo, 'YT')) > 0 then
      Tv[902] := ret[RetNo].Lnn[33199];
    Tv[903] := Vl(FetchElm(RetNo, 'S9', 13));

    Tv[904]:=Tv[143]+AddColumns(898, 903, 1)+Tv[883];  //20210410
    {
    // summarize
    x := 0;
    x := x + AddColumns(886, 888, 1) + Tv[125] + Tv[889] + Tv[126] + Tv[807] +
      AddColumns(891, 893, 1) + Tv[101] + Tv[803]; // + Tv[804];  //20181110
    x := x + Tv[114] + Tv[805] + Tv[894] + AddColumns(896, 897, 1);
    Tv[229] := x;
    x := x + AddColumns(898, 899, 1) + Tv[900] + Tv[901] + Tv[883] + Tv[902]
      + Tv[903];
    Tv[904] := x;
    }
    Tv[905] := 6.4; // %
    Tv[906] := Tv[904] * Tv[905] / 100;
    Tv[907] := Vl(FetchElm(RetNo, 'S9', 15));
    Tv[908] := 12.8; // %
    Tv[909] := Tv[907] * Tv[908] / 100;
    Tv[910] := Tv[906];
    Tv[911] := Tv[909] + Tv[910];
    if Tv[161]>0 then Tv[911]:=Tv[161];  //keep
   end;
End;

// NT
Procedure CopyNT428ToT2203(RetNo, FNo: Integer; Prv: String); // 20180314
Var
  S428FNo, T2203FNo: Integer;
  x: Real;
Begin
  S428FNo := GetFormNo('NT428');
  T2203FNo := GetFormNo('T2203');  //2200404

  //LoadTV(RetNo,'T2203',T2203FNo);  //20240505

  with ret[RetNo].Frm[FNo] do
  begin
    Tv[828] := Vl(FetchElmFNo(RetNo, S428FNo, 23));
    Tv[829] := T2203NTAgeDed; //Vl(FetchElmFNo(RetNo, t2203FNo, 261)); //ageded 20180406
    Tv[830] := Vl(FetchElmFNo(RetNo, S428FNo, 28));
    Tv[831] := T2203NTEligDepend;
    Tv[832] := T2203NTInfirmAmount;
    Tv[833] := Vl(FetchElmFNo(RetNo, S428FNo, 31));
    Tv[834] := Ret[RetNo].LNN[31000]; //20240513); Vl(FetchElmFNo(RetNo, S428FNo, 32));
    Tv[835] := Vl(FetchElmFNo(RetNo, S428FNo, 33));
    Tv[107] := Vl(FetchElmFNo(RetNo, S428FNo, 51));
    If ret[RetNo].Province = 'NT' Then
      Tv[128] := MinR(ret[RetNo].Lnn[31400], 1000);
    //Tv[836] := This is NU //Vl(FetchElmFNo(RetNo, S428FNo, 34)); //20180406
    Tv[837] := Vl(FetchElm(RetNo, 'NTMJWS',46)); //20240605 T2203NTCaregiver; //Vl(FetchElm(RetNo,'CAREPRV',T2203NTCaregiver;  //20200330
    Tv[838] := T2203NTDisab; // VL(FetchElmFNo(RetNo,S428FNo,36));
    Tv[839] := T2203NTDisabXfer;

    Tv[144]:=AddColumns(828, 835, 1) + Tv[107] +  AddColumns(836, 839, 1); //20210410
    Tv[230] := Tv[144]; // subtotal
    {
    x := x + AddColumns(840, 843, 1) + Tv[881];
    x := x + Tv[844] + Tv[845];
    Tv[846] := x;
    }
    Tv[840] := Vl(FetchElmFNo(RetNo, S428FNo, 38));
    //If Ret[RetNo].Province='NT' then  //20220514
    //20240504 Tv[841] :=Vl(FetchElm(RetNo, 'S11',33)); //20230508
      //Vl(FetchElmFNo(RetNo, GetFormNo('S11MJ' + UpperCase(Prv)), 21)); //20190317  Tv[243]; //Vl(FetchElmFNo(RetNo, GetFormNo('S11MJ' + UpperCase(Prv)), 21));
    Tv[842] := T2203NTTuitionXfer;
    Tv[843]:=T2203NTSpouseXfer; //20240529 //Tv[843] := Vl(FetchElm(RetNo,'S2MJ',19)); //20240520 //T2203NTSpouseXfer; // Vl(FetchElm(RetNo,'S2MJNT',19));
    Tv[881] := Vl(FetchElm(RetNo,'T1',48)); //Vl(FetchElmFNo(RetNo, S428FNo, 44));
    Tv[844] := Vl(FetchElmFNo(RetNo, S428FNo, 45));
    Tv[845] := Vl(FetchElm(RetNo, 'S9', 13));

    Tv[846]:=Tv[144]+AddColumns(840, 843, 1) + Tv[881]+ Tv[844] + Tv[845];

    Tv[847] := 5.9; //5.9; // %   //20190317
    Tv[848] := Tv[846] * Tv[847] / 100;
    Tv[849] := Vl(FetchElm(RetNo, 'S9', 15));
    Tv[850] := 14.05; // %   //20190317
    Tv[851] := Tv[849] * Tv[850] / 100;
    Tv[852] := Tv[848];
    Tv[853] := Tv[851] + Tv[852];
    if Tv[162]>0 then Tv[853]:=Tv[162];  //keep
    //ShowMessage(FormatFloat('#########.##',Tv[853]));      //20190317
  end;
  // SaveTv(RetNo,'T2203',T2203FNo);  //20240505
End;

// NU
Procedure CopyNU428ToT2203(RetNo, FNo: Integer; Prv: String); // 20180314
Var
  S428FNo, T2203FNo: Integer;
  x: Real;
Begin
  S428FNo := GetFormNo('NU428');
  T2203FNo := GetFormNo('T2203');  //2200404

  //LoadTV(RetNo,'T2203',T2203FNo);  //20240505

  with ret[RetNo].Frm[FNo] do
  begin
    Tv[854] := Vl(FetchElmFNo(RetNo, S428FNo, 23));
    Tv[855] := T2203NUAgeDed;//Vl(FetchElmFNo(RetNo, S428FNo, 24));
    Tv[856] := Vl(FetchElmFNo(RetNo, S428FNo, 28));
    Tv[857] := T2203NUEligDepend;
    Tv[858] := T2203NUInfirmAmount; // VL(FetchElmFNo(RetNo,S428FNo,30));
    // If Ret[RetNo].Province='NU' then StoreElm(RetNo,T2203FNo,806,FetchElmFNo(RetNo,S428FNo,75)); //20180328
    If ret[RetNo].Province = 'NU' Then
      Tv[802] := Vl(FetchElmFNo(RetNo, S428FNo, 73));
    Tv[859] := Vl(FetchElmFNo(RetNo, S428FNo, 31));
    Tv[860] := Ret[RetNo].LNN[31000]; //20240513); Vl(FetchElmFNo(RetNo, S428FNo, 32));
    Tv[861] := Vl(FetchElmFNo(RetNo, S428FNo, 33));
    Tv[109] := Vl(FetchElmFNo(RetNo, S428FNo, 79));
    If ret[RetNo].Province = 'NU' Then Tv[862] := Ret[RetNo].Lnn[31400]; //Vl(FetchElmFNo(RetNo, S428FNo, 34)); //20180406
    Tv[863] := Vl(FetchElm(RetNo, 'NUMJWS',46)); //20240605T2203NUCaregiver;
    Tv[864] := T2203NUDisab; // VL(FetchElmFNo(RetNo,S428FNo,36));
    Tv[865] := T2203NUDisabXfer;

    Tv[145]:=AddColumns(854, 858, 1) + Tv[802] + AddColumns(859, 861, 1)
      + Tv[109]+ AddColumns(862, 865, 1);
    Tv[231] := Tv[145];
    //x := x + AddColumns(866, 869, 1) + Tv[882] + Tv[870] + Tv[871];

    Tv[866] := Vl(FetchElmFNo(RetNo, S428FNo, 38));
    //If Ret[RetNo].Province='NU' then  //20220514
    //20240504 Tv[867] :=Vl(FetchElm(RetNo, 'S11',33)); //20230508 // Vl(FetchElmFNo(RetNo, GetFormNo('S11MJ' + UpperCase(Prv)), 21)); //20190317 Tv[244]; //Vl(FetchElmFNo(RetNo, GetFormNo('S11MJ' + UpperCase(Prv)), 21));
    Tv[869] := T2203NUSpouseXfer; //20240529 // Vl(FetchElm(RetNo,'S2MJNU',19));
    Tv[882] := Vl(FetchElm(RetNo,'T1',48)); //Vl(FetchElmFNo(RetNo, S428FNo, 44));
    Tv[870] := Vl(FetchElmFNo(RetNo, S428FNo, 45));
    Tv[871] := Vl(FetchElm(RetNo, 'S9', 13));

    Tv[872]:=Tv[145]+AddColumns(866, 869, 1) + Tv[882] + Tv[870] + Tv[871];
    Tv[873] := 4.0; // %
    Tv[874] := Tv[872] * Tv[873] / 100;
    Tv[875] := Vl(FetchElm(RetNo, 'S9', 15));
    Tv[876] := 11.5; // %
    Tv[877] := Tv[875] * Tv[876] / 100;
    Tv[878] := Tv[874];
    Tv[879] := Tv[877] + Tv[878];
    if Tv[163]>0 then Tv[879]:=Tv[163];  //keep
  end;
  //SaveTv(RetNo,'T2203',T2203FNo);  //20240505
End;



Function GetMjSpouseTransfer(RetNo: Integer; Prv: String): Real;
Var
  i: Integer;
  FName: String;
  FInst: String;
  FNo: Integer;
begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'S2MJ' then
    begin
      If LeftStr(FetchElmFNo(RetNo, FRec.FormNo, 15), 2) = Prv then
      begin { right Prv }
        Result := Vl(FetchElmFNo(RetNo, FRec.FormNo, 19));
        exit;
      end;
    end;
  end; { i }
end;

//20251125 Igor >>>
procedure S2MJNL(RetNo: Integer; FName: string; FNo: Integer; Prv: string);
var
  i, S2FNo, S2PrvFNo, SpRetNo: Integer;
  SpTaxFormName: string;
begin
  SpTaxFormName:= GetSpTaxFormName(RetNo);
  InitPrvConstants('NL');
  SpRetNo:= GetSpRetNo(RetNo);
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    if CouplingSw then
    begin
      SpRetNo:= GetSpRetNo(RetNo);

      if (SpRetNo > 0) then Tv[3]:= GetspouseAgeDeductionForMJ(SpRetNo, RetNo, FNo, 'NL');

      Tv[4]:= MinR(1000, Vl(FetchElm(SpRetNo, SpTaxFormName, 31))); //20251202 Igor
      Tv[5]:= GetMaxDisabForS2MJ(SpRetNo, Prv);

      if UpperCase(FetchElm(SpRetNo, 'S11PRV', 25)).Equals('Y') then Tv[6]:= Vl(FetchElm(SpRetNo, 'S11PRV', 10)); // tuition
    end;

    Tv[7]:= Tv[3] + Tv[4] + Tv[5] + Tv[6];

    if CouplingSw then
    begin
      if (Ret[SpRetNo].Lnn[26000] <= 44192) then //20251202 Igor
        Tv[24]:= Ret[SpRetNo].Lnn[26000]
      else
        Tv[24]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 101)) / 0.087; //20251202 Igor
    end else
      Tv[24]:= MaxR(0, Tv[22] - Tv[23]);

    Tv[8] := Tv[24];

    if CouplingSw then
    begin
      Tv[51]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 112));
      Tv[9]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 23)); //pers  5804
      Tv[14]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 39));
    end;

    Tv[12]:= Tv[9] + Tv[51] + Tv[14];
    Tv[16]:= Tv[12];
    Tv[17]:= MaxR(0, Tv[8] - Tv[16]);
    Tv[18]:= Tv[17];
    Tv[19]:= MaxR(0, (Tv[7] - Tv[18]));

    if IsPreBankruptcyReturn(RetNo) then Tv[19]:= Tv[19] * Vl(FetchElm(RetNo, 'BANKRPT', 2)) / 366;
    if (Ret[RetNo].MarStatus >= 3) then
    begin
      for i:= 1 to 13 do
      begin
        Frm[FNo].Strings[i]:= '';
        Tv[i]:= 0;
      end;

      Tv[14]:= 0;
      for i:= 16 to 21 do
      begin
        Frm[FNo].Strings[i]:= '';
        Tv[i]:= 0;
      end;
    end;
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20251125 Igor <<<

Procedure S2MJPE(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
// 20180331
Var
 i, S2FNo, SpRetNo: Integer;
 SpTaxFormName: String;
Begin
 SpTaxFormName :=GetSpTaxFormName(RetNo); //20200412 'PE428'; //UpperCase(Prv)+'428'; //PrvGetSpTaxFormName(RetNo);  //20200410
 InitPrvConstants('PE');  //20200412 InitPrvConstants('PE'); // ret[RetNo].Province);
 LoadTv(RetNo, FName, FNo);

 With ret[RetNo], ret[RetNo].Frm[FNo] do
 begin
  If CouplingSw = True then //20190323
  begin
       SpRetNo := GetSpRetNo(RetNo);
       if SpRetNo>0 then Tv[3]:=GetspouseAgeDeductionForMJ(SpRetNo, RetNo, FNo, 'PE'); //20220516
        //20200410
       Tv[4] := Vl(FetchElm(SpRetNo, SpTaxFormName, 34));    //5836 pension
       Tv[5]:=GetMaxDisabForS2MJ(SpRetNo,Prv); //20200410  //GetMaxDisabForS2MJ(RetNo,Prv); //Vl(FetchElm(SpRetNo, SpTaxFormName, 36));   //disabil 5844  //20200410
       If UpperCase(FetchElm(SpRetNo, 'S11PRV', 25)) = 'Y' then
         Tv[6] := Vl(FetchElm(SpRetNo, 'S11PRV', 10));        // tuition
  end;

  Tv[7] := Tv[3] + Tv[4] + Tv[5] + Tv[6];
  If CouplingSw = True then
  begin
   If Ret[SpRetNo].Lnn[26000]<=31984 then
    Tv[24]:=Ret[SpRetNo].Lnn[26000]
  Else
    Tv[24]:=Vl(FetchElm(SpRetNo,SpTaxFormName,101))/(9.8/100);
  end
  Else
    Tv[24] := MaxR(0, Tv[22] - Tv[23]);

  Tv[8] := Tv[24];
  If CouplingSw = True then
   begin
    //20210412
    Tv[51]  :=Vl(FetchElm(SpRetNo, SpTaxFormName, 95));
    Tv[9]  := Vl(FetchElm(SpRetNo, SpTaxFormName, 23));  //pers  5804
    Tv[14]  :=Vl(FetchElm(SpRetNo, SpTaxFormName, 39));
  end; // coupling
  Tv[12]:=Tv[9]+Tv[51]+Tv[14];

  Tv[16] :=Tv[12];
  Tv[17] := MaxR(0, Tv[8] - Tv[16]);
  Tv[18] := Tv[17];
  Tv[19] := MaxR(0, (Tv[7] - Tv[18]));

  If IsPreBankruptcyReturn(RetNo) then
    Tv[19] := Tv[19] * Vl(FetchElm(RetNo, 'BANKRPT', 2)) / 366; // 20161227
  If (ret[RetNo].MarStatus < 3) then
   // ok
  Else
  begin
   For i := 1 to 13 do
   begin
     Frm[FNo].Strings[i] := '';
     Tv[i] := 0;
   end;

   Tv[14] := 0;
   For i := 16 to 21 do
   begin
    Frm[FNo].Strings[i] := '';
    Tv[i] := 0;
   end;
  end;
 End; //with ret
 SaveTv(RetNo, FName, FNo);
End;

//20251125 Igor >>>
procedure S2MJNB(RetNo: Integer; FName: string; FNo: Integer; Prv: string);
var
  i, S2FNo, SpRetNo: Integer;
  SpTaxFormName: string;
begin
  SpTaxFormName:= GetSpTaxFormName(RetNo);
  InitPrvConstants('NB');
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    if CouplingSw then
    begin
      SpRetNo:= GetSpRetNo(RetNo);

      if (SpRetNo > 0) then Tv[3]:= GetspouseAgeDeductionForMJ(SpRetNo, RetNo, FNo, 'NB');

      Tv[4]:= MinR(1000, Vl(FetchElm(SpRetNo, SpTaxFormName, 34))); //pension 5836 //20251201 Igor
      Tv[5]:= GetMaxDisabForS2MJ(spRetNo,Prv); //disabil 5844

      if UpperCase(FetchElm(SpRetNo, 'S11PRV', 25)).Equals('Y') then Tv[6]:= Vl(FetchElm(SpRetNo, 'S11PRV', 10));
    end;

    Tv[7]:= Tv[3] + Tv[4] + Tv[5] + Tv[6];

    if CouplingSw then
    begin
      if (Ret[SpRetNo].Lnn[26000] <= 51306) then //20251201 Igor
        Tv[24]:= Ret[SpRetNo].Lnn[26000]
      else
        Tv[24]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 101)) / 0.094; //20251201 Igor
    end;

    Tv[8]:= Tv[24];

    if CouplingSw then
    begin
      Tv[51]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 98));
      Tv[9]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 23));  //pers  5804
      Tv[14]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 39));
    end;

    Tv[12]:= Tv[9] + Tv[51] + Tv[14];
    Tv[16]:= Tv[12];
    Tv[17]:= MaxR(0, Tv[8] - Tv[16]);
    Tv[18]:= Tv[17];
    Tv[19]:= MaxR(0, (Tv[7] - Tv[18]));

    if IsPreBankruptcyReturn(RetNo) then Tv[19]:= Tv[19] * Vl(FetchElm(RetNo, 'BANKRPT', 2)) / 366;
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure S2MJYT(RetNo: Integer; FName: string; FNo: Integer; Prv: string);
var
  i, S2FNo, SpRetNo: Integer;
  S2PrvFNo: Integer;
  SpTaxFormName: string;
begin
  SpTaxFormName:= GetSpTaxFormName(RetNo);
  S2PrvFNo:= GetFormNo('S2Prv');
  InitPrvConstants('YT');
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    for i:= 3 to 19 do
    begin
      Strings[i]:= FetchElmFNo(RetNo, S2PRVFNo, i);
      Tv[i]:= Vl(FetchElmFNo(RetNo, S2PrvFNo, i));
    end;

    if CouplingSw then
    begin
      SpRetNo:= GetSpRetNo(RetNo);

      if (SpRetNo > 0) then Tv[3]:= GetspouseAgeDeductionForMJ(SpRetNo, RetNo, FNo, 'YT');
      if Ret[RetNo].Province.Equals('YT') then Tv[34]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 25)) else Tv[34]:= 0; //5825

      Tv[4]:= MinR(2000, Vl(FetchElm(SpRetNo, SpTaxFormName, 34))); //pens 5836 //20251202 Igor
      Tv[5]:= GetMaxDisabForS2MJ(spRetNo, Prv);

      if UpperCase(FetchElm(SpRetNo, 'S11PRV', 25)).Equals('Y') then Tv[6]:= Vl(FetchElm(SpRetNo, 'S11PRV', 10));
    end;

    Tv[7]:= Tv[3] + Tv[34] + Tv[4] + Tv[5] + Tv[6];

    if CouplingSw then
    begin
      if (Ret[SpRetNo].Lnn[26000] <= 57375) then //20251202 Igor
        Tv[24]:= Ret[SpRetNo].Lnn[26000]
      else
        Tv[24]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 134)) / 0.064; //20251202 Igor
    end;

    Tv[8]:= Tv[24];

    if CouplingSw then
    begin
      Tv[51]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 63));
      Tv[9]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 23)); //pers 5804
      Tv[14]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 39));
    end;

    Tv[12]:= Tv[9] + Tv[51] + Tv[14];
    Tv[16]:=Tv[12];
    Tv[17]:= MaxR(0, Tv[8] - Tv[16]);
    Tv[18]:= Tv[17];
    Tv[19]:= MaxR(0, (Tv[7] - Tv[18]));

    if IsPreBankruptcyReturn(RetNo) then Tv[19]:= Tv[19] * Vl(FetchElm(RetNo, 'BANKRPT', 2)) / 366;

    if (Ret[RetNo].MarStatus >= 3) then //20251202 Igor
    begin
      for i:= 1 to 13 do
      begin
        Frm[FNo].Strings[i]:= '';
        Tv[i]:= 0;
      end;

      Tv[14]:= 0;
      for i:= 16 to 21 do
      begin
        Frm[FNo].Strings[i]:= '';
        Tv[i]:= 0;
      end;
    end;
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure S2MJBC(RetNo: Integer; FName: string; FNo: Integer; Prv: string);
var
 i, S2FNo, SpRetNo: Integer;
 SpTaxFormName: string;
begin
  SpTaxFormName:= GetSpTaxFormName(RetNo);
  InitPrvConstants('BC');
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    if CouplingSw then
    begin
      SpRetNo:= GetSpRetNo(RetNo);

      if (SpRetNo > 0) then Tv[3]:= GetspouseAgeDeductionForMJ(SpRetNo, RetNo, FNo, 'BC');

      Tv[4]:= MinR(1000, Vl(FetchElm(SpRetNo, SpTaxFormName, 34))); //5836 pension //20251201 Igor
      Tv[5]:= GetMaxDisabForS2MJ(spRetNo, Prv);

      if UpperCase(FetchElm(SpRetNo, 'S11PRV', 25)).Equals('Y') then

      Tv[6]:= Vl(FetchElm(SpRetNo, 'S11PRV', 10)); // tuition
    end;

    Tv[7]:= Tv[3] + Tv[4] + Tv[5] + Tv[6];

    if CouplingSw then
    begin
      if (Ret[SpRetNo].Lnn[26000] <= 49279) then //20251201 Igor
        Tv[24]:= Ret[SpRetNo].Lnn[26000]
      else
        Tv[24]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 132)) / 0.0506; //20251201 Igor
    end;

    Tv[8]:= Tv[24];

    if CouplingSw then
    begin
      Tv[51]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 53));
      Tv[9]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 23)); // pers  5804
      Tv[14]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 39));
    end;

    Tv[12]:= Tv[9] + Tv[51] + Tv[14];
    Tv[16]:= Tv[12];
    Tv[17]:= MaxR(0, Tv[8] - Tv[16]);
    Tv[18]:= Tv[17];
    Tv[19]:= MaxR(0, (Tv[7] - Tv[18]));

    if IsPreBankruptcyReturn(RetNo) then Tv[19]:= Tv[19] * Vl(FetchElm(RetNo, 'BANKRPT', 2)) / 366;
    if (Ret[RetNo].MarStatus >= 3) then
    begin
      for i:= 1 to 13 do
      begin
        Frm[FNo].Strings[i]:= '';
        Tv[i]:= 0;
      end;

      Tv[14]:= 0;
      for i:= 16 to 21 do
      begin
        Frm[FNo].Strings[i]:= '';
        Tv[i]:= 0;
      end;
    end;
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure S2MJNU(RetNo: Integer; FName: string; FNo: Integer; Prv: string);
var
  i, S2FNo, SpRetNo: Integer;
  SpTaxFormName: string;
begin
  SpTaxFormName:= GetSpTaxFormName(RetNo);
  InitPrvConstants('NU');
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    if CouplingSw then
    begin
      SpRetNo:= GetSpRetNo(RetNo);

      if (SpRetNo > 0) then Tv[3]:= GetspouseAgeDeductionForMJ(SpRetNo, RetNo, FNo, 'NU'); //20220516

      Tv[4]:= MinR(2000, Vl(FetchElm(SpRetNo, SpTaxFormName, 34))); //5836 pension //20251202 Igor
      Tv[5]:= GetMaxDisabForS2MJ(spRetNo, Prv); //disabil 5844

      if UpperCase(FetchElm(SpRetNo, 'S11PRV', 25)).Equals('Y') then Tv[6]:= Vl(FetchElm(SpRetNo, 'S11PRV', 10)); // tuition
    end;

    Tv[7]:= Tv[3] + Tv[4] + Tv[5] + Tv[6];

    if CouplingSw then
    begin
      if (Ret[SpRetNo].Lnn[26000] <= 54707) then //20251202 Igor
        Tv[24]:= Ret[SpRetNo].Lnn[26000]
      else
        Tv[24]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 101)) / 0.04; //20251202 Igor
    end;

    Tv[8]:= Tv[24];

    if CouplingSw then
    begin
      Tv[51]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 85));
      Tv[9]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 23)); //pers 5804
      Tv[14]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 39));
    end;

    Tv[12]:= Tv[9] + Tv[51] + Tv[14];
    Tv[16]:= Tv[12];
    Tv[17]:= MaxR(0, Tv[8] - Tv[16]);
    Tv[18]:= Tv[17];
    Tv[19]:= MaxR(0, (Tv[7] - Tv[18]));

    if IsPreBankruptcyReturn(RetNo) then Tv[19]:= Tv[19] * Vl(FetchElm(RetNo, 'BANKRPT', 2)) / 366;
    if (ret[RetNo].MarStatus >= 3) then
    begin
      for i:= 1 to 13 do
      begin
        Frm[FNo].Strings[i]:= '';
        Tv[i]:= 0;
      end;

      Tv[14]:= 0;
      for i:= 16 to 21 do
      begin
        Frm[FNo].Strings[i]:= '';
        Tv[i]:= 0;
      end;
    end;
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure S2MJON(RetNo: Integer; FName: string; FNo: Integer; Prv: string);
var
  i, S2FNo, SpRetNo: Integer;
  SpTaxFormName: string;
begin
  SpTaxFormName:= GetSpTaxFormName(RetNo);
  InitPrvConstants('ON');
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    if CouplingSw then
    begin
      SpRetNo:= GetSpRetNo(RetNo);

      if (SpRetNo > 0) then Tv[3]:= GetspouseAgeDeductionForMJ(SpRetNo, RetNo, FNo, 'ON');

      Tv[4]:= MinR(1762, Vl(FetchElm(SpRetNo, SpTaxFormName, 34))); //5836 pension //20251202 Igor
      Tv[5]:= GetMaxDisabForS2MJ(spRetNo, Prv); //disabil 5844
      Tv[6]:= 0;
    end;

    Tv[7]:= Tv[3] + Tv[4] + Tv[5];

    if CouplingSw then
    begin
      if (Ret[SpRetNo].Lnn[26000] <= 52886) then //20251202 Igor
        Tv[24]:= Ret[SpRetNo].Lnn[26000]
      else
        Tv[24]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 101)) / 0.0505; //20251202 Igor
    end;

    Tv[8]:= Tv[24];

    if CouplingSw then
    begin
      Tv[51]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 137));
      Tv[9]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 23)); //pers 5804
      Tv[14]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 39));
    end;

    Tv[12]:= Tv[9] + Tv[51] + Tv[14];
    Tv[16]:= Tv[12];
    Tv[17]:= MaxR(0, Tv[8] - Tv[16]);
    Tv[18]:= Tv[17];
    Tv[19]:= MaxR(0, (Tv[7] - Tv[18]));

    if IsPreBankruptcyReturn(RetNo) then Tv[19]:= Tv[19] * Vl(FetchElm(RetNo, 'BANKRPT', 2)) / 366;
    if (Ret[RetNo].MarStatus >= 3) then
    begin
      for i:= 1 to 13 do
      begin
        Frm[FNo].Strings[i]:= '';
        Tv[i]:= 0;
      end;

      Tv[14]:= 0;
      for i:= 16 to 21 do
      begin
        Frm[FNo].Strings[i]:= '';
        Tv[i]:= 0;
      end;
    end;
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure S2MJAB(RetNo: Integer; FName: string; FNo: Integer; Prv: string);
var
 i, S2FNo, SpRetNo: Integer;
 SpTaxFormName: string;
begin
  SpTaxFormName:= GetSpTaxFormName(RetNo);
  InitPrvConstants('AB');
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    if CouplingSw then
    begin
      SpRetNo:= GetSpRetNo(RetNo);

      if (SpRetNo > 0) then Tv[3]:= GetspouseAgeDeductionForMJ(SpRetNo, RetNo, FNo, 'AB');

      Tv[4]:= MinR(1719, Vl(FetchElm(SpRetNo, SpTaxFormName, 34))); //5836 pension //20251201 Igor
      Tv[5]:= GetMaxDisabForS2MJ(spRetNo, Prv);

      if UpperCase(FetchElm(SpRetNo, 'S11PRV', 25)).Equals('Y') then

      Tv[6]:= Vl(FetchElm(SpRetNo, 'S11PRV', 10)); // tuition
    end;

    Tv[7]:= Tv[3] + Tv[4] + Tv[5];

    if CouplingSw then
    begin
      if (Ret[SpRetNo].Lnn[26000] <= 60000) then //20251201 Igor
        Tv[24]:= Ret[SpRetNo].Lnn[26000]
      else
        Tv[24]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 19)) / 0.08; //20251201 Igor
    end;

    Tv[8]:= Tv[24];

    if CouplingSw then
    begin
      Tv[51]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 57));
      Tv[9]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 23)); //pers 5804
      Tv[14]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 39));
    end;

    Tv[12]:= Tv[9] + Tv[51] + Tv[14];
    Tv[16]:= Tv[12];
    Tv[17]:= MaxR(0, Tv[8] - Tv[16]);
    Tv[18]:= Tv[17];
    Tv[19]:= MaxR(0, (Tv[7] - Tv[18]));

    if IsPreBankruptcyReturn(RetNo) then Tv[19]:= Tv[19] * Vl(FetchElm(RetNo, 'BANKRPT', 2)) / 366;

    if (Ret[RetNo].MarStatus >= 3) then
    begin
      for i:= 1 to 13 do
      begin
        Frm[FNo].Strings[i]:= '';
        Tv[i]:= 0;
      end;

      Tv[14]:= 0;
      for i:= 16 to 21 do
      begin
        Frm[FNo].Strings[i]:= '';
        Tv[i]:= 0;
      end;
    end;
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure S2MJMB(RetNo: Integer; FName: string; FNo: Integer; Prv: string);
var
 i, S2FNo, SpRetNo: Integer;
 SpTaxFormName: string;
begin
  SpTaxFormName:= GetSpTaxFormName(RetNo);
  InitPrvConstants('MB');
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    if CouplingSw then
    begin
      SpRetNo:= GetSpRetNo(RetNo);

      if (SpRetNo > 0) then Tv[3]:= GetspouseAgeDeductionForMJ(SpRetNo, RetNo, FNo, 'MB');

      Tv[4]:= MinR(1000, Vl(FetchElm(SpRetNo, SpTaxFormName, 34))); //5836 pension //20251201 Igor
      Tv[5]:= GetMaxDisabForS2MJ(spRetNo, Prv);

      if UpperCase(FetchElm(SpRetNo, 'S11PRV', 25)).Equals('Y') then Tv[6]:= Vl(FetchElm(SpRetNo, 'S11PRV', 10)); // tuition
    end;

    Tv[7]:= Tv[3] + Tv[4] + Tv[5] + Tv[6];

    if CouplingSw then
    begin
      if (Ret[SpRetNo].Lnn[26000] <= 47000) then //20251201 Igor
        Tv[24]:= Ret[SpRetNo].Lnn[26000]
      else
        Tv[24]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 101)) / 0.108; //20251201 Igor
    end;

    Tv[8]:= Tv[24];

    if CouplingSw then
    begin
      Tv[51]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 82));
      Tv[9]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 23));  //pers  5804
      Tv[14]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 39));
    end;

    Tv[12]:= Tv[9] + Tv[51] + Tv[14];
    Tv[16]:= Tv[12];
    Tv[17]:= MaxR(0, Tv[8] - Tv[16]);
    Tv[18]:= Tv[17];
    Tv[19]:= MaxR(0, (Tv[7] - Tv[18]));

    if IsPreBankruptcyReturn(RetNo) then Tv[19] := Tv[19] * Vl(FetchElm(RetNo, 'BANKRPT', 2)) / 366;
    if (Ret[RetNo].MarStatus >= 3) then
    begin
      for i:= 1 to 13 do
      begin
        Frm[FNo].Strings[i]:= '';
        Tv[i]:= 0;
      end;

      Tv[14]:= 0;
      for i:= 16 to 21 do
      begin
        Frm[FNo].Strings[i]:= '';
        Tv[i]:= 0;
      end;
    end;
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20251125 Igor <<<

Procedure S2MJSK(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
// 20180322
Var
 i, S2FNo, SpRetNo: Integer;
 SpTaxFormName: String;
Begin
 SpTaxFormName := GetSpTaxFormName(RetNo);

 InitPrvConstants('SK'); // ret[RetNo].Province);
 LoadTv(RetNo, FName, FNo);

 With ret[RetNo], ret[RetNo].Frm[FNo] do
 begin
  If CouplingSw = True then
  begin
       SpRetNo := GetSpRetNo(RetNo);
       Tv[25]:=Vl(FetchElm(spRetNo,'SK428',66));  //20200412 //Vl(FetchElm(spRetNo,SpTaxFormName,66));  //20200412
       if SpRetNo>0 then Tv[3]:=GetspouseAgeDeductionForMJ(SpRetNo, RetNo, FNo, 'SK'); //20220516
       //20200412
       if GetSpouseAge(RetNo) >=65 then Tv[26]:=1305 else Tv[26]:=0;  // //20220517 seniors supplement
        //Tv[26] :=Vl(FetchElm(SpRetNo, 'SK428', 67));  //Vl(FetchElm(SpRetNo, SpTaxFormName, 67)); //20220517

       Tv[4] := Vl(FetchElm(SpRetNo, 'SK428', 34));
       Tv[5] := GetMaxDisabForS2MJ(spRetNo,Prv); //20200410  //Vl(FetchElm(SpRetNo, SpTaxFormName, 36));
       If UpperCase(FetchElm(SpRetNo, 'S11PRV', 25)) = 'Y' then
         Tv[6] := Vl(FetchElm(SpRetNo, 'S11PRV', 10));
  end;

  Tv[7] :=Tv[25]+Tv[3] +Tv[26] + Tv[4] + Tv[5];  //20200412 [25]
  If CouplingSw = True then
  begin
   If Ret[SpRetNo].Lnn[26000]<=49720 then
    Tv[24]:=Ret[SpRetNo].Lnn[26000]
  Else
    Tv[24]:=Vl(FetchElm(SpRetNo,SpTaxFormName,101))/(10.5/100);  //2019031
  end; //  Else ; //Tv[24] := MaxR(0, Tv[22] - Tv[23]);  /???

  Tv[8] := Tv[24];

  If CouplingSw = True then
   begin
      //20210412
    Tv[51]  :=Vl(FetchElm(SpRetNo, SpTaxFormName, 90));
    Tv[9]  := Vl(FetchElm(SpRetNo, SpTaxFormName, 23));  //pers  5804
    Tv[14]  :=Vl(FetchElm(SpRetNo, SpTaxFormName, 39));
  end; // coupling
  Tv[12]:=Tv[9]+Tv[51]+Tv[14];

  Tv[16] :=Tv[12];

  Tv[17] := MaxR(0, Tv[8] - Tv[16]);
  Tv[18] := Tv[17];
  Tv[19] := MaxR(0, (Tv[7] - Tv[18]));

  If IsPreBankruptcyReturn(RetNo) then
  Tv[19] := Tv[19] * Vl(FetchElm(RetNo, 'BANKRPT', 2)) / 366; // 20161227
  If (ret[RetNo].MarStatus < 3) then
   // ok
  Else
  begin
   For i := 1 to 13 do
   begin
     Frm[FNo].Strings[i] := '';
     Tv[i] := 0;
   end;
   Tv[14] := 0;
   For i := 16 to 21 do
   begin
    Frm[FNo].Strings[i] := '';
    Tv[i] := 0;
   end;
  end;
 End; //with ret
 SaveTv(RetNo, FName, FNo);  //20200412
End;

//20251125 Igor >>>
procedure S2MJNS(RetNo: Integer; FName: string; FNo: Integer; Prv: string);
var
 i, S2FNo, SpRetNo: Integer;
 SpTaxFormName: string;
begin
  SpTaxFormName:= GetSpTaxFormName(RetNo);
  InitPrvConstants('NS'); // ret[RetNo].Province);
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    if CouplingSw then
    begin
      SpRetNo:= GetSpRetNo(RetNo);

      if (SpRetNo > 0) then Tv[3]:= GetspouseAgeDeductionForMJ(SpRetNo, RetNo, FNo, 'NS');

      Tv[4]:= MinR(1173, Vl(FetchElm(SpRetNo, SpTaxFormName, 34))); //20251202 Igor
      Tv[5]:= GetMaxDisabForS2MJ(spRetNo, Prv);

      if UpperCase(FetchElm(SpRetNo, 'S11PRV', 25)).Equals('Y') then Tv[6]:= Vl(FetchElm(SpRetNo, 'S11PRV', 10)); // tuition
    end;

    Tv[7]:= Tv[3] + Tv[4] + Tv[5] + Tv[6];

    if CouplingSw then
    begin
      if (Ret[SpRetNo].Lnn[26000] <= 30507) then //20251202 Igor
        Tv[24]:= Ret[SpRetNo].Lnn[26000]
      else
        Tv[24]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 130)) / 0.0879; //20251202 Igor
    end;

    Tv[8]:= Tv[24];

    if CouplingSw then
    begin
      Tv[51]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 173));
      Tv[9]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 23)); //pers 5804
      Tv[14]:= Vl(FetchElm(SpRetNo, SpTaxFormName, 39));
    end;

    Tv[12]:= Tv[9] + Tv[51] + Tv[14];
    Tv[16]:= Tv[12];
    Tv[17]:= MaxR(0, Tv[8] - Tv[16]);
    Tv[18]:= Tv[17];
    Tv[19]:= MaxR(0, (Tv[7] - Tv[18]));

    if IsPreBankruptcyReturn(RetNo) then Tv[19]:= Tv[19] * Vl(FetchElm(RetNo, 'BANKRPT', 2)) / 366;
    if (Ret[RetNo].MarStatus >= 3) then
    begin
      for i:= 1 to 13 do
      begin
        Frm[FNo].Strings[i]:= '';
        Tv[i]:= 0;
      end;

      Tv[14]:= 0;
      for i:= 16 to 21 do
      begin
        Frm[FNo].Strings[i]:= '';
        Tv[i]:= 0;
      end;
    end;
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20251125 Igor <<<

Procedure S2MJNT(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
// 20180331
Var
 i, S2FNo, SpRetNo: Integer;
 S2PrvFNo:Integer;
 SpTaxFormName: String;
Begin
 SpTaxFormName := GetSpTaxFormName(RetNo);

 InitPrvConstants('NT'); // ret[RetNo].Province);
 LoadTv(RetNo, FName, FNo);

 With ret[RetNo], ret[RetNo].Frm[FNo] do
 begin
  //20240520
  S2prvFNo:=GetFormNo('S2PRV');
  {
  //Did not help //20240520
  for i:=3 to 47 do //20240520   //not to 19   //20240520
  begin
   Strings[i]:= FetchElmFNo(RetNo, S2PRVFNo,i);
   Tv[i]:=Vl(FetchElmFNo(RetNo, S2PrvFNo,i));
  end;
  xx:=Tv[3];
  }
  If CouplingSw = True then
  begin
       SpRetNo := GetSpRetNo(RetNo);
       if SpRetNo>0 then Tv[3]:=GetspouseAgeDeductionForMJ(SpRetNo, RetNo, FNo, 'NT'); //20220516
               //or from   Vl(FetchElm(SpRetNo, SpTaxFormName, 24)); //20220515
       xx:=Tv[3];
       {
       if Ret[SpRetNo].Lnn[23600]<=38508 then  //20200409
         Tv[3]:=7456 //10408  //20220515
       else
        Tv[3] := Vl(FetchElm(SpRetNo, SpTaxFormName, 24));  //5808 pesr
       If GetSpouseAge(RetNo)<65 then Tv[3]:=0; //20190317
       }
       Tv[4] := Vl(FetchElm(SpRetNo, SpTaxFormName, 34));    //5836 pension
       Tv[5] := GetMaxDisabForS2MJ(spRetNo,Prv);//Vl(FetchElm(SpRetNo, SpTaxFormName, 36));   //disabil 5844
       If UpperCase(FetchElm(SpRetNo, 'S11PRV', 25)) = 'Y' then
         Tv[6] := Vl(FetchElm(SpRetNo, 'S11PRV', 10));        // tuition
  end;

  Tv[7] := Tv[3] + Tv[4] + Tv[5] + Tv[6];
  If CouplingSw = True then
  begin
   If Ret[SpRetNo].Lnn[26000]<=48326 then
    Tv[24]:=Ret[SpRetNo].Lnn[26000]
  Else
    Tv[24]:=Vl(FetchElm(SpRetNo,SpTaxFormName,101))/(5.9/100); //20240521
  end;//  Else Tv[24] := MaxR(0, Tv[22] - Tv[23]);  //??? 20210404

  Tv[8] := Tv[24];

 If CouplingSw = True then
  begin
    //20210412
    Tv[51]  :=Vl(FetchElm(SpRetNo, SpTaxFormName, 79));
    Tv[9]  := Vl(FetchElm(SpRetNo, SpTaxFormName, 23));  //pers  5804
    Tv[14]  :=Vl(FetchElm(SpRetNo, SpTaxFormName, 39));
  end; // coupling
  Tv[12]:=Tv[9]+Tv[51]+Tv[14];

  Tv[16] :=Tv[12];
  Tv[17] := MaxR(0, Tv[8] - Tv[16]);
  Tv[18] := Tv[17];
  Tv[19] := MaxR(0, (Tv[7] - Tv[18]));
  xx:=tv[19];
  If IsPreBankruptcyReturn(RetNo) then
  Tv[19] := Tv[19] * Vl(FetchElm(RetNo, 'BANKRPT', 2)) / 366; // 20161227
  If (ret[RetNo].MarStatus < 3) then
   // ok
  Else
  begin
   For i := 1 to 13 do
   begin
     Frm[FNo].Strings[i] := '';
     Tv[i] := 0;
   end;

   Tv[14] := 0;
   For i := 16 to 21 do
   begin
    Frm[FNo].Strings[i] := '';
    Tv[i] := 0;
   end;
  end;
 End; //with ret
 SaveTv(RetNo, FName, FNo);
End;

(*
 //20200409 ?????? needs work
Procedure S2MJNT(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
// 20180322
Var
  i, S2FNo, SpRetNo: Integer;
  SpTaxFormName: String;
Begin
  SpTaxFormName := GetSpTaxFormName(RetNo);

  InitPrvConstants('NT'); // ret[RetNo].Province);
  LoadTv(RetNo, FName, FNo);

  With ret[RetNo] do
  begin
    Frm[FNo].Strings[30] := 'S2';
    If not FullTONIProvince(RetNo) then
    begin
      For i := 1 to 46 do // instead of 35
      begin
        Frm[FNo].Strings[i] := '';
        Tv[i] := 0;
        SaveTv(RetNo, FName, FNo);
        exit;
      end;
    end;
    If GetSpouseAge(RetNo)<65 then Tv[3]:=0; //20190317
    If (Prv = 'ON') or (Prv = 'NU') then { allow overrides }
      // ok
    else
    begin
      Frm[FNo].Strings[28] := '';
      Frm[FNo].Strings[27] := '';
    end;

    { copy from federal }
    S2FNo := GetFormNo('S2');
    For i := 1 to 2 do
    begin
      Frm[FNo].Strings[i] := FetchElmFNo(RetNo, S2FNo, i);
      Tv[i] := Vl(FetchElmFNo(RetNo, S2FNo, i));
    end;
    // --------------
    // 20180322  new fiels copy from fed
    Tv[11] := Vl(FetchElmFNo(RetNo, S2FNo, 11)); // cpp empl
    Tv[12] := Vl(FetchElmFNo(RetNo, S2FNo, 12)); // cpp self
    Tv[35] := Vl(FetchElmFNo(RetNo, S2FNo, 35)); // line 317
    Tv[13] := Vl(FetchElmFNo(RetNo, S2FNo, 13)); // Empl ins
    If (Prv = 'MB') then
      Tv[38] := Vl(FetchElmFNo(RetNo, S2FNo, 38))
    else
      Tv[38] := 0;
    If (Prv = 'BC') or (Prv = 'MB') Or (Prv = 'YT') then
      Tv[39] := Vl(FetchElmFNo(RetNo, S2FNo, 39))
    else
      Tv[39] := 0;
    If (Prv = 'BC') then
      Tv[44] := Vl(FetchElmFNo(RetNo, S2FNo, 44))
    else
      Tv[44] := 0;
    If (Prv = 'BC') then
      Tv[45] := Vl(FetchElmFNo(RetNo, S2FNo, 45))
    else
      Tv[45] := 0;
    If (Prv = 'BC') or (Prv = 'MB') then
      Tv[43] := Vl(FetchElmFNo(RetNo, S2FNo, 43))
    else
      Tv[43] := 0;
    If (Prv = 'BC') then
      Tv[46] := Vl(FetchElmFNo(RetNo, S2FNo, 46))
    else
      Tv[46] := 0;
    If (Prv = 'NL') or (Prv = 'BC') OR (Prv = 'MB') then
      Tv[40] := Vl(FetchElmFNo(RetNo, S2FNo, 40))
    else
      Tv[40] := 0;
    If (Prv = 'NL') then
      Tv[41] := Vl(FetchElmFNo(RetNo, S2FNo, 41))
    else
      Tv[41] := 0;
    If (Prv = 'SK') then
      Tv[42] := Vl(FetchElmFNo(RetNo, S2FNo, 42))
    else
      Tv[42] := 0;
    // ---------------------------

    // disability Xfer
    Frm[FNo].Strings[5] := FetchElmFNo(RetNo, S2FNo, 5);
    Tv[5] := Vl(FetchElmFNo(RetNo, S2FNo, 5));
    If (Tv[5] > 0) then
    begin
      If CalcAge(GetSpouseBirthDate(RetNo)) < 18 then
        Tv[5] := PrvConstant[RY].PrvMaxDisability + PrvConstant[RY]
          .PrvMaxDisabSupl18
      else
        Tv[5] := PrvConstant[RY].PrvMaxDisability;
    end;
    // 20130224
    For i := 7 to 9 do // do not include the tuition April 15 2008  //not 10
    begin
      Frm[FNo].Strings[i] := FetchElmFNo(RetNo, S2FNo, i);
      Tv[i] := Vl(FetchElmFNo(RetNo, S2FNo, i));
    end;

    For i := 16 to 18 do // not 19 20130224
    begin
      Frm[FNo].Strings[i] := FetchElmFNo(RetNo, S2FNo, i);
      Tv[i] := Vl(FetchElmFNo(RetNo, S2FNo, i));
    end;
    // 20130224
    For i := 20 to 20 do // not 21
    begin
      Frm[FNo].Strings[i] := FetchElmFNo(RetNo, S2FNo, i);
      Tv[i] := Vl(FetchElmFNo(RetNo, S2FNo, i));
    end;

    For i := 22 to 24 do
    begin
      Frm[FNo].Strings[i] := FetchElmFNo(RetNo, S2FNo, i);
      Tv[i] := Vl(FetchElmFNo(RetNo, S2FNo, i));
    end;

    ret[RetNo].Frm[FNo].Strings[29] := PrvLong[GetPrvIndex(Prv)];
    // PrvLong[GetPrvIndex(ret[RetNo].Province)];

    // 20110409  age amount
    If UpperCase(Frm[FNo].Strings[28]) <> 'Y' then
    begin
      If Vl(FetchElmFNo(RetNo, S2FNo, 3)) = Constant[RY].MaxAgeAmount then
        Tv[3] := PrvConstant[RY].PrvMaxAgeAmount; // april 2005
    end;

    i := 4; // pension
    If UpperCase(Frm[FNo].Strings[27]) <> 'Y' then
    begin // april 2005
      If Vl(FetchElmFNo(RetNo, S2FNo, i)) = 1000 then // max fed
        Tv[i] := PrvConstant[RY].PrvMaxPensionAmount
      else
        Tv[i] := Vl(FetchElmFNo(RetNo, S2FNo, i));
    end;

    Frm[FNo].Strings[29] := PrvLong[GetPrvIndex(Prv)];
    // PrvLong[GetPrvIndex(Province)]; //20180314
    If Prv = 'NL' then
      ret[RetNo].Frm[FNo].Strings[29] := 'NL';
    If Prv <> 'SK' then
    begin
      Tv[25] := 0;
      Tv[26] := 0;
    end;

    // 20160220 //20160223 Igor
    If Prv <> 'BC' then
    Begin
      Tv[44] := 0;
      Tv[45] := 0;
      Tv[46] := 0; // 20161127
    end;

    If Prv <> 'NU' then
    begin
      Tv[32] := 0;
    end;

    If CouplingSw = True then
    begin
      SpRetNo := GetSpRetNo(RetNo);
      Tv[3] := Vl(FetchElm(SpRetNo, SpTaxFormName, 24));
      Tv[4] := Vl(FetchElm(SpRetNo, SpTaxFormName, 34));
      Tv[5] := GetMaxDisabForS2MJ(RetNo,Prv); //20200410  //Vl(FetchElm(SpRetNo, SpTaxFormName, 36));
      If Prv = 'SK' then
      begin
        Tv[25] := Vl(FetchElm(SpRetNo, 'SK428', 66));
        Tv[26] := Vl(FetchElm(SpRetNo, 'SK428', 67));
        // 20160216 Igor
        Tv[42] := Vl(FetchElm(RetNo, 'SK428', 84)); // 20160214
      end;
      { M15 }
      If UpperCase(FetchElm(SpRetNo, 'S11PRV', 25)) = 'Y' then
        Tv[6] := Vl(FetchElm(SpRetNo, 'S11PRV', 10));
    end;

    If UpperCase(Frm[FNo].Strings[28]) <> 'Y' then
      Tv[3] := MinR(Tv[3], PrvConstant[RY].PrvMaxAgeAmount);

    If UpperCase(Frm[FNo].Strings[27]) <> 'Y' then
      Tv[4] := MinR(PrvConstant[RY].PrvMaxPensionAmount, Tv[4]);

    If (Prv = 'ON') then { if eq to max fed }
    begin
      If Tv[3] = Constant[RY].MaxAgeAmount then
        Tv[3] := PrvConstant[RY].PrvMaxAgeAmount;
      If Tv[4] = 1000 then { max fed pens ded }
        Tv[4] := PrvConstant[RY].PrvMaxPensionAmount;
    end;

    If CalcAge(GetSpouseBirthDate(RetNo)) < 18 then
      Tv[5] := MinR(Tv[5], PrvConstant[RY].PrvMaxDisability + PrvConstant[RY]
        .PrvMaxDisabSupl18)
    else
      Tv[5] := MinR(Tv[5], PrvConstant[RY].PrvMaxDisability);

    // if Province='PE' then Tv[5]:=8113;  //20180322

    If FullTONIProvince(RetNo) then
    begin
      Tv[6] := MinR(Tv[6], PrvConstant[RY].PrvMaxEducXfer);
    end;

    Tv[7] := Tv[3] + Tv[4] + Tv[5] + Tv[6];

    Tv[24] := MaxR(0, Tv[22] - Tv[23]);
    Tv[8] := Tv[24];

    Tv[9] := PrvConstant[RY].PrvPersAmount;

    Tv[9] := MinR(Tv[9], PrvConstant[RY].PrvPersAmount);
    Tv[11] := MinR(Tv[11], Constant[RY].MaxCpp);
    Tv[13] := MinR(Tv[13], Constant[RY].MaxUI52);
    If CouplingSw = True then
    begin
      Tv[9] := Vl(FetchElm(SpRetNo, SpTaxFormName, 23));
      Tv[11] := Vl(FetchElm(SpRetNo, SpTaxFormName, 31));
      Tv[12] := Vl(FetchElm(SpRetNo, SpTaxFormName, 32));
      Tv[35] := ret[RetNo].Lnn[31217];
      Tv[13] := Vl(FetchElm(SpRetNo, SpTaxFormName, 33));
      If (Prv = 'NL') or (Prv = 'ON') or (Prv = 'MB') or (Prv = 'AB') or
        (Prv = 'BC') then
        Tv[31] := Vl(FetchElm(SpRetNo, SpTaxFormName, 51)) // adoption
      else
        Tv[31] := 0;

      Tv[33] := 0; // fitness 5838
      If (Prv = 'BC') then
      begin
        Tv[33] := Vl(FetchElm(SpRetNo, SpTaxFormName, 83)); // 20160220
        Tv[40] := Vl(FetchElm(SpRetNo, SpTaxFormName, 86)); // 20180225
        Tv[43] := Vl(FetchElm(SpRetNo, SpTaxFormName, 87)); // 20180225
        Tv[46] := Vl(FetchElm(RetNo, 'BC428', 88)); // 20161127
      end;
      if SpRetNo > 0 then // 20180202
        Tv[14] := Vl(FetchElm(SpRetNo, SpTaxFormName, 39));
      // tuition  //20120131  //20140315

      If (Prv = 'YT') then
        Tv[36] := Vl(FetchElm(SpRetNo, 'YT428', 73))
      else
        Tv[36] := 0;
    end; // coupling

    If (Prv = 'MB') or (Prv = 'YT') then // fitness
      // ok
    else
      Tv[33] := 0;

    If (Prv <> 'YT') then
      Tv[34] := 0;
    If (Prv <> 'YT') then
      Tv[36] := 0;
    If (Prv <> 'YT') then
      Tv[37] := 0;

    // 20120131
    If CouplingSw = True then // 20170102
    Begin
      If Prv = 'MB' then
      begin
        Tv[38] := Vl(FetchElm(SpRetNo, SpTaxFormName, 67)); // 5839
        Tv[43] := Vl(FetchElm(SpRetNo, 'MB428', 78));
        // 20170102 //20160214 //20160216 Igor //Vl(FetchElm(RetNo,'MB428',78));  //20160214 //20160216 Igor
      end
      Else
      Begin
        Tv[38] := 0;
        Tv[43] := 0; // 20160214
      end;
    End;

    // 20160220 //20160223 Igor
    // 5841 Tv[39]
    If (Prv = 'BC') then
      Tv[39] := Vl(FetchElm(RetNo, 'BC428', 84));
    If (Prv = 'MB') then
      Tv[39] := Vl(FetchElm(RetNo, 'MB428', 74));
    If (Prv = 'YT') then
      Tv[39] := Vl(FetchElm(RetNo, 'YT428', 65));

    // 20120131
    If Prv = 'NL' then
    begin
      Tv[40] := Vl(FetchElm(SpRetNo, SpTaxFormName, 90)); // 5830
      Tv[41] := Vl(FetchElm(SpRetNo, SpTaxFormName, 91)); // 5831
    end
    Else If (Prv = 'MB') then // 20160214 //20160216 Igor
    begin
      Tv[40] := Vl(FetchElm(SpRetNo, SpTaxFormName, 77)); // 5830
    end
    Else
    Begin
      Tv[40] := 0;
      Tv[41] := 0;
    end;

    Tv[16] := Tv[9] + Tv[11] + Tv[12] + Tv[13] + Tv[35] + Tv[14];

    Tv[17] := MaxR(0, Tv[8] - Tv[16]);
    Tv[18] := Tv[17];
    Tv[19] := MaxR(0, (Tv[7] - Tv[18]));

    If IsPreBankruptcyReturn(RetNo) then
      Tv[19] := Tv[19] * Vl(FetchElm(RetNo, 'BANKRPT', 2)) / 366; // 20161227
    If UpperCase(Frm[FNo].Strings[10]) = 'Y' then
      Tv[19] := Tv[21];

    // 20151220
    If (ret[RetNo].MarStatus < 3) then
      // ok
    Else
    begin
      If (UpperCase(Frm[FNo].Strings[20]) <> 'Y') then
      begin
        // 20160126   //15 is the prv naame
        For i := 1 to 13 do
        begin
          Frm[FNo].Strings[i] := '';
          Tv[i] := 0;
        end;
        Tv[14] := 0; // 20180202
        For i := 16 to 21 do
        begin
          Frm[FNo].Strings[i] := '';
          Tv[i] := 0;
        end;
      end;
    end;
  end; { with ret[retno] }
  SaveTv(RetNo, FName, FNo);
end;
*)
Procedure S11MJPE(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
// 20180324
var
  i, S11FNo, PrvTaxFNo, T2202FNo: Integer;
  S11PrvFNo: Integer;
Begin
  InitPrvConstants('PE');
  PrvTaxFNo := GetFormNo(Prv + '428');

  S11PrvFNo := GetFormNo('S11PRV');
  // bring from the generic S11Prv
  // for i:=1 to 50 do Begin StroreElm(RetNo,FNo,i,FetchElmFNo(RetNo,S11PrvFNo,i);

  LoadTv(RetNo, FName, FNo);
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    // Copy from federal  20091121
    S11FNo := GetFormNo('S11');
    T2202FNo := GetFormNo('T2202'); // 20180227
   // Frm[FNo].Strings[31] := PrvLong[GetPrvIndex(ret[RetNo].Province)];
   // Frm[FNo].Strings[32] := GetS11PrvHeader(RetNo);

    //29240504 Tv[13]:= Vl(FetchElmFNo(RetNo, S11FNo, 13)); //20180402  //cf from last year

    Tv[1] := Vl(FetchElmFNo(RetNo, S11FNo, 1));
    If Prv = 'NB' then  Tv[1] := 0; // 20180201
    if Prv = 'ON' then  Tv[1] := Vl(FetchElmFNo(RetNo, T2202FNo, 68)); // t22080227
    if Prv = 'SK' then  Tv[1] := Vl(FetchElmFNo(RetNo, T2202FNo, 71)); // t22080312

    //xx:=Tv[1]; //20240504

    // 20180205
    With ret[RetNo].Frm[FNo] do
    Begin
      // part time
      Strings[15] := FetchElmFNo(RetNo, S11FNo, 35); // b
      if Prv = 'ON' then
        Strings[15] := FetchElmFNo(RetNo, T2202FNo, 69); // t22080227
      if Prv = 'SK' then
        Strings[15] := FetchElmFNo(RetNo, T2202FNo, 72); // t22080312
      If MyStrToInt(Strings[15]) > 12 then
        Strings[15] := '12';
      If (Prv = 'NB') then
      Begin
        Tv[1] := 0;
        Strings[15] := '';
        Strings[33] := '';
      end;
      If (Prv = 'YT') then
      begin
        Strings[15] := '';
        Strings[33] := '';
      end;
      Strings[39] := '';
      Strings[40] := '';
      Strings[33] := AllTrim(IntToStr(PrvConstant[RY].PrvPartEducPerMonth));

      If Prv = 'NU' then
        Strings[33] := '120';
      if FetchElm(RetNo, S11FNo, 31) > '' then
        Strings[15] := ''; // makeit full time //20189211
      Tv[37] := MyStrToInt(Strings[15]) * (MyStrToInt(Strings[33]));

      If Prv = 'NU' then
      begin
        Strings[39] := Strings[15];
        Strings[40] := '20';
      end; // 20180211

      Tv[41] := MyStrToInt(Strings[39]) * (MyStrToInt(Strings[40]));
      Tv[42] := Tv[37] + Tv[41];
      Tv[14] := Tv[42];

      // ---------Full time
      Strings[12] := FetchElmFNo(RetNo, S11FNo, 42);
      if Prv = 'ON' then
        Strings[12] := FetchElmFNo(RetNo, T2202FNo, 70); // t22080227
      if Prv = 'SK' then
        Strings[12] := FetchElmFNo(RetNo, T2202FNo, 73); // t22080312
      If MyStrToInt(Strings[12]) > 12 then
        Strings[12] := '12';
      Strings[34] := AllTrim(IntToStr(PrvConstant[RY].PrvEducPerMonth));
      If (Prv = 'NB') then
      begin
        Strings[12] := '';
        Strings[34] := '';
      end;
      If (Prv = 'YT') then
      Begin
        Strings[12] := '';
        Strings[34] := '';
      end;
      If Prv = 'NU' then
        Strings[34] := '400';

      if FetchElm(RetNo, S11FNo, 31) > '' then
        Strings[12] := FetchElmFNo(RetNo, S11FNo, 35);
      // prt time months to full time //20180211
      Tv[45] := MyStrToInt(Strings[12]) * (MyStrToInt(Strings[34]));

      Strings[44] := ''; // Strings[12];
      Strings[43] := ''; // AllTrim(IntToStr(PrvConstant[RY].PrvEducPerMonth));
      If Prv = 'NU' then
      begin
        Strings[44] := Strings[12];
        Strings[43] := '65';
      end; // 20180211
      Tv[46] := MyStrToInt(Strings[44]) * (MyStrToInt(Strings[43]));
      Tv[47] := Tv[45] + Tv[46];
      Tv[2] := Tv[47];
      Strings[26] := FetchElmFNo(RetNo, S11FNo, 26); // 20120204    //sin?
    end;
    Tv[3] := Tv[1] + Tv[14] + Tv[2];
    Tv[16] := Tv[3];
    Tv[4] := Tv[13] + Tv[16];
    If FullTONIProvince(RetNo) then
    begin
      PrvTaxFNo := GetFormNo(WhichTaxForm(RetNo, Prv));
      Tv[5] := GetTxblForPrvS11(RetNo, Prv, PrvConstant[RY].PrvBracket1,
        Vl(PrvConstant[RY].PrvRate1));
      // 20180324
      If (Prv = 'NL') then
        Tv[6] := Vl(FetchElm(RetNo, 'T2203', 220));
      If (Prv = 'PE') then
        Tv[6] := Vl(FetchElm(RetNo, 'T2203', 221));
      If (Prv = 'NS') then
        Tv[6] := Vl(FetchElm(RetNo, 'T2203', 222));
      If (Prv = 'NB') then
        Tv[6] := Vl(FetchElm(RetNo, 'T2203', 223));
      If (Prv = 'ON') then
        Tv[6] := Vl(FetchElm(RetNo, 'T2203', 224));
      If (Prv = 'MB') then
        Tv[6] := Vl(FetchElm(RetNo, 'T2203', 225));
      If (Prv = 'SK') then
        Tv[6] := Vl(FetchElm(RetNo, 'T2203', 226));
      If (Prv = 'AB') then
        Tv[6] := Vl(FetchElm(RetNo, 'T2203', 227));
      If (Prv = 'BC') then
        Tv[6] := Vl(FetchElm(RetNo, 'T2203', 228));
      If (Prv = 'YT') then
        Tv[6] := Vl(FetchElm(RetNo, 'T2203', 229));
      If (Prv = 'NT') then
        Tv[6] := Vl(FetchElm(RetNo, 'T2203', 230));
      If (Prv = 'NU') then
        Tv[6] := Vl(FetchElm(RetNo, 'T2203', 231));
    end;

    Tv[7] := MaxR(0, Tv[5] - Tv[6]);
    Tv[17] := MinR(Tv[13], Tv[7]);
    Tv[18] := Tv[17];
    Tv[19] := MaxR(0, Tv[7] - Tv[17]);
    Tv[8] := MinR(Tv[16], Tv[19]);

    If UpperCase(Frm[FNo].Strings[28]) = 'Y' then
      Tv[8] := Tv[29];
    If Tv[29] > MinR(Tv[16], Tv[19]) then
      Tv[8] := MinR(Tv[16], Tv[19]);

    Tv[21] := Tv[18] + Tv[8];

    Tv[22] := Tv[4]; // MinR(Tv[16],Tv[35]);
    Tv[23] := Tv[21]; // Tv[8];
    Tv[24] := MaxR(0, Tv[22] - Tv[23]);

    Tv[35] := PrvConstant[RY].PrvMaxEducXfer;
    Tv[9] := MinR(Tv[35], Tv[16]); // Tv[4];
    Tv[20] := Tv[8]; // Tv[21];  Feb 12, 2003
    Tv[30] := MaxR(0, Tv[9] - Tv[20]);

    If Tv[10] > Tv[30] then
      Tv[10] := Tv[30];
    If UpperCase(Frm[FNo].Strings[36]) = 'Y' then
    begin
      If UpperCase(Frm[FNo].Strings[38]) <> 'N' then
        Tv[10] := Tv[30];
      If Frm[FNo].Strings[26] > '' then
        Frm[FNo].Strings[25] := 'N';
    end
    else
    begin
      Tv[10] := 0;
      Frm[FNo].Strings[25] := 'N';
      Frm[FNo].Strings[26] := '';
    end;

    Tv[11] := MaxR(0, Tv[24] - Tv[10]);
  end;
  SaveTv(RetNo, FName, FNo);
End;

//20251125 Igor >>>
procedure S11MJNL(RetNo: Integer; FName: string; FNo: Integer; Prv: string);
var
  i, S11FNo, PrvTaxFNo, T2202FNo: Integer;
  S11PrvFNo: Integer;
begin
  InitPrvConstants('NL');
  PrvTaxFNo:= GetFormNo(Prv + '428');
  S11PrvFNo:= GetFormNo('S11PRV');
  // bring from the generic S11Prv
  // for i:=1 to 50 do Begin StroreElm(RetNo,FNo,i,FetchElmFNo(RetNo,S11PrvFNo,i);
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    S11FNo:= GetFormNo('S11');
    T2202FNo:= GetFormNo('T2202');
    //29240504 If Ret[RetNo].Province='NL' then Tv[13]:= Vl(FetchElmFNo(RetNo, S11FNo, 13)); //20180402  //cf from last year
    Tv[1]:= Vl(FetchElmFNo(RetNo, S11FNo, 1));
    Strings[15]:= FetchElmFNo(RetNo, S11FNo, 35); // b
    Strings[33]:= AllTrim(IntToStr(PrvConstant[RY].PrvPartEducPerMonth));

    if (FetchElm(RetNo, S11FNo, 31) > '') then  Strings[15]:= '';

    Tv[14]:= MyStrToInt(Strings[15]) * (MyStrToInt(Strings[33]));
    Strings[12]:= FetchElmFNo(RetNo, S11FNo, 42);
    Strings[34]:= AllTrim(IntToStr(PrvConstant[RY].PrvEducPerMonth));

    if (MyStrToInt(Strings[12]) > 12) then Strings[12]:= '12';
    if (FetchElm(RetNo, S11FNo, 31) > '') then  Strings[12]:= FetchElmFNo(RetNo, S11FNo, 35);

    Tv[2]:= MyStrToInt(Strings[12]) * (MyStrToInt(Strings[34]));
    Tv[3]:= Tv[1] + Tv[14] + Tv[2];
    Tv[16]:= Tv[3];
    Tv[4]:= Tv[13] + Tv[16];

    if (Ret[retno].LNN[26000] <= 44192) then
      Tv[5]:= Ret[RetNo].Lnn[26000]
    else
    begin
      Tv[11]:= Vl(FetchElm(RetNo, 'NLMJ', 1));
      Tv[5]:= Tv[11] / 0.087;
    end;

    Tv[6]:= Vl(FetchElm(RetNo, 'T2203', 113)); //GetMj5804To5848(RetNo, Prv); //20200411 //If (Prv = 'NL') then Tv[6] := Vl(FetchElm(RetNo, 'T2203', 220));
    Tv[7]:= MaxR(0, Tv[5] - Tv[6]);
    Tv[17]:= MinR(Tv[13], Tv[7]);
    Tv[18]:= Tv[17];
    Tv[19]:= MaxR(0, Tv[7] - Tv[17]);
    Tv[8]:= MinR(Tv[16], Tv[19]);
    Tv[21]:= Tv[18] + Tv[8];
    Tv[9]:= MinR(5000, Tv[16]);
    Tv[20]:= Tv[8];
    Tv[30]:= MaxR(0, Tv[9] - Tv[20]);

    if (Tv[10] > Tv[30]) then Tv[10]:= Tv[30];
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure S11MJNS(RetNo: Integer; FName: string; FNo: Integer; Prv: string);
var
  i, S11FNo, PrvTaxFNo, T2202FNo: Integer;
  S11PrvFNo: Integer;
begin
  InitPrvConstants('NS');
  PrvTaxFNo:= GetFormNo(Prv + '428');
  S11PrvFNo:= GetFormNo('S11PRV');
  // bring from the generic S11Prv
  // for i:=1 to 50 do Begin StroreElm(RetNo,FNo,i,FetchElmFNo(RetNo,S11PrvFNo,i);
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    S11FNo:= GetFormNo('S11');
    T2202FNo:= GetFormNo('T2202');
    //29240504 Tv[13]:= Vl(FetchElmFNo(RetNo, S11FNo, 13)); //20180402  //cf from last year
    Tv[1]:= Vl(FetchElmFNo(RetNo, S11FNo, 1));
    Strings[15]:= FetchElmFNo(RetNo, S11FNo, 35); // b
    Strings[33]:= '60';
    Tv[14]:= MyStrToInt(Strings[15]) * (MyStrToInt(Strings[33]));
    Strings[12]:= FetchElmFNo(RetNo, S11FNo, 42);
    Strings[34]:= '200'; //20251128 Igor
    Tv[2]:= MyStrToInt(Strings[12]) * (MyStrToInt(Strings[34]));
    Tv[3]:= Tv[1] + Tv[14] + Tv[2];
    Tv[16]:= Tv[3];
    Tv[4]:= Tv[13] + Tv[16];

    if (Ret[retno].LNN[26000] <= 30507) then //20251128 Igor
      Tv[5]:= Ret[RetNo].Lnn[26000]
    else
    begin
      Tv[9]:= Vl(FetchElm(RetNo, 'NSMJ', 30)); //line 8 of xxMJ
      Tv[5]:= Tv[9] / 0.0879; //20251128 Igor
    end;

    Tv[6]:= Vl(FetchElm(RetNo, 'T2203', 127));
    Tv[7]:= MaxR(0, Tv[5] - Tv[6]);
    Tv[17]:= MinR(Tv[13], Tv[7]);
    Tv[18]:= Tv[17];
    Tv[19]:= MaxR(0, Tv[7] - Tv[17]);
    Tv[8]:= MinR(Tv[16], Tv[19]);

    if UpperCase(Ret[RetNo].Frm[FNo].Strings[28]).Equals('Y') then Tv[8]:= Tv[29];
    if (Tv[29] > MinR(Tv[16], Tv[19])) then Tv[8]:= MinR(Tv[16], Tv[19]);

    Tv[21]:= Tv[18] + Tv[8];
    Tv[22]:= MinR(5000, Tv[16]);
    Tv[23]:= Tv[8];
    Tv[24]:= MaxR(0, Tv[22] - Tv[23]);
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure S11MJNB(RetNo: Integer; FName: string; FNo: Integer; Prv: string);
var
  i, S11FNo, PrvTaxFNo, T2202FNo: Integer;
  S11PrvFNo: Integer;
begin
  InitPrvConstants('NB');
  PrvTaxFNo:= GetFormNo(Prv + '428');
  S11PrvFNo:= GetFormNo('S11PRV');
  //bring from the generic S11Prv
  //for i:=1 to 50 do Begin StroreElm(RetNo,FNo,i,FetchElmFNo(RetNo,S11PrvFNo,i);
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    S11FNo:= GetFormNo('S11');
    T2202FNo:= GetFormNo('T2202');
    //29240504 Tv[13]:= Vl(FetchElmFNo(RetNo, S11FNo, 13)); //20180402  //cf from last year
    Tv[1]:= Vl(FetchElmFNo(RetNo, S11FNo, 1));
    Tv[4]:= Tv[13] + Tv[1];
    PrvTaxFNo:= GetFormNo(WhichTaxForm(RetNo, Prv));

    if (Ret[retno].LNN[26000] <= 51306) then //20251125 Igor
      Tv[5]:=Ret[RetNo].Lnn[26000]
    else
    begin
      Tv[8]:= Vl(FetchElm(RetNo, 'NBMJ', 30));
      Tv[5]:= Tv[81] / 0.094; //20251125 Igor
    end;

    Tv[6]:= Vl(FetchElm(RetNo, 'T2203', 128));
    Tv[7]:= MaxR(0, Tv[5] - Tv[6]);
    Tv[2]:= MinR(Tv[13], Tv[7]);
    Tv[18]:= Tv[2];
    Tv[19]:= MaxR(0, Tv[7] - Tv[2]);
    Tv[17]:= MinR(Tv[13], Tv[7]);
    Tv[3]:= MinR(Tv[1], Tv[19]);
    Tv[21]:= Tv[18] + Tv[3];
    Tv[9]:= MinR(5000, Tv[1]);
    Tv[20]:= Tv[3];
    Tv[30]:= MaxR(0, Tv[9] - Tv[20]);

    if (Tv[10] > Tv[30]) then Tv[10]:= Tv[30];
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20251125 Igor <<<

Procedure S11MJON(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
// 20190317
var
  i, S11FNo, PrvTaxFNo, T2202FNo: Integer;
  S11PrvFNo: Integer;
Begin
  InitPrvConstants('ON');
  PrvTaxFNo := GetFormNo(Prv + '428');

  S11PrvFNo := GetFormNo('S11PRV');
  // bring from the generic S11Prv
  // for i:=1 to 50 do Begin StroreElm(RetNo,FNo,i,FetchElmFNo(RetNo,S11PrvFNo,i);

  LoadTv(RetNo, FName, FNo);
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    // Copy from federal  20091121
    S11FNo := GetFormNo('S11');
    T2202FNo := GetFormNo('T2202'); // 20180227

    //29240504 Tv[13]:= Vl(FetchElmFNo(RetNo, S11FNo, 13)); //20180402  //cf from last year

    // 20180205
    With ret[RetNo].Frm[FNo] do
    Begin
      // part time
      Strings[15] := FetchElmFNo(RetNo, S11FNo, 35); // b
      if Prv = 'ON' then
        Strings[15] := FetchElmFNo(RetNo, T2202FNo, 69); // t22080227

      PrvTaxFNo := GetFormNo(WhichTaxForm(RetNo, Prv));

      if Ret[retno].LNN[26000] <=45142 then
       Tv[5]:=Ret[RetNo].Lnn[26000]
      Else
      Begin
       Tv[1]:=Vl(FetchElm(RetNo,'ONMJ',30));  //line 8 of xxMJ
       Tv[5]:=Tv[1]/(5.05/100);
      End;
      //Tv[5] := GetTxblForPrvS11(RetNo, Prv, PrvConstant[RY].PrvBracket1,Vl(PrvConstant[RY].PrvRate1));
      Tv[6]:=Vl(FetchElm(RetNo,'T2203',129)); //GetMj5804To5848(RetNo, Prv); //20200411 //If (Prv = 'ON') then Tv[6] := Vl(FetchElm(RetNo, 'T2203', 224));
    end;
    Tv[7] := MaxR(0, Tv[5] - Tv[6]);
    Tv[21] := MinR(Tv[13],Tv[7]);
  end;
  SaveTv(RetNo, FName, FNo);
End;

//20251125 Igor >>>
procedure S11MJMB(RetNo: Integer; FName: string; FNo: Integer; Prv: string);
var
  i, S11FNo, PrvTaxFNo, T2202FNo: Integer;
  S11PrvFNo: Integer;
begin
  InitPrvConstants('MB');
  PrvTaxFNo:= GetFormNo(Prv + '428');
  S11PrvFNo:= GetFormNo('S11PRV');
  // bring from the generic S11Prv
  // for i:=1 to 50 do Begin StroreElm(RetNo,FNo,i,FetchElmFNo(RetNo,S11PrvFNo,i);
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    S11FNo:= GetFormNo('S11');
    T2202FNo:= GetFormNo('T2202');
    Tv[1]:= Vl(FetchElmFNo(RetNo, S11FNo, 1));
    Strings[15]:= FetchElmFNo(RetNo, S11FNo, 35); // b

    if (MyStrToInt(Strings[15]) > 12) then Strings[15]:= '12';

    Strings[33]:= AllTrim(IntToStr(PrvConstant[RY].PrvPartEducPerMonth)); //20251128 Igor

    if FetchElm(RetNo, S11FNo, 31).Equals('') then  Strings[15]:= '';

    Tv[14]:= Tv[15] * myStrToInt(strings[33]);
    Strings[12] := FetchElmFNo(RetNo, S11FNo, 42);
    Strings[34]:= AllTrim(IntToStr(PrvConstant[RY].PrvEducPerMonth));

    if (MyStrToInt(Strings[12]) > 12) then Strings[12]:= '12';
    if (FetchElm(RetNo, S11FNo, 31) > '') then Strings[12]:= FetchElmFNo(RetNo, S11FNo, 35);

    Tv[2]:= MyStrToInt(Strings[12]) * (MyStrToInt(Strings[34]));
    Tv[3]:= Tv[1] + Tv[14] + Tv[2];
    Tv[16]:= Tv[3];
    Tv[4]:= Tv[13] + Tv[16];

    if (Ret[retno].LNN[26000] <= 47000) then //20251125 Igor
      Tv[5]:= Ret[RetNo].Lnn[26000]
    else
    begin
      Tv[11]:= Vl(FetchElm(RetNo, 'MBMJ', 62));
      Tv[5]:= Tv[11] / 0.108; //20251125 Igor
    end;

    // PrvTaxFNo:= GetFormNo(WhichTaxForm(RetNo, Prv));
    // Tv[5]:= GetTxblForPrvS11(RetNo, Prv, PrvConstant[RY].PrvBracket1,Vl(PrvConstant[RY].PrvRate1));
    Tv[6]:= Vl(FetchElm(RetNo, 'T2203', 130)); //??GetMj5804To5848(RetNo, Prv); //20200411
    Tv[7]:= MaxR(0, Tv[5] - Tv[6]);
    Tv[17]:= MinR(Tv[13], Tv[7]);
    Tv[18]:= Tv[17];
    Tv[19]:= MaxR(0, Tv[7] - Tv[17]);
    Tv[8]:= MinR(Tv[16], Tv[19]);
    //If UpperCase(Frm[FNo].Strings[28]) = 'Y' then  Tv[8] := Tv[29];
    //If Tv[29] > MinR(Tv[16], Tv[19]) then Tv[8] := MinR(Tv[16], Tv[19]);
    Tv[21]:= Tv[18] + Tv[8];
    Tv[22]:= Tv[16];
    Tv[23]:= Tv[8];
    Tv[24]:= MaxR(0, Tv[22] - Tv[23]);
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20251125 Igor <<<

Procedure S11MJSK(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
// 20180324
var
  i, S11FNo, PrvTaxFNo, T2202FNo: Integer;
  S11PrvFNo: Integer;
Begin
  InitPrvConstants('SK');
  PrvTaxFNo := GetFormNo(Prv + '428');

  S11PrvFNo := GetFormNo('S11PRV');
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    // Copy from federal  20091121
    S11FNo := GetFormNo('S11');
    T2202FNo := GetFormNo('T2202'); // 20180227
    //29240504 Tv[13]:= Vl(FetchElmFNo(RetNo, S11FNo, 13)); //20180402  //cf from last year
    PrvTaxFNo := GetFormNo(WhichTaxForm(RetNo, Prv));
    if Ret[retno].LNN[26000] <=49720 then //45677 then //20240504
     Tv[5]:=Ret[RetNo].Lnn[26000]
    Else
    Begin
     Tv[1]:=Vl(FetchElm(RetNo,'SKMJ',1));  //line 8 of xxMJ
     Tv[5]:=Tv[1]/(10.5/100);
    End;

    //Tv[5] := GetTxblForPrvS11(RetNo, Prv, PrvConstant[RY].PrvBracket1,Vl(PrvConstant[RY].PrvRate1));
    Tv[6] :=Vl(FetchElm(RetNo,'T2203',136));  GetMj5804To5848(RetNo, Prv);  //20200411 //Vl(FetchElm(RetNo, 'T2203', 226));
    Tv[7] := MaxR(0, Tv[5] - Tv[6]);
    Tv[21] := MinR(Tv[13], Tv[7]); //Tv[17] := MinR(Tv[13], Tv[7]); //20190326

  end;
  SaveTv(RetNo, FName, FNo);
End;

//20251125 Igor >>>
procedure S11MJAB(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
var
  i, S11FNo, PrvTaxFNo, T2202FNo: Integer;
  S11PrvFNo: Integer;
Begin
  InitPrvConstants('AB');
  PrvTaxFNo:= GetFormNo(Prv + '428');
  S11PrvFNo:= GetFormNo('S11PRV');
  // bring from the generic S11Prv
  // for i:=1 to 50 do Begin StroreElm(RetNo,FNo,i,FetchElmFNo(RetNo,S11PrvFNo,i);

  LoadTv(RetNo, FName, FNo);
  with ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    if (Ret[retno].LNN[26000] <= 60000) then //20251125 Igor
      Tv[1]:= Ret[RetNo].Lnn[26000]
    else
    begin
      Tv[5]:= Vl(FetchElm(RetNo, 'ABMJ', 25)); //line 8 of xxMJ
      Tv[1]:= Tv[5] / 0.08; //20251125 Igor
    end;

    Tv[6]:= Vl(FetchElm(RetNo, 'T2203', 140)); //GetMj5804To5848(RetNo, Prv); //20200411
    Tv[7]:= MaxR(0, Tv[1] - Tv[6]);
    Tv[10]:= MinR(Tv[13], Tv[7]);
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure S11MJBC(RetNo: Integer; FName: string; FNo: Integer; Prv: string);
var
  i, S11FNo, PrvTaxFNo, T2202FNo: Integer;
  S11PrvFNo: Integer;
begin
  InitPrvConstants('BC');
  PrvTaxFNo:= GetFormNo(Prv + '428');
  S11PrvFNo:= GetFormNo('S11PRV');
  LoadTv(RetNo, FName, FNo);

  With Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    S11FNo:= GetFormNo('S11');
    T2202FNo:= GetFormNo('T2202');
    Tv[13]:= Vl(FetchElmFNo(RetNo, S11FNo, 13));
    Tv[1]:= Vl(FetchElmFNo(RetNo, S11FNo, 33));
    Tv[4]:= Tv[13] + Tv[1];

    if (Ret[retno].LNN[26000] <= 49279) then //20251125 Igor
      Tv[5]:= Ret[RetNo].Lnn[26000]
    else
    begin
      Tv[2]:= Vl(FetchElm(RetNo, 'BCMJ', 32));
      Tv[5]:= Tv[2] / 0.0506; //20251125 Igor
    end;

    Tv[6]:= Vl(FetchElm(RetNo, 'T2203', 141));
    Tv[16]:= MaxR(0, Tv[5] - Tv[6]);
    Tv[17]:= MinR(Tv[13], Tv[16]);
    Tv[18]:= Tv[17];
    Tv[19]:= MaxR(0, Tv[16] - Tv[17]);
    Tv[8]:= MinR(Tv[1], Tv[19]);
    Tv[21]:= Tv[18] + Tv[8];
    Tv[22]:= Tv[1];
    Tv[23]:= Tv[8];
    Tv[24]:= MaxR(0, Tv[22] - Tv[23]);
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure S11MJYT(RetNo: Integer; FName: string; FNo: Integer; Prv: string);
var
  i, S11FNo, PrvTaxFNo, T2202FNo: Integer;
  S11PrvFNo: Integer;
begin
  InitPrvConstants('YT');
  PrvTaxFNo:= GetFormNo(Prv + '428');
  S11PrvFNo:= GetFormNo('S11PRV');
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    S11FNo:= GetFormNo('S11');
    T2202FNo:= GetFormNo('T2202');
    //20240503 Tv[13]:= Vl(FetchElmFNo(RetNo, S11FNo, 13)); //20180402  //cf from last year
    Tv[1]:= Vl(FetchElmFNo(RetNo, S11FNo, 1));
    Tv[2]:= Vl(FetchElmFNo(RetNo, S11FNo, 2));
    Tv[4]:= Tv[1] + Tv[2];
    Tv[3]:= Tv[4];
    Tv[9]:= Tv[13] + Tv[3];

    if (Ret[retno].LNN[26000] <= 57375) then //20251128 Igor
      Tv[5]:= Ret[RetNo].Lnn[26000]
    else
    begin
      Tv[11]:= Vl(FetchElm(RetNo, 'YTMJ', 30)); //line 8 of xxMJ
      Tv[5]:= Tv[11] / 0.064; //20251128 Igor
    end;

    Tv[6]:= Vl(FetchElm(RetNo, 'T2203', 143));
    Tv[7]:= MaxR(0, Tv[5] - Tv[6]);
    Tv[17]:= MinR(Tv[13], Tv[7]);
    Tv[18]:= Tv[17];
    Tv[19]:= MaxR(0, Tv[7] - Tv[17]);
    Tv[8]:= MinR(Tv[3], Tv[19]);
    Tv[21]:= Tv[18] + Tv[8];
    Tv[22]:= Tv[3];
    Tv[23]:= Tv[8];
    Tv[24]:= MaxR(0, Tv[22] - Tv[23]);
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure S11MJNT(RetNo: Integer; FName: string; FNo: Integer; Prv: string);
var
  i, S11FNo, PrvTaxFNo, T2202FNo: Integer;
  S11PrvFNo: Integer;
begin
  InitPrvConstants('NT');
  PrvTaxFNo:= GetFormNo(Prv + '428');
  S11PrvFNo:= GetFormNo('S11PRV');
  // bring from the generic S11Prv
  // for i:=1 to 50 do Begin StroreElm(RetNo,FNo,i,FetchElmFNo(RetNo,S11PrvFNo,i);
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    S11FNo:= GetFormNo('S11');
    T2202FNo:= GetFormNo('T2202');
    Tv[13]:= Vl(FetchElmFNo(RetNo, S11FNo, 13));
    Tv[1]:= Vl(FetchElmFNo(RetNo, S11FNo, 1));
    Strings[15]:= FetchElmFNo(RetNo, S11FNo, 35); // b

    if (MyStrToInt(Strings[15]) > 12) then Strings[15]:= '12';

    if Prv.Equals('YT') then
    begin
      Strings[15]:= '';
      Strings[33]:= '';
    end;

    Strings[39]:= '';
    Strings[40]:= '';
    Strings[33]:= AllTrim(IntToStr(PrvConstant[RY].PrvPartEducPerMonth));

    if (FetchElm(RetNo, S11FNo, 31) > '') then  Strings[15]:= '';

    Tv[14]:= MyStrToInt(Strings[15]) * (MyStrToInt(Strings[33]));
    Strings[12]:= FetchElmFNo(RetNo, S11FNo, 42);
    Strings[34]:= AllTrim(IntToStr(PrvConstant[RY].PrvEducPerMonth));

    if (MyStrToInt(Strings[12]) > 12) then Strings[12]:= '12';
    if (FetchElm(RetNo, S11FNo, 31) > '') then Strings[12]:= FetchElmFNo(RetNo, S11FNo, 35);

    Tv[2]:= MyStrToInt(Strings[12]) * (MyStrToInt(Strings[34]));
    Tv[3]:= Tv[1] + Tv[14] + Tv[2];
    Tv[16]:= Tv[3];
    Tv[4]:= Tv[13] + Tv[16];

    if (Ret[retno].LNN[26000] <= 51964) then //20251128 Igor
      Tv[5]:= Ret[RetNo].Lnn[26000]
    else
    begin
      Tv[9]:= Vl(FetchElm(RetNo, 'NTMJ', 30));  //line 8 of xxMJ
      Tv[5]:= Tv[1] / 0.059; //20251128 Igor
    end;

    Tv[6]:= Vl(FetchElm(RetNo, 'T2203', 143));
    Tv[7]:= MaxR(0, Tv[5] - Tv[6]);
    Tv[17]:= MinR(Tv[13], Tv[7]);
    Tv[18]:= Tv[17];
    Tv[19]:= MaxR(0, Tv[7] - Tv[17]);
    Tv[8]:= MinR(Tv[16], Tv[19]);
    Tv[21]:= Tv[18] + Tv[8];
    Tv[22]:= MinR(5000, Tv[16]);
    Tv[23]:= Tv[8];
    Tv[24]:= MaxR(0, Tv[22] - Tv[23]);
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure S11MJNU(RetNo: Integer; FName: string; FNo: Integer; Prv: string);
var
  i, S11FNo, PrvTaxFNo, T2202FNo: Integer;
  S11PrvFNo: Integer;
begin
  InitPrvConstants('NU');
  PrvTaxFNo:= GetFormNo(Prv + '428');
  S11PrvFNo:= GetFormNo('S11PRV');
  // bring from the generic S11Prv
  // for i:=1 to 50 do Begin StroreElm(RetNo,FNo,i,FetchElmFNo(RetNo,S11PrvFNo,i);
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    S11FNo:= GetFormNo('S11');
    T2202FNo:= GetFormNo('T2202');
    //20240504 Tv[13]:= Vl(FetchElmFNo(RetNo, S11FNo, 13)); //20180402  //cf from last year
    Tv[1]:= Vl(FetchElmFNo(RetNo, S11FNo, 1));
    Strings[15]:= FetchElmFNo(RetNo, S11FNo, 35); // b

    if (MyStrToInt(Strings[15]) > 12) then Strings[15]:= '12';

    Strings[39]:= '';
    Strings[40]:= '';
    Strings[33]:= AllTrim(IntToStr(PrvConstant[RY].PrvPartEducPerMonth));

    if Prv.Equals('NU') then Strings[33]:= '120';
    if (FetchElm(RetNo, S11FNo, 31) > '') then Strings[15]:= '';

    Tv[37]:= MyStrToInt(Strings[15]) * (MyStrToInt(Strings[33]));

    if Prv.Equals('NU') then
    begin
      Strings[39]:= Strings[15];
      Strings[40]:= '20';
    end;

    Tv[41]:= MyStrToInt(Strings[39]) * (MyStrToInt(Strings[40]));
    Tv[42]:= Tv[37] + Tv[41];
    Tv[14]:= Tv[42];
    Strings[12]:= FetchElmFNo(RetNo, S11FNo, 42);
    Strings[34]:= AllTrim(IntToStr(PrvConstant[RY].PrvEducPerMonth));

    if (MyStrToInt(Strings[12]) > 12) then Strings[12]:= '12';
    if Prv.Equals('NU') then Strings[34]:= '400';
    if (FetchElm(RetNo, S11FNo, 31) > '') then Strings[12]:= FetchElmFNo(RetNo, S11FNo, 35);

    Tv[45]:= MyStrToInt(Strings[12]) * (MyStrToInt(Strings[34]));

    Strings[44]:= '';
    Strings[43]:= '';

    if Prv.Equals('NU') then
    begin
      Strings[44]:= Strings[12];
      Strings[43]:= '65';
    end;

    Tv[46]:= MyStrToInt(Strings[44]) * (MyStrToInt(Strings[43]));
    Tv[47]:= Tv[45] + Tv[46];
    Tv[2]:= Tv[47];
    Strings[26]:= FetchElmFNo(RetNo, S11FNo, 26);
    Tv[3]:= Tv[1] + Tv[14] + Tv[2];
    Tv[16]:= Tv[3];
    Tv[4]:= Tv[13] + Tv[16];

    if (Ret[retno].LNN[26000] <= 54707) then //20251125 Igor
      Tv[5]:= Ret[RetNo].Lnn[26000]
    else
    begin
      Tv[9]:= Vl(FetchElm(RetNo, 'NuMJ', 30));
      Tv[5]:= Tv[9] / 0.04; //20251125 Igor
    end;

    Tv[7]:= MaxR(0, Tv[5] - Tv[6]);
    Tv[17]:= MinR(Tv[13], Tv[7]);
    Tv[18]:= Tv[17];
    Tv[19]:= MaxR(0, Tv[7] - Tv[17]);
    Tv[8]:= MinR(Tv[16], Tv[19]);
    Tv[21]:= Tv[18] + Tv[8];
    Tv[22]:= MinR(5000, Tv[16]);
    Tv[23]:= Tv[8];
    Tv[24]:= MaxR(0, Tv[22] - Tv[23]);
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20251125 Igor <<<

Procedure S11MJNR(RetNo: Integer; FName: string; FNo: Integer; Prv: String);
// 20180324
var
  i, S11FNo, PrvTaxFNo, T2202FNo: Integer;
  S11PrvFNo: Integer;
Begin
  InitPrvConstants('NR');  //???
  PrvTaxFNo := GetFormNo(Prv + '428');

  S11PrvFNo := GetFormNo('S11PRV');
  // bring from the generic S11Prv
  // for i:=1 to 50 do Begin StroreElm(RetNo,FNo,i,FetchElmFNo(RetNo,S11PrvFNo,i);

  LoadTv(RetNo, FName, FNo);
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    // Copy from federal  20091121
    S11FNo := GetFormNo('S11');
    T2202FNo := GetFormNo('T2202'); // 20180227
   // Frm[FNo].Strings[31] := PrvLong[GetPrvIndex(ret[RetNo].Province)];
   // Frm[FNo].Strings[32] := GetS11PrvHeader(RetNo);

    Tv[13]:= Vl(FetchElmFNo(RetNo, S11FNo, 13)); //20180402  //cf from last year
    Tv[1] := Vl(FetchElmFNo(RetNo, S11FNo, 1));
    // 20180205
    With ret[RetNo].Frm[FNo] do
    Begin
      // part time
      Strings[15] := FetchElmFNo(RetNo, S11FNo, 35); // b
      If MyStrToInt(Strings[15]) > 12 then Strings[15] := '12';
      Strings[39] := '';
      Strings[40] := '';
      Strings[33] := AllTrim(IntToStr(PrvConstant[RY].PrvPartEducPerMonth));

      if FetchElm(RetNo, S11FNo, 31) > '' then
        Strings[15] := ''; // makeit full time //20189211
      Tv[37] := MyStrToInt(Strings[15]) * (MyStrToInt(Strings[33]));


      Tv[41] := MyStrToInt(Strings[39]) * (MyStrToInt(Strings[40]));
      Tv[42] := Tv[37] + Tv[41];
      Tv[14] := Tv[42];

      // ---------Full time
      Strings[12] := FetchElmFNo(RetNo, S11FNo, 42);
      If MyStrToInt(Strings[12]) > 12 then
        Strings[12] := '12';
      Strings[34] := AllTrim(IntToStr(PrvConstant[RY].PrvEducPerMonth));

      if FetchElm(RetNo, S11FNo, 31) > '' then
        Strings[12] := FetchElmFNo(RetNo, S11FNo, 35);
      // prt time months to full time //20180211
      Tv[45] := MyStrToInt(Strings[12]) * (MyStrToInt(Strings[34]));

      Strings[44] := ''; // Strings[12];
      Strings[43] := ''; // AllTrim(IntToStr(PrvConstant[RY].PrvEducPerMonth));
      Tv[46] := MyStrToInt(Strings[44]) * (MyStrToInt(Strings[43]));
      Tv[47] := Tv[45] + Tv[46];
      Tv[2] := Tv[47];
      Strings[26] := FetchElmFNo(RetNo, S11FNo, 26); // 20120204    //sin?
    end;
    Tv[3] := Tv[1] + Tv[14] + Tv[2];
    Tv[16] := Tv[3];
    Tv[4] := Tv[13] + Tv[16];
    If FullTONIProvince(RetNo) then
    begin
      PrvTaxFNo := GetFormNo(WhichTaxForm(RetNo, Prv));
      Tv[5] := GetTxblForPrvS11(RetNo, Prv, PrvConstant[RY].PrvBracket1, Vl(PrvConstant[RY].PrvRate1));
      Tv[6]:=GetMj5804To5848(RetNo, Prv); //20200411
    end;

    Tv[7] := MaxR(0, Tv[5] - Tv[6]);
    Tv[17] := MinR(Tv[13], Tv[7]);
    Tv[18] := Tv[17];
    Tv[19] := MaxR(0, Tv[7] - Tv[17]);
    Tv[8] := MinR(Tv[16], Tv[19]);

    If UpperCase(Frm[FNo].Strings[28]) = 'Y' then
      Tv[8] := Tv[29];
    If Tv[29] > MinR(Tv[16], Tv[19]) then
      Tv[8] := MinR(Tv[16], Tv[19]);

    Tv[21] := Tv[18] + Tv[8];

    Tv[22] := Tv[4]; // MinR(Tv[16],Tv[35]);
    Tv[23] := Tv[21]; // Tv[8];
    Tv[24] := MaxR(0, Tv[22] - Tv[23]);

    Tv[35] := PrvConstant[RY].PrvMaxEducXfer;
    Tv[9] := MinR(Tv[35], Tv[16]); // Tv[4];
    Tv[20] := Tv[8]; // Tv[21];  Feb 12, 2003
    Tv[30] := MaxR(0, Tv[9] - Tv[20]);

    If Tv[10] > Tv[30] then
      Tv[10] := Tv[30];
    If UpperCase(Frm[FNo].Strings[36]) = 'Y' then
    begin
      If UpperCase(Frm[FNo].Strings[38]) <> 'N' then
        Tv[10] := Tv[30];
      If Frm[FNo].Strings[26] > '' then
        Frm[FNo].Strings[25] := 'N';
    end
    else
    begin
      Tv[10] := 0;
      Frm[FNo].Strings[25] := 'N';
      Frm[FNo].Strings[26] := '';
    end;

    Tv[11] := MaxR(0, Tv[24] - Tv[10]);
  end;
  SaveTv(RetNo, FName, FNo);
End;


Function GetSpTaxFormName(RetNo: Integer): String;
Var
  SpRetNo: Integer;
  Prv: String;
Begin
  Result := '';
  If ret[RetNo].CouplingSw = True then
  begin
    SpRetNo := GetSpRetNo(RetNo);
    if SpRetNo > 0 then
    Begin
      Prv := ret[SpRetNo].Province;
      Result := Prv + '428';
    end;
  end;
End;

Procedure CalcLine5612(RetNo, T2203FNo: Integer); // Elig dep NI
Var
  EligInc: Real;
Begin
  with ret[RetNo].Frm[T2203FNo] do
  begin
    EligInc := Vl(FetchElm(RetNo, 'S5', 20));
    If (Vl(GetMJAlloc(RetNo, 'NL')) > 0) Or (Vl(GetMJAlloc(RetNo, 'PE')) > 0) Or
      (Vl(GetMJAlloc(RetNo, 'NS')) > 0) then
      Tv[421] := EligInc; // StoreElm(RetNo,T2203FNo,421,FetchElm(RetNo,'S5',20));

    If (Vl(GetMJAlloc(RetNo, 'SK')) > 0) Or (Vl(GetMJAlloc(RetNo, 'AB')) > 0) Or
      (Vl(GetMJAlloc(RetNo, 'BC')) > 0) then
      Tv[601] := EligInc; // StoreElm(RetNo,T2203FNo,601,FetchElm(RetNo,'S5',20));

    If (Vl(GetMJAlloc(RetNo, 'NB')) > 0) Or (Vl(GetMJAlloc(RetNo, 'ON')) > 0) Or
      (Vl(GetMJAlloc(RetNo, 'MB')) > 0) then
      Tv[501] := EligInc; // StoreElm(RetNo,T2203FNo,501,FetchElm(RetNo,'S5',20));

    If (Vl(GetMJAlloc(RetNo, 'YT')) > 0) Or (Vl(GetMJAlloc(RetNo, 'NT')) > 0) Or
      (Vl(GetMJAlloc(RetNo, 'NU')) > 0) then
      Tv[801] := EligInc; // StoreElm(RetNo,T2203FNo,801,FetchElm(RetNo,'S5',20));
  end;
End;

//jz//CERTMJ2024//20250509

Procedure ABMJWS(RetNo: Integer; FName: string; FNo: Integer);
begin

  LoadTv(RetNo, FName, FNo);
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
  end; //end with
  SaveTv(RetNo, FName, FNo);

end;


Procedure BCMJWS(RetNo: Integer; FName: string; FNo: Integer);
begin

  LoadTv(RetNo, FName, FNo);
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
  end; //end with
  SaveTv(RetNo, FName, FNo);

end;


Procedure MBMJWS(RetNo: Integer; FName: string; FNo: Integer);
begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
  end; //end with
  SaveTv(RetNo, FName, FNo);


end;


Procedure NSMJWS(RetNo: Integer; FName: string; FNo: Integer);
begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
  end; //end with
  SaveTv(RetNo, FName, FNo);


end;


Procedure NBMJWS(RetNo: Integer; FName: string; FNo: Integer);
begin

  LoadTv(RetNo, FName, FNo);
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
  end; //end with
  SaveTv(RetNo, FName, FNo);

end;


Procedure NLMJWS(RetNo: Integer; FName: string; FNo: Integer);
begin

  LoadTv(RetNo, FName, FNo);
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
  end; //end with
  SaveTv(RetNo, FName, FNo);

end;


Procedure NTMJWS(RetNo: Integer; FName: string; FNo: Integer);
begin

  LoadTv(RetNo, FName, FNo);
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
  end; //end with
  SaveTv(RetNo, FName, FNo);

end;


Procedure NUMJWS(RetNo: Integer; FName: string; FNo: Integer);
begin

  LoadTv(RetNo, FName, FNo);
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
  end; //end with
  SaveTv(RetNo, FName, FNo);

end;


Procedure ONMJWS(RetNo: Integer; FName: string; FNo: Integer);
begin

  LoadTv(RetNo, FName, FNo);
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
  end; //end with
  SaveTv(RetNo, FName, FNo);

end;


Procedure PEMJWS(RetNo: Integer; FName: string; FNo: Integer);
begin

  LoadTv(RetNo, FName, FNo);
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
  end; //end with
  SaveTv(RetNo, FName, FNo);

end;


Procedure SKMJWS(RetNo: Integer; FName: string; FNo: Integer);
begin

  LoadTv(RetNo, FName, FNo);
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
  end; //end with
  SaveTv(RetNo, FName, FNo);

end;


Procedure YTMJWS(RetNo: Integer; FName: string; FNo: Integer);
begin

  LoadTv(RetNo, FName, FNo);
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
  end; //end with
  SaveTv(RetNo, FName, FNo);

end;


procedure CalcPrvTaxAndCreditsMJ(RetNo: Integer);
Const
  ProvArray : array[1..12] of string = ('AB','BC','MB','NB','NL','NS','NT','NU','ON','PE','SK','YT');
var
  AgeDedFNo:integer;

  i,T2203FNo,Disab18FNo,SpRetNo,PtransfFNo,CarePrvFNo,S5PrvFNo: integer;
  S2MjFormNm,S11MjFormNm : String; // 20180325
  X:REAL;
begin

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

    //jz//20260325//MJCERT2025 - could/should be put in some kinda loop but leave for now
    {
    for  i:= Low(ProvArray) to High(ProvArray) do
    begin
      T2203Prov   := ProvArray[i];
      S2MjFormNm  := 'S2MJ'  + T2203Prov;
      S11MjFormNm := 'S11MJ' + T2203Prov;
      If vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
      begin
      end;
    end;
    }


    AgeDedFNo   := GetFormNo('AGEDED'); //jz//20260329//MJCERT2025v3 - set AgeDedFNo

    T2203Prov   := 'NL';
    S2MjFormNm  := 'S2MJ'  + T2203Prov;
    S11MjFormNm := 'S11MJ' + T2203Prov;
    If vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
    begin
      AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED'),T2203Prov); //jz//20260329//MJCERT2025v3 - T2203XXAgeDed populate like others
      T2203NLAgeDed := vl(FetchElm(RetNo, AgeDedFNo, 17));

      //AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED')); // 20180406  //t220516
      //if SpRetNo>0 then T2203NLAgeDed :=GetSpouseAgeDeductionForMJ(SpRetNo,T2203Prov); //20220516  //vl(FetchElm(RetNo, AgeDedFNo, 17));

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

      S11MJNL(RetNo, S11MjFormNm, GetFormNo(S11MjFormNm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 233, FetchElm(RetNo, S11MjFormNm, 21));
    end; // 20180314

    T2203Prov   := 'PE';
    S2MjFormNm  := 'S2MJ'  + T2203Prov;
    S11MjFormNm := 'S11MJ' + T2203Prov;
    If vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
    begin
      AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED'),T2203Prov); // 20180406
      T2203PEAgeDed := vl(FetchElm(RetNo, AgeDedFNo, 17));

      S5PRV(RetNo, 'S5PRV', GetFormNo('S5PRV'));
      // to get dependants etc //20180401
      Calc(RetNo, T2203Prov + '428'); // 20180401

      DISAB18(RetNo, 'DISAB18', Disab18FNo, T2203Prov);

      T2203PEDisab := MaxR(vl(FetchElmFNo(RetNo, Disab18FNo, 14)),vl(FetchElmFNo(RetNo, Disab18FNo, 24)));

      If SpRetNo > 0 then
        PE428(SpRetNo, T2203Prov + '428', GetFormNo(T2203Prov + '428'));
      // 20200410 Do the spouse's xx428

      {
      S2MJPE(RetNo, 'S2MJ' + T2203Prov, GetFormNo('S2MJ' + T2203Prov), T2203Prov); // 20180324
      T2203PESpousexfer := vl(FetchElm(RetNo, 'S2MJ' + T2203Prov, 19));
      S11MJPE(RetNo, S11MjFormNm, GetFormNo(S11MjFormNm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 234, FetchElm(RetNo, S11MjFormNm, 21));
      }
      //saveS2andS11MJAmounts()
      S2MJPE(RetNo, 'S2MJ' + T2203Prov, GetFormNo(S2MjFormNm),T2203Prov);         //jz//20260325//MJCERT2025 - ??? is GetFormNo('S2MJ' + T2203Prov) good enough in this case??
      T2203PESpousexfer := vl(FetchElm(RetNo,GetS2MjFNo(RetNo,T2203Prov) , 19));  //jz//20260325//MJCERT2025 - use GetS2MjFNo as 'S2MJ' + T2203Prov is not the correct form name / number gets wrong amount
      //StoreElm(RetNo, T2203FNo, XX,Formatfloat('#####.##',T2203XXSpousexfer));
      S11MJPE(RetNo, S11MjFormNm, GetFormNo(S11MjFormNm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 234, FetchElm(RetNo, S11MjFormNm, 21));

    end; // 20180314

    T2203Prov   := 'NS';
    S2MjFormNm  := 'S2MJ'  + T2203Prov;
    S11MjFormNm := 'S11MJ' + T2203Prov;
    If vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
    begin
      AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED'),T2203Prov); // 20180406
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

      {
      S2MJNS(RetNo, 'S2MJ' + T2203Prov, GetFormNo('S2MJ' + T2203Prov),T2203Prov); // 20180324     //20220528  transferS2MJtoS2MJxx(RetNo, T2203Prov); // 20190208
      T2203NSSpousexfer := vl(FetchElm(RetNo, 'S2MJ' + T2203Prov, 19));
      S11MJNS(RetNo, S11MjFormNm, GetFormNo(S11MjFormNm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 235, FetchElm(RetNo, S11MjFormNm, 21));
      }
      //saveS2andS11MJAmounts()
      S2MJNS(RetNo, 'S2MJ' + T2203Prov, GetFormNo(S2MjFormNm),T2203Prov);         //jz//20260325//MJCERT2025 - ??? is GetFormNo('S2MJ' + T2203Prov) good enough in this case??
      T2203NSSpousexfer := vl(FetchElm(RetNo,GetS2MjFNo(RetNo,T2203Prov) , 19));  //jz//20260325//MJCERT2025 - use GetS2MjFNo as 'S2MJ' + T2203Prov is not the correct form name / number gets wrong amount
      //StoreElm(RetNo, T2203FNo, XX,Formatfloat('#####.##',T2203XXSpousexfer));
      S11MJNS(RetNo, S11MjFormNm, GetFormNo(S11MjFormNm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 235, FetchElm(RetNo, S11MjFormNm, 21));

    end; // 20180314

    T2203Prov   := 'SK';
    S2MjFormNm  := 'S2MJ'  + T2203Prov;
    S11MjFormNm := 'S11MJ' + T2203Prov;
    If vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
    begin
      AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED'),T2203Prov);
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

      {
      S2MJSK(RetNo, 'S2MJ' + T2203Prov, GetFormNo('S2MJ' + T2203Prov),T2203Prov); // 20180324   //20220528  transferS2MJtoS2MJxx(RetNo, T2203Prov); // 20190208
      T2203SKSpousexfer := vl(FetchElm(RetNo, 'S2MJ' + T2203Prov, 19));
      S11MJSK(RetNo, S11MjFormNm, GetFormNo(S11MjFormNm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 239, FetchElm(RetNo, S11MjFormNm, 21));
      }
      //saveS2andS11MJAmounts()
      S2MJSK(RetNo, 'S2MJ' + T2203Prov, GetFormNo(S2MjFormNm),T2203Prov);         //jz//20260325//MJCERT2025 - ??? is GetFormNo('S2MJ' + T2203Prov) good enough in this case??
      T2203SKSpousexfer := vl(FetchElm(RetNo,GetS2MjFNo(RetNo,T2203Prov) , 19));  //jz//20260325//MJCERT2025 - use GetS2MjFNo as 'S2MJ' + T2203Prov is not the correct form name / number gets wrong amount
      //StoreElm(RetNo, T2203FNo, XX,Formatfloat('#####.##',T2203XXSpousexfer));
      S11MJSK(RetNo, S11MjFormNm, GetFormNo(S11MjFormNm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 239, FetchElm(RetNo, S11MjFormNm, 21));
    end; // 20180314

    T2203Prov   := 'AB';
    S2MjFormNm  := 'S2MJ'  + T2203Prov;
    S11MjFormNm := 'S11MJ' + T2203Prov;
    If vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
    begin
      AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED'),T2203Prov); // 20180406
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

      {
      S2MJAB(RetNo, 'S2MJ' + T2203Prov, GetFormNo('S2MJ' + T2203Prov), T2203Prov); // 20180324 //20220528  transferS2MJtoS2MJxx(RetNo, T2203Prov); // 20190208
      T2203ABSpousexfer := vl(FetchElm(RetNo, 'S2MJ' + T2203Prov, 19));
      S11MJAB(RetNo, S11MjFormNm, GetFormNo(S11MjFormNm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 240, FetchElm(RetNo, S11MjFormNm, 21));
      }
      //saveS2andS11MJAmounts()
      S2MJAB(RetNo, 'S2MJ' + T2203Prov, GetFormNo(S2MjFormNm),T2203Prov);         //jz//20260325//MJCERT2025 - ??? is GetFormNo('S2MJ' + T2203Prov) good enough in this case??
      T2203ABSpousexfer := vl(FetchElm(RetNo,GetS2MjFNo(RetNo,T2203Prov) , 19));  //jz//20260325//MJCERT2025 - use GetS2MjFNo as 'S2MJ' + T2203Prov is not the correct form name / number gets wrong amount
      //StoreElm(RetNo, T2203FNo, XX,Formatfloat('#####.##',T2203XXSpousexfer));
      S11MJAB(RetNo, S11MjFormNm, GetFormNo(S11MjFormNm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 240, FetchElm(RetNo, S11MjFormNm, 21));

    end; // 20180314

    T2203Prov   := 'BC';
    S2MjFormNm  := 'S2MJ'  + T2203Prov;
    S11MjFormNm := 'S11MJ' + T2203Prov;
    If vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
    begin
      AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED'),T2203Prov); // 20180406
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

      {
      S2MJBC(RetNo, 'S2MJ' + T2203Prov, GetFormNo('S2MJ' + T2203Prov), T2203Prov); // 20180324 // transferS2MJtoS2MJxx(RetNo, T2203Prov); // 20190208
      T2203BCSpousexfer := vl(FetchElm(RetNo, 'S2MJ' + T2203Prov, 19));
      S11MJBC(RetNo, S11MjFormNm, GetFormNo(S11MjFormNm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 241, FetchElm(RetNo, S11MjFormNm, 21));
      }
      //saveS2andS11MJAmounts()
      S2MJBC(RetNo, 'S2MJ' + T2203Prov, GetFormNo(S2MjFormNm),T2203Prov);         //jz//20260325//MJCERT2025 - ??? is GetFormNo('S2MJ' + T2203Prov) good enough in this case??
      T2203BCSpousexfer := vl(FetchElm(RetNo,GetS2MjFNo(RetNo,T2203Prov) , 19));  //jz//20260325//MJCERT2025 - use GetS2MjFNo as 'S2MJ' + T2203Prov is not the correct form name / number gets wrong amount
      //StoreElm(RetNo, T2203FNo, XX,Formatfloat('#####.##',T2203XXSpousexfer));
      S11MJBC(RetNo, S11MjFormNm, GetFormNo(S11MjFormNm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 241, FetchElm(RetNo, S11MjFormNm, 21));
    end; // 20180314

    T2203Prov   := 'NB';
    S2MjFormNm  := 'S2MJ'  + T2203Prov;
    S11MjFormNm := 'S11MJ' + T2203Prov;
    If vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
    begin
      AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED'),T2203Prov); // 20180406
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

      {
      S2MJNB(RetNo, 'S2MJ' + T2203Prov, GetFormNo('S2MJ' + T2203Prov),T2203Prov); // 20180324  //  transferS2MJtoS2MJxx(RetNo, T2203Prov); // 20190208
      T2203NBSpousexfer := vl(FetchElm(RetNo, 'S2MJ' + T2203Prov, 19));
      S11MJNB(RetNo, S11MjFormNm, GetFormNo(S11MjFormNm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 236, FetchElm(RetNo, S11MjFormNm, 21));
      }
      //saveS2andS11MJAmounts()
      S2MJNB(RetNo, 'S2MJ' + T2203Prov, GetFormNo(S2MjFormNm),T2203Prov);         //jz//20260325//MJCERT2025 - ??? is GetFormNo('S2MJ' + T2203Prov) good enough in this case??
      T2203NBSpousexfer := vl(FetchElm(RetNo,GetS2MjFNo(RetNo,T2203Prov) , 19));  //jz//20260325//MJCERT2025 - use GetS2MjFNo as 'S2MJ' + T2203Prov is not the correct form name / number gets wrong amount
      //StoreElm(RetNo, T2203FNo, XX,Formatfloat('#####.##',T2203XXSpousexfer));
      S11MJNB(RetNo, S11MjFormNm, GetFormNo(S11MjFormNm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 236, FetchElm(RetNo, S11MjFormNm, 21));
    end; // 20180314

    T2203Prov   := 'ON';
    S2MjFormNm  := 'S2MJ'  + T2203Prov;
    S11MjFormNm := 'S11MJ' + T2203Prov;
    If vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
    begin
      AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED'),T2203Prov); // 20180406
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

      {
      S2MJON(RetNo, 'S2MJ' + T2203Prov, GetFormNo('S2MJ' + T2203Prov),T2203Prov); // 20180324    //  transferS2MJtoS2MJxx(RetNo, T2203Prov); //20220528      // for i:=1 to 40 do Begin StoreElm(RetNo,'S2MJON',i,FetchElm(RetNo,'S2MJ#3',i));end;  //20190207 testing only
      T2203ONSpousexfer := vl(FetchElm(RetNo, 'S2MJ' + T2203Prov, 19));
      // StoreElm(RetNo,T2203FNo,517,FormatFloat('######.##',T2203ONSpouseXfer));   //20190205 not solved
      S11MJON(RetNo, S11MjFormNm, GetFormNo(S11MjFormNm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 237, FetchElm(RetNo, S11MjFormNm, 21));
      }
      //saveS2andS11MJAmounts()
      S2MJON(RetNo, 'S2MJ' + T2203Prov, GetFormNo(S2MjFormNm),T2203Prov);         //jz//20260325//MJCERT2025 - ??? is GetFormNo('S2MJ' + T2203Prov) good enough in this case??
      T2203ONSpousexfer := vl(FetchElm(RetNo,GetS2MjFNo(RetNo,T2203Prov) , 19));  //jz//20260325//MJCERT2025 - use GetS2MjFNo as 'S2MJ' + T2203Prov is not the correct form name / number gets wrong amount
      //StoreElm(RetNo, T2203FNo, XX,Formatfloat('#####.##',T2203XXSpousexfer));
      S11MJON(RetNo, S11MjFormNm, GetFormNo(S11MjFormNm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 237, FetchElm(RetNo, S11MjFormNm, 21));
    end; // 20180314

    T2203Prov   := 'MB';
    S2MjFormNm  := 'S2MJ'  + T2203Prov;
    S11MjFormNm := 'S11MJ' + T2203Prov;
    If vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
    begin
      AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED'),T2203Prov); // 20180406
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

      {
      S2MJMB(RetNo, 'S2MJ' + T2203Prov, GetFormNo('S2MJ' + T2203Prov),T2203Prov); // 20180324      //20220528 transferS2MJtoS2MJxx(RetNo, T2203Prov); // 20190208
      T2203MBSpousexfer := vl(FetchElm(RetNo, 'S2MJ' + T2203Prov, 19));
      S11MJMB(RetNo, S11MjFormNm, GetFormNo(S11MjFormNm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 238, FetchElm(RetNo, S11MjFormNm, 21));
      }
      //saveS2andS11MJAmounts()
      S2MJMB(RetNo, 'S2MJ' + T2203Prov, GetFormNo(S2MjFormNm),T2203Prov);         //jz//20260325//MJCERT2025 - ??? is GetFormNo('S2MJ' + T2203Prov) good enough in this case??
      T2203MBSpousexfer := vl(FetchElm(RetNo,GetS2MjFNo(RetNo,T2203Prov) , 19));  //jz//20260325//MJCERT2025 - use GetS2MjFNo as 'S2MJ' + T2203Prov is not the correct form name / number gets wrong amount
      //StoreElm(RetNo, T2203FNo, XX,Formatfloat('#####.##',T2203XXSpousexfer));
      S11MJMB(RetNo, S11MjFormNm, GetFormNo(S11MjFormNm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 238, FetchElm(RetNo, S11MjFormNm, 21));
    end; // 20180314

    T2203Prov   := 'YT';
    S2MjFormNm  := 'S2MJ'  + T2203Prov;
    S11MjFormNm := 'S11MJ' + T2203Prov;
    If vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
    begin
      //jz//20260329//MJCERT2025v3 - YT does not calc age amount
      //AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED'),T2203Prov); // 20180406
      //T2203YTAgeDed := vl(FetchElm(RetNo, AgeDedFNo, 17));
      T2203YTAgeDed := MinR(9028, Ret[RetNo].Lnn[30100]); //jz//20260329//MJCERT2025v3 - should this be in AGEDED??
                                                          //                           - same with the age amount in YT428


      S5PRV(RetNo, 'S5PRV', GetFormNo('S5PRV'));
      // to get dependants etc //20180401
      Calc(RetNo, T2203Prov + '428'); // 20180401

      DISAB18(RetNo, 'DISAB18', Disab18FNo, T2203Prov);
      T2203YTDisab := MaxR(vl(FetchElmFNo(RetNo, Disab18FNo, 14)),
        vl(FetchElmFNo(RetNo, Disab18FNo, 24)));

      If SpRetNo > 0 then
        YT428(SpRetNo, T2203Prov + '428', GetFormNo(T2203Prov + '428'));
      // 20200410 Do the spouse's xx428

      {
      S2MJYT(RetNo, 'S2MJ' + T2203Prov, GetFormNo('S2MJ' + T2203Prov), T2203Prov); // 20180324     //20220528  transferS2MJtoS2MJxx(RetNo, T2203Prov); // 20190208
      T2203YTSpousexfer := vl(FetchElm(RetNo, 'S2MJ' + T2203Prov, 19));
      S11MJYT(RetNo, S11MjFormNm, GetFormNo(S11MjFormNm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 242, FetchElm(RetNo, S11MjFormNm, 21));
      }
      //saveS2andS11MJAmounts()
      S2MJYT(RetNo, 'S2MJ' + T2203Prov, GetFormNo(S2MjFormNm),T2203Prov);         //jz//20260325//MJCERT2025 - ??? is GetFormNo('S2MJ' + T2203Prov) good enough in this case??
      T2203YTSpousexfer := vl(FetchElm(RetNo,GetS2MjFNo(RetNo,T2203Prov) , 19));  //jz//20260325//MJCERT2025 - use GetS2MjFNo as 'S2MJ' + T2203Prov is not the correct form name / number gets wrong amount
      //StoreElm(RetNo, T2203FNo, XX,Formatfloat('#####.##',T2203XXSpousexfer));
      S11MJYT(RetNo, S11MjFormNm, GetFormNo(S11MjFormNm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 242, FetchElm(RetNo, S11MjFormNm, 21));
    end; // 20180314

    T2203Prov     := 'NT';
    S2MjFormNm    := 'S2MJ' + T2203Prov;
    S11MjFormNm   := 'S11MJ' + T2203Prov;
    If vl(GetMJAlloc(RetNo, T2203Prov)) > 0 then
    begin
      AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED'),T2203Prov); // 20180406
      T2203NTAgeDed := vl(FetchElm(RetNo, AgeDedFNo, 17));

      S5PRV(RetNo, 'S5PRV', GetFormNo('S5PRV'));
      // to get dependants etc //20180401
      Calc(RetNo, T2203Prov + '428'); // 20180401

      DISAB18(RetNo, 'DISAB18', Disab18FNo, T2203Prov);
      T2203NTDisab := MaxR(vl(FetchElmFNo(RetNo, Disab18FNo, 14)),
        vl(FetchElmFNo(RetNo, Disab18FNo, 24)));

      //20220528  transferS2MJtoS2MJxx(RetNo, T2203Prov); // 20190208

      //saveS2andS11MJAmounts()
      S2MJNT(RetNo, 'S2MJ' + T2203Prov, GetFormNo(S2MjFormNm),T2203Prov);         //jz//20260325//MJCERT2025 - ??? is GetFormNo('S2MJ' + T2203Prov) good enough in this case??
      T2203NTSpousexfer := vl(FetchElm(RetNo,GetS2MjFNo(RetNo,T2203Prov) , 19));  //jz//20260325//MJCERT2025 - use GetS2MjFNo as 'S2MJ' + T2203Prov is not the correct form name / number gets wrong amount
      StoreElm(RetNo, T2203FNo, 843,Formatfloat('#####.##',T2203NTSpousexfer));   //20240520
      S11MJNT(RetNo, S11MjFormNm, GetFormNo(S11MjFormNm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 243, FetchElm(RetNo, S11MjFormNm, 21));

    end; // 20180314

    T2203Prov   := 'NU';
    S2MjFormNm  := 'S2MJ'  + T2203Prov;
    S11MjFormNm := 'S11MJ' + T2203Prov;
    If (vl(GetMJAlloc(RetNo, T2203Prov)) > 0) Or
      (ret[RetNo].Province = T2203Prov)
    // should be in all of them //???? //2''22030401
    then
    begin
      AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED'),T2203Prov); // 20180406
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

      {
      S2MJNU(RetNo, 'S2MJ' + T2203Prov, GetFormNo('S2MJ' + T2203Prov),T2203Prov); // 20180324
      T2203NUSpousexfer := vl(FetchElm(RetNo, 'S2MJ' + T2203Prov, 19));
      S11MJNU(RetNo, S11MjFormNm, GetFormNo(S11MjFormNm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 244, FetchElm(RetNo, S11MjFormNm, 21));
      }
      //saveS2andS11MJAmounts()
      S2MJNU(RetNo, 'S2MJ' + T2203Prov, GetFormNo(S2MjFormNm),T2203Prov);         //jz//20260325//MJCERT2025 - ??? is GetFormNo('S2MJ' + T2203Prov) good enough in this case??
      T2203NUSpousexfer := vl(FetchElm(RetNo,GetS2MjFNo(RetNo,T2203Prov) , 19));  //jz//20260325//MJCERT2025 - use GetS2MjFNo as 'S2MJ' + T2203Prov is not the correct form name / number gets wrong amount
      //StoreElm(RetNo, T2203FNo, XX,Formatfloat('#####.##',T2203XXSpousexfer));
      S11MJNU(RetNo, S11MjFormNm, GetFormNo(S11MjFormNm), T2203Prov);
      StoreElm(RetNo, T2203FNo, 244, FetchElm(RetNo, S11MjFormNm, 21));
    end; // 20180314



    //jz//20260329//MJCERT2025v3 - make sure data on form is the assinged province
    T2203Prov   := FetchElm(RetNo, AgeDedFNo, 9); //get prov showing on form
    if (IsMultJurisdiction(RetNo)) and (ret[RetNo].Province <> T2203Prov) then
      AGEDED(RetNo, 'AGEDED', GetFormNo('AGEDED'),ret[RetNo].Province); //call one last time with assinged province




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


end;
end.
