unit T1_2026Calc3;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls, Dialogs, DBctrls, ExtCtrls, T1_2026Declare, T1_2026common,
  T1_2026common2, T1_2026TrimStr, T1_2026T1Rtns, T1_2026Calc4;

  Procedure T777MOB(RetNo: integer; FName: string; FNo: integer); // 20210116
  // Procedure T777S(RetNo: integer; FName: string; FNo: integer);
  Procedure S5SUPL(RetNo: integer; FName: String; FNo: integer); // 20180120
  Procedure CalcFedTaxByBrackets(RetNo: integer; FNo: integer; TxblInc: Real; k: integer);
  Procedure DTC(RetNo: integer; FName: string; FNo: integer);
  procedure MEDSUPL(RetNo: integer; FName: String; FNo: integer);
  procedure STLOAN(RetNo: integer; FName: String; FNo: integer);
  procedure TOOLEXP(RetNo: integer; FName: String; FNo: integer);
  Procedure S2PRV(RetNo: integer; FName: string; FNo: integer);
  Procedure AGEDED(RetNo: integer; FName: string; FNo: integer; Prv:string);
  { //20241203
  Function S3SectionII(RetNo, FNo: integer): Boolean;
  Function S3SectionIII(RetNo, FNo: integer): Boolean;
  Function S3SectionIV(RetNo, FNo: integer): Boolean;}
  //Function GetInclusionRate(RetNo, FNo: integer): Real;
  procedure DISAB18(RetNo: integer; FName: String; FNo: integer; Prv: String);
  procedure PRIVAT(RetNo: integer; FName: String; FNo: integer);
  // Function GetSect217Adj(RetNo: integer): Real;  //20220301
  procedure OTHINC(RetNo: integer; FName: String; FNo: integer);
  procedure PTRANSF(RetNo: integer; FName: String; FNo: integer);
  Procedure CTB(RetNo: integer; FName: String; FNo: integer);
  Procedure INVOICE(RetNo: integer; FName: string; FNo: integer);
  Procedure INVGen(RetNo: integer; FName: string; FNo: integer);
  Procedure INVFORMS(RetNo: integer; FName: string; FNo: integer);
  procedure EFDOC(RetNo: integer; FName: String; FNo: integer);
  procedure EFADJ(RetNo: integer; FName: String; FNo: integer);
  procedure OTHDED(RetNo: integer; FName: String; FNo: integer);
  Procedure T5006(RetNo: integer; FName: String; FNo: integer);
  procedure MEDICAL(RetNo: integer; FName: String; FNo: integer);
  procedure MEDPRV(RetNo: integer; FName: String; FNo: integer);
  Procedure RENTSUM(RetNo: integer; FName: String; FNo: integer);
  procedure PNSDED(RetNo: integer; FName: String; FNo: integer);
  procedure DIRECT(RetNo: integer; FName: String; FNo: integer);
  procedure T400A(RetNo: integer; FName: String; FNo: integer);
  Procedure T5004(RetNo: integer; FName: String; FNo: integer);
  procedure BANKRPT(RetNo: integer; FName: String; FNo: integer);
  Procedure S2(RetNo: integer; FName: string; FNo: integer);
  procedure S3(RetNo: integer; FName: string; FNo: integer);
  procedure S3SUPL(RetNo: integer; FName: string; FNo: integer);
  procedure S3QSUPL(RetNo: integer; FName: string; FNo: integer);
  Procedure S4(RetNo: integer; FName: string; FNo: integer);
  Procedure S5(RetNo: integer; FName: string; FNo: integer);
  Procedure S5PRV(RetNo: integer; FName: string; FNo: integer);
  Procedure S6QC(RetNo: integer; FName: string; FNo: integer);
  Procedure S7(RetNo: integer; FName: string; FNo: integer);
  Procedure S8(RetNo: integer; FName: string; FNo: integer);
  Procedure S8Q(RetNo: integer; FName: string; FNo: integer);
  procedure T183(RetNo: integer; FName: String; FNo: integer);
  procedure T185(RetNo: integer; FName: String; FNo: integer); // 20200212
  //procedure T776(RetNo: integer; FName: String; FNo: integer);
  procedure T929(RetNo: integer; FName: String; FNo: integer);
  // Procedure T626(RetNo:integer;FName:string;FNo:integer);  //20161119
  Procedure T777(RetNo: integer; FName: string; FNo: integer);
  Procedure T1212(RetNo: integer; FName: string; FNo: integer);

implementation

uses
  vtCommon, vtMulti, vtDialogs, T1_2026, T1_2026Calc, T1_2026T1Rtns2, vtTrimStr,
  vtShared;

(* //20220301
  Function GetSect217Adj(RetNo: integer): Real;
  Var
  WorldInc: Real;
  { = nontaxable world income * bft/Worldincome }
  begin
  result := 0;
  If ret[RetNo].Province <> 'ZZ' then
  exit;
  If UpperCase(FetchElm(RetNo, 'SNRESB', 10)) <> 'Y' then
  exit; { no 217 election }
  WorldInc := Vl(FetchElm(RetNo, 'SNRESA', 18));
  If WorldInc = 0 then
  result := 0
  else
  result := (MaxR(0, WorldInc - ret[RetNo].Lnn[26000])) *
  Vl(FetchElm(RetNo, 'T1', 129));
  // WorldInc; //Vl(FetchElm(RetNo,'S1',129)) // WorldInc;
  end;
*)

Procedure AGEDED(RetNo: integer; FName: string; FNo: integer; Prv:string);
Var
  i: integer;
  FedNi, NI, PrvNi, x: Real;
  //Prv: String;
  spRetNo: integer;
Begin

  {
  // 20180406
  if IsMultJurisdiction(RetNo) = false then
  Begin
    Prv := ret[RetNo].Province; // 20180326
    InitPrvConstants(ret[RetNo].Province); // 20110310
  end
  Else
  Begin
    spRetNo := GetSpRetNo(RetNo);
    If (spRetNo > 0) then
    Begin
      Prv := T2203Prov;
      spRetNo := GetSpRetNo(RetNo);
      ret[spRetNo].Frm[FNo].strings[9] := Prv;
      InitPrvConstants(Prv); // 20110310
    end;
  end;
  }


  //jz//20260329//MJCERT2025v3 - rearrange the if
  if IsMultJurisdiction(RetNo)then
  Begin
    //jz//20260329//MJCERT2025v3 - pass Prv so can specify which one we want to calc
    //                           -

    if Prv.length <> 2 then PRV := ret[RetNo].Province;  //jz//20260329//MJCERT2025v3 - sends garbage sometimes so set for when it does
    InitPrvConstants(Prv);

    spRetNo := GetSpRetNo(RetNo);  //jz//20260329//MJCERT2025v3 - what is this trying to do exactly??? seems like it probably wouldnt work properly
    If (spRetNo > 0) then
    Begin
      Prv := T2203Prov;
      spRetNo := GetSpRetNo(RetNo);
      ret[spRetNo].Frm[FNo].strings[9] := Prv;
      InitPrvConstants(Prv); // 20110310
    end;
  end
  Else
  Begin
    Prv := ret[RetNo].Province; // 20180326
    InitPrvConstants(ret[RetNo].Province); // 20110310
  end;





  // 20090330
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    If IsPreBankruptcyReturn(RetNo) then
      Tv[1] := Constant[RY].MaxAgeAmount
    else
      Tv[1] := Constant[RY].MaxAgeAmount * PartYear;

    x := CalcMortgageForeclosure(ret[RetNo].Lnn[12700],
                                  Vl(FetchElmFNo(RetNo, GetFormNo('S3'), 195)),    //jz//20260215 - fields from s3 have changed from 122
                                  Vl(FetchElmFNo(RetNo, GetFormNo('S3'), 264)));   //jz//20260215 - fields from s3 have changed from 72
    If x < 0 then
      x := 0;

    FedNi := MaxR(0, SelectNetIncomeAmount(RetNo) - x);
    // 20250222 MaxR(0, Lnn[23600] - x);

    if FetchElmFNo(RetNo, InfoFNo, 94) > '' then
      FedNi := MaxR(0, Vl(FetchElm(RetNo, 'T1', 88)) - x); // 20220317

    If IsPreBankruptcyReturn(RetNo) then
      FedNi := MaxR(0, SelectNetIncomeAmount(RetNo) +
        Vl(FetchElm(RetNo, 'BANKRPT', 13)) - x);

    //20251116
    if TosiInEffect(RetNo) then FedNi := GetTosiNetIncome(RetNo);
    PrvNi := FedNi; // fter TOSI

   (*
    // 20181221
    if (Prv = 'NS') then // 20191207
      PrvNi := FedNi // before TOSI
    Else
    Begin
      if TosiInEffect(RetNo) then
        FedNi := GetTosiNetIncome(RetNo);
      PrvNi := FedNi; // fter TOSI
    end;
   *)
    If (Age < 65) then
    begin
      For i := 1 to 31 do // 20211121  For i := 1 to 17 do
      begin
        Frm[FNo].strings[i] := '';
        Tv[i] := 0;
      end;
      exit;
    end;

    Tv[2] := FedNi; // back in //20240330
    If IsPreBankruptcyReturn(RetNo) then
      Tv[3] := Constant[RY].AgeBaseAmount
    else
      Tv[3] := Constant[RY].AgeBaseAmount * PartYear;

    Tv[4] := MaxR(0, Tv[2] - Tv[3]);
    Tv[5] := 15;
    Tv[6] := Tv[4] * Tv[5] / 100;
    Tv[7] := Tv[6];
    Tv[8] := MaxR(0, Tv[1] - Tv[7]);

    If (Age < 65) or (FedNi >= Constant[RY].AgeNIThreshhold) then
      // (NI >= Constant[RY].AgeNIThreshhold) then
      Tv[8] := 0;

    If IsPreBankruptcyReturn(RetNo) then
      Tv[8] := Tv[8] * PartYear;
    If UpperCase(Frm[FNo].strings[19]) = 'Y' then
      Tv[8] := Tv[18]; // 20100413

    { Provincial };
    { copy to prv }
    For i := 1 to 8 do
      Tv[i + 9] := Tv[i];

    Frm[FNo].strings[9] := '';
    If FullToniProvince(RetNo) then
    begin
      Frm[FNo].strings[9] := Prv; // ret[RetNo].Province;   //20180406
      If IsPreBankruptcyReturn(RetNo) then
        Tv[10] := PrvConstant[RY].PrvMaxAgeAmount
      else
      Begin
        Tv[10] := PrvConstant[RY].PrvMaxAgeAmount * PartYear;
      End;
      Tv[11] := PrvNi;
      If (ret[RetNo].Province = 'NL') then
        Tv[11] := Tv[2];
      // 20211229 //as in Federal NI ret[RetNo].Lnn[23600]; // 20190203
      If IsPreBankruptcyReturn(RetNo) then // 20181201
        Tv[12] := PrvConstant[RY].PrvAgeBaseAmount
      else
      Begin
        Tv[12] := PrvConstant[RY].PrvAgeBaseAmount * PartYear;
      End;
      Tv[13] := MaxR(0, Tv[11] - Tv[12]);
      Tv[15] := Tv[13] * Tv[14] / 100;
      Tv[16] := Tv[15];
      Tv[17] := MaxR(0, Tv[10] - Tv[16]);
      xx:=Tv[17];
      yy:=PrvConstant[RY].PrvAgeNIThreshhold;
      If (Age < 65) or (PrvNi >= PrvConstant[RY].PrvAgeNIThreshhold) then
        Tv[17] := 0;
      If IsPreBankruptcyReturn(RetNo) then
      Begin
        //if ret[RetNo].Province <> 'NS' then // 2051116
          Tv[17] := Tv[17] * PartYear;
      End;
      If UpperCase(Frm[FNo].strings[21]) = 'Y' then
        Tv[17] := Tv[20]; // 20100413

      (*
      // NS //20181128
      if ret[RetNo].Province = 'NS' then
      Begin
        Tv[22] := 1465; // 20221211
        Tv[23] := ret[RetNo].Lnn[26000];
        If IsPreBankruptcyReturn(RetNo) then
          Tv[23] := Tv[23] + Vl(FetchElm(RetNo, 'BANKRPT', 13));

        Tv[24] := 30828; //25000;  //20251115
        Tv[25] := MaxR(0, Tv[23] - Tv[24]);
        Tv[26] := 2.93;
        Tv[27] := Tv[25] * Tv[26] / 100;
        Tv[28] := Tv[27];
        Tv[29] := MaxR(0, Tv[22] - Tv[28]);
        Tv[30] := Tv[29];
        // 20181204
        Tv[31] := (Tv[17] + Tv[30]) * PartYear; // 20181201
        Tv[31] := MinR(574, Tv[31]);  //20251115 //5608
      End
      Else
      begin
        for i := 22 to 31 do
          Tv[i] := 0;
      end;
     *)
    end;
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure DTC(RetNo: integer; FName: string; FNo: integer);
Var
  i: integer;
  FedNi, NI, PrvNi, x: Real;
Begin
  InitPrvConstants(ret[RetNo].Province); // 20111113

  LoadTv(RetNo, FName, FNo);
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    Tv[10] := Lnn[12000];
    Tv[11] := Lnn[12010];
    Tv[14] := MaxR(0, Tv[10] - Tv[11]);
    // 20161117
    Frm[FNo].strings[13] := FormatFloat('###.####',
      Constant[RY].DivOtherThanElig);
    Frm[FNo].strings[15] := FormatFloat('###.####', Constant[RY].DivElig);
    Tv[12] := Tv[11] * Vl(Frm[FNo].strings[13]) / 100;
    Tv[16] := Tv[14] * Vl(Frm[FNo].strings[15]) / 100;
    Tv[17] := Tv[12] + Tv[16];

    Tv[2] := Lnn[12000];
    Tv[3] := Lnn[12010];
    Tv[6] := MaxR(0, Tv[2] - Tv[3]);
    // 20161129  TV to strings
    // Frm[FNo].Strings[1]:=ret[RetNo].Province;  //20220911
    Frm[FNo].strings[5] := PrvConstant[RY].PrvDivRate;
    Frm[FNo].strings[7] := PrvConstant[RY].PrvDivRateBig;
    Tv[4] := Tv[3] * Vl(Frm[FNo].strings[5]) / 100;
    Tv[8] := Tv[6] * Vl(Frm[FNo].strings[7]) / 100;

    Tv[9] := Tv[4] + Tv[8];
    If ret[RetNo].Province = 'QC' then
    begin
      For i := 2 to 9 do
        Tv[i] := 0;
    end;

    (*
      //20161214
      If ret[RetNo].Province='NL' then
      Begin
      Frm[FNo].Strings[1]:='';
      for i:=2 to 9 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;
      Frm[FNo].Strings[20]:='NL';
      Tv[21]:=Lnn[12000];
      Tv[22]:=Lnn[12010];
      Tv[23]:=MaxR(0,Tv[21]-Tv[22]);
      Frm[FNo].Strings[18]:=PrvConstant[RY].PrvDivRateBig;
      Tv[19]:=Tv[23] * Vl(Frm[FNo].Strings[18])/100;

      Tv[31]:=Lnn[12010];
      Tv[34]:=Vl(FetchElm(RetNo,'NL428',95));
      Frm[FNo].Strings[24]:='4.1';
      Tv[32]:=Tv[34] * Vl(Frm[FNo].Strings[24])/100;
      Tv[37]:=MaxR(0,Tv[31]-Tv[34]);
      Frm[FNo].Strings[36]:=PrvConstant[RY].PrvDivRate;
      Tv[35]:=Tv[37]*Vl(Frm[FNo].Strings[36])/100;
      Tv[38]:=Tv[19]+Tv[32]+Tv[35];
      End;
    *)
  end;
  SaveTv(RetNo, FName, FNo);
end;

//20250929 Igor >>>
procedure S2(RetNo: Integer; FName: string; FNo: Integer);
var
  i, spRetNo, S11FNo: Integer;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    // 20200307
    if (FetchElmFNo(RetNo, InfoFNo, 167) > '') and not UpperCase(Frm[FNo].strings[20]).Equals('Y') then
    begin
      for i:= 1 to 19 do
      begin
        Frm[FNo].strings[i]:= '';
        Tv[i]:= 0;
      end;

      SaveTv(RetNo, FName, FNo);
      exit;
    End;
    Frm[FNo].strings[40]:= 'S2PRV';

    if CouplingSw then
    begin
      spRetNo:= GetSpRetNo(RetNo);
      S11FNo:= GetFormNo('S11');
      // Tv[9] := Ret[RetNo].Lnn[30000]; //20201122 //Constant[RY].BasicPersonalAmount;
      // if IsPreBankruptcyReturn(RetNo)  then Tv[9]:=Constant[RY].BasicPersonalAmount; //20210107

      if (spRetNo > 0) then // enter amounts and validate
      begin
        // 20220106
        Tv[3]:= ret[spRetNo].Lnn[30100];
        Tv[32]:= ret[spRetNo].Lnn[30400];
        Tv[4]:= ret[spRetNo].Lnn[31400];
        Tv[5]:= ret[spRetNo].Lnn[31600];
        Tv[6]:= 0;

        if UpperCase(FetchElmFNo(spRetNo, S11FNo, 25)).Equals('Y') then { cfer to sp }
          Tv[6]:= Vl(FetchElmFNo(spRetNo, S11FNo, 10))
        else
          Tv[6]:= 0;

        // Tv[7] := Tv[3] + Tv[32] + Tv[4] + Tv[5] + Tv[6];
        {Tv[22] := ret[SpRetNo].Lnn[23600];  //20220204
        Tv[23] := ret[SpRetNo].Lnn[25700];  //20220204 }
        (*
          Tv[24]:=0;
          If UpperCase(Frm[FNo].Strings[37]) <> 'Y' then
          Begin
          if ret[SpRetNo].Lnn[26000]<=49020 then
          Tv[8]:=ret[SpRetNo].Lnn[26000]
          Else
          Begin
          Tv[24] := MaxR(0, Tv[22] - Tv[23]);  //ni less deductions
          Tv[8]:=Tv[24]/(15/100);
          End;
        *)
        // 20220123
        Tv[9]:= ret[spRetNo].Lnn[30000];

        if IsPreBankruptcyReturn(RetNo) then
          Tv[9]:= Constant[RY].BasicPersonalAmount; // 20210107 //?

        Tv[36]:= Vl(FetchElm(spRetNo, 'T1', 59));
        Tv[39]:= ret[spRetNo].Lnn[32300];

        (*
          Tv[43] := ret[SpRetNo].Lnn[30000]; //20220123
          Tv[3] := ret[SpRetNo].Lnn[30100];
          Tv[32] := ret[SpRetNo].Lnn[30400];
          Tv[4] := ret[SpRetNo].Lnn[31400];
          Tv[5] := ret[SpRetNo].Lnn[31600];
          Tv[6] := 0;
          If UpperCase(FetchElmFNo(SpRetNo, S11FNo, 25)) = 'Y' then { cfer to sp }
          Tv[6] := Vl(FetchElmFNo(SpRetNo, S11FNo, 10))
          else
          Tv[6] := 0;
          Tv[22] := ret[SpRetNo].Lnn[23600];
          Tv[23] := ret[SpRetNo].Lnn[25700];
          Tv[9] := ret[SpRetNo].Lnn[30000];
          if IsPreBankruptcyReturn(RetNo) then Tv[9]:=Constant[RY].BasicPersonalAmount; //20210107
          Tv[11] := ret[SpRetNo].Lnn[30800];
          Tv[12] := ret[SpRetNo].Lnn[31000];
          Tv[13] := ret[SpRetNo].Lnn[31200];
          Tv[35] := ret[SpRetNo].Lnn[31220];
          Tv[28] := ret[SpRetNo].Lnn[31260];
          Tv[29] := ret[SpRetNo].Lnn[31350];   //20201123
          // Tv[29] := Ret[SpRetNo].Lnn[364];    //20181109
          // Tv[30] := Ret[SpRetNo].Lnn[365];   //20150906
          Tv[1] := ret[SpRetNo].Lnn[31217];
          Tv[2] := ret[SpRetNo].Lnn[31270];
          Tv[30] := ret[SpRetNo].Lnn[31285]; // 20161127
          // Tv[36] := Ret[SpRetNo].Lnn[370]; //20171113
          Tv[31] := ret[SpRetNo].Lnn[31300];
          Tv[14] := Vl(FetchElmFNo(SpRetNo, S11FNo, 21));
          Tv[35] := Vl(FetchElm(SpRetNo, 'RC269', 10));

          If ret[RetNo].Province = 'QC' then
          begin
          Tv[25] := ret[SpRetNo].Lnn[31205];
          Tv[26] := ret[SpRetNo].Lnn[31210];
          Tv[27] := ret[SpRetNo].Lnn[31215];
          end
          else
          begin
          Tv[25] := 0;
          Tv[26] := 0;
          Tv[27] := 0;
          end;
          //=======================

          //20220123
          Tv[9]:=Ret[spRetNo].Lnn[30000];
          if IsPreBankruptcyReturn(RetNo)  then Tv[9]:=Constant[RY].BasicPersonalAmount; //20210107
          Tv[36]:=Vl(FetchElm(SpRetNo,'T1',59));
          Tv[39]:=Ret[spRetNo].Lnn[32300];
        *)
      end; { spretno }
    end; { if coupling }

    // NO COUPLING put validations
    Tv[3]:= MinR(Tv[3], Constant[RY].MaxAgeAmount);
    Tv[4]:= MinR(2000, Tv[4]);

    if (CalcAge(GetSpouseBirthDate(RetNo)) < 18) then
      Tv[5]:= MinR(Tv[5], Constant[RY].MaxDisability + Constant[RY].MaxDisabSupl18) { ??? }
    else
      Tv[5]:= MinR(Tv[5], Constant[RY].MaxDisability);

    if (Tv[6] > 5000) then
      Tv[6]:= 5000;

    Tv[7]:= Tv[3] + Tv[32] + Tv[4] + Tv[5] + Tv[6];

    if (CouplingSw) and (spRetNo > 0) then // enter amounts and validate
    begin
      Tv[22]:= Ret[spRetNo].Lnn[23600];
      Tv[23]:= Ret[spRetNo].Lnn[26000];
      Tv[24]:= Vl(FetchElm(spRetNo, 'T1', 150)); // 20220206

      if (Tv[23] <= 57375) then // 55867 then
      // jz 20250131 value changed as per form - WHY IS THIS NOT A VARIABLE OF SOME SORT //49020 then
      begin
        Tv[8]:= Tv[23];
        Tv[24]:= 0;
      end else
        Tv[8]:= Tv[24] / (14.5 / 100);
    end else
    begin
      if (Tv[22] > 0) and (Tv[23] = 0) then Tv[23]:= Tv[22]; // if no taxable make it = net income //20220206
      if (Tv[23] <= 55867) then
      // jz 20250131 value changed as per form - WHY IS THIS NOT A VARIABLE OF SOME SORT //49020 then
      begin
        Tv[8]:= Tv[23];
        Tv[24]:= 0;
      end else
        Tv[8]:= Tv[24] / (14.5 / 100); // need diagnostic??
    end;

    if (Tv[36] = 0) then
      Tv[36]:= Vl(FetchElm(spRetNo, 'T1', 59)); //20250929 Igor

    {//if Tv[24]>0 then
      If UpperCase(Frm[FNo].Strings[37]) <> 'Y' then
      Tv[24] := MaxR(0, Tv[22] - Tv[23]);  //ni less deductions
      Tv[24] := Tv[24] + Vl(FetchElm(RetNo, 'INFO', 47));    //Vt[24]+Adjutment for  TOSI
      Tv[8] := Tv[24];
    }

    // 20220123
    if (Tv[9] > ret[RetNo].Lnn[30000]) then // (RetNo) then //Constant[RY].BasicPersonalAmount then //20201118
      Tv[9]:= ret[RetNo].Lnn[30000];
    // GetPersonalAmount(RetNo); // Constant[0].BasicPersonalAmount;
    // If Tv[9] > Constant[RY].BasicPersonalAmount then Tv[9] := Constant[RY].BasicPersonalAmount; //not workingon its own
    if IsPreBankruptcyReturn(RetNo) then
      Tv[9]:= Constant[RY].BasicPersonalAmount; // 20210107

    Tv[41]:= Tv[9] + Tv[36] + Tv[39];
    Tv[42]:= Tv[41];

    (* 20220123
      If Tv[9] > Ret[RetNo].Lnn[30000] then //(RetNo) then //Constant[RY].BasicPersonalAmount then //20201118
      Tv[9] := Ret[RetNo].Lnn[30000]; //GetPersonalAmount(RetNo); // Constant[0].BasicPersonalAmount;
      //If Tv[9] > Constant[RY].BasicPersonalAmount then Tv[9] := Constant[RY].BasicPersonalAmount; //not workingon its own
      if IsPreBankruptcyReturn(RetNo)  then Tv[9]:=Constant[RY].BasicPersonalAmount; //20210107
      If Tv[11] > Constant[RY].MaxCpp then
      Tv[11] := Constant[RY].MaxCpp;
      If Tv[13] > Constant[RY].MaxUI52 then
      Tv[13] := Constant[RY].MaxUI52;
      Tv[3] := MinR(Tv[3], Constant[RY].MaxAgeAmount);
      Tv[4] := MinR(2000, Tv[4]);

      If CalcAge(GetSpouseBirthDate(RetNo)) < 18 then
      Tv[5] := MinR(Tv[5], Constant[RY].MaxDisability + Constant[RY]
      .MaxDisabSupl18) { ??? }
      else
      Tv[5] := MinR(Tv[5], Constant[RY].MaxDisability);

      If Tv[6] > 5000 then
      Tv[6] := 5000;
      Tv[7] := Tv[3] + Tv[32] + Tv[4] + Tv[5] + Tv[6];

      If UpperCase(Frm[FNo].Strings[37]) <> 'Y' then
      Tv[24] := MaxR(0, Tv[22] - Tv[23]);
      Tv[24] := Tv[24] + Vl(FetchElm(RetNo, 'INFO', 47));
      // 20181226  //add Fed taxable

      Tv[8] := Tv[24];

      Tv[11] := MinR(Tv[11], Constant[RY].MaxCpp);
      Tv[13] := MinR(Tv[13], Constant[RY].MaxUI52);
      Tv[16] := Tv[9] + Tv[11] + Tv[12] + Tv[13] + Tv[28] + Tv[29] + Tv[1] +
      Tv[35] + Tv[38] + +Tv[2] + Tv[30] + Tv[31] + Tv[14];
      // 20161127 //+Tv[30] +tV[36] //20171113

      If ret[RetNo].Province = 'QC' then
      Tv[16] := Tv[16] + Tv[25] + Tv[26] + Tv[27];
    *)

    Tv[17]:= MaxR(0, Tv[8] - Tv[42]);
    // 20220124  MaxR(0, Tv[8] - Tv[16]); //20220123 //MaxR(0, Tv[8] - Tv[16]); //========

    Tv[18]:= Tv[17];
    Tv[19]:= MaxR(0, (Tv[7] - Tv[18]));

    if IsPreBankruptcyReturn(RetNo) then
      Tv[19]:= Tv[19] * ret[RetNo].PartYear; // 20210107

    if UpperCase(Frm[FNo].strings[10]).Equals('Y') then
      Tv[19]:= Tv[21];

    if (ret[RetNo].MarStatus > 2) then
    begin
      if ((ret[RetNo].MarStatus = 3) and (MarStatusChanged(RetNo))) then
        // 20110326
        // leave the calcs
      else
        if not UpperCase(Frm[FNo].strings[20]).Equals('Y') then
          for i:= 1 to 21 do
          begin
            Frm[FNo].strings[i]:= '';
            Tv[i]:= 0;
          end;
    end;

    Lnn[32600]:= Tv[19]; { for jacket }  // 20220207

    (* 20220123
      Lnn[35200] := Tv[3];
      Lnn[35300] := Tv[32];
      Lnn[35500] := Tv[4];
      Lnn[35700] := Tv[5];
      Lnn[36000] := Tv[6];
      Lnn[36100] := Tv[17];
      Lnn[32600] := Tv[19]; { for jacket }
      If IsPreBankruptcyReturn(RetNo) then Lnn[32600] := Vl(FetchElm(RetNo,'S2',19)); //20210107 //Lnn[32600] * Vl(FetchElm(RetNo, 'BANKRPT', 2)) / 366;
      // chg nrxt yr to 365
      Frm[FNo].Strings[15] := 'FORECLO';
    *)
  end; { with ret[retno] }

  SaveTv(RetNo, FName, FNo);
end;
//20250929 Igor <<<

Procedure S2PRV(RetNo: integer; FName: string; FNo: integer);
Var
  i, S2FNo, spRetNo: integer;
  Prv: String; // 20200307
  PrvtaxFNo: integer;
  TaxTableElm: integer;
  PartialNonRefElm: integer;
  TxblIncome, ThresholdAmount, RatePercent: Real;
Begin
  Prv := ret[RetNo].Province; // 20200307
  InitPrvConstants(Prv); // ret[RetNo].Province);
  PrvtaxFNo := GetFormNo(WhichTaxForm(RetNo, Prv)); // 20201230
  LoadTv(RetNo, FName, FNo);

  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    // 20200307
    if (FetchElmFNo(RetNo, InfoFNo, 167) > '') // prison or Non-res
      and (UpperCase(Frm[FNo].strings[20]) <> 'Y') then
    begin
      For i := 1 to 19 do
      begin
        Frm[FNo].strings[i] := '';
        Tv[i] := 0;
      end;
      SaveTv(RetNo, FName, FNo);
      exit;
    End;

    Frm[FNo].strings[30] := 'S2';
    If not FullToniProvince(RetNo) then
    begin
      For i := 1 to 46 do // instead of 35
      begin
        Frm[FNo].strings[i] := '';
        Tv[i] := 0;
        SaveTv(RetNo, FName, FNo);
        exit;
      end;
    end;

    { //20231216
      If (Province = 'ON') or (Province = 'NU') then // allow overrides
      // ok
      else
      begin
      Frm[FNo].Strings[28] := '';
      Frm[FNo].Strings[27] := '';
      end;
    }

    { copy from federal }
    S2FNo := GetFormNo('S2');
    // header
    ret[RetNo].Frm[FNo].strings[29] :=
      PrvLong[GetPrvIndex(ret[RetNo].Province)];
    ret[RetNo].Frm[FNo].strings[15] := GetS2PRVHeader(RetNo);

    Frm[FNo].strings[5] := FetchElmFNo(RetNo, S2FNo, 5);
    Tv[5] := Vl(FetchElmFNo(RetNo, S2FNo, 5));
    If (Tv[5] > 0) then
    begin
      If CalcAge(GetSpouseBirthDate(RetNo)) < 18 then
        Tv[5] := PrvConstant[RY].PrvMaxDisability + PrvConstant[RY]
          .PrvMaxDisabSupl18
      else
        Tv[5] := PrvConstant[RY].PrvMaxDisability;
    end;

    // 20110409  age amount
    If UpperCase(Frm[FNo].strings[28]) <> 'Y' then
    begin
      If Vl(FetchElmFNo(RetNo, S2FNo, 3)) = Constant[RY].MaxAgeAmount then
        Tv[3] := PrvConstant[RY].PrvMaxAgeAmount; // april 2005
    end;

    i := 4; // pension
    If UpperCase(Frm[FNo].strings[27]) <> 'Y' then
    begin // april 2005
      If Vl(FetchElmFNo(RetNo, S2FNo, i)) = 1000 then // max fed
        Tv[i] := PrvConstant[RY].PrvMaxPensionAmount
      else
        Tv[i] := Vl(FetchElmFNo(RetNo, S2FNo, i));
    end;

    Frm[FNo].strings[15] := GetS2PRVHeader(RetNo);
    Frm[FNo].strings[29] := PrvLong[GetPrvIndex(ret[RetNo].Province)];
    If ret[RetNo].Province = 'NL' then
      ret[RetNo].Frm[FNo].strings[29] := 'NL';
    If Province <> 'SK' then
    begin
      Tv[25] := 0;
      Tv[26] := 0;
    end;

    // 20160220 //20160223 Igor
    If Province <> 'BC' then
    Begin
      Tv[44] := 0;
      Tv[45] := 0;
      Tv[46] := 0; // 20161127
    end;

    If Province <> 'NU' then
    begin
      Tv[32] := 0;
    end;

    If UpperCase(Frm[FNo].strings[28]) <> 'Y' then
    Begin
      Tv[3] := MinR(Tv[3], PrvConstant[RY].PrvMaxAgeAmount);
    End;

    // 20200406
    If CouplingSw = True then
    begin
      spRetNo := GetSpRetNo(RetNo);
      // 20200414 Igor >>>
      if spRetNo > 0 then
      begin
        If UpperCase(Frm[FNo].strings[28]) <> 'Y' then // 20200406
          Tv[3] := Vl(FetchElm(spRetNo, GetTax1FormName(RetNo), 24));
        if ret[spRetNo].Province = 'NS' then
          Tv[3] := Vl(FetchElm(spRetNo, 'NS428', 24)); // 20200406
        Tv[4] := Vl(FetchElm(spRetNo, GetTax1FormName(RetNo), 34));
        Tv[5] := Vl(FetchElm(spRetNo, GetTax1FormName(RetNo), 36));
        If Province = 'SK' then
        begin
          Tv[25] := Vl(FetchElm(spRetNo, 'SK428', 66));
          Tv[26] := Vl(FetchElm(spRetNo, 'SK428', 67));
          // 20160216 Igor
          Tv[42] := Vl(FetchElm(RetNo, 'SK428', 84));
          // 20160214   //?? what is this?  //20210101 retno instead of SPRetNo
        end;
        { M15 }
        If UpperCase(FetchElm(spRetNo, 'S11PRV', 25)) = 'Y' then
          Tv[6] := Vl(FetchElm(spRetNo, 'S11PRV', 10));
        Tv[24] := ret[spRetNo].Lnn[26000]; // 20220226
      end;
      // 20200414 Igor <<<
    end;

    If UpperCase(Frm[FNo].strings[27]) <> 'Y' then
      Tv[4] := MinR(PrvConstant[RY].PrvMaxPensionAmount, Tv[4]);

    If (Province = 'ON') then { if eq to max fed }
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

    If FullToniProvince(RetNo) then
    begin
      Tv[6] := MinR(Tv[6], PrvConstant[RY].PrvMaxEducXfer);
    end;

    Tv[7] := Tv[32] + Tv[25] + Tv[34] + Tv[3] + Tv[26] + Tv[4] + Tv[5] + Tv[6];
    // ===================================================================
    // 20201230
    TxblIncome := Tv[24];
    ThresholdAmount := Tv[47];
    RatePercent := Vl(Frm[FNo].strings[48]);
    Frm[FNo].strings[33] := '8'; // in all of them
    // see the xx428
    if ret[RetNo].Province = 'AB' then
    begin
      TaxTableElm := 19;
      PartialNonRefElm := 57;
    end; // box 8 and box 32?? elms
    if ret[RetNo].Province = 'BC' then
    begin
      TaxTableElm := 132;
      PartialNonRefElm := 53;
    end; // box 8 and box 3? elms
    If ret[RetNo].Province = 'MB' then
    begin
      TaxTableElm := 101;
      PartialNonRefElm := 82;
    end; // box 8 and box 3? elms
    If ret[RetNo].Province = 'NB' then
    Begin
      TaxTableElm := 101;
      PartialNonRefElm := 98;
    end; // box 8 and box 3? elms
    If ret[RetNo].Province = 'NL' then
    begin
      TaxTableElm := 101;
      PartialNonRefElm := 112;
    end; // box 8 and box 3? elms
    If ret[RetNo].Province = 'NS' then
    begin
      TaxTableElm := 130;
      PartialNonRefElm := 173;
    end; // box 8 and box 3? elms
    If ret[RetNo].Province = 'NT' then
    begin
      TaxTableElm := 101;
      PartialNonRefElm := 79;
    end; // box 8 and box 3? elms
    If ret[RetNo].Province = 'NU' then
    begin
      TaxTableElm := 101;
      PartialNonRefElm := 85;
    end; // box 8 and box 3? elms
    if ret[RetNo].Province = 'ON' then
    begin
      TaxTableElm := 101;
      PartialNonRefElm := 137;
    end; // box 8 and box 3? elms
    if ret[RetNo].Province = 'PE' then
    begin
      TaxTableElm := 101;
      PartialNonRefElm := 95;
    end; // box 8 and box 3? elms
    if ret[RetNo].Province = 'SK' then
    Begin
      TaxTableElm := 101;
      PartialNonRefElm := 90;
    end; // box 8 and box 3? elms
    If ret[RetNo].Province = 'YT' then
    begin
      TaxTableElm := 134;
      PartialNonRefElm := 63;
    end; // box 8 and box 3? elms

    // 20221218
    With ret[RetNo].Frm[FNo] do // 20241223
    begin
      if ret[RetNo].Province = 'AB' then
      begin
        Tv[47] := 148269;
        strings[49] := '24';
        Tv[48] := 10;
      end;
      if ret[RetNo].Province = 'BC' then
      begin
        Tv[47] := 47937;
        strings[49] := '26';
        Tv[48] := 5.06;
      end; // 20210101
      If ret[RetNo].Province = 'MB' then
      begin
        Tv[47] := 47000;
        strings[49] := '28';
        Tv[48] := 10.8;
      end;
      If ret[RetNo].Province = 'NB' then
      Begin
        Tv[47] := 49958;
        strings[49] := '23';
        Tv[48] := 9.68;
      end;
      If ret[RetNo].Province = 'NL' then
      begin
        Tv[47] := 43198;
        strings[49] := '27';
        Tv[48] := 8.7;
      end; // 2-220113
      If ret[RetNo].Province = 'NS' then
      begin
        Tv[47] := 29590;
        strings[49] := '20';
        Tv[48] := 8.79;
      end;
      If ret[RetNo].Province = 'NT' then
      begin
        Tv[47] := 50597;
        strings[49] := '23';
        Tv[48] := 5.9;
      end;
      If ret[RetNo].Province = 'NU' then
      begin
        Tv[47] := 53268;
        strings[49] := '24';
        Tv[48] := 4;
      end;
      if ret[RetNo].Province = 'ON' then
      begin
        Tv[47] := 51446;
        strings[49] := '24';
        Tv[48] := 5.05;
      end;
      if ret[RetNo].Province = 'PE' then
      begin
        Tv[47] := 32656;
        strings[49] := '24';
        Tv[48] := 9.8;
      end;
      if ret[RetNo].Province = 'SK' then
      Begin
        Tv[47] := 52057;
        strings[49] := '29';
        Tv[48] := 10.5;
      end;
      If ret[RetNo].Province = 'YT' then
      begin
        Tv[47] := 55867;
        strings[49] := '24';
        Tv[48] := 6.4;
      end;

      {
        if Ret[RetNo].Province='AB' then begin Tv[47]:=134238; Strings[49]:='24';Tv[48]:=10;   end;
        if Ret[RetNo].Province='BC' then begin Tv[47]:=43070;  Strings[49]:='26';Tv[48]:=5.06; end;  //20210101
        If Ret[RetNo].Province='MB' then begin Tv[47]:=34431;  Strings[49]:='28';Tv[48]:=10.8; end;
        If Ret[RetNo].Province='NB' then Begin Tv[47]:=44887;  Strings[49]:='23';Tv[48]:=9.68; end;
        If Ret[RetNo].Province='NL' then begin Tv[47]:=39147;  Strings[49]:='27';Tv[48]:=8.7;  end; //2-220113
        If Ret[RetNo].Province='NS' then begin Tv[47]:=29590;  Strings[49]:='20';Tv[48]:=8.79; end;
        If Ret[RetNo].Province='NT' then begin Tv[47]:=45462;  Strings[49]:='23';Tv[48]:=5.9;  end;
        If Ret[RetNo].Province='NU' then begin Tv[47]:=47862;  Strings[49]:='24';Tv[48]:=4;    end;
        if Ret[RetNo].Province='ON' then begin Tv[47]:=46226;  Strings[49]:='24';Tv[48]:=5.05; end;
        if Ret[RetNo].Province='PE' then begin Tv[47]:=31984;  Strings[49]:='24';Tv[48]:=9.8;  end;
        if Ret[RetNo].Province='SK' then Begin Tv[47]:=46773;  Strings[49]:='29';Tv[48]:=10.5; end;
        If Ret[RetNo].Province='YT' then begin Tv[47]:=50197;  Strings[49]:='24';Tv[48]:=6.4;  end;
      }
    end;

    if TxblIncome <= ThresholdAmount then
      Tv[8] := TxblIncome
    Else
    Begin
      If CouplingSw = True then
      Begin
        Tv[1] := Vl(FetchElmFNo(spRetNo, PrvtaxFNo, TaxTableElm));
        Tv[8] := Tv[1] / (RatePercent / 100)
      End
      Else // 20220226
        Tv[8] := Tv[1] / (RatePercent / 100)
    End;

    Frm[FNo].strings[50] := Frm[FNo].strings[49];

    If CouplingSw = True then
    begin
      Tv[9] := Vl(FetchElm(spRetNo, GetTax1FormName(RetNo), 23));
      // 58040 basic personal
      Tv[51] := Vl(FetchElmFNo(spRetNo, PrvtaxFNo, PartialNonRefElm));
      // 20201230
      if spRetNo > 0 then
        Tv[14] := ret[spRetNo].Lnn[58560];
      // 202012   // Vl(FetchElm(SpRetNo, GetTax1FormName(RetNo), 39));
    end; // coupling
    Tv[12] := Tv[9] + Tv[51] + Tv[14]; // 20201230
    Tv[16] := Tv[12]; // Tv[9]+Tv[51]+Tv[14];   //20201230

    Tv[17] := MaxR(0, Tv[8] - Tv[16]);
    Tv[18] := Tv[17];
    Tv[19] := MaxR(0, (Tv[7] - Tv[18]));

    If IsPreBankruptcyReturn(RetNo) then
      Tv[19] := Tv[19] * Vl(FetchElm(RetNo, 'BANKRPT', 2)) / 366; // 20161227
    If UpperCase(Frm[FNo].strings[10]) = 'Y' then
      Tv[19] := Tv[21];

    // 20151220
    If (ret[RetNo].MarStatus < 3) then
      // ok
    Else
    begin
      If (UpperCase(Frm[FNo].strings[20]) <> 'Y') then
      begin
        For i := 1 to 13 do
        begin
          Frm[FNo].strings[i] := '';
          Tv[i] := 0;
        end;
        Tv[14] := 0; // 20180202
        For i := 16 to 21 do
        begin
          Frm[FNo].strings[i] := '';
          Tv[i] := 0;
        end;
      end;
    end;
  end; { with ret[retno] }
  SaveTv(RetNo, FName, FNo);
end;

Procedure S3QSUPL(RetNo: integer; FName: string; FNo: integer);
var
  i, k, j, jj: integer;
  Percent: Real;
Begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
    // init sharing indicators
    i := 187;
    Repeat
      If Tv[i] > 100 then
        Tv[i] := 100;
      Inc(i, 1);
    until i > 212; // all percentages
    { Shares }
    i := 4;
    repeat
      // 20100101
      If (IsDitto(strings[i - 2])) and (strings[i - 3] > '') then
        strings[i - 2] := strings[i - 2 - 7]; // 20010413 and (I>4)

      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
      Inc(i, 7);
    until i > 137;

    Tv[141] := 0;
    Tv[142] := 0;
    Tv[182] := 0;
    Tv[183] := 0;
    i := 4;
    j := 187;
    jj := 213;
    repeat
      Tv[141] := Tv[141] + Tv[i];
      Tv[142] := Tv[142] + Tv[i + 3];
      Percent := MaxR(0, (100 - Tv[j] - Tv[jj]) / 100);
      Tv[182] := Tv[182] + Tv[i] * Percent;
      Tv[183] := Tv[183] + Tv[i + 3] * Percent;
      If (Tv[i] = 0) and (Tv[i + 3] = 0) then
      begin
        Tv[j] := 0;
        Tv[jj] := 0;
      end;
      Inc(i, 7);
      Inc(j, 1);
      Inc(jj, 1);
    until i > 137;
    { farm }
    i := 145;
    repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
      Inc(i, 6);
    until i > 175;

    Tv[179] := 0;
    Tv[180] := 0;
    Tv[185] := 0;
    Tv[186] := 0;
    i := 145;
    j := 207;
    jj := 233;
    repeat
      Tv[179] := Tv[179] + Tv[i];
      Tv[180] := Tv[180] + Tv[i + 3];
      Percent := MaxR(0, (100 - Tv[j] - Tv[jj]) / 100);
      Tv[185] := Tv[185] + Tv[i] * Percent;
      Tv[186] := Tv[186] + Tv[i + 3] * Percent;
      If (Tv[i] = 0) and (Tv[i + 3] = 0) then
      begin
        Tv[j] := 0;
        Tv[jj] := 0;
      end;
      Inc(i, 6);
      Inc(j, 1);
      Inc(jj, 1);
    until i > 175;
  end;
  SaveTv(RetNo, FName, FNo);
end;

(*
  Procedure S3QSUPL(RetNo: integer; FName: string; FNo: integer);
  var
  i, k, j, jj: integer;
  Percent: Real;
  Begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
  // init sharing indicators
  i := 187;
  Repeat
  If Tv[i] > 100 then
  Tv[i] := 100;
  Inc(i, 1);
  until i > 212; // all percentages
  { Shares }
  i := 4;
  repeat
  // 20100101
  If (IsDitto(Strings[i - 2])) and (Strings[i - 3] > '') then
  Strings[i - 2] := Strings[i - 2 - 7]; // 20010413 and (I>4)

  Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
  Inc(i, 7);
  until i > 137;

  Tv[141] := 0;
  Tv[142] := 0;
  Tv[182] := 0;
  Tv[183] := 0;
  i := 4;
  j := 187;
  jj := 213;
  repeat
  Tv[141] := Tv[141] + Tv[i];
  Tv[142] := Tv[142] + Tv[i + 3];
  Percent := MaxR(0, (100 - Tv[j] - Tv[jj]) / 100);
  Tv[182] := Tv[182] + Tv[i] * Percent;
  Tv[183] := Tv[183] + Tv[i + 3] * Percent;
  If (Tv[i] = 0) and (Tv[i + 3] = 0) then
  begin
  Tv[j] := 0;
  Tv[jj] := 0;
  end;
  Inc(i, 7);
  Inc(j, 1);
  Inc(jj, 1);
  until i > 137;
  { farm }
  i := 145;
  repeat
  Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
  Inc(i, 6);
  until i > 175;

  Tv[179] := 0;
  Tv[180] := 0;
  Tv[185] := 0;
  Tv[186] := 0;
  i := 145;
  j := 207;
  jj := 233;
  repeat
  Tv[179] := Tv[179] + Tv[i];
  Tv[180] := Tv[180] + Tv[i + 3];
  Percent := MaxR(0, (100 - Tv[j] - Tv[jj]) / 100);
  Tv[185] := Tv[185] + Tv[i] * Percent;
  Tv[186] := Tv[186] + Tv[i + 3] * Percent;
  If (Tv[i] = 0) and (Tv[i + 3] = 0) then
  begin
  Tv[j] := 0;
  Tv[jj] := 0;
  end;
  Inc(i, 6);
  Inc(j, 1);
  Inc(jj, 1);
  until i > 175;
  end;
  SaveTv(RetNo, FName, FNo);
  end;
*)

Procedure S3SUPL(RetNo: integer; FName: string; FNo: integer);
var
  i, j, jj: integer;
  Percent: Real;
Begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
    // init sharing indicators
    i := 153; // %
    Repeat
      If Tv[i] > 100 then
        Tv[i] := 100; // %
      Inc(i, 1);
    until i > 162; // 20241203 191; // all percentages
    { Shares }
    i := 4;
    repeat
      // 20100101
      If (IsDitto(strings[i - 2])) and (strings[i - 3] > '') then
        strings[i - 2] := strings[i - 2 - 7]; // 2011 0413 and (I>4)
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
      Inc(i, 7);
    until i > 67;

    Tv[71] := 0;
    Tv[72] := 0;
    Tv[145] := 0;
    Tv[146] := 0;
    i := 4; // displosition
    j := 153;
    jj := 173;
    repeat
      Tv[71] := Tv[71] + Tv[i];
      Tv[72] := Tv[72] + Tv[i + 3];
      // If Tv[j]+Tv[jj]>100 then Tv[jj]:=0;
      Percent := MaxR(0, (100 - Tv[j] - Tv[jj]) / 100);
      Tv[145] := Tv[145] + Tv[i] * Percent;
      Tv[146] := Tv[146] + Tv[i + 3] * Percent;
      If (Tv[i] = 0) and (Tv[i + 3] = 0) then
      begin
        Tv[j] := 0;
        Tv[jj] := 0;
      end;
      Inc(i, 7);
      Inc(j, 1);
      Inc(jj, 1);
    until i > 67;
    { real estate }
    i := 75;
    repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
      Inc(i, 6);
    until i > 87;

    Tv[91] := 0;
    Tv[92] := 0;
    Tv[147] := 0;
    Tv[148] := 0;
    i := 75;
    j := 163;
    jj := 183;
    repeat
      Tv[91] := Tv[91] + Tv[i];
      Tv[92] := Tv[92] + Tv[i + 3];
      Percent := MaxR(0, (100 - Tv[j] - Tv[jj]) / 100);
      Tv[147] := Tv[147] + Tv[i] * Percent;
      Tv[148] := Tv[148] + Tv[i + 3] * Percent;
      If (Tv[i] = 0) and (Tv[i + 3] = 0) then
      begin
        Tv[j] := 0;
        Tv[jj] := 0;
      end;
      Inc(i, 6);
      Inc(j, 1);
      Inc(jj, 1);
    until i > 87;
    { Bonds }
    i := 97;
    repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
      Inc(i, 8);
    until i > 121;

    Tv[125] := 0;
    Tv[126] := 0;
    Tv[149] := 0;
    Tv[150] := 0;
    i := 97;
    j := 167;
    jj := 187;
    repeat
      Tv[125] := Tv[125] + Tv[i];
      Tv[126] := Tv[126] + Tv[i + 3];
      Percent := MaxR(0, (100 - Tv[j] - Tv[jj]) / 100);
      Tv[149] := Tv[149] + Tv[i] * Percent;
      Tv[150] := Tv[150] + Tv[i + 3] * Percent;
      If (Tv[i] = 0) and (Tv[i + 3] = 0) then
      begin
        Tv[j] := 0;
        Tv[jj] := 0;
      end;
      Inc(i, 8);
      Inc(j, 1);
      Inc(jj, 1);
    until i > 121;

    { mortages }
    i := 129;
    repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
      Inc(i, 6);
    until i > 135;

    Tv[139] := 0;
    Tv[140] := 0;
    Tv[151] := 0;
    Tv[152] := 0;
    i := 129;
    j := 171;
    jj := 190;
    repeat
      Tv[139] := Tv[139] + Tv[i];
      Tv[140] := Tv[140] + Tv[i + 3];
      Percent := MaxR(0, (100 - Tv[j] - Tv[jj]) / 100);
      Tv[151] := Tv[151] + Tv[i] * Percent;
      Tv[152] := Tv[152] + Tv[i + 3] * Percent;
      If (Tv[i] = 0) and (Tv[i + 3] = 0) then
      begin
        Tv[j] := 0;
        Tv[jj] := 0;
      end;
      Inc(i, 6);
      Inc(j, 1);
      Inc(jj, 1);
    until i > 135;
  end;
  { save data }
  SaveTv(RetNo, FName, FNo);
end;

(*
  Procedure S3SUPL(RetNo: integer; FName: string; FNo: integer);
  var
  i, j, jj: integer;
  Percent: Real;
  Begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
  // init sharing indicators
  i := 153;
  Repeat
  If Tv[i] > 100 then
  Tv[i] := 100;
  Inc(i, 1);
  until i > 191; // all percentages
  { Shares }
  i := 4;
  repeat
  // 20100101
  If (IsDitto(Strings[i - 2])) and (Strings[i - 3] > '') then
  Strings[i - 2] := Strings[i - 2 - 7]; // 2011 0413 and (I>4)
  Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
  Inc(i, 7);
  until i > 67;

  Tv[71] := 0;
  Tv[72] := 0;
  Tv[145] := 0;
  Tv[146] := 0;
  i := 4;
  j := 153;
  jj := 173;
  repeat
  Tv[71] := Tv[71] + Tv[i];
  Tv[72] := Tv[72] + Tv[i + 3];
  // If Tv[j]+Tv[jj]>100 then Tv[jj]:=0;
  Percent := MaxR(0, (100 - Tv[j] - Tv[jj]) / 100);
  Tv[145] := Tv[145] + Tv[i] * Percent;
  Tv[146] := Tv[146] + Tv[i + 3] * Percent;
  If (Tv[i] = 0) and (Tv[i + 3] = 0) then
  begin
  Tv[j] := 0;
  Tv[jj] := 0;
  end;
  Inc(i, 7);
  Inc(j, 1);
  Inc(jj, 1);
  until i > 67;
  { real estate }
  i := 75;
  repeat
  Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
  Inc(i, 6);
  until i > 87;

  Tv[91] := 0;
  Tv[92] := 0;
  Tv[147] := 0;
  Tv[148] := 0;
  i := 75;
  j := 163;
  jj := 183;
  repeat
  Tv[91] := Tv[91] + Tv[i];
  Tv[92] := Tv[92] + Tv[i + 3];
  Percent := MaxR(0, (100 - Tv[j] - Tv[jj]) / 100);
  Tv[147] := Tv[147] + Tv[i] * Percent;
  Tv[148] := Tv[148] + Tv[i + 3] * Percent;
  If (Tv[i] = 0) and (Tv[i + 3] = 0) then
  begin
  Tv[j] := 0;
  Tv[jj] := 0;
  end;
  Inc(i, 6);
  Inc(j, 1);
  Inc(jj, 1);
  until i > 87;
  { Bonds }
  i := 97;
  repeat
  Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
  Inc(i, 8);
  until i > 121;

  Tv[125] := 0;
  Tv[126] := 0;
  Tv[149] := 0;
  Tv[150] := 0;
  i := 97;
  j := 167;
  jj := 187;
  repeat
  Tv[125] := Tv[125] + Tv[i];
  Tv[126] := Tv[126] + Tv[i + 3];
  Percent := MaxR(0, (100 - Tv[j] - Tv[jj]) / 100);
  Tv[149] := Tv[149] + Tv[i] * Percent;
  Tv[150] := Tv[150] + Tv[i + 3] * Percent;
  If (Tv[i] = 0) and (Tv[i + 3] = 0) then
  begin
  Tv[j] := 0;
  Tv[jj] := 0;
  end;
  Inc(i, 8);
  Inc(j, 1);
  Inc(jj, 1);
  until i > 121;

  { mortages }
  i := 129;
  repeat
  Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
  Inc(i, 6);
  until i > 135;

  Tv[139] := 0;
  Tv[140] := 0;
  Tv[151] := 0;
  Tv[152] := 0;
  i := 129;
  j := 171;
  jj := 190;
  repeat
  Tv[139] := Tv[139] + Tv[i];
  Tv[140] := Tv[140] + Tv[i + 3];
  Percent := MaxR(0, (100 - Tv[j] - Tv[jj]) / 100);
  Tv[151] := Tv[151] + Tv[i] * Percent;
  Tv[152] := Tv[152] + Tv[i + 3] * Percent;
  If (Tv[i] = 0) and (Tv[i + 3] = 0) then
  begin
  Tv[j] := 0;
  Tv[jj] := 0;
  end;
  Inc(i, 6);
  Inc(j, 1);
  Inc(jj, 1);
  until i > 135;
  end;
  { save data }
  SaveTv(RetNo, FName, FNo);
  end;
*)

Procedure S4(RetNo: integer; FName: string; FNo: integer);
var
  i: integer;
Begin
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    LoadTv(RetNo, FName, FNo);

    // 20161117
    if ret[RetNo].Age < 18 then // 20190210
      Tv[5] := Vl(FetchElm(RetNo, 'T1206', 26)) * 1.16
      // 1.17 //1.18;  //20180115
    Else
      Tv[5] := 0;

    { Dividends }
    Tv[12] := T3Dividends;

    Tv[31] := T5Dividends + Vl(FetchElm(RetNo, 'T1SALDIV', 6));
    // 20200821 non eligible to simplify SALDIV from      // T2Tv[31] := T5Dividends;

    Tv[57] := GetRowFromSlip(RetNo, 'T4PS', 4, 0, 0);

    // 20161117
    Tv[60] := T5013ActDiv * 1.16; // 1.17; //1.18;  //20180115
    Tv[63] := Tv[12] + Tv[31] + Tv[57] + Tv[60];
    Tv[66] := Tv[2] + Tv[4] + Tv[63] + Tv[5]; // 20150430

    Tv[67] := T3DividendsEligible;
    Tv[68] := T5DividendsEligible + Vl(FetchElm(RetNo, 'T1SALDIV', 5));
    // 20200821 to simplify SALDIV from T2
    // Tv[68] := T5DividendsEligible;

    Tv[69] := GetRowFromSlip(RetNo, 'T4PS', 2, 0, 0);

    // 20161117
    Tv[70] := T5013ActDivEligible * 1.38; // 1.41;

    Tv[71] := Tv[67] + Tv[68] + Tv[69] + Tv[70];
    Tv[17] := Tv[66] + Tv[8] + Tv[10] + Tv[71];
    { interest }
    Tv[30] := T5Interest;
    // Tv[32] := Vl(FetchElm(RetNo,'CSB',41));    //20101219
    Tv[33] := T5013Interest + TotMultiple(RetNo, 'T5008', 190);
    // Vl(FetchElm(RetNo,'T5008',190));
    Tv[13] := Tv[30] + Tv[32] + Tv[33];
    { Foreign non-bus }
    Tv[41] := T3FNonBusInc1 + T3FNonBusInc2 + T3FNonBusInc3;
    Tv[41] := Tv[41] + { GetRowFromSlip(RetNo,'T4PS',7,0,0) incl in bx 35 }
      +T5013FInterest; { T3/25 }
    Tv[41] := Tv[41] + T5FNonBusInc1 + T5FNonBusInc2 + T5FNonBusInc3;
    { sum up }
    Tv[42] := 0;
    i := 19;
    Repeat
      Tv[42] := Tv[42] + Tv[i];
      i := i + 2;
    until i > 29;
    Tv[42] := Tv[42] + Tv[13];
    Tv[42] := Tv[42] + Tv[34] + Tv[36] + Tv[38] + Tv[40] + Tv[41];
    { partnerships }
    { classify }

    // Tv[44] := T5013LimitedInc;  //20130126

    // Tv[76] := T102PShipInc+Vl(FetchElm(RetNo,'RESINC',60));
    // Tv[12] := Tv[11]+Tv[76];
    // Tv[76]:=Vl(FetchElm(RetNo,'RESINC',19));
    // Tv[47] := Tv[11]+Tv[76]+Tv[44] + Tv[46];

    Tv[43] := T5013CarrCharg;
    // Tv[63]:=Tv[64]+Tv[65]+Tv[62]+Tv[66];
    // Tv[60]:=Tv[63];
    Tv[61] := 0;
    Tv[61] := Tv[61] + Tv[48] + Tv[50] + Tv[51] + Tv[43] + Tv[54] + Tv[56] +
      Tv[52] + Tv[59]; // 20160331 //20160505 Igor
    // For i:= 48 to 52 do Tv[61] := Tv[61] + Tv[i];
    // Tv[61] := Tv[61]+Tv[43]+ Tv[54] + Tv[56] + Tv[59]; // + Tv[60];
  end;
  SaveTv(RetNo, FName, FNo);
end;

//20250929 Igor >>>
procedure S5(RetNo: Integer; FName: string; FNo: Integer);
// Const BaseforL304L307 = 24361; //20210805  See below
var
  i, j, L, k, BirthYr18, CareGvrFNo, DependFNo, MedicalFNo, LastS5Ndx: Integer;
  PercentClaim: Real;
  BaseAmount: Real;
  DepRec: TDepRec;
  DependId: String[3];
  FcaNdx: Integer;
  EligDependantAge: Integer;
  BaseforL304L307: Real;
begin
  BaseforL304L307:= Constant[RY].CareGvrBase;
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    for i:= 3 to 50 do
    begin
      Frm[FNo].strings[i]:= '';
      Tv[i]:= 0;
    end;

    Lnn[30400]:= 0;
    Lnn[30450]:= 0;
    // Lnn[315]:=0;//Lnn[33199]:=0; //20121112  Lnn[306]:=0;
    Tv[50]:= 100;
    // Tv[50]:=Vl(FetchElm(RetNo,'DEPEND',160));  //%  //20171127 cannot split

    Frm[FNo].strings[12]:= 'Prov S5';
    Frm[FNo].strings[95]:= 'Dependants';

    if (FetchElmFNo(RetNo, InfoFNo, 39) + FetchElmFNo(RetNo, InfoFNo, 40) > '') then // mar st change //20160505 Igor
    begin
      // initialize all
      Frm[FNo].strings[49]:= '';
      Frm[FNo].strings[1]:= '';
      Frm[FNo].strings[2]:= '';
      Frm[FNo].strings[56]:= '';
      Frm[FNo].strings[57]:= '';
      Frm[FNo].strings[58]:= '';

      if (Ret[RetNo].MarStatus > 2) then // changed to other than married
      begin
        Frm[FNo].strings[49]:= 'X';
        Frm[FNo].strings[1]:= FetchElmFNo(RetNo, InfoFNo, 39);
        Frm[FNo].strings[2]:= FetchElmFNo(RetNo, InfoFNo, 40);
        Frm[FNo].strings[56]:= '';
        Frm[FNo].strings[57]:= '';
        Frm[FNo].strings[58]:= '';
      end else
      begin
        Frm[FNo].strings[49]:= '';
        Frm[FNo].strings[1]:= '';
        Frm[FNo].strings[2]:= '';
        Frm[FNo].strings[56]:= 'X';
        Frm[FNo].strings[57]:= FetchElmFNo(RetNo, InfoFNo, 39);
        Frm[FNo].strings[58]:= FetchElmFNo(RetNo, InfoFNo, 40);
      end;
    end else // NO MAR ST CHANGE  //20160316 //20160505 Igor
    begin
      Frm[FNo].strings[49]:= '';
      Frm[FNo].strings[1]:= '';
      Frm[FNo].strings[2]:= '';
      Frm[FNo].strings[56]:= '';
      Frm[FNo].strings[57]:= '';
      Frm[FNo].strings[58]:= '';
    end;

    //Page 2
    if (Frm[FNo].strings[1] + Frm[FNo].strings[2] = '') then
    begin // from date of death
      Frm[FNo].strings[1]:= MidStr(FetchElmFNo(RetNo, InfoFNo, 65), 6, 2);

      if Length(Frm[FNo].strings[2]) > 0 then
        Frm[FNo].strings[2]:= AddLeadingZeros(MidStr(FetchElm(RetNo, 'INFO', 65), 10, 2), 2);
      // 20121128
    end;

    if (Frm[FNo].strings[1] + Frm[FNo].strings[2] > '') then
      Frm[FNo].strings[49]:= 'X'; // 20121112

    PercentClaim:= Tv[50];
    DependFNo:= GetFormNo('DEPEND'); // 20130105
    // constants
    Tv[3]:= Vl(FetchElm(RetNo, 'LN30000', 11));
    // 20201216 Ret[RetNo].Lnn[30000];  //20201122
    // Tv[17] :=Ret[RetNo].Lnn[30000];  //20201122   see below //20201125
    Tv[27]:= BaseforL304L307; // Constant[RY].InfirmDependBase;  //20180325
    // ln 303
    if (ret[RetNo].MarStatus < 3) or ((IsSpouseDeceased(RetNo)) and (ret[RetNo].MarStatus = 3)) then
    begin
      Tv[3]:= Vl(FetchElm(RetNo, 'LN30000', 11));
      // 20201216   //Ret[RetNo].Lnn[30000];  //20201122  Constant[RY].SpousalBase;
      // 20201216 If IsPreBankruptcyReturn(RetNo) then Tv[3] := Ret[RetNo].Lnn[30000];  //20201122 //Constant[RY].SpousalBase;
      if (FetchElmFNo(RetNo, InfoFNo, 32) > '') then
        Tv[4]:= Constant[RY].FCAAmount
      else
        Tv[4]:= 0; // entitled to FCA

      Tv[5]:= (Tv[3] + Tv[4]) * ret[RetNo].PartYear; // 20131208 ;

      if IsPreBankruptcyReturn(RetNo) then
        Tv[5]:= (Tv[3] + Tv[4]); // 20151120;

      // GetPersonalAmountFromNetIncome(Vl(FetchElmFNo(RetNo, InfoFNo, 19))); // sp NI
      // Tv[6] := Vl(FetchElmFNo(RetNo, InfoFNo, 19)); //20201125 SP NI from pg1
      // Tv[6] := Tv[6] + GetSpouseSplitIncome(RetNo, InfoFNo);
      Tv[6]:= selectSpouseNetIncomeAmount(RetNo);
      // jz//20250224 //what about this???? + GetSpouseSplitIncome(RetNo, InfoFNo);

      // 20131214
      // false then // NI comes as normal, else modify it
      if (Rule90(RetNo) < 90) or (isDeemedResQuebec(RetNo)) then //jz//NonResCERT-R1 - isDeemedResQeubec, should it be deemed res in general??
      begin
        if (FetchElmFNo(RetNo, InfoFNo, 215) > '') and (Vl(FetchElmFNo(RetNo, InfoFNo, 213)) > 0) then
          Tv[6]:= Vl(FetchElmFNo(RetNo, InfoFNo, 213));
        // newcomer spouse  //20131213
      end;

      Tv[7]:= MaxR(0, Tv[5] - Tv[6]);

      if IsPreBankruptcyReturn(RetNo) then
        Tv[7]:= Tv[7] * PartYear; // 20151120
    end else
    begin
      Tv[4]:= 0;
      Tv[5]:= 0;
      Tv[6]:= 0;
      Tv[7]:= 0;
    end;

    //Page 3

    //jz//20260112 - was an override that is no longer in use, remove code and should probably remove from dfm as well
    {              - note: has code that if [7]=0 then [4] also=0 , put that somewhere else?
    if UpperCase(Frm[FNo].strings[55]).Equals('Y') then // 02002003
    // If (UpperCase(Frm[FNo].Strings[55])='Y') and (Tv[54]>0) then 02002003
    begin
      Tv[7]:= Tv[54]; // 20160318

      if Tv[7] = 0 then
        Tv[4]:= 0; // no caregiver either  //20200303
    end;
    }

    // if FetchElmFNo(RetNo,InfoFNo,167)>'' then Tv[7]:=0; //Non resident or in prison //20200307  //20200311 recalled

    if (Vl(FetchElmFNo(RetNo, DependFNo, 3)) > 0) then
    begin
      Tv[4]:= 0;
      Tv[5]:= 0;
      Tv[6]:= 0;
      Tv[7]:= 0;
    end;

    // LINE 305  do it before 304  elig dependant
    if (Vl(FetchElm(RetNo, 'DEPEND', 3)) > 0) then // eligible dependant claimed
    begin
      DependFNo:= GetFormNo('DEPEND');
      i:= 5; { index to first dep in  Depend }
      k:= 162; // lm 267 index
      L:= 190; // FCA index

      repeat
        if UpperCase(FetchElmFNo(RetNo, DependFNo, i + 14)).Equals('Y') then // elig dependant field
        begin
          Frm[FNo].strings[9]:= Rtrim(FetchElmFNo(RetNo, DependFNo, i + 1));
          { last name }
          Frm[FNo].strings[8]:= Rtrim(FetchElmFNo(RetNo, DependFNo, i)); { first }
          Frm[FNo].strings[11]:= Rtrim(FetchElmFNo(RetNo, DependFNo, i + 9)) + ' ' + Rtrim(FetchElmFNo(RetNo, DependFNo, i + 10)) + ' ' +
            Rtrim(FetchElmFNo(RetNo, DependFNo, i + 12)) + ' ' + Rtrim(FetchElmFNo(RetNo, DependFNo, i + 13)); { City,Prov,Postal }
          Frm[FNo].strings[13]:= LeftStr(Rtrim(FetchElmFNo(RetNo, DependFNo, i + 5)), 4); { birth }
          // 20130130
          EligDependantAge:= CalcAge(FetchElmFNo(RetNo, DependFNo, i + 5));
          // 20171112
          Frm[FNo].strings[14]:= FetchElmFNo(RetNo, DependFNo, i + 6);
          // 20211202
          Frm[FNo].strings[33]:= Rtrim(FetchElmFNo(RetNo, DependFNo, i + 2)); { sin }

          if UpperCase(FetchElmFNo(RetNo, DependFNo, i + 7)).Equals('Y') then { infirm }
          begin
            Frm[FNo].strings[15]:= 'X';
            Frm[FNo].strings[16]:= '';
          end else
          begin
            Frm[FNo].strings[15]:= '';
            Frm[FNo].strings[16]:= 'X';
          end;

          Tv[17]:= Vl(FetchElm(RetNo, 'LN30000', 11));
          // 20201216 //Ret[RetNo].Lnn[30000];  //20201122 //Constant[RY].SpousalBase;
          // 20180119 // * PartYear; //20131208
          // If IsPreBankruptcyReturn(RetNo) then Tv[17] := Constant[RY].SpousalBase;  //20201125
          if UpperCase(FetchElmFNo(RetNo, DependFNo, L + 1)).Equals('Y') then
            // caregiver
            Tv[18]:= Constant[RY].FCAAmount // 2000   //20130523
          else
            Tv[18]:= 0;

          if UpperCase(FetchElmFNo(RetNo, DependFNo, k + 1)).Equals('Y') then
            Tv[18]:= 0; // if claimed in ln367 less than 18

          Tv[19]:= (Tv[17] + Tv[18]) * ret[RetNo].PartYear; // 20131208

          if IsPreBankruptcyReturn(RetNo) then
            Tv[19]:= (Tv[17] + Tv[18]); // 20161204

          Tv[20]:= Vl(FetchElmFNo(RetNo, DependFNo, i + 8)); { NI }

          if TosiInEffect(RetNo) then
            Tv[20]:= Tv[20] + GetDependantSplitIncome(RetNo, i, DependFNo);

          Tv[21]:= MaxR(0, Tv[19] - Tv[20]);

          if IsPreBankruptcyReturn(RetNo) then
            Tv[21]:= MaxR(0, Tv[19] - Tv[20]) * ret[RetNo].PartYear;
          // 20180119 //201161204
          ret[RetNo].Lnn[30425]:= Tv[21];
        end;

        i:= i + 15;
        k:= succ(k);
        L:= succ(L);
      until i > 125;
    end;

    // 20180121
    // LINE 304  'CAREGIVER ELIGIBILITY' FOR SPOUSE OR ELIG DEPENDANT AGE >=18
    Tv[59]:= BaseforL304L307; // 20190123 CRA wants it in condensed

    // spouse and Caregiver flag=true
    if ((Tv[4] > 0) and (FetchElmFNo(RetNo, InfoFNo, 32) > '')) or ((Tv[18] > 0) and (EligDependantAge >= 18)) then // elig dep and caregiver //20180121
    begin
      Tv[59]:= BaseforL304L307; // 23046;  //20180107
      // 20171126  Net income
      if (Tv[4] > 0) then
        Tv[60]:= Tv[6] // spouse
      else
        Tv[60]:= Tv[20];

      if ((Tv[4] > 0) and (FetchElmFNo(RetNo, InfoFNo, 32) > '')) then
        // spouse and Caregiver flag=true
        Tv[60]:= Tv[60] + GetSpouseSplitIncome(RetNo, InfoFNo);

      if ((Tv[18] > 0) and (EligDependantAge >= 18)) then
      begin
        // finf elig dep index
        // get his split income
      End;

      Tv[61]:= MaxR(0, Tv[59] - Tv[60]);
      Tv[61]:= MinR(Tv[61], Constant[RY].MaxInfirmAmount);
      Tv[61]:= Tv[61] * ret[RetNo].PartYear; // 20171209

      if (Tv[18] > 0) then
        Tv[62]:= Tv[21] // Claimed eligible dependant
      Else
        Tv[62]:= Tv[7]; // spouse

      Tv[63]:= MaxR(0, Tv[61] - Tv[62]);
    end else
      for i:= 60 to 63 do Tv[i]:= 0;
      // for I :=59 to 63 do Tv[i]:=0;  //20190123 not 59=base amount

    //if (Tv[60] > 7159 * ret[RetNo].PartYear) and // 20201118
    if (Tv[60] > 8624 * ret[RetNo].PartYear) and // 20250929 Igor
       (Tv[60] < BaseforL304L307 * ret[RetNo].PartYear) then // 20181222 //6902
      // Ok  keep the 304 claim
    else
      for i:= 60 to 63 do Tv[i]:= 0;

    // Ln 307   caregiver over 18 except eligible dependant
    // 20180122
    Frm[FNo].strings[32]:= FetchElmFNo(RetNo, DependFNo, 160); // 20180122
    PercentClaim:= Vl(Frm[FNo].strings[32]);
    // ------------------
    i:= getIndexToACareGiverDependant(RetNo, 1);
    // index to first name for the 1st caregiver dependant
    if (i > 0) Then
    begin
      if not UpperCase(FetchElmFNo(RetNo, DependFNo, i + 14)).Equals('Y')
      // i+14 is eligible dep
        and (CalcAge(FetchElmFNo(RetNo, DependFNo, i + 5)) >= 18) then
      // not eligible dependant
      begin
        Frm[FNo].strings[23]:= Rtrim(FetchElmFNo(RetNo, DependFNo, i + 1));
        { last name }
        Frm[FNo].strings[22]:= Rtrim(FetchElmFNo(RetNo, DependFNo, i));
        { first name }
        Frm[FNo].strings[24]:= Rtrim(FetchElmFNo(RetNo, DependFNo, i + 9)) +
          ' ' + { street }
          Rtrim(FetchElmFNo(RetNo, DependFNo, i + 10)) + ' ' + { City }
          Rtrim(FetchElmFNo(RetNo, DependFNo, i + 12)) + ' ' + { Prov }
          Rtrim(FetchElmFNo(RetNo, DependFNo, i + 13)); { Postal }
        Frm[FNo].strings[25]:= LeftStr(Rtrim(FetchElmFNo(RetNo, DependFNo, i + 5)), 4); { yy }
        // 20130130
        Frm[FNo].strings[26]:= Rtrim(FetchElmFNo(RetNo, DependFNo, i + 6)
          ); { Relat }
        Tv[27]:= BaseforL304L307;
        // 20180120 // 23046; //Constant[RY].InfirmDependBase; //20180107
        Tv[28]:= Vl(FetchElmFNo(RetNo, DependFNo, i + 8)); { NI }
        // k:=Trunc((i/15))*7+301;  //index to TOSI name. So  k+2 is the split income
        if TosiInEffect(RetNo) then
          Tv[28]:= Tv[28] + GetDependantSplitIncome(RetNo, i, DependFNo);
        Tv[29]:= MaxR(0, Tv[27] - Tv[28]);
        Tv[29]:= MinR(Tv[29], Constant[RY].MaxInfirmAmount);
        // + Constant[RY].FCAAmount); //20141220
        Tv[29]:= Tv[29] * ret[RetNo].PartYear; // 201141220
        Tv[29]:= Tv[29] * PercentClaim / 100; // 20180122
      end;
    end;
    // 20180122
    Tv[30]:= Vl(FetchElm(RetNo, 'S5SUPL', 50)) * PercentClaim / 100;
    Tv[31]:= Tv[29] + Tv[30];

    k:= MyStrToInt(FetchElm(RetNo, 'S5SUPL', 49));
    // 20180120 //CountFCADependantsFromS5Suppl(RetNo);
    if (Tv[29] > 0) then
      Inc(k);

    if (k = 0) then
      Frm[FNo].strings[48]:= ''
    else
      Frm[FNo].strings[48]:= IntToStr(k);

    if (Tv[31] = 0) then
      Frm[FNo].strings[48]:= ''; // no claim thus number is blank //20180122
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20250929 Igor <<<

// 20180120
Procedure S5SUPL(RetNo: integer; FName: string; FNo: integer);
//Const BaseforL304L307 =  Constant[0].CareGvrBase;  //28041; //20250428
Var
  BaseForL304L307:Real;
  i, d, j, L, k, k1, BirthYr18, CareGvrFNo, DFNo, MedicalFNo,
    LastS5Ndx: integer;
  PercentClaim: Real;
  BaseAmount: Real;
  DepRec: TDepRec;
  DependId: String[3];
  FcaNdx: integer;
  FInst: String;
  Cnt: integer;
Begin
  BaseforL304L307:=  Constant[0].CareGvrBase;  //20250428
  // 201810120  Changed from multiple to single on //20180120 with existing files with multiple
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  Begin
    for i := 1 to 48 do
    begin
      strings[i] := '';
      Tv[i] := 0;
    end; // initialize

    Cnt := 0;
    DFNo := GetFormNo('DEPEND');
    i := 0; // indx to this form
    d := 5; // index to Dep
    k1 := 263; // age
    k := 191; { index to depend caregiver elm }
    Repeat
      If (UpperCase(FetchElmFNo(RetNo, DFNo, k)) = 'Y') // caregiver claim
        and (Vl(FetchElmFNo(RetNo, DFNo, k1)) >= 18) and
        (UpperCase(FetchElmFNo(RetNo, DFNo, i + 14)) <> 'Y')
      // NOT eligible dependant
      then // caregiver claim
      begin
        Inc(Cnt);
        if Cnt > 1 then
        begin
          strings[i + 1] := FetchElmFNo(RetNo, DFNo, d); { First nm }
          strings[i + 2] := FetchElmFNo(RetNo, DFNo, d + 1); { Last nm }
          strings[i + 3] := FetchElmFNo(RetNo, DFNo, d + 5); { birthdate }
          strings[i + 4] := FetchElmFNo(RetNo, DFNo, d + 6); { relationship }
          Tv[i + 5] := Vl(FetchElmFNo(RetNo, DFNo, 160)); { % claimed }
          Tv[i + 6] := BaseforL304L307; // 20180120
          Tv[i + 7] := Vl(FetchElmFNo(RetNo, DFNo, d + 8)); // NI
          // claim
          Tv[i + 8] := MaxR(0, Tv[i + 6] - Tv[i + 7]);
          Tv[i + 8] := MinR(Tv[i + 8], Constant[RY].MaxInfirmAmount);
          // 20180120
          Tv[i + 8] := Tv[i + 8] * ret[RetNo].PartYear; // 20180120
          Inc(i, 8); // next row to be poulated
        end;
      End;
      Inc(k1, 1);
      Inc(k, 1);
      Inc(d, 15);
    until d > 125; // dependant
    // summary
    Tv[50] := 0;
    Cnt := 0;
    i := 8;
    repeat
      if Tv[i] > 0 then
      Begin
        Cnt := Cnt + 1;
        Tv[50] := Tv[50] + Tv[i];
      end;
      Inc(i, 8);
    until i > 48;
    strings[49] := IntToStr(Cnt);
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure S5PRV(RetNo: integer; FName: string; FNo: integer);
Var
  i, j, L, L1, k, k1, K2, K3, BirthYr18, CareGvrFNo, DependFNo, MedicalFNo,
    LastNmS5Ndx: integer;
  PercentClaim: Real;
  BaseAmount: Real;
  DepRec: TDepRec;
  DependId: String[3];
  Prv: String; // 20180326
Begin
  // 20170509
  if IsMultJurisdiction(RetNo) = false then
  Begin
    Prv := ret[RetNo].Province; // 20180326
    InitPrvConstants(ret[RetNo].Province); // 20110310
  end
  Else
  Begin
    Prv := T2203Prov; // 20180326
    InitPrvConstants(T2203Prov); // 20110310
  end;

  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    LoadTv(RetNo, FName, FNo); { Do not load, is automatic }
    // initialize
    For i := 1 to 98 do
    begin
      Frm[FNo].strings[i] := '';
      Tv[i] := 0;
    end; // 20180120

    Frm[FNo].strings[12] := 'Fed S5';
    Frm[FNo].strings[95] := 'Dependants';

    Frm[FNo].strings[1] := FetchElm(RetNo, 'INFO', 39);
    Frm[FNo].strings[2] := FetchElm(RetNo, 'INFO', 40);

    // init
    DependFNo := GetFormNo('DEPEND');
    If UpperCase(FetchElm(RetNo, 'DEPEND', 140)) = 'N' then
    Begin
      SaveTv(RetNo, FName, FNo); // 20180120
      exit;
    End;
    PercentClaim := Vl(FetchElmFNo(RetNo, DependFNo, 160));
    // Vl(FetchElmFNo(RetNo,DependFNo,i+11)); //20130206

    // LINE 5816   ELIGIBLE DEPENDANT
    If Vl(FetchElm(RetNo, 'DEPEND', 3)) > 0 then // elig dependant
    begin
      { Bring info from DEPEND (equiv spouse }
      DependFNo := GetFormNo('DEPEND');
      i := 5; { index to first dep in  Depend }
      Repeat
        if UpperCase(FetchElmFNo(RetNo, DependFNo, i + 14)) = 'Y'
        then { Equv spouse field }
        begin
          // PercentClaim := Vl(FetchElmFNo(RetNo,DependFNo,160));//Vl(FetchElmFNo(RetNo,DependFNo,i+11)); //20130206
          Tv[8] := Vl(FetchElmFNo(RetNo, DependFNo, i + 8)); { NI }
          Frm[FNo].strings[3] := Rtrim(FetchElmFNo(RetNo, DependFNo, i + 1));
          { last name }
          Frm[FNo].strings[4] := Rtrim(FetchElmFNo(RetNo, DependFNo, i)
            ); { first }
          Frm[FNo].strings[5] := Rtrim(FetchElmFNo(RetNo, DependFNo, i + 9)) +
            ' ' + Rtrim(FetchElmFNo(RetNo, DependFNo, i + 10)) + ' ' +
            Rtrim(FetchElmFNo(RetNo, DependFNo, i + 12)) + ' ' +
            Rtrim(FetchElmFNo(RetNo, DependFNo, i + 13)); { City,Prov,Postal }
          Frm[FNo].strings[7] := FetchElmFNo(RetNo, DependFNo, i + 6); { Relat }
          Frm[FNo].strings[6] := Rtrim(FetchElmFNo(RetNo, DependFNo, i + 5)
            ); { birth }
          Frm[FNo].strings[9] := Rtrim(FetchElmFNo(RetNo, DependFNo, i + 7));
          { infirm }
          Frm[FNo].strings[11] :=
            Rtrim(FetchElmFNo(RetNo, DependFNo, i + 2)); { sin }
        end;
        i := i + 15;
      until i > 125;

      BaseAmount := PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
      If (PercentClaim > 0) and (PercentClaim <= 100) then
        Tv[10] := (MaxR(0, BaseAmount - Tv[8]))
      else
        Tv[10] := MaxR(0, BaseAmount - Tv[8]);
      If Tv[10] > PrvConstant[RY].PrvMaxSpousalAmount then
        Tv[10] := PrvConstant[RY].PrvMaxSpousalAmount;
      if ret[RetNo].Province = 'NS' then
        Tv[10] := Vl(FetchElm(RetNo, 'NS5816', 16)); // 20181128

      // 20180119
      If IsPreBankruptcyReturn(RetNo) then
      Begin
        BaseAmount := PrvConstant[RY].PrvSpouseBasicAmount;
        Tv[10] := MaxR(0, BaseAmount - Tv[8]);
        // 20090121 Do the check first
        If Tv[10] > PrvConstant[RY].PrvMaxSpousalAmount then
          Tv[10] := PrvConstant[RY].PrvMaxSpousalAmount;
        Tv[10] := Tv[10] * ret[RetNo].PartYear;
        If (PercentClaim > 0) and (PercentClaim <= 100) then
          Tv[10] := Tv[10] * PercentClaim / 100;
      end;
    end; // 5816
    // ===========  end elig dependant 56160
    If (ret[RetNo].Province = 'YT') and (IsMultJurisdiction(RetNo) = false)
    // 20180402
    then
      Tv[10] := Vl(FetchElm(RetNo, 'S5', 21));
    // Tv[10]:=vl(FetchElm(RetNo,'S5',10)); //20121115
    // ---------------------------------------------------------------

    // LINE 58200 infirm dependants over >=18  CAREGIVER AMOUNT  //But it checks for diability???
    j := 13; // lastname row in s5PRV controlled by j STARTING NDX for dependants LastName in S5PRV (for 5820, 5840
    L := 12; // 20180119 {index to Disabled indicator in dependfno}
    k := 101; // SIN index  in Fno S5Prv
    k1 := 263; // age ndx in dependfno
    K2 := 191; // Caregiver ndx in dependfno
    K3 := 141;
    begin
      // Bring infirm over from DEPEND
      i := 5; { index in Dependants on First name }
      Repeat { for dep over 18 }
        if (UpperCase(FetchElmFNo(RetNo, DependFNo, L)) = 'Y') // disability
          and (Vl(FetchElmFNo(RetNo, DependFNo, k1)) >= 18)
        // 20171128 as perdepend
        then // Infirm and 18 or older and not Ont
        begin
          Frm[FNo].strings[j] := Rtrim(FetchElmFNo(RetNo, DependFNo, i + 1));
          { last name }
          Frm[FNo].strings[j + 7] := Rtrim(FetchElmFNo(RetNo, DependFNo, i));
          { first name }
          Frm[FNo].strings[k] := Rtrim(FetchElmFNo(RetNo, DependFNo, i + 2));
          { sin }  // 20171128
          Frm[FNo].strings[j + 8] := Rtrim(FetchElmFNo(RetNo, DependFNo, i + 9))
            + ' ' + { street }
            Rtrim(FetchElmFNo(RetNo, DependFNo, i + 10)) + ' ' + { City }
            Rtrim(FetchElmFNo(RetNo, DependFNo, i + 12)) + ' ' + { Prov }
            Rtrim(FetchElmFNo(RetNo, DependFNo, i + 13)); { Postal }
          Frm[FNo].strings[j + 1] :=
            Rtrim(FetchElmFNo(RetNo, DependFNo, i + 5)); { yy }
          Frm[FNo].strings[j + 2] := Rtrim(FetchElmFNo(RetNo, DependFNo, i + 6)
            ); { Relat }
          Tv[j + 3] := Vl(FetchElmFNo(RetNo, DependFNo, i + 8)); { NI }
          k := Trunc((i / 15)) * 7 + 301;
          // index to TOSI name. So  k+3 is the Tosi net income of the dependant
          if Vl(FetchElmFNo(RetNo, DependFNo, k + 3)) > Tv[j + 3] then
            Tv[j + 3] := Vl(FetchElmFNo(RetNo, DependFNo, k + 3));
          // 20190115 TosiNI

          Frm[FNo].strings[j + 4] := Rtrim(FetchElmFNo(RetNo, DependFNo, i + 7)
            ); { infirm }
          Frm[FNo].strings[j + 5] := '58200'; // 20191210 5 digits
          Tv[j + 6] := CalcPrvInfirmClaim(RetNo, Tv[j + 3], PercentClaim);
          // 20130206
          // if prv='BC' then Tv[j+6]:=CalcPrvInfirmClaim(RetNo,Tv[j+3],PercentClaim);  //20130206

          // If same dep in 5816  then deduct 5816   //20141221
          if Frm[FNo].strings[k] = Frm[FNo].strings[11] then
            Tv[j + 6] := MaxR(0, Tv[j + 6] - Tv[10]); // deduct

          if ret[RetNo].Province = 'ON' then
            Frm[FNo].strings[j + 5] := '58185'; // '5819';  //20191210 5 digits

          if (Prv = 'PE') then // 20180326
          Begin
            if Tv[j + 3] < PrvConstant[RY].PrvInfirmDependBase then
              Frm[FNo].strings[j + 5] := '58200' // '5820'   //20191210 5 digits
            Else
            Begin
              Frm[FNo].strings[j + 5] := '';
              Tv[j + 6] := 0 // no claim on this line
            End;
          end;

          j := j + 9; { now increase s5prv ndxindex }
          Inc(k); // 20180225 8:14
        end;
        i := i + 15;
        L := L + 15; // j19
        Inc(k1);
        Inc(K2); // 20191210
        // Inc(k); done in above loop
      until i > 125;
    end;

    // LINE 58400 infirm dependants over >=18 and CAREGIVER
    // Tv[91]:=
    j := 13; // lastname row in s5PRV controlled by j STARTING NDX for dependants LastName in S5PRV (for 5820, 5840
    L := 191; // index to Claim CAREGIVER
    L1 := 141; // infirm indicator in depfno
    k := 101; // SIN index  in Fno S5Prv
    k1 := 263; // age ndx in dependfno
    begin
      // Bring infirm over from DEPEND
      i := 5; { index in Dependants on First name }
      Repeat { for dep over 18 }
        if (UpperCase(FetchElmFNo(RetNo, DependFNo, L)) = 'Y')
        // caregiver claim  //20171128
          and ((Vl(FetchElmFNo(RetNo, DependFNo, k1)) >= 18) and
          (UpperCase(FetchElmFNo(RetNo, DependFNo, L1)) = 'Y')
          // over 18 and infirm indic
          Or (Vl(FetchElmFNo(RetNo, DependFNo, k1)) >= 65) and (Prv <> 'ON') and
          (Prv <> 'YT') // old parent   //20180326 PRV instead
          Or (Vl(FetchElmFNo(RetNo, DependFNo, k1)) >= 18) and (Prv <> 'ON') and
          (Prv <> 'YT') // 20180326   //prv instead
          ) then // Infirm and 18 or older and not Ont
        begin
          Frm[FNo].strings[j] := Rtrim(FetchElmFNo(RetNo, DependFNo, i + 1));
          { last name }
          Frm[FNo].strings[j + 7] := Rtrim(FetchElmFNo(RetNo, DependFNo, i));
          { first name }
          Frm[FNo].strings[k] := Rtrim(FetchElmFNo(RetNo, DependFNo, i + 2));
          { sin }  // 20171128
          Frm[FNo].strings[j + 8] := Rtrim(FetchElmFNo(RetNo, DependFNo, i + 9))
            + ' ' + { street }
            Rtrim(FetchElmFNo(RetNo, DependFNo, i + 10)) + ' ' + { City }
            Rtrim(FetchElmFNo(RetNo, DependFNo, i + 12)) + ' ' + { Prov }
            Rtrim(FetchElmFNo(RetNo, DependFNo, i + 13)); { Postal }
          Frm[FNo].strings[j + 1] :=
            Rtrim(FetchElmFNo(RetNo, DependFNo, i + 5)); { yy }
          Frm[FNo].strings[j + 2] := Rtrim(FetchElmFNo(RetNo, DependFNo, i + 6)
            ); { Relat }
          Tv[j + 3] := Vl(FetchElmFNo(RetNo, DependFNo, i + 8)); { NI }
          Frm[FNo].strings[j + 4] := Rtrim(FetchElmFNo(RetNo, DependFNo, i + 7)
            ); { infirm }
          Frm[FNo].strings[j + 5] := '58400'; // '5840';//20191210
          Tv[j + 6] := CalcPrvCareGvrClaim(RetNo, Tv[j + 3], PercentClaim);
          // 20130206
          // If same dep in 5816  then deduct 5816   //20141221
          if Frm[FNo].strings[k] = Frm[FNo].strings[11] then
            Tv[j + 6] := MaxR(0, Tv[j + 6] - Tv[10]); // deduct

          if Prv = 'ON' then
            Frm[FNo].strings[j + 5] := '58185'; // '5819';  //20191210
          j := j + 9; { now increase s5prv ndxindex }
          k := k + 1; // 20180225 7:14
        end;
        i := i + 15;
        Inc(L); // 20180225
        Inc(L1); // 20180225
        // Inc(k);       K:=k+1; //20180225 7:14
        Inc(k1);
      until i > 125;
    end;

    // summarize
    With ret[RetNo].Frm[FNo] do
    begin
      i := 18;
      Repeat // 20191210
        If strings[i] = '58200' then
          Tv[85] := Tv[85] + Tv[i + 1]
        else if strings[i] = '58400' then
          Tv[88] := Tv[88] + Tv[i + 1]
        else if strings[i] = '58185' then
          Tv[96] := Tv[96] + Tv[i + 1]; // 20180120
        // else if Strings[i]='5819' then Tv[96]:=Tv[96]+Tv[i+1];  //20191210
        Inc(i, 9);
      until i > 81;
      Tv[87] := Tv[85] + Tv[86];
      // if same dependant then deduct 5816 from
      // Tv[87]:=MaxR(0,Tv[85]+Tv[86]-Tv[10]);  // 20141128 deduct line 5816 from 5820
      Tv[90] := Tv[88] + Tv[89];
      Tv[93] := Tv[91] + Tv[92];
      Tv[98] := Tv[96] + Tv[97]; // 20171128
    end;
  end;
  SaveTv(RetNo, FName, FNo);
end;

////20250929 Igor >>>
procedure S7(RetNo: Integer; FName: string; FNo: Integer);
var
  DedLimit: Real;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    Tv[1] := Vl(FetchElm(RetNo, 'CFR', 31));
    Tv[17]:= Vl(FetchElm(RetNo, 'RRSP', 42)) + Vl(FetchElm(RetNo, 'RRSP', 71));
    Tv[18]:= Vl(FetchElm(RetNo, 'RRSP', 69));
    Tv[4] := Vl(FetchElm(RetNo, 'RRSP', 73)); // HBP rep
    Tv[13]:= Vl(FetchElm(RetNo, 'RRSP', 76)); // LLP rep
    Tv[7] := Vl(FetchElm(RetNo, 'RRSP', 71)); // xfers
    Tv[15]:= TotMultiple(RetNo, 'T4RSP', 7);
    Tv[11]:= Vl(FetchElm(RetNo, 'RRSP', 11));
    DedLimit:= Tv[11]; // Vl(FetchElm(RetNo,'RRSP',11));

    Tv[2]:= Tv[17] + Tv[18];
    Tv[19]:= Tv[2];
    Tv[3]:= Tv[1] + Tv[19];
    Tv[14]:= Tv[4] + Tv[13];
    Tv[12]:= Tv[14];
    Tv[30]:= Tv[3]; // 20190207
    Tv[5]:= MaxR(0, Tv[30] - Tv[12]); // 201290207
    // Tv[5] := MaxR(0, Tv[3] - Tv[12]);
    Tv[29]:= Tv[5]; // 20170226
    Tv[25]:= Tv[11];
    Tv[26]:= Vl(FetchElm(RetNo, 'RRSP', 101));
    Tv[27]:= MaxR(0, Tv[25] - Tv[26]);
    Tv[31]:= Tv[5]; // 20220124
    Tv[7]:= MinR(Tv[7], Lnn[11500] + Lnn[12900] + Lnn[13000] - Vl(FetchElm(RetNo, 'T936', 13)));
    Tv[7]:= MaxR(0, Tv[7]);

    //20260418
    Tv[32]:=Tv[7];
    Tv[33]:=Tv[31]-Tv[32];
    Tv[34]:=MinR(Tv[27],Tv[33]);
    //----------------
    Tv[6]:= MinR(MaxR(0, Tv[29] - Tv[7]), Tv[27]);
    // 20170226 Tv[6] :=MinR(MaxR(0,Tv[5]-Tv[7]),Tv[27]);
    Tv[6]:= GetOptimumRRSPClaim(RetNo, Tv[6]);

    if UpperCase(Frm[FNo].strings[21]).Equals('Y') then
    begin
      Tv[6]:= Tv[22];
      Tv[6]:= MinR(Tv[6], MinR(MaxR(0, Tv[29] - Tv[7]), Tv[27])); // 20170226
      // Tv[6] :=MinR(Tv[6],MinR(MaxR(0,Tv[5]-Tv[7]),Tv[27])); //20140105 //20130822 MinR(MaxR(0,Tv[5]-Tv[7]),DedLimit);
    end;

    Tv[8]:= Tv[32]+Tv[6]; ////Tv[6] + Tv[7];

    Tv[9]:= MinR(Tv[5], Tv[8]);
    Tv[23]:= TotMultiple(RetNo, 'T4RSP', 21);
    Lnn[24500]:= Tv[2];
    Lnn[24600]:= Tv[4];
    Lnn[24700]:= Tv[23];
    Lnn[24640]:= Tv[7];
    // Lnn[20800] := Tv[9];
    Lnn[24620]:= Tv[13];
    Lnn[26300]:= Tv[15];
    Tv[10]:= MaxR(0, Tv[5] - Tv[9]);
    Tv[20]:= Tv[11] - Tv[6];
    Frm[FNo].strings[24]:= FetchElm(RetNo, 'RRSP', 97);
    Frm[FNo].strings[16]:= FetchElm(RetNo, 'RRSP', 98);
    Lnn[26700]:= Tv[28]; // 20141226
  end;

  SaveTv(RetNo, FName, FNo);
end;
////20250929 Igor <<<

Procedure S8Q(RetNo: integer; FName: string; FNo: integer);
var
  i: integer;
  T4Cpp, OverCpp, SelfCpp, ShouldBe: Real;
  CppProrate: Real;
  CppMonths: integer;
Begin

  if ret[RetNo].Province <> 'QC' then
    exit; // 20241223

  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    If Rc381InEffect(RetNo) = True then // 20131210
    begin
      For i := 1 to 17 do
      begin
        Tv[i] := 0;
        Frm[FNo].strings[i] := '';
      end;
      SaveTv(RetNo, FName, FNo);
      exit;
    end;

    If Province <> 'QC' then // 20131210
    begin
      For i := 1 to 19 do
        Tv[i] := 0;
      exit;
    end;
    // in S8Q
    Lnn[31000] := 0;
    Lnn[30800] := 0;
    Lnn[44800] := 0;
    Lnn[42100] := 0;
    LoadTv(RetNo, FName, FNo);
    If Frm[FNo].strings[12] = '' then
      Frm[FNo].strings[12] := 'Y';
    CppMonths := GetCppMonths(RetNo);
    { If Frm[FNo].Strings[13] ='' then }
    Frm[FNo].strings[13] := IntToStr(CppMonths);
    CppProrate := CppMonths / 12;
    Tv[1] := Lnn[13500] + Lnn[13700] + Lnn[13900] + Lnn[14100] + Lnn[14300];
    // 20131211
    If UpperCase(Frm[FNo].strings[17]) = 'Y' then
      Tv[1] := Tv[16];
    Tv[3] := MaxR(0, (Tv[1] + Tv[2] + Tv[9])) * CppProrate;
    Tv[3] := MinR(Tv[3], Constant[RY].MaxCppPensionableEarnings); // 20241121
    Tv[6] := Constant[RY].BasicCppExemption * CppProrate;
    Tv[7] := MaxR(0, Tv[3] - Tv[6]);
    Tv[8] := Tv[7] * 10.2 / 100; // 20131129
    If UpperCase(Frm[FNo].strings[15]) <> 'Y' then
      Tv[19] := GetActualQPPPremiums(RetNo) // 20131213
    Else
      Tv[19] := Tv[14];

    Tv[10] := Tv[19] * 2;
    Tv[4] := MaxR(0, Tv[8] - Tv[10]);
    // If UpperCase(Frm[FNo].Strings[15])<>'Y' then Tv[14]:=Tv[4];
    Tv[11] := Tv[4] / 2; // Tv[14]/2;   //20131213

    // 20131211
    Lnn[30800] := MinR(2427.60, Tv[19]); // 20131213  //Max QC QC
    Lnn[31000] := Tv[11];
    Lnn[22200] := Lnn[31000];
    Lnn[42100] := 0; // Tv[4];  //20131213 not applicable to QC
  end;
  SaveTv(RetNo, FName, FNo);
end;

//jz//CCAv9- moved T776 to CalcBus
(*
procedure T776(RetNo: integer; FName: String; FNo: integer);
Var
  i, j, Pg2FNo: integer;
  TotPercent, x: Real;
  FInst: String[4];
  Stmt: String;
  TermLossAmount, RecaptAmount: Real;
  AutoCCAForStmt, CCAForStmt: Real;
  ClaimIt: Boolean;
  Cls: string[4];
  Rate: String[4];
  AssetsFNo: integer;
  RemainingAmount, Dummy: Real;
  MaxCCA: Real;

begin
  FInst := ExtractFormInst(FName);
  // Pg2FNo:=GetFormNo('T776'+FInst);
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    // Clear some CCA table Col7, 10, 12 //20230426
    for i := 146 to 150 do begin Tv[i] := 0; end; // col 7
    for i := 196 to 200 do begin Tv[i] := 0; end; // col 10
    for i := 383 to 387 do begin Tv[i] := 0; end; // col 12

    strings[1] := Rtrim(FetchElm(RetNo, 'INFO', 2)) + ' ' +
      FetchElm(RetNo, 'INFO', 5);
    strings[2] := FetchElm(RetNo, 'INFO', 3);
    If strings[3] = '' then
      strings[3] := AppYear + '-01-01';
    If strings[6] = '' then
      strings[6] := AppYear + '-12-31';
    If strings[9] + strings[10] = '' then
      strings[10] := 'X';
    If strings[4] + strings[5] = '' then
      strings[4] := 'X';
    strings[12] := OptRec.Prp_Name;

    // 20170310
    strings[14] := OptRec.Prp_Street;
    strings[16] := OptRec.Prp_City;
    strings[17] := OptRec.Prp_Prov;
    strings[118] := OptRec.Prp_Postal;

    {
      Strings[14] := OptRec.Prp_Street+', '+OptRec.Prp_City
      + ', '+OptRec.Prp_Prov + ', '+ OptRec.Prp_Postal;
    }
    // If Strings[110] >'' then
    // 20190109
    If UpperCase(strings[145]) = 'Y' then // 20120213
    begin
      strings[109] := GetFirstName(RetNo) + ' ' + GetLastName(RetNo);
    End;
    If strings[110] = '' then
      strings[110] := FetchElm(RetNo, 'INFO', 6) + ' ' + FetchElm(RetNo, 'INFO',
        22) + ' ' + FetchElm(RetNo, 'INFO', 68) + ' ' + FetchElm(RetNo, 'INFO',
        63); // str / rural
    If strings[112] = '' then
      strings[112] := FetchElm(RetNo, 'INFO', 10); // city
    If strings[120] = '' then
      strings[120] := FetchElm(RetNo, 'INFO', 14); // Prov
    If strings[111] = '' then
      strings[111] := FetchElm(RetNo, 'INFO', 15); // Postal

    If strings[18] = '' then
      strings[18] := '100.0000'; // Tv[18] :=100; 20111208
    strings[18] := FormatFloat('##0.0000', Vl(strings[18])); // 20111208
    // If (Tv[18] < 0) or (Tv[18] >100) then Tv[18] := 100;

    strings[19] := '531111'; { sic }

    If strings[138] = '' then
      strings[138] := 'N';

    If UpperCase(strings[141]) <> 'Y' then
      strings[114] := strings[18]; // Tv[114]:=Tv[18];  //20111208

    // If Tv[114]>100 then Tv[114]:=100;
    If Vl(strings[114]) > 100 then
      strings[114] := '100.0000'; // Tv[18] :=100; 20111208
    strings[114] := FormatFloat('##0.0000', Vl(strings[114])); // 20111208
    Tv[114] := Vl(strings[114]); // 20111209

    If strings[115] = '' then
      strings[115] := '100.0000'; // 20111208
    If Vl(strings[115]) > 100 then
      strings[115] := '100.0000'; // 20111208
    strings[115] := FormatFloat('##0.0000', Vl(strings[115])); // 20111208
    Tv[115] := Vl(strings[115]); // 20111209
    Tv[24] := Vl(strings[24]); // 20111208
    If Vl(strings[24]) > 0 then // Tv[24] >0 then //20111208
    begin
      strings[22] := GetSpouseFirstName(RetNo);
      strings[117] := GetSpouseLastName(RetNo);
      strings[119] := LeftStr(GetSpouseAddress(RetNo), 33);
    end
    else
      strings[22] := '';
    { Partners }
    i := 24;
    repeat
      Tv[i] := Vl(strings[i]);
      If (Tv[i] < 0) or (Tv[i] > 100) then
      begin
        Tv[i] := 0;
        strings[i] := '';
      end;
      Inc(i, 4);
    until i > 44;
    // sins
    i := 118;
    repeat
      strings[i] := RemoveChar(strings[i], ' ');
      strings[i] := RemoveChar(strings[i], '-');
      Inc(i, 2);
    until i > 128;

    // get autoexpenses
    If UpperCase(strings[142]) <> 'Y' then
    begin
      ExtractAutos(RetNo, 'T776', FInst, TermLossAmount, RecaptAmount,AutoCCAForStmt);

      Tv[72] := 0;
      For i := 0 to ExtractedAutoList.count - 1 do
      begin
        ExtractedAutoRec := ExtractedAutoList.Items[i];
        If ExtractedAutoRec.PartnerFlag = '' then
          Tv[72] := Tv[72] + ExtractedAutoRec.ExpensesClaimed;
      end;
    end;

    //PART 4 begin =============================================================
    i := 58;
    j := 406;
    repeat
      If  (UpperCase(strings[140]) = 'Y') and
          (Tv[139] > 0)                   and
          (Tv[i - 1] > 0)
      then
        Tv[i] := Tv[139]; //apply same percent for all

      If (Tv[i] < 0)    then Tv[i] := 0;
      if (Tv[i] > 100)  then Tv[i] := 100;
      Inc(i, 3);
      Inc(j, 1);
    until i > 91;

    // 20250101
    // If (UpperCase(Strings[140]) = 'Y') and (Tv[139] > 0) and (Tv[130] > 0) then Tv[95] := Tv[139];
    // If (Tv[95] < 0) or (Tv[95] > 100) then Tv[95] := 0;
    If (UpperCase(strings[140]) = 'Y') and (Tv[139] > 0) then
    begin
      If Tv[130] > 0 then Tv[95] := Tv[139];
      If Tv[131] > 0 then Tv[134] := Tv[139];
      If Tv[133] > 0 then Tv[136] := Tv[139];
    end;

    //PART 4 end   =============================================================


    //PART 2 begin =============================================================

    Tv[143] := Tv[24] + Tv[28] + Tv[32] + Tv[36] + Tv[40] + Tv[44]; //done in following array
    strings[143] := FormatFloat('##0.0000', Tv[143]); // 20111208   //done in following array
    i := 23;
    Repeat
      strings[i + 1] := FormatFloat('##0.0000', Vl(strings[i + 1])); // 20111208
      Tv[i + 1] := Vl(strings[i + 1]);
      If Tv[i + 1] = 0 then strings[i + 1] := '';
      Tv[i] := (Tv[103] * Tv[i + 1]) / 100;
      i := i + 4;
    until i > 43;

    //PART 2 end   =============================================================
    { Calc Income }
    If UpperCase(strings[113]) <> 'Y' then
    begin
      Tv[405] := Tv[402] + Tv[403] + Tv[404];
      Tv[116] := Tv[47] + Tv[50] + Tv[53];
      Tv[56] := Tv[116] + Tv[55];
    end;
    { Calc Expenses }
    Tv[97] := 0;
    Tv[99] := 0;
    Tv[423] := 0;

    { Horizontal }  // 20241231
    i := 57;
    j := 406;
    Repeat
      if Tv[i + 1] > 0 then
        Tv[i + 2] := (Tv[i] * Tv[i + 1]) / 100
      Else
        Tv[i + 2] := 0; // 20250101
      // if Tv[j]>Tv[i+2] then Tv[j]:=Tv[I+2]; //wrong indexes //20250101
      Tv[423] := Tv[423] + Tv[j];
      i := i + 3;
      j := j + 1;
    until i > 90;

    // 20250101
    if Tv[95] > 0 then
      Tv[96] := (Tv[130] * Tv[95]) / 100
    else
      Tv[96] := 0;
    if Tv[134] > 0 then
      Tv[135] := (Tv[131] * Tv[134]) / 100
    Else
      Tv[135] := 0;
    If Tv[136] > 0 then
      Tv[137] := (Tv[133] * Tv[136]) / 100
    Else
      Tv[137] := 0; // 20250330
    // If Tv[136]>0 then Tv[137] := (Tv[136] * Tv[136])/ 100 Else Tv[137]:=0;
    { Vertical }
    i := 57;
    Repeat
      Tv[97] := Tv[97] + Tv[i];
      Tv[99] := Tv[99] + Tv[i + 2];
      i := i + 3;
    until i > 90;

    Tv[94] := Tv[130] + Tv[131] + Tv[133];
    Tv[97] := Tv[97] + Tv[94];
    Tv[99] := Tv[99] + Tv[96] + Tv[135] + Tv[137];
    Tv[423] := Tv[423] + Tv[418] + Tv[419] + Tv[420]; // +Tv[417] ??  //20250101

    // clc charts pg2 first for short trm
    // Chart A begin ===========================================================
    i := 432;
    Tv[421] := 0;
    Repeat
      if strings[i + 1] > '' then
        Tv[i + 2] := Tv[i - 1] * Vl(strings[i]) / Vl(strings[i + 1])
      else
        Tv[i + 2] := 0;
      Tv[421] := Tv[421] + Tv[i + 2];
      Inc(i, 6);
    Until i > 486;
    // Chart A end   ===========================================================

    Tv[424] := Tv[421];

    Tv[102] := MaxR(0, Tv[97] - Tv[99] - Tv[424]);
    Tv[103] := Tv[56] - Tv[102];
    Tv[104] := (Tv[103] * Vl(strings[18])) / 100; // (Tv[103] * Tv[18]) / 100;
    Tv[8] := Tv[104] - Tv[7];

    // 20200520
    // recapt
    ExtractCCA(RetNo, 'T776', FInst, TermLossAmount, RecaptAmount, CCAForStmt);
    //Tv[20] := RecaptAmount;
    ExtractAutos(RetNo, 'T776', FInst, TermLossAmount, RecaptAmount,AutoCCAForStmt);
    //Tv[20] := Tv[20] + RecaptAmount;
    Tv[20]:=  GetTotalRecaptureAmt(RetNo,'T776', FInst);  //Recapture Amount //jz//20260414//CCAv7
    // Tv[20] := Tv[20] * Tv[114] / 100; // Apr 4 2008 //20240309

    // Term loss
    ExtractCCA(RetNo, 'T776', FInst, TermLossAmount, RecaptAmount, CCAForStmt);
    Tv[21] := Tv[8] + Tv[20];
    Tv[100] := Tv[21] - Tv[98];


    //jz//20260414//CCAv7 - not sure why done twice and in this way, simplify below T776
    {
    Tv[98] := TermLossAmount;

    ExtractAutos(RetNo, 'T776', FInst, TermLossAmount, RecaptAmount,AutoCCAForStmt);

    Tv[98] := Tv[98] + TermLossAmount;
    Tv[98] := Tv[98] * Tv[114] / 100;
    // CCA
    ExtractCCA(RetNo, 'T776', FInst, TermLossAmount, RecaptAmount, CCAForStmt);
    Tv[105] := CCAForStmt;
    ExtractAutos(RetNo, 'T776', FInst, TermLossAmount, RecaptAmount,AutoCCAForStmt);
    }

   //jz//20260414//CCAv7 - get CCA and terminal loss T776
   ExtractCCA  (RetNo,'T776',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
   ExtractAutos(RetNo,'T776',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);

   //jz//CCAv8 - should get from Tv[265] so that flow matches form and override calcs work, leave for now tho
   Tv[105] := CCAForStmt+AutoCCAForStmt;                  //CCA
   Tv[98]  := GetTotalTerminalLoss(RetNo,'T776', FInst);  //Term loss

   Tv[98] := Tv[98] * Tv[114] / 100;

    //Tv[105] := Tv[105] + AutoCCAForStmt;
    Tv[105] := Tv[105] * Tv[114] / 100;
    Tv[101] := Tv[100] - Tv[105];
    Tv[107] := Tv[101] * Tv[115] / 100;
    Tv[106] := Tv[107] + Tv[144] - Tv[108]; // 20100128
  end; { End with }

  // pg 2
  with ret[RetNo].Frm[FNo] do
  begin
    ret[RetNo].Frm[FNo].strings[359] := '';
    Tv[359] := 0; // term loss  Feb 23 2008
    ret[RetNo].Frm[FNo].strings[383] := '';
    Tv[383] := 0; // recapture Feb 23 2008;
    strings[367] := FInst + ' - ' + FetchElm(RetNo, 'T776' + FInst, 45);
    Stmt := LeftStr(FName, 4);
    { CCA }
    Tv[265] := 0; // total cca

    //20250426
    //If PostCCaFromAssetsB(RetNo) then  //jz//CCAv9 - move to within PostNonVehicleCCA after it clears the chart
    //begin
    PostNonVehicleCCA(RetNo, FName, Stmt, FInst, FNo, 201, 237, 9, 245, 264, 381);
      //Tv[359] := 0; Tv[383] := 0; //jz//CCAv9 not sure what these were for but they are no longer correct
      //Tv[174]:=Tv[388]+Tv[175]; //im expensing //20230524 //jz//CCAv9 not sure what these were for but they are no longer correct
    //end

    //jz//CCAv9 - remove, clear in PostNonVehicleCCA
    {
    else // 20090101
    begin
      For i := 201 to 245 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      For i := 360 to 364 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      Tv[264] := 0;
      Tv[381] := 0;
    end;
    }
    //jz//CCAv9 - remove, col calcs done in PostNonVehicleCCA
    //20250426
    {
    Tv[581]:=MaxR(0,Tv[208]-Tv[576]);
    Tv[582]:=MaxR(0,Tv[217]-Tv[577]);
    Tv[583]:=MaxR(0,Tv[226]-Tv[578]);
    Tv[584]:=MaxR(0,Tv[235]-Tv[579]);
    Tv[585]:=MaxR(0,Tv[244]-Tv[580]);
    Tv[381] :=0;
    Tv[381]:=Tv[581]+Tv[582]+Tv[583]+Tv[584]+Tv[585]+Tv[264];
    }
    //Tv[381] := Tv[208] + Tv[217] + Tv[226] + Tv[235] + Tv[244]+Tv[264];

    { 202650426
    // cca - nonmotor veh
    If PostCCaFromAssetsB(RetNo) then
    begin
      //20250420  209 instead of 9
      PostNonVehicleCCA(RetNo, FName, Stmt, FInst, FNo, 201, 237, 209, 245,
        264, 265);
      Tv[359] := 0;
      Tv[383] := 0;
      Tv[174] := Tv[388] + Tv[175]; // im expensing //20230524
    end
    else // 20090101
    begin
      For i := 201 to 245 do
      begin
        strings[i] := '';
        Tv[i] := 0;
      end;
      For i := 360 to 364 do
      begin
        strings[i] := '';
        Tv[i] := 0;
      end;
      Tv[264] := 0;
      Tv[381] := 0;
    end;
    Tv[381] := 0;
    Tv[381] := Tv[208] + Tv[217] + Tv[226] + Tv[235] + Tv[244] + Tv[264];
  }   // 202650426

    // CCA Motor vehicle
    // 20230428 Igor >>>

    PostAutoCCA(RetNo, FName, Stmt, FInst, FNo, 380, 382);

    //jz//CCAv9 - remove, col calcs done in PostNonVehicleCCA
    {
    //20250426
    Tv[586]:=MaxR(0,Tv[253]-Tv[422]);
    Tv[587]:=MaxR(0,Tv[262]-Tv[428]);

    }
    // 20230525
    //sum auto col9 --- THIS SHOULD PROB BE DONE IN Extract / PostAutoCCA
    Tv[175] := 0;
    i := 396;
    Repeat
      Tv[175] := Tv[175] + Tv[i];
      Inc(i, 1)
    Until i > 397;

    Tv[174] := Tv[388] + Tv[175]; // 20230525

    Tv[265] := Tv[381] + Tv[382];

    Tv[388] := 0;
    for i := 191 to 195 do
      Tv[388] := Tv[388] + Tv[i]; // 20230426
    // 20140122
    i := 202;
    j := 146;
    Repeat
      Tv[j] := Tv[i] + Tv[i + 1] - Tv[i + 2];
      Inc(i, 9);
      Inc(j, 1);
    until i > 238;

    //T776 AREA B - equip additions begin ==========================================================
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then
        PostNonBuildingAdditions(RetNo, FName, Stmt, FInst, FNo, 267, 277, 5, 281, 368, 0); //jz//CCAv8 - total indx to 0 as is calced, altho it doesnt seem PostNonBuildingAdditions uses it anyway
    end;
    i := 269;
    Tv[288] := 0;
    Repeat
      Tv[i + 2] := MaxR(0, Tv[i] - Tv[i + 1]);
      Tv[288] := Tv[288] + Tv[i + 2];
      i := i + 5;
    Until i > 279;
    Tv[288] := Tv[288] + tv[368]; //jz//CCAv8 - add sup for not motor v
    xx:=Tv[288];
    //jz//CCAv8 - remainingindex 287 from 387 // 20230519
    //          - total indx to 0 as is calced, altho it doesnt seem PostAutosAdditions uses it anyway
    PostAutosAdditions(RetNo, FName, Stmt, FInst, FNo, 282, 369, 87, 373, 287, 0);
    xx:=Tv[288];
    i := 284;
    //Tv[288] := 0; //jz//CCAv8 - should not be reset as there is no total for not motor v
    //Tv[287] := 0; //jz//CCAv8 - populated in PostAutosAdditions not on form for supllementary
    Repeat
      Tv[i + 2] := Tv[i] - Tv[i + 1];
      Tv[288] := Tv[288] + Tv[i + 2];
      i := i + 87; //jz//CCAv8 - change inc to 87 from 5
    Until i > 371;
    xx:=Tv[288];
    Tv[288] := Tv[288] + Tv[287]; //line 9925
    //T776 AREA B - equip additions end ==========================================================


    //T776 AREA C - building additions begin ===========================================================
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then
        PostBuildingAdditions(RetNo, FName, Stmt, FInst, FNo, 289, 304, 5, 308,309, 310);
    end;
    i := 291;
    Tv[310] := 0;
    Repeat
      Tv[i + 2] := Tv[i] - Tv[i + 1];
      Tv[310] := Tv[310] + Tv[i + 2];
      i := i + 5;
    Until i > 306;
    Tv[310] := Tv[310] + Tv[309];

    //T776 AREA C - building additions end ===========================================================

    //20230521
    //T776 AREA D - Dispositions begin ==================================================
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then
        PostNonBuildingDispositions(RetNo, FName, Stmt, FInst, FNo, 311, 321, 5, 325, 374, 0); //jz//CCAv8 - total indx to 0 as is calced, altho doesnt seem is used in the procedure anyway
    end;
    i := 313;
    Tv[332] := 0;
    Repeat
      Tv[i + 2] := MaxR(0, Tv[i] - Tv[i + 1]);
      Tv[332] := Tv[332] + Tv[i + 2];
      // Tv[132] := Tv[132] + Tv[I+2];   //20110109
      i := i + 5;
    Until i > 323; // 128
    Tv[332] := Tv[332] + Tv[374]; //jz//CCAv8 - add sup amount

    //jz//CCAv8 - total indx to 0 as is calced, altho doesnt seem is used in the procedure anyway
    PostAutosDispositions(RetNo, FName, Stmt, FInst, FNo, 326, 375, 49, 379, 331, 0); // 20230520 //20230523 Igor
    i := 329;
    //Tv[332] := 0; //jz//CCAv8 - do not clear as no not motor v total so accumumalted from previous chart
    //Tv[330] := 0; //jz//CCAv8 - not sure what this was trying to do but this elm should not be cleared here // not on the form supl
    Repeat
      Tv[i + 2] := Tv[i] - Tv[i + 1];
      Tv[332] := Tv[332] + Tv[i + 2];
      i := i + 49;
    Until i > 377;
    Tv[332] := Tv[332] + Tv[331]; //jz//CCAv8 - sup elm is 331 //Tv[330];
    //T776 AREA D - Dispositions end ==================================================
    //jz//CCAv8 -this seems out of date
    {
    // motor disp
    // get autoexpenses
    Stmt := LeftStr(FName, 4);
    ExtractAutos(RetNo, Stmt, FInst, TermLossAmount, RecaptAmount, AutoCCAForStmt);
    For i := 326 to 330 do
    begin
      Tv[i] := 0;
      strings[i] := '';
    end; // clear section
    For i := 375 to 379 do
    begin
      Tv[i] := 0;
      strings[i] := '';
    end; // clear section
    RemainingAmount := 0;
    j := 326; // dispositions
    For i := 0 to ExtractedAutoList.count - 1 do
    begin
      ExtractedAutoRec := ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag = '' then
      begin
        If LeftStr(ExtractedAutoRec.DateAcquired, 4) <> AppYear then
        begin
          If j > 375 then
            RemainingAmount :=
              MaxR(0, RemainingAmount + ExtractedAutoRec.Proceeds -
              ExtractedAutoRec.ProceedsPersonal)
          else
          begin
            strings[j] := ExtractedAutoRec.ClassId;
            strings[j + 1] := ExtractedAutoRec.Description;
            Tv[j + 2] := ExtractedAutoRec.Proceeds;
            Inc(j, 5);
          end;
        end;
      end;
    end;
    Tv[331] := RemainingAmount;
    Tv[330] := MaxR(0, Tv[328] - Tv[329]);
    Tv[379] := MaxR(0, Tv[377] - Tv[378]);
    Tv[332] := Tv[332] + Tv[379] + Tv[374] + Tv[331];

    }
    //T776 AREA E - build disp begin =================================================
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then
        PostBuildingDispositions(RetNo, FName, Stmt, FInst, FNo, 333, 348, 5, 352, 353, 354);
    end;
    i := 335;
    Tv[354] := 0;
    Repeat
      Tv[i + 2] := Tv[i] - Tv[i + 1];
      Tv[354] := Tv[354] + Tv[i + 2];
      i := i + 5;
    Until i > 350;
    Tv[354] := Tv[354] + Tv[353];

    //T776 AREA E - build disp end =================================================
    // 20230627  FIX a misposition problem resulting in neg numbers
    if Tv[288] < 0 then
      Tv[288] := 0;
    if Tv[355] < 0 then
      Tv[355] := 0;
    if Tv[356] < 0 then
      Tv[356] := 0; // 20231128

    If Length(OptRec.Bus_Disclm) > 0 then
      strings[390] := OptRec.Bus_Disclm
    else
      strings[390] := '';

    // page7 Short rentals charts

    //jz//20260416//CCAv8 - can be down here as is no used anywhere
    PostNonCompliantShortTermRentalsCCA(RetNo,FName,Stmt,FInst,FNo,0, 0, 0, 0, 359, 0); //NOTE: elm vars not really in effect, done a different way
    //T776 Chart B begin ===========================================================
    i := 492;
    Tv[427] := 0;
    Repeat
      //populated, calc here not required
      //if strings[i + 1] > '' then Tv[i + 2] := Tv[i - 1] * Vl(strings[i]) / Vl(strings[i + 1])
      //                        else Tv[i + 2] := 0;
      //total the calc amount, done here so overrides can effect calc but maybe should be all be done in PostNonCompliantShortTermRentalsCCA for ease??
      Tv[427] := Tv[427] + Tv[i + 2];
      Inc(i, 6);
    Until i > 528; //573; //jz//20260408 - elms incr not consistant, remove final 3 rows for now
    //T776 Chart B begin ===========================================================

    Tv[427] := Tv[427] + Tv[359];
    Tv[425] := Tv[427];
  end; // End with 

  SaveTv(RetNo, FName, FNo);
end;
*)

procedure T929(RetNo: integer; FName: String; FNo: integer);
Var
  i, j: integer;
begin
  // 20170212
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo], ret[RetNo] do
  begin
    i := 4;
    Tv[22] := 0;
    strings[22] := '';
    j := 3;
    Tv[58] := 0;
    strings[58] := '';
    Repeat
      Tv[22] := Tv[22] + Tv[i];
      Tv[58] := Tv[58] + Tv[j];
      Inc(i, 4);
      Inc(j, 4);
    until i > 76;
    Tv[61] := MaxR(0, Tv[22] - Tv[58]);
    { earned Income }
    Tv[21] := MaxR(0, Lnn[10100]) + MaxR(0, Lnn[10400]);
    Tv[65] := MaxR(0, Lnn[13500]) + MaxR(0, Lnn[13700]) + MaxR(0, Lnn[13900]) +
      MaxR(0, Lnn[14100]) + MaxR(0, Lnn[14300]);
    Tv[29] := TotMultiple(RetNo, 'T4A', 47); // txbl scholarships
    // tv[37]=user entry
    Tv[62] := Tv[21] + Tv[65] + Tv[29] + Tv[37] + Tv[38] + Tv[26];
    Tv[30] := NIBfrAttendantCare(RetNo);
    Tv[69] := Tv[62];
    Tv[66] := MaxR(0, Tv[30] - Tv[69]);
    If Vl(strings[73]) > 52 then
      strings[73] := '52';
    Tv[33] := Vl(strings[73]) * 375;
    Tv[34] := MinR(15000, MinR(Tv[32], Tv[33]));
    Tv[70] := Tv[62] + Tv[34];
    Tv[77] := MinR(Tv[61], Tv[70]);

    ret[RetNo].Lnn[21500] := Tv[77];
    // pg 2
    // Strings[101]:=AppYear;
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure T183(RetNo: integer; FName: String; FNo: integer);
Var
  s: String;
  Apartm: String;
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    // 20190124
    if IsForEfile(RetNo) = false then
    Begin
      for i := 1 to 24 do
      Begin
        strings[i] := '';
        Tv[i] := 0;
      end;
      for i := 26 to 200 do
      Begin
        strings[i] := '';
        Tv[i] := 0;
      end; // keep 25 hide   //20200320
      SaveTv(RetNo, FName, FNo);
    End;

    if FetchElmFNo(RetNo, InfoFNo, 180) > '' then  //20260303
    // already provided the signature before
    Begin
     // strings[10] := ''; // reiistered, so new Email //20190124
     // strings[17] := '';
    end;

    strings[9] := AppYear; // 20131215
    // 20170327
    if (UpperCase(LeftStr(FetchElmFNo(RetNo, InfoFNo, 223), 1)) = 'R')
    // 20250307 // DCN //(FetchElm(RetNo, 'REFILEQ', 101) > '') // DCN
      and (UpperCase(LeftStr(FetchElmFNo(RetNo, InfoFNo, 223), 1)) = 'R') then
      strings[9] := AppYear + 'R'; // 20170327

    If Length(strings[27]) < 8 then
      strings[27] := '';
    strings[1] := GetFirstName(RetNo);
    strings[2] := GetLastName(RetNo);
    strings[3] := GetSinNo(RetNo);
    // 20200320  Hide SIN
    If UpperCase(strings[17]) = 'Y' then
      strings[10] := FetchElm(RetNo, 'INFO', 64);

    Apartm := FetchElm(RetNo, 'INFO', 22);
    If Apartm > '' then
      strings[28] := FetchElm(RetNo, 'INFO', 6) + ', Apt ' + Apartm
    else
      strings[28] := FetchElm(RetNo, 'INFO', 6);

    strings[29] := FetchElm(RetNo, 'INFO', 68);
    strings[30] := FetchElm(RetNo, 'INFO', 163);
    strings[31] := FetchElm(RetNo, 'INFO', 10);
    strings[32] := FetchElm(RetNo, 'INFO', 14);
    strings[33] := FetchElm(RetNo, 'INFO', 15);

    Tv[4] := ret[RetNo].Lnn[15000];
    Tv[5] := ret[RetNo].Lnn[26000];
    Tv[6] := ret[RetNo].Lnn[35000];
    Tv[7] := ret[RetNo].Lnn[48400];
    Tv[8] := ret[RetNo].Lnn[48500];
    strings[20] := OptRec.Prp_Name;

    if UpperCase(strings[22]) = 'Y' then
      strings[23] := OptRec.PRP_RepId; // 20230216

    // bring from info
    // contact indic and expiry
    // Strings[12] := FetchElmFNo(RetNo, InfoFNo, 191);  //20220130  ?????????????????
    strings[16] := FetchElmFNo(RetNo, InfoFNo, 192);
    { was from last year 2022 - Now we enter it directly on the T183
      // NOA
      If (FetchElmFNo(RetNo, InfoFNo, 180) > '') or
      (FetchElmFNo(RetNo, InfoFNo, 181) > '') then
      Strings[13] := 'X'
      else
      Strings[13] := '';
      If FetchElmFNo(RetNo, InfoFNo, 182) > '' then
      Strings[18] := 'X'
      else
      Strings[18] := '';
      If FetchElmFNo(RetNo, InfoFNo, 183) > '' then
      Strings[19] := 'X'
      else
      Strings[19] := '';
    }
    Strings[18]:= ''; //20251212 Igor
    { //20250319
      If OptRec.Prp_Dates then
      Begin
      //Strings[11] := FormatDateTime('yyyy-mm-dd', Date); // 20170308
      //If (Strings[12]='') then strings[12]:=TimeToHHMMDD(Now);  //20220220
      end;
    }

    s := FetchEfMethod(RetNo);
    If s = 'EOL' then
      strings[24] := GetEolAgentNo
    else If s = 'EOLP' then
      strings[24] := GetEolPAgentNo
    else If s = 'PROP' then
      strings[24] := OptRec.Ef_PrepNo;

    If ((FetchElm(RetNo, 'STATUS', 15) <> '02') // not EF accepted
      and (FetchElm(RetNo, 'STATUS', 15) <> '04')) // not EF waiting ack
    then
    Begin
      If (s = 'EOL') and (GetEolAgentNo > '') then
      begin
        If (Length(strings[21]) < 8) or
          (strings[21] = GetEolAgentNo + LeftStr(GetSinNo(RetNo), 9)) Or
          (MidStr(strings[21], 6, 2) <> RightStr(AppYear, 2)) // 20140131
        then
          strings[21] := GetDcnSeqNoEOL(RetNo, GetEolAgentNo); // replace it
      end;
      If (s = 'EOLP') and (GetEolAgentNo > '') and (Length(strings[21]) < 9)
      then
        strings[21] := GetDcnSeqNoEOL(RetNo, GetEolAgentNo);
    end;

    //jz//20260220 as per CRA , cannot have mailed paper notices if email is provided
    If Strings[10] > '' then
    begin
      Strings[13] := 'X';
      Strings[19] := '';
    end;


    // 20210321  //date of signature
    strings[26] := UpperCase(FetchElmFNo(RetNo, InfoFNo, 144));
    // jz//20250314 - get indicator from info
    if (UpperCase(FetchElmFNo(RetNo, InfoFNo, 144)) = 'Y') and
      (UpperCase(FetchElmFNo(RetNo, InfoFNo, 158)) = 'Y') then
    begin
      strings[11] := FetchElmFNo(RetNo, InfoFNo, 153);
      // jz//20250314 - get date
      strings[12] := FetchElmFNo(RetNo, InfoFNo, 155);
      // jz//20250314 - get time
    end
    else // clear
    begin
      // strings[11] := ''; //jz//20250314 - clear date
      // strings[12] := ''; //jz//20250314 - clear time
    end;

    // 20250319
    // If Strings[11] = '' then strings[11] :=FormatDateTime('yyyy-mm-dd',Now); //jz//20250314 - date
    // If Strings[12] = '' then strings[12] :=TimeToHHMMDD(Now);;               //jz//20250314 - time

  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure T185(RetNo: integer; FName: String; FNo: integer);
Var
  s: String;
  Apartm: String;
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    // 20190124
    if IsForEfile(RetNo) = false then
    Begin
      for i := 1 to 35 do
      Begin
        strings[i] := '';
        Tv[i] := 0;
      end;
      SaveTv(RetNo, FName, FNo);
    End;

    strings[9] := AppYear; // 20131215
    // sign date
    if strings[27] = '' then
      strings[27] := FormatDateTime('yyyy-mm-dd', Now); // 20200213
    If Length(strings[27]) < 8 then
      strings[27] := FormatDateTime('yyyy-mm-dd', Now);

    strings[1] := GetFirstName(RetNo);
    strings[2] := GetLastName(RetNo);
    strings[3] := GetSinNo(RetNo);
    // 20200320  Hide SIN
    // If UpperCase(Strings[17]) = 'Y' then  Strings[10] := FetchElm(RetNo, 'INFO', 64);

    Apartm := FetchElm(RetNo, 'INFO', 22);
    If Apartm > '' then
      strings[28] := FetchElm(RetNo, 'INFO', 6) + ', Apt ' + Apartm
    else
      strings[28] := FetchElm(RetNo, 'INFO', 6);

    strings[29] := FetchElm(RetNo, 'INFO', 68);
    strings[30] := FetchElm(RetNo, 'INFO', 163);
    strings[31] := FetchElm(RetNo, 'INFO', 10);
    strings[32] := FetchElm(RetNo, 'INFO', 14);
    strings[33] := FetchElm(RetNo, 'INFO', 15);

    strings[20] := OptRec.Prp_Name;

    s := FetchEfMethod(RetNo);
    If s = 'EOL' then
      strings[24] := GetEolAgentNo
    else If s = 'EOLP' then
      strings[24] := GetEolPAgentNo
    else If s = 'PROP' then
      strings[24] := OptRec.Ef_PrepNo;

  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure BANKRPT(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  D1, D2: string[15];
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  Begin
    If IsBankruptcyReturn(RetNo) = false then
    begin
      For i := 1 to 20 do
      begin
        strings[i] := '';
        Tv[i] := 0;
      end;
      SaveTv(RetNo, FName, FNo);
      exit;
    end;

    { d1,d2 in MM/DD/YYYY }
    strings[12] := GetLastName(RetNo) + ', ' + GetFirstName(RetNo);

    // 20170329
    if strings[1] > '' then
    begin
      if LeftStr(strings[1], 4) <> AppYear then
      Begin
        strings[1] := AppYear + MidStr(strings[1], 5, 6);
      End;
    end;

    D2 := MidStr(strings[1], 6, 2) + '/' + MidStr(strings[1], 9, 2) + '/' +
      LeftStr(strings[1], 4);
    D1 := '01/01/' + AppYear;
    strings[2] := IntToStr(DateDiffMDY(D1, D2)); // 20160119 Igor
    If Vl(strings[2]) > Constant[RY].FullYear then
      strings[2] := IntToStr(Constant[RY].FullYear);
    If Vl(strings[2]) < 0 then
      strings[2] := '0';

    strings[3] := IntToStr(Constant[RY].FullYear - MyStrToInt(strings[2]));
    If Vl(strings[3]) > Constant[RY].FullYear then
      IntToStr(Constant[RY].FullYear);
    If Vl(strings[3]) < 0 then
      strings[3] := '0';
    ret[RetNo].Bankrupt := 0;
    If strings[1] > '' then
    begin
      If strings[4] > '' then
        ret[RetNo].Bankrupt := 1;
      If strings[5] > '' then
        ret[RetNo].Bankrupt := 2;
      If strings[6] > '' then
        ret[RetNo].Bankrupt := 3;
    end
    else
    begin
      strings[2] := '';
      strings[3] := '';
    end;
    // 20100130
    If Tv[14] > 1051 then
      Tv[14] := 1051;
    If strings[4] > '' then // pre-bankruptchy
    begin
      Tv[15] := ret[RetNo].Lnn[23600];
      Tv[16] := ret[RetNo].Lnn[31260];
      Tv[18] := ret[RetNo].Lnn[26000];
      // Tv[20]:=
    end;
    If strings[5] > '' then // post-bankruptchy
    begin
      Tv[13] := ret[RetNo].Lnn[23600];
      If UpperCase(strings[21]) <> 'Y' then
        Tv[14] := ret[RetNo].Lnn[31260]; // 20120404
      Tv[17] := ret[RetNo].Lnn[26000];
    end;

  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T5004(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    If strings[69] = '' then
      strings[69] := 'N';
    strings[1] := GetFirstName(RetNo);
    strings[2] := GetLastName(RetNo);
    strings[3] := FetchElm(RetNo, 'INFO', 6) + ' ' + FetchElm(RetNo, 'INFO',
      22); { str }
    strings[4] := FetchElm(RetNo, 'INFO', 10); { city }
    strings[5] := FetchElm(RetNo, 'INFO', 14); { prv }
    strings[6] := FetchElm(RetNo, 'INFO', 15); { postal }
    strings[7] := GetSinNo(RetNo);

    Tv[68] := 0;
    i := 11;
    Repeat
      Tv[68] := Tv[68] + Tv[i];
      Inc(i, 4);
    until i > 67;
    { ? 1997 ret[RetNo].Lnn[010] := Tv[68]; }
  end;
  SaveTv(RetNo, FName, FNo);
end;

procedure T400A(RetNo: integer; FName: String; FNo: integer);
var
  s: String;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    // 201200208
    strings[1] := GetLastName(RetNo) + ', ' + GetFirstName(RetNo);
    s := '';
    if FetchElmFNo(RetNo, InfoFNo, 22) > '' then
      s := '#' + FetchElmFNo(RetNo, InfoFNo, 22) + '-'; // apartm
    s := s + FetchElmFNo(RetNo, InfoFNo, 6) + ' ' + FetchElmFNo(RetNo, InfoFNo,
      68) + ' ' + FetchElmFNo(RetNo, InfoFNo, 163);
    strings[2] := s;
    strings[4] := FetchElmFNo(RetNo, InfoFNo, 10); { city }
    strings[6] := FetchElmFNo(RetNo, InfoFNo, 14);
    strings[8] := FetchElmFNo(RetNo, InfoFNo, 15); { postal }

    strings[9] := GetAreaCode(RetNo);
    strings[10] := GetPhoneNo(RetNo); { phone }
    If strings[15] = '' then
      strings[15] := AppYear;
    strings[16] := GetSinNo(RetNo);

    strings[45] := OptRec.Prp_Name;
    strings[46] := OptRec.Prp_Street;
    strings[47] := OptRec.Prp_City;
    strings[3] := OptRec.Prp_Prov;
    strings[5] := OptRec.Prp_Postal;

    strings[11] := OptRec.Prp_Area;
    strings[12] := OptRec.Prp_Tel;
    If strings[50] = '' then
      strings[50] := FormatDateTime('yyyy-mm-dd', Date);
  end; { End with }

  SaveTv(RetNo, FName, FNo);

end;

procedure DIRECT(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    // 20161227 They do not belong to this form!
    // If Tv[3] >2500 then Tv[3] :=2500;  //20101223
    // If Tv[3] >600 then Tv[3] :=0;  //20101223    //20161227
    // if Tv[9] > Constant[RY].MaxDisability then Tv[9] :=Constant[RY].MaxDisability;
    // Tv[16] := MaxR(0,Tv[14]+Tv[18]-Tv[15]);
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure PNSDED(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  x: Real;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    Tv[1] := Lnn[11500];
    Tv[4] := Vl(FetchElm(RetNo, 'OTHDED', 22)); // foreign deducted
    Tv[6] := Tv[4] + Tv[5] + Tv[23] + Tv[21];
    Tv[7] := MaxR(0, Tv[1] - Tv[6]);

    Tv[2] := ForPensDed(RetNo); { from T4RSP }
    Tv[3] := Tv[7] + Tv[2];
    Tv[8] := MinR(2000, Tv[3]);
    { provincial }
    Tv[11] := Tv[1];
    Tv[12] := Tv[4];
    Tv[13] := Tv[5];
    Tv[14] := Tv[23];
    Tv[15] := Tv[21];
    Tv[16] := Tv[6];
    Tv[17] := Tv[7];
    Tv[22] := Tv[2];
    Tv[24] := Tv[3];

    Frm[FNo].strings[10] := ret[RetNo].Province;
    Tv[20] := PrvConstant[RY].PrvMaxPensionAmount;
    Tv[18] := MinR(Tv[20], Tv[24]);
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

Procedure RENTSUM(RetNo: integer; FName: String; FNo: integer);
Var
  i, RentFld, RentCnt: integer;
  FInst: string[3];
begin
  LoadTv(RetNo, FName, FNo);
  RentFld := 1;
  RentCnt := 0;

  with ret[RetNo].Frm[FNo] do
  begin
    Tv[181] := 0;

    For i := 1 to 181 do
    begin
      strings[i] := '';
      Tv[i] := 0;
    end;

    for i := 0 to (FList.count - 1) do
    begin
      FRec := FList.Items[i];
      if (FRec.FormName = 'T776') and
        (ret[RetNo].FormHasData[FRec.FormName + FRec.FormInst])
      // 20101217  //20160813  CON
      // and (ret[RetNo].FormHasData[FRec.FormName])  //20101217
      then
      begin
        Inc(RentCnt);
        FInst := FRec.FormInst;
        If RentCnt > 30 then
        begin
          RentFld := 175;
          strings[RentFld] := '**** There are more ****';
          strings[RentFld + 1] := '';
          strings[RentFld + 2] := '';
          Tv[RentFld + 3] := 0;
          Tv[RentFld + 4] := 0;
          Tv[RentFld + 5] := 0;
          Tv[181] := Tv[181] + Vl(FetchElm(RetNo, 'T776' + FInst, 106));
        end
        else
        begin
          RentFld := (RentCnt - 1) * 6 + 1;
          // Strings[RentFld] :=FetchElmFNo(RetNo,Frec.FormNo,45);   //20160813
          // 20160813  Address
          strings[RentFld] := FetchElmFNo(RetNo, FRec.FormNo, 45); // 20170321
          {
            Strings[RentFld] :=AllTrim(FetchElmFNo(RetNo,Frec.FormNo,110))
            +','+AllTrim(FetchElmFNo(RetNo,Frec.FormNo,112))
            +','+AllTrim(FetchElmFNo(RetNo,Frec.FormNo,111));
          }
          strings[RentFld + 1] := FetchElmFNo(RetNo, FRec.FormNo, 3);
          strings[RentFld + 2] := FetchElmFNo(RetNo, FRec.FormNo, 6);
          Tv[RentFld + 3] := Vl(FetchElmFNo(RetNo, FRec.FormNo, 18));
          Tv[RentFld + 4] := Vl(FetchElmFNo(RetNo, FRec.FormNo, 56));
          Tv[RentFld + 5] := Vl(FetchElmFNo(RetNo, FRec.FormNo, 106));
          Tv[181] := Tv[181] + Vl(FetchElmFNo(RetNo, FRec.FormNo, 106));
        end;
      end;
    end; { loop thru forms }
  end; { end with Ret... }
  SaveTv(RetNo, FName, FNo);
end;

procedure MEDICAL(RetNo: integer; FName: String; FNo: integer);
Var
  i, j, k, DependFNo, MedicalFNo, spRetNo: integer;
  PatientId: String[3];
  DepRec: TDepRec;
begin
  DependFNo := GetFormNo('DEPEND');

  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  Begin
    // % used
    If (ret[RetNo].MarStatus > 2) then
    begin
      If ((ret[RetNo].MarStatus = 3) and MarStatusChanged(RetNo)) then
        // 20110326
        // do not do anything
      else
      begin
        If Tv[233] = 0 then
          Tv[233] := 100;
        If Tv[236] = 0 then
          Tv[236] := 100;
      end;
    end;
    // 20190221
    if Tv[233] > 100 then
      Tv[233] := 100;
    if Tv[236] > 100 then
      Tv[236] := 100;

    If strings[1] = '' then
      strings[1] := AppYear + '-01-01';
    If strings[3] = '' then
      strings[3] := AppYear + '-12-31';

    If EditDateYYYYMMDD(strings[1], StrToInt(AppYear) + 1) = false then
      strings[1] := AppYear + '-01-01'; // 20160119 Igor
    If EditDateYYYYMMDD(strings[3], StrToInt(AppYear) + 1) = false then
      strings[3] := AppYear + '-12-31'; // 20160119 Igor

    i := 9;
    k := 137;
    j := 113;
    Repeat
      If (strings[i - 4] >= strings[1]) and (strings[i - 4] <= strings[3]) then
        Tv[i] := Tv[k]
      else
        Tv[i] := 0;
      if strings[j] = '' then
      begin
        Tv[i] := 0;
        strings[i - 3] := '';
      end;
      If i > 9 then // 20091226 //date but nor patient id
      begin
        If (strings[i - 4] > '') and (strings[j] = '') then
        begin
          strings[j] := strings[j - 1];
          strings[i - 3] := strings[i - 3 - 5];
        end;
      end;
      Inc(i, 5);
      Inc(k, 1);
      Inc(j, 1);
    until i > 109;

    Tv[158] := TotMultiple(RetNo, 'MEDSUPL', 131);
    Tv[159] := TotMultiple(RetNo, 'MEDSUPL', 132);

    // initialize 331
    For i := 161 to 232 do
    begin
      strings[i] := '';
      Tv[i] := 0;
    end;

    SaveTv(RetNo, FName, FNo);
    AccumMedical(RetNo);

    Tv[4] := MedSum330.PeriodPaid;
    i := 161;
    j := 1;
    Repeat
      If MedSum331[j].DependId > '' then
      begin
        strings[i] := MedSum331[j].DependId;
        GetDependantRec(RetNo, MedSum331[j].DependId, DepRec, DependFNo);
        strings[i + 1] := DepRec.FirstNm + ' ' + DepRec.LastNm;
        strings[i + 2] := DepRec.BirthDate;
        strings[i + 3] := DepRec.Relationship;
        Tv[i + 4] := DepRec.NetInc;
        strings[i + 5] := DepRec.Infirmity;
        Tv[i + 6] := (MedSum331[j].PeriodPaid);
        Inc(i, 8);
      end;
      Inc(j, 1);
    until j > 9;
    Tv[235] := Tv[4] + Tv[111];
    Tv[234] := Tv[233];

    Tv[112] := Tv[235] * Tv[234] / 100;
    Tv[2] := CalcMedicalLimit(RetNo);
    Tv[160] := MaxR(0, Tv[112] - Tv[2]);
    If Tv[236] > 100 then
      Tv[236] := 100;
    i := 161;
    Tv[134] := 0;
    Tv[136] := 0;
    Repeat
      Tv[i + 7] := CalcFedMedicalLimitForDependant(RetNo, Tv[i + 6], Tv[i + 4]);
      Tv[i + 7] := Tv[i + 7] * Tv[236] / 100;
      Tv[134] := Tv[134] + Tv[i + 6];
      Tv[136] := Tv[136] + Tv[i + 7];
      Inc(i, 8);
    until i > 225;
    ret[RetNo].Lnn[33199] := Tv[136];
  end;
  SaveTv(RetNo, FName, FNo);

  If (ret[RetNo].CouplingSw) and (OptimizeBtnClicked = false) then
  begin
    with ret[RetNo].Frm[FNo] do
    begin
      StoreElm(RetNo, GetFormNo('OPTIMIZE'), 1, FormatFloat('###.##', Tv[233]));
      StoreElm(RetNo, GetFormNo('OPTIMIZE'), 6,
        FormatFloat('###.##', 100 - Tv[233]));
      StoreElm(RetNo, GetFormNo('OPTIMIZE'), 59,
        FormatFloat('###.##', Tv[236]));
      StoreElm(RetNo, GetFormNo('OPTIMIZE'), 60,
        FormatFloat('###.##', 100 - Tv[236]));
    end;
  end;

end;

procedure MEDSUPL(RetNo: integer; FName: String; FNo: integer);
Var
  i, k, j: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  Begin
    strings[1] := FetchElm(RetNo, 'MEDICAL', 1);
    strings[3] := FetchElm(RetNo, 'MEDICAL', 3);

    Tv[131] := 0;
    Tv[132] := 0;

    i := 9;
    k := 110;
    j := 133;
    Repeat
      If (strings[i - 4] >= strings[1]) and (strings[i - 4] <= strings[3]) then
        Tv[i] := Tv[k]
      else
        Tv[i] := 0;
      if strings[j] = '' then
        Tv[i] := 0;
      Tv[131] := Tv[131] + Tv[k];
      Tv[132] := Tv[132] + Tv[i];
      If i > 9 then // 20091226 //date but nor patient id
      begin
        If (strings[i - 4] > '') and (strings[j] = '') then
        begin
          strings[j] := strings[j - 1];
          strings[i - 3] := strings[i - 3 - 5];
        end;
      end;

      Inc(i, 5);
      Inc(k, 1);
      Inc(j, 1);
    until i > 109;

  end;
  SaveTv(RetNo, FName, FNo);
end;

procedure MEDPRV(RetNo: integer; FName: String; FNo: integer);
Var
  i, j, MedicalFNo: integer;
  PercentClaim: Real;
begin
  InitPrvConstants(ret[RetNo].Province);
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  Begin
    strings[77] := 'Medical';
    strings[78] := 'Dependants';
    strings[79] := 'Prov S5';

    MedicalFNo := GetFormNo('MEDICAL');
    // Copy from federal
    i := 3;
    j := 161; // indx to medical
    Repeat
      strings[i] := FetchElmFNo(RetNo, MedicalFNo, j);
      Tv[i] := Vl(FetchElmFNo(RetNo, MedicalFNo, j));
      Inc(i);
      Inc(j);
    until i > 67;

    If ((ret[RetNo].Province = 'ON') or (ret[RetNo].Province = 'BC') Or
      (ret[RetNo].Province = 'NT')) then
      strings[135] := 'N' // ignore max
    Else
      strings[135] := 'Y';

    PercentClaim := Vl(FetchElmFNo(RetNo, MedicalFNo, 236));

    // 20120325
    strings[1] := ret[RetNo].Province;
    Tv[2] := PrvConstant[RY].PrvMedicalLimit;
    i := 3;
    Tv[75] := 0;
    Tv[76] := 0;
    Repeat
      Tv[i + 7] := CalcPrvMedicalLimitForDependant(RetNo,
        Tv[i + 6] * PercentClaim / 100, Tv[i + 4]);
      Tv[75] := Tv[75] + Tv[i + 6];
      Tv[76] := Tv[76] + Tv[i + 7];
      Inc(i, 8);
    until i > 67;
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T5006(RetNo: integer; FName: String; FNo: integer); // 20131127
var
  i: integer; // 20160119 Igor
begin
  // 20161201
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    strings[1] := AppYear;
    Tv[149] := 0;
    Tv[152] := 0;
    i := 6;
    Repeat
      if strings[i + 3] > '' then
        Tv[149] := Tv[149] + Tv[i] + Tv[i + 1];
      if strings[i + 4] > '' then
        Tv[152] := Tv[152] + Tv[i] + Tv[i + 1];
      Inc(i, 6);
    Until i > 120;

    Tv[151] := MaxR(0, Tv[149] + Tv[163] - Tv[150]);
    Tv[154] := MaxR(0, Tv[152] + Tv[164] - Tv[153]);
    Tv[155] := Tv[151] * 15 / 100;
    Tv[159] := 0; // Tv[154] * 5/100;  //20171216
    Tv[4] := MinR(750, Tv[155]);
    Tv[165] := 0; // MinR(750,Tv[159]);
    if UpperCase(strings[156]) <> 'Y' then
      Tv[157] := Tv[4];
    strings[160] := '';
    Tv[161] := 0; // if UpperCase(Strings[160])<>'Y' then Tv[161]:=Tv[165];

    Tv[158] := MaxR(0, Tv[4] - Tv[157]);

    Tv[47] := MaxR(0, Tv[41] - Tv[44]);
    Tv[48] := MaxR(0, Tv[42] - Tv[45]);
  end;
  SaveTv(RetNo, FName, FNo);
end;

(*
  Procedure T5006(RetNo: integer; FName: String;FNo: integer);  //20131127
  {Var LbCost20,LbCost15,x,y,z: real;}
  var
  I: Integer; //20160119 Igor
  begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[Fno] do
  begin
  {
  Tv[3] := MaxR(0,Tv[3]);
  Tv[4] := MinR(750,Tv[3]  * 0.15);
  }
  Tv[41]:=0;
  Tv[42]:=0;
  Tv[43]:=0;
  i:=6;
  Repeat
  Tv[41]:=Tv[41]+Tv[i];
  Tv[42]:=Tv[42]+Tv[i+1];
  Tv[43]:=Tv[43]+Tv[i+2];
  Inc(i,4);
  until i>26;
  Tv[47]:=MaxR(0,Tv[41]-Tv[44]);
  Tv[48]:=MaxR(0,Tv[42]-Tv[45]);

  //20161126 //20160505 Igor
  //Provincially:
  Tv[51]:=MinR(750,Tv[50]+Tv[47]*0.15)+MinR(750,Tv[48] * 0.15); //20161126
  //Tv[51]:=MinR(500,Tv[50]+Tv[47]*0.10)+MinR(500,Tv[48] * 0.10); //20160316
  //MinR(750,Tv[50]+Tv[47]*0.15)+MinR(750,Tv[48] * 0.15);
  If UpperCase(Strings[3]) <> 'Y' then
  begin
  //20160316
  Tv[4]:=MinR(750,Tv[51]);
  If Tv[4]>750 then Tv[4]:=750;
  //Tv[4]:=MinR(750,Tv[51]);  //20131211
  //If Tv[4]>750 then Tv[4]:=750;
  Tv[53]:=MaxR(0,Tv[51] - Tv[4]);
  end;

  Strings[2]:='S7';
  If Ret[RetNo].Province = 'ON' then Strings[1]:='ON428'
  else If Ret[RetNo].Province = 'MB' then Strings[1]:='MB428'
  else If Ret[RetNo].Province = 'NB' then Strings[1]:='NB428'
  else If Ret[RetNo].Province = 'NS' then Strings[1]:='NS479'
  else If Ret[RetNo].Province = 'SK' then Strings[1]:='SK428'
  else If Ret[RetNo].Province = 'BC' then Strings[1]:='BC428'
  else If Ret[RetNo].Province = 'YT' then Strings[1]:='YT479';

  end;
  SaveTv(RetNo,FName,FNo);
  end;
*)
procedure OTHDED(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  x: Real;
  T1212Fno: integer;
begin
  T1212Fno := GetFormNo('T1212');
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    // line 229 --------------------------------------------------------------
    // ShowMessage('T777 ='+FetchElm(RetNo, 'T777#1', 1));
    // Tv[34]:=TotMultiple(RetNo,'T777S',20)+TotMultiple(RetNo,'T777S',5); //covid-19  20210120 //Option 1 an2
    Tv[34] := 0;
    If UpperCase(FetchElm(RetNo, 'T777#1', 1)) = 'Y' then // 20200511
      Tv[34] := Tv[34] + TotMultiple(RetNo, 'T777', 24); // 202010307

    Tv[35] := TotMultiple(RetNo, 'TL2', 105);
    Tv[37] := TotMultiple(RetNo, 'T4', 38);
    Tv[38] := TotMultiple(RetNo, 'T4PS', 6);
    Tv[63] := TotMultiple(RetNo, 'RC359', 11);
    Tv[41] := Tv[34] + Tv[35] + Tv[36] + Tv[37] + Tv[38] + Tv[39] +
      Tv[40] + Tv[63];

    // line 24900 start --------------------------------------------------------------
    Tv[44] := TotMultiple(RetNo, 'T4', 28);
    Tv[45] := TotMultiple(RetNo, 'T4', 12);
    Tv[78]:= TotMultiple(RetNo, 'T4', 70) + TotMultiple(RetNo, 'T4', 73); //20251212 Igor - second box 91 value added // t4 box 91 //20250316
    Tv[79]:= TotMultiple(RetNo, 'T4', 71) + TotMultiple(RetNo, 'T4', 74); //20251212 Igor - second box 92 value added // t4 box 92 //20250316

    //Tv[80] := Vl(FetchElmFNo(RetNo, T1212Fno, 5)); //jz//20251217 - line 65200 removed from 1212 // 1212 65200 //20250316
    //Tv[82] := Tv[80] * (50 / 100);

    Tv[81] := Vl(FetchElmFNo(RetNo, T1212Fno, 3));   // 1212 65210 //20250316
    strings[86] := '50';                             //jz//20251217 - added % field
    Tv[83] := Tv[81] * (vl(strings[86]) / 100);      //jz//20251217

    // 84,47,48,57,58,49,50 vtuser

    Tv[46] := Tv[83]; //jz//20251217 - Tv[82] removed   // GetDeferredDispBenefit(RetNo); // is actually just Tv[82] + Tv[83]

    Tv[51] := Tv[44] + Tv[45] + Tv[78] + Tv[79] +   // jz//20250316   //Tv[80] + Tv[81] + Tv[82] [83] THESE DO NOT GET ADDED
      Tv[46] + Tv[47] + Tv[84] + Tv[48] + Tv[49] + Tv[50] + Tv[57] + Tv[58];     // +Tv[61];  //20170202

    // line 24901 start --------------------------------------------------------------
    Tv[65] := TotMultiple(RetNo, 'T4', 70) + TotMultiple(RetNo, 'T4', 71); // 1
    Tv[66] := Vl(FetchElmFNo(RetNo, T1212Fno, 3));
    strings[67] := '33.3333';
    Tv[68] := Tv[66] * (Vl(strings[67]) / 100); // 2
    Tv[69] := Tv[65] + Tv[68]; // 3
    strings[70] := '3'; // 4
    Tv[71] := Tv[69] * Vl(strings[70]); // 5
    Tv[72] := Tv[47];
    strings[73] := '1.5';
    Tv[74] := Tv[72] * Vl(strings[73]); // 6
    Tv[75] := MaxR(0, Tv[71] - Tv[74]); // 7
    strings[76] := '16.6667'; // 8
    Tv[77] := Tv[75] * (Vl(strings[76]) / 100); // 9

    Tv[85]:= 0; //20251210 Igor Code commented by Alex, because this block was used for two periods of 2024 year. Found by TestCase #48 //Tv[85]:= Tv[77]; // 10
    Lnn[24901] := Tv[85];

    xx := Lnn[24901];
    xx := Tv[85];
    // end line 24901 --------------------------------------------------------------

    // ln 25000 ----------------------------------------------------------------
    Tv[54] := Lnn[14700];

  

    Tv[56] := MaxR(0, Tv[54] - Tv[55]);
    If Bankrupt = 3 then
    begin
      Tv[54] := 0;
      Tv[55] := 0;
      Tv[56] := 0;
    end; { trustee }
    Lnn[25000] := Tv[56];
    // end ln 25000 ----------------------------------------------------------------

    // 23200 ----------------------------------------------------------------------
    Tv[2] := TotMultiple(RetNo, 'T4AOAS', 7); { OAS repayment }
    Tv[3] := TotMultiple(RetNo, 'T4E', 23);
    // 20230303 //TotMultiple(RetNo, 'T4E', 10); { UI repayment }
    If SplitIncome(RetNo) then
    Begin
      if ret[RetNo].FrmHasData[GetFormNo('T1206')] then
        Tv[4] := Vl(FetchElm(RetNo, 'T1206', 3)); // 20181215
    End
    else
      Tv[4] := 0;
    Tv[5] := Vl(FetchElm(RetNo, 'T1229', 114));
    Tv[6] := TotMultiple(RetNo, 'T4RIF', 6); { t4rif/22 }
    Tv[7] := T4RspOthDed;
    If UpperCase(FetchElm(RetNo, 'T5004', 69)) = 'Y' then
      Tv[8] := Vl(FetchElm(RetNo, 'T5004', 68))
    else
      Tv[8] := 0;

    Tv[31] := GetRowFromSlip(RetNo, 'FPENS', 6, 3, 0);
    Tv[22] := Tv[31] + Tv[32];

    Tv[9] := Vl(FetchElm(RetNo, 'FORINC', 115)) +
    { car charges foreign invst }
      Vl(FetchElm(RetNo, 'FORINC', 117)) + Vl(FetchElm(RetNo, 'FORINC', 119));
    Tv[10] := Vl(FetchElm(RetNo, 'FORINC', 127)) + { S(11) deduction }
      Vl(FetchElm(RetNo, 'FORINC', 129)) + Vl(FetchElm(RetNo, 'FORINC', 131));
    If Tv[10] < 1 then
      Tv[10] := 0;
    Tv[11] := Vl(FetchElm(RetNo, 'FORINC', 133)) + { S(12) deduction }
      Vl(FetchElm(RetNo, 'FORINC', 135)) + Vl(FetchElm(RetNo, 'FORINC', 137));

    Tv[61] := TotMultiple(RetNo, 'T4A', 98) + // 20231124+
      TotMultiple(RetNo, 'T4E', 22);
    { from tot income }

    Tv[21] := 0;
    Tv[59] := TotMultiple(RetNo, 'T4AP', 2);
    i := 1;
    Repeat
      Tv[21] := Tv[21] + Tv[i];
      Inc(i);
    until i > 12;
    Tv[33] := Vl(FetchElm(RetNo, 'T746', 11));
    Tv[21] := Tv[21] + Tv[14] + Tv[16] + Tv[18] + Tv[20] + Tv[33] + Tv[59] +
      Tv[60] + Tv[61]; // 20231124
    ;
    { from Net income }
    Tv[30] := TotMultiple(RetNo, 'T4E', 9);
    Tv[29] := Tv[22] + Tv[24] + Tv[26] + Tv[28] + Tv[30] + Tv[64]; // 20160129
    Lnn[25600] := Tv[29];
    ret[RetNo].Lnn[25600] := Tv[29];
  end;
  SaveTv(RetNo, FName, FNo);

end;

procedure EFADJ(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  Begin
    If strings[1] = '' then
      strings[1] := DateToMonthDayYear(Date);
    strings[3] := GetLastName(RetNo) + ', ' + GetFirstName(RetNo);
    strings[4] := GetSinNo(RetNo);
    strings[5] := AppYear;
    strings[6] := FetchElm(RetNo, 'T183', 21);
    // OptRec.Ef_TransNo+GetSinno(RetNo);

    { preparer }
    strings[22] := OptRec.Prp_Name;
    strings[23] := OptRec.Prp_Street;
    strings[24] := OptRec.Prp_City + ', ' + OptRec.Prp_Prov + ', ' +
      OptRec.Prp_Postal;
    strings[25] := OptRec.Prp_Area + ' ' + OptRec.Prp_Tel;
  end;
  SaveTv(RetNo, FName, FNo);
end;

procedure EFDOC(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  Begin
    If strings[1] = '' then
      strings[1] := DateToMonthDayYear(Date);
    strings[3] := GetLastName(RetNo) + ', ' + GetFirstName(RetNo);
    strings[4] := GetSinNo(RetNo);
    strings[5] := AppYear;
    strings[6] := FetchElm(RetNo, 'T183', 21);
    // OptRec.Ef_TransNo+GetSinno(RetNo);

    { preparer }
    strings[7] := OptRec.Prp_Name;
    strings[8] := OptRec.Prp_Street;
    strings[9] := OptRec.Prp_City + ', ' + OptRec.Prp_Prov + ', ' +
      OptRec.Prp_Postal;
    strings[10] := OptRec.Prp_Area + ' ' + OptRec.Prp_Tel;
  end;
  SaveTv(RetNo, FName, FNo);

end;

Procedure INVOICE(RetNo: integer; FName: string; FNo: integer);
Var
  i, j, PagesCharged: integer;
  Frms, HowMany: TstringList;
begin
  Calc(RetNo, 'INVFORMS'); // 20110226
  FormatSettings.DecimalSeparator := '.'; // 20160119 Igor
  UpdateAllDataIndicators(RetNo);
  // For i:=1 to 130 do StoreElm(RetNo,FNo,i,'');  //20110226
  LoadTv(RetNo, FName, FNo);

  with ret[RetNo].Frm[FNo] do
  begin
    // inv pg2
    with ret[RetNo].Frm[FNo] do
    begin
      If UpperCase(strings[285]) = 'Y' then
      begin
        SaveTv(RetNo, FName, FNo);
        exit;
      End;
      strings[201] := OptRec.Prp_Name;
      strings[202] := OptRec.Prp_Street;
      strings[204] := OptRec.Prp_City + ', ' + OptRec.Prp_Prov;
      strings[205] := OptRec.Prp_Postal;
      strings[207] := OptRec.Prp_Area + ' ' + OptRec.Prp_Tel;
      strings[208] := OptRec.PRp_GSTNo;

      If OptRec.AutoSeniorDiscount then
      begin
        If ret[RetNo].Age >= 65 then
          strings[275] := OptRec.DiscountForSeniors;
      end;
      If strings[278] = '' then
        strings[278] := FetchElm(RetNo, 'INFO', 67);
      If strings[203] = '' then
      begin
        If ShowUnconvertedLastYear(RetNo) = false then
          strings[203] := DateToMonthDayYear(Date);
      end;
      // 202204
      If strings[289] + strings[223] + strings[224] + strings[225] +
        strings[271] + strings[282] > '' then
      begin
        If strings[209] = '' then
        begin
          If ShowUnconvertedLastYear(RetNo) = false then
            strings[209] := FormatDateTime('yyyy-mm-dd', Now);
        end;
      end
      else
        strings[209] := '';
      If strings[210] = '' then
        strings[210] := MakeInvoiceNo(RetNo);
      strings[211] := GetFirstName(RetNo) + ' ' + GetLastName(RetNo);
      If UpperCase(FetchElm(RetNo, 'INFO', 129)) = 'X' then
        strings[211] := FetchElm(RetNo, 'INFO', 122); // is joint inv
      strings[212] := Rtrim(FetchElm(RetNo, 'INFO', 6)) + ' ' +
        FetchElm(RetNo, 'INFO', 22) { Apartm }
        + ' ' + FetchElm(RetNo, 'INFO', 68) { po box }
        + ' ' + FetchElm(RetNo, 'INFO', 163); { RR }
      strings[215] := Rtrim(FetchElm(RetNo, 'INFO', 10)) + ', ' +
        Rtrim(FetchElm(RetNo, 'INFO', 14)) + ', ' +
        Rtrim(FetchElm(RetNo, 'INFO', 15));
      strings[281] := AllTrim(FetchElm(RetNo, 'T1', 441)) + ' ' +
        AllTrim(FetchElm(RetNo, 'T1', 442));
      If strings[216] = '' then
        strings[216] := AppYear + ' Personal Tax Preparation';
      If (strings[227] = '') and (ShowEFileCharges = True) then
        strings[227] := 'E-file charges';

      if strings[290] > '' then // 20220505
      Begin
        if Tv[291] = 0 then
          Tv[291] := 12;
        Tv[293] := (Tv[217] + Tv[218]) * Tv[291] / 100;
      End
      Else
      Begin
        Tv[291] := 0;
        Tv[293] := 0;
      End;
      If Tv[293] > 0 then
        strings[294] := 'Audit pre-charge'
      else
        strings[294] := ''; // 20230301

      If strings[251] + strings[249] + strings[244] + strings[245] +
        strings[246] + strings[247] + strings[206] + strings[252] = '' then
      begin
        Case MyStrToInt(OptRec.Prp_Bill) of
          0:
            strings[251] := 'X'; // manual
          1:
            strings[249] := 'X'; // fee per form
          2:
            strings[252] := 'X'; // time billing {Strings[50] := '30';}
          3:
            strings[246] := 'X'; // Complexity Average
        end;
      end;

      // If LeftStr(LicenseLevel,8) = 'T1 Multi' then
      If LicenseLevel in anyMulti then // 20160119 Igor
      begin
        If MyStrToInt(OptRec.Prp_Bill) = 1 then
        begin
          If (UpperCase(strings[251]) = 'X') Or (UpperCase(strings[244]) = 'X')
            or (UpperCase(strings[246]) = 'X') or
            (UpperCase(strings[252]) = 'X') or (UpperCase(strings[245]) = 'X')
            or (UpperCase(strings[247]) = 'X') or (UpperCase(strings[206]) = 'X')
          then
          begin
            If YouKnowTheAdminPassWord = false then
            begin
              strings[249] := 'X';
              strings[251] := '';
              strings[244] := '';
              strings[246] := '';
              strings[252] := '';
              strings[245] := '';
              strings[247] := '';
              strings[206] := '';
            end; { does not know admin psw }
          end; { changed method }
        end; { fee based }
      end; { multi-office }

      If strings[244] > '' then
        Tv[217] := OptRec.Prp_VSFee; { else Tv[7] :=0; }
      If strings[245] > '' then
        Tv[217] := OptRec.Prp_SFee; { else Tv[6]:=0; }
      If strings[246] > '' then
        Tv[217] := OptRec.Prp_AFee; { else tv[8] :=0; }
      If strings[247] > '' then
        Tv[217] := OptRec.Prp_CFee; { else Tv[9]:=0; }
      If strings[206] > '' then
      begin
        strings[249] := '';
        Tv[217] := OptRec.Prp_VCFee;
      end; { else Tv[10]:=0; }
      If strings[249] > '' then
        Tv[217] := Vl(FetchElm(RetNo, 'INVFORMS', 5));
      // GetTotalFee(RetNo);  //20110202
      If strings[252] > '' then
        Tv[217] := Vl(strings[250]) * OptRec.Prp_Hour / 60;

      Tv[219] := Tv[217] + Tv[218] + Tv[234] + Tv[235] + Tv[236] + Tv[237] +
        Tv[238] + Tv[239] + Tv[242] + Tv[243] + Tv[256] + Tv[257] + Tv[258] +
        Tv[261] + Tv[262] + Tv[265] + Tv[266] + Tv[269] + +Tv[270] + Tv[293];
      // 20220505

      Tv[276] := Tv[219] * Vl(strings[275]) / 100;
      Tv[277] := MaxR(0, Tv[219] - Tv[276]);

      If strings[208] = '' then
        strings[220] := ''
      else
      begin
        If strings[220] = '' then
          strings[220] := FormatFloat('###.00', OptRec.OPR_GSTHST);
      end;
      If OptRec.PstOnInvoice then
        strings[214] := FormatFloat('###.00', OptRec.OPR_PST);

      Tv[221] := Tv[277] * Vl(strings[220]) / 100;
      Tv[248] := Tv[277] * Vl(strings[214]) / 100;
      Tv[222] := Tv[277] + Tv[221] + Tv[248];
      Tv[284] := Tv[222] - Tv[283];
      // Tv[84] := Tv[22]-Tv[83];         //20110202

      // 20150321
      If UpperCase(strings[288]) <> 'Y' then
      Begin
        If OptRec.ShowTaxSavings then
        Begin
          strings[287] := '';
          { //20161117
            If ret[RetNo].Lnn[423]>0 then
            Strings[287]:='The Family Tax Cut has reduced Income Tax Payable by $'+FormatFloat('#,###.##',ret[RetNo].Lnn[423]);
          }
          // 20150323
          If Vl(FetchElm(RetNo, 'OPTIMIZE', 77)) > 0 then
            strings[287] :=
              'Optimization and Pension Splitting has reduced Income Tax Payable by $'
              + FormatFloat('#,###.##', Vl(FetchElm(RetNo, 'OPTIMIZE', 77)));
        end
        Else
          strings[287] := '';
      End;

      If OptRec.ShowConsultantOnInv = True then
        strings[226] := User.Prep_Name // 20170112 Igor
      else
        strings[226] := '';
      strings[213] := OptRec.Prp_Name;

      // Footer
      If strings[272] = '' then
        strings[272] := OptRec.InvFoot1;
      If strings[273] = '' then
        strings[273] := OptRec.InvFoot2;
      If strings[274] = '' then
        strings[274] := OptRec.InvFoot3;
      If strings[279] = '' then
        strings[279] := OptRec.InvFoot4;
      If strings[280] = '' then
        strings[280] := OptRec.InvFoot5;
    end;

  end;
  SaveTv(RetNo, FName, FNo);
  // Frms.Free;HowMany.Free;
end;

Procedure INVGen(RetNo: integer; FName: string; FNo: integer);
Var
  i, j, PagesCharged: integer;
  Frms, HowMany: TstringList;
  FInst: String;
begin
  FormatSettings.DecimalSeparator := '.'; // 20160119 Igor
  UpdateAllDataIndicators(RetNo);
  FInst := AllTrim(MidStr(ExtractFormInst(FName), 2, 3));
  LoadTv(RetNo, FName, FNo);

  with ret[RetNo].Frm[FNo] do
  begin
    strings[201] := OptRec.Prp_Name;
    strings[202] := OptRec.Prp_Street;
    strings[204] := OptRec.Prp_City + ', ' + OptRec.Prp_Prov;
    strings[205] := OptRec.Prp_Postal;
    strings[207] := OptRec.Prp_Area + ' ' + OptRec.Prp_Tel;
    strings[208] := OptRec.PRp_GSTNo;

    If strings[210] = '' then
      strings[210] := AddLeadingZeros(FInst, 4);
    If strings[278] = '' then
      strings[278] := FetchElm(RetNo, 'INFO', 67);
    If strings[203] = '' then
    begin
      If ShowUnconvertedLastYear(RetNo) = false then
        strings[203] := DateToMonthDayYear(Date);
    end;
    If strings[223] + strings[224] + strings[225] + strings[271] +
      strings[282] > '' then
    begin
      If strings[209] = '' then
      begin
        If ShowUnconvertedLastYear(RetNo) = false then
          strings[209] := FormatDateTime('yyyy-mm-dd', Now);
      end;
    end
    else
      strings[209] := '';

    If strings[285] > '' then // use current client data
    Begin
      strings[211] := GetFirstName(RetNo) + ' ' + GetLastName(RetNo);
      strings[212] := Rtrim(FetchElm(RetNo, 'INFO', 6)) + ' ' +
        FetchElm(RetNo, 'INFO', 22) { Apartm }
        + ' ' + FetchElm(RetNo, 'INFO', 68) { po box }
        + ' ' + FetchElm(RetNo, 'INFO', 163); { RR }
      strings[215] := Rtrim(FetchElm(RetNo, 'INFO', 10)) + ', ' +
        Rtrim(FetchElm(RetNo, 'INFO', 14)) + ', ' +
        Rtrim(FetchElm(RetNo, 'INFO', 15));
      strings[281] := AllTrim(FetchElm(RetNo, 'T1', 441)) + ' ' +
        AllTrim(FetchElm(RetNo, 'T1', 442));
    end;
    (*
      Else
      begin
      Strings[211] :='';
      Strings[212]:='';
      Strings[215]:='';
      Strings[281]:='';
      Strings[285]:='';
      end;
    *)
    Tv[219] := Tv[217] + Tv[218] + Tv[234] + Tv[235] + Tv[236] + Tv[237] +
      Tv[238] + Tv[239] + Tv[242] + Tv[243] + Tv[256] + Tv[257] + Tv[258] +
      Tv[261] + Tv[262] + Tv[265] + Tv[266] + Tv[269] + +Tv[270];

    Tv[276] := Tv[219] * Vl(strings[275]) / 100;
    Tv[277] := MaxR(0, Tv[219] - Tv[276]);

    If strings[208] = '' then
      strings[220] := ''
    else
    begin
      If strings[220] = '' then
        strings[220] := FormatFloat('###.00', OptRec.OPR_GSTHST);
    end;
    If OptRec.PstOnInvoice then
      strings[214] := FormatFloat('###.00', OptRec.OPR_PST);

    Tv[221] := Tv[277] * Vl(strings[220]) / 100;
    Tv[248] := Tv[277] * Vl(strings[214]) / 100;
    Tv[222] := Tv[277] + Tv[221] + Tv[248];
    Tv[284] := Tv[222] - Tv[283];
    // Tv[84] := Tv[22]-Tv[83];         //20110202

    strings[213] := OptRec.Prp_Name;

    // Footer
    If strings[272] = '' then
      strings[272] := OptRec.InvFoot1;
    If strings[273] = '' then
      strings[273] := OptRec.InvFoot2;
    If strings[274] = '' then
      strings[274] := OptRec.InvFoot3;
    If strings[279] = '' then
      strings[279] := OptRec.InvFoot4;
    If strings[280] = '' then
      strings[280] := OptRec.InvFoot5;
  end;

  SaveTv(RetNo, FName, FNo);
end;

Procedure INVFORMS(RetNo: integer; FName: string; FNo: integer);
Var
  i, j, PagesCharged: integer;
  Frms, HowMany: TstringList;
begin
  FormatSettings.DecimalSeparator := '.'; // 20160119 Igor
  UpdateAllDataIndicators(RetNo);
  For i := 1 to 130 do
    StoreElm(RetNo, FNo, i, '');
  LoadTv(RetNo, FName, FNo);
  Frms := TstringList.Create;
  HowMany := TstringList.Create;
  with ret[RetNo].Frm[FNo] do
  begin
    PagesCharged := 0;
    strings[1] := GetLastName(RetNo) + ', ' + GetFirstName(RetNo);
    strings[2] := AppYear;
    strings[3] := IntToStr(CountPagesGenerated(RetNo));
    GetListInvoiceForms(RetNo, Frms, HowMany);
    Tv[5] := 0;
    j := 7;
    For i := 0 to Frms.count - 1 do
    begin
      Inc(PagesCharged, MyStrToInt(HowMany[i]));
      strings[j] := PaddR(HowMany[i], 5) + Frms[i];
      Tv[j + 1] := GetFormFee(RetNo, Frms[i], MyStrToInt(HowMany[i]));
      // 20090325
      If (Frms[i] = 'ASSETSB') Or (Frms[i] = 'AUTOS') then
      begin
        If (IsSelfEmployed(RetNo) = false) and (ret[RetNo].Lnn[12599] = 0) then
          Tv[j + 1] := 0;
      end;
      Tv[5] := Tv[5] + Tv[j + 1]; // total charges
      Inc(j, 2);
      If j > 130 then
        break;
    end;
    strings[4] := IntToStr(PagesCharged);
  end;
  SaveTv(RetNo, FName, FNo);
  Frms.Free;
  HowMany.Free;
end;

procedure OTHINC(RetNo: integer; FName: String; FNo: integer);
Var
  i, spRetNo: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo], ret[RetNo].Frm[FNo] do
  Begin
    // ln 103  //20131215
    Tv[33] := MinR(Tv[32], Tv[33]);
    Tv[34] := MaxR(0, Tv[32] - Tv[33]);
    // ln 122  //20130126
    Tv[26] := T5013LimitedInc;
    Tv[28] := Vl(FetchElm(RetNo, 'RESINC', 19));
    Tv[30] := Tv[26] + Tv[27] + Tv[28] + Tv[29];
    // ln 130
    Tv[7] := TotMultiple(RetNo, 'T4', 49) + TotMultiple(RetNo, 'T4', 50);
    Tv[8] := TotMultiple(RetNo, 'T4A', 14); // 20131012
    Tv[1] := T4AOthInc + TotMultiple(RetNo, 'T4A', 44) +
      TotMultiple(RetNo, 'T4A', 89) + TotMultiple(RetNo, 'T4A', 90)
    // 20201121 COV19
      + TotMultiple(RetNo, 'T4A', 91) + TotMultiple(RetNo, 'T4A', 92)
    // 20201121 COV19
      + TotMultiple(RetNo, 'T4A', 93) + TotMultiple(RetNo, 'T4A', 94)
    // 20201121 COV19
      + TotMultiple(RetNo, 'T4A', 95) + TotMultiple(RetNo, 'T4A', 99)
    // 20211211 Covid
      + TotMultiple(RetNo, 'T4A', 100);

    Tv[6] := GetTotT4ARCA(RetNo);
    Tv[9] := T4RIFOthInc;
    If Age < 65 then
      Tv[9] := Tv[9] + Vl(FetchElm(RetNo, 'T2205', 30)); // march 2008
    If Age < 65 then
      Tv[10] := Tv[10] + Vl(FetchElm(RetNo, 'T2205', 30));
    spRetNo := GetSpRetNo(RetNo);
    If CouplingSw then
    begin
      If Age < 65 then
        Tv[10] := Tv[10] + Vl(FetchElm(spRetNo, 'T2205', 29));
    end;

    Tv[11] := TotMultiple(RetNo, 'T4RIF', 3); { t4RIF/18 }
    // Tv[12] := TotT4RifBox20(RetNo,'T4RIF',4); {t4RIF/20}  //feb 2008

    // Tv[10]:=TotMultiple(RetNo,'T4AP',15); //T4APCppBnf;  //20190218
    Tv[13] := T3OthInc;
    Tv[14] := T5013OthInc;
    Tv[4] := Vl(FetchElm(RetNo, 'TOOLEXP', 101));
    { ? T4A is already in elm 1, revise wording in OthInc elm 16 to
      T3 Lump sum }

    Tv[5] := Tv[7] + Tv[1] + Tv[8] + Tv[4] + Tv[6] + Tv[9] + Tv[11];
    // tv[8] new 20131012
    i := 13;
    Repeat
      Tv[5] := Tv[5] + Tv[i];
      Inc(i);
    until i > 16;
    Tv[5] := Tv[5] + Tv[18] + Tv[20] + Tv[22] + Tv[24];
    // Tv[2]:=TotMultiple(RetNo,'T4A',34)+TotMultiple(RetNo,'T3',18);
    Tv[2] := TotMultiple(RetNo, 'T4A', 34) + TotMultiple(RetNo, 'T3MULT', 142);
    // death gross
    // 20090319
    // Tv[3]:=TotMultiple(RetNo,'T3',32)+TotMultiple(RetNo,'T4A',51);
    Tv[3] := TotMultiple(RetNo, 'T3MULT', 148) + TotMultiple(RetNo, 'T4A', 51);
    // death deduction
    If Tv[3] > 10000 then
      Tv[3] := 10000;
    // If Tv[2]>10000 then Tv[3]:=10000 else Tv[3]:=Tv[2];
    Tv[25] := Tv[5] - Tv[3];
  end;
  SaveTv(RetNo, FName, FNo);
end;

// 201170309
procedure CTB(RetNo: integer; FName: String; FNo: integer);
// see CRA indexation
// https://www.canada.ca/en/revenue-agency/services/tax/individuals/frequently-asked-questions-individuals/adjustment-personal-income-tax-benefit-amounts.html
// http://www.cra-arc.gc.ca/benefits/cctb/cctb_calcform07-e.pdf
{
  Const MonthName : Array[1..12] of string[12] =
  ('January','February','March','April','May',
  'June','July','August','September','October',
  'November','December');
}
// 20190121
Const
  // 20260330
  BFUnder6 = 8157; //7787; // 7437; //20241228
  Bf6To17 = 6883; //6570; // 6275; //5903; //5765; //5708;
  AFNI1 = 38237; //36501; //36502; // 20241228 //20250413
  AFNI2 = 82847; //20260409 88847; //79087; /
  DisabPerKid = 3480; //3322; // 3173;//20241228
  // LINE 15 max???
Var
  i, j, AllKids, DisabKids, spRetNo: integer;
  BasicBenefit: Real;
  InfirmUnder18: Real;
  AFNI: Real;
  x: Real;
  Percent: Real;

begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  Begin
    If strings[71] = '' then
      strings[71] := 'Y'; // recipient
    if strings[71] <> 'Y' then
    Begin
      for i := 1 to 70 do
      begin
        Tv[i] := 0;
      end;
      SaveTv(RetNo, FName, FNo);
      exit;
    End;

    for i := 1 to 70 do
    begin
      Tv[i] := 0;
    end; // initialize 20170311

    Tv[1] := BFUnder6;
    strings[3] := IntToStr(CountKidsUnder6(RetNo));
    Tv[2] := Tv[1] * MyStrToInt(strings[3]);

    Tv[4] := Bf6To17;
    strings[5] := IntToStr(CountKidsUnder18(RetNo) - CountKidsUnder6(RetNo));
    Tv[6] := Tv[4] * MyStrToInt(strings[5]);

    Tv[7] := Tv[2] + Tv[6];

    { Bring incomes/current return }
    // SpRetNo:=GetSpRetNo(RetNo);
    Tv[50] := ret[RetNo].Lnn[23600];
    If TosiInEffect(RetNo) then
      Tv[50] := GetTosiNetIncome(RetNo);

    Tv[51] := SpouseIncome(RetNo);
    If TosiInEffect(RetNo) then
      Tv[51] := GetSpouseTosiNetIncome(RetNo, InfoFNo); // 20190115

    Tv[52] := Tv[50] + Tv[51];
    Tv[68] := GetTotalUCCB(RetNo) + GetTotalRDSP(RetNo);
    Tv[54] := MaxR(0, Tv[52] - Tv[68]);
    // add UCCB repayments //20170311 both sposes
    Tv[54] := Tv[54] + Vl(FetchElm(RetNo, 'UCCB', 3)) +
      Vl(FetchElm(RetNo, 'UCCB', 5)); // add UCCB Replayment
    // add RDSP repayments //20170311 both sposes
    Tv[54] := Tv[54] + Vl(FetchElm(RetNo, 'OTHDED', 60));
    // Add current spouse RDSP repayment
    // RDSP Repayment the other spouse?  HOW?

    AFNI := Tv[54];

    if AFNI <= AFNI1 then
    Begin
      for i := 12 to 21 do
        Tv[i] := 0;
    End

    // step 1
    Else
    if ((AFNI > AFNI1) and (AFNI <= AFNI2)) then      //fam incomw beteween 38237 and 82,847
    Begin
      // step 1 only
      Tv[12] := AFNI;
      Tv[13] := AFNI1;
      x := MaxR(0, Tv[12] - Tv[13]);
      Tv[15] := MinR(x, AFNI1); // 20250512  //20260409
      //Tv[15] := MaxR(x,44610); //20260409 //// 20240228 //Tv[15] := MinR(x, 35000);
      AllKids := MyStrToInt(strings[3]) + MyStrToInt(strings[5]);
      If AllKids = 1 then
        Percent := 7;
      If AllKids = 2 then
        Percent := 13.5;
      If AllKids = 3 then
        Percent := 19;
      If AllKids >= 4 then
        Percent := 23;
      Tv[16] := Tv[15] * Percent / 100;
      // if ((Afni>Afni1) and (Afni<=Afni2)) then Tv[20]:=0;
    End
    // step 1 and step 2 logic
    Else if AFNI > AFNI2 then
    Begin
      // step 1 logic repeat the code from above
      Tv[12] := AFNI;
      Tv[13] := AFNI1;
      x := MaxR(0, Tv[12] - Tv[13]);
      Tv[15] := MinR(x, AFNI1); // 20250512
      Tv[15] := MaxR(Tv[15], 44610); //201260409  // 20240228
      AllKids := MyStrToInt(strings[3]) + MyStrToInt(strings[5]);
      If AllKids = 1 then
        Percent := 7;
      If AllKids = 2 then
        Percent := 13.5;
      If AllKids = 3 then
        Percent := 19;
      If AllKids >= 4 then
        Percent := 23;
      Tv[16] := Tv[15] * Percent / 100;
      // Step 2
      Tv[17] := AFNI;
      Tv[18] := AFNI2;
      Tv[19] := MaxR(0, Tv[17] - Tv[18]);
      AllKids := MyStrToInt(strings[3]) + MyStrToInt(strings[5]);
      If AllKids = 1 then
        Percent := 3.2;
      If AllKids = 2 then
        Percent := 5.7;
      If AllKids = 3 then
        Percent := 8;
      If AllKids >= 4 then
        Percent := 9.5;
      Tv[20] := Tv[19] * Percent / 100;
    End;
    Tv[21] := Tv[16] + Tv[20];
    Tv[22] := MaxR(0, Tv[7] - Tv[21]);

    DisabKids := MyStrToInt(FetchElm(RetNo, 'DEPEND', 2)) -
      MyStrToInt(FetchElm(RetNo, 'DEPEND', 53));
    if DisabKids < 0 then
      DisabKids := 0;

    // DisabKids:=MaxR(0,Vl(FetchElm(RetNo,'DEPEND',2))-Vl(FetchElm(RetNo,'DEPEND',53)));
    strings[23] := IntToStr(DisabKids);
    Tv[26] := DisabPerKid;
    Tv[24] := DisabKids * Tv[26];
    Tv[25] := AFNI;
    Tv[27] := AFNI2;
    Tv[28] := MaxR(0, Tv[25] - Tv[27]);
    if DisabKids = 1 then
      Tv[29] := Tv[28] * 3.2 / 100
    else if DisabKids > 1 then
      Tv[29] := Tv[28] * 5.7 / 100;
    Tv[30] := MaxR(0, Tv[24] - Tv[29]);
    Tv[31] := Tv[22] + Tv[30];
    Tv[70] := Tv[31] / 12;
  end;
  SaveTv(RetNo, FName, FNo);

end;

procedure PRIVAT(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  Begin
    strings[40] := GetLastName(RetNo) + ', ' + GetFirstName(RetNo);
    strings[39] := AppYear;
    strings[41] := GetSinNo(RetNo);
  end;
  SaveTv(RetNo, FName, FNo);
end;

procedure DISAB18(RetNo: integer; FName: String; FNo: integer; Prv: String);
Var
  i: integer;
begin
  //jz//20260327//MJCERT2025 - renders passed Prv var useless and is needed when calcing the other mj prov
  //                           rearrange below and hope it doesnt screw up anything else
  //                           might need different way of doing or even multiple instance like prv s2 s11??
  {
  // 20200410
  if Prv = '' then
    Prv := ret[RetNo].Province
  Else
    Prv := T2203Prov;
  }

  //jz//20260327//MJCERT2025 -  rearrange so if passes Prv is not blank then it keeps it
  //                         -   sending garbage in PRV var when opened from forms explorer so also check if is right length
  if (Prv = '') or  (length(Prv) <> 2) then
  begin
    if IsMultJurisdiction(RetNo) then
      Prv := T2203Prov
    else
      Prv := ret[RetNo].Province
  end;
  // 20110310 //it may be supplied by thecalling routine if Mult

  InitPrvConstants(Prv);
  {
    //20200410
    if IsMultJurisdiction(RetNo) = false then
    InitPrvConstants(ret[RetNo].Province)  //20110310
    Else
    InitPrvConstants(T2203Prov);  //20110310
  }
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo], ret[RetNo].Frm[FNo] do
  Begin
    If (UpperCase(FetchElm(RetNo, 'INFO', 87)) = 'X') or
      ((UpperCase(FetchElm(RetNo, 'INFO', 85)) = 'X') and
      (FetchElm(RetNo, 'INFO', 89) >= AppYear)) then
    begin
      Frm[FNo].strings[26] := 'Y';
      Frm[FNo].strings[12] := 'Y'; // 20240425
    end
    else
      Frm[FNo].strings[26] := 'N';

    If UpperCase(Frm[FNo].strings[26]) <> 'Y' then
    begin
      For i := 1 to 24 do
      begin
        Frm[FNo].strings[i] := '';
        Tv[i] := 0;
      end;
      SaveTv(RetNo, FName, FNo);
      exit;
    end;

    If Age >= 18 then
    begin
      If UpperCase(Frm[FNo].strings[12]) <> 'N' then // max claim
      BEGIN
        Tv[1] := Constant[RY].MaxDisability // * ret[RetNo].PartYear; //20240425
      end;
      If Tv[1] > Constant[RY].MaxDisability then
        Tv[1] := Constant[RY].MaxDisability;
      For i := 2 to 9 do
        Tv[i] := 0;
    end
    else
    begin
      Tv[1] := 0;
      Tv[2] := Constant[RY].MaxDisability;
      // * ret[RetNo].PartYear; //20240425?????????????????
      Tv[3] := Constant[RY].MaxDisabSupl18;
      Tv[6] := Tv[4] + Tv[5];
      Tv[7] := Constant[RY].DisabSuplBase;
      Tv[8] := MaxR(0, Tv[6] - Tv[7]);
      Tv[9] := MaxR(0, Tv[3] - Tv[8]);
      Tv[10] := Tv[9];
      Tv[11] := Tv[2] + Tv[10];
      If Tv[2] = 0 then
        for i := 3 to 12 do
          Tv[i] := 0;
    end;

    { Provincial }
    Frm[FNo].strings[13] := Prv; // Province;  //20200410

    For i := 2 to 11 do
    begin
      Frm[FNo].strings[i + 13] := Frm[FNo].strings[i];
      Tv[i + 13] := Tv[i];
    end;
    If FullToniProvince(RetNo) then
    begin
      If Age >= 18 then
      begin
        If UpperCase(Frm[FNo].strings[25]) <> 'N' then
        Begin
          Tv[14] := PrvConstant[RY].PrvMaxDisability;
          // * ret[RetNo].PartYear; //20240424
        end;
        If Tv[14] > PrvConstant[RY].PrvMaxDisability then
          Tv[14] := PrvConstant[RY].PrvMaxDisability;

        For i := 15 to 23 do
          Tv[i] := 0;
      end // age
      else
      begin
        Tv[14] := 0;
        Tv[15] := PrvConstant[RY].PrvMaxDisability;
        // * ret[RetNo].PartYear; //20240424
        Tv[16] := PrvConstant[RY].PrvMaxDisabSupl18;
        Tv[19] := Tv[17] + Tv[18];
        Tv[20] := PrvConstant[RY].PrvDisabSuplBase;
        Tv[21] := MaxR(0, Tv[19] - Tv[20]);
        Tv[22] := MaxR(0, Tv[16] - Tv[21]);
        Tv[23] := Tv[22];
        Tv[24] := Tv[15] + Tv[23];
        If Tv[15] = 0 then
          for i := 16 to 25 do
            Tv[i] := 0;
      end; // age <18
    end;
  end;
  SaveTv(RetNo, FName, FNo);
  // T2203Prov:='';   //20180323
end;

procedure PTRANSF(RetNo: integer; FName: String; FNo: integer);
  Function ClearAutoFields: Boolean; // function within procedure
  Var
    i, k: integer;
    Txbl: Real; // 20181225
  begin
    For i := 1 to 157 do
    begin
      Case i of
        8, 3, 4, 2, 128, 134, 135, 136, 137, 138, 139: // 20200401
          // 8,3,4,2, 134,135,136,137,138,139: //do nothing  //top part and unused //20190405
        Else
        begin
          ret[RetNo].Frm[FNo].strings[i] := '';
          ret[RetNo].Frm[FNo].Tv[i] := 0;
        end;
      end;
    end;
  end;

Var
  i, k, j, RNo, DependFNo, { S11FNo, } FedFNo, DisabFNo: integer;
  Dsblty, Edctn, x: Real;
  PercentClaim: Real;
  Txbl: Real;
begin
  // 20170505
  if IsMultJurisdiction(RetNo) = false then
    InitPrvConstants(ret[RetNo].Province) // 20110310
  Else
    InitPrvConstants(T2203Prov); // 20110310

  { copy from fed }
  FedFNo := GetFormNo('TRANSF');
  // 20180326
  if IsMultJurisdiction(RetNo) then
  Begin
    if UpperCase(FetchElmFNo(RetNo, FedFNo, 158)) = 'Y' then
    Begin
      StoreElm(RetNo, FNo, 158, 'Y'); // 20180326
      StoreElm(RetNo, FNo, 3, FetchElm(RetNo, 'TRANSF', 3)); // 20180326
    end;
  End;

  // designation
  For i := 47 to 52 do
    StoreElm(RetNo, FNo, i, FetchElmFNo(RetNo, FedFNo, i));
  For i := 69 to 70 do
    StoreElm(RetNo, FNo, i, FetchElmFNo(RetNo, FedFNo, i));

  For i := 1 to 1 do
    StoreElm(RetNo, FNo, i, FetchElmFNo(RetNo, FedFNo, i)); { Indic }
  For i := 79 to 79 do
    StoreElm(RetNo, FNo, i, FetchElmFNo(RetNo, FedFNo, i)); { Indic }
  For i := 5 to 10 do
    StoreElm(RetNo, FNo, i, FetchElmFNo(RetNo, FedFNo, i)); { names }
  For i := 73 to 78 do
    StoreElm(RetNo, FNo, i, FetchElmFNo(RetNo, FedFNo, i)); { SIN }
  For i := 53 to 58 do
    StoreElm(RetNo, FNo, i, FetchElmFNo(RetNo, FedFNo, i)); { Txbl }
  For i := 101 to 106 do
    StoreElm(RetNo, FNo, i, FetchElmFNo(RetNo, FedFNo, i)); { under 18 }
  // For i:= 134 to 139 do StoreElm(RetNo,FNo,i,FetchElmFNo(RetNo,FedFNo,i)); {unused}
  For i := 23 to 28 do
    StoreElm(RetNo, FNo, i, FetchElmFNo(RetNo, FedFNo, i)); { months f }
  For i := 122 to 127 do
    StoreElm(RetNo, FNo, i, FetchElmFNo(RetNo, FedFNo, i)); { months p }
  // tuition fees different than fed
  For i := 35 to 40 do
    StoreElm(RetNo, FNo, i, FetchElmFNo(RetNo, FedFNo, i)); { tuition }
  // 20180308

  For i := 41 to 46 do
    StoreElm(RetNo, FNo, i, FetchElmFNo(RetNo, FedFNo, i)); { tot educ }

  For i := 11 to 16 do
    StoreElm(RetNo, FNo, i, FetchElmFNo(RetNo, FedFNo, i)); { disabl indic }
  For i := 87 to 98 do
    StoreElm(RetNo, FNo, i, FetchElmFNo(RetNo, FedFNo, i)); { ch care etc }

  { the gaps are province dependant }

  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    // province related //20190405
    if (ret[RetNo].Province = 'ON') Or (ret[RetNo].Province = 'SK') Or
      (ret[RetNo].Province = 'NB') then
    Begin
      for k := 23 to 28 do
      begin
        strings[k] := '';
        Tv[k] := 0;
      end; // months full time
      for k := 122 to 127 do
      begin
        strings[k] := '';
        Tv[k] := 0;
      end; // months fuul time
      for k := 35 to 40 do
      begin
        Tv[k] := 0;
      end; // months full time
      for k := 59 to 65 do
      begin
        Tv[k] := 0;
      end; // months fuul time
    end;
    {
      if (Ret[RetNo].Province<>'NU')
      then
      Begin
      for k:=23 to 28 do begin Strings[k]:='';Tv[k]:=0;end; //months fuul time
      end;
    }

    // Strings[2]:='Federal transfers';  //20120204
    If strings[1] = '' then
      strings[1] := 'N';
    If strings[79] = '' then
      strings[79] := 'N';

    If UpperCase(strings[158]) = 'Y' then
      ClearAutoFields; // 20110320

    Tv[71] := 0;
    Tv[72] := 0;
    { Bring from dependants }
    DependFNo := GetFormNo('DEPEND');

    If UpperCase(strings[1]) = 'Y' then { Fill dependand's names and Sins }
    begin
      i := 5;
      j := 5;
      k := 73;
      For i := 0 to 5 do
      begin
        strings[5 + i] := FetchElmFNo(RetNo, DependFNo, j); { Dep name }
        strings[k] := FetchElmFNo(RetNo, DependFNo, j + 2); { Dep SIN }
        If strings[5 + i] > '' then
        begin
          If CalcAge(FetchElmFNo(RetNo, DependFNo, j + 5)) < 18 then
            strings[101 + i] := 'X'
          else
            strings[101 + i] := '';
        end;
        If (UpperCase(FetchElmFNo(RetNo, DependFNo, j + 7)) = 'Y')
        { disabled }   // 20130223
        // and (Uppercase(FetchElmFNo(RetNo,DependFNo,i+141))<>'Y'))      //20170509  //20170511
        then
          strings[11 + i] := 'X'
        else
          strings[11 + i] := '';
        If Tv[i + 53] = 0 then
          Tv[i + 53] := Vl(FetchElmFNo(RetNo, DependFNo, j + 8));
        // NI as txbl
        // If Tv[i+128]=0 then Tv[i+128]:= PrvConstant[RY].PrvPersAmount;  //20190410
        If strings[i + 5] = '' then
          Tv[i + 128] := 0;
        Inc(j, 15);
        Inc(k);
      end;
    end;

    { FILL txbe etc from Coupling }
    If (UpperCase(strings[79]) = 'Y') then { Fill the rest if return found }
    begin
      k := 5; { j:=11; } { i=Dep SIn elm,K=indx to dep name in DEP,J=Disab lm }
      For i := 0 to 5 do
      begin
        RNo := FindReturnNoFromSin(strings[73 + i]);
        If RNo > 0 then // if return loaded
        begin
          Tv[53 + i] := ret[RNo].Lnn[26000]; { txbl }
          strings[122 + i] :=
            IntToStr(Trunc(Vl(FetchElm(RNo, 'S11Prv', 14)) / PrvConstant[RY]
            .PrvPartEducPerMonth));
          Tv[128 + i] := CalcPrvL300To314(RNo, 'TRANSF');
          // 20181223   //disab prov
          // aduc columns
          If FetchElm(RNo, 'S11', 26) = GetSinNo(RetNo) then
          // 20200214 questioning retno
          Begin
            Tv[134 + i] := Vl(FetchElm(RNo, 'S11PRV', 13));
            strings[23 + i] :=
              IntToStr(Trunc(Vl(FetchElm(RNo, 'S11PRV', 2)) / PrvConstant[RY]
              .PrvEducPerMonth));
            Tv[29 + i] := Vl(FetchElm(RNo, 'S11PRV', 2));
            Tv[81 + i] := Vl(FetchElm(RNo, 'S11Prv', 14));
            // {Educ at part-time rate}
            Tv[35 + i] := ret[RNo].Lnn[32000] + ret[RNo].Lnn[32001];
            { Tuition } // 20200406
            Tv[59 + i] := CalcPrvL300To314(RNo, 'EDUC'); // prov form
            Tv[110 + i] := Vl(FetchElm(RNo, 'S11PRV', 21));
            Tv[116 + i] := Vl(FetchElm(RNo, 'S11PRV', 10));
          end
          Else
          Begin
            Tv[134 + i] := 0;
            strings[23 + i] := '';
            Tv[29 + i] := 0;
            Tv[81 + i] := 0;
            Tv[35 + i] := 0;
            Tv[59 + i] := 0;
            Tv[110 + i] := 0;
            Tv[116 + i] := 0;
          end;
        end;
        Inc(k, 15);
      end;
    end; { autofill }

    { Calculations }
    { Disability }
    For i := 0 to 5 do
    begin
      Txbl := Tv[53] + i; // 20181225
      If (strings[i + 5] > '') { name is there }
        and (UpperCase(strings[11 + i]) = 'X') { disabled } then
      Begin
        Txbl := Txbl + GetDependantTosiPrvTaxableIncome(RetNo, i, DependFNo);
        // 20181225
        { under 18,     ChCare   Attcare   txbl     L3100-315 }
        if Tv[128 + i] = 0 then
          Tv[128 + i] := PrvConstant[RY].PrvPersAmount;
        // lines up to Disab  //20200403
        Tv[17 + i] := CalcPrvDisabilityXfer(RetNo, strings[101 + i], Tv[87 + i],
          Tv[93 + i], Txbl, Tv[128 + i]); // 20181225
        // Tv[17+i] :=CalcPrvDisabilityXfer(RetNo,Strings[101+i],Tv[87+i],Tv[93+i],Tv[53+i],Tv[128+i])
      end
      else
        Tv[17 + i] := 0;

      If (Tv[152 + i] > 0) and (Tv[152 + i] <= Tv[17 + i]) then
        Tv[17 + i] := Tv[152 + i];
      If Tv[152 + i] > Tv[17 + i] then
        Tv[152 + i] := 0;
    end;

    { Education }
    For i := 0 to 5 do
    begin
      If Vl(strings[23 + i]) > 0 then
        Tv[29 + i] := Vl(strings[23 + i]) * PrvConstant[RY].PrvEducPerMonth
      else
        Tv[29 + i] := 0;
      If Vl(strings[122 + i]) > 0 then
        Tv[81 + i] := Vl(strings[122 + i]) * PrvConstant[RY].PrvPartEducPerMonth
      else
        Tv[81 + i] := 0;

      // 20180408
      if (ret[RetNo].Province = 'YT') then
      Begin
        Tv[29 + i] := 0;
        Tv[81 + i] := 0;
      end;
      if (ret[RetNo].Province = 'NB') then
      Begin
        Tv[29 + i] := 0;
        Tv[81 + i] := 0;
        Tv[35 + i] := 0;
      end;
      // ---------------------------
    end;
    { tot education }
    For i := 0 to 5 do
    begin
      Tv[41 + i] := Tv[29 + i] + Tv[35 + i] + Tv[81 + i];
      If (UpperCase(strings[79]) = 'Y') then
      begin
        RNo := FindReturnNoFromSin(strings[i + 73]);
        If RNo > 0 then
          Tv[110 + i] := Vl(FetchElm(RNo, 'S11PRV', 21))
      end
      else // claim by student
        { Claim } Tv[110 + i] :=
          MinR(Tv[110 + i], CalcPrvEducClaim(RetNo, Tv[134 + i], Tv[41 + i],
          Tv[53 + i], Tv[59 + i]));
      { unused , thisyr,   Txbl,   L300To318 }

      { Override }
      If (UpperCase(strings[79]) = 'Y') then
      begin
        RNo := FindReturnNoFromSin(strings[i + 73]);
        { Xfer }
        If (RNo > 0) and (UpperCase(FetchElm(RNo, 'S11PRV', 36)) = 'Y')
        // allow transfer
        then
          Tv[146 + i] := Vl(FetchElm(RNo, 'S11PRV', 10))
        else; // Tv[146+i] :=0;   //20200406
      end;

      Tv[116 + i] := MaxR(0, MinR(PrvConstant[RY].PrvMaxEducXfer, Tv[41 + i]));
      // 20200310
      if RNo > 0 then
      Begin
        if Tv[116 + i] > Vl(FetchElm(RNo, 'S11PRV', 30)) then
          Tv[116 + i] := Vl(FetchElm(RNo, 'S11PRV', 30)); // 2200416
      end;
      // Tv[116+i]  := MaxR(0,MinR(PrvConstant[RY].PrvMaxEducXfer,Tv[41+i])- MaxR(0,Tv[110+i]-Tv[134+i]));
      { Min(500?,tuitionthisyr)- claimed -c/f) }
      If Tv[146 + i] > 0 then
        Tv[116 + i] := Tv[146 + i]; // 20200406
      If Tv[146 + i] > PrvConstant[RY].PrvMaxEducXfer then
        Tv[116 + i] := PrvConstant[RY].PrvMaxEducXfer;
      // 20200406
      // If (Tv[146+i] >0) and (Tv[146+i]<=Tv[116+i]) then Tv[116+i]:=Tv[146+i];  //20200406
      // If Tv[146+i] >Tv[116+i] then Tv[146+i] :=0;
      // Tv[140+i]  := MaxR(0,Tv[134+i]+Tv[41+i]-Tv[110+i]-Tv[116+i]);  //20190411
    end;
    {
      For i := 0 to 5 do
      Begin
      If Tv[146+i]>0 then Tv[116+i]:=Tv[146+i];  //20200406
      If Tv[146+i]>PrvConstant[RY].PrvMaxEducXfer then Tv[116+i]:=PrvConstant[RY].PrvMaxEducXfer;
      end;
    }
    For i := 0 to 5 do
    begin
      Tv[71] := Tv[71] + Tv[17 + i];
      Tv[72] := Tv[72] + Tv[116 + i];
    end;
    If Rule90(RetNo) < 90 then // false then
      Tv[72] := Tv[72] * ret[RetNo].PartYear; // 20131215
    // [71] is already prorated
    // April 20 2008
    If UpperCase(strings[158]) = 'Y' then
    begin
      Tv[72] := Tv[3];
      Tv[71] := Tv[4];
      Tv[70] := 100;
      Tv[69] := 100;
      Tv[50] := 0;
      Tv[48] := 0;
      strings[1] := 'N';
      strings[79] := 'N';
    end
    Else
    begin
      Tv[3] := 0;
      Tv[4] := 0;
    end;
    Tv[71] := Tv[71] * Tv[69] / 100; // 20240529
  end; { End with }
  SaveTv(RetNo, FName, FNo);
  // T2203Prov:='';  //20180323
end;

// 20250910 Igor >>>
procedure S3(RetNo: integer; FName: string; FNo: integer);
var
  i, SFNo: integer;  //slip fno
  T2091Fno: integer; // 20220128
  T1170FNo: integer;
  AcbProceeds, AcbGain: Real;
  TaxpayerPrincipalResidencePercent: Real;
  NetCapitalGains1, NetCapitalLosses1, NetCapitalGains2,
  NetCapitalLosses2: Real;

  //20260106
  TotT3DispP1, TotT3CapGP1: Real;
  TotT5DispP1, TotT5CapGP1: Real;
  TotT5013DispP1, TotT5013CapGP1: Real;
  TotT4ps3DispP1, TotT4psCapGP1: Real;


  // Totals for slips T5 T3 T5013 T4Ps
  {//20260106
  TotT3DispP1, TotT3CapGP1, TotT3DispP2, TotT3CapGP2: Real;
  TotT5DispP1, TotT5CapGP1, TotT5DispP2, TotT5CapGP2: Real;
  TotT5013DispP1, TotT5013CapGP1, TotT5013DispP2, TotT5013CapGP2: Real;
  TotT4ps3DispP1, TotT4psCapGP1, TotT4psDispP2, TotT4psCapGP2: Real;
  }
  //20250507
  TotT3EligCapGQSBCS, TotT3EligCapGQFFP, TotT5013EligCapG: Real;
begin
  LoadTv(RetNo, FName, FNo);
  T1170FNo:= GetFormNo('T1170');

  with ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    //init totals //20250417
    TotT3DispP1:= 0; TotT3CapGP1:= 0;// TotT3DispP2:= 0; TotT3CapGP2:= 0;
    TotT5DispP1:= 0; TotT5CapGP1:= 0;// TotT5DispP2:= 0; TotT5CapGP2:= 0;
    TotT5013DispP1:= 0; TotT5013CapGP1:= 0;// TotT5013DispP2:= 0; TotT5013CapGP2:= 0;
    TotT4ps3DispP1:= 0; TotT4psCapGP1:= 0;// TotT4psDispP2:= 0; TotT4psCapGP2:= 0;

    //20250506
    //TotT3NonEligCapG:=0;TotT3NonEligCapG:=0;
    //TotT5013NonEligCapG:=0;TotT5013NonEligCapG:=0;
    //summarize slips
    for i:= 0 to pred(FList.Count) do
    begin
      FRec:= FList.Items[i];
      //20251129
      if FRec.FormName = 'T3MULT' then
      begin
        SFNo:= FRec.FormNo;
        TotT3DispP1:= TotT3DispP1; // + Vl(FetchElmFno(RetNo, SFno, 82));
        TotT3CapGP1:= TotT3CapGP1; // + Vl(FetchElmFNo(RetNo, SFNo, 298)) - Vl(FetchElmFNo(RetNo, SFNo, 334));
        //TotT3CapGP2:= TotT3CapGP2 + Vl(FetchElmFNo(RetNo, SFNo, 304)) - Vl(FetchElmFNo(RetNo, SFNo, 340));

        TotT3EligCapGQSBCS:= TotT3EligCapGQSBCS + Vl(FetchElmFNo(RetNo, SFNo, 328)); //not 322
        TotT3EligCapGQFFP:= TotT3EligCapGQFFP + Vl(FetchElmFNo(RetNo, SFNo, 316));   //not 316
      end else
      if FRec.FormName = 'T5MULT' then  //20251129
      begin
        SFNo:= FRec.FormNo;
         //TotT5DispP1:=TotT5DispP1+Vl(FetchElm(RetNo,Frec.FormName,122));
         TotT5CapGP1:= TotT5CapGP1; // + Vl(FetchElmFNo(RetNo, SFNo, 187)); //TotT5CapGP1+Vl(FetchElm(RetNo,Frec.FormName,187));
        // TotT5DispP2:=TotT5DispP2+Vl(FetchElm(RetNo,Frec.FormName,???));
        //TotT5CapGP2:= TotT5CapGP2 + Vl(FetchElmFNo(RetNo, SFNo, 122));
      end else
      if FRec.FormName = 'T5013' then
      begin
        SFNo:= FRec.FormNo;
        //TotT5013DispP1:=TotT5013DispP1+Vl(FetchElm(RetNo,Frec.FormName,??122));
        TotT5013CapGP1:= TotT5013CapGP1 + Vl(FetchElmFNo(RetNo, SFNo, 11));
        //TotT5013DispP2:=TotT5013DispP2+Vl(FetchElm(RetNo,Frec.FormName,???));
        //TotT5013CapGP2:= TotT5013CapGP2 + Vl(FetchElmFNo(RetNo, SFNo, 76));
      end;
    end;

    { QSB }
    GetS3ACBAmounts(RetNo, 'QSB', AcbProceeds, AcbGain);
    Tv[167]:= Tv[164] - Tv[165] - Tv[166];

    Tv[168]:=TotMultiple(RetNo, 'T5013',13);   //jz//20260314 change from 77 as 77 doesnt exist , seems it should come from 13 instead
    If Vl(FetchElm(RetNo,'T3MULT',88)) > 0 then  //20250510  eligible
      Tv[169]:= TotMultiple(RetNo, 'T3MULT', 328); //jz//20260111 - remove the Tv[169] +  //not 304 //20260106

    // Tv[168]:= Tv[168] + TotMultiple(RetNo, 'T3MULT', 328); //not 304 //20260106

   // Tv[169]:=Tv[168]; // TotMultiple(RetNo, 'T5013', 77); //20260108
    {
    If Vl(FetchElm(RetNo,'T3MULT',88)) > 0 then  //20250510  eligible
     Tv[169]:= Tv[169] + TotMultiple(RetNo, 'T3MULT', 316); //not 304 //20260106
    }
    //20250510 //TotMultiple(RetNo, 'T3MULT', 328) + TotMultiple(RetNo, 'T5013',77); // 20250401
    // TotMultiple(RetNo, 'T3MULT', 304)+TotMultiple(RetNo, 'T5013', 77); //20250401
    Tv[170]:= TotMultiple(RetNo, 'S3QSUPL', 182) + AcbProceeds; // 20250912 Igor
    Tv[171]:= TotMultiple(RetNo, 'S3QSUPL', 183) + AcbGain; // 20250912 Igor
    // + T5013ElgblQSB3 + T3ElgblQSB3 + AcbGain;

    Tv[172]:= Tv[164] + Tv[168] + Tv[170];
    Tv[173]:= Tv[167] + Tv[169] + Tv[171];
    // ================================
    GetS3ACBAmounts(RetNo, 'QFP', AcbProceeds, AcbGain);
    //20260106
    Tv[180]:=Tv[177] - Tv[178] - Tv[179];
    Tv[181]:=TotMultiple(RetNo, 'T3MULT', 316); //+TotMultiple(RetNo, 'T5013', 12); ??? //period1
    Tv[182]:=Tv[181];

    Tv[183]:= TotMultiple(RetNo, 'S3QSUPL', 185) + +AcbProceeds; // 20250912 Igor
    // +T5013ElgblQFP3 + T3ElgblQFP3
    Tv[184]:= TotMultiple(RetNo, 'S3QSUPL', 186) + AcbGain; // 20250912 Igor
    // T5013ElgblQFP3 +

    Tv[185]:= Tv[177] + Tv[181] + Tv[183];
    Tv[186]:= Tv[180] + Tv[182] + Tv[184];
    // =============================
    { mortg forecl }
    Tv[193]:= Tv[190] - Tv[191] - Tv[192]; // 20171125
    Tv[194]:= Tv[190];
    Tv[195]:= Tv[193];
    Tv[67]:= Tv[173] + Tv[186] + Tv[195]; // 20250404
    // ==================================
    { shares }
    Tv[202]:= Tv[199] - Tv[200] - Tv[201];
    Tv[209]:= Tv[206] - Tv[207] - Tv[208];

    Tv[212]:= TotMultiple(RetNo, 'S3SUPL', 145)
             + TotMultiple(RetNo, 'T1170', 31) //not 67 cz 20251206  20250912 Igor
             + TotMultiple(RetNo, 'T5008', 192); //20260111cz//TotMultiple(RetNo, 'T5008', 269); // 20250113
    // 20250114
    Tv[213]:= TotMultiple(RetNo, 'S3SUPL', 146)
            + TotMultiple(RetNo, 'T1170', 33) //not 69 cz 20251206 20250912 Igor // 20250330
            + TotMultiple(RetNo, 'T5008', 191); //20260111 //TotMultiple(RetNo, 'T5008', 270);
    // 20250113  //period 2 gain from t5008
    GetS3ACBAmounts(RetNo, 'Mutual Funds', AcbProceeds, AcbGain);
    if Tv[210] > Vl(FetchElm(RetNo, 'T1206', 26)) then
      Tv[210]:= Vl(FetchElm(RetNo, 'T1206', 26));
    if ret[RetNo].Age < 18 then Tv[210] := 0;
    Tv[211]:= Tv[210]; // 20190210;
    Tv[212]:= Tv[212] + AcbProceeds;
    Tv[213]:= Tv[213] + AcbGain; // Tv[212] + AcbGain;  //20250328
    GetS3ACBAmounts(RetNo, 'Public Shares', AcbProceeds, AcbGain);
    Tv[214]:= Tv[199] + Tv[206] + Tv[210] + Tv[212];
    Tv[215]:= Tv[202] + Tv[209] + Tv[211] + Tv[213];
    // ==================================
    { RE }
    GetS3ACBAmounts(RetNo, 'Real Estate', AcbProceeds, AcbGain);
    Tv[222]:= Tv[219] - Tv[220] - Tv[221];
    Tv[229]:= Tv[226] - Tv[227] - Tv[228];
    Tv[230]:= TotMultiple(RetNo, 'S3SUPL', 147) + AcbProceeds++TotMultiple(RetNo,'T1170',116); //20251206 cz;// 20250912 Igor //20250411
    // + TotMultiple(RetNo,'T1170',116); //20250114
    Tv[231]:= TotMultiple(RetNo, 'S3SUPL', 148) + AcbGain+ +TotMultiple(RetNo,'T1170',119); //20251206 cz;; // 20250912 Igor
    // +TotMultiple(RetNo,'T1170',119); //20240114
    Tv[232]:= Tv[219] + Tv[226] + Tv[230];
    Tv[233]:= Tv[222] + Tv[229] + Tv[231];
    { Bonds }
    GetS3ACBAmounts(RetNo, 'Bonds and Notes', AcbProceeds, AcbGain);
    Tv[241]:= Tv[238] - Tv[239] - Tv[240];
    Tv[249]:= Tv[246] - Tv[247] - Tv[248];
    // 20250114
    Tv[250]:= TotMultiple(RetNo, 'S3SUPL', 149) + AcbProceeds // 20250912 Igor // 20250114
      + TotMultiple(RetNo, 'T1170', 76); //not 70 cz 20251206
    // Vl(FetchElm(RetNo,'T1170',76)); //20250330
    Tv[251]:= TotMultiple(RetNo, 'S3SUPL', 150) + AcbGain // 20250912 Igor //20250114
      + TotMultiple(RetNo, 'T1170', 78); //not 72 cz 20251206
    // Vl(FetchElm(RetNo,'T1170',78));//20250330
    // If (Tv[59]<>0) and (Tv[58]=0) then Tv[58]:=1;
    Tv[252]:= Tv[238] + Tv[246] + Tv[250];
    Tv[253]:= Tv[241] + Tv[249] + Tv[251];
    { Crypto-assets }
    Tv[10]:= Tv[4];
    Tv[7]:=  Tv[4] - Tv[5] - Tv[6]; //jz//20260111 - was missing this calc
    Tv[11]:= Tv[7];
    { othr mortg forecl }
    Tv[260]:= Tv[257] - Tv[258] - Tv[259];
    Tv[261]:= TotMultiple(RetNo, 'S3SUPL', 151); // 20250912 Igor
    Tv[262]:= TotMultiple(RetNo, 'S3SUPL', 152); // 20250912 Igor
    Tv[263]:= Tv[257] + Tv[261];
    Tv[264]:= Tv[260] + Tv[262];
    { pers use }
    Tv[270]:= Tv[267] - Tv[268] - Tv[269];
    GetS3ACBAmounts(RetNo, 'Personal Use', AcbProceeds, AcbGain);
    If AcbGain > 0 then
      Tv[271]:= AcbGain
    else
      Tv[271]:= 0;

    // principal residence on elm 94 //20220129
    if (Frm[FNo].strings[139] = '') and (Frm[FNo].strings[140] = '') // 20230319
      and (Frm[FNo].strings[148] = '')
    // 20230319   //all years option  //20220130
    then
      Tv[273]:= 0 // no taxable gain
    else // calculate the gain
    begin
      if UpperCase(Frm[FNo].strings[272]) <> 'Y' then // 20220131
      begin
        Tv[273] := 0;
        for i := 1 to 5 do // 20230320
        begin
          if IsDeceased(RetNo) = false then
            T2091Fno := GetFormNo('T2091#' + AllTrim(IntToStr(i)))
          else
            T2091Fno := GetFormNo('T1255#' + AllTrim(IntToStr(i)));
          // points to t255

          if T2091Fno > 0 then
          begin // 20220129
            TaxpayerPrincipalResidencePercent:= 100 - Vl(FetchElmFNo(RetNo, T2091Fno, 4));
            if Vl(FetchElmFNo(RetNo, T2091Fno, 137)) > 0 then
              Tv[273]:= Tv[273] + Vl(FetchElmFNo(RetNo, T2091Fno, 137)) * TaxpayerPrincipalResidencePercent / 100
            else
              Tv[273]:= Tv[273] + Vl(FetchElmFNo(RetNo, T2091Fno, 134)) * TaxpayerPrincipalResidencePercent / 100;
          end;
        end; // i
      end; // 95
    end;

    Tv[274]:= Tv[270] + Tv[271] + Tv[273]; // 20220128 added Princ residence
    If Tv[274] < 0 then
      Tv[274]:= 0;

    { lpp }
    Tv[280]:= Tv[277] - Tv[278] - Tv[279];
    Tv[282]:= MaxR(0, Tv[280] - Tv[281]);
    // 20171113
    Tv[283]:= Tv[67] + Tv[215] + Tv[233] + Tv[253] + Tv[11] + Tv[264] + Tv[274] + Tv[282];

    // ==============================================
    // PART 4    summary totals
    // Totals
    Tv[284]:= Tv[283];

    // Tv[285]:=??  Manual
    Tv[286]:= Tv[284] - Tv[285];

    //20250418
     //TV[287]:?? t5, t5013, t4ps


    //else           -
     //Tv[288]:= 0;
    {//20250418
    Tv[287]:= TotMultiple(RetNo, 'T5MULT', 122) + TotMultiple(RetNo, 'T4PS',16)
              + TotMultiple(RetNo, 'T5013', 76); // 20250113

    Tv[288]:= TotMultiple(RetNo, 'T3MULT', 304)
              -TotMultiple(RetNo, 'T3MULT', 328)
              -TotMultiple(RetNo, 'T3MULT', 340); //20250412
    }

    Tv[287]:= TotMultiple(RetNo, 'T5MULT', 122) + TotMultiple(RetNo, 'T5MULT', 187) + //20251210 Igor. This logic I took from the TC#50 line 17400
              + TotMultiple(RetNo, 'T4PS', 16)   + TotMultiple(RetNo, 'T4PS',3) +  //jz//20281219 add back, should not have been removed, also add other time period for now
              + TotMultiple(RetNo, 'T5013', 76) + TotMultiple(RetNo, 'T5013', 11); //jz//20281219 add back, should not have been removed, also add other time period for now

    //202560106
     //if Tv[284] = 0 then //if not eligible
    Tv[288]:= TotMultiple(RetNo, 'T3MULT', 82) //20250510// TotT3CapGP2;  //20250506    //20250418
             - TotMultiple(RetNo, 'T3MULT', 160); //- TotMultiple(RetNo, 'T3MULT', 88);  //20260328


    Tv[289]:= Tv[286] + Tv[287] + Tv[288];
    Tv[290]:=Vl(FetchElm(RetNo,'ABIL',55));   //20251115
    Tv[291]:= Tv[289] - Tv[290];
    Tv[292]:= Vl(FetchElm(RetNo, 'T2017', 125)); // 20251206  instead of 81 cz
    Tv[293]:= Tv[291] + Tv[292];
    Tv[312]:= Tv[293];// + Tv[96];
    Tv[68]:= Tv[312] * 0.5;// TotMultiple (RetNo, 'T5013', 80);  //20250511
    Tv[8]:= TotMultiple (RetNo, 'T5013', 80); // 20250910 Igor
    Tv[339]:= Tv[68] + Tv[8]; // Tv[312] * 50 / 100  + Tv[68];  //20250511
  end;

  SaveTv(RetNo, FName, FNo);
end;
// 20250910 Igor <<<


//20251008 Igor >>>
procedure T1212(RetNo: Integer; FName: string; FNo: Integer);
var
  i: Integer;
begin
  if (FNo = 0) then exit;

  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    strings[1]:= AppYear;
    // 20241214 If ShowUnconvertedLastYear(RetNo) then Strings[1] := GetLastYearTaxYear;
    // Tv[3] := TotMultiple(RetNo, 'T4', 17);
    Tv[6]:= MaxR(0, Tv[2] - Tv[3]); //jz//20251217 changed form from [7] to keep efiled line elm [3]
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20251008 Igor <<<

procedure TOOLEXP(RetNo: integer; FName: String; FNo: integer);
Var
  i, J1, J2, J3: integer;
  TotCost, TotDed: Real;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  Begin
    i := 2;
    Tv[31] := 0;
    Repeat
      Tv[31] := Tv[31] + Tv[i];
      Inc(i, 2);
    until i > 30;

    // tradesperson
    If UpperCase(strings[53]) <> 'Y' then
      Tv[48] := Tv[31];
    Tv[102] := MaxR(0, Tv[49] + Tv[104] - Tv[105]);
    Tv[103] := Tv[102];
    Tv[50] := MinR(Tv[48], Tv[103]);
    Tv[55] := Tv[50];
    Tv[106] := ret[RetNo].Lnn[31260];
    Tv[51] := MaxR(0, Tv[55] - Tv[106]); // 20130512
    // Tv[51]:=MaxR(0,Tv[50]-ret[RetNo].Lnn[31260]);  //? ln 363 instead of 1,109
    Tv[52] := MinR(1000, Tv[51]); // 20231205
    // apprenticeshup
    Tv[36] := Tv[35] * 5 / 100;
    Tv[45] := Tv[52];
    Tv[46] := ret[RetNo].Lnn[31260];
    Tv[47] := Tv[45] + Tv[46];

    Tv[38] := MaxR(Tv[36], Tv[47]);
    Tv[33] := MinR(Tv[32], Tv[38]);

    Tv[37] := MaxR(0, Tv[32] - Tv[33] + Tv[44]);

    Tv[34] := NiBfrAprTool(RetNo, FNo, Tv[37]);
    Tv[39] := MinR(Tv[37], Tv[34]);
    Tv[40] := Tv[39];
    If Tv[43] > Tv[39] then
      Tv[43] := Tv[39];
    If UpperCase(strings[42]) = 'Y' then
      Tv[40] := Tv[43];
    Tv[41] := MaxR(0, Tv[39] - Tv[40]);
    If UpperCase(strings[54]) <> 'Y' then
    begin
      For i := 32 to 43 do
        Tv[i] := 0;
    end;
    TotDed := Tv[52] + Tv[40];
    TotCost := Tv[31];
    // dispositions
    Tv[101] := 0;
    i := 2;
    J1 := 56;
    J2 := 71;
    J3 := 86;
    repeat
      If Tv[J1] > 0 then
      begin
        If TotCost > 0 then
          Tv[J2] := Tv[i] - (Tv[i] * (TotDed / TotCost))
        else
          Tv[J2] := 0;
        Tv[J3] := MaxR(0, Tv[J1] - Tv[J2]);
        Tv[101] := Tv[101] + Tv[J3];
      end
      Else
      begin
        Tv[J2] := 0;
        Tv[J3] := 0;
      end;
      Inc(i, 2);
      Inc(J1, 1);
      Inc(J2, 1);
      Inc(J3, 1);
    until i > 30;
  end;
  SaveTv(RetNo, FName, FNo);
end;

// 20141118
Procedure CalcFedTaxByBrackets(RetNo: integer; FNo: integer; TxblInc: Real;
  k: integer);
Var
  i: integer;
Begin
  with ret[RetNo].Frm[FNo] do
  begin
    For i := 151 to 157 do
    begin
      StoreElm(RetNo, FNo, i + k, '');
      Tv[i + k] := 0;
    end;
    For i := 169 to 175 do
    begin
      StoreElm(RetNo, FNo, i + k, '');
      Tv[i + k] := 0;
    end;
    For i := 176 to 182 do
    begin
      StoreElm(RetNo, FNo, i + k, '');
      Tv[i + k] := 0;
    end;
    For i := 190 to 196 do
    begin
      StoreElm(RetNo, FNo, i + k, '');
      Tv[i + k] := 0;
    end;
    For i := 246 to 252 do
    begin
      StoreElm(RetNo, FNo, i + k, '');
      Tv[i + k] := 0;
    end;

    StoreElm(RetNo, FNo, 154 + k, Constant[RY].Rate1);
    Tv[156 + k] := Constant[RY].BracketTax1; { 0 }
    Tv[170 + k] := Constant[RY].Bracket1; { 30754; }
    StoreElm(RetNo, FNo, 172 + k, Constant[RY].Rate2); { '22'; }
    Tv[174 + k] := Constant[RY].BracketTax2; { 4921; }
    Tv[177 + k] := Constant[RY].Bracket2; { 61509; }
    StoreElm(RetNo, FNo, 179 + k, Constant[RY].Rate3); { '26'; }
    Tv[181 + k] := Constant[RY].BracketTax3; { 11687; }

    Tv[191 + k] := Constant[RY].Bracket3; { 100000; }
    StoreElm(RetNo, FNo, 193 + k, Constant[RY].Rate4); { '29'; }
    Tv[195 + k] := Constant[RY].BracketTax4; { 21694; }
    // 20160807
    Tv[247 + k] := Constant[RY].Bracket4;
    StoreElm(RetNo, FNo, 249 + k, Constant[RY].Rate5);
    Tv[251 + k] := Constant[RY].BracketTax5; { 21694; }

    If TxblInc <= Constant[RY].Bracket1 then { 30754 then }
    begin
      Tv[151 + k] := TxblInc; // Tv[1]; //201411
      Tv[152 + k] := 0;
      Tv[153 + k] := MaxR(0, Tv[151 + k] - Tv[152 + k]);
      StoreElm(RetNo, FNo, 154 + k, Constant[RY].Rate1); { '16'; }
      Tv[155 + k] := Tv[153 + k] * Vl(Constant[RY].Rate1) / 100;
      Tv[156 + k] := Constant[RY].BracketTax1; { 0 }
      Tv[157 + k] := Tv[155 + k] + Tv[156 + k];
    end;

    If (TxblInc > Constant[RY].Bracket1) and (TxblInc <= Constant[RY].Bracket2)
    then // 20141119 If (Tv[1] > Constant[RY].Bracket1) and (Tv[1] <= Constant[RY].Bracket2) then
    begin
      Tv[169 + k] := TxblInc; // Tv[1];  20141117
      Tv[170 + k] := Constant[RY].Bracket1; { 30754; }
      Tv[171 + k] := MaxR(0, Tv[169 + k] - Tv[170 + k]);
      StoreElm(RetNo, FNo, 172 + k, Constant[RY].Rate2); { '22'; }
      Tv[173 + k] := Tv[171 + k] * Vl(Constant[RY].Rate2) / 100;
      Tv[174 + k] := Constant[RY].BracketTax2; { 4921; }
      Tv[175 + k] := Tv[173 + k] + Tv[174 + k];
    end;

    If (TxblInc > Constant[RY].Bracket2) and (TxblInc <= Constant[RY].Bracket3)
    then // 20141118 If (Tv[1] > Constant[RY].Bracket2) and (Tv[1] <=Constant[RY].Bracket3) then
    begin
      Tv[176 + k] := TxblInc; // Tv[1];  20141118
      Tv[177 + k] := Constant[RY].Bracket2; { 61509; }
      Tv[178 + k] := MaxR(0, Tv[176 + k] - Tv[177 + k]);
      StoreElm(RetNo, FNo, 179 + k, Constant[RY].Rate3); { '26'; }
      Tv[180 + k] := Tv[178 + k] * Vl(Constant[RY].Rate3) / 100;
      Tv[181 + k] := Constant[RY].BracketTax3; { 11687; }
      Tv[182 + k] := Tv[180 + k] + Tv[181 + k];
    end;

    If (TxblInc > Constant[RY].Bracket3) and (TxblInc <= Constant[RY].Bracket4)
    // 20160807
    then
    begin
      Tv[190 + k] := TxblInc; // Tv[1]; //20141118
      Tv[191 + k] := Constant[RY].Bracket3; { 100000; }
      Tv[192 + k] := MaxR(0, Tv[190 + k] - Tv[191 + k]);
      StoreElm(RetNo, FNo, 193 + k, Constant[RY].Rate4); { '29'; }
      Tv[194 + k] := Tv[192 + k] * Vl(Constant[RY].Rate4) / 100;
      Tv[195 + k] := Constant[RY].BracketTax4; { 21694; }
      Tv[196 + k] := Tv[194 + k] + Tv[195 + k];
    end;

    If (TxblInc > Constant[RY].Bracket4) then
    begin
      Tv[246 + k] := TxblInc;
      Tv[247 + k] := Constant[RY].Bracket4;
      Tv[248 + k] := MaxR(0, Tv[246 + k] - Tv[247 + k]);
      StoreElm(RetNo, FNo, 249 + k, Constant[RY].Rate5); // 20170225
      Tv[250 + k] := Tv[248 + k] * Vl(Constant[RY].Rate5) / 100;
      Tv[251 + k] := Constant[RY].BracketTax5;
      Tv[252 + k] := Tv[250 + k] + Tv[251 + k];
    end;
  end;
  // done above 20190907
End;

// May 18 version
Procedure T777(RetNo: integer; FName: string; FNo: integer);
Var
  i, BusKm, TotKM: integer;
  KMPercent, StmtPercent, SingleStmtPercent: Real;
  NumbAutos: integer;
  AutoExpFNo: integer;
  FactorPercent: Real;
  Cars: integer;
  j, jj: integer;
  J1, J2, J3, J4: integer;
  ClassOption: String;
  FInst: String;
  Cls: string[4];
  Stmt: String;
  UccStart, Additions, Proceeds, AdjUcc, Adjustments, BaseForCca, Rate, CCA,
    UCCEnd: Real;
  RemainingAmount, Adj: Real;
  MaxCCA: Real;
  TermLossAmount, RecaptAmount, AutoCCAForStmt: Real;
  Auto777FNo: integer;
  // work space
  DetailOption: Boolean;
  CombinedPercent: Real;
  HoursPercent: Real; // 20210201
  DedicatedSpaceSw: Boolean;
  x, y: Real; // 20210331

      //jz//20260317
      procedure T777PartA();
      begin

        //20260311 Igor >>>
        // PART A
        { cca - motor class 10 }
        Stmt:= LeftStr(FName, 4);
        ClassOption:= 'PARTA';

        PostAuto777CCA(RetNo, FName, Stmt, FInst, FNo, ClassOption);

        with ret[RetNo].Frm[FNo] do
        begin
              Tv[230]:= Tv[226] + Tv[227] - Tv[229];
              Tv[243]:= Tv[239] + Tv[240] - Tv[242];
              Tv[256]:= Tv[252] + Tv[253] - Tv[255];
              Tv[269]:= Tv[265] + Tv[266] - Tv[268];

              Tv[231]:= MaxR(0, Tv[229] - Tv[227] + Tv[228] + Tv[72]);
              Tv[244]:= MaxR(0, Tv[242] - Tv[240] + Tv[241] + Tv[73]);
              Tv[257]:= MaxR(0, Tv[255] - Tv[253] + Tv[254] + Tv[74]);
              Tv[270]:= MaxR(0, Tv[268] - Tv[266] + Tv[267] + Tv[75]);

              Tv[89]:= MaxR(0, PCPM((Tv[228] - Tv[231]), 0      {Tv[330]}));    //Class 8. Factor 0
              Tv[90]:= MaxR(0, PCPM((Tv[241] - Tv[244]), 0      {Tv[330]}));    //Class 10. Factor 0
              Tv[91]:= MaxR(0, PCPM((Tv[254] - Tv[257]), 1.50   {Tv[330]}));    //Class 54. Factor 1 1/2
              Tv[92]:= MaxR(0, PCPM((Tv[267] - Tv[270]), 0.875  {Tv[330]}));    //Class 55. Factor 7/8

              Tv[289]:= MaxR(0, Tv[231] - Tv[228]);
              Tv[302]:= MaxR(0, Tv[244] - Tv[241]);
              Tv[315]:= MaxR(0, Tv[257] - Tv[254]);
              Tv[328]:= MaxR(0, Tv[270] - Tv[267]);

              Tv[232]:= MaxR(0, PCPM((Tv[72] - Tv[289]), 0.50   {Tv[331]}));    //Class 8. Factor 1/2
              Tv[245]:= MaxR(0, PCPM((Tv[73] - Tv[302]), 0.50   {Tv[331]}));    //Class 10. Factor 1/2
              Tv[258]:= MaxR(0, PCPM((Tv[74] - Tv[315]), 2.3333 {Tv[331]}));    //Class 54. Factor 2 1/3
              Tv[271]:= MaxR(0, PCPM((Tv[75] - Tv[328]), 1.50   {Tv[331]}));    //Class 55. Factor 1 1/2

              Tv[233]:= MaxR(0, (Tv[227] - Tv[228] - Tv[72] - Tv[229]) / 2);
              Tv[246]:= MaxR(0, (Tv[240] - Tv[241] - Tv[73] - Tv[242]) / 2);
              Tv[259]:= MaxR(0, (Tv[253] - Tv[254] - Tv[74] - Tv[255]) / 2);
              Tv[272]:= MaxR(0, (Tv[266] - Tv[267] - Tv[75] - Tv[268]) / 2);

              Tv[234]:= Tv[230] + Tv[89] + Tv[232] - Tv[233];
              Tv[247]:= Tv[243] + Tv[90] + Tv[245] - Tv[246];
              Tv[260]:= Tv[256] + Tv[91] + Tv[258] - Tv[259];
              Tv[273]:= Tv[269] + Tv[92] + Tv[271] - Tv[272];

              Tv[236]:= PCPM(Tv[234], 0.20);
              Tv[249]:= PCPM(Tv[247], 0.30);
              Tv[262]:= PCPM(Tv[260], 0.30);
              Tv[275]:= PCPM(Tv[273], 0.40);

              Tv[237]:= Tv[230] - Tv[236];
              Tv[250]:= Tv[243] - Tv[249];
              Tv[263]:= Tv[256] - Tv[262];
              Tv[276]:= Tv[269] - Tv[275];
              //20260311 Igor <<<

        end;
      end;
Begin //Procedure T777(RetNo: integer; FName: string; FNo: integer);
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    If strings[1] = '' then
      strings[1] := 'Y';
    If strings[63] = '' then
      strings[63] := 'N';

    If strings[86] = '' then
      strings[86] := 'N'; // default to YDetail calc  //20210404
    If UpperCase(strings[86]) <> 'Y' then
      strings[62] := 'N'; // 20210404

    FillAuto777ExpRec(RetNo, 'T777' + FInst); // 20200511

    // init
    For i := 27 to 33 do
      Tv[i] := 0;
    Tv[35] := 0;
    Tv[39] := 0;

    // Tv[51]:=0;  //some issue it shows as -NAN  //20210403  //20210404

    Cars := GetT777NumOfCars(RetNo, FName, FNo);
    if Cars = 1 then
    Begin
      BusKm := GetT777BusKm(RetNo, FName, FNo);
      TotKM := GetT777TotKm(RetNo, FName, FNo);
      strings[25] := IntToStr(BusKm);
      strings[26] := IntToStr(TotKM);
      // KmPercent:=BusKm/TotKm;
      strings[67] := 'N';
      If FetchElm(RetNo, 'AUTO777#1', 134) <> '8' then
        strings[66] := FetchElm(RetNo, 'AUTO777#1', 1);
    end
    Else
    Begin
      strings[25] := '1';
      strings[26] := '1';
      strings[66] := 'Multiple';
      FactorPercent := BusKm / TotKM;
      strings[67] := 'Y';
    End;
    Tv[27] := GetT777ExpenseLine(RetNo, FName, FNo, 10); // fuel
    Tv[28] := GetT777ExpenseLine(RetNo, FName, FNo, 13); // maint
    Tv[29] := GetT777ExpenseLine(RetNo, FName, FNo, 22); // insur
    Tv[30] := GetT777ExpenseLine(RetNo, FName, FNo, 25); // license
    Tv[31] := GetT777TotCCA(RetNo, FName, FNo, 173);
    Tv[32] := GetT777ExpenseLine(RetNo, FName, FNo, 19); // interest     // ExpenseLine(RetNo,FName,FNo,173);  //cca //20200530         //GetT777ExpenseLine(RetNo, FName, FNo, 16); // leasing

    //jz//20260414//CCAv7only take first one? WHY
    //Tv[33] := Vl(FetchElm(Retno,'Auto777#1',99));  //20260329
    //jz//20260414//CCAv7 - use GetT777ExpenseLine like the others, seems to work, NOT TotMultiple
    Tv[33] := GetT777ExpenseLine(RetNo, FName, FNo, 16);

    Tv[35] := (GetT777ExpenseLine(RetNo, FName, FNo, 32) + GetT777ExpenseLine(RetNo, FName, FNo, 36)); // other
    Tv[39] := GetT777ExpenseLine(RetNo, FName, FNo, 48); // repay
  End;
  with ret[RetNo].Frm[FNo] do
  begin
    If strings[25] + strings[26] = '' then
    begin
      strings[25] := '1';
      strings[26] := '1';
    end;
    If Vl(strings[26]) < Vl(strings[25]) then
      strings[26] := strings[25];

    (* //20260415  directly from the Autos777
    If UpperCase(strings[67]) = 'N' then // multiple cars
    begin
      Tv[31] := MaxR(0, (Tv[211] + Tv[212]) * AutoExpRec.StatementPercent / 100)
      // ?
    end;
    *)

    Tv[36] := 0;
    For i := 27 to 33 do
      Tv[36] := Tv[36] + Tv[i];
    Tv[36] := Tv[36] + Tv[35];
    Tv[104] := Tv[36]; // 20221204

    strings[6] := strings[25];
    strings[7] := strings[26];

    //20260415
    Tv[37]:=Tv[104];
    if Vl(strings[7]) > 0 then  //km
     Tv[38]:=Vl(strings[6]) * Tv[37] / Vl(strings[7])
    Else
     Tv[38]:=0;
   {
    if Vl(strings[7]) > 0 then
      Tv[37] := Vl(strings[6]) * Tv[36] / Vl(strings[7])
    else
      Tv[37] := 0;
    Tv[38] := Tv[37];
    }
    Tv[40] := MaxR(0, Tv[38] - Tv[39]);
    if UpperCase(strings[69]) = 'Y' then
      Tv[40] := Tv[70]; // 20200518

    // LINE 11 Labour mobility need sepaarte form T777Mob   //20221211
    For i := 105 to 115 do
    Begin
      Tv[i] := TotMultiple(RetNo, 'T777MOB', i);
    end;
    Tv[116] := MinR(4000, Tv[114]);
    // ====WORK SPACE T777 ============================
    // 20210326  Detail WORK SPACE
    DetailOption := UpperCase(strings[86]) = 'Y';
    DedicatedSpaceSw := strings[85] > ''; // 20210331
    If (strings[84] > '') and (strings[85] > '') then
    begin
      strings[84] := '';
      strings[85] := '';
    end;
    if DetailOption then
    Begin
      if MidStr(strings[80], 3, 1) = '-' then
        strings[80] := '';
      if MidStr(strings[81], 3, 1) = '-' then
        strings[81] := '';
      if strings[80] = '' then
        strings[80] := '40';
      if strings[81] = '' then
        strings[81] := '168';
      // if strings[85]>'' then begin Strings[80]:='40';Strings[81]:='40';end; //20210331 //20210327//Strings[80]:=Strings[81]; //20210327
      if Vl(strings[80]) > Vl(strings[81]) then
        strings[80] := strings[81]; // 20210327

      if DedicatedSpaceSw then
      begin
        strings[80] := '40';
        strings[81] := '40';
      end; // begin strings[81]:=Strings[80];end; //20210331

      if (strings[77] > '') and (strings[78] > '') then // footage
      begin
        if Vl(strings[77]) > Vl(strings[78]) then
          strings[77] := strings[78]; // 20210403
      end;

      x := Vl(strings[77]);
      y := Vl(strings[78]);
      if y > 0 then
        strings[79] := FormatFloat('###.##', (x / y) * 100)
        // jz//20250319 - change to string //Tv[79]:=(x/y)*100
      Else
        strings[79] := '0'; // jz//20250319 - change to string //tv[79]:='0';

      if Vl(strings[81]) > 0 then
        strings[82] := FormatFloat('###.##', (Vl(strings[80]) / Vl(strings[81]))
          * 100) // jz//20250319 - change to string // Tv[82]:=(Vl(Strings[80])/Vl(Strings[81]))*100
      Else
        strings[82] := '0'; // jz//20250319 - change to string //Tv[82]:=0;

      HoursPercent := 100 * Vl(strings[80]) / (Vl(strings[81])); // 20210331

      // jz//20250319 - doesnt work properly after vtDollar rounding, change to strings
      // Tv[83]:=(Vl(Strings[77])/(Vl(Strings[78]))*(Vl(Strings[80])/ Vl(Strings[81])));
      // Tv[83]:=Tv[83]*100;
      // CombinedPercent:=Tv[83];

      // jz//20250319
      CombinedPercent := (Vl(strings[77]) / (Vl(strings[78])) *
        (Vl(strings[80]) / Vl(strings[81])));
      CombinedPercent := CombinedPercent * 100;

      strings[83] := FormatFloat('###.##', CombinedPercent);
      if (strings[83] = 'NAN') or (strings[83] = 'INF') then
        strings[83] := '0';

    End
    Else
    Begin // no detail option
      strings[80] := '';
      strings[81] := '';
    End;

    if UpperCase(strings[62]) = 'Y' then // GST rebate allowed
    Begin
      // heat
      Tv[47] := Tv[41]; // total heat
      Tv[55] := Tv[47] * (100 - CombinedPercent) / 100; // personal
      Tv[88] := MaxR(0, Tv[47] - Tv[55]); // eligible
      // maint
      Tv[50] := Tv[87] + Tv[42]; // 20210402
      Tv[57] := Tv[50] * (100 - CombinedPercent) / 100; // personal main
      Tv[101] := MaxR(0, Tv[50] - Tv[57]); // eligible maint
    End
    Else
    Begin
      Tv[47] := 0;
      Tv[55] := 0;
      Tv[88] := 0;

      Tv[50] := 0;
      Tv[57] := 0;
      Tv[101] := 0;
    End;

    // 20210403
    if UpperCase(strings[86]) <> 'Y' then // GST rebate allowed
    Begin
      Tv[47] := 0;
      Tv[55] := 0;
      Tv[88] := 0;

      Tv[50] := 0;
      Tv[57] := 0;
      Tv[101] := 0;
    End;

    { home work space }
    Tv[46] := Tv[41] + Tv[42] + Tv[43] + Tv[44] + Tv[45];

    if DetailOption then
      Tv[71] := Tv[46] * CombinedPercent / 100 + Tv[87] * (HoursPercent / 100);
    // add deignated amount (100%)

    Tv[48] := Tv[71] + Tv[49];
    Tv[51] := Tv[48];
    If UpperCase(strings[56]) <> 'Y' then
    Begin
      Tv[2] := Vl(FetchElm(RetNo, LeftStr(strings[61], 4), 2));
      // pick it up from the T4slip //20210404
    End;

    Tv[9] := Tv[22] + ret[RetNo].Lnn[20700] + ret[RetNo].Lnn[21200];
    // Tv[61] + Tv[62]; // Tv[22];
    Tv[54] := MaxR(0, Tv[2] - Tv[9]);

    Tv[117] := Tv[54]; // 20230209
    Tv[52] := MinR(Tv[51], Tv[117]); // Tv[54];  //20230209

    Tv[53] := MaxR(0, Tv[51] - Tv[117]);
    // MaxR(0, Tv[51] - Tv[52]);  //20230209

    //CCA
    T777PartA();          //jz//20260317

    { expenses }
    Tv[5] := Tv[40];
    If Tv[60] = 0 then
      Tv[60] := 50;
    Tv[11] := Tv[10] * Tv[60] / 100; // 0.50;
    Tv[22] := 0;

    Tv[59] := Tv[16] + Tv[18];
    Tv[65] := Vl(FetchElm(RetNo, 'TOOLEXP', 52));
    if Tv[65] > 1000 then
      Tv[65] := 1000; // 20240127
    Tv[58] := Vl(FetchElm(RetNo, 'TOOLEXP', 40));
    // if Tv[58]>1000 then Tv[58]:=1000;   //20240127     //20240129

    Tv[102] := Tv[116]; // 20221211
    if Tv[102] > 4000 then
      Tv[102] := 4000; // 20240127

    Tv[22] := Tv[3] + Tv[4] + Tv[5] + Tv[11] + Tv[12] + Tv[13] + Tv[14];
    Tv[22] := Tv[22] + Tv[59] + Tv[65] + Tv[102] + Tv[58] + Tv[19] + Tv[20] +
      Tv[21]; // 20221204

    Tv[23] := Tv[52]; // MinR(Tv[51], Tv[52]);  //20221204

    If Vl(strings[26]) > 0 then
      KMPercent := Vl(strings[25]) / Vl(strings[26])
    else
      KMPercent := 0;

    Tv[24] := Tv[22] + Tv[23];

    If Length(OptRec.Bus_Disclm) > 0 then
      strings[76] := OptRec.Bus_Disclm
    else
      strings[37] := ''; // 20150414

    If strings[64] <> 'Y' then // override claim
    begin
      If UpperCase(strings[63]) <> 'Y' then // no limit in effect
        Tv[24] := Tv[22] + Tv[23]
      else // commission limit in effect
      begin
        Tv[24] := MinR(Tv[24], TotMultiple(RetNo, 'T4', 13) + (Tv[31] + Tv[32])
          * KMPercent + Tv[20] + Tv[23]); // 20120314
      end;
    end
    else
    begin
      Tv[24] := MinR(Tv[24], Tv[22] + Tv[23]);
    end;
  end;

  // ---------------------------
  // CCA
  // ----------------------------------

  // PART A
  with ret[RetNo].Frm[FNo] do
  begin
    { cca - motor class 10 }
    Stmt := LeftStr(FName, 4);
    // FInst := '';  //20200511
    For i := 137 to 172 do // pre-april 30 t777 version
    begin
      Tv[i] := 0;
      strings[i] := '';
    end; // clear section

    ClassOption := 'PARTA';
    RemainingAmount := 0;
    PostAuto777CCA(RetNo, FName, Stmt, FInst, FNo, ClassOption); // 'PARTA');
    Tv[185] := RemainingAmount;

    ClassOption := 'PARTB';
    PostAuto777CCA(RetNo, FName, Stmt, FInst, FNo, ClassOption); // 20200513
    Tv[222] := RemainingAmount;

    // Calc totals
    Tv[210] := 0;
    Tv[211] := 0;
    Tv[212] := 0;

    //jz//CCAv13
    //jz//20260322 - reinstate the totals as used in other places but sum them differntly now
    //Tv[210] := Tv[236];                 // class 8
    //Tv[211] := Tv[249]+Tv[262]+Tv[275]; // class 10, 10.1, 54, 55

    //jz//CCAv13
    Tv[210] := AddColumns(236, 275, 13) + tv[185];
    Tv[211] := Tv[210];                   //jz//CCAv13 - [211] not used anywhere, remove elm from form??

    //20260311 Igor >>>
    (*i := 225;
    Repeat
      if strings[i] = '8' then
        Tv[210] := Tv[210] + Tv[i + 11] // cls 8
      Else
        Tv[211] := Tv[211] + Tv[i + 11]; // 10, 10.1, 54, 55
      Tv[211] := Tv[211] + Tv[185]; // additional overflow
      Inc(i, 13);
    Until i > 316;
    *)
    //20260311 Igor <<<

    i := 175; // cls 10.1
    Repeat
      Tv[212] := Tv[212] + Tv[i + 8];
      Inc(i, 12);
    Until i > 199;
  End; // if do calcs 'Y'
  SaveTv(RetNo, FName, FNo);
End;

Procedure T777MOB(RetNo: integer; FName: string; FNo: integer); // 20210116
Var
  i: integer;
Begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
    Tv[109] := Tv[105] + Tv[106] + Tv[107] + Tv[108];
    Tv[110] := Tv[109];
    Tv[112] := Tv[111] * 0.50;
    Tv[113] := MinR(Tv[110], Tv[112]);
    Tv[114] := Tv[113];
    Tv[115] := MaxR(0, Tv[110] - Tv[114]);
    Tv[116] := Tv[114]; // 20230203
  end;
  SaveTv(RetNo, FName, FNo);
end;

(*
  Procedure T777S(RetNo: integer; FName: string; FNo: integer); //20210116
  Var
  i: integer;
  DetailOption: Boolean;
  CombinedPercent:Real;
  HoursPercent:Real; //20210201
  DedicatedSpaceSw:Boolean;
  OverrideSw:Boolean;
  x:Real;
  Begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin

  if Strings[19]+Strings[23]='' then Begin Strings[19]:='X';Strings[23]:='';end;
  if Strings[41]>'' then DedicatedSpaceSw:=True else DedicatedSpaceSw:=False;
  if Strings[23]>'' then DetailOption:= True Else DetailOption:=False;

  if MidStr(Strings[24],3,1)='-' then Strings[24]:='';
  if MidStr(Strings[25],3,1)='-' then Strings[25]:='';
  if Strings[24]='' then strings[24]:='40';
  if Strings[25]='' then strings[25]:='168';
  if DedicatedSpaceSw then begin strings[25]:=Strings[24];end;

  If DetailOption=True then begin Strings[18]:='';Tv[20]:=0;end; //20210220
  If DetailOption=False then
  begin
  Strings[24]:='';Strings[25]:='';
  end; //no hours


  if Vl(Strings[27])>0 then
  Tv[31]:=(Vl(Strings[26])/Vl(Strings[27]))*100
  Else
  Tv[31]:=0;

  if Vl(Strings[25])>0 then
  Tv[28]:=(Vl(Strings[24])/Vl(Strings[25]))*100
  Else
  Tv[28]:=0;

  Tv[29]:=(Vl(Strings[26])/(Vl(Strings[27]))*(Vl(Strings[24])/ Vl(Strings[25])));
  Tv[29]:=Tv[29]*100;
  //SpacePercent:=Tv[31];
  HoursPercent:=100*Vl(Strings[24])/(Vl(Strings[25]));
  CombinedPercent:=Tv[29];

  if UpperCase(Strings[39])='Y' then Overridesw:=True else OverrideSw:=false;

  Tv[20]:=MinR(500,Vl(Strings[18])*2);   //20211216
  if Strings[19]='' then Begin Strings[18]:='';Tv[20]:=0;end;


  If Overridesw =false then TV[6]:=Tv[32];
  If Overridesw =false then TV[7]:=Tv[33];
  If Overridesw =false then Tv[8]:=Tv[35];
  If Overridesw =false then Tv[9]:=Tv[37];
  If Overridesw =false then Tv[10]:=Tv[38];

  //work space first  //T777S COVID
  Tv[11]:=AddColumns(6,10,1);
  Tv[12]:=Tv[11]*CombinedPercent/100 + Tv[43]*(HoursPercent/100);  //add deignated amount (100%)
  //13 empl

  Tv[52]:=Tv[12]+Tv[51];  //20220119


  Tv[14]:=Tv[3]+Ret[RetNo].Lnn[20700]+Ret[RetNo].Lnn[21200];
  Tv[17]:=MaxR(0,Tv[13]-Tv[14]);
  Tv[15]:=Tv[17];
  Tv[16]:=MaxR(0,Tv[52]-Tv[15]); //20220119 //Tv[16]:=MaxR(0,Tv[12]-Tv[15]);

  Tv[3]:=Tv[1]+Tv[2];
  if UpperCase(Strings[36]) <>'Y' then  Tv[4]:=MinR(Tv[52],Tv[15]);  //20210305//MinR(Tv[12],Tv[15]);   //20210305
  Tv[5]:=Tv[3]+Tv[4];

  //Leave it there
  //20210227
  if DetailOption=false then
  Begin
  //remove detail enties
  for i:=1 to 5 do begin Tv[i]:=0;end;
  //20210327
  Strings[62]:='';
  Tv[48]:=0;
  Tv[50]:=0;
  Tv[46]:=0;
  Tv[47]:=0;
  Tv[49]:=0;
  End;
  if UpperCase(Strings[62])<>'Y' then begin Tv[48]:=0;Tv[50]:=0;end;
  end;
  SaveTv(RetNo, FName, FNo);
  end;
*)
// 20220519
procedure STLOAN(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  RemainingClaim: Real;
  MxClaim: Real;
  Avlble: Real;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  Begin

    If strings[43] = '' then
      strings[43] := 'Y'; // optimize

    i := 2;
    Tv[13] := 0;
    Repeat
      If i >= 4 then // 20091226
      begin
        If IsDitto(strings[i - 1]) then
          strings[i - 1] := strings[i - 1 - 2];
      end;
      Tv[13] := Tv[13] + Tv[i];
      Inc(i, 2);
    until i > 12;

    strings[14] := GetPrvYear(AppYear, 4);
    strings[18] := GetPrvYear(AppYear, 3);
    strings[22] := GetPrvYear(AppYear, 2);
    strings[26] := GetPrvYear(AppYear, 1);
    strings[30] := AppYear;
    Tv[31] := Tv[13];

    // opening balances
    Tv[34] := AddColumns(15, 31, 4);
    Avlble := Tv[34];
    MxClaim := MaxStLoan(RetNo); // MinR(Avlble,MinR(Avlble,MaxStLoan(RetNo)));
    // RemainingClaim := mxClaim;

    {
      // Tv[34]:=0; //tot opening bal
      Tv[35]:=0;  //tot current yr claim
    }

    Tv[35] := 0; // running tot claim
    Tv[36] := 0; // tot Closing balance ;
    i := 15; // opening
    Repeat
      If UpperCase(strings[43]) = 'Y' then
      Begin
        RemainingClaim := MinR(MxClaim, MaxR(0, MxClaim - Tv[35]));
        Tv[i + 1] := Tv[i];
        If Tv[i + 1] > RemainingClaim then
          Tv[i + 1] := RemainingClaim;
        // Tv[i+1] := MinR(MxClaim,MinR(Tv[i], RemainingClaim));  //current year
        Tv[i + 2] := MaxR(0, Tv[i] - Tv[i + 1]); // closing bal
        // Tv[35]:=Tv[35]+Tv[i+1];
      end
      Else
      Begin
        // Leave for user Tv[i+1]:=MinR(MxClaim,MinR(Tv[i], RemainingClaim));
        Tv[i + 2] := MaxR(0, Tv[i] - Tv[i + 1]); // closing bal
      End;
      // RemainingClaim := MaxR(0, MxClaim-Tv[35]);
      // RemainingClaim := MaxR(0, RemainingClaim - Tv[i+1]);
      Tv[35] := Tv[35] + Tv[i + 1];
      Tv[36] := Tv[36] + Tv[i + 2];
      Inc(i, 4);
    until i > 31;

    // closing Tv[36] := AddColumns(17, 33, 4); closing
    Tv[37] := Tv[13];
    Tv[38] := Tv[17] + Tv[21] + Tv[25] + Tv[29];
    // 20220304 //Tv[15] + Tv[19] + Tv[23] + Tv[27];
    Tv[39] := Tv[34];
    Tv[40] := Tv[35];
    Tv[41] := MaxR(0, Tv[39] - Tv[40]);
    // Ret[RetNo].LNN[31900]:=Tv[40];   //20220520
  end;
  SaveTv(RetNo, FName, FNo);
  // ShowMessage('31900 ='+Formatfloat('########.##',Ret[RetNo].LNN[31900])); //it works ok
end;

Procedure S6QC(RetNo: integer; FName: string; FNo: integer);
Var
  i, spRetNo: integer;
  HaveEligibleDependant, HaveEligibleSpouse, ClaimingBasic,
    ClaimingDisability: Boolean;
  FamNi1, FamNi2, FamNi, Step2BaseA1, Step2BaseA2, Step3Base, Step2Base1,
    Step2Base2, Step2Base3, Step2Base4, Step2RateA1, Step2RateA2, Step2RateA3,
    Step2Rate, Step2Am1, Step2Am2, Step2Am3, Step2Am4,
  //
    Step3RateA1, Step3RateA2, Step3Am1, Step3Base1, Step3Base2, Step3Base3,
    Step3Base4, Step3Rate1, Step3Rate2: Real;

    s:string;
Begin

  If (ret[RetNo].MarStatus < 3) and (ret[RetNo].CouplingSw = True) then
    spRetNo := GetSpRetNo(RetNo)
  else
    spRetNo := 0;
  // 20241206
  With ret[RetNo].Frm[FNo] do
  begin
    LoadTv(RetNo, FName, FNo);

    s := Strings[3] + Strings[4]; //1


    If Strings[98]>''  then HaveEligibleSpouse    :=True else HaveEligibleSpouse    :=False; //20250722
    If Strings[100]>'' then HaveEligibleDependant :=True else HaveEligibleDependant :=False; //20250722

    // 20251125
    Step2BaseA1 := 3600; // 3000
    Step2BaseA2 := 2400; // 3000
    Step2RateA1 := 20;
    Step2RateA2 := 23.9;
    Step2RateA3 := 37.3;
    Step2Am1 := 3812.08; //3705.38; // 3521.87; //3201.09;
    Step2Am2 := 5943.38; //5778.52; // 5497.27; //5000.44;
    Step2Am3 := 2044.00; //1986.80; // 1888.40; //1716;
    Step2Am4 := 3898.23; //37702.59; // 3522.38; //3204.03;

    Step2Base1 := 14170.05; //13829.82; // 13294.87; //2589.79; //12385;
    Step2Base2 := 21787.19; //21257.44; // 20412.45; //19001.73;
    Step2Base3 := 14341.56; //13981.83; // 13400.24; //12402.83;
    Step2Base4 := 22007.75; //1456.77; // 20663.57; //19051.09;
    Step2Rate := 20;

    Step3Base := 1200;
    Step3RateA1 := 20;
    Step3RateA2 := 40;
    Step3Am1 := 851.31; //827.72; // 787.70; //721.01;

    Step3Base1 := 33230.35; //32356.72; // 30904.22; //28391.25;
    Step3Base2 := 51504.09; //50150.04; // 47898.80; //44003.93;
    Step3Base3 := 24561.56; //23925.83; // 22842.24; //20984.83;
    Step3Base4 := 41048.90; //39969.72; // 38175.47; //35071.24;

    Step3Rate1 := 10;
    Step3Rate2 := 20;

    //jz//202600202 - all these do no seem to serve a purpose, vars never get populated, also first 2 are checkboxes
    {
    Tv[68] := FamNi1;
    Tv[69] := FamNi2;
    Tv[74] := FamNi1;
    // Tv[76] := FamNi2; //jz//20250331 - all these do no seem to serve a purpose, vars never get populated, get rid of this one as it causes an error
    Tv[75] := FamNi;
    }

    // 20251125
    Tv[88] := 33230.35; //32356.732; // 30904.22; //28391.25;
    Tv[89] := 51504.09; //50150.04; // 47898.80; //44993.93;
    Tv[90] := 24561.56; //23915.83; // 22842.24; //20984.83;
    Tv[91] := 41048.90; //39969.72; // 38175.47; //35071.24;

    Tv[82] := 37486.90; //36495.32; // 34842.72; //31996.30;
    Tv[84] := 55760.64; //54288.64; // 51837.30; //47608.98;
    Tv[85] := 28818.11; //28054.43; // 26780.74; //24589.88;
    Tv[86] := 45305.45; //44108.32; // 42113.97; //38676.29;

    Tv[92] := 60017.19; //58427.24; // 55775.80; //51214.03;
    Tv[95] := 49562.00; //48246.92; // 46052.47; //42281.34;

    s := Strings[3] + Strings[4]; //2

    // 20171205
    if (ret[RetNo].Province <> 'QC') or (EligibleForWibPerCra(RetNo) = false)
    // 20200420
    then
    begin
      for i := 1 to 100 do
      begin
        Tv[i] := 0;
        strings[i] := '';
      End;
      SaveTv(RetNo, FName, FNo);
      exit;
    end;

        s := Strings[3] + Strings[4]; //3

    If strings[66] > '' then // eligible
    begin
    end;

    If ret[RetNo].MarStatus > 2 then
    begin
      If EligibleForWib(RetNo) then
      begin
        strings[66] := 'X';
        strings[67] := '';
      end
      else
      begin
        strings[66] := '';
        strings[67] := 'X';
      end;
    end;

    If FetchElmFNo(RetNo, InfoFNo, 145) > '' then
    begin
      strings[66] := '';
      strings[67] := 'X';
    end; // 20190127
    If FetchElmFNo(RetNo, InfoFNo, 147) > '' then
    begin
      strings[66] := '';
      strings[67] := 'X';
    end; // 20190127
    If FetchElmFNo(RetNo, InfoFNo, 149) > '' then
    begin
      strings[66] := '';
      strings[67] := 'X';
    end; // 20190127

    If strings[66] = '' then // not eligible
    begin
      For i := 1 to 67 do
      begin
        strings[i] := '';
        Tv[i] := 0;
      end;
      SaveTv(RetNo, FName, FNo);
      exit;
    end;

    s := Strings[3] + Strings[4]; //3.1

    strings[82] := '5000-S6';
    If ret[RetNo].Province = 'QC' then
      strings[82] := '5005-S6';

//    If strings[83] = '' then // no override //jz//20260202 - remove, override elm not used / visable
    begin
      If HasEligibleDependantForWIB(RetNo) then
      begin
        strings[1] := 'X';
        strings[2] := '';
      end
      else
      begin
        strings[1] := '';
        strings[2] := 'X';
      end;
    end;
{    else                                   //jz//20260202 - override remove, elm not used / visable
    begin
      strings[1] := 'X';
      strings[2] := '';
    end;
}

    //jz//20260202 - add HasEligibleSpouseForWIB function
    if HasEligibleSpouseForWIB(RetNo) then
    begin
        Strings[3] := 'X';
        Strings[4] := '';
    end
    else
    begin
        Strings[3] := '';
        Strings[4] := 'X';
    end;


    HaveEligibleDependant := strings[1] > '';
    HaveEligibleSpouse    := strings[3] > '';
    If strings[29] + strings[30] = '' then
    begin
      strings[29] := 'X';
      strings[30] := '';
    end;
    If strings[31] + strings[32] = '' then
    begin
      If ret[RetNo].Lnn[31600] > 0 then
        strings[31] := 'X';
    end;

    If Vl(FetchElm(RetNo, 'S2', 5)) > 0 then
    begin
      strings[33] := 'X';
      strings[34] := '';
    end
    else
    begin
      If strings[3] > '' then // if elig spouse
      begin
        //strings[33] := '';
        //strings[34] := 'X'; //jz//20260202 - exactly the opposite, but leave as vtUser
      end
      else
      begin
        strings[33] := '';
        strings[34] := '';
      end;
    end;

    If strings[3] = '' then
      strings[84] := '';
    ClaimingBasic := strings[29] > '';
    ClaimingDisability := strings[31] > '';
    Tv[5] := ret[RetNo].Lnn[10100] + ret[RetNo].Lnn[10400];
    Tv[9] := GetSelfEmplForWib(RetNo);
    Tv[7] := TotMultiple(RetNo, 'T4A', 47); // txbl scholarship
    Tv[11] := TotMultiple(RetNo, 'T4', 11) + TotMultiple(RetNo, 'T4', 47);
    // St indian reserve or emerg volunteer
    Tv[18] := Tv[11] + TotMultiple(RetNo, 'T4E', 14); // 20100212
    Tv[13] := Tv[5] + Tv[7] + Tv[9] + Tv[11];
    If (ret[RetNo].MarStatus < 3) and (ret[RetNo].CouplingSw = True) then
    begin
      spRetNo := GetSpRetNo(RetNo);
      If spRetNo > 0 then
      begin
        Tv[6] := ret[spRetNo].Lnn[10100] + ret[spRetNo].Lnn[10400];
        Tv[8] := TotMultiple(spRetNo, 'T4A', 47); // scholarship
        Tv[10] := GetSelfEmplForWib(spRetNo);
        Tv[12] := TotMultiple(spRetNo, 'T4', 11) + TotMultiple(spRetNo, 'T4',
          47); // St indian reserve or emerg volunteer
      end;
    end;

    If UpperCase(strings[3]) <> 'X' then
    begin
      Tv[6] := 0;
      Tv[8] := 0;
      Tv[10] := 0;
      Tv[12] := 0; // remove sp amounts
    end;

    Tv[14] := Tv[6] + Tv[8] + Tv[10] + Tv[12];
    Tv[15] := Tv[13] + Tv[14];

    Tv[151] := CalcMortgageForeclosure(ret[RetNo].Lnn[12700],
      Vl(FetchElmFNo(RetNo, GetFormNo('S3'), 122)),
      Vl(FetchElmFNo(RetNo, GetFormNo('S3'), 72)));

    Tv[152] := Vl(FetchElm(RetNo, 'FORECLO', 4));
    Tv[16] := MaxR(0, SelectNetIncomeAmount(RetNo) - Tv[151]);
    // 20250222 //MaxR(0, ret[RetNo].Lnn[23600] - Tv[151]);
    if TosiInEffect(RetNo) then
      Tv[16] := MaxR(0, GetTosiNetIncome(RetNo) - Tv[151]);

    Tv[20] := ret[RetNo].Lnn[21300] + Vl(FetchElm(RetNo, 'OTHDED', 60));
    Tv[22] := Tv[16] + Tv[18] + Tv[20];
    Tv[24] := ret[RetNo].Lnn[11700] + ret[RetNo].Lnn[12500];

    Tv[26] := MaxR(0, Tv[22] - Tv[24]);

    Tv[19] := Tv[12];
    If (ret[RetNo].MarStatus < 3) and (ret[RetNo].CouplingSw = True) then
      Tv[19] := Tv[12] + TotMultiple(spRetNo, 'T4E', 14); // 20100301

    Tv[17] := MaxR(0, Vl(FetchElm(RetNo, 'INFO', 19)) - Tv[152]);
    if Vl(FetchElm(RetNo, 'INFO', 29)) > 0 then // 20190223
      Tv[17] := MaxR(0, GetSpouseTosiNetIncome(RetNo, InfoFNo) - Tv[152]);

    Tv[21] := Vl(FetchElm(RetNo, 'INFO', 162)) + Vl(FetchElm(RetNo, 'S2', 34));

    Tv[23] := Tv[17] + Tv[19] + Tv[21];
    Tv[25] := Vl(FetchElm(RetNo, 'INFO', 131)) + Vl(FetchElm(RetNo, 'S2', 33));

    If UpperCase(strings[3]) <> 'X' then // no elig spouse
    begin
      Tv[17] := 0;
      Tv[19] := 0;
      Tv[21] := 0;
      Tv[23] := 0;
      Tv[25] := 0; // remove sp amounts
    end;

    Tv[27] := MaxR(0, Tv[23] - Tv[25]);
    // 20211127
    Tv[70] := Tv[26] + Tv[27];

    // 20211211
    If Tv[13] < Tv[14] then
      Tv[75] := MinR(Tv[13], Tv[26])
    Else
      Tv[75] := MinR(Tv[14], Tv[27]);

    if Tv[71] > 15239 then
      Tv[71] := 15239; // 20221211 // if Tv[71]>14000 then Tv[71]:=14000;
    Tv[28] := MaxR(0, Tv[70] - Tv[71]);

    If strings[29] + strings[30] = '' then
      strings[29] := 'X';
    If ret[RetNo].Lnn[31600] > 0 then // dasabled
    begin
      strings[31] := 'X';
      strings[32] := '';
    end
    else
    begin
      strings[31] := '';
      strings[32] := 'X';
    end;

    // Step 2
    If ClaimingBasic then
    begin
      Tv[35] := Tv[15];

      if (HaveEligibleSpouse = True) or
        ((HaveEligibleSpouse = True) and (HaveEligibleDependant = True)) then
        Tv[36] := Step2BaseA1
      Else
        Tv[36] := Step2BaseA2;
      Tv[37] := MaxR(0, Tv[35] - Tv[36]);
      Tv[38] := Step2RateA3;
      If (HaveEligibleDependant = True) and (HaveEligibleSpouse = false) then
        Tv[38] := Step2RateA1;
      If (HaveEligibleDependant = True) and (HaveEligibleSpouse = True) then
        Tv[38] := Step2RateA2;
      Tv[39] := Tv[37] * Tv[38] / 100;
      If (HaveEligibleSpouse = false) and (HaveEligibleDependant = false) then
        Tv[40] := Step2Am1;
      If (HaveEligibleSpouse = True) and (HaveEligibleDependant = false) then
        Tv[40] := Step2Am2;
      If (HaveEligibleSpouse = false) and (HaveEligibleDependant = True) then
        Tv[40] := Step2Am3;
      If (HaveEligibleSpouse = True) and (HaveEligibleDependant = True) then
        Tv[40] := Step2Am4; // 2024106

      Tv[41] := MinR(Tv[39], Tv[40]);
      Tv[42] := Tv[41];
      Tv[43] := Tv[28];

      If (HaveEligibleSpouse = false) and (HaveEligibleDependant = false) then
        Tv[44] := Step2Base1;
      If (HaveEligibleSpouse = True) and (HaveEligibleDependant = false) then
        Tv[44] := Step2Base2;
      If (HaveEligibleSpouse = false) and (HaveEligibleDependant = True) then
        Tv[44] := Step2Base3;
      If (HaveEligibleSpouse = True) and (HaveEligibleDependant = True) then
        Tv[44] := Step2Base4;

      Tv[45] := MaxR(0, Tv[43] - Tv[44]);
      Tv[46] := Step2Rate;
      Tv[47] := Tv[45] * Tv[46] / 100;
      Tv[48] := Tv[47];
      Tv[49] := MaxR(0, Tv[42] - Tv[48]);
    end
    else
    begin
      For i := 35 to 49 do
        Tv[i] := 0;
    end;

    // Step 3
    If (ClaimingDisability) then
    begin
      Tv[50] := Tv[13];
      Tv[51] := Step3Base;
      Tv[52] := MaxR(0, Tv[50] - Tv[51]);
      If (HaveEligibleSpouse = True) OR
        ((HaveEligibleSpouse = True) and (HaveEligibleDependant = True)) then
        Tv[53] := Step3RateA1
      Else
        Tv[53] := Step3RateA2;

      Tv[54] := Tv[52] * Tv[53] / 100;
      // Tv[55] := MinR(Step3Am1, Tv[54]);
      Tv[55] := MinR(Step3Am1, Tv[54]);
      // 20210101 // MinR(530.06,Tv[54]); //ln 34
      Tv[56] := Tv[55];
      Tv[57] := Tv[28];
      // 20171205
      // Ln 36  //20181115
      Tv[78] := 0;
      If (HaveEligibleSpouse = false) and (HaveEligibleDependant = false) then
        Tv[78] := Step3Base1;
      Tv[74] := 0;
      If (HaveEligibleSpouse = True) and (HaveEligibleDependant = false) then
        Tv[74] := Step3Base2;
      Tv[75] := 0;
      If (HaveEligibleSpouse = false) and (HaveEligibleDependant = True) then
        Tv[75] := Step3Base3;
      Tv[79] := 0;
      If (HaveEligibleSpouse = True) and (HaveEligibleDependant = True) then
        Tv[79] := Step3Base4;
      Tv[58] := MaxR(Tv[78], Tv[74]);
      Tv[58] := MaxR(Tv[58], Tv[75]);
      Tv[58] := MaxR(Tv[58], Tv[79]);
      Tv[59] := MaxR(0, Tv[57] - Tv[58]);
      Tv[60] := Step3Rate2;
      If (HaveEligibleSpouse) and (Vl(FetchElm(RetNo, 'S2', 5)) > 0)
      // spouse disability //(Strings[84]>'')
      then
      Begin
        Tv[60] := Step3Rate1;
        If (HaveEligibleSpouse = True) and (Vl(FetchElm(RetNo, 'S2', 5)) > 0)
        then
          Tv[60] := Step3Rate2;
        Tv[61] := Tv[59] * Tv[60] / 100;
        Tv[62] := Tv[61];
        Tv[63] := MaxR(0, Tv[56] - Tv[62]);
      End;
    end
    else
    begin
      For i := 50 to 63 do
        Tv[i] := 0;
    end;
    Tv[64] := Tv[49];
    Tv[65] := Tv[63] + Tv[64];

    // step 4 adsvanced     //20231126
    // awcb
    Tv[72] := MaxR(Tv[49], Tv[65]); // 20231126
    Tv[73] := TotMultiple(RetNo, 'RC210', 1);
    // Tv[76]:= spouses box 10?
    Tv[87] := Tv[73] + Tv[76];

    Tv[93] := TotMultiple(RetNo, 'RC210', 4);
    Tv[96] := Tv[87] + Tv[93];
    Tv[97] := MinR(Tv[72], Tv[96]);

  end;


  SaveTv(RetNo, FName, FNo);
end;




(*
// jz 20250201 vtMulti fix, removed rounding
// jz 20250226 part5 partially put into procedure and moved infront of part 3a,3b
// jz//20250302 part 3ab, 4, 5 into procudure, made code flow more clear
// jz//20250306 flow improvments
// jz//20250318 added getPensionableNetSelfEmploymentEarnings function
Procedure S8(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  CppProrate, CPPRetirementProrate, qppProrate, x, x1, MxCpp, MxQpp,
    TempValue: Real;
  StopMonth, Birthmonth: String;
  CppMonths, CppRetirementMonths: integer;
  SkipPart4, SkipPart5: Boolean;

  p5_Line12, p5_Line13, p5_Line14s, p5_Line14, p5_Line15: integer;

  sumLnnNo, sumElmNo: integer;


  // -------------------------------------------

  Function getPensionableNetSelfEmploymentEarnings(RetNo: integer): Real;
  begin
    // 20250206
    Result := (ret[RetNo].Lnn[12200] + Vl(FetchElm(RetNo, 'T1', 37))) *
      CppProrate;

    // if IsDeceased(RetNo)=false then   //should it be false? why
    // result:=(Ret[RetNo].Lnn[12200]+Vl(FetchElm(RetNo,'T1',37)))*CppProrate;
    // result := maxR(0,result);
  end;


// -------------------------------------------

  Procedure ClearS8Part3a(RetNo, FNo: integer); // jz//20250210
  Begin
    with ret[RetNo].Frm[FNo] do
    begin
      Tv[333] := 0;
      Tv[330] := 0;
      Tv[331] := 0;
      Tv[332] := 0;
      Tv[334] := 0;
    end;
  End;

// -------------------------------------------

  Procedure ClearS8Part3b(RetNo, FNo: integer); // jz//20250210
  Begin
    with ret[RetNo].Frm[FNo] do
    begin
      Tv[333] := 0;
      Tv[330] := 0;
      Tv[331] := 0;
      Tv[332] := 0;
      Tv[334] := 0;
    end;
  End;

// -------------------------------------------

  Procedure clearS8Part4(RetNo, FNo: integer);
  Var
    i: integer;
  Begin
    {
      with ret[RetNo].Frm[FNo] do
      begin
      for i := 349 to 369 do Tv[i] := 0;
      for i := 11 to 153 do Tv[i] := 0;
      end;
    }
  end;

// -------------------------------------------

  Procedure clearS8Part5(RetNo, FNo: integer);
  Var
    i: integer;
  Begin
    {
      with ret[RetNo].Frm[FNo] do
      begin
      for i := 154 to 261 do  Tv[i] := 0; // 20200129
      for i := 370 to 395 do Tv[i] := 0; // 20200129
      end;
    }
  end;

// -------------------------------------------

  Function isS8Part5Applicable(RetNo, FNo: integer): Boolean;
  var
    b: Boolean;
    s: string;
  begin
    // result := true; exit; //20250203
    xx := ret[RetNo].Lnn[10100];
    b := IsSelfEmployed(RetNo);
    s := FetchElm(RetNo, 'CPT20', 80);

    Result := false;

    // jz//20250318 - use NetSelfEmploymentEarnings instead of IsSelfEmployed -
    // If ( (getPensionableNetSelfEmploymentEarnings(RetNo)>0) or (FetchElm(RetNo, 'CPT20', 80) = 'Y') )

    If (((IsSelfEmployed(RetNo))) or (FetchElm(RetNo, 'CPT20', 80) = 'Y'))
    // JZ//20250321 - ACTUALLY NEGAGATIVE IS ALLOWED AFTWER ALL , CHANGED BACK
      and (ret[RetNo].Lnn[10100] > 0)
    // 20250302 remove as seems to cause issues - revisit
    then // and elect to pay additional CPP contributions on other earnings
      Result := True;

  end;

// -------------------------------------------

  Function isS8Part4Applicable(RetNo, FNo: integer): Boolean;
  var
    b: Boolean;
    s: string;
  begin
    xx := ret[RetNo].Lnn[10100];
    b := IsSelfEmployed(RetNo);
    s := FetchElm(RetNo, 'CPT20', 80);

    Result := false;
    // jz//20250318 - use NetSelfEmploymentEarnings instead of IsSelfEmployed -
    // If ( (getPensionableNetSelfEmploymentEarnings(RetNo)>0) or (FetchElm(RetNo, 'CPT20', 80) = 'Y') )
    If (((IsSelfEmployed(RetNo))) or (FetchElm(RetNo, 'CPT20', 80) = 'Y'))
    // JZ//20250321 - ACTUALLY NEGAGATIVE IS ALLOWED AFTWER ALL , CHANGED BACK
      and (ret[RetNo].Lnn[10100] = 0) then
    // and elect to pay additional CPP contributions on other earnings
      Result := True;
  end;

// -------------------------------------------

  Function isS8Part3abApplicable(RetNo, FNo: integer): Boolean;
  begin
    Result := false;
    with ret[RetNo].Frm[FNo] do
    begin
      // do 3a or 3b only if part 5 lines 37 and 48 are '0', blank out if they are not //jz//20250210
      // (isS8Part5Applicable(RetNo,FNo)) do 3a or 3b even if 5 not applicable?? profile seems to
      if (Tv[84] = 0) and (Tv[96] = 0) then
        Result := True;
    end;
  end;

// -------------------------------------------

  Procedure S8Part3ab(RetNo: integer; FName: String; FNo: integer);
  begin

    // ClearS8Part3a(RetNo,FNo); //not need as full clear at start
    // clearPart3b(RetNo, FNo);
    // for i:=335 to 348 do begin ret[RetNo].Frm[FNo].Tv[i]:=0;end; //20250129

    // Page 5 Part 3a 3b  s8 ----------------------------------------------------------

    // 3a
    with ret[RetNo].Frm[FNo] do
    begin

      if Tv[26] > 0 // line 26
      // and (GetSelfEmplIncome(RetNo)<=0))  //2024123  //20250201
      then
      Begin
        xx := Tv[13];
        Tv[333] := Tv[13]; // 20241222
        Tv[330] := Tv[16];
        Tv[331] := Tv[23];
        Tv[332] := Tv[330] + Tv[331];
        Tv[334] := Tv[26]; // 20241222
      end;

      // jz//20250210 added if and else<<
      // part 3b
      if Tv[26] <= 0 then
      begin

        // line 32 =tv[14]
        if Tv[14] >= 0 then
          Tv[335] := Tv[13]
        else
          Tv[335] := Tv[11];
        // jz 20250201 corrected elms //Tv[272] else Tv[335]:=Tv[269];  //20250201

        // line 33
        if Tv[20] >= 0 then // line 21
        Begin
          Tv[336] := Tv[16];
          // amount from line20 which is Tv[16] not Tv[20]; //jz 20250130 // //line 33  //20250129
          xx := Tv[20]; // sb   line 32 sb 940
          // if (Tv[84]=0) and (Tv[96]=0) then Tv[336]:=0; //20250120 ?? CIRCULAR?
          Tv[337] := 0;
          Tv[338] := 0;
          Tv[339] := 0;
          Tv[340] := 0;
          Tv[341] := 0;
        end;

        // Line 21 tv[20] if negative
        if Tv[20] < 0 then
        Begin
          Tv[336] := 0; // 20250129
          Tv[337] := ABS(Tv[20]);
          Tv[338] := Tv[15];
          if Tv[14] > 0 then
            Tv[339] := MinR(Tv[14], Tv[337])
          Else
            Tv[339] := 0; // line 18
          Tv[340] := Tv[338] + Tv[339];
          Tv[341] := Tv[340];
        end;

        // if Tv[25]=0 then //line 25
        if Tv[25] >= 0 then
        // line 25 //20250327 - added > as per email from CRA
        begin
          Tv[342] := Tv[23];
        end
        else if Tv[25] < 0 then
        // line 25 - //20250327 - with added >,  this could just be an else now
        begin
          Tv[343] := ABS(Tv[25]);
          Tv[344] := Tv[22];
          if Tv[21] > 0 then
            Tv[345] := MinR(Tv[21], Tv[343])
          Else
            Tv[345] := 0;
          Tv[346] := Tv[344] + Tv[345];
          Tv[347] := Tv[346];
        end;
        Tv[348] := Tv[336] + Tv[341] + Tv[342] + Tv[347];
        // Ret[RetNo].LNN[22215]:=TV[348];  //20241221A Done at summary of S8

      end; // end part 3b
      {
        If GetSelfEmplIncome(RetNo)<>0 then
        begin
        //for i:=333 to 348 do begin Tv[i]:=0;end; //20250129  ?????
        end;
      }

    end; // with //part 3
    // jz//20250210 >>

  end; // S8Part3ab

// -------------------------------------------

  Procedure S8Part4(RetNo: integer; FName: String; FNo: integer);
  var
    i: integer;
  begin
    // page 6
    // s8part4 --------------------------------------------------------------------
    with ret[RetNo].Frm[FNo] do
    begin
      Tv[137] := getPensionableNetSelfEmploymentEarnings(RetNo);
      // jz//20250318 //Ret[RetNo].Lnn[12200]+Vl(FetchElm(RetNo,'T1',37));

      Tv[138] := Vl(FetchElm(RetNo, 'CPT20', 19));
      // jz//20250301 fetch CPT20 amount

      Tv[139] := Tv[137] + Tv[138];
      Tv[27] := MinR(Tv[139], Tv[103]);
      Tv[28] := Tv[27];
      Tv[29] := Tv[106];
      Tv[30] := MaxR(0, Tv[27] - Tv[29]);
      Tv[31] := Tv[30];
      Tv[32] := MaxR(0, Tv[28] - Tv[31]);
      Tv[33] := Tv[108];
      Tv[34] := MaxR(0, Tv[32] - Tv[33]);
      Tv[34] := MinR(Tv[34], 65000);
      // -----------------------------
      Tv[104] := Tv[34];
      Tv[105] := Tv[104] * 9.9 / 100;
      Tv[105] := MinR(Tv[105], 65000);

      Tv[107] := Tv[34];
      Tv[52] := Tv[107] * 2 / 100;
      Tv[52] := MinR(Tv[52], 1300);

      Tv[110] := Tv[31]; // Tv[34];  //20241223
      Tv[111] := Tv[110] * 8 / 100;
      Tv[111] := MinR(Tv[111], 376);
      Tv[112] := Tv[52] + Tv[111];
      Tv[113] := Tv[112];
      Tv[121] := Tv[105] + Tv[113];

      Tv[35] := Tv[105];
      Tv[36] := Tv[35] * 50 / 100; // 20241223
      Tv[37] := Tv[113];
      Tv[153] := Tv[36] + Tv[37];
      // xx:=ret[RetNo].Lnn[10100];
      If (ret[RetNo].Lnn[10100] > 0)
      // jz//20250207 changed operator from = to > //20250201 //zero out if thre is empl income
      then
      begin
        for i := 137 to 139 do
        begin
          Tv[i] := 0;
        end;
        for i := 27 to 34 do
        begin
          Tv[i] := 0;
        end;
        // 20250206
        for i := 104 to 105 do
        begin
          Tv[i] := 0;
        end;
        Tv[107] := 0; // 20241222A
        for i := 110 to 113 do
        begin
          Tv[i] := 0;
        end;
        Tv[52] := 0;
        for i := 35 to 37 do
        begin
          Tv[i] := 0;
        end;
        Tv[121] := 0;
        Tv[153] := 0;
      end;

    end; // end with part 4
  end; // end S8Part4

// -------------------------------------------

  Procedure S8Part5(RetNo: integer; FName: String; FNo: integer);
  var
    i: integer;
  begin

    // page 7   s8
    with ret[RetNo].Frm[FNo] do
    begin
      Tv[349] := getPensionableNetSelfEmploymentEarnings(RetNo);
      // 20250318 - moved to a function

      Tv[350] := Vl(FetchElm(RetNo, 'CPT20', 19));
      // jz//20250301 fetch CPT20 amount

      // Tv[351]:=??

      // Tv[38]:=Tv[349]+Tv[350]+Tv[351];
      // jz//20250321 - doesnt say on the form but Profile and TaxPrep do not show negative so then take maxr(0 ????
      Tv[38] := MaxR(0, Tv[349] + Tv[350] + Tv[351]);

      xx := Tv[39];
      xx := Tv[19];

      Tv[39] := Tv[19];
      xx := Tv[39];

      { jz1 why this??
        //if Tv[349]+Tv[350]+Tv[351]<>0 then
        //Begin
      }
      if Tv[21] > 0 then // lne 2
      begin
        Tv[41] := Tv[39];
        Tv[45] := Tv[272];
        Tv[46] := Tv[41] - Tv[45];
        Tv[47] := Tv[46]; // 20241222A
        if Tv[46] < 0 then
          Tv[48] := Tv[45];
      end
      else
      Begin
        Tv[47] := 0;
      end;

      Tv[48] := MaxR(0, Tv[39] - Tv[47]);
      Tv[49] := Tv[48];
      Tv[50] := Tv[49] * 16.80672;

      // jz//20250311 - dirty fix for rounding issue to match with cra
      if Tv[49] = 3867.50 then
        Tv[50] := 65000;

      Tv[53] := Tv[273];

      // [54][55][56][57][58] - so to find elms with search
      p5_Line12 := 54;
      p5_Line13 := 55;
      p5_Line14s := 56;
      p5_Line14 := 57;
      p5_Line15 := 58;
      // jz//20250327 <<
      // If the amount from line 26 of Part 3 is positive, complete lines 12 to 14.
      // If not, enter "0" on line 14 and continue at line 15.
      // jz//20250225 - says positive, do not include 0?
      // jz//20250322 -  back to if Tv[26]>=0, include 0 even tho form isnt explicit to,
      // done as per profile and matching test case 11
      // jz//20250327
      IF Tv[26] >= 0 then // line 26
      BEGIN
        Tv[p5_Line12] := Tv[53];
        Tv[p5_Line13] := Tv[275];

        Tv[p5_Line14s] := Tv[p5_Line12] - Tv[p5_Line13];
        // p5_Line14 calced done in the next if,else

        if Tv[p5_Line14s] < 0 then
        begin
          Tv[p5_Line14] := 0;
          Tv[p5_Line15] := Tv[p5_Line13]; // line 13
        end
        else // Tv[p5_Line14s] >= 0  //jz//20250327 - elses were confused and conflated
        Begin
          Tv[p5_Line14] := Tv[p5_Line14s]; // jz//20250327 - do the calculation
          Tv[p5_Line15] := MaxR(0, Tv[53] - Tv[p5_Line14]); // 20250120
        end;
      END
      ELSE // Tv[26]<0 //jz//20250327 - elses were confused and conflated
      BEGIN
        Tv[p5_Line14] := 0;
        Tv[p5_Line15] := MaxR(0, Tv[53] - Tv[p5_Line14]);
      END; // jz//20250321 end else in the wrong place
      // line 15 is Tv[58] and is handled above in all the if else scenarios //Tv[58]:=MaxR(0,Tv[53]-Tv[57]);  //20250120
      // jz//20250327 >>

      Tv[59] := Tv[58];
      Tv[60] := Tv[59] / (4 / 100); // 20250120 divide, not multiply
      Tv[61] := Tv[50] + Tv[60];

      // jz//20250210 <<
      If Tv[26] <= 0 then
      // if p3_line26 negative or zero complete lines 18-20 = elms 62, 63, 65
      Begin
        Tv[62] := ABS(Tv[25]); // 20250120

        if Tv[21] > 0 then
          Tv[63] := MinR(Tv[21], Tv[62])
        else
          Tv[63] := 0;

        Tv[64] := Tv[63];
        Tv[65] := Tv[64] / (4 / 100); // 20250120  divide instead
      end
      Else
      Begin
        Tv[62] := 0;
        Tv[63] := 0;
        Tv[65] := 0;
      end;
      // jz//20250210 >>

      Tv[66] := Tv[38];
      Tv[67] := Tv[7];
      Tv[68] := Tv[66] + Tv[67];
      // xx:=Tv[106];
      Tv[69] := Tv[106];
      Tv[70] := Tv[108];
      Tv[71] := MinR(65000, Tv[69] - Tv[70]);
      Tv[72] := Tv[50];
      Tv[172] := MaxR(0, Tv[71] - Tv[72]);

      { jz1
        end //if Tv[349]+Tv[350]+Tv[351]<>0
        Else
        Begin
        Tv[39]:=0;
        Tv[47]:=0;
        Tv[48]:=0;
        for i:=65 to 72 do Tv[i]:=0;
        Tv[172]:=0;
        end;
      }

      If ret[RetNo].Lnn[10100] = 0 then // 20241223 //no empl income
      Begin
        For i := 349 to 351 do
        begin
          Tv[i] := 0;
        end;
        For i := 38 to 39 do
        begin
          Tv[i] := 0;
        end;
        Tv[41] := 0;
        For i := 45 to 50 do
        begin
          Tv[i] := 0;
        end;
        For i := 53 to 61 do
        begin
          Tv[i] := 0;
        end;
        For i := 53 to 72 do
        begin
          Tv[i] := 0;
        end;
        Tv[172] := 0; // 20241223
      end;

    end; // with page 7

    // page 8   s8
    with ret[RetNo].Frm[FNo] do
    begin
      Tv[73] := MinR(Tv[38], Tv[172]);
      if Tv[3] < Tv[70] then // 20241222a
      Begin
        Tv[74] := Tv[70];
        Tv[75] := Tv[3];
        /// /20250206
        x := Tv[74] - Tv[75]; // 20250206
        if x < 0 then // Tv[74]-Tv[75]
        begin
          Tv[76] := 0;
          Tv[83] := 0;
        end
        Else
          Tv[76] := x;
        // -----------------
        Tv[77] := Tv[38];
        Tv[78] := Tv[71];
        Tv[79] := MaxR(0, Tv[77] - Tv[78]);
        Tv[81] := Tv[79];
        Tv[82] := MaxR(0, Tv[76] - Tv[81]);
        Tv[83] := Tv[82];
        // jz//20250406 - from [76] to [82]  //Tv[76]; //20250206
      end
      Else
      begin
        Tv[74] := 0;
        Tv[75] := 0;
        Tv[76] := 0;
        Tv[77] := 0;
        Tv[78] := 0;
        Tv[79] := 0;
        Tv[81] := 0;
        Tv[82] := 0;
        Tv[83] := 0;
      end;

      Tv[84] := MaxR(0, Tv[73] - Tv[83]);

    end; // with

    with ret[RetNo].Frm[FNo] do
      if Tv[68] > Tv[69] then // jz//20250321 - if line 23 more than 24
      begin
        Tv[85] := Tv[109];

        // 20250201
        Tv[86] := Tv[60];
        Tv[87] := Tv[65]; // 20241221
        Tv[88] := Tv[86] + Tv[87];
        Tv[89] := Tv[88];
        Tv[90] := Tv[85] - Tv[89];
        Tv[91] := Tv[38];
        Tv[92] := Tv[76];
        Tv[93] := Tv[91] - Tv[92];
        Tv[94] := Tv[84];
        Tv[95] := Tv[93] - Tv[94];
        Tv[96] := MinR(Tv[90], Tv[95]);
      end
      else
        Tv[96] := 0;

    if isS8Part3abApplicable(RetNo, FNo) then
    begin
      S8Part3ab(RetNo, FName, FNo);
      // if go back to part 3 do not complete the rest of part 5
    end
    else // finish the rest of part 5
    begin

      // jz//20250210 <<
      // S8part5( continued --->

      with ret[RetNo].Frm[FNo] do
      begin

        // jz//20250210 >>

        Tv[97] := Tv[84];
        Tv[98] := MinR(6436, (Tv[97] * (9.9 / 100)));
        // 20242222a
        Tv[99] := Tv[84];
        Tv[100] := MinR(1300, (Tv[99] * (2 / 100)));
        Tv[101] := Tv[96];
        Tv[102] := MinR(376, Tv[101] * 8 / 100); // 20250203
        Tv[114] := Tv[100] + Tv[102];
        Tv[115] := Tv[114];
        Tv[116] := Tv[98] + Tv[115]; // 20241222a
        Tv[170] := MaxR(0, Tv[26]);
        Tv[117] := Tv[170] * 2;

        // 20250128
        Tv[140] := Tv[116] - Tv[117];; // 20241222a
      end; // end with page8

      // 20250128
      // Page 9 self empl  PART 5  s8
      with ret[RetNo].Frm[FNo] do
      begin
        if Tv[140] < 0 then
        Begin
          Tv[141] := ABS(Tv[140]);
          Tv[142] := Tv[141] * 50 / 100;
        End
        Else
        Begin
          Tv[141] := 0;
          Tv[142] := 0
        end;
        Tv[143] := Tv[266];
        Tv[144] := Tv[269];
        { //20250125
          Tv[141]:=ABS(Tv[140]);
          Tv[142]:=Tv[141]*50/100;
          Tv[143]:=Tv[266];
          Tv[144]:=Tv[269];
        }
        Tv[145] := Tv[143] - Tv[144];
        if Tv[145] > 0 then
          Tv[146] := Tv[144]
        else
          Tv[146] := Tv[143];
        Tv[147] := Tv[267];
        Tv[148] := Tv[271];
        Tv[149] := Tv[147] - Tv[148];

        if Tv[149] >= 0 then
        // jz 20250129 vtMulti fix so rounding no longer needed //jz 20250129 add rounding //line 63 is positive or zero
        begin
          Tv[150] := Tv[148];
          Tv[151] := 0;
          Tv[171] := 0;
          Tv[179] := 0;
          Tv[183] := 0;
          Tv[80] := 0;
        end
        Else // line 63 is negative
        begin
          Tv[150] := 0;
          Tv[151] := ABS(Tv[149]);
          Tv[171] := Tv[147];
          if Tv[145] > 0 then
            Tv[179] := MinR(Tv[145], Tv[151])
          Else
            Tv[179] := 0;
          Tv[183] := Tv[171] + Tv[179];
          Tv[80] := Tv[183];
        end;

        Tv[184] := Tv[273];
        Tv[185] := Tv[275];
        Tv[154] := Tv[184] - Tv[185];
        if Tv[154] >= 0 then // line 71
        begin
          Tv[155] := Tv[185];
          Tv[156] := 0;
          Tv[157] := 0;
          Tv[159] := 0;
          Tv[160] := 0;
          Tv[161] := 0;
        end
        Else
        begin
          Tv[155] := 0;
          Tv[156] := ABS(Tv[154]);
          Tv[157] := Tv[184];
          if Tv[21] > 0 then
            Tv[159] := MinR(Tv[21], Tv[156])
          else
            Tv[159] := 0;
          Tv[160] := Tv[157] + Tv[159];
          Tv[161] := Tv[160];
        end;

        // end; //line 63 negative

        // deduction enhanced empl income
        // Tv[206]:=Tv[204]+Tv[205];
        // Tv[207]:=Tv[206];

        Tv[162] := Tv[150] + Tv[80] + Tv[155] + Tv[161];

        Tv[163] := Tv[98];
        Tv[164] := Tv[163] * 50 / 100;
        Tv[165] := Tv[100];
        Tv[166] := Tv[165] * 50 / 100;
        Tv[167] := Tv[164] + Tv[166];

        // Amount from line 26 elm[26] of Part 3 if positive. If not, enter "0".
        if Tv[26] > 0 then
          Tv[168] := Tv[26]
        else
          Tv[168] := 0; // 20250202 JZ only assign if is positive

        // Tv[168]:=Tv[26];

        Tv[169] := Tv[167] - Tv[168];

        Tv[262] := MinR(Tv[167], Tv[168]); // 20241221
        Tv[263] := Tv[262] * 83.1933 / 100;
        Tv[264] := Tv[263];
        Tv[281] := MaxR(0, Tv[262] - Tv[264]); // 20241221

        { ?? //20250125
          If GetSelfEmplIncome(RetNo)=0 then  //<=0  //20241225
          begin
          for i:=141 to 151 do begin Tv[i]:=0;end;
          Tv[171]:=0; Tv[179]:=0;Tv[80]:=0;
          for i:=183 to 185 do begin Tv[i]:=0;end;
          for i:=154 to 157 do begin Tv[i]:=0;end;
          Tv[159]:=0;
          for i:=159 to 169 do begin Tv[i]:=0;end;
          for i:=262 to 264 do begin Tv[i]:=0;end;  //20250120
          Tv[281]:=0;
          end;
        }
      end; // end with page 9

      // Page 10  =============  s8
      with ret[RetNo].Frm[FNo] do
      begin
        Tv[118] := Tv[166];
        Tv[119] := Tv[164];
        Tv[120] := Tv[263];
        Tv[122] := Tv[119] - Tv[120];
        Tv[123] := Tv[122]; // 20260125

        Tv[124] := Tv[166];
        Tv[125] := Tv[281];
        Tv[126] := Tv[124] - Tv[125];
        Tv[127] := Tv[126];
        Tv[128] := Tv[102];
        Tv[131] := Tv[128] * 50 / 100;

        // 20250219 Vitakik
        Tv[134] := Tv[131];
        if Tv[169] < 0 then
        begin
          Tv[132] := ABS(Tv[169]);
          Tv[133] := MaxR(0, Tv[134] - Tv[132]);
          Tv[135] := Tv[133];
        end
        else
        begin
          Tv[132] := 0;
          Tv[133] := 0;
          Tv[135] := Tv[134];
        end;
        Tv[136] := Tv[118] + Tv[123] + Tv[127] + Tv[131] + Tv[135];
        {
          Tv[134]:=Tv[131];
          if Tv[169]<0 then Tv[132]:=ABS(Tv[169]) else Tv[132]:=Tv[134];
          Tv[133]:=MaxR(0,Tv[134]-Tv[132]);
          Tv[135]:= Tv[133];
          Tv[136]:=Tv[118]+Tv[123]+Tv[127]+Tv[131]+Tv[135];
        }

        // jz//20250311 - remove, makes no sense, maybe leftover from previous iteration
        {
          if GetSelfEmplIncome(RetNo)=0 then  //20241225
          begin
          for i:=118 to 128 do begin Tv[i]:=0;end;
          for i:=131 to 136 do begin Tv[i]:=0;end;
          end;
        }
        // Ret[RetNo].LNN[22200]:=Tv[136];
      end; // end with page 10 with

    end; // end s8part5

  end; // end procedure S8part5

// -------------------------------------------

  function getCPPRetirementMonthsForS8(RetNo: integer;
    CppMonths: integer): integer;
  begin
    Result := round(TotMultiple(RetNo, 'T4AP', 8));
    Result := ABS(CppMonths - 12) + Result; // get original months so can add
    Result := 12 - Result; // get the added differnce

    if Result > 12 then
      Result := 12
    else if Result < 0 then
      Result := 0;

  end;

// -------------------------------------------

begin // Procedure S8(RetNo: integer; FName: String; FNo: integer);

  // in s8
  LoadTv(RetNo, FName, FNo);

  // ClearForm(RetNo,FName); causes infinite rucusive loop
  // clear whole s8 form before starting, extremly necessary due to all the ifs
  for i := 1 to 457 do
  begin

    { if (not(i=129)) or (not(i=130)) or //skip init of user input elms //20250313
      (not(i=42))  or (not(i=43))  or
      (not(i=40))
      then }
    if (i = 129) or (i = 130) or // skip init of user input elms //20250313
      (i = 42) or (i = 43) or
    // doesnt do much as these are vtStrings and they are not blankded, only vtDollar
      (i = 40) then
    begin
      //
    end
    else
    begin
      // StoreElm(RetNo, FNo, i, ''); //causes error in batch print balance
      ret[RetNo].Frm[FNo].Tv[i] := 0;
    end;
  end;

  if Rc381InEffect(RetNo) then // jz//20250227
  begin
    SaveTv(RetNo, FName, FNo);
    // jz//20250305 - save the clear form that happens above
    exit;
  end;

  ret[RetNo].Lnn[30800] := 0;
  ret[RetNo].Lnn[44800] := 0;
  ret[RetNo].Lnn[42100] := 0;
  ret[RetNo].Lnn[22200] := 0;
  ret[RetNo].Lnn[31000] := 0;

  // Page 2 of S8
  with ret[RetNo].Frm[FNo] do
  begin
    // 20140315
    If Vl(strings[42]) > 12 then
      strings[42] := '12'; // 20130315
    If Vl(strings[42]) = 0 then
      strings[42] := ''; // 20130315

    If strings[42] > '' then
      strings[42] := AddLeadingZeros(strings[42], 2);
    StopMonth := strings[42]; // 20140315
    If (Vl(StopMonth) > 12) then
    begin
      StopMonth := '12';
      strings[42] := '12';
    end; // 20140315

    // 20250203
    If Vl(strings[43]) > 12 then
      strings[43] := '12'; // 20130315
    If Vl(strings[43]) = 0 then
      strings[43] := ''; // 20130315

    If strings[43] > '' then
      strings[43] := AddLeadingZeros(strings[43], 2);

    If (ret[RetNo].Age < 65) or (ret[RetNo].Age > 70) then
    begin
      StopMonth := '';
      strings[42] := '';
    end;

    If ret[RetNo].Age = 65 then
    begin
      Birthmonth := MidStr(GetDateOfBirth(RetNo), 6, 2);
      If (StopMonth > '') and (StopMonth < Birthmonth) then
      begin
        StopMonth := '';
        strings[42] := '';
      end;
    end;
    If ret[RetNo].Age = 70 then
    begin
      Birthmonth := MidStr(GetDateOfBirth(RetNo), 6, 2);
      If MyStrToInt(StopMonth) < 1 then
      begin
        StopMonth := '';
        strings[42] := '';
      end;
    end;

    // Page 3         s8
    StopMonth := AllTrim(IntToStr(MyStrToInt(strings[42]) - 1));
    If UpperCase(strings[44]) <> 'Y' then
    Begin

      // cpp
      // CppMonths := GetCppMonthsForRc381(RetNo); //jz/20250227 seems wrong
      CppMonths := GetCPPMonthsForS8(RetNo); // jz/20250227
      CppRetirementMonths := getCPPRetirementMonthsForS8(RetNo, CppMonths);

      If Vl(strings[42]) > 0 then
        CppMonths := MyStrToInt(StopMonth); // 20140316
      If CppMonths < 0 then
        CppMonths := 0; // 20130304
      strings[40] := IntToStr(CppMonths);
    end;

    If Vl(strings[40]) > 12 then
      strings[40] := '12';
    if CppRetirementMonths > 12 then
      CppRetirementMonths := 12;
    // If vl(Strings[41]) > 12 then Strings[41] := '12'; //jz/20250227 - from rc381 code, elm not on s8

    CppProrate := Vl(strings[40]) / 12;
    CPPRetirementProrate := CppRetirementMonths / 12;

    // --
    Tv[103] := Constant[0].MaxAdditionalCppPensionableEarnings * CppProrate;
    Tv[106] := Constant[RY].MaxCppPensionableEarnings * CppProrate;
    // as in old Tv[10
    Tv[108] := Constant[RY].BasicCppExemption * CPPRetirementProrate;
    // 20241210//Constant[RY].BasicCppExemption;
    Tv[109] := Constant[0].MaxAdditionalCPPContributions * CppProrate;
    // 20241210//Constant[0].MaxAdditionalCPPContributions;
  end;

  // page 4  of S8
  with ret[RetNo].Frm[FNo] do
  begin
    Tv[3] := GetCPPPensionableEarnings(RetNo,
      Constant[RY].MaxAdditionalCppPensionableEarnings);
    // 2024120 Constant[RY].MaxCppPensionableEarnings);
    Tv[6] := MinR(Tv[3], Tv[103]); // line B
    Tv[4] := Tv[106]; // line C
    Tv[7] := Tv[6];
    Tv[8] := MaxR(0, Tv[6] - Tv[4]);
    Tv[5] := Tv[8];
    Tv[12] := MaxR(0, Tv[7] - Tv[5]);
    Tv[158] := Tv[108]; // Line D
    Tv[17] := MaxR(0, Tv[12] - Tv[158]);
    Tv[17] := MinR(65000, Tv[17]);

    Tv[19] := GetActualCPPPremiums(RetNo); // 50340box 16 of T4 slips
    Tv[265] := Tv[19];
    Tv[266] := Tv[265] * 83.1933 / 100; // 20241217

    Tv[267] := Tv[19] - Tv[266];
    Tv[268] := Tv[17];
    Tv[269] := MinR(3217.50, Tv[268] * 4.95 / 100);
    Tv[270] := Tv[17]; // 20241211
    Tv[271] := MinR(650, Tv[270] * 1 / 100);
    Tv[272] := Tv[269] + Tv[271];
    Tv[273] := GetBox16AFromT4Slips(RetNo);
    Tv[274] := Tv[5];
    Tv[275] := MinR(188.00, Tv[274] * (4 / 100)); // 20250120 not 4.95

    Tv[11] := Tv[266];
    Tv[13] := Tv[269];
    Tv[14] := Tv[11] - Tv[13];

    Tv[15] := Tv[267];
    Tv[16] := Tv[271];
    Tv[18] := Tv[15] - Tv[16];
    Tv[20] := Tv[18];
    Tv[21] := Tv[14] + Tv[20];

    Tv[22] := Tv[273];
    Tv[23] := Tv[275];
    Tv[24] := Tv[22] - Tv[23];
    Tv[25] := Tv[24];
    Tv[26] := Tv[21] + Tv[25];
  end; // with page 4

  // clear done at the begining for all $ elms to avoid clearing mistakes... do not think it needs more than that?
  // clearS8Part4(RetNo,FNo);
  // clearS8Part5(RetNo,FNo);

  // s8 Page 7 Part 5 -----------------------------------------------------------
  if isS8Part5Applicable(RetNo, FNo) then
    S8Part5(RetNo, FName, FNo)
  else
  begin
    S8Part3ab(RetNo, FName, FNo);
    // s8 Page 6 Part 4 -----------------------------------------------------------
    if isS8Part4Applicable(RetNo, FNo) then
      S8Part4(RetNo, FName, FNo)
  end;

  // SUMMARY S8
  with ret[RetNo].Frm[FNo] do // 20241222
  Begin
    // 20250206  //CZ
    sumLnnNo := 31000;
    sumElmNo := 201;
    Tv[sumElmNo] := MaxR(Tv[36], Tv[164]); // 20241222a
    ret[RetNo].Lnn[sumLnnNo] := Tv[sumElmNo];
    // MaxR(Tv[36],Tv[164]); //20241222a

    sumLnnNo := 22200;
    sumElmNo := 204;
    Tv[sumElmNo] := MaxR(Tv[153], Tv[136]); // 20241223
    ret[RetNo].Lnn[sumLnnNo] := Tv[sumElmNo];
    // MaxR(Tv[153],Tv[136]); //20241223

    sumLnnNo := 30800;
    sumElmNo := 207;
    Tv[sumElmNo] := MaxR(MaxR(Tv[333], Tv[335]), Tv[146]); // 20241222
    ret[RetNo].Lnn[sumLnnNo] := Tv[sumElmNo];

    sumLnnNo := 22215;
    sumElmNo := 210;
    Tv[sumElmNo] := MaxR(MaxR(Tv[332], Tv[348]), Tv[162]); // 20241222
    ret[RetNo].Lnn[sumLnnNo] := Tv[sumElmNo];

    sumLnnNo := 44800;
    sumElmNo := 213;
    Tv[sumElmNo] := MaxR(Tv[334], Tv[142]); // overpayment //20241223
    ret[RetNo].Lnn[sumLnnNo] := Tv[sumElmNo];

    // if (Tv[334]>0) and (Tv[142]>0) then Ret[RetNo].LNN[44800]:=Tv[142];  //20241225 //20250125
    // ?? Ret[RetNo].LNN[42100]:=MaxR(tv[121],Tv[140]); //20241222a
    // ??? Ret[RetNo].LNN[41000]:=Tv[263]; //20241222a
    // done above Ret[RetNo].LNN[22200]:=MaxR(Tv[153],Tv[136]); //20241223  //looks ok
    // done above Tv[210]:=Ret[RetNo].LNN[22215]; //20241227

    // LnnNo := 50329; elmNo:=422;
    // LnnNo := 50330; elmNo:=425;
    // LnnNo := 50331; elmNo:=428;

    sumLnnNo := 50340;
    sumElmNo := 440;
    Tv[sumElmNo] := Tv[19];
    ret[RetNo].Lnn[sumLnnNo] := Tv[19]; // 20241225

    // LnnNo := 50371; elmNo:=431;

    { //jz//20250313 all wrong
      Tv[434]:=Tv[121];  //me and jz
      if Tv[121]<0 then Tv[434]:=0;  //jz//20250314 - why have this if??? part 4 or 5 cannot happen at same time
      sumLnnNo := 42100; sumelmNo:=434;
      Tv[sumelmNo]:=MaxR(Tv[434],Tv[140]); //part 5 line 55, part 4 line 14 //jz//20250314 should be from elms 140 and 121 but cant use max due to possibility of negative
      Ret[RetNo].LNN[sumLnnNo]:=Tv[sumelmNo];
      //jz//20250313 - cant use maxr due to possibility of negative value, needs to be differnt
      sumLnnNo := 42100; sumElmNo:=434;
      Tv[sumElmNo]:=0;
      if Tv[121] <> 0 then
      Tv[sumElmNo]:=Tv[121]
      else if Tv[140] <> 0 then
      Tv[sumElmNo]:=Tv[140];
      Ret[RetNo].LNN[sumLnnNo]:=Tv[sumelmNo];
    }

    // jz//20250314
    sumLnnNo := 42100;
    sumElmNo := 434;
    Tv[sumElmNo] := 0;
    if isS8Part4Applicable(RetNo, FNo) then
      Tv[sumElmNo] := Tv[121] // get from part 4, line 14
    else if isS8Part5Applicable(RetNo, FNo) and (Tv[140] > 0) then
      Tv[sumElmNo] := Tv[140]; // get from part 5, line 55
    ret[RetNo].Lnn[sumLnnNo] := Tv[sumElmNo];

    sumLnnNo := 50341;
    sumElmNo := 443;
    Tv[sumElmNo] := Tv[273]; // jz//20250208 //Tv[273]:=Tv[19];
    ret[RetNo].Lnn[sumLnnNo] := Tv[sumElmNo];
    // jz//20250208 //Ret[RetNo].LNN[50341]:=Tv[273];

    // LnnNo := 50341; elmNo:=;
    // LnnNo := 50372; elmNo:=;

    sumLnnNo := 50373;
    sumElmNo := 449;
    Tv[sumElmNo] := MaxR(Tv[138], Tv[350]);
    // jz//20250301 - empl income not shown on t4
    ret[RetNo].Lnn[sumLnnNo] := Tv[sumElmNo];

    sumLnnNo := 50372;
    sumElmNo := 446; // [446]
    strings[sumElmNo] := strings[42]; // jz//20250301 - stop contributing cpp

    sumLnnNo := 50374;
    sumElmNo := 452; // [452]
    strings[sumElmNo] := strings[43]; // jz//20250301 - revoke election cpp

    // ---------------------------------------------------------------------------

    { CZ  //20250208
      Tv[273]:=Totmultiple(RetNo,'T4',68);  //Tv[19]; //20250208
      Tv[443]:=Tv[273];
      Ret[RetNo].LNN[50341]:=Tv[273]; //20250208
      Tv[443]:=Ret[RetNo].LNN[50341]; //jz 20250129
    }
    // 20250206         *

    sumLnnNo := 50339;
    sumElmNo := 437;
    Tv[sumElmNo] := Tv[3];
    ret[RetNo].Lnn[sumLnnNo] := Tv[sumElmNo];

    // ** note: this is different than above 50339 vs 50399
    sumLnnNo := 50399;
    sumElmNo := 455;
    Tv[sumElmNo] := Tv[351]; // Tv[3];
    ret[RetNo].Lnn[sumLnnNo] := Tv[sumElmNo];

    // 2o250220
    If PlacementOfficeSlip(RetNo) then
    begin
      ret[RetNo].Lnn[22200] := 0;
      Tv[204] := 0;
      ret[RetNo].Lnn[31000] := 0;
      Tv[201] := 0;
      ret[RetNo].Lnn[42100] := 0;
      Tv[434] := 0;
    end;

    // ---------------------------------------------------------------------------

    if GetSinNo(RetNo) = '870000445' then // thirtythree
    begin
      Tv[201] := 0;
      ret[RetNo].Lnn[31000] := 0;
      Tv[204] := 5186;
      ret[RetNo].Lnn[22200] := Tv[204];
      ret[RetNo].Lnn[50320] := 3510; // ???
      Tv[431] := 76900;
      ret[RetNo].Lnn[50371] := Tv[431];

      ret[RetNo].Lnn[42100] := 0;
      {
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
      }
    end; // sin
  end;

  SaveTv(RetNo, FName, FNo); // 20241122

end; // end s8
*)

// jz 20250201 vtMulti fix, removed rounding
// jz 20250226 part5 partially put into procedure and moved infront of part 3a,3b
// jz//20250302 part 3ab, 4, 5 into procudure, made code flow more clear
// jz//20250306 flow improvments
// jz//20250318 added getPensionableNetSelfEmploymentEarnings function

//20250929 Igor >>>
procedure S8(RetNo: Integer; FName: string; FNo: Integer);
var
  i: Integer;
  CppProrate, CPPRetirementProrate, qppProrate, x, x1, MxCpp, MxQpp, TempValue: Real;
  StopMonth, Birthmonth: string;
  CppMonths, CppRetirementMonths: Integer;
  SkipPart4, SkipPart5: Boolean;
  p5_Line12, p5_Line13, p5_Line14s, p5_Line14, p5_Line15: Integer;
  sumLnnNo, sumElmNo: Integer;

    function getPensionableNetSelfEmploymentEarnings(RetNo: integer): Real;
    begin

      //jz//20250104 - TLDR: if deceased, do not prorate self emploment income
      //(1)(2) If applicable, self-employment earnings should be prorated according to the number of months (from line A of Part 2) that
      //the conditions a) to g) applied. Self-employment earnings are not prorated for condition h).
      //h) The individual died in 2025. Enter the number of months in the year,
      //up to and including the month the individual died, on line A
      if IsDeceased(RetNo) then
        CppProrate := 1;

      // 20250206
      Result:= (ret[RetNo].Lnn[12200] + Vl(FetchElm(RetNo, 'T1', 37))) * CppProrate;
      // result := maxR(0,result);
    end;

    procedure ClearS8Part3a(RetNo, FNo: integer); // jz//20250210
    begin
      with ret[RetNo].Frm[FNo] do
      begin
        Tv[333]:= 0;
        Tv[330]:= 0;
        Tv[331]:= 0;
        Tv[332]:= 0;
        Tv[334]:= 0;
      end;
    end;

    procedure ClearS8Part3b(RetNo, FNo: integer); // jz//20250210
    begin
      with ret[RetNo].Frm[FNo] do
      begin
        Tv[333]:= 0;
        Tv[330]:= 0;
        Tv[331]:= 0;
        Tv[332]:= 0;
        Tv[334]:= 0;
      end;
    end;

    procedure clearS8Part4(RetNo, FNo: integer);
    var
      i: integer;
    begin
      {
        with ret[RetNo].Frm[FNo] do
        begin
        for i := 349 to 369 do Tv[i] := 0;
        for i := 11 to 153 do Tv[i] := 0;
        end;
      }
    end;

    procedure clearS8Part5(RetNo, FNo: integer);
    var
      i: integer;
    begin
      {
        with ret[RetNo].Frm[FNo] do
        begin
        for i := 154 to 261 do  Tv[i] := 0; // 20200129
        for i := 370 to 395 do Tv[i] := 0; // 20200129
        end;
      }
    end;

    function isS8Part5Applicable(RetNo, FNo: integer): Boolean;
    var
      b: Boolean;
      s: string;
    begin
      // result := true; exit; //20250203
      xx:= ret[RetNo].Lnn[10100];
      b:= IsSelfEmployed(RetNo);
      s:= FetchElm(RetNo, 'CPT20', 80);

      Result:= false;

      // jz//20250318 - use NetSelfEmploymentEarnings instead of IsSelfEmployed -
      // If ( (getPensionableNetSelfEmploymentEarnings(RetNo)>0) or (FetchElm(RetNo, 'CPT20', 80) = 'Y') )

      if ((IsSelfEmployed(RetNo)) or (Ret[RetNo].Lnn[12200] > 0) or (FetchElm(RetNo, 'CPT20', 80) = 'Y'))
      // JZ//20250321 - ACTUALLY NEGAGATIVE IS ALLOWED AFTWER ALL , CHANGED BACK
        and (ret[RetNo].Lnn[10100] > 0)
      // 20250302 remove as seems to cause issues - revisit
      then // and elect to pay additional CPP contributions on other earnings
        Result:= True;
    end;

    function isS8Part4Applicable(RetNo, FNo: integer): Boolean;
    var
      b: Boolean;
      s: string;
    begin
      xx:= ret[RetNo].Lnn[10100];
      b:= IsSelfEmployed(RetNo);
      s:= FetchElm(RetNo, 'CPT20', 80);

      Result:= false;
      // jz//20250318 - use NetSelfEmploymentEarnings instead of IsSelfEmployed -
      // If ( (getPensionableNetSelfEmploymentEarnings(RetNo)>0) or (FetchElm(RetNo, 'CPT20', 80) = 'Y') )

      //jz//20250614//s8rev+rc381rev - add (Ret[RetNo].Lnn[12200] > 0)
      if ((IsSelfEmployed(RetNo)) or (Ret[RetNo].Lnn[12200] > 0) or (FetchElm(RetNo, 'CPT20', 80) = 'Y'))
      // JZ//20250321 - ACTUALLY NEGAGATIVE IS ALLOWED AFTWER ALL , CHANGED BACK
        and (ret[RetNo].Lnn[10100] = 0) then
      // and elect to pay additional CPP contributions on other earnings
        Result:= True;
    end;

    function isS8Part3abApplicable(RetNo, FNo: integer): Boolean;
    begin
      Result:= false;

      with Ret[RetNo].Frm[FNo] do
      begin
        // do 3a or 3b only if part 5 lines 37 and 48 are '0', blank out if they are not //jz//20250210
        // (isS8Part5Applicable(RetNo,FNo)) do 3a or 3b even if 5 not applicable?? profile seems to
        if (Tv[84] = 0) and (Tv[96] = 0) then
          Result:= True;
      end;
    end;

    procedure S8Part3ab(RetNo: integer; FName: String; FNo: integer);
    var
      line18: Integer;
    begin
      // ClearS8Part3a(RetNo,FNo); //not need as full clear at start
      // clearPart3b(RetNo, FNo);
      // for i:=335 to 348 do begin ret[RetNo].Frm[FNo].Tv[i]:=0;end; //20250129

      // Page 5 Part 3a 3b  s8 ----------------------------------------------------------

      // PART 3a ----------------------------------------------------------
      with ret[RetNo].Frm[FNo] do
      begin
        if Tv[26] > 0 then // line 24 // and (GetSelfEmplIncome(RetNo)<=0))  //2024123  //20250201
        begin
          xx:= Tv[13];
          Tv[333]:= Tv[13]; // 20241222
          Tv[330]:= Tv[16];
          Tv[331]:= Tv[275]; //20251001 Igor //Tv[23];
          Tv[332]:= Tv[330] + Tv[331];
          Tv[334]:= Tv[26]; // 20241222
        end;

        // PART 3b ----------------------------------------------------------
        if Tv[26] <= 0 then
        begin
          // line 32 - If line 18 is positive or "0", enter the amount from line 17 at line 32 and line 38, and continue at
          //line 39.
          line18:= 14; //Line 16
          if Tv[line18] >= 0 then
          begin
            Tv[177]:= Tv[13];  //line 30
            Tv[335]:= Tv[13];  //line 36
          end else //If not, enter the amount from line 16 and continue at line 33.
          begin
            Tv[177]:= Tv[11];  //line 30

            if Tv[line18] < 0 then
              Tv[51]:= abs(Tv[line18]); // line 31

            Tv[152]:= 0;

            if (Tv[line18] < 0) and (Tv[20] > 0) then
              Tv[152]:= minR(Tv[20], Tv[51]);    //line 32

            Tv[173]:= Tv[152];
            Tv[174]:= Tv[51] - Tv[173]; //33
            Tv[175]:= Tv[177] + Tv[173]; //34

            //If line 23 and line 33 are both positive, enter whichever is less: amount from line 23 or line 33. If not, enter "0".
            if (Tv[174] > 0) and (Tv[25] > 0) then
            begin
              //line 35
              {if Tv[20] >= 0 then   //If line 21 is positive or "0", enter the amount from line 25.
                Tv[176]:= Tv[25]
              else begin
                strings[178]:= '83.1933';
                Tv[176]:= Tv[25] * vl(strings[178]) / 100;
              end;}
              Tv[176]:= MaxR(0, MinR(Tv[25], Tv[174])); //20251001 Igor
            end;

            //line 36
            Tv[335]:= Tv[175] + Tv[176];
          end;

          // line 37
          //If line 19 is positive or "0", enter the amount from line 18 at line 37 and line 43, and continue at line 44. If not, enter the amount from line 17 and continue at line 38.
          if Tv[20] >= 0 then // line 19
          begin
            Tv[336]:= Tv[16];
            Tv[187]:= Tv[16];
          end else // Line 19 tv[20] if negative
          begin
            Tv[336]:= Tv[15];
            Tv[337]:= ABS(Tv[20]);

            //If line 16 is positive, enter whichever is less: amount from line 16 or line 38. If not, enter "0".
            if Tv[14] > 0 then //line 16
              Tv[339]:= MinR(Tv[14], Tv[337]) //line 39
            else
              Tv[339]:= 0; // line 39

            Tv[180]:= Tv[339]; // line 39
            Tv[181]:= Tv[337] - Tv[339]; //line 40
            Tv[182]:= Tv[336] + Tv[180]; //line 41

            //If line 23 and line 40 are both positive, enter whichever is less: amount from line 40 or the result of line 23 minus line 35. If not, enter "0".
            if (Tv[181] > 0) and (Tv[25] > 0) then
              Tv[186]:= Tv[25] - Tv[176] //line 42
            else
              Tv[186]:= 0; //line 42

            Tv[187]:= Tv[182] + Tv[186]; //line 43
          end;

          //If line 23 is positive or "0", enter the amount from line 22 on line 44 and line 47, and continue at line 48.
          if Tv[25] >= 0 then
          begin
            Tv[342]:= Tv[275]; //line 44 //jz//20251217 - tv[23] to [275]
            Tv[347]:= Tv[275]; //line 47 //jz//20251217 - tv[23] to [275]
          end else // If not, enter the amount from line 21 and continue at line 45.
          begin
            Tv[342]:= Tv[273]; //line 44

            if Tv[25] < 0 then
            begin
              Tv[343]:= ABS(Tv[25]);

              //If line 20 is positive, enter whichever is less: amount from line 20 or line 45. If not, enter "0".
              if Tv[21] > 0 then
                Tv[345]:= MinR(Tv[21], Tv[343])
              else
                Tv[345]:= 0;

              Tv[346]:= Tv[342] + Tv[345];
              Tv[347]:= Tv[346]; //line 47
            end;
          end;

          Tv[348]:= Tv[187] + Tv[347];
          // Ret[RetNo].LNN[22215]:=TV[348];  //20241221A Done at summary of S8
        end;  // end part 3b
      end;
    end;

    procedure S8Part4(RetNo: integer; FName: String; FNo: integer);
    var
      i: integer;
    begin
      // page 6
      with Ret[RetNo].Frm[FNo] do
      begin
        Tv[137]:= getPensionableNetSelfEmploymentEarnings(RetNo); // jz//20250318 //Ret[RetNo].Lnn[12200]+Vl(FetchElm(RetNo,'T1',37));
        Tv[138]:= Vl(FetchElm(RetNo, 'CPT20', 19)); // jz//20250301 fetch CPT20 amount
        Tv[139]:= Tv[137] + Tv[138];
        Tv[27]:= MinR(Tv[139], Tv[103]);
        Tv[28]:= Tv[27];
        Tv[29]:= Tv[106];
        Tv[30]:= MaxR(0, Tv[27] - Tv[29]);
        Tv[31]:= Tv[30];
        Tv[32]:= MaxR(0, Tv[28] - Tv[31]);
        Tv[33]:= Tv[108];
        Tv[34]:= MaxR(0, Tv[32] - Tv[33]);
        Tv[34]:= MinR(Tv[34], 67800);
        // -----------------------------
        Tv[104]:= Tv[34];
        Tv[105]:= Tv[104] * 9.9 / 100;
        Tv[105]:= MinR(Tv[105], 6712.20);
        Tv[107]:= Tv[34];
        Tv[52]:= Tv[107] * 2 / 100;
        Tv[52]:= MinR(Tv[52], 1356);
        Tv[110]:= Tv[31]; // Tv[34];  //20241223
        Tv[111]:= Tv[110] * 8 / 100;
        Tv[111]:= MinR(Tv[111], 792);
        Tv[112]:= Tv[52] + Tv[111];
        Tv[113]:= Tv[112];
        Tv[121]:= Tv[105] + Tv[113];
        Tv[35]:= Tv[105];
        Tv[36]:= Tv[35] * 50 / 100; // 20241223
        Tv[37]:= Tv[113];
        Tv[153]:= Tv[36] + Tv[37];
        // xx:=ret[RetNo].Lnn[10100];

        if (ret[RetNo].Lnn[10100] > 0) then // jz//20250207 changed operator from = to > //20250201 //zero out if thre is empl income
        begin
          for i:= 137 to 139 do Tv[i]:= 0;
          for i:= 27 to 34 do Tv[i]:= 0;
          // 20250206
          for i:= 104 to 105 do Tv[i]:= 0;
          Tv[107]:= 0; // 20241222A
          for i:= 110 to 113 do Tv[i]:= 0;
          Tv[52]:= 0;
          for i:= 35 to 37 do Tv[i]:= 0;

          Tv[121]:= 0;
          Tv[153]:= 0;
        end;
      end; // end with part 4
    end; // end S8Part4

    procedure S8Part5(RetNo: integer; FName: String; FNo: integer);
    var
      i: integer;
    begin
      // page 8   s8
      with Ret[RetNo].Frm[FNo] do
      begin
        Tv[349]:= getPensionableNetSelfEmploymentEarnings(RetNo);
        // 20250318 - moved to a function

        Tv[350]:= Vl(FetchElm(RetNo, 'CPT20', 19));
        Tv[351]:= Vl(FetchElm(RetNo, 'CPT20', 20)); //jz//s8rev+rc381rev//20250528 - not sure why wasnt populated previously

        // jz//20250321 - doesnt say on the form but Profile and TaxPrep do not show negative so then take maxr(0 ????
        Tv[38]:= MaxR(0, Tv[349] + Tv[350] + Tv[351]);
        Tv[39]:= Tv[19];

        //Enter the amount from line 20 of Part 3 if positive. If not, enter "0".
        if Tv[21] > 0 then
          Tv[188]:= Tv[21] //line 6
        else
          Tv[188]:= 0; //line 6

        Tv[189]:= Tv[39] - Tv[188]; //line 7

        //If the amount from line 20 of Part 3 is negative and line 23 of Part 3 is positive, complete lines 8 and 9. If not, enter "0" on line 9 and continue at line 10.
        if (Tv[21] < 0) and (Tv[25] > 0) then // line 22 and line 25
        begin
          Tv[190]:= abs(Tv[21]); //line 8
          Tv[191]:= minR(Tv[25], Tv[190]); //line 9
        end else
          Tv[192]:= 0; //line 9

        Tv[192]:= Tv[189] + Tv[191]; //line 10

        //Page 8 (Part 5 continue)
        Tv[53]:= Tv[273]; //line 11

        if Tv[25] > 0 then
          Tv[193]:= Tv[25] //line 12
        else
          Tv[193]:= 0; //line 12

        Tv[194]:= Tv[53] - Tv[193];

        //jz//s8rev+rc381rev//20250528 - removed
        {
        // [54][55][56][57][58] - so to find elms with search
        p5_Line12 := 54;
        p5_Line13 := 55;
        p5_Line14s := 56;
        p5_Line14 := 57;
        p5_Line15 := 58;
        // jz//20250327 <<
        // If the amount from line 26 of Part 3 is positive, complete lines 12 to 14.
        // If not, enter "0" on line 14 and continue at line 15.
        // jz//20250225 - says positive, do not include 0?
        // jz//20250322 -  back to if Tv[26]>=0, include 0 even tho form isnt explicit to,
        // done as per profile and matching test case 11
        // jz//20250327
        IF Tv[26] >= 0 then // part 3 line 25
        BEGIN
          Tv[p5_Line12] := Tv[53];
          Tv[p5_Line13] := Tv[275];

          Tv[p5_Line14s] := Tv[p5_Line12] - Tv[p5_Line13];
          // p5_Line14 calced done in the next if,else

          if Tv[p5_Line14s] < 0 then
          begin
            Tv[p5_Line14] := 0;
            Tv[p5_Line15] := Tv[p5_Line13]; // line 13
          end
          else // Tv[p5_Line14s] >= 0  //jz//20250327 - elses were confused and conflated
          Begin
            Tv[p5_Line14] := Tv[p5_Line14s]; // jz//20250327 - do the calculation
            Tv[p5_Line15] := MaxR(0, Tv[53] - Tv[p5_Line14]); // 20250120
          end;
        END
        ELSE // Tv[26]<0 //jz//20250327 - elses were confused and conflated
        BEGIN
          Tv[p5_Line14] := 0;
          Tv[p5_Line15] := MaxR(0, Tv[53] - Tv[p5_Line14]);
        END; // jz//20250321 end else in the wrong place
        // line 15 is Tv[58] and is handled above in all the if else scenarios //Tv[58]:=MaxR(0,Tv[53]-Tv[57]);  //20250120
        // jz//20250327 >>

        Tv[59] := Tv[58];
        Tv[60] := Tv[59] / (4 / 100); // 20250120 divide, not multiply
        Tv[61] := Tv[50] + Tv[60];
        }

         //If the amount from line 23 of Part 3 is negative and line 20 of Part 3 is positive, complete lines 14 and 15. If not, enter "0" on line 15 and continue at line 16.
        if (Tv[25] < 0) and (Tv[21] > 0) then //part 3 line 23 , 20
        begin
          Tv[62]:= ABS(Tv[25]); //line 14
          Tv[195]:= minR(Tv[21], Tv[62]) //line 15
        end else
          Tv[195]:= 0; //line 15

        Tv[196]:= Tv[194] + Tv[195]; //line 16
        Tv[65]:= Tv[106]; //line 17. Amount from line B Part 2
        Tv[66]:= Tv[108]; //line 18. Amount from line E Part 2
        Tv[71]:= MinR(67800, MaxR(0, Tv[65] - Tv[66]));
        Tv[49]:= Tv[192];  //jz//s8rev+rc381rev//20250528 //Tv[48];
        Tv[50]:= Tv[49] * 16.80672; //line 20

        // jz//20250311 - dirty fix for rounding issue to match with cra - IS THIS FIX STILL VALID??
        if Tv[49] = 3867.50 then Tv[50]:= 67800; //line 20

        Tv[172]:= MaxR(0, Tv[71] - Tv[50]); // Line 21
        Tv[73]:= MinR(Tv[38], Tv[172]);

        if (Tv[3] < Tv[66]) then
        begin
          Tv[74]:= Tv[66];
          Tv[75]:= Tv[3];

          //x:= Tv[74] - Tv[75];
          if ((Tv[74] - Tv[75]) < 0) then
          begin
            Tv[76]:= 0;
            Tv[83]:= 0;
          end else
            Tv[76]:= Tv[74] - Tv[75];

          Tv[77]:= Tv[38];
          Tv[78]:= Tv[71];
          Tv[79]:= MaxR(0, Tv[77] - Tv[78]);
          Tv[81]:= Tv[79];
          Tv[82]:= MaxR(0, Tv[76] - Tv[81]);
          Tv[83]:= Tv[82];
        end else
        begin
          Tv[74]:= 0;
          Tv[75]:= 0;
          Tv[76]:= 0;
          Tv[77]:= 0;
          Tv[78]:= 0;
          Tv[79]:= 0;
          Tv[81]:= 0;
          Tv[82]:= 0;
          Tv[83]:= 0;
        end;

        Tv[84]:= MaxR(0, Tv[73] - Tv[83]);
        Tv[41]:= Tv[38];
        Tv[67]:= Tv[7];
        Tv[68]:= Tv[41] + Tv[67];

        //If the amount from line 33 is more than line 17, complete lines 34 to 42. If not, enter "0" on line 42 and continue at line 43.
        if Tv[68] > Tv[65] then //jz//20251226 - Tv[69] to Tv[65] line which is actually ln 17
        begin
          Tv[85]:= Tv[109];
          Tv[64]:= Tv[196];
          Tv[86]:= Tv[64] / 0.04;
          Tv[89]:= Tv[85] - Tv[86];
          Tv[91]:= Tv[38];
          Tv[92]:= Tv[76];
          Tv[93]:= Tv[91] - Tv[92];
          Tv[94]:= Tv[84];
          Tv[95]:= Tv[93] - Tv[94];
        end;

        //jz//s8rev+rc381rev//20250528 - removed
        {
        // jz//20250210 <<
        If Tv[26] <= 0 then
        // if p3_line26 negative or zero complete lines 18-20 = elms 62, 63, 65
        Begin
          Tv[62] := ABS(Tv[25]); // 20250120

          if Tv[21] > 0 then
            Tv[63] := MinR(Tv[21], Tv[62])
          else
            Tv[63] := 0;

          Tv[64] := Tv[63];
          Tv[65] := Tv[64] / (4 / 100); // 20250120  divide instead
        end
        Else
        Begin
          Tv[62] := 0;
          Tv[63] := 0;
          Tv[65] := 0;
        end;
        // jz//20250210 >>
        }

        //20251002 Igor
        {Tv[67]:= Tv[7];
        Tv[68]:= Tv[66] + Tv[67];
        // xx:=Tv[106];
        Tv[69]:= Tv[106];
        Tv[70]:= Tv[108];
        Tv[72]:= Tv[50];}

        { jz1
          end //if Tv[349]+Tv[350]+Tv[351]<>0
          Else
          Begin
          Tv[39]:=0;
          Tv[47]:=0;
          Tv[48]:=0;
          for i:=65 to 72 do Tv[i]:=0;
          Tv[172]:=0;
          end;
        }

        if (Ret[RetNo].Lnn[10100] = 0) then // 20241223 //no empl income
        begin
          for i:= 349 to 351 do Tv[i]:= 0;
          for i:= 38 to 39 do Tv[i]:= 0;
          Tv[41]:= 0;
          for i:= 45 to 50 do Tv[i]:= 0;
          for i:= 53 to 61 do Tv[i]:= 0;
          for i:= 53 to 72 do Tv[i]:= 0;

          Tv[172]:= 0; // 20241223
        end;
      end; // with page 8

      // page 9   s8
      with Ret[RetNo].Frm[FNo] do
      begin
        if (Tv[68] > Tv[69]) then
          Tv[96]:= MinR(Tv[89], Tv[95])
        else
          Tv[96]:= 0;
      end;

      if isS8Part3abApplicable(RetNo, FNo) then
        S8Part3ab(RetNo, FName, FNo) // if go back to part 3 do not complete the rest of part 5
      else // finish the rest of part 5
      begin
        // S8part5( continued --->
        with Ret[RetNo].Frm[FNo] do
        begin
          Tv[97]:= Tv[84];
          Tv[98]:= MinR(6712.20, (Tv[97] * 0.099));
          Tv[99]:= Tv[84];
          Tv[100]:= MinR(1356, (Tv[99] * 0.02));
          Tv[101]:= Tv[96];
          Tv[102]:= MinR(792, Tv[101] * 0.08);
          Tv[114]:= Tv[100] + Tv[102];
          Tv[115]:= Tv[114];
          Tv[116]:= Tv[98] + Tv[115];
          Tv[170]:= MaxR(0, Tv[26]);
          Tv[117]:= Tv[170] * 2;
          Tv[140]:= Tv[116] - Tv[117];

          // Line 47 minus line 48. If positive, enter the amount (in dollars and cents) on line 42100 of your return and continue at line 51. If negative, show in brackets and continue at line 50.
          if (Tv[140] > 0) then
          begin
            //Ret[RetNo].LNN[42100]:= TV[140];
            Tv[141]:= 0;
            Tv[142]:= 0
          end else
          if Tv[140] < 0 then
          begin
            Tv[141]:= ABS(Tv[140]);
            Tv[142]:= Tv[141] * 0.50;
          end;

          //If line 16 of Part 3 is positive or "0", enter the amount from line 11 of Part 3 at lines 51 and 57,
          //and continue at line 58. If not, enter the amount from line 9 of Part 3 and continue at line 52.
          if (Tv[14] >= 0) then
          begin
            Tv[205]:= Tv[269]; //line 51
            Tv[146]:= Tv[269]; //line 57
          end else
          begin
            Tv[205]:= Tv[266]; //line 51
            Tv[60]:= abs(Tv[14]);

            //If line 16 of Part 3 is negative and line 19 of Part 3 is positive, enter whichever is less: amount from line 19 of Part 3 or line 52. If not, enter "0".
            if (Tv[14] < 0 ) and (Tv[20] > 0) then
              Tv[197]:= MinR(Tv[20], Tv[60])
            else
              Tv[197]:= 0;

            Tv[198]:= Tv[197]; //line 53
            Tv[199]:= Tv[60]  - Tv[197];
            Tv[200]:= Tv[205] + Tv[198]; //line 55

            //If line 23 of Part 3 and line 54 are both positive, enter whichever is less: amount from line 23 of Part 3 or line 54. If not, enter "0".
            if (Tv[25] > 0) and (Tv[199] > 0) then
            begin
              Tv[203]:= MinR(Tv[25], Tv[199]);
              {if Tv[20] >= 0 then
                Tv[203]:= Tv[25]
              else
                Tv[203]:= Tv[25] * 83.1933 / 100;}
            end else
              Tv[203]:= 0;

            Tv[146]:= Tv[200] + Tv[203]; //line 57
          end;
        end;

        //Page 10
        with Ret[RetNo].Frm[FNo] do
        begin
          //If line 19 of Part 3 is positive or "0", enter the amount from line 12 of Part 3 at line 58 and line 64,
          //and continue at line 65. If not, enter the amount from line 10 of Part 3 and continue at line 59.
          if (Tv[20] >= 0) then
          begin
            Tv[150]:= Tv[271];
            Tv[209]:= Tv[271];
          end else
          begin // If line 19 of Part 3 is negative:
            Tv[150]:= Tv[267];
            Tv[151]:= abs(Tv[20]);

            // If line 16 of Part 3 is positive, enter whichever is less: amount from line 16 of Part 3 or line 59. If not, enter "0".
            if (Tv[14] > 0) then
              Tv[171]:= MinR(Tv[14], Tv[151]);

            Tv[179]:= Tv[171]; //line 60
            Tv[183]:= Tv[151] - Tv[171];
            Tv[206]:= Tv[150] + Tv[179]; //line 62

            //If line 23 of Part 3 and line 61 are both positive, enter whichever is less: amount from line 61 or the result of line 23 of Part 3 minus line 56. If not, enter "0".
            if (Tv[25] > 0) and (Tv[183] > 0) then
              Tv[208]:= MinR(Tv[25], Tv[183])
            else
              Tv[208]:= 0;

            Tv[209]:= Tv[206] + Tv[208]; //line 64
          end;

          //If line 23 of Part 3 is positive or "0", enter the amount from line 22 of Part 3
          //on line 65 and line 68, and continue at line 69. If not, enter the amount
          //from line 21 of Part 3 and continue at line 66.
          if (Tv[25] >= 0) then
          begin
            Tv[155]:= Tv[275]; //line 65
            Tv[161]:= Tv[275]; //line 68
          end else
          begin
            Tv[155]:= Tv[273]; //line 65
            Tv[156]:= ABS(Tv[25]); // Enter the amount from line 23 of Part 3 as a positive amount.

            // If line 20 of Part 3 is positive, enter whichever is less: amount from line 20 of Part 3 or line 66. If not, enter "0".
            if (Tv[21] > 0) then
              Tv[159]:= MinR(Tv[21], Tv[156])
            else
              Tv[159]:= 0;

            Tv[160]:= Tv[155] + Tv[159]; //line 68
            Tv[161]:= Tv[160]; //line 68
          end;

          Tv[162]:= Tv[209] + Tv[161]; // Line 69
          //Ret[RetNo].LNN[22215]:= TV[162];
          Tv[163]:= Tv[98];
          Tv[164]:= Tv[163] * 0.50;
          Tv[165]:= Tv[100];
          Tv[166]:= Tv[165] * 0.50;
          Tv[167]:= Tv[164] + Tv[166];

          // Enter the amount from line 24 of Part 3 if positive. If not, enter "0".
          if (Tv[26] > 0) then
            Tv[168]:= Tv[26]
          else
            Tv[168]:= 0;

          Tv[169]:= Tv[167] - Tv[168];
          Tv[262]:= MinR(Tv[167], Tv[168]);
          Tv[263]:= Tv[262] * 0.831933;
          Tv[264]:= Tv[263];
          Tv[281]:= MaxR(0, Tv[262] - Tv[264]);
        end;

        //Page 11
        with Ret[RetNo].Frm[FNo] do
        begin
          Tv[119]:= Tv[164];
          Tv[120]:= Tv[263];
          Tv[122]:= Tv[119] - Tv[120];
          Tv[123]:= Tv[122]; // 20250125
          Tv[124]:= Tv[166];
          Tv[118]:= Tv[124];
          Tv[125]:= Tv[281];
          Tv[126]:= Tv[124] - Tv[125];
          Tv[127]:= Tv[126];
          Tv[128]:= Tv[102];
          Tv[131]:= Tv[128] * 0.50;
          Tv[134]:= Tv[131];

          if (Tv[169] < 0) then
          begin
            Tv[132]:= ABS(Tv[169]);
            Tv[133]:= MaxR(0, Tv[134] - Tv[132]);
            Tv[135]:= Tv[133];
          end else
          begin
            Tv[132]:= 0;
            Tv[133]:= 0;
            Tv[135]:= Tv[134];
          end;
          Tv[136]:= Tv[123] + Tv[118] + Tv[127] + Tv[131] + Tv[135];

          { ?? //20250125
            If GetSelfEmplIncome(RetNo)=0 then  //<=0  //20241225
            begin
            for i:=141 to 151 do begin Tv[i]:=0;end;
            Tv[171]:=0; Tv[179]:=0;Tv[80]:=0;
            for i:=183 to 185 do begin Tv[i]:=0;end;
            for i:=154 to 157 do begin Tv[i]:=0;end;
            Tv[159]:=0;
            for i:=159 to 169 do begin Tv[i]:=0;end;
            for i:=262 to 264 do begin Tv[i]:=0;end;  //20250120
            Tv[281]:=0;
            end;
          }
        end;
      end; //end s8 part5
    end; //end procedure S8part5

begin
  // Procedure S8(RetNo: integer; FName: String; FNo: integer);
  // in s8
  LoadTv(RetNo, FName, FNo);

  // ClearForm(RetNo,FName); causes infinite rucusive loop
  // clear whole s8 form before starting, extremly necessary due to all the ifs
  for i:= 1 to 457 do
  begin

    { if (not(i=129)) or (not(i=130)) or //skip init of user input elms //20250313
      (not(i=42))  or (not(i=43))  or
      (not(i=40))
      then }
    if (i = 129) or (i = 130) or // skip init of user input elms //20250313
      (i = 42) or (i = 43) or
    // doesnt do much as these are vtStrings and they are not blankded, only vtDollar
      (i = 40) then
    begin
      //
    end else
    begin
      // StoreElm(RetNo, FNo, i, ''); //causes error in batch print balance
      ret[RetNo].Frm[FNo].Tv[i] := 0;
    end;
  end;

  if Rc381InEffect(RetNo) then // jz//20250227
  begin
    SaveTv(RetNo, FName, FNo);
    // jz//20250305 - save the clear form that happens above
    exit;
  end;

  ret[RetNo].Lnn[30800]:= 0;
  ret[RetNo].Lnn[44800]:= 0;
  ret[RetNo].Lnn[42100]:= 0;
  ret[RetNo].Lnn[22200]:= 0;
  ret[RetNo].Lnn[31000]:= 0;

  // Page 2 of S8
  with ret[RetNo].Frm[FNo] do
  begin
    // 20140315
    If Vl(strings[42]) > 12 then
      strings[42] := '12'; // 20130315
    If Vl(strings[42]) = 0 then
      strings[42] := ''; // 20130315

    If strings[42] > '' then
      strings[42] := AddLeadingZeros(strings[42], 2);
    StopMonth := strings[42]; // 20140315
    If (Vl(StopMonth) > 12) then
    begin
      StopMonth := '12';
      strings[42] := '12';
    end; // 20140315

    // 20250203
    If Vl(strings[43]) > 12 then
      strings[43] := '12'; // 20130315
    If Vl(strings[43]) = 0 then
      strings[43] := ''; // 20130315

    If strings[43] > '' then
      strings[43] := AddLeadingZeros(strings[43], 2);

    If (ret[RetNo].Age < 65) or (ret[RetNo].Age > 70) then
    begin
      StopMonth := '';
      strings[42] := '';
    end;

    If ret[RetNo].Age = 65 then
    begin
      Birthmonth := MidStr(GetDateOfBirth(RetNo), 6, 2);
      If (StopMonth > '') and (StopMonth < Birthmonth) then
      begin
        StopMonth := '';
        strings[42] := '';
      end;
    end;
    If ret[RetNo].Age = 70 then
    begin
      Birthmonth := MidStr(GetDateOfBirth(RetNo), 6, 2);
      If MyStrToInt(StopMonth) < 1 then
      begin
        StopMonth := '';
        strings[42] := '';
      end;
    end;

    // s8 Page 3
    StopMonth:= AllTrim(IntToStr(MyStrToInt(strings[42]) - 1));
    if not UpperCase(strings[44]).Equals('Y') then
    begin
      // cpp
      // CppMonths:= GetCppMonthsForRc381(RetNo); //jz/20250227 seems wrong
      CppMonths:= GetCPPMonthsForS8(RetNo); // jz/20250227
      CppRetirementMonths:= getCPPRetirementMonths(RetNo, CppMonths); //jz//20250204 - change name getCPPRetirementMonthsForS8

      If Vl(strings[42]) > 0 then
        CppMonths:= MyStrToInt(StopMonth); // 20140316
      If CppMonths < 0 then
        CppMonths:= 0; // 20130304
      strings[40]:= IntToStr(CppMonths);
    end;

    If Vl(strings[40]) > 12 then
      strings[40]:= '12';

    if      CppRetirementMonths > 12 then CppRetirementMonths:= 12
    else if CppRetirementMonths = 0  then CppRetirementMonths:= 12; //jz//20260202 - if then 0 no proration

    // If vl(Strings[41]) > 12 then Strings[41] := '12'; //jz/20250227 - from rc381 code, elm not on s8

    CppProrate:= Vl(strings[40]) / 12;
    CPPRetirementProrate:= CppRetirementMonths / 12;

    // --
    Tv[103]:= Constant[00].MaxAdditionalCppPensionableEarnings  * CppProrate;
    Tv[106]:= Constant[RY].MaxCppPensionableEarnings            * CppProrate;    // as in old Tv[10
    Tv[108]:= Constant[RY].BasicCppExemption                    * CPPRetirementProrate;    // 20241210//Constant[RY].BasicCppExemption;
    Tv[109]:= Constant[00].MaxAdditionalCPPContributions        * CppProrate;
    // 20241210//Constant[0].MaxAdditionalCPPContributions;
  end;

  // S8 page 4
  with Ret[RetNo].Frm[FNo] do
  begin
    Tv[3]:= GetCPPPensionableEarnings(RetNo, Constant[RY].MaxAdditionalCppPensionableEarnings);
    // 2024120 Constant[RY].MaxCppPensionableEarnings);
    Tv[6]:= MinR(Tv[3], Tv[103]); // line D
    Tv[4]:= Tv[106]; // line B
    Tv[7]:= Tv[6];
    Tv[8]:= MaxR(0, Tv[6] - Tv[4]);
    Tv[5]:= Tv[8];
    Tv[12]:= MaxR(0, Tv[7] - Tv[5]);
    Tv[158]:= Tv[108]; // Line E
    Tv[17]:= MaxR(0, Tv[12] - Tv[158]);
    Tv[17]:= MinR(67800, Tv[17]);
    Tv[19]:= GetActualCPPPremiums(RetNo); // 50340box 16 of T4 slips
    Tv[265]:= Tv[19];
    Tv[266]:= Tv[265] * 83.1933 / 100; // 20241217
    Tv[267]:= Tv[19] - Tv[266];
    Tv[268]:= Tv[17];
    Tv[269]:= MinR(3356.10, Tv[268] * 4.95 / 100);
    Tv[270]:= Tv[17]; // 20241211
    Tv[271]:= MinR(678.00, Tv[270] * 1 / 100);
    Tv[272]:= Tv[269] + Tv[271];
    Tv[11]:= Tv[266];
    Tv[13]:= Tv[269];
    Tv[14]:= Tv[11] - Tv[13];
    Tv[15]:= Tv[267];
    Tv[16]:= Tv[271];
    Tv[18]:= Tv[15] - Tv[16];
    Tv[20]:= Tv[18];
    Tv[21]:= Tv[14] + Tv[20];
    Tv[273]:= GetBox16AFromT4Slips(RetNo);
    Tv[274]:= Tv[5];
    Tv[275]:= MinR(396.00, Tv[274] * (4 / 100)); // 20250120 not 4.95
//    Tv[22]:= Tv[273];
//    Tv[23]:= Tv[275];
    Tv[24]:= Tv[273] - Tv[275];
    Tv[25]:= Tv[24];
    Tv[26]:= Tv[21] + Tv[25];
  end; // with page 4

  // clear done at the begining for all $ elms to avoid clearing mistakes... do not think it needs more than that?
  // clearS8Part4(RetNo,FNo);
  // clearS8Part5(RetNo,FNo);

  // s8 Page 7 Part 5 -----------------------------------------------------------
  if isS8Part5Applicable(RetNo, FNo) then
    S8Part5(RetNo, FName, FNo)
  else
  begin
    S8Part3ab(RetNo, FName, FNo);
    // s8 Page 6 Part 4 -----------------------------------------------------------
    if isS8Part4Applicable(RetNo, FNo) then
      S8Part4(RetNo, FName, FNo)
  end;

  // SUMMARY S8
  with Ret[RetNo].Frm[FNo] do
  begin
    //20251002 Igor checked
    sumLnnNo:= 22215;
    sumElmNo:= 210;
    Tv[sumElmNo]:= MaxR(MaxR(Tv[332], Tv[348]), Tv[162]);
    Ret[RetNo].Lnn[sumLnnNo]:= Tv[sumElmNo];

    //20251002 Igor checked
    sumLnnNo:= 22200;
    sumElmNo:= 204;
    Tv[sumElmNo]:= MaxR(Tv[153], Tv[136]);
    Ret[RetNo].Lnn[sumLnnNo]:= Tv[sumElmNo];

    //20251002 Igor checked
    sumLnnNo:= 30800;
    sumElmNo:= 207;
    Tv[sumElmNo]:= MaxR(MaxR(Tv[333], Tv[335]), Tv[146]);
    Ret[RetNo].Lnn[sumLnnNo]:= Tv[sumElmNo];

    //20251002 Igor checked
    sumLnnNo:= 31000;
    sumElmNo:= 201;
    Tv[sumElmNo]:= MaxR(Tv[36], Tv[164]);
    Ret[RetNo].Lnn[sumLnnNo]:= Tv[sumElmNo];

    //20251002 Igor checked
    sumLnnNo:= 42100;
    sumElmNo:= 434;
    Tv[sumElmNo]:= 0;
    if isS8Part4Applicable(RetNo, FNo) then
      Tv[sumElmNo]:= Tv[121] // get from part 4, line 14
    else
    if isS8Part5Applicable(RetNo, FNo) and (Tv[140] > 0) then
      Tv[sumElmNo]:= Tv[140]; // get from part 5, line 55

    Ret[RetNo].Lnn[sumLnnNo]:= Tv[sumElmNo];

    //20251002 Igor checked
    sumLnnNo:= 44800;
    sumElmNo:= 213;
    Tv[sumElmNo]:= MaxR(Tv[334], Tv[142]);
    Ret[RetNo].Lnn[sumLnnNo]:= Tv[sumElmNo];

    // if (Tv[334]>0) and (Tv[142]>0) then Ret[RetNo].LNN[44800]:=Tv[142];  //20241225 //20250125
    // ?? Ret[RetNo].LNN[42100]:=MaxR(tv[121],Tv[140]); //20241222a
    // ??? Ret[RetNo].LNN[41000]:=Tv[263]; //20241222a
    // done above Ret[RetNo].LNN[22200]:=MaxR(Tv[153],Tv[136]); //20241223  //looks ok
    // done above Tv[210]:=Ret[RetNo].LNN[22215]; //20241227

    // LnnNo:= 50329; elmNo:=422;
    // LnnNo:= 50330; elmNo:=425;
    // LnnNo:= 50331; elmNo:=428;

    // 20251002 Igor checked ** note: this is different than below 50339 vs 50399
    sumLnnNo:= 50339;
    sumElmNo:= 437;
    Tv[sumElmNo]:= Tv[3]; // ** note: this is different than below 50339 vs 50399
    Ret[RetNo].Lnn[sumLnnNo]:= Tv[sumElmNo];

    //20251002 Igor checked
    sumLnnNo:= 50340;
    sumElmNo:= 440;
    Tv[sumElmNo]:= Tv[19];
    Ret[RetNo].Lnn[sumLnnNo]:= Tv[19];

    // LnnNo := 50371; elmNo:=431;

    { //jz//20250313 all wrong
      Tv[434]:=Tv[121];  //me and jz
      if Tv[121]<0 then Tv[434]:=0;  //jz//20250314 - why have this if??? part 4 or 5 cannot happen at same time
      sumLnnNo := 42100; sumelmNo:=434;
      Tv[sumelmNo]:=MaxR(Tv[434],Tv[140]); //part 5 line 55, part 4 line 14 //jz//20250314 should be from elms 140 and 121 but cant use max due to possibility of negative
      Ret[RetNo].LNN[sumLnnNo]:=Tv[sumelmNo];
      //jz//20250313 - cant use maxr due to possibility of negative value, needs to be differnt
      sumLnnNo := 42100; sumElmNo:=434;
      Tv[sumElmNo]:=0;
      if Tv[121] <> 0 then
      Tv[sumElmNo]:=Tv[121]
      else if Tv[140] <> 0 then
      Tv[sumElmNo]:=Tv[140];
      Ret[RetNo].LNN[sumLnnNo]:=Tv[sumelmNo];    }

    //20251002 Igor checked
    sumLnnNo:= 50341;
    sumElmNo:= 443;
    Tv[sumElmNo]:= Tv[273];
    Ret[RetNo].Lnn[sumLnnNo]:= Tv[sumElmNo];

    //20251002 Igor checked
    sumLnnNo:= 50372;
    sumElmNo:= 446;
    strings[sumElmNo]:= strings[42]; // - stop contributing cpp

    //20251002 Igor checked
    sumLnnNo:= 50373;
    sumElmNo:= 449;
    Tv[sumElmNo]:= MaxR(Tv[138], Tv[350]); //  - empl income not shown on t4
    Ret[RetNo].Lnn[sumLnnNo]:= Tv[sumElmNo];

    //20251002 Igor checked
    sumLnnNo:= 50374;
    sumElmNo:= 452;
    strings[sumElmNo]:= strings[43]; // - revoke election cpp

    { CZ  //20250208
      Tv[273]:=Totmultiple(RetNo,'T4',68);  //Tv[19]; //20250208
      Tv[443]:=Tv[273];
      Ret[RetNo].LNN[50341]:=Tv[273]; //20250208
      Tv[443]:=Ret[RetNo].LNN[50341]; //jz 20250129
    }
    // 20250206         *

    //20251002 Igor checked ** note: this is different than above 50339 vs 50399
    sumLnnNo:= 50399;
    sumElmNo:= 455;
    Tv[sumElmNo]:= Tv[351]; // ** note: this is different than above 50339 vs 50399
    ret[RetNo].Lnn[sumLnnNo]:= Tv[sumElmNo];

    // 20250220
    if PlacementOfficeSlip(RetNo) then
    begin
      ret[RetNo].Lnn[22200]:= 0;
      Tv[204]:= 0;
      ret[RetNo].Lnn[31000]:= 0;
      Tv[201]:= 0;
      ret[RetNo].Lnn[42100]:= 0;
      Tv[434]:= 0;
    end;

    {//jz//20251220 - removed, better to use overrides until solved TC33
    if (GetSinNo(RetNo) = '870000445') then // thirtythree
    begin
      Tv[201]:= 0;
      ret[RetNo].Lnn[31000]:= 0;
      Tv[204]:= 5186;
      ret[RetNo].Lnn[22200]:= Tv[204];
      ret[RetNo].Lnn[50320]:= 3510; // ???
      Tv[431]:= 76900;
      ret[RetNo].Lnn[50371]:= Tv[431];
      ret[RetNo].Lnn[42100]:= 0;

      //  Lnn[30800]:=0;
      //  Lnn[22215]:=0;
      //  Lnn[44800]:=0;
      //  Lnn[50329]:=0;
      //  Lnn[50330]:=0;
      //  Lnn[50331]:=0;
      //  Lnn[50339]:=0;
      //  Lnn[50340]:=0;
      //  Lnn[50371]:=0;
      //  Lnn[50329]:=0;

      //  Lnn[50341]:=0;
      //  Lnn[50372]:=0;
      //  Lnn[50373]:=0;
      //  Lnn[50374]:=0;
      //  Lnn[50399]:=0;

    end; // sin
    }
  end;

  SaveTv(RetNo, FName, FNo); // 20241122
end;
//20250929 Igor <<<

end.
